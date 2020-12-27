 //  ____
 // |  _ \  ___  _ __  ___   ___   _ __   _ __    __ _   __ _   ___
 // | |_) |/ _ \| '__|/ __| / _ \ | '_ \ | '_ \  / _` | / _` | / _ \
 // |  __/|  __/| |   \__ \| (_) || | | || | | || (_| || (_| ||  __/
 // |_|    \___||_|   |___/ \___/ |_| |_||_| |_| \__,_| \__, | \___|
 //                                                     |___/
class Pers {
  // attribut hérité de level
  int     _colonne;
  int     _ligne;
  int     _colonneMax;
  int     _ligneMax;
  float   _largeurNiveau;
  float   _hauteurNiveau;
  PVector _millieuxBoite;
  // attribut conditionnel comme les positions en déplacement ou celle de départ
  int     _ligneDepart;
  int     _colonneDepart;
  float   _millieuxPersXDepart;
  float   _millieuxPersYDepart;
  float   _millieuxPersXFinal;
  float   _millieuxPersYFinal;
  // attribut propre à la class
  float   _hauteurPers;
  float   _largeurPers;
  float   _millieuxPersX;
  float   _millieuxPersY;
  // Constantes de config
  int     _vitesseParCase;
  int     _vitesse;
  int     _incrementationVitesse;
  int     _tempsAffichage;

  Pers( int ligne,
        int colonne,
        int nbDeLignes,
        int nbDeColonnes,
        float hauteurNiveau,
        float largeurNiveau,
        PVector millieuxBoite){
    // Paramètre les atributs hérité de level
    _colonne                = colonne;
    _ligne                  = ligne;
    _colonneMax             = nbDeColonnes;
    _ligneMax               = nbDeLignes;
    _largeurNiveau          = largeurNiveau;
    _hauteurNiveau          = hauteurNiveau;
    _millieuxBoite          = millieuxBoite;
    // calcule les attributs propre
    _hauteurPers            = _hauteurNiveau/_ligneMax;
    _largeurPers            = _largeurNiveau/_colonneMax;
    _millieuxPersX          = indiceACoord(_colonne,_ligne)[0];
    _millieuxPersY          = indiceACoord(_colonne,_ligne)[1];
    _vitesseParCase         = 5;
    // set les attributs conditionnel comme les positions en déplacement ou celle de départ
    _ligneDepart            = _ligne;
    _colonneDepart          = _colonne;
    _millieuxPersXDepart    = _millieuxPersX;
    _millieuxPersYDepart    = _millieuxPersY;
    _millieuxPersXFinal     = _millieuxPersX;
    _millieuxPersYFinal     = _millieuxPersY;
  }

  void affiche (){
    // Calcule de la position pour le "glissement"
    if(millis()-_tempsAffichage>1 && _incrementationVitesse<_vitesse){
      _incrementationVitesse++;
      _millieuxPersX = lerp(_millieuxPersXDepart,_millieuxPersXFinal,_incrementationVitesse/float(_vitesse));
      _millieuxPersY = lerp(_millieuxPersYDepart,_millieuxPersYFinal,_incrementationVitesse/float(_vitesse));
      _tempsAffichage=millis();
    }
    fill(BLANC,125);
    stroke(ROUGE);
    ellipseMode(CENTER);
    circle(_millieuxPersX,_millieuxPersY,_largeurPers*0.5);
    partAuLoing();
  }
  void deplace(int deltaColonne, int deltaLigne){
      _tempsAffichage       =millis();
      _millieuxPersX        = indiceACoord(_colonne,_ligne)[0];
      _millieuxPersY        = indiceACoord(_colonne,_ligne)[1];
      // Calcule des positions de départ et d'arrivé.
      _millieuxPersXDepart  = _millieuxPersX;
      _millieuxPersYDepart  = _millieuxPersY;
      _millieuxPersXFinal   = _millieuxPersX+_largeurPers*deltaColonne;
      _millieuxPersYFinal   = _millieuxPersY+_hauteurPers*deltaLigne;

      _incrementationVitesse = 0;
      _vitesse              = _vitesseParCase*(max(abs(deltaLigne),abs(deltaColonne)));
      _ligne               += deltaLigne;
      _colonne             += deltaColonne;
  }
  void partAuLoing(){
    if (_millieuxPersX <= _millieuxBoite.x-_largeurNiveau/2||
        _millieuxPersX >= _millieuxBoite.x+_largeurNiveau/2||
        _millieuxPersY <= _millieuxBoite.y-_hauteurNiveau/2||
        _millieuxPersY >= _millieuxBoite.y+_hauteurNiveau/2){
      // Réinitialise les valeurs de lignes et colonnes ainsi que les positions
      _ligne                = _ligneDepart;
      _colonne              = _colonneDepart;
      _millieuxPersX        = indiceACoord(_colonne,_ligne)[0];
      _millieuxPersY        = indiceACoord(_colonne,_ligne)[1];
      _millieuxPersXDepart  = indiceACoord(_colonne,_ligne)[0];
      _millieuxPersYDepart  = indiceACoord(_colonne,_ligne)[1];
      _millieuxPersXFinal   = indiceACoord(_colonne,_ligne)[0];
      _millieuxPersYFinal   = indiceACoord(_colonne,_ligne)[1];
    }
  }
  // Retourne une table de coordonnée [PosX, PosY] en f de la ligne et de la colonne.
  float[] indiceACoord(int colonne, int ligne){
    float posX              = _millieuxBoite.x-_largeurNiveau/2+
                              _largeurPers/2+_largeurPers*colonne;
    float posY              = _millieuxBoite.y-_hauteurNiveau/2+
                              _hauteurPers/2+_hauteurPers*ligne;
    float[] seraRetourner   = {posX, posY};
    return seraRetourner;
  }
  // Retourne une table de [colonne, ligne]
  int[] position(){
    int[] seraRetourner     = {_colonne, _ligne};
    return seraRetourner;
  }
  // Retourne une table de coordoné [X, Y] de la position acctuel du personnage
  float[] getPosPixel(){
    float[] seraRetourner   = {_millieuxPersX,_millieuxPersY};
    return seraRetourner;
  }
  // Retourne une table [Colonne, ligne] de la position final du personnage
  int[] getPosIndice(){
    int[] seraRetourner     = {_colonne,_ligne};
    return seraRetourner;
  }
  // retourne true si le personnage et à la position où il doit être à la fin de son glissement.
  boolean seDeplace(){
    if (_millieuxPersXFinal == _millieuxPersX && _millieuxPersYFinal == _millieuxPersY){
      return true ;
    }
    else{
      return false ;
    }
  }
}
