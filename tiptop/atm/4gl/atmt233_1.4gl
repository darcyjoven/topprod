# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmt233_1.4gl
# Descriptions...: 提案明細維護作業
# Date & Author..: 2006/01/13 By Elva
# Modify         : No.FUN-590083 06/03/31 By Alexstar 新增多語言資料顯示功能
# Modify.........: No.FUN-660104 06/06/19 By cl  Error Message 調整
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By Carrier 新增單頭折疊功能
# Modify.........: No.TQC-6C0217 06/12/30 By Rayven 取消明細維護按鈕中的查詢按鈕
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-940184 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_tsa_h    RECORD                     #程式變數(Program Variables)
                        tsa01      LIKE tsa_file.tsa01,
                        tqy03      LIKE tqy_file.tqy03,
                        tsa02      LIKE tsa_file.tsa02,
                        occ02      LIKE occ_file.occ02,
                        tqy10      LIKE tqy_file.tqy10,
                        tqy11      LIKE tqy_file.tqy11
                     END RECORD,
       g_tsa_b    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                        tsa03      LIKE tsa_file.tsa03,
                        tqz03      LIKE tqz_file.tqz03,
                        ima02      LIKE ima_file.ima02,
                        ima31      LIKE ima_file.ima31,
                        tsa04      LIKE tsa_file.tsa04,
                        tsa05      LIKE tsa_file.tsa05, 
                        tsa08      LIKE tsa_file.tsa08
                     END RECORD,
       g_tsa_b_t  RECORD
                        tsa03      LIKE tsa_file.tsa03,
                        tqz03      LIKE tqz_file.tqz03,
                        ima02      LIKE ima_file.ima02,
                        ima31      LIKE ima_file.ima31,
                        tsa04      LIKE tsa_file.tsa04,
                        tsa05      LIKE tsa_file.tsa05, 
                        tsa08      LIKE tsa_file.tsa08
                     END RECORD,
       l_tqy      RECORD 
                        tqy22   LIKE tqy_file.tqy22,
                        tqy23   LIKE tqy_file.tqy23,
                        tqy25   LIKE tqy_file.tqy25,
                        tqy26   LIKE tqy_file.tqy26,
                        tqy27   LIKE tqy_file.tqy27,
                        tqy29   LIKE tqy_file.tqy29,
                        tqy30   LIKE tqy_file.tqy30,
                        tqy31   LIKE tqy_file.tqy31,
                        tqy33   LIKE tqy_file.tqy33 
                     END RECORD,
       l_tqy_t    RECORD 
                        tqy22   LIKE tqy_file.tqy22,
                        tqy23   LIKE tqy_file.tqy23,
                        tqy25   LIKE tqy_file.tqy25,
                        tqy26   LIKE tqy_file.tqy26,
                        tqy27   LIKE tqy_file.tqy27,
                        tqy29   LIKE tqy_file.tqy29,
                        tqy30   LIKE tqy_file.tqy30,
                        tqy31   LIKE tqy_file.tqy31,
                        tqy33   LIKE tqy_file.tqy33 
                     END RECORD,
       g_gec04       LIKE gec_file.gec04,
       g_tqx01       LIKE tqx_file.tqx01,
       g_rec_b       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
       g_rec_b2      LIKE type_file.num5,          # 單身筆數            #No.FUN-680120 SMALLINT
       l_ac          LIKE type_file.num5,          # 目前處理的ARRAY CNT #No.FUN-680120 SMALLINT
       l_sql         LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(1000)
       l_wc,l_wc2    LIKE type_file.chr1000        #No.FUN-680120 VARCHAR(1000)
 
DEFINE  g_cnt          LIKE type_file.num10        #No.FUN-680120 INTEGER
DEFINE  g_i            LIKE type_file.num5         #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE  g_msg          LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE  g_row_count    LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE  g_curs_index   LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE  g_jump         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE  mi_no_ask      LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE  p_row,p_col    LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE  g_forupd_sql   STRING   #SELECT ... FOR UPDATE  SQL
DEFINE  g_before_input_done  LIKE type_file.num5    #No.FUN-680120 SMALLINT
DEFINE  l_tqx14    LIKE tqx_file.tqx14
DEFINE  l_tqx16    LIKE tqx_file.tqx16
 
 
FUNCTION t233_1_detail(p_tqx01)
   DEFINE p_tqx01   LIKE tqx_file.tqx01
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6B0014
 
   IF cl_null(p_tqx01) THEN RETURN END IF
 
   LET g_tqx01 = p_tqx01
 
   WHENEVER ERROR CALL cl_err_msg_log
  
 
   LET g_forupd_sql = "SELECT * FROM tsa_file  WHERE tsa01 = ?  ",
                      "   AND tsa02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t233_1_cl CURSOR FROM g_forupd_sql  # LOCK CURSOR
 
   DROP TABLE x
   DROP TABLE y
# No.FUN-680120-BEGIN
   CREATE TEMP TABLE x(
       x00 LIKE oea_file.oea01,
       x01 LIKE type_file.num10)
