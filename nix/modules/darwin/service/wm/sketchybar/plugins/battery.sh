#!/usr/bin/env bash

PERCENTAGE="$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)"
CHARGING="$(pmset -g batt | grep 'AC Power')"

if [ "$PERCENTAGE" = "" ]; then
  exit 0
fi

case "${PERCENTAGE}" in
  9[0-9]|100) ICON=""
  ;;
  [6-8][0-9]) ICON=""
  ;;
  [3-5][0-9]) ICON=""
  ;;
  [1-2][0-9]) ICON=""
  ;;
  *) ICON=""
esac

if [[ "$CHARGING" != "" ]]; then
  ICON=""
fi

sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"

# see https://github.com/FelixKratz/SketchyBar/blob/master/plugins/battery.sh
