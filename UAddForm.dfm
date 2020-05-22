object AddForm: TAddForm
  Left = 468
  Top = 349
  BorderStyle = bsSingle
  Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
  ClientHeight = 229
  ClientWidth = 296
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbNum: TLabel
    Left = 24
    Top = 16
    Width = 141
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
  end
  object lbMark: TLabel
    Left = 24
    Top = 72
    Width = 76
    Height = 13
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1084#1072#1088#1082#1091
  end
  object lbFIO: TLabel
    Left = 24
    Top = 128
    Width = 72
    Height = 13
    BiDiMode = bdLeftToRight
    Caption = #1042#1074#1077#1076#1080#1090#1077' '#1060#1048#1054
    ParentBiDiMode = False
  end
  object edNumber: TEdit
    Left = 24
    Top = 32
    Width = 249
    Height = 21
    ReadOnly = True
    TabOrder = 0
  end
  object edMark: TEdit
    Left = 24
    Top = 88
    Width = 249
    Height = 21
    ReadOnly = True
    TabOrder = 1
  end
  object btnSave: TButton
    Left = 24
    Top = 184
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object btnExit: TButton
    Left = 200
    Top = 184
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 3
    OnClick = btnExitClick
  end
  object edFIO: TEdit
    Left = 24
    Top = 144
    Width = 249
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
end
