/\/\*\+/{ # if we find the start of a comment /*
        # define "multilineComment" label
        :multilineComment 
        /\*\+\//!{
                N # add next line and check for comment end again
                b multilineComment
        }
        s/\*\+\///g
        s/\/\*\+//g
        p
}
