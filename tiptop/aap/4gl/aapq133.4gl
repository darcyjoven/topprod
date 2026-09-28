# Prog. Version..: '5.25.04-11.09.15(00007)'     #
#
# Pattern name...: aapq133.4gl
# Descriptions...: 暫估月度統計查詢作業
# Date & Author..: 12/11/29 By wangrr   #FUN-CB0120
# ...............: NO.FUN-D60022 13/06/06 By yuhuabao 由aglq133->aapq133(删除aglq133)
# Modify.........: No.FUN-D10110 13/07/01 By wangrr 9主機追單,在個本幣金額旁邊增加原幣金額欄位,本幣金額採用月底重評估匯率計算本幣金額

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_ape02    LIKE ape_file.ape02,
       g_ape03    LIKE ape_file.ape03
DEFINE g_ape      DYNAMIC ARRAY OF RECORD
       ape01      LIKE ape_file.ape01,
       pmc03      LIKE pmc_file.pmc03,
       ape04      LIKE ape_file.ape04,
       ima02      LIKE ima_file.ima02,
       ima021     LIKE ima_file.ima021,
       ape30      LIKE ape_file.ape30,   #FUN-D10110
       ape41      LIKE ape_file.ape41,   #FUN-D10110
       ape05      LIKE ape_file.ape05,
       ape06      LIKE ape_file.ape06,
       ape31      LIKE ape_file.ape31,   #FUN-D10110
       ape07      LIKE ape_file.ape07,
       ape32      LIKE ape_file.ape32,   #FUN-D10110
       ape08      LIKE ape_file.ape08,
       ape09      LIKE ape_file.ape09,
       ape10      LIKE ape_file.ape10,
       ape33      LIKE ape_file.ape33,   #FUN-D10110
       ape11      LIKE ape_file.ape11,
       ape34      LIKE ape_file.ape34,   #FUN-D10110
       ape12      LIKE ape_file.ape12,
       ape13      LIKE ape_file.ape13,
       ape14      LIKE ape_file.ape14,
       ape35      LIKE ape_file.ape35,   #FUN-D10110
       ape15      LIKE ape_file.ape15,
       ape36      LIKE ape_file.ape36,   #FUN-D10110
       ape16      LIKE ape_file.ape16,
       ape37      LIKE ape_file.ape37,   #FUN-D10110
       ape17      LIKE ape_file.ape17,
       ape38      LIKE ape_file.ape38,   #FUN-D10110
       ape18      LIKE ape_file.ape18,
       ape19      LIKE ape_file.ape19,
       ape20      LIKE ape_file.ape20,
       ape39      LIKE ape_file.ape39,   #FUN-D10110
       ape21      LIKE ape_file.ape21,
       ape40      LIKE ape_file.ape40,   #FUN-D10110
       ape22      LIKE ape_file.ape22,
       ape42      LIKE ape_file.ape42,   #FUN-D10110
       ape43      LIKE ape_file.ape43    #FUN-D10110
       END RECORD
DEFINE g_wc,g_sql       STRING,
       l_ac             LIKE type_file.num5,    
       g_rec_b          LIKE type_file.num5   
DEFINE g_cnt            LIKE type_file.num10  
DEFINE g_msg            LIKE type_file.chr1000
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
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time       #計算使用時間 (進入時間) 
            
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW q133_w AT p_row,p_col WITH FORM "aap/42f/aapq133" #FUN-D60022
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL q133_menu()
   CLOSE WINDOW q133_w             #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time       #計算使用時間 (退出使間)
END MAIN

