unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ExtDlgs, ComCtrls, Spin, BZImageViewer,
  BZClasses, BZColors, BZGraphic, BZBitmap, {%H-}BZBitmapIO, BZInterpolationFilters;

type
  TBZBitmapTransformationsHelper = Class helper for TBZBitmapTransformations
  public
    procedure NeuralResizeTo(DestBmp : TBZBitmap; Const ScaleFactor : Byte);
  end;

  { TMainForm }
  TMainForm = class(TForm)
    cbxScaleFactor : TComboBox;
    cbxResampleFilter : TComboBox;
    GroupBox3 : TGroupBox;
    ImgNeuralResult : TBZImageViewer;
    Label2 : TLabel;
    Label3 : TLabel;
    Panel1 : TPanel;
    Panel2 : TPanel;
    Panel3 : TPanel;
    Panel4 : TPanel;
    GroupBox1 : TGroupBox;
    GroupBox2 : TGroupBox;
    ImgOriginal : TBZImageViewer;
    ImgResampleResult : TBZImageViewer;
    OPD : TOpenPictureDialog;
    btnLoad : TButton;
    gbxOptions : TGroupBox;
    Label1 : TLabel;
    btnApply : TButton;
    pbImageProgress : TProgressBar;
    lblAction : TLabel;
    procedure btnLoadClick(Sender : TObject);
    procedure cbxScaleFactorChange(Sender : TObject);
    procedure FormCreate(Sender : TObject);
    procedure FormDestroy(Sender : TObject);
    procedure btnApplyClick(Sender : TObject);
  private
    FTempBmp : TBZBitmap;
    FApplyFilter : Boolean;
  protected
    FTotalProgress : Byte;
    FScaleFactor : Byte;

    Procedure DoFilterProgress(Sender: TObject; Stage: TBZProgressStage; PercentDone: Byte; RedrawNow: Boolean; Const R: TRect; Const Msg: String; Var aContinue: Boolean);
  public
    procedure ApplyFilter;
  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses
  BZMath,
  neuralnetwork,
  neuralvolume,
  neuraldatasets,
  neuralfit,
  usuperresolutionexample;

const
  csTileSize = 16;
  csTileBorder = 4;

  function GetMaxDivisor(x, acceptableMax: integer): integer;
  begin
    Result := acceptableMax;
    while (Result > 2) do
    begin
      if X mod Result = 0 then break;
      Dec(Result);
    end;
  end;

{ TBZBitmapTransformationsHelper }

procedure TBZBitmapTransformationsHelper.NeuralResizeTo(DestBmp : TBZBitmap; const ScaleFactor : Byte);
var
  nw, nh : Integer;
