unit BZTileMapEngine;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  BZColors, BZClasses, BZMath, BZVectorMath, BZGraphic, BZBitmap;

Const
  cMaxTileMapLayers : Byte = 32;

Type
  TBZMapTileInfoRec = packed record
    Alpha : Byte;
    Visible : Boolean;
    Index : Integer;
  end;


  { TBZCustomTileItem }
  TBZCustomTileItem = Class(TBZUpdateAbleObject)
  private
      FTexture : TBZBitmap;  //TBZSprite;
    FLoaded : Boolean;
    FName : String;
      FFileName : String;
    FTag : Integer;
    FTagPointer : Pointer;

    function GetWidth : Integer;
    function GetHeight : Integer;
  public
    Constructor Create(aName : String);
    Destructor Destroy; Override;

    //procedure Assign(source: TPersistent); override;

    function IsLoaded : Boolean;
    procedure LoadFromFile(FileName : String);
    procedure UnLoad; virtual;
    procedure Load; virtual;

    property Name : String read FName write FName;
      property FileName : String read FFileName write FFileName;
    property Width : Integer read GetWidth;
    property Height : Integer read GetHeight;
      property Texture : TBZBitmap Read FTexture;
    property Tag : Integer read FTag write FTag;
    property TagPointer : Pointer read FTagPointer write FTagPointer;
  end;

  TBZCustomTileItemClass = Class of TBZCustomTileItem;

  TBZCustomTileMap = Class;

  { TBZTileSet }
  TBZTileSet = Class(TBZPersistentObjectList)
  private
    FOwner : TBZCustomTileMap;
    FOwnerMap : TBZCustomTileMap;
    function GetTileItem(Index : Integer) : TBZCustomTileItem;
    procedure setTileItem(Index : Integer; const AValue : TBZCustomTileItem);
  protected
  public
    Constructor Create; Override;
    Constructor Create(aOwner : TBZCustomTileMap); overload;
    Destructor Destroy; Override;

    //procedure Assign(source: TPersistent); override;

    //procedure WriteToFiler(writer: TVirtualWriter); override;
    //procedure ReadFromFiler(reader: TVirtualReader); override;
    { Efface la liste des tiles}
    Procedure Clear; Override;
    Function AddTile(anItem : TBZCustomTileItem) : Integer; overload;
    Function AddTile(aName : String; Const aTag : Integer = 0) : Integer; overload;
    Function AddTile(aName : String; Const aTagPtr : Pointer) : Integer; overload;
    Function AddTile(aName : String; aFileName : String; Const aTag : Integer = 0) : Integer; overload;
    Function AddTile(aName : String; aFileName : String; Const aTagPtr : Pointer) : Integer; Overload;

    property Owner : TBZCustomTileMap read FOwnerMap write FOwnerMap;
    Property Items[Index: Integer]: TBZCustomTileItem read GetTileItem write setTileItem;
  end;


  { TBZCustomTileMap }
  TBZTileMapKind = (tmkStatic, tmkDynamic);
  TBZTileMapCameraLimitsMode = (clInside, clOutSide, clCenter);
  TBZCustomTileMap = Class(TBZUpdateAbleObject)
  private
    FSurface : TBZBitmap;
    FSurfaceSize : TBZPoint;

    FMapCache : TBZBitmap;
    FMapCacheTileSize : TBZPoint;
    FUseMapCache : Boolean;
    FAutoMapCacheSize : Boolean;

    FTileSet : TBZTileSet;

    FMapSize : TBZPoint;
    FMapSizeInPixel : TBZPoint;

    FTileSize : TBZPoint;

    FTileMapKind : TBZTileMapKind;

    FLayer : Array[0..31] of Array of TBZMapTileInfoRec;
    FlayerCount : Byte;

    FCameraLimitsMode : TBZTileMapCameraLimitsMode;

    FLinkCameraToCursor : Boolean;
    FCameraViewport : TBZRect;
    FCameraLimits : TBZRect;
    FCameraTilePos : TBZPoint;
    FLastCameraTilePos : TBZPoint;
    FTileViewportSize : TBZPoint;
    FSurfaceDelta : TBZPoint;

    FCursorPos : TBZPoint;
    FCursorTilePos : TBZPoint;
    FCursorLimitPos : TBZPoint;   // coordonnées relatives du point haut gauche du rapport à la position de la camera
    FCursorLimitSize : TBZPoint; // largeur et hauteur. Plus petite que la hauteur et largeur de la fenêtre de la camera
    FCursorLimits : TBZRect;      // Représentation des limites du curseur pour controler le déplacement de la camera

    FStartRow, FStartCol, FEndRow, FEndCol : Integer;
    FShiftOffsetX, FShiftOffsetY : Integer;
    FFLinkCameraToCursor : Boolean;

    procedure SetTileSet(const AValue : TBZTileSet);

    function GetMapWidth : Integer;
    function GetMapHeight : Integer;

    function GetTileWidth : Integer;
    procedure SetTileWidth(const AValue : Integer);

    function GetTileHeight : Integer;
    procedure SetTileHeight(const AValue : Integer);

    procedure SetCameraLimitsMode(const AValue : TBZTileMapCameraLimitsMode);
    procedure SetCursorLimitPos(const AValue : TBZPoint);
    procedure SetCursorLimitSize(const AValue : TBZPoint);
    procedure SetMapCacheTileSize(const AValue : TBZPoint);
    procedure SetUseMapCache(const AValue : Boolean);
    function GetCursorIsVisible : Boolean;
    procedure SetAutoMapCacheSize(const AValue : Boolean);

  protected


    procedure UpdateMap(LayerIndex : Byte); virtual;
    //procedure UpdateCursor;
    procedure UpdateCamera; virtual;

  public
    Constructor Create(aSurface : TBZBitmap; aTileSet : TBZTileSet;
                       aMapWidth, aMapHeight, aTileWidth, aTileHeight : Integer;
                       Const aUseCache : Boolean = false;
                       Const aCacheTileWidth : Word = 5; Const aCacheTileHeight : Word = 5);

    Destructor Destroy; Override;

    procedure SetSize(NewWidth, NewHeight : LongWord);

    function GetMapTile(x, y, z : Integer) : TBZMapTileInfoRec;
    procedure SetMapTile(x, y, z : Integer; const AValue : TBZMapTileInfoRec); overload;
    procedure SetMapTile(x, y, z : Integer; const AValue : Integer; Const Alpha : Byte = 255; Const IsVisible : Boolean = True); overload;

    function GetMapTileItem(x, y, z : Integer) : TBZCustomTileItem;

    procedure MoveCamera(OffsetX, OffsetY : Integer);
    procedure MoveCameraTo(x,y : Integer);
    procedure MoveCursor(OffsetX, OffsetY : Integer);
    procedure MoveCursorTo(x,y : Integer);

    function AddNewLayer : Byte;
    function AddTile(aName : String; Const aTag : Integer = 0) : Integer; Overload;
    function AddTile(aName : String; aFileName : String; Const aTag : Integer = 0) : Integer; Overload;
    function AddTile(aName : String; aFileName : String; Const aTagPtr : Pointer) : Integer; Overload;
    function AddTile(aName : String; Const aTagPtr : Pointer) : Integer; Overload;

    procedure DrawLayer(LayerIndex : Byte);
    procedure DrawGrid(Const aGridColor : TBZColor);

    function WorldToScreen(aPoint : TBZPoint) : TBZPoint; Overload;
    function WorldToScreen(x,y : Integer) : TBZPoint; Overload;

    function ScreenToWorld(aPoint : TBZPoint) : TBZPoint; Overload;
    function ScreenToWorld(x, y : Integer) : TBZPoint; Overload;

    procedure LoadTile(x,y,z : Integer); virtual;

    property TileSet : TBZTileSet read FTileSet write SetTileSet;

    property TileMapKind : TBZTileMapKind read FTileMapKind write FTileMapKind;

    property MapWidth   : Integer read GetMapWidth;
    property MapHeight  : Integer read GetMapHeight;
    property TileWidth  : Integer read GetTileWidth write SetTileWidth; //SetTileWidth
    property TileHeight : Integer read GetTileHeight write SetTileHeight; //SetTileHeight

    // property MapPixelSize : TBZPoint
    property TileViewportSize : TBZPoint read FTileViewportSize;
    property MapSizeInPixel : TBZPoint read FMapSizeInPixel;

    property CursorPos : TBZPoint read FCursorPos;
    property CursorTilePos : TBZPoint read FCursorTilePos;
    property CursorLimitPos : TBZPoint read FCursorLimitPos write SetCursorLimitPos;
    property CursorLimitSize : TBZPoint read FCursorLimitSize write SetCursorLimitSize;
    property CursorIsVisible : Boolean read GetCursorIsVisible;

    property LinkCameraToCursor : Boolean read FFLinkCameraToCursor write FLinkCameraToCursor;
    property CameraLimitsMode : TBZTileMapCameraLimitsMode read FCameraLimitsMode write SetCameraLimitsMode;
    property CameraViewport : TBZRect read FCameraViewPort;
    property CameraTilePos : TBZPoint read FCameraTilePos;

    property MapCacheTileSize : TBZPoint read FMapCacheTileSize write SetMapCacheTileSize;
    property UseMapCache : Boolean read FUseMapCache write SetUseMapCache;
    property AutoMapCacheSize : Boolean read FAutoMapCacheSize write SetAutoMapCacheSize;

    property Surface : TBZBitmap read FSurface write FSurface;   //SetSurface;

    property LayerCount : Byte read FlayerCount;
  end;


