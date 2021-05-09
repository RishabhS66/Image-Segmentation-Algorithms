% Author : Rishabh Srivastava

% Image Segmentation using Watershed Algorithm
clear;
clc;

%% Reading input
Im = imread('image.jpg');
[N,M,T] = size(Im); % Image size

%% Initialization
Im1 = rgb2gray(Im); %Convert RGB image to grayscale
Im1 = double(Im1); %Normalizing RGB Values
minI = min(min(Im1)); %Minimum pixel intensity
maxI = max(max(Im1)); %Maximum pixel intensity
J = zeros(N,M); %Will store label of the pixel
curr_label = 1; %Initializing first label value

%% Watershed Algorithm Implementation
for i=minI:maxI %Loop over range of pixel intensities, starting from lowest pixel intensity
    [idx idy] = find(Im1==i); %All pixels with pixel intensity 'i'
    pts = length(idx); %Number of pixels with pixel intensity 'i'
    if(pts==0) %Implies that there are no pixels with intensity 'i'
        continue;
    end
    for j = 1:pts
        lab = get_label(J,N,M,idx(j),idy(j)); %Get label for the pixel
        if(lab == -1) %There are no neighbours marked in the 8-neighbourhood 
            J(idx(j), idy(j)) = curr_label; %We assign a new label to the pixel
            curr_label = curr_label + 1; %Update label that will be assigned to a new region
        else
            J(idx(j), idy(j)) = lab; %Assign label as found in the neighbourhood
        end
    end
end

%% Obtaining Segmented Image
Final_im = zeros(size(Im));
%Since watershed segmntation algorithm leads to formation of many
%segments,but we have only 2 segments in ground truth image, so we apply further filtering and
%combine all segments such that we get only 2 segments
for i = 1:N
    for j = 1:M
        if(J(i,j)<420) %If the assigned label is below 420, make it green
            Final_im(i,j,2) = 128;
        else
            Final_im(i,j,3) = 255; %If the assigned label is above 420, make it blue
        end
    end
end

%% Plotting figures
figure();
imshow(Im); %% Shows original image alongwith initial seed point
title('\fontsize{16}Original Image');

figure();
image(J,'CDataMapping','scaled') %Will assign a color to a pixel according to its label value, and display the generated image
colorbar %Shows color bar alongside the graph 
title('\fontsize{16}Segmented Image using Watershed Algorithm');

figure();
imshow(uint8(Final_im)); %% Shows original image
title('\fontsize{16}Image limited to 2 Segments after further Filtering');

%% Jaccard Similarity
%Jaccard Similarity Coefficient J = |A intersection B| / |A union B|
Im2 = imread("ground_truth.png"); %Reading ground-truth image file
Im2 = double(Im2); %Converting from uint8 to double data type for calculations
intersection = 0; %Will count the number of points that are correctly marked as aeroplane (green)
union = 0; %Will count the number of pixels that are marked as aeroplane (green) in either output or ground-truth image 
for i = 1:N
    for j = 1:M
        r1 = Final_im(i,j,1); %Red pixel value for output image
        g1 = Final_im(i,j,2); %Green pixel value for output image
        b1 = Final_im(i,j,3); %Blue pixel value for output image
        r2 = Im2(i,j,1); %Red pixel value for ground-truth image
        g2 = Im2(i,j,2); %Green pixel value for ground-truth image
        b2 = Im2(i,j,3); %Blue pixel value for ground-truth image
        if(r1==r2 && g1==g2 && b1==b2 && g1~=0) % Checks if the pixel intensities match, and the pixel represents green
            intersection = intersection + 1; %increase the intersection points by 1
            union = union + 1; %increase the union points by 1
        elseif((g1>0 && g2==0)||(g2>0 && g1==0)) %Checks if the pixel is green in either one of the pictures
            union = union +1; %Increase union points by 1
        end
    end
end
JC = intersection/union; %Jaccard Similarity Coefficient
disp(['Jaccard Similarity Coefficient for Watershed Algorithm = ',num2str(JC)]);

%% Function to find labels in 8-neighbourhood
function lab = get_label(J,N,M,i,j)
%J - matrix that contains pixels marked with labels
%[N,M] - size of J
%[i,j] - coordinate of center pixel
moves = [1 0;-1 0;0 1;0 -1;1 1;1 -1;-1 1;-1 -1]; %8 possible neighbours
lab = -1; %If no label in neighbourhood is found, -1 will be returned
for m = 1:8
    %Obtain neighour pixel
    x = i+moves(m,1); 
    y = j+moves(m,2);
    if(x>=1 && x<=N && y>=1 && y<=M && J(x,y)>0) %Checks if coordinates are valid, and if it has a label assigned to it
        if(lab == -1)
            lab = J(x,y); %First neighbour with label is found, so its label is assigned to center pixel
        else
            lab = 0;
            %lab = min(J(x,y),lab); %If multiple label candidates are found, select the smallest
        end
    end
end
end