B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private ContentScroll As ScrollView
	Private HighContrast As Boolean
	Private FontScale As Float = 1
	Private LanguageCode As String = "id"
	Private FontSeek As SeekBar
	Private FontPercent As Label
	Private FontPreview As Label
	Private FontChangeGeneration As Int
	Private RenderingScreen As Boolean
	Private Const Gold As Int = 0xFFBE9638
	Private Const NormalBackground As Int = 0xFFF4F7F6
	Private Const NormalText As Int = 0xFF26322D
End Sub

Public Sub Initialize(p As B4XView)
	Root = p
End Sub

Public Sub createLayout
	LoadPreferences
	RenderScreen
End Sub

Private Sub LoadPreferences
	Dim saved As Object = Main.kvs.Get("access_font_scale")
	If saved <> Null And IsNumber(saved) Then FontScale = saved
	If FontScale < 0.8 Or FontScale > 2 Then FontScale = 1
	HighContrast = Utils.AccessibilityHighContrast
	Dim savedLanguage As Object = Main.kvs.Get("access_language")
	If savedLanguage <> Null Then LanguageCode = savedLanguage
	If LanguageCode <> "en" Then LanguageCode = "id"
End Sub

Private Sub RenderScreen
	RenderingScreen = True
	Root.RemoveAllViews
	Root.Color = PageBackground
	ContentScroll.Initialize(Max(1dip, Root.Height))
	Root.AddView(ContentScroll, 0, 0, Root.Width, Root.Height)

	Dim y As Int = 12dip
	y = AddIntroCard(y)
	y = AddSectionTitle(TextFor("Ukuran Teks", "Text Size"), y)
	y = AddFontCard(y)
	y = AddSwitchCard("♿", TextFor("Mode Kontras Tinggi", "High Contrast Mode"), _
		TextFor("Meningkatkan perbedaan warna pada layar ini", "Improves color contrast on this screen"), _
		HighContrast, "HighContrast", y)
	y = AddLanguageCard(y)
	y = AddNoteCard(y)
	ContentScroll.Panel.Height = Max(ContentScroll.Height, y + 16dip)
	RenderingScreen = False
End Sub

Private Sub AddIntroCard(y As Int) As Int
	Dim cardWidth As Int = Root.Width - 24dip
	Dim card As Panel = CreateCard(cardWidth, 100dip)
	Dim cardView As B4XView = card
	Dim iconTile As Panel
	iconTile.Initialize("")
	Dim iconTileView As B4XView = iconTile
	Dim iconTileColor As Int = IIf(HighContrast, 0xFFFFCC00, Gold)
	iconTileView.SetColorAndBorder(iconTileColor, 0, iconTileColor, 16dip)
	card.AddView(iconTile, 14dip, 16dip, 48dip, 48dip)
	Dim icon As Label
	icon.Initialize("")
	icon.Text = "♿"
	icon.TextSize = 27
	icon.TextColor = IIf(HighContrast, Colors.Black, Colors.White)
	icon.Gravity = Gravity.CENTER
	iconTile.AddView(icon, 0, 0, 48dip, 48dip)

	Dim title As Label
	title.Initialize("")
	title.Text = TextFor("SiMantab untuk Semua", "SiMantab for Everyone")
	title.TextColor = ForegroundColor
	title.TextSize = 15 * FontScale
	title.Typeface = Typeface.DEFAULT_BOLD
	title.SingleLine = False
	title.Gravity = Gravity.CENTER_VERTICAL
	Dim textLeft As Int = 74dip
	Dim textWidth As Int = cardWidth - textLeft - 14dip
	card.AddView(title, textLeft, 12dip, textWidth, 38dip)
	Dim titleHeight As Int = Max(28dip, Utils.GetTinggiLbl(title) + 4dip)
	title.SetLayoutAnimated(0, textLeft, 12dip, textWidth, titleHeight)

	Dim intro As Label
	intro.Initialize("")
	intro.Text = TextFor("Sesuaikan tampilan agar informasi lebih mudah dibaca dan digunakan.", _
		"Adjust the display to make information easier to read and use.")
	intro.TextColor = SecondaryTextColor
	intro.TextSize = 12 * FontScale
	intro.SingleLine = False
	intro.Gravity = Gravity.TOP
	Dim introTop As Int = 12dip + titleHeight + 3dip
	card.AddView(intro, textLeft, introTop, textWidth, 52dip)
	Dim introHeight As Int = Max(38dip, Utils.GetTinggiLbl(intro) + 4dip)
	intro.SetLayoutAnimated(0, textLeft, introTop, textWidth, introHeight)
	Dim cardHeight As Int = Max(80dip, introTop + introHeight + 14dip)
	cardView.SetLayoutAnimated(0, 0, 0, cardWidth, cardHeight)
	cardView.SetColorAndBorder(CardBackground, 1dip, BorderColor, 12dip)
	ContentScroll.Panel.AddView(card, 12dip, y, cardWidth, cardHeight)
	Return y + cardHeight + 12dip
End Sub

