Unit uOpenALDialogInfos;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Fileutil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

Type

  { TOpenALInfosDialog }

  TOpenALInfosDialog = Class(Tform)
    Button1 : Tbutton;
    Checkgroup1 : Tcheckgroup;
    Checkgroup2 : Tcheckgroup;
    Groupbox1 : Tgroupbox;
    Groupbox2 : Tgroupbox;
    Groupbox3 : Tgroupbox;
    Label1 : Tlabel;
    Label10 : Tlabel;
    Label11 : Tlabel;
    Label12 : Tlabel;
    Label13 : Tlabel;
    Label14 : Tlabel;
    Label15 : Tlabel;
    Label16 : Tlabel;
    Label2 : Tlabel;
    Label3 : Tlabel;
    Label4 : Tlabel;
    Label5 : Tlabel;
    Label6 : Tlabel;
    Label7 : Tlabel;
    Label8 : Tlabel;
    Label9 : Tlabel;
    Memo1 : Tmemo;
    Panel1 : Tpanel;
    Panel2 : Tpanel;
    Panel3 : Tpanel;
  Private

  Public

  End;

Var
  OpenALInfosDialog : TOpenALInfosDialog;

Implementation

{$R *.lfm}

End.

