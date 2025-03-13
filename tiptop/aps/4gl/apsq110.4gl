# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apsq110.4gl
# Descriptions...: 
# Date & Author..: 08/04/28 By Kevin #FUN-840179
# Modify.........: No.FUN-860105 08/06/26 By kevin 可以使用上下一筆
# Modify.........: No.FUN-870061 08/07/10 By kevin 顯示開始和結束時間
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: NO.TQC-940088 09/05/08 BY destiny vzu05,vzu06定義成DATETIME YEAR TO SECOND在msv環境下執行到foreach時會報錯
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B50050 11/05/10 By Mandy APS GP5.25 追版---str---
# Modify.........: No.TQC-950078 09/05/13 By Duke 開始時間及結束時間的show出來的時分秒欄位值不正確
# Modify.........: No:FUN-B50050 11/05/10 By Mandy ------------------end---
# Modify.........: No:FUN-CC0150 13/01/09 By Mandy 傳給APS時增加傳<code9> 此碼傳legal code(法人)
 
DATABASE ds
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE
    tm  RECORD
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
           #vzu05   LIKE type_file.dat,                   #No.TQC-940088 #TQC-950078 mark 
            vzu05   LIKE type_file.chr20,                                #TQC-950078 add
           #vzu06   LIKE type_file.dat,                   #No.TQC-940088 #TQC-950078 mark 
            vzu06   LIKE type_file.chr20,                                #TQC-950078 add
            vzu07   LIKE vzu_file.vzu07,
            vzu08   LIKE vzu_file.vzu08
        END RECORD,    
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
DEFINE   g_argv1       LIKE vzu_file.vzu01,     # INPUT ARGUMENT - 1
         g_argv2       LIKE vzu_file.vzu02      # INPUT ARGUMENT - 1
DEFINE   ms_pic_url    STRING  
DEFINE   g_msg525      LIKE ze_file.ze03
DEFINE   g_msg526      LIKE ze_file.ze03
DEFINE   g_msg527      LIKE ze_file.ze03
DEFINE   g_msg528      LIKE ze_file.ze03
DEFINE   g_msg529      LIKE ze_file.ze03      
DEFINE   g_msg530      LIKE ze_file.ze03      
DEFINE   g_msg531      LIKE ze_file.ze03
 
MAIN
   DEFINE l_cnt    LIKE type_file.num5
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   
   LET g_argv1 = ARG_VAL(1) CLIPPED     
   LET g_argv2 = ARG_VAL(2) CLIPPED  
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW apsq110_w AT p_row,p_col WITH FORM "aps/42f/apsq110"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()   
    
    LET ms_pic_url = FGL_GETENV("FGLASIP")
    CALL cl_getmsg('aps-525',g_lang) RETURNING g_msg525 #執行成功
    CALL cl_getmsg('aps-526',g_lang) RETURNING g_msg526 #未執行
    CALL cl_getmsg('aps-527',g_lang) RETURNING g_msg527 #執行中
    CALL cl_getmsg('aps-528',g_lang) RETURNING g_msg528 #執行失敗
    CALL cl_getmsg('aps-529',g_lang) RETURNING g_msg529 #強制結束
    CALL cl_getmsg('aps-530',g_lang) RETURNING g_msg530 #啟動時間
    CALL cl_getmsg('aps-531',g_lang) RETURNING g_msg531 #結束時間
    CALL q110()
    
    CLOSE WINDOW apsq110_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
   
END MAIN
 
FUNCTION q110()
   WHILE TRUE
      LET g_action_choice = NULL      
      CALL q110_menu()
      IF g_action_choice = "exit" THEN
         EXIT WHILE
      END IF
   END WHILE   
END FUNCTION
 
