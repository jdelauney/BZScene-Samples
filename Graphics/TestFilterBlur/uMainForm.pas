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
    rgBlurMethod : TRadioGroup;
    pbImageProgress : TProgressBar;
    lblAction : TLabel;
    Panel5 : TPanel;
    pnlMotionDirEdit : TPanel;
    Label2 : TLabel;
    fseMotionDir : TFloatSpinEdit;
    pnlRadiusEdit : TPanel;
    Label3 : TLabel;
    fseBlurRadius : TFloatSpinEdit;
    procedure btnLoadClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnApplyClick(Sender : TObject);
    procedure rgBlurMethodSelectionChanged(Sender : TObject);
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

uses BZMath;

{ TMainForm }

procedure TMainForm.btnLoadClick(Sender : TObject);
begin
  if OPD.Execute then
  begin
    FApplyFilter := False;
    FTempBmp.LoadFromFile(OPD.FileName);
    ImgOriginal.Picture.Bitmap.Assign(FTempBmp);
    ImgOriginal.Invalidate;
    rgBlurMethod.Enabled := true;
    btnApply.Enabled := True;
    gbxOptions.Enabled := True;
    pnlRadiusEdit.Enabled := False;
    pnlMotionDirEdit.Enabled := False;
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

procedure TMainForm.rgBlurMethodSelectionChanged(Sender : TObject);
begin
  pnlRadiusEdit.Enabled := ((rgBlurMethod.ItemIndex >= 2) and (rgBlurMethod.ItemIndex < 12)) or (rgBlurMethod.ItemIndex = 13);
  pnlMotionDirEdit.Enabled := (rgBlurMethod.ItemIndex = 7) or (rgBlurMethod.ItemIndex = 10) or (rgBlurMethod.ItemIndex = 11) or (rgBlurMethod.ItemIndex = 13);
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
begin

  FApplyFilter := True;

  FTempBmp.BlurFilter.OnProgress := @DoFilterProgress;
  Case rgBlurMethod.ItemIndex of
    0 : FTempBmp.BlurFilter.LinearBlur;
    1 : FTempBmp.BlurFilter.FastBlur;
    2 : FTempBmp.BlurFilter.BoxBlur(Round(fseBlurRadius.Value));
    3 : FTempBmp.BlurFilter.SplitBlur(Round(fseBlurRadius.Value));
    4 : FTempBmp.BlurFilter.GaussianSplitBlur(Round(fseBlurRadius.Value));
    5 : FTempBmp.BlurFilter.GaussianBlur(fseBlurRadius.Value);
    6 : FTempBmp.BlurFilter.GaussianBoxBlur(fseBlurRadius.Value);
    7 : FTempBmp.BlurFilter.MotionBlur(Round(fseMotionDir.Value), Round(fseBlurRadius.Value),1.0,0.0);
    8 : FTempBmp.BlurFilter.RadialBlur(Round(fseBlurRadius.Value));
    9 : FTempBmp.BlurFilter.CircularBlur(Round(fseBlurRadius.Value));
    10 : FTempBmp.BlurFilter.ZoomBlur(FTempBmp.CenterX, FTempBmp.CenterY, Round(fseBlurRadius.Value),Round(fseMotionDir.Value),Round(fseMotionDir.Value));
    11 : FTempBmp.BlurFilter.RadialZoomBlur(FTempBmp.CenterX, FTempBmp.CenterY,Round(fseBlurRadius.Value),Round(fseMotionDir.Value));
    12 : FTempBmp.BlurFilter.FXAABlur;
    13 : FTempBmp.BlurFilter.ThresholdBlur(fseBlurRadius.Value,ClampByte(Round(fseMotionDir.Value)));
  end;

  ImgResult.Picture.Bitmap.Assign(FTempBmp);
  ImgResult.Invalidate;
  FTempBmp.Assign(ImgOriginal.Picture.Bitmap);
end;

end.
