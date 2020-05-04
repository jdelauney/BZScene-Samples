unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin,
  BZColors, BZVectorMath, BZGraphic, BZBitmap, Math, BZAnimationTool;

const
  cGraphBottomOrigin = 210;
  cGraphTopOrigin = 70;
  //cGraphMaxHeight = 260;
  cGraphOriginX = 10;
  cGraphMaxWidth = 240;
  cGraphMaxHeight = 140;
  cGraphMaxX = 250;
  cDefaultDuration = 30;
  cEnd = 200;

type
  TBZParametricFunc1D = function(t:Single) : Single;
  TBZParametricFunc1DTest = function(t:Single) : Single of object;
  TBZParametricAddonFunc =  function(t : Single; aFunc : TBZParametricFunc1D; param1, param2 : Integer) : TBZParametricFunc1DTest of object;
  TBZEaseMode = (emIn, emInInverted,
                 emOut, emOutInverted,
                 emInOut, emOutIn,
                 emSpike, emSpikeInverted,
                 emArch, emArchInverted,
                 emCombined, emCombinedInverted,
                 emSnakeIn, emSnakeInInverted,
                 emSnakeOut, emSnakeOutInverted);

  TBZEaseType = (etLinear, etQuadratic, etCubic, etQuartic, etQuintic, etExponantial, etSine, etCircle, etElastic, etBack, etBounce, etBell);

