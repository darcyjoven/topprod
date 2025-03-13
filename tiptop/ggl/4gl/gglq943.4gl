# Prog. Version..: '5.30.09-13.09.06(00000)'     #
#
# Pattern name...: gglq943.4gl
# Descriptions...: 暫估月度統計查詢作業
# Date & Author..: 13/10/17 By wangrr   #FUN-DA0076


DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_tic00    LIKE tic_file.tic00,
       g_tic01    LIKE tic_file.tic01
DEFINE g_tic      DYNAMIC ARRAY OF RECORD
       tic02      LIKE tic_file.tic02,
       tic03      LIKE tic_file.tic03,
       tic04      LIKE tic_file.tic04,
       tic05      LIKE tic_file.tic05, 
       tic06      LIKE tic_file.tic06,
       nml02      LIKE nml_file.nml02, 
       tic07      LIKE tic_file.tic07,
       tic07f     LIKE tic_file.tic07f,
       tic08      LIKE tic_file.tic08,
       tic09      LIKE tic_file.tic09,
       nppglno    LIKE npp_file.nppglno,
       npq04      LIKE npq_file.npq04
       END RECORD
DEFINE g_nmz70    LIKE nmz_file.nmz70
DEFINE g_wc,g_sql       STRING,
       l_ac             LIKE type_file.num5,    
       g_rec_b          LIKE type_file.num5   
DEFINE g_cnt            LIKE type_file.num10  
DEFINE g_msg            STRING
DEFINE g_row_count      LIKE type_file.num10   
DEFINE g_curs_index     LIKE type_file.num10   
DEFINE g_jump           LIKE type_file.num10   
DEFINE mi_no_ask        LIKE type_file.num5   

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS                                 
        INPUT NO WRAP
    DEFER INTERRUPT                        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time       #計算使用時間 (進入時間) 
            
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW q943_w AT p_row,p_col WITH FORM "ggl/42f/gglq943" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()

   SELECT nmz70 INTO g_nmz70 FROM nmz_file
   IF g_nmz70='2' THEN
      CALL cl_set_comp_visible('nppglno',FALSE)
   END IF
   CALL q943_menu()
   CLOSE WINDOW q943_w             #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time       #計算使用時間 (退出使間)
END MAIN

#QBE 查詢資料
FUNCTION q943_cs()

   CLEAR FORM #清除畫面
   CALL g_tic.clear()
   CALL cl_opmsg('q')
   LET g_tic00=g_aza.aza81
   LET g_tic01=s_get_aznn(g_plant,g_aza.aza81,g_today,1)
   CALL cl_set_head_visible("","YES")    
   
   CONSTRUCT g_wc ON tic00,tic01,tic02,tic03,tic04,tic05,tic06,tic07,tic07f,
                     tic08,tic09
                FROM tic00,tic01,s_tic[1].tic02,s_tic[1].tic03,s_tic[1].tic04,
                     s_tic[1].tic05,s_tic[1].tic06,s_tic[1].tic07,
                     s_tic[1].tic07f,s_tic[1].tic08,s_tic[1].tic09
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         DISPLAY g_tic00,g_tic01 TO tic00,tic01 
         
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(tic00) #帳套
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tic00"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tic00	
               NEXT FIELD tic00
            WHEN INFIELD(tic04) #參考單號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tic04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tic04	
               NEXT FIELD tic04
             WHEN INFIELD(tic06) #現金變動碼
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_tic06"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO tic06
               NEXT FIELD tic06
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
         CALL cl_qbe_select()
      ON ACTION qbe_save
		 CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   IF cl_null(g_wc) THEN LET g_wc=" 1=1 " END IF
 
   LET g_sql="SELECT DISTINCT tic00,tic01 FROM tic_file",
             " WHERE ",g_wc CLIPPED,
             " ORDER BY tic00,tic01 "
   PREPARE q943_prepare FROM g_sql
   DECLARE q943_cs SCROLL CURSOR FOR q943_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT(tic00||tic01)) FROM tic_file ",
             " WHERE ",g_wc
   PREPARE q943_precount FROM g_sql
   DECLARE q943_count CURSOR FOR q943_precount
