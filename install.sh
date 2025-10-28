#!/bin/bash

# ========================================
# Script d'installation - Cheat-Sheet
# Projet Processing
# ========================================

set -e  # Arrêt du script en cas d'erreur

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Variables
PROCESSING_VERSION="3.5.4"
INSTALL_DIR="$HOME/processing"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$PROJECT_DIR/programme_Main/data"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Installation du projet Cheat-Sheet${NC}"
echo -e "${BLUE}========================================${NC}\n"

# ========================================
# Fonction: Détection du système d'exploitation
# ========================================
detect_os() {
    echo -e "${YELLOW}[1/6] Détection du système d'exploitation...${NC}"

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        ARCH=$(uname -m)
        if [[ "$ARCH" == "x86_64" ]]; then
            PROCESSING_URL="https://github.com/processing/processing/releases/download/processing-0270-3.5.4/processing-3.5.4-linux64.tgz"
            PROCESSING_FILE="processing-3.5.4-linux64.tgz"
        else
            PROCESSING_URL="https://github.com/processing/processing/releases/download/processing-0270-3.5.4/processing-3.5.4-linux32.tgz"
            PROCESSING_FILE="processing-3.5.4-linux32.tgz"
        fi
        echo -e "${GREEN}✓ Linux $ARCH détecté${NC}\n"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PROCESSING_URL="https://github.com/processing/processing/releases/download/processing-0270-3.5.4/processing-3.5.4-macosx.zip"
        PROCESSING_FILE="processing-3.5.4-macosx.zip"
        echo -e "${GREEN}✓ macOS détecté${NC}\n"
    else
        echo -e "${RED}✗ Système d'exploitation non supporté: $OSTYPE${NC}"
        echo -e "${YELLOW}Ce script supporte Linux et macOS uniquement.${NC}"
        echo -e "${YELLOW}Pour Windows, téléchargez Processing manuellement depuis https://processing.org/download${NC}"
        exit 1
    fi
}

# ========================================
# Fonction: Vérification de Java
# ========================================
check_java() {
    echo -e "${YELLOW}[2/6] Vérification de Java...${NC}"

    if command -v java &> /dev/null; then
        JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        echo -e "${GREEN}✓ Java $JAVA_VERSION est installé${NC}\n"
    else
        echo -e "${YELLOW}⚠ Java n'est pas installé${NC}"
        echo -e "${YELLOW}Processing inclut sa propre version de Java, l'installation continuera.${NC}\n"
    fi
}

# ========================================
# Fonction: Installation de Processing
# ========================================
install_processing() {
    echo -e "${YELLOW}[3/6] Installation de Processing...${NC}"

    if [ -d "$INSTALL_DIR" ]; then
        echo -e "${GREEN}✓ Processing est déjà installé dans $INSTALL_DIR${NC}"
        read -p "Voulez-vous réinstaller Processing? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}Installation de Processing ignorée.${NC}\n"
            return
        fi
        echo -e "${YELLOW}Suppression de l'installation existante...${NC}"
        rm -rf "$INSTALL_DIR"
    fi

    # Création du dossier temporaire
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    echo -e "${BLUE}Téléchargement de Processing $PROCESSING_VERSION...${NC}"
    if command -v wget &> /dev/null; then
        wget -q --show-progress "$PROCESSING_URL" -O "$PROCESSING_FILE"
    elif command -v curl &> /dev/null; then
        curl -L --progress-bar "$PROCESSING_URL" -o "$PROCESSING_FILE"
    else
        echo -e "${RED}✗ wget ou curl est requis pour télécharger Processing${NC}"
        echo -e "${YELLOW}Installez wget: sudo apt-get install wget (Debian/Ubuntu)${NC}"
        exit 1
    fi

    echo -e "${BLUE}Extraction de Processing...${NC}"
    if [[ "$OS" == "macos" ]]; then
        unzip -q "$PROCESSING_FILE"
        mv Processing.app "$INSTALL_DIR"
    else
        tar -xzf "$PROCESSING_FILE"
        mv processing-$PROCESSING_VERSION "$INSTALL_DIR"
    fi

    # Nettoyage
    cd "$PROJECT_DIR"
    rm -rf "$TMP_DIR"

    echo -e "${GREEN}✓ Processing installé avec succès${NC}\n"
}

