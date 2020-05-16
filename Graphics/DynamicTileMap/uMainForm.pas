unit uMainForm;

{$mode objfpc}{$H+}
{$modeswitch advancedrecords}


// Note le calcul de la position du curseur en pixel sur la carte est erroné.

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  FileUtil,
  BZColors, BZClasses, BZGraphic, BZBitmap, BZBitmapIO, BZVectorMath, BZTileMapEngine;

Const
  cTileWidth = 256;
  cTileHeight = 256;
  cDisplayWidth = 1024;
  cDisplayHeight = 600;
  cMapRootDir ='..\..\..\Ressources\Map\';
  cTileMapWidthMin = 5;
  cTileMapHeightMin = 5;

Const
  cEarthCircumferenceAtEquator = 2 * PI * 6378137;
  cEarthCircumferenceInMetersAtEquator = 40075017;

Type
  TLatLonArray = Array[0..1] of Double;
  { TLatLon : Type pour manipuler la latitude et la longitude exprimées en degrés }
  TLatLon = record
  public
    { Creation de la latitude et longitude exprimées en degrés }
    procedure Create(Lat, Lon : Double);
    { Creation de la latitude et longitude depuis les indices et le niveau de zoom d'OpenStreetMap }
    procedure CreateFromTileOSM(LatIndice, LonIndice, ZoomLevel : Integer);

    { Retourne la latitude comprise entre [-90, 90] et la longitude entre [-180,180] }
    function Wrap : TLatLon;
    { Retourne un chaine formaté de la latitude et de la longitude }
    function ToString : String;

    { Retourne les indices des tuiles OpenStreetMap par rapport au niveau de zoom }
    function ToTileOSM(ZoomLevel : Integer) : TBZPoint;

    { Retourne la cironférence de la terre par rapport à la latitude }
    function GetCircumferenceAtLatitude : Double;

    Case Byte of
      0 : (V : TLatLonArray);
      1 : (Latitude : Double ;Longitude : Double);
  end;

  TLatLonBoundsArray = Array[0..3] of Double;
  { TLatLonBounds : Type pour manipuer une boite englobante exprimée en latitude et longitude }
  TLatLonBounds = record
  public
    { Creation de la boite englobante depuis 2 coordonées latitude/Longitude }
    procedure Create(LatMin, LonMin, LatMax, LonMax : Double); overload;
    { Creation de la boite englobante depuis 2 coordonées  de type TLatLon }
    procedure Create(TopLeft, BottomRight : TLatLon);  overload;
    { Retourne un chaine formaté de la boite englobante }
    function ToString : String;

    { Retourne la longitude Nord }
    function GetNorth : Double;
    { Retourne la latitude Est }
    function GetEast : Double;
    { Retourne la longitude Sud }
    function GetSouth : Double;
    { Retourne la latitude Ouest }
    function GetWest : Double;
    { Retourne la latitdue et la longitude Nord-Est }
    function GetNorthEast : TLatLon;
    { Retourne la latitdue et la longitude Sud-Ouest }
    function GetSouthWest : TLatLon;
    { Retourne la latitdue et la longitude Nord-Ouest }
    function GetNorthWest : TLatLon;
    { Retourne la latitdue et la longitude Sud-Est }
    function GetSouthEast : TLatLon;

    { Retourne le centre de la boite englobante de type TLatLon }
    function GetCenter : TLatLon;

    { Retourne @True si la coordonnée de type TLatLon est contenue dans la boite englobante }
    function Contains(Coord : TLatLon) : Boolean; overload;
    { Retourne @True si la coordonnée de latitude et longitude passé en paramètre est contenue dans la boite englobante }
    function Contains(Lat, Lon : Double) : Boolean; overload;

    Case Byte of
      0 : (V : TLatLonBoundsArray);
      1 : (NorthEast : TLatLon ; SouthWest : TLatLon);
  end;

  //TMercatorCoordArray = Array[0..2] of Double;
  //TMercatorCoordinate = record
  //public
  //  procedure Create( ax, ay, az : Double);
  //  procedure CreateFromLatLon(Lat, Lon, Altitude : Double); overload;
  //  procedure CreateFromLatLon(LatLon : TLatLon; Altitude : Double); overload;
  //
  //  function ToLatLon : TLatLon;
  //  function ToAltitudeInMeters : Double;
  //
  //  Case Byte of
  //   0 : (V : TMercatorCoordArray);
  //   1 : (X : Double; Y : Double; Z : Double);
  //end;

Type
  TBZTileInfosRec = packed record
    LatIndice, LonIndice : Integer;
    Longitude, Latitude : Double;
    //Coord : TLatLon;
  end;
  PBZTileInfosRec = ^TBZTileInfosRec;

  //TBZTileMapOSM = class(TBZCustomTileMap)

Type
  TMoveKind = (mkNone, mkUp, mkDown, mkLeft, mkRight, mkUpLeft, mkUpRight, mkDownLeft, mkDownRight);

Const
  strMoveKind : Array[TMoveKind] of String = ('Aucun', 'Haut', 'Bas', 'Gauche', 'Droite', 'Haut-Gauche', 'Haut-Droit', 'Bas-Gauche', 'Bas-Droit');

Type
  TThreadTileLoader = class(TThread)
  protected
  public
  end;



type

  { TMainForm }

  TMainForm = class(TForm)
    pnlView : TPanel;
    lblCursorPos : TLabel;
    Panel1 : TPanel;
    GroupBox1 : TGroupBox;
    Label1 : TLabel;
    lblDisplaySize : TLabel;
    lblSurfaceMapSize : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    lblPixelMapSize : TLabel;
    Label2 : TLabel;
    lblTileMapPos : TLabel;
    GroupBox2 : TGroupBox;
    chkFreeMove : TCheckBox;
    Label7 : TLabel;
    cbxChooseMap : TComboBox;
    cbxChooseZoomLevel : TComboBox;
    Label8 : TLabel;
    Label9 : TLabel;
    lblSizeMapTile : TLabel;
    lblPixelTileMapPos : TLabel;
    Label10 : TLabel;
    Panel2 : TPanel;
    lblStatus : TLabel;
    Label11 : TLabel;
    lblSizeMapBufferTile : TLabel;
    Label12 : TLabel;
    lblSizeDisplayTile : TLabel;
    Bevel1 : TBevel;
    Label13 : TLabel;
    lblMapPosCoord : TLabel;
    Label14 : TLabel;
    Label15 : TLabel;
    lblTileCoordMin : TLabel;
    lblTileCoordMax : TLabel;
    chkMapRenderGrid : TCheckBox;
    procedure FormCreate(Sender : TObject);
    procedure pnlViewPaint(Sender : TObject);
    procedure pnlViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
    procedure pnlViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
    procedure FormDestroy(Sender : TObject);
    procedure cbxChooseMapSelect(Sender : TObject);
    procedure cbxChooseZoomLevelSelect(Sender : TObject);
    procedure FormKeyPress(Sender : TObject; var Key : char);
    procedure chkMapRenderGridChange(Sender : TObject);
    procedure chkFreeMoveClick(Sender : TObject);
  private
    FDisplayTilesH, FDisplayTilesV : Integer; // Nombre de tuiles affichées horizontalement et verticalement
    FMapTileWidth, FMapTileHeight : Integer;  // Nombre de tuiles Chargées horizontalement et verticalement

    //FMouseLimit : TBZRect;

    FTileSet : TBZTileSet;
    FCurrentMap : String;
    FMap : TBZCustomTileMap;
    FMapBuffer : TBZBitmap;
    FMapLoaded : Boolean;

    FMouseCursor : TBZBitmap;
    FCenterCursor : TBZBitmap;

    FDisplayBuffer : TBZBitmap;
    FDisplayDiff : TBZPoint;

    FMouseDown : Boolean;
    FMousePos, FDistanceMove, FDisplayCenter : TBZPoint;
    FDisplayPos : TBZPoint;
    FMoveKind : TMoveKind;
  protected

    procedure FindMaps;
    procedure FindZoomLevels(aMap : String);
    procedure LoadMap(aMap : String; ZoomLevel : Integer);

    procedure UpdateInfos;
    procedure UpdateMapBuffer;
    procedure RenderDisplayBuffer;
  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses Math, BZMath, BZSystem, BZUtils, BZFileFinder, BZTypesHelpers, BZLogger;

function CoordinatesToPixelInTile(Lat, Lon, Zoom : Double; Const TileSize : Word = 256) : TBZPoint;
VAr
  Res : Double;
begin
  res := 180 / TileSize / power(2,zoom);
  Result.X := Math.Floor((180 + lat) / res);
  Result.Y := Math.Floor((90 + lon) / res);
end;

function PixelToOSMCoordinates(x, y, Zoom : Integer; Const TileSize : Word = 256) : TBZFloatPoint;
Var
  pw, mapSize, n : Double;
  //tileX, tileY : Integer;
begin
  pw := Pow(2.0, Zoom);
  mapSize := (pw * TileSize) - 1;
  //tileX := Trunc(X / TileSize);
  //tileY := Trunc(Y / TileSize);

  n := cPI - ((c2PI * ((Y mod Trunc(mapSize)) * TileSize)) / pw);

  Result.X := (((X mod Trunc(mapSize)) * TileSize) / pw * 360.0) - 180.0;
  Result.Y := 180.0 / cPI * System.Arctan(Math.Sinh(n));

  if Result.X >= 180 then
    Result.X := Result.X - 360
  else if Result.X <= -180 then
    Result.X := Result.X + 360;

  //if Result.Y > 90 then
  //  Result.Y := Result.Y - 180
  //else if Result.Y < -90 then
  //  Result.Y := Result.Y + 180;

end;

function TileOSMToCoordinates(LonIndice, LatIndice, Zoom : Double) : TBZFloatPoint;
var
  lat_rad, n: Double;
begin
  n := Power(2, zoom);
  Result.X := LonIndice / n * 360.0 - 180.0;
  lat_rad := Arctan(Sinh (cPi * (1 - 2 * LatIndice / n)));
  Result.Y := RadiantoDeg (lat_rad);
end;

function CoordinatesToTilesOSM(Lat, Lont, Zoom : Double): TBZPoint;
Var
  n, lat_rad : Double;
begin
  lat_rad := DegToRadian(lat);
  n := Power(2, zoom);
  Result.X := Trunc(((lont + 180) / 360) * n);
  Result.Y := Trunc((1 - (ln(Math.Tan(lat_rad) + (1 /System.Cos(lat_rad))) / cPi)) / 2 * n);
end;

function PixelToCoordinates(x,y, mx,my : Integer) : TBZFloatPoint;
var
  y2 : Double;
begin
  Result.y := ((y/my) * 360 - 180);
  y2 := 180 - (x/mx) * 360;
  Result.x :=  (360 / PI * System.arctan(System.exp(y2 * PI / 180)) - 90);

  if Result.X >= 180 then
    Result.X := Result.X - 360
  else if Result.X <= -180 then
    Result.X := Result.X + 360;
  Result.Y := -Result.Y;
end;

{%region=====[ TLatLon ]===================================================================================================}

procedure TLatLon.Create(Lat, Lon : Double);
begin
  Self.Latitude := Lat;
  Self.Longitude := Lon;
end;

procedure TLatLon.CreateFromTileOSM(LatIndice, LonIndice, ZoomLevel : Integer);
var
  lat_rad, n: Double;
begin
  n := Power(2, ZoomLevel);
  Self.Longitude := LonIndice / n * 360.0 - 180.0;
  lat_rad := Arctan(Sinh (cPi * (1 - 2 * LatIndice / n)));
  Self.Latitude := RadiantoDeg (lat_rad);
end;

function TLatLon.Wrap : TLatLon;
Var
  lat, lon : Double;
begin
  Lat := Self.Latitude;
  Lon := Self.Longitude;
  if Lat > 90 then Lat := lat - 90;
  if Lat < -90 then Lat := Lat + 90;
  if Lon > 180 then Lon := Lon - 180;
  if Lon < -180 then Lon := Lon + 180;
  Result.Create(Lat, Lon);
end;

function TLatLon.ToString : String;
begin
  Result := '(Latitude  : '+FloattoStrF(Self.Latitude,fffixed,5,5)+
           ', Longitude : '+FloattoStrF(Self.Longitude,fffixed,5,5)+')';
end;

function TLatLon.ToTileOSM(ZoomLevel : Integer) : TBZPoint;
Var
  n, lat_rad : Double;
begin
  lat_rad := DegToRadian(Self.Latitude);
  n := Power(2, ZoomLevel);
  Result.X := Trunc(((Self.Longitude + 180) / 360) * n);
  Result.Y := Trunc((1 - (ln(Math.Tan(lat_rad) + (1 /System.Cos(lat_rad))) / cPi)) / 2 * n);
end;

//function TLatLon.toBounds(Radius : Double) : TLonLatBounds;
//Var
//  LatAc, LonAc : Double;
//begin
//  latAc := 360 * radius / earthCircumferenceInMetersAtEquator,
//  lonAc = latAc / System.cos((cPI / 180) * Self.lat);
//
//   return new LngLatBounds(new LngLat(this.lng - lngAccuracy, this.lat - latAccuracy),
//              new LngLat(this.lng + lngAccuracy, this.lat + latAccuracy));
//end;

function TLatLon.GetCircumferenceAtLatitude : Double;
begin
  Result := cEarthCircumferenceAtEquator * System.cos(Self.Latitude * System.PI / 180);
end;

{%endregion%}

{%region=====[ TLatLonBounds ]=============================================================================================}

procedure TLatLonBounds.Create(LatMin, LonMin, LatMax, LonMax : Double);
begin
  Self.NorthEast.Create(LatMin, LonMin);
  Self.SouthWest.Create(LatMax, LonMax);
end;

procedure TLatLonBounds.Create(TopLeft, BottomRight : TLatLon);
begin
  Self.NorthEast := TopLeft;
  Self.SouthWest := BottomRight;
end;

function TLatLonBounds.ToString : String;
begin
  Result := '(NE : ' + Self.NorthEast.ToString +
           ', SW : ' + Self.SouthWest.ToString + ')';
end;

function TLatLonBounds.GetNorth : Double;
begin
  Result := Self.NorthEast.Longitude;
end;

function TLatLonBounds.GetEast : Double;
begin
  Result := Self.NorthEast.Latitude;
end;

function TLatLonBounds.GetSouth : Double;
begin
  Result := Self.SouthWest.Longitude;
end;

function TLatLonBounds.GetWest : Double;
begin
  Result := Self.SouthWest.Latitude;
end;

function TLatLonBounds.GetNorthEast : TLatLon;
begin
  Result := Self.NorthEast;
end;

function TLatLonBounds.GetSouthWest : TLatLon;
begin
 Result := Self.SouthWest;
end;

function TLatLonBounds.GetNorthWest : TLatLon;
begin
  Result.Create(GetWest, GetNorth);
end;

function TLatLonBounds.GetSouthEast : TLatLon;
begin
  Result.Create(GetEast, GetSouth);
end;

function TLatLonBounds.GetCenter : TLatLon;
begin
  Result.Create((Self.SouthWest.Latitude + Self.NorthEast.Latitude) / 2, (Self.SouthWest.Longitude + Self.NorthEast.Longitude) / 2);
end;

function TLatLonBounds.Contains(Coord : TLatLon) : Boolean;
Var
  InLatitude, InLongitude : Boolean;
begin
  InLatitude := ((Self.SouthWest.Latitude <= Coord.Latitude) and (Coord.Latitude <= Self.NorthEast.Latitude));
  InLongitude := ((Self.SouthWest.Longitude <= Coord.Latitude) and (Coord.Latitude <= Self.NorthEast.Longitude));
  Result := InLatitude And InLongitude;
end;

function TLatLonBounds.Contains(Lat, Lon : Double) : Boolean;
Var
  c : TLatLon;
begin
  c.Create(Lat,Lon);
  Result := Self.Contains(c{%H-});
end;

{%endregion%}



{ TMainForm }

procedure TMainForm.FormCreate(Sender : TObject);
begin
  FDisplayBuffer := TBZBitmap.Create(cDisplayWidth,  cDisplayHeight);

  FDisplayTilesH := Ceil(cDisplayWidth / cTileWidth);
  FDisplayTilesV := Ceil(cDisplayHeight / cTileHeight);
  lblDisplaySize.Caption := FDisplayBuffer.Width .ToString + 'x' + FDisplayBuffer.Height .ToString;

  FMapTileWidth  := FDisplayTilesH + 1;
  FMapTileHeight := FDisplayTilesV + 2;

  FMapBuffer := TBZBitmap.Create(FMapTileWidth  * cTileWidth, FMapTileHeight * cTileHeight);
  FDisplayDiff.Width := (FMapBuffer.Width - FDisplayBuffer.Width) div 2;
  FDisplayDiff.Height := (FMapBuffer.Height - FDisplayBuffer.Height) div 2;
  lblSurfaceMapSize.Caption := FMapBuffer.Width .ToString + 'x' + FMapBuffer.Height .ToString;

  FMoveKind := mkNone;

  //------------------------------------------------------------------
  FCurrentMap := '';
  FTileSet := TBZTileSet.Create;
  FMap := TBZCustomTileMap.Create(FDisplayBuffer, FTileSet, cTileMapWidthMin, cTileMapHeightMin, cTileWidth, cTileHeight );
  //FMap.LinkCameraToCursor := True;
  FMap.TileMapKind := tmkDynamic;
  FMap.AutoMapCacheSize := True;
  FMap.UseMapCache := True;

  lblPixelMapSize.Caption := FMap.MapSizeInPixel.Width.ToString + 'x' + FMap.MapSizeInPixel.Height.ToString;
  lblSizeMapTile.Caption := FMap.MapWidth.ToString + 'x' + FMap.MapHeight.ToString;

  FMouseCursor := TBZBitmap.Create;
  FMouseCursor.LoadFromFile('../../../Ressources/viseur_croixB.png');
  FCenterCursor := TBZBitmap.Create;
  FCenterCursor.LoadFromFile('../../../Ressources/viseur_croix.png');
  FMouseDown := False;
  FMapLoaded := False;
  FindMaps;
end;

procedure TMainForm.FormDestroy(Sender : TObject);
Var
  i : Integer;
begin
  FreeAndNil(FMouseCursor);
  FreeAndNil(FCenterCursor);
  FreeAndNil(FMapBuffer);
  For i := 0 to FTileSet.Count - 1 do
  begin
    Dispose(PBZTileInfosRec(FTileSet.Items[i].TagPointer));
  end;
  FreeAndNil(FTileSet);
  FreeAndNil(FDisplayBuffer);
end;

procedure TMainForm.pnlViewPaint(Sender : TObject);
begin
  RenderDisplayBuffer;
end;

procedure TMainForm.pnlViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
  if Button = mbLeft then
  begin
    FMouseDown := True;
    FDistanceMove.Create(0,0);
    FMousePos.Create(X, Y);
    pnlView.Invalidate;
  end;
end;

procedure TMainForm.pnlViewMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
begin
   FMouseDown := False;
   FMousePos.Create(X, Y);
   FDistanceMove.Create(0,0);
   pnlView.Invalidate;
end;

procedure TMainForm.pnlViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
begin
  if FMouseDown then
  begin
    FMousePos.Create(X, Y);
    FDisplayPos.X := (FMousePos.X div cTileWidth);
    FDisplayPos.Y := (FMousePos.Y div cTileHeight);
    FDistanceMove := FMousePos - FDisplayCenter;

    if FDistanceMove.X = 0 then
    begin
      if FDistanceMove.Y = 0 then
        FMoveKind:= mkNone
      else if FDistanceMove.Y > 0 then
        FMoveKind:= mkDown
      else
        FMoveKind := mkUp;
    end
    else if FDistanceMove.X > 0 then
    begin
      if FDistanceMove.Y = 0 then
         FMoveKind:= mkRight
      else if FDistanceMove.Y > 0 then
        FMoveKind:= mkDownRight
      else
        FMoveKind := mkUpRight;
    end
    else
    begin
      if FDistanceMove.Y = 0 then
         FMoveKind:= mkLeft
      else if FDistanceMove.Y > 0 then
        FMoveKind:= mkDownLeft
      else
        FMoveKind := mkUpLeft;
    end;
    ////FDistanceMove := FDistanceMove.Clamp(-128,128);
    //if (FDistanceMove.X < -128) or (FDistanceMove.X > 128) or  (FDistanceMove.Y < -128) or  (FDistanceMove.Y > 128) then
    //begin
    //  UpdateMapBuffer;
    //end
    //else
    //begin
    //  FMapBufferPos.X := ((FCameraMapViewport.Left - 1) * cTileWidth) + FDistanceMove.X;
    //  FMapBufferPos.Y := ((FCameraMapViewport.Top - 1) * cTileHeight) + FDistanceMove.Y;
    //end;
    //end;

    pnlView.Invalidate;
  end;
end;

procedure TMainForm.cbxChooseMapSelect(Sender : TObject);
begin
  FCurrentMap := cbxChooseMap.Text;
  FindZoomLevels(FCurrentMap);
  cbxChooseZoomLevel.Enabled := True;
end;

procedure TMainForm.cbxChooseZoomLevelSelect(Sender : TObject);
begin
  LoadMap(FCurrentMap, cbxChooseZoomLevel.Items[cbxChooseZoomLevel.ItemIndex].ToInteger);
  UpdateInfos;
end;

procedure TMainForm.FormKeyPress(Sender : TObject; var Key : char);
begin
  if key<>#0 then
  begin

    if Upcase(Key) = 'D' then if chkFreeMove.Checked then FMap.MoveCamera(4,0) else FMap.MoveCursor(4,0);
    if Upcase(Key) = 'Q' then if chkFreeMove.Checked then FMap.MoveCamera(-4,0) else FMap.MoveCursor(-4,0);
    if Upcase(Key) = 'Z' then if chkFreeMove.Checked then FMap.MoveCamera(0,-4) else FMap.MoveCursor(0,-4);
    if Upcase(Key) = 'S' then if chkFreeMove.Checked then FMap.MoveCamera(0,4) else FMap.MoveCursor(0,4);
    pnlView.Invalidate;
  end;
end;

procedure TMainForm.chkMapRenderGridChange(Sender : TObject);
begin
  pnlView.Invalidate;
end;

procedure TMainForm.chkFreeMoveClick(Sender : TObject);
begin
  FMap.LinkCameraToCursor := not(chkFreeMove.checked);
end;

procedure TMainForm.FindMaps;
Var
  FolderList : TStringList;
  Dir : String;
  i : Integer;
begin
  Dir :=  FixPathDelimiter(cMapRootDir);
  //FixPathDelimiter(GetApplicationPath + cMapRootDir);
  cbxChooseMap.Items.Clear;
  FolderList := FindAllDirectories(Dir, False);
  if FolderList.Count > 0 then
  begin
    For i := 0 to FolderList.Count - 1 do
    begin
      FolderList.Strings[i] := FolderList.Strings[i].After(Dir);
    end;
    cbxChooseMap.Items.Assign(FolderList);
    FreeAndNil(FolderList);
  end;
end;

function MyNumSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if ((StrToInt(List.Strings[Index1])) > (StrToInt(List.Strings[Index2]))) then result := 1 else result := -1;
end;

procedure TMainForm.FindZoomLevels(aMap : String);
Var
  ZoomList : TStringList;
  i : Integer;
  Dir : String;
begin
  Dir := FixPathDelimiter(IncludeTrailingPathDelimiter(cMapRootDir + aMap));
  //FixPathDelimiter(IncludeTrailingPathDelimiter(GetApplicationPath + cMapRootDir + aMap));
  ZoomList := FindAllDirectories(Dir, False);

  if ZoomList.Count > 0 then
  begin
    For i := 0 to ZoomList.Count - 1 do
    begin
      ZoomList.Strings[i] := ZoomList.Strings[i].After(IncludeTrailingPathDelimiter(aMap));
    end;
    ZoomList.CustomSort(@MyNumSort);
    cbxChooseZoomLevel.Items.Assign(ZoomList);
    FreeAndNil(ZoomList);
  end;

end;

procedure TMainForm.LoadMap(aMap : String; ZoomLevel : Integer);
Var
  TileLatIndices : TStringList;
  TileLonIndices : TStringList;
  nbTileH, nbTileV, CurrentLon : Integer;
  TileRec : PBZTileInfosRec;
  s, Dir, SubDir, TileName : String;
  i,j, idx,tx,ty : Integer;
  Coords : TBZFloatPoint;
begin
  lblStatus.Caption := 'Chargement de la carte en cours. Veuillez patienter quelques instants.';
  GlobalLogger.LogStatus('------------------------------------------------------------------------------');
  GlobalLogger.LogNotice('Chargement de la carte en cours. Veuillez patienter quelques instants.');
  Screen.Cursor := crHourGlass;
  FMap.TileSet.Clear;
  Dir := FixPathDelimiter(IncludeTrailingPathDelimiter( IncludeTrailingPathDelimiter(cMapRootDir + aMap) +ZoomLevel.ToString));
  //ShowMessage(Dir);
  //FixPathDelimiter(IncludeTrailingPathDelimiter(
  //                        IncludeTrailingPathDelimiter(GetApplicationPath + cMapRootDir + aMap) +
  //                        ZoomLevel.ToString));
  //TileLatIndices := FindAllDirectories(Dir, False);
  TileLonIndices := TStringList.Create;
  //ShowMessage(Dir);
  SearchFolder(TileLonIndices, Dir, False);
  nbTileH := TileLonIndices.Count;

  TileLatIndices := TStringList.Create;
  SubDir := FixPathDelimiter(IncludeTrailingPathDelimiter(TileLonIndices.Strings[0]));
  SearchFile(TileLatIndices,SubDir,'*.png',false);
  nbTileV := TileLatIndices.Count;

  //GlobalLogger.LogStatus('Folder count : '+ nbTileH.ToString);
  //GlobalLogger.LogStatus('File count : '+ nbTileV.ToString);

  FMap.SetSize(nbTileH, nbTileV);

  For i := 0 to nbTileH - 1 do
  begin
    //GlobalLogger.LogNotice('Search for Lat n° : '+i.ToString);

    if i>0 then
    begin
      SubDir := FixPathDelimiter(IncludeTrailingPathDelimiter(TileLonIndices.Strings[i]));
      //GlobalLogger.LogNotice('Search in...'+ SubDir );
      //TileLonIndices.Clear;
      //FindAllFiles(TileLonIndices,SubDir,'*.png', False);
      SearchFile(TileLatIndices,SubDir,'*.png',false);
      nbTileV := TileLatIndices.Count;
    end;

    //GlobalLogger.LogStatus(' File count : '+nbTileV.ToString);
    if nbTileV=0 then exit;

    s := ExtractFileName(TileLonIndices.Strings[i]);
//    GlobalLogger.LogNotice('Longitude Str : ' + S);
    CurrentLon := s.ToInteger; //StrToInt(s); //
    //GlobalLogger.LogNotice('Longitude : '+ CurrentLon.ToString );

    For j := 0 to nbTileV - 1 do
    begin
       New(TileRec);
       TileRec^.LonIndice := CurrentLon;
       s := ExtractFileName(TileLatIndices.Strings[j]);
       s := s.Before('.');
       //GlobalLogger.LogStatus('Work on file : ' + s);
       TileRec^.LatIndice := s.ToInteger;
       Coords := TileOSMToCoordinates(TileRec^.LonIndice, TileRec^.LatIndice, ZoomLevel);
       TileRec^.Latitude := Coords.Y;
       TileRec^.Longitude := Coords.X;
       TileName := TileRec^.LonIndice.ToString + '_' + TileRec^.LatIndice.ToString;
       //TileName := CurrentLat.ToString + '_' + s;//LonIndice.ToString;
       //GlobalLogger.LogStatus('Add Tile : ' + TileName + ' ==> '+TileLatIndices.Strings[j]);
       idx := FMap.AddTile(TileName, TileLatIndices.Strings[j], TileRec);
       FMap.SetMapTile(i, j, 0, idx);
    end;
  end;
  FreeAndNil(TileLonIndices);
  FreeAndNil(TileLatIndices);

  tx := FDisplayBuffer.Width div cTileWidth;
  ty := FDisplayBuffer.Height div cTileHeight;
  lblSizeDisplayTile.Caption := tx.ToString + 'x' + ty.ToString;
  lblSizeMapBufferTile.Caption := FMap.TileViewportSize.Width.ToString + 'x' +FMap.TileViewportSize.Height.ToString;
  lblPixelMapSize.Caption := FMap.MapSizeInPixel.Width.ToString + 'x' + FMap.MapSizeInPixel.Height.ToString;
  lblSizeMapTile.Caption := FMap.MapWidth.ToString + 'x' + FMap.MapHeight.ToString;
  //FMap.CursorOrigin := coTopLeft; //coCenter;

  UpdateInfos;
  Screen.Cursor := crDefault;
  lblStatus.Caption := '';
  FMapLoaded := True;
  pnlView.Invalidate;
end;

procedure TMainForm.UpdateInfos;
var
  TileItem : TBZCustomTileItem;
  p : TBZFloatPoint;
  pt : TBZPoint;
begin
  if FMapLoaded then
  begin
    //pt := FMap.WorldToScreen(FMap.CursorPos);
    lblPixelTileMapPos.Caption := FMap.CursorPos.X.ToString + 'x' + FMap.CursorPos.Y.ToString;
    lblTileMapPos.Caption := FMap.CameraTilePos.X.ToString + 'x' + FMap.CameraTilePos.Y.ToString;

    //ZoomLevel := cbxChooseZoomLevel.Items[cbxChooseZoomLevel.ItemIndex].ToInteger;
    //p := PixelToCoordinates(FMap.CursorTilePos.X, FMap.CursorTilePos.Y, ZoomLevel);
    p := PixelToCoordinates(FMap.CursorPos.X, FMap.CursorPos.Y, FMap.MapSizeInPixel.Width, FMap.MapSizeInPixel.Height);
    lblMapPosCoord.Caption := 'Lat : ' + p.X.ToString()
                           + ' Lon : ' + p.Y.ToString();

    TileItem := FMap.GetMapTileItem(FMap.CursorTilePos.X, FMap.CursorTilePos.Y, 0);
    lblTileCoordMin.Caption := 'Lat : ' + PBZTileInfosRec(TileItem.TagPointer)^.Latitude.ToString()
                            + ' Lon : ' + PBZTileInfosRec(TileItem.TagPointer)^.Longitude.ToString();

    TileItem := FMap.GetMapTileItem(FMap.CursorTilePos.X + 1, FMap.CursorTilePos.Y + 1, 0);
    lblTileCoordMax.Caption := 'Lat : ' + PBZTileInfosRec(TileItem.TagPointer)^.Latitude.ToString()
                            + ' Lon : ' + PBZTileInfosRec(TileItem.TagPointer)^.Longitude.ToString();
  end;
  //lblMoveKind.Caption := strMoveKind[FMoveKind];
end;

procedure TMainForm.UpdateMapBuffer;
begin
  //
end;

procedure TMainForm.RenderDisplayBuffer;
Var
 p : TBZPoint;
begin
  FDisplayBuffer.Clear(clrBlack);
  if FMapLoaded then
  begin
    FMap.DrawLayer(0);
    if chkMapRenderGrid.Checked then FMap.DrawGrid(clrRed);
    p := FMap.WorldToScreen(FMap.CameraTilePos).Abs;
    FDisplayBuffer.PutImage(FCenterCursor, p.X - FCenterCursor.CenterX, p.Y - FCenterCursor.CenterY, 255, dmSet, amAlpha);

  end;
  FDisplayBuffer.DrawToCanvas(pnlView.Canvas, pnlView.ClientRect);
  UpdateInfos;
end;



end.

