import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Actions.SpawnOn (spawnOn)
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks (docks)
import XMonad.Util.EZConfig (additionalKeys)

myWorkspaces :: [[Char]]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

myStartupHook :: X ()
myStartupHook = do
  spawnOn "1" "brave --profile-directory=Default"

  -- For some reason, these don't spawn on the correct workspace
  -- spawnOn "3" "kitty tmux"

  -- spawnOn "5" "Discord"
  -- spawnOn "5" "slack"
  -- spawnOn "5" "keybase-gui"
  -- spawnOn "5" "signal-desktop"
  -- spawnOn "5" "telegram-desktop"

  spawn "configure-monitors"

main :: IO ()
main =
  xmonad $
    docks $
      ewmh
        def
          { terminal = "kitty",
            handleEventHook = fullscreenEventHook,
            modMask = mod4Mask,
            workspaces = myWorkspaces,
            startupHook = myStartupHook
          }
        `additionalKeys` [ ((mod1Mask, xK_p), spawn "rofi -show run"),
                           ((mod4Mask, xK_space), spawn "rofi -show calc -modi calc -no-show-match -no-sort"),
                           ((mod1Mask, xK_Delete), spawn "xscreensaver-command -lock"),
                           ((mod4Mask, xK_Control_R), spawn "rofi -show emoji"),
                           ((mod1Mask, xK_z), spawn "rofi -show window"),
                           ((mod1Mask .|. shiftMask, xK_p), spawn "rofi-systemd"),
                           -- media keys
                           ((0, xF86XK_AudioLowerVolume), spawn "amixer sset Master 2%-"),
                           ((0, xF86XK_AudioRaiseVolume), spawn "amixer sset Master 2%+"),
                           ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle"),
                           ((0, xF86XK_AudioPlay), spawn "playerctl play-pause"),
                           ((0, xF86XK_AudioPrev), spawn "playerctl previous"),
                           ((0, xF86XK_AudioNext), spawn "playerctl next")
                         ]
