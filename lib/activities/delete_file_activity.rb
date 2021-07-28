require "activities/base_file_activity"
require "fileutils"

module EdrTreadmill
  module Activities
    class DeleteFileActivity < BaseFileActivity
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
