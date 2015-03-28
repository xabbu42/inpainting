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
tc.verifyThat(     forx(m, 0), IsEqualTo( [1 1 -3; 1 1 -6; 1 1 -9] ), 'forward difference x, zero boundary' );
tc.verifyThat(     fory(m, 0), IsEqualTo( [3 3 3; 3 3 3; -7 -8 -9] ), 'forward difference x, zero boundary' );
tc.verifyThat( centralx(m, 0), IsEqualTo( [2 2 -2; 5 2 -5; 8 2 -8] ), 'central difference x, zero boundary' );
tc.verifyThat( centraly(m, 0), IsEqualTo( [4 5 6; 6 6 6; -4 -5 -6] ), 'central difference x, zero boundary' );

tc.verifyThat( backx(m, 1), IsEqualTo( [0 1 1; 3 1 1; 6 1 1] ),    'backward difference x, 1 boundary' );
tc.verifyThat( backy(m, 1), IsEqualTo( [0 1 2; 3 3 3; 3 3 3] ),    'backward difference x, 1 boundary' );
tc.verifyThat(  forx(m, 1), IsEqualTo( [1 1 -2; 1 1 -5; 1 1 -8] ), 'forward difference x, 1 boundary' );
tc.verifyThat(  fory(m, 1), IsEqualTo( [3 3 3; 3 3 3; -6 -7 -8] ), 'forward difference x, 1 boundary' );

tc.verifyThat( backx(m, 'replicate'), IsEqualTo( [0 1 1; 0 1 1; 0 1 1] ), 'backward difference x, constant boundary' );
tc.verifyThat( backy(m, 'replicate'), IsEqualTo( [0 0 0; 3 3 3; 3 3 3] ), 'backward difference x, constant boundary' );
tc.verifyThat(  forx(m, 'replicate'), IsEqualTo( [1 1 0; 1 1 0; 1 1 0] ), 'forward difference x, constant boundary' );
tc.verifyThat(  fory(m, 'replicate'), IsEqualTo( [3 3 3; 3 3 3; 0 0 0] ), 'forward difference x, constant boundary' );

% gradient descent to given target

cost = @(u) sqrt(qnorm2(u - m));
grad = @(u) (1/ cost(u)) * (u - m);
[res, meta] = gradient_descent([0 0 0; 0 0 0; 0 0 0], cost, grad, 'iterations', 100, 'error', 3e-6);
tc.verifyThat( res, IsEqualTo(m, 'Within', AbsoluteTolerance(3e-5)), 'gradient descent to given target' );
tc.verifyThat( meta.it, IsLessThan(50), '... converged before 50 steps' );
tc.verifyThat( meta.error, IsLessThan(3e-6), '... has small enough error' );

