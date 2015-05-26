unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, Datasnap.DSServer, Datasnap.DSAuth,
  untCtrImpressoras2,dbxjson,IOUtils,Generics.Collections;

type
  TServerMethods1 = class(TDSServerModule)
  private
    { Private declarations }
  function AlinhaEspBranco(inteiro1,Inteiro2: integer): String;
  function GetConsumo(json:string;var TListaProdutos,TListaQuant,TListaValor:Tstringlist;
                                              var Usuario,Terminal,Ticket:string):boolean;
  function GeraJson(var json:string):boolean;
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;
    function getStatusBematech2():string;
    function acionaguilhotina2():string;
    function imprimetx(Value: string):string;
    function imprimetx2(Value: string):string;
    function imprimetx3(Value:string):string;
  end;
var
 i_retorno: integer;
 implementation

{$R *.dfm}

uses System.StrUtils, Data.DBXJSONReflect;

function TServerMethods1.acionaguilhotina2: string;
var
s_cmdtx:string;
i_retorno:integer;
begin
 i_retorno:=Le_Status();
 if i_retorno=0 then
 begin
  ConfiguraModeloImpressora(7);
  IniciaPorta(Ansistring('USB'));
  i_retorno:=Le_Status();
 end;

  s_cmdtx:=#27+#109;
  i_retorno:=ComandoTX(s_cmdtx,length (s_cmdtx));
end;

function TServerMethods1.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods1.GeraJson(var json: string): boolean;
var
  arrProdutos,arrFormasPagamento : TJSONArray;
  joprincipal,objVenda_Produtos,objFormas_Pagamento : TJSONObject;
  ListaQuantidadeProduto,ListaValorUnitProduto,
  ListaDescricaoProduto: TStringList;
  i:integer;
begin
   result:=false;
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
  json:=(joprincipal.ToString);
  result:=true;
end;

function TServerMethods1.GetConsumo(json:string;var TListaProdutos,TListaQuant,TListaValor:Tstringlist;
                                              var Usuario,Terminal,Ticket:string): boolean;
var
  LJsonArray : TJsonArray;
  LJsonVal : TJSONValue;
  LJsonObj : TJSONObject;
begin
  try
    LJsonObj.Create;
    LJsonObj := TJSONObject.ParseJSONValue(json) as TJSONObject; // array de objetos
    {for LJsonVal in LJsonArray do
    begin
        LJsonObj := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(LJsonVal.ToString),0) as TJSONObject;
       if LJsonObj<>nil then
       begin
        terminal       := LJsonObj.Get('terminal').JsonValue.Value;
        usuario     := LJsonObj.Get('usuario').JsonValue.Value;
        Ticket     := LJsonObj.Get('ticket').JsonValue.Value;
         if (terminal<>'')and(usuario<>'') then
         begin

         end
         else
         begin

         end;
        if LJsonObj<>nil then
        FreeAndNil(LJsonObj);
       end
       else
       begin
       end;
    end;
    if LJsonArray<>nil then
    FreeAndNil(LJsonArray);}
  except
    on E: Exception do
    begin

    end;
  end;
end;

{function TServerMethods1.getStatusBematech(): string;
var
 PortaImp:String;Modelo:string;
begin
try
  //result:=CtrImpressoras.getStatusBematech('USB','MP-4200TH');
except
  result:='ruim'
end;
end; }

function TServerMethods1.getStatusBematech2: string;
var
i_status: integer;
begin
 i_retorno:=Le_Status();
 if i_retorno=0 then
 begin
  ConfiguraModeloImpressora(7);
  IniciaPorta(Ansistring('USB'));
  i_retorno:=Le_Status();
 end;

    if i_retorno= 0 then
    begin
        ConfiguraModeloImpressora(7);
        IniciaPorta(Ansistring('USB'));
        i_retorno:=Le_Status();
        if i_retorno= 0 then
        begin
         result:='0 - IMP. OFF LINE/SEM COMUNICA��O';
        end;
    end;
    if i_retorno= 24 then
       result:='24 - IMPRESSORA ON LINE';
    if i_retorno= 32 then
      result:='32 - IMP. SEM PAPEL';
    if i_retorno= 5 then
      result:='5 - ON LINE - POUCO PAPEL';
    if i_retorno= 9 then
      result:='9 - TAMPA ABERTA';


end;

