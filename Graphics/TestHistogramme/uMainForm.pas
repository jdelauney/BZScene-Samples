unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs,
  BZGraphic, BZBitmap, BZBitmapIO, BZImageViewer;

type

  { TMainForm }

  TMainForm = class(TForm)
    GroupBox2 : TGroupBox;
    pnlHistogram : TPanel;
    GroupBox3 : TGroupBox;
    Label1 : TLabel;
    cbxChannel : TComboBox;
    GroupBox4 : TGroupBox;
    Panel2 : TPanel;
    btnLoad : TButton;
    pbImageProgress : TProgressBar;
    lblAction : TLabel;
    Panel8 : TPanel;
    chkImgAdapt : TCheckBox;
    chkImgCenter : TCheckBox;
    Label5 : TLabel;
    cbxImageZoom : TComboBox;
    OPD : TOpenPictureDialog;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label6 : TLabel;
    Label7 : TLabel;
    Label8 : TLabel;
    Label9 : TLabel;
    lblStatPixels : TLabel;
    lblStatMinimum : TLabel;
    lblStatMaximum : TLabel;
    lblStatMean : TLabel;
    lblStatMedian : TLabel;
    lblStatDevStd : TLabel;
    lblStatExcess : TLabel;
    Label10 : TLabel;
    lblStatSkewness : TLabel;
    Label11 : TLabel;
    lblStatMaxFrequency : TLabel;
    GroupBox5 : TGroupBox;
    Panel4 : TPanel;
    GroupBox1 : TGroupBox;
    ImgOriginal : TBZImageViewer;
    GroupBox6 : TGroupBox;
    ImgResult : TBZImageViewer;
    sbHoriz : TScrollBar;
    sbVert : TScrollBar;
    btnHistogramEqualize : TButton;
    Button1 : TButton;
    GroupBox7 : TGroupBox;
    Label12 : TLabel;
    Label13 : TLabel;
    Label14 : TLabel;
    Label15 : TLabel;
    sbLevelInMin : TScrollBar;
    sbLevelInMax : TScrollBar;
    sbLevelOutMin : TScrollBar;
    sbLevelOutMax : TScrollBar;
    procedure btnLoadClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure sbVertChange(Sender : TObject);
    procedure sbHorizChange(Sender : TObject);
    procedure cbxImageZoomSelect(Sender : TObject);
    procedure cbxImageZoomEditingDone(Sender : TObject);
    procedure chkImgAdaptChange(Sender : TObject);
    procedure chkImgCenterChange(Sender : TObject);
    procedure cbxChannelSelect(Sender : TObject);
    procedure btnHistogramEqualizeClick(Sender : TObject);
    procedure sbLevelInOutChange(Sender : TObject);
    procedure Button1Click(Sender : TObject);
  private
    FTempBmp, FHistogramBmp : TBZBitmap;
  protected
    procedure DoZoom(Const Updatecbx:Boolean =  True);
    procedure UpdateHistogram(bmp : TBZBitmap);
  public
    ZoomFactor : Integer;
    LastMousePoint, MousePoint : TPoint;

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses
  BZTypesHelpers;

{ TMainForm }

procedure TMainForm.btnLoadClick(Sender : TObject);
begin
  if OPD.Execute then
  begin
    FTempBmp.LoadFromFile(OPD.FileName);
    ImgOriginal.Picture.Bitmap.Assign(FTempBmp);
    ImgOriginal.Invalidate;
    UpdateHistogram(FTempBmp);
  end;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  ZoomFactor := 100;
  FTempBmp := TBZBitmap.Create;
  FHistogramBmp := TBZBitmap.Create(256,180);
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FTempBmp);
end;

procedure TMainForm.sbVertChange(Sender : TObject);
begin
  ImgOriginal.OffsetTop := sbVert.Position;
  ImgResult.OffsetTop := sbVert.Position;
end;

