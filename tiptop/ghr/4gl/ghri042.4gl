# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#
# Pattern name...: ghri042.4gl
# Descriptions...: 畫面元件顯示多語言設定作業
# Date & Author..: 13/05/22 hourf  

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE   g_hrat01          LIKE hrat_file.hrat01
DEFINE   g_hratid          LIKE hrat_file.hratid
DEFINE   g_hrcb06        LIKE hrcb_file.hrcb06
DEFINE   g_hrcb07        LIKE hrcb_file.hrcb07
DEFINE   g_hrcb01          LIKE hrcb_file.hrcb01,   # 類別代號 (假單頭)
         g_hrcb01_t        LIKE hrcb_file.hrcb01,   # 類別代號 (假單頭)
         g_hrcb02          LIKE hrcb_file.hrcb02,   # 類別代號 (假單頭)
         g_hrcb02_t        LIKE hrcb_file.hrcb02,   # 類別代號 (假單頭)
         g_hrcb03          LIKE hrcb_file.hrcb03,   # No.FUN-710055
         g_hrcb03_t        LIKE hrcb_file.hrcb03,   # No.FUN-710055
         g_hrcb_lock RECORD LIKE hrcb_file.*,      # FOR LOCK CURSOR TOUCH
         g_hrcb    DYNAMIC ARRAY of RECORD        # 程式變數
            hrcb04          LIKE hrcb_file.hrcb04,
            hrcb05          LIKE hrat_file.hratid,
            hrat01          LIKE hrat_file.hrat01,
            hrat02          LIKE hrat_file.hrat02,
            hrat03          LIKE hrat_file.hrat03,
            hrat03_name     LIKE hraa_file.hraa12,
            hrat04          LIKE hrat_file.hrat04,
            hrat04_name     LIKE hrao_file.hrao02,
            hrat05          LIKE hrat_file.hrat05,
            hrat05_name     LIKE hrap_file.hrap06,   #FUN-7B0081
            hrcb06        LIKE hrcb_file.hrcb06,
            hrcb07        LIKE hrcb_file.hrcb07
                      END RECORD,
         g_hrcb_t           RECORD                 # 變數舊值
            hrcb04          LIKE hrcb_file.hrcb04,
            hrcb05          LIKE hrat_file.hratid,
            hrat01          LIKE hrat_file.hrat01,
            hrat02          LIKE hrat_file.hrat02,
            hrat03          LIKE hrat_file.hrat03,
            hrat03_name     LIKE hraa_file.hraa12,
            hrat04          LIKE hrat_file.hrat04,
            hrat04_name     LIKE hrao_file.hrao02,
            hrat05          LIKE hrat_file.hrat05,   
            hrat05_name     LIKE hrap_file.hrap06,   #FUN-7B0081
            hrcb06        LIKE hrcb_file.hrcb06,
            hrcb07        LIKE hrcb_file.hrcb07
                      END RECORD,
         g_cnt2                LIKE type_file.num5,    #FUN-680135 SMALLINT
         g_wc                  STRING,  #No.FUN-580092 HCN
         g_sql                 STRING,  #No.FUN-580092 HCN
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 #No.FUN-680135 VARCHAR(1)
         g_rec_b               LIKE type_file.num5,    # 單身筆數     #No.FUN-680135 SMALLINT
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT  #No.FUN-680135 SMALLINT
DEFINE   g_chr                 LIKE type_file.chr1     #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt                 LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_msg                 LIKE type_file.chr1000  #No.FUN-680135 VARCHAR(72)
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5     #No.FUN-680135 SMALLINT
DEFINE   g_argv1               LIKE hrcb_file.hrcb01
DEFINE   g_curs_index          LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_row_count           LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_jump                LIKE type_file.num10    #No.FUN-680135 INTEGER
DEFINE   g_no_ask              LIKE type_file.num5     #No.FUN-680135 SMALLINT #No.FUN-6A0080
DEFINE   g_std_id              LIKE smb_file.smb01     #No.FUN-710055
DEFINE   g_db_type             LIKE type_file.chr3     #No.FUN-760049
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE g_hrat  DYNAMIC ARRAY OF RECORD 
               hrat01   LIKE hrat_file.hrat01,
               hrat02   LIKE hrat_file.hrat02,
               hrao02   LIKE hrao_file.hrao02,
               hras04   LIKE hras_file.hras04,
               hrad03   LIKE hrad_file.hrad03,
               hrat25   LIKE hrat_file.hrat25
               END RECORD 
DEFINE g_hrcb_1   DYNAMIC ARRAY OF RECORD
         hrcb01     LIKE   hrcb_file.hrcb01,
         hrcb02     LIKE   hrcb_file.hrcb02
                  END RECORD,
       g_rec_b1,l_ac1   LIKE  type_file.num5
DEFINE g_bp_flag           LIKE type_file.chr1
DEFINE g_flag              LIKE type_file.chr1
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0096
 
   LET g_hrcb01_t = NULL
 
   #一般行業別代碼
#  SELECT smb01 INTO g_std_id FROM smb_file WHERE smb02="0" AND smb05="Y"  #No.FUN-760049 mark
   LET g_std_id = "std"            #No.FUN-760049 
   OPEN WINDOW ghri042_w WITH FORM "ghr/42f/ghri042"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   # 2004/03/24 新增語言別選項
#   CALL cl_set_combo_lang("hrcb03")    # mark by hourf 13/05/22
 
#  CALL ghri042_set_combobox()
#   CALL cl_set_combo_industry("hrcb03")    #No.FUN-750068
   LET g_db_type=cl_db_get_database_type()   #No.FUN-760049
 
   LET g_forupd_sql =" SELECT * FROM hrcb_file ",  
                      "  WHERE hrcb01 = ?  ",  #No.FUN-710055
                      " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ghri042_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL ghri042_q()
   END IF
 
   CALL ghri042_menu() 
 
   CLOSE WINDOW ghri042_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
         RETURNING g_time    #No.FUN-6A0096
END MAIN
 
