import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

main = xmonad
  $ docks
  $ ewmh def {
          terminal = "urxvt",
          handleEventHook = fullscreenEventHook
        }
        `additionalKeys`
        [
          ((mod1Mask, xK_p), spawn "rofi -show run"),
          ((mod1Mask, xK_BackSpace), spawn "chromium"),
          ((mod1Mask, xK_Delete), spawn "xscreensaver-command -lock"),
          ((mod1Mask, xK_z), spawn "rofi -show window"),
          ((mod1Mask .|. shiftMask, xK_p), spawn "rofi-systemd")
        ]
