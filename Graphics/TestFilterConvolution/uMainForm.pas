unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ExtDlgs, ComCtrls, Spin,
  BZClasses, BZUtils, BZGraphic, BZBitmap, {%H-}BZBitmapIO, BZImageViewer;

type

  { TMainForm }

  TMainForm = class(TForm)
    chkApplyRed : TCheckBox;
    chkApplyGreen : TCheckBox;
    chkApplyBlue : TCheckBox;
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
    GroupBox3 : TGroupBox;
    Panel5 : TPanel;
    Label2 : TLabel;
    Panel6 : TPanel;
    Label3 : TLabel;
    pnlMatRow1 : TPanel;
    pnlMatRow2 : TPanel;
    pnlMatRow7 : TPanel;
    pnlMatRow6 : TPanel;
    pnlMatRow5 : TPanel;
    pnlMatRow4 : TPanel;
    pnlMatRow3 : TPanel;
    GroupBox4 : TGroupBox;
    lbxConvolutionFilters : TListBox;
    Panel7 : TPanel;
    Label4 : TLabel;
    cbxMatrixSize : TComboBox;
    speDivisor : TSpinEdit;
    speBias : TSpinEdit;
    Panel8 : TPanel;
    chkImgAdapt : TCheckBox;
    chkImgCenter : TCheckBox;
    sbHoriz : TScrollBar;
    sbVert : TScrollBar;
    Label5 : TLabel;
    cbxImageZoom : TComboBox;
    SpinEdit1 : TSpinEdit;
    Panel9 : TPanel;
    Label6 : TLabel;
    cbxMode : TComboBox;
    procedure btnLoadClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnApplyClick(Sender : TObject);
    procedure lbxConvolutionFiltersSelectionChange(Sender : TObject; User : boolean);
    procedure chkImgCenterChange(Sender : TObject);
    procedure chkImgAdaptChange(Sender : TObject);
    procedure cbxImageZoomEditingDone(Sender : TObject);
    procedure cbxImageZoomSelect(Sender : TObject);
    procedure sbHorizChange(Sender : TObject);
    procedure sbVertChange(Sender : TObject);
    procedure cbxMatrixSizeChange(Sender : TObject);
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
  For j := 0 to 6 do
  begin
    for i := 0 to 6 do
    begin
      FEditMatrix[j,i] := TFloatSpinEdit.Create(Self);
      With FEditMatrix[j,i] do
      begin
        Case j of
          0 : Parent := pnlMatRow1;
          1 : Parent := pnlMatRow2;
          2 : Parent := pnlMatRow3;
          3 : Parent := pnlMatRow4;
          4 : Parent := pnlMatRow5;
          5 : Parent := pnlMatRow6;
          6 : Parent := pnlMatRow7;
        end;
        Width := 48;
        Name := 'speMatrix'+J.ToString+'_'+I.ToString;
        MinValue := -500;
        MaxValue := 500;
        Value := 0;
        Enabled := False;
        ReadOnly := True;
        DecimalPlaces := 1;
        TabOrder := i;
        Align := alRight;
      end;
    end;
  end;

  For j:= 0 to high(BZConvolutionFilterPresets) do
  begin
    lbxConvolutionFilters.Items.Add(BZConvolutionFilterPresets[j].Name);
  end;
  lbxConvolutionFilters.Items.Add('Personnalisé');
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
end;

procedure TMainForm.lbxConvolutionFiltersSelectionChange(Sender : TObject; User : boolean);
Var
  i,j,k, start : Integer;
begin
  k := lbxConvolutionFilters.ItemIndex;
  for j := 0 to 6 do
  begin
    for i := 0 to 6 do
    begin
      if k > high(BZConvolutionFilterPresets) then
      begin
        FEditMatrix[j,i].ReadOnly := False;
        FEditMatrix[j,i].Enabled := False;
        FEditMatrix[j,i].Value := 0;
        cbxMatrixSize.Enabled := True;
        cbxMatrixSize.ItemIndex := 0;
        cbxMatrixSizeChange(Self);
      end
      else
      begin
        FEditMatrix[j,i].ReadOnly := True;
        FEditMatrix[j,i].Enabled := False;
        cbxMatrixSize.Enabled := False;
      end;
    end;
  end;

  if k <= high(BZConvolutionFilterPresets) then
  begin
    Case BZConvolutionFilterPresets[k].MatrixType of
      mct3x3 :
      begin
        cbxMatrixSize.ItemIndex := 0;
        start := 2;
        for j := Start to 6-Start do
        begin
          for i := Start to 6-Start do
          begin
            FEditMatrix[j,i].Value := BZConvolutionFilterPresets[k].Matrix._3[ (j-Start) + (i-Start) * 3 ];
            FEditMatrix[j,i].Enabled := True;
          end;
        end;
      end;
      mct5x5 :
      begin
        cbxMatrixSize.ItemIndex := 1;
        start := 1;
        for j := Start to 6-Start do
        begin
          for i := Start to 6-Start do
          begin
            FEditMatrix[j,i].Value := BZConvolutionFilterPresets[k].Matrix._5[ (j-Start) + (i-Start) * 3 ];
            FEditMatrix[j,i].Enabled := True;
          end;
        end;
      end;
      mct7x7 :
      begin
        cbxMatrixSize.ItemIndex := 2;
        start := 0;
        for j := Start to 6-Start do
        begin
          for i := Start to 6-Start do
          begin
            FEditMatrix[j,i].Value := BZConvolutionFilterPresets[k].Matrix._7[ (j-Start) + (i-Start) * 3 ];
            FEditMatrix[j,i].Enabled := True;
          end;
        end;
      end;
    end;
    speDivisor.Value := BZConvolutionFilterPresets[k].Divisor;
    speBias.Value := BZConvolutionFilterPresets[k].Bias;
  end;

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

