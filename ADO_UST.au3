Global $g_AdoErrDesc

#include "ADO.au3"
#include <File.au3>
#Tidy_Parameters=/sort_funcs /reel
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

#include <Array.au3>
;#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>

Global $oCon = Null ; $oConnection

; SetUP internal ADO.au3 UDF COMError Handler
_ADO_ComErrorHandler_UserFunction(_ADO_COMErrorHandler_Function)

_ADO_UST_online() ; :)

Func _ADO_UST_online()

	$sFilePath = @ScriptDir & '\settings.ini'

	Local $sDriver 		= IniRead($sFilePath, "SQL", 'Driver', 'SQL Server')
	Local $sDatabase 	= IniRead($sFilePath, "SQL", 'Database','ust')
	Local $sServer 		= IniRead($sFilePath, "SQL", 'Server','localhost')
	Local $sPort 			= IniRead($sFilePath, "SQL", 'Port', '1433')
	Local $sUser 			= IniRead($sFilePath, "SQL", 'User', 'sa')
	Local $sPassword 	= IniRead($sFilePath, "SQL", 'Password','delor')
	
	Local $iNumber 		= IniRead($sFilePath, "AZS", 'Number',0)
	Local $iCode     		= IniRead($sFilePath, "Server", 'Code',1000)
	Local $sAddr	 		= IniRead($sFilePath, "Server", 'Address','www.fake.io')
	
	ConsoleWrite($iCode  & @CRLF )

	Local $sConnectionString = 'Driver={' & $sDriver & '};DATABASE=' & $sDatabase & ';SERVER=' & $sServer & ';PORT=' & $sPort & ';UID=' & $sUser & ';PWD=' & $sPassword & ';'

	Local $ADOErr, $ADOExtErr, $LogErr = @ScriptDir & "\ErrorLog.txt"

    ConsoleWrite("_ADO_UST " & $sConnectionString & @CRLF)

    ; Create connection object
    Local $oConnection = _ADO_Connection_Create()

    ; Open connection with $sConnectionString
    _ADO_Connection_OpenConString($oConnection, $sConnectionString)
    If @error Then 
		ConsoleWrite(@error)
		ConsoleWrite(@extended)
		_FileWriteLog($LogErr, @CRLF & @error & @CRLF & @extended)
		Return SetError(@error, @extended, $ADO_RET_FAILURE)
	EndIf

    $oCon = $oConnection

    Local $Query, $aQresult, $aResult, $Qresult
    $Query = ''
    
	$Query = FileRead(@ScriptDir & "\q1.txt")
	
	$aResult = _ADO_Execute($oCon, $Query, False, False)
    If @error Then
        $ADOErr = @error
        $ADOExtErr = @extended
        ;MsgBox($MB_SYSTEMMODAL, "ADO SQL Error: " & $ADO_RET_FAILURE, $g_AdoErrDesc & " * " & @CRLF & '@error = ' & @error & @CRLF & '@extended = ' & @extended & @CRLF & $Query & @CRLF)
        _FileWriteLog($LogErr, @CRLF & '------------------------------------------------ SQL ERROR ' & "Error: " & $ADOErr & " * " & "Extended: " & $ADOExtErr & " * " & "ADO Returned " & $ADO_RET_FAILURE & @CRLF & $Query & @CRLF)
        $ADOErr = 0
        $ADOExtErr = 0
	EndIf

    $Query = "select * from ##gt "
    $aResult = _ADO_Execute($oCon, $Query, True, True)
    If @error Then
        $ADOErr = @error
        $ADOExtErr = @extended
        ;MsgBox($MB_SYSTEMMODAL, "ADO SQL Error: " & $ADO_RET_FAILURE, $g_AdoErrDesc & " * " & @CRLF & '@error = ' & @error & @CRLF & '@extended = ' & @extended & @CRLF & $Query & @CRLF)
        _FileWriteLog($LogErr, @CRLF & '------------------------------------------------ SQL ERROR ' & "Error: " & $ADOErr & " * " & "Extended: " & $ADOExtErr & " * " & "ADO Returned " & $ADO_RET_FAILURE & @CRLF & $Query & @CRLF)
        $ADOErr = 0
        $ADOExtErr = 0
	Else
	    _FileWriteLog($LogErr, @CRLF & _ArrayToString($aResult, '$#$') & @CRLF)
    EndIf
	
    $Query = "select * from ##gs "
    $aResult = _ADO_Execute($oCon, $Query, True, True)
    If @error Then
        $ADOErr = @error
        $ADOExtErr = @extended
        ;MsgBox($MB_SYSTEMMODAL, "ADO SQL Error: " & $ADO_RET_FAILURE, $g_AdoErrDesc & " * " & @CRLF & '@error = ' & @error & @CRLF & '@extended = ' & @extended & @CRLF & $Query & @CRLF)
        _FileWriteLog($LogErr, @CRLF & '------------------------------------------------ SQL ERROR ' & "Error: " & $ADOErr & " * " & "Extended: " & $ADOExtErr & " * " & "ADO Returned " & $ADO_RET_FAILURE & @CRLF & $Query & @CRLF)
        $ADOErr = 0
        $ADOExtErr = 0
	Else
	    ConsoleWrite(_ArrayToString($aResult) & @CRLF)
    EndIf
	
    $Query = "select * from ##gsd "
    $aResult = _ADO_Execute($oCon, $Query, True, True)
    If @error Then
        $ADOErr = @error
        $ADOExtErr = @extended
        ;MsgBox($MB_SYSTEMMODAL, "ADO SQL Error: " & $ADO_RET_FAILURE, $g_AdoErrDesc & " * " & @CRLF & '@error = ' & @error & @CRLF & '@extended = ' & @extended & @CRLF & $Query & @CRLF)
        _FileWriteLog($LogErr, @CRLF & '------------------------------------------------ SQL ERROR ' & "Error: " & $ADOErr & " * " & "Extended: " & $ADOExtErr & " * " & "ADO Returned " & $ADO_RET_FAILURE & @CRLF & $Query & @CRLF)
        $ADOErr = 0
        $ADOExtErr = 0
	Else
	    ConsoleWrite(_ArrayToString($aResult) & @CRLF)
    EndIf
	
	Return 0

