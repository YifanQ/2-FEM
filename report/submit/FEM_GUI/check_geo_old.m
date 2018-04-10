function check_geo(handles)
%check the mesh plot
region_shape=get(handles.shape,'Value');
if region_shape==2
    load('model1/mesh.mat');
elseif region_shape==1
    load('model2/mesh.mat');
else
    fprint('shape selection error');
end
t = t(1:3,:);
axis(handles.figure_result);
triplot(t.',p(1,:).',p(2,:).'); 
axis off;
end