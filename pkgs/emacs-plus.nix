{ fetchpatch, ... }:
self: super: {
  emacsPgtk = super.emacsPgtk.overrideAttrs (old: {
      patches =
        (old.patches or [])
        ++ [
          # Fix OS window role (needed for window managers like yabai)
          (fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            sha256 = "0c41rgpi19vr9ai740g09lka3nkjk48ppqyqdnncjrkfgvm2710z";
          })
          # Use poll instead of select to get file descriptors
          (fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
            sha256 = "0j26n6yma4n5wh4klikza6bjnzrmz6zihgcsdx36pn3vbfnaqbh5";
          })
          # Enable rounded window with no decoration
          (fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
            sha256 = "111i0r3ahs0f52z15aaa3chlq7ardqnzpwp8r57kfsmnmg6c2nhf";
          })
          # Make Emacs aware of OS-level light/dark mode
          (fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
            sha256 = "14ndp2fqqc95s70fwhpxq58y8qqj4gzvvffp77snm2xk76c1bvnn";
          })
        ];
   });
}
