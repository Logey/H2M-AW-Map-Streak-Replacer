#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
  if (!isDefined("aw_replace_streaks")) setDvarIfUninitialized("aw_replace_streaks", 1);
  enabled = getDvarInt("aw_replace_streaks") == 1;
  if (!enabled) return;

  level.streakReplacements = spawnStruct();

  // WHAT SHOULD STREAKS BE REPLACED WITH?
  level.streakReplacements.replacement = [];
  level.streakReplacements.replacement["radar_mp"]              = "airdrop_marker_mp";
  level.streakReplacements.replacement["counter_radar_mp"]      = "airdrop_marker_mp";
  level.streakReplacements.replacement["airdrop_marker_mp"]     = "airdrop_marker_mp";    // * does not get replaced
  level.streakReplacements.replacement["sentry_mp"]             = "sentry_mp";            // * does not get replaced
  level.streakReplacements.replacement["predator_mp"]           = "predator_mp";          // * does not get replaced
  level.streakReplacements.replacement["airstrike_mp"]          = "airstrike_mp";         // * does not get replaced
  level.streakReplacements.replacement["helicopter_mp"]         = "airstrike_mp";
  level.streakReplacements.replacement["harrier_airstrike_mp"]  = "airstrike_mp";
  level.streakReplacements.replacement["pavelow_mp"]            = "stealth_airstrike_mp";
  level.streakReplacements.replacement["stealth_airstrike_mp"]  = "stealth_airstrike_mp"; // * does not get replaced
  level.streakReplacements.replacement["chopper_gunner_mp"]     = "stealth_airstrike_mp";
  level.streakReplacements.replacement["ac130_mp"]              = "stealth_airstrike_mp";
  level.streakReplacements.replacement["emp_mp"]                = "emp_mp";               // * does not get replaced
  level.streakReplacements.replacement["nuke_mp"]               = "nuke_mp";              // * does not get replaced

  // HOW MANY KILLS SHOULD THE STREAK BE IF REPLACED?
  level.streakReplacements.replacementKills = [];
  level.streakReplacements.replacementKills["radar_mp"]             =  4;
  level.streakReplacements.replacementKills["counter_radar_mp"]     =  4;
  level.streakReplacements.replacementKills["airdrop_marker_mp"]    =  4; // * does not get replaced
  level.streakReplacements.replacementKills["sentry_mp"]            =  5; // * does not get replaced
  level.streakReplacements.replacementKills["predator_mp"]          =  5; // * does not get replaced
  level.streakReplacements.replacementKills["airstrike_mp"]         =  6; // * does not get replaced
  level.streakReplacements.replacementKills["helicopter_mp"]        =  6;
  level.streakReplacements.replacementKills["harrier_airstrike_mp"] =  6;
  level.streakReplacements.replacementKills["pavelow_mp"]           =  9;
  level.streakReplacements.replacementKills["stealth_airstrike_mp"] =  9; // * does not get replaced
  level.streakReplacements.replacementKills["chopper_gunner_mp"]    =  9;
  level.streakReplacements.replacementKills["ac130_mp"]             =  9;
  level.streakReplacements.replacementKills["emp_mp"]               = 15; // * does not get replaced
  level.streakReplacements.replacementKills["nuke_mp"]              = 25; // * does not get replaced

  // HOW MANY KILLS SHOULD THE STREAK BE IF NOT REPLACED?
  level.streakReplacements.replacementKillsDefault = [];
  level.streakReplacements.replacementKillsDefault["radar_mp"]                =  3;
  level.streakReplacements.replacementKillsDefault["counter_radar_mp"]        =  4;
  level.streakReplacements.replacementKillsDefault["airdrop_marker_mp"]       =  4; // * does not get replaced
  level.streakReplacements.replacementKillsDefault["sentry_mp"]               =  5; // * does not get replaced
  level.streakReplacements.replacementKillsDefault["predator_mp"]             =  5; // * does not get replaced
  level.streakReplacements.replacementKillsDefault["airstrike_mp"]            =  6; // * does not get replaced
  level.streakReplacements.replacementKillsDefault["helicopter_mp"]           =  7;
  level.streakReplacements.replacementKillsDefault["harrier_airstrike_mp"]    =  7;
  level.streakReplacements.replacementKillsDefault["airdrop_mega_marker_mp"]  =  8; // * does not get replaced
  level.streakReplacements.replacementKillsDefault["pavelow_mp"]              =  9;
  level.streakReplacements.replacementKillsDefault["stealth_airstrike_mp"]    =  9; // * does not get replaced
  level.streakReplacements.replacementKillsDefault["chopper_gunner_mp"]       = 11;
  level.streakReplacements.replacementKillsDefault["ac130_mp"]                = 11;
  level.streakReplacements.replacementKillsDefault["emp_mp"]                  = 15; // * does not get replaced
  level.streakReplacements.replacementKillsDefault["nuke_mp"]                 = 25; // * does not get replaced

  // WHAT MAPS SHOULD STREAKS BE REPLACED ON?
  level.streakReplacements.replaceOnMap = [];
  level.streakReplacements.replaceOnMap["mp_clowntown3"]  = ["chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_blackbox"]    = ["helicopter_mp", "harrier_airstrike_mp", "pavelow_mp"];
  level.streakReplacements.replaceOnMap["mp_fracture"]    = ["chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_highrise2"]   = ["helicopter_mp", "harrier_airstrike_mp", "pavelow_mp", "chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_kremlin"]     = ["chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_lab2"]        = ["chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_lair"]        = ["helicopter_mp", "harrier_airstrike_mp", "pavelow_mp"];
  level.streakReplacements.replaceOnMap["mp_laser2"]      = ["chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_levity"]      = ["helicopter_mp", "harrier_airstrike_mp", "pavelow_mp"];
  level.streakReplacements.replaceOnMap["mp_recovery"]    = ["helicopter_mp", "harrier_airstrike_mp", "pavelow_mp"];
  level.streakReplacements.replaceOnMap["mp_sector17"]    = ["helicopter_mp", "harrier_airstrike_mp", "pavelow_mp", "chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_torqued"]     = ["radar_mp", "counter_radar_mp", "chopper_gunner_mp", "ac130_mp"];
  level.streakReplacements.replaceOnMap["mp_venus"]       = ["chopper_gunner_mp", "ac130_mp"];



  level.allStreaks = [
    "radar_mp",     "counter_radar_mp",     "airdrop_marker_mp",  "sentry_mp",              "predator_mp",
    "airstrike_mp", "harrier_airstrike_mp", "helicopter_mp",      "airdrop_mega_marker_mp", "stealth_airstrike_mp",
    "pavelow_mp",   "chopper_gunner_mp",    "ac130_mp",           "emp_mp",                 "nuke_mp"
  ];

  level.currentMap = getdvar("mapname");

  // set streaks to default or replacement kills
  for (i = 0; i < level.allStreaks.size; i++) {
    iStreak = level.allStreaks[i];
    streakDvar = getStreakDvar(iStreak);
    // check if needs to be replaced
    streakKillsReplaced = false;
    if (isDefined(level.streakReplacements.replaceOnMap[level.currentMap])) {
      for (j = 0; j < level.streakReplacements.replaceOnMap[level.currentMap].size; j++) {
        jStreak = level.streakReplacements.replaceOnMap[level.currentMap][j];
        if (iStreak == jStreak) {
          streakKills = level.streakReplacements.replacementKills[jStreak];
          setDvar(streakDvar, streakKills);
          streakKillsReplaced = true;
          break;
        }
      }
    }
    if (!streakKillsReplaced) {
      streakKills = level.streakReplacements.replacementKillsDefault[iStreak];
      setDvar(streakDvar, streakKills);
    }
  }

  level thread onPlayerConnect();
  level thread killstreakCheck();
}

