unit uinfoform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TSMInfosForm }

  TSMInfosForm = class(TForm)
    Button1: TButton;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  SMInfosForm: TSMInfosForm;

implementation

{$R *.lfm}

{ TSMInfosForm }

procedure TSMInfosForm.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

