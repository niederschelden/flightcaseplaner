#!/bin/bash

# Pfad zu OpenSCAD
OPENSCAD_PATH="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

# Dateiname
file="profile.scad"

# Iteriere durch die bekannten Profilnummern
for profile_number in {0..5}; do
    # Generiere den Bildnamen
    output_image="img/default_${profile_number}.png"
    
    # Aufruf von OpenSCAD mit den angegebenen Einstellungen
    $OPENSCAD_PATH -o $output_image --imgsize=200,200 --D "profil_nummer=$profile_number" --camera=10,10,0,180,0,0,140 --projection=p $file 

done

