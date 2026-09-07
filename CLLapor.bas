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
	
	Private etDescription As EditText
	Private spnBencana As Spinner
	
	Dim mBencana As Map
	Private clv As CustomListView
	Private iv1 As B4XImageView
	Private iv2 As B4XImageView
	Private iv3 As B4XImageView
	Private Panel1 As Panel
	Private Panel2 As Panel
	Private Panel3 As Panel
	
	Private const iconPlus As String = "kamera.png"
	Public paijo As String
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	'Log("MASUK SINI")

	mBencana.Initialize
	Api1.Initialize
'	xui.SetDataFolder("image")
'	Log(xui.DefaultFolder)
	kobis
	DeleteFolder(xui.DefaultFolder & "/image")
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("LayLapor")
	
	Appear
End Sub

Private Sub Appear
	etDescription.Color = Colors.Transparent
	createBencana
	loadImageData
End Sub

Sub createBencana
	Wait For (Api1.SelectData("get_listbencana",Null)) complete (result As resJrdc)
	If result.success Then
		spnBencana.Clear
		mBencana.Clear
		spnBencana.Add("Pilih bencana")
		Dim res As DBResult = result.res
		For Each re() As Object In res.Rows
			Dim id As Int		= re(res.Columns.Get("id"))
			Dim nama As String 	= re(res.Columns.Get("nama"))
			
			mBencana.Put(nama,id)
			spnBencana.Add(nama)
		Next
	End If
End Sub




Public Sub loadImageData
	Dim lfname As List
	lfname.Initialize
	lfname.Add(iconPlus)
'	Log(xui.DefaultFolder)
	Dim l As List = File.ListFiles(xui.DefaultFolder & "/image")

'	xui.de
	For x = 0 To l.Size - 1
'		Log(l.Get(x))
		If l.Get(x).As(String).EndsWith(".jpg") Then
			lfname.Add(l.Get(x))
		Else If l.Get(x).As(String).EndsWith(".png") Then
			lfname.Add(l.Get(x))
		End If
		
		
	Next
	
	Dim tData As Int
	tData = Ceil(lfname.Size / 3) - 1
	clv.Clear
	For i = 0 To tData
		Dim md(3) As String
		For t = 0 To 2
			Dim mindex As Int  = 3*i + t
			
			md(t) = lfname.Get(mindex)
			If (lfname.Size - 1) = mindex Then Exit
				
				
		Next
		clv.Add(createListImage(md),i)
	Next
End Sub


Private Sub createListImage(filename() As String) As Panel
	Dim width As Int = clv.AsView.Width
	Dim p As B4XView = xui.CreatePanel("")
	p.SetLayoutAnimated(0, 0,  0, width , 1dip)

	p.LoadLayout("layItemsImage")
	
	Panel1.Visible = False

	Panel2.Visible = False
	Panel3.Visible = False
	For i = 0 To filename.Length - 1
		If File.IsDirectory(xui.DefaultFolder & "/image",  filename(i)) = False Then
			If filename(i) <>  iconPlus Then
				Dim x As B4XBitmap = Utils.RotateBitmap(loadImage(filename(i)),90)
			Else
				Dim x As B4XBitmap =loadImage(filename(i))
			End If
			getIV(i,x,filename(i))
'			slee
'			Log("sini berapa kali")
'			Panel
		End If
	Next
	p.Color = Colors.White
	p.SetLayoutAnimated(0, 0, 0, width, Panel1.Top + Panel1.Height + 10dip)
	Return p
	
End Sub

private Sub getIV(p As Int, x As B4XBitmap, nama As String) 'As B4XImageView
'	Dim iv As B4XImageView
	Select p
		Case 0
			Panel1.Visible = True
			Panel1.Tag = nama
			iv1.Bitmap = x
			iv1.ResizeMode = "FILL_NO_DISTORTIONS"
			iv1.mBase.Visible = True
		Case 1
			Panel2.Visible = True
			Panel2.Tag = nama
			iv2.Bitmap = x
			iv2.ResizeMode = "FILL_NO_DISTORTIONS"
			iv2.mBase.Visible = True
		Case 2
			Panel3.Visible = True
			Panel3.Tag = nama
			iv3.Bitmap = x
			iv3.ResizeMode = "FILL_NO_DISTORTIONS"
			iv3.mBase.Visible = True
	End Select
'	iv1.ta
'	Return iv
End Sub

Sub loadImage(iname As String) As B4XBitmap
	Dim x As B4XBitmap
	If iname <> iconPlus Then
		x = xui.LoadBitmapResize(xui.DefaultFolder & "/image",iname,Panel1.Width, Panel1.Height, True)
