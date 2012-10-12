require 'ls_pair/local_user'

describe LsPair::LocalUser do
  let(:directory_service) { stub('LsPair::DirectoryService', :user_exists? => true) }
  let(:filesystem) {
    stub('LsPair::Filesystem', :mkdir_p => nil, :create_file => nil, :chmod => nil,
         :chown_R => nil)
  }
  let(:ssh_keys) { stub('LsPair::SshKeys', :read => 'blahblah') }
  let(:subject) {
    LsPair::LocalUser.new('bob',
                          :directory_service => directory_service,
                          :filesystem => filesystem,
                          :ssh_keys => ssh_keys)
  }

  context 'Provisioning a user' do
    it 'checks to see if the user exists on the system' do
      directory_service.stub!(:create_user)
      directory_service.should_receive(:user_exists?).with('bob')
      subject.provision
    end

    context 'when the user does not yet exist' do
      before(:each) do
        directory_service.stub!(:user_exists? => false)
      end

      it 'creates the user in the directory' do
        directory_service.should_receive(:create_user).with('bob')
        subject.provision
      end
    end

    context 'when the user already exists' do
      before(:each) do
        directory_service.stub!(:user_exists? => true)
      end

      it 'does not create the user in the directory' do
        directory_service.should_receive(:create_user).never
        subject.provision
      end
    end

    context 'when there is no public key for the named user' do
      before(:each) do
        directory_service.stub!(:user_exists? => false)
        ssh_keys.stub!(:read).and_raise(LsPair::SshKeys::NoPublicKeyForUser.new("sorry, bub, no can do"))
        subject.stub!(:puts)
      end

      it 'prints out a polite error message' do
        subject.should_receive(:puts).with(/sorry, bub/)
        subject.provision
      end

      it 'prints out a polite error message, and does not create the user in the directory' do
        directory_service.should_receive(:create_user).never
        subject.provision
      end
    end

    it 'sets up the home directory with ssh configuration' do
      ssh_keys.stub(:read).with('bob').and_return('mykeyabc123')

      filesystem.should_receive(:create_file).with('/Users/bob/.ssh/authorized_keys', 'mykeyabc123').ordered
      filesystem.should_receive(:chmod).with(0600, '/Users/bob/.ssh/authorized_keys').ordered
      filesystem.should_receive(:chmod).with(0700, '/Users/bob/.ssh').ordered
      filesystem.should_receive(:chmod).with(0755, '/Users/bob').ordered
      filesystem.should_receive(:chown_R).with('bob', 'staff', '/Users/bob').ordered

      subject.provision
    end
  end
end
