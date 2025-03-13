# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: sapsq100.4gl
# Descriptions...: APS規劃狀態一覽表
# Date & Author..: 2008/04/22 By rainy #FUN-840156
# Modify.........: No.FUN-840179 08/04/30 By kevin 共用q100
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/27 By douzh GP5.2集團架構調整,azp相關修改
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-840156
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	#wc  	LIKE type_file.chr1000,  
        	#wc2  	LIKE type_file.chr1000  
        	wc          STRING,     #NO.FUN-910082 
        	wc2         STRING     #NO.FUN-910082        	
        END RECORD,
    g_vzu01 LIKE vzu_file.vzu01,   #APS版本
    g_vzu02 LIKE vzu_file.vzu02,   #儲存版本
    g_vdate LIKE type_file.dat,   
    g_rec_b LIKE type_file.num5,          
    g_vzu DYNAMIC ARRAY OF RECORD
            vzu03   LIKE vzu_file.vzu03,
            vzu04   LIKE vzu_file.vzu04,
            vzu05   DATETIME YEAR TO SECOND,
            vzu06   DATETIME YEAR TO SECOND,
            vzu07   LIKE vzu_file.vzu07,
            vzu08   LIKE vzu_file.vzu08
        END RECORD,
    g_argv1         LIKE vzu_file.vzu01,      # INPUT ARGUMENT - 1
    g_argv2         LIKE vzu_file.vzu02,      # INPUT ARGUMENT - 1
    g_sql           string                  
 
DEFINE   p_row         LIKE type_file.num5    
DEFINE   p_col         LIKE type_file.num5    
DEFINE   g_cnt         LIKE type_file.num10   
DEFINE   g_msg         LIKE ze_file.ze03      
DEFINE   g_row_count   LIKE type_file.num10   
DEFINE   g_curs_index  LIKE type_file.num10   
DEFINE   g_jump        LIKE type_file.num10   
DEFINE   mi_no_ask     LIKE type_file.num5    
DEFINE   lc_qbe_sn     LIKE gbm_file.gbm01    
DEFINE   g_seq         LIKE type_file.num5
DEFINE   g_aps_run     LIKE type_file.chr1
DEFINE   g_cmd         STRING
DEFINE   g_init        LIKE type_file.chr1 
 
#FUN-840179 start
FUNCTION q100(p0,p1,p2)
DEFINE   p0         LIKE type_file.chr1,
         p1         LIKE vzu_file.vzu01,
         p2         LIKE vzu_file.vzu02
    
    WHENEVER ERROR CONTINUE
    LET g_aps_run=p0
    LET g_argv1=p1
    LET g_argv2=p2
    
    IF cl_null(p1) THEN 
       CALL q100_defqbe()
    END IF    
    CALL q100_q()   
    
    WHILE TRUE
      LET g_action_choice = NULL      
      CALL q100_menu()
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
#FUN-840179 end
 
FUNCTION q100_defqbe()
  DEFINE l_vzu01  LIKE vzu_file.vzu01,
         l_vzu02  LIKE vzu_file.vzu02
  
  LET g_init="Y"  
  
  {SELECT UNIQUE vzu01,vzu02 INTO l_vzu01,l_vzu02
    FROM vzu_file
   WHERE vzu00 = g_plant
     #AND vzu01 = g_vzu01 #mandy add
     #AND vzu02 = g_vzu02 #mandy add
     AND vzu07 = 'N'
     AND vzu08 = '2'
   IF SQLCA.sqlcode = 100 THEN
     SELECT UNIQUE vzu01,vzu02 INTO l_vzu01,l_vzu02
       FROM vzu_file
      WHERE vzu00 = g_plant
        AND vzu06 = (SELECT MAX(vzu06) FROM vzu_file
                      WHERE vzu00 = g_plant)
     IF SQLCA.sqlcode = 100 THEN
       LET g_argv1 = NULL
       LET g_argv2 = NULL
     ELSE
       LET g_argv1 = l_vzu01
       LET g_argv2 = l_vzu02
     END IF
  ELSE
    LET g_argv1 = l_vzu01
    LET g_argv2 = l_vzu02
  END IF}
