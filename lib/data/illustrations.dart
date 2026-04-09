/// Paths to all illustration assets
class Illustrations {
  static const _base = 'assets/images/illustrations';

  // App
  static const appIcon = '$_base/app_icon.png';
  static const logoHero = '$_base/logo_hero.png';

  // Themes
  static const themeCustom = '$_base/theme_custom.png';
  static const themePirate = '$_base/theme_pirate.png';
  static const themeSpace = '$_base/theme_space.png';
  static const themeJungle = '$_base/theme_jungle.png';
  static const themeBirthday = '$_base/theme_birthday.png';
  static const themeHalloween = '$_base/theme_halloween.png';
  static const themeChristmas = '$_base/theme_christmas.png';
  static const themeOutdoor = '$_base/theme_outdoor.png';

  // Gameplay
  static const howToPlay = '$_base/gameplay_how_to_play.png';
  static const clueCard = '$_base/gameplay_clue_card.png';
  static const foundIt = '$_base/gameplay_found_it.png';
  static const answerVerify = '$_base/gameplay_answer_verify.png';
  static const hint = '$_base/gameplay_hint.png';
  static const voiceClue = '$_base/gameplay_voice_clue.png';
  static const photoVerify = '$_base/gameplay_photo_verify.png';

  // Victory
  static const victoryBanner = '$_base/victory_banner.png';
  static const victoryTrophy = '$_base/victory_trophy.png';
  static const badgeLightning = '$_base/victory_badge_lightning.png';
  static const badgeBlazing = '$_base/victory_badge_blazing.png';
  static const badgeSpeedy = '$_base/victory_badge_speedy.png';
  static const badgeSteady = '$_base/victory_badge_steady.png';
  static const badgeThorough = '$_base/victory_badge_thorough.png';

  // Progression
  static const badgeRookie = '$_base/badge_rookie.png';
  static const badgeBronze = '$_base/badge_bronze.png';
  static const badgeSilver = '$_base/badge_silver.png';
  static const badgeGold = '$_base/badge_gold.png';
  static const badgeMaster = '$_base/badge_master.png';

  // Empty states
  static const emptyNoHunts = '$_base/empty_no_hunts.png';
  static const emptyNoTrophies = '$_base/empty_no_trophies.png';
  static const emptyChest = '$_base/empty_chest.png';
  static const emptyNoClues = '$_base/empty_no_clues.png';
  static const emptyQuickPlay = '$_base/empty_quick_play.png';

  // Sharing & join
  static const joinIllustration = '$_base/join_illustration.png';
  static const qrFrame = '$_base/ui_qr_frame.png';
  static const shareCodeScroll = '$_base/ui_share_code_scroll.png';

  // UI icons
  static const iconChest = '$_base/icon_chest.png';
  static const iconCompass = '$_base/icon_compass.png';
  static const iconScroll = '$_base/icon_scroll.png';
  static const iconMegaphone = '$_base/icon_megaphone.png';
  static const iconHourglass = '$_base/icon_hourglass.png';
  static const iconKey = '$_base/icon_key.png';
  static const iconQuill = '$_base/icon_quill.png';
  static const iconSwords = '$_base/icon_swords.png';
  static const iconCampfire = '$_base/icon_campfire.png';
  static const iconSpyglass = '$_base/icon_spyglass.png';
  static const iconMap = '$_base/icon_map.png';
  static const iconTrophy = '$_base/icon_trophy.png';
  static const iconStar = '$_base/icon_star.png';
  static const iconHome = '$_base/icon_home.png';

  // Textures
  static const parchmentBg = '$_base/parchment_background.png';
  static const woodPlank = '$_base/wood_plank_texture.png';
  static const trophyCabinetBg = '$_base/trophy_cabinet_bg.png';

  /// Get theme illustration path by theme type
  static String themeImage(String themeName) {
    switch (themeName) {
      case 'Custom Hunt': return themeCustom;
      case 'Pirate Treasure': return themePirate;
      case 'Space Mission': return themeSpace;
      case 'Jungle Explorer': return themeJungle;
      case 'Birthday Party': return themeBirthday;
      case 'Halloween Spooky': return themeHalloween;
      case 'Christmas Magic': return themeChristmas;
      case 'Outdoor Adventure': return themeOutdoor;
      default: return themeCustom;
    }
  }

  /// Get speed badge by seconds per clue
  static String speedBadge(double secsPerClue) {
    if (secsPerClue < 15) return badgeLightning;
    if (secsPerClue < 30) return badgeBlazing;
    if (secsPerClue < 60) return badgeSpeedy;
    if (secsPerClue < 120) return badgeSteady;
    return badgeThorough;
  }

  /// Get progression badge by hunt count
  static String progressionBadge(int huntCount) {
    if (huntCount >= 25) return badgeMaster;
    if (huntCount >= 10) return badgeGold;
    if (huntCount >= 5) return badgeSilver;
    if (huntCount >= 1) return badgeBronze;
    return badgeRookie;
  }
}
