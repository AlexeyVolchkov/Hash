unit UAddForm;

interface

uses
  UInfo, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAddForm = class(TForm)
    edNumber: TEdit;
    lbNum: TLabel;
    edMark: TEdit;
    lbMark: TLabel;
    btnSave: TButton;
    btnExit: TButton;
    lbFIO: TLabel;
    edFIO: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    constructor Create(AOwner: TComponent);
    constructor CreateShow(AOwner: TComponent; info: TInfo);
  private

  public
    { Public declarations }
    Correct: boolean;
    Number: string;
    Mark: string;
    FIO: string;

  end;

var
  AddForm: TAddForm;

implementation

{$R *.dfm}

constructor TAddForm.Create(AOwner: TComponent);
var
  i: integer;
begin
  inherited Create(AOwner);
  edNumber.ReadOnly:= false;
  edMark.ReadOnly:= false;
  edFIO.ReadOnly:= false;
end;

constructor TAddForm.CreateShow(AOwner: TComponent; info: TInfo);
var
  i: integer;
  countEx, countZach: integer;
begin
  //inherited Create(AOwner);
  inherited;
  edNumber.Text:= info.Number;
  edMark.Text:= info.Mark;
  edFIO.Text:= info.FIO;

  btnSave.Visible:= false;
end;

procedure TAddForm.btnSaveClick(Sender: TObject);
begin
  if(edNumber.Text = '') or (edMark.Text = '') or (edFIO.Text = '') then
    ShowMessage('Не все обязательные поля заполнены')
  else
    begin
      Number:= edNumber.Text;
      Mark:= edMark.Text;
      FIO:= edFIO.Text;
      Correct:= true;
      Close;
    end;
end;

procedure TAddForm.btnExitClick(Sender: TObject);
begin
  Close;
end;


end.
