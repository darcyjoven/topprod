# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: almt6201.4gl
# Descriptions...: 儲值卡充值維護作業(銀聯卡)
# Date & Author..: FUN-870015 08/08/12 By  shiwuying
# Modify.........: No.FUN-960134 09/07/21 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30159 10/04/07 By Smapmin 現金/銀聯卡/支票的動作要寫在Transaction裡
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_rxz           DYNAMIC ARRAY OF RECORD    
         rxz03       LIKE rxz_file.rxz03,
         rxz04       LIKE rxz_file.rxz04,
         rxz05       LIKE rxz_file.rxz05,
         rxz15       LIKE rxz_file.rxz15,
         rxz10       LIKE rxz_file.rxz10,
         rxz09       LIKE rxz_file.rxz09,
         rxz13       LIKE rxz_file.rxz13
                    END RECORD,
     g_rxz_t        RECORD    
         rxz03       LIKE rxz_file.rxz03,
         rxz04       LIKE rxz_file.rxz04,
         rxz05       LIKE rxz_file.rxz05,
         rxz15       LIKE rxz_file.rxz15,
         rxz10       LIKE rxz_file.rxz10,
         rxz09       LIKE rxz_file.rxz09,
         rxz13       LIKE rxz_file.rxz13
                    END RECORD,               
   
    g_wc2,g_sql              LIKE type_file.chr1000,    
    g_rec_b                  LIKE type_file.num5,       
    l_ac                     LIKE type_file.num5        
  
DEFINE g_forupd_sql          STRING         
DEFINE   g_cnt               LIKE type_file.num10           
DEFINE   g_i                 LIKE type_file.num5     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_argv1               LIKE lpu_file.lpu01
DEFINE g_amt                 LIKE lpu_file.lpu05
DEFINE g_rxz01               LIKE rxz_file.rxz01
DEFINE g_lpuplant            LIKE lpu_file.lpuplant
DEFINE g_lpulegal            LIKE lpu_file.lpulegal
DEFINE g_lpu06               LIKE lpu_file.lpu06
DEFINE g_lpu08               LIKE lpu_file.lpu08
DEFINE g_lpu12               LIKE lpu_file.lpu12
DEFINE g_rxy05               LIKE rxy_file.rxy05
DEFINE g_rxy08               LIKE rxy_file.rxy08
DEFINE g_rxy02               LIKE rxy_file.rxy02
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1)
    LET g_rxz01   = g_argv1
   
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
   DECLARE t6201_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
   #-----END TQC-A30159-----

   
    OPEN WINDOW t6201_w WITH FORM "alm/42f/almt6102" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()    
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = "rxz01 = '",g_argv1,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
    SELECT lpuplant,lpulegal,lpu06,lpu12,lpu08
      INTO g_lpuplant,g_lpulegal,g_lpu06,g_lpu12,g_lpu08
      FROM lpu_file WHERE lpu01=g_argv1
    IF cl_null(g_lpu06) THEN 
       LET g_lpu06=0
    END IF 
    IF cl_null(g_lpu12) THEN
       LET g_lpu12=0
    END IF
    LET g_amt=g_lpu06-g_lpu12
    DISPLAY g_amt TO FORMONLY.amt
    SELECT SUM(rxy05),SUM(rxy08) INTO g_rxy05,g_rxy08 FROM rxy_file 
     WHERE rxy00='21' AND rxy01=g_argv1 AND rxy03='02' AND rxyplant=g_lpuplant
    IF cl_null(g_rxy05) THEN 
       LET g_rxy05=0
    END IF 
    IF cl_null(g_rxy08) THEN 
       LET g_rxy08=0
    END IF  
    DISPLAY g_rxy05 TO FORMONLY.rxy05
    DISPLAY g_rxy08 TO FORMONLY.rxy08
    CALL t6201_b_fill(g_wc2)
    
    CALL t6201_menu()
    CLOSE WINDOW t6201_w    
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t6201_menu()
 
   WHILE TRUE
      CALL t6201_bp("G")
      CASE g_action_choice
      
