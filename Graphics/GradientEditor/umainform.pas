Unit umainform;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Fileutil, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Spin,
  BZMath, BZColors, BZGraphic, BZBitmap, BZAnimationTool;

Type

  { TMainForm }

  TMainForm = Class(Tform)
    Btnselectcolor : Tbutton;
    Cbxgradientcolorlerp : Tcombobox;
    Cbxgradienttween : Tcombobox;
    Chktweenglobal : Tcheckbox;
    Chktweennext : Tcheckbox;
    ColorDialog : Tcolordialog;
    Edtgradientcolorpos : Tfloatspinedit;
    Edtnewcolorname : Tedit;
    Edttweentime : Tfloatspinedit;
    Label1 : Tlabel;
    Label2 : Tlabel;
    Label3 : Tlabel;
    Label4 : Tlabel;
    Label5 : Tlabel;
    Lbxpalette : Tlistbox;
    Panel6 : Tpanel;
    Panel7 : Tpanel;
    pnlGradientBox : Tpanel;
    Panel2 : Tpanel;
    Panel3 : Tpanel;
    Pnlpalettecolorselected : Tpanel;

    Procedure Btnselectcolorclick(Sender : Tobject);
    Procedure Cbxgradientcolorlerpselect(Sender : Tobject);
    Procedure Cbxgradienttweenselect(Sender : Tobject);
    Procedure Chktweenglobalchange(Sender : Tobject);
    Procedure Chktweennextchange(Sender : Tobject);
    Procedure Edtgradientcolorposchange(Sender : Tobject);
    Procedure Edtgradientcolorposeditingdone(Sender : Tobject);
    Procedure Edtnewcolornameeditingdone(Sender : Tobject);
    Procedure Edttweentimeeditingdone(Sender : Tobject);
    Procedure Formdestroy(Sender : Tobject);
    Procedure Formshow(Sender : Tobject);
    Procedure Lbxpaletteselectionchange(Sender : Tobject; User : Boolean);
    Procedure Pnlgradientboxpaint(Sender : Tobject);
    Procedure edtTweenTimeChange(Sender : TObject);
  Private

  Public
    GradientBmp : TBZBitmap;

    Procedure UpdateGradient;
  End;

Var
  MainForm : TMainForm;

Implementation

{$R *.lfm}


Procedure Tmainform.Btnselectcolorclick(Sender : Tobject);
VAr newCol : TBZColor;
Begin
  if lbxPalette.ItemIndex<0 then
  begin
    Showmessage('Vous devez d''abord sélectionner une couleur dans la liste');
    Exit;
  End;
  if ColorDialog.Execute then
  begin
    pnlPaletteColorSelected.Color:= ColorDialog.Color;
    if lbxPalette.ItemIndex<>-1 then
    begin
      newCol.Create(pnlPaletteColorSelected.Color);
      GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].Value := newCol;
      GradientBmp.ColorManager.Palette.Colors[lbxPalette.ItemIndex].Value:=newCol;
      updateGradient;
    end;
  end;
End;

Procedure Tmainform.Cbxgradientcolorlerpselect(Sender : Tobject);
Begin
  if lbxPalette.ItemIndex<0 then
  begin
    Showmessage('Vous devez d''abord sélectionner une couleur dans la liste');
    Exit;
  End;
  GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].LerpType := TBZInterpolationType(Cbxgradientcolorlerp.ItemIndex);
  UpdateGradient;
End;

Procedure Tmainform.Cbxgradienttweenselect(Sender : Tobject);
Begin
  if lbxPalette.ItemIndex<0 then
  begin
    Showmessage('Vous devez d''abord sélectionner une couleur dans la liste');
    Exit;
  End;
  GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].EaseType := TBZAnimationType(cbxGradientTween.ItemIndex);
  UpdateGradient;
End;

Procedure Tmainform.Chktweenglobalchange(Sender : Tobject);
Begin
  GradientBmp.ColorManager.GradientColors.TweenGlobal := chkTweenGlobal.Checked;
  UpdateGradient;
End;

Procedure Tmainform.Chktweennextchange(Sender : Tobject);
Begin
  GradientBmp.ColorManager.GradientColors.TweenNext := chkTweenNext.Checked;
  UpdateGradient;
End;

Procedure Tmainform.Edtgradientcolorposchange(Sender : Tobject);
Begin
  if lbxPalette.ItemIndex<0 then
  begin
    Showmessage('Vous devez d''abord sélectionner une couleur dans la liste');
    Exit;
  End;
  GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].Theta := edtGradientColorPos.Value;
  UpdateGradient;
End;

