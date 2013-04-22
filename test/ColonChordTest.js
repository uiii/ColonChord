describe("Sample song parsed by SongParser", function() {
    var songText;

    // load sample song
    var xhr = new XMLHttpRequest();
    xhr.open('GET', "/base/test/unit/sample-song.txt", false);
    xhr.onload = function() {
        songText = xhr.responseText;
    };
    xhr.send();

    //var ColonChord = require('./build/debug/main.js');

    // parse song
    var song = ColonChord.parse(songText);
    
    // convert song structure to text
    var output = "{0} ({1})\n".format(song.title, song.author);

    _.each(song.sections, function(section) {
        var sectionOutput = "";

        _.each(section.lines, function(line, lineNumber) {
            var chordLine = _.reduce(line.chords, function(memo, chord) {
                return memo + _.str.repeat(" ", chord.offset) + chord.name;
            }, "");

            if(chordLine) {
                sectionOutput += ":{0}{1}\n".format(_.str.repeat(" ", section.label.length), chordLine);
            }

            if(lineNumber === 0) {
                sectionOutput += "{0} {1}\n".format(section.label, line.lyrics);
            } else {
                sectionOutput += "{0} {1}\n".format(_.str.repeat(" ", section.label.length), line.lyrics);
            }
        });

        output += "\n{0}".format(sectionOutput);
    });

    // tests
    it("is equal to this output", function() {
        expect(output).toBe(songText);
    });
});
