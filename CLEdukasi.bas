B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private scroll As ScrollView
	Private currentTab As Int
	Private tabLabels(3) As Label
	Private expandedGeneral(3) As Boolean
	Private expandedDisability(4) As Boolean
	Private FontSeek As SeekBar
	Private FontPercent As Label
	Private FontPreview As Label
	Private FontScale As Float = 1
	Private FontChangeGeneration As Int
	Private RenderingAccessibilityControls As Boolean
	Private Const SimantabGold As Int = 0xFFBE9638
	Private Const TextDark As Int = 0xFF26322D
	Private Const MutedText As Int = 0xFF5B665F
	Private Const SurfaceColor As Int = 0xFFF4F7F6
End Sub

Public Sub Initialize(p As B4XView)
	Root = p
End Sub

Public Sub createLayout
	Root.RemoveAllViews
	FontScale = Utils.AccessibilityFontScale
	Root.Color = Utils.AccessibilityPanelColor(SurfaceColor)
	currentTab = 0
	expandedGeneral(0) = True
	expandedDisability(0) = True

	Dim tabHeight As Int = 64dip
	Dim strip As Panel
	strip.Initialize("")
	Dim stripView As B4XView = strip
	stripView.SetColorAndBorder(Utils.AccessibilityPanelColor(Colors.White), 1dip, _
		Utils.AccessibilityTextColor(0xFFE6EAE8), 16dip)
	Root.AddView(strip, 12dip, 6dip, Root.Width - 24dip, 52dip)
	Dim tabWidth As Int = (Root.Width - 32dip) / 3
	For i = 0 To 2
		Dim tabView As Label
		tabView.Initialize("EducationTab")
		tabView.Tag = i
		tabView.TextSize = Utils.AccessibilityFontSize(12)
		tabView.Typeface = Typeface.DEFAULT_BOLD
		tabView.Gravity = Gravity.CENTER
		tabView.SingleLine = True
		Select i
			Case 0
				tabView.Text = "Umum"
			Case 1
				tabView.Text = "Anak-anak"
			Case 2
				tabView.Text = "Difabel"
		End Select
		tabLabels(i) = tabView
		strip.AddView(tabView, 4dip + i * tabWidth, 4dip, tabWidth - 2dip, 44dip)
	Next

	Dim scrollHeight As Int = Max(1dip, Root.Height - tabHeight)
	scroll.Initialize(scrollHeight)
	Root.AddView(scroll, 0, tabHeight, Root.Width, scrollHeight)
	UpdateTabs
	RenderContent
End Sub

Private Sub EducationTab_Click
	Dim tabView As Label = Sender
	currentTab = tabView.Tag
	UpdateTabs
	RenderContent
End Sub

Private Sub UpdateTabs
	For i = 0 To tabLabels.Length - 1
		Dim tabView As B4XView = tabLabels(i)
		If i = currentTab Then
			Dim selectedColor As Int = IIf(Utils.AccessibilityHighContrast, 0xFFFFCC00, 0xFFEEE1C4)
			tabView.SetColorAndBorder(selectedColor, 1dip, _
				IIf(Utils.AccessibilityHighContrast, Colors.White, 0xFFD8C59D), 13dip)
			tabView.TextColor = IIf(Utils.AccessibilityHighContrast, Colors.Black, TextDark)
		Else
			tabView.SetColorAndBorder(Utils.AccessibilityPanelColor(Colors.White), 1dip, _
				Utils.AccessibilityTextColor(0xFFF0F2F1), 13dip)
			tabView.TextColor = Utils.AccessibilityTextColor(MutedText)
		End If
	Next
End Sub

