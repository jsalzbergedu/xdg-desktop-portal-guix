(define-module (gnu packages xdg-portals)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system glib-or-gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gettext))

(define-public create-desktop-portal-symlink
  `(lambda* (#:key outputs #:allow-other-keys)
     (let* ((out (assoc-ref outputs "out"))
   	 (service-in (string-append out "/etc"))
            (service-to (string-append service-in "/dbus-1"))
            (service-from (string-append out "/share/dbus-1")))
          (mkdir-p service-in)
          (symlink service-from service-to)
          #t)))


(define-public xdg-desktop-portal
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
    `(#:configure-flags (list "--enable-libportal=no")
      #:phases (modify-phases %standard-phases 
			      (add-after 'install 'create-desktop-portal-symlink
                                         ,create-desktop-portal-symlink))))
   (native-inputs `(("pkg-config" ,pkg-config)
                    ("glib:bin" ,glib "bin")
                    ("fontconfig" ,fontconfig)
                    ("json-glib" ,json-glib)
                    ("geoclue" ,geoclue)
                    ("pipewire" ,pipewire)
                    ("fuse" ,fuse)))
   (propagated-inputs `(("dbus" ,dbus)))
   (synopsis "Desktop integration portal for Flatpak and Snap")
   (description "xdg-desktop-portal provides a portal frontend service for Flatpak, Snap, and possibly other desktop containment/sandboxing frameworks. This service is made available to the sandboxed application, and provides mediated D-Bus interfaces for file access, URI opening, printing and similar desktop integration features.")
   (home-page "https://github.com/flatpak/xdg-desktop-portal")
   (license license:lgpl2.1+)))

(define-public xdg-desktop-portal-gtk
  (package
   (name "xdg-desktop-portal-gtk")
   (version "1.6.0")
   (source (origin
            (method url-fetch)
            (uri (format #f "https://github.com/flatpak/xdg-desktop-portal-gtk/releases/download/~A/xdg-desktop-portal-gtk-~A.tar.xz" version version))
            (sha256
             (base32
              "0xiggqjp51a9nc1js9rggljwx3apqrnmmnf6shcp2zi411kd2vwm"))))
   (build-system glib-or-gtk-build-system)
   (arguments
    `(#:phases
      (modify-phases %standard-phases 
                     (add-after 'install 'create-desktop-portal-symlink
			 ,create-desktop-portal-symlink))))
   (native-inputs `(("pkg-config" ,pkg-config)
                    ("glib" ,glib)
                    ("xdg-desktop-portal" ,xdg-desktop-portal)
                    ("gtk+" ,gtk+)
                    ("fontconfig" ,fontconfig)
                    ("gnome-desktop" ,gnome-desktop)
                    ("gnu-gettext" ,gnu-gettext)))
   (synopsis "GTK+/GNOME portal backend for xdg-desktop-portal")
   (description
    "xdg-desktop-portal-gtk provides a GTK+/GNOME implementation for the desktop-agnostic xdg-desktop-portal service. This allows sandboxed applications to request services from outside the sandbox using GTK+ GUIs (app chooser, file chooser, print dialog) or using GNOME services (session manager, screenshot provider). ")
   (home-page "https://github.com/flatpak/xdg-desktop-portal-gtk")
   (license license:lgpl2.1+)))
