import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

main = xmonad
  $ docks
  $ ewmh def {
          terminal = "urxvt",
          handleEventHook = fullscreenEventHook,
          modMask = mod4Mask
        }
        `additionalKeys`
        [
          ((mod1Mask, xK_p), spawn "rofi -show run"),
          ((mod4Mask, xK_space), spawn "rofi -show calc -modi calc -no-show-match -no-sort"),
          ((mod1Mask, xK_BackSpace), spawn "chromium"),
          ((mod1Mask, xK_Delete), spawn "xscreensaver-command -lock"),
          ((mod1Mask, xK_z), spawn "rofi -show window"),
          ((mod1Mask .|. shiftMask, xK_p), spawn "rofi-systemd")
        ]
