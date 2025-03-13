# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi910.4gl
# Descriptions...: 資金模擬匯率設定
# Date & Author..: 06/02/21 By Nicola
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/09/13 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-730024 07/03/05 By Smapmin 複製功能有誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760066 07/06/19 By chenl   匯率打印應給原值，不應該截取小數位數。
# Modify.........: No.FUN-790050 07/08/06 By Carrier _out()轉p_query實現
# Modify.........: No.TQC-790001 07/09/02 By Mandy PK問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤 
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_nqc01      LIKE nqc_file.nqc01,
       g_nqc02      LIKE nqc_file.nqc02,
       g_nqc01_t    LIKE nqc_file.nqc01,
       g_nqc02_t    LIKE nqc_file.nqc02,
       g_azi02_1    LIKE azi_file.azi02,
       g_azi02_2    LIKE azi_file.azi02,
       g_nqc        DYNAMIC ARRAY OF RECORD
                       nqc03   LIKE nqc_file.nqc03,
                       nqc04   LIKE nqc_file.nqc04,
                       nqc05   LIKE nqc_file.nqc05
                    END RECORD,
       g_nqc_t      RECORD
                       nqc03   LIKE nqc_file.nqc03,
                       nqc04   LIKE nqc_file.nqc04,
                       nqc05   LIKE nqc_file.nqc05
                    END RECORD,
       g_wc,g_sql   STRING,
       g_rec_b      LIKE type_file.num5,         #No.FUN-680107 SMALLINT
       l_ac         LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_forupd_sql STRING
DEFINE g_sql_tmp    STRING#No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680107 SMALLINT
DEFINE g_cnt        LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_msg        LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   LET p_row = 4 LET p_col = 2
 
   OPEN WINDOW i910_w AT p_row,p_col
     WITH FORM "anm/42f/anmi910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL i910_menu()
 
   CLOSE WINDOW i910_w                 #結束畫面
 
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
END MAIN
 
FUNCTION i910_cs()
 
   CLEAR FORM
   CALL g_nqc.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nqc01 TO NULL    #No.FUN-750051
   INITIALIZE g_nqc02 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc ON nqc01,nqc02,nqc03,nqc04,nqc05
        FROM nqc01,nqc02,s_nqc[1].nqc03,s_nqc[1].nqc04,s_nqc[1].nqc05
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqc01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nqc01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nqc01
               NEXT FIELD nqc01
            WHEN INFIELD(nqc02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nqc01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nqc02
               NEXT FIELD nqc02
            OTHERWISE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
    
      ON ACTION help
         CALL cl_show_help()
    
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
  
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nqcuser', 'nqcgrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_sql = "SELECT UNIQUE nqc01,nqc02 FROM nqc_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY nqc01,nqc02"
 
   PREPARE i910_prepare FROM g_sql
   DECLARE i910_bcs SCROLL CURSOR WITH HOLD FOR i910_prepare
 
#  LET g_sql = "SELECT UNIQUE nqc01,nqc02 FROM nqc_file ",      #No.TQC-720019
   LET g_sql_tmp = "SELECT UNIQUE nqc01,nqc02 FROM nqc_file ",  #No.TQC-720019
               " WHERE ", g_wc CLIPPED,
               " INTO TEMP x "
   DROP TABLE x
#  PREPARE i910_precount_x FROM g_sql      #No.TQC-720019
   PREPARE i910_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i910_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i910_precount FROM g_sql
   DECLARE i910_count CURSOR FOR i910_precount
 
END FUNCTION
 
FUNCTION i910_menu()
 
   WHILE TRUE
      CALL i910_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i910_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i910_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i910_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i910_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i910_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i910_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi910" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "rate_batch"
            IF cl_chk_act_auth() THEN
               CALL i910_rate()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nqc),'','')
            END IF
         #No.FUN-6A0011-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_nqc01 IS NOT NULL THEN
                LET g_doc.column1 = "nqc01"
                LET g_doc.column2 = "nqc02"
                LET g_doc.value1 = g_nqc01
                LET g_doc.value2 = g_nqc02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0011-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i910_a()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_nqc.clear()
 
   SELECT nqa01 INTO g_nqc01 FROM nqa_file
    WHERE nqa00 = "0"
   IF STATUS THEN
      LET g_nqc01 = g_aza.aza17
   END IF
 
   SELECT azi02 INTO g_azi02_1 FROM azi_file
    WHERE azi01 = g_nqc01
   DISPLAY g_azi02_1 TO azi02_1
 
   LET g_nqc02 = g_aza.aza17
   LET g_nqc01_t = NULL
   LET g_nqc02_t = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i910_i("a")
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
 
      CALL i910_b()
 
      LET g_nqc01_t = g_nqc01
      LET g_nqc02_t = g_nqc02
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i910_u()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nqc01 IS NULL OR g_nqc02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nqc01_t = g_nqc01
   LET g_nqc02_t = g_nqc02
 
   WHILE TRUE
      CALL i910_i("u") 
 
      IF INT_FLAG THEN
         LET g_nqc01 = g_nqc01_t
         LET g_nqc02 = g_nqc02_t
         DISPLAY g_nqc01,g_nqc02 TO nqc01,nqc02
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_nqc01 != g_nqc01_t OR g_nqc02 != g_nqc02_t THEN
         UPDATE nqc_file SET nqc01 = g_nqc01,
                             nqc02 = g_nqc02
          WHERE nqc01 = g_nqc01_t
            AND nqc02 = g_nqc02_t
         IF SQLCA.sqlcode THEN
            LET g_msg = g_nqc01 CLIPPED,' + ', g_nqc02 CLIPPED
