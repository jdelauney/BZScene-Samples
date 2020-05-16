unit uMainForm;

{$mode objfpc}{$H+}

// ALIGNEMENT
{$ifdef cpu64}
  {$ALIGN 16}

  {$CODEALIGN CONSTMIN=16}
  {$CODEALIGN LOCALMIN=16}
  {$CODEALIGN VARMIN=16}
{$endif}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  BZVectorMath, BZColors, BZGraphic, BZBitmap, BZCadencer, BZStopWatch,{%H-}BZBitmapIO;


{
  Performance  sur :
  AMD-K7 - 16go Ram - NVidia getforce GTX 1070
   - 300 sprites ~59<> 62 fps
   - 500 sprites ~40<>42 fps
   - 750 sprites ~29<>32 fps
   - 1000 sprites ~~23<>25 fps
   - 2000 sprites ~12<>14 fps
}

Const
  MAXSPRITES = 299;
  ResNameList : Array[0..6] of String = ('flowerdance_back.tga',
                                         'flowerdance_fore1.tga',
                                         'flowerdance_sprite01.tga',
                                         'flowerdance_sprite02.tga',
                                         'flowerdance_sprite03.tga',
                                         'flowerdance_sprite04.tga',
                                         'flowerdance_sprite05.tga');
type
  TSpriteRec = packed record
    Pos : TBZVector2i;
    Delta : TBZVector2i;
    BounceX,BounceY : Boolean;
    Speed : TBZVector2i;
    Idx, LOD : Integer;
    Alpha : Byte;
  end;

type

  { TMainForm }

  TMainForm = class(TForm)
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormKeyPress(Sender : TObject; var Key : char);
    procedure FormShow(Sender : TObject);
  private
    FStopWatch : TBZStopWatch;
    FStartTime : Int64;
    FCurrentTime : Int64;

    FCadencer : TBZCadencer;
    FDisplayBuffer : TBZBitmap;
  protected

    SpriteResLib : Array[0..6] of TBZBitmap;

    SpritesLOD : Array[0..4,0..4] of TBZBitmap;
    ForeGround, BackGround :TBZBitmap;
    SpritesData : array[0..MAXSPRITES] of TSpriteRec;
    FrameCounter:Integer;

    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
  public
    procedure DoAnim;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
Var
  I,J,K,M,W : Integer;
begin
  FStopWatch := TBZStopWatch.Create(nil);
  FCadencer := TBZCadencer.Create(self);
  FCadencer.Enabled := False;
  FCadencer.OnProgress := @CadencerProgress;

  FDisplayBuffer:= TBZBitmap.Create(640,480);

  For I:=0 to 6 do
  begin
    SpriteResLib[I]:=TBZBitmap.Create(0,0);
    SpriteResLib[I].LoadFromFile('..\..\..\..\..\media\images\'+ResNameList[I]);
  end;
  BackGround := TBZBitmap.Create(640,480);
  BackGround.Assign(SpriteResLib[0]);
  ForeGround := TBZBitmap.Create(640,480);
  ForeGround.Assign(SpriteResLib[1]);
//  ForeGround.ColorFilter.SetAlpha(asmSuperBlackTransparent );
  For I:=0 to 4 do
  begin
    K:=16;
    For J:=0 to 4 do
    begin
      M:=J+1;
      W:=K*M;
      SpritesLOD[I,J]:=TBZBitmap.Create(SpriteResLib[I+2].Width,SpriteResLib[I+2].Height);
      SpritesLOD[I,J].Assign(SpriteResLib[I+2]);
      SpritesLOD[I,J].Transformation.StretchSmooth(W,W);
    end;
  end;

  Randomize;

  For i:=0 to MAXSPRITES do
  begin
   With SpritesData[i] do
   Begin
     Pos.Create(random(640),random(480));
     Delta.Create(1+Random(Random(8)),1+Random(Random(8)));
     j:=Random(2);
     if j>0 then BounceX:=True else BounceX:=False;
     j:=Random(2);
     if j>0 then BounceY:=True else BounceY:=False;
     Alpha:=0;
     Idx := Random(5);
     LOD := Random(5);
   end;
  end;
  FrameCounter:=0;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
Var
  I,J:Integer;
begin
  FCadencer.Enabled:=false;
  FStopWatch.Stop();

  FreeAndNil(ForeGround);
  FreeAndNil(BackGround);
  For I:=4 downto 0 do
  begin
    For J:=4 downto 0 do
    begin
     FreeAndNil(SpritesLOD[I,J]);
    end;
  end;

  For I:=6 downto 0 do
  begin
    FreeAndNil(SpriteResLib[I]);
  end;

  FreeAndNil(FDisplayBuffer);
  FreeAndNil(FCadencer);
  FreeAndNil(FStopWatch);
end;

procedure TMainForm.FormKeyPress(Sender : TObject; var Key : char);
begin
  if key = #27 then Close;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  DoubleBuffered:=true;
  FStopWatch.Start();
  FStartTime := GetTickCount64;
  FCadencer.Enabled:=true;
end;

procedure TMainForm.DoAnim;
Var
  i, dx, dy : Integer;
begin
  FDisplayBuffer.PutImage(BackGround,0,0,640,480,0,0);
  For i:=0 to MAXSPRITES do
  begin
    With SpritesData[i] do
    Begin
      Pos := Pos + Delta;

      dx := FDisplayBuffer.Width - SpritesLOD[Idx,LOD].Width;
      dy := FDisplayBuffer.Height - SpritesLOD[Idx,LOD].Height;

      if (Pos.X>dx) then
      begin
        Pos.X:=dx;
        Delta.X:=-Delta.X;
      end;
      if Pos.X<0 then
      begin
       Pos.X:=0;
       Delta.X:=-Delta.X;
      end;

      if Pos.Y<0 then
      begin
        Pos.Y:=0;
        Delta.Y:=-Delta.Y;
      end;
      if Pos.Y>dy then
      begin
       Pos.Y:=dy;
       Delta.Y:=-Delta.Y;
      end;

      FDisplayBuffer.PutImage(SpritesLOD[Idx,LOD],0,0,SpritesLOD[Idx,LOD].Width,SpritesLOD[Idx,LOD].Height,
                             Pos.X, Pos.Y,dmSet, amAlpha);

    end;
  end;
  FDisplayBuffer.PutImage(ForeGround,0,0,640,480,0,0,dmSet, amAlpha);
End;

procedure TMainForm.CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
begin
  DoAnim;
  FDisplayBuffer.DrawToCanvas(Canvas,ClientRect);
  Caption:='BZScene Demo - Dance Flower - FPS : '+Format('%.*f FPS', [3, FStopWatch.getFPS]);  //(FrameCounter)
end;

end.

