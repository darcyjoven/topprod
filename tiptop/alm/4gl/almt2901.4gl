# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: almt2901.4gl
# Descriptions...: 品牌資料維護作業
# Date & Author..: NO.FUN-870010 08/07/25 By lilingyu 
# Modify.........: No.FUN-960134 09/07/09 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A70063 10/07/13 By chenying azf02 = '3' 抓取品牌代碼改抓 tqa_file.tqa03 = '2';
#                                                     欄位 azf01 改抓 tqa01, 欄位 azf03 改抓 tqa02
# Modify.........: No:FUN-A70063 10/07/13 By chenying q_azfp2替換成q_tqap2

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lnc           DYNAMIC ARRAY OF RECORD    
         lnc02       LIKE lnc_file.lnc02,
#        azf03       LIKE azf_file.azf03,   #FUN-A70063 del
         tqa02       LIKE tqa_file.tqa02,   #FUN-A70063 add
         lnc03       LIKE lnc_file.lnc03,
         geo02       LIKE geo_file.geo02
                    END RECORD,
     g_lnc_t        RECORD    
         lnc02       LIKE lnc_file.lnc02,
#        azf03       LIKE azf_file.azf03,   #FUN-A70063 del
         tqa02       LIKE tqa_file.tqa02,   #FUN-A70063 add
         lnc03       LIKE lnc_file.lnc03,
         geo02       LIKE geo_file.geo02
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE g_argv1               LIKE lnc_file.lnc00
DEFINE g_argv2               LIKE lnc_file.lnc01
DEFINE g_lnc01               LIKE lnc_file.lnc01
 
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
   
    OPEN WINDOW t2901_w WITH FORM "alm/42f/almt2901" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()     
   
    LET g_argv1 = ARG_VAL(1)  
    LET g_argv2 = ARG_VAL(2)
    LET g_lnc01 = NULL
    LET g_lnc01 = g_argv2
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = "lnc01 = '",g_argv2,"' "     
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL t2901_b_fill(g_wc2)
    
    CALL t2901_menu()
    CLOSE WINDOW t2901_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t2901_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t2901_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL t2901_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t2901_b()
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
               IF g_lnc[l_ac].lnc02 IS NOT NULL THEN
                  LET g_doc.column1 = "lnc02"
                  LET g_doc.value1 = g_lnc[l_ac].lnc02
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t2901_q()
   CALL t2901_askkey()
END FUNCTION
 
FUNCTION t2901_b()
DEFINE
   l_ac_t          LIKE type_file.num5,           
   l_n             LIKE type_file.num5, 
   l_lock_sw       LIKE type_file.chr1,          
   p_cmd           LIKE type_file.chr1,         
   l_allow_insert  LIKE type_file.chr1,         
   l_allow_delete  LIKE type_file.chr1           
