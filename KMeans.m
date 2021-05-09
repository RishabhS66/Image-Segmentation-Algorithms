% Author : Rishabh Srivastava

% Image Segmentation using K-means Algorithm
clear;
clc;

%% Reading input
Im = imread('image.jpg');
[N,M,T] = size(Im); % Image size

%% Initialization
Im1 = double(Im)/255; %Normalizing RGB Values
Im1 = reshape(Im1,N*M,3); %Reshaping image matrix for simpler code in MATLAB
C = 2; %Number of Clusters
centroid1 = [12 23 7]/255; %Choosing initial centroid for first cluster randomly
centroid2 = [130 132 144]/255; %Choosing initial centroid for second cluster randomly
centroids = [centroid1;centroid2]; %Matrix containing centroids for all clusters
max_iter = 100; %Maximum number of iterations for which the program will run
epsilon_threshold = 0.001; %If the change in centroids between 2 successive iterations is less than this value, the iterations will stop
label_matrix = ones(N*M,3); % Matrix to store the cluster label of a pixel; all pixels are assigned to cluster 1 by default

%% K-means Algorithm Implementation
for n = 1:max_iter %Run loop till maximum iteration
    old_centroids = centroids; %Store current centroids to compare with after new centroids are calculated
    for i = 1:N*M %Loop over all pixels
        for c = 1:2 %Loop over all cluster centroids
            label_matrix(i,c) = norm(Im1(i,:) - centroids(c,:)); %Finds distance between pixel intensity and centroid intensity             
        end
        if(label_matrix(i,2)<label_matrix(i,1)) 
            label_matrix(i,3) = 2; %Assign pixel to cluster 2 if it is more closer to centroid of cluster 2
        end        
    end
    for c = 1:2 %Loop over all cluster centroids
        idx = find(label_matrix(:,3)==c); %Indexes where cluster label is 'c'
        centroids(c,:) = mean(Im1(idx,:)); %Calculation of new cluster centroid
    end
    if(abs(old_centroids - centroids)<epsilon_threshold) %Checks if convergence has occured or not
        break;
    end
end

%% Obtaining Segmented Image
Final_im = zeros(N*M,3); %Initialising Final Image matrix
green = [0 128 0]; %Color for representing cluster 1
blue = [0 0 255]; %Color for representing cluster 2
colors = [green;blue]; %Matrix of colors
for c = 1:2
    idx = find(label_matrix(:,3)==c); %Indexes where cluster label is 'c'
    Final_im(idx,:) = repmat(colors(c,:),size(idx,1),1); %Assigns color 'c' to all pixels which are part of cluster 'c'
end
Final_im = reshape(Final_im,N,M,3); %Reshaping Final Image matrix to display the image

%% Plotting figures
figure();
imshow(Im); %% Shows original image
title('\fontsize{16}Original Image');

figure();
imshow(uint8(Final_im)); %% Shows original image
title('\fontsize{16}Segmented Image using K-Means Algorithm');

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
disp(['Jaccard Similarity Coefficient for K-Means Algorithm = ',num2str(JC)]);