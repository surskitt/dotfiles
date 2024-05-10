#!/usr/bin/env python

import argparse
import os
import sys
import zlib

import luadata

# makes script work on windows 10 (apparently)
os.system("")

HOME_DIR = os.getenv("HOME")
BALATRO_DIR = f"{HOME_DIR}/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro/"

JOKERS = {
    "j_joker": {"name": "Joker", "rarity": "common"},
    "j_greedy_joker": {"name": "Greedy Joker", "rarity": "common"},
    "j_lusty_joker": {"name": "Lusty Joker", "rarity": "common"},
    "j_wrathful_joker": {"name": "Wrathful Joker", "rarity": "common"},
    "j_gluttenous_joker": {"name": "Gluttonous Joker", "rarity": "common"},
    "j_jolly": {"name": "Jolly Joker", "rarity": "common"},
    "j_zany": {"name": "Zany Joker", "rarity": "common"},
    "j_mad": {"name": "Mad Joker", "rarity": "common"},
    "j_crazy": {"name": "Crazy Joker", "rarity": "common"},
    "j_droll": {"name": "Droll Joker", "rarity": "common"},
    "j_sly": {"name": "Sly Joker", "rarity": "common"},
    "j_wily": {"name": "Wily Joker", "rarity": "common"},
    "j_clever": {"name": "Clever Joker", "rarity": "common"},
    "j_devious": {"name": "Devious Joker", "rarity": "common"},
    "j_crafty": {"name": "Crafty Joker", "rarity": "common"},
    "j_half": {"name": "Half Joker", "rarity": "common"},
    "j_stencil": {"name": "Joker Stencil", "rarity": "uncommon"},
    "j_four_fingers": {"name": "Four Fingers", "rarity": "uncommon"},
    "j_mime": {"name": "Mime", "rarity": "uncommon"},
    "j_credit_card": {"name": "Credit Card", "rarity": "common"},
    "j_ceremonial": {"name": "Ceremonial Dagger", "rarity": "uncommon"},
    "j_banner": {"name": "Banner", "rarity": "common"},
    "j_mystic_summit": {"name": "Mystic Summit", "rarity": "common"},
    "j_marble": {"name": "Marble Joker", "rarity": "uncommon"},
    "j_loyalty_card": {"name": "Loyalty Card", "rarity": "uncommon"},
    "j_8_ball": {"name": "8 Ball", "rarity": "common"},
    "j_misprint": {"name": "Misprint", "rarity": "common"},
    "j_dusk": {"name": "Dusk", "rarity": "uncommon"},
    "j_raised_fist": {"name": "Raised Fist", "rarity": "common"},
    "j_chaos": {"name": "Chaos the Clown", "rarity": "common"},
    "j_fibonacci": {"name": "Fibonacci", "rarity": "uncommon"},
    "j_steel_joker": {"name": "Steel Joker", "rarity": "uncommon"},
    "j_scary_face": {"name": "Scary Face", "rarity": "common"},
    "j_abstract": {"name": "Abstract Joker", "rarity": "common"},
    "j_delayed_grat": {"name": "Delayed Gratification", "rarity": "common"},
    "j_hack": {"name": "Hack", "rarity": "uncommon"},
    "j_pareidolia": {"name": "Pareidolia", "rarity": "uncommon"},
    "j_gros_michel": {"name": "Gros Michel", "rarity": "common"},
    "j_even_steven": {"name": "Even Steven", "rarity": "common"},
    "j_odd_todd": {"name": "Odd Todd", "rarity": "common"},
    "j_scholar": {"name": "Scholar", "rarity": "common"},
    "j_business": {"name": "Business Card", "rarity": "common"},
    "j_supernova": {"name": "Supernova", "rarity": "common"},
    "j_ride_the_bus": {"name": "Ride the Bus", "rarity": "common"},
    "j_space": {"name": "Space Joker", "rarity": "uncommon"},
    "j_egg": {"name": "Egg", "rarity": "common"},
    "j_burglar": {"name": "Burglar", "rarity": "uncommon"},
    "j_blackboard": {"name": "Blackboard", "rarity": "uncommon"},
    "j_runner": {"name": "Runner", "rarity": "common"},
    "j_ice_cream": {"name": "Ice Cream", "rarity": "common"},
    "j_dna": {"name": "DNA", "rarity": "rare"},
    "j_splash": {"name": "Splash", "rarity": "common"},
    "j_blue_joker": {"name": "Blue Joker", "rarity": "common"},
    "j_sixth_sense": {"name": "Sixth Sense", "rarity": "uncommon"},
    "j_constellation": {"name": "Constellation", "rarity": "uncommon"},
    "j_hiker": {"name": "Hiker", "rarity": "uncommon"},
    "j_faceless": {"name": "Faceless Joker", "rarity": "common"},
    "j_green_joker": {"name": "Green Joker", "rarity": "common"},
    "j_superposition": {"name": "Superposition", "rarity": "common"},
    "j_todo_list": {"name": "To Do List", "rarity": "common"},
    "j_cavendish": {"name": "Cavendish", "rarity": "common"},
    "j_card_sharp": {"name": "Card Sharp", "rarity": "uncommon"},
    "j_red_card": {"name": "Red Card", "rarity": "common"},
    "j_madness": {"name": "Madness", "rarity": "uncommon"},
    "j_square": {"name": "Square Joker", "rarity": "common"},
    "j_seance": {"name": "Séance", "rarity": "uncommon"},
    "j_riff_raff": {"name": "Riff-Raff", "rarity": "common"},
    "j_vampire": {"name": "Vampire", "rarity": "uncommon"},
    "j_shortcut": {"name": "Shortcut", "rarity": "uncommon"},
    "j_hologram": {"name": "Hologram", "rarity": "uncommon"},
    "j_vagabond": {"name": "Vagabond", "rarity": "rare"},
    "j_baron": {"name": "Baron", "rarity": "rare"},
    "j_cloud_9": {"name": "Cloud 9", "rarity": "uncommon"},
    "j_rocket": {"name": "Rocket", "rarity": "uncommon"},
    "j_obelisk": {"name": "Obelisk", "rarity": "rare"},
    "j_midas_mask": {"name": "Midas Mask", "rarity": "uncommon"},
    "j_luchador": {"name": "Luchador", "rarity": "uncommon"},
    "j_photograph": {"name": "Photograph", "rarity": "common"},
    "j_gift": {"name": "Gift Card", "rarity": "uncommon"},
    "j_turtle_bean": {"name": "Turtle Bean", "rarity": "uncommon"},
    "j_erosion": {"name": "Erosion", "rarity": "uncommon"},
    "j_reserved_parking": {"name": "Reserved Parking", "rarity": "common"},
    "j_mail": {"name": "Mail-In Rebate", "rarity": "common"},
    "j_to_the_moon": {"name": "To the Moon", "rarity": "uncommon"},
    "j_hallucination": {"name": "Hallucination", "rarity": "common"},
    "j_fortune_teller": {"name": "Fortune Teller", "rarity": "common"},
    "j_juggler": {"name": "Juggler", "rarity": "common"},
    "j_drunkard": {"name": "Drunkard", "rarity": "common"},
    "j_stone": {"name": "Stone Joker", "rarity": "uncommon"},
    "j_golden": {"name": "Golden Joker", "rarity": "common"},
    "j_lucky_cat": {"name": "Lucky Cat", "rarity": "uncommon"},
    "j_baseball": {"name": "Baseball Card", "rarity": "rare"},
    "j_bull": {"name": "Bull", "rarity": "uncommon"},
    "j_diet_cola": {"name": "Diet Cola", "rarity": "uncommon"},
    "j_trading": {"name": "Trading Card", "rarity": "uncommon"},
    "j_flash": {"name": "Flash Card", "rarity": "uncommon"},
    "j_popcorn": {"name": "Popcorn", "rarity": "common"},
    "j_trousers": {"name": "Spare Trousers", "rarity": "uncommon"},
    "j_ancient": {"name": "Ancient Joker", "rarity": "rare"},
    "j_ramen": {"name": "Ramen", "rarity": "uncommon"},
    "j_walkie_talkie": {"name": "Walkie Talkie", "rarity": "common"},
    "j_selzer": {"name": "Seltzer", "rarity": "uncommon"},
    "j_castle": {"name": "Castle", "rarity": "uncommon"},
    "j_smiley": {"name": "Smiley Face", "rarity": "common"},
    "j_campfire": {"name": "Campfire", "rarity": "rare"},
    "j_ticket": {"name": "Golden Ticket", "rarity": "common"},
    "j_mr_bones": {"name": "Mr. Bones", "rarity": "uncommon"},
    "j_acrobat": {"name": "Acrobat", "rarity": "uncommon"},
    "j_sock_and_buskin": {"name": "Sock and Buskin", "rarity": "uncommon"},
    "j_swashbuckler": {"name": "Swashbuckler", "rarity": "common"},
    "j_troubadour": {"name": "Troubadour", "rarity": "uncommon"},
    "j_certificate": {"name": "Certificate", "rarity": "uncommon"},
    "j_smeared": {"name": "Smeared Joker", "rarity": "uncommon"},
    "j_throwback": {"name": "Throwback", "rarity": "uncommon"},
    "j_hanging_chad": {"name": "Hanging Chad", "rarity": "common"},
    "j_rough_gem": {"name": "Rough Gem", "rarity": "uncommon"},
    "j_bloodstone": {"name": "Bloodstone", "rarity": "uncommon"},
    "j_arrowhead": {"name": "Arrowhead", "rarity": "uncommon"},
    "j_onyx_agate": {"name": "Onyx Agate", "rarity": "uncommon"},
    "j_glass": {"name": "Glass Joker", "rarity": "uncommon"},
    "j_ring_master": {"name": "Showman", "rarity": "uncommon"},
    "j_flower_pot": {"name": "Flower Pot", "rarity": "uncommon"},
    "j_blueprint": {"name": "Blueprint", "rarity": "rare"},
    "j_wee": {"name": "Wee Joker", "rarity": "rare"},
    "j_merry_andy": {"name": "Merry Andy", "rarity": "uncommon"},
    "j_oops": {"name": "Oops! All 6s", "rarity": "uncommon"},
    "j_idol": {"name": "The Idol", "rarity": "uncommon"},
    "j_seeing_double": {"name": "Seeing Double", "rarity": "uncommon"},
    "j_matador": {"name": "Matador", "rarity": "uncommon"},
    "j_hit_the_road": {"name": "Hit the Road", "rarity": "rare"},
    "j_duo": {"name": "The Duo", "rarity": "rare"},
    "j_trio": {"name": "The Trio", "rarity": "rare"},
    "j_family": {"name": "The Family", "rarity": "rare"},
    "j_order": {"name": "The Order", "rarity": "rare"},
    "j_tribe": {"name": "The Tribe", "rarity": "rare"},
    "j_stuntman": {"name": "Stuntman", "rarity": "rare"},
    "j_invisible": {"name": "Invisible Joker", "rarity": "rare"},
    "j_brainstorm": {"name": "Brainstorm", "rarity": "rare"},
    "j_satellite": {"name": "Satellite", "rarity": "uncommon"},
    "j_shoot_the_moon": {"name": "Shoot the Moon", "rarity": "common"},
    "j_drivers_license": {"name": "Driver's License", "rarity": "rare"},
    "j_cartomancer": {"name": "Cartomancer", "rarity": "uncommon"},
    "j_astronomer": {"name": "Astronomer", "rarity": "uncommon"},
    "j_burnt": {"name": "Burnt Joker", "rarity": "rare"},
    "j_bootstraps": {"name": "Bootstraps", "rarity": "uncommon"},
    "j_caino": {"name": "Canio", "rarity": "legendary"},
    "j_triboulet": {"name": "Triboulet", "rarity": "legendary"},
    "j_yorick": {"name": "Yorick", "rarity": "legendary"},
    "j_chicot": {"name": "Chicot", "rarity": "legendary"},
    "j_perkeo": {"name": "Perkeo", "rarity": "legendary"},
}

