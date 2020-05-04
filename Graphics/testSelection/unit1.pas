unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtDlgs,
  BZColors, BZGraphic, BZBitmap, BZMath, BZVectorMath, BZImageViewer, BZBitmapIO;

type

  { TForm1 }
  TBZRectSelectionDragMode = (sdmNone, sdmInside, sdmTop, sdmBottom, sdmLeft, sdmRight,
                              sdmTopLeft, sdmTopRight, sdmBottomLeft, sdmBottomRight);
  TForm1 = class(TForm)
    Button1 : TButton;
    Label1 : TLabel;
    OPD : TOpenPictureDialog;
    BZImageViewer1 : TBZImageViewer;
    procedure BZImageViewer1MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure BZImageViewer1MouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure BZImageViewer1MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure FormCreate(Sender : TObject);
    procedure Button1Click(Sender : TObject);
  private
    FSelectionMouseActive : Boolean;
    FEmptySelection : Boolean;
    FRectSelectionDragMode : TBZRectSelectionDragMode;
    FPointRadiusSize : Byte;
    FStartPos, FEndPos : TBZPoint;
    FPreviousStartPos, FPreviousEndPos : TBZPoint;
    FCurrentMousePos, FLastMousePos : TBZPoint;
    FBoundTopLeftPoint,
    FBoundTopRightPoint,
    FBoundTopCenterPoint,
    FBoundBottomLeftPoint,
    FBoundBottomRightPoint,
    FBoundBottomCenterPoint,
    FBoundLeftCenterPoint,
    FBoundRightCenterPoint,
    FBoundCenterPoint,
    FSelectionRect : TBZRect;

  protected
    procedure ResetRectangleSelection;
    procedure UpdateMoves;

    procedure DrawPoint(x,y : Integer; VirtualCanvas : TBZBitmapCanvas);
    procedure DrawRectangleSelection(VirtualCanvas : TBZBitmapCanvas);

    procedure DoRectSelectionMouseDownHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure DoRectSelectionMouseUpHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure DoRectSelectionMouseMoveHandle(Sender : TObject; Shift : TShiftState; X, Y : Integer);
  public

  end;

var
  Form1 : TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BZImageViewer1MouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  DoRectSelectionMouseDownHandle(Sender, Button, Shift, X, Y);
end;

procedure TForm1.BZImageViewer1MouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
begin
  DoRectSelectionMouseMoveHandle(Sender, Shift, X, Y);
end;

procedure TForm1.BZImageViewer1MouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  DoRectSelectionMouseUpHandle(Sender, Button, Shift, X, Y);
end;

procedure TForm1.FormCreate(Sender : TObject);
begin
  ResetRectangleSelection;
  BZImageViewer1.OnAfterPaint := @DrawRectangleSelection;
end;

procedure TForm1.Button1Click(Sender : TObject);
begin
  if OPD.Execute then
  begin
    BZImageViewer1.Picture.LoadFromFile(OPD.FileName);
    BZImageViewer1.Invalidate;
  end;
end;

procedure TForm1.ResetRectangleSelection;
begin
  FStartPos.Create(0,0);
  FEndPos.Create(0,0);
  FPreviousStartPos.Create(0,0);
  FPreviousEndPos.Create(0,0);
  FEmptySelection := True;
  FRectSelectionDragMode := sdmNone;
  FSelectionMouseActive := False;
  FPointRadiusSize := 4;
end;

