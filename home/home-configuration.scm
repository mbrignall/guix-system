;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules (gnu home)
             (gnu home services)
             (gnu home services shells)
             (gnu home services xdg)
             (gnu services)
             (gnu packages)
             (gnu packages search)
             (gnu packages shells)
             (gnu packages shellutils)
             (gnu packages terminals)
             (guix gexp))

(home-environment
 (packages
  (specifications->packages
   (list "bash-completion")))

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
      (bash-profile (list (local-file "dot-bash_profile.sh" #:recursive? #t)))))))))
