# Prog. Version..: '5.30.06-13.04.09(00004)'     #
#
# Pattern name...: acoi763.4gl
# Descriptions...: 歸併前後BOM維護作業
# Date & Author..: FUN-930151 09/04/01 BY rainy 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0238 09/12/01 By jan 只有單頭資料,刪除會無法執行
# Modify.........: No.MOD-9C0239 09/12/21 By destiny 进归并前单身后会使品名和规格资料变为空白
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-D20025 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-C80072 13/04/01 By wuxj     取消確認時審核異動人員及審核異動日期給值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE p_row,p_col     LIKE type_file.num5,
       g_rec_k         LIKE type_file.num5,     
       g_rec_l         LIKE type_file.num5,     
       g_row_count     LIKE type_file.num10,
       g_curs_index    LIKE type_file.num10,
       g_wc,g_sql      STRING,
       g_void          LIKE type_file.chr1,
       g_forupd_sql    STRING,
       g_cnt           LIKE type_file.num10
       
DEFINE l_ac            LIKE type_file.num5     
DEFINE l_ac2           LIKE type_file.num5     
DEFINE mi_no_ask       LIKE type_file.num5       
DEFINE g_jump          LIKE type_file.num10
DEFINE g_before_input_done LIKE type_file.num5    
DEFINE g_msg           LIKE type_file.chr1000
DEFINE g_chr           LIKE type_file.chr1
 
DEFINE g_cej        RECORD LIKE cej_file.*,
 
       g_cek        DYNAMIC ARRAY OF RECORD
         cek04      LIKE cek_file.cek04,
         cek05      LIKE cek_file.cek05,
         cek06      LIKE cek_file.cek06,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         cek09      LIKE cek_file.cek09,
         cek10      LIKE cek_file.cek10,
         cek11      LIKE cek_file.cek11
                        END RECORD,                        
       g_cek_t      RECORD
         cek04      LIKE cek_file.cek04,
         cek05      LIKE cek_file.cek05,
         cek06      LIKE cek_file.cek06,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         cek09      LIKE cek_file.cek09,
         cek10      LIKE cek_file.cek10,
         cek11      LIKE cek_file.cek11
                        END RECORD,                        
       g_cel        DYNAMIC ARRAY OF RECORD
         cel04      LIKE cel_file.cel04,
         cel05      LIKE cel_file.cel05,
         cel06      LIKE cel_file.cel06,
         cei12        LIKE cei_file.cei12,
         cei13        LIKE cei_file.cei13,
         cel07      LIKE cel_file.cel07,
         cel08      LIKE cel_file.cel08,
         cel09      LIKE cel_file.cel09
                        END RECORD
                                            
MAIN
  OPTIONS
    INPUT NO WRAP
  DEFER INTERRUPT
     
  IF (NOT cl_user()) THEN
    EXIT PROGRAM
  END IF
   
  WHENEVER ERROR CALL cl_err_msg_log
   
  IF (NOT cl_setup("ACO")) THEN
    EXIT PROGRAM
  END IF
  CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
  LET g_forupd_sql = "SELECT * FROM cej_file ",
                     " WHERE cej01=? ",
                     "   AND cej02=? AND cej03=? FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i763_cl CURSOR FROM g_forupd_sql
  
  LET p_row = 3
  LET p_col = 20
  OPEN WINDOW i763_w AT p_row,p_col WITH FORM "aco/42f/acoi763"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)  
  CALL cl_ui_init()
 
  CALL cl_set_comp_visible("cej03",g_sma.sma118='Y') 
  CALL i763_menu()
  CLOSE WINDOW i763_w 
  CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN    
 
 
FUNCTION i763_cs()
  DEFINE  lc_qbe_sn    LIKE    gbm_file.gbm01
 
   CLEAR FORM
   CALL g_cek.clear()
   CALL g_cel.clear()
 
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_cej.* TO NULL    
   CONSTRUCT BY NAME g_wc ON cej04,cej02,cej03,
                             cej06,cej05,cej07,cej08,
                             cejuser,cejgrup,cejmodu,cejdate,cejacti
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cej04)    #成品料號 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.arg1 = '1'
                 LET g_qryparam.arg3 = '3'
                 LET g_qryparam.form = "q_cei02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cej04
                 NEXT FIELD cej04
               WHEN INFIELD(cej06)     #海關商品編號 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_ceg01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cej06
                 NEXT FIELD cej06
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn) 
   END CONSTRUCT
   IF INT_FLAG THEN
       RETURN
   END IF
 
   #資料權限的檢查     
   #Begin:FUN-980030
   #   IF g_priv2 = '4' THEN                 #只能使用自己的資料     
   #      LET g_wc = g_wc clipped," AND cejuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                   #只能使用相同群的資料    
   #      LET g_wc = g_wc clipped," AND cejgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN      #群組權限   
   #      LET g_wc = g_wc clipped," AND cejgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cejuser', 'cejgrup')
   #End:FUN-980030
 
   LET g_sql = "SELECT cej01,cej02,cej03 FROM cej_file ",
               " WHERE ", g_wc CLIPPED," ORDER BY cej01,cej02,cej03"
   PREPARE i763_prepare FROM g_sql
   DECLARE i763_cs SCROLL CURSOR WITH HOLD FOR i763_prepare    #SCROLL CURSOR
   
   LET g_sql = "SELECT COUNT(*) FROM cej_file WHERE ",g_wc CLIPPED  #取合乎條件筆數                                                                 
   PREPARE i763_precount FROM g_sql
   DECLARE i763_count CURSOR FOR i763_precount
