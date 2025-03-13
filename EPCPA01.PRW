#include "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"
/*/{Protheus.doc} User Function EPCPA01()
	Cópia do produto para criação dos códigos para roteiro auxiliar
	@history 31/07/2024, Marcelo Benedito, 229748 - Ajuste nos item Complementares
	@history 11/03/2025, Bruno Walace, 247348 - Atributos do código do roteiro complementar 
	@type  Function
	@author Marcelo Benedito
	@since 07/09/2023
	@version version
	@param nenhum, sempre Nil, padrão do Protheus
	@return nenhum, sempre Nil, padrão do Protheus
	/*/
User Function EPCPA01()
Local aAmb		:= getarea() 
Local aAmbSB1	:= SB1->( getarea() )
Local cSB1Auto	:= alltrim( SB1->B1_COD )
Local nSeq 		:= 0
Local cCodigo 	:= ""

SB1->( dbsetorder( 1 ) )		// filal + cod produto

if alltrim(SB1->B1_GRUPO) + SB1->B1_XSUBGRP + SB1->B1_XCLASSE == "011601"
	MESSAGEBOX( "Este código já é de roteiros complementares. Posicione sobre o código original.", "EPCPA01_01", 16 )

else	

	do while .t.
		cCodigo	:= cSB1Auto + "C" + strzero(++nSeq, 3)

		if SB1->( dbseek( xfilial("SB1") + cCodigo ))
			loop 
		else
			exit 
		endif
	enddo


	CriaRotComp( cSB1Auto, cCodigo)	
endif

SB1->( restarea( aAmbSB1 ) )
restarea( aAmb ) 

Return Nil


/*/{Protheus.doc} CriaRotComp(cCodSb1, cCodRot)
	(long_description)
	@type  Static Function
	@author user
	@since 07/09/2023
	@version version
	@param cCodSb1, caracter, código original do cadastro do SB1
	@param cCodRot, caracter, código que será atribuído ao roteiro complementar	
	@return nenhum, sempre Nil, padrão do Protheus
/*/
Static Function CriaRotComp(cCodSb1, cCodRot)
Local oModel
Local oSB1Mod
Local oSB5Mod
Local aAmb		:= getarea() 
Local aAmbSB1 	:= SB1->( getarea() )
Local aAmbSB5 	:= SB5->( getarea() )
Local lRet		:= .T.
Local aErro		:= {}

SB1->( dbsetorder( 1 ) )		// filial + cod produto
SB5->( dbsetorder( 1 ) )		// filial + cod produto

if SB1->( dbseek(xfilial("SB1") + cCodSb1))

	oModel := FWLoadModel("MATA010")
	oModel:SetOperation( MODEL_OPERATION_INSERT )
	oModel:Activate()

//Pegando o model e setando os campos
	// 11/03/2025 - Bruno Walace reorganização dos campos
	oSB1Mod := oModel:GetModel("SB1MASTER")
	oSB1Mod:SetValue("B1_COD"		, cCodRot ) 
	oSB1Mod:SetValue("B1_GRUPO"		, "01" ) 
	oSB1Mod:SetValue("B1_XSUBGRP"	, "16" ) 
	oSB1Mod:SetValue("B1_XCLASSE"	, "01" ) 
	oSB1Mod:SetValue("B1_DESC"		, alltrim( SB1->B1_DESC ) ) 
	oSB1Mod:SetValue("B1_XCARACT"	, alltrim( SB1->B1_XCARACT ) ) 
	oSB1Mod:SetValue("B1_TIPO"		, SB1->B1_TIPO ) 
	oSB1Mod:SetValue("B1_CONTA"		, SB1->B1_CONTA )  
	oSB1Mod:SetValue("B1_CONTA1"	, SB1->B1_CONTA1 ) 
	oSB1Mod:SetValue("B1_CONTA2"	, SB1->B1_CONTA2 ) 
	oSB1Mod:SetValue("B1_TE"		, SB1->B1_TE ) 
	oSB1Mod:SetValue("B1_TS"		, SB1->B1_TS ) 
	oSB1Mod:SetValue("B1_POSIPI"	, SB1->B1_POSIPI ) 
	oSB1Mod:SetValue("B1_EX_NCM"	, SB1->B1_EX_NCM ) 
	oSB1Mod:SetValue("B1_CODISS"	, SB1->B1_CODISS ) 

	// 13/03/2025 - Bruno Walace 
	//oSB1Mod:SetValue("B1_XMAKBUY"	, SB1->B1_XMAKBUY ) 
	
	oSB1Mod:SetValue("B1_XPNPLM"	, SB1->B1_XPNPLM ) 
	oSB1Mod:SetValue("B1_XPOLCIV"	, SB1->B1_XPOLCIV ) 
	oSB1Mod:SetValue("B1_XPOLFED"	, SB1->B1_XPOLFED ) 
	oSB1Mod:SetValue("B1_XEXERCI"	, SB1->B1_XEXERCI ) 
	oSB1Mod:SetValue("B1_XCFISPQ"	, SB1->B1_XCFISPQ ) 
	oSB1Mod:SetValue("B1_XPNFABR"	, SB1->B1_XPNFABR ) 
	oSB1Mod:SetValue("B1_XREQIO "	, SB1->B1_XREQIO ) 
	oSB1Mod:SetValue("B1_XCOMPR "	, SB1->B1_XCOMPR ) 
	oSB1Mod:SetValue("B1_XCODCLI"	, SB1->B1_XCODCLI ) 
	oSB1Mod:SetValue("B1_XDSCCLI"	, SB1->B1_XDSCCLI ) 
	oSB1Mod:SetValue("B1_PE"		, SB1->B1_PE ) 
	oSB1Mod:SetValue("B1_TIPE"		, SB1->B1_TIPE ) 
	oSB1Mod:SetValue("B1_XCATOPR"	, SB1->B1_XCATOPR ) 
	oSB1Mod:SetValue("B1_XPROESP"	, SB1->B1_XPROESP ) 
	oSB1Mod:SetValue("B1_XCODFAM"	, SB1->B1_XCODFAM ) 
	oSB1Mod:SetValue("B1_XTPARMZ"	, SB1->B1_XTPARMZ ) 

