unit umainform;

{$mode objfpc}{$H+}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN CONSTMIN=16}
{$CODEALIGN RECORDMIN=16}
{$CODEALIGN VARMIN=16}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  BZColors, BZGraphic, BZBitmap, BZVectorMath, BZCadencer, BZStopWatch;

type

  { TMainForm }

  TMainForm = class(TForm)
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormKeyPress(Sender : TObject; var Key : char);
    procedure FormShow(Sender : TObject);

  private
    FBitmapBuffer : TBZBitmap;
    FCadencer : TBZCadencer;
    FStopWatch : TBZStopWatch;

  protected
    FDrawType : Integer;
    FrameCounter :Integer;

    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
  public
    procedure AnimateScene;
    Procedure RenderScene(delta:Single);
    Procedure InitScene;
    Procedure InitColorMap;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses  BZUtils,BZMath;
{ TMainForm }
const
  DRAWTYPE_BEZIER  = 0;
  DRAWTYPE_DBLLINE = 1;
  DRAWTYPE_POLYGON = 2;

  //cDrawType  = DRAWTYPE_BEZIER;

  cMovers    = 4;
  cFollowers = 40;

  cSpeedMax : single = 0.20;
  cSpeedMin : single = 0.10;

  cColorMin = 100;
  cColorMax = 250;

  cColorIncMin = 50;
  cColorIncMax = 150;

type
  {$CODEALIGN RECORDMIN=16}
  pCatchers = ^TCatchers;
  TCatchers = packed record

    Pos   : TBZVector2f;
    Vel   : TBZVector2f;

    Color : TBZColor;
    Follow: pCatchers;
  end;

  //pMovers = ^TMovers;
  TMovers = packed record
    Pos : TBZVector2f;
    Vel : TBZVector2f;
  end;
  {$CODEALIGN RECORDMIN=4}
var
  Catchers  : array[0..cMovers-1, 0..cFollowers-1] of TCatchers;
  Movers    : array[0..cMovers-1] of TMovers;
  LineColor : record
    Ri, Gi, Bi,
    R, G, B : single
  end;

  MoveXMin,
  MoveXMax,
  MoveYMin,
  MoveYMax : integer;

procedure TMainForm.AnimateScene;
var M, F: integer;
    //DX, DY, FPS : single;
    {$CODEALIGN VARMIN=16}
    Delta : TBZVector2f;
    {$CODEALIGN VARMIN=4}
begin

  { Deplacement des Catchers et Movers }
  for M := 0 to cMovers-1 do
  begin
    { Les Movers evoluent dans une zone definie par
      MoveXMin, MoveXMax et MoveYMin, MoveYMax }
    Movers[M].Pos := Movers[M].Pos + Movers[M].Vel;
    //Movers[M].Pos.X := Movers[M].Pos.X + Movers[M].Vel.X;
    if (Movers[M].Pos.X <= MoveXMin) or (Movers[M].Pos.X >= MoveXMax) then
      Movers[M].Vel.X :=-Movers[M].Vel.X;// * -1;

    //Movers[M].Pos.Y := Movers[M].Pos.Y + Movers[M].Vel.Y;
    if (Movers[M].Pos.Y <= MoveYMin) or (Movers[M].Pos.Y >= MoveYMax) then
      Movers[M].Vel.Y := -Movers[M].Vel.Y;// * -1;

    { Les premiers Catchers ( Catchers[M,0] ) doit attraper les Movers }
    //DX := Catchers[M, 0].Vel.X*(Movers[M].Pos.X - Catchers[M, 0].Pos.X);
    //DY := Catchers[M, 0].Vel.Y*(Movers[M].Pos.Y - Catchers[M, 0].Pos.Y);
    Delta:= Catchers[M, 0].Vel*(Movers[M].Pos - Catchers[M, 0].Pos);
    if Delta.X = 0 then
      Catchers[M, 0].Pos.X := Movers[M].Pos.X
    else
      Catchers[M, 0].Pos.X := Catchers[M, 0].Pos.X + Delta.X;


    if Delta.Y = 0 then
      Catchers[M, 0].Pos.Y := Movers[M].Pos.Y
    else
      Catchers[M, 0].Pos.Y := Catchers[M, 0].Pos.Y + Delta.Y;

    { Les autres Catchers ( Catchers[M, F > 0] ) doivent suivre les premiers
      Catchers }
    for F := 1 to cFollowers-1 do
      if Catchers[M,F].Follow <> nil then
      begin
        //DX := Catchers[M,F].Vel.X*(Catchers[M,F].Follow^.Pos.X - Catchers[M,F].Pos.X);
        Delta := Catchers[M,F].Vel*(Catchers[M,F].Follow^.Pos - Catchers[M,F].Pos);
        if Delta.X = 0 then
          Catchers[M,F].Pos.X := Catchers[M,F].Follow^.Pos.X
        else
          Catchers[M,F].Pos.X := Catchers[M,F].Pos.X + Delta.X;

        //DY := Catchers[M,F].Vel.Y*(Catchers[M,F].Follow^.Pos.Y - Catchers[M,F].Pos.Y);
        if Delta.Y = 0 then
          Catchers[M,F].Pos.Y := Catchers[M,F].Follow^.Pos.Y
        else
          Catchers[M,F].Pos.Y := Catchers[M,F].Pos.Y + Delta.Y;
      end;
  end;
