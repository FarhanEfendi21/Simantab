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
	
	Private gmap As GoogleMap
	Private MapFragment1 As MapFragment
	Private clv As CustomListView
	
	'DETAIL
	Private lbBGList As Label
	Private pBGList As Panel
	
	'MAKER
	Dim Markers As Map
	Dim mak As Marker
	Dim FakeMark As Marker
	Dim InfoWindowPanel As B4XView
	Private lbMaker As Label
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	Log("Data pengungsian")
	Api1.Initialize
	Markers.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("layDataPengungsian")
	
	Appear
End Sub

Private Sub Appear
	Wait For (InitializeMap) Complete (Success As Boolean)
	If Success Then
		If Starter.locationFLP.IsInitialized Then
		Dim cp As CameraPosition
		cp.Initialize(Starter.locationFLP.Latitude, Starter.locationFLP.Longitude,15)
		gmap.AnimateCamera(cp)
		End If
		initPanel
		Wait For (loadData)Complete (scs As Boolean)
	End If
'	Log(scs)
End Sub

Private Sub InitializeMap As ResumableSub
	Wait For gmap_Ready
	gmap = MapFragment1.GetMap
	If gmap.IsInitialized Then
		gmap.MyLocationEnabled = True
	End If
	Return gmap.IsInitialized
End Sub

Private Sub loadData As ResumableSub
	Wait For (Api1.SelectData("get_databarak",Null)) complete (result As resJrdc)
	clv.Clear
	If result.success Then
		Dim res As DBResult = result.res
		If res.Rows.Size > 0 Then
			
			Markers.Clear
			gmap.Clear
			
			Dim bmp As Bitmap
			bmp.InitializeSample(File.DirAssets,"camping-tent.png",40dip,40dip)
			
			For Each re() As Object In res.Rows
				Dim nama As String 			= re(res.Columns.Get("nama"))
				Dim alamat As String		= re(res.Columns.Get("alamat"))
				Dim tlpn As String			= re(res.Columns.Get("tlpn"))
				Dim deskripsi As String		= re(res.Columns.Get("deskripsi"))
'				Dim picture_name As String	= re(res.Columns.Get("picture_name"))
				Dim latitude As String		= re(res.Columns.Get("latitude"))
				Dim longitude As String		= re(res.Columns.Get("longitude"))
				
				mak = gmap.AddMarker3(latitude, longitude, nama,bmp)
				mak.Snippet = tlpn & CRLF & alamat & CRLF & deskripsi
				Markers.Put(mak, mak)
				
				clv.Add(createListItem(nama,alamat,tlpn),mak)
				Sleep(0)
			Next
			FakeMark = gmap.AddMarker(0,0,"Fake")
			FakeMark.Snippet=0
			FakeMark.InfoWindowShown=True
			FakeMark.Remove
		Else
			clv.AddTextItem(Utils.textDataTidakAda,0)
		End If
	Else
		clv.AddTextItem(Utils.textDataTidakDitemukan,0)
	End If
	
	Return True
End Sub

private Sub createListItem(nama As String, alamat As String, tlpn As String) As Panel
	Dim width As Int = clv.AsView.Width
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0,  0, width , 1dip)

	p.LoadLayout("layDataPengungsianItems")
	lbBGList.Text = createName(nama,alamat,tlpn)
	lbBGList.Height = Utils.GetTinggiLbl(lbBGList) 
	pBGList.Height = lbBGList.Height + 15DIP
	
	
	p.SetLayoutAnimated(0, 0, 0, width, pBGList.Top + pBGList.Height )
	Return p
End Sub

Sub createName(nama As String, alamat As String, phone_number As String) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(Colors.Black).Bold.Size(16).Append(nama).Append(CRLF).PopAll
	If phone_number <> "0" And phone_number.Trim.Length > 0 Then
		cs.Color(Colors.Black).Size(14).Append("Telpon : " & phone_number).Append(CRLF).PopAll
	End If
	cs.Color(Colors.Black).Size(14).Append(alamat).PopAll
	Return cs
