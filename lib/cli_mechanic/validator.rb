
module ConfigValidator
  def self.validate(hash)
    if !hash['cli']
      validation_error 'Root yaml element must been \'cli\'.'
    end

    main_config = hash['cli']

    description = main_config['description']
    if description && !(description.is_a?(String) ||
                        description.is_a?(Array))
      validation_error '\'description\' should be a string or array of strings.'
    end

    if ![nil, true, false].include?(main_config['debug'])
      validation_error '\'debug\' should be a boolean value.'
    end

    options = main_config['options'] || []
    options.each do |option|
      validation_error 'Option must have name.' unless option['name']
      short = option['short']
      long = option['long']
      if !(short || long)
        validation_error "Option '#{option['name']}' must have " \
                         " either long or short flag specified."
      end
      if option['arg']
        option['arg']['name'] = 'ARG' unless option['arg']['name']
        if ![nil, true, false].include?(option['arg']['required'])
          validation_error 'argument \'required\' should be a boolean value.'
        end
      end
    end
    arguments = main_config['arguments'] || []
    arguments.each do |arg|
      validation_error 'Argument must have name.' unless arg['name']

      if !['single', 'multiple'].include?(arg['type'])
        validation_error 'Argument \'type\' should be \'single\' or \'multiple\''
      end

      if arg['type'] == 'multiple' && arg['required'] != false
        validation_error 'Argument cannot be both required and multiple, ' \
                         'please specify mutiple single required arguments.'
      end
    end
  end

  def self.validation_error(msg)
    puts 'Config validation error:'
    puts msg
    exit 7
  end
end