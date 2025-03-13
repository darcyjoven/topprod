# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
#Pattern name..:"arti108.4gl"
#Descriptions..: 聯盟卡卡種維護作業
#Date & Author..:09/06/15S By lala
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-870007 09/12/09 By Cockroach PASS NO.
# Modify.........: No.FUN-9C0168 10/01/04 BY lutingting 會計科目改由axri050維護 ,本支作業拿掉科目相關欄位 
# Modify.........: No:FUN-A10012 10/01/06 By destiny rxw03可以等于0
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A30030 10/03/10 By Cockroach ADD POS?
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No:TQC-B60009 11/06/02 By lixia 修改p_query
# Modify.........: No:FUN-B70075 11/10/25 By yangxf 更新已传pos否的状态
# Modify.........: No:FUN-C50036 12/06/14 By yangxf pos<>'1'时noentry主键栏位
# Modify.........: No:FUN-D30033 13/04/10 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_rxw           DYNAMIC ARRAY OF RECORD
        rxw01       LIKE rxw_file.rxw01,
        rxw02       LIKE rxw_file.rxw02,
        rxw03       LIKE rxw_file.rxw03,
       #FUN-9C0168--mark--str--
       #rxw04       LIKE rxw_file.rxw04,
       #rxw04_desc  LIKE aag_file.aag02,
       #rxw05       LIKE rxw_file.rxw05,
       #rxw05_desc  LIKE aag_file.aag02,
       #FUN-9C0168--mark--end
        rxw06       LIKE rxw_file.rxw06,
        rxwacti     LIKE rxw_file.rxwacti,
        rxwpos      LIKE rxw_file.rxwpos        #FUN-A30030 ADD
                    END RECORD,
    g_rxw_t         RECORD
        rxw01       LIKE rxw_file.rxw01,
        rxw02       LIKE rxw_file.rxw02,
        rxw03       LIKE rxw_file.rxw03,
       #FUN-9C0168--mark--str--
       #rxw04       LIKE rxw_file.rxw04,
       #rxw04_desc  LIKE aag_file.aag02,
       #rxw05       LIKE rxw_file.rxw05,
       #rxw05_desc  LIKE aag_file.aag02,
       #FUN-9C0168--mark--end
        rxw06       LIKE rxw_file.rxw06,
        rxwacti     LIKE rxw_file.rxwacti,
        rxwpos      LIKE rxw_file.rxwpos        #FUN-A30030 ADD
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5, 
    l_ac            LIKE type_file.num5  
 
DEFINE g_forupd_sql STRING   
DEFINE   g_cnt           LIKE type_file.num10  
DEFINE   g_i             LIKE type_file.num5   
DEFINE g_before_input_done   LIKE type_file.num5 
DEFINE p_row,p_col       LIKE type_file.num5  
DEFINE l_cmd               LIKE type_file.chr1000
 
MAIN
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT    
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)  
         RETURNING g_time  
    LET p_row = 4 LET p_col = 15
    OPEN WINDOW arti108_w AT p_row,p_col WITH FORM "art/42f/arti108"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible('rxw05,rxw05_desc',FALSE)
    END IF
 
  #FUN-A30030 ADD---------------------------
   IF g_aza.aza88 = 'N' THEN
      CALL cl_set_comp_visible('rxwpos',FALSE)
   ELSE
      CALL cl_set_comp_visible('rxwpos',TRUE)
   END IF
  #FUN-A30030 END---------------------------
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL arti108_b_fill(g_wc2)
    CALL arti108_menu()
    CLOSE WINDOW arti108_w     
      CALL  cl_used(g_prog,g_time,2) 
         RETURNING g_time 
END MAIN
 
FUNCTION arti108_menu()
 DEFINE l_cmd   LIKE type_file.chr1000   
   WHILE TRUE
      CALL arti108_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL arti108_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL arti108_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL arti108_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_rxw[l_ac].rxw01 IS NOT NULL THEN
                  LET g_doc.column1 = "rxw01"
                  LET g_doc.value1 = g_rxw[l_ac].rxw01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rxw),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION arti108_q()
   CALL arti108_b_askkey()
END FUNCTION
 
#FUN-9C0168--mark--str--
#FUNCTION i108_rxw04(p_cmd)         
#DEFINE    l_rxw04_desc  LIKE aag_file.aag02,  
#          p_cmd         LIKE type_file.chr1
 
#  SELECT aag02 INTO l_rxw04_desc FROM aag_file WHERE aag00=g_aza.aza81 AND aag01 = g_rxw[l_ac].rxw04 AND aagacti='Y'
 
