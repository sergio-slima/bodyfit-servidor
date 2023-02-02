object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 266
  Width = 336
  object Conn: TFDConnection
    Params.Strings = (
      'Database=D:\Sergio\Projetos\bodyfit\servidor\DB\BANCO.FDB'
      'User_Name=sysdba'
      'Password=senhasys'
      'Server=LocalHost'
      'DriverID=FB')
    TxOptions.Isolation = xiDirtyRead
    ConnectedStoredUsage = []
    LoginPrompt = False
    BeforeConnect = ConnBeforeConnect
    Left = 48
    Top = 40
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 48
    Top = 112
  end
end
