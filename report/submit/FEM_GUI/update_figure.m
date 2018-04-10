function update_figure(handles)
%plot the specific mode on GUI
TE_or_TM=get(handles.TEorTM,'Value');
index_selected = get(handles.list_result,'Value');
if TE_or_TM==1
    Hz_all= handles.V(:,index_selected);
    p=handles.p;
    t=handles.t;
    axis(handles.figure_result);
    trisurf(t.',p(1,:).',p(2,:).',Hz_all);
    view(2);axis('equal');axis off;shading interp
end

if TE_or_TM==2
    pNum=handles.pNum;
    int_n=handles.intn;
    Ez_all = zeros(pNum, 1);
    Ez_all(int_n) =handles.V(:,index_selected);
    p=handles.p;
    t=handles.t;
    axis(handles.figure_result);
    trisurf(t.',p(1,:).',p(2,:).',Ez_all);
    view(2);axis('equal');axis off;shading interp
end
end