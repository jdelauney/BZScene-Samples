Unit UMainform;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, Sysutils, Fileutil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Spin, ExtCtrls, ComCtrls,
  BZTypesHelpers;

Type

  { TMainForm }

  TMainForm = Class(Tform)
    BtnRunStrTest1 : Tbutton;
    BtnRunStrTest2: TButton;
    BtnRunStrTest3: TButton;
    BtnRunStrTest4: TButton;
    BtnRunStrTest5: TButton;
    Btnrunstrtest6 : Tbutton;
    chkIntToStrFormatted : Tcheckbox;
    edtSingle1: TFloatSpinEdit;
    edtSingle2: TFloatSpinEdit;
    edtSingle3: TFloatSpinEdit;
    edtString : Tedit;
    edtChar : Tedit;
    Edtint1 : Tspinedit;
    Edtint2 : Tspinedit;
    edtInt3: TSpinEdit;
    edtInt4: TSpinEdit;
    edtString1: TEdit;
    edtStringToFloat: TEdit;
    Edtstringtoint : Tedit;
    Groupbox1 : Tgroupbox;
    Groupbox2 : Tgroupbox;
    Groupbox3 : Tgroupbox;
    GroupBox4: TGroupBox;
    Label1 : Tlabel;
    Label10 : Tlabel;
    Label100 : Tlabel;
    Label101 : Tlabel;
    Label102 : Tlabel;
    Label103 : Tlabel;
    Label104 : Tlabel;
    Label105 : Tlabel;
    Label106 : Tlabel;
    Label107 : Tlabel;
    Label108 : Tlabel;
    Label109 : Tlabel;
    Label11 : Tlabel;
    Label110 : Tlabel;
    Label111 : Tlabel;
    Label112 : Tlabel;
    Label113 : Tlabel;
    Label114 : Tlabel;
    Label115: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label12 : Tlabel;
    Label120: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label13 : Tlabel;
    Label130: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    Label139: TLabel;
    Label14 : Tlabel;
    Label140: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Label145: TLabel;
    Label146: TLabel;
    Label147: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    Label15 : Tlabel;
    Label150: TLabel;
    Label151: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    Label154: TLabel;
    Label155: TLabel;
    Label156: TLabel;
    Label157: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    Label16 : Tlabel;
    Label160: TLabel;
    Label161: TLabel;
    Label162: TLabel;
    Label163: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    Label166: TLabel;
    Label167: TLabel;
    Label168: TLabel;
    Label169: TLabel;
    Label17 : Tlabel;
    Label170: TLabel;
    Label171: TLabel;
    Label172: TLabel;
    Label173: TLabel;
    Label174: TLabel;
    Label175: TLabel;
    Label176: TLabel;
    Label177: TLabel;
    Label178: TLabel;
    Label179: TLabel;
    Label18 : Tlabel;
    Label180: TLabel;
    Label181: TLabel;
    Label182: TLabel;
    Label183: TLabel;
    Label184: TLabel;
    Label185: TLabel;
    Label186: TLabel;
    Label187: TLabel;
    Label188: TLabel;
    Label189: TLabel;
    Label19 : Tlabel;
    Label190: TLabel;
    Label191: TLabel;
    Label192: TLabel;
    Label193: TLabel;
    Label194: TLabel;
    Label195: TLabel;
    Label196: TLabel;
    Label197: TLabel;
    Label198: TLabel;
    Label199: TLabel;
    Label20 : Tlabel;
    Label200: TLabel;
    Label201: TLabel;
    Label202: TLabel;
    Label203: TLabel;
    Label204: TLabel;
    Label205: TLabel;
    Label206: TLabel;
    Label207: TLabel;
    Label208: TLabel;
    Label209: TLabel;
    Label210: TLabel;
    Label211: TLabel;
    Label212: TLabel;
    Label213: TLabel;
    Label214: TLabel;
    Label215: TLabel;
    Label216: TLabel;
    Label217: TLabel;
    Label218: TLabel;
    Label219: TLabel;
    Label220: TLabel;
    Label221: TLabel;
    Label222: TLabel;
    Label223: TLabel;
    Label224 : Tlabel;
    Label225 : Tlabel;
    Label226 : Tlabel;
    Label227 : Tlabel;
    Label228 : Tlabel;
    Label229 : Tlabel;
    Label230 : Tlabel;
    Label231 : Tlabel;
    Label232 : Tlabel;
    Label233 : Tlabel;
    Label234 : Tlabel;
    Label235 : Tlabel;
    Label236 : Tlabel;
    Label237 : Tlabel;
    Label238 : Tlabel;
    Label239 : Tlabel;
    Label240 : Tlabel;
    Label241 : Tlabel;
    Label242 : Tlabel;
    Label243 : Tlabel;
    Label244 : Tlabel;
    Label245 : Tlabel;
    Label246 : Tlabel;
    Label247 : Tlabel;
    Label248 : Tlabel;
    Label249 : Tlabel;
    Label250 : Tlabel;
    Label251 : Tlabel;
    Lbldatefromfile : Tlabel;
    lblDateToStr: TLabel;
    Label21 : Tlabel;
    Label22 : Tlabel;
    Label23 : Tlabel;
    Label24 : Tlabel;
    Label25 : Tlabel;
    Label26 : Tlabel;
    Label27 : Tlabel;
    Label28 : Tlabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56 : Tlabel;
    Label57 : Tlabel;
    Label58 : Tlabel;
    Label59 : Tlabel;
    Label60 : Tlabel;
    Label61 : Tlabel;
    Label62 : Tlabel;
    Label63 : Tlabel;
    Label64 : Tlabel;
    Label65 : Tlabel;
    Label66 : Tlabel;
    Label67 : Tlabel;
    Label68 : Tlabel;
    Label69 : Tlabel;
    Label70 : Tlabel;
    Label75: TLabel;
    Label76 : Tlabel;
    Label77 : Tlabel;
    Label78 : Tlabel;
    Label79 : Tlabel;
    Label80 : Tlabel;
    Label81 : Tlabel;
    Label82 : Tlabel;
    Label83 : Tlabel;
    Label84 : Tlabel;
    Label85 : Tlabel;
    Label86 : Tlabel;
    Label87 : Tlabel;
    Label88 : Tlabel;
    Label89 : Tlabel;
    Label90 : Tlabel;
    Label91 : Tlabel;
    Label92 : Tlabel;
    Label93 : Tlabel;
    Label94 : Tlabel;
    Label95 : Tlabel;
    Label96 : Tlabel;
    Label97 : Tlabel;
    Label98 : Tlabel;
    Label99 : Tlabel;
    lblDateAddDay: TLabel;
    lblDateRandom: TLabel;
    lblDateStrToDate : Tlabel;
    lblInt64ToStr : Tlabel;
    lblInt64Rnd : Tlabel;
    lblQWordToStr : Tlabel;
    lblDateAddMonth: TLabel;
    lblDateAddYear: TLabel;
    lblQWordRnd : Tlabel;
    lblStrRemoveChar : Tlabel;
    lblStrHash : Tlabel;
    lblTimeToStr: TLabel;
    lblFloatClamp: TLabel;
    lblFloatRound: TLabel;
    lblSingleToStr: TLabel;
    lblSingleIsInfinity: TLabel;
    lblStrIsEqual: TLabel;
    lblStrCompare: TLabel;
    lblStrSurround: TLabel;
    lblStrQuote: TLabel;
    lblStrReverse: TLabel;
    lblStrParseInt: TLabel;
    lblStrParseFloat: TLabel;
    lblStrImplode: TLabel;
    lblStrMid: TLabel;
    lblStrAfter: TLabel;
    lblStrBefore: TLabel;
    lblStrInsert: TLabel;
    lblStrLeftOf: TLabel;
    lblStrReplace1: TLabel;
    lblStrTest3: TLabel;
    lblStrToFloat: TLabel;
    lblStrWrap: TLabel;
    lblStrRightOf: TLabel;
    lblStrIsEmpty : Tlabel;
    lblStrPos : Tlabel;
    lblStrPosBetween : Tlabel;
    lblStrCopy : Tlabel;
    lblStrCopyPos : Tlabel;
    lblStrBetween: TLabel;
    lblStrContains: TLabel;
    lblStrReplace: TLabel;
    lblStrTest1 : Tlabel;
    Label71 : Tlabel;
    Label72 : Tlabel;
    Label73 : Tlabel;
    Label74 : Tlabel;
    lblBooleanToString : Tlabel;
    lblCharIsAlpha : Tlabel;
    Label2 : Tlabel;
    Label3 : Tlabel;
    Label4 : Tlabel;
    Label5 : Tlabel;
    Label6 : Tlabel;
    Label7 : Tlabel;
    Label8 : Tlabel;
    Label9 : Tlabel;
    lblCharCode : Tlabel;
    lblCharIsNumeric : Tlabel;
    Lblinttostr : Tlabel;
    lblStrGetLength : Tlabel;
    Lblisinrange : Tlabel;
    lblIntegerClamp: TLabel;
    lblIntegerToByte: TLabel;
    lblStrTest2: TLabel;
    lblStrTrim : Tlabel;
    lblStrToUpper : Tlabel;
    lblStrToLower : Tlabel;
    Lblstrtoint : Tlabel;
    lblStrPadLeft : Tlabel;
    lblStrTrimL : Tlabel;
    lblStrPadRight : Tlabel;
    lblStrTrimR : Tlabel;
    lblStrPadCenter : Tlabel;
    mmoTest: TMemo;
    Pagecontrol1 : Tpagecontrol;
    Panel1 : Tpanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Radiobutton1 : Tradiobutton;
    Radiobutton2 : Tradiobutton;
    edtAddDays: TSpinEdit;
    edtAddMonths: TSpinEdit;
    edtAddYears: TSpinEdit;
    Tabsheet1 : Ttabsheet;
    Tabsheet2 : Ttabsheet;
    Tabsheet3 : Ttabsheet;
    Tabsheet4 : Ttabsheet;
    Tabsheet5 : Ttabsheet;
    Tabsheet6 : Ttabsheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    Tabsheet9 : Ttabsheet;
    Procedure BtnRunStrTest1Click(Sender : Tobject);
    procedure BtnRunStrTest2Click(Sender: TObject);
    procedure BtnRunStrTest3Click(Sender: TObject);
    procedure BtnRunStrTest4Click(Sender: TObject);
    procedure BtnRunStrTest5Click(Sender: TObject);
    Procedure Btnrunstrtest6click(Sender : Tobject);
    Procedure Chkinttostrformattedchange(Sender : Tobject);
    procedure edtAddDaysChange(Sender: TObject);
    Procedure Edtaddmonthschange(Sender : Tobject);
    Procedure Edtaddyearschange(Sender : Tobject);
    Procedure Edtcharchange(Sender : Tobject);
    Procedure Edtint3change(Sender : Tobject);
    procedure edtInt4Change(Sender: TObject);
    Procedure Edtsingle2change(Sender : Tobject);
    Procedure Edtsingle3change(Sender : Tobject);
    Procedure Edtstring1change(Sender : Tobject);
    Procedure Edtstringchange(Sender : Tobject);
    procedure edtStringToFloatChange(Sender: TObject);
    Procedure edtStringToIntChange(Sender : Tobject);
    Procedure Edtint1editingdone(Sender : Tobject);
    Procedure Edtint2change(Sender : Tobject);
    procedure edtSingle1Change(Sender: TObject);
    Procedure Radiobutton1click(Sender : Tobject);
  Private

  Public
    C : Char;
    B : Boolean;
    I : Integer;
    BT : Byte;
    SingleFloat : Single;
    aString : String;
    ADateTime: TDateTime;
    i64 : Int64;
    QW : QWord;
  End;