FUNCTION ghri042_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_hrcb.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = "hrcb01 = '",g_argv1 CLIPPED,"' "
   ELSE
      CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
      IF NOT cl_null(g_hrcb[1].hrat01) THEN
         SELECT hratid INTO g_hrcb[1].hrcb05 
           FROM hrcb_file
          WHERE hrat01=g_hrcb[1].hrat01
      END IF
      CONSTRUCT g_wc ON hrcb01,hrcb02,hrcb03,hrat01,hrcb05,hrcb06,hrcb07                             #No.FUN-710055
                   FROM hrcb01,hrcb02,hrcb03,s_hrcb[1].hrat01,s_hrcb[1].hrcb05,s_hrcb[1].hrcb06,s_hrcb[1].hrcb07
         ON ACTION controlp
            CASE
               WHEN INFIELD(hrcb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrcb"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrcb01
                  NEXT FIELD hrcb01
              WHEN INFIELD(hrat01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrat"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_lang
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrat01
                  NEXT FIELD hrat01 
               OTHERWISE
                  EXIT CASE
            END CASE
 
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcbuser','hrcbgrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   END IF
 
 
#   IF g_wc.getIndexOf("gbs06",1) THEN   #FUN-7B0081        #mark by hourf 13/05/22
      IF g_db_type = "ORA" THEN
         LET g_sql=" SELECT UNIQUE hrcb01,hrcb02,hrcb03 FROM hrcb_file,hrat_file ",
                    " WHERE  hratid = hrcb05 ",
                    "   and " ,g_wc CLIPPED,
                    "order by hrcb01 "  #add by zhuzw 20140922
      END IF
   PREPARE ghri042_prepare FROM g_sql          # 預備一下
   DECLARE ghri042_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR ghri042_prepare
 
END FUNCTION
 
 # 2004/09/29 MOD-490456 選出筆數直接寫入 g_row_count
FUNCTION ghri042_count()
 
   DEFINE la_hrcb   DYNAMIC ARRAY of RECORD        # 程式變數
            hrcb01          LIKE hrcb_file.hrcb01
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b LIKE type_file.num10   #FUN-680135 INTEGER
 
   LET g_sql= "SELECT UNIQUE hrcb01 FROM hrcb_file,hrat_file ",  #No.FUN-710055
              " WHERE ", g_wc CLIPPED,
              "  and  hratid = hrcb05 ",
              " GROUP BY hrcb01 ORDER BY hrcb01"       #No.FUN-710055
 
   PREPARE ghri042_precount FROM g_sql
   DECLARE ghri042_count CURSOR FOR ghri042_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH ghri042_count INTO la_hrcb[li_cnt].hrcb01 
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
 
FUNCTION ghri042_menu()
 
   WHILE TRUE
      CALL ghri042_bp("G")
      
      IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN 
         SELECT hrcb01,hrcb02,hrcb03
           INTO g_hrcb01,g_hrcb02,g_hrcb03
           FROM hrcb_file
          WHERE hrcb01=g_hrcb_1[l_ac1].hrcb01
      END IF

      IF g_action_choice != "" THEN
         LET g_bp_flag = 'Page2'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         IF g_rec_b >0 THEN
             CALL ghri042_fetch('/')
         END IF
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("Page3", TRUE)
      END IF
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL ghri042_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL ghri042_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL ghri042_copy()
            END IF
        WHEN "delete"                          # R.取消
           IF cl_chk_act_auth() THEN
              CALL ghri042_r()
           END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL ghri042_q()
            END IF
         WHEN "nozu"  
            IF cl_chk_act_auth() THEN
               CALL ghri042_no_fill()
            END IF          
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL ghri042_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcb),'','')
            END IF
          WHEN "showlog"           #MOD-440464
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("ghri042")
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION ghri042_a()                            # Add  輸入
   MESSAGE ""
   CLEAR FORM
   CALL g_hrcb.clear()
 
   INITIALIZE g_hrcb01 LIKE hrcb_file.hrcb01         # 預設值及將數值類變數清成零
   INITIALIZE g_hrcb02 LIKE hrcb_file.hrcb02
   INITIALIZE g_hrcb03 LIKE hrcb_file.hrcb03         #No.FUN-710055
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
   	  LET g_flag = 'Y'
      CALL hr_gen_no('hrcb_file','hrcb01','059','0000','') RETURNING g_hrcb01,g_flag
      DISPLAY g_hrcb01 TO hrcb01
      IF g_flag = 'Y' THEN
         CALL cl_set_comp_entry("hrcb01",TRUE)
      ELSE
         CALL cl_set_comp_entry("hrcb01",FALSE)
      END IF
      CALL ghri042_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_hrcb01=NULL
         LET g_hrcb02=NULL
         LET g_hrcb03=NULL                         #No.FUN-710055
         LET INT_FLAG = 0
         CALL cl_err('',9001,1)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
#      IF g_ss='N' THEN                         #mark by hourf 13/05/23
#         CALL g_hrcb.clear()
#      ELSE
#         CALL ghri042_b_fill('1=1')             # 單身
#      END IF
 
      CALL ghri042_b()                          # 輸入單身
      LET g_hrcb01_t=g_hrcb01
      LET g_hrcb02_t=g_hrcb02
      LET g_hrcb03_t=g_hrcb03                       #No.FUN-710055
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION ghri042_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    #FUN-680135 SMALLINT
 
   LET g_ss = 'Y'
    
   DISPLAY g_hrcb01,g_hrcb02,g_hrcb03 TO hrcb01,hrcb02,hrcb03    #No.FUN-710055
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT g_hrcb01,g_hrcb02,g_hrcb03 WITHOUT DEFAULTS FROM hrcb01,hrcb02,hrcb03 #No.FUN-710055
     BEFORE INPUT 
      IF p_cmd='u' THEN
       CALL cl_set_comp_entry("hrcb01",FALSE)
      ELSE 
       CALL cl_set_comp_entry("hrcb01",TRUE)
   END IF  

      AFTER INPUT
         IF NOT cl_null(g_hrcb01) THEN
            IF g_hrcb01 != g_hrcb01_t OR cl_null(g_hrcb01_t) THEN
               SELECT COUNT(UNIQUE hrcb01) INTO g_cnt FROM hrcb_file
                WHERE hrcb01 = g_hrcb01 AND hrcb02 = g_hrcb02 AND hrcb03 = g_hrcb03   #No.FUN-710055
               IF g_cnt > 0 THEN
                  IF p_cmd = 'a' THEN
                     LET g_ss = 'Y'
                  END IF
               ELSE
                  IF p_cmd = 'u' THEN
                     CALL cl_err(g_hrcb01,-239,1)
                     LET g_hrcb01 = g_hrcb01_t
                     NEXT FIELD hrcb01
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_hrcb01,g_errno,1)
                  NEXT FIELD hrcb01
               END IF
            END IF
         END IF
 
      ON ACTION controlp
#         CASE
#            WHEN INFIELD(hrcb01)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_hrcb"
#               LET g_qryparam.arg1 = g_lang
#               LET g_qryparam.default1= g_hrcb01
#               CALL cl_create_qry() RETURNING g_hrcb01
#               NEXT FIELD hrcb01
# 
#            OTHERWISE 
#               EXIT CASE
#         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION modify_program_name
         # 2005/01/04 主程式及特殊需要而定義的元件資料不可設定 wintitle
         LET l_count = 0
         SELECT count(*) INTO l_count FROM zz_file WHERE zz01=g_hrcb01
         IF l_count > 0 OR g_hrcb01='TopMenuGroup' OR g_hrcb01='TopProgGroup' THEN
            CALL cl_err(g_hrcb01,"azz-079",1) 
#         ELSE
#            CALL p_hrcb_wintitle(g_hrcb01,g_hrcb03)
         END IF
 
   END INPUT
