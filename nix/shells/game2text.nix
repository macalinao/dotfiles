{ pkgs }:
with pkgs;
# See: https://game2text.com/resources/macos/m1-game2text/

let
  game2text-setup = writeShellScriptBin "game2text-setup" ''
    virtualenv venv --system-site-packages
    source venv/bin/activate
    pip install -U eel pytesseract psutil opencv-python pydub fuzzywuzzy requests googletrans parse pynput pyperclip pyyaml sudachipy sudachidict_small
  '';
  game2text-start = writeShellScriptBin "game2text-start" ''
    source venv/bin/activate
    python game2text.py
  '';
  game2text-python =
    (python39Full.override {
      packageOverrides = pyself: pysuper: {
        # Disable tk tests in Pillow
        pillow = (pysuper.pillow.overridePythonAttrs (old: rec {
          postPatch = ''
            ${old.postPatch}
            rm Tests/test_imagetk.py
          '';
        }));
        # For some reason, twisted tests trigger a trap
        twisted = (pysuper.twisted.overridePythonAttrs (old: rec {
          doCheck = false;
        }));
      };
    }).withPackages (ps: with ps; [
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

      levenshtein
      pytesseract
      opencv4
      fuzzywuzzy

      # various dependencies
      bottle

      # Broken for reason:
      # > ERROR: Could not find a version that satisfies the requirement pyobjc-framework-Quartz>=8.0; sys_platform == "darwin" (from pynput) (from versions: none)
      # pynput
    ]);
in
mkShell {
  name = "game2text";
  buildInputs = [
    tesseract5
    portaudio
    tk

    python39Packages.tkinter
    game2text-python
    game2text-setup
    game2text-start

    # needed for sudachi.rs to build properly
    rustup
  ] ++ (
    lib.optional stdenv.isDarwin [ libiconv ]
  );
}
