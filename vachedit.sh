#!/bin/bash

# La première ligne d'un script bash s'appelle un shebang : 
# elle sert simplement à indiquer l'endroit ou se trouve le shell pour executer le script.

# Gère l'épaisseur et la construction du panneau, en fonction du nombre de charactères.
function display_sign() {
  local message="$1"
  local length=${#message}
  local border=""

  for (( i=0; i<length; i++ )); do
    border="${border}_"
  done

  echo " $border "
  echo "/$message\\"
  echo "\\$border/"
}

# Répertoire des fichiers ASCII et de texte
ascii_dir=~/bin/vachedit/ascii
text_dir=~/bin/vachedit/text

# Fonction pour lister tous les personnages ascii
list_ascii_files() {
  local files=("$ascii_dir"/*.txt)
  local file_names=()

  for file in "${files[@]}"; do
    file_names+=("$(basename "$file" .txt)")
  done

  echo "Personnages disponibles :"
  echo "${file_names[*]}"
}

# Fonction pour choisir un fichier ASCII aléatoire
choose_random_ascii() {
  local files=("$ascii_dir"/*.txt)
  local random_index=$((RANDOM % ${#files[@]}))
  echo "${files[$random_index]}"
}

# Fonction pour choisir un texte aléatoire
choose_random_text() {
  local files=("$text_dir"/*.txt)
  local random_index=$((RANDOM % ${#files[@]}))
  cat "${files[$random_index]}"
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

shift $((OPTIND-1)) # Ligne nécessaire pour écrire sans guillemets après cowsay

# Boucle infinie pour afficher un message aléatoire avec un art ASCII aléatoire
while true; do
  # Choisir un fichier ASCII aléatoire
  ascii_path=$(choose_random_ascii)
  
  # Vérifie si le fichier existe. Si non, renvoie une erreur.
  if [ ! -f "$ascii_path" ]; then
    echo "Erreur: le fichier '$ascii_file' n'existe pas." >&2
    exit 1
  fi
  
  # Choisir un texte aléatoire
  message=$(choose_random_text)
  
  # Affiche le message et le fichier ASCII
  display_sign "$message"
  cat "$ascii_path"
  
  # Attendre 0.75 secondes avant de recommencer
  sleep 0.75
done