END FUNCTION
 
#中文的MENU
FUNCTION q943_menu()
   DEFINE l_cmd     STRING
   
   WHILE TRUE
      CALL q943_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q943_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tic),'','')
             END IF
          WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_tic00) THEN
                  LET g_doc.column1 = "tic00"
                  LET g_doc.value1 = g_tic00
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q943_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q943_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q943_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
       OPEN q943_count
       FETCH q943_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q943_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION q943_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1    #處理方式 
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     q943_cs INTO g_tic00,g_tic01
       WHEN 'P' FETCH PREVIOUS q943_cs INTO g_tic00,g_tic01
       WHEN 'F' FETCH FIRST    q943_cs INTO g_tic00,g_tic01
       WHEN 'L' FETCH LAST     q943_cs INTO g_tic00,g_tic01
       WHEN '/'
          IF NOT mi_no_ask THEN
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
          FETCH ABSOLUTE g_jump q943_cs INTO g_tic00,g_tic01
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_tic00=NULL
       LET g_tic01=NULL
       RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      DISPLAY g_curs_index TO FORMONLY.idx
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF

   CALL q943_show()
END FUNCTION
 
FUNCTION q943_show()
   DISPLAY g_tic00,g_tic01 TO tic00,tic01
   CALL q943_b_fill() #單身
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION q943_b_fill()              #BODY FILL UP
   LET g_sql ="SELECT tic02,tic03,tic04,tic05,tic06,nml02,",
              "       tic07,tic07f,tic08,tic09,'','' ",
              "  FROM tic_file LEFT OUTER JOIN nml_file ON (tic06=nml01) ",
              " WHERE tic00 = '",g_tic00,"'",
              "   AND tic01 =  ",g_tic01,
              "   AND ",g_wc CLIPPED,
              " ORDER BY tic02,tic03,tic04,tic05 "
    PREPARE q943_pb FROM g_sql
    IF STATUS THEN CALL cl_err('q943_pb',STATUS,1) RETURN END IF
    DECLARE q943_bcs CURSOR FOR q943_pb
    CALL g_tic.clear()
    LET g_cnt = 1
    FOREACH q943_bcs INTO g_tic[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH q943_bcs:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       CASE
          WHEN g_nmz70='1'
             SELECT nme10,nme05 INTO g_tic[g_cnt].nppglno,g_tic[g_cnt].npq04
             FROM nme_file 
             WHERE nme27=g_tic[g_cnt].npq04
          WHEN g_nmz70='2'
             SELECT abb01,abb04 INTO g_tic[g_cnt].nppglno,g_tic[g_cnt].npq04
             FROM abb_file 
             WHERE abb00=g_tic00
               AND abb01=g_tic[g_cnt].tic04 
               AND abb02=g_tic[g_cnt].tic05
          WHEN g_nmz70='3'
             SELECT nppglno INTO g_tic[g_cnt].nppglno FROM npp_file
             WHERE npp01=g_tic[g_cnt].tic04
             SELECT npq04 INTO g_tic[g_cnt].npq04 FROM npq_file
             WHERE npq01=g_tic[g_cnt].tic04 AND npq02=g_tic[g_cnt].tic05
       END CASE
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN  
          CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
       END IF
    END FOREACH
    CALL g_tic.deleteElement(g_cnt) 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q943_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tic TO s_tic.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()       
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q943_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q943_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)     
         CALL q943_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL q943_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q943_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
     
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds 
         CALL cl_on_idle()   
         CONTINUE DISPLAY    
 
      ON ACTION about        
         CALL cl_about()     
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY   
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                                                                                         	
         CALL cl_set_head_visible("","AUTO")   
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-DA0076--add 
