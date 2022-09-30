# Parkinson's disease diagnosis using wavelet-domain and time-domain features
In this project, a set of novel features were characterized based on self-similar, correlation, and compressibility properties extracted by multiscale features of gait data in the wavelet domain. The discriminatory power of these features in distinguishing gait patterns between cases and controls was evaluated using three different classifiers, $\it{Logistic Regression, Support Vector Machine, k-Nearest nehghbor}$. In addition, the proposed features were integrated with the time-domain features in order to further improve Parkinson's diagnostic performance. 

### Data Use in the project 
You can find the dataset available at https://physionet.org/content/gaitpdb/1.0.0/; the dataset consists of vertical ground reaction force (VGRF) data collected from 93 cases and 73 controls. This project considered only the VGRF data collected from subjects while walking at their normal pace for 2 minutes on a flat surface. 


##### Matlab Codes 
This repository contains only the Matlab files used to compute the multiscale features generated in the wavelet-domain and time-domain features. The **MatlabFunctions** folder includes a set of functions used in the following Matlab files. You can run these codes as follows.

1. Download the dataset by using the URL stated above

2. Run **CaseFeatures.m** and **ControlFefatures.m** using VGRF data of cases and control. These codes compute the follwing feaures 

  **Multi-scale features**\
    i. Level-wise cross-correlation \
    ii. Wavelet entropy\
    iii. Spectral slope 
    
   **Time-domain features** \
    i. Stance time and Swing Time\
    ii. Maximum force reaction at toe and heel

3. Run **Demo_1.m** to see the classification performance of all the multiscale features in diagnosing Parkinson's disease

4. Run **Demo_2.m** to compute the classification performance by integrating the multiscale features with three time-domain features in diagnosing Parkinson's disease.

