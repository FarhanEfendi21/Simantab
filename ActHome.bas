B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=11.2
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region
#Extends: android.support.v7.app.AppCompatActivity
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Public fileZoom As String
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Dim vp As AHViewPager
	Dim vpPanels(3) As Panel
	Dim ToolBar As ACToolBarDark
	Private ABHelper As ACActionBar
	Dim container As AHPageContainer
	
	Dim mMenu As CLMenu
	Dim mJarakMerapi As CLJarakMerapiKML
	Dim mLapor As CLLapor
	Dim mPeringatanDini As CLPeringatanDini
	Dim mTelpPenting As CLTelpPenting
	Dim mPengungsian As CLDataPengungsian
	Dim mAtensi As CLAtensi
	Dim mHistoryBencana As CLHistoryBencana
	Dim mWisata As CLWisata
	Dim mDataLogistik As CLDataLogistik
	Dim mDataPeralatan As CLDataPeralatan
	Dim mSubMenu As CLSubMenu
	Dim mChatbot As CLChatbot
	Dim mEdukasi As CLEdukasi
	Dim mAksesibilitas As CLAksesibilitas
	
	Dim rp As RuntimePermissions
	
	Dim api1 As Api
	Dim xui As XUI
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	
	If FirstTime Then
		If File.Exists(xui.DefaultFolder & "/image","") = False Then
			File.MakeDir(xui.DefaultFolder, "image")
		End If
	End If
	api1.Initialize
	ToolBar.Initialize("Toolbar")
	ToolBar.SetAsActionBar
	ABHelper.Initialize
	ABHelper.ShowUpIndicator=False
	ToolBar.Title = "Sistem Informasi Sleman Tangguh Bencana"
'	ToolBar.Title= titleAPP
'	ToolBar.SubTitle= translate(1)
	Activity.AddView(ToolBar,0,0,100%X,56dip)
	ApplyAccessibilityTheme
	ToolBar.InitMenuListener
	InitVP0
	
	mMenu.Initialize(vpPanels(0))
	mMenu.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(0))
End Sub

Sub Activity_Resume	
	If Main.kvs.GetEncrypted("iduser", Main.kunci) = Null Then
		ToastMessageShow("Seasion sudah habis, silahkan login kembali",False)
		StartActivity(Main)
		Activity.Finish
	End If
	
	rp.CheckAndRequest("android.permission.ACCESS_FINE_LOCATION")
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)
	If Result Then
		Starter.StartFLP
	End If
	
	Dim in As Intent
	in = Activity.GetStartingIntent
	If in.HasExtra("Notification_Tag") Then
		Log(in.GetExtra("Notification_Tag")) 'Will log the tag
		Dim tujuan As String = in.GetExtra("Notification_Tag")
		Select tujuan
			Case "jarak_merapi"
				gotoJarakMerapi
			Case "peringatan_dini"
				gotoPeringatanDini
		End Select
	End If
	
End Sub

Sub Activity_Pause (UserClosed As Boolean)
	Starter.StopFLP
End Sub

Sub Activity_Resize (Width As Int, Height As Int)
	If vp.IsInitialized Then
		vp.SetLayoutAnimated(0, 0, ToolBar.Height, Width, Height - ToolBar.Height)
	End If
	If mChatbot.IsInitialized Then mChatbot.Resize
End Sub

Sub Activity_KeyPress (KeyCode As Int) As Boolean 'Return True to consume the event
	If KeyCode = KeyCodes.KEYCODE_BACK Then
		Toolbar_NavigationItemClick
		Return True
	End If
	Return False
End Sub

Sub Activity_PermissionResult (Permission As String, Result As Boolean)

End Sub

Sub Toolbar_NavigationItemClick
	If vp.CurrentPage = 0 Then
		Activity.Finish
	Else
		If vp.CurrentPage = 1 Then
			ApplyAccessibilityTheme
			mMenu.Initialize(vpPanels(0))
			mMenu.createLayout
			Utils.ApplyAccessibilityTree(vpPanels(0))
		End If
		vp.GotoPage(vp.CurrentPage - 1, True)
		ABHelper.ShowUpIndicator = False
		ToolBar.Title = "Sistem Informasi Sleman Tangguh Bencana"
	End If
End Sub

Public Sub ApplyAccessibilityTheme
	Activity.Color = Utils.AccessibilityPanelColor(Colors.White)
	If Utils.AccessibilityHighContrast Then
		ToolBar.Color = Colors.Black
	Else
		ToolBar.Color = 0xFFBE9638
	End If
	ToolBar.TitleTextColor = Colors.White
End Sub

Sub InitVP0
	container.Initialize
	For i = 0 To vpPanels.Length-1
		vpPanels(i).Initialize("")
		container.AddPage(vpPanels(i),"")
	Next
		
	vp.Initialize2(container, "vp")
	
	Dim TabsHeight As Int=0

	Activity.AddView(vp, 0, ToolBar.Height+TabsHeight, Activity.Width, Activity.Height-ToolBar.Height-TabsHeight)
	vp.PagingEnabled=False
	vp.OffscreenPageLimit=4
	vp.CurrentPage=0
	
