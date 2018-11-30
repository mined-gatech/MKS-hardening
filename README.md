MATLAB implementation of Material Knowledge System for predicting stress--strain responses in non-linear two-phase composites as presented in Latypov et al., 2018. 

## Contents

`predict_response` -- example script showing how to use the calibrated linkages for prediction of responses (effective strength and strain rate partitioning) for two-phase microstructure(s) 

`predict_ss_linear` -- example script showing how to use the calibrated linkages for prediction of stress--strain curves of composites with phases exhibiting linear strain hardening behavior

`predict_ss_power` -- example script showing how to use the calibrated linkages for prediction of stress--strain curves of composites with phases exhibiting power-law strain hardening behavior

`data\linkages.mat` -- MATLAB file containing calibrated linkages (i.e., polynomial coefficients)

`data\calibration.mat` -- MATLAB file containing ensemble of microstructures used for calibration as well as their 2-point statistics and principal component basis needed for using the calibrated linkages

`data\ms_examples.mat` -- MATLAB file containing 38 example microstructures (different from calibration set) that can be used for testing the models

`vendor` -- folder with dependencies needed to use the prediction functions. 

## Publication

To cite this code and to see more details, refer to

M.I. Latypov, L.S. Toth, S.R. Kalidindi, Materials knowledge system for nonlinear composites, Computer Methods for Applied Mechanics and Engineering, Under Review, preprint: [arXiv:1809.07484](https://arxiv.org/abs/1809.07484).
