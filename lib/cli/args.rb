require "ostruct"

module CLI
  class Args
    attr_reader :flags, :options, :args, :arguments

    def initialize(flags: {}, options: {}, arguments: 0)
      @flags = flags
      @options = options
      @arguments = arguments
      @args = {}
    end

    def parse(args)
      @args[:arguments] = ARGV.pop(arguments)
      while (part = args.shift)
        if flag = locate_command(part, @flags)
          @args[flag] = true
        end

        if option = locate_command(part, @options)
          @args[option] = ARGV.shift
          raise "'#{@args[option]}' is not a valid value for #{part}" if (flags.keys + options.values).flatten.include?(@args[option])
        end

        raise "invalid option #{part}" unless option || flag
      end
      @args = OpenStruct.new(@args)
    end

    private

    def locate_command(part, spec)
      spec.detect { |k, v| k.include?(part) }&.last
    end
  end
end
