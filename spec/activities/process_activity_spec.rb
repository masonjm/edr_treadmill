require "edr_treadmill/activities/process_activity"

RSpec.describe EdrTreadmill::Activities::ProcessActivity do
  subject do
    EdrTreadmill::Activities::ProcessActivity
      .new(command: "/bin/echo argz")
      .execute
  end

  its([:timestamp]) { is_expected.to be_a(Time) }
  its([:user]) { is_expected.to eq(ENV["USER"])}
  its([:process_name]) { is_expected.to eq("/bin/echo") }
  its([:command_line]) { is_expected.to eq("/bin/echo argz")}
  its([:pid]) { is_expected.to be_an(Integer) }
end
