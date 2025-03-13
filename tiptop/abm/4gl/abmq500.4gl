# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abmq500.4gl
# Descriptions...: BOM 單階查詢
# Date & Author..: 94/02/06  By  Roger
#	.........: 將組成用量除以底數(bmb06/bmb07)
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-510115 05/01/19 By ching per 與 4gl array 需一致
# Modify.........: No.FUN-550093 05/05/24 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-610095 06/01/24 By Rosayu 串接abmq500
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能						
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720055 07/03/19 By Ray 單身下條件無法查詢
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790076 07/09/12 By judy 匯出Excel多一空白行
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-850118 08/05/15 By claire 料號加入開窗
# Modify.........: No.MOD-920233 09/02/18 By claire 特性代碼關聯
# Modify.........: No.FUN-950065 09/06/24 By mike 增加外部參數      
# Modify.........: No.TQC-970206 09/07/21 By Carrier l_ac判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:MOD-990109 09/11/11 By sabrina 單身應排除bmb06=0的資料
# Modify.........: No:TQC-990023 09/11/25 By sabrina 還原FUN-950065的功能
# Modify.........: No:MOD-A30161 10/07/23 By Pengu 由abmi600串查時，應考慮有效日期
# Modify.........: No.TQC-AB0063 10/11/18 By destiny 状态栏位无法查询
# Modify.........: No.TQC-C50116 12/05/14 By fengrui 填充單身時，除去無效資料
# Modify.........: No.CHI-CA0002 12/10/12 By Elise 修改MOD-850118開窗,改為q_bma101(改善效能)
# Modify.........: No.CHI-CB0050 13/02/26 By Elise 增加 作業編號(bmb09)欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(500)
        END RECORD,
    g_bma   RECORD
            bma01 LIKE bma_file.bma01,
            ima02 LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            ima05 LIKE ima_file.ima05,
            ima08 LIKE ima_file.ima08,
            ima55 LIKE ima_file.ima55,
            bmauser LIKE bma_file.bmauser,
            bmagrup LIKE bma_file.bmagrup,
            bmamodu LIKE bma_file.bmamodu,
            bmadate LIKE bma_file.bmadate,
            bmaacti LIKE bma_file.bmaacti,
            bma06 LIKE bma_file.bma06,  #FUN-550093
            bmaoriu LIKE bma_file.bmaoriu, #No.FUN-9A0024
            bmaorig LIKE bma_file.bmaorig  #No.FUN-9A0024
            END RECORD,
	g_vdate LIKE type_file.dat,        #No.FUN-680096 DATE
	g_rec_b LIKE type_file.num5,       #No.FUN-680096 SMALLINT
     g_bmb DYNAMIC ARRAY OF RECORD
            bmb02   LIKE bmb_file.bmb02,
            bmb03   LIKE bmb_file.bmb03,
             ima02_b LIKE ima_file.ima02,    #MOD-510115
            ima021_b LIKE ima_file.ima021,
            bmb09   LIKE bmb_file.bmb09,      #作業編號    #CHI-CB0050 add
            bmb06   LIKE bmb_file.bmb06,
            bmb10   LIKE bmb_file.bmb10,
            bmb08   LIKE bmb_file.bmb08,
            bmb13   LIKE bmb_file.bmb13
        END RECORD,
        
     g_argv1     LIKE bma_file.bma01,       # INPUT ARGUMENT - 1
    #g_argv2     LIKE bma_file.bma06,       #FUN-950065   #TQC-990023 mark    
     g_argv2     LIKE type_file.dat,        #No:MOD-A30161 add
     g_sql       string                     #No.FUN-580092 HCN
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
DEFINE   g_cnt         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_msg         LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   g_cmd         LIKE type_file.chr1000  #FUN-610095      #No.FUN-680096 VARCHAR(100)
DEFINE  lc_qbe_sn      LIKE gbm_file.gbm01  #No.FUN-580031  HCN
 
MAIN
      DEFINE #  l_time LIKE type_file.chr8           #No.FUN-6A0060
          l_sl	       LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
    LET g_argv1      = ARG_VAL(1)          # 參數值(1)
   #LET g_argv2      = ARG_VAL(2)          #FUN-950065    #TQC-990023 mark     
    LET g_argv2      = ARG_VAL(2)          #FUN-950065   #No:TQC-990023 mark  #No:MOD-A30161 del mark
   #----------No:MOD-A30161 add
    IF NOT cl_null(g_argv2) THEN
       LET g_vdate = g_argv2
    ELSE
   #----------No:MOD-A30161 add
       LET g_vdate      = g_today
    END IF                         #No:MOD-A30161 add
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q500_w AT p_row,p_col WITH FORM "abm/42f/abmq500"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #FUN-560021................begin
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
    #FUN-560021................end
