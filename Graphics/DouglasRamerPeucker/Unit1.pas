unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Menus, StdCtrls, ComCtrls,
  BZMath, BZVectorMath, BZColors, BZGraphic, BZBitmap, BZGeoTools;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1 : TButton;
    Memo1 : TMemo;
    pnlView : TPanel;
    tbTolerance : TTrackBar;
    procedure Button1Click(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormCreate(Sender : TObject);
    procedure pnlViewPaint(Sender : TObject);
    procedure tbToleranceChange(Sender : TObject);
  private
    FArrayOfPoints : TBZArrayOfFloatPoints;
    FDisplayBuffer : TBZBitmap;
    FRDPPoints : TBZArrayOfFloatPoints;
    FDistPoints : TBZArrayOfFloatPoints;

  protected
    procedure SimplifyDist(InPts : TBZArrayOfFloatPoints; Tolerance : Single; out OutPts : TBZArrayOfFloatPoints);
    procedure Internal_RamerDouglasPeucker(InPts : TBZArrayOfFloatPoints; Tolerance : Single; StartIndex, EndIndex : Integer; Var KeepPoints : Array of Boolean);
    procedure SimplifyRamerDouglasPeucker(InPts : TBZArrayOfFloatPoints; Tolerance : Single; out OutPts : TBZArrayOfFloatPoints);

  public
    procedure GenPolyLine;
    procedure RenderPolyLine;
    procedure RenderPolyLineSimplyfied;

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses BZTypesHelpers;

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FDisplayBuffer := TBZBitmap.Create(pnlView.Width, pnlView.Height);
  FDisplayBuffer.Clear(clrBlack);
  FArrayOfPoints := TBZArrayOfFloatPoints.Create(1024);
  Randomize;
  GenPolyLine;
  RenderPolyLine;
end;

procedure TMainForm.pnlViewPaint(Sender : TObject);
begin
  FDisplayBuffer.DrawToCanvas(pnlView.Canvas, pnlView.ClientRect);
end;

procedure TMainForm.tbToleranceChange(Sender : TObject);
begin
  Button1Click(Self);
end;

procedure TMainForm.SimplifyDist(InPts : TBZArrayOfFloatPoints; Tolerance : Single; out OutPts : TBZArrayOfFloatPoints);
Var
  KeepPoints : Array of Boolean;
  i, j, k : Integer;
  //SqTolerance : Single;
  {$CODEALIGN VARMIN=16}
  PrevPoint, CurrentPoint : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
begin
  //SqTolerance := Tolerance* Tolerance;
  k := InPts.Count;
  SetLength(KeepPoints{%H-}, k);
  KeepPoints[0] := True;
  KeepPoints[k-1] := True;
  For i := 2 to k-2 do KeepPoints[i] := False;
  PrevPoint  := InPts.Items[0];
  j := 1;
  For i := 1 to k-1 do
  begin
    CurrentPoint := InPts.Items[i];
    //if (CurrentPoint.DistanceSquare(PrevPoint) > SqTolerance) then
    if (CurrentPoint.Distance(PrevPoint) > Tolerance) then
    begin
      KeepPoints[i] := True;
      PrevPoint := CurrentPoint;
      Inc(j);
    end;
  end;
  OutPts := TBZArrayofFloatPoints.Create(j);
  For i := 0 to k - 1 do
  begin
    if KeepPoints[i] then
    begin
      OutPts.Add(InPts.Items[i]);
    end;
  end;

end;

procedure TMainForm.Internal_RamerDouglasPeucker(InPts : TBZArrayOfFloatPoints; Tolerance : Single; StartIndex, EndIndex : Integer; var KeepPoints : array of Boolean);
Var
  {$CODEALIGN VARMIN=16}
  p1, p2, p : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
  aLine : TBZ2DLineTool;
  i, MaxIndex : Integer;
  MaxDist, Dist : Single;
begin
  MaxIndex := 0;
  MaxDist := -1.0;
  p1 := InPts.Items[StartIndex];
  p2 := InPts.Items[EndIndex];
  aLine := TBZ2DLineTool.Create;
  aLine.StartPoint := p1;
  aLine.EndPoint := p2;
  for i := StartIndex + 1 to EndIndex - 1 do
  begin
    p := InPts.Items[i];
    Dist := aLine.DistanceSegmentToPoint(p);

    if Dist > MaxDist then
    begin
      MaxIndex := i;
      MaxDist := Dist;
    end;
  end;
  FreeAndNil(aLine);

  if MaxDist > Tolerance then
  begin
    KeepPoints[MaxIndex] := True;

    if (MaxIndex - StartIndex) > 1 then Internal_RamerDouglasPeucker(InPts, Tolerance, StartIndex, MaxIndex, KeepPoints);
    if (EndIndex - MaxIndex) > 1 then Internal_RamerDouglasPeucker(InPts, Tolerance, MaxIndex, EndIndex, KeepPoints);
  end;
end;

procedure TMainForm.SimplifyRamerDouglasPeucker(InPts : TBZArrayOfFloatPoints; Tolerance : Single; out OutPts : TBZArrayOfFloatPoints);
Var
  KeepPoints : Array of Boolean;
  i, j, k : Integer;
  //SqTolerance : Single;
begin
  //SqTolerance := Tolerance * Tolerance;
  k := InPts.Count;
  SetLength(KeepPoints{%H-}, k);
  KeepPoints[0] := True;
  KeepPoints[k-1] := True;
  For i := 2 to k-2 do KeepPoints[i] := False;

  Internal_RamerDouglasPeucker(InPts, Tolerance, 0, k, KeepPoints);

  j := 0;

  for i:= 0 to k - 1 do
  begin
    if KeepPoints[i] then Inc(j);
  end;

  OutPts := TBZArrayOfFloatPoints.Create(j);

  for i := 0 to k-1 do
  begin
    if KeepPoints[i] then
    begin
      OutPts.Add(InPts.Items[i]);
    end;
  end;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FArrayOfPoints);
  if Assigned(FDistPoints) then FreeAndNil(FDistPoints);
  if Assigned(FRDPPoints) then FreeAndNil(FRDPPoints);
  FreeAndNil(FDisplayBuffer);
