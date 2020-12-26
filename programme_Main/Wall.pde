
 // __        __      _  _
 // \ \      / /__ _ | || |
 //  \ \ /\ / // _` || || |
 //   \ V  V /| (_| || || |
 //    \_/\_/  \__,_||_||_|
 //
class Wall {
  int   _ligne;
  int   _colonne;
  int   _nbDeLignes;
  int   _nbDeColonnes;
  float _hauteurMure;
  float _largeurMure;
  float _millieuxMureX;
  float _millieuxMureY;
  float _espaceEntreBrique;
  float _briqueLigne1;
  float _briqueLigne2;
  float _briqueLigne3;
  float _briqueLigne4;
  float _briqueColonne1;
  float _briqueColonne2;
  float _briqueColonne3;
  float _briqueColonne4;
  float _briqueColonne5;
  float _briqueHauteur;
  float _briqueLargeurComplet;
  float _briqueLargeurFine;

  Wall( int ligne,
        int colonne,
        int nbDeLignes,
        int nbDeColonnes,
        float hauteurNiveau,
        float largeurNiveau,
        PVector millieuxBoite){
    _ligne                = ligne;
    _colonne              = colonne;
    _nbDeLignes           = nbDeLignes;
    _nbDeColonnes         = nbDeColonnes;
    _hauteurMure          = hauteurNiveau/nbDeLignes;
    _largeurMure          = largeurNiveau/nbDeColonnes;
    _millieuxMureX        = millieuxBoite.x-largeurNiveau/2+_largeurMure/2+_largeurMure*_colonne;
    _millieuxMureY        = millieuxBoite.y-hauteurNiveau/2+_hauteurMure/2+_hauteurMure*_ligne;
    _espaceEntreBrique    = _largeurMure*0.03;
    _briqueLigne1         = _millieuxMureY-3*_hauteurMure/8;
    _briqueLigne2         = _millieuxMureY-_hauteurMure/8;
    _briqueLigne3         = _millieuxMureY+_hauteurMure/8;
    _briqueLigne4         = _millieuxMureY+3*_hauteurMure/8;
    _briqueColonne1       = _millieuxMureX-3*_largeurMure/8-_espaceEntreBrique/4;
    _briqueColonne2       = _millieuxMureX-_largeurMure/4;
    _briqueColonne3       = _millieuxMureX;
    _briqueColonne4       = _millieuxMureX+_largeurMure/4;
    _briqueColonne5       = _millieuxMureX+3*_largeurMure/8+_espaceEntreBrique/4;
    _briqueHauteur        =  _hauteurMure/4-_espaceEntreBrique;
    _briqueLargeurComplet = _largeurMure/2-_espaceEntreBrique;
    _briqueLargeurFine    = _largeurMure/4-_espaceEntreBrique/2;
  }

  void affiche(){
    rectMode(CENTER);
    noStroke();
    fill(#34495e);
    rect(_millieuxMureX,_millieuxMureY,_largeurMure,_hauteurMure);
    fill(BLANC,125);
    rect(_briqueColonne2,_briqueLigne1,_briqueLargeurComplet,_briqueHauteur);//1
    rect(_briqueColonne4,_briqueLigne3,_briqueLargeurComplet,_briqueHauteur);//7
    rect(_briqueColonne1,_briqueLigne4,_briqueLargeurFine,_briqueHauteur);//8
    rect(_briqueColonne5,_briqueLigne4,_briqueLargeurFine,_briqueHauteur);//10
    fill(BLANC,90);
    rect(_briqueColonne4,_briqueLigne1,_briqueLargeurComplet,_briqueHauteur);//2
    rect(_briqueColonne3,_briqueLigne2,_briqueLargeurComplet,_briqueHauteur);//4
    rect(_briqueColonne3,_briqueLigne4,_briqueLargeurComplet,_briqueHauteur);//9
    fill(BLANC,212);
    rect(_briqueColonne1,_briqueLigne2,_briqueLargeurFine,_briqueHauteur);//3
    rect(_briqueColonne5,_briqueLigne2,_briqueLargeurFine,_briqueHauteur);//5
    rect(_briqueColonne2,_briqueLigne3,_briqueLargeurComplet,_briqueHauteur);//6
    textAlign(CENTER,CENTER);
  }

  int[] colision (int[] coordPers){
    int deltaVertical = 0;
    int deltaHorizontal = 0;
    if (coordPers[1] == _ligne){
      deltaHorizontal = _colonne - coordPers[0];
    }
    if (coordPers[0] == _colonne ){
      deltaVertical = _ligne - coordPers[1];
    }
    int[] seraRetourner = {deltaHorizontal,deltaVertical};
    return seraRetourner;
  }
}
