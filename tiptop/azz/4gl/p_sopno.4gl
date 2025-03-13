# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: p_sopno.4gl
# Descriptions...: SOP情境流程維護作業  
# Date & Author..: 03/03/17 By Nicola
# Modify.........: No.FUN-4B0049 04/11/19 By Yuna 加轉excel檔功能
# Modify.........: No.MOD-550209 05/06/01 By alex 刪除 p_zl 的聯接 p_zl不開放user用
# Modify.........: No.FUN-660081 06/06/15 By Carrier cl_err-->cl_err3
# Modify.........: No.MOD-670039 06/07/10 By day CONSTRUCT sop編號時不可多選
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/22 By bnlent  新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.MOD-8A0014 08/10/02 By clover 對應SOP代號,情境代號中文顯示
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_gbb01         LIKE gbb_file.gbb01,
    g_gba011        LIKE gba_file.gba011,
    g_gba021        LIKE gba_file.gba021,
    g_gbb02         LIKE gbb_file.gbb02,
    g_gbb03         LIKE gbb_file.gbb03,
    g_gbb04         LIKE gbb_file.gbb04,
    g_gbb01_t       LIKE gbb_file.gbb01,
    g_gbb02_t       LIKE gbb_file.gbb02,
    g_gbb03_t       LIKE gbb_file.gbb03,
    g_gbb04_t       LIKE gbb_file.gbb04,
    g_gbb           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        gbb05       LIKE gbb_file.gbb05, 
        gbb06       LIKE gbb_file.gbb06, 
        gbb07       LIKE gbb_file.gbb07, 
        gbb08       LIKE gbb_file.gbb08, 
       #zz02        LIKE zz_file.zz02, #TQC-740155 
        gaz03       LIKE gaz_file.gaz03, #TQC-740155
        gbb09       LIKE gbb_file.gbb09, 
        gbb10       LIKE gbb_file.gbb10, 
        gem02       LIKE gem_file.gem02, 
        gbb11       LIKE gbb_file.gbb11, 
        gbb12       LIKE gbb_file.gbb12, 
        gbb13       LIKE gbb_file.gbb13, 
        gbb14       LIKE gbb_file.gbb14, 
        gbb15       LIKE gbb_file.gbb15  
                    END RECORD,
    g_gbb_t         RECORD                  #程式變數 (舊值)
        gbb05       LIKE gbb_file.gbb05, 
        gbb06       LIKE gbb_file.gbb06, 
        gbb07       LIKE gbb_file.gbb07, 
        gbb08       LIKE gbb_file.gbb08, 
       #zz02        LIKE zz_file.zz02, #TQC-740155
        gaz03       LIKE gaz_file.gaz03, #TQC-740155
        gbb09       LIKE gbb_file.gbb09, 
        gbb10       LIKE gbb_file.gbb10, 
        gem02       LIKE gem_file.gem02, 
        gbb11       LIKE gbb_file.gbb11, 
        gbb12       LIKE gbb_file.gbb12, 
        gbb13       LIKE gbb_file.gbb13, 
        gbb14       LIKE gbb_file.gbb14, 
        gbb15       LIKE gbb_file.gbb15  
                    END RECORD,
g_wc,g_sql,g_wc2    string,                 #No.FUN-580092 HCN
    g_show          LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,    #單身筆數      #No.FUN-680135 SMALLINT
    g_flag          LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1) 
    g_argv1         LIKE gbb_file.gbb01,
    g_argv2         LIKE gbb_file.gbb02,
    g_argv3         LIKE gbb_file.gbb03,
    g_argv4         LIKE gbb_file.gbb04,
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT   #No.FUN-680135 SMALLINT
    # 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   mi_curs_index   LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE   g_row_count     LIKE type_file.num10  #No.FUN-580092 HCN  #No.FUN-680135 INTEGER
DEFINE   mi_jump         LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5   #No.FUN-680135 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5   #No.FUN-680135 SMALLINT 
#主程式開始
DEFINE   g_forupd_sql STRING                   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10  #No.FUN-680135 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000#No.FUN-680135 VARCHAR(72)
 