End Sub

Public Sub gotoJarakMerapi
	Dim rp As RuntimePermissions
	rp.CheckAndRequest("android.permission.ACCESS_FINE_LOCATION")
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)

	If Result Then
		vpPanels(1).RemoveAllViews
		mJarakMerapi.Initialize(vpPanels(1))
		mJarakMerapi.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
		vp.GotoPage(1,True)
	Else
		ToastMessageShow("Perlu mengaktifkan ijin lokasi",False)
	End If
End Sub

Public Sub gotoLaporBencana
	vpPanels(1).RemoveAllViews
	mLapor.Initialize(vpPanels(1))
	mLapor.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub gotoPeringatanDini
	vpPanels(1).RemoveAllViews
	mPeringatanDini.Initialize(vpPanels(1))
	mPeringatanDini.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub gotoTelpPenting
	rp.CheckAndRequest("android.permission.CALL_PHONE")
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)
	If Result Then
		vpPanels(1).RemoveAllViews
		mTelpPenting.Initialize(vpPanels(1))
		mTelpPenting.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
		vp.GotoPage(1,True)
	Else
		Utils.ShowToastTengah("Tidak ada izin untuk melakukan panggilan. Panggilan telpon langsung menggunakan applikasi tidak dapat digunakan.")
		vpPanels(1).RemoveAllViews
		mTelpPenting.Initialize(vpPanels(1))
		mTelpPenting.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
		vp.GotoPage(1,True)
	End If
End Sub

Public Sub gotoDataPengungsian
'	Dim rp As RuntimePermissions
	rp.CheckAndRequest("android.permission.ACCESS_FINE_LOCATION")
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)

	If Result Then
		vpPanels(1).RemoveAllViews
		mPengungsian.Initialize(vpPanels(1))
		mPengungsian.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
		vp.GotoPage(1,True)
	Else
		ToastMessageShow("Perlu mengaktifkan ijin lokasi",False)
	End If
End Sub

Public Sub gotoWisata
'	Dim rp As RuntimePermissions
	rp.CheckAndRequest("android.permission.ACCESS_FINE_LOCATION")
	Wait For Activity_PermissionResult (Permission As String, Result As Boolean)

	If Result Then
		vpPanels(1).RemoveAllViews
		mWisata.Initialize(vpPanels(1))
		mWisata.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
		vp.GotoPage(1,True)
	Else
		ToastMessageShow("Perlu mengaktifkan ijin lokasi",False)
	End If
End Sub

Public Sub gotoAtensi
	vpPanels(1).RemoveAllViews
	mAtensi.Initialize(vpPanels(1))
	mAtensi.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub gotoHistoryBencana
	vpPanels(1).RemoveAllViews
	mHistoryBencana.Initialize(vpPanels(1))
	mHistoryBencana.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub gotologpal
	vpPanels(1).RemoveAllViews
	mSubMenu.Initialize(vpPanels(1))
	mSubMenu.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub gotoDataLogistik
	vpPanels(1).RemoveAllViews
	mDataLogistik.Initialize(vpPanels(1))
	mDataLogistik.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub gotoDataPeralatan
	vpPanels(1).RemoveAllViews
	mDataPeralatan.Initialize(vpPanels(1))
	mDataPeralatan.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub gotoKML
	Dim mKML As CLJarakMerapiKML
	vpPanels(1).RemoveAllViews
	mKML.Initialize(vpPanels(1))
	mKML.createLayout
	Utils.ApplyAccessibilityTree(vpPanels(1))
	vp.GotoPage(1,True)
End Sub

Public Sub resumeImage
'	Log("dsa")
'	Log("dsa")
	If mLapor.IsInitialized Then
		mLapor.loadImageData
	End If
End Sub

Public Sub gotoChatbot
	vpPanels(1).RemoveAllViews
	mChatbot.Initialize(vpPanels(1))
	mChatbot.createLayout
	Utils.ApplyAccessibilityContrastTree(vpPanels(1))
	ToolBar.Title = "Tanya SiMantab"
	ABHelper.ShowUpIndicator = True
	vp.GotoPage(1, True)
End Sub

Public Sub gotoEdukasi
	vpPanels(1).RemoveAllViews
	mEdukasi.Initialize(vpPanels(1))
	mEdukasi.createLayout
	ToolBar.Title = "Edukasi Bencana"
	ABHelper.ShowUpIndicator = True
	vp.GotoPage(1, True)
End Sub

Public Sub gotoAksesibilitas
	vpPanels(1).RemoveAllViews
	mAksesibilitas.Initialize(vpPanels(1))
	mAksesibilitas.createLayout
	ToolBar.Title = "Aksesibilitas Inklusif"
	ABHelper.ShowUpIndicator = True
	vp.GotoPage(1, True)
End Sub
