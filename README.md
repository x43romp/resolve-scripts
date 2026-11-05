# Resolve Scritps
*By RompDIT*

These are some scripts I used to automate processes in resolve. 


# Installation
**Mac OS X:**

Install for all users
```
/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts
```

Install for current user
```
~/Library/Application Support/Blackmagic Design/DaVinci Resolve/Fusion/Scripts
```

**Windows**

All users
``` 
%PROGRAMDATA%\Blackmagic Design\DaVinci Resolve\Fusion\Scripts
```

Curent user
```
%APPDATA%\Roaming\Blackmagic Design\DaVinci Resolve\Support\Fusion\Scripts
```

**Linux**

All users
```
/opt/resolve/Fusion/Scripts
```
```
/home/resolve/Fusion/Scripts/
```

Current User
```
$HOME/.local/share/DaVinciResolve/Fusion/Scripts
```


## Simpify Bins
This script is used to simplify cards so all of its files are all in one bin instead of nested.

## SST to ST
*Scene-Shot-Take to Shot-Take*
This converts the scenes shot and take to shot take.
Before: `Scene 43, Shot X, Take 1`
After: `Scene 43X Take 001`
Merges the Scene and Shot and also pads the Take to three digits. 


## SST to ST
*Scene-Shot-Take to Shot-Take*
This converts the scenes shot and take to shot take.
Before: `Scene 43X Take 1`
After: `Scene 43, Shot X, Take 001`
Splits Scene to Shot and Scene and also pads the Take to three digits.
