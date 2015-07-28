class McasResult < ActiveRecord::Base
  include DateToSchoolYear
  include AssignToSchoolYear
  belongs_to :student
  belongs_to :school_year
  before_save :assign_to_school_year

  def risk_level
    if math_performance.present? || ela_performance.present?
      if math_performance == "W" || ela_performance == "W" ||
         math_performance == "F" || ela_performance == "F"
        3
      elsif math_performance == "NI" || ela_performance == "NI"
        2
      elsif math_performance == "P" || ela_performance == "P"
        1
     elsif math_performance == "A" || ela_performance == "A"
        0
      end
    end
  end

  def performance_warning_level
    ["W"]
  end

  def growth_warning_level
    40
  end

  # Warning flags for variables in roster view
  def math_performance_warning?
    if math_performance.present?
      performance_warning_level.include? math_performance
    end
  end

  def ela_performance_warning?
    if ela_performance.present?
      performance_warning_level.include? ela_performance
    end
  end

  def math_growth_warning?
    if math_growth.present?
      math_growth < growth_warning_level
    end
  end

  def ela_growth_warning?
    if ela_growth.present?
      ela_growth < growth_warning_level
    end
  end
end
