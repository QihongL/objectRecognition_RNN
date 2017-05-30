%% process group score
% compute averages and error bars classification accuracies over time
% written for data generated by "runGroup.m"
clear; clc; close all; 
mainDirName = 'groupScores_class';

OPTIONS = {'get_group_MVPA', 'get_dynamic_code'};
opts = OPTIONS{1};

%% load file and compute summarized data
condition = 'randomSubset';
condition = 'spatBlurring';
method = 'lasso';
%
simNum = 27;
presentation = 'normal';
% simName = 'decay';
simName = 'varyNoise';
ep = 20;
simNum_sub = 1;
rep_idx = 0;

% gather data
results = cell(length(simNum_sub),1);
for i = 1 : length(rep_idx)
    % get path
    subDirName = sprintf('sim%d.%d_%s_%s_e%d_%.2d', ...
        simNum,simNum_sub,simName,presentation,ep, rep_idx(i));
    pathName = fullfile(mainDirName,subDirName,method);
    % summarize data according to the option
    if strcmp(opts, 'get_group_MVPA')
        result_filename = 'gsClass';
        listing = dir(strcat(fullfile(pathName, strcat(result_filename, '_',condition)),'*.mat'));
        [results{i}, propUsed] = summarizeData_gm(listing, pathName, condition);
    elseif strcmp(opts, 'get_dynamic_code')
        result_filename = 'dc';
        listing = dir(strcat(fullfile(pathName, strcat(result_filename, '_',condition)),'*.mat'));
        [results{i}, propUsed] = summarizeData_dc(listing, pathName, condition);
    else
        error('unrecognizable analysis option.');
    end
end

%% Visualize the classification accuracy over time
if strcmp(opts, 'get_group_MVPA')
    data = computeAvg_acrossSims(results);
    plotPerformance_MVPA(data, propUsed, condition)
elseif strcmp(opts, 'get_dynamic_code')
    plotResults_dynCode(results, propUsed, condition)
else
    error('unrecognizable analysis option');
end

