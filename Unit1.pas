unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleServer, Excel2000, ComObj, Grids, StdCtrls, ExtCtrls, Math,
  Unit2, Unit3, Unit4, Unit5, Buttons, Menus, Gauges;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    StringGrid1: TStringGrid;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    SaveDialog1: TSaveDialog;
    PopupMenu2: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    Label16: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label1: TLabel;
    Button6: TButton;
    Button8: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button10: TButton;
    Button12: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Gauge1: TGauge;
    Gauge2: TGauge;
    Label9: TLabel;
    Label10: TLabel;
    Button26: TButton;
    Label11: TLabel;
    Edit3: TEdit;
    Label12: TLabel;
    Edit4: TEdit;
    Button37: TButton;
    Gauge3: TGauge;
    Gauge4: TGauge;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Gauge9: TGauge;
    Gauge10: TGauge;
    Button5: TButton;
    Button7: TButton;
    Button9: TButton;
    Button11: TButton;
    Button13: TButton;
    Button16: TButton;
    Edit5: TEdit;
    Edit6: TEdit;
    Button17: TButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Panel1: TPanel;
    Panel5: TPanel;

    function StrIsReal(AString: string; var AReal: real): boolean;
    procedure CheckAllDone(Num: integer);
    procedure MakeCompData;
    procedure FormCreate(Sender: TObject);

    procedure AddFieldClusterSRC(Num: integer);
    procedure AddFieldNeuronSRC(Num: integer);

    procedure RemoveFieldClusterSRC(Num: integer);
    procedure RemoveFieldNeuronSRC(Num: integer);

    procedure RecLearnEtalon(Num: integer);
    procedure RecLearnClasterSRC(Num: integer);
    procedure RecLearnNeuronSRC(Num: integer);

    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid4DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure N2Click(Sender: TObject);

    procedure Button8Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button37Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  AllDone: boolean;
  Iterations, Precision: integer;
  RecDone: array[1..3] of boolean;

implementation

{$R *.dfm}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// Технические процедуры //////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.FormCreate(Sender: TObject);
var i, j: integer;
begin
// Задание начальных параметров
  DataLoaded:=false;
  LearnLoaded:=false;
  CompDataCalculated:=false;
  LineNum:=0;
  ColNum:=0;
  Label2.Caption:='0';
  Label16.Caption:='0';
  Label20.Caption:='0';
  EtCount:=0;
  CSCount:=0;
  NSCount:=0;
  for i:=1 to 5000 do
    begin
      CSLearning[i]:=false;
      NSLearning[i]:=false;
      EtRezult[i]:=0;
      CSRezult[i]:=0;
      NSRezult[i]:=0;
      EtName[i]:='';
      CSName[i]:='';
      NSName[i]:='';
      EtRes[i]:=false;
      CSRes[i]:=false;
      NSRes[i]:=false;
    end;
  for i:=1 to 100 do
    for j:=1 to 400 do
      begin
        NSMul[i,j]:=0;
        NSWeight[i,j]:=0;
      end;
  for i:=1 to 100 do
    begin
      NSSumMul[i]:=0;
      NSSigmoid[i]:=0;
      NSLimit[i]:=0.9;
      NSRezLoc[i]:=0;
    end;
  StringGrid1.Cells[0,0]:='ID';
  StringGrid1.Cells[1,0]:='Crop';
  StringGrid1.Cells[2,0]:='Res';
  StringGrid1.Cells[3,0]:='Dist';
  StringGrid3.Cells[0,0]:='ID';
  StringGrid3.Cells[1,0]:='Crop';
  StringGrid3.Cells[2,0]:='Res';
  StringGrid3.Cells[3,0]:='Dist';
  StringGrid4.Cells[0,0]:='ID';
  StringGrid4.Cells[1,0]:='Crop';
  StringGrid4.Cells[2,0]:='Res';
  StringGrid4.Cells[3,0]:='Sig';
  for i:=1 to 5000 do
    for j:=1 to 3 do
      GraphColor[i,j]:=Random(255);
end;

function TForm1.StrIsReal(AString: string; var AReal: real): boolean;
begin
// Проверка является ли строка числом с плавающей точкой
  if AString='' then
    begin
      StrIsReal:=false;
      ShowMessage('Данная строка не является числом');
      Exit;
    end
  else
    begin
      AReal:=StrToFloat(AString);
      StrIsReal:=true;
    end;
end;

procedure TForm1.CheckAllDone(Num: integer);
var i: integer;
begin
// Проверка на завершение обучения и распознавания всеми алгоритмами
  RecDone[Num]:=true;
  AllDone:=true;
  for i:=1 to 3 do
    if not RecDone[i] then
      AllDone:=false;
  if AllDone then
    begin
      Button13.Enabled:=true;
      Button16.Enabled:=true;
    end;
end;

procedure TForm1.N2Click(Sender: TObject);
var i, j: integer;
begin
// Удаление объекта из датасета для обучения по эталонам
  for i:=Row1 to LineNum-1 do
    begin
      FieldID[i]:=FieldID[i+1];
      Crop[i]:=Crop[i+1];
      for j:=1 to ColNum do
        Data[i,j]:=Data[i+1,j];
      for j:=1 to CompNum do
        CompData[i,j]:=CompData[i+1,j];
    end;
    dec(LineNum);
    for i:=1 to LineNum do
      begin
        StringGrid1.Cells[0,i]:=IntToStr(FieldID[i]);
        StringGrid3.Cells[0,i]:=IntToStr(FieldID[i]);
        StringGrid4.Cells[0,i]:=IntToStr(FieldID[i]);
        StringGrid1.Cells[1,i]:=Crop[i];
        StringGrid3.Cells[1,i]:=Crop[i];
        StringGrid4.Cells[1,i]:=Crop[i];
        StringGrid1.Cells[2,i]:='';
        StringGrid3.Cells[2,i]:='';
        StringGrid4.Cells[2,i]:='';
        StringGrid1.Cells[3,i]:='';
        StringGrid3.Cells[3,i]:='';
        StringGrid4.Cells[3,i]:='';
        EtName[i]:='';
      end;
    StringGrid1.RowCount:=LineNum+1;
    StringGrid3.RowCount:=LineNum+1;
    StringGrid4.RowCount:=LineNum+1;
    Gauge9.Progress:=0;
    Gauge10.Progress:=0;
    EtCount:=0;
