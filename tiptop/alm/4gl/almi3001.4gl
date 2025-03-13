# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: almi3001.4gl
# Descriptions...: 正式商戶品牌資料維護作業
# Date & Author..: NO.FUN-870010 08/07/31 By lilingyu 
# Modify.........: No.FUN-960134 09/07/10 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70063 10/07/13 by chenying azf02 = '3' 抓取品牌代碼改抓 tqa_file.tqa03 = '2';
#                                                     欄位azf01改抓tqa01,欄位azf03改抓tqa02
# Modify.........: No.FUN-A70063 10/07/14 by chenying q_azfp3替換成q_tqap3 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_lnf           DYNAMIC ARRAY OF RECORD    
         lnf03       LIKE lnf_file.lnf03,
#        azf03       LIKE azf_file.azf03,    #FUN-A70063 mark
         tqa02       LIKE tqa_file.tqa02,    #FUN-A70063
         lnf04       LIKE lnf_file.lnf04,
         geo02       LIKE geo_file.geo02
                    END RECORD,
     g_lnf_t        RECORD    
         lnf03       LIKE lnf_file.lnf03,
#        azf03       LIKE azf_file.azf03,    #FUN-A70063 mark
         tqa02       LIKE tqa_file.tqa02,    #FUN-A70063
         lnf04       LIKE lnf_file.lnf04,
         geo02       LIKE geo_file.geo02
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
 
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5 
    
DEFINE g_argv1               LIKE lnf_file.lnf00
DEFINE g_argv2               LIKE lne_file.lne01
DEFINE g_argv3               LIKE lne_file.lne02 
DEFINE g_lnf01               LIKE lnf_file.lnf01
 
MAIN
    OPTIONS                              
        INPUT NO WRAP     #No.FUN-9B0136
    #   FIELD ORDER FORM  #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1) 
    LET g_argv2 = ARG_VAL(2) 
    LET g_argv3 = ARG_VAL(3)
    LET g_lnf01 = NULL
    LET g_lnf01 = g_argv2
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW i3001_w WITH FORM "alm/42f/almi3001" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()     
   
     IF NOT cl_null(g_argv2) THEN 
       LET g_wc2 = " lnf01 = '",g_argv2,"' "     
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
     
    CALL i3001_b_fill(g_wc2)
    
    CALL i3001_menu()
    CLOSE WINDOW i3001_w 
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i3001_menu()
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL i3001_bp("G")
      CASE g_action_choice
      
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i3001_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i3001_b()
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
               IF g_lnf[l_ac].lnf03 IS NOT NULL THEN
                  LET g_doc.column1 = "lnf03"
                  LET g_doc.value1 = g_lnf[l_ac].lnf03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lnf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i3001_q()
   CALL i3001_askkey()
END FUNCTION
 
FUNCTION i3001_b()
DEFINE
       l_ac_t          LIKE type_file.num5,           
       l_n             LIKE type_file.num5, 
       l_lock_sw       LIKE type_file.chr1,          
       p_cmd           LIKE type_file.chr1,         
       l_allow_insert  LIKE type_file.chr1,         
       l_allow_delete  LIKE type_file.chr1           
DEFINE l_lne36         LIKE lne_file.lne36
#DEFINE l_lneacti       LIKE lne_file.lneacti
#FUN-A70063---mark begin
#DEFINE l_azf02         LIKE azf_file.azf02
#DEFINE l_azf03         LIKE azf_file.azf03
#DEFINE l_azfacti       LIKE azf_file.azfacti
#FUN-A70063---mark end
#FUN-A70063---begin
DEFINE l_tqa02         LIKE tqa_file.tqa02
DEFINE l_tqa03         LIKE tqa_file.tqa03
DEFINE l_tqaacti       LIKE tqa_file.tqaacti
#FUN-A70063---end
DEFINE l_geo02         LIKE geo_file.geo02
DEFINE l_geoacti       LIKE geo_file.geoacti
 
   IF s_shut(0) THEN RETURN END IF
   
    SELECT lne36 INTO l_lne36 FROM lne_file
     WHERE lne01  = g_argv2
   IF (l_lne36 = 'Y' OR l_lne36 = 'X') THEN 
      CALL cl_err('','alm-148',0)
      LET g_action_choice = NULL
      RETURN       
   END IF   
    
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lnf03,'',lnf04,''", 
                      "  FROM lnf_file WHERE  " ,
                      "   lnf01= '",g_argv2,"' " ,
                      "   and lnf03 = ? " ,
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i3001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lnf WITHOUT DEFAULTS FROM s_lnf.*
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
             CALL i3001_set_entry(p_cmd)                                         
             CALL i3001_set_no_entry(p_cmd) 
             LET g_before_input_done = TRUE   
             LET g_lnf_t.* = g_lnf[l_ac].*  
             OPEN i3001_bcl USING g_lnf_t.lnf03
             IF STATUS THEN
                CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i3001_bcl INTO g_lnf[l_ac].* 
              ############################
