% Copyright (C) 2010 Benny Raphael

% This function is an internal routine of PGSL
% It performs the subdomain cycle
% argument 1: structure ProblemSetup
% returns the updated ProblemSetup structture
function ret  = PGSL_doSubdomainCycle (setup)

	ret = setup;
	

	bestpoint = 1;
	NSDC = ret.NSDC;
    for iSDC = 1:NSDC
	
		ret.iSDC = iSDC;

		% Calculate the number of runs since the last restart
		if (ret.restart == 0) 
			run = ret.iSDC;
		else
			run = ret.iSDC - ret.restart;
		end

		if iSDC == 1 & ret.useStartPoint == 1 
			% the start point is already in the variable ret.minimumPoint
			% No need to generate a new start point
		else
			% Generate a new point
			ret.minimumPoint = PGSL_generatePoint(ret, ret.minimumPoint);
			ret.numEvaluations = ret.numEvaluations +1;
		end
		pt = ret.minimumPoint;
		
		ret = PGSL_doFocusingCycle(ret, ret.lowerBounds, ret.upperBounds, pt);

		% V4.2 sampling
		if (run > 1) 
		if (ret.minimumPoint.y > savedpoints(bestpoint).y)
			numVars = ret.numvars;
			startPoint = savedpoints(bestpoint);
			pt = ret.minimumPoint;
			for i = 1:numVars

				if ret.numEvaluations > ret.maxNumEvaluations 
					break
				end
						
				x0 = startPoint.x(i);
				if ( abs(x0 - ret.minimumPoint.x(i) ) < ret.axes(i).precision )
					continue;
				end
				
				xold = pt.x(i);
				pt.x(i) = x0;
				pt.y = setup.costFunction(setup, pt.x);
				ret.numEvaluations = ret.numEvaluations +1;
				if ret.minimumPoint.y > pt.y 
					ret.minimumPoint = pt;
					% fprintf(1, 'v4.2s   %d %f \t %d %d \n', ret.numEvaluations, pt.y, ret.iSDC, i );
				else
					pt.x(i) = xold;
				end
				
				if (ret.minimumPoint.y <= ret.threshold) 
					break;
				end
				
			end
		end 
		end
		% ------------------------- end of V4.2 sampling
		
       
		if (run == 1)  
			savedpoints(bestpoint) = ret.minimumPoint;
		else  
			% Saving the best 5 points in the ascending order
			numsaved = min( [5 (run-1) ]);
			savedpoints = PGSL_sortBestPoints(numsaved, savedpoints, ret.minimumPoint);		
			numsaved = min( [5 run]);  % incrementing if necessary
		end
		
		% Checking terminating condition
		if (ret.minimumPoint.y <= ret.threshold) 
			break;
		end

		if (run > 1 & run < ret.NSDC)  
			if (PGSL_hasConverged(ret.axes) )  
				PGSL_doRestart(ret, savedpoints(bestpoint) );
			else 
				PGSL_narrowDown(ret, savedpoints, numsaved);
			end
		end

	end

	% Storing the minimum of all the focusing cycles in the ret.minimumPoint
	ret.minimumPoint = savedpoints(bestpoint);
	if (ret.restart > 0)  
		if (ret.backupMinimumPoint.y < ret.minimumPoint.y)  
			ret.minimumPoint = ret.backupMinimumPoint;
		end
	end

   
end
