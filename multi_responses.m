clc;clear;close all
% press 's' or 'l' or simultaneously
% FEI YI - UNIVERSITY OF GLASGOW - SEP 2016

DemoRect=[0 0 600 700];
keys = ['s','l'];
FlipClearMode = 0; % clears frames after flip
scrWdp = 800;  scrHtp = 600;    
image = randn(100,100); % image

try
    FlushEvents
    
    [w,~] = Screen('OpenWindow',0,127.5,DemoRect);
    black = BlackIndex(w);  % Retrieves the CLUT color code for black.
    white = WhiteIndex(w);  % Retrieves the CLUT color code for white.
%     gray = (black + white) / 2;  % Computes the CLUT color code for gray.
    priorityLevel = MaxPriority(w); % highest priority for stim presentation
    ListenChar(2);
        
    % message to press key to begin next block of trials
    Screen('DrawText', w, 'Press any key', scrWdp/2-128+10, scrHtp/2-25, 0, 160);
    Screen('DrawText', w, 'to start...',  scrWdp/2-128+10, scrHtp/2, 0, 160);
    Screen('FrameRect', w, 0, DemoRect);
    Screen('Flip',w);
    fprintf('waiting for a keypress...\n');
    KbWait;
    WaitSecs(1)
    Screen('FillRect', w, black);
    Screen('Flip',w);
    
    for trial = 1:2%:exptdesign.numtrials

        Screen('FillRect', w, black);
        [VBLTimestamp, FixPntOffset] = Screen('Flip',w);
        if trial >= 2
            [VBLTimestamp, FixOnsetTime] = Screen('Flip',w);
            RunTime=FixOnsetTime+4;
            Screen('FillRect', w, black);
            while GetSecs < RunTime
            end
            [VBLTimestamp, FixPntOffset] = Screen('Flip',w);
        end
       
        % image
        TexturePtr = Screen('MakeTexture', w, image );
        Screen('DrawTexture', w, TexturePtr);
        Screen('DrawingFinished', w, FlipClearMode);
        Screen('Close', TexturePtr);       
        FlushEvents;
        Priority(priorityLevel);
        [VBLTimestamp, StimOnsetTime] = Screen('Flip', w, FixPntOffset, FlipClearMode);       
        Screen('FillRect', w, black);

        
        Priority(0);        
        count =0;
        RunTime=StimOnsetTime+10;
        while GetSecs < RunTime
            
            [keyisdown,secs,keycode] = KbCheck;
            
            if keyisdown
                count =count+1;
                resp{count,trial} = KbName(find(keycode));
                rt{count,trial} = secs - StimOnsetTime;
            end
        end
        [VBLTimestamp, StimOffsetTime] = Screen('Flip',w);      
        FlushEvents;
        
        %                 save(filename,'resp','rt')
    end
    
    % results
    for trial = 1:size(rt,2)
        count = 0;
        for No =  1:size(rt,1)-1
            
            if isempty(find(sum(KbName(resp{No,trial})) == sum(KbName(resp{No+1,trial}))))
                count = count+1;
                result.where(count,trial) = No+1;
                result.what{count,trial} = resp{No+1,trial} ;
                tmp(count,trial) = rt{No+1,trial};
                
                if count < 2
                    result.wrt(count,trial) = tmp(count,trial) ;
                elseif count>=2
                    result.wrt(count,trial) = tmp(count,trial) - tmp(count-1,trial);
                end
            end
            
        end
        
    end
    
            %                 save(filename,'result')
    sca;
    ListenChar(0);

catch
    sca;
    ListenChar(0);

end







