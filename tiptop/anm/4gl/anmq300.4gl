# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: anmq300.4gl
# Descriptions...: 銀行存款異動記錄查詢
# Date & Author..: 92/05/14 By Jones
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
#
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: No.MOD-5B0104 05/11/11 By Smapmin 新增報表列印功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670067 06/07/21 By flowld voucher型報表轉template1
# Modify.........: No.FUN-680034 06/08/16 By flowld 兩套帳修改及alter table -- ANM模塊,前端基礎數據,融資
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/23 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740058 07/04/13 By Judy 匯出EXCEl多一行空白列
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-780011 07/08/15 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-840078 08/06/19 By xiaofeizhu 單身新增欄位“參考單號nme12”和“存提別nmc03”
# Modify.........: No.FUN-870031 08/07/09 By Sarah 銀行編號nma01增加開窗功能
# Modify.........: No.MOD-890242 08/10/01 By Sarah 1.查詢時在單身下條件,查出來的資料並沒針對單身下的條件去過濾
#                                                  2.報表列印出來的資料與查詢出來的結果不同
# Modify.........: NO.FUN-870037 08/10/06 by yiting add nme26
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A20079 10/02/22 By wujie 单身增加会计日期栏位，增加传票号码，增加对叁考单号的串查功能
# Modify.........: No:CHI-A90005 10/10/06 By Summer 抓取傳票號碼
# Modify.........: No:MOD-B40057 11/04/08 By Sarah nme12原本串npo03改成串npn01
# Modify.........: No:MOD-B50085 11/05/11 By Dido nme12原本串npm03改成串npl01
# Modify.........: No:FUN-B50141 11/05/27 By zhangweib 單身添加nme28,nme29兩個欄位 aoos010 參數設定aza26 = 'Y' AND aza73 = 'Y'時才顯示
# Modify.........: No:MOD-BB0303 11/11/29 By Dido 列印段邏輯調整 
# Modify.........: No.MOD-C20201 12/02/23 By Polly 列印段邏輯調整
# Modify.........: No.TQC-C70120 12/07/19 By lujh 列印出的報表中合計的部份是將將存入和取出的金額直接做加總，
#                                                 沒有什麼意義，建議合計欄位數據應是加存入減取出。
# Modify.........: No.MOD-C70218 12/08/03 By Elise 增加抓取 nmc03 傳入報表中 
# Modify.........: No.MOD-CC0083 12/12/12 By Polly 調整變數清空方式
# Modify.........: No.CHI-C80041 12/12/19 By bart 排除作廢
# Modify.........: No.MOD-D50167 13/05/20 By yinhy 增加aapt332憑證編號顯示
# Modify.........: No.FUN-D40121 13/06/27 By lujh  增加傳參

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm    RECORD
               wc  	STRING,#No.FUN-680107 VARCHAR(600) # Head Where condition #MOD-BB0303 mod 1000 -> STRING
       	       wc2  	STRING #No.FUN-680107 VARCHAR(600) # Body Where condition #MOD-BB0303 mod 1000 -> STRING
          END RECORD,
    g_nme DYNAMIC ARRAY OF RECORD
               nme02	LIKE nme_file.nme02,
               nme16    LIKE nme_file.nme16,                            #No.MOD-A20079                      
               nme12    LIKE nme_file.nme12,                            # FUN-840078           
               voucher  LIKE aba_file.aba01,                            # No.MOD20079
               flag     LIKE type_file.chr20,                           #No.MOD-A20079
               nmc03    LIKE nmc_file.nmc03,                            # FUN-840078
               nme03	LIKE nme_file.nme03,
               nmc02    LIKE nmc_file.nmc02,
               nme04	LIKE nme_file.nme04,
               nme07	LIKE nme_file.nme07,
               nme08	LIKE nme_file.nme08,   #No:9465
               nme06	LIKE nme_file.nme06,
               nme061   LIKE nme_file.nme061,  #No.FUN-680034
               nme26    LIKE nme_file.nme26    #FUN-870037
              ,nme28    LIKE nme_file.nme28,   #FUN-B50141   Add
               nme29    LIKE nme_file.nme29    #FUN-B50141   Add
            END RECORD,
    g_nma   RECORD
	       nma01    LIKE nma_file.nma01,   #銀行編號
	       nma02    LIKE nma_file.nma02,   #銀行名稱
	       nma04    LIKE nma_file.nma04,   #銀行帳號
               nma10    LIKE nma_file.nma10    #Curr
            END RECORD,
    g_argv1             LIKE nme_file.nme01,   # INPUT ARGUMENT - 1
    g_wc,g_wc2,g_sql    string,                #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5    #單身筆數  #No.FUN-680107 SMALLINT
 
 
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_i            LIKE type_file.num5    #MOD-5B0104  #No.FUN-680107 SMALLINT
DEFINE   lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE   g_str          STRING                 #No.FUN-780011
DEFINE   l_ac           LIKE type_file.num5    #No.MOD-A20079  
DEFINE   g_alc02  DYNAMIC ARRAY OF LIKE alc_file.alc02 #CHI-A90005 add
DEFINE   l_table        STRING      #TQC-C70120  add
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0082
DEFINE      l_sl	 	LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   OPTIONS                                     #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
   LET tm.wc2       = ARG_VAL(2)          #FUN-D40121 add
   LET tm.wc2       = cl_replace_str(tm.wc2, "\\\"", "'")  #FUN-D40121 add
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q300_w AT p_row,p_col
        WITH FORM "anm/42f/anmq300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("nme061",g_aza.aza63 = 'Y')   # No.FUN-680034  
    CALL cl_set_comp_visible("nme28,nme29",g_aza.aza26 != '2' AND g_aza.aza73 = 'Y')   #FUN-B50141   Add
