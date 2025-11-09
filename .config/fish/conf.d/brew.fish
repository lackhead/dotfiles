# 
# Homebrew setup
# 
if command -q /opt/homebrew/bin/brew && status is-interactive
    /opt/homebrew/bin/brew shellenv | source
end
