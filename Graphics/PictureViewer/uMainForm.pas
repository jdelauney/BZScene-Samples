Unit uMainForm;

{$mode objfpc}{$H+}

Interface

Uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ActnList, Menus,
  ExtCtrls, ShellCtrls, StdCtrls, ComCtrls, Buttons, EditBtn,
  BZClasses, BZColors, BZGraphic, BZBitmap, {%h-}BZBitmapIO, BZInterpolationFilters, BZImageViewer, Types;

Type

  { TMainForm }

  TMainForm = Class(TForm)
    actSetImageViewerCenter: TAction;
    actSetImageViewerDrawWithTransparency: TAction;
    actSetImageViewerStretch: TAction;
    ActionList1: TActionList;
    btnShowHideImageInfos: TSpeedButton;
    btnStretchSettings: TButton;
    btShowMoreInfos: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    chkCenter: TCheckBox;
    cbxImageZoom: TComboBox;
    ImageListLV: TImageList;
    ImageListTV: TImageList;
    chkDrawWithTransparency: TCheckBox;
    chkStretch: TCheckBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblColorFormat: TLabel;
    lblDataCompression: TLabel;
    lblDimension: TLabel;
    lblFileFormat: TLabel;
    lblFileName: TLabel;
    lblFormatVersion: TLabel;
    lblImagePos: TLabel;
    lblAction: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblDimension2: TLabel;
    lblFileFormat2: TLabel;
    lblImageTransparent: TLabel;
    lblImgBPP: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    mniDisplayZoomGrid: TMenuItem;
    mniResampleFilters: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    mniStretchAll: TMenuItem;
    mniStretchOnlyBiggest: TMenuItem;
    mniStretchOnlySmallest: TMenuItem;
    mniStretchProportionnal: TMenuItem;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel9: TPanel;
    pnlImageInfos: TPanel;
    pnlFileExplorer: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    pnlImageView: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    ppmStretchSettings: TPopupMenu;
    pbImageProgress: TProgressBar;
    sbImageViewH: TScrollBar;
    sbImageViewV: TScrollBar;
    ShellListView: TShellListView;
    ShellTreeView: TShellTreeView;
    btnImageZoomDec: TSpeedButton;
    btnImageZoomInc: TSpeedButton;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    ImageView : TBZImageViewer;
    mniStretchDraft : TMenuItem;
    mniStretchBicubic : TMenuItem;
    mniStretchSmart : TMenuItem;
    mniStretchResampleFilter : TMenuItem;
    mniStretchResample : TMenuItem;
    Procedure actSetImageViewerCenterExecute(Sender: TObject);
    Procedure actSetImageViewerDrawWithTransparencyExecute(Sender: TObject);
    Procedure actSetImageViewerStretchExecute(Sender: TObject);
    Procedure btnImageZoomDecClick(Sender: TObject);
    Procedure btnImageZoomIncClick(Sender: TObject);
    Procedure btnShowHideImageInfosClick(Sender: TObject);
    Procedure btnStretchSettingsClick(Sender: TObject);
    Procedure btShowMoreInfosClick(Sender: TObject);
    Procedure cbxImageZoomEditingDone(Sender: TObject);
    Procedure cbxImageZoomSelect(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormDropFiles(Sender: TObject; Const FileNames: Array Of String);
    Procedure FormShow(Sender: TObject);
    Procedure ImageViewMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure ImageViewMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    Procedure ImageViewMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure ImageViewMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
    Procedure ImageViewMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; Var Handled: Boolean);
    Procedure sbImageViewHChange(Sender: TObject);
    Procedure sbImageViewVChange(Sender: TObject);
    Procedure ShellListViewColumnClick(Sender: TObject; Column: TListColumn);
    Procedure ShellListViewFileAdded(Sender: TObject; Item: TListItem);
    Procedure ShellListViewSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    Procedure ShellTreeViewGetImageIndex(Sender: TObject; Node: TTreeNode);
    Procedure ShellTreeViewGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure mniStretchProportionnalClick(Sender : TObject);
    procedure mniDisplayZoomGridClick(Sender : TObject);
    procedure mniStretchResampleClick(Sender : TObject);
    procedure mniStretchResampleFilterClick(Sender : TObject);
  private
   // ImageView : TBZSimpleImageViewer;
  protected
    FOffsetLeft, FOffsetTop, FLastOffsetTop, FLastOffsetLeft: Integer;
    LastMousePoint, MousePoint : TPoint;
    ZoomFactor : Integer;

    procedure LoadPicture(FileName : String; const Drag : Boolean=false);

    Procedure DoOnBitmapLoadError(Sender: TObject; Const ErrorCount: Integer; Const ErrorList: TStringList);
    Procedure DoImageProgress(Sender: TObject; Stage: TBZProgressStage; PercentDone: Byte; RedrawNow: Boolean; Const R: TRect; Const Msg: String; Var aContinue: Boolean);

    procedure DoZoom(Const Updatecbx:Boolean =  True);
  public

  End;