# IF cl_null(g_errno) OR p_cmd = 'd' THEN
#    LET g_rxw[l_ac].rxw04_desc = l_rxw04_desc
#    DISPLAY BY NAME g_rxw[l_ac].rxw04_desc
# END IF
 
#END FUNCTION
 
#FUNCTION i108_rxw05(p_cmd)         
#DEFINE    l_rxw05_desc  LIKE aag_file.aag02,  
#          p_cmd         LIKE type_file.chr1
 
# SELECT aag02 INTO l_rxw05_desc FROM aag_file WHERE aag00=g_aza.aza82 AND aag01 = g_rxw[l_ac].rxw05 AND aagacti='Y'

# IF cl_null(g_errno) OR p_cmd = 'd' THEN
#    LET g_rxw[l_ac].rxw05_desc = l_rxw05_desc
#    DISPLAY BY NAME g_rxw[l_ac].rxw05_desc
# END IF
 
#END FUNCTION
#FUN-9C0168--mark--end
 
FUNCTION arti108_b()
DEFINE
   l_ac_t          LIKE type_file.num5, 
   l_n             LIKE type_file.num5, 
   l_lock_sw       LIKE type_file.chr1, 
   p_cmd           LIKE type_file.chr1, 
   l_allow_insert  LIKE type_file.chr1, 
   l_allow_delete  LIKE type_file.chr1   
DEFINE l_rxwpos    LIKE rxw_file.rxwpos  #FUN-B70075 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   #LET g_forupd_sql = "SELECT rxw01,rxw02,rxw03,rxw04,'',rxw05,'',rxw06,rxwacti",   #FUN-9C0168
   LET g_forupd_sql = "SELECT rxw01,rxw02,rxw03,rxw06,rxwacti,rxwpos",   #FUN-9C0168 #FUN-A30030 add POS
                      "  FROM rxw_file WHERE rxw01= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i108_bcl CURSOR FROM g_forupd_sql 
 
   INPUT ARRAY g_rxw WITHOUT DEFAULTS FROM s_rxw.*
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
             LET p_cmd='u'
             LET g_rxw_t.* = g_rxw[l_ac].*
 
             LET g_before_input_done = FALSE                                                                                      
             CALL arti108_set_entry(p_cmd)                                                                                           
             CALL arti108_set_no_entry(p_cmd)                                                                                        
#FUN-C50036 add begin ---
             IF g_aza.aza88 = 'Y' THEN
                IF g_rxw[l_ac].rxwpos <> '1' THEN
                   CALL cl_set_comp_entry("ryd01",FALSE)
                ELSE
                   CALL arti108_set_entry(p_cmd)
                   CALL arti108_set_no_entry(p_cmd)
                END IF 
             END IF 
