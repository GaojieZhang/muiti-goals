% Copyright (C) 2010 Benny Raphael

% Returns an instance of the the structure ProblemSetup representing an optimization problem
% arg 1: array containing the minimum value (lower bound) of each variable 
% arg 2: array containing the maximum value (upper bound )of each variable 
% arg 3: array containing the precision of each variable 
% arg 4: the maximum number of evaluations of the objective function
% arg 5: the threshold of the objective function
% Note that the number of variables is taken as the size of the array min
% returns the structure ProblemSetup
% 
function  ret  = ProblemSetup_create (min, max, precision, numeval, threshold)
	numvars = length(min);
	
	% The number of optimization variables
	ret.numvars = numvars;

	% Maximum number of evaluations of the objective function
	ret.maxNumEvaluations = numeval;
	
	% The threshold of the objective function below which search terminates
	ret.threshold = threshold;
	
	% The uppper and lower bounds of variables
	ret.lowerBounds = min;
	ret.upperBounds = max;
	
	for i=1:numvars
		% The axis representing each variable - is of type structure PAxis.
		ret.axes(i) = PAxis_create(min(i),max(i),precision(i) );
	end
	
	% Default values for the optimization parameters
	ret.NS = 2;
	ret.NPUC=1;
	ret.NFC=20*numvars;
	
	nsdc = floor( numeval/(ret.NS*ret.NPUC*ret.NFC) );
	if (nsdc < 1) 
		nsdc = 1;
	end
		
	ret.NSDC = nsdc;
	
	% The user should set the following variable to 1, if an initial starting point is to be used
	ret.useStartPoint = 0;
	
	% The number of evaluations of the objective function
	ret.numEvaluations = 0;
	
	% The following variables are assigned during the search
	% Current number of iterations in the SDC
	ret.iSDC = 0;
	% Current number of iterations in the Sampling Cycle
	ret.iS = 0;
	
	% This variable is set to non-zero whenever there is a restart after convergence
	ret.restart = 0;
	
	% Initial minimum point - the objective function is not called yet
	ret.minimumPoint = Point_create(numvars);
	
	% This variable stores the previous best minimum point when a restart occurs after convergence
	ret.backupMinimumPoint = ret.minimumPoint;
	
	% The pointer (handle) to the objective function
	% User should assign his objective function to this variable
	ret.costFunction = @costFunction;

end
