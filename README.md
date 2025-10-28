# Sheet Cheat

Un jeu de labyrinthe développé en Processing où vous aidez Mathurin à trouver des antisèches dans son salon avant l'examen !

## Description

Sheet Cheat est un jeu de puzzle/maze avec une contrainte de temps. Guidez Mathurin à travers différents niveaux remplis d'obstacles pour collecter des antisèches tout en évitant les pièges. Attention au temps qui défile - si vous arrivez en retard à votre partiel, c'est 0 pointé !

### Caractéristiques

- **7 niveaux** avec difficulté progressive
- **Système de score** avec tableau d'honneur
- **Éditeur de niveaux** intégré pour créer vos propres défis
- **Contrainte de temps** pour chaque niveau
- **Obstacles variés** : murs, pièges, bonus
- **Interface intuitive** avec système de menus

## Installation

### Installation automatique (Linux/macOS)

```bash
# Rendre le script exécutable
chmod +x install.sh

# Lancer l'installation
./install.sh

# Lancer le jeu
./run.sh
```

Le script d'installation va automatiquement :
- Détecter votre système d'exploitation
- Télécharger et installer Processing 3.5.4
- Configurer le projet
- Créer un lanceur

### Exécutables Windows précompilés

Des versions standalone sont disponibles :

**Windows 64-bit :**
```bash
cd application.windows64
programme_Main.exe
```

**Windows 32-bit :**
```bash
cd application.windows32
programme_Main.exe
```

### Installation manuelle

Consultez le fichier [INSTALLATION.md](INSTALLATION.md) pour des instructions détaillées.

## Comment jouer

### Commandes

- **Flèches directionnelles** : Déplacer Mathurin
- **Souris** : Interagir avec les menus
- **Entrée** : Valider votre nom

### Règles du jeu

1. **Objectif** : Atteindre la sortie (point de fin) avant la fin du temps imparti
2. **Obstacles** :
   - Murs (bloquent le passage)
   - Chat (vous fait perdre des points)
   - Cours (vous ralentit)
3. **Bonus** :
   - Café (vous donne de l'énergie)
   - Antisèches (bonus de points)
4. **Score** : Plus vous êtes rapide, plus votre score est élevé

### Menu principal

1. **Niveau** : Choisir et jouer un niveau
2. **Édition** : Créer vos propres niveaux
3. **Score** : Consulter le tableau d'honneur
4. **Aide** : Afficher les instructions
5. **Crédit** : Voir les remerciements
6. **Quitter** : Fermer le jeu

## Éditeur de niveaux

L'éditeur intégré vous permet de créer vos propres labyrinthes :

### Fonctionnalités de l'éditeur

- **Grille personnalisable** : Définir le nombre de lignes et colonnes
- **Outils de dessin** :
  - Vide : Case libre
  - Mur : Obstacle
  - Début : Point de départ
  - Fin : Point d'arrivée
- **Temps configurable** : Définir la limite de temps du niveau
- **Test en temps réel** : Tester votre niveau avant de le sauvegarder
- **Sauvegarde** : Enregistrer vos créations

## Structure du projet

```
Cheat-Sheet/
├── programme_Main/          # Code source principal
│   ├── programme_Main.pde   # Fichier principal
│   ├── Boite.pde           # Gestion des boîtes/conteneurs
│   ├── Button.pde          # Système de boutons
│   ├── Menu.pde            # Gestion des menus
│   ├── Page.pde            # Système de pages
│   ├── Level.pde           # Logique des niveaux
│   ├── Editeur.pde         # Éditeur de niveaux
│   ├── Pers.pde            # Personnage joueur
│   ├── Wall.pde            # Murs et obstacles
│   ├── Score.pde           # Système de score
│   ├── Text.pde            # Gestion du texte
│   ├── Fin.pde             # Écran de fin
│   ├── popup.pde           # Popups
│   ├── FORCED_SQUARE-50.vlw # Police de caractères
│   └── text/               # Fichiers de données
│       ├── niveau.txt      # Définition des niveaux
│       ├── nom.txt         # Noms des pages
│       ├── contenue.txt    # Textes du jeu
│       ├── score.txt       # Scores sauvegardés
│       └── popup.txt       # Messages popup
├── application.windows32/   # Build Windows 32-bit
├── application.windows64/   # Build Windows 64-bit
├── Compte_Rendu/           # Documentation et rapport
├── install.sh              # Script d'installation
├── DEPENDENCIES.md         # Liste des dépendances
├── INSTALLATION.md         # Guide d'installation détaillé
└── README.md               # Ce fichier

```

## Développement

### Prérequis

- Processing 3.5.4 ou supérieur
- Java 8+ (inclus avec Processing)

### Lancer en mode développement

```bash
# Avec Processing IDE
processing --sketch=$(pwd)/programme_Main --run

# Ou avec le script d'installation
./run.sh
```

### Compiler le projet

Ouvrez `programme_Main/programme_Main.pde` dans Processing IDE, puis :
- **File > Export Application**
- Choisir les plateformes cibles (Windows, Linux, macOS)

## Dépendances

Le projet utilise uniquement les bibliothèques standard de Processing :

- **processing.core** - Fonctions principales
- **processing.data** - Gestion des données
- **processing.event** - Événements clavier/souris
- **processing.opengl** - Rendu graphique

Consultez [DEPENDENCIES.md](DEPENDENCIES.md) pour plus de détails.

## Architecture technique

### Système de pages

Le jeu utilise un système de pages modulaire où chaque écran est composé de "boîtes" (Boite.pde) pouvant contenir :
- Du texte
- Des menus
- Des niveaux
- L'éditeur
- Des variables dynamiques

### Gestion des niveaux

Les niveaux sont définis dans `text/niveau.txt` avec le format :
```
LVL N
[temps_limite]
[grille avec 0=vide, W=mur, S=start, E=end]
```

### Système de score

Les scores sont calculés en fonction :
- Du temps restant
- De la difficulté du niveau
- Des bonus collectés

## Captures d'écran

Consultez le dossier `Compte_Rendu/` pour voir des captures d'écran et des diagrammes du jeu.

## Crédits

**Développeur principal** : [Votre nom]

**Remerciements spéciaux** :
- Paul Leborgne - Idées et design de certains niveaux
- Ma copine - Pour tous les cafés gentiment servis
- Mon chat - Soutien moral
- Le café - Énergie et motivation
- La faculté de Limoges - Pour l'opportunité de reprendre mes études

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE.md](LICENSE.md) pour plus de détails.

## Support

Pour toute question ou problème :
1. Consultez [INSTALLATION.md](INSTALLATION.md) pour les problèmes d'installation
2. Vérifiez [DEPENDENCIES.md](DEPENDENCIES.md) pour les dépendances
3. Ouvrez une issue sur GitHub

## Notes de développement

- Version Processing : 3.5.4
- Résolution : 1000x800 pixels
- Police personnalisée : FORCED SQUARE

---

**Merci de jouer à Sheet Cheat ! Bon courage, camarade tricheur !**
