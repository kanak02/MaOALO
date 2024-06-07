function currentAxes = Draw(Data,varargin)
%Draw - Display data.
%------------------------------- Copyright --------------------------------
% Copyright (c) 2024 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    persistent ax;
    if length(Data) == 1 && isgraphics(Data)
        ax = Data;
        cla(ax);
    elseif ~isempty(Data) && ismatrix(Data)
        if isempty(ax) || ~isgraphics(ax)
            ax = gca;
        end
        if size(Data,2) == 1
            Data = [(1:size(Data,1))',Data];
        end
        set(ax,'FontName','Times New Roman','FontSize',13,'NextPlot','add','Box','on','View',[0 90],'GridLineStyle','none');
        if islogical(Data)
            [ax.XLabel.String,ax.YLabel.String,ax.ZLabel.String] = deal('Solution No.','Objective Fn NO.',[]);
        elseif size(Data,2) > 3
            [ax.XLabel.String,ax.YLabel.String,ax.ZLabel.String] = deal('Objective Fn NO.','Objective Fn Value',[]);
        elseif ~isempty(varargin) && iscell(varargin{end})
            [ax.XLabel.String,ax.YLabel.String,ax.ZLabel.String] = deal(varargin{end}{:});
        end
        if ~isempty(varargin) && iscell(varargin{end})
            varargin = varargin(1:end-1);
        end
        if isempty(varargin)
            if islogical(Data)
                varargin = {'EdgeColor','none'};
            elseif size(Data,2) == 2
                varargin = {'o','MarkerSize',6,'Marker','o','Markerfacecolor',[.7 .7 .7],'Markeredgecolor',[.4 .4 .4]};
            elseif size(Data,2) == 3
                varargin = {'o','MarkerSize',8,'Marker','o','Markerfacecolor',[.7 .7 .7],'Markeredgecolor',[.4 .4 .4]};
            elseif size(Data,2) > 3
                varargin = {'-','LineWidth',2};
            end
        end
        if islogical(Data)
            C = zeros(size(Data)) + 0.6;
            C(~Data) = 1;
            surf(ax,zeros(size(Data')),repmat(C',1,1,3),varargin{:});
        elseif size(Data,2) == 2
            plot(ax,Data(:,1),Data(:,2),varargin{:});
        elseif size(Data,2) == 3
            plot3(ax,Data(:,1),Data(:,2),Data(:,3),varargin{:});
            view(ax,[135 30]);
        elseif size(Data,2) > 3
            Label = repmat([0.99,2:size(Data,2)-1,size(Data,2)+0.01],size(Data,1),1);
            Data(2:2:end,:)  = fliplr(Data(2:2:end,:));
            Label(2:2:end,:) = fliplr(Label(2:2:end,:));
            plot(ax,reshape(Label',[],1),reshape(Data',[],1),varargin{:});
        end
        axis(ax,'tight');
        set(ax.Toolbar,'Visible','off');
        set(ax.Toolbar,'Visible','on');
    end
    currentAxes = ax;
end