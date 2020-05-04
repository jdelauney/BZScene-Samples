unit uMainForm;

{$mode objfpc}{$H+}

{.$DEFINE DEBUGLOG} // Est definie dans les options personnalisées du projet
{$DEFINE SHOW_LOG_VIEW}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Spin,
  BZArrayClasses, BZLogger, BZStopWatch;
type

  { TMainForm }

  TMainForm = class(TForm)
    GroupBox1 : TGroupBox;
    Label1 : TLabel;
    Panel1 : TPanel;
    GroupBox2 : TGroupBox;
    GroupBox4 : TGroupBox;
    Label2 : TLabel;
    btnAddTenValues : TButton;
    speValue : TSpinEdit;
    btnAddValue : TButton;
    lbxInteger : TListBox;
    btnPush : TButton;
    btnPop : TButton;
    Label3 : TLabel;
    btnGetFirst : TButton;
    btnGetLast : TButton;
    btnGetPrevious : TButton;
    btnGetCurrent : TButton;
    btnGetNext : TButton;
    btnExchange : TButton;
    Label4 : TLabel;
    btnMoveToPrev : TButton;
    Label5 : TLabel;
    lblPosition : TLabel;
    btnReverse : TButton;
    btnClear : TButton;
    btnAddNoDup : TButton;
    Button13 : TButton;
    btnDelete : TButton;
    btnMoveToNext : TButton;
    Label7 : TLabel;
    chkSortOrder : TCheckBox;
    btnQuickSort : TButton;
    btnInsertionSort : TButton;
    btnMergeSort : TButton;
    Label8 : TLabel;
    lblCount : TLabel;
    btnShuffle : TButton;
    Label6 : TLabel;
    lblBenchTime : TLabel;
    btnAddManyValues1 : TButton;
    Button1 : TButton;
    procedure btnAddValueClick(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure btnAddNoDupClick(Sender : TObject);
    procedure btnAddTenValuesClick(Sender : TObject);
    procedure btnPushClick(Sender : TObject);
    procedure btnPopClick(Sender : TObject);
    procedure btnReverseClick(Sender : TObject);
    procedure btnClearClick(Sender : TObject);
    procedure btnDeleteClick(Sender : TObject);
    procedure lbxIntegerSelectionChange(Sender : TObject; User : boolean);
    procedure btnMoveToPrevClick(Sender : TObject);
    procedure btnMoveToNextClick(Sender : TObject);
    procedure btnGetPreviousClick(Sender : TObject);
    procedure btnGetNextClick(Sender : TObject);
    procedure btnGetCurrentClick(Sender : TObject);
    procedure btnGetFirstClick(Sender : TObject);
    procedure btnGetLastClick(Sender : TObject);
    procedure btnExchangeClick(Sender : TObject);
    procedure btnInsertionSortClick(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnQuickSortClick(Sender : TObject);
    procedure btnMergeSortClick(Sender : TObject);
    procedure btnShuffleClick(Sender : TObject);
    procedure btnAddManyValues1Click(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure Button1Click(Sender : TObject);
  private
     FArrayOfInteger : TBZIntegerList;
     FConsoleLoggerWriter : TBZConsoleLoggerWriter;
     FBenchSort : TBZStopWatch;
  protected
    procedure UpdateList;

  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

function CompareInteger(Const elem1, elem2) : Integer;
var
  i1 : integer absolute elem1;
  i2 : integer absolute elem2;
begin
  if i1 = i2 then Result:=0
  else if i1 < i2 then Result:=-1
  else Result:=1;
end;


procedure TMainForm.btnAddValueClick(Sender : TObject);
begin
  FArrayOfInteger.Add(speValue.Value);
  UpdateList;
end;

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FArrayOfInteger := TBZIntegerList.Create;

  {$IFDEF DEBUG}
    {$IFDEF DEBUGLOG}
    FConsoleLoggerWriter := TBZConsoleLoggerWriter.Create(GlobalLogger);
    FConsoleLoggerWriter.Enabled := True;
    GlobalLogger.LogWriters.AddWriter(FConsoleLoggerWriter);
    GlobalLogger.LogViewEnabled := true;
    //GlobalLogger.HandleApplicationException := True;
    {$ENDIF}
  {$ENDIF}

  FBenchSort := TBZStopWatch.Create(self);
  Randomize;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FArrayOfInteger);

end;

procedure TMainForm.btnAddNoDupClick(Sender : TObject);
begin
  FArrayOfInteger.AddNoDup(speValue.Value);
  UpdateList;
end;

procedure TMainForm.btnAddTenValuesClick(Sender : TObject);
Var
  I, R, J : Integer;
begin
  R := 0;
  I := 0;
  While (I < 10) do
  begin
    R := speValue.MinValue + Random(speValue.MaxValue * 2);
    J := FArrayOFInteger.AddNoDup(R);
    //I := FArrayOFInteger.Count;
    if (J<>-1) then Inc(I);
  end;
  UpdateList;

end;

procedure TMainForm.btnPushClick(Sender : TObject);
begin
  FArrayOfInteger.Push(speValue.Value);
  UpdateList;
end;

procedure TMainForm.btnPopClick(Sender : TObject);
begin
  ShowMessage('Pop the value = ' + FArrayOfInteger.Pop.ToString);
  UpdateList;
end;

procedure TMainForm.btnReverseClick(Sender : TObject);
begin
  FArrayOfInteger.Reverse;
  UpdateList;
end;

procedure TMainForm.btnClearClick(Sender : TObject);
begin
  FArrayOfInteger.Clear;
  UpdateList;
end;

procedure TMainForm.btnDeleteClick(Sender : TObject);
begin
  FArrayOfInteger.Delete(FArrayOfInteger.GetPosition);
  UpdateList;
end;

procedure TMainForm.lbxIntegerSelectionChange(Sender : TObject; User : boolean);
begin
  FArrayOfInteger.MoveTo(lbxInteger.ItemIndex);
  lblPosition.Caption := FArrayOfInteger.GetPosition.ToString;
end;

procedure TMainForm.btnMoveToPrevClick(Sender : TObject);
begin
  if FArrayOfInteger.MovePrev then
    lbxInteger.ItemIndex := FArrayOfInteger.GetPosition;
end;

procedure TMainForm.btnMoveToNextClick(Sender : TObject);
begin
  if FArrayOfInteger.MoveNext then
    lbxInteger.ItemIndex := FArrayOfInteger.GetPosition;
end;

procedure TMainForm.btnGetPreviousClick(Sender : TObject);
begin
  ShowMessage('Previous value = ' + FArrayOfInteger.Prev.ToString);
end;

procedure TMainForm.btnGetNextClick(Sender : TObject);
begin
  ShowMessage('Next value = ' + FArrayOfInteger.Next.ToString);
end;

procedure TMainForm.btnGetCurrentClick(Sender : TObject);
begin
  ShowMessage('Current value = ' + FArrayOfInteger.Current.ToString);
end;

procedure TMainForm.btnGetFirstClick(Sender : TObject);
begin
  ShowMessage('First value = ' + FArrayOfInteger.First.ToString);
end;

procedure TMainForm.btnGetLastClick(Sender : TObject);
begin
  ShowMessage('Last value = ' + FArrayOfInteger.Last.ToString);
end;

procedure TMainForm.btnExchangeClick(Sender : TObject);
begin
  FArrayOfInteger.Exchange(0, FArrayOfInteger.Count - 1);
  UpdateList;
end;

procedure TMainForm.btnInsertionSortClick(Sender : TObject);
Var
  Dir : TBZSortOrder;
begin
  if chkSortOrder.Checked then Dir := soDescending else Dir := soAscending;
  FBenchSort.Start();
  FArrayOfInteger.QuickSort(Dir);//,@CompareInteger);
  lblBenchTime.Caption := FBenchSort.getValueAsMilliSeconds;
  UpdateList;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  //FreeAndNil(FConsoleLoggerWriter);
end;

procedure TMainForm.btnQuickSortClick(Sender : TObject);
Var
  Dir : TBZSortOrder;
begin
  if chkSortOrder.Checked then Dir := soDescending else Dir := soAscending;
  FBenchSort.Start();
  FArrayOfInteger.Sort(Dir); //,@CompareInteger);
  lblBenchTime.Caption := FBenchSort.getValueAsMilliSeconds;
  UpdateList;
end;

procedure TMainForm.btnMergeSortClick(Sender : TObject);
Var
  Dir : TBZSortOrder;
begin
  if chkSortOrder.Checked then Dir := soDescending else Dir := soAscending;
  FBenchSort.Start();
  FArrayOfInteger.MergeSort(Dir); //,@CompareInteger); //.Sort(Dir,@CompareInteger);
  lblBenchTime.Caption := FBenchSort.getValueAsMilliSeconds;
  UpdateList;
end;

procedure TMainForm.btnShuffleClick(Sender : TObject);
begin
  FArrayOfInteger.Shuffle;
  UpdateList;
end;

procedure TMainForm.btnAddManyValues1Click(Sender : TObject);
Var
  I, R, J : Integer;
begin
  R := 0;
  I := 0;
  While (I < 10) do
  begin
    R := speValue.MinValue + Random(speValue.MaxValue * 2);
    J := FArrayOfInteger.AddNoDup(R);
    //I := FArrayOFInteger.Count;
    if (J<>-1) then Inc(I);
  end;
  UpdateList;
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  {$IFDEF SHOW_LOG_VIEW}
    // GlobalLogger.ShowLogView;
  {$ENDIF}
end;

procedure TMainForm.Button1Click(Sender : TObject);
begin
  GlobalLogger.ShowLogView;
end;

procedure TMainForm.UpdateList;
Var
  I : Integer;
begin
  Screen.Cursor := crHourGlass;
  lbxInteger.Clear;
  lbxInteger.Items.BeginUpdate;
  For i := 0 to FArrayOfInteger.Count - 1 do
  begin
    lbxInteger.AddItem(FArrayOfInteger.Items[i].ToString,nil);
  end;
  lbxInteger.Items.EndUpdate;
  lblPosition.Caption := FArrayOfInteger.GetPosition.ToString;
  lblCount.Caption := FArrayOfInteger.Count.ToString;

  Screen.Cursor := crDefault;
end;

end.