var
  NN: TNNet;
  InputImgVol, OutputImgVol: TNNetVolume; //AuxInputImgVol,
  InputTile, OutputTile: TNNetVolume;
  MaxTileX, MaxTileY: integer;
  TileXCnt, TileYCnt: integer;
  TileStartX, TileStartY: integer;
  LocalDestX, LocalDestY: integer;
  LocalOriginX, LocalOriginY: integer;
  LocalLenX, LocalLenY: integer;
  LocalTileSizeX, LocalTileSizeY: integer;
  DeltaTile : Single;

  procedure LoadBitmapIntoVolume(M: TBZBaseBitmap; Vol:TNNetVolume);
  var
    CountX, CountY : integer;
    //PixelPtr : PBZColor;
    inColor : TBZColor;
    RawPos: integer;
    Delta : Single;
  begin
    StartProgressSection(33.333333,'Loading bitmap');
    Delta := 100 / M.Width;
    Vol.ReSize(M.Width, M.Height, 3);
    //PixelPtr := M.GetScanLine(0);
    for CountX := 0 to M.MaxWidth do
    begin
      for CountY := 0 to M.MaxHeight do
      begin
        RawPos := Vol.GetRawPos(CountX, CountY, 0);
        inColor := M.getPixel(CountX, CountY);
        Vol.FData[RawPos]     := inColor.Red; //PixelPtr^.red;
        Vol.FData[RawPos + 1] := inColor.Green; //PixelPtr^.green;
        Vol.FData[RawPos + 2] := inColor.Blue; //PixelPtr^.blue;

        //Vol.FData[RawPos + 3] := PixelPtr^.Alpha;
        //inc(PixelPtr);
      end;
      AdvanceProgress(Delta,0,1,True);
    end;
    FinishProgressSection(False);
  end;

  procedure LoadVolumeIntoBitmap(Vol:TNNetVolume; M: TBZBitmap);
  var
    CountX, CountY, MaxX, MaxY: integer;
    PixelPtr: PBZColor;
    OutColor : TBZColor;
    RawPos: integer;
    Delta : Single;
  begin
    MaxX := Vol.SizeX - 1;
    MaxY := Vol.SizeY - 1;
    M.SetSize(Vol.SizeX, Vol.SizeY);
    StartProgressSection(33.333333,'Transfert bitmap');
    Delta := 100 / Vol.SizeX;
    PixelPtr := M.GetScanLine(0);
    for CountX := 0 to MaxX do
    begin
      for CountY := 0 to MaxY do
      begin
        RawPos := Vol.GetRawPos(CountX, CountY, 0);
        OutColor.Create(NeuronForceMinMax(Round(Vol.FData[RawPos]),0,255),
                        NeuronForceMinMax(Round(Vol.FData[RawPos + 1]),0,255),
                        NeuronForceMinMax(Round(Vol.FData[RawPos + 2]),0, 255));
                        //NeuronForceMinMax(Round(Vol.FData[RawPos + 3]),0, 255));
         M.setPixel(CountX, CountY, OutColor);
        //OutColor.Create(ClampByte(Round(Vol.FData[RawPos])),
        //                ClampByte(Round(Vol.FData[RawPos + 1])),
        //                ClampByte(Round(Vol.FData[RawPos + 2])));
                        ////ClampByte(Round(Vol.FData[RawPos + 3])));
        //PixelPtr^ := OutColor;
        //Inc(PixelPtr);
      end;
      AdvanceProgress(Delta,0,1,True);
    end;
    FinishProgressSection(False);
  end;

