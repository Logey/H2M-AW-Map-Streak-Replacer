#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

replaceHarrier = [
    "mp_blackbox",
    "mp_highrise2",
    "mp_lair",
    "mp_levity",
    "mp_recovery",
    "mp_sector17"
  ];
replaceChopper = [
    "mp_clowntown3",
    "mp_fracture",
    "mp_highrise2",
    "mp_kremlin",
    "mp_lab2",
    "mp_torqued",
    "mp_venus",
    "mp_sector17" // chopper gunner never ends; lasts forever
  ];

// killstreak kills dvars: https://discord.com/channels/1272500523010097202/1274686157891829815/1274690509805457409
init() {
  level.shouldReplaceHarrier = false;
  level.shouldReplaceChopper = false;

  currentMap = getdvar("mapname");
  foreach (map in replaceHarrier) {
    if (currentMap == map) {
      level.shouldReplaceHarrier = true;
      setDvar("scr_killstreak_kills_harrier", 6);
      setDvar("scr_killstreak_kills_heli", 6);
      break;
    }
  }
  if (!level.shouldReplaceHarrier) {
    setDvar("scr_killstreak_kills_harrier", 7);
    setDvar("scr_killstreak_kills_heli", 7);
  }
  foreach (map in replaceChopper) {
    if (currentMap == map) {
      level.shouldReplaceChopper = true;
      setDvar("scr_killstreak_kills_chopper", 9);
      setDvar("scr_killstreak_kills_ac130", 9);
      break;
    }
  }
  if (!level.shouldReplaceChopper) {
    setDvar("scr_killstreak_kills_chopper", 11);
    setDvar("scr_killstreak_kills_ac130", 11);
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

  if (level.shouldReplaceHarrier || level.shouldReplaceChopper) {
    self thread showMessage("Due to issues with this map, some streaks may be replaced.", -75, 10);
  }
}

showMessage(text, vOffset, toWait) { // https://github.com/Draakoor/h2m-gscscripts/blob/main/user_scripts/mp/Watermark.gsc
  info = self createFontString("objective", 0.95);
  info setPoint("CENTER", "CENTER", 0, vOffset);
  info.glowalpha = .6;
  info.glowcolor = ( 1, 0, 0 );
  info setText(text);
  wait toWait;
  info destroy();
}

killstreakCheck() {
  if (!level.shouldReplaceHarrier && !level.shouldReplaceChopper) {
    return;
  }
  while (1) {
    foreach (player in level.players) {
      if (isDefined(player.pers["killstreaks"]) && player.pers["killstreaks"].size > 0) {
        for (i = 0; i < player.pers["killstreaks"].size; i++) {
          streakName = player.pers["killstreaks"][i].streakName;
          switch (streakName) {
            case "helicopter_mp":
              if (level.shouldReplaceHarrier) player replaceKillstreak(i, "airstrike_mp");
              break;
            case "harrier_airstrike_mp":
              if (level.shouldReplaceHarrier) player replaceKillstreak(i, "airstrike_mp");
              break;
            case "pavelow_mp":
              if (level.shouldReplaceHarrier) player replaceKillstreak(i, "stealth_airstrike_mp");
              break;
            case "chopper_gunner_mp":
              if (level.shouldReplaceChopper) player replaceKillstreak(i, "stealth_airstrike_mp");
              break;
            case "ac130_mp":
              if (level.shouldReplaceChopper) player replaceKillstreak(i, "stealth_airstrike_mp");
              break;
            default:
              break;
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
  self showMessage(
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
