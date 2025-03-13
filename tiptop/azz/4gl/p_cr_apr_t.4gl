# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: p_cr_apr_t.4gl
# Descriptions...: 報表簽核欄維護作業
# Date & Author..: 11/12/09 By Downheal
# Modify.........: No.FUN-BB0127 11/12/04 By Downheal 透過簽核代號來維護報表簽核欄(語言別、序號、職稱)
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_gdx01          LIKE gdx_file.gdx01     # 簽核代號
DEFINE   g_gdx01_t        LIKE gdx_file.gdx01     # 簽核代號舊值

DEFINE   g_gdx_lock RECORD LIKE gdx_file.*        # FOR LOCK CURSOR TOUCH
DEFINE   g_gdx    DYNAMIC ARRAY of RECORD         
            gdx03          LIKE gdx_file.gdx03,   # 語言別
            gdx02          LIKE gdx_file.gdx02,   # 關卡順序
            gdx04          LIKE gdx_file.gdx04    # 簽核人員職稱
            END RECORD
DEFINE   g_gdx_t           RECORD                 # 變數舊值
            gdx03          LIKE gdx_file.gdx03,   # 語言別
            gdx02          LIKE gdx_file.gdx02,   # 關卡順序
            gdx04          LIKE gdx_file.gdx04    # 簽核人員職稱
            END RECORD

DEFINE   g_gdx02_max           LIKE gdx_file.gdx02     #最大關卡序號
DEFINE   g_argv1               LIKE gcx_file.gcx01     #傳入之簽核代號
DEFINE   g_wc                  STRING
DEFINE   g_sql                 STRING
DEFINE   g_ss                  LIKE type_file.chr1     # 決定後續步驟
DEFINE   g_rec_b               LIKE type_file.num5     # 單身筆數
DEFINE   l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT
DEFINE   g_chr                 LIKE type_file.chr1
DEFINE   g_cnt                 LIKE type_file.num10
DEFINE   g_cnt2                LIKE type_file.num5
DEFINE   g_msg                 LIKE type_file.chr1000
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_curs_index          LIKE type_file.num10
DEFINE   g_row_count           LIKE type_file.num10
DEFINE   g_jump                LIKE type_file.num10
DEFINE   g_no_ask              LIKE type_file.num5
DEFINE   g_seq_limit           LIKE type_file.num5     #單身序號最大限制

DEFINE   l_sql                 STRING
DEFINE   g_i                   LIKE type_file.num5
DEFINE   g_zemsg               DYNAMIC ARRAY OF STRING




MAIN

   OPTIONS                                         #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                 #擷取中斷鍵, 由程式處理

   LET g_argv1 = ARG_VAL(1)                        #傳入之簽核代號
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_gdx01_t = NULL
   LET g_seq_limit = 12 #單身筆數最大限制

   OPEN WINDOW p_cr_apr_t_w WITH FORM "azz/42f/p_cr_apr_t"  #No.FUN-BB0127
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_set_action_active("up,down", FALSE)
   CALL cl_ui_init()
   CALL cl_set_action_active("up,down", FALSE)
   CALL cl_set_combo_lang("gdx03")      #語言別選項

   LET g_forupd_sql =" SELECT * FROM gdx_file ",
                      " WHERE gdx01 = ?",
                      " ORDER BY gdx01,gdx02,gdx03",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_cr_apr_t_lock_u CURSOR FROM g_forupd_sql

   IF NOT cl_null(g_argv1) THEN
      CALL p_cr_apr_t_q()
   END IF

   CALL p_cr_apr_t_menu()

   CLOSE WINDOW p_cr_apr_t_w                     #結束畫面
     CALL  cl_used(g_prog,g_time,2)              #計算使用時間 (退出時間)
         RETURNING g_time
END MAIN

