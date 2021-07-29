require "edr_treadmill/activities/base_activity"

module EdrTreadmill
  module Activities
    class FileModifyActivity < BaseActivity
      self.activity_description = "Modify a file by appending the contents of "\
        "a second file"
      self.activity_options = {
        filename: {
          required: true,
          type: :string,
          desc: "Path to the file that will be modified"
        },
        source: {
          required: true,
          type: :string,
          desc: "Path to a source file to be appended to FILENAME"
        }
      }

      def initialize(filename:, source:)
        @filename = filename
        @source = source
      end

      def execute
        append_content
        result(
          path: @filename,
          activity: "modify"
        )
      end

      private

        def content
          File.read(@source)
        end

        def append_content
          # TODO add an option to handle binary files. This is text-only.
          File.open(@filename, "a") do |file|
            file.write(content)
          end
        end
    end
  end
end
