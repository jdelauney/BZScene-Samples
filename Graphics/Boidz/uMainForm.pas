unit uMainForm;

{$mode objfpc}{$H+}

// ALIGNEMENT
{$ifdef cpu64}
  {$ALIGN 16}

  {$CODEALIGN CONSTMIN=16}
  {$CODEALIGN LOCALMIN=16}
  {$CODEALIGN VARMIN=16}
{$endif}

{$DEFINE USE_FASTMATH}

{===============================================================================
 D'après le code source original en delphi :
 - http://codes-sources.commentcamarche.net/source/46214-boids-de-craig-reynoldsAuteur  : cs_barbichetteDate    : 03/08/2013

 Description :
 =============

 C'est une simulation de vol d'oiseau en groupe (ou de banc de poisson)
 Créer par Craig Reynolds, cette simulation se base sur un algo simple

 3 forces agissent sur chaque individu (boids):
 - chaque boids aligne sa direction sur celle de ses voisins.
 - chaque boids est attiré au centre de ses voisins
 - mais chaque boids est repoussé par les autres pour éviter le surpeuplement

 Enfin, une dernière force, classique attire les boids vers la souris.
 Dans tous les cas, le boids ne réagis que par rapport aux voisins qu'il voie
 (distance max et angle de vu). Il ne voit pas les boids derrière lui ni s'ils sont trop loin.
================================================================================}
interface

uses
  LCLIntf, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  BZColors, BZVectorMath,
  BZGraphic, BZBitmap,
  BZCadencer, BZStopWatch;


  { TMainForm }
Const
  maxboidz = 499;
  Cursor_attract = 1/150;    // 1/150
  cohesion_attract = 1/25;   // 1/25
  Align_attract = 1/4;       // 1/4
  Separation_repuls = 1/25;  // 1/25
  Vitesse_Max = 30;
  Distance_Max = 50*50;
  Angle_Vision = 90; //soit 180° au total;

type
  TMainForm = class(TForm)
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormResize(Sender : TObject);
    procedure FormShow(Sender : TObject);
  private
    FBitmapBuffer : TBZBitmap;
    FCadencer : TBZCadencer;
    FStopWatch : TBZStopWatch;
    {$ifdef cpu64}
      {$CODEALIGN RECORDMIN=16}
      FBoidz : array[0..MaxBoidz] of TBZVector4f;
      {$CODEALIGN RECORDMIN=4}
    {$else}
      FBoidz : array[0..MaxBoidz] of TBZVector4f;
    {$endif}

    FrameCounter :Integer;
    aCounter : Byte;

    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
  public
    procedure AnimateScene;
    Procedure RenderScene;
    Procedure InitScene;
    Procedure InitColorMap;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses BZMath;

// vérifie si b1 vois b2
function CheckAngleOfView(b1,b2:TBZVector4f):boolean;
var
 angle:extended;
 l:Single;
begin
 b1.UV :=b1.UV - b2.UV;
 angle:=abs(ArcTan2(b1.x,b1.y)*cPIDiv180); //180/cPI);
 l:=b1.UV.LengthSquare;
 result:=(l<Distance_Max) and (angle<=Angle_Vision);
end;

{ TMainForm }

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FStopWatch.Stop;
  FCadencer.Enabled := False;
  FCadencer.OnProgress := nil;
  Sleep(100);   // Pour permettre à la derniere frame de  s'afficher correctement
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  InitScene;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FStopWatch);
  FreeAndNil(FCadencer);
  FreeAndNil(FBitmapBuffer);
end;

procedure TMainForm.FormResize(Sender : TObject);
begin
  FStopWatch.Stop;
  FCadencer.Enabled := False;
  Sleep(100);
  FBitmapBuffer.SetSize(ClientWidth,ClientHeight);
  FrameCounter := 0;
  FStopWatch.Start();
  FCadencer.Enabled := True;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  DoubleBuffered:=true;
  FStopWatch.Start();
  FCadencer.Enabled := True;
end;

procedure TMainForm.CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
begin
  AnimateScene;
  RenderScene;
  FBitmapBuffer.DrawToCanvas(Canvas, ClientRect);
  Caption:='BZScene - Demo - BoïdZ : '+Format('%.*f FPS', [3, FStopWatch.getFPS]);
end;

