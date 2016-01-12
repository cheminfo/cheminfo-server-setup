'use strict';

const path = require('path');

module.exports = {
    getID: function (filename, contents) {
        return path.parse(filename).name;
    },
    getOwner: function (filename, contents) {
        return 'ir@cheminfo.org';
    },
    parse: function (filename, contents) {
        return {
            jpath: 'ir',
            data: {
                reference: path.parse(filename).name
            },
            type: 'jcamp',
            content_type: 'chemical/x-jcamp-dx'
        };
    }
};