procedure TMainForm.sbHorizChange(Sender : TObject);
begin
  ImgOriginal.OffsetLeft := sbHoriz.Position;
  ImgResult.OffsetLeft := sbHoriz.Position;
end;

procedure TMainForm.cbxImageZoomSelect(Sender : TObject);
Var
  Zoom : String;
begin
  Zoom := cbxImageZoom.Text;
  ZoomFactor := Zoom.ToInteger;
  DoZoom(False);
end;

procedure TMainForm.cbxImageZoomEditingDone(Sender : TObject);
Var
  Zoom : String;
begin
  Zoom := cbxImageZoom.Text;
  ZoomFactor := Zoom.ToInteger;
  DoZoom(False);
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

procedure TMainForm.cbxChannelSelect(Sender : TObject);
begin
  //FTempBmp.Histogram.DrawTo(FHistogramBmp,TBZHistorgramDrawMode(cbxChannel.ItemIndex),True, True, True);
  //FHistogramBmp.DrawToCanvas(pnlHistogram.Canvas, pnlHistogram.ClientRect);
  UpdateHistogram(FTempBmp);
end;

procedure TMainForm.btnHistogramEqualizeClick(Sender : TObject);
Var
  TmpBmp : TBZBitmap;
begin
  TmpBmp := FTempBmp.CreateClone;
  TmpBmp.Histogram.Equalize;
  imgResult.Picture.Bitmap.Assign(TmpBmp);
  UpdateHistogram(TmpBmp);
  imgResult.Invalidate;
  FreeAndNil(TmpBmp);
end;

procedure TMainForm.sbLevelInOutChange(Sender : TObject);
Var
  TmpBmp : TBZBitmap;
begin
  TmpBmp := FTempBmp.CreateClone;
  TmpBmp.Histogram.AdjustLevels(sbLevelInMin.Position / 100,sbLevelInMax.Position / 100,sbLevelOutMin.Position / 100,sbLevelOutMax.Position / 100);
  imgResult.Picture.Bitmap.Assign(TmpBmp);
  imgResult.Invalidate;
  UpdateHistogram(TmpBmp);
  FreeAndNil(TmpBmp);
end;

procedure TMainForm.Button1Click(Sender : TObject);
Var
  TmpBmp : TBZBitmap;
begin
  TmpBmp := FTempBmp.CreateClone;
  TmpBmp.Histogram.AutoAdjustLevels;
  imgResult.Picture.Bitmap.Assign(TmpBmp);
  imgResult.Invalidate;
  UpdateHistogram(TmpBmp);
  FreeAndNil(TmpBmp);
end;

procedure TMainForm.DoZoom(Const Updatecbx : Boolean);
begin
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
end;

procedure TMainForm.UpdateHistogram(bmp : TBZBitmap);
begin
  Bmp.Histogram.ComputeHistogram;
  lblStatPixels.Caption := Bmp.Histogram.Statistics.Pixels.ToString;
  lblStatMinimum.Caption := Bmp.Histogram.Statistics.Minimum.ToString;
  lblStatMaximum.Caption := Bmp.Histogram.Statistics.Maximum.ToString;
  lblStatMaxFrequency.Caption := Bmp.Histogram.Statistics.MaxFrequency.ToString;
  lblStatMean.Caption := Bmp.Histogram.Statistics.Mean.ToString;
  lblStatMedian.Caption := Bmp.Histogram.Statistics.Median.ToString;
  lblStatSkewness.Caption := Bmp.Histogram.Statistics.Skewness.ToString;
  lblStatDevStd.Caption := Bmp.Histogram.Statistics.StandardDeviation.ToString;
  lblStatExcess.Caption := Bmp.Histogram.Statistics.ExcessKurtosis.ToString;
  Bmp.Histogram.DrawTo(FHistogramBmp,TBZHistorgramDrawMode(cbxChannel.ItemIndex),True, True, True, True);
  FHistogramBmp.DrawToCanvas(pnlHistogram.Canvas, pnlHistogram.ClientRect);
end;

end.