#           CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("upd","nqc_file",g_nqc01_t,g_nqc02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CONTINUE WHILE
         END IF
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i910_i(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT g_nqc01,g_nqc02 WITHOUT DEFAULTS FROM nqc01,nqc02
 
      AFTER FIELD nqc02
         IF NOT cl_null(g_nqc02) THEN
            IF g_nqc02 != g_nqc02_t OR g_nqc02_t IS NULL THEN
               SELECT azi02 INTO g_azi02_2 FROM azi_file
                WHERE azi01 = g_nqc02
               IF STATUS THEN
#                 CALL cl_err(g_nqc02,"aap-002",0)   #No.FUN-660148
                  CALL cl_err3("sel","azi_file",g_nqc02,"","aap-002","","",1)  #No.FUN-660148
                  NEXT FIELD nqc02
               ELSE
                  DISPLAY g_azi02_2 TO azi02_2
               END IF
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
             EXIT INPUT
         END IF
         IF (g_nqc01 != g_nqc01_t OR g_nqc01_t IS NULL)
            AND g_nqc02 != g_nqc02_t OR g_nqc02_t IS NULL THEN
            SELECT COUNT(*) INTO g_cnt FROM nqc_file
             WHERE nqc01 = g_nqc01
               AND nqc02 = g_nqc02
            IF g_cnt > 0 THEN
               CALL cl_err("","axm-298",0)
               NEXT FIELD nqc01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqc01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nqc01
               CALL cl_create_qry() RETURNING g_nqc01
               DISPLAY BY NAME g_nqc01
               NEXT FIELD nqc01
            WHEN INFIELD(nqc02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nqc02
               CALL cl_create_qry() RETURNING g_nqc02
               DISPLAY BY NAME g_nqc02
               NEXT FIELD nqc02
            OTHERWISE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
 
END FUNCTION
 
FUNCTION i910_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   INITIALIZE g_nqc01 TO NULL             #No.FUN-6A0011
   INITIALIZE g_nqc02 TO NULL             #NO.FUN-6A0011
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i910_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_nqc01 TO NULL
      INITIALIZE g_nqc02 TO NULL
      RETURN
   END IF
 
   OPEN i910_bcs
   IF SQLCA.sqlcode THEN
      CALL cl_err("",SQLCA.sqlcode,0)
      INITIALIZE g_nqc01 TO NULL
      INITIALIZE g_nqc02 TO NULL
   ELSE
      CALL i910_fetch('F')
      OPEN i910_count
      FETCH i910_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF
 
END FUNCTION
 
FUNCTION i910_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_abso   LIKE type_file.num10         #No.FUN-680107 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i910_bcs INTO g_nqc01,g_nqc02
      WHEN 'P' FETCH PREVIOUS i910_bcs INTO g_nqc01,g_nqc02
      WHEN 'F' FETCH FIRST    i910_bcs INTO g_nqc01,g_nqc02
      WHEN 'L' FETCH LAST     i910_bcs INTO g_nqc01,g_nqc02
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
              
               ON ACTION help
                  CALL cl_show_help()
              
               ON ACTION controlg
                  CALL cl_cmdask()
 
               END PROMPT
 
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
 
            FETCH ABSOLUTE g_jump i910_bcs INTO g_nqc01,g_nqc02
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_nqc01,SQLCA.sqlcode,0)
      INITIALIZE g_nqc01 TO NULL  #TQC-6B0105
      INITIALIZE g_nqc02 TO NULL  #TQC-6B0105
   ELSE
      CALL i910_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
FUNCTION i910_show()
 
   SELECT azi02 INTO g_azi02_1 FROM azi_file
    WHERE azi01 = g_nqc01
 
   SELECT azi02 INTO g_azi02_2 FROM azi_file
    WHERE azi01 = g_nqc02
 
   DISPLAY g_nqc01,g_nqc02,g_azi02_1,g_azi02_2
        TO nqc01,nqc02,azi02_1,azi02_2
 
   CALL i910_b_fill(g_wc)
 
   CALL cl_show_fld_cont()
 
END FUNCTION
 
FUNCTION i910_r()
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqc01 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6A0011
      RETURN
   END IF
 
   IF cl_delh(0,0) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nqc01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "nqc02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nqc01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_nqc02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                      #No.FUN-9B0098 10/02/24
      DELETE FROM nqc_file
       WHERE nqc01 = g_nqc01
         AND nqc02 = g_nqc02
      IF SQLCA.sqlcode THEN
#        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660148
         CALL cl_err3("del","nqc_file",g_nqc01,g_nqc02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660148
      ELSE
         CLEAR FORM
         CALL g_nqc.clear()
         LET g_nqc01 = NULL
         LET g_nqc02 = NULL
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
 
         DROP TABLE x                        #No.TQC-720019
         PREPARE i910_pre_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i910_pre_x2                 #No.TQC-720019
         OPEN i910_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i910_bcs
            CLOSE i910_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i910_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i910_bcs
            CLOSE i910_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
 
         OPEN i910_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i910_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i910_fetch('/')
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i910_b()
   DEFINE l_ac_t          LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_n             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_lock_sw       LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #No.FUN-680107 SMALLINT
          l_allow_delete  LIKE type_file.num5           #No.FUN-680107 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqc01 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nqc03,nqc04,nqc05 FROM nqc_file",
                      "  WHERE nqc01=? AND nqc02=?",
                      "   AND nqc03=? AND nqc04=? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i910_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nqc WITHOUT DEFAULTS FROM s_nqc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nqc_t.* = g_nqc[l_ac].*
            BEGIN WORK
            OPEN i910_bcl USING g_nqc01,g_nqc02,g_nqc_t.nqc03,g_nqc_t.nqc04
            IF STATUS THEN
               CALL cl_err("OPEN i910_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i910_bcl INTO g_nqc[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nqc_t.nqc03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nqc[l_ac].* TO NULL
         LET g_nqc[l_ac].nqc03 = YEAR(g_today)
         LET g_nqc[l_ac].nqc05 = s_exrate(g_nqc02,g_nqc01,"S") 
         LET g_nqc_t.* = g_nqc[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD nqc03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_nqc01) THEN LET g_nqc01 = ' ' END IF #TQC-790001
         INSERT INTO nqc_file (nqc01,nqc02,nqc03,nqc04,nqc05,nqcoriu,nqcorig)
              VALUES(g_nqc01,g_nqc02,g_nqc[l_ac].nqc03,g_nqc[l_ac].nqc04,
                     g_nqc[l_ac].nqc05, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_nqc[l_ac].nqc03,SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nqc_file",g_nqc01,g_nqc02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      AFTER FIELD nqc03
         IF g_nqc[l_ac].nqc03 < 0 THEN
            CALL cl_err(g_nqc[l_ac].nqc03,"afa-040",0)
            NEXT FIELD nqc03
         END IF
 
      AFTER FIELD nqc04
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_nqc[l_ac].nqc04) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_nqc[l_ac].nqc03
            IF g_azm.azm02 = 1 THEN
               IF g_nqc[l_ac].nqc04 > 12 OR g_nqc[l_ac].nqc04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD nqc04
               END IF
            ELSE
               IF g_nqc[l_ac].nqc04 > 13 OR g_nqc[l_ac].nqc04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD nqc04
               END IF
            END IF
         END IF
#         IF g_nqc[l_ac].nqc04 < 1 OR g_nqc[l_ac].nqc04 > 13 THEN
#            CALL cl_err(g_nqc[l_ac].nqc04,"agl-013",0)
#            NEXT FIELD nqc04
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD nqc05
         IF g_nqc[l_ac].nqc04 < 0 THEN
            CALL cl_err(g_nqc[l_ac].nqc05,"afa-040",0)
            NEXT FIELD nqc05
         END IF
 
      BEFORE DELETE
         IF g_nqc_t.nqc03 > 0 AND g_nqc_t.nqc03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nqc_file
             WHERE nqc01 = g_nqc01
               AND nqc02 = g_nqc02
               AND nqc03 = g_nqc_t.nqc03
               AND nqc04 = g_nqc_t.nqc04
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqc_t.nqc03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nqc_file",g_nqc01,g_nqc_t.nqc03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nqc[l_ac].* = g_nqc_t.*
            CLOSE i910_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nqc[l_ac].nqc03,-263,1)
            LET g_nqc[l_ac].* = g_nqc_t.*
         ELSE
            UPDATE nqc_file SET nqc03 = g_nqc[l_ac].nqc03,
                                nqc04 = g_nqc[l_ac].nqc04,
                                nqc05 = g_nqc[l_ac].nqc05
             WHERE nqc01 = g_nqc01
               AND nqc02 = g_nqc02
               AND nqc03 = g_nqc_t.nqc03
               AND nqc04 = g_nqc_t.nqc04
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nqc[l_ac].nqc03,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nqc_file",g_nqc01,g_nqc_t.nqc03,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nqc[l_ac].* = g_nqc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
      #  LET l_ac_t = l_ac   #FUN-D30032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nqc[l_ac].* = g_nqc_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_nqc.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i910_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i910_bcl
         COMMIT WORK
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
   END INPUT
 
   CLOSE i910_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i910_b_fill(p_wc)
   DEFINE p_wc   LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT nqc03,nqc04,nqc05 FROM nqc_file ",
               " WHERE nqc01 = '",g_nqc01,"'",
               "   AND nqc02 = '",g_nqc02,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY nqc03,nqc04"
 
   PREPARE i910_prepare2 FROM g_sql
   DECLARE nqc_cs CURSOR FOR i910_prepare2
 
   LET g_cnt = 1
   LET g_rec_b=0
   CALL g_nqc.clear()
 
   FOREACH nqc_cs INTO g_nqc[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_nqc.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i910_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nqc TO s_nqc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL i910_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL i910_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL i910_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL i910_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL i910_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION rate_batch
         LET g_action_choice = "rate_batch"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------       
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i910_copy()
   DEFINE l_oldno1   LIKE nqc_file.nqc01,
          l_oldno2   LIKE nqc_file.nqc02,
          l_newno1   LIKE nqc_file.nqc01,
          l_newno2   LIKE nqc_file.nqc02
 
   IF s_anmshut(0) THEN RETURN END IF
 
   IF g_nqc01 IS NULL OR g_nqc02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #SELECT nqa01 INTO l_newno1 FROM nqc_file   #TQC-730024
   # WHERE nqc00 = "0"   #TQC-730024
   SELECT nqa01 INTO l_newno1 FROM nqa_file   #TQC-730024
    WHERE nqa00 = "0"   #TQC-730024
   IF STATUS THEN
      #LET g_nqc01 = g_aza.aza17   #TQC-730024
      LET l_newno1 = g_aza.aza17   #TQC-730024
   END IF
 
   SELECT azi02 INTO g_azi02_1 FROM azi_file
    WHERE azi01 = g_nqc01
   DISPLAY g_azi02_1 TO azi02_1
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   #INPUT l_newno1,l_newno2 FROM nqc01,nqc02   #TQC-730024
   INPUT l_newno1,l_newno2 WITHOUT DEFAULTS FROM nqc01,nqc02   #TQC-730024
 
      AFTER FIELD nqc02
         IF cl_null(l_newno2) THEN
            NEXT FIELD nqc02
         ELSE
            #-----TQC-730024---------
            #IF g_nqc02 != g_nqc02_t OR g_nqc02_t IS NULL THEN
            #   SELECT azi02 INTO g_azi02_2 FROM azi_file
            #    WHERE azi01 = g_nqc02
            #   IF STATUS THEN
#           #      CALL cl_err(g_nqc02,"aap-002",0)   #No.FUN-660148
            #      CALL cl_err3("sel","azi_file",g_nqc02,"","aap-002","","",1)  #No.FUN-660148
            #      NEXT FIELD nqc02
            #   ELSE
            #      DISPLAY g_azi02_2 TO azi02_2
            #   END IF
            #END IF
            SELECT azi02 INTO g_azi02_2 FROM azi_file 
             WHERE azi01 = l_newno2
             IF STATUS THEN
                CALL cl_err3("sel","azi_file",l_newno2,"","aap-002","","",1)
                NEXT FIELD nqc02
             ELSE
                DISPLAY g_azi02_2 TO azi02_2
             END IF
            #-----END TQC-730024-----
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqc02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno2
               DISPLAY l_newno2 TO nqc02
               NEXT FIELD nqc02
            OTHERWISE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
     
      ON ACTION help
         CALL cl_show_help()
     
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL i910_show()
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM nqc_file WHERE nqc01=g_nqc01 AND nqc02=g_nqc02 INTO TEMP x
 
   IF cl_null(l_newno1) THEN LET l_newno1 = ' ' END IF #TQC-790001
   UPDATE x SET nqc01=l_newno1,nqc02=l_newno2
 
   INSERT INTO nqc_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nqc01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("ins","nqc_file",g_nqc01,g_nqc02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_msg = l_newno1 CLIPPED, ' + ', l_newno2 CLIPPED
      MESSAGE 'ROW(',g_msg,') O.K'
      LET l_oldno1 = g_nqc01
      LET l_oldno2 = g_nqc02
      LET g_nqc01 = l_newno1
      LET g_nqc02 = l_newno2
      CALL i910_b()
      #LET g_nqc01 = l_oldno1  #FUN-C80046
      #LET g_nqc02 = l_oldno2  #FUN-C80046
      #CALL i910_show()        #FUN-C80046
   END IF
 
END FUNCTION
 
FUNCTION i910_rate()
   DEFINE p_row,p_col   LIKE type_file.num5       #No.FUN-680107 SMALLINT
   DEFINE g_nqc2        LIKE nqc_file.nqc02
   DEFINE g_azi2        LIKE azi_file.azi02
   DEFINE g_y1          LIKE nqc_file.nqc03
   DEFINE g_m1          LIKE nqc_file.nqc04
   DEFINE g_y2          LIKE nqc_file.nqc03
   DEFINE g_m2          LIKE nqc_file.nqc04
   DEFINE g_rate        LIKE nqc_file.nqc05
   DEFINE l_beg         LIKE type_file.num10      #No.FUN-680107 INTEGER
   DEFINE l_end         LIKE type_file.num10      #No.FUN-680107 INTEGER
   DEFINE l_co          LIKE type_file.num10      #No.FUN-680107 INTEGER
   DEFINE l_nqc03       LIKE nqc_file.nqc03
   DEFINE l_nqc04       LIKE nqc_file.nqc04
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW i910_r AT p_row,p_col WITH FORM "anm/42f/anmi910r"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("anmi910r")
 
   INPUT g_nqc2,g_y1,g_m1,g_y2,g_m2,g_rate FROM nqc2,y1,m1,y2,m2,rate
 
      AFTER FIELD nqc2
         IF NOT cl_null(g_nqc2) THEN
            SELECT azi02 INTO g_azi2 FROM azi_file
             WHERE azi01 = g_nqc2
            IF STATUS THEN
#              CALL cl_err(g_nqc2,"aap-002",0)   #No.FUN-660148
               CALL cl_err3("sel","azi_file",g_nqc2,"","aap-002","","",1)  #No.FUN-660148
               NEXT FIELD nqc2
            ELSE
               DISPLAY g_azi2 TO azi2
            END IF
           #SELECT COUNT(*) INTO g_cnt FROM nqc_file
           # WHERE nqc01 = g_nqc01
           #   AND nqc02 = g_nqc2
           #IF g_cnt > 0 THEN
           #   CALL cl_err("","axm-298",0)
           #   NEXT FIELD nqc2
           #END IF
         END IF
 
      AFTER FIELD y1
         IF g_y1 < 0 THEN
            CALL cl_err(g_y1,"afa-040",0)
            NEXT FIELD y1
         END IF
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_y1
            IF g_azm.azm02 = 1 THEN
               IF g_m1 > 12 OR g_m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF g_m1 > 13 OR g_m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#         IF g_m1 < 1 OR g_m1 > 13 THEN
#            CALL cl_err(g_m1,"agl-013",0)
#            NEXT FIELD m1
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD y2
         IF g_y2 < 0 THEN
            CALL cl_err(g_y2,"afa-040",0)
            NEXT FIELD y2
         END IF
 
      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_y2
            IF g_azm.azm02 = 1 THEN
               IF g_m2 > 12 OR g_m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF g_m2 > 13 OR g_m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#         IF g_m2 < 1 OR g_m2 > 13 THEN
#            CALL cl_err(g_m2,"agl-013",0)
#            NEXT FIELD m2
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD rate
         IF g_rate < 0 THEN
            CALL cl_err(g_rate,"afa-040",0)
            NEXT FIELD rate
         END IF
            
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nqc2)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nqc2
               CALL cl_create_qry() RETURNING g_nqc2
               DISPLAY BY NAME g_nqc2
               NEXT FIELD nqc2
            OTHERWISE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i910_r
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = "Y"
   LET l_beg = g_y1 * 13 + g_m1
   LET l_end = g_y2 * 13 + g_m2
 
   FOR l_co = l_beg TO l_end
      LET l_nqc04 = l_co MOD 13
      IF l_nqc04 = 0 THEN
         LET l_nqc04 = 13
      END IF
      LET l_nqc03 = (l_co - l_nqc04) / 13
   
      SELECT COUNT(*) INTO g_cnt FROM nqc_file
       WHERE nqc01 = g_nqc01
         AND nqc02 = g_nqc2
         AND nqc03 = l_nqc03
         AND nqc04 = l_nqc04
      IF g_cnt > 0 THEN
         CALL cl_err("","axm-298",0)
         LET g_success = "N"
         EXIT FOR
      END IF
 
      SELECT nqa01 INTO g_nqc01 FROM nqa_file WHERE nqa00 = "0"
      IF cl_null(g_nqc01) THEN LET g_nqc01 = ' ' END IF #TQC-790001
      INSERT INTO nqc_file (nqc01,nqc02,nqc03,nqc04,nqc05,nqcoriu,nqcorig)
           VALUES(g_nqc01,g_nqc2,l_nqc03,l_nqc04,g_rate, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
      IF SQLCA.sqlcode THEN
         LET g_success = "N"
         EXIT FOR
      END IF
   END FOR
 
   IF g_success = "Y" THEN
      CALL cl_err("","abm-019",1)
      COMMIT WORK
   ELSE
      CALL cl_err("","abm-020",1)
      ROLLBACK WORK
   END IF
 
   CLOSE WINDOW i910_r
 
   LET g_nqc02 = g_nqc2
 
   CALL i910_show()
 
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i910_out()
#   DEFINE l_name   LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
#          sr       RECORD     
#                      nqc01    LIKE nqc_file.nqc01,
#                      azi02_1  LIKE azi_file.azi02,
#                      nqc02    LIKE nqc_file.nqc02,
#                      azi02_2  LIKE azi_file.azi02,
#                      nqc03    LIKE nqc_file.nqc03,
#                      nqc04    LIKE nqc_file.nqc04,
#                      nqc05    LIKE nqc_file.nqc05
#                   END RECORD 
#
#   CALL cl_wait()
#   CALL cl_outnam('anmi910') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#   LET g_sql = "SELECT nqc01,'',nqc02,'',nqc03,nqc04,nqc05",
#               "  FROM nqc_file ",
#               " WHERE ",g_wc CLIPPED
#
#   PREPARE i910_p1 FROM g_sql
#   DECLARE i910_curo CURSOR FOR i910_p1
#
#   START REPORT i910_rep TO l_name
#
#   FOREACH i910_curo INTO sr.*   
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#         EXIT FOREACH
#      END IF
#
#      SELECT azi02 INTO sr.azi02_1 FROM azi_file
#       WHERE azi01 = sr.nqc01
#
#      SELECT azi02 INTO sr.azi02_2 FROM azi_file
#       WHERE azi01 = sr.nqc02
#
#      OUTPUT TO REPORT i910_rep(sr.*)
#
#   END FOREACH
#
#   FINISH REPORT i910_rep
#
#   CLOSE i910_curo
#   ERROR ""
#
#   CALL cl_prt(l_name,' ','1',g_len)
#
#END FUNCTION
#
#REPORT i910_rep(sr)
#   DEFINE l_trailer_sw   LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1)
#          sr             RECORD     
#                            nqc01    LIKE nqc_file.nqc01,
#                            azi02_1  LIKE azi_file.azi02,
#                            nqc02    LIKE nqc_file.nqc02,
#                            azi02_2  LIKE azi_file.azi02,
#                            nqc03    LIKE nqc_file.nqc03,
#                            nqc04    LIKE nqc_file.nqc04,
#                            nqc05    LIKE nqc_file.nqc05
#                         END RECORD 
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.nqc01,sr.nqc02,sr.nqc03,sr.nqc04
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno" 
#         PRINT g_head CLIPPED,pageno_total     
#         PRINT 
#         PRINT g_dash
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
#         PRINT g_dash1 
#         LET l_trailer_sw = "Y"
#
#      BEFORE GROUP OF sr.nqc02
#         PRINT COLUMN g_c[31],sr.nqc01 CLIPPED,
#               COLUMN g_c[32],sr.nqc02 CLIPPED;
#
#      ON EVERY ROW
#         PRINT COLUMN g_c[33],sr.nqc03 USING "####",
#               COLUMN g_c[34],sr.nqc04 USING "##",
#              #COLUMN g_c[35],cl_numfor(sr.nqc05,35,0)   #No.TQC-760066 
#               COLUMN g_c[35],sr.nqc05                   #No.TQC-760066 
#
#      ON LAST ROW
#         PRINT g_dash
#         PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#         LET l_trailer_sw = "N"
#
#      PAGE TRAILER
#         IF l_trailer_sw = "Y" THEN
#             PRINT g_dash
#             PRINT g_x[4] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#             SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-790050  --End  
