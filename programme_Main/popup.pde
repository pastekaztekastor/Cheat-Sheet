 //  ____
 // |  _ \  ___   _ __   _   _  _ __
 // | |_) |/ _ \ | '_ \ | | | || '_ \
 // |  __/| (_) || |_) || |_| || |_) |
 // |_|    \___/ | .__/  \__,_|| .__/
 //              |_|           |_|
 //
class Popup {
  float           _positionPopupX     = width/2;
  float           _positionPopupY     = height/2;
  float           _dimentionPopupX    = width/3;
  float           _dimentionPopupY    = height*0.25;
  String[]        _texteDeLaPopup;
  boolean         _etatValidation;
  String          _texteRetourner;
  String          _variableAffecter;
  Menu            _menuPopup;
  String[]        _paragraphe;
  int             _envoieVers;
  boolean         _retour;

  // CRÉATION D'UNE POPUP EN FONCTION DU TEXTE DEDANS ET DE CE QU'ELLE FAIT COMME ACTION
  Popup(int paragraphe, int vers, String var){
    // Variable modifié par la boite de texte de la popup
    _variableAffecter     = var;
    _menuPopup            = new Menu(1,2); // Principale
    _menuPopup.ajoutBouton(0,        "POPUPBUTON",     "Back",  0);
    _menuPopup.ajoutBouton(vers,     "POPUPBUTON",     "Next",  1);
    // Page ouverte lors
    _envoieVers=vers;
    _paragraphe           = tableTexte[4].lireParagraphe("popup",paragraphe);
    _texteRetourner = "";
  }

  // AFFICHE LA POPUP
  void affiche(){
    // Contour
    rectMode(CENTER);
    fill(ROUGE,200);
    stroke(BLANC);
    rect(_positionPopupX,_positionPopupY,_dimentionPopupX,_dimentionPopupY);
    // Fenêtre de frape
    PVector positionDeLaFenetreDeFrappe = new PVector(_positionPopupX,_positionPopupY+_dimentionPopupY/6);
    rectMode(CENTER);
    fill(NOIR);
    noStroke();
    rect(positionDeLaFenetreDeFrappe.x,positionDeLaFenetreDeFrappe.y,_dimentionPopupX*0.8,_dimentionPopupY*0.2);
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(18);
    text(_texteRetourner,positionDeLaFenetreDeFrappe.x,positionDeLaFenetreDeFrappe.y);
    // Texte de la popup
    PVector positionDuTexte = new PVector(_positionPopupX,_positionPopupY-_dimentionPopupY/4);
    float startLine         = (positionDuTexte.y)-(_paragraphe.length/2*entreLigneTexte);
    textAlign(CENTER, CENTER);
    fill(BLANC);
    for (int a=0; a<_paragraphe.length; a++){
      textSize(tailleTextePopup);
      text(_paragraphe[a], positionDuTexte.x,startLine+entreLigneTexte*a);
    }
    // Menu
    _menuPopup.configHauteur(_dimentionPopupY/3);
    _menuPopup.configLargeur(_dimentionPopupX);
    _menuPopup.configPosition(new PVector(_positionPopupX,_positionPopupY+2*_dimentionPopupY/5));

    _menuPopup.affiche();

    // Déclare qu'il y a une popup d'ouvert pour ne pas afficher l'animation des boutons de la page.
    popupAfficher = true;
  }

  void action(){
    _menuPopup.configHauteur(_dimentionPopupY/3);
    _menuPopup.configLargeur(_dimentionPopupX);
    _menuPopup.configPosition(new PVector(_positionPopupX,_positionPopupY+2*_dimentionPopupY/5));
    _menuPopup.action();
    // Action de s inputs calvier.
    if (keyPressed){
      switch (key){
        case BACKSPACE:
          if (_texteRetourner.length()>0){
            _texteRetourner = _texteRetourner.substring(0, _texteRetourner.length() - 1);
          }
          break;
        case RETURN:
          tablePage[pageEnCoursDaffichage]._tableDePopup = (Popup[])shorten(tablePage[pageEnCoursDaffichage]._tableDePopup);
          popupAfficher = false;
        break;
        case ENTER:
          if (!_texteRetourner.equals("")){
            tablePage[pageEnCoursDaffichage]._tableDePopup = (Popup[])shorten(tablePage[pageEnCoursDaffichage]._tableDePopup);
            pageEnCoursDaffichage = _envoieVers;
            popupAfficher=false;
          }
        break;
        default:
          if(Character.isLetterOrDigit(key)){
            String[] nomTemporaire = new String[2];
            nomTemporaire[0] = _texteRetourner;
            nomTemporaire[1] = str(key);
            _texteRetourner = join(nomTemporaire, "");
          }
          break;
      }
      variableEdit();
    }
  }

  // MODIFIE DES VARIABLES
  void variableEdit(){
    switch (_variableAffecter){
      case "Niveau":
        nomDuJoueur = _texteRetourner;
        break;
      case "Temps":
        editeur._tempsDuNiveau =int(_texteRetourner);
        println(editeur._tempsDuNiveau);
        break;
      case "Lignes":
        editeur._nombreDeLigne = int(_texteRetourner);
        break;
      case "Colonnes":
        editeur._nombreDeColonne = int(_texteRetourner);
        break;
    }
  }
}