Private Sub RenderContent
	RenderingAccessibilityControls = True
	Root.Color = Utils.AccessibilityPanelColor(SurfaceColor)
	scroll.Panel.Color = Utils.AccessibilityPanelColor(SurfaceColor)
	scroll.Panel.RemoveAllViews
	Dim y As Int = 0
	Select currentTab
		Case 0
			y = AddIntro("Panduan kesiapsiagaan erupsi Merapi", y)
			y = AddAccordionCard("Sebelum Erupsi", Tips(Array As String( _
				"Kenali tanda-tanda erupsi: gempa vulkanik, suara gemuruh, dan bau belerang menyengat.", _
				"Siapkan tas siaga berisi dokumen, obat, air, makanan, masker, senter, dan radio.", _
				"Hafalkan jalur evakuasi terdekat dari rumah Anda.", _
				"Simpan nomor darurat BNPB (117) dan BPBD daerah.", _
				"Ikuti arahan dan briefing dari petugas BPBD setempat.", _
				"Pastikan kendaraan siap digunakan dan bahan bakarnya cukup.")), _
				expandedGeneral(0), 0, 0xFFFFC107, y)
			y = AddAccordionCard("Saat Erupsi", Tips(Array As String( _
				"Segera evakuasi mengikuti jalur resmi BPBD.", _
				"Gunakan masker atau kain basah untuk menutup hidung dan mulut.", _
				"Lindungi kepala dari material yang jatuh.", _
				"Jauhi lembah dan aliran sungai yang berhulu dari gunung.", _
				"Jangan kembali ke zona bahaya meskipun letusan mereda.", _
				"Pantau informasi resmi dari BMKG, PVMBG, dan BPBD.")), _
				expandedGeneral(1), 1, 0xFFF44336, y)
			y = AddAccordionCard("Sesudah Erupsi", Tips(Array As String( _
				"Tunggu arahan resmi sebelum kembali ke rumah.", _
				"Bersihkan abu vulkanik dari atap dengan hati-hati karena bebannya dapat menyebabkan atap runtuh.", _
				"Periksa sumber air sebelum dikonsumsi.", _
				"Waspadai aliran lahar saat hujan.", _
				"Pantau kondisi kesehatan, terutama gangguan pernapasan.", _
				"Laporkan kerusakan kepada BPBD untuk pendataan.")), _
				expandedGeneral(2), 2, 0xFF4CAF50, y)
		Case 1
			y = AddIntro("Belajar tetap tenang dan aman saat terjadi erupsi.", y)
			y = AddChildCard("🌋", "Apa itu Gunung Berapi?", _
				"Gunung berapi adalah gunung yang bisa mengeluarkan lava panas, abu, dan gas dari dalam bumi. Seperti bumi sedang batuk!", 0xFFFF9800, y)
			y = AddChildCard("⚠️", "Tanda-tanda Bahaya", _
				"Jika tanah bergetar, terdengar suara keras dari gunung, atau tercium bau seperti telur busuk, segera beri tahu orang dewasa!", 0xFFF44336, y)
			y = AddChildCard("🏃", "Apa yang Harus Dilakukan?", _
				"Ikuti arahan orang tua atau guru. Jangan panik! Bergerak menjauhi gunung, bukan mendekat. Gunakan masker atau tutup hidung dengan kain.", 0xFF2196F3, y)
			y = AddChildCard("🎒", "Tas Siaga Kamu", _
				"Siapkan tas berisi botol air, makanan ringan, baju ganti, senter, dan obat-obatan. Simpan di tempat yang mudah dijangkau.", 0xFF4CAF50, y)
			y = AddChildCard("📞", "Nomor Penting", _
				"Hafalkan nomor telepon orang tua dan nomor darurat 117 (BNPB). Jika terpisah, minta bantuan petugas berseragam.", 0xFF9C27B0, y)
			y = AddChildCard("🤝", "Bantu Teman", _
				"Jika temanmu takut, pegang tangannya dan katakan, ‘Jangan takut, kita ikuti arahan petugas.’ Tetap tenang dan saling membantu.", 0xFF009688, y)
		Case 2
			y = AddIntro("Sesuaikan rencana evakuasi dengan kebutuhan setiap orang.", y)
			y = AddDisabilityAccessibilityControls(y)
			y = AddAccordionCard("Gangguan Pendengaran", Tips(Array As String( _
				"Aktifkan notifikasi visual atau lampu peringatan bila tersedia.", _
				"Gunakan pesan teks dan instruksi tertulis dari petugas.", _
				"Siapkan pendamping yang dapat memberi isyarat bahaya.", _
				"Letakkan alarm getar di dekat tempat tidur.")), _
				expandedDisability(0), 0, 0xFF1B2E7B, y)
			y = AddAccordionCard("Gangguan Penglihatan", Tips(Array As String( _
				"Minta pendamping membacakan informasi dan membantu mengenali jalur evakuasi.", _
				"Hafalkan jalur evakuasi melalui latihan dan penanda yang dapat dikenali.", _
				"Siapkan tongkat dan perlengkapan pribadi di dalam tas siaga.", _
				"Minta petugas memberi arahan lisan saat evakuasi.")), _
				expandedDisability(1), 1, 0xFF1B2E7B, y)
			y = AddAccordionCard("Pengguna Kursi Roda", Tips(Array As String( _
				"Kenali jalur evakuasi yang dapat dilalui pengguna kursi roda.", _
				"Buat rencana evakuasi dengan orang yang siap membantu.", _
				"Koordinasikan kebutuhan mobilitas dengan tim SAR atau petugas setempat.", _
				"Pastikan kursi roda dalam kondisi baik dan siap digunakan.")), _
				expandedDisability(2), 2, 0xFF1B2E7B, y)
			y = AddAccordionCard("Lansia", Tips(Array As String( _
				"Siapkan obat-obatan rutin di dalam tas siaga.", _
				"Koordinasikan bantuan evakuasi dengan keluarga atau tetangga.", _
				"Simpan informasi medis penting di dompet.", _
				"Pastikan alat bantu mobilitas mudah dijangkau.")), _
				expandedDisability(3), 3, 0xFF1B2E7B, y)
	End Select
	scroll.Panel.Height = Max(scroll.Height, y + 16dip)
	scroll.ScrollPosition = 0
	RenderingAccessibilityControls = False