MAIN
#     DEFINEl_time   LIKE type_file.chr8              #No.FUN-6A0096
 
   OPTIONS                                     #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   LET g_argv3 = ARG_VAL(3)
   LET g_argv4 = ARG_VAL(4)
 
   LET p_row = 3 LET p_col = 17
 
   OPEN WINDOW p_sopno_w AT p_row,p_col
     WITH FORM "azz/42f/p_sopno"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
   CALL cl_set_combo_lang("gbb04")
 
 
   IF NOT cl_null(g_argv1) THEN
      CALL p_sopno_q()
   END IF
 
   CALL p_sopno_menu()
 
   CLOSE WINDOW p_sopno_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
 
END MAIN
 
FUNCTION p_sopno_cs()
 
   IF cl_null(g_argv1) THEN
      CLEAR FORM                             #清除畫面
      CALL g_gbb.clear()
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      CONSTRUCT g_wc ON gbb01,gbb02,gbb03,gbb04,gbb05,gbb06,gbb07,gbb08,gbb09,
                        gbb10,gbb11,gbb12,gbb13,gbb14,gbb15
          FROM gbb01,gbb02,gbb03,gbb04,s_gbb[1].gbb05,s_gbb[1].gbb06,
               s_gbb[1].gbb07,s_gbb[1].gbb08,s_gbb[1].gbb09,s_gbb[1].gbb10,
               s_gbb[1].gbb11,s_gbb[1].gbb12,s_gbb[1].gbb13,s_gbb[1].gbb14,s_gbb[1].gbb15
         
         ON ACTION CONTROLP
            #No.MOD-670039--begin
            CASE
              WHEN INFIELD(gbb01) 
