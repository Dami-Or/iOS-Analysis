#include <AutoItConstants.au3>
#include <iTunes.au3>
#include <IE.au3>
#include<File.au3>
#include <WinAPIShPath.au3>

Stage1()

Func Stage1()
	Local $aCmdLine = _WinAPI_CommandLineToArgv($CmdLineRaw)
	Local $url = "itms://itunes.apple.com/us/app/id", $txt = ""
	;$txt="1027688889"
	$txt=$aCmdLine[1]
	$url_new=$url&$txt
	Local $oIE = _IECreate($url_new)
	Local $hWnd = WinWait("[CLASS:iexplore]", "", 10)
	Sleep(5000)
	WinActivate("[CLASS:iTunes]")
	Sleep(5000)
	ConsoleWrite("Before Itunes" )
	Sleep(11000)
	ControlClick("iTunes", "", "WebViewWindowClass1","left", 1,132,309)
	;I may have add code for password promts....but thats very annoyting since downloading each  app already takes like 30 sec min+why Itunes lets you disable authen.window for free apps;)
	;Msgbox(0,"", $url)
EndFunc



;#include <AutoItConstants.au3>
;#include <iTunes.au3>
;#include <IE.au3>
;#include<File.au3>
;Stage1()

;Func Stage1()
;	Local $aRetArray, $sFilePath = @ScriptDir & "\more_ids.txt"
;   _FileReadToArray($sFilePath, $aRetArray)
;_ArrayDisplay($aRetArray, "1D array - count", Default, 8)
;	Local $url = "itms://itunes.apple.com/us/app/id", $txt = ""
;	;For $i = 0 To UBound($aRetArray) - 1
;	For $i = 1 to 10
;		$txt=$aRetArray[$i]
;		$url_new=$url&$txt
;		Local $oIE = _IECreate($url_new)
;		Local $hWnd = WinWait("[CLASS:iexplore]", "", 10)
;		Sleep(2000)
;		WinActivate("[CLASS:iTunes]")
;		Sleep(2000)
;		ControlClick("iTunes", "", "WebViewWindowClass1","left", 1,151,309)
;		Sleep(2000)
;   Next
;    Msgbox(0,"", $txt)
;EndFunc
