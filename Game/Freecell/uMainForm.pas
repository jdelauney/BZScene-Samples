unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, BZImageViewer,
  BZColors, BZGraphic, BZBitmap, {%H-}BZBitmapIO;

Const
  cLargeurImageCarteMax = 110;
  cHauteurImageCarteMax = 160;

  // Decalage en pixel des cartes pour l'affichage de toutes les cartes d'une CardList
  cDecalageCarte = 40;


type
  // Couleur d'une carte
  TCardColor =(ccHeart, ccDiamond, ccSpade, ccClub);
  // Valeur d'une carte
  TCardValue = (cvAce, cvTwo, vcThree, cvFour, cvFive, cvSix, cvSeven,
                cvEight, cvNine, cvTen, cvJack, cvQueen, cvKing);

const
  // CardList des noms de fichier des cartes
  cCardFileNames : array[TCardColor] of array[TCardValue] of string  = (
    ('ace_of_hearts' , '2_of_hearts' , '3_of_hearts', '4_of_hearts', '5_of_hearts',
     '6_of_hearts' , '7_of_hearts', '8_of_hearts', '9_of_hearts',
     '10_of_hearts', 'jack_of_hearts2', 'queen_of_hearts2', 'king_of_hearts2'),
    ('ace_of_diamonds' , '2_of_diamonds' , '3_of_diamonds', '4_of_diamonds', '5_of_diamonds',
     '6_of_diamonds' , '7_of_diamonds', '8_of_diamonds', '9_of_diamonds',
     '10_of_diamonds', 'jack_of_diamonds2', 'queen_of_diamonds2', 'king_of_diamonds2'),
    ('ace_of_spades' , '2_of_spades' , '3_of_spades', '4_of_spades', '5_of_spades',
     '6_of_spades' , '7_of_spades', '8_of_spades', '9_of_spades',
     '10_of_spades', 'jack_of_spades2', 'queen_of_spades2', 'king_of_spades2'),
    ('ace_of_clubs' , '2_of_clubs' , '3_of_clubs', '4_of_clubs', '5_of_clubs',
     '6_of_clubs' , '7_of_clubs', '8_of_clubs', '9_of_clubs',
     '10_of_clubs', 'jack_of_clubs2', 'queen_of_clubs2', 'king_of_clubs2'));

Type
  // Description d'une carte
  TCard = packed record
    Color : TCardColor; // Couleur de la carte
    Value  : TCardValue;  // Valeur de la carte
    Image   : TBZBitmap;       // Image de la carte à afficher
  end;
  PCard = ^TCard; //Pointeur sur une carte

  TCardPointers = Array[1..52] of PCard;