END FUNCTION
 
 
FUNCTION i763_menu()
   DEFINE l_cmd LIKE type_file.chr1000 
 
   WHILE TRUE
 
      CALL i763_bp("G")
 
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i763_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i763_r()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i763_y_upd()
               CALL i763_set_pic()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i763_z()
               CALL i763_set_pic()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL i763_x()  #FUN-D20025 mark
               CALL i763_x(1) #FUN-D20025 add
               CALL i763_set_pic()
            END IF
         #FUN-D20025 add
         WHEN "undo_void"          #"取消作廢"
            IF cl_chk_act_auth() THEN
               CALL i763_x(2)
               CALL i763_set_pic()
            END IF
         #FUN-D20025 add             
         WHEN "detail"   #歸併前單身維護
            IF cl_chk_act_auth() THEN
              CALL i763_b1()
            END IF   
 
         WHEN "show_cek"
            IF cl_chk_act_auth() THEN
              CALL i763_show_cek()
            END IF   
         WHEN "show_cel"
            IF cl_chk_act_auth() THEN
              CALL i763_show_cel()
            END IF   
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cek),base.TypeInfo.create(g_cel),'')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i763_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   
   DISPLAY ARRAY g_cel TO s_cel.* ATTRIBUTE(COUNT=g_rec_l,UNBUFFERED)
     BEFORE DISPLAY   
       EXIT DISPLAY
     AFTER DISPLAY
       CONTINUE DISPLAY
   END DISPLAY
            
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cek TO s_cek.* ATTRIBUTE(COUNT=g_rec_k,UNBUFFERED)
      BEFORE DISPLAY  
         CALL cl_navigator_setting(g_curs_index,g_row_count)
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()
 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
 
      ON ACTION first
         CALL i763_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_k != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY             
 
      ON ACTION previous
         CALL i763_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_k != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         EXIT DISPLAY              
 
      ON ACTION jump
         CALL i763_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_k != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         EXIT DISPLAY               
 
      ON ACTION next
         CALL i763_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_k != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         EXIT DISPLAY              
 
      ON ACTION last
         CALL i763_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_k != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         EXIT DISPLAY              
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()     
         CALL i763_set_pic()
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION show_cek
         LET g_action_choice="show_cek"
         EXIT DISPLAY
            
      ON ACTION show_cel
         LET g_action_choice="show_cel"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
         
      ON ACTION void        
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20025 add
      ON ACTION undo_void         #取消作廢
        LET g_action_choice="undo_void"
        EXIT DISPLAY
      #FUN-D20025 add  
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE             
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION about         
         CALL cl_about()      
            
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")      
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
 
 
FUNCTION i763_q()
   LET g_row_count = 0
   LET g_curs_index = 0
 
   CALL cl_navigator_setting(g_curs_index, g_row_count)
   INITIALIZE g_cej.* TO NULL
 
   CALL cl_opmsg('q')
   CALL cl_msg("")   
   CLEAR FORM
   CALL g_cek.clear()
   CALL g_cel.clear()
 
   DISPLAY '   ' TO FORMONLY.cn1
 
   CALL i763_cs()
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")
 
   OPEN i763_cs                          # 從DB產生合乎條件TEMP(0-30秒)   
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cej.* TO NULL
   ELSE
      OPEN i763_count
      FETCH i763_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cn1
      CALL i763_fetch('F')               # 讀出TEMP第一筆並顯示     
   END IF
   CALL cl_msg("")
END FUNCTION
 
 
 
FUNCTION i763_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1,
          l_abso          LIKE type_file.num10
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     i763_cs INTO g_cej.cej01,g_cej.cej02,g_cej.cej03
       WHEN 'P' FETCH PREVIOUS i763_cs INTO g_cej.cej01,g_cej.cej02,g_cej.cej03
       WHEN 'F' FETCH FIRST    i763_cs INTO g_cej.cej01,g_cej.cej02,g_cej.cej03
       WHEN 'L' FETCH LAST     i763_cs INTO g_cej.cej01,g_cej.cej02,g_cej.cej03
       WHEN '/'
          IF (NOT mi_no_ask) THEN
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
          FETCH ABSOLUTE g_jump i763_cs INTO g_cej.cej01,g_cej.cej02,g_cej.cej03
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cej.cej01,SQLCA.sqlcode,0)
      INITIALIZE g_cej.* TO NULL
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
 
   SELECT * INTO g_cej.* FROM cej_file 
    WHERE cej01=g_cej.cej01 
      AND cej02=g_cej.cej02
      AND cej03=g_cej.cej03  #特性代碼
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cej_file",g_cej.cej01,g_cej.cej02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_cej.* TO NULL
   ELSE
      LET g_data_owner = g_cej.cejuser
      LET g_data_group = g_cej.cejgrup
      CALL i763_show()                       # 重新顯示    
   END IF
