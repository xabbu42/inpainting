import matlab.unittest.TestCase
import matlab.unittest.constraints.IsEqualTo
import matlab.unittest.constraints.AbsoluteTolerance
import matlab.unittest.constraints.IsLessThan

tc = TestCase.forInteractiveUse;

import_common();

m = [1 2 3; 4 5 6; 7 8 9];
tc.verifyThat( sum2(m), IsEqualTo(45), 'sum2');
tc.verifyThat( msum(m), IsEqualTo(45), 'msum');
tc.verifyThat( qnorm2(m), IsEqualTo(sum((1:9) .^ 2)), 'qnorm2');

tc.verifyThat(    backx(m, 0), IsEqualTo( [1 1 1; 4 1 1; 7 1 1] ),    'backward difference x, zero boundary' );
tc.verifyThat(    backy(m, 0), IsEqualTo( [1 2 3; 3 3 3; 3 3 3] ),    'backward difference x, zero boundary' );
tc.verifyThat(    forwx(m, 0), IsEqualTo( [1 1 -3; 1 1 -6; 1 1 -9] ), 'forward difference x, zero boundary' );
tc.verifyThat(    forwy(m, 0), IsEqualTo( [3 3 3; 3 3 3; -7 -8 -9] ), 'forward difference x, zero boundary' );
tc.verifyThat( centralx(m, 0), IsEqualTo( [2 2 -2; 5 2 -5; 8 2 -8] ), 'central difference x, zero boundary' );
tc.verifyThat( centraly(m, 0), IsEqualTo( [4 5 6; 6 6 6; -4 -5 -6] ), 'central difference x, zero boundary' );

tc.verifyThat( backx(m, 1), IsEqualTo( [0 1 1; 3 1 1; 6 1 1] ),    'backward difference x, 1 boundary' );
tc.verifyThat( backy(m, 1), IsEqualTo( [0 1 2; 3 3 3; 3 3 3] ),    'backward difference x, 1 boundary' );
tc.verifyThat( forwx(m, 1), IsEqualTo( [1 1 -2; 1 1 -5; 1 1 -8] ), 'forward difference x, 1 boundary' );
tc.verifyThat( forwy(m, 1), IsEqualTo( [3 3 3; 3 3 3; -6 -7 -8] ), 'forward difference x, 1 boundary' );

tc.verifyThat( backx(m, 'replicate'), IsEqualTo( [0 1 1; 0 1 1; 0 1 1] ), 'backward difference x, constant boundary' );
tc.verifyThat( backy(m, 'replicate'), IsEqualTo( [0 0 0; 3 3 3; 3 3 3] ), 'backward difference x, constant boundary' );
tc.verifyThat( forwx(m, 'replicate'), IsEqualTo( [1 1 0; 1 1 0; 1 1 0] ), 'forward difference x, constant boundary' );
tc.verifyThat( forwy(m, 'replicate'), IsEqualTo( [3 3 3; 3 3 3; 0 0 0] ), 'forward difference x, constant boundary' );

n = 10 * rand(4) - 5;
tau = forw_variation(n);
tc.verifyThat(tau(2,2), IsEqualTo(sqrt((n(3,2) - n(2,2))^2 + (n(2,3) - n(2,2))^2), 'Within', AbsoluteTolerance(1e-4)), 'forward variatien inside');
tc.verifyThat(tau(4,2), IsEqualTo(sqrt((     0 - n(4,2))^2 + (n(4,3) - n(4,2))^2), 'Within', AbsoluteTolerance(1e-4)), 'forward variation border');

grad = forw_total_variation_grad(n);
tc.verifyThat(grad(2,2), IsEqualTo((1/tau(2,2)) * (2 * n(2,2) - n(3,2) - n(2,3)) + (1/tau(1,2)) * (n(2,2) - n(1,2)) + (1/tau(2,1)) * (n(2,2) - n(2,1)), 'Within', AbsoluteTolerance(1e-8)), 'forward total variation gradient inside');
tc.verifyThat(grad(3,2), IsEqualTo((1/tau(3,2)) * (2 * n(3,2) - n(4,2) - n(3,3)) + (1/tau(2,2)) * (n(3,2) - n(2,2)) + (1/tau(3,1)) * (n(3,2) - n(3,1)), 'Within', AbsoluteTolerance(1e-8)), 'forward total variation gradient inside');

% gradient descent to given target

cost = @(u) qnorm2(u - m);
grad = @(u) 2 * (u - m);
doit = @() gradient_descent([0 0 0; 0 0 0; 0 0 0], cost, grad, 'iterations', 200, 'error', 3e-6);

