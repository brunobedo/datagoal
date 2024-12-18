function xSE = xSamp_Ent(x,y,m,R,norm)
%   This file is part of DataGoal: a Matlab Toolbox to Linear and Non-linear Soccer Positional Data Analysis.
%   Copyright (C) 2024 Bruno L. S. Bedo, Felipe A. Moura, Rodrigo Aquino, Sérgio A. Cunha, Paulo R. P. Santiago
% 
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
% 
%       http://www.apache.org/licenses/LICENSE-2.0
% 
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.
%
%   Bruno L. S. Bedo,
%   <bruno.bedo@usp.br>

%   xSE = xSamp_Ent(x,y,m,R,norm)
%   Function to calculate cross sample entropy for 2 data series using the
%   method described by Richman and Moorman (2000). J McCamley - Sept, 2015;

%   Inputs
%   x - first data series
%   y - second data series
%   m - vector length for matching (usually 2 or 3)
%   R - R tolerance to find matches (as a proportion of the average of the
%   SDs of the data sets, usually between 0.15 and 0.25)
%   norm - normalization to perform
%   1 = max rescale/unit interval (data ranges in value from 0 - 1)
%   2 = mean/Zscore (used when data is more variable or has outliers)
%   normalized data has SD = 1. This is best for cross sample entropy.
%   Set to any value other than 1 or 2 to not normalize/rescale the
%   data

%   Check both sets of data are the same length
    xl = length(x);
    yl = length(y);
    if xl ~= yl
    disp('The data series need to be the same length!')
    end

    N = length(x);
    % normalize the data ensure data fits in the same "space"
    if norm == 1 %normalize data to have a range 0 - 1
    xn = (x - min(x))/(max(x) - min(x));
    yn = (y - min(y))/(max(y) - min(y));
    r = R * ((std(xn)+std(yn))/2);

    elseif norm == 2 % normalize data to have a SD = 1, and mean = 0
    xn = (x - mean(x))/std(x);
    yn = (y - mean(y))/std(y);
    r = R;
    else disp('These data will not be normalized')
    end

    % fprintf(' 00.00%%');
    for i = 1:N-m
    for j = 1:N-m
    for k = 1:m+1;
    dij(k) = abs(xn(i+k-1)-yn(j+k-1));
    end
    di(j) = max(dij(1:m));
    di1(j) = max(dij(1:m+1));
    end
    d = find(di<=r); % find the vectors of length 'm' that are less than "r" distant from one another
    d1 = find(di1<=r); % find the vectors of length 'm+1' that are less than "r" distant from one another
    nm = length(d);
    Bm(i) = nm/(N-m);
    nm1 = length(d1);
    Am(i) = nm1/(N-m);

    if mod(i,1000) == 0
    % fprintf(repmat('\b',1,7));
    % fprintf('%3.0d',floor(i/(N-m)*100));
    % fprintf('.%1.0f',floor(mod((i/(N-m))*100,1)*10));
    % fprintf('%1.0f',floor(mod((i/(N-m))*1000,1)*10));
    % fprintf('%%');
    end
    end

    % fprintf(repmat('\b',1,7));
    % fprintf('100.00%%');
    % fprintf('\r');
    Bmr = sum(Bm)/(N-m);
    Amr = sum(Am)/(N-m);
    xSE = -log(Amr/Bmr);
end
