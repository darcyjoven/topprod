# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: sabmi200.4gl
# Descriptions...: BOM 插件位置維護
# Date & Author..: 94/08/12 By Nick
# Modify.........: No.MOD-4B0191 04/11/18 By Mandy 插件位置是否勾稽是由參數設定(aimi100)來決定, 'Y'則不match不可離開
# Modify.........: No.FUN-510033 05/02/16 By Mandy 報表轉XML
# Modify.........: No.FUN-550014 05/05/16 By Mandy 特性BOM
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.TQC-660046 06/06/13 By xumin cl_err To cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0002 06/10/20 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.TQC-870018 08/07/11 By Jerry 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bmb           RECORD LIKE bmb_file.*,
    g_bmb_t         RECORD LIKE bmb_file.*,
    g_bmb01         LIKE bmb_file.bmb01,   #主件編號-1
    g_bmb29         LIKE bmb_file.bmb29,   #FUN-550014
    g_bmt02         LIKE bmt_file.bmt02,   #項次-2
    g_bmt03         LIKE bmt_file.bmt03,   #元件編號-3
    g_bmt04         LIKE bmt_file.bmt04,   #生效日-4
    g_bmt           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmt05       LIKE bmt_file.bmt05,   #行序
        bmt06       LIKE bmt_file.bmt06,   #插件位置
        bmt07       LIKE bmt_file.bmt07    #組成用量
                    END RECORD,
    g_bmt_t         RECORD                 #程式變數 (舊值)
        bmt05       LIKE bmt_file.bmt05,   #行序
        bmt06       LIKE bmt_file.bmt06,   #插件位置
        bmt07       LIKE bmt_file.bmt07    #組成用量
                    END RECORD,
       #g_wc,g_wc2,g_sql    STRING, #TQC-630166  
        g_wc,g_wc2,g_sql    STRING,    #TQC-630166
        g_flag              LIKE type_file.chr1,      #No.FUN-680096 VARCHAR(1)
        g_rec_b             LIKE type_file.num5,      #單身筆數     #No.FUN-680096 SMALLINT
        l_ac                LIKE type_file.num5,      #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
        #g_qpa              DEC(15,3),  #FUN-550106
       #g_qpa               DEC(9,5),   #FUN-550106
        g_qpa               LIKE bmb_file.bmb06,      #FUN-550106 #FUN-560227
       #tot                 DEC(9,5),
        tot                 LIKE bmb_file.bmb06,      #FUN-560227
        g_ima147            LIKE ima_file.ima147      #BugNo:6542
DEFINE  p_row,p_col         LIKE type_file.num5       #No.FUN-680096 SMALLINT
DEFINE  g_forupd_sql        STRING                    #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done STRING
DEFINE  g_cnt               LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE  g_i                 LIKE type_file.num5       #count/index for any /purpose   #No.FUN-680096 SMALLINT
DEFINE  g_msg               LIKE ze_file.ze03         #No.FUN-680096 VARCHAR(72)
DEFINE  g_row_count         LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE  g_curs_index        LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE  g_jump              LIKE type_file.num10      #No.FUN-680096 INTEGER
DEFINE  mi_no_ask           LIKE type_file.num5       #No.FUN-680096 SMALLINT
 
 
#主程式開始
FUNCTION i200(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7) #FUN-550014 add p_argv7
DEFINE
#       l_time    LIKE type_file.chr8	        #No.FUN-6A0060
    p_argv1         LIKE bmb_file.bmb01,
    p_argv2         LIKE bmt_file.bmt02,
    p_argv3	    LIKE bmt_file.bmt03,
    p_argv4	    LIKE bmt_file.bmt04,
    p_argv5         LIKE type_file.chr1,     #'a'/'u' #No.FUN-680096 VARCHAR(1)
    p_argv6         LIKE bmb_file.bmb06,
    p_argv7         LIKE bmb_file.bmb29      #FUN-550014
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    LET g_bmb01  = p_argv1	           #主件編號
    LET g_bmb29  = p_argv7	           #FUN-550014
    LET g_bmt02  = p_argv2	           #項次
    LET g_bmt03  = p_argv3	           #元件
    LET g_bmt04  = p_argv4	           #生效日
    LET g_qpa    = p_argv6                 #QPA
 
    LET p_row = 6 LET p_col = 34
    OPEN WINDOW i200_w AT p_row,p_col WITH FORM "abm/42f/abmi200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("abmi200")
 
    CALL g_bmt.clear()
 
    SELECT ima147 INTO g_ima147 #BugNo:6542
      FROM ima_file
     WHERE ima01 = g_bmt03
     LET g_rec_b = 0
    IF g_bmb01 IS NOT NULL AND g_bmb01 != ' ' AND
       g_bmt02 IS NOT NULL AND g_bmt02 != ' ' AND
       g_bmt03 IS NOT NULL AND g_bmt03 != ' ' AND
       g_bmt04 IS NOT NULL AND g_bmt04 != ' '
       THEN IF p_argv5 = 'u' THEN
                 CALL i200_q()
            ELSE LET g_bmb.bmb06 = g_qpa
                 DISPLAY BY NAME g_bmb.bmb06
            END IF
            CALL i200_b()
    CALL i200_menu()
    END IF
    CLOSE WINDOW i200_w                 #結束畫面
