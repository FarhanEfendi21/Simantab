B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
#IgnoreWarnings: 9
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	
	Private gmap As GoogleMap
	Private gmapExtra As GoogleMapsExtras
	Private MapFragment1 As MapFragment
'	Private rp As RuntimePermissions
	
'	Private MapReady As Boolean
	Dim parser As SaxParser
	Dim TempName,TempAllCoords,TempCoords As String
	Dim TempAllList,SafeList As List
	Dim NameCount As Int
	Dim warna As String
	
	
	Dim api1 As Api
	
	
	Private Label1 As Label
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	parser.Initialize
	api1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("layJarakMerapi")
	Wait For (InitializeMap) Complete (Success As Boolean)
	If Success Then
		loadData
	End If
End Sub

Private Sub InitializeMap As ResumableSub
	Wait For gmap_Ready
	gmap = MapFragment1.GetMap
	If gmap.IsInitialized Then
		gmap.MyLocationEnabled = True
	End If
	Return gmap.IsInitialized
End Sub

Private Sub loadData
	parsing
	Try
		Do While Starter.locationFLP.IsInitialized = False
			Sleep(100)
		Loop
		
		Do While Starter.locationFLP.Latitude = 0 
			Sleep(100)
		Loop

	'	If Starter.locationFLP.IsInitialized Then
			Dim cp As CameraPosition
			cp.Initialize(Starter.locationFLP.Latitude, Starter.locationFLP.Longitude,11)
			gmap.AnimateCamera(cp)
			Dim jarakSaya As Double = 0
			jarakSaya = Utils.GetSimpleDistanceInMetersBetweenTwoLatLons(Starter.locationFLP.Latitude, Starter.locationFLP.Longitude, Main.latMerapi, Main.lonMerapi)
			jarakSaya = jarakSaya / 1000
			LokasiAman(jarakSaya)
	'	End If
	Catch
		Utils.ShowToastTengah("Lokasi anda tidak ditemukan")
	End Try
	

	Dim co As CircleOptions
	co.Initialize
	co.Center2(Main.latMerapi, Main.lonMerapi).Radius(2000).StrokeColor(Colors.Blue)
	gmapExtra.AddCircle(gmap, co)
	
	co.Initialize
	co.Center2(Main.latMerapi, Main.lonMerapi).Radius(10000).StrokeColor(Colors.Red)
	gmapExtra.AddCircle(gmap, co)
	co.Initialize
	co.Center2(Main.latMerapi, Main.lonMerapi).Radius(15000).StrokeColor(Colors.Green)
	gmapExtra.AddCircle(gmap, co)
End Sub

Sub parsing As ResumableSub
	Dim in As InputStream
'	in = File.OpenInput(File.DirAssets, "zkrb.kml")
	in = File.OpenInput(File.DirAssets, "zkrb.kml")
	Dim tr As TextReader
	tr.Initialize(in)
	parser.Parse2(tr,"Parser")
	
	in.Close
	
	Return True
End Sub


Sub Parser_EndElement (Uri As String, Name As String, Text As StringBuilder)
	If parser.Parents.IndexOf("Document") > -1 Then
		If Name="SimpleData" Then
			If NameCount=0 Then
				TempName=Text.ToString
			End If
			If NameCount=7 Then
				TempName=TempName&"_"&Text.ToString
			End If
			NameCount=NameCount+1
		End If
		
		If Name = "name" Then
			
'			Log(Text.ToString)
		End If
		
		
		If Name = "styleUrl" Then
'			Log(Text.ToString)
			Dim wrn() As String = Regex.Split("-",Text.ToString)
'			Log(wrn.Length)
			If wrn.Length > 0 Then
				warna = wrn(1)
			End If
		End If
		If warna.Length = 0 Then
			warna = "DC0000"
		End If
       
		If Name = "coordinates" Then
			SafeList.Initialize
			TempAllCoords=Text.ToString.Trim
'			TempCoords=TempAllCoords.Replace($"0
			'                "$,"")
