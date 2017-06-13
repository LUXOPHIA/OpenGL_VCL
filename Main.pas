unit Main;

interface //#################################################################### ■

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL, Winapi.OpenGLext,
  System.UITypes,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  LUX, LUX.D1, LUX.D2, LUX.D3, LUX.M4,
  LUX.GPU.OpenGL,
  LUX.GPU.OpenGL.GLView,
  LUX.GPU.OpenGL.Shader,
  LUX.GPU.OpenGL.Scener,
  LUX.GPU.OpenGL.Camera,
  LUX.GPU.OpenGL.Shaper,
  LUX.GPU.OpenGL.Matery.VCL;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
      TabSheetV: TTabSheet;
        Panel1: TPanel;
          GLView1: TGLView;
          GLView2: TGLView;
        Panel2: TPanel;
          GLView3: TGLView;
          GLView4: TGLView;
      TabSheetS: TTabSheet;
        PageControlS: TPageControl;
          TabSheetSV: TTabSheet;
            MemoSVS: TMemo;
            SplitterSV: TSplitter;
            MemoSVE: TMemo;
          TabSheetSF: TTabSheet;
            MemoSFS: TMemo;
            SplitterSF: TSplitter;
            MemoSFE: TMemo;
      TabSheetP: TTabSheet;
        MemoP: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MemoSVSChange(Sender: TObject);
    procedure MemoSFSChange(Sender: TObject);
    procedure GLView4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLView4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure GLView4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private 宣言 }
    _MouseA :TSingle2D;
    _MouseS :TShiftState;
    _MouseP :TSingle2D;
    ///// メソッド
    procedure EditShader( const Shader_:TGLShader; const Memo_:TMemo );
  public
    { Public 宣言 }
    _Scener  :TGLScener;
    _Shaper  :TGLShaper;
    _Matery  :TGLMateryI;
    _Camera1 :TGLCameraOrth;
    _Camera2 :TGLCameraOrth;
    _Camera3 :TGLCameraOrth;
    _Camera4 :TGLCameraPers;
    ///// メソッド
    procedure InitViewer;
    procedure InitCamera;
    procedure InitMatery;
    procedure InitShaper;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.dfm}

uses System.Math;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.EditShader( const Shader_:TGLShader; const Memo_:TMemo );
begin
     if Memo_.Focused then
     begin
          TabSheetV.Enabled := False;

          TIdleTask.Run( procedure
          begin
               Shader_.Source.Assign( Memo_.Lines );

               with _Matery.Engine do
               begin
                    TabSheetV.Enabled := Status;

                    if not Status then PageControl1.TabIndex := 1;
               end;
          end );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitViewer;
begin
     GLView1.Camera := _Camera1;
     GLView2.Camera := _Camera2;
     GLView3.Camera := _Camera3;
     GLView4.Camera := _Camera4;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitCamera;
begin
     with _Camera1 do
     begin
          Size := 5;

          Move := TSingleM4.Translate( 0, +5, 0 )
                * TSingleM4.RotateX( DegToRad( -90 ) );
     end;

     with _Camera2 do
     begin
          Size := 4;

          Move := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera3 do
     begin
          Size := 3;

          Move := TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera4 do
     begin
          Angl := DegToRad( 60{°} );

          Move := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +3 );
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitMatery;
begin
     with _Matery do
     begin
          with ShaderV do
          begin
               Source.LoadFromFile( '..\..\_DATA\ShaderV.glsl' );

               MemoSVS.Lines.Assign( Source );
          end;

          with ShaderF do
          begin
               Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

               MemoSFS.Lines.Assign( Source );
          end;

          Imager.LoadFromFile( '..\..\_DATA\Spherical_1024x1024.bmp' );

          OnBuilded := procedure
          begin
               MemoSVE.Lines.Assign( ShaderV.Errors );
               MemoSFE.Lines.Assign( ShaderF.Errors );
               MemoP  .Lines.Assign( Engine .Errors );
          end;
     end;
end;

//------------------------------------------------------------------------------

function BraidedTorus( const T_:TdSingle2D ) :TdSingle3D;
const
     LoopR :Single = 1.0;  LoopN :Integer = 3; 
     TwisR :Single = 0.5;  TwisN :Integer = 5;
     PipeR :Single = 0.3;
var
   T :TdSingle2D;
   cL, cT, cP, TX, PX, R,
   sL, sT, sP, TY, PY, H :TdSingle;
begin
     T := Pi2 * T_;

     CosSin( LoopN * T.U, cL, sL );
     CosSin( TwisN * T.U, cT, sT );
     CosSin(         T.V, cP, sP );

     TX := TwisR * cT;  PX := PipeR * cP;
     TY := TwisR * sT;  PY := PipeR * sP;

     R := LoopR * ( 1 + TX ) + PX  ;
     H := LoopR * (     TY   + PY );

     with Result do
     begin
          X := R * cL;
          Y := H     ;
          Z := R * sL;
     end;
end;

procedure TForm1.InitShaper;
begin
     with _Shaper do
     begin
          LoadFromFunc( BraidedTorus, 1300, 100 );

          Matery := _Matery;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _MouseS := [];
     _MouseP := TSingle2D.Create( 0, 0 );
     _MouseA := TSingle2D.Create( 0, 0 );

     _Scener  := TGLScener.Create;

     _Camera1 := TGLCameraOrth.Create( _Scener );
     _Camera2 := TGLCameraOrth.Create( _Scener );
     _Camera3 := TGLCameraOrth.Create( _Scener );
     _Camera4 := TGLCameraPers.Create( _Scener );

     _Matery  := TGLMateryI.Create;

     _Shaper  := TGLShaper.Create( _Scener );

     InitViewer;
     InitCamera;
     InitMatery;
     InitShaper;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Scener.DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.MemoSVSChange(Sender: TObject);
begin
     EditShader( _Matery.ShaderV, MemoSVS );
end;

procedure TForm1.MemoSFSChange(Sender: TObject);
begin
     EditShader( _Matery.ShaderF, MemoSFS );
end;

//------------------------------------------------------------------------------

procedure TForm1.GLView4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     _MouseS := Shift;
     _MouseP := TSingle2D.Create( X, Y );
end;

procedure TForm1.GLView4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
   P :TSingle2D;
begin
     if ssLeft in _MouseS then
     begin
          P := TSingle2D.Create( X, Y );

          _MouseA := _MouseA + ( P - _MouseP );

          _Shaper.Move := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
                        * TSingleM4.RotateY( DegToRad( _MouseA.X ) );

          GLView1.Repaint;
          GLView2.Repaint;
          GLView3.Repaint;
          GLView4.Repaint;

          _MouseP := P;
     end;
end;

procedure TForm1.GLView4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     GLView4MouseMove( Sender, Shift, X, Y );

     _MouseS := [];
end;

end. //######################################################################### ■
