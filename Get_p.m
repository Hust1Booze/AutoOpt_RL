function [outputArg1] = Get_p(varargin)
%GET_P 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin == 0 % call the GUI
    APP;
else 
    % get mode
    if any(strcmp(varargin,'Mode'))
        Setting = struct;
        ind = find(strcmp(varargin,'Mode'));
        Setting.Mode = varargin{ind+1};
    else
        error('Please set the mode to "design" or "solve".');
    end

    % get problem
    if strcmp(Setting.Mode,'design')
        [prob,instanceTrain,instanceTest] = Input(varargin,Setting,'data');

    elseif strcmp(Setting.Mode,'solve')
        [prob,instanceSolve] = Input(varargin,Setting,'data');
    end

    if any(strcmp(varargin,'Action'))
        ind = find(strcmp(varargin,'Action'));
        Setting.Action = varargin{ind+1};
    end

    % default parameters
    switch Setting.Mode
        case 'design'
            Setting.AlgP     = 1;
            Setting.AlgQ     = 3;
            Setting.Archive  = '';
            Setting.IncRate  = 0.05;
            Setting.ProbN    = 20;
            Setting.ProbFE   = 2000;
            Setting.InnerFE  = 200;
            Setting.AlgN     = 5;
            Setting.AlgFE    = 2000;
            Setting.AlgRuns  = 5;
            Setting.Metric   = 'quality'; % quality/runtimeFE/runtimeSec/auc
            Setting.Generate = 'get-p';   % search/learn
            Setting.Evaluate = 'exact';   % exact/approximate/intensification/racing
            Setting.Compare  = 'average'; % average/statistic
            Setting.Tmax     = [];
            Setting.Thres    = [];
            Setting.LSRange  = 0.3;
            Setting.RacingK  = max(1,round(length(instanceTrain)*0.2)); 
            Setting.Surro    = Setting.ProbFE*0.3;
            Setting          = Input(varargin,Setting,'parameter'); % replace default parameters with user-defined ones
            Setting          = Input(Setting,'check'); % avoid conflicting parameter settings
            outputArg1  = Process(prob,instanceTrain,instanceTest,Setting);

        case 'solve'
            Setting.Mode = 'solve';
            Setting.AlgFile  = '';
            Setting.AlgName  = 'Continuous Genetic Algorithm';
            Setting.Metric   = 'quality';
            Setting.Tmax     = [];
            Setting.Thres    = [];
            Setting.ProbN    = 100;
            Setting.ProbFE   = 50000;
            Setting.AlgRuns  = 31;
            Setting          = Input(varargin,Setting,'parameter');
            Setting          = Input(Setting,'check');
            [bestSolutions,allSolutions] = Process(prob,instanceSolve,Setting);
            Output(bestSolutions,allSolutions,instanceSolve,Setting);
    end
end
end
