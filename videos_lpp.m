%Define Constants
%--------------------------------------------------------------------------
% Switch KbName into unified mode: It will use the names of the OS-X
% platform on all platforms in order to make this script portable:
KbName('UnifyKeyNames');
OneKey = KbName('1');                       % "angry" response key
TwoKey = KbName('2');                       % "happy" response key
ThreeKey = KbName('3');                     % "disgust" response key
FourKey  = KbName('4');                     % "sad" response key
FiveKey  = KbName('5');                     % "surprise" response key
SixKey = KbName('6');                       % "fear" response key
SevenKey  = KbName('7');                    % "neutral"response key
esc=KbName('ESCAPE');
screen=max(Screen('Screens'));             % uses the external display if attached
[win, rect] = Screen('OpenWindow', screen); % opens window used for movie display
front = BlackIndex(win);                  % sets the black colour index used for txt
back = WhiteIndex(win);
[center(1), center(2)] = RectCenter(rect);  % get center screen coordinates
xcen = center(1);                           % use to kind of center fixation
ycen = center(2);                           %
xcenInstr = center(1)/2.2;                  % use to kind of center instructions
ycenInstr = center(2)/1.1;                  %
xcenResp = center(1)/1.8;                   % use to kind of center response text
ycenResp = center(2)/1.3;                   %
Screen('FillRect', win, back);            % Fill window in black
Screen('TextFont',win,'Helvetica');         % set Font to be used
Screen('TextSize',win, 32);                 % set Font size
HideCursor                                % Hide cursor - always undo this at end
ListenChar(2);



%Display instruction to start the experiment
%--------------------------------------------------------------------=-----
Screen('DrawText', win, 'Now it is time for the main experiment...', xcenInstr-60,ycenInstr-250,front);
Screen('DrawText', win, 'In this experiment, you are going to be presented with', xcenInstr-60,ycenInstr-200,front);
Screen('DrawText', win, 'a set of emotional expressions from faces and voices.', xcenInstr-60,ycenInstr-150,front);
Screen('DrawText', win, 'There are two tasks in total. ',  xcenInstr-60,ycenInstr-100,front); 
Screen('DrawText', win, 'One is to identify the emotion category you perceived;', xcenInstr-60,ycenInstr-50,front);
Screen('DrawText', win, 'The other is to rate how emotional arousal  ',  xcenInstr-60,ycenInstr,front);
Screen('DrawText', win, 'you feel when perceiveing displays.', xcenInstr-60,ycenInstr+50,front);
Screen('DrawText', win, 'For each task, there are seperate instructions', xcenInstr-60,ycenInstr+100,front);
Screen('DrawText', win, 'for how to respond. So please read the instructions',  xcenInstr-60,ycenInstr+150,front);
Screen('DrawText', win, 'very carefully before you start each block.',  xcenInstr-60,ycenInstr+200,front);
Screen('DrawText', win, '<If you understand the instruction, press any key to continue>',  xcenInstr-100,ycenInstr+250,front);
Screen('Flip',win);
KbWait([],2)


blockTask = randperm(2);
for i = 1: 2
    if blockTask(i)==1
        
        front = WhiteIndex(win);                    % sets the white colour index used for txt
        back= BlackIndex(win);                     % sets the black colour index for background
        [center(1), center(2)] = RectCenter(rect);  % get center screen coordinates
        xcen = center(1);                           % use to kind of center fixation
        ycen = center(2);                           %
        xcenInstr = center(1)/2.2;                  % use to kind of center instructions
        ycenInstr = center(2)/1.1;                  %
        xcenResp = center(1)/1.8;                   % use to kind of center response text
        ycenResp = center(2)/1.3;                   %
        Screen('FillRect', win, back);              % Fill window in black
        Screen('TextFont',win,'Helvetica');         % set Font to be used
        Screen('TextSize',win, 32);                 % set Font size
        
      
        
        %Display Instruction to start condition1
        %--------------------------------------------------------------------=-----
        
        Screen('DrawText', win, 'In this block, you will be presented with', xcenInstr-30,ycenInstr-100,front);
        Screen('DrawText', win, 'a set of emotional expressions from faces.', xcenInstr-30,ycenInstr-50,front);
        Screen('DrawText', win, 'After the display finishes, please respond', xcenInstr-30,ycenInstr,front);
        Screen('DrawText', win, 'which emotion category the display showed.', xcenInstr-30,ycenInstr+50,front);
        Screen('DrawText', win, '<Press any key when ready to start>',xcenInstr-30,ycenInstr+100,front);
        Screen('Flip',win); % Flip to show the screen:
        KbWait([],2)
        %Display trials for condition1
        %--------------------------------------------------------------------------
        
        sequence_stim = 1:68; %  how many stimulus  to present
