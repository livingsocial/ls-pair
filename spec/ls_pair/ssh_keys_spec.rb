require 'ls_pair/ssh_keys'

describe LsPair::SshKeys do
  def key_path(username)
    File.join(key_dir, "#{username}.pub")
  end

  def key_dir
    File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public_keys'))
  end

  let(:filesystem) { stub('LsPair::Filesystem') }
  subject { LsPair::SshKeys.new(:filesystem => filesystem) }

  it 'reads the specified key from the filesystem' do
    filesystem.should_receive(:read_file).with(key_path('bob')).and_return('abc123')
    subject.read('bob').should == 'abc123'
  end

  it 'complains if the specified key cannot be read from the filesystem' do
    filesystem.should_receive(:read_file).with(key_path('flemdue')).and_raise(LsPair::Filesystem::FileNotFound)
    expect { subject.read('flemdue') }.to raise_error(LsPair::SshKeys::NoPublicKeyForUser)
  end

  it 'returns a list of usernames for which public key files are present' do
    filesystem.should_receive(:entries).with(key_dir) \
      .and_return(%w(. .. foo bob.pub tom.pub foo.bar.pub))
    subject.usernames.should == %w(bob tom foo.bar)
  end
end
