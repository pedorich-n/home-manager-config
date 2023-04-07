import getpass
import os
import re
import subprocess
from dataclasses import dataclass
from datetime import datetime
from typing import List

from rich.console import Console
from rich.prompt import Prompt

HM_PROFILES_ROOT = "/nix/var/nix/profiles/per-user/"
DATATIME_FORMAT = "%Y-%m-%d %H:%M"


@dataclass
class HmGeneration:
    version: int
    path: str
    created_at: datetime


def get_generations(user: str, root: str = HM_PROFILES_ROOT) -> List[HmGeneration]:
    hm_profile_regex = re.compile("home-manager-(?P<number>\d+)-link")
    path = os.path.join(root, user)
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
    generations = sorted(generations, key=lambda g: g.version, reverse=True)  # Sort from the most recent to the oldest

    return generations


def format_generation(generation: HmGeneration) -> str:
    return f"[dark_goldenrod]{generation.created_at.strftime(DATATIME_FORMAT)}[/dark_goldenrod]: [dodger_blue1]{generation.version}[/dodger_blue1]"


def get_hm_generation_input(number: str, choices: List[str], console: Console) -> int:
    result = Prompt.ask(f"Enter {number} HM Generation to compare", choices=choices, show_choices=False, console=console)
    return int(result)


def main():
    generations = get_generations(getpass.getuser())
    generations_dict = {generation.version: generation for generation in generations}
    valid_ids = [str(key) for key in generations_dict.keys()]

    console = Console()
    console.print("Available Home-Manager generations:")
    for _, generation in generations_dict.items():
        console.print(format_generation(generation))

    hm_generation_left_version = get_hm_generation_input("first", valid_ids, console)
    hm_generation_right_num = get_hm_generation_input("second", valid_ids, console)

    console.print(f"Comparing generations {hm_generation_left_version}..{hm_generation_right_num}")

    cmd = ["nvd", "diff", generations_dict[hm_generation_left_version].path, generations_dict[hm_generation_right_num].path]

    subprocess.run(cmd, shell=False)


main()