# No.FUN-680120-END       
   IF STATUS THEN
      CALL cl_err('create #1',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
# No.FUN-680120-BEGINE
   CREATE TEMP TABLE y( 
       y00 LIKE oea_file.oea01,
       y01 LIKE type_file.num10)
# No.FUN-680120-END      
   IF STATUS THEN 
      CALL cl_err('create #2',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
      EXIT PROGRAM
   END IF
 
   # 維護提案明細資料
   OPEN WINDOW t233_1_w AT 4,24 WITH FORM "atm/42f/atmt233_6"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt233_6")
 
   IF NOT cl_null(g_tqx01) THEN 
      CALL t233_1_q()
   END IF
 
   CALL t233_1_menu()
 
   CLOSE WINDOW t233_1_w          # 結束畫面
END FUNCTION
 
FUNCTION t233_1_menu()
 
   WHILE TRUE
      CALL t233_1_bp("G")
      CASE g_action_choice
#No.TQC-6C0217 --start-- mark
#        WHEN "query" 
#           IF cl_chk_act_auth() THEN
#              CALL t233_1_q()
#           END IF
#No.TQC-6C0217 --end--
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
  {       WHEN "other_detail"
            IF cl_chk_act_auth() THEN
            END IF  }
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t233_1_b()
            END IF
         WHEN "other_data"
            IF cl_chk_act_auth() THEN
               CALL t233_1_o()
            END IF
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tsa_b),'','')
            END IF
      END CASE
   END WHILE
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
END FUNCTION
 
FUNCTION t233_1_cs()
 
    CLEAR FORM                             #清除畫面
    CALL g_tsa_b.clear()
 
    CALL cl_set_head_visible("","YES")  #No.FUN-6B0031
    IF NOT cl_null(g_tqx01) THEN 
       LET l_wc = " tsa01 = '", g_tqx01 CLIPPED, "'"
       LET l_wc2= " 1=1 "
    ELSE 
   INITIALIZE g_tsa_h.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME l_wc ON tsa01,tsa02     # 螢幕上取單頭條件
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
        {  ON ACTION CONTROLP 
             CASE
                WHEN INFIELD(tsa01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form  = "q_tc_ocm"
                     LET g_qryparam.default1 = g_tsa_h.tsa01
                     LET g_qryparam.arg1  =g_today
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tsa01
                     NEXT FIELD tsa01	
             END CASE    }
 
          ON ACTION about         #BUG-4C0121
             CALL cl_about()      #BUG-4C0121
 
          ON ACTION help          #BUG-4C0121
             CALL cl_show_help()  #BUG-4C0121
 
          ON ACTION controlg      #BUG-4C0121
             CALL cl_cmdask()     #BUG-4C0121
    
       END CONSTRUCT
       LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
       CONSTRUCT l_wc2 ON tsa03,tsa04,tsa05,tsa08
            FROM s_tsa[1].tsa03,s_tsa[1].tsa04,
                 s_tsa[1].tsa05,s_tsa[1].tsa08
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION about         #BUG-4C0121
             CALL cl_about()      #BUG-4C0121
 
          ON ACTION help          #BUG-4C0121
             CALL cl_show_help()  #BUG-4C0121
 
          ON ACTION controlg      #BUG-4C0121
             CALL cl_cmdask()     #BUG-4C0121
    
       END CONSTRUCT
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
 
    IF l_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET l_sql = "SELECT UNIQUE tsa01,tsa02 FROM tsa_file ",
                   " WHERE ", l_wc CLIPPED,
                   " ORDER BY tsa01,tsa02 "
     ELSE					# 若單身有輸入條件
       LET l_sql = "SELECT UNIQUE tsa01,tsa02 ",
                   "  FROM tsa_file ",
                   " WHERE ", l_wc CLIPPED, " AND ",l_wc2 CLIPPED,
                   " ORDER BY tsa01,tsa02 "
    END IF
 
    PREPARE t233_1_prepare FROM l_sql
    DECLARE t233_1_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t233_1_prepare
 
    IF l_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET l_sql="INSERT INTO x ",
                  "SELECT UNIQUE tsa01,tsa02 FROM tsa_file ",
                  " WHERE ",l_wc CLIPPED 
               #  " ORDER BY tsa01,tsa02 " 
       #因主鍵值有兩個故所抓出資料筆數有誤
       DELETE FROM x
 
       PREPARE t233_1_precount_x  FROM l_sql
       EXECUTE t233_1_precount_x
 
       LET l_sql="SELECT COUNT(*) FROM x "
    ELSE
        LET l_sql="INSERT INTO y",
                  "SELECT UNIQUE tsa01,tsa02 FROM tsa_file ",
                  " WHERE ",l_wc CLIPPED,
                  "   AND ",l_wc2 CLIPPED 
                # " ORDER BY tsa01,tsa02 " 
       #因主鍵值有兩個故所抓出資料筆數有誤
       DELETE FROM y
 
       PREPARE t233_1_precount_y  FROM l_sql
       EXECUTE t233_1_precount_y
 
       LET l_sql="SELECT COUNT(*) FROM y "
 
    END IF
    PREPARE t233_1_precount FROM l_sql
    DECLARE t233_1_count CURSOR FOR t233_1_precount
END FUNCTION
 
FUNCTION t233_1_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
 
   CALL g_tsa_b.clear()
   DISPLAY '   ' TO FORMONLY.cnt  
   CALL t233_1_cs()
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
   END IF
   OPEN t233_1_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tsa_h.* TO NULL
   ELSE
      OPEN t233_1_count
      FETCH t233_1_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t233_1_fetch('F')                 # 讀出TEMP第一筆并顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t233_1_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式       #No.FUN-680120 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t233_1_cs INTO g_tsa_h.tsa01,
                                             g_tsa_h.tsa02
        WHEN 'P' FETCH PREVIOUS t233_1_cs INTO g_tsa_h.tsa01,
                                             g_tsa_h.tsa02
        WHEN 'F' FETCH FIRST    t233_1_cs INTO g_tsa_h.tsa01,
                                             g_tsa_h.tsa02
        WHEN 'L' FETCH LAST     t233_1_cs INTO g_tsa_h.tsa01,
                                             g_tsa_h.tsa02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         #BUG-4C0121
                      CALL cl_about()      #BUG-4C0121
 
                   ON ACTION help          #BUG-4C0121
                      CALL cl_show_help()  #BUG-4C0121
 
                   ON ACTION controlg      #BUG-4C0121
                      CALL cl_cmdask()     #BUG-4C0121
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t233_1_cs INTO g_tsa_h.tsa01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tsa_h.tsa01,SQLCA.sqlcode,0)
        INITIALIZE g_tsa_h.* TO NULL  #TQC-6B0105
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
 
    CALL t233_1_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t233_1_show()
   DEFINE l_occ02     LIKE occ_file.occ02,
          l_tqy36     LIKE tqy_file.tqy36,
          l_dbs       LIKE azp_file.azp03
 
   SELECT tqy03,tqy36,tqy10,tqy11
     INTO g_tsa_h.tqy03,l_tqy36,g_tsa_h.tqy10,
          g_tsa_h.tqy11
     FROM tqy_file
    WHERE tqy01 = g_tsa_h.tsa01
      AND tqy02 = g_tsa_h.tsa02
   #FUN-A50102--mark--str--
   #SELECT azp03 INTO l_dbs
   #  FROM azp_file
   # WHERE azp01=l_tqy36
   #FUN-A50102--mark--end
    
  #LET l_sql="SELECT occ02 FROM ",l_dbs CLIPPED,".occ_file", #TQC-940184   
   #LET l_sql="SELECT occ02 FROM ",s_dbstring(l_dbs CLIPPED),"occ_file", #TQC-940184
   LET l_sql="SELECT occ02 FROM ",cl_get_target_table( l_tqy36, 'occ_file' ), #FUN-A50102
             " WHERE occ01='",g_tsa_h.tqy03 CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_tqy36) RETURNING l_sql #FUN-A50102
   PREPARE show_pre FROM l_sql
   EXECUTE show_pre INTO g_tsa_h.occ02
 
   DISPLAY BY NAME g_tsa_h.tsa01,g_tsa_h.tqy03,
                   g_tsa_h.occ02,g_tsa_h.tsa02,
                   g_tsa_h.tqy10,g_tsa_h.tqy11
 
   CALL t233_1_b_fill(l_wc2)                      # 把單身的資料置入陣列中
   CALL cl_show_fld_cont()                    #FUN-590083
 
