B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView 
	Private xui As XUI
	
	Private lbDetail As Label
	Private lbPhone As Label
	Private pBGDetail As Panel
	Private clv As CustomListView
	Private etSearch As EditText
	Private lbSearch As Label
	
	Dim api1 As Api
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	Log("telp penting")
	api1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("LayClv")
	
	Appear
End Sub

Private Sub Appear
	etSearch.Color = Colors.Transparent

	Wait For (api1.SelectData("get_telpall",Null)) complete (result As resJrdc)
	clv.Clear
	If result.success Then
		Dim res As DBResult = result.res
		If res.Rows.Size > 0 Then
			isiData(res)
		Else
			clv.AddTextItem(Utils.textDataTidakAda,0)
		End If
	Else
		clv.AddTextItem(Utils.textDataTidakDitemukan,0)
	End If
End Sub

Private Sub isiData(res As DBResult)
	For Each re() As Object In res.Rows
		Dim nama As String	= re(res.Columns.Get("nama"))
		Dim ket As String	= re(res.Columns.Get("deskripsi"))
		Dim telp As String	= re(res.Columns.Get("telpon"))
		Dim telptrim As String	= re(res.Columns.Get("telp_trim"))
		clv.Add(createListItem(nama,ket,telp, telptrim),telptrim)
	Next
End Sub

Sub createListItem( nama As String, description As String, phone_number As String, trimPhone As String) As Panel
	Dim width As Int = clv.AsView.Width
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0,  0, width , 1dip)

	p.LoadLayout("layItemTelp")
	
	lbDetail.Text = createName(nama,description, phone_number)

	lbDetail.Height = Utils.GetTinggiLbl(lbDetail) + 40dip
	pBGDetail.Height = Utils.GetTinggiLbl(lbDetail) + 40dip
	
	lbPhone.Tag = trimPhone
'	lbPhone.Tag = phone_number
	
	If phone_number.Trim.Length = 0 Or phone_number = "0" Then
		lbPhone.Visible = False
	End If
	
'	Dim setengah As Int = pBGDetail.Height / 2
	lbPhone.Top = 0
	lbPhone.Height = lbDetail.Height


	p.SetLayoutAnimated(0, 0, 0, width, pBGDetail.Top + pBGDetail.Height )
	Return p
End Sub

'Sub GetTinggiLbl moved to Utils.bas to avoid duplicate key error


Sub createName(nama As String, description As String, phone_number As String) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(Colors.Black).Bold.Size(18).Append(nama).Append(CRLF).PopAll
	cs.Color(Colors.Black).Size(16).Append(description).PopAll
	If phone_number <> "0" And phone_number.Trim.Length > 0 Then
		cs.Append(CRLF).Color(Colors.Black).Size(16).Append("Telpon : " & phone_number).PopAll
	End If
'clv.s
	Return cs
End Sub

Private Sub lbSearch_Click
	
'	If etSearch.Text.Length > 2 Then
		Dim keyword As String 
		
		keyword = "%" & etSearch.Text &"%"
		keyword = keyword.Replace(" ","%")
		ProgressDialogShow2("Cari data...", False)
		Wait For (api1.SelectData("get_telpall_search",Array(keyword))) complete (result As resJrdc)
		ProgressDialogHide
		clv.Clear
		If result.success Then
			Dim res As DBResult = result.res
			If res.Rows.Size > 0 Then
				isiData(res)
			Else
				clv.AddTextItem(Utils.textDataTidakAda,0)
			End If
		Else
		clv.AddTextItem(Utils.textDataTidakDitemukan,0)
		End If
'	Else
'		Utils.ShowToastTengah("Pencarian nomor telpon minimal 3 karakter")
'	End If
End Sub

Private Sub clv_ItemLongClick (Index As Int, Value As Object)

End Sub

Private Sub lbPhone_Click
	Dim lb As Label = Sender
	Dim p As Phone
	If p.GetSimOperator.Length > 0 Then
		Try
'			Log("telp : " & lb.Tag)
			Dim py As PhoneCalls
			StartActivity(py.Call(lb.Tag))
		Catch
			Log(LastException.Message)
		End Try
	Else
		ToastMessageShow("Simcard tidak tersedia", False)
	End If
End Sub

Private Sub etSearch_EnterPressed
	lbSearch_Click
End Sub