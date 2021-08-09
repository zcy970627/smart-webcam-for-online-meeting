function [mask,bg_updated,stat] = segmentation(left,bg)
% Add function description here
% Generate One Mask for one frame
% left, 600*800*6, double type
% bg, 600*800*3

%---------------------- Parameter Optimizatin -----------------------------
%Testing
% close all;
do_plot = false;
% do_plot = true;  

resize_factor = 12;%reduce resolution factor
resize_method = 'bicubic';
rough_threshold = 0.033;%roughly threshold to remain the changing pixel
main_threshold = 0.05;%For the most frequent case,

eps = 5;%radius for DBscan
minPts = 3;%minimum num of points to form a circle for DBscan
threshold_cluster = 10;%minimum points for identifying as a cluster
concave_factor1 = 0.7;
rely_on_bg_diff = 0.3;

expand_rec_factor_hori = 0.3;
expand_rec_factor_verti = 0.15;
concave_factor = 0.5; % the larger, the more lines bend inwards.

%Interpolation
expand_sz = 30;
interpolation_density = 20;
radius = 15;


%harris detector is calculated mids the program
k = 0.5; 
tau = 0.00005; %the harris response is normalized, so tau is very small
segment_length = 5;  %size of the image segment


min_dist = 10;          %minimal distance of two features in pixels
tile_size = [40 40];      %size of the tiles
N =  20;               %maximal number of features per tile

%with a bigger k, you will get less false corners but you will also miss 
%more real corners (high precision), with a smaller k you will get a lot 
%more corners, so you will miss less true corners, but get a lot of false 
%ones (high recall).
%--------------------------------------------------------------------------

if do_plot;tic;end


%Preparation
num_frame = size(left,3)/3; 
frame_cell = cell(1,num_frame);   %store gray pictures
left_bg = rgb_to_gray(bg);

% Read Frame
for i = 1:num_frame
im_gray_l = rgb_to_gray(left(:,:,3*(i-1)+1:3*i));
frame_cell{1,i} = im_gray_l;%assign to cell to store the gray result
end

%% Image Differencing
% Reduce Resolution to simplify computation
left_bg = imresize(left_bg,1/resize_factor,resize_method);
frame = imresize(frame_cell{1,2},1/resize_factor,resize_method);
frame_last = imresize(frame_cell{1,1},1/resize_factor,resize_method);

% Differencing with the last frame
frame_diff = abs(frame - frame_last);
% Differencing with the default background
frame_bg_diff = abs(frame - left_bg);

%-------------------choose which mode to rely on---------------------------
%frame_diff, frame_bg_diff, unnormalized
%pixel value max 255, min 0, so the maximum difference is 255;
%normalize it with 255
frame_diff = frame_diff./255;
frame_bg_diff = frame_bg_diff./255;

if do_plot
   figure;
   surf(frame_diff);
   title('frame - frame_last(normalized)');
   figure;
   surf(frame_bg_diff);
   title('frame - background');
end

frame_diff = (frame_diff>rough_threshold).*frame_diff;
frame_bg_diff = (frame_bg_diff>rough_threshold).*frame_bg_diff;

%count how many pixels remain after thresholding
no_frame_diff = sum(frame_diff>0,'all');
no_frame_bg_diff = sum(frame_bg_diff>0,'all');

%if both difference are two small, means the frame is bg?
if no_frame_diff == 0 && no_frame_bg_diff == 0 
    mask = zeros(600,800);
    bg_updated = left(:,:,4:6);%update the background with second frame
    stat = [];
    disp('both mode 0 number of difference points, background only confirmed')
    return
elseif no_frame_diff == 0 && no_frame_bg_diff > 0 
    %either there is no object, 
    %or there are objects but they are not moving
    %in this case, we rely 100% on the latter
    %so raise the threshold value
    diff_l = frame_bg_diff;%2, rely more on frame_diff
    diff_l = imgaussfilt(diff_l);
    threshold_value = min(diff_l,[],'all')+0.2;
