# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: aski014.4gl
# Descriptions...: 度法資料維護作業 
# Date & Author..: 08/06/30 BY ve007   FUN-870117
# Modify ........: No.FUN-8A0145 08/10/31 by hongmei 欄位類型修改
# Modify.........: No.TQC-8C0056 08/12/23 By alex 調整setup參數
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_slb           DYNAMIC ARRAY OF RECORD   
        slb01       LIKE slb_file.slb01,   
        slb02       LIKE slb_file.slb02,   
        slb03       LIKE slb_file.slb03,  
        slbacti     LIKE slb_file.slbacti  # LIKE type_file.chr1 FUN-8A0145
                       END RECORD,
    g_slb_t         RECORD                 
        slb01       LIKE slb_file.slb01,   
        slb02       LIKE slb_file.slb02,   
        slb03       LIKE slb_file.slb03,   
        slbacti     LIKE slb_file.slbacti  # LIKE type_file.chr1 FUN-8A0145
                    END RECORD,
    g_wc2,g_sql     STRING,  
    g_rec_b         LIKE type_file.num5,   #LIKE type_file.num5, FUN-8A0145            
    l_ac            LIKE type_file.num5    #LIKE type_file.num5  FUN-8A0145             
 
DEFINE g_before_input_done  LIKE type_file.num5  #LIKE type_file.num5    
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt           LIKE type_file.num10    #INTEGER   
DEFINE g_i             LIKE type_file.num5     #LIKE type_file.num5 #count/index for any purpose
 
MAIN
   OPTIONS                               
      INPUT NO WRAP
   DEFER INTERRUPT                    
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASK")) THEN   #TQC-8C0056
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW i014_w WITH FORM "ask/42f/aski014"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i014_b_fill()
   CALL i014_menu()
 
   CLOSE WINDOW i014_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
 
FUNCTION i014_menu()
 
   WHILE TRUE
      CALL i014_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i014_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i014_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0018
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_slb),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i014_q()
   CALL i014_b_askkey()
END FUNCTION
 
FUNCTION i014_b()
DEFINE
    l_ac_t          LIKE type_file.num5,             
    l_n             LIKE type_file.num5,             
    l_lock_sw       LIKE type_file.chr1,              
    p_cmd           LIKE type_file.chr1,              
    l_allow_insert  LIKE type_file.chr1, 
    l_allow_delete  LIKE type_file.chr1 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT slb01,slb02,
                               slb03,slbacti 
                          FROM slb_file 
                         WHERE slb01=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i014_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_slb.clear() END IF
 
 
        INPUT ARRAY g_slb WITHOUT DEFAULTS FROM s_slb.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT                                                              
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_slb_t.* = g_slb[l_ac].*  #BACKUP
                                                                                                          
               LET  g_before_input_done = FALSE                                                                                     
       #       CALL i014_set_entry(p_cmd)   
               CALL i014_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
        
               BEGIN WORK
               OPEN i014_bcl USING g_slb_t.slb01
               IF STATUS THEN
                  CALL cl_err("OPEN i014_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE    
                  FETCH i014_bcl INTO g_slb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_slb_t.slb01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE 
                     LET g_slb_t.* = g_slb[l_ac].*  #BACKUP
                  END IF
               END IF
               CALL cl_show_fld_cont()     
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                                                                                                          
            LET  g_before_input_done = FALSE                                                                                        
            CALL i014_set_entry(p_cmd)                                                                                              
            LET  g_before_input_done = TRUE                                                                                         
 
            INITIALIZE g_slb[l_ac].* TO NULL     
            LET g_slb[l_ac].slbacti = 'Y'       #Body default
            LET g_slb_t.* = g_slb[l_ac].*       
            CALL cl_show_fld_cont()     
            NEXT FIELD slb01
 
      AFTER INSERT
         IF INT_FLAG THEN                
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_slb[l_ac].* TO NULL  
              DISPLAY g_slb[l_ac].* TO s_slb.*
              CALL g_slb.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
         END IF
         INSERT INTO slb_file(slb01,slb02,slb03,
                                  slbacti,slbuser,slbdate,slboriu,slborig)
         VALUES(g_slb[l_ac].slb01,
                g_slb[l_ac].slb02,g_slb[l_ac].slb03,
                g_slb[l_ac].slbacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_slb[l_ac].slb01,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD slb01                       
            IF g_slb[l_ac].slb01 IS NOT NULL THEN 
               IF g_slb[l_ac].slb01 != g_slb_t.slb01 OR 
                  (g_slb[l_ac].slb01 IS NOT NULL 
                AND g_slb_t.slb01 IS NULL) THEN 
         
                  SELECT count(*) INTO l_n FROM slb_file
                   WHERE slb01 = g_slb[l_ac].slb01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_slb[l_ac].slb01 = g_slb_t.slb01
                     NEXT FIELD slb01
                  END IF
               END IF
            END IF
        BEFORE DELETE                          
            IF g_slb_t.slb01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM slb_file 
                      WHERE slb01 = g_slb_t.slb01
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_slb_t.slb01,SQLCA.sqlcode,0)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i014_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN              
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_slb[l_ac].* = g_slb_t.*
              CLOSE i014_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_slb[l_ac].slb01,-263,1)
              LET g_slb[l_ac].* = g_slb_t.*
           ELSE
              UPDATE slb_file SET
                                  slb01=g_slb[l_ac].slb01,
                                  slb02=g_slb[l_ac].slb02,
                                  slb03=g_slb[l_ac].slb03,
                                  slbacti=g_slb[l_ac].slbacti,
                                  slbmodu=g_user,
                                  slbdate=g_today
               WHERE slb01=g_slb_t.slb01
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_slb[l_ac].slb01,SQLCA.sqlcode,0)
                  LET g_slb[l_ac].* = g_slb_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i014_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                                             
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN 
                  LET g_slb[l_ac].* = g_slb_t.*  
               #FUN-D40030---add---str---
               ELSE
                  CALL g_slb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---                                  
               END IF 
               CLOSE i014_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i014_bcl                                                      
            COMMIT WORK            
            #CKP2
            CALL g_slb.deleteElement(g_rec_b+1)       
 
        ON ACTION CONTROLN
            CALL i014_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                      
            IF INFIELD(slb01) AND l_ac > 1 THEN
                LET g_slb[l_ac].* = g_slb[l_ac-1].*
                NEXT FIELD slb01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
        
        END INPUT
 
    CLOSE i014_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i014_b_askkey()
    CLEAR FORM
    CALL g_slb.clear()
    CONSTRUCT g_wc2 ON slb01,slb02,slb03,slbacti
         FROM s_slb[1].slb01,
              s_slb[1].slb02,s_slb[1].slb03,
              s_slb[1].slbacti
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
    
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('slbuser', 'slbgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i014_b_fill()
END FUNCTION
 
FUNCTION i014_b_fill()              #BODY FILL UP
 
    LET g_sql = " SELECT slb01,slb02,slb03,slbacti FROM slb_file",
                 " WHERE ", g_wc2 CLIPPED,                    
                 " ORDER BY 1"
    PREPARE i014_pb FROM g_sql
    DECLARE slb_curs CURSOR FOR i014_pb
 
    CALL g_slb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH slb_curs INTO g_slb[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_slb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i014_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_slb TO s_slb.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
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
 
                                                                                                           
FUNCTION i014_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1                                                                                                           
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("slb01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION   
 
FUNCTION i014_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
 
     CALL cl_set_comp_entry("slb01",FALSE)
 
   END IF
END FUNCTION
#No.FUN-870117                                                                                                                     
    
