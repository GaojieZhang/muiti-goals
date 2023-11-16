% Copyright (C) 2010 Benny Raphael

% This function is the main entry point to PGSL
% This should be called after creating the ProblemSetup structure, set all the parameters, cost function, etc.
% argument 1: structure ProblemSetup
% returns the updated ProblemSetup structture
function ret  = PGSL_findMinimum (setup)

	% Could insert some code to check for errors etc. here

	ret = PGSL_doSubdomainCycle(setup);

   
end
