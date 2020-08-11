unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ExtDlgs, ComCtrls, BZImageViewer,
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
    btnApply : TButton;
    GroupBox3 : TGroupBox;
    Label1 : TLabel;
    rgConvolutionFilters : TRadioGroup;
    chkGrayScale : TCheckBox;
    pbImageProgress : TProgressBar;
    lblAction : TLabel;
    Splitter1 : TSplitter;
    procedure btnLoadClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnApplyClick(Sender : TObject);
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
    rgConvolutionFilters.Enabled := true;
    btnApply.Enabled := True;

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

Procedure TMainForm.DoFilterProgress(Sender : TObject; Stage : TBZProgressStage; PercentDone : Byte; RedrawNow : Boolean; Const R : TRect; Const Msg : String; Var aContinue : Boolean);
begin
  Case Stage Of
    opsStarting, opsRunning:
    Begin
      FTotalProgress := PercentDone;
      lblAction.Caption := Msg + ' - ' + IntToStr(FTotalProgress) + '%';
      pbImageProgress.Position := FTotalProgress;
      Application.ProcessMessages;
      //if RedrawNow then Application.ProcessMessages;
    End;
    opsEnding:
    Begin
      lblAction.Caption := '';
      pbImageProgress.Position := 0;
      FTotalProgress := 0;
      //Application.ProcessMessages;
    End;
  End;
end;

procedure TMainForm.ApplyFilter;
begin
  FApplyFilter := True;
  if chkGrayScale.Checked then FTempBmp.ColorFilter.GrayScale();
  FTempBmp.ConvolutionFilter.OnProgress := @DoFilterProgress;
  FTempBmp.ConvolutionFilter.DetectEdge(TBZDetectEdgeFilterMode(rgConvolutionFilters.ItemIndex)); // DEPRECIE cf SegmentationFilter
  ImgResult.Picture.Bitmap.Assign(FTempBmp);
  ImgResult.Invalidate;
  FTempBmp.Assign(ImgOriginal.Picture.Bitmap);
end;

end.

