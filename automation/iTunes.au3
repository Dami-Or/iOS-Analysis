#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; #INDEX# =======================================================================================================================
; Title .........: iTunes
; AutoIt Version : 3.3.0.0
; Language ......: English
; Description ...: This module contains various functions for scripting with iTunes.
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_iTunes_Start
;_iTunes_Quit
;_iTunes_GetCollections
;_iTunes_GetCurrent
;_iTunes_PlayerCommand
;_iTunes_PlayerState
;_iTunes_PlayerPosition
;_iTunes_SoundVolume
;_iTunes_Mute
;_iTunes_ConvertFiles
;_iTunes_ConvertTrack
;_iTunes_ConvertTracks
;_iTunes_ConvertGetStatus
;_iTunes_ConvertSetStatusCallback
;_iTunes_Source_GetProperties
;_iTunes_Playlist_GetProperties
;_iTunes_Playlist_SetProperty
;_iTunes_Playlist_Search
;_iTunes_Playlist_Print
;_iTunes_Playlist_Create
;_iTunes_Track_GetProperties
;_iTunes_Track_SetProperty
;_iTunes_Artwork_GetProperties
;_iTunes_Artwork_SavetoFile
;_iTunes_Artwork_SetAddfromFile
;_iTunes_EQ_Create
;_iTunes_EQ_Delete
;_iTunes_EQ_Rename
;_iTunes_EQ_GetProperties
;_iTunes_EQ_SetProperty
;_iTunes_Encoder_GetFormats
;_iTunes_Encoder_SetFormat
;_iTunes_ErrorHandlerRegister
;_iTunes_ErrorHandlerDeRegister
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;__iTunesInternalErrorHandlerRegister()
;__iTunesInternalErrorHandlerDeRegister()
;__InternalErrorHandler
;__IsObjType
;Event_OnConvertOperationStatusChangedEvent
;Event_OnConvertOperationCompleteEvent
; ===============================================================================================================================

#Region Decleare Variables
Global $s_iTunesUserErrorHandler, $o_iTunesErrorHandler, $_ErrorNotify = True
Global $ConvertEvent, $FunctiontoCall
Global _; Com Error Handler Status Strings
		$iComErrorNumber, _
		$iComErrorNumberHex, _
		$iComErrorDescription, _
		$iComErrorScriptline, _
		$iComErrorWinDescription, _
		$iComErrorSource, _
		$iComErrorHelpFile, _
		$iComErrorHelpContext, _
		$iComErrorLastDllError, _
		$iComErrorComObj, _
		$iComErrorOutput

Global Enum _; Error Status Types
		$iStatus_GeneralError = 1, _
		$iStatus_ComError, _;2
		$iStatus_InvalidDataType, _;3
		$iStatus_InvalidObjectType, _;4
		$iStatus_InvalidValue, _;5
		$iStatus_NoMatch, _;6
		$iStatus_FileExists;7
;
#EndRegion Decleare Variables
#Region Main

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Start
; Description ...: Creates a iTunes Object
; Syntax.........: _iTunes_Start()
; Parameters ....: None
; Return values .: Success - Object variable pointing to the top-level iTunes application object.
;                  Failure - 0, sets @error to 1.
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Start()

	Local $o_Object = ObjCreate("iTunes.Application")

	If Not @error Then Return $o_Object

	SetError($iStatus_GeneralError)
	Return 0

EndFunc   ;==>_iTunes_Start

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Quit
; Description ...: Exits the iTunes application and releases object variable from iTunes.Application
; Syntax.........: _iTunes_Quit(ByRef $o_Object)
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Quit(ByRef $o_Object)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($o_Object, 'Main') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	$o_Object.Quit
	$o_Object = 0

	Return 1
EndFunc   ;==>_iTunes_Quit

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_GetCollections
; Description ...: Retrieves an Array of iTunes collections
; Syntax.........: _iTunes_GetCollections(ByRef $o_Object, $iType = 0)
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
;                  $iType		- [optional] Number representing type of collection to get:
;                  |0 - Array containing all Collectins
;                  |1 - Sources
;                  |2 - Encoders
;                  |3 - EQPresents
;                  |4 - Visuals
;                  |5 - Windows
; Return values .: Success	- Collection object or Array of Collections:
;                  |[0] - Sources Collection
;                  |[1] - Encoders Collection
;                  |[2] - EQPresents Collection
;                  |[3] - Visuals Collection
;                  |[4] - Windows Collection
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |5 - Invalid Value
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_GetCollections(ByRef $o_Object, $iType = 0)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If $iType = 1 Then Return $o_Object.Sources
	If $iType = 2 Then Return $o_Object.Encoders
	If $iType = 3 Then Return $o_Object.EQPresets
	If $iType = 4 Then Return $o_Object.Visuals
	If $iType = 5 Then Return $o_Object.Windows

	If $iType = 0 Then
		Local $aCollections[5]
		$aCollections[0] = $o_Object.Sources
		$aCollections[1] = $o_Object.Encoders
		$aCollections[2] = $o_Object.EQPresets
		$aCollections[3] = $o_Object.Visuals
		$aCollections[4] = $o_Object.Windows
		Return $aCollections
	EndIf

	SetError($iStatus_InvalidValue)
	Return 0

EndFunc   ;==>_iTunes_GetCollections

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_GetCurrent
; Description ...: Retrieves a Current object
; Syntax.........: _iTunes_GetCurrent(ByRef $o_Object, $iType = 0)
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
;                  $iType		- [optional] Number representing type of collection to get:
;                  |0 - (Default) Array containing all Current objects
;                  |1 - Track
;                  |2 - Playlist
;                  |3 - EQPresent
;                  |4 - Visual
;                  |5 - Encoder
; Return values .: Success	- Current object or Array Current Objects:
;                  |[0] - Track object
;                  |[1] - Playlist object
;                  |[2] - EQPresent object
;                  |[3] - Visual object
;                  |[4] - Encoder object
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |5 - Invalid Value
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_GetCurrent(ByRef $o_Object, $iType = 0)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If $iType = 1 Then Return $o_Object.CurrentTrack
	If $iType = 2 Then Return $o_Object.CurrentPlaylist
	If $iType = 3 Then Return $o_Object.CurrentEQPreset
	If $iType = 4 Then Return $o_Object.CurrentVisual
	If $iType = 5 Then Return $o_Object.CurrentEncoder

	Local $aCurrent_Objects[5]
	If $iType = 0 Then
		$aCurrent_Objects[0] = $o_Object.CurrentTrack
		$aCurrent_Objects[1] = $o_Object.CurrentPlaylist
		$aCurrent_Objects[2] = $o_Object.CurrentEQPreset
		$aCurrent_Objects[3] = $o_Object.CurrentVisual
		$aCurrent_Objects[4] = $o_Object.CurrentEncoder
		Return $aCurrent_Objects
	EndIf

	SetError($iStatus_InvalidValue)
	Return 0

EndFunc   ;==>_iTunes_GetCurrent
#EndRegion Main

#Region Player Control Functions
; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_PlayerCommand
; Description ...: Sends player control command to iTunes.
; Syntax.........: _iTunes_PlayerCommand(ByRef $o_Object, $sCommand)
; Parameters ....: $o_Object      	- Object variable of a iTunes.Application
;                  $iCommand 		- Command to send:
;                  |0 - Play the currently targeted track.
;                  |1 - Pause playback
;                  |2 - Toggle the playing/paused state of the current track
;                  |3 - Stop playback
;                  |4 - Return to the previous track in the current playlist
;                  |5 - Reposition to the beginning of the current track or go to the previous track if already at start of current track
;                  |6 - Advance to the next track in the current playlist
;                  |7 - Skip forward in a playing track
;                  |8 - Skip backwards in a playing track
;                  |9 - Disable fast forward/rewind and resume playback, if playing.
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |5 - Invalid Value (iCommand)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_PlayerCommand(ByRef $o_Object, $iCommand)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($o_Object, 'Main') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Switch $iCommand
		Case 0
			$o_Object.Play
		Case 1
			$o_Object.Pause
		Case 2
			$o_Object.PlayPause
		Case 3
			$o_Object.Stop
		Case 4
			$o_Object.PreviousTrack
		Case 5
			$o_Object.BackTrack
		Case 6
			$o_Object.NextTrack
		Case 7
			$o_Object.FastFoward
		Case 8
			$o_Object.Rewind
		Case 9
			$o_Object.Resume
		Case Else
			SetError($iStatus_InvalidValue)
			Return 0
	EndSwitch

	Return 1

EndFunc   ;==>_iTunes_PlayerCommand

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_PlayerState
; Description ...: Returns the current player state
; Syntax.........: _iTunes_PlayerState(ByRef $o_Object)
; Parameters ....: $o_Object - Object variable of a iTunes.Application
; Return values .: Success - Returns integer representing player state:
;                  |0 - Stopped
;                  |1 - Playing
;                  |2 - Fast Fowarding
;                  |3 - Rewinding
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_PlayerState(ByRef $o_Object)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($o_Object, 'Main') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Return $o_Object.PlayerState

EndFunc   ;==>_iTunes_PlayerState

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_PlayerPosition
; Description ...: Returns or sets the player's position within the currently playing track in seconds
; Syntax.........: _iTunes_PlayerPosition(ByRef $o_Object[, $iPos = -1])
; Parameters ....: $o_Object    - Object variable of a iTunes.Application
;                  $iPos 		- [optional] If specified, sets the players position
; Return values .: Success - Returns or sets the player's position
;                  Failure - 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_PlayerPosition(ByRef $o_Object, $iPos = -1)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($o_Object, 'Main') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	If $iPos = -1 Then Return $o_Object.PlayerPosition
	$o_Object.PlayerPosition = $iPos

