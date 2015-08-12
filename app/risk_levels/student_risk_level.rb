class StudentRiskLevel

  attr_accessor :level

  def initialize(options = {})
    @student = options[:student]
    @assessments = @student.assessments
    @latest_mcas = options[:latest_mcas] || @assessments.mcas.last_or_missing
    @latest_star = options[:latest_star] || @assessments.star.last_or_missing
    @level = calculate_level(@latest_mcas, @latest_star)
  end

  def calculate_level(mcas, star)
    # As defined by Somerville Public Schools

    if mcas.risk_level == 3 || star.risk_level == 3 || @student.limited_english_proficiency == "Limited"
      3
    elsif mcas.risk_level == 2 || star.risk_level == 2
      2
    elsif mcas.risk_level == 0 || star.risk_level == 0
      0
    elsif mcas.risk_level.nil? && star.risk_level.nil?
      nil
    else
      1
    end
  end

  def level_in_words
    case @level
    when 0
      " 0"
    when 1
      " 1"
    when 2
      " 2"
    when 3
      " 3"
    when nil
      "N/A"
    end
  end

  def level_for_roster
    @level.nil? ? "N/A" : @level
  end

  def level_abbreviation
    level_in_words == "N/A" ? level_in_words : level_in_words[0]
  end

  def css_class_name
    level_in_words.downcase.gsub("/", "")
    level_in_words.downcase.gsub(" ", "risk-")
  end

  def explanation
    explanations = []
    name = @student.first_name || "This student"

    case @level
    when 3
      if @student.limited_english_proficiency == "Limited"
        explanations << "#{name} is limited English proficient."
      end
      if @latest_mcas.risk_level == 3
        explanations << "#{name}'s MCAS performance level is Warning."
      end
      if @latest_star.risk_level == 3
        explanations << "#{name}'s STAR performance is in the warning range (below 10)."
      end
    when 2
      if @latest_mcas.risk_level == 2
        explanations << "#{name}'s MCAS performance level is Needs Improvement."
      end
      if @latest_star.risk_level == 2
        explanations << "#{name}'s STAR performance is in the 10-30 range."
      end
    when 1
      if @latest_mcas.risk_level == 1
        explanations << "#{name}'s MCAS performance level is Proficient."
      end
      if @latest_star.risk_level == 1
        explanations << "#{name}'s STAR performance is above 30."
      end
    when 0
      if @latest_mcas.risk_level == 0
        explanations << "#{name}'s MCAS performance level is Advanced."
      end
      if @latest_star.risk_level == 0
        explanations << "#{name}'s STAR performance is above 85."
      end
    when nil
      explanations << "There is not enough information to tell."
    end

    explanation = "#{name} is at Risk #{level_in_words} because:<br/><br/>"
    explanation += "<ul>" + explanations.map { |e| "<li>#{e}</li>" }.join + "</ul>"
  end
end
