function msg = imporconvt_common()
% defines some helper functions
assignin('base', 'sum2',  @(m) sum(sum(m)));
assignin('base', 'msum',  @(m) sum(m(:)));
assignin('base', 'qnorm2', @(m) sum(sum(m .^ 2)));

assignin('base', 'conv2boundary', @conv2boundary);
assignin('base', 'forx', @(m, b) conv2boundary(m, [1 -1], b));
assignin('base', 'fory', @(m, b) conv2boundary(m, [1 -1]', b));
assignin('base', 'backx', @(m, b) conv2boundary(m, [0 1 -1], b));
assignin('base', 'backy', @(m, b) conv2boundary(m, [0 1 -1]', b));
assignin('base', 'centralx', @(m, b) conv2boundary(m, [1 0 -1], b));
assignin('base', 'centraly', @(m, b) conv2boundary(m, [1 0 -1]', b));

msg = 'imported common functions';
end

function [r] = conv2boundary(a, b, boundary)
if isempty(boundary) || (length(boundary) == 1 && boundary == 0)
    r = conv2(a, b, 'same');
else
    %buggy, add tests and fix
    a = padarray(a, ceil( (size(b) - 1) ./ 2), boundary, 'post');
    a = padarray(a, floor((size(b) - 1) ./ 2), boundary, 'pre');
    r = conv2(a, b, 'valid');
end
end
