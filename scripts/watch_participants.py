#! /usr/bin/env python3

import asyncio
import argparse
import sys

from labelrepo.projects.participant_demographics import watch_participants

parser = argparse.ArgumentParser()
parser.add_argument("labelbuddy_database", type=str)
parser.add_argument("-p", "--port", type=int, default=8765)
args = parser.parse_args()

try:
    asyncio.run(watch_participants(args.labelbuddy_database, args.port))
except KeyboardInterrupt:
    print()
    sys.exit(0)
