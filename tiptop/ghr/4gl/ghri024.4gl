# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri024.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrbg             DYNAMIC ARRAY OF RECORD    
        hrbg01          LIKE hrbg_file.hrbg01,   
        hrbg02          LIKE hrbg_file.hrbg02,  
        hrat02          LIKE hrat_file.hrat02,   
        hrat04          LIKE hrat_file.hrat04,  
        hrat04_desc     LIKE hrao_file.hrao02, 
        hrat05          LIKE hrat_file.hrat05,  
        hrat05_desc     LIKE hrap_file.hrap06,
        hrbg03          LIKE hrbg_file.hrbg03,
        hrbg04          LIKE hrbg_file.hrbg04,
        hrbg05          LIKE hrbg_file.hrbg05,
        hrbg06          LIKE hrbg_file.hrbg06, 
        hrag07          LIKE hrag_file.hrag07,
        hrbg07          LIKE hrbg_file.hrbg07,
        hrbg08          LIKE hrbg_file.hrbg08,
        hrbg09          LIKE hrbg_file.hrbg09, 
        hrbg10          LIKE hrbg_file.hrbg10,
        hrbg11          LIKE hrbg_file.hrbg11,
        hrbg12          LIKE hrbg_file.hrbg12,
        hrbg13          LIKE hrbg_file.hrbg13,
        hrbg14          LIKE hrbg_file.hrbg14
                    END RECORD,
    g_hrbg_t         RECORD                 
        hrbg01          LIKE hrbg_file.hrbg01,   
        hrbg02          LIKE hrbg_file.hrbg02,  
        hrat02          LIKE hrat_file.hrat02,   
        hrat04          LIKE hrat_file.hrat04,  
        hrat04_desc     LIKE hrao_file.hrao02, 
        hrat05          LIKE hrat_file.hrat05,  
        hrat05_desc     LIKE hrap_file.hrap06,
        hrbg03          LIKE hrbg_file.hrbg03,
        hrbg04          LIKE hrbg_file.hrbg04,
        hrbg05          LIKE hrbg_file.hrbg05,
        hrbg06          LIKE hrbg_file.hrbg06, 
        hrag07          LIKE hrag_file.hrag07,
        hrbg07          LIKE hrbg_file.hrbg07,
        hrbg08          LIKE hrbg_file.hrbg08,
        hrbg09          LIKE hrbg_file.hrbg09, 
        hrbg10          LIKE hrbg_file.hrbg10,
        hrbg11          LIKE hrbg_file.hrbg11,
        hrbg12          LIKE hrbg_file.hrbg12,
        hrbg13          LIKE hrbg_file.hrbg13,
        hrbg14          LIKE hrbg_file.hrbg14 
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
    OPEN WINDOW i024_w AT p_row,p_col WITH FORM "ghr/42f/ghri024"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i024_b_fill(g_wc2)
    CALL i024_menu()
    CLOSE WINDOW i024_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i024_menu()
 
   WHILE TRUE
      CALL i024_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i024_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i024_b()
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
               IF g_hrbg[l_ac].hrbg01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrbg01"
                  LET g_doc.value1 = g_hrbg[l_ac].hrbg01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbg),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i024_q()
   CALL i024_b_askkey()
END FUNCTION	
	
