program N9a;

uses
  Forms,
  Hash_Main in 'Hash_Main.pas' {FrmMain},
  UInfo in 'UInfo.pas',
  UHashTable in 'UHashTable.pas',
  UHashTableGUI in 'UHashTableGUI.pas',
  UAddForm in 'UAddForm.pas' {AddForm};

// UShowStudFrm in 'UShowStudFrm.pas' {fmShowStud};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TAddForm, AddForm);
  //  Application.CreateForm(TfmShowStud, fmShowStud);
  Application.Run;
end.
