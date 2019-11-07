function [mtrc, f] = metric_estimate(dat1, dat2, fs, metric, norm)

% INPUT:
%   - dat1/2    = datasets from which metric will be computed
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

switch metric
    case 'psd'
        if ~isemtpy(dat2)
            warning('only data from first inpu will be preocessed')
        end
        
        [mtrc,f] = pwelch(fx_norm(dat1), window, .5, [0 100], fs);

    case 'coh'
        if (isemtpy(dat2) || isnan(dat2))
            error('two different datasets are required for estimating coherence')
        end
        
end