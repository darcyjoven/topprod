# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp620.4gl
# Descriptions...: 工單發放作業
# Date & Author..: 91/08/20 By APPLE
# Modify.........: 98/10/23 By Star 拆件式工單型態為 11 非 12
# Modify.........: No:8124 03/09/12 Carol 工單採批次發放時，應扣除已作廢之工單
# Modify.........: NO.FUN-510040 05/02/03 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550067 05/06/01 By Trisy 單據編號放大
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610003 06/01/17 By Nicola Call s_cralc時，多傳一個參數
# Modify.........: No.TQC-640024 06/04/07 By Claire sfb95 傳值時順序調整
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.MOD-680100 06/11/16 By pengu 6201_w畫面的"緊急比率"與"完工日期"內容對應有誤
# Modify.........: No.MOD-680105 06/12/06 By pengu p620_process()中所傳的參數與際sr的順序不合
# Modify.........: No.TQC-730022 07/03/27 By rainy 流程自動化
# Modify.........: No.TQC-830059 08/03/28 By lumx 增加條件當工單有備料的時候才可以工單發放
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-8C0081 09/03/10 By sabrina (1)工單發放時，應判斷該單據是否需走簽核，若要走簽核且簽核未核准，則不可發放
#                                                    (2)若單據不需走簽核，則發放後簽核狀況的狀態碼要更改為〝1：已核准〞
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A30080 10/03/16 By lilingyu 如果沒有符合條件的資料,系統仍然提示"運行成功"
# Modify.........: No:MOD-A10119 10/01/21 By Pengu 發放時未update製程第一站的轉入數量
# Modify.........: No:MOD-B20014 11/02/08 By sabrina 將sfb02!=7條件取消
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50207 11/05/25 By sabrina 用killcr刪除程式裡的^M字元
# Modify.........: No:TQC-B70137 11/08/03 By houlia 使用者退出時顯示運行失敗
# Modify.........: No:MOD-BB0319 11/11/29 By ck2yuan 修改l_cnt筆數累計錯誤
# Modify.........: No.FUN-BC0008 11/12/02 By zhangll s_cralc4整合成s_cralc,s_cralc增加傳參
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-BB0086 12/01/16 By tanxc 數量欄位小數取位
# Modify.........: No:TQC-C30303 12/03/27 By destiny 去掉单位换算逻辑，改为使用ecm62/ecm63
# Modify.........: NO.TQC-C50082 12/05/10 By fengrui 把必要字段controlz換成controlr
# Modify.........: No:MOD-D10057 13/01/08 By bart 修正asfp620更新工單相關欄位時也會update sfb24='Y'
# Modify.........: No:TQC-D70069 13/07/22 By lujh 1.無法ctrl+g 2.幫助按鈕灰色，無法打開help
#                                                 3.“工單單號”，“生產料件”欄位建議增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD                # Print condition RECORD
#                   wc       VARCHAR(300),      # Where condition TQC-630166
                    wc       STRING,         # TQC-630166
                    s        LIKE type_file.chr4,          # Prog. Version..: '5.30.06-13.03.12(04)# Order by sequence
                    c        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 是否需逐一確認
                    f        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                    g        LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
                 END RECORD,
       g_unalc   LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_cnt     LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_rec_b   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i       LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE l_flag    LIKE type_file.chr1          #Print tm.wc ?(Y/N)                 #No.FUN-680121 VARCHAR(1)
 
#TQC-730022 add
DEFINE g_argv1    STRING   #tm.wc
      # g_argv2   LIKE type_file.chr1,#發放採用順序
      # g_argv3   LIKE type_file.chr1,#逐一確認
      # g_argv4   LIKE type_file.chr1,#tm.s
      # g_argv5   LIKE type_file.chr1,#tm.c
      # g_argv6   LIKE type_file.chr1,#tm.f
      # g_argv7   LIKE type_file.chr1,#tm.g