END FUNCTION
 
 
FUNCTION ghri042_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrcb01) THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrcb01_t = g_hrcb01
   LET g_hrcb02_t = g_hrcb02
   LET g_hrcb03_t = g_hrcb03    #No.FUN-710055
 
   BEGIN WORK
   OPEN ghri042_lock_u USING g_hrcb01   #No.FUN-710055
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE ghri042_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH ghri042_lock_u INTO g_hrcb_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("hrcb01 LOCK:",SQLCA.sqlcode,1)
      CLOSE ghri042_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL ghri042_i("u")
      IF INT_FLAG THEN
         LET g_hrcb01 = g_hrcb01_t
         LET g_hrcb02 = g_hrcb02_t
         LET g_hrcb03 = g_hrcb03_t       #No.FUN-710055
         DISPLAY g_hrcb01,g_hrcb02,g_hrcb03 TO hrcb01,hrcb02,hrcb03   #No.FUN-710055
         LET INT_FLAG = 0
         CALL cl_err('',9001,1)
         EXIT WHILE
      END IF
      UPDATE hrcb_file SET hrcb01 = g_hrcb01, hrcb02 = g_hrcb02, hrcb03 = g_hrcb03   #No.FUN-710055
       WHERE hrcb01 = g_hrcb01_t
      IF SQLCA.sqlcode THEN
         #CALL cl_err(g_hrcb01,SQLCA.sqlcode,1)  #No.FUN-660081
         CALL cl_err3("upd","hrcb_file",g_hrcb01_t,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION ghri042_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   CALL g_hrcb.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL ghri042_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN ghri042_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_hrcb01 TO NULL
      INITIALIZE g_hrcb02 TO NULL
      INITIALIZE g_hrcb03 TO NULL                 #No.FUN-710055
   ELSE
#     OPEN ghri042_count
#     FETCH ghri042_count INTO g_row_count
      CALL ghri042_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL ghri042_fetch('F')                 #讀出TEMP第一筆並顯示
      CALL i042_b1_fill(g_wc)     
    END IF
END FUNCTION
 
FUNCTION ghri042_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式     #No.FUN-680135 VARCHAR(1) 
            l_abso   LIKE type_file.num10         #絕對的筆數   #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     ghri042_b_curs INTO g_hrcb01,g_hrcb02,g_hrcb03   #No.FUN-710055
      WHEN 'P' FETCH PREVIOUS ghri042_b_curs INTO g_hrcb01,g_hrcb02,g_hrcb03   #No.FUN-710055
      WHEN 'F' FETCH FIRST    ghri042_b_curs INTO g_hrcb01,g_hrcb02,g_hrcb03   #No.FUN-710055
      WHEN 'L' FETCH LAST     ghri042_b_curs INTO g_hrcb01,g_hrcb02,g_hrcb03   #No.FUN-710055
      WHEN '/' 
         IF (NOT g_no_ask) THEN          #No.FUN-6A0080
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
         FETCH ABSOLUTE g_jump ghri042_b_curs INTO g_hrcb01,g_hrcb02,g_hrcb03   #No.FUN-710055
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcb01,SQLCA.sqlcode,0)
      INITIALIZE g_hrcb01 TO NULL  #TQC-6B0105
      INITIALIZE g_hrcb02 TO NULL  #TQC-6B0105
      INITIALIZE g_hrcb03 TO NULL  #TQC-6B0105
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx  
      CALL ghri042_show()
   END IF
END FUNCTION
 