#NO.FUN-A70063---mark begin
#          SELECT azf03 INTO l_azf03 FROM azf_file
#           WHERE azf01 = g_lnf[l_ac].lnf03
#             AND azf02 = '3'
#             AND azfacti = 'Y'
#           LET g_lnf[l_ac].azf03 = l_azf03 
#            DISPLAY BY NAME g_lnf[l_ac].azf03 
#NO.FUN-A70063---mark end
           #NO.FUN-A70063---begin
           SELECT tqa02 INTO l_tqa02 FROM tqa_file
            WHERE tqa01 = g_lnf[l_ac].lnf03
              AND tqa03 = '2'
              AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07)) 
                 OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2'))) 
              AND tqaacti = 'Y'
            LET g_lnf[l_ac].tqa02 = l_tqa02
             DISPLAY BY NAME g_lnf[l_ac].tqa02
           #NO.FUN-A70063---end           

           SELECT geo02 INTO l_geo02 FROM geo_file
            WHERE geo01 = g_lnf[l_ac].lnf04
              AND geoacti  = 'Y'
              LET g_lnf[l_ac].geo02 = l_geo02
            DISPLAY BY NAME g_lnf[l_ac].geo02
        #############################################        
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lnf_t.lnf03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          LET g_before_input_done = FALSE                                       
          CALL i3001_set_entry(p_cmd)                                            
          CALL i3001_set_no_entry(p_cmd) 
          LET g_before_input_done = TRUE                                     
          INITIALIZE g_lnf[l_ac].* TO NULL    
          LET g_lnf_t.* = g_lnf[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD lnf03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i3001_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lnf_file(lnf00,lnf01,lnf02,lnf03,lnf04)
          VALUES(g_argv1,g_argv2,'0',g_lnf[l_ac].lnf03,g_lnf[l_ac].lnf04)
       
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lnf_file",g_lnf[l_ac].lnf03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx  
             COMMIT WORK
          END IF
 
       AFTER FIELD lnf03                        
          IF NOT cl_null(g_lnf[l_ac].lnf03) THEN
             IF g_lnf[l_ac].lnf03 != g_lnf_t.lnf03 OR
                g_lnf_t.lnf03 IS NULL THEN
                LET l_n = 0
#               SELECT count(*) INTO l_n FROM azf_file         #NO.FUN-A70063 mark
#                WHERE azf01 = g_lnf[l_ac].lnf03               #NO.FUN-A70063 mark
                #NO.FUN-A70063---begin
                SELECT count(*) INTO l_n FROM tqa_file
                 WHERE tqa01 = g_lnf[l_ac].lnf03
                  AND tqa03 = '2'
                #NO.FUN-A70063---end 
                IF l_n < 1 THEN
#                  CALL cl_err('','alm-121',0)                 #NO.FUN-A70063 mark
                   CALL cl_err('','alm1002',0)                 #NO.FUN-A70063
                   LET g_lnf[l_ac].lnf03 = g_lnf_t.lnf03
                   NEXT FIELD lnf03
                ELSE
                          LET l_n = 0
#NO.FUN-A70063---mark begin 
#                	  SELECT count(*) INTO l_n FROM azf_file
#                	   WHERE azf01 = g_lnf[l_ac].lnf03
#                             AND azf02 = '3'
#NO.FUN-A70063---mark end
                         #NO.FUN-A70063---begin
                         SELECT count(*) INTO l_n FROM tqa_file
                          WHERE tqa01 = g_lnf[l_ac].lnf03
                             AND tqa03 = '2'
                             AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                                 OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                         #NO.FUN-A70063---end
                          IF l_n < 1 THEN 
                     	     CALL cl_err('','alm1004',0)    #FUN-A70063 alm-123->alm1004 
                	     LET g_lnf[l_ac].lnf03 = g_lnf_t.lnf03
                       NEXT FIELD lnf03   
                    ELSE
#NO.FUN-A70063---mark begin
#                    	 SELECT azfacti INTO l_azfacti FROM azf_file
#                    	  WHERE azf01 = g_lnf[l_ac].lnf03
#                    	    AND azf02 = '3'
#                    	  IF l_azfacti != 'Y' THEN
#NO.FUN-A70063---mark end 
                        #NO.FUN-A70063---begin
                        SELECT tqaacti INTO l_tqaacti FROM tqa_file
                         WHERE tqa01 = g_lnf[l_ac].lnf03
                           AND tqa03 = '2'
                           AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                              OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                         IF l_tqaacti != 'Y' THEN
                        #NO.FUN-A70063---end

                    	     CALL cl_err('','alm-139',0)
                    	     LET g_lnf[l_ac].lnf03 = g_lnf_t.lnf03
                           NEXT FIELD lnf03   
                    	  ELSE
                    	  	LET l_n = 0
                    	  	SELECT COUNT(*) INTO l_n FROM lnf_file
                    	  	 WHERE lnf01   = g_argv2
                    	  	   AND lnf03   = g_lnf[l_ac].lnf03
                    	  	 IF l_n > 0 THEN 
                    	  	    CALL cl_err('','alm-167',0)
                    	  	    LET g_lnf[l_ac].lnf03 = g_lnf_t.lnf03
                    	  	    DISPLAY BY NAME g_lnf[l_ac].lnf03 
                    	  	    NEXT FIELD lnf03
                    	  	  ELSE
#NO.FUN-A70063---mark begin
#                   	  	     SELECT azf03 INTO l_azf03 FROM azf_file
#                    	      	      WHERE azf01 = g_lnf[l_ac].lnf03 
#                    	      	        AND azf02 = '3'                   	  	
#                   	  	      LET g_lnf[l_ac].azf03 = l_azf03
#                  	  	    DISPLAY BY NAME g_lnf[l_ac].azf03
#NO.FUN-A70063---mark begin
                                    #NO.FUN-A70063---begin
                                    SELECT tqa02 INTO l_tqa02 FROM tqa_file
                                     WHERE tqa01 = g_lnf[l_ac].lnf03
                                       AND tqa03 = '2'
                                        AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                                          OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
                                     LET g_lnf[l_ac].tqa02 = l_tqa02
                                    DISPLAY BY NAME g_lnf[l_ac].tqa02
                                    #NO.FUN-A70063---begin

                    	  	  END IF   
                       END IF   
                    END IF  	    
                END IF
             END IF
          END IF   
      
      AFTER FIELD lnf04
          IF NOT cl_null(g_lnf[l_ac].lnf04) THEN
             IF g_lnf[l_ac].lnf04 != g_lnf_t.lnf04 OR
                g_lnf_t.lnf04 IS NULL THEN
                LET l_n = 0
                SELECT count(*) INTO l_n FROM geo_file
                 WHERE geo01 = g_lnf[l_ac].lnf04
                IF l_n < 1 THEN
                   CALL cl_err('','alm-124',0)
                   LET g_lnf[l_ac].lnf04 = g_lnf_t.lnf04
                   NEXT FIELD lnf04
                ELSE
                	  SELECT geoacti INTO l_geoacti FROM geo_file
                	   WHERE geo01 = g_lnf[l_ac].lnf04
                	   IF l_geoacti != 'Y' THEN 
                    	  CALL cl_err('','alm-100',0)
                    	  LET g_lnf[l_ac].lnf04 = g_lnf_t.lnf04
                        NEXT FIELD lnf04   
                     ELSE
                     	  SELECT geo02 INTO l_geo02 FROM geo_file
                     	   WHERE geo01 = g_lnf[l_ac].lnf04
                     	   LET g_lnf[l_ac].geo02 = l_geo02
                     	   DISPLAY BY NAME g_lnf[l_ac].geo02
                     END IF                        	    
                END IF
             END IF          
          END IF   
      
       BEFORE DELETE                           
          IF g_lnf_t.lnf03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lnf03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lnf[l_ac].lnf03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lnf_file WHERE lnf01      = g_argv2
                                    AND lnf03      = g_lnf_t.lnf03
                                                                                                         
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lnf_file",g_lnf_t.lnf03,"",SQLCA.sqlcode,"","",1)  
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
             LET g_lnf[l_ac].* = g_lnf_t.*
             CLOSE i3001_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lnf[l_ac].lnf03,-263,0)
             LET g_lnf[l_ac].* = g_lnf_t.*
          ELSE
             UPDATE lnf_file SET lnf04=g_lnf[l_ac].lnf04
              WHERE lnf03 = g_lnf_t.lnf03
                AND lnf01 = g_argv2
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lnf_file",g_lnf_t.lnf03,"",SQLCA.sqlcode,"","",1)  
                LET g_lnf[l_ac].* = g_lnf_t.*
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
                LET g_lnf[l_ac].* = g_lnf_t.*
             END IF
             CLOSE i3001_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          CLOSE i3001_bcl            # 新增
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(lnf03) AND l_ac > 1 THEN
             LET g_lnf[l_ac].* = g_lnf[l_ac-1].*
             NEXT FIELD lnf03
          END IF
  
      ON ACTION controlp
         CASE
           WHEN INFIELD(lnf03)                                      
                CALL cl_init_qry_var()                                                       