'		x = xui.LoadBitmap(xui.DefaultFolder,  iname)
	Else
		x =  xui.LoadBitmap(File.DirAssets,  iname)
	End If
	Return x
End Sub

Private Sub panelImg_Click
	Dim p As Panel = Sender
	If p.Tag <> iconPlus Then
		If p.Tag.As(String).EndsWith(".jpg") Then
			ActHome.fileZoom = p.Tag
			StartActivity(ActImageView)
			CallSubDelayed(ActImageView,"setImage")
		End If
	Else
		StartActivity(ActCamera)
	End If
End Sub

Private Sub prepareFileUpload As List
	Dim lData As List
	lData.Initialize
	Dim l As List = File.ListFiles(xui.DefaultFolder & "/image")
	For x = 0 To l.Size - 1
		If l.Get(x).As(String).EndsWith(".jpg") Or l.Get(x).As(String).EndsWith(".mp4") Then
			lData.Add(l.Get(x))
		End If
	Next
	Return lData
End Sub


'Private Sub btnSimpan_Click
'
'	If spnBencana.SelectedIndex = 0 Then
'		Utils.ShowToastTengah("Silahkan pilih bencana")
'	else If etDescription.Text.Trim.Length = 0 Then
'		Utils.ShowToastTengah("Keterangan bencana belum di isi")
'		etDescription.RequestFocus
'	Else
'		ProgressDialogShow2("Menyimpan data....",False)
'		Wait For(Api1.uploadImage(xui.DefaultFolder & "/image", prepareFileUpload)) complete (resUpload As Boolean)
'		If resUpload Then
'			'insert header
'			Dim idUser As Int = Main.kvs.GetEncrypted("iduser", Main.kunci)
'			Dim lat As Float = 0
'			Dim lon As Float = 0
'			If Starter.locationFLP.IsInitialized Then
'				lat = Starter.locationFLP.Latitude
'				lon = Starter.locationFLP.Latitude
'			End If	
'			
'			Dim paramHeader As Object
'			paramHeader = Array As Object(idUser,mBencana.Get(spnBencana.SelectedItem),  lat,lon,idUser, etDescription.Text)
'			Wait For (Api1.ExeData("insert_laporan",paramHeader)) complete (resHeader As resJrdc)
'			If resHeader.success Then
'				Dim lastID As Int = 0
'				Wait For (Api1.SelectData("lastidlaporan",Array(idUser))) complete (resLastID As resJrdc)
'				If resLastID.success Then
'					Dim resID As DBResult = resLastID.res
'					For Each re() As Object In resID.Rows
'						lastID = re(resID.Columns.Get("maxid"))
'					Next
'					
'					If prepareFileUpload.Size > 0 Then
'						Dim insertBatch As List
'						insertBatch.Initialize
'						For i = 0 To prepareFileUpload.Size - 1
'							Dim tipe As Int
'							If prepareFileUpload.Get(i).As(String).EndsWith("jpg") Then
'								tipe = 1
'							Else	
'								tipe = 2
'							End If	
'							Dim dbCmd As DBCommand = Api1.CreateCommand("insert_image",Array(lastID,prepareFileUpload.Get(i), tipe))
'							insertBatch.Add(dbCmd)
'						Next
'						
'						Wait For (Api1.ExeDataBatch(insertBatch)) complete (result As resJrdc)
'						If result.success Then
'							Utils.ShowToastTengah("Data berhasil disimpan")
''							DeleteFolder(xui.DefaultFolder & "/image")
'							ProgressDialogHide
'							btnClear_Click
'						Else
'							ProgressDialogHide
'							Utils.ShowToastTengah("Data gagal disimpan")
'						End If
'					End If
'				Else
'					ProgressDialogHide
'					Utils.ShowToastTengah("Data gagal disimpan")
'				End If
'			Else
'				ProgressDialogHide
'				Utils.ShowToastTengah("Data gagal disimpan")
'			End If
'		Else
'			ProgressDialogHide
'			Utils.ShowToastTengah("Media gagal di upload")
'		End If
'	End If
'End Sub

'Private Sub btnClear_Click
'	DeleteFolder(xui.DefaultFolder & "/image")
'	spnBencana.SelectedIndex = 0
'	etDescription.Text = ""
'	Sleep(100)
'	loadImageData
'End Sub

Private Sub DeleteFolder (folder As String)
'	Main.kvs.Put("lastdelcache",DateTime.Now)
	For Each f As String In File.ListFiles(folder)
		If File.IsDirectory(folder, f) Then
			DeleteFolder(File.Combine(folder, f))
		End If
		File.Delete(folder, f)
	Next
End Sub

