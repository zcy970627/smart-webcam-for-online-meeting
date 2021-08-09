classdef ImageReader
    % Add class description here
    %
    %
    %Repository Request Example
    %...\ChokePoint\P1E_S1\P1E_S1_C1\00000032.jpg
    
    %%%%%%%%%%Test Commands%%%%%%%%%
    %for testing, src example C:\ChokePoint\P1E_S1
    %co = ImageReader("C:\ChokePoint\P1E_S1",1,2)
    %co = ImageReader("C:\ChokePoint\P1E_S1",1,2,"start",32,"N",3)
    %co.next
    
    %20-06-28
    %Adjust N for mini value 2
    properties
        L;
        R;
        src;
        start;
        N;
        
    end
    
    
    methods
        function ir = ImageReader(src,L,R,varargin)
            
            p = inputParser;
            
            defaultst = 0;
            defaultN = 1;
            
            validsrc = @(x) isfolder(x);
            validst = @(x) isnumeric(x) && (mod(x,1) == 0) && x > 0;
            validN = @(x) isnumeric(x) && (mod(x,1) == 0) && x >= 0;
            validL = @(x) isnumeric(x) && (x == 1 || x == 2);
            validR = @(x) isnumeric(x) && (x == 3 || x == 2);
            
            addRequired(p,'src',validsrc);
            addRequired(p,'L',validL);
            addRequired(p,'R',validR);
            addOptional(p,'start',defaultst,validst);
            addOptional(p,'N',defaultN,validN);
            
            parse(p,src,L,R,varargin{:});
            
            ir.src = p.Results.src;
            ir.L = p.Results.L;
            ir.R = p.Results.R;
            ir.start = p.Results.start;
            ir.N = p.Results.N;
        end
        
        function [left, right, loop] = next(ir)
            %modify the folder address of the src to add subfolder like
            %P1E_S1_C1
                  
            %right is not used
            right = [];
            
            folder_address = char(ir.src);
            subfolder = folder_address(end-5:end);
            subfolder_left = subfolder + "_C" + ir.L;
            %which frame to start "00000001" eight digits
            left = zeros(600,800,(ir.N+1)*3);
            %right = zeros(600,800,(ir.N+1)*3);
            for i = 1:ir.N+1
                %string manipulation
                null = char("0");
                length_start = length(char(string(ir.start + i - 1)));%number of "0"
                length_zero = 8 - length_start;
                picture = string(repmat(null,1,length_zero))+string((ir.start+i-1));
                %generating "00000001" like char.
                left(:,:,3*i-2:3*i) = imread(ir.src +"/" +subfolder_left + "/" + picture + ".jpg");
                %right(:,:,3*i-2:3*i) = imread(ir.src + "\" +subfolder_right + "\" + picture + ".jpg");                
            end
            
            %%%%%%%%%Setting of loop value%%%%%%%%%%%%%%%%%%
            %standard 0, to allow the loop to continune running
            %for testing purpose, set directly to 1 for executing one frame.
            loop = 0;
        end
    end
    
end