Var
  MainForm: TMainForm;

Implementation

{$R *.lfm}

uses

  FileCtrl, BZTypesHelpers,
  uBZitmapInfosForm, uErrorBoxForm;




{ TMainForm }

procedure TMainForm.DoOnBitmapLoadError(Sender : TObject; const ErrorCount : Integer; const ErrorList : TStringList);
Begin
  If ErrorCount > 0 then
  begin
    ErrorBoxForm.Memo1.Lines.Clear;
    ErrorBoxForm.Memo1.Lines := ErrorList;
    ErrorBoxForm.ShowModal;
  End;
End;

procedure TMainForm.DoImageProgress(Sender : TObject; Stage : TBZProgressStage; PercentDone : Byte; RedrawNow : Boolean; const R : TRect; const Msg : String; var aContinue : Boolean);
Begin
  Case Stage Of
    opsStarting:
    Begin
      lblAction.Caption := Msg + ' - ' + IntToStr(PercentDone) + '%';
      pbImageProgress.Position := PercentDone;
      Application.ProcessMessages;
    End;
    opsRunning:
    Begin
      lblAction.Caption := Msg + ' - ' + IntToStr(PercentDone) + '%';
      pbImageProgress.Position := PercentDone;
      // if (PercentDone mod 10)=0 then begin ImageView.Invalidate;end;   // Affichage progressif
      Application.ProcessMessages;
      //if RedrawNow then Application.ProcessMessages;
    End;
    opsEnding:
    Begin
      lblAction.Caption := '';
      pbImageProgress.Position := 0;
      //Application.ProcessMessages;
    End;
  End;
End;

procedure TMainForm.DoZoom(const Updatecbx : Boolean);
Var
  Zoom : String;
Begin
  If ZoomFactor < 5 Then ZoomFactor := 5;
  If ZoomFactor > 3200 Then ZoomFactor := 3200;
  if UpdateCbx then cbxImageZoom.Text := ZoomFactor.ToString();
  ImageView.ZoomFactor := ZoomFactor;
  if ImageView.CanScroll then
  begin
    sbImageViewH.Min := ImageView.ScrollBounds.Left;
    sbImageViewH.Max := ImageView.ScrollBounds.Right;
    sbImageViewV.Min := ImageView.ScrollBounds.Top;
    sbImageViewV.Max := ImageView.ScrollBounds.Bottom;
  end;
  sbImageViewH.Enabled := ImageView.CanScrollHorizontal;
  sbImageViewV.Enabled := ImageView.CanScrollVertical;
End;

procedure TMainForm.btnStretchSettingsClick(Sender : TObject);
Begin
  ppmStretchSettings.PopUp;
end;

procedure TMainForm.btShowMoreInfosClick(Sender : TObject);
Begin
  ShowBitmapInfos(ImageView.Picture.Bitmap);
end;

procedure TMainForm.cbxImageZoomEditingDone(Sender : TObject);
Var
  Zoom : String;
begin
  Zoom := cbxImageZoom.Text;
  ZoomFactor := Zoom.ToInteger;
  DoZoom(False);
end;

