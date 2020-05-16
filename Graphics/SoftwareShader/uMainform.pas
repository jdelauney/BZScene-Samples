unit uMainForm;

{$mode objfpc}{$H+}

{$CODEALIGN LOCALMIN=16}

{ TODO :



  http://glslsandbox.com/e#57089.0
  http://glslsandbox.com/e#56754.0
  http://glslsandbox.com/e#56286.0
  http://glslsandbox.com/e#63153.0
  http://glslsandbox.com/e#55641.0
  http://glslsandbox.com/e#55620.0
  http://glslsandbox.com/e#55602.0
  http://glslsandbox.com/e#55472.1
  http://glslsandbox.com/e#55279.0
  http://glslsandbox.com/e#55285.0
  http://glslsandbox.com/e#19521.2
  http://glslsandbox.com/e#45820.1
  http://glslsandbox.com/e#17474.2
  http://glslsandbox.com/e#45463.1
  http://glslsandbox.com/e#55156.0
  http://glslsandbox.com/e#46252.1
  http://glslsandbox.com/e#25869.1
  http://glslsandbox.com/e#55145.0
  http://glslsandbox.com/e#47213.1
  http://glslsandbox.com/e#55093.0

}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  BZClasses, BZVectorMath, BZColors, BZGraphic, BZBitmap, BZBitmapIO, BZCadencer, BZStopWatch,
  //BZCustomShader,
  BZBitmapRasterizer,
  BZSoftwareShader_GroundAndDistortPhongSphere,
  BZSoftwareShader_FuzzyMandelbrot,
  BZSoftwareShader_TwistedColoredLines,
  BZSoftwareShader_ReliefTunnel,
  BZSoftwareShader_NanoTubes,
  BZSoftwareShader_Flower,
  BZSoftwareShader_SymetryDisco,
  BZSoftwareShader_Explosion,
  BZSoftwareShader_MorphingSphereAndCube,
  BZSoftwareShader_Water,
  BZSoftwareShader_WaterPaint,
  BZSoftwareShader_NovaMarble,
  BZSoftwareShader_Voronoi;
type

  { TBZMyShader }

  //TBZMyShader = Class(TBZCustomSoftwareShader)
  //protected
  //  {$CODEALIGN RECORDMIN=16}
  //  FCameraPosition, FCameraDirection,
  //  FLightPosition : TBZVector4f;
  //  {$CODEALIGN RECORDMIN=4}
  //
  //
  //  FCadencer : TBZCadencer;
  //
  //  procedure DoApply(var rci: Pointer; Sender: TObject); override;
  //public
  //  {$CODEALIGN RECORDMIN=16}
  //  Resolution : TBZVector2i;
  //  InvResolution : TBZVector2f;
  //  {$CODEALIGN RECORDMIN=4}
  //  iChannel0 : TBZBitmap;
  //  RenderID : Integer;
  //  iTime : Double;
  //
  //  Constructor Create; override;
  //  Destructor Destroy; override;
  //
  //  function ShadePixelFloat:TBZColorVector; override;
  //  function Clone : TBZCustomSoftwareShader; override;
  //  procedure Assign(Source : TPersistent); override;
  //
  //  property Cadencer : TBZCadencer Read FCadencer Write FCadencer;
  //
  //  property CameraPosition : TBZVector4f read FCameraPosition Write FCameraPosition;
  //  property CameraDirection : TBZVector4f read FCameraDirection Write FCameraDirection;
  //  property LightPosition : TBZVector4f read FLightPosition Write FLightPosition;
  //
  //
  //end;

  { TMainForm }

  TMainForm = class(TForm)
    pnlProgress : Tpanel;
    lblAction : Tlabel;
    pbImageProgress : Tprogressbar;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormShow(Sender: TObject);
  private
    FBitmapBuffer, FDisplayBuffer : TBZBitmap;
    FCadencer : TBZCadencer;
    FStopWatch : TBZStopWatch;

  protected
    {$CODEALIGN RECORDMIN=16}
    GroundShader : TBZSoftShader_GroundAndDistortPhongSphere;
    FuzzyMandelShader : TBZSoftShader_FuzzyMandelbrot;
    ColoredLinesShader : TBZSoftShader_TwistedColoredLines;
    TunnelShader : TBZSoftShader_ReliefTunnel;
    NanotubeShader : TBZSoftShader_NanoTubes;
    FlowerShader : TBZSoftShader_Flower;
    DiscoShader : TBZSoftShader_SymetryDisco;
    ExplosionShader : TBZSoftShader_Explosion;
    MorphSphereAndCube : TBZSoftShader_MorphingSphereAndCube;
    Water : TBZSoftShader_Water;
    WaterPaint : TBZSoftShader_WaterPaint;
    NovaMarble : TBZSoftShader_NovaMarble;
    Voronoi : TBZSoftShader_Voronoi;
    {$CODEALIGN RECORDMIN=4}

    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
    Procedure DoRasterProgress(Sender: TObject; Stage: TBZProgressStage; PercentDone: Byte; RedrawNow: Boolean;
          Const R: TRect; Const Msg: String; Var aContinue: Boolean);
  public
    {$CODEALIGN RECORDMIN=16}
    BitmapRasterizer : TBZBitmapShaderThreadRasterizer;
    {$CODEALIGN RECORDMIN=4}

    Blur : Boolean;

    procedure DisplayBuffer;
    Procedure RenderScene;
    Procedure InitScene;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses  BZMath, BZUtils, BZLogger, BZTypesHelpers;

