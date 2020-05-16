unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ExtDlgs, Spin, Buttons, ComCtrls,
  BZClasses, BZStopWatch, BZColors, BZGraphic, BZBitmap, BZBitmapIO;

type

  { TMainForm }

  TMainForm = class(TForm)
    Panel1 : TPanel;
    pnlViewSrc : TPanel;
    pnlViewDest : TPanel;
    btnOpenImg : TButton;
    opd : TOpenPictureDialog;
    btnGenerate : TButton;
    pnlBottom : TPanel;
    lblRayHmax : TLabel;
    lblHmax : TLabel;
    lblRayAngle : TLabel;
    lblOmbre : TLabel;
    SpinOmbre : TSpinEdit;
    spinRayAngle : TFloatSpinEdit;
    spinHmax : TFloatSpinEdit;
    spinRayHmax : TFloatSpinEdit;
    btnSaveImg : TButton;
    Bar : TProgressBar;
    chkExpMode : TCheckBox;
    chkBlur : TCheckBox;
    spinBlurFactor : TFloatSpinEdit;
    Label1 : TLabel;
    btnLightColor : TColorButton;
    spd : TSavePictureDialog;
    procedure btnGenerateClick(Sender : TObject);
    procedure btnOpenImgClick(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure pnlViewSrcPaint(Sender : TObject);
    procedure pnlViewDestPaint(Sender : TObject);
    procedure FormShow(Sender : TObject);
    procedure btnSaveImgClick(Sender : TObject);
  private
    FDisplayBufferSrc, FDisplayBufferDst : TBZBitmap;
    FBmpSrc, FBmpDst : TBZBitmap;
    FStopWatch : TBZStopWatch;

  protected
    procedure DoLightmap(aSrc, aDst: TBZBitmap; aVO: Byte; aAR, aHR, aHP: Single; ClrLight  : TBZColor);
  public

  end;

var
  MainForm : TMainForm;

implementation

{$R *.lfm}

uses
  Math,BZMath;

procedure TMainForm.DoLightmap(aSrc, aDst: TBZBitmap; aVO: Byte; aAR, aHR, aHP: Single; ClrLight  : TBZColor);
var
   pSrcX, pSrcY        : PBZColor; //PByte;
   pDstX, pDstY        : PBZColor;
   OutColor, ClrOmbre : TBZColor;
   //ClrLight  : TBZColor;
   x, y, W, H, dZ, Zo, Zr, HR : Integer;

   z_step, z_origine, z_rayon: single;

   function ControlCouleur(const AC, AX: Byte): Byte; inline;
   begin
     if (255 - AC) > AX then
       Result := (AC + AX)
     else
       Result := 255;
   End;

begin
  // dXSrc := aSrc.RawImage.Description.BitsPerPixel div 8;
   FStopWatch.Start();
   W := aDst.MaxWidth;
   H := aDst.MaxHeight;

   ClrOmbre.Create(aVo,aVo,aVo);
   //ClrLight.Create(79,79,79);

   // Calcul du pas en z pour chaque rayon
   //z_step := abs(1 / tan(DegToRadian(AAR)));
   dz := round( 65280.0*Math.cotan(DegToRadian(aAR))/aHP);
   HR := round((65280.0*aHR)/aHP);

   aDst.Clear(ClrOmbre);
   // Lancement des rayons dans le sens horizontal et de gauche a droite.
   Bar.Max := H ;

   for y := 0 to H do
   begin
      Bar.Position := y;
      pDstY := aDst.GetScanLine(y);
      pSrcY := aSrc.GetScanLine(y);
      // Lancements des rayons pour chaque hauteur en remontant suivant l'axe z
      //z_origine := 0.0;
      Zo := 0;
      while Zo < HR do
      //while Z_Origine < aHR do
      begin                     // Lancement de rayon.
         Zr    := Zo;
         pSrcX := pSrcY;
         pDstX := pDstY;

         //z_rayon := z_origine;
         for x := 0 to W do
         begin
            if ((pSrcX^.Red shl 8) >= Zr) then
            //if (((pSrcX^.Red * _FloatColorRatio ) * aHP ) >= z_rayon) then
            begin
               if chkExpMode.Checked then
               begin
                 asm                               // Exponentielle  (mettre ClrLight.int à -1)
                    mov       r8,  pDstX           // en 1 - e^(-nb_impacts)
                    pxor      xmm0, xmm0
                    movd      xmm2, ClrLight
                    movd      xmm1, [r8]
                    punpcklbw xmm2, xmm0           // xmm2 = ClrLight en 16 bits
                    punpcklbw xmm1, xmm0           // xmm1 = pDstXo^ en 16 bits
                    psubw     xmm2, xmm1           // xmm2 = ClrLight-pDstXo^        (par composante)
                    psraw     xmm2, 2              // xmm3 =(ClrLight-pDstXo^)/2^n   (par composante)
                    paddw     xmm1, xmm2           // xmm1 = ClrLight+(pDstXo^-ClrLight)/16 (par comp)
                    packuswb  xmm1, xmm0
                    movd      [r8], xmm1
					       end;
               end
               else
               begin
                // Linéaire selon nb_impacts
                {$IFDEF WINDOWS}
                {$IFDEF CPU32}
                asm
                  push rdx
                  mov       rdx,   pDstX
                  movd      xmm2, ClrLight
                  movd      xmm1, [rdx]
                  paddusb   xmm2, xmm1
                  movd      [rdx], xmm2
                  pop rdx
                end;
                {$ELSE}
                asm
                  mov       r8d,   pDstX
                  movd      xmm2, ClrLight
                  movd      xmm1, [r8d]
                  paddusb   xmm2, xmm1
                  movd      [r8d], xmm2
                end;
                {$ENDIF}
                {$ELSE}
                 OutColor.Red := ControlCouleur(pDstX^.Red, ClrLight.Red);
                 OutColor.Green := ControlCouleur(pDstX^.Green, ClrLight.Green);
                 OutColor.Blue := ControlCouleur(pDstX^.Blue, ClrLight.Blue);
                 OutColor.Alpha := 255;
                 pDstx^:= OutColor;
                {$ENDIF}
               end;
              break;
            End;

            inc(pSrcX);
            inc(pDstX);

            Zr := Zr - dZ;
            //z_rayon := z_rayon - z_step;
         end;
         //z_origine := z_origine + z_step;
         Zo := Zo + dZ;
      end;
   end;

   FStopWatch.Stop;
   if chkBlur.Checked then FBmpDst.BlurFilter.BoxBlur(Round(spinBlurFactor.Value)); // .GaussianBoxBlur(spinBlurFactor.Value);
   pnlViewDest.Invalidate;
   Caption := 'Temps : '+FStopWatch.getValueAsMilliSeconds;
   Bar.Position := 0;
end;

procedure TMainForm.btnGenerateClick(Sender : TObject);
Var
   lc : TBZColor;
begin
    lc.Create(btnLightColor.ButtonColor);
    DoLightmap(FBmpSrc, FBmpDst, spinOmbre.Value, spinRayAngle.Value, spinRayHmax.Value, spinHmax.Value,lc);
end;

procedure TMainForm.btnOpenImgClick(Sender : TObject);
begin
  if opd.Execute then
  begin
    FBmpSrc.LoadFromFile(opd.FileName);
    FBmpDst.SetSize(FBmpSrc.Width, FBmpSrc.Height);
    pnlViewSrc.Invalidate;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender : TObject; var CanClose : boolean);