#FUN-950065    ---begin
   #IF NOT cl_null(g_argv1) THEN CALL q500_q() END IF    
   #IF NOT cl_null(g_argv1) AND g_argv2 IS NOT NULL THEN  #TQC-990023 mark                                                                
    IF NOT cl_null(g_argv1) THEN                          #TQC-990023 add                                                                 
       CALL q500_q()                                                                                                                
    END IF             
#FUN-950065    ---end        
    CALL q500_menu()
    CLOSE WINDOW q500_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION q500_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
#TQC-990023---modify---start---
  #FUN-950065   ---start      
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "bma01 = '",g_argv1,"'"
  #IF NOT cl_null(g_argv1) AND g_argv2 IS NOT NULL THEN                                                                             
  #   LET tm.wc = "bma01 = '",g_argv1,"' AND bma06 = '",g_argv2,"' "                                                                
  #FUN-950065     ---end       
#TQC-990023---modify---end---                                      
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM                       # 清除畫面
   CALL g_bmb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033					
 
   INITIALIZE g_bma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,bmauser,bmamodu,bmaacti,bmagrup,bmadate,bmaoriu,bmaorig #FUN-550093  #TQC-AB0063
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      #--No.MOD-850118--------
      ON ACTION CONTROLP
        CASE 
         WHEN INFIELD(bma01) #主件
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
      	     #LET g_qryparam.form = "q_bmb01"    #CHI-CA0002 mark
              LET g_qryparam.form = "q_bma101"   #CHI-CA0002
              CALL cl_create_qry() RETURNING g_qryparam.multiret
      	      DISPLAY g_qryparam.multiret TO bma01
      	      NEXT FIELD bma01
         OTHERWISE 
              EXIT CASE
         END CASE
      #--#MOD-850118-END-------    
 
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
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033					
 
      INPUT BY NAME g_vdate WITHOUT DEFAULTS
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE INPUT        #TQC-860021
 
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
 
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
      END INPUT                   #TQC-860021
 
      IF INT_FLAG THEN
         RETURN
      END IF
      CALL q500_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   MESSAGE ' SEARCHING '
   IF tm.wc2 = " 1=1" THEN
      LET g_sql = " SELECT UNIQUE bma01,bma06 FROM bma_file", #FUN-550093
                  "  WHERE ",tm.wc CLIPPED
   ELSE
#     LET g_sql = " SELECT UNIQUE bma01,bma06", #FUN-550093      #No.TQC-720055
      LET g_sql = " SELECT UNIQUE bma01,bma06", #FUN-550093      #No.TQC-720055
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY bma01,bma06"
   PREPARE q500_prepare FROM g_sql
   DECLARE q500_cs SCROLL CURSOR FOR q500_prepare
#No.TQC-720055 --begin
#  LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   IF tm.wc2 = " 1=1" THEN
      LET g_sql= " SELECT COUNT(*) FROM bma_file WHERE ",tm.wc CLIPPED
   ELSE
      LET g_sql = " SELECT COUNT(*) ",
                  " FROM bma_file, bmb_file ",
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma06 = bmb29",   #MOD-920233 add
                  "   AND bma01 = bmb01"
   END IF
#No.TQC-720055 --end
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND bmauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND bmagrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q500_pp FROM g_sql
   DECLARE q500_cnt CURSOR FOR q500_pp
END FUNCTION
 
 
FUNCTION q500_b_askkey()
   CONSTRUCT tm.wc2 ON bmb02,bmb03,bmb09,bmb13                        #CHI-CB0050 add bmb09
                  FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb09,s_bmb[1].bmb13  #CHI-CB0050 add bmb09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
              #No.FUN-580031 --end--       HCN

     #CHI-CB0050---add---S
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bmb09)
                 CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                        RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO bmb09
                   NEXT FIELD bmb09

            OTHERWISE EXIT CASE
         END  CASE
     #CHI-CB0050---add---E

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
END FUNCTION
 
FUNCTION q500_menu()
 
   WHILE TRUE
      CALL q500_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q500_q()
         WHEN "jump"
            CALL q500_fetch('/')
         WHEN "next"
            CALL q500_fetch('N')
         WHEN "previous"
            CALL q500_fetch('P')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
             CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