FUNCTION p_cr_apr_t_curs(l_flag)                 #QBE 查詢資料
   DEFINE  l_flag        LIKE type_file.chr1
   DEFINE  l_str         STRING

   CLEAR FORM                                    #清除畫面
   CALL g_gdx.clear()
   IF NOT cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")
      LET g_wc = NULL
      LET g_gdx01 = g_argv1                      #有傳遞參數
      DISPLAY g_gdx01 TO gcx01
      INPUT g_gdx[1].* WITHOUT DEFAULTS FROM s_gcx.*
         BEFORE INPUT
            DISPLAY g_gdx01 TO gdx01

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION help
            CALL cl_show_help()
         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION about
            CALL cl_about()
      END INPUT

      IF NOT cl_null(g_gdx01) THEN
         LET g_wc = "gdx01 = '",g_gdx01 CLIPPED,"'"
      END IF

      IF INT_FLAG THEN RETURN END IF   

   ELSE   #程式沒有傳入簽核參數
      CALL cl_set_head_visible("","YES")
      IF l_flag = "1" THEN
         CONSTRUCT BY NAME g_wc ON gdx01
         BEFORE CONSTRUCT 
         LET g_wc = NULL
         LET g_gdx01 = NULL
         
            #ON ACTION controlp
               #CASE
                   #WHEN INFIELD(gdx01)
                     #CALL cl_init_qry_var()            
                     #LET g_qryparam.form = "q_gdx01"
                     #LET g_qryparam.default1 = g_gdx01
                     #CALL cl_create_qry() RETURNING g_gdx01
                     #DISPLAY g_gdx01 TO gdx01
                     #NEXT FIELD gdx02
                  #OTHERWISE
                     #EXIT CASE
               #END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
            ON ACTION help
               CALL cl_show_help()
            ON ACTION controlg
               CALL cl_cmdask()
            ON ACTION about
               CALL cl_about()
               
         END CONSTRUCT
      END IF

      IF NOT cl_null(g_gdx01) THEN
         LET g_wc = "gdx01 = '",g_gdx01 CLIPPED,"'"
      END IF

      IF INT_FLAG THEN RETURN END IF
   END IF
   
   IF cl_null(g_wc) THEN
      LET g_wc = "1=1"
   END IF

   LET g_sql=" SELECT gdx01 FROM gdx_file ",
                    " WHERE ",g_wc CLIPPED,
                    " GROUP BY gdx01"
   PREPARE p_cr_apr_t_prepare FROM g_sql          # 預備一下
   DECLARE p_cr_apr_t_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_cr_apr_t_prepare
END FUNCTION

FUNCTION p_cr_apr_t_count()
   DEFINE li_cnt   LIKE type_file.num10
   DEFINE li_rec_b LIKE type_file.num10
   DEFINE l_gdx_c  RECORD
             gdx01   LIKE gdx_file.gdx01
             END RECORD

   LET g_sql= "SELECT gdx01 FROM gdx_file ",
              " WHERE ", g_wc CLIPPED,
              " GROUP BY gdx01",
              " ORDER BY gdx01"              
   PREPARE p_cr_apr_t_precount FROM g_sql
   DECLARE p_cr_apr_t_count CURSOR FOR p_cr_apr_t_precount

   LET li_cnt=1
   LET li_rec_b=0
   FOREACH p_cr_apr_t_count INTO l_gdx_c.*
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b

END FUNCTION

FUNCTION p_cr_apr_t_menu()

   WHILE TRUE
      CALL p_cr_apr_t_bp("G")

      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_cr_apr_t_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL p_cr_apr_t_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_cr_apr_t_copy()
            END IF
        WHEN "delete"                          # R.取消(刪除)
           IF cl_chk_act_auth() THEN
              CALL p_cr_apr_t_r()
           END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_cr_apr_t_q()
            END IF
         WHEN "detail"                          # 單身
            IF cl_chk_act_auth() THEN
               CALL p_cr_apr_t_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdx),'','')
            END IF

      END CASE
   END WHILE
END FUNCTION

