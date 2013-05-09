{
    function isRoman(roman) {
        var validator = /^M*(?:D?C{0,3}|C[MD])(?:L?X{0,3}|X[CL])(?:V?I{0,3}|I[XV])$/;

        return roman && validator.test(roman);
    }

    function romanToDecimal(roman) {
        if (! isRoman(roman)) {
            return null;
        }

        var convertTable = {
            M:1000, CM:900,
            D:500, CD:400,
            C:100, XC:90,
            L:50, XL:40,
            X:10, IX:9,
            V:5, IV:4,
            I:1
        };

        var token = /[MDLV]|C[MD]?|X[CL]?|I[XV]?/g;
        var decimal = 0;

        var match = null;
        while (match = token.exec(roman)) {
            decimal += convertTable[match[0]];
        }

        return decimal;
    }
}

song
    = header:header_line
      capo:capo_line?
      sections:section+ new_line*
    {
        console.log(header);
        console.log(sections);
        return {
            title: header.title,
            author: header.author,
            capo: capo ? capo : 0,
            sections: sections
        };
    }

header_line
    = new_line* title:[^()]+ whitespace* "(" author:[^()]+ ")"
    {
        return {
            title: title.join("").trim(),
            author: author.join("").trim()
        };
    }

capo_line
    = new_line+ "capo" whitespace fret_number:(number / roman)
    {
        return fret_number;
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

        console.log(start_line.label);

        return {
            type: start_line.label.type,
            label: start_line.label.text,
            number: start_line.label.number,
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
        console.log("label");
        console.log(label);
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
    = verse_label / refrain_label / recitation_label / other_label

verse_label
    = number:([1-9][0-9]*) "."
    {
        return {
            text: "",
            number: parseInt(number.join("")),
            type: 'VERSE',
            length: number.join("").length + 1
        };
    }

refrain_label
    = text:("Ref"/"Refrain"/"Chorus") number:(whitespace [1-9][0-9]*)? "."
    {
        console.log("ref");
        console.log(number);

        number = number ? number.join("") : "";

        return {
            text: text,
            number: number ? parseInt(number) : null,
            type: 'REFRAIN',
            length: text.length + number.length + 1
        };
    }

recitation_label
    = text:("Rec"/"Recitation") number:(whitespace [1-9][0-9]*)? "."
    {
        number = number ? number.join("") : "";

        return {
            text: text,
            number: number ? parseInt(number) : null,
            type: 'RECITATION',
            length: text.length + number.length + 1
        };
    }

other_label
    = first:[^: \n] rest:[^\\.\n]* "."
    {
        var text = first + rest.join("");
        var number = null;

        var match = text.match(/^(.+) ([1-9][0-9]*)$/);
        if(match) {
            text = match[1];
            number = parseInt(match[2]);
        }

        return {
            text: text,
            number: number,
            type: 'OTHER',
            length: first.length + rest.length + 1
        };
    }

number "number"
    = number:([1-9][0-9]*)
    {
        return parseInt(number.join(""));
    }

roman "Roman number"
    = number:[IVXLCM]+ ! { return isRoman(number); }
    {
        return romanToDecimal(number.join(""));
    }

text_char
    = [^\n]

non_empty_char
    = [^ \n]

whitespace
    = [ ]

new_line "empty line"
    = "\n"
