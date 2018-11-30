function y_hat = predict(model,x_val)

    y_hat = zeros(size(x_val,1),1);
    for jj = 1:size(x_val,1)
        
        NewDataPoint=x_val(jj,:);
        NewScores=repmat(NewDataPoint,[length(model.PowerMatrix) 1]).^model.PowerMatrix;
        EvalScores=ones(length(model.PowerMatrix),1);
        for ii=1:size(model.PowerMatrix,2)
            EvalScores=EvalScores.*NewScores(:,ii);
        end
        y_hat(jj) = model.Coefficients'*EvalScores;
    end
    
end

