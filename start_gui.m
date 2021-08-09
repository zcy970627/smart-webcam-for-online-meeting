function varargout = start_gui(varargin)
% start_gui MATLAB code for start_gui.fig
%      start_gui, by itself, creates a new start_gui or raises the existing
%      singleton*.
%
%      H = start_gui returns the handle to a new start_gui or the handle to
%      the existing singleton*.
%
%      start_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in start_gui.M with the given input arguments.
%
%      start_gui('Property','Value',...) creates a new start_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before start_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to start_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help start_gui

% Last Modified by GUIDE v2.5 11-Jul-2020 23:26:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @start_gui_OpeningFcn, ...
    'gui_OutputFcn',  @start_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before start_gui is made visible.
function start_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to start_gui (see VARARGIN)
addpath('./lib');
addpath('./documents')


% Choose default command line output for start_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global selpath;
selpath= 'C:/ChokePoint/P1E_S1';
global backgroundImage;
backgroundImage = 0;
set(handles.edit1,'enable','on');
set(handles.edit2,'enable','on');
set(handles.edit3,'enable','on');
set(handles.popupmenu1,'enable','on');
set(handles.pushbutton2,'enable','on');
set(handles.pushbutton4,'enable','on');
set(handles.pushbutton5,'enable','on');
set(handles.pushbutton7,'enable','on');
global bBreak;
bBreak = 0;
set(handles.edit2,'string','200');
set(handles.edit3,'string','100');
set(handles.edit1,'string','C:/ChokePoint/P1E_S1');%default path
set(handles.text6,'String', 'off');
global savepath;
savepath  = pwd;
savepath = strcat(savepath,'/output.avi');

global backgroundpath
backgroundpath = "background.jpg"; %default

global loop_mode
loop_mode = 0;
%add path

% addpath('./lib/cake/');
% addpath('./lib/cluster_DBSCAN/');
% UIWAIT makes start_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = start_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1. // choose image path
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selpath; %get path selpath from click
selpath = uigetdir(path);
if(0~=selpath)
    set(handles.edit2,'enable','on');
    set(handles.edit3,'enable','on');
    set(handles.popupmenu1,'enable','on');
    set(handles.pushbutton2,'enable','on');
    set(handles.pushbutton4,'enable','on');
    set(handles.pushbutton5,'enable','on');
    set(handles.pushbutton7,'enable','on');
    set(handles.edit1,'string',selpath);% put path into edit1
end


function edit1_Callback(hObject, eventdata, handles) % src
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1. // foreground
function popupmenu1_Callback(hObject, eventdata, handles) 
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% --- Executes on button press in pushbutton2  // Run_button execute
function pushbutton2_Callback(hObject, eventdata, handles) 
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.pushbutton4,'enable','on');
set(handles.pushbutton5,'enable','on');
set(handles.pushbutton7,'enable','on');
global bBreak;
bBreak = 0;
global selpath;
global savepath;
global backgroundpath
%savepath = strcat(savepath,'.avi');

savep = savepath;

src = strrep(selpath,'\','/');
src = char(src);
%if MAC, remove the last
if src(end) == '/'
    src = src(1:end-1);
end
src = string(src);

Nstart = get(handles.edit2,'string');
NnunSum = get(handles.edit3,'string');
Nstart = str2double(Nstart); 
NnunSum = str2double(NnunSum);

run challenge

axes(handles.axes2);
implay(savepath);

set(handles.pushbutton4,'enable','on'); %stop
set(handles.pushbutton5,'enable','on'); %save
set(handles.pushbutton7,'enable','on'); %loop

if bBreak == 1
    bBreak = 0;
    return
    
end

global loop_mode
while loop_mode == 1
    if bBreak == 1
        return
    end
     run challenge;
end


%%


% --- Executes on button press in pushbutton4. // Stop_button
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bBreak;
bBreak = 1;

% --- Executes on button press in pushbutton5. // Save_button
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global savepath
[file,path_] = uiputfile('*.avi','video_test','output');
savepath = strrep(strcat(path_,file),'\','/');


%%  Start point edit
function edit2_Callback(hObject, eventdata, handles) 
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% End point edit
function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6. //Choose_bg Button
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname]= uigetfile( ...
    {'*.jpg;*.bmp;*.png;*.gif','All Image Files';...
    '*.*','All Files' },...
    'Please choose a background image', ...
    'MultiSelect', 'off');
global backgroundpath;
backgroundpath = [pathname,filename];
background=imread( [pathname,filename]);
axes(handles.axes1);
imshow(background)


% --- Executes on button press in pushbutton7. // Loop_button
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global loop_mode
mode_string = get(handles.text6,'string');
if mode_string == "off"
    set(handles.text6,'String', 'on');
    loop_mode = 1;
elseif mode_string == "on"
    set(handles.text6,'String', 'off');
    loop_mode = 0;
else 
    error('loop mode error')
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
set( gca, 'xtick', [] ); %delete x_axis
set( gca, 'ytick', [] ); %delete y_axis


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
set( gca, 'xtick', [] ); %delete x_axis
set( gca, 'ytick', [] ); %delete y_axis