%         sequence_stim = repmat(sequence_stim,1,2);
        sequence_all = []; %zeros(2,length(sequence_stim)*exptdesign.numsessions);
        randseq = Shuffle(1:length(sequence_stim));
        sequence_all = [sequence_all sequence_stim(randseq)];
        timeOfEvent = 1.16;%
        
        for ij= 1:68
            
            moviename = ['/Volumes/Macintosh HD/Experiments/experiment_peipei/Ac_F/AcF_',num2str(sequence_all(ij)),'.mp4'];
            result.AcF.moviename{ij} = ['AcF_',num2str(sequence_all(ij)),'.mp4'];
            
           
            Screen('FillRect', win, back);% Clear screen to background color:
            Screen('DrawText', win,'+',xcen,ycen,front);
            Screen('Flip',win); % Show cleared screen..
            WaitSecs(0.5)
            [movie movieduration fps] = Screen('OpenMovie', win, moviename);
            
            framecount = movieduration * fps; % We estimate framecount
            Screen('PlayMovie', movie, 1, 0, 1.0);
            
            movietexture=0;     % Texture handle for the current movie frame.
            rttmp=-1;           % Variable to store reaction time.
            lastpts=0;          % Presentation timestamp of last frame.
            onsettime=-1;       % Realtime at which the event was shown to the subject.
            rejecttrial=0;      % Flag which is set to 1 to reject an invalid trial.
            
            
            while(movietexture>=0 && rttmp==-1)
                
                [movietexture pts] = Screen('GetMovieImage', win, movie,0);
                
                if (movietexture>0)% Is it a valid texture?
                    Screen('DrawTexture', win, movietexture); % Draw the texture into backbuffer
                    vbl=Screen('Flip', win);% Flip the display to show the image at next retrace:vbl will contain the exact system time of image onset on screen.
                    if (onsettime==-1)% Is this the event video frame we've been waiting for?
                        onsettime = vbl;% the exact time when the event was presented to the subject. Define it as onsettime
                        if (pts - lastpts > 1.5*(1/fps))%Compare current pts to last one to see if the movie decoder skipped a frame at this crucial point in time. That would invalidate this trial.
                            rejecttrial=1;% Difference to last frame is more than 1.5 times the expected difference under assumption 'no skip'. We skipped in the wrong moment!
                        end;
                    end;
                    
                    lastpts=pts;% Keep track of the frames pts in order to check for skipped frames
                    Screen('Close', movietexture);% Delete the texture.
                    movietexture=0;
                end;
                
            end; % end of the display loop
            %Display response instruction for condition1
            %----------------------------------------------------------------------
            Screen('DrawText', win, 'Please label the emotion in the preceeding display.', xcenInstr-30,ycenInstr-150,front);
            Screen('DrawText', win, 'Press 1 if it was "angry".', xcenInstr-30,ycenInstr-100,front);
            Screen('DrawText', win, 'Press 2 if it was "happy".', xcenInstr-30,ycenInstr-50,front);
            Screen('DrawText', win, 'Press 3 if it was "disgust".', xcenInstr-30,ycenInstr,front);
            Screen('DrawText', win, 'Press 4 if it was "sad".',  xcenInstr-30,ycenInstr+50,front);
            Screen('DrawText', win, 'Press 5 if it was "fear".', xcenInstr-30,ycenInstr+100,front);
            Screen('DrawText', win, 'Press 6 if it was "neutral".', xcenInstr-30,ycenInstr+150,front);
            Screen('Flip',win);
            KbWait([],2)
            
            
            %Get response for condition1
            %----------------------------------------------------------------------
            [keyIsDown, secs, keytmp]=KbCheck; % record keyboard for response.
            if (keyIsDown==1)
                if keytmp(esc)% Abort requested
                    rejecttrial=-1;% This signals abortion
                    break;% Break out of display loop
                end;
                
                if keytmp(OneKey)||keytmp(TwoKey)||keytmp(ThreeKey)||keytmp(FourKey)||keytmp(FiveKey)||keytmp(SixKey)% || ??????????????
                    if (onsettime==-1)% Response too early (before event happened?)
                        rejecttrial=2;% Reject this trial
                    else
                        
                        rttmp=secs - onsettime;% Valid response: Difference between 'secs' and 'onsettime' is the reaction time
                    end;
                end;
                
                result.AcF.response(ij) = find(keytmp==1); % save which key subject pressed.
            end
            
            
            droppedcount = Screen('PlayMovie', movie, 0, 0, 0);
            
            if (droppedcount > 0.2*framecount)
                
                rejecttrial=4;% Over 20% of all frames skipped?!? Playback problems! reject this trial...
            end;
            
            Screen('CloseMovie', movie);% Close the moviefile.
            if (rejecttrial==-1)% Check if aborted.
                break; % Break out of trial loop
            end;
            
            if (rttmp==-1 && rejecttrial==0)
                rejecttrial=3;
            end;
            
            result.AcF.reactiontime(ij) = rttmp
            
            KbReleaseWait;% Wait for subject to release keys: ???????
            
            
        end
        
        
        Screen('DrawText', win, 'End of this block. Press any key to continue...',xcenInstr,ycenInstr,front);
        Screen('Flip',win);
        KbWait([],2)
        
        %>>>>>>>>>>>conidition2--Vocal_expression>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
         elseif blockTask(i)==2
        
        front = WhiteIndex(win);                    % sets the white colour index used for txt
        back= BlackIndex(win);                     % sets the black colour index for background
        [center(1), center(2)] = RectCenter(rect);  % get center screen coordinates
        xcen = center(1);                           % use to kind of center fixation
        ycen = center(2);                           %
        xcenInstr = center(1)/2.2;                  % use to kind of center instructions
        ycenInstr = center(2)/1.1;                  %
        xcenResp = center(1)/1.8;                   % use to kind of center response text
        ycenResp = center(2)/1.3;                   %
        Screen('FillRect', win, back);              % Fill window in black
        Screen('TextFont',win,'Helvetica');         % set Font to be used
        Screen('TextSize',win, 32);                 % set Font size
        
      
                %Display Instruction to start condition4
        %--------------------------------------------------------------------=-----
        
        Screen('DrawText', win, 'In this block, you will be presented with', xcenInstr-30,ycenInstr-100,front);
        Screen('DrawText', win, 'a set of emotional expressions from VOICES.', xcenInstr-30,ycenInstr-50,front);
        Screen('DrawText', win, 'After the display finishes, please rate how', xcenInstr-30,ycenInstr,front);
        Screen('DrawText', win, 'emotional arousal you feel when viewing or listening the display', xcenInstr-30,ycenInstr+50,front);
        Screen('DrawText', win, 'on a scale from 1 (much less than average) to 7 (much more than average).', xcenInstr-80,ycenInstr+100,front);
        Screen('DrawText', win, '<Press any key when ready to start>',xcenInstr-30,ycenInstr+150,front);
        Screen('Flip',win); % Flip to show the screen:
        KbWait([],2)
        %Display trials for condition1
        %--------------------------------------------------------------------------
        
        sequence_stim = 1:60; %  how many stimulus  to present