Private Sub btnhapus_Click
	DeleteFolder(xui.DefaultFolder & "/image")
	spnBencana.SelectedIndex = 0
	etDescription.Text = ""
	Sleep(100)
	loadImageData
End Sub

Private Sub btnkirim_Click
	If spnBencana.SelectedIndex = 0 Then
		Utils.ShowToastTengah("Silahkan pilih bencana")
	else If etDescription.Text.Trim.Length = 0 Then
		Utils.ShowToastTengah("Keterangan bencana belum di isi")
		etDescription.RequestFocus	
		
	Else
		ProgressDialogShow2("Menyimpan data....",False)
		Wait For(Api1.uploadImage(xui.DefaultFolder & "/image", prepareFileUpload)) complete (resUpload As Boolean)
		If resUpload Then
			'insert header
			Dim idUser As Int = Main.kvs.GetEncrypted("iduser", Main.kunci)
			Dim lat As Float = 0
			Dim lon As Float = 0
			If Starter.locationFLP.IsInitialized Then
				lat = Starter.locationFLP.Latitude
				lon = Starter.locationFLP.Longitude
			End If
			
			If lat=0 And lon=0 Then
				xui.MsgboxAsync ("Koordinat Kosong, Aktifkan Lokasi Anda!","")
				etDescription.RequestFocus
				ProgressDialogHide
				Return
			End If
			
			Dim paramHeader As Object
			paramHeader = Array As Object(idUser,mBencana.Get(spnBencana.SelectedItem),  lat,lon,idUser, etDescription.Text)
			Wait For (Api1.ExeData("insert_laporan",paramHeader)) complete (resHeader As resJrdc)
			If resHeader.success Then
				Dim lastID As Int = 0
				Wait For (Api1.SelectData("lastidlaporan",Array(idUser))) complete (resLastID As resJrdc)
				If resLastID.success Then
					Dim resID As DBResult = resLastID.res
					For Each re() As Object In resID.Rows
						lastID = re(resID.Columns.Get("maxid"))
					Next
										
					If prepareFileUpload.Size > 0 Then
						Dim insertBatch As List
						insertBatch.Initialize
						For i = 0 To prepareFileUpload.Size - 1
							Dim tipe As Int
							If prepareFileUpload.Get(i).As(String).EndsWith("jpg") Then
								tipe = 1
							Else
								tipe = 2
							End If
							Dim dbCmd As DBCommand = Api1.CreateCommand("insert_image",Array(lastID,prepareFileUpload.Get(i), tipe))
							insertBatch.Add(dbCmd)
						Next
						
						Wait For (Api1.ExeDataBatch(insertBatch)) complete (result As resJrdc)
						If result.success Then
							Utils.ShowToastTengah("Data berhasil disimpan")
							notifadmin("admin","Laporan Baru",spnBencana.SelectedItem)
							DeleteFolder(xui.DefaultFolder & "/image")
							ProgressDialogHide
							btnhapus_Click
						Else
							ProgressDialogHide
							Utils.ShowToastTengah("Data gagal disimpan")
						End If
					End If
				Else
					ProgressDialogHide
					Utils.ShowToastTengah("Data gagal disimpan")
				End If
			Else
				ProgressDialogHide
				Utils.ShowToastTengah("Data gagal disimpan")
			End If
		Else
			ProgressDialogHide
			Utils.ShowToastTengah("Media gagal di upload, Silahkan Lakukan Pengambilan Foto!")
		End If
	End If
	
End Sub

Sub kobis
	Wait For (Api1.SelectData("svrKey",Null)) complete (result As resJrdc)
	Log("status : " & result.success)
	If result.success Then
		Dim res As DBResult = result.res
		For Each re() As Object In res.Rows
			Public nama As String 	= re(res.Columns.Get("nama"))
		Next
		paijo=nama
		Log("key :" & paijo)
	End If
End Sub

Sub notifadmin(topic As String,title As String, body As String)
	Dim m As Map = CreateMap("to": $"/topics/${topic}"$)
	Dim data As Map = CreateMap("title": title, "body": body)
	
	m.Put("data", data)
	m.Put("priority", 10)
	
	Dim jg As JSONGenerator
	jg.Initialize(m)
	Dim j As HttpJob
	j.Initialize("", Me)
	j.PostString("https://fcm.googleapis.com/fcm/send",jg.ToString)
	j.GetRequest.SetContentType("application/json;charset=UTF-8")
	j.GetRequest.SetHeader("Authorization", "key=" & paijo)
	Wait For (j) JobDone(j As HttpJob)
	If j.Success Then
		Log(j.GetString)
		'Log(paijo)
	End If
	j.Release
End Sub

