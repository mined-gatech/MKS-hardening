% Example script of using MKS linkages for
% predicting strain rate partitioning
% and effective strength of two-phase composites
% with strength contrast as a continuous variable
%
% Linkages are calibrated as described in Latypov et al., 2018
% https://arxiv.org/abs/1809.07484
%
% Marat I. Latypov (latmarat@ucsb.edu)
% November 2018

clear all; close all; 

%% Load data
% make dependencies available
addpath('vendor')
% load microstructure examples
load('data\ms_examples');
% load calibrated linkages
load('data\linkages');

%% Set composite properties
% pick the strength of the soft phase
s_1 = 1;
% pick a contrast
eta = 5.5;

%% Get microstructure terms
ms = ms+1;
% ims(:,:,:) = ms(10,:,:,:); %for only one RVE
[pc,f2] = get_pc_scores(ms);

%% Predict responses
% get terms for new microstructure(s)
x1_vars = [pc(:,ind_x1),(eta - 1)*ones(size(pc,1),1)];
x2_vars = [pc(:,ind_x2),(eta - 1)*ones(size(pc,1),1)];
s_vars = [pc(:,ind_s),(eta - 1)*ones(size(pc,1),1)];
x1_v = mono_eval(x1_vars,pv_x1);
x2_v = mono_eval(x2_vars,pv_x2);
s_v = mono_eval(s_vars,pv_s);

% predict strain partitioning ratios
x1_hat = 1 + predict(link_x1,x1_v);
x2_hat = 1 + predict(link_x2,x2_v);

% predict strain partitioning ratios
s_hat = s_1*(1 + predict(link_s,s_v));

% calculate classical bounds
s_2 = s_1*eta;
s_upp = s_1*(1-f2) + s_2*f2;
s_low = (1-f2)/s_1 + f2/s_2;
s_low = 1./s_low;

%% Visualize homogenization results
figure; scatter(f2,s_hat,'kx')
hold on; scatter(f2,s_upp,'r','filled')
hold on; scatter(f2,s_low,'b','filled')
xlabel('Volume fraction of hard phase')
ylabel('Effective strength')
