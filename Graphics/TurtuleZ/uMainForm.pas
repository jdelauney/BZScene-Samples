unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  BZColors, BZGraphic, BZBitmap, BZStopWatch, BZCadencer;

type

  { TMainForm }

  TMainForm = class(TForm)
    procedure FormShow(Sender : TObject);
    procedure FormKeyPress(Sender : TObject; var Key : char);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormCreate(Sender : TObject);
    procedure FormMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure FormMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
  private
    FBitmapBuffer : TBZBitmap;
    FCadencer : TBZCadencer;
    FStopWatch : TBZStopWatch;
  protected
    CurAngle : Single;
    FPause : Boolean;
    SpiroMode : Byte;
    FrameCounter :Integer;
    p, q: integer;  // pour le Dragoon
    IsMouseDown : Boolean;
    procedure CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
  public
    Procedure RenderScene;
    procedure RenderUI;
    Procedure InitScene;
    Procedure InitColorMap;
    procedure PauseScene;
    procedure ReStartScene;
    procedure StartScene;

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses
  BZMath, BZTypesHelpers;

procedure TMainForm.RenderUI;
begin

  With FBitmapBuffer.Canvas do
  begin
    //Antialias := True;
    //Font.Name := 'Serif';
    Font.Size := 32;
   // Font.Quality := fqAntiAliased;
    DrawMode.PixelMode := dmSet;

    Font.Color := clrRed;
    TextOut(20,40,'Turtle Walker');
    DrawMode.AlphaMode := amAlpha;
    Brush.Style := bsSolid;
    Brush.Color.Create(32,32,32,192);
    Rectangle(20,80,440,235);

    Font.Size:= 12;

    DrawMode.AlphaMode := amNone;
    Font.Color := clrYellow;
    TextOut(24,96,'Choose your runner');
    if SpiroMode = 0 then Font.Color := clrLime else Font.Color := clrWhite;
    TextOut(24,114,'[0] Spiral');
    if SpiroMode = 1 then Font.Color := clrLime else Font.Color := clrWhite;
    TextOut(24,128,'[1] Square');
    if SpiroMode = 2 then Font.Color := clrLime else Font.Color := clrWhite;
    TextOut(24,142,'[2] 5-Star');
    if SpiroMode = 3 then Font.Color := clrLime else Font.Color := clrWhite;
    TextOut(24,156,'[3] 9-Tri');
    if SpiroMode = 4 then Font.Color := clrLime else Font.Color := clrWhite;
    TextOut(24,170,'[4] VonCoch');
    if SpiroMode = 5 then Font.Color := clrLime else Font.Color := clrWhite;
    TextOut(24,184,'[5] Dragoon');
    if SpiroMode = 6 then Font.Color := clrLime else Font.Color := clrWhite;
    TextOut(24,198,'[6] Squared Spiral');
    Font.Color := clrWhite;
    TextOut(24,220,'[SPACE] Pause/Resume');
    //Antialias := False;
  end;
end;

procedure TMainForm.RenderScene;
var
  i, j: integer;
  CurColor : TBZColor;

  procedure dragon(n:integer; l:Single; var p,q:integer);
    begin
      if n=1 then
      begin
        //inc(cx);
        FBitmapBuffer.Canvas.TraceTo(l);
       (* if (cx mod 10)=0 then
          begin
           pnlView.Invalidate;
           application.ProcessMessages;
          End; *)
      end
      else
      begin
        FBitmapBuffer.Canvas.TurnTo(25+random(65));
        dragon(n-1,l,p,q);
        FBitmapBuffer.Canvas.TurnTo(5+random(85));
        dragon(n-1,l,p,q);
        FBitmapBuffer.Canvas.TurnTo(75+random(105));
        dragon(n-1,l,p,q);
        FBitmapBuffer.Canvas.TurnTo(-25+random(65));
        dragon(n-1,l,p,q);
        FBitmapBuffer.Canvas.TurnTo(-25+random(165));
        dragon(n-1,l,p,q);
        FBitmapBuffer.Canvas.TurnTo(-5+random(85));
        dragon(n-1,l,p,q);
        FBitmapBuffer.Canvas.TurnTo(90);
      end;
    end;

  procedure flocon(n:integer; lg:Single);
  var p:integer;
   procedure floc(n,p:integer; lg:Single);
     function Internalpow(a,b:integer):integer;
     begin
          if b=0 then
              result:=1
          else
              result:=Round(a*powerInt(a,b-1)); //round(a*powInt(a,b-1));
     end;
   begin
      if (n=0) then
      begin
        FBitmapBuffer.Canvas.TraceTo(lg/(Internalpow(3,p)));
      End
      else
      begin
        floc(n-1,p,lg);
        FBitmapBuffer.Canvas.TurnTo(60);
        floc(n-1,p,lg);
        FBitmapBuffer.Canvas.TurnTo(-120);
        floc(n-1,p,lg);
        FBitmapBuffer.Canvas.TurnTo(60);
        floc(n-1,p,lg);
      end;
   end;
   begin
     p:=n;
     floc(n,p,lg);
   end;

  procedure SquareSpiral;
  var
    i,j, d : Integer;
  begin
    i:=0;
    //d:=1+round(CurAngle*0.25); //
    d:=Round((CurAngle / 40)*20);//*20);
    FBitmapBuffer.Clear(curColor.Invert);
    FBitmapBuffer.Canvas.MoveTo(FBitmapBuffer.CenterX,FBitmapBuffer.CenterY);
    //ca := CurAngle;
    //FBitmapBuffer.Canvas.TurnTo(90);
    while i<90 do
    begin
      for j:=1 to 4 do
      begin
        with FBitmapBuffer.Canvas do
        begin
           TurnTo(90);
           TraceTo(d*i);
           inc(i);
        end;
      end;
    end;
  end;

