unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ExtDlgs, ComCtrls, Spin, DBCtrls,
  BZClasses, BZColors, BZGraphic, BZBitmap, {%H-}BZBitmapIO, BZImageViewer;

type

  { TMainForm }

  TMainForm = class(TForm)
    Panel1 : TPanel;
    Panel2 : TPanel;
    Panel3 : TPanel;
    Panel4 : TPanel;
    GroupBox1 : TGroupBox;
    GroupBox2 : TGroupBox;
    ImgOriginal : TBZImageViewer;
    ImgResult : TBZImageViewer;
    OPD : TOpenPictureDialog;
    btnLoad : TButton;
    gbxOptions : TGroupBox;
    Label1 : TLabel;
    btnApply : TButton;
    pbImageProgress : TProgressBar;
    lblAction : TLabel;
    Panel7 : TPanel;
    Panel8 : TPanel;
    chkImgAdapt : TCheckBox;
    chkImgCenter : TCheckBox;
    sbHoriz : TScrollBar;
    sbVert : TScrollBar;
    Label5 : TLabel;
    cbxImageZoom : TComboBox;
    Panel5 : TPanel;
    Label2 : TLabel;
    cbxColorFilters : TComboBox;
    GroupBox3 : TGroupBox;
    pnlParamColorA : TPanel;
    Label3 : TLabel;
    pnlParamFactor : TPanel;
    lblFactorB : TLabel;
    pnlParamChannel : TPanel;
    Label6 : TLabel;
    pnlParamColorB : TPanel;
    Label7 : TLabel;
    btnColorA : TColorButton;
    btnColorB : TColorButton;
    fseFactor2 : TFloatSpinEdit;
    cbxChannels : TComboBox;
    pnlParamFactor1 : TPanel;
    lblFactorA : TLabel;
    fseFactor1 : TFloatSpinEdit;
    pnlParamFactor2 : TPanel;
    lblFactorC : TLabel;
    fseFactor3 : TFloatSpinEdit;
    btnApplyChange : TButton;
    procedure btnLoadClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnApplyClick(Sender : TObject);
    procedure chkImgCenterChange(Sender : TObject);
    procedure chkImgAdaptChange(Sender : TObject);
    procedure cbxImageZoomEditingDone(Sender : TObject);
    procedure cbxImageZoomSelect(Sender : TObject);
    procedure sbHorizChange(Sender : TObject);
    procedure sbVertChange(Sender : TObject);
    procedure cbxColorFiltersSelect(Sender : TObject);
    procedure btnApplyChangeClick(Sender : TObject);
  private
    FTempBmp : TBZBitmap;
    FApplyFilter : Boolean;
    FEditMatrix : Array[0..6,0..6] of TFloatSpinEdit;
  protected
    FTotalProgress : Byte;
    ZoomFactor : Integer;
    LastMousePoint, MousePoint : TPoint;

    procedure DoZoom(Const Updatecbx:Boolean =  True);
    Procedure DoFilterProgress(Sender: TObject; Stage: TBZProgressStage; PercentDone: Byte; RedrawNow: Boolean; Const R: TRect; Const Msg: String; Var aContinue: Boolean);
  public
    procedure ApplyFilter;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses BZBitmapColorFilters;

{ TMainForm }

procedure TMainForm.btnLoadClick(Sender : TObject);
begin
  if OPD.Execute then
  begin
    FApplyFilter := False;
    FTempBmp.LoadFromFile(OPD.FileName);
    ImgOriginal.Picture.Bitmap.Assign(FTempBmp);
    ImgOriginal.Invalidate;
    btnApply.Enabled := True;
    gbxOptions.Enabled := True;
  end;
end;

procedure TMainForm.FormCreate(Sender : TObject);
var
  i,j : Integer;
begin
  ZoomFactor := 100;
  FTempBmp := TBZBitmap.Create;
  FTempBmp.OnProgress := @DoFilterProgress;
  FTotalProgress := 0;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
var
  i,j : Integer;
begin
  For j := 0 to 6 do
  begin
    for i := 0 to 6 do
    begin
      FreeAndNil(FEditMatrix[j,i]);
    end;
  end;
  FreeAndNil(FTempBmp);
end;

procedure TMainForm.btnApplyClick(Sender : TObject);
begin
  ApplyFilter;
  btnApplyChange.Enabled := true;
end;

procedure TMainForm.chkImgCenterChange(Sender : TObject);
begin
  imgOriginal.Center := chkImgCenter.Checked;
  imgResult.Center := chkImgCenter.Checked;
  if imgOriginal.CanScroll then
  begin
    sbHoriz.Min := imgOriginal.ScrollBounds.Left;
    sbHoriz.Max := imgOriginal.ScrollBounds.Right;
    sbHoriz.Position := 0;
    sbVert.Min := imgOriginal.ScrollBounds.Top;
    sbVert.Max := imgOriginal.ScrollBounds.Bottom;
    sbVert.Position := 0;
  end;
  sbHoriz.Enabled := imgOriginal.CanScrollHorizontal;
  sbVert.Enabled  := imgOriginal.CanScrollVertical;
