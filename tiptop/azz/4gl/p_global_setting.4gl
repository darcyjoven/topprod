# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# 
# Pattern name...: p_global_setting.4gl
# Descriptions...: 資料表欄位拆分設定
# Input parameter: 資料表名稱
# Return code....: 
# Date & Author..: 2010/05/24 By Jay   #FUN-A40050  
# Modify.........: No.FUN-A60085 10/06/25 By Jay 呼叫cl_query_prt_getlength()只做一次CREATE TEMP TABLE

DATABASE ds
#FUN-A40050  add p_global_setting
GLOBALS "../../config/top.global"

GLOBALS
DEFINE  g_MODNO              LIKE zs_file.zs08,     #zs08(MODNO)
        g_tiptop_ver         LIKE zs_file.zs12,     
        g_date               LIKE type_file.dat    
END GLOBALS

TYPE t_tab RECORD
            azwb01            LIKE azwb_file.azwb01,
            gat03             LIKE gat_file.gat03,
            gat06             LIKE gat_file.gat06
            END RECORD
TYPE t_tab1 RECORD
            sel               BOOLEAN,
            ztb03             LIKE ztb_file.ztb03,
            gaq03             LIKE gaq_file.gaq03,
            pk                BOOLEAN
            END RECORD
TYPE t_tab2 RECORD
            sel               BOOLEAN,
            azwb02            LIKE azwb_file.azwb02,
            gaq03             LIKE gaq_file.gaq03
            END RECORD
TYPE t_tab3 RECORD
            sel               BOOLEAN,
            azwe03            LIKE azwe_file.azwe03,
            azw08             LIKE azw_file.azw08,
            azwe02            LIKE azwe_file.azwe02
            END RECORD
TYPE t_tab4 RECORD
            azwc01            LIKE azwc_file.azwc01,
            azwc02            LIKE azwc_file.azwc02
            END RECORD
DEFINE g_global_azwe01        LIKE azwe_file.azwe01,    #pageglobal頁籤需進行設定之TABLE名稱
       g_global_gat03         LIKE gat_file.gat03,      #pageglobal頁籤需進行設定之TABLE名稱之檔案名稱
       g_global_r_azwe01      LIKE azwe_file.azwe01,    #pageglobal頁籤資料群組參考TABLE名稱
       g_global_r_gat03       LIKE gat_file.gat03,      #pageglobal頁籤資料群組參考TABLE名稱之檔案名稱
       g_global_azwe01_t      LIKE azwe_file.azwe01,
       g_global_r_azwe01_t    LIKE azwe_file.azwe01,
       g_global_azwb01        LIKE azwb_file.azwb01,
       g_global_azwb01_t      LIKE azwb_file.azwb01,
       p_row,p_col            LIKE type_file.num5,
       g_tb                   DYNAMIC ARRAY OF t_tab, 
       g_tb1                  DYNAMIC ARRAY OF t_tab1, 
       g_tb2                  DYNAMIC ARRAY OF t_tab2,
       g_tb3                  DYNAMIC ARRAY OF t_tab3,
       g_tb4                  DYNAMIC ARRAY OF t_tab4,
       g_tb2_t                DYNAMIC ARRAY OF t_tab2   
DEFINE g_db_type              LIKE type_file.chr3
DEFINE g_azwb                 RECORD LIKE azwb_file.*,
       g_azwe                 RECORD LIKE azwe_file.*,
       g_zta                  RECORD LIKE zta_file.* 
DEFINE g_sql                  STRING,
       g_wc                   STRING,
       g_curs_index           LIKE type_file.num10,     #INTEGER
       g_row_count            LIKE type_file.num10,     #INTEGER
       g_rec_b1               LIKE type_file.num10,
       g_jump                 LIKE type_file.num10,
       mi_no_ask              LIKE type_file.num5,
       g_msg                  LIKE type_file.chr1000,   #CHAR(72)
       g_ac1                  LIKE type_file.num10,
       g_bp_flag              LIKE type_file.chr10,
       g_before_input_done    LIKE type_file.num5,      #SMALLINT
       g_flag                 LIKE type_file.chr1,      #CHAR(1)
       g_gat02                LIKE gat_file.gat02,
       g_ss                   LIKE type_file.chr1,      #VARCHAR(1) # 決定後續步驟
       g_action_flag          STRING,                   #若是modify,則不直接進入pagegroup
       g_action_choice_t      STRING
DEFINE g_pks                  DYNAMIC ARRAY OF STRING   #該table的pk，以逗號區格pk欄位


MAIN

DEFINE   l_gat06             LIKE gat_file.gat06,
         l_gat06_t           STRING
        
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP  
   DEFER INTERRUPT
 
 
#   LET g_argv1 = ARG_VAL(1)
#   LET g_argv2 = ARG_VAL(2) 

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("azz")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_sql = " SELECT * FROM azwb_file WHERE azwb01 = ? FOR UPDATE "
   LET g_sql = cl_forupd_sql(g_sql)
   LET g_gat02 = g_lang CLIPPED

   DECLARE global_setting_cl CURSOR FROM g_sql
 
   OPEN WINDOW global_setting_w WITH FORM "azz/42f/p_global_setting" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL global_setting_init()
   
   #-----指定combo gat06的值-------------#
    DECLARE p_gat06_cur CURSOR FOR SELECT gao01 FROM gao_file ORDER BY gao01
    FOREACH p_gat06_cur INTO l_gat06
       IF cl_null(l_gat06_t) THEN
          LET l_gat06_t=l_gat06 CLIPPED
       ELSE
          LET l_gat06_t=l_gat06_t CLIPPED,",",l_gat06 CLIPPED
       END IF
    END FOREACH
    CALL cl_set_combo_items("gat06_l_1",l_gat06_t,l_gat06_t)
    #-------------------------------------#
 
   LET g_action_choice = ""
   CALL global_setting_menu()
 
   CLOSE WINDOW global_setting_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN

FUNCTION global_setting_init() #初始環境設定
   INITIALIZE g_azwb.* TO NULL 
   INITIALIZE g_azwe.* TO NULL 
   CALL g_tb.clear()
   CALL g_tb1.clear()
   CALL g_tb2.clear()
   CALL g_tb3.clear()
   CALL g_tb4.clear()
   CALL g_tb2_t.clear()
   INITIALIZE g_global_azwb01 TO NULL
   INITIALIZE g_global_azwe01 TO NULL
   INITIALIZE g_global_gat03 TO NULL
   INITIALIZE g_global_r_azwe01 TO NULL
   INITIALIZE g_global_r_gat03 TO NULL
   LET g_db_type=cl_db_get_database_type() 
END FUNCTION

FUNCTION global_setting_menu()
   DEFINE l_cmd     LIKE type_file.chr1000   # VARCHAR2(1000)
   
   WHILE TRUE
      CALL global_setting_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL global_setting_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               IF g_action_choice_t = "group_pg" THEN
                  CALL global_setting_group_b() 
               ELSE
                  CALL global_setting_b()
               END IF
            END IF
         WHEN "delete"                          # R.取消
           IF cl_chk_act_auth() THEN
              CALL global_setting_r()
           END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL global_setting_q()
            END IF
         WHEN "item_list"                       # 瀏覽頁籤
            IF cl_chk_act_auth() THEN
               CALL global_setting_list_menu()
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