#cs
    ; like SQLite_Exec
    If Not _ADO_Execute($oCon, "CREATE temp TABLE persons (Name text, Age int);") = $ADO_ERR_SUCCESS Then
        ConsoleWrite("5a @ERROR " & @error & @CRLF)
        ConsoleWrite("5b @ERROR " & @error & @CRLF)
        ConsoleWrite("5c @extended " & @extended & @CRLF)
    Else
        MsgBox($MB_SYSTEMMODAL, "5. ADO Okay", $ADO_ERR_SUCCESS)
    EndIf

    ; like SQLite_GetTable2d
    $Query = "Select * from t_log_access order by 2 desc limit 5; "
    ;$aQresult = _ADO_Execute($oCon, $Query, True)

    $aResult = _ADO_Execute($oCon, $Query, True, True)
    If @error Then
        SetError(@error, @extended, $ADO_RET_FAILURE)
        $ADOErr = @error
        $ADOExtErr = @extended
        MsgBox($MB_SYSTEMMODAL, "ADO SQL Error: " & $ADO_RET_FAILURE, $g_AdoErrDesc & " * " & @CRLF & '@error = ' & @error & @CRLF & '@extended = ' & @extended & @CRLF & $Query & @CRLF)
        _FileWriteLog($LogErr, @CRLF & '------------------------------------------------ SQL ERROR ' & "Error: " & $ADOErr & " * " & "Extended: " & $ADOExtErr & " * " & "ADO Returned " & $ADO_RET_FAILURE & @CRLF & $Query & @CRLF)
        $ADOErr = 0
        $ADOExtErr = 0
    EndIf
    ConsoleWrite(_ArrayDisplay($aResult))


    ; PREPAREd statement
    $Query = "PREPARE myloginsert (text ) AS  INSERT INTO t_log_access (uname  ) values ( $1 ) ; "
    ;$aQresult = _ADO_Execute($oCon, $Query, True)

    $aResult = _ADO_Execute($oCon, $Query, True, True)
    If @error Then
        SetError(@error, @extended, $ADO_RET_FAILURE)
        $ADOErr = @error
        $ADOExtErr = @extended
        MsgBox($MB_SYSTEMMODAL, "ADO SQL Error: " & $ADO_RET_FAILURE, $g_AdoErrDesc & " * " & @CRLF & '@error = ' & @error & @CRLF & '@extended = ' & @extended & @CRLF & $Query & @CRLF)
        _FileWriteLog($LogErr, @CRLF & '------------------------------------------------ SQL ERROR ' & "Error: " & $ADOErr & " * " & "Extended: " & $ADOExtErr & " * " & "ADO Returned " & $ADO_RET_FAILURE & @CRLF & $Query & @CRLF)
        $ADOErr = 0
        $ADOExtErr = 0
    EndIf

    $Query = "EXECUTE myloginsert ('skysnake from a prepared statement' )  ; "
    ;$aQresult = _ADO_Execute($oCon, $Query, True)

    $aResult = _ADO_Execute($oCon, $Query, True, True)
    If @error Then
        SetError(@error, @extended, $ADO_RET_FAILURE)
        $ADOErr = @error
        $ADOExtErr = @extended
        MsgBox($MB_SYSTEMMODAL, "ADO SQL Error: " & $ADO_RET_FAILURE, $g_AdoErrDesc & " * " & @CRLF & '@error = ' & @error & @CRLF & '@extended = ' & @extended & @CRLF & $Query & @CRLF)
        _FileWriteLog($LogErr, @CRLF & '------------------------------------------------ SQL ERROR ' & "Error: " & $ADOErr & " * " & "Extended: " & $ADOExtErr & " * " & "ADO Returned " & $ADO_RET_FAILURE & @CRLF & $Query & @CRLF)
        $ADOErr = 0
        $ADOExtErr = 0
    EndIf



    ConsoleWrite("$Query " & $Query & @CRLF)
    ConsoleWrite("$aQresult " & $aQresult & @CRLF)
    ConsoleWrite("$aResult " & $aResult & @CRLF)
    ConsoleWrite("$Qresult " & $Qresult & @CRLF)
#ce
EndFunc   ;==>_ADO_UST_online

Func _Get_Code($iN)
	Local $iCode = Cos($iN)
	If $iCode < 0 Then $iCode = -$iCode
	
	While $iCode<1000
		$iCode *= 10
	WEnd
	
	$iCode = Int($iCode)
	
	Return $iCode
EndFunc