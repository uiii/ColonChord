function checkTabulators(text) {
    var pos = text.search(/\t/);
    if(pos != -1) {
        var textBefore = text.substring(0, pos);
        var lineNumber = textBefore.split('\n').length;
        var columnNumber = pos - textBefore.lastIndexOf('\n');

        throw new Exception({
            type: 'InputError',
            message: "Song cannot contain tabulators, please replace them with spaces.",
            line: lineNumber,
            column: columnNumber,
            length: 1
        });
    }
}

function removeEmptyLines(text) {
    return text
        .replace(/ *\n/g, '\n') // remove line trailing spaces 
        .replace(/ *$/, "") // remove file trailing spaces
        ;//.replace(/\n(?=\n|$)/g, '\n##EMPTY_LINE##'); // mark empty lines
}

exports.parse = function(text) {
    checkTabulators(text);

    console.log(text);

    text = removeEmptyLines(text);

    console.log(text);

    var output = grammar.parse(text);

    console.log(output);

    return output;
}
