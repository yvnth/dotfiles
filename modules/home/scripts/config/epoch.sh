#!/usr/bin/env bash
set -euo pipefail

PINK='\033[38;2;244;184;228m'
RESET='\033[0m'

install_time=$(date -d "2025-09-20 23:47:23" +%s)
current_time=$(date +%s)
install_datetime=$(date -d "@$install_time" "+%d-%m-%Y %H:%M:%S")
current_datetime=$(date "+%d-%m-%Y %H:%M:%S")

age_seconds=$((current_time - install_time))
seconds=$((age_seconds % 60))
total_minutes=$((age_seconds / 60))
minutes=$((total_minutes % 60))
total_hours=$((total_minutes / 60))
hours=$((total_hours % 24))
total_days=$((total_hours / 24))
days=$((total_days % 30))
total_months=$((total_days / 30))
months=$((total_months % 12))
years=$((total_months / 12))

p() {
  if [[ $1 -eq 1 ]]; then
    printf "${PINK}%s${RESET} %s" "$1" "$2"
  else
    printf "${PINK}%s${RESET} %ss" "$1" "$2"
  fi
}

echo -e "initial linux install time: ${PINK}${install_datetime}${RESET}"
echo -e "current time: ${PINK}${current_datetime}${RESET}"
echo
echo "time elapsed since then:"
echo
printf "in seconds: %s\n" "$(p "$age_seconds" second)"
printf "in minutes: %s, %s\n" "$(p "$total_minutes" minute)" "$(p "$seconds" second)"
printf "in hours: %s, %s, %s\n" "$(p "$total_hours" hour)" "$(p "$minutes" minute)" "$(p "$seconds" second)"
printf "in days: %s, %s, %s, %s\n" "$(p "$total_days" day)" "$(p "$hours" hour)" "$(p "$minutes" minute)" "$(p "$seconds" second)"
printf "in months: %s, %s, %s, %s, %s\n" "$(p "$total_months" month)" "$(p "$days" day)" "$(p "$hours" hour)" "$(p "$minutes" minute)" "$(p "$seconds" second)"
printf "in years: %s, %s, %s, %s, %s, %s\n" "$(p "$years" year)" "$(p "$months" month)" "$(p "$days" day)" "$(p "$hours" hour)" "$(p "$minutes" minute)" "$(p "$seconds" second)"
