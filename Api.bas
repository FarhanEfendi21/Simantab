B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=11
@EndOfDesignText@
Sub Class_Globals
'	Dim serverWeb As String = "http://192.168.11.158:17178"

End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	
End Sub

private Sub CreateRequest As DBRequestManager
	Dim req As DBRequestManager
	req.Initialize(Me, Main.rdcLink)
	Return req
End Sub

private Sub CreateRequestEmail As DBRequestManager
	Dim req As DBRequestManager
	req.Initialize(Me, Main.rdcEmail)
	Return req
End Sub

Public Sub CreateCommand(Name As String, Parameters() As Object) As DBCommand
	Dim cmd As DBCommand
	cmd.Initialize
	cmd.Name = Name
	If Parameters <> Null Then cmd.Parameters = Parameters
	Return cmd
End Sub

'Wait For (api1.SelectData("get_telpall",Null)) complete (result As resJrdc)
Public Sub SelectData(command As String, param As Object) As ResumableSub
	Dim response As resJrdc
	response.Initialize
	
	' ================================================================
	' MOCK MODE: aktif saat Main.isDevelopment = True di krb.b4a
	' Untuk kembali ke server asli: ubah isDevelopment = False
	' ================================================================
	If Main.isDevelopment Then
		response.success = True
		response.res = MockData(command, param)
		Return response
	End If
	' ================================================================
	
	Dim req As DBRequestManager = CreateRequest
	Dim cmd As DBCommand = CreateCommand(command, param)
	Wait For (req.ExecuteQuery(cmd, 0, Null)) JobDone(j As HttpJob)
	response.success = j.Success
	If j.Success Then
		req.HandleJobAsync(j, "req")
		Wait For (req) req_Result(res As DBResult)
		response.res = res
	Else
		Try
			Utils.ShowToastTengah("Tidak terhubung ke server")
		Catch
			ToastMessageShow("Tidak terhubung ke server",False)
		End Try
		#If Debug
		Log("error : " & j.ErrorMessage)
		Dim errMsg As String = Utils.ErrorJRDC(j.ErrorMessage)
		Log("------------------------------------------")
		LogColor(errMsg,Colors.Red)
		LogColor(command,Colors.Red)
		LogColor(Utils.debugArrayDB(param),Colors.Green)
		Log("------------------------------------------")
		Log("error : " & j.ErrorMessage)
		response.errMsg = errMsg
		#End If
	End If
	j.Release
	Return response
End Sub