procedure TForm1.UpdateMoves;
begin
  //FSelectionRect.Create(FStartPos.X + FPointRadiusSize, FStartPos.Y + FPointRadiusSize, FEndPos.X - FPointRadiusSize, FEndPos.Y - FPointRadiusSize, true);
  FSelectionRect.Create(FStartPos.X, FStartPos.Y, FEndPos.X, FEndPos.Y, true);
  FBoundTopLeftPoint.Create((FSelectionRect.TopLeft - FPointRadiusSize), (FSelectionRect.TopLeft + FPointRadiusSize));

  FBoundTopRightPoint.Create((FSelectionRect.Right - FPointRadiusSize), (FSelectionRect.Top - FPointRadiusSize), (FSelectionRect.Right + FPointRadiusSize), (FSelectionRect.Top + FPointRadiusSize));
  //FBoundTopRightPoint.Create(FEndPos.X - FPointRadiusSize, FStartPos.Y  - FPointRadiusSize, FEndPos.X + FPointRadiusSize, FStartPos.Y + FPointRadiusSize);
  FBoundBottomLeftPoint.Create((FSelectionRect.Left - FPointRadiusSize), (FSelectionRect.Bottom - FPointRadiusSize), (FSelectionRect.Left + FPointRadiusSize), (FSelectionRect.Bottom + FPointRadiusSize));
  //FBoundBottomLeftPoint.Create(FStartPos.X - FPointRadiusSize, FEndPos.Y  - FPointRadiusSize, FStartPos.X + FPointRadiusSize, FEndPos.Y + FPointRadiusSize);
  FBoundBottomRightPoint.Create((FSelectionRect.BottomRight - FPointRadiusSize), (FSelectionRect.BottomRight + FPointRadiusSize));
  //FBoundBottomRightPoint.Create(FEndPos.X - FPointRadiusSize, FEndPos.Y  - FPointRadiusSize, FEndPos.X + FPointRadiusSize, FEndPos.Y + FPointRadiusSize);
  FBoundTopCenterPoint.Create((FSelectionRect.CenterPoint.X - FPointRadiusSize), (FSelectionRect.Top - FPointRadiusSize),(FSelectionRect.CenterPoint.X + FPointRadiusSize), (FSelectionRect.Top + FPointRadiusSize));
  //FBoundTopCenterPoint.Create(HorizMiddle - FPointRadiusSize, FStartPos.Y - FPointRadiusSize, HorizMiddle + FPointRadiusSize, FStartPos.Y + FPointRadiusSize);
  FBoundBottomCenterPoint.Create((FSelectionRect.CenterPoint.X - FPointRadiusSize), (FSelectionRect.Bottom - FPointRadiusSize),(FSelectionRect.CenterPoint.X + FPointRadiusSize), (FSelectionRect.Bottom + FPointRadiusSize));
  //FBoundBottomCenterPoint.Create(HorizMiddle - FPointRadiusSize, FEndPos.Y - FPointRadiusSize, HorizMiddle + FPointRadiusSize, FEndPos.Y + FPointRadiusSize);
  FBoundLeftCenterPoint.Create((FSelectionRect.Left - FPointRadiusSize), (FSelectionRect.CenterPoint.Y - FPointRadiusSize), (FSelectionRect.Left + FPointRadiusSize), (FSelectionRect.CenterPoint.Y + FPointRadiusSize));
  //FBoundLeftCenterPoint.Create(FStartPos.X - FPointRadiusSize, VertMiddle - FPointRadiusSize, FStartPos.X + FPointRadiusSize, VertMiddle + FPointRadiusSize);
  FBoundRightCenterPoint.Create((FSelectionRect.Right - FPointRadiusSize), (FSelectionRect.CenterPoint.Y - FPointRadiusSize), (FSelectionRect.Right + FPointRadiusSize), (FSelectionRect.CenterPoint.Y + FPointRadiusSize));
  //FBoundRightCenterPoint.Create(FEndPos.X - FPointRadiusSize, VertMiddle - FPointRadiusSize, FEndPos.X + FPointRadiusSize, VertMiddle + FPointRadiusSize);
  FBoundCenterPoint.Create((FSelectionRect.CenterPoint.X - FPointRadiusSize), (FSelectionRect.CenterPoint.Y - FPointRadiusSize),(FSelectionRect.CenterPoint.X + FPointRadiusSize), (FSelectionRect.CenterPoint.Y + FPointRadiusSize));
  //FBoundCenterPoint.Create(HorizMiddle - FPointRadiusSize, VertMiddle - FPointRadiusSize, HorizMiddle + FPointRadiusSize, VertMiddle + FPointRadiusSize);

