//   __  __
//  |  \/  |  ___  _ __   _   _
//  | |\/| | / _ \| '_ \ | | | |
//  | |  | ||  __/| | | || |_| |
//  |_|  |_| \___||_| |_| \__,_|
//
class Menu {
  float       _hauteur;
  float       _largeur;
  PVector     _position;
  Button[]    _contenuDuMenu = new Button[0];
  int         _nbDeLignes;
  int         _nbDeColonnes;
  // CRÉATION D'UN MENU EN FONCTION DU NOMBRE DE LIGNE ET DE COLONNE
  Menu(int nbDeLignes,int nbDeColonnes){
    _nbDeLignes   = nbDeLignes;
    _nbDeColonnes = nbDeColonnes;
  }
  // AJOUTE UN BOUTON
  // Reparamètre les variables de chaques boutons (taille et pos) en fonciton du nombre de bouton dans le menu
  void ajoutBouton( int indiceDuLien,
                  String typeDuLien,
                  String nom,
                  int positionDansLeMenu) {
    _contenuDuMenu = (Button[])append(_contenuDuMenu, new Button( indiceDuLien,
                                                                  typeDuLien,
                                                                  nom,
                                                                  positionDansLeMenu));
    for (int a=0;a<_contenuDuMenu.length;a++){
      _contenuDuMenu[a].configNbDeBoutons(_contenuDuMenu.length);
    }
  }
  // ACTION DE CHAQUE BOUTON
  void action() {
    for (int a=0;a<_contenuDuMenu.length;a++){
      // Re règles les dimentions  des boutons en fontion de la boite dans laquel ils sont
      _contenuDuMenu[a].configHauteurMenu(_hauteur);
      _contenuDuMenu[a].configLargeurMenu(_largeur);
      _contenuDuMenu[a].configPositionMenu(_position);
      _contenuDuMenu[a].configNbDeLignesMenu(_nbDeLignes);
      _contenuDuMenu[a].configNbDeColonnesMenu(_nbDeColonnes);
      // Re calcule tout les attributs d'un bouton comme lors de leur instanciation.
      _contenuDuMenu[a].recalculAttribut();
      // Action au clique
      _contenuDuMenu[a].actionAuClique();
    }
  }
  // LES MÉTHODES DE CONFIGURATION
  void configHauteur(float hauteur){
    _hauteur = hauteur-margeDesBoite;
  }
  void configLargeur(float largeur){
    _largeur = largeur-margeDesBoite;
  }
  void configPosition(PVector position){
    _position = position;
  }
  void configPopup(int indice, int paragraphe){
    _contenuDuMenu[indice].configText(paragraphe);
  }

  void affiche ( ) {
    for (int a=0;a<_contenuDuMenu.length;a++){
      // Re règles les dimentions  des boutons en fontion de la boite dans laquel il sont
      _contenuDuMenu[a].configHauteurMenu(_hauteur);
      _contenuDuMenu[a].configLargeurMenu(_largeur);
      _contenuDuMenu[a].configPositionMenu(_position);
      _contenuDuMenu[a].configNbDeLignesMenu(_nbDeLignes);
      _contenuDuMenu[a].configNbDeColonnesMenu(_nbDeColonnes);
      // Re calcule tout les attributs d'un bouton comme lors de leur instanciation.
      _contenuDuMenu[a].recalculAttribut();
      // Affiche le bouton
      _contenuDuMenu[a].affiche();
    }
  }
}
