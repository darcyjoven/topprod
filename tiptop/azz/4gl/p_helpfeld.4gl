# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_helpfeld.4gl
# Descriptions...: 求助文件欄位說明維護作業
# Date & Author..: 04/04/09 alex
# Modify.........: No.FUN-530024 05/03/17 By alex 修改傳值方式
# Modify.........: No.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.MOD-590329 05/10/04 By Yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.TQC-590032 05/10/17 By alex 加上可辨別客製及名稱欄位
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: NO.FUN-680135 06/09/18 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng  "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.FUN-750068 07/06/25 By saki 行業別功能
# Modify.........: No.FUN-7B0081 08/01/10 By alex gae06移入gbs07
# Modify.........: No.MOD-810259 08/01/14 By alex 行業別選項串接參數增加
# Modify.........: No.FUN-830072 08/12/11 By rainy 修改勾選規則
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gae01          LIKE gae_file.gae01,   # 類別代號 (假單頭)
         g_gae01_t        LIKE gae_file.gae01,   # 類別代號 (假單頭)
         g_gaz03          LIKE gaz_file.gaz03,   #TQC-590032
         g_gae11          LIKE gae_file.gae11,   #TQC-590032
         g_gae11_t        LIKE gae_file.gae11,   #TQC-590032
         g_gae12          LIKE gae_file.gae12,   #No.FUN-750068
         g_gae12_t        LIKE gae_file.gae12,   #No.FUN-750068
         g_gae_lock RECORD LIKE gae_file.*,      # FOR LOCK CURSOR TOUCH
         g_gae    DYNAMIC ARRAY of RECORD        # 程式變數
            gae02          LIKE gae_file.gae02,
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gbs07          LIKE gbs_file.gbs07,  #FUN-7B0081 gae_file.gae06,
            gae07          LIKE gae_file.gae07,
            gae08          LIKE gae_file.gae08,
            gae09          LIKE gae_file.gae09,
            gaq03          LIKE gaq_file.gaq03,
            gaq04          LIKE gaq_file.gaq04,
            gaq05          LIKE gaq_file.gaq05
                      END RECORD,
         g_gae_t           RECORD                 # 變數舊值
            gae02          LIKE gae_file.gae02,
            gae03          LIKE gae_file.gae03,
            gae04          LIKE gae_file.gae04,
            gbs07          LIKE gbs_file.gbs07,  #FUN-7B0081 gae_file.gae06,
            gae07          LIKE gae_file.gae07,
            gae08          LIKE gae_file.gae08,
            gae09          LIKE gae_file.gae09,
            gaq03          LIKE gaq_file.gaq03,
            gaq04          LIKE gaq_file.gaq04,
            gaq05          LIKE gaq_file.gaq05
                      END RECORD,
         g_cnt2                LIKE type_file.num5,   #No.FUN-680135 SMALLINT
         g_wc                  string,                #No.FUN-580092 HCN
         g_sql                 string,                #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01) # 決定後續步驟
         g_rec_b               LIKE type_file.num5,   #No.FUN-680135 SMALLINT # 單身筆數
         l_ac                  LIKE type_file.num5    #No.FUN-680135 SMALLINT # 目前處理的ARRAY CNT
