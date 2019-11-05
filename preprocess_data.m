function data_preproc = preprocess_data(data, depths, vlp_ch)

% INPUT:
%   - data: structure with trials, time, label, heights, fsample and
%   trialinfo
%   - depths: either single recording depth of interest or range of
%   interest (e.g. as [x1 x2] or 'all')) 
%   - vlp_ch: channels at the ventrolateral thalamus that should be 
%   considered (entered as e.g. {'posterior', 'anterior'} or 'all')

%   D. Pedrosa, University Hospital of Gieﬂen and Marburg, November 2019
%
%   Permission is hereby granted, free of charge, to any person obtaining a
%   copy of this software and associated documentation files (the "Software"),
%   to deal in the Software without restriction, including without limitation
%   the rights to use, copy, modify, merge, publish, distribute, sublicense,
%   and/or sell copies of the Software, and to permit persons to whom the
%   Software is furnished to do so, subject to the following conditions:

%   The above copyright notice and this permission notice shall be included
%   in all copies or substantial portions of the Software.

%   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
%   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
%   DEALINGS IN THE SOFTWARE.

if (nargin < 3 || strcmp(vlp_ch, 'all')) 
    vlp_ch = {'central', 'anterior', 'medial', 'posterior', 'lateral'};     % select all channels if not enough arguments
elseif nargin < 2
    depths = unique(data.height);                                           % if only one recording depth is selected, all data is considered
    vlp_ch = {'central', 'anterior', 'medial', 'posterior', 'lateral'};     % select all channels
end

if numel(depths) > 1                                                        % if depths is more than integer (i.e. range), a vector is created to find indices of interes later
    depths = depths(1):depths(end);
end
data_preproc = data;                                                         % copies data so that later data can be selected here

%% Start creating index in order to reduce data size and only select channels and recordings depths of interest
[idxtemp,~] = ismember(data.height, depths);
idx_height = find(idxtemp);                                                 % indices corresponding to

ind_vlp = find(cell2mat(arrayfun(@(q) contains(data.label{q}, vlp_ch), ...
    1:numel(data.label), 'Un', 0)));
ind_emg = find(cell2mat(arrayfun(@(q) contains(data.label{q}, {'EDC', 'FDL'}), ...
    1:numel(data.label), 'Un', 0)));

if isempty(ind_emg)                                                         % if there was no EMG data, only vlp indices are considered
    idx_tot = ind_vlp;                                                      % otherwise data is concatenated to total index (ind_tot)
else
    idx_tot = [ind_vlp, ind_emg];
end

%% preprocess data so that result fits to settings
data_preproc.trial = arrayfun(@(q) data_preproc.trial{q}(:,idx_tot), ...
    idx_height, 'Un', 0); 
data_preproc.time = ...
    arrayfun(@(q) data_preproc.time{q}, idx_height, 'Un', 0);
data_preproc.trialinfo = data_preproc.trialinfo(idx_height);
data_preproc.label = arrayfun(@(q) data_preproc.label{q}, ...
    idx_tot, 'Un', 0);
data_preproc.height = data_preproc.height(idx_height);

