%% ==== Easy set ====

%imshow(replace_face(im2double(imread('data/easy/1d198487f39d9981c514f968619e9c91.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/0013729928e6111451103c.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/1407162060_59511.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/bc.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/celebrity-couples-01082011-lead.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/inception-shared-dreaming.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/Iron-Man-Tony-Stark-the-avengers-29489238-2124-2560.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/iu.jpg'))));
%imshow(replace_face(im2double(imread('data/easy/jennifer.jpg'))));
imshow(replace_face(im2double(imread('data/easy/yao.jpg'))));

%% 

images = {'data/easy/1d198487f39d9981c514f968619e9c91.jpg' ...
    ,'data/easy/0013729928e6111451103c.jpg' ...
    ,'data/easy/1407162060_59511.jpg' ...
    ,'data/easy/bc.jpg' ...
    ,'data/easy/celebrity-couples-01082011-lead.jpg' ...
    ,'data/easy/inception-shared-dreaming.jpg' ...
    ,'data/easy/Iron-Man-Tony-Stark-the-avengers-29489238-2124-2560.jpg' ...
    ,'data/easy/iu.jpg' ...
    ,'data/easy/jennifer.jpg' ...
    ,'data/easy/yao.jpg'};
for i=1:numel(images)
    fprintf(1, '>> Replacing: %s\n', images{i});
    I = replace_face(im2double(imread(images{i})));
    filename = ['final_images/easy/output_', num2str(i), '.png'];
    imwrite(I, filename);
end

%% ==== Hard set ====

%imshow(replace_face(im2double(imread('data/hard/0b4e3684ebff3455f471bb82a0173f48.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/0lliviaa.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/4b5d69173e608408ecf97df87563fd34.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/53e34a746d54adb574ab169d624ccd0a.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/69daf49a8beb63dc35bf65b4e408cde9.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/314eeaedbe5732558841972afdbaf32f.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/beard-champs4.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/jennifer_xmen.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/mj.jpg'))));
%imshow(replace_face(im2double(imread('data/hard/star-trek-2009-sample-003.jpg'))));

%%

images = {'data/hard/0b4e3684ebff3455f471bb82a0173f48.jpg' ...
    ,'data/hard/0lliviaa.jpg' ...
    ,'data/hard/4b5d69173e608408ecf97df87563fd34.jpg' ...
    ,'data/hard/14b999d49e77c6205a72ca87c2c2e5df.jpg' ...
    ,'data/hard/53e34a746d54adb574ab169d624ccd0a.jpg' ...
    ,'data/hard/69daf49a8beb63dc35bf65b4e408cde9.jpg' ...
    ,'data/hard/314eeaedbe5732558841972afdbaf32f.jpg' ...
    ,'data/hard/beard-champs4.jpg' ...
    ,'data/hard/jennifer_xmen.jpg' ...
    ,'data/hard/mj.jpg' ...
    ,'data/hard/star-trek-2009-sample-003.jpg'};

for i=1:numel(images)
    fprintf(1, '>> Replacing: %s\n', images{i});
    I = replace_face(im2double(imread(images{i})));
    filename = ['final_images/hard/output_', num2str(i), '.png'];
    imwrite(I, filename);
end

%% ==== Blending set ====

%imshow(replace_face(im2double(imread('data/testset/blending/060610-beard-championships-bend-stroomer-0002.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/blending/b1.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/blending/bc.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/blending/Jennifer_lawrence_as_katniss-wide.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/blending/jennifer-lawrences-mystique-new-x-men-spin-off-movie.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/blending/Michael-Jordan.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/blending/Official_portrait_of_Barack_Obama.jpg'))));

%%

images = {'data/testset/blending/060610-beard-championships-bend-stroomer-0002.jpg' ...
    ,'data/testset/blending/b1.jpg' ...
    ,'data/testset/blending/bc.jpg' ...
    ,'data/testset/blending/Jennifer_lawrence_as_katniss-wide.jpg' ...
    ,'data/testset/blending/jennifer-lawrences-mystique-new-x-men-spin-off-movie.jpg' ...
    ,'data/testset/blending/Michael-Jordan.jpg' ...
    ,'data/testset/blending/Official_portrait_of_Barack_Obama.jpg'};

for i=1:numel(images)
    fprintf(1, '>> Replacing: %s\n', images{i});
    I = replace_face(im2double(imread(images{i})));
    filename = ['final_images/blending/output_', num2str(i), '.png'];
    imwrite(I, filename);
end

%% ==== Pose set ====

%imshow(replace_face(im2double(imread('data/testset/pose/golden-globes-jennifer-lawrence-0.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/pose/Michael_Jordan_Net_Worth.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/pose/p1.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/pose/p2.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/pose/Pepper-and-Tony-tony-stark-and-pepper-potts-9679158-1238-668.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/pose/robert-downey-jr-5a.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/pose/star-trek-2009-sample-003.jpg'))));

%%

images = {'data/testset/pose/golden-globes-jennifer-lawrence-0.jpg' ...
    ,'data/testset/pose/Michael_Jordan_Net_Worth.jpg' ...
    ,'data/testset/pose/p1.jpg' ...
    ,'data/testset/pose/p2.jpg' ...
    ,'data/testset/pose/Pepper-and-Tony-tony-stark-and-pepper-potts-9679158-1238-668.jpg' ...
    ,'data/testset/pose/robert-downey-jr-5a.jpg' ...
    ,'data/testset/pose/star-trek-2009-sample-003.jpg'};

for i=1:numel(images)
    fprintf(1, '>> Replacing: %s\n', images{i});
    I = replace_face(im2double(imread(images{i})));
    filename = ['final_images/pose/output_', num2str(i), '.png'];
    imwrite(I, filename);
end

%% ==== More set ====

%imshow(replace_face(im2double(imread('data/testset/more/real_madrid_2-wallpaper-960x600.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/more/marvels-the-avengers-wallpapers-01-700x466.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/more/jkweddingdance-jill_and_kevin_wedding_party.jpg'))));
%imshow(replace_face(im2double(imread('data/testset/more/burn-marvel-s-the-avengers.jpg'))));

%%

images = {'data/testset/more/real_madrid_2-wallpaper-960x600.jpg' ...
    ,'data/testset/more/marvels-the-avengers-wallpapers-01-700x466.jpg' ...
    ,'data/testset/more/jkweddingdance-jill_and_kevin_wedding_party.jpg' ...
    ,'data/testset/more/burn-marvel-s-the-avengers.jpg'};
    
for i=1:numel(images)
    fprintf(1, '>> Replacing: %s\n', images{i});
    I = imresize(replace_face(imresize(im2double(imread(images{i})), 2)), 0.5);
    filename = ['final_images/more/output_', num2str(i), '.png'];
    imwrite(I, filename);
end

%% ==== Video ====

% Read the video:

obj = VideoReader('data/testset/video/videoclip.mp4');
N   = obj.NumberOfFrames;
for k=1:N
    fprintf(1, '>> Rendering frame %d/%d\n', k, N);
    frame    = read(obj, k);
    filename = ['final_images/video/frame_', num2str(k), '.png'];
    %I = imresize(replace_face(imresize(frame,2)), 0.5);
    I = replace_face(im2double(frame));
    imwrite(I, filename);
end

%% Write the video from the files output above

obj = VideoWriter('final_images/video/videoclip_replaced.mp4', 'MPEG-4');
obj.FrameRate = 10;
open(obj);
for k=1:150
    filename = ['final_images/video/frame_', num2str(k), '.png'];
    writeVideo(obj, imread(filename));
end
close(obj);
