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

  void config(int numerosDeNiveau, int score){
    if (_scoreNiveau.length >= numerosDeNiveau){
      _scoreNiveau = append(_scoreNiveau,score);
    }
    _scoreNiveau[numerosDeNiveau]  = score;
    estUnHight();
  }

  int calcul(){
    int scoreFinal = 0;
    for (int a=0; a<_scoreNiveau.length;a++){
      scoreFinal += _scoreNiveau[a];
    }
    return scoreFinal;
  }

  void debug(){
    range();
    enregistre();
  }

  void enregistre(){
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

  void estUnHight(){
    if (!_nomDuHight.equals(nomDuJoueur)){_isNotInHight = true;}
    if (calcul() > int(_hightScore[_hightScore.length-1]) && _isNotInHight){
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
  void range(){
    for (int a = 0 ;a<_hightScore.length;a++){
      int deltaAvance = 0;
      int valeur = int(_hightScore[a]); // Prend le tab par la fin
      for (int b = a; b>0 ; b--){
        int valeurSup = int(_hightScore[b-1]);
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
