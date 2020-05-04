unit Unit1;

{$mode objfpc}{$H+}

{$MINSTACKSIZE 8192}
{$MAXSTACKSIZE $7FFFFFFF}

{$ALIGN 16}
{$CODEALIGN CONSTMIN=16}
{$CODEALIGN LOCALMIN=16}
{$CODEALIGN VARMIN=16}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Spin, ComCtrls, ExtDlgs,
  BZVectorMath, BZVectorMathUtils, BZGeoTools, BZColors, BZGraphic, BZBitmap, BZBitmapIO;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1 : TButton;
    cbxColorMatrixPreset : TComboBox;
    fseM11 : TFloatSpinEdit;
    fseM12 : TFloatSpinEdit;
    fseM13 : TFloatSpinEdit;
    fseM14 : TFloatSpinEdit;
    fseM21 : TFloatSpinEdit;
    fseM22 : TFloatSpinEdit;
    fseM23 : TFloatSpinEdit;
    fseM24 : TFloatSpinEdit;
    fseM31 : TFloatSpinEdit;
    fseM32 : TFloatSpinEdit;
    fseM33 : TFloatSpinEdit;
    fseM34 : TFloatSpinEdit;
    fseM41 : TFloatSpinEdit;
    fseM42 : TFloatSpinEdit;
    fseM43 : TFloatSpinEdit;
    fseM44 : TFloatSpinEdit;
    fseM51 : TFloatSpinEdit;
    fseM52 : TFloatSpinEdit;
    fseM53 : TFloatSpinEdit;
    fseM54 : TFloatSpinEdit;
    Label1 : TLabel;
    Label10 : TLabel;
    Label11 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    Label7 : TLabel;
    Label8 : TLabel;
    Label9 : TLabel;
    OPD : TOpenPictureDialog;
    Panel1 : TPanel;
    pnlView : TPanel;
    tbFactor : TTrackBar;
    procedure Button1Click(Sender : TObject);
    procedure cbxColorMatrixPresetChange(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure pnlViewClick(Sender : TObject);
    procedure pnlViewPaint(Sender : TObject);
    procedure tbFactorChange(Sender : TObject);
  private
    FSource, FBuffer : TBZBitmap;

    {$CODEALIGN RECORDMIN=16}
    FColorMatrix : TBZColorMatrix;
    {$CODEALIGN RECORDMIN=4}

    procedure UpdateColorMatrix;
  public
    procedure render;
  end;

var
  Form1 : TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender : TObject);
begin
  FSource := TBZBitmap.Create;
  FBuffer := TBZBitmap.Create(pnlView.ClientWidth, pnlView.ClientHeight);
  FBuffer.Clear(clrBlack);
end;

procedure TForm1.cbxColorMatrixPresetChange(Sender : TObject);
begin

  Case cbxColorMatrixPreset.ItemIndex of
    0 : FColorMatrix.CreateIdentity; //  Identité
    1 : FColorMatrix.CreateBlackWhite; // Noir et blanc
    2 : FColorMatrix.CreateBrightness(tbFactor.Position / 100); //Luminosité
    3 : FColorMatrix.CreateLightness(tbFactor.Position / 100); //Intensité
    4 : FColorMatrix.CreateContrast(tbFactor.Position / 100); //Contraste
    5 : FColorMatrix.CreateSaturation(tbFactor.Position / 100); //Saturation
    6 : FColorMatrix.CreateInvert(tbFactor.Position / 100); //Invertion
    7 : FColorMatrix.CreateGrayScaleBT601(tbFactor.Position / 100); //BT 601
    8 : FColorMatrix.CreateGrayScaleBT709(tbFactor.Position / 100); //BT 706
    9 : FColorMatrix.CreateGrayScaleBT2100(tbFactor.Position / 100); //BT 2100
    10 : FColorMatrix.CreateOpacity(tbFactor.Position / 100); //Opacité
    11 : FColorMatrix.CreateAchromAnomaly; //AchromAnomaly
    12 : FColorMatrix.CreateAchromatopsia; //AchromaTopsia
    13 : FColorMatrix.CreateDeuterAnomaly; //DeuterAnomaly
    14 : FColorMatrix.CreateDeuteranopia; //Deuteranopia
    15 : FColorMatrix.CreateProtAnomaly; //ProtAnomaly
    16 : FColorMatrix.CreateProtanopia; //protanopia
    17 : FColorMatrix.CreateTritAnomaly; //TritAnomaly
    18 : FColorMatrix.CreateTritanopia; //Tritanopia
    19 : FColorMatrix.CreateKodaChrome; //KodaChrome
    20 : FColorMatrix.CreateLomoGraph; //LomoGraph
    21 : FColorMatrix.CreatePolaroid; //Polaroid
    22 : FColorMatrix.CreatePolaroidII; //PolaroidII
    23 : FColorMatrix.CreateOldPhoto; //OldPhoto
    24 : FColorMatrix.CreateSepia(tbFactor.Position / 100); //OldPhoto
    25 : FColorMatrix.CreateSepiaII(tbFactor.Position / 100); //OldPhoto
  end;
  UpdateColorMatrix;
