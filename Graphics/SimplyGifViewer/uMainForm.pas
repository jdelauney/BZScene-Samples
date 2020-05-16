unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtDlgs,
  BZImageViewer, BZColors, BZGraphic, BZBitmap, BZBItmapIO;

type
  TMainForm = class(TForm)
    btnLoad : TButton;
    btnStop : TButton;
    btnPlay : TButton;
    btnPause : TButton;
    ImageView : TBZImageViewer;
    lblCounter : TLabel;
    OPD : TOpenPictureDialog;
    procedure btnLoadClick(Sender : TObject);
    procedure btnPauseClick(Sender : TObject);
    procedure btnPlayClick(Sender : TObject);
    procedure btnStopClick(Sender : TObject);
  private
    FFrameCount, FCurrentFrameIndex : Integer;
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
    ImageView.Picture.LoadFromFile(OPD.FileName);
    FFrameCount := ImageView.Picture.Bitmap.Layers.Count;
    FCurrentFrameIndex := 0;
    lblCounter.Caption := '0 / ' + FFrameCount.ToString;
  end;
end;

procedure TMainForm.btnPauseClick(Sender : TObject);
begin
  ImageView.AnimationPause;
end;

procedure TMainForm.btnPlayClick(Sender : TObject);
begin
  //if FCurrentFrameIndex <= FFrameCount - 1 then
  //begin
  //  lblCounter.Caption := FCurrentFrameIndex.ToString + ' / ' + FFrameCount.ToString;
  //  ImageView.Picture.Bitmap.RenderFrame(FCurrentFrameIndex);
  //  Inc(FCurrentFrameIndex);
  //end;
  ImageView.AnimationStart;
end;

procedure TMainForm.btnStopClick(Sender : TObject);
Var
  DstBmp, SrcBmp : TBZBitmap;
begin
  //DstBmp := TBZBitmap.Create;
  //SrcBmp := TBZBitmap.Create;
  //DstBmp.Assign(ImageView.Picture.Bitmap.Layers.Items[0].Bitmap);
  //SrcBmp.Assign(ImageView.Picture.Bitmap.Layers.Items[1].Bitmap);
  ////ShowMessage('TransColor =  ' + SrcBmp.ImageDescription.TransparentColor.ToString);
  //DstBmp.PutImage(SrcBmp,0,0,SrcBmp.Width, SrcBmp.Height,0,0,dmSet, amAlphaCheck);
  //ImageView.Picture.Bitmap.Assign(DstBmp);
  //ImageView.Invalidate;
  //FreeAndNil(DstBmp);
  //FreeAndNil(SrcBmp);
  ImageView.AnimationStop;
end;

end.

