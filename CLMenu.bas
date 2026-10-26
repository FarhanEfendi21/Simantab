B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	
	
	Type menuData (FileName As String, Title As String, tag As String)
	
	Dim jmlMenu As Int = 12
	Dim mLokasi(jmlMenu) As String '= Array as String("support.png")
	Dim mDesc(jmlMenu)  As String
	Dim mTag(jmlMenu)  As String
	
	Private clv As CustomListView
	Private Panel1 As Panel
	Private Panel2 As Panel
	Private Panel3 As Panel
	Private ImageView1 As ImageView
	Private ImageView2 As ImageView
	Private ImageView3 As ImageView
	Private Label1 As Label
	Private Label2 As Label
	Private Label3 As Label
	
	Private badger1 As Badger
	
	Dim api1 As Api
	Private CustomListView1 As CustomListView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	api1.Initialize
	badger1.Initialize
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("layMenu")
	
	Appear
End Sub

Private Sub Appear
	Utils.deleteBadgeDate
	tempData
	createCLV
	setListBadge
End Sub


'You can see the list of page related events in the B4XPagesManager object. The event name is B4XPage.
Sub tempData
		mLokasi(0)	=  "1.png"
		mDesc(0)	= "Paman Lepi"
		mTag(0)		= 0
		
		mLokasi(1)	=  "2.png"
		mDesc(1)	= "Pandu Timan"
		mTag(1)		= 1
		
		mLokasi(2)	=  "3.png"
		mDesc(2)	= "Dewi Lepi"
		mTag(2)		= 2
		
		mLokasi(3)	=  "4.png"
		mDesc(3)	= "Lapor Kak Todar"
		mTag(3)		= 3
		
		mLokasi(4)	=  "5.png"
		mDesc(4)	= "Merapi Live"
		mTag(4)		= 4
		
		mLokasi(5)	=  "6.png"
		mDesc(5)	= "History Kak Todar"
		mTag(5)		= 5
		
		mLokasi(6)	=  "7.png"
		mDesc(6)	= "No Telephone"
		mTag(6)		= 6
		
		mLokasi(7)	=  "8.png"
		mDesc(7)	= "Interman"
		mTag(7)		= 7
		
		mLokasi(8)	=  "9.png"
		mDesc(8)	= "Atensi Informasi"
		mTag(8)		= 8
		
		mLokasi(9)	=  "lola.png"
		mDesc(9)	= "Silola"
		mTag(9)		= 9
	
		mLokasi(10)	=  "lola.png"
		mDesc(10)	= "Tanya SiGumi"
		mTag(10)	= 10
		
'	For i = 0 To jmlMenu - 7
'		mLokasi(i)	=  "Lapor Bencana Sleman.png"
'		mDesc(i)	= "Lapor Bencana"
'		mTag(i)		= i
'	Next
End Sub

Private Sub createCLV
	Dim tData As Int
	tData = Ceil(jmlMenu / 3) - 1
'	Log(tData)
	For i = 0 To tData
		Dim md(3) As menuData
		For x = 0 To 2
			Dim mindex As Int  = 3*i + x
			md(x).Initialize
			md(x) =  CreatemenuDaata(mLokasi(mindex),mDesc(mindex), mTag(mindex))
		Next
		clv.Add(createItems(md),i)
	Next
End Sub

Public Sub CreatemenuDaata (FileName As String, Title As String, tag As String) As menuData
	Dim t1 As menuData
	t1.Initialize
	t1.FileName = FileName
	t1.Title = Title
	t1.tag = tag
	Return t1
End Sub

