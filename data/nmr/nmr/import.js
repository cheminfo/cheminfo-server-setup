'use strict';

const processNmr = require('../../processNmr');

module.exports = {
    getID: function (filename, contents) {
        return filename;
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
