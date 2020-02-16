#!/usr/bin/env python

# import cmd
import os
# import argparse
import sys
from colorama import Fore, Back

__version__ = "0.0.1"

def cmd_line(s):
    print(Fore.GREEN + ">> " + s + Fore.RESET)
    ret = os.popen(s).read()
    print(ret)

# def handle_args():
#     parser = argparse.ArgumentParser(description="This is a cool program")
#     parser.add_argument("cmd", help="command: status")
#     # parser.add_argument("-V", "--version", help="show program version", action="store_true")
#     args = parser.parse_args()
#     return args


if __name__ == "__main__":

    if len(sys.argv) != 2:
        print(Fore.RED + f"*** Error: {sys.argv[0]} takes 1 argument ***")
        exit(1)

    arg = sys.argv[1]
    cmds = None

    if arg == "status":
        cmds = [
            "docker ps",
            "docker images",
            "docker system df -v"
        ]

    elif arg == "version":
        print(sys.argv[0], __version__)

    elif arg == "build":
        NAME = "pi-opencv"
        VERSION = "0.5.0"
        cmds = [
            f"docker build -t walchko/{NAME}:{VERSION} .",
            f"docker images walchko/{NAME}"
        ]

    elif arg == "clean":
        cmds = [
            "docker volume rm $(docker volume ls -qf dangling=true) $(docker ps -a -q)", # delete orphaned/dangling volumes
            "docker rmi $(docker images -q -f dangling=true)" # delete dangling/untagged images
            # docker rm $(docker ps -a -q)
        ]

    elif arg == "nuke":
        print(">> nuke everything ... ha ha ha!!")
        cmds = [
            "docker kill $(docker ps -q)",  # kill all running containers
            "docker stop $(docker ps -a -q)",
            "docker rm $(docker ps -a -q)", # delete all containers
            "docker system prune -a -f",
            "docker images prune -a",
            "docker volume prune -f",
            "docker container prune -f",
            "docker rmi $(docker images -a -q)" # delete all images
        ]
    else:
        print(Fore.RED + f"*** Unknown command: {arg} ***" + Fore.RESET)

    if cmds:
        for c in cmds:
            a = cmd_line(c)
            print(a)
            print("-"*40)