#   IF cl_chk_act_auth() THEN
#      CALL q300_q()
#   END IF
    IF NOT cl_null(g_argv1) OR NOT cl_null(tm.wc2) THEN CALL q300_q() END IF   #FUN-D40121 add
    CALL q300_menu()
    CLOSE WINDOW q300_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
#QBE 查詢資料
FUNCTION q300_cs()
   DEFINE   l_cnt LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF NOT cl_null(g_argv1) OR NOT cl_null(tm.wc2) THEN   #FUN-D40121 add
      #FUN-D40121--add--str--
      IF cl_null(g_argv1) THEN
         LET tm.wc = "1=1"
      ELSE
      #FUN-D40121--add--end--
         LET tm.wc = "nma01 = '",g_argv1,"'"
      END IF                     #FUN-D40121 add
      IF cl_null(tm.wc2) THEN    #FUN-D40121 add
         LET tm.wc2=" 1=1 "     #單身不CONSTRUCT 條件
      END IF                     #FUN-D40121 add
   ELSE
      CLEAR FORM #清除畫面
      CALL g_nme.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
      INITIALIZE g_nma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON nma01 # 螢幕上取單頭條件
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
        #str FUN-870031 add
         ON ACTION controlp
            CASE
               WHEN INFIELD(nma01)   #銀行編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nma01
                  NEXT FIELD nma01
            END CASE
        #end FUN-870031 add
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET tm.wc = tm.wc clipped," AND nmauser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET tm.wc = tm.wc clipped," AND nmagrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
      #      END IF
      #      IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
      #         LET tm.wc = tm.wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
      #End:FUN-980030
 
      CALL q300_b_askkey()             # CONSTRUCT BODY S.Q.L.
      IF INT_FLAG THEN RETURN END IF
   END IF
 
  #str MOD-890242 mod
  #LET g_sql=" SELECT UNIQUE nma01 FROM nma_file ",
  #          " WHERE ",tm.wc CLIPPED,
  #          " ORDER BY 1 "
   IF tm.wc2 = " 1=1" THEN               # 若單身未輸入條件
      LET g_sql=" SELECT UNIQUE nma01 FROM nma_file ",
                " WHERE ",tm.wc CLIPPED,
                " ORDER BY 1 "
   ELSE                         # 若單身有輸入條件
      LET g_sql=" SELECT UNIQUE nma01 FROM nma_file,nme_file ",
                " WHERE nma01 = nme01",
                " AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
                " ORDER BY 1"
   END IF
  #end MOD-890242 mod
 
   PREPARE q300_prepare FROM g_sql
   DECLARE q300_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q300_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
  #str MOD-890242 mod
  #LET g_sql=" SELECT COUNT(UNIQUE nma01) FROM nma_file ",
  #           " WHERE ",tm.wc CLIPPED
   IF tm.wc2 = " 1=1" THEN               # 若單身未輸入條件
      LET g_sql=" SELECT COUNT(UNIQUE nma01) FROM nma_file ",
                " WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql=" SELECT COUNT(UNIQUE nma01) FROM nma_file,nme_file ",
                " WHERE nma01 = nme01",
                " AND ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED
   END IF
  #end MOD-890242 mod
   PREPARE q300_pp  FROM g_sql
   DECLARE q300_cnt   CURSOR FOR q300_pp
END FUNCTION
 
FUNCTION q300_b_askkey()
#  DISPLAY "[          ]" AT 10,1
   #CONSTRUCT tm.wc2 ON nme02,nme12,nme03,nme04,nme07,nme08,nme06,nme061     #No.FUN-680034   add nme061 #FUN-840078 Add nme12
