function p = figure_params_gen

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

params = {};
params.ftname = 'Georgia';
params.ftsize = [14, 19, 24];
params.greys = {24./255*ones(1,3), 84./255*ones(1,3), 144./255*ones(1,3), 201./255*ones(1,3)};  % different grey tones for data
params.colors = {[207 68 44], [103 138 23], [255 118 95], [85 115 171], [24 47 89]};
params.colors = cellfun(@(x) x./255, params.colors, 'Un', 0);
params.lnsize = [.35, .75, 1.5];
params.symbols = {'.', 's', '^','o'};

p = params; clear params