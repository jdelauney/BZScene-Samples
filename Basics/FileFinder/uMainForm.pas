unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, EditBtn, Spin,
  BZFileFinder;

type

  { TMainForm }

  TMainForm = class(TForm)
    Panel1 : TPanel;
    Label1 : TLabel;
    edtFolder : TDirectoryEdit;
    Label2 : TLabel;
    edtFileMask : TEdit;
    GroupBox1 : TGroupBox;
    Panel2 : TPanel;
    GroupBox3 : TGroupBox;
    GroupBox2 : TGroupBox;
    GroupBox4 : TGroupBox;
    chkSizeActive : TCheckBox;
    chkDateActive : TCheckBox;
    chkContentActive : TCheckBox;
    pnlSizeCirterias : TPanel;
    pnlDateCriterias : TPanel;
    pnlContentCriterias : TPanel;
    Label3 : TLabel;
    edtContent : TEdit;
    chkContentCaseSensitive : TCheckBox;
    Label4 : TLabel;
    cbxSizeCriteria : TComboBox;
    Label5 : TLabel;
    cbxDateCriteria : TComboBox;
    Label6 : TLabel;
    Label7 : TLabel;
    Label8 : TLabel;
    Label9 : TLabel;
    speMinSize : TSpinEdit;
    speMaxSize : TSpinEdit;
    edtDateFrom : TDateEdit;
    edtDateTo : TDateEdit;
    chkRecursive : TCheckBox;
    Panel6 : TPanel;
    Panel7 : TPanel;
    btnStartSearch : TButton;
    btnQuit : TButton;
    lblStatus : TLabel;
    GroupBox5 : TGroupBox;
    lbxSearchResult : TListBox;
    Label10 : TLabel;
    lblNbFolderFound : TLabel;
    Label12 : TLabel;
    lblNbFilesFound : TLabel;
    chkgAttributs : TGroupBox;
    chkLookForDirectory : TCheckBox;
    chkLookForHidden : TCheckBox;
    chkLookForSystem : TCheckBox;
    chkLookForArchive : TCheckBox;
    chkLookForReadOnly : TCheckBox;
    chkLookForAnyFile : TCheckBox;
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnQuitClick(Sender : TObject);
    procedure btnStartSearchClick(Sender : TObject);
  private

  protected
    FFileFinder : TBZFileFinder;

    procedure DoOnFileFinderFileFound(Sender : TObject; FileFound : TBZFileInformations);
    procedure DoOnFileFinderStart(Sender : TObject);
    procedure DoOnFileFinderCompleted(Sender : TObject; Stats : TBZSearchStatistics);
    procedure DoOnFileFinderChangeFolder(Sender : TObject; NewPath : String);
  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

Uses BZSystem, BZUtils, FileCtrl;
{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FFileFinder := TBZFileFinder.Create(Self);
  FFileFinder.OnFileFound := @DoOnFileFinderFileFound;
  FFileFinder.OnCompleted := @DoOnFileFinderCompleted;
  FFileFinder.OnStart := @DoOnFileFinderStart;
  FFileFinder.OnChangeFolder := @DoOnFileFinderChangeFolder;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FFileFinder);
end;

procedure TMainForm.btnQuitClick(Sender : TObject);
begin
  Screen.Cursor := crHourGlass;
  Close;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.btnStartSearchClick(Sender : TObject);
begin
  FFileFinder.RootPath := edtFolder.Text;
  FFileFinder.FileMasks.Clear;
  FFileFinder.FileMasks.Add(edtFileMask.Text);
  FFileFinder.SearchOptions.IncludeSubfolder := chkRecursive.Checked;
  FFileFinder.SearchOptions.LookForDirectory := chkLookForDirectory.Checked;
  FFileFinder.SearchOptions.LookForAnyFile := chkLookForAnyFile.Checked;
  FFileFinder.SearchOptions.LookForReadOnlyFile := chkLookForReadOnly.Checked;
  FFileFinder.SearchOptions.LookForHiddenFile := chkLookForHidden.Checked;
  FFileFinder.SearchOptions.LookForSystemFile := chkLookForSystem.Checked;
  FFileFinder.SearchOptions.LookForArchiveFile := chkLookForArchive.Checked;
  btnStartSearch.Enabled := False;
  FFileFinder.Search;
end;

procedure TMainForm.DoOnFileFinderFileFound(Sender : TObject; FileFound : TBZFileInformations);
var
  idx : Integer;
begin
  //idx := FFileFinder.SearchResult.Count-1;
  //lbxSearchResult.Items.Add(FFileFinder.SearchResult.Strings[idx]);
  lbxSearchResult.Items.Add(FixPathDelimiter(IncludeTrailingPathDelimiter(FileFound.path))+FileFound.Name);
  Application.ProcessMessages;
end;

procedure TMainForm.DoOnFileFinderStart(Sender : TObject);
begin
  Screen.Cursor := crHourGlass;
  lbxSearchResult.Items.Clear;
  Application.ProcessMessages;
  lblStatus.Caption := 'Recherche en cours, veuillez patienter quelques instants...'
end;

procedure TMainForm.DoOnFileFinderCompleted(Sender : TObject; Stats : TBZSearchStatistics);
begin
  btnStartSearch.Enabled := True;
  Screen.Cursor := crDefault;
  lblNbFolderFound.Caption := Stats.NbPathFound.ToString;
  lblNbFilesFound.Caption := Stats.NbFilesFound.ToString;
  lblStatus.Caption := 'Recherche terminée.'
end;

procedure TMainForm.DoOnFileFinderChangeFolder(Sender : TObject; NewPath : String);
begin
  lblStatus.Caption := 'Recherche en cours dans : '+ MinimizeName(NewPath, lblStatus.Canvas, lblStatus.ClientWidth - lblStatus.Canvas.TextWidth('Recherche en cours dans : '));
end;

end.