' ================================================================
' MOCK DATA - Data dummy untuk development lokal
' Tambahkan/edit data sesuai kebutuhan testing fitur baru
' ================================================================
Private Sub MockData(command As String, param As Object) As DBResult
	Dim res As DBResult
	res.Initialize
	Dim cols As Map
	cols.Initialize
	Dim rows As List
	rows.Initialize
	
	Select command
		Case "get_login"
			' Login selalu sukses dengan akun dummy
			cols.Put("pesan", 0)
			cols.Put("idtbluser", 1)
			cols.Put("fb_token", 2)
			Dim r(3) As Object
			r(0) = "ok"
			r(1) = "1"
			r(2) = ""
			rows.Add(r)
			
		Case "get_telpreg"
			' Nomor HP belum terdaftar (bisa daftar)
			' rows kosong = belum terdaftar, rows isi = sudah terdaftar
			' Ubah ke rows.Add(...) jika ingin simulasi HP sudah terdaftar
			
		Case "set_registrasi"
			' Registrasi selalu sukses
			cols.Put("pesan", 0)
			Dim rr(1) As Object
			rr(0) = "ok"
			rows.Add(rr)
			
		Case "get_databarak"
			cols.Put("nama", 0)
			cols.Put("alamat", 1)
			cols.Put("tlpn", 2)
			cols.Put("deskripsi", 3)
			cols.Put("latitude", 4)
			cols.Put("longitude", 5)
			Dim b1(6) As Object
			b1(0) = "Balai Desa Cangkringan"
			b1(1) = "Jl. Cangkringan No.1, Sleman"
			b1(2) = "0274-123456"
			b1(3) = "Barak pengungsian kapasitas 200 orang"
			b1(4) = "-7.6327"
			b1(5) = "110.4453"
			rows.Add(b1)
			Dim b2(6) As Object
			b2(0) = "SD Negeri Kepuharjo"
			b2(1) = "Kepuharjo, Cangkringan, Sleman"
			b2(2) = "0274-654321"
			b2(3) = "Barak pengungsian kapasitas 150 orang"
			b2(4) = "-7.6198"
			b2(5) = "110.4421"
			rows.Add(b2)
			
		Case "get_telpall", "get_telpall_search"
			cols.Put("nama", 0)
			cols.Put("deskripsi", 1)
			cols.Put("telpon", 2)
			cols.Put("telp_trim", 3)
			Dim t1(4) As Object
			t1(0) = "BPBD Sleman"
			t1(1) = "Badan Penanggulangan Bencana Daerah"
			t1(2) = "0274-868434"
			t1(3) = "0274868434"
			rows.Add(t1)
			Dim t2(4) As Object
			t2(0) = "Basarnas Yogyakarta"
			t2(1) = "Badan SAR Nasional"
			t2(2) = "0274-484119"
			t2(3) = "0274484119"
			rows.Add(t2)
			Dim t3(4) As Object
			t3(0) = "PMI Sleman"
			t3(1) = "Palang Merah Indonesia Kab. Sleman"
			t3(2) = "0274-868281"
			t3(3) = "0274868281"
			rows.Add(t3)
			
		Case "get_logistik"
			cols.Put("nama_gudang", 0)
			cols.Put("nama_barang", 1)
			cols.Put("sisa_stok", 2)
			cols.Put("uom", 3)
			Dim lg1(4) As Object
			lg1(0) = "Gudang BPBD Sleman"
			lg1(1) = "Selimut"
			lg1(2) = "250"
			lg1(3) = "lembar"
			rows.Add(lg1)
			Dim lg2(4) As Object
			lg2(0) = "Gudang BPBD Sleman"
			lg2(1) = "Masker N95"
			lg2(2) = "500"
			lg2(3) = "buah"
			rows.Add(lg2)
			Dim lg3(4) As Object
			lg3(0) = "Gudang PMI Sleman"
			lg3(1) = "Air Mineral 600ml"
			lg3(2) = "1000"
			lg3(3) = "botol"
			rows.Add(lg3)
			
		Case "get_peralatan"
			cols.Put("nama", 0)
			cols.Put("nama_alat", 1)
			cols.Put("merek", 2)
			cols.Put("kondisi", 3)
			cols.Put("tahun", 4)
			cols.Put("sumber", 5)
			Dim pr1(6) As Object
			pr1(0) = "Alat Evakuasi"
			pr1(1) = "Tandu Lipat"
			pr1(2) = "Paramedic"
			pr1(3) = "Baik"
			pr1(4) = "2022"
			pr1(5) = "BPBD Sleman"
			rows.Add(pr1)
			Dim pr2(6) As Object
			pr2(0) = "Komunikasi"
			pr2(1) = "HT Motorola"
			pr2(2) = "Motorola"
			pr2(3) = "Baik"
			pr2(4) = "2021"
			pr2(5) = "BPBD Sleman"
			rows.Add(pr2)
			
		Case "get_peringatandini"
			cols.Put("judul", 0)
			cols.Put("keterangan", 1)
			cols.Put("status", 2)
			cols.Put("tgl_kejadian", 3)
			cols.Put("idperingatan", 4)
			cols.Put("jam", 5)
			Dim pd1(6) As Object
			pd1(0) = "Siaga Merapi"
			pd1(1) = "Aktivitas Merapi meningkat, warga diminta waspada"
			pd1(2) = "Waspada"
			pd1(3) = "2026-08-25"
			pd1(4) = "1"
			pd1(5) = "25 Aug 2026 19:40"
			rows.Add(pd1)
			
		Case "get_badge_peringatan_dini"
			cols.Put("pedi", 0)
			Dim bd1(1) As Object
			bd1(0) = "1"
			rows.Add(bd1)
			
		Case "get_listbencana"
			' CLLapor uses: id, nama
			' CLHistoryBencana/peta uses: nama_bencana, tgl_kejadian, dll
			cols.Put("id", 0)
			cols.Put("nama", 1)
			cols.Put("nama_bencana", 2)
			cols.Put("tgl_kejadian", 3)
			cols.Put("nama_dusun", 4)
			cols.Put("nama_kalurahan", 5)
			cols.Put("dampak", 6)
			cols.Put("latitude", 7)
			cols.Put("longitude", 8)
			cols.Put("type", 9)
			Dim bn1(10) As Object
			bn1(0) = "1"
			bn1(1) = "Banjir"
			bn1(2) = "Banjir"
			bn1(3) = "2026-08-20"
			bn1(4) = "Jetis"
			bn1(5) = "Cangkringan"
			bn1(6) = "Rumah terendam"
			bn1(7) = "-7.630"
			bn1(8) = "110.448"
			bn1(9) = "banjir"
			rows.Add(bn1)
			Dim bn2(10) As Object
			bn2(0) = "2"
			bn2(1) = "Longsor"
			bn2(2) = "Longsor"
			bn2(3) = "2026-08-18"
			bn2(4) = "Turgo"
			bn2(5) = "Purwobinangun"
			bn2(6) = "Jalan tertutup"
			bn2(7) = "-7.615"
			bn2(8) = "110.439"
			bn2(9) = "longsor"
			rows.Add(bn2)
			
		Case "get_listcuaca"
			cols.Put("id", 0)
			cols.Put("nama", 1)
			cols.Put("nama_dusun", 2)
			cols.Put("keterangan", 3)
			cols.Put("statusaktivitas", 4)
			Dim cw1(5) As Object
			cw1(0) = "1"
			cw1(1) = "Cerah"
			cw1(2) = "Cangkringan"
			cw1(3) = "Cerah berawan"
			cw1(4) = "Normal"
			rows.Add(cw1)
			Dim cw2(5) As Object
			cw2(0) = "2"
			cw2(1) = "Hujan Ringan"
			cw2(2) = "Pakem"
			cw2(3) = "Hujan lokal"
			cw2(4) = "Normal"
			rows.Add(cw2)
			Dim cw3(5) As Object
			cw3(0) = "3"
			cw3(1) = "Berawan"
			cw3(2) = "Turi"
			cw3(3) = "Berawan tebal"
			cw3(4) = "Normal"
			rows.Add(cw3)
			
		Case "get_datawisata"
			cols.Put("nama", 0)
			cols.Put("alamat", 1)
			cols.Put("pengelola", 2)
			cols.Put("telp", 3)
			cols.Put("kategori", 4)
			cols.Put("latitude", 5)
			cols.Put("longitude", 6)
			cols.Put("picture_name", 7)
			cols.Put("deskripsi", 8)
			Dim ws1(9) As Object
			ws1(0) = "Lereng Merapi"
			ws1(1) = "Kaliurang, Pakem, Sleman"
			ws1(2) = "Dinas Pariwisata Sleman"
			ws1(3) = "0274-895156"
			ws1(4) = "Alam"
			ws1(5) = "-7.5972"
			ws1(6) = "110.4371"
			ws1(7) = ""
			ws1(8) = "Wisata alam lereng Gunung Merapi"
			rows.Add(ws1)
			Dim ws2(9) As Object
			ws2(0) = "Candi Prambanan"
			ws2(1) = "Jl. Raya Solo - Yogyakarta, Sleman"
			ws2(2) = "PT. Taman Wisata Candi"
			ws2(3) = "0274-496401"
			ws2(4) = "Budaya"
			ws2(5) = "-7.7520"
			ws2(6) = "110.4914"
			ws2(7) = ""
			ws2(8) = "Candi Hindu terbesar di Indonesia"
			rows.Add(ws2)
			
		Case "get_history_atensi", "history_laporan", "history_laporan_status"
			cols.Put("id", 0)
			cols.Put("judul", 1)
			cols.Put("status", 2)
			cols.Put("jam", 3)
			cols.Put("atensi", 4)
			cols.Put("rekomendasi", 5)
			cols.Put("file", 6)
			cols.Put("dampak", 7)
			cols.Put("nama", 8)
			Dim hl1(9) As Object
			hl1(0) = "1"
			hl1(1) = "Pohon Tumbang"
			hl1(2) = "selesai"
			hl1(3) = "2026-08-24 14:00"
			hl1(4) = "Atensi pembersihan jalan"
			hl1(5) = "Penanganan selesai"
			hl1(6) = ""
			hl1(7) = "Pohon tumbang menghalangi jalan di Pakem"
			hl1(8) = "Cerah"
			rows.Add(hl1)
			
		Case "get_jarak"
			cols.Put("jarakaman", 0)
			cols.Put("statusaktivitas", 1)
			cols.Put("rekomendasi", 2)
			Dim jk1(3) As Object
			jk1(0) = "5.0"
			jk1(1) = "Siaga (Level III)"
			jk1(2) = "Potensi bahaya saat ini berupa guguran lava dan awan panas pada sektor selatan-barat daya."
			rows.Add(jk1)
			
		Case "get_kml"
			cols.Put("file", 0)
			cols.Put("type", 1)
			Dim km1(2) As Object
			km1(0) = "http://simantab.slemankab.go.id/kml/radius.kml"
			km1(1) = "radius"
			rows.Add(km1)
			
		Case "svrKey"
			cols.Put("nama", 0)
			Dim sv1(1) As Object
			sv1(0) = "mock-firebase-server-key-dev"
			rows.Add(sv1)
			
		Case "lastidlaporan"
			cols.Put("id", 0)
			cols.Put("maxid", 0)
			Dim lid(1) As Object
			lid(0) = "999"
			rows.Add(lid)
			
		Case "cek_email", "cek_email_pin"
			cols.Put("pesan", 0)
			Dim em1(1) As Object
			em1(0) = "ok"
			rows.Add(em1)
			
		Case "get_PetaBencana30Day"
			cols.Put("latitude", 0)
			cols.Put("longitude", 1)
			cols.Put("nama_bencana", 2)
			cols.Put("kategori", 3)
			Dim pb1(4) As Object
			pb1(0) = "-7.630"
			pb1(1) = "110.448"
			pb1(2) = "Banjir Luapan"
			pb1(3) = "Banjir"
			rows.Add(pb1)
			
	End Select
	
	res.Columns = cols
	res.Rows = rows
	Return res