END FUNCTION
 
#單身
FUNCTION t233_1_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT#No.FUN-680120 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重復用       #No.FUN-680120 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否       #No.FUN-680120 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否         #No.FUN-680120 SMALLINT
          l_allow_delete  LIKE type_file.num5,                #可刪除否         #No.FUN-680120 SMALLINT
          l_sql           LIKE type_file.chr1000,                               #No.FUN-680120 VARCHAR(300)
          l_tsa03         LIKE tsa_file.tsa03,
          l_tqz031        LIKE tqz_file.tqz031,
          l_tqz08         LIKE tqz_file.tqz08,
          l_tqx07         LIKE tqx_file.tqx07,
          l_sum1          LIKE tqz_file.tqz19,
          l_sum2          LIKE tqz_file.tqz20,
          l_sum3          LIKE tqz_file.tqz21
 
   LET g_action_choice = ""
   IF g_tsa_h.tsa01 IS NULL THEN           #若單頭的KEY欄位是虛值時
      RETURN
   END IF
   SELECT tqx07 INTO l_tqx07
     FROM tqx_file
    WHERE tqx01=g_tsa_h.tsa01
   IF l_tqx07 != '1' THEN
      CALL cl_err(g_tsa_h.tsa01, 'atm-046', 0)
      RETURN
   END IF
   CALL cl_opmsg('b')                     #顯示單身的操作訊息
 
   LET g_forupd_sql = "SELECT tsa03,'','','',tsa04,tsa05,tsa08 ",
                      "  FROM tsa_file",
                      "  WHERE tsa01 = ?  ",
                      "   AND tsa02 = ? ",
                      "   AND tsa03 = ? ",
                      "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t233_1_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_ac=1
 
    INPUT ARRAY g_tsa_b WITHOUT DEFAULTS FROM s_tsa.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            IF g_rec_b>=l_ac THEN 
               LET g_tsa_b_t.* = g_tsa_b[l_ac].*   # 保留舊值
               OPEN t233_1_bcl USING g_tsa_h.tsa01,
                                     g_tsa_h.tsa02,
                                     g_tsa_b_t.tsa03
               IF STATUS THEN
                   CALL cl_err("OPEN t233_1_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                   FETCH t233_1_bcl INTO g_tsa_b[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_tsa_b_t.tsa03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   SELECT tqz03,ima02,tqz08 
                     INTO g_tsa_b[l_ac].tqz03,g_tsa_b[l_ac].ima02,
                          g_tsa_b[l_ac].ima31
                     FROM tqz_file,OUTER ima_file
                    WHERE tqz01 = g_tsa_h.tsa01 
                      AND tqz02 = g_tsa_b_t.tsa03 
                      AND tqz03 = ima_file.ima01
                   IF g_tsa_b[l_ac].tqz03[1,4]='MISC' THEN
                      SELECT tqz031,tqz08 INTO l_tqz031,l_tqz08
                        FROM tqz_file
                       WHERE tqz01=g_tsa_h.tsa01
                         AND tqz02=g_tsa_b_t.tsa03
                      LET g_tsa_b[l_ac].ima02 = l_tqz031
                    # LET g_tsa_b[l_ac].ima31 = l_tqz08
                   END IF
               END IF
               CALL cl_show_fld_cont()                    #FUN-590083
            END IF
            NEXT FIELD tsa04
 
        AFTER FIELD tsa04   # 目標數量
            IF NOT cl_null(g_tsa_b[l_ac].tsa04) THEN 
               IF g_tsa_b[l_ac].tsa04 < 0 THEN 
                  NEXT FIELD tsa04
               END IF
            END IF
            SELECT tqx14,tqx16 
              INTO l_tqx14,l_tqx16
              FROM tqx_file
	     WHERE tqx01 = g_tqx01
             IF l_tqx16='N' THEN 
                IF cl_null(g_tsa_b[l_ac].tsa05) OR
                   g_tsa_b[l_ac].tsa05=0 THEN
                   CALL t233_1_tsa05(g_tqx01,
                                      g_tsa_b[l_ac].tqz03,NULL,
                                      g_tsa_b[l_ac].tsa03,
                                      g_tsa_b[l_ac].tsa04)
                       RETURNING g_tsa_b[l_ac].tsa05
                  DISPLAY BY NAME g_tsa_b[l_ac].tsa05
                  LET g_tsa_b[l_ac].tsa08=g_tsa_b[l_ac].tsa05*(1+l_tqx14/100) #TQC-650031
                  DISPLAY BY NAME g_tsa_b[l_ac].tsa08
                END IF
             ELSE
                IF cl_null(g_tsa_b[l_ac].tsa08) OR
                   g_tsa_b[l_ac].tsa08=0 THEN
                   CALL t233_1_tsa08(g_tqx01,
                                       g_tsa_b[l_ac].tqz03,NULL,
                                       g_tsa_b[l_ac].tsa03,
                                       g_tsa_b[l_ac].tsa04)
                        RETURNING g_tsa_b[l_ac].tsa08
                   DISPLAY BY NAME g_tsa_b[l_ac].tsa08
                   LET g_tsa_b[l_ac].tsa05=
                         g_tsa_b[l_ac].tsa08/(1+l_tqx14/100)
                   DISPLAY BY NAME g_tsa_b[l_ac].tsa05
                END IF
             END IF
            
        AFTER FIELD tsa05   # 目標金額
            IF NOT cl_null(g_tsa_b[l_ac].tsa05) THEN 
               IF g_tsa_b[l_ac].tsa05 < 0 THEN 
                  NEXT FIELD tsa05
               END IF
            END IF
 
        AFTER FIELD tsa08   # 目標金額
            IF NOT cl_null(g_tsa_b[l_ac].tsa08) THEN 
               IF g_tsa_b[l_ac].tsa08 < 0 THEN 
                  NEXT FIELD tsa08
               END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tsa_b[l_ac].* = g_tsa_b_t.*
               CLOSE t233_1_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tsa_b[l_ac].tsa03,-263,1)
               LET g_tsa_b[l_ac].* = g_tsa_b_t.*
            ELSE
              UPDATE tsa_file
                 SET tsa04 = g_tsa_b[l_ac].tsa04,
                     tsa05 = g_tsa_b[l_ac].tsa05, 
                     tsa08 = g_tsa_b[l_ac].tsa08 
               WHERE tsa01 = g_tsa_h.tsa01
                 AND tsa02 = g_tsa_h.tsa02
                 AND tsa03 = g_tsa_b[l_ac].tsa03
              IF SQLCA.sqlcode THEN
              #  CALL cl_err(g_tsa_b[l_ac].tsa03,SQLCA.sqlcode,0)     #No.FUN-660104
                 CALL cl_err3("upd","tsa_file",g_tsa_b[l_ac].tsa03,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 LET g_tsa_b[l_ac].* = g_tsa_b_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CALL t233_1_sum()
                 COMMIT WORK
              END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tsa_b[l_ac].* = g_tsa_b_t.*
               CLOSE t233_1_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t233_1_bcl
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
 
        ON ACTION about         #BUG-4C0121
           CALL cl_about()      #BUG-4C0121
 
        ON ACTION help          #BUG-4C0121
           CALL cl_show_help()  #BUG-4C0121
 
#No.FUN-6B0031--Begin                                                           
        ON ACTION CONTROLS                                                      
           CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
        END INPUT
 
      LET l_sql =  "SELECT tsa03",
                   "  FROM tsa_file",
                   " WHERE tsa01 ='",g_tsa_h.tsa01,"'"
      PREPARE t233_1_pb1 FROM l_sql
      DECLARE tsa_cs1 CURSOR FOR t233_1_pb1
      FOREACH tsa_cs1 INTO l_tsa03
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         ELSE
            SELECT SUM(tsa04),SUM(tsa05),SUM(tsa08)
              INTO l_sum1,l_sum2,l_sum3
              FROM tsa_file
             WHERE tsa01=g_tsa_h.tsa01
               AND tsa03=l_tsa03
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,0)  
               EXIT FOREACH
            ELSE
               IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
               IF cl_null(l_sum2) THEN LET l_sum2=0 END IF
               IF cl_null(l_sum3) THEN LET l_sum3=0 END IF
               UPDATE tqz_file SET tqz19=l_sum1,tqz20=l_sum2,
                                      tqz21=l_sum3
                WHERE tqz01=g_tsa_h.tsa01
                  AND tqz02=l_tsa03
               IF SQLCA.sqlcode THEN
               #  CALL cl_err('update',SQLCA.sqlcode,0)     #No.FUN-660104
                  CALL cl_err3("upd","tqz_file",g_tsa_h.tsa01,l_tsa03,SQLCA.sqlcode,"","update",1)   #No.FUN-660104
               END IF
            END IF
          END IF
      END FOREACH        
 