Var
  MainForm : TMainForm;

Implementation

{$R *.lfm}

uses LCLIntf,  LazUTF8;
{ TMainForm }

Procedure TMainForm.Edtint1editingdone(Sender : Tobject);
Begin
  I := edtInt1.Value;
  lblIntToStr.Caption := I.ToString;
End;

Procedure TMainForm.edtStringToIntChange(Sender : Tobject);
Begin
  if I.Parse(edtStringToInt.Caption,-1) then lblStrToInt.Caption := 'TRUE' else lblStrToInt.Caption := 'FALSE';
  lblStrToInt.Caption := lblStrToInt.Caption + I.ToString.Surround(' ( I =',')');
End;

Procedure TMainForm.EdtCharChange(Sender : Tobject);
Var
  S:String;
Begin
  S:= EdtChar.Text;
  if Not(S.IsEmpty) then
  begin
    C := S[1];
    lblCharIsAlpha.Caption := C.IsAlpha.ToString();
    lblCharIsNumeric.Caption := C.IsNumeric.ToString();
    lblCharCode.Caption := C.ToCharCode.ToString;
  End;
End;

Procedure Tmainform.Chkinttostrformattedchange(Sender : Tobject);
Begin
  I := edtInt1.Value;
  lblIntToStr.Caption := I.ToString(Chkinttostrformatted.Checked);
