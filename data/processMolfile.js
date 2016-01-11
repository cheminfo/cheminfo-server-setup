'use strict';

const OCL = require('openchemlib');
const CC = require('chemcalc');

module.exports = function (molfile) {
    var result = {};
    var molecule = OCL.Molecule.fromMolfile(molfile);

    var mf = molecule.getMolecularFormula().getFormula();

    var infoMF = CC.analyseMF(mf);

    result.mf = {
        mf: mf,
        mw: infoMF.mw,
        em: infoMF.em
    };

    result.idCode = {
        type: 'oclid',
        value: molecule.getIDCode()
    };

    var properties = molecule.getProperties();
    result.properties = {
        acceptor: properties.getAcceptorCount(),
        donor: properties.getDonorCount(),
        logP: properties.getLogP(),
        logS: properties.getLogS(),
        polarSurfaceArea: properties.getPolarSurfaceArea(),
        rotatableBondcount: properties.getRotatableBondCount(),
        stereoCenterCount: properties.getStereoCenterCount()
    };

    return result;
};