End Sub



Private Sub CLV_ItemClick (Index As Int, Value As Object)
	MapFragment1_MarkerClick(Value)

	clv.GetPanel(Index).Color = Colors.White
	Dim pnl As Panel = clv.GetPanel(Index)
	Dim pnl1 As Panel = pnl.GetView(0)
	pnl1.Color = Colors.White
	clv.JumpToItem(Index)
	
	setColorCLV(Index)
End Sub

Sub setColorCLV (index As Int)
	For i = 0 To clv.Size - 1
		If i <> index Then
			Dim pnl As Panel = clv.GetPanel(i)
			Dim pnl1 As Panel = pnl.GetView(0)
			pnl1.Color = 0xFFE3DCDC
		End If
	Next
End Sub

Sub initPanel
	Dim GoogleMapsExtras1 As GoogleMapsExtras
	Dim InfoWindowAdapter1 As InfoWindowAdapter
		
	Dim OnInfoWindowClickListener1 As OnInfoWindowClickListener
	OnInfoWindowClickListener1.Initialize("OnInfoWindowClickListener1")
		
	If OnInfoWindowClickListener1.IsInitialized Then
		GoogleMapsExtras1.SetOnInfoWindowClickListener(gmap, OnInfoWindowClickListener1)
	Else
		'Log("OnInfoWindowClickListener1 is not initialized - check that the Activity contains a Click callback Sub")
	End If
		
	Dim OnMyLocationButtonClickListener1 As OnMyLocationButtonClickListener
	OnMyLocationButtonClickListener1.Initialize("OnMyLocationButtonClickListener1")
	GoogleMapsExtras1.SetOnMyLocationButtonClickListener(gmap, OnMyLocationButtonClickListener1)
		
		
	InfoWindowAdapter1.Initialize("InfoWindowAdapter1")
	GoogleMapsExtras1.SetInfoWindowAdapter(gmap, InfoWindowAdapter1)

'		
	InfoWindowPanel = xui.CreatePanel("")
	Root.AddView(InfoWindowPanel, 0, 0, 80%x, 1dip)
	
	InfoWindowPanel.LoadLayout("layPanel")
	InfoWindowPanel.Color = Colors.Transparent
	lbMaker.Color = Colors.Transparent
	InfoWindowPanel.RemoveViewFromParent
End Sub


Sub OnInfoWindowClickListener1_Click(Marker1 As Marker)

End Sub

Sub InfoWindowAdapter1_GetInfoContents(Marker1 As Marker) As View

	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(Colors.White).Bold.Size(14).Append(Marker1.Title).PopAll
	cs.Color(Colors.White).Size(12).Append(CRLF).Append(Marker1.Snippet).PopAll
	
	lbMaker.Text = cs
'	Sleep(0)
	Try
		lbMaker.Height = Utils.GetTinggiLbl(lbMaker)
		InfoWindowPanel.Height = Utils.GetTinggiLbl(lbMaker)
		InfoWindowPanel.Parent.Height = Utils.GetTinggiLbl(lbMaker)
		InfoWindowPanel.Parent.SetColorAndBorder(0xCE373737,2dip, 0xFFD19202, 10DIP)
	Catch
		Log(LastException.Message)
	End Try
	Return InfoWindowPanel
End Sub

Sub MapFragment1_MarkerClick (SelectedMarker As Marker) As Boolean 'Return True to consume the click
	If SelectedMarker.Title = "Set Location" Then
		SelectedMarker.InfoWindowShown = False
		Return True
	Else
		SelectedMarker.InfoWindowShown = True
	End If
	Dim CameraPosition1 As CameraPosition
	CameraPosition1.Initialize(SelectedMarker.Position.Latitude,SelectedMarker.Position.Longitude, 18)
	gmap.MoveCamera(CameraPosition1)
	Return True
End Sub


Sub OnMyLocationButtonClickListener1_MyLocationButtonClick As Boolean

	If gmap.IsInitialized Then

			
	End If
	Return False
End Sub


Private Sub Activity_Click
	
End Sub