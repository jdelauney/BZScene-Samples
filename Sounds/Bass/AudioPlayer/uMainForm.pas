unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  BZCadencer, BZSound, BZBassManager,
  BZSoundSample, BZSoundFileWAV,  BZSoundFileMP3 , BZSoundFileOGG {$IFDEF WINDOWS}, BZSoundFileModplug{$ENDIF};


type
  TMainForm = class(TForm)
    Button1 : TButton;
    Button2 : TButton;
    Button3 : TButton;
    Button4 : TButton;
    GroupBox1 : TGroupBox;
    Label1 : TLabel;
    Label11 : TLabel;
    Label13 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    lblDuration : TLabel;
    lblFileName : TLabel;
    lblFrequency : TLabel;
    lblNbBits : TLabel;
    lblNbChannels : TLabel;
    OpenDialog : TOpenDialog;
    ProgressBar1 : TProgressBar;
    Timer1 : TTimer;
    TrackBar1 : TTrackBar;
    TrackBar3 : TTrackBar;
    procedure Button1Click(Sender : TObject);
    procedure Button2Click(Sender : TObject);
    procedure Button3Click(Sender : TObject);
    procedure Button4Click(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure Timer1Timer(Sender : TObject);
    procedure TrackBar1Change(Sender : TObject);
    procedure TrackBar3Change(Sender : TObject);
  private

  public
    SoundManager : TBZSoundBassManager;
    SoundLibrary : TBZSoundLibrary;
    SoundFXLibrary : TBZSoundFXLibrary;
    SoundSources : TBZSoundSources;
    SoundSource  : TBZSoundSource;
    Cadencer : TBZCadencer;
    ReverbFX : TBZReverbSoundEffect;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}


uses uBassInfosForm;
{ TMainForm }

procedure TMainForm.Button1Click(Sender : TObject);
begin

  if OpenDialog.Execute then
  begin
    Cadencer.Enabled := False;
    SoundLibrary.Samples.Clear;
    SoundLibrary.Samples.AddFile(OpenDialog.FileName,ExtractFileName(OpenDialog.FileName));
    SoundManager.Sources.Items[0].SoundName := ExtractFileName(OpenDialog.FileName);
    //SoundManager.Sources.Items[0].UseEnvironnment := true;

    lblFileName.Caption := SoundManager.Sources.Items[0].SoundName;
    lblFrequency.Caption := InttoStr(SoundManager.Sources.Items[0].Sample.Data.Frequency)+' Mhz';
    lblNbChannels.Caption := InttoStr(SoundManager.Sources.Items[0].Sample.Data.NbChannels);
    lblNbBits.Caption := InttoStr(SoundManager.Sources.Items[0].Sample.Data.BitsPerSample);
    lblDuration.Caption := FloatToStr(SoundManager.Sources.Items[0].Sample.Data.LengthInSec)+' Sec';
    ProgressBar1.Max := SoundManager.Sources.Items[0].Sample.Data.LengthInBytes;
    //ProgressBar1.Position :=ProgressBar1.Max div 2;
    //showmessage(InttoStr(SoundManager.Sources.Items[0].Sample.LengthInBytes));
    Timer1.Enabled:=True;
    //InttoStr(SoundManager.Sources.Items[0].Sample.Data.getSoundDataSize);
    //
   // SoundManager.Active := True;
  End;
end;

procedure TMainForm.Button2Click(Sender : TObject);
begin
  SoundManager.Sources.Items[TButton(Sender).Tag].Playing := not(SoundManager.Sources.Items[TButton(Sender).Tag].Playing);
  Cadencer.Enabled := SoundManager.Sources.Items[TButton(Sender).Tag].Playing;
end;

procedure TMainForm.Button3Click(Sender : TObject);
begin
  SoundManager.Sources.Items[TButton(Sender).Tag].Pause := not(SoundManager.Sources.Items[TButton(Sender).Tag].Pause);
end;

procedure TMainForm.Button4Click(Sender : TObject);
begin
  BassInfosForm.Show;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  Cadencer.Enabled := False;
  FreeAndNil(SoundManager);
  FreeAndNil(SoundLibrary);
  FreeAndNil(Cadencer);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  SoundManager :=  TBZSoundBassManager.Create(Self);
  Cadencer := TBZCadencer.Create(self);
  Cadencer.Enabled := False;
  SoundManager.Cadencer := Cadencer;
  SoundLibrary := TBZSoundLibrary.Create(self);
  SoundFXLibrary := TBZSoundFXLibrary.Create(self);

  SoundManager.Sources.Add;
  SoundManager.Sources.Items[0].SoundLibrary := SoundLibrary;
  SoundManager.Sources.Items[0].SoundFXLibrary := SoundFXLibrary;
  //ShowMessage('Lib FX Count : '+IntToStr(SoundFXLibrary.FX.Count));
  with SoundFXLibrary.FX.AddFilterLowPass('Custom_LP_Filter') Do
  begin
    Gain := 0.3;
    GainHF := 0.3;
  end;
  //ShowMessage('Lib FX Count : '+IntToStr(SoundFXLibrary.FX.Count));
  SoundManager.Sources.Items[0].DirectFilter := 'Custom_LP_Filter';
  SoundManager.Sources.Items[0].DirectFilterActivated := true;

  with SoundFXLibrary.FX.AddEffectReverb('EAX_Reverb_Test') Do
  begin
    preset := seConcertHall;
  end;

  With SoundManager.Sources.Items[0].AuxSlots.Add do
  begin
    SoundFXLibrary := Self.SoundFXLibrary;
    Name := 'EAX_Reverb_Test';
    Activated := False;
  end;

(*  SoundManager.Sources.Items[0].DirectFilteringType := ftLowPass;
  TBZLowPassSoundFilter(SoundManager.Sources.Items[0].DirectFilter).Gain:=0.5;
  TBZLowPassSoundFilter(SoundManager.Sources.Items[0].DirectFilter).GainHF:=0.5;

  ReverbFX := TBZReverbSoundEffect.Create(SoundManager.Sources.Items[0].Effects);
  SoundManager.Sources.Items[0].Effects.AddEffect(ReverbFX);
  SoundManager.Sources.Items[0].ActiveEffects:=true; *)

  OpenDialog.Filter := 'Tous les fichier audio|*.wav;*.ogg;*.mp3;*.mod;*.s3m;*.xm;*.it|Microsoft WAV File Format|*.wav|OGG Vorbis File Format|*.ogg|MP3 File Format|*.mp3|Module Tracker File Format|*.mod;*.s3m;*.xm;*.it';
  Cadencer.Enabled := True;
  SoundManager.Active := True;
  BassInfosForm.Memo1.Lines.Add(SoundManager.getInformations);
end;

procedure TMainForm.Timer1Timer(Sender : TObject);
begin
  ProgressBar1.Position:=SoundManager.Sources.Items[0].TimePositionInByte;
end;

procedure TMainForm.TrackBar1Change(Sender : TObject);
begin
  SoundManager.Sources.Items[TTrackBar(Sender).Tag].Volume:=TTrackBar(Sender).Position / 100;
end;

procedure TMainForm.TrackBar3Change(Sender : TObject);
begin
 SoundManager.MasterVolume:= TrackBar3.position / 100;
end;

end.

