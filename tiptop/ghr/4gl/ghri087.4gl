# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri087.4gl
# Descriptions...: 
# Date & Author..: 06/28/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hrdt           DYNAMIC ARRAY OF RECORD    
        hrdt01       LIKE hrdt_file.hrdt01,     
        hrdt02       LIKE hrdt_file.hrdt02,   
        hrdt03       LIKE hrdt_file.hrdt03,
        hrdt04       LIKE hrdt_file.hrdt04 
                    END RECORD,
    g_hrdt_t         RECORD                 
        hrdt01       LIKE hrdt_file.hrdt01,     
        hrdt02       LIKE hrdt_file.hrdt02,   
        hrdt03       LIKE hrdt_file.hrdt03,
        hrdt04       LIKE hrdt_file.hrdt04 
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING

MAIN
    
    DEFINE p_row,p_col   LIKE type_file.num5    
    DEFINE l_name   STRING
    DEFINE l_items  STRING
    
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
    OPEN WINDOW i087_w AT p_row,p_col WITH FORM "ghr/42f/ghri087"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    CALL cl_set_combo_items("hrdt03",NULL,NULL)
    
    #统筹区域
    CALL i087_get_items('652') RETURNING l_name,l_items
    CALL cl_set_combo_items("hrdt03",l_name,l_items)

    LET g_wc2 = '1=1'
    CALL i087_b_fill(g_wc2)
    CALL i087_menu()
    CLOSE WINDOW i087_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i087_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i087_get_items_pre FROM l_sql
       DECLARE i087_get_items CURSOR FOR i087_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH i087_get_items INTO l_hrag06,l_hrag07
             		       		 
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items

END FUNCTION

FUNCTION i087_menu()
 
   WHILE TRUE
      CALL i087_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i087_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i087_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         #add by zhuzw 20140919 start   
         WHEN "gx"
            CALL i087_gx_hrdta(g_hrdt[l_ac].hrdt01)
         #add by zhuzw 20140919 end    
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrdt[l_ac].hrdt01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrdt01"
                  LET g_doc.value1 = g_hrdt[l_ac].hrdt01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdt),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i087_q()
   CALL i087_b_askkey()
END FUNCTION
	
