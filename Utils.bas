B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=11.2
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.
Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.

End Sub

'clr : FFD38100, FFBE9638,
'text : FF2B2B2B
'round : FF7C7C7C

Sub RotateBitmap (bmp As B4XBitmap, Degrees As Float) As B4XBitmap
	Dim xui As XUI
	Dim cvs As B4XCanvas
	Dim panel As B4XView = xui.CreatePanel("")
	panel.SetLayoutAnimated(0, 0, 0, bmp.Width, bmp.Height)
	cvs.Initialize(panel)
	cvs.DrawBitmapRotated(bmp, cvs.TargetRect, Degrees)
	cvs.Invalidate
	Dim b As B4XBitmap = cvs.CreateBitmap
	cvs.Release
	Return b
End Sub

Sub AdjustImageViewBmp(Imv As ImageView, bmp As Bitmap)
'	Private bmp As Bitmap = LoadBitmap(Dir, FileName)
 
	Dim Delta, Height, Width As Int
	If bmp.Width / bmp.Height > Imv.Width / Imv.Height Then
		Height = bmp.Height / bmp.Width * Imv.Width
		Delta = (Imv.Height - Height) / 2
		Imv.Height = Height
		Imv.Top = Imv.Top + Delta
	Else
		Width = bmp.Width / bmp.Height * Imv.Height
		Delta = (Imv.Width - Width) / 2
		Imv.Width = Width
		Imv.Left = Imv.Left + Delta
	End If
	Imv.Gravity = Gravity.FILL
	Imv.Bitmap = bmp
'	bmp.Resize(Imv.Width / 10,Imv.Height / 10,True)
End Sub

Public Sub HexToColor(Hex As String) As Int
	Dim bc As ByteConverter
	If Hex.StartsWith("#") Then
		Hex = Hex.SubString(1)
	Else If Hex.StartsWith("0x") Then
		Hex = Hex.SubString(2)
	End If
'	Log(Hex)
	Dim ints() As Int = bc.IntsFromBytes(bc.HexToBytes(Hex))
	Return ints(0)
End Sub


Sub ShowToastTengah( text As String)
	Try
	Dim x As Int
	Dim y As Int
	Dim longDuration As Boolean
	x = 0
	y = 50%y
	longDuration = False
	Dim duration As Int
	If longDuration = True Then
		duration = 1
	Else
		duration = 0
	End If
	Dim ctxt As JavaObject
	ctxt.InitializeContext
	Dim toastJO As JavaObject
	toastJO = toastJO.InitializeStatic("android.widget.Toast").RunMethod("makeText", Array(ctxt, text, duration))
	toastJO.RunMethod("setGravity", Array(Bit.Or(Gravity.CENTER_HORIZONTAL, Gravity.top), x, y))
	toastJO.RunMethod("show", Null)
	Dim v As View = toastJO.RunMethod("getView", Null)
	Dim cd As ColorDrawable
	cd.Initialize(0xFF7E7E7E, 20dip)
	v.Background = cd
	Catch
		ToastMessageShow(text,False)
	End Try
	
End Sub

Public Sub debugArrayDB(param() As Object) As String
	Dim lo As String = ""
	If param <> Null Then
	For p = 0 To param.Length - 1
		lo = lo &"'" & param(p) &"',"
	Next
	lo = lo.SubString2(0,lo.Length - 1)
	End If
	Return lo
End Sub


Sub ErrorJRDC(value As String) As String 'ignore
	Dim m As Matcher = Regex.Matcher("<title>(.*?)</title>", value)
	Dim result As String
	result = ""
	Do While m.Find
'		Log("Match: " & m.Match)
		For g = 1 To m.GroupCount
			result= m.Group(g)
			
		Next
	Loop
	Return result
End Sub

Sub debugArray(data() As String) 'ignore
	For i = 0 To data.Length - 1
		Log(i &" : "& data(i))
	Next
End Sub

Sub StringToZero(val As Object) As Double 'ignore
	Dim angka As Double
	If IsNumber(val) Then
		angka = val
	Else
		angka = 0
	End If
	Return angka
End Sub

Sub encryptMD5(val As String) As String 'ignore
	Dim md As MessageDigest
	Dim ByteCon As ByteConverter
	Dim passwordhash() As Byte
	passwordhash = md.GetMessageDigest(val.GetBytes("UTF8"),"MD5")
	Dim md5string As String
	md5string = ByteCon.HexFromBytes(passwordhash)
	Return md5string.ToLowerCase
End Sub

Sub getInfo As String
	Dim ph As Phone
	Dim text As String
	text = $"MANUFACTURE : ${ph.Manufacturer}
MODEL : ${ph.Model}
PRODUCT : ${ph.Product}
SDK VERSION :  ${ph.SdkVersion}
OPERATOR :  ${ph.GetNetworkOperatorName}
"$
	Return text
End Sub

Sub ValidateEmail(EmailAddress As String) As Boolean  'Ignore
	Dim MatchEmail As Matcher = Regex.Matcher("^(?i)[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$", EmailAddress)
 
	If MatchEmail.Find = True Then
		'Log(MatchEmail.Match)
		Return True
	Else
		'Log("Oops, please double check your email address...")
		Return False
	End If
End Sub

