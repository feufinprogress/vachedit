#!/bin/bash

# Gère l'épaisseur et la construction du panneau, en fonction du nombre de charactères.
function display_sign() {
  local message="$1"
  local length=${#message}
  local border=""

  for (( i=0; i<(length+0); i++ )); do
    border="${border}_"
  done

  echo " $border "
  echo "/$message\\"
  echo "\\$border/"
}

# Fichier Ascii utilisé si aucun argument n'est donné à la fonction.
default_ascii_file="vache.txt"
ascii_file="$default_ascii_file"
ascii_dir=~/bin/vachedit/ascii

# Fonction pour lister tous les personnages ascii
list_ascii_files() {
  local ascii_dir=~/bin/vachedit/ascii
  local files=("$ascii_dir"/*.txt)
  local file_names=()

  for file in "${files[@]}"; do
    file_names+=("$(basename "$file" .txt)")
  done

  echo "Personnages disponibles :"
  echo "${file_names[*]}"
}

# Executer la fonction
while getopts "a:l" opt; do
  case $opt in
    a)
      ascii_file="$OPTARG.txt"
      ;;
    l)
      list_ascii_files
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "L'option -$OPTARG requiert un argument." >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND-1)) #Ligne necessaire pour écrire sans guillemets 

# Check si le fichier existe. Si non, renvoie une erreur.
ascii_path=~/bin/vachedit/ascii/"$ascii_file"
if [ ! -f "$ascii_path" ]; then
  echo "Erreur: le fichier '$ascii_file' n'existe pas." >&2
  exit 1
fi

# Execute la commande
if [ $# -eq 0 ]; then
  echo "Utilisation : vachedit (-a personnage) [message]"
  exit 1
fi

# Affiche le message
message="$*"
display_sign "$message"
cat "$ascii_path"
