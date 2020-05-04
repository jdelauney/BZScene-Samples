unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Spin, Buttons, ExtDlgs,
  BZColors, BZGraphic, BZVectorMath, BZBitmap, BZImageViewer, BZBitmapIO; //BZGeoTools;

type

  { TMainForm }
  TBZPaintTool = (ptNone, ptPen, ptLine, ptRect, ptEllipse);
  TMainForm = class(TForm)
    btnBrushColor : TColorButton;
    btnGradientColorStart : TColorButton;
    btnGradientColorStop : TColorButton;
    btnPenColor : TColorButton;
    cbxFillStyle : TComboBox;
    cbxStrokeStyle : TComboBox;
    cbxGradientKind : TComboBox;
    cbxTextureMapKind : TComboBox;
    GroupBox1 : TGroupBox;
    GroupBox2 : TGroupBox;
    Label1 : TLabel;
    OPD : TOpenPictureDialog;
    pnlGradient : TPanel;
    pnlThumbTexture : TPanel;
    pnlPaintOptions : TPanel;
    Panel1 : TPanel;
    pnlPaintTools : TPanel;
    ScrollBox1 : TScrollBox;
    btnPaintToolNone : TSpeedButton;
    btnPaintToolPen : TSpeedButton;
    ImageView : TBZImageViewer;
    btnPaintToolLine : TSpeedButton;
    btnPaintToolRect : TSpeedButton;
    btnPaintToolEllipse : TSpeedButton;
    btnOpenTexture : TSpeedButton;
    spePenWidth : TSpinEdit;
    procedure btnGradientColorStartColorChanged(Sender : TObject);
    procedure btnGradientColorStopColorChanged(Sender : TObject);
    procedure btnOpenTextureClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormShow(Sender : TObject);

    procedure BtnChoosePaintToolClick(Sender : TObject);
    procedure pnlGradientPaint(Sender : TObject);
    procedure pnlThumbTexturePaint(Sender : TObject);
    procedure spePenWidthChange(Sender : TObject);
    procedure btnPenColorColorChanged(Sender : TObject);
    procedure ImageViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure ImageViewMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure ImageViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure ImageViewAfterPaint(VirtualCanvas : TBZBitmapCanvas);
    procedure btnBrushColorColorChanged(Sender : TObject);
  private
    FPaintBmp, FGradientBuffer, FBrushTexture, FBrushTextureThumb : TBZBitmap;
    FPenWidth : Integer;
    FPenColor, FBrushColor,
    FGradientColorStart, FGradientColorStop : TBZColor;
    FSelectedPaintTool : TBZPaintTool;

    FMouseIsDown, FDrawing : Boolean;
    FLastMousePos : TBZFloatPoint;
    FCurrentMousePos : TBZFloatPoint;
  protected
    procedure RenderGradientBuffer;
  public
    procedure UpdateBitmap;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FPaintBmp := TBZBitmap.Create(1024,768);
  FGradientBuffer := TBZBitmap.Create(pnlGradient.ClientWidth, pnlGradient.ClientHeight);
  FPaintBmp.Clear(clrWhite);
  FPenColor := clrBlack;
  FBrushColor := clrBlack;
  FGradientColorStart := clrBlack;
  FGradientColorStop := clrWhite;
  RenderGradientBuffer;
  FDrawing := False;
  FMouseIsDown := False;
  FSelectedPaintTool := ptNone;
end;

procedure TMainForm.btnGradientColorStartColorChanged(Sender : TObject);
begin
  FGradientColorStart.Create(btnGradientColorStart.ButtonColor);
  pnlGradient.Invalidate;
end;

procedure TMainForm.btnGradientColorStopColorChanged(Sender : TObject);
begin
  FGradientColorStop.Create(btnGradientColorStop.ButtonColor);
  pnlGradient.Invalidate;
end;

procedure TMainForm.btnOpenTextureClick(Sender : TObject);
begin
  if Not(Assigned(FBrushTexture)) then
  begin
    FBrushTexture := TBZBitmap.Create;
    FBrushTextureThumb := TBZBitmap.Create(32,32);
  end;
  if OPD.Execute then
  begin
    FBrushTexture.LoadFromFile(OPD.FileName);
    FBrushTexture.Transformation.StretchTo(FBrushTextureThumb, True);
    pnlThumbTexture.Invalidate;
  end;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  if Assigned(FBrushTexture) then FreeAndNil(FBrushTexture);
  if Assigned(FBrushTextureThumb) then FreeAndNil(FBrushTextureThumb);
  FreeAndNil(FPaintBmp);
  FreeAndNil(FGradientBuffer);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  UpdateBitmap;
