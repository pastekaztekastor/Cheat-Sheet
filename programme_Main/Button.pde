 //  ____                 _
 // | __ )   ___   _   _ | |_  ___   _ __
 // |  _ \  / _ \ | | | || __|/ _ \ | '_ \
 // | |_) || (_) || |_| || |_| (_) || | | |
 // |____/  \___/  \__,_| \__|\___/ |_| |_|
 // 

class Button {
  //    RECUPERER DE MENU
  float     _HauteurMenu;
  float     _largeurMenu;
  PVector   _positionMenu;
  int       _nombreDeLignes;
  int       _nombreDeColonnes;
  //    HERITER DE MENU
  int       _nombreDeBoutons;
  //    PROPRE A BOUTON
  // Sa position
  float     _hauteurBouton;
  float     _largeurBouton;
  PVector   _positionButton;
  int       _positionDansLeMenu;
  int       _indiceColonne;
  int       _indiceLigne;
  // ce sur quoi il agit
  int       _indiceDuLien;
  String    _typeDuLien;
  String    _nom;
  // Son etat
  boolean   _activer;
  boolean   _selectionner;
  // Pour les popup
  int       _text = 1;


  // CÉER UN BOUTON SELON LES INFORMATION PASSÉES EN PARAMÈTRES
  Button(int indiceDuLien, String typeDuLien, String nom, int positionDansLeMenu){
    _indiceDuLien       = indiceDuLien;
    _typeDuLien         = typeDuLien;
    _nom                = nom;
    _positionDansLeMenu = positionDansLeMenu;
    _positionMenu       = new PVector(1,1);
    _activer            = false;
  }
  //    SETTER
  void configHauteurMenu (float hauteurMenu){
    _HauteurMenu        = hauteurMenu;
  }
  void configLargeurMenu (float largeurMenu){
    _largeurMenu        = largeurMenu;
  }
  void configPositionMenu (PVector positionMenu){
    _positionMenu       = positionMenu;
  }
  void configNbDeBoutons (int nombreDeBoutons){
    _nombreDeBoutons    = nombreDeBoutons;
  }
  void configNbDeLignesMenu (int nombreDeLignes){
    _nombreDeLignes     = nombreDeLignes;
  }
  void configNbDeColonnesMenu (int nombreDeColonnes){
    _nombreDeColonnes   = nombreDeColonnes;
  }
  void configText(int numerosDuPara){
    _text               = numerosDuPara;
  }

  // RECALCULE LES DIMENTSION LA POSITION DANS LE MENU ET LA POSITION ABSOLU EN PIXEL
  void recalculAttribut(){
    _hauteurBouton      = _HauteurMenu/_nombreDeLignes;
    _largeurBouton      = _largeurMenu/_nombreDeColonnes;
    _indiceColonne      = _positionDansLeMenu/_nombreDeColonnes;
    _indiceLigne        = _positionDansLeMenu%_nombreDeColonnes;
    _positionButton     = new PVector(
      _positionMenu.x-_largeurMenu/2+_largeurBouton*_indiceLigne  +_largeurBouton/2,
      _positionMenu.y-_HauteurMenu/2+_hauteurBouton*_indiceColonne+_hauteurBouton/2
    );
  }

  // RETOURNE TRUE SI LE BOUTON EST CLIQUÉ
  boolean estCliquer(){
    if (estSurvoler() && mousePressed && mouseButton == LEFT){
        return true;
      }
      else{
        return false;
      }
  }

  //   AFFICHE LE BOUTON
  void affiche() {
    afficheBouton();
    activer();
    if (_activer){afficheBoutonActiver();}
    if (estCliquer()){afficheBoutonCliquer();}
    if (estSurvoler()){afficheBoutonSurvoler();}
  }

  // AFFICHE LE BOUTON À SON ÉTAT STATIQUE
  void afficheBouton(){
   if (_indiceColonne<_nombreDeLignes){
      rectMode(CENTER);
      stroke(ROUGE);
      fill(NOIR);
      strokeWeight(min(width,height)*epaisseurDesBordures);
      rect( _positionButton.x,
            _positionButton.y,
            _largeurBouton-margeDesBoite,
            _hauteurBouton-margeDesBoite);
      textAlign(CENTER, CENTER);
      fill(BLANC);
      textSize(tailleTexteBouton);
      text(_nom,_positionButton.x,_positionButton.y);
   }
  }

  // AFFICHE LE BOUTON LORS DU CLIQUE
  void afficheBoutonCliquer(){
    if (_indiceColonne<_nombreDeLignes && !popupAfficher || _typeDuLien.equals("POPUPBUTON")){
      rectMode(CENTER);
      stroke(ROUGE);
      fill(BLANC);
      strokeWeight(min(width,height)*epaisseurDesBordures);
      rect( _positionButton.x,
            _positionButton.y,
            _largeurBouton-margeDesBoite,
            _hauteurBouton-margeDesBoite);
      textAlign(CENTER, CENTER);
      fill(NOIR);
      textSize(tailleTexteBouton);
      text(_nom,_positionButton.x,_positionButton.y);
    }
  }

