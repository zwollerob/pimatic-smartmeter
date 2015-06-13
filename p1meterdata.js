var serialport = require("serialport");
var SerialPort = serialport.SerialPort;
var util = require("util");
var events = require("events");


var openSerialPort = function (opts, callback) {
    console.log('serialport options ');
    console.log(opts);

    // Setup a SerialPort instance
    var sp = new SerialPort(opts.portName, {
        baudRate: opts.baudRate,
        dataBits: opts.dataBits,
        parity: opts.parity,
        stopBits: opts.stopBits,
        flowControl: opts.flowControl,
        parser: serialport.parsers.raw
    }, false);

    sp.open(function () {
        console.log('- Serial port is open');
        sp.on('data', callback);
    });

    return sp;
};

//  Returns result from applying regex to data (string)
var returnRegExResult = function (data, regex) {
    var result = data.match(regex);

    if (result != undefined) {
        return result[1];
    } else {
        return undefined;
    }

}; // returnRegExResult

function newLineStream(callback) {
    var buffer = '';

    return (function (chunk) {
        convertedChunk = new Buffer(chunk, 'binary').toString('ascii');

        var i,
            piece = '',
            offset = 0;
        buffer += convertedChunk;
        while ((i = buffer.indexOf('!', offset)) !== -1) {
            piece = buffer.substr(offset, i - offset);
            offset = i + 1;
            callback(piece);
        }
        buffer = buffer.substr(offset);
    });
} // newLineStream

var P1DataStream = function (opts) {
    var self = this;
    self.opts = opts;


    var processDatagram = function (data) {

        var convertedChunk = new Buffer(data, 'binary').toString('ascii');

        var tariffOneTotalUsage = returnRegExResult(convertedChunk, /^1-0:1.8.1\(0+(.*?)\.0+\*/m);
        var tariffTwoTotalUsage = returnRegExResult(convertedChunk, /^1-0:1.8.2\(0+(.*?)\.0+\*/m);
        var currentTariff = returnRegExResult(convertedChunk, /^0-0:96.14.0\(0+(.*?)\)/m);
        var currentUsage = returnRegExResult(convertedChunk, /^1-0:1.7.0\((.*?)\*/m);

        var dataGram = {
            tariffOneTotalUsage: tariffOneTotalUsage * 1,
            tariffTwoTotalUsage: tariffTwoTotalUsage * 1,
            currentTariff: currentTariff * 1,
            currentUsage: currentUsage * 1000
        };

        console.log('Raw data received: ' + data);
        //console.log('self' + self.portName);

        self.emit("data", dataGram);
    };


    var listener = newLineStream(processDatagram);

    openSerialPort(self.opts, listener);
    events.EventEmitter.call(this);
};

util.inherits(P1DataStream, events.EventEmitter);

module.exports = P1DataStream;
