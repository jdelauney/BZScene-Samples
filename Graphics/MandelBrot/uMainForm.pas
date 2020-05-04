unit uMainForm;

{$mode objfpc}{$H+}

{.$DEFINE USE_ASM}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  BZVectorMath, BZColors, BZGraphic, BZBitmap, BZParallelThread, BZStopWatch;

type

  { TMandelRender }
  //Julia GLSL Fragment Shader
  //uniform sampler1D tex;
  //uniform vec2 c;
  //uniform int iter;
  //
  //void main() {
  //    vec2 z;
  //    z.x = 3.0 * (gl_TexCoord[0].x - 0.5);
  //    z.y = 2.0 * (gl_TexCoord[0].y - 0.5);
  //
  //    int i;
  //    for(i=0; i<iter; i++) {
  //        float x = (z.x * z.x - z.y * z.y) + c.x;
  //        float y = (z.y * z.x + z.x * z.y) + c.y;
  //
  //        if((x * x + y * y) > 4.0) break;
  //        z.x = x;
  //        z.y = y;
  //    }
  //
  //    gl_FragColor = texture1D(tex, (i == iter ? 0.0 : float(i)) / 100.0);
  //}

  TMandelRender = Class
  private
    {$IFDEF CPU64}
      {$CODEALIGN RECORDMIN=16}
        FStep    : TBZVector2f;
      {$CODEALIGN RECORDMIN=4}
    {$ELSE}
      FStep    : TBZVector2f;
    {$ENDIF}
    FSurface : TBZBitmap;

    FIterLimit : Integer;
    FIterations : Integer;
    FAutoIteration : Boolean;

    FColorMap : Array[0..511] of TBZColor;


    FPMin : Extended;
    FQMin : Extended;
    FPMax : Extended;
    FQMax : Extended;

    FXRangeMin, FYRangeMin : Extended;
    FXRangeMax, FYRangeMax : Extended;

    //FParallelizer : TBZParallelThread;

    Fwidth : Integer;
    Fheight : Integer;
    FMaxWidth, FMaxHeight : Integer;

    procedure Setpmin(Avalue : Extended);
    procedure Setqmin(Avalue : Extended);
    procedure Setpmax(Avalue : Extended);
    procedure Setqmax(Avalue : Extended);
    procedure SetWidth(AValue : Integer);
    procedure SetHeight(AValue : Integer);

    function ComputeOptimalIterations : Integer;

    procedure NextPixel(Sender: TObject; Index: Integer);
    procedure NextLine(Sender: TObject; Index: Integer; Data : Pointer);
    procedure SimpleNextLine(Sender: TObject; Index: Integer; Data : Pointer);

    procedure SetAutoIteration(const AValue : Boolean);
  protected

  public

    GradientStep : Array[0..4] of TBZColor;

    Constructor Create;
    Destructor Destroy; override;

    procedure Reset;
    procedure Init;
    procedure InitColorMap;
    procedure InitRender;
    function ComputePixel(x,y : Integer) : TBZColor;

    procedure NativeComputePixel(sx,sy : Integer);
    procedure NativeComputeLine(sy : Integer);

    procedure Render(Const UseThread : Boolean = True);

    // Look at
    property PMin : Extended read FPmin write SetPMin;
    property QMin : Extended read FQMin write SetQMin;

    // Zoom
    property PMax : Extended read FPMax write SetPMax;
    property QMax : Extended read FQMax write SetQMax;


    property IterLimit : Integer read FIterLimit write FIterLimit;
    property Iterations : Integer read FIterations write FIterations;
    property AutoIteration : Boolean read FAutoIteration write SetAutoIteration;

    property Width : Integer Read FWidth Write SetWidth;
    Property Height : Integer Read FHeight Write SetHeight;

    property Surface : TBZBitmap read FSurface;

  end;

  { TMainForm }

  TMainForm = class(TForm)
    Panel1 : TPanel;
    pnlView : TPanel;
    Button1 : TButton;
    lblTime : TLabel;
    chkUseThread : TCheckBox;
    Label2 : TLabel;
    lblThreadCount : TLabel;
    Shape1 : TShape;
    Button2 : TButton;
    lblIterations : TLabel;
    Label1 : TLabel;
    procedure FormCreate(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure Button1Click(Sender : TObject);

    procedure pnlViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure pnlViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlViewPaint(Sender : TObject);
    procedure Button2Click(Sender : TObject);
  private
    FMandelRender : TMandelRender;
    FStopWatch : TBZStopWatch;
  protected

  public
    mbX, mbY : Integer;
    procedure ComputeMandel;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

Uses Math, BZSystem, BZLogger;

{%region=====[ TMandelRender ]=================================================================================}

constructor TMandelRender.Create;
begin
  inherited Create;
  FWidth := 256;
  FHeight := 256;
  FSurface := TBZBitmap.Create(256,256);
  FMaxWidth := FWidth - 1;
  FMaxHeight := FHeight - 1;
  FAutoIteration := False; //True;
  Init;
end;

destructor TMandelRender.Destroy;
begin
  FreeAndNil(FSurface);
  inherited Destroy;
end;

procedure TMandelRender.Setpmin(Avalue : Extended);
begin
  if Fpmin = Avalue then Exit;
  Fpmin := Avalue;
  InitRender;
end;

procedure TMandelRender.Setqmin(Avalue : Extended);
begin
  if Fqmin = Avalue then Exit;
  Fqmin := Avalue;
  InitRender;
end;

procedure TMandelRender.Setqmax(Avalue : Extended);
begin
  if Fqmax = Avalue then Exit;
  Fqmax := Avalue;
  InitRender;
end;

procedure TMandelRender.Setpmax(Avalue : Extended);
begin
  if Fpmax = Avalue then Exit;
  Fpmax := Avalue;
  InitRender;
end;

procedure TMandelRender.SetHeight(AValue : Integer);
begin
  if FHeight = AValue then Exit;
  FHeight := AValue;
  FSurface.SetSize(FWidth, FHeight);
  FMaxHeight := FHeight - 1;
  InitRender;
end;

procedure TMandelRender.SetWidth(AValue : Integer);
begin
  if FWidth = AValue then Exit;
  FWidth := AValue;
  FSurface.SetSize(FWidth, FHeight);
  FMaxWidth := FWidth - 1;
  InitRender;
end;

procedure TMandelRender.SetAutoIteration(const AValue : Boolean);
begin
  if FAutoIteration = AValue then Exit;
  FAutoIteration := AValue;
  if FAutoIteration then InitRender;
end;

function TMandelRender.ComputeOptimalIterations : Integer;
VAr
   f : Extended;
begin
  FxRangeMin := FPmin-FQmin/2;
  FxRangeMax := FPmin+FQMin/2;
  FyRangeMin := FPmax-FQmax/2;
  FyRangeMax := FPmax+FQmax/2;

  f := System.Sqrt(0.001 +  Math.Min(abs(FPMax - FPMin), abs(FQMax - FQMin)));
 // f := System.Sqrt(0.001 + 2.0 + Math.Min(abs(FxRangeMin - FyRangeMin), abs(FxRangeMax - FyRangeMax)));
  Result := Math.floor(223.0/f);
end;

procedure TMandelRender.Reset;
begin

  FIterLimit := 10;
  FIterations := 50;

  Fqmin := -1.5;
  Fqmax := 1.5;
  Fpmin := -2.25;
  Fpmax := 0.75;

  InitRender;
end;

procedure TMandelRender.Init;
begin
  GradientStep[0].Create($00, $00, $20);
  GradientStep[1].Create($FF, $FF, $FF);
  GradientStep[2].Create($00, $00, $A0);
  GradientStep[3].Create($40, $FF, $FF);
  GradientStep[4].Create($20, $20, $FF);
  InitColorMap;
  Reset;
end;

procedure TMandelRender.InitColorMap;
var
   i, k : Integer;
   rstep, bstep, gstep : Extended;
begin
   FColorMap[0].Create(0,0,0);

  for i := 0 to 2 do
  begin
    rstep := (GradientStep[i+1].Red - GradientStep[i].Red) / 63;
    gstep := (GradientStep[i+1].Green - GradientStep[i].Green) / 63;
    bstep := (GradientStep[i+1].Blue - GradientStep[i].Blue) / 63;

    for k := 0 to 63 do
      FColorMap[k + (i * 64) + 1].Create(Round(GradientStep[i].Red + rstep * k),
                                      Round(GradientStep[i].Green + gstep * k),
                                      Round(GradientStep[i].Blue + bstep * k));
  end;

  for i := 257 to 511 do
    FColorMap[i] := FColorMap[i - 256];
end;

procedure TMandelRender.InitRender;
Var
  {$IFDEF CPU64}
    {$CODEALIGN VARMIN=16}
      BmpDim, pqMax, pqMin : TBZVector2f;
    {$CODEALIGN VARMIN=4}
  {$ELSE}
    BmpDim, pqMax, pqMin : TBZVector2f;
  {$ENDIF}
begin
  BmpDim.Create(FWidth, FHeight);
  pqMax.Create(FPMax, FQMax);
  pqMin.Create(FPMin, FQMin);
  FStep := (pqMax - pqMin) / BmpDim;
  if FAutoIteration then FIterations := ComputeOptimalIterations;
end;

procedure TMandelRender.NextPixel(Sender: TObject; Index: Integer);
begin
  NativeComputePixel(Index mod FWidth, Index div FHeight);
end;

procedure TMandelRender.NextLine(Sender : TObject; Index : Integer; Data : Pointer);
begin
  NativeComputeLine(Index mod FHeight);
end;

procedure TMandelRender.SimpleNextLine(Sender: TObject; Index : Integer; Data : Pointer);
begin
  NativeComputeLine(Index mod FHeight);
end;

function TMandelRender.ComputePixel(x,y : Integer) : TBZColor;
const
   kmax = 256;
var
   //x, y,
   r,xx : Single;
   k : Integer;
  // p, q, x0, y0 : Extended;

  {$IFDEF CPU64}
    {$CODEALIGN VARMIN=16}
      cp, pq, v1,v2, xy : TBZVector2f;
    {$CODEALIGN VARMIN=4}
  {$ELSE}
    cp, pq, v1,v2, xy : TBZVector2f;
  {$ENDIF}

begin
  cp.Create(x,y);
  xy.Create(x,-y);

  pq.Create(FPMin, FQMax);
  pq := pq + (FStep * xy);

  k := 0;
  xy.Create(0,0);

  repeat
    v2 := xy * xy;
    v1.X := v2.X - v2.Y;
    xx := xy.X * xy.Y;
    v1.Y :=  xx + xx;
    cp := v1 + pq;
    xy := cp;
    r := cp.LengthSquare;
    Inc(k);
  until ((r > FiterLimit) or (k >= kmax));

  if k >= Kmax then k := 0;

  Result := FColorMap[k];
  FSurface.setPixel(x,y,FColorMap[k]);
end;

procedure TMandelRender.NativeComputePixel(sx,sy : Integer);
var
   ztr, zti, tr, ti : Single;
   k : Integer;
   p, q, zr, zi : Single;
begin
  p := FPmin + FStep.x * sx;
  q := FQmax - FStep.y * sy;
  k := FIterations;
  zr := 0;
  zi := 0;
  ztr := 0;
  zti := 0;
  repeat
    ztr := zr * zr;
    zti := zi * zi;

    tr := ztr - zti + p;
    ti := zr * zi;
    zi := ti + ti + q;
    zr := tr;

    Dec(k);
  until ((ztr + zti) > FiterLimit) or (k = 0);

  //  // Four more iterations to decrease error term;
  //  // see http://linas.org/art-gallery/escape/escape.html
  //  for n:=0 to 3 do
  //  begin
  //    Zi := 2 * Zr * Zi + Ci;
  //    Zr := Tr - Ti + Cr;
  //    Tr := Zr * Zr;
  //    Ti := Zi * Zi;
  //  end;

  K := FIterations - k;
  //return [n, Tr, Ti];

  FSurface.setPixel(sx,sy,FColorMap[k]);
end;

procedure TMandelRender.NativeComputeLine(sy : Integer);
Const
   cSSE_OPERATOR_NOT_LESS = 5;
Var
  sx : Integer;
  ztr, zti, tr, ti : double;
  k, kIterations : Integer;
  IterationLimit, p, q, zr, zi : double;
  AColor : TBZColor;
begin
  IterationLimit := FIterLimit;
  kIterations := FIterations;
  //GlobalLogger.LogNotice('Start kIterations = ' + kIterations.ToString);
  q := FQmax - FStep.y * sy;
  For sx := 0 to FMaxWidth do
  begin

    //    var color = [0, 0, 0, 255];
    //
    //    for ( var s=0; s<superSamples; ++s ) {
    //      var rx = Math.random()*Cr_step;
    //      var ry = Math.random()*Ci_step;
    //      var p = iterateEquation(Cr - rx/2, Ci - ry/2, escapeRadius, steps);
    //      color = addRGB(color, pickColor(steps, p[0], p[1], p[2]));
    //    }
    //
    //    color = divRGB(color, superSamples);

    p := FPmin + FStep.x * sx;


    {$IFDEF USE_ASM}
    asm
      movq xmm8, [IterationLimit]
      //movq xmm0, [ztr]
      //movq xmm1, [zti]
      movq xmm2, [p]
      movq xmm3, [q]
      //movq xmm4, [zr]
      //movq xmm5, [zi]

      xorpd xmm0, xmm0
      xorpd xmm1, xmm1
      //movq xmm2, [p]    //xorpd xmm2, xmm2
      //movq xmm3, [q]
      xorpd xmm4, xmm4
      xorpd xmm5, xmm5

      mov rcx, [kIterations]
      @LoopStart:
        //tr := ztr - zti + p;
        subpd xmm0,xmm1
        addpd xmm0,xmm2
        //ti := zr * zi;
        mulpd xmm4,xmm5
        //zi := ti + ti + q;
        movq xmm5,xmm4
        addpd xmm5,xmm5
        addpd xmm5,xmm3
        movq xmm1, xmm5
        //zr := tr;
        movq xmm4,xmm0
        //ztr := zr * zr;
        mulpd xmm0,xmm0
        //zti := zi * zi;
        mulpd xmm1,xmm1

        //movq [ztr], xmm0
        //movq [zti], xmm1
          movq xmm6,xmm0
          movq xmm7,xmm1
          addpd xmm6,xmm7
          cmppd xmm6, xmm8, cSSE_OPERATOR_NOT_LESS
          movmskpd eax, xmm6
          xor eax, $FF
          jz @LoopEnd
          or rcx, rcx
          jz @LoopEnd
          dec rcx
          jmp @LoopStart
      @LoopEnd:
        mov [k], rcx

      end;
      {$ELSE}
    k := FIterations;

    zr := 0;
    zi := 0;
    ztr := 0;
    zti := 0;

    While ((ztr + zti) <= FiterLimit) and (k>=0) do
    begin
      tr := ztr - zti + p;
      ti := zr * zi;
      zi := ti + ti + q;
      zr := tr;

      ztr := zr * zr;
      zti := zi * zi;

      Dec(k);
    end;
   {$ENDIF}

//   inc(k);
    K := FIterations - k;
    //return [n, Tr, Ti];

    AColor.Green := (k+k) and 255;
    AColor.Red := (k+k+50) and 255;
    AColor.Blue := ((k+150) and 255);
    AColor.Alpha := 255;

    FSurface.setPixel(sx,sy,AColor);
  end;
    //FSurface.setPixel(sx,sy,FColorMap[k mod 512]);
end;

//double mapToReal(int x, int imageWidth, double minR, double maxR)
//{
//    double range = maxR - minR;
//    return x * (range / imageWidth) + minR;
//}
//
//double mapToImaginary(int y, int imageHeight, double minI, double maxI)
//{
//    double range = maxI - minI;
//    return y * (range / imageHeight) + minI;
//}
//function drawLineSuperSampled(Ci, off, Cr_init, Cr_step)
//{
//  var Cr = Cr_init;
//
//  for ( var x=0; x<canvas.width; ++x, Cr += Cr_step ) {
//    var color = [0, 0, 0, 255];
//
//    for ( var s=0; s<superSamples; ++s ) {
//      var rx = Math.random()*Cr_step;
//      var ry = Math.random()*Ci_step;
//      var p = iterateEquation(Cr - rx/2, Ci - ry/2, escapeRadius, steps);
//      color = addRGB(color, pickColor(steps, p[0], p[1], p[2]));
//    }
//
//    color = divRGB(color, superSamples);
//
//    img.data[off++] = color[0];
//    img.data[off++] = color[1];
//    img.data[off++] = color[2];
//    img.data[off++] = 255;
//  }
//}
//
//function drawLine(Ci, off, Cr_init, Cr_step)
//{
//  var Cr = Cr_init;
//
//  for ( var x=0; x<canvas.width; ++x, Cr += Cr_step ) {
//    var p = iterateEquation(Cr, Ci, escapeRadius, steps);
//    var color = pickColor(steps, p[0], p[1], p[2]);
//    img.data[off++] = color[0];
//    img.data[off++] = color[1];
//    img.data[off++] = color[2];
//    img.data[off++] = 255;
//  }
//}

//// Some constants used with smoothColor
//var logBase = 1.0 / Math.log(2.0);
//var logHalfBase = Math.log(0.5)*logBase;
//function smoothColor(steps, n, Tr, Ti)
//{
//  /*
//   * Original smoothing equation is
//   *
//   * var v = 1 + n - Math.log(Math.log(Math.sqrt(Zr*Zr+Zi*Zi)))/Math.log(2.0);
//   *
//   * but can be simplified using some elementary logarithm rules to
//   */
//  return 5 + n - logHalfBase - Math.log(Math.log(Tr+Ti))*logBase;
//}
//function pickColorHSV3(steps, n, Tr, Ti)
//{
//  if ( n == steps ) // converged?
//    return interiorColor;
//
//  var v = smoothColor(steps, n, Tr, Ti);
//  var c = hsv_to_rgb(360.0*v/steps, 1.0, 10.0*v/steps);
//
//  // swap red and blue
//  var t = c[0];
//  c[0] = c[2];
//  c[2] = t;
//
//  c.push(255); // alpha
//  return c;
//}

procedure TMandelRender.Render(const UseThread : Boolean);
var
  //sx,
  sy : Integer;
begin
  if Not(UseThread) then
  begin
    //for sx := 0 to FSurface.MaxWidth do
    //begin
      for sy := 0 to FSurface.MaxHeight do
      begin
         //NativeComputePixel(sx, sy);
        NativeComputeLine(sy);
      end;
    //end;
  end
  else
  begin
    //ParallelFor(0, FHeight,@NextLine);
    ParallelFor(0, FHeight,@NextLine,nil);
    //FParallelizer := TBZParallelThread.Create;
    //try
    //  //FParallelizer.OnIteration := @NextPixel;
    //  //FParallelizer.Run(FSurface.Size);
    //  FParallelizer.ThreadCount := 8;
    //  FParallelizer.OnProgress := @NextLine;
    //  FParallelizer.Run(FHeight);
    //finally
    //  FParallelizer.Free;
    //end;

  end;
end;

{%endregion%}

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
   FMandelRender := TMandelRender.Create;
   FMandelRender.Width  := 1024;
   FMandelRender.Height := 768;
   FStopWatch := TBZStopWatch.Create(self);
   lblThreadCount.Caption := BZSystem.GetProcessorCount.ToString;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FMandelRender);
  FreeAndNil(FStopWatch);