end;

procedure TMainForm.RenderScene(delta:Single);
var F   : integer;
    Pts : TBZArrayOfFloatPoints;//array[0..3] of TBZPoint;
    {$CODEALIGN VARMIN=16}
    pt1,pt2, pt3, pt4: TBZFloatPoint; //TBZVector2i;
    {$CODEALIGN VARMIN=4}
    AColor : TBZColor;
begin



  FBitmapBuffer.ColorFilter.AdjustBrightness(-0.15);
  //FastBlur; //BoxBlur(2); //GaussianBoxBlur(0.5); //FastBlur;// ;
  FBitmapBuffer.BlurFilter.FastBlur;
  //FBitmapBuffer.Clear(clrBlack);

  { Incrementation de la couleur des Catchers }
  LineColor.R := LineColor.R + LineColor.Ri;
  if (LineColor.R <= cColorMin) or (LineColor.R >= cColorMax) then
    LineColor.Ri := -LineColor.Ri;// * -1;

  LineColor.G := LineColor.G + LineColor.Gi;
  if (LineColor.G <= cColorMin) or (LineColor.G >= cColorMax) then
    LineColor.Gi := -LineColor.Gi;// * -1;

  LineColor.B := LineColor.B + LineColor.Bi;
  if (LineColor.B <= cColorMin) or (LineColor.B >= cColorMax) then
    LineColor.Bi := -LineColor.Bi;// * -1;

  AColor.Create(Round(LineColor.R), Round(LineColor.G), Round(LineColor.B),255); //Catchers[0,F].Color.Alpha);
  FBitmapBuffer.Canvas.Pen.Color := AColor;

  { Dessin des Catchers, ici on utilisera des courbes de Bezier! }
  for F := 0 to cFollowers-1 do
  begin
    { On redefinie la couleur }
   // Catchers[0,F].Color.Create(Round(LineColor.R), Round(LineColor.G), Round(LineColor.B),Catchers[0,F].Color.Alpha);
    FBitmapBuffer.Canvas.Pen.Color := AColor;
    AColor := AColor.Darken(0.10);

    //:=  Catchers[0,F].Color;

    { On dessine les courbes }
    pt1 := Catchers[0,F].Pos; //.Round;
    pt2 := Catchers[2,F].Pos; //.Round;
    pt3 := Catchers[1,F].Pos; //.Round;
    pt4 := Catchers[3,F].Pos; //.Round;

    case FDrawType of
      DRAWTYPE_BEZIER  :
      begin
        FBitmapBuffer.Canvas.BezierCurve(pt1, pt2, pt3, pt4);
      end;
      DRAWTYPE_DBLLINE :
      begin
        FBitmapBuffer.Canvas.Line(pt1.x,pt1.y,pt2.x,pt2.Y);
        FBitmapBuffer.Canvas.Line(pt3.x,pt3.y,pt4.x,pt4.Y);
      end;
      DRAWTYPE_POLYGON :
      begin
        FBitmapBuffer.Canvas.Brush.Style := bsClear;
        pts := TBZArrayOfFloatPoints.Create;
        pts.Add(pt1);
        pts.Add(pt2);
        pts.Add(pt3);
        pts.Add(pt4);
        //Pts[0] := TBZPoint(Catchers[0,F].Pos.Round);
        //Pts[1] := TBZPoint(Catchers[1,F].Pos.Round);
        //Pts[2] := TBZPoint(Catchers[2,F].Pos.Round);
        //Pts[3] := TBZPoint(Catchers[3,F].Pos.Round);
        FBitmapBuffer.Canvas.Polygon(Pts);
        FreeAndNil(pts);
      end;
    end;
    // Draw Points

  end;

