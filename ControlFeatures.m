%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code computes wavelet domain features for control subjects 
%  (1) Level-wise cross correlation
%  (2) Wavelet entropy
%  (3) Spectral slope 

%This code computes time domain features for control subjects  
%  (1) Swing time and stance time
%  (2) Maximum peak force at toe and heel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear all; clc
addpath('./MatlabFunctions/')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZING PARAMETERS 
J = 13;                         % power of two used for selecting data points
n = 2^J;                        % number of data points selected from data files 
L1 = 7; L2 = 7;                 % wavelet decomposition level
ismean = 2;                     % measure used to compute wavelet spectra; options 0- mean/ 1 - median
isplot = 0;                     % plot wavelet spectra 0 - No/ 1 - yes
Lt = 18; Rt = 19;               % column index coressponding to left and right foot in data file
filt = [sqrt(2)/2 sqrt(2)/2];   % wavelet filter 
F =10;     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  ############################## Load Control Data  ####################

dirName = sprintf('Data/Control/');         % folder path
files = dir( fullfile(dirName,'*.txt') );   % list all *.xyz files
files = {files.name}';                      % file names
nfi = numel(files);

%% ##############################  Wavelet-Domain Features ####################

%%  ############################## (1)  Level-Wise Cross Correlations  ####################


Control_CV = [];
for i = 1 : nfi
    fname = fullfile(dirName,files{i});     %# full path to file
    data = readmatrix(fname);
       
    if size(data,1) >= n
        CV = [];
        for p = 2:9
            
            %lf - left foot
            lf = zscore(data(1:n, p)); wc_lf = dwtr(lf, filt, J - L1); 
            
            %rf - left foot
            rf = zscore(data(1:n, p+8)); wc_rf = dwtr(rf, filt, J - L1);
            
            lf1 = wc_lf( round(2^(J-L1)+1) : end ); 
            rf1 = wc_rf( round(2^(J-L1)+1) : end );
            

            CV_LR = [];
            for j = L1 : J - 1
                help_lf = wc_lf( round(2^(j)+1) : round(2^(j+1)) );  
                help_rf = wc_rf( round(2^(j)+1) : round(2^(j+1)) ); 

                cv = help_lf*help_rf'/(norm(help_lf,2)*norm(help_rf,2));
                
                CV_LR = [CV_LR cv ];
            end
            CV = [ CV;  CV_LR];
        end 
    Control_CV = [Control_CV; mean(CV,1) ];
    
    end 
end 

%% ############################## (2) Wavelet Entropy  ####################
Control_As = []; 
for i = 1 : nfi
    fname = fullfile(dirName,files{i});     %# full path to file
    data = readmatrix(fname);
       
    if size(data,1) >= n
        CV = [];
        for p = 2:9
            %lf - left foot
            lf = diff(zscore(data(1:n+1, p)), 1); wc_lf = dwtr(lf, filt, J - L2); 
            
            lf1 = wc_lf( round(2^(J-L2)+1) : end ); rf1 = wc_rf( round(2^(J-L2)+1) : end );
           
            lf1 = lf1.^2; lf1 = lf1(find(lf1));
            
            we_l = -sum(lf1.*log(lf1)); 

            As = [we_l];

            CV = [ CV; As];
        end 
    Control_As = [Control_As; mean(CV(:,1),1) ];
    
    end 
end

%% ############################## (3)  Control Entropy  ####################
L =1; L_Slope = []; R_Slope = [];
for i = 1 : nfi
    fname = fullfile(dirName,files{i});     %# full path to file
    data = readmatrix(fname);
    
    if size(data,1) >= n
        Ls = []; Rs = [];
        for j = 2 : 9
            
            % lf - left foot 
            lf = zscore(data(1:n+1, j ));
            lf = cumsum(lf);
           
            k1 = 2; k2 = 5;
            [slope_lf1] = waveletspectra(lf, L, filt, k1, k2, ismean, isplot);
            
            k1 = 7; k2 = J-1;
            [slope_lf2] = waveletspectra(lf, L, filt, k1, k2, ismean, isplot);
                      
            Ls = [Ls; slope_lf1 slope_lf2];
            
        end 
        
    L_Slope = [L_Slope; mean(Ls,1) ]; 
    end 
end 
Control_Slope = [L_Slope];

%% ############################## //  ############################################

%% ##############################  Time Domain Features ####################

%% %%##############################  (1) Swing Time and Stance Time ####################

Control_HeelToe = [];
for i = 1 : nfi
    fname = fullfile(dirName,files{i});     %# full path to file
    data = readmatrix(fname);
    t = data(:,1);    
    if size(data,1) >= n
       Heel = data(:,2); Toe = data(:,9);
       [a_st, a_sw, VGRF_h]  = WalkingPhase(t, Heel, F); 
       [a_st, a_sw, VGRF_t]  = WalkingPhase(t, Toe, F);
       
       Heel = data(:,10); Toe = data(:,17);
       [a_st, a_sw, VGRF_hr]  = WalkingPhase(t, Heel, F); 
       [a_st, a_sw, VGRF_tr]  = WalkingPhase(t, Toe, F);
       
       Control_HeelToe  = [Control_HeelToe ; [ mean(VGRF_hr(:,1)) std(VGRF_hr(:,1)) ...
        mean(VGRF_tr(:,2)) std(VGRF_tr(:,2))] ];
    end 
end 

%% ##############################  (2) Maximum force reaction at toe and heel ####################

 Control_St = [];
for i = 1 : nfi
    fname = fullfile(dirName,files{i});     %# full path to file
    data = readmatrix(fname);
    t = data(:,1); 
    VGRF_L = data(:,18); VGRF_R = data(:,19);
    
    if size(data,1) >= n
        [st_L, sw_L]  = WalkingPhase(t, VGRF_L, 20);
        [st_R, sw_R]  = WalkingPhase(t, VGRF_R, 20);
        Control_St = [ Control_St; [ mean(sw_L)  mean(st_L)] ];
    end 
end 

Ctrl.Control_CV = Control_CV;
Ctrl.Control_Ent = Control_As;
Ctrl.Contorl_Slp = Control_Slope;
Ctrl.Control_St = Control_St;
Ctrl.Control_HeelToe = Control_HeelToe;

save('ControlFeatures/Ctrl.mat','Ctrl')