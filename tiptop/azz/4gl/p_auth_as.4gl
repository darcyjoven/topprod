# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_auth_as.4gl
# Descriptions...: 權限加嚴控管設定作業
# Date & Author..: 04/12/08 alex
# Modify.........: No.MOD-530203 05/03/23 By alex 修正 controlp 開窗找不到資料問題
# Modify.........: No.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.MOD-560051 05/08/23 By alex 修正查不到資料的問題
# Modify.........: NO.MOD-590329 05/10/03 By Yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成g_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740025 07/04/06 By chenl  1.修正點擊更改后再點擊新增或復制報錯的bug。
#                                                   2.修正復制過程中無法中斷的bug。
# Modify.........: No.TQC-740075 07/04/13 By Xufeng "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.MOD-880239 08/08/28 By Sarah 進入單身會將Action名稱欄位清空,單身輸入完Action代碼後沒帶出Action名稱
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D10130 13/01/30 By qiaozy 單獨運行程式p_auth_as，查詢不出多筆資料
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gbl01          LIKE gbl_file.gbl01,   # 類別代號 (假單頭)
         g_gbl01_t        LIKE gbl_file.gbl01,
         g_gaz03          LIKE gaz_file.gaz03,
         g_gbl_lock RECORD LIKE gbl_file.*,      # FOR LOCK CURSOR TOUCH
         g_gbl    DYNAMIC ARRAY of RECORD        # 程式變數
            gbl02          LIKE gbl_file.gbl02,
            gbd04          LIKE gbd_file.gbd04,
            gbl03          LIKE gbl_file.gbl03
                      END RECORD,
         g_gbl_t           RECORD                 # 變數舊值
            gbl02          LIKE gbl_file.gbl02,
            gbd04          LIKE gbd_file.gbd04,
            gbl03          LIKE gbl_file.gbl03
                      END RECORD,
         g_cnt2                LIKE type_file.num5,   #FUN-680135 SMALLINT
         g_wc                  STRING,
         g_sql                 STRING,
         g_ss                  LIKE type_file.chr1,   #FUN-680135  # 決定後續步驟 VARCHAR(1) 
         g_rec_b               LIKE type_file.num5,   # 單身筆數   #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5    # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10   #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5    #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE gbl_file.gbl01
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5          #No.FUN-680135 SMALLINT #No.FUN-6A0080
 
MAIN
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
        RETURNING g_time    #No.FUN-6A0096
 
   LET g_gbl01_t = NULL
 
   OPEN WINDOW p_auth_as_w WITH FORM "azz/42f/p_auth_as"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * FROM gbl_file  WHERE gbl01=? ",
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_auth_as_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_auth_as_q()
   END IF
 
   CALL p_auth_as_menu() 
 
   CLOSE WINDOW p_auth_as_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION p_auth_as_curs()                        # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_gbl.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "gbl01 = '",g_argv1 CLIPPED,"' "
   ELSE
 
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092 
      CONSTRUCT g_wc ON gbl01,gbl02,gbl03
                   FROM gbl01,s_gbl[1].gbl02,s_gbl[1].gbl03
 
         ON ACTION controlp
            CASE
                WHEN INFIELD(gbl01)    #MOD-530203
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gbl01
                  NEXT FIELD gbl01
 
               OTHERWISE
                  EXIT CASE
            END CASE
 
           ON IDLE g_idle_seconds  #FUN-860033
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION help          #FUN-860033
              CALL cl_show_help()  #FUN-860033
 
           ON ACTION about         #MOD-4C0121
              CALL cl_about()      #MOD-4C0121
      
           ON ACTION controlg      #MOD-4C0121
              CALL cl_cmdask()     #MOD-4C0121
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
   LET g_sql= "SELECT UNIQUE gbl01 FROM gbl_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gbl01"
   PREPARE p_auth_as_prepare FROM g_sql          # 預備一下
   DECLARE p_auth_as_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_auth_as_prepare
 
    LET g_sql= " SELECT count(UNIQUE gbl01) FROM gbl_file ",  #MOD-560051
              " WHERE ", g_wc CLIPPED
    #          " ORDER BY gal01"      #FUN-D10130---MARK----
 
   PREPARE p_auth_as_count_pre FROM g_sql
   DECLARE p_auth_as_count CURSOR FOR p_auth_as_count_pre
 