{ TMainForm }

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  FStopWatch.Stop;
  FCadencer.Enabled := False;
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  InitScene;
  //FBitmapBuffer.ClipRect.Create(50,50,150,150);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FStopWatch);
  FreeAndNil(FCadencer);
  FreeAndNil(BitmapRasterizer);
  FreeAndNil(GroundShader);
  FreeAndNil(FuzzyMandelShader);
  FreeAndNil(ColoredLinesShader);
  FreeAndNil(TunnelShader);
  FreeAndNil(NanotubeShader);
  FreeAndNil(FlowerShader);
  FreeAndNil(DiscoShader);
  FreeAndNil(ExplosionShader);
  FreeAndNil(MorphSphereAndCube);
  FreeAndNil(Water);
  FreeAndNil(WaterPaint);
  FreeAndNil(NovaMarble);
  FreeAndNil(Voronoi);
  FreeAndNil(FBitmapBuffer);
  FreeAndNil(FDisplayBuffer);
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = 'B')  or (Key='b') then Blur := not(blur);
  if key ='0' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    GroundShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,GroundShader);
    FCadencer.Enabled := True;
  end
  else
  if key ='1' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    FuzzyMandelShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,FuzzyMandelShader);
    FCadencer.Enabled := True;
  end
  else if key ='2' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    ColoredLinesShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,ColoredLinesShader);
    FCadencer.Enabled := True;
  end
  else if key ='3' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    TunnelShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,TunnelShader);
    FCadencer.Enabled := True;
  end
  else if key ='4' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    NanotubeShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,NanotubeShader);
    FCadencer.Enabled := True;
  end
  else if key ='5' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    FlowerShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,FlowerShader);
    FCadencer.Enabled := True;
  end
  else if key ='6' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    DiscoShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,DiscoShader);
    FCadencer.Enabled := True;
  end
  else if key ='7' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    ExplosionShader.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,ExplosionShader);
    FCadencer.Enabled := True;
  end
  else if key ='8' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    MorphSphereAndCube.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,MorphSphereAndCube);
    FCadencer.Enabled := True;
  end
  else if key ='9' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    Water.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,Water);
    FCadencer.Enabled := True;
  end
  else if upCase(key) ='A' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    NovaMarble.Enabled := False;
    WaterPaint.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,WaterPaint);
    FCadencer.Enabled := True;
  end
  else if upCase(key) ='C' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,NovaMarble);
    FCadencer.Enabled := True;
  end
  else if upCase(key) ='D' then
  begin
    FCadencer.Enabled := False;
    FreeAndNil(BitmapRasterizer);
    GroundShader.Enabled := False;
    FuzzyMandelShader.Enabled := False;
    ColoredLinesShader.Enabled := False;
    TunnelShader.Enabled := False;
    NanotubeShader.Enabled := False;
    FlowerShader.Enabled := False;
    DiscoShader.Enabled := False;
    ExplosionShader.Enabled := False;
    MorphSphereAndCube.Enabled := False;
    Water.Enabled := False;
    WaterPaint.Enabled := False;
    NovaMarble.Enabled := False;
    Voronoi.Enabled := True;
    BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,Voronoi);
    FCadencer.Enabled := True;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin

  GroundShader.CameraPosition.CreatePoint(0, 0, -5);
  GroundShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  FuzzyMandelShader.CameraPosition.CreatePoint(0, 0, -5);
  FuzzyMandelShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  ColoredLinesShader.CameraPosition.CreatePoint(0, 0, -5);
  ColoredLinesShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  TunnelShader.iChannel0 := TBZBitmap.Create;
  TunnelShader.iChannel0.LoadFromFile('..\..\..\textures\Tunnel8.bmp');
  TunnelShader.CameraPosition.CreatePoint(0, 0, -5);
  TunnelShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  NanotubeShader.CameraPosition.CreatePoint(0, 0, -5);
  NanotubeShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  FlowerShader.CameraPosition.CreatePoint(0, 0, -5);
  FlowerShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  DiscoShader.CameraPosition.CreatePoint(0, 0, -5);
  DiscoShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  ExplosionShader.CameraPosition.CreatePoint(0, 0, -5);
  ExplosionShader.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  MorphSphereAndCube.CameraPosition.CreatePoint(0, 0, -5);
  MorphSphereAndCube.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  Water.CameraPosition.CreatePoint(0, 0, -5);
  Water.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  WaterPaint.CameraPosition.CreatePoint(0, 0, -5);
  WaterPaint.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  NovaMarble.CameraPosition.CreatePoint(0, 0, -5);
  NovaMarble.LightPosition.CreatePoint( 2.0, 4.5, -2.0); //(2.0, -5.0, 3.0);

  GroundShader.Enabled := True;
  BitmapRasterizer := TBZBitmapShaderThreadRasterizer.Create(FBitmapBuffer,GroundShader);

  DoubleBuffered:=true;

  FStopWatch.Start;
  FCadencer.Enabled := True;
