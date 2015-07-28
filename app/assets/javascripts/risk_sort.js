// Extend TableSort with High, Medium, Low risk levels
(function(){

  function clean_cell(i) {
    return $.trim(i);
  }

  var performance_levels = ["H", "M", "L"];

  compareRiskLevel = function(a, b) {
    var clean_a = clean_cell(a);
    var clean_b = clean_cell(b);
    var a_index = performance_levels.indexOf(clean_a);
    var b_index = performance_levels.indexOf(clean_b);
    return a_index - b_index;
  };

  Tablesort.extend('risk_sort', function(item) {
    cleaned_cell = clean_cell(item);
    performance_levels.indexOf(cleaned_cell) > 0;
  }, function(a, b) {
      return compareRiskLevel(b, a);
  });

}());