elseif no_frame_diff > 0 && no_frame_bg_diff > 0
    %normal scenario, both have values
    diff_l = frame_diff + rely_on_bg_diff*frame_bg_diff;%2, rely more on frame_diff
    %diff_l = diff_l./(max(diff_l,[],'all'));
    threshold_value = main_threshold;
elseif no_frame_diff > 0 && no_frame_bg_diff == 0
    %the object leaves the camera,now the frame contains nothing
    mask = zeros(600,800);
    bg_updated = left(:,:,4:6);%update the background with second frame
    stat = [];
    disp('background detected, update the default background')
    return    
end

%Combine two modes
%rough detection for reduced resolution

[row, col] = find(diff_l > threshold_value);
remain_feature = [col' ; row'];

if do_plot
    figure;
    diff_l_filtered = (diff_l > threshold_value).*diff_l;
    surf(((diff_l_filtered)));
    title('Final Combination');
    figure
    imshow(uint8(frame));
    hold on;
    plot(remain_feature(1,:),remain_feature(2,:),'ro','MarkerSize',1)
    hold off;
    title('first detection')
    disp('pre-processing using simple global threshold');
    toc;
end



%% Cluster Analysis
if do_plot;tic;end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%DBSCAN Algorithm%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%introduce cluster recognization to exclude the a few scattered points
%outside.
%remove outliers
%Classifying feature points of an object as a cluster
%-----------------------Parameter Adjustment-------------------------------
clusters = cluster_DBSCAN(remain_feature,resize_factor,...
    'eps',eps,'minPts',minPts,'do_plot',do_plot);
if do_plot;disp('DBSCAN done');toc;tic;end;
%--------------------------------------------------------------------------
%Choose which cluster to use for creating mask
cluster_number = max(clusters(3,:)); %count how many cluster are identified
each_cluster_element_num = zeros(1,cluster_number);
num_qualified = 0;%num of clusters that are qualified as an object

%initialize mask
bw = zeros(600,800);

