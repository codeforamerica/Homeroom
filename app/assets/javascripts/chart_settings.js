(function(root) {
  var ChartSettings = {}

  ChartSettings.base_options = {
    chart: {
      renderTo: 'chart',
      type: 'areaspline',
      spacingBottom: 0,
      spacingTop: 0,
      spacingLeft: 0,
      spacingRight: 0
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

  ChartSettings.x_axis_datetime = {
    type: 'datetime',
    dateTimeLabelFormats: {
        day: '%e of %b'
    }
  }

  ChartSettings.x_axis_schoolyears = {
    type: 'linear',
    categories: [],
    dateTimeLabelFormats: {}
  }

  ChartSettings.default_yaxis = {
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

  ChartSettings.percentile_yaxis =  {
    allowDecimals: false,
    title: {
      text: '',
      style: {
        display: 'none'
      }
    },
    plotLines: [],
    min: 0,
    max: 100
  }

  ChartSettings.mcas_growth_plotline = {
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

  ChartSettings.star_plotline = {
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

  root.ChartSettings = ChartSettings

})(window)
