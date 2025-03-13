# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abmi607.4gl
# Descriptions...: 採購料件市價維護作業
# Date & Author..: 92/10/16 By Apple 
# Modify.........: No.MOD-470051 04/07/21 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0002 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530204 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550093 05/05/31 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/07 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.MOD-5C0036 05/12/07 By Claire 發料單位由取庫存單位(ima25)調整回ima63發料單位,增加採購單位(ima44)
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-6B0082 06/12/13 By pengu 市價作更正後,按確認並未即時show總金額到內購成本欄位
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-880153 08/09/01 By claire 單身會有空白的資料列出
# Modify.........: No.MOD-8A0120 08/10/14 By claire 調整TQC-630105,g_cnt不可重算,否則會造成同一階有二個料同時要往下展時,會跳離開其中一顆不往下展
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.TQC-920059 09/02/20 By destiny 將g_cnt改為l_cnt，否則無法進for循環
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting 未加離開前得cl_used(2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
      tm  RECORD            
              wc        LIKE type_file.chr1000,#No.FUN-680096 VARCHAR(300), # Where condition
              revision  LIKE ima_file.ima05,   # 版本    
              effective LIKE type_file.dat     #No.FUN-680096 DATE 
         END RECORD ,
      g_bmb   DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
               seq     LIKE type_file.num10,   #No.FUN-680096 INTEGER
               ima01   LIKE ima_file.ima01,    # 料件編號
               ima02   LIKE ima_file.ima02,    # 品名
               ima021   LIKE ima_file.ima021,  # 規格
              # Prog. Version..: '5.30.06-13.03.12(04),              # 購料特性
               ima103  LIKE ima_file.ima103,   # 購料特性
               qpa     LIKE bmb_file.bmb06,    # 組成用量
              #ima25   LIKE ima_file.ima25,    # 庫存單位 #MOD-5C0036 mark
               ima63   LIKE ima_file.ima63,    # 發料單位 #MOD-5C0036 modify
               ima44   LIKE ima_file.ima44,    # 採購單位 #MOD-5C0036 add
               ima53   LIKE ima_file.ima53,    # 採購單價
               imb218  LIKE imb_file.imb218,   # 平均單價
               ima531  LIKE ima_file.ima531,   # 市價    
               ima532  LIKE ima_file.ima532    # 異動日期
            END RECORD,
      g_bmb_t  RECORD   
               seq     LIKE type_file.num10,   #No.FUN-680096 INTEGER
               ima01   LIKE ima_file.ima01,    # 料件編號
               ima02   LIKE ima_file.ima02,    # 品名規格
               ima021   LIKE ima_file.ima021,  # 規格
              # Prog. Version..: '5.30.06-13.03.12(04),               # 購料特性
               ima103  LIKE ima_file.ima103,   # 購料特性
               qpa     LIKE bmb_file.bmb06,    # 組成用量
              #ima25   LIKE ima_file.ima25,    # 庫存單位 #MOD-5C0036 mark
               ima63   LIKE ima_file.ima63,    # 發料單位 #MOD-5C0036 modify
               ima44   LIKE ima_file.ima44,    # 採購單位 #MOD-5C0036 add
               ima53   LIKE ima_file.ima53,    # 採購單價
               imb218  LIKE imb_file.imb218,   # 平均單價
               ima531  LIKE ima_file.ima531,   # 市價    
               ima532  LIKE ima_file.ima532    # 異動日期
            END RECORD,
      g_no            LIKE type_file.num10,    #No.FUN-680096 INTEGER  
      g_bma01         LIKE bma_file.bma01,
      g_bma06         LIKE bma_file.bma06,     #FUN-550093
      g_sql string,                            #WHERE CONDITION  #No.FUN-580092 HCN
      g_rec_b LIKE type_file.num5,             #單身筆數        #No.FUN-680096 SMALLINT
      l_ac LIKE type_file.num5,                #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
      l_sl LIKE type_file.num5                 #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql      STRING                 #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-680096
DEFINE   g_before_input_done   LIKE type_file.num5          #No.FUN-680096 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #No.FUN-680096 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("ABM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060
 
    OPEN WINDOW i607_w WITH FORM "abm/42f/abmi607" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
 
    CALL i607_menu()
    CLOSE WINDOW i607_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i607_cs()
DEFINE   l_cnt   LIKE type_file.num5,      #No.FUN-680096 SMALLINT
         l_one   LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
         l_fld   LIKE bma_file.bma01,      #No.MOD-490217
         l_bdate,l_edate   LIKE type_file.dat,      #No.FUN-680096 DATE
         l_flag  LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
 
   CLEAR FORM                #清除畫面
   CALL g_bmb.clear()
   INITIALIZE tm.* TO NULL   # Default condition
 
   CALL cl_opmsg('q')
   LET l_one ='N'
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bma01 TO NULL    #No.FUN-750051
   INITIALIZE g_bma06 TO NULL    #No.FUN-750051
   CONSTRUCT tm.wc ON bma01, bma06, ima06, ima09, ima10, ima11, ima12 #FUN-550093
                 FROM bma01, bma06, ima06, ima09, ima10, ima11, ima12 #FUN-550093
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp    
            CASE
               WHEN INFIELD(bma01) 
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.form = "q_ima"
                #  LET g_qryparam.state = 'c'
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO bma01
                  NEXT FIELD bma01
               WHEN INFIELD(ima06) #分群碼
                 #CALL q_imz(10,3,g_ima.ima06) RETURNING g_ima.ima06
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_imz"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06 
                  NEXT FIELD ima06
               WHEN INFIELD(ima09) #其他分群碼一
                 #CALL q_azf(10,3,g_ima.ima09,'D') RETURNING g_ima.ima09 #6818
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "D"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima09 
                  NEXT FIELD ima09
               WHEN INFIELD(ima10) #其他分群碼二
                 #CALL q_azf(10,3,g_ima.ima10,'E') RETURNING g_ima.ima10 #6818
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "E"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima10 
                  NEXT FIELD ima10
               WHEN INFIELD(ima11) #其他分群碼三 
                 #CALL q_azf(10,3,g_ima.ima11,'F') RETURNING g_ima.ima11 #6818
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "F"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima11 
                  NEXT FIELD ima11
               WHEN INFIELD(ima12) #其他分群碼四
                 #CALL q_azf(10,3,g_ima.ima12,'G') RETURNING g_ima.ima12 #6818
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azf"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = "G"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO ima12 
                  NEXT FIELD ima12
               OTHERWISE EXIT CASE
            END CASE
        AFTER FIELD bma01
           LET l_fld = GET_FLDBUF(bma01)
           IF l_fld IS NOT NULL THEN
              LET l_one  ='Y'     
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup') #FUN-980030
#  IF INT_FLAG THEN CLOSE WINDOW i607_w2 RETURN END IF
   LET tm.effective = g_today
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.revision,tm.effective
              WITHOUT DEFAULTS 
 
      BEFORE FIELD revision
         IF l_one='N' THEN
             NEXT FIELD effective
         END IF
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i6071_set_entry(l_one)
          CALL i6071_set_no_entry(l_one)
          LET g_before_input_done = TRUE
 
      AFTER FIELD revision
         IF tm.revision IS NOT NULL THEN
            CALL s_version(l_fld,tm.revision)
            RETURNING l_bdate,l_edate,l_flag
            LET tm.effective = l_bdate 
            DISPLAY BY NAME tm.effective 
         END IF
 
      AFTER INPUT 
       IF INT_FLAG THEN EXIT INPUT END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask() # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
 
   LET g_sql = "SELECT UNIQUE  bma01, bma06 ", #FUN-550093
               "  FROM bma_file, bmb_file,ima_file ",
               " WHERE bma01 = bmb01 ",
               "   AND bma01 = ima01 AND ", tm.wc CLIPPED,
               "   AND bma06 = bmb29 ", #FUN-550093
               " ORDER BY 1"
    PREPARE i607_prepare FROM g_sql
    DECLARE i607_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i607_prepare
    #FUN-550093................begin
   #LET g_sql="SELECT COUNT(UNIQUE bma01) ",
   #          " FROM bma_file, bmb_file ",
   #          " WHERE bma01 = bmb01",
   #          "   AND ", tm.wc CLIPPED
    DROP TABLE i607_cnttemp
    LET g_sql="SELECT UNIQUE bma01, bma06 FROM bma_file, bmb_file,ima_file ",
               " WHERE bma01 = bmb01 ",
               "   AND bma01 = ima01 AND ", tm.wc CLIPPED,
               "   AND bma06 = bmb29 ",
               "INTO TEMP i607_cnttemp"
    PREPARE i607_cnttemp_sql from g_sql
    EXECUTE i607_cnttemp_sql
    IF SQLCA.sqlcode THEN 
       #CALL cl_err("",SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bma_file","","",SQLCA.sqlcode,"","",1)  #TQC-660046 
    END IF
                                
    LET g_sql = "SELECT COUNT(*) FROM i607_cnttemp" 
    #FUN-550093................end
    PREPARE i607_pp  FROM g_sql
    DECLARE i607_count   CURSOR FOR i607_pp
END FUNCTION
 
 
FUNCTION i607_menu()
 
   WHILE TRUE
      CALL i607_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i607_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i607_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
       #@WHEN "合計"    
       # WHEN "total"
       #    CALL i607_tot()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bma01 IS NOT NULL THEN
                  LET g_doc.column1 = "bma01"
                  LET g_doc.value1  = g_bma01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i607_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CLEAR FORM
    CALL g_bmb.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i607_cs()
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i607_w  #結束畫面
       CALL cl_used(g_prog,g_time,2)   RETURNING g_time  #FUN-B30211
       EXIT PROGRAM
    END IF
    MESSAGE ' WAIT ' 
    OPEN i607_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       RETURN
    END IF
   #FOREACH i607_count INTO g_bma01
   #    LET g_cnt=SQLCA.SQLERRD[3]
   #    EXIT FOREACH
   #END FOREACH
    OPEN i607_count
    FETCH i607_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    CALL i607_fetch('F')                  # 讀出TEMP第一筆並顯示
    MESSAGE ''
END FUNCTION
 
#處理資料的讀取
FUNCTION i607_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1       #處理方式     #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i607_cs INTO g_bma01,g_bma06 #FUN-550093
        WHEN 'P' FETCH PREVIOUS i607_cs INTO g_bma01,g_bma06 #FUN-550093
        WHEN 'F' FETCH FIRST    i607_cs INTO g_bma01,g_bma06 #FUN-550093
        WHEN 'L' FETCH LAST     i607_cs INTO g_bma01,g_bma06 #FUN-550093
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i607_cs INTO g_bma01,g_bma06 #FUN-550093
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma01,SQLCA.sqlcode,0)
        INITIALIZE g_bma01 TO NULL  #TQC-6B0105
        INITIALIZE g_bma06 TO NULL  #TQC-6B0105
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
    CALL i607_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i607_show()
 DEFINE  l_ima  RECORD LIKE ima_file.*
 
   SELECT * INTO l_ima.* FROM ima_file 
    WHERE ima01 = g_bma01
   DISPLAY l_ima.ima02  TO FORMONLY.ima02_h  
   DISPLAY l_ima.ima021 TO FORMONLY.ima021_h  
   DISPLAY l_ima.ima05  TO FORMONLY.revision
   DISPLAY l_ima.ima06  TO FORMONLY.ima06
   DISPLAY l_ima.ima09  TO FORMONLY.ima09
   DISPLAY l_ima.ima10  TO FORMONLY.ima10
   DISPLAY l_ima.ima11  TO FORMONLY.ima11
   DISPLAY l_ima.ima12  TO FORMONLY.ima12
   DISPLAY g_bma01  TO bma01           
   DISPLAY g_bma06  TO bma06 #FUN-550093          
   CALL i607_b_fill() 
   CALL i607_tot()
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i607_b()
DEFINE
    l_imb218        LIKE imb_file.imb218,
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否    #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_bma01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
     #" SELECT ' ',ima01,ima02,ima021,ima103,'',ima25,ima53,0,ima531,ima532 ", # MOD-5C0036 mark
      " SELECT ' ',ima01,ima02,ima021,ima103,'',ima63,ima44,ima53,0,ima531,ima532 ", # MOD-5C0036 modify
      " FROM ima_file ",
      "   WHERE ima01= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i607_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
       #LET l_allow_insert = cl_detail_input_auth("insert")
       #LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmb
              WITHOUT DEFAULTS
              FROM s_bmb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bmb_t.* = g_bmb[l_ac].*  #BACKUP
                LET p_cmd='u'
                BEGIN WORK
 
                OPEN i607_bcl USING g_bmb_t.ima01
                IF STATUS THEN
                    CALL cl_err("OPEN i607_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i607_bcl INTO g_bmb[l_ac].* 
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmb_t.ima01,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                   #CALL s_purdesc(g_bmb[l_ac].wdesc) 
                   #               RETURNING g_bmb[l_ac].wdesc  
                    SELECT imb218 INTO l_imb218 FROM imb_file 
                                  WHERE imb01 = g_bmb[l_ac].ima01
                    IF SQLCA.sqlcode THEN LET l_imb218 = ' ' END IF
                    LET g_bmb[l_ac].imb218 = l_imb218
                    DISPLAY g_bmb[l_ac].imb218 TO s_bmb[l_sl].imb218
                                            
                   #DISPLAY g_bmb[l_ac].wdesc TO s_bmb[l_sl].wdesc
                                            
                    LET g_bmb[l_ac].seq = g_bmb_t.seq 
                    LET g_bmb[l_ac].qpa = g_bmb_t.qpa 
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD seq
 
        AFTER FIELD ima531
            IF g_bmb[l_ac].ima01 IS NOT NULL 
             AND g_bmb[l_ac].ima01 != ' '
            THEN 
               IF g_bmb[l_ac].ima531 IS NULL OR g_bmb[l_ac].ima531 = ' '
                  OR g_bmb[l_ac].ima531 < 0 
               THEN LET g_bmb[l_ac].ima531 = g_bmb_t.ima531 
                    DISPLAY g_bmb[l_ac].ima531 TO s_bmb[l_sl].ima531 
                    NEXT FIELD ima531
               END IF
           END IF
 
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmb[l_ac].* = g_bmb_t.*
               CLOSE i607_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmb[l_ac].ima01,-263,1)
               LET g_bmb[l_ac].* = g_bmb_t.*
            ELSE
                UPDATE ima_file 
                   SET ima531 = g_bmb[l_ac].ima531,
                       ima532 = g_sma.sma30,
                       imadate = g_today              #FUN-C30315 add
                 WHERE ima01 = g_bmb[l_ac].ima01
                #WHERE ima01=g_bmb_t.ima01 
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
  #                  CALL cl_err(g_bmb[l_ac].ima01,'mfg0151',0) #No.TQC-660046
                    CALL cl_err3("upd","ima_file",g_bmb[l_ac].ima01,"","mfg0151","","",1)  #TQC-660046
                ELSE 
                    COMMIT WORK
                    LET g_bmb[l_ac].ima532 = g_sma.sma30
                    DISPLAY g_bmb[l_ac].ima532 TO s_bmb[l_sl].ima532
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmb[l_ac].* = g_bmb_t.*   
               END IF
               CLOSE i607_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CALL i607_tot()           #No.MOD-6B0082 add
          #CKP
          #LET g_bmb_t.* = g_bmb[l_ac].*          # 900423
            CLOSE i607_bcl
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
  
        END INPUT
 
    CLOSE i607_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION i607_b_fill()
       #FOR g_cnt = 1 TO g_bmb.getLength()	
       #    INITIALIZE g_bmb[g_cnt].* TO NULL
       #    LET g_bmb[g_cnt].qpa   = 0
       #END FOR
        CALL g_bmb.clear()
	LET g_rec_b=0
	LET g_cnt = 1
	LET g_no  = 0
        CALL i607_bom(g_bma01,1,g_bma06) #FUN-550093
        #CKP
        CALL g_bmb.deleteElement(g_no+1)
        LET g_rec_b = g_no
        DISPLAY g_no TO FORMONLY.cn2  
