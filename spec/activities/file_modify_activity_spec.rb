require "edr_treadmill/activities/file_modify_activity"
require "tempfile"

RSpec.describe EdrTreadmill::Activities::FileModifyActivity do
  let(:filename) { "#{Tempfile.new.path}.txt" }
  let(:append_path) { "spec/fixtures/file_modify_content.txt" }
  let(:append_contents) { File.read(append_path) }
  let(:existing_content) do
    "Should you or any of your IM Force be caught or killed"
  end

  before { File.write(filename, existing_content) }
  after { File.unlink(filename) }

  subject do
    EdrTreadmill::Activities::FileModifyActivity
      .new(filename: filename, source: append_path)
      .execute
  end

  its([:timestamp]) { is_expected.to be_a(Time) }
  its([:path]) { is_expected.to eq(filename) }
  its([:activity]) { is_expected.to eq("modify") }
  its([:user]) { is_expected.to eq(ENV["USER"])}
  its([:process_name]) { is_expected.to match(/rspec$/) }
  its([:command_line]) { is_expected.to match(/rspec/) }
  its([:pid]) { is_expected.to be_an(Integer) }

  it "appends contents of content file to destination file" do
    copied_contents = File.read(subject[:path])
    expect(copied_contents).to eq(existing_content + append_contents)
  end
end
