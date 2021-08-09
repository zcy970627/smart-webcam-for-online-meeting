%% Computer Vision Challenge 2020 config.m

%% Generall Settings
% Group number:
group_number = 59;

% Group members:
members = {'Zixiang Zhang', 'Yawen Cheng','Shuang Wang','Chenyu Zhang'};

% Email-Address (from Moodle!):
mail = {'zixiang.zhang@tum.de', 'ge37veb@mytum.de','koly76.wang@tum.de','chenyu.zhang@tum.de'};

%% Setup Image Reader
addpath('./lib');

% Select Cameras
L = 1;
R = 2;

% Choose a start point
try
    % Specify Scene Folder
    src = src;
    start = Nstart;
    N = NnunSum;%how long, total intended read frame
    
catch
    src = 'C:/ChokePoint/P1E_S1';
    start = 250;
    N = 20;
end
last =  start+N;

%According to the ChokePoint Dataset description
%the first 100 pages are background without object
% Read the default background
bg_set = ImageReader(src,L,R,1,4); %N set = 4 to read 5 background.
[left_set,~,~] = bg_set.next();
bg_default = get_bg(left_set);

%% Output Settings
% Output Path
%dst = "video_"+string(date)+"_"+string(start)+"to"+string(last)+".avi";
try
    dest = savep;
catch
    dest = 'Video_test.avi';
end
video = VideoWriter(dest); %create the video object
open(video); %open the file for writing

% Load Virual Background
try
    background = imread(backgroundpath);
catch
    background = imread("background.jpg");
end
background = background(1:600,1:800,:);%crop it

% Select rendering mode
try
    mode=get(handles.popupmenu1,'string');
    val=get(handles.popupmenu1,'value'); %get num.mode
    render_mode = string(mode{val});
catch
    render_mode = "substitute";
end
% Create a movie array
% movie =

% Store Output?
store = true;
