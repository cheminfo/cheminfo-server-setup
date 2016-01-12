'use strict';

const path = require('path');
const processMolfile = require('../../processMolfile');

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
            data: processMolfile(contents.toString()),
            type: 'mol2d',
            content_type: 'chemical/x-mdl-molfile'
        };
    }
};