END FUNCTION
   
#計算每個門店的金額合計
FUNCTION t233_1_sum()
   DEFINE l_tqy10  LIKE tqy_file.tqy10,
          l_tqy11  LIKE tqy_file.tqy11,
          l_tqx18  LIKE tqx_file.tqx18,
          l_tqx19  LIKE tqx_file.tqx19,
          l_tqz19  LIKE tqz_file.tqz19,
          l_tqz20  LIKE tqz_file.tqz20,
          l_tqz21  LIKE tqz_file.tqz21,
          l_n      LIKE type_file.num5           #No.FUN-680120 SMALLINT
 
   SELECT SUM(tsa05),SUM(tsa08) INTO l_tqy10,l_tqy11
     FROM tsa_file
    WHERE tsa01=g_tsa_h.tsa01
      AND tsa02=g_tsa_h.tsa02
   IF SQLCA.SQLCODE THEN
      LET l_tqy10=NULL
      LET l_tqy11=NULL
   END IF
   UPDATE tqy_file SET tqy10=l_tqy10,tqy11=l_tqy11
    WHERE tqy01=g_tsa_h.tsa01
      AND tqy02=g_tsa_h.tsa02
   LET g_tsa_h.tqy10=l_tqy10
   LET g_tsa_h.tqy11=l_tqy11
   DISPLAY BY NAME g_tsa_h.tqy10,g_tsa_h.tqy11
 
   SELECT SUM(tsa05),SUM(tsa08) INTO l_tqx18,l_tqx19
     FROM tsa_file
    WHERE tsa01=g_tsa_h.tsa01
   IF SQLCA.SQLCODE THEN
      LET l_tqx18=NULL
      LET l_tqx19=NULL
   END IF
   UPDATE tqx_file SET tqx18=l_tqx18,tqx19=l_tqx19
    WHERE tqx01=g_tsa_h.tsa01
 
   DECLARE t233_tsa03_cs CURSOR FOR
    SELECT tsa03 FROM tsa_file 
     WHERE tsa01=g_tsa_h.tsa01
       AND tsa02=g_tsa_h.tsa02
   FOREACH t233_tsa03_cs INTO l_n
      SELECT SUM(tsa04),SUM(tsa05),SUM(tsa08) 
        INTO l_tqz19,l_tqz20,l_tqz21
        FROM tsa_file
       WHERE tsa01=g_tsa_h.tsa01
         AND tsa03=l_n
      IF SQLCA.SQLCODE THEN
         LET l_tqz19=NULL
         LET l_tqz20=NULL
         LET l_tqz21=NULL
      END IF
      UPDATE tqz_file SET tqz19=l_tqz19,tqz20=l_tqz20,tqz21=l_tqz21
       WHERE tqz01=g_tsa_h.tsa01
         AND tqz02=l_n
   END FOREACH
