describe("Sample song parsed by SongParser", function() {
    var songText;

    // load sample song
    var xhr = new XMLHttpRequest();
    xhr.open('GET', "/base/test/sample-song.txt", false);
    xhr.onload = function() {
        songText = xhr.responseText;
    };
    xhr.send();

    // parse song
    var song = ColonChord.parse(songText);

    console.log(song);
    
    // convert song structure to text
    var output = song.title + " (" + song.author + ")\n";

    _.each(song.sections, function(section) {
        var sectionOutput = "";

        _.each(section.lines, function(line, lineNumber) {
            var chordLine = _.reduce(line.chords, function(memo, chord) {
                return memo + _.str.repeat(" ", chord.offset) + chord.name;
            }, "");

            if(chordLine) {
                sectionOutput += ":" + _.str.repeat(" ", section.label.length) + chordLine + "\n";
            }

            if(lineNumber === 0) {
                sectionOutput += section.label + " " + line.lyrics + "\n";
            } else {
                sectionOutput += _.str.repeat(" ", section.label.length) + " " + line.lyrics + "\n";
            }
        });

        output += "\n" + sectionOutput;
    });

    console.log(output);

    // tests
    it("is equal to this output", function() {
        expect(output).toBe(songText);
    });
});