END FUNCTION
 
#QBE 查詢資料
FUNCTION i200_cs()
    CLEAR FORM                             #清除畫面
    CALL g_bmt.clear()
 
     LET g_wc = " bmt01 ='",g_bmb01,"'",
                " AND bmt08 ='",g_bmb29,"'", #FUN-550014
                " AND bmt02 =",g_bmt02,
                " AND bmt03 ='",g_bmt03,"'",
                " AND bmt04 ='",g_bmt04,"'"
    IF INT_FLAG THEN RETURN END IF
 
    IF g_flag = 'N' THEN
   INITIALIZE g_bmb01 TO NULL    #No.FUN-750051
       CONSTRUCT g_wc2 ON bmt05,bmt06,bmt07       # 螢幕上取單身條件
                FROM s_bmt[1].bmt05,s_bmt[1].bmt06,s_bmt[1].bmt07
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
        IF INT_FLAG THEN RETURN END IF
    ELSE LET g_wc2 = " 1=1"
    END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  bmt01,bmt08,bmt02,bmt03,bmt04 FROM bmt_file ",#TQC-870018         #FUN-550014
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY bmt01,bmt08,bmt02 "
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE bmt01,bmt08,bmt02,bmt03,bmt04 ", #TQC-870018   #FUN-550014
                   "  FROM bmt_file ",
                   " WHERE ", g_wc CLIPPED,
	           "   AND ",g_wc2 CLIPPED,
                   " ORDER BY bmt01,bmt08,bmt02 "                                                   #FUN-550014
    END IF
 
    PREPARE i200_prepare FROM g_sql
    DECLARE i200_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i200_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bmt_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT UNIQUE COUNT(*) ",
                  " FROM bmt_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    PREPARE i200_precount FROM g_sql
    DECLARE i200_count CURSOR FOR i200_precount
END FUNCTION
 
FUNCTION i200_menu()
 
   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i200_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmb.* TO NULL             #No.FUN-6A0002
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bmt.clear()
    CALL i200_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_bmb.* TO NULL
        RETURN
    END IF
    OPEN i200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL
    ELSE
        OPEN i200_count
        FETCH i200_count INTO g_row_count
        CALL i200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i200_fetch(p_flag)