implementation

uses
  Math, BZTypesHelpers, BZLogger, SyncObjs;

{%region=====[ TBZCustomTileItem ]=========================================================================================}

Constructor TBZCustomTileItem.Create(aName : String);
begin
  inherited Create;
  FName := aName;
  FFileName := '';
  FLoaded := False;
  FTag := 0;
  FTagPointer := nil;
end;

Destructor TBZCustomTileItem.Destroy;
begin
  if FTexture<>nil then UnLoad;
  inherited Destroy;
end;

function TBZCustomTileItem.GetHeight : Integer;
begin
  Result := -1;
  if FTexture<>nil then
    Result := FTexture.Height;
end;

function TBZCustomTileItem.GetWidth : Integer;
begin
  Result := -1;
  if FTexture<>nil then
    Result := FTexture.Width;
end;

function TBZCustomTileItem.IsLoaded : Boolean;
begin
  Result := FLoaded;
end;

procedure TBZCustomTileItem.LoadFromFile(FileName : String);
begin
  FFileName := FileName;
  Load;
end;

procedure TBZCustomTileItem.UnLoad;
begin
  FreeAndNil(FTexture);
  FLoaded := False;
end;

procedure TBZCustomTileItem.Load;
begin
  Assert(FFileName='','Le nom de fichier doit être définis ! Sinon vous devez surcharger cette méthode');
