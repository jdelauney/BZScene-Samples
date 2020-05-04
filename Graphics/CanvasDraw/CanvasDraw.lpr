Program CanvasDraw;

{$mode objfpc}{$H+}

Uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  Cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uMainForm;

{$R *.res}

Begin
  Requirederivedformresource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.Createform(Tmainform, Mainform);
  Application.Run;
End.

