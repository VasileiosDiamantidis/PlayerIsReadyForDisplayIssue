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