//  GlobalLogger.LogNotice('');
//  GlobalLogger.LogNotice('TBZCustomTileItem.Load');
  // GlobalLogger.LogStatus('FileName = ' + FFileName);
  FTexture := TBZBitmap.Create;
  FTexture.LoadFromFile(FFileName);
  FLoaded := True;
end;

{%endregion%}

{%region=====[ TBZTileSet ]================================================================================================}

Constructor TBZTileSet.Create;
begin
  inherited Create;
  FOwner := nil;
end;

Constructor TBZTileSet.Create(aOwner : TBZCustomTileMap);
begin
  Inherited Create;
  FOwner := aOwner;
end;

Destructor TBZTileSet.Destroy;
begin
  inherited Destroy;
end;

function TBZTileSet.GetTileItem(Index : Integer) : TBZCustomTileItem;
begin
  Result := TBZCustomTileItem(Get(Index));
end;

procedure TBZTileSet.setTileItem(Index : Integer; const AValue : TBZCustomTileItem);
begin
  Put(Index, AValue);
end;

Procedure TBZTileSet.Clear;
Var
  i:   Integer;
  Tile: TBZCustomTileItem;
Begin
  if Count < 1 then exit;
  For i := 0 To Count - 1 Do
  Begin
    Tile := GetTileItem(i);
    If Assigned(Tile) Then Tile.Free;
  End;
  Inherited Clear;
end;

Function TBZTileSet.AddTile(anItem : TBZCustomTileItem) : Integer;
Begin
  Result := Add(anItem);
end;

Function TBZTileSet.AddTile(aName : String; Const aTag : Integer) : Integer;
Var
  anItem : TBZCustomTileItem;
begin
  anItem := TBZCustomTileItem.Create(aName);
  anItem.Tag := aTag;
  Result := AddTile(anItem);
end;

Function TBZTileSet.AddTile(aName : String; Const aTagPtr : Pointer) : Integer;
Var
  anItem : TBZCustomTileItem;
begin
  anItem := TBZCustomTileItem.Create(aName);
  anItem.TagPointer := aTagPtr;
  Result := AddTile(anItem);
end;

Function TBZTileSet.AddTile(aName : String; aFileName : String; Const aTag : Integer) : Integer;
Var
  anItem : TBZCustomTileItem;
begin
  anItem := TBZCustomTileItem.Create(aName);
  anItem.Tag := aTag;
  anItem.FileName := aFileName;
  Result := AddTile(anItem);
end;

Function TBZTileSet.AddTile(aName : String; aFileName : String; Const aTagPtr : Pointer) : Integer;
Var
  anItem : TBZCustomTileItem;
begin
  anItem := TBZCustomTileItem.Create(aName);
  anItem.TagPointer := aTagPtr;
  anItem.FileName := aFileName;
  Result := AddTile(anItem);
end;

{%endregion%}

{%region=====[ TBZCustomTileMap ]==========================================================================================}

Constructor TBZCustomTileMap.Create(aSurface : TBZBitmap; aTileSet : TBZTileSet; aMapWidth, aMapHeight, aTileWidth, aTileHeight : Integer; Const aUseCache : Boolean; Const aCacheTileWidth : Word; Const aCacheTileHeight : Word);
begin
  Inherited Create;
  FTileSet := aTileSet;

  FMapSize.Create(aMapWidth, aMapHeight);
  FTileSize.Create(aTileWidth, aTileHeight);
  FMapSizeInPixel := FMapSize * FTileSize;

  FSurface := aSurface;
  FSurfaceSize.Create(FSurface.Width, FSurface.Height);

  FMapCache := nil;
  if aUseCache then
  begin
    FMapCacheTileSize.Create(aCacheTileWidth,aCacheTileHeight);
    FSurfaceSize := FMapCacheTileSize * FTileSize;
    FMapCache := TBZBitmap.Create(FSurfaceSize.Width, FSurfaceSize.Height);
    FUseMapCache := True;
  end
  else
  begin
    FMapCacheTileSize.Create(1,1);
    FUseMapCache := False;
  end;

  FLayer[0] := nil;
  SetLength(FLayer[0],aMapWidth * aMapHeight);
  FLayerCount := 1;

  FCursorPos.Create(0,0);

  FCameraViewport.Create(0,0,FSurfaceSize.Width, FSurfaceSize.Height);
  FCameraLimitsMode := clInside;
  FCameraLimits.Create(0,0,FMapSizeInPixel.Width - FCameraViewPort.Width, FMapSizeInPixel.Height  - FCameraViewPort.Height);
  FSurfaceDelta.Create(0,0);
  //FTileViewportSize.Width := Floor(FSurfaceSize.Width /  FTileSize.Width);
  //FTileViewportSize.Height := Floor(FSurfaceSize.Height /  FTileSize.Height);
  FTileViewportSize := FSurfaceSize div FTileSize;

  FLastCameraTilePos.Create(-1,-1);
