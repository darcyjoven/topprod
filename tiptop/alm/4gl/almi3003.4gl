# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: almi3003.4gl
# Descriptions...: 正式商戶狀態信息維護作業
# Date & Author..: NO.FUN-870010 08/07/31 By lilingyu 
# Modify.........: No.FUN-960134 09/07/10 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-AB0096 10/11/24 By wangxin 修正 lnhstore 的開窗錯誤, 及資料新增的邏輯
# Modify.........: No:TQC-AC0362 10/12/27 By shiwuying 法人取值錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lnh           DYNAMIC ARRAY OF RECORD    
         lnhstore       LIKE lnh_file.lnhstore,
         rtz13       LIKE rtz_file.rtz13,   #FUN-A80148 add
         lnhlegal    LIKE lnh_file.lnhlegal,
         azt02       LIKE azt_file.azt02,
         lnh04       LIKE lnh_file.lnh04,
         lnh05       LIKE lnh_file.lnh05,
         lnh06       LIKE lnh_file.lnh06,
         lnh07       LIKE lnh_file.lnh07       
                    END RECORD,
     g_lnh_t        RECORD    
         lnhstore       LIKE lnh_file.lnhstore,
         rtz13       LIKE rtz_file.rtz13,  #FUN-A80148 add
         lnhlegal    LIKE lnh_file.lnhlegal,
         azt02       LIKE azt_file.azt02,
         lnh04       LIKE lnh_file.lnh04,
         lnh05       LIKE lnh_file.lnh05,
         lnh06       LIKE lnh_file.lnh06,
         lnh07       LIKE lnh_file.lnh07      
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE lne_file.lne04
DEFINE g_argv2               LIKE lne_file.lne01
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
     
    OPEN WINDOW i3003_w WITH FORM "alm/42f/almi3003" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()    
   
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       LET g_wc2 = " lnh01 = '",g_argv2,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL i3003_b_fill(g_wc2)
    
    CALL i3003_menu()
    CLOSE WINDOW i3003_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i3003_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL i3003_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i3003_q()
            END IF
         
         WHEN "body"
             IF cl_chk_act_auth() THEN 
                IF g_rec_b = 0 THEN  
                   CALL cl_err('','alm-414',1)
                   CONTINUE WHILE
                ELSE
                   CALL i3003_b('c')
                END IF
             END IF 
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN               
               CALL i3003_b('')
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
               IF g_lnh[l_ac].lnhstore IS NOT NULL THEN
                  LET g_doc.column1 = "lnhstore"
                  LET g_doc.value1 = g_lnh[l_ac].lnhstore
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnh),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i3003_q()
   CALL i3003_b_askkey()
END FUNCTION
 
