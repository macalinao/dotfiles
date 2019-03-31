import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig

main = xmonad $ defaultConfig {
          terminal = "urxvt"
        }
        `additionalKeys`
        [
          ((mod1Mask, xK_BackSpace), spawn "chromium")
        ]
        `additionalKeysP`
        [
          ("M-x", spawn "rofi -show run")
        , ("M-z", spawn "rofi -show window")
        ]
