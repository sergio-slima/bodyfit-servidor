program ServidorHorse;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'UPrincipal.pas' {FrmServidor},
  UDM in 'DataModule\UDM.pas' {DM: TDataModule},
  UControllers in 'Controllers\UControllers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmServidor, FrmServidor);
  Application.Run;
end.
