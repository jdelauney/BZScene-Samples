unit uBassInfosForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type
  TBassInfosForm = class(TForm)
    Button1 : TButton;
    GroupBox3 : TGroupBox;
    Memo1 : TMemo;
    Panel1 : TPanel;
    procedure Button1Click(Sender : TObject);
  private

  public

  end;

var
  BassInfosForm : TBassInfosForm;

implementation

{$R *.lfm}

{ TBassInfosForm }

procedure TBassInfosForm.Button1Click(Sender : TObject);
begin
  Close;
end;

end.