end;

procedure TMainForm.CadencerProgress(Sender: TObject; const deltaTime, newTime: Double);
begin
  RenderScene;
  DisplayBuffer;

  Caption:='BZScene Software Shaders Demo - Tap key [0..9, A,C,D] + B = Blur ON/OFF - '+Format('%.*f FPS', [3, FStopWatch.getFPS]);
end;

Procedure TMainForm.DoRasterProgress(Sender: TObject; Stage: TBZProgressStage; PercentDone: Byte; RedrawNow: Boolean;
  Const R: TRect; Const Msg: String; Var aContinue: Boolean);
Begin
  Case Stage Of
    opsStarting:
    Begin
      lblAction.Caption := Msg + ' - ' + IntToStr(PercentDone) + '%';
      pbImageProgress.Position := PercentDone;
      Application.ProcessMessages;
    End;
    opsRunning:
    Begin
      lblAction.Caption := Msg + ' - ' + IntToStr(PercentDone) + '%';
      pbImageProgress.Position := PercentDone;
      // if (PercentDone mod 10)=0 then begin ImageView.Invalidate;end;   // Affichage progressif
      Application.ProcessMessages;
      //if RedrawNow then Application.ProcessMessages;
    End;
    opsEnding:
    Begin
      lblAction.Caption := '';
      pbImageProgress.Position := 0;
      //Application.ProcessMessages;
    End;
  End;
End;

