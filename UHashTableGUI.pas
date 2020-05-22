unit UHashTableGUI;

interface

uses UInfo, Grids, UAddForm, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, StdCtrls, ExtCtrls, ComCtrls, UHashTable;

type

THashTableGUI = class(THashTable)
private
  TableView:TStringGrid;
  FModified: boolean;
  FFileName: string;

public
  {Создание визуального представления таблицы}
  constructor Create(var Grid: TStringGrid);
  {Добавление элемента в таблицу}
  function Add(info: TInfo): TAddRes; override;
  {Удалениие элемента из таблицы}
  function Delete(aKey: TKey): boolean; override;
  {Загрузка Хеш-таблицы из файла}
  procedure LoadFromFile(aFilename: string);
  {Сохранить в файл}
  procedure SaveToFile(aFileName: string);
  {Обновление визуального представления таблицы}
  procedure Print;
  {Очистка Хеш-таблицы}
  procedure Clear; override;

  property Table[Index: integer]: TCell read getCell;
  property FileName: string read FFileName write FFileName;
  property Modified: boolean read FModified write FModified;
  
end;

implementation

{Создание визуального представления таблицы}
constructor THashTableGUI.Create(var Grid: TStringGrid);
begin
  inherited Create;
  TableView:= Grid;
  TInfo.ShowTitle(Grid);
  FModified:= false;
end;

{Добавление элемента в таблицу}
function THashTableGUI.Add(info: TInfo): TAddRes;
begin
  result:= inherited AddHelp(info);
  Print;
end;

{Удаление элемента из таблицы}
function THashTableGUI.Delete(aKey: TKey): boolean;
begin
  result:= inherited DeleteHelp(aKey);
  if result then
  begin
    FModified:= true;
    Print;
  end;
end;

{Загрузка Хеш-таблицы из файла}
procedure THashTableGUI.LoadFromFile(aFilename: string);
begin
  inherited LoadFromFile(aFileName);
  Print;
  FModified:= false;
end;

{Сохранение элемента в файл}
procedure THashTableGUI.SaveToFile(aFileName: string);
begin
  inherited SaveToFile(aFileName);
  FFileName:= aFileName;
  FModified:= false;
end;

{Обновление визуального представления таблицы}
procedure THashTableGUI.Print;
var
  i:Integer;
begin
  TableView.RowCount:= 1;
  for i:=0 to N - 1 do
    if(Table[i].state = csFull) then
      begin
        with TableView do
          begin
            RowCount:= RowCount + 1;
            Cells[0,RowCount-1]:= Table[i].info.Number;
            Cells[1,RowCount-1]:= Table[i].info.Mark;
            Cells[2,RowCount-1]:= Table[i].info.FIO;
          end;
      end;
end;

{Очистка Хеш-таблицы}
procedure THashTableGUI.Clear;
begin
  inherited ClearHelp;
  Print;
  FModified:= true;
end;

end.
