unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Buttons, Spin,
  BZVectorMath, BZColors, BZGraphic, BZBitmap, BZNoiseGenerator;

type

  { TForm1 }

  TForm1 = class(TForm)
    Panel1 : TPanel;
    pnlView : TPanel;
    Panel3 : TPanel;
    Button1 : TButton;
    Memo1 : TMemo;
    Label1 : TLabel;
    edtSeed : TEdit;
    Label2 : TLabel;
    fseFrequency : TFloatSpinEdit;
    btnGenSeed : TSpeedButton;
    Label3 : TLabel;
    cbxSmoothFilter : TComboBox;
    chkSmoothNoise : TCheckBox;
    Label4 : TLabel;
    cbxBaseNoise : TComboBox;
    Label5 : TLabel;
    cbxNoiseInterpolation : TComboBox;
    ScrollBar1 : TScrollBar;
    Label6: TLabel;
    cbxNoiseType: TComboBox;
    Label7: TLabel;
    cbxFractalType: TComboBox;
    Label8: TLabel;
    fsePersistence: TFloatSpinEdit;
    Label9: TLabel;
    fseAmplitude: TFloatSpinEdit;
    Label10: TLabel;
    speOctave: TSpinEdit;
    procedure Button1Click(Sender : TObject);
    procedure pnlViewPaint(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnGenSeedClick(Sender : TObject);
    procedure ScrollBar1Change(Sender : TObject);
  private
    bmp : TBZBitmap;
  public

  end;

var
  Form1 : TForm1;

implementation

{$R *.lfm}

uses BZMath, BZInterpolationFilters, BZTypesHelpers;
{ TForm1 }

procedure TForm1.Button1Click(Sender : TObject);
var
  //ng : TBZNoiseGenerator;

  //ng : TBZValueNoiseGenerator;
  //ng : TBZGradientNoiseGenerator;
  //ng : TBZImprovedPerlinNoiseGenerator;
  //ng : TBZSimplexNoiseGenerator;
  //ng : TBZOpenSimplexNoiseGenerator;

  ng : TBZCustomFractalNoiseGenerator;

  i, x,y : Integer;
  n, PertubAmp, PertubFreq, Freq, Amplitude, maxValue, PertubBias, k,l,vx,vy : Double;
  r,g,b: Byte;
begin
  //ng := TBZGradientNoiseGenerator.Create;
  //ng := TBZNoiseGenerator.Create;

  //ng := TBZValueNoiseGenerator.Create;

  //ng := TBZImprovedPerlinNoiseGenerator.Create;
  //ng := TBZSimplexNoiseGenerator.Create;
  //ng := TBZOpenSimplexNoiseGenerator.Create;
  ng := TBZCustomFractalNoiseGenerator.Create;

  Case cbxBaseNoise.ItemIndex of
    0 : ng.NoiseGenerator.RandomNoiseGenerator := ngtWhite;
    1 : ng.NoiseGenerator.RandomNoiseGenerator := ngtAdditiveGaussian;
  end;

  ng.Seed := StrToInt(edtSeed.Text);
  ng.Frequency := fseFrequency.Value;

 // PertubAmp := 12;
  //PertubBias := 64;
  //PertubFreq := ng.Frequency;
  Amplitude := 1.0;

  Case cbxNoiseInterpolation.ItemIndex of
    0,1 : ng.NoiseGenerator.NoiseInterpolation := nitLinear;
    2   : ng.NoiseGenerator.NoiseInterpolation := nitCosine;
    3   : ng.NoiseGenerator.NoiseInterpolation := nitCubic;
  end;

  ng.NoiseGenerator.Smooth := chkSmoothNoise.Checked;
  ng.NoiseGenerator.SmoothInterpolation := GetBZInterpolationFilters.getFilterByIndex(cbxSmoothFilter.ItemIndex); //ifmHermit; //
  ng.NoiseType := TBZNoiseType(cbxNoiseType.ItemIndex);
  ng.Amplitude := fseAmplitude.Value;
  ng.Lacunarity := fsePersistence.Value;

  ng.Octaves := speOctave.Value;

//  Label4.Caption := TBZInterpolationFilterRec(GetBZInterpolationFilters.Items[cbxSmoothFilter.ItemIndex]).Name;
  bmp.Clear(clrBlack);
  for y:=1 to 512 do
  begin
    //Memo1.Lines.Add('----- '+Inttostr(y));
    //l:= Cos(cPi*(y)/PertubBias)*PertubAmp+(y-1);
    //vy := y;
    For x := 1 to 512 do
    begin
      //k:= Sin(cPi*(x)/PertubBias)*PertubAmp+(x-1);
      //vx := x;
      //
      ////n := (0.5 + ng.GetNoise(x,y) * 0.5) ;
      //n:=0;
      //Amplitude := 1.0;
      //Freq := PertubFreq ;
      //MaxValue := 0;
      ////vx := vx + k;
      ////vy := vy + l;
      //for i := 0 to 3 do
      //begin
      //
      //  ng.Frequency := Freq;
      //  n := n + ng.GetNoise(vx ,vy) * Amplitude; // 0, c2PI * ScrollBar1.Position / 100 )
      //  MaxValue := MaxValue + Amplitude;
      //  //ng.Seed := ng.Seed + 1;
      //  Freq := Freq * 2;
      //  Amplitude := Amplitude * 1.2;
      //  //vx := vx * 2;
      //  //vy := vy * 2;
      //
      //end;
      //n := n / MaxValue;
      n := ng.GetNoise(x - 256 ,y - 256);
      //n := RangeMap(n,-4,4,0,255);
      n := RangeMap(n,-1,1,0,255);
      //n := n + RangeMap(ng.GetNoise(x+k ,y+l, 0, c2PI * ScrollBar1.Position / 100 ),-1.0,1.0,0,255);
      r := Round(n);
      g := Round(n);
      b := Round(n);
      //r := ClampByte(Round((n*255)));
      //g := ClampByte(Round((n*255)));
      //b := ClampByte(Round((n*255)));
      bmp.setPixel((x-1),(y-1), BZColor(r,g,b));
    end;
  end;
  pnlView.Invalidate;
  FreeAndNil(ng);
end;

procedure TForm1.pnlViewPaint(Sender : TObject);
begin
  Bmp.DrawToCanvas(PnlView.Canvas,PnlView.ClientRect,True,True);
end;

procedure TForm1.FormCreate(Sender : TObject);
Var
  sl : TStringList;
begin
  sl := TStringList.Create;
  bmp := TBZBitmap.Create(512,512);
  bmp.Clear(clrBlack);
  GetBZInterpolationFilters.BuildStringList(sl);
  cbxSmoothFilter.Items := sl;
  cbxSmoothFilter.ItemIndex := 8;
  FreeAndNil(sl);
end;

procedure TForm1.FormDestroy(Sender : TObject);
begin
  FreeAndNil(Bmp);
end;

procedure TForm1.btnGenSeedClick(Sender : TObject);
Var
  i : Integer;
begin
  i := 1;
  edtSeed.Text := I.Random.ToString;
end;

procedure TForm1.ScrollBar1Change(Sender : TObject);
begin
  Button1Click(self);
end;

end.