end;

procedure TForm1.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var P: TPoint;
begin
// Выделение строки в StringGrid1 с исходными данными
  Win32Check(GetCursorPos(P));
  P:=(Sender as TStringGrid).ScreenToClient(P);
  TStringGrid(Sender).MouseToCell(P.X,P.Y,Col1,Row1);
  P:=GetClientOrigin;
end;

procedure TForm1.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var Point: TPoint;
begin
// Удаление поля из обучающей выборки
  if CompDataCalculated then
    begin
      if (Row1>0) and (Col1=2) then
        begin
          GetCursorPos(Point);
          PopupMenu2.Popup(Point.X,Point.Y);
        end;
    end;
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
// Отрисовка индикаторов резульатов распознавания кластеризацией по эталонам
  if DataLoaded then
    begin
      with StringGrid1 do
        begin
          if (ACol=2) and (ARow>0) then
            begin
              Canvas.Brush.Color:=clWhite;
              Canvas.Font.Color:=clBlack;
              if Cells[ACol,ARow]<>'' then
                begin
                  if EtRes[ARow] then
                    Canvas.Brush.Color:=clGreen
                  else
                    Canvas.Brush.Color:=clRed;
                end;
              Canvas.FillRect(Rect);
              Canvas.TextOut(Rect.Left+2,Rect.Top+2,EtName[ARow]);
            end;
        end;
    end;
end;

procedure TForm1.StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
// Отрисовка индикаторов включения поля в обучающую выборку и индикаторов распознавания
  if DataLoaded then
    begin
      with StringGrid3 do
        begin
          if (ACol<2) and (ARow>0) then
            begin
              if CSLearning[ARow] then
                begin
                  Canvas.Brush.Color:=RGB(43,53,205);
                  Canvas.Font.Color:=clWhite;
                end
              else
                begin
                  Canvas.Brush.Color:=clWhite;
                  Canvas.Font.Color:=clBlack;
                end;
              Canvas.FillRect(Rect);
              Canvas.TextOut(Rect.Left+2,Rect.Top+2,Cells[ACol,ARow]);
            end;
          if (ACol=2) and (ARow>0) then
            begin
              Canvas.Brush.Color:=clWhite;
              Canvas.Font.Color:=clBlack;
              if Cells[ACol,ARow]<>'' then
                begin
                  if CSRes[ARow] then
                    Canvas.Brush.Color:=clGreen
                  else
                    Canvas.Brush.Color:=clRed;
                end;
              Canvas.FillRect(Rect);
              Canvas.TextOut(Rect.Left+2,Rect.Top+2,CSName[ARow]);
            end;
        end;
    end;
end;

procedure TForm1.StringGrid4DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
// Отрисовка индикаторов распознавания для нейроссети по исходным данным
  if DataLoaded then
    begin
      with StringGrid4 do
        begin
          if (ACol<2) and (ARow>0) then
            begin
              if NSLearning[ARow] then
                begin
                  Canvas.Brush.Color:=RGB(43,53,205);
                  Canvas.Font.Color:=clWhite;
                end
              else
                begin
                  Canvas.Brush.Color:=clWhite;
                  Canvas.Font.Color:=clBlack;
                end;
              Canvas.FillRect(Rect);
              Canvas.TextOut(Rect.Left+2,Rect.Top+2,Cells[ACol,ARow]);
            end;
          if (ACol=2) and (ARow>0) then
            begin
              Canvas.Brush.Color:=clWhite;
              Canvas.Font.Color:=clBlack;
              if Cells[ACol,ARow]<>'' then
                begin
                  if NSRes[ARow] then
                    Canvas.Brush.Color:=clGreen
                  else
                    Canvas.Brush.Color:=clRed;
                end;
              if Cells[ACol,ARow]=' ХЗ' then
                Canvas.Brush.Color:=clYellow;
              Canvas.FillRect(Rect);
              Canvas.TextOut(Rect.Left+2,Rect.Top+2,NSName[ARow]);
            end;
        end;
    end;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
// Выход из программы
  Close;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// Загрузка и сохранение //////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Button5Click(Sender: TObject);
const xlCellTypeLastCell = $0000000B;
var ExlApp, Sheet: OLEVariant;
    i, j, r, c: integer;
    TmpReal: real;
    FileName, TmpStr: string;