end;

procedure TForm1.Button1Click(Sender : TObject);
begin
  Render;
end;

procedure TForm1.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FBuffer);
end;

procedure TForm1.pnlViewClick(Sender : TObject);
begin
  if OPD.Execute then
  begin
    FSource.LoadFromFile(OPD.FileName);
    FBuffer.Assign(FSource);
    pnlView.Invalidate;
  end;
end;

procedure TForm1.pnlViewPaint(Sender : TObject);
begin
  FBuffer.DrawToCanvas(pnlView.Canvas, pnlView.ClientRect, True, False);
end;

procedure TForm1.tbFactorChange(Sender : TObject);
begin
  Case cbxColorMatrixPreset.ItemIndex of
    2 : FColorMatrix.CreateBrightness(tbFactor.Position / 100);
    3 : FColorMatrix.CreateLightness(tbFactor.Position / 100);
    4 : FColorMatrix.CreateContrast(tbFactor.Position / 100);
    5 : FColorMatrix.CreateSaturation(tbFactor.Position / 100);
    6 : FColorMatrix.CreateInvert(tbFactor.Position / 100);
    7 : FColorMatrix.CreateGrayScaleBT601(tbFactor.Position / 100);
    8 : FColorMatrix.CreateGrayScaleBT709(tbFactor.Position / 100);
    9 : FColorMatrix.CreateGrayScaleBT2100(tbFactor.Position / 100);
    10 : FColorMatrix.CreateOpacity(tbFactor.Position / 100);
    24 : FColorMatrix.CreateSepia(tbFactor.Position / 100); //OldPhoto
    25 : FColorMatrix.CreateSepiaII(tbFactor.Position / 100); //OldPhoto
  end;
  UpdateColorMatrix;
end;

procedure TForm1.UpdateColorMatrix;
begin
  fseM11.Value := FColorMatrix.m11;
  fseM12.Value := FColorMatrix.m12;
  fseM13.Value := FColorMatrix.m13;
  fseM14.Value := FColorMatrix.m14;

  fseM21.Value := FColorMatrix.m21;
  fseM22.Value := FColorMatrix.m22;
  fseM23.Value := FColorMatrix.m23;
  fseM24.Value := FColorMatrix.m24;

  fseM31.Value := FColorMatrix.m31;
  fseM32.Value := FColorMatrix.m32;
  fseM33.Value := FColorMatrix.m33;
  fseM34.Value := FColorMatrix.m34;

  fseM41.Value := FColorMatrix.m41;
  fseM42.Value := FColorMatrix.m42;
  fseM43.Value := FColorMatrix.m43;
  fseM44.Value := FColorMatrix.m44;

  fseM51.Value := FColorMatrix.m51;
  fseM52.Value := FColorMatrix.m52;
  fseM53.Value := FColorMatrix.m53;
  fseM54.Value := FColorMatrix.m54;
end;

procedure TForm1.render;
Var
  i, x, y : Integer;
  PixPtr, DestPtr : PBZColor;
  inColor, outColor : TBZColorVector;
  FinalColor : TBZColor;
begin
  //inPts := TBZArrayOfFloatPoints.Create(11);
  //inPts.Add(Vec2(165, 125));
  //inPts.Add(Vec2(165, 265));
  //inPts.Add(Vec2(365, 265));
  //inPts.Add(Vec2(365, 345));
  //inPts.Add(Vec2(525, 345));
  //inPts.Add(Vec2(525, 265));
  //inPts.Add(Vec2(625, 265));
  //inPts.Add(Vec2(625, 165));
  //inPts.Add(Vec2(525, 165));
  //inPts.Add(Vec2(525, 125));
  //inPts.Add(Vec2(185, 125));
  ////inPts.Add(Vec2(165, 125));
  ////Poly := TBZ2DPolygonTool.Create;
  ////Poly.AssignPoints(inPts);
  ////
  //FBuffer.Clear(clrBlack);
  //With FBuffer.Canvas do
  //begin
  //  Pen.Width := 2;
  //  Pen.Color := clrRed;
  //  Pen.Style := ssSolid;
  //  Brush.Style := bsClear;
  //  Polygon(inPts);
  //  Rectangle(20,20,600,300);
  //  //FreeAndNil(inPts);
  //  //Pen.Color := clrYellow;
  //  //inPts := Poly.OffsetPolygon(1.2);
  //  //Polygon(inPts);
  //end;
  //
  //FreeAndNil(inPts);

  i := 0;
  PixPtr := FSource.GetScanLine(0);
  DestPtr := FBuffer.GetScanLine(0);
  while i <= FBuffer.maxSize do
  begin
    inColor := PixPtr^.AsColorVector;
    outColor := FColorMatrix.Transform(inColor);
    FinalColor.Create(outColor);
    DestPtr^ := FinalColor;
    inc(i);
    inc(PixPtr);
    inc(DestPtr);
  end;
  pnlView.Invalidate;
end;

end.

