%___________________________________________________________________%
%  Many-objective Ant Lion Optimizer (MaOALO) source codes          %
%                                                                   %
%  Developed in MATLAB R2023b                                       %
%                                                                   %
%  Author and programmer: Pradeep Jangir and Kanak Kalita           %
%                                                                   %
%         e-Mail: pkjmtech@gmail.com                                %
%   Main paper:                                                     %
%                                                                   %
%   Many-Objective Ant Lion Optimizer (MaOALO): A new many-objective%
%   optimizer with its engineering applications                     %
%   Heliyon                %
%                                                                   %
%___________________________________________________________________%

clear, clc
a_MaOALO=[];
 for i=1:1
    FUN='DTLZ2';
    numObj=5;
    dim=10;
    lb =zeros(1,dim);
    ub =1*ones(1,dim);%
    Max_iter=500;
    SearchAgents_no=100;
    [fit,IGD,P] = MaOALO(FUN,lb,ub,numObj,Max_iter,SearchAgents_no,dim);
         i
    a_MaOALO(i) = IGD(end);
 end
a_MaOALO
b1=mean(a_MaOALO);
b2=std(a_MaOALO);
if numObj == 3
    plot3(fit(:, 1), fit(:, 2), fit(:, 3), 'ro', 'LineWidth', 1, ...
        'MarkerEdgeColor', 'r', ...
        'MarkerFaceColor', 'r', ...
        'Marker', 'o', ...
        'MarkerSize', 5);
    hold on;
    plot3(P(:, 1), P(:, 2), P(:, 3), '.', 'color', 'k');
    legend('Obtained PF', 'True PF');
    title('MaOALO');
    xlabel('obj_1');
    ylabel('obj_2');
    zlabel('obj_3');
    box on;
elseif numObj == 2
    plot(fit(:, 1), fit(:, 2), 'ro', 'LineWidth', 1, ...
        'MarkerEdgeColor', 'r', ...
        'MarkerFaceColor', 'r', ...
        'Marker', 'o', ...
        'MarkerSize', 5);
    hold on;
    plot(P(:, 1), P(:, 2), 'Color', 'k', 'LineWidth', 4);
    legend('Obtained PF', 'True PF');
    title('MaOALO');
    xlabel('obj_1');
    ylabel('obj_2');
    box on;
else
    Data = [fit; P];
    Group = [repmat({'Obtained PF'}, size(fit, 1), 1); repmat({'True PF'}, size(P, 1), 1)];
    figure;
    Draw(Data, {'Dimension No.', 'Value', []});
    legend('MaOALO-Obtained PF');
    title('MaOALO');
end


