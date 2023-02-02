program ServidorHorse;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'UPrincipal.pas' {FrmServidor},
  UDM in 'DataModule\UDM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmServidor, FrmServidor);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
