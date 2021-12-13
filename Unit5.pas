unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Unit2, StdCtrls;

type
  TForm5 = class(TForm)
    Image1: TImage;
    Edit1: TEdit;
    Edit2: TEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure DrawBlancGraph;
    procedure DrawGraph;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GraphRezult: boolean;
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.DrawBlancGraph;
var i: integer;
    X, Y: integer;
    TmpInt: integer;
    TmpStr: string;
    Month: array[1..13] of integer;
    MonthName: array[1..12] of string;
    Rect: TRect;
begin
// ��������� ������� ���� ��������
  Month[1]:=1;
  Month[2]:=32;
  Month[3]:=60;
  Month[4]:=91;
  Month[5]:=121;
  Month[6]:=152;
  Month[7]:=182;
  Month[8]:=213;
  Month[9]:=244;
  Month[10]:=274;
  Month[11]:=305;
  Month[12]:=335;
  Month[13]:=365;
  MonthName[1]:='���';
  MonthName[2]:='���';
  MonthName[3]:='���';
  MonthName[4]:='���';
  MonthName[5]:='���';
  MonthName[6]:='���';
  MonthName[7]:='���';
  MonthName[8]:='���';
  MonthName[9]:='���';
  MonthName[10]:='���';
  MonthName[11]:='���';
  MonthName[12]:='���';
  with Image1 do
    begin
      Rect.Top:=0;
      Rect.Bottom:=Height;
      Rect.Left:=0;
      Rect.Right:=Width;
      Canvas.Brush.Color:=clWhite;
      Canvas.FillRect(Rect);
      Canvas.Pen.Width:=1;
      Canvas.Pen.Color:=RGB(200,200,200);
      for i:=1 to 100 do
        begin
          Y:=10+Round(((Height-40)/100)*(i-1));
          Canvas.MoveTo(30,Y);
          Canvas.LineTo(Width-10,Y);
        end;
      Canvas.Pen.Width:=2;
      Canvas.Pen.Color:=RGB(200,200,200);
      for i:=1 to 10 do
        begin
          Y:=10+Round(((Height-40)/10)*(i-1));
          Canvas.MoveTo(30,Y);
          Canvas.LineTo(Width-10,Y);
        end;
      Canvas.Pen.Width:=1;
      for i:=1 to 73 do
        begin
          X:=30+Round((Width-40)/73*i);
          Canvas.MoveTo(X,10);
          Canvas.LineTo(X,Height-30);
        end;
      Canvas.Pen.Width:=2;
      for i:=1 to 12 do
        begin
          X:=30+Round((Width-40)*Month[i]/365);
          Canvas.MoveTo(X,10);
          Canvas.LineTo(X,Height-30);
        end;
      Canvas.Pen.Color:=clBlack;
      Canvas.MoveTo(30,Height-30);
      Canvas.LineTo(Width-10,Height-30);
      Canvas.MoveTo(30,Height-30);
      Canvas.LineTo(30,10);
      for i:=0 to 10 do
        begin
          Str((10-i)/10:3:1,TmpStr);
          Y:=4+Round(((Height-40)/10)*i);
          Canvas.TextOut(10,Y,TmpStr);
        end;
      TmpStr:=IntToStr(DataNum[1]);
      Canvas.TextOut(25,Height-25,TmpStr);
      for i:=2 to 12 do
        begin
          TmpStr:=IntToStr(Month[i]);
          X:=30+Round((Width-40)*Month[i]/365)-7;
          Canvas.TextOut(X,Height-25,TmpStr);
        end;
      for i:=1 to 12 do
        begin
          TmpInt:=Round((Month[i]+Month[i+1])/2);
          X:=30+Round((Width-40)*TmpInt/365)-7;
          Canvas.TextOut(X,Height-20,MonthName[i]);
        end;
    end;
end;

procedure TForm5.DrawGraph;
var i, j: integer;
    X, Y: integer;
begin
// ��������� ��������
  Edit1.Text:=IntToStr(BegDt);
  Edit2.Text:=IntToStr(EndDt);
  with Form5.Image1 do
    begin
      for i:=1 to LineNum do
        begin
          Canvas.Pen.Color:=RGB(GraphColor[i,1],GraphColor[i,2],GraphColor[i,3]);
          Canvas.Pen.Width:=1;
          Y:=(Height-30)-Round(Data[i,1]*(Height-40));
          Canvas.MoveTo(30,Y);
          for j:=2 to ColNum do
            begin
              X:=30+Round((Width-40)/ColNum*j);
              Y:=(Height-30)-Round(Data[i,j]*(Height-40));
              Canvas.LineTo(X,Y);
            end;
        end;
      Canvas.Pen.Color:=clBlack;
      Canvas.Pen.Width:=3;
      X:=30+Round((Width-40)/ColNum*BegDt);
      Canvas.MoveTo(X,10);
      Canvas.LineTo(X,Height-30);
      X:=30+Round((Width-40)/ColNum*EndDt);
      Canvas.MoveTo(X,10);
      Canvas.LineTo(X,Height-30);
    end;
  Image1.Invalidate;
end;

procedure TForm5.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
// ����� ��������� � �������� ����
  with Image1 do
    begin
      Canvas.Pen.Color:=clBlack;
      Canvas.Pen.Width:=3;
      Canvas.MoveTo(X,10);
      Canvas.LineTo(X,Height-30);
      if RadioButton1.Checked then
        BegDt:=Round((X-30)*ColNum/(Width-40));
      if RadioButton2.Checked then
        EndDt:=Round((X-30)*ColNum/(Width-40));
    end;
  DrawBlancGraph;
  DrawGraph;
  Edit1.Text:=IntToStr(BegDt);
  Edit2.Text:=IntToStr(EndDt);
end;

procedure TForm5.RadioButton1Click(Sender: TObject);
begin
// ������������ ������ ��������� � �������� ����
  RadioButton2.Checked:=false;
end;

procedure TForm5.RadioButton2Click(Sender: TObject);
begin
  RadioButton1.Checked:=false;
end;

procedure TForm5.Button1Click(Sender: TObject);
begin
// ������������� ����� ���
  GraphRezult:=true;
  Close;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
// ������ ����� ���
  GraphRezult:=true;
  Close;
end;

end.
