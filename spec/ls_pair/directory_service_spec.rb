require 'ls_pair/directory_service'

describe LsPair::DirectoryService do
  let(:command_line) { stub('LsPair::CommandLine') }
  let(:subject) { LsPair::DirectoryService.new(:command_line => command_line) }
  let(:users_and_ids) { File.read(File.join(File.dirname(__FILE__), 'users_and_ids.txt')) }

  it 'tells us that a user account exists' do
    command_line.should_receive(:run).with('dscl . -list /Users UniqueID') \
      .and_return(users_and_ids)
    subject.user_exists?('foo').should == true
    subject.user_exists?('nonesuchuser').should == false
  end

  it 'creates a user with the specified username' do
    # Highest user ID in file read below is 511
    command_line.should_receive(:run).with('dscl . -list /Users UniqueID') \
      .and_return(users_and_ids)
    command_line.should_receive(:run).with('dscl . -create /Users/bob').ordered
    command_line.should_receive(:run).with('dscl . -create /Users/bob RealName "bob Pair Account"').ordered
    command_line.should_receive(:run).with('dscl . -create /Users/bob UserShell /bin/bash').ordered
    command_line.should_receive(:run).with('dscl . -create /Users/bob NFSHomeDirectory /Users/bob').ordered
    command_line.should_receive(:run).with('dscl . -create /Users/bob UniqueID 512').ordered
    command_line.should_receive(:run).with('dscl . -create /Users/bob PrimaryGroupID 20').ordered
    subject.create_user('bob')
  end
end
