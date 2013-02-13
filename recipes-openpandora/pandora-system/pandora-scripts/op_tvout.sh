#!/bin/bash

# defaults
tv_type="pal"
conn_type="svideo"
layer=0
pal_size="658,520"
pal_pos="35,35"
ntsc_size="655,455"
ntsc_pos="40,15"

usage()
{
  echo "usage: $0 [-d] [-t pal|ntsc] [-c composite|svideo] [-l 0|1] [-{p|n}s w,h] [-{p|n}p x,y]"
  exit 1
}

setup_scaler()
{
  # we must preallocate enough memory for the scaler layer
  # since the app won't be able to change this
  # the whole time TV-out is running..
  ofbset -fb /dev/fb1 -mem $[3*1024*1024] -size 512 256 -en 0
}

enable_it()
{
  size=$pal_size
  pos=$pal_pos
  if [ "$tv_type" = "ntsc" ]; then
    size=$ntsc_size
    pos=$ntsc_pos
  fi
  echo "${tv_type}, ${conn_type}, layer $layer, $pos $size"

  cd /sys/devices/platform/omapdss
  echo 0 > display1/enabled
  echo 0 > overlay0/enabled
  echo 0 > overlay1/enabled
  echo 0 > overlay2/enabled
  echo "" > /sys/class/graphics/fb2/overlays
  echo "" > /sys/class/graphics/fb1/overlays
  if [ $layer -eq 1 ]; then
    setup_scaler
    echo "0" > /sys/class/graphics/fb0/overlays
    echo "1,2" > /sys/class/graphics/fb1/overlays
  else
    # assume layer 0 for now
    echo "0,2" > /sys/class/graphics/fb0/overlays
    echo "1" > /sys/class/graphics/fb1/overlays
  fi
  echo $conn_type > display1/venc_type
  echo "tv" > overlay2/manager
  echo $tv_type > display1/timings
  echo $size > overlay2/output_size
  echo $pos > overlay2/position 
  echo 1 > overlay0/enabled
  echo 1 > overlay2/enabled
  echo 1 > display1/enabled
}

disable_it()
{
  cd /sys/devices/platform/omapdss
  echo 0 > overlay0/enabled
  echo 0 > overlay1/enabled
  echo 0 > overlay2/enabled
  echo 0 > display1/enabled
  echo "" > /sys/class/graphics/fb2/overlays
  echo "" > /sys/class/graphics/fb1/overlays
  echo 0 > /sys/class/graphics/fb0/overlays
  echo 1 > /sys/class/graphics/fb1/overlays
  echo 2 > /sys/class/graphics/fb2/overlays
  echo 1 > overlay0/enabled
}

# parse args
got_args=false
while true; do
  case $1 in
    "-d")
      disable_it
      exit 0
      ;;
    "-t")
      shift
      tv_type=$1
      ;;
    "-c")
      shift
      conn_type=$1
      ;;
    "-l")
      shift
      layer=$1
      ;;
    "-ps")
      shift
      if [ "$1" != "0,0" ]; then
        pal_size=$1
      else
        echo "warning: ignored pal_size: $1"
      fi
      ;;
    "-pp")
      shift
      pal_pos=$1
      ;;
    "-ns")
      shift
      if [ "$1" != "0,0" ]; then
        ntsc_size=$1
      else
        echo "warning: ignored ntsc_size: $1"
      fi
      ;;
    "-np")
      shift
      ntsc_pos=$1
      ;;
    "")
      ;;
    *)
      usage
      ;;
  esac

  if ! shift; then break; fi
  got_args=true
done

if [ "$tv_type" != "pal" -a "$tv_type" != "ntsc" ]; then
  usage
fi

if [ "$conn_type" != "svideo" -a "$conn_type" != "composite" ]; then
  usage
fi

if [ "$layer" != "0" -a "$layer" != "1" ]; then
  usage
fi


if $got_args; then
  enable_it
else
  # old zenity menu, to be removed
  while mainsel=$(zenity --title="TV-Out Configuration" --width="420" --height="348" --list \
    --column "id" --column "Please select" --hide-column=1 \
    --text="This is a very simple TV Out Script. It will be enhanced." \
    "pal" "Enable TV Out in PAL Mode (Composite)" \
    "ntsc" "Enable TV Out in NTSC Mode (Composite)" \
    "pal2" "Enable TV Out in PAL Mode, overlay (Composite)" \
    "ntsc2" "Enable TV Out in NTSC Mode, overlay (Composite)" \
    "pals" "Enable TV Out in PAL Mode (SVideo)" \
    "ntscs" "Enable TV Out in NTSC Mode (SVideo)" \
    "pal2s" "Enable TV Out in PAL Mode, overlay (SVideo)" \
    "ntsc2s" "Enable TV Out in NTSC Mode, overlay (SVideo)" \
    "disable" "Disable TV Out" \
    )
  do

  case $mainsel in
    "pal")
    layer=0
    tv_type="pal"
    conn_type="composite"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (PAL Mode) has been enabled." --timeout 6
    ;;

    "pal2")
    layer=1
    tv_type="pal"
    conn_type="composite"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (PAL Mode) has been enabled." --timeout 6
    ;;

    "ntsc")
    layer=0
    tv_type="ntsc"
    conn_type="composite"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (NTSC Mode) has been enabled." --timeout 6  
    ;;

    "ntsc2")
    layer=1
    tv_type="ntsc"
    conn_type="composite"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (NTSC Mode) has been enabled." --timeout 6  
    ;;

    "pals")
    layer=0
    tv_type="pal"
    conn_type="svideo"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (PAL Mode) has been enabled." --timeout 6
    ;;

    "pal2s")
    layer=1
    tv_type="pal"
    conn_type="svideo"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (PAL Mode) has been enabled." --timeout 6
    ;;

    "ntscs")
    layer=0
    tv_type="ntsc"
    conn_type="svideo"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (NTSC Mode) has been enabled." --timeout 6  
    ;;

    "ntsc2s")
    layer=1
    tv_type="ntsc"
    conn_type="svideo"
    enable_it
    zenity --info --title="TV Out" --text "TV Out (NTSC Mode) has been enabled." --timeout 6  
    ;;


    "disable")
    disable_it
    zenity --info --title="TV Out" --text "TV Out has been disabled." --timeout 6
    ;;    
  esac
  done
fi
