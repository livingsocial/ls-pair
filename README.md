# Pair Program! The Bruce Campbell Way

This is a small set of tools designed to provide a baseline environment
for doing remote pair programming via SSH.  The stack consists of:

* SSH
* Wemux, a wrapper around tmux to simplify multi-user access
* A baseline configuration file for tmux
* An install script to facilitate setup

You'll also want to set up a VoIP connection; you can negotiate this on a
pair-by-pair basis.



# Known Issues

* These instructions, and the user management scripts, are only tested
  on Mac OS X Lion.



# Rationale

While it can be cool to do remote screen-sharing, the sad fact is that pushing
bitmaps across the wire takes a lot of bandwidth, and the user experience for
the "guest" is... suboptimal.  So, this project bundles up a reasonably usable
set of terminal-based tools.  Just think of it as retrocomputing and you'll be
fine.  (Actually, it can be nice to have a shared environment that's just for
work, so nobody has to worry about embarrassing IM notifications derailing the
conversation.)



# Audio

Having a high-quality audio channel is ***critical*** to remote pairing.
Strictly speaking, this is not something the ls-pair toolkit can set up for
you, but here are some things to keep in mind:

* **Background Noise:** Shared offices are ***loud***. Grab a breakout room if
  you can.

* **External Speakers:** Please don't use them unless you're ***certain***
  that the sound won't feed back into your mic and bounce back to your
  partner. It's incredibly distracting.

* **Microphone:** The mics built in to your Apple laptop or external display
  are tolerable if you're in a quiet environment. In big open-plan
  offices, though, they're useless. Please use a microphone that's close to
  your mouth, designed for use in noisy environments, or both.

  * If you already have a Skype-friendly headset, dig it out of your drawer.

  * If you have a pair of iPhone earbuds, the mic works reasonably well.
    They can be a bit uncomfortable for extended wear -- YMMV.

  * If you don't have anything, consider this $50 headset with an inline mic
    and iPhone control. They're "open" headphones, so people around you will
    hear your music, but the effect is much less noticeable with voice.
    They're not going to block as much ambient noise as a closed-ear
    headphone, but they're light and reasonably comfortable to wear all day
    long.
    ([Amazon link](http://www.amazon.com/Sennheiser-PX-100-II-Supra-Aural-Headset/dp/B003WV8PKG/))
    <br /> *(FWIW, I've also found this headset very convenient for listening
    to music or podcasts while I do chores around the house. -SLG)*

* **Bandwidth:** Mics are the first step, but then your voice has to go
  through a series of tubes. Sometimes packets get dropped. There may not be
  much you can do about this in any given pairing session, but in the long
  term, try to avoid wifi networks with a lot of contention.

* **Software:** I've had decent results with both iChat and Skype. Both are
  significantly better than the "voice chat" option built into, for example,
  [join.me](http://join.me/).

If it's an option, you might **try working from home** on days when you know
you'll spend a significant amount of time doing remote pairing -- you may have
a quieter environment and a better Internet connection, and you'll feel more
comfortable speaking up when you aren't worried about distracting your
coworkers with one half of an ongoing conversation.



# Setting Up

## VPN

LogMeIn's [Hamachi](https://secure.logmein.com/products/hamachi/) is a reliable
way of creating ad-hoc VPNs, but it's a bit annoying to admin.

## SSH

**Please enable SSH on your machine.**  In Lion, go to System
Preferences --> Sharing and click on "Remote Login".  Make sure the box
is checked, and under "Allow access for:", check "All users". (If you
want to whitelist only certain users, you will need to revisit this
preference pane each time you add an account for a new pair-partner.)

You must add your pair partner's SSH public key to the 'public_keys'
subdirectory. The file should be named '{desired_username}.pub', where
'desired_username' is the username your pair partner will use to log in
to your machine.

## Creating Pair-Partner Accounts

You need to create a new account on your machine for each person with
whom you wish to pair. First, make sure you know which username they
will be using and verify that there is a matching public key in the
'public_keys' directory (see SSH above).

This repo includes a script, `bin/create_pair_account`, that will prompt
you for a username, create the account on your system, and set up the
account's '.ssh/authorized_keys' to include the key file in
'public_keys'. No need to worry about setting a password, OSX won't
allow password-based login for this account.

There is also a `bin/create_all_pair_accounts` command that will
provision a pair account for each SSH key in 'public_keys'.

## Other Configuration

  * Clone this repository and cd into its directory
  * Run <code>bin/install</code>


# Pairing

You'll probably want at least a voice channel, if not video.  (I've even
heard some people advise running a video chat window on a completely
separate machine, just so Skype doesn't burn up the CPU on your
development machine.)  That's up to you.

Decide who's going to host the pairing session.

## Hosting a Session

Open a terminal session and type 'wemux start'.

Find your IP address and communicate it to your pair partner.  In
versions of Hamachi that have a GUI client, they should be able to
locate your machine in the GUI and right-click on its hostname, then
select "copy IPv4 address".

## Joining a Session

SSH to {username}@{ip_of_partners_machine} (using the IP address
your pair partner gave you), and type 'wemux pair'.

Possible failure modes include (but are by no means limited to):

* **"No wemux server to pair with on 'wemux'."**
  * This indicates that your host has forgotten to run 'wemux start'.
* **"unknown command: pair"**
  * 'pair' is a wemux *client* command; you may be logged in as a wemux
    *host* (i.e., a user whose name is listed in the host_list variable
    in /usr/local/etc/wemux.conf).
* **You can see the other session, but are unable to type anything.**
  * You somehow joined wemux in mirror mode, not pair mode.



# Other Considerations

## iTerm2

As of Lion, Mac OS X's Terminal.app finally supports 256-color terminal
emulation. However, [iTerm2](http://www.iterm2.com/#/section/home) has a
number of other niceties that you may prefer. I've included a copy of my
preferences file, with a few different color schemes, in
com.googlecode.iterm2.plist; feel free to copy this somewhere. (You can
point iTerm2 at this file by going to Preferences, General, "Load
preferences from a user-defined folder or URL". I suggest copying the file
elsewhere so that any changes you make don't accidentally get pushed back
up into this repository. I have mine in Dropbox.)

## Text Editors

The use of SSH and tmux basically limits your choices to terminal-friendly
editors. (Unless you have some crazy GUI editor with a sharing protocol you
can tunnel across SSH -- in which case, I'd like to see it!)

This project is just about getting two (or more) developers to share
access to the same environment. It is editor-agnostic; each pair can
negotiate whatever editor(s) they're comfortable using. (Note: as long
as you make sure to reload your buffers, it's quite feasible to have vim
in one tmux window and emacs in another.)

## Standard Vim Configuration

If you don't want to pull your hair out while fumbling through your
pair's custom Vim bindings, you can toggle your Vim configuration with
the provided set of configs:

```
bin/toggle_vim_config
```

This script creates a backup of your Vim config and symlinks the ls-pair
`vimrc` and `vim` directory. To toggle back to your configuration,
simply run the command again:

```
bin/toggle_vim_config
```



# License

The MIT License

Copyright (C) 2012 LivingSocial

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