#               CALL q_gba(TRUE,TRUE,g_gbb01) RETURNING g_gbb01,g_gbb02,g_gbb03,g_gbb04 
                CALL q_gba(FALSE,TRUE,g_gbb01) RETURNING g_gbb01,g_gbb02,g_gbb03,g_gbb04
                DISPLAY g_gbb01 TO gbb01
                DISPLAY g_gbb02 TO gbb02
                DISPLAY g_gbb03 TO gbb03
                DISPLAY g_gbb04 TO gbb04
                NEXT FIELD gbb01
              OTHERWISE EXIT CASE
            END CASE
            #No.MOD-670039--end  
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON gbb05,gbb06,gbb07,gbb08,gbb09,gbb10,gbb11,gbb12,gbb13,
                         gbb14,gbb15
         FROM s_gbb[1].gbb05,s_gbb[1].gbb06,s_gbb[1].gbb07,s_gbb[1].gbb08,
              s_gbb[1].gbb09,s_gbb[1].gbb10,s_gbb[1].gbb11,s_gbb[1].gbb12,
              s_gbb[1].gbb13,s_gbb[1].gbb14,s_gbb[1].gbb15 
     
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gbb10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_gbb[1].gbb10
               WHEN INFIELD(gbb08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gaz"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_gbb[1].gbb08
               OTHERWISE
                  EXIT CASE
            END CASE
     
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      END CONSTRUCT
     
      IF INT_FLAG THEN 
         RETURN
      END IF
 
   ELSE
      LET g_wc=" gbb01='",g_argv1,"' AND gbb02='",g_argv2,"' AND gbb03='",g_argv3,"' AND gbb04='",g_argv4,"'"
      LET g_wc2=" 1=1"
   END IF
 
   LET g_sql= "SELECT UNIQUE gbb01,gbb02,gbb03,gbb04 FROM gbb_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY gbb01"
   PREPARE p_sopno_prepare FROM g_sql      #預備一下
   DECLARE p_sopno_bcs                     #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_sopno_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT gbb01) FROM gbb_file",
             " WHERE ", g_wc CLIPPED 
   PREPARE p_sopno_precount FROM g_sql
   DECLARE p_sopno_count CURSOR FOR p_sopno_precount
 
   IF NOT cl_null(g_argv1) THEN
      LET g_gbb01=g_argv1
   END IF
   IF NOT cl_null(g_argv2) THEN
      LET g_gbb02=g_argv2
   END IF
   IF NOT cl_null(g_argv3) THEN
      LET g_gbb03=g_argv3
   END IF
   IF NOT cl_null(g_argv4) THEN
      LET g_gbb04=g_argv4
   END IF
   IF NOT cl_null(g_argv1) OR 
      NOT cl_null(g_argv2) OR
      NOT cl_null(g_argv3) OR
      NOT cl_null(g_argv4) THEN
      SELECT gba011,gba021 INTO g_gba011,g_gba021 
        FROM gba_file 
       WHERE gba01=g_argv1
         AND gba02=g_argv2 
         AND gba03=g_argv3 
         AND gba04=g_argv4 
   END IF
   CALL p_sopno_show()
 
END FUNCTION
 
FUNCTION p_sopno_menu()
 
   WHILE TRUE
      CALL p_sopno_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL p_sopno_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_sopno_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL p_sopno_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gbb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_sopno_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_gbb.clear()
   LET g_gbb01_t  = NULL
   LET g_gbb02_t  = NULL
   LET g_gbb03_t  = NULL
   LET g_gbb04_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL p_sopno_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_gbb01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      CALL p_sopno_b_fill(g_wc2)            #單身
      LET g_rec_b=0
      CALL p_sopno_b()                      #輸入單身
 
      LET g_gbb01_t = g_gbb01
      LET g_gbb02_t = g_gbb02
      LET g_gbb03_t = g_gbb03
      LET g_gbb04_t = g_gbb04
      EXIT WHILE
   END WHILE
 
END FUNCTION
   
FUNCTION p_sopno_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
    l_n             LIKE type_file.num5,   #No.FUN-680135 SMALLINT
    l_str           LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(40)
 
 
    INITIALIZE g_gbb01  TO NULL
    INITIALIZE g_gbb02  TO NULL
    INITIALIZE g_gbb03  TO NULL
    INITIALIZE g_gbb04  TO NULL
    CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
    INPUT g_gbb01,g_gbb02,g_gbb03,g_gbb04 WITHOUT DEFAULTS FROM gbb01,gbb02,gbb03,gbb04 
 
       ON ACTION CONTROLP
          CALL q_gba(FALSE,TRUE,g_gbb01) RETURNING g_gbb01,g_gbb02,g_gbb03,g_gbb04
          DISPLAY g_gbb01 TO gbb01
          DISPLAY g_gbb02 TO gbb02
          DISPLAY g_gbb03 TO gbb03
          DISPLAY g_gbb04 TO gbb04
      
       ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
       AFTER INPUT
         IF NOT cl_null(g_gbb01) AND NOT cl_null(g_gbb02)
            AND NOT cl_null(g_gbb03) AND NOT cl_null(g_gbb04) THEN
            IF g_gbb01 != g_gbb01_t OR cl_null(g_gbb01_t)
               OR g_gbb02 != g_gbb02_t OR cl_null(g_gbb02_t)
               OR g_gbb03 != g_gbb03_t OR cl_null(g_gbb03_t)
               OR g_gbb04 != g_gbb04_t OR cl_null(g_gbb04_t) THEN
               SELECT COUNT(*) INTO g_cnt FROM gba_file
                WHERE gba01 = g_gbb01 AND gba02 = g_gbb02 
                  AND gba03 = g_gbb03 AND gba04 = g_gbb04
               IF g_cnt <= 0 THEN
                  CALL cl_err(g_gbb01,"mfg9329",0)
                  LET g_gbb01 = g_gbb01_t
                  LET g_gbb02 = g_gbb02_t
                  LET g_gbb03 = g_gbb03_t
                  LET g_gbb04 = g_gbb04_t
                  NEXT FIELD gbb01
               END IF
            END IF
         END IF
 
    END INPUT
 
END FUNCTION
 
FUNCTION p_sopno_q()
    LET g_row_count = 0 #No.FUN-580092 HCN
   LET mi_curs_index = 0
    CALL cl_navigator_setting(mi_curs_index,g_row_count) #No.FUN-580092 HCN
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_gbb.clear()
   DISPLAY '    ' TO FORMONLY.cnt 
 
   CALL p_sopno_cs()                   #取得查詢條件
 
   IF INT_FLAG THEN                    #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_gbb01 TO NULL
      RETURN
   END IF
 
   OPEN p_sopno_bcs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN               #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_gbb01 TO NULL
   ELSE
      OPEN p_sopno_count
       FETCH p_sopno_count INTO g_row_count  #No.FUN-580092 HCN
       DISPLAY g_row_count TO FORMONLY.cnt   #No.FUN-580092 HCN
      CALL p_sopno_fetch('F')                #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION p_sopno_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式   #No.FUN-680135 VARCHAR(1) 
   l_abso          LIKE type_file.num10     #絕對的筆數 #No.FUN-680135 INTEGER
 
   MESSAGE ""
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     p_sopno_bcs INTO g_gbb01,g_gbb02,g_gbb03,g_gbb04
       WHEN 'P' FETCH PREVIOUS p_sopno_bcs INTO g_gbb01,g_gbb02,g_gbb03,g_gbb04
       WHEN 'F' FETCH FIRST    p_sopno_bcs INTO g_gbb01,g_gbb02,g_gbb03,g_gbb04
       WHEN 'L' FETCH LAST     p_sopno_bcs INTO g_gbb01,g_gbb02,g_gbb03,g_gbb04
       WHEN '/' 
          IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR mi_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
              END PROMPT
              IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          FETCH ABSOLUTE mi_jump p_sopno_bcs INTO g_gbb01,g_gbb02,g_gbb03,g_gbb04
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_gbb01,SQLCA.sqlcode,0)
      INITIALIZE g_gbb01 TO NULL  #TQC-6B0105
      INITIALIZE g_gbb02 TO NULL  #TQC-6B0105
      INITIALIZE g_gbb03 TO NULL  #TQC-6B0105
      INITIALIZE g_gbb04 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
            WHEN 'F' LET mi_curs_index = 1
            WHEN 'P' LET mi_curs_index = mi_curs_index - 1
            WHEN 'N' LET mi_curs_index = mi_curs_index + 1
             WHEN 'L' LET mi_curs_index = g_row_count #No.FUN-580092 HCN
            WHEN '/' LET mi_curs_index = mi_jump          --改mi_jump
       END CASE
 
       CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
       
       #MOD-8A0014--start
       LET g_gba011='',g_gba021=''
       SELECT gba011,gba021 INTO g_gba011,g_gba021
        FROM gba_file
       WHERE gba01=g_gbb01
         AND gba02=g_gbb02
         AND gba03=g_gbb03
         AND gba04=g_gbb04
       #MOD-8A0014 --END   
       CALL p_sopno_show()
   END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION p_sopno_show()
  
   DISPLAY g_gbb01 TO gbb01                        #單頭
   DISPLAY g_gbb02 TO gbb02                        #單頭
   DISPLAY g_gbb03 TO gbb03                        #單頭
   DISPLAY g_gbb04 TO gbb04                        #單頭
   DISPLAY g_gba011 TO gbb01_desc                  #單頭
   DISPLAY g_gba021 TO gbb02_desc                  #單頭
 
   CALL p_sopno_b_fill(g_wc2)                      #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION p_sopno_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
   l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680135 SMALLINT
   l_sum           LIKE alg_file.alg05,    #預設值加總(gbb05) #No.FUN-680135 DEC(5,2)
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680135 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680135 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680135 SMALLINT
   l_allow_delete  LIKE type_file.num5,    #可刪除否          #No.FUN-680135 SMALLINT
   l_cmd  LIKE type_file.chr1000           #No.FUN-680135     VARCHAR(100)
 
   LET g_action_choice = ""
 
   IF cl_null(g_gbb01) THEN 
      RETURN
   END IF
 
   IF s_shut(0) THEN
      RETURN 
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT gbb05,gbb06,gbb07,gbb08,'',gbb09,gbb10,'',",
                      "       gbb11,gbb12,gbb13,gbb14,gbb15",
                      "  FROM gbb_file",
                      "  WHERE gbb01 = ? AND gbb02 = ? AND gbb03=? ",
                      "   AND gbb04 = ? AND gbb05 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_sopno_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_gbb WITHOUT DEFAULTS FROM s_gbb.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_gbb_t.* = g_gbb[l_ac].*  #BACKUP
            BEGIN WORK
            OPEN p_sopno_bcl USING g_gbb01,g_gbb02,g_gbb03,g_gbb04,g_gbb_t.gbb05
            IF STATUS THEN
               CALL cl_err("OPEN p_sopno_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH p_sopno_bcl INTO g_gbb[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gbb_t.gbb05,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  LET g_gbb_t.*=g_gbb[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         SELECT gem02 INTO g_gbb[l_ac].gem02 FROM gem_file
          WHERE gem01 = g_gbb[l_ac].gbb10
         DISPLAY g_gbb[l_ac].gem02 TO gem02
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gbb[l_ac].* TO NULL            #900423
         LET g_gbb_t.* = g_gbb[l_ac].*               #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD gbb05
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO gbb_file(gbb01,gbb02,gbb03,gbb04,gbb05,gbb06,gbb07,gbb08,
                              gbb09,gbb10,gbb11,gbb12,gbb13,gbb14,gbb15)
              VALUES(g_gbb01,g_gbb02,g_gbb03,g_gbb04,g_gbb[l_ac].gbb05,
                     g_gbb[l_ac].gbb06,g_gbb[l_ac].gbb07,g_gbb[l_ac].gbb08,
                     g_gbb[l_ac].gbb09,g_gbb[l_ac].gbb10,g_gbb[l_ac].gbb11,
                     g_gbb[l_ac].gbb12,g_gbb[l_ac].gbb13,g_gbb[l_ac].gbb14,
                     g_gbb[l_ac].gbb15)
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_gbb[l_ac].gbb05,SQLCA.sqlcode,0)  #No.FUN-660081
            CALL cl_err3("ins","gbb_file",g_gbb01,g_gbb[l_ac].gbb05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2 
         END IF
 
      BEFORE FIELD gbb05                        #default 序號
         IF cl_null(g_gbb[l_ac].gbb05) OR g_gbb[l_ac].gbb05 = 0 THEN
            SELECT max(gbb05)+1
              INTO g_gbb[l_ac].gbb05
              FROM gbb_file
             WHERE gbb01 = g_gbb01
               AND gbb02 = g_gbb02
               AND gbb03 = g_gbb03
               AND gbb04 = g_gbb04
            IF cl_null(g_gbb[l_ac].gbb05) THEN
               LET g_gbb[l_ac].gbb05 = 1
            END IF
         END IF
 
      AFTER FIELD gbb05                        #check 序號是否重複
         IF NOT cl_null(g_gbb[l_ac].gbb05) THEN
            IF g_gbb[l_ac].gbb05 != g_gbb_t.gbb05 OR cl_null(g_gbb_t.gbb05) THEN
               SELECT COUNT(*) INTO l_n FROM gbb_file
                WHERE gbb01 = g_gbb01
                  AND gbb02 = g_gbb02
                  AND gbb03 = g_gbb03 
                  AND gbb04 = g_gbb04
                  AND gbb05 = g_gbb[l_ac].gbb05
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gbb[l_ac].gbb05 = g_gbb_t.gbb05
                  NEXT FIELD gbb05
               END IF
            END IF
         END IF
 
      AFTER FIELD gbb08
         IF NOT cl_null(g_gbb[l_ac].gbb08) THEN
            SELECT COUNT(*) INTO g_cnt FROM zz_file
             WHERE zz01 = g_gbb[l_ac].gbb08
            IF g_cnt = 0 THEN
               CALL cl_err(g_gbb[l_ac].gbb08,"",0)
               NEXT FIELD gbb08
            ELSE
              #SELECT zz02 INTO g_gbb[l_ac].zz02 FROM zz_file #TQC-740155
              # WHERE zz01 = g_gbb[l_ac].gbb08 #TQC-740155
              #LET g_gbb[l_ac].zz02=cl_get_progdesc(g_gbb[l_ac].gbb08,g_lang) #TQC-740155
              #DISPLAY g_gbb[l_ac].zz02 TO zz02 #TQC-740155
               LET g_gbb[l_ac].gaz03=cl_get_progdesc(g_gbb[l_ac].gbb08,g_lang) #TQC-740155
               DISPLAY g_gbb[l_ac].gaz03 TO zz02 #TQC-740155
               IF g_gbb[l_ac].gbb09 is NULL or g_gbb[l_ac].gbb09=" " THEN
                  LET g_gbb[l_ac].gbb09 = g_gbb[l_ac].gaz03 #TQC-740155
               END IF 
               DISPLAY g_gbb[l_ac].gbb09 TO gbb09
            END IF
         END IF
 
      AFTER FIELD gbb10
         IF NOT cl_null(g_gbb[l_ac].gbb10) THEN
           # SELECT COUNT(*) INTO g_cnt FROM gem_file
           #  WHERE gem01 = g_gbb[l_ac].gbb10
           # IF g_cnt = 0 THEN
           #    CALL cl_err(g_gbb[l_ac].gbb10,"",0)
           #    NEXT FIELD gbb10
           # ELSE
               SELECT gem02 INTO g_gbb[l_ac].gem02 FROM gem_file
                WHERE gem01 = g_gbb[l_ac].gbb10
               DISPLAY g_gbb[l_ac].gem02 TO gem02
           # END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_gbb_t.gbb05 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM gbb_file
             WHERE gbb01 = g_gbb01 
               AND gbb02 = g_gbb02 
               AND gbb03 = g_gbb03 
               AND gbb04 = g_gbb04 
               AND gbb05 = g_gbb_t.gbb05
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbb_t.gbb05,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","gbb_file",g_gbb01,g_gbb_t.gbb05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2 
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gbb[l_ac].* = g_gbb_t.*
            CLOSE p_sopno_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gbb[l_ac].gbb05,-263,1)
            LET g_gbb[l_ac].* = g_gbb_t.*
         ELSE
            UPDATE gbb_file SET gbb05 = g_gbb[l_ac].gbb05,
                                gbb06 = g_gbb[l_ac].gbb06,
                                gbb07 = g_gbb[l_ac].gbb07,
                                gbb08 = g_gbb[l_ac].gbb08,
                                gbb09 = g_gbb[l_ac].gbb09,
                                gbb10 = g_gbb[l_ac].gbb10,
                                gbb11 = g_gbb[l_ac].gbb11,
                                gbb12 = g_gbb[l_ac].gbb12,
                                gbb13 = g_gbb[l_ac].gbb13,
                                gbb14 = g_gbb[l_ac].gbb14,
                                gbb15 = g_gbb[l_ac].gbb15 
             WHERE gbb01 = g_gbb01 
               AND gbb02 = g_gbb02 
               AND gbb03 = g_gbb03 
               AND gbb04 = g_gbb04 
               AND gbb05 = g_gbb_t.gbb05
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_gbb[l_ac].gbb05,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","gbb_file",g_gbb01,g_gbb_t.gbb05,SQLCA.sqlcode,"","",0)    #No.FUN-660081
               LET g_gbb[l_ac].* = g_gbb_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30034
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gbb[l_ac].* = g_gbb_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_gbb.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE p_sopno_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30034
         CLOSE p_sopno_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gbb10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_gbb[l_ac].gbb10
               CALL cl_create_qry() RETURNING g_gbb[l_ac].gbb10
               DISPLAY g_gbb[l_ac].gbb10 TO gbb10