FUNCTION p_cr_apr_t_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gdx.clear()

   INITIALIZE g_gdx01 LIKE gdx_file.gdx01

   CALL cl_opmsg('a')

   WHILE TRUE
      CALL p_cr_apr_t_i("a")                     # 輸入單頭

      IF INT_FLAG THEN                          
         LET g_gdx01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0

      IF g_ss='N' THEN
         CALL g_gdx.clear()
      ELSE
         CALL p_cr_apr_t_b_fill('1=1')             # 單身
      END IF

      CALL p_cr_apr_t_b()                          # 輸入單身
      LET g_gdx01_t=g_gdx01
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p_cr_apr_t_i(p_cmd)                      # 處理INPUT
   DEFINE   p_cmd        LIKE type_file.chr1    
   DEFINE   l_count      LIKE type_file.num5

   LET g_ss = 'Y'

   CALL cl_set_head_visible("","YES")

   INPUT g_gdx01 WITHOUT DEFAULTS FROM gdx01
      BEFORE INPUT
         CALL p_cr_apr_t_combo_gdx01("N")      
         DISPLAY g_gdx01 TO gdx01

      AFTER INPUT
         IF (NOT cl_null(g_gdx01)) THEN
            IF (g_gdx01 != g_gdx01_t OR cl_null(g_gdx01_t)) THEN
               SELECT COUNT(*) INTO g_cnt FROM gdx_file
                  WHERE gdx01 = g_gdx01
               IF g_cnt <= 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     LET g_gdx01 = g_gdx01_t
                     CALL p_cr_apr_t_combo_gdx01("N")      #"單別"下拉式選單
                     DISPLAY g_gdx01 TO gdx01
                  END IF
               END IF
            END IF
         END IF

      #ON ACTION controlp
         #CASE
            #WHEN INFIELD(gdx01)
            #CALL cl_init_qry_var()            
            #LET g_qryparam.form = "q_gdx01"
            #LET g_qryparam.default1 = g_gdx01
            #CALL cl_create_qry() RETURNING g_gdx01
            #DISPLAY g_gdx01 TO gdx01
            #NEXT FIELD gdx02
         #OTHERWISE
            #EXIT CASE
      #END CASE
         
      ON ACTION controlf
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


FUNCTION p_cr_apr_t_u()   #更改 單頭
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gdx01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gdx01_t = g_gdx01

   BEGIN WORK
   OPEN p_cr_apr_t_lock_u USING g_gdx01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_cr_apr_t_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_cr_apr_t_lock_u INTO g_gdx_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gdx01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_cr_apr_t_lock_u
      ROLLBACK WORK
      RETURN
   END IF

   WHILE TRUE
      CALL p_cr_apr_t_i("u")
      IF INT_FLAG THEN
         LET g_gdx01 = g_gdx01_t
         DISPLAY g_gdx01 TO gdx01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gdx_file SET gdx01=g_gdx01
         WHERE gdx01 = g_gdx01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gdx_file",g_gdx01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION

FUNCTION p_cr_apr_t_q()                            #Query 查詢
   CALL cl_opmsg('q')
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   CALL g_gdx.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   CALL p_cr_apr_t_curs("1")                       #取得查詢條件

   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   
   OPEN p_cr_apr_t_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gdx01 TO NULL
   ELSE
      CALL p_cr_apr_t_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_cr_apr_t_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION p_cr_apr_t_fetch(p_flag)                #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,        #處理方式
            l_abso   LIKE type_file.num10        #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_cr_apr_t_b_curs INTO g_gdx01
      WHEN 'P' FETCH PREVIOUS p_cr_apr_t_b_curs INTO g_gdx01
      WHEN 'F' FETCH FIRST    p_cr_apr_t_b_curs INTO g_gdx01
      WHEN 'L' FETCH LAST     p_cr_apr_t_b_curs INTO g_gdx01
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION controlp
                   CALL cl_cmdask()

                ON ACTION help
                   CALL cl_show_help()

                ON ACTION about
                   CALL cl_about()

            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_cr_apr_t_b_curs INTO g_gdx01
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gdx01,SQLCA.sqlcode,0)
      INITIALIZE g_gdx01 TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL p_cr_apr_t_show()
   END IF
END FUNCTION

FUNCTION p_cr_apr_t_show()            #將資料顯示在畫面上
   CALL p_cr_apr_t_combo_gdx01("N")   #"單別"下拉式選單
   DISPLAY g_gdx01 TO gdx01
   CALL p_cr_apr_t_b_fill(g_wc) 
   CALL cl_show_fld_cont()
   CALL p_cr_apr_t_gdx02_max()        #最大關卡序號
