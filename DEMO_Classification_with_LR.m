
close all; clear all; clc
%addpath('/Users/dixon/Documents/TAMU/DemosNew/')
addpath('./MatlabFunctions/')

rng(5); % random seed
%randn('seed',5)

%% Load time and wavelet domain features 
% Controls
load('./ControlFeatures/Control_Features.mat')

%  Wavelet-domain features
Control_CV    = Control.Control_CV;    % cross correlations
Control_Ent   = Control.Control_Ent;    % entropy
Control_Slope = Control.Contorl_Slp;    % slope

% Time-domain features
Control_St      = Control.Control_St;      % Stance 
Control_HeelToe = Control.Control_HeelToe(:,[3]); % maximum foce at toe

% Cases
load('./CaseFeatures/Case_Features.mat')

% Wavelet domain features
Case_CV    = Case.Case_CV; 
Case_Ent   = Case.Case_Ent;
Case_Slope = Case.Case_Slp; 
% Time-domain features
Case_St      = Case.Case_St; 
Case_HeelToe = Case.Case_HeelToe(:,[3]); 

%%
X_case =  [ Case_CV Case_Slope Case_Ent ]; 
X_control =  [ Control_CV Control_Slope Control_Ent ];


y_ca = ones(size(X_case,1),1); y_co = zeros(size(X_control,1),1);
Y = [y_ca; y_co];
X = zscore(cat(1, X_case, X_control));


maxdev = chi2inv(.95,1);     
opt = statset('display','iter',...
              'TolFun',maxdev,...
              'TolTypeFun','abs');
c = cvpartition(Y,'k',10);
[fs,history] = sequentialfs(@critfun,X,Y,...
                       'cv','none',...
                       'nullmodel',true,...
                       'options',opt,...
                       'direction','forward')               
%% Classification

X_case = X_case(:, find(fs)); X_control = X_control(:, find(fs));

% number of repititions 
nsample = 100;
% divide dataset into training and testing data 
tr_per = .80; % percentrage of samples used to train classifiers 


for b = 1:size(X_case,2)
    
%X_caseN = [ X_case X_case1(:,1:b)];  X_controlN = [ X_control X_control1(:,1:b) ]; 

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

[acc_str, acc_ts, sensi, speci] =  LogisticModel(Data, .5) ;
A(i,:) = [acc_str, acc_ts, sensi, speci];


end 
A;
a = mean(A,1) ;
 
end 

a = mean(A,1)
b = std(A,1)

%%
X_case1 = [X_case Case_St(:,2) Case_HeelToe];  X_control1 = [X_control Control_St(:,2) Control_HeelToe];


F = (mean(X_case1,1) - mean(X_control1,1)).^2./( var(X_case1,1) + var(X_control1,1) );

[q, r ]= maxk(F, size(X_case,2));

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

% (2) Support Vector Machine

[acc_str, acc_ts, sensi, speci] = LogisticModel(Data, .5) ;
A(i,:) = [acc_str, acc_ts, sensi, speci];


end 

b = mean(A,1) ;
 
end 

a = mean(A,1)
b = std(A,1)