 //  _____  _
 // |  ___|(_) _ __
 // | |_   | || '_ \
 // |  _|  | || | | |
 // |_|    |_||_| |_|
 //
class Fin {
  int     _ligne;
  int     _colonne;
  float   _millieuxFinX;
  float   _millieuxFinY;

  Fin(int ligne, int colonne){
    _ligne   = ligne;
    _colonne = colonne;
  }

  void affiche (int nbDeLignes,
                int nbDeColonnes,
                float hauteurNiveau,
                float largeurNiveau,
                PVector millieuxBoite){
    float hauteurFin  = hauteurNiveau/nbDeLignes;
    float largeurFin  = largeurNiveau/nbDeColonnes;
    _millieuxFinX     = millieuxBoite.x-largeurNiveau/2+largeurFin/2+largeurFin*_colonne;
    _millieuxFinY     = millieuxBoite.y-hauteurNiveau/2+hauteurFin/2+hauteurFin*_ligne;

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
  }

  float[] getPosPixel(){
    float[] seraRetourner = {_millieuxFinX,_millieuxFinY};
    return seraRetourner;
  }

  int[] getPosIndice(){
    int[] seraRetourner = {_colonne,_ligne};
    return seraRetourner;
  }
}