#               LET g_qryparam.form ="q_azfp3"      #NO.FUN-A70063 mark 
                LET g_qryparam.form ="q_tqap3"      #NO.FUN-A70063
                LET g_qryparam.arg1 = g_argv2                                         
                LET g_qryparam.default1 = g_lnf[l_ac].lnf03
                CALL cl_create_qry() RETURNING g_lnf[l_ac].lnf03          
                DISPLAY g_lnf[l_ac].lnf03 TO lnf03                                 
                NEXT FIELD lnf03       
           
            WHEN INFIELD(lnf04)                                              
                 CALL cl_init_qry_var()                                           
                 LET g_qryparam.form ="q_geo3"                                                     
                 LET g_qryparam.default1 = g_lnf[l_ac].lnf04
                 CALL cl_create_qry() RETURNING g_lnf[l_ac].lnf04          
                 DISPLAY g_lnf[l_ac].lnf04 TO lnf04                                               
                 NEXT FIELD lnf04           
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
 
   CLOSE i3001_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i3001_askkey()
 
   CLEAR FORM
   CALL g_lnf.clear()
       CONSTRUCT g_wc2 ON lnf03,lnf04 FROM s_lnf[1].lnf03,s_lnf[1].lnf04
 
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
            WHEN INFIELD(lnf03)                                      
                CALL cl_init_qry_var()              
