require 'cli_mechanic/option_handler'
require 'cli_mechanic/validator'
require 'optparse'
require 'yaml'

class Mechanic

  DEFAULT_HELP_WIDTH = 80
  DEFAULT_VERSION = '0.0.1'
  USAGE_PREFIX = 'Usage: {{BIN}}'
  FIXNUM_MAX = 2**(0.size * 8 - 2) - 1

  def initialize(config)
    @bin_name = $PROGRAM_NAME.split('/').last
    @config = config
    @version = DEFAULT_VERSION
  end

  def self.bootstrap(config_file, argv, version = nil, default_opts = {})
    options = default_opts

    @@mechanic ||= new(load_yaml(config_file))
    @@mechanic.set_version(@@mechanic.conf['version'], version)

    # validate yaml
    @@mechanic.validate(config_file)

    # parse config and create options
    puts @@mechanic.conf if @@mechanic.debug?

    op = OptionParser.new do |x|
      x.banner = @@mechanic.usage

      x.separator ''
      x.separator @@mechanic.description
      x.separator ''
      x.separator 'Options:'

      @@mechanic.conf['options'].each do |opt|
        OptionHandler.handle_option(x, @@mechanic, opt, options)
      end
    end

    begin
      op.parse!(ARGV)
      @@mechanic.validate_args(ARGV)
    rescue OptionParser::InvalidOption,
           OptionParser::MissingArgument,
           OptionParser::NeedlessArgument,
           OptionParser::AmbiguousOption
      puts "###############  #{$!.to_s}  ###############"
      puts ""
      puts op
      exit 1
    end

    options
  end

  def self.validate(config_file)
    puts new(load_yaml(config_file)).validate
  end

  def self.load_yaml(file)
    if !File.exist?(file)
      puts "Yaml file: #{file} does not exist."
      exit 8
    end

    begin
      yaml = YAML.load_file(file)
    rescue Psych::SyntaxError => e
      puts "Invalid YAML: #{e.message}"
      exit 9
    end
    yaml
  end

  # The following instance methods are for all intents and purposes
  # private since ::new is private and only our class methods can
  # instantiate an instance of the class and call said methods.
  def conf
    @config['cli']
  end

  def bin
    @bin_name
  end

  def options
    conf['options']
  end

  def arguments
    conf['arguments']
  end

  def validate(config_file = nil)
    unless @config
      @config = load_yaml(config_file)
    end
    ConfigValidator.validate(@config)
    'Config is Valid!'
  end

  def set_version(config_version, arg_version)
    if config_version
      @version = config_version
    elsif arg_version
      @version = arg_version
    end
  end

  def version
    @version
  end

  def debug?
    conf['debug']
  end

  def description
    desc = []
    conf['description'].each do |line|
      line.gsub!('{{BIN}}', bin)
      desc << line and next if line.length <= DEFAULT_HELP_WIDTH
      parts = line.scan(/\S.{0,#{DEFAULT_HELP_WIDTH}}\S(?=\s|$)|\S+/)
      desc << parts
    end
    desc.flatten
  end

  def usage
    usage_msg = USAGE_PREFIX
    usage_msg.gsub!('{{BIN}}', @bin_name)
    if options
      usage_msg << ' [options]'
    end
    if arguments
      usage_msg << "#{arg_usage}"
    end
  end

  def arg_usage
    arg_str = ''
    arguments.each do |arg|
      cur_arg = ''
      if arg['required'] == false
        cur_arg = " [#{arg['name']}{{MULTI}}]"
      else
        cur_arg = " #{arg['name']}{{MULTI}}"
      end

      if arg['type'] == 'single'
        cur_arg.gsub!('{{MULTI}}', '')
      else
        cur_arg.gsub!('{{MULTI}}', '...')
      end
      arg_str << cur_arg
    end
    arg_str
  end

  def validate_args(argv)
    min, max = 0, 0
    arguments.each do |arg|
      if arg['required'] == false && arg['type'] == 'single'
        max += 1
      elsif arg['required'] == false && arg['type'] == 'multiple'
        max = FIXNUM_MAX
      elsif arg['required'] != false && arg['type'] == 'single'
        min += 1
        max += 1
      end
    end

    if argv.size < min
      raise OptionParser::MissingArgument
    end

    if argv.size > max
      raise OptionParser::NeedlessArgument
    end
  end

  # new is private hence only our ::bootstrap method can
  private_class_method :new, :load_yaml
end
