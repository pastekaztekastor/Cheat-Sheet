 //  _                       _
 // | |     ___ __   __ ___ | |
 // | |    / _ \\ \ / // _ \| |
 // | |___|  __/ \ V /|  __/| |
 // |_____|\___|  \_/  \___||_|
 //
class Level {
  PVector   _position;
  int       _nbDeLignes;
  int       _nbDeColonnes;
  float     _largeurCase;
  float     _hauteurCase;
  float     _largeurBoite;
  float     _hauteurBoite;

  Wall[]    _mures = new Wall[0];
  Pers      _Mathurin;
  Fin       _sortie;

  boolean   _estFini;
  int       _score;
  int       _nbCoup;
  int       _tempsMax;
  int       _tempAuLancement;

  int       _deltaVertical;
  int       _deltaHorizontal;

  Level(int numerosDeNiveau, PVector position, float hauteur, float largeur){
    // Pour le calcule du score
    int ligneDuScore        = tableTexte[1].ligneDeChaine("LVL "+str(numerosDeNiveau))+1;
    _tempsMax               = int(tableTexte[1].chaineDe(ligneDuScore, 0));
    _score                  = _tempsMax;
    _tempAuLancement        = -1;
    // Charge le contenu du niveau depuis le fichier texte.
    Text contentOfLevel     = new Text(tableTexte[1].lireParagraphe("LVL",numerosDeNiveau));
    //
    _position               = position;
    _hauteurBoite           = hauteur;
    _largeurBoite           = largeur;
    // Calcule les Lignes et colonnes depuis le fichier texte
    _nbDeLignes             = (contentOfLevel._lignesTexte.length-1);
    _nbDeColonnes           = split(contentOfLevel._lignesTexte[1], ' ').length;
    // Determine les dimentions pour que les cases soient toujours carré en fonciton des dimmentions du niveau
    if (_largeurBoite/_nbDeColonnes<_hauteurBoite/_nbDeLignes) {
      // Si elle est en paysage
      _largeurCase          = _largeurBoite;
      _hauteurCase          = _largeurBoite/_nbDeColonnes*_nbDeLignes;
    }
    else{
      // Si elle est en portrait
      _largeurCase          = _hauteurBoite/_nbDeLignes*_nbDeColonnes;
      _hauteurCase          = _hauteurBoite;
    }
    // Parcour le fichier texte.
    for (int thisLingne=0; thisLingne<_nbDeLignes;thisLingne++){
      for (int thisColonne=0;thisColonne<_nbDeColonnes;thisColonne++){
        switch (contentOfLevel.chaineDe(thisLingne+1,thisColonne)) {
          case "W":
            _mures = (Wall[])append(_mures,new Wall(thisLingne,thisColonne,_nbDeLignes,_nbDeColonnes,_hauteurCase,_largeurCase,_position));
            break;
          case "S":
            _Mathurin = new Pers(thisLingne,thisColonne,_nbDeLignes,_nbDeColonnes,_hauteurCase,_largeurCase,_position);
            break;
          case "E":
            _sortie = new Fin(thisLingne,thisColonne);
            break;
          default:
            break;
        }
      }
    }
  }

  Level(PVector position, float hauteur, float largeur){
    // Pour le calcul du score
    _tempsMax               = 0;
    _score                  = _tempsMax;
    _tempAuLancement        = -1;
    //
    _position               = position;
    _hauteurBoite           = hauteur;
    _largeurBoite           = largeur;
    // Calcule les Lignes et colonnes depuis le fichier texte
    _nbDeLignes             = 1;
    _nbDeColonnes           = 1;
    // Determine les dimentions pour que les cases soient toujours carré en fonciton des dim du niveau
    if (_largeurBoite/_nbDeColonnes<_hauteurBoite/_nbDeLignes) {
      // Si elle est en paysage
      _largeurCase          = _largeurBoite;
      _hauteurCase          = _largeurBoite/_nbDeColonnes*_nbDeLignes;
    }
    else{
      // Si elle est en portrait
      _largeurCase          = _hauteurBoite/_nbDeLignes*_nbDeColonnes;
      _hauteurCase          = _hauteurBoite;
    }
  }

  void affiche(){
    if (_tempAuLancement > 0){
      _score = _tempsMax - (uniteDeTemps-_tempAuLancement) - _nbCoup*127;
    }
    if (_tempAuLancement == -1){
      _tempAuLancement = uniteDeTemps;
    }
    if (_mures.length > 0){
      for (int a=0; a<_mures.length; a++){
        _mures[a].affiche();
      }
    }
    _sortie.affiche(_nbDeLignes, _nbDeColonnes, _hauteurCase, _largeurCase, _position);
    _Mathurin.affiche();
    afficheFin();
    if (_score <= 0){
      scoreDuJoueur -= 30;
      recharger();
    }
  }