#              CALL FGL_DIALOG_SETBUFFER(g_gbb[l_ac].gbb10 )
            WHEN INFIELD(gbb08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaz"
               LET g_qryparam.default1 = g_gbb[l_ac].gbb08
                LET g_qryparam.arg1 = g_lang CLIPPED   #No.MOD-490082
               CALL cl_create_qry() RETURNING g_gbb[l_ac].gbb08
               DISPLAY g_gbb[l_ac].gbb08 TO gbb08
#              CALL FGL_DIALOG_SETBUFFER(g_gbb[l_ac].gbb08 )
            OTHERWISE
               EXIT CASE
          END CASE
      
 #     ON ACTION p_bug                  #MOD-550209
#        LET l_cmd = "p_zl"
#        CALL cl_cmdrun(l_cmd CLIPPED)
 
       # Rita 
      ON ACTION excute
         LET l_cmd = g_gbb[l_ac].gbb08
         CALL cl_cmdrun(l_cmd CLIPPED)
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gbb05) AND l_ac > 1 THEN
            LET g_gbb[l_ac].* = g_gbb[l_ac-1].*
            NEXT FIELD gbb05
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------       
   
   END INPUT
 
   CLOSE p_sopno_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION p_sopno_b_fill(p_wc)     #BODY FILL UP
