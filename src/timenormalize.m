
function signal_timenormalized = timenormalize(signal,T1,T2,n_el) %D1,D2,
% Author: Bruno L. S. Bedo 
% Email: bruno.bedo@usp.br
% update: June/2020
% timenormalize takes the column matrix signal and operate a time
% normalization between T1 and T2 over n_el elements by using a spline
% function. d1 and d2 can specify the derivative at beginning and end of
% the curve. If you don't want to specify any, input empy matrix [].
    x_base_norm = linspace(1,T2-T1+1,n_el)';
    x_base_current = (1:T2-T1+1)';
    nM = size(signal,2);
    signal_timenormalized = NaN(n_el, nM);
    for i = 1:nM
    %     if isempty(D1)
    %         d1 = [];
    %     else d1 = D1(i);
    %     end
    %     if isempty(D2)
    %         d2 = [];
    %     else d2 = D2(i);
    %     end
    %     y_current =  [ d1; signal(T1:T2,i); d2];
        y_current =  signal(T1:T2,i);

        if sum(isnan(y_current))>0
            y_current = zeros(length(y_current),1);
        end
        
        signal_timenormalized(:,i) = spline(x_base_current, y_current,x_base_norm);
end