END FUNCTION


FUNCTION p_cr_apr_t_r()               #取消整筆 (刪除所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,
            l_gdx   RECORD LIKE gdx_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gdx01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gdx_file
         WHERE gdx01 = g_gdx01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdx_file",g_gdx01,"",SQLCA.sqlcode,"","BODY DELETE",0)
      ELSE
         CLEAR FORM
         CALL g_gdx.clear()
         CALL p_cr_apr_t_count()
         DISPLAY g_row_count TO FORMONLY.cnt

         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            COMMIT WORK
            RETURN
         END IF

         OPEN p_cr_apr_t_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_cr_apr_t_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL p_cr_apr_t_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

FUNCTION p_cr_apr_t_b()
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,               # 檢查重複用
            l_cnt           LIKE type_file.num5,
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否
            p_cmd           LIKE type_file.chr1,               # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   l_count         LIKE type_file.num5
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
  LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gdx01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   LET g_forupd_sql= "SELECT gdx03,gdx02,gdx04 ",
                     "  FROM gdx_file ",
                     " WHERE gdx01 = ? AND gdx03 = ? AND gdx02 = ? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_cr_apr_t_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0

   INPUT ARRAY g_gdx WITHOUT DEFAULTS FROM s_gdx.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gdx_t.* = g_gdx[l_ac].*
            OPEN p_cr_apr_t_bcl USING g_gdx01,g_gdx_t.gdx03,g_gdx_t.gdx02
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_cr_apr_t_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_cr_apr_t_bcl INTO g_gdx[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_cr_apr_t_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gdx[l_ac].* TO NULL
         LET g_gdx_t.* = g_gdx[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD gdx03

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF

         INSERT INTO gdx_file(gdx01,gdx03,gdx02,gdx04)
                      VALUES (g_gdx01,g_gdx[l_ac].gdx03,g_gdx[l_ac].gdx02,g_gdx[l_ac].gdx04)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gdx_file",g_gdx01,"",SQLCA.sqlcode,"","",0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      BEFORE FIELD gdx02                       #default 序號
         IF cl_null(g_gdx[l_ac].gdx02) OR g_gdx[l_ac].gdx02 = 0 THEN
            SELECT max(gdx02)+1 INTO g_gdx[l_ac].gdx02 FROM gdx_file
               WHERE gdx01 = g_gdx01 AND
                     gdx03 = g_gdx[l_ac].gdx03
            IF cl_null(g_gdx[l_ac].gdx02) THEN
               LET g_gdx[l_ac].gdx02 = 1
            END IF
         END IF
         
      AFTER FIELD gdx02                        #check 序號是否重複
         IF NOT cl_null(g_gdx[l_ac].gdx02) THEN
            IF g_gdx[l_ac].gdx02 <= 0 OR g_gdx[l_ac].gdx02 > g_seq_limit THEN   #序號是否在合理範圍內
               CALL cl_err('','azz1188',0)
               NEXT FIELD gdx02
            END IF
            IF g_gdx[l_ac].gdx02 != g_gdx_t.gdx02 OR
               cl_null(g_gdx_t.gdx02) THEN
               SELECT count(*) INTO l_n FROM gdx_file
                  WHERE gdx01 = g_gdx01 AND
                        gdx03 = g_gdx[l_ac].gdx03 AND
                        gdx02 = g_gdx[l_ac].gdx02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gdx[l_ac].gdx02 = g_gdx_t.gdx02
                  NEXT FIELD gdx02
               END IF
            END IF
         ELSE
            CALL cl_err('','azz-527',0)
            NEXT FIELD gdx02
         END IF

      AFTER FIELD gdx03
         IF cl_null(g_gdx[l_ac].gdx03) THEN
            CALL cl_err('','azz-527',0)
            NEXT FIELD gdx03
         END IF

      AFTER FIELD gdx04
         IF cl_null(g_gdx[l_ac].gdx04) THEN
            CALL cl_err('','azz-527',0)
            NEXT FIELD gdx04
         END IF         
         
      BEFORE DELETE
         IF (NOT cl_null(g_gdx01)) AND
            (NOT cl_null(g_gdx_t.gdx03)) AND
            (NOT cl_null(g_gdx_t.gdx02)) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF

            DELETE FROM gdx_file WHERE gdx01 = g_gdx01
                                   AND gdx03 = g_gdx[l_ac].gdx03
                                   AND gdx02 = g_gdx[l_ac].gdx02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gdx_file",g_gdx[l_ac].gdx03,g_gdx[l_ac].gdx02,SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gdx[l_ac].* = g_gdx_t.*
            CLOSE p_cr_apr_t_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gdx[l_ac].gdx03,-263,1)
            LET g_gdx[l_ac].* = g_gdx_t.*
         ELSE
            UPDATE gdx_file
               SET gdx03 = g_gdx[l_ac].gdx03,
                   gdx02 = g_gdx[l_ac].gdx02,
                   gdx04 = g_gdx[l_ac].gdx04
               WHERE gdx01 = g_gdx01 AND
                     gdx03 = g_gdx_t.gdx03 AND
                     gdx02 = g_gdx_t.gdx02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gdx_file",g_gdx_t.gdx03,g_gdx_t.gdx02,SQLCA.sqlcode,"","",0)
               LET g_gdx[l_ac].* = g_gdx_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               #修改新值
               LET ls_msg_n = g_gdx01 CLIPPED,"",
                              g_gdx[l_ac].gdx03 CLIPPED,"",g_gdx[l_ac].gdx02 CLIPPED,"",
                              g_gdx[l_ac].gdx04 CLIPPED
               #修改舊值
               LET ls_msg_o = g_gdx01 CLIPPED,"",
                              g_gdx_t.gdx03 CLIPPED,"",g_gdx_t.gdx02 CLIPPED,"",
                              g_gdx_t.gdx04 CLIPPED
                CALL cl_log("p_cr_apr_t","U",ls_msg_n,ls_msg_o)   #紀錄程式資料變更
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gdx[l_ac].* = g_gdx_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gdx.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_cr_apr_t_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE p_cr_apr_t_bcl
         COMMIT WORK

      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gdx03) AND l_ac > 1 THEN
            LET g_gdx[l_ac].* = g_gdx[l_ac-1].*
            NEXT FIELD gdx03
         END IF

      ON ACTION CONTROLG                       #執行
          CALL cl_cmdask()

      ON ACTION CONTROLR                       #必要欄位
         CALL cl_show_req_fields()

      ON ACTION CONTROLF                       #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help                           #說明
         CALL cl_show_help()

      ON ACTION about                          #程式資訊
         CALL cl_about()

      ON ACTION controls                       #單頭摺疊，可利用hot key "Ctrl-s"開啟/關閉單頭區塊
         CALL cl_set_head_visible("","AUTO")
   END INPUT

   CLOSE p_cr_apr_t_bcl
   COMMIT WORK
