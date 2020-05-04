unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ExtDlgs, Spin,
  BZGraphic, BZColors, BZBitmap, BZBitmapIO;

type

  { TMainForm }

  TMainForm = class(TForm)
    Panel1 : TPanel;
    btnOpenBmpA : TButton;
    btnOpenBmpB : TButton;
    opd : TOpenPictureDialog;
    GroupBox1 : TGroupBox;
    pnlView : TPanel;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    speOpacity : TSpinEdit;
    sbOpacity : TScrollBar;
    cbxPixelDrawMode : TComboBox;
    cbxCombineDrawMode : TComboBox;
    cbxAlphaDrawMode : TComboBox;
    cbxBlendSrcFactor : TComboBox;
    cbxBlendDstFactor : TComboBox;
    btnSwapAAndB : TButton;
    procedure FormCreate(Sender : TObject);
    procedure sbOpacityChange(Sender : TObject);
    procedure speOpacityChange(Sender : TObject);
    procedure cbxDrawModeChange(Sender : TObject);
    procedure pnlViewPaint(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure btnOpenBmpAClick(Sender : TObject);
    procedure btnOpenBmpBClick(Sender : TObject);
    procedure btnSwapAAndBClick(Sender : TObject);
  private
    BmpSourceA, BmpSourceB, BmpDest : TBZBitmap;
    FUpdateOpacity : Boolean;
  public
    procedure DoFusion;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
Var
  i : Integer;
begin
  For i:=0 to High(cPixelDrawModeStr) do cbxPixelDrawMode.Items.Add(cPixelDrawModeStr[i]);
  cbxPixelDrawMode.ItemIndex := 0;
  For i:=0 to High(cCombineDrawModeStr) do cbxCombineDrawMode.Items.Add(cCombineDrawModeStr[i]);
  cbxCombineDrawMode.ItemIndex := 0;
  For i:=0 to High(cAlphaDrawModeStr) do cbxAlphaDrawMode.Items.Add(cAlphaDrawModeStr[i]);
  cbxAlphaDrawMode.ItemIndex := 0;
  For i:=0 to High(cBlendingFactorStr) do
  begin
    cbxBlendSrcFactor.Items.Add(cBlendingFactorStr[i]);
    cbxBlendDstFactor.Items.Add(cBlendingFactorStr[i]);
  end;
  cbxBlendSrcFactor.ItemIndex := 0;
  cbxBlendDstFactor.ItemIndex := 0;

  BmpSourceA := TBZBitmap.Create;
  BmpSourceA.LoadFromFile('../../media/images/Acropole.jpg');
  BmpSourceB := TBZBitmap.Create;
  BmpSourceB.LoadFromFile('../../media/images/Lazarus_Professional_Logo.tga');
  //BmpSourceB.PreMultiplyAlpha;
  BmpDest := TBZBitmap.Create;
  FUpdateOpacity := False;
end;

procedure TMainForm.sbOpacityChange(Sender : TObject);
begin
  if not(FUpdateOpacity) then
  begin
    // FUpdateOpacity := True;
     speOpacity.Value := sbOpacity.Position;
    // FUpdateOpacity := False;
    DoFusion;
    pnlView.Invalidate
  end;
end;

procedure TMainForm.speOpacityChange(Sender : TObject);
begin
  if not(FUpdateOpacity) then
  begin
    FUpdateOpacity := True;
    sbOpacity.Position := speOpacity.Value;
    FUpdateOpacity := False;
    DoFusion;
    pnlView.Invalidate;
  end;
end;

procedure TMainForm.cbxDrawModeChange(Sender : TObject);
begin
  DoFusion;
  pnlView.Invalidate;
end;

procedure TMainForm.pnlViewPaint(Sender : TObject);
begin
  BmpDest.DrawToCanvas(PnlView.Canvas,PnlView.ClientRect,True,True);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  DoFusion;
  pnlView.Invalidate;
end;

procedure TMainForm.btnOpenBmpAClick(Sender : TObject);
begin
  if opd.Execute then BmpSourceA.LoadFromFile(opd.FileName);
end;

procedure TMainForm.btnOpenBmpBClick(Sender : TObject);
begin
  if opd.Execute then BmpSourceB.LoadFromFile(opd.FileName);
end;

procedure TMainForm.btnSwapAAndBClick(Sender : TObject);
Var
  tmp : TBZBitmap;
begin
  tmp := BmpSourceA.CreateClone;
  BmpSourceA.Assign(BmpSourceB);
  BmpSourceB.Assign(tmp);
  FreeAndNil(tmp);
  DoFusion;
  pnlView.Invalidate;
end;

procedure TMainForm.DoFusion;
var
 cx, cy : Integer;
begin
  BmpSourceA.PreMultiplyAlpha;
  BmpSourceB.PreMultiplyAlpha;
  BmpDest.Assign(BmpSourceA);

  cx := (BmpDest.CenterX - BmpSourceB.CenterX);
  cy := (BmpDest.CenterY - BmpSourceB.CenterY);
  BmpDest.PutImage(BmpSourceB,0,0,BmpSourceB.Width, BmpSourceB.Height,cx,cy,
                   TBZBitmapDrawMode(cbxPixelDrawMode.ItemIndex),
                   TBZBitmapAlphaMode(cbxAlphaDrawMode.ItemIndex),speOpacity.Value,
                   TBZColorCombineMode(cbxCombineDrawMode.ItemIndex),
                   TBZBlendingFactor(cbxBlendSrcFactor.ItemIndex),
                   TBZBlendingFactor(cbxBlendDstFactor.ItemIndex));
end;

end.

