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
	Private gmapExtra As GoogleMapsExtras 'ignore
	Private MapFragment1 As MapFragment
'	Private rp As RuntimePermissions
	
'	Private MapReady As Boolean
	Dim parser As SaxParser
	Dim parserRKB As SaxParser
	Dim TempName,TempAllCoords,TempCoords As String
	Dim TempAllList,SafeList As List
	Dim NameCount As Int
	Dim warna As String
	Dim api1 As Api
	Private Label1 As Label
	Dim warnaGaris, warnaBlock, jarakCircle As String
	
'	Dim nameKRB(1) As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	parser.Initialize
	parserRKB.Initialize
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

Private Sub getDataKML As ResumableSub
	Wait For(api1.SelectData("get_kml",Null)) complete (result As resJrdc)
	If result.success Then
		Dim res As DBResult = result.res
		If res.Rows.Size > 0 Then
			
			Dim listData As List
			listData.Initialize
			
			For Each re() As Object In res.Rows
				Dim url As String = re(res.Columns.Get("file"))
				Dim nama As String ' = re(res.Columns.Get("file"))
				Dim tipe As String = re(res.Columns.Get("type"))
				Dim namax As String
				Try
				Dim name() As String = Regex.Split("\/",url)
					namax = name(name.Length - 1) 
				Catch
					namax = "no_data"
				End Try
				If tipe = "kml" Then
					
					nama = "kml_" & namax
				Else If tipe = "radius" Then
					nama = "radius_" & namax
				End If
				listData.Add(nama)
				If File.Exists(File.DirInternalCache,nama) = False Then
					wait for(downloadKMLCache(url,nama)) complete (cm As Boolean)
					If cm = False Then
						listData.RemoveAt(listData.IndexOf(nama))
					End If
				End If
			Next
			parsing(listData)
		End If
	End If
	
	Return True
End Sub



Private Sub downloadKMLCache(url As String, filename As String) As ResumableSub
'	Log(url)
'	Log(filename)
	Dim j As HttpJob
	j.Initialize("", Me)
	j.Download(url)
	Wait For (j) JobDone(j As HttpJob)
	If j.Success Then
		Dim out As OutputStream = File.OpenOutput(File.DirInternalCache, filename, False)
		File.Copy2(j.GetInputStream, out)
		out.Close 
	End If
	j.Release
	Return j.Success
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
	getDataKML
	Try
		Do While Starter.locationFLP.IsInitialized = False
			Sleep(100)
		Loop
		
		Do While Starter.locationFLP.Latitude = 0
			Sleep(100)
		Loop

		Dim cp As CameraPosition
		cp.Initialize(Starter.locationFLP.Latitude, Starter.locationFLP.Longitude,11)
		gmap.AnimateCamera(cp)
		Dim jarakSaya As Double = 0
		
		jarakSaya = Utils.GetSimpleDistanceInMetersBetweenTwoLatLons(Starter.locationFLP.Latitude, Starter.locationFLP.Longitude, Main.latMerapi, Main.lonMerapi)
		jarakSaya = jarakSaya / 1000
		LokasiAman(jarakSaya)
		
		Dim bmp As Bitmap
		bmp.InitializeSample(File.DirAssets,"location.png",40dip,40dip)
		gmap.AddMarker3(Starter.locationFLP.Latitude, Starter.locationFLP.Longitude,"",bmp)
	Catch
		Utils.ShowToastTengah("Lokasi anda tidak ditemukan")
	End Try
End Sub

Sub parsing(l As List) As ResumableSub
	
	
	For i = 0 To l.Size - 1
		If l.Get(i).As(String).StartsWith("kml") Then
			Try
				Dim ixn As InputStream
				ixn = File.OpenInput(File.DirInternalCache,l.Get(i).As(String))
				Dim tr As TextReader
				tr.Initialize(ixn)
				parserRKB.Parse2(tr,"parserrkb")
				ixn.Close
			Catch
				Utils.ShowToastTengah("Data tidak ditemukan")
			End Try
		Else If l.Get(i).As(String).StartsWith("radius") Then
			Try
				Dim in As InputStream
				in = File.OpenInput(File.DirInternalCache, l.Get(i).As(String))
				Dim tr As TextReader
				tr.Initialize(in)
				parser.Parse2(tr,"Parser")
				in.Close
			Catch
				Utils.ShowToastTengah("Data tidak ditemukan")
			End Try
		End If
	Next
	
	Return True
