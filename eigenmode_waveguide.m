close all; clear all; clc;

TE_or_TM='TM';
plotGeometry=false;

% load('model1/mesh.mat');
% load('model2/4k_tri.mat');
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

all_nNum = pNum;
int_nNum = size(int_n,1);

% logical array indicating a node in the internal or on the edge
int_or_edge = ones(pNum, 1);
int_or_edge(edge_n) = 0;
int_or_edge = logical(int_or_edge);

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

fprintf('# of non-zero elements in A = %d\n',nnz(A));
fprintf('# of non-zero elements in A(int_n, int_n) = %d\n',nnz(A(int_n, int_n)));
figure(1);
subplot(1,2,1);imagesc(full(A)~=0);
title(sprintf('A (%d, %d)',all_nNum,all_nNum));colorbar;axis('image');
subplot(1,2,2);imagesc(full(A(int_n, int_n))~=0);
title(sprintf('A for internal nodes (%d, %d)',int_nNum,int_nNum));colorbar;axis('image');

if strcmp(TE_or_TM,'TM')
% error, e=eig(A(int_n, int_n), B(int_n, int_n)) not for sparse matrix
[V,D,flag] = eigs(A(int_n, int_n), B(int_n, int_n), 20, 'sm'); % 2017a
% e=eigs(A(int_n, int_n), B(int_n, int_n), 10, 'smallestabs') 
% 2017b + https://www.mathworks.com/help/matlab/ref/eigs.html#bu2_q3e-sigma
% eigs(A,k,'smallestabs') returns the k smallest magnitude eigenvalues.
kt = sqrt(diag(D));

figure(2);
for eigen_ii=1:6
    subplot(2,3,eigen_ii);
    Ez_all = zeros(pNum, 1);
    Ez_all(int_n) = V(:,eigen_ii);
    trisurf(t.',p(1,:).',p(2,:).',Ez_all);
    view(2);xlabel('x'); ylabel('y'); zlabel('E_z');axis('equal');
    title(sprintf('k=%0.4f',kt(eigen_ii)));
end

kt_exact = load('model2/TMmodes.txt','-ascii');
kt_exact = kt_exact(:,1);
kt./kt_exact

end

if strcmp(TE_or_TM,'TE')
% error, e=eig(A(int_n, int_n), B(int_n, int_n)) not for sparse matrix
[V,D,flag] = eigs(A, B, 20+1, 'sm'); % 2017a
% e=eigs(A(int_n, int_n), B(int_n, int_n), 10, 'smallestabs') 
% 2017b + https://www.mathworks.com/help/matlab/ref/eigs.html#bu2_q3e-sigma
% eigs(A,k,'smallestabs') returns the k smallest magnitude eigenvalues.

%{ 
diag(D) not exactly in ascending order
0.0000
3.3924
3.3923
9.3409
9.3405
14.7157
17.6898
17.6879
%}

% drop kt = 0 mode
D = D(2:end, 2:end);
V = V(:, 2:end);
kt = sqrt(diag(D));

figure(2);
for eigen_ii=1:6
    subplot(2,3,eigen_ii);
    Hz_all = V(:,eigen_ii);
    trisurf(t.',p(1,:).',p(2,:).',Hz_all);
    view(2);xlabel('x'); ylabel('y'); zlabel('H_z');axis('equal');
    title(sprintf('k=%0.4f',kt(eigen_ii)));
end

kt_exact = load('model2/TEmodes.txt','-ascii');
kt_exact = kt_exact(:,1);
kt./kt_exact

end
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




if plotGeometry
figure(3);
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
end