#FUN-C50036 add end ---
             LET g_before_input_done = TRUE
             #FUN-B70075 Begin---
             IF g_aza.aza88 = 'Y' THEN
                 UPDATE rxw_file SET rxwpos = '4'
                  WHERE rxw01 = g_rxw[l_ac].rxw01
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rxw_file",g_rxw_t.rxw01,"",SQLCA.sqlcode,"","",1)   
                    LET l_lock_sw = "Y"
                 END IF
                 LET l_rxwpos = g_rxw[l_ac].rxwpos
                 LET g_rxw[l_ac].rxwpos = '4'
                 DISPLAY BY NAME g_rxw[l_ac].rxwpos
             END IF
             #FUN-B70075 End-----             
             BEGIN WORK
             OPEN i108_bcl USING g_rxw_t.rxw01
             IF STATUS THEN
                CALL cl_err("OPEN i108_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i108_bcl INTO g_rxw[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_rxw_t.rxw01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
               #CALL i108_rxw04('a')   #FUN-9C0168
               #CALL i108_rxw05('a')   #FUN-9C0168
             END IF
             CALL cl_show_fld_cont()  
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                       
          LET g_before_input_done = FALSE                                                                                         
          CALL arti108_set_entry(p_cmd)                                                                                              
          CALL arti108_set_no_entry(p_cmd)                                                                                           
          LET g_before_input_done = TRUE
          INITIALIZE g_rxw[l_ac].* TO NULL 
          LET g_rxw[l_ac].rxw06 = 'N'
          LET g_rxw[l_ac].rxwacti = 'Y'
          LET g_rxw[l_ac].rxw03=0 
          #LET g_rxw[l_ac].rxwpos  = 'N'  #FUN-A30030 ADD
          LET g_rxw[l_ac].rxwpos  = '1'  #NO.FUN-B40071
          LET l_rxwpos = '1'              #FUN-B70075
          LET g_rxw_t.* = g_rxw[l_ac].*   
          CALL cl_show_fld_cont()   
          NEXT FIELD rxw01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i108_bcl
             CANCEL INSERT
          END IF
          #INSERT INTO rxw_file(rxw01,rxw02,rxw03,rxw04,rxw05,rxw06,rxwacti)   #FUN-9C0168
          INSERT INTO rxw_file(rxw01,rxw02,rxw03,rxw06,rxwacti,rxwpos)   #FUN-9C0168 #FUN-A30030 ADD
          VALUES(g_rxw[l_ac].rxw01,g_rxw[l_ac].rxw02,g_rxw[l_ac].rxw03,
                 #g_rxw[l_ac].rxw04,g_rxw[l_ac].rxw05,g_rxw[l_ac].rxw06,g_rxw[l_ac].rxwacti) #FUN-9C0168
                 g_rxw[l_ac].rxw06,g_rxw[l_ac].rxwacti,g_rxw[l_ac].rxwpos) #FUN-9C0168 #FUN-A30030 ADD 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","rxw_file",g_rxw[l_ac].rxw01,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD rxw01  
          IF NOT cl_null(g_rxw[l_ac].rxw01) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rxw[l_ac].rxw01!=g_rxw_t.rxw01) THEN
                SELECT COUNT(*) INTO l_n FROM rxw_file WHERE rxw01 = g_rxw[l_ac].rxw01
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_rxw[l_ac].rxw01 = g_rxw_t.rxw01
                   NEXT FIELD rxw01
                END IF
             END IF
          END IF
       
        AFTER FIELD rxw03 
            IF NOT cl_null(g_rxw[l_ac].rxw03)  THEN
              #IF g_rxw[l_ac].rxw03<=0 THEN           #No.FUN-A10012
               IF g_rxw[l_ac].rxw03<0 THEN            #No.FUN-A10012     
                  CALL cl_err('','aim-223',0)
                  NEXT FIELD rxw03
               END IF
            END IF
 
       #FUN-9C0168--mark--str--
       #AFTER FIELD rxw04
       #   IF NOT cl_null(g_rxw[l_ac].rxw04) THEN
       #      SELECT COUNT(*) INTO l_n FROM aag_file WHERE aag00=g_aza.aza81 AND aag01=g_rxw[l_ac].rxw04 AND aagacti='Y'
       #      IF l_n>0 THEN
       #         CALL i108_rxw04('a')
       #      ELSE
       #         CALL cl_err('','afa-025',0)
       #         LET g_rxw[l_ac].rxw04=g_rxw_t.rxw04
       #         DISPLAY BY NAME g_rxw[l_ac].rxw04
       #         NEXT FIELD rxw04
       #      END IF
       #   END IF
 
       #AFTER FIELD rxw05
       #   IF NOT cl_null(g_rxw[l_ac].rxw05) THEN
       #      SELECT COUNT(*) INTO l_n FROM aag_file WHERE aag00=g_aza.aza82 AND aag01=g_rxw[l_ac].rxw05 AND aagacti='Y'
       #      IF l_n>0 THEN
       #         CALL i108_rxw05('a')
       #      ELSE
       #         CALL cl_err('','afa-025',0)
       #         LET g_rxw[l_ac].rxw05=g_rxw_t.rxw05
       #         DISPLAY BY NAME g_rxw[l_ac].rxw05
       #         NEXT FIELD rxw05
       #      END IF
       #   END IF
       #FUN-9C0168--mark--end
 
       BEFORE DELETE     
          IF g_rxw_t.rxw01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
            #FUN-A30030 ADD-------------------
             IF g_aza.aza88='Y' THEN 
               #FUN-B40071 --START--
                #IF g_rxw[l_ac].rxwpos ='N' OR g_rxw[l_ac].rxwacti='Y' THEN
                #   CALL cl_err("", 'art-648',0)
                #   CANCEL DELETE
                #END IF
               #FUN-B70075 Begin---
               #IF NOT ((g_rxw[l_ac].rxwpos='3' AND g_rxw[l_ac].rxwacti='N') 
               #           OR (g_rxw[l_ac].rxwpos='1'))  THEN
                IF NOT ((l_rxwpos='3' AND g_rxw_t.rxwacti='N')
                              OR (l_rxwpos='1'))  THEN
               #FUN-B70075 End-----                      
                   CALL cl_err('','apc-139',0) 
                   CANCEL DELETE           
                   RETURN
                END IF  
               #FUN-B40071 --END--
             END IF
            #FUN-A30030 END---------------
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "rxw01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_rxw[l_ac].rxw01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM rxw_file WHERE rxw01 = g_rxw_t.rxw01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","rxw_file",g_rxw_t.rxw01,"",SQLCA.sqlcode,"","",1) 
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN     
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_rxw[l_ac].* = g_rxw_t.*
             CLOSE i108_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_rxw[l_ac].rxw01,-263,0)
             LET g_rxw[l_ac].* = g_rxw_t.*
          ELSE
            #FUN-A30030 ADD-------------------
             IF g_aza.aza88='Y' THEN
               #FUN-B40071 --START-- 
                #LET g_rxw[l_ac].rxwpos ='N'
                #FUN-B70075 Begin--- 
                #IF g_rxw[l_ac].rxwpos <> '1' THEN
                 IF l_rxwpos <> '1' THEN
                    LET g_rxw[l_ac].rxwpos ='2'
                 ELSE 
                    LET g_rxw[l_ac].rxwpos = '1'
                 END IF 
                #   LET g_rxw[l_ac].rxwpos ='2'
                #END IF 
                #FUN-B70075 End-----
               #FUN-B40071 --END--
                DISPLAY BY NAME g_rxw[l_ac].rxwpos
             END IF
            #FUN-A30030 END---------------
             UPDATE rxw_file SET rxw01=g_rxw[l_ac].rxw01,
                                 rxw02=g_rxw[l_ac].rxw02,
                                 rxw03=g_rxw[l_ac].rxw03,
                                #rxw04=g_rxw[l_ac].rxw04,   #FUN-9C0168
                                #rxw05=g_rxw[l_ac].rxw05,   #FUN-9C0168
                                 rxw06=g_rxw[l_ac].rxw06,
                                 rxwacti=g_rxw[l_ac].rxwacti,
                                 rxwpos=g_rxw[l_ac].rxwpos     #FUN-A30030 ADD
              WHERE rxw01 = g_rxw_t.rxw01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","rxw_file",g_rxw_t.rxw01,"",SQLCA.sqlcode,"","",1) 
                LET g_rxw[l_ac].* = g_rxw_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()      
         #LET l_ac_t = l_ac       #FUN-D30033 Mark   
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_rxw[l_ac].* = g_rxw_t.*
             END IF
             CLOSE i108_bcl    
             ROLLBACK WORK  
            #FUN-B70075 Begin---
             IF p_cmd = 'a' THEN
                 CALL g_rxw.deleteElement(l_ac)
                 #FUN-D30033--add--str--
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
                 #FUN-D30033--add--end--
             END IF
             IF p_cmd='u' THEN
                IF g_aza.aza88 = 'Y' THEN
                   UPDATE rxw_file SET rxwpos = l_rxwpos
                    WHERE rxw01 = g_rxw[l_ac].rxw01
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","rxw_file",g_rxw_t.rxw01,"",SQLCA.sqlcode,"","",1)
                      LET l_lock_sw = "Y"
                   END IF
                   LET g_rxw[l_ac].rxwpos = l_rxwpos
                   DISPLAY BY NAME g_rxw[l_ac].rxwpos
                END IF
             END IF
            #FUN-B70075 End-----             
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac       #FUN-D30033 Add
          CLOSE i108_bcl    
          COMMIT WORK
 
       ON ACTION CONTROLO            
          IF INFIELD(rxw01) AND l_ac > 1 THEN
             LET g_rxw[l_ac].* = g_rxw[l_ac-1].*
             NEXT FIELD rxw01
          END IF
 
      #FUN-9C0168--mark--str--
      #ON ACTION controlp
      # CASE
      #    WHEN INFIELD(rxw04)
      #       CALL cl_init_qry_var()
      #       LET g_qryparam.form = "q_aag"
      #       LET g_qryparam.arg1 = g_aza.aza81
      #       LET g_qryparam.default1 = g_rxw[l_ac].rxw04
      #       CALL cl_create_qry() RETURNING g_rxw[l_ac].rxw04
      #       DISPLAY BY NAME g_rxw[l_ac].rxw04
      #       NEXT FIELD rxw04
      #    WHEN INFIELD(rxw05)
      #       CALL cl_init_qry_var()
      #       LET g_qryparam.form = "q_aag"
      #       LET g_qryparam.arg1 = g_aza.aza82
      #       LET g_qryparam.default1 = g_rxw[l_ac].rxw05
      #       CALL cl_create_qry() RETURNING g_rxw[l_ac].rxw05
      #       DISPLAY BY NAME g_rxw[l_ac].rxw05
      #       NEXT FIELD rxw05
      #    OTHERWISE
      #       EXIT CASE
      # END CASE
      #FUN-9C0168--mark--end
 
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
 
   CLOSE i108_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION arti108_b_askkey()
 
   CLEAR FORM
   CALL g_rxw.clear()
  #FUN-9C0168--mod--str--
  #CONSTRUCT g_wc2 ON rxw01,rxw02,rxw03,rxw04,rxw05,rxw06,rxwacti
  #     FROM s_rxw[1].rxw01,s_rxw[1].rxw02,s_rxw[1].rxw03,s_rxw[1].rxw04,
  #          s_rxw[1].rxw05,s_rxw[1].rxw06,s_rxw[1].rxwacti
   CONSTRUCT g_wc2 ON rxw01,rxw02,rxw03,rxw06,rxwacti,rxwpos    #FUN-A30030 ADD POS
        FROM s_rxw[1].rxw01,s_rxw[1].rxw02,s_rxw[1].rxw03,
             s_rxw[1].rxw06,s_rxw[1].rxwacti,s_rxw[1].rxwpos     #FUN-A30030 ADD POS
  #FUN-9C0168--mod--end
 
 
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
 
     #FUN-9C0168--mark--str--
     #ON ACTION controlp
     #  CASE
     #     WHEN INFIELD(rxw04)
     #        CALL cl_init_qry_var()
     #        LET g_qryparam.form = "q_rxw04"
     #        LET g_qryparam.state = "c"
     #        LET g_qryparam.arg1 = g_aza.aza81
     #        CALL cl_create_qry() RETURNING g_qryparam.multiret
     #        DISPLAY g_qryparam.multiret TO rxw04
     #        NEXT FIELD rxw04
     #     WHEN INFIELD(rxw05)
     #        CALL cl_init_qry_var()
     #        LET g_qryparam.form = "q_rxw05"
     #        LET g_qryparam.state = "c"
     #        LET g_qryparam.arg1 = g_aza.aza82
     #        CALL cl_create_qry() RETURNING g_qryparam.multiret
     #        DISPLAY g_qryparam.multiret TO rxw05
     #        NEXT FIELD rxw05
     #     OTHERWISE
     #        EXIT CASE
     #  END CASE
     #FUN-9C0168--mark--end
 
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
	 CALL cl_qbe_save()
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('rxwuser', 'rxwgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL arti108_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION arti108_b_fill(p_wc2)   
DEFINE
    p_wc2           LIKE type_file.chr1000 
 
    LET g_sql =
        #"SELECT rxw01,rxw02,rxw03,rxw04,'',rxw05,'',rxw06,rxwacti",   #FUN-9C0168
        "SELECT rxw01,rxw02,rxw03,rxw06,rxwacti,rxwpos",   #FUN-9C0168  #FUN-A30030 ADD rxwpos
        " FROM rxw_file ",
        " WHERE ", p_wc2 CLIPPED,      
        " ORDER BY 1"
    PREPARE arti108_pb FROM g_sql
    DECLARE rxw_curs CURSOR FOR arti108_pb
 
    CALL g_rxw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rxw_curs INTO g_rxw[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       #SELECT aag02 INTO g_rxw[g_cnt].rxw04_desc FROM aag_file WHERE aag00=g_aza.aza81 AND aag01 = g_rxw[g_cnt].rxw04 AND aagacti = 'Y'  #FUN-9C0168
       #SELECT aag02 INTO g_rxw[g_cnt].rxw05_desc FROM aag_file WHERE aag00=g_aza.aza81 AND aag01 = g_rxw[g_cnt].rxw05 AND aagacti = 'Y'  #FUN-9C0168
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rxw.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION arti108_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rxw TO s_rxw.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()      
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
 
FUNCTION arti108_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("rxw01",TRUE)
        END IF
END FUNCTION
 
FUNCTION arti108_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("rxw01",FALSE)
        END IF
END FUNCTION
 
FUNCTION arti108_out()
#p_query
DEFINE l_cmd  STRING
 
    IF cl_null(g_wc2) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    #IF g_aza.aza63='Y' THEN
    IF g_aza.aza88='Y' THEN   #TQC-B60009
       LET l_cmd = 'p_query "arti108" "',g_wc2 CLIPPED,'"'
    ELSE
       LET l_cmd = 'p_query "arti108_1" "',g_wc2 CLIPPED,'"'
    END IF
    CALL cl_cmdrun(l_cmd)
 
END FUNCTION
#FUN-870007 PASS  NO.
