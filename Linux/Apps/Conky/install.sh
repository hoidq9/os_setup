#!/bin/bash
source ../../variables.sh

Apps_Conky() {
    cd $REPO_DIR

    if rpm -q conky; then

        if [ ! -d /home/$user_current/.config/autostart ]; then
            mkdir -p /home/$user_current/.config/autostart
        fi

        cp conky.desktop /home/$user_current/.config/autostart
        mkdir -p /home/$user_current/.config/conky
        cd $os_id
        
        if [ "$os_id" == "fedora" ]; then
            if loginctl show-session $(loginctl list-sessions | grep $user_current | awk '{print $1}') -p Type | grep -q "wayland"; then
                cp conky_wayland.conf ~/.config/conky/
                mv ~/.config/conky/conky_wayland.conf ~/.config/conky/conky.conf
            elif loginctl show-session $(loginctl list-sessions | grep $user_current | awk '{print $1}') -p Type | grep -q "x11"; then
                cp conky_x11.conf ~/.config/conky/
                mv ~/.config/conky/conky_x11.conf ~/.config/conky/conky.conf
            fi

        elif [ "$os_id" == "rhel" ] || [ "$os_id" == "almalinux" ]; then
            if [ ! -f $HOME/.config/conky/conky.conf ]; then
                cp -f conky.conf /home/$user_current/.config/conky/
            fi
        fi
    fi
}

check_and_run Apps_Conky "$REPO_DIR/../../logs/Apps_Conky.log" "$REPO_DIR/../../logs/Result.log"
