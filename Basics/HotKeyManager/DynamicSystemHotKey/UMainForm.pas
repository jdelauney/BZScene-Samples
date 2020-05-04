unit UMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  LCLType, LCLIntf,
  {$IFDEF WINDOWS}
  windows,
  {$ENDIF}
  BZHotKeyManager;

type

  { TMainForm }

  TMainForm = class(TForm)
    Label1 : TLabel;
    Label2 : TLabel;
    Panel1 : TPanel;
    Image1 : TImage;
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
  private
    HotKeyManager : TBZHotKeyManager;

    procedure processHotKey(Sender:TObject);
  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
var
  modifiers,key:word;
  idx:integer;
begin
  modifiers := (MOD_CONTROL + MOD_ALT);
  key := VK_G;
  HotKeyManager:=TBZHotKeyManager.Create(self);
  idx:=HotKeyManager.AddHotKey(HotKeyManager.CreateHotKey(modifiers,Key));
  if idx>-1 then HotKeyManager.HotKeys[idx].OnExecute:=@processHotKey
  else ShowMessage('Il y a une erreur');
  HotKeyManager.Active := True;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(HotKeyManager);
end;

procedure TMainForm.processHotKey(Sender:TObject);
begin
  Panel1.Visible := True;
  WindowState:=wsMaximized;
end;
end.

