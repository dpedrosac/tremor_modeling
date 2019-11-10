function visualise_data(trials, time, height, label, trialinfo, fsample, metric)

% INPUT:
%   -

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

idx_vlp = find(cell2mat(arrayfun(@(q) contains(label{q}, ...
    {'central', 'anterior', 'medial', 'posterior', 'lateral'}), ...
    1:numel(label), 'Un', 0)));
idx_emg = find(cell2mat(arrayfun(@(q) contains(label{q}, {'EDC', 'FDL'}), ...
    1:numel(label), 'Un', 0)));

if isempty(idx_emg)
    nCol = 1;
else
    nCol = 2;
end

if isempty(idx_vlp)
    warning('No VLp data was selected')
end

switch metric
    case 'raw'
        x = trials; y = time;
        tit1 = 'Power of VLp/EMG-recordings at ';
    case 'psd'
        
        
end

% loads general information for plotting and estimating rows and columns
p   = figure_params_gen;                                                    % load general parameters for plots
nRow = size(x{1},2) - numel(idx_emg);                                       % number of rows
rowH = 0.7 / nRow ;  colW = 0.85 / nCol ;                                   % defines the row-height and the column-width for the subplots
colX = 0.15 + linspace( 0, 0.96, nCol+1 ) ;  colX = colX(1:end-1);          % array defining the settings for the subplots
rowY = 0.1 + linspace( 0.9, 0, nRow+1 ) ;  rowY = rowY(2:end) ;

for k = 1:size(trials,2)
    if trialinfo(k) == 11
        tit2 = strcat(num2str(height(k)), 'mm, rest-condition');
    else
        tit2 = strcat(num2str(height(k)), 'mm, postural tremor');
    end
    
    figure(100+k); clf;                                                        % create one figure for all data (ch x cond design)
    set( gcf, 'Color', 'White', 'Unit', 'Normalized', ...
        'Position', [0.1,0.1,0.6,0.6] ) ;
    iter =0;
    for dId = 1:size(x{1},2) % loop through channels that will be plotted
        iter = iter + 1;
        colId = 1;
        
        if ismember(dId, idx_vlp); rowId = dId; end
        if contains(label{dId}, 'EDC'); rowId = 1; colId = 2; end
        if contains(label{dId}, 'FDL'); rowId = 2; colId = 2; end
        
        ax(dId) = axes( 'Position', [colX(colId), rowY(rowId), colW, rowH] );
        m(dId) = plot(y{k}, x{k}(:, dId), ...                                   % plot average ERP result with a line color depending on the group
            'Color', p.colors{1}); hold on; set(gca, 'XMinorTick', 'on')
        
        plot([y{k}(1) y{k}(end)], [0 0], 'k');
        grid on; box off;
        ylabel(label{dId}, 'FontName', p.ftname, 'FontSize', p.ftsize(2));
                
        if rowId == 1
            axes( 'Position', [colX(colId), .95, colW, rowH] ) ;
            set( gca, 'Color', 'None', 'XColor', 'White', 'YColor', 'White' ) ;
        elseif rowId == numel(idx_vlp)
            xlabel('time [in s.]', 'FontName', p.ftname, 'FontSize', p.ftsize(2));
        end
    end
    
    % - Build title axes and title.
    axes( 'Position', [0, 0.95, 1, 0.05] ) ;
    set( gca, 'Color', 'None', 'XColor', 'White', 'YColor', 'White' ) ;
    text( 0.5, 0, strcat(tit1, tit2), 'FontName', p.ftname, 'FontSize', p.ftsize(2), 'FontWeight', 'Bold', ...
        'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom' ) ;
    linkaxes(ax, 'x')
end