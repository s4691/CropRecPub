unit Unit2;

interface

uses
  SysUtils, Classes;

type
  TDataModule2 = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;
// Исходные данные /////////////////////////////////////////////////////////////
  DataLoaded: boolean;
  LearnLoaded: boolean;
  CompDataCalculated: boolean;
  BegDt, EndDt: integer;
  LineNum, ColNum: integer;
  Col1, Row1: integer;
  FieldID: array[1..5000] of integer;
  Crop: array[1..5000] of string;
  DataNum: array[1..400] of integer;
  Data: array[1..5000,1..400] of real;
  GraphColor: array[1..5000,1..3] of byte;

// Массивы данных с 8-дневными интервалами /////////////////////////////////////
  CompNum: integer;
  CompDate: array[1..50] of integer;
  CompData: array[1..5000,1..50] of real;

// Создание эталонов и кластеризация ///////////////////////////////////////////
  EtCount: integer;
  EtLearnDist: array[1..100] of real;
  EtalonID: array[1..100] of integer;
  EtCrop: array[1..100] of string;
  EtData: array[1..100,1..50] of real;

// Обучение и распознавание кластеризацией по исходным данным //////////////////
  CSCount: integer;
  CSLearning: array[1..5000] of boolean;
  CSLearnDist: array[1..5000] of real;
  CSField: array[1..5000] of integer;
  CSCrop: array[1..5000] of string;
  CSData: array[1..5000,1..500] of real;

// Обучение и распознавание нейросетью по исходным данным //////////////////////
  NSCount: integer;
  NSLearning: array[1..5000] of boolean;
  NSCrop: array[1..100] of string;
  NSMul, NSWeight: array[1..100,1..400] of real;
  NSSumMul, NSSigmoid, NSLimit: array[1..100] of real;
  NSRezLoc: array[1..100] of byte;

// Результаты распознавания ////////////////////////////////////////////////////
  EtRezult, CSRezult, NSRezult: array [1..5000] of real;
  EtName, CSName, NSName: array [1..5000] of string;
  EtRes, CSRes, NSRes: array [1..5000] of boolean;

implementation

{$R *.dfm}

end.
