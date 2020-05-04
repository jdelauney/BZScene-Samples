unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ExtDlgs, ComCtrls, Spin, BZImageViewer,
  BZClasses, BZColors, BZGraphic, BZBitmap, {%H-}BZBitmapIO;

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
    rgGrayScaleMethod : TRadioGroup;
    rgConversionMatrix : TRadioGroup;
    pbImageProgress : TProgressBar;
    lblAction : TLabel;
    Panel5 : TPanel;
    speNumOfShade : TSpinEdit;
    cbxColorMask : TComboBox;
    procedure btnLoadClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnApplyClick(Sender : TObject);
    procedure rgGrayScaleMethodSelectionChanged(Sender : TObject);
  private
    FTempBmp : TBZBitmap;
    FApplyFilter : Boolean;
  protected
    FTotalProgress : Byte;
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
    rgGrayScaleMethod.Enabled := true;
    btnApply.Enabled := True;
    gbxOptions.Enabled := True;
  end;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FTempBmp := TBZBitmap.Create;
  FTempBmp.OnProgress := @DoFilterProgress;
  FTotalProgress := 0;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FTempBmp);
end;

procedure TMainForm.btnApplyClick(Sender : TObject);
begin
  ApplyFilter;
end;

procedure TMainForm.rgGrayScaleMethodSelectionChanged(Sender : TObject);
begin
  rgConversionMatrix.Enabled := (rgGrayScaleMethod.ItemIndex = 1);
  cbxColorMask.Enabled := (rgGrayScaleMethod.ItemIndex = 5);
  speNumOfShade.Enabled := (rgGrayScaleMethod.ItemIndex = 6);
end;

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
  OptVal : Integer;
begin

  FApplyFilter := True;
  OptVal := 0;
  if (rgGrayScaleMethod.ItemIndex = 5) then OptVal := cbxColorMask.ItemIndex;
  if (rgGrayScaleMethod.ItemIndex = 6) then OptVal := speNumOfShade.Value;

  FTempBmp.ColorFilter.OnProgress := @DoFilterProgress;
  FTempBmp.ColorFilter.GrayScale(TBZGrayConvertMode(rgGrayScaleMethod.ItemIndex),
                                 TBZGrayMatrixType(rgConversionMatrix.ItemIndex),
                                 OptVal);

  ImgResult.Picture.Bitmap.Assign(FTempBmp);
  ImgResult.Invalidate;
  FTempBmp.Assign(ImgOriginal.Picture.Bitmap);
end;

end.
