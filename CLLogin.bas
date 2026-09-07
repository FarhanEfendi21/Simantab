B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	

	Private etHP As EditText
	Private etPassword As EditText
	'Private lbRegister As Label
	Dim api1 As Api
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	api1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("LayLogin")
	
	Appear
'	If Main.isDevelopment Then
'		etHP.Text = "085643233547"
'		etPassword.Text = "dikau 17081991 blank"
'	End If
End Sub

Public Sub inputHPRegster(hp As String)
	etHP.Text = hp
End Sub

Private Sub Appear
	etHP.Color 			= Colors.Transparent
	etPassword.Color 	= Colors.Transparent
	'lbRegister.Text = createFontRegister
	

End Sub

Private Sub createFontRegister As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Size(16).Color(0xFF181818).Append("Tidak punya akun ? ").PopAll
	cs.Size(17).Color(0xFF0F18AF).Bold.Append("DAFTAR").PopAll
	Return cs
End Sub

'Private Sub lbRegister_Click
'	CallSub2(Main,"gotoRegister",etHP.Text)
'End Sub


Private Sub lbResetPassword_Click
	CallSub(Main,"gotoResetPassword")
End Sub

Private Sub btnLogin_Click
	If validasi Then
		Dim param As Object = Array(etHP.Text, Utils.encryptMD5(etPassword.Text))
		ProgressDialogShow("Loading.....")
		Wait For (api1.SelectData("get_login",param)) complete (result As resJrdc)
		ProgressDialogHide
		If result.success Then
			Dim res As DBResult = result.res
'			Log(result.res)
			If res.Rows.Size > 0 Then
				For Each re() As Object In res.Rows
					Dim pesan As String = re(res.Columns.Get("pesan"))
					If pesan = "ok" Then
						Dim iduser As String = re(res.Columns.Get("idtbluser"))
						Dim fb_token As String = re(res.Columns.Get("fb_token"))
						Main.kvs.PutEncrypted("iduser",iduser,Main.kunci)
						Main.kvs.Put("login","success")

						StartService(FirebaseMessaging)
						Wait For (CallSub(FirebaseMessaging,"getToken")) complete (v As Boolean)
						If Main.kvs.Get("fbtoken") <> Null Then
							If Main.kvs.Get("fbtoken") <> fb_token Then
								Dim param As Object = Array( Main.kvs.Get("fbtoken"),iduser)
								CallSubDelayed2(Starter,"updateToken",param)
							End If
						End If
						Dim prLog As Object = Array(Utils.getInfo,iduser)
						CallSubDelayed2(Starter,"logLogin",prLog)
						CallSub(Main,"successLogin")
					Else
						Utils.ShowToastTengah(pesan)
					End If
				Next
			Else
				Utils.ShowToastTengah("No HP / Password salah")
			End If
		End If
	End If
End Sub



Private Sub validasi As Boolean
	If etHP.Text.Length = "0" Then
		xui.MsgboxAsync("HP belum diisi","")
		etHP.RequestFocus
		Return False
	End If
	
	If etPassword.Text.Length = "0" Then
		xui.MsgboxAsync("Password belum diisi","")
		etPassword.RequestFocus
		Return False
	End If
	
	Return True
End Sub