DEFINE
   p_wc  LIKE type_file.chr1000   #No.FUN-680135 VARCHAR(200)
 
   LET g_sql = "SELECT gbb05,gbb06,gbb07,gbb08,'',gbb09,gbb10,'',",
               "       gbb11,gbb12,gbb13,gbb14,gbb15",
               "  FROM gbb_file ",
               " WHERE gbb01 = '",g_gbb01,"'",
               "   AND gbb02 = '",g_gbb02,"'",
               "   AND gbb03 = '",g_gbb03,"'",
               "   AND gbb04 = '",g_gbb04,"'",
               "   AND ",p_wc CLIPPED ,
               " ORDER BY gbb05,gbb06"
   PREPARE p_sopno_prepare2 FROM g_sql       #預備一下
   DECLARE gbb_cs CURSOR FOR p_sopno_prepare2
   DISPLAY "g_sql=",g_sql
   CALL g_gbb.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH gbb_cs INTO g_gbb[g_cnt].*     #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT gem02 INTO g_gbb[g_cnt].gem02 FROM gem_file
       WHERE gem01 = g_gbb[g_cnt].gbb10
     #SELECT zz02 INTO g_gbb[g_cnt].zz02 FROM zz_file #TQC-740155
     # WHERE zz01 = g_gbb[g_cnt].gbb08 #TQC-740155
      LET g_gbb[g_cnt].gaz03=cl_get_progdesc(g_gbb[g_cnt].gbb08,g_lang) #TQC-740155
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gbb.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION p_sopno_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
   DEFINE   l_cmd  LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(100)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gbb TO s_gbb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         # 2004/01/17 by Hiko : 上下筆資料的ToolBar控制.
          CALL cl_navigator_setting(mi_curs_index, g_row_count) #No.FUN-580092 HCN
 
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
      ON ACTION first 
         CALL p_sopno_fetch('F')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL p_sopno_fetch('P')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL p_sopno_fetch('/')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL p_sopno_fetch('N')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL p_sopno_fetch('L')
          CALL cl_navigator_setting(mi_curs_index, g_row_count)   ###add in 040517 #No.FUN-580092 HCN
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
 
 #     ON ACTION p_bug                      #MOD-550209
#        LET l_cmd = "p_zl"
#        CALL cl_cmdrun(l_cmd CLIPPED)
 
       # Rita 
      ON ACTION excute
         LET l_cmd = g_gbb[l_ac].gbb08
         CALL cl_cmdrun(l_cmd CLIPPED)
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         # 2004/03/24 新增語言別選項
         CALL cl_set_combo_lang("gbb04")
         EXIT DISPLAY
 
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
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
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
 
