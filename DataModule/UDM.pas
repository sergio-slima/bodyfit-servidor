unit UDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase,

  DataSet.Serialize, DataSet.Serialize.Config, System.JSON, FireDAC.DApt;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnBeforeConnect(Sender: TObject);
  private
    procedure CarregarConfigDB(Connection: TFDConnection);
    { Private declarations }
  public
    { Public declarations }
    function Login(email, senha: String): TJsonObject;
    function CriarConta(nome, email, senha: String): TJsonObject;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.CarregarConfigDB(Connection: TFDConnection);
begin
  Connection.DriverName := 'FB';

  with Connection.Params do
  begin
    Clear;
    Add('DriverID=FB');
    Add('Database=D:\Sergio\Projetos\bodyfit\servidor\DB\BANCO.FDB');
    Add('User_Name=SYSDBA');
    Add('Password=senhasys');
    Add('Port=3050');
    Add('Server=localhost');
    Add('Protocol=TCPIP');
  end;

  FDPhysFBDriverLink.VendorLib := 'C:\Program Files (x86)\Firebird\Firebird_3_0\fbclient.dll';
end;

procedure TDM.ConnBeforeConnect(Sender: TObject);
begin
  CarregarConfigDB(Conn);
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
  TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';

  Conn.Connected := True;
end;

function TDM.Login(email, senha: String): TJsonObject;
var
  qry: TFDQuery;
begin
  if (email = '') or (senha = '') then
    raise Exception.Create('Informe o e-mail e a senha!');

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Conn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('select id_usuario, nome, email');
      SQL.Add('from tab_usuario');
      SQL.Add('where email = :email and senha = :senha');
      ParamByName('email').Value := email;
      ParamByName('senha').Value := senha;
      Open;
    end;

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

function TDM.CriarConta(nome, email, senha: String): TJsonObject;
var
  qry: TFDQuery;
begin
  if (nome = '') or (email = '') or (senha = '') then
    raise Exception.Create('Informe o nome, e-mail e senha!');

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Conn;

    with qry do
    begin
      Close;
      SQL.Clear;
      SQL.Add('insert into tab_usuario (nome, email, senha)');
      SQL.Add('values (:nome, :email, :senha)');
      SQL.Add('returning id_usuario, nome, email');
      ParamByName('nome').Value := email;
      ParamByName('email').Value := email;
      ParamByName('senha').Value := senha;
      Open;
    end;    //01:33 hs

    Result := qry.ToJSONObject;
  finally
    FreeAndNil(qry);
  end;
end;

end.
