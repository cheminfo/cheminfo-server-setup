'use strict';

const processNmr = require('../../processNmr');

module.exports = {
    getID: function (filename, contents) {
        var name = filename.split('-')[0];
        if(!name) throw new Error('Could not get id. Invalid file name');
        return name;
    },
    getOwner: function (filename, contents) {
        return 'nmr@cheminfo.org';
    },
    parse: function (filename, contents) {
        return {
            jpath: 'nmr',
            data: processNmr(contents.toString()),
            type: 'jcamp',
            content_type: 'chemical/x-jcamp-dx'
        };
    }
};