End Sub

Public Sub ExeDataBatch(listDBCommand As List) As ResumableSub
	Dim response As resJrdc
	response.Initialize
	If Main.isDevelopment Then
		response.success = True
		Return response
	End If
	
	Dim j As HttpJob = CreateRequest.ExecuteBatch(listDBCommand, Null)
	Wait For(j) JobDone(j As HttpJob)
	response.success = j.Success
	If j.Success = False Then
		Log("error : " & j.ErrorMessage)
		Try
			Utils.ShowToastTengah("Tidak terhubung ke server")
		Catch
			ToastMessageShow("Tidak terhubung ke server",False)
		End Try
		#if Debug
		Log("------------------------------------------")
		LogColor(Utils.ErrorJRDC(j.ErrorMessage),Colors.Red)

		Log("------------------------------------------")
		Log("ERROR: " & j.ErrorMessage)
		response.errMsg = Utils.ErrorJRDC(j.ErrorMessage)
		#end if
	End If
	j.Release
	Return response
End Sub

Public Sub ExeData(command As String, param As Object) As ResumableSub
	Dim response As resJrdc
	response.Initialize
	If Main.isDevelopment Then
		response.success = True
		Return response
	End If
	
'	If command = "set_new_password" Then
'	Log(command)
'	Log(Utils.debugArrayDB(param))
'	End If
	Dim cmd As DBCommand = CreateCommand(command, param)
	Dim j As HttpJob = CreateRequest.ExecuteBatch(Array(cmd), Null)
	Wait For(j) JobDone(j As HttpJob)
	response.success = j.Success
	If j.Success = False Then
		Log("error : " & j.ErrorMessage)
		Try
			Utils.ShowToastTengah("Tidak terhubung ke server")
		Catch
			ToastMessageShow("Tidak terhubung ke server",False)
		End Try
		#if Debug
			Log("------------------------------------------")
			LogColor(Utils.ErrorJRDC(j.ErrorMessage),Colors.Red)
			LogColor(command,Colors.Red)
			LogColor(Utils.debugArrayDB(param),Colors.Green)
			Log("------------------------------------------")
	'		Log("ERROR: " & j.ErrorMessage)
			response.errMsg = Utils.ErrorJRDC(j.ErrorMessage)
		#end if
	End If
	j.Release
	Return response
