AutoStart:
systemctl --user add-wants niri.service mako.service
systemctl --user add-wants niri.service waybar.service
systemctl --user add-wants niri.service swww.service
systemctl --user add-wants niri.service overviewlistener.service
