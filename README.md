# Parkinson's disease diagnosis using wavelet-domain and time-domain features

## This repository contains matlab files that were used to generate both the multi-scale features generated in the  wavelet-domain and time-domain features. You can run these codes as follows

Download the dataset available at https://physionet.org/content/gaitpdb/1.0.0/
  The dataset used in this project is vertical ground reaction force (VGRF) data collected from 93 cases and 73 controls 

The MatlabFunctions folder contains all the supporting functions used in the following  codes 

Run **CaseFeatures.m** and **ControlFefatures.m**  to compute following feaures \
   a. Multi-scale features \
    i. Level-wise cross correlation \
    ii. Wavelet entropy\
    iii. Spectral slope \
   b. Time-domain features \
    i. Stance time and Swing Time\
    ii. Maximum force reaction at toe and heel\

Run **Demo_1.m** to see the classification performance of multiscale features by using three classifiers, Logistic Regression, Support Vector Machine, k-Nearest nehghbor.

Run **Demo_2.m** compute the classfication performance by combining the multi-scale features with three time-domain features, stance time, swing time, and maximum force reaction at toe