end;

Destructor TBZCustomTileMap.Destroy;
Var
  i : Byte;
begin
  For i := FLayerCount-1 downto 0 do
  begin
    SetLength(FLayer[i],0);
    FLayer[i] := nil;
  end;
  if FUseMapCache and (FMapCache<>nil) then FreeAndNil(FMapCache);

  inherited Destroy;
end;

procedure TBZCustomTileMap.SetSize(NewWidth, NewHeight : LongWord);
Var
  i : Byte;
begin
  FMapSize.Create(NewWidth, NewHeight);
  For i:=0 to FLayerCount-1 do
  begin
    SetLength(FLayer[i], (NewWidth * NewHeight));
  end;
  FMapSizeInPixel := FMapSize * FTileSize;

  if FUseMapCache then
  begin
    FCameraViewport.Create(0,0,FMapCache.MaxWidth, FMapCache.MaxHeight);
    ////GlobalLogger.LogStatus('CameraViewport size : ' + FCameraViewPort.Width.ToString + 'x' +FCameraViewPort.Height.ToString);
    FSurfaceDelta.Create((FCameraViewPort.Width - FSurface.Width) div 2 ,(FCameraViewPort.Height - FSurface.Height) div 2);
  end
  else
  begin
    FCameraViewport.Create(0,0,FSurface.MaxWidth, FSurface.MaxHeight);
    FSurfaceDelta.Create(0,0);
  end;

  Case FCameraLimitsMode of
    // On clip la camera entièrement. On reste à l'intérieur de la map
    clInside  : FCameraLimits.Create(0,0,FMapSizeInPixel.Width - FCameraViewPort.Width, FMapSizeInPixel.Height  - FCameraViewPort.Height);
    // On (clip) définit une limite pour la camera, on peut sortir entièrement de la map
    clOutSide : FCameraLimits.Create(-FMapSizeInPixel.Width, -FMapSizeInPixel.Height, FMapSizeInPixel.Width, FMapSizeInPixel.Height);
    // On clip la camera avec comme reference le centre. On peut sortir que partiellement de la map
    clCenter  :
    begin
      FCameraLimits.Create(-FCameraViewPort.CenterPoint.X,-FCameraViewPort.CenterPoint.Y,FMapSizeInPixel.Width - FCameraViewPort.CenterPoint.X, FMapSizeInPixel.Height - FCameraViewPort.CenterPoint.Y);
    end;
  end;

end;

function TBZCustomTileMap.GetMapTileItem(x, y, z : Integer) : TBZCustomTileItem;
Var
  Idx : Integer;
begin
  Idx := FLayer[z][(y*FMapSize.Width) + x].Index;
  Result := FTileSet.Items[Idx];
end;

function TBZCustomTileMap.GetMapHeight : Integer;
begin
  Result := FMapSize.Height;
end;

function TBZCustomTileMap.GetMapWidth : Integer;
begin
  Result := FMapSize.Width;
end;

function TBZCustomTileMap.GetTileHeight : Integer;
begin
 Result := FTileSize.Height;
end;

function TBZCustomTileMap.GetTileWidth : Integer;
begin
  Result := FTileSize.Width;
end;

procedure TBZCustomTileMap.SetTileHeight(const AValue : Integer);
begin
  FTileSize.Height := AValue;
end;

procedure TBZCustomTileMap.SetCameraLimitsMode(const AValue : TBZTileMapCameraLimitsMode);
begin
  if FCameraLimitsMode = AValue then Exit;
  FCameraLimitsMode := AValue;
  Case AValue of
    // On clip la camera entièrement. On reste à l'intérieur de la map
    clInside  : FCameraLimits.Create(0,0,FMapSizeInPixel.Width - FCameraViewPort.Width, FMapSizeInPixel.Height  - FCameraViewPort.Height);
    // On (clip) définit une limite pour la camera, on peut sortir entièrement de la map
    clOutSide : FCameraLimits.Create(-FMapSizeInPixel.Width, -FMapSizeInPixel.Height, FMapSizeInPixel.Width, FMapSizeInPixel.Height);
    // On clip la camera avec comme reference le centre. On peut sortir que partiellement de la map
    clCenter  :
    begin
      FCameraLimits.Create(-FCameraViewPort.CenterPoint.X,-FCameraViewPort.CenterPoint.X,FMapSizeInPixel.Width - FCameraViewPort.CenterPoint.X, FMapSizeInPixel.Height - FCameraViewPort.CenterPoint.Y);
    end;
  end;
