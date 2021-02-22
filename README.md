# PlayerIsReadyForDisplayIssue
PlayerIsReadyForDisplayIssue is Demo project to find why preview player goes to isReadyForDisplay=false


To reproduce the Issue two things need to be true. 
The link needs to be the TrickPlay URL and the player must be on pause mode.

On all other combinations where the link is the Main player URL or the player is not in paused mode the seek works correctly.

Steps to reproduce.
1. Open the player and seek forward in the seek bar.
2. The player will seek 10 * the value of the slider (0->100) to the past of the live player

Result ❌ <br>
The value of the player \.isReadyForDisplay becomes false

The issue is that the AVPlayerLayer isReadyForDisplay property becomes false on a specific type of live stream if the player is on Pause mode. On the same project with another type of live stream with timeshift enabled there is no issue.

As you can see in the project attached there are 2 URLs the 

**Stream A** line 20
https://demo-hls7-live.zahs.tv/hd/master.m3u8?audio_codecs=aac,eac3&minrate=900&timeshift=3600

And 
**Stream B** line 23
https://demo-hls7-live.zahs.tv/hd/t_track_trick_bw_4800_num_0_tid_3_nd_4000_mbr_5000.m3u8?z32=ORUW2ZLTNBUWM5B5GM3DAMBGOY6TAJTTNFTT2MRRL44DANRRMI2DCOBSGM2DEZBRHFRWGYLGHBSGGNJQMRSTGZBWME4WM

On the same code with URL A we can initialize the player and seek on a past date.

With stream B the playerLayer isReadyForDisplay value changes to false and we can’t perform any action.