end;

procedure TMainForm.Button1Click(Sender : TObject);
begin
  FDisplayBuffer.Clear(clrBlack);
  if Assigned(FDistPoints) then FreeAndNil(FDistPoints);
  if Assigned(FRDPPoints) then FreeAndNil(FRDPPoints);
  SimplifyDist(FArrayOfPoints, tbTolerance.Position, FDistPoints);
  //SimplifyRamerDouglasPeucker(FArrayOfPoints, tbTolerance.Position, FRDPPoints);
  SimplifyRamerDouglasPeucker(FDistPoints, tbTolerance.Position, FRDPPoints);
  RenderPolyLine;
  RenderPolyLineSimplyfied;
  pnlView.Invalidate;
end;

procedure TMainForm.GenPolyLine;
Var
   x, i : Integer;
   {$CODEALIGN VARMIN=16}
   NewPt : TBZFloatPoint;
   {$CODEALIGN VARMIN=4}
begin
  x := 0;
  While x < FDisplayBuffer.MaxWidth do
  //For x := 0 to FDisplayBuffer.MaxWidth do
  begin
    i := Integer.RandomRange(20,FDisplayBuffer.MaxHeight - 20);
    NewPt.Create(x, i);
    FArrayOfPoints.Add(NewPt);
    inc(x,3);
  end;
end;

procedure TMainForm.RenderPolyLine;
begin
  With FDisplayBuffer.Canvas do
  begin
    Pen.Style := ssSolid;
    Pen.Color := clrBlue;
    PolyLine(FArrayOfPoints);
  end;
 // pnlView.Invalidate;
end;

procedure TMainForm.RenderPolyLineSimplyfied;
begin
  With FDisplayBuffer.Canvas do
  begin
    Pen.Style := ssSolid;
    //Pen.Color := clrYellow;
    //PolyLine(FDistPoints);
    Pen.Color := clrFuchsia;
    PolyLine(FRDPPoints);
  end;
 // pnlView.Invalidate;
end;


end.