#FUN-4A0088
FUNCTION ghri042_show()                         # 將資料顯示在畫面上
   DISPLAY g_hrcb01,g_hrcb02,g_hrcb03 TO hrcb01,hrcb02,hrcb03  #No.FUN-710055
   CALL ghri042_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION ghri042_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_hrcb   RECORD LIKE hrcb_file.*
   DEFINE   l_hrcb05 LIKE hrcb_file.hrcb05
   DEFINE   l_hrcb06 LIKE hrcb_file.hrcb06
   DEFINE   l_hrcb07 LIKE hrcb_file.hrcb07
   DEFINE   l_sql    STRING
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_hrcb01) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM hrcb_file WHERE hrcb01=g_hrcb01
   IF l_cnt>1 THEN
      CALL cl_err('群组人员多于一笔,不能删除','!',1)
      RETURN
   END IF
   LET l_cnt=0 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
   	   LET l_sql = " SELECT hrcb05,hrcb06,hrcb07  ",
                    "  FROM hrcb_file ",
                    " WHERE hrcb01='",g_hrcb01,"' "
                    
                            
        PREPARE i042_sr_pre FROM l_sql
        DECLARE i042_sr_cs CURSOR FOR i042_sr_pre

        FOREACH i042_sr_cs INTO l_hrcb05,l_hrcb06,l_hrcb07
         UPDATE hrcp_file 
     	    SET hrcp35='N',
     	        hrcp04=' ',
     	        hrcp05=' '
     	  WHERE hrcp02=l_hrcb05
     	    AND hrcp07<>'Y'
     	    AND hrcp03>=l_hrcb06 AND hrcp03<=l_hrcb07
     	  
        END FOREACH 
      DELETE FROM hrcb_file
       WHERE hrcb01 = g_hrcb01   #No.FUN-710055
       
      IF SQLCA.sqlcode THEN
         #CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)  #No.FUN-660081
         CALL cl_err3("del","hrcb_file",g_hrcb01,g_hrcb[l_ac].hrcb04,SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         DELETE FROM gbs_file   #FUN-7B0081
          WHERE hrcb01= g_hrcb01 
         CLEAR FORM
         CALL g_hrcb.clear()
        OPEN ghri042_count
        IF STATUS THEN
           CLOSE ghri042_b_curs
           CLOSE ghri042_count
           COMMIT WORK
           RETURN
        END IF
        FETCH ghri042_count INTO g_row_count
   
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE ghri042_b_curs
         CLOSE ghri042_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN ghri042_b_curs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL ghri042_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL ghri042_fetch('/')
      END IF


      END IF
   END IF
   COMMIT WORK
   CALL i042_b1_fill(g_wc)
END FUNCTION
 
FUNCTION ghri042_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT #No.FUN-680135 SMALLINT 
            l_n             LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_cnt           LIKE type_file.num5,               # FUN-7B0081
            l_gau01         LIKE type_file.num5,               # 檢查重複用        #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否        #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,               # 處理狀態          #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,               #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                #No.FUN-680135 SMALLINT
   DEFINE   l_count         LIKE type_file.num5                #FUN-680135    SMALLINT
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   li_i            LIKE type_file.num5                # 暫存用數值   # No:FUN-BA0116
   DEFINE   lc_target       LIKE gay_file.gay01                # No:FUN-BA0116
   DEFINE   ID              LIKE hrat_file.hratid              # add by hourf 13/06/07 
   DEFINE   l_sql           STRING       #No.FUN-680072CHAR(500) 
   DEFINE   g_count         LIKE type_file.num10               #日期笔数
   DEFINE   g_num           LIKE type_file.num10               #日期笔数
   DEFINE   l_string        STRING
   DEFINE   l_hrcb06        LIKE hrcb_file.hrcb06
   DEFINE   l_hrcb07        LIKE hrcb_file.hrcb07
   DEFINE   l_hrcb07_new    LIKE hrcb_file.hrcb07
   DEFINE   l_sr            LIKE type_file.num10
#   DEFINE l_count      LIKE type_file.num5
   DEFINE l_old_hrcb06 LIKE hrcb_file.hrcb06
   DEFINE l_old_hrcb07 LIKE hrcb_file.hrcb07
   DEFINE l_new_hrcb07 LIKE hrcb_file.hrcb07
   DEFINE l_hratid     LIKE hrat_file.hratid
   
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_hrcb01) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   LET g_forupd_sql= "SELECT  hrcb04,hrcb05,hrcb06,hrcb07 ",
                     "  FROM hrcb_file ",
                        "  WHERE hrcb01 = ? AND  hrcb04 = ?  ",
                     "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE ghri042_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
   INPUT ARRAY g_hrcb WITHOUT DEFAULTS FROM s_hrcb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            SELECT COUNT(*) INTO l_ac FROM hrcb_file WHERE hrcb01=g_hrcb01
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
         
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                                                              
            LET g_before_input_done = TRUE 
            
            LET g_hrcb_t.* = g_hrcb[l_ac].*    #BACKUP
            OPEN ghri042_bcl USING g_hrcb01,g_hrcb[l_ac].hrcb04 #No.FUN-710055        记一下
             IF STATUS THEN
              CALL cl_err("OPEN ghri042_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
              ELSE
#               FETCH ghri042_bcl INTO g_hrcb[l_ac].*
               FETCH ghri042_bcl INTO g_hrcb[l_ac].hrcb04,g_hrcb[l_ac].hrcb05,g_hrcb[l_ac].hrcb06,g_hrcb[l_ac].hrcb07  #No.130606
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FETCH ghri042_bcl:',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE   
         INITIALIZE g_hrcb[l_ac].* TO NULL       #900423
         LET g_hrcb[l_ac].hrcb06=g_today
         LET g_hrcb[l_ac].hrcb07='9999-12-31' 
         LET g_hrcb_t.* = g_hrcb[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrat01
 

         BEFORE FIELD hrat01                        #default 序?  IF g_hrcb[l_ac].hrcb04 IS NULL OR g_hrcb[l_ac].hrcb04 = 0 THEN
          IF g_hrcb[l_ac].hrcb04 IS NULL OR g_hrcb[l_ac].hrcb04 = 0 THEN 
             SELECT max(hrcb04)+1
                INTO g_hrcb[l_ac].hrcb04
                FROM hrcb_file
               WHERE hrcb01 = g_hrcb01
              IF g_hrcb[l_ac].hrcb04 IS NULL THEN
                 LET g_hrcb[l_ac].hrcb04 = 1
              END IF
          END IF
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,1)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         SELECT COUNT(*) INTO l_count FROM hrcb_file WHERE hrcb05=g_hrcb[l_ac].hrcb05 AND hrcb06 >= g_hrcb[l_ac].hrcb06 
         IF l_count > 0 THEN 
            LET ls_msg_o = "生效日期必须大于'",g_hrcb[l_ac].hrcb06,"'"
            CALL cl_err(ls_msg_o,'!',1)
            CANCEL INSERT
         END IF 
         INSERT INTO hrcb_file(hrcb01,hrcb02,hrcb03,hrcb04,hrcb05,hrcb06,hrcb07,hrcbacti,hrcbuser,hrcbdate,hrcbgrup,hrcboriu,hrcborig)
                      VALUES (g_hrcb01,g_hrcb02,g_hrcb03,
                              g_hrcb[l_ac].hrcb04,g_hrcb[l_ac].hrcb05,g_hrcb[l_ac].hrcb06,g_hrcb[l_ac].hrcb07,
                              'Y',g_user,g_today,g_grup,g_user,g_grup)
         UPDATE hrcp_file SET hrcp35 = 'N' WHERE hrcp02 = g_hrcb[l_ac].hrcb05 AND hrcp03 >= g_hrcb[l_ac].hrcb06
         SELECT COUNT(*) INTO l_count FROM hrcb_file WHERE hrcb05=g_hrcb[l_ac].hrcb05 AND hrcb06 < g_hrcb[l_ac].hrcb06
         IF l_count > 0 THEN
            SELECT hrcb06,hrcb07 INTO l_old_hrcb06,l_old_hrcb07 
               FROM (SELECT hrcb06,hrcb07 FROM hrcb_file WHERE hrcb05 = g_hrcb[l_ac].hrcb05 AND hrcb06 < g_hrcb[l_ac].hrcb06 ORDER BY hrcb06 DESC)tt
               WHERE ROWNUM = 1
            SELECT trunc(g_hrcb[l_ac].hrcb06)-1 INTO l_new_hrcb07 FROM dual
            UPDATE hrcb_file SET hrcb07 = l_new_hrcb07
               WHERE hrcb05 = g_hrcb[l_ac].hrcb05 AND hrcb06=l_old_hrcb06 AND hrcb07=l_old_hrcb07
         END IF 
         IF SQLCA.sqlcode THEN
            #CALL cl_err(g_hrcb01,SQLCA.sqlcode,1)  #No.FUN-660081
            CALL cl_err3("ins","hrcb_file",g_hrcb01,g_hrcb[l_ac].hrcb04,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
            ELSE
            MESSAGE 'INSERT O.K'
             LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
            #No.FUN-BA0011 ---start
            LET ls_msg_n = g_hrcb01 CLIPPED,"^A",g_hrcb02 CLIPPED,"^A",
                                g_hrcb03 CLIPPED,"^A",g_hrcb[l_ac].hrcb04 CLIPPED,"^A",
                                g_hrcb[l_ac].hrcb05 CLIPPED
            LET ls_msg_o = ""
            CALL cl_log("ghri042","I",ls_msg_n,ls_msg_o)
            #No.FUN-BA0011 ---end
            END IF
           AFTER FIELD hrat01
            IF NOT cl_null(g_hrcb[l_ac].hrat01) THEN
                 SELECT hratid,hrat02,hrat03,hrat04,hrat05 
                   INTO g_hrcb[l_ac].hrcb05,g_hrcb[l_ac].hrat02,g_hrcb[l_ac].hrat03,g_hrcb[l_ac].hrat04,g_hrcb[l_ac].hrat05
                   FROM hrat_file  
                  WHERE hrat01 = g_hrcb[l_ac].hrat01
                 SELECT hraa12 INTO g_hrcb[l_ac].hrat03_name FROM hraa_file WHERE hraa01=g_hrcb[l_ac].hrat03
                 SELECT hrao02 INTO g_hrcb[l_ac].hrat04_name FROM hrao_file WHERE hrao01=g_hrcb[l_ac].hrat04
                 SELECT hrap06 INTO g_hrcb[l_ac].hrat05_name FROM hrap_file WHERE hrap05=g_hrcb[l_ac].hrat05
#                 DISPLAY BY NAME g_hrcb[l_ac].hrat02,g_hrcb[l_ac].hrat03,g_hrcb[l_ac].hrat04,g_hrcb[l_ac].hrat05
                 IF cl_null(g_hrcb[l_ac].hrcb05) THEN 
                 	CALL cl_err('员工不存在','!',0)
                 	NEXT FIELD hrat01
                 END IF 
               SELECT MAX(hrcb06) INTO  l_hrcb06 FROM hrcb_file WHERE hrcb05 =  g_hrcb[l_ac].hrcb05
               IF NOT cl_null(l_hrcb06) AND g_hrcb[l_ac].hrcb05 != g_hrcb_t.hrcb05 THEN 
                  SELECT MAX(hrcb06)+2 INTO  g_hrcb[l_ac].hrcb06 FROM hrcb_file WHERE hrcb05 =  g_hrcb[l_ac].hrcb05
               END IF             
            END IF
          
          AFTER FIELD hrcb06
             IF NOT cl_null(g_hrcb[l_ac].hrcb06) AND  NOT cl_null(g_hrcb[l_ac].hrcb07)  THEN 
             	IF g_hrcb[l_ac].hrcb06 > g_hrcb[l_ac].hrcb07 THEN
                CALL cl_err('',"ghr-120",1)
                NEXT FIELD hrcb06
              END IF
              LET l_sr=0
              SELECT COUNT(*) INTO l_sr FROM hrcb_file 
              WHERE ((hrcb06>=g_hrcb[l_ac].hrcb06 AND hrcb06<=g_hrcb[l_ac].hrcb07)
                OR  (hrcb07>=g_hrcb[l_ac].hrcb06 AND hrcb07<=g_hrcb[l_ac].hrcb07))
                AND hrcb05 = g_hrcb[l_ac].hrcb05
             #IF p_cmd='a' THEN 
             #  IF l_sr>0 THEN 
             #  	CALL cl_err('区间重复请重新录入','!',1)
             #  	NEXT FIELD hrcb06
             #  END IF
             # ELSE 
             #  IF l_sr>1 THEN 
             # 	CALL cl_err('区间重复请重新录入','!',1)
             # 	NEXT FIELD hrcb06
             # END IF
             #END IF  
             END IF 
               	  
          AFTER FIELD hrcb07
            IF NOT cl_null(g_hrcb[l_ac].hrcb06) AND  NOT cl_null(g_hrcb[l_ac].hrcb07)  THEN 
              IF g_hrcb[l_ac].hrcb06 > g_hrcb[l_ac].hrcb07 THEN
                CALL cl_err('',"ghr-120",1)
                NEXT FIELD hrcb07
              END IF
              LET l_sr=0
              SELECT COUNT(*) INTO l_sr FROM hrcb_file 
              WHERE ((hrcb06>=g_hrcb[l_ac].hrcb06 AND hrcb06<=g_hrcb[l_ac].hrcb07)
               OR  (hrcb07>=g_hrcb[l_ac].hrcb06 AND hrcb07<=g_hrcb[l_ac].hrcb07))
               AND hrcb05 = g_hrcb[l_ac].hrcb05
#             IF p_cmd='a' THEN 
#               IF l_sr>0 THEN 
#               	CALL cl_err('区间重复请重新录入','!',1)
#               	NEXT FIELD hrcb07
#               END IF
#              ELSE 
#               IF l_sr>1 THEN 
#              	CALL cl_err('区间重复请重新录入','!',1)
#              	NEXT FIELD hrcb07
#              END IF
#             END IF  
            END IF 

        ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,1)
            LET INT_FLAG = 0
            LET g_hrcb[l_ac].* = g_hrcb_t.*
            CLOSE ghri042_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF NOT cl_confirm('确定要修改当前记录信息吗？') THEN
            RETURN 
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_hrcb02,-263,1)
            LET g_hrcb[l_ac].* = g_hrcb_t.*
         ELSE
            UPDATE hrcb_file
               SET hrcb04 = g_hrcb[l_ac].hrcb04,
                   hrcb05 = g_hrcb[l_ac].hrcb05,
                   hrcb06 = g_hrcb[l_ac].hrcb06,
                   hrcb07 = g_hrcb[l_ac].hrcb07
             WHERE hrcb01 = g_hrcb01 AND hrcb04 = g_hrcb_t.hrcb04 AND hrcb05 = g_hrcb_t.hrcb05 
             IF g_hrcb_t.hrcb06<g_hrcb[l_ac].hrcb06 AND g_hrcb_t.hrcb07>g_hrcb[l_ac].hrcb07 THEN 
             	  UPDATE hrcp_file 
             	    SET hrcp35='N',
             	        hrcp04=' ',
             	        hrcp05=' '
             	  WHERE hrcp02=g_hrcb_t.hrcb05
             	    AND hrcp07<>'Y'
             	    AND ((hrcp03>=g_hrcb_t.hrcb06 AND hrcp03<=g_hrcb[l_ac].hrcb06)
             	    OR (hrcp03>=g_hrcb[l_ac].hrcb07 AND hrcp03<=g_hrcb_t.hrcb07))
             END IF            
             IF g_hrcb_t.hrcb06>g_hrcb[l_ac].hrcb06 AND g_hrcb_t.hrcb06<g_hrcb[l_ac].hrcb07<g_hrcb_t.hrcb07 THEN 
             	  UPDATE hrcp_file 
             	    SET hrcp35='N',
             	        hrcp04=' ',
             	        hrcp05=' '
             	  WHERE hrcp02=g_hrcb_t.hrcb05
             	    AND hrcp07<>'Y'
             	    AND ((hrcp03>=g_hrcb[l_ac].hrcb06 AND hrcp03<=g_hrcb_t.hrcb06)
             	    OR (hrcp03>=g_hrcb[l_ac].hrcb07 AND hrcp03<=g_hrcb_t.hrcb07))
             END IF     
             IF g_hrcb_t.hrcb06<g_hrcb[l_ac].hrcb06<g_hrcb_t.hrcb07 AND g_hrcb[l_ac].hrcb07>g_hrcb_t.hrcb07 THEN 
             	  UPDATE hrcp_file 
             	    SET hrcp35='N',
             	        hrcp04=' ',
             	        hrcp05=' '
             	  WHERE hrcp02=g_hrcb_t.hrcb05
             	    AND hrcp07<>'Y'
             	    AND ((hrcp03>=g_hrcb[l_ac].hrcb06 AND hrcp03<=g_hrcb_t.hrcb06)
             	    OR (hrcp03>=g_hrcb_t.hrcb07 AND hrcp03<=g_hrcb[l_ac].hrcb07))
             END IF     
             	
             	               
             IF g_hrcb_t.hrcb06<g_hrcb[l_ac].hrcb06 AND g_hrcb_t.hrcb07>g_hrcb[l_ac].hrcb07 AND g_hrcb_t.hrcb05<>g_hrcb[l_ac].hrcb05 THEN 
             	  UPDATE hrcp_file 
             	    SET hrcp35='N',
             	        hrcp04=' ',
             	        hrcp05=' '
             	  WHERE hrcp02=g_hrcb[l_ac].hrcb05
             	    AND hrcp07<>'Y'
             	    AND ((hrcp03>=g_hrcb_t.hrcb06 AND hrcp03<=g_hrcb[l_ac].hrcb06)
             	    OR (hrcp03>=g_hrcb[l_ac].hrcb07 AND hrcp03<=g_hrcb_t.hrcb07))
             END IF            
             IF g_hrcb_t.hrcb06>g_hrcb[l_ac].hrcb06 AND g_hrcb_t.hrcb06<g_hrcb[l_ac].hrcb07<g_hrcb_t.hrcb07 AND g_hrcb_t.hrcb05<>g_hrcb[l_ac].hrcb05 THEN 
             	  UPDATE hrcp_file 
             	    SET hrcp35='N',
             	        hrcp04=' ',
             	        hrcp05=' '
             	  WHERE hrcp02=g_hrcb[l_ac].hrcb05
             	    AND hrcp07<>'Y'
             	    AND ((hrcp03>=g_hrcb[l_ac].hrcb06 AND hrcp03<=g_hrcb_t.hrcb06)
             	    OR (hrcp03>=g_hrcb[l_ac].hrcb07 AND hrcp03<=g_hrcb_t.hrcb07))
             END IF     
             IF g_hrcb_t.hrcb06<g_hrcb[l_ac].hrcb06<g_hrcb_t.hrcb07 AND g_hrcb[l_ac].hrcb07>g_hrcb_t.hrcb07 AND g_hrcb_t.hrcb05<>g_hrcb[l_ac].hrcb05 THEN 
             	  UPDATE hrcp_file 
             	    SET hrcp35='N',
             	        hrcp04=' ',
             	        hrcp05=' '
             	  WHERE hrcp02=g_hrcb[l_ac].hrcb05
             	    AND hrcp07<>'Y'
             	    AND ((hrcp03>=g_hrcb[l_ac].hrcb06 AND hrcp03<=g_hrcb_t.hrcb06)
             	    OR (hrcp03>=g_hrcb_t.hrcb07 AND hrcp03<=g_hrcb[l_ac].hrcb07))
             END IF                                                            
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_hrcb[l_ac].hrcb02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("upd","hrcb_file",g_hrcb01,g_hrcb[l_ac].hrcb04,SQLCA.sqlcode,"","",1)   #No.FUN-660081
               LET g_hrcb[l_ac].* = g_hrcb_t.*
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               LET ls_msg_n = g_hrcb01 CLIPPED,"",g_hrcb02 CLIPPED,"",
                              g_hrcb03 CLIPPED,"",g_hrcb[l_ac].hrcb04 CLIPPED,"^A",
                              g_hrcb[l_ac].hrcb05 CLIPPED,"^A",g_hrcb[l_ac].hrcb06 CLIPPED,"^A",
                              g_hrcb[l_ac].hrcb07 CLIPPED
               LET ls_msg_o = g_hrcb01 CLIPPED,"",g_hrcb02 CLIPPED,"",
                              g_hrcb03 CLIPPED,"",g_hrcb[l_ac].hrcb04 CLIPPED,"^A",
                              g_hrcb[l_ac].hrcb05 CLIPPED,"^A",g_hrcb[l_ac].hrcb06 CLIPPED,"^A",
                              g_hrcb[l_ac].hrcb07 CLIPPED
                CALL cl_log("ghri042","U",ls_msg_n,ls_msg_o)            # MOD-440464
            END IF
         END IF
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_hrcb[l_ac].hrcb04) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            DELETE FROM hrcb_file WHERE hrcb01 = g_hrcb01 AND hrcb04=g_hrcb[l_ac].hrcb04
            IF SQLCA.sqlcode THEN
               #CALL cl_err(g_hrcb02,SQLCA.sqlcode,0)  #No.FUN-660081
               CALL cl_err3("del","hrcb_file",g_hrcb01,g_hrcb[l_ac].hrcb04,SQLCA.sqlcode,"","",1)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            ELSE      #FUN-7B0081
               DELETE FROM hrcb_file
               WHERE hrcb01 = g_hrcb01       
               AND hrcb04=g_hrcb[l_ac].hrcb04
               UPDATE hrcp_file 
             	    SET hrcp35='N',
             	        hrcp04=' ',
             	        hrcp05=' '
             	  WHERE hrcp02=g_hrcb[l_ac].hrcb05
             	    AND hrcp07<>'Y'
             	    AND hrcp03>=g_hrcb[l_ac].hrcb06 
             	    AND hrcp03<=g_hrcb[l_ac].hrcb07
               
            END IF 
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
         #No.FUN-BA0011 ---start
         MESSAGE 'DELETE O.K'
         LET ls_msg_n = g_hrcb01 CLIPPED,"",g_hrcb02 CLIPPED,"",
                              g_hrcb03 CLIPPED,"",g_hrcb[l_ac].hrcb04 CLIPPED,"",
                              g_hrcb[l_ac].hrcb05 CLIPPED,"^A",g_hrcb[l_ac].hrcb06 CLIPPED,"^A",
                              g_hrcb[l_ac].hrcb07 CLIPPED
         LET ls_msg_o = g_hrcb01 CLIPPED,"",g_hrcb02 CLIPPED,"",
                              g_hrcb03 CLIPPED,"",g_hrcb[l_ac].hrcb04 CLIPPED,"",
                              g_hrcb[l_ac].hrcb05 CLIPPED,"^A",g_hrcb[l_ac].hrcb06 CLIPPED,"^A",
                              g_hrcb[l_ac].hrcb07 CLIPPED
         CALL cl_log("ghri042","D",ls_msg_n,ls_msg_o) 
         #No.FUN-BA0011 ---end
      AFTER ROW
         LET l_ac = ARR_CURR()
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,1)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_hrcb[l_ac].* = g_hrcb_t.*
            END IF
            CLOSE ghri042_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE ghri042_bcl
         COMMIT WORK
      ON ACTION controlp
            CASE
              WHEN INFIELD(hrat01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_hrat"
                  LET g_qryparam.default1 = g_hrcb[l_ac].hrat01
                  CALL cl_create_qry() RETURNING g_hrcb[l_ac].hrat01
                  DISPLAY g_hrcb[l_ac].hrat01 TO hrat01
                 NEXT FIELD hrat01 
               OTHERWISE
                  EXIT CASE
            END CASE
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
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------     
 
   END INPUT
 
   CLOSE ghri042_bcl
   COMMIT WORK
END FUNCTION
 
 
 
FUNCTION ghri042_b_fill(p_wc)               #BODY FILL UP
 
   DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)
 
    LET g_sql = "SELECT hrcb04,hrcb05,hrcb06,hrcb07 ",
                 " FROM hrcb_file,hrat_file ",
                " WHERE hrcb01 = '",g_hrcb01 CLIPPED,"' ",
                  " AND ",p_wc CLIPPED,
                  " AND hratid= hrcb05 ",
                " ORDER BY hrcb04"
     
    PREPARE ghri042_prepare2 FROM g_sql           #預備一下
    DECLARE hrcb_curs CURSOR FOR ghri042_prepare2
 
    CALL g_hrcb.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH hrcb_curs INTO g_hrcb[g_cnt].hrcb04,g_hrcb[g_cnt].hrcb05,g_hrcb[g_cnt].hrcb06,g_hrcb[g_cnt].hrcb07   #單身 ARRAY 填充
    LET g_rec_b = g_rec_b + 1      
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
        END IF  
        SELECT hrat01,hrat02,hrat03,hrat04,hrat05 INTO g_hrcb[g_cnt].hrat01, g_hrcb[g_cnt].hrat02,g_hrcb[g_cnt].hrat03,
                                                  g_hrcb[g_cnt].hrat04,g_hrcb[g_cnt].hrat05
             FROM hrat_file
             WHERE hratid = g_hrcb[g_cnt].hrcb05  
        SELECT hraa12 INTO g_hrcb[g_cnt].hrat03_name FROM hraa_file WHERE hraa01=g_hrcb[g_cnt].hrat03
        SELECT hrao02 INTO g_hrcb[g_cnt].hrat04_name FROM hrao_file WHERE hrao01=g_hrcb[g_cnt].hrat04
        SELECT hrap06 INTO g_hrcb[g_cnt].hrat05_name FROM hrap_file WHERE hrap05=g_hrcb[g_cnt].hrat05
     LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_hrcb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION ghri042_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL SET_COUNT(g_rec_b)
   DIALOG ATTRIBUTES(UNBUFFERED)
    DISPLAY ARRAY g_hrcb TO s_hrcb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         #EXIT DISPLAY
         EXIT DIALOG
      ON ACTION nozu                            # 
         LET g_action_choice='nozu'
         #EXIT DISPLAY
         EXIT DIALOG 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         #EXIT DISPLAY
         EXIT DIALOG
 
