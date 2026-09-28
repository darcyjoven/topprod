# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: asfq312.4gl
# Descriptions...: 工藝調整單查詢作業
# Date & Author..: NO.FUN-930105 09/03/27 By lilingyu
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/02 By lilingyu 平行工藝
# Modify.........: No.FUN-A70137 10/07/29 By lilingyu 增加"製程段號 組成用量"等欄位邏輯
# Modify.........: No:TQC-D70079 13/07/23 By lujh 查詢的時候直接過濾掉runcard工藝調整資料，不要顯示出來  
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sho              RECORD LIKE sho_file.*,
    g_sho_t            RECORD LIKE sho_file.*,
    g_sho01_t          LIKE sho_file.sho01,
    g_z07,g_s07,g_f07  LIKE sho_file.sho07,
    g_z08,g_s08,g_f08  LIKE sho_file.sho08,
    g_s09,g_f09        LIKE sho_file.sho09,
    g_f10              LIKE sho_file.sho09,  #FUN-A70137 
    g_wc,g_wc2         STRING,  
    g_sql              STRING,  
    g_ecm              DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecm03           LIKE ecm_file.ecm03,      #製程序號
        ecm04           LIKE ecm_file.ecm04       #作業編號
                       END RECORD,
    g_ecm_t            RECORD                     #程式變數 (舊值)
        ecm03           LIKE ecm_file.ecm03,      #製程序號
        ecm04           LIKE ecm_file.ecm04       #作業編號
                       END RECORD,
    g_ecm59            LIKE ecm_file.ecm59,
    g_rec_b            LIKE type_file.num5,                    #單身筆數        
    l_ac               LIKE type_file.num5,                    #目前處理的ARRAY CNT       
    l_sl               LIKE type_file.num5,                    #目前處理的SCREEN LINE     
    g_argv1            LIKE sho_file.sho01 
DEFINE g_chr        LIKE type_file.chr1        
DEFINE g_cnt        LIKE type_file.num10        
DEFINE g_msg        LIKE type_file.chr1000       
DEFINE g_row_count  LIKE type_file.num10        
DEFINE g_curs_index LIKE type_file.num10        
DEFINE g_jump       LIKE type_file.num10         
DEFINE g_no_ask    LIKE type_file.num5          
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_argv1 = ARG_VAL(1)  
 
   INITIALIZE g_sho.* TO NULL
   INITIALIZE g_sho_t.* TO NULL
 
   OPEN WINDOW q312_w WITH FORM "asf/42f/asfq312"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
 
#FUN-A60092 --begin--
  IF g_sma.sma541 = 'Y' THEN 
     CALL cl_set_comp_visible("sho012,g_f10",TRUE)    #FUN-A70137 add g_f10
  ELSE 
     CALL cl_set_comp_visible("sho012,g_f10",FALSE)   #FUN-A70137 add g_f10
  END IF  	  
#FUN-A60092 --end--
 
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      CALL q312_q()
   END IF
   CALL q312_menu()
   CLOSE WINDOW q312_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q312_cs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    
 
   LET  g_wc2=' 1=1'
   CLEAR FORM
   IF cl_null(g_argv1) THEN   
    CALL cl_set_head_visible("","YES")  
    
   INITIALIZE g_sho.* TO NULL    
    CONSTRUCT BY NAME g_wc ON sho01,sho02,sho04,sho012,sho06,   #FUN-A60092 add sho012
                                g_z07,g_z08,g_s07,g_s08,g_s09,g_f07,g_f08,g_f09,
                                g_f10,   #FUN-A70137 add
                                sho12,sho10,sho11
                               ,sho62,sho63,sho64,sho16,sho17   #FUN-A70137  
     
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
    
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(sho01)   #調整單號
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_sho01"     #TQC-D70079 mark
                  LET g_qryparam.form = "q_sho01_1"    #TQC-D70079 add
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho01
                  NEXT FIELD sho01
#FUN-A60092 --begin--
               WHEN INFIELD(sho012) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sho012"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho012
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho012
                  NEXT FIELD sho012