FUNCTION q110_menu() 
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      ON ACTION query
         LET g_action_choice="query"
         CALL q110_q()
         CALL btn_status()         
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU           
         
      ON ACTION next
         CALL q110_fetch('N')
         CALL btn_status()
         
      ON ACTION PREVIOUS
         CALL q110_fetch('P')  
         CALL btn_status()
 
      ON ACTION FIRST
         CALL q110_fetch('F')  
         CALL btn_status()         
         
      ON ACTION LAST 
         CALL q110_fetch('L')  
         CALL btn_status()         
 
      ON ACTION bt01
         CALL aps_run()
         CONTINUE MENU
                    
      ON ACTION bt10
         CALL cl_err('','aps-503',1) ##不可跑程序編號10
         CONTINUE MENU    
        
      ON ACTION bt20
         IF checkdata("20") THEN
       	    	 LET g_cmd = "apsp600 'erp_export' '",
       	    	                         g_plant CLIPPED,"' '",
       	    	                         g_vzu01 CLIPPED,"' '",                                                                      
                                       '0' CLIPPED,"' ",
                                       " '' '' '",
                                       g_vzu02 CLIPPED,"' ", ##第六參數                              
                                       " '' ",          #FUN-CC0150 add
                                       " '' ",          #FUN-CC0150 add
                                       "'",g_legal,"'"  #FUN-CC0150 add
               DISPLAY  g_cmd                              
               CALL cl_cmdrun_wait(g_cmd)        	    	 
       	 END IF
         CONTINUE MENU   
 
      ON ACTION bt30
         IF checkdata("20") THEN
       	    	 LET g_cmd = "apsp600 'erp_export' '",
       	    	                         g_plant CLIPPED,"' '",
       	    	                         g_vzu01 CLIPPED,"' '",                                                                      
                                       '0' CLIPPED,"' ",
                                       " '' '' '",
                                       g_vzu02 CLIPPED,"' ", ##第六參數                              
                                       " '' ",          #FUN-CC0150 add
                                       " '' ",          #FUN-CC0150 add
                                       "'",g_legal,"'"  #FUN-CC0150 add
               DISPLAY  g_cmd                              
               CALL cl_cmdrun_wait(g_cmd)        	    	 
       	 END IF
         CONTINUE MENU           
 
      ON ACTION bt40 #手調器
           IF checkdata("40") THEN           	  
                 LET g_cmd = "apst601 '",g_plant CLIPPED,"' '",
       	    	                     g_vzu01 CLIPPED,"' ",
       	    	                     " '0' " #儲存版本為'0'
                                                 
                 DISPLAY  g_cmd                              
                 CALL cl_cmdrun_wait(g_cmd)              
           END IF
           CONTINUE MENU  
           
      ON ACTION bt50
           CONTINUE MENU                         
 
      ON ACTION bt60
           CONTINUE MENU
           
      ON IDLE 5   
         CALL btn_status()        
         CONTINUE MENU
         
      ON ACTION controlg
         CALL cl_cmdask()
        
      ON ACTION locale
         CALL cl_dynamic_locale()
        
      ON ACTION qbe_select
         CALL cl_qbe_select()
           
      ON ACTION qbe_save
         CALL cl_qbe_save()   
         
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE
          LET g_action_choice = "exit"
          EXIT MENU
      
      
   END MENU
END FUNCTION
 
