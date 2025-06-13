#!/usr/bin/env bash

INPUT="/home/davidtaki/testtask/dilans_data.csv"

awk -F';' '
  $2=="read" {
    if      (NF==6)  print > "first_visit.csv"
    else if (NF==5)  print > "returning_visit.csv"
    else             print > "read_errors.csv"
  }
' "$INPUT"