END FUNCTION
 
# 計算缺省目標金額(no tax)
FUNCTION t233_1_tsa05(l_tqx01,l_tqz03,p_tqz09,l_tsa03,l_tsa04)
   DEFINE l_tqz03   LIKE tqz_file.tqz03,
          l_tqz09   LIKE tqz_file.tqz09,
          p_tqz09   LIKE tqz_file.tqz09,
          l_tsa03   LIKE tsa_file.tsa03,
          l_tsa04   LIKE tsa_file.tsa04,
          l_tsa05   LIKE tsa_file.tsa05,
          l_tqx01   LIKE tqx_file.tqx01,
          l_ima25       LIKE ima_file.ima25,
          l_check       LIKE type_file.chr1,    #No.FUN-680120 VARCHAR(1)
          l_factor      LIKE type_file.num20_6  #No.FUN-680120 DECIMAL(20,6)
   DEFINE l_tqz08   LIKE tqz_file.tqz08  #laichuang 050926        
          
 
   IF cl_null(l_tqx01) THEN RETURN END IF
   IF cl_null(l_tqz03) THEN RETURN END IF
   IF cl_null(l_tsa03) THEN RETURN END IF
   IF cl_null(l_tsa04) THEN RETURN END IF
 
   # 計算稅率
#  CALL t233_1_tqx08('a',l_tqx01)
 
   SELECT tqz09,tqz08,ima25
     INTO l_tqz09,l_tqz08,l_ima25
     FROM tqz_file,tqx_file,OUTER ima_file
    WHERE tqz03 = l_tqz03
      AND tqz02 = l_tsa03
      AND tqz01 = l_tqx01
      AND tqz01 = tqx01
      AND tqz03 = ima_file.ima01
      AND tqx07 = '1'  
 
   # 若atmt100程序因促銷價格變動，則傳入修正后的價格時，判斷此地方
   IF NOT cl_null(p_tqz09) AND p_tqz09 != l_tqz09 THEN 
      LET l_tqz09 = p_tqz09
   END IF
 
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'atm-125'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN 0 END IF
  # CALL s_umfchk(l_tqz03,l_ima31,l_tqz08)
  #     RETURNING l_check,l_factor
  #IF l_check = '1' THEN 
  #   CALL cl_err(l_tqz03,'mfg2721',0)
  #   RETURN 0
  #END IF
    LET l_tsa05 =  l_tqz09*l_tsa04
   RETURN l_tsa05
