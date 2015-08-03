require 'optparse'


desc "Import students, attendance, behavior, assessments"
  # rake import => imports for all schools
  # rake import[HEA] => imports for just Healey School
  # rake import[BRN] => imports for just Brown School

# See schools.seeds.rb for Somerville school local_ids

task :import, [:school] => :environment do |task, args|
  # school_arg = {}
  # if args[:school].present?
  #   school = School.where(local_id: args[:school]).first
  #   if school.present?
  #     school_arg = { school: school }
  #   else
  #     raise "School not found"
  #   end
  # end
  options = {}
  OptionParser.new do |opts|
    opts.banner = "Usage: rake import -s school_name"
    opts.on("-s", "--school SCH", String) { |sch| options[:sch] = sch }
  end.parse!
  settings = Settings.for(options[:sch])
  ImportInitializer.import(settings)
end
