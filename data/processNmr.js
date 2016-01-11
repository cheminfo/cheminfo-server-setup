'use strict';

module.exports = getMetadata;

var anReg = /[0-9]{5,}/;
function getMetadata(filecontent) {
    var metadata = {
        nucleus: []
    };

    var line;
    if (line = getLineIfExist(filecontent, '##.SOLVENT NAME= ')) {
        metadata.solvent = line;
    }
    if (line = getLineIfExist(filecontent, '##.PULPROG= ')) {
        metadata.pulse = line;
    } else if (line = getLineIfExist(filecontent, '##.PULSE SEQUENCE= ')) {
        metadata.pulse = line;
    }
    if (line = getLineIfExist(filecontent, '##.OBSERVE FREQUENCY= ')) {
        metadata.frequency = parseFloat(line);
    }
    if (line = getLineIfExist(filecontent, '##.TE= ')) {
        metadata.temperature = parseFloat(line);
    }
    if (line = getLineIfExist(filecontent, '##NUM DIM= ')) {
        metadata.dimension = parseInt(line);
    } else {
        metadata.dimension = 1;
    }
    if (metadata.dimension === 1) {
        if (line = getLineIfExist(filecontent, '##.OBSERVE NUCLEUS= ')) {
            metadata.nucleus.push(line.replace('^', ''));
        }
    } else {
        if (line = getLineIfExist(filecontent, '##.NUCLEUS= ')) {
            var split = line.split(',');
            for (var j = 0; j < split.length; j++) {
                metadata.nucleus.push(split[j].trim());
            }
        }
    }
    if (line = getLineIfExist(filecontent, '##TITLE=')) {
        var resReg = anReg.exec(line);
        metadata.title = resReg ? parseInt(resReg[0]) : -1;
    }
    if (line = getLineIfExist(filecontent, '$$ Date_')) {
        var date = line.trim();
        var theDate = new Date(0);
        theDate.setDate(parseInt(date.substr(-2, 2)));
        theDate.setMonth(parseInt(date.substr(-4, 2)) - 1);
        theDate.setYear(parseInt(date.substr(0, date.length - 4)));
        if (line = getLineIfExist(filecontent, '$$ Time')) {
            date = line.trim().split('.');
            theDate.setHours(parseInt(date[0]));
            theDate.setMinutes(parseInt(date[1]));
        }
        metadata.date = theDate;
    }

    return metadata;
}

function getLineIfExist(str, prefix) {
    var line = str.indexOf(prefix);
    if (line > -1) {
        return str.substring(line + prefix.length, str.indexOf('\n', line)).trim();
    }
}