end;

procedure TMainForm.chkImgAdaptChange(Sender : TObject);
begin
  imgOriginal.Stretch := chkImgAdapt.Checked;
  imgResult.Stretch := chkImgAdapt.Checked;
  cbxImageZoom.Enabled := not(chkImgAdapt.Checked);
  if imgOriginal.CanScroll then
  begin
    sbHoriz.Min := imgOriginal.ScrollBounds.Left;
    sbHoriz.Max := imgOriginal.ScrollBounds.Right;
    sbHoriz.Position := 0;
    sbVert.Min := imgOriginal.ScrollBounds.Top;
    sbVert.Max := imgOriginal.ScrollBounds.Bottom;
    sbVert.Position := 0;
  end;
  sbHoriz.Enabled := imgOriginal.CanScrollHorizontal;
  sbVert.Enabled  := imgOriginal.CanScrollVertical;
end;

procedure TMainForm.cbxImageZoomEditingDone(Sender : TObject);
Var
  Zoom : String;
begin
  Zoom := cbxImageZoom.Text;
  ZoomFactor := Zoom.ToInteger;
  DoZoom(False);
end;

procedure TMainForm.cbxImageZoomSelect(Sender : TObject);
Var
  Zoom : String;
begin
  Zoom := cbxImageZoom.Text;
  ZoomFactor := Zoom.ToInteger;
  DoZoom(False);
end;

procedure TMainForm.sbHorizChange(Sender : TObject);
begin
  ImgOriginal.OffsetLeft := sbHoriz.Position;
  ImgResult.OffsetLeft := sbHoriz.Position;
end;

procedure TMainForm.sbVertChange(Sender : TObject);
begin
  ImgOriginal.OffsetTop := sbVert.Position;
  ImgResult.OffsetTop := sbVert.Position;
end;

procedure TMainForm.cbxColorFiltersSelect(Sender : TObject);
begin
  Case cbxColorFilters.ItemIndex of
    0 :
    begin
      fseFactor1.Enabled := False;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := False;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := True;
    end;
    3, 4 :
    begin
      fseFactor1.Enabled := True;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := True;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := False;
    end;
    5, 6, 7 :
    begin
      fseFactor1.Enabled := False;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := True;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := False;
    end;
    1,2,8,9,10,11,12,13,14,15,16,22,23,24,25,28,32 :
    begin
      fseFactor1.Enabled := True;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := False;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := False;
    end;
    17,18 :
    begin
      fseFactor1.Enabled := False;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := True;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := False;
    end;
    19,20 :
    begin
      fseFactor1.Enabled := False;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := True;
      btnColorB.Enabled := True;
      cbxChannels.Enabled := False;
    end;
    21 :
    begin
      fseFactor1.Enabled := True;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := False;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := False;
    end;
    26 :
    begin
      fseFactor1.Enabled := True;
      fseFactor2.Enabled := True;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := False;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := False;
    end;
    27,33 :
    begin
      fseFactor1.Enabled := True;
      fseFactor2.Enabled := True;
      fseFactor3.Enabled := True;
      btnColorA.Enabled := False;
      btnColorB.Enabled := False;
      cbxChannels.Enabled := False;
    end;
    29 :
    begin
      fseFactor1.Enabled := True;
      fseFactor2.Enabled := False;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := True;
      btnColorB.Enabled := True;
      cbxChannels.Enabled := False;
    end;
    30,31 :
    begin
      fseFactor1.Enabled := True;
      fseFactor2.Enabled := True;
      fseFactor3.Enabled := False;
      btnColorA.Enabled := True;
      btnColorB.Enabled := True;
      cbxChannels.Enabled := False;
    end;
  end;
end;

procedure TMainForm.btnApplyChangeClick(Sender : TObject);
begin
  FTempBmp.Assign(ImgResult.Picture.Bitmap);
  imgOriginal.Picture.Bitmap.Assign(FTempBmp);
  imgOriginal.Invalidate;
end;

procedure TMainForm.DoZoom(const Updatecbx : Boolean);
Begin
  If ZoomFactor < 5 Then ZoomFactor := 5;
  If ZoomFactor > 3200 Then ZoomFactor := 3200;
  if UpdateCbx then cbxImageZoom.Text := ZoomFactor.ToString();
  imgOriginal.ZoomFactor := ZoomFactor;
  imgResult.ZoomFactor := ZoomFactor;
  if imgOriginal.CanScroll then
  begin
    sbHoriz.Min := imgOriginal.ScrollBounds.Left;
    sbHoriz.Max := imgOriginal.ScrollBounds.Right;
    sbHoriz.Position := 0;
    sbVert.Min := imgOriginal.ScrollBounds.Top;
    sbVert.Max := imgOriginal.ScrollBounds.Bottom;
    sbVert.Position := 0;
  end;
  sbHoriz.Enabled := imgOriginal.CanScrollHorizontal;
  sbVert.Enabled  := imgOriginal.CanScrollVertical;