#TQC-730022 end
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
  LET g_argv1 = ARG_VAL(1)  #TQC-730022 add
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #MOD-580222 add  #No.FUN-6A0090 #FUN-BB0047 mark
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_success = 'Y'
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
 
   WHILE TRUE
     #TQC-730022 begin
      IF NOT cl_null(g_argv1) THEN
         LET tm.s    = '1'
         LET tm.c    = 'N'
         LET tm.f    = 'N'
         LET tm.g    = 'N'
         LET tm.wc = g_argv1 
         CALL asfp620_1()            
         EXIT WHILE
      ELSE
     #TQC-730022 end
        CALL asfp620_tm(0,0)            # Read data and create out-file
 
        IF tm.c MATCHES'[yY]' THEN
           OPEN WINDOW asfp6201_w AT 4,2
             WITH FORM "asf/42f/asfp6201"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
           CALL cl_ui_locale("asfp6201")
 
           CALL asfp620_2()            # Read data and create out-file
 
           CLOSE WINDOW asfp6201_w
           ERROR ''
        ELSE
           CALL asfp620_1()            # Read data and create out-file
        END IF
        IF g_success = 'Y' THEN               #TQC-A30080 
           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#TQC-A30080  --begin--           
        ELSE
        	 CALL cl_end2(2) RETURNING l_flag
        END IF 	   
#TQC-A30080  --end--        
 
        IF l_flag THEN
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
      END IF
   END WHILE
 
   CLOSE WINDOW asfp620_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #MOD-580222 add  #No.FUN-6A0090
 
END MAIN
 