#      ON ACTION reproduce                        # C.複製
#         LET g_action_choice='reproduce'
#         EXIT DISPLAY
 
     ON ACTION delete                           # R.取消
        LET g_action_choice='delete'
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION first                            # 第一筆
         CALL ghri042_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous                         # P.上筆
         CALL ghri042_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump                             # 指定筆
         CALL ghri042_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION next                             # N.下筆
         CALL ghri042_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last                             # 最終筆
         CALL ghri042_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         #ACCEPT DISPLAY
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
#        CALL ghri042_set_combobox()              #No.FUN-760049
#         CALL cl_set_combo_industry("hrcb03")        #No.FUN-750068
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         # 2004/03/24 新增語言別選項
#         CALL cl_set_combo_lang("hrcb03")                         #Mark by hourf 13/05/22
#         EXIT DISPLAY                      
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION close
         LET g_action_choice='exit'
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         #EXIT DISPLAY
         EXIT DIALOG
 
       ON ACTION showlog             #MOD-440464
         LET g_action_choice = "showlog"
         #EXIT DISPLAY
         EXIT DIALOG
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         #CONTINUE DISPLAY
         CONTINUE DIALOG
      # No.FUN-530067 ---end---
 
#No.FUN-6A0092------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6A0092-----End------------------     
 
    END DISPLAY
    DISPLAY ARRAY g_hrcb_1 TO s_hrcb_1.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont() 
      
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET g_no_ask = TRUE
         LET g_bp_flag = NULL
         CALL ghri042_fetch('/')
         CALL cl_set_comp_visible("Page3", FALSE)
         CALL ui.interface.refresh()                  #NO.FUN-840018 ADD
         CALL cl_set_comp_visible("Page3", TRUE)
         EXIT DIALOG
      
      ON ACTION insert
         LET g_action_choice="insert"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON ACTION query
         LET g_action_choice="query"
         #EXIT DISPLAY
         EXIT DIALOG    
      ON ACTION nozu                            # 
         LET g_action_choice='nozu'
         #EXIT DISPLAY
         EXIT DIALOG       
      ON ACTION modify
         LET g_action_choice="modify"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION help
        LET g_action_choice="help"
        #EXIT DISPLAY
        EXIT DIALOG
        
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         #EXIT DISPLAY
         EXIT DIALOG
         
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG

      ON ACTION close
         LET g_action_choice="exit"
         #EXIT DISPLAY
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         #CONTINUE DISPLAY
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
         
      AFTER DISPLAY
         #CONTINUE DISPLAY
         CONTINUE DIALOG
          
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
    END DISPLAY
   
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION ghri042_copy()
   DEFINE   l_n       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
            l_new01   LIKE hrcb_file.hrcb01,
            l_new02   LIKE hrcb_file.hrcb02,
            l_new03   LIKE hrcb_file.hrcb03,          #No.FUN-710055
            l_old01   LIKE hrcb_file.hrcb01,
            l_old02   LIKE hrcb_file.hrcb02,
            l_old03   LIKE hrcb_file.hrcb03           #No.FUN-710055
 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
 
   IF g_hrcb01 IS NULL THEN
      CALL cl_err('',-400,1)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   #No.FUN-6A0092
   INPUT l_new01,l_new02,l_new03 WITHOUT DEFAULTS FROM hrcb01,hrcb02,hrcb03   #No.FUN-710055
 
      AFTER INPUT
 #MOD-4A0311 add
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
##
         IF cl_null(l_new01) THEN
            NEXT FIELD hrcb01
 #           LET INT_FLAG = 1   #MOD-4A0311  mark
         END IF
