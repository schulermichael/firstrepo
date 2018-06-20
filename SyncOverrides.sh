#!/bin/sh

####
# Script, welches den AutoPkg-RecipeOverrides-Ordnerinhalt synchron hält.
####
# Voraussetzung: git und AutoPkg(r) sind installiert und konfiguriert.
####
# A&F/MSH 20.06.2018
####

# Parameter zum anpassen:
WEB_OVERRIDE_DIR="http://github.com/schulermichael/af-overrides"

# automatische Parameter:
LOCAL_OVERRIDE_DIR=$(defaults read com.github.autopkg RECIPE_OVERRIDE_DIRS)

# Klont WEB_OVERRIDE_DIR per git, falls im Override-Ordner noch kein .git vorhanden ist
if [ -e "$LOCAL_OVERRIDE_DIR/.git" ]
then
echo "Initialer 'git clone' wurde schon erfolgreich ausgeführt!"
else
git clone "$WEB_OVERRIDE_DIR" "$LOCAL_OVERRIDE_DIR"
fi

# setzt master als aktiver branch.
git -C "$LOCAL_OVERRIDE_DIR" checkout master

# löscht/resettet in LOCAL_OVERRIDE_DIR gemachte Änderungen an bestehenden Dateien.
git -C "$LOCAL_OVERRIDE_DIR" stash

# synchronisiert WEB_OVERRIDE_DIR nach LOCAL_OVERRIDE_DIR.
git -C "$LOCAL_OVERRIDE_DIR" pull

# führt ein update-trust-info aller Overrides aus.
OVERRIDEFILES="$LOCAL_OVERRIDE_DIR/*"
for f in $OVERRIDEFILES
do
  yes | autopkg update-trust-info $f
done



exit 0