FUNCTION global_setting_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_action_flag = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL ui.Dialog.setDefaultUnbuffered(TRUE)  #設定DIALOG全程都是UNBUFFERED

   DIALOG   
      DISPLAY ARRAY g_tb1 TO s_tb1.* 
      END DISPLAY

      DISPLAY ARRAY g_tb2 TO s_tb2.* 
      END DISPLAY
   
      DISPLAY ARRAY g_tb3 TO s_tb3.* 
      END DISPLAY
   
      DISPLAY ARRAY g_tb4 TO s_tb4.* 
      END DISPLAY

      BEFORE DIALOG
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL cl_set_act_visible("data_group", FALSE)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
 
      ON ACTION item_list                    #瀏覽頁籤
         LET g_action_choice = "item_list"  
         LET g_action_choice_t  = " "
         EXIT DIALOG 
         
      ON ACTION group_pg                     #資料群組設定頁籤
         LET g_action_choice = "group_pg"
         LET g_action_choice_t = "group_pg"
         CALL cl_set_comp_visible("l_ref_azwe01,l_ref_gat03", FALSE)
         CALL cl_set_act_visible("data_group", TRUE)
         
      ON ACTION global_pg                    #Global欄位設定頁籤
         LET g_action_choice = "global_pg"  
         LET g_action_choice_t  = " "
         CALL cl_set_comp_visible("l_ref_azwe01,l_ref_gat03", TRUE)
#         CALL cl_set_act_visible("data_group", FALSE)
         
      ON ACTION data_group
         LET g_action_choice = "data_group"
         CALL cl_cmdrun("aooi933")
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG 
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG 
 
      ON ACTION modify
         LET g_action_choice="modify"
         LET g_action_flag = "modify"
         EXIT DIALOG 
 
      ON ACTION first
         CALL global_setting_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN                 
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
         LET g_action_choice="first"
         EXIT DIALOG 
 
      ON ACTION previous
         CALL global_setting_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN                
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
         LET g_action_choice="previous"
         EXIT DIALOG 
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CALL global_setting_fetch('/')
         CALL cl_set_act_visible("accept,cancel", FALSE)
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b1 != 0 THEN             
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
         LET g_action_choice="jump"
         EXIT DIALOG 
 
      ON ACTION next
         CALL global_setting_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN       
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
         LET g_action_choice="next"
         EXIT DIALOG 
 
      ON ACTION last
         CALL global_setting_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b1 != 0 THEN        
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
         LET g_action_choice="last"
         EXIT DIALOG 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
 
      ON ACTION help
          LET g_action_choice='help'
          EXIT DIALOG 
 
      ON ACTION exit
         LET g_action_choice='exit'
         EXIT DIALOG 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about    
         CALL cl_about()   
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) 
         LET INT_FLAG=FALSE  
         LET g_action_choice='exit'
         EXIT DIALOG 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CALL cl_set_comp_visible("l_ref_azwe01,l_ref_gat03", TRUE)
END FUNCTION

FUNCTION global_setting_curs()
 
   CLEAR FORM
   CALL g_tb.clear()
   CONSTRUCT g_wc ON azwb01 FROM l_azwe01

      ON ACTION controlp
         CASE
             WHEN INFIELD(l_azwe01)       #Table Name
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azwb01"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.arg1     = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO l_azwe01
                  NEXT FIELD l_azwe01
               OTHERWISE EXIT CASE
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
   END CONSTRUCT
   
   IF INT_FLAG THEN
      RETURN
   END IF
   CALL global_setting_declare_curs()
END FUNCTION

FUNCTION global_setting_declare_curs()

   LET g_sql = "SELECT DISTINCT(azwb01) FROM azwb_file ",
               " WHERE ",g_wc CLIPPED,
               " ORDER BY azwb01"

   PREPARE p_global_setting_prepare FROM g_sql
   DECLARE p_global_setting_curs SCROLL CURSOR WITH HOLD FOR p_global_setting_prepare
 
   DECLARE p_global_setting_list_cur CURSOR FOR p_global_setting_prepare
 
   LET g_sql= "SELECT COUNT(DISTINCT(azwb01)) FROM azwb_file WHERE ",g_wc CLIPPED
   PREPARE p_global_setting_precount FROM g_sql
   DECLARE p_global_setting_count CURSOR FOR p_global_setting_precount
END FUNCTION

FUNCTION global_setting_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    MESSAGE ""
    CALL cl_opmsg('q')
#    DISPLAY '   ' TO FORMONLY.cnt
    CALL global_setting_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CALL global_setting_init()
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Searching!"
    OPEN p_global_setting_count
    FETCH p_global_setting_count INTO g_row_count
#    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN p_global_setting_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_global_azwb01,SQLCA.sqlcode,0)
        INITIALIZE g_azwb.* TO NULL
    ELSE
        CALL global_setting_list_fill()
        CALL global_setting_fetch('F')                  # 讀出TEMP第一筆並顯示 
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION global_setting_list_fill()
  DEFINE l_azwb01        LIKE azwb_file.azwb01
  DEFINE l_i             LIKE type_file.num10
 
    CALL g_tb.clear()
    LET l_i = 1
    FOREACH p_global_setting_list_cur INTO l_azwb01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT DISTINCT(azwb01),gat03,gat06 INTO g_tb[l_i].* FROM azwb_file 
         LEFT OUTER JOIN gat_file ON azwb01 = gat01 
         WHERE azwb01 = l_azwb01 AND gat02 = g_gat02
       
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          CALL cl_err('', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_tb TO s_tb.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
END FUNCTION

FUNCTION global_setting_fetch(p_flima)
    DEFINE
        p_flima          LIKE type_file.chr1    # VARCHAR(1)
 
    CASE p_flima
        WHEN 'N' FETCH NEXT     p_global_setting_curs INTO g_global_azwb01
        WHEN 'P' FETCH PREVIOUS p_global_setting_curs INTO g_global_azwb01
        WHEN 'F' FETCH FIRST    p_global_setting_curs INTO g_global_azwb01
        WHEN 'L' FETCH LAST     p_global_setting_curs INTO g_global_azwb01
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
            FETCH ABSOLUTE g_jump p_global_setting_curs INTO g_global_azwb01
            LET mi_no_ask = FALSE 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_global_azwb01,SQLCA.sqlcode,0)
        CALL global_setting_init()
        RETURN
    ELSE
      CASE p_flima
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
    
    #SELECT * INTO g_azwb.* FROM azwb_file           # 重讀DB,因TEMP有不被更新特性
    #   WHERE azwb01 = g_azwb.azwb01
             
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","azwb_file",g_global_azwb01,"",SQLCA.sqlcode,"","",1) 
    ELSE
        LET g_global_azwe01 = g_global_azwb01
        CALL global_setting_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION global_setting_show()
   
#   LET g_global_azwe01 = g_azwb.azwb01
   DISPLAY g_global_azwe01 TO FORMONLY.l_azwe01
  
   SELECT gat03 INTO g_global_gat03 FROM gat_file 
     WHERE gat01 = g_global_azwe01 AND gat02 = g_gat02
   DISPLAY g_global_gat03 TO FORMONLY.l_gat03
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gat_file",g_global_azwb01,"",SQLCA.sqlcode,"","",1) 
   END IF

   CALL cl_show_fld_cont()     
   CALL global_setting_b_fill()