FUNCTION i087_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1  
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrdt01,hrdt02,hrdt03,hrdt04",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hrdt_file WHERE hrdt01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i087_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrdt WITHOUT DEFAULTS FROM s_hrdt.*
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
           LET g_hrdt_t.* = g_hrdt[l_ac].*  #BACKUP
           OPEN i087_bcl USING g_hrdt_t.hrdt01
           IF STATUS THEN
              CALL cl_err("OPEN i087_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i087_bcl INTO g_hrdt[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrdt_t.hrdt01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL cl_set_comp_entry("hrdt01",FALSE)
        ELSE
        	 CALL cl_set_comp_entry("hrdt01",TRUE)  
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hrdt[l_ac].* TO NULL      #900423  
         LET g_hrdt_t.* = g_hrdt[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrdt01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i087_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hrdt_file(hrdt01,hrdt02,hrdt03,hrdt04,                          #FUN-A30097
                              hrdtacti,hrdtuser,hrdtdate,hrdtgrup,hrdtoriu,hrdtorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrdt[l_ac].hrdt01,g_hrdt[l_ac].hrdt02,
                      g_hrdt[l_ac].hrdt03,g_hrdt[l_ac].hrdt04,
                      'Y',g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrdt_file",g_hrdt[l_ac].hrdt01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK 
           CALL i087_g_hrdta() 
        END IF   
        	
             	  	
        	
    AFTER FIELD hrdt01                        
       IF NOT cl_null(g_hrdt[l_ac].hrdt01) THEN       	 	  	                                            
          IF g_hrdt[l_ac].hrdt01 != g_hrdt_t.hrdt01 OR
             g_hrdt_t.hrdt01 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrdt_file
              WHERE hrdt01 = g_hrdt[l_ac].hrdt01
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hrdt[l_ac].hrdt01 = g_hrdt_t.hrdt01
                NEXT FIELD hrdt01
             END IF
          END IF                                             	
       END IF
       	
    AFTER FIELD hrdt02
       IF NOT cl_null(g_hrdt[l_ac].hrdt02) THEN
          IF g_hrdt[l_ac].hrdt02 != g_hrdt_t.hrdt02 OR
             g_hrdt_t.hrdt02 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrdt_file
              WHERE hrdt02 = g_hrdt[l_ac].hrdt02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hrdt[l_ac].hrdt02 = g_hrdt_t.hrdt02
                NEXT FIELD hrdt02
             END IF
          END IF     
       END IF
       	
       	
    BEFORE DELETE                           
       IF g_hrdt_t.hrdt01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrdt01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrdt[l_ac].hrdt01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
          
          DELETE FROM hrdta_file WHERE hrdta01 = g_hrdt_t.hrdt01
          DELETE FROM hrdt_file WHERE hrdt01 = g_hrdt_t.hrdt01
                    
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdt_file",g_hrdt_t.hrdt01,g_hrdt_t.hrdt02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
          	 LET g_rec_b=g_rec_b-1
          	 DISPLAY g_rec_b TO cn2    
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrdt[l_ac].* = g_hrdt_t.*
         CLOSE i087_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrdt[l_ac].hrdt01,-263,0)
          LET g_hrdt[l_ac].* = g_hrdt_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hrdt_file SET hrdt01=g_hrdt[l_ac].hrdt01,
                               hrdt02=g_hrdt[l_ac].hrdt02,
                               hrdt03=g_hrdt[l_ac].hrdt03,
                               hrdt04=g_hrdt[l_ac].hrdt04, 
                               hrdtmodu=g_user,
                               hrdtdate=g_today
          WHERE hrdt01 = g_hrdt_t.hrdt01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrdt_file",g_hrdt_t.hrdt01,g_hrdt_t.hrdt02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrdt[l_ac].* = g_hrdt_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdt[l_ac].* = g_hrdt_t.*
          END IF
          CLOSE i087_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i087_bcl                
        COMMIT WORK  
 
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
        
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         CALL cl_err("暂不支持复制",'!',1)
         
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
 
    CLOSE i087_bcl
    COMMIT WORK
END FUNCTION   
	
FUNCTION i087_b_askkey()
    CLEAR FORM
    CALL g_hrdt.clear()
 
    CONSTRUCT g_wc2 ON hrdt01,hrdt02,hrdt03,hrdt04                      
         FROM s_hrdt[1].hrdt01,s_hrdt[1].hrdt02,
              s_hrdt[1].hrdt03,s_hrdt[1].hrdt04
                                                 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrdtuser', 'hrdtgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i087_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i087_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrdt01,hrdt02,hrdt03,hrdt04",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hrdt_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE i087_pb FROM g_sql
    DECLARE hrdt_curs CURSOR FOR i087_pb
 
    CALL g_hrdt.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdt_curs INTO g_hrdt[g_cnt].*  
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
    CALL g_hrdt.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i087_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdt TO s_hrdt.* ATTRIBUTE(COUNT=g_rec_b)
 
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
#add by  zhuzw 20140919 start        
      ON ACTION gx
         LET g_action_choice="gx"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
#add by  zhuzw 20140919 end  
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
	
FUNCTION i087_g_hrdta()
DEFINE l_sql     STRING	
DEFINE l_hrdta   RECORD LIKE hrdta_file.*

       IF cl_null(g_hrdt[l_ac].hrdt01) THEN
       	  RETURN
       END IF	  		   	     		
       
       INITIALIZE l_hrdta.* TO NULL
       
       LET l_sql=" SELECT hrds01 FROM hrds_file ORDER BY hrds01"
       
       PREPARE i087_g_pre FROM l_sql
       DECLARE i087_g_cs CURSOR FOR i087_g_pre
       
       FOREACH i087_g_cs INTO l_hrdta.hrdta02
          
          LET l_hrdta.hrdta01=g_hrdt[l_ac].hrdt01
          LET l_hrdta.hrdta03='001'
          LET l_hrdta.hrdta04=0
          LET l_hrdta.hrdta06='001'
          LET l_hrdta.hrdta07=0
          LET l_hrdta.hrdta08=0
          LET l_hrdta.hrdta09=0
          LET l_hrdta.hrdta10=0
          LET l_hrdta.hrdta11=0 
          LET l_hrdta.hrdta12=0
          LET l_hrdta.hrdta13=0
          #add by zhuzw 20140924 start
          LET l_hrdta.ta_hrdta01 = 'N'
          #add by zhuzw 20140924 end 
          LET l_hrdta.hrdtauser=g_user
          LET l_hrdta.hrdtagrup=g_grup
          LET l_hrdta.hrdtaoriu=g_user
          LET l_hrdta.hrdtaorig=g_grup
          LET l_hrdta.hrdtadate=g_today
          LET l_hrdta.hrdtaacti='Y'
          
          INSERT INTO hrdta_file VALUES (l_hrdta.*)
          
       END FOREACH
      
END FUNCTION
#add by zhuzw 20140919 start
FUNCTION i087_gx_hrdta(p_hrdt01)
DEFINE p_hrdt01,l_hrdt01 LIKE hrdt_file.hrdt01
DEFINE l_sql STRING
DEFINE l_n LIKE type_file.num5
DEFINE l_hrdta RECORD LIKE hrdta_file.*

 OPEN WINDOW i087_w1  WITH FORM "ghr/42f/ghri087_1"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 INPUT l_hrdt01  WITHOUT DEFAULTS FROM hrdt01
        AFTER FIELD hrdt01
        IF NOT cl_null(l_hrdt01) THEN 
           SELECT COUNT(*) INTO l_n FROM hrdt_file
            WHERE hrdt01 = l_hrdt01
           IF l_n =0 THEN 
              CALL cl_err('统筹体系不存在请检查','！',0)
              NEXT FIELD hrdt01
           END IF  
        END IF 
       ON ACTION controlp
           CASE WHEN INFIELD(hrdt01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_hrdt01"
                     LET g_qryparam.default1 = l_hrdt01
                     LET g_qryparam.where = " hrdt01 != '",p_hrdt01,"' "
                     CALL cl_create_qry() RETURNING l_hrdt01
                     DISPLAY l_hrdt01 TO  hrdt01
                OTHERWISE
                     EXIT CASE
            END CASE                     
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
           
        ON ACTION CONTROLG
           CALL cl_cmdask()
            
        ON ACTION CONTROLF                        
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
           
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
           
        ON ACTION about
           CALL cl_about() 
              
        ON ACTION help
           CALL cl_show_help()
   END INPUT  
   IF INT_FLAG THEN                        
      LET INT_FLAG = 0 
      CALL cl_err('',9001,0)
      CLOSE WINDOW i087_w1
      RETURN 
   END IF
   DELETE FROM hrdta_file WHERE hrdta01 = p_hrdt01
   LET l_sql = "select * from hrdta_file where hrdta01 = '",l_hrdt01,"'"
   PREPARE i087_t1 FROM l_sql
   DECLARE i087_gx_s CURSOR FOR i087_t1
   FOREACH i087_gx_s INTO l_hrdta.*
      LET l_hrdta.hrdta01 = p_hrdt01
      LET l_hrdta.hrdtaacti = 'Y'
      INSERT INTO hrdta_file VALUES (l_hrdta.*) 
   END FOREACH  
   IF SQLCA.SQLCODE = 0 THEN        
      CALL cl_err('','ghr-033',1)
   END IF 	   
 CLOSE WINDOW i087_w1  
END FUNCTION       
    
#add by zhuzw 20140919 end  

      