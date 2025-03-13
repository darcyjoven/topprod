# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: almt6102.4gl
# Descriptions...: 儲值卡銀聯卡付款維護作業
# Date & Author..: NO.FUN-960058 09/06/12 By  destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuyin.
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A70053 10/07/13 by houlia 賦初值g_legal
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位 

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin
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
DEFINE g_argv1               LIKE lps_file.lps01
DEFINE g_amt                 LIKE lps_file.lps05
DEFINE g_rxz01               LIKE rxz_file.rxz01
DEFINE g_lpsplant            LIKE lps_file.lpsplant
DEFINE g_lpslegal            LIKE lps_file.lpslegal
#DEFINE g_lma04               LIKE rtz_file.lma04   #FUN-A80148
DEFINE g_azw07               LIKE azw_file.azw07    #FUN-A80148
DEFINE g_lps07               LIKE lps_file.lps07
DEFINE g_lps09               LIKE lps_file.lps09
DEFINE g_lps05               LIKE lps_file.lps05
DEFINE g_lps13               LIKE lps_file.lps13
DEFINE g_rxy05               LIKE rxy_file.rxy05
DEFINE g_rxy08               LIKE rxy_file.rxy08
DEFINE g_rxy02               LIKE rxy_file.rxy02
 
MAIN
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                       
 
    LET g_argv1 = ARG_VAL(1)
    LET g_rxz01   = NULL
    LET g_rxz01   = g_argv1
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   
    OPEN WINDOW t6102_w WITH FORM "alm/42f/almt6102" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()    
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = "rxz01 = '",g_argv1,"'"                   
    ELSE
    	 LET g_wc2 = " 1=1"
    END IF  
    SELECT lpsplant,lps13,lpslegal INTO g_lpsplant,g_lps13,g_lpslegal 
      FROM lps_file WHERE lps01=g_argv1 
 
    SELECT lps05,lps07,lps09 INTO g_lps05,g_lps07,g_lps09 FROM lps_file 
     WHERE lps01=g_argv1 
 
    IF cl_null(g_lps13) THEN 
       LET g_lps13=0
    END IF 
    IF cl_null(g_lps07) THEN 
       LET g_lps07=0
    END IF  
    LET g_amt=g_lps07-g_lps13
    IF g_amt<0 THEN 
       LET g_amt=0
    END IF     
    DISPLAY g_amt TO FORMONLY.amt
    SELECT SUM(rxy05),SUM(rxy08) INTO g_rxy05,g_rxy08 FROM rxy_file 
     WHERE rxy00='20' AND rxy01=g_argv1 AND rxy03='02'
    IF cl_null(g_rxy05) THEN 
       LET g_rxy05=0
    END IF 
    IF cl_null(g_rxy08) THEN 
       LET g_rxy08=0
    END IF  
    DISPLAY g_rxy05 TO FORMONLY.rxy05
    DISPLAY g_rxy08 TO FORMONLY.rxy08
    CALL t6102_b_fill(g_wc2)
    
    CALL t6102_menu()
    CLOSE WINDOW t6102_w    
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t6102_menu()
 
 DEFINE l_cmd   LIKE type_file.chr1000            
 
   WHILE TRUE
      CALL t6102_bp("G")
      CASE g_action_choice
                  
         WHEN "auto"
         
         WHEN "swipecard"
             IF cl_chk_act_auth() THEN
                CALL t6102_b()
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
 
FUNCTION t6102_b()
DEFINE
   l_ac_t          LIKE type_file.num5,           
   l_n             LIKE type_file.num5,    
   l_lock_sw       LIKE type_file.chr1,          
   p_cmd           LIKE type_file.chr1,         
   l_allow_insert  LIKE type_file.chr1,         
   l_allow_delete  LIKE type_file.chr1        
DEFINE l_rxy05     LIKE rxy_file.rxy05
DEFINE l_rxy08     LIKE rxy_file.rxy08
DEFINE l_time      LIKE rxy_file.rxy22 #No.FUN-A80008
 
   IF s_shut(0) THEN RETURN END IF
           
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   
   IF g_lps09 = 'Y' THEN
      CALL cl_err('','mfg1005',0)
      RETURN
   END IF
 
   IF g_amt=0 THEN
      CALL cl_err('','alm-225',1)
      RETURN
   END IF 
   
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13", 
                      "  FROM rxz_file WHERE rxz01= '",g_argv1,"' and ",
                      "  rxz03 = ? and rxz00='20'  ",
#                      "and rxzplant='",g_lpsplant,"' ",
                      "  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t6102_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_rxz WITHOUT DEFAULTS FROM s_rxz.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             LET l_ac=g_rec_b+1
             CALL fgl_set_arr_curr(l_ac)
