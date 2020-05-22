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

  // ��������������� ����� ����������
  function AddHelp(info: TInfo): TAddRes;
  // ��������������� ����� �������
  procedure ClearHelp;
  // ��������������� ����� ��������
  function DeleteHelp(aKey: TKey): boolean;
  // �����
  function ShowInfo(info: TInfo; SL: TStrings): boolean;
public
  //�������� ���-�������
  constructor Create();

  function getCell(Index: integer): TCell;

  function Add(info: TInfo): TAddRes; virtual;

  //
  function IndexOf(key: TKey; var a, prev: TIndex): boolean;
  {���������� ���-������� � ����}
  procedure SaveToFile(Filename: string);
  {�������� ���-������� �� �����}
  procedure LoadFromFile(Filename: string);
  {�������� ����� �� ���-�������}
  function Delete(aKey:TKey): boolean; virtual;
  {���������� ����� � ���-�������}
  function Find(aKey:TKey): boolean;
  {�������� ���-�������}
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

// �������� �� ��������� � ���������� a �������, �� �������� ��������� ��������
// ��-� (��� ���), ��������� ��������
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
          Ok:= true                 // ����� �� ������� ������
        else
          begin
            prev:= a;               // ��������� ������ ������. ��-�� � ����� �� �����
            a:= NextCell(a, i);    // ��������� ��������
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
        result:= adFound            // ������ ����� �� ����������� ��������
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

{���������� ���-������� � ����}
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

{�������� ���-������� �� �����}
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

{�������� ����� �� ���-�������}
function THashTable.Delete(aKey:TKey):Boolean;
begin
  DeleteHelp(aKey);
end;

{���������� ����� � ���-�������}
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

{�������� ���-�������}
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
      SL[2]:= '�����'
    else if (state = csFull) then
      SL[2]:= '���������'
    else if (state = csDel) then
      SL[2]:= '�������';

end;

end.
