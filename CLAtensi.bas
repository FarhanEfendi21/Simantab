B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Dim Api1 As Api
	Dim mcuaca As Map
	
	Private panelHistory As Panel
	Private panelInput As Panel
	Private AsTab As ASSegmentedTab
	
	'input atensi
	Private etAtensi As EditText
	Private etCuaca As EditText
	Private clv As CustomListView
	Private btnHapus As SwiftButton
	Private btnSimpan As SwiftButton
	Private spncuaca As Spinner
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	mcuaca.Initialize
	Log("Atensi")
	Api1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("layAtensi")
	
	Appear
End Sub

Private Sub Appear
	panelHistory.Visible = False
	AsTab.CornerRadiusBackground = AsTab.Base.Height/2 'make the view rounded
'	AsTab.Base.Color= 0XFFBE9638
'	AsTab.ItemTextProperties.BackgroundColor = 0XFFBE9638
	
	AsTab.AddTab("ATENSI",Null)
	AsTab.AddTab("RIWAYAT",Null)
	createcuaca
	
	AsTab.CornerRadiusSelectionPanel = AsTab.SelectionPanel.Height/2
	
	panelInput.LoadLayout("layInputAtensi")
	etAtensi.Color = Colors.Transparent
	etCuaca.Color = Colors.Transparent
	
	panelHistory.LoadLayout("layHistoryAtensi")
	
	
End Sub

Private Sub AsTab_TabChanged(index As Int)
'	Log(index)
	If index = 1 Then
		panelInput.Visible = False
		panelHistory.SetVisibleAnimated(200,True)
		loadAtensi
	Else
		panelHistory.Visible = False       
		panelInput.SetVisibleAnimated(200,True)
	End If
End Sub

Sub createcuaca
	Wait For (Api1.SelectData("get_listcuaca",Null)) complete (result As resJrdc)
	If result.success Then
		spncuaca.Clear
		mcuaca.clear
		spncuaca.Add("Pilih Cuaca")
		Dim res As DBResult = result.res
		For Each re() As Object In res.Rows
			Dim idcuaca As Int		= re(res.Columns.Get("id"))
			Dim nama As String 	= re(res.Columns.Get("nama"))
			
			mcuaca.Put(nama,idcuaca)
			spncuaca.Add(nama)
		Next
	End If
End Sub

Private Sub loadAtensi
	Dim idUser As Int = Main.kvs.GetEncrypted("iduser", Main.kunci)
	
	Wait For (Api1.SelectData("get_history_atensi",Array(idUser))) complete (result As resJrdc)
	clv.Clear
	If result.success Then
		Dim res As DBResult = result.res
		If res.Rows.Size > 0 Then
			For Each re() As Object In res.Rows
				Dim nama As String		= re(res.Columns.Get("nama"))
				Dim atensi As String	= re(res.Columns.Get("atensi"))
				Dim tanggal As String	= re(res.Columns.Get("jam"))
				clv.AddTextItem(createLabelHistory(nama,atensi,tanggal),0)
			Next
			
		Else
			clv.AddTextItem(Utils.textDataTidakAda,0)
		End If
	Else
		clv.AddTextItem(Utils.textDataTidakDitemukan,0)
	End If
End Sub


Private Sub btnSimpan_Click
	If Validasi Then
		Dim idUser As Int = Main.kvs.GetEncrypted("iduser", Main.kunci)

		Dim param As Object
		param = Array(idUser, mcuaca.Get(spncuaca.SelectedItem), etAtensi.Text, Starter.locationFLP.Latitude, Starter.locationFLP.Longitude)
		Wait For (Api1.ExeData("insert_atensi",param)) complete (result As resJrdc)
		If result.success = False Then
			Utils.ShowToastTengah("Data gagal disimpan, silahkan coba beberapa saat lagi")
		Else
			Utils.ShowToastTengah("Data berhasil kami terima.")
			btnHapus_Click
		End If
	End If
End Sub

Private Sub btnHapus_Click
	spncuaca.SelectedIndex=0
	etCuaca.Text = ""
	etAtensi.Text = ""
End Sub


Private Sub Validasi As Boolean
	If spncuaca.SelectedIndex = 0 Then
		Utils.ShowToastTengah("Kondisi cuasa belum diisi")
		etCuaca.RequestFocus
		Return False
	End If
	
	If etAtensi.Text.Length = 0 Then
		Utils.ShowToastTengah("NET / Atensi belum diisi")
		etAtensi.RequestFocus
		Return False
	End If
	Return True
End Sub

Sub createLabelHistory(nama As String, atensi As String, tanggal As String) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(Colors.Black).Bold.Size(18).Append("CUACA : ").Append(nama).PopAll
	cs.Color(0xFF2B2B2B).Size(14).Append(CRLF).Append("Tanggal : " & tanggal).PopAll
	cs.Color(0xFF2B2B2B).Size(16).Append(CRLF).Append("NET / Atensi : ").Append(CRLF).Append(atensi).PopAll
	Return cs
End Sub