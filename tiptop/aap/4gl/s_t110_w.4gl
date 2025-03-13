# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
#Modify.........: No.8623 03/11/04 Kitty 直接付款副程式之t110_aph_b()FUNCTION中的Transcation有部份不完整,
#                                         使得程式偶會發生連續做直接付款時的問題
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法 
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0191 04/10/12 By ching 滑鼠按確定未存檔
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-520131 05/02/25 By Kitty 程式 455 行 LET g_aph[l_ac].aph05 應依幣別取位
# Modify ........: No.MOD-530009 05/03/04 By Kitty 匯率不能開窗
# Modify.........: No.FUN-530015 05/03/15 By Nicola 匯率自由格式設定
# Modify.........: No.MOD-530307 05/03/31 By Nicola 金額做幣別取位設定
# Modify.........: No.FUN-550037 05/05/13 By saki   欄位comment顯示
# Modify.........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify.........: No.MOD-560240 05/07/22 By Smapmin 直接付款時,選'2.T/T',其銀行幣別應為disable
# Modify.........: No.MOD-560239 05/08/11 By Smapmin 單身存提異動碼輸入時應chech合理性, 即使按 '放棄'也應check後才可離開
# Modify.........: No.MOD-590054 05/10/20 By Smapmin 將銀行異動碼放入ARRAY中
# Modify.........: No.MOD-590440 05/11/03 By ice 依月底重評價對AP未付金額調整,修正未付金額apa73的計算方法
# Modify.........: No.MOD-5B0200 05/11/24 By Smapmin 1.單身類別為6.7.8.9時,匯率要 set noentry.
#                                                    2.1時,銀行異動碼要可以不輸入.
#                                                    3.1.2.3時,銀行要可以輸入.
#                                                    4.1.2時,銀行開窗要過濾只能是1.2.(1只能開1.2只能開2)
#                                                    5.2時,銀行異動碼要可以輸入,且一定要有值.
# Modify.........: No.TQC-5C0094 05/12/27 By Smapmin 直接付款放棄時要能離開畫面
# Modify.........: No.MOD-5B0132 06/01/02 By Smapmin 會科與銀行位置互換.選擇1.支存 2.T/T 其會科應從銀行基本資料帶出.
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630110 06/03/14 By Smapmin 抓取t_azi04,g_azi04
# Modify.........: No.TQC-630104 06/03/14 By Smapmin DISPLAY ARRAY 無控制單身筆數
# Modify.........: No.TQC-630178 06/03/17 By Smapmin 類別維護方式改為COMBOBOX
# Modify.........: No.MOD-630122 06/03/31 By Smapmin 修改銀行欄位的控制
# Modify.........: No.FUN-640022 06/04/08 By kim GP3.0 匯率參數功能改善
# Modify.........: No.TQC-630088 06/04/09 By Smapmin 直接付款金額回寫到apa35f,apa35
# Modify.........: No.MOD-640555 06/04/25 By Smapmin 付款日=到期日且apz52<>'1',會科抓 nma05
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.MOD-660098 06/06/27 By Smapmin 修正幣別取位
# Modify.........: No.FUN-660192 06/07/04 By Smapmin 付款類別多A,B,C,Z四個選項
# Modify.........: No.FUN-680027 06/08/14 By wujie   多帳期修改
 
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.CHI-6A0004 06/10/30 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能	
# Modify.........: No.TQC-6B0066 06/11/28 By wujie  多帳期二次修改
# Modify.........: No.MOD-690026 06/12/19 By Smapmin FUN-640170追單,並增加"轉帳"
# Modify.........: No.TQC-6C0044 06/12/22 By Smapmin 修改回寫待抵已付金額
# Modify.........: No.MOD-710189 07/01/31 By Smapmin 用apg05f/apg05 UPDATE apa35f/apa35
# Modify.........: No.TQC-720051 07/03/01 By Smapmin 付款時,回寫待抵已付金額的時機,應加條件加以過濾
# Modify.........: No.MOD-740014 07/04/04 By Smapmin 已確認之單據不應再更改付款金額
# Modify.........: No.FUN-730064 07/04/04 By dxfwo    會計科目加帳套
# Modify.........: No.MOD-730098 07/04/16 By Smapmin 修改UPDATE apa_file 的錯誤訊息判斷
# Modify.........: No.TQC-740093 07/04/19 By bnlent  會計科目加帳套BUG修改
# Modify.........: No.MOD-740369 07/04/24 By bwujie  直接付款帶出的金額錯，應該從子帳期帶默認值
# Modify.........: No.TQC-740314 07/04/25 By wujie  "衝帳"作業中"本幣衝帳"金額計算錯誤
# Modify.........: No.TQC-750121 07/05/22 By rainy 直接付款子帳期判斷應與aapt330相同
# Modify.........: No.TQC-750140 07/05/24 By rainy 報銷還款的直接付款類別選項應與aapt331相同
# Modify.........: No.TQC-750177 07/05/24 By rainy aapt121(報銷還款) ""直接付款"" 時   若選 8.借款待抵 應該只可查 aapq231(員工借支待抵資料)當 apa00='13' ,'17' 時,其它情況不可影響到 
# Modify.........: No.FUN-770043 07/08/17 By Smapmin 確認後仍需要看直接沖帳的資料
# Modify.........: No.MOD-770120 07/08/17 By Smapmin 確認後查看直接付款金額,單身合計值未顯示
# Modify.........: No.MOD-780121 07/08/17 By Smapmin 錯誤訊息顯示錯誤
# Modify.........: No.MOD-770123 07/08/23 By Smapmin 修改付款單身異動碼輸入與否控管
# Modify.........: No.TQC-790108 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.TQC-790131 07/09/25 By wujie  在應付帳款里按“直接付款”，在付款畫面里如果是第二次進去修改付款單身時會出錯
#                                                   進入直接付款一筆原有的單身資料，即使不作修改，科目也會被重新預設
# Modify.........: No.TQC-790179 07/10/09 By wujie  直接付款時帶出默認的會計科目給aph041，使得會計分錄底稿二的科目有值
# Modify.........: No.TQC-7A0095 07/10/25 By chenl  修正"更改銀行時，科目不自動更新"的問題。
# Modify.........: No.MOD-7B0009 07/11/02 By cnenl  1.修正更新apc_file時的條件錯誤。
# Modify.........:                                  2.before field aph05f時，不再對aph05進行賦值。
# Modify.........:                                  3.在插入apg_file時，將根據apc_file帳期進行一對一插入，即按照子帳期設置進行apg_file的新增和修改。
# Modify.........: No.MOD-7B0219 07/11/26 By Smapmin 修改付款部分預設金額
# Modify.........: No.TQC-7C0005 07/12/03 By wujie   去除多余的insert apg動作，以免與審核時的apg資料衝突
# Modify.........: No.TQC-7C0140 07/12/11 By chenl   1.若已有付款金額，且幣種及匯率不變，則不必自動帶出金額。
# Modify.........:                                   2.修正匯率變更后，金額換算問題。
# Modify.........: No.MOD-7C0121 07/12/18 By Smapmin 沖帳金額不可大於未沖金額
# Modify.........: No.FUN-820052 08/02/27 By Smapmin 付款類別為6/7/8/9時,帳款編號開窗僅顯示同一付款廠商的資料
#                                                    子帳期項次預設為1
# Modify.........: No.MOD-820129 08/02/27 By Smapmin 為暫估帳款不能進行沖帳
# Modify.........: No.MOD-820064 08/02/28 By Smapmin 修正MOD-7B0009
# Modify.........: No.MOD-810260 08/02/28 By Smapmin 修改單身付款金額預設值
#                                                    修改已沖金額回寫部份
# Modify.........: No.MOD-830059 08/03/11 By Smapmin insert into apg_file 的動作移到update apc_file當下再處理
#                                                    修正MOD-7C0121
# Modify.........: No.MOD-840458 08/04/25 By Carrier 直接付款時,請去掉留置金額
# Modify.........: No.TQC-860021 08/06/10 By Sarah DISPLAY ARRAY段漏了ON IDLE控制
# Modify.........: No.MOD-860098 08/06/12 By Sarah AFTER FIELD aph08段增加呼叫s_bankex()
# Modify.........: No.CHI-850023 08/07/04 By Sarah 把所有UPDATE段後面的判斷都改為IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN,而非IF STATUS THEN
# Modify.........: No.MOD-870048 08/07/08 By Sarah 刪除資料前都需先COUNT有沒有資料,有的話才做刪除的動作
# Modify.........: No.MOD-870279 08/07/30 By Sarah AFTER FIELD aph13,aph14段,以azi07對aph14取位
# Modify.........: No.MOD-880080 08/08/18 By Sarah 直接付款先不更新apa35f,apa35,於確認後再更新
# Modify.........: No.MOD-880222 08/08/27 By Sarah 為求直接付款未確認時更新apa_file與apc_file一致性,改回原先做法(將MOD-880080取消,改回原做法)
# Modify.........: No.MOD-8A0119 08/10/16 By Sarah 直接付款時若類別為'4','5'時,原幣金額預設值為0
# Modify.........: No.MOD-8A0282 08/11/07 By Sarah 只需判斷本幣金額大於0就將apa55改成'2'
# Modify.........: No.MOD-8B0300 08/12/01 By Sarah 直接付款開放輸入付款日(apa12)
# Modify.........: No.TQC-8C0003 08/12/02 By Sarah CALL t110_upd_apc_date()改成CALL t110_upd_apc_date_w()
# Modify.........: No.MOD-940321 09/04/24 By lilingyu AFTER FIELD aph05f段后增加DISPLAY BY NAME aph05f
# Modify.........: No.MOD-980029 09/08/05 By mike FUNCTION t110_w(),INPUT段改成只能修改apa02,改完apa02后,直接LET apa12=apa02        
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0188 09/11/05 By Sarah 排除r.c2的錯誤
# Modify.........: No.FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No.MOD-9C0170 09/12/18 By sabrina 錯誤訊息不需給預設值 
# Modify.........: No.MOD-9C0187 09/12/18 By sabrina 直接付款，若有匯差時，帶出的金額錯誤 
# Modify.........: No:FUN-970077 10/03/11 By chenmoyan add aph18,aph19
# Modify.........: No:FUN-A20010 10/03/11 By chenmoyan add aph20
# Modify.........: No.TQC-A30078 10/03/16 By Carrier q_apw传帐套                
# Modify.........: No.TQC-A30083 10/03/16 By Carrier 付款类型为2.转帐时,要限制所选银行的性质为2.活存
# Modify.........: No.TQC-B30165 11/03/22 By yinhy 直接付款金额不可大於未付金額，原幣或者本幣一方已付完另一方必須也付完
# Modify.........: No.CHI-B60090 11/07/26 By Polly 增加判斷，如果參數:是大陸，則不做aap-804檢核
# Modify.........: No.MOD-B70124 11/07/13 By Carrier aph16的开窗修改为q_nmc1,仅为'提出'性质
# Modify.........: No.TQC-B90007 11/09/02 By guoch 直接付款金额判断有误，进行修正
# Modify.........: No.MOD-BC0174 11/12/19 Byb Polly 增加「直接付款」Lock住單頭資料功能 
# Modify.........: No.MOD-BB0088 12/02/09 By jt_chen FUNCTION t110_w 中 LET l_apg05f=g_apg.apg05f 與 l_apg05=g_apg.apg05 移至 OPEN WINDOW t110_w_w 前給予 
# Modify.........: No.MOD-C70214 12/08/03 By Elise 若第二次以後要再增加直接付款金額
# Modify.........: No.TQC-BC0052 12/10/08 By yinhy AFTER FIELD aph04增加判断
# Modify.........: No.FUN-C50126 12/12/22 By Abby HRM改善功能:增加類別G,代表"代扣款(HRM整合專用)"
# Modify.........: No.FUN-CC0142 13/01/11 By Nina HRM改善功能:增加類別H,代表"代扣款(HRM整合專用)"=>改為類別H
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_apa	    RECORD LIKE apa_file.*,
       g_aps	    RECORD LIKE aps_file.*,
       m_aph        RECORD LIKE aph_file.*,
       g_apg        RECORD LIKE apg_file.*,
       g_apg_o      RECORD LIKE apg_file.*,    #MOD-860098 add
       g_aph        DYNAMIC ARRAY OF RECORD #Program Variables No.MOD-480007
                       aph02   LIKE aph_file.aph02,
                       aph03   LIKE aph_file.aph03,
                       aph08   LIKE aph_file.aph08,   #MOD-5B0132
                       aph04   LIKE aph_file.aph04,   #MOD-5B0132
                       aph17   LIKE aph_file.aph17,   #No.FUN-680027
                       aph16   LIKE aph_file.aph16,   #MOD-590054
                       nmc02   LIKE nmc_file.nmc02,   #MOD-590054
                       aph07   LIKE aph_file.aph07,
                       aph09   LIKE aph_file.aph09,
                       aph13   LIKE aph_file.aph13,
                       aph14   LIKE aph_file.aph14,
                       aph05f  LIKE aph_file.aph05f,
                       aph05   LIKE aph_file.aph05
                      ,aph18   LIKE aph_file.aph18,   #FUN-A20010                                                                   
                       aph19   LIKE aph_file.aph19,   #FUN-A20010                                                                   
                       aph20   LIKE aph_file.aph20    #FUN-A20010
                    END RECORD,
       g_aph_t      RECORD
                       aph02   LIKE aph_file.aph02,
                       aph03   LIKE aph_file.aph03,
                       aph08   LIKE aph_file.aph08,   #MOD-5B0132
                       aph04   LIKE aph_file.aph04,   #MOD-5B0132
                       aph17   LIKE aph_file.aph17,   #No.FUN-680027
                       aph16   LIKE aph_file.aph16,   #MOD-590054
                       nmc02   LIKE nmc_file.nmc02,   #MOD-590054
                       aph07   LIKE aph_file.aph07,
                       aph09   LIKE aph_file.aph09,
                       aph13   LIKE aph_file.aph13,
                       aph14   LIKE aph_file.aph14,
                       aph05f  LIKE aph_file.aph05f,
                       aph05   LIKE aph_file.aph05
                      ,aph18   LIKE aph_file.aph18,   #FUN-A20010                                                                   
                       aph19   LIKE aph_file.aph19,   #FUN-A20010                                                                   
                       aph20   LIKE aph_file.aph20    #FUN-A20010
                    END RECORD
