% Author : Rishabh Srivastava

% Image Segmentation using Region Growing Algorithm
clear;
clc;

%% Reading input
Im = imread('image.jpg');
[N,M,T] = size(Im); % Image size

%% Initialization
Im1 = double(Im)/255; %Normalizing RGB Values
seed_posn1 = [160;250]; %Seed point 
seeds = [seed_posn1]; %Matrix that will maintain record of all seed points. 
%Since only 2 clusters are to be obtained, 1 seed point is enough
vis = zeros(size(Im1)); %Matrix used to check if a pixel has become a seed point or not
moves = [1 0 -1 0; 0 1 0 -1]; %To find pixels present in 4-neighbourhood 
max_iter = 100000; %Maximum number of iterations needed
idx = 1; %Index of first seed not visted yet
last = 1; %Maintains size of seeds matrix

%% Region Growing Algorithm Implementation
for n = 1:max_iter
    ctr=0; %To count number of points added to the seeds matrix
    for i = idx:last
        sp = seeds(:,i); %Seed Point
        vis(sp(1,1),sp(2,1)) = 1; %Marking the seed as visited
        r1 = Im1(sp(1,1),sp(2,1),1); %Red pixel value of seed
        g1 = Im1(sp(1,1),sp(2,1),2); %Green pixel value of seed
        b1 = Im1(sp(1,1),sp(2,1),3); %Blue pixel value of seed
        for m = 1:4
            new_coord = sp + moves(:,m); %Neighbour Pixel
            x = new_coord(1,1);
            y = new_coord(2,1);
            if(x>=1 && x<=N && y>=1 && y<=M && vis(x,y)==0) %Checks if seed point is valid or not
                rx = Im1(x,y,1); %Red pixel value of neighbour
                gx = Im1(x,y,2); %Green pixel value of neighbour
                bx = Im1(x,y,3); %Blue pixel value of neighbour
                d = ((r1-rx)^2 + (b1-bx)^2 + (g1-gx)^2)^0.5; %Measures similarity between pixel intensities
                if(d<0.05) %Serves as Predicate for growing the region
                    vis(x,y) = 1; %Marking the pixel as visited
                    seeds = [seeds new_coord]; %Adding the pixels to seeds
                    ctr = ctr+1; 
                end
            end
        end
    end
    idx = last+1; %Index of first seed not visted yet
    last = last + ctr; %Updated size of seeds matrix
    if(idx>=last) %Indicates that no pixels can be merged anymore
        break;
    end    
end
    
%% Obtaining Segmented Image
Final_im = zeros(size(Im1));
pts = size(seeds,2); %Number of points in the region marked
for i = 1:pts
    %Mark the region obtained in blue
    Final_im(seeds(1,i),seeds(2,i),1) = 0;
    Final_im(seeds(1,i),seeds(2,i),2) = 0;
    Final_im(seeds(1,i),seeds(2,i),3) = 255;
end

for i =1:N
    for j=1:M
        %Mark the region left in green
        if(Final_im(i,j,3)==0)
            Final_im(i,j,2)=128;
        end
    end
end

%% Plotting figures
figure();
imshow(Im); %% Shows original image alongwith initial seed point
hold on;
plot(seed_posn1(2),seed_posn1(1),'bx','Linewidth',2)
title('\fontsize{16}Original Image and the initial Seed Point');

figure();
imshow(uint8(Final_im)); %% Shows original image
title('\fontsize{16}Segmented Image using Region Growing Algorithm');

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
disp(['Jaccard Similarity Coefficient for Region Growing Algorithm = ',num2str(JC)]);