END FUNCTION
   
# 計算缺省目標金額(have tax)
FUNCTION t233_1_tsa08(l_tqx01,l_tqz03,p_tqz09,l_tsa03,l_tsa04)
   DEFINE l_tqz03   LIKE tqz_file.tqz03,
          l_tqz09   LIKE tqz_file.tqz09,
          p_tqz09   LIKE tqz_file.tqz09,
          l_tsa03   LIKE tsa_file.tsa03,
          l_tsa04   LIKE tsa_file.tsa04,
          l_tsa08   LIKE tsa_file.tsa08,
          l_tqx01   LIKE tqx_file.tqx01,
          l_tqx07   LIKE tqx_file.tqx07,
      #   l_ima31       LIKE ima_file.ima31,
          l_ima25       LIKE ima_file.ima25,
          l_check       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
          l_factor      LIKE type_file.num20_6           #No.FUN-680120 DECIMAL(20,6)
   DEFINE l_tqz08   LIKE tqz_file.tqz08
 
   IF cl_null(l_tqx01) THEN RETURN END IF
   IF cl_null(l_tqz03) THEN RETURN END IF
   IF cl_null(l_tsa03) THEN RETURN END IF
   IF cl_null(l_tsa04) THEN RETURN END IF
 
   # 計算稅率
#  CALL t233_1_tqx08('a',l_tqx01)
 
   SELECT tqz09,tqz08,ima25,tqx07
     INTO l_tqz09,l_tqz08,l_ima25,l_tqx07
     FROM tqz_file,tqx_file,OUTER ima_file
    WHERE tqz03 = l_tqz03
      AND tqz02 = l_tsa03
      AND tqz01 = l_tqx01
      AND tqz01 = tqx01
      AND tqz03 = ima01
      AND tqx07 = '1'  
 
   # 若atmt100程序因促銷價格變動，則傳入修正后的價格時，判斷此地方
   IF NOT cl_null(p_tqz09) AND p_tqz09 != l_tqz09 THEN 
      LET l_tqz09 = p_tqz09
   END IF
 
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'atm-125'
        WHEN l_tqx07   = '7' LET g_errno = '9028' # 此資料已無效
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
#   IF NOT cl_null(g_errno) THEN RETURN 0 END IF
#    CALL s_umfchk(l_tqz03,l_ima31,l_tqz08)
#        RETURNING l_check,l_factor
#   IF l_check = '1' THEN 
#      CALL cl_err(l_tqz03,'mfg2721',0)
#      RETURN 0
#   END IF
   LET l_tsa08 =  l_tqz09*l_tsa04
   RETURN l_tsa08
END FUNCTION
 