procedure TMainForm.cbxImageZoomSelect(Sender : TObject);
Var
  Zoom : String;
begin
  Zoom := cbxImageZoom.Text;
  ZoomFactor := Zoom.ToInteger;
  DoZoom(False);
end;

procedure TMainForm.actSetImageViewerDrawWithTransparencyExecute(Sender : TObject);
Begin
  ImageView.DrawWithTransparency := Not(ImageView.DrawWithTransparency);
 // chkDrawWithTransparency.Checked := ImageView.DrawWithTransparency;
end;

procedure TMainForm.actSetImageViewerCenterExecute(Sender : TObject);
Begin
  ImageView.Center:= Not(ImageView.Center);
 // chkCenter.Checked := ImageView.Center;
  if ImageView.CanScroll then
  begin
    sbImageViewH.Min := ImageView.ScrollBounds.Left;
    sbImageViewH.Max := ImageView.ScrollBounds.Right;
    sbImageViewH.Position := 0;
    sbImageViewV.Min := ImageView.ScrollBounds.Top;
    sbImageViewV.Max := ImageView.ScrollBounds.Bottom;
    sbImageViewV.Position := 0;
  end;
  sbImageViewH.Enabled := ImageView.CanScrollHorizontal;
  sbImageViewV.Enabled := ImageView.CanScrollVertical;
end;

procedure TMainForm.actSetImageViewerStretchExecute(Sender : TObject);
Begin
  ImageView.Stretch:= Not(ImageView.Stretch);
  //chkStretch.Checked := ImageView.Stretch;
  if ImageView.CanScroll then
  begin
    sbImageViewH.Min := ImageView.ScrollBounds.Left;
    sbImageViewH.Max := ImageView.ScrollBounds.Right;
    sbImageViewH.Position := 0;
    sbImageViewV.Min := ImageView.ScrollBounds.Top;
    sbImageViewV.Max := ImageView.ScrollBounds.Bottom;
    sbImageViewV.Position := 0;
  end;
  sbImageViewH.Enabled := ImageView.CanScrollHorizontal;
  sbImageViewV.Enabled := ImageView.CanScrollVertical;
end;

procedure TMainForm.btnImageZoomDecClick(Sender : TObject);
Begin
  ZoomFactor := ZoomFactor - 1;
  DoZoom;
end;

procedure TMainForm.btnImageZoomIncClick(Sender : TObject);
Begin
  ZoomFactor := ZoomFactor + 1;
  DoZoom;
end;

procedure TMainForm.btnShowHideImageInfosClick(Sender : TObject);
Begin
  pnlImageInfos.Top :=btnShowHideImageInfos.top+btnShowHideImageInfos.Height;
  pnlImageInfos.Visible := not pnlImageInfos.Visible;
end;

procedure TMainForm.FormCreate(Sender : TObject);
Var
  aCol : TListColumn;
Begin
  ShellListView.Mask := GetBZImageFileFormats.BuildFileFilterMask;
  aCol := ShellListView.Columns.Add;
  aCol.Caption := 'Date';
  aCol.AutoSize := true;
  ZoomFactor := 100;
end;

procedure TMainForm.FormDropFiles(Sender : TObject; const FileNames : array of String);
Begin
  if Length(FileNames) > 0 then LoadPicture(FileNames[0],true);
end;

procedure TMainForm.FormShow(Sender : TObject);
Var
  ResampleFilterList : TStringList;
  i : Integer;
  mni : TMenuItem;
Begin
  With ImageView Do
  Begin
    Color := Parent.Color; //clNone;
    Picture.Bitmap.SetSize(pnlImageView.ClientWidth-2, pnlImageView.ClientHeight-2);
    Picture.Bitmap.Clear(clrTransparent);
    Picture.Bitmap.OnProgress := @DoImageProgress;
    Picture.Bitmap.OnLoadError := @DoOnBitmapLoadError;
