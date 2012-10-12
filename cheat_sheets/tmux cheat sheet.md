# tmux vs wemux

All of these commands are **tmux** commands. **wemux** is just a small set of
bash scripts that makes it easier to share tmux sessions between different
users on the same machine.

# Prefix

Most of these keystrokes begin with "PREFIX". The prefix key is configured in
tmux.conf, and is currently set to ^\ (Ctrl+backslash) -- which, it is hoped,
will not cause *too* many conflicts with emacs.

# Session management

    PREFIX d  _D_etach from the current session

# Window management

    PREFIX c      _C_reate a new window
    PREFIX n      _N_ext window
    PREFIX p      _P_revious window
    PREFIX i      Go to last window (i.e., the one you were just in)
    PREFIX #{n}   Go to window #n
    PREFIX &      Kill the current window
                  (Note: & closes **all** panes in the window.  You can also 
                  quit whatever process is running in the window; tmux will
                  notice when it exits and close the window.)

# Splitting a window into panes

NB: tmux terminology uses "horizontal" and "vertical" in counterintuitive
ways. Our tmux.conf binds '-' and '|' for better mnemonics: use the one that
creates the kind of split you want.

## Pane management

    PREFIX |        Split the current pane into left/right
    PREFIX -        Split the current pane into top/bottom
    PREFIX <space>  Switch between predefined split layouts
    PREFIX x        Kill the current pane
                    (Notes: x also closes the current window, if there's only
                    one pane. If there's only one window, it also exits tmux.
                    You can also quit whatever process is running in the
                    pane; tmux will notice when it exits and close the pane.)

## Navigating between panes

    PREFIX [hjkl]   Use vim-style commands to navigate between panes.

PREFIX followed by an arrow key will also work for navigation, but
you'll have to use the vim equivalents for...

## Resizing split panes

    PREFIX [HJKL]   Resize the current pane by 5 rows/cols

The [HJKL] commands can be repeated *if* you do so within the "repeat-time"
interval, which is expressed in milliseconds. (As of this writing, our
tmux.conf sets that interval to 1000ms; the default is 500ms.)

I *think* the logic might be something like this:

    PREFIX H  Move the RIGHT  border LEFT
    PREFIX J  Move the BOTTOM border DOWN
    PREFIX K  Move the BOTTOM border UP
    PREFIX L  Move the RIGHT  border RIGHT

# Scrollback

    PREFIX [  goes into "Copy mode".  Once there, vim-style navigation is enabled:

        [hjkl]  Move one row/col at a time
        w       Back a word
        b       Forward a word
        ^B      Back a page
        ^F      Forward a page
        g       Go to top
        G       Go to bottom
        q       Quit copy mode

        If you'd like to copy some text while you're there:
        <space> start highlighting
        (move around, then)
        <enter> copies highlighted text into tmux's paste buffer and exits copy mode

    PREFIX ]  Pastes from tmux's paste buffer (assuming there's something in it).

(The [tmux book](http://pragprog.com/book/bhtmux/tmux) mentions that tmux
actually has multiple paste buffers; if you need this, go look it up. ;)
Personally, I just use the OS X copy/paste features, and a little menubar app
called [JumpCut](http://jumpcut.sourceforge.net/) for multiple buffer
goodness. But copy mode might be occasionally useful, so I mention it here.
-SLG)