B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=12.5
@EndOfDesignText@
Sub Class_Globals
	
	Private Button1 As B4XView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

Private Sub Button1_Click
	CallSub(Main,"gotologin")
End Sub

Private Sub Button2_Click
	CallSub(Main,"gotoregister")
End Sub