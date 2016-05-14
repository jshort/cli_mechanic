
module OptionHandler
  def self.handle_option(parser, mechanic, option, cli_options)
    if option['name'] == 'help'
      parser.on(*create_parser_args(option, mechanic)) do
        puts parser
        exit 0
      end
    elsif option['name'] == 'version'
      parser.on(*create_parser_args(option, mechanic)) do
        puts "#{mechanic.bin} version #{mechanic.version}"
        exit 0
      end
    else
      parser.on(*create_parser_args(option, mechanic)) do |val|
        cli_options[option['name']] = val
      end
    end
  end

  def self.create_parser_args(option, mechanic)
    [
      option['short'],
      option['long'],
      option['message'].gsub('{{BIN}}', mechanic.bin)
    ]
  end
end