end;

procedure TMainForm.ComputeMandel;
begin
  FStopWatch.Start();
  lblIterations.Caption := FMandelRender.Iterations.ToString;
  FMandelRender.Render(chkUseThread.Checked);
  lblTime.Caption := 'Time render : ' + FStopWatch.getValueAsMilliSeconds;
  FMandelRender.Surface.DrawToCanvas(pnlView.Canvas, pnlView.ClientRect);
  pnlView.invalidate;
end;


procedure TMainForm.Button1Click(Sender : TObject);
begin
  ComputeMandel;
end;

procedure TMainForm.pnlViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   mbX:=X;
   mbY:=Y;
end;

procedure TMainForm.pnlViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
   s : Integer;
begin
   if ssLeft in Shift then
   begin
      s := Max(X-mbX, Y-mbY);
      if s>0 then
      begin
         Shape1.SetBounds(mbX, mbY, s, s);
         Shape1.Visible:=True;
      end;
   end;
end;

procedure TMainForm.pnlViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
   s : Integer;
   pw, qw : Extended;
begin
   Shape1.Visible:=False;

   s:=Max(X-mbX, Y-mbY);
   if (s>3) then
   begin
      X := mbX + s;
      Y := mbY + s;

      pw := FMandelRender.pmax - FMandelRender.pmin;
      FMandelRender.pmin := FMandelRender.pmin + mbX * pw / FMandelRender.Width;
      FMandelRender.pmax := FMandelRender.pmax - (FMandelRender.Width - X) * pw / FMandelRender.Width;

      qw := FMandelRender.qmax - FMandelRender.qmin;
      FMandelRender.qmin := FMandelRender.qmin + (FMandelRender.Height - Y) * qw / FMandelRender.Height;
      FMandelRender.qmax := FMandelRender.qmax - mbY * qw / FMandelRender.Height;

      ComputeMandel;
   end;
end;

procedure TMainForm.pnlViewPaint(Sender : TObject);
begin
  FMandelRender.Surface.DrawToCanvas(pnlView.Canvas, pnlView.ClientRect);
end;

procedure TMainForm.Button2Click(Sender : TObject);
begin
 FMandelRender.Reset;
 ComputeMandel;
end;


end.

