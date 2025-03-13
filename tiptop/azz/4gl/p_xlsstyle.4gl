# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_xlsstyle.4gl 
# Descriptions...: 資料上傳下載Excel設定維護程式
# Date & Author..: 06/05/05 by saki
# Modify.........: No.FUN-660081 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-690132 06/10/03 By kim 加入可供外部呼叫的功能及參數
# Modify.........: No.FUN-6A0080 06/10/23 By Czl g_no_ask改成mi_no_ask
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-860009 08/06/05 By saki 資料處理修正
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.MOD-920039 09/02/27 By Sarah load_from_excel()段組出來insert into的欄位順序和p_xlsstyle中設定的順序不同
# Modify.........: No.MOD-960306 09/06/25 By Dido TEMP TABLE xlsstyle_tmp 須 DROP
# Modify.........: No.MOD-970234 09/07/24 By Dido 增加檢核單身資料格式為 2 時須限制 20 筆提示警告
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷 
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30027 12/08/15 By bart 複製後停在新資料畫面
# Modify.........: No.FUN-CB0047 12/11/12 by zong-yi 匯出匯入excel功能sheet name由寫死Sheet1改為自動抓取
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   g_gcc           RECORD LIKE gcc_file.*,       #簽核等級 (單頭)
         g_gcc_t         RECORD LIKE gcc_file.*,       #簽核等級 (舊值)
         g_gcc01_t       LIKE gcc_file.gcc01,          #簽核等級 (舊值)
         g_gcd           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
             gcd02       LIKE gcd_file.gcd02,          #序號
             gcd03       LIKE gcd_file.gcd03,          #資料格式
             gcd04       LIKE gcd_file.gcd04,          #表格名稱
             gcd05       LIKE gcd_file.gcd05,          #資料內容
             gcd06       LIKE gcd_file.gcd06,          #是否使用條件式
             gcd07       LIKE gcd_file.gcd07,          #GROUP
             gcd08       LIKE gcd_file.gcd08,          #起始位置
             gcd09       LIKE gcd_file.gcd09,          #截止位置
             gcd10       LIKE gcd_file.gcd10           #資料排列
                         END RECORD,
         g_gcd_t         RECORD                        #程式變數 (舊值)
             gcd02       LIKE gcd_file.gcd02,          #序號
             gcd03       LIKE gcd_file.gcd03,          #資料格式
             gcd04       LIKE gcd_file.gcd04,          #表格名稱
             gcd05       LIKE gcd_file.gcd05,          #資料內容
             gcd06       LIKE gcd_file.gcd06,          #是否使用條件式
             gcd07       LIKE gcd_file.gcd07,          #GROUP
             gcd08       LIKE gcd_file.gcd08,          #起始位置
             gcd09       LIKE gcd_file.gcd09,          #截止位置
             gcd10       LIKE gcd_file.gcd10           #資料排列
                         END RECORD,
         g_gcd_o         DYNAMIC ARRAY OF RECORD       #程式變數 (舊值)
             gcd02       LIKE gcd_file.gcd02,          #序號
             gcd03       LIKE gcd_file.gcd03,          #資料格式
             gcd04       LIKE gcd_file.gcd04,          #表格名稱
             gcd05       LIKE gcd_file.gcd05,          #資料內容
             gcd06       LIKE gcd_file.gcd06,          #是否使用條件式
             gcd07       LIKE gcd_file.gcd07,          #GROUP
             gcd08       LIKE gcd_file.gcd08,          #起始位置
             gcd09       LIKE gcd_file.gcd09,          #截止位置
             gcd10       LIKE gcd_file.gcd10           #資料排列
                         END RECORD,
         g_gce           DYNAMIC ARRAY OF RECORD
             gce03       LIKE gce_file.gce03,
             oper_sign   LIKE cre_file.cre08,          #No.FUN-680135 VARCHAR(10)
             value       LIKE type_file.chr50          #No.FUN-680135 VARCHAR(30)
                         END RECORD,
         g_gce_t         RECORD
             gce03       LIKE gce_file.gce03,
             oper_sign   LIKE cre_file.cre08,          #No.FUN-680135 VARCHAR(10)
             value       LIKE type_file.chr50          #No.FUN-680135 VARCHAR(30)
                         END RECORD,
         g_sql           STRING,                       #CURSOR暫存 TQC-5B0183
         g_wc            STRING,                       #單頭CONSTRUCT結果
         g_wc2           STRING,                       #單身CONSTRUCT結果
         g_rec_b         LIKE type_file.num5,          #單身筆數            #No.FUN-680135 SMALLINT
         g_rec_b2        LIKE type_file.num5,          #單身筆數            #No.FUN-680135 SMALLINT
         l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
         l_ac2           LIKE type_file.num5           #目前處理的ARRAY CNT #No.FUN-680135 SMALLINT
 
DEFINE   p_row,p_col         LIKE type_file.num5       #No.FUN-680135 SMALLINT 
DEFINE   g_forupd_sql        STRING                    #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done LIKE type_file.num5       #No.FUN-680135 SMALLINT
DEFINE   g_chr               LIKE type_file.chr1       #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt               LIKE type_file.num10      #No.FUN-680135 INTEGER
DEFINE   g_i                 LIKE type_file.num5       #count/index for any purpose  #No.FUN-680135 SMALLINT
DEFINE   g_msg               LIKE type_file.chr1000    #No.FUN-680135 VARCHAR(72)
DEFINE   g_curs_index        LIKE type_file.num10      #No.FUN-680135 INTEGER
DEFINE   g_row_count         LIKE type_file.num10      #總筆數             #No.FUN-680135 INTEGER
DEFINE   g_jump              LIKE type_file.num10      #查詢指定的筆數     #No.FUN-680135 INTEGER
DEFINE   mi_no_ask           LIKE type_file.num5       #是否開啟指定筆視窗 #No.FUN-680135 SMALLINT  #No.FUN-6A0080
DEFINE   g_argv1             LIKE gcc_file.gcc01       #FUN-690132
 
MAIN
#     DEFINE   l_time  LIKE type_file.chr8                #No.FUN-6A0096
 
 
   OPTIONS
           INPUT NO WRAP
   DEFER INTERRUPT                                     # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
#   CALL cl_used(g_prog, l_time, 1) RETURNING l_time #No.FUN-6A0096
   CALL cl_used(g_prog, g_time, 1) RETURNING g_time #No.FUN-6A0096
   LET g_argv1 =ARG_VAL(1) #FUN-690132
 
   LET g_forupd_sql = "SELECT * FROM gcc_file WHERE gcc01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE xlsstyle_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW xlsstyle_w WITH FORM "azz/42f/p_xlsstyle" 
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   
   IF NOT (cl_null(g_argv1)) THEN #FUN-690132
      CALL xlsstyle_q()
   END IF   
 
   CALL xlsstyle_menu()
 
   CLOSE WINDOW xlsstyle_w
#   CALL cl_used(g_prog, l_time, 2) RETURNING l_time #No.FUN-6A0096
   CALL cl_used(g_prog, g_time, 2) RETURNING g_time #No.FUN-6A0096
END MAIN
 
FUNCTION xlsstyle_cs()
   DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
 
   IF NOT (cl_null(g_argv1)) THEN #FUN-690132
      LET g_wc = " gcc01 = '",g_argv1,"'"
      LET g_wc2=" 1=1"
   ELSE
      CLEAR FORM                             #清除畫面
      CALL g_gcd.clear()
      CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
      CONSTRUCT BY NAME g_wc ON gcc01,gcc02
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      
      IF INT_FLAG THEN
         RETURN
      END IF
      
      CONSTRUCT g_wc2 ON gcd02,gcd03,gcd04,gcd05,gcd06,gcd07,gcd08,gcd09,gcd10
                    FROM s_gcd[1].gcd02,s_gcd[1].gcd03,s_gcd[1].gcd04,
                         s_gcd[1].gcd05,s_gcd[1].gcd06,s_gcd[1].gcd07,
                         s_gcd[1].gcd08,s_gcd[1].gcd09,s_gcd[1].gcd10
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION about
            CALL cl_about()
         ON ACTION help
            CALL cl_show_help()
         ON ACTION controlg
            CALL cl_cmdask()
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  gcc01 FROM gcc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY gcc01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  gcc01 ",
                  "  FROM gcc_file, gcd_file ",
                  " WHERE gcc01 = gcd01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY gcc01"
   END IF
  
   PREPARE xlsstyle_prepare FROM g_sql
   DECLARE xlsstyle_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR xlsstyle_prepare
  
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM gcc_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT gcc01) FROM gcc_file,gcd_file WHERE ",
                "gcd01=gcc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE xlsstyle_precount FROM g_sql
   DECLARE xlsstyle_count CURSOR FOR xlsstyle_precount
END FUNCTION
 
FUNCTION xlsstyle_menu()
   WHILE TRUE
      CALL xlsstyle_bp()
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_u()
            END IF
         WHEN "operational_setting"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_operational_setting()
            END IF
         WHEN "change_location"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_change_location()
            END IF
         WHEN "unload_to_excel"
            IF cl_chk_act_auth() THEN
               CALL unload_to_excel()
            END IF
         WHEN "load_from_excel"
            IF cl_chk_act_auth() THEN
               CALL load_from_excel()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL xlsstyle_b()
            END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL xlsstyle_out()
