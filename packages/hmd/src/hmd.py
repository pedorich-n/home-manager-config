import getpass
import os
import re
import signal
import subprocess
import sys
from dataclasses import dataclass
from datetime import datetime
from typing import List

from rich.console import Console
from rich.prompt import Prompt

signal.signal(signal.SIGINT, lambda signal, frame: sys.exit(0))


@dataclass
class HmGeneration:
    version: int
    path: str
    created_at: datetime


def get_hm_profiles_root(user: str) -> str:
    # A copy of https://github.com/nix-community/home-manager/blob/f1490b8/home-manager/home-manager#L119-L140
    global_nix_state_dir = os.environ.get("NIX_STATE_DIR", "/nix/var/nix")
    global_nix_profiles_dir = os.path.join(global_nix_state_dir, "profiles", "per-user", user)

    user_state_home = os.environ.get("XDG_STATE_HOME", os.path.join(os.path.expanduser("~"), ".local", "state"))
    user_nix_state_dir = os.path.join(user_state_home, "nix")
    user_nix_profiles_dir = os.path.join(user_nix_state_dir, "profiles", user)

    if os.path.exists(user_nix_profiles_dir):
        return user_nix_profiles_dir
    else:
        return global_nix_profiles_dir


def get_generations(path: str) -> List[HmGeneration]:
    hm_profile_regex = re.compile(r"home-manager-(?P<number>\d+)-link")
    subfolders = [p.path for p in os.scandir(path) if p.is_dir()]

    generations = []
    for folder in subfolders:
        result = re.search(hm_profile_regex, folder)
        if result:
            version_number = int(result.groupdict()["number"])
            real_path = os.path.realpath(folder)
            created_at = datetime.fromtimestamp(os.path.getctime(real_path))

            generation = HmGeneration(version=version_number, path=real_path, created_at=created_at)

            generations.append(generation)
    generations = sorted(generations, key=lambda g: g.version, reverse=True)

    return generations


def format_generation(generation: HmGeneration) -> str:
    format = "%Y-%m-%d %H:%M"
    return f"[dark_goldenrod]{generation.created_at.strftime(format)}[/dark_goldenrod]: [dodger_blue1]{generation.version}[/dodger_blue1]"


def get_hm_generation_input(number: str, choices: List[str], console: Console, default: str) -> int:
    result = Prompt.ask(f"Enter {number} HM Generation to compare", choices=choices, show_choices=False, console=console, default=default)
    return int(result)


def main():
    console = Console()
    try:
        user = getpass.getuser()
    except Exception as e:
        console.print("Failed to get current user!")
        console.print_exception()
        sys.exit(1)

    path_for_user = get_hm_profiles_root(user)

    generations_dict = {generation.version: generation for generation in get_generations(path_for_user)}
    valid_ids = [str(key) for key in generations_dict.keys()]

    console.print("Available Home-Manager generations:")
    for _, generation in generations_dict.items():
        console.print(format_generation(generation))

    if len(generations_dict) < 2:
        console.print("At least 2 Home-Manager generations required!")
        sys.exit(1)

    hm_generation_first = generations_dict[get_hm_generation_input("first", valid_ids, console, valid_ids[1])]
    hm_generation_second = generations_dict[get_hm_generation_input("second", valid_ids, console, valid_ids[0])]

    console.print(f"Comparing generations {hm_generation_first.version}..{hm_generation_second.version}")

    cmd = ["nvd", "diff", hm_generation_first.path, hm_generation_second.path]

    subprocess.run(cmd, shell=False)
