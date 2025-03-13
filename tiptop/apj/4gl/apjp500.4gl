# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#  
# Pattern name...: apjp500.4gl
# Descriptions...: 專案材料轉入請購單作業 
# Date & Author..: 00/01/24 BY Gina 
# Modify.........: 00/04/15 By Carol:請購單專案改在單身
# Modify.........: No.FUN-550060 05/05/19 By wujie 單據編號加大 
# Modify.........: No.FUN-560084 05/06/17 By Carrier 雙單位內容修改
# Modify.........: NO.MOD-590281 05/09/14 BY yiting 專案材料轉請購單時，請購單單別無法輸入超過三碼之單據別，而造成無法轉請購單。
# Modify.........: NO.TQC-5A0096 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.TQC-630022 06/03/08 By Pengu 轉請購單apmt420時稅別稅率會帶成幣別匯率
# Modify.........: No.TQC-640132 06/04/17 By Nicola 日期調整
# Modify.........: No.FUN-660053 06/06/12 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei 欄位型態轉換
# Modify.........: No.FUN-690024 06/09/18 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/18 By jamie 所有判斷狀況碼pmc05改判斷有效碼pmcacti  
# Modify.........: No.FUN-690047 06/09/29 By Sarah 抓取請購單資料時,需將pml38='Y'條件加入
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: NO.CHI-6A0016 06/10/27 BY yiting pml190/pml191/pml192需給預設
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-780087 06/12/05 By Carol 單身按[放棄]作業邏輯調整
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-790025 08/03/17 By douzh 項目管理制造功能調整
# Modify.........: No.TQC-840018 08/04/08 By douzh 單身已轉請購量不可錄
# Modify.........: No.MOD-840463 08/04/21 By douzh pjf07改為no use pjf05為需求量,pjf06為需求日期
# Modify.........: No.MOD-840476 08/04/25 By douzh 非尾階WBS材料需求也可拋請購單
# Modify.........: No.MOD-860155 08/07/15 By Pengu 1.單頭的幣別應default本國幣別
# Modify.........: No.MOD-930100 09/03/10 By rainy WBS尾階沒設活動，apmp500後請購單單身卻出現活動代號1 . 2. 3
# Modify.........: No.FUN-980005 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No:FUN-9B0023 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N' 
# Modify.........: No:TQC-9C0145 09/12/17 BY Carrier lock cursor 加上FOR UPDATE
# Modify.........: No:TQC-9C0146 09/12/17 BY jan 產生請購單時，出現-391
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-AC0108 10/12/21 By Smapmin 有使用計價單位時,產生到請購的計價單位要default ima908
# Modify.........: No:MOD-B30126 11/03/11 By sabrina AFTER FIELD pml20判斷數量合理性應跟pjf05判斷才對
# Modify.........: No:MOD-B30195 11/03/15 By Pengu 抓取已轉請採數量的SQL異常
# Modify.........: No.FUN-B80031 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-910088 11/11/23 By chenjing 增加數量欄位小數取位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   
    g_rec_b         LIKE type_file.num5,        #單身筆數    #No.FUN-680103 SMALLINT
    g_exit          LIKE type_file.chr1,        #FUN-680103  VARCHAR(01)          
    g_add_po        LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01), #判斷是否為新增之采購單  
    g_pmk           RECORD LIKE pmk_file.*,     #請購單頭檔
    g_pml           RECORD LIKE pml_file.*,     #請購單身檔
    g_pjf2          RECORD LIKE pjf_file.*,     #專案材料單身檔
    tm_pjb01_t      LIKE pjb_file.pjb01,        #專案代號
    tm_pjb02_t      LIKE pjb_file.pjb02,        #順序 -->WBS編碼       #No.FUN-790025
 
    tm              RECORD
        pjb01       LIKE pjb_file.pjb01,    #專案代號
        pjb02       LIKE pjb_file.pjb02,    #順序  -->WBS編碼  #No.FUN-790025
        pmk01       LIKE pmk_file.pmk01,    #請購單號
        pmk09       LIKE pmk_file.pmk09,    #廠商編號
        pmc03       LIKE pmc_file.pmc03,    #
        pmk12       LIKE pmk_file.pmk12,    #請購人員代號
        gen02       LIKE gen_file.gen02,    #
        pmk04       LIKE pmk_file.pmk04,    #採購日期
        pmk22       LIKE pmk_file.pmk22,    #採購幣別
        pmk13       LIKE pmk_file.pmk13,    #採購部門
        gem02       LIKE gem_file.gem02     #
                    END RECORD,
    g_pjf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pjf01       LIKE pjf_file.pjf01,    #WBS編碼          #No.FUN-790025
        pjk02       LIKE pjk_file.pjk02,    #活動代碼         #No.FUN-790025
        pjf02       LIKE pjf_file.pjf02,    #順序            
        pjf03       LIKE pjf_file.pjf03,    #料件編號
        pjf04       LIKE pjf_file.pjf04,    #品名規格 
        ima25       LIKE ima_file.ima25,    #請購單位         #No.MOD-840463
        pjf05       LIKE pjf_file.pjf05,    #需求數量         #No.MOD-840463 
        sum         LIKE type_file.num10,   #No.FUN-790025   已轉請采量
        pml20       LIKE pml_file.pml20,    #到廠日期 
        pjf06       LIKE pjf_file.pjf06,    #需求日期         #No.MOD-840463 
        pml34       LIKE pml_file.pml34,    #請購單號
        pml31       LIKE pml_file.pml31     #請購數量
                    END RECORD,
    g_pjf_t         RECORD                  #程式變數 (舊值)
        pjf01       LIKE pjf_file.pjf01,    #WBS編碼          #No.FUN-790025
        pjk02       LIKE pjk_file.pjk02,    #活動代碼         #No.FUN-790025
        pjf02       LIKE pjf_file.pjf02,    #順序  
        pjf03       LIKE pjf_file.pjf03,    #料件編號
        pjf04       LIKE pjf_file.pjf04,    #品名規格
        ima25       LIKE ima_file.ima25,    #請購單位         #No.MOD-840463
        pjf05       LIKE pjf_file.pjf05,    #需求數量         #No.MOD-840463 
        sum         LIKE type_file.num10,   #No.FUN-790025   已轉請采量
        pml20       LIKE pml_file.pml20,    #到廠日期
        pjf06       LIKE pjf_file.pjf06,    #需求日期         #No.MOD-840463 
        pml34       LIKE pml_file.pml34,    #請購單號
        pml31       LIKE pml_file.pml31     #請購數量
                    END RECORD,
    l_exit          LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01), #目前處理的ARRAY CNT
    l_smyslip       LIKE smy_file.smyslip,   # Prog. Version..: '5.30.06-13.03.12(05), #單別
    l_smyapr        LIKE smy_file.smyapr, #FUN-680103    VARCHAR(01)                
    l_flag          LIKE type_file.chr1,   #No.FUN-680103 VARCHAR(01)
    l_sql           LIKE type_file.chr1000,#No.FUN-680103 VARCHAR(300)
    l_pmk25         LIKE pmk_file.pmk25,   #                    
    l_sfb82         LIKE sfb_file.sfb82,   #                    
    l_pmkacti       LIKE pmk_file.pmkacti, #                    
    l_pmk05         LIKE pmk_file.pmk05,   #                    
    g_pmc03         LIKE pmc_file.pmc03,   #                    
    g_tot           LIKE pmk_file.pmk40,   #                    
    l_k1            LIKE bmr_file.bmr17,   #FUN-680103 DECIMAL(11,3)
    l_ac,l_k        LIKE type_file.num5,   #目前處理的ARRAY CNT   #No.FUN-680103 SMALLINT
    l_n1            LIKE type_file.chr1,   #FUN-680103 VARCHAR(1)            
    l_nn            LIKE type_file.num5,   #FUN-680103 SMALLINT        
    l_s1            LIKE type_file.chr1,   #FUN-680103 SMALLINT, #目前處理的SCREEN LINE 
    l_n             LIKE type_file.num5,   #No.FUN-680103 SMALLINT
    l_sum           LIKE type_file.num10   #FUN-680103    INTEGER
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL   
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE   li_result       LIKE type_file.num5     #No.FUN-680103 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680103 VARCHAR(72)
DEFINE   i               LIKE type_file.num5     #No.FUN-680103 SMALLINT 
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   OPEN WINDOW p500_w WITH FORM "apj/42f/apjp500" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET l_exit   = 'n'
 
   WHILE TRUE
     CLEAR FORM 
     CALL g_pjf.clear()
     IF s_shut(0) THEN
        EXIT WHILE
     END IF
     LET tm.pjb01=null
     LET tm.pjb02=null
     LET tm.pmk01=null
     LET tm.pmk04=g_today
     LET tm.pmk09=null
     LET tm.pmk12=null
     LET tm.pmk22=g_aza.aza17
     LET tm.pmk13=null
     CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
     INPUT BY NAME tm.pjb01,tm.pjb02,tm.pmk01,tm.pmk04,tm.pmk09,tm.pmk22,
                   tm.pmk12,tm.pmk13
                   WITHOUT DEFAULTS  
 
 
        AFTER FIELD pjb01
           IF cl_null(tm.pjb01) THEN
              NEXT FIELD pjb01
           END IF
             #進行輸入之單號檢查
           IF tm.pjb01 != tm_pjb01_t OR cl_null(tm_pjb01_t) THEN 
              SELECT count(*) INTO l_n FROM pja_file WHERE pja01 = tm.pjb01
              IF l_n=0  THEN   #check 專案代號主檔
                 CALL cl_err(tm.pjb01,'apj-004',0)
                 LET tm.pjb01 = tm_pjb01_t
                 DISPLAY BY NAME tm.pjb01 
                 NEXT FIELD pjb01
              END IF
              SELECT pjaconf INTO l_n1 FROM pja_file WHERE pja01 = tm.pjb01
              IF l_n1 = 'N' THEN
                CALL cl_err('',9029,0)
                NEXT FIELD pjb01
              END IF
              SELECT pjaclose INTO l_n1 FROM pja_file WHERE pja01 = tm.pjb01
              IF l_n1 = 'Y' THEN
                CALL cl_err('','abg-503',0)
                NEXT FIELD pjb01
              END IF
           END IF
        
        AFTER FIELD pjb02
           IF NOT cl_null(tm.pjb02) THEN                      #No.FUN-790025
             #進行輸入之單號檢查
              IF tm.pjb02 !=tm_pjb02_t OR cl_null(tm_pjb02_t) THEN 
                 SELECT count(*) INTO l_n FROM pjb_file
                  WHERE pjb01 = tm.pjb01 AND pjb02 = tm.pjb02
                 IF l_n = 0  THEN   #check專案明細單頭檔
                    CALL cl_err(tm.pjb02,'apj-004',0)
                    LET tm.pjb02 = tm_pjb02_t
                    DISPLAY BY NAME tm.pjb02 
                    NEXT FIELD pjb02
                 END IF
              END IF
           END IF                                             #No.FUN-790025
        
        AFTER FIELD pmk01                      #請購單號
           IF cl_null(tm.pmk01) THEN
              NEXT FIELD pmk01
           END IF
           LET l_smyslip = tm.pmk01[1,g_doc_len]
           CALL s_check_no("apm",tm.pmk01,"","1","pmk_file","pmk01","") 
           RETURNING li_result,tm.pmk01 
           LET tm.pmk01 = s_get_doc_no(tm.pmk01)  
            IF (NOT li_result) THEN                                                                                                 
               NEXT FIELD pmk01                                                                                                     
            END IF             
           
           SELECT smyapr INTO l_smyapr FROM smy_file WHERE smyslip = l_smyslip
           LET g_cnt=0
           SELECT count(*) INTO g_cnt FROM pmk_file WHERE pmk01 = tm.pmk01
           IF g_cnt > 0 THEN   #請購單已存在
              SELECT pmk09,pmk12,pmk04,pmk22,pmk13,pmk25,pmkacti
                INTO tm.pmk09,tm.pmk12,tm.pmk04,tm.pmk22,tm.pmk13,
                     l_pmk25,l_pmkacti
                FROM pmk_file
               WHERE pmk01 = tm.pmk01
              IF (l_pmk25 > '0' AND l_smyapr = 'Y') OR       #判斷狀況及簽核
                 (l_pmk25 > '1' AND l_smyapr = 'N') THEN
                 CALL cl_err(tm.pmk01,'mfg3110',0)
                 NEXT FIELD pmk01
              END IF
              IF l_pmkacti='N'  THEN                         #判斷有效碼
                 CALL cl_err(tm.pmk01,'mfg3028',1)
                 NEXT FIELD pmk01
              END IF
              IF tm.pmk22 != g_pmk.pmk22 AND NOT cl_null(g_pmk.pmk22) THEN
                 CALL cl_err(tm.pmk22,'mfg3138',1)           #判斷幣別
                 NEXT FIELD pmk01
              END IF
              IF g_pmk.pmk22 != tm.pmk22 THEN           #如請購幣別與採購幣別不同
                 CALL cl_err('','mfg3138',0)
              END IF 
              IF g_pmk.pmk09 != tm.pmk09 THEN           #如請購廠商與採購廠商不同
                 CALL cl_err('','mfg3020',0)
                 SELECT pmc03 INTO g_pmc03  #廠商名稱
                   FROM pmc_file WHERE pmc01=tm.pmk09
                DISPLAY g_pmc03 TO FORMONLY.pmc03
              END IF
              DISPLAY tm.pmk09 TO FORMONLY.pmk09
              DISPLAY tm.pmk04 TO FORMONLY.pmk04
              DISPLAY tm.pmk12 TO FORMONLY.pmk12
              DISPLAY tm.pmk13 TO FORMONLY.pmk13
              DISPLAY tm.pmk22 TO FORMONLY.pmk22
              LET g_add_po='N'
                  CALL p500_pmk09()
                  CALL p500_pmk12()
                  CALL p500_pmk13()
                  CALL p500_pmk22()
 
              EXIT INPUT                        #如為已存在之採購單後面欄位不輸入
 
           ELSE
              LET g_add_po='Y'
              CALL s_auto_assign_no("apm",tm.pmk01,tm.pmk04,"1","pmk_file","pmk01","","","")
              RETURNING li_result,tm.pmk01
              IF (NOT li_result) THEN                                                                                                 
                 NEXT FIELD pmk01                                                                                                     
              END IF                                                                                                                  
              DISPLAY tm.pmk01 TO pmk01 
           END IF
        
        AFTER FIELD pmk09                      #供應商
           IF not cl_null(tm.pmk09) THEN 
              CALL p500_pmk09()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(tm.pmk09,g_errno,0)
                 NEXT FIELD pmk09
              END IF
           END IF
        
        AFTER FIELD pmk04                      #請購日期
           IF cl_null(tm.pmk04) THEN
              NEXT FIELD pmk04
           END IF
        
        AFTER FIELD pmk22                      #採購幣別
           IF NOT cl_null(tm.pmk22) THEN 
              CALL p500_pmk22()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(tm.pmk22,g_errno,0)
                 NEXT FIELD pmk22
              END IF
           END IF
        
        AFTER FIELD pmk12                      #請購人員
           IF cl_null(tm.pmk12) THEN 
              NEXT FIELD pmk12
           ELSE
              CALL p500_pmk12()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(tm.pmk12,g_errno,0)
                 NEXT FIELD pmk12
              END IF
           END IF
 
      AFTER FIELD pmk13                      #請購部門
         IF cl_null(tm.pmk13) THEN 
            NEXT FIELD pmk13
         ELSE
            CALL p500_pmk13()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.pmk13,g_errno,0) 
               NEXT FIELD pmk13
            END IF
         END IF
 
      AFTER INPUT       
         IF INT_FLAG THEN
            LET INT_FLAG = 0 
            LET l_exit   = 'y'
            EXIT INPUT
         END IF
         IF cl_null(tm.pjb01) THEN
            NEXT FIELD pjb01
         END IF  #重要欄位不可空白
         IF cl_null(tm.pmk01) THEN
            NEXT FIELD pmk01
         END IF
         IF cl_null(tm.pmk04) THEN
            NEXT FIELD pmk04
         END IF
         IF cl_null(tm.pmk12) THEN
            NEXT FIELD pmk12
         END IF
         IF cl_null(tm.pmk13) THEN
            NEXT FIELD pmk13
         END IF
 
         ON ACTION qry_pr
                  SELECT MAX(pml02) INTO l_nn FROM pml_file WHERE pml01=tm.pmk01
                  IF cl_null(l_nn) THEN LET l_nn=1 END IF  
                  CALL q_pmk(FALSE,TRUE,tm.pmk01,l_nn,'0') RETURNING tm.pmk01,l_nn
                  DISPLAY tm.pmk01 TO FORMONLY.pmk01
                  NEXT FIELD pmk01
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pjb01) #專案代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pja"
                  LET g_qryparam.default1 = tm.pjb01
                  CALL cl_create_qry() RETURNING tm.pjb01
                  DISPLAY tm.pjb01 TO pjb01
                  NEXT FIELD pjb01
               WHEN INFIELD(pjb02) #順序 -->WBS編碼           #No.FUN-790025
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pjb7"              #No.FUN-790025
                  LET g_qryparam.default1 = tm.pjb02
                  LET g_qryparam.arg1 = tm.pjb01
                  CALL cl_create_qry() RETURNING tm.pjb02
                  DISPLAY tm.pjb02 TO pjb02
                  NEXT FIELD pjb02
               WHEN INFIELD(pmk01) #請購單號
                  LET l_smyslip=s_get_doc_no(tm.pmk01)  #MOD-590281
                  CALL q_smy(FALSE,FALSE,l_smyslip,'APM','1') RETURNING l_smyslip #TQC-670008
                  LET tm.pmk01=l_smyslip  #MOD-590281
                  DISPLAY tm.pmk01 TO pmk01
                  NEXT FIELD pmk01
               WHEN INFIELD(pmk09) #查詢廠商檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.default1 = tm.pmk09
                  CALL cl_create_qry() RETURNING tm.pmk09
                  DISPLAY tm.pmk09 TO FORMONLY.pmk09
                  CALL p500_pmk09()
                  NEXT FIELD pmk09
               WHEN INFIELD(pmk22) #查詢幣別檔 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = tm.pmk22
                  CALL cl_create_qry() RETURNING tm.pmk22
                  DISPLAY tm.pmk22 TO pmk22
                  NEXT FIELD pmk22
               WHEN INFIELD(pmk12) #採購員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = tm.pmk12
                  CALL cl_create_qry() RETURNING tm.pmk12
                  DISPLAY BY NAME tm.pmk12 
                  CALL p500_pmk12()
                  NEXT FIELD pmk12
               WHEN INFIELD(pmk13) #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = tm.pmk13
                  CALL cl_create_qry() RETURNING tm.pmk13
                  DISPLAY BY NAME tm.pmk13 
                  CALL p500_pmk13()
                  NEXT FIELD pmk13
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
             CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION locale
             CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         ON ACTION exit                            #加離開功能
             LET INT_FLAG = 1
             EXIT INPUT
      
      END INPUT
      IF INT_FLAG THEN LET INT_FLAG = 0  EXIT WHILE END IF
      IF l_exit = 'n' THEN 
         CALL g_pjf.clear()
         IF cl_confirm('apj-013') THEN
            LET g_rec_b = 0
            CALL p500_b_fill()              #單身填充
            IF g_exit='Y' THEN
               EXIT WHILE
            END IF
            CALL p500_b()                   #修改單身資料
         END IF
      ELSE
         EXIT WHILE
      END IF
   END WHILE
   CLOSE WINDOW p500_w                #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p500_b_fill()                 #單身填充
    DEFINE l_sql      LIKE type_file.chr1000,       #No.FUN-680103 VARCHAR(300)
           l_ima49    LIKE ima_file.ima49,
           l_pml33    LIKE pml_file.pml33
    DEFINE l_sumA     LIKE pml_file.pml20
    DEFINE l_sumB     LIKE pmn_file.pmn20
    DEFINE l_pjb25    LIKE pjb_file.pjb25                                                 #No.FUN-790025   
    DEFINE l_pjb      RECORD LIKE pjb_file.*                                              #No.FUN-790025
 
    IF tm.pjb02 IS NOT NULL THEN
       SELECT pjb25 INTO l_pjb25 FROM pjb_file
        WHERE pjb01 = tm.pjb01 AND pjb02 = tm.pjb02
       IF l_pjb25 = 'N' THEN
          LET l_sql = " SELECT pjfa01,'',pjfa02,pjfa03,pjfa04,ima25,pjfa05,'','',pjfa06,'','' ",      #No.MOD-840463
                      " FROM pjfa_file,ima_file",
                      " WHERE pjfa01 = '",tm.pjb02,"' ",
                      " AND ima01 = pjfa03 "
       ELSE 
          LET l_sql = " SELECT pjk11,pjfb02,pjfb03,pjfb04,pjfb05,ima25,pjfb06,'','',pjfb07,'','' ",   #No.MOD-840463
                      " FROM pjk_file,pjfb_file,ima_file",
                      " WHERE pjfb01 = pjk01 ",
                      " AND pjfb02 = pjk02 ",
                      " AND pjk11 = '",tm.pjb02,"' ",
                      " AND ima01 = pjfb04 "
       END IF
       PREPARE p500_prepare FROM l_sql
       MESSAGE " SEARCHING! " 
       DECLARE p500_cur CURSOR FOR p500_prepare
       LET g_cnt = 1
 
       FOREACH p500_cur INTO g_pjf[g_cnt].*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
         #已轉請采量＋采購(無請購單來源)的數量
        #--------------No:MOD-B30195 add
         IF cl_null(g_pjf[g_cnt].pjk02) THEN 
            SELECT SUM(pml20) INTO l_sumA FROM pml_file,pmk_file
             WHERE pmk01 = pml01
               AND pml12 = tm.pjb01
               AND pml121 = g_pjf[g_cnt].pjf01
               AND pml04 = g_pjf[g_cnt].pjf03
            SELECT SUM(pmn20) INTO l_sumB FROM pmm_file,pmn_file
             WHERE pmm01 = pmn01
               AND (pmn24 IS NULL OR pmn24 ='')
               AND pmn122 = tm.pjb01
               AND pmn96 = g_pjf[g_cnt].pjf01
               AND pmn04 = g_pjf[g_cnt].pjf03
         ELSE
        #--------------No:MOD-B30195 add
            SELECT SUM(pml20) INTO l_sumA FROM pml_file,pmk_file
             WHERE pmk01 = pml01
               AND pml12 = tm.pjb01
               AND pml121 = g_pjf[g_cnt].pjf01
               AND pml122 = g_pjf[g_cnt].pjk02
               AND pml04 = g_pjf[g_cnt].pjf03   #No:MOD-B30195 add
            SELECT SUM(pmn20) INTO l_sumB FROM pmm_file,pmn_file
             WHERE pmm01 = pmn01
               AND (pmn24 IS NULL OR pmn24 ='')
               AND pmn122 = tm.pjb01
               AND pmn96 = g_pjf[g_cnt].pjf01
               AND pmn97 = g_pjf[g_cnt].pjk02
               AND pmn04 = g_pjf[g_cnt].pjf03   #No:MOD-B30195 add
         END IF            #No:MOD-B30195 add
         IF cl_null(l_sumA) THEN LET l_sumA=0 END IF
         IF cl_null(l_sumB) THEN LET l_sumB=0 END IF
         LET g_pjf[g_cnt].sum = l_sumA+l_sumB
         DISPLAY g_pjf[g_cnt].sum TO FORMONLY.sum
         #請購數量 = 需求數量
         LET g_pjf[g_cnt].pml20 = g_pjf[g_cnt].pjf05
 
         SELECT ima49 INTO l_ima49 FROM ima_file
            WHERE ima01 = g_pjf[g_cnt].pjf03 
         IF SQLCA.sqlcode THEN LET l_ima49 = 0 END IF
         #到廠日期 = 需求日期 + 到廠前置期
         LET g_pjf[g_cnt].pml34 = g_pjf[g_cnt].pjf06 + l_ima49         #No.MOD-840463 
 
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
       END FOREACH
    ELSE
       DECLARE p500_cur_b CURSOR FOR 
         SELECT * FROM pjb_file
           WHERE pjb01 = tm.pjb01 
       FOREACH p500_cur_b INTO l_pjb.*
       IF l_pjb.pjb25 = 'N' THEN
          LET l_sql = " SELECT pjfa01,'',pjfa02,pjfa03,pjfa04,ima25,pjfa05,'','',pjfa06,'','' ",          #No.MOD-840463
                      " FROM pjfa_file,ima_file",
                      " WHERE pjfa01 = '",l_pjb.pjb02,"' ",
                      " AND ima01 = pjfa03 "
       ELSE 
          LET l_sql = " SELECT pjk11,pjfb02,pjfb03,pjfb04,pjfb05,ima25,pjfb06,'','',pjfb07,'','' ",       #No.MOD-840463
                      " FROM pjk_file,pjfb_file,ima_file",
                      " WHERE pjfb01 = pjk01 ",
                      " AND pjfb02 = pjk02 ",
                      " AND pjk11 = '",tm.pjb02,"' ",
                      " AND ima01 = pjfb04 "
       END IF
         PREPARE p500_pb FROM l_sql
         MESSAGE " SEARCHING! " 
         DECLARE p500_cb CURSOR FOR p500_pb
         LET g_cnt = 1
 
         FOREACH p500_cb INTO g_pjf[g_cnt].*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
         #已轉請采量＋采購(無請購單來源)的數量
         #--------------No:MOD-B30195 add
          IF cl_null(g_pjf[g_cnt].pjk02) THEN 
             SELECT SUM(pml20) INTO l_sumA FROM pml_file,pmk_file
              WHERE pmk01 = pml01
                AND pml12 = tm.pjb01
                AND pml121 = g_pjf[g_cnt].pjf01
                AND pml04 = g_pjf[g_cnt].pjf03
             SELECT SUM(pmn20) INTO l_sumB FROM pmm_file,pmn_file
              WHERE pmm01 = pmn01
                AND (pmn24 IS NULL OR pmn24 ='')
                AND pmn122 = tm.pjb01
                AND pmn96 = g_pjf[g_cnt].pjf01
                AND pmn04 = g_pjf[g_cnt].pjf03
          ELSE
         #--------------No:MOD-B30195 add
             SELECT SUM(pml20) INTO l_sumA FROM pml_file,pmk_file
              WHERE pmk01 = pml01
                AND pml12 = tm.pjb01
                AND pml121 = g_pjf[g_cnt].pjf01
                AND pml122 = g_pjf[g_cnt].pjk02
                AND pml04 = g_pjf[g_cnt].pjf03   #No:MOD-B30195 add
             SELECT SUM(pmn20) INTO l_sumB FROM pmm_file,pmn_file
              WHERE pmm01 = pmn01
                AND (pmn24 IS NULL OR pmn24 ='')
                AND pmn122 = tm.pjb01
                AND pmn96 = g_pjf[g_cnt].pjf01
                AND pmn97 = g_pjf[g_cnt].pjk02
                AND pmn04 = g_pjf[g_cnt].pjf03   #No:MOD-B30195 add
          END IF            #No:MOD-B30195 add
           IF cl_null(l_sumA) THEN LET l_sumA=0 END IF
           IF cl_null(l_sumB) THEN LET l_sumB=0 END IF
           LET g_pjf[g_cnt].sum = l_sumA+l_sumB
           DISPLAY g_pjf[g_cnt].sum TO FORMONLY.sum
           #請購數量 = 需求數量
           LET g_pjf[g_cnt].pml20 = g_pjf[g_cnt].pjf05

           SELECT ima49 INTO l_ima49 FROM ima_file
              WHERE ima01 = g_pjf[g_cnt].pjf03 
           IF SQLCA.sqlcode THEN LET l_ima49 = 0 END IF
           #到廠日期 = 需求日期 + 到廠前置期
           LET g_pjf[g_cnt].pml34 = g_pjf[g_cnt].pjf06 + l_ima49          #No.MOD-840463 
           DISPLAY g_pjf[g_cnt].pml34 TO FORMONLY.pml34
 
           LET g_cnt = g_cnt + 1
           IF g_cnt > g_max_rec THEN
              CALL cl_err( '', 9035, 0 )
              EXIT FOREACH
           END IF
         END FOREACH
       END FOREACH
    END IF
    CALL g_pjf.deleteElement(g_cnt)
 
    IF g_cnt = 1 THEN CALL cl_err('','apm-204',0) END IF
    LET g_cnt = g_cnt - 1 
    DISPLAY g_cnt TO FORMONLY.cnt2  
    LET g_rec_b = g_cnt 
