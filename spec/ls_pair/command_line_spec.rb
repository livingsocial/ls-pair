require 'ls_pair/command_line'

describe LsPair::CommandLine do
  it 'runs the specified command and returns the output' do
    expected = `ls -al`
    subject.run('ls -al').should == expected
  end
end
