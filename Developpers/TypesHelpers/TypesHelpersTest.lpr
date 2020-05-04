Program TypesHelpersTest;

{$mode objfpc}{$H+}

Uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  Cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, UMainform
  { you can add units after this };

{$R *.res}

Begin
  Requirederivedformresource := True;
  Application.Initialize;
  Application.Createform(Tmainform, Mainform);
  Application.Run;
End.

