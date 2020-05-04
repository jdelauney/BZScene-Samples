unit uMainForm;

{$mode objfpc}{$H+}

{ GAME JAM DVP 2019 : Concept 2 game play 2 jeux en 1. Une facon de jouer, 2 concepts }

{ V.Break and H.Pong :
  Ce joue à 2 contre un autre adversaire humain.
  Le joueur A  voit :
      en Vertical "partiellement" des briques ou autres
      a l'horizontal a gauche ou à droite je sais plus, une poil plus grande au départ avec une butée limite en bas

  Chaque joueur devra gérer deux balles. Une des deux boules de l'adversaire arrivera dans le sens opposé de la raquette verticale (vous suivez toujours ???)

  Les briques que le joueur verra (en partie seulement. jusqu'a... que....) ne sera pas les siennes, mais le mirroir de l'adversaire
  ... Qui au final seront les votres, puisque que votre adversaire celle de sont adversaire, qui en occurence se trouve être incarné par vous !

 ... vous suivez toujours là ?

 En fonction de la progression dans le jeu plusieurs facteurs pourront évoluer comme la taille de la raquette par exemple
 les limites du "Pong" ainsi que la visibilité du champs adverse

 Ressources :
   - https://opengameart.org/content/breakout-graphics-no-shadow
   - http://unluckystudio.com/game-art-giveaway-6-breakout-sprites-pack/
    -https://getavataaars.com
   -http://www.gameburp.com/free-game-sound-fx/
   -http://soundbible.com/royalty-free-sounds-1.html

  Ca tourne en 1024x768, pas de sdl, d'onpegl, directx, etc... c'est 100% software ;)
  L'audio est pris en charge par OpenAl et ModPlug

  Le rebond des balles est très basique.
  aucun bonus/malus a cette heure, et j'ai une tonne d'idée :P

  Voila le code exploite ma bibliothèque que je rendrais publique dès que.....

  Si vous utiliser BGRABitmap c'est très facilement transposable

  Sinon le code, il est un peu bourrin, voila ce que j'ai fait en plus ou moins 24h....
}


interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Spin, Menus,
  BZMath, BZVectorMath,
  BZGraphic, BZBitmap, BZBitmapIO,
  BZBitmapFont,
  BZCadencer,
  BZSound, BZOpenALManager, BZSoundSample, BZSoundFileModplug, BZSoundFileWAV;

const
  cGridMaxRowCount = 8;
  cGridMaxColCount = 13;
  // Dimension de la grille en pixel
  cGridWidth = 832; // 64 tailles maximal des bricks
  cGridHeight = 512  ;