%Process each cluster
for i = 1:cluster_number
    each_cluster_element_num(i) = sum(clusters(3,:) == i); 
    if each_cluster_element_num(i) > threshold_cluster
        %multiply the resize_factor to get back the original coordinates.
        x = clusters(1,clusters(3,:) == i)*resize_factor;
        x(x>800) = 800;
        y = clusters(2,clusters(3,:) == i)*resize_factor;
        y(y>600) = 600;

        %-----------------------Deal with each cluster---------------------
        frame_full = frame_cell{1,2}; %the second frame
        diff_resize = imresize(diff_l,resize_factor);
        
        %Getting coordinates for cropping the object for detailed detection
        %expand the rec of 10%x max 800, y max 600
        hori_max = max(x);hori_min = min(x);
        range_hori = hori_max - hori_min;
        hori_max = min(ceil(range_hori*expand_rec_factor_hori + hori_max),800);
        hori_min = max(floor(hori_min - range_hori*expand_rec_factor_hori),1);
        verti_max = max(y);verti_min = min(y);
        range_verti = verti_max - verti_min;
        verti_max = min(ceil(range_verti*expand_rec_factor_verti + verti_max),600);
        verti_min = max(floor(verti_min - range_verti*expand_rec_factor_verti),1);
        
        %put another sub-mask to only include the main points
        %because later detailed detection main have noise outside
        [idex] = boundary(x',y',concave_factor1); %concave
        x = x(idex);y = y(idex);
         % x is 0 to 800, y is 0 to 600
         % to have the y direction extended to include hair
         [~,y_index]= sort(y,'ascend');
         num_y_extended = ceil(0.1*length(y));
         [va_min] = min(y);
         va_max = max(y);
         y(y_index(1:num_y_extended)) = max(y(y_index(1:num_y_extended))...
             - 0.01*abs(va_min-va_max),1);
         %add points, the x y from boundary are not enough
         
         %Generate Sub_Mask along the contour
         %First, Interpolating the closed curve(boundary we got)

         x_interpolated = zeros(1,each_cluster_element_num(i));
         y_interpolated = zeros(1,each_cluster_element_num(i));
         
         n = 0;
         for l = 2:length(x)
             %distance for each line
             d = sqrt((x(l) - x(l-1))^2 + (y(l) - y(l-1))^2);
             num_add_segment = ceil(d/interpolation_density);
             %dbstop if error;
             if num_add_segment >= 2
                 num_add_point = num_add_segment - 1;
                 x_new = x(l-1);
                 y_new = y(l-1);
                 dx = (x(l) - x(l-1))/num_add_segment;
                 dy = (y(l) - y(l-1))/num_add_segment;
                 for p = 1:num_add_point
                     n = n + 1;
                     x_new = ceil(x_new + dx);
                     y_new = ceil(y_new + dy);
                     try
                         x_interpolated(n) = x_new;
                         y_interpolated(n) = y_new;
                     end
                 end
             end
         end
         
         
         [~,n] = find(x_interpolated>0);
         [~,m] = find(y_interpolated>0);
         
         if ~isempty(n)
         x_interpolated = x_interpolated(1:n(end));
         end
         if ~isempty(m)
         y_interpolated = y_interpolated(1:m(end));
         end
         
         x_full = [ceil(x) x_interpolated] + expand_sz ;
         y_full= [ceil(y) y_interpolated] + expand_sz ;
         
         %each point has a round area where mask value = 1
         
        
        CAKE = zeros(600 + 2*expand_sz,800 + 2*expand_sz);
        for l = 1:length(x_full)
            try
            CAKE_part = CAKE(y_full(l) - radius:y_full(l) + radius,...
                x_full(l) - radius: x_full(l) + radius);
             CAKE(y_full(l) - radius:y_full(l) + radius,...
                x_full(l) - radius:x_full(l) + radius)...
                =logical(CAKE_part)|~cake(radius);       
            catch
                disp('sub_mask generating error detected')
               continue 
            end
        end
        mask_expanded = CAKE;
        sub_mask = mask_expanded(expand_sz + 1:600+expand_sz,...
            expand_sz + 1:800+expand_sz);
        sub_mask_cropped = sub_mask(verti_min:verti_max,hori_min:hori_max);
%         new_bw = activecontour(frame_full,sub_mask,20);
        frame_cropped = frame_full(verti_min:verti_max,hori_min:hori_max);
        diff_resize_cropped = diff_resize(verti_min:verti_max,hori_min:hori_max);
        
        if do_plot
            figure
            imshow(uint8(frame_cropped.*sub_mask_cropped));
            title('cropped')
        end
        

         features_l = harris_detector( frame_cropped,...
            'tau',tau,'Segment_length',segment_length,'k',k,...
            'tile_size',tile_size,'min_dist',min_dist,'N',N,...
            'sub_mask',sub_mask_cropped,'do_plot',do_plot);%crippled harris_detector. #1.9 not implemented
        
        features_l = features_l + [hori_min - 1;verti_min - 1]; %get the original cors
        xx = features_l(1,:);
        yy = features_l(2,:);
        [idex] = boundary(xx',yy',concave_factor); %concave
        new_bw = poly2mask(xx(idex),yy(idex),600,800);
        if do_plot
            figure
            imshow((uint8(left(:,:,4:6))));
            hold on;
            imshow((uint8(new_bw*255)));
            hold off
            alpha(0.7);
            title('Mask')
        end
        bw = logical(bw) | logical(new_bw);%combine the mask
        num_qualified = num_qualified + 1;
    end
end

if num_qualified == 0
    disp('No Objects detected')
    mask = zeros(600,800);
elseif num_qualified >= 1
    disp(string(num_qualified) + ' objects detected');
    mask = bw;
end
bg_updated = [];
stat = [];


if do_plot;disp('cluster processing ');toc;end
end