FUNCTION i3003_b(w_cmd)
DEFINE
       l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5,    
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       w_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1        
DEFINE l_lne36         LIKE lne_file.lne36
#DEFINE l_lneacti       LIKE lne_file.lneacti
DEFINE l_rtz28         LIKE rtz_file.rtz28   #FUN-A80148 add
DEFINE l_rtz13         LIKE rtz_file.rtz13   #FUN-A80148 add
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT lne36 INTO l_lne36 FROM lne_file
    WHERE lne01      = g_argv2
   IF (l_lne36 = 'Y' OR l_lne36 = 'X') THEN 
       CALL cl_err('','alm-148',0)
       LET g_action_choice = NULL 
       RETURN 
   END IF     
       
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   IF w_cmd = 'c' THEN
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
   ELSE
      LET l_allow_insert = cl_detail_input_auth('insert')
      LET l_allow_delete = cl_detail_input_auth('delete')
   END IF
 
   LET g_forupd_sql = "SELECT lnhstore,'',lnhlegal,'',lnh04,lnh05,lnh06,lnh07", 
                      "  FROM lnh_file WHERE  ",
                      "  lnh01= '",g_argv2,"' and lnhstore = ?  ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i3003_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lnh WITHOUT DEFAULTS FROM s_lnh.*
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
          LET g_lnh[l_ac].lnh06 = 'N'
           
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL i3003_set_entry(p_cmd)                                         
             CALL i3003_arg(w_cmd)
             CALL i3003_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lnh_t.* = g_lnh[l_ac].*  
             OPEN i3003_bcl USING g_lnh_t.lnhstore
             IF STATUS THEN
                CALL cl_err("OPEN i3003_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i3003_bcl INTO g_lnh[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lnh_t.lnhstore,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                ################################
                 SELECT rtz13 INTO l_rtz13 FROM rtz_file
                  WHERE rtz01      = g_lnh[l_ac].lnhstore
                  LET g_lnh[l_ac].rtz13 = l_rtz13   
                SELECT azt02 INTO g_lnh[l_ac].azt02 FROM azt_file
                             WHERE azt01 = g_lnh[l_ac].lnhlegal
                   DISPLAY BY NAME g_lnh[l_ac].rtz13,g_lnh[l_ac].azt02
               ########################           
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL i3003_set_entry(p_cmd)  
          CALL i3003_arg(w_cmd)
          CALL i3003_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lnh[l_ac].* TO NULL    
          LET g_lnh_t.* = g_lnh[l_ac].*     
          LET g_lnh[l_ac].lnh06 = 'N'  
          DISPLAY BY NAME g_lnh[l_ac].lnh06
          #FUN-AB0096 add -------------begin----------------------
          LET g_lnh[l_ac].lnhstore = g_plant
          SELECT rtz13 INTO g_lnh[l_ac].rtz13 FROM rtz_file
           WHERE rtz01 = g_lnh[l_ac].lnhstore  
           
         #TQC-AC0362 Begin---
         #SELECT lnhlegal INTO g_lnh[l_ac].lnhlegal FROM lnh_file
         # WHERE lnhstore = g_lnh[l_ac].lnhstore            
          SELECT azw02 INTO g_lnh[l_ac].lnhlegal FROM azw_file
           WHERE azw01 = g_lnh[l_ac].lnhstore            
         #TQC-AC0362 End-----
          SELECT azt02 INTO g_lnh[l_ac].azt02 FROM azt_file
           WHERE azt01 = g_lnh[l_ac].lnhlegal 
          DISPLAY BY NAME g_lnh[l_ac].lnhstore,g_lnh[l_ac].rtz13,
                          g_lnh[l_ac].lnhlegal,g_lnh[l_ac].azt02                
          #FUN-AB0096 add --------------end-----------------------
          CALL cl_show_fld_cont()    
          #NEXT FIELD lnhstore  #FUN-AB0096 mark 
          NEXT FIELD lnh04      #FUN-AB0096 add 
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i3003_bcl
             CANCEL INSERT
          END IF
         INSERT INTO lnh_file(lnh00,lnh01,lnh02,lnhstore,lnh04,lnh05,lnh06,lnh07,lnhlegal)
              VALUES(g_argv1,g_argv2,'0',g_lnh[l_ac].lnhstore,g_lnh[l_ac].lnh04,
                     g_lnh[l_ac].lnh05,g_lnh[l_ac].lnh06,g_lnh[l_ac].lnh07,g_lnh[l_ac].lnhlegal)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lnh_file",g_lnh[l_ac].lnhstore,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       AFTER FIELD lnhstore                        
          IF NOT cl_null(g_lnh[l_ac].lnhstore) THEN 
             IF p_cmd = 'a' THEN 
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM rtz_file
               WHERE  rtz01      = g_lnh[l_ac].lnhstore
                IF l_n < 1 THEN 
                   CALL cl_err('','alm-077',0)
                   LET g_lnh[l_ac].lnhstore = g_lnh_t.lnhstore
                   DISPLAY BY NAME g_lnh[l_ac].lnhstore
                   NEXT FIELD lnhstore 
                 ELSE
                   SELECT rtz28 INTO l_rtz28 FROM rtz_file
                    WHERE  rtz01      = g_lnh[l_ac].lnhstore
                     IF l_rtz28 != 'Y' THEN 
                        CALL cl_err('','alm-002',0)
                        LET g_lnh[l_ac].lnhstore = g_lnh_t.lnhstore
                        DISPLAY BY NAME g_lnh[l_ac].lnhstore
                        NEXT FIELD lnhstore 
                     ELSE
                     	   LET l_n = 0 
                     	   SELECT COUNT(lnhstore) INTO l_n FROM lnh_file
                     	    WHERE  lnh01       = g_argv2
                     	      AND  lnhstore       = g_lnh[l_ac].lnhstore
                     	    IF l_n > 0 THEN 
                     	       CALL cl_err('','alm-172',0)
                     	       NEXT FIELD lnhstore
                     	    ELSE
                     	    SELECT azw02 INTO g_lnh[l_ac].lnhlegal FROM azw_file
                             WHERE azw01 = g_lnh[l_ac].lnhstore 
                            SELECT azt02 INTO g_lnh[l_ac].azt02 FROM azt_file
                             WHERE azt01 = g_lnh[l_ac].lnhlegal	    
                     	   SELECT rtz13 INTO l_rtz13 FROM rtz_file
                            WHERE rtz01      = g_lnh[l_ac].lnhstore
                         LET g_lnh[l_ac].rtz13 = l_rtz13
                         DISPLAY BY NAME g_lnh[l_ac].rtz13,g_lnh[l_ac].lnhlegal,g_lnh[l_ac].azt02
                         END IF 
                     END IF                     
                 END IF 	
               END IF       
          ELSE
             CALL cl_err('','alm-062',0)
             NEXT FIELD lnhstore
          END IF
         
       AFTER FIELD lnh04
          IF NOT cl_null(g_lnh[l_ac].lnh04) THEN 
             IF g_lnh[l_ac].lnh06 = 'N' THEN 
               LET g_lnh[l_ac].lnh07 = g_lnh[l_ac].lnh04
             END IF
          END IF 
     
      AFTER FIELD lnh05
           IF NOT cl_null(g_lnh[l_ac].lnh05) THEN 
             IF g_lnh[l_ac].lnh06 = 'Y' THEN 
                LET  g_lnh[l_ac].lnh07 = g_lnh[l_ac].lnh05
             END IF
          END IF 
     
     BEFORE FIELD lnh06 
        IF g_rec_b = 0 THEN 
           CALL cl_err('','alm-414',1)
           RETURN
        END IF    
          
     AFTER FIELD lnh06
           IF g_lnh[l_ac].lnh06 = 'Y' THEN 
              LET g_lnh[l_ac].lnh07 = g_lnh[l_ac].lnh05
           ELSE
           	  IF g_lnh[l_ac].lnh06 = 'N' THEN 
           	    LET g_lnh[l_ac].lnh07 = g_lnh[l_ac].lnh04  
           	  END IF      
           END IF 
           
       BEFORE DELETE                      
          IF g_lnh_t.lnhstore IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                   #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lnhstore"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lnh[l_ac].lnhstore      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lnh_file WHERE lnhstore = g_lnh_t.lnhstore
                                    AND lnh01 = g_argv2
                                    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lnh_file",g_lnh_t.lnhstore,"",SQLCA.sqlcode,"","",1)  
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_lnh[l_ac].* = g_lnh_t.*
             CLOSE i3003_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lnh[l_ac].lnhstore,-263,0)
             LET g_lnh[l_ac].* = g_lnh_t.*
          ELSE
             UPDATE lnh_file SET lnhstore=g_lnh[l_ac].lnhstore,
                                 lnhlegal=g_lnh[l_ac].lnhlegal,
                                 lnh04=g_lnh[l_ac].lnh04,
                                 lnh05=g_lnh[l_ac].lnh05,
                                 lnh06=g_lnh[l_ac].lnh06,
                                 lnh07=g_lnh[l_ac].lnh07
              WHERE lnhstore = g_lnh_t.lnhstore
                AND lnh01 = g_argv2
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lnh_file",g_lnh_t.lnhstore,"",SQLCA.sqlcode,"","",1)  
                LET g_lnh[l_ac].* = g_lnh_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
          LET l_ac_t = l_ac                # 新增
                    
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lnh[l_ac].* = g_lnh_t.*
             #FUN-AB0096 add ------------begin--------------------
             CALL cl_set_comp_entry("lnhstore",FALSE)
             #FUN-AB0096 add -------------end---------------------   
             END IF
             CLOSE i3003_bcl            # 新增
             ROLLBACK WORK              # 新增
             EXIT INPUT
          END IF
           
          CLOSE i3003_bcl            # 新增
          COMMIT WORK
       #IF g_argv3 = 'c' THEN 
       #  IF l_ac = g_rec_b THEN
       #      RETURN    
       #  END IF 
       #END IF   
             
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lnhstore) AND l_ac > 1 THEN
             LET g_lnh[l_ac].* = g_lnh[l_ac-1].*
             NEXT FIELD lnhstore
          END IF 
  
       ON ACTION controlp                                                    
         CASE                                                                             
           WHEN INFIELD(lnhstore)                                                             
             CALL cl_init_qry_var()                                 
             LET g_qryparam.form = "q_rtz11"                                                       
             LET g_qryparam.where = " rtz01 IN ",g_auth," "  #No.FUN-A10060 
             LET g_qryparam.default1 = g_lnh[l_ac].lnhstore         
             CALL cl_create_qry() RETURNING g_lnh[l_ac].lnhstore                      
             DISPLAY g_lnh[l_ac].lnhstore TO lnhstore                                             
             NEXT FIELD lnhstore   
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
 
   CLOSE i3003_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i3003_b_askkey()
 
   CLEAR FORM
   CALL g_lnh.clear()
      CONSTRUCT g_wc2 ON lnhstore,lnhlegal,lnh04,lnh05,lnh06,lnh07  
                 FROM s_lnh[1].lnhstore,s_lnh[1].lnhlegal,
                      s_lnh[1].lnh04,s_lnh[1].lnh05,s_lnh[1].lnh06,
                      s_lnh[1].lnh07
                 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
      ON ACTION controlp 
         CASE
           WHEN INFIELD(lnhstore)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_lnhstore"
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_argv2
              LET g_qryparam.arg2 = '0'                           #FUN-AB0096 add
              LET g_qryparam.where = " lnhstore IN ",g_auth," "   #FUN-AB0096 add
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO lnhstore
              NEXT FIELD lnhstore         
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_rec_b = 0
      LET g_wc2 = NULL
      RETURN 
   END IF
 
   CALL i3003_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i3003_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000  
 DEFINE   l_rtz13         LIKE rtz_file.rtz13   
 
    LET g_sql ="SELECT lnhstore,'',lnhlegal,'',lnh04,lnh05,lnh06,lnh07",   
               " FROM lnh_file ",
               " WHERE ", p_wc2 CLIPPED,  
               " and lnh01 = '",g_argv2,"'",
               "  AND lnhstore IN ",g_auth," ",  #No.FUN-A10060
               " ORDER BY lnhstore"
    PREPARE i3003_pb FROM g_sql
    DECLARE lnh_curs CURSOR FOR i3003_pb
 
    CALL g_lnh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lnh_curs INTO g_lnh[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT rtz13 INTO l_rtz13 FROM rtz_file
         WHERE rtz01      = g_lnh[g_cnt].lnhstore
        LET g_lnh[g_cnt].rtz13 = l_rtz13   
                        
        SELECT azt02 INTO g_lnh[g_cnt].azt02 FROM azt_file
           WHERE azt01 = g_lnh[g_cnt].lnhlegal
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i3003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lnh TO s_lnh.* ATTRIBUTE(COUNT=g_rec_b)
 
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
    
      ON ACTION body
         LET g_action_choice = "body"
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
                                            
FUNCTION i3003_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lnhstore",TRUE)                                  
   END IF                                                                       
                                                                                
END FUNCTION   
 
FUNCTION i3003_arg(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'c' THEN
     CALL cl_set_comp_entry("lnh06",TRUE)  
     CALL cl_set_comp_entry("lnhstore,lnh04,lnh05",FALSE)
   ELSE
     CALL cl_set_comp_entry("lnh06",FALSE)
     CALL cl_set_comp_entry("lnhstore,lnh04,lnh05",TRUE)
   END IF                                                                       
                                                                                
END FUNCTION                                                                   
                                                                                
FUNCTION i3003_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lnhstore",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 
