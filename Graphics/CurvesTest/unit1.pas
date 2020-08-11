unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Spin,
  BZArrayClasses, BZColors, BZGraphic, BZBitmap, BZMath, BZVectorMath, BZGeoTools;

type
  TBZCurvePointType = (cptControls, cptAnchors);

  { TBZ2DCustomCurve }

  TBZ2DCustomCurve = Class(TBZFloatPointsContainer)
  private
    FCurvePointType : TBZCurvePointType;

  protected
    FTolerance : Single;

  public
    Constructor Create; override;
    Constructor Create(APoints : TBZArrayOfFloatPoints; Const aPointType : TBZCurvePointType = cptAnchors); overload;
    Destructor Destroy; override;

    function ComputePointAt(t : Single) : TBZFloatPoint; virtual;
    function ComputePolyLinePoints(Const nbStep : Integer = -1) : TBZArrayOfFloatPoints; virtual;

    function GetLength : Single; virtual;
    function GetBounds : TBZFloatRect;  virtual;

    // function getTangentAt(t: Single) : TBZFloatPoint;
    // function getNormalAt(t: Single) : TBZFloatPoint;

    //function ComputeControlPoints : TBZArrayOfFloatPoints; virtual;

    function ComputeOptimalSteps(Const aTolerance : Single = 0.1) : Integer; virtual;

    property CurvePointType : TBZCurvePointType read FCurvePointType write FCurvePointType;
    property Tolerance : Single read FTolerance write FTolerance;
  end;

  { TBZ2DBezierSplineCurve }

  TBZ2DBezierSplineCurve = Class(TBZ2DCustomCurve)
  private
     FControlPoints : TBZArrayOfFloatPoints;
  protected
    //function ComputeOptimalSteps(Const aTolerance : Single = 0.1) : Integer;  override;
    function ComputeCoef(n, k : Integer) : Double;
  public
     function ComputeOptimalSteps(Const aTolerance : Single = 0.1) : Integer; override;
    function ComputePointAt(t : Single) : TBZFloatPoint; override;
    function ComputePolyLinePoints(Const nbStep : Integer = -1) : TBZArrayOfFloatPoints; override;
  end;

  //TBZCubicSplineType = (cstMonotonic, cstNatural, cstNaturalClamped);
  //TBZ2DCubicSplineCurve = Class(TBZ2DCustomCurve)
  //private
  //  FSplineType : TBZCubicSplineType;
  //protected
  //
  //public;
  //  Constructor Create; override;
  //  Constructor Create(APoints : TBZArrayOfFloatPoints; Const aSplineType : TBZCubicSplineType = cptAnchors); overload;
  //
  //  function ComputePointAt(t : Single) : TBZFloatPoint; override;
  //  function ComputePolyLinePoints(Const nbStep : Integer = -1) : TBZArrayOfFloatPoints; override;
  //
  //  property SplineType : TBZBSplineType read FSplineType write FSplineType;
  //end;

  TBZCatmullRomSplineType = (cstCentripetal, cstChordal, cstUniform);

  { TBZ2DCatmullRomSplineCurve }

  TBZ2DCatmullRomSplineCurve = Class(TBZ2DCustomCurve)
  private
     FSplineType :  TBZCatmullRomSplineType;
     FClosed : Boolean;
     FTension : Single;
  protected
     procedure ComputeCubicCoefs(x0, x1, t0, t1 : Single; var c0, c1, c2, c3 : Single);
     procedure ComputeUniformCatmullRomCoefs(x0, x1, x2, x3, w : Single; var c0, c1, c2, c3 : Single);
     procedure ComputeNonUniformCatmullRomCoefs(x0, x1, x2, x3, dt0, dt1, dt2 : Single; var c0, c1, c2, c3 : Single);
     function ComputeCoef(t, c0, c1, c2, c3 : Single) : Single;

  public
    Constructor Create; override;
    Constructor Create(APoints : TBZArrayOfFloatPoints; Const aSplineType : TBZCatmullRomSplineType = cstUniform); overload;

    function ComputePointAt(t : Single) : TBZFloatPoint; override;
    function ComputePolyLinePoints(Const nbStep : Integer = -1) : TBZArrayOfFloatPoints; override;

    property SplineType :  TBZCatmullRomSplineType read FSplineType write FSplineType;
    property Closed : Boolean read FClosed write FClosed;
    property Tension : Single read FTension write FTension;
  end;



  { TMainForm }
  TBZPointToolMode = (ptmNone, ptmCreate, ptmMove, ptmDelete);
  TMainForm = class(TForm)
    pnlViewer : TPanel;
    Panel1 : TPanel;
    Label2 : TLabel;
    GroupBox1 : TGroupBox;
    Panel2 : TPanel;
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
    Panel7 : TPanel;
    Label11 : TLabel;
    lblNormal : TLabel;
    Panel8 : TPanel;
    chkShowTangentAndNormal : TCheckBox;
    chkShowBoundingBox : TCheckBox;
    chkShowControlPoint : TCheckBox;
    chkShowConstructLine : TCheckBox;
    Panel9 : TPanel;
    Panel11 : TPanel;
    Label13 : TLabel;
    lblOptimalSteps : TLabel;
    Panel3: TPanel;
    sbCurveTension: TScrollBar;
    Label1: TLabel;
    lblCurveTension: TLabel;
    Panel10: TPanel;
    Label12: TLabel;
    speSteps: TSpinEdit;
    Label3: TLabel;
    cbxCurveType: TComboBox;
    Panel12: TPanel;
    sbCurvePos: TScrollBar;
    Label8: TLabel;
    lblCurveTime: TLabel;
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure pnlViewerMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewerMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewerMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure FormShow(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure pnlViewerPaint(Sender : TObject);
    procedure sbCurveTensionChange(Sender : TObject);
    procedure sbCurvePosChange(Sender: TObject);
  private
    FBuffer : TBZBitmap;

    FControlPoints, FAnchorPoints : TBZArrayOfFloatPoints;
    FPointIndex : Integer;

    FMousePos, FLastMousePos : TBZFloatPoint;
    FMouseActive : Boolean;
    FPointToolMode : TBZPointToolMode;
    FDrag : Byte;
    FDist : Single;

    FBezierCurve : TBZ2DBezierSplineCurve;
    FCatmullRomCurve : TBZ2DCatmullRomSplineCurve;
    FBezierCurve2 : TBZ2DCurve;

    procedure CheckSelectedPoint;
  protected
    procedure DrawControlPoint(pt : TBZFloatPoint; IsSelected : Boolean);
    procedure Render;
    function InPoint(mx, my, px, py, r : Single) : Boolean;
  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

Uses Math, BZLogger, BZTypesHelpers;

{%region TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FBuffer := TBZBitmap.Create(pnlViewer.ClientWidth, pnlViewer.ClientHeight);
  FControlPoints :=  TBZArrayOfFloatPoints.Create(16);
  FAnchorPoints := TBZArrayOfFloatPoints.Create(16);
  FPointToolMode := ptmNone;
  FPointIndex := -1;
  //FBezierCurve := TBZ2DBezierSplineCurve.Create(16);
  //FBezierCurve.CurvePointType := cptAnchors;

  FCatmullRomCurve := TBZ2DCatmullRomSplineCurve.Create;
  FCatmullRomCurve.SplineType := cstUniform;
  FCatmullRomCurve.Tension := 0.8;
  FCatmullRomCurve.Closed := True;

  FBezierCurve := TBZ2DBezierSplineCurve.Create;

  FBezierCurve2 := TBZ2DCurve.Create(ctBezier);
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FBezierCurve2);
  FreeAndNil(FBezierCurve);
  FreeAndNil(FCatmullRomCurve);
  FreeAndNil(FAnchorPoints);
  FreeAndNil(FControlPoints);
  FreeAndNil(FBuffer);
end;

procedure TMainForm.pnlViewerMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseActive := True;
  FMousePos.Create(x,y);
  if (ssLeft in Shift) then
  begin
    if (ssCtrl in Shift) then
    begin
      CheckSelectedPoint;
      if (FPointIndex > - 1) then FPointToolMode  := ptmMove;
    end
    else
    begin
      FPointToolMode := ptmCreate;
      FMouseActive := False;
    end;
  end
  else if (ssRight in Shift) then
  begin
    CheckSelectedPoint;
    if (FPointIndex > - 1) then FPointToolMode := ptmDelete;
    FMouseActive := False;
  end;

  //if InPoint(FMousePos.X, FMousePos.Y, CurveSpline.Points[0].X, CurveSpline.Points[0].Y, 5) then FDrag := 0
  //else if InPoint(FMousePos.X, FMousePos.Y, CurveSpline.Points[1].X, CurveSpline.Points[1].Y, 5) then FDrag := 1
  //else if InPoint(FMousePos.X, FMousePos.Y, CurveSpline.Points[2].X, CurveSpline.Points[2].Y, 5) then FDrag := 2
  //else if InPoint(FMousePos.X, FMousePos.Y, CurveSpline.Points[3].X, CurveSpline.Points[3].Y, 5) then FDrag := 3;

  FLastMousePos := FMousePos;
  Render;
  pnlViewer.invalidate;
end;

procedure TMainForm.pnlViewerMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FMouseActive := False;
  Case FPointToolMode of
    ptmCreate :
    begin
      FAnchorPoints.Add(FMousePos);
      //FBezierCurve.PointsList.Add(FMousePos);
    end;
    ptmDelete :
    begin
      if (FPointIndex > -1) then FAnchorPoints.Delete(FPointIndex);
    end;
  end;
  FPointToolMode := ptmNone;
  FPointIndex := -1;
  FLastMousePos.Create(x,y);
  Render;
  pnlViewer.invalidate;
end;

procedure TMainForm.pnlViewerMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
Var
  Delta : TBZFloatPoint;
begin
  FMousePos.Create(x,y);
  if FMouseActive then
  begin
    if (FPointToolMode = ptmMove) then
    begin
      Delta := FMousePos - FLastMousePos;
      FAnchorPoints.Items[FPointIndex] := FAnchorPoints.Items[FPointIndex] + Delta;
      FLastMousePos := FMousePos;
    end;
  end
  else CheckSelectedPoint;
  Render;
  pnlViewer.invalidate;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  //BZThreadTimer1.Enabled := True;
  Render;
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  //BZThreadTimer1.Enabled := False;
  CanClose := True;
end;

procedure TMainForm.pnlViewerPaint(Sender : TObject);
begin
  FBuffer.DrawToCanvas(pnlViewer.Canvas, pnlViewer.ClientRect);
end;

procedure TMainForm.sbCurveTensionChange(Sender : TObject);
var
  t : Single;
begin
  t := sbCurveTension.Position / 100;
  lblCurveTension.Caption := t.ToString(2);
  FCatmullRomCurve.Tension := t;
  Render;
  pnlViewer.Invalidate;
end;

procedure TMainForm.sbCurvePosChange(Sender: TObject);
var
  t : Single;
begin
  t := sbCurvePos.Position / 100;
  lblCurveTime.Caption := t.ToString(2);
  Render;
  pnlViewer.Invalidate;
end;

procedure TMainForm.CheckSelectedPoint;
Var
  i : integer;
begin
  FPointIndex := -1;
  if FAnchorPoints.Count > 0 then
  begin
    for i := 0 to (FAnchorPoints.Count - 1) do
    begin
      if InPoint(FMousePos.X, FMousePos.Y, FAnchorPoints.Items[i].X, FAnchorPoints.Items[i].Y, 5) then
      begin
        FPointIndex := i;
        Break;
      end;
    end;
  end;
  lblNormal.Caption := FPointIndex.ToString;
end;

procedure TMainForm.DrawControlPoint(pt: TBZFloatPoint; IsSelected: Boolean);
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
    if Not(IsSelected) then Pen.Color := clrWhite else Pen.Color := clrAqua;
    Circle(pt, 3);
    Circle(pt, 4);
    Antialias := False;

    //Brush.Color := clrGreen;
    //Brush.Color.Alpha := 127;
    //Circle(pt, 2);
  end;
end;

procedure TMainForm.Render;
Var
  i : Integer;
  //aBezierCurve : TBZArrayOfFloatPoints;
  t : Single;
  LSelected : Boolean;
  {$CODEALIGN VARMIN=16}
  pSA, pAB, pBE, pt1, pt2, ptC, NormPt : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
  NormalLine : TBZ2DLineTool;
  PolyPoints, PolyPoints2, PolyPoints3 : TBZArrayOfFloatPoints;
begin
  FBuffer.RenderFilter.DrawGrid(clrBlack, clrGray25, clrGray15, clrRed, clrGreen, 16);
  Fbuffer.Canvas.Antialias := False;

  if chkShowControlPoint.Checked then
  begin
    for i := 0 to (FAnchorPoints.Count - 1) do
    begin
      if FPointIndex = i then LSelected := True else LSelected := False;
      DrawControlPoint(FAnchorPoints.Items[i], LSelected);
    end;
  end;

  With FBuffer.Canvas do
  begin


    if chkShowConstructLine.Checked then
    begin
      Pen.Style := ssSolid;
      Pen.Color := clrYellow;
      for i := 0 to (FAnchorPoints.Count - 2) do
      begin
        Line(FAnchorPoints.Items[i], FAnchorPoints.Items[i + 1]);
      end;
    end;

    //if chkShowBoundingBox.Checked then
    //begin
    //  Pen.Color := clrTeal;
    //  Brush.Style := bsClear;
    //  Rectangle(CurveSpline.GetBounds);
    //end;

    Pen.Style := ssSolid;
    Pen.Color := clrWhite;
    Brush.Style := bsClear;
    //For i := 0 to (aBezierCurve.Count - 2) do
    //begin
    //  Line(aBezierCurve.Items[i], aBezierCurve.Items[i+1]);
    //end;
    Pen.Width := 1;

    if (FAnchorPoints.Count > 2) then
    begin
      Case cbxCurveType.ItemIndex of
        0 :
        begin
          FBezierCurve2.AssignPoints(FAnchorPoints);
          FBezierCurve2.CurveType := ctBezier;
          PolyPoints2 := FBezierCurve2.ComputePolylinePoints;
          FBezierCurve2.CurveType := ctSmoothBezier;
          PolyPoints3 := FBezierCurve2.ComputePolylinePoints;

          FBezierCurve.AssignPoints(FAnchorPoints);
          //lblOptimalSteps.Caption := FBezierCurve.ComputeOptimalSteps.ToString;
          PolyPoints := FBezierCurve.ComputePolyLinePoints(speSteps.Value);
        end;
        4, 5, 6 :
        begin
          FCatmullRomCurve.AssignPoints(FAnchorPoints);
          lblOptimalSteps.Caption := FCatmullRomCurve.ComputeOptimalSteps.ToString;
          PolyPoints := FCatmullRomCurve.ComputePolyLinePoints(speSteps.Value);
        end;
      end;
      MoveTo(PolyPoints.Items[0]);
      for i := 1 to (PolyPoints.Count - 1) do
      begin
        LineTo(PolyPoints.Items[i]);
      end;
      FreeAndNil(PolyPoints);


      MoveTo(PolyPoints2.Items[0]);
      //DrawControlPoint(PolyPoints2.Items[0], true);
      for i := 1 to (PolyPoints2.Count - 1) do
      begin
        //DrawControlPoint(PolyPoints2.Items[i], true);
        Pen.Color := clrFuchsia;
        LineTo(PolyPoints2.Items[i]);
      end;
      FreeAndNil(PolyPoints2);

      MoveTo(PolyPoints3.Items[0]);
      for i := 1 to (PolyPoints3.Count - 1) do
      begin
        Pen.Color := clrAqua;
        LineTo(PolyPoints3.Items[i]);
      end;

      FreeAndNil(PolyPoints3);

    end;

    //if chkShowTangentAndNormal.Checked then
    //begin
    //  //NormPt := CubicBezierA.GetNormalAt(t);
    //  //NormalLine := TBZ2DLineTool.Create;
    //  //NormalLine.SetInfiniteLine(CubicBezierA.ComputePointAt(t), NormPt, 40);
    //  ptC := CubicBezierA.ComputePointAt(t);
    //  NormPt := CubicBezierA.GetNormalAt(t);
    //  Pen.Color := clrBrass;
    //  Pen.Style := ssSolid;
    //  MoveTo(ptC);// - (NormPt * 40));
    //  LineTo(ptC + (NormPt * 40));
    //
    //  ptC := CubicBezierA.ComputePointAt(t);
    //  NormPt := CubicBezierA.GetTangentAt(t);
    //  Pen.Color := clrVioletRed;
    //  MoveTo(ptC); // - (NormPt * 80));
    //  LineTo(ptC + (NormPt * 80));
    //
    //
    //  //FreeAndNil(NormalLine);
    //  lblNormal.Caption := NormPt.ToString;
    //end
    //else lblNormal.Caption := '---';
    end;

    //pt1.Create(80,FBuffer.MaxHeight - 80);
    //pt2.Create(FBuffer.MaxWidth - 80, 80);
    //Pen.Color := clrLime;
    //MoveTo(pt1);
    //LineTo(pt2);
end;


function TMainForm.InPoint(mx, my, px, py, r : Single) : Boolean;
begin
  Result := False;
  if (mX >= px - r) and (mX <= px + r) and
     (mY >= py - r) and (mY <= py + r) then Result := True;
end;

{%endregion%}

{%region  TBZ2DCustomCurve }

Constructor TBZ2DCustomCurve.Create;
begin
  inherited Create(64);
  FCurvePointType := cptAnchors;
  FTolerance := 0.1;
end;

Constructor TBZ2DCustomCurve.Create(APoints: TBZArrayOfFloatPoints; Const aPointType: TBZCurvePointType);
begin
  inherited Create(aPoints);
  FCurvePointType := aPointType;
  FTolerance := 0.1;
end;

Destructor TBZ2DCustomCurve.Destroy;
begin
  inherited Destroy;
end;

function TBZ2DCustomCurve.ComputeOptimalSteps(Const aTolerance: Single): Integer;
Var
  {$CODEALIGN VARMIN=16}
  P1, P2 : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
  i : Integer;
  d : Single;
begin
  d := 0;
  For i := 0 to (Self.PointsList.Count - 2) do
  begin
    P1 := Self.Points[i];
    P2 := Self.Points[i+1];
    d := d + P1.DistanceSquare(P2);
  end;
  d := System.Sqrt(System.Sqrt(d) / aTolerance);
  if (d < cEpsilon) then d := 1.0;
  Result := Round(d);
end;

function TBZ2DCustomCurve.ComputePointAt(t: Single): TBZFloatPoint;
begin
  Result.Create(0,0);
end;

function TBZ2DCustomCurve.ComputePolyLinePoints(Const nbStep: Integer): TBZArrayOfFloatPoints;
begin
  result := nil;
end;

function TBZ2DCustomCurve.GetLength: Single;
begin
  Result := 0;
end;

function TBZ2DCustomCurve.GetBounds: TBZFloatRect;
begin
  Result.Create(0,0,0,0);
end;

{%endregion%}

{%region TBZ2DBezierSplineCurve }

function TBZ2DBezierSplineCurve.ComputeOptimalSteps(Const aTolerance: Single): Integer;
Var
  {$CODEALIGN VARMIN=16}
  P1, P2 : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
  i : Integer;
  d : Single;
begin
  d := 0;
  For i := 0 to (Self.PointsList.Count - 2) do
  begin
    P1 := Self.Points[i];
    P2 := Self.Points[i+1];
    d := Max(d, P1.DistanceSquare(P2));
  end;
  d := System.Sqrt(System.Sqrt(d) / aTolerance) * 2;
  if (d < cEpsilon) then d := 1.0;
  Result := Round(d);
end;

function TBZ2DBezierSplineCurve.ComputeCoef(n, k: Integer): Double;
Var
  Coef : Single;
  i, j : integer;
begin
  Coef := 1;
  j := n - k + 1;
  for i := j to n do
  begin
    Coef := Coef * i;
  end;
  for i := 1 to k do
  begin
    Coef := Coef / i;
  end;
  Result := Coef;
end;

function TBZ2DBezierSplineCurve.ComputePointAt(t: Single): TBZFloatPoint;
Var
  i, n : integer;
  b, nt : Double;
begin
  n := Self.PointsList.Count - 1;
  Result.Create(0,0);
  nt := 1 - t;
  for i := 0 to n do
  begin
    b := ComputeCoef(n, i) * BZMath.Pow(nt, (n-i)) * BZMath.Pow(t, i);
  	Result := Result + (Self.Points[i]	* b);
  end;
end;

function TBZ2DBezierSplineCurve.ComputePolyLinePoints(Const nbStep: Integer): TBZArrayOfFloatPoints;
var
  nbSteps, j : Integer;
  Delta, aTime : Single;
  pt : TBZFloatPoint;
begin
  Result := nil;
  if nbStep <= 0 then nbSteps := ComputeOptimalSteps(FTolerance)
  else nbSteps := nbStep;

  Result := TBZArrayOfFloatPoints.Create(nbSteps + 1);
  if nbSteps > 1 then
  begin
    aTime := 0;
    Delta := 1.0 / nbSteps;
    for j := 0 to (nbSteps - 1) do
    begin
      pt :=ComputePointAt(aTime);
      Result.Add(pt);
      aTime := aTime + Delta;
    end;
  end
  else
  begin
    Result.Add(Self.Points[0]);
    Result.Add(Self.Points[(Self.PointsList.Count - 1)]);
  end;
end;


//function TBZ2DBezierSplineCurve.ComputeControlPoints: TBZArrayOfFloatPoints;
//var
//  sp, ep, cp1, cp2 : TBZFloatPoint;
//  n, j : integer;
//  RightHandSide, pX, pY : TBZSingleList;
//  t : Single;
//
//  function GetFirstControlPoint( rhs : TBZSingleList) : TBZSingleList;
//  var
//    i, k : Integer;
//    tmp, tmpX : TBZSingleList;
//    b, v : single;
//  begin
//    k := rhs.Count;
//    b := 2.0;
//    tmp := TBZSingleList.Create(16);
//    tmpX := TBZSingleList.Create(16);
//    v := rhs.Items[0] / b;
//    tmpX.Add(v);
//    for i := 1 to (k - 1) do
//    begin
//      v := 1 / b;
//      tmp.Add(v);
//      if (i < (k - 1)) then b := 4.0 - tmp.Items[i - 1]
//      else b := 3.5 - tmp.Items[i - 1];
//      v := (rhs.Items[i] - tmpX.Items[i - 1]) / b;
//      tmpX.Add(v);
//    end;
//
//    for i := 1 to (k - 1) do
//    begin
//      v := tmpX.Items[k - i - 1];
//      v := v - (tmp.Items[i - 1] * tmpX.Items[i - 1]);
//      tmpX.Items[k - i - 1] := v;
//    end;
//
//    FreeAndNil(tmp);
//    Result := tmpX;
//  end;
//
//begin
//  n := PointsList.Count - 1;
//  Result := TBZArrayOfFloatPoints.Create(16);
//  if (n = 1) then  // Cas spécial, c'est une simple ligne
//  begin
//    sp := Self.Points[0];
//    cp1 := ((Self.Points[0] + Self.Points[0]) + Self.Points[1]) / 3;
//    cp2 := (cp1 - Self.Points[0]);
//    ep := Self.Points[1];
//    Result.Add(sp);
//    Result.Add(cp1);
//    Result.Add(cp2);
//    Result.Add(ep);
//    Exit;
//  end;
//
//  RightHandSide := TBZSingleList.Create(16);
//  t := Self.Points[1].X;
//  t := t + t;
//  t := t+ Self.Points[0].X;
//  RightHandSide.Add(t);
//  for j := 1 to (n - 1) do
//  begin
//    t := Self.Points[j + 1].X;
//    t := t + t;
//    t := (4 * Self.Points[j].X) + t;
//    RightHandSide.Add(t);
//  end;
//  t := ((8 * Self.Points[n - 1].X) + Self.Points[n].X) * 0.5;
//  RightHandSide.Add(t);
//  pX := GetFirstControlPoint(RightHandSide);
//
//  RightHandSide.Clear;
//  t := Self.Points[1].Y;
//  t := t + t;
//  t := t+ Self.Points[0].Y;
//  RightHandSide.Add(t);
//  for j := 1 to (n - 1) do
//  begin
//    t := Self.Points[j + 1].Y;
//    t := t + t;
//    t := (4 * Self.Points[j].Y) + t;
//    RightHandSide.Add(t);
//  end;
//  t := ((8 * Self.Points[n - 1].Y) + Self.Points[n].Y) * 0.5;
//  RightHandSide.Add(t);
//  pY := GetFirstControlPoint(RightHandSide);
//
//  FreeAndNil(RightHandSide);
//
//  for j := 0 to (n - 1) do
//  begin
//    sp := Self.Points[j];
//    cp1.Create(pX.Items[j], pY.Items[j]);
//    if (j < (n - 1)) then
//    begin
//      cp2.Create((Self.Points[j + 1].X * 2) - pX.Items[j + 1], (Self.Points[j + 1].Y * 2) - pY.Items[j + 1]);
//    end
//    else
//    begin
//      cp2.Create((Self.Points[n].X + pX.Items[n - 1]) * 0.5, (Self.Points[n].Y + pY.Items[n - 1]) * 0.5);
//    end;
//    ep  := Self.Points[j + 1];
//    Result.Add(sp);
//    Result.Add(cp1);
//    Result.Add(cp2);
//    Result.Add(ep);
//  end;
//  //Result.Add(Self.Points[n]);
//  FreeAndNil(pX);
//  FreeAndNil(pY);
//end;

{%endregion%}

{%region TBZ2DCatmullRomSplineCurve }

Constructor TBZ2DCatmullRomSplineCurve.Create;
begin
  inherited Create;
  FSplineType := cstUniform;
  FClosed := False;
  FTension := 0.5;
end;

Constructor TBZ2DCatmullRomSplineCurve.Create(APoints: TBZArrayOfFloatPoints; Const aSplineType: TBZCatmullRomSplineType);
begin
  inherited Create(aPoints, cptAnchors);
  FSplineType := aSplineType;
  FClosed := False;
  FTension := 0.5;
end;

procedure TBZ2DCatmullRomSplineCurve.ComputeCubicCoefs(x0, x1, t0, t1: Single; var c0, c1, c2, c3: Single);
begin
  c0 := x0;
  c1 := t0;
  c2 := -3 * x0 + 3 * x1 - 2 * t0 - t1;
  c3 :=  2 * x0 - 2 * x1 + t0 + t1;
end;

procedure TBZ2DCatmullRomSplineCurve.ComputeUniformCatmullRomCoefs(x0, x1, x2, x3, w: Single; var c0, c1, c2, c3: Single);
begin
  ComputeCubicCoefs( x1, x2, w * ( x2 - x0 ), w * ( x3 - x1 ), c0, c1, c2, c3 );
end;

procedure TBZ2DCatmullRomSplineCurve.ComputeNonUniformCatmullRomCoefs(x0, x1, x2, x3, dt0, dt1, dt2: Single; var c0, c1, c2, c3: Single);
var
  t1, t2 : Single;
begin
	t1 := ( x1 - x0 ) / dt0 - ( x2 - x0 ) / ( dt0 + dt1 ) + ( x2 - x1 ) / dt1;
	t2 := ( x2 - x1 ) / dt1 - ( x3 - x1 ) / ( dt1 + dt2 ) + ( x3 - x2 ) / dt2;

	t1 := t1 * dt1;
	t2 := t2 * dt1;
	ComputeCubicCoefs( x1, x2, t1, t2, c0, c1, c2, c3 );
end;

function TBZ2DCatmullRomSplineCurve.ComputeCoef(t, c0, c1, c2, c3: Single): Single;
var
  t2, t3 : Single;
begin
  t2 := t * t;
  t3 := t2 * t;
  result := c0 + c1 * t + c2 * t2 + c3 * t3;
end;

function TBZ2DCatmullRomSplineCurve.ComputePointAt(t: Single): TBZFloatPoint;
var
 k, pi : Integer;
 p, weight : Single;
 tmp, p0, p1, p2, p3 : TBZFloatPoint;
 dt0, dt1, dt2, powfactor, cx0, cx1, cx2, cx3, cy0, cy1, cy2, cy3 : Single;

begin
  k := Self.PointsList.Count;
  if FClosed then p := (k * t) else p := (k - 1) * t;
  pi := Floor(p);
  Weight := p - pi;

  if FClosed then
  begin
    if (pi <= 0) then pi := pi + ((floor(abs(pi) / k ) + 1 ) * k);
  end
  else if (Weight = 0) and (pi = (k - 1)) then
  begin
    pi := k - 2;
    Weight := 1;
  end;

  if (FClosed and (pi > 0)) then
  begin
    p0 := Self.Points[( pi - 1) mod k];
  end
  else
  begin
    tmp := Self.Points[0];
    p0 := (tmp - Self.Points[1]) + tmp;
  end;

  p1 := Self.Points[(pi mod k)];
  p2 := Self.Points[(pi + 1) mod k];

  if (FClosed or ((pi + 1) < k)) then
  begin
    p3 := Self.Points[(pi + 2) mod k];
  end
  else
  begin
    tmp := Self.Points[k - 1];
    p0 := (tmp - Self.Points[k - 2]) + tmp;
  end;

  Case FSplineType of
    cstCentripetal, cstChordal  :
    begin
      if (FSplineType = cstChordal) then powfactor := 0.5 else powfactor := 0.25;
      dt0 := power( p0.distanceSquare( p1 ), powfactor );
      dt1 := power( p1.distanceSquare( p2 ), powfactor );
      dt2 := power( p2.distanceSquare( p3 ), powfactor );

      // safety check for repeated points
      if ( dt1 < cEpsilon ) then dt1 := 1.0;
      if ( dt0 < cEpsilon ) then dt0 := dt1;
      if ( dt2 < cEpsilon ) then dt2 := dt1;

      ComputeNonuniformCatmullRomCoefs( p0.x, p1.x, p2.x, p3.x, dt0, dt1, dt2, cx0, cx1, cx2, cx3 );
		  ComputeNonuniformCatmullRomCoefs( p0.y, p1.y, p2.y, p3.y, dt0, dt1, dt2, cy0, cy1, cy2, cy3 );
    end;
    cstUniform:
    begin
      ComputeUniformCatmullRomCoefs( p0.x, p1.x, p2.x, p3.x, Ftension, cx0, cx1, cx2, cx3  );
		  ComputeUniformCatmullRomCoefs( p0.y, p1.y, p2.y, p3.y, Ftension, cy0, cy1, cy2, cy3  );
    end;
  end;
  Result.x := ComputeCoef(Weight, cx0, cx1, cx2, cx3);
  Result.y := ComputeCoef(Weight, cy0, cy1, cy2, cy3);
end;

function TBZ2DCatmullRomSplineCurve.ComputePolyLinePoints(Const nbStep: Integer): TBZArrayOfFloatPoints;
var
  nbSteps, i: Integer;
  Delta, aTime : Single;
  pt : TBZFloatPoint;
begin

  if (nbStep <= 0) then nbSteps := Self.ComputeOptimalSteps(Self.Tolerance)
  else nbSteps := nbStep;

  if not(FClosed) then
  begin
    Self.PointsList.Add(Self.Points[(Self.PointsList.Count - 1)]);
  end
  else nbSteps := nbSteps + 1;

  Result := TBZArrayOfFloatPoints.Create(32);
  aTime := 0;
  Delta := 1.0 / nbSteps;
  for i := 0 to (nbSteps - 1) do
  begin
    pt := ComputePointAt(aTime);
    aTime := aTime + Delta;
    Result.Add(pt);
  end;
  if CLosed then Result.Add(Self.Points[0]);
end;

{%endregion%}

end.