type

  { TMainForm }
  TMainForm = class(TForm)
    GroupBox1 : TGroupBox;
    pnlGraphView : TPanel;
    GroupBox2 : TGroupBox;
    GroupBox3 : TGroupBox;
    Label1 : TLabel;
    cbxEaseFunction : TComboBox;
    Label2 : TLabel;
    cbxEaseMode : TComboBox;
    Panel1 : TPanel;
    Panel2 : TPanel;
    pnlEaseOutIn : TPanel;
    Panel3 : TPanel;
    Panel4 : TPanel;
    pnlEaseInOut : TPanel;
    Panel5 : TPanel;
    Panel6 : TPanel;
    pnlEaseOut : TPanel;
    Panel7 : TPanel;
    Panel8 : TPanel;
    pnlEaseIn3 : TPanel;
    ShapeEaseSpikeInverted : TShape;
    ShapeEaseOut : TShape;
    ShapeEaseInOut : TShape;
    ShapeEaseOutIn : TShape;
    GroupBox4 : TGroupBox;
    Label3 : TLabel;
    tbWait : TTrackBar;
    Button1 : TButton;
    Panel9 : TPanel;
    Panel10 : TPanel;
    pnlEaseOutIn1 : TPanel;
    ShapeEaseOutInverted : TShape;
    Panel11 : TPanel;
    Panel12 : TPanel;
    pnlEaseInOut1 : TPanel;
    ShapeEaseArchInverted : TShape;
    Panel13 : TPanel;
    Panel14 : TPanel;
    pnlEaseOut1 : TPanel;
    ShapeEaseInInverted : TShape;
    Panel15 : TPanel;
    Panel16 : TPanel;
    pnlEaseIn4 : TPanel;
    ShapeEaseSpike : TShape;
    Panel17 : TPanel;
    Panel18 : TPanel;
    pnlEaseOutIn2 : TPanel;
    ShapeEaseCombinedInverted : TShape;
    Panel19 : TPanel;
    Panel20 : TPanel;
    pnlEaseInOut2 : TPanel;
    ShapeEaseArch : TShape;
    Panel21 : TPanel;
    Panel22 : TPanel;
    pnlEaseOut2 : TPanel;
    ShapeEaseCombined : TShape;
    Panel23 : TPanel;
    Panel24 : TPanel;
    pnlEaseIn5 : TPanel;
    ShapeEaseIn : TShape;
    chkInterpolate : TCheckBox;
    cbxInterpolationFilter : TComboBox;
    cbxClamp : TComboBox;
    Label4 : TLabel;
    chkShowComposite : TCheckBox;
    chkPingPong : TCheckBox;
    btnReinitAnim : TButton;
    gbxExtraParams : TGroupBox;
    pcParams : TPageControl;
    tsExtraParam1 : TTabSheet;
    lblExtraParam1 : TLabel;
    fseExtraParam1 : TFloatSpinEdit;
    procedure pnlGraphViewPaint(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure cbxEaseFunctionSelect(Sender : TObject);
    procedure chkShowCompositeClick(Sender : TObject);
    procedure Button1Click(Sender : TObject);
    procedure tbWaitChange(Sender : TObject);
    procedure btnReinitAnimClick(Sender : TObject);
    procedure chkInterpolateClick(Sender : TObject);
    procedure cbxClampSelect(Sender : TObject);
    procedure cbxInterpolationFilterSelect(Sender : TObject);
    procedure fseExtraParam1EditingDone(Sender : TObject);
  private
    FGraphBmp : TBZBitmap;
    FDuration : Integer;
    FAnimStart, FAnimEnd : Integer;
    FAnimationController : TBZAnimationTool;

    procedure DrawGraphBackground;
    procedure DrawEaseCurve;
    procedure DrawCompositeCurve;

    procedure RenderGraph;

    function ComputeInterpolationInt(AStep: Integer; AMode : TBZAnimationMode; AInter: TBZAnimationType; ABack: Boolean): Integer;

  public
    procedure Animate;


  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses BZMath, BZInterpolationFilters;

{%region%=====[ Easing functions ]======================================================================}
{
function EaseFlip(t : Single) : Single; inline;
begin
  result := 1.0 - t;
end;

{ Exemple un personnage de jeu à une vitesse (in) d'attaque entre 4 et 12 et les dommages infligés (out) entre 1 et 4 }
function easeRemap(t, inStart, inEnd, outStart, outEnd : Single; EaseFunc : TBZParametricFunc1D) : Single; inline;
var
  v : Single;
begin
  v := t - inStart;
  v := v / (inEnd - inStart);
  v := EaseFunc(v);
  v := v * (outEnd - outStart);
  Result := v + outStart;
end;

function EaseMix(EaseFuncStart, EaseFuncStop : TBZParametricFunc1D; t, Blend : Single) : Single; inline;
Var
  a, b : Single;
begin
  a := EaseFuncStart(t);
  b := EaseFuncStop(t);
  Result := a + Blend * (b - a);
end;

function EaseCrossFade(EaseFuncStart, EaseFuncStop : TBZParametricFunc1D; t : Single) : Single; inline;
begin
  result := EaseMix(EaseFuncStart, EaseFuncStop, t, t);
end;

function EaseScale(EaseFunc : TBZParametricFunc1D; t : Single) : Single; inline;
begin
  Result := t * EaseFunc(t);
end;

function EaseReverseScale(EaseFunc : TBZParametricFunc1D; t : Single) : Single; inline;
begin
  Result := (1.0 - t) * EaseFunc(t);
end;

function EaseArch(t : Single) : Single; inline;
begin
  // Result := EaseScale(EaseFlip,t));
  Result := t * (1.0 - t);
end;

function EaseBounceClampBottom(t : Single) : Single; inline;
begin
  Result := abs(t);
end;

function EaseBounceClampTop(t : Single) : Single; inline;
begin
  Result := 1.0 - abs(1.0 - t);
end;

function EaseBounceClampBottomTop(t : Single) : Single; inline;
begin
  Result := EaseBounceClampTop(EaseBounceClampBottom(t));
end;

function easeSmoothStep(t : Single) : Single; inline;
begin
  Result := (t * t * (3 - 2 * t));
end;

function easeSmootherStep(t : Single) : Single; inline;
begin
  Result := (t * t * t * (t * (t * 6 - 15) + 10));
end;

{ Où t est la valeur actuelle,
  WeightFactor est la valeur vers laquelle nous voulons aller
  SlowDownFactor est le facteur de ralentissement. Plus SlowDownFactor est élevé, plus v se rapproche lentement de WeightFactor. }
function easeWeightedAverage(t, SlowDownFactor, WeightFactor : Single) : Single; inline;
begin
  Result := ((t * (SlowDownFactor - 1.0)) + WeightFactor) / SlowDownFactor;
end;

// Cubic 3rd Bezier (A,B,C,D) ou A (1er point) = 0 et D (Dernier point) = 1.0
function EaseNormalizedCubicBezier( CoefB, CoefC, t : Single) : Single; inline;
Var
  s, t2, s2, t3 : Single;
begin
  s := 1.0 - t;
  t2 := t * t;
  s2 := s * s;
  t3 := t2 * t;
  Result := (3.0 * CoefB * s2 * t) + (3.0 * CoefC * s * t2) + t3;
end;

function EaseNormalizedBezier7( CoefB, CoefC, CoefD, CoefE, CoefF, CoefG, t : Single) : Single; inline;
Var
  s,
  t2, s2,
  t3, s3,
  t4, s4,
  t5, s5,
  t6, s6,
  t7 : Single;
begin
  s := 1.0 - t;
  t2 := t * t;
  s2 := s * s;
  t3 := t2 * t;
  s3 := s2 * s;
  t4 := t2 * t2;
  s4 := s2 * s2;
  t5 := t3 * t2;
  s5 := s3 * s2;
  t6 := t3 * t3;
  s6 := s3 * s3;
  t7 := t3 * t2 * t2;

  Result := ( 7.0 * CoefB * s6 * t ) +
            (21.0 * CoefC * s5 * t2) +
            (35.0 * CoefD * s4 * t3) +
            (35.0 * CoefE * s3 * t4) +
            (21.0 * CoefF * s2 * t5) +
            ( 7.0 * CoefG * s  * t6) + t7;
end;


function EaseCustomTween(rangeStart, rangeEnd : Single; EaseFuncValue : Single) : Single;
Var
  x : Single;
begin
  x := (rangeEnd - rangeStart) * Clamp(EaseFuncValue, -1.0, 1.0);
  Result := rangeStart + x;
end;

function easeSmoothLinear(t : Single) : Single; inline;
begin
  result := t;
end;

function easeSmoothStartQuadratic(t : Single) : Single; inline;
begin
  result := t * t;
end;

function easeSmoothStopQuadratic(t : Single) : Single; inline;
//var
//  x : single;
begin
  //x := 1.0 - t;
  //result := 1.0 - (x * x);
  Result := t * (2.0 - t);
end;

function easeSmoothStartCubic(t : Single) : Single; inline;
begin
  result := t * t * t;
end;

function easeSmoothStopCubic(t : Single) : Single; inline;
var
  x : single;
begin
  x :=  1.0 - t;
  result := 1.0 - (x * x * x);
end;

function easeSmoothStartQuartic(t : Single) : Single; inline;
begin
  result := t * t * t * t;
end;

function easeSmoothStopQuartic(t : Single) : Single; inline;
var
  x : single;
begin
  x := 1.0 - t;
  result := 1.0 - (x * x * x * x);
end;

function easeSmoothStartQuintic(t : Single) : Single; inline;
begin
  result := t * t * t * t * t;
end;

function easeSmoothStopQuintic(t : Single) : Single; inline;
var
  x : single;
begin
  x := 1.0 - t;
  result := 1.0 - (x * x * x * x * x);
end;

function easeSmoothStartExponantial(t : Single) : Single; inline;
begin
  if t = 0.0 then result := 0.0
  else result := Math.Power(2, 10 * (t - 1));
end;

function easeSmoothStopExponantial(t : Single) : Single; inline;
begin
  if t = 1.0 then result := 1.0
  else
    result := 1.0 - Math.Power(2, -10.0 * t);
end;

function easeSmoothStartSine(t : Single) : Single; inline;
begin
  //Result := Sin((t - 1.0) * cPiDiv2) + 1.0;
  //Result := 1 - cos((t * cPI) * 0.5);
  Result := 1 - cos(t * cPiDiv2);
end;

function easeSmoothStopSine(t : Single) : Single; inline;
begin
  Result := Sin(t * cPiDiv2);
  //return sin((x * PI) / 2);
end;




function easeSmoothStartCircle(t : Single) : Single; inline;
begin
  Result := 1.0 - Sqrt(1.0 - (t * t));
end;

function easeSmoothStopCircle(t : Single) : Single; inline;
begin
  Result := Sqrt((2.0 - t) * t);
end;

function easeSmoothStartElastic(t : Single) : Single; inline;
begin
  Result := Sin(13.0 * cPiDiv2 * t) * Math.Power(2.0, 10.0 * (t - 1.0));
end;

function easeSmoothStopElastic(t : Single) : Single; inline;
begin
  Result := Sin(-13.0 * cPiDiv2 * (t + 1.0)) * Math.Power(2.0, -10.0 * t) + 1.0;
// p := 0.3;
// return Math.pow(2,-10*t) * Math.sin((t-p/4)*(2*Math.PI)/p) + 1;
end;

function easeSmoothStartBack(t : Single) : Single; inline;
begin
  //Result := EaseFunc(t) - t * Sin(t * cPI);
  // Cubic
  Result := t * t * t - t * Sin(t * cPI);
end;

function easeSmoothStopBack(t : Single) : Single; inline;
Var
  f : Single;
begin
  f := 1.0 - t;
  //Result := 1.0 - (EaseFunc(f) - f * Sin(f * cPI));
  Result := 1.0 - (f * f * f - f * Sin(f * cPI));
end;

function easeSmoothStartBounce(t : Single) : Single; inline;
Const
  cFactorA = 0.363636; // 4.0 / 11.0
  cFactorB = 0.727272; // 8.0 / 11.0
  cFactorC = 3.4; // 17 / 5
  cFactorD = 0.9; // 9.0 / 10.0
  cFactorE = 8.898060; // 16061.0/1805.0
  cFactorF = 10.72; // 268.0 / 25.0
begin
  if (t < cFactorA) then
  begin
    Result := (121 * t * t) / 16.0;
  end
  else if (t < cFactorB) then
  begin
  	Result := (363/40.0 * t * t) - (99.0 / 10.0 * t) + cFactorC;
  end
  else if (t < cFactorD) then
  begin
  	Result := (4356/361.0 * t * t) - (35442/1805.0 * t) + cFactorE;
  end
  else
  begin
    Result :=  (54/5.0 * t * t) - (513/25.0 * t) + cFactorF;
  end;
end;

function easeSmoothStopBounce(t : Single) : Single; inline;
begin
  Result := 1.0 - easeSmoothStartBounce(1.0 - t);
end;

{ ????(t) = EaseSmoothStopXXX(EaseSmoothStartXXX(t)), etc...}
function EaseSmoothStartBell(t : Single) : Single; inline;
begin
  Result := (1.0 - EaseSmoothStartCubic(1.0 - t)) * EaseSmoothStartCubic(t);
end;

function EaseSmoothStopBell(t : Single) : Single; inline;
begin
  Result := 1.0 - EaseSmoothStartBell(1.0 - t);
end;


function GetEaseSmoothStartFunc(EaseType : TBZEaseType) : TBZParametricFunc1D;
begin
  Case EaseType of
    etLinear :  Result := @EaseSmoothLinear;
    etQuadratic :  Result := @EaseSmoothStartQuadratic;
    etCubic :  Result := @EaseSmoothStartCubic;
    etQuartic :  Result := @EaseSmoothStartQuartic;
    etQuintic :  Result := @EaseSmoothStartQuintic;
    etExponantial :  Result := @EaseSmoothStartExponantial;
    etSine :  Result := @EaseSmoothStartSine;
    etCircle :  Result := @EaseSmoothStartCircle;
    etElastic :  Result := @EaseSmoothStartElastic;
    etBack :  Result := @EaseSmoothStartBack;
    etBounce :  Result := @EaseSmoothStartBounce;
    etBell :  Result := @EaseSmoothStartBell
    else Result := @EaseSmoothLinear;
  end;
end;

function GetEaseSmoothStopFunc(EaseType : TBZEaseType) : TBZParametricFunc1D;
begin
  Case EaseType of
    etLinear :  Result := @EaseSmoothLinear;
    etQuadratic :  Result := @EaseSmoothStopQuadratic;
    etCubic :  Result := @EaseSmoothStopCubic;
    etQuartic :  Result := @EaseSmoothStopQuartic;
    etQuintic :  Result := @EaseSmoothStopQuintic;
    etExponantial :  Result := @EaseSmoothStopExponantial;
    etSine :  Result := @EaseSmoothStopSine;
    etCircle :  Result := @EaseSmoothStopCircle;
    etElastic :  Result := @EaseSmoothStopElastic;
    etBack :  Result := @EaseSmoothStopBack;
    etBounce :  Result := @EaseSmoothStopBounce;
    etBell :  Result := @EaseSmoothStopBell
    else Result := @EaseSmoothLinear;
  end;
end;

procedure GetEaseSmoothStartStopFunc(EaseType : TBZAnimationType; out EaseInFunc, EaseOutFunc : TBZParametricFunc1D);
begin
  Case EaseType of
    etLinear :
    begin
      EaseInFunc := @EaseSmoothLinear;
      EaseOutFunc := @EaseSmoothLinear;
    end;
    etQuadratic :
    begin
      EaseInFunc := @EaseSmoothStartQuadratic;
      EaseOutFunc := @EaseSmoothStopQuadratic;
    end;
    etCubic :
    begin
      EaseInFunc := @EaseSmoothStartCubic;
      EaseOutFunc := @EaseSmoothStopCubic;
    end;
    etQuartic :
    begin
      EaseInFunc := @EaseSmoothStartQuartic;
      EaseOutFunc := @EaseSmoothStopQuartic;
    end;
    etQuintic :
    begin
      EaseInFunc := @EaseSmoothStartQuintic;
      EaseOutFunc := @EaseSmoothStopQuintic;
    end;
    etExponantial :
    begin
      EaseInFunc := @EaseSmoothStartExponantial;
      EaseOutFunc := @EaseSmoothStopExponantial;
    end;
    etSine :
    begin
      EaseInFunc := @EaseSmoothStartSine;
      EaseOutFunc := @EaseSmoothStopSine;
    end;
    etCircle :
    begin
      EaseInFunc := @EaseSmoothStartCircle;
      EaseOutFunc := @EaseSmoothStopCircle;
    end;
    etElastic :
    begin
      EaseInFunc := @EaseSmoothStartElastic;
      EaseOutFunc := @EaseSmoothStopElastic;
    end;
    etBack :
    begin
      EaseInFunc := @EaseSmoothStartBack;
      EaseOutFunc := @EaseSmoothStopBack;
    end;
    etBounce :
    begin
      EaseInFunc := @EaseSmoothStartBounce;
      EaseOutFunc := @EaseSmoothStopBounce;
    end;
    etBell :
    begin
      EaseInFunc := @EaseSmoothStartBell;
      EaseOutFunc := @EaseSmoothStopBell;
    end
    else
    begin
      EaseInFunc := @EaseSmoothLinear;
      EaseOutFunc := @EaseSmoothLinear;
    end
  end;
end;

function EaseIn(EaseType : TBZAnimationType; t : Single) : Single;
Var
  EaseInFunc : TBZParametricFunc1D;
begin
  EaseInFunc := GetEaseSmoothStartFunc(EaseType);
  Result := EaseInFunc(t);
end;

function EaseOut(EaseType : TBZAnimationType; t : Single) : Single;
Var
  EaseOutFunc : TBZParametricFunc1D;
begin
  EaseOutFunc := GetEaseSmoothStopFunc(EaseType);
  Result := EaseOutFunc(t);
end;

function EaseInOut(EaseType : TBZAnimationType; t : Single) : Single;
Var
  EaseInFunc : TBZParametricFunc1D;
  x : Single;
begin
  EaseInFunc := GetEaseSmoothStartFunc(EaseType);
  if (t < 0.5) then
  begin
    Result := EaseInFunc(t + t) * 0.5
  end
  else
  begin
    x := 1.0 - t;
    x := x + x; //x * 2.0
    Result := 1.0 - EaseInFunc(x) * 0.5;
  end;
end;

function EaseOutIn(EaseType : TBZAnimationType; t : Single) : Single;
var
  EaseOutFunc : TBZParametricFunc1D;
  //EaseInFunc : TBZParametricFunc1D;
  x : Single;
begin
  EaseOutFunc := GetEaseSmoothStopFunc(EaseType);
  //EaseInFunc := GetEaseSmoothStartFunc(EaseType);
  if (t < 0.5) then
  begin
    Result := EaseOutFunc(t + t) * 0.5
  end
  else
  begin
    x := 1.0 - t;
    x := x + x; //x * 2.0
    Result := 1.0 - EaseOutFunc(x) * 0.5;
  end;
  //Result := EaseMix(EaseOutFunc, EaseInFunc, t, t );
end;

function Ease(EaseMode : TBZEaseMode; EaseType : TBZAnimationType; t : Single) : Single;
var
  v : Single;
begin
  Case EaseMode of
    emIn          : Result := EaseIn(EaseType, t);
    emInInverted  : Result := EaseIn(EaseType, 1.0 - t);
    emOut         : Result := 1.0 - EaseIn(EaseType, 1.0 - t);
    emOutInverted : Result := 1.0 - EaseIn(EaseType, t);
    emInOut:
    begin
      if (t < 0.5) then
      begin
        v := t + t;
        Result := EaseIn(EaseType, v) * 0.5;
      end
      else
      begin
        v := 1.0 - t;
        v := v + v; //x * 2.0
        Result := 1.0 - EaseIn(EaseType, v) * 0.5;
      end;
    end;
    emOutIn:
    begin
      if (t < 0.5) then
      begin
        v := t + t;
        v := 1.0 - v;
        Result := (1.0 - EaseIn(EaseType, v)) * 0.5;
      end
      else
      begin
        v := 1.0 - t;
        v := v + v; //x * 2.0
        v := 1.0 - v;
        Result :=  1.0 - ( (1.0 - EaseIn(EaseType, v) ) * 0.5);


       // Result := 1.0 - EaseOutFunc(x) * 0.5;
      end;
    end;
    emSpike       :  // Spike
    begin
      if t < 0.5 then
      begin
        v := t / 0.5;
        //Result := EaseInOut(EaseType, t);
      end
      else
      begin
        v := 1 - ((t - 0.5) / 0.5);
      end;
      Result := EaseIn(EaseType, v);
    end;
    emSpikeInverted :
    begin
      if t < 0.5 then
      begin
        //Result := EaseInOut(EaseType, t);
         v := t / 0.5;
      end
      else
      begin
        v := 1.0 - ((t - 0.5) / 0.5);
      end;
      Result := 1.0 - EaseIn(EaseType, v);
    end;
    emArch :
    begin
      if t < 0.5 then
      begin
        //Result := EaseInOut(EaseType, t);
         v := t / 0.5;
      end
      else
      begin
        v := 1.0 - ((t - 0.5) / 0.5);
      end;
      Result := 1.0 - EaseIn(EaseType, 1.0 - v);
    end;
    emArchInverted : //Result := EaseOutIn(EaseType, t);  //ArchInverted
    begin
      if t < 0.5 then
      begin
        //Result := EaseInOut(EaseType, t);
         v := t / 0.5;
      end
      else
      begin
        v := 1.0 - ((t - 0.5) / 0.5);
      end;
      Result := EaseIn(EaseType, 1.0 - v);
    end;
    emCombined :
    begin
      if t < 0.5 then
      begin
        //Result := EaseInOut(EaseType, t);
         v := t / 0.5;
         Result := EaseIn(EaseType, v);
      end
      else
      begin
        v := (t - 0.5) / 0.5;
        Result := 1.0 - EaseIn(EaseType, v);
      end;
    end;
    emCombinedInverted :
    begin
      if t < 0.5 then
      begin
        //Result := EaseInOut(EaseType, t);
         v := 1.0 - (t / 0.5);
         Result := EaseIn(EaseType, v);
      end
      else
      begin
        v := 1.0 - ((t - 0.5) / 0.5);
        Result := 1.0 - EaseIn(EaseType, v);
      end;
    end;
  end;
end;

function EaseTween(Current, Duration, rangeStart, rangeEnd : Single; EaseMode : TBZEaseMode; EaseType : TBZAnimationType) : Single;
Var
   t , x : Single;
begin
  t := Current / Duration;
  x := (rangeEnd - rangeStart) * Ease(EaseMode, EaseType, t);
  Result := rangeStart + x;
end;

float catmullrom(float t, float p0, float p1, float p2, float p3)
{
return 0.5f * (
              (2 * p1) +
              (-p0 + p2) * t +
              (2 * p0 - 5 * p1 + 4 * p2 - p3) * t * t +
              (-p0 + 3 * p1 - 3 * p2 + p3) * t * t * t
              );
}

for (i = 0; i < N; i++)
{
  v = i / N;
  v = catmullrom(v, Q, 0, 1, T);
  X = (A * v) + (B * (1 - v));
}


}



{%endregion%}

procedure TMainForm.pnlGraphViewPaint(Sender : TObject);
begin
  RenderGraph;
  FGraphBmp.DrawToCanvas(pnlGraphView.Canvas, pnlGraphView.ClientRect);
end;

procedure TMainForm.FormCreate(Sender : TObject);
var
  tsl : TStringList;
begin
  FGraphBmp := TBZBitmap.Create(400, 280);
  FAnimationController := TBZAnimationTool.Create;
  FAnimStart := 4 + ((pnlEaseOutIn.Width - 8) div 2) - (ShapeEaseIn.Width div 2) ;

  ShapeEaseIn.Left := FAnimStart;
  ShapeEaseInInverted.Left := FAnimStart;
  ShapeEaseOut.Left := FAnimStart;
  ShapeEaseOutInverted.Left := FAnimStart;
  ShapeEaseInOut.Left := FAnimStart;
  ShapeEaseOutIn.Left := FAnimStart;
  ShapeEaseSpike.Left := FAnimStart;
  ShapeEaseSpikeInverted.Left := FAnimStart;
  ShapeEaseArch.Left := FAnimStart;
  ShapeEaseArchInverted.Left := FAnimStart;
  ShapeEaseCombined.Left := FAnimStart;
  ShapeEaseCombinedInverted.Left := FAnimStart;

  FAnimEnd := (pnlEaseOutIn.Width - 4) - ShapeEaseSpikeInverted.Width;

  FDuration := cDefaultDuration;
  tbWait.Max := cEnd;
  tbWait.Position := FDuration;

  FAnimationController.StartValue := FAnimStart;
  FAnimationController.EndValue := FAnimEnd;
  FAnimationController.Duration := FDuration;
  tsl := TStringList.Create;
  GetBZInterpolationFilters.BuildStringList(tsl);
  cbxInterpolationFilter.Items.Text := tsl.Text;
  FreeAndNil(tsl);
  cbxInterpolationFilter.ItemIndex := 0;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FAnimationController);
  FreeAndNil(FGraphBmp);
end;

procedure TMainForm.cbxEaseFunctionSelect(Sender : TObject);
Var
  HasExtraParams : Boolean;
begin
  HasExtraParams := (cbxEaseFunction.ItemIndex = 12) or (cbxEaseFunction.ItemIndex = 13);
  gbxExtraParams.Enabled := HasExtraParams;
  if HasExtraParams then
  begin
    Case cbxEaseFunction.ItemIndex of
      12 :
      begin
        tsExtraParam1.Caption := 'Power';
        lblExtraParam1.Caption := 'Exposant : ';
        fseExtraParam1.Value := 3.6;
        pcParams.ActivePage := tsExtraParam1;
      end;
      13 :
      begin
        tsExtraParam1.Caption := 'Step';
        lblExtraParam1.Caption := 'Etapes : ';
        fseExtraParam1.Value := 5.0;
        pcParams.ActivePage := tsExtraParam1;
      end;
    end;
  end;
  pnlGraphView.Invalidate;
end;

procedure TMainForm.chkShowCompositeClick(Sender : TObject);
begin
  cbxEaseMode.Enabled := not(chkShowComposite.Checked);
  pnlGraphView.Invalidate;
end;

procedure TMainForm.Button1Click(Sender : TObject);
begin
  Animate;
end;

procedure TMainForm.tbWaitChange(Sender : TObject);
begin
  FDuration := tbWait.Position;
  FAnimationController.Duration := FDuration;
end;

procedure TMainForm.btnReinitAnimClick(Sender : TObject);
begin
  ShapeEaseIn.Left := FAnimStart;
  ShapeEaseInInverted.Left := FAnimStart;
  ShapeEaseOut.Left := FAnimStart;
  ShapeEaseOutInverted.Left := FAnimStart;
  ShapeEaseInOut.Left := FAnimStart;
  ShapeEaseOutIn.Left := FAnimStart;
  ShapeEaseSpike.Left := FAnimStart;
  ShapeEaseSpikeInverted.Left := FAnimStart;
  ShapeEaseArch.Left := FAnimStart;
  ShapeEaseArchInverted.Left := FAnimStart;
  ShapeEaseCombined.Left := FAnimStart;
  ShapeEaseCombinedInverted.Left := FAnimStart;
end;

procedure TMainForm.chkInterpolateClick(Sender : TObject);
begin
  FAnimationController.Interpolate := chkInterpolate.Checked;
  pnlGraphView.Invalidate;
end;

procedure TMainForm.cbxClampSelect(Sender : TObject);
begin
  FAnimationController.ClampMode := TBZAnimationClampMode(cbxClamp.ItemIndex);
  pnlGraphView.Invalidate;
end;

procedure TMainForm.cbxInterpolationFilterSelect(Sender : TObject);
begin
  FAnimationController.InterpolationFilter := TBZInterpolationFilterMethod(cbxInterpolationFilter.ItemIndex);
  pnlGraphView.Invalidate;
end;

procedure TMainForm.fseExtraParam1EditingDone(Sender : TObject);
begin
  pnlGraphView.Invalidate;
end;

{ TMainForm }
procedure TMainForm.DrawGraphBackground;
begin
  with FGraphBmp.Canvas do
  begin
    Pen.Color := clrWhite;
    Pen.Width := 1;
    //MoveTo(cGraphOriginX, cGraphTopOrigin);
    //LineTo(cGraphOriginX, cGraphBottomOrigin);
    //LineTo(cGraphOriginX + cGraphMaxWidth, cGraphBottomOrigin);
    Rectangle(cGraphOriginX, cGraphTopOrigin, cGraphOriginX + cGraphMaxWidth, cGraphBottomOrigin);
  end;
end;

procedure TMainForm.DrawEaseCurve;
var
  x,y : Integer;
  t : Single;
  v : Single;
  AColor : TBZColor;
  //AMode : TBZEaseMode;
  AMode : TBZAnimationMode;
begin
  //AMode := TBZEaseMode(cbxEaseMode.itemIndex);
  AMode := TBZAnimationMode(cbxEaseMode.itemIndex);
  Case AMode of
    amIn: AColor := clrBlue;
    amInInverted: AColor := clrNavy;
    amOut: AColor := clrRed;
    amOutInverted: AColor := clrMaroon;
    amInOut: AColor := clrFuchsia;
    amOutIn: AColor := clrPurple;
    amSpike: AColor := clrTeal;
    amSpikeInverted: AColor := clrAqua;
    amArch: AColor := clrYellow;
    amArchInverted: AColor := clrOlive;
    amSpikeAndArch: AColor := clrLime;
    amSpikeAndArchInverted: AColor := clrGreen;
    amArchAndSpike : AColor := clrWhite;
  end;

  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(AMode, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(AMode, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    //v := EaseArch(EaseIn(TBZAnimationType(cbxEaseFunction.ItemIndex), t));
    //v := EaseReverseScale(@EaseArch, t);
    //Case cbxEaseFunction.ItemIndex of
    //  0 : v := easeSmoothStartLinear(t);
    //  1 : v := easeSmoothStopLinear(t);
    //  2 : v := easeSmoothStartStopLinear(t);
    //  3 : v := easeSmoothStopStartLinear(t);
    //end;

    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );

    FGraphBmp.setPixel(cGraphOriginX + x,y, AColor);
  end;

end;

procedure TMainForm.DrawCompositeCurve;
var
  x,y : Integer;
  t : Single;
  v : Single;
begin

  // In
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    //v := Ease(emIn, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amIn, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amIn, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;

    //EaseIn(TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrBlue);
  end;

  // In Inverted
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amInInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amInInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrNavy);
  end;

  // Out
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amOut, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amOut, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrRed);
  end;

  // Out Inverted
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amOutInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amOutInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrMaroon);
  end;

  // InOut
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amInOut, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amInOut, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrGreen);
  end;

  // OutIn
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amOutIn, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amOutIn, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrFuchsia);
  end;

  // Spike
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amSpike, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amSpike, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrTeal);
  end;

  // Spike Inverted
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amSpikeInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amSpikeInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrAqua);
  end;

  // Arch
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amArch, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amArch, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrYellow);
  end;

  // Arch Inverted
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrOlive);
  end;

  // Combined
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amSpikeAndArch, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amSpikeAndArch, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrLime);
  end;

  // Combined Inverted
  For x :=  0 to cGraphMaxWidth do
  begin
    t := x / cGraphMaxWidth;
    Case cbxEaseFunction.ItemIndex of
      12, 13 : v := FAnimationController.Ease(amSpikeAndArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t, fseExtraParam1.Value);
      else
        v := FAnimationController.Ease(amSpikeAndArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), t);
    end;
    y := cGraphBottomOrigin - Round(v * cGraphMaxHeight );
    FGraphBmp.setPixel(cGraphOriginX + x,y,clrGreen);
  end;