Private Sub AddSectionTitle(title As String, y As Int) As Int
	Dim label As Label
	label.Initialize("")
	label.Text = title
	label.TextColor = ForegroundColor
	label.TextSize = 17 * FontScale
	label.Typeface = Typeface.DEFAULT_BOLD
	label.Gravity = Gravity.CENTER_VERTICAL
	ContentScroll.Panel.AddView(label, 18dip, y, Root.Width - 36dip, 38dip)
	Return y + 42dip
End Sub

Private Sub AddFontCard(y As Int) As Int
	Dim card As Panel = CreateCard(Root.Width - 24dip, 152dip)
	Dim smallA As Label
	smallA.Initialize("")
	smallA.Text = "A"
	smallA.TextColor = ForegroundColor
	smallA.TextSize = 14
	smallA.Gravity = Gravity.CENTER
	card.AddView(smallA, 12dip, 12dip, 30dip, 32dip)
	Dim largeA As Label
	largeA.Initialize("")
	largeA.Text = "A"
	largeA.TextColor = ForegroundColor
	largeA.TextSize = 24
	largeA.Typeface = Typeface.DEFAULT_BOLD
	largeA.Gravity = Gravity.CENTER
	card.AddView(largeA, card.Width - 42dip, 12dip, 30dip, 32dip)
	FontSeek.Initialize("FontSeek")
	FontSeek.Max = 12
	FontSeek.Value = Round((FontScale - 0.8) * 10)
	card.AddView(FontSeek, 42dip, 12dip, card.Width - 84dip, 32dip)
	FontPercent.Initialize("")
	FontPercent.Text = NumberFormat(FontScale * 100, 1, 0) & "%"
	FontPercent.TextColor = ForegroundColor
	FontPercent.TextSize = 12
	FontPercent.Gravity = Gravity.CENTER
	card.AddView(FontPercent, 12dip, 48dip, card.Width - 24dip, 24dip)
	FontPreview.Initialize("")
	FontPreview.Text = TextFor("Contoh teks yang lebih mudah dibaca", "A sample of easier-to-read text")
	FontPreview.TextColor = ForegroundColor
	FontPreview.TextSize = 15 * FontScale
	FontPreview.SingleLine = False
	FontPreview.Gravity = Gravity.CENTER
	card.AddView(FontPreview, 12dip, 76dip, card.Width - 24dip, 60dip)
	Dim cardView As B4XView = card
	cardView.SetColorAndBorder(CardBackground, 1dip, BorderColor, 12dip)
	ContentScroll.Panel.AddView(card, 12dip, y, Root.Width - 24dip, 152dip)
	Return y + 164dip
End Sub

Private Sub FontSeek_ValueChanged(Value As Int, UserChanged As Boolean)
	FontScale = 0.8 + (Value / 10)
	UpdateFontPreview
	If UserChanged = False Then Return
	FontChangeGeneration = FontChangeGeneration + 1
	Dim requestId As Int = FontChangeGeneration
	Sleep(800)
	If requestId <> FontChangeGeneration Then Return
	Dim dialog As Object = xui.Msgbox2Async("Terapkan ukuran teks " & NumberFormat(FontScale * 100, 1, 0) & "%?", _
		"Konfirmasi ukuran teks", "Terapkan", "", "Batal", Null)
	Wait For (dialog) Msgbox_Result (Result As Int)
	If requestId <> FontChangeGeneration Then Return
	If Result = xui.DialogResponse_Positive Then
		Main.kvs.Put("access_font_scale", FontScale)
		RenderScreen
	Else
		FontScale = Utils.AccessibilityFontScale
		FontSeek.Value = Round((FontScale - 0.8) * 10)
		UpdateFontPreview
	End If
End Sub

Private Sub UpdateFontPreview
	FontPercent.Text = NumberFormat(FontScale * 100, 1, 0) & "%"
	FontPreview.TextSize = 15 * FontScale
	FontPreview.Height = Max(60dip, 34dip * FontScale)
End Sub

Private Sub AddSwitchCard(iconText As String, title As String, subtitle As String, checked As Boolean, eventName As String, y As Int) As Int
	Dim card As Panel = CreateCard(Root.Width - 24dip, 88dip)
	Dim icon As Label
	icon.Initialize("")
	icon.Text = iconText
	icon.TextSize = 24
	icon.Gravity = Gravity.CENTER
	card.AddView(icon, 8dip, 12dip, 42dip, 56dip)
	Dim titleLabel As Label
	titleLabel.Initialize("")
	titleLabel.Text = title
	titleLabel.TextColor = ForegroundColor
	titleLabel.TextSize = 14 * FontScale
	titleLabel.Typeface = Typeface.DEFAULT_BOLD
	titleLabel.Gravity = Gravity.CENTER_VERTICAL
	card.AddView(titleLabel, 54dip, 10dip, card.Width - 128dip, 30dip)
	Dim subtitleLabel As Label
	subtitleLabel.Initialize("")
	subtitleLabel.Text = subtitle
	subtitleLabel.TextColor = SecondaryTextColor
	subtitleLabel.TextSize = 11 * FontScale
	subtitleLabel.SingleLine = False
	subtitleLabel.Gravity = Gravity.TOP
	card.AddView(subtitleLabel, 54dip, 40dip, card.Width - 128dip, 38dip)
	Dim toggle As CheckBox
	toggle.Initialize(eventName)
	toggle.Checked = checked
	If HighContrast Then toggle.Color = 0xFFFFCC00
	card.AddView(toggle, card.Width - 66dip, 23dip, 50dip, 42dip)
	Dim cardView As B4XView = card
	cardView.SetColorAndBorder(CardBackground, 1dip, BorderColor, 12dip)
	ContentScroll.Panel.AddView(card, 12dip, y, Root.Width - 24dip, 88dip)
	Return y + 100dip
