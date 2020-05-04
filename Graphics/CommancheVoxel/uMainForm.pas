unit uMainForm;

{$mode objfpc}{$H+}

//----------------------- DATA ALIGNMENT ---------------------------------------
{$IFDEF CPU64}
  {$ALIGN 16}
  {$CODEALIGN CONSTMIN=16}
  {$CODEALIGN LOCALMIN=16}
  {$CODEALIGN VARMIN=16}
{$ENDIF}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  LCLType,  // Pour les touches clavier
  BZArrayClasses, BZVectorMath, BZMath,
  BZColors, BZGraphic, BZBitmap, BZImageFileTGA,
  BZStopWatch, BZCadencer, BZKeyBoard;

Type
  TVirtualCam = packed record
    Position : TBZVector2f;
    Height : Single;
    Angle : Single;
    Horizon : Single;
    Distance : Single;
  end;

  TUserInput = packed record
    ForwardBackward : Single;
    LeftRight       : Single;
    UpDown          : Single;
    LookUp          : Boolean;
    LookDown        : Boolean;
  End;

type
  { TMainForm }
  TMainForm = class(TForm)
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormShow(Sender : TObject);
    procedure FormMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure FormMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure FormMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
  private
    FScreenBuffer, FMapBuffer, FTextureBuffer : TBZBitmap;
    FCadencer : TBZCadencer;
    FStopWatch : TBZStopWatch;
  protected
    {$IFDEF CPU64} {$CODEALIGN RECORDMIN=16} {$ENDIF}
     ScreenSize : TBZVector2i;
    {$IFDEF CPU64} {$CODEALIGN RECORDMIN=4} {$ENDIF}

    FHiddenY : TBZIntegerList;
    InvScreenWidth : Single;

    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
  public
    Camera        : TVirtualCam;
    UserInput     : TUserInput;
    MousePosition : TPoint;
    MMove         : Boolean;
    FShowHelp     : Boolean;
    FBlurring     : Boolean;
    SkyColor      : TBZColor;
    CurrentDeltaTime : Double;


    procedure UpdateCamera(DeltaTime : Double);
    procedure HandleKeys;

    procedure InitScene;
    procedure RenderScene;
    //procedure DisplayScene;

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

Uses BZTypesHelpers;
{ TMainForm }

Const
  {$IFDEF CPU64} {$CODEALIGN CONSTMIN=16} {$ENDIF}
  cDeltaTime : TBZVector2f = (x:0.03;y:0.03);
  {$IFDEF CPU64} {$CODEALIGN CONSTMIN=4} {$ENDIF}

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FCadencer.Enabled := False;
  FStopWatch.Stop;
  CanClose := True;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FTextureBuffer);
  FreeAndNil(FMapBuffer);
  FreeAndNil(FScreenBuffer);
  FreeAndNil(FStopWatch);
  FreeAndNil(FCadencer);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  InitScene;
  DoubleBuffered:=true;
  FStopWatch.Start;
  FCadencer.Enabled := True;
  UpdateCamera(FCadencer.CurrentTime);
end;

procedure TMainForm.FormMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
var
  dx,dy : Integer;
Begin
  if MMove then
  begin
    dx := (MousePosition.x - x);
    dy := (MousePosition.y - y);
    With UserInput do
    Begin
     // ForwardBackWard := 3.0;
      LeftRight := dx*0.7; // FScreenBuffer.Width;
      UpDown :=  1.0+dy;   // (FScreenBuffer.Height * 10);
    End;
    Camera.Horizon  := 100 + dy; // / (FScreenBuffer.Height * 500);
    MousePosition.x := X;
    MousePosition.y := Y;
    UpdateCamera(CurrentDeltaTime); //(FCadencer.CurrentTime);
    //DisplayScene;
  End;
end;

procedure TMainForm.FormMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  MMove := True;
  MousePosition.x := X;
  MousePosition.y := Y;
end;

procedure TMainForm.FormMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  MMove := False;
  With UserInput do
  Begin
   LeftRight := 0;
   ForwardBackWard := 0;
   UpDown := 0;
   LookDown := False;
   LookUp:=False;
  End;
end;

procedure TMainForm.CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
begin
  CurrentDeltaTime := DeltaTime*500;
  HandleKeys;
  RenderScene;
  FScreenBuffer.DrawToCanvas(Canvas, ClientRect);
  Caption:='BZScene Commanche Voxel Demo : '+Format('%.*f FPS', [3, FStopWatch.getFPS]);
end;

