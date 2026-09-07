B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=13.1
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	
	Private lbDetail As Label
	Private lbgudang As Label
	Private pBG As Panel
	Private clv As CustomListView
	Private lbgudang As Label
	
	Dim api1 As Api
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	Log("Data Logistik")
	api1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("LayDataLogistik")
	
	Appear
End Sub

Private Sub Appear
'	etSearch.Color = Colors.Transparent

	Wait For (api1.SelectData("get_logistik",Null)) complete (result As resJrdc)
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
		Dim gudang As String	= re(res.Columns.Get("nama_gudang"))
		Dim nama As String	= re(res.Columns.Get("nama_barang"))
		Dim jumlah As String	= re(res.Columns.Get("sisa_stok"))
		Dim uom As String	= re(res.Columns.Get("uom"))
		clv.Add(createListItem(gudang,nama,jumlah,uom), uom)
	Next
End Sub

Private Sub createLabelgudang(text As String) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(Colors.Black).Bold.Size(14).Append("Nama Gudang : " ).Append(text).PopAll
	Return cs
End Sub

Sub createListItem( gudang As String, nama As String, uom As String, jumlah As String) As Panel
	Dim width As Int = clv.AsView.Width
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0,  0, width , 1dip)

	p.LoadLayout("layDataLogistikItems")
	lbgudang.Text = createLabelgudang(gudang)
	lbDetail.Text = createName(nama,uom,jumlah)

	lbDetail.Height = Utils.GetTinggiLbl(lbDetail) + 50dip
	pBG.Height = Utils.GetTinggiLbl(lbDetail) + 50dip
	
'	lbPhone.Tag = trimPhone
'	lbPhone.Tag = phone_number
	
'	If phone_number.Trim.Length = 0 Or phone_number = "0" Then
'		lbPhone.Visible = False
'	End If
	
'	Dim setengah As Int = pBGDetail.Height / 2
'	lbPhone.Top = 0
'	lbPhone.Height = lbDetail.Height


	p.SetLayoutAnimated(0, 0, 0, width, pBG.Top + pBG.Height )
	Return p
End Sub

'Sub GetTinggiLbl moved to Utils.bas to avoid duplicate key error


Sub createName(nama As String, jumlah As String, uom As String) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(Colors.Black).Bold.Size(16).Append("Nama Barang : ").Append(nama).Append(CRLF).PopAll
	cs.Color(Colors.Black).Size(14).Append("Stok : ").Append(jumlah).PopAll
	cs.Color(Colors.Black).Size(14).Append("  ").Append(uom).PopAll
'	If phone_number <> "0" And phone_number.Trim.Length > 0 Then
'		cs.Append(CRLF).Color(Colors.Black).Size(16).Append("Telpon : " & phone_number).PopAll
'	End If
	'clv.s
	Return cs
End Sub

'Private Sub lbSearch_Click
'	
''	If etSearch.Text.Length > 2 Then
'	Dim keyword As String
'		
'	keyword = "%" & etSearch.Text &"%"
'	keyword = keyword.Replace(" ","%")
'	ProgressDialogShow2("Cari data...", False)
'	Wait For (api1.SelectData("get_telpall_search",Array(keyword))) complete (result As resJrdc)
'	ProgressDialogHide
'	clv.Clear
'	If result.success Then
'		Dim res As DBResult = result.res
'		If res.Rows.Size > 0 Then
'			isiData(res)
'		Else
'			clv.AddTextItem(Utils.textDataTidakAda,0)
'		End If
'	Else
'		clv.AddTextItem(Utils.textDataTidakDitemukan,0)
'	End If
''	Else
''		Utils.ShowToastTengah("Pencarian nomor telpon minimal 3 karakter")
''	End If
'End Sub

Private Sub clv_ItemLongClick (Index As Int, Value As Object)

End Sub

'Private Sub lbPhone_Click
'	Dim lb As Label = Sender
'	Dim p As Phone
'	If p.GetSimOperator.Length > 0 Then
'		Try
''			Log("telp : " & lb.Tag)
'			Dim py As PhoneCalls
'			StartActivity(py.Call(lb.Tag))
'		Catch
'			Log(LastException.Message)
'		End Try
'	Else
'		ToastMessageShow("Simcard tidak tersedia", False)
'	End If
'End Sub

Private Sub etSearch_EnterPressed
'	lbSearch_Click
End Sub