FUNCTION q110_cs()                         # QBE 查詢資料
   DEFINE   l_cnt   LIKE type_file.num5          
   
      CLEAR FORM                       # 清除畫面
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			# Default condition
      CALL cl_set_head_visible("","YES")
 
      LET g_vzu01 = NULL      
      
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
              CALL cl_create_qry() RETURNING g_vzu01,g_vzu02
              DISPLAY g_vzu01 TO vzu01
              DISPLAY g_vzu02 TO vzu02
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
         
         IF INT_FLAG THEN
            RETURN
         END IF
         
         MESSAGE ' SEARCHING '
         LET g_sql = " SELECT UNIQUE vzu01,vzu02 FROM vzu_file", 
                  "  WHERE ",tm.wc  CLIPPED,                  
                  "    AND vzu00 = '",g_plant,"'"
         
         LET g_sql = g_sql clipped," ORDER BY vzu01 "
         PREPARE q110_prepare FROM g_sql
         DECLARE q110_cs SCROLL CURSOR FOR q110_prepare     
         
         LET g_sql="SELECT vzu01,vzu02  ",
             "  FROM vzu_file   ",
             " WHERE ",tm.wc  CLIPPED,             
             "   AND vzu00 = '",g_plant,"'",
             " GROUP BY vzu01,vzu02 ",
             " INTO TEMP x "
             
         DROP TABLE x
         PREPARE q110_cnt_tmp  FROM g_sql
         EXECUTE q110_cnt_tmp
         DECLARE q110_cnt CURSOR FOR SELECT COUNT(*) FROM x
   
END FUNCTION   
 
FUNCTION q110_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q110_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q110_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q110_cnt
       FETCH q110_cnt INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q110_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''  
    CALL q110_show()  
END FUNCTION    
 
FUNCTION q110_show()
   DISPLAY g_vzu01 TO vzu01
   DISPLAY g_vzu02 TO vzu02
   CALL cl_show_fld_cont() 
END FUNCTION
 
 
FUNCTION q110_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1      #處理方式   #No.FUN-680096 VARCHAR(1)
    
    CASE p_flag
        WHEN 'N' FETCH NEXT     q110_cs INTO g_vzu01,g_vzu02
        WHEN 'P' FETCH PREVIOUS q110_cs INTO g_vzu01,g_vzu02
        WHEN 'F' FETCH FIRST    q110_cs INTO g_vzu01,g_vzu02
        WHEN 'L' FETCH LAST     q110_cs INTO g_vzu01,g_vzu02
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
            FETCH ABSOLUTE g_jump q110_cs INTO g_vzu01,g_vzu02
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
    CALL q110_show() 
END FUNCTION    
 
FUNCTION btn_status()
   DEFINE l_msg    string
   DEFINE l_sql1   STRING  #FUN-B50050 add
   DEFINE l_sql2   STRING  #FUN-B50050 add
   
   IF cl_null(g_vzu01) OR cl_null(g_vzu02) THEN
      RETURN
   END IF
   

  #FUN-B50050---mod---str----
  #LET g_sql = " SELECT vzu03,vzu04,vzu05,vzu06,vzu07,vzu08 FROM vzu_file",               #TQC-950078 MARK
   LET l_sql1 = cl_tp_tochar('vzu05','yyyy/mm/dd HH24:MI:SS')
   LET l_sql2 = cl_tp_tochar('vzu06','yyyy/mm/dd HH24:MI:SS')
   LET g_sql = " SELECT vzu03,vzu04, ",l_sql1 CLIPPED," vzu05,",l_sql2 CLIPPED," vzu06,vzu07,vzu08 FROM vzu_file ",
  #LET g_sql = " SELECT vzu03,vzu04,TO_CHAR(vzu05,'yyyy/mm/dd HH24:MI:SS') vzu05, ",      #TQC-950078 ADD
  #            "        TO_CHAR(vzu06,'yyyy/mm/dd HH24:MI:SS') vzu06 , ",                 #TQC-950078 ADD
  #            "         vzu07,vzu08 FROM vzu_file", #TQC-950078 ADD
  #FUN-B50050---mod---end----
               "  WHERE vzu01='",g_vzu01 CLIPPED,"' ",
               "    AND vzu02='",g_vzu02 CLIPPED,"' ",
               "    AND vzu00 = '",g_plant,"'"
           
    PREPARE c110_prepare FROM g_sql
    DECLARE c110_cs CURSOR FOR c110_prepare          
    
    CALL g_vzu.clear()
    LET g_cnt = 1
    FOREACH c110_cs INTO g_vzu[g_cnt].*
       IF STATUS THEN 
    	     CALL cl_err('foreach:',STATUS,1)
    	     EXIT FOREACH
       END IF                
       
       CALL btn_change(g_vzu[g_cnt].vzu03,g_vzu[g_cnt].vzu04,g_vzu[g_cnt].vzu05,g_vzu[g_cnt].vzu06,g_vzu[g_cnt].vzu07)
        
       LET g_cnt=g_cnt+1
    END FOREACH
