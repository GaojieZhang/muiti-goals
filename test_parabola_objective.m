% Copyright (C) 2010 Benny Raphael

% This is a test function used evaluate the performance of PGSL
function ret  = test_parabola_objective (setup, x)


	x1 = x(1);
	x2 = x(2);

	ret = x1*x1 + x2*x2;
   

end
