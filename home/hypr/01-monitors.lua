-- ============================================================================
-- Écrans — préfixes EDID validés par `hyprctl monitors all` du 2026-10-21
-- ----------------------------------------------------------------------------
-- La règle `output = "desc:..."` teste un PRÉFIXE de la ligne `description:`
-- de `hyprctl monitors all` (sensible à la casse). Les 3 préfixes ci-dessous
-- sont maintenant les bons ; la casse/ponctuation compte.
--
-- Disposition (colonne de 2 à gauche) :
--
--   ┌──────────────┬────────────────────┐
--   │ Iiyama 1080p │                    │
--   │  DP-3  0x0    │  Gigabyte MO27Q3   │
--   ├──────────────┤  1440p @ 360 Hz    │
--   │ CHiQ 1080p    │  1920x0 — PRINCIPAL│
--   │ HDMI 0x1080  ├────────────────────┘
--   │              │
--   └──────────────┘
-- Bords supérieurs alignés (y=0). Alt pour le principal : 1920x-180 ou 1920x360.
-- ============================================================================

-- ---- Principal : Gigabyte 27" 2560x1440 @ 360 Hz, OLED, HDR, DP-2 ----------
-- Mode "KDE" : HDR permanent (cm hdredid) + curseurs SDR comme sur Plasma.
-- Plus de bascule auto : les jeux voient un écran HDR en permanence.
-- Réglages validés + luminances OLED explicites (fix "brouillard" : point
-- noir et blanc du SDR mal mappés en HDR quand ils viennent de l'EDID).
-- Ajustables librement. DP 1.4 en 10-bit/360 Hz via DSC (AMD).
-- vrr=3 : VRR seulement en plein écran jeu/vidéo (évite le scintillement OLED).
hl.monitor({
    output              = "desc:GIGA-BYTE TECHNOLOGY CO. LTD.",
    mode                = "2560x1440@360",
    position            = "1920x0",
    scale               = 1,
    bitdepth            = 10,
    cm                  = "hdredid",
    sdrbrightness       = 1.7,
    sdrsaturation       = 0.9,
    sdr_eotf            = "gamma22force",
    sdr_min_luminance   = 0.005,
    sdr_max_luminance   = 250,
    min_luminance       = 0,
    max_luminance       = 1000,
    max_avg_luminance   = 275,
    vrr                 = 3,
    supports_wide_color = 1,
    supports_hdr        = 1,
})

-- ---- Secondaire haut-gauche : Iiyama PL2245H 1080p@100 — DP-3 --------------
hl.monitor({
    output         = "desc:iiyama Corporation",
    mode           = "1920x1080@100",
    position       = "0x0",
    scale          = 1,
    sdrsaturation  = 0.8,
    vrr            = 3,
})

-- ---- Secondaire bas-gauche : ChangHong/CHiQ MNT 1080p@100 — HDMI-A-1 -------
hl.monitor({
    output         = "desc:ChangHong Electric",
    mode           = "1920x1080@100",
    position       = "0x1080",
    scale          = 1,
    sdrsaturation  = 0.8,
    vrr            = 3,
})

-- ---- Secours : tout écran non identifié -----------------------------------
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto-right",
    scale    = 1,
})