END FUNCTION
 
 
FUNCTION i763_show()
   DEFINE l_ima02  LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021
          
   DISPLAY BY NAME g_cej.cej02,g_cej.cej03,g_cej.cej04,
       g_cej.cej05,g_cej.cej06,g_cej.cej07,g_cej.cej08,
       g_cej.cejuser,g_cej.cejgrup,g_cej.cejmodu,
       g_cej.cejdate,g_cej.cejacti     
  
   SELECT ima02,ima021 INTO l_ima02,l_ima021 
     FROM ima_file 
    WHERE ima01=g_cej.cej04
 
   DISPLAY l_ima02 TO FORMONLY.ima02
   DISPLAY l_ima021 TO FORMONLY.ima021
 
   CALL i763_set_pic()
 
   CALL i763_b1_fill(g_wc)       #單身 cek_file
   CALL i763_b2_fill(g_wc)       #單身 cel_file     
   CALL cl_show_fld_cont()   
END FUNCTION
 
 
FUNCTION i763_b1_fill(p_wc)    #cek_file
  DEFINE p_wc     LIKE type_file.chr1000
  DEFINE l_ima02  LIKE ima_file.ima02,
         l_ima021 LIKE ima_file.ima021
  
  IF p_wc IS NULL THEN
    LET p_wc=" 1=1 "
  END IF
 
  LET g_sql ="SELECT cek04,cek05,cek06,'','',cek09,cek10,cek11 ",
      " FROM cek_file ",
      " WHERE cek01='",g_cej.cej01,"'",
      "   AND cek02='",g_cej.cej02,"'",
      "   AND cek03='",g_cej.cej03,"'",  #特性代碼
      " ORDER BY cek04"   
  PREPARE i763_cek_pb FROM g_sql
  DECLARE i763_cek_curs CURSOR FOR i763_cek_pb
 
  CALL g_cek.clear()
  LET g_rec_k = 0
  LET g_cnt = 1
  FOREACH i763_cek_curs INTO g_cek[g_cnt].*   #單身 ARRAY 填充   
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
   
    SELECT ima02,ima021 INTO l_ima02,l_ima021 
      FROM ima_file
     WHERE ima01=g_cek[g_cnt].cek06 
       AND ROWNUM=1 
    LET g_cek[g_cnt].ima02=l_ima02
    LET g_cek[g_cnt].ima021=l_ima021
    
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH  
  CALL g_cek.deleteElement(g_cnt)
 
  LET g_rec_k = g_cnt - 1
  LET g_cnt = 0  
  DISPLAY g_rec_k TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION i763_b2_fill(p_wc)   #cel_file
  DEFINE p_wc     LIKE type_file.chr1000
  DEFINE l_cei12  LIKE cei_file.cei12,
         l_cei13  LIKE cei_file.cei13 
  
  IF p_wc IS NULL THEN
    LET p_wc=" 1=1 "
  END IF
 
 CALL g_cel.clear() 
 LET g_rec_l = 0
 IF g_cej.cej07 = 'Y' THEN   #單頭已確認
   LET g_sql ="SELECT cel04,cel05,cel06,'','',cel07,cel08,cel09 ",
       "  FROM cel_file ",
       " WHERE cel01='",g_cej.cej05,"'",
       "   AND cel02='",g_cej.cej02,"'",
       "   AND cel03='",g_cej.cej03,"'"     #特性代碼
   PREPARE i763_cel_pb FROM g_sql
   DECLARE i763_cel_curs CURSOR FOR i763_cel_pb
   CALL g_cel.clear()
   LET g_rec_l = 0
   LET g_cnt = 1
   FOREACH i763_cel_curs INTO g_cel[g_cnt].*   
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
 
     SELECT ceh02,ceh03 INTO l_cei12,l_cei13 
       FROM ceh_file
      WHERE ceh01=g_cel[g_cnt].cel05 
        AND ceh00='2'
     LET g_cel[g_cnt].cei12=l_cei12
     LET g_cel[g_cnt].cei13=l_cei13
     
     LET g_cnt = g_cnt + 1
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
   END FOREACH  
 END IF 
 
 CALL g_cel.deleteElement(g_cnt)
 LET g_rec_l = g_cnt - 1
 LET g_cnt = 0  