END FUNCTION

FUNCTION global_setting_tb1()   #將欲設定TABLE 所有欄位撈出來
   DEFINE idx             LIKE type_file.num5   
   DEFINE l_ispk          BOOLEAN,
          l_field_pks     STRING
   DEFINE l_st            base.StringTokenizer
   DEFINE l_sql           STRING

   CALL g_tb1.clear()
   IF cl_null(g_global_azwe01) THEN EXIT PROGRAM END IF
   
   #找出Table屬於PK欄位
   CALL global_setting_pk() RETURNING l_field_pks
   LET l_st = base.StringTokenizer.create(l_field_pks,",")
   WHILE l_st.hasmoretokens()
      CALL g_pks.appendElement()
      LET g_pks[g_pks.getLength()] = l_st.nextToken()
   END WHILE

   CALL cl_query_prt_temptable()     #No.FUN-A60085

#   CALL cl_query_prt_getlength(g_global_azwe01,'N','m','0')    #呼叫lib產生xabc Temp Table
   CASE g_db_type               
       WHEN "IFX"                
      
       WHEN "ORA"               
          CALL cl_query_prt_getlength(g_global_azwe01,'N','m','0')    #呼叫lib產生xabc Temp Table
          LET l_sql = "SELECT xabc02,xabc03 FROM xabc ORDER BY xabc01"
 
       WHEN "MSV"                 
          LET l_sql = "SELECT gaq01, gaq03 FROM gaq_file ",
                      " WHERE gaq01 IN (SELECT b.name ",
                      "    FROM sys.objects a, sys.columns b, sys.types c ",
                      "    WHERE a.name='", g_global_azwe01 CLIPPED, "'",
                      "       AND a.object_id=b.object_id ",
                      "       AND b.user_type_id=c.user_type_id) ",
                      "    AND gaq02='",g_lang,"'",
                      " ORDER BY gaq01"
   END CASE     

   PREPARE p_global_setting_c1_col FROM l_sql    
   DECLARE p_global_setting_c1 CURSOR FOR p_global_setting_c1_col
#        SELECT xabc02,xabc03 FROM xabc ORDER BY xabc01
   LET idx = 1
   FOREACH p_global_setting_c1 INTO g_tb1[idx].ztb03, g_tb1[idx].gaq03
      LET l_ispk = global_setting_is_pk(g_tb1[idx].ztb03 CLIPPED)
      LET g_tb1[idx].sel = FALSE
      LET g_tb1[idx].pk = FALSE
      LET g_tb1[idx].pk = l_ispk   #'pk' 打勾
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET idx = idx + 1
      IF idx > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH   
   CALL g_tb1.deleteElement(idx)
END FUNCTION

FUNCTION global_setting_tb2()   #將已存在azwb_file之 TABLE 欄位撈出來
   DEFINE idx         LIKE type_file.num5   
   DEFINE l_azwb02    LIKE azwb_file.azwb02

   CALL g_tb2.clear()
   IF cl_null(g_global_azwe01) THEN EXIT PROGRAM END IF
   
   CALL cl_query_prt_temptable()     #No.FUN-A60085
        
   IF g_db_type != "MSV" THEN
      CALL cl_query_prt_getlength(g_global_azwe01,'N','m','0')    #呼叫lib產生xabc Temp Table
   END IF
   
   DECLARE p_global_setting_c2 CURSOR FOR
        SELECT azwb02 FROM azwb_file WHERE azwb01 = g_global_azwe01
        
   LET idx = 1
   FOREACH p_global_setting_c2 INTO l_azwb02   
      CASE g_db_type               
         WHEN "IFX"                
      
         WHEN "ORA"        
            SELECT xabc02,xabc03 INTO g_tb2[idx].azwb02, g_tb2[idx].gaq03 
               FROM xabc WHERE xabc02=l_azwb02 
          WHEN "MSV"                 
            SELECT gaq01, gaq03 INTO g_tb2[idx].azwb02, g_tb2[idx].gaq03 
               FROM gaq_file WHERE gaq01 = l_azwb02 AND gaq02=g_lang
      END CASE  
    
#      SELECT xabc02,xabc03 INTO g_tb2[idx].azwb02, g_tb2[idx].gaq03 FROM xabc 
#        WHERE xabc02=l_azwb02 ORDER BY xabc01
      LET g_tb2[idx].sel = FALSE
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET idx = idx + 1
      IF idx > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   
   CALL g_tb2.deleteElement(idx)
END FUNCTION

FUNCTION global_setting_tb2_t_fill()   
   DEFINE idx         LIKE type_file.num5   
   DEFINE l_cnt       LIKE type_file.num5   
   DEFINE l_azwb02    LIKE azwb_file.azwb02

   IF cl_null(g_global_azwe01) THEN EXIT PROGRAM END IF

   CALL g_tb2_t.clear()
   LET l_cnt = g_tb2.getlength()
   FOR idx=1 TO l_cnt
       LET g_tb2_t[idx].* = g_tb2[idx].*
   END FOR
   
   CALL g_tb2_t.deleteElement(idx)
END FUNCTION

FUNCTION global_setting_tb3()   #將Group頁籤屬於該TABLE 所有營運中心撈出來
   DEFINE idx         LIKE type_file.num5  

   CALL g_tb3.clear()
   IF cl_null(g_global_azwe01) THEN EXIT PROGRAM END IF

   DECLARE p_global_setting_c3 CURSOR FOR
        SELECT azwe03,azw08,azwe02 FROM azwe_file 
          LEFT OUTER JOIN azw_file ON azwe_file.azwe03 = azw_file.azw01
          WHERE azwe_file.azwe01 = g_global_azwe01           
          GROUP BY azwe02,azwe03,azw08
          ORDER BY azwe02,azwe03
   LET idx = 1
   FOREACH p_global_setting_c3 INTO g_tb3[idx].azwe03, g_tb3[idx].azw08, g_tb3[idx].azwe02
      LET g_tb3[idx].sel = FALSE
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET idx = idx + 1
      IF idx > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
  
   CALL g_tb3.deleteElement(idx)
END FUNCTION

FUNCTION global_setting_tb4()   #將所有資料群組撈出來
   DEFINE idx         LIKE type_file.num5  

   CALL g_tb4.clear()
   IF cl_null(g_global_azwe01) THEN EXIT PROGRAM END IF

   DECLARE p_global_setting_c4 CURSOR FOR
        SELECT azwc01,azwc02 FROM azwc_file 
          WHERE azwcacti='Y'
          ORDER BY azwc01
   LET idx = 1
   FOREACH p_global_setting_c4 INTO g_tb4[idx].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET idx = idx + 1
      IF idx > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
  
   CALL g_tb4.deleteElement(idx)
END FUNCTION

FUNCTION global_setting_b_fill()

   CALL global_setting_tb1()
   CALL global_setting_tb2()
   CALL global_setting_tb3()
   CALL global_setting_tb4()
END FUNCTION