# 計算稅率 
{FUNCTION t233_1_tqx08(l_tqx01)
   DEFINE l_gec02      LIKE gec_file.gec02
   DEFINE l_gecacti    LIKE gec_file.gecacti
   DEFINE l_tqx01  LIKE tqx_file.tqx01
   DEFINE l_tqx08  LIKE tqx_file.tqx08
 
   IF cl_null(l_tqx01) THEN RETURN END IF
 
   SELECT tqx08 INTO l_tqx08 FROM tqx_file
    WHERE tqx01  = l_tqx01
      AND tqx07 != '7'
 
   SELECT gec02,gec04,gecacti
     INTO l_gec02,g_gec04,l_gecacti FROM gec_file
    WHERE gec01 = l_tqx08
      AND gecacti = 'Y'
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg3044'
        WHEN l_gecacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
 
   # 計算稅率 
   IF cl_null(g_gec04) THEN LET g_gec04 = 0 END IF
 
END FUNCTION }
 
FUNCTION t233_1_b_askkey()
 
    CONSTRUCT l_wc2 ON tsa03,tsa04,tsa05,tsa08   # 螢幕上取單身條件
         FROM s_tsa[1].tsa03,s_tsa[1].tsa04,
              s_tsa[1].tsa05,s_tsa[1].tsa08
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about         #BUG-4C0121
          CALL cl_about()      #BUG-4C0121
 
       ON ACTION help          #BUG-4C0121
          CALL cl_show_help()  #BUG-4C0121
 
       ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
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
    CALL t233_1_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t233_1_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680120 VARCHAR(200)
    l_tqz031        LIKE tqz_file.tqz031,
    l_tqz08         LIKE tqz_file.tqz08 
 
    LET l_sql =
        "SELECT tsa03,tqz03,ima02,tqz08,tsa04,tsa05,tsa08,tqz031 ",
        "  FROM tsa_file,tqz_file,OUTER ima_file   ",
        " WHERE tsa01 ='",g_tsa_h.tsa01,"'", #單頭
        "   AND tsa02 ='",g_tsa_h.tsa02,"'", #單頭
        "   AND tqz01 = tsa01 ",
        "   AND tqz02 = tsa03 ",
        "   AND tqz03 = ima_file.ima01 ",
        "   AND ",p_wc2 CLIPPED,                                         
        " ORDER BY tsa03"
    PREPARE t233_1_pb FROM l_sql
    DECLARE tsa_curs                       #SCROLL CURSOR
        CURSOR FOR t233_1_pb
 
    CALL g_tsa_b.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH tsa_curs INTO g_tsa_b[g_cnt].*,l_tqz031   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_tsa_b[g_cnt].tqz03[1,4] = 'MISC' THEN
           LET g_tsa_b[g_cnt].ima02 = l_tqz031
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_tsa_b.DeleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
# 提案其他資料
FUNCTION t233_1_o()
 
 
   IF cl_null(g_tqx01) THEN RETURN END IF
 
   # 維護提案其他資料
   OPEN WINDOW t233_1_o_w AT 4,24 WITH FORM "atm/42f/atmt233_7"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_locale("atmt233_7")
 
   INITIALIZE l_tqy.* TO NULL
   INITIALIZE l_tqy_t.* TO NULL
 
   SELECT tqy22,tqy23,tqy25,tqy26,
          tqy27,tqy29,tqy30,tqy31,tqy33 
     INTO l_tqy.* 
     FROM tqy_file
    WHERE tqy01 = g_tqx01
      AND tqy02 = g_tsa_h.tsa02
 
   IF cl_null(l_tqy.tqy22) THEN LET l_tqy.tqy22 = 'N' END IF
   IF cl_null(l_tqy.tqy26) THEN LET l_tqy.tqy26 = 'N' END IF
   IF cl_null(l_tqy.tqy30) THEN LET l_tqy.tqy30 = 'N' END IF
   DISPLAY BY NAME l_tqy.*
 
   INPUT BY NAME l_tqy.* WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t233_1_set_entry()
         CALL t233_1_set_no_entry()
         LET g_before_input_done = TRUE
 
      BEFORE FIELD tqy22
         CALL t233_1_set_entry()
 
      AFTER FIELD tqy22
         IF NOT cl_null(l_tqy.tqy22) THEN 
            IF l_tqy.tqy22 = 'N' THEN 
               LET l_tqy.tqy23 = NULL
               LET l_tqy.tqy25 = NULL
            END IF
         END IF
         DISPLAY BY NAME l_tqy.tqy22,
                         l_tqy.tqy23,l_tqy.tqy25
         CALL t233_1_set_no_entry()
 
      AFTER FIELD tqy23
         IF NOT cl_null(l_tqy.tqy23) THEN 
            IF l_tqy.tqy23 < 0 THEN
               CALL cl_err(l_tqy.tqy23,'afa-043',0) 
               NEXT FIELD tqy23
            END IF
         END IF
 
      BEFORE FIELD tqy26
         CALL t233_1_set_entry()
 
      AFTER FIELD tqy26
         IF NOT cl_null(l_tqy.tqy26) THEN 
            IF l_tqy.tqy26 = 'N' THEN 
               LET l_tqy.tqy27 = NULL
               LET l_tqy.tqy29 = NULL
            END IF
         END IF
         DISPLAY BY NAME l_tqy.tqy26,
                         l_tqy.tqy27,l_tqy.tqy29
         CALL t233_1_set_no_entry()
 
      AFTER FIELD tqy27
         IF NOT cl_null(l_tqy.tqy27) THEN 
            IF l_tqy.tqy27 < 0 THEN
               CALL cl_err(l_tqy.tqy27,'afa-043',0) 
               NEXT FIELD tqy27
            END IF
         END IF
 
      BEFORE FIELD tqy30
         CALL t233_1_set_entry()
 
      AFTER FIELD tqy30
         IF NOT cl_null(l_tqy.tqy30) THEN 
            IF l_tqy.tqy30 = 'N' THEN 
               LET l_tqy.tqy31 = NULL
               LET l_tqy.tqy33 = NULL
            END IF
         END IF
         DISPLAY BY NAME l_tqy.tqy30,
                         l_tqy.tqy31,l_tqy.tqy33
         CALL t233_1_set_no_entry()
 
      AFTER FIELD tqy31
         IF NOT cl_null(l_tqy.tqy31) THEN 
            IF l_tqy.tqy31 < 0 THEN
               CALL cl_err(l_tqy.tqy31,'afa-043',0) 
               NEXT FIELD tqy31
            END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
 
   END INPUT
 
   CLOSE WINDOW t233_1_o_w                 #結束畫面
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   UPDATE tqy_file SET tqy22 = l_tqy.tqy22,
                          tqy23 = l_tqy.tqy23,
                          tqy25 = l_tqy.tqy25,
                          tqy26 = l_tqy.tqy26,
                          tqy27 = l_tqy.tqy27,
                          tqy29 = l_tqy.tqy29,
                          tqy30 = l_tqy.tqy30,
                          tqy31 = l_tqy.tqy31,
                          tqy33 = l_tqy.tqy33 
    WHERE tqy01 = g_tqx01
      AND tqy02 = g_tsa_h.tsa02
   IF SQLCA.sqlcode THEN
   #  CALL cl_err('upd tqy_file',SQLCA.sqlcode,0)    #No.FUN-660104
      CALL cl_err3("upd","tqy_file",g_tqx01,g_tsa_h.tsa02,SQLCA.sqlcode,"","upd tqy_file",1)   #No.FUN-660104
      RETURN 
   END IF
