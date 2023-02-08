unit UControllers;

interface

uses UDM, Horse, System.JSON, System.SysUtils;

procedure RegistrarRotas;
procedure Login(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure CriarConta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
procedure ListarTreinos(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure RegistrarRotas;
begin
  THorse.Post('/usuarios/login', Login);
  THorse.Post('/usuarios/registro', CriarConta);
  THorse.Put('/usuarios/senha', EditarSenha);
  THorse.Put('/usuarios', EditarUsuario);
  THorse.Get('/treinos', ListarTreinos);
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

procedure EditarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  DM: TDM;
  id_usuario: Integer;
  nome, email: String;
  body, json_ret: TJSONObject;
begin
  try
    try
      DM := TDM.Create(nil);

      body := Req.Body<TJSONObject>;
      id_usuario := body.GetValue<integer>('id_usuario', 0);
      nome := body.GetValue<string>('nome', '');
      email := body.GetValue<string>('email', '');

      json_ret := DM.EditarUsuario(id_usuario, nome, email);

      Res.Send<TJSONObject>(json_ret).Status(200);

    except on ex:exception do
      Res.Send(ex.Message).Status(500);
    end;
  finally
    FreeAndNil(DM);
  end;
end;

procedure EditarSenha(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  DM: TDM;
  id_usuario: Integer;
  senha: String;
  body, json_ret: TJSONObject;
begin
  try
    try
      DM := TDM.Create(nil);

      body := Req.Body<TJSONObject>;
      id_usuario := body.GetValue<integer>('id_usuario', 0);
      senha := body.GetValue<string>('senha', '');

      json_ret := DM.EditarSenha(id_usuario, senha);

      Res.Send<TJSONObject>(json_ret).Status(200);

    except on ex:exception do
      Res.Send(ex.Message).Status(500);
    end;
  finally
    FreeAndNil(DM);
  end;
end;

procedure ListarTreinos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  DM: TDM;
  id_usuario: Integer;
begin
  try
    try
      DM := TDM.Create(nil);

      try
        id_usuario := Req.Query['id_usuario'].ToInteger;
      except
        id_usuario := 0;
      end;

      Res.Send<TJSONArray>(DM.ListarTreinos(id_usuario)).Status(200);

    except on ex:exception do
      Res.Send(ex.Message).Status(500);
    end;
  finally
    FreeAndNil(DM);
  end;
end;

end.