EndFunc   ;==>_iTunes_PlayerPosition

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_SoundVolume
; Description ...: Returns or sets the sound output volume.
; Syntax.........: _iTunes_SoundVolume(ByRef $o_Object[, $iVol_percent = -1])
; Parameters ....: $o_Object    - Object variable of a iTunes.Application
;                  $iVol 		- [optional] If specified, sets the sound output volume. Values can be 0-100.
; Return values .: Success	- Returns or sets the sound output volume
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |5 - Invalid Value (iVol)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_SoundVolume(ByRef $o_Object, $iVol = -1)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($o_Object, 'Main') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	If $iVol = -1 Then Return $o_Object.SoundVolume

	If $iVol < 0 Or $iVol > 100 Then
		SetError($iStatus_InvalidValue)
		Return 0
	EndIf

	$o_Object.SoundVolume = $iVol

EndFunc   ;==>_iTunes_SoundVolume

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Mute
; Description ...: Returns or sets sound output mute state.
; Syntax.........: _iTunes_Mute(ByRef $o_Object, [$iMute = -1])
; Parameters ....: $o_Object    - Object variable of a iTunes.Application
;                  $iMute 		- [optional] If specified, sets the sound output mute state.
;                  |-1 	- (Default) Returns sound output mute state. -1 = Muted, 0 = Not Muted.
;                  |0 	- Sets mute state to not muted.
;                  |1 	- Sets mute state to muted.
; Return values .: Success	- 1 or Returns the sound output mute state
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |5 - Invalid Value (iMute can be 0 or 1)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Mute(ByRef $o_Object, $iMute = -1)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($o_Object, 'Main') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	If $iMute = -1 Then Return $o_Object.Mute

	If $iMute <> 0 And $iMute <> 1 Then
		SetError($iStatus_InvalidValue)
		Return 0
	EndIf

	$o_Object.Mute = $iMute
	Return 1

EndFunc   ;==>_iTunes_Mute

#EndRegion Player Control Functions

#Region Convert Functins
; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_ConvertFiles
; Description ...: Converts the files and/or folders specified in an array.
; Syntax.........: _iTunes_ConvertFiles(ByRef $o_Object, $aFilePaths[, $iCheckPaths = 1])
; Parameters ....: $o_Object - Object variable of a iTunes.Application
;                  $aFilePaths - Array containing filepaths
;                  $iCheckPaths - [optional] If set to 0, function will not verify that files in array exist.
; Return values .: Success	- Returns a ConvertOperationStatus object corresponding to the asynchronous operation.
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type ($aFilePaths is not an array)
;                  |7 - One of the files speecified in the array does not exist.
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......: _iTunes_ConvertGetStatus, _iTunes_SetConvertStatusCallback
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_ConvertFiles(ByRef $o_Object, $aFilePaths, $iCheckPaths = 1)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not IsArray($aFilePaths) Then
		SetError($iStatus_InvalidValue)
		Return 0
	EndIf

	If $iCheckPaths Then
		For $i = 0 To UBound($aFilePaths) - 1
			If Not FileExists($aFilePaths[$i]) Then
				SetError($iStatus_FileExists)
				Return 0
			EndIf
		Next
	EndIf

	Return $o_Object.ConvertFiles2($aFilePaths)

EndFunc   ;==>_iTunes_ConvertFiles

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_ConvertTrack
; Description ...:	Converts the specifed Track
; Syntax.........: _iTunes_ConvertTrack(ByRef $o_Object, $oTrack)
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
;                  $oTrack - Track Object
; Return values .: Success	- Returns an IITConvertOperationStatus object corresponding to the asynchronous operation.
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......: _iTunes_ConvertGetStatus, _iTunes_SetConvertStatusCallback
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_ConvertTrack(ByRef $o_Object, $oTrack)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oTrack, "Track") Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Return $o_Object.ConvertTrack2($oTrack)

EndFunc   ;==>_iTunes_ConvertTrack

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_ConvertTracks
; Description ...:	Converts Tracks specifed in Track Collection
; Syntax.........: _iTunes_ConvertTracks(ByRef $o_Object, $ocTracks)
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
;                  $ocTrack - Track Collection
; Return values .: Success	- Returns an IITConvertOperationStatus object corresponding to the asynchronous operation.
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type ($ocTracks)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......: _iTunes_ConvertGetStatus, _iTunes_SetConvertStatusCallback
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_ConvertTracks(ByRef $o_Object, $ocTracks)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not ObjName($ocTracks) = 'IITTrackCollection' Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Return $o_Object.ConvertTracks2($ocTracks)

EndFunc   ;==>_iTunes_ConvertTracks

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_ConvertGetStatus
; Description ...: Retrieve the status of a conversion.
; Syntax.........: _iTunes_ConvertGetStatus(ByRef $oStatus)
; Parameters ....: $oStatus	- IITConvertOperationStatus object variable
; Return values .: Success	- Array
;                  |[0] - Track Name
;                  |[1] - Progress Value
;                  |[2] - Max Progress Value
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($oStatus is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......: _iTunes_ConvertTracks, _iTunes_ConvertTrack, _iTunes_ConvertFiles
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _iTunes_ConvertGetStatus(ByRef $oStatus)
	If Not IsObj($oStatus) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not ObjName($oStatus) = 'IITConvertOperationStatus' Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Return StringSplit($oStatus.TrackName & '|' & $oStatus.ProgressValue & '|' & $oStatus.MaxProgressValue, '|', 2)

EndFunc   ;==>_iTunes_ConvertGetStatus

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_ConvertSetStatusCallback
; Description ...: Sets function to call as progress is made durning conversions.
; Syntax.........: _iTunes_ConvertSetStatusCallback(ByRef $oStatus, $sFunctiontoCall)
; Parameters ....: $oStatus			- IITConvertOperationStatus object variable
;                  $sFunctiontoCall - Name of Function to Call
; Return values .: Success	- 1
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($oStatus is not a object)
;                  |4 - Invalid Object type
;                  |5 - Function not specified
; Author ........: Beege
; Modified.......:
; Remarks .......: The status event will send 3 values to your function: TrackName, ProgressValue and MaxprogressValue. When finished it will send a -1.
; Related .......: _iTunes_ConvertTracks, _iTunes_ConvertTrack, _iTunes_ConvertFiles
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================

Func _iTunes_ConvertSetStatusCallback(ByRef $oStatus, $sFunctiontoCall)
	If Not IsObj($oStatus) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not ObjName($oStatus) = 'IITConvertOperationStatus' Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	If Not $sFunctiontoCall Then
		SetError($iStatus_InvalidValue)
		Return 0
	EndIf

	$ConvertEvent = ObjEvent($oStatus, 'Event_', '_IITConvertOperationStatusEvents')
	$FunctiontoCall = $sFunctiontoCall
	Return 1

EndFunc   ;==>_iTunes_ConvertSetStatusCallback
#EndRegion Convert Functins

#Region Source Functions
; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Source_GetProperties
; Description ...: Retrives properties of a Source object
; Syntax.........: _iTunes_Source_GetProperties(ByRef $oSource)
; Parameters ....: $oSource	- Source object
; Return values .: Success	- Array
;                  |[0] - Kind (0=Unknown, 1=Library, 2=iPod, 3=Audio CD, 4=MP3 CD, 5=Device, 6=Radio Tuner, 7=Shared Library)
;                  |[1] - Capacity
;                  |[2] - FreeSpace
;                  |[3] - Playlist Collection
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type ($aFilePaths is not an array)
;                  |5 - Invalid Value
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Source_GetProperties(ByRef $oSource)
	If Not IsObj($oSource) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oSource, 'Source') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Local $aProperties[4]
	$aProperties[0] = $oSource.Kind
	$aProperties[1] = $oSource.Capacity
	$aProperties[2] = $oSource.FreeSpace
	$aProperties[3] = $oSource.Playlists; collection object
	Return $aProperties

EndFunc   ;==>_iTunes_Source_GetProperties