End Sub

Private Sub HighContrast_CheckedChange(Checked As Boolean)
	If RenderingScreen Then Return
	HighContrast = Checked
	Main.kvs.Put("access_high_contrast", HighContrast)
	RenderScreen
	CallSub(ActHome, "ApplyAccessibilityTheme")
End Sub

Private Sub AddLanguageCard(y As Int) As Int
	Dim card As Panel = CreateCard(Root.Width - 24dip, 92dip)
	Dim title As Label
	title.Initialize("")
	title.Text = TextFor("Bahasa", "Language")
	title.TextColor = ForegroundColor
	title.TextSize = 14 * FontScale
	title.Typeface = Typeface.DEFAULT_BOLD
	title.Gravity = Gravity.CENTER_VERTICAL
	card.AddView(title, 14dip, 10dip, card.Width - 28dip, 26dip)
	Dim subtitle As Label
	subtitle.Initialize("")
	subtitle.Text = IIf(LanguageCode = "en", "English", "Bahasa Indonesia")
	subtitle.TextColor = SecondaryTextColor
	subtitle.TextSize = 11 * FontScale
	subtitle.Gravity = Gravity.CENTER_VERTICAL
	card.AddView(subtitle, 14dip, 42dip, 126dip, 34dip)
	Dim idButton As Button
	idButton.Initialize("LanguageSelect")
	idButton.Tag = "id"
	idButton.Text = "ID"
	idButton.TextSize = Utils.AccessibilityFontSize(12)
	If HighContrast Then
		idButton.Color = 0xFFFFCC00
		idButton.TextColor = Colors.Black
	End If
	card.AddView(idButton, card.Width - 118dip, 42dip, 48dip, 36dip)
	Dim enButton As Button
	enButton.Initialize("LanguageSelect")
	enButton.Tag = "en"
	enButton.Text = "EN"
	enButton.TextSize = Utils.AccessibilityFontSize(12)
	If HighContrast Then
		enButton.Color = 0xFFFFCC00
		enButton.TextColor = Colors.Black
	End If
	card.AddView(enButton, card.Width - 62dip, 42dip, 48dip, 36dip)
	Dim cardView As B4XView = card
	cardView.SetColorAndBorder(CardBackground, 1dip, BorderColor, 12dip)
	ContentScroll.Panel.AddView(card, 12dip, y, Root.Width - 24dip, 92dip)
	Return y + 104dip
End Sub

Private Sub LanguageSelect_Click
	Dim button As Button = Sender
	LanguageCode = button.Tag
	Main.kvs.Put("access_language", LanguageCode)
	RenderScreen
End Sub

Private Sub AddNoteCard(y As Int) As Int
	Dim note As Label
	note.Initialize("")
	note.Text = TextFor("Tersedia dalam Bahasa Indonesia dan Inggris. Pengubahan ukuran teks ditampilkan pada pratinjau di atas.", _
		"Available in Indonesian and English. The text-size adjustment is shown in the preview above.")
	note.TextColor = SecondaryTextColor
	note.TextSize = 11 * FontScale
	note.SingleLine = False
	note.Gravity = Gravity.CENTER
	ContentScroll.Panel.AddView(note, 18dip, y, Root.Width - 36dip, 58dip)
	Return y + 66dip
End Sub

Private Sub CreateCard(width As Int, height As Int) As Panel
	Dim card As Panel
	card.Initialize("")
	card.SetLayoutAnimated(0, 0, 0, width, height)
	Dim cardView As B4XView = card
	cardView.SetColorAndBorder(CardBackground, 1dip, BorderColor, 12dip)
	Return card
End Sub

Private Sub TextFor(indonesian As String, english As String) As String
	If LanguageCode = "en" Then Return english
	Return indonesian
End Sub

Private Sub PageBackground As Int
	If HighContrast Then Return Colors.Black
	Return NormalBackground
End Sub

Private Sub CardBackground As Int
	If HighContrast Then Return 0xFF101010
	Return Colors.White
End Sub

Private Sub ForegroundColor As Int
	If HighContrast Then Return Colors.White
	Return NormalText
End Sub

Private Sub SecondaryTextColor As Int
	If HighContrast Then Return 0xFFE0E0E0
	Return 0xFF5B665F
End Sub

Private Sub BorderColor As Int
	If HighContrast Then Return Colors.White
	Return 0xFFE0E5E2
End Sub
