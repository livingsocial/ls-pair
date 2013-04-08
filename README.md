# Pair Program! The Bruce Campbell Way

This is a small set of tools designed to provide a baseline environment
for doing remote pair programming via SSH.  The toolkit consists of:

* Wemux, a wrapper around tmux to simplify multi-user access
* A common baseline configuration for tmux and vim (none of us use emacs; PRs
  welcome)
* An install script to facilitate setup

While it can be cool to do remote screen-sharing, the sad fact is that pushing
bitmaps across the wire takes a lot of bandwidth, and the user experience for
the guest is... suboptimal.  So, this project bundles up a reasonably usable
set of terminal-based tools.  Just think of it as retrocomputing and you'll be
fine.  :D


<br /><hr /><br />


# HOWTO: Host a Session on Your Computer

## Preflight Checklist:

* You've completed basic setup (see [Setting Up](#setting-up), below).
* You have SSH keys for all of your intended guests, and you've created accounts (see
  <code>bin/create\_all\_pair\_accounts</code>) for them to use.
* In System Preferences, Sharing:  "Remote Login" (aka SSH) is enabled, and your guest
  accounts are allowed to use it.  (The easiest way to ensure this is to enable it for
  all users; if you're using a whitelist approach, you'll have to visit this screen
  every time you pair with someone new.)
* Your computer is reachable over at least one Internets:
  * If using Hamachi, make sure it's running, and that you've added your guest's machine
    to at least one of your networks.

## Takeoff:

* Open a terminal window, make the font as small as you can tolerate, and make the window
  as big as you can tolerate (bonus points for using full-screen mode).
* Run: <code>wemux start</code>
* Start an audio and/or video chat session (FaceTime, G+ Hangout, iChat, Skype) with your
  guest(s).  If necessary, give them the IP address they can SSH to.
* If your terminal dimensions are larger than those of your guest(s), you'll see a border
  appear on the right and/or bottom edge of your terminal window as soon as *they* run
  <code>wemux pair</code>.
* Within tmux's "status-interval" setting (5 seconds as of this writing), you'll see the
  tmux status bar update with the usernames of all users currently in the tmux session.

## In flight:

* Pair as usual.  Air traffic control suggests using the "mine/yours" protocol to
  negotiate control of the keyboard.  <br />(Protip: either word can be inflected as a
  question or a statement.)

## Landing:

* If you're done with your tmux session, just exit all of the shells running inside it;
  it'll shut down once its last hosted process exits.
* If you'd like to leave your state hanging around for later, use PREFIX, d to **D**etach.
  It'll stick around as long as your computer stays on.  <br />(To come back later, just run
  <code>wemux start</code> again; wemux will figure out that there's a session already
  running and reattach you to it.)


<br /><hr /><br />


# HOWTO: Join a Session on Someone Else's Computer

## Preflight Checklist:

* You're able to reach your host's computer over at least one Internets:
  * If using Hamachi, make sure it's running, and that you can see your host's machine
    on at least one of your networks.

## Takeoff:

* Make sure your host has your SSH public key.
* Open a terminal window, make the font as small as you can tolerate, and make the window
  as big as you can tolerate (bonus points for using full-screen mode).
* Start an audio and/or video chat session (FaceTime, G+ Hangout, iChat, Skype) with your
  host.
* **On your computer**, run: <code>ssh *username*@*hosts\_ip\_address*</code>
* **On your host's computer**, run: <code>wemux pair</code>

## In flight:

* Pair as usual.  Air traffic control suggests using the "mine/yours" protocol to
  negotiate control of the keyboard.  <br />(Protip: either word can be inflected as a
  question or a statement.)

## Landing:

* Hit PREFIX, followed by 'd' to **D**etach from tmux on your host's computer.
  <br />(PREFIX should be Control-\ by default, so this is the sequence "Control-\, d" [don't type the comma])
* Hit ^D or type 'exit' to end the SSH session and return to your local computer.


<br /><hr /><br />


# Audio

Having a high-quality audio channel is ***critical*** to remote pairing.
Strictly speaking, this is not something the ls-pair toolkit can set up for
you, but here are some things to keep in mind:

* **Background Noise:** Shared offices are ***loud***. Grab a private room
  if you can.

* **External Speakers:** Please don't use them unless you're ***certain***
  that the sound won't feed back into your mic and bounce back to your
  partner. It's incredibly distracting.

* **Microphone:** The mics built in to your Apple laptop or external display
  are tolerable if you're in a quiet environment. In big open-plan
  offices, though, they're useless. Please use a microphone that's close to
  your mouth, designed for use in noisy environments, or both.

  * If you already have a Skype-friendly headset, dig it out of your drawer.
    These can usually be purchased for under $20 on Amazon or from many
    big-box retailers.

  * If you have a pair of iPhone earbuds, the mic works reasonably well.
    They can be a bit uncomfortable for extended wear -- YMMV.

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

# Video

If you have the hardware and bandwidth to support it, it can be surprisingly
beneficial to have video while pairing.  As social primates, our brains have
dedicated significant resources to decoding body language.  It can be
helpful to run the A/V processing on a completely separate box so that
your primary development machine is not slowed down.  Also, having a
dedicated screen for your partner's video feed makes it harder to cover
them up with another window, which contributes to a telepresence effect.


<br /><hr /><br />


# <a id="setting-up"></a>Setting Up

## All Participants

### VPN

LogMeIn's [Hamachi](https://secure.logmein.com/products/hamachi/) is a reliable
way of creating ad-hoc VPNs, but it's a bit annoying to admin. The set up
process is described in this
[wiki page](https://github.com/livingsocial/ls-pair/wiki/How-to-set-up-LogMeIn-Hamachi).

## Hosts

The rest of this section applies only to hosts.  Guests only need to SSH to
their host's machine.

### SSH

**Please enable SSH on your machine.**  In Lion, go to System
Preferences --> Sharing and click on "Remote Login".  Make sure the box
is checked, and under "Allow access for:", check "All users". (If you
want to whitelist only certain users, you will need to revisit this
preference pane each time you add an account for a new pair-partner.)

You must add your pair partner's SSH public key to the 'public_keys'
subdirectory. The file should be named '{desired_username}.pub', where
'desired_username' is the username your pair partner will use to log in
to your machine.

### Creating Guest Accounts

You need to create a new account on your machine for each person with
whom you wish to pair. First, make sure you know which username they
will be using and verify that there is a matching public key in the
'public_keys' directory (see SSH above).

This repo includes a script, `bin/create_pair_account`, that will prompt
you for a username, create the account on your system, and set up the
account's '.ssh/authorized_keys' to include the key file in
'public_keys'. No need to worry about setting a password; OSX won't
allow password-based login for this account.

There is also a `bin/create_all_pair_accounts` command that will
provision a pair account for each SSH key in 'public_keys'.

### Other Configuration

  * Clone this repository and cd into its directory
  * Run <code>bin/install</code>
  * If you have an existing ~/.vimrc or ~/.vim directory,
    the install script will not overwrite it.
    See the "Standard Vim Configuration" section, below.


<br /><hr /><br />


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


<br /><hr /><br />


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

