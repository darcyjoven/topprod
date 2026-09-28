# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: apcq001.4gl
# Descriptions...: POS數據傳輸異常記錄查詢作業
# Date & Author..: No.TQC-B20181 11/03/03 By wangxin

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_plg                DYNAMIC ARRAY OF RECORD 
           ryl01             LIKE ryl_file.ryl01 ,
           ryl02             LIKE ryl_file.ryl02 ,
           ryl03             LIKE ryl_file.ryl03 ,
           ryl04             LIKE ryl_file.ryl04 ,
           ryl05             LIKE ryl_file.ryl05 ,
           ryl06             LIKE ryl_file.ryl06 ,
           ryl07             LIKE ryl_file.ryl07 ,
           ryl08             LIKE ryl_file.ryl08 ,
           ryl09             LIKE ryl_file.ryl09 ,
           ryl10             LIKE ryl_file.ryl10 ,
           ryl11             LIKE ryl_file.ryl11 ,
           ryl12             LIKE ryl_file.ryl12 ,
           ryl13             LIKE ryl_file.ryl13 ,
           ryl14             LIKE ryl_file.ryl14 ,
           ryl15             LIKE ryl_file.ryl15 ,
           ryl16             LIKE ryl_file.ryl16 
        END RECORD,
        g_plg_t              RECORD 
           ryl01             LIKE ryl_file.ryl01 ,
           ryl02             LIKE ryl_file.ryl02 ,
           ryl03             LIKE ryl_file.ryl03 ,
           ryl04             LIKE ryl_file.ryl04 ,
           ryl05             LIKE ryl_file.ryl05 ,
           ryl06             LIKE ryl_file.ryl06 ,
           ryl07             LIKE ryl_file.ryl07 ,
           ryl08             LIKE ryl_file.ryl08 ,
           ryl09             LIKE ryl_file.ryl09 ,
           ryl10             LIKE ryl_file.ryl10 ,
           ryl11             LIKE ryl_file.ryl11 ,
           ryl12             LIKE ryl_file.ryl12 ,
           ryl13             LIKE ryl_file.ryl13 ,
           ryl14             LIKE ryl_file.ryl14 ,
           ryl15             LIKE ryl_file.ryl15 ,
           ryl16             LIKE ryl_file.ryl16  
        END RECORD
DEFINE  g_sql                STRING,
        g_wc2                STRING,
        g_rec_b              LIKE type_file.num5,
        l_ac                 LIKE type_file.num5
DEFINE  p_row,p_col          LIKE type_file.num5
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_cnt                LIKE type_file.num10
 
MAIN
        OPTIONS                            
        INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1)      
        RETURNING g_time   
          
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW q001_w AT p_row,p_col WITH FORM "apc/42f/apcq001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL  cl_ui_init()
   LET   g_wc2 = "1=1"
   CALL  q001_b_fill(g_wc2)
   CALL  q001_menu()
   CLOSE WINDOW q001_w                   
   CALL  cl_used(g_prog,g_time,2)        
         RETURNING g_time    
END MAIN
 
FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_plg TO s_plg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE ROW
      LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
         
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      
      ON ACTION remove
         LET g_action_choice="remove"
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION controlg
        LET g_action_choice="controlg"
        EXIT DISPLAY
      
      ON ACTION accept
        LET g_action_choice="detail"
        LET l_ac = ARR_CURR()
        EXIT DISPLAY
      
      ON ACTION cancel
        LET INT_FLAG=FALSE 		
        LET g_action_choice="exit"
        EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         
         CALL cl_about()      
            
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
      END DISPLAY
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q001_menu()
 
   WHILE TRUE
      CALL q001_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL q001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q001_out()
            END IF
         WHEN "remove"
            IF cl_chk_act_auth() THEN
               CALL q001_remove()
            END IF   
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_plg),'','')
             END IF        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q001_q()
 
   CALL q001_b_askkey()
   
END FUNCTION
 
