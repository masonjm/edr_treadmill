require "activities/delete_file_activity"
require "tempfile"
require "pathname"

RSpec.describe EdrTreadmill::Activities::DeleteFileActivity do
  let(:filename) { "#{Tempfile.new.path}.txt" }
  let(:existing_content) do
    "This file will self-destruct in five milliseconds. Good luck."
  end

  before { File.write(filename, existing_content) }
  after { File.unlink(filename) if File.exists?(filename) }

  subject do
    EdrTreadmill::Activities::DeleteFileActivity
      .new(filename: filename)
      .execute
  end

  its([:timestamp]) { is_expected.to be_a(Time) }
  its([:path]) { is_expected.to eq(filename) }
  its([:activity]) { is_expected.to eq("delete") }
  its([:user]) { is_expected.to eq(ENV["USER"])}
  its([:process_name]) { is_expected.to match(/rspec$/) }
  its([:command_line]) { is_expected.to match(/rspec/) }
  its([:pid]) { is_expected.to be_an(Integer) }

  it "deletes the file" do
    expect(Pathname.new(subject[:path])).not_to exist
  end
end
