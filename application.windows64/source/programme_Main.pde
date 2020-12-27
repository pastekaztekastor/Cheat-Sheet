 //  ____   _                  _           _                   _
 // / ___| | |__    ___   ___ | |_    ___ | |__    ___   __ _ | |_
 // \___ \ | '_ \  / _ \ / _ \| __|  / __|| '_ \  / _ \ / _` || __|
 //  ___) || | | ||  __/|  __/| |_  | (__ | | | ||  __/| (_| || |_
 // |____/ |_| |_| \___| \___| \__|  \___||_| |_| \___| \__,_| \__|
 //

  //    DÉCLARATION DES VARIABLES GLOBALES
final float margeDesBoite                   = 20;
final float epaisseurDesBordures            = 0.008;
final float tailleTexte1                    = min(width,height)*0.20;
final float tailleTexte2                    = min(width,height)*0.50;
final float tailleTexte3                    = min(width,height)*0.60;
final float tailleTexteBouton               = min(width,height)*0.23;
final float tailleTextePopup                = min(width,height)*0.23;
final float hauteurLigneTitrePourcent       = 0.1;
final float HauteurLigneSouTitrePourcent    = 0.2;
final float entreLigneTexte                 = 20;
//    DECLARATION DES COULEURS
final color BLANC                           = (#ecf0f1);
final color ROUGE                           = (#d35400);
final color NOIR                            = (#2c3e50);

int     pageEnCoursDaffichage               = 0;
int     niveauEnCoursDaffichage             = 0;
int     uniteDeTemps                        = 0;
String  nomDuJoueur                         = "";
boolean nomDuJoueurOk                       = false;
boolean popupAfficher                       = false;
int     scoreDuJoueur                       = 0;
String  tamponDuPopup                       = "";
Score   score;

//    DECLARATION DES TABLES D'OBJETS
Page[] tablePage                            = new Page[8];
Menu[] tableMenu                            = new Menu[8];
Text[] tableTexte                           = new Text[5];
Level[] tableNiveau                         = new Level[0];
Editeur editeur;

void setup(){
  size(1000,800);
  background(NOIR);
  PFont font;
  font = loadFont("FORCED_SQUARE-50.vlw");
  textFont(font, 30);
  //    CREATION DES OBJETS TEXTES
  tableTexte[0] = new Text("contenue");
  tableTexte[1] = new Text("niveau");
  tableTexte[2] = new Text("score");
  tableTexte[3] = new Text("nom");
  tableTexte[4] = new Text("popup");
  //    CREATION DES MENUS
  tableMenu[0] = new Menu(6,1); // Principale
                          // vers, Type,       Nom,         Position
    tableMenu[0].ajoutBouton(1,    "POPUP",    "Niveau",    0);
    tableMenu[0].ajoutBouton(4,    "PAGE",     "Édition",   1);
    tableMenu[0].ajoutBouton(2,    "PAGE",     "Score",     2);
    tableMenu[0].ajoutBouton(3,    "PAGE",     "Aide",      3);
    tableMenu[0].ajoutBouton(-1,   "PAGE",     "Quitter",   5);
    tableMenu[0].ajoutBouton(5,    "PAGE",     "Crédit",    4);
    tableMenu[0].configPopup(0,1);
  tableMenu[1] = new Menu(1,4); //Footer 1
    tableMenu[1].ajoutBouton(-1,   "PAGE",     "Quitter",   1);
    tableMenu[1].ajoutBouton(0,    "PAGE",     "Accueil",   2);
  tableMenu[3] = new Menu(1,3); //Footer game
    tableMenu[3].ajoutBouton(0,    "recharge", "Recharger", 0);
    tableMenu[3].ajoutBouton(1,    "PAGE",     "Retour",    1);
    tableMenu[3].ajoutBouton(0,    "PAGE",     "Accueil",   2);
  tableMenu[4] = new Menu(1,3); //Footer game
    tableMenu[4].ajoutBouton(0,    "PAGE",     "Retour",    1);
  tableMenu[5] = new Menu(5,1); //Coté gauche Editeur
    tableMenu[5].ajoutBouton(1,    "ETAT",     "Vide",      0);
    tableMenu[5].ajoutBouton(1,    "ETAT",     "Mure",      2);
    tableMenu[5].ajoutBouton(1,    "ETAT",     "Début",     3);
    tableMenu[5].ajoutBouton(1,    "ETAT",     "Fin",       4);
  tableMenu[6] = new Menu(6,1); //Coté Droit Editeur
    tableMenu[6].ajoutBouton(4,    "POPUP",    "Temps",     0);
    tableMenu[6].ajoutBouton(4,    "POPUP",    "Lignes",    2);
    tableMenu[6].ajoutBouton(4,    "POPUP",    "Colonnes",  4);
    tableMenu[6].configPopup(0,4);
    tableMenu[6].configPopup(1,2);
    tableMenu[6].configPopup(2,3);
  tableMenu[7] = new Menu(1,5); //Footer éditeur
    tableMenu[7].ajoutBouton(4,    "POPUP",    "Joke",   0);
    tableMenu[7].ajoutBouton(4,    "POPUP",    "Effacer",   1);
    tableMenu[7].ajoutBouton(4,    "POPUP",    "Tester",    2);
    tableMenu[7].ajoutBouton(4,    "POPUP",    "Sauver",    3);
    tableMenu[7].ajoutBouton(0,    "POPUP",    "Retour",    4);
    tableMenu[7].configPopup(0,6);
    tableMenu[7].configPopup(1,7);
    tableMenu[7].configPopup(3,8);
    tableMenu[7].configPopup(4,9);
  //    CRÉATION DES PAGES
  tablePage[0] = new Page("Accueil");
    //                      hauteur, largeur,PosX, PosY, typeDeContenu, pointeur,Identité, Contour
    tablePage[0].ajoutBoite(30,      60,     50,   15,   "TEXTE",       1,       0,        false);
    tablePage[0].ajoutBoite(10,      50,     50,   35,   "NOM",         0,       1,        false);
    tablePage[0].ajoutBoite(60,      60,     50,   70,   "MENU",        0,       2,        false);
    //                            Taille       indice de numeroDeBoite.
    tablePage[0].configTailleTxt (tailleTexte3,0);
    tablePage[0].configTailleTxt (tailleTexte2,1);
  tablePage[1] = new Page("Niveau");
    //                      hauteur, largeur,PosX, PosY, typeDeContenu, pointeur,Identité, Contour
    tablePage[1].ajoutBoite(12,      60 ,    50,   10,   "NOM",         0,       3,        true);
    tablePage[1].ajoutBoite(60,      100,    50,   50,   "MENU",        2,       4,        false);
    tablePage[1].ajoutBoite(12,      60 ,    50,   90,   "MENU",        1,       5,        true);
    tablePage[1].ajoutBoite(12,      20 ,    10,   10,   "VARIABLE",    0,       1,        true);
    tablePage[1].ajoutBoite(12,      20 ,    90,   10,   "VARIABLE",    0,       0,        true);
    //                            Taille       indice de numeroDeBoite.
    tablePage[1].configTailleTxt (tailleTexte2,0);
  tablePage[2] = new Page("Tableau d'honneur");
    //                      hauteur, largeur,PosX, PosY, typeDeContenu, pointeur,Identité, Contour
    tablePage[2].ajoutBoite(12,      60 ,    50,   10,   "NOM",         0,       0,        true);
    tablePage[2].ajoutBoite(12,      50 ,    50,   25,   "VARIABLE",    1,       0,        true);
    tablePage[2].ajoutBoite(52,      50,     40,   57,   "TEXTE",       1,       3,        false);
    tablePage[2].ajoutBoite(52,      50,     60,   57,   "TEXTE",       1,       2,        false);
    tablePage[2].ajoutBoite(12,      60 ,    50,   90,   "MENU",        1,       0,        true);
    tablePage[2].configTailleTxt (tailleTexte2,0);
    //                            Taille       indice de numeroDeBoite.
    tablePage[2].configTailleTxt (tailleTexte2,1);
  tablePage[3] = new Page("Au secoure");
    //                      hauteur, largeur,PosX, PosY, typeDeContenu, pointeur,Identité, Contour
    tablePage[3].ajoutBoite(12,      60 ,    50,   10,   "NOM",         0,       0,        true);
    tablePage[3].ajoutBoite(60,      100,    50,   50,   "TEXTE",       4,       0,        false);
    tablePage[3].ajoutBoite(12,      60 ,    50,   90,   "MENU",        1,       0,        true);
    //                            Taille       indice de numeroDeBoite.
    tablePage[3].configTailleTxt (tailleTexte2,0);
  tablePage[4] = new Page("Editeur");
    //                      hauteur, largeur,PosX, PosY, typeDeContenu, pointeur,Identité, Contour
    tablePage[4].ajoutBoite(12,     100 ,    50,   10,   "NOM",         0,       0,        true);
    tablePage[4].ajoutBoite(65,      60 ,    50,   50,   "EDITEUR",     0,       0,        false);
    tablePage[4].ajoutBoite(68,      20 ,    10,   50,   "MENU",        5,       0,        false);
    tablePage[4].ajoutBoite(68,      20 ,    90,   50,   "MENU",        6,       0,        false);
    tablePage[4].ajoutBoite(12,     100 ,    50,   90,   "MENU",        7,       0,        true);
    //                            Taille       indice de numeroDeBoite.
    tablePage[4].configTailleTxt (tailleTexte2,0);
    // Création de l'éditeur
    editeur = new Editeur(tablePage[4]._tableDeBoite[1]._positionMilieux,
                          tablePage[4]._tableDeBoite[1]._hauteur,
                          tablePage[4]._tableDeBoite[1]._largeur);
  tablePage[5] = new Page("Credit");
    //                      hauteur, largeur,PosX, PosY, typeDeContenu, pointeur,Identité, Contour
    tablePage[5].ajoutBoite(12,      60 ,    50,   10,   "NOM",         0,       0,        true);
    tablePage[5].ajoutBoite(60,      100,    50,   50,   "TEXTE",       5,       0,        false);
    tablePage[5].ajoutBoite(12,      60 ,    50,   90,   "MENU",        1,       0,        true);
    //                            Taille       indice de numeroDeBoite.
    tablePage[5].configTailleTxt (tailleTexte2,0);
  tablePage[6] = new Page("Niveau");
    //                      hauteur, largeur,PosX, PosY, typeDeContenu, pointeur,Identité, Contour
    tablePage[6].ajoutBoite(12,      60 ,    50,   10,   "NOMNIVEAU",   0,       0,        true);
    tablePage[6].ajoutBoite(12,      20 ,    90,   10,   "VARIABLE",    0,       0,        true);
    tablePage[6].ajoutBoite(60,      100,    50,   50,   "NIVEAU",      0,       0,        false);
    tablePage[6].ajoutBoite(12,      60 ,    50,   90,   "MENU",        3,       0,        true);
    tablePage[6].ajoutBoite( 6,      20 ,    10,   13,   "VARIABLE",    0,       1,        true);
    tablePage[6].ajoutBoite( 6,      20 ,    10,    7,   "SCORE",       3,       0,        true);
    // Ajoute des boutons dans le menu en fonciton du nombre de niveaux.
    tableMenu[2] = new Menu(4,4); //Choix des Niveaux
    for (int a = 0; a<tableTexte[1].compte("LVL")-1;a++){
      int indice = a+1;
      tableMenu[2].ajoutBouton(a,      "level",    "Lvl "+indice, a);
      tableNiveau = (Level[])append(tableNiveau,new Level(a+1,
                                                  tablePage[6]._tableDeBoite[2]._positionMilieux,
                                                  tablePage[6]._tableDeBoite[2]._hauteur ,
                                                  tablePage[6]._tableDeBoite[2]._largeur));
    }
    //                            Taille       indice de numeroDeBoite.
    tablePage[6].configTailleTxt (tailleTexte2,0);

  score = new Score(tableNiveau.length);
}

void draw() {
  // Acctualise l'affichage des variables
  for (int a=0; a<tablePage.length-1; a++){
    for (int b=0; b<tablePage[a]._tableDeBoite.length; b++){
      if (tablePage[a]._tableDeBoite[b]._typeDeContenu.equals("VARIABLE")){
        if (tablePage[a].idDeBoite(b, 0)){tablePage[a].actualiseVar(b,nomDuJoueur);}
        if (tablePage[a].idDeBoite(b, 1)){tablePage[a].actualiseVar(b,str(scoreDuJoueur));}
      }
    }
  }
  // Calcule de la variable temporel
  uniteDeTemps = (millis())/10;
  // Affichage des éléments de l'écran
  background(NOIR);
  tablePage[pageEnCoursDaffichage].affiche();
}
void mousePressed(){
  tablePage[pageEnCoursDaffichage].action();
}
void keyPressed(){
  tablePage[pageEnCoursDaffichage].action();
}
