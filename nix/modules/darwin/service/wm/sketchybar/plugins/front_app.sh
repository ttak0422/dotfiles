#!/usr/bin/env bash

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO"
fi

# see https://github.com/FelixKratz/SketchyBar/blob/master/plugins/front_app.sh
