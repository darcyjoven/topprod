# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri104.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrag           DYNAMIC ARRAY OF RECORD    
        hrag05       LIKE hrag_file.hrag05,
        hrag06       LIKE hrag_file.hrag06,
        hrag07       LIKE hrag_file.hrag07,
        hrag08       LIKE hrag_file.hrag08, 
        hrag09       LIKE hrag_file.hrag09,
        hragacti     LIKE hrag_file.hragacti  
                    END RECORD,
    g_hrag_t         RECORD                 
        hrag05       LIKE hrag_file.hrag05,
        hrag06       LIKE hrag_file.hrag06,
        hrag07       LIKE hrag_file.hrag07,
        hrag08       LIKE hrag_file.hrag08, 
        hrag09       LIKE hrag_file.hrag09,
        hragacti     LIKE hrag_file.hragacti
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 

DEFINE g_hrag01     LIKE hrag_file.hrag01
DEFINE g_hrag02     LIKE hrag_file.hrag02
DEFINE g_hrag03     LIKE hrag_file.hrag03
DEFINE g_hrag04     LIKE hrag_file.hrag04
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5
DEFINE g_jump       LIKE type_file.num10
DEFINE g_no_ask     LIKE type_file.num5      
DEFINE g_str        STRING 
DEFINE g_msg        LIKE type_file.chr1000

MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i104_w AT p_row,p_col WITH FORM "ghr/42f/ghri104"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()


    CALL i104_menu()

    CLOSE WINDOW i104_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i104_menu()
 
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i104_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrag01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrag01"
                  LET g_doc.value1 = g_hrag01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrag),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i104_q()
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM  #NO.TQC-740075
   CALL g_hrag.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL i104_b_askkey()
   IF INT_FLAG THEN                            
      LET INT_FLAG = 0
      RETURN
   END IF

   LET g_sql=" SELECT DISTINCT hrag01,hrag02,hrag03,hrag04 FROM hrag_file ",
              "  WHERE ",g_wc2 CLIPPED,
              "  ORDER BY hrag01,hrag02,hrag03,hrag04"
    PREPARE i104_prepare FROM g_sql
    DECLARE i104_curs
      SCROLL CURSOR WITH HOLD FOR i104_prepare

    LET g_sql=" SELECT COUNT(DISTINCT hrag01) FROM hrag_file ",
              "  WHERE ",g_wc2 CLIPPED
    PREPARE i104_count_prepare FROM g_sql
    DECLARE i104_count CURSOR FOR i104_count_prepare

    OPEN i104_count
    FETCH i104_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt	
    OPEN i104_curs
    IF SQLCA.SQLCODE THEN                         
       CALL cl_err('',SQLCA.SQLCODE,0)
       INITIALIZE g_hrag01 TO NULL
       INITIALIZE g_hrag02 TO NULL
       INITIALIZE g_hrag03 TO NULL
       INITIALIZE g_hrag04 TO NULL                 
    ELSE
       CALL i104_fetch('F')                 
    END IF
   	
END FUNCTION
	
FUNCTION i104_fetch(p_flag)                  
DEFINE   p_flag   LIKE type_file.chr1,         
         l_abso   LIKE type_file.num10         

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i104_curs INTO g_hrag01,g_hrag02,g_hrag03,g_hrag04
      WHEN 'P' FETCH PREVIOUS i104_curs INTO g_hrag01,g_hrag02,g_hrag03,g_hrag04
      WHEN 'F' FETCH FIRST    i104_curs INTO g_hrag01,g_hrag02,g_hrag03,g_hrag04
      WHEN 'L' FETCH LAST     i104_curs INTO g_hrag01,g_hrag02,g_hrag03,g_hrag04
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
         FETCH ABSOLUTE g_jump i104_curs INTO g_hrag01,g_hrag02,g_hrag03,g_hrag04
         LET g_no_ask = FALSE    #No.FUN-6A0080
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrag01,SQLCA.sqlcode,0)
      INITIALIZE g_hrag01 TO NULL  #TQC-6B0i104
      INITIALIZE g_hrag02 TO NULL  #TQC-6B0i104
      INITIALIZE g_hrag03 TO NULL  #TQC-6B0i104
      INITIALIZE g_hrag04 TO NULL  #TQC-6B0i104
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          
      END CASE

      CALL cl_navigator_setting(g_curs_index, g_row_count)

      CALL i104_show()
   END IF