DEFINE   g_cnt                 LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE gae_file.gae01    #MOD-810259
DEFINE   g_argv2               LIKE gae_file.gae11    #MOD-810259
DEFINE   g_argv3               LIKE gae_file.gae12    #MOD-810259
DEFINE   g_curs_index          LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_no_ask              LIKE type_file.num5    #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_db_type             LIKE type_file.chr3    #No.FUN-750068
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = UPSHIFT(ARG_VAL(2))    #MOD-810259
   LET g_argv3 = DOWNSHIFT(ARG_VAL(3))  #MOD-810259
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_gae01_t = NULL
   LET g_gae11_t = NULL            #TQC-590032
   LET g_gae12_t = NULL            #No.FUN-750068
 
   OPEN WINDOW p_helpfeld_w WITH FORM "azz/42f/p_helpfeld"
   ATTRIBUTE(STYLE=g_win_style)
    
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gae03")
 
   # No.FUN-750068 行業別選項
   CALL cl_set_combo_industry("gae12")
   LET g_db_type=cl_db_get_database_type()
 
   LET g_forupd_sql = "SELECT * from gae_file  WHERE gae01 = ? AND gae12 = ?",   #No.FUN-750068
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_helpfeld_lock_u CURSOR FROM g_forupd_sql
 
   # 2004/04/05
   IF NOT cl_null(g_argv1) THEN
       CALL p_helpfeld_q()
   END IF
 
   CALL p_helpfeld_menu() 
 
   CLOSE WINDOW p_helpfeld_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_helpfeld_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_gae.clear()
 
   # 2004/04/28 新增傳值修改
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " gae01 = '",g_argv1 CLIPPED,"' "
      IF NOT cl_null(g_argv2) THEN             #MOD-810259
         LET g_wc = g_wc," AND gae11 = '",g_argv2 CLIPPED,"' "
         IF NOT cl_null(g_argv3) THEN
            LET g_wc = g_wc," AND gae12 = '",g_argv3 CLIPPED,"' "
         END IF
      END IF
   ELSE
      CALL cl_set_head_visible("","YES")                     #FUN-6A0092
      CONSTRUCT g_wc ON gae01,gae12,gae02,gae03,             #FUN-7B0081
                        gae07,gae08,gae09,gaq03,gaq04,gaq05  #FUN-750068
                   FROM gae01,gae12,    s_gae[1].gae02, s_gae[1].gae03,                    #No.FUN-750068
                        s_gae[1].gae07, s_gae[1].gae08, s_gae[1].gae09,
                        s_gae[1].gaq03, s_gae[1].gaq04, s_gae[1].gaq05
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(gae01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gae01
                  NEXT FIELD gae01
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   IF g_wc.getIndexOf("gbs07",1) THEN   #FUN-7B0081
      IF g_db_type = "ORA" THEN
         LET g_sql="SELECT UNIQUE gae01,gae11,gae12 FROM gae_file,gbs_file ",
                   " WHERE ",g_wc CLIPPED,
                     " AND gbs01=gae01 AND gbs02=gae02 AND gbs03=gae03 ",
                     " AND gbs04=gae11 AND gbs05=gae12 ",
                   " ORDER BY DECODE(gae12,'std','1',gae12)"
      ELSE
         LET g_sql="SELECT UNIQUE gae01,gae11,gae12 FROM gae_file,gbs_file ",
                   " WHERE ", g_wc CLIPPED,
                     " AND gbs01=gae01 AND gbs02=gae02 AND gbs03=gae03 ",
                     " AND gbs04=gae11 AND gbs05=gae12 ",
                   " ORDER BY gae01,gae11,gae12 "
      END IF
   ELSE
      IF g_db_type = "ORA" THEN
         LET g_sql="SELECT UNIQUE gae01,gae11,gae12 FROM gae_file ",
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY DECODE(gae12,'std','1',gae12)"
      ELSE
         LET g_sql= "SELECT UNIQUE gae01,gae11,gae12 FROM gae_file ",   #TQC-590032
                    " WHERE ", g_wc CLIPPED,
                    " ORDER BY gae01,gae11,gae12 "
      END IF
   END IF
   #No.FUN-750068 ---end---
   PREPARE p_helpfeld_prepare FROM g_sql          # 預備一下
   DECLARE p_helpfeld_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_helpfeld_prepare
 
   #No.FUN-750068 ---mark--
#  LET g_sql = "SELECT COUNT(DISTINCT gae01,gae12) FROM gae_file ",
#              " WHERE ",g_wc CLIPPED
 
#  PREPARE p_helpfeld_precount FROM g_sql
#  DECLARE p_helpfeld_count CURSOR FOR p_helpfeld_precount
   #No.FUN-750068 ---end---
END FUNCTION
 
#No.FUN-750068 --start--
FUNCTION p_helpfeld_count()
   DEFINE lr_gae   RECORD
            gae01  LIKE gae_file.gae01,
            gae11  LIKE gae_file.gae11,
            gae12  LIKE gae_file.gae12
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10
 
   LET g_sql= "SELECT UNIQUE gae01,gae11,gae12 FROM gae_file ",
              " WHERE ", g_wc CLIPPED,
              " GROUP BY gae01,gae11,gae12 ORDER BY gae01"
 
   PREPARE p_helpfeld_precount FROM g_sql
   DECLARE p_helpfeld_count CURSOR FOR p_helpfeld_precount
   LET li_cnt=0
   FOREACH p_helpfeld_count INTO lr_gae.*
       LET li_cnt = li_cnt + 1
   END FOREACH
   LET g_row_count=li_cnt
 
END FUNCTION
#No.FUN-750068 ---end---
 
FUNCTION p_helpfeld_menu()
 
   WHILE TRUE
      CALL p_helpfeld_bp("G")
 
      CASE g_action_choice
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_helpfeld_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_helpfeld_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_helpfeld_q()                            #Query 查詢
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   CALL g_gae.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_helpfeld_curs()                        #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_helpfeld_b_curs                        #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gae01 TO NULL
      INITIALIZE g_gae11 TO NULL                 #TQC-590032
      INITIALIZE g_gae12 TO NULL                 #No.FUN-750068
   ELSE
      CALL p_helpfeld_fetch('F')                 #讀出TEMP第一筆並顯示
      #No.FUN-750068 --start--
#     OPEN p_helpfeld_count
#     FETCH p_helpfeld_count INTO g_row_count
      CALL p_helpfeld_count()
      #No.FUN-750068 ---end---
      DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
FUNCTION p_helpfeld_fetch(p_flag)            #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1) #處理方式
            l_abso   LIKE type_file.num10    #No.FUN-680135 INTEGER #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_helpfeld_b_curs INTO g_gae01,g_gae11,g_gae12  #TQC-590032  #No.FUN-750068
      WHEN 'P' FETCH PREVIOUS p_helpfeld_b_curs INTO g_gae01,g_gae11,g_gae12  #No.FUN-750068
      WHEN 'F' FETCH FIRST    p_helpfeld_b_curs INTO g_gae01,g_gae11,g_gae12  #No.FUN-750068
      WHEN 'L' FETCH LAST     p_helpfeld_b_curs INTO g_gae01,g_gae11,g_gae12  #No.FUN-750068
      WHEN '/' 
         IF (NOT g_no_ask) THEN         #No.FUN-6A0080
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
         FETCH ABSOLUTE g_jump p_helpfeld_b_curs INTO g_gae01,g_gae11,g_gae12  #TQC-590032  #No.FUN-750068
         LET g_no_ask = FALSE          #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gae01,SQLCA.sqlcode,0)
      INITIALIZE g_gae01 TO NULL  #TQC-6B0105
      INITIALIZE g_gae11 TO NULL  #TQC-6B0105
      INITIALIZE g_gae12 TO NULL  #No.FUN-750068
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   END IF
   CALL p_helpfeld_show()
END FUNCTION
 
 
FUNCTION p_helpfeld_show()                         # 將資料顯示在畫面上
   CALL p_helpfeld_gaz03()                         #TQC-590032
   DISPLAY g_gae01,g_gae11,g_gae12,g_gaz03 TO gae01,gae11,gae12,gaz03    #No.FUN-750068
   CALL p_helpfeld_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                         #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION p_helpfeld_b()                             # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,    #No.FUN-680135 SMALLINT # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,    #No.FUN-680135 SMALLINT # 檢查重複用
            l_gau01         LIKE type_file.num5,    #No.FUN-680135 SMALLINT # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01) # 單身鎖住否
            p_cmd           LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01) # 處理狀態
            l_allow_insert  LIKE type_file.num5,    #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5     #No.FUN-680135 SMALLINT
   DEFINE   li_i            LIKE type_file.num5     #FUN-7B0081
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gae01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   # 2004/04/09 本程式只 Modify 不可 Insert OR Delete
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
 
   LET g_forupd_sql= "SELECT gae02,gae03,gae04,'',gae07,gae08,gae09,'','','' ",
                     "  FROM gae_file ",           #FUN-7B0081
                     "  WHERE gae01 = ? AND gae11 = ? AND gae12 = ?",    #TQC-590032  #No.FUN-750068
                       " AND gae02 = ? AND gae03 = ? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_helpfeld_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_gae WITHOUT DEFAULTS FROM s_gae.*
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
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gae_t.* = g_gae[l_ac].*    #BACKUP
#-------- NO.MOD-590329 MARK-----------------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_helpfeld_set_entry_b(p_cmd)
#           CALL p_helpfeld_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#-------- NO.MOD-590329 MARK-----------------------
            OPEN p_helpfeld_bcl USING g_gae01,g_gae11,g_gae12,g_gae_t.gae02,g_gae_t.gae03  #No.FUN-750068
            IF SQLCA.sqlcode THEN   #TQC-590032
               CALL cl_err("OPEN p_helpfeld_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_helpfeld_bcl INTO g_gae[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_helpfeld_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               SELECT gaq03,gaq04,gaq05
                 INTO g_gae[l_ac].gaq03,g_gae[l_ac].gaq04,g_gae[l_ac].gaq05
                 FROM gaq_file
                WHERE gaq01 = g_gae[l_ac].gae02
                  AND gaq02 = g_gae[l_ac].gae03
                                                    #FUN-7B0081
               SELECT gbs07 INTO g_gae[l_ac].gbs07 FROM gbs_file
                WHERE gbs01 = g_gae01 AND gbs02 = g_gae[l_ac].gae02
                                      AND gbs03 = g_gae[l_ac].gae03
                  AND gbs04 = g_gae11 AND gbs05 = g_gae12
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gae[l_ac].* TO NULL       #900423
         LET g_gae_t.* = g_gae[l_ac].*          #新輸入資料
#-------NO.MOD-590329 MARK-------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_helpfeld_set_entry_b(p_cmd)
#           CALL p_helpfeld_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
         NEXT FIELD gae02
#-------NO.MOD-590329 MARK-------------
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gae[l_ac].* = g_gae_t.*
            CLOSE p_helpfeld_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gae[l_ac].gae03,-263,1)
            LET g_gae[l_ac].* = g_gae_t.*
         ELSE
            UPDATE gae_file
               SET gae07 = g_gae[l_ac].gae07,    #FUN-7B0081
                   gae08 = g_gae[l_ac].gae08,
                   gae09 = g_gae[l_ac].gae09
             WHERE gae01 = g_gae01
               AND gae11 = g_gae11         #TQC-590032
               AND gae12 = g_gae12         #No.FUN-750068
               AND gae02 = g_gae_t.gae02
               AND gae03 = g_gae_t.gae03
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gae[l_ac].gae02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gae_file",g_gae01,g_gae_t.gae02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gae[l_ac].* = g_gae_t.*
            ELSE               #FUN-7B0081
               IF NOT cl_null(g_gae[l_ac].gbs07) THEN
                  SELECT COUNT(*) INTO li_i FROM gbs_file
                   WHERE gbs01 = g_gae01
                     AND gbs02 = g_gae_t.gae02 AND gbs03 = g_gae_t.gae03
                     AND gbs04 = g_gae11       AND gbs05 = g_gae12
                  IF li_i > 0 THEN
                     UPDATE gbs_file SET gbs07 = g_gae[l_ac].gbs07
                      WHERE gbs01 = g_gae01
                        AND gbs02 = g_gae_t.gae02 AND gbs03 = g_gae_t.gae03
                        AND gbs04 = g_gae11       AND gbs05 = g_gae12
                  ELSE
                     INSERT INTO gbs_file(gbs01,gbs02,gbs03,gbs04,gbs05,gbs07)
                            VALUES(g_gae01,g_gae_t.gae02,g_gae_t.gae03,
                                   g_gae11,g_gae12,g_gae[l_ac].gbs07)
                  END IF
               ELSE
                  DELETE FROM gbs_file
                   WHERE gbs01 = g_gae01
                     AND gbs02 = g_gae_t.gae02 AND gbs03 = g_gae_t.gae03
                     AND gbs04 = g_gae11       AND gbs05 = g_gae12
               END IF
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gae[l_ac].* = g_gae_t.*
            END IF
            CLOSE p_helpfeld_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p_helpfeld_bcl
         COMMIT WORK
 
      BEFORE FIELD gbs07   #FUN-7B0081
         CALL s_textedit(g_gae[l_ac].gbs07) RETURNING g_gae[l_ac].gbs07
         DISPLAY g_gae[l_ac].gbs07 TO gbs07
 
     #FUN-830072 begin
      AFTER FIELD gae07
        IF g_gae[l_ac].gae03 ='0' AND g_gae[l_ac].gae07 = 'Y' THEN
          IF cl_null(g_gae[l_ac].gbs07) THEN
             CALL cl_err('','azz-803',1)
             LET g_gae[l_ac].gae07 = 'N'
          END IF
        END IF
        IF g_gae[l_ac].gae07 = 'N' THEN
           LET g_gae[l_ac].gae08 = 'N'
        END IF
        IF g_gae[l_ac].gae03 = '0' THEN
           CALL p_helpfeld_gae07()  
        ELSE
           IF NOT p_helpfeld_chk_gae07() THEN
             CALL cl_err('','azz-807',1)
             LET g_gae[l_ac].gae07 = g_gae_t.gae07
             NEXT FIELD CURRENT
           END IF
        END IF
 
      AFTER FIELD gae08
        IF g_gae[l_ac].gae08 = 'Y' THEN
           IF g_gae[l_ac].gae07 = 'N' THEN
              CALL cl_err('','azz-804',1)
              LET g_gae[l_ac].gae08 = 'N'
           END IF
        END IF
 
        IF g_gae[l_ac].gae03 = '0' THEN
           CALL p_helpfeld_gae07()  
        ELSE
           IF NOT p_helpfeld_chk_gae08() THEN
             CALL cl_err('','azz-807',1)
             LET g_gae[l_ac].gae08 = g_gae_t.gae08
             NEXT FIELD CURRENT
           END IF
        END IF
     #FUN-830072 end
 
      ON ACTION update_gae06
         CALL p_helpfeld_update_gbs07()
 
      ON ACTION open_sample_doc
         IF cl_null(g_gae[l_ac].gae09) THEN
            CALL cl_err(g_gae[l_ac].gae02,"azz-055", 1)
         ELSE
            CALL p_helpfeld_sample_doc(g_gae[l_ac].gae09)
         END IF
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gae02) AND l_ac > 1 THEN
            LET g_gae[l_ac].* = g_gae[l_ac-1].*
            NEXT FIELD gae02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END INPUT
 
   CALL p_helpfeld_upd()  #FUN-830072
   CLOSE p_helpfeld_bcl
   COMMIT WORK
   CALL p_helpfeld_b_fill(g_wc) #FUN-830072