procedure TMainForm.DisplayBuffer;
begin
 //FDisplayBuffer.FastCopy(FBitmapBuffer);
  FBitmapBuffer.Transformation.StretchTo(FDisplayBuffer);
  if Blur then FDisplayBuffer.BlurFilter.GaussianSplitBlur(1);

 //  if Blur then FBitmapBuffer.Transformation.StretchBicubicTo(FDisplayBuffer)
 //  else FBitmapBuffer.Transformation.StretchTo(FDisplayBuffer);

  //with FDisplayBuffer.Canvas do
  //begin
  //  //Font.Quality := fqAntialiased;
  //  Font.Color := clrWhite;
  //  TextOut(8,16,'Tap key : 0,1,2,3,4 for choosing shader.');
  //  if Blur then TextOut(8,32,'B for disable gaussian blur ')
  //  else TextOut(8,32,'B for enable gaussian blur ')
  //End;
  FDisplayBuffer.DrawToCanvas(Canvas, ClientRect);
end;

procedure TMainForm.RenderScene;
begin
  FBitmapBuffer.Clear(clrBlack);
 (* if MyShader.RenderID = 4 then
  begin
    Screen.Cursor := crHourGlass;
    BitmapRasterizer.Rasterize;
    pnlProgress.Visible := False;
    DisplayBuffer;
  End;   *)
  BitmapRasterizer.Rasterize;
  //if MyShader.RenderID = 4 then Screen.Cursor := crDefault;
end;

procedure TMainForm.InitScene;
begin
  FCadencer := TBZCadencer.Create(self);
  FCadencer.Enabled := False;
  FCadencer.OnProgress := @CadencerProgress;

  FStopWatch := TBZStopWatch.Create(self);

  Randomize;
  FDisplayBuffer := TBZBitmap.Create(640,480);
//  FDisplayBuffer.SetSize(Width div 2,Height div 2);
  FDisplayBuffer.Clear(clrBlack);

  FBitmapBuffer := TBZBitmap.Create;
  //FBitmapBuffer.SetSize(Width,Height); // Extra Qualité
  FBitmapBuffer.SetSize(Width div 2,Height div 2); // Moyenne Qualité
 // FBitmapBuffer.SetSize(160,110); // Basse qualité

  //FBitmapBuffer.SetSize(Width,Height);
  FBitmapBuffer.Clear(clrBlack);

  GroundShader := TBZSoftShader_GroundAndDistortPhongSphere.Create;
  FuzzyMandelShader := TBZSoftShader_FuzzyMandelbrot.Create;
  ColoredLinesShader := TBZSoftShader_TwistedColoredLines.Create;
  TunnelShader := TBZSoftShader_ReliefTunnel.Create;
  NanotubeShader := TBZSoftShader_NanoTubes.Create;
  FlowerShader := TBZSoftShader_Flower.Create;
  DiscoShader := TBZSoftShader_SymetryDisco.Create;
  ExplosionShader := TBZSoftShader_Explosion.Create;
  MorphSphereAndCube := TBZSoftShader_MorphingSphereAndCube.Create;
  Water := TBZSoftShader_Water.Create;
  WaterPaint := TBZSoftShader_WaterPaint.Create;
  NovaMarble := TBZSoftShader_NovaMarble.Create;
  Voronoi := TBZSoftShader_Voronoi.Create;

  GroundShader.Cadencer := FCadencer;
  FuzzyMandelShader.Cadencer := FCadencer;
  ColoredLinesShader.Cadencer := FCadencer;
  TunnelShader.Cadencer := FCadencer;
  NanotubeShader.Cadencer := FCadencer;
  FlowerShader.Cadencer := FCadencer;
  DiscoShader.Cadencer := FCadencer;
  ExplosionShader.Cadencer := FCadencer;
  MorphSphereAndCube.Cadencer := FCadencer;
  Water.Cadencer := FCadencer;
  WaterPaint.Cadencer := FCadencer;
  NovaMarble.Cadencer := FCadencer;
  Voronoi.Cadencer := FCadencer;

  Blur := true;

 // BitmapRasterizer.Shader := MyShader;
 // BitmapRasterizer.Buffer := FBitmapBuffer;
  //BitmapRasterizer.OnProgress := @DoRasterProgress;
end;

end.