#  CONSTRUCT tm.wc2 ON nme02,nme12,nme03,nme04,nme07,nme08,nme06,nme061,nme26     #No.FUN-680034   add nme061 #FUN-840078 Add nme12  #FUN-870037 add nme26
   CONSTRUCT tm.wc2 ON nme02,nme16,nme12,nme03,nme04,nme07,nme08,nme06,nme061,nme26     #No.FUN-680034   add nme061 #FUN-840078 Add nme12  #FUN-870037 add nme26   MOD-A20079 add nme16
#       FROM s_nme[1].nme02,s_nme[1].nme12,s_nme[1].nme03,s_nme[1].nme04,  #No.FUN-840078 Add s_nme[1].nme12
        FROM s_nme[1].nme02,s_nme[1].nme16,s_nme[1].nme12,s_nme[1].nme03,s_nme[1].nme04,  #No.FUN-840078 Add s_nme[1].nme12     #No.MOD-A20079
             s_nme[1].nme07,s_nme[1].nme08,s_nme[1].nme06,s_nme[1].nme061,   #No.FUN-680034   add s_nme[1].nme061
             s_nme[1].nme26  #FUN-870037
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
#  DISPLAY "" AT 10,1
END FUNCTION
 
FUNCTION q300_menu()
   DEFINE l_npl01 LIKE npl_file.npl01 #CHI-A90005 add
   DEFINE l_npn01 LIKE npn_file.npn01 #CHI-A90005 add
 
   WHILE TRUE
      CALL q300_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_argv1= NULL   #FUN-D40121 add 
               LET tm.wc2 = NULL   #FUN-D40121 add
               CALL q300_q()
            END IF
#MOD-5B0104
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q300_out()
            END IF
#END MOD-5B0104
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nme),'','')
            END IF
#No.MOD-A20079 --begin                                                          
         WHEN "nme12_qry"                                                       
            #CHI-A90005 add --start--
            CASE g_nme[l_ac].flag
               WHEN 'aapt741'
                  LET g_msg = g_nme[l_ac].flag CLIPPED," ",g_nme[l_ac].nme12 CLIPPED," ",g_alc02[l_ac]
                  CALL cl_cmdrun(g_msg)
               WHEN 'anmt150'
                 #SELECT npl01 INTO l_npl01 FROM npl_file,npm_file    #MOD-B50085 mark
                 # WHERE npm01 = npl01 AND npm03 = g_nme[l_ac].nme12  #MOD-B50085
                 #-MOD-B50085-add-
                  SELECT npl01 INTO l_npl01 
                    FROM npl_file
                   WHERE npl01 = g_nme[l_ac].nme12
                 #-MOD-B50085-end-
                  IF NOT cl_null(l_npl01) THEN
                     LET g_msg = g_nme[l_ac].flag CLIPPED," ",l_npl01
                     CALL cl_cmdrun(g_msg)
                  END IF
               WHEN 'anmt250'
                 #str MOD-B40057 mod
                 #SELECT npn01 INTO l_npn01 FROM npn_file,npo_file
                 # WHERE npn01 = npo01 AND npo03 = g_nme[l_ac].nme12
                  SELECT npn01 INTO l_npn01 FROM npn_file
                   WHERE npn01 = g_nme[l_ac].nme12
                 #end MOD-B40057 mod
                  IF NOT cl_null(l_npn01) THEN
                     LET g_msg = g_nme[l_ac].flag CLIPPED," ",l_npn01
                     CALL cl_cmdrun(g_msg)
                  END IF
               OTHERWISE
            #CHI-A90005 add --end--
               LET g_msg = g_nme[l_ac].flag CLIPPED," ",g_nme[l_ac].nme12          
               CALL cl_cmdrun(g_msg)                                               
            END CASE #CHI-A90005 add
#No.MOD-A20079 --end 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q300_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q300_cnt
       FETCH q300_cnt INTO g_row_count
       DISPLAY g_row_count TO cnt
       CALL q300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION q300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式   #No.FUN-680107 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數 #No.FUN-680107 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q300_cs INTO g_nma.nma01
        WHEN 'P' FETCH PREVIOUS q300_cs INTO g_nma.nma01
        WHEN 'F' FETCH FIRST    q300_cs INTO g_nma.nma01
        WHEN 'L' FETCH LAST     q300_cs INTO g_nma.nma01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q300_cs INTO g_nma.nma01
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
               INITIALIZE g_nma.* TO NULL  #TQC-6B0105
               RETURN
            END IF
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
	SELECT nma02,nma04,nma10 INTO g_nma.nma02,g_nma.nma04 ,g_nma.nma10
	  FROM nma_file
	  WHERE nma01 = g_nma.nma01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)  #FUN-660148
        CALL cl_err3("sel","nma_file",g_nma.nma01,"",SQLCA.sqlcode,"","",0) #FUN-660045
        RETURN
    END IF
 
    CALL q300_show()