FUNCTION q500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q500_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q500_cnt
       FETCH q500_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q500_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q500_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1     #處理方式   #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q500_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'P' FETCH PREVIOUS q500_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'F' FETCH FIRST    q500_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'L' FETCH LAST     q500_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q500_cs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL  #TQC-6B0105
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
 
	SELECT bma01,'','',' ','','', #FUN-550093
           bmauser,bmagrup,bmamodu,bmadate,bmaacti,bma06 #FUN-550093
	  INTO g_bma.*
      FROM bma_file
       # WHERE bma01 = g_bma.bma01 AND g_bma.bma06 = bma06 AND bma01 = ima01  #FUN-550093
	 WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06  #FUN-550093
 
 
    IF SQLCA.sqlcode THEN
      # CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bma_file",g_bma.bma01,"",SQLCA.sqlcode,"","",0)    #No.TQC-660046
        RETURN
    END IF
 
    #FUN-550093................begin
    SELECT ima02,ima021,' ',ima08,ima55
      INTO g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55
    FROM ima_file
      WHERE ima01 = g_bma.bma01
    #FUN-550093................end
 
    CALL s_effver(g_bma.bma01,g_vdate) RETURNING g_bma.ima05
 
    CALL q500_show()
END FUNCTION
 
FUNCTION q500_show()
   #No.FUN-9A0024--begin 
   #DISPLAY BY NAME g_bma.*
   DISPLAY BY NAME g_bma.bma01,g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55,
                   g_bma.bmauser,g_bma.bmamodu,g_bma.bmaacti,g_bma.bmagrup,
                   g_bma.bmadate,g_bma.bmaoriu,g_bma.bmaorig 
   #No.FUN-9A0024--end  
   CALL q500_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q500_b_fill()              #BODY FILL UP
   DEFINE l_sql   LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(1000)
   DEFINE ia      LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
    LET l_sql =			#95/12/21 Modify By Lynn
         "SELECT bmb02,bmb03,ima02,ima021,bmb09,", #MOD-510115 #CHI-CB0050 add bmb09
        "       (bmb06/bmb07),bmb10,bmb08,bmb13",
        #" FROM  bmb_file, OUTER ima_file",          #TQC-C50116 mark
        " FROM  bma_file,bmb_file, OUTER ima_file",  #TQC-C50116 add
        " WHERE ",tm.wc2 CLIPPED,
        "   AND bmb01 = bma01 ",                     #TQC-C50116 add
        "   AND bmb29 = bma06 ",                     #TQC-C50116 add 
        "   AND bmaacti = 'Y' ",                     #TQC-C50116 add
        "   AND bmb01 = '",g_bma.bma01,"'",
        "   AND bmb29 = '",g_bma.bma06,"'", #FUN-550093
        "   AND bmb06 != 0 ",      #No:MOD-990109 modify
        "   AND bmb_file.bmb03 = ima_file.ima01"
    IF g_vdate IS NOT NULL THEN
       LET l_sql=l_sql CLIPPED,
        " AND (bmb04 <='",g_vdate CLIPPED,"' OR bmb04 IS NULL)",
        " AND (bmb05 > '",g_vdate CLIPPED,"' OR bmb05 IS NULL)"
    END IF
    CASE
      WHEN g_sma.sma65 = '1' LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
      WHEN g_sma.sma65 = '2' LET l_sql=l_sql CLIPPED," ORDER BY bmb03"
      WHEN g_sma.sma65 = '3' LET l_sql=l_sql CLIPPED," ORDER BY bmb13"
      OTHERWISE              LET l_sql=l_sql CLIPPED," ORDER BY bmb02"
    END CASE
    PREPARE q500_pb FROM l_sql
    DECLARE q500_bcs CURSOR FOR q500_pb
    FOR g_cnt = 1 TO g_bmb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_bmb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q500_bcs INTO g_bmb[g_cnt].*
      IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
#     IF g_cnt > g_bmb_arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_bmb.deleteElement(g_cnt)   #TQC-790076
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
#   LET i = g_cnt / g_bmb_sarrno
#   IF (g_cnt > i*g_bmb_sarrno) THEN LET i = i + 1 END IF
END FUNCTION
 
FUNCTION q500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
   DEFINE   l_t    LIKE type_file.num10     #No.FUN-680096 INTEGER
   DEFINE l_ima910 LIKE ima_file.ima910     #No.TQC-970206
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      #FUN-610095 add
      ON ACTION mat_qty_use
         LET l_t = ARR_CURR()
         #No.TQC-970206  --Begin
         IF l_t > 0 THEN  
            SELECT ima910 INTO l_ima910 FROM ima_file
             WHERE ima01 = g_bmb[l_t].bmb03
            IF l_ima910 IS NULL THEN LET l_ima910 = ' ' END IF
            LET g_cmd = "abmq500 '",g_bmb[l_t].bmb03,"' '",l_ima910,"'"
            CALL cl_cmdrun(g_cmd CLIPPED)
         END IF  
         #No.TQC-970206  --End  
         CONTINUE DISPLAY
      #FUN-610095 end
     #BEFORE ROW
         #LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION next
         CALL q500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION accept
        #LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       						
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033						
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
