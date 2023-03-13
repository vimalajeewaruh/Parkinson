# Parkinson's disease diagnosis using wavelet-domain and time-domain features
This project aimed to develop new features for analyzing gait data by exploring self-similar, cross correlation, and compressibility properties in the wavelet domain. The effectiveness of these features in distinguishing gait patterns between Parkinson's disease patients and control subjects was evaluated using three classifiers: logistic regression, support vector machine, and k-nearest neighbor. The new features were also combined with time-domain features to enhance the diagnostic performance of Parkinson's disease.

### Dataset
You can find the dataset available at https://physionet.org/content/gaitpdb/1.0.0/; the dataset consists of vertical ground reaction force (VGRF) data collected from 93 cases and 73 controls. This project considered only the VGRF data collected from subjects while walking at their normal pace for 2 minutes on a flat surface. 


### Matlab Codes 
The repository includes Matlab files that are used to compute multiscale features generated in the wavelet domain and time-domain features. The **MatlabFunctions** folder contains a set of functions used in the Matlab files. To run these codes, follow the instructions provided.


1.  The study utilized VGRF data files, which were extracted from the Physionet repository. The **CaseFeatures** and **ControlFeatures** folders contain multiscale and time-domain features that were generated using the VGRF data.

   **Multi-scale features**\
      i. Level-wise cross-correlation \
      ii. Wavelet entropy\
      iii. Spectral slope 
    
   **Time-domain features** \
      i. Stance time and Swing Time\
      ii. Maximum force reaction at toe off

3.  Run **Demo** files to test the classification performance of multiscale features and their integration with three time-domain features in diagnosing Parkinson's disease


