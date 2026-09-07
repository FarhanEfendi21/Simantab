B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=9.9
@EndOfDesignText@
	#Region  Service Attributes 
	#StartAtBoot: False
	#ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Dim api1 As Api
	Dim gps1 As GPS
	Public FLP As FusedLocationProvider
	Private flpStarted As Boolean
	Public locationFLP As Location
	Dim altitude As Float
End Sub

Sub Service_Create
	'This is the program entry point.
	'This is a good place to load resources that are not specific to a single activity.
	api1.Initialize
	FLP.Initialize("flp")
	FLP.Connect
	CallSubDelayed(FirebaseMessaging, "SubscribeToTopics")
End Sub

Sub Service_Start (StartingIntent As Intent)
	Service.StopAutomaticForeground 'Starter service can start in the foreground state in some edge cases.
End Sub

Sub Service_TaskRemoved
	'This event will be raised when the user removes the app from the recent apps list.
End Sub

'Return true to allow the OS default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy

End Sub


Sub updateToken(param As Object)
	Wait For(api1.ExeData("update_token", param)) complete (result As resJrdc)
End Sub

Sub logLogin(param As Object)
	Log("logLogin")
	Wait For(api1.ExeData("update_log_login", param)) complete (result As resJrdc)
End Sub

'GPS

Sub flp_ConnectionSuccess
	Log("Connected to location provider")
End Sub

Sub flp_ConnectionFailed(ConnectionResult1 As Int)
	Log("Failed to connect to location provider")
End Sub

Public Sub StartFLP
	Do While FLP.IsConnected = False
		Sleep(1000)
	Loop
	If flpStarted = False Then
		FLP.RequestLocationUpdates(CreateLocationRequest)
		flpStarted = True
	End If
End Sub


Private Sub flp_LocationChanged (Location1 As Location)
'	CallSub2(Main, "LocationChanged", Location1)
	locationFLP = Location1
	altitude = Location1.Altitude
	Log(altitude)
End Sub

Private Sub CreateLocationRequest As LocationRequest
	Dim lr As LocationRequest
	lr.Initialize
	lr.SetInterval(10000)
	lr.SetFastestInterval(lr.GetInterval / 2)
	lr.SetPriority(lr.Priority.PRIORITY_HIGH_ACCURACY)
	Return lr
End Sub

Public Sub StopFLP
	If flpStarted Then
		FLP.RemoveLocationUpdates
		flpStarted = False
	End If
End Sub

Sub notifBablas(jaraksaya As Double)
	Dim n As Notification
	'jaraksaya= jaraksaya/1000
	n.Initialize2(n.IMPORTANCE_HIGH)
	n.Vibrate = True
	n.AutoCancel = True
	n.Icon = "icon"
	n.SetInfo2("Informasi Jarak","Jarak Anda "& Round2(jaraksaya ,2) & " KM, dari Puncak Merapi.","jarak_merapi", ActHome)
	n.Notify(2)
End Sub




