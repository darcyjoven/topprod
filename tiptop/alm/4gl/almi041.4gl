# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: almi041.4gl
# Descriptions...: 預算維護作業
# Date & Author..: NO.FUN-870010 08/12/15 By lilingyu 
# Modify.........: No.FUN-960134 09/07/23 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No.FUN-D30033 13/04/12 By minpp 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lto          DYNAMIC ARRAY OF RECORD    
         ltostore    LIKE lto_file.ltostore,
        #rtz13       LIKE rtz_file.rtz13, #FUN-A80148 ---mark---
         rtz13       LIKE rtz_file.rtz13, #FUN-A80148 add
         ltolegal LIKE lto_file.ltolegal,
         azt02    LIKE azt_file.azt02,
         lto02    LIKE lto_file.lto02,  
         lto03    LIKE lto_file.lto03,
         lto04    LIKE lto_file.lto04
                    END RECORD,
     g_lto_t        RECORD    
         ltostore    LIKE lto_file.ltostore,
        #rtz13       LIKE rtz_file.rtz13, #FUN-A80148 ---mark---
         rtz13       LIKE rtz_file.rtz13, #FUN-A80148 add
         ltolegal LIKE lto_file.ltolegal,
         azt02    LIKE azt_file.azt02,
         lto02    LIKE lto_file.lto02,  
         lto03    LIKE lto_file.lto03,
         lto04    LIKE lto_file.lto04
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
        INPUT NO WRAP     #No.FUN-9B0136
    #   FIELD ORDER FORM  #No.FUN-9B0136
    DEFER INTERRUPT                       
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW i041_w WITH FORM "alm/42f/almi041" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
   
    LET g_wc2 = '1=1' 
    CALL i041_b_fill(g_wc2)
    
    CALL i041_menu()
    CLOSE WINDOW i041_w    
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i041_menu()
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL i041_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i041_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i041_b()
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
               IF g_lto[l_ac].ltostore IS NOT NULL THEN
                  LET g_doc.column1 = "ltostore"
                  LET g_doc.value1 = g_lto[l_ac].ltostore
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lto),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i041_q()
   CALL i041_b_askkey()
END FUNCTION
 
FUNCTION i041_b()
DEFINE
   l_ac_t          LIKE type_file.num5,           
   l_n             LIKE type_file.num5,     
   l_lock_sw       LIKE type_file.chr1,          
   p_cmd           LIKE type_file.chr1,         
   l_allow_insert  LIKE type_file.chr1,         
   l_allow_delete  LIKE type_file.chr1           