[res, meta] = doit();
meta
tc.verifyThat( res, IsEqualTo(m, 'Within', AbsoluteTolerance(3e-5)), 'gradient descent to given target' );
tc.verifyThat( meta.it, IsLessThan(200), '... converged before 200 steps' );
tc.verifyThat( meta.error, IsLessThan(3e-6), '... has small enough error' );

time = timeit(doit);
time

% gradient descent to given random target

target = 10*rand(10, 20) - 5;
cost = @(u) qnorm2(u - target);
grad = @(u) 2 * (u - target);
doit = @() gradient_descent(ones(10, 20), cost, grad, 'iterations', 200, 'error', 3e-6);

[res, meta] = doit();
meta
tc.verifyThat( res, IsEqualTo(target, 'Within', AbsoluteTolerance(3e-4)), 'gradient descent to given random target' );
tc.verifyThat( meta.it, IsLessThan(200), '... converged before 200 steps' );
tc.verifyThat( meta.error, IsLessThan(3e-6), '... has small enough error' );

time = timeit(doit);
time

% gradient descent to given big random target

target = 10*rand(200, 400) - 5;
cost = @(u) qnorm2(u - target);
grad = @(u) 2 * (u - target);
doit = @() gradient_descent(ones(200, 400), cost, grad, 'iterations', 10000, 'error', 3e-10);

[res, meta] = doit();
meta
tc.verifyThat( res, IsEqualTo(target, 'Within', AbsoluteTolerance(3e-4)), 'gradient descent to given big random target' );
tc.verifyThat( meta.error, IsLessThan(3e-6), '... has small enough error' );

% gradient descent to least mean squares linear approx (from exercise 1, week 2)

areas  = [50,52,24,150,80,76,77,120,115,65,61,30];
prices = [392,245,135,1800,579,655,653,1276,1108,566,477,176];
N = length(areas);

% normalize
areasN  = (areas - min(areas)) / (max(areas) - min(areas));
pricesN = (prices - min(prices)) / (max(prices) - min(prices));

X = [ones(N,1), areasN'];
Y = pricesN';
cost = @(u) (1/N) * 0.5 * qnorm2(u * X' - Y');
grad = @(u) (1/N) * (u * X' - Y') * X;
doit = @() gradient_descent([0 0], cost, grad, 'iterations', 100, 'error', 0);

[res, meta] = doit();
meta
tc.verifyThat( res, IsEqualTo([-0.074231268042242;0.980023444518299]', 'Within', AbsoluteTolerance(1e-10)), 'gradient descent to least mean squares linear approx (from exercise 1, week 2)' );
tc.verifyThat( meta.it, IsEqualTo(100), '... made exactly 100 steps' );
time = timeit(doit);
time

% gradient descent to flat 0
cost = forw_total_variation;
grad = forw_total_variation_grad;
doit = @() gradient_descent(m, cost, grad, 'iterations', 1000, 'error', 1e-6);
[res, meta] = doit();
meta
tc.verifyThat( res, IsEqualTo(zeros(3), 'Within', AbsoluteTolerance(1e-6)), 'gradient descent to flat zero with total variation');
tc.verifyThat( meta.it, IsLessThan(800), '... converged before 800 steps' );
tc.verifyThat( meta.error, IsLessThan(1e-6), '... has small enough error' );

% gradient descent to flat with replicated border
cost = @(u) forw_total_variation(u, 'replicate');
grad = @(u) forw_total_variation_grad(u, 'replicate');
doit = @() gradient_descent(m, cost, grad, 'iterations', 500, 'error', 1e-6);
[res, meta] = doit();
meta
tc.verifyThat( res, IsEqualTo(res(1,1) * ones(3), 'Within', AbsoluteTolerance(1e-6)), 'gradient descent to flat with replicated border');
tc.verifyThat( meta.it, IsLessThan(400), '... converged before 400 steps' );
tc.verifyThat( meta.error, IsLessThan(1e-6), '... has small enough error' );

% gradient descent to flat larger matrix
start = 10 * rand(20, 40);
cost = @(u) forw_total_variation(u, 'replicate');
grad = @(u) forw_total_variation_grad(u, 'replicate');
doit = @() gradient_descent(start, cost, grad, 'iterations', 2000, 'error', 5e-4, 'plot', 1);
[res, meta] = doit();
meta
tc.verifyThat( res, IsEqualTo(res(1,1) * ones(20, 40), 'Within', AbsoluteTolerance(1e-2)), 'gradient descent to flat with total variation');
tc.verifyThat( meta.it, IsLessThan(1500), '... converged before 1500 steps' );
tc.verifyThat( meta.error, IsLessThan(1e-5), '... has small enough error' );
