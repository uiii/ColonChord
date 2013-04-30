{
    var song = {};
}

song
    = header:header_line sections:section+ new_line*
    {
        console.log(header);
        console.log(sections);
        return {
            title: header.title,
            author: header.author,
            sections: sections
        };
    }

header_line
    = title:[^()]+ whitespace* "(" author:[^()]+ ")"
    {
        return {
            title: title.join("").trim(),
            author: author.join("").trim()
        };
    }

section
    = chord_section
    / lyrics_section

chord_section
    = new_line+ section:chord_section_line
    {
        return section;
    }

chord_section_line "chord section"
    = "::" chords:chord+
    {
        return {
            type: "CHORDS",
            lines: [
                {
                    chords: chords
                }
            ]
        };
    }

lyrics_section
    = start_line:lyrics_section_start_line lines:lyrics_section_line*
    {
        lines.unshift({
            chords: start_line.chords,
            lyrics: start_line.lyrics
        });

        return {
            type: "LYRICS", // TODO
            label: start_line.label,
            lines: lines
        };
    }

lyrics_section_start_line
    = chords:chord_line? lyrics:labeled_lyrics_line
    {
        if(chords) {
            chords[0].offset -= lyrics.offset - 1;
        }

        return {
            label: lyrics.label,
            chords: chords ? chords : [],
            lyrics: lyrics.text
        };
    }

lyrics_section_line
    = chords:chord_line? lyrics:lyrics_line
    {
        if(chords) {
            chords[0].offset -= lyrics.offset - 1;
        }

        return {
            chords: chords ? chords : [],
            lyrics: lyrics.text
        };
    }

chord_line
    = new_line+ line:chords
    {
        return line;
    }

labeled_lyrics_line
    = new_line+ line:labeled_lyrics
    {
        return line;
    }

lyrics_line
    = new_line+ line:lyrics
    {
        return line;
    }

chords "chord line"
    = ":" chords:chord+
    {
        return chords;
    }

chord
    = space:whitespace+ name:non_empty_char+
    {
        return {
            offset: space.length,
            name: name.join("")
        }
    }

labeled_lyrics "labeled lyrics line"
    = label:label lyrics:lyrics
    {
        return {
            label: label,
            offset: label.length + lyrics.offset,
            text: lyrics.text
        }
    }

lyrics "lyrics line"
    = space:whitespace+ text:text_char+
    {
        return {
            offset: space.length,
            text: text.join("")
        }
    }
    
label
    = first:[^: \n] rest:non_empty_char+
    {
        return first + rest.join("");
    }

text_char
    = [^\n]

non_empty_char
    = [^ \n]

whitespace
    = [ ]

new_line "empty line"
    = "\n"
