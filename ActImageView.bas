B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=11.2
@EndOfDesignText@
#Region  Activity Attributes 
		#FullScreen: true
	#IncludeTitle: false
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Dim xui As XUI
	Private lbBack As Label
	Private lbDelete As Label
	Private HugeImageView1 As HugeImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("layZoomImage")
	
End Sub

Sub Activity_Resume
	
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub setImage
	HugeImageView1.SetBitmap(xui.DefaultFolder & "/image",ActHome.fileZoom)
End Sub


Private Sub lbBack_Click
	Activity.Finish
End Sub

Private Sub lbDelete_Click
	File.Delete(xui.DefaultFolder & "/image",ActHome.fileZoom)
	CallSubDelayed(ActHome,"resumeImage")
	Sleep(1000)
	Activity.Finish
End Sub