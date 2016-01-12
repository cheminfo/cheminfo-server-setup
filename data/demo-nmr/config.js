'use strict';

module.exports = {
    defaultEntry: function () {
        return {
            parent: [],
            name: [],
            molecule: [],
            nmr: []
        };
    },
    customDesign: {
        version: 1,
        views: {},
        updates: {}
    },
    rights: {
        read: ['anonymous'],
        create: ['nmr@cheminfo.org']
    }
};
