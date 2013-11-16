---
title: Muting/unmuting Skype for lazy people
---

With my current employer, we decided telecommuting was worth a try.

Our office is distributed between Barcelona and Bologna, with occasional incursions by traveler colleagues who happen to be in some random coffee house around the world.

One of the key elements for this setup to be practical and effective is Skype, which I don't particularly like but I have to admit works pretty well in this scenario. In our headquarters in Bologna there's an USB microphone/speaker, which my colleagues connect in shifts to their laptops, or to a spare Android tablet. On my side, I use the <a class="zem_slink" title="MacBook Pro" href="http://www.apple.com/macbookpro/" rel="homepage">Macbook Pro</a> internal mic and headphones.

The Skype audio chat is <strong>always on</strong>, meaning that it's almost like being there: I only miss lunch and coffee breaks.

Actually, it seems it's even more vivid than the real thing. It's not unusual some of them shout "MUTE!" in my direction: the internal microphone on my parts takes in too much consideration the <em>tik-ke-ti-tak</em> of the keyboard, which in Bologna becomes an unsolicited, thunderous and rather unpleasant proof I'm really at my desk.

Of course I could use the handy HUD window with all the Skype controls, but that requires 1) finding its position on the screen, 2) moving my hands from keyboard to trackpad, 3) click the mute button. I'm lazy, and I wanted something less cumbersome. Something like a keyboard trigger to toggle the mute status of the current Skype call. Triggers? <a href="http://www.blacktree.com/">Quicksilver</a> to the rescue.

I knew Quicksilver permits to assign arbitrary actions to hotkeys, and those actions can be anything you can do with Quicksilver: for example, running an Applescript program. Unfortunately, a quick inspection in the Skype's Applescript dictionary revealed there was no direct and simple access to the Mute toggle. Here the first program I wrote to solve the problem:

``` Applescript
on run argv
    set front_app to (path to frontmost application as Unicode text)
    tell application "Skype" to activate
    menu_click({"Skype", "Conversations", (item 1 of argv) & " Microphone"})
    tell application front_app to activate
end run


-- http://hints.macworld.com/article.php?story=20060921045743404
-- `menu_click`, by Jacob Rus, September 2006
-- 
-- Accepts a list of form: `{"Finder", "View", "Arrange By", "Date"}`
-- Execute the specified menu item.  In this case, assuming the Finder 
-- is the active application, arranging the frontmost folder by date.

on menu_click(mList)
    local appName, topMenu, r

    -- Validate our input
    if mList's length < 3 then error "Menu list is not long enough"

    -- Set these variables for clarity and brevity later on
    set {appName, topMenu} to (items 1 through 2 of mList)
    set r to (items 3 through (mList's length) of mList)

    -- This overly-long line calls the menu_recurse function with
    -- two arguments: r, and a reference to the top-level menu
    tell app "System Events" to my menu_click_recurse(r, ((process appName)'s ¬
        (menu bar 1)'s (menu bar item topMenu)'s (menu topMenu)))
end menu_click

on menu_click_recurse(mList, parentObject)
    local f, r

    -- `f` = first item, `r` = rest of items
    set f to item 1 of mList
    if mList's length > 1 then set r to (items 2 through (mList's length) of mList)

    -- either actually click the menu item, or recurse again
    tell app "System Events"
        if mList's length is 1 then
            click parentObject's menu item f
        else
            my menu_click_recurse(r, (parentObject's (menu item f)'s (menu f)))
        end if
    end tell
end menu_click_recurse
```

This is largely based on a piece of code by <a href="http://www.hcs.harvard.edu/~jrus/">Jacob Rus</a> I found in a <a href="http://hints.macworld.com/article.php?story=20060921045743404">hold post on Macworld</a>. It accepts a single parameters ("<em>Mute</em>" or "<em>Unmute</em>") and it will work only if you use the English Skype localization. I don't think there's something particularly interesting in this program, except the useful code I borrowed from Jacob, the trick with <em>frontmost application</em> to re-activate the application which had the focus before switching to Skype and, yes!, the fact is remarkably long to perform such a simple task. Also, I'm not set with only this script: I'd need to create two different hotkeys for muting and un-muting, and assign them to two different ways of calling the script itself.

There must be a shorter path.

To a closer inspection (silly me!), I noticed the menu item I'm using keeps the same hotkey (I mean hotkey from Skype's standpoint): no matter what the current mic status is, it's always ??M. Let's try to shorten the program.

    set front_app to (path to frontmost application as Unicode text)
    tell application "System Events"
        tell application "Skype" to activate
        keystroke "M" using {command down, shift down} 
    end tell
    tell application front_app to activate

No need to differentiate the mechanism, and there is so much less code!
<div class="zemanta-pixie" style="margin-top: 10px; height: 15px;"><img class="zemanta-pixie-img" style="border: none; float: right;" alt="" src="http://img.zemanta.com/pixy.gif?x-id=90f33d62-818c-4d4d-84bf-4134a787529e" /></div>
