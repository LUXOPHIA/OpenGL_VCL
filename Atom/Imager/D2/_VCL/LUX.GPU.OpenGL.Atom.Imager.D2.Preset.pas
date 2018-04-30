unit LUX.GPU.OpenGL.Atom.Imager.D2.Preset;

interface //#################################################################### ■

uses System.UITypes,
     Vcl.Graphics,
     LUX, LUX.GPU.OpenGL.Atom.Imager.D2;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【型】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiIma2D_TAlphaColorF

     TGLPoiIma2D_TAlphaColorF = class( TGLPoiIma2D<TAlphaColorF> )
     private
     protected
     public
       constructor Create;
       destructor Destroy; override;
       ///// メソッド
       procedure ImportFrom( const BMP_:TBitmap );
       procedure ExportTo( const BMP_:TBitmap );
       procedure LoadFromFile( const FileName_:String );
       procedure SaveToFile( const FileName_:String );
     end;

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelIma2D_TAlphaColorF

     TGLCelIma2D_TAlphaColorF = class( TGLCelIma2D<TAlphaColorF> )
     private
     protected
     public
       constructor Create;
       destructor Destroy; override;
       ///// メソッド
       procedure ImportFrom( const BMP_:TBitmap );
       procedure ExportTo( const BMP_:TBitmap );
       procedure LoadFromFile( const FileName_:String );
       procedure SaveToFile( const FileName_:String );
     end;

//const //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【定数】

//var //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【変数】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

implementation //############################################################### ■

uses Winapi.OpenGL, Winapi.OpenGLext;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【レコード】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【クラス】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLPoiIma2D_TAlphaColorF

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLPoiIma2D_TAlphaColorF.Create;
begin
     inherited;

     _TexelF := GL_RGBA32F;
     _PixelF := GL_RGBA;
     _PixelT := GL_FLOAT;
end;

destructor TGLPoiIma2D_TAlphaColorF.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLPoiIma2D_TAlphaColorF.ImportFrom( const BMP_:TBitmap );
var
   X, Y :Integer;
   C :TAlphaColorF;
begin
     Texels.PoinsX := BMP_.Width ;
     Texels.PoinsY := BMP_.Height;

     for Y := 0 to Texels.PoinsY-1 do
     begin
          for X := 0 to Texels.PoinsX-1 do
          begin
               with TColorRec( BMP_.Canvas.Pixels[ X, Y ] ) do
               begin
                    C.R := R / 255;
                    C.G := G / 255;
                    C.B := B / 255;
                    C.A := 1      ;
               end;

               Texels[ X, Y ] := C;
          end;
     end;

     SendData;
end;

procedure TGLPoiIma2D_TAlphaColorF.ExportTo( const BMP_:TBitmap );
var
   X, Y :Integer;
begin
     BMP_.SetSize( Texels.PoinsX, Texels.PoinsY );

     for Y := 0 to Texels.PoinsY-1 do
     begin
          for X := 0 to Texels.PoinsX-1 do
          begin
               BMP_.Canvas.Pixels[ X, Y ] := Texels[ X, Y ].ToAlphaColor;
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TGLPoiIma2D_TAlphaColorF.LoadFromFile( const FileName_:String );
var
   B :TBitmap;
begin
     B := TBitmap.Create;

     B.LoadFromFile( FileName_ );

     ImportFrom( B );

     B.DisposeOf;
end;

procedure TGLPoiIma2D_TAlphaColorF.SaveToFile( const FileName_:String );
var
   B :TBitmap;
begin
     B := TBitmap.Create;

     ExportTo( B );

     B.SaveToFile( FileName_ );

     B.DisposeOf;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TGLCelIma2D_TAlphaColorF

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& protected

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TGLCelIma2D_TAlphaColorF.Create;
begin
     inherited;

     _TexelF := GL_RGBA32F;
     _PixelF := GL_RGBA;
     _PixelT := GL_FLOAT;
end;

destructor TGLCelIma2D_TAlphaColorF.Destroy;
begin

     inherited;
end;

/////////////////////////////////////////////////////////////////////// メソッド

procedure TGLCelIma2D_TAlphaColorF.ImportFrom( const BMP_:TBitmap );
var
   X, Y :Integer;
   C :TAlphaColorF;
begin
     Texels.CellsX := BMP_.Width ;
     Texels.CellsY := BMP_.Height;

     for Y := 0 to Texels.CellsY-1 do
     begin
          for X := 0 to Texels.CellsX-1 do
          begin
               with TColorRec( BMP_.Canvas.Pixels[ X, Y ] ) do
               begin
                    C.R := R / 255;
                    C.G := G / 255;
                    C.B := B / 255;
                    C.A := 1      ;
               end;

               Texels[ X, Y ] := C;
          end;
     end;

     SendData;
end;

procedure TGLCelIma2D_TAlphaColorF.ExportTo( const BMP_:TBitmap );
var
   X, Y :Integer;
begin
     BMP_.SetSize( Texels.CellsX, Texels.CellsY );

     for Y := 0 to Texels.CellsY-1 do
     begin
          for X := 0 to Texels.CellsX-1 do
          begin
               BMP_.Canvas.Pixels[ X, Y ] := Texels[ X, Y ].ToAlphaColor;
          end;
     end;
end;

//------------------------------------------------------------------------------

procedure TGLCelIma2D_TAlphaColorF.LoadFromFile( const FileName_:String );
var
   B :TBitmap;
begin
     B := TBitmap.Create;

     B.LoadFromFile( FileName_ );

     ImportFrom( B );

     B.DisposeOf;
end;

procedure TGLCelIma2D_TAlphaColorF.SaveToFile( const FileName_:String );
var
   B :TBitmap;
begin
     B := TBitmap.Create;

     ExportTo( B );

     B.SaveToFile( FileName_ );

     B.DisposeOf;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【ルーチン】

//############################################################################## □

initialization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 初期化

finalization //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 最終化

end. //######################################################################### ■