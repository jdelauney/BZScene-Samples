unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, BZSnapForm;

type
  TMainForm = class(TForm)
    Button1 : TButton;
    Button2 : TButton;
    Button3 : TButton;
    Button4 : TButton;
    BZSnapForm1 : TBZSnapForm;
    CheckBox1 : TCheckBox;
    CheckBox2 : TCheckBox;
    CheckBox3 : TCheckBox;
    CheckBox4 : TCheckBox;
    GroupBox1 : TGroupBox;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    lblFormH : TLabel;
    lblFormW : TLabel;
    lblFormX : TLabel;
    lblFormY : TLabel;
    lblMouseX : TLabel;
    lblMouseY : TLabel;
    Timer1 : TTimer;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);

    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses
  uChildForm;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin

  lblFormX.Caption:=inttostr(MainForm.Left);
  lblFormY.Caption:=inttostr(MainForm.Top);
  lblFormW.Caption:=inttostr(MainForm.Width);
  lblFormH.Caption:=inttostr(MainForm.Height);

  lblMouseX.Caption := inttostr(BZSnapForm1.MousePosX);
  lblMouseY.Caption := inttostr(BZSnapForm1.MousePosY);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  BZSnapForm1.EnterFullScreen;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  BZSnapForm1.ExitFullScreen;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  BZSnapForm1.ShowForm('ChildForm',true);
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
  BZSnapForm1.HideForm('ChildForm',true);
end;

procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  BZSnapForm1.ActiveMoving := TCheckBox(Sender).Checked;
end;

procedure TMainForm.CheckBox2Click(Sender: TObject);
begin
  BZSnapForm1.ActiveSizing := TCheckBox(Sender).Checked;
end;

procedure TMainForm.CheckBox3Click(Sender: TObject);
begin
  BZSnapForm1.ScreenMagnet := TCheckBox(Sender).Checked;
end;

procedure TMainForm.CheckBox4Click(Sender: TObject);
begin
  BZSnapForm1.Snapping := TCheckBox(Sender).Checked;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  // ATTENTION IL EST IMPORTANT D AJOUTER LES FENETRES ENFANT DANS ONSHOW ET NON ONCREATE
  BZSnapForm1.addChildForm('ChildForm',ChildForm);
end;

end.

