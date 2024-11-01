# Add ~/.guix-profile if it exists
if [ -L ~/.guix-profile ]; then
    GUIX_PROFILE="/home/aloysius/.guix-profile"
    . "$GUIX_PROFILE/etc/profile"
fi

# StumpWM - Set title bar of GTK applications
export GTK_THEME=Adwaita:dark