End;

Procedure TMainForm.DoFilterProgress(Sender : TObject; Stage : TBZProgressStage; PercentDone : Byte; RedrawNow : Boolean; Const R : TRect; Const Msg : String; Var aContinue : Boolean);
begin
  Case Stage Of
    opsStarting, opsRunning:
    Begin
      FTotalProgress := PercentDone;
      lblAction.Caption := Msg + ' - ' + IntToStr(FTotalProgress) + '%';
      pbImageProgress.Position := FTotalProgress;
      if FApplyFilter then
      begin
        if RedrawNow then Application.ProcessMessages;
      end else Application.ProcessMessages;
    End;
    opsEnding:
    Begin
      lblAction.Caption := '';
      pbImageProgress.Position := 0;
      FTotalProgress := 0;
    End;
  End;
end;

procedure TMainForm.ApplyFilter;
Var
  i, j, MatrixSize : Integer;
  ColorA, ColorB : TBZColor;
  FactorA, FactorB, FactorC : Single;
begin

  FApplyFilter := True;
  FTempBmp.ColorFilter.OnProgress := @DoFilterProgress;

  FactorA := fseFactor1.Value;
  FactorB := fseFactor2.Value;
  FactorC := fseFactor3.Value;
  ColorA.Create(btnColorA.ButtonColor);
  ColorB.Create(btnColorB.ButtonColor);
  Case cbxColorFilters.ItemIndex of
    0 : FTempBmp.ColorFilter.SwapChannel(TBZColorFilterSwapChannelMode(cbxChannels.ItemIndex));
    1 : FTempBmp.ColorFilter.Negate;
    2 : FTempBmp.ColorFilter.HyperSat;
    3 : FTempBmp.ColorFilter.Mix(ColorA, FactorA);
    4 : FTempBmp.ColorFilter.MixInv(ColorA, FactorA);
    5 : FTempBmp.ColorFilter.Average(ColorA);
    6 : FTempBmp.ColorFilter.Modulate(ColorA);
    7 : FTempBmp.ColorFilter.Colorize(ColorA);
    8 : FTempBmp.ColorFilter.AdjustBrightness(FactorA);
    9 : FTempBmp.ColorFilter.AdjustContrast(FactorA);
    10 : FTempBmp.ColorFilter.AdjustSaturation(FactorA);
    11 : FTempBmp.ColorFilter.GammaCorrection(FactorA);
    12 : FTempBmp.ColorFilter.Posterize(FactorA);
    13 : FTempBmp.ColorFilter.Solarize(FactorA);
    14 : FTempBmp.ColorFilter.KeepRed(FactorA);
    15 : FTempBmp.ColorFilter.KeepGreen(FactorA);
    16 : FTempBmp.ColorFilter.KeepBlue(FactorA);
    17 : FTempBmp.ColorFilter.ExcludeColor(ColorA);
    18 : FTempBmp.ColorFilter.ExtractColor(ColorA);
    19 : FTempBmp.ColorFilter.ExcludeColorInRange(ColorA, ColorB);
    20 : FTempBmp.ColorFilter.ExtractColorInRange(ColorA, ColorB);
    21 : FTempBmp.ColorFilter.SplitLight(Round(FactorA));
    22 : FTempBmp.ColorFilter.Minimum;
    23 : FTempBmp.ColorFilter.Maximum;
    24 : FTempBmp.ColorFilter.GrayOut;
    25 : FTempBmp.ColorFilter.AdjustExposure(FactorA);
    26 : FTempBmp.ColorFilter.AdjustGain(FactorA, FactorB);
    27 : FTempBmp.ColorFilter.AdjustRGB(FactorA, FactorB, FactorC);
    28 : FTempBmp.ColorFilter.RemoveRedEye;
    29 : FTempBmp.ThresholdFilter.ThresholdSImple(Round(FactorA),clrBlack,clrWhite,True);
    30 : FTempBmp.ThresholdFilter.ThresholdDual(Round(FactorA), Round(FactorB),clrBlack,clrWhite, False);
    31 : FTempBmp.ThresholdFilter.ThresholdDual(Round(FactorA), Round(FactorB),clrBlack,clrWhite, True,True);
    32 : FTempBmp.ThresholdFilter.Otsu(clrBlack,clrWhite,False, True);
    33 : FTempBmp.ThresholdFilter.ThresholdSimple(Round(FactorA), Round(FactorB),Round(FactorC),clrBlack,clrWhite);
    34 : FTempBmp.MorphologicalFilter.Erode(3);
    35 : FTempBmp.MorphologicalFilter.Dilate(3);
  end;

  ImgResult.Picture.Bitmap.Assign(FTempBmp);
  ImgResult.Invalidate;
  FTempBmp.Assign(ImgOriginal.Picture.Bitmap);

end;

end.
