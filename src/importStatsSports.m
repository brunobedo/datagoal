function rawdata = importStatsSports(filename, dataLines)
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
    %% Input handling

    % If dataLines is not specified, define defaults
    if nargin < 2
        dataLines = [2, Inf];
    end

    %% Setup the Import Options
    opts = delimitedTextImportOptions("NumVariables", 9);

    % Specify range and delimiter
    opts.DataLines = dataLines;
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["PlayerId", "PlayerDisplayName", "Time", "ElapsedTimes", "Lat", "Lon", "Speedkmh", "InstantaneousAccelerationImpulse", "HeartRatebpm"];
    opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string", "string", "string"];
    opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, [1, 2, 3, 4, 5, 6, 7, 8, 9], "EmptyFieldRule", "auto");
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Import the data
    rawdata = readtable(filename, opts);

    %% Convert to output type
    rawdata = table2array(rawdata);
end