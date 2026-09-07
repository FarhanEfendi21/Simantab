B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=11.2
@EndOfDesignText@
Sub Process_Globals
	Private fm As FirebaseMessaging
End Sub

Sub Service_Create
	fm.Initialize("fm")
'	Main.kvs.Put("fbtoken", fm.Token)
'	getToken
End Sub

Public Sub SubscribeToTopics
	fm.SubscribeToTopic("general") 'you can subscribe to more topics
	fm.SubscribeToTopic("user") 'you can subscribe to more topics
End Sub

Sub Service_Start (StartingIntent As Intent)
	If StartingIntent.IsInitialized Then fm.HandleIntent(StartingIntent)
	Sleep(0)
	Service.StopAutomaticForeground 'remove if not using B4A v8+.
End Sub

Sub getToken As ResumableSub
	Do While fm.Token = ""
		Sleep(100)
	Loop
	If Main.kvs.Get("fbtoken") = Null Then
		Main.kvs.Put("fbtoken", fm.Token)
	Else
		Dim tkn As String = Main.kvs.Get("fbtoken")
		If tkn <> fm.Token Then
			
			Main.kvs.Put("fbtoken", fm.Token)
		End If
	End If
	Return True
End Sub

Sub fm_MessageArrived (Message As RemoteMessage)
'	Log("Message arrived")
'	Log($"Message data: ${Message.GetData}"$)
	Try
		Dim n As Notification
		n.Initialize
		n.Vibrate=True
		n.AutoCancel=True
		n.Icon = "icon"
		n.SetInfo2(Message.GetData.Get("title"), Message.GetData.Get("body"),Message.GetData.Get("tag"), ActHome)
		n.Notify(1)
		
	Catch
		Log(LastException.Message)
	End Try
End Sub

Sub Service_Destroy

End Sub