#FUN-A60092 --end--
               WHEN INFIELD(sho04)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb_2"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho04
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho04
                  NEXT FIELD sho04
               WHEN INFIELD(g_s09)   #作業編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecd3"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_s09
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_s09
                  NEXT FIELD g_s09
               WHEN INFIELD(g_f09)   #製程編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ecu"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_f09
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_f09
                  NEXT FIELD g_f09
               WHEN INFIELD(sho10)   #作業員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.default1 = g_sho.sho10
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sho10
                  NEXT FIELD sho10
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
      IF INT_FLAG THEN RETURN END IF
 
      CONSTRUCT g_wc2 ON ecm03,ecm04
                    FROM s_ecm[1].ecm03,s_ecm[1].ecm04
        
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
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc ="sho01 ='",g_argv1,"'"
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                            # 只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND shouser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                            # 只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND shogrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND shogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shouser', 'shogrup')
   #End:FUN-980030
 
   IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
      LET g_sql="SELECT sho01 FROM sho_file ",                      #09/10/21 xiaofeizhu Add
                " WHERE ",g_wc CLIPPED,
                "   AND sho01 IS NOT NULL ",    #TQC-D70079 add
                "   AND sho04 IS NOT NULL ",    #TQC-D70079 add
                " ORDER BY sho01"
   ELSE
      LET g_sql="SELECT sho01",                                     #09/10/21 xiaofeizhu Add
                "  FROM sho_file,ecm_file ",
                " WHERE sho04=ecm01 ",
                "   AND sho012=ecm012",  #FUN-A60092 add
                "   AND sho07 =ecm03",   #FUN-A70137 add
                "   AND sho01 IS NOT NULL ",    #TQC-D70079 add
                "   AND sho04 IS NOT NULL ",    #TQC-D70079 add
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY sho01"
   END IF
 
   PREPARE q312_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE q312_cs SCROLL CURSOR WITH HOLD FOR q312_prepare
 
   IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
      LET g_sql= "SELECT COUNT(*) FROM sho_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND sho01 IS NOT NULL ",    #TQC-D70079 add
                 "   AND sho04 IS NOT NULL "     #TQC-D70079 add
   ELSE
      LET g_sql= "SELECT COUNT(DISTINCT sho01) FROM sho_file,ecm_file ",
                 " WHERE sho04=ecm01 ",
                 "   AND sho012=ecm012",  #FUN-A60092 add                 
                 "   AND sho07 =ecm03",   #FUN-A70137 add                 
                 "   AND sho01 IS NOT NULL ",    #TQC-D70079 add
                 "   AND sho04 IS NOT NULL ",    #TQC-D70079 add
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE q312_precount FROM g_sql
   DECLARE q312_count CURSOR FOR q312_precount
END FUNCTION
 
FUNCTION q312_menu()
 
   WHILE TRUE
      CALL q312_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q312_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecm),'','')
            END IF
      END CASE
   END WHILE
   CLOSE q312_cs
END FUNCTION
 
