unit Main;

interface //#################################################################### ■

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL,
  System.UITypes,
  Vcl.ExtCtrls,
  LUX, LUX.D3, LUX.GPU.OpenGL.GLView;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
      GLView1: TGLView;
      GLView2: TGLView;
    GLView3: TGLView;
    GLView4: TGLView;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private 宣言 }
    _Angle :Single;
  public
    { Public 宣言 }
    ///// メソッド
    procedure MakeModel;
    procedure DrawModel;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.dfm}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.MakeModel;
begin
     glEnableClientState( GL_VERTEX_ARRAY );
     glEnableClientState( GL_COLOR_ARRAY  );
end;

procedure TForm1.DrawModel;                                                     { OpenGL 1.1 (1997) }
const
     Ps :array [ 0..8-1 ] of TSingle3D = ( ( X:-1; Y:-1; Z:-1 ),
                                           ( X:+1; Y:-1; Z:-1 ),
                                           ( X:-1; Y:+1; Z:-1 ),
                                           ( X:+1; Y:+1; Z:-1 ),
                                           ( X:-1; Y:-1; Z:+1 ),
                                           ( X:+1; Y:-1; Z:+1 ),
                                           ( X:-1; Y:+1; Z:+1 ),
                                           ( X:+1; Y:+1; Z:+1 ) );
     Cs :array [ 0..8-1 ] of TAlphaColorF = ( ( R:0; G:0; B:0; A:1 ),
                                              ( R:1; G:0; B:0; A:1 ),
                                              ( R:0; G:1; B:0; A:1 ),
                                              ( R:1; G:1; B:0; A:1 ),
                                              ( R:0; G:0; B:1; A:1 ),
                                              ( R:1; G:0; B:1; A:1 ),
                                              ( R:0; G:1; B:1; A:1 ),
                                              ( R:1; G:1; B:1; A:1 ) );
     Fs :array [ 0..12-1 ] of TCardinal3D = ( ( _1:0; _2:4; _3:6 ), ( _1:6; _2:2; _3:0 ),
                                              ( _1:0; _2:1; _3:5 ), ( _1:5; _2:4; _3:0 ),
                                              ( _1:0; _2:2; _3:3 ), ( _1:3; _2:1; _3:0 ),
                                              ( _1:7; _2:5; _3:1 ), ( _1:1; _2:3; _3:7 ),
                                              ( _1:7; _2:3; _3:2 ), ( _1:2; _2:6; _3:7 ),
                                              ( _1:7; _2:6; _3:4 ), ( _1:4; _2:5; _3:7 ) );
begin
     //    2-------3
     //   /|      /|
     //  6-------7 |
     //  | |     | |
     //  | 0-----|-1
     //  |/      |/
     //  4-------5

     glVertexPointer( 3, GL_FLOAT, 0, @Ps[ 0 ] );
     glColorPointer ( 4, GL_FLOAT, 0, @Cs[ 0 ] );

     glDrawElements( GL_TRIANGLES, 3{Poin} * 12{Face}, GL_UNSIGNED_INT, @Fs[ 0 ] );
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
const
     C0 :Single = 0.1;
     C1 :Single = 1000;
begin
     _Angle := 0;

     MakeModel;

     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, C0, C1 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( +90, 1, 0, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView2.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -4, +4, -2, +2, C0, C1 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( -90, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView3.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -3, +3, C0, C1 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView4.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glFrustum( -4/8*C0, +4/8*C0,
                       -3/8*C0, +3/8*C0, C0, C1 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -8 );
            glRotatef( +30, 1, 0, 0 );
            glRotatef( -30, 0, 1, 0 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;
end;

////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     _Angle := _Angle + 1;

     GLView1.Repaint;
     GLView2.Repaint;
     GLView3.Repaint;
     GLView4.Repaint;
end;

end. //######################################################################### ■