END FUNCTION 
 
#Body Fill Up
FUNCTION i607_bom(p_item,p_totl,p_acode) #FUN-550093
DEFINE  l_sql    LIKE type_file.chr1000,      #No.FUN-680096 VARCHAR(400)
        p_item   LIKE bmb_file.bmb01,
        p_totl   LIKE bmb_file.bmb06,
        p_acode  LIKE bmb_file.bmb29,         #FUN-550093 
        l_i,l_k  LIKE type_file.num5,         #No.FUN-680096 SMALLINT
        l_cnt    LIKE type_file.num5,         #No.FUN-680096 SMALLINT
    	g_bmb2 DYNAMIC ARRAY OF RECORD	
               bma01   LIKE bma_file.bma01,
               seq     LIKE type_file.num10,  #No.FUN-680096 INTEGER
               ima01   LIKE ima_file.ima01,   # 料件編號
               ima02   LIKE ima_file.ima02,   # 品名
               ima021   LIKE ima_file.ima021, # 規格
              # Prog. Version..: '5.30.06-13.03.12(04),             # 購料特性
               ima103  LIKE ima_file.ima103,  # 購料特性
               qpa     LIKE bmb_file.bmb06,   # 組成用量
              #ima25   LIKE ima_file.ima25,   # 庫存單位 #MOD-5C0036 mark
               ima63   LIKE ima_file.ima63,   # 發料單位 #MOD-5C0036 modify
               ima44   LIKE ima_file.ima44,   # 採購單位 #MOD-5C0036 add
               ima53   LIKE ima_file.ima53,   # 採購單價
               imb218  LIKE imb_file.imb218,  # 平均單價
               ima531  LIKE ima_file.ima531,  # 市價    
               ima532  LIKE ima_file.ima532   # 異動日期
		END RECORD
    DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015
  
    #LET l_cnt = 1   # TQC-630105 add by Joe
    #LET g_cnt = 1   # TQC-920059 add by destiny
    LET l_cnt = 1    #MOD-8A0120 add
    LET l_sql = " SELECT bma01,'',bmb03,",
              #"  ima02,ima021,ima103,((bmb06/bmb07) * bmb10_fac),ima25,",      #MOD-5C0036 mark
               "  ima02,ima021,ima103,((bmb06/bmb07) * bmb10_fac),ima63,ima44,", #MOD-5C0036 modify
               "  ima53,imb218,ima531,ima532", 
               " FROM bmb_file,ima_file,OUTER bma_file, OUTER imb_file",
               " WHERE bmb_file.bmb03 = bma_file.bma01 AND ",
               "  bmb03= ima01 AND ",
               "  bmb_file.bmb03= imb_file.imb01 AND ",
               "  bmb29='",p_acode,"' AND ", #FUN-550093
               "  bmb01='",p_item,"'"
 
    #生效日及失效日的判斷
    IF tm.effective IS NOT NULL THEN
         LET l_sql=l_sql CLIPPED, " AND (bmb04 <='",tm.effective,
         "' OR bmb04 IS NULL) AND (bmb05 >'",tm.effective,
         "' OR bmb05 IS NULL)"
    END IF
    LET l_sql = l_sql clipped," ORDER BY bmb03 "
 
	PREPARE i607_pb FROM l_sql
	DECLARE i607_bcs
		CURSOR FOR i607_pb
 
	#FOREACH i607_bcs INTO g_bmb2[l_cnt].*  # TQC-630105 by Joe
	#FOREACH i607_bcs INTO g_bmb2[g_cnt].*  #MOD-8A0120 mark
	FOREACH i607_bcs INTO g_bmb2[l_cnt].*   #MOD-8A0120 
	  IF SQLCA.sqlcode THEN
             CALL cl_err('Foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
          END IF
          #FUN-8B0015--BEGIN--
          LET l_ima910[l_cnt]=''
          SELECT ima910 INTO l_ima910[l_cnt] FROM ima_file WHERE ima01=g_bmb2[l_cnt].ima01 
          IF cl_null(l_ima910[l_cnt]) THEN LET l_ima910[l_cnt]=' ' END IF
          #FUN-8B0015--END--  
        #LET l_cnt = l_cnt +1 # TQC-630105 by Joe
        LET l_cnt = l_cnt +1  # TQC-920059 by destiny
        LET g_cnt = g_cnt + 1 
        # TQC-630105----------start add by Joe
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
        # TQC-630105----------end add by Joe
   END FOREACH 
 
   #FOR l_k = 1 TO  l_cnt -1 # TQC-630105 by Joe      
   #FOR l_k = 1 TO  g_cnt -1 #MOD-8A0120 mark      
   FOR l_k = 1 TO  l_cnt -1  #MOD-8A0120      
     IF g_bmb2[l_k].bma01 IS NOT NULL THEN         #若為主件(有BOM單頭)
        #CALL i607_bom(g_bmb2[l_k].ima01,p_totl*g_bmb2[l_k].qpa,' ')           #FUN-8B0015
         CALL i607_bom(g_bmb2[l_k].ima01,p_totl*g_bmb2[l_k].qpa,l_ima910[l_k]) #FUN-8B0015
     ELSE 
        LET g_bmb2[l_k].qpa   = g_bmb2[l_k].qpa   * p_totl 
        FOR l_i = 1 TO 600  
        #IF g_bmb[l_i].ima01 = g_bmb2[l_k].ima01                                  #MOD-880153 mark 
         IF (g_bmb[l_i].ima01 = g_bmb2[l_k].ima01) OR cl_null(g_bmb2[l_k].ima01)  #MOD-880153
         THEN LET g_bmb[l_i].qpa   = g_bmb[l_i].qpa   + g_bmb2[l_k].qpa   
              EXIT FOR  
         ELSE 
              IF g_bmb[l_i].ima01 IS NULL OR 
                 g_bmb[l_i].ima01 = ' '
              THEN 
                 LET g_bmb[l_i].seq = l_i
                 LET g_bmb[l_i].ima01 = g_bmb2[l_k].ima01
                 LET g_bmb[l_i].ima02 = g_bmb2[l_k].ima02
                 LET g_bmb[l_i].ima021 = g_bmb2[l_k].ima021
                #CALL s_purdesc(g_bmb2[l_k].wdesc) 
                #RETURNING g_bmb[l_i].wdesc
                 LET g_bmb[l_i].ima103= g_bmb2[l_k].ima103
                 LET g_bmb[l_i].qpa   = g_bmb2[l_k].qpa  
                #LET g_bmb[l_i].ima25 = g_bmb2[l_k].ima25 # MOD-5C0036 mark
                 LET g_bmb[l_i].ima63 = g_bmb2[l_k].ima63 # MOD-5C0036 modify
                 LET g_bmb[l_i].ima44 = g_bmb2[l_k].ima44 # MOD-5C0036 add
                 LET g_bmb[l_i].ima53 = g_bmb2[l_k].ima53
                 LET g_bmb[l_i].imb218= g_bmb2[l_k].imb218
                 LET g_bmb[l_i].ima531= g_bmb2[l_k].ima531
                 LET g_bmb[l_i].ima532= g_bmb2[l_k].ima532
                 LET g_no = g_no + 1
                 EXIT FOR
              ELSE CONTINUE FOR 
              END IF
        END IF
        END FOR
     END IF
  END FOR
END FUNCTION
 
 
FUNCTION i607_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i607_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL i607_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump
         CALL i607_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL i607_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last
         CALL i607_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
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
    #@ON ACTION 合計
    # ON ACTION total
    #    LET g_action_choice="total"
    #    EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i607_tot()
 DEFINE l_k   LIKE type_file.num5,          #No.FUN-680096 SMALLINT
        l_cost1,l_cost2,l_cost3  LIKE ima_file.ima531 #MOD-530204
 
#  #UI
# OPEN WINDOW i607_w3 WITH FORM "abm/42f/abmi6072" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
# CALL cl_ui_locale("abmi6072")
 
  LET l_cost1 = 0  LET l_cost2 = 0 LET l_cost3 = 0
  FOR l_k = 1 TO g_no
      IF cl_null(g_bmb[l_k].qpa) THEN LET  g_bmb[l_k].qpa = 0 END IF
      IF cl_null(g_bmb[l_k].ima531) THEN LET  g_bmb[l_k].ima531 = 0 END IF
      CASE 
      #WHEN g_bmb[l_k].wdesc = '內購'
       WHEN g_bmb[l_k].ima103 ="0" #內購
            LET l_cost1 = l_cost1 + (g_bmb[l_k].qpa * g_bmb[l_k].ima531)
      #WHEN g_bmb[l_k].wdesc = '外購'
       WHEN g_bmb[l_k].ima103 ="1" #外購
            LET l_cost2 = l_cost2 + (g_bmb[l_k].qpa * g_bmb[l_k].ima531)
       OTHERWISE 
            LET l_cost3 = l_cost3 + (g_bmb[l_k].qpa * g_bmb[l_k].ima531)
      END CASE
  END FOR 
  IF cl_null(l_cost1) THEN LET l_cost1 = 0 END IF
  IF cl_null(l_cost2) THEN LET l_cost2 = 0 END IF
  IF cl_null(l_cost3) THEN LET l_cost3 = 0 END IF
  DISPLAY l_cost1 TO FORMONLY.cost1 
  DISPLAY l_cost2 TO FORMONLY.cost2 
  DISPLAY l_cost3 TO FORMONLY.cost3 
# CALL cl_anykey(0)
# CLOSE WINDOW i607_w3
END FUNCTION
#單頭
FUNCTION i6071_set_entry(p_one)
DEFINE   p_one     LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("revision",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i6071_set_no_entry(p_one)
DEFINE   p_one     LIKE type_file.chr1     #No.FUN-680096 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_one='N' THEN 
           CALL cl_set_comp_entry("revision",FALSE)
       END IF
   END IF
 
END FUNCTION
