Unit uMainForm;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls, Spin, ExtDlgs, ComCtrls,
  BZMath, BZVectorMath, BZColors, BZGraphic, BZBitmap, BZImageViewer, BZBitmapIO, BZStopWatch, fpReadPNG;

Type

  { TMainform }
  TSelectTool = (stPen,stLine, stRect, stRoundRect, stCircle, stEllipse);
  TMainform = Class(Tform)
    Panel1 : TPanel;
    Panel2 : TPanel;
    Panel3 : TPanel;
    pnlView : TPanel;
    Speedbutton1 : TSpeedButton;
    Speedbutton2 : TSpeedButton;
    Speedbutton3 : TSpeedButton;
    Speedbutton4 : TSpeedButton;
    Speedbutton5 : TSpeedButton;
    Speedbutton6 : TSpeedButton;
    Panel5 : TPanel;
    Panel6 : TPanel;
    Label1 : TLabel;
    btnStrokeColor : TColorButton;
    Label2 : TLabel;
    iseStrokeWidth : TSpinEdit;
    Panel7 : TPanel;
    Label3 : TLabel;
    btnFillColor : TColorButton;
    cbxFillMode : TComboBox;
    cbxGradientKind : TComboBox;
    btnOpenTexture : TSpeedButton;
    opd : TOpenPictureDialog;
    ImageView : TBZImageViewer;
    Panel8 : TPanel;
    chkAntialias : TCheckBox;
    Label4 : TLabel;
    cbxDrawMode : TComboBox;
    Label5 : TLabel;
    cbxCombineMode : TComboBox;
    Label6 : TLabel;
    Spinedit1 : TSpinEdit;
    Label7 : TLabel;
    cbxZoom : TComboBox;
    Label8 : TLabel;
    lblMousePos : TLabel;
    Label9 : TLabel;
    Label10 : TLabel;
    Procedure FormCreate(Sender : Tobject);
    Procedure BtnOpenTextureClick(Sender : Tobject);

    procedure FormShow(Sender : TObject);
    procedure FormDestroy(Sender : TObject);

    Procedure ImageViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure ImageViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    Procedure ImageViewMouseUp(Sender : Tobject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure SpeedButton1Click(Sender : TObject);
    procedure btnStrokeColorColorChanged(Sender : TObject);
    procedure btnFillColorColorChanged(Sender : TObject);
    procedure iseStrokeWidthChange(Sender : TObject);
    procedure cbxZoomSelect(Sender : TObject);
  Private
    FDisplayBuffer : TBZBitmap;
    FCanvasBuffer  : TBZBitmap;
    FTempBuffer    : TBZBitmap;
  Protected
    SelectedTool  : TSelectTool;
    smx, smy, emx, emy  : Integer;
    FScrollViewOffset, FLastScrollViewOffset, FLastViewMousePos, FViewMousePos : TPoint;
    DoDraw : Boolean;
  Public
    procedure UpdateDisplay;
  End;

Var
  MainForm : TMainform;

Implementation

{$R *.lfm}

uses BZVectorMathUtils, BZGeoTools, BZLogger;

{ TMainform }

Procedure TMainform.FormCreate(Sender : Tobject);
Begin
  smx := 0;
  smy := 0;
  emx := 0;
  emy := 0;
  SelectedTool := stPen;
  DoDraw := False;
End;

Procedure TMainform.BtnOpenTextureClick(Sender : Tobject);
Var
  bmp:TBZBitmap;
begin
  if opd.Execute then
  begin
    Try
       bmp:=TBZBitmap.Create;
       bmp.LoadFromFile(opd.filename);
    finally
      //Need Transtype for loading bitmap here
      FCanvasBuffer.Canvas.Brush.Texture.Assign(bmp);
      FTempBuffer.Canvas.Brush.Texture.Assign(Bmp);
      //ImageView.Picture.Bitmap.Assign(bmp);
      //ImageView.Invalidate;
      FreeAndNil(bmp);
    end;
  end;
End;

procedure TMainform.FormShow(Sender : TObject);
CONST
  R0 = 0.420;
  R1 = 0.150 ;
  R2 = R0 - R1;
  NmaxV = 80;
VAR
  i: Integer;
  Ct, St, t, u, v, ww, D_PisN,nx,ny : Single;
  w,h : Integer;
  Points, StrokePoints : TBZArrayOfFloatPoints;
  PolyTool, PolyTool2 : TBZ2DPolygonTool;
  {$CODEALIGN VARMIN=16}
  pt : TBZFloatPoint;
  {$CODEALIGN VARMIN=4}
begin
  //ShowMessage(Inttostr(3 div 2));
 // GlobalLogger.ShowLogView;
  w := pnlView.ClientWidth;
  h := pnlView.ClientHeight;
  FDisplayBuffer := TBZBitmap.Create(w,h);
  FCanvasBuffer  := TBZBitmap.Create(w,h);
  FTempBuffer    := TBZBitmap.Create(w,h);

  FDisplayBuffer.Clear(clrTransparent);
  FCanvasBuffer.Clear(clrTransparent);
  FTempBuffer.Clear(clrWhite);
  FTempBuffer.Canvas.Pen.Color := clrBlack;
  FCanvasBuffer.Canvas.Pen.Color := clrBlack;
  FTempBuffer.Canvas.Brush.Color := clrBlack;
  FCanvasBuffer.Canvas.Brush.Color := clrBlack;
  ImageView.Picture.Bitmap.SetSize(w,h);
  ImageView.ZoomGrid := True;

  StrokePoints := TBZArrayOfFloatPoints.Create(12);

  //
  //  6/10
  // 0 *---------------* 7
  //   |-\\------------|
  //   |---*-------*---|
  //   |---|1/5   4|---|
  //   |---|       |---|
  //   |---|2     3|---|
  //   |---*-------*---|
  //   |---------------|
  // 9 *---------------* 8
  //

  //StrokePoints.Add(vec2(20,6));  //0
  //StrokePoints.Add(vec2(22,8));  //1
  //StrokePoints.Add(vec2(22,12));  //2
  //StrokePoints.Add(vec2(26,12));  //3
  //StrokePoints.Add(vec2(26,8));  //4
  //StrokePoints.Add(vec2(22,8));  //5
  //StrokePoints.Add(vec2(20,6));  //6
  //StrokePoints.Add(vec2(28,6)); //7
  //StrokePoints.Add(vec2(28,14));//8
  //StrokePoints.Add(vec2(20,14)); //9
  //StrokePoints.Add(vec2(20,6));  //10

  //
  //   10
  // 0 *---------------* 1
  //   |---------------|
  //   |---*-------*---|
  //   |---|7     6|---|
  //   |---|       |---|
  //   |---|4/8   5|---|
  //   |---*-------*---|
  //   |-//------------|
  // 3 *---------------* 2
  //   9

  //StrokePoints.Add(vec2(20,6));  //0
  //StrokePoints.Add(vec2(28,6)); //7
  //StrokePoints.Add(vec2(28,14));//8
  //StrokePoints.Add(vec2(20,14)); //9
  //
  //StrokePoints.Add(vec2(22,12));  //2
  //StrokePoints.Add(vec2(26,12));  //3
  //StrokePoints.Add(vec2(26,8));  //4
  //StrokePoints.Add(vec2(22,8));  //1
  //
  //StrokePoints.Add(vec2(22,12));  //2
  //StrokePoints.Add(vec2(20,14)); //9
  //
  //StrokePoints.Add(vec2(20,6));  //10

  //
  //   10
  // 0 *---------------* 1
  //   |---------------|
  //   |---*-------*---|
  //   |---|5     6|---|
  //   |---|       |---|
  //   |---|4/8   7|---|
  //   |---*-------*---|
  //   |-//------------|
  // 3 *---------------* 2
  //   9
  //StrokePoints.Add(vec2(20,6));  //0
  //StrokePoints.Add(vec2(28,6)); //7
  //StrokePoints.Add(vec2(28,14));//8
  //StrokePoints.Add(vec2(20,14)); //9
  //
  //StrokePoints.Add(vec2(22,12));  //2
  //StrokePoints.Add(vec2(22,8));  //1
  //StrokePoints.Add(vec2(26,8));  //4
  //StrokePoints.Add(vec2(26,12));  //3
  //
  //StrokePoints.Add(vec2(22,12));  //2
  //StrokePoints.Add(vec2(20,14)); //9
  //
  //StrokePoints.Add(vec2(20,6));  //10

  PolyTool := TBZ2DPolygonTool.Create;
  PolyTool2 := TBZ2DPolygonTool.Create;

     //D_PisN := c2Pi / NmaxV;
     //RandSeed:= 1222333555;
     ////Randomize;
     //FOR i:= 1 TO NmaxV DO
     //  BEGIN
     //    t:= i * D_PisN;
     //    Ct:= Cos(t);
     //    St:= Sin(t);
     //    u:= Random;
     //    v:=  R1 + (R2 * u);
     //    ww:= v * Ct;
     //    nx := (ImageView.Width * (ww + R0));
     //    //GlobalLogger.LogStatus('NX = '+nx.ToString);
     //    //if nx < 0 then nx := (ImageView.Width / 2) + nx;
     //    ww:= v * St;
     //    ny := (ImageView.Height * (ww + R0));
     //    //GlobalLogger.LogStatus('NY = '+ny.ToString);
     //    //if ny < 0 then ny := (ImageView.Height / 2) + ny;
     //    StrokePoints.Add(vec2(100+nx,50+ny));
     //  END;
//
//     StrokePoints.Add(vec2(120,120));
//     StrokePoints.Add(vec2(240,120));
//     StrokePoints.Add(vec2(300,180));
//     StrokePoints.Add(vec2(300,120));
//     StrokePoints.Add(vec2(180,220));
//     StrokePoints.Add(vec2(120,180));





     StrokePoints.Add(vec2(125,110));
     StrokePoints.Add(vec2(25,110));
     StrokePoints.Add(vec2(40,20));
     StrokePoints.Add(vec2(140,80));
     StrokePoints.Add(vec2(10,80));
     StrokePoints.Add(vec2(110,20));

  PolyTool.AssignPoints(StrokePoints);
  PolyTool2.AssignPoints(StrokePoints);
  For i := 0 to StrokePoints.Count - 1 do
  begin
    pt := PolyTool2.Points[i];
    pt.X := pt.X + 250;
    PolyTool2.Points[i] := pt;
  end;


  GlobalLogger.LogNotice('StrokePoint Count = ' + StrokePoints.Count.ToString);
  Case PolyTool.GetPolygonType of
    ptConvex : Label9.Caption := 'Est convexe';
    ptConcave : Label9.Caption := 'Est concave';
    ptComplex : Label9.Caption := 'Est complexe';
  end;
  if PolyTool.IsMonotoneVertical then Label10.Caption := 'Est Monotone vertical' else Label10.Caption := 'Est monotone horizontal';

  With FTempBuffer.Canvas do
  begin
    Pen.Style := ssSolid;
    Pen.Color := clrBlack;
    //Pen.Width := 3;
    //Rectangle(8,8,12,12);
    //Pen.Color := clrRed;
    Pen.Width := 1;

    //Line(18,2,18,22);
    //AntiAlias := False;
    Brush.Style := bsSolid;
    //Brush.Color := clrWhite;
    Brush.Color := clrBlue;
    //Pen.Width := 10;
    //Rectangle(40,40,80,80);

   // Rectangle(8,8,12,12);
    //Pen.Width := 6;
    //GlobalPerformanceTimer.Start;
    Polygon(StrokePoints);
    Polygon(PolyTool2.PointsList);
    //GlobalPerformanceTimer.Stop;


  end;
  //Caption := GlobalPerformanceTimer.getValueAsMicroSeconds;

  FreeAndNil(PolyTool);
  FreeAndNil(PolyTool2);
  FreeAndNil(StrokePoints);

  //ImageView.Picture.Bitmap.Clear(clrWhite);
  UpdateDisplay;
end;

procedure TMainform.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FTempBuffer);
  FreeAndNil(FCanvasBuffer);
  FreeAndNil(FDisplayBuffer);
