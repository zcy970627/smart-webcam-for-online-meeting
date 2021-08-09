function [result] = render(frame,mask,bg,mode)
% Add function description here
% foreground: Original foreground ,black background
% background: Black foreground, original background 
% overlay   : Magenta for foreground
% substitute: Replace original background with bg


switch(mode)
    case 'foreground' 
        ImageR = frame(:,:,1);
        ImageG = frame(:,:,2);
        ImageB = frame(:,:,3);
        ImageR(~mask) = 0;
        ImageG(~mask) = 0;
        ImageB(~mask) = 0;
        frame(:,:,1) = ImageR;
        frame(:,:,2) = ImageG;
        frame(:,:,3) = ImageB;
        result = frame;
    case 'background'
        ImageR = frame(:,:,1);
        ImageG = frame(:,:,2);
        ImageB = frame(:,:,3);
        try
        ImageR(mask) = 0;
        ImageG(mask) = 0;
        ImageB(mask) = 0;
        end
        frame(:,:,1) = ImageR;
        frame(:,:,2) = ImageG;
        frame(:,:,3) = ImageB;
        result = frame;
    case 'overlay'

        ImageR = frame(:,:,1);
        ImageG = frame(:,:,2);
        ImageB = frame(:,:,3);
        ImageR(mask==1) = ImageR(mask==1);
        ImageG(mask==1) = ImageG(mask==1) + 50;
        ImageB(mask==1) = ImageB(mask==1);
        ImageR(mask==0) = ImageR(mask==0) + 50;
        ImageG(mask==0) = ImageG(mask==0);
        ImageB(mask==0) = ImageB(mask==0);
        frame(:,:,1)=ImageR;
        frame(:,:,2)=ImageG;
        frame(:,:,3)=ImageB;
        result=frame;

 
        
    case 'substitute'
        ImageR = frame(:,:,1);
        ImageG = frame(:,:,2);
        ImageB = frame(:,:,3);
        ImageR(~mask) = 0;
        ImageG(~mask) = 0;
        ImageB(~mask) = 0;
        frame(:,:,1) = ImageR;
        frame(:,:,2) = ImageG;
        frame(:,:,3) = ImageB;
        ImageR = bg(:,:,1);
        ImageG = bg(:,:,2);
        ImageB = bg(:,:,3);
        try
        ImageR(mask) = 0;
        ImageG(mask) = 0;
        ImageB(mask) = 0;
        end
        bg(:,:,1) = ImageR;
        bg(:,:,2) = ImageG;
        bg(:,:,3) = ImageB;
        
        result = frame + bg;
end