begin
// Загрузка файла данных
  if OpenDialog1.Execute then
    begin
      FileName:='';
      TmpStr:=OpenDialog1.FileName;
      j:=Length(TmpStr);
      Repeat
        dec(j);
      Until TmpStr[j]='\';
      for i:=j+1 to Length(TmpStr) do
        FileName:=FileName+TmpStr[i];
      ExlApp:=CreateOleObject('Excel.Application');
      ExlApp.Visible:=false;
      ExlApp.Workbooks.Open(OpenDialog1.Filename);
      Sheet:=ExlApp.Workbooks[ExtractFileName(OpenDialog1.Filename)].WorkSheets[1];
      Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
      r:= ExlApp.ActiveCell.Row;
      c:= ExlApp.ActiveCell.Column;
      StringGrid1.RowCount:=r;
      StringGrid3.RowCount:=r;
      StringGrid4.RowCount:=r;
      LineNum:=r-1;
      ColNum:=c-2;
      Form3.Button1.Enabled:=false;
      Form3.Gauge1.Progress:=0;
      Form3.Gauge1.MaxValue:=r-1;
      Form3.Label2.Caption:=FileName;
      Form3.Button1.Visible:=true;
      Form3.Show;
      for i:=1 to r do
        begin
          StringGrid1.Cells[0,i-1]:=sheet.cells[i,1];
          StringGrid3.Cells[0,i-1]:=sheet.cells[i,1];
          StringGrid4.Cells[0,i-1]:=sheet.cells[i,1];
        end;
      for i:=1 to r-1 do
        FieldID[i]:=StrToInt(sheet.cells[i+1,1]);
      for i:=1 to r do
        begin
          StringGrid1.Cells[1,i-1]:=sheet.cells[i,2];
          StringGrid3.Cells[1,i-1]:=sheet.cells[i,2];
          StringGrid4.Cells[1,i-1]:=sheet.cells[i,2];
        end;
      for i:=1 to r-1 do
        Crop[i]:=sheet.cells[i+1,2];
      for i:=1 to c-2 do
        DataNum[i]:=StrToInt(sheet.cells[1,i+2]);
      for i:=1 to r-1 do
        for j:=1 to c-2 do
          begin
            if StrIsReal(sheet.cells[i+1,j+2],TmpReal) then
              Data[i,j]:=TmpReal;
            Form3.Gauge1.Progress:=i;
          end;
      for i:=1 to r-1 do
        begin
          CSLearning[i]:=false;
          NSLearning[i]:=false;
        end;
      ExlApp.Quit;
      ExlApp := Unassigned;
      Sheet := Unassigned;
      for i:=1 to 3 do
        RecDone[i]:=false;
      Form3.Button1.Enabled:=true;
      Form1.Caption:='Распознавание культур 4.0 - '+FileName;
      Button9.Enabled:=true;
      Button11.Enabled:=true;
      DataLoaded:=true;
      Panel2.Color:=clGreen;
    end;
end;

procedure TForm1.Button13Click(Sender: TObject);
var ExlApp: OLEVariant;
    i, j :integer;
    RowNumber: integer;
    TmpStr: string;
begin
// Сохранение общей обучающей выборки по трем алгоритмам
  try
    ExlApp:=CreateOleObject('Excel.Application');
    ExlApp.Visible:=false;
    ExlApp.WorkBooks.Add;
// Сохранение заголовка и дат
    RowNumber:=1;
    ExlApp.ActiveSheet.Cells(RowNumber,1):=Edit5.Text;
    ExlApp.ActiveSheet.Cells(RowNumber,2):=Edit6.Text;
    for i:=1 to CompNum do
      ExlApp.ActiveSheet.Cells(RowNumber,i+2):=IntToStr(CompDate[i]);
// Сохранение эталонов
    for i:=1 to EtCount do
      begin
        inc(RowNumber);
        ExlApp.ActiveSheet.Cells[RowNumber,1]:=IntToStr(EtalonID[i]);
        ExlApp.ActiveSheet.Cells[RowNumber,2]:=EtCrop[i];
        for j:=1 to CompNum do
          begin
            Str(EtData[i,j]:10:6,TmpStr);
            ExlApp.ActiveSheet.Cells[RowNumber,j+2]:=TmpStr;
          end;
      end;
    inc(RowNumber);
    ExlApp.ActiveSheet.Cells[RowNumber,1]:='New set';
// Сохранение результатов кластеризации по исходным данным
    for i:=1 to CSCount do
      begin
        inc(RowNumber);
        ExlApp.ActiveSheet.Cells[RowNumber,1]:=IntTostr(CSField[i]);
        ExlApp.ActiveSheet.Cells[RowNumber,2]:=CSCrop[i];
        for j:=1 to CompNum do
          begin
            Str(CSData[i,j]:10:6,TmpStr);
            ExlApp.ActiveSheet.Cells[RowNumber,j+2]:=TmpStr;
          end;
      end;
    inc(RowNumber);
    ExlApp.ActiveSheet.Cells[RowNumber,1]:='New set';
// Сохпранение результатов нейросети по исходным данным
    for i:=1 to NSCount do
      begin
        inc(RowNumber);
        Str(NSLimit[i]:10:6,TmpStr);
        ExlApp.ActiveSheet.Cells[RowNumber,1]:=TmpStr;
        ExlApp.ActiveSheet.Cells[RowNumber,2]:=NSCrop[i];
        for j:=1 to CompNum do
          begin
            Str(NSWeight[i,j]:10:6,TmpStr);
            ExlApp.ActiveSheet.Cells[RowNumber,j+2]:=TmpStr;
          end;
      end;
    inc(RowNumber);