#FUN-4C0020
          SELECT COUNT(*) INTO g_cnt FROM hrcb_file
           WHERE hrcb01 = l_new01 AND hrcb02 = l_new02 AND hrcb03 = l_new03   #No.FUN-710055
          IF g_cnt > 0 THEN
             CALL cl_err_msg(NULL,"azz-110",l_new01||"|"||l_new02,10)
#            CALL cl_err(l_new11,-239,0)
#            NEXT FIELD hrcb01
          END IF
#FUN-4C0020(END)
 
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
      DISPLAY g_hrcb01,g_hrcb02,g_hrcb03 TO hrcb01,hrcb02,hrcb03   #No.FUN-710055
      RETURN
   END IF
 
   DROP TABLE x
#FUN-4C0020
   SELECT * FROM hrcb_file 
     WHERE hrcb01=g_hrcb01 and hrcb02=g_hrcb02 and hrcb03=g_hrcb03
   #  and (hrcb02 NOT IN   #No.FUN-710055         #mark by hourf 13/05/22
   #  (SELECT hrcb02 FROM hrcb_file WHERE hrcb01=l_new01 and hrcb02=l_new11 and hrcb03=l_new12)   #No.FUN-710055
   #  or( hrcb02 IN (SELECT hrcb02 FROM hrcb_file WHERE hrcb01=l_new01 and hrcb02=l_new11 and hrcb03=l_new12)  #No.FUN-710055
   #  and hrcb03 NOT IN (SELECT hrcb03 FROM hrcb_file WHERE hrcb01=l_new01 and hrcb02=l_new11 and hrcb03=l_new12))) #No.FUN-710055
   INTO TEMP x
 
