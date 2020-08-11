unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtDlgs, ExtCtrls,
  BZImageViewer, BZColors, BZGraphic, BZBitmap, BZBItmapIO;

type
  TMainForm = class(TForm)
    btnLoad : TButton;
    btnStop : TButton;
    btnPlay : TButton;
    btnPause : TButton;
    Button1 : TButton;
    Button2 : TButton;
    chkRaw : TCheckBox;
    chkTransparent : TCheckBox;
    ImageView : TBZImageViewer;
    Label1 : TLabel;
    Label2 : TLabel;
    lblCounter : TLabel;
    OPD : TOpenPictureDialog;
    Panel1 : TPanel;
    Timer1 : TTimer;
    procedure btnLoadClick(Sender : TObject);
    procedure btnPauseClick(Sender : TObject);
    procedure btnPlayClick(Sender : TObject);
    procedure btnStopClick(Sender : TObject);
    procedure Button1Click(Sender : TObject);
    procedure Button2Click(Sender : TObject);
    procedure chkTransparentChange(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure Timer1Timer(Sender : TObject);
  private
    FFrameCount, FCurrentFrameIndex : Integer;
    FTest : TBZBitmap;

    procedure DoOnFrameChange(Sender:TObject);
  public

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
    if Not(Assigned(FTest)) then
    begin
      FTest := TBZBitmap.Create;
      FTest.OnFrameChanged := @DoOnFrameChange;
    end;
    FTest.LoadFromFile(OPD.FileName);

    ImageView.Picture.LoadFromFile(OPD.FileName);
    FFrameCount := ImageView.Picture.Bitmap.ImageDescription.FrameCount; //ImageView.Picture.Bitmap.Layers.Count;
    FCurrentFrameIndex := 0;
    lblCounter.Caption := '0 / ' + FFrameCount.ToString;
    ImageView.Picture.Bitmap.RenderFrame(FCurrentFrameIndex);
  end;
end;

procedure TMainForm.btnPauseClick(Sender : TObject);
begin
  Timer1.Enabled := False;
  ImageView.AnimationPause;
  FTest.PauseAnimate;
end;

procedure TMainForm.btnPlayClick(Sender : TObject);
begin
  Timer1.Enabled := True;
  ImageView.AnimationStart;
  FTest.StartAnimate;
end;

procedure TMainForm.btnStopClick(Sender : TObject);
begin
  Timer1.Enabled := False;
  ImageView.AnimationStop;
  FTest.StopAnimate;
end;

procedure TMainForm.Button1Click(Sender : TObject);
begin
  if chkRaw.Checked then
  begin
    if ImageView.Picture.Bitmap.LayerIndex > 0 then
      ImageView.Picture.Bitmap.LayerIndex := ImageView.Picture.Bitmap.LayerIndex - 1;
  end
  else
  begin
    if FCurrentFrameIndex > 0 then
    FCurrentFrameIndex := FCurrentFrameIndex - 1;
    ImageView.Picture.Bitmap.RenderFrame(FCurrentFrameIndex);
  end;
end;

procedure TMainForm.Button2Click(Sender : TObject);
begin
  if chkRaw.Checked then
  begin
    if ImageView.Picture.Bitmap.LayerIndex < ImageView.Picture.Bitmap.Layers.Count-1 then
      ImageView.Picture.Bitmap.LayerIndex := ImageView.Picture.Bitmap.LayerIndex + 1;
  end
  else
  begin
    if FCurrentFrameIndex < ImageView.Picture.Bitmap.Layers.Count-1 then
    FCurrentFrameIndex := FCurrentFrameIndex + 1;
    ImageView.Picture.Bitmap.RenderFrame(FCurrentFrameIndex);
  end;
end;

procedure TMainForm.chkTransparentChange(Sender : TObject);
begin
  ImageView.DrawWithTransparency := not(ImageView.DrawWithTransparency);
  DoOnFrameChange(Self);
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  Timer1.Enabled := False;
  if Assigned(FTest) then FreeAndNil(FTest);
end;

procedure TMainForm.Timer1Timer(Sender : TObject);
begin
  lblCounter.Caption := ImageView.Picture.Bitmap.CurrentFrame.ToString + ' / ' + FFrameCount.ToString;
end;

procedure TMainForm.DoOnFrameChange(Sender : TObject);
begin
  FTest.DrawToCanvas(panel1.Canvas,panel1.ClientRect, not(ImageView.DrawWithTransparency), true);
end;

end.

