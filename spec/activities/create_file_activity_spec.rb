require "activities/create_file_activity"
require "tempfile"

RSpec.describe EdrTreadmill::Activities::CreateFileActivity do
  let(:filename) { "#{Tempfile.new.path}.txt" }
  let(:source_path) { "spec/fixtures/create_file_source.txt" }
  let(:source_contents) { File.read(source_path) }

  after { File.unlink(filename) }

  subject do
    EdrTreadmill::Activities::CreateFileActivity
      .new(filename: filename, source: source_path)
      .execute
  end

  its([:timestamp]) { is_expected.to be_a(Time) }
  its([:path]) { is_expected.to eq(filename) }
  its([:activity]) { is_expected.to eq("create") }
  its([:user]) { is_expected.to eq(ENV["USER"])}
  its([:process_name]) { is_expected.to match(/rspec$/) }
  its([:command_line]) { is_expected.to match(/rspec/) }
  its([:pid]) { is_expected.to be_an(Integer) }

  it "copies contents of source file to destination file" do
    copied_contents = File.read(subject[:path])
    expect(copied_contents).to eq(source_contents)
  end
end