begin
  CurColor := FBitmapBuffer.ColorManager.Palette.Colors[Round(CurAngle*256) div 360].Value;
  //(Round(((CurAngle+1)*(FBitmapBuffer.ColorManager.ColorCount-1))*0.002777)).ToByte].Value;
  FBitmapBuffer.Canvas.Pen.Color :=  CurColor;
  FBitmapBuffer.Canvas.Brush.Color :=  CurColor;
  CurColor := CurColor - 32; // Darken the color
  CurColor.Alpha := 255;

  Case SpiroMode of
    0:  // spiraling
    begin
      FBitmapBuffer.Clear(curColor.Invert);
      FBitmapBuffer.Canvas.MoveTo(FBitmapBuffer.CenterX,FBitmapBuffer.CenterY);
      for i := 0 to 599 do
      begin
        with FBitmapBuffer.Canvas do
        begin
          TraceTo(I);
          TurnTo(CurAngle);
        end;
      end;
    end;
    1:  // Square
    begin
      FBitmapBuffer.Clear(curColor.Invert);
      FBitmapBuffer.Canvas.MoveTo(FBitmapBuffer.CenterX-25,FBitmapBuffer.CenterY-25);
      for i := 0 to 3 do
      begin
        with FBitmapBuffer.Canvas do
        begin
          TraceTo(50);
          TurnTo(CurAngle);
        end;
      end;
    end;
    2:  // Five points Star
    begin
      FBitmapBuffer.Clear(curColor.Invert);
      FBitmapBuffer.Canvas.MoveTo(FBitmapBuffer.CenterX-100,FBitmapBuffer.CenterY-50);
      for i := 0 to 4 do
      begin
        with FBitmapBuffer.Canvas do
        begin
          TraceTo(200);
          TurnTo(CurAngle);
        end;
      end;
    end;
    3:  // 9 Triangles
    begin
      FBitmapBuffer.Clear(curColor.Invert);
      FBitmapBuffer.Canvas.MoveTo(FBitmapBuffer.CenterX-50,FBitmapBuffer.CenterY-120);
      FBitmapBuffer.Canvas.TraceTo(200);
      for i := 1 to 3 do
      begin
        For j:=0 to 2 do
        begin
          with FBitmapBuffer.Canvas do
          begin
            TurnTo(CurAngle);
            TraceTo(100);
          end;
        end;
        For j:=0 to 2 do
        begin
          with FBitmapBuffer.Canvas do
          begin
            TurnTo(CurAngle);
            TraceTo(100);
          end;
        end;
        FBitmapBuffer.Canvas.TurnTo(120);
      end;
    end;
    4:  // VonCoch
    begin
     FBitmapBuffer.Clear(curColor.Invert);
     for i:= 1 to 8 do
     begin
       FBitmapBuffer.Canvas.MoveTo(FBitmapBuffer.CenterX,FBitmapBuffer.CenterY);
       FBitmapBuffer.Canvas.TurnTo(15+Random(round(curAngle)));
       flocon(2+(i div 2),i*100);
     end;
    end;
    5: // Dragoon
    begin
       FBitmapBuffer.Clear(curColor.Invert);
       FBitmapBuffer.Canvas.MoveTo(FBitmapBuffer.CenterX,FBitmapBuffer.CenterY);
       Dragon(5,7,p,q);
    end;
    6:
    begin
       SquareSpiral;
    end;
  end;

end;

