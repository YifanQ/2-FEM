function     [p,t,V,pNum,int_n]=main_calc(hObject,handles)
%main calculation function of GUI
%show kc result
TE_or_TM=get(handles.TEorTM,'Value');
region_shape=get(handles.shape,'Value');
index_selected = get(handles.list_result,'Value');
if region_shape==2
    load('model1/mesh.mat');
elseif region_shape==1
    load('model2/mesh.mat');
else
    fprint('shape selection error');
end
t = t(1:3,:);
b_e = e(1:2,:);
tNum = size(t,2);
pNum = size(p,2);
all_n = [1:pNum].';
edge_n = unique(b_e(:));
int_n = setdiff(all_n, edge_n);
A = sparse(pNum, pNum);
B = sparse(pNum, pNum);
for ii = 1:tNum
    node = t(1:3, ii);
    [AA, BB] = get_AB(p(:,node));
    A(node, node) = A(node, node) + AA;
    B(node, node) = B(node, node) + BB;
end
if TE_or_TM==2
    [V,D] = eigs(A(int_n, int_n), B(int_n, int_n), 20, 'sm');
    kt = sqrt(diag(D));
    kt=flipud(kt);
    V=fliplr(V);
    if region_shape==2
        kt_exact = load('model1/TMmodes.txt','-ascii');
    elseif region_shape==1
        kt_exact = load('model2/TMmodes.txt','-ascii');
    else
        fprint('shape selection error');
    end    
    kt_exact = kt_exact(1:20,:);
    kt_exact = kt_exact(:,[2,3,1]);
    kt_all=num2str([kt_exact(:,1:2),kt,kt_exact(:,3)]);
    set(handles.list_result,'string',kt_all);
    handles.p=p;
    handles.t=t;
    handles.V=V;
    handles.pNum=pNum;
    handles.intn=int_n;
    guidata(hObject,handles)
end
if TE_or_TM==1
    [V,D] = eigs(A, B, 20+1, 'sm');
    D = D(1:end-1, 1:end-1);
    V = V(:, 1:end-1);
    kt = sqrt(diag(D));
    kt=flipud(kt);
    V=fliplr(V);
    if region_shape==2
        kt_exact = load('model1/TEmodes.txt','-ascii');
    elseif region_shape==1
        kt_exact = load('model2/TEmodes.txt','-ascii');
    else
        fprint('shape selection error');
    end
    kt_exact = kt_exact(1:20,:);
    kt_exact = kt_exact(:,[2,3,1]);
    kt_all=num2str([kt_exact(:,1:2),kt,kt_exact(:,3)]);
    set(handles.list_result,'string',kt_all);
    handles.p=p;
    handles.t=t;
    handles.V=V;
    guidata(hObject,handles)
end
end
