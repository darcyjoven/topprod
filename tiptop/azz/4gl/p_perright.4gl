# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_perright
# Descriptions...: 群組或個別使用者特殊權限設定
# Date & Author..: 03/06/30 alex
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-540140 05/04/20 By alex 修改 controlf 寫法
# Modify.........: No.MOD-580056 05/08/05 By yiting key可更改
# Modify.........: No.MOD-590329 05/10/04 By yiting 針對zz13設定，假雙檔程式單身不做控管
# Modify.........: No.FUN-560038 05/10/07 By alex 增加與 p_per 互相勾稽,畫面名稱,控管
# Modify.........: No.MOD-560212 05/10/07 By alex 新增判斷此群組是否已失效,失效則不改
# Modify.........: No.TQC-630107 06/03/10 By Alexstar 單身筆數限制
# Modify.........: No.MOD-640496 06/04/17 By saki 修改azz-216訊息
# Modify.........: No.FUN-660081 06/06/25 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-570023 06/06/27 By alexstar 新增一筆資料時, 單頭程式代號欄位開窗無任何資料帶出
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740075 07/04/13 By Xufeng  "CLEAR FROM"應改為"CLEAR FORM"
# Modify.........: No.MOD-7B0166 07/11/20 By Smapmin 會掉複製相關程式段
# Modify.........: No.TQC-840055 08/04/23 By saki 增加行業別代碼
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
# Modify.........: No.FUN-8C0139 09/01/17 By kevin 新增欄位gaj12"資料隱藏否"
# Modify.........: No.MOD-960326 09/06/26 By Dido 資料隱藏否應限定於欄位才可設定,其餘類型是不可設定此功能的
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0438 09/12/28 By Dido 考量客制需求 
# Modify.........: No:MOD-A50003 10/05/10 By Smapmin 將MOD-960326的邏輯寫成function,然後AFTER FIELD gaj12/gaj02都要控管
# Modify.........: No:MOD-A50127 10/05/20 By sabrina 抓取模組改抓zz011
# Modify.........: No:MOD-B10162 11/01/20 By lilingyu 在客制路徑下面的畫面,會導致組出來的sql錯誤,而報錯
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-C90043 12/09/16 By SunLM 添加matrix类型的判断
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE    g_cnt2            LIKE type_file.num5,  #FUN-680135 SMALLINT
          g_gaj01           LIKE gaj_file.gaj01,  # 程式代號 (假單頭)
          g_gaj11           LIKE gaj_file.gaj11,  #No.TQC-840055
          g_gaz03           LIKE gaz_file.gaz03,  #FUN-560038
          g_gaj     DYNAMIC ARRAY of RECORD       # 程式變數(Program Variables)
            gaj12           LIKE gaj_file.gaj12,  #FUN-8C0139
            gaj02           LIKE gaj_file.gaj02,
            gaj03           LIKE gaj_file.gaj03,
            gaj04           LIKE gaj_file.gaj04,
            gaj05           LIKE gaj_file.gaj05,
            gaj06           LIKE gaj_file.gaj06
                        END RECORD,
         g_gaj_t            RECORD                # 變數舊值
            gaj12           LIKE gaj_file.gaj12,  #FUN-8C0139
            gaj02           LIKE gaj_file.gaj02,
            gaj03           LIKE gaj_file.gaj03,
            gaj04           LIKE gaj_file.gaj04,
            gaj05           LIKE gaj_file.gaj05,
            gaj06           LIKE gaj_file.gaj06
                        END RECORD,
         g_wc               STRING,                 #FUN-580092 HCN
         g_sql              STRING,                 #FUN-580092 HCN
         g_ss               LIKE type_file.chr1,    #FUN-680135  VARCHAR(1) # 決定後續步驟
         g_rec_b            LIKE type_file.num5,    # 單身筆數   #No.FUN-680135 SMALLINT
         l_ac               LIKE type_file.num5,    # 目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
         l_sl               LIKE type_file.num5     #FUN-680135  SMALLINT   # 目前處理的SCREEN LINE
DEFINE   g_chr              LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt              LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg              LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql       STRING
DEFINE   g_argv1            LIKE gaj_file.gaj01
DEFINE   g_before_input_done   LIKE type_file.num5       #No.FUN-680135 SMALLINT
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_curs_index       LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_row_count        LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_jump             LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_no_ask           LIKE type_file.num5          #No.FUN-680135 SMALLINT
 
MAIN
   DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680135 SMALLINT SMALLINT
#     DEFINE   l_time   LIKE type_file.chr8              #No.FUN-6A0096
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)            # 計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET p_row = 5 LET p_col = 1
 
   OPEN WINDOW p_perright_w AT p_row,p_col WITH FORM "azz/42f/p_perright" 
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL cl_set_combo_industry("gaj11")            #No.TQC-840055
 
   LET g_gaj01 = NULL                             # 清除鍵值
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_perright_q()
   END IF
 
   CALL p_perright_menu()                         # 中文
 
   CLOSE WINDOW p_perright_w                      # 結束畫面
     CALL  cl_used(g_prog,g_time,2)            # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
END MAIN
 
