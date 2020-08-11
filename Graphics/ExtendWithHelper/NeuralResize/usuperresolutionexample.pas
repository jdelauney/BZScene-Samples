unit usuperresolutionexample;

{$mode objfpc}{$H+}

interface
uses
  neuralnetwork, Classes, SysUtils;

const
  csExampleBaseFileName: string = 'super-resolution-7-64-sep';
  csExampleFileName:string = 'super-resolution-7-64-sep.nn';
  csExampleBottleNeck:integer = 16;
  csExampleNeuronCount:integer = 64;
  csExampleLayerCount:integer = 7;
  csExampleIsSeparable:boolean =  true;

function CreateResizingNN(SizeX, SizeY: integer; FileName: string): THistoricalNets;
procedure LoadResizingWeights(NN: TNNet; FileName: string; FailIfNotFound: boolean = false);

implementation

function CreateResizingNN(SizeX, SizeY: integer; FileName: string): THistoricalNets;
var
  NN: THistoricalNets;
begin
  NN := THistoricalNets.Create();
  NN.AddSuperResolution({pSizeX=}SizeX, {pSizeY=}SizeY,
    {BottleNeck=}csExampleBottleNeck, {pNeurons=}csExampleNeuronCount,
    {pLayerCnt=}csExampleLayerCount, {IsSeparable=}csExampleIsSeparable);
  LoadResizingWeights(NN, FileName, true);
  Result := NN;
end;

procedure LoadResizingWeights(NN: TNNet; FileName: string; FailIfNotFound: boolean = false);
begin
  if FileExists(FileName) then
  begin
    NN.LoadDataFromFile(FileName);
   // WriteLn('Neural network file found:', FileName);
  end
  else
  if FileExists(FileName) then
  begin
    NN.LoadDataFromFile(FileName);
  end
  else
  begin
    if FailIfNotFound then
    begin
      Raise exception.Create('ERROR: '+FileName+' can''t be found. Please run SuperResolutionTrain.');
      ReadLn;
    end;
  end;
end;

end.