Sub createItems( dt() As menuData) As Panel
'	Dim p As B4XView = xui.CreatePanel("")
'	Dim height As Int = 2DIP
'	Dim width As Int = 100%x
'	p.SetLayoutAnimated(0, 0, 0, width, height)
'	p.LoadLayout("LitemMenu")
'	Panel1.Visible = False
''	Panel3.Color = Colors.Green
'	Panel2.Visible = False
'	Panel3.Visible = False
'	For i = 0 To dt.Length - 1
'		If dt(i).Title = Null Or dt(i).Title.Length = 0 Then Exit
'		Utils.AdjustImageViewBmp(getIV(i),loadImage(dt(i).FileName))
'		getLB(i).Text = dt(i).Title
'		getPN(i).Tag = dt(i).tag
'		getPN(i).Visible = True
'	Next
'
'	p.Height = Panel1.Height + 8dip
'	Return p

	Dim p As B4XView = xui.CreatePanel("")
	Dim height As Int = 2DIP
	Dim width As Int = 100%x
	p.SetLayoutAnimated(0, 0, 0, width, height)
	p.LoadLayout("LitemMenu")
	Panel1.Visible = False
'	Panel3.Color = Colors.Green
	Panel2.Visible = False
	Panel3.Visible = False
	For i = 0 To dt.Length - 1
		If dt(i).Title = Null Or dt(i).Title.Length = 0 Then Exit
		Try
			Utils.AdjustImageViewBmp(getIV(i),loadImage(dt(i).FileName))
		Catch
			Log(LastException.Message)
		End Try
		getLB(i).Text = dt(i).Title
		getPN(i).Tag = dt(i).tag
		getPN(i).Visible = True
	Next

	p.Height = Panel1.Height + 8dip
	Return p
	
End Sub

Sub loadImage(iname As String) As Bitmap
	Return LoadBitmap(File.DirAssets,  iname)
End Sub


Sub getPN(p As Int) As Panel
	Dim pn As Panel
	Select p
		Case 0
			pn = Panel1
		Case 1
			pn = Panel2
		Case 2
			pn = Panel3
	End Select
	Return pn
End Sub

Sub getIV(p As Int) As ImageView
	Dim iv As ImageView
	Select p
		Case 0
			iv = ImageView1
		Case 1
			iv = ImageView2
		Case 2
			iv = ImageView3
	End Select
	Return iv
End Sub

Sub getLB(p As Int) As Label
	Dim lb As Label
	Select p
		Case 0
			lb = Label1
		Case 1
			lb = Label2
		Case 2
			lb = Label3
	End Select
	Return lb
End Sub

Private Sub panelMenu_Click
	Dim p As Panel = Sender
	Dim dt As Int = p.Tag
	Log(p)
	Select dt
		Case  0
			CallSub(ActHome, "gotoJarakMerapi")
		Case 1
			CallSub(ActHome, "gotoDataPengungsian")
		Case 2
			CallSub(ActHome, "gotoWisata")
			Main.kvs.Put("badgedelete","ok")
			badger1.SetBadge(Panel3,0)
		Case 3
			CallSub(ActHome, "gotoLaporBencana")
		Case 4
			Dim l As PhoneIntents
			StartActivity (l.OpenBrowser("http://bpbd-sleman.online"))
		Case 5
			CallSub(ActHome, "gotoHistoryBencana")
		Case 6
			CallSub(ActHome, "gotoTelpPenting")
		Case 7
			CallSub(ActHome, "gotoPeringatanDini")
		Case 8
			CallSub(ActHome, "gotoAtensi")
		Case 9
			CallSub(ActHome, "gotologpal")
		Case 10
			CallSub(ActHome, "gotoChatbot")
		Case 11
			StartActivity(ActCamera)
		Case 12
'			CallSub(ActHome, "gotoKML")
			
	End Select
End Sub

Private Sub setBadge(jml As Int, pn As Panel)
	If Main.kvs.Get("badgepedi") <> Null Then
		badger1.SetBadge(pn, jml)
	End If
End Sub

Private Sub setListBadge
	If Main.kvs.Get("badgedelete") = Null Then
		Wait For (api1.SelectData("get_badge_peringatan_dini",Null)) complete (val As resJrdc)
		If val.success Then
			Dim res As DBResult = val.res
			If res.Rows.Size > 0 Then
				For Each re() As Object In res.Rows
					Dim idd As String = re(res.Columns.Get("pedi"))
				Next
				Main.kvs.Put("badgepedi", idd)
				Main.kvs.Put("badgedate", DateTime.DateParse(DateTime.Date(DateTime.Now)))
				setBadge(idd,Panel3)
			End If
		End If
End If
End Sub