DEFINE l_lnb33     LIKE lnb_file.lnb33
#DEFINE l_lnbacti   LIKE lnb_file.lnbacti
#DEFINE l_azf02     LIKE azf_file.azf02      #FUN-A70063 del
#DEFINE l_azf03     LIKE azf_file.azf03      #FUN-A70063
#DEFINE l_azfacti   LIKE azf_file.azfacti    #FUN-A70063 del 
DEFINE l_geo02     LIKE geo_file.geo02
DEFINE l_geoacti   LIKE geo_file.geoacti
DEFINE l_tqa02     LIKE tqa_file.tqa02       #FUN-A70063
DEFINE l_tqa03     LIKE tqa_file.tqa03       #FUN-A70063
DEFINE l_tqaacti   LIKE tqa_file.tqaacti     #FUN-A70063
 
   IF s_shut(0) THEN RETURN END IF
   
    SELECT lnb33 INTO l_lnb33 FROM lnb_file
     WHERE lnb01 = g_argv2
   IF (l_lnb33 = 'Y' OR l_lnb33 = 'X') THEN 
      CALL cl_err('','alm-148',0)
      LET g_action_choice = NULL
      RETURN    
   END IF   
    
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lnc02,'',lnc03,''", 
                      "  FROM lnc_file WHERE  ",
                      "       lnc01= '",g_argv2,"' and lnc02 = ? ",
                      "   FOR UPDATE "
                 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t2901_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lnc WITHOUT DEFAULTS FROM s_lnc.*
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
             CALL t2901_set_entry(p_cmd)                                         
             CALL t2901_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lnc_t.* = g_lnc[l_ac].*  
             OPEN t2901_bcl USING g_lnc_t.lnc02
             IF STATUS THEN
                CALL cl_err("OPEN t2901_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t2901_bcl INTO g_lnc[l_ac].* 
                ######################

#FUN-A70063--begin--
#              SELECT azf03 INTO l_azf03 FROM azf_file
#               WHERE azf01 = g_lnc[l_ac].lnc02
#                 AND azf02 = '3'
#                 AND azfacti = 'Y'
#                LET g_lnc[l_ac].azf03 = l_azf03
#FUN-A70063--end--

#FUN-A70063--begin--
               SELECT tqa02 INTO l_tqa02 FROM tqa_file 
                WHERE tqa03 = '2' 
                  AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
                      OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
                  AND tqa01 = g_lnc[l_ac].lnc02
                  AND tqaacti = 'Y'
               LET g_lnc[l_ac].tqa02 = l_tqa02
#FUN-A70063--end--

#                DISPLAY BY NAME  g_lnc[l_ac].azf03      #FUN-A70063 del
                 DISPLAY BY NAME  g_lnc[l_ac].tqa02
           
                 SELECT geo02 INTO l_geo02 FROM geo_file
                  WHERE geo01 = g_lnc[l_ac].lnc03
                    AND geoacti  = 'Y'
                    LET g_lnc[l_ac].geo02 = l_geo02
                 DISPLAY BY NAME g_lnc[l_ac].geo02
                ############################
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lnc_t.lnc02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL t2901_set_entry(p_cmd)                                            
          CALL t2901_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lnc[l_ac].* TO NULL    
          LET g_lnc_t.* = g_lnc[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lnc02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t2901_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lnc_file(lnc00,lnc01,lnc02,lnc03)
           VALUES(g_argv1,g_argv2,g_lnc[l_ac].lnc02,g_lnc[l_ac].lnc03)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lnc_file",g_lnc[l_ac].lnc02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx  
             COMMIT WORK
          END IF
 
       AFTER FIELD lnc02                        
          IF NOT cl_null(g_lnc[l_ac].lnc02) THEN
             IF g_lnc[l_ac].lnc02 != g_lnc_t.lnc02 OR
                g_lnc_t.lnc02 IS NULL THEN
                LET l_n = 0

#FUN-A70063--begin--
#               SELECT count(*) INTO l_n FROM azf_file
#                WHERE azf01 = g_lnc[l_ac].lnc02
#                  AND azf02 = '3'

                SELECT count(*) INTO l_n FROM tqa_file 
                 WHERE tqa03 = '2'
                   AND tqa01 = g_lnc[l_ac].lnc02
#FUN-A70063--end--

                IF l_n < 1 THEN
#                  CALL cl_err('','alm-121',0)      #FUN-70063 mark
                   CALL cl_err('','alm1002',0)      #FUN-70063
                   LET g_lnc[l_ac].lnc02 = g_lnc_t.lnc02
                   NEXT FIELD lnc02
                ELSE
                       
#FUN-A70063--begin--
#                   	 SELECT azfacti INTO l_azfacti FROM azf_file
#                   	  WHERE azf01 = g_lnc[l_ac].lnc02
#                           AND azf02 = '3'
                      SELECT count(*) INTO l_n FROM tqa_file
                         WHERE tqa03 = '2' AND tqa01 = g_lnc[l_ac].lnc02
                           AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                                OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                         IF l_n < 1 THEN
                            CALL cl_err('','alm1004',0)
                            LET g_lnc[l_ac].lnc02 = g_lnc_t.lnc02
                            NEXT FIELD lnc02
                         ELSE

                         SELECT tqaacti INTO l_tqaacti FROM tqa_file 
                          WHERE tqa03 = '2'
                            AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                                OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
                            AND tqa01 = g_lnc[l_ac].lnc02
#FUN-A70063--end--

#                   	  IF l_azfacti != 'Y' THEN                #FUN-A70063
                          IF l_tqaacti != 'Y' THEN                #FUN-A70063
                    	     CALL cl_err('','alm-139',0)        
                    	     LET g_lnc[l_ac].lnc02 = g_lnc_t.lnc02
                           NEXT FIELD lnc02   
                    	  ELSE
                    	  	  LET l_n = 0
                        	  SELECT COUNT(*) INTO l_n FROM lnc_file
                        	    WHERE lnc01 = g_argv2
                     	         AND lnc02 = g_lnc[l_ac].lnc02
                         	   IF l_n > 0 THEN 
                        	      CALL cl_err('','alm-167',0)
                     	          LET g_lnc[l_ac].lnc02 = g_lnc_t.lnc02
                     	          NEXT FIELD lnc02                     	      
                        	   ELSE 	
 
#FUN-A70063--begin--
#                   	      	 SELECT azf03 INTO l_azf03 FROM azf_file
#                   	  	     WHERE azf01 = g_lnc[l_ac].lnc02                    	  
#                                   AND azf02 = '3'
#                   	  	     LET g_lnc[l_ac].azf03 = l_azf03
#                   	  	 DISPLAY BY NAME g_lnc[l_ac].azf03

                                 SELECT tqa02 INTO l_tqa02 FROM tqa_file 
                                  WHERE tqa03 = '2'
                                    AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                                      OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
                                    AND tqa01 = g_lnc[l_ac].lnc02
                    	  	 LET g_lnc[l_ac].tqa02 = l_tqa02
                    	  	 DISPLAY BY NAME g_lnc[l_ac].tqa02
#FUN-A70063--end--

                    	  	  END IF   
                       END IF  
                 END IF 
               END IF
             END IF
          END IF   
      
      AFTER FIELD lnc03
          IF NOT cl_null(g_lnc[l_ac].lnc03) THEN
                LET l_n = 0
                SELECT count(*) INTO l_n FROM geo_file
                 WHERE geo01 = g_lnc[l_ac].lnc03
                IF l_n < 1 THEN
                   CALL cl_err('','alm-124',0)
                   LET g_lnc[l_ac].lnc03 = g_lnc_t.lnc03
                   NEXT FIELD lnc03
                ELSE
                	  SELECT geoacti INTO l_geoacti FROM geo_file
                	   WHERE geo01 = g_lnc[l_ac].lnc03
                	   IF l_geoacti != 'Y' THEN 
                    	  CALL cl_err('','alm-100',0)
                    	  LET g_lnc[l_ac].lnc03 = g_lnc_t.lnc03
                        NEXT FIELD lnc03   
                     ELSE               
                     	   	  SELECT geo02 INTO l_geo02 FROM geo_file
                     	   	   WHERE geo01 = g_lnc[l_ac].lnc03                     	   	 
                     	   	   LET g_lnc[l_ac].geo02 = l_geo02
                     	   	   DISPLAY BY NAME g_lnc[l_ac].geo02                  
                     END IF                        	    
             END IF         
          END IF   
      
       BEFORE DELETE                            #是否取消單身
          IF g_lnc_t.lnc02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lnc02"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lnc[l_ac].lnc02      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lnc_file WHERE lnc02 = g_lnc_t.lnc02
                                    AND lnc01 = g_argv2
                                    
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lnc_file",g_lnc_t.lnc02,"",SQLCA.sqlcode,"","",1)  
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
             LET g_lnc[l_ac].* = g_lnc_t.*
             CLOSE t2901_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lnc[l_ac].lnc02,-263,0)
             LET g_lnc[l_ac].* = g_lnc_t.*
          ELSE
             UPDATE lnc_file SET lnc00 = g_argv1,
                                 lnc02=g_lnc[l_ac].lnc02,
                                 lnc03=g_lnc[l_ac].lnc03
              WHERE lnc02 = g_lnc_t.lnc02
                AND lnc01 = g_argv2
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lnc_file",g_lnc_t.lnc02,"",SQLCA.sqlcode,"","",1)  
                LET g_lnc[l_ac].* = g_lnc_t.*
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
                LET g_lnc[l_ac].* = g_lnc_t.*
             END IF
             CLOSE t2901_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          CLOSE t2901_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lnc02) AND l_ac > 1 THEN
             LET g_lnc[l_ac].* = g_lnc[l_ac-1].*
             NEXT FIELD lnc02
          END IF
  
      ON ACTION controlp
         CASE
           WHEN INFIELD(lnc02)                                                                      
                CALL cl_init_qry_var()                                                                