end;

procedure TMainForm.BtnChoosePaintToolClick(Sender : TObject);
begin
  Case TSpeedButton(Sender).Tag of
    0 : FSelectedPaintTool := ptNone;
    1 : FSelectedPaintTool := ptPen;
    2 : FSelectedPaintTool := ptLine;
    3 : FSelectedPaintTool := ptRect;
    4 : FSelectedPaintTool := ptEllipse;
  end;
end;

procedure TMainForm.pnlGradientPaint(Sender : TObject);
begin
  RenderGradientBuffer;
  FGradientBuffer.DrawToCanvas(pnlGradient.Canvas, pnlGradient.ClientRect);
end;

procedure TMainForm.pnlThumbTexturePaint(Sender : TObject);
begin
  if Assigned(FBrushTextureThumb) then
    FBrushTextureThumb.DrawToCanvas(pnlThumbTexture.Canvas, pnlThumbTexture.ClientRect);
end;

procedure TMainForm.spePenWidthChange(Sender : TObject);
begin
  FPenWidth := spePenWidth.Value;
end;

procedure TMainForm.btnPenColorColorChanged(Sender : TObject);
begin
  FPenColor.Create(btnPenColor.ButtonColor);
end;

procedure TMainForm.ImageViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button = mbLeft then
  begin
    FMouseIsDown := True;
    FLastMousePos.Create(X, Y);
  end;
end;

procedure TMainForm.ImageViewMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
Var
  Dist : Single;
  FillStyle : TBZBrushStyle;
  StrokeStyle : TBZStrokeStyle;
begin
  FillStyle := TBZBrushStyle(cbxFillStyle.itemIndex);
  StrokeStyle := TBZStrokeStyle(cbxStrokeStyle.ItemIndex);
  With FPaintBmp.Canvas do
  begin
    Antialias := True;
    Pen.Style := StrokeStyle;
    Pen.Width := FPenWidth;
    Pen.Color := FPenColor;
    Brush.Style := FillStyle;
    Case FillStyle of
      //bsClear: ;
      bsSolid: Brush.Color := FBrushColor;
      bsGradient:
      begin
        Brush.Gradient.Kind := TBZGradientKind(cbxGradientKind.ItemIndex);
        Brush.Gradient.Angle := 35;
        Brush.Gradient.ColorSteps.Clear;
        Brush.Gradient.ColorSteps.AddColorStop(FGradientColorStart,0.0);
        Brush.Gradient.ColorSteps.AddColorStop(FGradientColorStop,1.0);
      end;
      bsTexture:
      begin
        Brush.Texture.Bitmap.Assign(FBrushTexture);
        Brush.Texture.MappingKind := TBZTextureMappingKind(cbxTextureMapKind.ItemIndex);
        Brush.Texture.TileX := 16;
        Brush.Texture.TileY := 16;
      end;
      //bsPattern: ;
      //bsCustom: ;
    end;
  end;
  Case FSelectedPaintTool of
    ptLine :
    begin
      With FPaintBmp.Canvas do
      begin
        Brush.Style := bsClear;
        MoveTo(FLastMousePos);
        LineTo(FCurrentMousePos);
      end;
      UpdateBitmap;
    end;
    ptRect :
    begin
      With FPaintBmp.Canvas do
      begin
        Rectangle(FLastMousePos, FCurrentMousePos);
      end;
      UpdateBitmap;
    end;
    ptEllipse :
    begin
      With FPaintBmp.Canvas do
      begin
        Ellipse(FLastMousePos, FCurrentMousePos);
        //Dist := FLastMousePos.Distance(FCurrentMousePos);
        //Circle(FLastMousePos, Dist);
      end;
      UpdateBitmap;
    end;
  end;

  FMouseIsDown := False;
  FDrawing := False;

end;

procedure TMainForm.ImageViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
Var
  N, TN : Single;
  t, k : Integer;
  nX, nY : Integer;