FUNCTION i024_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hratid     LIKE hrat_file.hratid    
      
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbg01,hrbg02,'','','','','',hrbg03,hrbg04,hrbg05,hrbg06,'',",
                       "       hrbg07,hrbg08,hrbg09,hrbg10,hrbg11,hrbg12,hrbg13,hrbg14",
                       "  FROM hrbg_file WHERE hrbg01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i024_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrbg WITHOUT DEFAULTS FROM s_hrbg.*
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
           LET g_hrbg_t.* = g_hrbg[l_ac].*  #BACKUP
           OPEN i024_bcl USING g_hrbg_t.hrbg01
           IF STATUS THEN
              CALL cl_err("OPEN i024_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i024_bcl INTO g_hrbg[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrbg_t.hrbg01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           #hrag02存的是hratid,需要将其显示为hrat01	
           SELECT hrat01 INTO g_hrbg[l_ac].hrbg02 FROM hrat_file
            WHERE hratid = g_hrbg[l_ac].hrbg02
              AND hratacti='Y'
              AND hratconf='Y'
           #姓名,部门,职位   
           SELECT hrat02,hrat04,hrat05 
             INTO g_hrbg[l_ac].hrat02,g_hrbg[l_ac].hrat04,g_hrbg[l_ac].hrat05 
             FROM hrat_file
            WHERE hrat01 = g_hrbg[l_ac].hrbg02  
              AND hratacti = 'Y'
              AND hratconf='Y'
           #部门名称   
           SELECT hrao02 INTO g_hrbg[l_ac].hrat04_desc 
             FROM hrao_file  
            WHERE hrao01=g_hrbg[l_ac].hrat04
              AND hraoacti='Y'
           #职位名称
           SELECT hrap06 INTO g_hrbg[l_ac].hrat05_desc
             FROM hrap_file 
            WHERE hrap01=g_hrbg[l_ac].hrat04        #部门编号
              AND hrap05=g_hrbg[l_ac].hrat05        #职位编号
              AND hrapacti='Y'
           #等级名称---代码组
           SELECT hrag07 INTO g_hrbg[l_ac].hrag07
             FROM hrag_file 
            WHERE hrag01='330'                      #工伤等级代码组编号为330
              AND hrag06=g_hrbg[l_ac].hrbg06
                  
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL cl_set_comp_entry("hrbg02",FALSE)
        ELSE
           CALL cl_set_comp_entry("hrbg02",TRUE)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end  
         INITIALIZE g_hrbg[l_ac].* TO NULL      #900423
         
         LET g_hrbg[l_ac].hrbg04=g_today
         LET g_hrbg[l_ac].hrbg05=g_today
         SELECT MAX(hrbg01)+1 INTO g_hrbg[l_ac].hrbg01 FROM hrbg_file
         IF cl_null(g_hrbg[l_ac].hrbg01) THEN 
         	  LET g_hrbg[l_ac].hrbg01=1
         END IF
                         
         LET g_hrbg_t.* = g_hrbg[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrbg02 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i024_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        #hrbg02存hratid
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbg[l_ac].hrbg02
        
        INSERT INTO hrbg_file(hrbg01,hrbg02,hrbg03,hrbg04,hrbg05,                          #FUN-A30097
                    hrbg06,hrbg07,hrbg08,hrbg09,hrbg10,hrbg11,hrbg12,
                    hrbg13,hrbg14,
                    hrbguser,hrbgdate,hrbggrup,hrbgoriu,hrbgorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrbg[l_ac].hrbg01,l_hratid,
                      g_hrbg[l_ac].hrbg03,g_hrbg[l_ac].hrbg04,                                                              #FUN-A80148--mark--
                      g_hrbg[l_ac].hrbg05,g_hrbg[l_ac].hrbg06,
                      g_hrbg[l_ac].hrbg07,g_hrbg[l_ac].hrbg08,
                      g_hrbg[l_ac].hrbg09,g_hrbg[l_ac].hrbg10,
                      g_hrbg[l_ac].hrbg11,g_hrbg[l_ac].hrbg12,
                      g_hrbg[l_ac].hrbg13,g_hrbg[l_ac].hrbg14,
                      g_user,g_today,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrbg_file",g_hrbg[l_ac].hrbg01,g_hrbg[l_ac].hrbg02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF
 
       	
    AFTER FIELD hrbg02
       IF NOT cl_null(g_hrbg[l_ac].hrbg02) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrbg[l_ac].hrbg02
       	                                            AND hratacti='Y'
                                                    AND hratconf='Y'
       	  IF l_n=0 THEN
       	  	  CALL cl_err('无此员工编号','!',0)
       	  	  NEXT FIELD hrbg02
       	  END IF
       	  	
       	  SELECT hrat02,hrat04,hrat05
       	    INTO g_hrbg[l_ac].hrat02,g_hrbg[l_ac].hrat04,g_hrbg[l_ac].hrat05 
            FROM hrat_file
           WHERE hrat01 = g_hrbg[l_ac].hrbg02  
             AND hratacti = 'Y' 
             AND hratconf = 'Y'
         
          SELECT hrao02 INTO g_hrbg[l_ac].hrat04_desc FROM hrao_file
           WHERE hrao01=g_hrbg[l_ac].hrat04
             AND hraoacti='Y'
            
          SELECT hrap06 INTO g_hrbg[l_ac].hrat05_desc FROM hrap_file
           WHERE hrap01=g_hrbg[l_ac].hrat04
             AND hrap05=g_hrbg[l_ac].hrat05
             AND hrapacti='Y'                     	
       	  
       	 DISPLAY BY NAME g_hrbg[l_ac].hrat02,g_hrbg[l_ac].hrat04,g_hrbg[l_ac].hrat05,
       	                 g_hrbg[l_ac].hrat04_desc,g_hrbg[l_ac].hrat05_desc  	  	                                                                                        	
       END IF 
       	   	           	
    AFTER FIELD hrbg03                        
       IF NOT cl_null(g_hrbg[l_ac].hrbg03) THEN
        	IF g_hrbg[l_ac].hrbg03<1000 OR g_hrbg[l_ac].hrbg03>9999 THEN
        		 CALL cl_err('年度必须是4位数字','!',0)
        		 NEXT FIELD hrbg03
        	END IF	         	 	  	                                                                                         	
       END IF
       	
    
    AFTER FIELD hrbg05
       IF NOT cl_null(g_hrbg[l_ac].hrbg05) THEN
       	  IF cl_null(g_hrbg[l_ac].hrbg04) THEN
       	  	 CALL cl_err('请先录入受伤日期','!',0)
       	  	 LET g_hrbg[l_ac].hrbg05=''
       	  	 NEXT FIELD hrbg04
       	  ELSE
       	  	 IF g_hrbg[l_ac].hrbg05<g_hrbg[l_ac].hrbg04 THEN
       	  	    CALL cl_err('医疗结转日期不可小于受伤日期','!',0)
       	  	    NEXT FIELD hrbg05
       	  	 END IF
       	  END IF
       END IF	  	 	 		  	   	
   
    AFTER FIELD hrbg06
       IF NOT cl_null(g_hrbg[l_ac].hrbg06) THEN
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hrag_file 
           WHERE hrag01='330'
             AND hrag06=g_hrbg[l_ac].hrbg06
             AND hragacti='Y'
          IF l_n=0 THEN
          	 CALL cl_err('工伤等级编号不存在或者无效','!',0)
          	 NEXT FIELD hrbg06
          END IF
          
          SELECT hrag07 INTO g_hrbg[l_ac].hrag07 FROM hrag_file
           WHERE hrag01='330'
             AND hrag06=g_hrbg[l_ac].hrbg06
             AND hragacti='Y'
          DISPLAY BY NAME g_hrbg[l_ac].hrag07	               	
       END IF
       	       	
    BEFORE DELETE                            
       IF g_hrbg_t.hrbg01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrbg01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrbg[l_ac].hrbg01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrbg_file WHERE hrbg01 = g_hrbg_t.hrbg01
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrbg_file",g_hrbg_t.hrbg01,g_hrbg_t.hrbg02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrbg[l_ac].* = g_hrbg_t.*
         CLOSE i024_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrbg[l_ac].hrbg01,-263,0)
          LET g_hrbg[l_ac].* = g_hrbg_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hrbg_file SET hrbg03=g_hrbg[l_ac].hrbg03,
                               hrbg04=g_hrbg[l_ac].hrbg04,
                               hrbg05=g_hrbg[l_ac].hrbg05,
                               hrbg06=g_hrbg[l_ac].hrbg06,
                               hrbg07=g_hrbg[l_ac].hrbg07,
                               hrbg08=g_hrbg[l_ac].hrbg08,
                               hrbg09=g_hrbg[l_ac].hrbg09,
                               hrbg10=g_hrbg[l_ac].hrbg10,
                               hrbg11=g_hrbg[l_ac].hrbg11,
                               hrbg12=g_hrbg[l_ac].hrbg12,
                               hrbg13=g_hrbg[l_ac].hrbg13,
                               hrbg14=g_hrbg[l_ac].hrbg14,    
                               hrbgmodu=g_user,
                               hrbgdate=g_today
                WHERE hrbg01 = g_hrbg_t.hrbg01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrbg_file",g_hrbg_t.hrbg01,g_hrbg_t.hrbg02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrbg[l_ac].* = g_hrbg_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrbg[l_ac].* = g_hrbg_t.*
          END IF
          CLOSE i024_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i024_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hrbg02)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrat02"
             LET g_qryparam.default1 = g_hrbg[l_ac].hrbg02
             CALL cl_create_qry() RETURNING g_hrbg[l_ac].hrbg02
             DISPLAY BY NAME g_hrbg[l_ac].hrbg02
             NEXT FIELD hrbg02
             
           WHEN INFIELD(hrbg06)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrbg[l_ac].hrbg06
             LET g_qryparam.arg1='330'
             CALL cl_create_qry() RETURNING g_hrbg[l_ac].hrbg06
             DISPLAY BY NAME g_hrbg[l_ac].hrbg06
             NEXT FIELD hrbg06
             
         OTHERWISE
           EXIT CASE
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE i024_bcl
    COMMIT WORK
END FUNCTION      	     		
	
FUNCTION i024_b_askkey()
    CLEAR FORM
    CALL g_hrbg.clear()
 
    CONSTRUCT g_wc2 ON hrbg01,hrbg02,hrbg03,hrbg04,hrbg05,hrbg06,hrbg07,
                       hrbg08,hrbg09,hrbg10,hrbg11,hrbg12,hrbg13,hrbg14                       
         FROM s_hrbg[1].hrbg01,s_hrbg[1].hrbg02,s_hrbg[1].hrbg03,                                  
              s_hrbg[1].hrbg04,s_hrbg[1].hrbg05,s_hrbg[1].hrbg06,
              s_hrbg[1].hrbg07,s_hrbg[1].hrbg08,s_hrbg[1].hrbg09,
              s_hrbg[1].hrbg10,s_hrbg[1].hrbg11,s_hrbg[1].hrbg12,
              s_hrbg[1].hrbg13,s_hrbg[1].hrbg14
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrbg02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbg02
               NEXT FIELD hrbg02
               
            WHEN INFIELD(hrbg06)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06"
               LET g_qryparam.state = "c" 
               LET g_qryparam.arg1='330'  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbg06
               NEXT FIELD hrbg06
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbguser', 'hrbggrup') #FUN-980030
   CALL cl_replace_str(g_wc2,'hrbg02','hrat01') RETURNING g_wc2
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i024_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i024_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	
	
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrbg01,hrbg02,'','','','','',hrbg03,hrbg04,hrbg05,hrbg06,'',",
                   "       hrbg07,hrbg08,hrbg09,hrbg10,hrbg11,hrbg12,hrbg13,hrbg14 ",
                   " FROM hrbg_file,hrat_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   "   AND hratid=hrbg02 ",
                   " ORDER BY 1" 
 
    PREPARE i024_pb FROM g_sql
    DECLARE hrbg_curs CURSOR FOR i024_pb
 
    CALL g_hrbg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbg_curs INTO g_hrbg[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        #显示工号
        SELECT hrat01 INTO g_hrbg[g_cnt].hrbg02 FROM hrat_file 
         WHERE hratid=g_hrbg[g_cnt].hrbg02
           AND hratacti='Y'
           AND hratconf='Y'
        #姓名,部门编号,职位编号   
        SELECT hrat02,hrat04,hrat05 
          INTO g_hrbg[g_cnt].hrat02,g_hrbg[g_cnt].hrat04,g_hrbg[g_cnt].hrat05 
          FROM hrat_file
         WHERE hrat01=g_hrbg[g_cnt].hrbg02
           AND hratacti='Y'
           AND hratconf='Y'
        #部门名称
        SELECT hrao02 INTO g_hrbg[g_cnt].hrat04_desc FROM hrao_file
         WHERE hrao01=g_hrbg[g_cnt].hrat04
           AND hraoacti='Y'
        #职位名称
        SELECT hrap06 INTO g_hrbg[g_cnt].hrat05_desc FROM hrap_file
         WHERE hrap01=g_hrbg[g_cnt].hrat04
           AND hrap05=g_hrbg[g_cnt].hrat05
           AND hrapacti='Y'
        #等级名称
        SELECT hrag07 INTO g_hrbg[g_cnt].hrag07 FROM hrag_file
         WHERE hrag01='330'
           AND hrag06=g_hrbg[g_cnt].hrbg06
           AND hragacti='Y'      
                       
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i024_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbg TO s_hrbg.* ATTRIBUTE(COUNT=g_rec_b)
 
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
	
	     	
	     		  	
	     	   
