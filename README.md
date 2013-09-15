# Rails Girls Berlin Installation Script

This script can be used on Linux and OS X to install Ruby, Rails and some other dependencies like git or imagemagick. Open a terminal and copy-paste this line.

```sh
bash < <(curl -L -s https://raw.github.com/plexus/rails_girls_berlin_installer/master/rails_girls_berlin_installer.sh)
```

Feedback is highly appreciated.

Most of the heavy lifting is done by RVM. If Chruby or Rbenv is detected, the script will exit with a warning. You can force it to continue by setting the environment variable `RVM_PLEASE=yes`. RVM autolibs feature is used to install dependencies, although depending on the platform a number of dependencies are already installed beforehand.

For OS X this script leans on the [XCode Command Line Tools installation script](https://github.com/hagzag/xcode-cli-install) by [hagzag](https://github.com/hagzag), which unfortunately only supports OS X 10.8 and 10.7. Hopefully we can add support for older versions in the near future.


## License

Copyright (c) 2013 Arne Brasseur

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