begin
  nw := DestBmp.Width * ScaleFactor;
  nh := DestBmp.Height * ScaleFactor;
  DestBmp.SetSize(nw,nh);

  InputImgVol := TNNetVolume.Create();
  OutputImgVol := TNNetVolume.Create();
  initprogress(nw, nh);
  StartProgressSection(0,'');

  LoadBitmapIntoVolume(OwnerBitmap, InputImgVol);

  WriteLn('Input image size: ', InputImgVol.SizeX,' x ', InputImgVol.SizeY,' x ',InputImgVol.Depth);
  InputImgVol.Divi(64);
  InputImgVol.Sub(2);
  WriteLn('Creating Neural Network...');
  if InputImgVol.SizeX * InputImgVol.SizeY <= 128*128 then
  begin
    StartProgressSection(33.333333,'Neural Resizing ');
    WriteLn('Resizing...');
    NN := CreateResizingNN(InputImgVol.SizeX, InputImgVol.SizeY, csExampleFileName);
    AdvanceProgress(33.3333,0,1,True);
    NN.Compute(InputImgVol);
    AdvanceProgress(33.3333,0,1,True);
    NN.GetOutput(OutputImgVol);
    AdvanceProgress(33.3333,0,1,True);
  end
  else
  begin
    //NN := CreateResizingNN(csTileSize+csTileBorder*2, csTileSize+csTileBorder*2, csExampleFileName);
    //InputTile := TNNetVolume.Create(csTileSize+csTileBorder*2, csTileSize+csTileBorder*2, 3);
    //OutputTile := TNNetVolume.Create(csTileSize * 2 + csTileBorder*2, csTileSize * 2 + csTileBorder*2, 3);
    //MaxTileX := (InputImgVol.SizeX div csTileSize) - 1;
    //MaxTileY := (InputImgVol.SizeY div csTileSize) - 1;

    LocalTileSizeX := GetMaxDivisor(InputImgVol.SizeX-csTileBorder*2, 128);
    LocalTileSizeY := GetMaxDivisor(InputImgVol.SizeY-csTileBorder*2, 128);
    WriteLn('Resizing with tiles. Tile size is:', LocalTileSizeX, 'x', LocalTileSizeY, ' .');
    NN := CreateResizingNN(LocalTileSizeX+csTileBorder*2, LocalTileSizeY+csTileBorder*2, csExampleFileName);
    InputTile := TNNetVolume.Create(LocalTileSizeX+csTileBorder*2, LocalTileSizeY+csTileBorder*2, 3);
    OutputTile := TNNetVolume.Create(InputTile.SizeX*2, InputTile.SizeY*2, 3);
    MaxTileX := ( (InputImgVol.SizeX-csTileBorder*2) div LocalTileSizeX) - 1;
    MaxTileY := ( (InputImgVol.SizeY-csTileBorder*2) div LocalTileSizeY) - 1;
    StartProgressSection(33.333333,'Neural Resizing with tiles ');
    DeltaTile := 100 / (MaxTileX + 1);
    AdvanceProgress(0,0,1,True);

    OutputImgVol.Resize(InputImgVol.SizeX*2, InputImgVol.SizeY*2, 3);
    WriteLn('Resizing with tiles to: ', OutputImgVol.SizeX,' x ', OutputImgVol.SizeY,' x ',OutputImgVol.Depth);
    OutputImgVol.Fill(0);
    for TileXCnt := 0 to MaxTileX do
    begin
      for TileYCnt := 0 to MaxTileY do
      begin
        TileStartX := TileXCnt*LocalTileSizeX;
        TileStartY := TileYCnt*LocalTileSizeY;
        InputTile.CopyCropping
        (
          InputImgVol,
          TileStartX,
          TileStartY,
          LocalTileSizeX+csTileBorder*2,
          LocalTileSizeY+csTileBorder*2
        );
        NN.Compute(InputTile);
        NN.GetOutput(OutputTile);
        LocalDestX := TileXCnt*LocalTileSizeX*2+csTileBorder*2;
        LocalDestY := TileYCnt*LocalTileSizeY*2+csTileBorder*2;
        LocalOriginX := csTileBorder*2;
        LocalOriginY := csTileBorder*2;
        LocalLenX := LocalTileSizeX*2;
        LocalLenY := LocalTileSizeY*2;

        if ((TileXCnt = 0) or (TileXCnt = MaxTileX)) then
        begin
          LocalLenX := LocalLenX + csTileBorder*2;
          if (TileXCnt = 0) then
          begin
            LocalOriginX := 0;
            LocalDestX := 0;
          end;
        end;

        if ((TileYCnt = 0) or (TileYCnt = MaxTileY)) then
        begin
          LocalLenY := LocalLenY + csTileBorder*2;
          if (TileYCnt = 0) then
          begin
            LocalOriginY := 0;
            LocalDestY := 0;
          end;
        end;

        OutputImgVol.AddArea
        (
          {DestX=}LocalDestX,
          {DestY=}LocalDestY,
          {OriginX=}LocalOriginX,
          {OriginY=}LocalOriginY,
          {LenX=}LocalLenX,
          {LenY=}LocalLenY,
          OutputTile
        );
      end;
      AdvanceProgress(DeltaTile,0,1,True);
    end;
    InputTile.Free;
    OutputTile.Free;
  end;
    //if
    //  (InputImgVol.SizeX mod csTileSize < csTileBorder*2) or
    //  (InputImgVol.SizeY mod csTileSize < csTileBorder*2) then
    //begin
    //  AuxInputImgVol := TNNetVolume.Create();
    //  AuxInputImgVol.CopyPadding(InputImgVol, csTileBorder);
    //  InputImgVol.Copy(AuxInputImgVol);
    //  AuxInputImgVol.Free;
    //end;
  //  OutputImgVol.Resize((MaxTileX + 1)*csTileSize*2, (MaxTileY + 1)*csTileSize*2, 3);
  //
  //  OutputImgVol.Fill(0);
  //  for TileXCnt := 0 to MaxTileX do
  //  begin
  //    TileStartX := (TileXCnt*csTileSize);
  //    for TileYCnt := 0 to MaxTileY do
  //    begin
  //      TileStartY := (TileYCnt*csTileSize);
  //
  //      InputTile.CopyCropping
  //      (
  //        InputImgVol,
  //        TileStartX,
  //        TileStartY,
  //        csTileSize+csTileBorder*2,
  //        csTileSize+csTileBorder*2
  //      );
  //      NN.Compute(InputTile);
  //      NN.GetOutput(OutputTile);
  //      OutputImgVol.AddArea
  //      (
  //        {DestX=}TileXCnt*csTileSize*2,
  //        {DestY=}TileYCnt*csTileSize*2,
  //        {OriginX=}csTileBorder*2,
  //        {OriginX=}csTileBorder*2,
  //        {LenX=}csTileSize*2,
  //        {LenY=}csTileSize*2,
  //        OutputTile
  //      );
  //    end;
  //  end;
  //  InputTile.Free;
  //  OutputTile.Free;
  //end;
  OutputImgVol.Add(2);
  OutputImgVol.Mul(64);
  LoadVolumeIntoBitmap(OutputImgVol, DestBmp);
  FinishProgressSection(False);
  FinishProgressSection(True);
  OutputImgVol.Free;
  InputImgVol.Free;
  NN.Free;
