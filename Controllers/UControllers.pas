unit UControllers;

interface

uses UDM, Horse, System.JSON, System.SysUtils;

procedure RegistrarRotas;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CriarConta(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.Post('/usuarios/login', Login);
  THorse.Post('/usuarios/registro', CriarConta);
end;

procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  DM: TDM;
  email, senha: String;
  body, json_ret: TJSONObject;
begin
  try
    try
      DM := TDM.Create(nil);

      body := Req.Body<TJSONObject>;
      email := body.GetValue<string>('email', '');
      senha := body.GetValue<string>('senha', '');

      json_ret := DM.Login(email, senha);

      if json_ret.Size = 0 then
        Res.Send('E-mail ou senha inválida!').Status(401)
      else
        Res.Send<TJSONObject>(json_ret).Status(200);

    except on ex:exception do
      Res.Send(ex.Message).Status(500);
    end;
  finally
    FreeAndNil(DM);
  end;
end;

procedure CriarConta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  DM: TDM;
  nome, email, senha: String;
  body, json_ret: TJSONObject;
begin
  try
    try
      DM := TDM.Create(nil);

      body := Req.Body<TJSONObject>;
      nome := body.GetValue<string>('nome', '');
      email := body.GetValue<string>('email', '');
      senha := body.GetValue<string>('senha', '');

      json_ret := DM.CriarConta(nome, email, senha);

      Res.Send<TJSONObject>(json_ret).Status(201);

    except on ex:exception do
      Res.Send(ex.Message).Status(500);
    end;
  finally
    FreeAndNil(DM);
  end;
end;

end.