// Запись файла с результатами обучения
    if SaveDialog1.Execute then
        begin
          ExlApp.ActiveWorkbook.SaveAs(SaveDialog1.FileName);
          ShowMessage('Результаты обучения сохранены'+#13+SaveDialog1.FileName+'.xlsx');
          Panel1.Color:=clGreen;
        end
    else
      ExlApp.DisplayAlerts:=false;
  finally
    ExlApp.ActiveWorkbook.Close;
    ExlApp.Application.Quit;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
const xlCellTypeLastCell = $0000000B;
var ExlApp, Sheet: OLEVariant;
    i, j, r, c:integer;
    BegLine, EndLine: integer;
    TmpReal: real;
    FileName, TmpStr: string;
begin
// Загрузка общей обучающей выборки по трем алгоритмам
  if OpenDialog1.Execute then
    begin
      FileName:='';
      TmpStr:=OpenDialog1.FileName;
      j:=Length(TmpStr);
      Repeat
        dec(j);
      Until TmpStr[j]='\';
      for i:=j+1 to Length(TmpStr) do
        FileName:=FileName+TmpStr[i];
      ExlApp:=CreateOleObject('Excel.Application');
      ExlApp.Visible:=false;
      ExlApp.Workbooks.Open(OpenDialog1.Filename);
      Sheet:=ExlApp.Workbooks[ExtractFileName(OpenDialog1.Filename)].WorkSheets[1];
      Sheet.Cells.SpecialCells(xlCellTypeLastCell, EmptyParam).Activate;
      r:=ExlApp.ActiveCell.Row;
      c:=ExlApp.ActiveCell.Column;
      Edit5.Text:=sheet.cells[1,1];
      Edit6.Text:=sheet.cells[1,2];
      CompNum:=c-2;
      for i:=1 to CompNum do
        CompDate[i]:=StrToInt(sheet.cells[1,i+2]);
// Загрузка эталонов
      BegLine:=2;
      EndLine:=BegLine;
      Repeat
        inc(EndLine);
        TmpStr:=sheet.cells[EndLine,1]
      Until TmpStr='New set';
      dec(EndLine);
      EtCount:=EndLine-BegLine+1;
      Form3.Button1.Enabled:=false;
      Form3.Gauge1.Progress:=0;
      Form3.Gauge1.MaxValue:=EtCount;
      Form3.Caption:='Загрузка эталонов';
      Form3.Label2.Caption:=FileName;
      Form3.Button1.Visible:=true;
      Form3.Show;
      for i:=1 to EtCount do
        begin
          EtalonID[i]:=StrToInt(sheet.cells[i+BegLine-1,1]);
          EtCrop[i]:=sheet.cells[i+BegLine-1,2];
          for j:=1 to CompNum do
            begin
              if StrIsReal(sheet.cells[i+BegLine-1,j+2],TmpReal) then
                EtData[i,j]:=TmpReal;
              Form3.Gauge1.Progress:=i;
            end;
        end;
      Label32.Caption:=IntToStr(EtCount);
// Загрузка обучающей выборки для кластеризации по исходным данным
      BegLine:=EndLine+2;
      EndLine:=BegLine;
      Repeat
        inc(EndLine);
        TmpStr:=sheet.cells[EndLine,1]
      Until TmpStr='New set';
      dec(EndLine);
      CSCount:=EndLine-BegLine+1;
      Form3.Gauge1.Progress:=0;
      Form3.Gauge1.MaxValue:=CSCount;
      Form3.Caption:='Загрузка выборки';
      for i:=1 to CSCount do
        begin
          CSField[i]:=StrToInt(sheet.cells[i+BegLine-1,1]);
          CSCrop[i]:=sheet.cells[i+BegLine-1,2];
          for j:=1 to CompNum do
            begin
              if StrIsReal(sheet.cells[i+BegLine-1,j+2],TmpReal) then
                CSData[i,j]:=TmpReal;
              Form3.Gauge1.Progress:=i;
            end;
        end;
      Label34.Caption:=IntToStr(CSCount);
// Загрузка результатов обучения нейросети по исходным данным
      BegLine:=EndLine+2;
      EndLine:=r;
      NSCount:=EndLine-BegLine+1;
      Form3.Gauge1.Progress:=0;
      Form3.Gauge1.MaxValue:=NSCount;
      Form3.Caption:='Загрузка выборки';
      for i:=1 to NSCount do
        begin
          if StrIsReal(sheet.cells[i+BegLine-1,1],TmpReal) then
            NSLimit[i]:=TmpReal;
          NSCrop[i]:=sheet.cells[i+BegLine-1,2];
          for j:=1 to c-2 do
            begin
              if StrIsReal(sheet.cells[i+BegLine-1,j+2],TmpReal) then
                NSWeight[i,j]:=TmpReal;
              NSMul[i,j]:=0;
              NSSumMul[j]:=0;
              NSSigmoid[j]:=0;
              NSRezLoc[j]:=0;
              Form3.Gauge1.Progress:=i;
            end;
        end;
      ExlApp.Quit;
      ExlApp := Unassigned;
      Sheet := Unassigned;
      Form3.Button1.Enabled:=true;
      Panel3.Color:=clGreen;
      if DataLoaded and CompDataCalculated then
        begin
          Button6.Enabled:=true;
          Button10.Enabled:=true;
          Button26.Enabled:=true;
        end;
    end;
end;

procedure TForm1.Button16Click(Sender: TObject);
var ExlApp: OLEVariant;
    i, j:integer;
    Max, MaxProb: real;
    TmpStr: string;
    CropCount: array[1..4] of integer;
    CropList: array[1..4] of string;
    DistList: array[1..4] of real;
    ProbList: array[1..4] of real;
begin
// Постобработка и сохранение результатов распознавания
  try
    ExlApp:=CreateOleObject('Excel.Application');
    ExlApp.Visible:=false;
    ExlApp.WorkBooks.Add;
    ExlApp.ActiveSheet.Cells(1,1):='Поле';
    ExlApp.ActiveSheet.Cells(1,2):='Культура';
    ExlApp.ActiveSheet.Cells(1,3):='Вероятность';
    ExlApp.ActiveSheet.Cells(1,4):='';
    ExlApp.ActiveSheet.Cells(1,5):='ET';
    ExlApp.ActiveSheet.Cells(1,6):='Dist';
    ExlApp.ActiveSheet.Cells(1,7):='CS';
    ExlApp.ActiveSheet.Cells(1,8):='Dist';
    ExlApp.ActiveSheet.Cells(1,9):='NS';
    ExlApp.ActiveSheet.Cells(1,10):='Sig';
    for i:=1 to LineNum do
      begin
        DistList[1]:=EtRezult[i];
        ProbList[1]:=(1-DistList[1])*100;
        if DistList[1]>0.6 then
          CropList[1]:=' ХЗ'
        else
          begin
            TmpStr:='';
            for j:=1 to 3 do
              TmpStr:=TmpStr+EtName[i][j];
            CropList[1]:=TmpStr;
          end;
        DistList[2]:=CSRezult[i];
        ProbList[2]:=(1-DistList[2])*100;
        if DistList[2]>0.6 then
          CropList[2]:=' ХЗ'
        else
          begin
            TmpStr:='';
            for j:=1 to 3 do
              TmpStr:=TmpStr+CSName[i][j];
            CropList[2]:=TmpStr;
          end;
        DistList[3]:=NSRezult[i];
        ProbList[3]:=((DistList[3]-0.9)*1000)/56*100;
        if DistList[3]<0.9 then
          CropList[3]:=' ХЗ'
        else
          begin
            TmpStr:='';
            for j:=1 to 3 do
              TmpStr:=TmpStr+NSName[i][j];
            CropList[3]:=TmpStr;
          end;
        TmpStr:=CropList[1];
        CropCount[1]:=0;
        for j:=1 to 3 do
          if TmpStr=CropList[j] then
            inc(CropCount[1]);
        TmpStr:=CropList[2];
        CropCount[2]:=0;
        for j:=1 to 3 do
          if TmpStr=CropList[j] then
            inc(CropCount[2]);
        TmpStr:=CropList[3];
        CropCount[3]:=0;
        for j:=1 to 3 do
          if TmpStr=CropList[j] then
            inc(CropCount[3]);
        Max:=0;
        for j:=1 to 3 do
          if CropCount[j]>Max then
            Max:=CropCount[j];
        if Max=1 then
          begin
            CropList[4]:=' ХЗ';
            MaxProb:=0;
            for j:=1 to 3 do
              if ProbList[j]>MaxProb then
                MaxProb:=ProbList[j];
            DistList[4]:=MaxProb;
          end;
        if Max=2 then
          begin
            MaxProb:=0;
            for j:=1 to 3 do
              if CropCount[j]=2 then
                begin
                  CropList[4]:=CropList[j];
                  MaxProb:=MaxProb+ProbList[j];
                end;
            DistList[4]:=MaxProb/2;
          end;
        if Max=3 then
          begin
            CropList[4]:=CropList[1];
            DistList[4]:=(ProbList[1]+ProbList[2]+ProbList[3])/3;
          end;
        if DistList[4]<25 then CropList[4]:=' ХЗ';
        ExlApp.ActiveSheet.Cells(i+1,1):=IntToStr(FieldID[i]);
        ExlApp.ActiveSheet.Cells(i+1,2):=CropList[4];
        Str(DistList[4]:5:3,TmpStr);
        ExlApp.ActiveSheet.Cells(i+1,3):=TmpStr;
        ExlApp.ActiveSheet.Cells(i+1,4):='';
        ExlApp.ActiveSheet.Cells(i+1,5):=CropList[1];
        Str(DistList[1]:5:3,TmpStr);
        ExlApp.ActiveSheet.Cells(i+1,6):=TmpStr;
        ExlApp.ActiveSheet.Cells(i+1,7):=CropList[2];
        Str(DistList[2]:5:3,TmpStr);
        ExlApp.ActiveSheet.Cells(i+1,8):=TmpStr;
        ExlApp.ActiveSheet.Cells(i+1,9):=CropList[3];
        Str(DistList[3]:5:3,TmpStr);
        ExlApp.ActiveSheet.Cells(i+1,10):=TmpStr;
      end;
    if SaveDialog1.Execute then
        begin
          ExlApp.ActiveWorkbook.SaveAs(SaveDialog1.FileName);
          ShowMessage('Результаты распознавания сохранены'+#13+SaveDialog1.FileName+'.xlsx');
          Panel5.Color:=clGreen;
        end
    else
      ExlApp.DisplayAlerts:=false;
  finally
    ExlApp.ActiveWorkbook.Close;
    ExlApp.Application.Quit;
  end;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// Предобработка //////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.MakeCompData;
var i, j, k: integer;
    BegDate, EndDate, DateCount: integer;
    DateArray: array[1..400] of integer;
begin
// Создание массива данных с 8-дневными интервалами
  EndDate:=StrToInt(Edit6.Text);
  i:=1;
  DateArray[1]:=1;
  Repeat
    inc(i);
    DateArray[i]:=DateArray[i-1]+7;
  Until DateArray[i]>=EndDate;
  if DateArray[i]>EndDate then
    DateCount:=i
  else
    DateCount:=i-1;
  EndDate:=StrToInt(Edit5.Text);
  i:=0;
  Repeat
    inc(i);
  Until DateArray[i]>=EndDate;
  BegDate:=i;
  CompNum:=DateCount-BegDate+1;
  j:=0;
  for i:=BegDate to DateCount do
    begin
      inc(j);
      CompDate[j]:=DateArray[i];
      for k:=1 to LineNum do
        CompData[k,j]:=Data[k,DateArray[i]];
    end;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  MakeCompData;
  Button8.Enabled:=true;
  Button12.Enabled:=true;
  Button37.Enabled:=true;
  CompDataCalculated:=true;
  Panel4.Color:=clGreen;
  if DataLoaded and CompDataCalculated then
    begin
      Button6.Enabled:=true;
      Button10.Enabled:=true;
      Button26.Enabled:=true;
    end;
end;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// Графики /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Button9Click(Sender: TObject);
begin
// Построение графика
  BegDt:=StrToInt(Edit5.Text);
  EndDt:=StrToInt(Edit6.Text);
  Form5.GraphRezult:=false;
  Form5.DrawBlancGraph;
  Form5.DrawGraph;
  if not Form5.Visible then
    Form5.ShowModal;
  if Form5.GraphRezult then
    begin
      Edit5.Text:=IntToStr(BegDt);
      Edit6.Text:=IntToStr(EndDt);
    end;
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// Кластеризация по исходным данным //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.AddFieldClusterSRC(Num: integer);
var i: integer;
begin
// Добавление поля в обучающую выборку для кластеризации по исходным данным
  if CSLearning[Num] then
    begin
      ShowMessage('Это поле уже добавлено');
      Exit;
    end;
  if Num=0 then
    begin
      ShowMessage('Не выбрано поле для добавления в выборку');
      Exit;
    end;
  CSLearning[Num]:=true;
  inc(CSCount);
  CSField[CSCount]:=FieldID[Num];
  CSCrop[CSCount]:=Crop[Num];
  for i:=1 to CompNum do
    CSData[CSCount,i]:=CompData[Num,i];
  Label34.Caption:=IntToStr(CSCount);
  StringGrid3.Invalidate;
end;

procedure TForm1.RemoveFieldClusterSRC(Num: integer);
var i, j: integer;
    Pos: integer;
begin
// Удаление поля из обучающей выборки для кластеризации по исходным данным
  if Num=0 then
    begin
      ShowMessage('Не выбрано поле для удаления из выборки');
      Exit;
    end;
  if not CSLearning[Num] then
    begin
      ShowMessage('Это поле не было добавлено в выборку');
      Exit;
    end;
  CSLearning[Num]:=false;
  for i:=1 to CSCount do
    if FieldID[Num]=CSField[i] then
      Pos:=i;
  dec(CSCount);
  for i:=Pos to CSCount do
    begin
      CSField[i]:=CSField[i+1];
      CSCrop[i]:=CSCrop[i+1];
      for j:=1 to ColNum do
        CSData[i,j]:=CSData[i+1,j];
    end;
  Label34.Caption:=IntToStr(CSCount);
  StringGrid3.Invalidate;
end;

procedure TForm1.RecLearnClasterSRC(Num: integer);
var i, j: integer;
    Min, Sum: real;
    TmpStr, TmpStr1, TmpStr2, TmpStr3, TmpStr4: string;
begin
// Распознавание кластеризацией по исходным данным
  for i:=1 to CSCount do
    begin
      Sum:=0;
      for j:=1 to CompNum do
        Sum:=Sum+(CompData[Num,j]-CSData[i,j])*(CompData[Num,j]-CSData[i,j]);
          CSLearnDist[i]:=sqrt(Sum);
    end;
  Min:=100000;
  for i:=1 to CSCount do
    if CSLearnDist[i]<Min then
      begin
        Min:=CSLearnDist[i];
        CSRezult[Num]:=Min;
        CSName[Num]:=CSCrop[i];
      end;
    StringGrid3.Cells[2,Num]:=CSName[Num];
    Str(CSRezult[Num]:5:2,TmpStr);
    StringGrid3.Cells[3,Num]:=TmpStr;
    if Crop[Num]='' then
      begin
        if CSRezult[Num]>1 then
          CSRes[Num]:=false
        else
          CSRes[Num]:=true;
      end;
    if Crop[Num]<>'' then
      begin
        TmpStr1:=Crop[Num];
        TmpStr2:=CSName[Num];
        TmpStr3:='';
        TmpStr4:='';
        for i:=1 to 3 do
          begin
            TmpStr3:=TmpStr3+TmpStr1[i];
            TmpStr4:=TmpStr4+TmpStr2[i];
          end;
        if TmpStr3=TmpStr4 then
          CSRes[Num]:=true
        else
          CSRes[Num]:=false;
      end;
end;

procedure TForm1.Button12Click(Sender: TObject);
var i: integer;
    NextPos, ItLocal: integer;
    MinRez: real;
    TmpStr: string;
begin
// Автоматическое обучение кластеризацией по исходным данным - первая стратегия
  Iterations:=StrToInt(Edit1.Text);
  Precision:=StrToInt(Edit2.Text);
  Gauge1.MaxValue:=Iterations;
  Gauge2.MaxValue:=Precision;
  ItLocal:=0;
  Repeat
    MinRez:=10000;
    for i:=1 to LineNum do
      if (CSRezult[i]<MinRez) and (not CSRes[i]) then
        begin
          MinRez:=CSRezult[i];
          NextPos:=i;
        end;
    if NextPos<=LineNum then
      AddFieldClusterSRC(NextPos)
    else
      begin
        ShowMessage('Все объекты распознаны');
        Exit;
      end;
    for i:=1 to LineNum do
      RecLearnClasterSRC(i);
    NextPos:=0;
    for i:=1 to LineNum do
     if CSRes[i] then
        inc(NextPos);
    MinRez:=NextPos*100/LineNum;
    Str(MinRez:5:2,TmpStr);
    Label16.Caption:=TmpStr;
    inc(ItLocal);
    Gauge1.Progress:=ItLocal;
    Gauge2.Progress:=Round(MinRez);
  Until (ItLocal>=Iterations) or (MinRez>=Precision);
  if MinRez>=StrToInt(Edit2.Text) then
    CheckAllDone(2);
end;

procedure TForm1.Button10Click(Sender: TObject);
var i: integer;
    Count: integer;
    Percent: real;
    TmpStr: string;
begin
// Распознавание кластеризацией по исходным данным
  Gauge1.MaxValue:=LineNum;
  Gauge2.MaxValue:=100;
  for i:=1 to LineNum do
    begin
      RecLearnClasterSRC(i);
      Gauge1.Progress:=i;
    end;
  Count:=0;
  for i:=1 to LineNum do
    if CSRes[i] then
      inc(Count);
  Percent:=Count*100/LineNum;
  Str(Percent:5:2,TmpStr);
  Label16.Caption:=TmpStr;
  Gauge2.Progress:=Round(Percent);
  CheckAllDone(2);
end;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////// Нейросеть по исходным данным //////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.AddFieldNeuronSRC(Num: integer);
begin
// Добавление объекта в обучение нейросети по исходным данным
  inc(NSCount);
  NSLearning[Num]:=true;
  NSCrop[NSCount]:=Crop[Num];
  Label36.Caption:=IntToStr(NSCount);
  StringGrid4.Invalidate;
end;

procedure TForm1.RemoveFieldNeuronSRC(Num: integer);
var i, j: integer;
begin
// Удаление объекта из обучения нейросети по исходным данным
  if Num=0 then
    begin
      ShowMessage('Не выбран объект для удаления из выборки');
      Exit;
    end;
  if not NSLearning[Num] then
    begin
      ShowMessage('Данный объект не был добавлен в выборку');
      Exit;
    end;
  dec(NSCount);
  for i:=Num to NSCount do
    begin
      NSCrop[i]:=NSCrop[i+1];
      NSSumMul[i]:=NSSumMul[i+1];
      NSSigmoid[i]:=NSSigmoid[i+1];
      NSLimit[i]:=NSLimit[i+1];
      NSRezLoc[i]:=NSRezLoc[i+1];
      for j:=1 to CompNum do
        begin
          NSMul[i,j]:=NSMul[i+1,j];
          NSWeight[i,j]:=NSWeight[i+1,j];
        end;
    end;
  Label36.Caption:=IntToStr(NSCount);
  StringGrid4.Invalidate;
end;

procedure TForm1.RecLearnNeuronSRC(Num: integer);
var i, j: integer;
    Max: real;
    TmpStr, TmpStr1, TmpStr2, TmpStr3, TmpStr4: string;
begin
// Распознавание нейросетью по исходным данным
  for i:=1 to NSCount do
    begin
      for j:=1 to CompNum do
        NSMul[i,j]:=CompData[Num,j]*NSWeight[i,j];
        NSSumMul[i]:=0;
        for j:=1 to CompNum do
          NSSumMul[i]:=NSSumMul[i]+NSMul[i,j];
        NSSumMul[i]:=NSSumMul[i]/CompNum;
        NSSigmoid[i]:=1/(1+EXP(NSSumMul[i]*(-1)));
        if NSSigmoid[i]>=NSLimit[i] then
          NSRezLoc[i]:=1
        else
          NSRezLoc[i]:=0;
    end;
  Max:=-1;
  for i:=1 to NSCount do
    if NSSigmoid[i]>Max then
      begin
        Max:=NSSigmoid[i];
        NSRezult[Num]:=Max;
        if NSRezLoc[i]>NSLimit[i] then
          NSName[Num]:=NSCrop[i]
        else
          NSName[Num]:=' ХЗ';
      end;
  StringGrid4.Cells[2,Num]:=NSName[Num];
  Str(NSRezult[Num]:6:4,TmpStr);
  StringGrid4.Cells[3,Num]:=TmpStr;
  if Crop[Num]='' then
    begin
      if NSRezult[Num]<0.9 then
        NSRes[Num]:=false
      else
        NSRes[Num]:=true;
    end;
  if Crop[Num]<>'' then
    begin
      TmpStr1:=Crop[Num];
      TmpStr2:=NSName[Num];
      TmpStr3:='';
      TmpStr4:='';
      for i:=1 to 3 do
        begin
          TmpStr3:=TmpStr3+TmpStr1[i];
          TmpStr4:=TmpStr4+TmpStr2[i];
        end;
      if TmpStr3=TmpStr4 then
        NSRes[Num]:=true
      else
        NSRes[Num]:=false;
    end;
end;

procedure TForm1.Button37Click(Sender: TObject);
var i: integer;
    LocalIt, ObjNum, NeuNum: integer;
    Percent: real;
    TmpStr: string;
begin
// Автоматическое обучение нейросетью по исходным данным - первая стратегия
  if NSCount=0 then
    AddFieldNeuronSRC(1);
  Iterations:=StrToInt(Edit3.Text);
  Precision:=StrToInt(Edit4.Text);
  LocalIt:=0;
  Gauge3.MaxValue:=Iterations;
  Gauge4.MaxValue:=Precision;
  Gauge3.Progress:=0;
  Gauge4.Progress:=0;
  Repeat
    inc(LocalIt);
    ObjNum:=0;
    for i:=LineNum downto 1 do
      if not NSRes[i] then
        ObjNum:=i;
    if ObjNum=0 then
      begin
        ShowMessage('Все объекты распознаны верно');
        Exit;
      end;
    if (NSName[ObjNum]=' ХЗ') or (NSName[ObjNum]='') then
      begin
        NeuNum:=0;
        for i:=1 to NSCount do
          if NSCrop[i]=Crop[ObjNum] then
            NeuNum:=i;
        if NeuNum=0 then
          AddFieldNeuronSRC(ObjNum);
        for i:=1 to CompNum do
          NSWeight[NeuNum,i]:=NSWeight[NeuNum,i]+CompData[ObjNum,i];
      end
    else
      begin
        NeuNum:=0;
        for i:=1 to NSCount do
          if NSCrop[i]=Crop[ObjNum] then
            NeuNum:=i;
        if NeuNum=0 then
          AddFieldNeuronSRC(ObjNum);
        for i:=1 to CompNum do
          NSWeight[NeuNum,i]:=NSWeight[NeuNum,i]+CompData[ObjNum,i];
        NeuNum:=0;
        for i:=1 to NSCount do
          if NSCrop[i]=NSName[ObjNum] then
            NeuNum:=i;
        if NeuNum=0 then
          AddFieldNeuronSRC(ObjNum);
        for i:=1 to CompNum do
          NSWeight[NeuNum,i]:=NSWeight[NeuNum,i]-CompData[ObjNum,i];
      end;
    for i:=1 to LineNum do
      RecLearnNeuronSRC(i);
    ObjNum:=0;
    for i:=1 to LineNum do
      if NSRes[i] then
        inc(ObjNum);
    Percent:=ObjNum*100/LineNum;
    Str(Percent:5:2,TmpStr);
    Gauge3.Progress:=LocalIt;
    Gauge4.Progress:=Round(Percent);
    Label20.Caption:=TmpStr;
    StringGrid4.Invalidate;
  Until (LocalIt>=Iterations) or (Percent>=Precision);
  if Percent>=StrToInt(Edit4.Text) then
    CheckAllDone(3);
end;

procedure TForm1.Button26Click(Sender: TObject);
var i: integer;
    Count: integer;
    Percent: real;
    TmpStr: string;
begin
// Распознавание нейросетью по исходным данным
  Gauge3.MaxValue:=LineNum;
  Gauge4.MaxValue:=100;
  for i:=1 to LineNum do
    begin
      RecLearnNeuronSRC(i);
      Gauge3.Progress:=i;
    end;
  Count:=0;
  for i:=1 to LineNum do
    if NSRes[i] then
      inc(Count);
  Percent:=Count*100/LineNum;
  Str(Percent:5:2,TmpStr);
  Label20.Caption:=TmpStr;
  Gauge4.Progress:=Round(Percent);
  CheckAllDone(3);
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////// Создание эталонов и кластеризация //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

procedure TForm1.Button8Click(Sender: TObject);
var i, j: integer;
    BegPoint, EndPoint, Count: integer;
    Sum, Percent: real;
    TmpStr: string;
begin
// Создание эталонов
  EtCount:=0;
  BegPoint:=0;
  Repeat
    inc(BegPoint);
    EndPoint:=BegPoint;
    Repeat
      inc(EndPoint);
    Until (Crop[BegPoint]<>Crop[EndPoint]) or (EndPoint>LineNum);
    dec(EndPoint);
    inc(EtCount);
    for i:=1 to CompNum do
      begin
        Sum:=0;
        for j:=BegPoint to EndPoint do
          Sum:=Sum+CompData[j,i];
        EtData[EtCount,i]:=Sum/(EndPoint-BegPoint+1);
      end;
    EtCrop[EtCount]:=Crop[BegPoint];
    EtalonID[EtCount]:=EtCount;
    BegPoint:=EndPoint;
  Until EndPoint=LineNum;
  Label32.Caption:=IntToStr(EtCount);
  Gauge9.MaxValue:=LineNum;
  Gauge10.MaxValue:=100;
  Gauge9.Progress:=0;
  Gauge10.Progress:=0;
  for i:=1 to LineNum do
    begin
      RecLearnEtalon(i);
      Gauge9.Progress:=i;
    end;
  Count:=0;
  for i:=1 to LineNum do
    if EtRes[i] then
      inc(Count);
  Percent:=Count*100/LineNum;
  Gauge10.Progress:=Round(Percent);
  Str(Percent:5:2,TmpStr);
  Label2.Caption:=TmpStr;
  CheckAllDone(1);
end;

procedure TForm1.RecLearnEtalon(Num: integer);
var i, j: integer;
    Min, Sum: real;
    TmpStr, TmpStr1, TmpStr2, TmpStr3, TmpStr4: string;
begin
// Распознавание кластеризацией по эталонам
  for i:=1 to EtCount do
    begin
      Sum:=0;
      for j:=1 to CompNum do
        Sum:=Sum+(CompData[Num,j]-EtData[i,j])*(CompData[Num,j]-EtData[i,j]);
          EtLearnDist[i]:=sqrt(Sum);
    end;
  Min:=100000;
  for i:=1 to EtCount do
    if EtLearnDist[i]<Min then
      begin
        Min:=EtLearnDist[i];
        EtRezult[Num]:=Min;
        EtName[Num]:=EtCrop[i];
      end;
    StringGrid1.Cells[2,Num]:=EtName[Num];
    Str(EtRezult[Num]:5:2,TmpStr);
    StringGrid1.Cells[3,Num]:=TmpStr;
    if Crop[Num]='' then
      begin
        if EtRezult[Num]>1 then
          EtRes[Num]:=false
        else
          EtRes[Num]:=true;
      end;
    if Crop[Num]<>'' then
      begin
        TmpStr1:=Crop[Num];
        TmpStr2:=EtName[Num];
        TmpStr3:='';
        TmpStr4:='';
        for i:=1 to 3 do
          begin
            TmpStr3:=TmpStr3+TmpStr1[i];
            TmpStr4:=TmpStr4+TmpStr2[i];
          end;
        if TmpStr3=TmpStr4 then
          EtRes[Num]:=true
        else
          EtRes[Num]:=false;
      end;
end;

procedure TForm1.Button6Click(Sender: TObject);
var i: integer;
    Count: integer;
    Percent: real;
    TmpStr: string;
begin
// Распознавание кластеризацией по эталонам
  Gauge9.MaxValue:=LineNum;
  Gauge10.MaxValue:=100;
  Gauge9.Progress:=0;
  Gauge10.Progress:=0;
  for i:=1 to LineNum do
    begin
      RecLearnEtalon(i);
      Gauge9.Progress:=i;
    end;
  Count:=0;
  for i:=1 to LineNum do
    if EtRes[i] then
      inc(Count);
  Percent:=Count*100/LineNum;
  Gauge10.Progress:=Round(Percent);
  Str(Percent:5:2,TmpStr);
  Label2.Caption:=TmpStr;
  CheckAllDone(1);
end;

end.
