unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Buttons,
  BZLogger;

type

  { TMainForm }

  TMainForm = class(TForm)
    btnLog : TButton;
    btnLogNotice : TButton;
    btnLogStatus : TButton;
    btnLogWarn : TButton;
    btnLogError : TButton;
    btnLogException : TButton;
    btnViewLog : TButton;
    btnLogHint : TButton;
    btnHalt : TButton;
    btnShowLogView : TButton;
    btnHideLogView : TButton;
    procedure btnLogClick(Sender : TObject);
    procedure btnLogNoticeClick(Sender : TObject);
    procedure btnLogStatusClick(Sender : TObject);
    procedure btnLogWarnClick(Sender : TObject);
    procedure btnLogErrorClick(Sender : TObject);
    procedure tnLogHint(Sender : TObject);
    procedure btnLogHintClick(Sender : TObject);
    procedure btnViewLogClick(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure btnHaltClick(Sender : TObject);
    procedure btnShowLogViewClick(Sender : TObject);
    procedure btnHideLogViewClick(Sender : TObject);
  private
    procedure GetLog( aLevel: TBZLogLevel;  aTimeStamp : TDateTime; const aMessage, ParseMsg : String);
  protected
    FLogStr : String;
    FConsoleLoggerWriter : TBZConsoleLoggerWriter;

    procedure LogToMemo;
  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

//uses
//  uViewLoggerMainForm;
{ TMainForm }

procedure TMainForm.btnLogClick(Sender : TObject);
begin
  GlobalLogger.Log('Texte de log simple');
end;

procedure TMainForm.btnLogNoticeClick(Sender : TObject);
begin
  GlobalLogger.LogNotice('Texte de log de type Notification');
end;

procedure TMainForm.btnLogStatusClick(Sender : TObject);
begin
  GlobalLogger.LogStatus('Texte de log de type Status');
end;

procedure TMainForm.btnLogWarnClick(Sender : TObject);
begin
  GlobalLogger.LogWarning('Texte de log de type Warning');
end;

procedure TMainForm.btnLogErrorClick(Sender : TObject);
begin
  GlobalLogger.LogError('Texte de log de type Error');
end;

procedure TMainForm.tnLogHint(Sender : TObject);
begin
  GlobalLogger.LogException('Texte de log de type Exception');
end;

procedure TMainForm.btnLogHintClick(Sender : TObject);
begin
  GlobalLogger.LogHint('Texte de log de type Conseil');
end;

procedure TMainForm.btnViewLogClick(Sender : TObject);
begin
  //ViewLoggerMainForm.Show;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin

  FConsoleLoggerWriter := TBZConsoleLoggerWriter.Create(GlobalLogger);
  FConsoleLoggerWriter.Enabled := True;
  GlobalLogger.LogWriters.AddWriter(FConsoleLoggerWriter);
  GlobalLogger.LogWriters.Items[1].Enabled := true;
  GlobalLogger.HandleApplicationException := True;

  //GlobalLogger.OnCallBack := @GetLog;
  //ViewLoggerMainForm.Top := Self.Top;
  //ViewLoggerMainForm.Left := Self.Left + Self.Width + 4;
  //ViewLoggerMainForm.Show;
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  GlobalLogger.OnCallBack := nil;
end;

procedure TMainForm.btnHaltClick(Sender : TObject);
begin
   raise Exception.Create('Une Exception à été levée - Fin de l''application');
end;

procedure TMainForm.btnShowLogViewClick(Sender : TObject);
begin
  GlobalLogger.LogViewEnabled:= True;
  GlobalLogger.ShowLogView;
end;

procedure TMainForm.btnHideLogViewClick(Sender : TObject);
begin
  GlobalLogger.HideLogView;
  //GlobalLogger.LogViewEnabled:= False;
end;

procedure TMainForm.GetLog(aLevel : TBZLogLevel; aTimeStamp : TDateTime; const aMessage, ParseMsg : String);
begin
  FLogStr := ParseMsg;
  //TThread.Synchronize(GlobalLogger, @LogToMemo);  // La synchronisation n'est pas indispensable ici
  LogToMemo;
end;

procedure TMainForm.LogToMemo;
begin
  //Close;
  //ViewLoggerMainForm.MemoLog.Append(FLogStr);
end;

end.

