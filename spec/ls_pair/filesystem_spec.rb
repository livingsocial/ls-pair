require 'ls_pair/filesystem'

describe LsPair::Filesystem do
  it 'reads the specified file' do
    expected = File.read(__FILE__)
    subject.read_file(__FILE__).should == expected
  end

  it 'raises if the specified file cannot be read' do
    bad_read = lambda {
      subject.read_file('if_this_file_exists_then_somebody_is_fired.docx')
    }
    expect(bad_read).to raise_error(LsPair::Filesystem::FileNotFound)
  end

  it 'creates a file with the specified content' do
    content = "Hello, world: #{`uuidgen`}"
    path = '/tmp/ls_pair_spec/foo/bar/yak/filesystem_test_write_ls_pair.txt'
    subject.create_file(path, content)
    File.read(path).should == content

    FileUtils.rm_rf '/tmp/ls_pair_spec'
  end

  it 'lists the file/directory names that appear under the specified path' do
    expected = Dir.entries(File.dirname(__FILE__))
    subject.entries(File.dirname(__FILE__)).should == expected
  end
end
