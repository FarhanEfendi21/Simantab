B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Dim api1 As Api
	
	Private chkAgree As CheckBox
	Private etNama As EditText
	Private etEmail As EditText
	Private etHP As EditText
	Private etPassword As EditText
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	api1.Initialize
	Root = p
End Sub

Public Sub createLayout(hp As String)
	Root.LoadLayout("lRegister")
	If hp.Trim.Length > 4 Then
		etHP.Text = hp
	End If
	Appear
End Sub

Private Sub Appear
	For Each v As B4XView In Root.GetAllViewsRecursive
		If v Is EditText Then
			v.Color = Colors.Transparent
		End If
	Next
End Sub
Private Sub lbAgree_Click
	chkAgree.Checked = Not(chkAgree.Checked)
End Sub

Private Sub validasi As Boolean
	If etNama.Text.Length = 0 Then
		Utils.ShowToastTengah("Nama belum diisi")
		etNama.RequestFocus
		Return False
	End If
	
	If etEmail.Text.Length = 0 Then
		Utils.ShowToastTengah("Email belum diisi")
		etEmail.RequestFocus
		Return False
	End If
	
	If Utils.ValidateEmail(etEmail.Text) = False Then
		Utils.ShowToastTengah("Penulisan email tidak benar")
		etEmail.RequestFocus
		Return False
	End If
	
	If etHP.Text.Length = 0 Then
		Utils.ShowToastTengah("No HP belum diisi")
		etHP.RequestFocus
		Return False
	End If
	
	If etPassword.Text.Length < 6 Then
		Utils.ShowToastTengah("Password minimal 6 karakter")
		etPassword.RequestFocus
		Return False
	End If
	
	If chkAgree.Checked = False Then
		Utils.ShowToastTengah("Syarat ketentuan belum disetujui")
		Return False
	End If
	
	Return True
End Sub


Private Sub btnLogin_Click
	If validasi Then
		Wait For (api1.SelectData("get_telpreg", Array(etHP.Text))) complete (resGet As resJrdc)
		If resGet.success Then
			If resGet.res.Rows.Size > 0 Then
				Utils.ShowToastTengah("Nomor HP sudah terdaftar")
			Else
				Dim param As Object = Array (etNama.Text, etEmail.Text, etHP.Text, Utils.encryptMD5(etPassword.Text))
				Wait For(api1.ExeData("set_registrasi", param)) complete (result As resJrdc)
				If result.success Then
					CallSub2(Main,"gotoLogin",etHP.Text)
					Utils.ShowToastTengah("Pendaftaran sudah berhasil, silahkan masuk applikasi dengan no hp yang baru didaftarkan")
				End If
			End If
		End If
	End If
End Sub