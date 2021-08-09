Computer Vision Challenge 2020
Group Number: G59
Group Member: Cheng, Yawen   Wang, Shuang   Zhang, Chenyu   Zhang, Zixiang
Designed in July 2020

Readme：

1. Basic function of the Algorithm：The Algorithm deals with the distinction between front and background, as well as replacing unwanted scene components.

2. The method of running the code: The installation environment can be Windows and Unix. It runs with the help of GUI.  The GUI program can be launched by entering‘start_gui’ at command-line of matlab, or by double-clicking directly.

3. GUI instructions:

Step1: Choose any scene folder path by clicking "choose image path", such as 'C:/ChokePoint/P1E_S1'.
 
Step2: Select a file path for a virtual background image (used in substitute mode) by clicking "choose background(optional)". Select a save path that you can save the rendered movie to any file path.
 
Step3: Select the rendering mode : foreground, background, overlay or substitute.
 
Step4: Enter the Start Point ‘start’ , and the number of successor images to be loaded‘N’.
 
Step5: Play control: Click the button ‘Start’ to start playing the video streams, then you can get the rendered video stream. Click the button ‘Stop’ to stop video streams. Click the button ‘Loop’ as an endless loop. After finishing the procedure, the corresponding video will be automatically saved in your chosen file path. If you do not choose your save path, the video will be saved in your current path.

4. Description of the code directory structure:

 G59   
├── lib
├── MainProGui.fig
├── MainProGui.m
├── background.jpg
├── challenge.m
├── config.m
├── ImageReader.m
├── render.m
└── segmentation.m
