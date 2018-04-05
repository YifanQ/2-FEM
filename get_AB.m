function [A, B] = get_AB(p)
% 2D

AA =( p(1,2) - p(1,1) )*( p(2,3) - p(2,1) ) - ...
    ( p(1,3) - p(1,1) )*( p(2,2) - p(2,1) );
    % (x2-x1 * y3-y1) - (x3-x1 * y2-y1)

abc = zeros(3,3);
for ii = 1:3
    pp = circshift(p, 1-ii, 2);

    a = pp(1,2)*pp(2,3)-pp(1,3)*pp(2,2);
    b = pp(2,2)-pp(2,3);
    c = pp(1,3)-pp(1,2);
    % f = (a+b*x+c*y)./T;
    abc(ii,:) = [a, b, c];
end
abc = abc/AA;

A = abc(:,2:3)*abc(:,2:3).';
B = zeros(3,3);

l_x_y = zeros(3,3);

% local variables
sx = p(1,1) + p(1,2) + p(1,3);
sy = p(2,1) + p(2,2) + p(2,3);
sxy = dot(p(1,:), p(2,:));
sxx = p(1,1)*p(1,2) + p(1,2)*p(1,3) + p(1,3)*p(1,1);
syy = p(2,1)*p(2,2) + p(2,2)*p(2,3) + p(2,3)*p(2,1);

l_x_y(1,1) = 1/2;
l_x_y(2,2) = 1/12*(sx*sx - sxx); %x^2
l_x_y(3,3) = 1/12*(sy*sy - syy); %y^2
l_x_y(1,2) = 1/6*sx; l_x_y(2,1) = l_x_y(1,2); %x
l_x_y(1,3) = 1/6*sy; l_x_y(3,1) = l_x_y(1,3); %y
l_x_y(2,3) = 1/24*(sx*sy+sxy); l_x_y(3,2) = l_x_y(2,3); %xy

l_x_y = l_x_y*AA;


for ii = 1:3
    for jj = ii:3
        B_ii_jj = ( abc(ii,:).'*abc(jj,:) ).*l_x_y;
        B(ii,jj) = sum(B_ii_jj(:));
        B(jj,ii) = B(ii,jj);
    end
end


end

% p = [0,0;1,0;0,1].';
% [A,B] = get_AB(p)