End Sub

Private Sub AddDisabilityAccessibilityControls(y As Int) As Int
	Dim cardWidth As Int = Root.Width - 24dip
	Dim card As Panel
	card.Initialize("")
	Dim cardView As B4XView = card
	cardView.SetColorAndBorder(Utils.AccessibilityPanelColor(Colors.White), 1dip, _
		Utils.AccessibilityTextColor(0xFFE5EAE7), 14dip)
	Dim title As Label
	title.Initialize("")
	title.Text = "Pengaturan tampilan"
	title.TextColor = Utils.AccessibilityTextColor(TextDark)
	title.TextSize = Utils.AccessibilityFontSize(15)
	title.Typeface = Typeface.DEFAULT_BOLD
	title.Gravity = Gravity.CENTER_VERTICAL
	card.AddView(title, 16dip, 10dip, cardWidth - 32dip, 40dip)

	Dim contrast As CheckBox
	contrast.Initialize("DisabilityHighContrast")
	contrast.Text = "Kontras tinggi"
	contrast.TextColor = Utils.AccessibilityTextColor(TextDark)
	contrast.TextSize = Utils.AccessibilityFontSize(14)
	contrast.Checked = Utils.AccessibilityHighContrast
	If Utils.AccessibilityHighContrast Then contrast.Color = 0xFFFFCC00
	card.AddView(contrast, 14dip, 54dip, cardWidth - 28dip, 52dip)

	Dim fontTitle As Label
	fontTitle.Initialize("")
	fontTitle.Text = "Ukuran teks"
	fontTitle.TextColor = Utils.AccessibilityTextColor(TextDark)
	fontTitle.TextSize = Utils.AccessibilityFontSize(14)
	fontTitle.Typeface = Typeface.DEFAULT_BOLD
	fontTitle.Gravity = Gravity.CENTER_VERTICAL
	card.AddView(fontTitle, 16dip, 112dip, cardWidth - 32dip, 36dip)

	FontSeek.Initialize("DisabilityFontSeek")
	FontSeek.Max = 12
	FontSeek.Value = Round((FontScale - 0.8) * 10)
	card.AddView(FontSeek, 42dip, 150dip, cardWidth - 84dip, 40dip)
	FontPercent.Initialize("")
	FontPercent.Text = NumberFormat(FontScale * 100, 1, 0) & "%"
	FontPercent.TextColor = Utils.AccessibilityTextColor(TextDark)
	FontPercent.TextSize = Utils.AccessibilityFontSize(13)
	FontPercent.Gravity = Gravity.CENTER
	card.AddView(FontPercent, 12dip, 192dip, cardWidth - 24dip, 36dip)
	FontPreview.Initialize("")
	FontPreview.Text = "Contoh teks yang lebih mudah dibaca"
	FontPreview.TextColor = Utils.AccessibilityTextColor(TextDark)
	FontPreview.TextSize = Max(1, Round(14 * FontScale))
	FontPreview.SingleLine = False
	FontPreview.Gravity = Gravity.CENTER
	card.AddView(FontPreview, 12dip, 230dip, cardWidth - 24dip, 68dip)
	card.SetLayoutAnimated(0, 0, 0, cardWidth, 310dip)
	scroll.Panel.AddView(card, 12dip, y, cardWidth, 310dip)
	RenderingAccessibilityControls = True
	Return y + 322dip
