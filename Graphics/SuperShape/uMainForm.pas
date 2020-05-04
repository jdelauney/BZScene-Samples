unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Spin,
  Math, BZMath, BZVectorMath, BZVectorMathUtils, BZColors, BZGraphic, BZBitmap;

type

  { TMainForm }

  TMainForm = class(TForm)
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    Label7 : TLabel;
    Label8 : TLabel;
    Panel1 : TPanel;
    pnlView : TPanel;
    RadioButton1 : TRadioButton;
    RadioButton2 : TRadioButton;
    speScaleFactor : TSpinEdit;
    tbValueM : TTrackBar;
    tbValueA : TTrackBar;
    tbValueB : TTrackBar;
    tbValueN1 : TTrackBar;
    tbValueN2 : TTrackBar;
    tbValueN3 : TTrackBar;
    tbNbPoints : TTrackBar;
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormCreate(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure pnlViewPaint(Sender : TObject);
    procedure HandleParamsChange(Sender : TObject);
  private
     FDisplayBuffer : TBZBitmap;
  public
    procedure UpdateShape;

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses
  BZGeoTools;

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FDisplayBuffer := TBZBitmap.Create(pnlView.Width, pnlView.Height);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  UpdateShape;
end;

procedure TMainForm.pnlViewPaint(Sender : TObject);
begin
  FDisplayBuffer.DrawToCanvas(pnlView.Canvas, pnlView.ClientRect);
end;

procedure TMainForm.HandleParamsChange(Sender : TObject);
begin
  UpdateShape;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FDisplayBuffer);
end;

procedure TMainForm.UpdateShape;
Var
  m, a, b, n1, n2, n3, sf : Single;
  pts : TBZArrayOfFloatPoints;
begin
  sf := speScaleFactor.Value;
  m := tbValueM.Position;
  a := tbValueA.Position / 100;
  b := tbValueB.Position / 100;
  n1 := tbValueN1.Position / 100;
  n2 := tbValueN2.Position / 100;
  n3 := tbValueN3.Position / 100;
  if RadioButton1.Checked then
    BuildPolySuperShape(vec2(FDisplayBuffer.CenterX, FDisplayBuffer.CenterY), n1,n2,n3,m,a,b,sf,tbNbPoints.Position,pts)
  else
    BuildPolyStar(vec2(FDisplayBuffer.CenterX, FDisplayBuffer.CenterY),tbValueA.Position, tbValueB.Position, tbValueM.Position, pts);

  FDisplayBuffer.Clear(clrBlack);
  With FDisplayBuffer.Canvas do
  begin
    Pen.Style := ssSolid;
    Pen.Color := clrWhite;
    Polygon(pts);
  end;
  FreeAndNil(pts);
  pnlView.Invalidate;
end;

end.