END FUNCTION
 
FUNCTION q300_show()
   DISPLAY BY NAME g_nma.nma01,g_nma.nma02,g_nma.nma04,g_nma.nma10
   CALL q300_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q300_b_fill()              #BODY FILL UP
   DEFINE l_sql     STRING #No.FUN-680107 VARCHAR(400) #MOD-BB0303 mod 1000 -> STRING
 
   LET tm.wc2 = cl_replace_str(tm.wc2,"nma01","nme01")   #FUN-D40121 add
   LET l_sql =
#       "SELECT nme02,nme12,'',nme03,'',nme04,nme07,nme08,nme06,nme061,", #No.FUN-680034 add nme061 #No.FUN-840078 Add nme12,''
        "SELECT nme02,nme16,nme12,'','','',nme03,'',nme04,nme07,nme08,nme06,nme061,", #No.FUN-680034 add nme061 #No.FUN-840078 Add nme12,''    MOD-A20079 add nme16,'',''
        "       nme26 ",  #FUN-870037
        "      ,nme28,nme29",   #FUN-B50141   Add
        " FROM  nme_file",
        " WHERE nme01 = '",g_nma.nma01,"' AND ", tm.wc2 CLIPPED,
#       " ORDER BY 1,3 "
        " ORDER BY nme02,nme12,nme03"    #No.MOD-A20079 
    PREPARE q300_pb FROM l_sql
    DECLARE q300_bcs                       #BODY CURSOR
        CURSOR FOR q300_pb
 
   #FOR g_cnt = 1 TO g_nme.getLength()           #單身 ARRAY 乾洗#MOD-CC0083 mark
   #   INITIALIZE g_nme[g_cnt].* TO NULL         #MOD-CC0083 mark
   #END FOR                                      #MOD-CC0083 mark
    CALL g_nme.clear()                           #MOD-CC0083 add
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH q300_bcs INTO g_nme[g_cnt].*
     #  IF g_cnt=1 THEN
     #      LET g_rec_b=SQLCA.SQLERRD[3]  # the number of row processed
     #  END IF
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT nmc03,nmc02 INTO g_nme[g_cnt].nmc03,g_nme[g_cnt].nmc02 FROM nmc_file      #No.FUN-840078 Add nmc03                
        WHERE nmc01 = g_nme[g_cnt].nme03
        IF g_nme[g_cnt].nme04 IS NULL THEN
  	       LET g_nme[g_cnt].nme04 = 0.00
        END IF

       #MOD-C70218---S---
        IF g_nme[g_cnt].nmc03 = '2' THEN
           LET g_nme[g_cnt].nme04 = g_nme[g_cnt].nme04 * -1
           LET g_nme[g_cnt].nme08 = g_nme[g_cnt].nme08 * -1
        END IF
       #MOD-C70218---E---

        CALL q300_voucher()   #No.MOD-A20079  
        LET g_cnt = g_cnt + 1 #筆數累加
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_nme.deleteElement(g_cnt)  #TQC-740058
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nme TO s_nme.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      LET l_ac = ARR_CURR()   #No.MOD-A20079 l_ac free
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
        CALL cl_show_fld_cont()                   #No.FUN-550037
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
#MOD-5B0104
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
#END MOD-5B0104
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530853  --end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------      
#No.MOD-A20079 --begin                                                          
     ON ACTION nme12_qry                                                        
         LET g_action_choice = 'nme12_qry'                                      
         EXIT DISPLAY                                                           
