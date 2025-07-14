#
# __init__: Anything that needs to be configured prior to other
#           configurations being sourced
#

# Set XDG basedirs.
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
set -q XDG_CONFIG_HOME; or set -x XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -x XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME; or set -x XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME; or set -x XDG_CACHE_HOME $HOME/.cache
