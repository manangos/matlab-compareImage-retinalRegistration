% evresh arxeivn
rootPath= 'C:\Users\anagn\OneDrive\Desktop\ΥΠΟΛΟΓΙΣΤΙΚΗ_ΟΡΑΣΗ_2\Retinal_registration';
imageFolder = fullfile(rootPath,'Images');
textFolder = fullfile(rootPath,'Ground Truth');

% diabazei tiw eikones
%imageFiles = dir(fullfile(imageFolder, 'Α*.jpg'));
if ~exist(imageFolder, 'dir')
    error('No images found in the specified folder.');
end
imageFiles = dir(fullfile(imageFolder, '*.jpg'));
if isempty(imageFiles)
    imageFiles = dir(fullfile(imageFolder, '*.JPG'));
end
if isempty(imageFiles)
    disp('images not found');
    return;
else
    fprintf('%d images found\n', length(imageFiles));
end

images = cell(1, length(imageFiles));
for i = 1:length(imageFiles)
    images{i} = imread(fullfile(imageFolder, imageFiles(i).name));
end

% diabazei ta shmeia apo to txt file
textFiles = dir(fullfile(textFolder, '*.txt'));
if isempty(textFiles)
    disp('No text files found in the specified folder.');
    return;
end
%metatroph se points kai enswatwsh se cells
im1points = cell(1, length(textFiles));
im2points = cell(1, length(textFiles));
for i = 1:length(textFiles)
    data = fscanf( fopen(fullfile(textFolder, textFiles(i).name), 'r'), '%f %f %f %f', [4, 10] )';
    im1points{i} = data(:, 1:2);
    im2points{i} = data(:, 3:4);
end

% euthygrammish kai optikopoihsh
tform = cell(1, length(textFiles));
alignedImg = cell(1, length(textFiles));
for i = 1:2:length(images) - 1
    tform{ceil(i / 2)} = fitgeotrans(im2points{ceil(i / 2)}, im1points{ceil(i / 2)}, 'affine');
    outputView = imref2d(size(images{i}));
    alignedImg{i} = imwarp(images{i + 1}, tform{ceil(i / 2)}, 'OutputView', outputView);


   % susxetish kai posotikopoihsh prin kai meta
    [correlationBefore, mutualInfoBefore] = compareImages(images{i}, images{i + 1});
    [correlationAfter, mutualInfoAfter] = compareImages(images{i}, alignedImg{i});
    
    %%APOTELESMATA
    fprintf('Image Pair %d and %d:\n', i, i + 1);
    fprintf('Correlation Coefficient Before: %.4f\n', correlationBefore);
    fprintf('Mutual Information Before: %.4f\n', mutualInfoBefore);
    fprintf('Correlation Coefficient After: %.4f\n', correlationAfter);
    fprintf('Mutual Information After: %.4f\n', mutualInfoAfter);


    %% EMFANISH
    figure;
    subplot(2, 2, 1);
    imshow(images{i});
    title(sprintf('Original Image %d', i));

    subplot(2, 2, 2);
    imshow(images{i + 1});
    title(sprintf('Original Image %d', i + 1));

    subplot(2, 2, 3);
    fusedImgBefore = imfuse(images{i}, images{i + 1}, 'blend');
    imshow(fusedImgBefore);
    title('Fused Before Alignment');

    subplot(2, 2, 4);
    fusedImgAfter = imfuse(images{i}, alignedImg{i}, 'blend');
    imshow(fusedImgAfter);
    title('Fused After Alignment');
end



