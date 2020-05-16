unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  LCLIntf, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ValEdit, ExtDlgs, ExtCtrls,SyncObjs,
  BZClasses, BZColors, BZGraphic, BZBitmap, {%H-}BZBitmapIO, BZParallelThread, BZImageViewer;

type


  { TForm1 }

  TForm1 = class(TForm)
    BZImageViewer1 : TBZImageViewer;
    Button1 : TButton;
    Button2 : TButton;
    ValueListEditor1 : TValueListEditor;
    OPD : TOpenPictureDialog;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    procedure Button1Click(Sender : TObject);
    procedure Button2Click(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
  private

  protected
    SL : TBZStringList;
    SLColors : Array[0..$FFFFFF] of integer;
    iCpt : Integer;
    maCS : TCriticalSection;

    //procedure CompteurDeLignes(Sender : TObject; Index : Integer);
    procedure CompteurDeLignes;
    procedure ProcessLine(y : Integer);
    procedure MyParalelleProc(Sender: TObject; Index: Integer; Data : Pointer);
  public

  end;

var
  Form1 : TForm1;

implementation

{$R *.lfm}


{ TForm1 }

procedure TForm1.Button1Click(Sender : TObject);
begin
  if OPD.Execute then
  begin
    BZImageViewer1.Picture.LoadFromFile(OPD.FileName);
    BZImageViewer1.Invalidate;
  end;
end;

procedure TForm1.Button2Click(Sender : TObject);
var
  i : Int64;
  SLOut : TStringList;
  Stream : TStringStream;

begin

   maCs := TCriticalSection.Create;
   Screen.Cursor := crHourGlass;
   FillByte(SLColors, Sizeof(SLColors),0);


   //ParallelFor(0, BZImageViewer1.Picture.Bitmap.MaxHeight, @MyParalelleProc,@CompteurDeLignes, nil);
   ParallelFor(0, BZImageViewer1.Picture.Bitmap.MaxHeight, @MyParalelleProc, nil);
   //SLOut := TStringList.Create;
   //for i:=0 to SL.Count-1 do
   //begin
   //  SLOut.Add(SL.Strings[i]+'='+SL.Items[i].Tag.ToString);
   //end;
   //ValueListEditor1.Strings.CommaText := SLOut.CommaText;
   //FreeAndNil(SLOut);
   maCs.Free;
   Stream := TStringStream.Create('');
       try
         for i := 0 to High(SLColors) do
         begin
           if SLColors[i] > 0 then            //
             //SLOut.Add(Format('%.6x=%d'+#13#10, [i, SLColors[i]]));
             Stream.WriteString(Format('%.6x=%d'+#13#10, [i, SLColors[i]]));
         end;

         Stream.Position := 0;

         ValueListEditor1.Strings.LoadFromStream(Stream);

         //ListBox1.Items.LoadFromStream(Stream);
         //ListBox1.Items.CommaText := SLOut.CommaText;
         Label3.Caption := ValueListEditor1.Strings.Count.ToString;
       finally
         Stream.Free;
       end;
   Label1.Caption := 'Terminé';


   Screen.Cursor := crDefault;

end;

procedure TForm1.FormCreate(Sender : TObject);
begin
  SL := TBZStringList.Create(Nil);
  SL.CaseSensitive := True;
end;

procedure TForm1.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(SL);
end;

//procedure TForm1.ProcessLine(y : Integer);
//var
//  X: DWord;
//  L : PBZColor;
//  Current : TBZColor;
//  S: String;
//  I, J: Integer;
//begin
//  Current := clrBlack;
//  L := BZImageViewer1.Picture.Bitmap.GetScanLine(y);
//  For X := 0 to BZImageViewer1.Picture.Bitmap.MaxWidth do
//  begin
//
//    if (L^<>clrBlack) and (l^<>clrTransparent) then
//    begin
//      //maCS.Acquire;
//      maCS.Enter;
//      if L^<>Current then
//      begin
//        S := L^.ToHexString;
//        I := SL.IndexOf(S);
//        if  I < 0 then
//        begin
//          J := SL.Add(S);
//          SL.Items[J].Tag := 1;
//          Current := L^;
//          I := J;
//        end
//        else
//        begin
//          SL.Items[I].Tag := SL.Items[I].Tag + 1;
//        end;
//      end
//      else
//      begin
//          SL.Items[I].Tag := SL.Items[I].Tag + 1;
//      end;
//      //maCS.Release;
//      maCS.Leave;
//    end;
//    inc(L);
//  end;
//end;


procedure TForm1.ProcessLine(y : Integer);
var
  X: DWord;
  L : PBZColor;
begin
  L := BZImageViewer1.Picture.Bitmap.GetScanLine(y);

  For X := 0 to BZImageViewer1.Picture.Bitmap.MaxWidth do
  begin
    maCS.Enter;
    InterlockedIncrement(SLColors[L^.AsInteger and $FFFFFF]);
    maCS.Leave;
    inc(L);
  end;

end;

procedure TForm1.MyParalelleProc(Sender : TObject; Index : Integer; Data : Pointer);
begin
  ProcessLine(Index mod BZImageViewer1.Picture.Bitmap.Height);
  TThread.Synchronize(BZCurrentParallelThread,@CompteurDeLignes);
end;

//procedure TForm1.CompteurDeLignes(Sender : TObject; Index : Integer);
procedure TForm1.CompteurDeLignes;
begin
  Inc(iCpt);
//  Label1.Caption := IntToStr(Index);
  Label1.Caption := IntToStr(iCpt);
  Application.ProcessMessages;
end;

end.

