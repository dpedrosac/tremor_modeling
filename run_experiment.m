
%% Definition of working directory and change to folder
if strcmp(getenv('username'), 'dpedr')
    addpath('D:\skripte\tremor_modeling')
    wdir = 'D:\projekte\oxtrem\preproc_data_reduced_2-5k';                      % working directory
end

try cd(wdir)
catch
    warning('Directory: "%s" \nnot available, please select the right folder', wdir)
end

%% Start loading data and running functions
listsubj = {'subj4l_preproc_macro'};

if strcmp(listsubj, 'all')
    listsubj = ls('*.mat');                                                 % list of subjects available
end

for k = 1:numel(listsubj) % loop through all subjects to analyse
    clear dat;
    load(listsubj{k});
    dat_reduced = preprocess_data(data_macro, [-2 0], 'all');        % reduce data to recordings depths and channels of interest
    visualise_data(dat_reduced.trial, dat_reduced.time, dat_reduced.height, ...
        dat_reduced.label, dat_reduced.trialinfo, dat_reduced.fsample, 'raw')
end