# ========================================
# Fonction: Création du dossier data
# ========================================
setup_data_folder() {
    echo -e "${YELLOW}[4/6] Configuration du dossier data...${NC}"

    if [ ! -d "$DATA_DIR" ]; then
        echo -e "${BLUE}Création du dossier data...${NC}"
        mkdir -p "$DATA_DIR"
    fi

    # Vérification des fichiers nécessaires
    if [ ! -f "$DATA_DIR/FORCED_SQUARE-50.vlw" ]; then
        echo -e "${YELLOW}⚠ Attention: La police FORCED_SQUARE-50.vlw n'est pas présente${NC}"
        echo -e "${YELLOW}  Le projet ne pourra pas démarrer sans cette police.${NC}"
        echo -e "${YELLOW}  Veuillez ajouter le fichier .vlw dans le dossier data/${NC}"
    else
        echo -e "${GREEN}✓ Police de caractères trouvée${NC}"
    fi

    echo -e "${GREEN}✓ Dossier data configuré${NC}\n"
}

# ========================================
# Fonction: Vérification des fichiers du projet
# ========================================
check_project_files() {
    echo -e "${YELLOW}[5/6] Vérification des fichiers du projet...${NC}"

    MAIN_FILE="$PROJECT_DIR/programme_Main/programme_Main.pde"
    if [ ! -f "$MAIN_FILE" ]; then
        echo -e "${RED}✗ Fichier principal non trouvé: $MAIN_FILE${NC}"
        exit 1
    fi

    # Compter les fichiers .pde
    PDE_COUNT=$(find "$PROJECT_DIR/programme_Main" -maxdepth 1 -name "*.pde" | wc -l)
    echo -e "${GREEN}✓ $PDE_COUNT fichiers .pde trouvés${NC}\n"
}

# ========================================
# Fonction: Création du lanceur
# ========================================
create_launcher() {
    echo -e "${YELLOW}[6/6] Création du script de lancement...${NC}"

    LAUNCHER="$PROJECT_DIR/run.sh"

    if [[ "$OS" == "macos" ]]; then
        PROCESSING_EXEC="$INSTALL_DIR/Contents/MacOS/Processing"
    else
        PROCESSING_EXEC="$INSTALL_DIR/processing"
    fi

    cat > "$LAUNCHER" << EOF
#!/bin/bash
# Script de lancement - Cheat-Sheet

PROCESSING="$PROCESSING_EXEC"
PROJECT_DIR="$PROJECT_DIR/programme_Main"

if [ ! -f "\$PROCESSING" ]; then
    echo "Erreur: Processing n'est pas installé dans $INSTALL_DIR"
    echo "Exécutez install.sh pour installer Processing"
    exit 1
fi

echo "Lancement du projet Cheat-Sheet..."
"\$PROCESSING" --sketch="\$PROJECT_DIR" --run
EOF

    chmod +x "$LAUNCHER"
    echo -e "${GREEN}✓ Script de lancement créé: $LAUNCHER${NC}\n"
}

# ========================================
# Fonction: Affichage du résumé
# ========================================
show_summary() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${GREEN}Installation terminée avec succès!${NC}"
    echo -e "${BLUE}========================================${NC}\n"

    echo -e "${YELLOW}Informations:${NC}"
    echo -e "  • Dossier du projet: $PROJECT_DIR"
    echo -e "  • Processing installé: $INSTALL_DIR"
    echo -e "  • Dossier data: $DATA_DIR"
    echo -e ""

    echo -e "${YELLOW}Pour lancer le projet:${NC}"
    echo -e "  ${GREEN}./run.sh${NC}"
    echo -e ""

    echo -e "${YELLOW}Ou manuellement avec Processing:${NC}"
    if [[ "$OS" == "macos" ]]; then
        echo -e "  ${GREEN}$INSTALL_DIR/Contents/MacOS/Processing --sketch=$PROJECT_DIR/programme_Main --run${NC}"
    else
        echo -e "  ${GREEN}$INSTALL_DIR/processing --sketch=$PROJECT_DIR/programme_Main --run${NC}"
    fi
    echo -e ""

    echo -e "${YELLOW}Fichiers importants:${NC}"
    echo -e "  • DEPENDENCIES.md - Liste des dépendances"
    echo -e "  • README.md - Documentation du projet"
    echo -e ""

    if [ ! -f "$DATA_DIR/FORCED_SQUARE-50.vlw" ]; then
        echo -e "${RED}⚠ ATTENTION:${NC}"
        echo -e "${YELLOW}  La police FORCED_SQUARE-50.vlw est manquante!${NC}"
        echo -e "${YELLOW}  Ajoutez-la dans: $DATA_DIR/${NC}"
        echo -e ""
    fi
}

# ========================================
# Exécution principale
# ========================================
main() {
    detect_os
    check_java
    install_processing
    setup_data_folder
    check_project_files
    create_launcher
    show_summary
}

# Lancement du script
main