End;

procedure TMainForm.edtAddDaysChange(Sender: TObject);
begin
  ADateTime.SetToDay;
  lblDateAddDay.Caption := ADateTime.AddDay(edtAddDays.Value).DateToString();
end;

Procedure Tmainform.Edtaddmonthschange(Sender : Tobject);
Begin
  ADateTime.SetToDay;
  lblDateAddMonth.Caption := ADateTime.AddMonth(edtAddMonths.Value).DateToString();
End;

Procedure Tmainform.Edtaddyearschange(Sender : Tobject);
Begin
  ADateTime.SetToDay;
  lblDateAddYear.Caption := ADateTime.AddYear(edtAddYears.Value).DateToString();
End;

Procedure Tmainform.BtnRunStrTest1Click(Sender : Tobject);
var
  startpos,endpos : Integer;
Begin
  startpos := 0;
  endpos := 0;
  aString := lblStrTest1.Caption;
  lblStrTrim.Caption := aString.Trim;
  lblStrTrimL.Caption := aString.TrimLeft;
  lblStrTrimR.Caption := aString.TrimRight;
  lblStrPadLeft.Caption := aString.PadCharLeft(40,'#');
  lblStrPadRight.Caption := aString.PadCharRight(40,'#');
  lblStrPadCenter.Caption := aString.PadCenter(50,'=');
  lblStrPos.Caption := aString.Pos('Text').ToString();
  lblStrPosBetween.Caption := aString.PosBetween('Test','Text',startpos,endpos).ToString + ' -> Start : '+StartPos.ToString()+' End : '+EndPos.ToString();
  lblStrCopy.Caption :=  aString.Copy(6,9);
  lblStrCopyPos.Caption :=  aString.CopyPos(StartPos,EndPos);
