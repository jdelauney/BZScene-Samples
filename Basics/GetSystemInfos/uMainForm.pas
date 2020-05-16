unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls,
  // BZScene
  BZSystem;

type

  { TMainForm }

  TMainForm = class(TForm)
    CheckBox1:  TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox2:  TCheckBox;
    CheckBox3:  TCheckBox;
    CheckBox4:  TCheckBox;
    CheckBox5:  TCheckBox;
    CheckBox6:  TCheckBox;
    CheckBox7:  TCheckBox;
    CheckBox8:  TCheckBox;
    CheckBox9:  TCheckBox;
    GroupBox1:  TGroupBox;
    GroupBox2:  TGroupBox;
    GroupBox3:  TGroupBox;
    GroupBox4:  TGroupBox;
    Label1:     TLabel;
    Label10:    TLabel;
    Label11:    TLabel;
    Label12:    TLabel;
    Label13:    TLabel;
    Label14:    TLabel;
    Label15:    TLabel;
    Label16:    TLabel;
    Label17:    TLabel;
    Label18:    TLabel;
    Label19:    TLabel;
    Label2:     TLabel;
    Label20:    TLabel;
    Label21:    TLabel;
    Label22:    TLabel;
    Label23:    TLabel;
    Label24:    TLabel;
    Label25:    TLabel;
    Label26:    Tlabel;
    Label27:    Tlabel;
    Label28:    Tlabel;
    Label29:    Tlabel;
    Label3:     TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    lblMemFreeSwap: TLabel;
    lblMemTotalSwap: TLabel;
    lblMemFreeVirtual: TLabel;
    lblMemTotalVirtual: TLabel;
    Label4:     TLabel;
    lblMemFreePhys: TLabel;
    lblMemTotalPhys: TLabel;
    Label5:     TLabel;
    Label6:     TLabel;
    Label7:     TLabel;
    Label8:     TLabel;
    Label9:     TLabel;
    PageControl1: TPageControl;
    TabSheet1:  TTabSheet;
    TabSheet2:  TTabSheet;
    TabSheet3:  TTabSheet;
    TabSheet4: TTabSheet;
    Label36 : TLabel;
    lblMemDiskSize : TLabel;
    Label37 : TLabel;
    lblMemDiskFreeSpace : TLabel;
    Panel1 : TPanel;
    Label38 : TLabel;
    lblUsername : TLabel;

    procedure FormShow(Sender: TObject);

  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

Uses
 BZUtils;
{ TMainForm }

procedure TMainForm.FormShow(Sender: TObject);
var
  ms : TBZMemoryStatus;
begin
  Label3.Caption  := BZCPUInfos.BrandName;
  Label4.Caption  := BZCPUInfos.Vendor;
  Label23.Caption := inttostr(BZCPUInfos.ProcessorType);
  Label24.Caption := inttostr(BZCPUInfos.Stepping);
  Label14.Caption := inttostr(BZCPUInfos.Model);
  Label16.Caption := inttostr(BZCPUInfos.ExtModel);
  Label20.Caption := inttostr(BZCPUInfos.Familly);
  Label17.Caption := inttostr(BZCPUInfos.ExtFamilly);

  Label6.Caption := inttostr(BZCPUInfos.LogicalProcessors);
  Label8.Caption := inttostr(BZCPUInfos.Speed) + ' Mhz';
  if CPU_HasFeature(cf3DNow) then CheckBox1.State := cbGrayed;
  if CPU_HasFeature(cf3DNowExt) then CheckBox2.State := cbGrayed;
  if CPU_HasFeature(cfMMX) then CheckBox3.State := cbGrayed;
  if CPU_HasFeature(cfEMMX) then CheckBox4.State := cbGrayed;
  if CPU_HasFeature(cfSSE) then CheckBox5.State := cbGrayed;
  if CPU_HasFeature(cfSSE2) then CheckBox6.State := cbGrayed;
  if CPU_HasFeature(cfSSE3) then CheckBox7.State := cbGrayed;
  if CPU_HasFeature(cfSSE41) then CheckBox8.State := cbGrayed;
  if CPU_HasFeature(cfSSE42) then CheckBox9.State := cbGrayed;
  if CPU_HasFeature(cfSSE4A) then CheckBox10.State := cbGrayed;
  if CPU_HasFeature(cfAVX) then CheckBox11.State := cbGrayed;
  if CPU_HasFeature(cfFMA3) then CheckBox12.State := cbGrayed;
  if CPU_HasFeature(cfFMA4) then CheckBox13.State := cbGrayed;
  if CPU_HasFeature(cfAES) then CheckBox14.State := cbGrayed;

  Label10.Caption := GetPlatformVersionAsString;
  Label11.Caption := GetDeviceCapabilitiesAsString;

  Label25.Caption := GetTempFolderPath;
  Label27.Caption := GetApplicationFileName;
  Label29.Caption := GetApplicationPath;

  ms := GetMemoryStatus;
  lblMemTotalPhys.Caption := FormatByteSize(ms.TotalPhys);
  lblMemFreePhys.Caption := FormatByteSize(ms.AvailPhys);
  lblMemTotalVirtual.Caption := FormatByteSize(ms.TotalVirtual);
  lblMemFreeVirtual.Caption := FormatByteSize(ms.AvailVirtual);
  lblMemTotalSwap.Caption := FormatByteSize(ms.TotalPageFile);
  lblMemFreeSwap.Caption := FormatByteSize(ms.AvailPageFile);

  lblMemDiskSize.Caption := GetCurrentDiskSize;
  lblMemDiskFreeSpace.Caption := GetCurrentFreeDiskSpace;

  lblUserName.Caption := GetCurrentUserName;

end;

end.