#EndRegion Source Functions
#Region Playlist Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Playlist_GetProperties
; Description ...: Retrives properties of a playlist object
; Syntax.........: _iTunes_Playlist_GetProperties(ByRef $oPlaylist)
; Parameters ....: $oPlaylist - Playlist object
; Return values .: Success	- Array
;                  |[0] - Kind (0=Unknown, 1=Library, 2=User, 3=CD, 4=Device, 5=Radio Tuner)
;                  |[1] - Source (object corresponding to the source that contains the playlist)
;                  |[2] - Duration (total length of all songs in the playlist in seconds)
;                  |[3] - Shuffle (-1 if songs in the playlist are played in random order)
;                  |[4] - Size (total size of all songs in the playlist in bytes)
;                  |[5] - SongRepeat (playback repeat mode)
;                  |[6] - Time (total length of all songs in the playlist in MM:SS format)
;                  |[7] - Visible (-1 if the playlist is visible in the Source list)
;                  |[8] - Track Collection
;                  |If Playlist Kind is CD:
;                  |[9] - Artist
;                  |[10] - Compilation
;                  |[11] - Composer
;                  |[12] - Disc Count
;                  |[13] - Disc Number
;                  |[14] - Genre
;                  |[15] - Year
;                  |If Playlist Kind is User:
;                  |[9] - Shared (-1 if this playlist is shared)
;                  |[10] - Smart (-1 if this playlist is a smart playlist)
;                  |[11] - SpecialKind (0=Not Special, 1=Purchased, 2=Party Shuffle, 3=Podcasts, 4=Folder, 5=Videos, 6=Music, 7=Movies, 8=TV Shows, 9=Audiobooks)
;                  |[12] - Parent (UserPlaylist object corresponding to the parent folder)
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type ($aFilePaths is not an array)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Playlist_GetProperties(ByRef $oPlaylist)
	If Not IsObj($oPlaylist) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oPlaylist, 'Playlist') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Local $aProperties[9]
	$aProperties[0] = $oPlaylist.Kind
	$aProperties[1] = $oPlaylist.Source;object
	$aProperties[2] = $oPlaylist.Duration
	$aProperties[3] = $oPlaylist.Shuffle
	$aProperties[4] = $oPlaylist.Size
	$aProperties[5] = $oPlaylist.SongRepeat
	$aProperties[6] = $oPlaylist.Time
	$aProperties[7] = $oPlaylist.Visible
	$aProperties[8] = $oPlaylist.Tracks;trackcollection

	If $aProperties[0] = 3 Then
		ReDim $aProperties[16]
		$aProperties[9] = $oPlaylist.Artist
		$aProperties[10] = $oPlaylist.Compilation
		$aProperties[11] = $oPlaylist.Composer
		$aProperties[12] = $oPlaylist.DiscCount
		$aProperties[13] = $oPlaylist.DiscNumber
		$aProperties[14] = $oPlaylist.Genre
		$aProperties[15] = $oPlaylist.Year
		Return $aProperties
	EndIf

	If $aProperties[0] = 2 Then
		ReDim $aProperties[13]
		$aProperties[9] = $oPlaylist.Shared
		$aProperties[10] = $oPlaylist.Smart
		$aProperties[11] = $oPlaylist.SpecialKind
		$aProperties[12] = $oPlaylist.Parent ;userplaylist object
	EndIf

	Return $aProperties

EndFunc   ;==>_iTunes_Playlist_GetProperties

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Playlist_SetProperty
; Description ...: Sets a property of a playlist.
; Syntax.........: _iTunes_Playlist_SetProperty(ByRef $oPlaylist, $sProperty, $iNewValue)
; Parameters ....: $oPlaylist      	- Playlist Object
;                  $iProperty 		- Property to Set:
;                  |0 - Shuffle
;                  |1 - SongRepeat
;                  |2 - Shared
;                  |3 - Parent
;                  $iNewValue 		- New Value for Property
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |5 - Invalid Value (iCommand)
; Author ........: Beege
; Modified.......:
; Remarks .......: If setting Parent Property, $newvalue must be a UserPlaylist Object. $newvalue should be a 0 or 1 for the rest.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Playlist_SetProperty(ByRef $oPlaylist, $iProperty, $iNewValue)
	If Not IsObj($oPlaylist) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oPlaylist, 'Playlist') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	__iTunesInternalErrorHandlerRegister()
	Select
		Case $iProperty = 0;'Shuffle'
			$oPlaylist.Shuffle = $iNewValue
		Case $iProperty = 1;'SongRepeat'
			$oPlaylist.SongRepeat = $iNewValue
	EndSelect

	Local $iKind = $oPlaylist.Kind
	If $iKind = 2 Then
		Select
			Case $iProperty = 2;'Shared'
				$oPlaylist.Shared = $iNewValue
			Case $iProperty = 3;'Parent'
				$oPlaylist.Parent = $iNewValue
		EndSelect
	EndIf
	__iTunesInternalErrorHandlerDeRegister()

	Return 1

EndFunc   ;==>_iTunes_Playlist_SetProperty

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Playlist_Search
; Description ...: Search a playlist
; Syntax.........: _iTunes_Playlist_Search(ByRef $oPlaylist, $sSearch[, $iFields = 0])
; Parameters ....: $oPlaylist      	- Playlist Object
;                  $sSearch 		- Text to search for
;                  $iFields 		- [optional] Field to search in:
;                  |0 - (Default) All
;                  |1 - Only the fields with columns that are currently visible in the display for the playlist.
;                  |2 - artist
;                  |3 - album
;                  |4 - composer
;                  |5 - song name
; Return values .: Success - Track collection containing the tracks with the specified text.
;                  Failure - 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......: If setting Parent Property, $newvalue must be a UserPlaylist Object. $newvalue should be a 0 or 1 for the rest.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Playlist_Search(ByRef $oPlaylist, $sSearch, $iFields = 0)
	If Not IsObj($oPlaylist) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oPlaylist, 'Playlist') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Return $oPlaylist.Search($sSearch, $iFields)

EndFunc   ;==>_iTunes_Playlist_Search

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Playlist_Print
; Description ...: Print a Playlist
; Syntax.........: _iTunes_Playlist_Print(ByRef $oPlaylist[, $iKind = 1[, $iTheme = 1[, $bDialog = 1]]])
; Parameters ....: $iKind      	- [optional] Kind of Printout (0=List of Tracks, 1=List of Albums, 2=Cd jewel Case Insert)
;                  $sTheme 		- [optional] The name of the theme to use
;                  $bDialog 	- [optional] Show or Hide Dialog
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......: Theme string cannot be longer than 255 characters
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Playlist_Print(ByRef $oPlaylist, $iKind = 1, $iTheme = 1, $bDialog = 1)
	If Not IsObj($oPlaylist) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oPlaylist, 'Playlist') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	__iTunesInternalErrorHandlerRegister()
	$oPlaylist.Print($bDialog, $iKind, $iTheme)
	__iTunesInternalErrorHandlerDeRegister()

	Return 1

EndFunc   ;==>_iTunes_Playlist_Print

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Playlist_Create
; Description ...: Create a new playlist
; Syntax.........: _iTunes_Playlist_Create(ByRef $o_Object, $sName[, $iFolder = 0])
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
;                  $sName 		- The name of the playlist
;                  $iFolder 	- [optional] If set to 1 creates a Folder type playlist
; Return values .: Success - 1
;                  Failure - 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Playlist_Create(ByRef $o_Object, $sName, $iFolder = 0)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not $iFolder Then Return $o_Object.CreatePlaylist($sName)
	Return $o_Object.CreateFolder($sName)

EndFunc   ;==>_iTunes_Playlist_Create

#EndRegion Playlist Functions

