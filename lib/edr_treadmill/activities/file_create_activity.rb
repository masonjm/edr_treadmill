require "edr_treadmill/activities/base_activity"
require "fileutils"

module EdrTreadmill
  module Activities
    class FileCreateActivity < BaseActivity
      def initialize(filename:, source:)
        @filename = filename
        @source = source
      end

      def execute
        FileUtils.cp(@source, @filename)
        result(
          path: @filename,
          activity: "create"
        )
      end
    end
  end
end
