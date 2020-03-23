#!/usr/bin/env python

import subprocess
import time
import io


def start(executable_file):
    print(executable_file)
    return subprocess.Popen(
        executable_file,
        shell=True,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE
        # stderr=subprocess.PIPE
    )


def read(process):
    return process.stdout.readline().decode("utf-8").strip()


def write(process, message):
    # process.stdin.write(f"{message.strip()}\n\r".encode("utf-8"))
    process.stdin.write(f"{message}\n".encode("utf-8"))
    process.stdin.flush()


def terminate(process):
    process.stdin.close()
    process.terminate()
    process.wait(timeout=0.2)


cmd = "docker run -ti -v `pwd`/pi-opencv:/done --name pi-opencv  walchko/pi-opencv:0.5.0"

process = start(cmd)

stdin = io.TextIOWrapper(
    process.stdin,
    encoding='utf-8',
    line_buffering=True,  # send data on newline
)
stdout = io.TextIOWrapper(
    process.stdout,
    encoding='utf-8',
)

for _ in range(10):
    time.sleep(0.5)
    print(stdout.readline())
    stdin.write("ls -al\n")
    # print(process.communicate()[0].decode("utf-8"))
    # print(read(process))
    # a = input(">> ")
    # if a:
    a = "ls -al"
    # write(process, a)
    # if a == "exit":
    #     terminate(process)
    #     cmd_line(cmds["run"][1])
    #     cmd_line(cmds["run"][2])
    #     break
