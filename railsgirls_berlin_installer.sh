#!/bin/bash

# Unified Linux/OS X installation script written for Rails Girls Berlin
#
# Author : Arne Brasseur (@plexus)
#
# History:
#    2013-09-15 : first version

set -e

RUBY_VERSION=2.0.0-p247
RAILS_VERSION=4.0.0

info()  { echo -e "[\033[0;32m info  \033[0m] ${*}" ; }
warn()  { echo -e "[\033[0;33m warn  \033[0m] ${*}" ; }
error() { echo -e "[\033[0;31m error \033[0m] ${*}" ; }
fatal() { error $* 1>&2 ; exit 1 ; }

case $OSTYPE in
    linux-gnu)
        PLATFORM=linux
        case `lsb_release -i -s` in
            Debian|Ubuntu|Mint)
                DISTRO=debian
                ;;
            Fedora)
                DISTRO=fedora
                ;;
        esac
        ;;

    darwin*)
        PLATFORM=osx
        DISTRO=osx
        ;;
    # cygwin)
    #     ;;
esac

install_prerequisites_debian() {
    INSTALLER=apt-get
    PACKAGES=(build-essential bison openssl libreadline6 libreadline6-dev
              curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev
              libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev
              autoconf libc6-dev nodejs imagemagick)

    install_prerequisites_linux
}

install_prerequisites_fedora() {
    INSTALLER=yum
    PACKAGES=(sudo yum install make automake gcc gcc-c++ kernel-devel patch
              libffi-devel libtool bison openssl readline readline-devel
              curl git-core zlib zlib-devel openssl-devel libyaml-devel
              sqlite sqlite-devel libxml2 libxml2-devel libxslt-devel
              autoconf glibc-devel nodejs ImageMagick)

    install_prerequisites_linux
}

install_prerequisites_linux() {
    info "Updating package list. Please provide your password when asked."
    sudo $INSTALLER update -y
    info "Installing packages. Please provide your password when asked."
    sudo $INSTALLER install -y ${PACKAGES[@]}
}

install_prerequisites_osx() {
    RECEIPT_FILE=/var/db/receipts/com.apple.pkg.DeveloperToolsCLI.bom
    if [ -f "$RECEIPT_FILE" ]; then
        info "Command Line Tools are already installed. Great!"
    else
        info "Installing XCode Command Line Tools. Please provide your password when asked."
        sudo bash < <(curl -L -s https://raw.github.com/plexus/xcode-cli-install/master/install.sh)
    fi
}

check_version_managers() {
    [[ -z "$RVM_PLEASE" ]] || return 0
    for version_manager in rbenv chruby ; do
        if which $version_manager > /dev/null ; then
            fatal "You seem to have ${version_manager} installed, this "\
                  "installer will use RVM. If you really want that, use 'RVM_PLEASE=yes ${0}'"
        fi
    done
}

check_ruby() {
    local executable=$(which ruby)
    if $? ; then
        local version=$(ruby -e 'print RUBY_VERSION')
        if [[ $version = "1.9.2" ]] || [[ $version = "1.9.3" ]] || [[ $version = "2.0.0" ]] ; then
            info "Found Ruby ${version} at ${executable}, great!"
            break
        else
            warn "Your Ruby version, ${version} is not supported, we recommend ${RUBY_VERSION}. We'll let RVM bring you up to date."
        fi
        if [[ $executable =~ '/usr' ]] ; then
            warn "It seems you are using a system Ruby, this can be problematic. "\
                 "To be on the safe side we'll use RVM to install a separate Ruby in your home directory"
        fi
    fi
    install_ruby
}

install_ruby() {
    # This will update rvm and install the ruby we need, even if rvm and/or other rubies are already present
    info "Installing RVM, and Ruby ${RUBY_VERSION}, this can take a while."
    curl -L https://get.rvm.io | bash -s stable --ruby=$RUBY_VERSION --autolibs=enable
    source ~/.rvm/scripts/rvm
    if [ -f "$HOME/.profile" ] && [ -f "$HOME/.bash_profile" ] && ! grep "source.*profile" "$HOME/.profile" ; then
        echo -e "#Added by Rails Girls Installer, so RVM loads correctly\nsource ~/.profile" >> $HOME/.bash_profile
    fi
}

check_bundler() {
    which bundle >/dev/null || install_bundler
}

install_bundler() {
    info "Installing bundler"
    gem install bundler
}

install_rails() {
    info "Installing Ruby on Rails $RAILS_VERSION, this can take a while."
    gem install rails --version "=${RAILS_VERSION}" -V
}

verify_installation() {
    if [[ $(\rails --version) == $RAILS_VERSION ]] ; then
        info "Rails installed and working, congratulations!"
    else
        if $? ; then
            fatal "'rails --version' returned an error, please find a coach to have a look at it."
        else
            fatal "Expected 'rails --version' to be '${RAILS_VERSION}', but it's actually $(\rails --version). Please find a coach to have a look at it."
        fi
    fi
}

main() {
    check_version_managers
    install_prerequisites_${DISTRO}
    check_ruby
    check_bundler
    install_rails
    verify_installation

    info "\033[0;31m IMPORTANT! Please close all your terminals now. The new settings will be active when you reopen them. \033[0m"
    info "That's all, have a nice workshop! <3"
}

main