DEFINE g_aph_o      RECORD
                       aph02   LIKE aph_file.aph02,
                       aph03   LIKE aph_file.aph03,
                       aph08   LIKE aph_file.aph08,   #MOD-5B0132
                       aph04   LIKE aph_file.aph04,   #MOD-5B0132
                       aph17   LIKE aph_file.aph17,   #No.FUN-680027
                       aph16   LIKE aph_file.aph16,   #MOD-590054
                       nmc02   LIKE nmc_file.nmc02,   #MOD-590054
                       aph07   LIKE aph_file.aph07,
                       aph09   LIKE aph_file.aph09,
                       aph13   LIKE aph_file.aph13,
                       aph14   LIKE aph_file.aph14,
                       aph05f  LIKE aph_file.aph05f,
                       aph05   LIKE aph_file.aph05
                      ,aph18   LIKE aph_file.aph18,   #FUN-A20010                                                                   
                       aph19   LIKE aph_file.aph19,   #FUN-A20010                                                                   
                       aph20   LIKE aph_file.aph20    #FUN-A20010
                    END RECORD
DEFINE aph05f_t     LIKE aph_file.aph05f
DEFINE aph05_t      LIKE aph_file.aph05
DEFINE l_apg05f     LIKE apg_file.apg05f
DEFINE l_apg05      LIKE apg_file.apg05
DEFINE l_azi04      LIKE azi_file.azi04
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-690028 INTEGER
DEFINE g_msg        LIKE type_file.chr1000  #No.FUN-690028 VARCHAR(72)
DEFINE g_flag       LIKE type_file.chr1     #TQC-740093                                                                     
DEFINE g_bookno1    LIKE aza_file.aza81     #FUN-730064                                                                     
DEFINE g_bookno2    LIKE aza_file.aza82     #FUN-730064  
DEFINE g_rec_b      LIKE type_file.num5                #單身筆數  #No.FUN-690028 SMALLINT
DEFINE g_sql        STRING   #TQC-6C0044
DEFINE l_ac         LIKE type_file.num5     #MOD-770123   
DEFINE g_aph041     LIKE aph_file.aph041    #No.TQC-790179
DEFINE g_apa02_t    LIKE apa_file.apa02     #MOD-8B0300 add
DEFINE g_apa12_t    LIKE apa_file.apa12     #MOD-8B0300 add
DEFINE g_apa24_t    LIKE apa_file.apa24     #MOD-8B0300 add
DEFINE g_apa64_t    LIKE apa_file.apa64     #MOD-8B0300 add
 
