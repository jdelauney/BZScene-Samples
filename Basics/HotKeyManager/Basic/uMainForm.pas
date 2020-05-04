unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  LCLProc, LCLType, LCLIntf, Process,
  {$IFDEF WINDOWS}
  windows,
  {$ENDIF}
  FileUtil, LazFileUtils, LazUTF8, UTF8Process,
  BZHotKeyManager;

type

  { TMainForm }

  TMainForm = class(TForm)
    Label1 : TLabel;
    Label2 : TLabel;
    BZFormHotKeyManager1 : TBZFormHotKeyManager;
    procedure TBZHotKeyList0Execute(Sender : TObject);
    procedure TBZHotKeyList1Execute(Sender : TObject);
  private

  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.TBZHotKeyList0Execute(Sender : TObject);
begin
  WindowState:=wsMaximized;
end;

procedure TMainForm.TBZHotKeyList1Execute(Sender : TObject);
begin
  OpenURL('http://www.lazarus.freepascal.org/');
end;

end.

