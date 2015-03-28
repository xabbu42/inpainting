function msg = imporconvt_common()
% defines some helper functions
assignin('base', 'sum2',  @(m) sum(sum(m)));
assignin('base', 'msum',  @(m) sum(m(:)));
assignin('base', 'qnorm2', @(m) sum(sum(m .^ 2)));

assignin('base', 'conv2boundary', @conv2boundary);
assignin('base', 'forx', @(m, b) conv2boundary(m, [1 -1], b));
assignin('base', 'fory', @(m, b) conv2boundary(m, [1 -1]', b));

msg = 'imported common functions';
end

function [r] = conv2boundary(a, b, boundary)
if isempty(boundary) || (length(boundary) == 1 && boundary == 0)
    r = conv2(a, b, 'same');
else
    %buggy, add tests and fix
    a2 = padarray(a, floor(size(b) ./ 2), boundary);
    r = conv2(a2, b, 'valid');
end
end
