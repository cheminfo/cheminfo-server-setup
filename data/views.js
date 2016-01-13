'use strict';

module.exports = {
    entryByMW: {
        map: function(doc) {
            if(doc.$type !== 'entry') return;

            if(doc.$content && doc.$content.molecule && doc.$content.molecule.length) {
                for(var i=0; i<doc.$content.molecule.length; i++) {
                    var mol = doc.$content.molecule[i];
                    emit(mol.mf.mw);
                }
            }
        }
    }
};