END FUNCTION
 
#FUN-830072 begin
FUNCTION p_helpfeld_gae07()
  DEFINE  l_i   SMALLINT
  
  FOR l_i = 1 TO g_rec_b
    IF l_i <> l_ac THEN
      IF g_gae[l_i].gae02 = g_gae[l_ac].gae02  THEN
         LET g_gae[l_i].gae07 = g_gae[l_ac].gae07
         LET g_gae[l_i].gae08 = g_gae[l_ac].gae08
         DISPLAY BY NAME g_gae[l_i].gae07,g_gae[l_i].gae08
      END IF
    END IF
  END FOR
END FUNCTION
 
FUNCTION p_helpfeld_chk_gae07()
  DEFINE l_gae07  LIKE gae_file.gae07
 
  SELECT gae07 INTO l_gae07 FROM gae_file
   WHERE gae01 = g_gae01
     AND gae02 = g_gae[l_ac].gae02
     AND gae03 = '0'
 
  IF l_gae07 <> g_gae[l_ac].gae07 THEN
     RETURN FALSE
  END IF
 
  RETURN TRUE
END FUNCTION
 
FUNCTION p_helpfeld_chk_gae08()
  DEFINE l_gae08  LIKE gae_file.gae08
 
  SELECT gae08 INTO l_gae08 FROM gae_file
   WHERE gae01 = g_gae01
     AND gae02 = g_gae[l_ac].gae02
     AND gae03 = '0'
 
  IF l_gae08 <> g_gae[l_ac].gae08 THEN
     RETURN FALSE
  END IF
 
  RETURN TRUE
