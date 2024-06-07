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

function [fit,sub_IGD,P_1] =MaOALO(FUN, lb,ub,numObj,Max_iter,SearchAgents_no,dim)
%% Initialization
Iter=0;
sub_IGD=[];
fit = -inf*ones(SearchAgents_no, numObj);
while Iter<Max_iter    
    if Iter==0
       Positions=initialization(SearchAgents_no,dim,ub,lb);
       [Z,SearchAgents_no] = UniformPoint(SearchAgents_no,numObj); 
       [subfit, ~,~] = MOFcn(FUN, Positions, numObj);
       Zmin  = min(subfit,[],1); 
       Positions=EnvironmentalSelection(FUN,Positions,SearchAgents_no,numObj,Z,Zmin);
       New_pos=Positions; 
    end
     Sorted_antlions=repmat(New_pos(randi(SearchAgents_no),:),SearchAgents_no,1);
        % Update Positions using ALO's mechanism
        Current_iter = Iter + 1;
        for i = 1:SearchAgents_no
            Rolette_index = RouletteWheelSelection(1 ./ Zmin);
            if Rolette_index == -1
                Rolette_index = 1;
            end
            RA = Random_walk_around_antlion(dim, Max_iter, lb, ub, Sorted_antlions(Rolette_index, :), Current_iter);
            RE = Random_walk_around_antlion(dim, Max_iter, lb, ub, Positions, Current_iter);
            Positions(i, :) = (RA(Current_iter, :) + RE(Current_iter, :)) / 2;
        end       
  for i=1:size(Positions,1)  
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;    
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;  
  end 
  Ant_evo=Positions;
  Ant_gau = Gaussian_search(Positions,SearchAgents_no,dim,ones(1,dim).*ub,ones(1,dim).*lb);
     two_Ant = [New_pos;Ant_evo;Ant_gau];     
     two_loc=unique(two_Ant,'rows');
     [subfit,~ ,P_1] = MOFcn(FUN, two_loc, numObj);
     Zmin       = min([Zmin;subfit],[],1);
     Positions=EnvironmentalSelection(FUN,two_loc,SearchAgents_no,numObj,Z,Zmin);
     [fit, ~,~] = MOFcn(FUN, Positions, numObj);
     New_pos=Positions;
     sub_IGD(Iter+1)=IGD(fit,P_1);
  Iter=Iter+1;  
  Iter    
end
end

function [RWs] = Random_walk_around_antlion(Dim, max_iter, lb, ub, antlion, current_iter)
    if size(lb, 1) == 1 && size(lb, 2) == 1 
        lb = ones(1, Dim) * lb;
        ub = ones(1, Dim) * ub;
    end
    if size(lb, 1) > size(lb, 2) 
        lb = lb';
        ub = ub';
    end
    I = 1; 
    if current_iter > max_iter / 10
        I = 1 + 100 * (current_iter / max_iter);
    end
    if current_iter > max_iter / 2
        I = 1 + 1000 * (current_iter / max_iter);
    end
    if current_iter > max_iter * (3 / 4)
        I = 1 + 10000 * (current_iter / max_iter);
    end
    if current_iter > max_iter * (0.9)
        I = 1 + 100000 * (current_iter / max_iter);
    end
    if current_iter > max_iter * (0.95)
        I = 1 + 1000000 * (current_iter / max_iter);
    end
    lb = lb / (I); 
    ub = ub / (I); 
    if rand < 0.5
        lb = lb + antlion; 
    else
        lb = -lb + antlion;
    end
    if rand >= 0.5
        ub = ub + antlion; 
    else
        ub = -ub + antlion;
    end
    for i = 1:Dim
        X = [0 cumsum(2 * (rand(max_iter, 1) > 0.5) - 1)']; 
        a = min(X);
        b = max(X);
        c = lb(i);
        d = ub(i);      
        X_norm = ((X - a) * (d - c)) / (b - a) + c; 
        RWs(:, i) = X_norm;
    end
end

function choice = RouletteWheelSelection(weights)
    accumulation = cumsum(weights);
    p = rand() * accumulation(end);
    chosen_index = -1;
    for index = 1 : length(accumulation)
        if (accumulation(index) > p)
            chosen_index = index;
            break;
        end
    end
    choice = chosen_index;
end





function Prey = Gaussian_search(Prey,SearchAgents_no,dim,ub,lb)
    for i=1:SearchAgents_no
        d=randperm(dim,1);
        Prey(i,d)=Prey(i,d)+(ub(d)-lb(d))*randn;
    end

    for i=1:size(Prey,1)  
            Flag4ub=Prey(i,:)>ub;
            Flag4lb=Prey(i,:)<lb;    
            Prey(i,:)=(Prey(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;  
    end 
end


function Positions=initialization(SearchAgents_no,dim,ub,lb)
Boundary_no= size(ub,2); 
if Boundary_no==1
     Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
end
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
         Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;      
    end
end
end



