#!/usr/bin/env python

import os
import re
import sys
import zlib

# makes script work on windows 10 (apparently)
os.system("")

HOME_DIR = os.getenv("HOME")
BALATRO_DIR = f"{HOME_DIR}/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/"

JOKER_SLUGS = {
    "j_joker": "Joker",
    "j_greedy_joker": "Greedy Joker",
    "j_lusty_joker": "Lusty Joker",
    "j_wrathful_joker": "Wrathful Joker",
    "j_gluttenous_joker": "Gluttonous Joker",
    "j_jolly": "Jolly Joker",
    "j_zany": "Zany Joker",
    "j_mad": "Mad Joker",
    "j_crazy": "Crazy Joker",
    "j_droll": "Droll Joker",
    "j_sly": "Sly Joker",
    "j_wily": "Wily Joker",
    "j_clever": "Clever Joker",
    "j_devious": "Devious Joker",
    "j_crafty": "Crafty Joker",
    "j_half": "Half Joker",
    "j_stencil": "Joker Stencil",
    "j_four_fingers": "Four Fingers",
    "j_mime": "Mime",
    "j_credit_card": "Credit Card",
    "j_ceremonial": "Ceremonial Dagger",
    "j_banner": "Banner",
    "j_mystic_summit": "Mystic Summit",
    "j_marble": "Marble Joker",
    "j_loyalty_card": "Loyalty Card",
    "j_8_ball": "8 Ball",
    "j_misprint": "Misprint",
    "j_dusk": "Dusk",
    "j_raised_fist": "Raised Fist",
    "j_chaos": "Chaos the Clown",
    "j_fibonacci": "Fibonacci",
    "j_steel_joker": "Steel Joker",
    "j_scary_face": "Scary Face",
    "j_abstract": "Abstract Joker",
    "j_delayed_grat": "Delayed Gratification",
    "j_hack": "Hack",
    "j_pareidolia": "Pareidolia",
    "j_gros_michel": "Gros Michel",
    "j_even_steven": "Even Steven",
    "j_odd_todd": "Odd Todd",
    "j_scholar": "Scholar",
    "j_business": "Business Card",
    "j_supernova": "Supernova",
    "j_ride_the_bus": "Ride the Bus",
    "j_space": "Space Joker",
    "j_egg": "Egg",
    "j_burglar": "Burglar",
    "j_blackboard": "Blackboard",
    "j_runner": "Runner",
    "j_ice_cream": "Ice Cream",
    "j_dna": "DNA",
    "j_splash": "Splash",
    "j_blue_joker": "Blue Joker",
    "j_sixth_sense": "Sixth Sense",
    "j_constellation": "Constellation",
    "j_hiker": "Hiker",
    "j_faceless": "Faceless Joker",
    "j_green_joker": "Green Joker",
    "j_superposition": "Superposition",
    "j_todo_list": "To Do List",
    "j_cavendish": "Cavendish",
    "j_card_sharp": "Card Sharp",
    "j_red_card": "Red Card",
    "j_madness": "Madness",
    "j_square": "Square Joker",
    "j_seance": "Séance",
    "j_riff_raff": "Riff-Raff",
    "j_vampire": "Vampire",
    "j_shortcut": "Shortcut",
    "j_hologram": "Hologram",
    "j_vagabond": "Vagabond",
    "j_baron": "Baron",
    "j_cloud_9": "Cloud 9",
    "j_rocket": "Rocket",
    "j_obelisk": "Obelisk",
    "j_midas_mask": "Midas Mask",
    "j_luchador": "Luchador",
    "j_photograph": "Photograph",
    "j_gift": "Gift Card",
    "j_turtle_bean": "Turtle Bean",
    "j_erosion": "Erosion",
    "j_reserved_parking": "Reserved Parking",
    "j_mail": "Mail-In Rebate",
    "j_to_the_moon": "To the Moon",
    "j_hallucination": "Hallucination",
    "j_fortune_teller": "Fortune Teller",
    "j_juggler": "Juggler",
    "j_drunkard": "Drunkard",
    "j_stone": "Stone Joker",
    "j_golden": "Golden Joker",
    "j_lucky_cat": "Lucky Cat",
    "j_baseball": "Baseball Card",
    "j_bull": "Bull",
    "j_diet_cola": "Diet Cola",
    "j_trading": "Trading Card",
    "j_flash": "Flash Card",
    "j_popcorn": "Popcorn",
    "j_trousers": "Spare Trousers",
    "j_ancient": "Ancient Joker",
    "j_ramen": "Ramen",
    "j_walkie_talkie": "Walkie Talkie",
    "j_selzer": "Seltzer",
    "j_castle": "Castle",
    "j_smiley": "Smiley Face",
    "j_campfire": "Campfire",
    "j_ticket": "Golden Ticket",
    "j_mr_bones": "Mr. Bones",
    "j_acrobat": "Acrobat",
    "j_sock_and_buskin": "Sock and Buskin",
    "j_swashbuckler": "Swashbuckler",
    "j_troubadour": "Troubadour",
    "j_certificate": "Certificate",
    "j_smeared": "Smeared Joker",
    "j_throwback": "Throwback",
    "j_hanging_chad": "Hanging Chad",
    "j_rough_gem": "Rough Gem",
    "j_bloodstone": "Bloodstone",
    "j_arrowhead": "Arrowhead",
    "j_onyx_agate": "Onyx Agate",
    "j_glass": "Glass Joker",
    "j_ring_master": "Showman",
    "j_flower_pot": "Flower Pot",
    "j_blueprint": "Blueprint",
    "j_wee": "Wee Joker",
    "j_merry_andy": "Merry Andy",
    "j_oops": "Oops! All 6s",
    "j_idol": "The Idol",
    "j_seeing_double": "Seeing Double",
    "j_matador": "Matador",
    "j_hit_the_road": "Hit the Road",
    "j_duo": "The Duo",
    "j_trio": "The Trio",
    "j_family": "The Family",
    "j_order": "The Order",
    "j_tribe": "The Tribe",
    "j_stuntman": "Stuntman",
    "j_invisible": "Invisible Joker",
    "j_brainstorm": "Brainstorm",
    "j_satellite": "Satellite",
    "j_shoot_the_moon": "Shoot the Moon",
    "j_drivers_license": "Driver's License",
    "j_cartomancer": "Cartomancer",
    "j_astronomer": "Astronomer",
    "j_burnt": "Burnt Joker",
    "j_bootstraps": "Bootstraps",
    "j_caino": "Canio",
    "j_triboulet": "Triboulet",
    "j_yorick": "Yorick",
    "j_chicot": "Chicot",
    "j_perkeo": "Perkeo",
}