FUNCTION global_setting_list_menu()
   DEFINE   l_cmd     LIKE type_file.chr1000
 
   WHILE TRUE
 
      CALL global_setting_list_bp("G")  
 
    LET g_sql = "SELECT DISTINCT(azwb01) FROM azwb_file ",
               " WHERE ",g_wc CLIPPED,
               " ORDER BY azwb01"
               
      IF NOT cl_null(g_action_choice) AND g_ac1>0 THEN #將清單的資料回傳到主畫面
         SELECT DISTINCT(azwb01) INTO g_global_azwb01
           FROM azwb_file
          WHERE azwb01=g_tb[g_ac1].azwb01
          LET g_global_azwe01 = g_global_azwb01
      END IF
 
      IF g_action_choice!= "" THEN
         LET g_bp_flag = 'main'
         LET g_ac1 = ARR_CURR()
         LET g_jump = g_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL global_setting_fetch('/')
         END IF
         CALL cl_set_comp_visible("page112", FALSE)
         CALL cl_set_comp_visible("pagegroup", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page112", TRUE)
         CALL cl_set_comp_visible("pagegroup", TRUE)
       END IF
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN  
               CALL global_setting_a()
            END IF
            EXIT WHILE
 
        WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL global_setting_q()
            END IF
            EXIT WHILE
        
        WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL global_setting_r()
            END IF
 
        WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL global_setting_b()
            END IF
            EXIT WHILE
 
        WHEN "help"
            CALL cl_show_help()
 
        WHEN "controlg"
            CALL cl_cmdask()
 
        WHEN "locale"
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
 
        WHEN "exit"
            EXIT WHILE
 
        WHEN "g_idle_seconds"
            CALL cl_on_idle()
 
        WHEN "about"      
            CALL cl_about()      
 
        OTHERWISE 
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION   

FUNCTION global_setting_list_bp(p_ud)
   DEFINE   p_ud      LIKE type_file.chr1          #VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_tb TO s_tb.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
 
      BEFORE ROW
         LET g_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION main
         LET g_bp_flag = 'main'
         LET g_ac1 = ARR_CURR()
         LET g_jump = g_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL global_setting_fetch('/')
         END IF
         CALL cl_set_comp_visible("page112", FALSE)
         CALL cl_set_comp_visible("pagegroup", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page112", TRUE)
         CALL cl_set_comp_visible("pagegroup", TRUE)
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_ac1 = ARR_CURR()
         IF g_ac1 <> 0 THEN
            LET g_jump = g_ac1
            LET mi_no_ask = TRUE
            LET g_bp_flag = NULL
            CALL global_setting_fetch('/')
            CALL cl_set_comp_visible("pagegroup", FALSE)
            CALL cl_set_comp_visible("pagegroup", TRUE)
            CALL cl_set_comp_visible("page112", FALSE)  
            CALL ui.interface.refresh()               
            CALL cl_set_comp_visible("page112", TRUE)  
            EXIT DISPLAY
         END IF
 
      ON ACTION first
         CALL global_setting_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION previous
         CALL global_setting_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)
         CALL global_setting_fetch('/')
         CALL cl_set_act_visible("accept,cancel", FALSE)
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION next
         CALL global_setting_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION last
         CALL global_setting_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)
         END IF
         CONTINUE DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"  
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"  
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION cancel
         LET INT_FLAG=FALSE    
         LET g_action_choice="exit" 
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about       
         LET g_action_choice="about" 
         EXIT DISPLAY    
     
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF INT_FLAG THEN
      CALL cl_set_comp_visible("list", FALSE)
      CALL cl_set_comp_visible("pagegroup", FALSE)
      CALL ui.interface.refresh()
      CALL cl_set_comp_visible("list", TRUE)
      CALL cl_set_comp_visible("pagegroup", TRUE)
      LET INT_FLAG = 0
   END IF
END FUNCTION

FUNCTION global_setting_a()
   LET g_wc = NULL
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL global_setting_init()
   CALL cl_opmsg('a')
 
   WHILE TRUE
  
      CALL global_setting_i("a")               # 各欄位輸入
 
      IF INT_FLAG THEN                         # 若按了DEL鍵
         CALL global_setting_init()
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
 
      IF g_global_azwe01 IS NULL THEN         # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      LET g_rec_b1 = 0
      
#      LET g_azwb.azwb01 = g_global_azwe01
      LET g_global_azwb01 = g_global_azwe01
 
      IF g_ss='N' THEN
         CALL g_tb.CLEAR()
         CALL g_tb1.CLEAR()
         CALL g_tb2.CLEAR()
         CALL g_tb3.CLEAR()
         CALL g_tb4.CLEAR()
         CALL g_tb2_t.CLEAR()
      ELSE
         CALL global_setting_b_fill()         # 單身
      END IF
 
      CALL global_setting_b()                 # 輸入單身
      LET g_global_azwe01_t=g_global_azwe01
      LET g_global_azwb01_t=g_global_azwb01
      EXIT WHILE
   END WHILE
END FUNCTION   

FUNCTION global_setting_b()
DEFINE l_cnt  LIKE type_file.num5

   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_global_azwe01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
   CALL global_setting_tb2_t_fill()

   DIALOG ATTRIBUTES(UNBUFFERED = TRUE)      
      INPUT ARRAY g_tb1 FROM s_tb1.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE, #GLOBAL TABLE不能做異動
                                                       APPEND ROW=FALSE,AUTO APPEND=FALSE,
                                                       DELETE ROW=FALSE,INSERT ROW=FALSE)
         BEFORE INPUT
            CALL DIALOG.setActionHidden("accept", FALSE)
            CALL DIALOG.setActionActive("to_left",FALSE)
            CALL DIALOG.setActionActive("select_all01",TRUE)
            CALL DIALOG.setActionActive("cancel_all01",TRUE)

         ON CHANGE l_sel01
            IF g_tb1[ARR_CURR()].pk = TRUE THEN       #檢查是否為PK，PK不能選
               LET g_tb1[ARR_CURR()].sel = FALSE
            END IF

         ON ACTION to_right
            CALL global_setting_to_right()

         ON ACTION select_all01
            CALL global_setting_tb1_selectAll()
            
         ON ACTION cancel_all01
            CALL global_setting_tb1_cancelAll()
      END INPUT
      
      INPUT ARRAY g_tb2 FROM s_tb2.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE,
                                                       AUTO APPEND=FALSE,
                                                       INSERT ROW=FALSE)
         BEFORE INPUT
            CALL DIALOG.setActionHidden("accept", FALSE)
            CALL DIALOG.setActionActive("to_right",FALSE)
            CALL DIALOG.setActionActive("select_all02",TRUE)
            CALL DIALOG.setActionActive("cancel_all02",TRUE)

         ON ACTION to_left
            CALL global_setting_to_left()

         ON ACTION select_all02
            CALL global_setting_tb2_selectAll()
         
         ON ACTION cancel_all02
            CALL global_setting_tb2_cancelAll()
      END INPUT
      
      ON ACTION group_pg
         SELECT count(*) INTO l_cnt FROM azwb_file
           WHERE azwb01 = g_global_azwe01 
         IF l_cnt = 0 OR g_tb2.getlength()= 0 THEN          #azwb_file尚無新增此Local table資料
            CALL cl_err_msg('','azz1044','',10)
            CONTINUE DIALOG
         ELSE
            LET g_action_choice = "group_pg"  
            LET g_action_choice_t = "group_pg"
            EXIT DIALOG 
         END IF

      ON ACTION accept
         IF NOT g_tb2.getlength()= 0 THEN
            LET g_action_choice = "accept"  
            EXIT DIALOG 
         ELSE
            IF (cl_confirm("azz1046")) THEN
               LET g_action_choice = "accept"  
               EXIT DIALOG 
            ELSE
               CONTINUE DIALOG
            END IF
         END IF
         
      ON ACTION cancel
         LET g_action_choice = "cancel"
         EXIT DIALOG
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"  
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about       
         LET g_action_choice="about" 
         EXIT DIALOG    

      ON ACTION exit
         EXIT PROGRAM
   END DIALOG

   CASE g_action_choice
      WHEN "cancel"   #按了放棄，會將s_tb2清單初始化。
         CALL global_setting_b_fill()  
      WHEN "group_pg" 
         CALL global_setting_group_b() 
      WHEN "accept"
         BEGIN WORK 
         IF NOT global_setting_a_ins() THEN 
            ROLLBACK WORK    
         ELSE
            COMMIT WORK
            MESSAGE 'INSERT O.K'
            IF NOT g_action_flag = "modify" THEN
               CALL global_setting_group_b()             
            END IF
         END IF
      WHEN "help"
         CALL cl_show_help()
 
      WHEN "controlg"
         CALL cl_cmdask()
 
      WHEN "about"      
         CALL cl_about()     
   END CASE   
