function [mtrc, f] = metric_estimate(dat, fs, metric, norm)

% INPUT:
%   - dat       = dataset from which metric will be computed
%   - fs        = sampling frequency
%   - metric    = metric to be estimated ('psd', 'coh')
%   - norm      = normalisation to M = 0, STD = 1 (boolean)

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

if norm == 1
    fx_norm = @(x) (x-nanmean(x))./nanstd(x);
else
    fx_norm = @(x) x;
end

% General settings
ch = size(dat{1},2);
nwin    = fs;                                                             % start estimating PSD using welch's method with half a second
overlap = nwin/2;                                                           % windows and 50%-overlap
freq    = 1:.5:100;                                                         % frequency vector

switch metric
    case 'psd'
        fprintf('\n estimating PSD for all channels ...')
        [psd,fall]    = arrayfun(@(q) ...                                   % estimate PSD via Welch's method
            pwelch(fx_norm(dat{q}), nwin, overlap, freq, fs), ...
            1:numel(dat), 'Un', 0);
        
        mtrc = cell(1,numel(dat));                                         % create identity matrix with psd values
        for n = 1:numel(dat)
            for nch = 1:ch
                mtrc{1,n}{nch,nch}= psd{1,n}(:,nch);
            end
        end
        f = fall{1};
        fprintf('DONE! ...\n')
        
    case 'coh'
        [mtrc, f] = metric_estimate(dat, fs, 'psd', 1);                     % the diagonal is the PSD estimate from the first part of the script
        idx = triu(ones(size(dat{1},2)), 1);                                % upper diagonal used to estimate
        
        fprintf('\n estimating coherence between all channels ...\n')
        p = progressbar( numel(dat)*sum(idx(:)), 'percent' ); iter= 0;      % JSB routine for progress bars
        for depth = 1:numel(dat)
            for row = 1:ch
                for col = 1:ch
                    if idx(row, col)==0
                        continue
                    else
                        iter = iter+1;
                        p.update( iter )
                        [mtrc{depth}{row,col}, f] = ...
                            mscohere(fx_norm(dat{depth}(:,row)), ...
                            fx_norm(dat{depth}(:,col)), ...
                            nwin, overlap, freq, fs);
                    end
                end
            end
        end
        p.stop()
        fprintf('DONE! ...\n')
        
    case 'pcd'
        fprintf('\n not yet implemented, returning ...\n')
        return
end