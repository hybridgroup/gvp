#!/bin/bash
usage() {
cat << EOF
usage: gst [COMMAND]

SYNOPSIS
    gst is a gemset manager inspired by [gs](http://github.com/soveran/gs).
    The difference is that it stays in the same shell and just modifies gem env variables.
    To be compatible with gs, it uses a .gs directory and sets the GS_NAME variable.

USAGE
    Since gst is a script, env changes will not happen unless you source them.

      $ gst init
      $ source gst in
      $ source gst out

COMMANDS
    init    Creates the .gs directory
    in      Modifies GEM_HOME, GEM_PATH and PATH to use the .gs directory and sets the GS_NAME variable.
    out     Restores the previous GEM_HOME, GEM_PATH and PATH. Also unsets GS_NAME.
EOF
}

if [[ "$#" -ne 1 ]]; then
  usage
  exit 1
fi

case "$1" in
  "init")
    mkdir .gs;;
  "in")
    GS_DIR="$(pwd)/.gs"

    if [[ ! -d $GS_DIR ]]; then
      echo 'Directory .gs not found. Run `gst init` first.'
      exit 1
    fi

    GST_OLD_PATH=$PATH
    GST_OLD_GEM_PATH=$GEM_PATH
    GST_OLD_GEM_HOME=$GEM_HOME

    export GST_OLD_PATH GST_OLD_GEM_PATH GST_OLD_GEM_HOME

    GS_NAME=$(pwd | sed -E "s/^.*\/(.*)$/\\1/")
    PATH="$GS_DIR/bin":$PATH
    GEM_PATH=$GS_DIR:$GEM_PATH
    GEM_HOME=$GS_DIR

    export PATH GEM_PATH GEM_HOME GS_NAME
    ;;
  "out")
    GS_DIR="$(pwd)/.gs"

    if [[ ! -d $GS_DIR ]]; then
      echo 'Directory .gs not found. Run `gst init` first.'
      exit 1
    fi

    PATH=$GST_OLD_PATH
    GEM_PATH=$GST_OLD_GEM_PATH
    GEM_HOME=$GST_OLD_GEM_HOME

    export PATH GEM_PATH GEM_HOME
    unset GST_OLD_PATH GST_OLD_GEM_PATH GST_OLD_GEM_HOME GS_NAME
    ;;
  *)
    usage
    exit 1
    ;;
esac