END FUNCTION


FUNCTION p_cr_apr_t_b_fill(p_wc)   #單身填充
   DEFINE p_wc         STRING

   LET g_sql = "SELECT gdx03,gdx02,gdx04 ",
               " FROM gdx_file ",
               " WHERE gdx01 = '",g_gdx01 CLIPPED,"' AND ",p_wc CLIPPED,
               " ORDER BY gdx02,gdx03"
   PREPARE p_cr_apr_t_prepare2 FROM g_sql
   IF SQLCA.SQLCODE THEN
         CALL cl_err("prepare p_cr_apr_t_prepare2: ", SQLCA.SQLCODE, 1)
         EXIT PROGRAM
      END IF
   DECLARE gdx_curs CURSOR FOR p_cr_apr_t_prepare2

   CALL g_gdx.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   FOREACH gdx_curs INTO g_gdx[g_cnt].*       #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gdx.deleteElement(g_cnt)

   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION


FUNCTION p_cr_apr_t_bp(p_ud)   #單身
   DEFINE   p_ud   LIKE type_file.chr1
   DEFINE   l_n    LIKE type_file.num5   #列數

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gdx TO s_gdx.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL p_cr_apr_t_gdx02_max()     #最大關卡序號

      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()
         CALL cl_show_fld_cont()

         IF l_n >0 THEN
            CALL cl_set_action_active("up,down", TRUE)
            IF g_gdx[l_ac].gdx02 = 1 THEN
               CALL cl_set_action_active("up", FALSE)
            END IF
            IF g_gdx[l_ac].gdx02 = g_gdx02_max THEN
               CALL cl_set_action_active("down", FALSE)
            END IF
         ELSE
            CALL cl_set_action_active("up,down", FALSE)
         END IF

      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY

      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY

      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY

      ON ACTION reproduce                        # C.複製
         LET g_action_choice='reproduce'
         EXIT DISPLAY

     ON ACTION delete                           # R.取消
        LET g_action_choice='delete'
        EXIT DISPLAY

      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION accept                           # 確定
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel                           # 放棄
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION first                            # 第一筆
         CALL p_cr_apr_t_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY

      ON ACTION previous                         # P.上筆
         CALL p_cr_apr_t_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	     ACCEPT DISPLAY

      ON ACTION jump                             # 指定筆
         CALL p_cr_apr_t_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	     ACCEPT DISPLAY

      ON ACTION next                             # N.下筆
         CALL p_cr_apr_t_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	     ACCEPT DISPLAY

      ON ACTION last                             # 最終筆
         CALL p_cr_apr_t_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	     ACCEPT DISPLAY

       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY

      ON ACTION locale                            # 語言
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL p_cr_apr_t_combo_gdx01("N")      #"單別"下拉式選單
         CALL cl_set_combo_lang("gdx03")       #語言別選項
         EXIT DISPLAY

      ON ACTION exit                              # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about
         CALL cl_about()

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION up
         CALL p_cr_apr_t_seq(-1)   #單身序號移動
         IF g_gdx[l_ac].gdx02 = 1 THEN
            CALL cl_set_action_active("up", FALSE)
         END IF

      ON ACTION down
         CALL p_cr_apr_t_seq(1)   #單身序號移動
         IF g_gdx[l_ac].gdx02 = g_gdx02_max THEN
            CALL cl_set_action_active("down", FALSE)
         END IF
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_action_active("up,down", FALSE)
END FUNCTION


