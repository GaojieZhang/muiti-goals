% Copyright (C) 2010 Benny Raphael

% This is a sample cost function
% The actual  costFunction should be defned by the user and the pointer should be provided in the ProblemSetup structure
% argument 1: structure ProblemSetup
% argument 2: x - values of variables in the proposed new solution
% returns the evaluation of the point 
function ret  = costFunction (setup, x)
	x1 = x(1);
	x2 = x(2);

	ret = (x1-0.5)* (x1-0.5) + (x2-0.1)* (x2-0.1) ;
   
end