end;

procedure TMainForm.RenderGraph;
begin
  FGraphBmp.Clear(clrBlack);
  DrawGraphBackground;
  if chkShowComposite.Checked then DrawCompositeCurve
  else DrawEaseCurve;
end;

function TMainForm.ComputeInterpolationInt(AStep : Integer; AMode : TBZAnimationMode; AInter : TBZAnimationType; ABack : Boolean) : Integer;
begin
 FAnimationController.AnimationMode := AMode;
 FAnimationController.AnimationType := AInter;
 if AInter = atPower then
 begin
   Result := FAnimationController.AnimateInt(AStep,fseExtraParam1.Value,ABack);
 end
 else Result := FAnimationController.AnimateInt(AStep,ABack);
end;

procedure TMainForm.Animate;
var
  Li : Integer;
  LBack: Boolean;
  AMode : TBZAnimationMode;
begin
  tbWait.Enabled := False;
  LBack := False;
  if chkShowComposite.Checked then
  begin
    if chkPingPong.checked then
    begin
      for LBack := False to True do
      begin
        for Li := 1 to FDuration do
        begin
          ShapeEaseIn.Left := ComputeInterpolationInt( Li, amIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseInInverted.Left := ComputeInterpolationInt( Li, amInInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseOut.Left := ComputeInterpolationInt( Li, amOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseOutInverted.Left := ComputeInterpolationInt( Li, amOutInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseInOut.Left := ComputeInterpolationInt( Li, amInOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseOutIn.Left := ComputeInterpolationInt( Li, amOutIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseSpike.Left := ComputeInterpolationInt( Li, amSpike, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseSpikeInverted.Left := ComputeInterpolationInt( Li, amSpikeInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseArch.Left := ComputeInterpolationInt( Li, amArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseArchInverted.Left := ComputeInterpolationInt( Li, amArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseCombined.Left := ComputeInterpolationInt( Li, amSpikeAndArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          ShapeEaseCombinedInverted.Left := ComputeInterpolationInt( Li, amSpikeAndArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          //sleep(10);
          Repaint;
          Application.ProcessMessages;
        end;
      end;
    end
    else
    begin
      for Li := 1 to FDuration do
      begin
        ShapeEaseIn.Left := ComputeInterpolationInt( Li, amIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseInInverted.Left := ComputeInterpolationInt( Li, amInInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseOut.Left := ComputeInterpolationInt( Li, amOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseOutInverted.Left := ComputeInterpolationInt( Li, amOutInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseInOut.Left := ComputeInterpolationInt( Li, amInOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseOutIn.Left := ComputeInterpolationInt( Li, amOutIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseSpike.Left := ComputeInterpolationInt( Li, amSpike, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseSpikeInverted.Left := ComputeInterpolationInt( Li, amSpikeInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseArch.Left := ComputeInterpolationInt( Li, amArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseArchInverted.Left := ComputeInterpolationInt( Li, amArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseCombined.Left := ComputeInterpolationInt( Li, amSpikeAndArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        ShapeEaseCombinedInverted.Left := ComputeInterpolationInt( Li, amSpikeAndArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
        //sleep(10);
        Repaint;
        Application.ProcessMessages;
      end;
    end;
  end
  else
  begin
    AMode := TBZAnimationMode(cbxEaseMode.ItemIndex);
    if chkPingPong.Checked then
    begin
      for LBack := False to True do
      begin
        for Li := 1 to FDuration do
        begin
          Case AMode of
            amIn: ShapeEaseIn.Left := ComputeInterpolationInt( Li, amIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amInInverted: ShapeEaseInInverted.Left := ComputeInterpolationInt( Li, amInInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amOut: ShapeEaseOut.Left := ComputeInterpolationInt( Li, amOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amOutInverted: ShapeEaseOutInverted.Left := ComputeInterpolationInt( Li, amOutInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amInOut: ShapeEaseInOut.Left := ComputeInterpolationInt( Li, amInOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amOutIn: ShapeEaseOutIn.Left := ComputeInterpolationInt( Li, amOutIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amSpike: ShapeEaseSpike.Left := ComputeInterpolationInt( Li, amSpike, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amSpikeInverted: ShapeEaseSpikeInverted.Left := ComputeInterpolationInt( Li, amSpikeInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amArch: ShapeEaseArch.Left := ComputeInterpolationInt( Li, amArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amArchInverted: ShapeEaseArchInverted.Left := ComputeInterpolationInt( Li, amArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amSpikeAndArch: ShapeEaseCombined.Left := ComputeInterpolationInt( Li, amSpikeAndArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
            amSpikeAndArchInverted: ShapeEaseCombinedInverted.Left := ComputeInterpolationInt( Li, amSpikeAndArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack) ;
          end;
          Repaint;
          Application.ProcessMessages;
        end;
      end;
    end
    else
    begin
      for Li := 1 to FDuration do
      begin
        Case AMode of
          amIn: ShapeEaseIn.Left := ComputeInterpolationInt( Li, amIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amInInverted: ShapeEaseInInverted.Left := ComputeInterpolationInt( Li, amInInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amOut: ShapeEaseOut.Left := ComputeInterpolationInt( Li, amOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amOutInverted: ShapeEaseOutInverted.Left := ComputeInterpolationInt( Li, amOutInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amInOut: ShapeEaseInOut.Left := ComputeInterpolationInt( Li, amInOut, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amOutIn: ShapeEaseOutIn.Left := ComputeInterpolationInt( Li, amOutIn, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amSpike: ShapeEaseSpike.Left := ComputeInterpolationInt( Li, amSpike, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amSpikeInverted: ShapeEaseSpikeInverted.Left := ComputeInterpolationInt( Li, amSpikeInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amArch: ShapeEaseArch.Left := ComputeInterpolationInt( Li, amArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amArchInverted: ShapeEaseArchInverted.Left := ComputeInterpolationInt( Li, amArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amSpikeAndArch: ShapeEaseCombined.Left := ComputeInterpolationInt( Li, amSpikeAndArch, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack);
          amSpikeAndArchInverted: ShapeEaseCombinedInverted.Left := ComputeInterpolationInt( Li, amSpikeAndArchInverted, TBZAnimationType(cbxEaseFunction.ItemIndex), LBack) ;
        end;
        Repaint;
        Application.ProcessMessages;
      end;
    end;
  end;
  tbWait.Enabled := True;
end;







end.