FUNCTION p_cr_apr_t_copy()   #複製
   DEFINE   l_n       LIKE type_file.num5
   DEFINE   l_new01   LIKE gdx_file.gdx01
   DEFINE   l_old02   LIKE gdx_file.gdx01

   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF

   LET g_gdx01_t = g_gdx01

   DISPLAY g_gdx01 TO gdx01

   IF cl_null(g_gdx01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   CALL cl_set_head_visible("","YES")

   INPUT g_gdx01 WITHOUT DEFAULTS FROM gdx01
      BEFORE INPUT

         DISPLAY g_gdx01 TO gdx01

         ON CHANGE gdx01
#         LET g_gdx01 = 0
         DISPLAY g_gdx01 TO　gdx01
         CALL p_cr_apr_t_combo_gdx01("N")       #"單別"下拉式選單

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

         IF cl_null(g_gdx01) THEN
            NEXT FIELD gdx01
         END IF

         SELECT COUNT(*) INTO g_cnt FROM gdx_file
            WHERE gdx01 = g_gdx01
         IF g_cnt > 0 THEN
            CALL cl_err(g_gdx01,-239,0)
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()

   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gdx01_t TO gdx01
      RETURN
   END IF

   DROP TABLE x

   SELECT * FROM gdx_file WHERE gdx01 = g_gdx01_t
      INTO TEMP x

   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_gdx01,"",SQLCA.sqlcode,"","",0)
      RETURN
   END IF

   UPDATE x
      SET gdx01 = g_gdx01                        # 資料鍵值

   INSERT INTO gdx_file SELECT * FROM x

   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","gdx_file",g_gdx01,"",SQLCA.sqlcode,"","",0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'

   CALL p_cr_apr_t_b()   #單身

   #複製後重新查詢，並且只顯示此筆資料，以避免按"上下筆"按鈕導致出現之前的資料
   CALL p_cr_apr_t_curs("2")
   OPEN p_cr_apr_t_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                     #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gdx01 TO NULL
   ELSE
      CALL p_cr_apr_t_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_cr_apr_t_fetch('F')             #讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION p_cr_apr_t_combo_gdx01(p_it)  #"單別"下拉式選單
   DEFINE p_it          LIKE type_file.chr1   #是否改變combo內容 Y/N
   DEFINE ls_values     STRING                #所對應的儲存值字串(中間以逗點分隔)
   DEFINE ls_items      STRING                #Item字串(中間以逗點分隔)
   DEFINE l_values      LIKE apy_file.apyslip
   DEFINE l_items       LIKE apy_file.apyslip
   DEFINE l_sql         STRING
   DEFINE l_str         STRING

   LET l_sql = ""
   LET ls_values = ""
   LET ls_items = ""

   IF p_it="Y" THEN   #是否開窗查詢
      #CALL cl_set_combo_items("gdx01",ls_values,ls_values)   #產生下拉式選單
      #p_qry設定的sql，必須與p_cr_apr.4gl的FUNCTION p_cr_apr_combo_gdx01中的l_sql相同
      CALL cl_init_qry_var()
      LET g_qryparam.form = "q_gdx01"      
      LET g_qryparam.default1 = g_gdx01
      CALL cl_create_qry() RETURNING g_gdx01
      DISPLAY g_gdx01 TO gdx01
   END IF