end;

procedure TForm1.DrawPoint(x, y : Integer; VirtualCanvas : TBZBitmapCanvas);
Var
  OldPenStyle : TBZStrokeStyle;
  OldBrushStyle : TBZBrushStyle;
  OldCombineMode : TBZColorCombineMode;
  OldPixelMode : TBZBitmapDrawMode;
  OldAlphaMode : TBZBitmapAlphaMode;
  OldPenColor : TBZColor;
  OldBrushColor : TBZColor;
begin
  With VirtualCanvas do
  begin
    OldPenStyle := Pen.Style;
    OldPenColor := Pen.Color;
    OldBrushStyle := Brush.Style;
    OldBrushColor := Brush.Color;
    OldCombineMode := DrawMode.CombineMode;
    OldPixelMode := DrawMode.PixelMode;
    OldAlphaMode := DrawMode.AlphaMode;
    DrawMode.PixelMode := dmCombine;
    DrawMode.AlphaMode := amNone; //amAlphaBlendHQ;
    DrawMode.CombineMode := cmXOr;
    Pen.Style := ssSolid;
    Pen.Color := clrYellow;
    Brush.Style := bsSolid;
    Brush.Color := clrRed;
    //Rectangle(X - FPointRadiusSize, Y  - FPointRadiusSize, X + FPointRadiusSize, Y + FPointRadiusSize);
    Circle(X,Y, FPointRadiusSize);
    Pen.Style := OldPenStyle;
    Pen.Color := OldPenColor;
    Brush.Style := OldBrushStyle;
    Brush.Color := OldBrushColor;
    DrawMode.CombineMode := OldCombineMode;
    DrawMode.PixelMode := OldPixelMode;
    DrawMode.AlphaMode := OldAlphaMode;
  end;
end;

procedure TForm1.DrawRectangleSelection(VirtualCanvas : TBZBitmapCanvas);
Var
  OldPenStyle : TBZStrokeStyle;
  OldBrushStyle : TBZBrushStyle;
  OldCombineMode : TBZColorCombineMode;
  OldAlphaMode : TBZBitmapAlphaMode;
  OldPixelMode : TBZBitmapDrawMode;
  OldPenColor : TBZColor;
  VertMiddle, HorizMiddle : Integer;
begin

  With VirtualCanvas do
  begin
    OldCombineMode := DrawMode.CombineMode;
    OldPixelMode := DrawMode.PixelMode;
    OldAlphaMode := DrawMode.AlphaMode;
    OldPenStyle := Pen.Style;
    OldPenColor := Pen.Color;
    OldBrushStyle := Brush.Style;
    DrawMode.PixelMode := dmCombine;
    DrawMode.AlphaMode := amNone; //amAlphaBlendHQ;
    DrawMode.CombineMode := cmXor;
    Pen.Style := ssSolid;
    Pen.Color := clrYellow;
    Brush.Style := bsClear;
    Rectangle(FSelectionRect);// (FStartPos.X, FStartPos.Y, FEndPos.X, FEndPos.Y);
    Pen.Style := OldPenStyle;
    Pen.Color := OldPenColor;
    Brush.Style := OldBrushStyle;
    DrawMode.CombineMode := OldCombineMode;
    DrawMode.PixelMode := OldPixelMode;
    DrawMode.AlphaMode := OldAlphaMode;
  end;

  HorizMiddle :=   FSelectionRect.CenterPoint.X;
  VertMiddle := FSelectionRect.CenterPoint.Y;

  DrawPoint(FSelectionRect.Left, FSelectionRect.Top, VirtualCanvas);
  DrawPoint(FSelectionRect.Left, FSelectionRect.Bottom, VirtualCanvas);
  DrawPoint(FSelectionRect.Right, FSelectionRect.Top, VirtualCanvas);
  DrawPoint(FSelectionRect.Right, FSelectionRect.Bottom, VirtualCanvas);
  DrawPoint(HorizMiddle, FSelectionRect.Top, VirtualCanvas);
  DrawPoint(HorizMiddle, FSelectionRect.Bottom, VirtualCanvas);
  DrawPoint(FSelectionRect.Left, VertMiddle, VirtualCanvas);
  DrawPoint(FSelectionRect.Right, VertMiddle, VirtualCanvas);
  DrawPoint(HorizMiddle, VertMiddle, VirtualCanvas);

