removeAllWeapons player;
removeAllItems player;
removeAllAssignedItems player;
removeUniform player;
removeVest player;
removeBackpack player;
removeHeadgear player;
removeGoggles player;
player forceAddUniform "U_B_CTRG_Soldier_F";
player addItemToUniform "ACE_Flashlight_XL50";
player addItemToUniform "ACE_EarPlugs";
player addItemToUniform "9Rnd_45ACP_Mag";
player addVest "V_PlateCarrier2_rgr";
for "_i" from 1 to 10 do {player addItemToVest "UK3CB_BAF_9_30Rnd";};
for "_i" from 1 to 2 do {player addItemToVest "HandGrenade";};
player addBackpack "B_ViperHarness_oli_F";
for "_i" from 1 to 50 do {player addItemToBackpack "ACE_fieldDressing";};
for "_i" from 1 to 10 do {player addItemToBackpack "ACE_epinephrine";};
for "_i" from 1 to 10 do {player addItemToBackpack "ACE_morphine";};
for "_i" from 1 to 6 do {player addItemToBackpack "ACE_salineIV_500";};
for "_i" from 1 to 4 do {player addItemToBackpack "ACE_salineIV";};
for "_i" from 1 to 2 do {player addItemToBackpack "ACE_salineIV_250";};
for "_i" from 1 to 5 do {player addItemToBackpack "UK3CB_BAF_9_30Rnd";};
player addHeadgear "H_HelmetB_TI_tna_F";
player addGoggles "G_Balaclava_oli";
player addWeapon "UK3CB_BAF_L92A1";
player addPrimaryWeaponItem "optic_ACO_grn_smg";
player addWeapon "hgun_ACPC2_F";
player addWeapon "Rangefinder";
player linkItem "ItemMap";
player linkItem "ItemCompass";
player linkItem "ItemWatch";
player linkItem "TFAR_anprc152";
player linkItem "ItemGPS";
player setSpeaker "ace_novoice";
