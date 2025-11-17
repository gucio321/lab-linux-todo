s/\/\/.*//g
/\/\*\+/{
        s/\/\*\+//g
        p
        :multiline
        N
        
        /\*\+\//!b multiline
        s/.*\*\+\///
        p
        d
}
