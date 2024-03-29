
function [X_tr, Y_tr, X_ts, Y_ts] = TrainTestSample(X_control, X_case, tr_per)


X_c2 = X_case; 
X_n2 = X_control;

y_c = repelem(1, size(X_c2,1)); y_n = repelem(0,size(X_n2,1)); % asign labels case and control as 1 and 0

A = min(length(y_c), length(y_n));% select number of samples for fitting a classification model
 
Train = round(A *tr_per); Test = A - Train; % number of model training and testing samples 
  
i_n = randperm(size(y_n,2)); i_ntr = i_n(1:Train); i_nts = i_n(Train +1:Train + Test);

i_c = randperm(size(y_c,2)); i_ctr = i_c(1:Train); i_cts = i_c(Train +1:Train + Test);
 
%% Select samples from Slopes 
X_c2tr =  X_c2(i_ctr,:); X_c2ts =  X_c2(i_cts,:);
X_n2tr =  X_n2(i_ntr,:); X_n2ts =  X_n2(i_nts,:);

X_tr = cat(1, X_c2tr, X_n2tr);
X_ts = cat(1, X_c2ts, X_n2ts); 
        
%% training dataset
Y_tr = cat(2, y_n(i_ntr),y_c(i_ctr)); 
Y_tr = Y_tr';  

% testing dataset
Y_ts = cat(2, y_n(i_nts),y_c(i_cts));
Y_ts = Y_ts';
