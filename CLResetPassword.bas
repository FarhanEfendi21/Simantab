B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	
	Private btnNewPassword As Button
	Private panPassword As Panel
	
	Dim api1 As Api
	Private etEmail As EditText
'	Dim IME1 As IME
'	Private Panel6 As Panel
	Private pPIN As Panel
	Private etPIN As EditText
	Private etPassword As EditText
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	api1.Initialize
'	IME1.Initialize("IME1")
	
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("lResetPassword")
	
	Appear
'	IME1.AddHeightChangedEvent
'	IME1_HeightChanged(Root.Height - 120dip,0)
End Sub

Sub IME1_HeightChanged(NewHeight As Int, OldHeight As Int)
	btnNewPassword.Top = (NewHeight - 56dip) - btnNewPassword.Height
End Sub


Private Sub Appear
	For Each v As B4XView In Root.GetAllViewsRecursive
		If v Is EditText Then
			v.Color = Colors.Transparent
		End If
	Next
End Sub


Private Sub btnNewPassword_Click
	If Utils.ValidateEmail(etEmail.Text) Then
		If panPassword.Visible = False Then
			
			Wait For(api1.SelectData("cek_email",Array(etEmail.Text))) complete (resEmail As resJrdc)
			If resEmail.success Then
				If resEmail.res.Rows.Size > 0 Then
					Wait For(api1.sendEmail(etEmail.Text,"1111")) COMPLETE (resSendEmail As Boolean)
					If resSendEmail Then
						xui.MsgboxAsync("Kode telah dikirimkan ke email anda, silahkan membuka email anda dan masukan kode di sini","")
						Log (resSendEmail)
						etEmail.Enabled = False
						etPIN.RequestFocus
						panPassword.Visible = True
						pPIN.Visible = True
						btnNewPassword.Top = panPassword.Top + panPassword.Height + 20dip
						btnNewPassword.Text = "SIMPAN"
					Else
						Utils.ShowToastTengah("Kode gagal di kirim ke email")
					End If
				Else
					Utils.ShowToastTengah("Email tidak ditemukan")
				End If
			Else
				Utils.ShowToastTengah("Tidak terhubung ke server")
			End If
		Else
			If etPIN.Text.Length = 4 Then
'				Log("dsa")
				Wait For (api1.SelectData("cek_email_pin", Array(etEmail.Text,etPIN.Text) )) complete (respin As resJrdc)
				Log(respin.success)
				If respin.success Then
					If respin.res.Rows.Size > 0 Then
						If etPassword.Text.Length > 5 Then
							Wait For(api1.ExeData("set_new_password",Array(Utils.encryptMD5( etPassword.Text), etEmail.Text))) complete (resPwd As resJrdc)
							Log("pwd : " & resPwd.success)
							If resPwd.success Then
								xui.MsgboxAsync("Password berhasil diganti, silakan masuk applikasi dengan password baru anda","")
								panPassword.Visible = False
								pPIN.Visible = False
								CallSub2(Main,"gotoLogin","")
							End If
						Else
							Utils.ShowToastTengah("Password minimal 6 karakter")
						End If
					
					Else
						Utils.ShowToastTengah("Kode tidak benar")
					End If
				Else
					Utils.ShowToastTengah("Tidak terhubung ke server")
				End If
				
				
			Else
				Utils.ShowToastTengah("Kode harus 4 digit")
			End If
			
		End If
	Else
		Utils.ShowToastTengah("Email tidak benar")
	End If
End Sub