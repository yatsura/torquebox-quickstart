#!/bin/bash

# The pre_start_cartridge and pre_stop_cartridge hooks are *SOURCED*
# immediately before (re)starting or stopping the specified cartridge.
# They are able to make any desired environment variable changes as
# well as other adjustments to the application environment.

# The post_start_cartridge and post_stop_cartridge hooks are executed
# immediately after (re)starting or stopping the specified cartridge.

# Exercise caution when adding commands to these hooks.  They can
# prevent your application from stopping cleanly or starting at all.
# Application start and stop is subject to different timeouts
# throughout the system.

# Required environment variables
export TORQUEBOX_HOME=$OPENSHIFT_DATA_DIR/torquebox
export IMMUTANT_HOME=$TORQUEBOX_HOME
export JRUBY_HOME=$TORQUEBOX_HOME/jruby
export PATH=$JRUBY_HOME/bin:$PATH

# Insert the TorqueBox modules before the jbossas-7 ones
export JBOSS_MODULEPATH_ADD=$TORQUEBOX_HOME/jboss/modules/system/layers/base:$TORQUEBOX_HOME/jboss/modules

function torquebox_install() {
    local VERSION=${1:-LATEST}
    URL=http://immutant.org/builds/torquebox-immutant.zip
    pushd ${OPENSHIFT_DATA_DIR} >/dev/null
    rm -rf torquebox*
    wget -nv ${URL}
    unzip -q torquebox-immutant.zip
    rm torquebox-immutant.zip
    ln -s torquebox-* torquebox
    echo "Installed" torquebox-*
    popd >/dev/null
}

function bundle_install() {
    find ${OPENSHIFT_REPO_DIR} -maxdepth 1 -type d -print0 | while read -d $'\0' dir
    do
        if [ ! -d "${dir}/.bundle" ] && [ -f "${dir}/Gemfile" ]; then
            pushd ${dir} > /dev/null
            jruby -J-Xmx256m -J-Dhttps.protocols=SSLv3 -S bundle install
            popd > /dev/null
        fi
    done
}

function db_migrate() {
    local dir=${1:-$OPENSHIFT_REPO_DIR}
    pushd ${dir} > /dev/null
    bundle exec rake db:migrate RAILS_ENV="production"
    popd > /dev/null
}