#Region Track Functions
; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Track_GetProperties
; Description ...: Retrives properties of a Track object
; Syntax.........: _iTunes_Track_GetProperties(ByRef $oTrack)
; Parameters ....: $oTrack - Track object
; Return values .: Success	- Array
;                  |For all kinds of Tracks:
;                  |     [0] - Name
;                  |     [1] - Kind (0=Unknown, 1=File, 2=CD, 3=URL, 4=Device, 5=Shared Library)
;                  |     [2] - Playlist (object corresponding to the playlist that contains the track)
;                  |     [3] - Album
;                  |     [4] - Artist
;                  |     [5] - BitRate
;                  |     [6] - BPM
;                  |     [7] - Comment
;                  |     [8] - Compilation (-1 if this track is from a compilation album)
;                  |     [9] - Composer
;                  |     [10] - DateAdded
;                  |     [11] - DiscCount
;                  |     [12] - DiscNumber
;                  |     [13] - Duration
;                  |     [14] - Enabled
;                  |     [15] - EQ (name of the EQ preset of the track)
;                  |     [16] - Finish (stop time of the track in seconds)
;                  |     [17] - Genre
;                  |     [18] - Grouping
;                  |     [19] - KindAsString (Ex:MP3,Wave,AAC)
;                  |     [20] - ModificationDate
;                  |     [21] - PlayedCount
;                  |     [22] - PlayedDate
;                  |     [23] - PlayOrderIndex
;                  |     [24] - Rating
;                  |     [25] - SampleRate (Hz)
;                  |     [26] - Size (bytes)
;                  |     [27] - Start (start time of the track in seconds)
;                  |     [28] - Time (length of the track in MM:SS format)
;                  |     [29] - TrackCount
;                  |     [30] - TrackNumber
;                  |     [31] - VolumeAdjustment
;                  |     [32] - Year
;                  |     [33] - Artwork  (collection containing the artwork for the track)
;                  |If Track Kind is File, CD, or URL:
;                  |     [34] - Category
;                  |     [35] - Description
;                  |     [36] - LongDescription
;                  |     [37] - Podcast (-1 if this track is a podcast track)
;                  |     [38] - AlbumRating
;                  |     [39] - AlbumRatingKind (0=User-specified, 1=iTunes-computed)
;                  |     [40] - RatingKind (0=User-specified, 1=iTunes-computed)
;                  |     [41] - Playlists (collection of playlists that contain the song that this track represents)
;                  |If Track Kind is URL
;                  |     [42] - URL
;                  |;Track Kind is File or CD
;                  |     [42] - Location
;                  |     [36] - RememberBookmark
;                  |     [37] - ExcludeFromShuffle
;                  |     [38] - Lyrics
;                  |     [42] - BookmarkTime
;                  |     [43] - VideoKind
;                  |     [44] - SkippedCount
;                  |     [45] - SkippedDate
;                  |     [46] - PartOfGaplessAlbum
;                  |     [47] - AlbumArtist
;                  |     [48] - Show
;                  |     [49] - SeasonNumber
;                  |     [50] - EpisodeID
;                  |     [51] - EpisodeNumber
;                  |     [52] - Size64High
;                  |     [53] - Size64Low
;                  |     [54] - Unplayed
;                  |     [55] - SortAlbum
;                  |     [56] - SortAlbumArtist
;                  |     [57] - SortArtist
;                  |     [58] - SortComposer
;                  |     [59] - SortName
;                  |     [60] - SortShow
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($oTrack is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Track_GetProperties(ByRef $oTrack)
	If Not IsObj($oTrack) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oTrack, 'Track') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	Local $aProperties[34]
	$aProperties[0] = $oTrack.Name
	$aProperties[1] = $oTrack.Kind
	$aProperties[2] = $oTrack.Playlist; Object
	$aProperties[3] = $oTrack.Album
	$aProperties[4] = $oTrack.Artist
	$aProperties[5] = $oTrack.BitRate
	$aProperties[6] = $oTrack.BPM
	$aProperties[7] = $oTrack.Comment
	$aProperties[8] = $oTrack.Compilation
	$aProperties[9] = $oTrack.Composer
	$aProperties[10] = $oTrack.DateAdded
	$aProperties[11] = $oTrack.DiscCount
	$aProperties[12] = $oTrack.DiscNumber
	$aProperties[13] = $oTrack.Duration
	$aProperties[14] = $oTrack.Enabled
	$aProperties[15] = $oTrack.EQ
	$aProperties[16] = $oTrack.Finish
	$aProperties[17] = $oTrack.Genre
	$aProperties[18] = $oTrack.Grouping
	$aProperties[19] = $oTrack.KindAsString
	$aProperties[20] = $oTrack.ModificationDate
	$aProperties[21] = $oTrack.PlayedCount
	$aProperties[22] = $oTrack.PlayedDate
	$aProperties[23] = $oTrack.PlayOrderIndex
	$aProperties[24] = $oTrack.Rating
	$aProperties[25] = $oTrack.SampleRate
	$aProperties[26] = $oTrack.Size
	$aProperties[27] = $oTrack.Start
	$aProperties[28] = $oTrack.Time
	$aProperties[29] = $oTrack.TrackCount
	$aProperties[30] = $oTrack.TrackNumber
	$aProperties[31] = $oTrack.VolumeAdjustment
	$aProperties[32] = $oTrack.Year
	$aProperties[33] = $oTrack.Artwork ; Artwork Collection

	If $aProperties[1] = 0 Or $aProperties[1] = 4 Or $aProperties[1] = 5 Then Return $aProperties ;Track Kind is Device track, Shared library track, Or Uknown

	ReDim $aProperties[43] ;Track Kind is File or CD or URL
	$aProperties[34] = $oTrack.Category
	$aProperties[35] = $oTrack.Description
	$aProperties[36] = $oTrack.LongDescription
	$aProperties[37] = $oTrack.Podcast
	$aProperties[38] = $oTrack.AlbumRating
	$aProperties[39] = $oTrack.AlbumRatingKind
	$aProperties[40] = $oTrack.RatingKind
	$aProperties[41] = $oTrack.Playlists

	If $aProperties[1] = 3 Then ;Track Kind is URL
		$aProperties[42] = $oTrack.URL
		Return $aProperties
	EndIf

	ReDim $aProperties[61];Track Kind is File or CD
	$aProperties[42] = $oTrack.Location
	$aProperties[36] = $oTrack.RememberBookmark
	$aProperties[37] = $oTrack.ExcludeFromShuffle
	$aProperties[38] = $oTrack.Lyrics
	$aProperties[42] = $oTrack.BookmarkTime
	$aProperties[43] = $oTrack.VideoKind
	$aProperties[44] = $oTrack.SkippedCount
	$aProperties[45] = $oTrack.SkippedDate
	$aProperties[46] = $oTrack.PartOfGaplessAlbum
	$aProperties[47] = $oTrack.AlbumArtist
	$aProperties[48] = $oTrack.Show
	$aProperties[49] = $oTrack.SeasonNumber
	$aProperties[50] = $oTrack.EpisodeID
	$aProperties[51] = $oTrack.EpisodeNumber
	$aProperties[52] = $oTrack.Size64High
	$aProperties[53] = $oTrack.Size64Low
	$aProperties[54] = $oTrack.Unplayed
	$aProperties[55] = $oTrack.SortAlbum
	$aProperties[56] = $oTrack.SortAlbumArtist
	$aProperties[57] = $oTrack.SortArtist
	$aProperties[58] = $oTrack.SortComposer
	$aProperties[59] = $oTrack.SortName
	$aProperties[60] = $oTrack.SortShow

	Return $aProperties

EndFunc   ;==>_iTunes_Track_GetProperties

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Track_SetProperty
; Description ...: Sets the property of a Track object
; Syntax.........: _iTunes_Track_SetProperty(ByRef $oTrack, $iProperty, $iNewValue)
; Parameters ....: $oTrack - Track object
;                  $iProperty - Number representing track property:
;                  |For all kinds of Tracks:
;                  |      1 - Name
;                  |      2 - Album
;                  |      3 - Artist
;                  |      4 - Comment
;                  |      5 - Compilation (-1 if this track is from a compilation album)
;                  |      6 - Composer
;                  |      7 - DateAdded
;                  |      8 - DiscCount
;                  |      9 - DiscNumber
;                  |      10 - Enabled
;                  |      11 - EQ (name of the EQ preset of the track)
;                  |      12 - Finish (stop time of the track in seconds)
;                  |      13 - Genre
;                  |      14 - Grouping
;                  |      15 - PlayedCount
;                  |      16 - PlayedDate
;                  |      17 - Rating
;                  |      18 - Start (start time of the track in seconds)
;                  |      19 - TrackCount
;                  |      20 - TrackNumber
;                  |      21 - VolumeAdjustment
;                  |      22 - Year
;                  |If Track Kind URL:
;                  |      23 - URL
;                  |If Track Kind is File, CD, or URL:
;                  |      24 - AlbumRating
;                  |      25 - RememberBookmark
;                  |      26 - ExcludeFromShuffle
;                  |      27 - Lyrics
;                  |      28 - Category
;                  |      29 - Description
;                  |      30 - LongDescription
;                  |      31 - BookmarkTime
;                  |      32 - VideoKind
;                  |      33 - SkippedCount
;                  |      34 - SkippedDate
;                  |      35 - PartOfGaplessAlbum
;                  |      36 - AlbumArtist
;                  |      37 - Show
;                  |      38 - SeasonNumber
;                  |      39 - EpisodeID
;                  |      40 - EpisodeNumber
;                  |      41 - Unplayed
;                  |      42 - SortAlbum
;                  |      43 - SortAlbumArtist
;                  |      44 - SortArtist
;                  |      45 - SortComposer
;                  |      46 - SortName
;                  |      47 - SortShow
;                  |      48 - AlbumRating
;                  $iNewValue - New value to set property to.
; Return values .: Success	- Array
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($oTrack is not a object)
;                  |4 - Invalid Object type
;                  |4 - Invalid Value ($iProperty)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Track_SetProperty(ByRef $oTrack, $iProperty, $iNewValue)
	If Not IsObj($oTrack) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oTrack, 'Track') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf
	__iTunesInternalErrorHandlerRegister()

	Local $iKind = $oTrack.Kind
	Select
		Case $iProperty = 1;'Name'
			$oTrack.Name = $iNewValue
		Case $iProperty = 2;'Album'
			$oTrack.Album = $iNewValue
		Case $iProperty = 3;'Artist'
			$oTrack.Artist = $iNewValue
		Case $iProperty = 4;'Comment'
			$oTrack.Comment = $iNewValue
		Case $iProperty = 5;'Compilation'
			$oTrack.Compilation = $iNewValue
		Case $iProperty = 6;'Composer'
			$oTrack.Composer = $iNewValue
		Case $iProperty = 7;'DateAdded'
			$oTrack.DateAdded = $iNewValue
		Case $iProperty = 8;'DiscCount'
			$oTrack.DiscCount = $iNewValue
		Case $iProperty = 9;'DiscNumber'
			$oTrack.DiscNumber = $iNewValue
		Case $iProperty = 10;'Enabled'
			$oTrack.Enabled = $iNewValue
		Case $iProperty = 11;'EQ'
			$oTrack.EQ = $iNewValue
		Case $iProperty = 12;'Finish'
			$oTrack.Finish = $iNewValue
		Case $iProperty = 13;'Genre'
			$oTrack.Genre = $iNewValue
		Case $iProperty = 14;'Grouping'
			$oTrack.Grouping = $iNewValue
		Case $iProperty = 15;'PlayedCount'
			$oTrack.PlayedCount = $iNewValue
		Case $iProperty = 16;'PlayedDate'
			$oTrack.PlayedDate = $iNewValue
		Case $iProperty = 17;'Rating'
			$oTrack.Rating = $iNewValue
		Case $iProperty = 18;'Start'
			$oTrack.Start = $iNewValue
		Case $iProperty = 19;'TrackCount'
			$oTrack.TrackCount = $iNewValue
		Case $iProperty = 20;'TrackNumber'
			$oTrack.TrackNumber = $iNewValue
		Case $iProperty = 21;'VolumeAdjustment'
			$oTrack.VolumeAdjustment = $iNewValue
		Case $iProperty = 22;'Year'
			$oTrack.Year = $iNewValue
		Case $iProperty = 23;'URL'
			If $iKind <> 3 Then
				SetError($iStatus_InvalidObjectType)
				Return 0
			EndIf
			$oTrack.URL = $iNewValue
	EndSelect

	If $iKind = 0 Or $iKind = 4 Or $iKind = 5 Then
		__iTunesInternalErrorHandlerDeRegister()
		If $iProperty > 23 Then
			SetError($iStatus_InvalidValue)
			Return 0
		Else
			Return 1
		EndIf
	EndIf

	Select
		Case $iProperty = 24;'AlbumRating'
			$oTrack.AlbumRating = $iNewValue
		Case $iProperty = 25;'RememberBookmark'
			$oTrack.RememberBookmark = $iNewValue
		Case $iProperty = 26;'ExcludeFromShuffle'
			$oTrack.ExcludeFromShuffle = $iNewValue
		Case $iProperty = 27;'Lyrics'
			$oTrack.Lyrics = $iNewValue
		Case $iProperty = 28;'Category'
			$oTrack.Category = $iNewValue
		Case $iProperty = 29;'Description'
			$oTrack.Description = $iNewValue
		Case $iProperty = 30;'LongDescription'
			$oTrack.LongDescription = $iNewValue
		Case $iProperty = 31;'BookmarkTime'
			$oTrack.BookmarkTime = $iNewValue
		Case $iProperty = 32;'VideoKind'
			$oTrack.VideoKind = $iNewValue
		Case $iProperty = 33;'SkippedCount'
			$oTrack.SkippedCount = $iNewValue
		Case $iProperty = 34;'SkippedDate'
			$oTrack.SkippedDate = $iNewValue
		Case $iProperty = 35;'PartOfGaplessAlbum'
			$oTrack.PartOfGaplessAlbum = $iNewValue
		Case $iProperty = 36;'AlbumArtist'
			$oTrack.AlbumArtist = $iNewValue
		Case $iProperty = 37;'Show'
			$oTrack.Show = $iNewValue
		Case $iProperty = 38;'SeasonNumber'
			$oTrack.SeasonNumber = $iNewValue
		Case $iProperty = 39;'EpisodeID'
			$oTrack.EpisodeID = $iNewValue
		Case $iProperty = 40;'EpisodeNumber'
			$oTrack.EpisodeNumber = $iNewValue
		Case $iProperty = 41;'Unplayed'
			$oTrack.Unplayed = $iNewValue
		Case $iProperty = 42;'SortAlbum'
			$oTrack.SortAlbum = $iNewValue
		Case $iProperty = 43;'SortAlbumArtist'
			$oTrack.SortAlbumArtist = $iNewValue
		Case $iProperty = 44;'SortArtist'
			$oTrack.SortArtist = $iNewValue
		Case $iProperty = 45;'SortComposer'
			$oTrack.SortComposer = $iNewValue
		Case $iProperty = 46;'SortName'
			$oTrack.SortName = $iNewValue
		Case $iProperty = 47;'SortShow'
			$oTrack.SortShow = $iNewValue
		Case $iProperty = 48;'AlbumRating'
			$oTrack.AlbumRating = $iNewValue
		Case Else ;user entered invalid value
			__iTunesInternalErrorHandlerDeRegister()
			SetError($iStatus_InvalidValue)
			Return 0
	EndSelect
	__iTunesInternalErrorHandlerDeRegister()

	Return 1