begin
  FreeAndNil(FStopWatch);
  CanClose := True;
end;

procedure TMainForm.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  FreeAndNil(FDisplayBufferDst);
  FreeAndNil(FDisplayBufferSrc);
  FreeAndNil(FBmpDst);
  FreeAndNil(FBmpSrc);
end;

procedure TMainForm.pnlViewSrcPaint(Sender : TObject);
begin
  FDisplayBufferSrc.Assign(FBmpSrc);
  FDisplayBufferSrc.Transformation.Stretch(pnlViewSrc.Width,pnlViewSrc.Height);
  FDisplayBufferSrc.DrawToCanvas(pnlViewSrc.Canvas, pnlViewSrc.ClientRect,true,true);
end;

procedure TMainForm.pnlViewDestPaint(Sender : TObject);
begin
  FDisplayBufferDst.Assign(FBmpDst);
  FDisplayBufferDst.Transformation.Stretch(pnlViewDest.Width,pnlViewDest.Height);
  FDisplayBufferDst.DrawToCanvas(pnlViewDest.Canvas, pnlViewDest.ClientRect,true,true);
end;

procedure TMainForm.FormShow(Sender : TObject);
begin
  FBmpSrc := TBZBitmap.Create(256,256);
  FBmpDst := TBZBitmap.Create(256,256);
  FDisplayBufferSrc := TBZBitmap.Create(256,256);
  FDisplayBufferDst := TBZBitmap.Create(256,256);
  FStopWatch := TBZStopWatch.Create(self);
end;

procedure TMainForm.btnSaveImgClick(Sender : TObject);
var
  bmp : TBitmap;
begin
  if spd.Execute then
  begin
    Bmp := FBmpDst.ExportToBitmap;
    Bmp.SaveToFile(spd.FileName);
    FreeAndNil(Bmp);
  end;
end;


end.

