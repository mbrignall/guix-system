;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

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
  (list font-hack ;;|--> gnu packages fonts
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
