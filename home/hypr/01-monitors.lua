-- ============================================================================
-- Écrans
-- ----------------------------------------------------------------------------
-- Identification par description EDID (préfixe "desc:") : insensible à
-- l'ordre d'énumération des ports DP/HDMI. La description commence par le
-- fabricant ; un simple préfixe suffit tant qu'il n'y a qu'un écran par marque.
--
-- ⚠️ À VÉRIFIER au premier boot :  hyprctl monitors all
-- Si un écran ne récupère pas sa configuration (nom de fabricant différent
-- dans son EDID), remplace le préfixe ci-dessous par le début de la valeur
-- "description:" affichée par hyprctl (sans le "(DP-x)" final).
-- La règle de secours tout en bas garantit que tous les écrans s'allument
-- quoi qu'il arrive.
--
-- Disposition supposée : secondaire | PRINCIPAL | secondaire.
-- Si gauche/droite sont inversés chez toi, échange les deux blocs 1080p.
-- ============================================================================

-- ---- Principal (centre) : Gigabyte 27" 2560x1440 @ 360 Hz, OLED, HDR, DP --
-- bitdepth = 10 + cm = "auto" (large gamut en 10 bit) : bureau SDR propre,
-- bascule HDR automatique en plein écran via render.cm_auto_hdr (voir
-- home/hyprland.nix). À 360 Hz en 10 bit, le lien DP 1.4 utilise le DSC :
-- aucun souci côté GPU AMD.
-- vrr = 3 : VRR limité au plein écran "jeu/vidéo" ; évite le scintillement
-- VRR caractéristique des OLED sur le bureau.
hl.monitor({
    output              = "desc:Gigabyte Technology Co., Ltd.",
    mode                = "2560x1440@360",
    position            = "1920x0",
    scale               = 1,
    bitdepth            = 10,
    cm                  = "auto",
    vrr                 = 3,
    supports_wide_color = 1,
    supports_hdr        = 1,
})

-- ---- Secondaire gauche : iiyama 24" 1920x1080 @ 100 Hz (SDR) ---------------
-- Décalé de 180 px vers le bas pour aligner les centres : (1440 - 1080) / 2.
hl.monitor({
    output   = "desc:Iiyama",
    mode     = "1920x1080@100",
    position = "0x180",
    scale    = 1,
    vrr      = 3, -- mettre 0 si l'écran scintille
})

-- ---- Secondaire droit : CHiQ 1920x1080 @ 100 Hz (SDR) -----------------------
hl.monitor({
    output   = "desc:CHiQ",
    mode     = "1920x1080@100",
    position = "4480x180", -- 1920 (gauche) + 2560 (principal)
    scale    = 1,
    vrr      = 3,
})

-- ---- Secours : tout écran non identifié -------------------------------------
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto-right",
    scale    = 1,
})