EndFunc   ;==>_iTunes_Track_SetProperty
#EndRegion Track Functions

#Region Artwork Functions
; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Artwork_GetProperties
; Description ...: Retrives properties of an artwork object
; Syntax.........: _iTunes_Artwork_GetProperties(ByRef $oTrackorArtwork)
; Parameters ....: $oTrackorArtwork	- Track or Artwork object
; Return values .: Success	- Array
;                  |   [0] - Format (0=Unknown, 1=JPEG, 2=PNG, 3=BMP)
;                  |   [1] - IsDownloadedArtwork (-1 if the artwork was downloaded by iTunes)
;                  |   [2] - Description (Artwork descriptions are only supported in files that use ID3 tags)
;                  |If $oTrackorArtwork is a Track object:
;                  |   [3] - Artwork Object of the track
;                  Failure	- 0, sets @error to:
;                  |1 - No Artwork Avalible
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......: If variable is Track object and has more than one artwork image, the main image is selected.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Artwork_GetProperties(ByRef $oTrackorArtwork)
	If Not IsObj($oTrackorArtwork) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	Local $aProperties[3], $oArtwork
	Select
		Case __IsObjType($oTrackorArtwork, 'Track')
			If $oTrackorArtwork.Artwork.Count = 0 Then
				SetError(1);Track has no artwork
				Return 0
			EndIf
			ReDim $aProperties[4]
			$oArtwork = $oTrackorArtwork.Artwork.Item(1)
			$aProperties[3] = $oArtwork
		Case ObjName($oTrackorArtwork) = 'IITArtwork'
			$oArtwork = $oTrackorArtwork
		Case Else
			SetError($iStatus_InvalidObjectType)
			Return 0
	EndSelect

	$aProperties[0] = $oArtwork.Format
	$aProperties[1] = $oArtwork.IsDownloadedArtwork
	$aProperties[2] = $oArtwork.Description

	Return $aProperties

EndFunc   ;==>_iTunes_Artwork_GetProperties

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Artwork_SavetoFile
; Description ...: Save artwork data to an image file
; Syntax.........: _iTunes_Artwork_SavetoFile(ByRef $oTrackorArtwork, $sFilePath)
; Parameters ....: $oTrackorArtwork	- Track or Artwork object
;                  $sFilePath - The Path and FileName to save image to.
; Return values .: Success	- 1
;                  Failure	- 0, sets @error to:
;                  |1 - No Artwork Avalible
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Artwork_SavetoFile(ByRef $oTrackorArtwork, $sFilePath)
	If Not IsObj($oTrackorArtwork) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oTrackorArtwork, 'Track') And ObjName($oTrackorArtwork) <> 'IITArtwork' Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	If __IsObjType($oTrackorArtwork, 'Track') Then
		If $oTrackorArtwork.Artwork.Count = 0 Then
			SetError(1);Track has no artwork
			Return 0
		EndIf

		$oTrackorArtwork.Artwork.Item(1).SaveArtworkToFile($sFilePath)
	Else
		$oTrackorArtwork.SaveArtworkToFile($sFilePath)
	EndIf

	Return 1

EndFunc   ;==>_iTunes_Artwork_SavetoFile

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Artwork_SetAddfromFile
; Description ...: Sets or Adds artwork data of a Track object
; Syntax.........: _iTunes_Artwork_SetAddfromFile(ByRef $oTrack, $sFilePath[, $iSetorAdd = 0])
; Parameters ....: $oTrack	- Track object
;                  $sFilePath - The Path and FileName to save image to.
;                  $iSetorAdd - [optional] If set to 1 the existing artwork data will be replaced.
; Return values .: Success	- 1 or a Artwork object if $iSetorAdd is set to 1.
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Artwork_SetAddfromFile(ByRef $oTrack, $sFilePath, $iSetorAdd = 0)
	If Not IsObj($oTrack) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If Not __IsObjType($oTrack, 'Track') Then
		SetError($iStatus_InvalidObjectType)
		Return 0
	EndIf

	If Not FileExists($sFilePath) Then
		SetError($iStatus_FileExists)
		Return 0
	EndIf
	__iTunesInternalErrorHandlerRegister()
	If Not $iSetorAdd Then
		$oTrack.Artwork.Item(1).SetArtworkFromFile($sFilePath)
		__iTunesInternalErrorHandlerDeRegister()
		Return 1
	Else
		__iTunesInternalErrorHandlerDeRegister()
		Return $oTrack.AddArtworkFromFile($sFilePath)
	EndIf

EndFunc   ;==>_iTunes_Artwork_SetAddfromFile

#EndRegion Artwork Functions
#Region EQ Present Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_EQ_Create
; Description ...: Creates a new EQ Present
; Syntax.........: _iTunes_EQ_Create(ByRef $o_Object, $sName)
; Parameters ....: $o_Object	- Source object
;                  $sName		- Name of Present
; Return values .: Success	- EQ Object
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_EQ_Create(ByRef $o_Object, $sName)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	Return $o_Object.CreateEQPreset($sName)

EndFunc   ;==>_iTunes_EQ_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_EQ_Delete
; Description ...: Deletes an EQ Present
; Syntax.........: _iTunes_EQ_Delete(ByRef $o_Object, [$sName = 0[, $iUpdateAllTracks = 1]])
; Parameters ....: $o_Object	- Object variable of a iTunes.Application or EQ object
;                  $sName		- [optional] Name of Present
;                  $iUpdateAllTracks	- [optional] If Set to 0, Tracks using this present will NOT be updated.
; Return values .: Success	- 1
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |5 - Invalid Value
; Author ........: Beege
; Modified.......:
; Remarks .......: If $o_Object is not a EQ object, $sName must be specified.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_EQ_Delete(ByRef $o_Object, $sName = 0, $iUpdateAllTracks = 1)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	Local $oPresent
	If ObjName($o_Object) = 'IITEQPreset' Then
		$oPresent = $o_Object
	Else
		If Not $sName Then; possible problem if name is 0..
			SetError($iStatus_InvalidValue)
			Return 0
		EndIf
		$oPresent = $o_Object.EQPresets.ItemByName($sName)
		If Not IsObj($oPresent) Then
			SetError($iStatus_NoMatch)
			Return 0
		EndIf
	EndIf

	$oPresent.Delete($iUpdateAllTracks)

	Return 1