End Sub

'Sub EncryptText(text As String, password As String) As Byte()
'	Dim c As B4XCipher
'	Return c.Encrypt(text.GetBytes("utf8"), password)
'End Sub

Public Sub sendEmail(email As String, code As Object) As ResumableSub
'	Dim feedback As String
	Dim req As DBRequestManager = CreateRequestEmail
	Dim cmd As DBCommand = CreateCommand(email, Array(code))
	Wait For (req.SendMail(cmd, Null)) JobDone(j As HttpJob)
	If j.Success = False Then
'		feedback = "success"
'	Else
'		feedback = "error"
		#if Debug
		Try
			Utils.ShowToastTengah("Tidak terhubung ke server")
		Catch
			ToastMessageShow("Tidak terhubung ke server",False)
		End Try
		#end if
	End If
	j.Release
	Return j.Success
End Sub

Public Sub uploadImage(dir As String, listData As List) As ResumableSub
	Dim scUpl As Boolean
	scUpl = False
	
	Dim filesx As List
	filesx.Initialize
'	Log(listData.size)
	For i = 0 To listData.size - 1 'iki close e endi yo?
		Dim aun As Int = 0
		If File.Exists(dir, listData.Get(i)) Then
			If  listData.Get(i).As(String).EndsWith(".mp4") And  listData.Get(i).As(String).StartsWith("temp") Then
				Continue
			End If
			If File.Size(dir, listData.Get(i)) > 8000 Then
				If listData.Get(i).As(String).EndsWith(".jpg") Then
					Utils.resizeImage(dir, listData.Get(i))
				End If
			End If
		
			Dim fda As MultipartFileData
			fda.Initialize
			fda.KeyName 		= "laporan" & aun
			fda.Dir				= dir
			fda.FileName		=  listData.Get(i)
			If listData.Get(i).As(String).EndsWith(".jpg") Then
				fda.ContentType  	= "image/jpg"
			Else
				fda.ContentType  	= "video/mp4"
				
			End If
			
			Log( listData.Get(i))
			filesx.Add(fda)
		
