# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: almi330.4gl
# Descriptions...: 費用總類維護作業
# Date & Author..: NO.FUN-870010 08/07/08 By lilingyu 
# Modify.........: No.FUN-960134 09/07/09 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lnj           DYNAMIC ARRAY OF RECORD    
         lnj01       LIKE lnj_file.lnj01,
         lnj02       LIKE lnj_file.lnj02,
         lnj03       LIKE lnj_file.lnj03
                    END RECORD,
     g_lnj_t        RECORD    
         lnj01       LIKE lnj_file.lnj01,
         lnj02       LIKE lnj_file.lnj02,
         lnj03       LIKE lnj_file.lnj03
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
 
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW i330_w WITH FORM "alm/42f/almi330" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
   
    LET g_wc2 = '1=1' 
    CALL i330_b_fill(g_wc2)
    
    CALL i330_menu()
    CLOSE WINDOW i330_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i330_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL i330_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i330_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i330_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lnj[l_ac].lnj01 IS NOT NULL THEN
                  LET g_doc.column1 = "lnj01"
                  LET g_doc.value1 = g_lnj[l_ac].lnj01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnj),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i330_q()
   CALL i330_b_askkey()
END FUNCTION
 
FUNCTION i330_b()
DEFINE l_cnt       LIKE type_file.num5
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
 
   LET g_forupd_sql = "SELECT lnj01,lnj02,lnj03", 
                      "  FROM lnj_file ",
                      " WHERE lnj01= ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i330_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lnj WITHOUT DEFAULTS FROM s_lnj.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'           
          LET l_n  = ARR_COUNT()
 
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL i330_set_entry(p_cmd)                                         
             CALL i330_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE   
             LET g_lnj_t.* = g_lnj[l_ac].*  
             OPEN i330_bcl USING g_lnj_t.lnj01
             IF STATUS THEN
                CALL cl_err("OPEN i330_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i330_bcl INTO g_lnj[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lnj_t.lnj01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL i330_set_entry(p_cmd)                                            
          CALL i330_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lnj[l_ac].* TO NULL      
          LET g_lnj[l_ac].lnj03 = 'Y'       
          LET g_lnj_t.* = g_lnj[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lnj01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i330_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lnj_file(lnj01,lnj02,lnj03)
               VALUES(g_lnj[l_ac].lnj01,g_lnj[l_ac].lnj02,g_lnj[l_ac].lnj03)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lnj_file",g_lnj[l_ac].lnj01,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD lnj01                        #check 編號是否重複
          IF NOT cl_null(g_lnj[l_ac].lnj01) THEN
             IF g_lnj[l_ac].lnj01 != g_lnj_t.lnj01 OR
                g_lnj_t.lnj01 IS NULL THEN
                SELECT count(*) INTO l_n FROM lnj_file
                 WHERE lnj01 = g_lnj[l_ac].lnj01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_lnj[l_ac].lnj01 = g_lnj_t.lnj01
                   NEXT FIELD lnj01
                END IF
             END IF
          END IF   
 
       AFTER FIELD lnj03
          IF p_cmd = 'u' AND g_lnj_t.lnj03 = 'Y' AND
             g_lnj[l_ac].lnj03 = 'N' THEN
             SELECT COUNT(*) INTO l_cnt FROM oaj_file
              WHERE oaj031 = g_lnj_t.lnj01
             IF l_cnt > 0 THEN
                CALL cl_err('','alm-563',1)
                LET g_lnj[l_ac].lnj03 = 'Y'
                NEXT FIELD lnj03
             END IF
          END IF
            		
       BEFORE DELETE                            #是否取消單身
          IF g_lnj_t.lnj01 IS NOT NULL THEN
             SELECT COUNT(*) INTO l_cnt FROM oaj_file
              WHERE oaj031 = g_lnj_t.lnj01
             IF l_cnt > 0 THEN
                CALL cl_err('','alm-563',1)
                CANCEL DELETE
             END IF
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lnj01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lnj[l_ac].lnj01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lnj_file WHERE lnj01 = g_lnj_t.lnj01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lnj_file",g_lnj_t.lnj01,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lnj[l_ac].* = g_lnj_t.*
             CLOSE i330_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lnj[l_ac].lnj01,-263,0)
             LET g_lnj[l_ac].* = g_lnj_t.*
          ELSE
             UPDATE lnj_file SET lnj01=g_lnj[l_ac].lnj01,
                                 lnj02=g_lnj[l_ac].lnj02,
                                 lnj03=g_lnj[l_ac].lnj03
              WHERE lnj01 = g_lnj_t.lnj01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lnj_file",g_lnj_t.lnj01,"",SQLCA.sqlcode,"","",1)  
                LET g_lnj[l_ac].* = g_lnj_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增     #FUN-D30033
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lnj[l_ac].* = g_lnj_t.*
             #FUN-D30033----add--str
             ELSE
                CALL g_lnj.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033---add--end
             END IF
             CLOSE i330_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac                # 新增     #FUN-D30033
          CLOSE i330_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lnj01) AND l_ac > 1 THEN
             LET g_lnj[l_ac].* = g_lnj[l_ac-1].*
             NEXT FIELD lnj01
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
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
        
   END INPUT
 
   CLOSE i330_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i330_b_askkey()
 
   CLEAR FORM
   CALL g_lnj.clear()
   CONSTRUCT g_wc2 ON lnj01,lnj02,lnj03   
                 FROM s_lnj[1].lnj01,s_lnj[1].lnj02,s_lnj[1].lnj03
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()  
         
       ON ACTION CONTROLP                                                                                                            
           CASE                                                                                                                     
              WHEN INFIELD(lnj01)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_lnj1"                                                                                      
                 LET g_qryparam.state='c'                                                                                           
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO lnj01                                                                              
                 NEXT FIELD lnj01                                                                                                   
           END CASE        
    
	    ON ACTION qbe_select
    	   CALL cl_qbe_select() 
  
      ON ACTION qbe_save
	  	   CALL cl_qbe_save()
		
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i330_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i330_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 
    LET g_sql ="SELECT lnj01,lnj02,lnj03",   
               " FROM lnj_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY lnj01"
    PREPARE i330_pb FROM g_sql
    DECLARE lnj_curs CURSOR FOR i330_pb
 
    CALL g_lnj.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lnj_curs INTO g_lnj[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_lnj.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i330_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lnj TO s_lnj.* ATTRIBUTE(COUNT=g_rec_b)
 
   BEFORE ROW
       LET l_ac = ARR_CURR()
       CALL cl_show_fld_cont()                  
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
 
       ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
    
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                            
FUNCTION i330_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lnj01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i330_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lnj01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134      