FUNCTION q312_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    
    CALL q312_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN q312_count
    FETCH q312_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q312_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sho.sho01,SQLCA.sqlcode,0)
       INITIALIZE g_sho.* TO NULL
    ELSE
       CALL q312_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION q312_fetch(p_flsho)
    DEFINE p_flsho          LIKE type_file.chr1,        
           l_abso           LIKE type_file.num10        
 
    CASE p_flsho
        WHEN 'N' FETCH NEXT     q312_cs INTO g_sho.sho01                #09/10/21 xiaofeizhu Add
        WHEN 'P' FETCH PREVIOUS q312_cs INTO g_sho.sho01                #09/10/21 xiaofeizhu Add
        WHEN 'F' FETCH FIRST    q312_cs INTO g_sho.sho01                #09/10/21 xiaofeizhu Add
        WHEN 'L' FETCH LAST     q312_cs INTO g_sho.sho01                #09/10/21 xiaofeizhu Add
        WHEN '/'
            IF (NOT g_no_ask) THEN 
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0 
                PROMPT g_msg CLIPPED,': ' FOR  g_jump
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
            FETCH ABSOLUTE  g_jump q312_cs INTO g_sho.sho01             #09/10/21 xiaofeizhu Add
            LET g_no_ask = FALSE    
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sho.sho01,SQLCA.sqlcode,0)
        INITIALIZE g_sho.* TO NULL  
        RETURN
    ELSE
       CASE p_flsho
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_sho.* FROM sho_file       # 重讀DB,因TEMP有不被更新特性
     WHERE sho01 = g_sho.sho01                                          #09/10/21 xiaofeizhu Add  
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sho_file",g_sho.sho01,"",SQLCA.sqlcode,"","",1)   
       INITIALIZE g_sho.* TO NULL          
    ELSE
       LET g_data_owner = g_sho.shouser     
       LET g_data_group = g_sho.shogrup     
       CALL q312_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION q312_show()
    DEFINE l_gen02   LIKE gen_file.gen02
 
    LET g_sho_t.* = g_sho.*
 
    DISPLAY BY NAME g_sho.sho01, g_sho.sho02, g_sho.sho04, g_sho.sho06,
                    g_sho.sho12, g_sho.sho10, g_sho.sho11
                   ,g_sho.sho012   #FUN-A60092 add 
                   ,g_sho.sho16,g_sho.sho17,g_sho.sho62,g_sho.sho63,g_sho.sho64  #FUN-A70137 add
    DISPLAY '' TO FORMONLY.g_z07
    DISPLAY '' TO FORMONLY.g_z08
    DISPLAY '' TO FORMONLY.g_z09
    DISPLAY '' TO FORMONLY.g_s07
    DISPLAY '' TO FORMONLY.g_s08
    DISPLAY '' TO FORMONLY.g_s09
    DISPLAY '' TO FORMONLY.g_f07
    DISPLAY '' TO FORMONLY.g_f08
    DISPLAY '' TO FORMONLY.g_f09
    DISPLAY g_sho.sho112 TO FORMONLY.g_f10  #FUN-A70137 add
    CASE g_sho.sho06
         WHEN '1'   
            DISPLAY g_sho.sho07 TO FORMONLY.g_z07
            DISPLAY g_sho.sho08 TO FORMONLY.g_z08
            DISPLAY '' TO FORMONLY.g_z09
         WHEN '2'   
            DISPLAY g_sho.sho07 TO FORMONLY.g_s07
            DISPLAY g_sho.sho08 TO FORMONLY.g_s08
            DISPLAY g_sho.sho09 TO FORMONLY.g_s09
         WHEN '3'   
            DISPLAY g_sho.sho07 TO FORMONLY.g_f07
            DISPLAY g_sho.sho08 TO FORMONLY.g_f08
            DISPLAY g_sho.sho09 TO FORMONLY.g_f09
         OTHERWISE  
            DISPLAY g_sho.sho07 TO FORMONLY.g_z07
            DISPLAY g_sho.sho08 TO FORMONLY.g_z08
            DISPLAY '' TO FORMONLY.g_z09
    END CASE
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_sho.sho10
    IF STATUS THEN
       LET l_gen02 = ' '
    END IF
    DISPLAY l_gen02 TO FORMONLY.gen02
    CALL q312_b_fill(g_wc2)
    CALL cl_show_fld_cont()                
 
   IF g_sho.sho01 IS NOT NULL AND g_sho.sho04 IS NULL THEN   
      CALL cl_err('','asf-045',1)
   END IF 
END FUNCTION
 
FUNCTION q312_b_askkey()
 
    CONSTRUCT g_wc2 ON ecm03,ecm04
                  FROM s_ecm[1].ecm03,s_ecm[1].ecm04
 
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
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q312_b_fill(g_wc2)
END FUNCTION
 
FUNCTION q312_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ecm TO s_ecm.* ATTRIBUTE(COUNT = g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q312_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q312_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL q312_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
 
      ON ACTION next
         CALL q312_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                
 
      ON ACTION last
         CALL q312_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                 
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
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
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
                                                                                                     
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)  #NO.FUN-930105
END FUNCTION
 
FUNCTION q312_b_fill(p_wc2)             
    DEFINE p_wc2           LIKE type_file.chr1000      
 
    LET g_sql ="SELECT ecm03,ecm04 ",
               "  FROM ecm_file",
               " WHERE ecm01 = '",g_sho.sho04, "'",
               "   AND ecm012= '",g_sho.sho012,"'",  #FUN-A60092 add
               "   AND ecm03 = '",g_sho.sho07,"'",  #FUN-A70137 add
               "   AND ",g_wc2 CLIPPED,
               " ORDER BY ecm03,ecm04 "
    PREPARE q312_pb FROM g_sql
    DECLARE ecm_curs CURSOR FOR q312_pb
 
    CALL g_ecm.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ecm_curs  INTO g_ecm[g_cnt].*     #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1                                                                                               
                                                                                                                            
        IF g_cnt > g_max_rec THEN                                                                                           
          CALL cl_err( '',9035,1)                                                                                          
          EXIT FOREACH                                                                                                     
        END IF                                                                                                              
    END FOREACH                                                                                                             
    CALL g_ecm.deleteElement(g_cnt)                                                                                         
 
    LET g_rec_b= g_cnt-1                                                                                                    
    DISPLAY g_rec_b TO FORMONLY.cn2                                                                                         
    LET g_cnt = 0                                                                                                           
                                                                                                                             
END FUNCTION 
