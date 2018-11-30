% Example script of using MKS linkages for
% predicting stress--strain curves of composites
% with phases exhibiting power-law strain hardening
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

% pick a microstructure
ims(:,:,:) = ms(randi(size(ms,1),1),:,:,:);

%% Hardening parameters
% hard phase
m_tay = 2.4;
h_0_2 = m_tay*563e3; 
s_0_2 = m_tay*406; 
s_sat_2 = m_tay*971;

% soft phase
h_0_1 = 3*1.e3; 
s_0_1 = 95*3; 
s_sat_1 = 412*3;

h_a = 2.25;

%% model settings
% macroscopically imposed strain rate
rate = 1e-3;

% time settings
dt = 1;
tmin = 0;
tmax = 100.0;
time = tmin:dt:tmax;

ims = ims+1;
[pc,f2] = get_pc_scores(ims);

%% allocate 
e = zeros(size(time));
e_1 = zeros(size(time));
e_2 = zeros(size(time));

x1 = zeros(size(time));
x2 = zeros(size(time));

s = zeros(size(time));
s_low = zeros(size(time));
s_upp = zeros(size(time));
s_1 = zeros(size(time));
s_2 = zeros(size(time));

%% initialize
eta = s_0_2/s_0_1;
s_1(1) = s_0_1;
s_2(1) = s_0_2;

tic 
for ii = 2:numel(time)

    t = time(ii-1);
    tau = time(ii);
    dt = tau-t; 
    
    x1_vars = [pc(ind_x1),(eta - 1)];
    x2_vars = [pc(ind_x2),(eta - 1)];
     
    x1_v = mono_eval(x1_vars,pv_x1);
    x2_v = mono_eval(x2_vars,pv_x2);

    x1(ii) = 1 + predict(link_x1,x1_v);
    x2(ii) = 1 + predict(link_x2,x2_v);

    rate_1 = rate*x1(ii); 
    rate_2 = rate*x2(ii); 
    
    s_dot_1 = rate_1*h_0_1*(1-s_1(ii-1)/s_sat_1)^h_a; 
    s_dot_2 = rate_2*h_0_2*(1-s_2(ii-1)/s_sat_2)^h_a; 

    s_1(ii) = s_1(ii-1) + s_dot_1*dt;
    s_2(ii) = s_2(ii-1) + s_dot_2*dt;
    
    eta = s_2(ii)/s_1(ii);
    s_vars = [pc(ind_s),(eta - 1)];
    s_v = mono_eval(s_vars,pv_s);
    
    s(ii) = s_1(ii)*(1 + predict(link_s,s_v));
    
    s_upp(ii) = s_1(ii)*(1-f2) + s_2(ii)*f2;
    s_low(ii) = (1-f2)/s_1(ii) + f2/s_2(ii);
    s_low(ii) = 1/s_low(ii);

    
    e(ii) = e(ii-1) + rate*dt;
    e_1(ii) = e_1(ii-1) + rate_1*dt;
    e_2(ii) = e_2(ii-1) + rate_2*dt;
    
end
toc

figure; plot(e,s,'Color','k','LineWidth',3)
hold on; plot(e,s_low,'Color','g','LineWidth',2)
hold on; plot(e,s_upp,'Color','r','LineWidth',2)

xlabel('Strain')
ylabel('Stress')