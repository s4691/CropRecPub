unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm4 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Treshhold: real;
    Rez: boolean;
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.FormShow(Sender: TObject);
begin
// Задание начальных параметров
  Rez:=false;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
// Выход без сохранения значения
  Rez:=false;
  Close;
end;

procedure TForm4.Button1Click(Sender: TObject);
var i: integer;
    TmpStr: string;
begin
// Выход с сохранением значения
  TmpStr:=Edit1.Text;
  for i:=1 to Length(TmpStr) do
    if TmpStr[i]='.' then
      TmpStr[i]:=',';
  try
    Treshhold:=StrToFloat(TmpStr);
  except
    on EConvertError do
      begin
        ShowMessage('Введенное значение не является числом');
        Exit;
      end;
  end;
  Rez:=true;
  Close;
end;

end.
