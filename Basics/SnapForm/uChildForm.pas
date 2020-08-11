unit uChildForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type
  TChildForm = class(TForm)
    Button1 : TButton;
    Image1 : TImage;
    Label1 : TLabel;
    Panel1 : TPanel;

    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  ChildForm : TChildForm;

implementation

{$R *.lfm}

uses
  uMainForm;

procedure TChildForm.Button1Click(Sender: TObject);
Var
  Bmp : TBitmap;
begin
  Bmp := MainForm.BZSnapForm1.TakeChildFormScreenShot('ChildForm');
  Image1.Picture.Assign(Bmp);
  FreeAndNil(Bmp);
end;

end.

