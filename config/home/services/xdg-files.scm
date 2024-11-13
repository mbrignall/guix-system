(define-module (home services xdg-files)
  #:use-module (ice-9 optargs)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu home services dotfiles)
  #:export (home-xdg-local-files-service-type))

;; TODO - Refactor, rename symbols accordingly!
(define %home-path "/home/aloysius/.config/")

(define (home-file dir filename)
  "Resolve local config file."
  (local-file (string-append
               %home-path
               dir "/"
               filename)
              #:recursive? #t))

(define (home-xdg-local-files-gexp-service config)
  `(;; Guix Configuration Channels
    ("guix/channels.scm"
     ,(home-file "config/system" "channels.scm"))))

    ;; Sway configuration files
    ("sway/config"
     ,(home-file "files/sway" "config"))

;;     ("sway/bin/swaybar-status.sh"
;;      ,(home-file "files/sway/bin" "swaybar-status.sh"))

;;     ("sway/bin/toggle-display.sh"
;;      ,(home-file "files/sway/bin" "toggle-display.sh"))

;;     ;; GTK configuration
;;     ("gtk-3.0/settings.ini"
;;      ,(home-file "files/gtk-3.0" "settings.ini"))))

(define home-xdg-local-files-service-type
  (service-type (name 'home-xdg-files)
                (description "Service for setting up XDG local files.")
                (extensions
                 (list (service-extension
                        home-xdg-configuration-files-service-type
                        home-xdg-local-files-gexp-service)))
                (default-value #f)))