END FUNCTION  

FUNCTION global_setting_group_b()
   DEFINE l_ac     LIKE type_file.num10
   DEFINE l_err    BOOLEAN
   
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_global_azwe01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
 
   CALL cl_opmsg('b')
   
   LET l_err = FALSE
   CALL cl_set_comp_visible("l_ref_azwe01,l_ref_gat03", FALSE)
   CALL cl_set_act_visible("data_group", TRUE)

   DIALOG ATTRIBUTES(UNBUFFERED = TRUE)
      
      INPUT ARRAY g_tb3 FROM s_tb3.* ATTRIBUTES(WITHOUT DEFAULTS=TRUE, 
                                                       APPEND ROW=FALSE,AUTO APPEND=FALSE,
                                                       DELETE ROW=FALSE,INSERT ROW=FALSE)
         BEFORE INPUT
            CALL DIALOG.setActionActive("select_all03",TRUE)
            CALL DIALOG.setActionActive("cancel_all03",TRUE)

         ON ACTION select_all03
            CALL global_setting_tb3_selectAll()
            
         ON ACTION cancel_all03
            CALL global_setting_tb3_cancelAll()
      END INPUT

      DISPLAY ARRAY g_tb4 TO s_tb4.* 
         BEFORE DISPLAY
            LET l_ac = 0

         BEFORE ROW
            LET l_ac = ARR_CURR() 
      END DISPLAY
      
      ON ACTION to_modify
         LET l_err = FALSE
         IF NOT global_setting_tb3_chkSelect() THEN
            LET l_err = TRUE
            CALL cl_err_msg('','azz1041','',10)
            CONTINUE DIALOG
         END IF
         IF l_ac = 0 THEN
            LET l_err = TRUE
            CALL cl_err_msg('','azz1043','',10)
            CONTINUE DIALOG
         END IF
         IF g_tb4[l_ac].azwc01 != 'Global' THEN
            IF NOT global_setting_tb3_chkGlobal() THEN
               LET l_err = TRUE
               CALL cl_err_msg('','azz1042','',10)
               CONTINUE DIALOG
            END IF
         END IF
         IF NOT l_err THEN
            LET g_action_choice = "to_modify"
            EXIT DIALOG
         END IF
         
      ON ACTION data_group
         LET g_action_choice = "data_group"
         CALL cl_cmdrun("aooi933")
         
      ON ACTION global_pg
         LET g_action_choice = "global_pg"  
         LET g_action_choice_t  = " "
         EXIT DIALOG 
         
      ON ACTION cancel
         LET g_action_choice = "cancel"
         EXIT DIALOG
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"  
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about       
         LET g_action_choice="about" 
         EXIT DIALOG    

      ON ACTION exit
         EXIT PROGRAM
   END DIALOG

   CALL cl_set_comp_visible("l_ref_azwe01,l_ref_gat03", TRUE)   
   CASE g_action_choice
      WHEN "global_pg"
         CALL global_setting_b()
      WHEN "cancel"
         CALL global_setting_b_fill()
      WHEN "to_modify"
         CALL global_setting_group_u(g_tb4[l_ac].azwc01)
         CALL global_setting_b_fill()
      WHEN "help"
         CALL cl_show_help()
      WHEN "controlg"
         CALL cl_cmdask()
      WHEN "about"      
         CALL cl_about()     
   END CASE
   CALL cl_set_comp_visible("l_ref_azwe01,l_ref_gat03", TRUE)  
END FUNCTION 

FUNCTION global_setting_r()
   DEFINE   l_cnt     LIKE type_file.num5,          #SMALLINT
            l_azwb    RECORD LIKE azwb_file.*,
            l_azwe    RECORD LIKE azwe_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_global_azwe01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF (cl_confirm("azz1045")) THEN                   #確認一下
      DELETE FROM azwb_file
       WHERE azwb01 = g_global_azwe01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","azwb_file",g_global_azwe01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         DELETE FROM azwe_file
          WHERE azwe01=g_global_azwe01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","azwb_file",g_global_azwe01,"",SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
         ELSE
            COMMIT WORK
            CLEAR FORM
            CALL g_tb.clear()
            CALL g_tb2.clear()
            CALL g_tb2_t.clear()
            CALL g_tb3.clear()
#            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN p_global_setting_count
            FETCH p_global_setting_count INTO g_row_count
            OPEN p_global_setting_curs  
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL global_setting_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL global_setting_fetch('/')
            END IF
         END IF
      END IF
   END IF
   COMMIT WORK
   CALL global_setting_list_fill()
   MESSAGE 'DELETE O.K'
END FUNCTION 

