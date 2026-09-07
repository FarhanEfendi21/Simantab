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
	
	Private clv As CustomListView
'	Private Label1 As Label
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	Utils.deleteBadge
	api1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("layClvFull")
	
	Appear
End Sub

Private Sub Appear
'	Log("ap")
	Wait For (api1.SelectData("get_peringatandini",Null)) complete (result As resJrdc)
	If result.success Then
		Dim res As DBResult = result.res
		clv.Clear
		If res.Rows.Size > 0 Then
			For Each re() As Object In res.Rows
				Dim idperingatan As Int	 = re(res.Columns.Get("idperingatan"))
				Dim judul As String		 = re(res.Columns.Get("judul"))
				Dim keterangan As String= re(res.Columns.Get("keterangan"))
				Dim jam As String		= re(res.Columns.Get("jam"))
				clv.AddTextItem(generateText(judul,keterangan, jam),idperingatan)
			Next
		Else
			clv.AddTextItem(Utils.textDataTidakAda,0)
		End If
	Else
		clv.AddTextItem(Utils.textDataTidakDitemukan,0)
	End If
	
'	For i = 0 To 1
'	
'		clv.AddTextItem(generateText("Peringatan Dini Cuaca DIY Tanggal 19 Februari 2020 Pukul 13.30 WIB.", _
'			"Berpotensi terjadi hujan dengan intensitas sedang - lebat yang dapat disertai kilat/petir dan angin kencang pada pukul 14.00 WIB di wilayah Sleman (Sleman, Tempel, Ngaglik), Kulon Progo (Samigaluh, Kalibawang) dan dapat meluas ke wilayah Sleman lainnya (Minggir, Sayegan, Mlati, Moyudan, Godean, Depok, Kalasan), Kulon Progo (Girimulyo, Nanggulan).  Kondisi ini diprakirakan akan berlangsung hingga pukul 15.30 WIB.  Prakirawan - BMKG DIY https://www.bmkg.go.id/peringatan-dini/?p=xyx520200219", _
'			"24 Des 2021 19:40"),1)
'			
''	Dim p As Phone    '<----Add phone Library
''	Log( p.SdkVersion)
''	If p.SdkVersion >= 26 Then
''		Private jo As JavaObject = Label1
''		jo.RunMethod("setJustificationMode", Array As Object(1))
''	End If
'	Next
End Sub

Private Sub generateText(judul As String, detail As String, jam As String) As CSBuilder
	Dim cs As CSBuilder
		cs.Initialize
		cs.Bold.Color(Colors.Black).Size(18).Append(judul).PopAll.Append(CRLF)
		cs.Color(0xFF3C3C3C).Size(14).Append("Update Jam : ").Append(jam).PopAll.Append(CRLF)
		cs.Color(Colors.Black).Size(16).Append(detail).PopAll
	Return cs
End Sub