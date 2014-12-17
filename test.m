%% Master test file

basic = load('data/basicset.mat');

%% 

[I, t_out] = replace_face(basic.easy{2});

%%
imshow(I);
hold on;
plot(t_out(:,1), t_out(:,2), 'g-');
hold off;