EndFunc   ;==>_iTunes_EQ_Delete

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_EQ_Rename
; Description ...: Renames a EQ Present
; Syntax.........: _iTunes_EQ_Rename(ByRef $o_Object, $sNewName[, $sPresent = 0[, $iUpdateAllTracks = 1]])
; Parameters ....: $o_Object	- Object variable of a iTunes.Application or EQ object
;                  $sNewName	- New Name For Present
;                  $sPresent	- [optional] Name of Present to be rename
;                  $iUpdateAllTracks	- [optional] If Set to 0, Tracks using this present will NOT be updated.
; Return values .: Success	- 1
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |5 - Invalid Value
; Author ........: Beege
; Modified.......:
; Remarks .......: If $o_Object is not a EQ object, $sPresent must be specified.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_EQ_Rename(ByRef $o_Object, $sNewName, $sPresent = 0, $iUpdateAllTracks = 1)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	Local $oPresent
	If ObjName($o_Object) = 'IITEQPreset' Then
		$oPresent = $o_Object
	Else
		$oPresent = $o_Object.EQPresets.ItemByName($sPresent)
		If Not IsObj($oPresent) Then
			SetError($iStatus_NoMatch)
			Return 0
		EndIf
	EndIf

	$oPresent.Rename($sNewName, $iUpdateAllTracks)
	Return 1

EndFunc   ;==>_iTunes_EQ_Rename

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_EQ_GetProperties
; Description ...: Retrieves the properties of a EQ Present object
; Syntax.........: _iTunes_EQ_GetProperties(ByRef $o_Object[, $sPresent = 0])
; Parameters ....: $o_Object	- Object variable of a iTunes.Application or EQ object
;                  $sPresent	- [optional] Name of Present
; Return values .: Success	- Array
;                  |[0] - PreAmp
;                  |[1] - Band1
;                  |[2] - Band2
;                  |[3] - Band3
;                  |[4] - Band4
;                  |[5] - Band5
;                  |[6] - Band6
;                  |[7] - Band7
;                  |[8] - Band8
;                  |[9] - Band9
;                  |[10] - Band10
;                  |[11] - Band11
;                  |[11] - Modifiable
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |6 - No Match
; Author ........: Beege
; Modified.......:
; Remarks .......: If $o_Object is not a EQ object, $sPresent must be specified.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_EQ_GetProperties(ByRef $o_Object, $sPresent = 0)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	Local $oPresent
	If ObjName($o_Object) = 'IITEQPreset' Then
		$oPresent = $o_Object
	Else
		$oPresent = $o_Object.EQPresets.ItemByName($sPresent)
		If Not IsObj($oPresent) Then
			SetError($iStatus_NoMatch)
			Return 0
		EndIf
	EndIf

	Return StringSplit($oPresent.Preamp & '|' & $oPresent.Band1 & '|' & $oPresent.Band2 & '|' & $oPresent.Band3 & '|' & $oPresent.Band4 & '|' & $oPresent.Band5 _
			 & '|' & $oPresent.Band6 & '|' & $oPresent.Band7 & '|' & $oPresent.Band8 & '|' & $oPresent.Band9 & '|' & $oPresent.Band10 & '|' & $oPresent.Modifiable, '|', 2)
EndFunc   ;==>_iTunes_EQ_GetProperties

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_EQ_SetProperty
; Description ...: Set a property of an EQ Present object
; Syntax.........: _iTunes_EQ_SetProperty(ByRef $o_Object, $iProperty, $sSettings[, $sPresent = 0])
; Parameters ....: $o_Object	- Object variable of a iTunes.Application or EQ object
;                  $iProperty	- Number representing EQ property:
;                  |0 - PreAmp
;                  |1 - Band1
;                  |2 - Band2
;                  |3 - Band3
;                  |4 - Band4
;                  |5 - Band5
;                  |6 - Band6
;                  |7 - Band7
;                  |8 - Band8
;                  |9 - Band9
;                  |10 - Band10
;                  $sSettings	- Value to set property to.
;                  $sPresent	- [optional] Name of Present.
; Return values .: Success	- 1
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |6 - No Match
; Author ........: Beege
; Modified.......:
; Remarks .......: If $o_Object is not a EQ object, $sPresent must be specified.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_EQ_SetProperties(ByRef $o_Object, $iProperty, $sSettings, $sPresent = 0)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	Local $oPresent
	If ObjName($o_Object) = 'IITEQPreset' Then
		$oPresent = $o_Object
	Else
		If $sPresent = 0 Then
			SetError($iStatus_InvalidObjectType)
			Return 0
		EndIf
		$oPresent = $o_Object.EQPresets.ItemByName($sPresent)
		If Not IsObj($oPresent) Then
			SetError($iStatus_NoMatch)
			Return 0
		EndIf
	EndIf

;~ 	If IsArray($aSettings) Then
;~ 		If UBound($aSettings) >= 11 Then
;~ 			SetError(1)
;~ 			Return 0
;~ 		EndIf
;~ 		$oPresent.Preamp = $aSettings[0]
;~ 		$oPresent.Band1 = $aSettings[1]
;~ 		$oPresent.Band2 = $aSettings[2]
;~ 		$oPresent.Band3 = $aSettings[3]
;~ 		$oPresent.Band4 = $aSettings[4]
;~ 		$oPresent.Band5 = $aSettings[5]
;~ 		$oPresent.Band6 = $aSettings[6]
;~ 		$oPresent.Band7 = $aSettings[7]
;~ 		$oPresent.Band8 = $aSettings[8]
;~ 		$oPresent.Band9 = $aSettings[9]
;~ 		$oPresent.Band10 = $aSettings[10]
;~ 		Return 1
;~ 	EndIf

	Switch $iProperty
		Case 0
			$oPresent.Preamp = $sSettings
		Case 1
			$oPresent.Band1 = $sSettings
		Case 2
			$oPresent.Band2 = $sSettings
		Case 3
			$oPresent.Band3 = $sSettings
		Case 4
			$oPresent.Band4 = $sSettings
		Case 5
			$oPresent.Band5 = $sSettings
		Case 6
			$oPresent.Band6 = $sSettings
		Case 7
			$oPresent.Band7 = $sSettings
		Case 8
			$oPresent.Band8 = $sSettings
		Case 9
			$oPresent.Band9 = $sSettings
		Case 10
			$oPresent.Band10 = $sSettings
		Case Else
			SetError($iStatus_InvalidValue)
			Return 0
	EndSwitch

	Return 1

EndFunc   ;==>_iTunes_EQ_SetProperties

#EndRegion EQ Present Functions
#Region Encoder Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Encoder_GetFormats
; Description ...: Retrieves availible encoder Formats
; Syntax.........: _iTunes_Encoder_GetFormats(ByRef $o_Object)
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
; Return values .: Success	- array of availible formats
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Encoder_GetFormats(ByRef $o_Object)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	Local $sEncoders, $ocEncoders = $o_Object.Encoders
	For $encoder In $ocEncoders
		$sEncoders &= $encoder.Format & '|'
	Next

	Return StringSplit(StringTrimRight($sEncoders, 1), '|', 2)

EndFunc   ;==>_iTunes_Encoder_GetFormats

; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_Encoder_SetFormat
; Description ...: Sets the current encoder Format
; Syntax.........: _iTunes_Encoder_SetFormat(ByRef $o_Object, $sFormat)
; Parameters ....: $o_Object	- Object variable of a iTunes.Application
;                  $sFormat		- Format Name or Encoder object
; Return values .: Success	- 1
;                  Failure	- 0, sets @error to:
;                  |3 - Invalid Data type ($o_Object is not a object)
;                  |4 - Invalid Object type
;                  |5 - Invalid Value
; Author ........: Beege
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_Encoder_SetFormat(ByRef $o_Object, $sFormat)
	If Not IsObj($o_Object) Then
		SetError($iStatus_InvalidDataType)
		Return 0
	EndIf

	If IsObj($sFormat) Then
		If Not ObjName($sFormat) = 'IITEncoder' Then
			SetError($iStatus_InvalidObjectType)
			Return 0
		EndIf
		$o_Object.CurrentEncoder = $sFormat
		Return 1
	EndIf

	Local $oEncoder
	For $oEncoder In $o_Object.Encoders
		If $oEncoder.Format = $sFormat Then
			$o_Object.CurrentEncoder = $oEncoder
			Return 1
		EndIf
	Next

	SetError($iStatus_NoMatch)
	Return 0

EndFunc   ;==>_iTunes_Encoder_SetFormat

#EndRegion Encoder Functions


#Region Error Handling
; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_ErrorHandlerRegister
; Description ...: Register and enable a user COM error handler
; Syntax.........: _iTunes_ErrorHandlerRegister($sFunctionName = "__InternalErrorHandler")
; Parameters ....: $sFunctionName	- [optional] String variable with the name of a user-defined COM error handler
; Return values .: Success	- 1
;                  Failure	- 0, sets @error to:
;                  |0 - Failed Registering ERROR Event
; Author ........:
; Modified.......:
; Remarks .......: If no function is specified, the internel com error handler will be used.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_ErrorHandlerRegister($sFunctionName = "__InternalErrorHandler")
	$s_iTunesUserErrorHandler = $sFunctionName
	$o_iTunesErrorHandler = ""
	$o_iTunesErrorHandler = ObjEvent("AutoIt.Error", $sFunctionName)
	If IsObj($o_iTunesErrorHandler) Then
		Return 1
	Else
		SetError($iStatus_GeneralError)
		Return 0
	EndIf