end;

procedure TForm1.DoRectSelectionMouseDownHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FSelectionMouseActive := True;
  FCurrentMousePos.Create(X, Y);
  if FEmptySelection then
  begin
    FStartPos := FCurrentMousePos + BZImageViewer1.VirtualViewPort.TopLeft;
    FRectSelectionDragMode := sdmBottomRight;
  end
  else
  begin

    if FBoundTopLeftPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmTopLeft;
      Screen.Cursor := crSizeNWSE;
    end
    else if FBoundTopRightPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmTopRight;
      Screen.Cursor := crSizeNESW;
    end
    else if FBoundTopCenterPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmTop;
      Screen.Cursor := crSizeNS;
    end
    else if FBoundBottomLeftPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmBottomLeft;
      Screen.Cursor := crSizeNESW;
    end
    else if FBoundBottomCenterPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmBottom;
      Screen.Cursor := crSizeNS;
    end
    else if FBoundBottomRightPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmBottomRight;
      Screen.Cursor := crSizeNWSE;
    end
    else if FBoundLeftCenterPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmLeft;
      Screen.Cursor := crSizeWE;
    end
    else if FBoundRightCenterPoint.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmRight;
      Screen.Cursor := crSizeWE;
    end
    else if FSelectionRect.PointInRect(FCurrentMousePos) then
    begin
      FRectSelectionDragMode := sdmInside;
      Screen.Cursor := crSizeAll;
    end
    else
    begin
      FRectSelectionDragMode := sdmNone;
      Screen.Cursor := crDefault;
    end;
    FLastMousePos := FCurrentMousePos;
  end;
end;