End Sub

Sub Parserrkb_EndElement (Uri As String, Name As String, Text As StringBuilder)
	Try
	If parserRKB.Parents.IndexOf("LineStyle") > -1 Then
		If Name = "color" Then
			warnaGaris = Text.ToString
			If warnaGaris.Length = 8 Then
				warnaGaris = warnaGaris.SubString2(2,warnaGaris.Length)
			End If
		End If
	End If
	
	If parserRKB.Parents.IndexOf("PolyStyle") > -1 Then
		If Name = "color" Then
			warnaBlock = Text.ToString
			If warnaBlock.Length = 8 Then
				warnaBlock = warnaBlock.SubString2(2,warnaBlock.Length)
			End If
		End If
	End If

	If parserRKB.Parents.IndexOf("Document") > -1 Then
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
			jarakCircle = Text.ToString
		End If
		If Name = "coordinates" Then
			SafeList.Initialize
			TempAllCoords=Text.ToString.Trim
			TempCoords=TempAllCoords.Replace(" ","")
			TempCoords=TempCoords.Replace("0 ","")
			TempCoords=TempCoords.Replace($"0
"$,"")
			TempAllList.Initialize
			TempAllList=Regex.Split(",",TempCoords)
			For i=0 To TempAllList.Size - 2 Step 2
				Dim ln As LatLng
				ln.Initialize(TempAllList.Get(i+1),TempAllList.Get(i))
				SafeList.Add(ln)
			Next
			DrawPolygon(warnaGaris,SafeList,warnaBlock)
			Sleep(0)
			NameCount=0
			Sleep(0)
		End If
	End If
	Catch
		Utils.ShowToastTengah("Data tidak ditemukan")
	End Try
End Sub



Sub Parser_EndElement (Uri As String, Name As String, Text As StringBuilder)
	Try
	If parser.Parents.IndexOf("LineStyle") > -1 Then
		If Name = "color" Then
			warnaGaris = Text.ToString
			If warnaGaris.Length = 8 Then
				warnaGaris = warnaGaris.SubString2(2,warnaGaris.Length)
			End If
		End If
	End If
	
	If parser.Parents.IndexOf("PolyStyle") > -1 Then
		If Name = "color" Then
			warnaBlock = Text.ToString
			If warnaBlock.Length = 8 Then
				warnaBlock = warnaBlock.SubString2(2,warnaBlock.Length)
			End If
		End If
	End If
'	Dim mulai As Int = 0
	Dim mulai As Int = 0
	Dim lt, lng As Float
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
			jarakCircle = Text.ToString
		End If
	
		If warna.Length = 0 Then
			warna = "DC0000"
		End If
		
		If Name = "coordinates" Then
			
			SafeList.Initialize
			TempAllCoords=Text.ToString.Trim
			TempCoords=TempAllCoords.Replace(" ","")
			TempCoords=TempCoords.Replace("0 ","")
			TempCoords=TempCoords.Replace($"0
"$,"")
			TempAllList.Initialize
			TempAllList=Regex.Split(",",TempCoords)
			
			For i=0 To TempAllList.Size - 2 Step 2
				If mulai = 0 Then
					lt = TempAllList.Get(i+1)
					lng = TempAllList.Get(i)
				End If
				Dim ln As LatLng
				ln.Initialize(TempAllList.Get(i+1),TempAllList.Get(i))
				SafeList.Add(ln)
			Next
			
			If mulai = 0 Then
				addtextMaker(lt,lng,jarakCircle)
			End If
			mulai = mulai + 1
			DrawRadius(warnaGaris,SafeList)
			Sleep(0)
			NameCount=0
			Sleep(0)
		End If
	End If
	Catch
		Utils.ShowToastTengah("Data tidak ditemukan")
	End Try
End Sub

Sub DrawPolygon (clr As String, PointList As List, stockColor As String )
	
	
	
	Dim GoogleMapsExtras1 As GoogleMapsExtras
	Dim polygonoptions1 As PolygonOptions
	polygonoptions1.Initialize
	polygonoptions1.FillColor = Utils.HexToColor("4C" & stockColor)
	polygonoptions1.AddPoints(PointList)
'	polygonoptions1.StrokeColor=0xFFAB0000
	polygonoptions1.StrokeColor=Utils.HexToColor("4C" & clr)
	polygonoptions1.StrokeWidth=3
'	polygonoptions1.
	
	Dim pg As Polygon = GoogleMapsExtras1.AddPolygon(gmap, polygonoptions1)
End Sub

Sub addtextMaker(lat As Float, lng As Float, text As String)
	Dim bmp As Bitmap = TextToBitmap(DipToCurrent(100),xui.CreateDefaultFont(10), xui.Color_Black, text)
'	Dim bmp As B4XBitmap = CreateBitmap(text)
	Dim m As Marker = gmap.AddMarker3(lat, lng ,"", bmp)
	Dim x As MarkerExtras
	x.SetAnchor(m, 0, 0.5)
End Sub


Sub TextToBitmap (Width As Int, Fnt As B4XFont, Clr As Int, Text As Object) As B4XBitmap
	Dim lbl As Label
	lbl.Initialize("")
	Dim x As B4XView = lbl
	x.Font = Fnt
	x.TextColor = Clr
	x.SetLayoutAnimated(0, 0, 0, Width, 0)
	Dim su As StringUtils
	x.Height = su.MeasureMultilineTextHeight(x, Text)
	x.Text = Text
	Return x.Snapshot
End Sub

Sub DrawRadius (clr As String, PointList As List)
	Dim GoogleMapsExtras1 As GoogleMapsExtras
	Dim polygonoptions1 As PolygonOptions
	polygonoptions1.Initialize
	polygonoptions1.FillColor = 0x00FFFFFF
	polygonoptions1.AddPoints(PointList)
'	polygonoptions1.StrokeColor=0xFFAB0000
	polygonoptions1.StrokeColor=Utils.HexToColor("4C" & clr)
	polygonoptions1.StrokeWidth=3
	Dim pg As Polygon = GoogleMapsExtras1.AddPolygon(gmap, polygonoptions1)
End Sub


Private Sub LokasiAman (jarakSaya As Double)
	Wait For (api1.SelectData("get_jarak",Null)) complete (result As resJrdc)
'	Log(result.success)
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
			Label1.Text =	StatusMerapi(jarakAman, statusAktifitas, Rekomendasi, jarakSaya)
		Else
			Label1.Text = StatusMerapiKosong(jarakSaya)
		End If
	End If
End Sub

Private Sub StatusMerapi(jarak As String, status As String, rek As String, jarakSaya As Double) As CSBuilder
	Dim cs As CSBuilder
	CallSubDelayed2(Starter,"notifBablas",jarakSaya)
	cs.Initialize
	cs.Color(0xFF2B2B2B).Bold.Size(16).Alignment("ALIGN_CENTER").Append("STATUS MERAPI : ").Append(status.ToUpperCase).PopAll
	cs.Color(0xFF2B2B2B).Size(14).Append(CRLF).Append(CRLF).Append("JARAK AMAN : ").Append(jarak).Append(" KM").PopAll
	'cs.Color(0xFF2B2B2B).Size(14).Append(CRLF).Append(CRLF).Append("KETINGGIAN : ").Append(ketinggian).Append(" Mdpl").PopAll
	cs.Color(0xFF2B2B2B).Size(14).Append(CRLF).Append("REKOMENDASI : ").PopAll
	cs.Color(0xFF2B2B2B).Size(14).Append(CRLF).Append(rek).Append(CRLF).PopAll
	cs.Color(0xFF2B2B2B).Size(14).Append(CRLF).Append("JARAK ANDA DARI MERAPI : " & Utils.DisplayDouble("de", "DE",jarakSaya)).Append(" KM").PopAll
	
	If jarakSaya <= jarak Then
		cs.Color(Colors.Red).Bold.Size(16).Append(CRLF).Append("SAAT INI ANDA BERADA DI ZONA TIDAK AMAN").Append(CRLF).PopAll
	Else
		cs.Color(0xFF2B2B2B).Bold.Size(16).Append(CRLF).Append("SAAT INI ANDA BERADA DI ZONA AMAN."& CRLF &"JANGAN LENGAH, TETAP WASPADA DAN PATUHI ARAHAN").Append(CRLF).PopAll
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