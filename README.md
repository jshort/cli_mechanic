# CliMechanic

Ruby gem for scaffolding a robust and consumable ruby cli tool.

## Usage

See [cli_config.yml](config/cli_config.yml) for example and documentation for the yaml configuration that is consume by the `cli_mechanic` gem.  This file defines all of your options, arguments and metadata regarding your cli tool.

To utilize this config, simple define an executable ruby script and run the file through the `cli_mechanic` bootstrapper:

    require 'cli_mechanic'

    options = {
      'filename' => 'default_filename',
      'verbose' => false,
      'do_something' => false
    }

    Mechanic.bootstrap('config/cli_config.yml', ARGV, '0.0.1', options)

Currently `cli_mechanic` only supports boolean and single valued options.  List support, posix-style boolean short flag support, and argument handling coming soon.

## Installation

Add this line to your application's Gemfile:

    gem 'cli_mechanic'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cli_mechanic

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2014 jshort

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