function TServerMethods1.imprimetx(Value: string): string;
begin
 i_retorno:=Le_Status();
 if i_retorno=0 then
 begin
  ConfiguraModeloImpressora(7);
  IniciaPorta(Ansistring('USB'));
  i_retorno:=Le_Status();
 end;
  FormataTX(AnsiString('RECARGA F�SICA DINHEIRO')+#10,3,0,0,1,1);
end;

function TServerMethods1.imprimetx2(Value: string): string;
begin
 i_retorno:=Le_Status();
 if i_retorno=0 then
 begin
  ConfiguraModeloImpressora(7);
  IniciaPorta(Ansistring('USB'));
  i_retorno:=Le_Status();
 end;
  result:=inttostr(FormataTX(AnsiString(value)+#10,3,0,0,1,1));
end;

function TServerMethods1.imprimetx3(Value: string): string;
var
  i:integer;
  vtotal,vrtotalCarrinho,cArquivo,json:String;
  texto,usuario,terminal,ticket:String;
  ListaQuantidadeProduto,ListaValorUnitProduto,ListaDescricaoProduto:Tstringlist;
begin
  result:='0';
  ListaQuantidadeProduto:=TStringList.Create;
  ListaValorUnitProduto:= TStringList.Create;
  ListaDescricaoProduto:= TStringList.Create;
  {ListaQuantidadeProduto.Add('1');
  ListaValorUnitProduto.Add('5,00');
  ListaDescricaoProduto.Add('Suco de Laranja');
  ListaQuantidadeProduto.Add('1');
  ListaValorUnitProduto.Add('5,00');
  ListaDescricaoProduto.Add('Bolo integral');
  ListaQuantidadeProduto.Add('1');
  ListaValorUnitProduto.Add('5,00');
  ListaDescricaoProduto.Add('Banana integral');}
  GeraJson(json);
  GetConsumo(json,ListaDescricaoProduto,ListaQuantidadeProduto,ListaValorUnitProduto,
  Usuario,Terminal,Ticket);
try
    vtotal:='15,00';
    cArquivo := 'c:\nutrebem_ticket_logo.bmp';
    ImprimeBitmap( AnsiString( cArquivo ), 0 );
    FormataTX(AnsiString('Loja Teste de Impress�o')+#10,3,0,0,1,0);
    FormataTX('------------------------------------------------'+#10,3,0,0,0,0);
    FormataTX(AnsiString(Terminal)+#10,3,0,0,1,0);
    FormataTX(AnsiString('Operador  : '+'Teste Impress�o')+#10,3,0,0,0,0);
    FormataTX(AnsiString('Data  : '+datetostr(now)+' Hora: '+timetostr(now))+#10,3,0,0,0,0);
    FormataTX(AnsiString('Usu�rio   : '+usuario)+#10,3,0,0,0,0);
    FormataTX('------------------------------------------------'+#10,3,0,0,0,0);
    FormataTX(AnsiString('CUPOM N�O FISCAL')+#10,3,0,0,1,1);
    FormataTX('------------------------------------------------'+#10,3,0,0,0,0);
    FormataTX('Item   Descri��o'+#10,3,0,0,0,0);
    FormataTX('     Quantidade x Valor unit�rio      SubTotal'#10,3,0,0,0,0);
    for i:=0 to ListaQuantidadeProduto.Count-1  do
    begin
     vrtotalCarrinho:=formatfloat('###,###0.00', StrToFloat(ListaQuantidadeProduto[i])*
     strtofloat(ListaValorUnitProduto[i]));
     texto:=texto+inttostr(i+1)+')  '+ListaDescricaoProduto[i]+#10+
    '      '+ AlinhaEspBranco(6,length(ListaQuantidadeProduto[i]))+ListaQuantidadeProduto[i]
    +'   x   '+AlinhaEspBranco(6,length(ListaValorUnitProduto[i]))+ListaValorUnitProduto[i]
    +'                  '+AlinhaEspBranco(6,length(vrtotalCarrinho))+vrtotalCarrinho+#10;
    end;
    texto:=texto+
    '------------------------------------------------'+#10+
    'Total           :   '+vtotal+#10+
    'Forma pagamento :    Cart�o Nutrebem'+#10+
    'Numero Ticket   :   '+ticket+#10+#10+#10+#10+#10;

    if bematechTX(AnsiString(texto))=1then
     begin
       result:='1';
       AcionaGuilhotina(1);
     end;
  except
  on E: Exception do
   begin
      result:='0';
   end;
   end;
end;




function TServerMethods1.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

function TServerMethods1.AlinhaEspBranco(inteiro1,Inteiro2: integer): String;
begin
try
   If (Inteiro1=7) and (Inteiro2=4) then
  begin
    result:='   ';//3 espa�os
  end
  else If (Inteiro1=6) and (Inteiro2=4)  then
  begin
    result:='  ';//2 espa�os
  end
  else If (Inteiro1=5) and (Inteiro2=4)  then
  begin
    result:=' ';//1 espa�o
  end
  else If (Inteiro1=4) and (Inteiro2=4)  then
  begin
    result:='';//sem espa�o
  end
  else If (Inteiro1=7) and (Inteiro2=5) then
  begin
    result:='  ';//2 espa�os
  end
  else If (Inteiro1=6) and (Inteiro2=5)  then
  begin
    result:=' ';//1 espa�o
  end
  else If (Inteiro1=5) and (Inteiro2=5)  then
  begin
    result:='';//sem espa�o
  end
  else If (Inteiro1=7) and (Inteiro2=6) then
  begin
    result:=' ';//1 espa�o
  end
  else If (Inteiro1=6) and (Inteiro2=6)  then
  begin
    result:='';//sem espa�o
  end
  else If (Inteiro1=7) and (Inteiro2=7)  then
  begin
    result:='';//sem espa�o
  end;
     except
      on E: Exception do
     begin

     end;
   end;
end;

end.

