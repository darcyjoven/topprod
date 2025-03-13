# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: almt6202.4gl
# Descriptions...: 儲值卡充值維護作業(支票) 
# Date & Author..: FUN-870015 08/08/14 By  shiwuying
# Modify.........: No.FUN-960134 09/07/21 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30159 10/04/07 By Smapmin 現金/銀聯卡/支票的動作要寫在Transaction裡
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
# Modify.........: No:FUN-C30038 12/03/27 By JinJJ rxy11增加开窗q_nmt，AFTER FIELD 一并修改，存在anmi080且有效
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_rxy           DYNAMIC ARRAY OF RECORD    
         rxy02       LIKE rxy_file.rxy02,
         rxy06       LIKE rxy_file.rxy06,
         rxy09       LIKE rxy_file.rxy09,
         rxy10       LIKE rxy_file.rxy10,
         rxy11       LIKE rxy_file.rxy11,
         rxy05       LIKE rxy_file.rxy05,
         rxy17       LIKE rxy_file.rxy17
                    END RECORD,
     g_rxy_t        RECORD    
         rxy02       LIKE rxy_file.rxy02,
         rxy06       LIKE rxy_file.rxy06,
         rxy09       LIKE rxy_file.rxy09,
         rxy10       LIKE rxy_file.rxy10,
         rxy11       LIKE rxy_file.rxy11,
         rxy05       LIKE rxy_file.rxy05,
         rxy17       LIKE rxy_file.rxy17
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
  
DEFINE g_forupd_sql          STRING         
DEFINE g_cnt                 LIKE type_file.num10           
DEFINE g_i                   LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE lpu_file.lpu01
DEFINE g_amt                 LIKE lpu_file.lpu05
DEFINE g_rxy01               LIKE rxy_file.rxy01
DEFINE g_lpuplant               LIKE lpu_file.lpuplant
DEFINE g_lpulegal            LIKE lpu_file.lpulegal
DEFINE g_lpu06               LIKE lpu_file.lpu06
DEFINE g_lpu08               LIKE lpu_file.lpu08
DEFINE g_lpu12               LIKE lpu_file.lpu12
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1)
    LET g_rxy01   = g_argv1
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    

   #-----TQC-A30159---------
   LET g_forupd_sql= "SELECT * FROM lpu_file WHERE lpu01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t6202_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
   #-----END TQC-A30159-----

   
    OPEN WINDOW t6202_w WITH FORM "alm/42f/almt6103" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()    
   
    SELECT lpuplant,lpulegal,lpu06,lpu12,lpu08
      INTO g_lpuplant,g_lpulegal,g_lpu06,g_lpu12,g_lpu08
      FROM lpu_file WHERE lpu01=g_rxy01
    IF cl_null(g_lpu06) THEN 
       LET g_lpu06=0
    END IF 
    LET g_amt=g_lpu06-g_lpu12
    DISPLAY g_amt TO FORMONLY.amt
    
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = "rxy01 = '",g_argv1,"' AND rxyplant = '",g_lpuplant,"'"                  
    ELSE
    	 LET g_wc2 = " 1=1"
    END if
    CALL t6202_b_fill(g_wc2)
    
    CALL t6202_menu()
    CLOSE WINDOW t6202_w    
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t6202_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t6202_bp("G")
      CASE g_action_choice
      
#         WHEN "query"  
#            IF cl_chk_act_auth() THEN
#               CALL t6202_q()
#            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t6202_b()
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
               IF g_rxy[l_ac].rxy02 IS NOT NULL THEN
                  LET g_doc.column1 = "rxy02"
                  LET g_doc.value1 = g_rxy[l_ac].rxy02
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxy),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t6202_b()
DEFINE
   l_ac_t          LIKE type_file.num5,           
   l_n             LIKE type_file.num5,
   l_cnt           LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,          
   p_cmd           LIKE type_file.chr1, 
   l_cmd           LIKE type_file.chr1,
   l_allow_insert  LIKE type_file.chr1,         
   l_allow_delete  LIKE type_file.chr1        