end;

procedure TMainForm.InitScene;
var M,F: integer;
    SP : single;
const
  SpdInv : array[0..1] of integer = (1,-1);
begin
  { Pour generer des nombres aleatoires different a chaque lancement}
  Randomize;

  { Definition des limites de deplacement des Movers}
  MoveXMin := -20;
  MoveYMin := -20;
  MoveXMax := ClientWidth + 20;
  MoveYMax := ClientHeight + 20;

  { Selection d'une couleur de depart et des incrementeurs de cette
    derniere.}
  LineColor.Ri := ((Random(cColorIncMax)+cColorIncMin)*0.001) * SpdInv[Random(100) mod 2];
  LineColor.Gi := ((Random(cColorIncMax)+cColorIncMin)*0.001) * SpdInv[Random(100) mod 2];
  LineColor.Bi := ((Random(cColorIncMax)+cColorIncMin)*0.001) * SpdInv[Random(100) mod 2];
  LineColor.R := Random(128)+127;
  LineColor.G := Random(128)+127;
  LineColor.B := Random(128)+127;

  { Initialisation des Catchers et Movers}
  for M := 0 to cMovers-1 do
  begin
    { Les movers sont placé aléatoirement dans la zone definie par
      MoveXMin,MoveXMax et MoveYMin,MoveYMax. }
    Movers[M].Pos.X := Random(MoveXMax-20)+MoveXMin+10;
    Movers[M].Pos.Y := Random(MoveYMax-20)+MoveYMin+10;
    Movers[M].Vel.X := ((Random(525)+275)*0.01)*SpdInv[Random(100) mod 2];
    Movers[M].Vel.Y := ((Random(525)+275)*0.01)*SpdInv[Random(100) mod 2];

    { Les Catchers }
    for F := 0 to cFollowers-1 do
    begin
      if F > 0 then
        Catchers[M,F].Follow := @Catchers[M,F-1]
      else
        Catchers[M,F].Follow := nil;

      SP := cSpeedMin + ((cSpeedMax-cSpeedMin)/cFollowers)*(cFollowers-F);

      Catchers[M,F].Pos.X := Random(MoveXMax-60)+MoveXMin+30;
      Catchers[M,F].Pos.Y := Random(MoveYMax-60)+MoveYMin+30;
      Catchers[M,F].Vel.X := SP;
      Catchers[M,F].Vel.Y := SP;

      Catchers[M,F].Color.Create(round(LineColor.R), round(LineColor.G),round(LineColor.B),round(200/cFollowers*(cFollowers-F)));
    end;
  end;

  FCadencer := TBZCadencer.Create(self);
  FCadencer.OnProgress := @CadencerProgress;

  FStopWatch := TBZStopWatch.Create(self);

  Randomize;
  FBitmapBuffer := TBZBitmap.Create;
  FBitmapBuffer.SetSize(Width,Height);
  FBitmapBuffer.Clear(clrBlack);

  //FBitmapBuffer.Clipping := True;
  //FBitmapBuffer.ClipRect.Contract(100,100);

  //FBitmapBuffer.UsePalette := True; // if we uses palette

  // Create Color Map
  InitColorMap;

  FrameCounter:=0;
  FDrawType := DRAWTYPE_BEZIER;
end;

procedure TMainForm.InitColorMap;
begin
// Init Palette color map if needed
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FStopWatch.Stop;
  FCadencer.Enabled := False;
  //Timer1.Enabled := False;
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
//  FBitmapBuffer.Free;
end;

procedure TMainForm.FormKeyPress(Sender : TObject; var Key : char);
begin
    if key = #27 then Close;
    if Key='1' then FDrawType := 0;
    if Key='2' then FDrawType := 1;
    if Key='3' then FDrawType := 2;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  DoubleBuffered:=true;
  FStopWatch.Start;
  FCadencer.Enabled := True;
  //Timer1.Enabled := true;
end;

procedure TMainForm.CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
begin

  RenderScene(deltaTime);
  FBitmapBuffer.DrawToCanvas(Canvas, ClientRect);
  //Inc(FrameCounter);
  AnimateScene;
  Caption:='BZScene BoZoon Demo (Hit : 1,2,3) : '+Format('%.*f FPS', [3, FStopWatch.getFPS]);
end;

end.

