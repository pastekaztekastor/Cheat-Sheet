 //  ____          _  _
 // | __ )   ___  (_)| |_  ___
 // |  _ \  / _ \ | || __|/ _ \
 // | |_) || (_) || || |_|  __/
 // |____/  \___/ |_| \__|\___|
 //
class Boite{
  PVector   _positionMilieux;
  float     _largeur;
  float     _hauteur;
  String    _typeDeContenu;
  int       _indiceDuContenu;
  String    _nom;
  boolean   _afficheContour;
  float     _tailleTexte;
  int       _id;


  Boite (   PVector positionMilieux,
            float hauteur,
            float largeur,
            String typeDeContenu,
            int indiceDuContenu,
            boolean afficheContour,
            int id){
    _positionMilieux   = positionMilieux;
    _largeur           = largeur;
    _hauteur           = hauteur;
    _typeDeContenu     = typeDeContenu;
    _indiceDuContenu   = indiceDuContenu;
    _afficheContour    = afficheContour;
    _tailleTexte       = tailleTexte1;
    _id                = id;
  }
  // Selectionne le type de fonction d'affichage en fonction de ce que doit contenir la boite
  void affiche(){
    afficheContour();
    switch (_typeDeContenu){
      case "TEXTE":
      afficheTexte();
      break;
      case "NIVEAU":
      afficheNiveau();
      break;
      case "MENU":
      afficheMenu();
      break;
      case "NOM":
      afficheNom();
      break;
      case "SCORE":
      afficheScore();
      break;
      case "VARIABLE":
      afficheVariable();
      break;
      case "EDITEUR":
      afficheEditeur();
    }
  }

  // LES SETTER
  void config(String typeDeContenu,int indiceDuContenu){
    _typeDeContenu    = typeDeContenu;
    _indiceDuContenu  = indiceDuContenu;
  }
  void config(String typeDeContenu,String nom){
    _typeDeContenu    = typeDeContenu;
    _nom              = nom;
  }
  void configTailleTxt(float tailleTexte){
    _tailleTexte      = tailleTexte;
  }
  void config(PVector positionMilieux, float largeur, float hauteur, String typeDeContenu){
    _positionMilieux  = positionMilieux;
    _largeur          = largeur;
    _hauteur          = hauteur;
    _typeDeContenu    = typeDeContenu;
  }

  // LES AFFICHAGE
  void afficheContour(){
    if (_afficheContour){
      stroke(ROUGE);
      fill(NOIR);
      strokeWeight(min(width,height)*epaisseurDesBordures);
      rectMode(CENTER);
      rect(_positionMilieux.x,_positionMilieux.y,_largeur,_hauteur);
    }
  }
  void afficheTexte() {
    String[] paragraphe   = tableTexte[_id].lireParagraphe("paragraphe",_indiceDuContenu);
    float startLine       = (_positionMilieux.y)-(paragraphe.length/2*entreLigneTexte);
    textAlign(CENTER, CENTER);
    fill(BLANC);
    for (int a=0; a<paragraphe.length; a++){
      textSize(_tailleTexte);
      text(paragraphe[a], _positionMilieux.x,startLine+entreLigneTexte*a);
    }
  }
  void afficheNiveau(){
    tableNiveau[niveauEnCoursDaffichage].affiche();
  }
  void afficheMenu(){
    tableMenu[_indiceDuContenu].configHauteur(_hauteur);
    tableMenu[_indiceDuContenu].configLargeur(_largeur);
    tableMenu[_indiceDuContenu].configPosition(_positionMilieux);
    tableMenu[_indiceDuContenu].affiche();
  }
  void afficheNom(){
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(_tailleTexte);
    text(_nom,_positionMilieux.x,_positionMilieux.y);
  }
  void afficheScore(){
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(_tailleTexte);
    text(str(tableNiveau[niveauEnCoursDaffichage]._score),_positionMilieux.x,_positionMilieux.y);
  }
  void afficheVariable(){
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(_tailleTexte);
    text(_nom,_positionMilieux.x,_positionMilieux.y);
  }
  void afficheEditeur(){
    editeur.affiche();
  }

  // LES ACTION
  void action(){
    if (_typeDeContenu == "MENU")  {tableMenu[_indiceDuContenu].action();}
    if (_typeDeContenu == "NIVEAU"){tableNiveau[niveauEnCoursDaffichage].action();}
    if (_typeDeContenu == "ENTRER"){entrerNom();}
  }
  void entrerNom(){
    if (keyPressed){
      switch (key){
        case ENTER:
          if (!nomDuJoueur.equals("")){
            nomDuJoueurOk = true;
            pageEnCoursDaffichage = _indiceDuContenu;
          }
          break;
        case BACKSPACE:
          if (nomDuJoueur.length()>0){
            nomDuJoueur = nomDuJoueur.substring(0, nomDuJoueur.length() - 1);
          }
          break;
        default:
          if(Character.isLetterOrDigit(key)){
            String[] nomTemporaire = new String[2];
            nomTemporaire[0] = nomDuJoueur;
            nomTemporaire[1] = str(key);
            nomDuJoueur = join(nomTemporaire, "");
            break;
          }
      }
    }
  }
}
