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
  int compte(String cible){
    int occurence = 0;
    for (int a=0;a<_lignesTexte.length;a++) {
      String[] mots = split(_lignesTexte[a], ' ');
      for (int b=0;b<mots.length;b++){
        if (cible.equals(mots[b])){occurence++;}
      }
    }
    return occurence;
  }
  int ligneDeChaine(String cible){
    int ligne = 0;
    for (int a=0;a<_lignesTexte.length;a++) {
      if (cible.equals(_lignesTexte[a])){ligne=a;}
    }
    return ligne;
  }
  int ligneDeChaine(int cible){
    int ligne = 0;
    for (int a=0;a<_lignesTexte.length;a++) {
      if (cible == int((_lignesTexte[a]))){ligne=a;}
    }
    return ligne;
  }
  String chaineDe(int ligne, int mot){
    String[] mots = split(_lignesTexte[ligne], ' ');
    return mots[mot];
  }
  String[] lireParagraphe(String id, int numerosDuParagraphe){
    int indiceDuDebut = numerosDuParagraphe+1;
    int ligneDuDebut = ligneDeChaine(id+" "+str(numerosDuParagraphe))+1;
    int ligneDeFin =ligneDeChaine(id+" "+str(indiceDuDebut))-1;
    String[] paragraphe = subset(_lignesTexte, ligneDuDebut, ligneDeFin-ligneDuDebut+1);
    return paragraphe;
  }
}
