# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: sggli604.4gl
# Descriptions...: 股東權益期初導入/餘額查詢維護作業
# Date & Author..: 11/06/29 By lixiang (FUN-B60144)
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"     #FUN-BB0037
 
#模組變數(Module Variables)
DEFINE
    g_atq15           LIKE atq_file.atq15,
    g_atq15_t         LIKE atq_file.atq15,   
    g_atq01           LIKE atq_file.atq01,
    g_atq01_t         LIKE atq_file.atq01,
    g_atq02           LIKE atq_file.atq02,
    g_atq02_t         LIKE atq_file.atq02,
    g_atq             DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        atq17         LIKE atq_file.atq17,
        ats02         LIKE ats_file.ats02,
        atq19         LIKE atq_file.atq19,
        atn02         LIKE atn_file.atn02,
        atq18         LIKE atq_file.atq18,
        atq20         LIKE atq_file.atq20
                      END RECORD,
    g_atq_t           RECORD                 #程式變數 (舊值)
        atq17         LIKE atq_file.atq17,
        ats02         LIKE ats_file.ats02,
        atq19         LIKE atq_file.atq19,
        atn02         LIKE atn_file.atn02,
        atq18         LIKE atq_file.atq18,
        atq20         LIKE atq_file.atq20
                      END RECORD,
    a                 LIKE type_file.chr1,
    g_wc,g_sql        STRING,
    g_show            LIKE type_file.chr1,   
    g_rec_b           LIKE type_file.num5,   #單身筆數
    g_flag            LIKE type_file.chr1,   
    g_ss              LIKE type_file.chr1,   
    l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT
    g_argv1           LIKE atq_file.atq14,
    g_argv2           LIKE atq_file.atq15,
    g_argv3           LIKE atq_file.atq16,
    g_argv4           LIKE atq_file.atq01,
    g_argv5           LIKE atq_file.atq02, 
    g_argv6           LIKE type_file.chr1
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098  SMALLINT
#主程式開始
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_msg         LIKE ze_file.ze03  #No.FUN-680098    VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680098  INTEGER
DEFINE   g_curs_index  LIKE type_file.num10    #No.FUN-680098  INTEGER

FUNCTION i006(p_argv1)
 DEFINE p_argv1       LIKE type_file.chr1
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   WHENEVER ERROR CALL cl_err_msg_log

   LET g_argv6 = p_argv1
   CASE
      WHEN g_argv6 = '1'
         LET g_prog = 'ggli604'
      WHEN g_argv6 = '2'
         LET g_prog = 'ggli6041'
   END CASE
 
   LET g_argv1 =ARG_VAL(1)
   LET g_argv2 =ARG_VAL(2)
   LET g_argv3 =ARG_VAL(3)
   LET g_argv4 =ARG_VAL(4)
   LET g_argv5 =ARG_VAL(5)
 
   LET p_row = 3 LET p_col = 16
 
   OPEN WINDOW i006_w AT p_row,p_col
     WITH FORM "ggl/42f/ggli604"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()

   CALL cl_set_comp_visible("atq20",FALSE)
 
   IF (NOT cl_null(g_argv1)) AND (NOT cl_null(g_argv2)) AND
      (NOT cl_null(g_argv3)) AND (NOT cl_null(g_argv4)) AND
      (NOT cl_null(g_argv5)) THEN
      CALL i006_q()
   END IF   
   CALL i006_menu()
 
   CLOSE WINDOW i006_w                 #結束畫面
END FUNCTION 
 