type
  //TBZBonusEntity =
  TBZBonusType = (btNone, btRandom, btExtraLive, btFreeRacket, btGuns, btGrow, btShrink,
                  btExtraBall, btGrowBall, btShrinkBall, btBreakOutBall, btFireBall,
                  btSlowBall, btSpeedBall, btInvertPong, btUpDown, btExplodeAll);
  //TBZSpecialBonus = (sbAddLineToOpponent, sbFreezeControl, sbBallMine, justfordeconcentrate....

  TLevelBrickRes = Packed Record
    NbSprite : Byte;
    //Width : Integer;
    //Height : Integer;
    BricksBitmap : TBZBitmap;//Array of TBZBitmap;
  end;

  TBrickPack = Array[0..3] of TBZBitmap; //TLevelBrickRes;

  TLevelRec = packed Record
    BrickIndex : Integer;
    LifeTime : Integer; // Nombre de fois touché avant de disparaitre, a chaque fois on augmente le brickindex pour l'affichage de la brique
    Animation : Boolean;
    BonusType : TBZBonusType;
    Reserved : Integer;
    IsIndestructible : Boolean;
    IsDead : Boolean;
  end;

  TLevelMap = array[0..7,0..12] of TLevelRec;

  { TGameLevelManager }

  TGameLevelManager = class
  private
    FLevelMap : TLevelMap;
    FBrickPack : TBrickPack;

    FLevelData : TStrings;
  protected
  public
    Constructor Create;
    Destructor Destroy; override;

    procedure LoadRessources;

    procedure SaveToFile(const Filename : String);
    procedure LoadFromFile(const Filename : String);

    procedure DrawLevelTo(Dest : TBZBitmap; DstX, DstY : Integer);

  end;


  { TMainForm }

  TMainForm = class(TForm)
    Panel1 : TPanel;
    Panel2 : TPanel;
    pnlViewer : TPanel;
    Button1 : TButton;
    btnLoadLevel : TButton;
    Button3 : TButton;
    Label1 : TLabel;
    Label2 : TLabel;
    CheckBox1 : TCheckBox;
    CheckBox2 : TCheckBox;
    Label3 : TLabel;
    SpinEdit1 : TSpinEdit;
    lbxBrickItem : TListBox;
    ListBox2 : TListBox;
    lbltmp : TLabel;
    Memo1 : TMemo;
    chkShowGrid : TCheckBox;
    ppmEditMap : TPopupMenu;
    mniDeleteBrick : TMenuItem;
    procedure pnlViewerPaint(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormShow(Sender : TObject);
    procedure pnlViewerMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewerMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewerMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure btnLoadLevelClick(Sender : TObject);
    procedure lbxBrickItemClick(Sender : TObject);
    procedure mniDeleteBrickClick(Sender : TObject);
  private
    FGridBuffer, FDisplayBuffer : TBZBitmap;
    FRacketBitmap,FRacketBitmapV, FGameBoardBackground, FSideBarBitmap : TBZBitmap;
    FBallPong, FBallBreak, FBrickExplosion : TBZBitmap;

    FBmpFont, FBmpFontB : TBZBitmapFont;

    FListExplosion : TBZVector4iList;

    FCadencer : TBZCadencer;

    FSoundManager : TBZSoundOpenALManager;
    FSoundLibrary : TBZSoundLibrary;
    FSoundSources : TBZSoundSources;
    FSoundSource  : TBZSoundSource;

    FGridLeft, FGridTop : Integer;
    FLevelMap : TLevelMap;
    FBrickPack : TBrickPack;
    FLevelData : TStrings;

    FMousePos : TPoint;
    FSelectedCell, FHoverCellPos : TPoint;
    FBallPongPos, FBallBreakPos,
    FBallPongDir, FBallBreakDir: TBZPoint;
    FBallPongSpeed, FBallBreakSpeed : TBZPoint;
    FBallPongHotSpot, FBallBreakHotSpot : TBZPoint;

    FPongTopLine : Integer;

    FSelectedRect, FHoverRect : TBZRect;
    FRacketPos, FRacketPosV : TBZPoint;
    FFloatStep : Single; //TBZFloatPoint;
    FHoverCell : Boolean;
    FMouseDown, FSelected : Boolean;
    FLevelLoaded : Boolean;
    FBallPongRun, FBallBreakRun, FEditMode, FStarted : Boolean;
    FPlayerScore : Integer;
    FNbBricks : Integer;
    FLoose : Boolean;
    //FLevel : TGameLevelManager;

    procedure LoadLevelDataFromFile(const Filename : String);
    procedure DrawAnimText(Str : String; xStart,yStart : Integer; newtime : Double);
  protected
    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
  public

    procedure DrawExplosionFrame(dx,dy,idx : Integer);
    procedure RenderExplosions;

    procedure DrawLevelGrid;
    procedure DrawLevel;
    procedure DrawSelectedCell(x,y : Integer);

    procedure RenderScene(NewTime : Double);

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses BZTypesHelpers;

{ TGameLevelManager }

constructor TGameLevelManager.Create;
begin
  //
end;

destructor TGameLevelManager.Destroy;
begin
  inherited Destroy;
end;

procedure TGameLevelManager.LoadRessources;
begin

//  FRacketBitmap.LoadFromFile('Racket.png');
end;

procedure TGameLevelManager.SaveToFile(const Filename : String);
begin

end;

procedure TGameLevelManager.LoadFromFile(const Filename : String);
begin

end;

procedure TGameLevelManager.DrawLevelTo(Dest : TBZBitmap; DstX, DstY : Integer);
begin

end;

procedure TMainForm.DrawAnimText(Str : String; xStart,yStart : Integer; newtime : Double);
Var
  a : Single;
  x,y, i : Integer;
begin
  a := 0;
  for x := 0 to length( str)-1 do
  begin
    for i:=0 to 6 do
    begin
      a := ((newtime*700)+((x*80)-(i*40)))*FFloatStep;
      y :=  Round(YStart + cos(a)*25);
      FBmpFontB.TextOut(FDisplayBuffer, xStart + (x*FBmpFontB.CarWidth)  , y, Str[x+1]);
    end;
  end;
end;

{ TMainForm }

procedure TMainForm.LoadLevelDataFromFile(const Filename : String);
var
  i, nb,j,k : integer;
  sLine : String;
  sIndex, sLeft,sRight : String;
  sList : TStrings;
begin
  i := 0;
  //While i<FLevelData.Count-1 do
  //begin
    Inc(i);
    Inc(i);
    sLine := FLevelData.Strings[i];
    if sLine = '@STARTRES' then
    begin
      inc(i);
      sLine := FLevelData.Strings[i];
      nb := sLine.ToInteger;
      Inc(i);
      for j := 0 to nb-1 do
      begin
        sLine := FLevelData.Strings[i];
        sLeft := sLine.Before('|').Trim;
        sRight := sLine.After('|').Trim;
        lbxBrickItem.Items.Add(sLeft);
        //if not(Assigned(FBrickPack[j])) then
        FBrickPack[j].LoadFromFile(sRight);

        Inc(i);
      end;
      Inc(i);
    end;

    sList := TStringList.Create;
    For j := 0 to  cGridMaxRowCount-1 do
    begin
      sLine := FLevelData.Strings[i];
      sList := sLine.Explode(',');
      //FLevelMap[J,k]
      for k := 0 to sList.Count-1 do
      begin
        sIndex := sList.Strings[k];
        nb := sIndex.ToInteger;
        FLevelMap[j,k].BrickIndex := nb;
        if nb>-1 then
        begin
          FLevelMap[j,k].IsDead := false;
          Inc(FNbBricks);
        end
        else FLevelMap[j,k].IsDead := true;
      end;

      inc(I);
    end;
    FreeAndNil(sList);
end;

procedure TMainForm.pnlViewerPaint(Sender : TObject);
begin
 //
end;

procedure TMainForm.FormCreate(Sender : TObject);
var
  j:Integer;
begin

  FEditMode := False;

  if Not(FEditMode) then
  begin
    panel1.visible := false;
    panel1.height := 0;
    panel2.visible := false;
    panel2.Width := 0;
    self.Width := 1024;
    self.Height := 768;
  end;


  FDisplayBuffer := TBZBitmap.Create(pnlViewer.Width,pnlViewer.Height);
  FGridBuffer := TBZBitmap.Create(cGridWidth, cGridHeight);
  FCadencer := TBZCadencer.Create(Self);
  FCadencer.Enabled := False;
  FCadencer.OnProgress := @CadencerProgress;

  FSoundManager :=  TBZSoundOpenALManager.Create(Self);
  FSoundManager.Cadencer := FCadencer;
  FSoundLibrary := TBZSoundLibrary.Create(self);
  FSoundManager.Sources.Add;
  FSoundManager.Sources.Items[0].SoundLibrary := FSoundLibrary;

  FRacketBitmap := TBZBitmap.Create;
  FRacketBitmap.LoadFromFile('Racket.png');
  FRacketBitmapV := TBZBitmap.Create;
  FRacketBitmapV.LoadFromFile('Racketv.png');
  FRacketPosV.Create(0, 240);
  FRacketPos.Create( FDisplayBuffer.CenterX - FRacketBitmap.CenterX, 700);

  FFloatStep := (1.1*cPi)/FDisplayBuffer.Height;

  FHoverCell := False;
  FMousePos.x := Screen.Width div 2;
  FMousePos.Y := Screen.Height div 2;
  FMouseDown := False;
  FLevelData := TStringList.Create;
  FLevelLoaded := False;


  FGameBoardBackground := TBZBitmap.Create;
  FGameBoardBackground.LoadFromFile('gbBackground.png');
  FSideBarBitmap := TBZBitmap.Create;
  FSideBarBitmap.LoadFromFile('rightbar02.png');

  FBallPong  := TBZBitmap.Create;
  FBallPong.LoadFromFile('ballpong01.png');
  FBallBreak := TBZBitmap.Create;
  FBallBreak.LoadFromFile('BallBreak01.png');

  FBrickexplosion := TBZBitmap.Create;
  FBrickExplosion.LoadFromFile('explosion01.png');

  FListExplosion := TBZVector4iList.Create;


  FBmpFont := TBZBitmapFont.Create('megamini_font.png',16,16);
  FBmpFont.Alphabet := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789()!"';
  FBmpFont.VerticalLowerCaseGapSize := 2;
  FBmpFont.HorizontalLowerCaseGapSize := 0;
  FBmpFont.HorizontalGapSize := 0;
  FBmpFont.VerticalGapSize := 0;
  FBmpFont.SpaceOffset := 0;

  FBmpFontB := TBZBitmapFont.Create('KnightHawks_fontb.png',32,25);
  FBmpFontB.Alphabet := ' !"  % `() +,-./0123456789:; = ?''ABCDEFGHIJKLMNOPQRSTUVWXYZ    _     ';
  FBmpFontB.VerticalLowerCaseGapSize := 2;
  FBmpFontB.HorizontalLowerCaseGapSize := 0;
  FBmpFontB.HorizontalGapSize := 0;
  FBmpFontB.VerticalGapSize := 0;
  FBmpFontB.SpaceOffset := 0;

  FBallPongHotSpot.Create(20,-20);
  FBallBreakHotSpot.Create(16,-12);

  FBallPongPos.Create(511,0);
  FBallBreakPos.Create((FRacketPos.X - FBallBreakHotSpot.x),660); // (FRacketPos.x + FRacketBitmap.CenterX, 660);

  FBallPongRun :=False;
  FBallBreakRun :=False;

  FBallPongDir.Create(6,7);
  FBallBreakDir.Create(-4,-5);

  FNbBricks := 0;
  for j:= 0 to 3 do FBrickPack[j] := TBZBitmap.Create;

  FStarted := False;
  FLoose := False;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
var
  i: integer;
begin
  for i:= 3 downto 0 do
  begin
    if Assigned(FBrickPack[i]) then FreeAndNil(FBrickPack[i]);
  end;
  FreeAndNil(FBmpFontB);
  FreeAndNil(FBmpFont);
  FreeAndNil(FListExplosion);
  FreeAndNil(FBrickExplosion);
  FreeAndNil(FBallBreak);
  FreeAndNil(FBallPong);
  FreeAndNil(FSideBarBitmap);
  FreeAndNil(FGameBoardBackground);
  FreeAndNil(FLevelData);
  FreeAndNil(FSoundManager);
  FreeAndNil(FSoundLibrary);
  FreeAndNil(FCadencer);
  FreeAndNil(FGridBuffer);
  FreeAndNil(FDisplayBuffer);
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FSoundManager.Sources.Items[0].Playing := False;
  FSoundManager.Active := False;
  FCadencer.Enabled := False;
  Screen.Cursor := crDefault;
  CanClose := true;
end;

procedure TMainForm.FormShow(Sender : TObject);

begin
  DoubleBuffered:=true;


  FCadencer.Enabled := False;
  FSoundLibrary.Samples.Clear;
  //FSoundLibrary.Samples.AddFile('breakthepower.s3m','Music1');
  FSoundLibrary.Samples.AddFile('chip1299.xm','Music1');
  FSoundLibrary.Samples.AddFile('impact.wav','ImpactH');
  FSoundLibrary.Samples.AddFile('pop.wav','ImpactV');
  FSoundLibrary.Samples.AddFile('explosion.wav','Explode');
  FSoundLibrary.Samples.AddFile('electricshock.wav','ElectricShock');
  FSoundLibrary.Samples.AddFile('youwin.wav','YouWin');
  FSoundLibrary.Samples.AddFile('splatcrush.wav','YouLoose');

  FSoundManager.Sources.Items[0].SoundName := 'Music1';
  FSoundManager.Sources.Items[0].Volume:= 255;
  FSoundManager.Sources.Items[0].NbLoops := 10;

  FSoundManager.Sources.Add;
  FSoundManager.Sources.Items[1].SoundLibrary := FSoundLibrary;
  FSoundManager.Sources.Items[1].SoundName := 'ImpactH';
  FSoundManager.Sources.Items[1].Volume:= 255;

  FSoundManager.Sources.Add;
  FSoundManager.Sources.Items[2].SoundLibrary := FSoundLibrary;
  FSoundManager.Sources.Items[2].SoundName := 'ImpactV';
  FSoundManager.Sources.Items[2].Volume:= 255;

  FSoundManager.Sources.Add;
  FSoundManager.Sources.Items[3].SoundLibrary := FSoundLibrary;
  FSoundManager.Sources.Items[3].SoundName := 'Explode';
  FSoundManager.Sources.Items[3].Volume:= 255;

  FSoundManager.Sources.Add;
  FSoundManager.Sources.Items[4].SoundLibrary := FSoundLibrary;
  FSoundManager.Sources.Items[4].SoundName := 'ElectricShock';
  FSoundManager.Sources.Items[4].Volume:= 255;

  FSoundManager.Sources.Add;
  FSoundManager.Sources.Items[5].SoundLibrary := FSoundLibrary;
  FSoundManager.Sources.Items[5].SoundName := 'YouWin';
  FSoundManager.Sources.Items[5].Volume:= 255;


  FSoundManager.Sources.Add;
  FSoundManager.Sources.Items[6].SoundLibrary := FSoundLibrary;
  FSoundManager.Sources.Items[6].SoundName := 'YouLoose';
  FSoundManager.Sources.Items[6].Volume:= 255;

  FSoundManager.Active := True;
   if Not(FSoundManager.Sources.Items[0].Playing) then FSoundManager.Sources.Items[0].Playing := True;

  Screen.Cursor := crNone;

  FCadencer.Enabled := True;

  btnLoadLevelClick(self);
end;

procedure TMainForm.pnlViewerMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
  procedure CheckCellHover(mx,my : Integer);
  var
    i, j : integer;
    px,py : integer;
  begin
    FHoverCell := False;
    for i := 0 to  cGridMaxRowCount-1 do
    begin
      py := FGridTop + i * 64;
      for j := 0 to cGridMaxColCount-1 do
      begin
         px := FGridLeft + j * 64;
         FHoverRect.Left := px;
         FHoverRect.Top := py;
         FHoverRect.Right := px+63;
         FHoverRect.Bottom := py+63;
         if FHoverRect.PointInRect(mx,my) then
         begin
           FHoverCellPos.X := j;
           FHoverCellPos.Y := i;
           FHoverCell := True;
           Break;
         end;
      end;
      if FHoverCell then break;
    end;
  end;

begin
 // dx := x-FMousePos.x;
  FMousePos.x := x;
  FMousePos.Y := y;
  CheckCellHover(x,y);
  if FHoverCell  then lblTmp.Caption := x.ToString + ', '+y.ToString + ' --> ' + FHoverRect.ToString
  else lblTmp.Caption := x.ToString + ', '+y.ToString;
  FRacketPos.X := x; //FRacketPos.X;
  if (y>60) and (y<480) then FRacketPosV.Y := y;
  if y<=80 then FRacketPosV.Y := 80;
  if y>=500 then FRacketPosV.Y := 500;

end;

procedure TMainForm.pnlViewerMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseDown := True;

end;

procedure TMainForm.pnlViewerMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if FHoverCell and FMouseDown then
  begin
    FSelectedRect := FHoverRect;
    FSelectedCell := FHoverCellPos;
    FSelected := true;
    if FEditMode then
    begin
      if Button = mbRight then
       begin
         ppmEditMap.PopUp(Self.Left + x,Self.Top+pnlViewer.Top+y);
       end;
    end;
  end;

  if not(FStarted) then FBallPongRun := FStarted;
  if not(FBallPongRun) then FBallPongRun := True;
  if not(FBallBreakRun) then FBallBreakRun := True;

  FMouseDown := False;

end;

procedure TMainForm.btnLoadLevelClick(Sender : TObject);
begin
  FLevelData.Text := Memo1.Lines.Text;
  LoadLevelDataFromFile('');
  FLevelLoaded := True;
end;

procedure TMainForm.lbxBrickItemClick(Sender : TObject);
begin
  if FSelected then
  begin
    FLevelMap[FSelectedCell.y,FSelectedCell.x].BrickIndex := lbxBrickItem.ItemIndex;
  end;
end;

procedure TMainForm.mniDeleteBrickClick(Sender : TObject);
begin
  FLevelMap[FSelectedCell.y,FSelectedCell.x].BrickIndex := -1;
end;

procedure TMainForm.DrawExplosionFrame(dx,dy, idx : Integer);
var
  ox: integer;
begin
  ox := 75 * idx;
  FDisplayBuffer.PutImage(FBrickExplosion,ox,0,75,110,dx-38,dy-55,dmSet,amAlpha);
end;

procedure TMainForm.RenderExplosions;
Var
  i,  k : Integer;
  p : TBZVector4i;
begin
  k := FListExplosion.Count;
  if k > 0 then
  begin
    For i:= 0 to k-1 do
    begin
      if i<FListExplosion.Count then
      begin
        p.Create(-1,-1,-1,-1);
        p := FListExplosion.Items[i];
        if p.z<0 then FListExplosion.Delete(i)
        else
        begin
          DrawExplosionFrame(P.x,P.y,P.z);
          P.Z := P.Z - 1;
          FListExplosion.Items[i] := p;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
begin
  RenderScene(NewTime);
  //FDisplayBuffer.BlurFilter.FXAABlur;
  //FDisplayBuffer.BlurFilter.LinearBlur;
  //DisplayHelp;
  FDisplayBuffer.DrawToCanvas(pnlViewer.Canvas, pnlViewer.ClientRect);
  //Caption:=cFormCaption + ' : '+Format('%.*f FPS', [3, FStopWatch.getFPS]);
end;

procedure TMainForm.DrawLevelGrid;
begin
  FGridLeft := 40; //FDisplayBuffer.CenterX - FGridBuffer.CenterX;
  FGridTop := 8; //FDisplayBuffer.CenterY - FGridBuffer.CenterY;
  FDisplayBuffer.PutImage(FGridBuffer,FGridLeft, FGridTop);
end;

procedure TMainForm.DrawLevel;
var
  x,y, idx : integer;
  bmp : TBZBitmap;
begin



  FGridLeft := 40; //FDisplayBuffer.CenterX - FGridBuffer.CenterX;
  FGridTop := 8; //FDisplayBuffer.CenterY - FGridBuffer.CenterY;

  if FLevelLoaded then
  begin
    for y := 0 to cGridMaxRowCount-1 do
    begin
      for x := 0 to cGridMaxColCount-1 do
      begin
        idx := FLevelMap[y,x].BrickIndex;
        if (idx>-1) and not(FLevelMap[y,x].IsDead)  then
        begin
          bmp := FBrickPack[idx];
          //bmp.PreMultiplyAlpha;
          //showMessage('Draw Brick :'+idx.ToString);
          if (FBallPongRun) and (FBallBreakRun) then   FDisplayBuffer.PutImage(bmp, FGridLeft+x*64, FGridTop+y*64,255,dmSet,amAlpha)
          else FDisplayBuffer.PutImage(bmp, FGridLeft+x*64, FGridTop+y*64,92,dmSet,amAlphaBlend);
        end;
      end;
    end;
  end;

  if FEditMode then
  begin
    if chkShowGrid.Checked then
    begin
      With FGridBuffer.Canvas do
      begin
        pen.Width := 1;
        Pen.Color := clrWhite;
        Pen.Style := ssSolid;
        Brush.Style := TBZBrushStyle.bsClear;
        //Rectangle(FGridLeft,FGridTop,FGridLeft+FGridBuffer.MaxWidth, FGridTop+FGridBuffer.MaxHeight);
      end;

      y := 0;
      While y<= cGridHeight do
      begin
        FDisplayBuffer.Canvas.Pen.Color := clrWhite;
        FDisplayBuffer.Canvas.Line(FGridLeft,FGridTop+y,FGridLeft + FGridBuffer.maxWidth,FGridTop+y);
        y := y + 64;
      end;

      x := 0;
      While x<= cGridWidth do
      begin
        FDisplayBuffer.Canvas.Pen.Color := clrWhite;
        FDisplayBuffer.Canvas.Line(FGridLeft+x,FGridTop,FGridLeft+x,FGridTop+FGridBuffer.MaxHeight);
        x := x + 64;
      end;
    end;
  end;

  if FRacketPos.X>890 then FRacketPos.X := 890;
  FDisplayBuffer.PutImage(FRacketBitmap,FRacketPos.X-FRacketBitmap.CenterX, FracketPos.Y,255,dmSet,amAlpha);
  FDisplayBuffer.PutImage(FRacketBitmapV,FRacketPosV.X, FRacketPosV.Y-FRacketBitmapV.CenterY,255,dmSet,amAlpha);

  if Not(FBallBreakRun) then FDisplayBuffer.PutImage(FBallBreak,(FRacketPos.X - FBallBreakHotSpot.x), FBallBreakPos.y-FBallBreakHotSpot.y,255,dmSet,amAlpha)
  else FDisplayBuffer.PutImage(FBallBreak,FBallBreakPos.x-FBallBreakHotSpot.x, FBallBreakPos.y-FBallBreakHotSpot.y,255,dmSet,amAlpha);

  if (FBallPongRun) and (FBallBreakRun) then FDisplayBuffer.PutImage(FBallPong,FBallPongPos.x-FBallPongHotSpot.x, FBallPongPos.y-FBallPongHotSpot.y,255,dmSet,amAlpha);

  FDisplayBuffer.PutImage(FSideBarBitmap, FDisplayBuffer.MaxWidth-FSideBarBitmap.Width,0,255,dmSet,amAlphaBlendHQ);

  FBmpFont.TextOut(FDisplayBuffer,FDisplayBuffer.MaxWidth-FSideBarBitmap.Width + 40,700,'SCORE : ');
    FBmpFont.TextOut(FDisplayBuffer,FDisplayBuffer.MaxWidth-FSideBarBitmap.Width + 40,730,FPlayerScore.ToString);
//  DrawLevelGrid;
  //
  //pnlViewer.Invalidate;
end;

procedure TMainForm.DrawSelectedCell(x, y : Integer);
begin

end;

procedure TMainForm.RenderScene(NewTime : Double);
var
  CollideRectA, CollideRectB : TBZRect;
  i,j : Integer;
  Collision : Boolean;
  ci : TBZVector4i;
begin

  FDisplayBuffer.PutImage(FGameBoardBackground,0,384,1024,768,0,0);

  if (FNbBricks<=0) or (FLoose=TRUE) then
  begin
    // Partie Gagné
    if Not(FLoose) then
    begin
      if FBallBreakRun then FSoundManager.Sources.Items[5].Playing := True;
      DrawAnimText(UpperCase('You win !'), 350,200,NewTime);
    end
    else
    begin
      if FBallBreakRun then FSoundManager.Sources.Items[6].Playing := True;
      DrawAnimText(UpperCase('You Loose !'), 380,200,NewTime);
    end;

    FBallPongRun := False;
    FBallBreakRun := False;
    FStarted := False;
  end
  else
  begin
    DrawLevel;

    if (Not(FBallPongRun) and not(FBallBreakRun)) then
    begin
      DrawAnimText(UpperCase('Tap Mouse Left Button'), 100,280,NewTime);
      DrawAnimText(UpperCase('to play against V.Breaker'),40,340,NewTime);
    end;

    if FEditMode then
    begin
      if FHoverCell then
      begin
        With FDisplayBuffer.Canvas do
        begin
          Pen.Color := clrBlue;
          Line(FHoverRect.Left, FHoverRect.Top,FHoverRect.Right, FHoverRect.Top);
          Line(FHoverRect.Left, FHoverRect.Top,FHoverRect.left, FHoverRect.Bottom);
          Line(FHoverRect.Right, FHoverRect.Top,FHoverRect.Right, FHoverRect.Bottom);
          Line(FHoverRect.Left, FHoverRect.Bottom,FHoverRect.Right, FHoverRect.Bottom);
        end;
      end;

      if FSelected then
      begin
        With FDisplayBuffer.Canvas do
        begin
          Pen.Color := clrYellow;
          Line(FSelectedRect.Left, FSelectedRect.Top,FSelectedRect.Right, FSelectedRect.Top);
          Line(FSelectedRect.Left, FSelectedRect.Top,FSelectedRect.left, FSelectedRect.Bottom);
          Line(FSelectedRect.Right, FSelectedRect.Top,FSelectedRect.Right, FSelectedRect.Bottom);
          Line(FSelectedRect.Left, FSelectedRect.Bottom,FSelectedRect.Right, FSelectedRect.Bottom);
        end;
      end;
    end;

    if FBallPongRun then
    begin
      FBallPongPos.X := FBallPongPos.X + FBallPongDir.x;
      FBallPongPos.Y := FBallPongPos.Y + FBallPongDir.y;

      if FBallPongPos.y<0 then FBallPongDir.y := -FBallPongDir.y;
      if FBallPongPos.x>2039 then
      begin
        FBallPongDir.x := -FBallPongDir.x; //La balle passe chez le deuxieme joueur
        FSoundManager.Sources.Items[2].Playing := True;
      end;
      if FBallPongPos.y>515 then FBallPongDir.y := -FBallPongDir.y;

      if FBallPongPos.x<45 then
      begin

        if FBallPongPos.x<0 then
        begin
          FBallPongDir.x := -FBallPongDir.x; // You DIE Reset PongBall + Malus
          FPlayerScore := FPlayerScore - 10;
          FSoundManager.Sources.Items[4].Playing := True;
        end
        else
        begin
          CollideRectA.Left := FBallPongPos.x - FBallPongHotSpot.x;
          CollideRectA.Top := FBallPongPos.y - FBallPongHotSpot.y;
          CollideRectA.Right := CollideRectA.Left + 30;
          CollideRectA.Bottom := CollideRectA.Top + 30;

          CollideRectB.Left := 0;
          CollideRectB.Top := FRacketPosV.Y-FRacketBitmapV.CenterY;
          CollideRectB.Right := CollideRectB.Left + FRacketBitmapV.Width;
          CollideRectB.Bottom := CollideRectB.Top + FRacketBitmapV.Height;

          if CollideRectA.OverlapRect(CollideRectB) then
          begin
            FBallPongDir.x := -FBallPongDir.x;
            FSoundManager.Sources.Items[2].Playing := True;
          end;
        end;

      end;
    end;

    if FBallBreakRun then
    begin
      FBallBreakPos.X := FBallBreakPos.X + FBallBreakDir.x;
      FBallBreakPos.Y := FBallBreakPos.Y + FBallBreakDir.Y;

      if FBallBreakPos.x<0 then FBallBreakDir.x := -FBallBreakDir.x;
      if FBallBreakPos.y<8 then FBallBreakDir.y := -FBallBreakDir.y;
      if FBallBreakPos.x>875 then FBallBreakDir.x := -FBallBreakDir.x;
      if FBallBreakPos.y>700 then
      begin
        FBallBreakDir.y := -FBallBreakDir.y; // You DIE !!!!!!
        FLoose := True;
      end;

      if FBallBreakPos.y>560 then // Collision Racket
      begin
        CollideRectA.Left := FBallBreakPos.x - FBallBreakHotSpot.x;
        CollideRectA.Top := FBallBreakPos.y - FBallBreakHotSpot.y;
        CollideRectA.Right := CollideRectA.Left + 30;
        CollideRectA.Bottom := CollideRectA.Top + 30;

        CollideRectB.Left := FRacketPos.x-FRacketBitmap.Centerx;
        CollideRectB.Top :=  FRacketPos.Y;
        CollideRectB.Right := CollideRectB.Left + FRacketBitmap.Width;
        CollideRectB.Bottom := CollideRectB.Top + FRacketBitmap.Height;

        if CollideRectA.OverlapRect(CollideRectB) then
        begin
          FBallBreakDir.y := -FBallBreakDir.y;
          FSoundManager.Sources.Items[1].Playing := True;
        end;

      end
      else // Collision bricks
      begin
        CollideRectA.Left := FBallBreakPos.x - FBallBreakHotSpot.x;
        CollideRectA.Top := FBallBreakPos.y - FBallBreakHotSpot.y;
        CollideRectA.Right := CollideRectA.Left + 30;
        CollideRectA.Bottom := CollideRectA.Top + 30;

        Collision :=false;
        for j :=  cGridMaxRowCount-1 downto 0 do
        begin
          CollideRectB.Top :=  FGridTop+j*64;
          CollideRectB.Bottom := CollideRectB.Top + 64;
          for i := 0 to  cGridMaxColCount-1 do
          begin
              CollideRectB.Left := FGridLeft+i*64;
              CollideRectB.Right := CollideRectB.Left + 64;

              if not(FLevelMap[j,i].IsDead) then
              begin
                if CollideRectA.OverlapRect(CollideRectB) then
                begin
                  //FBallBreakDir.x := -FBallBreakDir.x;
                  FBallBreakDir.y := -FBallBreakDir.y;
                  FPlayerScore := FPlayerScore + 5;
                  FLevelMap[j,i].IsDead := true;
                  Collision := true;
                  ci.Create(CollideRectB.CenterPoint.X,CollideRectB.CenterPoint.Y,23,-1); // Anim explosion = 24 images
                  FListExplosion.Add(ci);
                  Dec(FNbBricks);
                  FSoundManager.Sources.Items[3].Playing := True;
                  Break;
                end;
              end;
          end;
          if Collision then Break;
        end;

        CollideRectB.Left := 0;
        CollideRectB.Top := FRacketPosV.Y-FRacketBitmapV.CenterY;
        CollideRectB.Right := CollideRectB.Left + FRacketBitmapV.Width;
        CollideRectB.Bottom := CollideRectB.Top + FRacketBitmapV.Height;

        if CollideRectA.OverlapRect(CollideRectB) then
        begin
          FBallBreakDir.x := -FBallBreakDir.x;
          FSoundManager.Sources.Items[1].Playing := True;
        end;


      end;
    end;

    RenderExplosions;
  end;
end;

end.