END FUNCTION
 
FUNCTION q100_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          
 
   {IF NOT cl_null(g_argv1) THEN
      LET tm.wc = " vzu01 = '",g_argv1,"'",
                  " AND vzu02 = '",g_argv2,"'"
      LET tm.wc2=" 1=1 "
      LET g_argv1 = NULL
      LET g_argv2 = NULL
   ELSE}
   IF g_action_choice = 'idle' THEN
   	  
   	  LET tm.wc = " vzu01 = '",g_vzu01,"'",
                  " AND vzu02 = '",g_vzu02,"'"
                  
      LET tm.wc2=" 1=1 "
      
   	  LET g_sql = " SELECT UNIQUE vzu01,vzu02 FROM vzu_file", 
                  "  WHERE ",tm.wc  CLIPPED,
                  "    AND ",tm.wc2 CLIPPED,
                  "    AND vzu00 = '",g_plant,"'"
      
   ELSE
   
      CLEAR FORM                       # 清除畫面
      CALL g_vzu.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")     
 
      LET g_vzu01 = NULL
      
      IF cl_null(g_init) THEN #FUN-840179
         CONSTRUCT BY NAME tm.wc ON vzu01,vzu02
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
   
         ON ACTION CONTROLP
           IF INFIELD(vzu01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_vzu01"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO vzu01
              NEXT FIELD vzu01
           END IF
    
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
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
         IF INT_FLAG THEN
            RETURN
         END IF
         CALL cl_set_head_visible("","YES")     
   
         CALL q100_b_askkey()             # 取得單身 construct 條件( tm.wc2 )
         IF INT_FLAG THEN
            RETURN
         END IF
         
         MESSAGE ' SEARCHING '
         LET g_sql = " SELECT UNIQUE vzu01,vzu02 FROM vzu_file", 
                  "  WHERE ",tm.wc  CLIPPED,
                  "    AND ",tm.wc2 CLIPPED,
                  "    AND vzu00 = '",g_plant,"'"
      #FUN-840179 --start
      ELSE   
    	    LET g_sql=" SELECT UNIQUE vzu01,vzu02 FROM vzu_file ",              
              "  where vzu07 = 'N' ",
              "    AND vzu08 = '2' ",
              "    AND vzu00 = '",g_plant,"'"   
                         
          LET tm.wc =" 1=1 "    
          LET tm.wc2=" 1=1 "              
          DISPLAY g_sql
      END IF
   END IF   
   #FUN-840179 --end
   LET g_sql = g_sql clipped," ORDER BY vzu01 "
   PREPARE q100_prepare FROM g_sql
   DECLARE q100_cs SCROLL CURSOR FOR q100_prepare
 
  #LET g_sql = " SELECT COUNT(UNIQUE vzu01) ",
  #            " FROM vzu_file ",
  #            " WHERE ",tm.wc  CLIPPED, 
  #            "   AND ",tm.wc2 CLIPPED,
  #            "   AND vzu00 = '",g_plant,"'"
  #PREPARE q100_pp FROM g_sql
  #DECLARE q100_cnt CURSOR FOR q100_pp
 
   IF cl_null(g_init) THEN
   	  LET g_sql="SELECT vzu01,vzu02  ",
             "  FROM vzu_file             ",
             " WHERE ",tm.wc  CLIPPED, 
             "   AND ",tm.wc2 CLIPPED,
             "   AND vzu00 = '",g_plant,"'",
             " GROUP BY vzu01,vzu02 ",
             " INTO TEMP x "
   ELSE
  	  LET g_sql="SELECT vzu01,vzu02  ",
             "  FROM vzu_file ",
             "  where vzu07 = 'N' ",
             "    AND vzu08 = '2' ",
             "   AND vzu00 = '",g_plant,"'",
             " GROUP BY vzu01,vzu02 ",
             " INTO TEMP x "
      LET g_init=NULL                         
   END IF 
  
   DROP TABLE x
   PREPARE q100_cnt_tmp  FROM g_sql
   EXECUTE q100_cnt_tmp
   DECLARE q100_cnt CURSOR FOR SELECT COUNT(*) FROM x
END FUNCTION
 
 
FUNCTION q100_b_askkey()
   CONSTRUCT tm.wc2 ON vzu03,vzu04,vzu05,vzu06,vzu07,vzu08
                  FROM s_vzu[1].vzu03,s_vzu[1].vzu04,
                       s_vzu[1].vzu05,s_vzu[1].vzu06,
                       s_vzu[1].vzu07,s_vzu[1].vzu08
                       
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
END FUNCTION
 
FUNCTION q100_menu()
 
   WHILE TRUE
      CALL q100_bp("G")
      CASE g_action_choice
         WHEN "query"
            CALL q100_q()
         WHEN "jump"
            CALL q100_fetch('/')
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "next"
            CALL q100_fetch('N')
         WHEN "previous"
            CALL q100_fetch('P')
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vzu),'','')
            END IF
         WHEN "aps_run" 
            IF cl_chk_act_auth() THEN
              CALL aps_run()      #FUN-840179
            END IF  
         WHEN "aps_continue" 
            IF cl_chk_act_auth() THEN
              CALL aps_continue() #FUN-840179              
            END IF             
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q100_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q100_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q100_cnt
       FETCH q100_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q100_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q100_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q100_cs INTO g_vzu01,g_vzu02
        WHEN 'P' FETCH PREVIOUS q100_cs INTO g_vzu01,g_vzu02
        WHEN 'F' FETCH FIRST    q100_cs INTO g_vzu01,g_vzu02
        WHEN 'L' FETCH LAST     q100_cs INTO g_vzu01,g_vzu02
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q100_cs INTO g_vzu01,g_vzu02
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_vzu01,SQLCA.sqlcode,0)
        LET g_vzu01 = NULL
        LET g_vzu02 = NULL
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
    SELECT UNIQUE vzu01,vzu02
      INTO g_vzu01,g_vzu02
      FROM vzu_file 
     WHERE vzu01=g_vzu01
       AND vzu02=g_vzu02
       AND vzu00=g_plant
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","vzu_file",g_vzu01,g_vzu02,SQLCA.sqlcode,"","",1)    
        RETURN
    END IF
    CALL q100_show()
