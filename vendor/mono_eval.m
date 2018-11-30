function [ v ] = mono_eval( x, pv )
%MONO_EVAL Summary of this function goes here
%   Detailed explanation goes here


    num_mono = size(pv,1);
    num_vars = size(pv,2);
    num_samples = size(x,1);
    v = zeros([num_samples,num_mono]);
    for ii = 1:num_mono
        v(:,ii) = mono_value ( num_vars, num_samples, pv(ii,:), x' );
    end

end