end;

procedure TBZCustomTileMap.SetCursorLimitPos(const AValue : TBZPoint);
begin
  if FCursorLimitPos = AValue then Exit;
  FCursorLimitPos := AValue;
  FCursorLimits.Create(AValue.X, AValue.Y, FCursorLimitSize.Width, FCursorLimitSize.Height);
end;

procedure TBZCustomTileMap.SetCursorLimitSize(const AValue : TBZPoint);
begin
  if FCursorLimitSize = AValue then Exit;
  FCursorLimitSize := AValue;
  FCursorLimits.Create(FCursorLimitPos.X, FCursorLimitPos.Y, AValue.Width, AValue.Height);
end;

procedure TBZCustomTileMap.SetMapCacheTileSize(const AValue : TBZPoint);
begin
  if FMapCacheTileSize = AValue then Exit;
  FMapCacheTileSize := AValue;
  if (FMapCache<>nil) then
  begin
    FSurfaceSize.Create(AValue.Width, AValue.Height);
    FMapCache.SetSize(AValue.Width, AValue.Height);
    FCameraViewport.Create(0,0,FMapCache.MaxWidth, FMapCache.MaxHeight);
    FSurfaceDelta.Create((FMapCache.Width - AValue.Width) div 2 ,(FMapCache.Height - Avalue.Height) div 2);
    FTileViewportSize := FMapCacheTileSize div FTileSize;
  end;
end;

procedure TBZCustomTileMap.SetUseMapCache(const AValue : Boolean);
Var
  w,h : Integer;
begin
  if FUseMapCache = AValue then Exit;
  FUseMapCache := AValue;
  If AValue then
  begin
    if FAutoMapCacheSize then
    begin
      w := Floor(FSurface.Width / FTileSize.Width) + 1;
      h := Floor(FSurface.Height / FTileSize.Height) + 1;
      w := max(w,h);
      h := w;
      //GlobalLogger.LogStatus('Cache Tile Size : ' + w.ToString + 'x' + h.ToString);
      FMapCacheTileSize.Create(w,h);
      w := w * FTileSize.Width;
      h := h * FTileSize.Height;
      FMapCache := TBZBitmap.Create(w,h);
      FCameraViewport.Create(0,0,FMapCache.MaxWidth, FMapCache.MaxHeight);
      FTileViewportSize := FMapCacheTileSize;
    end
    else
    begin
      FMapCache.Create(FMapCacheTileSize.Width * FTileSize.Width, FMapCacheTileSize.Height * FTileSize.Width);
      FCameraViewport.Create(0,0,FMapCache.MaxWidth, FMapCache.MaxHeight);
      FTileViewportSize := FMapCacheTileSize;
    end;
    FSurfaceDelta.Create((FMapCache.Width - FSurface.Width) div 2 ,(FMapCache.Height - FSurface.Height) div 2);
    //GlobalLogger.LogStatus('Surface Delta : '+ FSurfaceDelta.ToString);
  end
  else
  begin
    FreeAndNil(FMapCache);
    FSurfaceDelta.Create(0,0);
  end;
end;

function TBZCustomTileMap.GetCursorIsVisible : Boolean;
begin
  Result := FCameraViewport.PointInRect(FCursorPos);
end;

procedure TBZCustomTileMap.SetAutoMapCacheSize(const AValue : Boolean);
Var
  w,h : Integer;
begin
  if FAutoMapCacheSize = AValue then Exit;
  FAutoMapCacheSize := AValue;
  if AValue then
  begin
    if FUseMapCache then
    begin
      w := Floor(FSurface.Width / FTileSize.Width) + 1;
      h := Floor(FSurface.Height / FTileSize.Height) + 1;
      w := max(w,h);
      h := w;
      FMapCacheTileSize.Create(w,h);
      w := w * FTileSize.Width;
      h := h * FTileSize.Height;
      FMapCache.SetSize(w,h);
      FTileViewportSize := FMapCacheTileSize;
      FSurfaceDelta.Create((FMapCache.Width - FMapCache.Width) div 2 ,(FMapCache.Height - FMapCache.Height) div 2);
      //GlobalLogger.LogStatus('Surface Delta : '+ FSurfaceDelta.ToString);
    end;
  end;
end;

procedure TBZCustomTileMap.SetTileWidth(const AValue : Integer);
begin
  FTileSize.Width := AValue;
end;

function TBZCustomTileMap.GetMapTile(x, y, z : Integer) : TBZMapTileInfoRec;
begin
  Assert(z>=FLayerCount,'Calque non initialisé. Utilisez la méthode AddLayer');
  Assert(z<0,'Index de calque hors-limites');

  Result := FLayer[z][(y*FMapSize.Width) + x];