RARITIES = ["common", "uncommon", "rare", "legendary"]

parser = argparse.ArgumentParser(
    prog="balatro_collection", description="Balatro gold sticker collection tracker"
)
parser.add_argument(
    "--stake",
    "-s",
    action="append",
    choices=[0, 1, 2, 3, 4, 5, 6, 7, 8],
    type=int,
)
parser.add_argument("--invert", "-i", action="store_true", default=False)
parser.add_argument("--rarity", "-r", action="append", choices=RARITIES)
parser.add_argument("--profile", "-p", choices=["1", "2", "3"], default="1")
parser.add_argument("--name", "-n")
args = parser.parse_args()


def invert(stakes, inv):
    if inv:
        return [i for i in [0, 1, 2, 3, 4, 5, 6, 7, 8] if i not in stakes]

    return stakes


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

CORANGE = fg(172)
CBLACK232 = fg(232)

COLOUR_NONE = CGREY  # no sticker
COLOUR_END = "\033[0m"

STAKE_COLOURS = {
    0: COLOUR_NONE,  # blank
    1: CWHITE,  # white
    2: CRED,  # red
    3: CGREEN,  # green
    4: CBLACK232,  # black
    5: CBLUE,  # blue
    6: CVIOLET,  # purple
    7: CORANGE,  # orange
    8: CYELLOW2,  # gold
}

input_file = os.path.join(BALATRO_DIR, args.profile, "profile.jkr")

with open(input_file, "rb") as f:
    input_data = zlib.decompress(f.read(), wbits=-15)

lua_table = input_data[7:].decode("utf-8")
profile = luadata.unserialize(lua_table)

for slug, data in JOKERS.items():
    name = data["name"]
    rarity = data["rarity"]

    if args.name and args.name not in name.lower():
        continue

    if args.rarity and rarity not in args.rarity:
        continue

    stats = profile["joker_usage"].get(slug)

    if not stats:
        stake_no = 0
    else:
        wins = stats.get("wins", [])

        if isinstance(wins, list):
            stake_no = len(wins)
        else:
            stake_no = max(wins.keys())

    colour = STAKE_COLOURS[stake_no]

    if not args.stake or stake_no in invert(args.stake, args.invert):
        print(f"{colour}{name}{COLOUR_END}")
