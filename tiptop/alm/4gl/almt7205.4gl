# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: almt7205.4gl
# Descriptions...: 維護折扣規則維護作業
# Date & Author..: NO:FUN-870010 08/11/13 By lilingyu 
# Modify.........: No:FUN-960134 09/07/20 By shiwuying 市場移植
# Modify.........: No:FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No:FUN-9C0101 09/12/29 By shiwuying FETCH報錯位置錯誤
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A90049 10/09/27 By shaoyong 全部抓取lmu_file 需調整改為 ima_file 且料件性質='2.商戶料號'
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lsx           DYNAMIC ARRAY OF RECORD    
         lsx03       LIKE lsx_file.lsx03,
         lsx04       LIKE lsx_file.lsx04,
         lsx05       LIKE lsx_file.lsx05,
         lsx06       LIKE lsx_file.lsx06,
         ima02       LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         ima128       LIKE ima_file.ima128
                    END RECORD,
     g_lsx_t        RECORD    
         lsx03       LIKE lsx_file.lsx03,
         lsx04       LIKE lsx_file.lsx04,
         lsx05       LIKE lsx_file.lsx05,
         lsx06       LIKE lsx_file.lsx06,
         ima02       LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         ima128       LIKE ima_file.ima128
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5 
    
DEFINE g_argv1               LIKE lsx_file.lsx01
DEFINE g_argv2               LIKE lsx_file.lsx02
 
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
   
    OPEN WINDOW t7205_w WITH FORM "alm/42f/almt7205" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()     
   
    LET g_argv1 = ARG_VAL(1) 
    LET g_argv2 = ARG_VAL(2) 
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = " lsx01 = '",g_argv1,"'  and lsx02 = '",g_argv2,"'"     
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL t7205_b_fill(g_wc2)
    
    CALL t7205_menu()
    CLOSE WINDOW t7205_w    
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t7205_menu()
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t7205_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t7205_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t7205_b()
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
               IF g_lsx[l_ac].lsx03 IS NOT NULL THEN
                  LET g_doc.column1 = "lsx03"
                  LET g_doc.value1 = g_lsx[l_ac].lsx03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lsx),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t7205_q()
   CALL t7205_askkey()
END FUNCTION
 