#QBE 查詢資料
FUNCTION i006_cs()
DEFINE l_sql STRING
DEFINE
    l_atq20     LIKE atq_file.atq20

    IF g_argv6 = '1' THEN
       LET l_atq20 = 'Y'
    ELSE
       LET l_atq20 = 'N'
    END IF 
   IF (NOT cl_null(g_argv2)) AND
      (NOT cl_null(g_argv4)) AND
      (NOT cl_null(g_argv5)) THEN
       LET g_wc = "     atq15 = '",g_argv2,"'",
                  " AND atq01 = '",g_argv4,"'",
                  " AND atq02 = '",g_argv5,"'"
    ELSE
       CLEAR FORM                            #清除畫面
       CALL g_atq.clear()
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
       INITIALIZE g_atq15 TO NULL
       INITIALIZE g_atq01 TO NULL
       INITIALIZE g_atq02 TO NULL
       CONSTRUCT g_wc ON atq15,atq01,atq02,atq17,atq19,atq18
          FROM atq15,atq01,atq02,s_atq[1].atq17,s_atq[1].atq19,s_atq[1].atq18
 
       #No.FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(atq15)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form  = "q_atq15"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO atq15
                NEXT FIELD atq15
             WHEN INFIELD(atq17)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                IF g_argv6 = '1' THEN
                   LET g_qryparam.form = "q_ats01"
                ELSE
                   LET g_qryparam.form = "q_ats02"
                END IF
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_atq[1].atq17
                NEXT FIELD atq17
            WHEN INFIELD(atq19)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form  = "q_atn"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_atq[1].atq19
                NEXT FIELD atq19  
          END CASE
          
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('atquser', 'atqgrup') #FUN-980030
 
       IF INT_FLAG THEN
          RETURN
       END IF
    END IF
 
    IF cl_null(g_wc) THEN
       LET g_wc="1=1"
    END IF
    
    LET l_sql="SELECT UNIQUE atq15,atq01,atq02 FROM atq_file ",
               " WHERE ", g_wc CLIPPED,
               " AND atq20='",l_atq20,"' "    
    LET g_sql= l_sql," ORDER BY atq15,atq01,atq02"
    PREPARE i006_prepare FROM g_sql      #預備一下
    DECLARE i006_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i006_prepare
 
    DROP TABLE i006_cnttmp
#   LET l_sql=l_sql," INTO TEMP i006_cnttmp"      #No.TQC-720019
    LET g_sql_tmp=l_sql," INTO TEMP i006_cnttmp"  #No.TQC-720019
    
#   PREPARE i006_cnttmp_pre FROM l_sql       #No.TQC-720019
    PREPARE i006_cnttmp_pre FROM g_sql_tmp   #No.TQC-720019
    EXECUTE i006_cnttmp_pre    
    
    LET g_sql="SELECT COUNT(*) FROM i006_cnttmp"
 
    PREPARE i006_precount FROM g_sql
    DECLARE i006_count CURSOR FOR i006_precount
 
    IF NOT cl_null(g_argv2) THEN
       LET g_atq15=g_argv2
    END IF
 
    IF NOT cl_null(g_argv4) THEN
       LET g_atq01=g_argv4
    END IF
 
    IF NOT cl_null(g_argv5) THEN
       LET g_atq02=g_argv5
    END IF
    CALL i006_show()
END FUNCTION
 
FUNCTION i006_menu()
 
   WHILE TRUE
      CALL i006_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i006_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i006_q()
            END IF
           WHEN "delete" 
              IF cl_chk_act_auth() THEN
                 CALL i006_r()
              END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i006_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i006_out()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),
                base.TypeInfo.create(g_atq),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_atq15 IS NOT NULL THEN
                LET g_doc.column1 = "atq15"
                LET g_doc.value1 = g_atq15
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_atq.clear()
   LET g_atq15_t  = NULL
   LET g_atq01_t  = NULL
   LET g_atq02_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i006_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_atq15=NULL
         LET g_atq01=NULL
         LET g_atq02=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_atq.clear()
      ELSE
         CALL i006_b_fill('1=1')            #單身
      END IF
 
      CALL i006_b()                      #輸入單身
 
      LET g_atq15_t = g_atq15
      LET g_atq01_t = g_atq01
      LET g_atq02_t = g_atq02
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i006_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
    l_cnt           LIKE type_file.num10,
    li_result       LIKE type_file.num5,
    l_atq20         LIKE atq_file.atq20

    IF g_argv6 = '1' THEN
       LET l_atq20 = 'Y'
    ELSE
       LET l_atq20 = 'N'
    END IF
    LET g_ss='Y'
 
    CALL cl_set_head_visible("","YES")         #No.FUN-6B0029 
 
    INPUT g_atq15,g_atq01,g_atq02 WITHOUT DEFAULTS
        FROM atq15,atq01,atq02
 
      #AFTER FIELD atq14
      #   CALL i006_chk_atq14(g_atq14) 
      #        RETURNING li_result,g_atq15,g_atq16
      #   DISPLAY i006_set_asg02(g_atq14) TO FORMONLY.asg02
      #   DISPLAY g_atq15 TO atq15
      #   DISPLAY g_atq16 TO atq16
      #   IF NOT li_result THEN
      #      NEXT FIELD CURRENT
      #   END IF
      
       AFTER FIELD atq15
          SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=g_atq15
          IF l_cnt=0 THEN
             CALL cl_err(g_atq15,100,0)
             LET g_atq15=NULL
             NEXT FIELD atq15
          END IF
 
       AFTER FIELD atq02
          IF (NOT cl_null(g_atq15)) OR
             (NOT cl_null(g_atq01)) OR
             (NOT cl_null(g_atq02)) THEN
             LET l_cnt=0             
             SELECT COUNT(*) INTO l_cnt FROM atq_file
                                       WHERE atq15=g_atq15
                                         AND atq01=g_atq01
                                         AND atq02=g_atq02
                                         AND atq20=l_atq20
            IF l_cnt>0 THEN
               CALL cl_err('','-239',1)
               NEXT FIELD atq02
            END IF
          END IF
       
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(atq15)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aaa"
                CALL cl_create_qry() RETURNING g_atq15
                DISPLAY g_atq15 TO atq15
                NEXT FIELD atq15
          END CASE

       ON ACTION CONTROLG
         CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
    END INPUT
 
