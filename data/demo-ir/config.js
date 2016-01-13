'use strict';

module.exports = {
    defaultEntry: function () {
        return {
            parent: [],
            name: [],
            molecule: [],
            ir: []
        };
    },
    customDesign: {
        version: 2,
        views: {
            entryByMW: require('../views').entryByMW
        },
        updates: {}
    },
    rights: {
        read: ['anonymous'],
        create: ['ir@cheminfo.org']
    }
};