#             CALL fgl_set_arr_curr(g_rec_b+1)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'           
          LET l_n  = ARR_COUNT()
          IF g_amt=0 THEN
             CALL cl_err('','alm-225',1)
             RETURN
          END IF 
          CALL t6102_set_entry_b()
          BEGIN WORK
          IF l_ac<=g_rec_b THEN 
             LET l_ac=g_rec_b+1
             CALL fgl_set_arr_curr(l_ac)
          END IF 
          IF g_rec_b>=l_ac THEN 
             LET p_cmd='u'               
             CALL t6102_set_no_entry_b() 
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                       
          CALL t6102_set_entry_b()                                    
          INITIALIZE g_rxz[l_ac].* TO NULL  
          LET g_rxz[l_ac].rxz13 = 'Y'  
          LET g_rxz[l_ac].rxz15='N'
          LET g_rxz[l_ac].rxz10=0
          CALL cl_set_comp_entry("rxz10",TRUE)
          CALL cl_set_comp_entry("rxz09",FALSE)
          LET g_rxz_t.* = g_rxz[l_ac].*        
          CALL cl_show_fld_cont()    
          NEXT FIELD rxz03
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE t6102_bcl
             CANCEL INSERT
          END IF
          LET l_time = TIME #No.FUN-A80008
          INSERT INTO rxz_file(rxz00,rxz01,rxz02,rxz03,rxz04,rxz05,rxz06,rxz07,rxz08,rxz09,rxz10,
                               rxz13,rxz14,rxz20,rxzplant,rxzlegal,rxz15) 
                 VALUES('20',g_argv1,'1',g_rxz[l_ac].rxz03,g_rxz[l_ac].rxz04,
                        g_rxz[l_ac].rxz05,g_today,l_time,g_user,g_rxz[l_ac].rxz09, #No.FUN-A80008
                        g_rxz[l_ac].rxz10,g_rxz[l_ac].rxz13,'S','2',g_lpsplant,g_lpslegal,
                        g_rxz[l_ac].rxz15)
 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rxz_file",g_rxz[l_ac].rxz03,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             IF g_rxz[l_ac].rxz13='Y' THEN 
                SELECT MAX(rxy02) INTO g_rxy02 FROM rxy_file WHERE rxy00='20' AND rxy01= g_argv1
                IF g_rxy02 IS NULL THEN 
                   LET g_rxy02=0
                END IF 
                LET g_rxy02=g_rxy02+1
          #     INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,rxy07,rxy08,rxy20,rxyplant,rxy21,rxy22) 
          #     VALUES('20',g_argv1,g_rxy02,'02','1',g_rxz[l_ac].rxz05,g_rxz[l_ac].rxz04,g_rxz[l_ac].rxz10,
          #            g_rxz[l_ac].rxz09,g_rxz[l_ac].rxz15,g_lpsplant,g_today,to_char(sysdate,'HH24:MI'))
                INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxy06,rxy07,rxy08,rxy20,rxyplant,rxy21,rxy22,rxylegal) 
                VALUES('20',g_argv1,g_rxy02,'02','1',g_rxz[l_ac].rxz05,g_rxz[l_ac].rxz04,g_rxz[l_ac].rxz10,
                      #g_rxz[l_ac].rxz09,g_rxz[l_ac].rxz15,g_lpsplant,g_today,to_char(sysdate,'HH24:MI'),g_legal)     #TQC-A70053houlia   add rxylegal
                       g_rxz[l_ac].rxz09,g_rxz[l_ac].rxz15,g_lpsplant,g_today,l_time,g_legal) #No.FUN-A80008
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","rxy_file",g_rxz[l_ac].rxz03,"",SQLCA.sqlcode,"","",1) 
                END IF 
                LET g_lps13=g_lps13+g_rxz[l_ac].rxz05
                LET g_amt=g_lps07-g_lps13
                IF g_amt<0 THEN 
                   LET g_amt=0
                END IF 
                UPDATE lps_file SET lps13=g_lps13
                              WHERE lps01=g_argv1
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","lps_file",g_argv1,"",SQLCA.sqlcode,"","",1) 
               END IF   
               SELECT SUM(rxy05),SUM(rxy08) INTO l_rxy05,l_rxy08 FROM rxy_file 
                WHERE rxy00='20' AND rxy01=g_argv1 AND rxy03='02'
               IF cl_null(l_rxy05) THEN 
                  LET l_rxy05=0 
               END IF 
               IF cl_null(l_rxy08) THEN 
                  LET l_rxy08=0 
               END IF
               DISPLAY l_rxy05 TO FORMONLY.rxy05
               DISPLAY l_rxy08 TO FORMONLY.rxy08
               DISPLAY g_amt TO FORMONLY.amt
             END IF
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.idx
             COMMIT WORK
          END IF
 
       BEFORE FIELD rxz03 
        IF cl_null(g_rxz[l_ac].rxz03) OR cl_null(g_rxz_t.rxz03) THEN     
           SELECT max(rxz03)+1 INTO g_rxz[l_ac].rxz03 FROM rxz_file      
            WHERE rxz00='20' AND rxz01= g_argv1   
           IF cl_null(g_rxz[l_ac].rxz03) OR g_rxz[l_ac].rxz03 <= 0 THEN 
              LET g_rxz[l_ac].rxz03 = 1 
           END IF      
        END IF      
               
       AFTER FIELD rxz03                        
         IF p_cmd='u' AND g_rxz[l_ac].rxz03 != g_rxz_t.rxz03 OR 
            g_rxz_t.rxz03 IS NULL THEN  
           SELECT COUNT(*) INTO l_n FROM rxz_file 
             WHERE rxz00='20' AND rxz01=g_argv1
               AND rxz03=g_rxz[l_ac].rxz03
               AND rxzplant=g_lpsplant
           IF l_n>0 THEN 
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
             ELSE 
             	  IF g_rxz[l_ac].rxz05+g_lps13>g_lps07 AND p_cmd != 'u' THEN 
             	     CALL cl_err('','alm-208',1)
             	     NEXT FIELD rxz05
             	  END IF 
             END IF          
          END IF   
           
       AFTER FIELD rxz15
          IF NOT cl_null(g_rxz[l_ac].rxz15) THEN
             IF g_rxz[l_ac].rxz15='Y' THEN 
                CALL cl_set_comp_entry("rxz10",FALSE)
                CALL cl_set_comp_entry("rxz09",TRUE)
                LET  g_rxz[l_ac].rxz10=0
                LET  g_rxz[l_ac].rxz09=20
             ELSE 
             	  CALL cl_set_comp_entry("rxz10",TRUE)
                CALL cl_set_comp_entry("rxz09",FALSE)
                LET g_rxz[l_ac].rxz09=g_rxz[l_ac].rxz05*g_rxz[l_ac].rxz10*0.001
             END IF 
             DISPLAY BY NAME g_rxz[l_ac].rxz09,g_rxz[l_ac].rxz10
          END IF
                 
       AFTER FIELD rxz10
             IF g_rxz[l_ac].rxz10<0 OR g_rxz[l_ac].rxz10>1000 THEN 
                CALL cl_err('','alm-352',1)
                LET g_rxz[l_ac].rxz10=g_rxz_t.rxz10
                NEXT FIELD rxz10
             ELSE 
             	  LET g_rxz[l_ac].rxz09=g_rxz[l_ac].rxz05*g_rxz[l_ac].rxz10/1000 
             END IF   
       AFTER FIELD rxz09
          IF NOT cl_null(g_rxz[l_ac].rxz09) THEN
             IF g_rxz[l_ac].rxz09 <=0 THEN
                CALL cl_err('','alm-061',1)
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
             DELETE FROM rxz_file WHERE rxz01 = g_argv1
                                    AND rxz03 = g_rxz_t.rxz03
                                    AND rxz00 = '20'
                                    AND rxzplant= g_lpsplant
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
             CLOSE t6102_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_rxz[l_ac].rxz03,-263,0)
             LET g_rxz[l_ac].* = g_rxz_t.*
          ELSE
             UPDATE rxz_file SET rxz04=g_rxz[l_ac].rxz04,
                                 rxz05=g_rxz[l_ac].rxz05,
                                 rxz09=g_rxz[l_ac].rxz09,
                                 rxz10=g_rxz[l_ac].rxz10,
                                 rxz13=g_rxz[l_ac].rxz13
              WHERE rxz00 ='20'
                AND rxz01 = g_argv1
                AND rxz03 = g_rxz_t.rxz03
                AND rxzplant= g_lpsplant
                
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rxz_file",g_rxz_t.rxz03,"",SQLCA.sqlcode,"","",1)  
                LET g_rxz[l_ac].* = g_rxz_t.*
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
                LET g_rxz[l_ac].* = g_rxz_t.*
             END IF
             CLOSE t6102_bcl            # 新增
             ROLLBACK WORK         # 新增
             EXIT INPUT
          END IF
 
          CLOSE t6102_bcl            # 新增
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
 
   CLOSE t6102_bcl
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION t6102_b_fill(p_wc2)              
 DEFINE   p_wc2           LIKE type_file.chr1000     
 
    LET g_sql ="SELECT rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13",   
               " FROM rxz_file ",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " AND rxz00 ='20' ",
               " AND rxzplant='",g_lpsplant,"' ", 
               " ORDER BY rxz03"
    PREPARE t6102_pb FROM g_sql
    DECLARE rxz_curs CURSOR FOR t6102_pb
 
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
 
FUNCTION t6102_bp(p_ud)
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
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################    
    
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
         
      ON ACTION auto 
         LET g_action_choice="auto"
         EXIT DISPLAY
         
      ON ACTION swipecard 
         LET g_action_choice="swipecard"
         EXIT DISPLAY  
           
      ON ACTION transactions 
         LET g_action_choice="transactions"
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
                                            
FUNCTION t6102_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                         
                                                                                  
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("rxz03",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION t6102_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                               
                                                                                  
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("rxz03",FALSE)                                      
   END IF                                                                       
                                            
END FUNCTION                                                                    
      
FUNCTION t6102_set_entry_b()
     CALL cl_set_comp_entry("rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13",TRUE) 
END FUNCTION 
 
FUNCTION t6102_set_no_entry_b()
     CALL cl_set_comp_entry("rxz03,rxz04,rxz05,rxz15,rxz10,rxz09,rxz13",FALSE) 
END FUNCTION  
 
 
 
