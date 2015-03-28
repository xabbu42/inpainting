function msg = imporconvt_common()
% defines some helper functions
assignin('caller', 'sum2',  @(m) sum(sum(m)));
assignin('caller', 'msum',  @(m) sum(m(:)));
assignin('caller', 'qnorm2', @(m) sum(sum(m .^ 2)));

assignin('caller', 'conv2boundary', @conv2boundary);
assignin('caller', 'forx', @(m, b) conv2boundary(m, [1 -1], b));
assignin('caller', 'fory', @(m, b) conv2boundary(m, [1 -1]', b));
assignin('caller', 'backx', @(m, b) conv2boundary(m, [0 1 -1], b));
assignin('caller', 'backy', @(m, b) conv2boundary(m, [0 1 -1]', b));
assignin('caller', 'centralx', @(m, b) conv2boundary(m, [1 0 -1], b));
assignin('caller', 'centraly', @(m, b) conv2boundary(m, [1 0 -1]', b));

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
