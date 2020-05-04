unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Spin,
  BZColors, BZGraphic, BZBitmap, BZMath, BZVectorMath, BZGeoTools;

type

  { TForm1 }

  TForm1 = class(TForm)
    pnlViewer : TPanel;
    Panel1 : TPanel;
    Label2 : TLabel;
    GroupBox1 : TGroupBox;
    Panel2 : TPanel;
    Panel3 : TPanel;
    sbCurvePos : TScrollBar;
    Label1 : TLabel;
    lblCurveTime : TLabel;
    GroupBox2 : TGroupBox;
    GroupBox3 : TGroupBox;
    Label4 : TLabel;
    Panel4 : TPanel;
    Label5 : TLabel;
    Label6 : TLabel;
    Panel5 : TPanel;
    Label7 : TLabel;
    lblCurveLen : TLabel;
    Panel6 : TPanel;
    Label9 : TLabel;
    Label10 : TLabel;
    btnDivideCurve : TButton;
    Panel7 : TPanel;
    Label11 : TLabel;
    lblNormal : TLabel;
    btnAlignWithLine : TButton;
    Panel8 : TPanel;
    chkShowTangentAndNormal : TCheckBox;
    chkShowBoundingBox : TCheckBox;
    chkShowControlPoint : TCheckBox;
    chkShowConstructLine : TCheckBox;
    chkShowDecasteljau : TCheckBox;
    Panel9 : TPanel;
    Panel10 : TPanel;
    Label12 : TLabel;
    speSteps : TSpinEdit;
    Panel11 : TPanel;
    Label13 : TLabel;
    lblOptimalSteps : TLabel;
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure pnlViewerMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewerMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewerMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure FormShow(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure pnlViewerPaint(Sender : TObject);
    procedure sbCurvePosChange(Sender : TObject);
    procedure btnDivideCurveClick(Sender : TObject);
    procedure btnAlignWithLineClick(Sender : TObject);
    procedure speStepsChange(Sender : TObject);
  private
    FBuffer : TBZBitmap;
    FTangent : TBZFloatPoint;

    //FLineA, FLineB, FLineC, FLineAB,  FLineBC, FLineCD : TBZ2DLineTool;
    FStartPoint, FControlPointA, FControlPointB, FEndPoint  : TBZFloatPoint;
    //FPointOnLineA, FPointOnLineB : TBZFloatPoint;
    CubicBezierA, CubicBezierB : TBZ2DCubicBezierCurve;
    FIsDivide : Boolean;
    FMousePos, FLastMousePos : TBZFloatPoint;
    FMouseActive : Boolean;
    FDrag : Byte;
    FDist : Single;
  protected
    procedure DrawControlPoint(pt : TBZFloatPoint);
    procedure Render;
    function InPoint(mx, my, px, py, r : Single) : Boolean;
  public

  end;

var
  Form1 : TForm1;

implementation

{$R *.lfm}

Uses BZTypesHelpers;

{ TForm1 }

procedure TForm1.FormCreate(Sender : TObject);
begin
  FBuffer := TBZBitmap.Create(pnlViewer.ClientWidth, pnlViewer.ClientHeight);

  FStartPoint.Create(10,FBuffer.MaxHeight - 10);
  FControlPointA.Create(10,10);
  FControlPointB.Create(FBuffer.MaxWidth - 10, FBuffer.MaxHeight - 10);
  FEndPoint.Create(FBuffer.MaxWidth - 10, 10);

  //QuadraticBezier := TBZ2DQuadraticBezierCurve.Create;
  //QuadraticBezier.StartPoint := FStartPoint;
  //QuadraticBezier.ControlPoint := FControlPointA;
  //QuadraticBezier.EndPoint := FEndPoint;

  CubicBezierA := TBZ2DCubicBezierCurve.Create;
  CubicBezierA.StartPoint := FStartPoint;
  CubicBezierA.ControlPointA := FControlPointA;
  CubicBezierA.ControlPointB := FControlPointB;
  CubicBezierA.EndPoint := FEndPoint;
  FIsDivide := False;

  //FPointOnLineA := FStartPoint;
  //FPointOnLineB := FControlPointA;
  //FPointOnLineB := FControlPointB;
  //
  //FLineA := TBZ2DLineTool.Create;
  //FLineA.StartPoint := FStartPoint;
  //FLineA.EndPoint := FControlPointA;
  //
  //FLineB := TBZ2DLineTool.Create;
  //FLineB.StartPoint := FControlPointA;
  //FLineB.EndPoint := FControlPointB; //
  //
  //FLineC := TBZ2DLineTool.Create;
  //FLineC.StartPoint := FControlPointB;
  //FLineC.EndPoint := FEndPoint;
  //
  //FLineAB := TBZ2DLineTool.Create;
  //FLineAB.StartPoint := FStartPoint;
  //FLineAB.EndPoint := FControlPointA;
  //
  //FLineBC := TBZ2DLineTool.Create;
  //FLineBC.StartPoint := FControlPointA;
  //FLineBC.EndPoint := FControlPointB;
  //
  //FLineCD := TBZ2DLineTool.Create;
  //FLineCD.StartPoint := FControlPointB;
  //FLineCD.EndPoint := FEndPoint;
  //CubicBezier.Tolerance := 20;
end;

procedure TForm1.FormDestroy(Sender : TObject);
begin
  //FreeAndNil(FLineCD);
  //FreeAndNil(FLineBC);
  //FreeAndNil(FLineAB);
  //FreeAndNil(FLineC);
  //FreeAndNil(FLineB);
  //FreeAndNil(FLineA);
  //FreeAndNil(QuadraticBezier);
  FreeAndNil(CubicBezierA);
  if Assigned(CubicBezierB) then FreeAndNil(CubicBezierB);
  FreeAndNil(FBuffer);
end;

procedure TForm1.pnlViewerMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseActive := True;
  FMousePos.Create(x,y);
  if InPoint(FMousePos.X, FMousePos.Y, CubicBezierA.StartPoint.X, CubicBezierA.StartPoint.Y, 5) then FDrag := 0
  else if InPoint(FMousePos.X, FMousePos.Y, CubicBezierA.ControlPointA.X, CubicBezierA.ControlPointA.Y, 5) then FDrag := 1
  else if InPoint(FMousePos.X, FMousePos.Y, CubicBezierA.EndPoint.X, CubicBezierA.EndPoint.Y, 5) then FDrag := 2
  else if InPoint(FMousePos.X, FMousePos.Y, CubicBezierA.ControlPointB.X, CubicBezierA.ControlPointB.Y, 5) then FDrag := 3;
  FLastMousePos := FMousePos;
end;

procedure TForm1.pnlViewerMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseActive := False;
  FLastMousePos.Create(x,y);
end;

procedure TForm1.pnlViewerMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
Var
  Delta : TBZFloatPoint;
begin
  if FMouseActive then
  begin
    if ssLeft in Shift then
    begin
      FMousePos.Create(x,y);
      Delta := FMousePos - FLastMousePos;
      Case FDrag of
        0:
        begin
          CubicBezierA.StartPoint := CubicBezierA.StartPoint + Delta;
          //CubicBezierA.StartPoint := FStartPoint;
        end;
        1 :
        begin
          CubicBezierA.ControlPointA := CubicBezierA.ControlPointA + Delta;
          //CubicBezierA.ControlPointA := FControlPointA;
        end;
        2 :
        begin
          CubicBezierA.EndPoint := CubicBezierA.EndPoint + Delta;
          //CubicBezierA.EndPoint := FEndPoint;
        end;
        3 :
        begin
          CubicBezierA.ControlPointB := CubicBezierA.ControlPointB + Delta;
          //CubicBezierA.ControlPointB := FControlPointB;
        end;
      end;
      FDist := Abs(CubicBezierA.EndPoint.X - CubicBezierA.StartPoint.X);
      Render;
      pnlViewer.invalidate;
      FLastMousePos := FMousePos;
    end;
  end;
end;

procedure TForm1.FormShow(Sender : TObject);
begin
  //BZThreadTimer1.Enabled := True;
  Render;
end;

procedure TForm1.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  //BZThreadTimer1.Enabled := False;
  CanClose := True;
end;

procedure TForm1.pnlViewerPaint(Sender : TObject);
begin
  FBuffer.DrawToCanvas(pnlViewer.Canvas, pnlViewer.ClientRect);
end;

procedure TForm1.sbCurvePosChange(Sender : TObject);
var
  t : Single;
begin
  t := sbCurvePos.Position / 100;
  lblCurveTime.Caption := t.ToString(2);
  Render;
  pnlViewer.Invalidate;
end;

procedure TForm1.btnDivideCurveClick(Sender : TObject);
begin
  //if not(Assigned(CubicBezierB)) then CubicBezierB := TBZ2DCubicBezierCurve.Create;

  CubicBezierA.Split(CubicBezierA, CubicBezierB);

  FIsDivide := True;
  Render;
  pnlViewer.Invalidate;
end;

procedure TForm1.btnAlignWithLineClick(Sender : TObject);
Var
  {$CODEALIGN VARMIN=16}
  p1, p2 : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
begin
  p2.Create(80,FBuffer.MaxHeight - 80);
  p1.Create(FBuffer.MaxWidth - 80, 80);
  CubicBezierA.AlignToLine(p1,p2);
  Render;
  pnlViewer.Invalidate;
end;

procedure TForm1.speStepsChange(Sender : TObject);
begin
  Render;
  pnlViewer.Invalidate;
end;

procedure TForm1.DrawControlPoint(pt : TBZFloatPoint);
begin
  With FBuffer.Canvas do
  begin
    //Antialias := True;
    Brush.Style := bsClear;
    Pen.Style := ssSolid;
    Pen.Color := clrGray;
    Pen.Width := 1;
    Circle(pt, 5);
    Circle(pt, 2);
    Pen.Color := clrWhite;
    Circle(pt, 3);
    Circle(pt, 4);
    Antialias := False;

    //Brush.Color := clrGreen;
    //Brush.Color.Alpha := 127;
    //Circle(pt, 2);
  end;
end;

procedure TForm1.Render;
Var
  i : Integer;
  //aBezierCurve : TBZArrayOfFloatPoints;
  t : Single;
  {$CODEALIGN VARMIN=16}
  pSA, pAB, pBE, pt1, pt2, ptC, NormPt : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
  NormalLine : TBZ2DLineTool;
begin
  FBuffer.RenderFilter.DrawGrid(clrBlack, clrGray25, clrGray15, clrRed, clrGreen, 16);
  Fbuffer.Canvas.Antialias := False;
  //aBezierCurve := QuadraticBezier.ComputePolyLinePoints;
  //aBezierCurve := CubicBezier.ComputePolyLinePoints;
  lblOptimalSteps.Caption := CubicBezierA.ComputeOptimalSteps.ToString;
  if chkShowControlPoint.Checked then
  begin
    DrawControlPoint(CubicBezierA.StartPoint);
    DrawControlPoint(CubicBezierA.ControlPointA);
    DrawControlPoint(CubicBezierA.ControlPointB);
    DrawControlPoint(CubicBezierA.EndPoint);
    if FIsDivide then
    begin
      DrawControlPoint(CubicBezierB.StartPoint);
      DrawControlPoint(CubicBezierB.ControlPointA);
      DrawControlPoint(CubicBezierB.ControlPointB);
      DrawControlPoint(CubicBezierB.EndPoint);
    end;
  end;

  With FBuffer.Canvas do
  begin
    //if chkShowControlPoint.Checked then
    //begin
    //
    //  Pen.Style := ssClear;
    //  Brush.Style := bsSolid;
    //  Brush.Color := clrRed;
    //  Circle(FStartPoint, 5);
    //  Brush.Color := clrGreen;
    //  Circle(FControlPointA, 5);
    //  Brush.Color := clrLime;
    //  Circle(FControlPointB, 5);
    //  Brush.Color := clrBlue;
    //  Circle(FEndPoint, 5);
    //end;

    if chkShowConstructLine.Checked then
    begin
      Pen.Style := ssSolid;
      Pen.Color := clrYellow;
      Line(CubicBezierA.StartPoint, CubicBezierA.ControlPointA);
      Line(CubicBezierA.ControlPointA, CubicBezierA.ControlPointB);
      Line(CubicBezierA.ControlPointB, CubicBezierA.EndPoint);
    end;

    if chkShowBoundingBox.Checked then
    begin
      Pen.Color := clrTeal;
      Brush.Style := bsClear;
      Rectangle(CubicBezierA.GetBounds);
    end;

    Pen.Style := ssSolid;
    Pen.Color := clrWhite;
    Brush.Style := bsClear;
    //For i := 0 to (aBezierCurve.Count - 2) do
    //begin
    //  Line(aBezierCurve.Items[i], aBezierCurve.Items[i+1]);
    //end;
    Pen.Width := 1;
    if FIsDivide then
    begin
      Pen.Color := clrMediumTurquoise;
      BezierCurve(CubicBezierB.StartPoint,
                  CubicBezierB.ControlPointA,
                  CubicBezierB.ControlPointB,
                  CubicBezierB.EndPoint,
                  speSteps.Value);
      Pen.Color := clrMediumViolet;

    end;
    BezierCurve(CubicBezierA.StartPoint,
                CubicBezierA.ControlPointA,
                CubicBezierA.ControlPointB,
                CubicBezierA.EndPoint,
                speSteps.Value);

    Pen.Width := 1;

    t := sbCurvePos.Position / 100;
    if chkShowDeCasteljau.Checked then
    begin
      pSA := CubicBezierA.StartPoint.Lerp(CubicBezierA.ControlPointA, t);
      pAB := CubicBezierA.ControlPointA.Lerp(CubicBezierA.ControlPointB, t);
      pBE := CubicBezierA.ControlPointB.Lerp(CubicBezierA.EndPoint, t);
      pt1 := PSA.Lerp(pAB,t);
      pt2 := pAB.Lerp(pBE,t);
      ptC := pt1.Lerp(pt2,t);
      pen.Color :=  clrGreen;
      moveto(pSA);
      lineto(pAB);
      moveto(pBE);
      lineto(pAB);
      pen.Color :=  clrBlue;
      moveto(pt1);
      lineto(pt2);
      Pen.Style := ssClear;
      Brush.Style := bsSolid;
      Brush.Color := clrAqua;
      Circle(pSA, 3);
      Circle(pAB, 3);
      Circle(pBE, 3);
      Circle(pt1, 3);
      Circle(pt2, 3);
      Brush.Color := clrRed;
      Circle(ptC, 3);
    end;

    if chkShowTangentAndNormal.Checked then
    begin
      //NormPt := CubicBezierA.GetNormalAt(t);
      //NormalLine := TBZ2DLineTool.Create;
      //NormalLine.SetInfiniteLine(CubicBezierA.ComputePointAt(t), NormPt, 40);
      ptC := CubicBezierA.ComputePointAt(t);
      NormPt := CubicBezierA.GetNormalAt(t);
      Pen.Color := clrBrass;
      Pen.Style := ssSolid;
      MoveTo(ptC);// - (NormPt * 40));
      LineTo(ptC + (NormPt * 40));

      ptC := CubicBezierA.ComputePointAt(t);
      NormPt := CubicBezierA.GetTangentAt(t);
      Pen.Color := clrVioletRed;
      MoveTo(ptC); // - (NormPt * 80));
      LineTo(ptC + (NormPt * 80));


      //FreeAndNil(NormalLine);
      lblNormal.Caption := NormPt.ToString;
    end
    else lblNormal.Caption := '---';

    pt1.Create(80,FBuffer.MaxHeight - 80);
    pt2.Create(FBuffer.MaxWidth - 80, 80);
    Pen.Color := clrLime;
    MoveTo(pt1);
    LineTo(pt2);
  end;

  lblCurveLen.Caption :=  CubicBezierA.GetLength.ToString(2);
  //FreeAndNil(aBezierCurve);
end;

function TForm1.InPoint(mx, my, px, py, r : Single) : Boolean;
begin
  Result := False;
  if (mX >= px - r) and (mX <= px + r) and
     (mY >= py - r) and (mY <= py + r) then Result := True;
end;

end.

