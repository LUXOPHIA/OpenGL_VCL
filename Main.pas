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
  LUX.GPU.OpenGL.Viewer,
  LUX.GPU.OpenGL.Atom.Shader,
  LUX.GPU.OpenGL.Scener,
  LUX.GPU.OpenGL.Camera,
  LUX.GPU.OpenGL.Shaper,
  LUX.GPU.OpenGL.Matery.VCL;

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
          TabSheetSG: TTabSheet;
            MemoSGS: TMemo;
            SplitterSG: TSplitter;
            MemoSGE: TMemo;
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
    procedure MemoSGSChange(Sender: TObject);
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
    _Scener  :TGLScener;
    _Camera1 :TGLCameraOrth;
    _Camera2 :TGLCameraOrth;
    _Camera3 :TGLCameraOrth;
    _Camera4 :TGLCameraPers;
    _Matery  :TGLMateryImagG;
    _Shaper  :TGLShaperFace;
    ///// メソッド
    procedure MakeCamera;
    procedure MakeMatery;
    procedure MakeShaper;
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

procedure TForm1.MakeCamera;
begin
     _Camera1 := TGLCameraOrth.Create( _Scener );
     _Camera2 := TGLCameraOrth.Create( _Scener );
     _Camera3 := TGLCameraOrth.Create( _Scener );
     _Camera4 := TGLCameraPers.Create( _Scener );

     with _Camera1 do
     begin
          Size := 5;

          Pose := TSingleM4.Translate( 0, +5, 0 )
                * TSingleM4.RotateX( DegToRad( -90 ) );
     end;

     with _Camera2 do
     begin
          Size := 4;

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera3 do
     begin
          Size := 3;

          Pose := TSingleM4.Translate( 0, 0, +5 );
     end;

     with _Camera4 do
     begin
          Angl := DegToRad( 60{°} );

          Pose := TSingleM4.RotateX( DegToRad( -45 ) )
                * TSingleM4.Translate( 0, 0, +2 );
     end;

     GLViewer1.Camera := _Camera1;
     GLViewer2.Camera := _Camera2;
     GLViewer3.Camera := _Camera3;
     GLViewer4.Camera := _Camera4;
end;

//------------------------------------------------------------------------------

procedure TForm1.MakeMatery;
begin
     _Matery := TGLMateryImagG.Create;

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

          with ShaderG do
          begin
               Source.LoadFromFile( '..\..\_DATA\ShaderG.glsl' );

               MemoSGS.Lines.Assign( Source );

               OnCompiled := procedure
               begin
                    MemoSGE.Lines.Assign( Errors );
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

          with Progra do
          begin
               OnLinked := procedure
               begin
                    MemoP.Lines.Assign( Errors );

                    TabSheetV.Enabled := Status;

                    if not Status then PageControl1.TabIndex := 1;
               end;
          end;

          with Imager do
          begin
               LoadFromFile( '..\..\_DATA\Spherical_1024x1024.bmp' );
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

procedure TForm1.MakeShaper;
begin
     _Shaper := TGLShaperFace.Create( _Scener );

     with _Shaper do
     begin
          LoadFromFunc( BraidedTorus, 1300, 100 );

          Matery := _Matery;
     end;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Scener := TGLScener.Create;

     MakeCamera;
     MakeMatery;
     MakeShaper;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     _Scener.DisposeOf;
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
begin
     if ssLeft in _MouseS then
     begin
          P := TSingle2D.Create( X, Y );

          _MouseA := _MouseA + ( P - _MouseP );

          _Shaper.Pose := TSingleM4.RotateX( DegToRad( _MouseA.Y ) )
                        * TSingleM4.RotateY( DegToRad( _MouseA.X ) );

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

procedure TForm1.MemoSGSChange(Sender: TObject);
begin
     EditShader( _Matery.ShaderG, MemoSGS );
end;

procedure TForm1.MemoSFSChange(Sender: TObject);
begin
     EditShader( _Matery.ShaderF, MemoSFS );
end;

end. //######################################################################### ■
