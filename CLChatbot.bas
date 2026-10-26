B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11.2
@EndOfDesignText@
Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private clv As CustomListView
	Private etSearch As EditText
	Private lbSearch As Label
	Private chatBusy As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(p As B4XView)
	Log("Chatbot SiMantab")
	Root = p
End Sub

Public Sub createLayout
	Root.LoadLayout("LayClv")
	Appear
End Sub

Private Sub Appear
	etSearch.Hint = "Tanya SiMantab..."
	etSearch.TextColor = Colors.Black
	etSearch.SingleLine = False
	etSearch.Color = Colors.White

	lbSearch.Text = "KIRIM"
	lbSearch.TextColor = Colors.RGB(255, 255, 255)
	lbSearch.Color = Colors.RGB(20, 111, 94)
	lbSearch.Gravity = Gravity.CENTER

	Root.Color = Colors.RGB(244, 247, 246)
	clv.AsView.Color = Colors.RGB(244, 247, 246)

	clv.Clear
	AddChatBubble("Halo! Saya SiMantab. Saya siap membantu menjawab pertanyaan seputar kebencanaan dan bantuan.", False)
End Sub

Private Sub etSearch_EnterPressed
	lbSearch_Click
End Sub

Private Sub lbSearch_Click
	If chatBusy Then Return
	Dim prompt As String = etSearch.Text.Trim
	If prompt = "" Then Return

	AddChatBubble(prompt, True)
	etSearch.Text = ""
	chatBusy = True
	lbSearch.Text = "..."
	lbSearch.Enabled = False
	etSearch.Enabled = False
	CallOllama(prompt)
End Sub

Private Sub CallOllama(prompt As String)
	Dim job As HttpJob
	job.Initialize("OllamaJob", Me)

	Dim jsonMap As Map
	jsonMap.Initialize
	jsonMap.Put("model", Main.ollamaModel)
	Dim messages As List
	messages.Initialize
	Dim systemMessage As Map
	systemMessage.Initialize
	systemMessage.Put("role", "system")
	systemMessage.Put("content", "Anda adalah asisten SIMANTAB untuk informasi kebencanaan. Jawab dengan jelas dan ringkas dalam Bahasa Indonesia. Jangan mengarang status bencana terkini; arahkan pengguna ke sumber resmi jika data terbaru diperlukan.")
	messages.Add(systemMessage)
	Dim userMessage As Map
	userMessage.Initialize
	userMessage.Put("role", "user")
	userMessage.Put("content", prompt)
	messages.Add(userMessage)
	jsonMap.Put("messages", messages)
	jsonMap.Put("stream", False)

	Dim jg As JSONGenerator
	jg.Initialize(jsonMap)

	Dim targetUrl As String = Main.ollamaLink.Trim
	If targetUrl.EndsWith("/") Then targetUrl = targetUrl.SubString2(0, targetUrl.Length - 1)
	If targetUrl.EndsWith("/api/chat") = False Then targetUrl = targetUrl & "/api/chat"

	If targetUrl.StartsWith("https://") = False And targetUrl.StartsWith("http://") = False Then
		AddChatBubble("URL chatbot belum dikonfigurasi. Isi Main.ollamaLink dengan alamat publik Ollama di VPS.", False)
		job.Release
		FinishSending
		Return
	End If

	job.PostString(targetUrl, jg.ToString)
	job.GetRequest.SetContentType("application/json")
	If Main.ollamaUser <> "" And Main.ollamaPass <> "" Then
		Dim su As StringUtils
		Dim auth As String = su.EncodeBase64((Main.ollamaUser & ":" & Main.ollamaPass).GetBytes("UTF8"))
		job.GetRequest.SetHeader("Authorization", "Basic " & auth)
	End If

	AddChatBubble("...", False)
	Wait For (job) JobDone(j As HttpJob)

	' Remove loading item ("...")
	If clv.Size > 0 Then
		clv.RemoveAt(clv.Size - 1)
	End If

	If j.Success Then
		Dim jp As JSONParser
		Try
			jp.Initialize(j.GetString)
			Dim resMap As Map = jp.NextObject
			Dim messageMap As Map = resMap.Get("message")
			Dim reply As String = messageMap.GetDefault("content", "").As(String)
			If reply.Trim = "" Then reply = "Maaf, SiMantab belum menerima jawaban dari server. Silakan coba lagi."
			AddChatBubble(reply, False)
		Catch
			AddChatBubble("Maaf! SiMantab tidak bisa menjawab pertanyaan ini", False)
		End Try
	Else
		AddChatBubble("Maaf, server SiMantab tidak dapat dijangkau. Periksa koneksi internet lalu coba lagi.", False)
		Log("Ollama Error: " & j.ErrorMessage)
	End If
	j.Release
	FinishSending
End Sub

Private Sub FinishSending
	chatBusy = False
	lbSearch.Text = "KIRIM"
	lbSearch.Enabled = True
	etSearch.Enabled = True
End Sub

Private Sub AddChatBubble(text As String, isUser As Boolean)
	clv.Add(CreateBubble(text, isUser), "")
	clv.ScrollToItem(clv.Size - 1)
End Sub

Private Sub CreateBubble(text As String, isUser As Boolean) As B4XView
	Dim p As B4XView = xui.CreatePanel("")

	Dim pWidth As Int = clv.AsView.Width
	If pWidth <= 0 Then pWidth = 100%x
	Dim bubbleWidth As Int = Min(300dip, pWidth * 0.82)
	Dim textWidth As Int = Max(40dip, bubbleWidth - 28dip)
	Dim charsPerLine As Int = Max(12, textWidth / 8dip)
	Dim lineCount As Int = Max(1, (text.Length + charsPerLine - 1) / charsPerLine)
	Dim txtHeight As Int = Max(42dip, lineCount * 20dip + 16dip)
	p.SetLayoutAnimated(0, 0, 0, pWidth, txtHeight + 14dip)

	Dim pnlBG As B4XView = xui.CreatePanel("")
	If isUser Then
		pnlBG.SetColorAndBorder(Colors.RGB(20, 111, 94), 0, Colors.RGB(20, 111, 94), 16dip)
		p.AddView(pnlBG, pWidth - bubbleWidth - 12dip, 5dip, bubbleWidth, txtHeight)
	Else
		pnlBG.SetColorAndBorder(Colors.White, 1dip, Colors.RGB(226, 232, 229), 16dip)
		p.AddView(pnlBG, 12dip, 5dip, bubbleWidth, txtHeight)
	End If

	Dim lbl As Label
	lbl.Initialize("")
	lbl.Text = text
	lbl.TextSize = 15
	lbl.TextColor = IIf(isUser, Colors.White, Colors.RGB(38, 50, 45))
	lbl.Gravity = Gravity.CENTER_VERTICAL
	lbl.SingleLine = False

	pnlBG.AddView(lbl, 14dip, 6dip, bubbleWidth - 28dip, txtHeight - 12dip)
	Return p
End Sub