End Sub

Private Sub DisabilityFontSeek_ValueChanged(Value As Int, UserChanged As Boolean)
	FontScale = 0.8 + (Value / 10)
	FontPercent.Text = NumberFormat(FontScale * 100, 1, 0) & "%"
	FontPreview.TextSize = Max(1, Round(14 * FontScale))
	If UserChanged = False Or RenderingAccessibilityControls Then Return
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
		RenderContent
	Else
		FontScale = Utils.AccessibilityFontScale
		FontSeek.Value = Round((FontScale - 0.8) * 10)
		FontPercent.Text = NumberFormat(FontScale * 100, 1, 0) & "%"
		FontPreview.TextSize = Utils.AccessibilityFontSize(14)
	End If
End Sub

Private Sub DisabilityHighContrast_CheckedChange(Checked As Boolean)
	If RenderingAccessibilityControls Then Return
	Main.kvs.Put("access_high_contrast", Checked)
	UpdateTabs
	RenderContent
	CallSub(ActHome, "ApplyAccessibilityTheme")
End Sub

Private Sub GeneralSection_Click
	Dim header As Label = Sender
	Dim index As Int = header.Tag
	expandedGeneral(index) = Not(expandedGeneral(index))
	RenderContent
End Sub

Private Sub DisabilitySection_Click
	Dim header As Label = Sender
	Dim index As Int = header.Tag
	expandedDisability(index) = Not(expandedDisability(index))
	RenderContent
End Sub

Private Sub AddIntro(text As String, y As Int) As Int
	Dim cardWidth As Int = Root.Width - 24dip
	Dim card As Panel
	card.Initialize("")
	card.SetLayoutAnimated(0, 0, 0, cardWidth, 120dip)
	Dim iconTile As Panel
	iconTile.Initialize("")
	Dim iconColor As Int = IIf(Utils.AccessibilityHighContrast, 0xFFFFCC00, 0xFFFFF1D4)
	Dim iconTileView As B4XView = iconTile
	iconTileView.SetColorAndBorder(iconColor, 0, iconColor, 14dip)
	card.AddView(iconTile, 14dip, 14dip, 44dip, 44dip)
	Dim icon As Label
	icon.Initialize("")
	Select currentTab
		Case 0
			icon.Text = "🌋"
		Case 1
			icon.Text = "🧒"
		Case Else
			icon.Text = "♿"
	End Select
	icon.TextSize = 24
	icon.Gravity = Gravity.CENTER
	iconTile.AddView(icon, 0, 0, 44dip, 44dip)

	Dim heading As Label
	heading.Initialize("")
	heading.Text = "Panduan keselamatan"
	heading.TextColor = Utils.AccessibilityTextColor(TextDark)
	heading.TextSize = Utils.AccessibilityFontSize(16)
	heading.Typeface = Typeface.DEFAULT_BOLD
	heading.SingleLine = False
	heading.Gravity = Gravity.CENTER_VERTICAL
	Dim textLeft As Int = 70dip
	Dim textWidth As Int = cardWidth - textLeft - 14dip
	card.AddView(heading, textLeft, 10dip, textWidth, 38dip)
	Dim headingHeight As Int = Max(28dip, Utils.GetTinggiLbl(heading) + 4dip)
	heading.SetLayoutAnimated(0, textLeft, 10dip, textWidth, headingHeight)

	Dim intro As Label
	intro.Initialize("")
	intro.Text = text
	intro.TextColor = Utils.AccessibilityTextColor(MutedText)
	intro.TextSize = Utils.AccessibilityFontSize(13)
	intro.SingleLine = False
	intro.Gravity = Gravity.TOP
	Dim introTop As Int = 10dip + headingHeight + 2dip
	card.AddView(intro, textLeft, introTop, textWidth, 52dip)
	Dim introHeight As Int = Max(36dip, Utils.GetTinggiLbl(intro) + 4dip)
	intro.SetLayoutAnimated(0, textLeft, introTop, textWidth, introHeight)
	Dim cardHeight As Int = Max(72dip, introTop + introHeight + 12dip)
	Dim cardView As B4XView = card
	cardView.SetLayoutAnimated(0, 0, 0, cardWidth, cardHeight)
	cardView.SetColorAndBorder(Utils.AccessibilityPanelColor(Colors.White), 1dip, _
		Utils.AccessibilityTextColor(0xFFE4E9E6), 14dip)
	scroll.Panel.AddView(card, 12dip, y + 6dip, cardWidth, cardHeight)
	Return y + cardHeight + 18dip