FUNCTION t110_w(p_no)
   DEFINE p_no	     LIKE apa_file.apa01    #FUN-660117 #CHAR(16)
   DEFINE l_paydate  LIKE type_file.dat     #MOD-8B0300 add
 
   WHENEVER ERROR CONTINUE
 
   SELECT * INTO g_apa.* FROM apa_file
    WHERE apa01=p_no
   IF STATUS THEN 
      CALL cl_err3("sel","apa_file",p_no,"",STATUS,"","sel apa:",1)  #No.FUN-660122
      RETURN
   END IF
   LET g_apa02_t = g_apa.apa02   #MOD-8B0300 add
   LET g_apa12_t = g_apa.apa12   #MOD-8B0300 add
   LET g_apa24_t = g_apa.apa24   #MOD-8B0300 add
   LET g_apa64_t = g_apa.apa64   #MOD-8B0300 add
 
   IF s_aapshut(0) THEN
      RETURN
   END IF
 
   IF g_apa.apa01 IS NULL THEN 
      RETURN
   END IF
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_apa.apa13
 
   IF g_apa.apa41 = 'N' AND g_apa.apaacti ='Y' THEN 
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	

  #---------------------------------MOD-BC0174------------------------start
   LET g_forupd_sql = "SELECT * FROM apa_file WHERE apa01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t110_cl CURSOR FROM g_forupd_sql
   LET g_success = 'Y'    #No:8623
   BEGIN WORK
   OPEN t110_cl USING g_apa.apa01
   IF STATUS THEN
      CALL cl_err("OPEN t110_cl b:", STATUS, 1)
      CLOSE t110_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t110_cl INTO g_apa.*            # 鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        CALL cl_err(g_apa.apa01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t110_cl
        ROLLBACK WORK
        RETURN
     END IF
  #----------------------------------MOD-BC0174--------------------------end
 
      INPUT BY NAME g_apa.apa02 WITHOUT DEFAULTS ATTRIBUTES(REVERSE)  #MOD-980029                        
         AFTER FIELD apa02 #MOD-980029                                                                                              
            LET g_apa.apa12=g_apa.apa02  #MOD-980029    
            IF (g_apa.apa00[1,1] = '1' OR   #MOD-860203
                g_apa.apa00='21' OR g_apa.apa00='22' OR g_apa.apa00='26') AND   #MOD-860203 add
                g_apa.apa12 IS NOT NULL THEN
               IF g_apa12_t IS NULL OR g_apa12_t<>g_apa.apa12 THEN
                  IF g_apa.apa00 = '13' OR g_apa.apa00 = '17' THEN
                     CALL s_paydate('a','',g_apa.apa09,g_apa.apa02,g_apa.apa11,'EMPL')
                        RETURNING l_paydate,g_apa.apa64,g_apa.apa24   #No.+106
                  ELSE
                     CALL s_paydate('a','',g_apa.apa09,g_apa.apa02,g_apa.apa11,
                                    g_apa.apa06)
                        RETURNING l_paydate,g_apa.apa64,g_apa.apa24   #No.+106
                  END IF
                  DISPLAY BY NAME g_apa.apa24,g_apa.apa64
               END IF
               IF g_apa12_t IS NULL OR g_apa12_t<>g_apa.apa12 THEN
                  CALL t110_upd_apc_date_w()   #TQC-8C0003 mod
               END IF
            END IF
            LET g_apa12_t = g_apa.apa12
 
         AFTER INPUT
            IF g_apa.apa02 IS NULL THEN
               IF NOT INT_FLAG THEN   #MOD-8B0300 add
                  NEXT FIELD apa02
               END IF                 #MOD-8B0300 add
            END IF
            IF g_apa.apa12 IS NULL THEN
               IF NOT INT_FLAG THEN
                  NEXT FIELD apa12
               END IF
            END IF
            IF INT_FLAG THEN
               LET g_apa.apa02=g_apa02_t
               LET g_apa.apa12=g_apa12_t
               LET g_apa.apa24=g_apa24_t
               LET g_apa.apa64=g_apa64_t
               DISPLAY BY NAME g_apa.apa02,g_apa.apa12,
                               g_apa.apa24,g_apa.apa64
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE t110_cl                                     #MOD-BC0174 add
         ROLLBACK WORK                                     #MOD-BC0174 add
         RETURN 
      END IF
 
      UPDATE apa_file SET apa02 = g_apa.apa02
                         ,apa12 = g_apa.apa12   #MOD-8B0300 add
                         ,apa24 = g_apa.apa24   #MOD-8B0300 add
                         ,apa64 = g_apa.apa64   #MOD-8B0300 add
       WHERE apa01 = g_apa.apa01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_apa.apa01,SQLCA.sqlcode,0)
         LET g_success='N'
      END IF
      CALL s_get_bookno(YEAR(g_apa.apa02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(g_apa.apa02,'aoo-081',1)
      END IF
 
   END IF
 
   IF g_apz.apz13 = 'Y' THEN
      SELECT * INTO g_aps.* FROM aps_file
       WHERE aps01 = g_apa.apa22
   ELSE
      SELECT * INTO g_aps.* FROM aps_file 
       WHERE (aps01 = ' ' OR aps01 IS NULL)
   END IF
   DECLARE t110_aph_curs CURSOR FOR
        SELECT aph02,aph03,aph08,aph04,aph17,
               aph16,'',aph07,aph09,aph13,aph14,
               aph05f,aph05,aph18,aph19,aph20   #FUN-A20010   #MOD-5B0132   #No.FUN-680027
          FROM aph_file
         WHERE aph01 = g_apa.apa01
         ORDER BY aph02   #No.FUN-680027
   CALL g_aph.clear() 
   LET g_cnt = 1
   FOREACH t110_aph_curs INTO g_aph[g_cnt].*   #單身 ARRAY 填充
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT nmc02 INTO g_aph[g_cnt].nmc02 FROM nmc_file
           WHERE nmc01 = g_aph[g_cnt].aph16
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err('',9035,0)
        EXIT FOREACH
     END IF
   END FOREACH
   CALL g_aph.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
   LET g_apg.apg05f=0 LET g_apg.apg05=0
   SELECT SUM(apg05f),SUM(apg05) INTO g_apg.apg05f,g_apg.apg05 FROM apg_file  #No.MOD-7B0009
    WHERE apg01=g_apa.apa01
   IF cl_null(g_apg.apg05f) THEN LET g_apg.apg05f = 0 END IF #MOD-C70214 add
   IF cl_null(g_apg.apg05) THEN LET g_apg.apg05 = 0 END IF   #MOD-C70214 add
   IF cl_null(g_apa.apa20) THEN LET g_apa.apa20 = 0 END IF   #No.MOD-840458
   IF g_apa.apa41 = 'N' THEN 
      IF cl_null(g_apg.apg05f) OR g_apg.apg05f=0 THEN 
         LET g_apg.apg05f=g_apa.apa34f-g_apa.apa35f - g_apa.apa20
          LET g_apg.apg05f=cl_digcut(g_apg.apg05f,t_azi04)   #No.MOD-530307 
         #LET l_apg05f=g_apg.apg05f   #MOD-BB0088  --mark
      END IF
      IF cl_null(g_apg.apg05) OR g_apg.apg05=0 THEN 
         IF g_apz.apz27 = 'N' THEN                                                                                                  
            LET g_apg.apg05=g_apa.apa34-g_apa.apa35 - g_apa.apa20 * g_apa.apa14
         ELSE                                                                                                                       
            LET g_apg.apg05=g_apa.apa73 - g_apa.apa20 * g_apa.apa72
         END IF                                                                                                                     
         LET g_apg.apg05=cl_digcut(g_apg.apg05,g_azi04)   #No.MOD-530307    #MOD-820064 取消mark
         #LET l_apg05=g_apg.apg05     #MOD-BB0088  --mark
      END IF
   END IF
   LET l_apg05f=g_apg.apg05f   #MOD-BB0088 add
   LET l_apg05=g_apg.apg05     #MOD-BB0088 add
   OPEN WINDOW t110_w_w AT 10,2 WITH FORM "aap/42f/aapt110_w"
               ATTRIBUTE (STYLE = g_win_style CLIPPED)  #MOD-9A0188
 
    CALL cl_ui_locale("aapt110_w")
    CALL t110_set_comb()   #TQC-630178
 
 
   #FUN-970077---Begin
    IF g_aza.aza73  = 'Y' AND g_aza.aza26  = '0' THEN
       CALL cl_set_comp_visible("aph18,aph19,aph20",TRUE) #FUN-A20010 add aph20
    ELSE
       CALL cl_set_comp_visible("aph18,aph19,aph20",FALSE)#FUN-A20010 add aph20
    END IF
   #FUN-970077---End
   DISPLAY BY NAME g_apg.apg05f,g_apg.apg05 
   DISPLAY ARRAY g_aph TO s_aph.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF g_apa.apa41<>'Y' THEN   #FUN-770043
            EXIT DISPLAY
         ELSE   #MOD-770120
            CALL t110_aph_tot()   #MOD-770120
         END IF   #FUN-770043      
 
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
 
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE DISPLAY      #TQC-860021
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
   END DISPLAY
   IF g_apa.apaacti ='N' THEN
      CALL cl_err(g_apa.apa01,'9027',1) CLOSE WINDOW t110_w_w RETURN
   END IF
   IF g_apa.apa41<>'Y' THEN   #FUN-770043
      CALL t110_aph_tot()   #MOD-740014
      CALL t110_aph_b()
   END IF   #FUN-770043
   CLOSE WINDOW t110_w_w
END FUNCTION
 
FUNCTION t110_upd_apc_date_w()
   SELECT COUNT(*) INTO g_cnt FROM apc_file WHERE apc01 =g_apa.apa01
   IF g_cnt >1 THEN
      RETURN
   END IF
   IF g_cnt =1 THEN
      UPDATE apc_file SET apc04 =g_apa.apa12,
                          apc05 =g_apa.apa64
       WHERE apc01 =g_apa.apa01
   END IF
END FUNCTION
 
FUNCTION t110_apg()
  DEFINE l_unpay1,l_unpay2   LIKE type_file.num20_6  #No.TQC-B30165
  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
  LET g_apg_o.apg05f = g_apg.apg05f    #MOD-860098 add
  LET l_unpay1 = g_apa.apa34f - g_apa.apa35f   #TQC-B30165
  LET l_unpay2 = g_apa.apa34  - g_apa.apa35    #TQC-B30165
 
  INPUT BY NAME g_apg.apg05f,g_apg.apg05 WITHOUT DEFAULTS HELP 1
    AFTER FIELD apg05f
      IF cl_null(g_apg.apg05f) THEN NEXT FIELD apg05f END IF
      SELECT azi04 INTO t_azi04 FROM azi_file    #MOD-660098
                  WHERE azi01=g_apa.apa13   #MOD-660098
       LET g_apg.apg05f=cl_digcut(g_apg.apg05f,t_azi04)   #No.MOD-530307 
     #IF g_apg.apg05f > l_apg05f THEN             #MOD-C70214 mark
      IF g_apg.apg05f > l_unpay1 + l_apg05f THEN  #MOD-C70214
         CALL cl_err(l_apg05f,'aap-194',0)
         NEXT FIELD apg05f
      END IF
      #No.TQC-B30165  --Begin
     # IF g_apg.apg05f > l_unpay1 THEN  #TQC-B90007  mark
      IF g_apg.apg05f > g_apa.apa34f THEN #TQC-B90007 add
         CALL cl_err(l_apg05f,'aapt003',0)
         NEXT FIELD apg05f
      END IF
      #No.TQC-B30165  --End
      #當有修改原幣金額時才需重算本幣金額
      IF g_apg_o.apg05f != g_apg.apg05f THEN    #MOD-860098 add
         LET g_apg.apg05=g_apg.apg05f* g_apa.apa14
         LET g_apg.apg05=cl_digcut(g_apg.apg05,g_azi04)     #No.MOD-7B0009 mark   #MOD-820064 取消mark
      END IF                                    #MOD-860098 add
      DISPLAY BY NAME g_apg.apg05f  #MOD-820064
 
    AFTER FIELD apg05
      IF cl_null(g_apg.apg05) THEN NEXT FIELD apg05 END IF
      LET g_apg.apg05=cl_digcut(g_apg.apg05,g_azi04)  #No.MOD-530307 #No.MOD-7B0009 mark   #MOD-820064 取消mark
     #IF g_apg.apg05 > l_apg05 THEN             #MOD-C70214 mark
      IF g_apg.apg05 > l_unpay2 + l_apg05 THEN  #MOD-C70214
         CALL cl_err(l_apg05,'aapt003',0)
         NEXT FIELD apg05
      END IF
      #No.TQC-B30165  --Begin
     # IF g_apg.apg05 > l_unpay2 THEN #TQC-B90007 mark
      IF g_apg.apg05 > g_apa.apa34 THEN #TQC-B90007 add
         CALL cl_err(l_apg05,'aap-194',0)
         NEXT FIELD apg05
      END IF
      #No.TQC-B30165  --End
 
    AFTER INPUT
      IF cl_null(g_apg.apg05f) THEN NEXT FIELD apg05f END IF
      IF cl_null(g_apg.apg05)  THEN NEXT FIELD apg05  END IF
      
      #No.TQC-B30165   --Begin
      IF g_apg.apg05f = l_unpay1 AND g_apg.apg05 < l_unpay2 THEN
         CALL cl_err('','aapt004',0)
         NEXT FIELD apg05
      END IF 
      IF g_apg.apg05 = l_unpay2 AND g_apg.apg05f < l_unpay1 THEN
         CALL cl_err('','aapt005',0)
         NEXT FIELD apg05f
      END IF 
      #No.TQC-B30165   --End
      UPDATE apa_file SET apa35f = g_apg.apg05f,
                          apa35 = g_apg.apg05,
                          apa73 = g_apa.apa34 - g_apg.apg05
        WHERE apa01 = g_apa.apa01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN  
         CALL cl_err(g_apa.apa01,SQLCA.sqlcode,0)
         LET g_success='N'   
      END IF
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
  END INPUT 
 
END FUNCTION
 
FUNCTION t110_aph_b()
DEFINE
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
    l_apa41  LIKE apa_file.apa41,          #FUN-660117
    l_apa42  LIKE apa_file.apa42,          #FUN-660117
    l_apa74  LIKE apa_file.apa74,          #FUN-660117
    l_apa13         LIKE apa_file.apa13,
    l_apa14         LIKE apa_file.apa14,
    g_qty1,g_qty2   LIKE type_file.num20_6,   # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    ddd             LIKE type_file.chr8,      # No.FUN-690028 VARCHAR(6),
    mm              LIKE type_file.num5,                #  #No.FUN-690028 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
    l_aptype        LIKE apa_file.apa00,      # No.FUN-690028  VARCHAR(2),               # 
    l_type          LIKE type_file.chr2,      # No.FUN-690028 VARCHAR(2),                #
    l_nma21         LIKE nma_file.nma21,
    l_allow_insert  LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    l_cnt   LIKE type_file.num5,     #MOD-590054  #No.FUN-690028 SMALLINT
    l_nma28         LIKE nma_file.nma28,  #MOD-5B0132
    l_aph05f        LIKE aph_file.aph05f, #MOD-740369
    l_aph05         LIKE aph_file.aph05,  #MOD-740369
    l_aph05f_sum    LIKE aph_file.aph05f, #MOD-740369
    l_aph05_sum     LIKE aph_file.aph05,  #MOD-740369
    l_n1            LIKE type_file.num5,  #TQC-BC0052
    l_apa08         LIKE apa_file.apa08   #MOD-820129
 
DEFINE l_flag       LIKE type_file.chr1   #No.TQC-740314
#FUN-A20010 --Begin                                                                                                                 
DEFINE l_pmf11      LIKE pmf_file.pmf11
DEFINE l_pmf14      LIKE pmf_file.pmf14
DEFINE l_pmf15      LIKE pmf_file.pmf15
#FUN-A20010 --End


#str------- add by dengsy161223   #mark by wanghao 201102 -str
#DEFINE l_nmd08   LIKE nmd_file.nmd08,
#       l_nmd10   LIKE nmd_file.nmd10,
#       l_nmd30   LIKE nmd_file.nmd30,
#       l_nmd04   LIKE nmd_file.nmd04,
#       l_nmd55   LIKE nmd_file.nmd55,
#       l_nmd21   LIKE nmd_file.nmd21,
#       l_nmd19   LIKE nmd_file.nmd19
#end------- add by dengsy161223  #mark by wanghao 201102 -end
#150615wudj-str
DEFINE l_nmd08   LIKE nmd_file.nmd08,
       l_nmd10   LIKE nmd_file.nmd10,
       l_nmd30   LIKE nmd_file.nmd30,
       l_nmd04   LIKE nmd_file.nmd04,
       l_nmd55   LIKE nmd_file.nmd55,
       l_nmd21   LIKE nmd_file.nmd21,
       l_nmd19   LIKE nmd_file.nmd19
DEFINE l_sql string
DEFINE l_nmh record like nmh_file.*
DEFINE l_nmh02   like nmh_file.nmh02
DEFINE tot1   like nmh_file.nmh02
DEFINE l_aph14   LIKE aph_file.aph14 
DEFINE l_aph13   LIKE aph_file.aph13 
DEFINE l_aph07   LIKE aph_file.aph07 
DEFINE l_aph04   LIKE aph_file.aph04 
   DEFINE l_nmydmy3       LIKE nmy_file.nmydmy3
DEFINE l_aph04_o LIKE aph_file.aph04       
#150615wudj-end
#--add by lifang 201104 begin#
   DEFINE l_sum_aph05f    LIKE aph_file.aph05f,
          l_sum_aph05     LIKE aph_file.aph05
#--add by lifang 201104 end#
 
#FUN-A20010 --Begin                                                                                                                 
#   LET g_forupd_sql = "SELECT aph02,aph03,aph08,aph18,aph19,aph04,aph17,",
#                      "       aph16,'',aph07,aph09,aph13,",   #MOD-5B0132   #No.FUN-680027 #FUN-970077 add aph18,aph19             
#                      "       aph14,aph05f,aph05 FROM aph_file",
    LET g_forupd_sql = "SELECT aph02,aph03,aph08,aph04,aph17,aph16,'',aph07,",
                       "       aph09,aph13,",
                       "       aph14,aph05f,aph05,aph18,aph19,aph20 FROM aph_file",
#FUN-A20010 --End
                       " WHERE aph01=? AND aph02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t110_aph_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   #LET g_success = 'Y'    #No:8623      #MOD-BC0174 mark
   #BEGIN WORK                           #MOD-BC0174 mark
    CALL t110_aph_tot()
    CALL t110_apg()  
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_aph WITHOUT DEFAULTS FROM s_aph.* HELP 1
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd='' 
            LET l_flag ='N'     #No.TQC-740314 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            CALL t110_w_set_entry()
            CALL t110_w_set_no_entry()
            IF g_rec_b >= l_ac THEN
               LET g_aph_t.* = g_aph[l_ac].*  #BACKUP
               LET g_aph_o.* = g_aph[l_ac].*  #BACKUP     #No.TQC-790131
               LET p_cmd='u'
               OPEN t110_aph_bcl USING g_apa.apa01,g_aph_t.aph02
               IF STATUS THEN
                  CALL cl_err("OPEN t110_aph_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH t110_aph_bcl INTO g_aph[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_aph_t.aph02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT nmc02 INTO g_aph[l_ac].nmc02 FROM nmc_file
                  WHERE nmc01 = g_aph[l_ac].aph16
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               CANCEL INSERT
            END IF
 
            IF g_aph[l_ac].aph03 MATCHES "[6789]" THEN   #TQC-720051
               LET g_sql = "UPDATE apa_file ",
                           "   SET apa35f = apa35f + ?, ",
                           "       apa35  = apa35 + ?, ",
                           "       apa73  = apa73 - ?  ",
                           " WHERE apa01= ? "
               PREPARE apa_ins_c1 FROM g_sql
               IF STATUS THEN
                  CALL cl_err('apa_ins_c1',status,1)
                  LET g_success='N'
                  CANCEL INSERT
               END IF
               EXECUTE apa_ins_c1 USING g_aph[l_ac].aph05f,g_aph[l_ac].aph05,
                                       g_aph[l_ac].aph05,g_aph[l_ac].aph04
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err(g_aph[l_ac].aph04,SQLCA.sqlcode,0)
                  LET g_success='N'
                  CANCEL INSERT
               END IF
            END IF   #TQC-720051
 
            INSERT INTO aph_file(aph01,aph02,aph03,aph08,aph18,aph19,aph04,aph041,aph17,aph16,aph07,aph09,   #MOD-5B0132    #No.TQC-790179#FUN-970077 add aph18,aph19
                                 aph13,aph14,aph05f,aph05,aph20,aphlegal)   #MOD-590054 #FUN-980001 add legal#FUN-970077
                 VALUES(g_apa.apa01,g_aph[l_ac].aph02,g_aph[l_ac].aph03,
                        g_aph[l_ac].aph08,g_aph[l_ac].aph18,g_aph[l_ac].aph19,            #FUN-970077 add aph18/19
                        g_aph[l_ac].aph04,g_aph041,g_aph[l_ac].aph17,g_aph[l_ac].aph16,   #FUN-680027    #No.TQC-790179
                        g_aph[l_ac].aph07,   #MOD-590054
                        g_aph[l_ac].aph09,g_aph[l_ac].aph13,g_aph[l_ac].aph14,
                        g_aph[l_ac].aph05f,g_aph[l_ac].aph05,g_aph[l_ac].aph20,g_legal)   #MOD-590054 #FUN-980001 add legal #FUN-A20010
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","aph_file",g_apa.apa01,g_aph[l_ac].aph02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
               CANCEL INSERT
               LET g_success='N'            #No:8623
            ELSE
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
#更新代扺帳款帳期內容。
               IF g_aph[l_ac].aph03 MATCHES"[6,7,8,9]" THEN            #No.MOD-7B0009
                  UPDATE apc_file SET apc10 =apc10+g_aph[l_ac].aph05f,
                                      apc11 =apc11+g_aph[l_ac].aph05,
                                      apc13 =apc13-g_aph[l_ac].aph05   #No.MOD-7B0009
                   WHERE apc01 =g_aph[l_ac].aph04                      #No.MOD-7B0009
                     AND apc02 =g_aph[l_ac].aph17
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
                     CALL cl_err3("upd","apc_file",g_aph[l_ac].aph04,g_aph[l_ac].aph17,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                     CANCEL INSERT
                     LET g_success='N'           
                  END IF
               END IF                                                  #No.MOD-7B0009
            END IF
            LET l_flag ='Y'          #No.TQC-790131
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aph[l_ac].* TO NULL      #900423
            LET g_aph[l_ac].aph07  = g_apa.apa02
            LET g_aph[l_ac].aph13  = g_apa.apa13
            LET g_aph[l_ac].aph14  = 1
            LET g_aph[l_ac].aph05f = 0
            LET g_aph[l_ac].aph05 = 0
            LET g_aph_t.* = g_aph[l_ac].*         #新輸入資料
            LET g_aph_o.* = g_aph[l_ac].*         #新輸入資料     #No.TQC-790131
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD aph02
 
        BEFORE FIELD aph02                        #default 序號
            IF g_aph[l_ac].aph02 IS NULL OR
               g_aph[l_ac].aph02 = 0 THEN
                SELECT max(aph02)+1
                   INTO g_aph[l_ac].aph02
                   FROM aph_file
                   WHERE aph01 = g_apa.apa01
                IF g_aph[l_ac].aph02 IS NULL THEN
                    LET g_aph[l_ac].aph02 = 1
                END IF
            END IF
 
        AFTER FIELD aph02                        #check 序號是否重複
            IF g_aph[l_ac].aph02 IS NULL THEN
               LET g_aph[l_ac].aph02 = g_aph_t.aph02 
               NEXT FIELD aph02
            END IF
            IF g_aph[l_ac].aph02 != g_aph_t.aph02 OR
               g_aph_t.aph02 IS NULL THEN
                SELECT count(*)
                  INTO l_n
                  FROM aph_file
                 WHERE aph01 = g_apa.apa01
                   AND aph02 = g_aph[l_ac].aph02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aph[l_ac].aph02 = g_aph_t.aph02
                    NEXT FIELD aph02
                END IF
            END IF
 
        BEFORE FIELD aph03
            IF g_aph[l_ac].aph03 = '1' AND 
               g_aph[l_ac].aph09 IS NOT NULL AND g_aph[l_ac].aph09 = 'Y'
            THEN CALL cl_err('','aap-085',1) NEXT FIELD aph02     # 已轉 NP
            END IF
            CALL t110_w_set_entry()   #MOD-770123
 
        AFTER FIELD aph03
            IF g_aph[l_ac].aph03 IS NULL THEN NEXT FIELD aph03 END IF
            IF g_aph_o.aph03 IS NULL OR g_aph_o.aph03 != g_aph[l_ac].aph03 THEN #MOD-5B0132
            CASE WHEN g_aph[l_ac].aph03 = '1'   #MOD-5B0132   #MOD-640555
                      LET g_aph[l_ac].aph04 = g_aps.aps24   #MOD-5B0132   #MOD-640555
                 WHEN g_aph[l_ac].aph03 = '3'
                      LET g_aph[l_ac].aph04 = g_aps.aps47
                 WHEN g_aph[l_ac].aph03 = '4'
                      LET g_aph[l_ac].aph04 = g_aps.aps43
                 WHEN g_aph[l_ac].aph03 = '5'
                      LET g_aph[l_ac].aph04 = g_aps.aps42
                 WHEN g_aph[l_ac].aph03 = 'A'
                      LET g_aph[l_ac].aph04 = g_aps.aps46
                 WHEN g_aph[l_ac].aph03 = 'B'
                      LET g_aph[l_ac].aph04 = g_aps.aps57
                 WHEN g_aph[l_ac].aph03 = 'C'
                      LET g_aph[l_ac].aph04 = g_aps.aps58
                 WHEN g_aph[l_ac].aph03 = 'Z'
                      LET g_aph[l_ac].aph04 = g_aps.aps56
            END CASE
            LET g_aph_o.aph03 = g_aph[l_ac].aph03   #MOD-5B0132
            END IF
            IF g_aph[l_ac].aph03='1' THEN 
                LET g_aph[l_ac].aph07 = g_apa.apa64
            END IF
            IF g_aph[l_ac].aph03 NOT MATCHES "[6789AB]" THEN
            SELECT apw03 INTO g_aph[l_ac].aph04 FROM apw_file
                   WHERE apw01=g_aph[l_ac].aph03
            END IF
#FUN-A20010 --Begin
          LET g_aph[l_ac].aph18 = ''
          LET g_aph[l_ac].aph19 = ''
          LET g_aph[l_ac].aph20 = ''
          IF g_aph[l_ac].aph03 = '2' THEN
             SELECT pmf14,pmf15,pmf11 INTO l_pmf14,l_pmf15,l_pmf11
               FROM pmf_file
              WHERE pmf01 = g_apa.apa05
                AND pmf08 = g_apa.apa13
                AND pmf05 = 'Y'
                AND pmfacti = 'Y'
             IF cl_null(g_aph[l_ac].aph18) THEN
                LET g_aph[l_ac].aph18 = l_pmf14
             END IF
             IF cl_null(g_aph[l_ac].aph19) THEN
                IF NOT cl_null(l_pmf15) THEN
                   LET g_aph[l_ac].aph19 = l_pmf15
                ELSE
                   LET g_aph[l_ac].aph19 = '1'
                END IF
             END IF
             IF cl_null(g_aph[l_ac].aph20) THEN
                LET g_aph[l_ac].aph20 = l_pmf11
             END IF
          ELSE
             IF cl_null(g_aph[l_ac].aph19) THEN
                LET g_aph[l_ac].aph19 = '1'
             END IF
          END IF
#FUN-A20010  --End
          CALL t110_w_set_no_entry()
 
       #MOD-9C0170---mark---start---
       #BEFORE FIELD aph04
       #    IF g_aph[l_ac].aph03 MATCHES "[6789]"
       #       THEN CALL cl_getmsg('aap-074',g_lang) RETURNING g_msg
       #       ELSE CALL cl_getmsg('aap-073',g_lang) RETURNING g_msg
       #    END IF
       #    ERROR g_msg CLIPPED
       #MOD-9C0170---mark---end---

        AFTER FIELD aph04
            IF g_aph[l_ac].aph04 IS NULL THEN NEXT FIELD aph04 END IF
            IF g_aph_t.aph04 IS NULL OR g_aph[l_ac].aph04!=g_aph_t.aph04 THEN
                IF g_aph[l_ac].aph03 NOT MATCHES "[6789DF]" THEN  #150615wudj add DF  
                 IF g_apz.apz02 = 'Y' THEN  #mark by dengsy170104  remark by wanghao 201102
                 #IF g_apz.apz02 = 'Y' AND g_aph[l_ac].aph03<>'F' THEN  #add by dengsy170104  mark by wanghao 201102
                    CALL s_aapact('2',g_bookno1,g_aph[l_ac].aph04) RETURNING g_msg  #No:8727
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aph[l_ac].aph04,g_errno,0)
                       NEXT FIELD aph04
                    END IF
                 END IF
                      #str------ add by dengsy161223   #mark by wanghao 201102 -str
                      #IF g_prog='aapt150' AND g_aph[l_ac].aph03='F' THEN
                      #   SELECT nmd08,nmd10,nmd30,nmd04,nmd55
                      #     INTO l_nmd08,l_nmd10,l_nmd30,l_nmd04,l_nmd55
                      #   FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
                      #   IF SQLCA.sqlcode = 100 THEN
                      #      CALL cl_err('','axr-944',0)
                      #      NEXT FIELD aph04
                      #   END IF
                      #   IF l_nmd08<>g_apa.apa05 THEN
                      #      CALL cl_err('','aap-040',0)
                      #      NEXT FIELD aph04
                      #   END IF
                      #   IF l_nmd30<>'Y' THEN
                      #      CALL cl_err('','axr-194',0)
                      #      NEXT FIELD aph04
                      #   END IF
                      #   IF cl_null(l_nmd04) THEN LET l_nmd04=0 END IF
                      #   IF cl_null(l_nmd55) THEN LET l_nmd55=0 END IF
                      #   IF l_nmd04-l_nmd55<=0 THEN
                      #      CALL cl_err('','aap-268',0)
                      #      NEXT FIELD aph04
                      #   END IF
                      #   SELECT nmd03,nmd21,nmd19,nmd04-nmd55,nmd05
                      #   INTO g_aph[l_ac].aph08,g_aph[l_ac].aph13,
                      #        g_aph[l_ac].aph14,g_aph[l_ac].aph05f,
                      #        g_aph[l_ac].aph07
                      #   FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
                      #   LET g_aph[l_ac].aph05=g_aph[l_ac].aph05f*g_aph[l_ac].aph14
                      #   LET g_aph_t.aph04=g_aph[l_ac].aph04
                      #   DISPLAY BY NAME g_aph[l_ac].aph13,g_aph[l_ac].aph14,
                      #                   g_aph[l_ac].aph05f,g_aph[l_ac].aph05,
                      #                   g_aph[l_ac].aph07
                      #END IF
                      ##end----- add by dengsy161223  #mark by wanghao 201102 -end
                END IF
                IF g_aph[l_ac].aph03 MATCHES "[6789]" THEN
                   IF g_apz.apz27 = 'N' THEN   
                         SELECT apa00,apc08-apc10,apc09-apc11,apa41,apa42,                                                              
                                apa13,apc06,apa74,
                                apa08   #MOD-820129                                                                                         
                           INTO l_aptype,g_qty1,g_qty2,l_apa41,l_apa42,                                                                   
                                l_apa13,l_apa14,l_apa74,
                                l_apa08   #MOD-820129                                                                                   
                           FROM apa_file,apc_file                                                                                             
                          WHERE apa01 = g_aph[l_ac].aph04       
                            AND apa01 =apc01
                            AND apc02 =1                              #No.TQC-6B0066 
                   ELSE                                                                                                                
                         SELECT apa00,apc08-apc10,apc13,apa41,apa42,                                                              
                                apa13,apc07,apa74,
                                apa08   #MOD-820129                                                                                         
                           INTO l_aptype,g_qty1,g_qty2,l_apa41,l_apa42,                                                                   
                                l_apa13,l_apa14,l_apa74,
                                l_apa08   #MOD-820129                                                                                   
                           FROM apa_file,apc_file     #No.MOD-7B0009 add apc_file                                                                                             
                          WHERE apa01 = g_aph[l_ac].aph04        
                            AND apa01 =apc01
                            AND apc02 =1                         #No.TQC-6B0066 
                   END IF                                                                                                              
                   CASE WHEN g_aph[l_ac].aph03 = '6' LET l_type = '21'
                        WHEN g_aph[l_ac].aph03 = '7' LET l_type = '22'
                        WHEN g_aph[l_ac].aph03 = '8' 
                           IF l_aptype = '13' OR l_aptype='17' THEN  
                             LET l_type = '25'
                           ELSE 
                             LET l_type = '23'
                           END IF
                        WHEN g_aph[l_ac].aph03 = '9' LET l_type = '24'
                   END CASE
                   CASE WHEN l_aptype[1,1]!='2'  LET g_errno = 'aap-079'
                        WHEN SQLCA.sqlcode = 100 LET g_errno = 'aap-075'
                        WHEN l_apa41       = 'N' LET g_errno = 'aap-141'
                        WHEN l_apa42       = 'Y' LET g_errno = 'aap-165'
                        WHEN l_apa74       = 'Y' LET g_errno = 'aap-334'
                        WHEN l_apa08       = 'UNAP' LET g_errno = 'aap-915'   #MOD-820129
                        WHEN g_qty1       <= 0   LET g_errno = 'aap-076'
                        WHEN g_qty1       >  0   LET g_errno = ' '
                        OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
                   END CASE
                   #No.TQC-BC0052  --Begin
                   SELECT count(*) INTO l_n1 FROM apa_file,apc_file
                    WHERE apa00=l_type
                      AND apa01=apc01
                      AND apa01=g_aph[l_ac].aph04
                      AND apa06=g_apa.apa06
                   IF l_n1=0  THEN
                      LET g_errno = 'axr-186'
                   END IF
                   #No.TQC-BC0052  --End
                   IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aph[l_ac].aph04,g_errno,1)
                       NEXT FIELD aph04
                   END IF
                   LET g_aph[l_ac].aph13 = l_apa13
                   LET g_aph[l_ac].aph14 = l_apa14
                   LET g_aph[l_ac].aph05f= g_qty1
                   LET g_aph[l_ac].aph05 = g_qty2
                END IF
                SELECT SUM(aph05f),SUM(aph05)
                  INTO l_aph05f_sum,l_aph05_sum FROM aph_file
                 WHERE aph01 =g_apa.apa01
                IF cl_null(l_aph05f_sum) THEN
                   LET l_aph05f_sum =0
                END IF
                IF cl_null(l_aph05_sum) THEN
                   LET l_aph05_sum =0
                END IF
                IF g_aph_t.aph04 IS NULL THEN
                   IF g_aph[l_ac].aph05f > g_apg.apg05f - l_aph05f_sum THEN
                      LET g_aph[l_ac].aph05f = g_apg.apg05f - l_aph05f_sum
                   END IF
                   IF g_aph[l_ac].aph05 > g_apg.apg05 - l_aph05_sum THEN
                      LET g_aph[l_ac].aph05 = g_apg.apg05 - l_aph05_sum
                   END IF
                ELSE
                   IF g_aph[l_ac].aph05f >
                      g_apg.apg05f - l_aph05f_sum + g_aph_t.aph05f THEN
                      LET g_aph[l_ac].aph05f =
                      g_apg.apg05f - l_aph05f_sum + g_aph_t.aph05f
                   END IF
                   IF g_aph[l_ac].aph05 >
                      g_apg.apg05 - l_aph05_sum + g_aph_t.aph05 THEN
                      LET g_aph[l_ac].aph05 =
                      g_apg.apg05 - l_aph05_sum + g_aph_t.aph05
                   END IF
                END IF
            END IF
            #str------ add by dengsy161223  #mark by wanghao 201102 -str
             #         IF g_prog='aapt150' AND g_aph[l_ac].aph03='F' THEN
             #            SELECT nmd08,nmd10,nmd30,nmd04,nmd55
             #              INTO l_nmd08,l_nmd10,l_nmd30,l_nmd04,l_nmd55
             #            FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
             #            IF SQLCA.sqlcode = 100 THEN
             #               CALL cl_err('','axr-944',0)
             #               NEXT FIELD aph04
             #            END IF
             #            IF l_nmd08<>g_apa.apa05 THEN
             #               CALL cl_err('','aap-040',0)
             #               NEXT FIELD aph04
             #           END IF
             #            IF l_nmd30<>'Y' THEN
             #               CALL cl_err('','axr-194',0)
             #               NEXT FIELD aph04
             #            END IF
             #            IF cl_null(l_nmd04) THEN LET l_nmd04=0 END IF
             #            IF cl_null(l_nmd55) THEN LET l_nmd55=0 END IF
             #            IF l_nmd04-l_nmd55<=0 THEN
             #               CALL cl_err('','aap-268',0)
             #               NEXT FIELD aph04
             #            END IF
             #            SELECT nmd03,nmd21,nmd19,nmd04-nmd55,nmd05
             #            INTO g_aph[l_ac].aph08,g_aph[l_ac].aph13,
             #                 g_aph[l_ac].aph14,g_aph[l_ac].aph05f,
             #                 g_aph[l_ac].aph07
             #            FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
             #            LET g_aph[l_ac].aph05=g_aph[l_ac].aph05f*g_aph[l_ac].aph14
             #            LET g_aph_t.aph04=g_aph[l_ac].aph04
             #            DISPLAY BY NAME g_aph[l_ac].aph13,g_aph[l_ac].aph14,
             #                            g_aph[l_ac].aph05f,g_aph[l_ac].aph05,
             #                            g_aph[l_ac].aph07
             #         END IF
             #         #end----- add by dengsy161223  #mark by wanghao 201102 -end
             #150615wudj--str--
                      IF g_aph[l_ac].aph03='F' THEN
                         SELECT nmd08,nmd10,nmd30,nmd04,nmd55
                           INTO l_nmd08,l_nmd10,l_nmd30,l_nmd04,l_nmd55
                         FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
                         IF SQLCA.sqlcode = 100 THEN
                            CALL cl_err('','axr-944',0)
                            NEXT FIELD aph04
                         END IF
                         IF l_nmd08<>g_apa.apa06 THEN
                            CALL cl_err('','aap-040',0)
                            NEXT FIELD aph04
                         END IF
                         IF l_nmd30<>'Y' THEN
                            CALL cl_err('','axr-194',0)
                            NEXT FIELD aph04
                         END IF
                         IF cl_null(l_nmd04) THEN LET l_nmd04=0 END IF
                         IF cl_null(l_nmd55) THEN LET l_nmd55=0 END IF
                         IF l_nmd04-l_nmd55<=0 THEN
                            CALL cl_err('','aap-268',0)
                            NEXT FIELD aph04
                         END IF
                         SELECT nmd03,nmd21,nmd19,nmd04-nmd55,nmd05
                         INTO g_aph[l_ac].aph08,g_aph[l_ac].aph13,
                              g_aph[l_ac].aph14,g_aph[l_ac].aph05f,
                              g_aph[l_ac].aph07
                         FROM nmd_file WHERE nmd01=g_aph[l_ac].aph04
                         LET g_aph[l_ac].aph05=g_aph[l_ac].aph05f*g_aph[l_ac].aph14
                         LET g_aph_t.aph04=g_aph[l_ac].aph04
                         DISPLAY BY NAME g_aph[l_ac].aph13,g_aph[l_ac].aph14,
                                         g_aph[l_ac].aph05f,g_aph[l_ac].aph05,
                                         g_aph[l_ac].aph07
                      END IF
#--begin-- FUN-B40011
   IF g_aph[l_ac].aph03 = 'D' THEN
      LET l_sql="SELECT nmh_file.*,nmydmy3 FROM nmh_file,nmy_file ",
                " WHERE nmh01= '",g_aph[l_ac].aph04,"'",
                "   AND SUBSTR(nmh01,1,",g_doc_len,")=nmyslip"
      PREPARE nmh_p2 FROM l_sql
      DECLARE nmh_c2 CURSOR FOR nmh_p2
      OPEN nmh_c2
      FETCH nmh_c2 INTO l_nmh.*,l_nmydmy3
      IF STATUS THEN CALL cl_err('sel nmh',STATUS,1) LET g_errno=STATUS RETURN '','','','','' END IF
      IF l_nmh.nmh24 !='5' THEN
         LET g_errno = 'axr-115'
         CLOSE nmh_c2
      END IF

      IF l_nmh.nmh38 = 'N' THEN
         LET g_errno='axr-194' 
      END IF
      IF l_nmh.nmh38 = 'X' THEN
         LET g_errno = '9024' 
      END IF
      
      #darcy:2024/09/03 mod s---
      #---> TQC-C30293 add
      # 用anmt250冲账记录判断供应商编号
      # IF l_nmh.nmh22!=g_apa.apa06 THEN
      #    LET g_errno='aap-040'
      # END IF
      select count(*) into g_cnt from npn_file,npo_file
       where npo01 = npn01 and npnconf = 'Y' and npn03 = '5'
         and npn14 = g_apa.apa06 and npo03 = g_aph[l_ac].aph04
      if g_cnt = 0 then
         LET g_errno='aap-040'
      end if
      #darcy:2024/09/03 mod e---
      #---> TQC-C30293 add--end
      #TQC-C50108--add--str
      IF l_nmh.nmh05 < g_apa.apa02 THEN
         LET g_errno = 'aap-209'
      END IF
      #TQC-C50108--add--end

      LET tot1 = 0
      
      #darcy:2024/09/03 mod s---
      # SELECT SUM(aph05f) INTO tot1
      #   FROM aph_file
      #  WHERE aph03 = 'D'
      #    AND aph04 = g_aph[l_ac].aph04
      
      SELECT SUM(aph05f) INTO tot1
        FROM aph_file,apf_file
       WHERE aph03 = 'D'
         AND aph04 = g_aph[l_ac].aph04 
         AND aph01 = apf01 AND apf41 != 'X'
         and apf03 = g_apa.apa06

      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      # SELECT nmh02 INTO l_nmh02    #No.TQC-C30121   Add
      #   FROM nmh_file
      #  WHERE nmh01 = g_aph[l_ac].aph04
      #    AND nmh24='5'
      #    AND nmh38='Y'
      select sum(npo04) into l_nmh02 from npo_file,npn_file
       where npn03 = '5' and npn14 = g_apa.apa06 and npnconf = 'Y'
         and npo03 = g_aph[l_ac].aph04 and npo01 = npn01
      #darcy:2024/09/03 mod e---
      IF cl_null(l_nmh02) THEN LET l_nmh02 = 0 END IF    #No.TQC-C30121   Add

                       
      LET l_aph13=l_nmh.nmh03
      LET l_aph14=l_nmh.nmh32/l_nmh.nmh02
      LET l_aph05f=l_nmh02 - tot1   #No.TQC-C30121   Add
      LET l_aph05=l_aph05f*l_aph14
      LET l_aph07 = l_nmh.nmh05 #TQC-C40096 nmh04收票日期---->nmh05到期日期
              IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_aph[l_ac].aph04,g_errno,0)
                   NEXT FIELD aph04
              END IF
                   LET g_aph[l_ac].aph07 = l_aph07
                   LET g_aph[l_ac].aph13 = l_aph13
                   LET g_aph[l_ac].aph14 = l_aph14
                   LET g_aph[l_ac].aph05f= l_aph05f
                   LET g_aph[l_ac].aph05 = l_aph05
                   LET l_aph04_o = g_aph[l_ac].aph04      
   END IF
                      #150615wudj--end
 
        BEFORE FIELD aph17
            IF cl_null(g_aph[l_ac].aph17) AND g_aph[l_ac].aph03<>'D' THEN   #add AND g_aph[l_ac].aph03<>'D' by lifang 201104
               LET g_aph[l_ac].aph17 = 1
               DISPLAY BY NAME g_aph[l_ac].aph17
            END IF
 
        AFTER FIELD aph17
            IF g_aph[l_ac].aph03='D' THEN   #add by lifang 201104
            ELSE    #add by lifang 201104
            IF g_aph[l_ac].aph17 IS NULL THEN NEXT FIELD aph17 END IF   
            IF g_aph_t.aph17 IS NULL OR g_aph[l_ac].aph17!=g_aph_t.aph17 OR  
               g_aph_t.aph04 IS NULL OR g_aph[l_ac].aph04!=g_aph_t.aph04 THEN
                SELECT COUNT(*) INTO l_n FROM apc_file 
                 WHERE apc01 =g_aph[l_ac].aph04   #FUN-820052
                   AND apc02 =g_aph[l_ac].aph17
                IF l_n =0 THEN
                  CALL cl_err('','aap-777',1)
                  NEXT FIELD aph17
                END IF
                SELECT COUNT(*) INTO l_n FROM apc_file 
                 WHERE apc01 =g_aph[l_ac].aph04   #FUN-820052
                   AND apc02 =g_aph[l_ac].aph17
                   AND apc08 >(apc10+apc14)
                IF l_n =0 THEN
                  CALL cl_err('','aap-778',1)
                  NEXT FIELD aph17
                END IF
                IF cl_null(g_aph[l_ac].aph05) OR g_aph[l_ac].aph05 = 0 THEN
                   SELECT (apc09-apc11-apc15-apc16*apc06) INTO l_aph05
                     FROM apc_file
                    WHERE apc01 =g_apa.apa01
                      AND apc02= g_aph[l_ac].aph17
                   SELECT SUM(aph05) INTO l_aph05_sum FROM aph_file
                    WHERE aph01 =g_apa.apa01
                   IF cl_null(l_aph05_sum) THEN
                      LET l_aph05_sum =0
                   END IF
                   IF g_aph_t.aph17 IS NULL THEN    #MOD-810260
                      IF g_apg.apg05 -l_aph05_sum >l_aph05 THEN
                         LET g_aph[l_ac].aph05 =l_aph05
                      ELSE
                         LET g_aph[l_ac].aph05 =g_apg.apg05 -l_aph05_sum
                      END IF
                   ELSE
                      IF g_apg.apg05-l_aph05_sum+g_aph[l_ac].aph05>l_aph05 THEN
                         LET g_aph[l_ac].aph05 =l_aph05
                      ELSE
                         LET g_aph[l_ac].aph05 =g_apg.apg05-l_aph05_sum+
                                                g_aph[l_ac].aph05
                      END IF
                   END IF
                END IF
                IF cl_null(g_aph[l_ac].aph05f) OR g_aph[l_ac].aph05f = 0 THEN
                   SELECT (apc08-apc10-apc14-apc16) INTO l_aph05f
                     FROM apc_file
                    WHERE apc01 =g_apa.apa01
                      AND apc02= g_aph[l_ac].aph17
                   SELECT SUM(aph05f) INTO l_aph05f_sum FROM aph_file
                    WHERE aph01 =g_apa.apa01
                   IF cl_null(l_aph05f_sum) THEN
                      LET l_aph05f_sum =0
                   END IF
                   IF g_aph_t.aph17 IS NULL THEN    #MOD-810260
                      IF g_apg.apg05f -l_aph05f_sum >l_aph05f THEN
                         LET g_aph[l_ac].aph05f =l_aph05f
                      ELSE
                         LET g_aph[l_ac].aph05f =g_apg.apg05f -l_aph05f_sum
                      END IF
                   ELSE
                      IF g_apg.apg05f-l_aph05f_sum+g_aph[l_ac].aph05f>
                         l_aph05f THEN
                         LET g_aph[l_ac].aph05f =l_aph05f
                      ELSE
                         LET g_aph[l_ac].aph05f =g_apg.apg05f-l_aph05f_sum+
                                                g_aph[l_ac].aph05f
                      END IF
                   END IF
                END IF
            END IF
            END IF    #add by lifang 201104
 
 
        BEFORE FIELD aph08
            LET g_aph_o.aph02 = g_aph[l_ac].aph02
 
        AFTER FIELD aph08
            IF g_aph[l_ac].aph03 = '2' THEN
               IF cl_null(g_aph[l_ac].aph08) THEN NEXT FIELD aph08 END IF
            END IF
            IF g_aph[l_ac].aph08 IS NOT NULL THEN
               SELECT nma10 INTO g_aph[l_ac].aph13 FROM nma_file
                WHERE nma01 = g_aph[l_ac].aph08
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","nma_file",g_aph[l_ac].aph08,"",STATUS,"","sel nma:",1)  #No.FUN-660122
                  NEXT FIELD aph08
               END IF
            END IF
            IF g_aph[l_ac].aph03 MATCHES '[2]' AND 
               NOT cl_null(g_aph[l_ac].aph07) THEN 
               LET l_nma21 = NULL
               SELECT nma21 INTO l_nma21 FROM nma_file 
                WHERE nma01 = g_aph[l_ac].aph08
               IF l_nma21 IS NOT NULL AND l_nma21>g_aph[l_ac].aph07 THEN
                  CALL cl_err(g_aph[l_ac].aph07,'anm-225',0)
                  NEXT FIELD aph03
               END IF
            END IF   
            #No.TQC-A30083  --Begin                                             
            #-----MOD-630122---------                                           
            IF g_aph[l_ac].aph03 MATCHES '[12]' THEN                            
               IF NOT cl_null(g_aph[l_ac].aph08) THEN                           
                  SELECT nma28 INTO l_nma28 FROM nma_file                       
                   WHERE nma01=g_aph[l_ac].aph08    
                  IF g_aza.aza26 <> '2' THEN                         #No.CHI-B60090 add                            
                     IF l_nma28 <> g_aph[l_ac].aph03 THEN                          
                        CALL cl_err('','aap-804',0)                                
                        NEXT FIELD aph08                                           
                     END IF                                                        
                  END IF                                             #No.CHI-B60090 add
               END IF                                                           
            END IF                                                              
            #-----END MOD-630122-----                                           
            #No.TQC-A30083  --End 
            IF g_aph[l_ac].aph03 = '2' AND
               g_aph[l_ac].aph13 != g_aza.aza17 THEN
               CALL s_bankex(g_aph[l_ac].aph08,g_aph[l_ac].aph07)
                    RETURNING g_aph[l_ac].aph14
               SELECT azi07 INTO t_azi07 FROM azi_file
                WHERE azi01= g_aph[l_ac].aph13
               LET g_aph[l_ac].aph14 = cl_digcut(g_aph[l_ac].aph14,t_azi07)
               LET g_aph[l_ac].aph05 = g_aph[l_ac].aph05f * g_aph[l_ac].aph14
               LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)
               DISPLAY BY NAME g_aph[l_ac].aph14
               DISPLAY BY NAME g_aph[l_ac].aph05
            END IF
 
            IF g_aph[l_ac].aph03 = '2' AND (p_cmd ='a'                       #No.TQC-7A0095
               OR (p_cmd = 'u' AND g_aph[l_ac].aph08 <> g_aph_t.aph08)) THEN #No.TQC-7A0095 
               SELECT nma05 INTO g_aph[l_ac].aph04 FROM nma_file
                  WHERE nma01 = g_aph[l_ac].aph08
               DISPLAY BY NAME g_aph[l_ac].aph04
               IF g_aza.aza63 ='Y' THEN
                  LET g_aph041 =null
                  SELECT nma051 INTO g_aph041 FROM nma_file
                     WHERE nma01 = g_aph[l_ac].aph08
               END IF
            END IF
        #FUN-970077---Begin                                                                                                         
        AFTER FIELD aph18
           IF NOT cl_null(g_aph[l_ac].aph18) THEN
              SELECT COUNT(*) INTO l_n FROM nnc_file
               WHERE nnc02 = g_aph[l_ac].aph18
              IF l_n = 0 THEN
                 CALL cl_err("","asfi115",0)
                 NEXT FIELD aph18
              END IF
           END IF
       #FUN-970077--End
 
        BEFORE FIELD aph16
           IF g_aph[l_ac].aph03 = '2' THEN
               IF cl_null(g_aph[l_ac].aph16) THEN
                  LET g_aph[l_ac].aph16 = g_apz.apz58
               END IF
               SELECT nmc02 INTO g_aph[l_ac].nmc02 FROM nmc_file
                  WHERE nmc01 = g_aph[l_ac].aph16
               DISPLAY BY NAME g_aph[l_ac].nmc02
           END IF
 
        AFTER FIELD aph16
           IF cl_null(g_aph[l_ac].aph16) AND g_aph[l_ac].aph03 = '2' THEN
              NEXT FIELD aph16
           END IF
           IF NOT cl_null(g_aph[l_ac].aph16) THEN
              SELECT COUNT(*) INTO l_cnt FROM nmc_file
                 WHERE nmc01 = g_aph[l_ac].aph16 AND nmc03 = '2'
              IF l_cnt = 0 THEN
                 CALL cl_err('','anm-024',1)
                 LET g_aph[l_ac].aph16 = g_aph_o.aph16
                 NEXT FIELD aph16
              ELSE
                 SELECT nmc02 INTO g_aph[l_ac].nmc02 FROM nmc_file
                    WHERE nmc01 = g_aph[l_ac].aph16  AND nmc03 = '2' #僅能為提出
                    DISPLAY BY NAME g_aph[l_ac].nmc02
                 LET g_aph_o.aph16 = g_aph[l_ac].aph16
              END IF
           END IF
 
        BEFORE FIELD aph13
            IF g_aph[l_ac].aph13 IS NULL THEN
               LET g_aph[l_ac].aph13 = g_apa.apa13
            END IF
        AFTER FIELD aph13,aph14
            IF g_aph[l_ac].aph13 IS NULL THEN NEXT FIELD aph13 END IF
            IF g_aph[l_ac].aph03 NOT MATCHES "[6789]" AND
               g_aph[l_ac].aph13 != g_aza.aza17 AND
               g_aph[l_ac].aph14 = 1 THEN
               CALL s_curr3(g_aph[l_ac].aph13,g_apa.apa02,g_apz.apz33) #FUN-640022
                    RETURNING g_aph[l_ac].aph14
               SELECT azi07 INTO t_azi07 FROM azi_file
                WHERE azi01= g_aph[l_ac].aph13
               LET g_aph[l_ac].aph14 = cl_digcut(g_aph[l_ac].aph14,t_azi07)
               DISPLAY BY NAME g_aph[l_ac].aph14
            END IF
            IF g_aph[l_ac].aph14 IS NOT NULL THEN
               IF g_aph[l_ac].aph13 =g_aza.aza17 THEN
                  LET g_aph[l_ac].aph14 =1
                  DISPLAY BY NAME g_aph[l_ac].aph14
               ELSE
                  SELECT azi07 INTO t_azi07 FROM azi_file
                   WHERE azi01= g_aph[l_ac].aph13
                  LET g_aph[l_ac].aph14 = cl_digcut(g_aph[l_ac].aph14,t_azi07)
                  DISPLAY BY NAME g_aph[l_ac].aph14
               END IF
            END IF
            IF g_aph[l_ac].aph03 MATCHES "[45]" THEN LET g_aph[l_ac].aph14 = 1 END IF     #MOD-9C0187 add 
 
        BEFORE FIELD aph05f
           IF g_aph[l_ac].aph03 MATCHES "[45]" THEN
              IF p_cmd='a' THEN
                 LET g_aph[l_ac].aph05f = 0
              END IF
           END IF
           SELECT azi04 INTO t_azi04 FROM azi_file    #MOD-660098
            WHERE azi01=g_aph[l_ac].aph13             #MOD-660098
           LET g_aph[l_ac].aph05f = cl_digcut(g_aph[l_ac].aph05f,t_azi04)
          IF cl_null(g_aph[l_ac].aph05f) OR g_aph[l_ac].aph05f= 0 THEN
              IF g_aph[l_ac].aph03 NOT MATCHES "[45]" THEN   #MOD-8A0119 add
                 SELECT SUM(aph05f)
                   INTO l_aph05f_sum FROM aph_file
                  WHERE aph01 =g_apa.apa01
                 IF cl_null(l_aph05f_sum) THEN
                    LET l_aph05f_sum =0
                 END IF
                 IF g_aph_t.aph03 IS NULL THEN
                    LET g_aph[l_ac].aph05f = g_apg.apg05f-l_aph05f_sum
                 ELSE
                    LET g_aph[l_ac].aph05f = g_apg.apg05f-l_aph05f_sum+g_aph[l_ac].aph05f
                 END IF
              END IF   #MOD-8A0119 add
             #MOD-9C0187---modify---start---
              IF g_aph[l_ac].aph03 MATCHES "[45]" THEN
                 LET g_aph[l_ac].aph05 = g_apa.apa31+g_apa.apa32-aph05_t
                 LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)          
              END IF
              IF g_aph[l_ac].aph03 NOT MATCHES "[45]" THEN
                 LET g_aph[l_ac].aph05 = g_aph[l_ac].aph05f * g_aph[l_ac].aph14
                 LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)         
              END IF
             #MOD-9C0187---modify---end---
              LET g_aph[l_ac].aph05f = cl_digcut(g_aph[l_ac].aph05f,t_azi04)
              LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)
           END IF    #No.TQC-7C0140
 
        AFTER FIELD aph05f
           SELECT azi04 INTO t_azi04 FROM azi_file    #MOD-660098
                  WHERE azi01=g_aph[l_ac].aph13   #MOD-660098
            LET g_aph[l_ac].aph05f = cl_digcut(g_aph[l_ac].aph05f,t_azi04)             #No.MOD-530307
           IF g_aph[l_ac].aph03 MATCHES "[45]" THEN
              LET g_aph[l_ac].aph05 = g_apa.apa31+g_apa.apa32-aph05_t
              LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)             #No.MOD-530307  #No.MOD-7B0009 mark   #MOD-820064 取消mark
           END IF
           IF g_aph[l_ac].aph03 NOT MATCHES "[45]" THEN
              LET g_aph[l_ac].aph05 = g_aph[l_ac].aph05f * g_aph[l_ac].aph14
              LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)             #No.MOD-520131  #No.MOD-7B0009 mark   #MOD-820064 取消mark
           END IF
           IF g_aph[l_ac].aph03 MATCHES "[6789]" THEN
              SELECT apc08-apc10                                                              
                INTO g_qty1                                                                   
                FROM apa_file,apc_file                                                                                             
               WHERE apa01 = g_aph[l_ac].aph04       
                 AND apa01 =apc01
                 AND apc02 =1                            
              IF g_aph[l_ac].aph05f > g_qty1 + g_aph_t.aph05f THEN    #MOD-830059
                 CALL cl_err(g_qty1,'aap-194',0)
                 LET g_aph[l_ac].aph05f = g_aph_t.aph05f   #MOD-830059
                 DISPLAY BY NAME g_aph[l_ac].aph05f   #MOD-830059
                 NEXT FIELD aph05f
              END IF
           END IF
             #--add by lifang 201104 begin#
           IF g_aph[l_ac].aph03 = 'D' THEN
                  LET l_sum_aph05f= 0
                  LET l_sum_aph05 = 0
                  SELECT SUM(aph05f),SUM(aph05) INTO l_sum_aph05f,l_sum_aph05
                    FROM aph_file,apf_file
                   WHERE aph03 = 'D'
                     AND aph04 = g_aph[l_ac].aph04
                     AND aph01 = apf01 AND apf41 != 'X'   #MOD-9C0147 add
                     and apf03 = g_apa.apa06 #darcy:2024/09/03 add
                  IF cl_null(l_sum_aph05f) THEN LET l_sum_aph05f= 0 END IF
                  IF cl_null(l_sum_aph05)  THEN LET l_sum_aph05 = 0 END IF
                  IF cl_null(g_aph_t.aph05f) THEN LET g_aph_t.aph05f = 0 END IF

                  LET l_sum_aph05f = l_sum_aph05f - g_aph_t.aph05f

                  #darcy:2024/09/03 add s---
                  # SELECT nmh02 INTO l_nmh02    #NO.TQC-C30121   Add
                  #   FROM nmh_file
                  #  WHERE nmh01 = g_aph[l_ac].aph04
                  #    AND nmh24='5'
                  #    AND nmh38='Y'
                  select sum(npo04) into l_nmh02 from npo_file,npn_file
                   where npn03 = '5' and npn14 = g_apa.apa06 and npnconf = 'Y'
                     and npo03 = g_aph[l_ac].aph04 and npo01 = npn01
                  #darcy:2024/09/03 add e---
                  IF cl_null(l_nmh02) THEN LET l_nmh02 = 0 END IF   #No.TQC-C30121   Add

                  IF l_sum_aph05f+g_aph[l_ac].aph05f > l_nmh02 THEN #No.TQC-C30121   Add
                     CALL cl_err(g_aph[l_ac].aph05f,'aap-670',1)
                     NEXT FIELD aph05f
                  END IF
               END IF

           #--add by lifang 201104 end#

           DISPLAY BY NAME g_aph[l_ac].aph05f          #MOD-940321                      
           DISPLAY BY NAME g_aph[l_ac].aph05           #MOD-940321                      
 
        AFTER FIELD aph05
            LET g_aph[l_ac].aph05 = cl_digcut(g_aph[l_ac].aph05,g_azi04)             #No.MOD-530307  #No.MOD-7B0009   #MOD-820064 取消mark
           IF g_aph[l_ac].aph03 MATCHES "[6789]" THEN
              IF g_apz.apz27 = 'N' THEN   
                    SELECT apc09-apc11                                                              
                      INTO g_qty2                                                                   
                      FROM apa_file,apc_file                                                                                             
                     WHERE apa01 = g_aph[l_ac].aph04       
                       AND apa01 =apc01
                       AND apc02 =1                            
              ELSE                                                                                                                
                    SELECT apc13                                                              
                      INTO g_qty2                                                                   
                      FROM apa_file,apc_file                                                                                                 
                     WHERE apa01 = g_aph[l_ac].aph04        
                       AND apa01 =apc01
                       AND apc02 =1                          
              END IF                                                                                                              
              IF g_aph[l_ac].aph05 > g_qty2 + g_aph_t.aph05 THEN    #MOD-830059
                 CALL cl_err(g_qty2,'aap-194',0)
                 LET g_aph[l_ac].aph05 = g_aph_t.aph05   #MOD-830059
                 DISPLAY BY NAME g_aph[l_ac].aph05   #MOD-830059
                 NEXT FIELD aph05
              END IF
           END IF
            #--add by lifang 201104 begin#
           IF g_aph[l_ac].aph03 = 'D' THEN
                  LET l_sum_aph05f= 0
                  LET l_sum_aph05 = 0
                  SELECT SUM(aph05f),SUM(aph05) INTO l_sum_aph05f,l_sum_aph05
                    FROM aph_file,apf_file
                   WHERE aph03 = 'D'
                     AND aph04 = g_aph[l_ac].aph04
                     AND aph01 = apf01 AND apf41 != 'X'   #MOD-9C0147 add
                  IF cl_null(l_sum_aph05f) THEN LET l_sum_aph05f= 0 END IF
                  IF cl_null(l_sum_aph05)  THEN LET l_sum_aph05 = 0 END IF
                  IF cl_null(g_aph_t.aph05f) THEN LET g_aph_t.aph05f = 0 END IF

                  LET l_sum_aph05f = l_sum_aph05f - g_aph_t.aph05f

                  SELECT nmh02 INTO l_nmh02    #NO.TQC-C30121   Add
                    FROM nmh_file
                   WHERE nmh01 = g_aph[l_ac].aph04
                     AND nmh24='5'
                     AND nmh38='Y'
                  IF cl_null(l_nmh02) THEN LET l_nmh02 = 0 END IF   #No.TQC-C30121   Add

                  IF l_sum_aph05f+g_aph[l_ac].aph05f > l_nmh02 THEN #No.TQC-C30121   Add
                     CALL cl_err(g_aph[l_ac].aph05f,'aap-670',1)
                     NEXT FIELD aph05f
                  END IF
               END IF

           #--add by lifang 201104 end#


        AFTER FIELD aph07
          IF g_apa.apa02 = g_aph[l_ac].aph07 AND g_apz.apz52 <> '1' THEN
             SELECT nma05 INTO g_aph[l_ac].aph04 FROM nma_file
                WHERE nma01 = g_aph[l_ac].aph08
          END IF
          DISPLAY BY NAME g_aph[l_ac].aph04
 
        BEFORE DELETE                            #是否取消單身
            IF g_aph_t.aph02 > 0 AND
               g_aph_t.aph02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
 
               IF g_aph[l_ac].aph03 MATCHES "[6789]" THEN   #TQC-720051
                  LET g_sql = "UPDATE apa_file ",
                              "   SET apa35f = apa35f - ?, ",
                              "       apa35  = apa35 - ?, ",
                              "       apa73  = apa73 + ?  ",
                              " WHERE apa01= ? "
                  PREPARE apa_ins_c2 FROM g_sql
                  IF STATUS THEN
                     CALL cl_err('apa_ins_c2',status,1)
                     LET g_success='N'
                     CANCEL DELETE
                  END IF
                  EXECUTE apa_ins_c2 USING g_aph[l_ac].aph05f,g_aph[l_ac].aph05,
                                          g_aph[l_ac].aph05,g_aph[l_ac].aph04
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err(g_aph[l_ac].aph04,SQLCA.sqlcode,0)
                     LET g_success='N'
                     CANCEL DELETE
                  END IF
               END IF   #TQC-720051
 
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM aph_file
                 WHERE aph01 = g_apa.apa01
                   AND aph02 = g_aph_t.aph02
                IF l_cnt > 0 THEN
                   DELETE FROM aph_file
                    WHERE aph01 = g_apa.apa01
                      AND aph02 = g_aph_t.aph02
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
                       CALL cl_err3("del","aph_file",g_apa.apa01,g_aph_t.aph02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                       CANCEL DELETE    
                   ELSE
                      LET g_rec_b=g_rec_b-1
                     #更新代扺帳款帳期內容
                      IF g_aph_t.aph03 MATCHES"[6,7,8,9]" THEN
                         UPDATE apc_file SET apc10 =apc10-g_aph[l_ac].aph05f,
                                             apc11 =apc11-g_aph[l_ac].aph05,
                                             apc13 =apc13+g_aph[l_ac].aph05    #No.MOD-7B0009 
                          WHERE apc01 =g_aph_t.aph04   #No.MOD-7B0009
                            AND apc02 =g_aph_t.aph17
                         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
                            CALL cl_err3("upd","apc_file",g_aph_t.aph04,g_aph[l_ac].aph17,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                            CANCEL DELETE
                            LET g_success='N'           
                         END IF
                      END IF
                   END IF
                END IF   #MOD-870048 add
            END IF
            LET l_flag ='Y'          #No.TQC-790131
            CALL t110_apa55_check()
            CALL t110_aph_tot()
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET g_aph[l_ac].* = g_aph_t.*
               CLOSE t110_aph_bcl
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aph[l_ac].aph02,-263,1)
               LET g_aph[l_ac].* = g_aph_t.*
            ELSE
               IF g_aph[l_ac].aph03 MATCHES "[6789]" THEN   #TQC-720051
                  LET g_sql = "UPDATE apa_file ",
                              "   SET apa35f = apa35f - ?, ",
                              "       apa35  = apa35 - ?, ",
                              "       apa73  = apa73 + ?  ",
                              " WHERE apa01= ? "
                  PREPARE apa_ins_c3 FROM g_sql
                  IF STATUS THEN
                     CALL cl_err('apa_ins_c3',status,1)
                     LET g_success='N'
                  END IF
                  EXECUTE apa_ins_c3 USING g_aph_t.aph05f,
                                           g_aph_t.aph05,
                                           g_aph_t.aph05,
                                           g_aph_t.aph04
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err(g_aph[l_ac].aph04,SQLCA.sqlcode,0)
                     LET g_success='N'
                  END IF
                  LET g_sql = "UPDATE apa_file ",
                              "   SET apa35f = apa35f + ?, ",
                              "       apa35  = apa35 + ?, ",
                              "       apa73  = apa73 - ?  ",
                              " WHERE apa01= ? "
                  PREPARE apa_ins_c5 FROM g_sql
                  IF STATUS THEN
                     CALL cl_err('apa_ins_c5',status,1)
                     LET g_success='N'
                  END IF
                  EXECUTE apa_ins_c5 USING g_aph[l_ac].aph05f,
                                           g_aph[l_ac].aph05,
                                           g_aph[l_ac].aph05,
                                           g_aph[l_ac].aph04
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err(g_aph[l_ac].aph04,SQLCA.sqlcode,0)
                     LET g_success='N'
                  END IF
               END IF   #TQC-720051
               UPDATE aph_file SET aph02=g_aph[l_ac].aph02,
                                   aph03=g_aph[l_ac].aph03,
                                   aph08=g_aph[l_ac].aph08,   #MOD-5B0132
                                   aph18=g_aph[l_ac].aph18,   #FUN-970077 add
                                   aph19=g_aph[l_ac].aph19,   #FUN-970077 add
                                   aph04=g_aph[l_ac].aph04,   #MOD-5B0132
                                   aph17=g_aph[l_ac].aph17,   #No.FUN-680027
                                   aph16=g_aph[l_ac].aph16,   #MOD-590054
                                   aph07=g_aph[l_ac].aph07,
                                   aph09=g_aph[l_ac].aph09,
                                   aph13=g_aph[l_ac].aph13,
                                   aph14=g_aph[l_ac].aph14,
                                   aph05f=g_aph[l_ac].aph05f,
                                   aph05=g_aph[l_ac].aph05
                                  ,aph20=g_aph[l_ac].aph20    #FUN-A20010 add
                WHERE aph01=g_apa.apa01
                  AND aph02=g_aph_t.aph02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
                  CALL cl_err3("upd","aph_file",g_apa.apa01,g_aph_t.aph02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                  LET g_aph[l_ac].* = g_aph_t.*
                  LET g_success='N'            #No:8623
               ELSE
                  MESSAGE 'UPDATE O.K'
                  IF g_aph[l_ac].aph03 MATCHES"[6,7,8,9]" THEN
                     UPDATE apc_file SET apc10 =apc10-g_aph_t.aph05f,
                                         apc11 =apc11-g_aph_t.aph05,
                                         apc13 =apc13+g_aph_t.aph05
                      WHERE apc01 =g_aph_t.aph04
                        AND apc02 =g_aph_t.aph17
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
                        CALL cl_err3("upd","apc_file",g_aph_t.aph04,g_aph_t.aph17,SQLCA.sqlcode,"","",1)
                        LET g_aph[l_ac].* = g_aph_t.*
                        LET g_success='N'
                     END IF
                     UPDATE apc_file SET apc10 =apc10+g_aph[l_ac].aph05f,
                                         apc11 =apc11+g_aph[l_ac].aph05,
                                         apc13 =apc13-g_aph[l_ac].aph05
                      WHERE apc01 =g_aph[l_ac].aph04
                        AND apc02 =g_aph[l_ac].aph17
                     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
                        CALL cl_err3("upd","apc_file",g_aph[l_ac].aph04,g_aph[l_ac].aph17,SQLCA.sqlcode,"","",1)
                        LET g_aph[l_ac].* = g_aph_t.*
                        LET g_success='N'
                     END IF
                  END IF
               END IF
            LET l_flag ='Y'          #No.TQC-790131
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               IF p_cmd = 'u' THEN
                  LET g_aph[l_ac].* = g_aph_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aph.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE t110_aph_bcl
               EXIT INPUT
            END IF
            CLOSE t110_aph_bcl
            CALL t110_aph_tot()
 
        ON ACTION frequently_used_acct
           IF g_aph[l_ac].aph03 NOT MATCHES '[AB]' OR 
              cl_null(g_aph[l_ac].aph03) THEN
              CALL cl_cmdrun('aapi204') 
           END IF
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(aph03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_apw"
                   LET g_qryparam.arg1 = g_bookno1     #No.TQC-A30078
                   LET g_qryparam.default1 = g_aph[l_ac].aph03
                   CALL cl_create_qry() RETURNING g_aph[l_ac].aph03
                    DISPLAY g_aph[l_ac].aph03 TO aph03         #No.MOD-490344
                   NEXT FIELD aph03
                WHEN INFIELD(aph08)
                   CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_nma2"   #MOD-5B0200
                  IF g_aph[l_ac].aph03 = 'C' THEN
                     LET g_qryparam.arg1 = '23'
                  ELSE
                     IF g_aph[l_ac].aph03 = '2' THEN
                      # LET g_qryparam.arg1 = '123'  #No.TQC-A30083            
                        LET g_qryparam.arg1 = '2'    #No.TQC-A30083
                     ELSE
                        #str------ add by dengsy161223  #mark by wanghao 201102 -str
                        #IF  g_aph[l_ac].aph03 = 'F' THEN
                        #   LET g_qryparam.arg1 ='123'
                        #ELSE 
                        ##end------ add by dengsy161223  #mark by wanghao 201102 -end 
                        LET g_qryparam.arg1 = g_aph[l_ac].aph03
                        #END IF #add by dengsy161223  #mark by wanghao 2011
                     END IF
                  END IF
                   LET g_qryparam.default1 = g_aph[l_ac].aph08
                   CALL cl_create_qry() RETURNING g_aph[l_ac].aph08
                    DISPLAY g_aph[l_ac].aph08 TO aph08         #No.MOD-490344
                   NEXT FIELD aph08

                #FUN-970077--Begin
                WHEN INFIELD(aph18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_nnc1"
                   LET g_qryparam.arg1 = g_aph[l_ac].aph08
                   LET g_qryparam.default1 = g_aph[l_ac].aph18
                   CALL cl_create_qry() RETURNING g_aph[l_ac].aph18 
                   DISPLAY BY NAME g_aph[l_ac].aph18
                   NEXT FIELD aph18
                #FUN-970077---End
                WHEN INFIELD(aph16)
                   CALL cl_init_qry_var()
                   #No.MOD-B70124  --Begin
                   #LET g_qryparam.form ="q_nmc"
                   LET g_qryparam.form ="q_nmc1"
                   #No.MOD-B70124  --End  
                   LET g_qryparam.default1 = g_aph[l_ac].aph16
                   CALL cl_create_qry() RETURNING g_aph[l_ac].aph16
                   DISPLAY BY NAME g_aph[l_ac].aph16
                   NEXT FIELD aph16
 
                WHEN INFIELD(aph04)
                    IF g_aph[l_ac].aph03 NOT MATCHES "[6789]" THEN
                    #150615wudj-str
                    CASE 
                    WHEN   g_aph[l_ac].aph03 = 'D' 
                     #darcy:2024/09/03 mod s---
                        # CALL cl_init_qry_var()
                        # LET g_qryparam.form = "q_nmh6"
                        # LET g_qryparam.arg1 = g_apa.apa06  
                        # LET g_qryparam.where = " nmh05 >='",g_apa.apa02,"'" 
                        # CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                        call cq_nmh("i",true,g_apa.apa02,g_apa.apa06)
                              returning g_aph[l_ac].aph04
                        next field aph04
                     #darcy:2024/09/03 mod e---
                    WHEN  g_aph[l_ac].aph03 ='F' 
                              CALL cl_init_qry_var()
                              LET g_qryparam.form = "q_nmd4"
                              LET g_qryparam.arg1 = g_apa.apa06
                              CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                    OTHERWISE 


#150615wudj-end
                      #str------- add by dengsy161223   #mark by wanghao 201102 -str
                      #IF g_aph[l_ac].aph03 ='F' THEN 
                      #        CALL cl_init_qry_var()
                      #        LET g_qryparam.form = "q_nmd4"
                      #        LET g_qryparam.arg1 = g_apa.apa05
                      #        CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                      #        DISPLAY g_aph[l_ac].aph04 TO aph04  
                      #        NEXT FIELD aph04
                      #ELSE 
                      #end------- add by dengsy161223  #mark by wanghao 201102 -end
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_aag"
                        LET g_qryparam.arg1 = g_bookno1   #No.FUN-730064   #No.TQC-740093
                        LET g_qryparam.default1 = g_aph[l_ac].aph04
                        CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                        DISPLAY g_aph[l_ac].aph04 TO aph04  
                      #END IF #add by dengsy161223   #mark by wanghao 201102
                      END CASE   #150615wudj
                    ELSE 
                        CASE WHEN g_aph[l_ac].aph03 = '6' LET l_type = '21'
                              WHEN g_aph[l_ac].aph03 = '7' LET l_type = '22'
                              WHEN g_aph[l_ac].aph03 = '8' 
                                IF g_apa.apa00 = '13' OR g_apa.apa00 = '17' THEN  #aapt121
                                  LET l_type = '25'
                                ELSE #TQC-750177 end
                                  LET l_type = '23'
                                END IF
                              WHEN g_aph[l_ac].aph03 = '9' LET l_type = '24'
                         END CASE

                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_apa8"   #FUN-820052
                       LET g_qryparam.arg1 = l_type
                       LET g_qryparam.arg2 = g_apa.apa06   #FUN-820052
                       LET g_qryparam.default1 = g_aph[l_ac].aph04
                       CALL cl_create_qry() RETURNING g_aph[l_ac].aph04
                       DISPLAY g_aph[l_ac].aph04 TO aph04
                    END IF
              WHEN INFIELD(aph14)
                   CALL s_rate(g_aph[l_ac].aph13,g_aph[l_ac].aph14)
                   RETURNING g_aph[l_ac].aph14
                   DISPLAY BY NAME g_aph[l_ac].aph14
                   NEXT FIELD aph14
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLO
            IF INFIELD(aph02) AND l_ac > 1 THEN
                LET g_aph[l_ac].* = g_aph[l_ac-1].*
                LET g_aph[l_ac].aph02 = NULL   #TQC-620018
                NEXT FIELD aph02
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG=0
       LET g_success = 'N'
       CALL cl_err('',9001,0)
    ELSE
       CALL t110_aph_tot()
       IF aph05_t  != g_apg.apg05  
          THEN
          CALL cl_err(g_apa.apa01,'aap-028',1) 
          CALL t110_aph_b()   #MOD-560240
       END IF
       CLOSE t110_aph_bcl
 
       IF aph05_t > 0 THEN    #No.MOD-7B0009 增加對本幣金額的判斷
          UPDATE apa_file SET apa55='2' WHERE apa01=g_apa.apa01
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #CHI-850023
             CALL cl_err3("upd","apa_file",g_apa.apa01,"",STATUS,"","upd apa55:",1)  #No.FUN-660122
             LET g_success='N'
          END IF
       END IF
    END IF    #TQC-5C0094
 
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t110_aph_tot()
  SELECT SUM(aph05f),SUM(aph05) INTO aph05f_t,aph05_t FROM aph_file
         WHERE aph01=g_apa.apa01
  IF aph05f_t IS NULL THEN LET aph05f_t=0 END IF
  IF aph05_t  IS NULL THEN LET aph05_t =0 END IF
  DISPLAY BY NAME aph05f_t,aph05_t 
END FUNCTION
 
FUNCTION t110_apa55_check()
  SELECT COUNT(*) INTO g_cnt FROM aph_file
   WHERE aph01 = g_apa.apa01
  IF g_cnt = 0 THEN
     LET g_apa.apa55 = '1'
     UPDATE apa_file SET apa55 = g_apa.apa55
      WHERE apa01 = g_apa.apa01
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","apa_file",g_apa.apa01,"",STATUS,"","upd apa:",1)
        LET g_success='N'
     END IF
  END IF  
END FUNCTION
 
FUNCTION t110_set_comb()
  DEFINE l_apw      RECORD LIKE apw_file.*
  DEFINE comb_value STRING
  DEFINE comb_item  LIKE type_file.chr1000   # No.FUN-690028 VARCHAR(1000)
  DEFINE l_apa00    LIKE apa_file.apa00      #TQC-750140
 
  SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01 = g_apa.apa01  #TQC-750140
 
   IF l_apa00 = '13' THEN
     LET comb_value = '1,2,3,4,5,8,A,B,C,Z'
   ELSE
    #LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,Z'   #FUN-660192 #FUN-C50126 mark
    #LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,Z,G'             #FUN-C50126 add G  #FUN-CC0142 mark
     LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,Z,H'             #FUN-C50126 add G  #FUN-CC0142 add  #mark by dnegsy161223  #remark by wanghao 201102
     #LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,F,Z,H'  #add by dengsy161223  #mark by wanghao 201102
   END IF
 
   IF l_apa00 = '13' THEN
     SELECT ze03 INTO comb_item FROM ze_file
      WHERE ze01='aap-337' AND ze02=g_lang
   ELSE
     SELECT ze03 INTO comb_item FROM ze_file
      WHERE ze01='aap-335' AND ze02=g_lang
   END IF
   #150615wudj-str
   IF l_apa00 = '15' THEN
     LET comb_value = '1,2,3,4,5,6,7,8,9,A,B,C,D,F,Z,H'             
      SELECT ze03 INTO comb_item FROM ze_file
      WHERE ze01='cap-335' AND ze02=g_lang     
   END IF
#150615wudj-end 
   DECLARE apw_cs CURSOR FOR
    SELECT * FROM apw_file
   FOREACH apw_cs INTO l_apw.*
       LET comb_value = comb_value CLIPPED,',',l_apw.apw01
       LET comb_item  = comb_item  CLIPPED,',',l_apw.apw01 CLIPPED,':',
                                               l_apw.apw02
   END FOREACH
   CALL cl_set_combo_items('aph03',comb_value,comb_item)
END FUNCTION
 
FUNCTION t110_w_set_entry()
    CALL cl_set_comp_entry("aph07,aph08,aph13,aph14,aph16,aph17",TRUE)  
    CALL cl_set_comp_required("aph08",FALSE)   
END FUNCTION
 
FUNCTION t110_w_set_no_entry()
    IF g_aph[l_ac].aph03 MATCHES '[6789]' THEN
       CALL cl_set_comp_entry("aph07,aph08,aph13,aph14",FALSE)   
    ELSE
       CALL cl_set_comp_entry("aph17",FALSE)   
    END IF
    IF g_aph[l_ac].aph03 MATCHES '[12]' THEN  
       CALL cl_set_comp_entry("aph13",FALSE)
    END IF
    IF g_aph[l_ac].aph03 <>"2" THEN   
       CALL cl_set_comp_entry("aph16",FALSE)
       LET g_aph[l_ac].aph16 = '' 
       LET g_aph[l_ac].nmc02 = ''   
       DISPLAY BY NAME g_aph[l_ac].aph16,g_aph[l_ac].nmc02   
    END IF
    IF g_aph[l_ac].aph03 ="2" THEN
       CALL cl_set_comp_required("aph08",TRUE)
    END IF
END FUNCTION 
#No.FUN-9C0072 精簡程式碼 
 
 
