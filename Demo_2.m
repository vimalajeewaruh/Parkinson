%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Wavelet-domain features are sequentially included into the classifiers and
% check the training, testing accuracy, sensitivity and specifificity
% 
close all; clear all; clc

addpath('./MatlabFunctions/')

%% Load time and wavelet domain features 
% Controls
load('ControlFeatures/Ctrl.mat')

%  Wavelet-domain features
Control_CV    = Ctrl.Control_CV ;          % cross correlations
Control_Ent   = Ctrl.Control_Ent;         % entropy
Control_Slope = Ctrl.Contorl_Slp;       % slope

% Time-domain features
Control_St      = Ctrl.Control_St;
Control_HeelToe = Ctrl.Control_HeelToe;

% Cases
load('CaseFeatures/Cse.mat')

% Wavelet domain features
Case_CV    = Cse.Case_CV ;
Case_Ent   = Cse.Case_Ent;
Case_Slope = Cse.Case_Slp;

% Time-domain features
Case_St      = Cse.Case_St;
Case_HeelToe = Cse.Case_HeelToe;

%% Create feature matrix by aggregating all wavelet domain features
X_case    =  [  Case_CV  Case_Slope Case_Ent Case_St Case_HeelToe(:,3) ]; 
X_control =  [ Control_CV  Control_Slope Control_Ent Control_St Control_HeelToe(:,3)];

%% Normalize feature matrices 
X_case = X_case./maxk(abs(X_case),1);  X_control = X_control./maxk(abs(X_control),1);

%% Check classifier performance 

nsample = 1000; % number of repititions 
tr_per = .67; % percentrage of samples used to train classifiers 
B = zeros(3,size(X_case,2)); % store training, validation accuracy and sensitivity and specificity

for b = 1:size(X_case,2)
X_caseN = X_case(:,1:b);  X_controlN = X_control(:,1:b); 

%% Classification
A = zeros(nsample,3,4);
    for i = 1 : nsample
        
        % divide dataset into training and testing data 
        [X_tr, Y_tr, X_ts, Y_ts] = TrainTestSample(X_controlN, X_caseN, tr_per);

        % training data set
        Data.X_tr = X_tr; Data.Y_tr = Y_tr;

        % testing dataset 
        Data.X_ts = X_ts; Data.Y_ts = Y_ts; 

        %(1) Logistic regression 
        p = 0.5; % threshold
        [acc_tr, acc_ts, sensi, speci] = LogisticModel(Data, p);
        A(i,1,:) = [acc_tr, acc_ts, sensi, speci];

        %(2) Support Vector Machine
        [acc_str, acc_ts, sensi, speci] = SVMMOdel(Data);
        A(i,2,:) = [acc_str, acc_ts, sensi, speci];

        % (3) k-Nearest neightbor 
        k = 5;
        [acc_ktr, acc_ts, sensi, speci] = KNNModel(Data, k);
        A(i,3,:) = [acc_ktr, acc_ts, sensi, speci];

    end 
k = zeros(3,4);
k(:,:) = mean(A,1) ;
B(:,b) = k(:,2); 
end

B