end;

{ TMainForm }

procedure TMainForm.btnLoadClick(Sender : TObject);
begin
  if OPD.Execute then
  begin
    FApplyFilter := False;
    FTempBmp.LoadFromFile(OPD.FileName);
    ImgOriginal.Picture.Bitmap.Assign(FTempBmp);
    ImgOriginal.Invalidate;
    btnApply.Enabled := True;
    gbxOptions.Enabled := True;
  end;
end;

procedure TMainForm.cbxScaleFactorChange(Sender : TObject);
begin
  Case cbxScaleFactor.ItemIndex of
    0 : FScaleFactor :=  2;
    1 : FScaleFactor :=  4;
    2 : FScaleFactor :=  8;
    3 : FScaleFactor :=  16;
    4 : FScaleFactor :=  32;
  end;
end;

procedure TMainForm.FormCreate(Sender : TObject);
var
  sl : TStringList;
begin

  FTempBmp := TBZBitmap.Create;
  FTempBmp.OnProgress := @DoFilterProgress;
  FTotalProgress := 0;
  sl := TStringList.Create;
  GetBZInterpolationFilters.BuildStringList(sl);
  cbxResampleFilter.Items.Assign(sl);
  FreeAndNil(sl);
  cbxResampleFilter.ItemIndex := 0;
  FScaleFactor := 2;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
begin
  FreeAndNil(FTempBmp);
end;

procedure TMainForm.btnApplyClick(Sender : TObject);
begin
  ApplyFilter;
end;


Procedure TMainForm.DoFilterProgress(Sender : TObject; Stage : TBZProgressStage; PercentDone : Byte; RedrawNow : Boolean; Const R : TRect; Const Msg : String; Var aContinue : Boolean);
begin
  Case Stage Of
    opsStarting, opsRunning:
    Begin
      FTotalProgress := PercentDone;
      lblAction.Caption := Msg + ' - ' + IntToStr(FTotalProgress) + '%';
      pbImageProgress.Position := FTotalProgress;
      if FApplyFilter then
      begin
        if RedrawNow then Application.ProcessMessages;
      end else Application.ProcessMessages;
    End;
    opsEnding:
    Begin
      lblAction.Caption := '';
      pbImageProgress.Position := 0;
      FTotalProgress := 0;
    End;
  End;
end;

procedure TMainForm.ApplyFilter;
begin

  FApplyFilter := True;

  Screen.Cursor := crHourGlass;
  FTempBmp.Transformation.OnProgress := @DoFilterProgress;

  FTempBmp.Transformation.ResampleTo(ImgResampleResult.Picture.Bitmap,(FTempBmp.Width * FScaleFactor), (FTempBmp.Height * FScaleFactor), TBZInterpolationFilterMethod(cbxResampleFilter.ItemIndex));

  FTempBmp.Transformation.NeuralResizeTo(ImgNeuralResult.Picture.Bitmap, FScaleFactor);


  ImgResampleResult.Invalidate;
  ImgNeuralResult.Invalidate;
  Screen.Cursor := crDefault;
end;

end.
