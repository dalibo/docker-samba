#!/bin/bash
#
# sourced by entrypoing

samba-tool user add --random-password alice
samba-tool user add --random-password bob

samba-tool group add owners
samba-tool group addmembers owners alice