end;

Procedure TMainform.ImageViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  FViewMousePos.x := X;
  FViewMousePos.y := Y;
  smx := x;
  smy := y;
  If (ssCTRL In Shift) Then
  Begin
    If (ssLeft In Shift) Then
    Begin
      if TBZImageViewer(Sender).CanScroll then
      begin
        Screen.cursor := crSizeAll;
        FLastViewMousePos := FViewMousePos;
         //lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
      End;
    End;
  end
  else If (ssLeft In Shift) Then DoDraw := True;
end;

Procedure TMainform.ImageViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
var
  sx, sy : Integer;
begin

  If TBZImageViewer(Sender).CanScroll And ((ssleft In shift) And (ssCTRL In Shift)) Then
  Begin
    Screen.cursor := crSizeAll;
    FScrollViewOffset.x := FLastScrollViewOffset.x + X - FLastViewMousePos.x;
    FScrollViewOffset.y  := FLastScrollViewOffset.y + Y - FLastViewMousePos.y;
    imageView.OffsetLeft := FScrollViewOffset.x;
    imageView.OffsetTop := FScrollViewOffset.y;
    imageView.Invalidate;
    //lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
  End
  else if ssLeft in Shift then
  begin
    if DoDraw then
    begin
     emx := x;
     emy := y;
     FCanvasBuffer.Clear(clrTransparent);
     Case SelectedTool of
       stLine      : FCanvasBuffer.Canvas.Line(smx, smy,emx,emy);
       stRect      : FCanvasBuffer.Canvas.Rectangle(smx, smy,emx,emy);
       stRoundRect : FCanvasBuffer.Canvas.RoundedRect(smx, smy,emx,emy,15,15);
       stCircle    : FCanvasBuffer.Canvas.Circle(smx, smy,abs(emx-smx));
       stEllipse   : FCanvasBuffer.Canvas.Ellipse(smx, smy,abs(emx-smx),abs(emy-smy));
     End;
     //ShowMessage('UpdateDisplay');
     UpdateDisplay;
    End;
  end;
  sx := ((x div (imageView.ZoomFactor div 100)) - imageView.OffsetLeft);
  sy := ((y div (imageView.ZoomFactor div 100)) - imageView.OffsetTop);
  lblMousePos.Caption := sx.ToString + 'x' + sy.ToString;