'			TempCoords=TempCoords.Replace($"0
			'            "$,"")
			TempCoords=TempAllCoords.Replace(" ","")
			TempCoords=TempCoords.Replace("0 ","")
			TempCoords=TempCoords.Replace($"0
"$,"")
'			Log(TempCoords)
			TempAllList.Initialize
			TempAllList=Regex.Split(",",TempCoords)
'			Log(TempAllList.Size)
'			Log(TempAllList)
			For i=0 To TempAllList.Size - 2 Step 2
				
'				Log(i & " = " & TempAllList.Get(i+1) &", "& TempAllList.Get(i))
				Dim ln As LatLng
				ln.Initialize(TempAllList.Get(i+1),TempAllList.Get(i))

'				gmap.AddMarker(TempAllList.Get(i+1),TempAllList.Get(i),"i")
				SafeList.Add(ln)
			Next
			
'			Log(warna)
'			Log(SafeList)
			DrawPolygon(warna,SafeList)
			Sleep(0)
'			File.WriteList(File.DirRootExternal,TempName&".txt",SafeList)
'			ListView1.AddSingleLine(TempName)
			NameCount=0
		End If
	End If
	'   Msgbox("gambar","")
End Sub

Sub DrawPolygon (clr As String, PointList As List) 
	Dim GoogleMapsExtras1 As GoogleMapsExtras
	Dim polygonoptions1 As PolygonOptions
	polygonoptions1.Initialize
	polygonoptions1.FillColor = Utils.HexToColor("4C" & clr)
	polygonoptions1.AddPoints(PointList)
	polygonoptions1.StrokeColor=0xFFAB0000
	polygonoptions1.StrokeWidth=3
	Dim pg As Polygon = GoogleMapsExtras1.AddPolygon(gmap, polygonoptions1)
End Sub

Private Sub LokasiAman (jarakSaya As Double)
	Wait For (api1.SelectData("get_jarak",Null)) complete (result As resJrdc)
	Log(result.success)
	If result.success Then
		Dim res As DBResult = result.res
		If res.Rows.Size > 0 Then
			For Each re() As Object In res.Rows
				Private jarakAman As Float
				Private statusAktifitas As String
				Private Rekomendasi As String
				jarakAman 		= re(res.Columns.Get("jarakaman"))
				statusAktifitas = re(res.Columns.Get("statusaktivitas"))
				Rekomendasi 	= re(res.Columns.Get("rekomendasi"))
			Next
			Label1.Text =	StatusMerapi(jarakAman,statusAktifitas, Rekomendasi,jarakSaya)
		Else
			Label1.Text = StatusMerapiKosong(jarakSaya)
		End If
	End If
End Sub

Private Sub StatusMerapi(jarak As String, status As String, rek As String, jarakSaya As Double) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(0xFF2B2B2B).Bold.Size(18).Alignment("ALIGN_CENTER").Append("STATUS MERAPI : ").Append(status.ToUpperCase).PopAll
	cs.Color(0xFF2B2B2B).Size(16).Append(CRLF).Append("JARAK AMAN : ").Append(jarak).Append(" KM").PopAll
	cs.Color(0xFF2B2B2B).Size(16).Append(CRLF).Append("REKOMENDASI : ").PopAll
	cs.Color(0xFF2B2B2B).Size(16).Append(CRLF).Append(rek).Append(CRLF).PopAll
	cs.Color(0xFF2B2B2B).Size(18).Append(CRLF).Append("JARAK ANDA DARI MERAPI : " & Utils.DisplayDouble("de", "DE",jarakSaya)).Append(" KM").PopAll
	
	If jarakSaya <= jarak Then
		cs.Color(Colors.Red).Bold.Size(18).Append(CRLF).Append("SAAT INI ANDA BERADA DI ZONA TIDAK AMAN").Append(CRLF).PopAll
	Else
		cs.Color(0xFF2B2B2B).Bold.Size(18).Append(CRLF).Append("SAAT INI ANDA BERADA DI ZONA AMAN."& CRLF &"JANGAN LENGAH, TETAP WASPADA DAN PATUHI ARAHAN").Append(CRLF).PopAll
	End If
	
	Return cs
End Sub


Private Sub StatusMerapiKosong( jarakSaya As Double) As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	
	cs.Color(0xFF2B2B2B).Size(16).Append(CRLF).Append("JARAK ANDA DARI MERAPI : " & Utils.DisplayDouble("de", "DE",jarakSaya)).Append(" KM").Append(CRLF).PopAll
	cs.Color(0xFF2B2B2B).Bold.Size(18).Append(CRLF).Append("SAAT INI ANDA BERADA DI ZONA AMAN."& CRLF &"JANGAN LENGAH, TETAP WASPADA DAN PATUHI ARAHAN").Append(CRLF).PopAll
	Return cs
End Sub