END FUNCTION
 
FUNCTION t233_1_set_entry() 
 
    IF INFIELD(tqy22) OR l_tqy.tqy22 = 'Y' THEN
       CALL cl_set_comp_entry("tqy23,tqy25",TRUE)
    END IF 
 
    IF INFIELD(tqy26) OR l_tqy.tqy26 = 'Y' THEN
       CALL cl_set_comp_entry("tqy27,tqy29",TRUE)
    END IF 
 
    IF INFIELD(tqy30) OR l_tqy.tqy30 = 'Y' THEN
       CALL cl_set_comp_entry("tqy31,tqy33",TRUE)
    END IF 
END FUNCTION
 
FUNCTION t233_1_set_no_entry() 
 
    IF INFIELD(tqy22) AND l_tqy.tqy22 = 'N' THEN
       CALL cl_set_comp_entry("tqy23,tqy25",FALSE)
    END IF
 
    IF INFIELD(tqy26) AND l_tqy.tqy26 = 'N' THEN
       CALL cl_set_comp_entry("tqy27,tqy29",FALSE)
    END IF 
 
    IF INFIELD(tqy30) AND l_tqy.tqy30 = 'N' THEN
       CALL cl_set_comp_entry("tqy31,tqy33",FALSE)
    END IF 
END FUNCTION
 
FUNCTION t233_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tsa_b TO s_tsa.*
      ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         CALL cl_show_fld_cont()                    #FUN-590083
 
#No.FUN-6B0031--Begin                                                           
      ON ACTION CONTROLS                                                      
         CALL cl_set_head_visible("","AUTO")                                  
#No.FUN-6B0031--End
 
#No.TQC-6C0217 --start-- mark
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#No.TQC-6C0217 --end--
 
      ON ACTION first
         CALL t233_1_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY              #FUN-590083
      ON ACTION previous
         CALL t233_1_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION jump
         CALL t233_1_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION next
         CALL t233_1_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION last
         CALL t233_1_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         ACCEPT DISPLAY              #FUN-590083
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                    #FUN-590083
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
    
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION other_data
         LET g_action_choice="other_data"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
  
      #FUN-590083 ---start---
      AFTER DISPLAY
         CONTINUE DISPLAY
      #FUN-590083 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION t233_1_bp_refresh()
   DISPLAY ARRAY g_tsa_b TO s_tsa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #BUG-4C0121
         CALL cl_about()      #BUG-4C0121
 
      ON ACTION help          #BUG-4C0121
         CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION controlg      #BUG-4C0121
         CALL cl_cmdask()     #BUG-4C0121
   
   END DISPLAY
END FUNCTION