//    Picture.Bitmap.OnChange := @DoOnBitmapChange;
//    Picture.Bitmap.OnFrameChanged := @DoOnFrameChanged;
  End;
  ResampleFilterList := TStringList.Create;
  With GetBZInterpolationFilters do BuildStringList(ResampleFilterList);
  ResampleFilterList.Sort;
  //Memo1.Lines.AddStrings(ResampleFilterList);
  For i:= 0 to ResampleFilterList.Count-1 do
  begin
     mni:= TMenuItem.Create(ppmStretchSettings);
     mni.RadioItem := True;
     mni.GroupIndex := 253;
     mni.Caption := ResampleFilterList.Strings[i];
     mni.AutoCheck := True;
     mni.Tag := 100 + i;
     if ResampleFilterList.Strings[i].Contains('box') then mni.Checked := true;
     mni.OnClick := @mniStretchResampleFilterClick;
     mniStretchResampleFilter.Add(mni);
  end;
  FreeAndNil(ResampleFilterList);
end;

procedure TMainForm.ImageViewMouseDown(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
Begin

  MousePoint.x := X;
  MousePoint.y := Y;
  If (ssLeft In Shift) Then
  Begin
    If (ssCTRL In Shift) Then
    Begin
      if ImageView.CanScroll then
      begin
         LastMousePoint := MousePoint;
         Screen.cursor := crSizeAll;
         lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
      End;
    End;
  End;
end;

procedure TMainForm.ImageViewMouseMove(Sender : TObject; Shift : TShiftState; X, Y : Integer);
Begin
  If ImageView.CanScroll And ((ssleft In shift) And (ssCTRL In Shift)) Then
  Begin

    FOffsetLeft := FLastOffsetLeft + x - LastMousePoint.x;
    FOffsetTop := FLastOffsetTop + y - LastMousePoint.y;

    //Screen.cursor := crSizeAll;
    //ImageView.OffsetLeft := FOffsetLeft;
    //ImageView.OffsetTop := FOffsetTop;
    sbImageViewH.Position := FOffsetLeft;
    sbImageViewV.Position := FOffsetTop;
    imageView.Invalidate;
    lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
  End
end;

procedure TMainForm.ImageViewMouseUp(Sender : TObject; Button : TMouseButton; Shift : TShiftState; X, Y : Integer);
Begin
  Screen.Cursor := crDefault;
  FLastOffsetTop := FOffsetTop;
  FLastOffsetLeft := FOffsetLeft;
end;

procedure TMainForm.ImageViewMouseWheelDown(Sender : TObject; Shift : TShiftState; MousePos : TPoint; var Handled : Boolean);
Begin
  Begin
    handled := True;
    If Not (ImageView.Stretch) Then
    Begin
      If (ssCTRL In Shift) Then
      Begin
        ZoomFactor := ZoomFactor - 1;
      End
      Else
      Begin
        ZoomFactor:= ZoomFactor - 5;
      End;
      DoZoom;
    End;
  end;
end;

procedure TMainForm.ImageViewMouseWheelUp(Sender : TObject; Shift : TShiftState; MousePos : TPoint; var Handled : Boolean);
Begin
  handled := True;
  If Not (ImageView.Stretch) Then
  Begin
    If (ssCTRL In Shift) Then
    Begin
      ZoomFactor := ZoomFactor + 1;
    End
    Else
    Begin
      ZoomFactor:= ZoomFactor + 5;
    End;
    DoZoom;
  End;
end;

procedure TMainForm.sbImageViewHChange(Sender : TObject);
Begin
  ImageView.OffsetLeft := sbImageViewH.Position;
  lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
end;

procedure TMainForm.sbImageViewVChange(Sender : TObject);
Begin
  ImageView.OffsetTop := sbImageViewV.Position;
  lblImagePos.Caption := ImageView.VirtualViewPort.left.ToString()+'x'+ImageView.VirtualViewPort.Top.ToString();
end;

procedure TMainForm.ShellListViewColumnClick(Sender : TObject; Column : TListColumn);
Begin
  ShellListView.SortColumn := Column.Index;
end;

procedure TMainForm.ShellListViewFileAdded(Sender : TObject; Item : TListItem);
Var
  Ext : String;
  dt: TDateTime;
Begin
  Ext := LowerCase(ExtractFileExt(Item.Caption));
  if (Ext = '.bmp') or (Ext = '.rle') or (Ext = '.dib') then Item.ImageIndex := 0
  else if (Ext = '.gif') then Item.ImageIndex := 1
  else if (Ext = '.jpeg') or (Ext = '.jpg') or (Ext = '.jpe') or (Ext = '.jfif') then Item.ImageIndex := 2
  else if (Ext = '.pcx') or (Ext = '.pcc') or (Ext = '.scr') then Item.ImageIndex := 3
  else if (Ext = '.pbm') or (Ext = '.pgm') or (Ext = '.pnm') or (Ext = '.ppm') or (Ext = '.pam') or (Ext = '.pfm') then Item.ImageIndex := 4
  else if (Ext = '.tga') or (Ext = '.vst') or (Ext = '.icb') or (Ext = '.vda') then Item.ImageIndex := 5
  else if (Ext = '.png') or (Ext = '.apng') or (Ext = '.mng') then Item.ImageIndex := 6
  else if (Ext = '.tif') or (Ext = '.tiff') then Item.ImageIndex := 7
  else if (Ext = '.xpm')  then Item.ImageIndex := 8;
  FileAge(ShellListView.Root+Item.Caption, dt);
 // Item.SubItems.Add(Dt.ToString(dfCustom,'DD/MM/YYYY  hh:mm'));
  Item.SubItems.Add(FormatDateTime('DD/MM/YYYY  hh:mm',Dt));

end;

procedure TMainForm.ShellListViewSelectItem(Sender : TObject; Item : TListItem; Selected : Boolean);
Begin
//  ShowMessage(ShellListView.Root+Item.Caption);
  if selected then LoadPicture(ShellListView.Root+Item.Caption);
end;

procedure TMainForm.ShellTreeViewGetImageIndex(Sender : TObject; Node : TTreeNode);
//var
//  path: String;
//  attr: LongInt;
begin
  //path := ShellTreeView1.GetPathFromNode(node);
  //attr := FileGetAttr(path);
  case Node.Expanded of
    True : Node.ImageIndex:=1;
    False: Node.ImageIndex:=0;
  end;

   //if (attr and (faHidden + faVolumeID + faSysFile)) = faHidden then
   //          Node.ImageIndex:=0 else
end;

procedure TMainForm.ShellTreeViewGetSelectedIndex(Sender : TObject; Node : TTreeNode);
Begin
  if (Node.Selected) or (nsSelected in Node.States) then  Node.SelectedIndex := 2
  else
    Node.SelectedIndex := Node.ImageIndex;

end;

procedure TMainForm.mniStretchProportionnalClick(Sender : TObject);
begin
  ImageView.Proportional := mniStretchProportionnal.Checked;
end;

procedure TMainForm.mniDisplayZoomGridClick(Sender : TObject);
begin
  ImageView.ZoomGrid := mniDisplayZoomGrid.Checked ;
 // ImageView.invalidate;
end;

procedure TMainForm.mniStretchResampleClick(Sender : TObject);
begin
  mniStretchResampleFilter.Enabled := mniStretchResample.Checked;
  Case TMenuItem(Sender).Tag of
    41 : ImageView.StretchMode := ismDraft;  // ismSmooth
    42 : ImageView.StretchMode := ismBicubic;
    //43 : ImageView.StretchMode := ismSmart;
    43, 44 : ImageView.StretchMode := ismResample;
  end;
//  imageView.Invalidate;
end;

procedure TMainForm.mniStretchResampleFilterClick(Sender : TObject);
begin
  ImageView.ResampleFilter := TBZInterpolationFilterMethod(TMenuItem(Sender).Tag - 100);
//  ImageView.Invalidate;
end;

procedure TMainForm.LoadPicture(FileName : String; const Drag : Boolean);
Begin
  Try
    Try
      Screen.Cursor := crHourGlass;
      ImageView.Picture.LoadFromFile(FileName);
     // ImageView.Picture.Bitmap.Layers.Transparent := ImageView.Transparent;
    Finally
      ImageView.Invalidate;
      with ImageView.Picture.Bitmap do
      begin
        lblFileName.Caption :=MinimizeName( FullFileName, lblFileName.Canvas ,lblFileName.ClientWidth);
        if Drag then ShellTreeView.Path := ExtractFilePath(FullFileName);
        Case DataFormatDesc.Encoding of
          etNone : lblDataCompression.Caption:='Aucun';
          etRLE : lblDataCompression.Caption:='RLE';
          etJPEG : lblDataCompression.Caption:='JPEG';
          etLZ77 : lblDataCompression.Caption:='LZ 77';
          etHuffman : lblDataCompression.Caption:='Huffman';
          // 2 : lblDataCompression.Caption:='RLE 4Bits';
          etBitFields : lblDataCompression.Caption:='Encodage BitFields';
          etLZW : lblDataCompression.Caption:='LZW';
          //  4 : if FHeaderType=bmpht_Os22x then lblDataCompression.Caption:='RLE 24Bits' else
          //4:  lblDataCompression.Caption:='JPEG';
          //5 : lblDataCompression.Caption:='PNG';
          //6 : lblDataCompression.Caption:='Encodage Alpha Bitfields';
          else lblDataCompression.Caption:='Encodage non supporté';
        end;
        lblFileFormat.Caption := DataFormatDesc.Name + ' (' + DataFormatDesc.Desc + ')';
        lblFormatVersion.Caption :=  DataFormatDesc.Version;

        lblDimension.Caption := IntToStr(Width) + ' x ' + IntToStr(Height);
        With ImageDescription Do
        Begin
          Case PixelFormat Of
            pf1Bit: lblImgBPP.Caption := '1 Bit (Monochrome)';
            pf2Bits: lblImgBPP.Caption := '2 Bits (4 Couleurs)';
            pf4Bits: lblImgBPP.Caption := '4 Bits (16 Couleurs)';
            pf8Bits: lblImgBPP.Caption := '8 Bits (256 Couleurs)';
            pf15Bits: lblImgBPP.Caption := '15 Bits';
            pf16Bits: lblImgBPP.Caption := '16 Bits';
            pf24Bits: lblImgBPP.Caption := '24 Bits';
            pf32Bits: lblImgBPP.Caption := '32 Bits';
            pf48Bits: lblImgBPP.Caption := '48 Bits';
            pf64Bits: lblImgBPP.Caption := '64 Bits';
            pf96Bits: lblImgBPP.Caption := '96 Bits';
            pf128Bits: lblImgBPP.Caption := '128 Bits';
          End;
         // lblnbFrame.Caption := FrameCount.ToString;
         lblColorFormat.Caption := BZColorFormatDesc[ColorFormat].name;
         lblImageTransparent.Caption := HasAlpha.ToString('Oui','Non');
        End;
      End;

      if ImageView.CanScroll then
      begin
        sbImageViewH.Min := ImageView.ScrollBounds.Left;
        sbImageViewH.Max := ImageView.ScrollBounds.Right;
        sbImageViewH.Position := 0;
        sbImageViewV.Min := ImageView.ScrollBounds.Top;
        sbImageViewV.Max := ImageView.ScrollBounds.Bottom;
        sbImageViewV.Position := 0;
      end;
      sbImageViewH.Enabled := ImageView.CanScrollHorizontal;
      sbImageViewV.Enabled := ImageView.CanScrollVertical;


      Screen.Cursor := crDefault;
    End;
  Except
    On E: Exception Do
    Begin
      if  E is EBZBaseException Then
      begin
       MessageDlg(E.Message, mtWarning, [mbOK], 0);
       Exit;
      end
      Else // En principe ce message ne s'affiche jamais
      Begin
       MessageDlg('Erreur Inconnue : ' +E.Message+
         #13 + #10 + 'Ok pour continuer' + #13 + #10 + 'Abandonner pour quitter l''application', mtError, [mbOK, mbAbort], 0);
      End;
    End;
  End;
End;

End.

