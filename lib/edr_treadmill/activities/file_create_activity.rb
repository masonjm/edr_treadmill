require "edr_treadmill/activities/base_activity"
require "fileutils"

module EdrTreadmill
  module Activities
    class FileCreateActivity < BaseActivity
      self.activity_description = "Create a new file by copying an existing file"
      self.activity_options = {
        filename: {
          required: true,
          type: :string,
          desc: "Path to the file that will be created"
        },
        source: {
          required: true,
          type: :string,
          desc: "Path to the source file to be copied to FILENAME"
        }
      }

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
