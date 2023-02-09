{ pkgs }:
with pkgs;
# See: https://game2text.com/resources/macos/m1-game2text/

let
  game2text-setup = writeShellScriptBin "game2text-setup" ''
    virtualenv venv --system-site-packages
    source venv/bin/activate
    pip3 install -U eel pytesseract pynput sudachipy sudachidict_small
  '';
  game2text-python =
    python311Full.withPackages (ps:
      with ps; [
        pip
        pyaudio
        virtualenv

        # pytesseract
        psutil
        opencv4
        pydub
        fuzzywuzzy
        requests
        googletrans
        parse
        # broken, idk why
        pynput
        pyperclip
        pyyaml
      ]);
in
mkShell {
  name = "game2text";
  buildInputs = [
    tesseract5
    portaudio
    tk

    game2text-python
    game2text-setup

    # needed for sudachi.rs to build properly
    rustup
  ] ++ (
    lib.optional stdenv.isDarwin [ libiconv ]
  );
}
