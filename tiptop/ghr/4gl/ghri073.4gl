# on..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri073.4gl
# Descriptions...: 待审核计件信息
# Date & Author..: 13/05/24 By lifang
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrdf    DYNAMIC ARRAY OF RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrdf01    LIKE hrdf_file.hrdf01,  
                  hrdf02    LIKE hrdf_file.hrdf02,  
                  hrat02    LIKE hrat_file.hrat02,  
                  hrat03    LIKE hrat_file.hrat03,
                  hraa02    LIKE hraa_file.hraa02,
                  hrat04    LIKE hrat_file.hrat04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrdf03    LIKE hrdf_file.hrdf03,
                  hrdf04    LIKE hrdf_file.hrdf04,
                  hrdf05    LIKE hrdf_file.hrdf05,
                  hrdf06    LIKE hrdf_file.hrdf06,
                  hrdf07    LIKE hrdf_file.hrdf07,
                  hrdfacti  LIKE hrdf_file.hrdfacti                   
               END RECORD,
 
       g_hrdf_t RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrdf01    LIKE hrdf_file.hrdf01, 
                  hrdf02    LIKE hrdf_file.hrdf02,   
                  hrat02    LIKE hrat_file.hrat02,  
                  hrat03    LIKE hrat_file.hrat03,
                  hraa02    LIKE hraa_file.hraa02,
                  hrat04    LIKE hrat_file.hrat04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrdf03    LIKE hrdf_file.hrdf03,
                  hrdf04    LIKE hrdf_file.hrdf04,
                  hrdf05    LIKE hrdf_file.hrdf05,
                  hrdf06    LIKE hrdf_file.hrdf06,
                  hrdf07    LIKE hrdf_file.hrdf07,
                  hrdfacti  LIKE hrdf_file.hrdfacti 
               END RECORD
DEFINE g_hrdfa    DYNAMIC ARRAY OF RECORD
                  surea      LIKE type_file.chr1,   #選擇
                  hrdf01a    LIKE hrdf_file.hrdf01,  
                  hrdf02a    LIKE hrdf_file.hrdf02,  
                  hrat02a    LIKE hrat_file.hrat02,  
                  hrat03a    LIKE hrat_file.hrat03,
                  hraa02a    LIKE hraa_file.hraa02,
                  hrat04a    LIKE hrat_file.hrat04,
                  hrao02a    LIKE hrao_file.hrao02,
                  hrdf03a    LIKE hrdf_file.hrdf03,
                  hrdf04a    LIKE hrdf_file.hrdf04,
                  hrdf05a    LIKE hrdf_file.hrdf05,
                  hrdf06a    LIKE hrdf_file.hrdf06,
                  hrdf07a    LIKE hrdf_file.hrdf07,
                  hrdfactia  LIKE hrdf_file.hrdfacti                   
               END RECORD,
 
       g_hrdfa_t RECORD
                  surea      LIKE type_file.chr1,   #選擇
                  hrdf01a    LIKE hrdf_file.hrdf01, 
                  hrdf02a    LIKE hrdf_file.hrdf02,   
                  hrat02a    LIKE hrat_file.hrat02,  
                  hrat03a    LIKE hrat_file.hrat03,
                  hraa02a    LIKE hraa_file.hraa02,
                  hrat04a    LIKE hrat_file.hrat04,
                  hrao02a    LIKE hrao_file.hrao02,
                  hrdf03a    LIKE hrdf_file.hrdf03,
                  hrdf04a    LIKE hrdf_file.hrdf04,
                  hrdf05a    LIKE hrdf_file.hrdf05,
                  hrdf06a    LIKE hrdf_file.hrdf06,
                  hrdf07a    LIKE hrdf_file.hrdf07,
                  hrdfactia  LIKE hrdf_file.hrdfacti 
               END RECORD               
DEFINE g_hrdfb    DYNAMIC ARRAY OF RECORD
                  hrdf01b    LIKE hrdf_file.hrdf01,  
                  hrdf02b    LIKE hrdf_file.hrdf02,  
                  hrat02b    LIKE hrat_file.hrat02,  
                  hrat03b    LIKE hrat_file.hrat03,
                  hraa02b    LIKE hraa_file.hraa02,
                  hrat04b    LIKE hrat_file.hrat04,
                  hrao02b    LIKE hrao_file.hrao02,
                  hrdf03b    LIKE hrdf_file.hrdf03,
                  hrdf04b    LIKE hrdf_file.hrdf04,
                  hrdf05b    LIKE hrdf_file.hrdf05,
                  hrdf06b    LIKE hrdf_file.hrdf06,
                  hrdf07b    LIKE hrdf_file.hrdf07,
                  hrdfactib  LIKE hrdf_file.hrdfacti                   
               END RECORD,               
    g_hrdf_ins     RECORD LIKE hrdf_file.*,
    g_success      LIKE type_file.chr1,
    g_wc2           STRING,
    g_wc2a          STRING,
    g_wc2b          STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5,
    g_rec_ba        LIKE type_file.num5,                
    l_aca           LIKE type_file.num5,
    g_rec_bb        LIKE type_file.num5,                
    l_acb           LIKE type_file.num5,    
    g_flag          LIKE type_file.chr10
 
DEFINE g_forupd_sql STRING   
DEFINE g_cnt        LIKE type_file.num10  
DEFINE g_cnta       LIKE type_file.num10 
DEFINE g_cntb       LIKE type_file.num10   
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING 
DEFINE p_row,p_col   LIKE type_file.num5  
DEFINE g_abc        LIKE type_file.chr1

MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW i073_w AT p_row,p_col WITH FORM "ghr/42f/ghri073"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    LET g_wc2 = " hrdf05 = '002' "
    LET g_wc2a = " hrdf05 = '003'" 
    LET g_wc2b = " hrdf05 = '004 "
    LET g_flag = 'dsh'
    CALL cl_set_comp_visible("hrdf01",FALSE)
    CALL cl_set_comp_visible("hrdf01a",FALSE)
    CALL cl_set_comp_visible("hrdf01b",FALSE)
    CALL i073_b_fill(g_wc2)
    CALL i074_b_fill(g_wc2a)
    CALL q074_b_fill(g_wc2b)
    LET g_abc = 'Y'
    CALL i073_menuall()
    CLOSE WINDOW i073_w 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN

FUNCTION i073_menuall()
   WHILE TRUE
      CASE g_flag 
         WHEN 'dsh'
            CALL i073_menu()
         WHEN 'ysh'
            CALL i074_menu()
         WHEN 'ygd'
            CALL q074_menu()
      END CASE
      IF g_abc = 'N' THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION i073_menu()
  
      CALL i073_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i073_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i073_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            LET g_abc = 'N'
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "confirm"
             IF cl_chk_act_auth() THEN
           	CALL i073_confirm()
             END IF
         
         WHEN "sel_all"
             IF cl_chk_act_auth() THEN
             	CALL i073_sel_all('Y')
             END IF
          
         WHEN "cancle_sel_all"
             IF cl_chk_act_auth() THEN
             	CALL i073_sel_all('N')
             END IF             
 
      END CASE
END FUNCTION 
	
FUNCTION i073_q()
   CALL i073_b_askkey()
END FUNCTION	
	
