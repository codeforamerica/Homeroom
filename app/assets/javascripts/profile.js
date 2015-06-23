$(function() {

  if ($('body').hasClass('students') && $('body').hasClass('show')) {

    var profile_data = $("#profile-data")
    var attendance_events = profile_data.data('attendance-events')
    var discipline_incidents = profile_data.data('discipline-incidents')
    var mcas_results = profile_data.data('mcas-results')
    var star_results = profile_data.data('star-results')
    var student_name = $("#student-name").text()

    function prepareEventsForChart(events, prepare_function) {
      return schoolYears(events).map(function(key) { return prepare_function(events[key]) })
    }

    function prepareScoresForChart(scores, prepare_function) {
      return scores.map(function(score) {
        var date_array = score.date_taken.split("-").map(function(a) { return parseInt(a) })
        var date_utc = Date.UTC.apply(this || window, date_array)
        return [date_utc, prepare_function(score)]
      })
    }

    function checkZero(options) {
      return options.series.every(function(element) {
        return element.data.every(function(el) {
          return el == 0
        });
      });
    }

    // Functions for adding absences, tardies, and behavior issues to chart
    function isAbsence (event) { return event.absence }
    function isTardy (event) { return event.tardy }
    function countAbsences (attendanceEvents) { return attendanceEvents.filter(isAbsence).length }
    function countTardies (attendanceEvents) { return attendanceEvents.filter(isTardy).length }
    function countSize (events) { return events.length }

    // Functions for adding assessments to chart
    function getStarMathPercentile (result) { return result.math_percentile_rank }
    function getStarReadingPercentile (result) { return result.reading_percentile_rank }
    function getMcasMathScaled (result) { return result.math_scaled }
    function getMcasEnglishScaled (result) { return result.ela_scaled }
    function getMcasMathGrowth (result) { return result.math_growth }
    function getMcasEnglishGrowth (result) { return result.ela_growth }

    function schoolYears(events) { return Object.keys(events).reverse() }

    // Attendance events, behavior shown as aggregated counts by school year
    var attendance_series = [{
        name: 'Absences',
        data: prepareEventsForChart(attendance_events, countAbsences)
      }, {
        name: 'Tardies',
        data: prepareEventsForChart(attendance_events, countTardies)
      }
    ]

    var behavior_series = [{
      name: 'Behavior incidents',
      data: prepareEventsForChart(discipline_incidents, countSize)
    }]

    // STAR and MCAS results shown by date taken, not aggregated by school year
    // http://www.highcharts.com/demo/spline-irregular-time
    var star_series = [{
        name: 'Math percentile rank',
        data: prepareScoresForChart(star_results, getStarMathPercentile)
      }, {
        name: 'Reading percentile rank',
        data: prepareScoresForChart(star_results, getStarReadingPercentile)
      }
    ]

    var mcas_scaled_series = [{
      name: 'Math scaled score',
      data: prepareScoresForChart(mcas_results, getMcasMathScaled)
        }, {
      name: 'English scaled score',
      data: prepareScoresForChart(mcas_results, getMcasEnglishScaled)
    }]

    var mcas_growth_series = [{
      name: 'Math growth score',
      data: prepareScoresForChart(mcas_results, getMcasMathGrowth)
        }, {
      name: 'English growth score',
      data: prepareScoresForChart(mcas_results, getMcasEnglishGrowth)
    }]

    var options = {
      chart: {
        renderTo: 'chart',
        type: 'areaspline'
      },
      title: {
        text: '',
        style: {
          display: 'none'
        }
      },
      subtitle: {
        text: '',
        style: {
          display: 'none'
        }
      },
      legend: {
        layout: 'horizontal',
        align: 'right',
        verticalAlign: 'top',
        itemStyle: {
          font: '12px "Open Sans", sans-serif !important;',
          color: '#555555'
        }
      },
      xAxis: {
        categories: [],
        dateTimeLabelFormats: {}
      },
      tooltip: {
        shared: true
      },
      credits: {
        enabled: false
      },
      plotOptions: {
        areaspline: {
          fillOpacity: 0
        }
      }
    }

    var x_axis_datetime = {
      type: 'datetime',
      dateTimeLabelFormats: {
          day: '%e of %b'
      }
    }

    var x_axis_schoolyears = {
      type: 'linear',
      categories: [],
      dateTimeLabelFormats: {}
    }

    function zeroDraw(){
      $('#chart').empty();
      var zeroHtml =  '<div class="zero-case">' +
                      '<img src="/assets/placeholder.svg"/>' +
                      '<h2>Looks Great!</h2>' +
                      '<div>'+ student_name + ' has no ' +
                              options.title.text + ' on record</div>' +
                      '</div>';
      $('#chart').html(zeroHtml);
    }

    var default_yaxis = {
      allowDecimals: false,
      title: {
        text: '',
        style: {
          display: 'none'
        }
      },
      plotLines: [],
      min: undefined,
      max: undefined
    }

    var percentile_yaxis = $.extend({}, default_yaxis)
    percentile_yaxis.min = 0
    percentile_yaxis.max = 100

    var mcas_growth_plotline = {
      color: '#B90504',
      width: 1,
      zIndex: 3,
      value: 40,
      label: {
        text: 'MCAS Growth warning: Less than 40 points',
        align: 'center',
        style: {
          color: '#999999'
        }
      }
    }

    var star_plotline = {
      color: '#B90504',
      width: 1,
      zIndex: 3,
      value: 40,
      label: {
        text: 'STAR Percentile warning: Less than 40 points',
        align: 'center',
        style: {
          color: '#999999'
        }
      }
    }

    // Default view is attendance series
    options.series = attendance_series
    options.yAxis = default_yaxis
    options.xAxis.categories = schoolYears(attendance_events)

    options.title.text = 'absences or tardies'
    var chart
    checkZero(options) ? zeroDraw() : chart = new Highcharts.Chart(options)

	  $("#chart-type").on('change', function(){
	    var selVal = $("#chart-type").val();
	    if (selVal == "attendance" || selVal == '') {
	        options.series = attendance_series
          options.title.text = 'absences or tardies'
          options.xAxis = x_axis_schoolyears
          options.xAxis.categories = schoolYears(attendance_events)
          options.yAxis = default_yaxis
      } else if (selVal == "behavior") {
          options.series = behavior_series
          options.title.text = 'behavior incidents'
          options.xAxis = x_axis_schoolyears
          options.xAxis.categories = schoolYears(discipline_incidents)
          options.yAxis = default_yaxis
      } else if (selVal == "mcas-growth") {
          options.series = mcas_growth_series
          options.title.text = 'MCAS Growth'
          options.xAxis = x_axis_datetime
          options.yAxis = percentile_yaxis
          options.yAxis.plotLines = []
          options.yAxis.plotLines.push(mcas_growth_plotline)
      } else if (selVal == "mcas-scaled") {
          options.series = mcas_scaled_series
          options.title.text = 'MCAS Scaled'
          options.xAxis = x_axis_datetime
          options.yAxis = default_yaxis
      } else if (selVal == "star") {
          options.series = star_series
          options.xAxis = x_axis_datetime
          options.yAxis = percentile_yaxis
          options.yAxis.plotLines = []
          options.yAxis.plotLines.push(star_plotline)
	    }
      checkZero(options) ? zeroDraw() : chart = new Highcharts.Chart(options)
	});
  }
});
