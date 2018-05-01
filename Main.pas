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
  LUX.GPU.OpenGL.Viewer,
  LUX.GPU.OpenGL.Atom.Shader,
  MYX.Camera,
  MYX.Shaper,
  MYX.Matery;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
      TabSheetV: TTabSheet;
        Panel1: TPanel;
          GLViewer1: TGLViewer;
          GLViewer2: TGLViewer;
        Panel2: TPanel;
          GLViewer3: TGLViewer;
          GLViewer4: TGLViewer;
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
    procedure GLViewer1DblClick(Sender: TObject);
    procedure GLViewer2DblClick(Sender: TObject);
    procedure GLViewer3DblClick(Sender: TObject);
    procedure GLViewer4DblClick(Sender: TObject);
    procedure GLViewer4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLViewer4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure GLViewer4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MemoSVSChange(Sender: TObject);
    procedure MemoSFSChange(Sender: TObject);
  private
    { Private 宣言 }
    _MouseA :TSingle2D;
    _MouseS :TShiftState;
    _MouseP :TSingle2D;
    ///// メソッド
    procedure EditShader( const Shader_:TGLShader; const Memo_:TMemo );
  public
    { Public 宣言 }
    _Camera1 :TMyCamera;
    _Camera2 :TMyCamera;
    _Camera3 :TMyCamera;
    _Camera4 :TMyCamera;
    _Matery  :TMyMatery;
    _Shaper  :TMyShaper;
    ///// メソッド
    procedure InitCamera;
    procedure InitMatery;
    procedure InitShaper;
    procedure InitViewer;
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
          TIdleTask.Run( procedure
          begin
               Shader_.Source.Assign( Memo_.Lines );
          end );
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.InitCamera;
const
     _N :Single = 0.1;
     _F :Single = 1000;
var
   C :TMyCameraData;
begin
     with C do
     begin
          Proj := TSingleM4.ProjOrth( -2.5, +2.5, -2.5, +2.5, _N, _F );

          Pose := TSingleM4.Translate( 0, +5, 0 )
                * TSingleM4.RotateX( DegToRad( -90 ) );
     end;

     _Camera1.Data := C;

     with C do
     begin
          Proj := TSingleM4.ProjOrth( -2, +2, -2, +2, _N, _F );

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +5 );
     end;

     _Camera2.Data := C;

     with C do
     begin
          Proj := TSingleM4.ProjOrth( -1.5, +1.5, -1.5, +1.5, _N, _F );

          Pose := TSingleM4.Translate( 0, 0, +5 );
     end;

     _Camera3.Data := C;

     with C do
     begin
          Proj := TSingleM4.ProjPers( -_N/2, +_N/2, -_N/2, +_N/2, _N, _F );

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +2 );
     end;

     _Camera4.Data := C;
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

               OnCompiled := procedure
               begin
                    MemoSVE.Lines.Assign( Errors );
               end;
          end;

          with ShaderF do
          begin
               Source.LoadFromFile( '..\..\_DATA\ShaderF.glsl' );

               MemoSFS.Lines.Assign( Source );

               OnCompiled := procedure
               begin
                    MemoSFE.Lines.Assign( Errors );
               end;
          end;

          with Engine do
          begin
               OnLinked := procedure
               begin
                    MemoP.Lines.Assign( Errors );

                    TabSheetV.Enabled := Status;

                    if not Status then PageControl1.TabIndex := 1;
               end;
          end;

          with Textur do
          begin
               Imager.LoadFromFile( '..\..\_DATA\Spherical_1024x1024.bmp' );
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
var
   S :TMyShaperData;
begin
     with _Shaper do
     begin
          LoadFormFunc( BraidedTorus, 1300, 100 );

          with S do
          begin
               Pose := TSingleM4.Identity;
          end;

          Data := S;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.InitViewer;
begin
     GLViewer1.OnPaint := procedure
     begin
          _Camera1.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;

     GLViewer2.OnPaint := procedure
     begin
          _Camera2.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;

     GLViewer3.OnPaint := procedure
     begin
          _Camera3.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;

     GLViewer4.OnPaint := procedure
     begin
          _Camera4.Use;
          _Matery .Use;
          _Shaper .Draw;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Camera1 := TMyCamera.Create;
     _Camera2 := TMyCamera.Create;
     _Camera3 := TMyCamera.Create;
     _Camera4 := TMyCamera.Create;
     _Matery  := TMyMatery.Create;
     _Shaper  := TMyShaper.Create;

     InitCamera;
     InitMatery;
     InitShaper;
     InitViewer;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Camera1.DisposeOf;
     _Camera2.DisposeOf;
     _Camera3.DisposeOf;
     _Camera4.DisposeOf;
     _Matery .DisposeOf;
     _Shaper .DisposeOf;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.GLViewer1DblClick(Sender: TObject);
begin
     with GLViewer1.MakeScreenShot do
     begin
          SaveToFile( 'Viewer1.bmp' );

          DisposeOf;
     end;
end;

procedure TForm1.GLViewer2DblClick(Sender: TObject);
begin
     with GLViewer2.MakeScreenShot do
     begin
          SaveToFile( 'Viewer2.bmp' );

          DisposeOf;
     end;
end;

procedure TForm1.GLViewer3DblClick(Sender: TObject);
begin
     with GLViewer3.MakeScreenShot do
     begin
          SaveToFile( 'Viewer3.bmp' );

          DisposeOf;
     end;
end;

procedure TForm1.GLViewer4DblClick(Sender: TObject);
begin
     with GLViewer4.MakeScreenShot do
     begin
          SaveToFile( 'Viewer4.bmp' );

          DisposeOf;
     end;
end;

//------------------------------------------------------------------------------

procedure TForm1.GLViewer4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     _MouseS := Shift;
     _MouseP := TSingle2D.Create( X, Y );
end;

procedure TForm1.GLViewer4MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
   P :TSingle2D;
   S :TMyShaperData;
begin
     if ssLeft in _MouseS then
     begin
          P := TSingle2D.Create( X, Y );

          _MouseA := _MouseA + ( P - _MouseP );

          with S do
          begin
               Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
                     * TSingleM4.RotateY( DegToRad( _MouseA.X ) );
          end;

          _Shaper.Data := S;

          GLViewer1.Repaint;
          GLViewer2.Repaint;
          GLViewer3.Repaint;
          GLViewer4.Repaint;

          _MouseP := P;
     end;
end;

procedure TForm1.GLViewer4MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     GLViewer4MouseMove( Sender, Shift, X, Y );

     _MouseS := [];
end;

//------------------------------------------------------------------------------

procedure TForm1.MemoSVSChange(Sender: TObject);
begin
     EditShader( _Matery.ShaderV, MemoSVS );
end;

procedure TForm1.MemoSFSChange(Sender: TObject);
begin
     EditShader( _Matery.ShaderF, MemoSFS );
end;

end. //######################################################################### ■