FUNCTION i073_b()
DEFINE l_hratid    LIKE hrat_file.hratid
DEFINE l_hrdf05    LIKE hrdf_file.hrdf05
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_c             LIKE type_file.num5,
    l_hrag07        LIKE hrag_file.hrag07
    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    
    CALL i073_set_no_entry(p_cmd) 
    CALL i073_set_required()	 
     
    LET g_sql="SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
               "hrdf05,hrdf06,hrdf07,hrdfacti",
               "  FROM hrdf_file,hrat_file WHERE hrdf01=? AND hrdf02 = hratid "
               
    LET g_sql= cl_forupd_sql(g_sql) 
    PREPARE g_forupd_sql FROM g_sql
    DECLARE i073_bcl CURSOR FOR g_forupd_sql      
    INPUT ARRAY g_hrdf WITHOUT DEFAULTS FROM s_hrdf.*
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
           LET g_before_input_done = FALSE                                                                         
           LET g_before_input_done = TRUE      
           LET g_hrdf_t.* = g_hrdf[l_ac].*  #BACKUP         
           OPEN i073_bcl USING g_hrdf_t.hrdf01          
           IF STATUS THEN
              CALL cl_err("OPEN i073_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i073_bcl INTO g_hrdf[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrdf_t.hrdf01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_hrdf[l_ac].sure = 'Y'
              DISPLAY g_hrdf[l_ac].sure TO sure 
              
              SELECT hraa02 INTO g_hrdf[l_ac].hraa02 FROM hraa_file
              WHERE hraa01 = g_hrdf[l_ac].hrat03
              DISPLAY BY NAME g_hrdf[l_ac].hraa02
              
              SELECT hrao02 INTO g_hrdf[l_ac].hrao02 FROM hrao_file
              WHERE hrao01 = g_hrdf[l_ac].hrat04 
              DISPLAY BY NAME g_hrdf[l_ac].hrao02
              
              SELECT hrag07 INTO g_hrdf[l_ac].hrdf05 FROM hrag_file 
               WHERE hrag01 = '103' AND hrag06 = g_hrdf[l_ac].hrdf05              
                            
              LET g_hrdf[l_ac].hrdfacti = 'Y'
              DISPLAY BY NAME g_hrdf[l_ac].hrdfacti 
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 

    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'                                                         
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE  
         CALL i073_set_no_entry(p_cmd) 
         CALL i073_set_required()	                                       
 
         INITIALIZE g_hrdf[l_ac].* TO NULL      #900423             
         LET g_hrdf_t.* = g_hrdf[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         LET g_hrdf[l_ac].sure = 'Y'
         DISPLAY g_hrdf[l_ac].sure TO sure
         
         SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag01='103' AND hrag06='002'
         LET g_hrdf[l_ac].hrdf05 = '002'       
         SELECT hrag07 INTO g_hrdf[l_ac].hrdf05 FROM hrag_file 
          WHERE hrag01 = '103' AND hrag06 = g_hrdf[l_ac].hrdf05
         DISPLAY BY NAME g_hrdf[l_ac].hrdf05
         
         LET g_hrdf[l_ac].hrdf06 = '0'
         DISPLAY BY NAME g_hrdf[l_ac].hrdf06
         
         LET g_hrdf[l_ac].hrdfacti = 'Y'
         DISPLAY BY NAME g_hrdf[l_ac].hrdfacti
            
      
    AFTER FIELD hrdf02 
        SELECT COUNT(*) INTO l_c 
          FROM hrat_file WHERE hrat01 = g_hrdf[l_ac].hrdf02
        IF l_c = 0 THEN 
        	 CALL cl_err ('此员工ID不存在','!',0)
        END IF 
        SELECT hrat02,hrat03,hrat04 
        INTO g_hrdf[l_ac].hrat02,g_hrdf[l_ac].hrat03,g_hrdf[l_ac].hrat04
        FROM hrat_file
        WHERE hrat01 = g_hrdf[l_ac].hrdf02
        DISPLAY BY NAME g_hrdf[l_ac].hrat02 
        DISPLAY BY NAME g_hrdf[l_ac].hrat03
        DISPLAY BY NAME g_hrdf[l_ac].hrat04 
        
        SELECT hraa02 INTO g_hrdf[l_ac].hraa02 FROM hraa_file
        WHERE hraa01 = g_hrdf[l_ac].hrat03
        DISPLAY BY NAME g_hrdf[l_ac].hraa02
        
        SELECT hrao02 INTO g_hrdf[l_ac].hrao02 FROM hrao_file
        WHERE hrao01 = g_hrdf[l_ac].hrat04 
        DISPLAY BY NAME g_hrdf[l_ac].hrao02
        CALL i073_hrdf01()
   
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i073_bcl
           CANCEL INSERT
        END IF
        
        CALL i073_insert()
        
        IF cl_null(g_hrdf_ins.hrdf01) OR cl_null(g_hrdf_ins.hrdf02) OR
        	 cl_null(g_hrdf_ins.hrdf03) OR cl_null(g_hrdf_ins.hrdf04) THEN
           CALL cl_err('必输栏位不可为空','!',0)
           NEXT FIELD hrdf02
        END IF
        BEGIN WORK                    #FUN-680010
        
        INSERT INTO hrdf_file VALUES (g_hrdf_ins.*)
        
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrdf_file",g_hrdf[l_ac].hrdf02,'1',SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cnt  
           COMMIT WORK  
        END IF        	  	        	       
       	
    BEFORE DELETE                            
       IF g_hrdf_t.hrdf01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF

          DELETE FROM hrdf_file WHERE hrdf01 = g_hrdf_t.hrdf01
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdf_file",g_hrdf_t.hrdf01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cnt
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrdf[l_ac].* = g_hrdf_t.*
         CLOSE i073_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrdf[l_ac].hrdf02,-163,0)
          LET g_hrdf[l_ac].* = g_hrdf_t.*
       ELSE
       IF cl_null(g_hrdf[l_ac].hrdf01) OR cl_null(g_hrdf[l_ac].hrdf02) OR
       	  cl_null(g_hrdf[l_ac].hrdf03) OR cl_null(g_hrdf[l_ac].hrdf04)THEN
       	  CALL cl_err('必输栏位不可为空','!',0)
           NEXT FIELD hrdf02
      END IF
          
         #FUN-A30030 END--------------------
          LET l_hratid = ''
          SELECT hratid INTO l_hratid FROM hrat_file
           WHERE hrat01 = g_hrdf[l_ac].hrdf02 
          LET l_hrdf05 = ''
          SELECT hrag06 INTO l_hrdf05 FROM hrag_file 
           WHERE hrag01 = '103' AND hrag07 = g_hrdf[l_ac].hrdf05
             AND rownum = 1           
          UPDATE hrdf_file SET hrdf01=g_hrdf[l_ac].hrdf01,
                               hrdf02=l_hratid,
                               hrdf03=g_hrdf[l_ac].hrdf03,
                               hrdf04=g_hrdf[l_ac].hrdf04,
                               hrdf05=l_hrdf05,
                               hrdf06=g_hrdf[l_ac].hrdf06,
                               hrdf07=g_hrdf[l_ac].hrdf07,
                               hrdfacti=g_hrdf[l_ac].hrdfacti,
                               hrdfuser=g_user,      
                               hrdfmodu=g_user,
                               hrdfdate=g_today,
                               hrdforiu=g_user,
                               hrdforig=g_grup
                WHERE hrdf01 = g_hrdf_t.hrdf01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrdf_file",g_hrdf_t.hrdf01,g_hrdf_t.hrdf02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrdf[l_ac].* = g_hrdf_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdf[l_ac].* = g_hrdf_t.*
          END IF
          CLOSE i073_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i073_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
        
           WHEN INFIELD(hrdf02)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrat01"
             LET g_qryparam.default1 = g_hrdf[l_ac].hrdf02 
             CALL cl_create_qry() RETURNING g_hrdf[l_ac].hrdf02
             DISPLAY BY NAME g_hrdf[l_ac].hrdf02
             NEXT FIELD hrdf02        
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
 
    CLOSE i073_bcl
    COMMIT WORK 
END FUNCTION      	     		
	
FUNCTION i073_b_askkey()
    CLEAR FORM
    CALL g_hrdf.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrdf01,hrdf02,hrat02,hrat03,hrat04,hrdf03,hrdf04,hrdf05,
                       hrdf06,hrdf07,hrdfacti                     
         FROM s_hrdf[1].hrdf01,s_hrdf[1].hrdf02,s_hrdf[1].hrat02,s_hrdf[1].hrat03,s_hrdf[1].hrat04,s_hrdf[1].hrdf03,s_hrdf[1].hrdf04,
              s_hrdf[1].hrdf05,s_hrdf[1].hrdf06,s_hrdf[1].hrdf07,s_hrdf[1].hrdfacti

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
              WHEN INFIELD(hrdf02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdf02
                 NEXT FIELD hrdf02
              WHEN INFIELD(hrat03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03
                 NEXT FIELD hrat03                 
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
         OTHERWISE
              EXIT CASE
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrdfuser', 'hrdfgrup') #FUN-980030
    LET g_wc2 = cl_replace_str(g_wc2,"hrdf02","hrat01")
    LET g_wc2 = g_wc2," AND hrdf05 = '002' "
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF 
 
    CALL i073_b_fill(g_wc2)
 
END FUNCTION 
	
FUNCTION i073_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
    IF cl_null(p_wc2) THEN
       LET p_wc2 = "1=1"
    END IF
       
       LET g_sql = "SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
                   "hrdf05,hrdf06,hrdf07,hrdfacti",
                   " FROM hrdf_file,hrat_file ",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid = hrdf02 ",
                   " ORDER BY hrdf01" 
 
    PREPARE i073_pb FROM g_sql
    DECLARE hrdf_curs CURSOR FOR i073_pb
 
    CALL g_hrdf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdf_curs INTO g_hrdf[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
         

      SELECT hraa02 INTO g_hrdf[g_cnt].hraa02 FROM hraa_file
      WHERE hraa01 = g_hrdf[g_cnt].hrat03

      SELECT hrao02 INTO g_hrdf[g_cnt].hrao02 FROM hrao_file
      WHERE hrao01 = g_hrdf[g_cnt].hrat04 

       SELECT hrag07 INTO g_hrdf[g_cnt].hrdf05 FROM hrag_file
        WHERE hrag01 = '103' AND hrag06 = g_hrdf[g_cnt].hrdf05
      
      LET g_hrdf[g_cnt].sure = 'Y'
     
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i073_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      DISPLAY ARRAY g_hrdf TO s_hrdf.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY 
            CALL cl_show_fld_cont() 
         
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()  
            LET g_flag='dsh'
                                            
         ON ACTION ysh
            LET g_flag = "ysh"
            EXIT DIALOG
            
         ON ACTION ygd
            LET g_flag = "ygd"
            EXIT DIALOG
                        
      END DISPLAY    
   {   DISPLAY ARRAY g_hrdfa TO s_hrdfa.* ATTRIBUTE(COUNT=g_rec_ba)

         BEFORE DISPLAY 
            CALL cl_show_fld_cont() 
         
         BEFORE ROW
            LET l_aca = ARR_CURR()
            CALL cl_show_fld_cont()  
            LET g_flag='ysh'
                                            
         ON ACTION dsh
            LET g_flag = "dsh"
            EXIT DIALOG

         ON ACTION ygd
            LET g_flag = "ygd"
            EXIT DIALOG
                        
      END DISPLAY               
      
      DISPLAY ARRAY g_hrdfb TO s_hrdfb.* ATTRIBUTE(COUNT=g_rec_bb)

         BEFORE DISPLAY 
            CALL cl_show_fld_cont() 
         
         BEFORE ROW
            LET l_acb = ARR_CURR()
            CALL cl_show_fld_cont()  
            LET g_flag='ygd'
                                            
         ON ACTION dsh
            LET g_flag = "dsh"
            EXIT DIALOG

         ON ACTION ysh
            LET g_flag = "ysh"
            EXIT DIALOG
                        
      END DISPLAY  
    }        
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
      
      ON ACTION sel_all
         LET g_action_choice="sel_all"
         EXIT DIALOG
      
     ON ACTION cancle_sel_all
         LET g_action_choice="cancle_sel_all"
         EXIT DIALOG    
         
      AFTER DIALOG
         CONTINUE DIALOG
      # No.FUN-530067 ---end---
 
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
FUNCTION i073_insert()
             	
	LET g_hrdf_ins.hrdf01 = g_hrdf[l_ac].hrdf01 
  SELECT hratid INTO g_hrdf_ins.hrdf02 FROM hrat_file
   WHERE hrat01 = g_hrdf[l_ac].hrdf02
	LET g_hrdf_ins.hrdf03 = g_hrdf[l_ac].hrdf03
	LET g_hrdf_ins.hrdf04 = g_hrdf[l_ac].hrdf04
	LET g_hrdf_ins.hrdf05 = g_hrdf[l_ac].hrdf05
	SELECT hrag06 INTO g_hrdf_ins.hrdf05 FROM hrag_file 
  WHERE hrag01 = '103' AND hrag07 = g_hrdf[l_ac].hrdf05
    AND rownum = 1  
	LET g_hrdf_ins.hrdf06 = g_hrdf[l_ac].hrdf06
	LET g_hrdf_ins.hrdf07 = g_hrdf[l_ac].hrdf07
	LET g_hrdf_ins.hrdfacti = g_hrdf[l_ac].hrdfacti
	LET g_hrdf_ins.hrdfuser = g_user
	LET g_hrdf_ins.hrdfgrup = g_grup
	LET g_hrdf_ins.hrdfmodu = g_user
	LET g_hrdf_ins.hrdfdate = g_today
	LET g_hrdf_ins.hrdforiu = g_user
	LET g_hrdf_ins.hrdforig = g_grup
	
END FUNCTION

	
FUNCTION i073_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i2      LIKE type_file.num5

  FOR l_i2 = 1 TO g_rec_b 
    LET g_hrdf[l_i2].sure = p_flag
    DISPLAY BY NAME g_hrdf[l_i2].sure
  END FOR
 
  CALL g_hrdf.deleteElement(l_i2)
  
  LET l_i2 = l_i2-1
  
  CALL ui.Interface.refresh()

END FUNCTION	
	
FUNCTION i073_set_required()
    CALL cl_set_comp_required("hrdf02,hrdf03,hrdf04",TRUE)
END FUNCTION

FUNCTION i073_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1 
 
     CALL cl_set_comp_entry("hrat02,hrat03,hraa02,hrat04,hrao02,hrdf05,hrdf06,hrdf07",FALSE)

END FUNCTION

FUNCTION i073_confirm() 
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_hrdf  RECORD  LIKE hrdf_file.*
  DEFINE l_count         LIKE type_file.num5 
  CALL s_showmsg_init()
  FOR l_i = 1 TO g_rec_b
    IF g_hrdf[l_i].sure = 'Y' THEN
       IF g_hrdf[l_i].hrdf05 = '003' OR g_hrdf[l_i].hrdf05 = '已审核' THEN 
          CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdf03,"已审核，不可再次审核","",1) 
          CONTINUE FOR
       END IF  
       IF g_hrdf[l_i].hrdfacti = 'N' THEN 
          CALL s_errmsg(g_hrdf[l_i].hrat02,g_hrdf[l_i].hrdfacti,"无效的资料不能审核","",1) 
          CONTINUE FOR
       END IF         
       UPDATE hrdf_file SET hrdf05 = '003' WHERE hrdf01 = g_hrdf[l_i].hrdf01
       IF SQLCA.SQLCODE THEN
          CALL s_errmsg('update hrdf_file','',SQLCA.SQLCODE,"",1) 
       END IF 
       SELECT hrag07 INTO g_hrdf[l_i].hrdf05 FROM hrag_file 
        WHERE hrag01 = '103' AND hrag06 = '003'
       DISPLAY BY NAME g_hrdf[l_i].hrdf05   
    END IF
  END FOR
  CALL s_showmsg() 
END FUNCTION

FUNCTION i073_hrdf01()
  DEFINE  l_max        LIKE type_file.num20
  DEFINE  l_count      LIKE type_file.num20
  DEFINE  l_chgday     STRING
  DEFINE  l_chghrdf01  LIKE hrdf_file.hrdf01

 
  SELECT COUNT(hrdf01) INTO l_count FROM hrdf_file 
#  WHERE hrdfdate = g_today
  WHERE substr(hrdf01,1,8) = to_char(to_date(sysdate),'yyyymmdd')
  IF l_count = 0 THEN 
  	 LET l_chgday = g_today USING 'yyyymmdd'
  	 LET  g_hrdf[l_ac].hrdf01 = l_chgday,'0001'
  ELSE 
     SELECT MAX(hrdf01) INTO l_max FROM hrdf_file
     LET g_hrdf[l_ac].hrdf01 = l_max + 1 USING '&&&&&&&&&&&&'
  END IF
END FUNCTION


FUNCTION i074_menu()
  
      CALL i074_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i074_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i074_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            LET g_abc = 'N'
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "unconfirm"
             IF cl_chk_act_auth() THEN
               CALL i074_unconfirm()
             END IF
 
         WHEN "closg"
             IF cl_chk_act_auth() THEN
               CALL i074_closg()
             END IF
             
         WHEN "guidang"
             IF cl_chk_act_auth() THEN
               CALL i074_guidang()
             END IF
                                    
         WHEN "sel_all"
             IF cl_chk_act_auth() THEN
              CALL i074_sel_all('Y')
             END IF
          
         WHEN "cancle_sel_all"
             IF cl_chk_act_auth() THEN
              CALL i074_sel_all('N')
             END IF             
 
      END CASE 
END FUNCTION 
 
FUNCTION i074_q()
   CALL i074_b_askkey()
END FUNCTION 
 
FUNCTION i074_b()
DEFINE l_hratid    LIKE hrat_file.hratid
DEFINE
    l_aca_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_c             LIKE type_file.num5,
    l_hrag07        LIKE hrag_file.hrag07
    
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
      
      
    LET g_sql="SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
               "hrdf05,hrdf06,hrdf07,hrdfacti",
               "  FROM hrdf_file,hrat_file WHERE hrdf01=? AND hrdf02 = hratid "
    LET g_sql= cl_forupd_sql(g_sql)
    PREPARE g_forupd_sqla FROM g_sql
    DECLARE i074_bcl CURSOR FOR g_forupd_sqla      
 
    INPUT ARRAY g_hrdfa WITHOUT DEFAULTS FROM s_hrdfa.*
          ATTRIBUTE (COUNT=g_rec_ba,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
    BEFORE INPUT
       IF g_rec_ba != 0 THEN
          CALL fgl_set_arr_curr(l_aca)
       END IF 
        
    BEFORE ROW
        LET p_cmd='' 
        LET l_aca = ARR_CURR()
        LET l_lock_sw = 'N'             
        LET l_n  = ARR_COUNT()
 
        IF g_rec_ba>=l_aca THEN
           BEGIN WORK
           LET p_cmd='u'                                        
           LET g_before_input_done = FALSE                                                                         
           LET g_before_input_done = TRUE          
           LET g_hrdfa_t.* = g_hrdfa[l_aca].*           
           OPEN i074_bcl USING g_hrdfa_t.hrdf01a          
           IF STATUS THEN
              CALL cl_err("OPEN i074_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i074_bcl INTO g_hrdfa[l_aca].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrdfa_t.hrdf01a,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              IF cl_null(g_hrdfa[l_aca].surea) THEN 
                 LET g_hrdfa[l_aca].surea = 'Y'
              END IF
              DISPLAY g_hrdfa[l_aca].surea TO surea 
              
              SELECT hraa02 INTO g_hrdfa[l_aca].hraa02a 
                FROM hraa_file
               WHERE hraa01 = g_hrdfa[l_aca].hrat03a
              DISPLAY BY NAME g_hrdfa[l_aca].hraa02a
              
              SELECT hrao02 INTO g_hrdfa[l_aca].hrao02a 
                FROM hrao_file
               WHERE hrao01 = g_hrdfa[l_aca].hrat04a
              DISPLAY BY NAME g_hrdfa[l_aca].hrao02a
                             
              
              SELECT hrag07 INTO g_hrdfa[l_aca].hrdf05a FROM hrag_file 
               WHERE hrag01 = '103' AND hrag06 = g_hrdfa[l_aca].hrdf05a
        
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 

    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrdfa[l_aca].* = g_hrdfa_t.*
         CLOSE i074_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
                   
    AFTER ROW
       LET l_aca = ARR_CURR()            
       LET l_aca_t = l_aca                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdfa[l_aca].* = g_hrdfa_t.*
          END IF
          CLOSE i074_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i074_bcl                
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
 
      ON ACTION about                     
         CALL cl_about()                  
                                          
      ON ACTION help                      
         CALL cl_show_help()              
 
    END INPUT
 
    CLOSE i074_bcl
    COMMIT WORK 
END FUNCTION              
 
FUNCTION i074_b_askkey()
    CLEAR FORM
    CALL g_hrdfa.clear()
    LET g_rec_ba=0
 
    CONSTRUCT g_wc2a ON hrdf01a,hrdf02a,hrat02a,hrat03a,hrat04a,hrdf03a,hrdf04a,hrdf05a,
                       hrdf06a,hrdf07a,hrdfactia                     
         FROM s_hrdfa[1].hrdf01a,s_hrdfa[1].hrdf02a,s_hrdfa[1].hrat02a,s_hrdfa[1].hrat03a,s_hrdfa[1].hrat04a,s_hrdfa[1].hrdf03a,s_hrdfa[1].hrdf04a,
              s_hrdfa[1].hrdf05a,s_hrdfa[1].hrdf06a,s_hrdfa[1].hrdf07a,s_hrdfa[1].hrdfactia

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
              WHEN INFIELD(hrdf02a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdf02a
                 NEXT FIELD hrdf02a
              WHEN INFIELD(hrat03a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03a
                 NEXT FIELD hrat03a                 
              WHEN INFIELD(hrat04a)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04a
                 NEXT FIELD hrat04a
         OTHERWISE
              EXIT CASE
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2a = NULL
       RETURN
    END IF 
    LET g_wc2a = g_wc2a CLIPPED,cl_get_extra_cond('hrdfuser', 'hrdfgrup') #FUN-980030
    LET g_wc2a = cl_replace_str(g_wc2a,"hrdf02a","hrat01")
    LET g_wc2a=cl_replace_str(g_wc2a,"hrdf01a","hrdf01")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrat02a","hrat02")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrat03a","hrat03")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hraa02a","hraa02")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrat04a","hrat04")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrao02a","hrao02")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrdf03a","hrdf03")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrdf04a","hrdf04")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrdf05a","hrdf05")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrdf06a","hrdf06")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrdf07a","hrdf07")    
    LET g_wc2a=cl_replace_str(g_wc2a,"hrdfactia","hrdfacti")
    LET g_wc2a = g_wc2a," AND hrdf05 = '003' "

 
    CALL i074_b_fill(g_wc2a)
 
END FUNCTION 
 
FUNCTION i074_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
    IF cl_null(p_wc2) THEN
       LET p_wc2 = "1=1"
    END IF
       
       LET g_sql = "SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
                   "hrdf05,hrdf06,hrdf07,hrdfacti",
                   " FROM hrdf_file,hrat_file ",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid = hrdf02 ",
                   " ORDER BY hrdf01" 
 
    PREPARE i074_pba FROM g_sql
    DECLARE hrdfa_curs CURSOR FOR i074_pba
 
    CALL g_hrdfa.clear()
    LET g_cnta = 1
    MESSAGE "Searching!" 
    FOREACH hrdfa_curs INTO g_hrdfa[g_cnta].*   
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF 

       SELECT hraa02 INTO g_hrdfa[g_cnta].hraa02a FROM hraa_file
       WHERE hraa01 = g_hrdfa[g_cnta].hrat03a
       
       SELECT hrao02 INTO g_hrdfa[g_cnta].hrao02a FROM hrao_file
       WHERE hrao01 = g_hrdfa[g_cnta].hrat04a 
       
       SELECT hrag07 INTO g_hrdfa[g_cnta].hrdf05a FROM hrag_file 
        WHERE hrag01 = '103' AND hrag06 = g_hrdfa[g_cnta].hrdf05a
        
       LET g_hrdfa[g_cnta].surea = 'Y'
     
       LET g_cnta = g_cnta + 1
       IF g_cnta > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_hrdfa.deleteElement(g_cnta)
    MESSAGE ""
    LET g_rec_ba = g_cnta-1
    DISPLAY g_rec_ba TO FORMONLY.cnta 
    LET g_cnta = 0
 
END FUNCTION 
 
FUNCTION i074_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " " 
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdfa TO s_hrdfa.* ATTRIBUTE(COUNT=g_rec_ba)
 
      BEFORE DISPLAY  
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

         ON ACTION dsh
            LET g_flag = "dsh"
            EXIT DISPLAY

         ON ACTION ygd
            LET g_flag = "ygd"
            EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_aca = 1
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
         LET l_aca = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION sel_all
         LET g_action_choice="sel_all"
         EXIT DISPLAY
      
     ON ACTION cancle_sel_all
         LET g_action_choice="cancle_sel_all"
         EXIT DISPLAY   
         
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY
      
      ON ACTION closg
         LET g_action_choice="closg"
         EXIT DISPLAY
      
      ON ACTION guidang
         LET g_action_choice="guidang"
         EXIT DISPLAY
              
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
   
 
FUNCTION i074_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i2      LIKE type_file.num5

  FOR l_i2 = 1 TO g_rec_ba
    LET g_hrdfa[l_i2].surea = p_flag
    DISPLAY BY NAME g_hrdfa[l_i2].surea
  END FOR
 
  CALL g_hrdfa.deleteElement(l_i2)
  
  LET l_i2 = l_i2-1
  
  CALL ui.Interface.refresh()

END FUNCTION 
  
 
 
FUNCTION i074_unconfirm() 
  DEFINE l_i,l_n         LIKE type_file.num5 
  DEFINE l_count         LIKE type_file.num5 
  CALL s_showmsg_init()
  FOR l_i = 1 TO g_rec_ba
    IF g_hrdfa[l_i].surea = 'Y' THEN
      IF g_hrdfa[l_i].hrdf05a = '002' OR g_hrdfa[l_i].hrdf05a= '待审核' THEN 
          CALL s_errmsg(g_hrdfa[l_i].hrat02a,g_hrdfa[l_i].hrdf03a,"未审核，不可取消审核","",1) 
          CONTINUE FOR
       END IF 
       IF g_hrdfa[l_i].hrdf06a = '1' THEN 
          CALL s_errmsg(g_hrdfa[l_i].hrat02a,g_hrdfa[l_i].hrdf03a,"已关账，不可取消审核","",1) 
          CONTINUE FOR
       END IF 
        
       UPDATE hrdf_file SET hrdf05 = '002' WHERE hrdf01 = g_hrdfa[l_i].hrdf01a
       IF SQLCA.SQLCODE THEN
          CALL s_errmsg('update hrdf_file','',SQLCA.SQLCODE,"",1) 
       END IF 
       SELECT hrag07 INTO g_hrdfa[l_i].hrdf05a FROM hrag_file 
        WHERE hrag01 = '103' AND hrag06 = '002'
       DISPLAY BY NAME g_hrdfa[l_i].hrdf05a   
    END IF
  END FOR
  CALL s_showmsg() 
END FUNCTION
 
FUNCTION i074_closg() 
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5 
  DEFINE l_hrct03        LIKE hrct_file.hrct03
  DEFINE l_hraa02        LIKE hraa_file.hraa02
  DEFINE l_hrct11        LIKE hrct_file.hrct11
  DEFINE l_hrct07        LIKE hrct_file.hrct07
  DEFINE l_hrct08        LIKE hrct_file.hrct08

  OPEN WINDOW i074_w1  WITH FORM "ghr/42f/ghri074_1"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  CALL cl_ui_locale("ghri074_1")
  CALL cl_set_label_justify("i074_w1","right")  
  LET l_hrct03 = g_hrdfa[1].hrat03a
  LET l_hraa02 = g_hrdfa[1].hraa02a
  DISPLAY l_hrct03 TO hrct03
  DISPLAY l_hraa02 TO hrct03_name
  INPUT l_hrct03,l_hrct11,l_hrct07,l_hrct08  WITHOUT DEFAULTS FROM hrct03,hrct11,hrct07,hrct08
        AFTER FIELD hrct03
            IF NOT cl_null(l_hrct03) THEN
               LET l_count = 0
               SELECT COUNT(*) INTO l_count FROM hrct_file
                WHERE hrct03 = l_hrct03
               IF l_count = 0 THEN
                  CALL cl_err('薪资周期维护资料中没有该公司资料','!',0)
                  NEXT FIELD hrct03
               END IF
               SELECT hraa02 INTO l_hraa02 FROM hraa_file WHERE hraa01 = l_hrct03
               DISPLAY l_hraa02 TO hraa02
            END IF  
        AFTER FIELD hrct11
            IF NOT cl_null(l_hrct11) THEN
               LET l_count = 0
               SELECT COUNT(*) INTO l_count FROM hr11_file
                WHERE hrct11 = l_hrct11
               IF l_count = 0 THEN
                  CALL cl_err('薪资周期维护资料中没有该周期月','!',0)
                  NEXT FIELD hrct11
               END IF
               SELECT hrct07,hrct08 INTO l_hrct07,l_hrct08 FROM hrct_file
                WHERE hrct11 = l_hrct11
                  AND rownum = 1
               DISPLAY l_hrct07 TO hrct07
               DISPLAY l_hrct08 TO hrct08
            END IF
        AFTER FIELD hrct07
            IF NOT cl_null(l_hrct07) AND NOT cl_null(l_hrct08) THEN
               IF l_hrct07 > l_hrct08 THEN
                  CALL cl_err(l_hrct07,'mfg9234',0)
                  NEXT FIELD hrct07
               END IF
            END IF
        AFTER FIELD hrct08
            IF NOT cl_null(l_hrct07) AND NOT cl_null(l_hrct08) THEN
               IF l_hrct07 > l_hrct08 THEN
                  CALL cl_err(l_hrct08,'axm1028',0)
                  NEXT FIELD hrct08
               END IF
            END IF
        
        ON ACTION controlp
            CASE 
               WHEN INFIELD(hrct03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_hraa01" 
                   LET g_qryparam.default1 = l_hrct03
                   CALL cl_create_qry() RETURNING l_hrct03
                   DISPLAY l_hrct03 TO hrct03
                   NEXT FIELD hrct03
               WHEN INFIELD(hrct11)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form  = "q_hrct11" 
                   LET g_qryparam.default1 = l_hrct11
                   CALL cl_create_qry() RETURNING l_hrct11
                   DISPLAY l_hrct11 TO hrct11
                   NEXT FIELD hrct11                   
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
      CLOSE WINDOW i074_w1
      RETURN 
   END IF           
   CLOSE WINDOW i074_w1
              
   CALL s_showmsg_init()

   FOR l_i = 1 TO g_rec_ba
      IF g_hrdfa[l_i].surea = 'Y' AND g_hrdfa[l_i].hrat03a = l_hrct03 AND g_hrdfa[l_i].hrdf03a >= l_hrct07 AND g_hrdfa[l_i].hrdf03a <= l_hrct08 THEN
         IF g_hrdfa[l_i].hrdf06a = '1' THEN 
            CALL s_errmsg(g_hrdfa[l_i].hrat02a,g_hrdfa[l_i].hrdf03a,"已关账，不可再次关账","",1)
            CONTINUE FOR 
         END IF 
         IF g_hrdfa[l_i].hrdf05a = '002' OR g_hrdfa[l_i].hrdf05a = '待审核' THEN 
            CALL s_errmsg(g_hrdfa[l_i].hrat02a,g_hrdfa[l_i].hrdf03a,"未审核，不可关账","",1) 
            CONTINUE FOR
         END IF 
           
         UPDATE hrdf_file SET hrdf06 = '1',hrdf07 = l_hrct11  WHERE hrdf01 = g_hrdfa[l_i].hrdf01a
         IF SQLCA.SQLCODE THEN
            CALL s_errmsg('update hrdf_file','hrdf06',"",SQLCA.SQLCODE,1) 
         END IF 
         LET g_hrdfa[l_i].hrdf06a = '1'
         LET g_hrdfa[l_i].hrdf07a = l_hrct11
         DISPLAY BY NAME g_hrdfa[l_i].hrdf06a,g_hrdfa[l_i].hrdf07a
      END IF
   END FOR
   CALL s_showmsg()  
END FUNCTION  
 
FUNCTION i074_guidang() 
  DEFINE l_i,l_n         LIKE type_file.num5
  DEFINE l_count         LIKE type_file.num5 

   CALL s_showmsg_init() 
   FOR l_i = 1 TO g_rec_ba
       IF g_hrdfa[l_i].surea = 'Y' THEN
          IF g_hrdfa[l_i].hrdf05a = '002' OR g_hrdfa[l_i].hrdf05a = '待审核' THEN 
             CALL s_errmsg(g_hrdfa[l_i].hrat02a,g_hrdfa[l_i].hrdf03a,"未审核，不可归档","",1) 
             CONTINUE FOR
          END IF 
          IF g_hrdfa[l_i].hrdf06a = '0' THEN 
             CALL s_errmsg(g_hrdfa[l_i].hrat02a,g_hrdfa[l_i].hrdf03a,"未关账，不可归档","",1) 
             CONTINUE FOR
          END IF 
        
          UPDATE hrdf_file SET hrdf05 = '004' WHERE hrdf01 = g_hrdfa[l_i].hrdf01a
          IF SQLCA.SQLCODE THEN
             CALL s_errmsg('update hrdf_file','',"",SQLCA.SQLCODE,1) 
          END IF 
          SELECT hrag07 INTO g_hrdfa[l_i].hrdf05a FROM hrag_file 
           WHERE hrag01 = '103' AND hrag06 = '004'
          DISPLAY BY NAME g_hrdfa[l_i].hrdf05a   
       END IF
   END FOR
   CALL s_showmsg() 
END FUNCTION 


FUNCTION q074_menu()
  
      CALL q074_bp("G")
      CASE g_action_choice

         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q074_q()
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            LET g_abc = 'N'
         WHEN "controlg"
            CALL cl_cmdask()
         
      END CASE 
END FUNCTION 
	
FUNCTION q074_q()
   CALL q074_b_askkey()
END FUNCTION	
	
FUNCTION q074_b_askkey()
    CLEAR FORM
    CALL g_hrdfb.clear()
    LET g_rec_bb=0
 
    CONSTRUCT g_wc2b ON hrdf01b,hrdf02b,hrat02b,hrat03b,hrat04b,hrdf03b,hrdf04b,hrdf05b,                                                      
                       hrdf06b,hrdf07b,hrdfactib                                                                                        
         FROM s_hrdfb[1].hrdf01b,s_hrdfb[1].hrdf02b,s_hrdfb[1].hrat02b,s_hrdfb[1].hrat03b,s_hrdfb[1].hrat04b,s_hrdfb[1].hrdf03b,s_hrdfb[1].hrdf04b,
              s_hrdfb[1].hrdf05b,s_hrdfb[1].hrdf06b,s_hrdfb[1].hrdf07b,s_hrdfb[1].hrdfactib                                                  

      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
              WHEN INFIELD(hrdf02b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrdf02b
                 NEXT FIELD hrdf02b
              WHEN INFIELD(hrat03b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hraa01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat03b
                 NEXT FIELD hrat03b                 
              WHEN INFIELD(hrat04b)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04b
                 NEXT FIELD hrat04b
         OTHERWISE
              EXIT CASE
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2b = NULL
       RETURN
    END IF 
    LET g_wc2b = g_wc2b CLIPPED,cl_get_extra_cond('hrdfuser', 'hrdfgrup') #FUN-980030
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdf02b","hrat01")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdf01b","hrdf01")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrat02b","hrat02")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrat03b","hrat03")
    LET g_wc2b = cl_replace_str(g_wc2b,"hraa02b","hraa02")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrat04b","hrat04")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrao02b","hrao02")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdf03b","hrdf03")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdf04b","hrdf04")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdf05b","hrdf05")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdf06b","hrdf06")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdf07b","hrdf07")
    LET g_wc2b = cl_replace_str(g_wc2b,"hrdfactib","hrdfacti")
    LET g_wc2b = g_wc2b," AND hrdf05 = '004' "
 
    CALL q074_b_fill(g_wc2b)
 