// 31/07/2024 Marcelo Benedito
//	oSB1Mod:SetValue("B1_UM"		, "HR" ) 
//	oSB1Mod:SetValue("B1_SEGUM"		, "HR" ) 
//	oSB1Mod:SetValue("B1_LOCPAD"	, "01" ) 
//	oSB1Mod:SetValue("B1_RASTRO"	, "N" )
//	oSB1Mod:SetValue("B1_LOCALIZ"	, "N" ) 

	// 13/03/2025 - Bruno Walace 
	oSB1Mod:SetValue("B1_XMAKBUY"	, "F" ) 

	oSB1Mod:SetValue("B1_UM"		, "PC" ) 
	oSB1Mod:SetValue("B1_SEGUM"		, "PC" ) 
	oSB1Mod:SetValue("B1_LOCPAD"	, "WIP" ) 
	oSB1Mod:SetValue("B1_RASTRO"	, "L" )
	oSB1Mod:SetValue("B1_LOCALIZ"	, "S" ) 

	oSB1Mod:SetValue("B1_CONV"		, 1 ) 
	oSB1Mod:SetValue("B1_TIPCONV"	, "M" ) 
	oSB1Mod:SetValue("B1_ORIGEM"	, "0" ) 
	oSB1Mod:SetValue("B1_CODFORM"	, " " ) 
	oSB1Mod:SetValue("B1_NOTAMIN"	, 0 ) 
	oSB1Mod:SetValue("B1_XLEGADO"	, "N" ) 
	//oSB1Mod:SetValue("B1_XFABRIC"	, SB1->B1_XFABRIC ) 
	oSB1Mod:SetValue("B1_FANTASM"	, "N" ) 
	//oSB1Mod:SetValue("B1_XCODFAM"	, if(empty(SB1->B1_XCODFAM), "01", SB1->B1_XCODFAM)	) 
	oSB1Mod:SetValue("B1_XNAT "		, "ST" ) 

//Setando o complemento do produto
	if "SB5" $ alltrim( GETMV("MV_CADPROD") )
		oSB5Mod := oModel:GetModel("SB5DETAIL")
		If oSB5Mod != Nil
			oSB5Mod:SetValue("B5_CEME"	, SB1->B1_DESC	)
		EndIf
	endif
		
//Se conseguir validar as informações
	If oModel:VldData()
			
//Tenta realizar o Commit
		lRet 	:= oModel:CommitData()

// 31/07/2024 Marcelo Benedito
		if lRet 
			CriaSB2(cCodRot, "WIP")
		endif 
	else 
		lRet 	:= .F.
	endif

//Se não deu certo a inclusão, mostra a mensagem de erro
//Busca o Erro do Modelo de Dados
	if !lRet
		aErro := oModel:GetErrorMessage()

		AutoGrLog( "Codigo de Produto:         " + ' [' + cCodSB1 + ']' )
		AutoGrLog( "Id do formulário de origem:" + ' [' + AllToChar( aErro[1]  ) + ']' )
		AutoGrLog( "Id do campo de origem:     " + ' [' + AllToChar( aErro[2]  ) + ']' )
		AutoGrLog( "Id do formulário de erro:  " + ' [' + AllToChar( aErro[3]  ) + ']' )
		AutoGrLog( "Id do campo de erro:       " + ' [' + AllToChar( aErro[4]  ) + ']' )
		AutoGrLog( "Id do erro:                " + ' [' + AllToChar( aErro[5]  ) + ']' )
		AutoGrLog( "Mensagem do erro:          " + ' [' + AllToChar( aErro[6]  ) + ']' )
		AutoGrLog( "Mensagem da solução:       " + ' [' + AllToChar( aErro[7]  ) + ']' )
		AutoGrLog( "Valor atribuido:           " + ' [' + AllToChar( aErro[8]  ) + ']' )
		AutoGrLog( "Valor anterior:            " + ' [' + AllToChar( aErro[9]  ) + ']' )
		MostraErro()				
	EndIf
		
//Desativa o modelo de dados
	oModel:DeActivate()
	oModel:Destroy()
endif

SB5->( restarea( aAmbSB5 ) )	
SB1->( restarea( aAmbSB1 ) )	
restarea( aAmb )

Return Nil