#         WHEN "query"  
#            IF cl_chk_act_auth() THEN
#               CALL t6201_q()
#            END IF
            
#         WHEN "detail"
#            IF cl_chk_act_auth() THEN
#               CALL t6201_b()
#            ELSE
#               LET g_action_choice = NULL
#            END IF
            
         WHEN "auto"
         
         WHEN "swipecard"
             IF cl_chk_act_auth() THEN
                CALL t6201_b()
             ELSE 
                LET g_action_choice = NULL
             END IF
             
         WHEN "transactions"    
                            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
          WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_rxz[l_ac].rxz03 IS NOT NULL THEN
                  LET g_doc.column1 = "rxz03"
                  LET g_doc.value1 = g_rxz[l_ac].rxz03
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxz),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t6201_b()
DEFINE
   l_ac_t          LIKE type_file.num5,           
   l_n             LIKE type_file.num5,
   l_cnt           LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,          
   p_cmd           LIKE type_file.chr1, 
   l_allow_insert  LIKE type_file.chr1,         
   l_allow_delete  LIKE type_file.chr1        
DEFINE l_rxy05     LIKE rxy_file.rxy05
DEFINE l_rxy08     LIKE rxy_file.rxy08
DEFINE l_time      LIKE rxy_file.rxy22 #No.FUN-A80008 
   IF s_shut(0) THEN RETURN END IF
   
   IF g_lpu08 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
   END IF 
   
   IF g_amt=0 THEN
      CALL cl_err('','alm-225',1)
      RETURN
   END IF 
   
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET g_forupd_sql = "SELECT rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13", 
                      "  FROM rxz_file WHERE rxz01= '",g_rxz01,"' AND ",
                      "  rxz03 = ? and rxz00='21'  ",
                      " and rxzplant='",g_lpuplant,"' ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t6201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

 
   INPUT ARRAY g_rxz WITHOUT DEFAULTS FROM s_rxz.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              # INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
                INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=l_allow_insert)
 
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
          OPEN t6201_cl USING g_rxz01
          IF STATUS THEN
             CALL cl_err("OPEN t6201_cl:", STATUS, 1)
             CALL g_rxz.deleteElement(l_ac)
             RETURN
          END IF
          #-----END TQC-A30159-----
          IF g_rec_b>=l_ac THEN
             LET p_cmd='u'
             LET g_before_input_done = FALSE                                    
             CALL t6201_set_entry(p_cmd)                                         
             CALL t6201_set_no_entry(p_cmd)
          #  CALL t6201_set_entry_b()    
             LET g_before_input_done = TRUE   
             LET g_rxz_t.* = g_rxz[l_ac].*  
             OPEN t6201_bcl USING g_rxz_t.rxz03
             IF STATUS THEN
                CALL cl_err("OPEN t6201_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t6201_bcl INTO g_rxz[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rxz_t.rxz03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont()           
          #  CALL t6201_set_no_entry_b()
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                
          INITIALIZE g_rxz[l_ac].* TO NULL    
          LET g_rxz[l_ac].rxz13 = 'Y'
          LET g_rxz[l_ac].rxz15 = 'N'
          LET g_rxz[l_ac].rxz10 = 0
          LET g_rxz_t.* = g_rxz[l_ac].* 
          CALL cl_show_fld_cont()
          LET g_before_input_done = FALSE                                       
          CALL t6201_set_entry(p_cmd)
          CALL t6201_set_no_entry(p_cmd) 
          CALL t6201_set_entry_b()  
          CALL t6201_set_entry_rxy15()
          CALL cl_set_comp_entry("rxz09",FALSE) 
          LET g_before_input_done = TRUE
          NEXT FIELD rxz03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t6201_bcl
             CLOSE t6201_cl   #TQC-A30159
             CANCEL INSERT
          END IF
          LET l_time = TIME #No.FUN-A80008
          INSERT INTO rxz_file(rxz00,rxz01,rxz02,rxz03,rxz04,rxz05,rxz06,rxz07,
                               rxz08,rxz09,rxz10,rxz11,rxz12,rxz13,rxz14,rxz15,
                               rxz20,rxz21,rxzplant,rxzlegal)
                        VALUES('21',g_rxz01,'1',g_rxz[l_ac].rxz03,
                               g_rxz[l_ac].rxz04,g_rxz[l_ac].rxz05,g_today,
                               l_time,g_user,g_rxz[l_ac].rxz09,  #No.FUN-A80008
                               g_rxz[l_ac].rxz10,'','',g_rxz[l_ac].rxz13,'S',
                               g_rxz[l_ac].rxz15,'2','',g_lpuplant,g_lpulegal)
 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rxz_file",g_rxz[l_ac].rxz03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             IF g_rxz[l_ac].rxz13='Y' THEN 
                SELECT MAX(rxy02) INTO g_rxy02 FROM rxy_file WHERE rxy00='21' AND rxy01= g_argv1
                IF g_rxy02 IS NULL THEN 
                   LET g_rxy02=0
                END IF 
                LET g_rxy02=g_rxy02+1
                INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,
                                     rxy06,rxy07,rxy08,rxyplant,rxy20,rxy21,
                                     rxy22,rxylegal) 
                VALUES('21',g_rxz01,g_rxy02,'02','1',g_rxz[l_ac].rxz05,
                       g_rxz[l_ac].rxz04,g_rxz[l_ac].rxz10,g_rxz[l_ac].rxz09,
                       g_lpuplant,g_rxz[l_ac].rxz15,g_today,
                      #to_char(sysdate,'HH24:MI'), g_lpulegal) #No.FUN-A80008
                       l_time,g_lpulegal) #No.FUN-A80008
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","rxy_file",g_rxz[l_ac].rxz03,"",SQLCA.sqlcode,"","",1) 
                END IF
             
                SELECT SUM(rxy05),SUM(rxy08) INTO l_rxy05,l_rxy08 FROM rxy_file 
                 WHERE rxy00='21' AND rxy01=g_rxz01 and rxyplant= g_lpuplant and rxy03 = '02'
                DISPLAY l_rxy05 TO FORMONLY.rxy05
                DISPLAY l_rxy08 TO FORMONLY.rxy08
                LET g_lpu12 = g_lpu12 + g_rxz[l_ac].rxz05
                LET g_amt=g_lpu06-g_lpu12
                DISPLAY g_amt TO FORMONLY.amt
                UPDATE lpu_file SET lpu12=g_lpu12
                WHERE lpu01=g_rxz01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","lpu_file",g_rxz01,"",SQLCA.sqlcode,"","",1) 
                END IF   
             END if
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       BEFORE FIELD rxz03 
        IF cl_null(g_rxz[l_ac].rxz03) THEN     
           SELECT max(rxz03)+1 INTO g_rxz[l_ac].rxz03 FROM rxz_file      
            WHERE rxz00='21' AND rxz01= g_rxz01 AND rxzplant=g_lpuplant
           IF cl_null(g_rxz[l_ac].rxz03) OR g_rxz[l_ac].rxz03 <= 0 THEN 
              LET g_rxz[l_ac].rxz03 = 1 
           END IF      
        END IF      
               
       AFTER FIELD rxz03                        
         IF g_rxz[l_ac].rxz03 != g_rxz_t.rxz03 OR 
            g_rxz_t.rxz03 IS NULL THEN  
           SELECT COUNT(*) INTO l_cnt FROM rxz_file 
             WHERE rxz00='21' AND rxz01=g_rxz01
               AND rxz03=g_rxz[l_ac].rxz03
               AND rxzplant=g_lpuplant
           IF l_cnt > 0 THEN 
              CALL cl_err('','-239',1)
              LET g_rxz[l_ac].rxz03=g_rxz_t.rxz03
              NEXT FIELD rxz03
           END IF 
        END IF
          
       AFTER FIELD rxz05
          IF NOT cl_null(g_rxz[l_ac].rxz05) THEN  
             IF g_rxz[l_ac].rxz05<=0 THEN 
                CALL cl_err('','alm-192',1)
                LET g_rxz[l_ac].rxz05=g_rxz_t.rxz05
                NEXT FIELD rxz05
             END IF
             IF g_rxz[l_ac].rxz05 + g_lpu12 > g_lpu06 THEN 
                CALL cl_err('','alm-199',1)
                LET g_rxz[l_ac].rxz05=g_rxz_t.rxz05
                NEXT FIELD rxz05
             END IF
          END IF    
       
       AFTER FIELD rxz15
          IF p_cmd = 'a' THEN
             CALL t6201_set_entry_rxy15()
          END IF
       
       AFTER FIELD rxz10
          IF NOT cl_null(g_rxz[l_ac].rxz10) THEN
             IF g_rxz[l_ac].rxz10 > 1000 OR g_rxz[l_ac].rxz10 < 0 THEN
                CALL cl_err(g_rxz[l_ac].rxz10,'alm-352',0)
                NEXT FIELD rxz10
             ELSE
                LET g_rxz[l_ac].rxz09 = g_rxz[l_ac].rxz05 * g_rxz[l_ac].rxz10/1000
             END IF
          END IF
       
       AFTER FIELD rxz09
          IF NOT cl_null(g_rxz[l_ac].rxz09) THEN
             IF g_rxz[l_ac].rxz09 < 0 THEN
                CALL cl_err(g_rxz[l_ac].rxz09,'alm-061',0)
                NEXT FIELD rxz09
             END IF
          END IF
       
       BEFORE DELETE                            #是否取消單身
          IF (g_rxz_t.rxz03 IS NOT NULL) THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "rxz03"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_rxz[l_ac].rxz03      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF g_rxz_t.rxz13='Y' THEN
                CALL cl_err('','alm-190',1)
                CANCEL DELETE
             END IF    
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM rxz_file WHERE rxz01 = g_rxz01
                                    AND rxz03 = g_rxz_t.rxz03
                                    AND rxz00 = '21'
                                    AND rxzplant= g_lpuplant
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rxz_file",g_rxz_t.rxz03,"",SQLCA.sqlcode,"","",1)  
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
             LET g_rxz[l_ac].* = g_rxz_t.*
             CLOSE t6201_bcl
             CLOSE t6201_cl   #TQC-A30159
             ROLLBACK WORK
             EXIT INPUT
          END if
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_rxz[l_ac].rxz03,-263,0)
             LET g_rxz[l_ac].* = g_rxz_t.*
          ELSE  
             UPDATE rxz_file SET rxz03=g_rxz[l_ac].rxz03,
                                 rxz04=g_rxz[l_ac].rxz04,
                                 rxz05=g_rxz[l_ac].rxz05,
                                 rxz09=g_rxz[l_ac].rxz09,
                                 rxz10=g_rxz[l_ac].rxz10,
                                 rxz13=g_rxz[l_ac].rxz13,
                                 rxz15=g_rxz[l_ac].rxz15
              WHERE rxz00 ='21'
                AND rxz01 = g_rxz01
                AND rxz03 = g_rxz_t.rxz03
                AND rxzplant= g_lpuplant
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rxz_file",g_rxz_t.rxz03,"",SQLCA.sqlcode,"","",1)  
                LET g_rxz[l_ac].* = g_rxz_t.*
             ELSE
                IF g_rxz[l_ac].rxz13='Y' THEN 
                   SELECT MAX(rxy02) INTO g_rxy02 FROM rxy_file 
                    WHERE rxy00='21' AND rxy01= g_argv1 AND rxyplant=g_lpuplant
                   IF g_rxy02 IS NULL THEN 
                      LET g_rxy02=0
                   END IF 
                   LET g_rxy02=g_rxy02+1
                   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,
                                        rxy06,rxy07,rxy08,rxyplant,rxy20,rxy21,
                                        rxy22,rxylegal)
                   VALUES('21',g_rxz01,g_rxy02,'02','1',g_rxz[l_ac].rxz05,
                          g_rxz[l_ac].rxz04,g_rxz[l_ac].rxz10,g_rxz[l_ac].rxz09,
                          g_lpuplant,g_rxz[l_ac].rxz15,g_today,g_time,g_lpulegal)
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","rxy_file",g_rxz[l_ac].rxz03,"",SQLCA.sqlcode,"","",1) 
                   END IF
                END IF
                MESSAGE 'UPDATE O.K'
                CLOSE t6201_bcl
                CLOSE t6201_cl   #TQC-A30159
                COMMIT WORK
             END if
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            # 新增
          LET l_ac_t = l_ac                # 新增
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_rxz[l_ac].* = g_rxz_t.*
             END IF
             CLOSE t6201_bcl            # 新增
             CLOSE t6201_cl   #TQC-A30159
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          CLOSE t6201_bcl            # 新增
          CLOSE t6201_cl   #TQC-A30159
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(rxz03) AND l_ac > 1 THEN
             LET g_rxz[l_ac].* = g_rxz[l_ac-1].*
             NEXT FIELD rxz03
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
   CLOSE t6201_bcl
   CLOSE t6201_cl   #TQC-A30159
   COMMIT WORK