end;

Procedure TMainform.ImageViewMouseUp(Sender : Tobject; Button : Tmousebutton; Shift : Tshiftstate; X, Y : Integer);
Begin
  emx := x;
  emy := y;
  Case SelectedTool of
    stLine      : FTempBuffer.Canvas.Line(smx, smy,emx,emy);
    stRect      : FTempBuffer.Canvas.Rectangle(smx, smy,emx,emy);
    stRoundRect : FTempBuffer.Canvas.RoundedRect(smx, smy,emx,emy,15,15);
    stCircle    : FTempBuffer.Canvas.Circle(smx, smy,abs(emx-smx));
    stEllipse   : FTempBuffer.Canvas.Ellipse(smx, smy,abs(emx-smx),abs(emy-smy));
  End;
  ImageView.Picture.Bitmap.Assign(FTempBuffer);
  ImageView.Invalidate;
  emx := 0;
  emy := 0;
  smx := 0;
  smy := 0;
  Screen.Cursor := crDefault;
  FViewMousePos.x := X;
  FViewMousePos.y := Y;
  FLastScrollViewOffset := FScrollViewOffset;
  DoDraw := False;
End;

procedure TMainform.SpeedButton1Click(Sender : TObject);
begin
  if TSpeedButton(Sender).Down then
  begin
    Case TSpeedButton(Sender).Tag of
      1 : SelectedTool := stPen;
      2 : SelectedTool := stLine;
      3 : SelectedTool := stRect;
      4 : SelectedTool := stRoundRect;
      5 : SelectedTool := stCircle;
      6 : SelectedTool := stEllipse;
    end;
  end;