#DEFINE l_rtz28    LIKE rtz_file.rtz28 #FUN-A80148 ---mark---
DEFINE l_rtz28     LIKE rtz_file.rtz28 #FUN-A80148
DEFINE l_rtz13     LIKE rtz_file.rtz13
DEFINE l_azw02     LIKE azw_file.azw02
DEFINE l_azt02     LIKE azt_file.azt02
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT ltostore,'',ltolegal,'',lto02,lto03,lto04 FROM lto_file", 
                      " WHERE ltostore= ? AND lto02 = ? and lto03 = ?",
                      " FOR UPDATE "
               
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i041_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lto WITHOUT DEFAULTS FROM s_lto.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,
                DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert) 
 
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
             CALL i041_set_entry(p_cmd)                                         
             CALL i041_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE   
             LET g_lto_t.* = g_lto[l_ac].*  
             OPEN i041_bcl USING g_lto_t.ltostore,
                                 g_lto_t.lto02,
                                 g_lto_t.lto03
             IF STATUS THEN
                CALL cl_err("OPEN i041_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i041_bcl INTO g_lto[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lto_t.ltostore,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                SELECT rtz13 INTO l_rtz13 FROM rtz_file
                 WHERE rtz01 = g_lto[l_ac].ltostore 
                   AND rtz28 = 'Y'
                 LET g_lto[l_ac].rtz13 = l_rtz13
                SELECT azt02 INTO g_lto[l_ac].azt02 FROM azt_file
                 WHERE azt01 = g_lto[l_ac].ltolegal
                 DISPLAY BY NAME g_lto[l_ac].rtz13,g_lto[l_ac].azt02                     
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL i041_set_entry(p_cmd)                                            
          CALL i041_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lto[l_ac].* TO NULL      
          LET g_lto_t.* = g_lto[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD ltostore
 
        AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i041_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lto_file(ltostore,ltolegal,lto02,lto03,lto04)
               VALUES(g_lto[l_ac].ltostore,g_lto[l_ac].ltolegal,
                      g_lto[l_ac].lto02,g_lto[l_ac].lto03,
                      g_lto[l_ac].lto04)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lto_file",g_lto[l_ac].ltostore,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
       AFTER FIELD ltostore                        #check 編號是否重複
          IF NOT cl_null(g_lto[l_ac].ltostore) THEN
             IF g_lto[l_ac].ltostore != g_lto_t.ltostore OR
                g_lto_t.ltostore IS NULL THEN
                SELECT count(*) INTO l_n FROM rtz_file
                 WHERE rtz01 = g_lto[l_ac].ltostore
                IF l_n = 0 THEN
                   CALL cl_err('','alm-001',0)
                   NEXT FIELD ltostore
                ELSE 
                   SELECT rtz13,rtz28 INTO l_rtz13,l_rtz28 FROM rtz_file
               	    WHERE rtz01 = g_lto[l_ac].ltostore
                   IF l_rtz28 = 'Y' THEN 
                      SELECT azw02 INTO l_azw02 FROM azw_file
                       WHERE azw01 = g_lto[l_ac].ltostore
                      IF NOT cl_null(l_azw02) THEN
                         SELECT azt02 INTO l_azt02 FROM azt_file
                          WHERE azt01 = l_azw02
                         LET g_lto[l_ac].ltolegal = l_azw02
                         LET g_lto[l_ac].azt02 = l_azt02
                      END IF
                      LET g_lto[l_ac].rtz13 = l_rtz13
                      DISPLAY BY NAME g_lto[l_ac].rtz13,g_lto[l_ac].ltolegal,
                                      g_lto[l_ac].azt02 
                      LET l_n = 0
                      SELECT COUNT(*) INTO l_n FROM lto_file
                       WHERE ltostore = g_lto[l_ac].ltostore
                         AND lto02 = g_lto[l_ac].lto02
                         AND lto03 = g_lto[l_ac].lto03
                      IF l_n >= 1 THEN 
                          CALL cl_err('','alm-751',0)
                          NEXT FIELD ltostore
                      END IF    
                    ELSE
                      CALL cl_err('','alm-750',0)
                      NEXT FIELD ltostore
                   END IF 	     
                END IF
             END IF
          END IF   
     
      AFTER FIELD lto02
        IF NOT cl_null(g_lto[l_ac].lto02) THEN 
           IF g_lto[l_ac].lto02 != g_lto_t.lto02 OR
                g_lto_t.lto02 IS NULL THEN
                IF LENGTH(g_lto[l_ac].lto02)<> 4 THEN 
                   CALL cl_err('','alm-157',0)
                   NEXT FIELD lto02
                ELSE
                    IF g_lto[l_ac].lto02 <= 0 THEN 
                       CALL cl_err('','alm-105',0)
                        NEXT FIELD lto02
                     ELSE   
                        LET l_n = 0
                        SELECT COUNT(*) INTO l_n FROM lto_file
                         WHERE ltostore = g_lto[l_ac].ltostore
                           AND lto02 = g_lto[l_ac].lto02
                  	   AND lto03 = g_lto[l_ac].lto03   
                        IF l_n >= 1 THEN 
                           CALL cl_err('','alm-751',0)
                  	   NEXT FIELD lto02
                        END IF    
                    END IF   
                END IF  
             END IF
        END IF 
       
        AFTER FIELD lto03
        IF NOT cl_null(g_lto[l_ac].lto03) THEN 
           IF g_lto[l_ac].lto03 != g_lto_t.lto03 OR
                g_lto_t.lto03 IS NULL THEN
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM lto_file
                WHERE ltostore = g_lto[l_ac].ltostore
                  AND lto02 = g_lto[l_ac].lto02
                  AND lto03 = g_lto[l_ac].lto03   
                IF l_n >= 1 THEN 
                    CALL cl_err('','alm-751',0)
                    NEXT FIELD lto03
             	  END IF    
            END IF
        END IF  
       
       AFTER FIELD lto04
         IF NOT cl_null(g_lto[l_ac].lto04) THEN 
            IF g_lto[l_ac].lto04 <= 0 THEN 
               CALL cl_err('','alm-752',0)
               NEXT FIELD lto04 
            END IF 
         END IF 
            		
       BEFORE DELETE                            #是否取消單身
          IF g_lto_t.ltostore IS NOT NULL OR 
             g_lto_t.lto02 IS NOT NULL OR 
             g_lto_t.lto03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                   #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "ltostore"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lto[l_ac].ltostore      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lto_file WHERE ltostore = g_lto_t.ltostore
                                       AND lto02 = g_lto_t.lto02
                                       AND lto03 = g_lto_t.lto03                                            
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lto_file",g_lto_t.ltostore,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cnt
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lto[l_ac].* = g_lto_t.*
             CLOSE i041_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lto[l_ac].ltostore,-263,0)
             LET g_lto[l_ac].* = g_lto_t.*
          ELSE
             UPDATE lto_file SET lto04 = g_lto[l_ac].lto04,
                                 lto02 = g_lto[l_ac].lto02,
                                 lto03 = g_lto[l_ac].lto03,
                                 ltolegal = g_lto[l_ac].ltolegal,
                                 ltostore = g_lto[l_ac].ltostore
              WHERE ltostore = g_lto_t.ltostore
                AND lto02 = g_lto_t.lto02
                AND lto03 = g_lto_t.lto03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lto_file",g_lto_t.ltostore,"",SQLCA.sqlcode,"","",1)  
                LET g_lto[l_ac].* = g_lto_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增  #FUN-D30033
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lto[l_ac].* = g_lto_t.*
             #FUN-D30033----add--str
             ELSE
                CALL g_lto.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033---add--end
             END IF
             CLOSE i041_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac         # 新增  #FUN-D30033
          CLOSE i041_bcl            # 新增
          COMMIT WORK
 
      ON ACTION CONTROLP
          CASE            
             WHEN INFIELD(ltostore)                           
                CALL cl_init_qry_var()                        
                LET g_qryparam.form ="q_lto1"
                LET g_qryparam.default1 = g_lto[l_ac].ltostore                        
                LET g_qryparam.where = " rtz01 IN ",g_auth," "  #No.FUN-A10060
                CALL cl_create_qry() RETURNING g_lto[l_ac].ltostore               
                DISPLAY g_lto[l_ac].ltostore TO ltostore
                NEXT FIELD ltostore      
             OTHERWISE 
                 EXIT CASE
           END CASE      
       
       
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
 
   CLOSE i041_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i041_b_askkey()
 
   CLEAR FORM
   CALL g_lto.clear()
   CONSTRUCT g_wc2 ON ltostore,ltolegal,lto02,lto03,lto04   
                 FROM s_lto[1].ltostore,s_lto[1].ltolegal,s_lto[1].lto02,
                      s_lto[1].lto03,s_lto[1].lto04
 
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
            WHEN INFIELD(ltostore)                                  
                CALL cl_init_qry_var()        
                 LET g_qryparam.form ="q_ltostore"
                 LET g_qryparam.state='c'                          
                 LET g_qryparam.where = " ltostore IN ",g_auth," "  #No.FUN-A10060
                 CALL cl_create_qry() RETURNING g_qryparam.multiret       
                 DISPLAY g_qryparam.multiret TO ltostore          
                 NEXT FIELD ltostore                                                  
            WHEN INFIELD(ltolegal)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ltolegal"
               LET g_qryparam.state='c'
               LET g_qryparam.where = " ltostore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ltolegal
               NEXT FIELD ltolegal
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
 
   CALL i041_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i041_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 DEFINE   l_rtz13         LIKE rtz_file.rtz13
 
    LET g_sql ="SELECT ltostore,'',ltolegal,'',lto02,lto03,lto04",   
               " FROM lto_file ",
               " WHERE ", p_wc2 CLIPPED,          #單身
               "   AND ltostore IN ",g_auth," ",   #No.FUN-A10060
               " ORDER BY lto02,lto03"
    PREPARE i041_pb FROM g_sql
    DECLARE lto_curs CURSOR FOR i041_pb
 
    CALL g_lto.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lto_curs INTO g_lto[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
         
        SELECT rtz13 INTO l_rtz13 FROM rtz_file
         WHERE rtz01 = g_lto[g_cnt].ltostore
           AND rtz28 = 'Y'         
        LET g_lto[g_cnt].rtz13 = l_rtz13
        SELECT azt02 INTO g_lto[g_cnt].azt02 FROM azt_file
         WHERE azt01 = g_lto[g_cnt].ltolegal
        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lto.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i041_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lto TO s_lto.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION i041_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("ltostore,lto02,lto03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i041_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("ltostore,lto02,lto03",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION             
#No.FUN-960134
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
