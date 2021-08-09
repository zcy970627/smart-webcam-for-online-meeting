%% Computer Vision Challenge 2020 challenge.m
% close all;
% clear;

%% Run Config
run config;

%% Start timer here
tic
mytic = tic;
%% Generate Movie
loop = 0;
i = 0;
first_frame_flag = false;
%Every Mask need two frames to compute
left_last = [];%store data for the last frame. avoid repeated imread
num_not_found = 0;
while loop ~= 1
  % Read frames
    try
        co = ImageReader(src,1,2,start+i,0);
        [left,~,~] = co.next();%read one frame
        %if reads 999 and 1000 is missing, the catch statement is run.
    catch
        %if the frame not found, continue and display info.
        left_last = [];
        disp(string(start+i)+' not found')
        i = i + 1;
        num_not_found = num_not_found + 1;
        if start+i >= last
            s = 'Processing ' + string(start+i) + 'th frame ' + ...
                '======================>'+ string(i/N*100) + '%';
            disp(s);
            try
                set(handles.text5, 'String', s);
            end
            break
        end
        continue
    end
    
    s = 'Processing ' + string(start+i) + 'th frame ' + ...
        '======================>'+ string(i/N*100) + '%';
    disp(s);
    try
    set(handles.text5, 'String', s);
    end

    if isempty(left_last)
        %if the previous frame not found, replicate the current frame
        mat = zeros(600,800,6);
        mat(:,:,1:3) = left;
        mat(:,:,4:6) = left;
        left_last = left;%update, store this for next computation
        left = mat;
    else
        %if there is frame from the last, use that instead
        mat = zeros(600,800,6);
        mat(:,:,1:3) = left_last;
        mat(:,:,4:6) = left;
        left_last = left;%update, store this for next computation
        left = mat;
    end
    
    %with two frames in "left" perform segmentation
    [mask,bg_updated,~] = segmentation(left,bg_default);
   
    if ~isempty(bg_updated)
        bg_default = bg_updated;
    end
    
  % Render new frame
%     mask = logical(mask);
%     %modify mask for use in RGB
%     background_masked = double(background).*repmat(double((~mask)),1,1,3);
%     object = left(:,:,4:6).*repmat(double((mask)),1,1,3);
%     Final_image = uint8(background_masked + object);
    frame_original = left(:,:,4:6);
    result = render(left(:,:,4:6),mask,double(background),render_mode);
    writeVideo(video, uint8(result)); %write the image to file
    
    try
    %GUI Interaction
    pause(.03)
    if bBreak == 1
        loop = 1;
    end
    axes(handles.axes2);
    imshow(uint8(result));
    axes(handles.axes1);
    imshow(uint8(frame_original));
    end
    
    i = i + 1;
    if start+i>= last
        break
    end
end

disp(string(N - num_not_found) + " frame processing");
close(video);

try
    
end
%% Stop timer here
toc
elapsed_time =  toc(mytic);


%% Write Movie to Disk
% if store
%   %v = VideoWriter(dst,'Motion JPEG AVI');
% end
