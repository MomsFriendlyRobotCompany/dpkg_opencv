#!/usr/bin/env python

# import cmd
import os
# import argparse
import sys
from colorama import Fore, Back

__version__ = "0.0.1"

import subprocess


def start(executable_file):
    return subprocess.Popen(
        executable_file,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )


def read(process):
    return process.stdout.readline().decode("utf-8").strip()


def write(process, message):
    process.stdin.write(f"{message.strip()}\n".encode("utf-8"))
    process.stdin.flush()


def terminate(process):
    process.stdin.close()
    process.terminate()
    process.wait(timeout=0.2)


NAME = "pi-opencv"
VERSION = "0.5.0"

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

    cmds = {}

    cmds["nuke"] = [
        "docker kill $(docker ps -q)",  # kill all running containers
        "docker stop $(docker ps -a -q)",
        "docker rm $(docker ps -a -q)", # delete all containers
        "docker system prune -a -f",
        "docker images prune -a",
        "docker volume prune -f",
        "docker container prune -f",
        "docker rmi $(docker images -a -q)" # delete all images
    ]

    cmds["status"] = [
        "docker ps",
        "docker images",
        "docker system df -v"
    ]

    cmds["clean"] = [
        "docker volume rm $(docker volume ls -qf dangling=true) $(docker ps -a -q)", # delete orphaned/dangling volumes
        "docker rmi $(docker images -q -f dangling=true)" # delete dangling/untagged images
        # docker rm $(docker ps -a -q)
    ]

    cmds["build"] = [
        f"docker build -t walchko/{NAME}:{VERSION} .",
        f"docker images walchko/{NAME}"
    ]

    # cmds["run"] = [
    #     # THIS DOESN'T WORK ... need interactive commandline!!!!
    # docker run -ti -v `pwd`/pi-opencv:/done --name pi-opencv  walchko/pi-opencv:0.5.0
    #     f"docker run -ti -v `pwd`/pi-opencv:/done --name {NAME}  walchko/{NAME}:{VERSION}",
    #     f"docker stop {NAME}",
    #     f"docker rm {NAME}"
    # ]

    cmds["rm"] = [
        f"docker stop {NAME}",
        f"docker rm {NAME}"
    ]


    arg = sys.argv[1]
    if arg == "version":
        print(sys.argv[0], __version__)
        exit(0)

        # print(">> nuke everything ... ha ha ha!!")
    elif arg not in cmds.keys():
        print(Fore.RED + f"*** Unknown command: {arg} ***" + Fore.RESET)
        print(Fore.YELLOW + f"{sys.argv[0]} valid commands are:")
        for k in cmds.keys():
            print(f"  {k}")
        print("  version" + Fore.RESET)
        exit(1)

    # if arg == "run":
    #     process = start(cmds["run"][0].split(" "))
    #     while True:
    #         print(read(process))
    #         a = input(">> ")
    #         if a:
    #             write(process, a)
    #         if a == "exit":
    #             terminate(process)
    #             cmd_line(cmds["run"][1])
    #             cmd_line(cmds["run"][2])
    #             break
    # else:
    for c in cmds[arg]:
        a = cmd_line(c)
        print(a)
        print("-"*40)
