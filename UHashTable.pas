unit UHashTable;

interface

uses UInfo, Grids, UAddForm, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, StdCtrls, ExtCtrls, ComCtrls;

type

TCellState = (csFree, csFull, csDel);

TAddRes = (adOk, adFound, adNotFree);

TIndex = -1..N-1;
TNext = ^TCell;
TCell = record
  info: TInfo;
  state: TCellState;
  next: TNext;
end;

TTable = array[TIndex] of TCell;

THashTable = class
private
  FTable: TTable;
  FCount: integer;
protected
  //
  function NextCell(a0: TIndex; var i: integer): TIndex;

  // Вспомогательный метод добавления
  function AddHelp(info: TInfo): TAddRes;
  // Вспомогательный метод очистки
  procedure ClearHelp;
  // Вспомогательный метод удаления
  function DeleteHelp(aKey: TKey): boolean;
  // Вывод
  function ShowInfo(info: TInfo; SL: TStrings): boolean;
public
  //Создание Хеш-таблицы
  constructor Create();

  function getCell(Index: integer): TCell;

  function Add(info: TInfo): TAddRes; virtual;

  //
  function IndexOf(key: TKey; var a, prev: TIndex): boolean;
  {Сохранение Хеш-таблицы в файл}
  procedure SaveToFile(Filename: string);
  {Загрузка Хеш-таблицы из файла}
  procedure LoadFromFile(Filename: string);
  {Удаление ключа из Хеш-таблицы}
  function Delete(aKey:TKey): boolean; virtual;
  {Нахождение ключа в Хеш-таблице}
  function Find(aKey:TKey): boolean;
  {Очищение Хеш-таблицы}
  procedure Clear; virtual;

  property Table[Index: integer]: TCell read getCell;
  property Count: integer read FCount;
end;

implementation

constructor THashTable.Create();
var
  i: integer;
begin
  for i:= 0 to N-1 do
  begin
    FTable[i].info:= TInfo.CreateEmpty;
    FTable[i].state:= csFree;
    FTable[i].next:= nil;
  end;
end;

function THashTable.NextCell(a0: TIndex; var i: integer): TIndex;
begin
  inc(i);
  if(a0 = N) then
    a0:= 0
  else
    result:= a0 + 1;
end;

// Отвечает за получение в переменную a индекса, по которому допустимо вставить
// эл-т (или нет), преодолев коллизию
function THashTable.IndexOf(key: TKey; var a: TIndex; var prev: TIndex): boolean;
var
  a0: TIndex;
  i, d: integer;
  Ok, stop: boolean;
begin
  a0:= TInfo.BadHashFunction(key);
  i:= 0;
  a:= a0;
  Ok:= false;
  stop:= false;
  d:= -1;
  repeat
    case FTable[a].state of
      csFree:
      begin
       stop:= true;
      end;
      csFull:
      begin
        if FTable[a].info.Number = key then
          Ok:= true                 // такой же элемент пришел
        else
          begin
            prev:= a;               // Сохраняем индекс послед. эл-та с таким же кодом
            a:= NextCell(a, i);    // произошла коллизия
          end;
      end;
      csDel:
      begin
        d:= a;
        a:= NextCell(a, i);
      end;
    end;
  until Ok or stop or (i = N * 2);
  result:= Ok;
  if not Ok and (d >= 0) then
    a:= d;
end;

function THashTable.AddHelp(info: TInfo): TAddRes;
var
  a, prev: TIndex;
  Ok: boolean;
begin
  prev:= -1;
  if FCount = N then
    Result:= adNotFree
  else
    begin
      Ok:= IndexOf(info.Number, a, prev);
      if ok then
        result:= adFound            // Пришел такой же дублирующий аргумент
      else
        if FTable[a].state = csFull then
          result:= adNotFree
        else
          begin
            FTable[a].info:= info;
            FTable[a].state:= csFull;
            inc(FCount);
            if (prev <> -1) then
              FTable[prev].next:= @FTable[a];
            result:= adOk;
          end;
    end;
end;

function THashTable.Add(info: TInfo): TAddRes;
begin
  Result:= AddHelp(info);
end;

{Сохранение Хеш-таблицы в файл}
procedure THashTable.SaveToFile(Filename:string);
var
  f:TextFile;
  i:Integer;
begin
  AssignFile(f, Filename);
  Rewrite(f);
  for i:=0 to N - 1 do
    if (FTable[i].state = csFull) then
      FTable[i].info.SaveToFile(f);
  CloseFile(f);
end;

{Загрузка Хеш-таблицы из файла}
procedure THashTable.LoadFromFile(Filename:string);
var
  f:TextFile;
  i:Integer;
  newInfo: Tinfo;
begin
  Clear;
  AssignFile(f, Filename);
  Reset(f);
  newInfo:= TInfo.CreateEmpty;
  while newInfo.LoadFromFile(f) do
    begin
      AddHelp(newInfo);
      newInfo:= TInfo.CreateEmpty;
    end;
  CloseFile(f);
end;

function THashTable.DeleteHelp(aKey: TKey): boolean;
var
  a, prev: TIndex;
begin
  prev:= -1;
  if IndexOf(aKey, a, prev) then
    begin
      Dec(FCount);
      FTable[a].State:= csDel;
      FreeAndNil(FTable[a].Info);
      if (prev <> -1) then
        FTable[prev].next:= FTable[a].next;
      FTable[a].next:= nil;
      result:= true;
    end
  else
    result:= false;
end;

{Удаление ключа из Хеш-таблицы}
function THashTable.Delete(aKey:TKey):Boolean;
begin
  DeleteHelp(aKey);
end;

{Нахождение ключа в Хеш-таблице}
function THashTable.Find(aKey:TKey):Boolean;
var
  index1, index2: TIndex;
begin
  result:= IndexOf(aKey, index1, index2);
end;

procedure THashTable.ClearHelp;
var
  i:Integer;
begin
  for i:=0 to N - 1 do
    begin
      FTable[i].State:= csFree;
      FreeAndNil(FTable[i].Info);
      FTable[i].next:= nil;
    end;
  FCount:=0;
end;

{Очищение Хеш-таблицы}
procedure THashTable.Clear;
begin
  ClearHelp;
end;

function THashTable.getCell(Index: integer): TCell;
begin
  result:= FTable[Index];
end;

//
function THashTable.ShowInfo(info: TInfo; SL: TStrings): boolean;
var
  state: TCellState;
  a, prev: TIndex;
begin
  info.ShowInfo(SL);
  result:= IndexOf(info.Number, a, prev);
  state:= FTable[a].state;
  if result then
    if (state = csFree) then
      SL[2]:= 'Пусто'
    else if (state = csFull) then
      SL[2]:= 'Заполнено'
    else if (state = csDel) then
      SL[2]:= 'Удалено';

end;

end.
