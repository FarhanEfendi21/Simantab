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
	
	'bencana
	Private spnFIlter As Spinner
	Private clv As CustomListView
	
	'items
	Private lbDetail As Label
	Private lbStatus As Label
	Private lbTanggal As Label
	Private pBG As Panel
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	Log("History Bencana")
	Api1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("layHistoryBencana")
	Appear
End Sub

Private Sub Appear
	spnFIlter.Clear
	spnFIlter.Add("Semua status")
	spnFIlter.Add("Selesai")
	spnFIlter.Add("Proses")
	spnFIlter.Add("Belum di tangani")
	
	loadHistory("")
End Sub

Private Sub loadHistory(filter As String)
	Dim idUser As Int = Main.kvs.GetEncrypted("iduser", Main.kunci)
	If filter.Length = 0 Then
		Wait For (Api1.SelectData("history_laporan",Array(idUser))) complete (result As resJrdc)
	Else
		Wait For (Api1.SelectData("history_laporan_status",Array(idUser,filter))) complete (result As resJrdc)
	End If
	clv.Clear
	If result.success Then
		Dim res As DBResult = result.res
		If res.Rows.Size > 0 Then
			For Each re() As Object In res.Rows
				Dim tanggal As String	= re(res.Columns.Get("jam"))
				Dim detail As String	= re(res.Columns.Get("dampak"))
				Dim status As String	= re(res.Columns.Get("status"))
				
				clv.Add(createListItem(tanggal,detail,status),0)
			Next
		Else
			clv.AddTextItem(Utils.textDataTidakAda,0)
		End If
	Else
		clv.AddTextItem(Utils.textDataTidakDitemukan,0)
	End If
End Sub

Sub createListItem( tanngal As String, detail As String, status As String) As Panel
	Dim width As Int = clv.AsView.Width
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0,  0, width , 1dip)

	p.LoadLayout("layHistoryBencanaItems")
	
	lbTanggal.Text = createLabelTanggal(tanngal)
	lbStatus.Text = createLabelStatus(status)
	lbDetail.Text = detail
	
	lbDetail.Height = Utils.GetTinggiLbl(lbDetail)
	pBG.Top = 5dip
	pBG.Height = lbTanggal.Top + lbTanggal.Height + lbDetail.Height + 10dip
	
	

	p.SetLayoutAnimated(0, 0, 0, width, pBG.Top + pBG.Height )
	Return p
End Sub


Private Sub createLabelTanggal(text As String) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(0xFF2B2B2B).Size(14).Append("Dibuat : " ).Append(text).PopAll
	Return cs
End Sub

Private Sub createLabelStatus(text As String) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(0xFF2B2B2B).Size(14).Append("Status : " ).PopAll
	If text = "proses" Then
		cs.Color(0xFFC57900).Size(14).Append(text).PopAll
	Else If text = "selesai" Then
		cs.Color(0xFF179100).Size(14).Append(text).PopAll
	Else
		cs.Color(0xFFD00000).Size(14).Append(text).PopAll
	End If
	Return cs
End Sub

Private Sub spnFIlter_ItemClick (Position As Int, Value As Object)
	If Position <> 0 Then
		loadHistory(spnFIlter.SelectedItem)
	End If
End Sub