end;

procedure TMainform.btnStrokeColorColorChanged(Sender : TObject);
Var
  C : TBZColor;
begin
  C.Create(btnStrokeColor.ButtonColor);
  FCanvasBuffer.Canvas.Pen.Color := C;
  FTempBuffer.Canvas.Pen.Color := C;
end;

procedure TMainform.btnFillColorColorChanged(Sender : TObject);
Var
  C : TBZColor;
begin
  C.Create(btnFillColor.ButtonColor);
  FCanvasBuffer.Canvas.Brush.Color := C;
  FTempBuffer.Canvas.Brush.Color := C;
end;

procedure TMainform.iseStrokeWidthChange(Sender : TObject);
var
  w : Byte;
begin
  w := TSpinEdit(Sender).Value;
  if w<=0 then w := 1;
  FCanvasBuffer.Canvas.Pen.Width := w;
  FTempBuffer.Canvas.Pen.Width := w;
end;

procedure TMainform.cbxZoomSelect(Sender : TObject);
begin
  ImageView.ZoomFactor := String(cbxZoom.Text).ToInteger;
  ImageView.Invalidate;
end;

procedure TMainform.UpdateDisplay;
Begin
  FDisplayBuffer.Assign(FTempBuffer);
  FDisplayBuffer.PutImage(FCanvasBuffer,0,0,FCanvasBuffer.Width, FCanvasBuffer.Height,0,0,dmSet, amAlpha);
  //FDisplayBuffer.Canvas.Pen.Color := clrRed;
  //FDisplayBuffer.Canvas.Line(5,5,FDisplayBuffer.MaxWidth - 5,FDisplayBuffer.MaxHeight - 5);
  ImageView.Picture.Bitmap.Assign(FDisplayBuffer);
  ImageView.Invalidate;

//  Application.ProcessMessages;
End;

End.