EndFunc   ;==>_iTunes_ErrorHandlerRegister


; #FUNCTION# ====================================================================================================================
; Name...........: _iTunes_ErrorHandlerDeRegister
; Description ...: Disable a registered user COM error handler
; Syntax.........: _iTunes_ErrorHandlerDeRegister()
; Parameters ....: None
; Return values .: Success	- 1
; Author ........:
; Modified.......:
; Remarks .......: If no function is specified, the internel com error handler will be used.
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _iTunes_ErrorHandlerDeRegister()
	$s_iTunesUserErrorHandler = ""
	$o_iTunesErrorHandler = ""
;~ 	SetError($_WordStatus_Success)
	Return 1
EndFunc   ;==>_iTunes_ErrorHandlerDeRegister

#EndRegion Error Handling

#Region Internal Functions

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __iTunesInternalErrorHandlerRegister()
; Parameters ....: None
; Return values .: Success  - 1
; Author ........:
; Remarks .......: This function is used internally
; ===============================================================================================================================
Func __iTunesInternalErrorHandlerRegister()
	Local $sCurrentErrorHandler = ObjEvent("AutoIt.Error")
	If $sCurrentErrorHandler <> "" And Not IsObj($o_iTunesErrorHandler) Then
		; We've got trouble... User COM Error handler assigned without using _iTunes_ErrorHandlerRegister
		SetError($iStatus_GeneralError)
		Return 0
	EndIf
	$o_iTunesErrorHandler = ""
	$o_iTunesErrorHandler = ObjEvent("AutoIt.Error", "__InternalErrorHandler")
	If IsObj($o_iTunesErrorHandler) Then
;~ 		SetError($_WordStatus_Success)
		Return 1
	Else
		SetError($iStatus_GeneralError)
		Return 0
	EndIf
EndFunc   ;==>__iTunesInternalErrorHandlerRegister

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __iTunesInternalErrorHandlerDeRegister()
; Parameters ....: None
; Return values .: Success  - 1
; Author ........:
; Remarks .......: This function is used internally
; ===============================================================================================================================

Func __iTunesInternalErrorHandlerDeRegister()
	$o_iTunesErrorHandler = ""
	If $s_iTunesUserErrorHandler <> "" Then
		$o_iTunesErrorHandler = ObjEvent("AutoIt.Error", $s_iTunesUserErrorHandler)
	EndIf
;~ 	SetError($_WordStatus_Success)
	Return 1
EndFunc   ;==>__iTunesInternalErrorHandlerDeRegister

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __InternalErrorHandler
; Description ...: Internel Error Handler
; Syntax.........: __InternalErrorHandler()
; Parameters ....: None
; Return values .: Success  - 1
; Author ........:
; Remarks .......: This function is used internally
; ===============================================================================================================================
Func __InternalErrorHandler()

	$iComErrorScriptline = $o_iTunesErrorHandler.scriptline
	$iComErrorNumber = $o_iTunesErrorHandler.number
	$iComErrorNumberHex = Hex($o_iTunesErrorHandler.number, 8)
	$iComErrorDescription = StringStripWS($o_iTunesErrorHandler.description, 2)
	$iComErrorWinDescription = StringStripWS($o_iTunesErrorHandler.WinDescription, 2)
	$iComErrorSource = $o_iTunesErrorHandler.Source
	$iComErrorHelpFile = $o_iTunesErrorHandler.HelpFile
	$iComErrorHelpContext = $o_iTunesErrorHandler.HelpContext
	$iComErrorLastDllError = $o_iTunesErrorHandler.LastDllError
	$iComErrorOutput = ""
	$iComErrorOutput &= "--> COM Error Encountered in " & @ScriptName & @CR
	$iComErrorOutput &= "----> $iComErrorScriptline = " & $iComErrorScriptline & @CR
	$iComErrorOutput &= "----> $iComErrorNumberHex = " & $iComErrorNumberHex & @CR
	$iComErrorOutput &= "----> $iComErrorNumber = " & $iComErrorNumber & @CR
	$iComErrorOutput &= "----> $iComErrorWinDescription = " & $iComErrorWinDescription & @CR
	$iComErrorOutput &= "----> $iComErrorDescription = " & $iComErrorDescription & @CR
	$iComErrorOutput &= "----> $iComErrorSource = " & $iComErrorSource & @CR
	$iComErrorOutput &= "----> $iComErrorHelpFile = " & $iComErrorHelpFile & @CR
	$iComErrorOutput &= "----> $iComErrorHelpContext = " & $iComErrorHelpContext & @CR
	$iComErrorOutput &= "----> $iComErrorLastDllError = " & $iComErrorLastDllError & @CR
	If $_ErrorNotify Then ConsoleWrite($iComErrorOutput & @CR)
	SetError($iStatus_ComError)
	Return 1
EndFunc   ;==>__InternalErrorHandler

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __IsObjType
; Description ...: Check to see if an object variable is of a specific type
; Syntax.........: __IsObjType(ByRef $o_Object, $s_type)
; Parameters ....: None
; Return values .: Success  - 1
;                  Failure	- 0
; Author ........:
; Remarks .......: This function is used internally
; ===============================================================================================================================
Func __IsObjType(ByRef $o_Object, $s_type)
	Local $s_Name = ObjName($o_Object), $objectOK = False

	Switch $s_type
		Case "Main"
			If $s_Name = 'IiTunes' Then $objectOK = True
		Case "Source"
			If $s_Name = 'IITIPodSource' Or $s_Name = 'IITSource' Then $objectOK = True
		Case "Track"
			If $s_Name = 'IITTrack' Or $s_Name = 'IITURLTrack' Or $s_Name = 'IITFileOrCDTrack' Then $objectOK = True
		Case "Playlist"
			If $s_Name = 'IITPlaylist' Or $s_Name = 'IITAudioCDPlaylist' Or $s_Name = 'IITLibraryPlaylist' Or $s_Name = 'IITUserPlaylist' Then $objectOK = True
	EndSwitch

	If $objectOK Then Return 1
	Return 0

EndFunc   ;==>__IsObjType
#Region Event Functions
; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: Event_OnConvertOperationStatusChangedEvent
; Description ...: Calls user conversion status function
; Syntax.........: Event_OnConvertOperationStatusChangedEvent($sTrackName, $iProgressValue, $iMaxprogressValue)
; Author ........: Beege
; Remarks .......: This function is used internally
; ===============================================================================================================================
Func Event_OnConvertOperationStatusChangedEvent($sTrackName, $iProgressValue, $iMaxprogressValue)
	Call($FunctiontoCall, $sTrackName, $iProgressValue, $iMaxprogressValue)
EndFunc   ;==>Event_OnConvertOperationStatusChangedEvent

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: Event_OnConvertOperationCompleteEvent()
; Description ...: Conversion complete event
; Syntax.........: Event_OnConvertOperationCompleteEvent()
; Parameters ....: None
; Return values .: None
; Author ........: Beege
; Remarks .......: This function is used internally
; ===============================================================================================================================
Func Event_OnConvertOperationCompleteEvent()
	Call($FunctiontoCall, -1, -1, -1)
EndFunc   ;==>Event_OnConvertOperationCompleteEvent
#EndRegion Event Functions


#EndRegion Internal Functions





#Region Removed Functions

;~ Func iTunes_Artwork_Delete(ByRef $oArtwork)
;~ 	If Not IsObj($oArtwork) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If ObjName($oArtwork) <> 'IITArtwork' Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	$oArtwork.Delete
;~ 	Return 1

;~ EndFunc   ;==>iTunes_Artwork_Delete

;~ Func _iTunes_Source_GetObj(ByRef $o_Object, $sName = 0, $iKind = 0);1 = Library Source, 2 = ipod source, 3 = cd source
;~ 	If Not IsObj($o_Object) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	Local $oCollection = $o_Object.Sources;

;~ 	If $iKind <> 0 Then
;~ 		For $obj In $oCollection
;~ 			If $obj.Kind = $iKind Then Return $obj
;~ 		Next
;~ 	EndIf

;~ 	If $sName Then
;~ 		For $obj In $oCollection
;~ 			If $obj.Name = $sName Then Return $obj
;~ 		Next
;~ 	EndIf

;~ 	SetError($iStatus_NoMatch)
;~ 	Return 0

;~ EndFunc   ;==>_iTunes_Source_GetObj

;~ Func _Playlist_GetObj(ByRef $o_Object, $iReturn_Type = 0, $sName = 0);0 = Collection, 1 = LibraryPlaylist, 2 = UserPlaylist, 3 = Cd Playlist
;~ 	If Not IsObj($o_Object) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not __IsObjType($o_Object, 'Source') Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	If $iReturn_Type = 0 Then Return $o_Object.Playlists;collectin
;~ 	If $iReturn_Type = 1 Then Return $o_Object.LibraryPlaylist

;~ 	Local $collection = $o_Object.Playlists
;~ 	If $sName Then
;~ 		For $obj In $collection
;~ 			If $obj.Name = $iReturn_Type Then Return $obj
;~ 		Next
;~ 	EndIf
;~ 	For $obj In $collection
;~ 		If $obj.Kind = $iReturn_Type Then Return $obj
;~ 	Next

;~ 	SetError($iStatus_NoMatch)
;~ 	Return 0

;~ EndFunc   ;==>_Playlist_GetObj

