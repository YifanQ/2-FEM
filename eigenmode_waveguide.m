close all; clear all; clc;

% load('model1/mesh.mat');
load('model2/4k_tri.mat');
% https://www.mathworks.com/help/pde/ug/pde.pdemodel.generatemesh.html
% https://www.mathworks.com/help/pde/ug/mesh-data.html
% e(6,k) is the subdomain number on the left side of the edge (subdomain 0 is the exterior of the geometry), where direction along the edge is given by increasing parameter values.
% e(7,k) is the subdomain number on the right side of the edge.

t = t(1:3,:);
b_e = e(1:2,:);

tNum = size(t,2);
b_eNum = size(b_e,2);
pNum = size(p,2);

all_n = [1:pNum].';
edge_n = unique(b_e(:));
int_n = setdiff(all_n, edge_n);

N = size(int_n,1);
int_or_edge = ones(pNum, 1);
int_or_edge(edge_n) = 0;
int_or_edge = logical(int_or_edge);

% A = sparse(N, N);
% B = sparse(N, N);
A = sparse(pNum, pNum);
B = sparse(pNum, pNum);

for ii = 1:tNum
    node = t(1:3, ii);
    % int_node_flag = int_or_edge(node);
    % int_node = node(int_node_flag);
    [AA, BB] = get_AB(p(:,node));
    A(node, node) = A(node, node) + AA;
    B(node, node) = B(node, node) + BB;
end

nnz(A)
nnz(A(int_n, int_n))
figure(3);imagesc(full(A)~=0);colorbar;axis('image');
figure(4);imagesc(full(B)~=0);colorbar;axis('image');
% e=eig(A(int_n, int_n), B(int_n, int_n))
[V,D,flag] = eigs(A(int_n, int_n), B(int_n, int_n), 20, 'sm'); % 2017a

figure(2);
for eigen_ii=1:4
    subplot(2,2,eigen_ii);
    Ez_all = zeros(pNum, 1);
    Ez_all(int_n) = V(:,eigen_ii+5);
    trisurf(t.',p(1,:).',p(2,:).',Ez_all);
    view(2);xlabel('x'); ylabel('y'); zlabel('E_z');axis('equal');
end

% e=eigs(A(int_n, int_n), B(int_n, int_n), 10, 'smallestabs') 
% 2017b + https://www.mathworks.com/help/matlab/ref/eigs.html#bu2_q3e-sigma
% eigs(A,k,'smallestabs') returns the k smallest magnitude eigenvalues.

% diag(D)
% a=[24.8118
% 39.8671
% 65.1878
% 85.4346];
% a./[5,8,13,20].'
% a = [11.6024
%    29.5776
%    29.5803
%    53.4601];

% a = diag(D);
% a = a(1:4,1);
% a./([2.405, 3.832, 3.832, 5.1356].^2).'
kt = sqrt(diag(D));
kt_exact = load('model2/TMmodes.txt','-ascii');
kt_exact = kt_exact(:,1);
kt./kt_exact



figure(1);
subplot(1,3,1);
triplot(t.',p(1,:).',p(2,:).'); % TRI m x 3, x, y
xlabel('x'); ylabel('y'); axis('equal');

subplot(1,3,2);
x1_b_e = p(1,b_e(1,:));
x2_b_e = p(1,b_e(2,:));
y1_b_e = p(2,b_e(1,:));
y2_b_e = p(2,b_e(2,:));
x_b_e = [x1_b_e;x2_b_e;nan(1,b_eNum)];
y_b_e = [y1_b_e;y2_b_e;nan(1,b_eNum)];
plot(x_b_e(:), y_b_e(:), 'k.-');
xlabel('x'); ylabel('y'); axis('equal');
clear('x1_b_e','x2_b_e','y1_b_e','y2_b_e','x_b_e','y_b_e');