END FUNCTION
 
FUNCTION p500_b()                          #單身修改
DEFINE
    l_ima49         LIKE ima_file.ima49,
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680103 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680103 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680103 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680103 VARCHAR(1)
    l_total         LIKE alh_file.alh33,    #No.FUN-680103 DECIMAL(13,3),
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680103 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680103 SMALLINT
 
    LET g_action_choice = ""
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pjf01,'',pjf02,pjf03,pjf04,'',pjf05,'','',pjf06,'','' ",      #No.TQC-840018 
                       "  FROM pjf_file  ",
                       " WHERE pjf01  = ? ",
                       "   AND pjf02  = ? " ,
                       " FOR UPDATE "                 #No.TQC-9C0145
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #No.FUN-B80031---刪除空白行-- 
    DECLARE p500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
        INPUT ARRAY g_pjf WITHOUT DEFAULTS FROM s_pjf.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
                LET l_ac = 1
                CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            SELECT COUNT(*) INTO g_cnt FROM pjf_file
                   WHERE pjf01 = tm.pjb02 AND pjf02 <= g_pjf[l_ac].pjf02           #No.FUN-790025
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
 
                LET g_pjf_t.* = g_pjf[l_ac].*  #BACKUP
                OPEN p500_bcl USING tm.pjb02,g_pjf_t.pjf02                          #No.FUN-790025
 
                IF STATUS THEN
                    CALL cl_err("OPEN p500_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF  
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_pjf[l_ac].* TO NULL      #900423
            LET g_pjf_t.* = g_pjf[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pjf02
 
        AFTER INSERT
          #DISPLAY "AFTER INSERT!"                #CHI-A70049 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
        AFTER FIELD pml20 
           #FUN-910088--add--start--
           LET g_pjf[l_ac].pml20 = s_digqty(g_pjf[l_ac].pml20,g_pjf[l_ac].ima25)
           DISPLAY BY NAME g_pjf[l_ac].pml20 
           #FUN-910088--add--end--
           #---------------No:MOD-B30195 modify
           #SELECT SUM(pml20) INTO l_sum FROM pml_file
           #  WHERE pml121=g_pjf[l_ac].pjf01 AND pml122=g_pjf[l_ac].pjf02 AND         #No.FUN-790025
           #        pml12=tm.pjb01
           #IF cl_null(l_sum)  THEN LET l_sum=0  END IF 
           #LET l_sum = l_sum + g_pjf[l_ac].pml20 
            LET l_sum = g_pjf[l_ac].sum + g_pjf[l_ac].pml20
           #---------------No:MOD-B30195 end
           #IF l_sum > g_pjf[l_ac].pjf06  THEN          #No.MOD-840463  #MOD-B30126 mark
            IF l_sum > g_pjf[l_ac].pjf05  THEN          #MOD-B30126 add
               CALL cl_err('','apj-017',1)      
            END IF  
 
        BEFORE DELETE                            #是否取消單身
            IF g_pjf_t.pjf02 IS NOT NULL THEN
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               IF p_cmd = 'u' THEN
                   LET g_pjf[l_ac].* = g_pjf_t.*
               END IF
               CLOSE p500_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p500_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
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
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
        END INPUT
 
        IF INT_FLAG THEN
           LET INT_FLAG = 0 
           RETURN 
        END IF
 
        LET l_flag='N'
        FOR i=1 TO g_rec_b             #判斷單身是否有輸入
            IF g_pjf[i].pjf02>0 AND NOT cl_null(g_pjf[i].pjf02) THEN
               LET l_flag='Y'
               EXIT FOR
            END IF
        END FOR 
        IF l_flag='Y' THEN        #確認
           IF cl_sure(0,0) THEN 
              LET g_success='Y'
              BEGIN WORK
              CALL p500_process()   #產生單身
              IF g_success='Y' THEN
                 CALL cl_cmmsg(4)
                 COMMIT WORK
                 IF cl_confirm('asf-538') THEN
                    LET g_msg="apmt420 ","'",tm.pmk01,"'" #No:B011
                    CALL cl_cmdrun(g_msg)
                 END IF
              ELSE
                 CALL cl_rbmsg(4)
                 ROLLBACK WORK
              END IF
           END IF
        END IF
        CLEAR FORM  
        CALL g_pjf.clear()
END FUNCTION
    
#----------------#
#   確     認    #
#----------------#
FUNCTION p500_process()             
  DEFINE l_pmp,l_pmo    LIKE type_file.num5     #No.FUN-680103 SMALLINT   
  DEFINE l_sum          LIKE feb_file.feb10     #No.FUN-680103 DEC(10,2) #數量
  DEFINE l_pmli         RECORD LIKE pmli_file.* #NO.FUN-7B0018
 
      IF g_add_po='Y' THEN
              CALL s_auto_assign_no("apm",tm.pmk01,tm.pmk04,"1","pmk_file","pmk01","","","")
              RETURNING li_result,tm.pmk01
              IF (NOT li_result) THEN                                                                                                 
                 RETURN
              END IF                                                                                                                  
              DISPLAY tm.pmk01 TO pmk01 
         CALL p500_pmk()            #產生請購單頭資料(新增)
         LET g_pmk.pmk46 = '1'  #No.FUN-870007
         LET g_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
         LET g_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO pmk_file VALUES (g_pmk.*)
         IF SQLCA.sqlcode THEN 
            CALL cl_err3("ins","pmk_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
            LET g_success='N' 
            RETURN
         END IF
      ELSE
         UPDATE pmk_file SET pmkmodu=g_user,pmkdate=g_today  
          WHERE pmk01=tm.pmk01 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
            CALL cl_err3("upd","pmk_file",tm.pmk01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
            LET g_success='N' 
            RETURN
         END IF
      END IF
 
#----- insert 採購單身檔
      LET l_nn=0
      IF g_add_po='Y' THEN      #產生序號 
         LET l_nn=0
      ELSE 
         SELECT MAX(pml02) INTO l_nn FROM pml_file WHERE pml01=tm.pmk01
         IF cl_null(l_nn) THEN LET l_nn = 0 END IF
      END IF
 
      FOR g_cnt=1 TO g_rec_b
          IF g_pjf[g_cnt].pml20>0 AND NOT cl_null(g_pjf[g_cnt].pml20) THEN
             #-----產生單身資料
             LET l_nn=l_nn+1
             CALL p500_pml()            
             LET g_pml.pml49 = '1'  #No.FUN-870007
             LET g_pml.pml50 = '1'  #No.FUN-870007
             LET g_pml.pml54 = '2'  #No.FUN-870007
             LET g_pml.pml56 = '1'  #No.FUN-870007
             LET g_pml.pml92 = 'N'  #FUN-9B0023
             LET g_pml.pml91 = 'N'  #TQC-9C0146
             INSERT INTO pml_file VALUES (g_pml.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","pml_file",g_pml.pml01,g_pml.pml02,SQLCA.sqlcode,"","ins pml",1) #No.FUN-660053
                LET g_success='N'
                RETURN
             END IF
 
             IF NOT s_industry('std') THEN
                INITIALIZE l_pmli.* TO NULL
                LET l_pmli.pmli01 = g_pml.pml01
                LET l_pmli.pmli02 = g_pml.pml02
                IF NOT s_ins_pmli(l_pmli.*,'') THEN
                   LET g_success='N'
                   RETURN
                END IF
             END IF
 
            #合計專案已轉請購量
             SELECT SUM(pml20) INTO l_sum FROM pml_file,pmk_file 
              WHERE pml12=tm.pjb01
                AND pml121=g_pjf[g_cnt].pjf01        #No.FUN-790025 
                AND pml122=g_pjf[g_cnt].pjf02        #No.FUN-790025
                AND pmk01=pml01 
                AND pmk25 !='9'   #no.5733
                AND pml38='Y'   #FUN-690047 add  #可用/不可用
             IF cl_null(l_sum) THEN LET l_sum=0  END IF 
          END IF
      END FOR
END FUNCTION
 
FUNCTION  p500_pmk()       #產生採購單頭資料
  DEFINE l_pmc15 LIKE pmc_file.pmc15,
         l_pmc16 LIKE pmc_file.pmc16,
         l_pmc17 LIKE pmc_file.pmc17,
         l_pmc22 LIKE pmc_file.pmc22,
         l_pmc47 LIKE pmc_file.pmc47,
         l_pmc49 LIKE pmc_file.pmc49,
         l_gec04 LIKE gec_file.gec04,
         l_smyprint LIKE smy_file.smyprint,
         l_smyapr  LIKE smy_file.smyapr,
         l_smysign LIKE smy_file.smysign,
         l_smydays LIKE smy_file.smydays,
         l_smyprit LIKE smy_file.smyprit 
 
     SELECT pmc15,pmc16,pmc17,pmc22,pmc47
          INTO l_pmc15,l_pmc16,l_pmc17,l_pmc22,l_pmc47
          FROM pmc_file
          WHERE pmc01 = tm.pmk09
 
    LET g_pmk.pmk01=tm.pmk01          #單號
    LET g_pmk.pmk02="REG"             #單據性質
    LET g_pmk.pmk03=" "               #更動序號
    LET g_pmk.pmk04=tm.pmk04          #採購日期
    LET g_pmk.pmk05=''                #專案號碼--> no use 
    LET g_pmk.pmk06=" "               #預算號碼
    LET g_pmk.pmk07=" "               #請購類別
    LET g_pmk.pmk08=" "               #PBI批號
    LET g_pmk.pmk09=tm.pmk09          #供應廠商
    LET g_pmk.pmk10=l_pmc15           #送貨地址
    LET g_pmk.pmk11=l_pmc16           #帳單地址
    LET g_pmk.pmk12=tm.pmk12          #採購員
    LET g_pmk.pmk13=tm.pmk13          #採購部門
    LET g_pmk.pmk14=" "               #收貨部門
    LET g_pmk.pmk15=" "               #確認人
    LET g_pmk.pmk16=" "               #運送方式
    LET g_pmk.pmk17=" "               #代理商
    LET g_pmk.pmk18="N"               #確認否
    LET g_pmk.pmk20=l_pmc17           #付款方式
    LET g_pmk.pmk21=l_pmc47           #稅別        #No.TQC-630022   add
    LET g_pmk.pmk22=tm.pmk22           #幣別
    LET g_pmk.pmk25='0'		      #狀況碼
    LET g_pmk.pmk26=" "               #理由碼
    LET g_pmk.pmk27=g_today           #狀況異動日期
    LET g_pmk.pmk28=" "               #會計分類
    LET g_pmk.pmk29=" "               #會計科目
    LET g_pmk.pmk30='Y'               #驗收單列印否
    LET g_pmk.pmk31=" "               #會計年度
    LET g_pmk.pmk32=" "               #會計科目
 
    LET g_pmk.pmk40=0                 #總金額
    LET g_pmk.pmk401=" "              #代買總金額
    LET g_pmk.pmk41=l_pmc49           #價格條件
    LET g_pmk.pmk42=s_curr3(tm.pmk22,g_today,'S')      #匯率
       SELECT gec04 INTO l_gec04 FROM gec_file
          WHERE gec01=l_pmc47 AND gec011='1'
    LET g_pmk.pmk43=l_gec04           #稅率
    LET g_pmk.pmk45="Y"               #可用/不可用
 
    LET l_smyslip = s_get_doc_no(tm.pmk01)   #No.TQC-5A0096
    SELECT smyprint,smyapr,smysign,smydays,smyprit
      INTO l_smyprint,l_smyapr,l_smysign,l_smydays,l_smyprit
      FROM smy_file
      WHERE smyslip = l_smyslip 
 
    LET g_pmk.pmkprsw=l_smyprint      #列印抑制
    LET g_pmk.pmkprno=0               #已列印次數
    LET g_pmk.pmkprdt=NULL            #最後列印日期
    LET g_pmk.pmkmksg=l_smyapr        #是否簽核
    LET g_pmk.pmksign=l_smysign       #簽核等級
    LET g_pmk.pmkdays=l_smydays       #簽核完成天數
    LET g_pmk.pmkprit=l_smyprit       #簽核優先等級
    LET g_pmk.pmksseq = 0             #已簽順序
    LET g_pmk.pmksmax = 0             #應簽順序
    LET g_pmk.pmkacti='Y'             #資料有效碼 
    LET g_pmk.pmkuser=g_user          #資料所有者 
    LET g_pmk.pmkgrup=g_grup          #資料所有部門
    LET g_pmk.pmkmodu=' '             #資料修改者 
    LET g_pmk.pmkdate=g_today         #最近修改日期
 
    LET g_pmk.pmkplant = g_plant      #FUN-980005
    LET g_pmk.pmklegal = g_legal      #FUN-980005
END FUNCTION
 
FUNCTION p500_pml()  #產生單身資料
DEFINE  l_pml02      LIKE pml_file.pml02,
        l_pml13      LIKE pml_file.pml13, 
        l_ima05      LIKE ima_file.ima05,
        l_ima25      LIKE ima_file.ima25,
        l_ima44_fac  LIKE ima_file.ima44_fac,
        l_imb118     LIKE imb_file.imb118 
DEFINE  l_ima44      LIKE ima_file.ima44
DEFINE  l_ima906     LIKE ima_file.ima906
DEFINE  l_ima907     LIKE ima_file.ima907
DEFINE  l_cnt        LIKE type_file.num5          #No.FUN-680103 SMALLINT
DEFINE  l_factor     LIKE ima_file.ima44_fac
DEFINE l_ima491   LIKE ima_file.ima491   #No.TQC-640132
DEFINE l_ima49    LIKE ima_file.ima49    #No.TQC-640132
DEFINE l_ima913   LIKE ima_file.ima913   #NO.CHI-6A0016
DEFINE l_ima914   LIKE ima_file.ima914   #NO.CHI-6A0016
 
  #---取出請購單身資料
   SELECT * INTO g_pjf2.* FROM pjf_file 
    WHERE pjf01 = tm.pjb02 AND                                  #No.FUN-790025
          pjf02 = g_pjf[g_cnt].pjf02                            #No.FUN-790025
 
  #---產生採購單身資料
   LET  g_pml.pml01=tm.pmk01              #請購單號
   IF g_add_po='N' THEN      #產生序號
      SELECT pmk02  INTO g_pml.pml011 FROM pmk_file WHERE pmk01=tm.pmk01
   ELSE
      LET  g_pml.pml011="REG"                #採購性質
   END IF
   LET  g_pml.pml02=l_nn                  #序號
   LET  g_pml.pml03=" "                   #詢價單號
   LET  g_pml.pml04=g_pjf[g_cnt].pjf03          #料號                  #No.MOD-840463 
   LET  g_pml.pml041=g_pjf[g_cnt].pjf04         #品名                  #No.MOD-840463 
      SELECT ima05,ima25,ima44_fac,ima49,ima491,   #No.TQC-640132
             ima913,ima914                         #NO.CHI-6A0016
        INTO l_ima05,l_ima25,l_ima44_fac,l_ima49,l_ima491,   #No.TQC-640132
             l_ima913,l_ima914                               #NO.CHI-6A0016
        FROM ima_file
        WHERE ima01 = g_pml.pml04
   LET  g_pml.pml05=NULL                  #APS單據編號(no.4649)
   LET  g_pml.pml06=''                    #備註
   LET  g_pml.pml07=g_pjf[g_cnt].ima25    #請購單位                #No.MOD-840463
   LET  g_pml.pml08=l_ima25               #庫存單位
   LET  g_pml.pml09=l_ima44_fac           #轉換率
   LET  g_pml.pml10=" "                   #檢驗碼
   LET  g_pml.pml11='N'                   #凍結碼
   LET  g_pml.pml12 =tm.pjb01             #專案代號
   LET  g_pml.pml121=g_pjf[g_cnt].pjf01   #專案代號-WBS編碼        #No.MOD-840463 
   LET  g_pml.pml122=g_pjf[g_cnt].pjk02   #活動代碼                                 #MOD-930100   
   LET  g_pml.pml123=" "                  #廠牌
 
   LET  l_pml13 = s_overate(g_pml.pml04)    
   LET  g_pml.pml13=l_pml13               #超短交限率
   LET  g_pml.pml14=g_sma.sma886[1,1]     #部份交貨否  
   LET  g_pml.pml15=g_sma.sma886[2,2]     #提前交貨否
   LET  g_pml.pml16='0'                   #狀況碼
   LET  g_pml.pml18=' '                   #MRP需求日
   LET  g_pml.pml20=g_pjf[g_cnt].pml20    #訂購量
   LET  g_pml.pml21=0                     #已轉採購數量
   LET  g_pml.pml23='Y'                   #課稅否
      SELECT imb118 INTO l_imb118 FROM imb_file
        WHERE imb01 = g_pml.pml04
      IF cl_null(l_imb118) THEN LET l_imb118=0 END IF
   LET  g_pml.pml30=l_imb118              #標準價格
   LET  g_pml.pml31=g_pjf[g_cnt].pml31    #單價
   LET  g_pml.pml32=0                     #採購價差
   CALL s_aday(g_pjf[g_cnt].pjf06,-1,0) RETURNING g_pml.pml35     #No.MOD-840463
   CALL s_aday(g_pml.pml35,-1,l_ima491) RETURNING g_pml.pml34
   CALL s_aday(g_pml.pml34,-1,l_ima49) RETURNING g_pml.pml33
   LET  g_pml.pml38='Y'                   #可用/不可用
   LET  g_pml.pml40=" "                   #會計科目
   LET  g_pml.pml41=" "                   #PLP NO
   LET  g_pml.pml42='0'                   #替代碼
   LET  g_pml.pml43=0                     #作業序號
   LET  g_pml.pml431=0                    #下一站作業序號
   LET  g_pml.pml44 =0                    #本幣單價
 
   LET g_pml.pmlplant = g_plant #FUN-980005
   LET g_pml.pmllegal = g_legal #FUN-980005
 
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima25,ima44,ima906,ima907 INTO l_ima25,l_ima44,l_ima906,l_ima907
        FROM ima_file WHERE ima01=g_pml.pml04
      IF SQLCA.sqlcode =100 THEN                                                  
         IF g_pml.pml04 MATCHES 'MISC*' THEN                                
            SELECT ima25,ima44,ima906,ima907 
              INTO l_ima25,l_ima44,l_ima906,l_ima907                               
              FROM ima_file WHERE ima01='MISC'                                    
         END IF                                                                   
      END IF                                                                      
      IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
      LET g_pml.pml80=g_pml.pml07
      LET l_factor = 1
      CALL s_umfchk(g_pml.pml04,g_pml.pml80,l_ima44) 
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET g_pml.pml81=l_factor
      LET g_pml.pml82=g_pml.pml20
      LET g_pml.pml83=l_ima907
      LET l_factor = 1
      CALL s_umfchk(g_pml.pml04,g_pml.pml83,l_ima44) 
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET g_pml.pml84=l_factor
      LET g_pml.pml85=0
      IF l_ima906 = '3' THEN
         LET l_factor = 1
         CALL s_umfchk(g_pml.pml04,g_pml.pml80,g_pml.pml83) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml.pml85=g_pml.pml82*l_factor
         LET g_pml.pml85 = s_digqty(g_pml.pml85,g_pml.pml83)   #FUN-910088--add
      END IF
   END IF
   #-----MOD-AC0108---------
   #LET g_pml.pml86 =g_pml.pml07
   #LET g_pml.pml87 =g_pml.pml20
   IF g_sma.sma116 MATCHES  '[02]' THEN 
      LET g_pml.pml86 =g_pml.pml07
      LET g_pml.pml87 =g_pml.pml20
   ELSE
      SELECT ima908 INTO g_pml.pml86 FROM ima_file
       WHERE ima01 = g_pml.pml04
      CALL s_umfchk(g_pml.pml04,g_pml.pml07,g_pml.pml86) 
           RETURNING l_cnt,l_factor
      LET g_pml.pml87 = g_pml.pml20 * l_factor
      LET g_pml.pml87 = s_digqty(g_pml.pml87,g_pml.pml86)   #FUN-910088--add--
   END IF 
   #-----END MOD-AC0108-----
   LET g_pml.pml930=s_costcenter(g_pmk.pmk13) #FUN-670061
   LET g_pml.pml190 = l_ima913
   LET g_pml.pml191 = l_ima914
   LET g_pml.pml192 = 'N'
 
END FUNCTION
 
FUNCTION  p500_pmk01()    #請購單號
DEFINE
    l_pjf    LIKE type_file.num5,     #FUN-680103 SMALLINT
    l_pjf01  LIKE pjf_file.pjf01,
    l_pmc03  LIKE pmc_file.pmc03,
    l_gen02  LIKE gen_file.gen02
 
    LET g_errno=' '
    SELECT pmk_file.* INTO g_pmk.* 
        FROM pmk_file
        WHERE pmk01=tm.pmk01 AND pmkacti='Y'
    IF SQLCA.sqlcode THEN
        LET g_errno = 'mfg3178'
        RETURN
    ELSE
        IF g_pmk.pmk25 NOT MATCHES '[12]' THEN
           LET g_errno='mfg3176'
           RETURN
        END IF
        IF g_pmk.pmkmksg MATCHES '[yY]' AND ( g_pmk.pmksmax > g_pmk.pmksseq )
           THEN  LET g_errno='mfg3177'
                 RETURN
        END IF
 
        SELECT count(*) INTO g_cnt FROM pjf_file
               WHERE pjf01=tm.pjb01
        IF g_cnt=0 THEN LET g_errno = 'mfg3111' RETURN END IF
    END IF
 
    IF g_pmk.pmk09 IS NOT NULL THEN
       SELECT pmc03 INTO g_pmc03  #廠商名稱
         FROM pmc_file
        WHERE pmc01=g_pmk.pmk09
       LET tm.pmk09=g_pmk.pmk09
    END IF
    IF g_pmk.pmk12 IS NOT NULL THEN
       SELECT gen02 INTO l_gen02  #員工姓名
         FROM gen_file
        WHERE gen01=g_pmk.pmk12
       LET tm.pmk12=g_pmk.pmk12
    END IF
    LET tm.pmk22=g_pmk.pmk22
    DISPLAY g_pmk.pmk09 TO FORMONLY.pmk09
    DISPLAY g_pmc03     TO FORMONLY.pmc03
    DISPLAY g_pmk.pmk12 TO FORMONLY.pmk12
    DISPLAY l_gen02     TO FORMONLY.gen02
    DISPLAY g_pmk.pmk22 TO FORMONLY.pmk22
END FUNCTION
 
FUNCTION p500_pmk09()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05,
          l_pmc22     LIKE pmc_file.pmc22
 
   LET g_errno=' '
   SELECT pmcacti,pmc05,pmc03,pmc22 INTO l_pmcacti,l_pmc05,g_pmc03,l_pmc22
     FROM pmc_file
    WHERE pmc01=tm.pmk09
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
                                LET g_pmc03=NULL
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'    #No.FUN-690024
         
        WHEN l_pmc05='0'        LET g_errno='aap-032'      #No.FUN-690025
                                LET g_pmc03=NULL           #No.FUN-690025
        WHEN l_pmc05='3'        LET g_errno='aap-033'      #No.FUN-690025
                                LET g_pmc03=NULL           #No.FUN-690025
 
  END CASE
   DISPLAY g_pmc03 TO FORMONLY.pmc03
   IF tm.pmk22 IS NULL THEN
      LET tm.pmk22 = l_pmc22
      DISPLAY BY NAME tm.pmk22
   END IF
END FUNCTION
 
FUNCTION p500_pmk22()  #幣別
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = " "
   SELECT aziacti INTO l_aziacti FROM azi_file
    WHERE azi01 = tm.pmk22
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION p500_pmk12()  #人員
         DEFINE l_gen02     LIKE gen_file.gen02,
                l_genacti   LIKE gen_file.genacti
 
	  LET g_errno = ' '
	  SELECT gen02,gen03,genacti INTO l_gen02,tm.pmk13,l_genacti 
            FROM gen_file WHERE gen01 = tm.pmk12
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gen02 TO FORMONLY.gen02
END FUNCTION
 
FUNCTION p500_pmk13()    #部門
         DEFINE l_gem02     LIKE gem_file.gem02,
                l_gemacti   LIKE gem_file.gemacti
 
	  LET g_errno = ' '
	  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file 
				  WHERE gem01 = tm.pmk13
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          DISPLAY l_gem02 TO FORMONLY.gem02
END FUNCTION 
#No:FUN-9C0071--------精簡程式-----
