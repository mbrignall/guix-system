;; Indicate which modules to import to access the variables
;; used in this configuration.
(define-module (config system config)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages xdisorg)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(use-service-modules cups
		     desktop
		     networking
		     ssh
		     xorg
		     sound
		     sddm)

(use-package-modules cups
                     fonts
                     screen
                     ssh
                     wm)

(define etc-sudoers-config
  (plain-file "etc-sudoers-config"
              "Defaults  timestamp_timeout=480
root        ALL=(ALL) ALL
%wheel      ALL=(ALL) ALL
user        ALL=(ALL) NOPASSWD:/run/current-system/profile/bin/loginctl"))

(define guix-system-services
  (cons*
   ;; Below is the list of system services.  To search for available
   ;; se`rvices, run 'guix system search KEYWORD' in a terminal.
   (service screen-locker-service-type
            (screen-locker-configuration
             (name "swaylock")
             (program
              (file-append swaylock "/bin/swaylock"))
             (using-pam? #t)
             (using-setuid? #f)))
   (service gnome-desktop-service-type)
   (service bluetooth-service-type)
   (modify-services %desktop-services
                    (gdm-service-type config =>
                                      (gdm-configuration
                                       (inherit config)
                                       (wayland? #t))))))
  
(define guix-os
  (operating-system
   (locale "en_GB.utf8")
   (timezone "Europe/London")
   (sudoers-file etc-sudoers-config)
   (keyboard-layout
    (keyboard-layout "us"))
   (host-name "aloysius")
   (kernel linux)
   (initrd microcode-initrd)
   (firmware
    (list sof-firmware linux-firmware))
   
   ;; The list of user accounts ('root' is implicit).
   (users
    (cons*
     (user-account
      (name "aloysius")
      (comment "Aloysius")
      (group "users")
      (shell
       (file-append bash "/bin/bash"))
      (home-directory "/home/aloysius")
      (supplementary-groups
       '("wheel" "netdev" "audio" "video")))
     %base-user-accounts))
   
   ;; Packages installed system-wide.  Users can also install packages
   ;; under their own account: use 'guix search KEYWORD' to search
   ;; for packages and 'guix install PACKAGE' to install a package.
   (packages
    (append
     (list
      alacritty
      alsa-utils
      bluez
      brightnessctl
      dbus 
      emacs
      emacs-guix
      fuzzel
      font-fira-code
      git
      grimshot
      linux
      mako
      pavucontrol
      pipewire
      wireplumber
      polkit
      sway
      swaybg
      swayidle
      swaylock
      waybar
      wdisplays
      xdg-desktop-portal-wlr
      zsh)
     %base-packages))
   
   ;; This is the default list of services we
   ;; are appending to.
   ;;%desktop-services))
   (bootloader
    (bootloader-configuration
     (bootloader grub-efi-bootloader)
     (targets
      (list "/boot/efi"))
     (keyboard-layout keyboard-layout)))
   (swap-devices
    (list
     (swap-space
      (target
       (uuid
        "bba2936a-8c33-4a9e-bab9-21b5bb5f4094")))))
   
   ;; The list of file systems that get "mounted".  The unique
   ;; file system identifiers there ("UUIDs") can be obtained
   ;; by running 'blkid' in a terminal.
   (file-systems
    (cons*
     (file-system
      (mount-point "/boot/efi")
      (device
       (uuid "0081-53B9"
             'fat32))
      (type "vfat"))
     (file-system
      (mount-point "/")
      (device
       (uuid
        "0eb34dbb-4b4b-4a4f-9d50-14482ea1ec23"
        'ext4))
      (type "ext4"))
     %base-file-systems))

   (services guix-system-services)))

guix-os
