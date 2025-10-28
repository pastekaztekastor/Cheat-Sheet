# Guide d'installation - Cheat-Sheet

## Installation automatique (Linux/macOS)

Le script d'installation automatique configure tout pour vous.

### Étapes:

1. **Rendre le script exécutable**
   ```bash
   chmod +x install.sh
   ```

2. **Lancer l'installation**
   ```bash
   ./install.sh
   ```

Le script va:
- Détecter votre système d'exploitation
- Vérifier que Java est installé
- Télécharger et installer Processing 3.5.4
- Créer le dossier data nécessaire
- Créer un script de lancement `run.sh`

3. **Lancer le projet**
   ```bash
   ./run.sh
   ```

## Installation manuelle

### 1. Installer Processing

#### Linux
```bash
# Télécharger Processing
wget https://github.com/processing/processing/releases/download/processing-0270-3.5.4/processing-3.5.4-linux64.tgz

# Extraire
tar -xzf processing-3.5.4-linux64.tgz

# Déplacer dans un dossier d'installation
mv processing-3.5.4 ~/processing
```

#### macOS
```bash
# Télécharger Processing
curl -L https://github.com/processing/processing/releases/download/processing-0270-3.5.4/processing-3.5.4-macosx.zip -o processing.zip

# Extraire
unzip processing.zip

# Déplacer dans Applications
mv Processing.app /Applications/
```

#### Windows
1. Télécharger Processing depuis https://processing.org/download
2. Extraire l'archive ZIP
3. Lancer processing.exe

### 2. Vérifier les dépendances

Consultez le fichier `DEPENDENCIES.md` pour la liste complète des dépendances.

Toutes les bibliothèques nécessaires sont incluses avec Processing.

### 3. Configurer le projet

1. **Créer le dossier data (si nécessaire)**
   ```bash
   mkdir -p programme_Main/data
   ```

2. **Ajouter les ressources**
   - Placez la police `FORCED_SQUARE-50.vlw` dans `programme_Main/data/`
   - Ajoutez les fichiers de niveaux et de configuration

### 4. Lancer le projet

#### En ligne de commande

**Linux/macOS:**
```bash
~/processing/processing --sketch=$(pwd)/programme_Main --run
```

**Windows:**
```cmd
processing.exe --sketch=C:\chemin\vers\programme_Main --run
```

#### Avec l'IDE Processing

1. Ouvrir Processing IDE
2. Fichier > Ouvrir
3. Sélectionner `programme_Main/programme_Main.pde`
4. Cliquer sur le bouton "Run" (triangle)

## Exécutables précompilés

Des versions exécutables sont déjà disponibles:

### Windows 32-bit
```bash
cd application.windows32
./programme_Main.exe
```

### Windows 64-bit
```bash
cd application.windows64
./programme_Main.exe
```

Ces versions incluent tout le nécessaire et ne nécessitent pas d'installation de Processing.

## Résolution des problèmes

### Le projet ne démarre pas

**Problème**: Erreur "NullPointerException" au démarrage

**Solution**: Vérifiez que la police `FORCED_SQUARE-50.vlw` est présente dans `programme_Main/data/`

Pour créer la police:
1. Ouvrir Processing IDE
2. Tools > Create Font
3. Sélectionner FORCED SQUARE ou une police similaire
4. Taille: 50
5. Enregistrer dans `data/`

### Processing ne se lance pas

**Problème**: Processing ne démarre pas sur Linux

**Solution**: Installer les dépendances système
```bash
# Debian/Ubuntu
sudo apt-get install default-jre libgl1-mesa-glx libglu1-mesa

# Arch Linux
sudo pacman -S jre-openjdk mesa

# Fedora
sudo dnf install java-latest-openjdk mesa-libGL mesa-libGLU
```

### Erreur de permissions

**Problème**: "Permission denied" lors de l'exécution

**Solution**:
```bash
chmod +x install.sh
chmod +x run.sh
```

### Java n'est pas installé

**Problème**: Java n'est pas trouvé

**Solution**: Processing inclut sa propre version de Java. Vous n'avez pas besoin d'installer Java séparément.

Si vous souhaitez quand même installer Java:

**Debian/Ubuntu:**
```bash
sudo apt-get update
sudo apt-get install default-jdk
```

**macOS:**
```bash
brew install openjdk
```

## Support

Pour plus d'informations:
- Documentation Processing: https://processing.org/reference
- Dépendances du projet: voir `DEPENDENCIES.md`
- Code source: `programme_Main/`

## Configuration système requise

### Minimum
- OS: Windows 7+, Linux (kernel 3.x+), macOS 10.10+
- RAM: 512 MB
- Espace disque: 200 MB
- Java: JRE 8+ (inclus avec Processing)

### Recommandé
- OS: Windows 10/11, Ubuntu 20.04+, macOS 10.14+
- RAM: 1 GB
- Espace disque: 500 MB
- Accélération graphique: Support OpenGL 2.0+
