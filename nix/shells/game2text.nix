{ pkgs }:
with pkgs;
# See: https://game2text.com/resources/macos/m1-game2text/

let
  game2text-setup = writeShellScriptBin "game2text-setup" ''
    virtualenv venv --system-site-packages
    source venv/bin/activate
    pip install -U eel pytesseract psutil opencv-python pydub fuzzywuzzy requests googletrans parse pynput pyperclip pyyaml sudachipy sudachidict_small
  '';
  game2text-python =
    python38Full.withPackages
      (ps:
        with ps; [
          pip
          pyaudio
          virtualenv

          tkinter
          gevent
          psutil
          pydub
          requests
          googletrans
          parse
          pyperclip
          pyyaml

          # broken, idk why
          # pynput
          # pytesseract
          # opencv4
          # fuzzywuzzy
        ]);
in
mkShell {
  name = "game2text";
  buildInputs = [
    tesseract5
    portaudio
    tk

    python38Packages.tkinter
    game2text-python
    game2text-setup

    # needed for sudachi.rs to build properly
    rustup
  ] ++ (
    lib.optional stdenv.isDarwin [ libiconv ]
  );
}