def fg(colour):
    return "\33[38;5;" + str(colour) + "m"


CBLACK = fg(0)
CRED = fg(1)
CGREEN = fg(2)
CYELLOW = fg(3)
CBLUE = fg(4)
CVIOLET = fg(5)
CCYAN = fg(6)
CWHITE = fg(7)
CGREY = fg(8)
CRED2 = fg(9)
CGREEN2 = fg(10)
CYELLOW2 = fg(11)
CBLUE2 = fg(12)
CVIOLET2 = fg(13)
CCYAN2 = fg(14)
CWHITE2 = fg(15)

CBLACK232 = fg(232)
CORANGE = fg(172)

STAKE_COLOURS = {
    "1": CWHITE,  # white
    "2": CRED,  # red
    "3": CGREEN,  # green
    "4": CBLACK232,  # black
    "5": CBLUE,  # blue
    "6": CVIOLET,  # purple
    "7": CORANGE,  # orange
    "8": CYELLOW2,  # gold
}

COLOUR_NONE = CGREY  # no sticker
COLOUR_END = "\033[0m"

input_file = os.path.join(BALATRO_DIR, "1", "profile.jkr")

with open(input_file, "rb") as f:
    input_data = zlib.decompress(f.read(), wbits=-15)

JOKER_EXTRACT_REGEX = r"\[\"j_\w+\"\].*?}"
JOKER_SLUG_REGEX = r"j_\w+"
STAKE_REGEX = r"\[(\d)\]"

for slug, name in JOKER_SLUGS.items():
    JOKER_EXTRACT_REGEX = r"\[\"" + slug + r"\"\].*?}"
    match = re.search(JOKER_EXTRACT_REGEX, str(input_data))

    if not match:
        if len(sys.argv) == 1 or sys.argv[1] == "0":
            print(f"{COLOUR_NONE}{name}{COLOUR_END}")
        continue

    jkr = match.group(0)

    stakes = re.findall(STAKE_REGEX, jkr)
    if not stakes:
        if len(sys.argv) == 1 or sys.argv[1] == "0":
            print(f"{COLOUR_NONE}{name}{COLOUR_END}")
        continue
    stake_no = max(stakes)

    if len(sys.argv) > 1 and sys.argv[1] != stake_no:
        continue

    colour = STAKE_COLOURS[stake_no]

    print(f"{colour}{name}{COLOUR_END}")
