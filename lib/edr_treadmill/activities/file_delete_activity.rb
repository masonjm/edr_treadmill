require "edr_treadmill/activities/base_activity"
require "fileutils"

module EdrTreadmill
  module Activities
    class FileDeleteActivity < BaseActivity
      self.activity_description = "Delete a file"
      self.activity_options = {
        filename: {
          required: true,
          type: :string,
          desc: "Path to the file that will be deleted"
        }
      }

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