END FUNCTION
 
FUNCTION btn_change(p_vzu03,p_vzu04,p_vzu05,p_vzu06,p_vzu07)
  DEFINE   p_vzu03          LIKE vzu_file.vzu03
  DEFINE   p_vzu04          LIKE vzu_file.vzu04
 #DEFINE   p_vzu05          DATETIME YEAR TO SECOND  #TQC-950078 MARK
 #DEFINE   p_vzu06          DATETIME YEAR TO SECOND  #TQC-950078 MARK
  DEFINE   p_vzu05          LIKE type_file.chr20     #TQC-950078 MARK
  DEFINE   p_vzu06          LIKE type_file.chr20     #TQC-950078 MARK
  DEFINE   p_vzu07          LIKE vzu_file.vzu07  
  DEFINE   ls_imgstr        string  
  DEFINE   lwin_curr        ui.Window
  DEFINE   lfrm_curr        ui.Form
  DEFINE   lnode_item       om.DomNode
  DEFINE   lnode_value_list om.DomNode,
           lnode_value      om.DomNode,
           lst_value        om.NodeList,
           btn_name         string,
           btn_name1        string, 
           btn_name2        string 
            
            
            
   LET lwin_curr = ui.Window.getCurrent()
   LET lfrm_curr = lwin_curr.getForm()     
   
   LET btn_name = "bt", p_vzu03 USING "<<<<<<<<"
   
   LET lnode_item = lfrm_curr.findNode("Button",btn_name)      
   CALL lnode_item.setAttribute("text",p_vzu04)
   
   CASE p_vzu07
       WHEN 'Y' 
       	  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/greenLight.jpg"   	      
   	   WHEN 'N' 
   	   	  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/blueLight.jpg"          
       WHEN 'R'
       	  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/yellowLight.jpg"                 	  
       WHEN 'F'
       	  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/redLight.jpg"          
       WHEN 'C'
       	  LET ls_imgstr = ms_pic_url.trim() || "/tiptop/pic/redLight.jpg"       	  
   END CASE
   CALL lnode_item.setAttribute("image",ls_imgstr)
   LET btn_name = "formonly.text" , p_vzu03 USING "<<<<<<<<"   
   LET lnode_item = lfrm_curr.findNode("FormField",btn_name)      
   
   CASE p_vzu07
       WHEN 'Y'       	  
   	      CALL lnode_item.setAttribute("value",g_msg525)       
       WHEN 'N'
          CALL lnode_item.setAttribute("value",g_msg526)
       WHEN 'R'
       	  CALL lnode_item.setAttribute("value",g_msg527)
       WHEN 'F'
       	  CALL lnode_item.setAttribute("value",g_msg528)	  
       WHEN 'C'
       	  CALL lnode_item.setAttribute("value",g_msg529)	  	  
   END CASE 
   
   LET btn_name1 = btn_name.trim() || "_1"  
   LET lnode_item = lfrm_curr.findNode("FormField",btn_name1)      
   CALL lnode_item.setAttribute("value", g_msg530|| "\n" || p_vzu05)
   
   LET btn_name2 = btn_name.trim() || "_2" 
   LET lnode_item = lfrm_curr.findNode("FormField",btn_name2)      
   CALL lnode_item.setAttribute("value", g_msg531||  "\n" || p_vzu06)
   
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
 
      SELECT count(*) INTO l_cnt
        FROM vzu_file
       WHERE vzu00=g_plant
         AND vzu01=g_vzu01
         AND vzu02=g_vzu02
         AND vzu07="F"
         
      IF l_cnt <=0 THEN
          CALL cl_err('','aps-523',1)
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
 