#               LET g_qryparam.form = "q_azfp2"                    #FUN-A70063                               
                LET g_qryparam.form = "q_tqap2"                    #FUN-A70063 add                                   
                LET g_qryparam.arg1 = g_argv2
                LET g_qryparam.default1 = g_lnc[l_ac].lnc02
                CALL cl_create_qry() RETURNING g_lnc[l_ac].lnc02          
                DISPLAY g_lnc[l_ac].lnc02 TO lnc02                                              
                NEXT FIELD lnc02       
           
            WHEN INFIELD(lnc03)                                                                    
                CALL cl_init_qry_var()                                                             
#modify by hellen --begin 090601
#               LET g_qryparam.form ="q_geo2"                                          
                LET g_qryparam.form ="q_geo"                                          
#modify by hellen --end 090601
                LET g_qryparam.default1 = g_lnc[l_ac].lnc03
                CALL cl_create_qry() RETURNING g_lnc[l_ac].lnc03          
                DISPLAY g_lnc[l_ac].lnc03 TO lnc03                                    
                NEXT FIELD lnc03           
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
 
   CLOSE t2901_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t2901_askkey()
 
   CLEAR FORM
   CALL g_lnc.clear()
       CONSTRUCT g_wc2 ON lnc02,lnc03 FROM s_lnc[1].lnc02,s_lnc[1].lnc03
 
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
          WHEN INFIELD(lnc02)                                                          
            CALL cl_init_qry_var()                         
            LET g_qryparam.form ="q_lnc01"                                                    
            LET g_qryparam.state='c'                                                   
            LET g_qryparam.arg1 = g_argv2
            CALL cl_create_qry() RETURNING g_qryparam.multiret                   
            DISPLAY g_qryparam.multiret TO lnc02                                         
            NEXT FIELD lnc0
 
          WHEN INFIELD(lnc03)                           
            CALL cl_init_qry_var()             
            LET g_qryparam.form ="q_lnc02"       
            LET g_qryparam.state='c'       
            LET g_qryparam.arg1 = g_argv2 
            CALL cl_create_qry() RETURNING g_qryparam.multiret                            
            DISPLAY g_qryparam.multiret TO lnc03                                        
            NEXT FIELD lnc03 
                                                                                                
           END CASE        
    
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
 
   CALL t2901_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t2901_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