END FUNCTION
 
 
FUNCTION p_auth_as_menu()
 
   WHILE TRUE
      CALL p_auth_as_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_auth_as_a()
            END IF
 
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               IF g_chkey='Y' THEN      #No.TQC-740025
                  CALL p_auth_as_u()
               END IF                   #No.TQC-740025 
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_auth_as_copy()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_auth_as_r()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_auth_as_q()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_auth_as_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gbl),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_auth_as_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_gbl.clear()
 
   INITIALIZE g_gbl01 LIKE gbl_file.gbl01         # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_auth_as_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gbl01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_gbl.clear()
      ELSE
         CALL p_auth_as_b_fill('1=1')             # 單身
      END IF
 
      CALL p_auth_as_b()                          # 輸入單身
      LET g_gbl01_t=g_gbl01
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_auth_as_i(p_cmd)                  # 處理INPUT
   DEFINE   p_cmd   LIKE type_file.chr1      # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'Y'
   DISPLAY g_gbl01 TO gbl01
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT g_gbl01 WITHOUT DEFAULTS FROM gbl01
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_auth_as_set_entry(p_cmd)
         CALL p_auth_as_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
 
      AFTER FIELD gbl01
        SELECT gaz03 INTO g_gaz03 FROM gaz_file 
         WHERE gaz01=g_gbl01 AND gaz02=g_lang
 
      AFTER INPUT
         IF NOT cl_null(g_gbl01) THEN
            IF g_gbl01 != g_gbl01_t OR cl_null(g_gbl01_t) THEN
               SELECT COUNT(UNIQUE gbl01) INTO g_cnt FROM gbl_file
                WHERE gbl01=g_gbl01 
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_gbl01,-239,0)
                     LET g_gbl01 = g_gbl01_t
                     NEXT FIELD gbl01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_gbl01,g_errno,0)
                  NEXT FIELD gbl01
               END IF
            END IF
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gbl01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.default1= g_gbl01
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_gbl01
               DISPLAY g_gbl01 TO gbl01
               NEXT FIELD gbl01
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
END FUNCTION
 
 
FUNCTION p_auth_as_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gbl01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gbl01_t = g_gbl01
 
   BEGIN WORK
   OPEN p_auth_as_lock_u USING g_gbl01
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE p_auth_as_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH p_auth_as_lock_u INTO g_gbl_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("gbl01 LOCK:",SQLCA.sqlcode,1)
      CLOSE p_auth_as_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL p_auth_as_i("u")
      IF INT_FLAG THEN
         LET g_gbl01 = g_gbl01_t
         DISPLAY g_gbl01 TO gbl01
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE gbl_file SET gbl01 = g_gbl01
       WHERE gbl01 = g_gbl01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_gbl01,SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("upd","gbl_file",g_gbl01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION p_auth_as_q()                            #Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_gbl.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL p_auth_as_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN p_auth_as_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gbl01 TO NULL
   ELSE
      CALL p_auth_as_fetch('F')                 #讀出TEMP第一筆並顯示
      OPEN p_auth_as_count
      FETCH p_auth_as_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
END FUNCTION
 
FUNCTION p_auth_as_fetch(p_flag)              #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,     #處理方式      #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10     #絕對的筆數    #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_auth_as_b_curs INTO g_gbl01
      WHEN 'P' FETCH PREVIOUS p_auth_as_b_curs INTO g_gbl01
      WHEN 'F' FETCH FIRST    p_auth_as_b_curs INTO g_gbl01
      WHEN 'L' FETCH LAST     p_auth_as_b_curs INTO g_gbl01
      WHEN '/' 
         IF (NOT g_no_ask) THEN        #No.FUN-6A0080
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
         FETCH ABSOLUTE g_jump p_auth_as_b_curs INTO g_gbl01
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gbl01,SQLCA.sqlcode,0)
      INITIALIZE g_gbl01 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
      CALL p_auth_as_show()
   END IF
END FUNCTION
 
FUNCTION p_auth_as_show()                         # 將資料顯示在畫面上
   SELECT gaz03 INTO g_gaz03 FROM gaz_file 
    WHERE gaz01=g_gbl01 AND gaz02=g_lang
   DISPLAY g_gbl01,g_gaz03 TO gbl01,gaz03
   CALL p_auth_as_b_fill(g_wc)                    # 單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p_auth_as_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_gbl   RECORD LIKE gbl_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gbl01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gbl_file WHERE gbl01 = g_gbl01 
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","gbl_file",g_gbl01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_gbl.clear()
         OPEN p_auth_as_count
         #FUN-B50065-add-start--
         IF STATUS THEN
            CLOSE p_auth_as_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end-- 
         FETCH p_auth_as_count INTO g_row_count
         #FUN-B50065-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE p_auth_as_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50065-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN p_auth_as_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_auth_as_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE          #No.FUN-6A0080
            CALL p_auth_as_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_auth_as_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_gau01         LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_gbl01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql= "SELECT gbl02,'',gbl03 ",
                      " FROM gbl_file ",
                     "  WHERE gbl01=? AND gbl02=? ",
                       " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_auth_as_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
   LET l_ac_t = 0
 
   INPUT ARRAY g_gbl WITHOUT DEFAULTS FROM s_gbl.*
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
            LET g_gbl_t.* = g_gbl[l_ac].*    #BACKUP
