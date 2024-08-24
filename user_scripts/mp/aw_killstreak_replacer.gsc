#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
  setDvarIfUninitialized("aw_replace_streaks", 1);
  enabled = getDvarInt("aw_replace_streaks") == 1;
  if (!enabled) return;

  setDvarIfUninitialized("aw_replacements_welcome_message", "Due to issues with this map, some streaks may be replaced.");
  level.awReplacementsMessage = getDvar("aw_replacements_welcome_message");

  setDvarIfUninitialized("aw_replacements_welcome_message_time", 5);
  level.awReplacementsMessageTime = getDvarInt("aw_replacements_welcome_message_time");

  setDvarIfUninitialized("aw_replacements_welcome_message_y_offset", -75);
  level.awReplacementsMessageYOffset = getDvarInt("aw_replacements_welcome_message_y_offset");

  setDvarIfUninitialized("aw_replacements_message_glow_r", 1.0);
  setDvarIfUninitialized("aw_replacements_message_glow_g", 0.0);
  setDvarIfUninitialized("aw_replacements_message_glow_b", 0.0);
  level.awReplacementsMessageGlowRGB = spawnStruct();
  level.awReplacementsMessageGlowRGB.R = getDvarFloat("aw_replacements_message_glow_r");
  level.awReplacementsMessageGlowRGB.G = getDvarFloat("aw_replacements_message_glow_g");
  level.awReplacementsMessageGlowRGB.B = getDvarFloat("aw_replacements_message_glow_b");

  setDvarIfUninitialized("aw_replacements_streak_message_time", 3);
  level.awReplacementsStreakMessageTime = getDvarInt("aw_replacements_streak_message_time");

  setDvarIfUninitialized("aw_replacements_streak_message_y_offset", -100);
  level.awReplacementsStreakMessageYOffset = getDvarInt("aw_replacements_streak_message_y_offset");

  setDvarIfUninitialized("aw_replacements",
    "mp_clowntown3;chopper_gunner_mp;stealth_airstrike_mp "+
    "mp_clowntown3;ac130_mp;stealth_airstrike_mp "+
    "mp_blackbox;helicopter_mp;airstrike_mp "+
    "mp_blackbox;harrier_airstrike_mp;airstrike_mp "+
    "mp_blackbox;pavelow_mp;airstrike_mp "+
    "mp_blackbox;chopper_gunner_mp;ac130_mp "+ // chopper gunner lasts forever but ac130 works fine
    "mp_fracture;chopper_gunner_mp;stealth_airstrike_mp "+
    "mp_fracture;ac130_mp;stealth_airstrike_mp "+
    "mp_highrise2;helicopter_mp;airstrike_mp "+
    "mp_highrise2;harrier_airstrike_mp;airstrike_mp "+
    "mp_highrise2;pavelow_mp;airstrike_mp "+
    "mp_highrise2;chopper_gunner_mp;stealth_airstrike_mp "+
    "mp_highrise2;ac130_mp;stealth_airstrike_mp "+
    "mp_kremlin;chopper_gunner_mp;stealth_airstrike_mp "+
    "mp_kremlin;ac130_mp;stealth_airstrike_mp "+
    "mp_lab2;chopper_gunner_mp;stealth_airstrike_mp "+
    "mp_lab2;ac130_mp;stealth_airstrike_mp "+
    "mp_lair;helicopter_mp;airstrike_mp "+
    "mp_lair;harrier_airstrike_mp;airstrike_mp "+
    "mp_lair;pavelow_mp;airstrike_mp "+
    "mp_laser2;chopper_gunner_mp;stealth_airstrike_mp "+ // chopper gunner lasts forever
    "mp_laser2;ac130_mp;stealth_airstrike_mp "+ // needs testing as ac130 may work fine like it does on mp_blackbox
    "mp_levity;helicopter_mp;airstrike_mp "+
    "mp_levity;harrier_airstrike_mp;airstrike_mp "+
    "mp_levity;pavelow_mp;airstrike_mp "+
    "mp_recovery;helicopter_mp;airstrike_mp "+
    "mp_recovery;harrier_airstrike_mp;airstrike_mp "+
    "mp_recovery;pavelow_mp;airstrike_mp "+
    "mp_sector17;helicopter_mp;airstrike_mp "+
    "mp_sector17;harrier_airstrike_mp;airstrike_mp "+
    "mp_sector17;pavelow_mp;airstrike_mp "+
    "mp_sector17;chopper_gunner_mp;stealth_airstrike_mp "+ // chopper gunner lasts forever
    "mp_sector17;ac130_mp;stealth_airstrike_mp "+ // needs testing as ac130 may work fine like it does on mp_blackbox
    "mp_torqued;radar_mp;airdrop_marker_mp "+ // using uav on this map breaks uav on all future maps until server restart
    "mp_torqued;counter_radar_mp;airdrop_marker_mp "+ // replacing just in case it does the same as uav; but untested
    "mp_torqued;chopper_gunner_mp;stealth_airstrike_mp "+
    "mp_torqued;ac130_mp;stealth_airstrike_mp "+
    "mp_venus;chopper_gunner_mp;stealth_airstrike_mp "+
    "mp_venus;ac130_mp;stealth_airstrike_mp"
  );

  level.currentMap = getdvar("mapname");
  level.streakReplacementsOnMap = [];

  allStreaks = [
    "radar_mp",     "counter_radar_mp",     "airdrop_marker_mp",  "sentry_mp",              "predator_mp",
    "airstrike_mp", "harrier_airstrike_mp", "helicopter_mp",      "airdrop_mega_marker_mp", "stealth_airstrike_mp",
    "pavelow_mp",   "chopper_gunner_mp",    "ac130_mp",           "emp_mp",                 "nuke_mp"
  ];

  replacementsDvar = getDvar("aw_replacements");
  replacementsList = strTok(replacementsDvar, " ");

  // replace kills needed for streak
  for (i = 0; i < allStreaks.size; i++) {
    iStreak = allStreaks[i];
    streakDvar = getStreakDvar(iStreak);
    // check if needs to be replaced
    streakKills = -1;
    for (j = 0; j < replacementsList.size; j++) {
      jReplacement = strTok(replacementsList[j], ";");
      jMap = jReplacement[0];
      if (jMap != level.currentMap) continue;
      jStreak = jReplacement[1];
      if (jStreak != iStreak) continue;
      jReplacementStreak = jReplacement[2];
      streakKills = getStreakKills(jReplacementStreak);
      level.streakReplacementsOnMap[level.streakReplacementsOnMap.size] = [iStreak, jReplacementStreak];
    }
    if (streakKills == -1) streakKills = getStreakKills(iStreak);
    setDvar(streakDvar, streakKills);
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
  if (isDefined(level.streakReplacementsOnMap) && level.streakReplacementsOnMap.size > 0) {
    self thread showMessage(
      level.awReplacementsMessage,
      level.awReplacementsMessageYOffset,
      level.awReplacementsMessageTime
    );
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

getStreakKills(streak) {
  switch (streak) {
    case "radar_mp":
      return 3;
    case "counter_radar_mp":
      return 4;
    case "airdrop_marker_mp":
      return 4;
    case "sentry_mp":
      return 5;
    case "predator_mp":
      return 5;
    case "airstrike_mp":
      return 6;
    case "helicopter_mp":
      return 7;
    case "harrier_airstrike_mp":
      return 7;
    case "airdrop_mega_marker_mp":
      return 8;
    case "pavelow_mp":
      return 9;
    case "stealth_airstrike_mp":
      return 9;
    case "chopper_gunner_mp":
      return 11;
    case "ac130_mp":
      return 11;
    case "emp_mp":
      return 15;
    case "nuke_mp":
      return 25;
    default:
      return 999;
  }
}

// https://github.com/Draakoor/h2m-gscscripts/blob/main/user_scripts/mp/Watermark.gsc
showMessage(text, vOffset, toWait) {
  info = self createFontString("objective", 0.95);
  info setPoint("CENTER", "CENTER", 0, vOffset);
  info.glowalpha = .6;
  // info.glowcolor = ( 1, 0, 0 );
  info.glowcolor = (
    level.awReplacementsMessageGlowRGB.R,
    level.awReplacementsMessageGlowRGB.G,
    level.awReplacementsMessageGlowRGB.B
  );
  info setText(text);
  wait toWait;
  info destroy();
}

killstreakCheck() {
  if (!isDefined(level.streakReplacementsOnMap) || level.streakReplacementsOnMap.size == 0) {
    return;
  }
  while (1) {
    foreach (player in level.players) {
      if (isDefined(player.pers["killstreaks"]) && player.pers["killstreaks"].size > 0) {
        for (i = 0; i < player.pers["killstreaks"].size; i++) {
          streakName = player.pers["killstreaks"][i].streakName;
          for (j = 0; j < level.streakReplacementsOnMap.size; j++) {
            jStreak = level.streakReplacementsOnMap[j][0];
            if (streakName == jStreak) {
              replacement = level.streakReplacementsOnMap[j][1];
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
    level.awReplacementsStreakMessageYOffset,
    level.awReplacementsStreakMessageTime);
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
