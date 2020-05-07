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

