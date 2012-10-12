module LsPair
  class CommandLine
    def run(command)
      `#{command}`
    end
  end
end
