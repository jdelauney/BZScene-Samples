Program BeanzPictureViewer;

{$mode objfpc}{$H+}

Uses
  //SimplyMM,
  {$IFDEF UNIX}
    cLocale,
    {$IFDEF UseCThreads}
      cthreads,
    {$ENDIF}
  {$ENDIF}
  Interfaces, LCLIntf,
  {$ifdef WINDOWS }
  Windows,// this includes the LCL widgetset
  {$ENDIF}
  Forms, Dialogs, uMainForm,uErrorBoxForm
  { you can add units after this };

{$R *.res}

Const
  cHeapMinSize : ptruint = $FFFFFFFF;
  cHeapMaxSize : ptruint = $FFFFFFFF;

Begin
  RequireDerivedFormResource := True;

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TErrorBoxForm, ErrorBoxForm);
  {$ifdef WINDOWS }
    SetProcessWorkingSetSize(Application.MainFormHandle ,cHeapMinSize, cHeapMaxSize );
    {
    if not(SetProcessWorkingSetSize(Application.MainFormHandle ,cHeapMinSize, cHeapMaxSize )) then
      ShowMessage('Impossible de locker la heap');
    }
  {$ENDIF}
  Application.Run;

End.