type
  TMainForm = class(TForm)
    image1 : TBZImageViewer;
    image10 : TBZImageViewer;
    image11 : TBZImageViewer;
    image12 : TBZImageViewer;
    image13 : TBZImageViewer;
    image14 : TBZImageViewer;
    image15 : TBZImageViewer;
    image16 : TBZImageViewer;
    image2 : TBZImageViewer;
    image3 : TBZImageViewer;
    image4 : TBZImageViewer;
    image5 : TBZImageViewer;
    image6 : TBZImageViewer;
    image7 : TBZImageViewer;
    image8 : TBZImageViewer;
    image9 : TBZImageViewer;
    MainMenu : TMainMenu;
    MenuItem1 : TMenuItem;
    mnuAbout : TMenuItem;
    mnuExitApp : TMenuItem;
    mnuNewGame : TMenuItem;
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormCreate(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure imageMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure mnuExitAppClick(Sender : TObject);
    procedure mnuNewGameClick(Sender : TObject);

    procedure ImageClick(Sender : TObject);
  private
    // Sera utile pour le tirage aléatoire des cartes
    FCardDistibution : Array[1..52] of Boolean;

    // Les quatre images en haut à gauche
    FDeckTemps : Array[1..4] of TList;

    // Les quatre images en haut à droite
    FDeckFinals : Array[1..4] of TList;

    // Les huit images en bas
    FDecks : array[1..8] of TList;

    // Liste pour stocker les cartes sélectionnées si il y en plus de une
    FSelectionList : TList;

    // Jeu de carte complets, CardList de tous les pointeurs de cartes dans un tableau
    FCards : TCardPointers;

    FSelection : Boolean; // Drapeau lorsqu'une ou plusieurs cartes sont sélectionnées
    FSelectionCount : Integer;  // Nombre de carte sélectionnées
    FMousePoint : TPoint; // Position de la souris dans les TImages
    FSelectionListIndex : Integer; // Numero de la Liste de carte ou on fait la selection
    FSelectionCard : PCard; // Carte sélectionnée utilisée pour les tests de vérifications

    // Tableau de référence des TImage de notre application
    // Va permettre de simplifier les interactions
    FImageRef : Array[1..16] of TBZImageViewer;

    // Tableau pour stocker nos 4 images de fond pour les tas finaux
    FCardBackgrounds : Array[1..4] of TBZBitmap;

  protected
    { Initalise la CardList de tirage des cartes
      leur valeur est mise à FAUX (False) car aucune carte n'a été tirée }
    procedure InitCardsDistribution;

    { Distribution des cartes aléatoirement dans les huit CardLists "FTasDeCartes" }
    procedure DistributeCards;

    { Creation d'une nouvelle carte et retourne celle-ci
      Note : L'image de la carte sera automatique chargé en fonction de sa couleur et valeur }
    function CreateCard(CardColor : TCardColor; CardValue : TCardValue) : PCard;

    { Creation de toutes les cartes du jeux dans le tableau de pointeurs "FCartes }
    procedure CreateGameCards;

    { Creation des CardLists de cartes du jeux et chargements des images }
    procedure CreateCardLists;

    { Détruit toutes les CardLists de carte du jeux }
    procedure DestroyAllCardLists;

    { Vides toutes les CardLists de carte du jeux, sans libérer les pointeurs des cartes }
    procedure ClearCardLists;

    { Ajoute un pointeur carte dans une CardList }
    procedure AddCardInList(CardList : TList; Card : PCard);

    { Pioche la dernière carte d'une CardList et efface celle-ci de la CardList }
    function GetLastCardInList(CardList : TList) : PCard;

    { Efface la derniere carte d'une CardList }
    procedure DeleteLastCardInList(CardList : TList);

    { Detruit toutes les cartes d'une CardList et la CardList elle même }
    procedure DestroyCardList(CardList : TList);

    { Retourne CardList Suivant Index, basé sur les numero de Tag des TImage }
    function GetCardList(Index : Integer) : TList;

    { Creation de la liste de sélection, utilisé si plusieurs cartes sont sélectionnées }
    procedure CreateSelectionList(aList : TList; StartSelectionIndex : Integer);

    { Affiche tous les "Bitmap" (image) des cartes d'une CardList,
      dans un control visuel "TImage', en les décalant.
      Si le paramètre "Selection" est à VRAI (True) alors la dernière carte sera affichée
      en couleur inverse}
    procedure DisplayCardList(CardList : TList; img : TBZImageViewer; Selection : Boolean);

    { Retourne VRAI (true) si on peux déposer la carte sur un tas final }
    function CanMoveOnFinalDeck(IndexList : Integer; aCard : PCard) : Boolean;

    { Retourne VRAI (true) si on peux déposer la carte sur un tas de carte temporaire }
    function CanMoveOnTempDeck(IndexList : Integer) : Boolean;

    { Retourne VRAI (true) si on peux déposer la carte sur un tas de carte principal }
    function CanMoveOnDeck(IndexList : Integer; aCard : PCard) : Boolean;

    { Retourne VRAI (True) si on a déposé toutes les cartes sur les tas finaux }
    function CheckIfWin : Boolean;
  public

    procedure NewGame;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
Var
  Img : TBZImageViewer;
  i, cnt : Integer;
  TmpBmp : TBZBitmap;
begin
  CreateGameCards;
  CreateCardLists;
  DistributeCards;

  FSelectionList := TList.Create;

  // On doit initialiser les bitmaps des TImage car ceux-ci sont vide
  //Image9.Picture.Bitmap := TBitmap.Create;
  //Image9.Picture.Bitmap.SetSize(cLargeurImageCarteMax, Image9.Height);
  // Plutot que d'ajouter les 8 TImage correspondant aux tas de cartes
  // on va parcourir la liste des controle présent sur notre form

  cnt := 1;
  for i := 0  to Self.ControlCount - 1 do
  begin
    if Self.Controls[i] is TBZImageViewer then
    begin
      Img := TBZImageViewer(Self.Controls[i]);

      FImageRef[cnt] := Img; // On sauvegarde la réference

      // On créé les Bitmap et on remplis avec une couleur de fond
      if (Img.Tag < 5)  then
      begin
        TmpBmp := TBZBitmap.Create;
        TmpBmp.SetSize(cLargeurImageCarteMax, cHauteurImageCarteMax);
        TmpBmp.Canvas.Pen.Style := ssClear;
        TmpBmp.Canvas.Brush.Style := bsSolid;
        TmpBmp.Canvas.Brush.Color := clrDarkGreen;
        TmpBmp.Canvas.Rectangle(0,0,cLargeurImageCarteMax, cHauteurImageCarteMax);
        Img.Picture.Bitmap.Assign(TmpBmp);
        FreeAndNil(TmpBmp);
      end
      else if (img.Tag >= 5) and (img.Tag <= 8) then
      begin
        FCardBackgrounds[Img.tag - 4] := TBZBitmap.Create;
        FCardBackgrounds[Img.tag - 4].SetSize(cLargeurImageCarteMax, cHauteurImageCarteMax);
        // on a déja préchargé les bitmaps dans nos TImage
        // On fais juste une copie
        FCardBackgrounds[Img.tag - 4].Assign(Img.Picture.Bitmap);
      end
      else
      if (Img.Tag > 8)  then
      begin
        TmpBmp := TBZBitmap.Create;
        TmpBmp.SetSize(cLargeurImageCarteMax, Img.Height);
        TmpBmp.Canvas.Pen.Style := ssClear;
        TmpBmp.Canvas.Brush.Style := bsSolid;
        TmpBmp.Canvas.Brush.Color := clrDarkGreen;
        TmpBmp.Canvas.Rectangle(0,0,cLargeurImageCarteMax, Img.Height);
        Img.Picture.Bitmap.Assign(TmpBmp);
        FreeAndNil(TmpBmp);
      end;

      inc(cnt);
    end;
  end;

  FSelection := False;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  DisplayCardList(FDecks[1], Image9, false);
  DisplayCardList(FDecks[2], Image10, false);
  DisplayCardList(FDecks[3], Image11, false);
  DisplayCardList(FDecks[4], Image12, false);
  DisplayCardList(FDecks[5], Image13, false);
  DisplayCardList(FDecks[6], Image14, false);
  DisplayCardList(FDecks[7], Image15, false);
  DisplayCardList(FDecks[8], Image16, false);
end;

procedure TMainForm.imageMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMousePoint.Create(x,y);
end;

procedure TMainForm.mnuExitAppClick(Sender : TObject);
begin
  Close;
end;

procedure TMainForm.mnuNewGameClick(Sender : TObject);
begin
  NewGame;
end;

procedure TMainForm.ImageClick(Sender : TObject);
Var
  Img : TBZImageViewer;
  ListeA, ListeB : TList;
  Ok : Boolean;
  R : TRect;
  idx, y1, y2, i : Integer;
begin
  Ok := False;
  Img := TBZImageViewer(Sender);
  if FSelection then
  begin
    ListeA := GetCardList(FSelectionListIndex);
    ListeB := GetCardList(img.Tag);
    Case Img.Tag of
      1, 2, 3, 4 : Ok := CanMoveOnTempDeck(img.tag);
      5, 6, 7, 8 : Ok := CanMoveOnFinalDeck(img.Tag, FSelectionCard);
      else
        Ok := CanMoveOnDeck(Img.Tag, FSelectionCard);
    end;
    if Ok then // La carte sélectionnée peut-être déplacée
    begin
      // On Ajoute la ou les cartes selectionnées dans la nouvelle liste
      if FSelectionCount > 1 then
      begin
        for i := 0 to (FSelectionList.Count - 1) do
        begin
          AddCardInList(ListeB, PCard(FSelectionList.Items[i]));
        end;
      end
      else  AddCardInList(ListeB, FSelectionCard);
    end
    else
    begin
      // Non, alors on remet les cartes dans la liste d'origine
      if FSelectionCount > 1 then
      begin

        for i := 0 to (FSelectionList.Count - 1) do
        begin
          AddCardInList(ListeA, PCard(FSelectionList.Items[i]));
        end;
      end
      else AddCardInList(ListeA, FSelectionCard);
    end;

    DisplayCardList(ListeB, FimageRef[img.Tag], false);
    DisplayCardList(ListeA, FimageRef[FSelectionListIndex], false);

    FSelection := False;

    if CheckIfWin then
    begin
      if MessageDlg('Bravo vous avez gagné !'+LineEnding+'Souhaitez vous commencer une nouvelle partie ?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      begin
        NewGame;
      end;
    end;

  end
  else
  begin
    y1 := 0;
    y2 := cDecalageCarte;
    FSelectionCount := 0;
    FSelectionListIndex := Img.Tag;
    ListeA := GetCardList(FSelectionListIndex);
    if FSelectionListIndex >=9 then
    begin
      if ListeA.Count > 0 then
      begin
        R := Rect(0,y1, cLargeurImageCarteMax, y2);
        for i := 0 to ListeA.Count - 1 do
        begin
          if (i <  (ListeA.Count - 1)) then
            R := Rect(0,y1, cLargeurImageCarteMax, y2)
          else
            R := Rect(0,y1, cLargeurImageCarteMax, y1 + cHauteurImageCarteMax);

          if R.Contains(FMousePoint) then
          begin
            FSelectionCount := ListeA.Count - i;
            Break;
          end;
          y1 := y1 + cDecalageCarte;
          y2 := y2 + cDecalageCarte;
        end;
        DisplayCardList(ListeA, FimageRef[FSelectionListIndex], True);
        // On conserve la carte selectionnée dans une variable globale
        if FSelectionCount > 1 then
        begin
          Idx := (ListeA.Count - 1) - (FSelectionCount - 1);
          FSelectionCard := PCard(ListeA.Items[Idx]);
          CreateSelectionList(ListeA, Idx);
        end
        else
          FSelectionCard := GetLastCardInList(ListeA);
      end;
    end
    else
    begin
      if ListeA.Count > 0 then
      begin
        FSelectionCount := 1;
        DisplayCardList(ListeA, FimageRef[FSelectionListIndex], True);
        FSelectionCard := GetLastCardInList(ListeA);

      end;
    end;

    FSelection := True;
  end;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
Var
  i : Integer;
begin
  // On libere nos listes et tous les pointeurs des cartes
  DestroyAllCardLists;
  FreeAndNil(FSelectionList);
  // On libère nos images de fond
  for i := 4 downto 1 do FreeAndNil(FCardBackgrounds[i]);

end;

procedure TMainForm.InitCardsDistribution;
Var
  i : Byte;
begin
  for i := 1 to 52 do
  begin
    FCardDistibution[i] := False;
  end;
end;

procedure TMainForm.DistributeCards;
Var
  i, j, n : Byte;
  nbCards : Byte; // Nombre de carte à tirer par liste
begin

  InitCardsDistribution;  // Remize à zero de la liste pour l'aide au tirage

  Randomize; // Initialisation de la génération de nombre aléatoire

  // Tirage des sept premiers tas de carte
  for i := 1 to 7 do
  begin
    if i > 4 then nbCards := 6 else nbCards := 7;
    j := 1;
    While (j <= nbCards) do
    begin
      n := (Random(104) div 2) + 1; // Tirage d'une nombre entre 1 et 52

      if not(FCardDistibution[n]) then // Si la carte n'a pas encore été tirée
      begin
        AddCardInList(FDecks[i], FCards[n]);
        FCardDistibution[n] := True;
        inc(j);
      end;
    end;
  end;

  // On ajoute les cartes restantes dans le dernier tas de carte
  For i := 1 to 52 do
  begin
    if not(FCardDistibution[i]) then
    begin
      AddCardInList(FDecks[8], FCards[i]);
    end;
  end;
end;

function TMainForm.CreateCard(CardColor : TCardColor; CardValue : TCardValue) : PCard;
Var
  NewCard : PCard;
begin
  New(NewCard); //Allocation du pointeur de la nouvelle carte en mémoire
  // On définie les propriétés. On utilise ^ car c'est un pointeur
  NewCard^.Color := CardColor;
  NewCard^.Value := CardValue;
  NewCard^.Image := TBZBitmap.Create; // Creation du Bitmap
  NewCard^.Image.LoadFromFile('../../../images/' + cCardFileNames[CardColor][CardValue] + '.png');
  Result := NewCard;
end;

procedure TMainForm.CreateGameCards;
Var
  i : TCardColor;
  j : TCardValue;
  cnt : Byte;
begin
  cnt := 1;
  for i := ccHeart to ccClub do
  begin
    for j:= cvAce to cvKing do
    begin
      FCards[cnt] := CreateCard(i,j);
      inc(cnt)
    end;
  end;
end;

procedure TMainForm.CreateCardLists;
Var
 i : Byte;
begin
  for i := 1 to 8 do
  begin
    if i < 5 then
    begin
      FDeckTemps[i] := TList.Create;
      FDeckFinals[i] := TList.Create;
    end;
    FDecks[i] := TList.Create;
  end;
end;

procedure TMainForm.DestroyAllCardLists;
Var
 i : Byte;
begin
  for i := 8 downto 1 do
  begin
    if i < 5 then
    begin
      DestroyCardList(FDeckTemps[i]);
      DestroyCardList(FDeckFinals[i]);
    end;
    DestroyCardList(FDecks[i]);
  end;
end;

procedure TMainForm.ClearCardLists;
Var
 i : Byte;
 j : Integer;
begin
  for i := 8 downto 1 do
  begin
    if i < 5 then
    begin
      if FDeckTemps[i].Count > 0 then
        for j := (FDeckTemps[i].Count - 1) downto 0 do FDeckTemps[i].Delete(j);
      if FDeckFinals[i].Count > 0 then
        for j := (FDeckFinals[i].Count - 1) downto 0 do FDeckFinals[i].Delete(j);
    end;
    if FDecks[i].Count > 0 then
      for j := (FDecks[i].Count - 1) downto 0 do FDecks[i].Delete(j);
  end;
end;

procedure TMainForm.AddCardInList(CardList : TList; Card : PCard);
begin
  CardList.Add(Card);
end;

function TMainForm.GetLastCardInList(CardList : TList) : PCard;
begin
  Result := CardList.Items[(CardList.Count - 1)];
  DeleteLastCardInList(CardList);
end;

procedure TMainForm.DeleteLastCardInList(CardList : TList);
begin
  CardList.Delete((CardList.Count - 1));
end;

procedure TMainForm.DestroyCardList(CardList : TList);
Var
 p : PCard;
 i : integer;
begin
  if CardList.Count > 0 then
  begin
    for i := (CardList.Count - 1) downto 0 do
    begin
      p := CardList.Items[i];
      CardList.Delete(i);
      FreeAndNil(P^.Image); // NE PAS OUBLIER DE LIBERER LES BITMAPS
      Dispose(p);
    end;
  end;
  FreeAndNil(CardList);
end;

function TMainForm.GetCardList(Index : Integer) : TList;
begin
  Case Index of
    1, 2, 3, 4 :
    begin
      Result := FDeckTemps[Index];
    end;
    5,6,7,8 :
    begin
      Result := FDeckFinals[Index - 4]
    end;
    else
      begin
         Result := FDecks[Index - 8];
      end;
  end;
end;

procedure TMainForm.CreateSelectionList(aList : TList; StartSelectionIndex : Integer);
var
 i, cnt : integer;

begin

  // On vide la liste de slection
  cnt := FSelectionList.Count;
  if (cnt > 0) then
  begin
    for i := (cnt-1) downto 0 do  // IMPORTANT ! Attention d'effacer les éléments en partant du dernier
    begin
      FSelectionList.Delete(i);
    end;
  end;
  // On remplis la liste de selection avec les cartes sélectionnées
  cnt := aList.Count;
  for i := StartSelectionIndex to (cnt - 1) do
  begin
    FSelectionList.Add(PCard(aList.Items[i]));
  end;
  // On efface les cartes sélectionnées de la liste d'origine
  for i := (cnt - 1) downto StartSelectionIndex do aList.Delete(i);
end;

procedure TMainForm.DisplayCardList(CardList : TList; img : TBZImageViewer; Selection : Boolean);
Var
 i, cnt : Integer;
 Decalage : Integer;
 Card : PCard;
 TmpBmp : TBZBitmap;
begin
  Decalage := 0;
  cnt := (CardList.Count - 1);

  if ((Img.Tag >= 5) and (Img.Tag <= 8)) then // S'agit-il des tas finaux
  begin
    // Oui on copie l' image de fond
    Img.Picture.Bitmap.PutImage(FCardBackgrounds[Img.tag - 4],0,0,255,dmSet,amAlpha);
    //Img.Picture.Bitmap.Clear(clrYellow);
  end
  else
  begin
    // On efface avec la couleur du fond
    Img.Picture.Bitmap.Canvas.Pen.Style := ssClear;
    Img.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    Img.Picture.Bitmap.Canvas.Brush.Color := clrDarkGreen;
    Img.Picture.Bitmap.Canvas.Rectangle(0,0,Img.Width, Img.Height);
  end;

  if cnt < 0 then
  begin
    img.Invalidate;
    exit; // Rien à dessiner on sort
  end;

  if (Img.Tag >= 9) then // On affiche nos tas de cartes
  begin
    for i := 0 to cnt do
    begin
      Card := CardList.Items[i];
      if Selection then
      begin
        //if FSelectionCount > 1 then
        //begin
          if (i >= (cnt - (FSelectionCount-1))) then
          begin
            TmpBmp := Card^.Image.CreateClone;
            TmpBmp.ColorFilter.Negate();
            Img.Picture.Bitmap.PutImage(TmpBmp,0,Decalage,255,dmSet,amAlpha);
            FreeAndNil(TmpBmp);
          end
          else
          begin
            Img.Picture.Bitmap.PutImage(Card^.Image,0,Decalage,255,dmSet,amAlpha);
          end;
        //end
        //else
        //if i = cnt then
        //begin
        //  TmpBmp := Card^.Image.CreateClone;
        //  TmpBmp.ColorFilter.Negate();
        //  Img.Picture.Bitmap.PutImage(TmpBmp,0,Decalage,255,dmSet,amAlpha);
        //  FreeAndNil(TmpBmp);
        //end
        //else
        //begin
        //  Img.Picture.Bitmap.PutImage(Card^.Image,0,Decalage,255,dmSet,amAlpha);  // Transfert de l'image de la carte dans le TImage
        //end;
      end
      else
      begin
        Img.Picture.Bitmap.PutImage(Card^.Image,0,Decalage,255,dmSet,amAlpha);  // Transfert de l'image de la carte dans le TImage
      end;
      Decalage := Decalage + cDecalageCarte;
    end;
  end
  else
  begin // Pour les autres on n'affiche que la dernière
    Card := CardList.Items[cnt];
    if Selection then // Transfert de l'image slectionner en couleur inverse de la carte dans le TImage
    begin
      TmpBmp := Card^.Image.CreateClone;
      TmpBmp.ColorFilter.Negate();
      Img.Picture.Bitmap.PutImage(TmpBmp,0,0,255,dmSet,amAlpha);
      FreeAndNil(TmpBmp);
    end
    else
    begin
      //Card^.Image.ColorFilter.SwapChannel(scmRedBlue);
      Img.Picture.Bitmap.PutImage(Card^.Image ,0,0,255,dmSet,amAlpha);  // Transfert de l'image de la carte dans le TImage
    end;
  end;
  Img.Invalidate; // Pour rafraichir le TImage
end;

function TMainForm.CanMoveOnFinalDeck(IndexList : Integer; aCard : PCard) : Boolean;
Var
 aList : TList;
 Idx : Integer;
begin
  Result := False;
  if FSelectionCount > 1 then exit; // On ne peux pas placer plus d'une carte

  aList := GetCardList(IndexList);

  if aList.Count = 13 then Exit; // La liste est pleine on sort

  Idx := IndexList - 4;
  Case idx of
    1 : Result := (aCard^.Color = ccHeart);
    2 : Result := (aCard^.Color = ccDiamond);
    3 : Result := (aCard^.Color = ccSpade);
    4 : Result := (aCard^.Color = ccClub);
  end;

  if aList.Count < 1 then
  begin
    Result := Result and (aCard^.Value = cvAce);
  end
  else
  begin
    Result := Result and (aCard^.Value = TCardValue(aList.Count));
  end;
end;

function TMainForm.CanMoveOnTempDeck(IndexList : Integer) : Boolean;
Var
  aList : TList;
begin
  Result := False;
  if FSelectionCount > 1 then exit; // On ne peux pas placer plus d'une carte
  aList := GetCardList(IndexList);
  Result := aList.Count < 1;
end;

function TMainForm.CanMoveOnDeck(IndexList : Integer; aCard : PCard) : Boolean;
Var
  Card : PCard;
  aList : TList;
begin
  Result := False;
  aList := GetCardList(IndexList);

  if aList.Count < 1 then Exit(true);

  Card := aList.Items[(aList.Count - 1)]; // On recupere la derniere carte de la liste ou on veux déposer la carte
  Case Card^.Color of
    ccHeart, ccDiamond : Result := (aCard^.Color = ccSpade) or (aCard^.Color = ccClub);
    ccSpade, ccClub : Result := (aCard^.Color = ccHeart) or (aCard^.Color = ccDiamond);
  end;
  if Result then
  begin
    Result := Result and (Card^.Value = TCardValue((ord(aCard^.Value) + 1)));    //(Card^Value + 1)
  end;
end;

function TMainForm.CheckIfWin : Boolean;
begin
  // On fait simplement la somme de tous les tas
  Result := (FDeckFinals[1].Count + FDeckFinals[2].Count + FDeckFinals[3].Count + FDeckFinals[4].Count) = 52;
end;

procedure TMainForm.NewGame;
begin
  Screen.Cursor := crHourGlass;
  ClearCardLists;
  DistributeCards;
  FSelectionCount := 0;
  FSelectionCard := nil;
  FSelection := False;

  // On affiche nos tas de cartes
  DisplayCardList(FDecks[1], Image9, false);
  DisplayCardList(FDecks[2], Image10, false);
  DisplayCardList(FDecks[3], Image11, false);
  DisplayCardList(FDecks[4], Image12, false);
  DisplayCardList(FDecks[5], Image13, false);
  DisplayCardList(FDecks[6], Image14, false);
  DisplayCardList(FDecks[7], Image15, false);
  DisplayCardList(FDecks[8], Image16, false);

  DisplayCardList(FDeckTemps[1], Image1, False);
  DisplayCardList(FDeckTemps[2], Image2, False);
  DisplayCardList(FDeckTemps[3], Image3, False);
  DisplayCardList(FDeckTemps[4], Image4, False);

  DisplayCardList(FDeckFinals[1], Image5, False);
  DisplayCardList(FDeckFinals[2], Image6, False);
  DisplayCardList(FDeckFinals[3], Image7, False);
  DisplayCardList(FDeckFinals[4], Image8, False);

  Screen.Cursor := crDefault;
end;

end.