Procedure Tmainform.Edtgradientcolorposeditingdone(Sender : Tobject);
Begin
  if lbxPalette.ItemIndex<0 then
  begin
    Showmessage('Vous devez d''abord sélectionner une couleur dans la liste');
    Exit;
  End;
  GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].Theta := edtGradientColorPos.Value;
  UpdateGradient;
End;

Procedure Tmainform.Edtnewcolornameeditingdone(Sender : Tobject);
Begin
  if lbxPalette.ItemIndex<0 then
  begin
    Showmessage('Vous devez d''abord sélectionner une couleur dans la liste');
    Exit;
  End;
  GradientBmp.ColorManager.Palette.Colors[lbxPalette.ItemIndex].Name := edtNewColorName.Text;
  UpdateGradient;
End;

Procedure Tmainform.Edttweentimeeditingdone(Sender : Tobject);
Begin
  GradientBmp.ColorManager.GradientColors.TweenDuration := edtTweenTime.Value;
  UpdateGradient;
End;

Procedure Tmainform.Formdestroy(Sender : Tobject);
Begin
  FreeAndNil(GradientBmp);
End;

Procedure Tmainform.Formshow(Sender : Tobject);
Var
  x,y:Integer;
  delta : Single;
begin
  GradientBmp:=TBZBitmap.Create(pnlGradientBox.ClientWidth,pnlGradientBox.ClientHeight);
  x:=1;
  With GradientBmp.ColorManager do
  begin
    CreateColor('Color#1',BZColor($00,$00,$00,$FF));
    CreateColor('Color#2',BZColor($7E,$00,$FF,$FF));
    CreateColor('Color#3',BZColor($E8,$7A,$FF,$FF));
    CreateColor('Color#4',BZColor($7E,$00,$FF,$FF));
    CreateColor('Color#5',BZColor($FF,$FF,$FF,$FF));
    CreateColor('Color#6',BZColor($00,$00,$00,$FF));
    CreateColor('Color#7',BZColor($05,$00,$A8,$FF));
    CreateColor('Color#8',BZColor($BE,$FF,$39,$FF));
    CreateColor('Color#9',BZColor($FF,$C9,$39,$FF));
    CreateColor('Color#10',BZColor($FF,$F5,$8D,$FF));
    CreateColor('Color#11',BZColor($FF,$FF,$FF,$FF));
  end;
  Delta := 1.0 / GradientBmp.ColorManager.ColorCount;
  for x:=0 to GradientBmp.ColorManager.ColorCount-1 do
  begin
    lbxPalette.Items.Add(GradientBmp.ColorManager.Palette.Colors[X].Name);
    GradientBmp.ColorManager.CreateGradientColor(GradientBmp.ColorManager.Palette.Colors[X].Value, x*Delta, amInOut, atLinear, itLinear);
  end;

  UpdateGradient;
End;

Procedure Tmainform.Lbxpaletteselectionchange(Sender : Tobject; User : Boolean);
Begin
  pnlPaletteColorSelected.Color:=GradientBmp.ColorManager.Palette.Colors[lbxPalette.ItemIndex].Value.AsColor;
  pnlPaletteColorSelected.Refresh;
  edtNewColorName.Text:= GradientBmp.ColorManager.Palette.Colors[lbxPalette.ItemIndex].Name;
  cbxGradientTween.ItemIndex:=ord(GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].EaseType);
  cbxGradientColorLerp.ItemIndex:=ord(GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].LerpType);
  edtGradientColorPos.Value:=GradientBmp.ColorManager.GradientColors.ColorStops[lbxPalette.ItemIndex].Theta;
End;

Procedure Tmainform.Pnlgradientboxpaint(Sender : Tobject);
Begin
  GradientBmp.DrawToCanvas(pnlGradientBox.Canvas,pnlGradientBox.ClientRect,True);
End;

Procedure TMainForm.edtTweenTimeChange(Sender : TObject);
Begin
  GradientBmp.ColorManager.GradientColors.TweenDuration := edtTweenTime.Value;
  UpdateGradient;
end;

procedure TMainForm.UpdateGradient;
var
  x,y : integer;
begin
 // GradientBmp.ColorManager.MakeGradientPalette(GradientBmp.Width);
  y:=GradientBmp.MaxHeight;
  GradientBmp.Clear(clrRed);
  For x:=0 to GradientBmp.MaxWidth do
  begin
    With GradientBmp.Canvas do
    begin
      //Pen.Color := GradientBmp.ColorManager.GradientPalette.Colors[X].Value;
      Pen.Color :=GradientBmp.ColorManager.GetGradientColor(x/GradientBmp.MaxWidth);
      Line(x,0,x,y);
    End;
  end;

  pnlGradientBox.Invalidate;

end;


End.

