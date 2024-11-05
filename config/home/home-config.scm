(define-module (home home-config)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services shells)
  #:use-module (gnu packages)
  #:use-module (guix gexp))

(use-package-modules fonts
                     version-control
                     guile
                     guile-xyz
                     emacs
                     emacs-xyz
                     linux
                     sdl
                     compression
                     web-browsers
                     wm
                     xorg
                     xdisorg
                     freedesktop
                     ssh
                     cups
                     suckless
                     networking
                     package-management)


;;; Packages
(define guile-packages
  (list guile-next ;;|--> gnu packages guile
        guile-ares-rs ;;|--> gnu packages guile-xyz
        guile-hoot
        guile-websocket
        guile-sdl2 ;;|--> gnu package sdl
        sdl2))

(define aloysius-packages
  (list firefox
        font-hack ;;|--> gnu packages fonts
        font-jetbrains-mono
        font-fira-code
        font-iosevka-aile
        font-google-noto
        font-google-noto-emoji
        font-google-noto-sans-cjk
        brightnessctl
        zip
        unzip))

(define aloysius-home
  (home-environment
   (packages (append
              aloysius-packages
              guile-packages))
   
   (services
    (append
     (list
      ;; Primary Bash configuration
      (service
       home-bash-service-type
       (home-bash-configuration
        (guix-defaults? #f)
        (aliases
         '(("grep" . "grep --color=auto")
           ("la" . "ls -al")
           ("ll" . "ls -l")
           ("ls" . "ls -p --color=auto")))
        (bashrc (list (local-file "dot-bashrc.sh" #:recursive? #t)))
        (bash-profile (list (local-file "dot-bash_profile.sh" #:recursive? #t))))))))))

aloysius-home