End Sub

Private Sub AddAccordionCard(title As String, adviceItems As List, isExpanded As Boolean, index As Int, accent As Int, y As Int) As Int
	Dim card As Panel
	card.Initialize("")
	Dim cardWidth As Int = Root.Width - 24dip
	card.SetLayoutAnimated(0, 0, 0, cardWidth, 180dip)
	Dim eventName As String = IIf(currentTab = 0, "GeneralSection", "DisabilitySection")
	Dim header As Label
	header.Initialize(eventName)
	header.Tag = index
	header.Text = title
	header.TextColor = Utils.AccessibilityTextColor(TextDark)
	header.TextSize = Utils.AccessibilityFontSize(15)
	header.Typeface = Typeface.DEFAULT_BOLD
	header.Gravity = Gravity.CENTER_VERTICAL
	card.AddView(header, 16dip, 4dip, cardWidth - 64dip, 52dip)
	Dim toggle As Label
	toggle.Initialize(eventName)
	toggle.Tag = index
	toggle.Text = IIf(isExpanded, "−", "+")
	toggle.TextColor = IIf(Utils.AccessibilityHighContrast, Colors.Black, TextDark)
	toggle.TextSize = Utils.AccessibilityFontSize(20)
	toggle.Typeface = Typeface.DEFAULT_BOLD
	toggle.Gravity = Gravity.CENTER
	Dim togglePanel As B4XView = toggle
	Dim toggleColor As Int = IIf(Utils.AccessibilityHighContrast, 0xFFFFCC00, 0xFFF2F5F3)
	togglePanel.SetColorAndBorder(toggleColor, 0, toggleColor, 16dip)
	card.AddView(toggle, cardWidth - 48dip, 13dip, 32dip, 32dip)
	Dim cardHeight As Int = 60dip
	If isExpanded Then
		Dim divider As Panel
		divider.Initialize("")
		divider.Color = Utils.AccessibilityTextColor(0xFFE8ECEA)
		card.AddView(divider, 16dip, 60dip, cardWidth - 32dip, 1dip)
		cardHeight = 68dip
		For i = 0 To adviceItems.Size - 1
			Dim detail As Label
			detail.Initialize("")
			detail.Text = adviceItems.Get(i)
			detail.TextColor = Utils.AccessibilityTextColor(TextDark)
			detail.TextSize = Utils.AccessibilityFontSize(14)
			detail.SingleLine = False
			detail.Gravity = Gravity.TOP
			Dim textX As Int = 54dip
			Dim textW As Int = cardWidth - textX - 16dip
			card.AddView(detail, textX, cardHeight, textW, 58dip)
			Dim detailHeight As Int = Max(42dip, Utils.GetTinggiLbl(detail) + 6dip)
			detail.SetLayoutAnimated(0, textX, cardHeight, textW, detailHeight)
			Dim check As Label
			check.Initialize("")
			check.Text = "✓"
			check.TextColor = IIf(Utils.AccessibilityHighContrast, Colors.Black, TextDark)
			check.TextSize = Utils.AccessibilityFontSize(13)
			check.Typeface = Typeface.DEFAULT_BOLD
			check.Gravity = Gravity.CENTER
			Dim checkView As B4XView = check
			Dim checkColor As Int = IIf(Utils.AccessibilityHighContrast, 0xFFFFCC00, 0xFFF2F5F3)
			checkView.SetColorAndBorder(checkColor, 0, checkColor, 13dip)
			card.AddView(check, 16dip, cardHeight + 2dip, 26dip, 26dip)
			cardHeight = cardHeight + detailHeight + 12dip
		Next
	End If
	Dim cardView As B4XView = card
	cardView.SetLayoutAnimated(0, 0, 0, cardWidth, cardHeight)
	cardView.SetColorAndBorder(Utils.AccessibilityPanelColor(Colors.White), 1dip, _
		Utils.AccessibilityTextColor(0xFFE5EAE7), 14dip)
	scroll.Panel.AddView(card, 12dip, y, cardWidth, cardHeight)
	Return y + cardHeight + 14dip