end;

procedure TBZCustomTileMap.SetMapTile(x, y, z : Integer; const AValue : TBZMapTileInfoRec);
begin
  Assert(z>=FLayerCount,'Calque non initialisé. Utilisez la méthode AddLayer');
  Assert(z<0,'Index de calque hors-limites');

  FLayer[z][(y*FMapSize.Width) + x] := AValue;
end;

procedure TBZCustomTileMap.SetMapTile(x, y, z : Integer; const AValue : Integer; Const Alpha : Byte = 255; Const IsVisible : Boolean = True);
Var
  TileInfo : TBZMapTileInfoRec;
begin
  Assert(z>=FLayerCount,'Calque non initialisé. Utilisez la méthode AddLayer');
  Assert(z<0,'Index de calque hors-limites');

  TileInfo.Index := AValue;
  TileInfo.Alpha := Alpha;
  TileInfo.Visible := IsVisible;
  SetMapTile(x, y, z, TileInfo);
end;

procedure TBZCustomTileMap.SetTileSet(const AValue : TBZTileSet);
begin
  if FTileSet = AValue then Exit;
  FTileSet := AValue;
  FTileSet.Owner := Self;
end;

procedure TBZCustomTileMap.MoveCamera(OffsetX, OffsetY : Integer);
Var
  cx, cy : Integer;
  p : TBZPoint;
begin
  FCameraViewport.OffsetRect(OffsetX,OffsetY);

   // On clip suivant les limites de la camera
   p.x := max(FCameraLimits.Left, min(FCameraViewport.Left, FCameraLimits.Right));
   p.y := max(FCameraLimits.Top,  min(FCameraViewport.Top, FCameraLimits.Bottom));

   // On déplace la camera
   FCameraViewPort.MoveTo(p);

  UpdateCamera;
end;

procedure TBZCustomTileMap.MoveCameraTo(x, y : Integer);
Var
  p : TBZPoint;
begin
  P.Create(x,y);

  // On clip suivant les limites de la camera
  p.x := max(FCameraLimits.Left, min(p.x, FCameraLimits.Right));
  p.y := max(FCameraLimits.Top,  min(p.y, FCameraLimits.Bottom));

  // On déplace la camera
  FCameraViewPort.MoveTo(p);

  UpdateCamera;
end;

procedure TBZCustomTileMap.MoveCursor(OffsetX, OffsetY : Integer);
begin
  FCursorPos.X := FCursorPos.X + OffsetX;
  FCursorPos.Y := FCursorPos.Y + OffsetY;

  FCursorPos.X := max(0,min(FCursorPos.X, FMapSizeInPixel.Width));
  FCursorPos.Y := max(0,min(FCursorPos.Y, FMapSizeInPixel.Height));

  FCursorTilePos := FCursorPos div FTileSize;

  UpdateCamera;
end;

procedure TBZCustomTileMap.MoveCursorTo(x, y : Integer);
begin
  FCursorPos.X := max(0,min(x, FMapSizeInPixel.Width));
  FCursorPos.Y := max(0,min(y, FMapSizeInPixel.Height));

  FCursorTilePos := FCursorPos div FTileSize;

  UpdateCamera;
end;

function TBZCustomTileMap.AddNewLayer : Byte;
begin
  SetLength(FLayer[FLayerCount], (FMapSize.Width *  FMapSize.Height));
  Result := FLayerCount;
  Inc(FLayerCount);
end;

function TBZCustomTileMap.AddTile(aName : String; Const aTag : Integer) : Integer;
begin
  Result := FTileSet.AddTile(aName, aTag);
end;

function TBZCustomTileMap.AddTile(aName : String; aFileName : String; Const aTag : Integer) : Integer;
begin
  Result :=FTileSet.AddTile(aName, aFileName, aTag);
end;

function TBZCustomTileMap.AddTile(aName : String; aFileName : String; Const aTagPtr : Pointer) : Integer;
begin
  Result := FTileSet.AddTile(aName, aFileName, aTagPtr);
end;

function TBZCustomTileMap.AddTile(aName : String; Const aTagPtr : Pointer) : Integer;
begin
  Result := FTileSet.AddTile(aName, aTagPtr);
end;

procedure TBZCustomTileMap.UpdateCamera;
Var
  p : TBZPoint;
  ox, oy : Integer;
