unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms,
  Controls, Graphics, Dialogs, StdCtrls, Menus,
  BZSystem, BZThreadTimer, BZStopWatch;

type

  { TMainForm }

  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;

    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    Procedure Formcreate(Sender : Tobject);
    Procedure Formdestroy(Sender : Tobject);
    procedure FormShow(Sender: TObject);
    procedure ThreadTimer1Timer(Sender: TObject);
  private
    { private declarations }

  public
    { public declarations }
     StopWatch1: TBZStopWatch;
     ThreadTimer1: TBZThreadTimer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.ThreadTimer1Timer(Sender: TObject);
begin
  Label2.Caption:= ' Nous sommes le : '+ FormatDateTime('YYYY-MM-DD',Now)+' Il est : '+FormatDateTime('HH:NN:SS',Now);
  Label4.Caption:=GlobalStopWatch.getValueAsSeconds;
  Label6.Caption:=StopWatch1.getValueAsSeconds;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  StopWatch1.Start();
  ThreadTimer1.Enabled:=True;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  ThreadTimer1.Enabled:=false;
  StopWatch1.Stop;
  application.Terminate;
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
  ThreadTimer1.Enabled:=false;
  StopWatch1.Stop;
 // Label6.Caption:=StopWatch1.getValueAsMilliSeconds;
end;

Procedure TMainForm.Formcreate(Sender : Tobject);
Begin
  //StopWatch1 := TBZStopWatch.Create(self);
  //ThreadTimer1 := TBZThreadTimer.Create(self);
  //ThreadTimer1.Interval := 1000;
  //ThreadTimer1.KeepAlive := True;
  //ThreadTimer1.Accurate := True;
  //ThreadTimer1.Synchronize := True;
  //ThreadTimer1.OnTimer := @ThreadTimer1Timer;
End;

Procedure TMainForm.Formdestroy(Sender : Tobject);
Begin
  ThreadTimer1.Enabled := False;
  FreeAndNil(ThreadTimer1);
  FreeAndNil(StopWatch1);
End;

procedure TMainForm.FormShow(Sender: TObject);
begin
  StopWatch1 := TBZStopWatch.Create(self);
  ThreadTimer1 := TBZThreadTimer.Create(self);
  ThreadTimer1.Interval := 1000;
  ThreadTimer1.KeepAlive := True;
  ThreadTimer1.Accurate := False;//True;
  //ThreadTimer1.Synchronize := True;
  ThreadTimer1.OnTimer := @ThreadTimer1Timer;
  Label8.Caption:='Frequence : '+inttostr(StopWatch1.Frequency)+' / Vitesse : '+inttostr(round(CPU_Speed)) + ' Mhz';
end;



end.