DEFINE l_rxy05     LIKE rxy_file.rxy05
DEFINE l_time      LIKE rxy_file.rxy22 #No.FUN-A80008 
DEFINE l_nmt01     LIKE nmt_file.nmt01 #No.FUN-C30038								
DEFINE l_nmtacti   LIKE nmt_file.nmtacti #No.FUN-C30038

   IF s_shut(0) THEN RETURN END IF
 
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   IF g_lpu08 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
   END IF
 
   IF g_amt=0 THEN
      CALL cl_err('','alm-225',1)
      RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql = "SELECT rxy02,rxy06,rxy09,rxy10,rxy11,rxy05,rxy17", 
                      "  FROM rxy_file WHERE rxy01= '",g_rxy01,"' AND ",
                      "  rxy02 = ? and rxy00='21' AND rxy03 = '03' ",
                      " and rxyplant='",g_lpuplant,"' ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t6202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_rxy WITHOUT DEFAULTS FROM s_rxy.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
             CALL fgl_set_arr_curr(g_rec_b+1)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'           
          LET l_n  = ARR_COUNT()
          IF l_ac <= g_rec_b THEN
             LET l_ac = g_rec_b + 1
             LET l_n = l_ac
             CALL fgl_set_arr_curr(l_ac)
          END IF
          IF g_amt=0 THEN
             CALL cl_err('','alm-225',1)
             RETURN
          END IF
          BEGIN WORK
          #-----TQC-A30159---------
          OPEN t6202_cl USING g_rxy01
          IF STATUS THEN
             CALL cl_err("OPEN t6202_cl:", STATUS, 1)
             CALL g_rxy.deleteElement(l_ac)
             RETURN
          END IF
          #-----END TQC-A30159-----
          IF g_rec_b>=l_ac then 
             LET l_cmd='N'
             
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL t6202_set_entry(p_cmd)                                         
             CALL t6202_set_no_entry(p_cmd)
          #  CALL t6202_set_entry_b()    
             LET g_before_input_done = TRUE   
             LET g_rxy_t.* = g_rxy[l_ac].*  
             OPEN t6202_bcl USING g_rxy_t.rxy02
             IF STATUS THEN
                CALL cl_err("OPEN t6202_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t6202_bcl INTO g_rxy[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rxy_t.rxy02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()           
          #  CALL t6202_set_no_entry_b()
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                
          INITIALIZE g_rxy[l_ac].* TO NULL    
          LET g_rxy_t.* = g_rxy[l_ac].* 
          CALL cl_show_fld_cont()                                                      
          LET g_before_input_done = FALSE                                       
          CALL t6202_set_entry(p_cmd)                                            
          CALL t6202_set_no_entry(p_cmd) 
       #  CALL t6202_set_entry_b() 
          LET g_before_input_done = TRUE
          NEXT FIELD rxy02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t6202_bcl
             CLOSE t6202_cl   #TQC-A30159
             CANCEL INSERT
          END IF
          LET l_time = TIME #No.FUN-A80008
          INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,rxy09,
                               rxy10,rxy11,rxyplant,rxy21,rxy22,rxylegal,rxy17)
               VALUES('21',g_rxy01,g_rxy[l_ac].rxy02,'03','1',g_rxy[l_ac].rxy05,
                      g_rxy[l_ac].rxy06,g_rxy[l_ac].rxy09,g_rxy[l_ac].rxy10,
                      g_rxy[l_ac].rxy11,g_lpuplant,g_today,
                     #to_char(sysdate,'HH24:MI'),g_lpulegal,g_rxy[l_ac].rxy17) #No.FUN-A80008
                      l_time,g_lpulegal,g_rxy[l_ac].rxy17)                     #No.FUN-A80008
 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rxy_file",g_rxy[l_ac].rxy02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             LET g_lpu12 = g_lpu12 + g_rxy[l_ac].rxy05
             LET g_amt=g_lpu06-g_lpu12
             DISPLAY g_amt TO FORMONLY.amt
             UPDATE lpu_file SET lpu12=g_lpu12
             WHERE lpu01=g_rxy01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lpu_file",g_rxy01,"",SQLCA.sqlcode,"","",1) 
             END IF  
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       BEFORE FIELD rxy02
        IF cl_null(g_rxy[l_ac].rxy02) THEN     
           SELECT max(rxy02)+1 INTO g_rxy[l_ac].rxy02 FROM rxy_file      
            WHERE rxy00='21' AND rxy01= g_rxy01  AND rxyplant= g_lpuplant
           IF cl_null(g_rxy[l_ac].rxy02) OR g_rxy[l_ac].rxy02 <= 0 THEN 
              LET g_rxy[l_ac].rxy02 = 1 
           END IF      
        END IF      
               
       AFTER FIELD rxy02 
         IF not cl_null(g_rxy[l_ac].rxy02) THEN                       
            IF g_rxy[l_ac].rxy02 != g_rxy_t.rxy02 OR 
               g_rxy_t.rxy02 IS NULL THEN  
              SELECT COUNT(*) INTO l_cnt FROM rxy_file 
                WHERE rxy00='21' AND rxy01=g_rxy01
                  AND rxy02=g_rxy[l_ac].rxy02
                  AND rxyplant = g_lpuplant
              IF l_cnt > 0 THEN 
                 CALL cl_err('','-239',1)
                 LET g_rxy[l_ac].rxy02=g_rxy_t.rxy02
                 NEXT FIELD rxy02
              END IF
           END IF 
        END IF
          
