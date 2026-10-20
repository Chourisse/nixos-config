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
-- Disposition :
--
--   ┌──────────────┬────────────────────┐
--   │ 1080p (haut) │                    │
--   │   0x0        │  1440p @ 360 Hz    │
--   ├──────────────┤  HDR — PRINCIPAL   │
--   │ 1080p (bas)  │   1920x0           │
--   │   0x1080     ├────────────────────┘
--   │              │
--   └──────────────┘
--
-- Les bords supérieurs sont alignés (y = 0). Alternatives pour le principal,
-- selon la hauteur physique de ton installation — change juste son "position" :
--   "1920x-180" : centre du principal aligné sur le centre de l'écran du haut
--   "1920x360"  : principal centré par rapport aux deux écrans empilés
--
-- ⚠️ Attribution des marques supposée : CHiQ en haut, Iiyama en bas.
-- Si c'est l'inverse chez toi, échange uniquement les deux valeurs "desc:"
-- des blocs 1080p ci-dessous (les positions, elles, ne changent pas).
-- ============================================================================

-- ---- Principal : Gigabyte 27" 2560x1440 @ 360 Hz, OLED, HDR, DP ------------
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

-- ---- Secondaire haut-gauche : CHiQ 1920x1080 @ 100 Hz (SDR, DP) -------------
hl.monitor({
    output   = "desc:CHiQ",
    mode     = "1920x1080@100",
    position = "0x0",
    scale    = 1,
    vrr      = 3, -- mettre 0 si l'écran scintille
})

-- ---- Secondaire bas-gauche : Iiyama 1920x1080 @ 100 Hz (SDR, HDMI) ----------
-- Juste sous l'écran du haut (y = 1080). Il descendra donc plus bas que le
-- principal (2160 > 1440) : c'est normal, le coin bas-droite de cet écran
-- n'a simplement pas de voisin à droite.
hl.monitor({
    output   = "desc:Iiyama",
    mode     = "1920x1080@100",
    position = "0x1080",
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