procedure TForm1.DoRectSelectionMouseUpHandle(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
Var
  TempPos : TBZPoint;
begin
  FSelectionMouseActive := False;
  if FEmptySelection then FEmptySelection := False;
  FRectSelectionDragMode := sdmNone;

  if (FStartPos.X > FEndPos.X) or (FStartPos.Y > FEndPos.Y) then
  begin
    TempPos := FStartPos;
    FStartPos := FEndPos;
    FEndPos := TempPos;
    BZImageViewer1.Invalidate;
  end;
  Screen.Cursor := crDefault;
end;

procedure TForm1.DoRectSelectionMouseMoveHandle(Sender : TObject; Shift : TShiftState; X, Y : Integer);
Var
  DeltaPos, MinMax : TBZPoint;
begin
  FCurrentMousePos.Create(X, Y);
  FCurrentMousePos := FCurrentMousePos + BZImageViewer1.VirtualViewPort.TopLeft;


  if FSelectionMouseActive then
  begin
    if (ssLeft in Shift) then
    begin
      FPreviousStartPos := FStartPos;
      FPreviousEndPos := FEndPos;

      if FEmptySelection then
      begin
        FEndPos := FCurrentMousePos + BZImageViewer1.VirtualViewPort.TopLeft;
        UpdateMoves;
        BZImageViewer1.Invalidate;
      end
      else
      begin
        Case FRectSelectionDragMode of
          sdmInside:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FStartPos := FStartPos + DeltaPos;
            FEndPos := FEndPos + DeltaPos;
            MinMax.Create(BZImageViewer1.Picture.Bitmap.MaxWidth ,BZImageViewer1.Picture.Bitmap.MaxHeight);
            FEndPos := FEndPos.Min(MinMax);
            MinMax.Create(BZImageViewer1.Picture.Bitmap.MaxWidth - (FEndPos.X - FStartPos.X),BZImageViewer1.Picture.Bitmap.MaxHeight - (FEndPos.Y - FStartPos.Y));
            FStartPos := FStartPos.Min(MinMax);
          end;
          sdmTop:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FStartPos.Y := max(0,min((FStartPos.Y + DeltaPos.Y), FEndPos.Y));
          end;
          sdmBottom:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FEndPos.Y := min(BZImageViewer1.Picture.Bitmap.MaxHeight, max((FEndPos.Y + DeltaPos.Y), FStartPos.Y));
          end;
          sdmLeft:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FStartPos.X := max(0,min((FStartPos.X + DeltaPos.X), FEndPos.X));
          end;
          sdmRight:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FEndPos.X := min(BZImageViewer1.Picture.Bitmap.MaxWidth, max((FEndPos.X + DeltaPos.X), FStartPos.X));
          end;
          sdmTopLeft:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FStartPos := FStartPos + DeltaPos;
            FStartPos := FStartPos.Min(FEndPos);
            MinMax.Create(0,0);
            FStartPos := FStartPos.Max(MinMax);
          end;
          sdmTopRight:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FEndPos.X := min(BZImageViewer1.Picture.Bitmap.MaxWidth, max((FEndPos.X + DeltaPos.X), FStartPos.X));
            FStartPos.Y := max(0, min((FStartPos.Y + DeltaPos.Y), FEndPos.Y));
          end;
          sdmBottomLeft:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FEndPos.Y := min(BZImageViewer1.Picture.Bitmap.MaxHeight,max((FEndPos.Y + DeltaPos.Y), FStartPos.Y));
            FStartPos.X := max(0, min((FStartPos.X + DeltaPos.X), FEndPos.X));
          end;
          sdmBottomRight:
          begin
            DeltaPos := FCurrentMousePos - FLastMousePos;
            FEndPos := FEndPos + DeltaPos;
            FEndPos := FEndPos.Max(FStartPos);
            MinMax.Create(BZImageViewer1.Picture.Bitmap.MaxWidth,BZImageViewer1.Picture.Bitmap.MaxHeight);
            FEndPos := FEndPos.Max(MinMax);
          end;
        end;
        UpdateMoves;
        BZImageViewer1.Invalidate;
      end;
      FLastMousePos := FCurrentMousePos;
    end
    else
    begin
      Screen.Cursor := crDefault;
    end;
  end
  else
  begin
    if Not(FEmptySelection) then
    begin
      if FBoundTopLeftPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmTopLeft;
        Screen.Cursor := crSizeNWSE;
      end
      else if FBoundTopRightPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmTopRight;
        Screen.Cursor := crSizeNESW;
      end
      else if FBoundTopCenterPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmTop;
        Screen.Cursor := crSizeNS;
      end
      else if FBoundBottomLeftPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmBottomLeft;
        Screen.Cursor := crSizeNESW;
      end
      else if FBoundBottomCenterPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmBottom;
        Screen.Cursor := crSizeNS;
      end
      else if FBoundBottomRightPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmBottomRight;
        Screen.Cursor := crSizeNWSE;
      end
      else if FBoundLeftCenterPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmLeft;
        Screen.Cursor := crSizeWE;
      end
      else if FBoundRightCenterPoint.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmRight;
        Screen.Cursor := crSizeWE;
      end
      else if FSelectionRect.PointInRect(FCurrentMousePos) then
      begin
        //FRectSelectionDragMode := sdmInside;
        Screen.Cursor := crSizeAll;
      end
      else
      begin
        //FRectSelectionDragMode := sdmNone;
        Screen.Cursor := crDefault;
      end;
    end;
  end;

end;

end.

