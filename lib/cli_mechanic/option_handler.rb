
module OptionHandler
  def self.handle_option(parser, mechanic, option, cli_options)
    opt = Option.new(option, mechanic.bin)

    if opt.name == 'help'
      parser.on_tail(*opt.parser_args) do
        puts parser
        exit 0
      end
    elsif opt.name == 'version'
      parser.on_tail(*opt.parser_args) do
        puts "#{mechanic.bin} version #{mechanic.version}"
        exit 0
      end
    else
      parser.on(*opt.parser_args) do |val|
        cli_options[opt.name] = !val.nil? ? val : true
      end
    end
  end

  class Option
    attr_reader :name, :short, :long, :type, :message, :opt_arg, :bin

    def initialize(option_hash, bin)
      @name = option_hash['name']
      @short = option_hash['short']
      @long = option_hash['long']
      @type = option_hash['type']
      @message = option_hash['message']
      @opt_arg = option_hash['arg']
      @bin = bin
    end

    def parser_args
      args = []
      args << short if short
      if opt_arg
        if arg_required?
          args << "#{long}=#{opt_arg['name']}"
        else
          args << "#{long} [=#{opt_arg['name']}]"
        end
      else
        args << long if long
      end
      args << message.gsub('{{BIN}}', bin) if message
      args
    end

    def has_arg?
      opt_arg
    end

    def arg_required?
      # not specified defaults to required argument
      has_arg? && (opt_arg['required'].nil? || opt_arg['required'])
    end
  end
  private_constant :Option
end