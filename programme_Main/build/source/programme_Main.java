import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class programme_Main extends PApplet {

 //  ____   _                  _           _                   _
 // / ___| | |__    ___   ___ | |_    ___ | |__    ___   __ _ | |_
 // \___ \ | '_ \  / _ \ / _ \| __|  / __|| '_ \  / _ \ / _` || __|
 //  ___) || | | ||  __/|  __/| |_  | (__ | | | ||  __/| (_| || |_
 // |____/ |_| |_| \___| \___| \__|  \___||_| |_| \___| \__,_| \__|
 //

  //    DÉCLARATION DES VARIABLES GLOBALES
final float margeDesBoite                   = 20;
final float epaisseurDesBordures            = 0.008f;
final float tailleTexte1                    = min(width,height)*0.20f;
final float tailleTexte2                    = min(width,height)*0.50f;
final float tailleTexte3                    = min(width,height)*0.60f;
final float tailleTexteBouton               = min(width,height)*0.23f;
final float tailleTextePopup                = min(width,height)*0.23f;
final float hauteurLigneTitrePourcent       = 0.1f;
final float HauteurLigneSouTitrePourcent    = 0.2f;
final float entreLigneTexte                 = 20;
//    DECLARATION DES COULEURS
final int BLANC                           = (0xffecf0f1);
final int ROUGE                           = (0xffd35400);
final int NOIR                            = (0xff2c3e50);

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

public void setup(){
  
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

public void draw() {
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
public void mousePressed(){
  tablePage[pageEnCoursDaffichage].action();
}
public void keyPressed(){
  tablePage[pageEnCoursDaffichage].action();
}
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
  public void affiche(){
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
      case "NOMNIVEAU":
      afficheNomNiveau();
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

  // LES SETTERS
  public void config(String typeDeContenu,int indiceDuContenu){
    _typeDeContenu    = typeDeContenu;
    _indiceDuContenu  = indiceDuContenu;
  }
  public void config(String typeDeContenu,String nom){
    _typeDeContenu    = typeDeContenu;
    _nom              = nom;
  }
  public void configTailleTxt(float tailleTexte){
    _tailleTexte      = tailleTexte;
  }
  public void config(PVector positionMilieux, float largeur, float hauteur, String typeDeContenu){
    _positionMilieux  = positionMilieux;
    _largeur          = largeur;
    _hauteur          = hauteur;
    _typeDeContenu    = typeDeContenu;
  }

  // LES AFFICHAGES
  public void afficheContour(){
    if (_afficheContour){
      stroke(ROUGE);
      fill(NOIR);
      strokeWeight(min(width,height)*epaisseurDesBordures);
      rectMode(CENTER);
      rect(_positionMilieux.x,_positionMilieux.y,_largeur,_hauteur);
    }
  }
  public void afficheTexte() {
    String[] paragraphe   = tableTexte[_id].lireParagraphe("paragraphe",_indiceDuContenu);
    float startLine       = (_positionMilieux.y)-(paragraphe.length/2*entreLigneTexte);
    textAlign(CENTER, CENTER);
    fill(BLANC);
    for (int a=0; a<paragraphe.length; a++){
      textSize(_tailleTexte);
      text(paragraphe[a], _positionMilieux.x,startLine+entreLigneTexte*a);
    }
  }
  public void afficheNiveau(){
    tableNiveau[niveauEnCoursDaffichage].affiche();
  }
  public void afficheMenu(){
    tableMenu[_indiceDuContenu].configHauteur(_hauteur);
    tableMenu[_indiceDuContenu].configLargeur(_largeur);
    tableMenu[_indiceDuContenu].configPosition(_positionMilieux);
    tableMenu[_indiceDuContenu].affiche();
  }
  public void afficheNom(){
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(_tailleTexte);
    text(_nom,_positionMilieux.x,_positionMilieux.y);
  }
  public void afficheNomNiveau(){
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(_tailleTexte);
    int numeroDuNiveau = niveauEnCoursDaffichage+1;
    text(_nom+" "+numeroDuNiveau,_positionMilieux.x,_positionMilieux.y);
  }
  public void afficheScore(){
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(_tailleTexte);
    text(str(tableNiveau[niveauEnCoursDaffichage]._score),_positionMilieux.x,_positionMilieux.y);
  }
  public void afficheVariable(){
    textAlign(CENTER, CENTER);
    fill(BLANC);
    textSize(_tailleTexte);
    text(_nom,_positionMilieux.x,_positionMilieux.y);
  }
  public void afficheEditeur(){
    editeur.affiche();
  }

  // LES ACTIONS
  public void action(){
    if (_typeDeContenu == "MENU")  {tableMenu[_indiceDuContenu].action();}
    if (_typeDeContenu == "NIVEAU"){tableNiveau[niveauEnCoursDaffichage].action();}
    if (_typeDeContenu == "ENTRER"){entrerNom();}
  }
  public void entrerNom(){
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
  //    HÉRITÉ DE MENU
  int       _nombreDeBoutons;
  //    PROPRE À BOUTON
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
  // Pour les popups
  int       _text = 1;


  // CÉER UN BOUTON SELON LES INFORMATIONS PASSÉES EN PARAMÈTRES
  Button(int indiceDuLien, String typeDuLien, String nom, int positionDansLeMenu){
    _indiceDuLien       = indiceDuLien;
    _typeDuLien         = typeDuLien;
    _nom                = nom;
    _positionDansLeMenu = positionDansLeMenu;
    _positionMenu       = new PVector(1,1);
    _activer            = false;
  }
  //    SETTERS
  public void configHauteurMenu (float hauteurMenu){
    _HauteurMenu        = hauteurMenu;
  }
  public void configLargeurMenu (float largeurMenu){
    _largeurMenu        = largeurMenu;
  }
  public void configPositionMenu (PVector positionMenu){
    _positionMenu       = positionMenu;
  }
  public void configNbDeBoutons (int nombreDeBoutons){
    _nombreDeBoutons    = nombreDeBoutons;
  }
  public void configNbDeLignesMenu (int nombreDeLignes){
    _nombreDeLignes     = nombreDeLignes;
  }
  public void configNbDeColonnesMenu (int nombreDeColonnes){
    _nombreDeColonnes   = nombreDeColonnes;
  }
  public void configText(int numerosDuPara){
    _text               = numerosDuPara;
  }

  // RECALCULE LES DIMENTSIONS LA POSITION DANS LE MENU ET LA POSITION ABSOLU EN PIXEL
  public void recalculAttribut(){
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
  public boolean estCliquer(){
    if (estSurvoler() && mousePressed && mouseButton == LEFT){
        return true;
      }
      else{
        return false;
      }
  }

  //   AFFICHE LE BOUTON
  public void affiche() {
    afficheBouton();
    activer();
    if (_activer){afficheBoutonActiver();}
    if (estCliquer()){afficheBoutonCliquer();}
    if (estSurvoler()){afficheBoutonSurvoler();}
  }

  // AFFICHE LE BOUTON À SON ÉTAT STATIQUE
  public void afficheBouton(){
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
  public void afficheBoutonCliquer(){
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
  public void afficheBoutonSurvoler(){
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
            _positionButton.x+random(-_largeurBouton*0.005f,_largeurBouton*0.005f),
            _positionButton.y+random(-_largeurBouton*0.005f,_largeurBouton*0.005f));
    }
  }

  // AFFICHE LE BOUTON QUAND IL EST ACTIVÉ
  // niveau fait, ou variable en cours
  public void afficheBoutonActiver(){
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
  public boolean estSurvoler(){
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

  // VÉRIFIE SI LE BOUTON DOIT ÊTRE ACTIVÉ DANS L'ÉDITEUR
  public void activer(){
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
  public void actionAuClique(){
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
 //  _____     _  _  _
 // | ____| __| |(_)| |_  ___  _   _  _ __
 // |  _|  / _` || || __|/ _ \| | | || '__|
 // | |___| (_| || || |_|  __/| |_| || |
 // |_____|\__,_||_| \__|\___| \__,_||_|
 //
class Editeur{
  // Herité de boite
  float       _hauteur;
  float       _largeur;
  PVector     _position;
  // Propre à l'éditeur
  int         _nombreDeLigne;
  int         _nombreDeColonne;
  int         _tempsDuNiveau;
  int         _indiceLingneCurseur = 0;
  int         _indiceColonneCurseur = 0;
  String[][]  _plateau;
  Boite[]     _variableDuNiveau = new Boite[3];

  String typeDElement = "empty";

  Editeur(PVector position, float hauteur ,float largeur){
    // passage des paramètres indispenssable
    _hauteur          =hauteur;
    _largeur          =largeur;
    _position         =position;
    // Paramètre de base de l'éditeur lors de son ouverture
    _nombreDeLigne    = 1;
    _nombreDeColonne  = 2;
    _tempsDuNiveau    = 1000;
    // Création d'un tableau minimal
    _plateau = new String[_nombreDeLigne][_nombreDeColonne];
    _plateau[0][0]="S";
    _plateau[0][1]="E";
    // Emplacement et boite pour l'affichage des variables du niveau
    _variableDuNiveau[0] = new Boite( new PVector(width*0.9f,
                                                  height*0.5f-3*height*0.68f/8+1*height*0.68f/18),
                                      height*0.68f,///8,
                                      width*0.2f,
                                      "VARIABLE",
                                      0,
                                      false,
                                      0);
    _variableDuNiveau[1] = new Boite( new PVector(width*0.9f,
                                                  height*0.5f-1*height*0.68f/8+1*height*0.68f/18),
                                      height*0.68f,///8,
                                      width*0.2f,
                                      "VARIABLE",
                                      0,
                                      false,
                                      0);
    _variableDuNiveau[2] = new Boite( new PVector(width*0.9f,
                                                  height*0.5f+1*height*0.68f/8+1*height*0.68f/18),
                                      height*0.68f,///8,
                                      width*0.2f,
                                      "VARIABLE",
                                      0,
                                      false,
                                      0);
  }
  // MÉTHODE D'AFFICHAGE
  public void affiche(){
    coordAIndice();
    changeTaillePlateau();
    afficheGrille();
    afficheVariable();
    changeCaseValeur();
  }

  // AFFICHAGE DE LA GRILLE DE FOND
  public void afficheGrille(){
    // Calcule des dimentions et les emplacements de chaque case en fonction des
    // dimentions du plateau et de la position de l'éditeur ainsi que de ces dimentions
    float dimCasePixel = min(_largeur/_plateau[0].length,_hauteur/_plateau.length);
    PVector coinsSup = new PVector( _position.x-dimCasePixel/2*_plateau[0].length+dimCasePixel/2,
                                    _position.y-dimCasePixel/2*_plateau.length+dimCasePixel/2);
    // Parcour le plateau
    for (int cetteLigne=0; cetteLigne<_plateau.length; cetteLigne++){
      for (int cetteColonne=0; cetteColonne<_plateau[cetteLigne].length; cetteColonne++){
        if (_plateau[cetteLigne][cetteColonne]!=null){
          switch (_plateau[cetteLigne][cetteColonne]){
            //Vide
            case "0":
              noFill();
              stroke(BLANC);
              strokeWeight(2);
              rectMode(CENTER);
              textAlign(CENTER,CENTER);
              rect(coinsSup.x+cetteColonne*dimCasePixel,coinsSup.y+cetteLigne*dimCasePixel,dimCasePixel,dimCasePixel);
              break;
            // Départ
            case "S":
              strokeWeight(epaisseurDesBordures*min(height,width));
              fill(BLANC,125);
              stroke(ROUGE);
              ellipseMode(CENTER);
              circle(coinsSup.x+cetteColonne*dimCasePixel,coinsSup.y+cetteLigne*dimCasePixel,dimCasePixel*0.5f);
              break;
            // fin
            case "E":
              strokeWeight(epaisseurDesBordures*min(height,width));
              float hauteurFin = dimCasePixel;
              float largeurFin = dimCasePixel;
              float _millieuxFinX = coinsSup.x+cetteColonne*dimCasePixel;
              float _millieuxFinY = coinsSup.y+cetteLigne*dimCasePixel;

              noFill();
              rectMode(CENTER);
              stroke(ROUGE,50);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.2f,hauteurFin*0.2f);
              stroke(ROUGE,100);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.3f,hauteurFin*0.3f);
              stroke(ROUGE,150);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.4f,hauteurFin*0.4f);
              stroke(ROUGE,200);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.5f,hauteurFin*0.5f);
              stroke(ROUGE,250);
              rect(_millieuxFinX,_millieuxFinY,largeurFin*0.6f,hauteurFin*0.6f);
              break;
            // Brique
            case "W":
              float _ligne = cetteLigne;
              float _colonne = cetteColonne;
              float _nbDeLignes = _plateau.length;
              float _nbDeColonnes = _plateau[cetteLigne].length;
              float _hauteurMure = dimCasePixel;
              float _largeurMure = dimCasePixel;
              float _millieuxMureX = coinsSup.x+cetteColonne*dimCasePixel;
              float _millieuxMureY = coinsSup.y+cetteLigne*dimCasePixel;
              float espaceEntreBrique = _largeurMure*0.03f;
              float briqueLigne1 = _millieuxMureY-3*_hauteurMure/8;
              float briqueLigne2 = _millieuxMureY-_hauteurMure/8;
              float briqueLigne3 = _millieuxMureY+_hauteurMure/8;
              float briqueLigne4 = _millieuxMureY+3*_hauteurMure/8;
              float briqueColonne1 = _millieuxMureX-3*_largeurMure/8-espaceEntreBrique/4;
              float briqueColonne2 = _millieuxMureX-_largeurMure/4;
              float briqueColonne3 = _millieuxMureX;
              float briqueColonne4 = _millieuxMureX+_largeurMure/4;
              float briqueColonne5 = _millieuxMureX+3*_largeurMure/8+espaceEntreBrique/4;
              float briqueHauteur =  _hauteurMure/4-espaceEntreBrique;
              float briqueLargeurComplet = _largeurMure/2-espaceEntreBrique;
              float briqueLargeurFine = _largeurMure/4-espaceEntreBrique/2;
              rectMode(CENTER);
              noStroke();
              fill(0xff34495e);
              rect(_millieuxMureX,_millieuxMureY,_largeurMure,_hauteurMure);
              fill(BLANC,125);
              rect(briqueColonne2,briqueLigne1,briqueLargeurComplet,briqueHauteur);//1
              rect(briqueColonne4,briqueLigne3,briqueLargeurComplet,briqueHauteur);//7
              rect(briqueColonne1,briqueLigne4,briqueLargeurFine,briqueHauteur);//8
              rect(briqueColonne5,briqueLigne4,briqueLargeurFine,briqueHauteur);//10
              fill(BLANC,90);
              rect(briqueColonne4,briqueLigne1,briqueLargeurComplet,briqueHauteur);//2
              rect(briqueColonne3,briqueLigne2,briqueLargeurComplet,briqueHauteur);//4
              rect(briqueColonne3,briqueLigne4,briqueLargeurComplet,briqueHauteur);//9
              fill(BLANC,212);
              rect(briqueColonne1,briqueLigne2,briqueLargeurFine,briqueHauteur);//3
              rect(briqueColonne5,briqueLigne2,briqueLargeurFine,briqueHauteur);//5
              rect(briqueColonne2,briqueLigne3,briqueLargeurComplet,briqueHauteur);//6
              textAlign(CENTER,CENTER);
              break;
          }
        }
        // Remplie les cases sans valeur
        else{
          _plateau[cetteLigne][cetteColonne]="0";
        }
      }
    }
  }

  // ACTUALISE LE CONTENUE DES VARIABLES ET LES AFFICHE
  public void afficheVariable(){
    _variableDuNiveau[0]._nom = str(_tempsDuNiveau);
    _variableDuNiveau[0].affiche();
    _variableDuNiveau[1]._nom = str(_nombreDeLigne);
    _variableDuNiveau[1].affiche();
    _variableDuNiveau[2]._nom = str(_nombreDeColonne);
    _variableDuNiveau[2].affiche();
  }
  // PARCOUR LE TABLEAU ACTUEL ET LE COPIE DANS UN TABLEAU AVEC DE NOUVELLE DIMMENTIONS
  public void changeTaillePlateau (){
    if (_plateau.length != _nombreDeLigne && _nombreDeLigne > 0||_plateau[0].length != _nombreDeColonne && _nombreDeColonne>0){
      String[][] nouveauPlateau = new String[_nombreDeLigne][_nombreDeColonne];
      for (int cetteLigne=0; cetteLigne<min(_plateau.length,nouveauPlateau.length); cetteLigne++){
        for (int cetteColonne=0; cetteColonne<min(_plateau[cetteLigne].length,nouveauPlateau[cetteLigne].length); cetteColonne++){
          nouveauPlateau[cetteLigne][cetteColonne] = _plateau[cetteLigne][cetteColonne];
        }
      }

      _plateau = new String[_nombreDeLigne][_nombreDeColonne];

      for (int cetteLigne=0; cetteLigne<nouveauPlateau.length; cetteLigne++){
        for (int cetteColonne=0; cetteColonne<nouveauPlateau[cetteLigne].length; cetteColonne++){
          _plateau[cetteLigne][cetteColonne] = nouveauPlateau[cetteLigne][cetteColonne];
        }
      }
    }
  }

  // RÉCUPÈRE LE NUMÉRO DE LIGNE ET DE COLONNE DE LA OU POINTE LA SOURIE
  public void coordAIndice(){

    float dimCasePixel = min(_largeur/_plateau[0].length,_hauteur/_plateau.length);
    PVector coinsSup = new PVector( _position.x-dimCasePixel/2*_plateau[0].length+dimCasePixel/2,
                                    _position.y-dimCasePixel/2*_plateau.length+dimCasePixel/2);

    for (int cetteLigne=0; cetteLigne<_plateau.length; cetteLigne++){
      for (int cetteColonne=0; cetteColonne<_plateau[cetteLigne].length; cetteColonne++){
        if (mouseX> coinsSup.x+cetteColonne*dimCasePixel-dimCasePixel/2 &&
            mouseX< coinsSup.x+cetteColonne*dimCasePixel+dimCasePixel/2 ){
          _indiceColonneCurseur = cetteColonne;
        }
        if (mouseY> coinsSup.y+cetteLigne*dimCasePixel-dimCasePixel/2 &&
            mouseY< coinsSup.y+cetteLigne*dimCasePixel+dimCasePixel/2 ){
        _indiceLingneCurseur = cetteLigne;
        }
      }
    }
  }

  // CHANGE LA VALEUR D'UNE CASE SI L'ON CLIQUE DESSUS
  public void changeCaseValeur(){
    float dimCasePixel = min(_largeur/_plateau[0].length,_hauteur/_plateau.length);
    PVector coinsSup = new PVector( _position.x-dimCasePixel/2*_plateau[0].length+dimCasePixel/2,
                                    _position.y-dimCasePixel/2*_plateau.length+dimCasePixel/2);
    float gauche = coinsSup.x-dimCasePixel/2;
    float droit = coinsSup.x+dimCasePixel/2+dimCasePixel*(_nombreDeColonne-1);
    float haut = coinsSup.y-dimCasePixel/2;
    float bas = coinsSup.y+dimCasePixel/2+dimCasePixel*(_nombreDeLigne-1);
    if (mouseX > gauche &&
        mouseX < droit &&
        mouseY < bas &&
        mouseY > haut &&
        mousePressed &&
        mouseButton == LEFT &&
        !popupAfficher &&
        typeDElement != "empty"){
          _plateau[_indiceLingneCurseur][_indiceColonneCurseur] = typeDElement;
    }
  }

  // CONVERTI LE TAB PLATEAU EN UN FICHIER TEXTE ET L'AJOUTE AU FICHIER NIVEAU.TXT
  public void enregistre(){
    println("save");
    String[] fichierNiveauAvant = loadStrings("text/niveau.txt");
    String tempsString = str(_tempsDuNiveau);
    String[] temps = {tempsString};
    fichierNiveauAvant = concat(fichierNiveauAvant, temps);
    for (int cetteLigne = 0; cetteLigne <_plateau.length ; cetteLigne++){
      String ligneEnCoursString =join(_plateau[cetteLigne]," ");
      String[] ligneEnCours = {ligneEnCoursString};
      fichierNiveauAvant = concat(fichierNiveauAvant, ligneEnCours);
    }
    int indiceDeFin = tableNiveau.length+2;
    int indiceDeNiveau = indiceDeFin-1;
    int indiceDeBouton = indiceDeNiveau-1;

    String[] fin = {"LVL "+indiceDeFin};
    fichierNiveauAvant = concat(fichierNiveauAvant, fin);

    saveStrings("text/niveau.txt", fichierNiveauAvant);

    tableTexte[1] = new Text("niveau");
    tableMenu[2].ajoutBouton(indiceDeBouton,      "level",    "Lvl "+indiceDeNiveau, indiceDeBouton);
    println(indiceDeNiveau+" "+indiceDeBouton);
    tableNiveau = (Level[])append(tableNiveau,new Level(indiceDeNiveau,
                                                        tablePage[6]._tableDeBoite[2]._positionMilieux,
                                                        tablePage[6]._tableDeBoite[2]._hauteur ,
                                                        tablePage[6]._tableDeBoite[2]._largeur));

  }

  // MET LA VALEUR DE TOUT LES CASES À 0
  public void supprimer(){
    println("reset");
    for (int cetteLigne=0; cetteLigne<_plateau.length; cetteLigne++){
      for (int cetteColonne=0; cetteColonne<_plateau[cetteLigne].length; cetteColonne++){
        _plateau[cetteLigne][cetteColonne]="0";
      }
    }
  }
}
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

  public void affiche (int nbDeLignes,
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
    rect(_millieuxFinX,_millieuxFinY,largeurFin*0.2f,hauteurFin*0.2f);
    stroke(ROUGE,100);
    rect(_millieuxFinX,_millieuxFinY,largeurFin*0.3f,hauteurFin*0.3f);
    stroke(ROUGE,150);
    rect(_millieuxFinX,_millieuxFinY,largeurFin*0.4f,hauteurFin*0.4f);
    stroke(ROUGE,200);
    rect(_millieuxFinX,_millieuxFinY,largeurFin*0.5f,hauteurFin*0.5f);
    stroke(ROUGE,250);
    rect(_millieuxFinX,_millieuxFinY,largeurFin*0.6f,hauteurFin*0.6f);
  }

  public float[] getPosPixel(){
    float[] seraRetourner = {_millieuxFinX,_millieuxFinY};
    return seraRetourner;
  }

  public int[] getPosIndice(){
    int[] seraRetourner = {_colonne,_ligne};
    return seraRetourner;
  }
}
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
    _tempsMax               = PApplet.parseInt(tableTexte[1].chaineDe(ligneDuScore, 0));
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

  public void affiche(){
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

  public void action(){
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

  public void afficheFin(){
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

  public void recharger(){
    tableNiveau[niveauEnCoursDaffichage]=new Level(niveauEnCoursDaffichage+1, _position, _hauteurBoite, _largeurBoite);
  }
}
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
  public void ajoutBouton( int indiceDuLien,
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
  public void action() {
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
  public void configHauteur(float hauteur){
    _hauteur = hauteur-margeDesBoite;
  }
  public void configLargeur(float largeur){
    _largeur = largeur-margeDesBoite;
  }
  public void configPosition(PVector position){
    _position = position;
  }
  public void configPopup(int indice, int paragraphe){
    _contenuDuMenu[indice].configText(paragraphe);
  }

  public void affiche ( ) {
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

  // MÉTHODE D'AJOUT D'UNE BOITE
  // En passant par la méthode configBoite de cette class
  public void ajoutBoite(int       hauteurBoitePrct,
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
  public void addPopups(int paragraphe, int vers, String var){
    _tableDePopup = (Popup[])append(_tableDePopup,new Popup(paragraphe, vers, var));
  }
  // MÉTHODE QUI RETOURNE LES PARAMÈTRES DE CRÉATION D'UNE BOITE
  // Elle convertie une position relative en pourçentage
  // en position absolue en pixel
  public Boite configBoite(  int hauteurBoitePrct,
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
  public void actualiseVar(int boite, String var){
    _tableDeBoite[boite].config("VARIABLE",var);
  }

  // VALIDE QUI L'ON PARLE BIEN D'UNE BOITE D'UN CERTAIN ID
  public boolean idDeBoite(int boite, int id){
    if (_tableDeBoite[boite]._id==id){return true;}
    else {return false;}
  }

  // CONFIGURE LA TAILLE D'UN TEXTE D'UNE BOITE DONT ON À LE NUMÉROS
  public void configTailleTxt(float tailleTexte, int numeroDeBoite){
    _tableDeBoite[numeroDeBoite].configTailleTxt(tailleTexte);
  }

  // AFFICHE LA TOTALITÉ DE CE QUE CONTIENT LA PAGE
  public void affiche(){
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
  public void action(){
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

  public void affiche (){
    // Calcule de la position pour le "glissement"
    if(millis()-_tempsAffichage>1 && _incrementationVitesse<_vitesse){
      _incrementationVitesse++;
      _millieuxPersX = lerp(_millieuxPersXDepart,_millieuxPersXFinal,_incrementationVitesse/PApplet.parseFloat(_vitesse));
      _millieuxPersY = lerp(_millieuxPersYDepart,_millieuxPersYFinal,_incrementationVitesse/PApplet.parseFloat(_vitesse));
      _tempsAffichage=millis();
    }
    fill(BLANC,125);
    stroke(ROUGE);
    ellipseMode(CENTER);
    circle(_millieuxPersX,_millieuxPersY,_largeurPers*0.5f);
    partAuLoing();
  }
  public void deplace(int deltaColonne, int deltaLigne){
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
  public void partAuLoing(){
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
  public float[] indiceACoord(int colonne, int ligne){
    float posX              = _millieuxBoite.x-_largeurNiveau/2+
                              _largeurPers/2+_largeurPers*colonne;
    float posY              = _millieuxBoite.y-_hauteurNiveau/2+
                              _hauteurPers/2+_hauteurPers*ligne;
    float[] seraRetourner   = {posX, posY};
    return seraRetourner;
  }
  // Retourne une table de [colonne, ligne]
  public int[] position(){
    int[] seraRetourner     = {_colonne, _ligne};
    return seraRetourner;
  }
  // Retourne une table de coordoné [X, Y] de la position acctuel du personnage
  public float[] getPosPixel(){
    float[] seraRetourner   = {_millieuxPersX,_millieuxPersY};
    return seraRetourner;
  }
  // Retourne une table [Colonne, ligne] de la position final du personnage
  public int[] getPosIndice(){
    int[] seraRetourner     = {_colonne,_ligne};
    return seraRetourner;
  }
  // retourne true si le personnage et à la position où il doit être à la fin de son glissement.
  public boolean seDeplace(){
    if (_millieuxPersXFinal == _millieuxPersX && _millieuxPersYFinal == _millieuxPersY){
      return true ;
    }
    else{
      return false ;
    }
  }
}
 //  ____
 // / ___|   ___  ___   _ __  ___
 // \___ \  / __|/ _ \ | '__|/ _ \
 //  ___) || (__| (_) || |  |  __/
 // |____/  \___|\___/ |_|   \___|
 //
class Score{
  int[]     _scoreNiveau;
  String[]  _nom;
  String    _nomDuHight = "";
  String[]  _hightScore;
  boolean   _isNotInHight = true;

  Score(int nbLevel) {
    _scoreNiveau = new int[nbLevel];
    for (int a=0;a<_scoreNiveau.length;a++){
      _scoreNiveau[a]  = 0;
    }
    _nom = tableTexte[3].lireParagraphe("paragraphe", 1);
    _hightScore = tableTexte[2].lireParagraphe("paragraphe", 1);
  }

  public void config(int numerosDeNiveau, int score){
    if (_scoreNiveau.length >= numerosDeNiveau){
      _scoreNiveau = append(_scoreNiveau,score);
    }
    _scoreNiveau[numerosDeNiveau]  = score;
    estUnHight();
  }

  public int calcul(){
    int scoreFinal = 0;
    for (int a=0; a<_scoreNiveau.length;a++){
      scoreFinal += _scoreNiveau[a];
    }
    return scoreFinal;
  }

  public void debug(){
    range();
    enregistre();
  }

  public void enregistre(){
    String[] d = {"paragraphe 1"};
    String[] f = {"paragraphe 2"};

    String[] fichierScore = concat(d,_hightScore);
    fichierScore = concat(fichierScore, f);
    saveStrings("text/score.txt", fichierScore);

    String[] fichierNom = concat(d, _nom);
    fichierNom = concat(fichierNom, f);
    saveStrings("text/nom.txt", fichierNom);

    tableTexte[2] = new Text("score");
    tableTexte[3] = new Text("nom");
  }

  public void estUnHight(){
    if (!_nomDuHight.equals(nomDuJoueur)){_isNotInHight = true;}
    if (calcul() > PApplet.parseInt(_hightScore[_hightScore.length-1]) && _isNotInHight){
      _hightScore[_hightScore.length-1]=str(calcul());
      _nom[_hightScore.length-1]=nomDuJoueur;
      _nomDuHight=nomDuJoueur;
      _isNotInHight = false;
    }
    if (!_isNotInHight){
      for (int a=0; a<_nom.length; a++){
        if (_nom[a].equals(nomDuJoueur)){
          _hightScore[a]=str(calcul());
        }
      }
    }
    range();
    enregistre();
  }
  public void range(){
    for (int a = 0 ;a<_hightScore.length;a++){
      int deltaAvance = 0;
      int valeur = PApplet.parseInt(_hightScore[a]); // Prend la table par la fin
      for (int b = a; b>0 ; b--){
        int valeurSup = PApplet.parseInt(_hightScore[b-1]);
        if (valeur>valeurSup){
          deltaAvance = a-b+1;
        }
      }
      if (deltaAvance>0){
        String[] debut = subset(_hightScore, 0, a);
        String[] fin = subset(_hightScore, a+1, _hightScore.length-a-1);
        _hightScore = concat(debut, fin);
        _hightScore = splice(_hightScore, str(valeur), a-deltaAvance);

        String nomDeplacer = _nom[a];
        debut = subset(_nom, 0, a);
        fin = subset(_nom, a+1, _nom.length-a-1);
        _nom = concat(debut, fin);
        _nom = splice(_nom, nomDeplacer, a-deltaAvance);

      }
    }
  }
}
 //  _____            _
 // |_   _|___ __  __| |_
 //   | | / _ \\ \/ /| __|
 //   | ||  __/ >  < | |_
 //   |_| \___|/_/\_\ \__|
 //
class Text{
  String[] _lignesTexte;

  Text(String name){
    _lignesTexte = loadStrings("text/"+name+".txt");
  }
  Text(String[] content){
    _lignesTexte = content;
  }
  public int compte(String cible){
    int occurence = 0;
    for (int a=0;a<_lignesTexte.length;a++) {
      String[] mots = split(_lignesTexte[a], ' ');
      for (int b=0;b<mots.length;b++){
        if (cible.equals(mots[b])){occurence++;}
      }
    }
    return occurence;
  }
  public int ligneDeChaine(String cible){
    int ligne = 0;
    for (int a=0;a<_lignesTexte.length;a++) {
      if (cible.equals(_lignesTexte[a])){ligne=a;}
    }
    return ligne;
  }
  public int ligneDeChaine(int cible){
    int ligne = 0;
    for (int a=0;a<_lignesTexte.length;a++) {
      if (cible == PApplet.parseInt((_lignesTexte[a]))){ligne=a;}
    }
    return ligne;
  }
  public String chaineDe(int ligne, int mot){
    String[] mots = split(_lignesTexte[ligne], ' ');
    return mots[mot];
  }
  public String[] lireParagraphe(String id, int numerosDuParagraphe){
    int indiceDuDebut = numerosDuParagraphe+1;
    int ligneDuDebut = ligneDeChaine(id+" "+str(numerosDuParagraphe))+1;
    int ligneDeFin =ligneDeChaine(id+" "+str(indiceDuDebut))-1;
    String[] paragraphe = subset(_lignesTexte, ligneDuDebut, ligneDeFin-ligneDuDebut+1);
    return paragraphe;
  }
}

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
    _espaceEntreBrique    = _largeurMure*0.03f;
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

  public void affiche(){
    rectMode(CENTER);
    noStroke();
    fill(0xff34495e);
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

  public int[] colision (int[] coordPers){
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
  float           _dimentionPopupY    = height*0.25f;
  String[]        _texteDeLaPopup;
  boolean         _etatValidation;
  String          _texteRetourner;
  String          _variableAffecter;
  Menu            _menuPopup;
  String[]        _paragraphe;
  int             _envoieVers;
  boolean         _retour;

  // CRÉATION D'UNE POPUP EN FONCTION DU TEXTE CONTENUE EN ELLE ET DE CE QU'ELLE FAIT COMME ACTION
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
  public void affiche(){
    // Contour
    rectMode(CENTER);
    fill(ROUGE,200);
    stroke(BLANC);
    rect(_positionPopupX,_positionPopupY,_dimentionPopupX,_dimentionPopupY);
    // Fenêtre de frappe
    PVector positionDeLaFenetreDeFrappe = new PVector(_positionPopupX,_positionPopupY+_dimentionPopupY/6);
    rectMode(CENTER);
    fill(NOIR);
    noStroke();
    rect(positionDeLaFenetreDeFrappe.x,positionDeLaFenetreDeFrappe.y,_dimentionPopupX*0.8f,_dimentionPopupY*0.2f);
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

  public void action(){
    _menuPopup.configHauteur(_dimentionPopupY/3);
    _menuPopup.configLargeur(_dimentionPopupX);
    _menuPopup.configPosition(new PVector(_positionPopupX,_positionPopupY+2*_dimentionPopupY/5));
    _menuPopup.action();
    // Action des inputs calvier.
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

  // MODIFICATION DE LA VARIABLE SÉLECTIONNÉ
  public void variableEdit(){
    switch (_variableAffecter){
      case "Niveau":
        nomDuJoueur = _texteRetourner;
        break;
      case "Temps":
        editeur._tempsDuNiveau =PApplet.parseInt(_texteRetourner);
        println(editeur._tempsDuNiveau);
        break;
      case "Lignes":
        editeur._nombreDeLigne = PApplet.parseInt(_texteRetourner);
        break;
      case "Colonnes":
        editeur._nombreDeColonne = PApplet.parseInt(_texteRetourner);
        break;
    }
  }
}
  public void settings() {  size(1000,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "programme_Main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