procedure TMainForm.InitScene;
begin

  FCadencer := TBZCadencer.Create(self);
  FCadencer.Enabled := False;
  FCadencer.OnProgress := @CadencerProgress;

  FStopWatch := TBZStopWatch.Create(self);

  Randomize;
  FBitmapBuffer := TBZBitmap.Create;
  FBitmapBuffer.SetSize(ClientWidth,ClientHeight);
  FBitmapBuffer.Clear(clrWhite);
  //FBitmapBuffer.UsePalette := True; // if we uses palette


  // Create Color Map
  InitColorMap;

  FrameCounter:=0;
  IsMouseDown := False;
end;

procedure TMainForm.InitColorMap;
Var i : Integer;
begin
// Init gray Palette 255 color map
  //FBitmapBuffer.ColorManager.CreateGrayPalette;
  //FBitmapBuffer.ColorManager.CreateDefaultPalette;

  for i := 0 to 255 do
  begin
    if i<128 then
      FBitmapBuffer.ColorManager.CreateColor(BZColor(i+64,(i*2) div 4,(i+127)))
    else
      FBitmapBuffer.ColorManager.CreateColor(BZColor(i-32,(i-64) div 2,i div 4));
  end;
  With FBitmapBuffer.Canvas do
  begin
    Antialias := False;
    Pen.Style := ssSolid;
    Pen.Color := clrBlack;
    Pen.Width := 2;
  end;
end;

procedure TMainForm.PauseScene;
begin
  FStopWatch.Stop;
  FCadencer.Enabled:=False;
  FPause := True;
end;

procedure TMainForm.ReStartScene;
begin
  //Framecounter := 0;
  FStopWatch.Start;
  FCadencer.Enabled:=True;
  FPause := False;
end;

procedure TMainForm.StartScene;
begin
  CurAngle := 0;
  //FrameCounter := 0;
  p:=4;
  q:=3;
  ReStartScene;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  DoubleBuffered:=true;
  FStopWatch.Start;
  FCadencer.Enabled := True;
end;

procedure TMainForm.FormKeyPress(Sender : TObject; var Key : char);
begin
  if key = #27 then Close;
  if Key = #32 then
   if FPause then ReStartScene else PauseScene;
  if Key ='0' then
  begin
   PauseScene;
   SpiroMode := 0;
   StartScene;
  end;
  if Key ='1' then
  begin
   PauseScene;
   SpiroMode := 1;
   StartScene;
  end;
  if Key ='2' then
  begin
   PauseScene;
   SpiroMode := 2;
   StartScene;
  end;
  if Key ='3' then
  begin
   PauseScene;
   SpiroMode := 3;
   StartScene;
  end;
  if Key ='4' then
  begin
   PauseScene;
   SpiroMode := 4;
   StartScene;
  end;
  if Key ='5' then
  begin
   PauseScene;
   SpiroMode := 5;
   StartScene;
  end;
  if Key ='6' then
  begin
   PauseScene;
   SpiroMode := 6;
   StartScene;
  end;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FStopWatch);
  FreeAndNil(FCadencer);
  FreeAndNil(FBitmapBuffer);
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FStopWatch.Stop;
  FCadencer.Enabled := False;
  CanClose := True;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  InitScene;
  CurAngle := 0;
  SpiroMode := 0;
  FPause := False;
end;

procedure TMainForm.FormMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button = mbLeft then IsMouseDown := True;
end;

procedure TMainForm.FormMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  IsMouseDown := False;
end;

procedure TMainForm.CadencerProgress(Sender : TObject; const deltaTime, newTime : Double);
Const cSpiroStr: Array[0..6] of String =('Spirale','Square','5-Star','9 Triangles','Vonkoch','Dragon','SpiroSquare');
begin

  RenderScene;
  RenderUI;
  FBitmapBuffer.DrawToCanvas(Canvas, ClientRect);
  //Inc(FrameCounter);

  Caption:='BZScene TurtuleZ Demo : '+Format('%.*f FPS', [3, FStopWatch.getFPS]);
  Caption := Caption +' | '+cSpiroStr[SpiroMode]+' -> Angle : '+FloatToStr(CurAngle);

  if IsMouseDown then CurAngle := CurAngle + 0.0003 else CurAngle := CurAngle + 0.05;
  if (CurAngle >= 360) then
  begin
    if SpiroMode<6 then
    begin
      FStopWatch.Stop;
      CurAngle := 0;
      //FrameCounter:=0;
      inc(SpiroMode);
      FStopWatch.Start;
    end
    else
    begin
      spiroMode := 0;
      CurAngle := 0;
      //FrameCounter:=0;
      PauseScene;
    end;
    if SpiroMode=6 then PauseScene;

  end;
end;



end.