#No.MOD-A20079 --end  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#MOD-5B0104
FUNCTION q300_out()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#         l_time    LIKE type_file.chr8            #No.FUN-6A0082
          l_sql     STRING,        #No.FUN-680107 VARCHAR(3000) #MOD-BB0303 mod 1000 -> STRING
          sr        RECORD
                    nma01   LIKE nma_file.nma01,
                    nma02   LIKE nma_file.nma02,
                    nma10   LIKE nma_file.nma10,
                    nma04   LIKE nma_file.nma04,
                    nme02   LIKE nme_file.nme02,
                    nme03   LIKE nme_file.nme03,
                    nmc02   LIKE nmc_file.nmc02,
                    nmc03   LIKE nmc_file.nmc03,     #TQC-C70120   add
                    nme04   LIKE nme_file.nme04,
                    nme07   LIKE nme_file.nme07,
                    nme08   LIKE nme_file.nme08,
                    nme06   LIKE nme_file.nme06,
                    nme061  LIKE nme_file.nme061,   #No.FUN-680034
                    azi04   LIKE azi_file.azi04,    #TQC-C70120   add
                    azi05   LIKE azi_file.azi05,    #TQC-C70120   add
                    azi07   LIKE azi_file.azi07     #TQC-C70120   add
                    END RECORD
    
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    #TQC-C70120--add--str--
    LET g_sql = "nma01.nma_file.nma01,",
                "nma02.nma_file.nma02,",
                "nma10.nma_file.nma10,",
                "nma04.nma_file.nma04,",
                "nme02.nme_file.nme02,",
                "nme03.nme_file.nme03,",
                "nmc02.nmc_file.nmc02,",
                "nmc03.nmc_file.nmc03,",
                "nme04.nme_file.nme04,",
                "nme07.nme_file.nme07,",
                "nme08.nme_file.nme08,",
                "nme06.nme_file.nme06,",
                "nme061.nme_file.nme061,",
                "azi04.azi_file.azi04,",
                "azi05.azi_file.azi05,",
                "azi07.azi_file.azi07"
  #MOD-C70218---mark-S---  
  # LET l_table = cl_prt_temptable('anmq300',g_sql) CLIPPED
  # IF l_table = -1 THEN
  #    CALL cl_used(g_prog,g_time,2) RETURNING g_time
  #    EXIT PROGRAM
  # END IF
  # CALL cl_del_data(l_table)
  # LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
  #             " VALUES(?,?,?,?,?,  ?,?,?,?,?,",
  #             "        ?,?,?,?,?,  ?)"
  #PREPARE insert_prep FROM g_sql
  #IF STATUS THEN
  #   CALL cl_err('insert_prep:',status,1)
  #   CALL cl_used(g_prog,g_time,2) RETURNING g_time
  #   EXIT PROGRAM
  #END IF
  ##TQC-C70120--add--end--
  #MOD-C70218---mark-E---

# NO.FUN-670067 --start--
#   SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'anmq300'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 100 END IF
# NO.FUN-670067 ---end---
 
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR     # NO.FUN-670067 
#   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR    # NO.FUN-670067
    #No.FUN-780011  --Begin
    LET l_sql = " SELECT nma01,nma02,nma10,nma04,nme02, ",
                "        nme03,nmc02,nmc03,nme04,nme07,nme08, ",       #TQC-C70120  add  nmc03
                "        nme06,nme061,azi04,azi05,azi07 ",  #No.FUN-680034
               #"   FROM nma_file,nme_file,OUTER nmc_file,OUTER azi_file ",          #MOD-890242 mark
               #"   FROM nma_file LEFT OUTER JOIN azi_file ON nma10=azi01,nme_file LEFT OUTER JOIN nmc_file ON nme03=nmc01 ",    #MOD-890242 #MOD-BB0303 mark
               #"   FROM nma_file LEFT OUTER JOIN azi_file ON nma10=azi01 ",                                   #MOD-BB0303 #MOD-C20201 mark
               #"                 LEFT OUTER JOIN (SELECT nme01,nme02,nme03,nme04,nme07,nme08,nme06,nme061 ",  #MOD-BB0303 #MOD-C20201 mark
               #"                                    FROM nme_file ) tma ON tma.nme01 = nma01",                #MOD-BB0303 #MOD-C20201 mark
               #"                                    FROM nme_file WHERE ", tm.wc2 CLIPPED,                    #MOD-C20201 mark 
               #"                                    ) tma ON tma.nme01 = nma01 ",                             #MOD-C20201 mark 
               #"                 LEFT OUTER JOIN (SELECT nmc01,nmc02 FROM nmc_file ) tmb ON tmb.nmc01 = tma.nme03 ", #MOD-BB0303 #MOD-C20201 mark
                "   FROM nma_file LEFT OUTER JOIN azi_file ON nma10=azi01,",           #MOD-C20201 add
                "        nme_file LEFT OUTER JOIN nmc_file ON nme03=nmc01 ",           #MOD-C20201 add 
                "  WHERE nma01=nme01",                                                 #MOD-890242 mark #MOD-C20201 remark
               #"  WHERE 1=1 ",                                                        #MOD-890242 #MOD-C20201 mark
                "    AND ",tm.wc CLIPPED, 
                "    AND ",tm.wc2 CLIPPED    #MOD-890242 add   
  #MOD-C70218---mark--- 
  ##TQC-C70120--add--str-- 
  #PREPARE q300_pre FROM l_sql
  #DECLARE q300_c CURSOR FOR q300_pre
  #FOREACH q300_c INTO sr.*
  #   IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
  #   IF sr.nmc03 = '2' THEN 
  #      LET sr.nme04 = sr.nme04*(-1)
  #      LET sr.nme08 = sr.nme08*(-1)
  #   END IF 
  #   EXECUTE insert_prep USING sr.*
  #END FOREACH   
  #LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  ##TQC-C70120--add--end--
  #MOD-C70218---mark---
   #PREPARE q300_p FROM l_sql
   #DECLARE q300_c CURSOR FOR q300_p
   #CALL cl_outnam('anmq300') RETURNING l_name
   #START REPORT q300_rep TO l_name
   #LET g_pageno=0
   #FOREACH q300_c INTO sr.*
   #  IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
   #  SELECT nmc02 INTO sr.nmc02 FROM nmc_file
   #    WHERE nmc01=sr.nme03
   #  OUTPUT TO REPORT q300_rep(sr.*)
   #END FOREACH

   #FINISH REPORT q300_rep
 
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0082
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'nma01,nme02,nme03,nme04,nme07,nme08,nme06,nme061')
            RETURNING g_str
    END IF
    LET g_str = g_str,";",g_azi04,";",g_azi05
    CALL cl_prt_cs1('anmq300','anmq300',l_sql,g_str)
   #No.FUN-780011  --End  
 
