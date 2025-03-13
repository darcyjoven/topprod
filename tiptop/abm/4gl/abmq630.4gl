# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abmq630.4gl
# Descriptions...: BOM 指定廠牌查詢
# Date & Author..: 97/10/06  By  Roger
# Modify.........: No.FUN-4B0022 04/11/03 By Yuna 新增料號開窗
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4B0024 04/11/03 By Smapmin 料號開窗
# Modify.........: No.FUN-560107 05/06/18 By kim 資料無法輸入及呈現(因為bma_file add bma06故程式要改)
# Modify.........: No.MOD-650015 06/06/14 By douzh cl_err----->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760113 07/07/18 By pengu SELECT SQL語法的欄位個數與g_bmb.*欄位個數不一致
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.TQC-970209 09/07/22 By sherry 狀態頁簽欄的資料顯示出來
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-AB0064 10/11/18 By destiny 状态栏位无法查询
# Modify.........: No.TQC-AC0037 10/12/13 By destiny 將單身無資料的單頭資料過濾掉
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm  RECORD
        	wc  	LIKE type_file.chr1000,  #No.FUN-680096 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(500)
        END RECORD,
    g_bma   RECORD
            bma01 LIKE bma_file.bma01,
            ima02 LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            bma06 LIKE bma_file.bma06, #FUN-560107
            ima05 LIKE ima_file.ima05,
            ima08 LIKE ima_file.ima08,
            ima55 LIKE ima_file.ima55 
           #bmauser LIKE bma_file.bmauser, #mark by FUN-560107
           #bmagrup LIKE bma_file.bmagrup, #mark by FUN-560107
           #bmamodu LIKE bma_file.bmamodu, #mark by FUN-560107
           #bmadate LIKE bma_file.bmadate, #mark by FUN-560107
           #bmaacti LIKE bma_file.bmaacti  #mark by FUN-560107
            #TQC-970209---Begin                                                                                                     
            ,bmauser LIKE bma_file.bmauser,                                                                                         
            bmagrup LIKE bma_file.bmagrup,                                                                                          
            bmamodu LIKE bma_file.bmamodu,                                                                                          
            bmadate LIKE bma_file.bmadate,                                                                                          
            bmaacti LIKE bma_file.bmaacti,
            bmaoriu LIKE bma_file.bmaoriu, #No.FUN-9A0024                                                                           
            bmaorig LIKE bma_file.bmaorig  #No.FUN-9A0024                                                                                              
            #TQC-970209---End   
            END RECORD,
	g_vdate LIKE type_file.dat,         #No.FUN-680096 DATE
	g_rec_b LIKE type_file.num5,        #No.FUN-680096 SMALLINT
    g_bmb DYNAMIC ARRAY OF RECORD
            bmb02     LIKE bmb_file.bmb02,
            bmb03     LIKE bmb_file.bmb03,
            ima02_b   LIKE ima_file.ima02,
            ima021_b  LIKE ima_file.ima021,
            bmb13     LIKE bmb_file.bmb13,  #FUN-560107
            qvl1      LIKE ze_file.ze03     #No.FUN-680096 VARCHAR(50)
        END RECORD,
     g_argv1     LIKE bma_file.bma01,       # INPUT ARGUMENT - 1
     g_argv2     LIKE bma_file.bma06,       #FUN-560107
     g_sql       string                     #No.FUN-580092 HCN
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
DEFINE   g_cnt         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_msg         LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE  lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031  HCN
 