FUNCTION global_setting_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,    #VARCHAR(1)
          l_cmd           LIKE type_file.chr1000  #VARCHAR(80)
   DEFINE l_cnt           LIKE type_file.num5
   
   LET g_ss = 'Y'
   LET g_global_azwe01 = NULL
   LET g_global_azwb01 = NULL
   LET g_global_gat03 = NULL
   LET g_global_r_azwe01 = NULL
   LET g_global_r_gat03 = NULL
   
   DISPLAY g_global_azwe01,g_global_gat03,g_global_r_azwe01,g_global_r_gat03
     TO l_azwe01,l_gat03,l_ref_azwe01,l_ref_gat03

   IF p_cmd = 'u' THEN LET g_azwb.azwbdate = g_today END IF

   INPUT g_global_azwe01,g_global_r_azwe01 FROM l_azwe01,l_ref_azwe01 ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
            
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            LET g_global_azwb01 = g_global_azwe01
            LET g_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_global_azwe01 IS NULL THEN
               NEXT FIELD l_azwe01
            END IF
            IF NOT cl_null(g_global_azwb01) THEN
               IF g_global_azwb01 != g_global_azwb01_t THEN
                  SELECT COUNT(UNIQUE azwb01) INTO l_cnt FROM azwb_file
                    WHERE azwb01=g_global_azwb01
                  IF l_cnt > 0 THEN
                     LET g_ss = 'Y'
                  END IF
               END IF
            END IF
            
        AFTER FIELD l_azwe01                  #需設定之Table
            IF NOT cl_null(g_global_azwe01) THEN
               SELECT count(*) INTO l_cnt FROM zta_file
                 LEFT OUTER JOIN gat_file ON zta01 = gat01 
                 WHERE zta01 = g_global_azwe01 AND gat07 = 'M'
               IF l_cnt = 0 THEN          #查無此Table--檢查此Table是否存在zta_file
                  CALL cl_err_msg('','azz1039',g_global_azwe01, 10)
                  LET g_global_azwe01 = g_global_azwe01_t
                  LET g_global_azwb01 = g_global_azwe01
                  LET g_global_azwb01_t = g_global_azwb01
                  DISPLAY "" TO FORMONLY.l_gat03
                  NEXT FIELD l_azwe01
               END IF
               
               SELECT COUNT(UNIQUE azwe01) INTO l_cnt FROM azwe_file
                 WHERE azwe01=g_global_azwe01
               IF l_cnt > 0 THEN
                  LET g_ss = 'Y'
               END IF
            END IF   
            IF NOT cl_null(g_global_azwe01) THEN           
               SELECT gat03 INTO g_global_gat03 FROM gat_file 
                 WHERE gat01 = g_global_azwe01 AND gat02 = g_gat02
               DISPLAY g_global_gat03 TO FORMONLY.l_gat03
            ELSE
               DISPLAY "" TO FORMONLY.l_gat03
            END IF
            
         AFTER FIELD l_ref_azwe01                   #需參考之Table
            IF NOT cl_null(g_global_r_azwe01) THEN
               IF g_global_azwe01 = g_global_r_azwe01 THEN
                  CALL cl_err_msg('','azz1047',g_global_r_azwe01, 10)
                  LET g_global_r_azwe01 = g_global_r_azwe01_t
                  DISPLAY "" TO FORMONLY.l_ref_azwe01
                  DISPLAY "" TO FORMONLY.l_ref_gat03
                  NEXT FIELD l_ref_azwe01
               END IF
               SELECT count(*) INTO l_cnt FROM azwe_file
                 WHERE azwe01 = g_global_r_azwe01 
               IF l_cnt = 0 THEN          #查無此Table
                  CALL cl_err_msg('','azz1040',g_global_r_azwe01, 10)
                  LET g_global_r_azwe01 = g_global_r_azwe01_t
                  DISPLAY "" TO FORMONLY.l_ref_azwe01
                  DISPLAY "" TO FORMONLY.l_ref_gat03
                  NEXT FIELD l_ref_azwe01
               END IF
            END IF
            IF NOT cl_null(g_global_r_azwe01) THEN         
               SELECT gat03 INTO g_global_r_gat03 FROM gat_file 
                 WHERE gat01 = g_global_r_azwe01 AND gat02 = g_gat02
               DISPLAY g_global_r_gat03 TO FORMONLY.l_ref_gat03
            ELSE
               DISPLAY "" TO FORMONLY.l_ref_gat03
            END IF
            
         ON ACTION controlp
            CASE
               WHEN INFIELD(l_azwe01) #需設定之Table
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_zta02"
                  LET g_qryparam.default1 = g_global_azwe01
                  LET g_qryparam.default1 = g_global_gat03 
                  LET g_qryparam.arg1     = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_global_azwe01,g_global_gat03 
                  DISPLAY g_global_azwe01 TO l_azwe01
                  DISPLAY g_global_gat03 TO FORMONLY.l_gat03
                  NEXT FIELD l_azwe01
                  
                WHEN INFIELD(l_ref_azwe01) #需參考之Table
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_azwe01"
                  LET g_qryparam.default1 = g_global_r_azwe01
                  LET g_qryparam.default1 = g_global_r_gat03 
                  LET g_qryparam.arg1     = g_lang CLIPPED
                  IF cl_null(g_global_azwe01) THEN
                     LET g_qryparam.arg2 = " "
                  ELSE
                     LET g_qryparam.arg2 = g_global_azwe01
                  END IF
                  CALL cl_create_qry() RETURNING g_global_r_azwe01,g_global_r_gat03 
                  DISPLAY g_global_r_azwe01 TO l_ref_azwe01
                  DISPLAY g_global_r_gat03 TO FORMONLY.l_ref_gat03
                  NEXT FIELD l_ref_azwe01
             OTHERWISE EXIT CASE
            END CASE
 
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
    END INPUT
END FUNCTION

FUNCTION global_setting_tb1_selectAll()
   DEFINE idx      LIKE type_file.num5   

   FOR idx=1 TO g_tb1.getlength()
       LET g_tb1[idx].sel = TRUE
       IF g_tb1[idx].pk = TRUE THEN       #檢查是否為PK，PK不能選
          LET g_tb1[idx].sel = FALSE
       END IF
   END FOR
END FUNCTION

FUNCTION global_setting_tb1_cancelAll()
   DEFINE idx      LIKE type_file.num5  

   FOR idx=1 TO g_tb1.getlength()
       LET g_tb1[idx].sel = FALSE
   END FOR
END FUNCTION

FUNCTION global_setting_tb2_selectAll()
   DEFINE idx      LIKE type_file.num5   

   FOR idx=1 TO g_tb2.getlength()
       LET g_tb2[idx].sel = TRUE
   END FOR
END FUNCTION

FUNCTION global_setting_tb2_cancelAll()
   DEFINE idx      LIKE type_file.num5  

   FOR idx=1 TO g_tb2.getlength()
       LET g_tb2[idx].sel = FALSE
   END FOR
END FUNCTION

FUNCTION global_setting_tb3_selectAll()
   DEFINE idx      LIKE type_file.num5   

   FOR idx=1 TO g_tb3.getlength()
       LET g_tb3[idx].sel = TRUE
   END FOR
END FUNCTION

FUNCTION global_setting_tb3_cancelAll()
   DEFINE idx      LIKE type_file.num5  

   FOR idx=1 TO g_tb3.getlength()
       LET g_tb3[idx].sel = FALSE
   END FOR
END FUNCTION

FUNCTION global_setting_tb3_chkSelect()
   DEFINE idx      LIKE type_file.num5   

   FOR idx=1 TO g_tb3.getlength()
       IF g_tb3[idx].sel = TRUE THEN
          RETURN TRUE
       END IF
   END FOR
   RETURN FALSE
END FUNCTION

FUNCTION global_setting_tb3_chkGlobal()
   DEFINE idx      LIKE type_file.num5   
   DEFINE l_global BOOLEAN
   
   LET l_global = FALSE
   FOR idx=1 TO g_tb3.getlength()
       IF g_tb3[idx].sel = FALSE THEN
          IF g_tb3[idx].azwe02 = 'Global' THEN
             LET l_global = TRUE
             EXIT FOR
          END IF
       END IF
   END FOR
   RETURN l_global
END FUNCTION