FUNCTION q001_b_askkey()
 
    CLEAR FORM
  
    CONSTRUCT g_wc2 ON ryl01,ryl02,ryl03,ryl04,ryl05,ryl06,ryl07, 
                       ryl08,ryl09,ryl10,ryl11,ryl12,ryl13                     
                  FROM s_plg[1].ryl01,s_plg[1].ryl02,s_plg[1].ryl03,s_plg[1].ryl04,s_plg[1].ryl05,
                       s_plg[1].ryl06,s_plg[1].ryl07,s_plg[1].ryl08,s_plg[1].ryl09,s_plg[1].ryl10,
                       s_plg[1].ryl11,s_plg[1].ryl12,s_plg[1].ryl13
 
           ON ACTION controlp
           CASE
              WHEN INFIELD(ryl01)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryl01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryl01
                 NEXT FIELD ryl01
                 
              WHEN INFIELD(ryl02)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryl02"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryl02
                 NEXT FIELD ryl02
                 
              WHEN INFIELD(ryl05)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryl05"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryl05
                 NEXT FIELD ryl05
                 
              WHEN INFIELD(ryl06)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryl06"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryl06
                 SELECT ryl07 INTO g_plg[1].ryl07 FROM ryl_file 
                  WHERE ryl05 = g_plg[1].ryl05
                 IF SQLCA.sqlcode=100 THEN 
                    LET g_plg[1].ryl07 = NULL
                 END IF   
                 DISPLAY BY NAME g_plg[1].ryl07
                 NEXT FIELD ryl06
                
              WHEN INFIELD(ryl12)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ryl12"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ryl12
                 NEXT FIELD ryl12            
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
        RETURN
    END IF
 
    CALL q001_b_fill(g_wc2)
    
END FUNCTION

FUNCTION q001_b_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql = "SELECT ryl01,ryl02,ryl03,ryl04,ryl05,ryl06,ryl07,ryl08,ryl09, 
                        ryl10,ryl11,ryl12,ryl13 FROM ryl_file ",  
                " WHERE ",p_wc2 CLIPPED
                
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    
    PREPARE q001_pb FROM g_sql
    DECLARE plg_cs CURSOR FOR q001_pb
 
    CALL g_plg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH plg_cs INTO g_plg[g_cnt].*  
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
       EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_plg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
        
END FUNCTION
 
FUNCTION q001_b()
   DEFINE  l_ac_t          LIKE type_file.num5,
           l_n             LIKE type_file.num5,
           l_cnt           LIKE type_file.num5,
           l_lock_sw       LIKE type_file.chr1,
           p_cmd           LIKE type_file.chr1,
           l_misc          LIKE gef_file.gef01,
           l_allow_insert  LIKE type_file.num5,
           l_allow_delete  LIKE type_file.num5
   DEFINE  l_msg           STRING,
           li_n            LIKE type_file.num5
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
           RETURN
        END IF
 
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT ryl01,ryl02,ryl03,ryl04,ryl05,ryl06,ryl07,ryl08,ryl09,",  
                         " ryl10,ryl11,ryl12,ryl13 ",  
                         "  FROM ryl_file",
                         " WHERE ryl01=? AND ryl02=? AND ryl03=?",
                         " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE q001_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=FALSE
        LET l_allow_delete=FALSE
        
        INPUT ARRAY g_plg WITHOUT DEFAULTS FROM s_plg.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                          INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                          APPEND ROW= l_allow_insert)
        BEFORE INPUT
           CALL cl_set_act_visible("insert,delete", FALSE)
           IF g_rec_b !=0 THEN 
                   CALL fgl_set_arr_curr(l_ac)
           END IF
        BEFORE ROW
           LET p_cmd =''
           LET l_ac =ARR_CURR()
           LET l_lock_sw ='N'
           LET l_n =ARR_COUNT()
           
           BEGIN WORK 
                       
           IF g_rec_b>=l_ac THEN 
              LET p_cmd ='u'
              LET g_plg_t.*=g_plg[l_ac].*
              LET g_before_input_done = FALSE                                                                                      
              CALL q001_set_entry(p_cmd)                                                                                           
              CALL q001_set_no_entry(p_cmd)                                                                                        
              
              OPEN q001_bcl USING g_plg_t.ryl01,g_plg_t.ryl02,g_plg_t.ryl03
              IF STATUS THEN
                 CALL cl_err("OPEN q001_bcl:",STATUS,1)
                 LET l_lock_sw='Y'
              ELSE
                 FETCH q001_bcl INTO g_plg[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_plg_t.ryl01,SQLCA.sqlcode,1)
                    LET l_lock_sw="Y"
                 END IF
              END IF
            END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_plg[l_ac].* = g_plg_t.*
              CLOSE q001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_plg[l_ac].ryl01,-263,1)
              LET g_plg[l_ac].* = g_plg_t.*
           ELSE
             
              UPDATE ryl_file SET ryl09 = g_plg[l_ac].ryl09
               WHERE ryl01=g_plg_t.ryl01
                 AND ryl02=g_plg_t.ryl02
                 AND ryl03=g_plg_t.ryl03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ryl_file",g_plg_t.ryl01,"",SQLCA.sqlcode,"","",1) 
                 LET g_plg[l_ac].* = g_plg_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_plg[l_ac].* = g_plg_t.*
              END IF
              CLOSE q001_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE q001_bcl
           COMMIT WORK
           
        ON ACTION CONTROLO                        
           IF INFIELD(ryl01) AND l_ac > 1 THEN
              LET g_plg[l_ac].* = g_plg[l_ac-1].*
              LET g_plg[l_ac].ryl01= g_rec_b + 1
              NEXT FIELD ryl01
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(ryl01)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ryl01" 
               LET g_qryparam.default1 = g_plg[l_ac].ryl01
               CALL cl_create_qry() RETURNING g_plg[l_ac].ryl01
               DISPLAY BY NAME g_plg[l_ac].ryl01
               NEXT FIELD ryl01
               
            WHEN INFIELD(ryl02)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ryl02" 
               LET g_qryparam.default1 = g_plg[l_ac].ryl02
               CALL cl_create_qry() RETURNING g_plg[l_ac].ryl02
               DISPLAY BY NAME g_plg[l_ac].ryl02
               NEXT FIELD ryl02
               
            WHEN INFIELD(ryl05)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ryl05" 
               LET g_qryparam.default1 = g_plg[l_ac].ryl05
               CALL cl_create_qry() RETURNING g_plg[l_ac].ryl05
               DISPLAY BY NAME g_plg[l_ac].ryl05
               NEXT FIELD ryl05
               
            WHEN INFIELD(ryl06)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ryl06" 
               LET g_qryparam.default1 = g_plg[l_ac].ryl06
               CALL cl_create_qry() RETURNING g_plg[l_ac].ryl06
               DISPLAY BY NAME g_plg[l_ac].ryl06
               NEXT FIELD ryl06
               
            WHEN INFIELD(ryl12)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ryl12" 
               LET g_qryparam.default1 = g_plg[l_ac].ryl12
               CALL cl_create_qry() RETURNING g_plg[l_ac].ryl12
               DISPLAY BY NAME g_plg[l_ac].ryl12
               NEXT FIELD ryl12
                           
            OTHERWISE EXIT CASE
          END CASE
     
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
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
  
    CLOSE q001_bcl
    COMMIT WORK
    