  void action(){
    _deltaVertical = _nbDeLignes+1;
    _deltaHorizontal = _nbDeColonnes+1;
    if (keyPressed && _Mathurin.seDeplace()){
      _nbCoup ++;
      if (keyCode == UP){
        _deltaVertical = -_deltaVertical;
        for (int a=0; a<_mures.length ; a++){
          if (_mures[a].colision(_Mathurin.position())[1]<0){_deltaVertical = max(_deltaVertical,_mures[a].colision(_Mathurin.position())[1]);}
        }
        _deltaVertical ++;
        for (int a = 0; a> _deltaVertical; a--){
          if (_Mathurin.getPosIndice()[0] == _sortie.getPosIndice()[0] && _Mathurin.getPosIndice()[1]+a == _sortie.getPosIndice()[1]){
            _deltaVertical = max(_deltaVertical,a);
          }
        }
        _deltaHorizontal = 0;
      }
      if (keyCode == RIGHT){
        for (int a=0; a<_mures.length ; a++){
          if (_mures[a].colision(_Mathurin.position())[0]>0){_deltaHorizontal = min(_deltaHorizontal,_mures[a].colision(_Mathurin.position())[0]);}
        }
        _deltaHorizontal--;
        for (int a = 0; a< _deltaHorizontal; a++){
          if (_Mathurin.getPosIndice()[0]+a == _sortie.getPosIndice()[0] && _Mathurin.getPosIndice()[1] == _sortie.getPosIndice()[1]){
            _deltaHorizontal = min(_deltaHorizontal,a);
          }
        }
        _deltaVertical = 0;
      }
      if (keyCode == DOWN){
        for (int a=0; a<_mures.length ; a++){
          if (_mures[a].colision(_Mathurin.position())[1]>0){_deltaVertical = min(_deltaVertical,_mures[a].colision(_Mathurin.position())[1]);}
        }
        _deltaVertical--;
        for (int a = 0; a> _deltaVertical; a++){
          if (_Mathurin.getPosIndice()[0] == _sortie.getPosIndice()[0] && _Mathurin.getPosIndice()[1]+a == _sortie.getPosIndice()[1]){
            _deltaVertical = min(_deltaVertical,a);
          }
        }
        _deltaHorizontal = 0;
      }
      if (keyCode == LEFT){
        _deltaHorizontal = -_deltaHorizontal;
        for (int a=0; a<_mures.length ; a++){
          if (_mures[a].colision(_Mathurin.position())[0]<0){_deltaHorizontal = max(_deltaHorizontal,_mures[a].colision(_Mathurin.position())[0]);}
        }
        _deltaHorizontal++;
        for (int a = 0; a> _deltaHorizontal; a--){
          if (_Mathurin.getPosIndice()[0]+a == _sortie.getPosIndice()[0] && _Mathurin.getPosIndice()[1] == _sortie.getPosIndice()[1]){
            _deltaHorizontal = max(_deltaHorizontal,a);
          }
        }
        _deltaVertical = 0;
      }
      _Mathurin.deplace(_deltaHorizontal,_deltaVertical);
    }
  }

  void afficheFin(){
    if (_sortie.getPosPixel()[0] <= _Mathurin.getPosPixel()[0]+10 &&
        _sortie.getPosPixel()[0] >= _Mathurin.getPosPixel()[0]-10 &&
        _sortie.getPosPixel()[1] <= _Mathurin.getPosPixel()[1]+10 &&
        _sortie.getPosPixel()[1] >= _Mathurin.getPosPixel()[1]-10){
      score.config(niveauEnCoursDaffichage, _score);
      scoreDuJoueur = score.calcul();
      recharger();
      if (niveauEnCoursDaffichage == tableNiveau.length-1){
        tableMenu[2]._contenuDuMenu[niveauEnCoursDaffichage]._activer = true;
        pageEnCoursDaffichage = 1;
      }
      else{
        tableMenu[2]._contenuDuMenu[niveauEnCoursDaffichage]._activer = true;
        niveauEnCoursDaffichage++;
      }
    }
  }

  void recharger(){
    tableNiveau[niveauEnCoursDaffichage]=new Level(niveauEnCoursDaffichage+1, _position, _hauteurBoite, _largeurBoite);
  }
}