%         sequence_stim = repmat(sequence_stim,1,2);
        sequence_all = []; %zeros(2,length(sequence_stim)*exptdesign.numsessions);
        randseq = Shuffle(1:length(sequence_stim));
        sequence_all = [sequence_all sequence_stim(randseq)];
        timeOfEvent = 1.16;%
        
        for ij= 1:60
            
            moviename = ['/Volumes/Macintosh HD/Experiments/experiment_peipei/Arousal_V/ArV_',num2str(sequence_all(ij)),'.mp4'];
            result.ArV.moviename{ij} = ['ArF_',num2str(sequence_all(ij)),'.mp4'];
            
           
            Screen('FillRect', win, back);% Clear screen to background color:
            Screen('DrawText', win,'+',xcen,ycen,front);
            Screen('Flip',win); % Show cleared screen..
            WaitSecs(0.5)
            [movie movieduration fps] = Screen('OpenMovie', win, moviename);
            
            framecount = movieduration * fps; % We estimate framecount
            Screen('PlayMovie', movie, 1, 0, 1.0);
            
            movietexture=0;     % Texture handle for the current movie frame.
            rttmp=-1;           % Variable to store reaction time.
            lastpts=0;          % Presentation timestamp of last frame.
            onsettime=-1;       % Realtime at which the event was shown to the subject.
            rejecttrial=0;      % Flag which is set to 1 to reject an invalid trial.
            
            while(movietexture>=0 && rttmp==-1)
                
                [movietexture pts] = Screen('GetMovieImage', win, movie,0);
                
                if (movietexture>0)% Is it a valid texture?
                    Screen('DrawTexture', win, movietexture); % Draw the texture into backbuffer
                    vbl=Screen('Flip', win);% Flip the display to show the image at next retrace:vbl will contain the exact system time of image onset on screen.
                    if (onsettime==-1)% Is this the event video frame we've been waiting for?
                        onsettime = vbl;% the exact time when the event was presented to the subject. Define it as onsettime
                        if (pts - lastpts > 1.5*(1/fps))%Compare current pts to last one to see if the movie decoder skipped a frame at this crucial point in time. That would invalidate this trial.
                            rejecttrial=1;% Difference to last frame is more than 1.5 times the expected difference under assumption 'no skip'. We skipped in the wrong moment!
                        end;
                    end;
                    
                    lastpts=pts;% Keep track of the frames pts in order to check for skipped frames
                    Screen('Close', movietexture);% Delete the texture.
                    movietexture=0;
                end;
                
            end; % end of the display loop
            
            %Display response instruction for condition1
            %----------------------------------------------------------------------
            Screen('DrawText', win, 'Please rate how emotional arousal you feel of this display', xcenInstr-30,ycenInstr,front);
            Screen('DrawText', win, 'on a scale from 1 (much less than average) to 7 (much more than average).', xcenInstr-80,ycenInstr+50,front);
            Screen('Flip',win);
            KbWait([],2)
            
            
            %Get response for condition1
            %----------------------------------------------------------------------
            [keyIsDown, secs, keytmp]=KbCheck; % record keyboard for response.
            if (keyIsDown==1)
                if keytmp(esc)% Abort requested
                    rejecttrial=-1;% This signals abortion
                    break;% Break out of display loop
                end;
                
                if keytmp(OneKey)||keytmp(TwoKey)||keytmp(ThreeKey)||keytmp(FourKey)||keytmp(FiveKey)||keytmp(SixKey)||keytmp(SevenKey)% || ??????????????
                    if (onsettime==-1)% Response too early (before event happened?)
                        rejecttrial=2;% Reject this trial
                    else
                        
                        rttmp=secs - onsettime;% Valid response: Difference between 'secs' and 'onsettime' is the reaction time
                    end;
                end;
                
                result.ArV.response(ij) = find(keytmp==1); % save which key subject pressed.
            end
            
            
            droppedcount = Screen('PlayMovie', movie, 0, 0, 0);
            
            if (droppedcount > 0.2*framecount)
                
                rejecttrial=4;% Over 20% of all frames skipped?!? Playback problems! reject this trial...
            end;
            
            Screen('CloseMovie', movie);% Close the moviefile.
            if (rejecttrial==-1)% Check if aborted.
                break; % Break out of trial loop
            end;
            
            if (rttmp==-1 && rejecttrial==0)
                rejecttrial=3;
            end;
            
            result.ArV.reactiontime(ij) = rttmp
            
            KbReleaseWait;% Wait for subject to release keys: ???????
            
            
        end
        
        
        Screen('DrawText', win, 'End of this block. Press any key to continue...',xcenInstr,ycenInstr,front);
        Screen('Flip',win);
        KbWait([],2)
        
        
          
        
    end;
end;

pathfile = '/Volumes/Macintosh HD/Experiments/experiment_peipei/result_ER_mainExp/';
save ([pathfile, subjCode '.mat'], 'result','movieduration','secs','onsettime','blockTask','v'); 

%Finish this block, participants will be informed to take a break
%----------------------------------------------------------------------
% Done with the experiment. Close onscreen window and finish.
Screen('DrawText', win, 'That is the end of the experiment.',xcenInstr,ycenInstr,front);
Screen('DrawText', win, 'THANK YOU for your participation.',xcenInstr,ycenInstr+50,front);
Screen('DrawText', win, 'Press any key to exit.',xcenInstr,ycenInstr+100,front);
Screen('Flip',win);
KbWait([],2)