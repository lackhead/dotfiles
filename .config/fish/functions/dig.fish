function dig --wraps 'dig'
   command dig +search +noall +answer $argv
end