#QBE 查詢資料
FUNCTION q133_cs()
  
   CLEAR FORM #清除畫面
   CALL g_ape.clear()
   CALL cl_opmsg('q')
   LET g_ape02=NULL
   LET g_ape03=NULL
   CALL cl_set_head_visible("","YES")    
   #FUN-D10110--MOD--str--
   #CONSTRUCT g_wc ON ape02,ape03,ape01,ape04,ape05,ape06,ape07,ape08,ape09,
   #                  ape10,ape11,ape12,ape13,ape14,ape15,ape16,ape17,ape18,
   #                  ape19,ape20,ape21,ape22
   #             FROM ape02,ape03,s_ape[1].ape01,s_ape[1].ape04,s_ape[1].ape05,
   #                  s_ape[1].ape06,s_ape[1].ape07,s_ape[1].ape08,s_ape[1].ape09,
   #                  s_ape[1].ape10,s_ape[1].ape11,s_ape[1].ape12,s_ape[1].ape13,
   #                  s_ape[1].ape14,s_ape[1].ape15,s_ape[1].ape16,s_ape[1].ape17,
   #                  s_ape[1].ape18,s_ape[1].ape19,s_ape[1].ape20,s_ape[1].ape21,
   #                  s_ape[1].ape22
   CONSTRUCT g_wc ON ape02,ape03,ape01,ape04,ape30,ape41,ape05,ape06,ape31,ape07,
                     ape32,ape08,ape09,ape10,ape33,ape11,ape34,ape12,ape13,ape14,
                     ape35,ape15,ape36,ape16,ape37,ape17,ape38,ape18,ape19,ape20,
                     ape39,ape21,ape40,ape22,ape42,ape43
                FROM ape02,ape03,s_ape[1].ape01,s_ape[1].ape04,s_ape[1].ape30,
                     s_ape[1].ape41,s_ape[1].ape05,s_ape[1].ape06,s_ape[1].ape31,
                     s_ape[1].ape07,s_ape[1].ape32,s_ape[1].ape08,s_ape[1].ape09,
                     s_ape[1].ape10,s_ape[1].ape33,s_ape[1].ape11,s_ape[1].ape34,
                     s_ape[1].ape12,s_ape[1].ape13,s_ape[1].ape14,s_ape[1].ape35,
                     s_ape[1].ape15,s_ape[1].ape36,s_ape[1].ape16,s_ape[1].ape37,
                     s_ape[1].ape17,s_ape[1].ape38,s_ape[1].ape18,s_ape[1].ape19,
                     s_ape[1].ape20,s_ape[1].ape39,s_ape[1].ape21,s_ape[1].ape40,
                     s_ape[1].ape22,s_ape[1].ape42,s_ape[1].ape43
   #FUN-D10110--MOD--end
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
             
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ape01) #供應商
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ape01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ape01	
               NEXT FIELD ape01
            WHEN INFIELD(ape04) #料號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ape04"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ape04	
               NEXT FIELD ape04
            #FUN-D10110--add--str--
             WHEN INFIELD(ape30) #幣種
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ape30"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ape30	
               NEXT FIELD ape30
            #FUN-D10110--add--end
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
 
   LET g_sql="SELECT DISTINCT ape02,ape03 FROM ape_file",
             " WHERE ",g_wc CLIPPED,
             " ORDER BY ape02,ape03 "
   PREPARE q133_prepare FROM g_sql
   DECLARE q133_cs SCROLL CURSOR FOR q133_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT(ape02||ape03)) FROM ape_file ",
             " WHERE ",g_wc
   PREPARE q133_precount FROM g_sql
   DECLARE q133_count CURSOR FOR q133_precount
END FUNCTION
 
#中文的MENU
FUNCTION q133_menu()
   DEFINE l_cmd     STRING
   
   WHILE TRUE
      CALL q133_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q133_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET l_cmd='p_query "aapq133" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ape),'','')
             END IF
          WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_ape02) THEN
                  LET g_doc.column1 = "ape02"
                  LET g_doc.value1 = g_ape02
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q133_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL q133_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q133_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
   ELSE
       OPEN q133_count
       FETCH q133_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q133_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION q133_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1    #處理方式 
 
   CASE p_flag
       WHEN 'N' FETCH NEXT     q133_cs INTO g_ape02,g_ape03
       WHEN 'P' FETCH PREVIOUS q133_cs INTO g_ape02,g_ape03
       WHEN 'F' FETCH FIRST    q133_cs INTO g_ape02,g_ape03
       WHEN 'L' FETCH LAST     q133_cs INTO g_ape02,g_ape03
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
          FETCH ABSOLUTE g_jump q133_cs INTO g_ape02,g_ape03
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       LET g_ape02=NULL
       LET g_ape03=NULL
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

   CALL q133_show()
END FUNCTION
 
FUNCTION q133_show()
   DISPLAY g_ape02,g_ape03 TO ape02,ape03
   CALL q133_b_fill() #單身
   CALL cl_show_fld_cont()  
END FUNCTION
 
FUNCTION q133_b_fill()              #BODY FILL UP
   #FUN-D10110--MOD--str--
   #LET g_sql ="SELECT ape01,pmc03,ape04,ima02,ima021,ape05,ape06,ape07,ape08,ape09,",
   #           "       ape10,ape11,ape12,ape13,ape14,ape15,ape16,ape17,ape18,ape19,",
   #           "       ape20,ape21,ape22",
   LET g_sql ="SELECT ape01,pmc03,ape04,ima02,ima021,ape30,ape41,ape05,ape06,",
              "       ape31,ape07,ape32,ape08,ape09,ape10,ape33,ape11,ape34,ape12,",
              "       ape13,ape14,ape35,ape15,ape36,ape16,ape37,ape17,ape38,ape18,",
              "       ape19,ape20,ape39,ape21,ape40,ape22,ape42,ape43 ",
   #FUN-D10110--MOD--end
              "  FROM ape_file LEFT OUTER JOIN pmc_file ON (ape01=pmc01) ",
              "                LEFT OUTER JOIN ima_file ON (ape04=ima01) ",
              " WHERE ape02 = ",g_ape02,
              "   AND ape03 = ",g_ape03,
              "   AND ",g_wc CLIPPED,
              " ORDER BY ape03 "
    PREPARE q133_pb FROM g_sql
    IF STATUS THEN CALL cl_err('q133_pb',STATUS,1) RETURN END IF
    DECLARE q133_bcs CURSOR FOR q133_pb
    CALL g_ape.clear()
    LET g_cnt = 1
    FOREACH q133_bcs INTO g_ape[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH q133_bcs:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN  
          CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ape.deleteElement(g_cnt) 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q133_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ape TO s_ape.* ATTRIBUTE(UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()       
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q133_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q133_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL cl_set_act_visible("accept,cancel", TRUE)     
         CALL q133_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL q133_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL q133_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
      ON ACTION OUTPUT
         LET g_action_choice="output"
         EXIT DISPLAY
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
 