procedure TMainForm.AnimateScene;
var
 {$ifdef cpu64}
   {$CODEALIGN VARMIN=16}
   cohesion,balign,separation,center: TBZVector2f;
   ct : TBZVector2f;
   ptc, ptcx : TBZVector2f;
   {$CODEALIGN VARMIN=4}
 {$else}
   cohesion,balign,separation,center: TBZVector2f;
   ct : TBZVector2f;
   ptc, ptcx : TBZVector2f;
 {$endif}
 i,j:integer;
 pt:tpoint;
 c,rc:Single;

begin
  // position de la souris

  ptcx.Create(FBitmapBuffer.CenterX,FBitmapBuffer.CenterY);

  GetCursorPos(pt);
  pt := Mainform.ScreenToClient(pt);

  ptc.Create(pt.x,pt.y);
  //ptc.Create(pt.x+(-320+Random(320)),pt.y+(-240+Random(240)));
  //ptc.X := ptc.x - (Mainform.ClientWidth shr 1) ;
  //ptc.Y := ptc.Y - (Mainform.ClientHeight shr 1) ;
  ptc :=ptc - ptcx;

  // pour chaque boïde
  for i:=0 to maxBoidz do
  begin
   c:=0;
   cohesion.Create(0,0);
   bAlign.Create(0,0);
   separation.Create(0,0);
   // ils suivent le comportement des voisins
   // on parcours toute la liste
   for j:=0 to maxBoidz do
   begin
    // si le FBoidz J est dans le champs de vision de I
    // càd : pas trop loin et devant lui
    if (i<>j) and CheckAngleOfView(FBoidz[i],FBoidz[j]) then
     begin
      // alors on traite les 3 forces qui régissent de comportement du groupe
      c:=c+1;
      // il se rapproche du centre de masse de ses voisins
      Cohesion := Cohesion + FBoidz[j].UV;
      // il aligne sa direction sur celle des autres
      bAlign := bAlign + FBoidz[j].ST;
      // mais il s'éloigne si ils sont trop nombreux
      Separation := Separation - (FBoidz[j].UV - FBoidz[i].UV);
     end;
   end;
   // si il y a des voisins, on fini les calculs des moyennes
   if c<>0 then
    begin
     rc := 1/c;
      ct.Create(rc,rc);
      cohesion    := ((cohesion * ct) - FBoidz[i].UV) * Cohesion_attract;
      bAlign     := ((bAlign * ct) - FBoidz[i].ST) * Align_attract;
      separation := separation * Separation_Repuls;
    end;
   // la dernière force les poussent tous vers la souris
   Center := (ptc*10-FBoidz[i].UV) * Cursor_Attract;
   // on combine toutes les infos pour avoir la nouvelle vitesse
   FBoidz[i].ST := FBoidz[i].ST + cohesion + bAlign + separation + center;
   // attention, si il va trop vite, on le freine
  // c:=round(sqrt(boides[i].ST.x*boides[i].ST.x+boides[i].ST.y*boides[i].ST.y));
   c:=FBoidz[i].ST.Length;
   if c>Vitesse_Max then
    begin
     //c:=(Vitesse_Max / c);
     FBoidz[i].ST := (FBoidz[i].ST * Vitesse_Max) / c//* c;
    end;
   // on le déplace en fonction de sa vitesse
   FBoidz[i].UV := FBoidz[i].UV + (FBoidz[i].ST);

   //rebond sur les bords
   //if FBoidz[i].UV.x>FBitmapBuffer.width then FBoidz[i].ST.x:=-(FBoidz[i].ST.x)
   //else if FBoidz[i].UV.x<0 then FBoidz[i].ST.x:=-(FBoidz[i].ST.x);
   //if FBoidz[i].UV.y>FBitmapBuffer.height then FBoidz[i].ST.y:=-(FBoidz[i].ST.y)
   //else if FBoidz[i].UV.y<0 then FBoidz[i].ST.y:=-(FBoidz[i].ST.y);

   // univers fermé
     if FBoidz[i].UV.x>FBitmapBuffer.width then FBoidz[i].UV.x:=FBoidz[i].UV.x-FBitmapBuffer.width;
     if FBoidz[i].UV.x<0 then FBoidz[i].UV.x:=FBoidz[i].UV.x+FBitmapBuffer.width;
     if FBoidz[i].UV.y>FBitmapBuffer.height then FBoidz[i].UV.y:=FBoidz[i].UV.y-FBitmapBuffer.height;
     if FBoidz[i].UV.y<0 then FBoidz[i].UV.y:=FBoidz[i].UV.y+FBitmapBuffer.height;
  end;
end;