FUNCTION checkdata(p_step)
DEFINE p_step      LIKE vzu_file.vzu03
DEFINE l_vzu03     LIKE vzu_file.vzu03
DEFINE l_ze03      LIKE  ze_file.ze03
DEFINE l_sql    STRING
 
   IF cl_null(g_vzu01) OR cl_null(g_vzu02) THEN
      RETURN FALSE
   END IF
   
   LET l_sql = "SELECT vzu03  FROM vzu_file WHERE vzu00='",g_plant,"' ",
                           " AND vzu01='",g_vzu01,"' ",
                           " AND vzu02='",g_vzu02,"' ",      
                           " AND vzu07 IN ('N','F','C') order by vzu03 "
      
   PREPARE aps_vzu FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','vzu_file','','',SQLCA.sqlcode,'','',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE vzu_cs CURSOR FOR aps_vzu
   	
   OPEN vzu_cs
   FETCH vzu_cs INTO l_vzu03  
   CLOSE vzu_cs
   
   IF p_step=l_vzu03 THEN 
      RETURN TRUE
   END IF 
   
   RETURN FALSE
   
END FUNCTION
 
FUNCTION aps_continue()
DEFINE i	 LIKE type_file.num5      
DEFINE l_proc    LIKE vzu_file.vzu03
    
    LET l_proc=""
    FOR i=1 TO g_cnt    	 
    	IF (g_vzu[i].vzu07="F" OR g_vzu[i].vzu07="C") THEN
    	   LET l_proc = g_vzu[i].vzu03		
    	   EXIT FOR    		 	
    	END IF
    END FOR    
    
    IF cl_null(l_proc) THEN #FUN-870061
    	 CALL cl_err('','aps-532',1)
    	 RETURN 
    END IF
    
    CASE l_proc
       WHEN "10"
    	    CALL cl_err('','aps-503',1) ##不可跑程序編號10
    	 	    
       WHEN "20"
       	     LET g_cmd = "apsp600 'erp_export' '",
       	    	                         g_plant CLIPPED,"' '",
       	    	                         g_vzu01 CLIPPED,"' '",                                                                      
                                       '0' CLIPPED,"' ",
                                       " '' '' '",
                                       g_vzu02 CLIPPED,"' ", ##第六參數                              
                                       " '' ",          #FUN-CC0150 add
                                       " '' ",          #FUN-CC0150 add
                                       "'",g_legal,"'"  #FUN-CC0150 add
             DISPLAY  g_cmd                              
             CALL cl_cmdrun_wait(g_cmd)        	    	 
       	    
       WHEN "30"
       	    LET g_cmd = "apsp600 'erp_export' '",
       	                           g_plant CLIPPED,"' '",
       	                            g_vzu01 CLIPPED,"' '",                                                                        
                                    '0' CLIPPED,"' ",
                                    " '' '' '",
                                   g_vzu02 CLIPPED,"' ", ##第六參數                              
                                    " '' ",          #FUN-CC0150 add
                                    " '' ",          #FUN-CC0150 add
                                    "'",g_legal,"'"  #FUN-CC0150 add
            DISPLAY  g_cmd                              
            CALL cl_cmdrun_wait(g_cmd)
       	    
       WHEN "40" #手調器
       	    LET g_cmd = "apst601 '",g_plant CLIPPED,"' '",
       	   	                     g_vzu01 CLIPPED,"' ",
       	    	                     " '0' " #儲存版本為'0'               
            DISPLAY  g_cmd                              
            CALL cl_cmdrun_wait(g_cmd)
    END CASE
END FUNCTION
#No.FUN-9C0072 精簡程式碼
