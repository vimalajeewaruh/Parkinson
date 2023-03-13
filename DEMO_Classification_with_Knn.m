
close all; clear all; clc

addpath('./MatlabFunctions/')

rng(5); % random seed

%% Load time and wavelet domain features 
% Controls
load('./ControlFeatures/Control_Features.mat')

%  Wavelet-domain features
Control_CV    = Control.Control_CV ;    % cross correlations
Control_Ent   = Control.Control_Ent;    % entropy
Control_Slope = Control.Contorl_Slp;    % slope

% Time-domain features
Control_St      = Control.Control_St;      % Stance 
Control_HeelToe = Control.Control_HeelToe(:,[3]); % maximum foce at toe

% Cases
load('./CaseFeatures/Case_Features.mat')

% Wavelet domain features
Case_CV    = Case.Case_CV ; 
Case_Ent   = Case.Case_Ent;
Case_Slope = Case.Case_Slp; 

% Time-domain features
Case_St      = Case.Case_St; 
Case_HeelToe = Case.Case_HeelToe(:,[3]); 

%% Select the optimal wavelet-based feature set
X_case =  [ Case_CV Case_Slope Case_Ent ]; 
X_control =  [ Control_CV Control_Slope Control_Ent ];

y_ca = ones(size(X_case,1),1); y_co = zeros(size(X_control,1),1);
Y = [y_ca; y_co];
X = zscore(cat(1, X_case, X_control));

% number of nearest neighbors
k = 5;
                  
c = cvpartition(Y,'k',10);
opts = statset('Display','iter', 'TolTypeFun','abs');

fun = @(XT,yT,Xt,yt)loss(fitcknn(XT,yT, 'NumNeighbors',k,'Standardize', 0),Xt,yt);
[fs,history] = sequentialfs(fun,X,Y,'cv',c,'options',opts,'direction','forward','nullmodel',false)

%% Perfrom classification with the optimal wavelet-based feature set

% number of repititions of model performance evaluations  
nsample = 100;

% divide dataset into training and testing data 
tr_per = .80; % percentrage of samples used to train classifiers 

% All wavelet-based features
X_case =  [ Case_CV Case_Slope Case_Ent]; X_control =  [ Control_CV Control_Slope Control_Ent];

% optimal feature set
X_case = X_case(:, find(fs)); X_control = X_control(:, find(fs));

for b = 1:size(X_case,2)
%% Classification 

A = zeros(nsample,4);

for i = 1 : nsample
[X_tr, Y_tr, X_ts, Y_ts] = TrainTestSample(X_control, X_case, tr_per);

% Normalize feature matrices 
X_tr= zscore(X_tr); X_ts = zscore(X_ts);

% training data set
Data.X_tr = X_tr; Data.Y_tr = Y_tr;

% testing dataset 
Data.X_ts = X_ts; Data.Y_ts = Y_ts; 

% (2) Support Vector Machine

[acc_str, acc_ts, sensi, speci] = KNNModel(Data, k);
A(i,:) = [acc_str, acc_ts, sensi, speci];


end 
A;
a = mean(A,1) ;
 
end 

a = mean(A,1)
b = std(A,1)

%% Classfication with the wavelet-based optimal features and time-domain features
X_case1 = [X_case Case_St Case_HeelToe];  X_control1 = [X_control Control_St Control_HeelToe];


for b = 1:size(X_case1,2)
%% Classification

A = zeros(nsample,4);

for i = 1 : nsample
[X_tr, Y_tr, X_ts, Y_ts] = TrainTestSample(X_control1, X_case1, tr_per);

% Normalize feature matrices 
X_tr= zscore(X_tr); X_ts = zscore(X_ts);

% training data set
Data.X_tr = X_tr; Data.Y_tr = Y_tr;

% testing dataset 
Data.X_ts = X_ts; Data.Y_ts = Y_ts; 

% Knn model

[acc_str, acc_ts, sensi, speci] = KNNModel(Data, k);
A(i,:) = [acc_str, acc_ts, sensi, speci];

end 

b = mean(A,1) ;
 
end 

a = mean(A,1)
b = std(A,1)