procedure TMainForm.cbxMatrixSizeChange(Sender : TObject);
var
  i,j : Integer;
  Start : Integer;
begin
  if cbxMatrixSize.Enabled then
  begin
    if cbxMatrixSize.ItemIndex = 2 then
    begin
      for j := 0 to 6 do
      begin
        for i := 0 to 6 do
        begin
          FEditMatrix[j,i].ReadOnly := False;
          FEditMatrix[j,i].Enabled := True;
        end;
      end;
    end
    else
    begin
      if cbxMatrixSize.ItemIndex = 1 then start := 1 else Start := 2;
      for j := 0 to 6 do
      begin
        for i := 0 to 6 do
        begin
          FEditMatrix[j,i].ReadOnly := False;
          FEditMatrix[j,i].Enabled := (((j>=Start) and (j<=6-start)) and ((i>=Start) and (i<=6-start)));
        end;
      end;
    end;
  end;
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
  CustomMatrix : Array Of Single;
  i, j, MatrixSize : Integer;
begin

  FApplyFilter := True;
  FTempBmp.ConvolutionFilter.OnProgress := @DoFilterProgress;

  i := lbxConvolutionFilters.ItemIndex;

  if (i <= high(BZConvolutionFilterPresets)) then
  begin
    if spinEdit1.Value <>0 then
    begin
      MatrixSize := BZConvolutionFilterPresets[i].MatrixSize;
      SetLength(CustomMatrix, MatrixSize * MatrixSize);
      Case MatrixSize of
        3: CustomMatrix := BZConvolutionFilterPresets[i].Matrix._3;
        5: CustomMatrix := BZConvolutionFilterPresets[i].Matrix._5;
        7: CustomMatrix := BZConvolutionFilterPresets[i].Matrix._7;
      end;
      if spinEdit1.Value < 0 then CircularShiftLeftArray(CustomMatrix,MatrixSize,abs(spinEdit1.Value))
      else CircularShiftRightArray(CustomMatrix,MatrixSize,spinEdit1.Value);

      FTempBmp.ConvolutionFilter.Convolve(CustomMatrix,MatrixSize,speDivisor.Value, speBias.Value, TBZConvolutionFilterMode(cbxMode.ItemIndex),chkApplyRed.Checked, chkApplyGreen.Checked, chkApplyBlue.Checked);

    end
    else
      FTempBmp.ConvolutionFilter.Convolve(BZConvolutionFilterPresets[i],speDivisor.Value, speBias.Value, TBZConvolutionFilterMode(cbxMode.ItemIndex),chkApplyRed.Checked, chkApplyGreen.Checked, chkApplyBlue.Checked);
  end
  else
  begin
    MatrixSize := 3;
    Case cbxMatrixSize.ItemIndex of
      0 :
      begin
        SetLength(CustomMatrix,9);
        MatrixSize := 3;
        for j := 2 to 4 do
        begin
          for i := 2 to 4 do
          begin
            CustomMatrix[(j-2) + (i-2) * 3] := FEditMatrix[j,i].Value;
          end;
        end;
      end;
      1 :
      begin
        SetLength(CustomMatrix,25);
        MatrixSize := 5;
        for j := 1 to 5 do
        begin
          for i := 1 to 5 do
          begin
            CustomMatrix[(j-1) + (i-1) * 5] := FEditMatrix[j,i].Value;
          end;
        end;
      end;
      2 :
      begin
        SetLength(CustomMatrix,49);
        MatrixSize := 7;
        for j := 0 to 6 do
        begin
          for i := 0 to 6 do
          begin
            CustomMatrix[j + (i * 7)] := FEditMatrix[j,i].Value;
          end;
        end;
      end;
    end;
    FTempBmp.ConvolutionFilter.Convolve(CustomMatrix,MatrixSize,speDivisor.Value, speBias.Value, TBZConvolutionFilterMode(cbxMode.ItemIndex));
  end;

  ImgResult.Picture.Bitmap.Assign(FTempBmp);
  ImgResult.Invalidate;
  FTempBmp.Assign(ImgOriginal.Picture.Bitmap);
  SetLength(CustomMatrix,0);
end;

end.