#NO.MOD-590329 MARK--------------
 #No.MOD-580056 --start
#           LET g_before_input_done = FALSE
#           CALL p_auth_as_set_entry_b(p_cmd)
#           CALL p_auth_as_set_no_entry_b(p_cmd)
#           LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK--------------
            OPEN p_auth_as_bcl USING g_gbl01,g_gbl_t.gbl02
            IF SQLCA.sqlcode THEN 
               CALL cl_err("OPEN p_auth_as_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_auth_as_bcl INTO g_gbl[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH p_auth_as_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                 #str MOD-880239 add
                 #SELECT gbd04 INTO g_gbl[l_ac].gbd04 FROM gbl_file
                 # WHERE gbl01=g_gbl01
                 #   AND gbl02=g_gbl[l_ac].gbl02 AND gbl03=g_lang
                  SELECT gbd04 INTO g_gbl[l_ac].gbd04 FROM gbd_file
                   WHERE gbd01=g_gbl[l_ac].gbl02
                     AND gbd02=g_gbl01 AND gbd03=g_lang
                  IF cl_null(g_gbl[l_ac].gbd04) THEN
                     SELECT gbd04 INTO g_gbl[l_ac].gbd04 FROM gbd_file
                      WHERE gbd01=g_gbl[l_ac].gbl02
                        AND gbd02='standard' AND gbd03=g_lang
                  END IF
                  DISPLAY BY NAME g_gbl[l_ac].gbd04
                 #end MOD-880239 add
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gbl[l_ac].* TO NULL       #900423
         LET g_gbl_t.* = g_gbl[l_ac].*          #新輸入資料
#NO.MOD-590329 MARK-----------------------
 #No.MOD-580056 --start
#         LET g_before_input_done = FALSE
#         CALL p_auth_as_set_entry_b(p_cmd)
#         CALL p_auth_as_set_no_entry_b(p_cmd)
#         LET g_before_input_done = TRUE
 #No.MOD-580056 --end
#NO.MOD-590329 MARK-----------------------
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gbl02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gbl_file (gbl01,gbl02,gbl03)
              VALUES (g_gbl01,g_gbl[l_ac].gbl02,g_gbl[l_ac].gbl03)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gbl01,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gbl_file",g_gbl01,g_gbl[l_ac].gbl02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD gbl02
         IF g_gbl[l_ac].gbl02 != g_gbl_t.gbl02 OR g_gbl_t.gbl02 IS NULL THEN
            # 檢視 gbl_file 中同一 Program Name (gbl01) 下是否有相同的
            # Filed Name (gbl02)
            SELECT COUNT(*) INTO l_n FROM gbl_file
             WHERE gbl01 = g_gbl01 
               AND gbl02 = g_gbl[l_ac].gbl02
            IF l_n > 0 THEN
               CALL cl_err(g_gbl[l_ac].gbl02,-239,0)
               LET g_gbl[l_ac].gbl02 = g_gbl_t.gbl02
               NEXT FIELD gbl02
            END IF
         END IF
        #str MOD-880239 add
         LET g_gbl[l_ac].gbd04 = NULL
         SELECT gbd04 INTO g_gbl[l_ac].gbd04 FROM gbd_file
          WHERE gbd01=g_gbl[l_ac].gbl02
            AND gbd02=g_gbl01 AND gbd03=g_lang
         IF cl_null(g_gbl[l_ac].gbd04) THEN
            SELECT gbd04 INTO g_gbl[l_ac].gbd04 FROM gbd_file
             WHERE gbd01=g_gbl[l_ac].gbl02
               AND gbd02='standard' AND gbd03=g_lang
         END IF
         DISPLAY BY NAME g_gbl[l_ac].gbd04
        #end MOD-880239 add
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gbl_t.gbl02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            IF l_gau01 > 0 THEN  #當刪除為主鍵的其中一筆資料時
               CALL cl_err("Deleting One of Several Primary Keys!","!",1)
            END IF
            DELETE FROM gbl_file WHERE gbl01 = g_gbl01
                                   AND gbl02 = g_gbl[l_ac].gbl02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbl_t.gbl02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gbl_file",g_gbl01,g_gbl_t.gbl02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
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
            LET g_gbl[l_ac].* = g_gbl_t.*
            CLOSE p_auth_as_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_gau01 > 0 THEN
            CALL cl_err("Primary Key CHANGING!","!",1)
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbl[l_ac].gbl02,-263,1)
            LET g_gbl[l_ac].* = g_gbl_t.*
         ELSE
            UPDATE gbl_file
               SET gbl02 = g_gbl[l_ac].gbl02,
                   gbl03 = g_gbl[l_ac].gbl03
             WHERE gbl01 = g_gbl01
               AND gbl02 = g_gbl_t.gbl02
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbl[l_ac].gbl02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbl_file",g_gbl01,g_gbl_t.gbl02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gbl[l_ac].* = g_gbl_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gbl[l_ac].* = g_gbl_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_gbl.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE p_auth_as_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE p_auth_as_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(gbl02) AND l_ac > 1 THEN
            LET g_gbl[l_ac].* = g_gbl[l_ac-1].*
            NEXT FIELD gbl02
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(gbl02)    #MOD-530267
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gap"
               LET g_qryparam.arg1 = g_gbl01 CLIPPED
               LET g_qryparam.arg2 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_gbl[l_ac].gbl02
               DISPLAY g_gbl[l_ac].gbl02 TO gbl02
               NEXT FIELD gbl02
         END CASE
 
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
 
      ON ACTION controls                       #No.FUN-6A0092 
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6A0092
 
   END INPUT
   CLOSE p_auth_as_bcl
   COMMIT WORK