END FUNCTION
 
FUNCTION i006_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_atq15,g_atq01,g_atq02 TO NULL
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_atq.clear()
   DISPLAY '' TO FORMONLY.cnt
 
   CALL i006_cs()                      #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_atq15,g_atq01,g_atq02 TO NULL
      RETURN
   END IF
 
   OPEN i006_bcs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_atq15,g_atq01,g_atq02 TO NULL
   ELSE
      OPEN i006_count
      FETCH i006_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i006_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i006_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,   #處理方式
   l_abso          LIKE type_file.num10   #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i006_bcs INTO g_atq15,
                                             g_atq01,g_atq02
       WHEN 'P' FETCH PREVIOUS i006_bcs INTO g_atq15,
                                             g_atq01,g_atq02
       WHEN 'F' FETCH FIRST    i006_bcs INTO g_atq15,
                                             g_atq01,g_atq02
       WHEN 'L' FETCH LAST     i006_bcs INTO g_atq15,
                                             g_atq01,g_atq02
       WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
              
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
              
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
              
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
              
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            FETCH ABSOLUTE l_abso i006_bcs INTO g_atq15,
                                                g_atq01,g_atq02
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_atq15,SQLCA.sqlcode,0)
      INITIALIZE g_atq15 TO NULL
      INITIALIZE g_atq01 TO NULL
      INITIALIZE g_atq02 TO NULL
   ELSE
      CALL i006_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = l_abso
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i006_show()
 
   DISPLAY g_atq15 TO atq15
   DISPLAY g_atq01 TO atq01
   DISPLAY g_atq02 TO atq02
 
   CALL i006_b_fill(g_wc)                      #單身
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i006_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT
   l_n             LIKE type_file.num5,          #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否       
   p_cmd           LIKE type_file.chr1,          #處理狀態         
   l_allow_insert  LIKE type_file.num5,          #可新增否         
   l_allow_delete  LIKE type_file.num5,          #可刪除否         
   l_cnt           LIKE type_file.num10,         #No.FUN-680098
   l_atq20         LIKE atq_file.atq20
   LET g_action_choice = ""
 
   IF cl_null(g_atq15) OR
      cl_null(g_atq01) OR
      cl_null(g_atq02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   IF g_argv6 = '1' THEN
      LET l_atq20 = 'Y'
   ELSE
      LET l_atq20 = 'N'
   END IF
   IF s_shut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT atq17,'',atq19,'',atq18,atq20 FROM atq_file",
                      "  WHERE atq15= ? ",
                      "   AND atq01 = ? AND atq02= ? AND atq17= ? ",
                      "   FOR UPDATE "
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i006_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_atq.clear() END IF
 
   INPUT ARRAY g_atq WITHOUT DEFAULTS FROM s_atq.*
 
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_atq_t.* = g_atq[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN i006_bcl USING g_atq15,g_atq01,g_atq02,
                                g_atq[l_ac].atq17
            IF STATUS THEN
               CALL cl_err("OPEN i006_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i006_bcl INTO g_atq[l_ac].*
               IF STATUS THEN
                  CALL cl_err("OPEN i006_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_atq[l_ac].ats02=i006_set_ats02(g_atq[l_ac].atq17)
                  LET g_atq[l_ac].atn02=i006_set_atn02(g_atq[l_ac].atq19)
                  LET g_atq_t.*=g_atq[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_atq[l_ac].* TO NULL            #900423
         IF g_argv6 = '1' THEN
            LET g_atq[l_ac].atq20 = 'Y'
         ELSE
            LET g_atq[l_ac].atq20 = 'N'
         END IF
         LET g_atq_t.* = g_atq[l_ac].*               #新輸入資料
         LET g_atq[l_ac].atq18=0
         CALL cl_show_fld_cont()
         NEXT FIELD atq17
 
      AFTER FIELD atq17                         # check data 是否重複
         IF NOT cl_null(g_atq[l_ac].atq17) THEN
            IF NOT i006_chk_atq17() THEN
               LET g_atq[l_ac].atq17=g_atq_t.atq17
               LET g_atq[l_ac].ats02=i006_set_ats02(g_atq[l_ac].atq17)
               DISPLAY BY NAME g_atq[l_ac].atq17,g_atq[l_ac].ats02
               NEXT FIELD CURRENT
            END IF
            LET g_atq[l_ac].ats02=i006_set_ats02(g_atq[l_ac].atq17)
            DISPLAY BY NAME g_atq[l_ac].ats02
            IF g_atq[l_ac].atq17 != g_atq_t.atq17 OR g_atq_t.atq17 IS NULL THEN
               IF NOT i006_chk_dudata() THEN
                  LET g_atq[l_ac].atq17=g_atq_t.atq17
                  LET g_atq[l_ac].ats02=i006_set_ats02(g_atq[l_ac].atq17)
                  DISPLAY BY NAME g_atq[l_ac].atq17,g_atq[l_ac].ats02
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
         LET g_atq[l_ac].ats02=i006_set_ats02(g_atq[l_ac].atq17)
         DISPLAY BY NAME g_atq[l_ac].ats02

      AFTER FIELD atq19
         IF NOT cl_null(g_atq[l_ac].atq19) THEN
            IF NOT i006_chk_atq19() THEN
               LET g_atq[l_ac].atq19=g_atq_t.atq19
               LET g_atq[l_ac].atn02=i006_set_atn02(g_atq[l_ac].atq19)
               DISPLAY BY NAME g_atq[l_ac].atq19,g_atq[l_ac].atn02
               NEXT FIELD CURRENT
            END IF
            LET g_atq[l_ac].atn02=i006_set_atn02(g_atq[l_ac].atq19)
            DISPLAY BY NAME g_atq[l_ac].atn02
            IF g_atq[l_ac].atq19 != g_atq_t.atq19 OR 
               g_atq_t.atq19 IS NULL THEN
               IF NOT i006_chk_dudata() THEN
                  LET g_atq[l_ac].atq19=g_atq_t.atq19
                  LET g_atq[l_ac].atn02=i006_set_atn02(g_atq[l_ac].atq19)
                  DISPLAY BY NAME g_atq[l_ac].atq19,g_atq[l_ac].atn02
                  NEXT FIELD CURRENT
               END IF
            END IF
         END IF
         LET g_atq[l_ac].atn02=i006_set_atn02(g_atq[l_ac].atq19)
         DISPLAY BY NAME g_atq[l_ac].atn02
 
      AFTER FIELD atq18
         CALL i006_set_atq18()
         
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_atq[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_atq[l_ac].* TO s_atq.*
            CALL g_atq.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO atq_file(atq14,atq15,atq16,atq01,atq02,atq17,atq18,atq19,atq20,atqlegal,atqoriu,atqorig) #FUN-980003 add legal
              VALUES(' ',g_atq15,' ',g_atq01,g_atq02,
                     g_atq[l_ac].atq17,g_atq[l_ac].atq18,
                     g_atq[l_ac].atq19,g_atq[l_ac].atq20,g_legal, g_user, g_grup) #FUN-980003 add legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","atq_file",g_atq[l_ac].atq17,
                         "",SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            CALL i006_sum_atq18()      #MOD-840613-add
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF l_ac>0 THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM atq_file WHERE atq15 = g_atq15
                                   AND atq01 = g_atq01
                                   AND atq02 = g_atq02
                                   AND atq17 = g_atq_t.atq17
                                   AND atq20 = g_atq_t.atq20
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","atq_file",g_atq[l_ac].atq17,
                            "",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         CALL i006_sum_atq18()      #MOD-840613-add
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_atq[l_ac].* = g_atq_t.*
            CLOSE i006_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_atq[l_ac].atq17,-263,1)
            LET g_atq[l_ac].* = g_atq_t.*
         ELSE
            UPDATE atq_file SET atq17 = g_atq[l_ac].atq17,
                                atq18 = g_atq[l_ac].atq18,
                                atq19 = g_atq[l_ac].atq19
                                 WHERE atq15 = g_atq15
                                   AND atq01 = g_atq01
                                   AND atq02 = g_atq02
                                   AND atq17 = g_atq_t.atq17
                                   AND atq20 = g_atq_t.atq20
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","atq_file",g_atq[l_ac].atq17,
                            "",SQLCA.sqlcode,"","",1)
               LET g_atq[l_ac].* = g_atq_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               CALL i006_sum_atq18()      #MOD-840613-add
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_atq[l_ac].* = g_atq_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_atq.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i006_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30032 Add
         CLOSE i006_bcl
         COMMIT WORK
         #CKP2
          CALL g_atq.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(atq17)
              CALL cl_init_qry_var()
              IF g_argv6 = '1' THEN
                 LET g_qryparam.form = "q_ats01"
              ELSE
                 LET g_qryparam.form = "q_ats02"
              END IF
              LET g_qryparam.default1 = g_atq[l_ac].atq17
              CALL cl_create_qry() RETURNING g_atq[l_ac].atq17
              DISPLAY BY NAME g_atq[l_ac].atq17
              NEXT FIELD atq17
           WHEN INFIELD(atq19)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_atn01"
              LET g_qryparam.default1 = g_atq[l_ac].atq19
              LET g_qryparam.default2 = g_atq[l_ac].atn02
              CALL cl_create_qry() RETURNING g_atq[l_ac].atq19,
                                             g_atq[l_ac].atn02
              DISPLAY BY NAME g_atq[l_ac].atq19
              DISPLAY BY NAME g_atq[l_ac].atn02
              NEXT FIELD atq19
         END CASE
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
             RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
   END INPUT
 
   CLOSE i006_bcl
   COMMIT WORK
   CALL i006_sum_atq18()
END FUNCTION
 
FUNCTION i006_b_fill(p_wc)                     #BODY FILL UP
DEFINE p_wc STRING
DEFINE
    l_atq20     LIKE atq_file.atq20

    IF g_argv6 = '1' THEN
       LET l_atq20 = 'Y'
    ELSE
       LET l_atq20 = 'N'
    END IF
 
   LET g_sql = "SELECT atq17,'',atq19,'',atq18,atq20",
               " FROM atq_file ",
               " WHERE atq15 = '",g_atq15,"'",
               "   AND atq01 = '",g_atq01,"'",
               "   AND atq02 = '",g_atq02,"'",
               "   AND atq20 = '",l_atq20,"'",  
               "   AND ",p_wc CLIPPED ,
               " ORDER BY atq17"
   PREPARE i006_prepare2 FROM g_sql       #預備一下
   DECLARE atq_cs CURSOR FOR i006_prepare2
 
   CALL g_atq.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH atq_cs INTO g_atq[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_atq[g_cnt].ats02=i006_set_ats02(g_atq[g_cnt].atq17)
      LET g_atq[g_cnt].atn02=i006_set_atn02(g_atq[g_cnt].atq19)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_atq.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2
   CALL i006_sum_atq18()
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i006_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_atq TO s_atq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i006_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i006_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i006_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i006_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i006_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6B0040  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--beatk                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i006_copy()
DEFINE
   l_n             LIKE type_file.num5,   #No.FUN-680098   smallint
   l_cnt           LIKE type_file.num10,  #No.FUN-680098   INTEGER
   l_newno2,l_oldno2  LIKE atq_file.atq15,
   l_newno4,l_oldno4  LIKE atq_file.atq01,
   l_newno5,l_oldno5  LIKE atq_file.atq02,
   li_result       LIKE type_file.num5,
   l_atq20         LIKE atq_file.atq20 

   IF g_argv6 = '1' THEN
      LET l_atq20 = 'Y'
   ELSE
      LET l_atq20 = 'N'
   END IF 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_atq15) OR
      cl_null(g_atq01) OR
      cl_null(g_atq02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
 
   DISPLAY NULL TO atq15
   DISPLAY NULL TO atq01
   DISPLAY NULL TO atq02
   CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INPUT l_newno2,l_newno4,l_newno5 
    FROM atq15,atq01,atq02
 
      #AFTER FIELD atq14
      #   CALL i006_chk_atq14(l_newno1) 
      #       RETURNING li_result,l_newno2,l_newno3
      #   DISPLAY i006_set_asg02(l_newno1) TO FORMONLY.asg02
      #   DISPLAY l_newno2 TO atq15
      #   DISPLAY l_newno3 TO atq16
      #   IF NOT li_result THEN
      #      NEXT FIELD CURRENT
      #   END IF
 
       AFTER FIELD atq02
          IF (NOT cl_null(l_newno2)) OR
             (NOT cl_null(l_newno4)) OR
             (NOT cl_null(l_newno5)) THEN
             LET l_cnt=0             
             SELECT COUNT(*) INTO l_cnt FROM atq_file
                                       WHERE atq15=l_newno2
                                         AND atq01=l_newno4
                                         AND atq02=l_newno5
                                         AND atq20=l_atq20
            IF l_cnt>0 THEN
               CALL cl_err('','-239',1)
               NEXT FIELD atq15
            END IF
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
      DISPLAY g_atq15 TO atq15
      DISPLAY g_atq01 TO atq01
      DISPLAY g_atq02 TO atq02
      RETURN
   END IF
 
   DROP TABLE i006_x
 
   SELECT * FROM atq_file             #單身複製
    WHERE atq15 = g_atq15
      AND atq01 = g_atq01
      AND atq02 = g_atq02
      AND atq20 = l_atq20
     INTO TEMP i006_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno2 CLIPPED
      CALL cl_err3("ins","i006_x",g_atq15,g_atq01,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE i006_x SET atq15=l_newno2,
                     atq01=l_newno4,
                     atq02=l_newno5
               WHERE atq20=l_atq20      
   INSERT INTO atq_file SELECT * FROM i006_x
   IF SQLCA.sqlcode THEN
      LET g_msg=l_newno2 CLIPPED
      CALL cl_err3("ins","atq_file",l_newno2,l_newno4,
                    SQLCA.sqlcode,"",g_msg,1)
      RETURN
   ELSE
      MESSAGE 'COPY O.K'
      LET g_atq15=l_newno2
      LET g_atq01=l_newno4
      LET g_atq02=l_newno5
      CALL i006_show()
   END IF
 
END FUNCTION
 
FUNCTION i006_r()
DEFINE l_atq20 LIKE atq_file.atq20

   IF g_argv6 = '1' THEN
      LET l_atq20 = 'Y'
   ELSE
      LET l_atq20 = 'N'
   END IF
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_atq15) OR
      cl_null(g_atq01) OR
      cl_null(g_atq02) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   IF NOT cl_delh(20,16) THEN RETURN END IF
   INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
   LET g_doc.column1 = "atq15"      #No.FUN-9B0098 10/02/24
   LET g_doc.value1 = g_atq15       #No.FUN-9B0098 10/02/24
   CALL cl_del_doc()                                                          #No.FUN-9B0098 10/02/24
   DELETE FROM atq_file WHERE atq15=g_atq15
                          AND atq01=g_atq01
                          AND atq02=g_atq02
                          AND atq20=l_atq20
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","atq_file",g_atq15,g_atq01,
                   SQLCA.sqlcode,"","del atq",1)
      RETURN      
   END IF   
 
   INITIALIZE g_atq15,g_atq01,g_atq02 TO NULL
   MESSAGE ""
   CLEAR FORM
   CALL g_atq.clear()
   IF NOT cl_null(g_sql_tmp) THEN
      DROP TABLE i006_cnttmp                   #No.TQC-720019
      PREPARE i006_precount_x2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i006_precount_x2        
   END IF 
   OPEN i006_count
   #FUN-B50062-add-start--
   IF STATUS THEN
      CLOSE i006_bcs
      CLOSE i006_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   FETCH i006_count INTO g_row_count
   #FUN-B50062-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE i006_bcs
      CLOSE i006_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50062-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   IF g_row_count>0 THEN
      OPEN i006_bcs
      CALL i006_fetch('F') 
   ELSE
      DISPLAY g_atq15 TO atq15
      DISPLAY g_atq01 TO atq01
      DISPLAY g_atq02 TO atq02
      DISPLAY 0 TO FORMONLY.cn2
      CALL g_atq.clear()
      CALL i006_menu()
   END IF
END FUNCTION
 
#FUNCTION i006_chk_atq14(p_atq14)
#  DEFINE p_atq14 LIKE atq_file.atq14
#  DEFINE l_asgacti  LIKE asg_file.asgacti
#  DEFINE l_asg05 LIKE asg_file.asg05
#  DEFINE l_asg06 LIKE asg_file.asg06
#
#  LET l_asg05=NULL
#  LET l_asg06=NULL
#  IF NOT cl_null(p_atq14) THEN
#    #SELECT asgacti,asg05,asg06                         #FUN-920123 mark 
#    #  INTO l_asgacti,l_asg05,l_asg06 FROM asg_file     #FUN-920123 mark
#     SELECT asg05,asg06                                 #FUN-920123 
#       INTO l_asg05,l_asg06 FROM asg_file               #FUN-920123 
#                                     WHERE asg01=p_atq14
#     CASE
#        WHEN SQLCA.sqlcode
#           CALL cl_err3("sel","atq_file",p_atq14,"",SQLCA.sqlcode,"","",1)
#           RETURN FALSE,NULL,NULL
#       #FUN-920123 --------------mark -------start-------------------
#       #WHEN l_asgacti='N'
#       #   CALL cl_err3("sel","atq_file",p_atq14,"",9028,"","",1)
#       #   RETURN FALSE,NULL,NULL
#       #FUN-920123 --------------mark -------end--------------------
#     END CASE      
#  END IF
#  RETURN TRUE,l_asg05,l_asg06
#END FUNCTION
 
FUNCTION i006_set_asg02(p_asg01)
   DEFINE p_asg01 LIKE asg_file.asg01
   DEFINE l_asg02 LIKE asg_file.asg02
   
   IF cl_null(p_asg01) THEN RETURN NULL END IF
   LET l_asg02=''
   SELECT asg02 INTO l_asg02 FROM asg_file
                            WHERE asg01=p_asg01
   RETURN l_asg02
END FUNCTION
 
FUNCTION i006_set_ats02(p_ats01)
   DEFINE p_ats01 LIKE ats_file.ats01
   DEFINE l_ats02 LIKE ats_file.ats02
   
   IF cl_null(p_ats01) THEN RETURN NULL END IF
   LET l_ats02=''
   SELECT ats02 INTO l_ats02 FROM ats_file
                            WHERE ats01=p_ats01
   RETURN l_ats02
END FUNCTION

FUNCTION i006_set_atn02(p_atn01)
   DEFINE p_atn01 LIKE atn_file.atn01
   DEFINE l_atn02 LIKE atn_file.atn02
   
   IF cl_null(p_atn01) THEN RETURN NULL END IF
   LET l_atn02=''
   SELECT atn02 INTO l_atn02 FROM atn_file
                            WHERE atn01=p_atn01
   RETURN l_atn02
END FUNCTION

FUNCTION i006_chk_atq19()
   IF NOT cl_null(g_atq[l_ac].atq19) THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM atn_file 
                                WHERE atn01 = g_atq[l_ac].atq19
      IF g_cnt=0 THEN
         CALL cl_err3("sel","atn_file",g_atq[l_ac].atq19,"",100,"","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i006_chk_atq17()
   IF NOT cl_null(g_atq[l_ac].atq17) THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM ats_file 
                                WHERE ats01 = g_atq[l_ac].atq17
      IF g_cnt=0 THEN
         CALL cl_err3("sel","ats_file",g_atq[l_ac].atq17,"",100,"","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i006_set_atq18()
   IF NOT cl_null(g_atq[l_ac].atq18) THEN
      SELECT azi04 INTO t_azi04 FROM azi_file
                               WHERE azi01=g_atq16
      LET g_atq[l_ac].atq18=cl_digcut(g_atq[l_ac].atq18,t_azi04)
      DISPLAY BY NAME g_atq[l_ac].atq18
   END IF
END FUNCTION
 
FUNCTION i006_chk_dudata()
   IF (NOT cl_null(g_atq[l_ac].atq17)) AND 
      (NOT cl_null(g_atq[l_ac].atq19))THEN
      LET g_cnt=0
      SELECT COUNT(*) INTO g_cnt FROM atq_file
                                WHERE atq15=g_atq15
                                  AND atq01=g_atq01
                                  AND atq02=g_atq02
                                  AND atq17=g_atq[l_ac].atq17
                                  AND atq19=g_atq[l_ac].atq19
      IF g_cnt>0 THEN
         CALL cl_err('',-239,1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION i006_sum_atq18()
   DEFINE l_atq20 LIKE atq_file.atq20
   DEFINE l_atq18 LIKE atq_file.atq18
   
   IF g_argv6 = '1' THEN
      LET l_atq20 = 'Y'
   ELSE
      LET l_atq20 = 'N'
   END IF
   SELECT SUM(atq18) INTO l_atq18 FROM atq_file
                                WHERE atq15=g_atq15
                                  AND atq01=g_atq01
                                  AND atq02=g_atq02
                                  AND atq20=l_atq20 
   IF SQLCA.sqlcode OR cl_null(l_atq18) THEN
      LET l_atq18=0
   END IF
   DISPLAY l_atq18 TO FORMONLY.sum_atq18
END FUNCTION
 
FUNCTION i006_out()
   DEFINE l_wc STRING
   DEFINE l_cmd STRING

   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF

   IF g_argv6 = '1' THEN
      LET g_wc = g_wc," AND atq20 = 'Y'"
   ELSE
      LET g_wc = g_wc," AND atq20 = 'N'"
   END IF

   IF g_argv6 = '1' THEN
      LET l_cmd = 'p_query "ggli601" "',g_wc CLIPPED,'"'
   ELSE
      LET l_cmd = 'p_query "ggli6011" "',g_wc CLIPPED,'"'
   END IF
   CALL cl_cmdrun(l_cmd)
   RETURN
 
#  CALL cl_wait()
#
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
#  SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'ggli604'
#
#  #組合出 SQL 指令
#  LET g_sql="SELECT A.atq14,B.asg02 atq14_d,A.atq15,A.atq16,",
#            "       A.atq01,A.atq02,A.atq17,C.ats02 atq17_d,",
#            "       A.atq18,D.azi04,D.azi05",
#            "  FROM atq_file A,asg_file B,ats_file C,azi_file D",
#            " WHERE A.atq14=B.asg01",
#            "   AND A.atq17=C.ats01",
#            "   AND A.atq16=D.azi01",
#            "   AND ",g_wc CLIPPED,
#            " ORDER BY A.atq14,A.atq15,A.atq16,A.atq01,A.atq02,A.atq07"
#  PREPARE i006_p1 FROM g_sql                # RUNTIME 編譯
#  DECLARE i006_co  CURSOR FOR i006_p1
#
#  #是否列印選擇條件
#  IF g_zz05 = 'Y' THEN
#     CALL cl_wcchp(g_wc,'atq14,atq15,atq16,atq01,atq02,atq17,atq18')
#          RETURNING l_wc
#  ELSE
#     LET l_wc = ' '
#  END IF
#
#  CALL cl_prt_cs1('agli006','agli006',g_sql,l_wc)
 
END FUNCTION
##FUN-780013
#FUN-B60144--
