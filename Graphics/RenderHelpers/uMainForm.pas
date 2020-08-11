unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  BZColors, BZGraphic, BZBitmap;

Const
  { Nombre aléatoire premier pour l'axe des X }
  cX_PRIME = 1619;
  { Nombre aléatoire premier pour l'axe des Y }
  cY_PRIME = 31337;
  { Nombre aléatoire premier pour l'axe des Z }
  cZ_PRIME = 6971;
  { Nombre aléatoire premier pour l'axe des W }
  cW_PRIME = 1013;
  { Nombre aléatoire }
  cNOISE_SEED = 4679;

type

  { TBZBitmapRenderFiltersHelper }

  TBZBitmapRenderFiltersHelper = class helper for TBZBitmapRenderFilters
  public
    procedure Plasma(Const MaxValue : Byte = 255; Const MapPalette : Boolean = False);
    procedure DiamondSquare(Const Seed : Longint = 123456; Const Roughtness : Integer = 64; Const FallOff : Single = 0.36);

    procedure InfiniteDiamondSquare(MoveX, MoveY : Integer; Const Iterations : Byte = 7; Const FallOff : Single = 0.36; Const Seed : Int64 = 1337);
  end;

  { TMainForm }

  TMainForm = class(TForm)
    pnlView: TPanel;
    Button1: TButton;
    Button2: TButton;
    sbRoughness: TScrollBar;
    sbFallOff: TScrollBar;
    sbMoveX: TScrollBar;
    sbMoveY: TScrollBar;
    chkDSInfinite: TCheckBox;
    chkBlur: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    lblRoughness: TLabel;
    lblFallOff: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure pnlViewPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure sbRoughnessChange(Sender: TObject);
    procedure sbMoveXChange(Sender: TObject);
    procedure sbFallOffChange(Sender: TObject);
  private
  protected
    FTexture : TBZBitmap;
    FMoveX, FMoveY : Integer;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses Math, BZMath, BZArrayClasses, BZLogger,  BZTypesHelpers;

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FTexture := TBZBitmap.Create(512,512);
  FMoveX := 0;
  FMoveY := 0;
end;

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FreeAndNil(FTexture);
end;

procedure TMainForm.pnlViewPaint(Sender: TObject);
begin
  if Assigned(FTexture) then FTexture.DrawToCanvas(pnlView.Canvas, pnlView.ClientRect);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  FTexture.RenderFilter.Plasma();
  pnlView.Invalidate;
end;

procedure TMainForm.Button2Click(Sender: TObject);
begin
  if chkDSInfinite.Checked then
  begin
    FMoveX := sbMoveX.Position;
    FMoveY := sbMoveY.Position;
    FTexture.RenderFilter.InfiniteDiamondSquare(FMoveX, FMoveY, min(sbRoughNess.Position,24), (sbFallOff.Position / 100));
  end
  else
    FTexture.RenderFilter.DiamondSquare(123456, sbRoughness.Position, (sbFallOff.Position / 100));

    if chkBlur.Checked then FTexture.BlurFilter.BoxBlur(2);
  pnlView.Invalidate;
end;

procedure TMainForm.sbRoughnessChange(Sender: TObject);
begin
  lblRoughness.Caption := sbRoughness.Position.ToString;
  Button2Click(self);
end;

procedure TMainForm.sbMoveXChange(Sender: TObject);
begin
  Button2Click(self);
end;

procedure TMainForm.sbFallOffChange(Sender: TObject);
Var
 d : Single;
begin
  d := sbFallOff.Position / 100;
  lblFallOff.Caption := d.ToString(2);
  Button2Click(self);
end;

{ TBZBitmapRenderFiltersHelper }

procedure TBZBitmapRenderFiltersHelper.Plasma(Const MaxValue: Byte; Const MapPalette: Boolean);
Var
   Level : Integer;
   xmax, ymax, randValue :integer;
   RndColor : TBZColor;

  function adjust(xa,ya,x,y,xb,yb:integer): TBZColor;
  var
    rand : Integer;
    SrcColorA, SrcColorB, DstColor : TBZColor;
  begin
     rand := random(MaxValue) shr level;
     if (random(2)=0) then rand := -rand;
     SrcColorA := OwnerBitmap.getPixel(xa,ya);
     SrcColorB := OwnerBitmap.getPixel(xb,yb);
     DstColor := SrcColorA.Average(SrcColorB);

     DstColor.Red := ClampByte(DstColor.Red + Rand);
     DstColor.Green := ClampByte(DstColor.Green + Rand);
     DstColor.Blue := ClampByte(DstColor.Blue + Rand);

     OwnerBitmap.setPixel(X,Y, DstColor);
     result := DstColor;
  end;

  procedure Divide(x1,y1,x2,y2:Integer);
  var
    x, y, sr, sg,sb, sa : integer;
    AColor, DstColor : TBZColor;
  begin
     //Level :=0;
     sr := 0;
     sg := 0;
     sb := 0;
     sa := 0;
     if ((x2-x1<2) and (y2-y1<2)) then exit;

     inc(level);
     x:=((x1+x2) shr 1);
     y:=((y1+y2) shr 1);

     AColor := OwnerBitmap.getPixel(x,y1);
     if (AColor = clrBlack) or (AColor = clrTransparent) then AColor := adjust(x1,y1,x,y1,x2,y1);

     sr := AColor.Red;
     sg := AColor.Green;
     sb := AColor.Blue;
     sa := AColor.Alpha;

     AColor := OwnerBitmap.getPixel(x2,y);
     if (AColor = clrBlack) or (AColor = clrTransparent) then AColor := adjust(x2,y1,x2,y,x2,y2);

     sr := sr + AColor.Red;
     sg := sg + AColor.Green;
     sb := sb + AColor.Blue;
     sa := sa + AColor.Alpha;

     AColor := OwnerBitmap.getPixel(x,y2);
     if (AColor = clrBlack) or (AColor = clrTransparent) then AColor := adjust(x1,y2,x,y2,x2,y2);

     sr := sr + AColor.Red;
     sg := sg + AColor.Green;
     sb := sb + AColor.Blue;
     sa := sa + AColor.Alpha;

     AColor := OwnerBitmap.getPixel(x1,y);
     if (AColor = clrBlack) or (AColor = clrTransparent) then AColor := adjust(x1,y1,x1,y,x1,y2);

     sr := sr + AColor.Red;
     sg := sg + AColor.Green;
     sb := sb + AColor.Blue;
     sa := sa + AColor.Alpha;

     AColor := OwnerBitmap.getPixel(x,y);
     if (AColor = clrBlack) or (AColor = clrTransparent) then
     begin
       sr := sr + 2;
       sg := sg + 2;
       sb := sb + 2;
       sa := sa + 2;
       DstColor.Create((sr shr 2), (sg shr 2), (sb shr 2), (sa shr 2));
       OwnerBitmap.setPixel(x,y, DstColor);
     end;

     Divide(x1,y1,x,y);
     Divide(x,y1,x2,y);
     Divide(x,y,x2,y2);
     Divide(x1,y,x,y2);
     dec(level)
  end;

begin
   OwnerBitmap.Clear(clrBlack);
   Randomize;
   xmax := OwnerBitmap.MaxWidth;//((x2-x1) div 2)-1;
   ymax := OwnerBitmap.MaxHeight;//((y2-y1) div 2)-1;

   randValue := random(MaxValue);
   RndColor.Create(RandValue, RandValue, RandValue);
   OwnerBitmap.setPixel(0,0, RndColor);
   //randValue := random(MaxValue);
   //RndColor.Create(RandValue, RandValue, RandValue);
   OwnerBitmap.setPixel(xmax,0, RndColor);
   //randValue := random(MaxValue);
   //RndColor.Create(RandValue, RandValue, RandValue);
   OwnerBitmap.setPixel(0,ymax, RndColor);
   //randValue := random(MaxValue);
   //RndColor.Create(RandValue, RandValue, RandValue);
   OwnerBitmap.setPixel(xmax,ymax, RndColor);

   level := 0;
   divide(0, 0, xmax, ymax);
end;


{ https://fr.wikipedia.org/wiki/Algorithme_Diamant-Carré
  https://yahiko.developpez.com/tutoriels/heightmap/
  https://hiko-seijuro.developpez.com/articles/diamond-square/
  https://stackoverflow.com/questions/2755750/diamond-square-algorithm
  https://learn.64bitdragon.com/articles/computer-science/procedural-generation/the-diamond-square-algorithm }
procedure TBZBitmapRenderFiltersHelper.DiamondSquare(Const Seed: Longint; Const Roughtness: Integer; Const FallOff: Single);
Var
  TileSize, TileSizeW, TileSizeH, RandValue, rand, HalfSize : Integer;
  xx, yy, xmax, ymax : integer;
  AColor, AColorSum : TBZColorVector;
  NeedResize : Boolean;
  DstColor : TBZColor;
begin
   // Ajustement des dimensions du bitmap si elles ne sont pas de l'ordre de 2n + 1
  NeedResize := False;
  xMax := OwnerBitmap.Width;
  yMax := OwnerBitmap.Height;
  if xMax.IsPowerOfTwo then
  begin
    xMax := xMax + 1;
    NeedResize := True;
  end;
  if yMax.IsPowerOfTwo then
  begin
    yMax := yMax + 1;
    NeedResize := True;
  end;
  if NeedResize then OwnerBitmap.SetSize(xMax, yMax);

  OwnerBitmap.Clear(clrBlack);
  //Randomize;
  RandSeed := Seed;

  xmax := OwnerBitmap.MaxWidth;//((x2-x1) div 2)-1;
  ymax := OwnerBitmap.MaxHeight;//((y2-y1) div 2)-1;

  randValue := random(256);
  DstColor.Create(RandValue, RandValue, RandValue);
  OwnerBitmap.setPixel(0,0, DstColor);
  randValue := random(256);
  DstColor.Create(RandValue, RandValue, RandValue);
  OwnerBitmap.setPixel(xmax,0, DstColor);
  randValue := random(256);
  DstColor.Create(RandValue, RandValue, RandValue);
  OwnerBitmap.setPixel(0,ymax, DstColor);
  randValue := random(256);
  DstColor.Create(RandValue, RandValue, RandValue);
  OwnerBitmap.setPixel(xmax,ymax, DstColor);

  TileSizeW := xmax;
  TileSizeH := ymax;
  TileSize := TileSizeW;
  TileSize:= Max(TileSizeW, TileSizeH);
  RandValue := Roughtness;
  While TileSize > 1 do
  begin
    HalfSize :=  TileSize div 2; //((TileSize + 1) div 2) - 1;

    // Square
    xx := 0;
    While (xx < OwnerBitmap.Width) do
    begin
      yy := 0;
      While (yy < OwnerBitmap.Height) do
      begin
        AColorSum := ClrTransparent.AsColorVector;

        AColor := OwnerBitmap.getPixel(xx, yy).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColor := OwnerBitmap.getPixel(xx + TileSize, yy).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColor := OwnerBitmap.getPixel(xx, yy + TileSize).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColor := OwnerBitmap.getPixel(xx + TileSize, yy + TileSize).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColorSum :=  AColorSum * 0.25;

        Rand := Integer.RandomRange(-RandValue, RandValue);
        AColor.Create(Rand * _FloatColorRatio);
        AColorSum :=  AColorSum + AColor;

        DstColor.Create(AColorSum);
        OwnerBitmap.setPixel(xx + HalfSize, yy + HalfSize, DstColor);


        yy := yy + TileSize;
      end;
      xx := xx + TileSize;
    end;

    // Diamond
    xx := 0;
    While (xx < OwnerBitmap.Width) do
    begin
      yy := (xx + HalfSize) mod TileSize;

      While (yy < OwnerBitmap.Height) do
      begin
        AColorSum := ClrTransparent.AsColorVector;

        AColor := OwnerBitmap.getPixel((xx - halfSize + xmax) mod xmax, yy).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColor := OwnerBitmap.getPixel((xx + halfSize) mod xmax, yy).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColor := OwnerBitmap.getPixel(xx, (yy + halfSize) mod ymax).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColor := OwnerBitmap.getPixel(xx, (yy - halfSize + ymax) mod ymax).AsColorVector;
        AColorSum :=  AColorSum + AColor;

        AColorSum :=  AColorSum * 0.25;

        Rand := Integer.RandomRange(-RandValue, RandValue);
        AColor.Create(Rand * _FloatColorRatio);
        AColorSum :=  AColorSum + AColor;

        DstColor.Create(AColorSum);
        OwnerBitmap.setPixel(xx, yy, DstColor);

        if (xx = 0) then OwnerBitmap.setPixel(xmax, yy, DstColor);
        if (yy = 0) then OwnerBitmap.setPixel(xx, ymax, DstColor);

        yy := yy + TileSize;
      end;
      xx := xx + HalfSize;
    end;

    //RandValue := (RandValue div 2) + 1;
    Randvalue := RandValue - Round((RandValue * 0.5) * FallOff);
    TileSize := TileSize div 2;
  end;
end;

procedure TBZBitmapRenderFiltersHelper.InfiniteDiamondSquare(MoveX, MoveY: Integer; Const Iterations: Byte; Const FallOff: Single; Const Seed: Int64);
Var
 DSMap : TBZSingle2DMap;

  function getDiamondSquareMap : TBZSingle2DMap;
  Var
    MaxDeviation : Single;
    ResultMap : TBZSingle2DMap;
    ix, iy : integer;

    function ComputeMaxDeviation(Iters : Byte) : Single;
    Var
      Dev : Single;
    begin
      dev := 0.5 / (iters+1);
      if (iters <= 0) then Result := dev
      else result := ComputeMaxDeviation(iters-1) + dev;
    end;

    Function RandUniform3D(x,y,z : Double): Double;
    Var
      n : Integer;
    begin
      n := Round(cX_PRIME * x + cY_PRIME * y + cZ_PRIME * z + cNOISE_SEED * Seed) and $7fffffff;
      n := (n shr 13) xor n;
      Result := 1.0 - (((n * (n * n * 60493 + 19990303) + 1376312589) and $7fffffff) / 1073741824.0);
    end;

    //function PseudoRandomHash(x, y : Integer; Iters : Byte): Single;
    //var
    //  Hash, ite, vx, vy, rem, h : Int64;
    //begin
    //  vx := x and $FFF;
    //  vy := y and $FFF;
    //  ite := Iters and $FF;
    //  Hash := (ite shl 24);
    //  Hash := Hash or (vy shl 12);
    //  Hash := Hash or vx;
    //  rem := Hash and 3;
    //  h := Hash;
    //
    //  Case rem of
    //    1:
    //    begin
    //      Hash := Hash + h;
    //      Hash := round(Math.intpower(Hash, (Hash shl 20)));
    //      Hash := Hash + (Hash shr 2);
    //    end;
    //    2:
    //    begin
    //      Hash := Hash + h;
    //      Hash := round(Math.intpower(Hash, (Hash shl 22)));
    //      Hash := Hash + (Hash shr 34);
    //    end;
    //    3:
    //    begin
    //      Hash := Hash + h;
    //      hash := round(Math.intpower(Hash, (Hash shl 32)));
    //      hash := round(Math.intpower(Hash, (h shl 36)));
    //      Hash := Hash + (Hash shr 22);
    //    end;
    //  end;
    //
    //  Hash := round(Math.intpower(Hash, (Hash shl 6)));
    //  Hash := Hash + (Hash shr 10);
    //  Hash := round(Math.intpower(Hash, (Hash shl 8)));
    //  Hash := Hash + (Hash shr 34);
    //  hash := round(Math.intpower(Hash, (Hash shl 50)));
    //  Hash := Hash + (Hash shr 12);
    //
    //  Result := (Hash and $FFFF) / $FFFF;
    //  GlobalLogger.LogStatus('PRH = ' + Result.ToString);
    //end;

    function DisplaceMap(Iter : Byte; x, y : Integer) : Single;
    begin
      //Result := (((PseudoRandomHash(Iter,x,y) - 0.5) * 2)) / (Iter + 1);
      //Result := ((RandUniform3D(x, y, Iter) - 0.5) * 2) / (Iter + 1);
      Result := ((RandUniform3D(x, y, Iter) - 0.5) * FallOff) / (Iter + 1);
    end;

    function ComputeDiamondSquareMap(x0, y0, x1, y1 : Integer; Iter : Byte) : TBZSingle2DMap;
    Var
      UpperMap, CurrentMap, FinalMap : TBZSingle2DMap;
      FinalWidth, FinalHeight : Integer;
      ux0, uy0, ux1, uy1, uw, uh, cw, ch, cx0, cy0, xoff, yoff, j, k : Integer;

    begin
      if (x1 < x0) then exit;
      if (y1 < y0) then exit;
      FinalWidth  := x1 - x0;
      FinalHeight := y1 - y0;
      FinalMap := TBZSingle2DMap.Create(FinalWidth, FinalHeight);

      if (Iter = 0) then
      begin
        for j := 0 to (FinalWidth-1) do
        begin
          for k := 0 to (FinalHeight-1) do
          begin
            FinalMap.Items[j,k] :=  DisplaceMap(Iter, x0 + j, y0 + k) ;
          end;
        end;
        Result := FinalMap;
        Exit;
      end;

      ux0 := Math.floor(x0 * 0.5) - 1;
      uy0 := Math.floor(y0 * 0.5) - 1;
      ux1 := Math.ceil(x1 * 0.5) + 1;
      uy1 := Math.ceil(y1 * 0.5) + 1;

      UpperMap := ComputeDiamondSquareMap(ux0, uy0, ux1, uy1, Iter - 1);

      uw := ux1 - ux0;
      uh := uy1 - uy0;

      cx0 := ux0 + ux0; //ux0 * 2;
      cy0 := uy0 + uy0; //uy0 * 2;

      cw := (uw + uw) - 1; //uw * 2 -1;
      ch := (uh + uh) - 1; //uh * 2 -1;

      CurrentMap := TBZSingle2DMap.Create(cw,ch);

      for j := 0 to (uw - 1) do
      begin
        for k := 0 to (uh - 1) do
        begin
          CurrentMap.Items[j + j, k + k] := UpperMap.Items[j, k];
        end;
      end;

      FreeAndNil(UpperMap);
      xoff := x0 - cx0;
      yoff := y0 - cy0;

      j := 1;
      While (j < (cw-1)) do
      begin
        k := 1;
        While (k < (ch - 1)) do
        begin
          CurrentMap.Items[j, k] := ((CurrentMap.Items[j - 1, k - 1] +
                                      CurrentMap.Items[j - 1, k + 1] +
                                      CurrentMap.Items[j + 1, k - 1] +
                                      CurrentMap.Items[j + 1, k + 1]) * 0.25) +
                                      DisplaceMap(Iter, cx0 + j, cy0 + k);
          k := k + 2;
        end;
        j := j + 2;
      end;

      j := 1;
      While (j < (cw-1)) do
      begin
        k := 2;
        While (k < (ch - 1)) do
        begin
          CurrentMap.Items[j, k] := ((CurrentMap.Items[j - 1, k] +
                                      CurrentMap.Items[j + 1, k] +
                                      CurrentMap.Items[j, k - 1] +
                                      CurrentMap.Items[j, k + 1]) * 0.25) +
                                      DisplaceMap(Iter, cx0 + j, cy0 + k);
          k := k + 2;
        end;
        j := j + 2;
      end;

      j := 2;
      While (j < (cw-1)) do
      begin
        k := 1;
        While (k < (ch - 1)) do
        begin
          CurrentMap.Items[j, k] := ((CurrentMap.Items[j - 1, k] +
                                      CurrentMap.Items[j + 1, k] +
                                      CurrentMap.Items[j, k - 1] +
                                      CurrentMap.Items[j, k + 1]) * 0.25) +
                                      DisplaceMap(Iter, cx0 + j, cy0 + k);
          k := k + 2;
        end;
        j := j + 2;
      end;

      for j := 0 to (FinalWidth - 1) do
      begin
        for k := 0 to (FinalHeight - 1) do
        begin
          FinalMap.Items[j, k] := CurrentMap.Items[j + xoff, k + yoff];
        end;
      end;

      FreeAndNil(CurrentMap);
      Result := FinalMap;
    end;

  begin
    ResultMap := ComputeDiamondSquareMap(MoveX, MoveY, MoveX + OwnerBitmap.Width, MoveY + OwnerBitmap.Height, Iterations);

    MaxDeviation := 1/ComputeMaxDeviation(Iterations);

    for ix := 0 to OwnerBitmap.MaxWidth do
    begin
      for iy := 0 to OwnerBitmap.MaxHeight do
      begin
        ResultMap.Items[ix, iy] := ResultMap.Items[ix, iy] * MaxDeviation;
        ResultMap.Items[ix, iy] := Clamp(((ResultMap.Items[ix, iy] + 1) * 0.5), -1.0, 1.0);
      end;
    end;

    Result := ResultMap;
  end;

  procedure RenderMap(Map : TBZSingle2DMap);
  Var
    ix, iy : Integer;
    lum : Byte;
    f : Single;
    DstColor : TBZColor;
  begin
    for ix := 0 to OwnerBitmap.MaxWidth do
    begin
      for iy := 0 to OwnerBitmap.MaxHeight do
      begin
         f := Map.Items[ix, iy];
         //GlobalLogger.LogStatus('f = ' + f.ToString);
         f := RangeMap(f,-1.0,1.0,0,255);
         lum := Round(f);
         DstColor.Create(lum, lum, lum);
         OwnerBitmap.setPixel(ix, iy, DstColor);
      end;
    end;
  end;

begin
  DSMap := getDiamondSquareMap;
  if Assigned(DSMap) then
  begin
    RenderMap(DSMap);
    FreeAndNil(DSMap);
  end;
end;

end.

