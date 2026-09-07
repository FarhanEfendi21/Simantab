B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=12.5
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	Public ActionBarHomeClicked As Boolean
	Public CorrectHeight As Int
	Public HeightChangedFired As Boolean
End Sub

Sub Globals

End Sub

Sub Activity_Create(FirstTime As Boolean)
	Dim ime As IME
	ime.Initialize("ime")
	ime.AddHeightChangedEvent
	Dim pm As B4XPagesManager
	pm.Initialize(Activity)
	CorrectHeight = 100%y
	Wait For ime_HeightChanged (NewHeight As Int, OldHeight As Int)
	CorrectHeight = NewHeight
	HeightChangedFired = True
End Sub

Sub ime_HeightChanged (NewHeight As Int, OldHeight As Int)
	
End Sub