End;

procedure TMainForm.BtnRunStrTest2Click(Sender: TObject);
begin
  aString := lblStrTest2.Caption;

  lblStrBetween.Caption := aString.Between('<','>');
  lblStrMid.Caption := aString.Mid('=','<');
  lblStrAfter.Caption := aString.After('=');
  lblStrBefore.Caption := aString.Before('=');
  lblStrInsert.Caption := aString.Insert('big ',16);
  lblStrLeftOf.Caption := aString.LeftOf(10);
  lblStrRightOf.Caption := aString.RightOf(26);
  lblStrContains.Caption := aString.Contains('Couple',true).ToString();

  lblStrReplace.Caption := aString.Replace('line','TEXT',true);
  lblStrReplace1.Caption := aString.Replace('line','TEXT');
  lblStrRemoveChar.Caption := aString.RemoveChar('l',true);

  lblStrWrap.Caption := aString.Wrap(26);
end;

procedure TMainForm.BtnRunStrTest3Click(Sender: TObject);
begin
  aString.Parse(123);
  lblStrParseInt.Caption := aString;
  aString.Parse(1.23456,3);
  lblStrParseFloat.Caption := aString;
  aString.Implode(TStringList(mmoTest.Lines),',');
  lblStrImplode.Caption :=  aString;
  aString := lblStrTest3.Caption;
  mmoTest.Lines := aString.Explode('/');

end;

procedure TMainForm.BtnRunStrTest4Click(Sender: TObject);
begin
  SingleFloat := Single.PositiveInfinity;
  lblSingleIsInfinity.Caption := SingleFloat.IsInfinity.ToString();
