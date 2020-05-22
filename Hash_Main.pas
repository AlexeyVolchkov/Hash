{
 Задан набор записей следующей структуры: номер автомобиля, его марка,
 ФИО владельца. По номеру автомобиля найти остальные сведения
}
unit Hash_Main;

interface

uses
  UHashTableGUI, UAddForm, UInfo, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, Grids, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  ToolWin, UHashTable;

type
  TFrmMain = class(TForm)
    StrGrid: TStringGrid;
    MainMenu: TMainMenu;
    file1: TMenuItem;
    NewMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    SaveAsMenuItem: TMenuItem;
    CloseMenuItem: TMenuItem;
    ExMenuItem: TMenuItem;
    add1: TMenuItem;
    FindMenuItem: TMenuItem;
    DelMenuItem: TMenuItem;
    ClearMenuItem: TMenuItem;
    process1: TMenuItem;
    TaskMenuItem: TMenuItem;
    AddMenuItem: TMenuItem;
    ActionList: TActionList;
    ActAdd: TAction;
    ActDelete: TAction;
    ActClear: TAction;
    ActFind: TAction;
    ActNew: TAction;
    ActSave: TAction;
    ActSaveAs: TAction;
    ActClose: TAction;
    ActOpen: TAction;
    ActTask: TAction;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ToolBar: TToolBar;
    NewToolBtn: TToolButton;
    ImageList: TImageList;
    ToolButton2: TToolButton;
    OpenToolBtn: TToolButton;
    SaveToolBtn: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ClearToolBtn: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    DelToolBtn: TToolButton;
    ToolButton12: TToolButton;
    AddToolBtn: TToolButton;
    TaskToolBtn: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure ExMenuItemClick(Sender: TObject);
    procedure ActNewExecute(Sender: TObject);
    procedure ActAddExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure ActClearExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActOpenExecute(Sender: TObject);
    procedure ActSaveAsExecute(Sender: TObject);
    procedure ActFindExecute(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActTaskExecute(Sender: TObject);
    procedure StrGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    // Оснавная хэш-таблица
    HashTable: THashTableGUI;

    function CanCloseFile: boolean;

    procedure MyIdle(Sender: TObject; var Done: boolean);
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  OpenDialog.InitialDir:= ExtractFilePath(Application.ExeName);
  SaveDialog.InitialDir:= openDialog.InitialDir;
  HashTable:= nil;
  Application.OnIdle:= MyIdle;
end;

procedure TfrmMain.MyIdle(Sender: Tobject; var Done: boolean);
begin
  Done:=true;
  actSave.Enabled:= HashTable <> nil;
  actSaveAs.Enabled:= HashTable <> nil;
  actClose.Enabled:= HashTable <> nil;
  actAdd.Enabled:= HashTable <> nil;

  actDelete.Enabled:=(HashTable <> nil) and (HashTable.Count <> 0);
  actClear.Enabled:= actDelete.Enabled;
  actFind.Enabled:= actDelete.Enabled;
  actTask.Enabled:= actDelete.Enabled;

  StrGrid.Visible:= (HashTable <> nil);

end;

function TFrmMain.CanCloseFile: boolean;
var
  ans: word;
begin
  result:= true;
  if (HashTable <> nil) and (HashTable.Count <> 0) then
    begin
      ans:= MessageDlg('Сохранить изменения?', mtConfirmation, [mbYes, mbNo, mbCancel], 0);
      case ans of
        mrYes:
          begin
            actSave.Execute;
            result:= not HashTable.Modified;
          end;
        mrNo:;
        mrCancel: Result:= false;
      end;
    end;
  if Result then
    FreeAndNil(HashTable);
end;

procedure TFrmMain.ExMenuItemClick(Sender: TObject);
begin
  CanCloseFile;
  Close;
end;

procedure TFrmMain.ActNewExecute(Sender: TObject);
begin
  if CanCloseFile then
    HashTable:= THashTableGUI.Create(StrGrid);
end;

procedure TFrmMain.ActAddExecute(Sender: TObject);
var
  newInfo: TInfo;
  addForm: TAddForm;
  i: integer;
begin
  addForm:= TAddForm.Create(FrmMain);
  newInfo:= TInfo.CreateEmpty;

  addForm.ShowModal;
  if addForm.Correct then
    begin
      newInfo.Number:= addForm.Number;
      newInfo.Mark:= addForm.Mark;
      newInfo.FIO:= addForm.FIO;
      ShowMessage('| ' + newInfo.Number + ' |');
      HashTable.Add(newInfo);
    end;
end;

procedure TFrmMain.ActDeleteExecute(Sender: TObject);
var
  key: Integer;
  wrd: string;
begin
  InputQuery('Ввод данных', 'Введите ключ', wrd);
  HashTable.Delete(wrd);
end;

procedure TFrmMain.ActClearExecute(Sender: TObject);
begin
  HashTable.Clear;
end;

procedure TFrmMain.ActSaveExecute(Sender: TObject);
begin
  if HashTable.FileName <> '' then
    HashTable.SaveToFile(HashTable.FileName)
  else
    actSaveAs.Execute;
end;

procedure TFrmMain.ActOpenExecute(Sender: TObject);
begin
  FreeAndNil(HashTable);
  Hashtable:= THashTableGUI.Create(StrGrid);
  if openDialog.Execute then
    begin
      HashTable.LoadFromFile(openDialog.FileName);
      HashTable.FileName:= openDialog.FileName;
    end;
end;

procedure TFrmMain.ActSaveAsExecute(Sender: TObject);
begin
  saveDialog.FileName:= HashTable.FileName;
  if saveDialog.Execute then
    HashTable.SaveToFile(saveDialog.FileName);
end;

procedure TFrmMain.ActFindExecute(Sender: TObject);
var
  key: TKey;
  wrd: string;
begin
  InputQuery('Ввод данных', 'Введите ключ', key);
  key:= wrd;
  if HashTable.Find(key) then
    ShowMessage('Элемент найден')
  else
    ShowMessage('Элемент ненайден')
end;

procedure TFrmMain.ActCloseExecute(Sender: TObject);
begin
  CanCloseFile;
end;

procedure TFrmMain.ActTaskExecute(Sender: TObject);
var
  wrd: string;
  key: TKey;
  mark: integer;
  count, i: integer;
  a, prev: TIndex;
  form: TAddForm;
begin
  InputQuery('Ввод данных', 'Введите ключ', key);
  if (HashTable.IndexOf(key, a, prev)) then
    begin
      form:= AddForm.CreateShow(FrmMain, HashTable.Table[a].info);
      form.ShowModal;
    end
  else
    ShowMessage('Информация о студенте не найдена');
end;



procedure TFrmMain.StrGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  ShowFm: TAddForm;
  key: TKey;
  index, prev: TIndex;
begin
  if ARow <> 0 then
  begin
    key:= StrGrid.Cells[0, ARow];
    HashTable.IndexOf(key, index, prev);
    ShowFm:= TAddForm.CreateShow(frmMain, HashTable.Table[index].info);
    ShowFm.Show;
  end;
end;

end.