FUNCTION t7205_b()
DEFINE
       l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5, 
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1           
DEFINE l_lqg07         LIKE lqg_file.lqg07
DEFINE l_lqgacti       LIKE lqg_file.lqgacti
DEFINE l_count         LIKE type_file.num5
DEFINE l_ima02         LIKE ima_file.ima02
DEFINE l_ima021         LIKE ima_file.ima021
DEFINE l_ima128         LIKE ima_file.ima128
DEFINE l_imaacti         LIKE ima_file.imaacti
 
   IF s_shut(0) THEN RETURN END IF
   
    SELECT lqg07,lqgacti INTO l_lqg07,l_lqgacti FROM lqg_file
     WHERE lqg01 = g_argv1
       AND lqg02 = g_argv2
   IF (l_lqg07 = 'Y' OR l_lqg07 = 'X' OR l_lqg07 = 'S') THEN 
      CALL cl_err('','alm-256',1)
      LET g_action_choice = NULL
      RETURN       
   END IF   
   IF l_lqgacti = 'N' THEN       
      CALL cl_err('','alm-150',0)
      LET g_action_choice = NULL
      RETURN        
   END IF 
    
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lsx03,lsx04,lsx05,lsx06,'','',''", 
                      "  FROM lsx_file WHERE  " ,
                      "   lsx01= '",g_argv1,"' " ,
                      "   and lsx02 = '",g_argv2,"'",
                      "   and lsx03 = ? " ,
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t7205_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lsx WITHOUT DEFAULTS FROM s_lsx.*
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
             CALL t7205_set_entry(p_cmd)                                         
             CALL t7205_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lsx_t.* = g_lsx[l_ac].*  
             OPEN t7205_bcl USING g_lsx_t.lsx03
             IF STATUS THEN
                CALL cl_err("OPEN t7205_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t7205_bcl INTO g_lsx[l_ac].* 
             #No.FUN-9C0101 BEGIN -----
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lsx_t.lsx03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             #No.FUN-9C0101 END -------
                ###################################
                 SELECT ima02,ima021,ima128 INTO l_ima02,l_ima021,l_ima128
                   FROM ima_file
                  WHERE ima01 = g_lsx[l_ac].lsx06
                    AND imaacti = 'Y'
                 LET g_lsx[l_ac].ima02 = l_ima02
                 LET g_lsx[l_ac].ima021 = l_ima021
                 LET g_lsx[l_ac].ima128 = l_ima128  
             #No.FUN-9C0101 BEGIN -----
             #   DISPLAY g_lsx[l_ac].ima02 TO FORMONLY.ima02
             #   DISPLAY g_lsx[l_ac].ima021 TO FORMONLY.ima021
             #   DISPLAY g_lsx[l_ac].ima128 TO FORMONLY.ima128  
             #  ######################################             
             #  IF SQLCA.sqlcode THEN
             #     CALL cl_err(g_lsx_t.lsx03,SQLCA.sqlcode,1)
             #     LET l_lock_sw = "Y"
             #  END IF
                DISPLAY BY NAME g_lsx[l_ac].ima02,g_lsx[l_ac].ima021,
                                g_lsx[l_ac].ima128
             #No.FUN-9C0101 END -------
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL t7205_set_entry(p_cmd)                                            
          CALL t7205_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lsx[l_ac].* TO NULL    
          LET g_lsx_t.* = g_lsx[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lsx03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t7205_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lsx_file(lsx01,lsx02,lsx03,lsx04,lsx05,lsx06)
          VALUES(g_argv1,g_argv2,g_lsx[l_ac].lsx03,g_lsx[l_ac].lsx04,
                 g_lsx[l_ac].lsx05,g_lsx[l_ac].lsx06)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lsx_file",g_lsx[l_ac].lsx03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cnt  
             COMMIT WORK
          END IF
 
       BEFORE FIELD lsx03 
        IF cl_null(g_lsx[l_ac].lsx03) OR cl_null(g_lsx_t.lsx03) THEN     
           SELECT max(lsx03)+1 INTO l_count FROM lsx_file      
            WHERE lsx01 = g_argv1 
              AND lsx02 = g_argv2  
            LET g_lsx[l_ac].lsx03 = l_count
            IF cl_null(g_lsx[l_ac].lsx03) OR g_lsx[l_ac].lsx03 <= 0 THEN 
               LET g_lsx[l_ac].lsx03 = 1 
            END IF      
        END IF   
        
        AFTER FIELD lsx03         
           IF NOT cl_null(g_lsx[l_ac].lsx03) THEN
              IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lsx[l_ac].lsx03 != g_lsx_t.lsx03) THEN
                 LET l_n = 0 
                 SELECT COUNT(*) INTO l_n FROM lsx_file
                  WHERE lsx03 = g_lsx[l_ac].lsx03 
                    AND lsx01 = g_argv1 
                  IF l_n>0 THEN 
                     CALL cl_err('','-239',1)
                     LET g_lsx[l_ac].lsx03=g_lsx_t.lsx03
                    NEXT FIELD lsx03
                  END IF 
              END IF   
           END IF                  
  
      AFTER FIELD lsx04
          IF NOT cl_null(g_lsx[l_ac].lsx04) THEN
             IF g_lsx[l_ac].lsx04 < 0 THEN 
                CALL cl_err('','alm-258',1)
                NEXT FIELD lsx04 
             END IF 
             IF g_lsx[l_ac].lsx04 > g_lsx[l_ac].lsx05 THEN 
                CALL cl_err('','alm-259',1)
                NEXT FIELD lsx04 
             END IF 
          END IF
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lsx_file
              WHERE lsx01 = g_argv1
                AND lsx02 = g_argv2
                AND lsx03 != g_lsx[l_ac].lsx03
                AND ((g_lsx[l_ac].lsx04 >= lsx04 AND g_lsx[l_ac].lsx04 <= lsx05)
                    OR (g_lsx[l_ac].lsx04 <= lsx04 AND g_lsx[l_ac].lsx05 >= lsx05)
                    OR (g_lsx[l_ac].lsx04 <= lsx04 AND g_lsx[l_ac].lsx05 >= lsx04))
               IF l_n > 0 THEN
                  CALL cl_err('','alm-401',1)
                  NEXT FIELD lsx04 
               END IF           
              
        AFTER FIELD lsx05
          IF NOT cl_null(g_lsx[l_ac].lsx05) THEN
             IF g_lsx[l_ac].lsx05 < 0 THEN 
                CALL cl_err('','alm-258',1)
                NEXT FIELD lsx05 
             END IF 
             IF g_lsx[l_ac].lsx05 < g_lsx[l_ac].lsx04 THEN 
                CALL cl_err('','alm-400',1)
                NEXT FIELD lsx05 
             END IF 
          END IF          
             LET l_n = 0 
             SELECT COUNT(*) INTO l_n FROM lsx_file
              WHERE lsx01 = g_argv1
                AND lsx02 = g_argv2
                AND lsx03 != g_lsx[l_ac].lsx03
                AND ((g_lsx[l_ac].lsx05 >= lsx04 AND g_lsx[l_ac].lsx05 <=  lsx05)
                     OR (g_lsx[l_ac].lsx04 <= lsx04 AND g_lsx[l_ac].lsx05 >= lsx05)
                     OR (g_lsx[l_ac].lsx04 <= lsx04 AND g_lsx[l_ac].lsx05 >= lsx04))
              IF l_n > 0 THEN
                 CALL cl_err('','alm-401',1)
                 NEXT FIELD lsx05 
              END IF   
     
     AFTER FIELD lsx06
        IF NOT cl_null(g_lsx[l_ac].lsx06) THEN 
           LET l_n = 0 
           SELECT COUNT(*) INTO l_n FROM ima_file
            WHERE ima01 = g_lsx[l_ac].lsx06
            IF l_n < 1 THEN 
               CALL cl_err('','alm-622',1)
               NEXT FIELD lsx06
            ELSE
               SELECT imaacti INTO l_imaacti FROM ima_file 
                WHERE ima01 = g_lsx[l_ac].lsx06
               IF l_imaacti = 'N' OR cl_null(l_imaacti) THEN 
                  CALL cl_err('','alm-623',1)
                  NEXT FIELD lsx06 
                ELSE
                	 SELECT ima02,ima021,ima128 INTO l_ima02,l_ima021,l_ima128 FROM ima_file
                	  WHERE ima01 = g_lsx[l_ac].lsx06
                	    AND imaacti = 'Y'
                	 LET g_lsx[l_ac].ima02 = l_ima02
                   LET g_lsx[l_ac].ima021 = l_ima021
                   LET g_lsx[l_ac].ima128 = l_ima128  
                   DISPLAY g_lsx[l_ac].ima02 TO FORMONLY.ima02
                   DISPLAY g_lsx[l_ac].ima021 TO FORMONLY.ima021
                   DISPLAY g_lsx[l_ac].ima128 TO FORMONLY.ima128    
                END IF  	   
            END IF   	   
        ELSE
        	DISPLAY '' TO FORMONLY.ima02
        	DISPLAY '' TO FORMONLY.ima021
        	DISPLAY '' TO FORMONLY.ima128
        END IF  	
      	
     
       BEFORE DELETE                           
          IF g_lsx_t.lsx03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lsx03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lsx[l_ac].lsx03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lsx_file WHERE lsx01 = g_argv1
                                    AND lsx02 = g_argv2
                                    AND lsx03 = g_lsx_t.lsx03
                                                                                                         
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lsx_file",g_lsx_t.lsx03,"",SQLCA.sqlcode,"","",1)  
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
             LET g_lsx[l_ac].* = g_lsx_t.*
             CLOSE t7205_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lsx[l_ac].lsx03,-263,0)
             LET g_lsx[l_ac].* = g_lsx_t.*
          ELSE
             UPDATE lsx_file SET lsx04 = g_lsx[l_ac].lsx04,
                                 lsx05 = g_lsx[l_ac].lsx05,
                                 lsx06 = g_lsx[l_ac].lsx06
              WHERE lsx03 = g_lsx_t.lsx03
                AND lsx01 = g_argv1
                AND lsx02 = g_argv2
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lsx_file",g_lsx_t.lsx03,"",SQLCA.sqlcode,"","",1)  
                LET g_lsx[l_ac].* = g_lsx_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
         #LET l_ac_t = l_ac                # 新增  #FUN-D30033 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lsx[l_ac].* = g_lsx_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lsx.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE t7205_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac          #FUN-D30033 Add
          CLOSE t7205_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lsx03) AND l_ac > 1 THEN
             LET g_lsx[l_ac].* = g_lsx[l_ac-1].*
             NEXT FIELD lsx03
          END IF  
     
       ON ACTION controlp 
          CASE
             WHEN INFIELD(lsx06)
                 CALL cl_init_qry_var()                                        
                 LET g_qryparam.form ="q_ima31"                                            
                 LET g_qryparam.default1 = g_lsx[l_ac].lsx06                         
                 CALL cl_create_qry() RETURNING g_lsx[l_ac].lsx06                          
                 DISPLAY g_lsx[l_ac].lsx06 TO lsx06                                        
                 NEXT FIELD lsx06
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
 
   CLOSE t7205_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t7205_askkey()
 
   CLEAR FORM
   CALL g_lsx.clear()
       CONSTRUCT g_wc2 ON lsx03,lsx04,lsx05,lsx06
                     FROM s_lsx[1].lsx03,s_lsx[1].lsx04,
                          s_lsx[1].lsx05,s_lsx[1].lsx06
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
                 
      ON ACTION controlp 
         CASE 
             WHEN INFIELD(lsx06)
              CALL cl_init_qry_var()                                                 
              LET g_qryparam.form ="q_lsx06"                                
              LET g_qryparam.state='c'                                            
              CALL cl_create_qry() RETURNING g_qryparam.multiret                  
              DISPLAY g_qryparam.multiret TO lsx06                                 
              NEXT FIELD lsx06      
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
 
   CALL t7205_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t7205_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 DEFINE   l_ima02         LIKE ima_file.ima02
 DEFINE   l_ima021         LIKE ima_file.ima021
 DEFINE   l_ima128         LIKE ima_file.ima128
  
    LET g_sql ="SELECT lsx03,lsx04,lsx05,lsx06,'','','' ",   
               " FROM lsx_file ",
               " WHERE ", p_wc2 CLIPPED,                   
               " and lsx01 = '",g_argv1,"'",
               " and lsx02 = '",g_argv2,"'",
               " ORDER BY lsx03"
    PREPARE t7205_pb FROM g_sql
    DECLARE lsx_curs CURSOR FOR t7205_pb
 
    CALL g_lsx.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lsx_curs INTO g_lsx[g_cnt].*   
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF       
        SELECT ima02,ima021,ima128 INTO l_ima02,l_ima021,l_ima128
          FROM ima_file
         WHERE ima01 = g_lsx[g_cnt].lsx06
           AND imaacti = 'Y'
         LET g_lsx[g_cnt].ima02 = l_ima02
         LET g_lsx[g_cnt].ima021 = l_ima021
         LET g_lsx[g_cnt].ima128 = l_ima128  
        DISPLAY g_lsx[g_cnt].ima02 TO FORMONLY.ima02
        DISPLAY g_lsx[g_cnt].ima021 TO FORMONLY.ima021
        DISPLAY g_lsx[g_cnt].ima128 TO FORMONLY.ima128  
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lsx.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t7205_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lsx TO s_lsx.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION t7205_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lsx03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t7205_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lsx03",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
#No.FUN-960134
#No.FUN-A90049
