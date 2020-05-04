unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  LclType,
  BZColors, BZGraphic, BZBitmap, BZVectorMath, BZVectorMathEx, BZCadencer;

const
  cRadius = 4;
  cUnitScale = 5;
  cGridSquareSize = 10;

  cBullets : array[0..38] of TBZVector2f =
  (
 	(x:-1;y:-1),
 	(x:-1;y:-0.75),
 	(x:-1;y:-0.50),
 	(x:-1;y:-0.25),
 	(x:-1;y:0),
 	(x:-1;y:0.25),
 	(x:-1;y:0.50),
 	(x:-1;y:0.75),
 	(x:-1;y:1),

 	(x:-0.83;y:0.83),
 	(x:-0.66;y:0.66),
 	(x:-0.50;y:0.50),
 	(x:-0.33;y:0.33),
 	(x:-0.16;y:0.16),

 	(x:-0.83;y:-0.83),
 	(x:-0.66;y:-0.66),
 	(x:-0.50;y:-0.50),
 	(x:-0.33;y:-0.33),
 	(x:-0.16;y:-0.16),

 	(x:0;y:0),

 	(x:1;y:-1),
 	(x:1;y:-0.75),
 	(x:1;y:-0.50),
 	(x:1;y:-0.25),
 	(x:1;y:0),
 	(x:1;y:0.25),
 	(x:1;y:0.50),
 	(x:1;y:0.75),
 	(x:1;y:1),

 	(x:0.83;y:0.83),
 	(x:0.66;y:0.66),
 	(x:0.50;y:0.50),
 	(x:0.33;y:0.33),
 	(x:0.16;y:0.16),

 	(x:0.83;y:-0.83),
 	(x:0.66;y:-0.66),
 	(x:0.50;y:-0.50),
 	(x:0.33;y:-0.33),
 	(x:0.16;y:-0.16)
 );
type

  { TMainForm }

  TMainForm = class(TForm)
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormShow(Sender : TObject);
    procedure FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
  private
    FCadencer : TBZCadencer;
    FDisplayBuffer : TBZBitmap;
    FPoints : Array[0..3] of TBZVector2f;
    FGridCenter : TBZVector2f;
    FTranslateVector,  FShearVector, FScaleVector, FWorldCenter : TBZVector2f;
    FRotateAngle : Single;
    FCellX, FCellY : Integer;

  protected
    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
  public
    function ConvertWorldToScreen(aPoint : TBZVector2f) : TBZVector2i;

    procedure InitGrid;
    procedure InitPoints;

    procedure DrawGrid;
    procedure DrawPoints;
    procedure DrawHelp;

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FDisplayBuffer := TBZBitmap.Create(Self.Width,Self.Height);
  FCadencer := TBZCadencer.Create(self);
  FCadencer.Enabled := False;
  FCadencer.OnProgress := @CadencerProgress;
  InitGrid;
  InitPoints;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FDisplayBuffer);
  FreeAndNil(FCadencer);
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FCadencer.Enabled := False;
  CanClose := True;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  FCadencer.Enabled := True;
end;

procedure TMainForm.FormKeyDown(Sender : TObject; var Key : Word; Shift : TShiftState);
begin

  if Key = vk_Left then FTranslateVector.x := FTranslateVector.x - 0.25;
  if Key = vk_Right then FTranslateVector.x := FTranslateVector.x + 0.25;
  if Key = vk_Down then FTranslateVector.y := FTranslateVector.y + 0.25;
  if Key = vk_Up then FTranslateVector.y := FTranslateVector.y - 0.25;
  if Key = vk_Next then FRotateAngle := FRotateAngle + 0.001;
  if Key = vk_Prior then FRotateAngle := FRotateAngle - 0.001;

  if Key = vk_Add then FScaleVector.y := FScaleVector.y + 0.1;
  if Key = vk_Subtract then FScaleVector.y := FScaleVector.y - 0.1;
  if Key = vk_Multiply then FScaleVector.x := FScaleVector.x + 0.1;
  if Key = vk_Divide then FScaleVector.x := FScaleVector.x - 0.1;

  if Key = vk_Numpad4 then FShearVector.x := FShearVector.x - 0.01;
  if Key = vk_Numpad6 then FShearVector.x := FShearVector.x + 0.01;
  if Key = vk_Numpad8 then FShearVector.y := FShearVector.y + 0.01;
  if Key = vk_Numpad2 then FShearVector.y := FShearVector.y - 0.01;

end;

procedure TMainForm.CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
begin
  FDisplayBuffer.Clear(clrBlack);
  DrawGrid;
  DrawPoints;
  DrawHelp;
  FDisplayBuffer.DrawToCanvas(Self.Canvas, Self.ClientRect);
end;

function TMainForm.ConvertWorldToScreen(aPoint : TBZVector2f) : TBZVector2i;
var
  P : TBZVector2f;
begin
//  aPoint.y := -aPoint.y;
  p := FGridCenter + (APoint * cGridSquareSize);
  Result := P.Round;
  //Result.x := Round(P.x);
  //Result.y := Round(P.y);
end;

procedure TMainForm.InitGrid;
begin
  FGridCenter.x := FDisplayBuffer.CenterX;
  FGridCenter.y := FDisplayBuffer.CenterY;
  FCellx := ((FDisplayBuffer.Width div cGridSquareSize) div 2) +1;
  FCelly := ((FDisplayBuffer.Height div cGridSquareSize) div 2) +1;
  FWorldCenter.Create(FCellx / 2 , FCelly / 2);
end;

procedure TMainForm.InitPoints;
begin
  FPoints[0].Create(-1,1);
  FPoints[1].Create(1,1);
  FPoints[2].Create(1,-1);
  FPoints[3].Create(-1,-1);
  FTranslateVector.Create(0,0);
  FRotateAngle := 0;
  FShearVector.Create(0,0);
  FScaleVector.Create(1,1);
