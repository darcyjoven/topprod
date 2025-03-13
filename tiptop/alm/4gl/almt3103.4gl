# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: almt3103.4gl
# Descriptions...: 正式商戶狀態信息維護作業
# Date & Author..: NO.FUN-870010 08/07/31 By lilingyu 
# Modify.........: No.FUN-960134 09/07/15 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位 
# Modify.........: NO:FUN-AB0096 10/11/24 By wangxin 將程式中, luhplant 改成 luhstore. 並修正 luhstore 的開窗錯誤, 及資料新增的邏輯 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_luh           DYNAMIC ARRAY OF RECORD    
         luhstore       LIKE luh_file.luhstore,
         rtz13       LIKE rtz_file.rtz13,          #FUN-A80148 
         luhlegal    LIKE luh_file.luhlegal,
         azt02       LIKE azt_file.azt02,
         luh04       LIKE luh_file.luh04,
         luh05       LIKE luh_file.luh05,
         luh06       LIKE luh_file.luh06,
         luh07       LIKE luh_file.luh07       
                    END RECORD,
     g_luh_t        RECORD    
         luhstore       LIKE luh_file.luhstore,
         rtz13       LIKE rtz_file.rtz13,    #FUN-A80148
         luhlegal    LIKE luh_file.luhlegal,
         azt02       LIKE azt_file.azt02,
         luh04       LIKE luh_file.luh04,
         luh05       LIKE luh_file.luh05,
         luh06       LIKE luh_file.luh06,
         luh07       LIKE luh_file.luh07    
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE luh_file.luh00
DEFINE g_argv2               LIKE lue_file.lue01
DEFINE g_argv3               LIKE lue_file.lue02
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW t3103_w WITH FORM "alm/42f/almt3103" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()    
 
     IF NOT cl_null(g_argv2) AND NOT cl_null(g_argv3) THEN
       LET g_wc2 = " luh01 = '",g_argv2,"'  and luh02 = '",g_argv3,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL t3103_b_fill(g_wc2)
    
    CALL t3103_menu()
    CLOSE WINDOW t3103_w
 
    CALL cl_used(g_prog,g_time,2)RETURNING g_time    
END MAIN
 
FUNCTION t3103_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t3103_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t3103_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t3103_b('')
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "body"
             IF cl_chk_act_auth() THEN 
               IF g_rec_b = 0 THEN
                   CALL cl_err('','alm-414',1)
                   CONTINUE WHILE
                ELSE
                   CALL t3103_b('c')
                END IF
             END IF   
         
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_luh[l_ac].luhstore IS NOT NULL THEN
                  LET g_doc.column1 = "luhstore"
                  LET g_doc.value1 = g_luh[l_ac].luhstore
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_luh),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t3103_q()
   CALL t3103_b_askkey()
END FUNCTION
 