END FUNCTION
 
FUNCTION p_helpfeld_upd()
  DEFINE l_sql    STRING,
         l_gae02 LIKE gae_file.gae02,
         l_gae07 LIKE gae_file.gae07,
         l_gae08 LIKE gae_file.gae08,
         l_gae11 LIKE gae_file.gae11,
         l_gae12 LIKE gae_file.gae12,
         l_gay   DYNAMIC  ARRAY OF RECORD 
                  gay01  LIKE gay_file.gay01
         END RECORD
  DEFINE l_cnt,i   SMALLINT 
  DEFINE l_tot     SMALLINT 
 
   #判斷如語言別有漏掉的補資料
    LET l_cnt = 1
    LET l_sql = "SELECT DISTINCT gay01 FROM gay_file ",
                " WHERE gay01 <>'0'",
                " ORDER BY gay01 "
    PREPARE gay_pre FROM l_sql
    DECLARE gay_curs CURSOR WITH HOLD FOR gay_pre 
    FOREACH gay_curs INTO l_gay[l_cnt].gay01
      LET l_gay[l_cnt].gay01 = l_gay[l_cnt].gay01 CLIPPED
      LET l_cnt = l_cnt + 1
    END FOREACH
    LET l_tot = l_cnt - 1
 
    LET l_sql = " SELECT gae02,gae11,gae12,gae07 FROM gae_file ",
                "  WHERE gae01 = '",g_gae01,"'",
                "    AND gae03 = '0'"
    PREPARE gae_p2 FROM l_sql
    DECLARE gae_c2 CURSOR WITH HOLD FOR gae_p2
    FOREACH gae_c2 INTO l_gae02,l_gae11,l_gae12,l_gae07
      FOR i = 1 TO l_tot   #找語言別資料
        #gae_file
        LET l_sql = "SELECT COUNT(*) FROM gae_file ",
                    " WHERE gae01 = '",g_gae01 ,"'",
                    "   AND gae02 = '",l_gae02 ,"'",
                    "   AND gae03 = '",l_gay[i].gay01,"'",
                    "   AND gae11 = '",l_gae11 ,"'",
                    "   ANd gae12 = '",l_gae12 ,"'"
        PREPARE gay_cnt_p FROM l_sql
        EXECUTE gay_cnt_p INTO l_cnt
        IF l_cnt = 0 THEN
           LET l_sql = "INSERT INTO gae_file ",
                       "SELECT gae01,gae02,'",l_gay[i].gay01,"',",
                       "       '','','',gae07,gae08,gae09,gae10,gae11,gae12 ",
                       "  FROM gae_file ",
                       " WHERE gae01 = '",g_gae01 ,"'",
                       "   AND gae02 = '",l_gae02 ,"'",
                       "   AND gae03 = '0'"
           PREPARE gae_ins_p FROM l_sql
           EXECUTE gae_ins_p
        END IF
      END FOR
 
      #gbs_file
      IF l_gae07 = 'Y'  THEN   #有勾確認，在gbs_file中一定要有資料 
         FOR i = 1 TO l_tot   #找語言別資料
           LET l_sql = "SELECT COUNT(*) FROM gbs_file ",
                       " WHERE gbs01 = '",g_gae01 ,"'",
                       "   AND gbs02 = '",l_gae02 ,"'",
                       "   AND gbs03 = '",l_gay[i].gay01,"'",
                       "   AND gbs04 = '",l_gae11 ,"'",
                       "   ANd gbs05 = '",l_gae12 ,"'"
           PREPARE gbs_cnt_p FROM l_sql
           EXECUTE gbs_cnt_p INTO l_cnt
           IF l_cnt = 0 THEN
              LET l_sql = "INSERT INTO gbs_file ",
                          " (gbs01,gbs02,gbs03,gbs04,gbs05,gbs07) ",
                          " VALUES(",
                          "'",g_gae01,"'",
                          ",'",l_gae02,"'",
                          ",'",l_gay[i].gay01,"'",
                          ",'",l_gae11,"'",
                          ",'",l_gae12,"'",
                          ",'')"
              PREPARE gbs_ins_p FROM l_sql
              EXECUTE gbs_ins_p
           END IF
         END FOR
      END IF
    END FOREACH
   
   #各語言別的gae07,gae08,gae09資料要相同
    LET l_sql = " SELECT gae02,gae07,gae08 FROM gae_file ",
                "  WHERE gae01 = '",g_gae01,"'",
                "    AND gae03 = '0'"
    PREPARE gae_p3 FROM l_sql
    DECLARE gae_c3 CURSOR WITH HOLD FOR gae_p3
    FOREACH gae_c3 INTO l_gae02,l_gae07,l_gae08
      IF cl_null(l_gae07) THEN LET l_gae07 = 'N' END IF
      IF cl_null(l_gae08) THEN LET l_gae08 = 'N' END IF
      IF l_gae07 = 'N' THEN LET l_gae08 = 'N' END IF
      
      LET l_sql = "UPDATE gae_file ",
                  "   SET gae07 = '", l_gae07,"'",
                  "      ,gae08 = '", l_gae08,"'",
                  " WHERE gae01 = '", g_gae01 ,"'",
                  "   AND gae02 = '", l_gae02 ,"'",
                  "   AND gae03 <>'0'"
      PREPARE gae_upd_p FROM l_sql
      EXECUTE gae_upd_p 
    END FOREACH
 END FUNCTION