'METER
Public Sub GetSimpleDistanceInMetersBetweenTwoLatLons(lat1 As Double, lon1 As Double, lat2 As Double, lon2 As Double) As Double
	Dim Deg2Rad As Double = 2*cPI/360
	Dim R As Double = 6371e3
	Dim phi1 As Double = lat1 * Deg2Rad
	Dim phi2 As Double = lat2 * Deg2Rad
	Dim deltaphi As Double = phi2-phi1
	Dim deltalambda As Double = (lon2-lon1) * Deg2Rad
	Dim sindeltaphihalf As Double = Sin(deltaphi/2)
	Dim sindeltalambdahalf As Double = Sin(deltalambda/2)
	Dim a As Double = sindeltaphihalf * sindeltaphihalf + Cos(phi1) * Cos(phi2) * sindeltalambdahalf * sindeltalambdahalf
	Dim c As Double = 2 * ATan2(Sqrt(a), Sqrt(1-a))
	Return R*c
End Sub

Sub DisplayDouble(language As String, region As String, Number As Double) As String
	Dim jo As JavaObject
	jo = jo.InitializeNewInstance("java.util.Locale.Builder", Null)
	Dim locale As JavaObject = jo.RunMethodJO("setLanguage", Array As Object(language)).RunMethodJO("setRegion", Array As Object(region)).RunMethod("build", Null)
	Dim numberFormatter As JavaObject = jo.InitializeStatic("java.text.NumberFormat").RunMethod("getNumberInstance", Array As Object(locale))
	Dim retVal As String = numberFormatter.RunMethod("format", Array As Object(Number))
	Return retVal
End Sub

Public Sub deleteBadgeDate
	If Main.kvs.Get("badgedate") <> Null Then
	Dim tfl As Long = Main.kvs.Get("badgedate")
		
	If tfl <  DateTime.DateParse(DateTime.Date(DateTime.Now)) Then
			Main.kvs.Remove("badgepedi")
			Main.kvs.Remove("badgedate")
		End If
	End If
End Sub

Public Sub deleteBadge
	Try
		If Main.kvs.Get("badgedelete") = "ok" Then
			Main.kvs.Put("badgepedi",0)
	'		Main.kvs.Remove("badgedate")
		Else
			Main.kvs.Remove("badgepedi")
			Main.kvs.Remove("badgedate")
		End If
	Catch
		Main.kvs.Remove("badgepedi")
		Main.kvs.Remove("badgedate")
	End Try
End Sub

Sub textDataTidakAda As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(0xFF2B2B2B).Size(16).Alignment("ALIGN_CENTER").Append("Tidak ada data.").PopAll
	Return cs
End Sub

Sub textDataTidakDitemukan As CSBuilder
	Dim cs As CSBuilder
	cs.Initialize
	cs.Color(0xFF2B2B2B).Size(16).Alignment("ALIGN_CENTER").Append("Data tidak ditemukan.").PopAll
	Return cs
End Sub

Sub GetTinggiLbl(label As Label) As Int
	Dim su As StringUtils
	Return su.MeasureMultilineTextHeight(label, label.Text)
End Sub

' Converts image to JPEG byte array. Ability to resize and adjust JPEG quality.
' Negative width and height values = %, such that -50 = 50% and -200 = 200%
' Positive width and height values = pixel dimensions
' If one value (either width or height) are 0, then the other value is proportionally
'  calculated from the first.
' If both width and height are 0 or -100, no resizing takes place
' If quality = -1, use default quality of 75
' Will return a zero length byte array if something is wrong with the parameters
Sub XUIImageToJPEGByteArray(aImage As Object, width As Int, height As Int, quality As Int) As Byte() 'ignore
	'Sanity check quality
	If (quality < -1 And quality > 100) Then
		'Log("Parameter quality not in range (-1..100)")
		Return Array As Byte ()
	End If
	If quality = -1 Then quality = 75

	'Sanity check incoming image
	Try
		Dim image As B4XBitmap = aImage
	Catch
		'Log(LastException)
		Return Array As Byte ()
	End Try
  
	'Sanity check incoming image dimensions
	Dim oldWidth As Int = image.Width
	Dim oldHeight As Int = image.Height
	If (oldWidth = 0 And oldHeight = 0 ) Then
		'Log("Source image with incorrect dimensions")
		Return Array As Byte ()
	End If

	'See if were resizing the image
	Dim  resize As Boolean = True
	If ((width = 0 And height = 0) Or (width = -100 Or height = -100)) Then resize = False
  
	'Resize if necessary
	If (resize) Then
		Dim newWidth As Int = width
		Dim newHeight As Int = height
		'Calculate new dimensions
		If (newWidth < 0) Then newWidth = -1 * oldWidth * newWidth / 100
		If (newHeight < 0) Then newHeight = -1 * oldHeight * newHeight / 100
		If (newWidth = 0) Then newWidth = oldWidth * newHeight / oldHeight
		If (newHeight = 0 ) Then newHeight = oldHeight * newWidth / oldWidth
		image = image.Resize(newWidth, newHeight, False)
	End If
  
	'Convert image to JPEG byte array
	Dim out As OutputStream
	out.InitializeToBytesArray(0)
	image.WriteToStream(out, quality, "JPEG")
	out.Close
  
	'Done
	Return out.ToBytesArray
End Sub

Sub BytesToFile (Dir As String, FileName As String, Data() As Byte)
	Dim out As OutputStream = File.OpenOutput(Dir, FileName, False)
	out.WriteBytes(Data, 0, Data.Length)
	out.Close
End Sub

Sub resizeImage(dir As String,fName As String)
'	Log(fName)
	Dim xui As XUI
	Dim bImage As B4XBitmap
	bImage = xui.LoadBitmap(dir, fName)
	Dim c() As Byte = XUIImageToJPEGByteArray(bImage, -30, 0, 60)
	'https://www.b4x.com/android/forum/threads/b4x-bytes-to-file.70111/#content
'	BytesToFile(dir, "_" & fName, c)
	BytesToFile(dir, fName, c)
End Sub