'	Next
			If filesx.Size = 0 Then Return True
				
			Log(filesx.Size)
	
			Dim authkey As String
			authkey = "TgNv1l9Eg1cMZv5iJpwudJ0ljliQFnce7jKRFb05qHiT+Re5mLzMh76Q5el2JkpUutVmgTRsZGTUz0MTKFzpzSxs9TmnJKhqO7gSWBXUNZT+v9S3bDi+KXjUyyEvi8VHgJdAY4oxXh7bwZqG6ol4qUhl/vludwGunanZjAJ9Ld+rHZJpwbsdt3gbK02ILnIkfVrQel1Z4nU="
	
			Dim su As StringUtils
	
	
	For jd = 0 To filesx.Size - 1
			Dim m As Map
			m.Initialize
			m.Put("action","upload")
			m.Put("uplname","laporan" & aun)
			Dim j As HttpJob
			j.Initialize("", Me)
			j.PostMultipart(Main.urlUpload, m ,filesx)
			j.GetRequest.SetHeader("Authorization", DecryptText(su.DecodeBase64(authkey),Main.kunci))
			Wait For (j) JobDone(j As HttpJob)
		Next
'		Log("scs : " & jd & " : " & j.Success)
			If j.Success Then
				Log(j.GetString)
				scUpl = True
			Else
				scUpl = False
				Log(j.ErrorMessage)
			End If
			j.Release
		
			If scUpl = False Then
				Exit
			End If
		End If
		
		aun = aun + 1
	Next
	
	Return 	scUpl
End Sub

Sub DecryptText(EncryptedData() As Byte, password As String) As String
	Dim c As B4XCipher
	Dim b() As Byte = c.Decrypt(EncryptedData, password)
	Return BytesToString(b, 0, b.Length, "utf8")
End Sub