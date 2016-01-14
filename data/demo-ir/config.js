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
        version: 3,
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
