unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo;

type
  TFrmServidor = class(TForm)
    Memo: TMemo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmServidor: TFrmServidor;

implementation

{$R *.fmx}

uses Horse, Horse.Jhonson, Horse.BasicAuthentication, Horse.CORS, DataSet.Serialize.Config;

procedure TFrmServidor.FormShow(Sender: TObject);
begin
  THorse.Use(Jhonson());
  THorse.Use(CORS);

  THorse.Use(HorseBasicAuthentication(
  function(const AUsername, APassword: string): Boolean
  begin
    Result := AUsername.Equals('Sergio') and APassword.Equals('123');
  end));

  THorse.Listen(3000, procedure(Horse: THorse)
  begin
    memo.Lines.Add('Servidor online na porta 3000');
  end);
end;

end.