  // AFFICHE LE BOUTON LORS DU SURVOLE
  void afficheBoutonSurvoler(){
    if (_indiceColonne<_nombreDeLignes && !popupAfficher || _typeDuLien.equals("POPUPBUTON")){
      rectMode(CENTER);
      stroke(ROUGE);
      fill(NOIR);
      strokeWeight(min(width,height)*epaisseurDesBordures);
      rect( _positionButton.x,
            _positionButton.y,
            _largeurBouton,
            _hauteurBouton);
      textAlign(CENTER, CENTER);
      fill(BLANC);

      textSize(tailleTexteBouton);
      text( _nom,
            _positionButton.x+random(-_largeurBouton*0.005,_largeurBouton*0.005),
            _positionButton.y+random(-_largeurBouton*0.005,_largeurBouton*0.005));
    }
  }

  // AFFICHE LE BOUTON QUAND IL EST ACTIVER
  // niveau fait, ou variable en cours
  void afficheBoutonActiver(){
    if (_indiceColonne<_nombreDeLignes){
      rectMode(CENTER);
      stroke(ROUGE);
      fill(ROUGE,125);
      strokeWeight(min(width,height)*epaisseurDesBordures);
      rect( _positionButton.x,
            _positionButton.y,
            _largeurBouton-margeDesBoite,
            _hauteurBouton-margeDesBoite);
      textAlign(CENTER, CENTER);
      fill(BLANC);
      textSize(tailleTexteBouton);
      text(_nom,_positionButton.x,_positionButton.y);
    }
  }

  // RETOURNE TRUE SI LE CURSEUR EST AU DESSUS DU BOUTON
  boolean estSurvoler(){
    if (mouseX> _positionButton.x-_largeurBouton/2 &&
        mouseX< _positionButton.x+_largeurBouton/2 &&
        mouseY> _positionButton.y-_hauteurBouton/2 &&
        mouseY< _positionButton.y+_hauteurBouton/2 || _selectionner){
        return true;
    }
    else{
      return false;
    }
  }

  // VÉRIFIE SI LE BOUTON DOIT ÊTRE ACTIVER DANS L'ÉDITEUR
  void activer(){
    switch (editeur.typeDElement){
      case "W":
        if (_nom.equals("Mure")){
        _activer = true;
        }
        else {_activer = false;}
        break;
      case "S":
        if (_nom.equals("Début")){
        _activer = true;
        }
        else {_activer = false;}
        break;
      case "E":
        if (_nom.equals("Fin")){
        _activer = true;
        }
        else {_activer = false;}
        break;
      case "0":
        if (_nom.equals("Vide")){
        _activer = true;
        }
        else {_activer = false;}
        break;
        default:
        break;
      }
  }

  //    ACTION AU CLIQUE
  void actionAuClique(){
    if (estCliquer()){
      if (_indiceDuLien < 0){exit();}
      switch(_typeDuLien){
      case "PAGE":
        pageEnCoursDaffichage = _indiceDuLien;
        break;
      case "level":
        niveauEnCoursDaffichage = _indiceDuLien;
        pageEnCoursDaffichage = 6;
        break;
      case "recharge":
        tableNiveau[niveauEnCoursDaffichage].recharger();
        break;
      case "ETAT":
        // Actions des bouton de l'éditeur
        switch(_nom){
          case "Mure":
            editeur.typeDElement = "W";
            break;
          case "Début":
            editeur.typeDElement = "S";
            break;
          case "Fin":
            editeur.typeDElement = "E";
            break;
          case "Vide":
            editeur.typeDElement = "0";
            break;
        }
        break;
      case "POPUP":
        // Action des bouton qui ouvre une popup
        tablePage[pageEnCoursDaffichage].addPopups(_text,_indiceDuLien,_nom);
        switch(_nom){
          case "Sauver":
            editeur.enregistre();
            break;
          case "Effacer":
            editeur.supprimer();
            break;
        }
        break;
      case "POPUPBUTON":
        // Action des boutons sur les popup.
        if (_nom.equals("Back")){
          tablePage[pageEnCoursDaffichage]._tableDePopup = (Popup[])shorten(tablePage[pageEnCoursDaffichage]._tableDePopup);
          popupAfficher = false;
        }
        if (_nom.equals("Next")){
          tablePage[pageEnCoursDaffichage]._tableDePopup = (Popup[])shorten(tablePage[pageEnCoursDaffichage]._tableDePopup);
          pageEnCoursDaffichage = _indiceDuLien;
          popupAfficher = false;
        }
      }
    }
  }
}