begin
  //GlobalLogger.LogNotice('TBZCustomTileMap.UpdateCamera');

  if FLinkCameraToCursor then
  begin
    // On suit la position du cursor sur la map
    // La camera suit le curseur. Toujours centrer
    //GlobalLogger.LogStatus('Cursor Pos  = ' + FCursorPos.ToString);
    p.X := FCursorPos.X - FCameraViewPort.CenterPoint.X;
    p.Y := FCursorPos.Y - FCameraViewPort.CenterPoint.Y;
    //GlobalLogger.LogStatus('Camera Pos  = ' + FCameraViewPort.TopLeft.ToString);

    if (FCursorPos.X < FCursorLimits.Left) then  ox := -(FCursorLimits.Left - FCursorPos.X);
    if (FCursorPos.Y < FCursorLimits.Top) then  oy := -(FCursorLimits.Top - FCursorPos.Y);
    if (FCursorPos.X > FCursorLimits.Right) then  ox := (FCursorPos.X - FCursorLimits.Right);
    if (FCursorPos.Y > FCursorLimits.Bottom) then  oy := (FCursorPos.Y - FCursorLimits.Bottom);

    FCameraViewport.OffsetRect(ox,oy);

    // On clip suivant les limites de la camera
    p.x := max(FCameraLimits.Left, min(p.x, FCameraLimits.Right));
    p.y := max(FCameraLimits.Top,  min(p.y, FCameraLimits.Bottom));

    // On déplace la camera
    FCameraViewPort.MoveTo(p);
  end;

  // Position en tuile de la camera
  FCameraTilePos := FCameraViewPort.TopLeft div FTileSize;
end;

procedure TBZCustomTileMap.UpdateMap(LayerIndex : Byte);  //(newTime, DeltaTime : Double)
var
  Col, Row, LastCol, LastRow : Integer;
  Tile : TBZCustomTileItem;
begin
  //GlobalLogger.LogNotice('TBZCustomTileMap.UpdateMap');
  // Load/unload


  //NewCursorTilePos.X := FCameraPos.X div FTileSize.Width;
  //NewCursorTilePos.Y := FCameraPos.Y div FTileSize.Height;

  //NewCursorTilePos.X := FCursorTilePos.X;
  //NewCursorTilePos.Y := FCursorTilePos.Y;

  //GlobalLogger.LogStatus('Last Cursor Pos = ' + FLastCameraTilePos.ToString);
  //GlobalLogger.LogStatus('New Cursor Pos  = ' + FCameraTilePos.ToString);


  if (FCameraTilePos.X <> FLastCameraTilePos.X) or (FCameraTilePos.Y <> FLastCameraTilePos.Y) then
  begin
    FStartCol := max(0,FCameraTilePos.X);
    FEndCol := Floor(FStartCol + FTileViewportSize.Width) - 1;
    FStartRow := max(0,FCameraTilePos.Y);
    FEndRow := Floor(FStartRow + FTileViewportSize.Height) - 1;
    FShiftOffsetX := -FCameraViewport.Left  + FStartCol * FTileSize.Width;
    FShiftOffsetY := -FCameraViewport.Top  + FStartRow * FTileSize.Height;
    FEndCol := Min(FEndCol,(FMapSize.Width-1));
    FEndRow := Min(FEndRow,(FMapSize.Height-1));

    //GlobalLogger.LogStatus('Start Row = ' + FStartRow.ToString + ', End Row = ' + FEndRow.ToString);
    //GlobalLogger.LogStatus('Start Col = ' + FStartCol.ToString + ', End Col = ' + FEndCol.ToString);

    //GlobalLogger.LogStatus('Shift Offset X = ' + FShiftOffsetX.ToString);
    //GlobalLogger.LogStatus('Shift Offset Y = ' + FShiftOffsetY.ToString);

    //if FLastCursorTilePos.X < 0 then FLastCursorTilePos.X := 0;
    //if FLastCursorTilePos.Y < 0 then FLastCursorTilePos.Y := 0;
    if FTileMapKind = tmkDynamic then
    begin
      For Row := FStartRow to FEndRow do
      begin
        For Col := FStartCol to FEndCol do
        begin
          Tile := GetMapTileItem(Col, Row, LayerIndex);
          if (Row >= FStartRow) and (Row <= FEndRow) and (Col>=FStartCol) and (Col<=FEndCol) then
          begin
            //GlobalLogger.LogNotice('Load Tile ==> Tile is already loaded : ' + Tile.IsLoaded.ToString());
            if Not(Tile.IsLoaded) then Tile.Load;
          end
          else
          begin
            //GlobalLogger.LogNotice('Unload Tile ==> Tile is loaded : ' + Tile.IsLoaded.ToString());
            if Tile.IsLoaded then Tile.UnLoad;
          end;
        end;
      end;
    end;
  end
  else
  begin
    FShiftOffsetX := -FCameraViewport.Left  + FStartCol * FTileSize.Width;
    FShiftOffsetY := -FCameraViewport.Top  + FStartRow * FTileSize.Height;
  end;
  FLastCameraTilePos := FCameraTilePos;
end;

procedure TBZCustomTileMap.DrawLayer(LayerIndex : Byte);
Var
  col, row : Integer;
  x, y : Integer;
  Tile : TBZCustomTileItem;
  TileInfo : TBZMapTileInfoRec;
