unit untCtrImpressoras;

interface

uses Classes, typinfo, DB, dbClient,SysUtils, System.UITypes,System.UIConsts,MidasLib;

   type

  TCtrImpressoras = Class
     private
     public

//Funções BEMATECH
  function getStatusBematech(PortaImp:String;Modelo:string): string;
  function BIniciaPorta(Porta:string):integer;
  //function IniciaBematech1(PPortaImp,PModeloImp:string):string;




      end;
//Funções BEMATECH DLL
function IniciaPorta(Porta:Ansistring):integer; stdcall; far; external 'Mp2032.dll';
function FechaPorta: integer	;  stdcall; far; external 'Mp2032.dll';
function ConfiguraTaxaSerial(velocidade:integer):integer; stdcall; far; external 'Mp2032.dll';
function BematechTX(BufTrans:Ansistring):integer; stdcall; far; external 'Mp2032.dll';
function FormataTX(BufTras:Ansistring; TpoLtra:integer; Italic:integer; Sublin:integer; expand:integer; enfat:integer):integer; stdcall; far; external 'Mp2032.dll';
function ComandoTX (BufTrans:string;TamBufTrans:integer):integer; stdcall; far; external 'Mp2032.dll';
function Status_Porta:integer; stdcall; far; external 'Mp2032.dll';
function Le_Status:integer; stdcall; far; external 'Mp2032.dll';
function ConfiguraModeloImpressora(ModeloImpressora:integer):integer; stdcall; far; external 'Mp2032.dll';
function AcionaGuilhotina(Modo:integer):integer; stdcall; far; external 'Mp2032.dll';

var
  CtrImpressoras: TCtrImpressoras;


implementation





function TCtrImpressoras.getStatusBematech(PortaImp:String;Modelo:string): string;
var
i_retorno: integer;
s_stporta: String;
begin
try
//ANÁLISE DO RETORNO DE STATUS
if PortaImp='USB' then s_stporta:='usb';
i_retorno:=Le_Status();

//*********************IMPRESSORAS MP 4000 TH CONEXÃO USB***********************
 { if (modelo='MP-4000TH') and (s_stporta='serial') then
    Begin
    if i_retorno= 24 then
    begin
     Result:='On line.';
     //frmPrincipal.GPBematechOldStatus:=24;
    end;
    if i_retorno= 68 then
    begin
     Result:='Off line.';
     //frmPrincipal.GPBematechOldStatus:=68;
    end;
    if i_retorno= 32 then
    begin
     Result:='Fim de papel.';
     //frmPrincipal.GPBematechOldStatus:=32;
    end;
    if i_retorno= 24 then
    begin
     Result:='Pouco papel.';
     //frmPrincipal.GPBematechOldStatus:=24;
    end;
    End }

//*******************IMPRESSORAS MP 4200 TH CONEXÃO TODAS***********************

    if (modelo='MP-4200TH') then
    Begin
     //FechaPorta;
     //ConfiguraModeloImpressora(7);
     //IniciaPorta(PortaImp);
    if i_retorno= 24 then
    begin
     Result:='On line.';
     //frmPrincipal.GPBematechOldStatus:=24;
    end;
    if i_retorno= 0 then
    begin
     Result:='Off line.';
     //frmPrincipal.GPBematechOldStatus:=0;
    end;
    if i_retorno= 32then
    begin
     Result:='Fim de papel.';
     //frmPrincipal.GPBematechOldStatus:=32;
    end;
    if i_retorno= 5 then
    begin
     Result:='Pouco papel.';
     //frmPrincipal.GPBematechOldStatus:=5;
    end;
    if i_retorno= 9 then
    begin
     Result:='Tampa Aberta.';
     //frmPrincipal.GPBematechOldStatus:=9;
    end;
    {End

//*********************IMPRESSORAS MP 2500 TH CONEXÃO USB***********************

  else if (modelo='MP-2500TH') and (s_stporta='usb') then
  Begin
    if (frmPrincipal.GPBematechOldStatus=68)or(frmPrincipal.GPBematechOldStatus=1) then
    begin
     ConfiguraModeloImpressora(8);
     BIniciaPorta(PortaImp);
    end;
    if i_retorno= 24 then
    begin
     Result:='On line.';
     frmPrincipal.GPBematechOldStatus:=24;
    end;
    if i_retorno= 32 then
    begin
     Result:='Fim de papel.';
     frmPrincipal.GPBematechOldStatus:=32;
    end;
    if i_retorno= 5 then
    begin
     Result:='Pouco papel.';
     frmPrincipal.GPBematechOldStatus:=5;
    end;
    if i_retorno= 9 then
    begin
     Result:='Tampa Aberta.';
     frmPrincipal.GPBematechOldStatus:=9;
    end;
    if i_retorno= 68 then
    begin
     FechaPorta;
     ConfiguraModeloImpressora(8);
     BIniciaPorta(PortaImp);
     i_retorno:=Le_Status();
     if i_retorno= 68 then
     begin
      Result:='Off line.';
      frmPrincipal.GPBematechOldStatus:=68;
     end
     else if i_retorno= 24 then
    begin
     Result:='On line.';
     frmPrincipal.GPBematechOldStatus:=24;
    end
    else if i_retorno= 32 then
    begin
     Result:='Fim de papel.';
     frmPrincipal.GPBematechOldStatus:=32;
    end
    else if i_retorno= 5 then
    begin
     Result:='Pouco papel.';
     frmPrincipal.GPBematechOldStatus:=5;
    end
    else if i_retorno= 9 then
    begin
     Result:='Tampa Aberta.';
     frmPrincipal.GPBematechOldStatus:=9;
    end;
    end;
    if i_retorno= 0 then
    begin
     Result:='Off line.';
     frmPrincipal.GPBematechOldStatus:=1;
    end;}
  End;
except
   on E: Exception do
 begin
 //dm_Util.ADDTryCath(Terminal.ID_TERMINAL,'getStatusBematech '+e.Message,'TCtrImpressoras','AA',terminal.CHAVETERMINAL);
 end;
end;
end;





function TCtrImpressoras.BIniciaPorta(Porta: string): integer;
begin
result:=-100;
try
  result:=IniciaPorta(pchar(Porta))
  except
    on E: Exception do
  begin
     //dm_Util.ADDTryCath(Terminal.ID_TERMINAL,'BIniciaPorta '+e.Message,'TCtrImpressoras','PDV',terminal.CHAVETERMINAL);
  end;
   end;
end;



end.
