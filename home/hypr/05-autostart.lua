-- Démarrage de session.
-- Le shell Caelestia, cliphist et l'agent polkit sont des services systemd
-- utilisateur (graphical-session.target, démarrée par UWSM) : rien à lancer ici
-- pour eux. Le trousseau GNOME Keyring est activé par D-Bus/PAM.

hl.on("hyprland.start", function()
    -- Transfère les commandes média Bluetooth (casques, etc.) vers MPRIS
    hl.exec_cmd("mpris-proxy")

    -- Purge la corbeille des éléments vieux de plus de 30 jours
    hl.exec_cmd("trash-empty 30")
end)