begin
  if FMouseIsDown then
  begin
    FCurrentMousePos.Create(X, Y);
    if ssLeft in Shift then
    begin
      FDrawing := True;
      Case FSelectedPaintTool of
        ptPen:
        begin
          N := FCurrentMousePos.Distance(FLastMousePos);
          if Abs(N) > 1.0 then
          begin
            N := 1 + ( N * 100 ) / 100;
            K := Round(N) - 1;
            For t := 0 to K do
            begin
              TN := t/N;
              nX := Trunc((1.0 - TN) * FLastMousePos.X + (TN * X));
              nY := Trunc((1.0 - TN) * FLastMousePos.Y + (TN * Y));
              if FPenWidth > 1 then
              begin
                With FPaintBmp.Canvas do
                begin
                  Antialias := True;
                  Pen.Style := ssSolid;
                  Pen.Color := FPenColor;
                  Brush.Style := bsSolid;
                  Brush.Color := FPenColor;
                  Circle(nX, nY, FPenWidth div 2);
                end;
              end
              else
              begin
                FPaintBmp.setPixel(nX,nY, FPenColor);
              end;
            end;
          end;
          UpdateBitmap;
          FLastMousePos := FCurrentMousePos;
        end;
        ptLine, ptRect, ptEllipse :
        begin
          ImageView.Repaint;
        end;
      end;
    end;
  end;
end;

procedure TMainForm.ImageViewAfterPaint(VirtualCanvas : TBZBitmapCanvas);
Var
  Dist : Single;
  FillStyle : TBZBrushStyle;
  StrokeStyle : TBZStrokeStyle;
begin

  if FMouseIsDown and FDrawing then
  begin
    FillStyle := TBZBrushStyle(cbxFillStyle.itemIndex);
    StrokeStyle := TBZStrokeStyle(cbxStrokeStyle.ItemIndex);
    With ImageView.VirtualCanvas do
    begin
      Antialias := False;
      Pen.Style := StrokeStyle;
      Pen.Width := FPenWidth;
      Pen.Color := FPenColor;
      Brush.Style := FillStyle;
      Case FillStyle of
        //bsClear: ;
        bsSolid: Brush.Color := FBrushColor;
        bsGradient:
        begin
          Brush.Gradient.Kind := TBZGradientKind(cbxGradientKind.ItemIndex);
          Brush.Gradient.Angle := 35;
          Brush.Gradient.ColorSteps.Clear;
          Brush.Gradient.ColorSteps.AddColorStop(FGradientColorStart,0.0);
          Brush.Gradient.ColorSteps.AddColorStop(FGradientColorStop,1.0);
        end;
        bsTexture:
        begin
          if not(Assigned(FBrushTexture)) then btnOpenTextureClick(nil);
          Brush.Texture.Bitmap.Assign(FBrushTexture);
          //TBZTextureMappingKind = (tmkDefault, tmkTiled);
          Brush.Texture.MappingKind := TBZTextureMappingKind(cbxTextureMapKind.ItemIndex);
          Brush.Texture.TileX := 16;
          Brush.Texture.TileY := 16;
        end;
        //bsPattern: ;
        //bsCustom: ;
      end;
    end;
    Case FSelectedPaintTool of
      ptLine :
      begin
        With ImageView.VirtualCanvas do
        begin
          Brush.Style := bsClear;
          MoveTo(FLastMousePos);
          LineTo(FCurrentMousePos);
        end;
      end;
      ptRect :
      begin
        With ImageView.VirtualCanvas do
        begin
          Antialias := False;
          Rectangle(FLastMousePos, FCurrentMousePos);
        end;
        UpdateBitmap;
      end;
      ptEllipse :
      begin
        With ImageView.VirtualCanvas do
        begin
          Ellipse(FLastMousePos, FCurrentMousePos);
          //Dist := FLastMousePos.Distance(FCurrentMousePos);
          //Circle(FLastMousePos, Dist);
        end;
        UpdateBitmap;
      end;
    end;
  end;
end;

procedure TMainForm.btnBrushColorColorChanged(Sender : TObject);
begin
  FBrushColor.Create(btnBrushColor.ButtonColor);
end;

procedure TMainForm.RenderGradientBuffer;
begin
  FGradientBuffer.Clear(clrBlack);
  With FGradientBuffer.Canvas do
  begin
    Pen.Style := ssClear;
    Brush.Style := bsGradient;

    Brush.Gradient.Kind := gkHorizontal;
    Brush.Gradient.ColorSteps.Clear;
    Brush.Gradient.ColorSteps.AddColorStop(FGradientColorStart,0.0);
    Brush.Gradient.ColorSteps.AddColorStop(FGradientColorStop,1.0);
    Rectangle(0,0,FGradientBuffer.MaxWidth, FGradientBuffer.MaxHeight);
  end;
end;

procedure TMainForm.UpdateBitmap;
begin
  ImageView.Picture.Bitmap.Assign(FPaintBmp);
  ImageView.Repaint;
end;

end.

