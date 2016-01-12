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
        version: 1,
        views: {},
        updates: {}
    },
    rights: {
        read: ['anonymous'],
        create: ['ir@cheminfo.org']
    }
};
