 //  _____     _  _  _
 // | ____| __| |(_)| |_  ___  _   _  _ __
 // |  _|  / _` || || __|/ _ \| | | || '__|
 // | |___| (_| || || |_|  __/| |_| || |
 // |_____|\__,_||_| \__|\___| \__,_||_|
 //
class Editeur{
  // Herité de boite
  float       _hauteur;
  float       _largeur;
  PVector     _position;
  // Propre à l'éditeur
  int         _nombreDeLigne;
  int         _nombreDeColonne;
  int         _tempsDuNiveau;
  int         _indiceLingneCurseur = 0;
  int         _indiceColonneCurseur = 0;
  String[][]  _plateau;
  Boite[]     _variableDuNiveau = new Boite[3];

  String typeDElement = "empty";

  Editeur(PVector position, float hauteur ,float largeur){
    // passage des paramètres indispenssable
    _hauteur          =hauteur;
    _largeur          =largeur;
    _position         =position;
    // PAramètre de base de l'éditeur lors de son ouverture
    _nombreDeLigne    = 1;
    _nombreDeColonne  = 2;
    _tempsDuNiveau    = 1000;
    // Création d'un tableau minimal
    _plateau = new String[_nombreDeLigne][_nombreDeColonne];
    _plateau[0][0]="S";
    _plateau[0][1]="E";
    // Emplacement et boite pour l'affichage des variable du niveau
    _variableDuNiveau[0] = new Boite( new PVector(width*0.9,
                                                  height*0.5-3*height*0.68/8+1*height*0.68/18),
                                      height*0.68,///8,
                                      width*0.2,
                                      "VARIABLE",
                                      0,
                                      false,
                                      0);
    _variableDuNiveau[1] = new Boite( new PVector(width*0.9,
                                                  height*0.5-1*height*0.68/8+1*height*0.68/18),
                                      height*0.68,///8,
                                      width*0.2,
                                      "VARIABLE",
                                      0,
                                      false,
                                      0);
    _variableDuNiveau[2] = new Boite( new PVector(width*0.9,
                                                  height*0.5+1*height*0.68/8+1*height*0.68/18),
                                      height*0.68,///8,
                                      width*0.2,
                                      "VARIABLE",
                                      0,
                                      false,
                                      0);
  }
  // MÉTHODE D'AFFICHAGE
  void affiche(){
    coordAIndice();
    changeTaillePlateau();
    afficheGrille();
    afficheVariable();
    changeCaseValeur();
  }

