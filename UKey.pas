unit UKey;

interface


{type

TKey = class
private
  FKey: integer;
public
  {Создание объекта информации}
//  constructor Create(aKey: integer = 0);
  {Сравнение значений ключей}
//  function IsEqual(aKey:TKey):Boolean;
//  {Различные хеш-функции}
//  function BadHashFunction():Integer;
//
//  function GoodHashFunction():Integer;
{
  property Value:integer
    read FKey
    write FKey;
end;

implementation

{Создание объекта информации}
{
constructor TKey.Create(aKey: integer = 0);
begin
  FKey:=aKey;
end;

{Сравнение значений ключей}
{
function TKey.IsEqual(aKey:TKey):Boolean;
begin
  Result:= FKey = aKey.FKey;
end;

function TKey.BadHashFunction():Integer;
begin
  result:= FKey mod N mod 3;
end;

function TKey.GoodHashFunction():Integer;
begin
  result:= FKey mod N;
end;
}
//end.