DEFINE
    p_flag    LIKE type_file.chr1      #處理方式     #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i200_cs INTO g_bmb01,
                                                              g_bmb29, #FUN-550014 add
                                                              g_bmt02,
                                                              g_bmt03,
                                                              g_bmt04 #TQC-870018
        WHEN 'P' FETCH PREVIOUS i200_cs INTO g_bmb01,
                                                              g_bmb29, #FUN-550014 add
                                                              g_bmt02,
                                                              g_bmt03,
                                                              g_bmt04 #TQC-870018
        WHEN 'F' FETCH FIRST    i200_cs INTO g_bmb01,
                                                              g_bmb29, #FUN-550014 add
                                                              g_bmt02,
                                                              g_bmt03,
                                                              g_bmt04 #TQC-870018
        WHEN 'L' FETCH LAST     i200_cs INTO g_bmb01,
                                                              g_bmb29, #FUN-550014 add
                                                              g_bmt02,
                                                              g_bmt03,
                                                              g_bmt04 #TQC-870018
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
            FETCH ABSOLUTE g_jump i200_cs INTO g_bmb01,
                                                              g_bmb29, #FUN-550014 add
                                                              g_bmt02,
                                                              g_bmt03,
                                                              g_bmt04 #TQC-870018
    END CASE
 
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb01 CLIPPED,'+',g_bmt02
                  CLIPPED,'+',g_bmt03 CLIPPED,'+',g_bmt04
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL  #TQC-6B0105
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
    IF SQLCA.sqlcode THEN
        LET g_msg=g_bmb01 CLIPPED,'+',g_bmt02
                  CLIPPED,'+',g_bmt03 CLIPPED,'+',g_bmt04
    #   CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660046
        CALL cl_err3("sel","bmt_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
        INITIALIZE g_bmb.* TO NULL
        RETURN
    END IF
 
    CALL i200_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i200_show()
    LET g_bmb_t.* = g_bmb.*                #保存單頭舊值
    LET g_bmb.bmb06 = g_qpa
    DISPLAY BY NAME g_bmb.bmb06
    CALL i200_b_fill(g_wc2)   #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680096 SMALLINT
    l_i             LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否        #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680096 VARCHAR(1)
    l_k             LIKE type_file.num5,      #No.FUN-680096 SMALLINT
    l_tot           LIKE bmb_file.bmb06,
    l_amt           LIKE bmb_file.bmb06,
    l_allow_insert  LIKE type_file.num5,      #No.FUN-680096 VARCHAR(1)
    l_allow_delete  LIKE type_file.num5,      #No.FUN-680096 VARCHAR(1)
    fld_name        LIKE type_file.chr20,     #No.FUN-680096 VARCHAR(18)
    frm_name        LIKE type_file.chr8       #No.FUN-680096 VARCHAR(7)
 
    LET g_action_choice = ""
 
    IF s_shut(0)  THEN RETURN END IF
    IF g_bmb01 IS NULL THEN
        RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bmt05,bmt06,bmt07 FROM bmt_file",
                       "  WHERE bmt01=? ",
                       "   AND bmt02=? ",
                       "   AND bmt03=? ",
                       "   AND bmt04=? ",
                       "   AND bmt05=? ",
                       "   AND bmt08=? FOR UPDATE" #FUN-550014 add bmt08
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET tot = 0
     WHILE TRUE #MOD-4B0191(ADD WHILE....END WHILE)
        INPUT ARRAY g_bmt WITHOUT DEFAULTS FROM s_bmt.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bmt_t.* = g_bmt[l_ac].*  #BACKUP
               LET p_cmd='u'
#No.FUN-570110 --start--
               LET g_before_input_done = FALSE
               CALL i200_set_entry(p_cmd)
               CALL i200_set_no_entry(p_cmd)
               LET g_before_input_done = TRUE
#No.FUN-570110 --end--
               BEGIN WORK
               OPEN i200_b_cl USING g_bmb01,g_bmt02,g_bmt03,g_bmt04,g_bmt_t.bmt05,g_bmb29  #FUN-550014 add bmb29
               IF STATUS THEN
                  CALL cl_err("OPEN i200_b_cl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i200_b_cl INTO g_bmt[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bmt_t.bmt05,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                 #LET g_before_input_done = FALSE
                 #CALL i200_set_entry(p_cmd)
                 #CALL i200_set_no_entry(p_cmd)
                 #LET g_before_input_done = TRUE
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmt05
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--
            LET g_before_input_done = FALSE
            CALL i200_set_entry(p_cmd)
            CALL i200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570110 --end--
            INITIALIZE g_bmt[l_ac].* TO NULL      #900423
            LET g_bmt_t.* = g_bmt[l_ac].*         #新輸入資料
            LET g_bmt[l_ac].bmt07 = 1
           #LET g_before_input_done = FALSE
           #CALL i200_set_entry(p_cmd)
           #CALL i200_set_no_entry(p_cmd)
           #LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmt05
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
         IF g_bmt[l_ac].bmt05 > 0 THEN
            #CHI-790004..................begin
            IF cl_null(g_bmt02) THEN
               LET g_bmt02=0
            END IF
            #CHI-790004..................end
            INSERT INTO bmt_file(bmt01,bmt02,bmt03,
                                 bmt04,bmt05,bmt06,bmt07,bmt08) #FUN-550014 add bmt08
            VALUES(g_bmb01,g_bmt02,g_bmt03,
                   g_bmt04,g_bmt[l_ac].bmt05,g_bmt[l_ac].bmt06,
                   g_bmt[l_ac].bmt07,g_bmb29) #FUN-550014
            IF SQLCA.sqlcode THEN
          #     CALL cl_err(g_bmt[l_ac].bmt05,SQLCA.sqlcode,0) #No.TQC-660046
                CALL cl_err3("ins","bmt_file",g_bmb01,g_bmt02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                  #CKP
                  ROLLBACK WORK
                  CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
         END IF
 
        BEFORE FIELD bmt05                        #default 序號
           #CALL i200_set_entry(p_cmd)
            IF g_bmt[l_ac].bmt05 IS NULL OR
               g_bmt[l_ac].bmt05 = 0
            THEN
                SELECT max(bmt05)
                   INTO g_bmt[l_ac].bmt05
                   FROM bmt_file
                   WHERE bmt01 = g_bmb01
                     AND bmt02 = g_bmt02
                     AND bmt03 = g_bmt03
                     AND bmt04 = g_bmt04
                     AND bmt08 = g_bmb29 #FUN-550014 add
                IF g_bmt[l_ac].bmt05 IS NULL THEN
                    LET g_bmt[l_ac].bmt05 = 0
                END IF
                LET g_bmt[l_ac].bmt05 = g_bmt[l_ac].bmt05 + g_sma.sma19
            END IF
 
        AFTER FIELD bmt05                        #check 序號是否重複
            IF g_bmt[l_ac].bmt05 IS NOT NULL THEN
            IF g_bmt[l_ac].bmt05 != g_bmt_t.bmt05 OR
               g_bmt_t.bmt05 IS NULL THEN
                SELECT count(*)
                    INTO l_n
                    FROM bmt_file
                    WHERE bmt01 = g_bmb01
                      AND bmt02 = g_bmt02
                      AND bmt03 = g_bmt03
                      AND bmt04 = g_bmt04
                      AND bmt05 = g_bmt[l_ac].bmt05
                      AND bmt08 = g_bmb29 #FUN-550014 add
                IF l_n > 0 THEN
                    CALL cl_err(g_bmt[l_ac].bmt05,-239,0)
                    LET g_bmt[l_ac].bmt05 = g_bmt_t.bmt05
                    NEXT FIELD bmt05
                END IF
            END IF
            END IF
           #CALL i200_set_no_entry(p_cmd)
 
 
        AFTER FIELD bmt06
            IF NOT cl_null(g_bmt[l_ac].bmt06) THEN
            IF g_bmt_t.bmt06 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM bmt_file
                WHERE bmt01 = g_bmb01
                  AND bmt02 = g_bmt02
                  AND bmt03 = g_bmt03
                  AND bmt04 = g_bmt04
                  AND bmt06=g_bmt[l_ac].bmt06
                  AND bmt08 = g_bmb29 #FUN-550014 add
               IF l_n>0 THEN CALL cl_err('',-239,0) NEXT FIELD bmt06 END IF
            END IF
            END IF
 
 
        #BugNo:6002
        BEFORE FIELD bmt07
            IF cl_null(g_bmt[l_ac].bmt07) THEN
                LET g_bmt[l_ac].bmt07 = 1
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bmt[l_ac].bmt07
                #------MOD-5A0095 END------------
            END IF
        AFTER FIELD bmt07
            IF NOT cl_null(g_bmt[l_ac].bmt07) THEN
               IF g_bmt[l_ac].bmt07 <=0 THEN NEXT FIELD bmt07 END IF
            IF g_bmt[l_ac].bmt07 > g_bmb.bmb06 AND g_ima147='Y'    #no.6542
            THEN CALL cl_err(g_bmt_t.bmt07,'mfg2766',0)
                 NEXT FIELD bmt07
            END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmt_t.bmt05 > 0 AND
               g_bmt_t.bmt05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                DELETE FROM bmt_file
                    WHERE bmt01 = g_bmb01
                      AND bmt02 = g_bmt02
                      AND bmt03 = g_bmt03
                      AND bmt04 = g_bmt04
                      AND bmt05 = g_bmt_t.bmt05
                      AND bmt08 = g_bmb29 #FUN-550014 add bmt08
                IF SQLCA.sqlcode THEN
           #        CALL cl_err(g_bmt_t.bmt05,SQLCA.sqlcode,0) #No.TQC-660046
                    CALL cl_err3("del","bmt_file",g_bmb01,g_bmt02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete OK"
                CLOSE i200_b_cl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bmt[l_ac].* = g_bmt_t.*
              CLOSE i200_b_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bmt[l_ac].bmt05,-263,1)
              LET g_bmt[l_ac].* = g_bmt_t.*
           ELSE
              IF g_bmt[l_ac].bmt05 >= 0 THEN
              UPDATE bmt_file SET
                  bmt05=g_bmt[l_ac].bmt05,
                  bmt06=g_bmt[l_ac].bmt06,
                  bmt07=g_bmt[l_ac].bmt07
               WHERE bmt01= g_bmb01
                 AND bmt02= g_bmt02
                 AND bmt03= g_bmt03
                 AND bmt04= g_bmt04
                 AND bmt05=g_bmt_t.bmt05
                 AND bmt08= g_bmb29  #FUN-550014
              IF SQLCA.sqlcode THEN
             #    CALL cl_err(g_bmt[l_ac].bmt05,SQLCA.sqlcode,0) #No.TQC-660046
                  CALL cl_err3("del","bmt_file",g_bmb01,g_bmt02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                  LET g_bmt[l_ac].* = g_bmt_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i200_b_cl
 		  COMMIT WORK
              END IF
              END IF
          END IF
 
        AFTER ROW
            LET l_tot = 0
            FOR l_k = 1  TO g_bmt.getLength()
               IF cl_null(g_bmt[l_k].bmt06) THEN  EXIT FOR END IF
               LET l_tot = l_tot + g_bmt[l_k].bmt07
            END FOR
            DISPLAY l_tot TO FORMONLY.tot
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmt[l_ac].* = g_bmt_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmt.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i200_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
          #LET g_bmt_t.* = g_bmt[l_ac].*          # 900423
            LET l_ac_t = l_ac
            CLOSE i200_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i200_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmt05) AND l_ac > 1 THEN
                LET g_bmt[l_ac].* = g_bmt[l_ac-1].*
                NEXT FIELD bmt05
            END IF
 
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
 
        END INPUT
        CALL i200_chk_QPA()
     #MOD-4B0191
        IF cl_null(g_errno) THEN
            EXIT WHILE
        ELSE
            CONTINUE WHILE
        END IF
    END WHILE
     #MOD-4B0191(end)
 
    CLOSE i200_b_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i200_b_askkey()
DEFINE
   #l_wc2           STRING #TQC-630166        #No.FUN-680096
    l_wc2           STRING    #TQC-630166
 
    CALL g_bmt.clear()
    CONSTRUCT l_wc2 ON bmt05,bmt06,bmt07
            FROM s_bmt[1].bmt05,s_bmt[1].bmt06,s_bmt[1].bmt07
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
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   #p_wc2           STRING #TQC-630166 
    p_wc2           STRING    #TQC-630166
 
    LET g_sql =
        "SELECT bmt05,bmt06,bmt07",
        " FROM bmt_file",
        " WHERE bmt01 ='",g_bmb01,"' AND",  #單頭-1
              " bmt08 ='",g_bmb29,"' AND",  #FUN-550014
              " bmt02 = ",g_bmt02,"  AND",  #單頭-2
              " bmt03 ='",g_bmt03,"' AND",  #單頭-3
              " bmt04 ='",g_bmt04,"' AND ", #單頭-4
        p_wc2 CLIPPED,                           #單身
        " ORDER BY 1"
    PREPARE i200_pb FROM g_sql
    DECLARE bmt_cs                       #CURSOR
        CURSOR FOR i200_pb
 
    CALL g_bmt.clear()
    LET g_cnt 	= 1
    LET g_rec_b = 0
	LET tot		= 0
    FOREACH bmt_cs INTO g_bmt[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
		LET tot	= tot + g_bmt[g_cnt].bmt07
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_bmt.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY tot TO FORMONLY.tot	
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmt TO s_bmt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i200_out()
DEFINE
    l_prog_t        LIKE type_file.chr20,  #No.FUN-680096 VARCHAR(10)
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmb01       LIKE bmb_file.bmb01,   #主件編號
        bmb02       LIKE bmb_file.bmb02,   #項次
        bmb03       LIKE bmb_file.bmb03,   #元件編號
        bmb04       LIKE bmb_file.bmb04,   #生效日
        bmt05       LIKE bmt_file.bmt05,   #行序
        bmt06       LIKE bmt_file.bmt06,   #說明
		bmt07		LIKE bmt_file.bmt07
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
 
    IF g_wc IS NULL THEN
      # CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    LET l_prog_t = g_prog
    LET g_prog = 'abmi200'
    CALL cl_outnam('abmi200') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT bmb01,bmb02,bmb03,bmb04,bmt05,bmt06,bmt07 ",
          " FROM bmb_file,bmt_file ",
          " WHERE bmt01=bmb01 AND bmt02=bmb02 ",
          " AND   bmt08=bmb29 ", #FUN-550014
          " AND bmt03=bmb03 AND bmt04=bmb04 ",
          " AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i200_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i200_co                         # CURSOR
        CURSOR FOR i200_p1
 
    START REPORT i200_rep TO l_name
 
    FOREACH i200_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i200_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i200_rep
 
    CLOSE i200_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
    LET g_prog = l_prog_t
END FUNCTION
 
REPORT i200_rep(sr)
DEFINE
    l_ima02_bmb01   LIKE ima_file.ima02,   #FUN-510033
    l_ima021_bmb01  LIKE ima_file.ima021,  #FUN-510033
    l_ima02_bmb03   LIKE ima_file.ima02,   #FUN-510033
    l_ima021_bmb03  LIKE ima_file.ima021,  #FUN-510033
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        bmb01       LIKE bmb_file.bmb01,   #主件編號
        bmb02       LIKE bmb_file.bmb02,   #項次
        bmb03       LIKE bmb_file.bmb03,   #元件編號
        bmb04       LIKE bmb_file.bmb04,   #生效日
        bmt05       LIKE bmt_file.bmt05,   #行序
        bmt06       LIKE bmt_file.bmt06,   #說明
        bmt07       LIKE bmt_file.bmt07    #說明
                    END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmt05
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT ' '
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39]
            PRINTX name=H2 g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.bmb04  #項次
            LET g_cnt=1
            SELECT ima02,ima021 INTO l_ima02_bmb01,l_ima021_bmb01
              FROM ima_file
             WHERE ima01=sr.bmb01
            SELECT ima02,ima021 INTO l_ima02_bmb03,l_ima021_bmb03
              FROM ima_file
             WHERE ima01=sr.bmb03
            PRINTX name=D1 COLUMN g_c[31],sr.bmb01 CLIPPED,
	                   COLUMN g_c[32],l_ima02_bmb01,
	                   COLUMN g_c[33],sr.bmb02 using '###&',
                           COLUMN g_c[34],sr.bmb03 CLIPPED,
	                   COLUMN g_c[35],l_ima02_bmb03,
		           COLUMN g_c[36],sr.bmb04 CLIPPED
            PRINTX name=D2 COLUMN g_c[40],' ',
                           COLUMN g_c[41],l_ima021_bmb01,
                           COLUMN g_c[42],' ',
                           COLUMN g_c[43],' ',
                           COLUMN g_c[44],l_ima021_bmb03
	ON EVERY ROW
	    PRINTX name=D1 COLUMN g_c[37],sr.bmt05 using '###&',
		           COLUMN g_c[38],sr.bmt06 CLIPPED,
		           #COLUMN g_c[39],cl_numfor(sr.bmt07,39,3)   #FUN-550106
		           COLUMN g_c[39],cl_numfor(sr.bmt07,39,5)   #FUN-550106
	
        ON LAST ROW
            PRINT g_dash
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN#IF g_wc[001,080] > ' ' THEN
		   #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
		   #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
                    PRINT g_dash[1,g_len]
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
FUNCTION i200_chk_QPA()
    DEFINE l_i LIKE type_file.num10   #No.FUN-680096 INTEGER
        LET tot = 0
        FOR l_i = 1 TO g_bmt.getLength()
            IF cl_null(g_bmt[l_i].bmt07) THEN
                EXIT FOR
            END IF
            LET tot   = tot   + g_bmt[l_i].bmt07
        END FOR
        DISPLAY tot TO FORMONLY.tot
        LET g_errno = NULL
        IF g_ima147 = 'Y' AND (tot != g_qpa) THEN
            CALL cl_err(tot,'mfg2765',0)
            LET g_errno = 'mfg2765'
        END IF
END FUNCTION
 
FUNCTION i200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
#No.FUN-570110 --start--
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bmt05",TRUE)
   END IF
#No.FUN-570110 --end--
    IF INFIELD(bmt05) OR ( NOT g_before_input_done ) THEN
         CALL cl_set_comp_entry("bmt06",TRUE)
    END IF
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
#No.FUN-570110 --start--
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
      CALL cl_set_comp_entry("bmt05",FALSE)
    END IF
#No.FUN-570110 --end--
    IF INFIELD(bmt05) OR ( NOT g_before_input_done ) THEN
       IF g_bmt[l_ac].bmt05 = 0 THEN
          CALL cl_set_comp_entry("bmt06",FALSE)
       END IF
    END IF
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #
#Patch....NO.TQC-610035 <001> #