FUNCTION asfp620_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd         LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 4
   LET p_col = 20
 
   OPEN WINDOW asfp620_w AT p_row,p_col
     WITH FORM "asf/42f/asfp620"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '1'
   LET tm.c    = 'Y'
   LET tm.f    = 'N'
   LET tm.g    = 'N'
 
   WHILE TRUE
      CLEAR FORM
 
      CONSTRUCT BY NAME tm.wc ON sfb02,sfb01,sfb05,sfb13,sfb15
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #TQC-D70069--add--str--
         ON ACTION controlp
           CASE
              WHEN INFIELD(sfb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb01
                  NEXT FIELD sfb01
              WHEN INFIELD(sfb05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_sfb05_1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb05
                  NEXT FIELD sfb05
              OTHERWISE
                 EXIT CASE
           END CASE

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()
         #TQC-D70069--add--end--
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW asfp620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      DISPLAY BY NAME tm.s,tm.c,tm.f,tm.g     # Condition
 
      INPUT BY NAME tm.s,tm.c,tm.f,tm.g   WITHOUT DEFAULTS
 
         AFTER FIELD c
            IF tm.c NOT MATCHES "[YN]" THEN
               NEXT FIELD c
            END IF
 
         AFTER FIELD f
            IF tm.f NOT MATCHES "[YN]" THEN
               NEXT FIELD f
            END IF
 
         AFTER FIELD g
            IF tm.g NOT MATCHES "[YN]" THEN
               NEXT FIELD g
            END IF
 
         #ON ACTION CONTROLZ   #TQC-C50082 mark
         ON ACTION CONTROLR    #TQC-C50082 add
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #TQC-D70069--add--str--
         ON ACTION help
            CALL cl_show_help()
         #TQC-D70069--add--end--

      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW asfp620_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      EXIT WHILE
      ERROR ""
   END WHILE
 
END FUNCTION
 
FUNCTION asfp620_1()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT TQC-630166        #No.FUN-680121 VARCHAR(600)
          l_sql     STRING,          # TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         l_order   ARRAY[4] OF VARCHAR(7),
          l_order   ARRAY[4] OF LIKE type_file.chr20, #No.FUN-680121 VARCHAR(20)#TQC-630166
          l_t       LIKE smy_file.smyslip,            # Prog. Version..: '5.30.06-13.03.12(05)#No.FUN-550067
          l_msg     LIKE type_file.chr1000,           #No.FUN-680121 VARCHAR(66)
          l_smykind LIKE type_file.chr1,              #No.FUN-680121 VARCHAR(1)
          sr        RECORD
                       sfb01 LIKE sfb_file.sfb01,
                       sfb02 LIKE sfb_file.sfb02,
                       sfb05 LIKE sfb_file.sfb05,
                       sfb071 LIKE sfb_file.sfb071,
                       sfb08 LIKE sfb_file.sfb08,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb40 LIKE sfb_file.sfb40,
                       sfb06 LIKE sfb_file.sfb06,
                       sfb34 LIKE sfb_file.sfb34,
                       sfb23 LIKE sfb_file.sfb23,
                       sfb24 LIKE sfb_file.sfb24,
                       sfb251 LIKE sfb_file.sfb251,
                       sfb95 LIKE sfb_file.sfb95   #No.TQC-610003 
                    END RECORD
 
  #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
 
   LET l_sql = "SELECT sfb01,sfb02,sfb05,sfb071,sfb08, ",
               "       sfb13,sfb15,sfb40,sfb06,sfb34,  ",
               "       sfb23,sfb24,sfb251,sfb95 ",  #No.TQC-610003  
               "  FROM sfb_file ",
               " WHERE sfb04 = '1' AND sfb87 !='X' AND ", #No:8124 add sfb87 !='X'
              #"       sfb02 != 7  AND sfb02 != 13 AND ",    #MOD-B20014 mark
               "       sfb02 != 13 AND ",                    #MOD-B20014 add
               "       ((sfbmksg = 'Y' and sfb43 = '1') OR sfbmksg = 'N' OR sfbmksg IS NULL) AND ",     #FUN-8C0081 add
               "       sfb23 = 'Y' AND",  #TQC-830059
               " sfbacti ='Y' AND ",tm.wc
 
   PREPARE asfp620_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE asfp620_curs1 CURSOR FOR asfp620_prepare1
 
   CALL cl_outnam('asfp620') RETURNING l_name
 
   START REPORT asfp620_rep TO l_name
 
 
   FOREACH asfp620_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_t=s_get_doc_no(sr.sfb01)        #No.FUN-550067
 
      SELECT smykind INTO l_smykind FROM smy_file
       WHERE smyslip = l_t
         AND smysys = 'asf'
 
      IF l_smykind='5' OR sr.sfb02=13 THEN
         SELECT ze03 INTO l_msg FROM ze_file
          WHERE ze01='mfg9386'
            AND ze02=g_lang
 
         OUTPUT TO REPORT asfp620_rep(sr.sfb01,l_msg)
 
         CONTINUE FOREACH
      END IF
 
      IF sr.sfb23 not matches'[Yy]' AND sr.sfb24 not matches'[Yy]' THEN
         CALL asfp620_process(sr.sfb01,sr.sfb02,sr.sfb05,sr.sfb071,
                              sr.sfb08,sr.sfb13,sr.sfb15,sr.sfb06,
                             #-------No.MOD-680105 modify
                             #sr.sfb23,sr.sfb24,sr.sfb95)   #No.TQC-610003
                              sr.sfb95,sr.sfb23,sr.sfb24)   #No.TQC-610003
                             #-------No.MOD-680105 end
      ELSE
         CALL asfp620_update(sr.sfb01,sr.sfb05,sr.sfb08,sr.sfb02)
      END IF
   END FOREACH
 
   FINISH REPORT asfp620_rep
 
   IF g_success = 'N' THEN
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   END IF
 
  #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
 
END FUNCTION
 
FUNCTION asfp620_2()
   DEFINE l_name      LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8          #No.FUN-6A0090
          l_sql       LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(600)
          l_chr       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order     ARRAY[4] OF LIKE type_file.chr20,#No.FUN-680121 VARCHAR(07)
          g_arrcnt    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_ac,l_cnt  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_cmd       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
          l_sfb06     LIKE sfb_file.sfb06,
          l_sfb23     LIKE sfb_file.sfb23,
          l_sfb24     LIKE sfb_file.sfb24,
          l_sfb251    LIKE sfb_file.sfb251,
          l_t         LIKE smy_file.smyslip,        # Prog. Version..: '5.30.06-13.03.12(05)#No.FUN-550067
          l_smykind   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_msg       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_sfb       DYNAMIC ARRAY OF RECORD
                         sure     LIKE type_file.chr1,      #No.FUN-680121 VARCHAR(1)
                         sfb01    LIKE sfb_file.sfb01,      #工單編號
                         sfb05    LIKE sfb_file.sfb05,      #料件編號
                        #--------No.MOD-680100 modify
                         sfb95    LIKE sfb_file.sfb95,      #No.TQC-640024
                         sfb02    LIKE sfb_file.sfb02,      #型態
                         sfb40    LIKE sfb_file.sfb40,      #優先比率
                         sfb13    LIKE sfb_file.sfb13,      #開工日期
                         sfb08    LIKE sfb_file.sfb08,      #生產數量
                         sfb071   LIKE sfb_file.sfb071,     #BOM 有效日
                         sfb34    LIKE sfb_file.sfb34,      #緊急比率
                         sfb15    LIKE sfb_file.sfb15,      #完工日期
                         ima55    LIKE ima_file.ima55       #生產單位
                        #--------No.MOD-680100 end
                      END RECORD
 
  #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
 
  #-----No.MOD-680100 modify
  #LET l_sql = "SELECT '',sfb01,sfb05,sfb02,sfb071,sfb40,sfb34, ",
  #            "       sfb13,sfb15,sfb08,ima55,sfb95,sfb251 ",  #No.TQC-640024
  #           #"       sfb13,sfb15,sfb08,ima55,sfb251,sfb95 ",  #No.TQC-610003  #TQC-640024 mark
   LET l_sql = "SELECT '',sfb01,sfb05,sfb95,sfb02,sfb40,sfb13, ",
               "       sfb08,sfb071,sfb34,sfb15,ima55,sfb251 ",  
  #-----No.MOD-680100 
               "  FROM sfb_file,ima_file ",
               " WHERE sfb04 = '1' AND sfbacti ='Y' AND ",
              #" sfb02 !=7 AND sfb02 != 13 AND ",    #MOD-B20014 mark
               " sfb02 != 13 AND ",                  #MOD-B20014 add
               "       ((sfbmksg = 'Y' and sfb43 = '1') OR sfbmksg = 'N' OR sfbmksg IS NULL) AND ",     #FUN-8C0081 add
               " sfb05 = ima01 AND sfb87 !='X' AND ", tm.wc CLIPPED  #No:8124 add sfb
 
   PREPARE p620_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   DECLARE p620_curs2 CURSOR FOR p620_prepare2
 
   WHILE TRUE
      LET g_arrcnt= 40
      FOR g_cnt=1 TO g_arrcnt
         INITIALIZE l_sfb[g_cnt].* TO NULL
      END FOR
      LET g_rec_b=0
      LET g_cnt=1                                         #總選取筆數
 
      FOREACH p620_curs2 INTO l_sfb[g_cnt].*,l_sfb251   #逐筆抓出
         IF SQLCA.sqlcode THEN                                  #有問題
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
 
         LET l_sfb[g_cnt].sure='N'
         LET l_t=s_get_doc_no(l_sfb[g_cnt].sfb01)        #No.FUN-550067
 
         SELECT smykind INTO l_smykind FROM smy_file
          WHERE smyslip=l_t AND smysys='asf'
 
         IF l_smykind='5' OR l_sfb[g_cnt].sfb02=13 THEN
            CALL cl_err(l_sfb[g_cnt].sfb01,'mfg9386',1)
            CONTINUE FOREACH
         END IF
 
         LET g_cnt = g_cnt + 1                           #累加筆數
         IF g_cnt > g_arrcnt THEN                         #超過肚量了
            CALL cl_err('','9035',0)
            EXIT FOREACH
         END IF
      END FOREACH
 
      IF g_cnt=1 THEN                                     #沒有抓到
         CALL cl_err('','asf-332',1)                     #顯示錯誤, 並回去
         LET g_success = 'N'                             #TQC-A30080 
         EXIT WHILE
      END IF
      CALL l_sfb.deleteElement(g_cnt)                    #TQC-630166
      LET g_cnt=g_cnt-1                                   #正確的總筆數
      LET g_rec_b=g_cnt
#     DISPLAY g_cnt TO FORMONLY.cn3  #顯示總筆數
      DISPLAY g_cnt TO FORMONLY.cn2  #顯示總筆數         #TQC-630166
      LET l_cnt=0
 
 #顯示並進行選擇
      DISPLAY ARRAY l_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
     END DISPLAY
         #MOD-860081------add-----end---
 
      INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
         BEFORE INPUT
            LET l_ac = ARR_CURR()
 
         #AFTER FIELD sure                       #MOD-BB0319 mark
         ON CHANGE sure                          #MOD-BB0319 add
            LET l_ac = ARR_CURR()                #MOD-BB0319 add
            IF l_sfb[l_ac].sure ='Y' THEN
              LET l_cnt=l_cnt+1                 #累加已選筆數
            ELSE
               LET l_cnt=l_cnt-1                   #減少已選筆數
            END IF
            DISPLAY l_cnt TO FORMONLY.cn2
 
         ON ACTION qry_wo  #查詢工單明細
            LET l_ac = ARR_CURR()
            LET l_cmd="asfi301 '",l_sfb[l_ac].sfb01,"' "
            CALL cl_cmdrun(l_cmd)
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         #TQC-D70069--add--str--
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION help
            CALL cl_show_help()
         #TQC-D70069--add--end--
      END INPUT
 
      CALL cl_set_act_visible("accept,cancel", TRUE)
 
      IF INT_FLAG THEN #使用者中斷
         LET INT_FLAG = 0
         LET g_success = 'N'     #TQC-B70137
         EXIT WHILE
      END IF
 
      IF l_cnt < 1 THEN                               #已選筆數超過 0筆
         EXIT WHILE
      END IF
 
      CALL cl_wait()
 
      CALL cl_outnam('asfp620') RETURNING l_name
 
      START REPORT asfp620_rep TO l_name
 
      FOR l_ac=1 TO g_cnt
         IF l_sfb[l_ac].sure='Y' THEN          #該單據要結案
            SELECT sfb23,sfb24,sfb06
              INTO l_sfb23,l_sfb24,l_sfb06 FROM sfb_file
             WHERE sfb01 = l_sfb[l_ac].sfb01
            CALL asfp620_process(l_sfb[l_ac].sfb01,l_sfb[l_ac].sfb02,
                                 l_sfb[l_ac].sfb05,l_sfb[l_ac].sfb071,
                                 l_sfb[l_ac].sfb08,l_sfb[l_ac].sfb13,
                                #-------No.MOD-680105 modify
                                #l_sfb[l_ac].sfb15,l_sfb06,l_sfb23,l_sfb24,
                                #l_sfb[l_ac].sfb95)   #No.TQC-610003
                                 l_sfb[l_ac].sfb15,l_sfb06,l_sfb[l_ac].sfb95,
                                 l_sfb23,l_sfb24)
                                #-------No.MOD-680105 end
         END IF
      END FOR
 
      FINISH REPORT asfp620_rep
 
      IF g_success = 'N' THEN
         CALL cl_prt(l_name,g_prtway,g_copies,g_len)
      END IF
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0090
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION asfp620_process(sr,p_sfb23,p_sfb24)
 DEFINE sr               RECORD sfb01 LIKE sfb_file.sfb01,
                                sfb02 LIKE sfb_file.sfb02,
                                sfb05 LIKE sfb_file.sfb05,
                                sfb071 LIKE sfb_file.sfb071,
                                sfb08 LIKE sfb_file.sfb08,
                                sfb13 LIKE sfb_file.sfb13,
                                sfb15 LIKE sfb_file.sfb15,
                                sfb06 LIKE sfb_file.sfb06,
                                sfb95 LIKE sfb_file.sfb95  #No.TQC-610003
                        END RECORD,
        l_minopseq LIKE ecb_file.ecb03,
        p_sfb23    LIKE sfb_file.sfb23,
        p_sfb24    LIKE sfb_file.sfb24,
        l_strtdat,l_duedat         LIKE type_file.dat,           #No.FUN-680121 DATE
        l_error                    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_type,l_track,l_flag      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_pt                       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_msg                      LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(66)
 
   IF sr.sfb02= 5 OR sr.sfb02 = 11 THEN  #拆件式及再加工工單無製程可
      LET g_success = 'N'
 
      SELECT ze03 INTO l_msg FROM ze_file
       WHERE ze01='asf-355'
         AND ze02=g_lang
 
      #BugNO:4783拆件式及再加工工單無製程!
      OUTPUT TO REPORT asfp620_rep(sr.sfb01,l_msg)
   ELSE
     IF p_sfb24 = 'N' AND g_sma.sma26<>'1' THEN
        CALL s_schdat(0,sr.sfb13,sr.sfb15,sr.sfb071,
                      sr.sfb01,sr.sfb06,sr.sfb02,
                      sr.sfb05,sr.sfb08,'1')
            RETURNING l_error,l_strtdat,l_duedat,l_type,l_track
        IF l_error < 0 THEN
            #No.+109 010516 mark by linda 不再重給g_errno值,因s_schdat有給
           #CASE  l_error
           #   WHEN  -1   LET g_errno = 'asf-323'
           #   WHEN  -2   LET g_errno = 'asf-324'
           #   WHEN  -4   LET g_errno = 'asf-325'
           #   WHEN  -99  LET g_errno = 'asf-016'
           #   WHEN  -9   LET g_errno = 'asf-326'
           #   WHEN  -10  LET g_errno = 'asf-327'
           #   WHEN  -5   LET g_errno = 'asf-328'
           #   OTHERWISE  LET g_errno = 'asf-329'
           #END CASE
            #No.+109 end-----
            LET g_success = 'N'
            SELECT ze03 INTO l_msg FROM ze_file
             WHERE ze01=g_errno
               AND ze02=g_lang
 
            OUTPUT TO REPORT asfp620_rep(sr.sfb01,l_msg)
        ELSE
       # produce W/O Loading file --> Keith
           IF g_sma.sma26='3' THEN
              CALL s_wccap(sr.sfb01) RETURNING l_pt
              IF l_pt THEN
                 CALL cl_err(sr.sfb01,'asf-473',1)
              END IF
           END IF
        END IF
     END IF
   END IF
 
   IF p_sfb23 NOT MATCHES '[Yy]' OR p_sfb23 IS NULL THEN
      CALL s_minopseq(sr.sfb05,sr.sfb06,sr.sfb071)
            RETURNING l_minopseq
 
     #-------------No.FUN-670041 modify
     #CALL s_cralc(sr.sfb01,sr.sfb02,sr.sfb05,g_sma.sma29,sr.sfb08,
      CALL s_cralc(sr.sfb01,sr.sfb02,sr.sfb05,'Y',sr.sfb08,
     #-------------No.FUN-670041 end
                  #sr.sfb071,'Y',g_sma.sma71,l_minopseq,sr.sfb95)  #No.TQC-610003
                   sr.sfb071,'Y',g_sma.sma71,l_minopseq,'',sr.sfb95)  #No.TQC-610003   #FUN-BC0008 mod
         RETURNING g_unalc
 
      IF NOT g_unalc THEN
         LET g_success = 'N'
         SELECT ze03 INTO l_msg FROM ze_file
          WHERE ze01=g_errno
            AND ze02=g_lang
 
         OUTPUT TO REPORT asfp620_rep(sr.sfb01,l_msg)
      END IF
   END IF
 
   IF g_unalc OR p_sfb23 MATCHES '[Yy]' THEN
      CALL asfp620_update(sr.sfb01,sr.sfb05,sr.sfb08,sr.sfb02)
   END IF
 
END FUNCTION
 
FUNCTION asfp620_update(p_sfb01,p_part,p_qty,p_sfb02)
   DEFINE p_sfb01   LIKE sfb_file.sfb01,
          p_part    LIKE sfb_file.sfb05,
          p_qty     LIKE sfb_file.sfb08,
          p_sfb02   LIKE sfb_file.sfb02,
          l_msg     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(66)

  #----------------------No:MOD-A10119 add
   DEFINE l_sfb93   LIKE sfb_file.sfb93
   DEFINE l_sfb08   LIKE sfb_file.sfb08
   DEFINE l_ecm03   LIKE ecm_file.ecm03
   DEFINE l_ecm57   LIKE ecm_file.ecm57 
   DEFINE l_ecm62   LIKE ecm_file.ecm62  #TQC-C30303
   DEFINE l_ecm63   LIKE ecm_file.ecm63  #TQC-C30303
   DEFINE l_ecm301  LIKE ecm_file.ecm301
   DEFINE l_ima55   LIKE ima_file.ima55
   DEFINE l_flag    LIKE type_file.chr1
   DEFINE l_factor  LIKE ima_file.ima55_fac
   DEFINE l_sql     LIKE type_file.chr1   #No.FUN-BB0086
   DEFINE l_ecm12   LIKE ecm_file.ecm12   #No.FUN-BB0086
   DEFINE l_ecm58   LIKE ecm_file.ecm58   #No.FUN-BB0086
   DEFINE l_cnt     LIKE type_file.num5  #MOD-D10057
   DEFINE l_sfb24   LIKE sfb_file.sfb24  #MOD-D10057
   
   LET l_sfb93 = NULL
   LET l_sfb08 = 0
   SELECT sfb08,sfb93 INTO l_sfb08,l_sfb93 FROM sfb_file WHERE sfb01 = p_sfb01
   IF l_sfb93='Y' THEN
      LET l_ecm03=0
      SELECT MIN(ecm03) INTO l_ecm03
        FROM ecm_file
       WHERE ecm01=p_sfb01
      IF STATUS THEN LET l_ecm03=0 END IF
      IF cl_null(l_ecm03) OR l_ecm03 = 0 THEN 
         LET g_success ='N'  
         LET l_msg = cl_getmsg('adf-349',g_lang)
         OUTPUT TO REPORT asfp620_rep(p_sfb01,l_msg)
         RETURN 
      END IF
#TQC-C30303--begin
#     #---------------- 單位換算
#     SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=p_part
#     IF STATUS THEN LET l_ima55=' ' END IF
#     SELECT ecm57 INTO l_ecm57 FROM ecm_file WHERE ecm01=p_sfb01
#                                               AND ecm03=l_ecm03
#     IF STATUS THEN LET l_ecm57=' ' END IF
#     CALL s_umfchk(p_part,l_ima55,l_ecm57)
#          RETURNING l_flag,l_factor       
#     IF l_flag=1 THEN
#        LET g_success ='N'  
#        LET l_msg = cl_getmsg('abm-731',g_lang)
#        OUTPUT TO REPORT asfp620_rep(p_sfb01,l_msg)
#        RETURN  
#     END IF
#     LET l_ecm301 = l_sfb08*l_factor  
      SELECT ecm62,ecm63 INTO l_ecm62,l_ecm63 FROM ecm_file WHERE ecm01=p_sfb01
                                                              AND ecm03=l_ecm03

      LET l_ecm301 = l_sfb08*l_ecm62/l_ecm63     
#TQC-C30303--end 
      #No.FUN-BB0086---add--start--
      LET l_sql = "SELECT ecm12,ecm58 FROM ecm_file ",
                  " WHERE ecm01='",p_sfb01,"'",
                  "   AND ecm03='",l_ecm03,"'"
      PREPARE p620_pre FROM l_sql
      DECLARE p620_cs CURSOR FOR p620_pre
      FOREACH p620_cs INTO l_ecm12,l_ecm58
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            RETURN FALSE
         END IF
      LET l_ecm301 = s_digqty(l_ecm301,l_ecm58)
      UPDATE ecm_file SET ecm301=l_ecm301
       WHERE ecm01=p_sfb01 
         AND ecm03=l_ecm03
         AND ecm12=l_ecm12
      IF STATUS THEN
         LET g_success='N'
         LET l_msg = cl_getmsg('asf-721',g_lang)
         OUTPUT TO REPORT asfp620_rep(p_sfb01,l_msg)
         RETURN  
      END IF
      END FOREACH    
      #No.FUN-BB0086---add--end--

      #No.FUN-BB0086---mark--start--
      #SELECT ecm58 INTO l_ecm58 FROM ecm_file WHERE       
      #UPDATE ecm_file SET ecm301=l_ecm301
      #   WHERE ecm01=p_sfb01 AND ecm03=l_ecm03
      #IF STATUS THEN
      #   LET g_success='N'
      #   LET l_msg = cl_getmsg('asf-721',g_lang)
      #   OUTPUT TO REPORT asfp620_rep(p_sfb01,l_msg)
      #   RETURN  
      #END IF
      #No.FUN-BB0086---mark--end--
   END IF

  #----------------------No:MOD-A10119 end
   #MOD-D10057---begin
   LET l_cnt=0
   SELECT count(*) INTO l_cnt FROM ecm_file WHERE ecm01 = p_sfb01                                                       
   IF l_cnt > 0 THEN LET l_sfb24 = 'Y' ELSE LET l_sfb24 = 'N' END IF 
   #MOD-D10057---end
   
   UPDATE sfb_file SET sfb04 = '2',
                       sfb251 = g_today,
                       sfb23 = 'Y',
                       #sfb24 = 'Y', #MOD-D10057
                       sfb24 = l_sfb24, #MOD-D10057
                       sfb87 = 'Y',
                       sfb43 = '1'      #FUN-8C0081 add
    WHERE sfb01 = p_sfb01
 
   IF SQLCA.sqlcode != 0 THEN
      LET g_success = 'N'
 
      SELECT ze03 INTO l_msg FROM ze_file
       WHERE ze01='asf-330'
         AND ze02=g_lang
 
      OUTPUT TO REPORT asfp620_rep(p_sfb01,l_msg)
   END IF
 
END FUNCTION
 
REPORT asfp620_rep(p_sfb01,p_msg)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          p_sfb01      LIKE sfb_file.sfb01,
          p_msg        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(66)
          l_chr        LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line   #No.MOD-580242
 
#  ORDER BY sr.sfb01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED, pageno_total
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
         PRINT ' '
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      ON EVERY ROW
         PRINT COLUMN g_c[31],p_sfb01,
               COLUMN g_c[32],p_msg
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
            CALL cl_wcchp(tm.wc,'sfb02,sfb01,sfb05')
                RETURNING tm.wc
            PRINT g_dash[1,g_len]
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#           IF tm.wc[001,070] > ' ' THEN            # for 80
#              PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED
#           END IF
#           IF tm.wc[071,140] > ' ' THEN
#              PRINT COLUMN 10,tm.wc[071,140] CLIPPED
#           END IF
#           IF tm.wc[141,210] > ' ' THEN
#              PRINT COLUMN 10,tm.wc[141,210] CLIPPED
#           END IF
#           IF tm.wc[211,280] > ' ' THEN
#              PRINT COLUMN 10,tm.wc[211,280] CLIPPED
#           END IF
#TQC-630166-end
         END IF
         PRINT g_dash[1,g_len]
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
         LET l_last_sw = 'y'
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4] CLIPPED ,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
#MOD-B50207
