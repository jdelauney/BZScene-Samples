unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, LCLType, LclIntf, ExtCtrls, StdCtrls, Types,
  BZKeyboard;

type
   TVirtualKeyCode = Integer;

const
   // pseudo wheel keys (we squat F23/F24), see KeyboardNotifyWheelMoved
   VK_MOUSEWHEELUP   = VK_F23;
   VK_MOUSEWHEELDOWN = VK_F24;


type

  { TForm1 }

  TForm1 = class(TForm)
    Timer1: TTimer;
    Panel1 : Tpanel;
    Label2 : Tlabel;
    Label1 : Tlabel;
    Label3 : Tlabel;
    Label4 : Tlabel;
    pnlLeft : Tpanel;
    pnlRight : Tpanel;
    Panel2 : Tpanel;
    Shape1 : Tshape;
    procedure Timer1Timer(Sender: TObject);
    Procedure Formmousewheel(Sender : Tobject; Shift : Tshiftstate; Wheeldelta : Integer; Mousepos : Tpoint; Var Handled : Boolean);
    procedure PnlChooseKeyClick(Sender: TObject);
    Procedure Formclose(Sender : Tobject; Var Closeaction : Tcloseaction);
    Procedure Formshow(Sender : Tobject);
  private

  public

  end;

type
  TDirection = (dirLeft, dirRight, dirNone);

var
  Form1: TForm1;
  Direction: TDirection = dirNone;

var
   vLastWheelDelta : Integer;

implementation

{$R *.lfm}
Uses
{$IFDEF MSWINDOWS}
  Windows
{$ELSE}
  {$IFDEF LINUX}
     x, xlib, KeySym
  {$ENDIF}
{$ENDIF};

{ TForm1 }


procedure TForm1.PnlChooseKeyClick(Sender: TObject);
var
   keyCode : Integer;
begin
   Timer1.Enabled := false;
   Label1.Caption:='Taper la Touche a mapper';
   // wait for a key to be pressed
   repeat
      Application.ProcessMessages;  // let other messages happen
      Sleep(1);                     // relinquish time for other processes
      keyCode:=KeyPressed;
   until keyCode>=0;
   // retrieve keyname and adjust panel caption
   TPanel(Sender).Caption:=VirtualKeyCodeToKeyName(keyCode);
   TPanel(Sender).Tag:=keyCode;
   // restore default label1.caption
   Label1.Caption:='Appuyez sur une des touches ci-dessous pour allumer les panneaux et déplacer le carré ...' ;
   Timer1.Enabled := true;
end;

Procedure Tform1.Formclose(Sender : Tobject; Var Closeaction : Tcloseaction);
Begin
  Timer1.Enabled := false;
End;

Procedure Tform1.Formshow(Sender : Tobject);
Begin
  DoubleBuffered := True;
  pnlLeft.Tag := VK_LBUTTON;
  pnlRight.Tag := VK_RBUTTON;
  pnlLeft.Caption := VirtualKeyCodeToKeyName(pnlLeft.Tag);
  pnlRight.Caption := VirtualKeyCodeToKeyName(pnlRight.Tag);
  Timer1.Enabled := true;
End;

procedure TForm1.Timer1Timer(Sender: TObject);
  function CheckPanel(panel : TPanel):Boolean;
  begin
    // check if key associated to current panel's caption is down
    //
    result := false;
    if IsKeyDown(panel.Tag) then
    //if IsKeyDown(KeyNameToVirtualKeyCode(panel.Caption)) then
    begin
       panel.Color:=clRed;         // down, set panel to red
       result := true;
    End
    else panel.Color:=clBtnFace;  // up, set panel to default color
  end;
begin
  if CheckPanel(pnlLeft) then Direction := dirLeft;
  if CheckPanel(pnlRight) then Direction := dirRight;
  case Direction of
    dirLeft:
    begin
      Shape1.Brush.Color := clBlue;
      Shape1.Left := Shape1.Left - 1;
    End;
    dirRight:
    begin
      Shape1.Left := Shape1.Left + 1;
      Shape1.Brush.Color := clYellow;
    End;
    else
    begin
      Shape1.Brush.Color := clWhite;
    End;
  end;
  if (Shape1.Left < -70)   then Shape1.Left := Width;
  if (Shape1.Left > Width) then Shape1.Left := -70;
  Direction := dirNone;


end;

Procedure Tform1.Formmousewheel(Sender : Tobject; Shift : Tshiftstate; Wheeldelta : Integer; Mousepos : Tpoint; Var Handled : Boolean);
Begin
  KeyboardNotifyWheelMoved(Wheeldelta);
End;

end.
