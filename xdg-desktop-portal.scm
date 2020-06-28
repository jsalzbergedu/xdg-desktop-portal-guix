(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
             ((guix licenses) #:prefix license:)
             (guix build-system glib-or-gtk)
             (gnu packages pkg-config)
             (gnu packages glib)
             (gnu packages gnome)
             (gnu packages fontutils)
             (gnu packages linux))

(package
  (name "xdg-desktop-portal")
  (version "1.6.0")
  (source (origin
            (method url-fetch)
            (uri (format #f "https://github.com/flatpak/xdg-desktop-portal/releases/download/~A/xdg-desktop-portal-~A.tar.xz" version version))
            (sha256
             (base32
              "1nmrmxmsy9l1b8yshxkhwb16wxyx8vslflrbh5aayj2yjad9qg48"))))
  (build-system glib-or-gtk-build-system)
  (arguments
   `(#:configure-flags (list
                        "--enable-libportal=no")))
  (native-inputs `(("pkg-config" ,pkg-config)
                   ("glib:bin" ,glib "bin")
                   ("fontconfig" ,fontconfig)
                   ("json-glib" ,json-glib)
                   ("geoclue" ,geoclue)
                   ("pipewire" ,pipewire)
                   ("fuse" ,fuse)))
  (inputs `(("dbus" ,dbus)))
  (synopsis "Desktop integration portal for Flatpak and Snap")
  (description "xdg-desktop-portal provides a portal frontend service for Flatpak, Snap, and possibly other desktop containment/sandboxing frameworks. This service is made available to the sandboxed application, and provides mediated D-Bus interfaces for file access, URI opening, printing and similar desktop integration features.")
  (home-page "https://github.com/flatpak/xdg-desktop-portal")
  (license license:lgpl2.1+))