END FUNCTION	
	
FUNCTION q074_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
    IF cl_null(p_wc2) THEN
       LET p_wc2 = "1=1"
    END IF
       
       LET g_sql = "SELECT '',hrdf01,hrat01,hrat02,hrat03,'',hrat04,'',hrdf03,hrdf04,",
                   "hrdf05,hrdf06,hrdf07,hrdfacti",
                   " FROM hrdf_file,hrat_file ",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid = hrdf02 ",
                   " ORDER BY hrdf01,hrat01" 
 
    PREPARE q074_pb FROM g_sql
    DECLARE hrdfb_curs CURSOR FOR q074_pb
 
    CALL g_hrdfb.clear()
    LET g_cntb = 1
    MESSAGE "Searching!" 
    FOREACH hrdfb_curs INTO g_hrdfb[g_cntb].*   
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF 

       SELECT hraa02 INTO g_hrdfb[g_cntb].hraa02b FROM hraa_file
       WHERE hraa01 = g_hrdfb[g_cntb].hrat03b
       
       SELECT hrao02 INTO g_hrdfb[g_cntb].hrao02b FROM hrao_file
       WHERE hrao01 = g_hrdfb[g_cntb].hrat04b 
       
       SELECT hrag07 INTO g_hrdfb[g_cntb].hrdf05b FROM hrag_file 
        WHERE hrag01 = '103' AND hrag06 = g_hrdfb[g_cntb].hrdf05b
        
       LET g_cntb = g_cntb + 1
       IF g_cntb > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_hrdfb.deleteElement(g_cntb)
    MESSAGE ""
    LET g_rec_bb = g_cntb-1
    DISPLAY g_rec_bb TO FORMONLY.cntb 
 
END FUNCTION	
	
FUNCTION q074_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdfb TO s_hrdfb.* ATTRIBUTE(COUNT=g_rec_bb)
 
      BEFORE DISPLAY 
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

         ON ACTION ysh
            LET g_flag = "ysh"
            EXIT DISPLAY

         ON ACTION dsh 
            LET g_flag = "dsh"
            EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
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
         LET l_acb = ARR_CURR()
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
      
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
