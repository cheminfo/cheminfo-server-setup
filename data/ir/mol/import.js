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
            jpath: 'molecule',
            data: {
                reference: path.parse(filename).name
            },
            type: 'mol2d',
            content_type: 'chemical/x-mdl-molfile'
        };
    }
};
