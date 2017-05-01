unit Main;

interface //#################################################################### ■

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.OpenGL,
  Vcl.ExtCtrls,
  LUX.GPU.OpenGL.VCL.GLView;

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
    procedure DrawModel;
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.dfm}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

/////////////////////////////////////////////////////////////////////// メソッド

procedure TForm1.DrawModel;
begin
     glBegin( GL_TRIANGLES );

       glColor3f( 1.0, 0.0, 0.0 );  glVertex3f( +1.0, -1.0, +1.0 ); //R
       glColor3f( 0.0, 1.0, 0.0 );  glVertex3f( +1.0, +1.0, -1.0 ); //G
       glColor3f( 0.0, 0.0, 1.0 );  glVertex3f( -1.0, +1.0, +1.0 ); //B

       glColor3f( 1.0, 1.0, 1.0 );  glVertex3f( -1.0, -1.0, -1.0 ); //W
       glColor3f( 1.0, 0.0, 0.0 );  glVertex3f( +1.0, -1.0, +1.0 ); //R
       glColor3f( 0.0, 0.0, 1.0 );  glVertex3f( -1.0, +1.0, +1.0 ); //B

       glColor3f( 1.0, 1.0, 1.0 );  glVertex3f( -1.0, -1.0, -1.0 ); //W
       glColor3f( 0.0, 0.0, 1.0 );  glVertex3f( -1.0, +1.0, +1.0 ); //B
       glColor3f( 0.0, 1.0, 0.0 );  glVertex3f( +1.0, +1.0, -1.0 ); //G

       glColor3f( 1.0, 1.0, 1.0 );  glVertex3f( -1.0, -1.0, -1.0 ); //W
       glColor3f( 0.0, 1.0, 0.0 );  glVertex3f( +1.0, +1.0, -1.0 ); //G
       glColor3f( 1.0, 0.0, 0.0 );  glVertex3f( +1.0, -1.0, +1.0 ); //R

     glEnd;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     _Angle := 0;

     GLView1.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -2, +2, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView2.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -4, +4, -2, +2, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
            glRotatef( _Angle, 0, 1, 0 );
            DrawModel;
     end;

     GLView3.OnPaint := procedure
     begin
          glMatrixMode( GL_PROJECTION );
            glLoadIdentity;
            glOrtho( -3, +3, -3, +3, 0.1, 100 );
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
            glOrtho( -4, +4, -3, +3, 0.1, 100 );
          glMatrixMode( GL_MODELVIEW );
            glLoadIdentity;
            glTranslatef( 0, 0, -5 );
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
