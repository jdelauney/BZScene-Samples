unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  BZColors, BZGraphic, BZBitmap, BZBitmapIO, BZMath, BZVectorMath,
  BZInterpolationFilters,
  BZThreadTimer;

type

  { TMainForm }

  TMainForm = class(TForm)
    procedure FormCreate(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormPaint(Sender : TObject);
    procedure FormShow(Sender : TObject);
  private
    FThreadTimer : TBZThreadTimer;
    FBackBitmap : TBZBitmap;
    FGlassBitmap : TBZBitmap;
    FClockBitmap : TBZBitmap;
    FDisplayBitmap : TBZBitmap;
    FClockCenter : TBZPoint;
  public
    bWidth, bHeight : Integer;
    Second_PointA, Second_PointB : TBZPoint;
    Minute_PointA, Minute_PointB : TBZPoint;
    Hour_PointA, Hour_PointB : TBZPoint;
    FCanClose : Boolean;
    procedure UpdateClock(Sender:TObject);
    procedure RenderClock;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses
  BZTypesHelpers;

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  bWidth := 512;
  bHeight := 512;
  FThreadTimer   := TBZThreadTimer.Create(Self);
  FThreadTimer.Enabled := False;
  FThreadTimer.OnTimer := @UpdateClock;
  FBackBitmap    := TBZBitmap.Create;
  FBackBitmap.LoadFromFile('../../../../../media/images/stonefloor.jpg');
  FBackBitmap.Transformation.Resample(bWidth,bHeight,ifmLanczos3);
  FGlassBitmap   := TBZBitmap.Create;
  FGlassBitmap.LoadFromFile('../../../../../media/images/backclockglass01.png');
  FGlassBitmap.PreMultiplyAlpha;
  FClockBitmap   := TBZBitmap.Create;
  FClockBitmap.LoadFromFile('../../../../../media/images/backclock01.png');
  FBackBitmap.PutImage(FClockBitmap,0,0,bWidth, bHeight,0,0,dmSet,amAlpha);
  FreeAndNil(FClockBitmap);
  FDisplayBitmap := TBZBitmap.Create(512,512);
  FDisplayBitmap.Clear(clrBlack);
  FClockCenter.Create(255,255);
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FBackBitmap);
  FreeAndNil(FGlassBitmap);
  //FreeAndNil(FClockBitmap);
  FreeAndNil(FDisplayBitmap);
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FThreadTimer.Enabled := False;
  CanClose := FCanClose;
  OnPaint := nil;
end;

procedure TMainForm.FormPaint(Sender : TObject);
begin
  FDisplayBitmap.DrawToCanvas(Canvas, ClientRect);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  FThreadTimer.Enabled := True;
end;

procedure TMainForm.UpdateClock(Sender : TObject);
VAr
  Angle : Single;
  dMin,dMax : Integer;
  h,m, s : Word;
  sa, ca : Single;
  d : TDateTime;
begin
  d := Now;
  s := d.Second;
  m := d.Minute;
  h := d.Hour;

  // Second
  Angle := -c2PI * (s/60);
  dMax := 200;
  dMin := 50;
  sa := Sin(Angle);
  ca := Cos(Angle);
  Second_PointA.Create(Round(FClockCenter.X + dMin * sa), Round(FClockCenter.Y + dMin * ca));
  Second_PointB.Create(Round(FClockCenter.X - dMax * sa), Round(FClockCenter.Y - dMax * ca));

  // Minute
  Angle := -c2PI * (m/60);
  dMax := 180;
  dMin := 30;
  sa := Sin(Angle);
  ca := Cos(Angle);
  Minute_PointA.Create(Round(FClockCenter.X + dMin * sa), Round(FClockCenter.Y + dMin * ca));
  Minute_PointB.Create(Round(FClockCenter.X - dMax * sa), Round(FClockCenter.Y - dMax * ca));

  // Hour
  if h > 12 then h := h - 12;
  Angle := -c2PI * (h/12);
  dMax := 150;
  dMin := 20;
  sa := Sin(Angle);
  ca := Cos(Angle);
  Hour_PointA.Create(Round(FClockCenter.X + dMin * sa), Round(FClockCenter.Y + dMin * ca));
  Hour_PointB.Create(Round(FClockCenter.X - dMax * sa), Round(FClockCenter.Y - dMax * ca));

  RenderClock;
end;

procedure TMainForm.RenderClock;
begin
  FCanClose := False;
  FDisplayBitmap.PutImage(FBackBitmap,0,0,bWidth, bHeight,0,0);
  With FDisplayBitmap.Canvas do
  begin
    Antialias := True;
    Pen.Width := 3;
    Pen.Color := clrRed;
    Line(Second_PointA,Second_PointB);
    Pen.Color := clrBlack;
    Pen.Width := 5;
    Line(Minute_PointA,Minute_PointB);
    Pen.Width := 7;
    Line(Hour_PointA,Hour_PointB);
    Pen.Width := 1;
    Pen.Color := BZColor(234,234,173);
    Brush.Style := bsGradient;
    Brush.Gradient.Kind := gkRadial;
    Brush.Gradient.ColorSteps.AddColorStop(BZColor(217,217,26),0.0);
    Brush.Gradient.ColorSteps.AddColorStop(BZColor(204,127,50),1.0);
    Circle(FClockCenter.X-1, FClockCenter.Y,15);
  end;
  FDisplayBitmap.PutImage(FGlassBitmap,0,0,bWidth, bHeight,0,0,dmCombine,amAlphaBlend,255,cmHardLight);
  Invalidate;
  FCanClose := True;
end;

end.

