function [val_scores,f2] = get_pc_scores(data)
% calculate PC scores for new microstructure(s)
% by projecting 2-point statistics into the PC basis
% established as described in Latypov et al., 2018
%
% Usage: 
% val_scores = get_pc_scores(data); 
% data - 4D or 3D array containing phase labels:
% * 4D case - data(N,nx,ny,nz)
% * 3D case - data(nx,ny,nz)
% where N is the number of microstructures
% and nx,ny,nz are numbers of voxels along x,y,z
%
% data must contain 1 and 2 corresponding to labels of 
% soft and hard phase respectively
    
    addpath('vendor');
    load('data\calibration','ms_cal_data');
    
    % transform data to 0 and 1
    data = data-1;
    
    ndim = numel(size(data));
    switch ndim
        case 4
            num_samples = size(data,1);
            ms = data;
            dsize = size(data);
            dims = dsize(2:end);
        case 3
            num_samples = 1;
            ms(1,:,:,:) = data;
            dims = size(data);
        otherwise
            disp('Please provide 3-D microstructure!')
            val_scores = 0;
            return
    end
    
    % get dimensions of calibration RVEs
    cal_dims = [size(ms_cal_data.ms,2),size(ms_cal_data.ms,3),size(ms_cal_data.ms,4)];
    
    % calculate 2-pt stats for new microstructure
    cutoff = fix(mean(cal_dims/2+1));  
    tps = zeros([num_samples,cal_dims]);
    f2 = zeros([num_samples,1]);
    for ii = 1:num_samples
        ims(:,:,:) = ms(ii,:,:,:);
        itps = TwoPoint('auto',cutoff,'periodic',ims);
        tps(ii,:,:,:) = itps;   
        f2(ii) = nnz(ims(:)==1)*1.0/numel(ims(:));
    end    
    
    % get basis from calibration data
    tps_mean = ms_cal_data.tps_mean;
    basis = ms_cal_data.basis;
    cal_scores = ms_cal_data.scores;  
    
    % calculate scores for new microstructure
    tpsV = reshape(tps,[num_samples,prod(cal_dims)]);
    tps_mean_m = repmat(tps_mean,size(tpsV,1),1);
    tpsVc = tpsV - tps_mean_m;
    val_scores = tpsVc*basis;
    
    % plot scores i.t.o PC-1 and PC-2
    figure; scatter(cal_scores(:,1),cal_scores(:,2),75,'filled','MarkerFaceColor',[0.7 0.7 0.7])
    hold on; scatter(val_scores(:,1),val_scores(:,2),90,'Marker','x','MarkerEdgeColor',[255 0 69]/255)
    
    xlabel('PC score 1')
    ylabel('PC score 2')
    
end