end;

procedure TMainForm.BtnRunStrTest5Click(Sender: TObject);
begin
  ADateTime.SetToNow;
  LblDateToStr.Caption:= ADateTime.DateToString(ADateTime.fmtFullDate);
  LblTimeToStr.Caption:= ADateTime.TimeToString();
  ADateTime.SetRandomDate;
  LblDateRandom.Caption:= ADateTime.DateToString();
  ADateTime.SetFromString('1977/02/07 15:55:12');
  lblDateStrToDate.Caption := ADateTime.ToString();
  ADateTime.SetFromFile(ExtractFileName(ParamStrUTF8(0)));
  lblDateFromFile.Caption := ADateTime.ToString();
end;

Procedure Tmainform.Btnrunstrtest6click(Sender : Tobject);
Begin
  lblInt64ToStr.Caption := I64.MaxValue.ToString();
  lblQWordToStr.Caption := QW.MaxValue.ToString();
  lblInt64Rnd.Caption := I64.RandomRange(Int64.MinValue+100000,int64.MaxValue-100000).ToString();
  lblQWordRnd.Caption := QW.Random().ToString();
End;

Procedure Tmainform.Edtint3change(Sender : Tobject);
Begin
  I := edtInt3.Value;
  lblIntegerClamp.Caption := I.Clamp(-20,20).ToString;
End;

procedure TMainForm.edtInt4Change(Sender: TObject);
begin
  I := edtInt4.Value;
  lblIntegerToByte.Caption := I.ToByte.ToString;
end;

Procedure Tmainform.Edtsingle2change(Sender : Tobject);
Begin
  SingleFloat := edtSingle2.Value;
  lblFloatClamp.Caption:= SingleFloat.Clamp(-0.5,1.0).ToString();
End;

Procedure Tmainform.Edtsingle3change(Sender : Tobject);
Begin
  SingleFloat := edtSingle3.Value;
  lblFloatRound.Caption:= SingleFloat.Round.ToString;
End;

Procedure Tmainform.Edtstring1change(Sender : Tobject);
Begin
  aString := edtString1.Text;
  //
  lblStrIsEqual.Caption := aString.IsEquals('TEST').ToString();
  lblStrCompare.Caption := aString.Compare('Text',true).ToString();
  lblStrSurround.Caption :=  aString.Surround('BEGIN ', ' END');
  lblStrQuote.Caption :=  aString.Quote;
  lblStrReverse.Caption :=  aString.Reverse;
  aString:= edtString1.Text;;
  lblStrHash.Caption := aString.ComputeHash().ToString();
End;

Procedure Tmainform.Edtstringchange(Sender : Tobject);
Begin
  aString := edtString.Text;
  lblStrIsEmpty.Caption := aString.IsEmpty.ToString();
  lblStrGetLength.Caption := aString.Length.ToString();
  lblStrToUpper.Caption :=  aString.ToUpper;
  lblStrToLower.Caption :=  aString.ToLower;

End;

procedure TMainForm.edtStringToFloatChange(Sender: TObject);
begin
  if SingleFloat.Parse(edtStringToFloat.Caption,-1) then lblStrToFloat.Caption := 'TRUE' else lblStrToFloat.Caption := 'FALSE';
  lblStrToFloat.Caption := lblStrToFloat.Caption + SingleFloat.ToString.Surround(' ( Float =',')');
end;

Procedure TMainForm.Edtint2change(Sender : Tobject);
Begin
  I := edtInt2.Value;
  if I.IsInRange(-20,20) then lblIsInRange.Caption := 'TRUE' else lblIsInRange.Caption := 'FALSE';
End;

procedure TMainForm.edtSingle1Change(Sender: TObject);
begin
  SingleFloat := edtSingle1.Value;
  lblSingleToStr.Caption:= SingleFloat.ToString(3);
end;

Procedure TMainForm.Radiobutton1click(Sender : Tobject);
Begin
  B := Radiobutton1.Checked;
  lblBooleanToString.Caption := B.ToString('Is Good','Is Bad');
End;

End.