FUNCTION global_setting_tb2_chk_exist(l_azwb02)
   DEFINE l_azwb02 LIKE azwb_file.azwb02   
   DEFINE idx      LIKE type_file.num5  
   DEFINE l_cnt    LIKE type_file.num5 
   
   LET l_cnt = g_tb2_t.getlength()
   FOR idx=1 TO l_cnt
       IF l_azwb02 = g_tb2_t[idx].azwb02 THEN
          RETURN TRUE
       END IF
   END FOR
   RETURN FALSE
END FUNCTION

FUNCTION global_setting_tb2_t_chk_exist(l_azwb02)
   DEFINE l_azwb02 LIKE azwb_file.azwb02   
   DEFINE idx      LIKE type_file.num5   
   DEFINE l_cnt    LIKE type_file.num5 

   LET l_cnt = g_tb2.getlength()
   FOR idx=1 TO l_cnt
       IF l_azwb02 = g_tb2[idx].azwb02 THEN
          RETURN TRUE
       END IF
   END FOR
   RETURN FALSE
END FUNCTION

FUNCTION global_setting_to_right()  #移動欄位至Global欄位清單
   DEFINE idx      INTEGER
   FOR idx = 1 TO g_tb1.getlength()
       IF g_tb1[idx].sel = TRUE AND g_tb1[idx].pk != TRUE THEN
          IF NOT global_setting_chk_exist(g_tb1[idx].ztb03) THEN
             CALL g_tb2.appendElement()
             LET g_tb2[g_tb2.getLength()].azwb02 = g_tb1[idx].ztb03
             LET g_tb2[g_tb2.getLength()].gaq03 = g_tb1[idx].gaq03
             LET g_tb2[g_tb2.getLength()].sel = FALSE
          END IF
          LET g_tb1[idx].sel = FALSE
       END IF
   END FOR
END FUNCTION

FUNCTION global_setting_chk_exist(l_ztb03)  #檢查是否已在清單之中
   DEFINE l_ztb03  STRING
   DEFINE idx      INTEGER
   FOR idx = 1 TO g_tb2.getLength()
       IF g_tb2[idx].azwb02 = l_ztb03 THEN
          RETURN TRUE
       END IF
   END FOR
   RETURN FALSE
END FUNCTION

FUNCTION global_setting_to_left() #移動欄位至Table所有欄位清單(實際上只是刪除Global欄位清單)
   DEFINE idx    INTEGER
   DEFINE l_tab2 DYNAMIC ARRAY OF t_tab2

   FOR idx = 1 TO g_tb2.getLength()                             #FOR迴圈中，無法直接使用deleteEelemtn(int)。
      IF g_tb2[idx].sel != TRUE THEN                            #所以先將沒有打勾的及pk放到暫存的ARRAY。再把
         CALL l_tab2.appendElement()                            #原本的ARRAY清空，再把暫存的倒回去。
         LET l_tab2[l_tab2.getLength()].* = g_tb2[idx].*
      END IF
   END FOR
   CALL g_tb2.clear()                       #清空原本的ARRAY
   FOR idx = 1 TO l_tab2.getLength()        #將暫存的ARRAY倒回去。
      LET g_tb2[idx].* = l_tab2[idx].*
   END FOR
END FUNCTION

FUNCTION global_setting_a_ins()
   DEFINE idx,idx_t      LIKE type_file.num5   
   DEFINE l_cnt          LIKE type_file.num5 

   LET l_cnt = g_tb2.getlength()
   #先檢查變更後欄位清單的每筆資料是否已有?s在DB中,沒有話採取Insert,有的話則不需再Insert
   FOR idx=1 TO l_cnt
      IF NOT cl_null(g_tb2[idx].azwb02) AND NOT global_setting_tb2_chk_exist(g_tb2[idx].azwb02) THEN
         LET g_azwb.azwb01 = g_global_azwe01
         LET g_azwb.azwb02 = g_tb2[idx].azwb02
         LET g_azwb.azwbuser=g_user
         LET g_azwb.azwbgrup=g_grup
         LET g_azwb.azwbdate=g_today
         LET g_azwb.azwborig=g_grup
         LET g_azwb.azwboriu=g_user
        
         INSERT INTO azwb_file VALUES(g_azwb.*)       # DISK WRITE
      END IF
   END FOR
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","azwb_file",g_global_azwe01,"",SQLCA.sqlcode,
                   "","",1) 
      RETURN FALSE
   END IF
   
   LET l_cnt = g_tb2_t.getlength()
   #再檢查變更後欄位清單的每筆資料是否有需從DB中刪除
   FOR idx_t=1 TO l_cnt
      IF NOT cl_null(g_tb2_t[idx_t].azwb02) AND NOT global_setting_tb2_t_chk_exist(g_tb2_t[idx_t].azwb02) THEN
          DELETE FROM azwb_file
            WHERE azwb01 = g_global_azwe01 AND azwb02 = g_tb2_t[idx_t].azwb02    # DISK WRITE
      END IF
   END FOR
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","azwb_file",g_tb2_t[idx_t].azwb02,"",SQLCA.sqlcode,
                   "","",1) 
      RETURN FALSE
   END IF
   
   IF cl_null(g_global_azwe01) THEN EXIT PROGRAM END IF
   
   #若g_global_azwe01在azwe_file中已存在資料,則不再做azwe_file之變更
   SELECT COUNT(UNIQUE azwe01) INTO l_cnt FROM azwe_file
     WHERE azwe01=g_global_azwe01
   IF l_cnt > 0 THEN
      SELECT COUNT(UNIQUE azwb01) INTO l_cnt FROM azwb_file
        WHERE azwb01=g_global_azwe01
      IF l_cnt = 0 THEN
         DELETE FROM azwe_file
            WHERE azwe01 = g_global_azwe01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","azwe_file",g_global_azwe01,"",SQLCA.sqlcode,
                         "","",1) 
            RETURN FALSE
         END IF   
      END IF
      CALL global_setting_tb3()
      RETURN TRUE
   END IF

   INITIALIZE g_azwe.* LIKE azwe_file.*
   IF cl_null(g_global_r_azwe01) THEN
      DECLARE p_global_setting_azw CURSOR FOR
         SELECT azw01 FROM azw_file WHERE azwacti='Y' ORDER BY azw01
      LET idx = 1
      FOREACH p_global_setting_azw INTO g_azwe.azwe03
         LET g_azwe.azwe01 = g_global_azwe01
         LET g_azwe.azwe02 = 'Global'
         LET g_azwe.azweuser=g_user
         LET g_azwe.azwegrup=g_grup
         LET g_azwe.azwedate=g_today
         LET g_azwe.azweorig=g_grup
         LET g_azwe.azweoriu=g_user
         
         INSERT INTO azwe_file VALUES(g_azwe.*)       # DISK WRITE
      END FOREACH
   ELSE
      DECLARE p_global_setting_azwe_r CURSOR FOR
         SELECT azwe02,azwe03 FROM azwe_file
           WHERE azwe01=g_global_r_azwe01
         ORDER BY azwe01
      LET idx = 1
      FOREACH p_global_setting_azwe_r INTO g_azwe.azwe02,g_azwe.azwe03
         LET g_azwe.azwe01 = g_global_azwe01
         LET g_azwe.azweuser=g_user
         LET g_azwe.azwegrup=g_grup
         LET g_azwe.azwedate=g_today
         LET g_azwe.azweorig=g_grup
         LET g_azwe.azweoriu=g_user
         
         INSERT INTO azwe_file VALUES(g_azwe.*)       # DISK WRITE
      END FOREACH
   END IF
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","azwe_file",g_global_azwe01,"",SQLCA.sqlcode,
                   "","",1) 
      RETURN FALSE
   END IF
   CALL global_setting_tb3()
   RETURN TRUE