onPlayerConnect() {
  for (;;) {
    level waittill("connected", player);
    player thread checkMap();
  }
}

checkMap() {
  self waittill("spawned_player");
  if (isDefined(level.streakReplacements.replaceOnMap[level.currentMap]) && level.streakReplacements.replaceOnMap[level.currentMap].size > 0) {
    self thread showMessage("Due to issues with this map, some streaks may be replaced.", -75, 5);
  }
}

// killstreak kills dvars: https://discord.com/channels/1272500523010097202/1274686157891829815/1274690509805457409
getStreakDvar(streak) {
  switch (streak) {
    case "radar_mp":
      return "scr_killstreak_kills_uav";
    case "counter_radar_mp":
      return "scr_killstreak_kills_counter_uav";
    case "airdrop_marker_mp":
      return "scr_killstreak_kills_airdrop";
    case "sentry_mp":
      return "scr_killstreak_kills_sentry";
    case "predator_mp":
      return "scr_killstreak_kills_predator";
    case "airstrike_mp":
      return "scr_killstreak_kills_precision_airstrike";
    case "harrier_airstrike_mp":
      return "scr_killstreak_kills_harrier";
    case "helicopter_mp":
      return "scr_killstreak_kills_heli";
    case "airdrop_mega_marker_mp":
      return "scr_killstreak_kills_airdrop_mega";
    case "stealth_airstrike_mp":
      return "scr_killstreak_kills_stealth";
    case "pavelow_mp":
      return "scr_killstreak_kills_pavelow";
    case "chopper_gunner_mp":
      return "scr_killstreak_kills_chopper";
    case "ac130_mp":
      return "scr_killstreak_kills_ac130";
    case "emp_mp":
      return "scr_killstreak_kills_emp";
    case "nuke_mp":
      return "scr_killstreak_kills_nuke";
    default:
      return "";
  }
}