#               LET g_qryparam.form ="q_lnf01"           #FUN-A70063                  
                LET g_qryparam.form ="q_lnf01_1"           #FUN-A70063                  
                LET g_qryparam.state='c'    
                LET g_qryparam.arg1 = g_argv2
                LET g_qryparam.arg2 = g_argv3                                                        
                CALL cl_create_qry() RETURNING g_qryparam.multiret                      
                DISPLAY g_qryparam.multiret TO lnf03                                      
                NEXT FIELD lnf03
             
             WHEN INFIELD(lnf04)        
                CALL cl_init_qry_var()                
                LET g_qryparam.form ="q_lnf02"            
                LET g_qryparam.state='c'                                           
                LET g_qryparam.arg1 = g_argv2
                LET g_qryparam.arg2 = g_argv3             
                CALL cl_create_qry() RETURNING g_qryparam.multiret    
                DISPLAY g_qryparam.multiret TO lnf04                                 
                NEXT FIELD lnf04 
                                                                                                
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
  
   CALL i3001_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i3001_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
#DEFINE   l_azf03         LIKE azf_file.azf03      #NO.FUN-A70063
 DEFINE   l_tqa02         LIKE tqa_file.tqa02      #NO.FUN-A70063 
 DEFINE   l_geo02         LIKE geo_file.geo02
 
    LET g_sql ="SELECT lnf03,'',lnf04,'' ",   
               " FROM lnf_file ",
               " WHERE ", p_wc2 CLIPPED,                   
              ############################
               " and lnf01 = '",g_argv2,"'",
               " and lnf02 = '",g_argv3,"'", 
               " ORDER BY lnf03"
    PREPARE i3001_pb FROM g_sql
    DECLARE lnf_curs CURSOR FOR i3001_pb
 
    CALL g_lnf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lnf_curs INTO g_lnf[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN 
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        ############################
#NO.FUN-A70063---mark begin
#       SELECT azf03 INTO l_azf03 FROM azf_file
#        WHERE azf01 = g_lnf[g_cnt].lnf03
#          AND azf02 = '3'
#          AND azfacti = 'Y'
#       LET g_lnf[g_cnt].azf03 = l_azf03 
#       DISPLAY BY NAME g_lnf[g_cnt].azf03 
#NO.FUN-A70063---mark end 
        #NO.FUN-A70063---begin
        SELECT tqa02 INTO l_tqa02 FROM tqa_file
         WHERE tqa01 = g_lnf[g_cnt].lnf03
           AND tqa03 = '2'
           AND ((tqa01 = tqa07 AND tqa07 NOT IN (SELECT tqa07 FROM tqa_file WHERE tqa03 = '2' AND tqa01 <> tqa07))
                 OR (tqa01 <> tqa07 AND tqa01 NOT IN (SELECT DISTINCT tqa07 FROM tqa_file WHERE tqa03 = '2')))
           AND tqaacti = 'Y'
        LET g_lnf[g_cnt].tqa02 = l_tqa02
        DISPLAY BY NAME g_lnf[g_cnt].tqa02
        #NO.FUN-A70063---end
           
        SELECT geo02 INTO l_geo02 FROM geo_file
         WHERE geo01 = g_lnf[g_cnt].lnf04
           AND geoacti  = 'Y'
           LET g_lnf[g_cnt].geo02 = l_geo02
        DISPLAY BY NAME g_lnf[g_cnt].geo02
        #############################################      
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lnf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i3001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lnf TO s_lnf.* ATTRIBUTE(COUNT=g_rec_b)
 
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
                                            
FUNCTION i3001_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lnf03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i3001_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lnf03",FALSE)                                      
   END IF  
END FUNCTION 
#No.FUN-960134 
