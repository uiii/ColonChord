{
    var song = {};
}

song
    = new_line* header:header_line sections:section+ new_line*
    {
        return {
            title: header.title,
            author: header.author,
            sections: sections
        };
    }

header_line
    = title:[^()]+ whitespace* "(" author:[^()]+ ")" whitespace*
    { 
        return {
            title: title.join("").trim(),
            author: author.join("").trim()
        };
    }

section
    = section:(chord_section / lyrics_section)
    {
        return section;
    }

chord_section
    = new_line+ "::" chords:chords
    {
        return {
            type: "CHORDS",
            label: "::",
            lines: [
                {
                    chords: chords,
                    lyrics: ""
                }
            ]
        };
    }

lyrics_section
    = labeled_line:labeled_line lines:line+
    {
        if(! lines) {
            lines = [];
        }
        
        return {
            type: "TODO",
            label: labeled_line.label,
            lines: [labeled_line.line].concat(lines)
        };
    }

labeled_line
    = chords:chord_line?
      new_line+ label:non_empty_char+ lyrics:lyrics
    {
        if(chords) {
            chords[0].offset -= label.length + lyrics.offset

            if(chords[0].offset < 0) {
                // TODO error
            }
        } else {
            chords = [];
        }

        return {
            label: label.join(""),
            line: {
                chords: chords,
                lyrics: lyrics.lyrics
            }
        };
    }

line
    = chords:chord_line?
      new_line+ lyrics:lyrics
    {
        if(chords) {
            chords[0].offset -= lyrics.offset

            if(chords[0].offset < 0) {
                // TODO error
            }
        } else {
            chords = [];
        }

        return {
            chords: chords,
            lyrics: lyrics.lyrics
        };
    }

chord_line
    = new_line+ ":" chords:chords whitespace*
    {
        return chords;
    }

chords
    = chords:chord+
    {
        return chords;
    }

chord
    = offset:whitespace+ name:non_empty_char+
    {
        return {
            offset: offset.length,
            name: name.join("")
        };
    }

lyrics
    = space:whitespace+ lyrics:text_char+
    {
        return {
            offset: space.length,
            lyrics: lyrics.join("")
        };
    }

text_char
    = [^\n]

non_empty_char
    = [^ \n]

whitespace
    = [ ]

new_line
    = whitespace* "\n"
