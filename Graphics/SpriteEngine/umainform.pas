Unit umainform;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Fileutil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  BZColors, BZGraphic, BZBitmap, BZBitmapIO, BZSprite;

Const BallCounts = 12;

Type
  TBZBallSprite = Class(TBZBitmapSprite)
  protected
    procedure DoMove(MoveCount : Integer); override;
    procedure DoCollision(Sprite: TBZCustomBaseSprite);override;
  End;

  { TMainForm }

  TMainForm = Class(Tform)
    Timer1 : Ttimer;
    Procedure Formclose(Sender : Tobject; Var Closeaction : Tcloseaction);
    Procedure Formcreate(Sender : Tobject);
    Procedure Formdestroy(Sender : Tobject);
    Procedure Formshow(Sender : Tobject);
    Procedure Timer1timer(Sender : Tobject);
  Private

  Public
    SpriteEngine : TBZBitmapSpriteEngine;
    BallSprites : Array[0..BallCounts-1] of TBZBallSprite;
    SurfaceBuffer : TBZBitmap;
    BallSpriteImage : TBZBitmap;
  End;

Var
  MainForm : TMainForm;

Implementation

{$R *.lfm}

{ TMainForm }

procedure TBZBallSprite.DoMove(MoveCount : Integer);
begin
  inherited DoMove(MoveCount);
  if (Self.WorldX>590) or (Self.WorldX<4) then Self.MoveX := -Self.MoveX;
  if (Self.WorldY>430) or (Self.WorldY<4) then Self.MoveY := -Self.MoveY;
  self.Collision;
End;

procedure TBZBallSprite.DoCollision( Sprite: TBZCustomBaseSprite);
begin
  if Sprite Is TBZBallSprite then
  begin
    if (Self.WorldX <= TBZBallSprite(Sprite).WorldX+24)  then
    begin
      //Self.MoveX := -Self.MoveX;
      //TBZBallSprite(Sprite).MoveX := -TBZBallSprite(Sprite).MoveX;
      //if Self.MoveX > 0 then
      Self.MoveX := -Self.MoveX;// else Self.MoveX := abs(Self.MoveX);
      //if TBZBallSprite(Sprite).MoveX > 0 then
      TBZBallSprite(Sprite).MoveX := -TBZBallSprite(Sprite).MoveX;
      //else TBZBallSprite(Sprite).MoveX := abs(TBZBallSprite(Sprite).MoveX);
    End;

    if Self.WorldY <= TBZBallSprite(Sprite).WorldY+24  then
    begin
      //if Self.MoveY > 0 then
      Self.MoveY := -Self.MoveY;// else Self.MoveY := abs(Self.MoveY);
      //if TBZBallSprite(Sprite).MoveY > 0 then
      TBZBallSprite(Sprite).MoveY := -TBZBallSprite(Sprite).MoveY;
      //else TBZBallSprite(Sprite).MoveY := abs(TBZBallSprite(Sprite).MoveY);
    End;

   (* if (TBZBallSprite(Sprite).WorldX = Self.WorldX) and (TBZBallSprite(Sprite).WorldY = Self.WorldY) then
    begin
      Self.Dead;
      Sprite.Dead;
    End; *)

  (*  Self.DoMove(1);
    TBZBallSprite(Sprite).DoMove(1);
    if (Self.WorldX>614) or (Self.WorldX<26) then Self.MoveX := -Self.MoveX;
    if (Self.WorldY>454) or (Self.WorldY<26) then Self.MoveY := -Self.MoveY;
    if (TBZBallSprite(Sprite).WorldX>614) or (TBZBallSprite(Sprite).WorldY<26) then TBZBallSprite(Sprite).MoveX := -TBZBallSprite(Sprite).MoveX;
    if (TBZBallSprite(Sprite).WorldY>454) or (TBZBallSprite(Sprite).WorldY<26) then TBZBallSprite(Sprite).MoveY := -TBZBallSprite(Sprite).MoveY; *)
  end;
End;

Procedure Tmainform.Formcreate(Sender : Tobject);
var i:Integer;
Begin
  Randomize;
  SurfaceBuffer := TBZBitmap.Create(640,480);
  BallSpriteImage := TBZBitmap.Create;
  BallSpriteImage.LoadFromFile('..\..\..\medias\ball1.tga');
  SpriteEngine := TBZBitmapSpriteEngine.Create(nil);
  SpriteEngine.Surface := SurfaceBuffer;
  SpriteEngine.SurfaceRect.Create(0,0,640,480);
  For I:=0 to BallCounts-1 do
  begin
    BallSprites[I] := TBZBallSprite.Create(SpriteEngine);
    BallSprites[I].Image := BallSpriteImage;
    BallSprites[I].Width := BallSpriteImage.Width;
    BallSprites[I].Height := BallSpriteImage.Height;
    BallSprites[I].X := 24+Random(590);
    BallSprites[I].Y := 24+Random(430);
    BallSprites[I].MoveX := 1+Random(4);
    BallSprites[I].MoveY := 1+Random(4);
    BallSprites[I].Anchor := saCenter;
    BallSprites[I].CollideMode := cmCircle;
    BallSprites[I].CollideRadius := 24;
    BallSprites[I].EnabledCollision := True;
    BallSprites[I].EnabledMove := True;
  End;
End;

Procedure Tmainform.Formdestroy(Sender : Tobject);
var i : Integer;
Begin
//    For I:=0 to 19 do BallSprites[I].Free;

 // SpriteEngine.Free;
  FreeAndNil(SurfaceBuffer);
  FreeAndNil(BallSpriteImage);
End;

Procedure Tmainform.Formclose(Sender : Tobject; Var Closeaction : Tcloseaction);
Begin
   Timer1.Enabled := False;
End;

Procedure Tmainform.Formshow(Sender : Tobject);
Begin
  Timer1.Enabled := True;
End;

Procedure Tmainform.Timer1timer(Sender : Tobject);
Begin
  SurfaceBuffer.Clear(clrBlack);
  SpriteEngine.Draw;
  SpriteEngine.Move(1);
  //SpriteEngine.Collision;

 SurfaceBuffer.DrawToCanvas(Self.Canvas, Self.ClientRect,True, False);
End;

End.