FUNCTION p_perright_curs()                        # QBE 查詢資料
 
   CLEAR FORM                                    # 清除畫面
   CALL g_gaj.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "gaj01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON gaj01,gaj11,gaj02,gaj03,gaj04,gaj05,gaj06
                   FROM gaj01,gaj11,    s_gaj[1].gaj02, s_gaj[1].gaj03,
                        s_gaj[1].gaj04,
                        s_gaj[1].gaj05, s_gaj[1].gaj06  #No.TQC-840055
 
         ON ACTION CONTROLP    #FUN-560038
            CASE
               WHEN INFIELD(gaj01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gav"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gaj01
                  NEXT FIELD gaj01
 
               WHEN INFIELD(gaj02)
                  CALL cl_init_qry_var()
                  #FUN-8C0139 --start
                  #LET g_qryparam.form = "q_gae"
                  #LET g_qryparam.state = "c"
                  LET g_qryparam.form     = "q_gae04"  
                  LET g_qryparam.arg1     = g_lang
                  LET g_qryparam.arg2     = g_gaj01  
                  CALL cl_create_qry() RETURNING g_gaj[l_ac].gaj02
                  DISPLAY g_gaj[l_ac].gaj02 TO gaj02          
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #DISPLAY g_qryparam.multiret TO gaj02
                  #FUN-8C0139  --end
 
               WHEN INFIELD(gaj03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zw"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gaj03
                  NEXT FIELD gaj03
 
               WHEN INFIELD(gaj04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zw"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gaj04
                  NEXT FIELD gaj04
 
               WHEN INFIELD(gaj05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zx"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gaj05
                  NEXT FIELD gaj05
 
               WHEN INFIELD(gaj06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zx"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gaj06
                  NEXT FIELD gaj06
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
 
   LET g_sql= "SELECT UNIQUE gaj01,gaj11 FROM gaj_file ",      #No.TQC-840055
              " WHERE ", g_wc CLIPPED," ORDER BY gaj01,gaj11"  #No.TQC-840055
 
   PREPARE p_perright_prepare FROM g_sql          # 預備一下
   DECLARE p_perright_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR p_perright_prepare
 
   #No.TQC-840055 --start--
#  LET g_sql = "SELECT COUNT(DISTINCT gaj01) FROM gaj_file ",
#              " WHERE ",g_wc CLIPPED
 
#  PREPARE p_perright_precount FROM g_sql
#  DECLARE p_perright_count CURSOR FOR p_perright_precount
   CALL p_perright_count()
   #No.TQC-840055 ---end---
 
END FUNCTION
 
#No.TQC-840055 --start--
FUNCTION p_perright_count()
   DEFINE lr_gaj   DYNAMIC ARRAY of RECORD        # 程式變數
            gaj01          LIKE gae_file.gae01,
            gaj11          LIKE gae_file.gae11
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10   #FUN-680135 INTEGER
 
   LET g_sql= "SELECT UNIQUE gaj01,gaj11 FROM gaj_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gaj01"
   PREPARE p_perright_precount FROM g_sql
   DECLARE p_perright_count CURSOR FOR p_perright_precount
   LET li_cnt=1
   FOREACH p_perright_count INTO lr_gaj[li_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_cnt - 1
END FUNCTION
#No.TQC-840055 ---end---
 
FUNCTION p_perright_menu()                        # 中文的MENU
 
 
   WHILE TRUE
      CALL p_perright_bp("G")
      CASE g_action_choice
         WHEN "insert"                            # A.輸入
            IF cl_chk_act_auth() THEN 
               CALL p_perright_a() 
            END IF
         WHEN "delete"                            # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_perright_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_perright_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "query"                             # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_perright_q() 
            END IF
         WHEN "help"                              # H.說明
            CALL cl_show_help()
         WHEN "controlg"                          # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exit"                              # Esc.結束
            EXIT WHILE
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gaj),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p_perright_a()                           # Add  輸入
 
   MESSAGE ""
   CLEAR FORM
   CALL g_gaj.clear()
 
   INITIALIZE g_gaj01 LIKE gaj_file.gaj01         # 預設值及將數值類變數清成零
   INITIALIZE g_gaj11 LIKE gaj_file.gaj11         # No.TQC-840055
   INITIALIZE g_gaz03 LIKE gaz_file.gaz03         # FUN-560038
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_perright_i("a")                      # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_gaj01=NULL
         LET g_gaj11=NULL                         #No.TQC-840055
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b=0                               #No.FUN-680064  
      IF g_ss='N' THEN
         CALL g_gaj.clear()
      ELSE
         CALL p_perright_b_fill('1=1')            # 單身
      END IF
 
      CALL p_perright_b()                         # 輸入單身
      CALL p_perright_count()
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p_perright_i(p_cmd)                      # 處理INPUT
 
   DEFINE   p_cmd   LIKE type_file.chr1           # a:輸入 u:更改        #No.FUN-680135 VARCHAR(1)
 
   LET g_ss = 'Y'
   DISPLAY g_gaj01 TO gaj01
   DISPLAY g_gaj11 TO gaj11                       #No.TQC-840055
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_gaj01,g_gaj11 WITHOUT DEFAULTS FROM gaj01,gaj11   #No.TQC-840055
 
    #NO.MOD-580056------
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_perright_set_entry(p_cmd)
         CALL p_perright_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
   #--------END
 
      AFTER FIELD gaj01                           # 查詢程式代號
         IF NOT cl_null(g_gaj01) THEN
            CALL p_perright_gaj01(p_cmd,g_gaj01)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gaj01,g_errno,0)
               NEXT FIELD gaj01
            END IF
            CALL p_perright_gaz03()
            DISPLAY g_gaz03 TO gaz03
         ELSE
            NEXT FIELD gaj01
         END IF
 
      #No.TQC-840055 --start--
      AFTER FIELD gaj11
         IF NOT cl_null(g_gaj01) AND NOT cl_null(g_gaj11) THEN
            SELECT COUNT(UNIQUE gaj11) INTO g_cnt FROM gaj_file
             WHERE gaj01=g_gaj01 AND gaj11=g_gaj11
            IF g_cnt > 0 THEN
               LET g_ss = 'Y'
            ELSE
               IF p_cmd = 'u' THEN
                  CALL cl_err(g_gaj11,-239,0)
                  NEXT FIELD gaj11
               END IF
            END IF
         END IF
      #No.TQC-840055 ---end---
 
      ON ACTION CONTROLP
         CALL cl_init_qry_var()
         CASE
            WHEN INFIELD(gaj01)
              #FUN-570023---start---mark
              #CASE g_lang
              #   WHEN "0"
              #      LET g_qryparam.form = "q_zz"
              #   WHEN "1"
              #      LET g_qryparam.form = "q_zze"
              #   WHEN "2"
              #      LET g_qryparam.form = "q_zzc"
              #   OTHERWISE
              #      LET g_qryparam.form = "q_zze"
              #END CASE
              #FUN-570023---end---mark
               LET g_qryparam.form = "q_gav"  #FUN-570023
               LET g_qryparam.default1= g_gaj01
               CALL cl_create_qry() RETURNING g_gaj01
#               CALL FGL_DIALOG_SETBUFFER( g_gaj01 )
               DISPLAY g_qryparam.default1 TO gaj01
               NEXT FIELD gaj01
            END CASE
 
      ON ACTION controlf                           # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON ACTION about         #FUN-860033
         CALL cl_about()      #FUN-860033
 
      ON ACTION controlg      #FUN-860033
         CALL cl_cmdask()     #FUN-860033
 
      ON ACTION help          #FUN-860033
         CALL cl_show_help()  #FUN-860033
 
      ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT 
 
   END INPUT
END FUNCTION
 
FUNCTION p_perright_gaj01(l_cmd,l_gaj01)
 
   DEFINE   l_cmd     LIKE type_file.chr1           #No.FUN-680135 VARCHAR(1)
   DEFINE   l_gaj01   LIKE gaj_file.gaj01
 
   LET g_errno = " "
 
   SELECT UNIQUE gaj01,gaj11 INTO g_chr           #No.TQC-840055
     FROM gaj_file
    WHERE gaj01 = g_gaj01 AND gaj11 = g_gaj11
 
   IF SQLCA.SQLCODE THEN                          # 不存在, 新來的
      CASE
         WHEN SQLCA.SQLCODE = 100 
            IF l_cmd='a' THEN 
               LET g_ss='N' 
            END IF
         OTHERWISE
            LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
   ELSE
      IF l_cmd='u' THEN 
         LET g_errno = "-239" 
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION p_perright_q()                           # Query 查詢
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   MESSAGE ""
  #CLEAR FROM  #No.TQC-740075
   CLEAR FORM  #No.TQC-740075
   CALL g_gaj.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_perright_curs()                         # 取得查詢條件
   IF INT_FLAG THEN                               # 使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_gaj01 TO NULL
      INITIALIZE g_gaj11 TO NULL                  # No.TQC-840055
      RETURN
   END IF
   OPEN p_perright_b_curs                         # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                          # 有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gaj01 TO NULL
   ELSE
      CALL p_perright_fetch('F')                  # 讀出TEMP第一筆並顯示
      #No.TQC-840055 --start--
      CALL p_perright_count()
#     OPEN p_perright_count
#     FETCH p_perright_count INTO g_row_count
      #No.TQC-840055 ---end---
      DISPLAY g_row_count TO FORMONLY.cnt        # ATTRIBUTE(MAGENTA)
   END IF
END FUNCTION
 
 
FUNCTION p_perright_fetch(p_flag)                 # 處理資料的讀取
 
   DEFINE   p_flag   LIKE type_file.chr1,         # 處理方式    #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10         # 絕對的筆數  #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     p_perright_b_curs INTO g_gaj01,g_gaj11   #No.TQC-840055
       WHEN 'P' FETCH PREVIOUS p_perright_b_curs INTO g_gaj01,g_gaj11   #No.TQC-840055
       WHEN 'F' FETCH FIRST    p_perright_b_curs INTO g_gaj01,g_gaj11   #No.TQC-840055
       WHEN 'L' FETCH LAST     p_perright_b_curs INTO g_gaj01,g_gaj11   #No.TQC-840055
       WHEN '/'  
          IF (NOT g_no_ask) THEN
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
          FETCH ABSOLUTE g_jump p_perright_b_curs INTO g_gaj01,g_gaj11    #No.TQC-840055
          LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gaj01,SQLCA.sqlcode,0)
      INITIALIZE g_gaj01 TO NULL  #TQC-6B0105
      INITIALIZE g_gaj11 TO NULL  #No.TQC-840055
      RETURN
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
 
   CALL p_perright_show()
 
END FUNCTION
 
FUNCTION p_perright_show()                        # 將資料顯示在畫面上
   CALL p_perright_gaz03()
   DISPLAY g_gaj01,g_gaz03,g_gaj11 TO gaj01,gaz03,gaj11         #MOD-560038  #No.TQC-840055
   CALL p_perright_b_fill(g_wc)                   # 單身
   CALL cl_show_fld_cont()                        #FUN-550037 hmf
END FUNCTION
 
#FUN-560038 (start)
FUNCTION p_perright_gaz03()
 
   DEFINE l_count  LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_gaz03 = ""
   LET l_count = 0
 
   SELECT count(*) INTO l_count FROM gaz_file WHERE gaz01=g_gaj01
 
   IF l_count > 0 THEN
      SELECT gaz03 INTO g_gaz03 FROM gaz_file
       WHERE gaz01=g_gaj01 AND gaz02=g_lang AND gaz05="Y"
      IF cl_null(g_gaz03) THEN
        SELECT gaz03 INTO g_gaz03 FROM gaz_file
         WHERE gaz01=g_gaj01 AND gaz02=g_lang AND gaz05="N"
      END IF
   ELSE
      SELECT gae04 INTO g_gaz03 FROM gae_file
       WHERE gae01=g_gaj01 AND gae02='wintitle' AND gae03=g_lang AND gae11="Y" AND gae12=g_ui_setting   #No.TQC-840055
      IF cl_null(g_gaz03) THEN
        SELECT gae04 INTO g_gaz03 FROM gae_file
         WHERE gae01=g_gaj01 AND gae02='wintitle' AND gae03=g_lang AND gae11="N" AND gae12=g_ui_setting   #No.TQC-840055
      END IF
   END IF
 
   IF g_gaj01='TopMenuGroup' THEN
      LET g_gaz03='Common Items For TOP Menu'
   END IF
 
   IF g_gaj01='TopProgGroup' THEN
      LET g_gaz03='Program Items For TOP Menu'
   END IF
 
END FUNCTION
#FUN-560038(end)
 
 
FUNCTION p_perright_r()                           # 取消整筆 (所有合乎單頭的資料)
 
  DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
           l_gaj   RECORD LIKE gaj_file.*
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_gaj01) THEN 
       CALL cl_err('',-400,0)
       RETURN
    END IF 
 
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
       DELETE FROM gaj_file WHERE gaj01 = g_gaj01 AND gaj11 = g_gaj11   #No.TQC-840055
       IF SQLCA.sqlcode THEN
#          CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660081
           CALL cl_err3("del","gaj_file",g_gaj01,"",SQLCA.sqlcode,"","BODY DELETE",0)    #No.FUN-660081
       ELSE
           CLEAR FORM
           CALL g_gaj.clear()
           #No.TQC-840055 --start--
           CALL p_perright_count()
#          OPEN p_perright_count
#          FETCH p_perright_count INTO g_row_count
           #No.TQC-840055 ---end---
#FUN-B50065------begin---
           IF cl_null(g_row_count) OR g_row_count=0 THEN
              COMMIT WORK
              RETURN
           END IF
#FUN-B50065------end-----
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN p_perright_b_curs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL p_perright_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET g_no_ask = TRUE
              CALL p_perright_fetch('/')
           END IF
 
       END IF
    END IF
    COMMIT WORK 
END FUNCTION
 
FUNCTION p_perright_b()                          #單身
 
    DEFINE l_ac_t          LIKE type_file.num5,        #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
           l_n             LIKE type_file.num5,        #檢查重複用        #No.FUN-680135 SMALLINT
           l_lock_sw       LIKE type_file.chr1,        #單身鎖住否        #No.FUN-680135 VARCHAR(1)
           p_cmd           LIKE type_file.chr1,        #處理狀態          #No.FUN-680135 VARCHAR(1)
           l_cnt           LIKE type_file.num5,        #檢查重複用        #No.FUN-680135 SMALLINT
           l_allow_insert  LIKE type_file.num5,        #No.FUN-680135 SMALLINT
           l_allow_delete  LIKE type_file.num5         #No.FUN-680135 SMALLINT
    DEFINE lc_gav03        LIKE gav_file.gav03
    DEFINE lc_gav09        LIKE gav_file.gav09
    DEFINE lc_gav10        LIKE gav_file.gav10
    #-----MOD-A50003---------
    #DEFINE ls_module       STRING		       #MOD-960326
    #DEFINE ls_frm_path     STRING                     #MOD-960326
    #DEFINE lwin_curr       ui.Window		       #MOD-960326
    #DEFINE lfrm_curr       ui.Form                    #MOD-960326
    #DEFINE lnode_item      om.DomNode                 #MOD-960326
    #DEFINE ls_tabname      STRING                     #MOD-960326
    #-----END MOD-A50003-----
 
    LET g_action_choice = NULL
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_gaj01) THEN 
       CALL cl_err('',-400,0)
       RETURN
    END IF 
 
    CALL cl_opmsg("b")
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    LET g_forupd_sql = " SELECT gaj12,gaj02,gaj03,gaj04,gaj05,gaj06 ", #FUN-8C0139
                         " FROM gaj_file ",
                        "  WHERE gaj01 = ? ",
                          " AND gaj02 = ? ",
                          " AND gaj11 = ? ",   #No.TQC-840055
                          " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_perright_bcl CURSOR FROM g_forupd_sql     # LOCK CURSOR
 
    LET l_ac_t = 0
 
    INPUT ARRAY g_gaj WITHOUT DEFAULTS FROM s_gaj.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b !=0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'              #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET p_cmd="u"              #表示更改狀態
               LET g_gaj_t.* = g_gaj[l_ac].*    #BACKUP
               OPEN p_perright_bcl USING g_gaj01, g_gaj_t.gaj02, g_gaj11  #No.TQC-840055
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gaj_t.gaj02,STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH p_perright_bcl INTO g_gaj[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gaj_t.gaj03,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               LET g_before_input_done = FALSE
               CALL p_perright_set_entry_b(p_cmd)
               CALL p_perright_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               #NEXT FIELD gaj12            #FUN-8C0139               
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd="a"
            INITIALIZE g_gaj[l_ac].* TO NULL       #900423
            #FUN-8C0139 --start
            IF cl_null(g_gaj[l_ac].gaj12) THEN
               LET g_gaj[l_ac].gaj12 = "N"            
            END IF
            #FUN-8C0139 --end
            LET g_gaj_t.* = g_gaj[l_ac].*          #新輸入資料
#---------NO.MOD-590329 MARK-------------
             #NO.MOD-580056
#            LET g_before_input_done = FALSE
#            CALL p_perright_set_entry_b(p_cmd)
#            CALL p_perright_set_no_entry_b(p_cmd)
#            LET g_before_input_done = TRUE
            #--END
#---------NO.MOD-590329 MARK-------------
            CALL cl_show_fld_cont()     #FUN-550037(smin)
       #FUN-8C0139 --start 
            #NEXT FIELD gaj02
            NEXT FIELD gaj12           
        
        BEFORE FIELD gaj12           
        	 IF p_cmd="u" AND cl_null(g_gaj[l_ac].gaj12) THEN
        	 	  LET g_gaj[l_ac].gaj12="N"
        	 	  DISPLAY g_gaj[l_ac].gaj12 TO gaj12
        	 END IF
        	 
        AFTER FIELD gaj12           
           IF NOT cl_null(g_gaj[l_ac].gaj02) THEN
              CASE p_perright_chk_gaj02(g_gaj[l_ac].gaj02,g_gaj[l_ac].gaj12)
               	WHEN 1
               		NEXT FIELD gaj12
               	WHEN 2               		
               		LET g_gaj[l_ac].gaj12 = "Y"
               		DISPLAY g_gaj[l_ac].gaj12 TO gaj12
               		NEXT FIELD gaj12               	
              END CASE 
              #-----MOD-A50003---------
              CALL gaj12_gaj02_check()   
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gaj[l_ac].gaj02,g_errno,1)                     
                 NEXT FIELD gaj12
              END IF
              #-----END MOD-A50003-----
           END IF
        #FUN-8C0139 --end
        
        AFTER FIELD gaj02                          #FUN-560038
            IF NOT cl_null(g_gaj[l_ac].gaj02) THEN #No.MOD-640496
              #-----MOD-A50003---------
              CALL gaj12_gaj02_check()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_gaj[l_ac].gaj02,g_errno,1)                     
                 NEXT FIELD gaj12
              END IF
	      ##-MOD-960326-add-
	      # IF g_gaj[l_ac].gaj12 = 'Y' THEN
              #    CALL p_perright_get_module(g_gaj01 CLIPPED) RETURNING ls_module,ls_frm_path
              #    IF cl_null(ls_module) THEN
              #       RETURN
              #    END IF
              #    OPEN WINDOW test_w WITH FORM ls_frm_path
              #       LET lwin_curr = ui.Window.getCurrent()
              #       LET lfrm_curr = lwin_curr.getForm()
              #       LET ls_tabname = cl_get_table_name(g_gaj[l_ac].gaj02 CLIPPED)   #No.FUN-720042
              #       LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||g_gaj[l_ac].gaj02 CLIPPED)   #No.FUN-720042
              #       IF lnode_item IS NULL THEN
              #          LET lnode_item = lfrm_curr.findNode("FormField","formonly."||g_gaj[l_ac].gaj02 CLIPPED)
              #          IF lnode_item IS NULL THEN
              #             LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||g_gaj[l_ac].gaj02 CLIPPED)   #No.FUN-720042
              #             IF lnode_item IS NULL THEN
              #                LET lnode_item = lfrm_curr.findNode("TableColumn","formonly."||g_gaj[l_ac].gaj02 CLIPPED)
              #             END IF
              #          END IF
              #       END IF
              #       IF lnode_item IS NULL THEN
              #          CLOSE WINDOW test_w
              #          CALL cl_err(g_gaj[l_ac].gaj02,"-4322",1)                     
              #          NEXT FIELD gaj02
              #       END IF
              #    CLOSE WINDOW test_w
              # END IF
	      ##-MOD-960326-end-
              #-----END MOD-A50003-----
               SELECT count(*) INTO l_cnt FROM gav_file
                WHERE gav01 = g_gaj01 AND gav02=g_gaj[l_ac].gaj02 AND gav08 = "Y" AND gav11 = g_ui_setting   #No.TQC-840055
               IF l_cnt = 1 THEN
                  SELECT gav03,gav09,gav10 INTO lc_gav03,lc_gav09,lc_gav10 FROM gav_file
                   WHERE gav01 = g_gaj01 AND gav02=g_gaj[l_ac].gaj02 AND gav08 = "Y" AND gav11 = g_ui_setting   #No.TQC-840055
               ELSE
                  SELECT gav03,gav09,gav10 INTO lc_gav03,lc_gav09,lc_gav10 FROM gav_file
                   WHERE gav01 = g_gaj01 AND gav02=g_gaj[l_ac].gaj02 AND gav08 = "N" AND gav11 = g_ui_setting   #No.TQC-840055
                  IF SQLCA.SQLCODE THEN