END FUNCTION                          
                                                   
FUNCTION q001_bp_refresh()
 
  DISPLAY ARRAY g_plg TO s_plg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
FUNCTION q001_out()                                                     
DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "apcq001" "',g_wc2 CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
    
END FUNCTION                                                            
 
FUNCTION q001_set_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ryl09",TRUE)
   END IF
END FUNCTION
 
FUNCTION q001_set_no_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
      CALL cl_set_comp_entry("ryl01",FALSE)
      CALL cl_set_comp_entry("ryl02",FALSE)
      CALL cl_set_comp_entry("ryl03",FALSE)
      CALL cl_set_comp_entry("ryl04",FALSE)
      CALL cl_set_comp_entry("ryl05",FALSE)
      CALL cl_set_comp_entry("ryl06",FALSE)
      CALL cl_set_comp_entry("ryl07",FALSE)
      CALL cl_set_comp_entry("ryl08",FALSE)
      CALL cl_set_comp_entry("ryl10",FALSE)
      CALL cl_set_comp_entry("ryl11",FALSE)
      CALL cl_set_comp_entry("ryl12",FALSE)
      CALL cl_set_comp_entry("ryl13",FALSE)
   END IF
END FUNCTION

FUNCTION q001_remove()
DEFINE g_success LIKE type_file.chr1  

   LET g_success = 'Y'
   WHILE g_rec_b >= 1
      IF g_plg[g_rec_b].ryl09 = 'Y' THEN
         BEGIN WORK
         DELETE FROM ryl_file
          WHERE ryl01 = g_plg[g_rec_b].ryl01
            AND ryl02 = g_plg[g_rec_b].ryl02
            AND ryl03 = g_plg[g_rec_b].ryl03
         IF SQLCA.sqlcode THEN  
            CALL cl_err3("del","ryl_file",g_plg[g_rec_b].ryl01,"",SQLCA.sqlcode,"","",1)  
            LET g_success = 'N'
         END IF
         IF g_success = 'Y' THEN
            COMMIT WORK
            MESSAGE 'DELETE O.K'
         ELSE
         	  CALL cl_err3("del","ryl_file",g_plg[g_rec_b].ryl01,"",SQLCA.sqlcode,"","",1)
   	        ROLLBACK WORK   
   	        CONTINUE WHILE
         END IF
      END IF   
      LET g_rec_b=g_rec_b-1
   END WHILE
   DISPLAY g_rec_b TO FORMONLY.cnt       
   CALL q001_b_fill('1=1')   
END FUNCTION 
#TQC-B20181