#  SELECT * FROM hrcb_file WHERE hrcb01 = g_hrcb01 AND hrcb02 = g_hrcb02
#    INTO TEMP x
 
   IF SQLCA.sqlcode THEN
      #CALL cl_err(g_hrcb01,SQLCA.sqlcode,0)  #No.FUN-660081
      CALL cl_err3("ins","x",g_hrcb01,g_hrcb[l_ac].hrcb04,SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   END IF
 
   UPDATE x
      SET hrcb01 = l_new01,                        # 資料鍵值
          hrcb02 = l_new02,                        # 資料鍵值
          hrcb03 = l_new03                        # No.FUN-710055
 
   INSERT INTO hrcb_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      #CALL cl_err('hrcb:',SQLCA.SQLCODE,1)  #No.FUN-660081
      CALL cl_err3("ins","hrcb_file",l_new01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
      RETURN
   ELSE    #FUN-7B0081
      DROP TABLE x
      SELECT * FROM hrcb_file 
       WHERE hrcb01=g_hrcb01 AND hrcb02=g_hrcb02 AND hrcb03=g_hrcb03 
        INTO TEMP x
      UPDATE x
         SET hrcb01 = l_new01,
             hrcb02 = l_new02,
             hrcb03 = l_new03                       
      INSERT INTO hrcb_file SELECT * FROM x
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_old01 = g_hrcb01
   LET l_old02 = g_hrcb02
   LET l_old03 = g_hrcb03   #No.FUN-710055
   LET g_hrcb01 = l_new01
   LET g_hrcb02 = l_new02
   LET g_hrcb03 = l_new03   #No.FUN-710055
   CALL ghri042_b()
   LET g_hrcb01 = l_old01
   LET g_hrcb02 = l_old02
   LET g_hrcb03 = l_old03   #No.FUN-710055
   CALL ghri042_show()
END FUNCTION
 
#No.FUN-760049 --start--
FUNCTION ghri042_set_combobox()
   DEFINE   lc_smb01    LIKE smb_file.smb01
   DEFINE   lc_smb03    LIKE smb_file.smb03
   DEFINE   ls_value    STRING
   DEFINE   ls_desc     STRING
 
   LET g_sql = "SELECT UNIQUE smb01,smb03 FROM smb_file WHERE smb02='",g_lang CLIPPED,"'"
   PREPARE smb_pre FROM g_sql
   DECLARE smb_curs CURSOR FOR smb_pre
   FOREACH smb_curs INTO lc_smb01,lc_smb03
      IF lc_smb01 = "std" THEN
         LET ls_value = lc_smb01,",",ls_value
         LET ls_desc = lc_smb01,":",lc_smb03,",",ls_desc
      ELSE
         LET ls_value = ls_value,lc_smb01,","
         LET ls_desc = ls_desc,lc_smb01,":",lc_smb03,","
      END IF
   END FOREACH
#   CALL cl_set_combo_items("hrcb03",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
#No.FUN-760049 ---end---
#No.TQC-880038 

FUNCTION i042_b1_fill(p_wc)
DEFINE p_wc     STRING
DEFINE l_sql    STRING
DEFINE l_i      LIKE   type_file.num5

  
        CALL g_hrcb_1.clear()
        
        
        LET l_sql = " SELECT DISTINCT hrcb01,hrcb02  ",
                    "  FROM hrcb_file ",
                    " WHERE ",p_wc CLIPPED,
                    " ORDER BY hrcb01 "
                            
        PREPARE i042_b1_pre FROM l_sql
        DECLARE i042_b1_cs CURSOR FOR i042_b1_pre
        
        LET l_i=1
        
        FOREACH i042_b1_cs INTO g_hrcb_1[l_i].*
                            
           LET l_i=l_i+1
           
           IF l_i > g_max_rec THEN
              IF g_action_choice ="query"  THEN   #CHI-BB0034 add
                 CALL cl_err( '', 9035, 0 )
              END IF                              #CHI-BB0034 add
              EXIT FOREACH
           END IF
        END FOREACH
        CALL g_hrcb_1.deleteElement(l_i)
        LET g_rec_b1 = l_i - 1
END FUNCTION
FUNCTION ghri042_no_fill()
DEFINE l_sql STRING
DEFINE l_i,l_rec_b   LIKE type_file.num5
     OPEN WINDOW i0421_w 
     WITH FORM "ghr/42f/ghri042_1"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN   
    CALL cl_ui_init()
    CALL cl_set_act_visible("accept,cancel", FALSE)
    LET l_sql = " SELECT  hrat01,hrat02,hrao02,hras04,hrad03,hrat25           ", 
                "   FROM  hrcb_file,hrat_file ,hrad_file,hrao_file,hras_file  ",
                "  WHERE  hratid = hrcb05(+)                                  ",
                "    AND  hrcb05 is null                                      ",
                "    AND  hrat19 = hrad02                                     ",
                "    AND  hrad01 !='003'                                      ",
                "    AND  hrao01= hrat04                                      ",
                "    AND  hras01 = hrat05                                     ",
                "   UNION all ",
                " SELECT  hrat01,hrat02,hrao02,hras04,hrad03,hrat25           ",
                "    FROM  hrcb_file,hrat_file ,hrad_file,hrao_file,hras_file  ",
                "   where hratid = hrcb05(+) ",
                "     and hrcb05 is NULL  ",
                "     and hrat19 = hrad02 ",
                "    and hrad01 ='003' ",
                "    AND  hrao01= hrat04                                      ",
                "    AND  hras01 = hrat05                                     ",                
                "    and year(hrat77) = year('",g_today,"') ",
                "    and  month(hrat77) = month('",g_today,"')"

    PREPARE i042_1_q FROM l_sql
    DECLARE i042_1_s CURSOR FOR i042_1_q
    LET l_i=1
    FOREACH i042_1_s INTO g_hrat[l_i].*
       LET l_i=l_i+1
       IF l_i > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )                            
           EXIT FOREACH
       END IF       
    END FOREACH                  
    CALL g_hrat.deleteElement(l_i)
    LET l_rec_b = l_i - 1
    DISPLAY ARRAY g_hrat TO s_hrat1.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
         ON ACTION xx 
            LET w = ui.Window.getCurrent()
            LET f = w.getForm()  
            LET page = f.FindNode("Page","page1")
            CALL cl_export_to_excel(page,base.TypeInfo.create(g_hrat),'','')
    END DISPLAY 
    CLOSE WINDOW i0421_w
END FUNCTION 