END FUNCTION
 
FUNCTION t6201_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 
    LET g_sql ="SELECT rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13",   
               " FROM rxz_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " AND rxz00 = '21' ",
               " and rxzplant='",g_lpuplant,"' ", 
               " ORDER BY rxz03"
    PREPARE t6201_pb FROM g_sql
    DECLARE rxz_curs CURSOR FOR t6201_pb
 
    CALL g_rxz.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rxz_curs INTO g_rxz[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_rxz.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.idx
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t6201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rxz TO s_rxz.* ATTRIBUTE(COUNT=g_rec_b)
 
   BEFORE ROW
       LET l_ac = ARR_CURR()
       CALL cl_show_fld_cont() 
       
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
         
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY         
    
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
         
      ON ACTION auto 
         LET g_action_choice="auto"
         EXIT DISPLAY
         
      ON ACTION swipecard 
         LET g_action_choice="swipecard"
         EXIT DISPLAY  
           
      ON ACTION transactions 
         LET g_action_choice="transactions"
         EXIT DISPLAY  
                       
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
 
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
 
FUNCTION t6201_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("rxz03",TRUE) 
   END if
END FUNCTION 
 
FUNCTION t6201_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' then
     CALL cl_set_comp_entry("rxz03",FALSE) 
   END IF
END FUNCTION                                                                    
      
FUNCTION t6201_set_entry_b()
     CALL cl_set_comp_entry("rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13",TRUE) 
END FUNCTION 
 
FUNCTION t6201_set_no_entry_b()
     CALL cl_set_comp_entry("rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13",FALSE) 
END FUNCTION  
 
FUNCTION t6201_set_entry_rxy15()
   IF g_rxz[l_ac].rxz15 = 'N' THEN
      CALL cl_set_comp_entry("rxz10",TRUE)
      CALL cl_set_comp_entry("rxz09",FALSE)
      LET g_rxz[l_ac].rxz10 = 0
      LET g_rxz[l_ac].rxz09 = ''
   ELSE
      CALL cl_set_comp_entry("rxz09",TRUE)
      CALL cl_set_comp_entry("rxz10",FALSE)
      LET g_rxz[l_ac].rxz10 = ''
      LET g_rxz[l_ac].rxz09 = 20
   END IF
   DISPLAY BY NAME g_rxz[l_ac].rxz09,g_rxz[l_ac].rxz10
END FUNCTION
#No.FUN-960134 