#       AFTER FIELD rxy05
#          IF NOT cl_null(g_rxy[l_ac].rxy05) THEN  
#             IF g_rxy[l_ac].rxy05<0 THEN 
#                CALL cl_err('','alm-192',1)
#                LET g_rxy[l_ac].rxy05=g_rxy_t.rxy05
#                NEXT FIELD rxy05
#             END IF
#             IF g_rxy[l_ac].rxy05 + g_lpu12 > g_lpu06 THEN 
#                CALL cl_err('','alm-199',1)
#                LET g_rxy[l_ac].rxy05=g_rxy_t.rxy05
#                NEXT FIELD rxy05
#             END IF
#          END IF    
       
       AFTER FIELD rxy09
          IF NOT cl_null(g_rxy[l_ac].rxy09) THEN  
             IF g_rxy[l_ac].rxy09<=0 THEN 
                CALL cl_err('','alm-192',1)
                LET g_rxy[l_ac].rxy09=g_rxy_t.rxy09
                NEXT FIELD rxy09
             END IF
             IF g_rxy[l_ac].rxy09 + g_lpu12 > g_lpu06 THEN
             #  CALL cl_err('','alm-199',1)
             #  LET g_rxy[l_ac].rxy09=g_rxy_t.rxy09
             #  NEXT FIELD rxy09
                LET g_rxy[l_ac].rxy05 = g_lpu06 - g_lpu12
                LET g_rxy[l_ac].rxy17 = g_rxy[l_ac].rxy09 - g_rxy[l_ac].rxy05
             ELSE
                LET g_rxy[l_ac].rxy05 = g_rxy[l_ac].rxy09
                LET g_rxy[l_ac].rxy17 = 0
             END IF
             DISPLAY BY NAME g_rxy[l_ac].rxy05
          END IF

#FUN-C30038---START---
      AFTER FIELD rxy11
         IF NOT cl_null(g_rxy[l_ac].rxy11) THEN
            LET g_errno=''
            SELECT nmt01,nmtacti INTO l_nmt01,l_nmtacti FROM nmt_file
              WHERE nmt01=g_rxy[l_ac].rxy11
            CASE
               WHEN SQLCA.sqlcode=100   LET g_errno='aap-007'
                                        LET l_nmt01=NULL
               WHEN l_nmtacti='N'       LET g_errno='axr-093'
               OTHERWISE
                  LET g_errno=SQLCA.sqlcode USING '------'
            END CASE

            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_rxy[l_ac].rxy11,g_errno,1)
               LET g_rxy[l_ac].rxy11 = g_rxy_t.rxy11
               DISPLAY BY NAME g_rxy[l_ac].rxy11
               NEXT FIELD rxy11
            END IF
         END IF
