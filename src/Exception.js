var Exception = function(params) {
    this.type = params.type;
    this.message = params.message;
    this.line = params.line;
    this.column = params.column;
    this.length = params.length;
};

Exception.prototype = Error.prototype;