END FUNCTION
 
 
FUNCTION p_auth_as_b_fill(p_wc)               #BODY FILL UP
   DEFINE p_wc         STRING
   DEFINE p_ac         LIKE type_file.num5    #FUN-680135 SMALLINT
 
    LET g_sql = " SELECT gbl02,'',gbl03 ",
                  " FROM gbl_file ",
                 " WHERE gbl01= '",g_gbl01 CLIPPED,"' ",
                   " AND ",p_wc CLIPPED,
                 " ORDER BY gbl02"
    PREPARE p_auth_as_prepare2 FROM g_sql           #預備一下
    DECLARE gbl_curs CURSOR FOR p_auth_as_prepare2
 
    CALL g_gbl.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gbl_curs INTO g_gbl[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          SELECT gbd04 INTO g_gbl[g_cnt].gbd04 FROM gbd_file
           WHERE gbd01=g_gbl[g_cnt].gbl02
             AND gbd02=g_gbl01 AND gbd03=g_lang
          IF cl_null(g_gbl[g_cnt].gbd04) THEN
             SELECT gbd04 INTO g_gbl[g_cnt].gbd04 FROM gbd_file
              WHERE gbd01=g_gbl[g_cnt].gbl02
                AND gbd02='standard' AND gbd03=g_lang
          END IF
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_gbl.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_auth_as_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gbl TO s_gbl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         CALL SET_COUNT(g_rec_b)
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY    
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
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
         CALL p_auth_as_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL p_auth_as_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL p_auth_as_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next                             # N.下筆
         CALL p_auth_as_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last                             # 最終筆
         CALL p_auth_as_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6A0092                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6A0092 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_auth_as_copy()
   DEFINE   l_n       LIKE type_file.num5,       #No.FUN-680135 SMALLINT
            l_newno   LIKE gbl_file.gbl01,
            l_oldno   LIKE gbl_file.gbl01
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
   IF g_gbl01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092 
   INPUT l_newno WITHOUT DEFAULTS FROM gbl01
 
      AFTER INPUT
         #No.TQC-740025--begin-- 
         IF INT_FLAG THEN  
            EXIT INPUT      
         END IF              
         #No.TQC-740025--end--
         IF cl_null(l_newno) THEN
            NEXT FIELD gbl01
            LET INT_FLAG = 1
#        ELSE
#           SELECT zx
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
      DISPLAY g_gbl01 TO gbl01
      RETURN
   END IF
 
   DROP TABLE x
#FUN-4C0020
   SELECT * FROM gbl_file
     WHERE gbl01=g_gbl01 and gbl02 NOT IN
     (SELECT gbl02 FROM gbl_file WHERE gbl01=l_newno)
     INTO TEMP x
{
   SELECT * FROM gbl_file WHERE gbl01=g_gbl01 
     INTO TEMP x
}
#FUN-4C0020(END)
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_gbl01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_gbl01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET gbl01 = l_newno                         # 資料鍵值
 
   INSERT INTO gbl_file SELECT * FROM x 
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('gbl:',SQLCA.SQLCODE,0)  #No.FUN-660081
      CALL cl_err3("ins","gbl_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldno = g_gbl01
   LET g_gbl01 = l_newno
 
   CALL p_auth_as_b()
   #LET g_gbl01 = l_oldno  #FUN-C30027
   #CALL p_auth_as_show()  #FUN-C30027
END FUNCTION
 
 
 #No.MOD-580056 --start
FUNCTION p_auth_as_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gbl01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p_auth_as_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gbl01",FALSE)
   END IF
 
END FUNCTION
 
#NO.MOD-590329 MARK---------------------------------
#FUNCTION p_auth_as_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gbl02",TRUE)
#   END IF
 
#END FUNCTION
 
#FUNCTION p_auth_as_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gbl02",FALSE)
#   END IF
 
#END FUNCTION
 #No.MOD-580056--end
#NO.MOD-590329 MARK