MAIN
      DEFINE  # l_time LIKE type_file.chr8           #No.FUN-6A0060
          l_sl	       LIKE type_file.num5     #No.FUN-680096  SMALLINT
 
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
    LET g_argv2      = ARG_VAL(2)          #FUN-560107
    IF cl_null(g_argv2) THEN LET g_argv2=' ' END IF #FUN-560107
    LET g_vdate      = g_today
    LET p_row = 3 LET p_col = 2
 
    OPEN WINDOW q630_w AT p_row,p_col WITH FORM "abm/42f/abmq630" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL q630_q() END IF
    CALL q630_menu()
    CLOSE WINDOW q630_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION q630_cs()                          # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5     #No.FUN-680096 SMALLINT
   DEFINE   l_sql   STRING  #FUN-560107
 
   IF NOT cl_null(g_argv1) THEN
      LET tm.wc = "bma01 = '",g_argv1,"' AND bma06='",g_argv2,"'" #FUN-560107
      LET tm.wc2=" 1=1 "
   ELSE
      CLEAR FORM                       # 清除畫面
   CALL g_bmb.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON bma01,bma06,bmauser,bmamodu,bmaacti,bmagrup,bmadate,bmaoriu,bmaorig #FUN-560107  #TQC-AB0064
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         #--No.FUN-4B0022-------
         ON ACTION CONTROLP
           CASE WHEN INFIELD(bma01)      #料件編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_bma3"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bma01
                     NEXT FIELD bma01
           OTHERWISE EXIT CASE
           END CASE
         #--END---------------
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
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
      CALL q630_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
      IF INT_FLAG THEN 
         RETURN
      END IF
   END IF
   MESSAGE ' SEARCHING ' 
   IF tm.wc2 = " 1=1" THEN
      LET g_sql = " SELECT UNIQUE bma01,bma06 FROM bma_file", #FUN-560107
                  " ,bml_file ",       #TQC-AC0037
                  "  WHERE ",tm.wc CLIPPED,
                  " AND bma01=bml02 ", #TQC-AC0037
                  " ORDER BY bma01"
      #FUN-560107................begin
      LET l_sql = " SELECT UNIQUE bma01,bma06 FROM bma_file ",
                  " ,bml_file ",                          #TQC-AC0037
                  #" WHERE ",tm.wc CLIPPED                #TQC-AC0037
                  " WHERE bma01=bml02 AND ",tm.wc CLIPPED #TQC-AC0037
      #FUN-560107................end
   ELSE
      LET g_sql = " SELECT UNIQUE bma01,bma06", #FUN-560107
                  " FROM bma_file, bmb_file ",
                  " ,bml_file ",                          #TQC-AC0037
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma01 = bmb01",
                  "   AND bmb29 = bma06", #FUN-560107
                  " AND bma01=bml02 ",                    #TQC-AC0037 
                  " AND bmb03=bml01 ",                    #TQC-AC0037
                  " ORDER BY bma01"
      #FUN-560107................begin
      LET l_sql = " SELECT UNIQUE bma01,bma06 ",
                  " FROM bma_file, bmb_file ",
                  " ,bml_file ",                          #TQC-AC0037
                  " WHERE ",tm.wc CLIPPED, " AND ", tm.wc2 CLIPPED,
                  "   AND bma01 = bmb01",
                  "   AND bmb29 = bma06",
                  " AND bma01=bml02 ",                    #TQC-AC0037 
                  " AND bmb03=bml01 "                     #TQC-AC0037
      #FUN-560107................end
   END IF
   PREPARE q630_prepare FROM g_sql
   DECLARE q630_cs SCROLL CURSOR FOR q630_prepare
   #FUN-560107................begin
  #LET g_sql= " SELECT COUNT(DISTINCT bma01) FROM bma_file WHERE ",tm.wc CLIPPED #FUN-560107
   DROP TABLE q630_cnttmp
   LET l_sql = l_sql," INTO TEMP q630_cnttmp"
   PREPARE q630_cnttmp_sql FROM l_sql
   EXECUTE q630_cnttmp_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('q630_cnttmp',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET g_sql=" SELECT COUNT(*) FROM q630_cnttmp"
   #FUN-560107................end
   PREPARE q630_pp FROM g_sql
   DECLARE q630_cnt CURSOR FOR q630_pp
END FUNCTION
 
 
FUNCTION q630_b_askkey()
   CONSTRUCT tm.wc2 ON bmb02,bmb03,bmb13 #FUN-560107
                  FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb13 #FUN-560107
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
              #No.FUN-580031 --end--       HCN
   ON ACTION CONTROLP    #FUN-4B0024
           IF INFIELD(bmb03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_bmb4"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bmb03
              NEXT FIELD bmb03
           END IF
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
 
FUNCTION q630_menu()
 
   WHILE TRUE
      CALL q630_bp("G")
      CASE g_action_choice
         WHEN "query" 
            CALL q630_q() 
         WHEN "jump"   
            CALL q630_fetch('/')
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "next"  
            CALL q630_fetch('N')
         WHEN "previous" 
            CALL q630_fetch('P')
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q630_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   CALL q630_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q630_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
      OPEN q630_cnt 
      FETCH q630_cnt INTO g_row_count
      DISPLAY g_row_count TO cnt  
      CALL q630_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ''
END FUNCTION
 
FUNCTION q630_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1          #處理方式  #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q630_cs INTO g_bma.bma01,g_bma.bma06 #FUN-560107
        WHEN 'P' FETCH PREVIOUS q630_cs INTO g_bma.bma01,g_bma.bma06 #FUN-560107
        WHEN 'F' FETCH FIRST    q630_cs INTO g_bma.bma01,g_bma.bma06 #FUN-560107
        WHEN 'L' FETCH LAST     q630_cs INTO g_bma.bma01,g_bma.bma06 #FUN-560107
        WHEN '/'
 
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump q630_cs INTO g_bma.bma01,g_bma.bma06 #FUN-560107
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
 
    #FUN-560107................begin
   #SELECT DISTINCT bma01,ima02,ima021,bma06,' ',ima08,ima55  #FUN-560107
   #      #bmauser,bmagrup,bmamodu,bmadate,bmaacti      #mark by FUN-560107
   #      INTO g_bma.*
   #  FROM bma_file, OUTER ima_file
   #     WHERE bma01 = g_bma.bma01 AND bma01 = ima_file.ima01
   #TQC-970209---Begin                                                                                                              
   # SELECT bma01,'','',bma06,'','','' INTO g_bma.* FROM bma_file                                                                   
    SELECT bma01,'','',bma06,'','','',bmauser,bmagrup,bmamodu,bmadate,bmaacti                                                       
      INTO g_bma.* FROM bma_file                                                                                                    
   #TQC-970209---End 
      WHERE bma01=g_bma.bma01 AND bma06=g_bma.bma06
 
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bma_file",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","",0)  # TQC-660046
        RETURN
    END IF
 
    SELECT ima02,ima021,' ',ima08,ima55
      INTO g_bma.ima02,g_bma.ima021,g_bma.ima05,g_bma.ima08,g_bma.ima55
    FROM ima_file WHERE ima01 = g_bma.bma01
    #FUN-560107................end
    CALL s_effver(g_bma.bma01,g_vdate) RETURNING g_bma.ima05
 
    CALL q630_show()
END FUNCTION
 
FUNCTION q630_show()
   #No.FUN-9A0024--begin                                                                                                            
   #DISPLAY BY NAME g_bma.*                                                                                                         
   DISPLAY BY NAME g_bma.bma01,g_bma.ima02,g_bma.ima021,g_bma.bma06,g_bma.ima05,g_bma.ima08,g_bma.ima55,                                        
                   g_bma.bmauser,g_bma.bmamodu,g_bma.bmaacti,g_bma.bmagrup,                                                         
                   g_bma.bmadate,g_bma.bmaoriu,g_bma.bmaorig                                                                        
   #No.FUN-9A0024--end 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       DISPLAY '!' TO FORMONLY.g_s
   END IF
   CALL q630_b_fill() #單身
END FUNCTION
 
FUNCTION q630_b_fill()                     #BODY FILL UP
   DEFINE l_sql    LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(1000)
   DEFINE l_bml    RECORD LIKE bml_file.*
   DEFINE i	   LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
    LET l_sql =			#95/12/21 Modify By Lynn
       #---------------No.MOD-760113 modify
       #"SELECT DISTINCT bmb02,bmb03,ima02,ima021,'','',bmb13", #FUN-560107
        "SELECT DISTINCT bmb02,bmb03,ima02,ima021,bmb13,''", #FUN-560107
       #---------------No.MOD-760113 end
        " FROM  bmb_file, OUTER ima_file",
        " WHERE ",tm.wc2 CLIPPED,
        "   AND bmb01 = '",g_bma.bma01,"'",
        "   AND bmb_file.bmb03 = ima_file.ima01",
        "   AND bmb29 = '",g_bma.bma06,"'"  #FUN-560107
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
    PREPARE q630_pb FROM l_sql
    DECLARE q630_bcs CURSOR FOR q630_pb
    FOR g_cnt = 1 TO g_bmb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_bmb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q630_bcs INTO g_bmb[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       DECLARE q630_c2 CURSOR FOR
           SELECT * FROM bml_file
            WHERE bml02=g_bma.bma01
              AND bml01=g_bmb[g_cnt].bmb03
            ORDER BY bml03
       LET g_msg=NULL
       FOREACH q630_c2 INTO l_bml.*
          LET g_msg=g_msg CLIPPED,' ',l_bml.bml04
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
       END FOREACH
       IF g_msg IS NULL THEN
          INITIALIZE g_bmb[g_cnt].* TO NULL CONTINUE FOREACH
       END IF
       LET g_bmb[g_cnt].qvl1=g_msg
#      LET g_bmb[g_cnt].qvl1=g_msg[02,23]
#      LET g_bmb[g_cnt].qvl2=g_msg[24,47]
       LET g_cnt = g_cnt + 1
#      IF g_cnt > g_bmb_arrno THEN CALL cl_err('',9035,0) EXIT FOREACH END IF
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2  
#   LET i = g_cnt / g_bmb_sarrno
#   IF (g_cnt > i*g_bmb_sarrno) THEN LET i = i + 1 END IF
END FUNCTION
 
FUNCTION q630_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1      #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         #LET l_ac = ARR_CURR()
         #LET l_sl = SCR_LINE()
         CALL cl_show_fld_cont()                           #No.FUN-560228
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q630_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL q630_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL q630_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q630_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL q630_fetch('P')
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q630_bp_refresh()
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
END FUNCTION
 
