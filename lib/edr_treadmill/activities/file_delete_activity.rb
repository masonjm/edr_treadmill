require "edr_treadmill/activities/base_activity"
require "fileutils"

module EdrTreadmill
  module Activities
    class FileDeleteActivity < BaseActivity
      def initialize(filename:)
        @filename = filename
      end

      def execute
        FileUtils.rm(@filename)
        result(
          path: @filename,
          activity: "delete"
        )
      end
    end
  end
end