;~ Func _Playlist_Delete(ByRef $oPlaylist)
;~ 	If Not IsObj($oPlaylist) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not __IsObjType($oPlaylist, 'Playlist') Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	$oPlaylist.Delete
;~ 	Return 1

;~ EndFunc   ;==>_Playlist_Delete

;~ Func _Playlist_PlayFirstTrack(ByRef $oPlaylist)
;~ 	If Not IsObj($oPlaylist) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not __IsObjType($oPlaylist, 'Playlist') Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	$oPlaylist.PlayFirstTrack
;~ 	Return 1

;~ EndFunc   ;==>_Playlist_PlayFirstTrack

;~ Func _Track_GetObj(ByRef $oPlaylist, $sName = 0)
;~ 	If Not IsObj($oPlaylist) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not __IsObjType($oPlaylist, 'Playlist') Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not $sName Then Return $oPlaylist.Tracks

;~ 	Local $oCollection = $oPlaylist.Tracks
;~ 	If $sName Then
;~ 		For $obj In $oCollection
;~ 			If $obj.Name = $sName Then Return $obj
;~ 		Next
;~ 	EndIf

;~ 	SetError($iStatus_NoMatch)
;~ 	Return 0

;~ EndFunc   ;==>_Track_GetObj

;~ Func _Track_Delete(ByRef $oTrack)
;~ 	If Not IsObj($oTrack) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not __IsObjType($oTrack, 'Track') Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	$oTrack.Delete
;~ 	Return 1

;~ EndFunc   ;==>_Track_Delete

;~ Func _Track_Play(ByRef $oTrack)
;~ 	If Not IsObj($oTrack) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not __IsObjType($oTrack, 'Track') Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	$oTrack.Play
;~ 	Return 1

;~ EndFunc   ;==>_Track_Play

;~ Func _iTunes_TrackCollection_GetProperties(ByRef $ocTracks);Gets all properties each track in a track collection and returns a 2D Array.
;~ 	Local $iCd = 0, $i = 0, $aProperties[$ocTracks.Count][62]

;~ 	If Not IsObj($ocTracks) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If ObjName($ocTracks) <> 'IITTrackCollection' Then
;~ 		SetError($iStatus_InvalidObjectType)
;~ 		Return 0
;~ 	EndIf

;~ 	If ObjName($ocTracks.Item(2).Playlist) = 'IITAudioCDPlaylist' Then $iCd = 1

;~ 	For $oTrack In $ocTracks
;~ 		$aProperties[$i][61] = $oTrack
;~ 		$aProperties[$i][0] = $oTrack.Name
;~ 		$aProperties[$i][1] = $oTrack.Kind
;~ 		$aProperties[$i][2] = $oTrack.Playlist; Object
;~ 		$aProperties[$i][3] = $oTrack.Album
;~ 		$aProperties[$i][4] = $oTrack.Artist
;~ 		$aProperties[$i][5] = $oTrack.BitRate
;~ 		$aProperties[$i][6] = $oTrack.BPM
;~ 		$aProperties[$i][7] = $oTrack.Comment
;~ 		$aProperties[$i][8] = $oTrack.Compilation
;~ 		$aProperties[$i][9] = $oTrack.Composer
;~ 		$aProperties[$i][10] = $oTrack.DateAdded
;~ 		$aProperties[$i][11] = $oTrack.DiscCount
;~ 		$aProperties[$i][12] = $oTrack.DiscNumber
;~ 		$aProperties[$i][13] = $oTrack.Duration
;~ 		$aProperties[$i][14] = $oTrack.Enabled
;~ 		$aProperties[$i][15] = $oTrack.EQ
;~ 		$aProperties[$i][16] = $oTrack.Finish
;~ 		$aProperties[$i][17] = $oTrack.Genre
;~ 		$aProperties[$i][18] = $oTrack.Grouping
;~ 		$aProperties[$i][19] = $oTrack.KindAsString
;~ 		$aProperties[$i][20] = $oTrack.ModificationDate
;~ 		$aProperties[$i][21] = $oTrack.PlayedCount
;~ 		$aProperties[$i][22] = $oTrack.PlayedDate
;~ 		$aProperties[$i][23] = $oTrack.PlayOrderIndex
;~ 		$aProperties[$i][24] = $oTrack.Rating
;~ 		$aProperties[$i][25] = $oTrack.SampleRate
;~ 		$aProperties[$i][26] = $oTrack.Size
;~ 		$aProperties[$i][27] = $oTrack.Start
;~ 		$aProperties[$i][28] = $oTrack.Time
;~ 		$aProperties[$i][29] = $oTrack.TrackCount
;~ 		$aProperties[$i][30] = $oTrack.TrackNumber
;~ 		$aProperties[$i][31] = $oTrack.VolumeAdjustment
;~ 		$aProperties[$i][32] = $oTrack.Year
;~ 		$aProperties[$i][33] = $oTrack.Artwork ; Artwork Collection

;~ 		If $aProperties[$i][1] = 0 Or $aProperties[$i][1] = 4 Or $aProperties[$i][1] = 5 Then ;Track Kind is Device track, Shared library track, Or Unknown
;~ 			For $a = 34 To 60
;~ 				$aProperties[$i][$a] = 'XXX'
;~ 			Next
;~ 			ContinueLoop
;~ 		EndIf

;~ 		$aProperties[$i][34] = $oTrack.Category
;~ 		$aProperties[$i][35] = $oTrack.Description
;~ 		$aProperties[$i][36] = $oTrack.LongDescription
;~ 		$aProperties[$i][37] = $oTrack.Podcast
;~ 		$aProperties[$i][38] = $oTrack.AlbumRating
;~ 		$aProperties[$i][39] = $oTrack.AlbumRatingKind
;~ 		$aProperties[$i][40] = $oTrack.RatingKind
;~ 		$aProperties[$i][41] = $oTrack.Playlists

;~ 		If $aProperties[$i][1] = 3 Then ;Track Kind is URL
;~ 			$aProperties[$i][42] = $oTrack.URL
;~ 			For $a = 42 To 60
;~ 				$aProperties[$i][$a] = 'XXX'
;~ 			Next
;~ 			ContinueLoop
;~ 		EndIf

;~ 		$aProperties[$i][42] = $oTrack.Location
;~ 		$aProperties[$i][36] = $oTrack.RememberBookmark
;~ 		$aProperties[$i][37] = $oTrack.ExcludeFromShuffle
;~ 		If Not $iCd Then $aProperties[$i][38] = $oTrack.Lyrics
;~ 		$aProperties[$i][42] = $oTrack.BookmarkTime
;~ 		$aProperties[$i][43] = $oTrack.VideoKind
;~ 		$aProperties[$i][44] = $oTrack.SkippedCount
;~ 		$aProperties[$i][45] = $oTrack.SkippedDate
;~ 		$aProperties[$i][46] = $oTrack.PartOfGaplessAlbum
;~ 		$aProperties[$i][47] = $oTrack.AlbumArtist
;~ 		$aProperties[$i][48] = $oTrack.Show
;~ 		$aProperties[$i][49] = $oTrack.SeasonNumber
;~ 		$aProperties[$i][50] = $oTrack.EpisodeID
;~ 		$aProperties[$i][51] = $oTrack.EpisodeNumber
;~ 		$aProperties[$i][52] = $oTrack.Size64High
;~ 		$aProperties[$i][53] = $oTrack.Size64Low
;~ 		$aProperties[$i][54] = $oTrack.Unplayed
;~ 		$aProperties[$i][55] = $oTrack.SortAlbum
;~ 		$aProperties[$i][56] = $oTrack.SortAlbumArtist
;~ 		$aProperties[$i][57] = $oTrack.SortArtist
;~ 		$aProperties[$i][58] = $oTrack.SortComposer
;~ 		$aProperties[$i][59] = $oTrack.SortName
;~ 		$aProperties[$i][60] = $oTrack.SortShow
;~ 		$i += 1
;~ 	Next

;~ 	Return $aProperties

;~ EndFunc   ;==>_iTunes_TrackCollection_GetProperties

;~ Func _Visuals_GetObj(ByRef $o_Object, $sName = 0)
;~ 	If Not IsObj($o_Object) Then
;~ 		SetError($iStatus_InvalidDataType)
;~ 		Return 0
;~ 	EndIf

;~ 	If Not $sName Then Return $o_Object.Visuals

;~ 	Local $oc_Visuals = $o_Object.Visuals
;~ 	For $visuals In $oc_Visuals
;~ 		If $visuals.Name = $sName Then Return $visuals
;~ 	Next

;~ 	SetError($iStatus_NoMatch)
;~ 	Return 0

;~ EndFunc   ;==>_Visuals_GetObj

#EndRegion Removed Functions

;Post
;Here is a another iTunes UDF that I have been working on for sometime now.  I tried to make it more like the includes word.au3 and $IE.au3. ;The error handling functions and some understanding came from them.
;Also special thanks to  torels. His iTunes UDF gave me a great amount of understanding the iTunes COM SDK so Thankyou very much torels. I love anykind of feedback so please let me know what you think, or if you have problems, don't understand, think something should be done diffrently, removed, added, ANYTHING! In my opinion, an iTunes UDF is something that could mabey be added to autoit in the future.  Its a very popular program that on a lot of windows computers. I only included four examples but, I plan on adding more examples in the future.(Feel Free to post more or better examples)



;~  http://www.autoitscript.com/forum/index.php?showtopic=70675&hl=itunes&st=0



;~ http://developer.apple.com/sdk/itunescomsdk.html