procedure TMainForm.RenderScene;
var
 {$CODEALIGN LOCALMIN=16}
 b : TBZVector4f;
 p : TBZVector4i;
 CurColor : TBZColor;
 {$CODEALIGN LOCALMIN=4}
 i,c : Integer;
begin
  AnimateScene;
  // on efface le buffer et on affiche les boïdes

  //if aCounter = 15 then
  //begin
  //  aCounter := 0;
  //end;
  //db.Create(10,10,10,10);

  FBitmapBuffer.ColorFilter.AdjustBrightness(-0.15);
  FBitmapBuffer.BlurFilter.FastBlur; //GaussianSplitBlur(2);
//  FBitmapBuffer.Clear(clrBlack);

  for i:=0 to maxboidz do
  begin
    b := FBoidz[i];
    p := b.Round;
    //calcul de la direction de déplacement pour la couleur
    c:=round((ArcTan2(b.ST.X,b.ST.Y)*c180divPI)+180); //*cPIDiv180)+180); //
    CurColor := FBitmapBuffer.ColorManager.Palette.Colors[c].Value;
    with FBitmapBuffer.Canvas do
    begin
      Pen.Color :=  CurColor;
      // dessine un traits de la longueur de la vitesse
      //  ShowMessage('Line : '+P.UV.x.ToString+' , '+P.UV.y.ToString+' --> '+(P.UV.x+P.ST.x).ToString+' , '+(P.UV.y+P.ST.y).ToString);
      Line(P.UV.x,P.UV.y,(P.UV.x+P.ST.x),(P.UV.y+P.ST.y));
      //MoveTo(P.UV.x,P.UV.y);
      //LineTo((P.UV.x+P.ST.x),(P.UV.y+P.ST.y));
    end;
  end;

{  With FBitmapBuffer.Canvas do
  begin
    Font.Quality:=fqAntialiased;
    Font.Size := 32;
    Font.Color := clrRed;
    TextOut(FBitmapBuffer.CenterX-154,20,'Craig Reynolds''s BoidZ');
    DrawMode.PixelMode := dmSet;
    DrawMode.AlphaMode := amAlpha;
    Brush.Style := bsSolid;
    Brush.Color.Create(192,220,192,192);
    Pen.Color := clrBlack;
    Pen.Style := psSolid;
    Rectangle(FBitmapBuffer.CenterX-154,70,580,110);

    Font.Size := 16;
    Font.Color.Create(255,255,255,192);
    //Font.Color.Alpha := 192;
    TextOut(FBitmapBuffer.CenterX-124,80,'Move your mouse around the windows');
    Font.Color := clrBlack;
    DrawMode.AlphaMode := amNone;
    TextOut(FBitmapBuffer.CenterX-122,82,'Move your mouse around the windows');
  end; }
end;

procedure TMainForm.InitScene;
Var
 i: Integer;
begin

  FCadencer := TBZCadencer.Create(self);
  FCadencer.OnProgress := @CadencerProgress;


  FStopWatch := TBZStopWatch.Create(self);

  Randomize;
  FBitmapBuffer := TBZBitmap.Create;
  FBitmapBuffer.SetSize(Width,Height);
  FBitmapBuffer.Clear(clrBlack);
  FBitmapBuffer.UsePalette := True;

  // Create Color Map
  InitColorMap;
  FrameCounter:=0;

  // on initialise une vitesse et une place aléatoire pour le départ
  for i:=0 to maxboidz do
  with Fboidz[i] do
  begin
    ST.x:=10+random(FBitmapBuffer.Width-10);
    ST.y:=10+random(FBitmapBuffer.Height-10);
    UV.x:=10+random(Vitesse_Max-10);
    UV.y:=10+random(Vitesse_Max-10);
  end;

  aCounter :=0;
end;

procedure TMainForm.InitColorMap;
Var
 i : Integer;
 nc : TBZColor;
begin
  // on crée la palette de oculeur pour l'affichage
  for i:=0 to 360 do
  begin
    Case (i div 60) of
       0,6 : nc.Create(255,(i Mod 60)*255 div 60,0);
       1   : nc.Create(255-(i Mod 60)*255 div 60,255,0);
       2   : nc.Create(0,255,(i Mod 60)*255 div 60);
       3   : nc.Create(0,255-(i Mod 60)*255 div 60,255);
       4   : nc.Create((i Mod 60)*255 div 60,0,255);
       5   : nc.Create(255,0,255-(i Mod 60)*255 div 60);
    end;
    FBitmapBuffer.ColorManager.CreateColor(nc);
  end;
end;

end.