#DEFINE   l_azf03         LIKE azf_file.azf03              #FUN-A70063 del
 DEFINE   l_geo02         LIKE geo_file.geo02
 DEFINE   l_tqa02         LIKE tqa_file.tqa02              #FUN-A70063 add
 
    LET g_sql ="SELECT lnc02,'',lnc03,'' ",   
               " FROM lnc_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " and lnc01 = '",g_argv2,"'",
               " ORDER BY lnc02"
    PREPARE t2901_pb FROM g_sql
    DECLARE lnc_curs CURSOR FOR t2901_pb
 
    CALL g_lnc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lnc_curs INTO g_lnc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        ############################
#FUN-A70063--begin--
#       SELECT azf03 INTO l_azf03 FROM azf_file
#        WHERE azf01 = g_lnc[g_cnt].lnc02
#          AND azf02 = '3'
#          AND azfacti = 'Y'
#       LET g_lnc[g_cnt].azf03 = l_azf03
#       DISPLAY BY NAME  g_lnc[g_cnt].azf03

        SELECT tqa02 INTO l_tqa02 FROM tqa_file 
         WHERE tqa03 = '2'
       #No.FUN-A70063 -BEGIN----- Mark By shi
       #   AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
       #              OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
       #   AND tqa01 = g_lnc[l_ac].lnc02
           AND tqa01 = g_lnc[g_cnt].lnc02
       #No.FUN-A70063 -END-------
           AND tqaacti = 'Y'
        LET g_lnc[g_cnt].tqa02 = l_tqa02
        DISPLAY BY NAME  g_lnc[g_cnt].tqa02
#FUN-A70063--end--

           
        SELECT geo02 INTO l_geo02 FROM geo_file
         WHERE geo01 = g_lnc[g_cnt].lnc03
           AND geoacti  = 'Y'
           LET g_lnc[g_cnt].geo02 = l_geo02
        DISPLAY BY NAME g_lnc[g_cnt].geo02
              
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t2901_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lnc TO s_lnc.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION t2901_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lnc02",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t2901_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lnc02",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
      
#No.FUN-960134 
 
 