end;

procedure TMainForm.DrawGrid;
var
 i, p : integer;
begin
  FDisplayBuffer.Clear(clrGray20);
  With FDisplayBuffer.Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Style := ssSolid;
    Pen.Color := clrGray;
    Pen.Width := 1;
  end;
  For i := 1 to FCelly*2 do
  begin
    with FDisplayBuffer.Canvas do
    begin
      p := (cGridSquareSize*i) - 1;
      moveto(0,p);
      LineTo(FDisplayBuffer.MaxWidth,p);
    end;
  end;
  for i := 1 to FCellx*2 do
  begin
    with FDisplayBuffer.Canvas do
    begin
      p := (cGridSquareSize*i) -1;
      moveto(p,0);
      LineTo(p, FDisplayBuffer.MaxHeight);
    end;
  end;
  with FDisplayBuffer.Canvas do
  begin

    Pen.Width := 1;
    Pen.Color := clrLime;
    moveto(Round(FGridCenter.x),0);
    lineto(Round(FGridCenter.x), FDisplayBuffer.MaxHeight);
    Pen.Color := clrRed;
    moveto(0,Round(FGridCenter.y));
    lineto(FDisplayBuffer.MaxWidth, Round(FGridCenter.y));
    Brush.Style := bsClear;
    Pen.Color := clrBlack;
    Rectangle(0,0,FDisplayBuffer.MaxWidth, FDisplayBuffer.MaxHeight);
    Font.Color := clrGreen;
    TextOut(Round(FGridCenter.x) - 24,14,'-Y');
    Font.Color := clrGreen;
    TextOut(Round(FGridCenter.x) - 24,FDisplayBuffer.MaxHeight-4,'+Y');
    Font.Color := clrRed;
    TextOut(5,Round(FGridCenter.y + 14),'-X');
    Font.Color := clrRed;
    TextOut(FDisplayBuffer.MaxWidth-18,Round(FGridCenter.y + 14),'+X');
  end;

end;

procedure TMainForm.DrawPoints;
var
  i : Integer;
  opw, pw : Array[0..38] of TBZVector2i;
  pt, opt : TBZVector2f;
  FMatTransform : TBZAffineMatrix;
  PerspectiveMatrix : TBZAffineMatrix;
begin
  //PerspectiveMatrix.CreatePerspectiveMatrix(0,0,1,1,0,0,1,0.25,1,0.75,0,1);
  For i := 0 to 38 do
  begin
    with FDisplayBuffer.Canvas do
    begin
      Brush.Style := bsSolid;

      Pen.Style := ssSolid;
      Pen.Width := 1;
      pt := cBullets[i] * cUnitScale; // FPoints[i] * cUnitScale;
      //pt.y := -pt.y;
      opt := pt;
      //FMatTransform.Create(FScaleVector, FShearVector, FTranslateVector, FRotateAngle);
      FMatTransform.CreateIdentityMatrix;
      FMatTransform.Translate(FTranslateVector);
      FMatTransform.Rotate(FRotateAngle);
      FMatTransform.Scale(FScaleVector);
      FMatTransform.Shear(FShearVector);
      //FMatTransform := PerspectiveMatrix * FMatTransform;
      //FMatTransform.Translate(-FWorldCenter);
      pt := FMatTransform * pt;

      //pt := pt * FScaleVector;
      //pt := pt.Rotate(FRotateAngle, cNullVector2f);
      //pt := pt + FTranslateVector;

      opw[i] := ConvertWorldToScreen(opt);
      pw[i] := ConvertWorldToScreen(pt);

      Brush.Color := clrBlack;
      Pen.Color := clrWhite;
      Circle(opw[i].x, opw[i].y, cRadius);
      Brush.Color := clrCyan;
      Pen.Color := clrWhite;
      Circle(pw[i].x, pw[i].y, cRadius);
      Pen.Color := clrBlack;
      Line(opw[i].X, opw[i].y, pw[i].X, pw[i].y);

      //if i>0 then
      //begin
      //  Pen.Color := clrFuchsia;
      //  LineTo(pw[i].x, pw[i].y);
      //end else MoveTo(pw[i].x, pw[i].y);
    end;
  end;
  //with FDisplayBuffer.Canvas do
  //begin
  //  LineTo(pw[0].x, pw[0].y);
  //end;
end;

procedure TMainForm.DrawHelp;
begin
  With FDisplayBuffer.Canvas do
  begin
    DrawMode.AlphaMode := amAlphaBlend;
    DrawMode.MasterAlpha := 192;
    Brush.Style := bsSolid;
    Brush.Color := clrGray20;
    Pen.Color := clrBlack;
    Rectangle(8,8,310,114);
    DrawMode.AlphaMode := amOpaque;
    Font.Color := clrLtGreen;
    Font.Bold := True;
    //Font.Underline := True;
    TextOut(14,20,'Touches de controle :');
    Font.Bold := False;
    //Font.Underline := False;
    Font.Color := clrGray;
    TextOut(14,34,'Translation');
    TextOut(14,48,'Rotation');
    TextOut(14,62,'Cisaillement horizontal');
    TextOut(14,76,'Cisaillement vertical');
    TextOut(14,90,'Echelle horizontale');
    TextOut(14,104,'Echelle Verticale');
    Font.Color := clrltGray;
    TextOut(150,34,': gauche, droite, haut, bas');
    TextOut(150,48,': pageUp and pageDown');
    TextOut(150,62,': numpad-4 et numpad-6');
    TextOut(150,76,': numpad-8 et numpad-2');
    TextOut(150,90,': / et *');
    TextOut(150,104,': - et +');
  end;
end;

end.

