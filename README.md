## AutoStart Services

To enable auto-start for the necessary services, run the following commands:

```bash
# Make these services start automatically with Niri
systemctl --user add-wants niri.service mako.service
systemctl --user add-wants niri.service waybar.service
systemctl --user add-wants niri.service swww.service
systemctl --user add-wants niri.service overviewlistener.service
