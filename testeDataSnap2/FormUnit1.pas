unit FormUnit1;

interface

uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.AppEvnts, Vcl.StdCtrls, IdHTTPWebBrokerBridge, Web.HTTPApp,
  untCtrImpressoras2;

type
  TForm1 = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    Label1: TLabel;
    ApplicationEvents1: TApplicationEvents;
    ButtonOpenBrowser: TButton;
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FServer: TIdHTTPWebBrokerBridge;
    procedure StartServer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Winapi.ShellApi, Datasnap.DSSession, Data.DBXJSON;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
begin
  ButtonStart.Enabled := not FServer.Active;
  ButtonStop.Enabled := FServer.Active;
  EditPort.Enabled := not FServer.Active;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
s_cmdtx:string;
i_retorno:integer;
begin
 i_retorno:=Le_Status();
 if i_retorno=0 then
 begin
  FechaPorta;
  ConfiguraModeloImpressora(7);
  IniciaPorta(Ansistring('USB'));
 end;
  i_retorno:=Le_Status();
  s_cmdtx:=#27+#109;
  i_retorno:=ComandoTX(s_cmdtx,length (s_cmdtx));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
   jo : TJSONObject;
begin
   Memo1.Clear;
   jo := TJSONObject.Create;
   //Na nota��o JSON, objetos s�o delimitados por {}
   //e podem conter diversos pares separados por ,
   //sendo que cada par � formado por chave e valor
   jo.AddPair('Nome', TJSONString.Create('DELMAR')); //AddPair adiciona ao JSONObject um par com chave Nome e Valor DELMAR
   jo.AddPair(TJSONPair.Create('Cidade', 'AJURICABA')); //Tamb�m podemos usar TJSONPair para criar um par
   jo.AddPair(TJSONPair.Create('Bairro', 'CENTRO'));
   Memo1.Lines.Add(jo.ToString);
end;


procedure TForm1.Button3Click(Sender: TObject);
var  //retorna um array com tr�s elementos onde cada elemento � um objeto contendo um �nico par
  ja: TJSONArray;
  jo1, jo2, jo3 : TJSONObject;
begin
   Memo1.Clear;
   //Na nota��o JSON, arrays s�o delimitados por []
   //e podem conter diversos elementos separados por ,
   ja := TJSONArray.Create;

   jo1 := TJSONObject.Create;
   jo1.AddPair('Nome', TJSONString.Create('DELMAR'));

   jo2 := TJSONObject.Create;
   jo2.AddPair(TJSONPair.Create('Nome', 'DEVMEDIA'));

   jo3 := TJSONObject.Create;
   jo3.AddPair(TJSONPair.Create('Nome', 'DALVAN'));

   ja.AddElement(jo1); //a procedure AddElemento adiciona um elemento ao JSONArray
   ja.AddElement(jo2);
   ja.AddElement(jo3);

   Memo1.Lines.Add(ja.ToString);
end;


procedure TForm1.Button4Click(Sender: TObject);
var
  arrProdutos,arrFormasPagamento : TJSONArray;
  joprincipal,objVenda_Produtos,objFormas_Pagamento : TJSONObject;
  ListaQuantidadeProduto,ListaValorUnitProduto,
  ListaDescricaoProduto: TStringList;
  i:integer;
begin
   Memo1.Clear;
   ListaQuantidadeProduto:=TStringList.Create;
   ListaValorUnitProduto:= TStringList.Create;
   ListaDescricaoProduto:= TStringList.Create;
   ListaQuantidadeProduto.Add('1');
   ListaValorUnitProduto.Add('5,00');
   ListaDescricaoProduto.Add('Suco de Laranja');
   ListaQuantidadeProduto.Add('1');
   ListaValorUnitProduto.Add('5,00');
   ListaDescricaoProduto.Add('Bolo integral');
   ListaQuantidadeProduto.Add('1');
   ListaValorUnitProduto.Add('5,00');
   ListaDescricaoProduto.Add('Banana integral');
   joprincipal:=TJSONObject.Create;
   joprincipal.AddPair(TJSONPair.Create('chaveTerminal', '141602240003895'));
   joprincipal.AddPair(TJSONPair.Create('ticket', '000001'));
   joprincipal.AddPair(TJSONPair.Create('usuario', 'Teste da Silva'));
   joprincipal.AddPair(TJSONPair.Create('valortotal', '15,00'));
   arrProdutos := TJSONArray.Create;
   arrFormasPagamento := TJSONArray.Create;
   //Adicionando os produtos no respectivo array
  for i := 0 to ListaDescricaoProduto.Count-1 do
  begin
  objVenda_Produtos := TJSONObject.Create;
  arrProdutos.AddElement(objVenda_Produtos);
  objVenda_Produtos.AddPair(TJSONPair.Create('produto',TJSONString.Create(ListaDescricaoProduto[i])));
  objVenda_Produtos.AddPair(TJSONPair.Create('quantidade',TJSONString.Create(ListaQuantidadeProduto[i])));
  objVenda_Produtos.AddPair(TJSONPair.Create('valorUnitario',TJSONString.Create(ListaValorUnitProduto[i])));
  end;
  objFormas_Pagamento := TJSONObject.Create;
  arrFormasPagamento.AddElement(objFormas_Pagamento);
  objFormas_Pagamento.AddPair(TJSONPair.Create('tipo',TJSONString.Create('nutrebem')));
  objFormas_Pagamento.AddPair(TJSONPair.Create('valor',TJSONString.Create('15,00')));
  objFormas_Pagamento.AddPair(TJSONPair.Create('origem',TJSONString.Create('C')));

  joprincipal.AddPair(TJSONPair.Create('produtos', arrProdutos));
  joprincipal.AddPair(TJSONPair.Create('formaspagamento', arrFormasPagamento));
  Memo1.Lines.Add(joprincipal.ToString);
end;

procedure TForm1.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [EditPort.Text]);
  ShellExecute(0,
        nil,
        PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

procedure TForm1.ButtonStartClick(Sender: TObject);
begin
  StartServer;

end;

procedure TerminateThreads;
begin
  if TDSSessionManager.Instance <> nil then
    TDSSessionManager.Instance.TerminateAllSessions;
end;

procedure TForm1.ButtonStopClick(Sender: TObject);
begin
  TerminateThreads;
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Self);
end;

procedure TForm1.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