// https://github.com/Draakoor/h2m-gscscripts/blob/main/user_scripts/mp/Watermark.gsc
showMessage(text, vOffset, toWait) {
  info = self createFontString("objective", 0.95);
  info setPoint("CENTER", "CENTER", 0, vOffset);
  info.glowalpha = .6;
  info.glowcolor = ( 1, 0, 0 );
  info setText(text);
  wait toWait;
  info destroy();
}

killstreakCheck() {
  if (!isDefined(level.streakReplacements.replaceOnMap[level.currentMap]) || level.streakReplacements.replaceOnMap[level.currentMap].size < 1) {
    return;
  }
  while (1) {
    foreach (player in level.players) {
      if (isDefined(player.pers["killstreaks"]) && player.pers["killstreaks"].size > 0) {
        for (i = 0; i < player.pers["killstreaks"].size; i++) {
          streakName = player.pers["killstreaks"][i].streakName;
          for (j = 0; j < level.streakReplacements.replaceOnMap[level.currentMap].size; j++) {
            thisStreak = level.streakReplacements.replaceOnMap[level.currentMap][j];
            if (streakName == thisStreak) {
              replacement = level.streakReplacements.replacement[thisStreak];
              player replaceKillstreak(i, replacement);
              break;
            }
          }
        }
      }
    }
    wait 0.2;
  }
}

streakToDisplayName(streak) {
  // full list of streaks: https://github.com/Draakoor/h2m-gscscripts/blob/main/user_scripts/mp/RestrictKillStreakH2.gsc#L9
  switch (streak) {
    case "radar_mp":
      return "UAV";
    case "counter_radar_mp":
      return "Counter-UAV";
    case "airdrop_marker_mp":
      return "Care Package";
    case "sentry_mp":
      return "Sentry Gun";
    case "predator_mp":
      return "Predator Missile";
    case "airstrike_mp":
      return "Airstrike";
    case "harrier_airstrike_mp":
      return "Harrier Strike";
    case "helicopter_mp":
      return "Helicopter";
    case "airdrop_mega_marker_mp":
      return "Emergency Airdrop";
    case "stealth_airstrike_mp":
      return "Stealth Bomber";
    case "pavelow_mp":
      return "Pavelow";
    case "chopper_gunner_mp":
      return "Chopper Gunner";
    case "ac130_mp":
      return "AC-130";
    case "emp_mp":
      return "EMP";
    case "nuke_mp":
      return "Tactical Nuke";
    default:
      return "Unknown Killstreak";
  }
}

// killstreak replacement: https://github.com/Draakoor/h2m-gscscripts/blob/main/user_scripts/mp/replace_killstreaks.gsc
replaceKillstreak(el, newStreak) {
  streakName = self.pers["killstreaks"][el].streakName;
  self thread showMessage(
    "Your " + streakToDisplayName(streakName) + " has been replaced with " +
      aOrAn(streakToDisplayName(newStreak)[0]) + " " + streakToDisplayName(newStreak) +
      " due to an issue with this map.",
    -100,
    3);
  self.pers["killstreaks"][el].streakName = newStreak;
  self SetActionSlot(4, "");
  self giveweapon(newStreak);
  self givemaxammo(newStreak);
  self setactionslot(4, "weapon", newStreak);
}

aOrAn(nextChar) {
  if (
    nextChar == "a" || nextChar == "e" || nextChar == "i" || nextChar == "o" || nextChar== "u" ||
    nextChar == "A" || nextChar == "E" || nextChar == "I" || nextChar == "O" || nextChar== "U"
  ) return "an";
  return "a";
}
