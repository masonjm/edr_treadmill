require "edr_treadmill/version"

module EdrTreadmill
end

# require all of the activity implementations
Dir[File.dirname(__FILE__) + "/edr_treadmill/activities/*.rb"].each do |file|
  require file
end