End Sub

Private Sub AddChildCard(emoji As String, title As String, description As String, accent As Int, y As Int) As Int
	Dim card As Panel
	card.Initialize("")
	Dim cardWidth As Int = Root.Width - 24dip
	card.SetLayoutAnimated(0, 0, 0, cardWidth, 160dip)
	Dim accentTileColor As Int = IIf(Utils.AccessibilityHighContrast, 0xFFFFCC00, accent)
	Dim iconTile As Panel
	iconTile.Initialize("")
	Dim iconTileView As B4XView = iconTile
	iconTileView.SetColorAndBorder(accentTileColor, 0, accentTileColor, 14dip)
	card.AddView(iconTile, 14dip, 14dip, 44dip, 44dip)
	Dim icon As Label
	icon.Initialize("")
	icon.Text = emoji
	icon.TextSize = 23
	icon.Gravity = Gravity.CENTER
	iconTile.AddView(icon, 0, 0, 44dip, 44dip)
	Dim heading As Label
	heading.Initialize("")
	heading.Text = title
	heading.TextColor = Utils.AccessibilityTextColor(TextDark)
	heading.TextSize = Utils.AccessibilityFontSize(15)
	heading.Typeface = Typeface.DEFAULT_BOLD
	heading.Gravity = Gravity.CENTER_VERTICAL
	heading.SingleLine = False
	Dim textLeft As Int = 70dip
	Dim textWidth As Int = cardWidth - textLeft - 14dip
	card.AddView(heading, textLeft, 10dip, textWidth, 40dip)
	Dim headingHeight As Int = Max(28dip, Utils.GetTinggiLbl(heading) + 4dip)
	heading.SetLayoutAnimated(0, textLeft, 10dip, textWidth, headingHeight)
	Dim body As Label
	body.Initialize("")
	body.Text = description
	body.TextColor = Utils.AccessibilityTextColor(TextDark)
	body.TextSize = Utils.AccessibilityFontSize(14)
	body.SingleLine = False
	body.Gravity = Gravity.TOP
	Dim bodyTop As Int = 14dip + Max(44dip, headingHeight) + 8dip
	Dim bodyWidth As Int = cardWidth - 32dip
	card.AddView(body, 16dip, bodyTop, bodyWidth, 72dip)
	Dim bodyHeight As Int = Max(52dip, Utils.GetTinggiLbl(body) + 8dip)
	body.SetLayoutAnimated(0, 16dip, bodyTop, bodyWidth, bodyHeight)
	Dim cardHeight As Int = bodyTop + bodyHeight + 16dip
	Dim cardView As B4XView = card
	cardView.SetLayoutAnimated(0, 0, 0, cardWidth, cardHeight)
	cardView.SetColorAndBorder(Utils.AccessibilityPanelColor(Colors.White), 1dip, _
		Utils.AccessibilityTextColor(0xFFE5EAE7), 14dip)
	scroll.Panel.AddView(card, 12dip, y, cardWidth, cardHeight)
	Return y + cardHeight + 14dip
End Sub

Private Sub Tips(values() As String) As List
	Dim result As List
	result.Initialize
	For Each value As String In values
		result.Add(value)
	Next
	Return result
End Sub
