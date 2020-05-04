unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  BZAnimationTool;

const
 cDefaultDuration = 100;
 cEnd = 200;

type

  { TMainForm }

  TMainForm = class(TForm)
    Panel1 : TPanel;
    Label1 : TLabel;
    tbWait : TTrackBar;
    pnlLeft : TPanel;
    Splitter1 : TSplitter;
    pnlRight : TPanel;
    btnLinear : TButton;
    btnQuadIn : TButton;
    btnCubicIn : TButton;
    btnQuartIn : TButton;
    btnQuintIn : TButton;
    btnSinIn : TButton;
    btnCircleIn : TButton;
    btnExpoIn : TButton;
    btnElasticIn : TButton;
    btnBackIn : TButton;
    btnBounceIn : TButton;
    btnBounceOut : TButton;
    btnBackOut : TButton;
    btnElasticOut : TButton;
    btnExpoOut : TButton;
    btnCircleOut : TButton;
    btnSinOut : TButton;
    btnQuintOut : TButton;
    btnQuartOut : TButton;
    btnCubicOut : TButton;
    btnQuadOut : TButton;
    btnSineTransform : TButton;
    btnQuadInOut : TButton;
    btnCubicInOut : TButton;
    btnQuartInOut : TButton;
    btnQuintInOut : TButton;
    btnSinInOut : TButton;
    btnCircleInOut : TButton;
    btnExpoInOut : TButton;
    btnElasticInOut : TButton;
    btnBackInOut : TButton;
    btnBounceInOut : TButton;
    btnQuadOutIn : TButton;
    btnCubicOutIn : TButton;
    btnQuartOutIn : TButton;
    btnQuintOutIn : TButton;
    btnSinOutIn : TButton;
    btnCircleOutIn : TButton;
    btnExpoOutIn : TButton;
    btnElasticOutIn : TButton;
    btnBackOutIn : TButton;
    btnBounceOutIn : TButton;
    btnSineCycle : TButton;
    btnSineSymCycle : TButton;
    btnTardis : TButton;
    procedure btnLinearClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure tbWaitChange(Sender : TObject);
    procedure btnQuadOutClick(Sender : TObject);
    procedure btnQuadInOutClick(Sender : TObject);
    procedure btnQuadOutInClick(Sender : TObject);
    procedure btnTardisClick(Sender : TObject);
    procedure btnSineTransformClick(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
  private
    FDuration : Integer;
    FAnimationController : TBZAnimationTool;
  public
    function ComputeInterpolation(AStart, AEnd, AStep: Single; AMode : TBZAnimationMode; AInter: TBZAnimationType; ABack: Boolean): Single;
    function ComputeInterpolationInt(AStart, AEnd, AStep: Integer; AMode : TBZAnimationMode; AInter: TBZAnimationType; ABack: Boolean): Integer;

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses BZMath;

{ TMainForm }

procedure TMainForm.btnLinearClick(Sender : TObject);
var
  Li, LWidth, LWidth2, LStart: Integer;
  LBack: Boolean;
begin
  tbWait.Enabled := False;
  LWidth := pnlLeft.Width - btnLinear.Width;
  FAnimationController.EndValue := LWidth;
  FAnimationController.StartValue := btnLinear.Tag;
  for LBack := False to True do
    for Li := 1 to FDuration do
    begin
      btnLinear.Left := ComputeInterpolationInt(btnLinear.Tag, LWidth, Li, amIn, atLinear, LBack);
      btnQuadIn.Left := ComputeInterpolationInt(btnQuadIn.Tag, LWidth, Li, amIn, atQuadratic, LBack);
      btnCubicIn.Left := ComputeInterpolationInt(btnCubicIn.Tag, LWidth, Li, amIn, atCubic, LBack);
      btnQuartIn.Left := ComputeInterpolationInt(btnQuartIn.Tag, LWidth, Li, amIn, atQuartic, LBack);
      btnQuintIn.Left := ComputeInterpolationInt(btnQuintIn.Tag, LWidth, Li, amIn, atQuintic, LBack);
      btnSinIn.Left := ComputeInterpolationInt(btnSinIn.Tag, LWidth, Li, amIn, atSine, LBack);
      btnCircleIn.Left := ComputeInterpolationInt(btnCircleIn.Tag, LWidth, Li, amIn, atCircle, LBack);
      btnExpoIn.Left := ComputeInterpolationInt(btnExpoIn.Tag, LWidth, Li, amIn, atExponantial, LBack);
      btnElasticIn.Left := ComputeInterpolationInt(btnElasticIn.Tag, LWidth, Li, amIn, atElastic, LBack);
      btnBackIn.Left := ComputeInterpolationInt(btnBackIn.Tag, LWidth, Li, amIn, atBack, LBack);
      btnBounceIn.Left := ComputeInterpolationInt(btnBounceIn.Tag, LWidth, Li, amIn, atBounce, LBack);
      sleep(10);
      Repaint;
      Application.ProcessMessages;
    end;
  tbWait.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FAnimationController := TBZAnimationTool.Create;
  FDuration := cDefaultDuration;
  tbWait.Max := cEnd;
  tbWait.Position := FDuration;
  FAnimationController.Duration := FDuration;
end;

procedure TMainForm.tbWaitChange(Sender : TObject);
begin
  FDuration := tbWait.Position;
  FAnimationController.Duration := FDuration;
end;

procedure TMainForm.btnQuadOutClick(Sender : TObject);
var
  Li, LWidth, LWidth2, LStart: Integer;
  LBack: Boolean;
begin
  tbWait.Enabled := False;
  LWidth := pnlLeft.Width - btnLinear.Width;
  FAnimationController.EndValue := LWidth;
  FAnimationController.StartValue := btnQuadOut.Tag;
  for LBack := False to True do
    for Li := 1 to FDuration do
    begin
      btnQuadOut.Left := ComputeInterpolationInt(btnQuadOut.Tag, LWidth, Li, amOut, atQuadratic, LBack);
      btnCubicOut.Left := ComputeInterpolationInt(btnCubicOut.Tag, LWidth, Li, amOut, atCubic, LBack);
      btnQuartOut.Left := ComputeInterpolationInt(btnQuartOut.Tag, LWidth, Li, amOut, atQuartic, LBack);
      btnQuintOut.Left := ComputeInterpolationInt(btnQuintOut.Tag, LWidth, Li, amOut, atQuintic, LBack);
      btnSinOut.Left := ComputeInterpolationInt(btnSinOut.Tag, LWidth, Li, amOut, atSine, LBack);
      btnCircleOut.Left := ComputeInterpolationInt(btnCircleOut.Tag, LWidth, Li, amOut, atCircle, LBack);
      btnExpoOut.Left := ComputeInterpolationInt(btnExpoOut.Tag, LWidth, Li, amOut, atExponantial, LBack);
      btnElasticOut.Left := ComputeInterpolationInt(btnElasticOut.Tag, LWidth, Li, amOut, atElastic, LBack);
      btnBackOut.Left := ComputeInterpolationInt(btnBackOut.Tag, LWidth, Li, amOut, atBack, LBack);
      btnBounceOut.Left := ComputeInterpolationInt(btnBounceOut.Tag, LWidth, Li, amOut, atBounce, LBack);
      sleep(10);
      Repaint;
      Application.ProcessMessages;
    end;
  tbWait.Enabled := True;
end;

procedure TMainForm.btnQuadInOutClick(Sender : TObject);
var
  Li, LWidth, LWidth2, LStart: Integer;
  LBack: Boolean;
begin
  tbWait.Enabled := False;
  LWidth := pnlLeft.Width - btnQuadInOut.Width;
  FAnimationController.EndValue := LWidth;
  FAnimationController.StartValue := btnQuadInOut.Tag;
  for LBack := False to True do
    for Li := 1 to FDuration do
    begin
      btnQuadInOut.Left := ComputeInterpolationInt(btnQuadInOut.Tag, LWidth, Li, amInOut, atQuadratic, LBack);
      btnCubicInOut.Left := ComputeInterpolationInt(btnCubicInOut.Tag, LWidth, Li, amInOut, atCubic, LBack);
      btnQuartInOut.Left := ComputeInterpolationInt(btnQuartInOut.Tag, LWidth, Li, amInOut, atQuartic, LBack);
      btnQuintInOut.Left := ComputeInterpolationInt(btnQuintInOut.Tag, LWidth, Li, amInOut, atQuintic, LBack);
      btnSinInOut.Left := ComputeInterpolationInt(btnSinInOut.Tag, LWidth, Li, amInOut, atSine, LBack);
      btnCircleInOut.Left := ComputeInterpolationInt(btnCircleInOut.Tag, LWidth, Li, amInOut, atCircle, LBack);
      btnExpoInOut.Left := ComputeInterpolationInt(btnExpoInOut.Tag, LWidth, Li, amInOut, atExponantial, LBack);
      btnElasticInOut.Left := ComputeInterpolationInt(btnElasticInOut.Tag, LWidth, Li, amInOut, atElastic, LBack);
      btnBackInOut.Left := ComputeInterpolationInt(btnBackInOut.Tag, LWidth, Li, amInOut, atBack, LBack);
      btnBounceInOut.Left := ComputeInterpolationInt(btnBounceInOut.Tag, LWidth, Li, amInOut, atBounce, LBack);
      sleep(10);
      Repaint;
      Application.ProcessMessages;
    end;
  tbWait.Enabled := True;
end;

procedure TMainForm.btnQuadOutInClick(Sender : TObject);
var
  Li, LWidth : Integer;
  LBack: Boolean;
begin
  tbWait.Enabled := False;
  LWidth := pnlLeft.Width - btnQuadOutIn.Width;
  FAnimationController.EndValue := LWidth;
  FAnimationController.StartValue := btnQuadOutIn.Tag;
  for LBack := False to True do
    for Li := 1 to FDuration do
    begin
      btnQuadOutIn.Left := ComputeInterpolationInt(btnQuadOutIn.Tag, LWidth, Li, amOutIn, atQuadratic, LBack);
      btnCubicOutIn.Left := ComputeInterpolationInt(btnCubicOutIn.Tag, LWidth, Li, amOutIn, atCubic, LBack);
      btnQuartOutIn.Left := ComputeInterpolationInt(btnQuartOutIn.Tag, LWidth, Li, amOutIn, atQuartic, LBack);
      btnQuintOutIn.Left := ComputeInterpolationInt(btnQuIntOutIn.Tag, LWidth, Li, amOutIn, atQuintic, LBack);
      btnSinOutIn.Left := ComputeInterpolationInt(btnSinOutIn.Tag, LWidth, Li, amOutIn, atSine, LBack);
      btnCircleOutIn.Left := ComputeInterpolationInt(btnCircleOutIn.Tag, LWidth, Li, amOutIn, atCircle, LBack);
      btnExpoOutIn.Left := ComputeInterpolationInt(btnExpoOutIn.Tag, LWidth, Li, amOutIn, atExponantial, LBack);
      btnElasticOutIn.Left := ComputeInterpolationInt(btnElasticOutIn.Tag, LWidth, Li, amOutIn, atElastic, LBack);
      btnBackOutIn.Left := ComputeInterpolationInt(btnBackOutIn.Tag, LWidth, Li, amOutIn, atBack, LBack);
      btnBounceOutIn.Left := ComputeInterpolationInt(btnBounceOutIn.Tag, LWidth, Li, amOutIn, atBounce, LBack);
      sleep(10);
      Repaint;
      Application.ProcessMessages;
    end;
  tbWait.Enabled := True;
end;

procedure TMainForm.btnTardisClick(Sender : TObject);
var
  Li, LWidth : Integer;
  LBack: Boolean;
begin
  tbWait.Enabled := False;
  LWidth := pnlLeft.Width - btnLinear.Width;
  for LBack := False to True do
    for Li := 1 to FDuration do
    begin
      btnTardis.Left := ComputeInterpolationInt(btnTardis.Tag, LWidth, Li, amIn, atTardis, LBack);
      sleep(10);
      Repaint;
      Application.ProcessMessages;
    end;
  tbWait.Enabled := True;
end;

procedure TMainForm.btnSineTransformClick(Sender : TObject);
var
  Li, LWidth : Integer;
  LBack: Boolean;
begin
  tbWait.Enabled := False;
  LWidth := pnlLeft.Width - btnLinear.Width;
  for LBack := False to True do
    for Li := 1 to FDuration do
    begin
      //btnSineTransform.Left := ComputeInterpolationInt(btnSineTransform.Tag, LWidth, Li, etSineTransform, LBack);
      //btnSineCycle.Left := ComputeInterpolationInt(btnSineTransform.Tag, LWidth, Li, etSineCycle, LBack);
      //btnSineSymCycle.Left := ComputeInterpolationInt(btnSineTransform.Tag, LWidth, Li, etSineSymCycle, LBack);
      sleep(10);
      Repaint;
      Application.ProcessMessages;
    end;
  tbWait.Enabled := True;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FAnimationController);
end;

function TMainForm.ComputeInterpolation(AStart, AEnd, AStep : Single; AMode : TBZAnimationMode; AInter : TBZAnimationType; ABack : Boolean) : Single;
begin
  //Result := Tweener(AStart, AEnd, AStep, FDuration, AInter);
  //if ABack then Result := AStart + AEnd - Result;
  FAnimationController.AnimationMode := AMode;
  FAnimationController.AnimationType := AInter;
  Result := FAnimationController.Animate(AStep,ABack);

end;

function TMainForm.ComputeInterpolationInt(AStart, AEnd, AStep : Integer; AMode : TBZAnimationMode; AInter : TBZAnimationType; ABack : Boolean) : Integer;
begin
  FAnimationController.AnimationMode := AMode;
  FAnimationController.AnimationType := AInter;
  Result := FAnimationController.AnimateInt(AStep,ABack);
end;

end.