#FUN-C30038---END---

       BEFORE DELETE                            #是否取消單身
          IF (g_rxy_t.rxy02 IS NOT NULL) THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END if
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "rxy02"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_rxy[l_ac].rxy02      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM rxy_file WHERE rxy01 = g_rxy01
                                    AND rxy02 = g_rxy_t.rxy02
                                    AND rxy00 = '21'
                                    AND rxyplant= g_lpuplant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rxy_file",g_rxy_t.rxy02,"",SQLCA.sqlcode,"","",1)  
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
             LET g_rxy[l_ac].* = g_rxy_t.*
             CLOSE t6202_bcl
             CLOSE t6202_cl   #TQC-A30159
             ROLLBACK WORK
             EXIT INPUT
          END if
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_rxy[l_ac].rxy02,-263,0)
             LET g_rxy[l_ac].* = g_rxy_t.*
          ELSE 
             UPDATE rxy_file SET rxy02=g_rxy[l_ac].rxy02,
                                 rxy06=g_rxy[l_ac].rxy06,
                                 rxy09=g_rxy[l_ac].rxy09,
                                 rxy10=g_rxy[l_ac].rxy10,
                                 rxy11=g_rxy[l_ac].rxy11,
                                 rxy05=g_rxy[l_ac].rxy05,
                                 rxy17=g_rxy[l_ac].rxy17
              WHERE rxy00 ='21'
                AND rxy01 = g_rxy01
                AND rxy02 = g_rxy_t.rxy02
                AND rxyplant= g_lpuplant
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rxy_file",g_rxy_t.rxy02,"",SQLCA.sqlcode,"","",1)  
                LET g_rxy[l_ac].* = g_rxy_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE t6202_bcl
                CLOSE t6202_cl   #TQC-A30159
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR() 
          LET l_ac_t = l_ac 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_rxy[l_ac].* = g_rxy_t.*
             END IF
             CLOSE t6202_bcl            # 新增
             CLOSE t6202_cl   #TQC-A30159
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END if
          CLOSE t6202_bcl            # 新增
          CLOSE t6202_cl   #TQC-A30159
          COMMIT WORK
#FUN_C30038---START---
		ON ACTION controlp					     
		   CASE					          
		      WHEN INFIELD(rxy11)					              
		         CALL cl_init_qry_var()					                
		         LET g_qryparam.form="q_nmt"					                
		         LET g_qryparam.default1=g_rxy[l_ac].rxy11
                 
		         CALL cl_create_qry() RETURNING g_rxy[l_ac].rxy11			                
		         DISPLAY BY NAME g_rxy[l_ac].rxy11	                 
		         NEXT FIELD rxy11
							 
		      OTHERWISE					            
		         EXIT CASE					                 
		  END CASE	
#FUN_C30038---END---

       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(rxy02) AND l_ac > 1 THEN
             LET g_rxy[l_ac].* = g_rxy[l_ac-1].*
             NEXT FIELD rxy02
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
   CLOSE t6202_bcl
   CLOSE t6202_cl   #TQC-A30159
   COMMIT WORK
END FUNCTION
 
FUNCTION t6202_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 
    LET g_sql ="SELECT rxy02,rxy06,rxy09,rxy10,rxy11,rxy05,rxy17",   
               " FROM rxy_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " AND rxy00 = '21' ",
               " AND rxy03 = '03' ",
               " AND rxyplant='",g_lpuplant,"' ", 
               " ORDER BY rxy02"
    PREPARE t6202_pb FROM g_sql
    DECLARE rxy_curs CURSOR FOR t6202_pb
 
    CALL g_rxy.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rxy_curs INTO g_rxy[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_rxy.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t6202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rxy TO s_rxy.* ATTRIBUTE(COUNT=g_rec_b)
 
   BEFORE ROW
       LET l_ac = ARR_CURR()
       CALL cl_show_fld_cont() 
       
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
         
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
 
FUNCTION t6202_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("rxy02",TRUE) 
   END if
END FUNCTION 
 
FUNCTION t6202_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' then
     CALL cl_set_comp_entry("rxy02",FALSE) 
   END IF
   CALL cl_set_comp_entry("rxy05",FALSE)
END FUNCTION                                                                    
      
FUNCTION t6202_set_entry_b()
     CALL cl_set_comp_entry("rxy02,rxy06,rxy10,rxy09,rxy11",TRUE) 
END FUNCTION 
 
FUNCTION t6202_set_no_entry_b()
     CALL cl_set_comp_entry("rxy02,rxy06,rxy05,rxy10,rxy09,rxy11",FALSE) 
END FUNCTION  
#No.FUN-960134