#FUN-830072 end
 
FUNCTION p_helpfeld_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc         STRING                 #TQC-590032
   DEFINE p_ac         LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
    LET g_sql =" SELECT gae02,gae03,gae04,'',gae07,gae08,gae09,gaq03,gaq04,gaq05 ",
                 " FROM gae_file,OUTER gaq_file ",         #FUN-7B0081
                " WHERE gae_file.gae01 = '",g_gae01 CLIPPED,"' ",
                  " AND gae_file.gae11 = '",g_gae11 CLIPPED,"' ",   #TQC-590032
                  " AND gae_file.gae12 = '",g_gae12 CLIPPED,"' ",   #No.FUN-750068
                  " AND gae_file.gae02 = gaq_file.gaq01 ",
                  " AND gae_file.gae03 = gaq_file.gaq02 ",
                  " AND ",p_wc CLIPPED,
                " ORDER BY gae02,gae03"
 
    PREPARE p_helpfeld_prepare2 FROM g_sql           #預備一下
    DECLARE gae_curs CURSOR FOR p_helpfeld_prepare2
 
    CALL g_gae.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gae_curs INTO g_gae[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE    #FUN-7B0081
          SELECT gbs07 INTO g_gae[g_cnt].gbs07 FROM gbs_file
           WHERE gbs01 = g_gae01 AND gbs02 = g_gae[g_cnt].gae02
                                 AND gbs03 = g_gae[g_cnt].gae03
             AND gbs04 = g_gae11 AND gbs05 = g_gae12
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gae.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_helpfeld_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_gae TO s_gae.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
#     ON ACTION update_gae06                       #Marked by #TQC-590032
#        LET g_action_choice="update_gae06"
#        CALL p_helpfeld_update_gbs07()
 
      ON ACTION open_sample_doc
         LET g_action_choice="open_sample_doc"
         IF cl_null(g_gae[l_ac].gae09) THEN
            CALL cl_err(g_gae[l_ac].gae02,"azz-055", 1)
         ELSE
            CALL p_helpfeld_sample_doc(g_gae[l_ac].gae09)
         END IF
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_helpfeld_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous                         # P.上筆
         CALL p_helpfeld_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump                             # 指定筆
         CALL p_helpfeld_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next                             # N.下筆
         CALL p_helpfeld_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last                             # 最終筆
         CALL p_helpfeld_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_set_combo_industry("gae12")        #No.FUN-750068
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gae03")
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_helpfeld_update_gbs07()     #FUN-7B0081
  DEFINE l_gaq05   LIKE gaq_file.gaq05
 
    SELECT gaq05 INTO l_gaq05 FROM gaq_file
     WHERE gaq01 = g_gae[l_ac].gae02
       AND gaq02 = g_gae[l_ac].gae03
    
     IF NOT cl_null(l_gaq05) THEN
        UPDATE gbs_file SET gbs07 = l_gaq05
         WHERE gbs01 = g_gae01
           AND gbs02 = g_gae[l_ac].gae02 AND gbs03 = g_gae[l_ac].gae03
           AND gbs04 = g_gae11           AND gbs05 = g_gae12
       IF SQLCA.sqlcode THEN
       ELSE
           LET g_gae[l_ac].gbs07 = l_gaq05
       END IF
    END IF
END FUNCTION
 
 # MOD-460149
FUNCTION p_helpfeld_sample_doc(ls_filename)
 
   DEFINE   ls_filename     STRING
   DEFINE   ls_help_url     STRING
 
   IF cl_null(ls_filename) THEN RETURN END IF
 
   LET ls_help_url = FGL_GETENV("FGLASIP"), "/tiptop/training/",g_lang CLIPPED,
                     "/sample/", ls_filename.trim(), ".doc"
   DISPLAY ls_help_url
   IF NOT cl_open_url(ls_help_url) THEN
      CALL cl_err(ls_filename.trim(),"azz-056", 1)
   END IF
END FUNCTION
 
FUNCTION p_helpfeld_gaz03()    #TQC-590032
 
   DEFINE l_count  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   LET g_gaz03 = ""
   LET l_count = 0
 
   SELECT count(*) INTO l_count FROM zz_file WHERE zz01=g_gae01
 
   IF l_count > 0 THEN
      SELECT gaz03 INTO g_gaz03 FROM gaz_file
       WHERE gaz01=g_gae01 AND gaz02=g_lang AND gaz05="Y"
      IF cl_null(g_gaz03) THEN
        SELECT gaz03 INTO g_gaz03 FROM gaz_file
         WHERE gaz01=g_gae01 AND gaz02=g_lang AND gaz05="N"
      END IF
   ELSE
      SELECT gae04 INTO g_gaz03 FROM gae_file
       WHERE gae01=g_gae01 AND gae02='wintitle' AND gae03=g_lang AND gae11="Y" AND gae12 = g_gae12   #No.FUN-750068
      IF cl_null(g_gaz03) THEN
        SELECT gae04 INTO g_gaz03 FROM gae_file
         WHERE gae01=g_gae01 AND gae02='wintitle' AND gae03=g_lang AND gae11="N" AND gae12 = g_gae12 #No.FUN-750068
      END IF
   END IF
 
   IF g_gae01='TopMenuGroup' THEN
      LET g_gaz03='Common Items For TOP Menu'
   END IF
 
   IF g_gae01='TopProgGroup' THEN
      LET g_gaz03='Program Items For TOP Menu'
   END IF
 
END FUNCTION
 
 
#----NO.MOD-590329 MARK----------------------
 #No.MOD-580056 --start
#FUNCTION p_helpfeld_set_entry_b(p_cmd)
#  DEFINE p_cmd   VARCHAR(01)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gae02,gae03",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_helpfeld_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   VARCHAR(01)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gae02,gae03",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580056 --end
#-----NO.MOD-590329 MARK----------------------