  // AFFICHAGE DE LA GRILLE DE FOND
  void afficheGrille(){
    // Calcule des dimention et les emplacemenet de chaque case en fonction des
    // dimentions du plateau et de la position de l'éditaure ainsi que de ces dimentions
    float dimCasePixel = min(_largeur/_plateau[0].length,_hauteur/_plateau.length);
    PVector coinsSup = new PVector( _position.x-dimCasePixel/2*_plateau[0].length+dimCasePixel/2,
                                    _position.y-dimCasePixel/2*_plateau.length+dimCasePixel/2);
    // Parcour le plateur
    for (int cetteLigne=0; cetteLigne<_plateau.length; cetteLigne++){
      for (int cetteColonne=0; cetteColonne<_plateau[cetteLigne].length; cetteColonne++){
        if (_plateau[cetteLigne][cetteColonne]!=null){
          switch (_plateau[cetteLigne][cetteColonne]){
            //Vide
            case "0":
              noFill();
              stroke(BLANC);
              strokeWeight(2);
              rectMode(CENTER);
              textAlign(CENTER,CENTER);
              rect(coinsSup.x+cetteColonne*dimCasePixel,coinsSup.y+cetteLigne*dimCasePixel,dimCasePixel,dimCasePixel);
              break;
            // Départ
            case "S":
              strokeWeight(epaisseurDesBordures*min(height,width));
              fill(BLANC,125);
              stroke(ROUGE);
              ellipseMode(CENTER);
              circle(coinsSup.x+cetteColonne*dimCasePixel,coinsSup.y+cetteLigne*dimCasePixel,dimCasePixel*0.5);
              break;
            // fin
            case "E":
              strokeWeight(epaisseurDesBordures*min(height,width));
              float hauteurFin = dimCasePixel;
              float largeurFin = dimCasePixel;
              float _millieuxFinX = coinsSup.x+cetteColonne*dimCasePixel;
              float _millieuxFinY = coinsSup.y+cetteLigne*dimCasePixel;

              noFill();
              rectMode(CENTER);
              stroke(ROUGE,50);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.2,hauteurFin*0.2);
              stroke(ROUGE,100);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.3,hauteurFin*0.3);
              stroke(ROUGE,150);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.4,hauteurFin*0.4);
              stroke(ROUGE,200);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.5,hauteurFin*0.5);
              stroke(ROUGE,250);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.6,hauteurFin*0.6);
              break;
            // Brique
            case "W":
              float _ligne = cetteLigne;
              float _colonne = cetteColonne;
              float _nbDeLignes = _plateau.length;
              float _nbDeColonnes = _plateau[cetteLigne].length;
              float _hauteurMure = dimCasePixel;
              float _largeurMure = dimCasePixel;
              float _millieuxMureX = coinsSup.x+cetteColonne*dimCasePixel;
              float _millieuxMureY = coinsSup.y+cetteLigne*dimCasePixel;
              float espaceEntreBrique = _largeurMure*0.03;
              float briqueLigne1 = _millieuxMureY-3*_hauteurMure/8;
              float briqueLigne2 = _millieuxMureY-_hauteurMure/8;
              float briqueLigne3 = _millieuxMureY+_hauteurMure/8;
              float briqueLigne4 = _millieuxMureY+3*_hauteurMure/8;
              float briqueColonne1 = _millieuxMureX-3*_largeurMure/8-espaceEntreBrique/4;
              float briqueColonne2 = _millieuxMureX-_largeurMure/4;
              float briqueColonne3 = _millieuxMureX;
              float briqueColonne4 = _millieuxMureX+_largeurMure/4;
              float briqueColonne5 = _millieuxMureX+3*_largeurMure/8+espaceEntreBrique/4;
              float briqueHauteur =  _hauteurMure/4-espaceEntreBrique;
              float briqueLargeurComplet = _largeurMure/2-espaceEntreBrique;
              float briqueLargeurFine = _largeurMure/4-espaceEntreBrique/2;
              rectMode(CENTER);
              noStroke();
              fill(#34495e);
              rect(_millieuxMureX,_millieuxMureY,_largeurMure,_hauteurMure);
              fill(BLANC,125);
              rect(briqueColonne2,briqueLigne1,briqueLargeurComplet,briqueHauteur);//1
              rect(briqueColonne4,briqueLigne3,briqueLargeurComplet,briqueHauteur);//7
              rect(briqueColonne1,briqueLigne4,briqueLargeurFine,briqueHauteur);//8
              rect(briqueColonne5,briqueLigne4,briqueLargeurFine,briqueHauteur);//10
              fill(BLANC,90);
              rect(briqueColonne4,briqueLigne1,briqueLargeurComplet,briqueHauteur);//2
              rect(briqueColonne3,briqueLigne2,briqueLargeurComplet,briqueHauteur);//4
              rect(briqueColonne3,briqueLigne4,briqueLargeurComplet,briqueHauteur);//9
              fill(BLANC,212);
              rect(briqueColonne1,briqueLigne2,briqueLargeurFine,briqueHauteur);//3
              rect(briqueColonne5,briqueLigne2,briqueLargeurFine,briqueHauteur);//5
              rect(briqueColonne2,briqueLigne3,briqueLargeurComplet,briqueHauteur);//6
              textAlign(CENTER,CENTER);
              break;
          }
        }
        // Remplie les case sans valeur
        else{
          _plateau[cetteLigne][cetteColonne]="0";
        }
      }
    }
  }

  // ACTUALISE LE CONTENUE DES VARIABLES ET LES AFFICHES
  void afficheVariable(){
    _variableDuNiveau[0]._nom = str(_tempsDuNiveau);
    _variableDuNiveau[0].affiche();
    _variableDuNiveau[1]._nom = str(_nombreDeLigne);
    _variableDuNiveau[1].affiche();
    _variableDuNiveau[2]._nom = str(_nombreDeColonne);
    _variableDuNiveau[2].affiche();
  }
  // PARCOUR LE TABLEAU ACTUEL ET LE COPIE DANS UN TABLEAU AVEC DE NOUVELLE DIMMENTIONS
  void changeTaillePlateau (){
    if (_plateau.length != _nombreDeLigne && _nombreDeLigne > 0||_plateau[0].length != _nombreDeColonne && _nombreDeColonne>0){
      String[][] nouveauPlateau = new String[_nombreDeLigne][_nombreDeColonne];
      for (int cetteLigne=0; cetteLigne<min(_plateau.length,nouveauPlateau.length); cetteLigne++){
        for (int cetteColonne=0; cetteColonne<min(_plateau[cetteLigne].length,nouveauPlateau[cetteLigne].length); cetteColonne++){
          nouveauPlateau[cetteLigne][cetteColonne] = _plateau[cetteLigne][cetteColonne];
        }
      }

      _plateau = new String[_nombreDeLigne][_nombreDeColonne];

      for (int cetteLigne=0; cetteLigne<nouveauPlateau.length; cetteLigne++){
        for (int cetteColonne=0; cetteColonne<nouveauPlateau[cetteLigne].length; cetteColonne++){
          _plateau[cetteLigne][cetteColonne] = nouveauPlateau[cetteLigne][cetteColonne];
        }
      }
    }
  }

  // RÉCUPÈRE LE NUMÉROS DE LIGNE ET DE COLONNE DE LA OU POINT LA SOURIE
  void coordAIndice(){

    float dimCasePixel = min(_largeur/_plateau[0].length,_hauteur/_plateau.length);
    PVector coinsSup = new PVector( _position.x-dimCasePixel/2*_plateau[0].length+dimCasePixel/2,
                                    _position.y-dimCasePixel/2*_plateau.length+dimCasePixel/2);

    for (int cetteLigne=0; cetteLigne<_plateau.length; cetteLigne++){
      for (int cetteColonne=0; cetteColonne<_plateau[cetteLigne].length; cetteColonne++){
        if (mouseX> coinsSup.x+cetteColonne*dimCasePixel-dimCasePixel/2 &&
            mouseX< coinsSup.x+cetteColonne*dimCasePixel+dimCasePixel/2 ){
          _indiceColonneCurseur = cetteColonne;
        }
        if (mouseY> coinsSup.y+cetteLigne*dimCasePixel-dimCasePixel/2 &&
            mouseY< coinsSup.y+cetteLigne*dimCasePixel+dimCasePixel/2 ){
        _indiceLingneCurseur = cetteLigne;
        }
      }
    }
  }

  // CHANGE LA VALEUR D'UNE CASE SI L'ON CLIQUE DESSUS
  void changeCaseValeur(){
    float dimCasePixel = min(_largeur/_plateau[0].length,_hauteur/_plateau.length);
    PVector coinsSup = new PVector( _position.x-dimCasePixel/2*_plateau[0].length+dimCasePixel/2,
                                    _position.y-dimCasePixel/2*_plateau.length+dimCasePixel/2);
    float gauche = coinsSup.x-dimCasePixel/2;
    float droit = coinsSup.x+dimCasePixel/2+dimCasePixel*(_nombreDeColonne-1);
    float haut = coinsSup.y-dimCasePixel/2;
    float bas = coinsSup.y+dimCasePixel/2+dimCasePixel*(_nombreDeLigne-1);
    if (mouseX > gauche &&
        mouseX < droit &&
        mouseY < bas &&
        mouseY > haut &&
        mousePressed &&
        mouseButton == LEFT &&
        !popupAfficher &&
        typeDElement != "empty"){
          _plateau[_indiceLingneCurseur][_indiceColonneCurseur] = typeDElement;
    }
  }

  // CONVERTI LE TAB PLATEAU EN UN FICHIER TEXTE ET L'AJOUTEET FICHIER NIVEAU.TXT
  void enregistre(){
    println("save");
    String[] fichierNiveauAvant = loadStrings("text/niveau.txt");
    String tempsString = str(_tempsDuNiveau);
    String[] temps = {tempsString};
    fichierNiveauAvant = concat(fichierNiveauAvant, temps);
    for (int cetteLigne = 0; cetteLigne <_plateau.length ; cetteLigne++){
      String ligneEnCoursString =join(_plateau[cetteLigne]," ");
      String[] ligneEnCours = {ligneEnCoursString};
      fichierNiveauAvant = concat(fichierNiveauAvant, ligneEnCours);
    }
    int indiceDeFin = tableNiveau.length+2;
    int indiceDeNiveau = indiceDeFin-1;
    int indiceDeBouton = indiceDeNiveau-1;

    String[] fin = {"LVL "+indiceDeFin};
    fichierNiveauAvant = concat(fichierNiveauAvant, fin);

    saveStrings("text/niveau.txt", fichierNiveauAvant);

    tableTexte[1] = new Text("niveau");
    tableMenu[2].ajoutBouton(indiceDeBouton,      "level",    "Lvl "+indiceDeNiveau, indiceDeBouton);
    println(indiceDeNiveau+" "+indiceDeBouton);
    tableNiveau = (Level[])append(tableNiveau,new Level(indiceDeNiveau,
                                                        tablePage[6]._tableDeBoite[2]._positionMilieux,
                                                        tablePage[6]._tableDeBoite[2]._hauteur ,
                                                        tablePage[6]._tableDeBoite[2]._largeur));

  }

  // MET LA VALEUR DE TOUT LES CASES À 0
  void supprimer(){
    println("reset");
    for (int cetteLigne=0; cetteLigne<_plateau.length; cetteLigne++){
      for (int cetteColonne=0; cetteColonne<_plateau[cetteLigne].length; cetteColonne++){
        _plateau[cetteLigne][cetteColonne]="0";
      }
    }
  }
}