END FUNCTION

FUNCTION global_setting_group_u(l_azwc01)
   DEFINE idx        LIKE type_file.num5   
   DEFINE l_azwc01   LIKE azwc_file.azwc01
   DEFINE l_cnt      LIKE type_file.num5   

   INITIALIZE g_azwe.* LIKE azwe_file.*
   LET g_sql= " SELECT * FROM azwe_file WHERE azwe01= ? AND azwe03= ?", #g_global_azwe01,g_tb3.azwe03
                          " FOR UPDATE "
   DECLARE p_global_setting_azwe CURSOR FROM g_sql

   LET l_cnt = g_tb3.getlength()
   BEGIN WORK
     WHILE TRUE
       FOR idx = 1 TO l_cnt
          OPEN p_global_setting_azwe USING g_global_azwe01,g_tb3[idx].azwe03
          IF STATUS THEN
             CALL cl_err("OPEN p_global_setting_azwe:", STATUS, 1)
             CLOSE p_global_setting_azwe
             ROLLBACK WORK
             RETURN
          END IF
          
          FETCH p_global_setting_azwe INTO g_azwe.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err("FETCH p_global_setting_azwe:", STATUS, 1)     # 資料被他人LOCK
             CLOSE p_global_setting_azwe
             ROLLBACK WORK
             RETURN
          END IF

          IF g_tb3[idx].sel = TRUE THEN
             IF INT_FLAG THEN
                LET INT_FLAG = 0
#                EXIT WHILE
                CALL cl_err('','9001',0)
#                EXIT WHILE
                ROLLBACK WORK
                RETURN 
             END IF
             UPDATE azwe_file SET (azwe02,azwemodu,azwedate)=(l_azwc01,g_user,g_today)
                WHERE azwe01 = g_global_azwe01 AND azwe03 = g_tb3[idx].azwe03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","azwe_file",g_tb3[idx].azwe03,"",SQLCA.sqlcode,"","azwe",0)   #No.FUN-660081
                CONTINUE WHILE 
             END IF
          END IF
          LET g_tb3[idx].sel = FALSE
       END FOR
       EXIT WHILE
     END WHILE
     CLOSE p_global_setting_azwe
   COMMIT WORK
   MESSAGE 'UPDATE O.K'
END FUNCTION


FUNCTION global_setting_pk()
DEFINE  l_sql           STRING
DEFINE  l_ztd03         LIKE ztd_file.ztd03,
        l_ztd04         LIKE ztd_file.ztd04
DEFINE  l_column_name   LIKE ztd_file.ztd13
DEFINE  l_schema        STRING,
        l_field_pks     STRING
DEFINE  l_zta02         LIKE zta_file.zta02 

    LET l_zta02=g_dbs

    IF cl_null(g_global_azwe01) OR cl_null(l_zta02) THEN
       CALL cl_err("",-400,0) RETURN
    END IF
    
    SELECT * INTO g_zta.* FROM zta_file 
      WHERE zta01 = g_global_azwe01 AND zta02 = l_zta02
      ORDER BY zta01,zta02

    IF g_zta.zta07='S' THEN
       LET l_schema = g_zta.zta17 CLIPPED
    ELSE
       LET l_schema = g_zta.zta02 CLIPPED
    END IF

    INITIALIZE l_ztd03 TO NULL
    INITIALIZE l_ztd04 TO NULL
    LET l_field_pks = NULL

    CASE g_db_type               
       WHEN "IFX"                
      

       WHEN "ORA"               
         #取得 Constraint 資料
         LET l_sql = "SELECT LOWER(CONSTRAINT_NAME),CONSTRAINT_TYPE",
                     "  FROM ALL_CONSTRAINTS ",
                     " WHERE LOWER(OWNER)='",l_schema,"' ",
                     "   AND LOWER(TABLE_NAME)='", g_global_azwe01 CLIPPED,"'",
                     "   AND LOWER(CONSTRAINT_TYPE)='p'",
                     "  AND CONSTRAINT_NAME NOT like \"SYS_%\""

         DECLARE p_global_setting_ztd1 CURSOR FROM l_sql
         FOREACH p_global_setting_ztd1 INTO l_ztd03,l_ztd04
            #取得 PrimaryKey Columns 
            LET l_sql = "SELECT LOWER(COLUMN_NAME) FROM ALL_CONS_COLUMNS",
                        " WHERE LOWER(OWNER)='",l_schema,"' ",
                        "   AND LOWER(TABLE_NAME) ='",g_global_azwe01 CLIPPED,"' ",
                        "   AND LOWER(CONSTRAINT_NAME) ='",l_ztd03 CLIPPED,"' ",
                        " ORDER BY POSITION "
         
            DECLARE p_global_setting_ztd2 CURSOR FROM l_sql
            FOREACH p_global_setting_ztd2 INTO l_column_name
                IF NOT cl_null(l_column_name) THEN
                   LET l_field_pks = l_field_pks CLIPPED,",",l_column_name CLIPPED
                END IF
            END FOREACH
         END FOREACH
 
     WHEN "MSV"     
         #取得 PrimaryKey Columns  
         LET l_sql = "SELECT name FROM sys.columns a ",
                     "  RIGHT OUTER JOIN (SELECT b.object_id, column_id FROM sys.index_columns b ", 
                     "      RIGHT OUTER JOIN (SELECT object_id, index_id FROM sys.indexes ", 
                     "         WHERE object_id = (SELECT object_id FROM sys.objects ", 
                     "            WHERE name = '",g_global_azwe01 CLIPPED,"') AND is_primary_key = 1) c ",
                     "      ON c.object_id = b.object_id AND c.index_id = b.index_id) d", 
                     "  ON a.object_id = d.object_id WHERE a.column_id = d.column_id"  
         DECLARE p_global_setting_ztd2_msv CURSOR FROM l_sql
         FOREACH p_global_setting_ztd2_msv INTO l_column_name
            IF NOT cl_null(l_column_name) THEN
               LET l_field_pks = l_field_pks CLIPPED,",",l_column_name CLIPPED
            END IF
         END FOREACH         
     
    END CASE       
    RETURN l_field_pks
END FUNCTION

FUNCTION global_setting_is_pk(l_ztb03) 
   DEFINE l_ztb03    LIKE ztb_file.ztb03
   DEFINE l_cnt      LIKE type_file.num5,  
          l_i        LIKE type_file.num5 
          
   LET l_cnt = g_pks.getLength()  
   FOR l_i = 1 TO l_cnt
       IF g_pks[l_i] = l_ztb03 AND NOT cl_null(g_pks[l_i]) THEN 
          RETURN TRUE
       END IF
   END FOR
   RETURN FALSE
END FUNCTION
