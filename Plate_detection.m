close all;
clear all;

im = imread('Number Plate Images/image2.png');
imgray = rgb2gray(im);
imbin = imbinarize(imgray);
im = edge(imgray, 'prewitt');

% Below steps are to find location of number plate
Iprops = regionprops(im, 'BoundingBox', 'Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa = area;
boundingBox = Iprops.BoundingBox;

for i = 1:count
    if maxa < Iprops(i).Area
        maxa = Iprops(i).Area;
        boundingBox = Iprops(i).BoundingBox;
    end
end

im = imcrop(imbin, boundingBox); % Crop the number plate area
im = bwareaopen(~im, 500); % Remove some objects if their size is too small

[h, w] = size(im); % Get width and height of cropped image

imshow(im);

Iprops = regionprops(im, 'BoundingBox', 'Area', 'Image'); % Read each connected region
count = numel(Iprops);
noPlate = []; % Initializing the variable for storing the detected characters

for i = 1:count
    ow = length(Iprops(i).Image(1, :));
    oh = length(Iprops(i).Image(:, 1));
    if ow < (h / 2) && oh > (h / 3)
        letter = Letter_detection(Iprops(i).Image); % Reading the character from binary image
        noPlate = [noPlate letter]; % Appending detected characters
    end
end

% Check if noPlate is empty and display appropriate message
if isempty(noPlate)
    disp('No number plate is present.');
else
    disp(['Detected Number Plate: ', noPlate]);
end