procedure TMainForm.UpdateCamera(DeltaTime : Double);
Var
  Altitude : Single;
  CosA,SinA : Single;
  {$IFDEF CPU64} {$CODEALIGN VARMIN=16} {$ENDIF}
  p1,p2,p3 : TBZVector2f;
  pt : TBZVector2i;
  {$IFDEF CPU64} {$CODEALIGN VARMIN=4} {$ENDIF}
Begin
  With UserInput do
  begin
    if LeftRight<>0 then
    begin
      Camera.angle := Camera.Angle + LeftRight*DeltaTime*0.003;
    End;
    if ForwardBackward<>0 then
    begin
      p1.Create(ForwardBackward,ForwardBackward);
      SinA := Sin(Camera.angle);
      CosA := Cos(camera.angle);
      p2.Create(SinA,CosA);
      p3.Create(DeltaTime,DeltaTime);
      Camera.Position :=  Camera.Position - (p1*p2*p3*cDeltatime);
    End;
    if UpDown<>0 then
    begin
      Camera.Height := Camera.Height + UpDown*DeltaTime*0.03;
    End;
    if LookUp then
    begin
      Camera.Horizon := Camera.Horizon + (DeltaTime*2)*0.03;
    End
    else if LookDown then
    begin
      Camera.Horizon := Camera.Horizon - (DeltaTime*2)*0.03;
    End;
    // Collision detection. Don't fly below the surface.
    pt := Camera.Position.floor;
    pt.x := (pt.x and FMapBuffer.MaxWidth);
    pt.y := (pt.y and FMapBuffer.MaxHeight);
    Altitude := FMapBuffer.Pixels[pt.x,pt.y].Red + 10;
    if (Altitude > Camera.Height) then Camera.Height := Altitude;
    //Camera.Distance := 600+Camera.Horizon+Camera.Height;
  End;
end;

procedure TMainForm.HandleKeys;
begin
  if IsKeyDown(VK_H) then FShowHelp:=not(FShowHelp);
  if IsKeyDown(VK_B) then FBlurring := not(FBlurring);
  if IsKeyDown(VK_ADD) then
  begin
   Camera.Distance := Camera.Distance + 2;
   Camera.Distance := Camera.Distance.Clamp(800,2000);
  End;
  if IsKeyDown(VK_SUBTRACT) then
  begin
   Camera.Distance := Camera.Distance - 2;
   Camera.Distance := Camera.Distance.Clamp(800,2000);
  End;

  if IsKeyDown(VK_LEFT) then
  begin
   UserInput.LeftRight :=  0.3;
  End
  else if IsKeyDown(VK_RIGHT) then
  begin
   UserInput.LeftRight := -0.3;
  End
  else UserInput.LeftRight :=0;

  if IsKeyDown(VK_UP) or IsKeyDown(VK_RBUTTON)  then
  begin
   UserInput.ForwardBackward := +3.0;
  End
  else if IsKeyDown(VK_DOWN) then
  begin
   UserInput.ForwardBackward :=  -3.0;
  End
  else UserInput.ForwardBackward := 0;

  if IsKeyDown(VK_R) then
  begin
   UserInput.UpDown := +2.0;
  End
  else if IsKeyDown(VK_F) then
  begin
   UserInput.UpDown := -2.0;
  End
  else UserInput.UpDown := 0;

  if IsKeyDown(VK_E) then
  begin
   UserInput.LookUp := True;
   UserInput.LookDown := False;
  End
  else if IsKeyDown(VK_D) then
  begin
   UserInput.LookUp := False;
   UserInput.LookDown := True;
  End
  else
  begin
   UserInput.LookUp := False;
   UserInput.LookDown := False;
  End;
  UpdateCamera(CurrentDeltaTime); //(FCadencer.CurrentTime);
  //DisplayScene;
end;

procedure TMainForm.InitScene;
begin
  FCadencer := TBZCadencer.Create(self);
  FCadencer.Enabled := False;
  FCadencer.OnProgress := @CadencerProgress;

  FStopWatch := TBZStopWatch.Create(self);

  SkyColor.Create(0,128,255,255);
  FScreenBuffer := TBZBitmap.Create(ClientWidth,ClientHeight);
  FScreenBuffer.Clear(SkyColor);

  FMapBuffer := TBZBitmap.Create;
  FTextureBuffer := TBZBitmap.Create;

  FTextureBuffer.LoadFromFile('../../../../../media/images/texturemaphq.tga');
  FMapBuffer.LoadFromFile('../../../../../media/images/maphq.tga');


  FHiddenY := TBZIntegerList.Create(FScreenBuffer.Width);
  FHiddenY.Count := FScreenBuffer.Width;

  With Camera do
  Begin
   Position.Create(512,512);
   Height := 50;
   Angle := 25;
   Horizon := 100;
   Distance := 800;
  End;
  ScreenSize.Create(FScreenBuffer.Width, FScreenBuffer.Height);

  With UserInput do
  begin
   ForwardBackward := 0;
   LeftRight := 0;
   UpDown := 0;
   LookUp := False;
   LookDown := False;
   MousePosition.Create(FScreenBuffer.CenterX,FScreenBuffer.CenterY);
  End;

  FShowHelp := true;
  FBlurring := false;
  end;