END FUNCTION
 
FUNCTION q100_show()
   DISPLAY g_vzu01 TO vzu01
   DISPLAY g_vzu02 TO vzu02
   CALL q100_b_fill() #單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION q100_b_fill()              #BODY FILL UP
   DEFINE i	LIKE type_file.num5          
 
    
      LET g_sql=" SELECT vzu03,vzu04,vzu05,vzu06,vzu07,vzu08 ",
              "   FROM vzu_file ",
              "  WHERE vzu01 = '",g_vzu01,"'",
              "    AND vzu02 = '",g_vzu02,"'",
              "    AND vzu00 = '",g_plant,"'",
              "  ORDER BY vzu03 "
    
    PREPARE q100_pre_bcs FROM g_sql
    DECLARE q100_bcs CURSOR FOR q100_pre_bcs
    CALL g_vzu.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH q100_bcs INTO g_vzu[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
	   EXIT FOREACH
       END IF
    END FOREACH
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_vzu.deleteElement(g_cnt)       
    LET g_rec_b = g_cnt -1
    LET g_cnt = g_cnt-1
    DISPLAY g_cnt TO FORMONLY.cn2
END FUNCTION
 
FUNCTION q100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vzu TO s_vzu.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()  
         #CALL cl_set_act_visible("aps_run", FALSE)#暫不開放
         IF g_aps_run="Y" THEN
   	        CALL cl_set_act_visible("aps_continue", FALSE)
         END IF 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
 
      ON ACTION jump
         CALL q100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL q100_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION next
         CALL q100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL q100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION accept
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      
 
      ON ACTION about        
         CALL cl_about()   
 
      #FUN-840179 start         
      ON ACTION aps_run        
         LET g_action_choice = 'aps_run'
         EXIT DISPLAY
      
      ON ACTION aps_continue       
         LET g_action_choice = 'aps_continue'
         EXIT DISPLAY       
      #FUN-840179 end
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")           
         
      ON IDLE 5          
         LET g_action_choice = 'idle'
         CALL q100_q()
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-840179 start
FUNCTION aps_continue()
DEFINE i	       LIKE type_file.num5      
DEFINE l_proc    LIKE vzu_file.vzu03,
       last_step LIKE vzu_file.vzu03
       
       
    FOR i=1 TO g_cnt    	
    	  IF (g_vzu[i].vzu07="N" OR g_vzu[i].vzu07="F" OR g_vzu[i].vzu07="C")  THEN
    	     LET l_proc = g_vzu[i].vzu03		
    		   EXIT FOR    		 	
    	  END IF
    	  LET last_step=g_vzu[i].vzu03    	
    END FOR
    
#   SELECT azp01 INTO g_plant FROM azp_file WHERE azp03 = g_dbs     #FUN-980020
    
    CASE l_proc
    	 WHEN "10"
    	 	    CALL cl_err('','aps-503',1) ##不可跑程序編號10
    	 	    
       WHEN "20"
       	    IF checkdata("10") THEN
       	    	 LET g_cmd = "apsp600 'erp_export' '",
       	    	                         g_plant CLIPPED,"' '",
       	    	                         g_vzu01 CLIPPED,"' '",                                                                      
                                       '0' CLIPPED,"' ",
                                       " '' '' '",
                                       g_vzu02 CLIPPED,"' "  ##第六參數                              
               DISPLAY  g_cmd                              
               CALL cl_cmdrun_wait(g_cmd)        	    	 
       	    END IF
       	    
       WHEN "30"
       	    IF checkdata("20") THEN
       	    	 LET g_cmd = "apsp600 'erp_export' '",
       	    	                         g_plant CLIPPED,"' '",
       	    	                         g_vzu01 CLIPPED,"' '",                                                                        
                                       '0' CLIPPED,"' ",
                                       " '' '' '",
                                       g_vzu02 CLIPPED,"' "  ##第六參數                              
               DISPLAY  g_cmd                              
               CALL cl_cmdrun_wait(g_cmd)
       	    END IF
       	    
       WHEN "40" #手調器
       	    IF checkdata("30") THEN
       	    	 LET g_cmd = "apst601 '",g_plant CLIPPED,"' '",
       	    	                         g_vzu01 CLIPPED,"' '",
                                       g_vzu02 CLIPPED,"' "                                                       
               DISPLAY  g_cmd                              
               CALL cl_cmdrun_wait(g_cmd)
       	    END IF
    END CASE
END FUNCTION
 
FUNCTION aps_run()
   DEFINE   l_cnt   LIKE type_file.num5          
 
   IF NOT cl_null(g_vzu01) AND NOT cl_null(g_vzu02) THEN
      SELECT count(*) INTO l_cnt 
        FROM vld_file
       WHERE vld01 = g_vzu01
         AND vld02 = g_vzu02
      IF l_cnt <=0 THEN
          CALL cl_err('','aps-502',1)
          RETURN
      END IF
 
      IF cl_confirm("aps-500") THEN
         
         LET g_cmd = "apsp500 '",g_vzu01 CLIPPED,"' '",
                                 g_vzu02 CLIPPED,"' '",
                                 g_user  CLIPPED,"' '",
                                 g_today CLIPPED,"' 'Y' "
                                 
         DISPLAY  g_cmd                                   
         CALL cl_cmdrun_wait(g_cmd)
         LET g_cmd = NULL
      
         IF INT_FLAG THEN
             RETURN
         END IF
         
         BEGIN WORK
         UPDATE vzu_file
            SET vzu07='N'
          WHERE vzu01= g_vzu01 AND vzu02=g_vzu02 AND vzu03>'10'
      
         IF SQLCA.sqlcode THEN              
      	    CALL cl_err3("upd","vzu_file",g_vzu01,g_vzu02,SQLCA.sqlcode,"","",1)      
         ELSE
            MESSAGE 'UPDATE O.K'
            COMMIT WORK
         END IF
      END IF
   END IF
   
END FUNCTION
 
FUNCTION checkdata(last_step)
DEFINE last_step LIKE vzu_file.vzu03
 
   RETURN TRUE   
END FUNCTION
#FUN-840179 end
 
