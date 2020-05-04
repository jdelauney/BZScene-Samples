unit uViewLoggerMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TViewLoggerMainForm }

  TViewLoggerMainForm = class(TForm)
    MemoLog : TMemo;
  private

  public

  end;

var
  ViewLoggerMainForm : TViewLoggerMainForm;

implementation

{$R *.lfm}

end.