FUNCTION t3103_b(w_cmd)
DEFINE l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5,    
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       w_cmd           LIKE type_file.chr1,
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1        
DEFINE l_lue36         LIKE lue_file.lue36
DEFINE l_rtz28         LIKE rtz_file.rtz28
DEFINE l_rtz13         LIKE rtz_file.rtz13
 
   IF s_shut(0) THEN RETURN END IF
 
   SELECT lue36 INTO l_lue36 FROM lue_file
     WHERE lue01 = g_argv2
      AND lue02  = g_argv3
   IF (l_lue36 = 'Y' OR l_lue36 = 'X') THEN 
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
 
   LET g_forupd_sql = "SELECT luhstore,'',luhlegal,'',luh04,luh05,luh06,luh07", 
                      "  FROM luh_file WHERE  ",
                      "  luh01= '",g_argv2,"' and luh02 = '",g_argv3,"' and luhstore = ?  ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t3103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_luh WITHOUT DEFAULTS FROM s_luh.*
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
          LET g_luh[l_ac].luh06 = 'N'
           
          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL t3103_set_entry(p_cmd) 
             CALL t3103_arg(w_cmd)
             CALL t3103_set_no_entry(p_cmd) 
        
             LET g_before_input_done = TRUE   
             LET g_luh_t.* = g_luh[l_ac].*  
             OPEN t3103_bcl USING g_luh_t.luhstore
             IF STATUS THEN
                CALL cl_err("OPEN t3103_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t3103_bcl INTO g_luh[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_luh_t.luhstore,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                ################################
                 SELECT rtz13 INTO l_rtz13 FROM rtz_file       #FUN-A80148
                  WHERE rtz01  = g_luh[l_ac].luhstore
                  LET g_luh[l_ac].rtz13 = l_rtz13   
                 SELECT azt02 INTO g_luh[l_ac].azt02 FROM azt_file
                  WHERE azt01 = g_luh[l_ac].luhlegal
                   DISPLAY BY NAME g_luh[l_ac].rtz13,g_luh[l_ac].azt02
               ########################           
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL t3103_set_entry(p_cmd)  
          CALL t3103_arg(w_cmd)
          CALL t3103_set_no_entry(p_cmd) 
 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_luh[l_ac].* TO NULL    
          LET g_luh_t.* = g_luh[l_ac].*     
          LET g_luh[l_ac].luh06 = 'N'  
          DISPLAY BY NAME g_luh[l_ac].luh06 
          #FUN-AB0096 add -------------begin----------------------
          LET g_luh[l_ac].luhstore = g_plant
          SELECT rtz13 INTO g_luh[l_ac].rtz13 FROM rtz_file
           WHERE rtz01 = g_luh[l_ac].luhstore  
           
          #SELECT luhlegal INTO g_luh[l_ac].luhlegal FROM luh_file   #FUN-AB0096 mark by wangxin
          # WHERE luhstore = g_luh[l_ac].luhstore                    #FUN-AB0096 mark by wangxin
          SELECT azw02 INTO g_luh[l_ac].luhlegal FROM azw_file       #FUN-AB0096 add by wangxin
           WHERE azw01 = g_luh[l_ac].luhstore                        #FUN-AB0096 add by wangxin
          SELECT azt02 INTO g_luh[l_ac].azt02 FROM azt_file
           WHERE azt01 = g_luh[l_ac].luhlegal 
          DISPLAY BY NAME g_luh[l_ac].luhstore,g_luh[l_ac].rtz13,
                          g_luh[l_ac].luhlegal,g_luh[l_ac].azt02  
          CALL cl_set_comp_entry("luhstore",FALSE)                              
          #FUN-AB0096 add --------------end-----------------------
          CALL cl_show_fld_cont()    
          #NEXT FIELD luhstore   #FUN-AB0096 mark 
          NEXT FIELD luh04       #FUN-AB0096 add 
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t3103_bcl
             CANCEL INSERT
          END IF
         INSERT INTO luh_file(luh00,luh01,luh02,luhstore,luh04,luh05,luh06,luh07,luhlegal)
              VALUES(g_argv1,g_argv2,g_argv3,g_luh[l_ac].luhstore,g_luh[l_ac].luh04,
                     g_luh[l_ac].luh05,g_luh[l_ac].luh06,g_luh[l_ac].luh07,g_luh[l_ac].luhlegal)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","luh_file",g_luh[l_ac].luhstore,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       AFTER FIELD luhstore                        
          IF NOT cl_null(g_luh[l_ac].luhstore) THEN 
             IF p_cmd = 'a' THEN 
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM rtz_file
               WHERE  rtz01 = g_luh[l_ac].luhstore
                IF l_n < 1 THEN 
                   CALL cl_err('','alm-077',0)
                   LET g_luh[l_ac].luhstore = g_luh_t.luhstore
                   DISPLAY BY NAME g_luh[l_ac].luhstore
                   NEXT FIELD luhstore 
                 ELSE
                   SELECT rtz28 INTO l_rtz28 FROM rtz_file
                    WHERE  rtz01 = g_luh[l_ac].luhstore
                     IF l_rtz28 != 'Y' THEN 
                        CALL cl_err('','alm-002',0)
                        LET g_luh[l_ac].luhstore = g_luh_t.luhstore
                        DISPLAY BY NAME g_luh[l_ac].luhstore
                        NEXT FIELD luhstore 
                     ELSE
                     	   LET l_n = 0 
                     	   SELECT COUNT(luhstore) INTO l_n FROM luh_file
                     	    WHERE  luh01 = g_argv2
                     	      AND  luh02 = g_argv3
                     	      AND  luhstore = g_luh[l_ac].luhstore
                     	    IF l_n > 0 THEN 
                     	       CALL cl_err('','alm-172',0)
                     	       NEXT FIELD luhstore
                     	    ELSE
                     	    	    
                     	   SELECT rtz13 INTO l_rtz13 FROM rtz_file
                          WHERE rtz01  = g_luh[l_ac].luhstore
                         SELECT azw02 INTO g_luh[l_ac].luhlegal FROM azw_file
                          WHERE azw01 = g_luh[l_ac].luhstore
                         SELECT azt02 INTO g_luh[l_ac].azt02 FROM azt_file
                          WHERE azt01 = g_luh[l_ac].luhlegal
                         LET g_luh[l_ac].rtz13 = l_rtz13
                         DISPLAY BY NAME g_luh[l_ac].rtz13,g_luh[l_ac].luhlegal,g_luh[l_ac].azt02
                         END IF 
                     END IF                     
                 END IF 	
               END IF       
          ELSE
             CALL cl_err('','alm-062',0)
             NEXT FIELD luhstore
          END IF
         
       AFTER FIELD luh04
          IF NOT cl_null(g_luh[l_ac].luh04) THEN 
             IF g_luh[l_ac].luh06 = 'N' THEN 
               LET g_luh[l_ac].luh07 = g_luh[l_ac].luh04
             END IF
          END IF 
     
      AFTER FIELD luh05
           IF NOT cl_null(g_luh[l_ac].luh05) THEN 
             IF g_luh[l_ac].luh06 = 'Y' THEN 
                LET  g_luh[l_ac].luh07 = g_luh[l_ac].luh05
             END IF
          END IF 
          
      AFTER FIELD luh06                                                                       
          IF g_luh[l_ac].luh06 = 'Y' THEN                                                     
              LET g_luh[l_ac].luh07 = g_luh[l_ac].luh05                                   
          ELSE                                                                               
              IF g_luh[l_ac].luh06 = 'N' THEN                               
                 LET g_luh[l_ac].luh07 = g_luh[l_ac].luh04                                 
              END IF                                                                                
          END IF          
     
       BEFORE DELETE                      
          IF g_luh_t.luhstore IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                   #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "luhstore"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_luh[l_ac].luhstore      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM luh_file WHERE luhstore = g_luh_t.luhstore
                                    AND luh01 = g_argv2
                                    AND luh02 = g_argv3
                                    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","luh_file",g_luh_t.luhstore,"",SQLCA.sqlcode,"","",1)  
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
             LET g_luh[l_ac].* = g_luh_t.*
             CLOSE t3103_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_luh[l_ac].luhstore,-263,0)
             LET g_luh[l_ac].* = g_luh_t.*
          ELSE
             UPDATE luh_file SET luhstore=g_luh[l_ac].luhstore,
                                 luhlegal=g_luh[l_ac].luhlegal,
                                 luh04=g_luh[l_ac].luh04,
                                 luh05=g_luh[l_ac].luh05,
                                 luh06=g_luh[l_ac].luh06,
                                 luh07=g_luh[l_ac].luh07
              WHERE luhstore = g_luh_t.luhstore
                AND luh01 = g_argv2
                AND luh02 = g_argv3
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","luh_file",g_luh_t.luhstore,"",SQLCA.sqlcode,"","",1)  
                LET g_luh[l_ac].* = g_luh_t.*
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
                LET g_luh[l_ac].* = g_luh_t.*
                #FUN-AB0096 add ------------begin--------------------
                CALL cl_set_comp_entry("luhstore",FALSE)
                #FUN-AB0096 add -------------end---------------------
             END IF
             CLOSE t3103_bcl            # 新增
             ROLLBACK WORK              # 新增
             EXIT INPUT
          END IF
 
          CLOSE t3103_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(luhstore) AND l_ac > 1 THEN
             LET g_luh[l_ac].* = g_luh[l_ac-1].*
             NEXT FIELD luhstore
          END IF 
  
       ON ACTION controlp                                                              
         CASE                                                                                
           WHEN INFIELD(luhstore)                                                                        
             CALL cl_init_qry_var()                                            
             LET g_qryparam.form = "q_rtz"                                                                      
             LET g_qryparam.default1 = g_luh[l_ac].luhstore                          
             LET g_qryparam.where = " rtz01 IN ",g_auth," "  #No.FUN-A10060
             CALL cl_create_qry() RETURNING g_luh[l_ac].luhstore                           
             DISPLAY g_luh[l_ac].luhstore TO luhstore                                                    
             NEXT FIELD luhstore   
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
 
   CLOSE t3103_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t3103_b_askkey()
 
   CLEAR FORM
   CALL g_luh.clear()     
      CONSTRUCT g_wc2 ON luhstore,luhlegal,luh04,luh05,luh06,luh07  
                 FROM s_luh[1].luhstore,s_luh[1].luhlegal,
                      s_luh[1].luh04,s_luh[1].luh05,s_luh[1].luh06,
                      s_luh[1].luh07
                 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
      ON ACTION controlp 
         CASE
           WHEN INFIELD(luhstore)
              CALL cl_init_qry_var()
              #LET g_qryparam.form = "q_lnhstore"       #FUN-AB0096 mark
              LET g_qryparam.form = "q_luhstore"        #FUN-AB0096 add
              LET g_qryparam.state = "c"
              LET g_qryparam.arg1 = g_argv2
              LET g_qryparam.arg2 = g_argv3
              LET g_qryparam.where = " luhstore IN ",g_auth," "  #No.FUN-A10060
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO luhstore
              NEXT FIELD luhstore         
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
      LET g_wc2 = NULL
      LET g_rec_b= 0 
      RETURN 
   END IF
   CALL t3103_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t3103_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000  
 DEFINE   l_rtz13         LIKE rtz_file.rtz13   
 DEFINE   l_n             LIKE type_file.num5 
 
  SELECT COUNT(*) INTO l_n FROM luh_file
   WHERE luh01 = g_argv2
     AND luh02 = g_argv3
     AND luhstore IS NOT NULL 
     
  IF l_n > 0 THEN    
    LET g_sql ="SELECT luhstore,'',luhlegal,'',luh04,luh05,luh06,luh07",   
               " FROM luh_file ",
               " WHERE ", p_wc2 CLIPPED,        
               " and luh01 = '",g_argv2,"'",
               " and luh02 = '",g_argv3,"'",
               " AND luhstore IN ",g_auth," ",  #No.FUN-A10060
               " ORDER BY luhstore"
    PREPARE t3103_pb FROM g_sql
    DECLARE luh_curs CURSOR FOR t3103_pb
 
    CALL g_luh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH luh_curs INTO g_luh[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT rtz13 INTO l_rtz13 FROM rtz_file
          WHERE rtz01  = g_luh[g_cnt].luhstore
        LET g_luh[g_cnt].rtz13 = l_rtz13   
        DISPLAY BY NAME g_luh[g_cnt].rtz13
                        
        SELECT azt02 INTO g_luh[g_cnt].azt02 FROM azt_file
         WHERE azt01 = g_luh[g_cnt].luhlegal
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_luh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
ELSE
	  LET g_sql ="SELECT lnhstore,'',lnhlegal,'',lnh04,lnh05,lnh06,lnh07",   
               " FROM lnh_file ",
               " WHERE lnh01 = '",g_argv2,"'",
               " and lnhstore is not NULL",
               " ORDER BY lnhstore"
    PREPARE t3103_pb_1 FROM g_sql
    DECLARE luh_curs_1 CURSOR FOR t3103_pb_1
 
    CALL g_luh.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH luh_curs_1 INTO g_luh[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT rtz13 INTO l_rtz13 FROM rtz_file
           WHERE rtz01      = g_luh[g_cnt].luhstore
          LET g_luh[g_cnt].rtz13 = l_rtz13   
        DISPLAY BY NAME g_luh[g_cnt].rtz13
 
        SELECT azt02 INTO g_luh[g_cnt].azt02 FROM azt_file
         WHERE azt01 = g_luh[g_cnt].luhlegal
       ########################
       INSERT INTO luh_file(luh00,luh01,luh02,luhstore,luh04,luh05,luh06,luh07,luhlegal)
           VALUES(g_argv1,g_argv2,g_argv3,g_luh[g_cnt].luhstore,g_luh[g_cnt].luh04,
                 g_luh[g_cnt].luh05,g_luh[g_cnt].luh06,g_luh[g_cnt].luh07,g_luh[g_cnt].luhlegal)
       ##################
                        
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_luh.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
END IF 	
END FUNCTION
 
FUNCTION t3103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_luh TO s_luh.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION t3103_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("luhstore",TRUE)                                  
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                         
FUNCTION t3103_arg(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
 
   IF p_cmd = 'c' THEN
     CALL cl_set_comp_entry("luh06",TRUE)  
     CALL cl_set_comp_entry("luhstore,luh04,luh05",FALSE)
   ELSE
      CALL cl_set_comp_entry("luh06",FALSE)
      CALL cl_set_comp_entry("luhstore,luh04,luh05",TRUE)
   END IF                                                                       
                                                                                
END FUNCTION 
                                                                                
FUNCTION t3103_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("luhstore",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134      
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 
 
 
 