#                    CALL cl_err(g_gaj[l_ac].gaj02 CLIPPED,"azz-216",1)   #No.FUN-660081
                     CALL cl_err3("sel","gav_file",g_gaj01,g_gaj[l_ac].gaj02,"azz-216","","",1)    #No.FUN-660081
                     NEXT FIELD gaj02
                  END IF
               END IF
               IF lc_gav03 = "N" OR
                  ((lc_gav09 = "N" OR lc_gav09 IS NULL) AND lc_gav10 = "Y" ) THEN
                  #FUN-8C0139 --start
                  IF g_gaj[l_ac].gaj12="Y" THEN
                     #可以輸入任何欄位
                  ELSE
                   #  CALL cl_err(g_gaj[l_ac].gaj02,"azz-118",1)                      #tianry add 161206
                   #  NEXT FIELD gaj02
                  END IF
                  #FUN-8C0139 --end
               END IF
            END IF                                 #No.MOD-640496
 
        BEFORE FIELD gaj03
           CALL p_perright_set_entry_b(p_cmd)
 
        AFTER FIELD gaj03
            IF NOT cl_null(g_gaj[l_ac].gaj03) THEN   #MOD-560212
              IF NOT p_perright_chkzwacti(g_gaj[l_ac].gaj03) THEN
                 NEXT FIELD gaj03
              END IF
           END IF
           CALL p_perright_set_no_entry_b(p_cmd)
 
        BEFORE FIELD gaj04
           CALL p_perright_set_entry_b(p_cmd)
 
        AFTER FIELD gaj04
            IF NOT cl_null(g_gaj[l_ac].gaj04) THEN   #MOD-560212
              IF NOT p_perright_chkzwacti(g_gaj[l_ac].gaj04) THEN
                 NEXT FIELD gaj04
              END IF
           END IF
           CALL p_perright_set_no_entry_b(p_cmd)
 
        BEFORE FIELD gaj05
           CALL p_perright_set_entry_b(p_cmd)
 
        AFTER FIELD gaj05
           CALL p_perright_set_no_entry_b(p_cmd)
 
        BEFORE FIELD gaj06
           CALL p_perright_set_entry_b(p_cmd)
 
        AFTER FIELD gaj06
           CALL p_perright_set_no_entry_b(p_cmd)
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         
         #FUN-8C0139 --start
         IF g_gaj[l_ac].gaj12="N" AND NOT cl_null(g_gaj[l_ac].gaj02) THEN
            CASE p_perright_chk_gaj02(g_gaj[l_ac].gaj02,g_gaj[l_ac].gaj12)
               	WHEN 1
                   NEXT FIELD gaj02
               	WHEN 2
               	   NEXT FIELD gaj02               	
            END CASE
         END IF
         #FUN-8C0139 --end
         
         #FUN-560038
         IF cl_null(g_gaj[l_ac].gaj03) AND cl_null(g_gaj[l_ac].gaj04) AND
            cl_null(g_gaj[l_ac].gaj05) AND cl_null(g_gaj[l_ac].gaj06) THEN
            CALL cl_err(g_gaj[l_ac].gaj02 CLIPPED,"azz-241",1)   #No.MOD-640496
            CANCEL INSERT
            NEXT FIELD gaj03
         ELSE
            INSERT INTO gaj_file(gaj01,gaj02,gaj03,gaj04,gaj05,gaj06,gaj11,gaj12) #No.MOD-470041  #No.TQC-840055 #FUN-8C0139
                          VALUES(g_gaj01,g_gaj[l_ac].gaj02,
                                 g_gaj[l_ac].gaj03,g_gaj[l_ac].gaj04,
                                 g_gaj[l_ac].gaj05,g_gaj[l_ac].gaj06,g_gaj11,g_gaj[l_ac].gaj12) #No.TQC-840055 #FUN-8C0139
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gaj01,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("ins","gaj_file",g_gaj01,g_gaj[l_ac].gaj02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2    #No.TQC-840055
            END IF
         END IF
 
        BEFORE DELETE                            #是否取消單身
           IF NOT cl_null(g_gaj_t.gaj02) THEN
              IF NOT cl_delb(1,3) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM gaj_file WHERE gaj01 = g_gaj01
                                     AND gaj02 = g_gaj_t.gaj02
                                     AND gaj11 = g_gaj11        #No.TQC-840055
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_gaj_t.gaj02,SQLCA.sqlcode,0)   #No.FUN-660081
                 CALL cl_err3("del","gaj_file",g_gaj01,g_gaj_t.gaj02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF 
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2    #No.TQC-840055
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gaj[l_ac].* = g_gaj_t.*
              CLOSE p_perright_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           
           #FUN-8C0139 --start
           IF g_gaj[l_ac].gaj12="N" AND NOT cl_null(g_gaj[l_ac].gaj02) THEN #No.MOD-640496
              CASE p_perright_chk_gaj02(g_gaj[l_ac].gaj02,g_gaj[l_ac].gaj12)
               	WHEN 1
               	   NEXT FIELD gaj02
               	WHEN 2
               	   NEXT FIELD gaj02               	
              END CASE
           END IF
           
           IF cl_null(g_gaj[l_ac].gaj03) AND cl_null(g_gaj[l_ac].gaj04) AND
              cl_null(g_gaj[l_ac].gaj05) AND cl_null(g_gaj[l_ac].gaj06) THEN
              CALL cl_err(g_gaj[l_ac].gaj02 CLIPPED,"azz-241",1)      
              NEXT FIELD gaj03
           END IF
           #FUN-8C0139 --end
           
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gaj[l_ac].gaj02,-263,1)
              LET g_gaj[l_ac].* = g_gaj_t.*
           ELSE
              UPDATE gaj_file
                 SET gaj02 = g_gaj[l_ac].gaj02,
                     gaj03 = g_gaj[l_ac].gaj03,
                     gaj04 = g_gaj[l_ac].gaj04,
                     gaj05 = g_gaj[l_ac].gaj05,
                     gaj06 = g_gaj[l_ac].gaj06,
                     gaj12 = g_gaj[l_ac].gaj12  #FUN-8C0139
               WHERE gaj01 = g_gaj01 AND gaj02 = g_gaj_t.gaj02 AND gaj11 = g_gaj11   #No.TQC-840055
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_gaj[l_ac].gaj02,SQLCA.sqlcode,0)   #No.FUN-660081
                 CALL cl_err3("upd","gaj_file",g_gaj01,g_gaj_t.gaj02,SQLCA.sqlcode,"","",0)    #No.FUN-660081
                 LET g_gaj[l_ac].* = g_gaj_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
          END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30034 add
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gaj[l_ac].* = g_gaj_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_gaj.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_perright_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034 add
         
         #FUN-8C0139 --start                    
         #CALL g_gaj.deleteElement(g_rec_b+1)   #FUN-D30034 mark      
         #FUN-8C0139 --end
         
         CLOSE p_perright_bcl
         COMMIT WORK
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(gaj02) AND l_ac > 1 THEN
                LET g_gaj[l_ac].* = g_gaj[l_ac-1].*
                DISPLAY g_gaj[l_ac].* TO s_gaj[l_ac].*
                NEXT FIELD gaj02
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gaj02)
                  CALL cl_init_qry_var()
                  #FUN-8C0139 --start
                  #LET g_qryparam.form     = "q_gae"
                  LET g_qryparam.form     = "q_gae04"  
                  LET g_qryparam.arg1     = g_lang     
                  LET g_qryparam.arg2     = g_gaj01    
                  LET g_qryparam.default1 = g_gaj[l_ac].gaj02
                  #LET g_qryparam.arg1     = g_gaj01
                  
                  CALL cl_create_qry() RETURNING g_gaj[l_ac].gaj02
                  #FUN-8C0139 --end
                  DISPLAY g_gaj[l_ac].gaj02 TO gaj02
                  NEXT FIELD gaj02
 
               WHEN INFIELD(gaj03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_zw"
                  LET g_qryparam.default1 = g_gaj[l_ac].gaj03
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_gaj[l_ac].gaj03
                  DISPLAY g_gaj[l_ac].gaj03 TO gaj03
                  NEXT FIELD gaj03
 
               WHEN INFIELD(gaj04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_zw"
                  LET g_qryparam.default1 = g_gaj[l_ac].gaj04 
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_gaj[l_ac].gaj04
                  DISPLAY g_gaj[l_ac].gaj04 TO gaj04
                  NEXT FIELD gaj04
 
               WHEN INFIELD(gaj05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_zx"
                  LET g_qryparam.default1 = g_gaj[l_ac].gaj05
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_gaj[l_ac].gaj05
                  DISPLAY g_gaj[l_ac].gaj05 TO gaj05
                  NEXT FIELD gaj05
 
               WHEN INFIELD(gaj06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_zx"
                  LET g_qryparam.default1 = g_gaj[l_ac].gaj06
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_gaj[l_ac].gaj06
                  DISPLAY g_gaj[l_ac].gaj06 TO gaj06
                  NEXT FIELD gaj06
 
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
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
 
        END INPUT
 
    CLOSE p_perright_bcl
    COMMIT WORK
END FUNCTION
 
#-----MOD-A50003---------
FUNCTION gaj12_gaj02_check() 
   DEFINE ls_module       STRING		      
   DEFINE ls_frm_path     STRING                   
   DEFINE lwin_curr       ui.Window	
   DEFINE lfrm_curr       ui.Form     
   DEFINE lnode_item      om.DomNode
   DEFINE ls_tabname      STRING   

   LET g_errno=''

   IF g_gaj[l_ac].gaj12 = 'Y' THEN
      CALL p_perright_get_module(g_gaj01 CLIPPED) RETURNING ls_module,ls_frm_path
      IF cl_null(ls_module) THEN
         RETURN
      END IF
      OPEN WINDOW test_w WITH FORM ls_frm_path
         LET lwin_curr = ui.Window.getCurrent()
         LET lfrm_curr = lwin_curr.getForm()
         LET ls_tabname = cl_get_table_name(g_gaj[l_ac].gaj02 CLIPPED)  
         LET lnode_item = lfrm_curr.findNode("FormField",ls_tabname||"."||g_gaj[l_ac].gaj02 CLIPPED)   
         #MOD-C90043 add beg
         IF lnode_item IS NULL THEN
         	LET  lnode_item = lfrm_curr.findNode("Matrix",ls_tabname||"."||g_gaj[l_ac].gaj02 CLIPPED) 
         #MOD-C90043 add end
            IF lnode_item IS NULL THEN
               LET lnode_item = lfrm_curr.findNode("FormField","formonly."||g_gaj[l_ac].gaj02 CLIPPED)
               IF lnode_item IS NULL THEN
                  LET lnode_item = lfrm_curr.findNode("TableColumn",ls_tabname||"."||g_gaj[l_ac].gaj02 CLIPPED)   
                  IF lnode_item IS NULL THEN
                     LET lnode_item = lfrm_curr.findNode("TableColumn","formonly."||g_gaj[l_ac].gaj02 CLIPPED)
                  END IF
               END IF
            END IF
         END IF #MOD-C90043 add   
         IF lnode_item IS NULL THEN
            CLOSE WINDOW test_w
            LET g_errno='-4322'
         END IF
      CLOSE WINDOW test_w
   END IF
END FUNCTION
#-----END MOD-A50003-----


#-MOD-960326-add-
FUNCTION p_perright_get_module(ps_frm_name)
   DEFINE   ps_frm_name STRING
   DEFINE   li_i        LIKE type_file.num10
   DEFINE   li_error    LIKE type_file.num5
   DEFINE   lc_gao01    LIKE gao_file.gao01
   DEFINE   lc_gax02    LIKE gax_file.gax02
   DEFINE   lc_zz011    LIKE zz_file.zz011
   DEFINE   lc_zz01     LIKE zz_file.zz01   #MOD-A50127 add 
   DEFINE   ls_module   STRING
   DEFINE   ls_frm_path STRING
   DEFINE   l_cnt       LIKE type_file.num5             #MOD-9C0438
 
   LET li_error = FALSE
   CASE
      WHEN ps_frm_name.subString(1,1)="a" OR ps_frm_name.subString(1,1)="g"
        #MOD-A50127---modify---start---
        #FOR li_i=3 TO ps_frm_name.getLength()
        #    LET ls_module = ps_frm_name.subString(1,li_i)
        #    LET lc_gao01 = UPSHIFT(ls_module.trim())
        #    SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
        #    IF NOT SQLCA.SQLCODE THEN
        #       LET li_error=FALSE
        #       EXIT FOR
        #    ELSE
        #       LET li_error=TRUE
        #    END IF
        #END FOR
         LET lc_zz01 = ps_frm_name.trim()
         SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01 = lc_zz01 
         LET ls_module = lc_zz011
         SELECT gao01 FROM gao_file WHERE gao01= lc_zz011
         IF NOT SQLCA.SQLCODE THEN
            LET li_error=FALSE
         ELSE
            LET li_error=TRUE
         END IF
        #MOD-A50127---modify---end---
      WHEN ps_frm_name.subString(1,2)="sa" OR ps_frm_name.subString(1,2)="sg"
         FOR li_i=4 TO ps_frm_name.getLength()
            LET ls_module = ps_frm_name.subString(2,li_i)
            LET lc_gao01 = UPSHIFT(ls_module.trim())
            SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
            IF NOT SQLCA.SQLCODE THEN
               LET li_error=FALSE
               EXIT FOR
            ELSE
               LET li_error=TRUE
            END IF
         END FOR
      WHEN ps_frm_name.subString(1,2)="sc" 
         FOR li_i=4 TO ps_frm_name.getLength()
            LET ls_module = ps_frm_name.subString(2,li_i)
            LET lc_gao01 = UPSHIFT(ls_module.trim())
            SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
            IF NOT SQLCA.SQLCODE THEN
               EXIT FOR
            END IF
         END FOR
      WHEN ps_frm_name.subString(1,2)="p_" OR ps_frm_name.trim()="udm_tree" 
         LET lc_gax02 = ps_frm_name.trim()
         SELECT zz011 INTO lc_zz011 FROM zz_file,gax_file
          WHERE gax02 = lc_gax02 AND gax01 = zz01
         IF DOWNSHIFT(lc_zz011) = "ain" THEN
            LET ls_module = "ain"
         ELSE
            LET ls_module = "azz"
         END IF
      WHEN ps_frm_name.subString(1,2)="s_" 
         LET ls_module = "sub"
      WHEN ps_frm_name.subString(1,2)="q_" 
         LET ls_module = "qry"
      WHEN ps_frm_name.subString(1,1)="c" 
         CASE
            WHEN ps_frm_name.subString(2,3)="l_"
               LET ls_module = "lib"
            WHEN ps_frm_name.subString(2,4)="cl_"
               LET ls_module = "clib"
            WHEN ps_frm_name.subString(2,3)="p_"
               LET ls_module = "czz"
            WHEN ps_frm_name.subString(2,3)="q_"
               LET ls_module = "cqry"
            WHEN ps_frm_name.subString(2,3)="s_"
               LET ls_module = "csub"
            OTHERWISE
               FOR li_i=3 TO ps_frm_name.getLength()
                  LET ls_module = ps_frm_name.subString(1,li_i)
                  LET lc_gao01 = UPSHIFT(ls_module.trim())
                  SELECT gao01 FROM gao_file WHERE gao01=lc_gao01
                  IF NOT SQLCA.SQLCODE THEN
                     EXIT FOR
                  END IF
               END FOR
         END CASE
      OTHERWISE
         RETURN ls_module,ls_frm_path
   END CASE
 
  #-MOD-9C0438-add-
   SELECT COUNT(*) INTO l_cnt FROM gae_file
    WHERE gae01 = g_gaj01 AND gae11 = "Y" 
   IF l_cnt > 1 THEN
      LET ls_module = 'c'||ls_module.subString(2,ls_module.getLength())      #MOD-B10162
      LET ls_frm_path = FGL_GETENV("CUST") || "/" || DOWNSHIFT(ls_module CLIPPED) || "/42f/" || ps_frm_name CLIPPED
   ELSE
      LET ls_frm_path = FGL_GETENV("TOP")  || "/" || DOWNSHIFT(ls_module CLIPPED) || "/42f/" || ps_frm_name CLIPPED
   END IF
  #-MOD-9C0438-end-
 
   RETURN ls_module,ls_frm_path
END FUNCTION
#-MOD-960326-end-
 
 # MOD-560212
FUNCTION p_perright_chkzwacti(ls_zw)
 
    DEFINE ls_zw       STRING
    DEFINE lst_grup    base.StringTokenizer,
           ls_grup     STRING
    DEFINE ls_unact    STRING
    DEFINE lc_zw01     LIKE zw_file.zw01
    DEFINE lc_zwacti   LIKE zw_file.zwacti
 
    LET lst_grup = base.StringTokenizer.create(ls_zw CLIPPED, "|")
    LET ls_unact = ""
 
    WHILE lst_grup.hasMoreTokens()
       LET ls_grup = lst_grup.nextToken()
       LET lc_zw01 = ls_grup.trim()
 
       SELECT zwacti INTO lc_zwacti FROM zw_file
        WHERE zw01 = lc_zw01
       IF lc_zwacti = "N" THEN
          LET ls_unact = ls_unact,", ",lc_zw01 CLIPPED
       END IF
    END WHILE
 
    IF cl_null(ls_unact) THEN
       RETURN TRUE
    ELSE
       LET ls_unact = ls_unact.subString(2,ls_unact.getLength())
       LET ls_unact = ls_unact.trim()
       CALL cl_err_msg(NULL,"azz-218",ls_unact.trim(),10)
       RETURN FALSE
    END IF
 
END FUNCTION
 
 
#No.MOD-580056 --start
FUNCTION p_perright_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("gaj01,gaj11",TRUE)   #No.TQC-840055
   END IF
 
END FUNCTION
 
FUNCTION p_perright_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gaj01,gaj11",FALSE)  #No.TQC-840055
   END IF
END FUNCTION
#--END
 
FUNCTION p_perright_set_entry_b(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
#---------NO.MOD-590329 MARK---------------------
#    #NO.MOD-580056
#   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
#     CALL cl_set_comp_entry("gaj02",TRUE)
#   END IF
   #--END
#NO.MOD-590329 MARK----------------
 
   IF INFIELD(gaj03) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj04",TRUE)
   END IF
   IF INFIELD(gaj04) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj03",TRUE)
   END IF
   IF INFIELD(gaj05) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj06",TRUE)
   END IF
   IF INFIELD(gaj06) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("gaj05",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_perright_set_no_entry_b(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
#--------NO.MOD-590329 MARK------------
    #NO.MOD-580056
#   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
#     CALL cl_set_comp_entry("gaj02",FALSE)
#   END IF
   #--END
#--------NO.MOD-590329 MARK------------
#  CALL GET_FLDBUF(s_smy.*) RETURNING g_gaj[l_ac].*
 
   IF INFIELD(gaj03) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj[l_ac].gaj03) THEN
         CALL cl_set_comp_entry("gaj04",FALSE)
      END IF
   END IF
 
   IF INFIELD(gaj04) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj[l_ac].gaj04) THEN
         CALL cl_set_comp_entry("gaj03",FALSE)
      END IF
   END IF
 
   IF INFIELD(gaj05) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj[l_ac].gaj05) THEN
         CALL cl_set_comp_entry("gaj06",FALSE)
      END IF
   END IF
 
   IF INFIELD(gaj06) OR (NOT g_before_input_done) THEN
      IF NOT cl_null(g_gaj[l_ac].gaj06) THEN
         CALL cl_set_comp_entry("gaj05",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION p_perright_b_askkey()
 
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(200)
 
    CONSTRUCT l_wc ON gaj03,gaj04,gaj05,gaj06
                 FROM s_gaj[1].gaj03, s_gaj[1].gaj04, s_gaj[1].gaj05,
                      s_gaj[1].gaj06
 
       ON ACTION about         #FUN-860033
          CALL cl_about()      #FUN-860033
 
       ON ACTION controlg      #FUN-860033
          CALL cl_cmdask()     #FUN-860033
 
       ON ACTION help          #FUN-860033
          CALL cl_show_help()  #FUN-860033
 
       ON IDLE g_idle_seconds  #FUN-860033
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
    END CONSTRUCT
                      
    IF INT_FLAG THEN RETURN END IF
    CALL p_perright_b_fill(l_wc)
END FUNCTION
 
FUNCTION p_perright_b_fill(p_wc)              #BODY FILL UP
 
DEFINE  p_wc          LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(300)
 
    LET g_sql = "SELECT gaj12,gaj02,gaj03,gaj04,gaj05,gaj06 ",    #FUN-8C0139
                 " FROM gaj_file ",
                " WHERE gaj_file.gaj01 = '",g_gaj01,"' ",
                  " AND gaj_file.gaj11 = '",g_gaj11,"' ",   #No.TQC-840055
                  " AND ",p_wc CLIPPED,
                " ORDER BY gaj02,gaj03,gaj04"
 
    PREPARE p_perright_prepare2 FROM g_sql           #預備一下
    DECLARE gaj_curs CURSOR FOR p_perright_prepare2
 
    CALL g_gaj.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH gaj_curs INTO g_gaj[g_cnt].*       #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #FUN-8C0139
        IF cl_null(g_gaj[g_cnt].gaj12) THEN
           LET g_gaj[g_cnt].gaj12 = "N"
        END IF
        #FUN-8C0139
        LET g_cnt = g_cnt + 1
        #NO.TQC-630107---add---
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
        END IF
        #NO.TQC-630107---end---
    END FOREACH
    CALL g_gaj.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cnt2 #FUN-8C0139
 
END FUNCTION
 
FUNCTION p_perright_bp(p_ud)
 
   DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud<>'G' OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gaj TO s_gaj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY                    # A.輸入
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY                    # Q.查詢
 
      ON ACTION first
         CALL p_perright_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL p_perright_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL p_perright_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL p_perright_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL p_perright_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
#        CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY                    # U.更改
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY                    # R.取消
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY                    # B.單身
 
      #-----MOD-7B0166--------- 
      #ON ACTION reproduce
      #   LET g_action_choice="reproduce"
      #   EXIT DISPLAY                    # C.複製
      #-----END MOD-7B0166-----
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY                    # H.說明
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY                    # Esc.結束
 
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
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
 
#FUN-8C0139 --start
FUNCTION p_perright_chk_gaj02(p_gaj02,p_gaj12)
DEFINE p_gaj02   LIKE gaj_file.gaj02,
       p_gaj12   LIKE gaj_file.gaj12,
       l_cnt     LIKE type_file.num5           
DEFINE lc_gav03  LIKE gav_file.gav03
DEFINE lc_gav09  LIKE gav_file.gav09
DEFINE lc_gav10  LIKE gav_file.gav10  
 
   IF NOT cl_null(p_gaj02) THEN #No.MOD-640496
      SELECT count(*) INTO l_cnt FROM gav_file
       WHERE gav01 = g_gaj01 AND gav02=p_gaj02 AND gav08 = "Y" AND gav11 = "std"    #No.TQC-840055
      IF l_cnt = 1 THEN
         SELECT gav03,gav09,gav10 INTO lc_gav03,lc_gav09,lc_gav10 FROM gav_file
          WHERE gav01 = g_gaj01 AND gav02=p_gaj02 AND gav08 = "Y" AND gav11 = "std" #No.TQC-840055
      ELSE
         SELECT gav03,gav09,gav10 INTO lc_gav03,lc_gav09,lc_gav10 FROM gav_file
          WHERE gav01 = g_gaj01 AND gav02=p_gaj02 AND gav08 = "N" AND gav11 = "std" #No.TQC-840055
         IF SQLCA.SQLCODE THEN
#           CALL cl_err(p_gaj02 CLIPPED,"azz-216",1)   #No.FUN-660081
            CALL cl_err3("sel","gav_file",g_gaj01,p_gaj02,"azz-216","","",1)    #No.FUN-660081                     
            RETURN 1                    
         END IF
      END IF
      IF lc_gav03 = "N" OR
         ((lc_gav09 = "N" OR lc_gav09 IS NULL) AND lc_gav10 = "Y" ) THEN
         
         IF p_gaj12="Y" THEN
            RETURN 0
         ELSE
       #     CALL cl_err(p_gaj02,"azz-118",1)                      #tianry add 161206
       #     RETURN 2
         END IF
         #FUN-8C0139 --end
      END IF
   END IF                              #No.MOD-640496
   RETURN 0
END FUNCTION
#FUN-8C0139 --end