END FUNCTION

FUNCTION p_cr_apr_t_seq(p_move)   #單身序號移動
   DEFINE   p_move   LIKE type_file.num10     #往上、往下移動多少列
   DEFINE   l_i      LIKE type_file.num10
   DEFINE   l_j      LIKE type_file.num10
   DEFINE   l_x      LIKE type_file.num10

   BEGIN WORK
      LET l_i = g_gdx[l_ac].gdx02             #目前的序號
      LET l_j = g_gdx[l_ac].gdx02 + p_move    #new序號

      UPDATE gdx_file SET gdx02=-1            #up僮Y已有資料，暫時先改為序號為-1
         WHERE gdx01=g_gdx01 AND gdx02=l_j
      IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gdx_file",g_gdx01,"",SQLCA.sqlcode,"","",0)
            ROLLBACK WORK
      END IF

      UPDATE gdx_file SET gdx02=l_j           #移動至up
         WHERE gdx01=g_gdx01 AND gdx02=l_i
      IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gdx_file",g_gdx01,"",SQLCA.sqlcode,"","",0)
            ROLLBACK WORK
      END IF

      UPDATE gdx_file SET gdx02=l_i           #調換序號-1的資料
         WHERE gdx01=g_gdx01 AND gdx02=-1
      IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gdx_file",g_gdx01,"",SQLCA.sqlcode,"","",0)
            ROLLBACK WORK
      END IF

      CALL p_cr_apr_t_b_fill('1=1')             #單身

      FOR l_x=1 TO g_gdx.getlength()
         IF g_gdx[l_x].gdx02=l_j THEN
            LET l_ac = l_x                    #目前處理的ARRAY CNT
            CALL fgl_set_arr_curr(l_ac)       #指定游標位置
            EXIT FOR
         END IF
      END FOR
   COMMIT WORK
END FUNCTION


FUNCTION p_cr_apr_t_gdx02_max()   #最大關卡序號
   SELECT MAX(gdx02) INTO　g_gdx02_max　FROM gdx_file
      WHERE gdx01=g_gdx01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gdx_file",g_gdx01,"",SQLCA.sqlcode,"","",0)
   END IF
   IF cl_null(g_gdx02_max) THEN
      LET g_gdx02_max = 0
   END IF
END FUNCTION

FUNCTION p_cr_apr_t_combo_def(p_str)   #下拉式選單預設第一個值
   DEFINE p_str         STRING
   DEFINE l_default     STRING                #預設值
   DEFINE l_spos        LIKE type_file.num10  #開始位置
   DEFINE l_epos        LIKE type_file.num10  #結束位置

   LET l_epos = p_str.getindexof(",", 1)
   IF l_epos=0 THEN
      LET l_epos = p_str.getlength()
   ELSE
      LET l_epos = l_epos-1
   END IF
   LET l_default = p_str.substring(1, l_epos)

   RETURN l_default
END FUNCTION
