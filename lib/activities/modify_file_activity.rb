require "activities/base_file_activity"

module EdrTreadmill
  module Activities
    class ModifyFileActivity < BaseFileActivity
      def initialize(filename:, content_path:)
        @filename = filename
        @content_path = content_path
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
          File.read(@content_path)
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
