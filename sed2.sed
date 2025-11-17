/\/\*\+/{ # if we find the start of a comment /*
        # define "multilineComment" label
        :multilineComment 
        s/\/\*\+//g
        /^$/!{
                s/\(.*\)/\/\/ \1/g
        }
        /\*\+\//!{
                n
                b multilineComment
        }
        s/\(\/\/ \+\)\?\*\+\///g
        p
        d
}