END FUNCTION	

FUNCTION i104_show()                         
   DISPLAY g_hrag01,g_hrag02,g_hrag03,g_hrag04 TO hrag01,hrag02,hrag03,hrag04  
   CALL i104_b_fill(g_wc2)                    
   CALL cl_show_fld_cont()                   
END FUNCTION		
	
FUNCTION i104_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
   
    LET g_action_choice=""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_hrag01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
    
    IF g_hrag04='N' THEN
       LET l_allow_insert = cl_detail_input_auth('insert')
    END IF   
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrag05,hrag06,hrag07,hrag08,hrag09,hragacti ",
                       "  FROM hrag_file WHERE hrag01=?  AND hrag06=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i104_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrag WITHOUT DEFAULTS FROM s_hrag.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_hrag_t.* = g_hrag[l_ac].*  #BACKUP
           OPEN i104_bcl USING g_hrag01,g_hrag_t.hrag06
           IF STATUS THEN
              CALL cl_err("OPEN i104_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i104_bcl INTO g_hrag[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrag_t.hrag06,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hrag[l_ac].* TO NULL      #900423  
         LET g_hrag[l_ac].hrag08 = 'N'
         LET g_hrag[l_ac].hragacti = 'Y'               
         LET g_hrag_t.* = g_hrag[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrag05 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i104_bcl
           CANCEL INSERT
        END IF
        
        INSERT INTO hrag_file(hrag01,hrag02,hrag03,hrag04,hrag05,                          #FUN-A30097
                    hrag06,hrag07,hrag08,hrag09,
                    hragacti,hraguser,hragdate,hraggrup,hragoriu,hragorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrag01,g_hrag02,
                      g_hrag03,g_hrag04,                                                              #FUN-A80148--mark--
                      g_hrag[l_ac].hrag05,g_hrag[l_ac].hrag06,
                      g_hrag[l_ac].hrag07,g_hrag[l_ac].hrag08,
                      g_hrag[l_ac].hrag09,g_hrag[l_ac].hragacti,
                      g_user,g_today,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrag_file",g_hrag01,g_hrag[l_ac].hrag06,SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cn2         
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hrag05                        
       IF NOT cl_null(g_hrag[l_ac].hrag05) THEN       	 	  	                                            
          IF g_hrag[l_ac].hrag05 != g_hrag_t.hrag05 OR
             g_hrag_t.hrag05 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrag_file
              WHERE hrag01 = g_hrag01
                AND hrag05 = g_hrag[l_ac].hrag05
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hrag[l_ac].hrag05 = g_hrag_t.hrag05
                NEXT FIELD hrag05
             END IF
          END IF                                            	
       END IF 
       	
    AFTER FIELD hrag06
       IF NOT cl_null(g_hrag[l_ac].hrag06) THEN       	 	  	                                            
          IF g_hrag[l_ac].hrag06 != g_hrag_t.hrag06 OR
             g_hrag_t.hrag06 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrag_file
              WHERE hrag01 = g_hrag01
                AND hrag06 = g_hrag[l_ac].hrag06
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hrag[l_ac].hrag06 = g_hrag_t.hrag06
                NEXT FIELD hrag06
             END IF
          END IF                                            	
       END IF 
       	
    AFTER FIELD hragacti
       IF NOT cl_null(g_hrag[l_ac].hragacti) THEN
          IF g_hrag[l_ac].hragacti NOT MATCHES '[YN]' THEN 
             LET g_hrag[l_ac].hragacti = g_hrag_t.hragacti
             NEXT FIELD hragacti
          END IF	  	
       END IF   	 	  	    	
       	
    BEFORE DELETE                            
       IF g_hrag01 IS NOT NULL AND g_hrag_t.hrag06 IS NOT NULL THEN
       	  IF g_hrag_t.hrag08='N' THEN
       	     LET l_n=0 
       	     SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01=g_hrag01
       	     IF l_n>1 THEN
                IF NOT cl_delete() THEN
                   ROLLBACK WORK      #FUN-680010
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "hrag01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_hrag01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   ROLLBACK WORK      #FUN-680010
                   CANCEL DELETE 
                END IF 
         
                DELETE FROM hrag_file WHERE hrag01 = g_hrag01
                                        AND hrag06 = g_hrag_t.hrag06
          
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","hrag_file",g_hrag01,g_hrag_t.hrag06,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                   ROLLBACK WORK      #FUN-680010
                   CANCEL DELETE
                   EXIT INPUT
                ELSE
                   LET g_rec_b = g_rec_b - 1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
             ELSE
             	  CALL cl_err('最后一笔数据不可删除','!',0)
             	  CANCEL DELETE
             END IF	     	
          ELSE
          	 CALL cl_err('系统数据不可删除','!',0)
          	 CANCEL DELETE
          END IF	    	
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrag[l_ac].* = g_hrag_t.*
         CLOSE i104_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrag01,-263,0)
          LET g_hrag[l_ac].* = g_hrag_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hrag_file SET hrag05=g_hrag[l_ac].hrag05,
                               hrag06=g_hrag[l_ac].hrag06,
                               hrag07=g_hrag[l_ac].hrag07,
                               hrag08=g_hrag[l_ac].hrag08,
                               hrag09=g_hrag[l_ac].hrag09,
                               hragacti=g_hrag[l_ac].hragacti,    
                               hragmodu=g_user,
                               hragdate=g_today
                WHERE hrag01 = g_hrag01
                  AND hrag06 = g_hrag_t.hrag06
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrag_file",g_hrag01,g_hrag_t.hrag06,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrag[l_ac].* = g_hrag_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrag[l_ac].* = g_hrag_t.*
          END IF
          CLOSE i104_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i104_bcl                
        COMMIT WORK  
 
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE i104_bcl
    COMMIT WORK
END FUNCTION  
	
FUNCTION i104_b_askkey()
    CLEAR FORM
    CALL g_hrag.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrag01,hrag02,hrag03,hrag04,hrag05,hrag06,hrag07,
                       hrag08,hrag09,hragacti                       
         FROM hrag01,hrag02,hrag03,hrag04,                                 
              s_hrag[1].hrag05,s_hrag[1].hrag06,
              s_hrag[1].hrag07,s_hrag[1].hrag08,s_hrag[1].hrag09,
              s_hrag[1].hragacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
               WHEN INFIELD(hrag01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrag01
               NEXT FIELD hrag01
               
            WHEN INFIELD(hrag06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06_1"
               LET g_qryparam.state = "c"   
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrag06
               NEXT FIELD hrag06
         OTHERWISE
              EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraguser', 'hraggrup') #FUN-980030
    IF INT_FLAG THEN RETURN END IF
{    	
    LET g_sql=" SELECT DISTINCT hrag01,hrag02,hrag03,hrag04 FROM hrag_file ",
              "  WHERE ",g_wc2 CLIPPED,
              "  ORDER BY hrag01,hrag02,hrag03,hrag04"
    PREPARE i104_prepare FROM g_sql          
    DECLARE i104_curs                    
      SCROLL CURSOR WITH HOLD FOR i104_prepare 
    
    LET g_sql=" SELECT COUNT(DISTINCT hrag01) FROM hrag_file ",
              "  WHERE ",g_wc2 CLIPPED
    PREPARE i104_count_prepare FROM g_sql          
    DECLARE i104_count CURSOR FOR i104_count_prepare         
}               	 
END FUNCTION
	
FUNCTION i104_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrag05,hrag06,hrag07,hrag08,hrag09,hragacti",
                   " FROM hrag_file",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hrag01='",g_hrag01,"'",
                   "   AND hrag02='",g_hrag02,"'",
                   "   AND hrag03='",g_hrag03,"'",
                   "   AND hrag04='",g_hrag04,"'", 
                   " ORDER BY hrag05,hrag06" 
 
    PREPARE ii104_pb FROM g_sql
    DECLARE hrag_curs CURSOR FOR ii104_pb
 
    CALL g_hrag.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrag_curs INTO g_hrag[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF   
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrag.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrag TO s_hrag.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION first                            
         CALL i104_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION previous                         
         CALL i104_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION jump                             
         CALL i104_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION next                             
         CALL i104_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST

      ON ACTION last                             
         CALL i104_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST   
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
   
      ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION					    	     			