END FUNCTION
 
#No.FUN-780011  --Begin
#REPORT q300_rep(sr)
#  DEFINE  l_last_sw         LIKE type_file.chr1,   #No.FUN-680107CHAR(1)
#          g_head1           LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(100)
#          sr        RECORD
#                    nma01   LIKE nma_file.nma01,
#                    nma02   LIKE nma_file.nma02,
#                    nma10   LIKE nma_file.nma10,
#                    nma04   LIKE nma_file.nma04,
#                    nme02   LIKE nme_file.nme02,
#                    nme03   LIKE nme_file.nme03,
#                    nmc02   LIKE nmc_file.nmc02,
#                    nme04   LIKE nme_file.nme04,
#                    nme07   LIKE nme_file.nme07,
#                    nme08   LIKE nme_file.nme08,
#                    nme06   LIKE nme_file.nme06,
#                    nme061  LIKE nme_file.nme061   #No.FUN-680034
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.nma01,sr.nme02
#  FORMAT
#   PAGE HEADER
#
#     # NO.FUN-670067 --start--
#     #   PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     # NO.FUN-670067 ---end---
#
#        PRINT ' '
#        
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED, pageno_total
#     # NO.FUN-670067 --start--
#     #   PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1];
#         PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2+1,g_x[1]
#     # NO.FUN-670067 ---end---
#
#     # NO.FUN-670067 --start-- 
#     #   PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     #   PRINT ' '
#     #   LET g_pageno= g_pageno+1
#     #   PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#     #         COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#     #   PRINT g_dash
#
#        # LET g_pageno = g_pageno + 1
#        # LET pageno_total = PAGENO USING '<<<',"/pageno"
#        # PRINT g_head CLIPPED, pageno_total
#   
#         PRINT g_dash
#     # NO.FUN-670067 ---end---
#        LET l_last_sw = 'n'
#
#     # NO.FUN-670067 --start--
#     #  PRINT COLUMN 01,g_x[9],sr.nma01,COLUMN 50,g_x[11],sr.nma10
#     #  PRINT COLUMN 01,g_x[10],sr.nma02,COLUMN 50,g_x[12],sr.nma04
#
#        PRINT COLUMN 01,g_x[9],sr.nma01,COLUMN 50,g_x[10],sr.nma10
#        PRINT COLUMN 01,g_x[11],sr.nma02,COLUMN 50,g_x[12],sr.nma04
#     # NO.FUN-670067 ---end---
#
#        PRINT g_dash
#        PRINT ' '
#
#     # NO.FUN-670067 --start--     
#     #  PRINT COLUMN 01,g_x[13],COLUMN 10,g_x[14],COLUMN 17,g_x[15],
#     #        COLUMN 28,g_x[16],COLUMN 48,g_x[17],COLUMN 60,g_x[18],
#     #        COLUMN 80,g_x[19]
#
#        PRINT  g_x[31], g_x[32], g_x[33],
#               g_x[34], g_x[35], g_x[36],
#               g_x[37]
#
#     #    PRINT '-------- ------ ---------- ------------------- ',
#     #         '----------- ------------------- ------------------------'
#
#         PRINT g_dash1
#     # NO.FUN-670067 ---end---
#     
#        BEFORE GROUP OF sr.nma01
#
#        SKIP TO TOP OF PAGE
#
#    ON EVERY ROW
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file
#           WHERE azi01=sr.nma10
#
#     # NO.FUN-670067 --start--
#     #  PRINT COLUMN 01,sr.nme02 CLIPPED,
#     #        COLUMN 10,sr.nme03 CLIPPED,
#     #        COLUMN 17,sr.nmc02 CLIPPED,
#     #        COLUMN 28,cl_numfor(sr.nme04,18,t_azi04) CLIPPED,
#     #        COLUMN 48,cl_numfor(sr.nme07,10,t_azi07) CLIPPED,
#     #        COLUMN 60,cl_numfor(sr.nme08,18,g_azi04) CLIPPED,
#     #        COLUMN 80,sr.nme06 CLIPPED
#      
#        PRINT COLUMN g_c[31],sr.nme02 CLIPPED,
#              COLUMN g_c[32],sr.nme03 CLIPPED,
#              COLUMN g_c[33],sr.nmc02 CLIPPED,
#              COLUMN g_c[34],cl_numfor(sr.nme04,34,t_azi04) CLIPPED,
#              COLUMN g_c[35],cl_numfor(sr.nme07,35,t_azi07) CLIPPED,
#              COLUMN g_c[36],cl_numfor(sr.nme08,36,g_azi04) CLIPPED,
#              COLUMN g_c[37],sr.nme06 CLIPPED
#
#    AFTER GROUP OF sr.nma01
#         PRINT g_dash2
#
#     #   PRINT COLUMN 17,g_x[20] CLIPPED,
#     #         COLUMN 28,cl_numfor(GROUP SUM(sr.nme04),18,t_azi05) CLIPPED,
#     #         COLUMN 60,cl_numfor(GROUP SUM(sr.nme08),18,g_azi05) CLIPPED
#          
#         PRINT COLUMN g_c[33],g_x[20] CLIPPED,
#               COLUMN g_c[34],cl_numfor(GROUP SUM(sr.nme04),34,t_azi05) CLIPPED,
#               COLUMN g_c[36],cl_numfor(GROUP SUM(sr.nme08),36,g_azi05) CLIPPED
#     # NO.FUN-670067 ---end---
#
#    ON LAST ROW
#      LET l_last_sw = 'y'
#
#
#   PAGE TRAILER
#     IF l_last_sw ='n' THEN
#        PRINT g_dash
#        PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN g_len-7,g_x[06] CLIPPED
#     ELSE
#        PRINT g_dash
#        PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN g_len-7,g_x[07] CLIPPED
#     END IF
#END REPORT
#END MOD-5B0104
#No.FUN-780011  --End  
#No.MOD-A20079 --begin
FUNCTION q300_voucher()
DEFINE l_apa00    LIKE apa_file.apa00
DEFINE l_nnw00    LIKE nnw_file.nnw00 #CHI-A90005 add

    SELECT apa00,apa44 INTO l_apa00,g_nme[g_cnt].voucher FROM apa_file WHERE apa01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
       IF l_apa00 ='23' THEN
          LET g_nme[g_cnt].flag ='aapq230'
          RETURN
       END IF
       IF l_apa00 ='25' THEN
          LET g_nme[g_cnt].flag ='aapq231'
          RETURN
       END IF
       IF l_apa00 ='24' THEN
          LET g_nme[g_cnt].flag ='aapq240'
          RETURN
       END IF
       IF l_apa00 ='11' THEN
          LET g_nme[g_cnt].flag ='aapt110'
          RETURN
       END IF
       IF l_apa00 ='12' THEN
          LET g_nme[g_cnt].flag ='aapt120'
          RETURN
       END IF
       IF l_apa00 ='13' THEN
          LET g_nme[g_cnt].flag ='aapt121'
          RETURN
       END IF
       IF l_apa00 ='15' THEN
          LET g_nme[g_cnt].flag ='aapt150'
          RETURN
       END IF
       IF l_apa00 ='17' THEN
          LET g_nme[g_cnt].flag ='aapt151'
          RETURN
       END IF
       IF l_apa00 ='16' THEN
          LET g_nme[g_cnt].flag ='aapt160'
          RETURN
       END IF
       IF l_apa00 ='21' THEN
          LET g_nme[g_cnt].flag ='aapt210'
          RETURN
       END IF
       IF l_apa00 ='22' THEN
          LET g_nme[g_cnt].flag ='aapt220'
          RETURN
       END IF
       IF l_apa00 ='26' THEN
          LET g_nme[g_cnt].flag ='aapt260'
          RETURN
       END IF
    END IF

    SELECT oma33 INTO g_nme[g_cnt].voucher FROM oma_file WHERE oma01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='axrt300'
          RETURN
    END IF
    #No.MOD-D50167  --Begin
    SELECT apf44 INTO g_nme[g_cnt].voucher FROM apf_file,aph_file 
     WHERE apf01 = aph01 AND aph04 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='aapt332'
          RETURN
    END IF
    #No.MOD-D50167  --End
    
    SELECT apf44 INTO g_nme[g_cnt].voucher FROM apf_file WHERE apf01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='aapt330'
          RETURN
    END IF
    

    SELECT ooa33 INTO g_nme[g_cnt].voucher FROM ooa_file WHERE ooa01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='axrt400'
          RETURN
    END IF
    
    #CHI-A90005 add --start--
    SELECT alc74,alc02 INTO g_nme[g_cnt].voucher,g_alc02[g_cnt] FROM alc_file 
     WHERE alc01 = g_nme[g_cnt].nme12
       AND alc02 = (SELECT MAX(alc02) FROM alc_file WHERE alc01 = g_nme[g_cnt].nme12 
                       AND alcfirm <> 'X' ) #CHI-C80041
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='aapt741'
          RETURN
    END IF

    SELECT ala74 INTO g_nme[g_cnt].voucher FROM ala_file WHERE ala01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='aapt711'
          RETURN
    END IF

    SELECT gxf13 INTO g_nme[g_cnt].voucher FROM gxf_file WHERE gxf011 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmi820'
          RETURN
    END IF

   #SELECT npl09 INTO g_nme[g_cnt].voucher FROM npl_file,npm_file          #MOD-B50085 mark
    SELECT DISTINCT npl09 INTO g_nme[g_cnt].voucher FROM npl_file,npm_file #MOD-B50085
    #WHERE npm01 = npl01 AND npm03 = g_nme[g_cnt].nme12                    #MOD-B50085 mark
     WHERE npm01 = npl01 AND npl01 = g_nme[g_cnt].nme12                    #MOD-B50085
       AND (npl03='8' OR (npl03 = '7' AND npm07 = '8') OR (npl03 = '9' AND npm07 = '8'))
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt150'
          RETURN
    END IF

   #SELECT npn09 INTO g_nme[g_cnt].voucher FROM npn_file,npo_file          #MOD-B50085 mark  
    SELECT DISTINCT npn09 INTO g_nme[g_cnt].voucher FROM npn_file,npo_file #MOD-B50085
    #WHERE npn01 = npo01 AND npo03 = g_nme[g_cnt].nme12   #MOD-B40057 mark
     WHERE npn01 = npo01 AND npn01 = g_nme[g_cnt].nme12   #MOD-B40057
       AND (npn03='8' OR (npn03='7' AND npo07='8'))
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt250'
          RETURN
    END IF

    SELECT gxe14 INTO g_nme[g_cnt].voucher FROM gxe_file WHERE gxe01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt420'
          RETURN
    END IF

    SELECT gsh21 INTO g_nme[g_cnt].voucher FROM gsh_file WHERE gsh01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt605'
          RETURN
    END IF

    SELECT gse21 INTO g_nme[g_cnt].voucher FROM gse_file WHERE gse01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt610'
          RETURN
    END IF

    SELECT nneglno INTO g_nme[g_cnt].voucher FROM nne_file WHERE nne01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt710'
          RETURN
    END IF

    SELECT nngglno INTO g_nme[g_cnt].voucher FROM nng_file WHERE nng01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt720'
          RETURN
    END IF

    SELECT nniglno INTO g_nme[g_cnt].voucher FROM nni_file WHERE nni01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt740'
          RETURN
    END IF

    SELECT nnkglno INTO g_nme[g_cnt].voucher FROM nnk_file WHERE nnk01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt750'
          RETURN
    END IF

    SELECT gxiglno INTO g_nme[g_cnt].voucher FROM gxi_file WHERE gxi01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt840'
          RETURN
    END IF

    SELECT gxkglno INTO g_nme[g_cnt].voucher FROM gxk_file WHERE gxk01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt850'
          RETURN
    END IF

    SELECT nnv34 INTO g_nme[g_cnt].voucher FROM nnv_file WHERE nnv01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt920'
          RETURN
    END IF

    SELECT nnw00,nnw28 INTO l_nnw00,g_nme[g_cnt].voucher FROM nnw_file WHERE nnw01 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          IF l_nnw00 ='1' THEN
             LET g_nme[g_cnt].flag ='anmt930'
             RETURN
          END IF
          IF l_nnw00 ='2' THEN
             LET g_nme[g_cnt].flag ='anmt940'
             RETURN
          END IF
    END IF
    #CHI-A90005 add --end--
    
    SELECT nmg13 INTO g_nme[g_cnt].voucher FROM nmg_file WHERE nmg00 = g_nme[g_cnt].nme12
    IF NOT sqlCA.sqlcode THEN
          LET g_nme[g_cnt].flag ='anmt302'
          RETURN
    END IF

END FUNCTION
#No.MOD-A20079 --end 
#Patch....NO.TQC-610036 <001> #
