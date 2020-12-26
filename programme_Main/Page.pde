 //  ____
 // |  _ \  __ _   __ _   ___
 // | |_) |/ _` | / _` | / _ \
 // |  __/| (_| || (_| ||  __/
 // |_|    \__,_| \__, | \___|
 //               |___/

class Page{
  Boite[]     _tableDeBoite;
  Popup[]     _tableDePopup;
  PVector     _positionMilieux;
  float       _largeur;
  float       _hauteur;
  String      _nom;

   // CONSTRUCTEUR PAR DÉFAUT
  Page(){
    _positionMilieux  = new PVector(width/2, height/2) ;
    _largeur          = width;
    _hauteur          = height;
    _tableDeBoite    = new Boite[0];
    _tableDePopup    = new Popup[0];
    _nom              = "Défaut";
  }
  // CONSTRUCTEUR PAR NOM
  Page(String nom){
    _positionMilieux  = new PVector(width/2, height/2) ;
    _largeur          = width;
    _hauteur          = height;
    _tableDeBoite    = new Boite[0];
    _tableDePopup    = new Popup[0];
    _nom              = nom;
  }

  // MÉTHODE D'AJJOUTE D'UNE BOITE
  // En passant par la méthode configBoite de cette class
  void ajoutBoite(int       hauteurBoitePrct,
                  int       largeurBoitePrct,
                  int       facteurPosX,
                  int       facteurPosY,
                  String    typeDeContenu,
                  int       pointeurDuContenu,
                  int       id,
                  boolean   afficheContour){
    _tableDeBoite = (Boite[])append( _tableDeBoite,
                                      configBoite(hauteurBoitePrct,
                                                  largeurBoitePrct,
                                                  facteurPosX,
                                                  facteurPosY,
                                                  typeDeContenu,
                                                  pointeurDuContenu,
                                                  afficheContour,
                                                  id));
    _tableDeBoite[_tableDeBoite.length-1]._nom = _nom;
  }
  // MÉTHODE D'AJOUT D'UNE POPUP
  void addPopups(int paragraphe, int vers, String var){
    _tableDePopup = (Popup[])append(_tableDePopup,new Popup(paragraphe, vers, var));
  }
  // MÉTHODE QUI RETOURNE LES PARAMÈTRE DE CRÉATION D'UNE BOITE
  // Elle convertie une position relative en pourcentage
  // en position absolu en pixel
  Boite configBoite(  int hauteurBoitePrct,
                      int largeurBoitePrct,
                      int facteurPosX,
                      int facteurPosY,
                      String typeDeContenu,
                      int pointeurDuContenu,
                      boolean afficheContour,
                      int id){
    PVector millieuxBoite = new PVector(  facteurPosX*_largeur/100,
                                          facteurPosY*_hauteur/100);
    return new Boite(
      millieuxBoite,
      _hauteur*hauteurBoitePrct/100-margeDesBoite,
      _largeur*largeurBoitePrct/100-margeDesBoite,
      typeDeContenu,
      pointeurDuContenu,
      afficheContour,
      id);
  }

  // TRANSMET LA VARIABLE GLOBAL À UNE BOITE
  void actualiseVar(int boite, String var){
    _tableDeBoite[boite].config("VARIABLE",var);
  }

  // VALIDE QUI L'ON PARLE BIEN D'UNE BOITE D'UN CERTAIN ID
  boolean idDeBoite(int boite, int id){
    if (_tableDeBoite[boite]._id==id){return true;}
    else {return false;}
  }

  // CONFIGURE LA TAILLE D'UN TEXTE D'UNE BOITE D'ONT ON À LE NUMÉROS
  void configTailleTxt(float tailleTexte, int numeroDeBoite){
    _tableDeBoite[numeroDeBoite].configTailleTxt(tailleTexte);
  }

  // AFFICHE LA TOTALITÉ DE CE QUE CONTIENT LA PAGE
  void affiche(){
    if (_tableDeBoite.length>0){
      for (int iteration=0;iteration<_tableDeBoite.length;iteration++){
        _tableDeBoite[iteration].affiche();
      }
    }
    if (_tableDePopup.length>0){
      for (int a=0; a<_tableDePopup.length; a++){
        _tableDePopup[a].affiche();
      }
    }
  }

  // COMPORTEMENT LORS D'UN INPUT UTILISATEUR
  void action(){
    // SI IL N'Y A PAS DE POPUP
    if (_tableDePopup.length==0){
      if (_tableDeBoite.length>0){
        for (int iteration=0;iteration<_tableDeBoite.length;iteration++){
          _tableDeBoite[iteration].action();
        }
      }
    }
    // SI UNE POPUP EST OUVERTE
    for (int a=0; a<_tableDePopup.length; a++){
      _tableDePopup[a].action();
    }
  }
}
