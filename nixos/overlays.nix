self: super:
let
  gtk3 = super.gtk3.overrideAttrs (oa: {
    patches = oa.patches ++ [
      (self.fetchpatch {
        # missing symbols but exported from gir
        url = https://gitlab.gnome.org/GNOME/gtk/commit/95c0f07295fd300ab7f3416a39290ae33585ea6c.patch;
        sha256 = "0z9w7f39xcn1cbcd8jhx731vq64nvi5q6kyc86bq8r00daysjwnl";
      })
    ];
  });
in
{
  haskellPackages = with self.haskell.lib; super.haskellPackages.extend (hself: hsuper: {
    gi-gdk = hsuper.gi-gdk.override { inherit gtk3; };
    taffybar = overrideCabal (hsuper.taffybar.overrideAttrs (oa : {
      src = self.fetchFromGitHub {
        owner = "taffybar";
        repo = "taffybar";
        rev = "e382599358bb06383ba4b08d469fc093c11f5915";
        sha256 = "0qncwpfz0v2b6nbdf7qgzl93kb30yxznkfk49awrz8ms3pq6vq6g";
      };
    })) (attrs: {
      libraryHaskellDepends = attrs.libraryHaskellDepends ++ [hself.HTTP];
    });
  });
}
