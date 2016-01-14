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
        version: 3,
        views: {
            entryByMW: require('../views').entryByMW
        },
        updates: {}
    },
    rights: {
        read: ['anonymous'],
        create: ['nmr@cheminfo.org']
    }
};
