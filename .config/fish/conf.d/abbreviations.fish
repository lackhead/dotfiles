# Things that should be known by another name

# bat isn't always bat but damn well should be
if not command -q bat && command -q batcat
    abbr --position command bat batcat
end

# fdfind should be fd
if not command -q fd && command -q fdfind
    abbr --position command fd fdfind
end