#           END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gcd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION xlsstyle_bp()

   #FUN-D30034---add---str 
   IF g_action_choice = "detail" THEN
      RETURN
   END IF
   #FUN-D30034---add---end

   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gcd TO s_gcd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION operational_setting
         LET g_action_choice="operational_setting"
         EXIT DISPLAY
 
      ON ACTION change_location
         LET g_action_choice="change_location"
         EXIT DISPLAY
 
      ON ACTION unload_to_excel
         LET g_action_choice="unload_to_excel"
         EXIT DISPLAY
 
      ON ACTION load_from_excel
         LET g_action_choice="load_from_excel"
         EXIT DISPLAY
 
      ON ACTION first
         CALL xlsstyle_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL xlsstyle_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL xlsstyle_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL xlsstyle_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL xlsstyle_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION xlsstyle_q()
   LET l_ac = 0
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_gcd.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL xlsstyle_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_gcc.* TO NULL
      RETURN
   END IF
 
   OPEN xlsstyle_cs                             # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_gcc.* TO NULL
   ELSE
      OPEN xlsstyle_count
      FETCH xlsstyle_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL xlsstyle_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION xlsstyle_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1        #No.FUN-680135 VARCHAR(1) 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     xlsstyle_cs INTO g_gcc.gcc01
      WHEN 'P' FETCH PREVIOUS xlsstyle_cs INTO g_gcc.gcc01
      WHEN 'F' FETCH FIRST    xlsstyle_cs INTO g_gcc.gcc01
      WHEN 'L' FETCH LAST     xlsstyle_cs INTO g_gcc.gcc01
      WHEN '/'
            IF (NOT mi_no_ask) THEN           #No.FUN-6A0080
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump xlsstyle_cs INTO g_gcc.gcc01
            LET mi_no_ask = FALSE               #No.FUN-6A0080
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gcc.gcc01,SQLCA.sqlcode,0)
      INITIALIZE g_gcc.* TO NULL  #TQC-6B0105
      LET g_gcc.gcc01 = NULL      #TQC-6B0105
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
 
   SELECT * INTO g_gcc.* FROM gcc_file WHERE gcc01 = g_gcc.gcc01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_gcc.gcc01,SQLCA.sqlcode,0)   #No.FUN-660081
      CALL cl_err3("sel","gcc_file",g_gcc.gcc01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      INITIALIZE g_gcc.* TO NULL
      RETURN
   END IF
 
   CALL xlsstyle_show()
END FUNCTION
 
FUNCTION xlsstyle_show()
   LET g_gcc_t.* = g_gcc.*                #保存單頭舊值
   DISPLAY BY NAME g_gcc.gcc01,g_gcc.gcc02
 
   CALL xlsstyle_b_fill(g_wc2)            #單身
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION xlsstyle_b_fill(p_wc2)
   DEFINE    p_wc2   STRING
 
   LET g_sql = "SELECT gcd02,gcd03,gcd04,gcd05,gcd06,gcd07,gcd08,gcd09,gcd10",
               "  FROM gcd_file",
               " WHERE gcd01 ='",g_gcc.gcc01,"' "
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY gcd02"
 
   PREPARE gcd_pb FROM g_sql
   DECLARE gcd_cs CURSOR FOR gcd_pb
 
   CALL g_gcd.clear()
   LET g_cnt = 1
 
   FOREACH gcd_cs INTO g_gcd[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_gcd.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION xlsstyle_a()
   DEFINE   li_result   LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10   #No.FUN-680135 INTEGER
 
   MESSAGE ""
   CLEAR FORM
   CALL g_gcd.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_gcc.* LIKE gcc_file.*             #DEFAULT 設定
   LET g_gcc01_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_gcc_t.* = g_gcc.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL xlsstyle_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_gcc.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_gcc.gcc01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO gcc_file VALUES (g_gcc.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#        CALL cl_err(g_gcc.gcc01,SQLCA.sqlcode,1)   #No.FUN-660081
         CALL cl_err3("ins","gcc_file",g_gcc.gcc01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660081
         CONTINUE WHILE
      END IF
 
      SELECT gcc01 INTO g_gcc.gcc01 FROM gcc_file
       WHERE gcc01 = g_gcc.gcc01
      LET g_gcc01_t = g_gcc.gcc01        #保留舊值
      LET g_gcc_t.* = g_gcc.*
      CALL g_gcd.clear()
 
      LET g_rec_b = 0
      DISPLAY g_rec_b TO FORMONLY.cn2
      CALL xlsstyle_b()                   #輸入單身
      #可增加檢查ORDER BY所輸入的欄位是否存在單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION xlsstyle_u()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_gcc.gcc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_gcc.* FROM gcc_file
    WHERE gcc01=g_gcc.gcc01
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_gcc01_t = g_gcc.gcc01
 
   BEGIN WORK
   OPEN xlsstyle_cl USING g_gcc.gcc01
   IF STATUS THEN
      CALL cl_err("OPEN xlsstyle_cl:", STATUS, 1)
      CLOSE xlsstyle_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH xlsstyle_cl INTO g_gcc.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gcc.gcc01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE xlsstyle_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL xlsstyle_show()
 
   WHILE TRUE
      LET g_gcc01_t = g_gcc.gcc01
 
      CALL xlsstyle_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gcc.*=g_gcc_t.*
         CALL xlsstyle_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_gcc.gcc01 != g_gcc01_t THEN            # 更改單號
         UPDATE gcd_file SET gcd01 = g_gcc.gcc01
          WHERE gcd01 = g_gcc01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#           CALL cl_err('gcd',SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("upd","gcd_file",g_gcc01_t,"",SQLCA.sqlcode,"","gcd",0)   #No.FUN-660081
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE gcc_file SET gcc_file.* = g_gcc.*
       WHERE gcc01 = g_gcc.gcc01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err(g_gcc.gcc01,SQLCA.sqlcode,0)   #No.FUN-660081
         CALL cl_err3("upd","gcc_file",g_gcc01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE xlsstyle_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION xlsstyle_i(p_cmd)
   DEFINE   l_n         LIKE type_file.num5,     #No.FUN-680135 SMALLINT
            p_cmd       LIKE type_file.chr1      #a:輸入 u:更改 #No.FUN-680135 VARCHAR(1)
   DEFINE   li_result   LIKE type_file.num5      #No.FUN-680135 SMALLINT
 
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT BY NAME g_gcc.gcc01,g_gcc.gcc02 WITHOUT DEFAULTS
 
      AFTER FIELD gcc01
         IF NOT cl_null(g_gcc.gcc01) THEN
            IF g_gcc.gcc01 != g_gcc01_t OR g_gcc01_t IS NULL THEN
               SELECT count(*) INTO l_n FROM gcc_file
                WHERE gcc01 = g_gcc.gcc01
               IF l_n > 0 THEN   #編號重複
                  CALL cl_err(g_gcc.gcc01,-239,0)
                  LET g_gcc.gcc01 = g_gcc01_t
                  DISPLAY BY NAME g_gcc.gcc01
                  NEXT FIELD gcc01
               END IF
            END IF
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gcc02) #Order By順序
               CALL GET_FLDBUF(gcc02) RETURNING g_gcc.gcc02
               CALL xlsstyle_orderby(g_gcc.gcc02) RETURNING g_gcc.gcc02
               NEXT FIELD gcc02
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
   END INPUT
END FUNCTION
 
FUNCTION xlsstyle_b()
   DEFINE   l_n             LIKE type_file.num5,                #檢查重複用      #No.FUN-680135 SMALLINT
            l_cnt           LIKE type_file.num5,                #檢查重複用      #No.FUN-680135 SMALLINT
            l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680135 SMALLINT
   DEFINE   li_i            LIKE type_file.num5                 #No.FUN-680135   SMALLINT
   DEFINE   l_ac_t          LIKE type_file.num5   #FUN-D30034 Add
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_gcc.gcc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_gcc.* FROM gcc_file
    WHERE gcc01=g_gcc.gcc01
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT gcd02,gcd03,gcd04,gcd05,gcd06,gcd07,gcd08,gcd09,gcd10 ",
                      "  FROM gcd_file",
                      " WHERE gcd01=? AND gcd02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE xlsstyle_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_gcd WITHOUT DEFAULTS FROM s_gcd.*
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
 
         BEGIN WORK
 
         OPEN xlsstyle_cl USING g_gcc.gcc01
         IF STATUS THEN
            CALL cl_err("OPEN xlsstyle_cl:", STATUS, 1)
            CLOSE xlsstyle_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH xlsstyle_cl INTO g_gcc.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_gcc.gcc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE xlsstyle_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_gcd_t.* = g_gcd[l_ac].*  #BACKUP
            OPEN xlsstyle_bcl USING g_gcc.gcc01,g_gcd_t.gcd02
            IF STATUS THEN
               CALL cl_err("OPEN xlsstyle_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH xlsstyle_bcl INTO g_gcd[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gcd_t.gcd02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
           #-MOD-970234-add-
            LET g_sql = "SELECT COUNT(*) ",
                        "  FROM gcd_file",
                        " WHERE gcd01 ='",g_gcc.gcc01,"' AND gcd03 = '2' "
            PREPARE gcd_pb2 FROM g_sql
            DECLARE gcd_cs2 CURSOR FOR gcd_pb2
               OPEN gcd_cs2
              FETCH gcd_cs2 INTO l_cnt
           #-MOD-970234-add-
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gcd[l_ac].* TO NULL      #900423
         LET g_gcd[l_ac].gcd03 = "1"           #Body default
         LET g_gcd[l_ac].gcd06 = "N"           #Body default
         LET g_gcd[l_ac].gcd07 = "N"           #Body default
         LET g_gcd[l_ac].gcd10 = "1"           #Body default
         LET g_gcd_t.* = g_gcd[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD gcd02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO gcd_file(gcd01,gcd02,gcd03,gcd04,gcd05,gcd06,
                              gcd07,gcd08,gcd09,gcd10)
                       VALUES(g_gcc.gcc01,g_gcd[l_ac].gcd02,
                              g_gcd[l_ac].gcd03,g_gcd[l_ac].gcd04,
                              g_gcd[l_ac].gcd05,g_gcd[l_ac].gcd06,
                              g_gcd[l_ac].gcd07,g_gcd[l_ac].gcd08,
                              g_gcd[l_ac].gcd09,g_gcd[l_ac].gcd10)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_gcd[l_ac].gcd02,SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("ins","gcd_file",g_gcc.gcc01,g_gcd[l_ac].gcd02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD gcd02                       #default 序號
         IF g_gcd[l_ac].gcd02 IS NULL OR g_gcd[l_ac].gcd02 = 0 THEN
            SELECT max(gcd02)+1 INTO g_gcd[l_ac].gcd02
              FROM gcd_file WHERE gcd01 = g_gcc.gcc01
            IF g_gcd[l_ac].gcd02 IS NULL THEN
               LET g_gcd[l_ac].gcd02 = 1
            END IF
         END IF
 
      AFTER FIELD gcd02                        #check 序號是否重複
         IF NOT cl_null(g_gcd[l_ac].gcd02) THEN
            IF (g_gcd[l_ac].gcd02 != g_gcd_t.gcd02) OR (g_gcd_t.gcd02 IS NULL) THEN
               SELECT COUNT(*) INTO l_n FROM gcd_file
                WHERE gcd01 = g_gcc.gcc01 AND gcd02 = g_gcd[l_ac].gcd02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gcd[l_ac].gcd02 = g_gcd_t.gcd02
                  NEXT FIELD gcd02
               END IF
            END IF
         END IF
 
     #-MOD-970234-add
      AFTER FIELD gcd03                        
        IF g_gcd[l_ac].gcd03 = '2' THEN
           LET l_cnt = l_cnt + 1
           IF l_cnt >= 20 THEN
              CALL cl_err('','azz-150',1)
              NEXT FIELD gcd03
           END IF           
        END IF
     #-MOD-970234-add
 
      AFTER FIELD gcd04
         IF NOT cl_null(g_gcd[l_ac].gcd04) THEN
            #SELECT COUNT(*) INTO l_n FROM gat_file WHERE gat01=g_gcd[l_ac].gcd04    #No.FUN-A70082 mark
            SELECT COUNT(*) INTO l_n FROM zta_file WHERE zta01=g_gcd[l_ac].gcd04 AND zta02 = 'ds'    #No.FUN-A70082
            IF l_n <= 0 THEN
               CALL cl_err(g_gcd[l_ac].gcd04,"!",0)
               NEXT FIELD gcd04
            END IF
         END IF
 
      AFTER FIELD gcd07
         IF NOT cl_null(g_gcd[l_ac].gcd07) AND (g_gcd[l_ac].gcd07 = "Y") THEN
            SELECT COUNT(*) INTO l_n FROM gcd_file
             WHERE gcd01=g_gcc.gcc01 AND gcd02<>g_gcd[l_ac].gcd02 AND gcd07="Y"
            IF l_n > 0 THEN
               CALL cl_err(g_gcd[l_ac].gcd04,"!",0)
               NEXT FIELD gcd07
            END IF
         END IF
 
      BEFORE DELETE                      #是否取消單身
         IF g_gcd_t.gcd02 > 0 AND g_gcd_t.gcd02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gcd_file
             WHERE gcd01 = g_gcc.gcc01
               AND gcd02 = g_gcd_t.gcd02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gcd_t.gcd02,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("del","gcd_file",g_gcc.gcc01,g_gcd_t.gcd02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            ELSE
               DELETE FROM gce_file
                WHERE gce01 = g_gcc.gcc01 AND gce02 = g_gcd_t.gcd02
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gcd[l_ac].* = g_gcd_t.*
            CLOSE xlsstyle_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gcd[l_ac].gcd02,-263,1)
            LET g_gcd[l_ac].* = g_gcd_t.*
         ELSE
            UPDATE gcd_file SET gcd02=g_gcd[l_ac].gcd02,
                                gcd03=g_gcd[l_ac].gcd03,
                                gcd04=g_gcd[l_ac].gcd04,
                                gcd05=g_gcd[l_ac].gcd05,
                                gcd06=g_gcd[l_ac].gcd06,
                                gcd07=g_gcd[l_ac].gcd07,
                                gcd08=g_gcd[l_ac].gcd08,
                                gcd09=g_gcd[l_ac].gcd09,
                                gcd10=g_gcd[l_ac].gcd10
             WHERE gcd01=g_gcc.gcc01
               AND gcd02=g_gcd_t.gcd02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err(g_gcd[l_ac].gcd02,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("upd","gcd_file",g_gcc.gcc01,g_gcd_t.gcd02,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gcd[l_ac].* = g_gcd_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_gcd[l_ac].* = g_gcd_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_gcd.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end--
            END IF
            CLOSE xlsstyle_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac    #FUN-D30034 Add 
         CLOSE xlsstyle_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(gcd02) AND l_ac > 1 THEN
            LET g_gcd[l_ac].* = g_gcd[l_ac-1].*
            LET g_gcd[l_ac].gcd02 = g_rec_b + 1
            NEXT FIELD gcd02
         END IF
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gcd04)   #表格代碼
               IF g_gcd[l_ac].gcd03 = "2" THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gat"
                  LET g_qryparam.default1= g_gcd[l_ac].gcd04
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_gcd[l_ac].gcd04
                  DISPLAY BY NAME g_gcd[l_ac].gcd04
                  NEXT FIELD gcd04
               END IF
            WHEN INFIELD(gcd05)   #欄位代碼
               IF g_gcd[l_ac].gcd03 = "2" THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaq"
                  LET g_qryparam.default1= g_gcd[l_ac].gcd05
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  LET g_qryparam.arg2 = g_gcd[l_ac].gcd04
                  LET g_qryparam.arg2 = g_qryparam.arg2.subString(1,g_qryparam.arg2.getIndexOf("_file",1)-1)
                  CALL cl_create_qry() RETURNING g_gcd[l_ac].gcd05
                  DISPLAY BY NAME g_gcd[l_ac].gcd05
                  NEXT FIELD gcd05
               END IF
            OTHERWISE EXIT CASE
         END CASE
 
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
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
   END INPUT
 
   CLOSE xlsstyle_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION xlsstyle_orderby(pc_default)
   DEFINE   pc_default  LIKE gcc_file.gcc02
   DEFINE   lr_order    ARRAY[5] OF LIKE gaq_file.gaq01
   DEFINE   lst_flds    base.StringTokenizer
   DEFINE   ls_fld_name STRING
   DEFINE   li_i        LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_cnt      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_str      STRING
   DEFINE   lc_result   LIKE gcc_file.gcc02
 
 
   LET li_i = 1
   LET lst_flds = base.StringTokenizer.create(pc_default,",")
   WHILE lst_flds.hasMoreTokens()
      LET ls_fld_name = lst_flds.nextToken()
      LET ls_fld_name = ls_fld_name.trim()
      LET lr_order[li_i] = ls_fld_name
      LET li_i = li_i + 1
   END WHILE
 
   OPEN WINDOW xlsstyle_orderby_w WITH FORM "azz/42f/p_xlsstyle_orderby"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("p_xlsstyle_orderby")
 
   INPUT ARRAY lr_order WITHOUT DEFAULTS FROM s_order.*
      ATTRIBUTE(COUNT=5,MAXCOUNT=5,UNBUFFERED,
                INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
      BEFORE ROW
         LET li_i = ARR_CURR()
 
      AFTER FIELD gaq01
         IF NOT cl_null(lr_order[li_i]) THEN
            SELECT COUNT(*) INTO li_cnt FROM gaq_file WHERE gaq01=lr_order[li_i]
            IF li_cnt <= 0 THEN
               NEXT FIELD gaq01
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(gaq01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gaq"
               LET g_qryparam.arg1 = g_lang CLIPPED
               LET g_qryparam.default1 = lr_order[li_i]
               CALL cl_create_qry() RETURNING lr_order[li_i]
               NEXT FIELD gaq01
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
      LET INT_FLAG = FALSE
      LET lc_result = pc_default
   ELSE
      LET ls_str = ""
      FOR li_i = 1 TO 5
          IF NOT cl_null(lr_order[li_i]) THEN
             LET ls_str = ls_str,lr_order[li_i],","
          END IF
      END FOR
      LET ls_str = ls_str.subString(1,ls_str.getLength()-1)
      LET lc_result = ls_str
   END IF
   CLOSE WINDOW xlsstyle_orderby_w
 
   RETURN lc_result
END FUNCTION
 
FUNCTION xlsstyle_operational_setting()
   DEFINE   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      #No.FUN-680135 VARCHAR(1)
            p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680135 VARCHAR(1)
            l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680135 SMALLINT
            l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680135 SMALLINT
   DEFINE   lc_gce04        LIKE gce_file.gce04
   DEFINE   l_ac2_t         LIKE type_file.num5    #FUN-D30034 Add     
 
 
   IF cl_null(g_gcd[l_ac].gcd06) OR g_gcd[l_ac].gcd06 = "N" THEN
      RETURN
   END IF
   CALL xlsstyle_operational_b_fill()
   
   LET g_forupd_sql = "SELECT gce03,'','' FROM gce_file",
                      " WHERE gce01=? AND gce02=? AND gce03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE xlsstyle2_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   OPEN WINDOW xlsstyle_operational_w WITH FORM "azz/42f/p_xlsstyle_oper"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("p_xlsstyle_oper")
 
   DISPLAY ARRAY g_gce TO s_gce.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   INPUT ARRAY g_gce WITHOUT DEFAULTS FROM s_gce.*
      ATTRIBUTE(COUNT=5,MAXCOUNT=5,UNBUFFERED,
                INSERT ROW=TRUE,DELETE ROW=TRUE,APPEND ROW=TRUE)
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
 
         BEGIN WORK
 
         IF g_rec_b2 >= l_ac2 THEN
            LET p_cmd='u'
            LET g_gce_t.* = g_gce[l_ac2].*  #BACKUP
            OPEN xlsstyle2_bcl USING g_gcc.gcc01,g_gcd[l_ac].gcd02,g_gce_t.gce03
            IF STATUS THEN
               CALL cl_err("OPEN xlsstyle2_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH xlsstyle2_bcl INTO g_gce[l_ac2].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gce_t.gce03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL xlsstyle_gce04(g_gce[l_ac2].gce03) RETURNING g_gce[l_ac2].oper_sign,g_gce[l_ac2].value
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET p_cmd='a'
         INITIALIZE g_gce[l_ac2].* TO NULL      #900423
         LET g_gce[l_ac2].oper_sign = "="       #Body default
         LET g_gce_t.* = g_gce[l_ac2].*         #新輸入資料
         CALL cl_show_fld_cont()
         NEXT FIELD gce03
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         LET lc_gce04 = g_gce[l_ac2].oper_sign,g_gce[l_ac2].value
         INSERT INTO gce_file(gce01,gce02,gce03,gce04)
                       VALUES(g_gcc.gcc01,g_gcd[l_ac].gcd02,
                              g_gce[l_ac2].gce03,lc_gce04)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_gce[l_ac2].gce03,SQLCA.sqlcode,0)   #No.FUN-660081
            CALL cl_err3("ins","gce_file",g_gcc.gcc01,g_gce[l_ac2].gce03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b2=g_rec_b2+1
         END IF
 
      BEFORE DELETE                      #是否取消單身
         IF g_gce_t.gce03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gce_file
             WHERE gce01 = g_gcc.gcc01
               AND gce02 = g_gcd[l_ac].gcd02
               AND gce03 = g_gce[l_ac2].gce03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_gce_t.gce03,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("del","gce_file",g_gcc.gcc01,g_gce_t.gce03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b2=g_rec_b2-1
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gce[l_ac2].* = g_gce_t.*
            CLOSE xlsstyle2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gce[l_ac2].gce03,-263,1)
            LET g_gcd[l_ac2].* = g_gcd_t.*
         ELSE
            LET lc_gce04 = g_gce[l_ac2].oper_sign,g_gce[l_ac2].value
            UPDATE gce_file SET gce03=g_gce[l_ac2].gce03,
                                gce04=lc_gce04
             WHERE gce01=g_gcc.gcc01 AND gce02=g_gcd[l_ac].gcd02
               AND gce03=g_gce_t.gce03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              CALL cl_err(g_gce[l_ac2].gce03,SQLCA.sqlcode,0)   #No.FUN-660081
               CALL cl_err3("upd","gce_file",g_gcc.gcc01,g_gce_t.gce03,SQLCA.sqlcode,"","",0)   #No.FUN-660081
               LET g_gce[l_ac2].* = g_gce_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac2 = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_gce[l_ac2].* = g_gce_t.*
            #FUN-D30034--add--str--
            ELSE
               CALL g_gce.deleteElement(l_ac2)
            #FUN-D30034--add--end--
            END IF
            CLOSE xlsstyle2_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac2_t = l_ac2   #FUN-D30034 Add
         CLOSE xlsstyle2_bcl
         COMMIT WORK
 
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
      LET INT_FLAG = FALSE
   END IF
   CLOSE WINDOW xlsstyle_operational_w
END FUNCTION
 
FUNCTION xlsstyle_operational_b_fill()
 
   LET g_sql = "SELECT gce03,'','' FROM gce_file",
               " WHERE gce01 ='",g_gcc.gcc01,"' AND gce02 = '",g_gcd[l_ac].gcd02,"'"
 
   PREPARE gce_pb FROM g_sql
   DECLARE gce_cs CURSOR FOR gce_pb
 
   CALL g_gce.clear()
   LET g_cnt = 1
 
   FOREACH gce_cs INTO g_gce[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL xlsstyle_gce04(g_gce[g_cnt].gce03) RETURNING g_gce[g_cnt].oper_sign,g_gce[g_cnt].value
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_gce.deleteElement(g_cnt)
 
   LET g_rec_b2=g_cnt-1
   LET g_cnt = 0
END FUNCTION
 
FUNCTION xlsstyle_gce04(pc_gce03)
   DEFINE   pc_gce03      LIKE gce_file.gce03
   DEFINE   lc_gce04      LIKE gce_file.gce04
   DEFINE   ls_gce04      STRING
   DEFINE   lc_oper_sign  LIKE cre_file.cre08,   #No.FUN-680135 VARCHAR(10)
            lc_value      LIKE type_file.chr50   #No.FUN-680135 VARCHAR(30)
 
   SELECT gce04 INTO lc_gce04 FROM gce_file
    WHERE gce01=g_gcc.gcc01 AND gce02=g_gcd[l_ac].gcd02 AND gce03=pc_gce03
   LET ls_gce04 = lc_gce04
   CASE
      WHEN ls_gce04.subString(1,2)="<>"
         LET lc_oper_sign=ls_gce04.subString(1,2)
         LET lc_value=ls_gce04.subString(3,ls_gce04.getLength())
      WHEN ls_gce04.subString(1,1)="=" OR ls_gce04.subString(1,1)=">" OR
           ls_gce04.subString(1,1)="<"
         LET lc_oper_sign=ls_gce04.subString(1,1)
         LET lc_value=ls_gce04.subString(2,ls_gce04.getLength())
   END CASE
 
   RETURN lc_oper_sign,lc_value
END FUNCTION
 
FUNCTION xlsstyle_r()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_gcc.gcc01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN xlsstyle_cl USING g_gcc.gcc01
   IF STATUS THEN
      CALL cl_err("OPEN xlsstyle_cl:", STATUS, 1)
      CLOSE xlsstyle_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH xlsstyle_cl INTO g_gcc.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gcc.gcc01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL xlsstyle_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM gcc_file WHERE gcc01 = g_gcc.gcc01
      DELETE FROM gcd_file WHERE gcd01 = g_gcc.gcc01
      DELETE FROM gce_file WHERE gce01 = g_gcc.gcc01
      CLEAR FORM
      CALL g_gcd.clear()
      OPEN xlsstyle_count
#FUN-B50065------begin---
      IF STATUS THEN
         CLOSE xlsstyle_count
         CLOSE xlsstyle_cl
         COMMIT WORK
         RETURN
      END IF
#FUN-B50065------end------
      FETCH xlsstyle_count INTO g_row_count
#FUN-B50065------begin---
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE xlsstyle_count
         CLOSE xlsstyle_cl
         COMMIT WORK
         RETURN
      END IF
#FUN-B50065------end------
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN xlsstyle_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL xlsstyle_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE          #No.FUN-6A0080
         CALL xlsstyle_fetch('/')
      END IF
   END IF
 
   CLOSE xlsstyle_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION xlsstyle_copy()
   DEFINE   l_newno         LIKE gcc_file.gcc01,
            l_oldno         LIKE gcc_file.gcc01
   DEFINE   l_n             LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   IF g_gcc.gcc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INPUT l_newno FROM gcc01
      AFTER FIELD gcc01
         IF NOT cl_null(l_newno) THEN
            SELECT count(*) INTO l_n FROM gcc_file
             WHERE gcc01 = l_newno
            IF l_n > 0 THEN   #編號重複
               CALL cl_err(l_newno,-239,0)
               LET l_newno = g_gcc.gcc01
               DISPLAY l_newno TO gcc01
               NEXT FIELD gcc01
            END IF
         END IF
 
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
      DISPLAY BY NAME g_gcc.gcc01
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM gcc_file         #單頭複製
    WHERE gcc01=g_gcc.gcc01
     INTO TEMP y
 
   UPDATE y
      SET gcc01=l_newno     #新的鍵值
 
   INSERT INTO gcc_file
       SELECT * FROM y
   IF SQLCA.sqlcode THEN
#     CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660081
      CALL cl_err3("ins","gcc_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM gcd_file         #單身複製
    WHERE gcd01=g_gcc.gcc01
     INTO TEMP x
 
   UPDATE x
      SET gcd01=l_newno
 
   INSERT INTO gcd_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
#     CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660081
      CALL cl_err3("ins","gcd_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
 
   DROP TABLE z
 
   SELECT * FROM gce_file         #副單身複製
    WHERE gce01=g_gcc.gcc01
     INTO TEMP z
 
   UPDATE z
      SET gce01=l_newno
 
   INSERT INTO gce_file
       SELECT * FROM z
   IF SQLCA.sqlcode THEN
#     CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660081
      CALL cl_err3("ins","gce_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660081
      RETURN
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_gcc.gcc01
   SELECT gcc01 INTO g_gcc.gcc01 FROM gcc_file WHERE gcc01 = l_newno
   CALL xlsstyle_u()
   CALL xlsstyle_b()
   #SELECT gcc01 INTO g_gcc.gcc01 FROM gcc_file WHERE gcc01 = l_oldno  #FUN-C30027
   #CALL xlsstyle_show()  #FUN-C30027
END FUNCTION
 
FUNCTION xlsstyle_change_location()
   DEFINE   lc_loc1    LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
   DEFINE   lc_loc2    LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
   DEFINE   li_num1    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_num2    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_loc_old STRING
   DEFINE   ls_loc_new STRING
   DEFINE   ls_str     STRING
   DEFINE   li_i       LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_result  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   IF g_gcc.gcc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   OPEN WINDOW location_w WITH FORM "azz/42f/p_xlsstyle_location"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_locale("p_xlsstyle_location")
 
   INPUT lc_loc1,li_num1,lc_loc2,li_num2 WITHOUT DEFAULTS
    FROM FORMONLY.loc1,FORMONLY.num1,FORMONLY.loc2,FORMONLY.num2
 
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
      LET INT_FLAG = FALSE
      CLOSE WINDOW location_w
      RETURN
   END IF
   CLOSE WINDOW location_w
 
   LET ls_str = li_num1
   LET ls_loc_old = lc_loc1,ls_str.trim()
   LET ls_str = li_num2
   LET ls_loc_new = lc_loc2,ls_str.trim()
 
   LET g_gcd_o.* = g_gcd.*
 
   BEGIN WORK
   LET li_result = TRUE
   FOR li_i = 1 TO g_gcd.getLength()
       LET ls_str = g_gcd[li_i].gcd08
       IF ls_str.getIndexOf(ls_loc_old,1) > 0 THEN
          LET ls_str = cl_replace_str(ls_str,ls_loc_old,ls_loc_new)
          LET g_gcd[li_i].gcd08 = ls_str
       END IF
       LET ls_str = g_gcd[li_i].gcd09
       IF ls_str.getIndexOf(ls_loc_old,1) > 0 THEN
          LET ls_str = cl_replace_str(ls_str,ls_loc_old,ls_loc_new)
          LET g_gcd[li_i].gcd09 = ls_str
       END IF
       UPDATE gcd_file SET gcd08=g_gcd[li_i].gcd08,gcd09=g_gcd[li_i].gcd09
        WHERE gcd01 = g_gcc.gcc01 AND gcd02 = g_gcd[li_i].gcd02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] != 1 THEN
          LET li_result = FALSE
          EXIT FOR
       END IF
   END FOR
   IF li_result THEN
      COMMIT WORK
      MESSAGE 'Successful'
   ELSE
      ROLLBACK WORK
      LET g_gcd.* = g_gcd_o.*
      MESSAGE 'Failed'
   END IF
END FUNCTION
 
FUNCTION unload_to_excel()
   DEFINE   lr_data_tmp     RECORD
            data01,data02,data03,data04,data05,data06,data07,data08,data09,
            data10,data11,data12,data13,data14,data15,data16,data17,data18,
            data19,data20
#           ,data21,data22,data23,data24,data25,data26,data27,
#           data28,data29,data30,data31,data32,data33,data34,data35,data36,
#           data37,data38,data39,data40,data41,data42,data43,data44,data45,
#           data46,data47,data48,data49,data50
                            LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(255)
                            END RECORD
   DEFINE   lr_data         DYNAMIC ARRAY OF RECORD
            data01,data02,data03,data04,data05,data06,data07,data08,data09,
            data10,data11,data12,data13,data14,data15,data16,data17,data18,
            data19,data20
#           ,data21,data22,data23,data24,data25,data26,data27,
#           data28,data29,data30,data31,data32,data33,data34,data35,data36,
#           data37,data38,data39,data40,data41,data42,data43,data44,data45,
#           data46,data47,data48,data49,data50
 STRING
                            END RECORD
   DEFINE   li_result       LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_i            LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_j            LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_cell         STRING
   DEFINE   ls_cell2        STRING
   DEFINE   ls_cell_r       STRING
   DEFINE   ls_cell_c       STRING
   DEFINE   ls_cell_r2      STRING
   DEFINE   ls_cell_c2      STRING
   DEFINE   ls_value        STRING
   DEFINE   ls_sql          STRING
   DEFINE   ls_col_str      STRING
   DEFINE   ls_tab_str      STRING
   DEFINE   ls_where_str    STRING
   DEFINE   ls_where2_ori   STRING
   DEFINE   ls_where2_str   STRING
   DEFINE   li_col_cnt      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_col_idx      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   lr_gce          RECORD
               gce03        LIKE gce_file.gce03,
               gce04        LIKE gce_file.gce04
                            END RECORD
   DEFINE   lc_gcc02        LIKE gcc_file.gcc02
   DEFINE   lc_first        LIKE gcd_file.gcd10
   DEFINE   li_data_stat    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_data_end     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   lr_gcd          RECORD
             gcd02          LIKE gcd_file.gcd02,
             gcd03          LIKE gcd_file.gcd03,
             gcd04          LIKE gcd_file.gcd04,
             gcd05          LIKE gcd_file.gcd05,
             gcd06          LIKE gcd_file.gcd06,
             gcd07          LIKE gcd_file.gcd07,
             gcd08          LIKE gcd_file.gcd08,
             gcd09          LIKE gcd_file.gcd09,
             gcd10          LIKE gcd_file.gcd10
                            END RECORD
   DEFINE   lc_value        LIKE type_file.chr1000 #No.FUN-680135 VARCHAR(1000)
   DEFINE   li_cnt          LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_cnt          STRING
   DEFINE   lc_direction    LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
   DEFINE   l_sheet         STRING                 #FUN-CB0047 
 
   IF g_gcc.gcc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL xlsstyle_b_fill("1=1")
 
   #開啟Excel
   CALL ui.Interface.frontCall("standard","shellexec",["EXCEL"] ,li_result)
   CALL xlsstyle_checkError(li_result,"Open File")
   SLEEP 5
   LET l_sheet=cl_getsheetname() CLIPPED ,'1'                                        #FUN-CB0047
  #CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result]) #mark by FUN-CB0047
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",l_sheet],[li_result])  #FUN-CB0047
   CALL xlsstyle_checkError(li_result,"Connect File")
 
   LET ls_col_str = ""
   LET ls_tab_str = ""
   LET ls_where_str = ""
   LET lc_first = ""
   LET li_col_cnt = 0
   FOR li_i = 1 TO g_gcd.getLength()
       CASE g_gcd[li_i].gcd03
          WHEN "1"
             IF g_gcd[li_i].gcd08 CLIPPED = g_gcd[li_i].gcd09 CLIPPED THEN
                LET ls_cell = g_gcd[li_i].gcd08
                LET ls_value = g_gcd[li_i].gcd05
               #CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL","Sheet1",ls_cell,ls_value],[li_result]) #mark by FUN-CB0047
                CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL",l_sheet,ls_cell,ls_value],[li_result])  #FUN-CB0047
                CALL xlsstyle_checkError(li_result,"Poke Cells")
             ELSE
                #如果不一樣要先解析位置，再用迴圈塞入資料
             END IF
          WHEN "2"
             #設定是由設定為直向的資料先開始搜尋或是橫向開始
             IF cl_null(lc_first) THEN
                LET lc_first = g_gcd[li_i].gcd10
             END IF
 
             IF NOT cl_null(g_gcd[li_i].gcd04) THEN
                IF ls_tab_str.getIndexOf(g_gcd[li_i].gcd04 CLIPPED,1) <= 0 THEN
                   LET ls_tab_str = ls_tab_str,g_gcd[li_i].gcd04 CLIPPED,","
                END IF
             END IF
             IF NOT cl_null(g_gcd[li_i].gcd05) AND (g_gcd[li_i].gcd10 = lc_first) THEN
                LET li_col_cnt = li_col_cnt + 1
                IF g_gcd[li_i].gcd07 = "Y" THEN
                   LET ls_col_str = ls_col_str," UNIQUE "
                END IF
                LET ls_col_str = ls_col_str,g_gcd[li_i].gcd05,","
             END IF
             IF (g_gcd[li_i].gcd06 = "Y") AND (g_gcd[li_i].gcd10 = lc_first) THEN
                LET ls_sql = "SELECT gce03,gce04 FROM gce_file ",
                             " WHERE gce01='",g_gcc.gcc01 CLIPPED,"' AND gce02='",g_gcd[li_i].gcd02 CLIPPED,"'"
                PREPARE gce_pre FROM ls_sql
                DECLARE gce_curs CURSOR FOR gce_pre
                FOREACH gce_curs INTO lr_gce.*
                   IF NOT cl_null(lr_gce.gce03) AND NOT cl_null(lr_gce.gce04) THEN
                      LET ls_where_str = ls_where_str,lr_gce.gce03,lr_gce.gce04," AND "
                   END IF
                END FOREACH
             END IF
          WHEN "3"
       END CASE
   END FOR
   FOR li_i = li_col_cnt + 1 TO 9
       LET ls_col_str = ls_col_str,"'',"
   END FOR
   LET ls_col_str = ls_col_str.subString(1,ls_col_str.getLength() -1)
   LET ls_tab_str = ls_tab_str.subString(1,ls_tab_str.getLength() -1)
   LET ls_where_str = ls_where_str.subString(1,ls_where_str.getLength() -5)
   SELECT gcc02 INTO lc_gcc02 FROM gcc_file WHERE gcc01=g_gcc.gcc01
 
   LET ls_sql = "SELECT ",ls_col_str," FROM ",ls_tab_str
   IF ls_where_str IS NOT NULL THEN
      LET ls_sql = ls_sql," WHERE ",ls_where_str
   END IF
   IF lc_gcc02 IS NOT NULL THEN
      LET ls_sql = ls_sql," ORDER BY ",lc_gcc02 CLIPPED
   END IF
   PREPARE data_pre FROM ls_sql
display '1:',ls_sql
   DECLARE data_curs CURSOR FOR data_pre
   LET li_i = 1
   FOREACH data_curs INTO lr_data_tmp.*
      IF SQLCA.sqlcode THEN
         EXIT FOREACH
      END IF
      LET lr_data[li_i].data01 = lr_data_tmp.data01
      LET lr_data[li_i].data02 = lr_data_tmp.data02
      LET lr_data[li_i].data03 = lr_data_tmp.data03
      LET lr_data[li_i].data04 = lr_data_tmp.data04
      LET lr_data[li_i].data05 = lr_data_tmp.data05
      LET lr_data[li_i].data06 = lr_data_tmp.data06
      LET lr_data[li_i].data07 = lr_data_tmp.data07
      LET lr_data[li_i].data08 = lr_data_tmp.data08
      LET lr_data[li_i].data09 = lr_data_tmp.data09
      LET lr_data[li_i].data10 = lr_data_tmp.data10
      LET lr_data[li_i].data11 = lr_data_tmp.data11
      LET lr_data[li_i].data12 = lr_data_tmp.data12
      LET lr_data[li_i].data13 = lr_data_tmp.data13
      LET lr_data[li_i].data14 = lr_data_tmp.data14
      LET lr_data[li_i].data15 = lr_data_tmp.data15
      LET lr_data[li_i].data16 = lr_data_tmp.data16
      LET lr_data[li_i].data17 = lr_data_tmp.data17
      LET lr_data[li_i].data18 = lr_data_tmp.data18
      LET lr_data[li_i].data19 = lr_data_tmp.data19
      LET lr_data[li_i].data20 = lr_data_tmp.data20
      INITIALIZE lr_data_tmp.* TO NULL
      LET li_i = li_i + 1
      IF li_i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
 
   LET li_col_idx = 1
   FOR li_i = 1 TO g_gcd.getLength()
       IF (g_gcd[li_i].gcd03 = "2") THEN
          IF (NOT cl_null(g_gcd[li_i].gcd08)) AND (NOT cl_null(g_gcd[li_i].gcd09)) THEN
             #先解析由哪裡印到哪裡
             CASE lc_first
                WHEN "1"
                   LET ls_cell = g_gcd[li_i].gcd08
                   LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1),ls_cell.getLength())
                   LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
                   LET li_data_stat = ls_cell_r
                   LET ls_cell = g_gcd[li_i].gcd09
                   LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
                   LET li_data_end = ls_cell_r
                WHEN "2"
                   LET ls_cell = g_gcd[li_i].gcd08
                   LET ls_cell_r = ls_cell.subString(1,ls_cell.getIndexOf("C",1)-1)
                   LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1)+1,ls_cell.getLength())
                   LET li_data_stat = ls_cell_c
                   LET ls_cell = g_gcd[li_i].gcd09
                   LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1)+1,ls_cell.getLength())
                   LET li_data_end = ls_cell_c
             END CASE
 
             FOR li_j = li_data_stat TO li_data_end
                 CASE lc_first
                    WHEN "1"
                       LET ls_cell_r = li_j
                       LET ls_cell = "R",ls_cell_r.trim(),ls_cell_c.trim()
                    WHEN "2"
                       LET ls_cell_c = li_j
                       LET ls_cell = ls_cell_r.trim(),"C",ls_cell_c.trim()
                 END CASE
                 CASE li_col_idx
                    WHEN 1
                       LET ls_value = lr_data[li_j].data01
                    WHEN 2
                       LET ls_value = lr_data[li_j].data02
                    WHEN 3
                       LET ls_value = lr_data[li_j].data03
                    WHEN 4
                       LET ls_value = lr_data[li_j].data04
                    WHEN 5
                       LET ls_value = lr_data[li_j].data05
                    WHEN 6
                       LET ls_value = lr_data[li_j].data06
                    WHEN 7
                       LET ls_value = lr_data[li_j].data07
                    WHEN 8
                       LET ls_value = lr_data[li_j].data08
                    WHEN 9
                       LET ls_value = lr_data[li_j].data09
                    WHEN 10
                       LET ls_value = lr_data[li_j].data10
                    WHEN 11
                       LET ls_value = lr_data[li_j].data11
                    WHEN 12
                       LET ls_value = lr_data[li_j].data12
                    WHEN 13
                       LET ls_value = lr_data[li_j].data13
                    WHEN 14
                       LET ls_value = lr_data[li_j].data14
                    WHEN 15
                       LET ls_value = lr_data[li_j].data15
                    WHEN 16
                       LET ls_value = lr_data[li_j].data16
                    WHEN 17
                       LET ls_value = lr_data[li_j].data17
                    WHEN 18
                       LET ls_value = lr_data[li_j].data18
                    WHEN 19
                       LET ls_value = lr_data[li_j].data19
                    WHEN 20
                       LET ls_value = lr_data[li_j].data20
                 END CASE
                #CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL","Sheet1",ls_cell,ls_value],[li_result]) #mark by FUN-CB0047
                 CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL",l_sheet,ls_cell,ls_value],[li_result])  #FUN-CB0047
                 CALL xlsstyle_checkError(li_result,"Poke Cells")
             END FOR
          END IF
          LET li_col_idx = li_col_idx + 1
       END IF
   END FOR
 
   LET ls_sql = "SELECT gcd02,gcd03,gcd04,gcd05,gcd06,gcd07,gcd08,gcd09,gcd10",
                "  FROM gcd_file",
                " WHERE gcd01='",g_gcc.gcc01,"' AND gcd03='2'"
   CASE lc_first
      WHEN "1"
         LET ls_sql = ls_sql," AND gcd10='2'"
      WHEN "2"
         LET ls_sql = ls_sql," AND gcd10='1'"
   END CASE
   PREPARE gcd_2_pre FROM ls_sql
   DECLARE gcd_2_curs CURSOR FOR gcd_2_pre
 
   FOREACH gcd_2_curs INTO lr_gcd.*
      #組自己的where條件式
      LET ls_sql = "SELECT gce03,gce04 FROM gce_file ",
                   " WHERE gce01='",g_gcc.gcc01 CLIPPED,"' AND gce02=",lr_gcd.gcd02 CLIPPED
      PREPARE gce_2_pre FROM ls_sql
      DECLARE gce_2_curs CURSOR FOR gce_2_pre
      FOREACH gce_2_curs INTO lr_gce.*
         IF NOT cl_null(lr_gce.gce03) AND NOT cl_null(lr_gce.gce04) THEN
            IF cl_null(ls_where_str) THEN
               LET ls_where2_ori = lr_gce.gce03,lr_gce.gce04," AND "
            ELSE
               LET ls_where2_ori = ls_where_str," AND ",lr_gce.gce03,lr_gce.gce04," AND "
            END IF
         END IF
      END FOREACH
 
      #組搜尋出來的資料的條件式,找出值
      FOR li_j = li_data_stat TO li_data_end
          LET ls_where2_str = ls_where2_ori
          LET li_col_idx = 1
          FOR li_i = 1 TO g_gcd.getLength()
              IF (g_gcd[li_i].gcd03 = "2") AND (g_gcd[li_i].gcd10 = lc_first) THEN
                 LET ls_where2_str = ls_where2_str,g_gcd[li_i].gcd05,"='"
                 CASE li_col_idx
                    WHEN 1
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data01,"' AND "
                    WHEN 2
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data02,"' AND "
                    WHEN 3
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data03,"' AND "
                    WHEN 4
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data04,"' AND "
                    WHEN 5
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data05,"' AND "
                    WHEN 6
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data06,"' AND "
                    WHEN 7
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data07,"' AND "
                    WHEN 8
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data08,"' AND "
                    WHEN 9
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data09,"' AND "
                    WHEN 10
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data10,"' AND "
                    WHEN 11
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data11,"' AND "
                    WHEN 12
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data12,"' AND "
                    WHEN 13
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data13,"' AND "
                    WHEN 14
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data14,"' AND "
                    WHEN 15
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data15,"' AND "
                    WHEN 16
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data16,"' AND "
                    WHEN 17
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data17,"' AND "
                    WHEN 18
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data18,"' AND "
                    WHEN 19
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data19,"' AND "
                    WHEN 20
                       LET ls_where2_str = ls_where2_str,lr_data[li_j].data20,"' AND "
                 END CASE
                 LET li_col_idx = li_col_idx + 1
              END IF
          END FOR
          LET ls_where2_str = ls_where2_str.subString(1,ls_where2_str.getLength()-5)
 
          LET lc_value = ""
          LET ls_sql = "SELECT COUNT(*) FROM ",ls_tab_str," WHERE ",ls_where2_str
          PREPARE last_data_cnt FROM ls_sql
          EXECUTE last_data_cnt INTO li_cnt
          IF li_cnt > 1 THEN
             #解析印在哪裡
             IF (NOT cl_null(lr_gcd.gcd08)) AND (NOT cl_null(lr_gcd.gcd09)) THEN
                LET ls_cell = lr_gcd.gcd08
                LET ls_cell_r = ls_cell.subString(1,ls_cell.getIndexOf("C",1)-1)
                LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1),ls_cell.getLength())
                LET ls_cell2= lr_gcd.gcd09
                LET ls_cell_r2= ls_cell2.subString(1,ls_cell2.getIndexOf("C",1)-1)
                LET ls_cell_c2= ls_cell2.subString(ls_cell2.getIndexOf("C",1),ls_cell.getLength())
                IF ls_cell_r.equals(ls_cell_r2) THEN
                   LET ls_cell_c = li_j
                   LET ls_cell = ls_cell_r,"C",ls_cell_c.trim()
                   LET lc_direction = "v"
                ELSE
                   LET ls_cell_r = li_j
                   LET ls_cell = "R",ls_cell_r.trim(),ls_cell_c
                   LET lc_direction = "h"
                END IF
             END IF
             LET ls_sql = "SELECT ",lr_gcd.gcd05 CLIPPED," FROM ",ls_tab_str,
                          " WHERE ",ls_where2_str
display '2:',ls_sql
             PREPARE last_data_2 FROM ls_sql
             DECLARE last_data_2_curs CURSOR FOR last_data_2
             LET li_cnt = 1
             FOREACH last_data_2_curs INTO lc_value
                LET ls_value = lc_value
                LET ls_cnt = li_cnt
                CASE
                   WHEN lc_direction = "v"
                      LET ls_cell = ls_cell_r,"C",ls_cnt.trim()
                   WHEN lc_direction = "h"
                      LET ls_cell = "R",ls_cnt.trim(),ls_cell_c
                END CASE
               #CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL","Sheet1",ls_cell,ls_value],[li_result]) #mark by FUN-CB0047
                CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL",l_sheet,ls_cell,ls_value],[li_result])  #FUN-CB0047
                CALL xlsstyle_checkError(li_result,"Poke Cells")
                LET li_cnt = li_cnt + 1
             END FOREACH
          ELSE
             LET ls_sql = "SELECT ",lr_gcd.gcd05 CLIPPED," FROM ",ls_tab_str,
                          " WHERE ",ls_where2_str
display '2:',ls_sql
             PREPARE last_data FROM ls_sql
             EXECUTE last_data INTO lc_value
             LET ls_value = lc_value
             IF (NOT cl_null(lr_gcd.gcd08)) AND (NOT cl_null(lr_gcd.gcd09)) THEN
                #解析印在哪裡
                LET ls_cell = lr_gcd.gcd08
                LET ls_cell_r = ls_cell.subString(1,ls_cell.getIndexOf("C",1)-1)
                LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1),ls_cell.getLength())
                LET ls_cell2= lr_gcd.gcd09
                LET ls_cell_r2= ls_cell2.subString(1,ls_cell2.getIndexOf("C",1)-1)
                LET ls_cell_c2= ls_cell2.subString(ls_cell2.getIndexOf("C",1),ls_cell.getLength())
                IF ls_cell_r.equals(ls_cell_r2) THEN
                   LET ls_cell_c = li_j
                   LET ls_cell = ls_cell_r,"C",ls_cell_c.trim()
                ELSE
                   LET ls_cell_r = li_j
                   LET ls_cell = "R",ls_cell_r.trim(),ls_cell_c
                END IF
               #CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL","Sheet1",ls_cell,ls_value],[li_result]) #mark by FUN-CB0047
                CALL ui.Interface.frontCall("WINDDE","DDEPoke",["EXCEL",l_sheet,ls_cell,ls_value],[li_result])  #FUN-CB0047
                CALL xlsstyle_checkError(li_result,"Poke Cells")
             END IF
          END IF
      END FOR
   END FOREACH
 
   #關閉Excel寫入
  #CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","Sheet1"],[li_result]) #mark by FUN-CB0047
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL",l_sheet],[li_result])  #FUN-CB0047
   CALL xlsstyle_checkError(li_result,"Finish")
END FUNCTION
 
FUNCTION load_from_excel()
   DEFINE   lr_data         DYNAMIC ARRAY OF RECORD
            data01,data02,data03,data04,data05,data06,data07,data08,data09,
            data10,data11,data12,data13,data14,data15,data16,data17,data18,
            data19,data20
#           ,data21,data22,data23,data24,data25,data26,data27,
#           data28,data29,data30,data31,data32,data33,data34,data35,data36,
#           data37,data38,data39,data40,data41,data42,data43,data44,data45,
#           data46,data47,data48,data49,data50
 STRING
                            END RECORD
   DEFINE   lr_data_tmp     DYNAMIC ARRAY OF RECORD
            data01,data02,data03,data04,data05,data06,data07,data08,data09,
            data10,data11,data12,data13,data14,data15,data16,data17,data18,
            data19,data20
#           ,data21,data22,data23,data24,data25,data26,data27,
#           data28,data29,data30,data31,data32,data33,data34,data35,data36,
#           data37,data38,data39,data40,data41,data42,data43,data44,data45,
#           data46,data47,data48,data49,data50
 STRING
                            END RECORD
   DEFINE   ls_doc_path     STRING
   DEFINE   ls_key_list     STRING
   DEFINE   lst_keys        base.StringTokenizer
   DEFINE   ls_key          STRING
   DEFINE   ls_file_name    STRING
   DEFINE   ls_file_path    STRING
   DEFINE   li_result       LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_cnt          LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_cnt2         LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   lc_gcd02        LIKE gcd_file.gcd02    #MOD-920039 add
   DEFINE   lc_gcd04        LIKE gcd_file.gcd04
   DEFINE   lc_gcd05        LIKE gcd_file.gcd05
   DEFINE   ls_fields       STRING
   DEFINE   ls_exe_sql      STRING
   DEFINE   li_i            LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_j            LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_k            LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   lc_first        LIKE gcd_file.gcd10
   DEFINE   ls_cell         STRING
   DEFINE   ls_cell2        STRING
   DEFINE   ls_cell_r       STRING
   DEFINE   ls_cell_c       STRING
   DEFINE   ls_cell_r2      STRING
   DEFINE   ls_cell_c2      STRING
   DEFINE   li_data_stat    LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_data_end     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_col_cnt      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_col_idx      LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   li_col_idx2     LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   ls_value        STRING
   DEFINE   lr_err          DYNAMIC ARRAY OF RECORD
               line         STRING,
               key1         STRING,
               err          STRING,
               cmd          STRING           #No.TQC-860009
                            END RECORD
   DEFINE   lr_key          DYNAMIC ARRAY OF STRING     #key列表
   DEFINE   lr_gcd          DYNAMIC ARRAY OF RECORD LIKE gcd_file.*
   DEFINE   lc_now_fld      LIKE gcd_file.gcd05
   DEFINE   l_flag          LIKE type_file.chr1    #MOD-960306
   DEFINE   l_sheet         STRING                 #FUN-CB0047
   DEFINE   li_val          LIKE type_file.num5    #FUN-CB0047
 
   IF g_gcc.gcc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL xlsstyle_b_fill("1=1")
 
   SELECT COUNT(UNIQUE gcd04) INTO li_cnt FROM gcd_file
    WHERE gcd01 = g_gcc.gcc01 AND gcd03 = '2'
   IF li_cnt > 1 THEN
      CALL cl_err("設定值內，table不為唯一無法匯入","!",1)
      RETURN
   ELSE
      SELECT UNIQUE gcd04 INTO lc_gcd04 FROM gcd_file
       WHERE gcd01 = g_gcc.gcc01 AND gcd03 = '2'
   END IF
 
   #開窗選擇檔案
   OPEN WINDOW xlsstyle_load_w WITH FORM "azz/42f/p_xlsstyle_load" 
   CALL cl_ui_locale("p_xlsstyle_load")
   
   INPUT ls_doc_path,ls_key_list WITHOUT DEFAULTS
    FROM FORMONLY.doc_path,FORMONLY.key_list
 
      ON ACTION open_file
         CALL cl_browse_file() RETURNING ls_doc_path
         DISPLAY ls_doc_path TO FORMONLY.doc_path
      ON ACTION exit
         EXIT INPUT
#TQC-860017 start
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
#TQC-860017 end
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      CLOSE WINDOW xlsstyle_load_w
      RETURN
   END IF
 
   IF ls_doc_path IS NULL OR ls_key_list IS NULL THEN
      CLOSE WINDOW xlsstyle_load_w
      RETURN
   ELSE
      LET ls_file_path = ls_doc_path
      LET ls_file_name = ls_doc_path
      WHILE TRUE
         IF ls_file_name.getIndexOf("/",1) THEN
            LET ls_file_name = ls_file_name.subString(ls_file_name.getIndexOf("/",1) + 1,ls_file_name.getLength())
         ELSE
            EXIT WHILE
         END IF
      END WHILE
      DISPLAY 'ls_file_path = ',ls_file_path
   END IF
 
   #Check key list有沒有存在設定列表中
   LET lst_keys = base.StringTokenizer.create(ls_key_list,",")
   LET li_cnt = 1
   CALL lr_key.clear()
   WHILE lst_keys.hasMoreTokens()
      LET ls_key = lst_keys.nextToken()
      LET ls_key = ls_key.trim()
      LET lc_gcd05 = ls_key
      SELECT COUNT(*) INTO li_cnt FROM gcd_file WHERE gcd01 = g_gcc.gcc01 AND gcd03 = '2'
      IF li_cnt <= 0 THEN
         CALL cl_err("輸入的key值不存在設定列表中","!",1)
         RETURN
      END IF
      LET lr_key[li_cnt]=ls_key
      LET li_cnt = li_cnt + 1
   END WHILE
 
   CALL ui.Interface.frontCall("standard","shellexec",[ls_file_path] ,li_result)
   CALL xlsstyle_checkError(li_result,"Open File")
 
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",ls_file_name],[li_result])
   CALL xlsstyle_checkError(li_result,"Connect File")

   #FUN-CB0047 --start--
   #auto get xxx.xls first sheet name
   CALL ui.Interface.frontCall("WINDDE","DDEConnect", ["EXCEL", "system"],[li_result])
   CALL xlsstyle_checkError(li_result,"Connect File")
   CALL ui.Interface.frontCall("WINDDE","DDEPeek", ["EXCEL","system","topics"], [li_result,ls_value] ) #get xxx.xls sheet list
   IF ls_value IS NOT NULL THEN #拆解sheet list,sample=[:]:\t[gen.xls]sheet1\tSystem
      IF ls_value.getIndexOf("[:]",1) > 0 THEN #部份office 2003格式不同,不會有[:],所以解析方式不同
         LET li_val=ls_value.getIndexOf("]",1)
         LET ls_value=ls_value.subString(li_val+1,length(ls_value))
      END IF
      LET li_val=ls_value.getIndexOf("]",1)
      LET ls_value=ls_value.subString(li_val+1,length(ls_value))
      LET li_val=ls_value.getIndexOf("\t",1)
      LET l_sheet=ls_value.subString(1,li_val-1)
   END IF
   #FUN-CB0047 --end--
 
  #CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL","Sheet1"],[li_result]) #mark by FUN-CB0047
   CALL ui.Interface.frontCall("WINDDE","DDEConnect",["EXCEL",l_sheet],[li_result])  #FUN-CB0047
   CALL xlsstyle_checkError(li_result,"Connect Sheet1")
 
   MESSAGE ls_file_name," File Analyze..."
 
   #組SQL前半段.dbo.INSERT INTO xxx_file(xxx....) VALUES(
  #str MOD-920039 add
  #DECLARE sql_curs CURSOR FOR
  #   SELECT UNIQUE gcd05 FROM gcd_file
  #    WHERE gcd01 = g_gcc.gcc01 AND gcd03 = '2'
 
   DROP TABLE xlsstyle_tmp	#MOD-960306 
 
   #為了讓抓出來的欄位代號照項次排序,先抓出UNIQUE gcd05,寫入Temptable裡,
   #再以gcd05去抓出在設定檔裡最小的項次寫入Temptable,
   #最後撈取Temptable裡的資料出來
   CREATE TEMP TABLE xlsstyle_tmp(
    gcd05 LIKE gcd_file.gcd05, 
    gcd02 LIKE gcd_file.gcd02); 
 
   DECLARE sql_curs1 CURSOR FOR
      SELECT UNIQUE gcd05 FROM gcd_file
       WHERE gcd01 = g_gcc.gcc01 AND gcd03 = '2'
   FOREACH sql_curs1 INTO lc_gcd05
      SELECT MIN(gcd02) INTO lc_gcd02 FROM gcd_file
       WHERE gcd01=g_gcc.gcc01 AND gcd03='2' AND gcd05=lc_gcd05
      INSERT INTO xlsstyle_tmp (gcd05,gcd02) VALUES (lc_gcd05,lc_gcd02)
   END FOREACH
 
   DECLARE sql_curs CURSOR FOR
      SELECT gcd05 FROM xlsstyle_tmp ORDER BY gcd02
  #end MOD-920039 add
 
   LET li_col_cnt = 0
   FOREACH sql_curs INTO lc_gcd05
      IF NOT cl_null(lc_gcd05) THEN
         LET ls_fields = ls_fields,lc_gcd05,","
         LET li_col_cnt = li_col_cnt + 1
      END IF
   END FOREACH
   LET ls_fields = ls_fields.subString(1,ls_fields.getLength()-1)
 
   #搜尋出直向先開始或橫向
   LET lc_first = ""
   FOR li_i = 1 TO g_gcd.getLength()
       IF g_gcd[li_i].gcd03 = "2" THEN
          LET lc_first = g_gcd[li_i].gcd10
          EXIT FOR
       END IF
   END FOR
 
   #非定值的gcd資料拿出來使用
   DECLARE gcd1_curs CURSOR FOR
      SELECT * FROM gcd_file WHERE gcd01=g_gcc.gcc01 AND gcd03='2'
#      ORDER BY gcd05,gcd02    #mark by FUN-CB0047
       ORDER BY gcd02          #FUN-CB0047 解決後續insert into欄位順序與values資料順序不一樣的問題
   LET li_cnt = 1
   CALL lr_gcd.clear()
   FOREACH gcd1_curs INTO lr_gcd[li_cnt].*
      LET li_cnt = li_cnt + 1
   END FOREACH
   CALL lr_gcd.deleteElement(li_cnt)
 
   #準備解Excel內的資料
   #第一階段搜尋
   LET li_col_idx = 1
   FOR li_i = 1 TO lr_gcd.getLength()
       IF lr_gcd[li_i].gcd10 = lc_first THEN
          CASE lc_first
             WHEN "1"
                LET ls_cell = lr_gcd[li_i].gcd08
                LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1),ls_cell.getLength())
                LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
                LET li_data_stat = ls_cell_r
                LET ls_cell = lr_gcd[li_i].gcd09
                LET ls_cell_r = ls_cell.subString(ls_cell.getIndexOf("R",1)+1,ls_cell.getIndexOf("C",1)-1)
                LET li_data_end = ls_cell_r
             WHEN "2"
                LET ls_cell = lr_gcd[li_i].gcd08
                LET ls_cell_r = ls_cell.subString(1,ls_cell.getIndexOf("C",1)-1)
                LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1)+1,ls_cell.getLength())
                LET li_data_stat = ls_cell_c
                LET ls_cell = lr_gcd[li_i].gcd09
                LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1)+1,ls_cell.getLength())
                LET li_data_end = ls_cell_c
          END CASE
 
          #將抓到的資料放到lr_data_tmp
          LET li_cnt = 1
          FOR li_j = li_data_stat TO li_data_end
              LET ls_value = ""
              CASE lc_first
                 WHEN "1"
                    LET ls_cell_r = li_j
                    LET ls_cell = "R",ls_cell_r.trim(),ls_cell_c.trim()
                 WHEN "2"
                    LET ls_cell_c = li_j
                    LET ls_cell = ls_cell_r.trim(),"C",ls_cell_c.trim()
              END CASE
              CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",ls_file_name,ls_cell],[li_result,ls_value])
              CALL xlsstyle_checkError(li_result,"Peek Cells")
              LET ls_value = ls_value.trim()
              #No.TQC-860009 --start--
              IF ls_value.getIndexOf("\"",1) THEN
                 LET ls_value = cl_replace_str(ls_value,'"','@#$%')
                 LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
              END IF
              IF ls_value.getIndexOf("'",1) THEN
                 LET ls_value = cl_replace_str(ls_value,"'","@#$%")
                 LET ls_value = cl_replace_str(ls_value,"@#$%","''")
              END IF
              #No.TQC-860009 ---end---
              CASE li_col_idx
                 WHEN 1
                    LET lr_data_tmp[li_cnt].data01 = ls_value
                 WHEN 2
                    LET lr_data_tmp[li_cnt].data02 = ls_value
                 WHEN 3
                    LET lr_data_tmp[li_cnt].data03 = ls_value
                 WHEN 4
                    LET lr_data_tmp[li_cnt].data04 = ls_value
                 WHEN 5
                    LET lr_data_tmp[li_cnt].data05 = ls_value
                 WHEN 6
                    LET lr_data_tmp[li_cnt].data06 = ls_value
                 WHEN 7
                    LET lr_data_tmp[li_cnt].data07 = ls_value
                 WHEN 8
                    LET lr_data_tmp[li_cnt].data08 = ls_value
                 WHEN 9
                    LET lr_data_tmp[li_cnt].data09 = ls_value
                 WHEN 10
                    LET lr_data_tmp[li_cnt].data10 = ls_value
                 WHEN 11
                    LET lr_data_tmp[li_cnt].data11 = ls_value
                 WHEN 12
                    LET lr_data_tmp[li_cnt].data12 = ls_value
                 WHEN 13
                    LET lr_data_tmp[li_cnt].data13 = ls_value
                 WHEN 14
                    LET lr_data_tmp[li_cnt].data14 = ls_value
                 WHEN 15
                    LET lr_data_tmp[li_cnt].data15 = ls_value
                 WHEN 16
                    LET lr_data_tmp[li_cnt].data16 = ls_value
                 WHEN 17
                    LET lr_data_tmp[li_cnt].data17 = ls_value
                 WHEN 18
                    LET lr_data_tmp[li_cnt].data18 = ls_value
                 WHEN 19
                    LET lr_data_tmp[li_cnt].data19 = ls_value
                 WHEN 20
                    LET lr_data_tmp[li_cnt].data20 = ls_value
              END CASE
              LET li_cnt = li_cnt + 1
          END FOR
          LET li_col_idx = li_col_idx + 1
       END IF
   END FOR
 
   #第二階段搜尋(如果有第二階段)
   SELECT COUNT(*) INTO li_cnt FROM gcd_file
    WHERE gcd01=g_gcc.gcc01 AND gcd03='2' AND gcd10 != lc_first
   #檢查有第二階段才做
   LET li_k = 1
   IF li_cnt > 0 THEN
      LET li_cnt2= 1         #lr_data_tmp的資料指標，因為Excel一行包含多筆資料，所以第一階段的資料是重覆使用的
      FOR li_j = li_data_stat TO li_data_end
          LET li_col_idx2 = li_col_idx        #li_col_idx2是第二階段欄位開始的指標，接續第一階段的欄位順序
          LET li_cnt = 1
          LET lc_now_fld = ""                 #因為Excel一行內會有多筆資料多個欄位，這是檢查是否為同一筆資料的不同欄位進來了
          FOR li_i = 1 TO lr_gcd.getLength()
              IF lr_gcd[li_i].gcd10 != lc_first THEN
                 IF (NOT cl_null(lr_gcd[li_i].gcd08)) AND (NOT cl_null(lr_gcd[li_i].gcd09)) THEN
                    IF cl_null(lc_now_fld) THEN
                       LET lc_now_fld = lr_gcd[li_i].gcd05
                    END IF
                    #如果目前的欄位名稱不等於剛剛做的欄位名稱，代表lr_data需重頭，
                    #補回沒有的欄位資料，並將lc_now_fld指向新的欄位名稱以便和下面
                    #尋找到的欄位名稱比對
                    IF lc_now_fld != lr_gcd[li_i].gcd05 THEN
                       LET li_cnt = 1
                       LET li_col_idx2 = li_col_idx2 + 1     #補下一個欄位資料
                       LET lc_now_fld = lr_gcd[li_i].gcd05   #做下一階段的欄位名稱比對
                    ELSE
                       #如果都是同樣欄位而且為第二階段剛開始，代表是Excel此筆資
                       #料所產生的所有的insert資料，必須將第一階段的資料放進來
                       IF li_col_idx2 = li_col_idx THEN
                          LET lr_data[li_cnt].* = lr_data_tmp[li_cnt2].*
                       END IF
                    END IF
                    LET ls_value = ""
                    #解析從哪裡抓取資料
                    LET ls_cell = lr_gcd[li_i].gcd08
                    LET ls_cell_r = ls_cell.subString(1,ls_cell.getIndexOf("C",1)-1)
                    LET ls_cell_c = ls_cell.subString(ls_cell.getIndexOf("C",1),ls_cell.getLength())
                    LET ls_cell2= lr_gcd[li_i].gcd09
                    LET ls_cell_r2= ls_cell2.subString(1,ls_cell2.getIndexOf("C",1)-1)
                    LET ls_cell_c2= ls_cell2.subString(ls_cell2.getIndexOf("C",1),ls_cell.getLength())
                    IF ls_cell_r.equals(ls_cell_r2) THEN
                       LET ls_cell_c = li_j
                       LET ls_cell = ls_cell_r,"C",ls_cell_c.trim()
                    ELSE
                       LET ls_cell_r = li_j
                       LET ls_cell = "R",ls_cell_r.trim(),ls_cell_c
                    END IF
                    CALL ui.Interface.frontCall("WINDDE","DDEPeek",["EXCEL",ls_file_name,ls_cell],[li_result,ls_value])
                    CALL xlsstyle_checkError(li_result,"Peek Cells")
                    #No.TQC-860009 --start--
                    IF ls_value.getIndexOf("\"",1) THEN
                       LET ls_value = cl_replace_str(ls_value,'"','@#$%')
                       LET ls_value = cl_replace_str(ls_value,'@#$%','\"')
                    END IF
                    IF ls_value.getIndexOf("'",1) THEN
                       LET ls_value = cl_replace_str(ls_value,"'","@#$%")
                       LET ls_value = cl_replace_str(ls_value,"@#$%","''")
                    END IF
                    #No.TQC-860009 ---end---
                    CASE li_col_idx2
                       WHEN 1
                          LET lr_data[li_cnt].data01 = ls_value
                       WHEN 2
                          LET lr_data[li_cnt].data02 = ls_value
                       WHEN 3
                          LET lr_data[li_cnt].data03 = ls_value
                       WHEN 4
                          LET lr_data[li_cnt].data04 = ls_value
                       WHEN 5
                          LET lr_data[li_cnt].data05 = ls_value
                       WHEN 6
                          LET lr_data[li_cnt].data06 = ls_value
                       WHEN 7
                          LET lr_data[li_cnt].data07 = ls_value
                       WHEN 8
                          LET lr_data[li_cnt].data08 = ls_value
                       WHEN 9
                          LET lr_data[li_cnt].data09 = ls_value
                       WHEN 10
                          LET lr_data[li_cnt].data10 = ls_value
                       WHEN 11
                          LET lr_data[li_cnt].data11 = ls_value
                       WHEN 12
                          LET lr_data[li_cnt].data12 = ls_value
                       WHEN 13
                          LET lr_data[li_cnt].data13 = ls_value
                       WHEN 14
                          LET lr_data[li_cnt].data14 = ls_value
                       WHEN 15
                          LET lr_data[li_cnt].data15 = ls_value
                       WHEN 16
                          LET lr_data[li_cnt].data16 = ls_value
                       WHEN 17
                          LET lr_data[li_cnt].data17 = ls_value
                       WHEN 18
                          LET lr_data[li_cnt].data18 = ls_value
                       WHEN 19
                          LET lr_data[li_cnt].data19 = ls_value
                       WHEN 20
                          LET lr_data[li_cnt].data20 = ls_value
                    END CASE
                    LET li_cnt = li_cnt + 1
                 END IF
              END IF
          END FOR
          LET li_cnt2 = li_cnt2 + 1
          #帶入找到的lr_data資料，執行INSERT指令
          FOR li_i = 1 TO lr_data.getLength()
              CASE li_col_cnt
                 WHEN 1
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"')"
                 WHEN 2
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"')"
                 WHEN 3
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"')"
                 WHEN 4
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"')"
                 WHEN 5
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"')"
                 WHEN 6
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"')"
                 WHEN 7
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"')"
                 WHEN 8
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"')"
                 WHEN 9
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"')"
                 WHEN 10
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"')"
                 WHEN 11
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"')"
                 WHEN 12
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"')"
                 WHEN 13
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"')"
                 WHEN 14
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"')"
                 WHEN 15
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"')"
                 WHEN 16
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"')"
                 WHEN 17
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"')"
                 WHEN 18
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"','",lr_data[li_i].data18,"')"
                 WHEN 19
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"','",lr_data[li_i].data18,"','",lr_data[li_i].data19,"')"
                 WHEN 20
                    LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"','",lr_data[li_i].data18,"','",lr_data[li_i].data19,"','",lr_data[li_i].data20,"')"
              END CASE
              PREPARE execute_sql FROM ls_exe_sql
              EXECUTE execute_sql
              IF SQLCA.sqlcode THEN
                 LET lr_err[li_k].line = li_i
                 LET lr_err[li_k].key1 = lr_data[li_i].data01
                 LET lr_err[li_k].err  = SQLCA.sqlcode
                 LET lr_err[li_k].cmd  = ls_exe_sql     #No.TQC-860009
                 LET li_k = li_k + 1
              END IF
          END FOR
      END FOR
   ELSE
      #如果沒有第二階段，就直接將第一階段的東西倒到lr_data
      FOR li_i = 1 TO lr_data_tmp.getLength()
          LET lr_data[li_i].* = lr_data_tmp[li_i].*
      END FOR
      #帶入找到的lr_data資料，執行INSERT指令
      FOR li_i = 1 TO lr_data.getLength()
          CASE li_col_cnt
             WHEN 1
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"')"
             WHEN 2
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"')"
             WHEN 3
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"')"
             WHEN 4
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"')"
             WHEN 5
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"')"
             WHEN 6
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"')"
             WHEN 7
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"')"
             WHEN 8
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"')"
             WHEN 9
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"')"
             WHEN 10
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"')"
             WHEN 11
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"')"
             WHEN 12
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"')"
             WHEN 13
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"')"
             WHEN 14
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"')"
             WHEN 15
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"')"
             WHEN 16
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"')"
             WHEN 17
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"')"
             WHEN 18
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"','",lr_data[li_i].data18,"')"
             WHEN 19
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"','",lr_data[li_i].data18,"','",lr_data[li_i].data19,"')"
             WHEN 20
                LET ls_exe_sql = "INSERT INTO ",lc_gcd04,"(",ls_fields,") VALUES('",lr_data[li_i].data01,"','",lr_data[li_i].data02,"','",lr_data[li_i].data03,"','",lr_data[li_i].data04,"','",lr_data[li_i].data05,"','",lr_data[li_i].data06,"','",lr_data[li_i].data07,"','",lr_data[li_i].data08,"','",lr_data[li_i].data09,"','",lr_data[li_i].data10,"','",lr_data[li_i].data11,"','",lr_data[li_i].data12,"','",lr_data[li_i].data13,"','",lr_data[li_i].data14,"','",lr_data[li_i].data15,"','",lr_data[li_i].data16,"','",lr_data[li_i].data17,"','",lr_data[li_i].data18,"','",lr_data[li_i].data19,"','",lr_data[li_i].data20,"')"
          END CASE
          PREPARE execute2_sql FROM ls_exe_sql
          EXECUTE execute2_sql
          IF SQLCA.sqlcode THEN
             LET lr_err[li_k].line = li_i
             LET lr_err[li_k].key1 = lr_data[li_i].data01
             LET lr_err[li_k].err  = SQLCA.sqlcode
             LET lr_err[li_k].cmd  = ls_exe_sql    #No.TQC-860009
             LET li_k = li_k + 1
          END IF
      END FOR
   END IF
 
   IF lr_err.getLength() > 0 THEN
      CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"Line|Key1|Error")
  #-MOD-960306-add-
      CALL cl_end2(2) RETURNING l_flag  
   ELSE
      CALL cl_end2(1) RETURNING l_flag
  #-MOD-960306-end-
   END IF
 
   #關閉Excel寫入
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","system"],[li_result])     #FUN-CB0047
  #CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL","Sheet1"],[li_result])     #mark by FUN-CB0047
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL",l_sheet],[li_result])      #FUN-CB0047
   CALL ui.Interface.frontCall("WINDDE","DDEFinish",["EXCEL",ls_file_name],[li_result]) #FUN-CB0047
   CALL xlsstyle_checkError(li_result,"Finish")
 
   CLOSE WINDOW xlsstyle_load_w
END FUNCTION
 
FUNCTION xlsstyle_checkError(p_result,p_msg)
   DEFINE   p_result   LIKE type_file.num5    #No.FUN-680135 SMALLINT
   DEFINE   p_msg      STRING
   DEFINE   ls_msg     STRING
   DEFINE   li_result  LIKE type_file.num5    #No.FUN-680135 SMALLINT
 
 
   IF p_result THEN
      RETURN
   END IF
   DISPLAY p_msg," DDE ERROR:"
   CALL ui.Interface.frontCall("WINDDE","DDEError",[],[ls_msg])
   DISPLAY ls_msg
   CALL ui.Interface.frontCall("WINDDE","DDEFinishAll",[],[li_result])
   IF NOT li_result THEN
      DISPLAY "Exit with DDE Error."
   END IF
   EXIT PROGRAM
END FUNCTION