begin
  Assert(FSurface=nil,'Vous devez définir une surface d''affichage');

  //GlobalLogger.LogNotice('TBZCustomTileMap.DrawLayer');
  //UpdateCamera;
  UpdateMap(LayerIndex);
  //GlobalLogger.LogStatus('Draw tile ==> StartRow : ' +FStartRow.ToString + 'EndRow : '+ FEndRow.ToString + ' - StartCol : ' + FStartCol.ToString + ' EndCol : ' + FEndCol.ToString);

  For Row := FStartRow to FEndRow do
  begin
    For Col := FStartCol to FEndCol do
    begin
      TileInfo := GetMapTile(Col, Row, LayerIndex);
      if (TileInfo.Visible) and (TileInfo.Alpha > 0) then
      begin
        Tile := FTileSet.Items[TileInfo.Index]; //GetMapTileItem(Col, Row, LayerIndex);
        //GlobalLogger.LogStatus('Draw tile ('+TileInfo.Index.ToString+') : '+ Tile.Name);
        x := (Col - FStartCol) * Self.TileWidth + FShiftOffsetX;
        y := (Row - FStartRow) * Self.TileHeight + FShiftOffsetY;

        //GlobalLogger.LogStatus('Draw ('+Col.ToString+'x'+Row.ToString + ') at = '+x.Tostring+', '+y.ToString);
        if (Assigned(Tile)) then
        begin
          if (Tile.IsLoaded) then
          begin
            //GlobalLogger.LogStatus('Tile is loaded');
            if FUseMapCache then
              FMapCache.PutImage(Tile.Texture, x, y, 255, dmSet, amAlpha)
            else FSurface.PutImage(Tile.Texture, x, y, 255, dmSet, amAlpha);
          end
          //else
          //begin
          //  //GlobalLogger.LogWarning('TILE IS NOT LOADED !!!!');
          //end;
        end;
      end;
    end;
  end;

  if FUseMapCache then
  begin
    //GlobalLogger.LogStatus('Surface Delta : '+ FSurfaceDelta.ToString);
    //GlobalLogger.LogStatus('Camera : '+ FCameraViewport.ToString);
    //if (FCameraViewport.Left <= FSurfaceDelta.X) or (FCameraViewport.Right >= (FCameraLimits.Right - FSurfaceDelta.X)) then
    //  x := 0
    //else
    //  x := FSurfaceDelta.X;
    //
    //if (FCameraViewport.Top <= FSurfaceDelta.Y) or (FCameraViewport.Bottom >= (FCameraLimits.Bottom - FSurfaceDelta.Y)) then
    //  y := 0
    //else
    //  y := FSurfaceDelta.Y;
    x:=0;y:=0;
    //GlobalLogger.LogStatus('Surface Delta : '+ FSurfaceDelta.ToString);
    //GlobalLogger.LogStatus('Put Map at : '+x.ToString+'x'+y.ToString);
    FSurface.PutImage(FMapCache,x,y,FSurface.Width, FSurface.Height,0,0);
  end;

//  if FRenderGrid then DrawGrid(FGridColor);

end;

procedure TBZCustomTileMap.DrawGrid(Const aGridColor : TBZColor);
Var
  x, y, row, col, w, h : Integer;
begin
  Assert(FSurface=nil,'Vous devez définir une surface d''affichage');
  w := FMapSizeInPixel.Width;
  h := FMapSizeInPixel.Height;

  FSurface.Canvas.Pen.Color := aGridColor;
  FSurface.Canvas.Pen.Style := ssSolid;

  for Row := 0 to FMapSize.Height - 1 do
  begin
     x := -FCameraViewport.Left;
     y := (Row * FTileSize.Height) - FCameraViewport.Top;
     With FSurface.Canvas do
     begin
       MoveTo(x,y);
       LineTo(w,y);
     end;
  end;

  for Col := 0 to FMapSize.Width - 1 do
  begin
     x := (Col * FTileSize.Width) - FCameraViewport.Left;
     y := -FCameraViewport.Top;
     With FSurface.Canvas do
     begin
       MoveTo(x,y);
       LineTo(x,h);
     end;
  end;
end;

function TBZCustomTileMap.WorldToScreen(aPoint : TBZPoint) : TBZPoint;
begin
  Result := aPoint - FCameraViewport.TopLeft;
end;

function TBZCustomTileMap.WorldToScreen(x, y : Integer) : TBZPoint;
Var
  Pt : TBZPoint;
begin
  Pt.Create(x,y);
  Result := WorldToScreen(Pt);
end;

function TBZCustomTileMap.ScreenToWorld(aPoint : TBZPoint) : TBZPoint;
begin
  Result := aPoint + FCameraViewport.TopLeft;
end;

function TBZCustomTileMap.ScreenToWorld(x, y : Integer) : TBZPoint;
Var
  Pt : TBZPoint;
begin
  Pt.Create(x,y);
  Result := ScreenToWorld(Pt);
end;

procedure TBZCustomTileMap.LoadTile(x, y, z : Integer);
Var
  Tile : TBZCustomTileItem;
begin
  Tile := GetMapTileItem(x,y,z);
  Tile.Load;
end;

{%endregion%}

end.