procedure TMainForm.RenderScene;
var
  {$CODEALIGN VARMIN=16}
  pl, pr, dp, p1,p2,p3,p4,p5 : TBZVector2f;
  pt : TBZVector2i;
  {$CODEALIGN VARMIN=4}
  SinCamAngle, CosCamAngle, dz, z,
  InvZ,  HeightOnScreen : Single;
  I, yl, hl :Integer;

  procedure ClearHiddenY;
  Var
    I : Integer;
  begin
    For i:=0 to FHiddenY.Count-1 do
    begin
      FHiddenY.Items[I] :=  FScreenBuffer.MaxHeight;
    End;
  End;

Begin
  FScreenBuffer.Clear(SkyColor);
  ClearHiddenY;
  SinCamAngle := Sin((Camera.Angle));
  CosCamAngle := Cos((Camera.Angle));
  p1.Create(-CosCamAngle, SinCamAngle);
  p2.Create(CosCamAngle,-SinCamAngle);
  p3.Create(SinCamAngle,CosCamAngle);
  dz :=0.1;
  Z:=1.0;
  While (Z<Camera.Distance) do
  begin
    z:=z+dz;
    p4.Create(z,z);
    p5 := (p3 * p4);
    pl := (p1 * p4) - p5;
    pr := (p2 * p4) - p5;
    dp := (pr - pl) / ScreenSize;
    pl := pl + Camera.Position;
    InvZ := 1 / Z*240;
    For i:=0 to FScreenBuffer.MaxWidth do
    begin
      pt := pl.Floor;
      pt.x := pt.x and FMapBuffer.MaxWidth;
      pt.y := pt.y and FMapBuffer.MaxHeight;
      HeightOnScreen := (Camera.Height - FMapBuffer.getPixel(pt.X,pt.Y).Red) * InvZ + Camera.Horizon;
      yl:=HeightOnScreen.Round;
      if (yl<0) then yl:=0;
     // if (yl>FScreenBuffer.MaxHeight) then continue;
      hl := FHiddenY.Items[i];//- yl;
      if (hl>yl) then
      begin
        With FScreenBuffer.Canvas do
        begin
          Pen.Color := FTextureBuffer.GetPixel(pt.X,pt.Y);
          VLine(I,yl,hl);
        End;
      End;
      if (yl<=FHiddenY.Items[i]) then FHiddenY.Items[i] := yl;
      pl := pl + dp;
    End;
    dz := dz+ 0.01;
  end;
 if FBlurring then FScreenBuffer.BlurFilter.GaussianSplitBlur(1); //.FastBlur;
 if FShowHelp then
 begin
   With FScreenBuffer.Canvas do
   begin
      Pen.Color:=clrBlack;
      Brush.Color.Create(64,164,64,175);
      Brush.Style := bsSolid;;
      DrawMode.AlphaMode := amAlpha;
      Rectangle(4,4,670,100);
      //DrawMode.PixelMode := dmSet;
      DrawMode.AlphaMode := amOpaque;
      font.Size:=10;
      font.Color :=clrWhite;
      Textout(10,20,'Keys : Up/Down for moving forward and backward. Use mouse for lift and turn, Right Button for auto advance');
      Textout(10,36,'Keys : left/right for turn. E/D for pitch. R/F for Lift up and Down');
      Textout(10,50,'Keys : B Enable/Disable Blur ='+FBlurring.ToString('ON','OFF'));
      Textout(10,64,'Keys : C Show/Hide Cockpit');
      Textout(10,78,'Keys : +/- Change Distance = '+Camera.Distance.ToString());
      Textout(10,92,'Keys : H Show/Hide this Help');
    End;
 End;
end;

//procedure TMainForm.DisplayScene;
//begin
//  RenderScene;
//  FScreenBuffer.DrawToCanvas(Canvas, ClientRect); //,true,false);
//end;

end.

