# Dépendances du projet Cheat-Sheet

## Description
Ce projet est développé en Processing, un langage de programmation basé sur Java pour la création d'animations et de jeux.

## Dépendances principales

### Processing
- **Version recommandée**: Processing 3.5.4 ou supérieur
- **Description**: Environnement de développement et bibliothèques principales
- **Site officiel**: https://processing.org/download

### Bibliothèques Processing utilisées
Le projet utilise les bibliothèques core de Processing:

1. **processing.core**
   - Bibliothèque principale de Processing
   - Fournie avec l'installation de Processing
   - Contient les fonctions de base (draw, setup, etc.)

2. **processing.data**
   - Gestion des données et structures de données
   - Fournie avec l'installation de Processing

3. **processing.event**
   - Gestion des événements (souris, clavier)
   - Fournie avec l'installation de Processing

4. **processing.opengl**
   - Rendu graphique OpenGL
   - Fournie avec l'installation de Processing
   - Utilise JOGL (Java OpenGL) en arrière-plan

### Bibliothèques Java standard
- **java.util** (HashMap, ArrayList)
- **java.io** (File, BufferedReader, PrintWriter, etc.)

### Dépendances natives (incluses dans Processing)

1. **JOGL (Java OpenGL)**
   - Bibliothèques: jogl-all.jar
   - Natives Windows 32-bit: jogl-all-natives-windows-i586.jar
   - Natives Windows 64-bit: jogl-all-natives-windows-amd64.jar
   - Natives Linux: jogl-all-natives-linux-*.jar

2. **GlueGen**
   - Bibliothèques: gluegen-rt.jar
   - Natives Windows 32-bit: gluegen-rt-natives-windows-i586.jar
   - Natives Windows 64-bit: gluegen-rt-natives-windows-amd64.jar
   - Natives Linux: gluegen-rt-natives-linux-*.jar

### Ressources requises

1. **Police de caractères**
   - FORCED_SQUARE-50.vlw (police personnalisée)
   - Doit être dans le dossier data/ du projet

2. **Fichiers de données**
   - Fichiers de niveaux et de scores
   - Stockés dans le dossier data/ du projet

## Configuration système requise

### Minimum
- **OS**: Windows, Linux, macOS
- **RAM**: 512 MB
- **Java**: JRE 8 ou supérieur (inclus avec Processing)
- **Espace disque**: 200 MB

### Recommandé
- **OS**: Windows 10/11, Ubuntu 20.04+, macOS 10.14+
- **RAM**: 1 GB
- **Java**: JRE 11 ou supérieur
- **Espace disque**: 500 MB
- **Accélération graphique**: Support OpenGL 2.0+

## Installation

Pour installer toutes les dépendances, utilisez le script d'installation:

```bash
chmod +x install.sh
./install.sh
```

## Remarques

- Aucune bibliothèque Processing externe n'est requise
- Toutes les dépendances sont incluses dans l'installation standard de Processing
- Les exports Windows (32 et 64 bits) sont déjà compilés et disponibles dans les dossiers application.windows32/ et application.windows64/