END FUNCTION
 
 
FUNCTION i763_b1()
DEFINE
    l_ac2_t          LIKE type_file.num5,       
    l_n             LIKE type_file.num5,      
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,    
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5    
DEFINE l_cnt        LIKE type_file.num10               
DEFINE l_retrunno   LIKE type_file.chr1               
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    SELECT * INTO g_cej.* FROM cej_file 
     WHERE cej01=g_cej.cej01 
       AND cej02=g_cej.cej02
       AND cej03=g_cej.cej03  #特性代碼
    IF g_cej.cej01 IS NULL THEN RETURN END IF
    IF g_cej.cej07 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    IF g_cej.cej07 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    IF g_cej.cejacti = 'N' THEN    #檢查資料是否為無效    
       CALL cl_err(g_cej.cej01,9027,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql ="SELECT cek04,cek05,cek06,'','',cek09,cek10,cek11 ",
                      "  FROM cek_file ",
                      " WHERE cek01=?",
                      "   AND cek02=?",
                      "   AND cek03=?", #特性代碼
                      "   AND cek04=?", 
                      "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i763_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
 
    INPUT ARRAY g_cek WITHOUT DEFAULTS FROM s_cek.*
          ATTRIBUTE(COUNT=g_rec_k,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
       
       BEFORE INPUT
          IF g_rec_k != 0 THEN
             CALL fgl_set_arr_curr(l_ac2)
          END IF
          CALL i763_set_required_b()    
           
       BEFORE ROW
         LET p_cmd = ''
         LET l_ac2 = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN i763_cl USING g_cej.cej01,g_cej.cej02,g_cej.cej03
         IF STATUS THEN
            CALL cl_err("OPEN i763_cl:", STATUS, 1)
            CLOSE i763_cl
            ROLLBACK WORK
            RETURN
         END IF       
 
         FETCH i763_cl INTO g_cej.*        #鎖住將被更改或取消的資料  
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_cej.cej02,SQLCA.sqlcode,0)       #資料被他人LOCK   
            CLOSE i763_cl
            ROLLBACK WORK
            RETURN
         END IF    
 
         IF g_rec_k>=l_ac2 THEN
            LET p_cmd='u'
            LET g_cek_t.* = g_cek[l_ac2].*  #BACKUP
            LET  g_before_input_done = FALSE                                                                                     
            CALL i763_set_entry_b(p_cmd)                                                                                           
            CALL i763_set_no_entry_b(p_cmd)                                                                                        
            LET  g_before_input_done = TRUE                                                                                      
 
            OPEN i763_bcl USING g_cej.cej01,g_cej.cej02,g_cej.cej03,g_cek_t.cek04
            IF STATUS THEN
               CALL cl_err("OPEN i763_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i763_bcl INTO g_cek[l_ac2].* 
               IF STATUS THEN
                  CALL cl_err(g_cek_t.cek04,STATUS,1)
                  LET l_lock_sw = "Y"
               #MOD-9C0239--begin
               ELSE 
               	  SELECT ima02,ima021 INTO g_cek[l_ac2].ima02,g_cek[l_ac2].ima021 
                    FROM ima_file
                   WHERE ima01=g_cek[l_ac2].cek06 
               #MOD-9C0239--end
               END IF
            END IF
            CALL cl_show_fld_cont()     
         END IF
 
 
 
 
       AFTER FIELD cek10  
          IF NOT cl_null(g_cek[l_ac2].cek10) THEN
             IF g_cek[l_ac2].cek10 < 0 THEN
                CALL cl_err('','mfg9243',0)
                LET g_cek[l_ac2].cek10 = g_cek_t.cek10
                NEXT FIELD cek10
             END IF 
          END IF 
          
       AFTER FIELD cek11  
          IF NOT cl_null(g_cek[l_ac2].cek11) THEN
             IF g_cek[l_ac2].cek11 < 0 THEN
                CALL cl_err('','mfg9243',0)
                LET g_cek[l_ac2].cek11 = g_cek_t.cek11
                NEXT FIELD cek11
             END IF 
          END IF 
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cek[l_ac2].* = g_cek_t.*
             CLOSE i763_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
           
          LET l_cnt=0      
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cek[l_ac2].cek04,-263,1)
             LET g_cek[l_ac2].* = g_cek_t.*
          ELSE
             UPDATE cek_file 
                SET cek10=g_cek[l_ac2].cek10,
                    cek11=g_cek[l_ac2].cek11
              WHERE cek01 = g_cej.cej01   #成品序號
                AND cek02 = g_cej.cej02   #BOM版本
                AND cek03 = g_cej.cej03   #特性代碼
                AND cek04 = g_cek_t.cek04
 
             IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","cek_file",g_cej.cej01,g_cek_t.cek04,SQLCA.sqlcode,"","",1)  
                 LET g_cek[l_ac2].* = g_cek_t.*
             ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i763_bcl
                 COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
         LET l_ac2= ARR_CURR()
         LET l_ac2_t = l_ac2
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN 
               LET g_cek[l_ac2].* = g_cek_t.*
            END IF 
            CLOSE i763_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i763_bcl
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
    END INPUT
 
    CLOSE i763_bcl
    COMMIT WORK
END FUNCTION
 
 
#FUNCTION i763_x()   #無效 #FUN-D20025 mark
FUNCTION i763_x(p_type)  #FUN-D20025 add
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add  
   IF s_shut(0) THEN RETURN END IF
  #IF g_rec_k=0 THEN RETURN END IF   #TQC-9B0238
 
   IF cl_null(g_cej.cej01) OR cl_null(g_cej.cej02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_cej.* FROM cej_file 
     WHERE cej01=g_cej.cej01
       AND cej02=g_cej.cej02
       AND cej03=g_cej.cej03  #特性代碼
   IF cl_null(g_cej.cej01) OR cl_null(g_cej.cej02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF   
 
   IF g_cej.cej07 = 'Y' THEN   #-->已確認不可作廢        
      CALL cl_err('',9023,0)
      RETURN
   END IF
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF g_cej.cej07='X' THEN RETURN END IF
   ELSE
      IF g_cej.cej07<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end    
   BEGIN WORK
   LET g_success='Y'
   OPEN i763_cl USING g_cej.cej01,g_cej.cej02,g_cej.cej03
   IF STATUS THEN
      CALL cl_err("OPEN i763_cl:", STATUS, 1)
      CLOSE i763_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i763_cl INTO g_cej.*      #鎖住將被更改或取消的資料   
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cej.cej04,SQLCA.sqlcode,0)     #資料被他人LOCK 
      CLOSE i763_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   IF cl_void(0,0,g_cej.cej07) THEN   
      LET g_chr = g_cej.cej07
      IF g_cej.cej07 = 'N' THEN
         LET g_cej.cej07 = 'X'
      ELSE
         LET g_cej.cej07 = 'N'
      END IF
   
      UPDATE cej_file 
         SET cej07 = g_cej.cej07,
             cej08 = g_today,
             cejmodu = g_user,
             cejdate = g_today
       WHERE cej01=g_cej.cej01
         AND cej02=g_cej.cej02
         AND cej03=g_cej.cej03  #特性代碼
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","cej_file",g_cej.cej01,g_cej.cej02,SQLCA.sqlcode,"","",1)
         LET g_cej.cej07 = 'N'
         ROLLBACK WORK
         RETURN
      END IF
      
      #IF g_rec_l>0 THEN      
      #   UPDATE ces_file 
      #      SET ces05 = g_cej.cej07,
      #          ces06 = g_today,
      #          cesmodu = g_user,
      #          cesdate = g_today
      #      WHERE ces01=g_cej.cej05 
      #        AND ces02=g_cej.cej02
      #        AND ces03=g_cej.cej03   #特性代碼
      #   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      #      CALL cl_err3("upd","ces_file",g_cej.cej01,g_cej.cej02,SQLCA.sqlcode,"","",1)
      #      ROLLBACK WORK
      #      RETURN
      #   END IF
      #END IF
      
      SELECT * INTO g_cej.* FROM cej_file 
       WHERE cej01=g_cej.cej01
         AND cej02=g_cej.cej02
         AND cej03=g_cej.cej03  #特性代碼
      DISPLAY BY NAME g_cej.cej07,g_cej.cej08
   END IF
   
   CLOSE i763_cl
   COMMIT WORK   
END FUNCTION
 
 
FUNCTION i763_z()  #Undo Confirm
   DEFINE l_cnt1     LIKE type_file.num5
   DEFINE l_cnt2     LIKE type_file.num5
   DEFINE l_cn       LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_rec_l=0 THEN RETURN END IF
   IF cl_null(g_cej.cej01) OR cl_null(g_cej.cej02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_cej.* FROM cej_file 
     WHERE cej01=g_cej.cej01
       AND cej02=g_cej.cej02
       AND cej03=g_cej.cej03  #特性代碼
   IF cl_null(g_cej.cej01) OR cl_null(g_cej.cej02)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF   
   IF g_cej.cej07 = 'N' THEN    #未確認
      CALL cl_err('',9025,0)
      RETURN
   END IF
   IF g_cej.cej07 = 'X' THEN    #已作廢不可確認
      CALL cl_err('',9024,0)
      RETURN
   END IF
   
   IF NOT cl_confirm('axm-109') THEN   #是否確定取消確認 (Y/N) ?
      RETURN
   END IF
   
   BEGIN WORK
   LET g_success='Y'
   OPEN i763_cl USING g_cej.cej01,g_cej.cej02,g_cej.cej03
   IF STATUS THEN
      CALL cl_err("OPEN i763_cl:", STATUS, 1)
      CLOSE i763_cl
      ROLLBACK WORK
      RETURN
   END IF       
 
   FETCH i763_cl INTO g_cej.*        #鎖住將被更改或取消的資料    
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cej.cej04,SQLCA.sqlcode,0)      #資料被他人LOCK  
      CLOSE i763_cl
      ROLLBACK WORK
      RETURN
   END IF    
 
   SELECT COUNT(*) INTO l_cnt1    #出口報關清單     
     FROM cet_file    
    WHERE cet04=g_cej.cej04 
      AND cet17=g_cej.cej02
      
   IF l_cnt1>0 THEN
      CALL cl_err(g_cej.cej04,'aco-710',1)
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN       
   END IF   
   
   UPDATE cej_file 
      SET cej07 = 'N',
         #cej08 = '',          #CHI-C80072  mark
          cej08 = g_today,     #CHI-C80072  add 
          cejmodu = g_user,
          cejdate = g_today
    WHERE cej01=g_cej.cej01
      AND cej02=g_cej.cej02
      AND cej03=g_cej.cej03  #特性代碼
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","cej_file",g_cej.cej01,g_cej.cej02,SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
      RETURN
   END IF
 
 
   #DELETE FROM ces_file 
   # WHERE ces01=g_cej.cej05  #歸併後序號
   #   AND ces02=g_cej.cej02  #BOM版本
   #   AND ces03=g_cej.cej03   #特性代碼
   #IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
   #   CALL cl_err3("del","ces_file",g_cej.cej01,g_cej.cej02,SQLCA.sqlcode,"","",1)
   #   ROLLBACK WORK
   #   RETURN
   #END IF
        
   #歸併後資料 
    DELETE FROM cel_file 
     WHERE cel01=g_cej.cej05  #歸併後序號
       AND cel02=g_cej.cej02  #BOM版本
       AND cel03=g_cej.cej03  #特性代碼
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("del","cel_file",g_cej.cej01,g_cej.cej02,SQLCA.sqlcode,"","",1)
       ROLLBACK WORK
       RETURN
    END IF     
 
    LET g_cej.cej07 = 'N'
   #LET g_cej.cej08 = ''            #CHI-C80072 mark
    LET g_cej.cej08 = g_today       #CHI-C80072 add 
    CLOSE i763_cl
    COMMIT WORK
    CALL i763_show()
END FUNCTION
 
 
FUNCTION i763_r()  #刪除
   IF s_shut(0) THEN RETURN END IF
  #IF g_rec_k=0 THEN RETURN END IF  #TQC-9B0238
 
   IF cl_null(g_cej.cej01) OR cl_null(g_cej.cej02)  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_cej.* FROM cej_file 
     WHERE cej01=g_cej.cej01
       AND cej02=g_cej.cej02
       AND cej03=g_cej.cej03   #特性代碼
   IF cl_null(g_cej.cej01) OR cl_null(g_cej.cej02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF   
 
   IF g_cej.cejacti = 'N' THEN    #檢查資料是否為無效    
      CALL cl_err(g_cej.cej01,9027,0)
      RETURN
   END IF
 
   IF g_cej.cej07 = 'X' THEN     #無效資料不可刪除
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_cej.cej07 = 'Y' THEN     #已確認資料不可刪除
      CALL cl_err('','9023',0)
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success='Y'
   OPEN i763_cl USING g_cej.cej01,g_cej.cej02,g_cej.cej03
   IF STATUS THEN
      CALL cl_err("OPEN i763_cl:", STATUS, 1)
      CLOSE i763_cl
      ROLLBACK WORK
      RETURN
   END IF       
 
   FETCH i763_cl INTO g_cej.*        #鎖住將被更改或取消的資料  
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cej.cej04,SQLCA.sqlcode,0)       #資料被他人LOCK   
      CLOSE i763_cl
      ROLLBACK WORK
      RETURN
   END IF    
 
   CALL i763_show()
 
   IF cl_delh(0,0) THEN  #確認一下    
      DELETE FROM cej_file      #刪單頭
       WHERE cej01=g_cej.cej01
         AND cej02=g_cej.cej02
         AND cej03=g_cej.cej03   #特性代碼
 
      DELETE FROM cek_file      #刪單身(歸併前BOM單身)
        WHERE cek01=g_cej.cej01
          AND cek02=g_cej.cej02
          AND cek03=g_cej.cej03   #特性代碼
 
      INITIALIZE g_cej.* TO NULL
      CLEAR FORM
      CALL g_cek.clear()
      CALL g_cel.clear()
      OPEN i763_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i763_cs
         CLOSE i763_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i763_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i763_cs
         CLOSE i763_count
         COMMIT WORK
         RETURN
      END IF
     #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cn1     
 
      OPEN i763_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i763_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i763_fetch('/')
      END IF
   END IF
   
   CLOSE i763_cl
   COMMIT WORK   
END FUNCTION
 
 
FUNCTION i763_y_upd()  #confirm
  DEFINE l_cn    LIKE    type_file.num5 
  
  IF s_shut(0) THEN RETURN END IF
  IF g_rec_k=0 OR g_rec_l>0 THEN RETURN END IF
#CHI-C30107 -------- add --------- begin
  IF g_cej.cejacti ='N' THEN     #檢查資料是否為無效
     CALL cl_err(g_cej.cej01,'mfg1000',0)
     RETURN
  END IF
  IF g_cej.cej07 = 'X' THEN   #已作廢
     CALL cl_err('','axr-103',1)
     RETURN
  END IF
  IF g_cej.cej07 = 'Y' THEN
     CALL cl_err('','anm-105',1)
     RETURN
  END IF
#CHI-C30107 -------- add --------- end
  IF NOT cl_confirm('aap-222') THEN RETURN END IF  #CHI-C30107 add
#CHI-C30107 -------- add --------- begin
  SELECT * INTO g_cej.* FROM cej_file WHERE cej01 = g_cej.cej01
                                        AND cej02 = g_cej.cej02
                                        AND cej03 = g_cej.cej03
#CHI-C30107 -------- add --------- end
  IF cl_null(g_cej.cej01) OR cl_null(g_cej.cej02) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF   
 
  IF g_cej.cejacti ='N' THEN     #檢查資料是否為無效     
     CALL cl_err(g_cej.cej01,'mfg1000',0)
     RETURN
  END IF
  IF g_cej.cej07 = 'X' THEN   #已作廢
     CALL cl_err('','axr-103',1)
     RETURN
  END IF
  IF g_cej.cej07 = 'Y' THEN
     CALL cl_err('','anm-105',1)
     RETURN
  END IF
 
  BEGIN WORK
  LET g_success='Y'
  OPEN i763_cl USING g_cej.cej01,g_cej.cej02,g_cej.cej03
  IF STATUS THEN
     CALL cl_err("OPEN i763_cl:", STATUS, 1)
     CLOSE i763_cl
     ROLLBACK WORK
     RETURN
  END IF       
 
  FETCH i763_cl INTO g_cej.*          #鎖住將被更改或取消的資料 
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_cej.cej04,SQLCA.sqlcode,0)      
     CLOSE i763_cl
     ROLLBACK WORK
     RETURN
  END IF    
  CALL i763_show()
 
# IF cl_confirm('aap-222') THEN  #CHI-C30107 mark
     LET l_cn = '0'
     SELECT COUNT(*) INTO l_cn FROM cel_file
      WHERE cel01 = g_cej.cej05   #歸併後序號
        AND cel02 = g_cej.cej02   #BOM版本
        AND cel03 = g_cej.cej03   #特性代碼
     IF l_cn = 0 THEN
       CALL i763_ins_ces()
     END IF
 
     IF g_success = 'Y' THEN
        UPDATE cej_file 
           SET cej07 = 'Y',
               cej08 = g_today,
               cejmodu = g_user,
               cejdate = g_today
         WHERE cej01=g_cej.cej01
           AND cej02=g_cej.cej02
           AND cej03=g_cej.cej03  #特性代碼
        IF SQLCA.sqlcode THEN
           CALL cl_err('update cej07:','SQLCA.sqlcode',1)
           LET g_success = 'N'
           LET g_cej.cej07 = 'N'
           ROLLBACK WORK
           CALL cl_rbmsg(1)
        ELSE
           COMMIT WORK
           SELECT * INTO g_cej.* FROM cej_file 
            WHERE cej01=g_cej.cej01
              AND cej02=g_cej.cej02
              AND cej03=g_cej.cej03   #特性代碼
           CALL i763_show()
           CALL cl_cmmsg(1)
        END IF
     ELSE
        ROLLBACK WORK
        CALL cl_rbmsg(1)  
     END IF
#  END IF  #CHI-C30107
END FUNCTION
 
#寫入歸併後單身&海關其他資料檔 
FUNCTION i763_ins_ces()
   #DEFINE l_ces    RECORD LIKE ces_file.*
   DEFINE l_cel    RECORD LIKE cel_file.*
   DEFINE l_cek    RECORD LIKE cek_file.*,
          l_n         SMALLINT,
          l_qty1      LIKE   cek_file.cek10,  #單耗匯總
          l_qty2      LIKE   cek_file.cek10,  #總耗匯總  
          l_qty3      LIKE   cek_file.cek11   #損耗率 
   DEFINE l_cek10  LIKE   cek_file.cek10,
          l_cek11  LIKE   cek_file.cek11,
          l_cel05  LIKE   cel_file.cel05
 
   #LET l_ces.ces01 = g_cej.cej05    #歸併後序號
   #LET l_ces.ces02 = g_cej.cej02    #BOM版本
   #LET l_ces.ces03 = g_cej.cej03    #特性代碼
   #LET l_ces.ces04 = g_cej.cej06    #海關商品編號
   #LET l_ces.ces05 = 'N'            #審核狀態
   #LET l_ces.ces06 = g_today        #審核日期
   #LET l_ces.cesacti = 'Y'         
   #LET l_ces.cesuser = g_user
   #LET l_ces.cesgrup = g_grup
   #LET l_ces.cesdate = g_today
 
   #INSERT INTO ces_file VALUES(l_ces.*)
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err("insert ces_file:",SQLCA.sqlcode,1)
   #   LET g_success = 'N'
   #   RETURN
   #END IF
 
  #===先將歸併後的資料INSERT到cel_file中（不包含單耗、損耗率）=====  
   LET g_sql="SELECT DISTINCT cek12,cek02,cek07,",   #成品歸併後序號,BOM版本 ,歸併後序號 
             "                cek08,cek09,cek13 ",   #海關商品編號,申報計量單位,類型
             "  FROM cek_file ",
             " WHERE cek01='",g_cej.cej01,"'",
             "   AND cek02='",g_cej.cej02,"'",
             "   AND cek03='",g_cej.cej03,"'",   #特性代碼
             " ORDER BY cek12"
   PREPARE i763_cek_p2 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('Prepare i763_cek_p2 err !',SQLCA.sqlcode,1)
      LET g_success = 'N' RETURN
   END IF  
   DECLARE i763_cek_cs2 CURSOR FOR i763_cek_p2
   FOREACH i763_cek_cs2 
      INTO l_cek.cek12,l_cek.cek02,l_cek.cek07,
           l_cek.cek08,l_cek.cek09,l_cek.cek13
 
         LET l_cel.cel01 = g_cej.cej05   #歸併後序號
         LET l_cel.cel02 = g_cej.cej02   #BOM版本
         LET l_cel.cel03 = g_cej.cej03   #特性碼
 
         SELECT MAX(cel04) INTO l_n FROM cel_file
            WHERE cel01 = g_cej.cej05
              AND cel02 = g_cej.cej02
              AND cel03 = g_cej.cej03   #特性代碼
         IF cl_null(l_n) OR l_n = 0 THEN
            LET l_cel.cel04 = '10'
         ELSE
            LET l_cel.cel04 = l_n + 10
         END IF
 
         LET l_cel.cel05 = l_cek.cek07   #歸併後序號 
         LET l_cel.cel06 = l_cek.cek08   #海關商編  
         LET l_cel.cel07 = l_cek.cek09   #申報計量單位
         LET l_cel.cel08 = 0             #單耗
         LET l_cel.cel09 = 0             #損耗率
         LET l_cel.cel10 = l_cek.cek13   #類型 1.成品 2.材料
         INSERT INTO cel_file VALUES(l_cel.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err('insert cel_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
   END FOREACH
 
  #==再計算單耗、損耗率UPDATE到cel_file中======
   LET g_sql="SELECT cel05 FROM cel_file ",
             " WHERE cel01='",g_cej.cej05,"'",
             "   AND cel02='",g_cej.cej02,"'",
             "   AND cel03='",g_cej.cej03,"'",    #特性代碼
             " ORDER BY cel05 "
   PREPARE i763_cel_p2 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('Prepare i763_cel_p2 err !',SQLCA.sqlcode,1)
      LET g_success = 'N' RETURN
   END IF  
   DECLARE i763_cel_cs2 CURSOR FOR i763_cel_p2
 
   FOREACH i763_cel_cs2 INTO l_cel05   #歸併後材料序號
      SELECT COUNT(*) INTO l_n FROM cek_file
        WHERE cek01=g_cej.cej01
          AND cek02=g_cej.cej02 
          AND cek03=g_cej.cej03  #特性代碼
          AND cek07=l_cel05
      IF l_n=1 THEN
         SELECT cek10,cek11 INTO l_cek10,l_cek11 
           FROM cek_file
          WHERE cek01=g_cej.cej01
            AND cek02=g_cej.cej02 
            AND cek03=g_cej.cej03  #特性代碼
            AND cek07=l_cel05      
         
         UPDATE cel_file 
            SET cel08=l_cek10,  #單耗
                cel09=l_cek11   #損耗率
          WHERE cel01=g_cej.cej05
            AND cel02=g_cej.cej02 
            AND cel05=l_cel05
            AND cel03=g_cej.cej03  #特性代碼
         IF SQLCA.sqlcode THEN
            CALL cl_err('update cel_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
 
      ELSE
 
         LET l_qty1=0   #單耗
         LET l_qty2=0   #總耗
         LET g_sql="SELECT cek10,cek11 FROM cek_file ",
                   " WHERE cek01='",g_cej.cej01,"'",
                   "   AND cek02='",g_cej.cej02,"'",
                   "   AND cek03='",g_cej.cej03,"'",  #特性代碼
                   "   AND cek07='",l_cel05,"'"
         PREPARE i763_cek_p3 FROM g_sql
         IF SQLCA.SQLCODE THEN
           CALL cl_err('Prepare i763_cek_p3 err !',SQLCA.sqlcode,1)
           LET g_success = 'N' RETURN
         END IF  
         DECLARE i763_cek_cs3 CURSOR FOR i763_cek_p3
         FOREACH i763_cek_cs3 INTO l_cek10,l_cek11    #單耗/損耗率       
           LET l_qty1=l_qty1+l_cek10
           LET l_qty2=l_qty2+l_cek10/(1-l_cek11/100)
         END FOREACH
         LET l_qty3=(1-l_qty1/l_qty2)*100
 
         UPDATE cel_file 
            SET cel08 = l_qty1,
                cel09 = l_qty3
          WHERE cel01=g_cej.cej05
            AND cel02=g_cej.cej02 
            AND cel05=l_cel05
            AND cel03=g_cej.cej03  #特性代碼
         IF SQLCA.sqlcode THEN
            CALL cl_err('update cel_file:',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF    
   END FOREACH       
END FUNCTION
 
 
FUNCTION i763_show_cek()
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cek TO s_cek.* ATTRIBUTE(COUNT=g_rec_k,UNBUFFERED)
      BEFORE DISPLAY  
         CALL cl_navigator_setting(g_curs_index,g_row_count)
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()
 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i763_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY             
 
      ON ACTION previous
         CALL i763_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION jump
         CALL i763_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
 
      ON ACTION next
         CALL i763_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION last
         CALL i763_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac2 = 1
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
         CALL i763_set_pic()
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION show_cek
         LET g_action_choice="show_cek"
         EXIT DISPLAY
            
      ON ACTION show_cel
         LET g_action_choice="show_cel"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
         
      ON ACTION void       
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20025 add
      ON ACTION undo_void         #取消作廢
        LET g_action_choice="undo_void"
        EXIT DISPLAY
      #FUN-D20025 add  
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac2 = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE             
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")      
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
 
FUNCTION i763_show_cel()   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_cel TO s_cel.* ATTRIBUTE(COUNT=g_rec_l,UNBUFFERED)
      BEFORE DISPLAY  #b-->j
         CALL cl_navigator_setting(g_curs_index,g_row_count)
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i763_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY             
 
      ON ACTION previous
         CALL i763_fetch('P')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION jump
         CALL i763_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count) 
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
 
      ON ACTION next
         CALL i763_fetch('N')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION last
         CALL i763_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         IF g_rec_l != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()     
         CALL i763_set_pic()
         
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      
      ON ACTION show_cek
         LET g_action_choice="show_cek"
         EXIT DISPLAY
            
      ON ACTION show_cel
         LET g_action_choice="show_cel"
         EXIT DISPLAY
 
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
         
      ON ACTION void       
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20025 add
      ON ACTION undo_void         #取消作廢
        LET g_action_choice="undo_void"
        EXIT DISPLAY
      #FUN-D20025 add  
 
      ON ACTION cancel
         LET INT_FLAG=FALSE             
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")      
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
 
FUNCTION i763_set_pic()
 
  IF g_cej.cej07 = 'X' THEN
     LET g_void = 'Y'
  ELSE
     LET g_void = 'N'
  END IF
  CALL cl_set_field_pic(g_cej.cej07,"","","",g_void,g_cej.cejacti)
END FUNCTION
 
 
FUNCTION i763_set_entry_b(p_cmd)                                                                                           
  DEFINE p_cmd   LIKE type_file.chr1   
 
  CALL cl_set_comp_entry("cek10,cek11",TRUE) 
END FUNCTION
 
FUNCTION i763_set_no_entry_b(p_cmd)                                                                                        
  DEFINE p_cmd   LIKE type_file.chr1   
 
  CALL cl_set_comp_entry("cek04,cek05,cek06,cek09",FALSE) 
END FUNCTION
 
FUNCTION i763_set_required_b()    
  CALL cl_set_comp_required("cek10,cek11",TRUE) 
END FUNCTION
# FUN-930151
