# Parkinson's disease diagnosis using wavelet-domain and time-domain features
In this project, a set of novel features were characterized on on the basis of self-similar, correlation, and compressibility properties that are extracted by multiscale features of gait data in the wavelet-domain. The discriminatory power of these features in distingushing gait patterns between cases and controls was evaluated by using three different classifiers, $\it{Logistic Regression, Support Vector Machine, k-Nearest nehghbor}$. In addition, the proposed feaures were integrated with the time-domain features in order to  further improve Parkinson's diagnostic performance. 

#### This repository contains matlab files that were used to generate both the multi-scale features generated in the  wavelet-domain and time-domain features. You can run these codes as follows

Download the dataset available at https://physionet.org/content/gaitpdb/1.0.0/; the dataset consists of vertical ground reaction force (VGRF) data collected from 93 cases and 73 controls. 

The **MatlabFunctions** folder contains the matlab functions used in the project

Run **CaseFeatures.m** and **ControlFefatures.m**  to compute following feaures 
   Markup: a. Multi-scale features \
    i. Level-wise cross correlation \
    ii. Wavelet entropy\
    iii. Spectral slope \
   b. Time-domain features \
    i. Stance time and Swing Time\
    ii. Maximum force reaction at toe and heel\

Run **Demo_1.m** to see the classification performance of multiscale features 

Run **Demo_2.m** compute the classfication performance by integrating the multi-scale features with three time-domain features


 Markup : 1. A numbered list
              1. A nested numbered list
              2. Which is numbered
          2. Which is numbered
