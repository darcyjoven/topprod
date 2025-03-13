# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrp402.4gl
# Descriptions...: 應收帳款沖帳整批確認
# Author.........: NO.FUN-A40046 10/08/26 BY vealxu 
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B50248 11/06/10 By wujie    修改对axr-995的判断条件

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql    string        #FUN-A40046
DEFINE g_ooa         RECORD LIKE ooa_file.*
DEFINE g_t1          LIKE oay_file.oayslip 
DEFINE p_row,p_col   LIKE type_file.num5   
DEFINE g_cnt         LIKE type_file.num10       
DEFINE i             LIKE type_file.num5,         
       g_change_lang LIKE type_file.chr1  
DEFINE g_bookno1     LIKE aza_file.aza81  
DEFINE g_bookno2     LIKE aza_file.aza82 
DEFINE g_flag        LIKE type_file.chr1 
DEFINE b_oob         RECORD LIKE oob_file.*
DEFINE g_forupd_sql  STRING                      
DEFINE tot,tot1,tot2 LIKE type_file.num20_6    
DEFINE tot3          LIKE type_file.num20_6   
DEFINE un_pay1,un_pay2  LIKE type_file.num20_6      
DEFINE g_net            LIKE apv_file.apv04            
DEFINE g_wc_gl          STRING                        
DEFINE g_str            STRING                          
DEFINE g_ok             LIKE type_file.num10
MAIN
DEFINE l_flag        LIKE type_file.chr1   
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT

   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET g_bgjob = ARG_VAL(2)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0095
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p402_tm()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p402_process()
            CALL s_showmsg()   
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p402_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p402_process()
         CALL s_showmsg()   
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN

FUNCTION p402_tm()
DEFINE    lc_cmd        LIKE type_file.chr1000      
DEFINE l_flag        LIKE type_file.chr1   

   OPEN WINDOW p402_w AT p_row,p_col WITH FORM "axr/42f/axrp402"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()

    WHILE TRUE
       CLEAR FORM
       MESSAGE   ""
       CALL cl_opmsg('w')
       CONSTRUCT BY NAME g_wc ON ooa01,ooa02,ooa03

        BEFORE CONSTRUCT
           CALL cl_qbe_init()

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 

        ON ACTION locale
           LET g_change_lang = TRUE
           EXIT CONSTRUCT

        ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT

        ON ACTION qbe_select
           CALL cl_qbe_select()

         
        ON ACTION qbe_save
           CALL cl_qbe_save()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ooa01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ooa"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ooa01
                NEXT FIELD ooa01
              WHEN INFIELD(ooa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"  
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa03
                 NEXT FIELD ooa03
           END CASE

       END CONSTRUCT
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0 
          CLOSE WINDOW p402_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       IF g_wc = ' 1=1'
          THEN CALL cl_err('','9046',0) CONTINUE WHILE
       END IF

       LET g_bgjob = "N" 

       INPUT BY NAME g_bgjob WITHOUT DEFAULTS 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            call cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION about         #BUG-4C0121
            CALL cl_about()      #BUG-4C0121
         ON ACTION help          #BUG-4C0121
            CALL cl_show_help()  #BUG-4C0121
         ON ACTION exit      #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p402_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axrp402"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axrp402','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axrp402',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p402_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p402_process()
   LET g_forupd_sql = "SELECT * FROM ooa_file WHERE ooa01 = ? FOR UPDATE "
   CALL cl_forupd_sql(g_forupd_sql) RETURNING g_forupd_sql 
   DECLARE p402_cl CURSOR FROM g_forupd_sql
  
   LET g_sql="SELECT * FROM ooa_file WHERE ",g_wc CLIPPED,
             "  AND ooaconf='N'",
             "    AND (ooamksg = 'N' OR (ooamksg = 'Y' AND ooa34 = '1')) " 
   PREPARE p402_prepare FROM g_sql
   DECLARE p402_cs CURSOR WITH HOLD FOR p402_prepare
   CALL s_showmsg_init() 
   LET g_ok = 0
   FOREACH p402_cs INTO g_ooa.*
     IF STATUS THEN CALL s_errmsg('','','p402(foreach):',STATUS,1) EXIT FOREACH END IF
     IF g_success='N' THEN                                                                                                        
        LET g_totsuccess='N'                                                                                                      
        LET g_success="Y"                                                                                                         
     END IF                                                                                                                       
     BEGIN WORK
     IF g_ooa.ooa02<=g_ooz.ooz09 THEN 
        CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-164',1)
        CONTINUE FOREACH
     END IF
     LET g_t1=s_get_doc_no(g_ooa.ooa01) 
     SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
     IF STATUS THEN
       LET g_success = 'N'
       RETURN
     END IF
     CALL s_get_bookno(YEAR(g_ooa.ooa02))                                                                                   
          RETURNING g_flag,g_bookno1,g_bookno2                                                                              
     IF g_flag = '1' THEN     #抓不到帳別                                                                                   
        CALL s_errmsg('ooa02',g_ooa.ooa02,'','aoo-081',1)
        LET g_success = 'N'
        RETURN
     END IF                                                                                                                 
     CALL p402_y_chk()
     IF g_success = 'Y' THEN
         CALL p402_y_upd()
         IF g_success = 'Y' THEN LET g_ok = g_ok + 1 END IF
     END IF
   END FOREACH
   #有1筆以上成功
   IF g_ok>0 THEN
      LET g_success = "Y"        #批次作業正確結束
     #DISPLAY g_ok TO g_cnt  #CHI-A70049 mark
   ELSE
      LET g_success = "N"        #批次作業失敗
   END IF
END FUNCTION

FUNCTION p402_y_chk()                # when g_ooa.ooaconf='N' (Turn to 'Y')
   DEFINE l_cnt      LIKE type_file.num5     
   DEFINE l_oma00    LIKE oma_file.oma00   
   DEFINE l_apa00    LIKE apa_file.apa00   
   DEFINE l_sql      STRING               
   DEFINE l_oob      RECORD      
             oob03    LIKE oob_file.oob03,
             oob04    LIKE oob_file.oob04,
             oob06    LIKE oob_file.oob06
                     END RECORD  

   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
   IF g_ooa.ooaconf = 'X' THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','9024',1) 
      LET g_success = 'N'
      RETURN
   END IF

   IF g_ooa.ooaconf = 'Y' THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-101',1) 
      LET g_success = 'N'
      RETURN
   END IF

   IF g_ooa.ooa32d != g_ooa.ooa32c THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-203',1) 
      LET g_success = 'N'
      RETURN
   END IF

   IF g_ooa.ooa02 <= g_ooz.ooz09 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-164',1) 
      LET g_success = 'N'
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01 = g_ooa.ooa01
   IF l_cnt = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','mfg-009',1) 
      LET g_success = 'N'                  
      RETURN
   END IF
   
   LET l_sql = "SELECT oob03,oob04,oob06 FROM oob_file",
               " WHERE oob01 = '",g_ooa.ooa01,"'",
               "   AND ((oob03 = '1' AND (oob04='3' OR oob04='9'))",   
               "    OR  (oob03 = '2' AND (oob04='1' OR oob04='9')))"   
   PREPARE oob06_pb FROM l_sql
   DECLARE oob06_cl CURSOR FOR oob06_pb                                 
                        
   FOREACH oob06_cl INTO l_oob.*
      IF STATUS THEN 
         CALL s_errmsg('','','Foreach oob06_cl',STATUS,1) 
         LET g_success = 'N'
         EXIT FOREACH 
      END IF
  
      IF l_oob.oob03='1' THEN                         
         IF l_oob.oob04 = '3' THEN 
            SELECT oma00 INTO l_oma00 FROM oma_file
             WHERE oma01 = l_oob.oob06
            IF (l_oma00 != '21') AND (l_oma00 != '22') AND
               (l_oma00 != '24') AND (l_oma00 != '25') THEN  
               CALL s_errmsg('oob06',l_oob.oob06,'','axr-992',1)  
               LET g_success = 'N'
               EXIT FOREACH                
            END IF 
         END IF 
         IF l_oob.oob04 = '9' THEN 
            SELECT apa00 INTO l_apa00 FROM apa_file
             WHERE apa01 = l_oob.oob06
               AND apa02 <= g_ooa.ooa02 
            IF (l_apa00 != '11') AND (l_apa00 != '12') AND (l_apa00 != '15') THEN 
               CALL s_errmsg('oob06',l_oob.oob06,'','axr-993',1)  
               LET g_success = 'N'
               EXIT FOREACH            
            END IF   
         END IF                
      END IF      
              
      IF l_oob.oob03='2' THEN
         IF l_oob.oob04 = '1' THEN 
            SELECT oma00 INTO l_oma00 FROM oma_file
             WHERE oma01 = l_oob.oob06
            IF (l_oma00 !='11') AND (l_oma00 !='12') AND
               (l_oma00 !='13') AND (l_oma00 !='14') THEN 
               CALL s_errmsg('oob06',l_oob.oob06,'','axr-994',1)  
               LET g_success = 'N'
               EXIT FOREACH            
            END IF 
         END IF 
         IF l_oob.oob04 = '9' THEN 
            SELECT apa00 INTO l_apa00 FROM apa_file
             WHERE apa01 = l_oob.oob06
               AND apa02 <= g_ooa.ooa02 
#no.MOD-B50248--begin
            IF l_apa00 NOT MATCHES '2*' THEN
#           IF (l_apa00 !='21') AND (l_apa00 !='22') AND
#              (l_apa00 !='23') AND (l_apa00 !='24') THEN 
#no.MOD-B50248--end
               CALL s_errmsg('oob06',l_oob.oob06,'','axr-995',1)  
               LET g_success = 'N'
               EXIT FOREACH          
            END IF   
         END IF                    
      END IF    
   END FOREACH 
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p402_y_upd()
DEFINE l_cnt  LIKE type_file.num5      

   IF g_ooz.ooz62='Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01 = g_ooa.ooa01
         AND oob03 = '2'
         AND oob04 = '1'
         AND (oob06 IS NULL OR oob06 = ' ' OR oob15 IS NULL OR oob15 <= 0 )

      IF cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF
 
      IF l_cnt > 0 THEN
         CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-900',1) 
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt
     FROM oob_file,oma_file
    WHERE oma02 > g_ooa.ooa02
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01

   IF g_cnt >0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-371',1) 
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'N' THEN  
      CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)  
      IF g_aza.aza63='Y' AND g_success='Y' THEN          
         CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2) 
      END IF                                            
    # LET g_dbs_new = s_dbstring(g_dbs CLIPPED) 
      LET g_plant_new = g_plant 
   END IF

   IF g_success = 'N' THEN
      RETURN
   END IF

   OPEN p402_cl USING g_ooa.ooa01
   IF STATUS THEN
      CALL s_errmsg('','','OPEN p402_cl',STATUS,1)  
      LET g_success = 'N'
      CLOSE p402_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH p402_cl INTO g_ooa.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL s_errmsg('ooa01',g_ooa.ooa01,'fetch p402_cl',SQLCA.sqlcode,1) 
       LET g_success = 'N'
       CLOSE p402_cl
       ROLLBACK WORK
       RETURN
   END IF

   LET g_ooa.ooa34 = '1'
   UPDATE ooa_file SET ooa34 = g_ooa.ooa34 WHERE ooa01 = g_ooa.ooa01
   IF STATUS THEN
      LET g_success = 'N'
   END IF

   CALL p402_y1()
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
       SELECT COUNT(*) INTO l_cnt FROM npq_file 
        WHERE npq01= g_ooa.ooa01
          AND npq00= 3  
          AND npqsys= 'AR'  
          AND npq011= 1
       IF l_cnt = 0 THEN
          CALL p402_gen_glcr(g_ooa.*,g_ooy.*)
       END IF
       IF g_success = 'Y' THEN 
          CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)      
          IF g_aza.aza63='Y' AND g_success='Y' THEN           
             CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2) 
          END IF                                            
        # LET g_dbs_new = s_dbstring(g_dbs CLIPPED) 
          LET g_plant_new = g_plant 
       END IF
       IF g_success = 'N' THEN 
          ROLLBACK WORK   
          RETURN 
       END IF 
    END IF
    IF g_success = 'Y' THEN
       IF g_ooa.ooamksg = 'Y' THEN #簽核模式
          CASE aws_efapp_formapproval()#呼叫 EF 簽核功能
               WHEN 0  #呼叫 EasyFlow 簽核失敗
                    LET g_ooa.ooaconf="N"
                    LET g_success = "N"
                    ROLLBACK WORK
                    RETURN
               WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                    LET g_ooa.ooaconf="N"
                    ROLLBACK WORK
                    RETURN
          END CASE
       END IF
       IF g_success='Y' THEN
          LET g_ooa.ooa34='1'              #執行成功, 狀態值顯示為 '1' 已核准
          LET g_ooa.ooaconf='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
          DISPLAY BY NAME g_ooa.ooaconf
          DISPLAY BY NAME g_ooa.ooa34
          COMMIT WORK
          CALL cl_flow_notify(g_ooa.ooa01,'Y')
       ELSE
          LET g_ooa.ooaconf='N'
          LET g_success = 'N'
          ROLLBACK WORK
       END IF
    ELSE
       LET g_ooa.ooaconf='N'
       LET g_success = 'N'
       ROLLBACK WORK
    END IF

    SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
    IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
       LET g_wc_gl = 'npp01 = "',g_ooa.ooa01,'" AND npp011 = 1'
       LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #No.TQC-810036
       CALL cl_cmdrun_wait(g_str)
    END IF

END FUNCTION

FUNCTION p402_y1()
DEFINE n       LIKE type_file.num5 
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_flag  LIKE type_file.chr1   

   UPDATE ooa_file SET ooaconf = 'Y',ooa34='1' WHERE ooa01 = g_ooa.ooa01  #No.TQC-9C0057
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'upd ooaconf',SQLCA.sqlcode,1) 
      LET g_success = 'N'
      RETURN
   END IF
   CALL p402_hu2()
   IF g_success = 'N' THEN
      RETURN
   END IF  
   DECLARE p402_y1_c CURSOR FOR SELECT * FROM oob_file
                                 WHERE oob01 = g_ooa.ooa01
                                 ORDER BY oob02
   LET l_cnt = 1
   LET l_flag = '0'
   FOREACH p402_y1_c INTO b_oob.*         
      IF STATUS THEN
         CALL s_errmsg('oob01',g_ooa.ooa01,'p402_y1_c foreach',STATUS,1)  
         LET g_success = 'N'
         RETURN
      END IF 
      IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y' 
      END IF                                                     

      IF l_flag = '0' THEN
         LET l_flag = b_oob.oob03
      END IF

      IF l_flag != b_oob.oob03 THEN
         LET l_cnt = l_cnt + 1
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '1' THEN
         CALL p402_bu_11('+')
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '2' THEN
         CALL p402_bu_12('+')
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL p402_bu_13('+')
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '9' THEN
         CALL p402_bu_19('+')
      END IF

      IF b_oob.oob03 = '2' AND b_oob.oob04 = '1' THEN
         CALL p402_bu_21('+')
      END IF

      IF b_oob.oob03 = '2' AND b_oob.oob04 = '9' THEN
         CALL p402_bu_19('+')
      END IF

      IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
         CALL p402_bu_22('+',l_cnt)
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          
   #---------------------------------- 970124 roger A/P對沖->需自動產生apf,g,h
   #No.B184 010419 by plum mod 只要類別為9,就都INS AP:apf,g,h
   SELECT COUNT(*) INTO n FROM oob_file
    WHERE oob01 = g_ooa.ooa01
      AND oob04 = '9'

   IF n > 0 THEN
      CALL ins_apf()
   END IF
  
END FUNCTION

FUNCTION p402_hu2()            #最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   IF STATUS THEN 
      CALL s_errmsg('ooa03',g_ooa.ooa03,'select',STATUS,1)  
      LET g_success='N' 
      RETURN 
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < g_ooa.ooa02 THEN
      LET l_occ.occ174=g_ooa.ooa02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_ooa.ooa03
   IF STATUS THEN 
     CALL s_errmsg('ooa03',g_ooa.ooa03,'update',STATUS,1)  
     LET g_success='N' 
     RETURN
   END IF
END FUNCTION

FUNCTION ins_apf()
  DEFINE b_oob      RECORD LIKE oob_file.*
  DEFINE l_apf      RECORD LIKE apf_file.*
  DEFINE l_apg      RECORD LIKE apg_file.*
  DEFINE l_aph      RECORD LIKE aph_file.*
  DEFINE l_amt      LIKE type_file.num20_6 
  DEFINE l_apz27    LIKE apz_file.apz27

  INITIALIZE l_apf.* TO NULL
  LET l_apf.apf00='33'
  LET l_apf.apf01 =g_ooa.ooa01
  LET l_apf.apf02 =g_ooa.ooa02
  LET l_apf.apf03 =g_ooa.ooa03
  LET l_apf.apf12 =g_ooa.ooa032
  LET l_apf.apf04 =g_ooa.ooa14
  LET l_apf.apf05 =g_ooa.ooa15
  LET l_apf.apf06 =g_ooa.ooa23
  LET l_apf.apf07 =1
  LET l_apf.apf08f=g_ooa.ooa31d
  LET l_apf.apf08 =g_ooa.ooa32d
  LET l_apf.apf09f=0
  LET l_apf.apf09 =0
  LET l_apf.apf10f=g_ooa.ooa31c
  LET l_apf.apf10 =g_ooa.ooa32c
  LET l_apf.apf13 = ''
  SELECT pmc24 INTO l_apf.apf13 FROM pmc_file
    WHERE pmc01 = g_ooa.ooa03
  LET l_apf.apf41 ='Y'
  LET l_apf.apf44 =g_ooa.ooa33
  LET l_apf.apfinpd =TODAY
  LET l_apf.apfmksg ='N'
  LET l_apf.apfacti ='Y'
  LET l_apf.apfuser =g_user
  LET l_apf.apfgrup =g_grup
  INSERT INTO apf_file VALUES(l_apf.*)
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL s_errmsg('apf01','g_ooa.ooa01','ins apf',SQLCA.SQLCODE,1)              #NO.FUN-710050
     LET g_success = 'N'
  END IF
  DECLARE ins_apf_c CURSOR FOR
    SELECT * FROM oob_file WHERE oob01=g_ooa.ooa01 ORDER BY 1,2
  FOREACH ins_apf_c INTO b_oob.*
    IF g_success='N' THEN                                                    
      LET g_totsuccess='N'                                                   
      LET g_success='Y' 
    END IF                                                     
    IF b_oob.oob03='1' THEN
       INITIALIZE l_apg.* TO NULL
       LET l_apg.apg01 =g_ooa.ooa01
       LET l_apg.apg02 =b_oob.oob02
       LET l_apg.apg03 = g_plant 
       LET l_apg.apg04 =b_oob.oob06
       LET l_apg.apg05f=b_oob.oob09
       LET l_apg.apg05 =b_oob.oob10
       LET l_apg.apg06 =b_oob.oob19 
       INSERT INTO apg_file VALUES(l_apg.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          LET g_showmsg=g_ooa.ooa01,"/",b_oob.oob02 
          CALL s_errmsg('apg01,apg02',g_showmsg,'ins apg',SQLCA.SQLCODE,1)   #NO.FUN-710050    #NO.FUN-710050
          LET g_success = 'N'
       END IF
    END IF
    IF b_oob.oob03='2' THEN
       INITIALIZE l_aph.* TO NULL
       LET l_aph.aph01 =g_ooa.ooa01
       LET l_aph.aph02 =b_oob.oob02
       LET l_aph.aph03 ='0'
       LET l_aph.aph04 =b_oob.oob06
       LET l_aph.aph05f=b_oob.oob09
       LET l_aph.aph05 =b_oob.oob10
       LET l_aph.aph13 =b_oob.oob07
       LET l_aph.aph14 =b_oob.oob08
       LET l_aph.aph17 =b_oob.oob19  #No.FUN-680022 add
       INSERT INTO aph_file VALUES(l_aph.*)
       IF STATUS OR SQLCA.SQLCODE THEN
          LET g_showmsg=g_ooa.ooa01,"/",b_oob.oob02                          #NO.FUN-710050    
          CALL s_errmsg('aph01,aph02',g_showmsg,'ins aph',SQLCA.SQLCODE,1)   #NO.FUN-710050  
          LET g_success = 'N'
       END IF
    END IF
  END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
END FUNCTION

FUNCTION p402_bu()
   LET g_ooa.ooa31d = 0 LET g_ooa.ooa31c = 0
   LET g_ooa.ooa32d = 0 LET g_ooa.ooa32c = 0
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31d,g_ooa.ooa32d
          FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='1'
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31c,g_ooa.ooa32c
          FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='2'
   IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
   IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF
   IF cl_null(g_ooa.ooa31c) THEN LET g_ooa.ooa31c=0 END IF
   IF cl_null(g_ooa.ooa32c) THEN LET g_ooa.ooa32c=0 END IF
   #no.A010依幣別取位
   LET g_ooa.ooa32d = cl_digcut(g_ooa.ooa32d,g_azi04) 
   LET g_ooa.ooa32c = cl_digcut(g_ooa.ooa32c,g_azi04) 
   UPDATE ooa_file SET
          ooa31d=g_ooa.ooa31d,ooa31c=g_ooa.ooa31c,
          ooa32d=g_ooa.ooa32d,ooa32c=g_ooa.ooa32c
          WHERE ooa01=g_ooa.ooa01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_showmsg = g_ooa.ooa31d,'/',g_ooa.ooa31c,'/',g_ooa.ooa32d,'/',g_ooa.ooa32c
      CALL s_errmsg('ooa31d,ooa31c,ooa32d,ooa32c',g_showmsg,'UPDATE',SQLCA.SQLCODE,1) 
   END IF
END FUNCTION

FUNCTION p402_bu_11(p_sw)                   #更新應收票據檔 (nmh_file)
  DEFINE p_sw       LIKE type_file.chr1, 
       l_nmh17      LIKE  nmh_file.nmh17,
       l_nmh38      LIKE  nmh_file.nmh38
  DEFINE l_nmz59        LIKE nmz_file.nmz59
  DEFINE l_amt1,l_amt2 LIKE nmg_file.nmg25    #No.MOD-910126

  #確認時,判斷此參考單號之單據是否已確認
  SELECT nmh17,nmh38 INTO l_nmh17,l_nmh38 FROM nmh_file WHERE nmh01=b_oob.oob06
  IF STATUS THEN LET l_nmh38 = 'N' END IF
  IF l_nmh38 != 'Y' THEN
     CALL s_errmsg('nmh01',b_oob.oob06,' ','axr-194',1)   
  END IF
  SELECT nmz59 INTO l_nmz59 FROM nmz_file WHERE nmz00 = '0'
  IF l_nmz59 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
     CALL s_g_np('4','1',b_oob.oob06,b_oob.oob15) RETURNING tot3
  ELSE
    SELECT nmh32 INTO l_amt1 FROM nmh_file WHERE nmh01 = b_oob.oob06
    IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
    CALL cl_digcut(l_amt1,g_azi04) RETURNING l_amt1
    SELECT SUM(oob10) INTO l_amt2 FROM oob_file,ooa_file 
     WHERE ooa01 = oob01 AND ooaconf = 'Y' AND oob03 = '1' AND oob04 = '1'
       AND oob06 = b_oob.oob06
    IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
    LET tot3 = l_amt1 - l_amt2
    IF cl_null(tot3) THEN LET tot3 = 0 END IF
  END IF

  IF p_sw = '-' THEN
     UPDATE nmh_file SET nmh17=nmh17-b_oob.oob09 ,nmh40 = tot3
      WHERE nmh01= b_oob.oob06
     IF STATUS THEN
        CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh17',STATUS,1)              
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh17','axr-198',1) LET g_success = 'N' RETURN    
     END IF
  END IF
  IF p_sw = '+' THEN
     UPDATE nmh_file SET nmh17=nmh17+b_oob.oob09 ,nmh40 = tot3
      WHERE nmh01= b_oob.oob06
     IF STATUS THEN
        CALL s_errmsg('nmh01',b_oob.oob06,'unp nmh17',STATUS,1)                          #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh17','axr-198',1)  LET g_success = 'N' RETURN    #NO.FUN-710050
     END IF
  END IF
END FUNCTION

FUNCTION p402_bu_12(p_sw)             #更新TT檔 (nmg_file)
  DEFINE p_sw           LIKE type_file.chr1      #No.FUN-680123 CHAR(1)                  # +:更新 -:還原
  DEFINE l_nmg23        LIKE nmg_file.nmg23
  DEFINE l_nmg24        LIKE nmg_file.nmg24,
         l_nmg25        LIKE nmg_file.nmg25,        #bug NO:A053 by plum
         l_nmgconf      LIKE nmg_file.nmgconf,
         l_cnt          LIKE type_file.num5      #No.FUN-680123 smallint
  DEFINE tot1,tot3,tot2 LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #FUN-4C0013 #bug NO:A053 by plum
  DEFINE l_nmz20        LIKE nmz_file.nmz20
  DEFINE l_str          STRING                      #FUN-640246

  LET l_str = "bu_12:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
  CALL cl_msg(l_str) 
  LET l_nmgconf = ' '
  SELECT nmg25,nmgconf INTO l_nmg25,l_nmgconf
    FROM nmg_file WHERE nmg00= b_oob.oob06
  IF STATUS THEN LET l_nmgconf= 'N' END IF
  IF l_nmgconf != 'Y' THEN
     CALL s_errmsg('nmg00',b_oob.oob06,'','axr-194',1)  LET g_success = 'N' RETURN    #NO.FUN-710050
  END IF
  IF cl_null(l_nmg25) THEN LET l_nmg25=0 END IF  
##--------------------------------------------------
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='2'
            AND oob06=b_oob.oob06
  IF l_cnt>0 THEN RETURN END IF
 
  LET tot1 = 0 LET tot2 = 0  #bug NO:A053 by plum
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
          WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
            AND oob03='1'         AND oob04 = '2'
  IF cl_null(tot1) THEN LET tot1 = 0 END IF
  IF cl_null(tot2) THEN LET tot2 = 0 END IF   
  SELECT nmz20 INTO l_nmz20 FROM nmz_file WHERE nmz00 = '0'
  IF l_nmz20 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
     CALL s_g_np('3','',b_oob.oob06,b_oob.oob15) RETURNING tot3
  ELSE
     LET tot3 = 0
  END IF

  IF p_sw = '-' THEN
     UPDATE nmg_file SET nmg24 = tot1, nmg10 = tot3
      WHERE nmg00= b_oob.oob06
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24',SQLCA.SQLCODE,1)           
       RETURN
    END IF
    RETURN
  END IF
  LET l_nmg24 =0
  SELECT nmg23,nmg23-nmg24 INTO l_nmg23,l_nmg24
    FROM nmg_file WHERE nmg00= b_oob.oob06
    IF STATUS THEN
       CALL s_errmsg('nmg00',b_oob.oob06,'sel nmg24',STATUS,1)            
       LET g_success = 'N' 
       RETURN
    END IF
    IF l_nmg24 = 0  THEN
       CALL s_errmsg('nmg00',b_oob.oob06,'nmg24=0','axr-185',1) LET g_success='N' RETURN       
    END IF
# check 是否沖過頭了 ------------
    IF tot1>l_nmg23  THEN
       CALL s_errmsg('nmg00',b_oob.oob06,'','axr-258',1) LET g_success='N' RETURN              
    END IF
    UPDATE nmg_file SET nmg24=tot1, nmg10 = tot3
     WHERE nmg00= b_oob.oob06
    IF STATUS THEN
       CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24',STATUS,1)               #NO.FUN-710050
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24','axr-198',1) LET g_success = 'N' RETURN   #NO.FUN-710050
    END IF
END FUNCTION

FUNCTION p402_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1      #No.FUN-680123 CHAR(1)                  # +:更新 -:還原
  DEFINE l_omaconf      LIKE oma_file.omaconf,   #No.FUN-680123 CHAR(1),            #
         l_omavoid      LIKE oma_file.omavoid,   #No.FUN-680123 CHAR(1),
         l_cnt          LIKE type_file.num5      #No.FUN-680123 smallint
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE tot4,tot4t     LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #TQC-5B0171
  DEFINE tot5,tot6      LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #No.FUN-680022 add
  DEFINE tot8           LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #No.FUN-680022 add
  DEFINE l_omc10        LIKE omc_file.omc10,#No.FUN-680022 add
         l_omc11        LIKE omc_file.omc11,#No.FUN-680022 add
         l_omc13        LIKE omc_file.omc13 #No.FUN-680022 add

# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='3'  #No.9047 add
            AND oob06=b_oob.oob06
  IF l_cnt>0 THEN RETURN END IF
 
 #預防在收款沖帳確認前,多沖待抵貨款
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob01=ooa01
     AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'     #No:9638
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF

  IF p_sw='+' THEN
     SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
      WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
        AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'    
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF
  END IF
 
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(tot1,t_azi04) RETURNING tot1   
  CALL cl_digcut(tot2,g_azi04) RETURNING tot2  
 
  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
           #"  FROM ",g_dbs_new CLIPPED,"oma_file",
            "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),  
            " WHERE oma01=?"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  PREPARE p402_bu_13_p1 FROM g_sql
  DECLARE p402_bu_13_c1 CURSOR FOR p402_bu_13_p1
  OPEN p402_bu_13_c1 USING b_oob.oob06
  FETCH p402_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    IF p_sw='+' AND l_omavoid='Y' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N' RETURN   #NO.FUN-710050
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N' RETURN   #NO.FUN-710050
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL p402_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4      
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t   
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN  
       CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) LET g_success = 'N' RETURN  
       END IF
    END IF

    SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
       AND oob03='1'  AND oob04 = '3'
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
    	
    IF p_sw='+' THEN
       SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
        WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
          AND ooaconf = 'Y' AND oob03='1'  AND oob04 = '3'
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF
       
       SELECT omc10,omc11,omc13 INTO l_omc10,l_omc11,l_omc13 FROM omc_file 
        WHERE omc01=b_oob.oob06 AND omc02 = b_oob.oob19
       IF cl_null(l_omc10) THEN LET l_omc10=0 END IF
       IF cl_null(l_omc11) THEN LET l_omc11=0 END IF
       IF cl_null(l_omc13) THEN LET l_omc13=0 END IF
    END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       #取得未沖金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
       #未衝金額扣除待扺
       LET tot3 = tot3 - tot4t
    ELSE
       LET tot3 = un_pay2 - tot2 - tot4t
    END IF
  # LET g_sql="UPDATE ",g_dbs_new CLIPPED,"oma_file SET oma55=?,oma57=?,oma61=? ",
    LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oma_file'), " SET oma55=?,oma57=?,oma61=? ",
              " WHERE oma01=? "
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
    PREPARE p402_bu_13_p2 FROM g_sql
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1     
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2    
    EXECUTE p402_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06 
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)           
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN   #NO.FUN-710050
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p402_omc(l_oma00)   
    END IF
END FUNCTION

FUNCTION p402_bu_19(p_sw)                   #更新 A/P 檔 (apa_file)
  DEFINE p_sw        LIKE type_file.chr1      #No.FUN-680123 CHAR(1)                  # +:更新 -:還原
  DEFINE l_apa       RECORD LIKE apa_file.*
  DEFINE l_apc       RECORD LIKE apc_file.*   #No.FUN-680022 add
  DEFINE l_apz27     LIKE apz_file.apz27
  DEFINE l_tot       LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #FUN-4C0013

  IF g_bgjob='N' OR cl_null(g_bgjob) THEN
    #DISPLAY "bu_11:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1  #CHI-A70049 mark
  END IF

  SELECT * INTO l_apa.* FROM apa_file WHERE apa01=b_oob.oob06
                                        AND apa02 <= g_ooa.ooa02 #MOD-A30146 add
  IF STATUS THEN 
     CALL s_errmsg('apa01',b_oob.oob06,'sel apa',STATUS,1)              #NO.FUN-710050
     LET g_success ='N' 
     RETURN 
  END IF
  IF l_apa.apa41 != 'Y' THEN
     CALL s_errmsg('apa01',b_oob.oob06,'apa41<>Y','axr-194',1) LET g_success ='N' RETURN   #NO.FUN-710050
  END IF
  SELECT apz27 INTO l_apz27 FROM apz_file WHERE apz00 = '0'
  IF l_apz27 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
     CALL s_g_np('2',l_apa.apa00,b_oob.oob06,b_oob.oob15) RETURNING tot
  END IF
  IF p_sw = '-' THEN
     LET l_apa.apa35f=l_apa.apa35f-b_oob.oob09
     LET l_apa.apa35 =l_apa.apa35 -b_oob.oob10
     CALL p402_comp_oox(b_oob.oob06) RETURNING g_net
     LET tot = l_apa.apa34 - l_apa.apa35 + g_net  
     UPDATE apa_file SET apa35f=l_apa.apa35f,
                         apa35 =l_apa.apa35,
                         apa73 = tot
               WHERE apa01= b_oob.oob06
                 AND apa02 <= g_ooa.ooa02 
     IF STATUS THEN
        CALL s_errmsg('apa01',b_oob.oob06,'upd apa35,35f',STATUS,1)              #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('apa01',b_oob.oob06,'upd apa35,35f','axr-198',1) LET g_success = 'N' RETURN    #NO.FUN-710050
     END IF
     IF SQLCA.sqlcode = 0  THEN
        CALL p402_apc(p_sw)
     END IF
  END IF
  IF p_sw = '+' THEN
     LET l_apa.apa35f=l_apa.apa35f+b_oob.oob09
     LET l_apa.apa35 =l_apa.apa35 +b_oob.oob10
     CALL p402_comp_oox(b_oob.oob06) RETURNING g_net
     LET tot = l_apa.apa34 - l_apa.apa35 + g_net  
     IF l_apz27 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
        IF l_apa.apa35f>l_apa.apa34f OR l_apa.apa35 >l_apa.apa34 THEN
           CALL s_errmsg("apa35",l_apa.apa35,"apa35>apa34","axr-190",1)
           LET g_success = 'N'
           RETURN          
        END IF
     END IF
     UPDATE apa_file SET apa35f=l_apa.apa35f,
                         apa35 =l_apa.apa35,
                         apa73 = tot
               WHERE apa01= b_oob.oob06
                 AND apa02 <= g_ooa.ooa02 
     IF STATUS THEN
        CALL s_errmsg('apa01',b_oob.oob06,'upd apa35f,35',STATUS,1)              #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('apa01',b_oob.oob06,'upd apa35f,35','axr-198',1) LET g_success = 'N' RETURN #NO.FUN-710050
     END IF
     IF SQLCA.sqlcode = 0  THEN
        CALL p402_apc(p_sw)
     END IF
  END IF
END FUNCTION

FUNCTION p402_bu_21(p_sw)                  #更新應收帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1      #No.FUN-680123 CHAR(1)                  # +:更新 -:還原
  DEFINE l_omaconf      LIKE oma_file.omaconf,   #No.FUN-680123 CHAR(1),            #
         l_omavoid      LIKE oma_file.omavoid,   #No.FUN-680123 CHAR(1),
         l_cnt          LIKE type_file.num5      #No.FUN-680123 smallint
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE l_omc   RECORD LIKE omc_file.*         #No.FUN-680022 add
  DEFINE l_omc10        LIKE omc_file.omc10     #No.FUN-680022 add
  DEFINE l_omc11        LIKE omc_file.omc11     #No.FUN-680022 add
  DEFINE l_omc13        LIKE omc_file.omc13     #No.FUN-680022 add
  DEFINE l_oob10        LIKE oob_file.oob10     #No.FUN-680022 add
  DEFINE l_oob09        LIKE oob_file.oob09     #No.FUN-680022 add
  DEFINE tot4,tot4t     LIKE type_file.num20_6  #No.FUN-680123 DEC(20,6)           #TQC-5B0171
  DEFINE tot5,tot6      LIKE type_file.num20_6  #No.FUN-680123 DEC(20,6)           #No.FUN-680022 add

# 同參考單號若有一筆以上僅沖款一次即可 --------------
  IF g_ooz.ooz62='Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM oob_file
      WHERE oob01=b_oob.oob01
        AND oob02<b_oob.oob02
        AND oob03='2'
        AND oob04='1' 
        AND oob06=b_oob.oob06 AND oob15 = b_oob.oob15
  ELSE
     SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='2'
            AND oob19=b_oob.oob19    
            AND oob06=b_oob.oob06
  END IF
  IF l_cnt>0 THEN  
      LET g_showmsg=b_oob.oob06,"/",b_oob.oob01                        
      CALL s_errmsg('oob06,oob01',g_showmsg,b_oob.oob01,'axr-409',1)  
      LET g_success = 'N'
      RETURN
  END IF
 
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
     AND oob03='2'
     AND oob04='1'  
  IF cl_null(tot1) THEN LET tot1 = 0 END IF
  IF cl_null(tot2) THEN LET tot2 = 0 END IF
  
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07 
  CALL cl_digcut(tot1,t_azi04) RETURNING tot1        
  CALL cl_digcut(tot2,g_azi04) RETURNING tot2       

  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
           #"  FROM ",g_dbs_new,"oma_file",         
            "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),   
            " WHERE oma01=?"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  PREPARE p402_bu_21_p1 FROM g_sql
  DECLARE p402_bu_21_c1 CURSOR FOR p402_bu_21_p1
  OPEN p402_bu_21_c1 USING b_oob.oob06
  FETCH p402_bu_21_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2

  IF p_sw='+' AND l_omavoid='Y' THEN
     CALL s_errmsg('oma01',b_oob.oob06,b_oob.oob06,'axr-103',1) LET g_success='N' RETURN #NO.FUN-710050  #No.TQC-740094
  END IF

  IF p_sw='+' AND l_omaconf='N' THEN
     CALL s_errmsg('oma01',b_oob.oob06,b_oob.oob06,'axr-194',1) LET g_success='N' RETURN #NO.FUN-710050  #No.TQC-740094
  END IF

  IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
  IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
  #取得衝帳單的待扺金額
  CALL p402_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
  CALL cl_digcut(tot4,t_azi04) RETURNING tot4      
  CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t   

  IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
     IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN   #TQC-5B0171
     CALL s_errmsg('oma01',b_oob.oob06,'un_pay<pay','axr-196',1) LET g_success='N' RETURN #NO.FUN-710050  #No.TQC-740094
     END IF
  END IF
  IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
     #取得未沖金額
     CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
     #未衝金額扣除待扺
     LET tot3 = tot3 - tot4t
  ELSE
     LET tot3 = un_pay2 - tot2 - tot4t
  END IF
 #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"oma_file SET oma55=?,oma57=?,oma61=? ",
  LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oma_file'), " SET oma55=?,oma57=?,oma61=? ",
             " WHERE oma01=? "
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
  PREPARE p402_bu_21_p2 FROM g_sql
  LET tot1 = tot1 + tot4
  LET tot2 = tot2 + tot4t
  CALL cl_digcut(tot1,t_azi04) RETURNING tot1        
  CALL cl_digcut(tot2,g_azi04) RETURNING tot2       

  EXECUTE p402_bu_21_p2 USING tot1, tot2, tot3, b_oob.oob06
  IF STATUS THEN
     CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)              #NO.FUN-710050
     LET g_success = 'N'
     RETURN
  END IF
  IF SQLCA.SQLERRD[3]=0 THEN
     CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN  #NO.FUN-710050
  END IF
  IF SQLCA.sqlcode = 0 THEN
     CALL p402_omc(l_oma00)  #No.MOD-930140
  END IF
  # 若有指定沖帳項次, 則對項次再次檢查及更新已沖金額
  IF NOT cl_null(b_oob.oob15) AND g_ooz.ooz62='Y' THEN
     LET tot1 = 0 LET tot2 = 0
     SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
      WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf='Y'
        AND oob03='2' AND oob15 = b_oob.oob15
        AND oob04='1'
     IF cl_null(tot1) THEN LET tot1 = 0 END IF
     IF cl_null(tot2) THEN LET tot2 = 0 END IF
     LET g_sql="SELECT oma00,omaconf,omb14t,omb16t ",
              #"  FROM ",g_dbs_new CLIPPED,"omb_file,",g_dbs_new CLIPPED,"oma_file ",
               "  FROM ",cl_get_target_table(g_plant_new,'omb_file'),",",
                         cl_get_target_table(g_plant_new,'oma_file'),  
               " WHERE oma01=omb01 AND omb01=? AND omb03 = ? "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
     PREPARE p402_bu_21_p1b FROM g_sql
     DECLARE p402_bu_21_c1b CURSOR FOR p402_bu_21_p1b
     OPEN p402_bu_21_c1b USING b_oob.oob06,b_oob.oob15
     FETCH p402_bu_21_c1b INTO l_oma00,l_omaconf,un_pay1,un_pay2

     IF p_sw='+' AND l_omaconf='N' THEN
         LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                     #NO.FUN-710050   
         CALL s_errmsg('omb01,omb03',g_showmsg,b_oob.oob06,'axr-194',1) LET g_success='N' RETURN #NO.FUN-710050  #No.TQC-740094
     END IF

     IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
     IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
     IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
        IF p_sw='+' AND (un_pay1 < tot1 OR un_pay2 < tot2) THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                        #NO.FUN-710050   
        CALL s_errmsg('omb01,omb03',g_showmsg,'un_pay<pay','axr-196',1)  LET g_success='N' RETURN #NO.FUN-710050
        END IF
     END IF
     IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
        #取得未沖金額
        CALL s_g_np('1',l_oma00,b_oob.oob06,b_oob.oob15) RETURNING tot3
     ELSE
        LET tot3 = un_pay2  - tot2
     END IF
   # LET g_sql="UPDATE ",g_dbs_new CLIPPED,"omb_file SET omb34=?,omb35=?,omb37=? ",
     LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'omb_file'), " SET omb34=?,omb35=?,omb37=? ",
               " WHERE omb01=? AND omb03=?"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql		#FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   
     PREPARE p402_bu_21_p2b FROM g_sql
     EXECUTE p402_bu_21_p2b USING tot1, tot2, tot3, b_oob.oob06,b_oob.oob15
     IF STATUS THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                        #NO.FUN-710050   
        CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35',STATUS,1)   #NO.FUN-710050
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                        #NO.FUN-710050   
        CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35','axr-198',1) LET g_success = 'N' RETURN   #NO.FUN-710050  #No.TQC-740094
     END IF
  END IF
END FUNCTION

FUNCTION p402_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
  DEFINE p_sw            LIKE type_file.chr1      #No.FUN-680123 CHAR(1)                  # +:產生 -:刪除
  DEFINE p_cnt           LIKE type_file.num5      #No.FUN-680123 SMALLINT
  DEFINE l_oma            RECORD LIKE oma_file.*
  DEFINE l_omc            RECORD LIKE omc_file.*
  DEFINE li_result       LIKE type_file.num5      #No.FUN-680123 SMALLINT   #FUN-560099
  IF g_bgjob='N' OR cl_null(g_bgjob) THEN
     IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        MESSAGE "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
     ELSE
       #DISPLAY "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1  #CHI-A70049 mark
     END IF
  END IF
  INITIALIZE l_oma.* TO NULL
  IF p_sw = '-' THEN
##若溢收款在後已被沖帳,則不可取消確認
     IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
        SELECT COUNT(*) INTO g_cnt FROM oob_file,ooa_file                
         WHERE oob06 = b_oob.oob06
           AND oob03 = '1' AND oob04 = '3'
           AND ooa01 = oob01 AND ooaconf!='X'                           
        IF g_cnt > 0 THEN
           LET g_showmsg=b_oob.oob06,"/",'1',"/",'3'                   
           CALL s_errmsg('oob06,oob03,oob04',g_showmsg,b_oob.oob06,'axr-206',1) #NO.FUN-710050
           LET g_success = 'N' RETURN                                           #NO.FUN-710050      
        END IF
     END IF
     SELECT * INTO l_oma.* FROM oma_file WHERE oma01=b_oob.oob06      
                                           AND omavoid = 'N'
     IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN
          LET g_showmsg=b_oob.oob06,"/",'N'                           
          CALL s_errmsg('oma01,omavoid',g_showmsg,'oma55,57>0','axr-206',1)
          LET g_success = 'N' RETURN                                     
     END IF
     DELETE FROM oma_file WHERE oma01 = b_oob.oob06
     IF STATUS THEN
        CALL s_errmsg('oma01','b_oob.oob06','del oma',STATUS,1)          
        LET g_success = 'N' 
        RETURN 
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('oma01','b_oob.oob06','del oma','axr-199',1)     
        LET g_success = 'N' RETURN
     END IF
     DELETE FROM omc_file WHERE omc01=b_oob.oob06 AND omc02=b_oob.oob19
     IF STATUS THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob19                                    
        CALL s_errmsg('omc01,omc02',g_showmsg,"del omc",STATUS,1)                  
        LET g_success ='N'
        RETURN
     END IF 
     DELETE FROM oov_file WHERE oov01 = b_oob.oob06
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('oov01','b_oob.oob06','del oov',STATUS,1)             
        LET g_success='N'
     END IF
     UPDATE oob_file SET oob06=NULL
       WHERE oob01=b_oob.oob01 AND oob02=b_oob.oob02
     IF STATUS OR SQLCA.SQLCODE THEN
       LET g_showmsg=b_oob.oob01,"/",b_oob.oob02                                    #NO.FUN-710050
       CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)           #NO.FUN-710050
       LET g_success = 'N' 
       RETURN
     ELSE     
        LET b_oob.oob06 = NULL
     END IF
  END IF
  IF p_sw = '+' THEN
     IF cl_null(b_oob.oob06)
        THEN LET l_oma.oma01 = g_ooz.ooz22   
        ELSE LET l_oma.oma01 = b_oob.oob06
     END IF
     CALL s_auto_assign_no("axr",l_oma.oma01,g_ooa.ooa02,"24","","","","","")
     RETURNING li_result,l_oma.oma01
     IF (NOT li_result) THEN
        LET g_success='N'
     END IF
     CALL cl_msg(l_oma.oma01)       

     #轉預收時(oma00='24'),重新讀取g_ooa.*變數
     SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01=b_oob.oob01   #MOD-860002 add

     LET l_oma.oma00 = '24'
     LET l_oma.oma02 = g_ooa.ooa02
     LET l_oma.oma03 = g_ooa.ooa03
     LET l_oma.oma032= g_ooa.ooa032
     LET l_oma.oma13 = g_ooa.ooa13
     LET l_oma.oma14 = g_ooa.ooa14
     LET l_oma.oma15 = g_ooa.ooa15
     LET l_oma.oma16 = g_ooa.ooa01
     LET l_oma.oma18 = b_oob.oob11
     IF g_aza.aza63='Y' THEN             
        LET l_oma.oma181 = b_oob.oob111 
     END IF                            
     LET l_oma.oma211= 0  
     LET l_oma.oma23 = b_oob.oob07
     LET l_oma.oma24 = b_oob.oob08
     LET l_oma.oma50 = 0
     LET l_oma.oma50t= 0
     LET l_oma.oma52 = 0
     LET l_oma.oma53 = 0
     LET l_oma.oma54 = b_oob.oob09
     LET l_oma.oma54t= b_oob.oob09
     LET l_oma.oma56 = b_oob.oob10
     LET l_oma.oma56t= b_oob.oob10
     LET l_oma.oma54x= 0
     LET l_oma.oma55 = 0
     LET l_oma.oma56x= 0
     LET l_oma.oma57 = 0
     LET l_oma.oma58 = 0
     LET l_oma.oma59 = 0
     LET l_oma.oma59x= 0
     LET l_oma.oma59t= 0
     LET l_oma.oma60 = b_oob.oob08
     LET l_oma.oma61 = b_oob.oob10
     LET l_oma.omaconf='Y'
     LET l_oma.oma64 = '1'  
     LET l_oma.omavoid='N'
     LET l_oma.omauser=g_user
     LET l_oma.omagrup=g_grup
     LET l_oma.omadate=g_today
     LET l_oma.oma12 = l_oma.oma02
     LET l_oma.oma11 = l_oma.oma02
     LET l_oma.oma65 = '1' 
     LET l_oma.oma66 = g_plant 
     LET l_oma.oma68 = g_ooa.ooa03                                                                         
     LET l_oma.oma69 = g_ooa.ooa032                                                                         
     LET l_omc.omc01=l_oma.oma01
     LET l_omc.omc02=1
     SELECT occ45 INTO l_oma.oma32 FROM occ_file WHERE occ01=g_ooa.ooa03
     IF cl_null(l_oma.oma32) THEN LET l_oma.oma32 = ' ' END IF
     LET l_omc.omc03=l_oma.oma32
     LET l_omc.omc04=l_oma.oma11
     LET l_omc.omc05=l_oma.oma12
     LET l_omc.omc06=l_oma.oma24
     LET l_omc.omc07=l_oma.oma60
     LET l_omc.omc08=l_oma.oma54t
     LET l_omc.omc09=l_oma.oma56t
     LET l_omc.omc10=l_oma.oma55
     LET l_omc.omc11=l_oma.oma57
     LET l_omc.omc12=l_oma.oma10
     LET l_omc.omc13=l_omc.omc09-l_omc.omc11
     LET l_omc.omc14=l_oma.oma51f
     LET l_omc.omc15=l_oma.oma51
    
     SELECT oga27 INTO l_oma.oma67 FROM oga_file WHERE oga01=l_oma.oma16
     LET l_oma.oma930=s_costcenter(l_oma.oma15) #FUN-680006
     LET l_oma.oma64='0' #MOD-980263 
#No.FUN-AB0034 --begin
    IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
    IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
    IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
     INSERT INTO oma_file VALUES(l_oma.*)
     IF STATUS OR SQLCA.SQLCODE THEN
        CALL s_errmsg('oma02','g_ooa.ooa02','ins oma',SQLCA.SQLCODE,1)              #NO.FUN-710050
        LET g_success='N' 
        RETURN
     END IF
     
     INSERT INTO omc_file VALUES(l_omc.*)
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('omc01','l_oma.oma01','ins omc',SQLCA.SQLCODE,1)                      #NO.FUN-710050
        LET g_success='N'
        RETURN
     END IF
     UPDATE oob_file SET oob06=l_oma.oma01,oob19=l_omc.omc02   #No.FUN-680022 add
       WHERE oob01=b_oob.oob01 AND oob02=b_oob.oob02
     IF STATUS OR SQLCA.SQLCODE THEN
       LET g_showmsg=b_oob.oob01,"/",b_oob.oob02                                      #NO.FUN-710050 
       CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)             #NO.FUN-710050
       LET g_success = 'N' 
       RETURN
     END IF
  END IF
END FUNCTION

FUNCTION p402_gen_glcr(p_ooa,p_ooy)
  DEFINE p_ooa     RECORD LIKE ooa_file.*
  DEFINE p_ooy     RECORD LIKE ooy_file.*

    IF cl_null(p_ooy.ooygslp) THEN
       CALL s_errmsg('ooa01',p_ooa.ooa01,'','axr-070',1) 
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_t400_gl(p_ooa.ooa01,'0')   
    IF g_aza.aza63='Y' THEN        
       CALL s_t400_gl(p_ooa.ooa01,'1') 
    END IF                         
    IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION p402_omc(p_oma00) 
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_omc13           LIKE omc_file.omc13
DEFINE   l_oob09           LIKE oob_file.oob09  
DEFINE   l_oob10           LIKE oob_file.oob10   
DEFINE   l_oox10           LIKE oox_file.oox10 
DEFINE   p_oma00           LIKE oma_file.oma00

   LET l_oox10 = 0 
   SELECT SUM(oox10) INTO l_oox10 FROM oox_file 
    WHERE oox00 = 'AR'
      AND oox03 = b_oob.oob06 
      AND oox041 = b_oob.oob19
   IF cl_null(l_oox10) THEN LET l_oox10 = 0 END IF 
   IF p_oma00 MATCHES '2*' THEN 
      LET l_oox10 = l_oox10 * -1
   END IF 

  SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19 
     AND oob01=ooa01  AND ooaconf = 'Y'
     AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))   
  IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
  IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
# LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc10=?,omc11=? ",   
  LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file')," SET omc10=?,omc11=? ", 
            " WHERE omc01=? AND omc02=? "
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
  PREPARE p402_bu_13_p3 FROM g_sql
  EXECUTE p402_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     CALL s_errmsg('omc01',b_oob.oob06,'upd omc10,11','axr-198',1)
     LET g_success = 'N' RETURN
  END IF
# LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc13=omc09-omc11+ ",l_oox10,  
  LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file')," SET omc13=omc09-omc11+ ",l_oox10,
            " WHERE omc01=? AND omc02=? "
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   
  PREPARE p402_bu_13_p4 FROM g_sql
  EXECUTE p402_bu_13_p4 USING b_oob.oob06,b_oob.oob19
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     CALL s_errmsg('omc01',b_oob.oob06,'upd omc13','axr-198',1)
     LET g_success = 'N' RETURN
  END IF
END FUNCTION

FUNCTION p402_apc(p_sw)
DEFINE   l_apc10           LIKE apc_file.apc10
DEFINE   l_apc11           LIKE apc_file.apc11
DEFINE   l_apc13           LIKE apc_file.apc13
DEFINE   p_sw              LIKE type_file.chr1  

 #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"apc_file SET apc10=?,apc11=?,apc13=? ",
  LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'apc_file')," SET apc10=?,apc11=?,apc13=? ", 
            " WHERE apc01=? AND apc02=? "
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  
  PREPARE p402_bu_19_p3 FROM g_sql

  SELECT apc10,apc11,apc13 INTO l_apc10,l_apc11,l_apc13
    FROM apc_file WHERE apc01=b_oob.oob06 AND apc02=b_oob.oob19
  IF l_apc10 IS NULL THEN LET l_apc10=0 END IF
  IF l_apc11 IS NULL THEN LET l_apc11=0 END IF
  IF l_apc13 IS NULL THEN LET l_apc13=0 END IF
  IF p_sw='+' THEN
     LET l_apc10 = l_apc10 + b_oob.oob09
     LET l_apc11 = l_apc11 + b_oob.oob10
     LET l_apc13 = l_apc13 - b_oob.oob10
     IF NOT cl_null(b_oob.oob19) THEN 
        EXECUTE p402_bu_19_p3 USING l_apc10,l_apc11,l_apc13,b_oob.oob06,b_oob.oob19
        IF STATUS THEN
           LET g_showmsg=b_oob.oob06,"/",b_oob.oob19                                            #NO.FUN-710050 
           CALL s_errmsg('apc01,apc02',g_showmsg,'upd apc10,11,13',STATUS,1)                    #NO.FUN-710050
           LET g_success='N'
           RETURN
        END IF
     END IF
  END IF
  IF p_sw='-' THEN
     LET l_apc10 = l_apc10 - b_oob.oob09
     LET l_apc11 = l_apc11 - b_oob.oob10
     LET l_apc13 = l_apc13 + b_oob.oob10
     IF NOT cl_null(b_oob.oob19) THEN 
        EXECUTE p402_bu_19_p3 USING l_apc10,l_apc11,l_apc13,b_oob.oob06,b_oob.oob19
        IF STATUS THEN
           LET g_showmsg=b_oob.oob06,"/",b_oob.oob19                                            #NO.FUN-710050 
           CALL s_errmsg('apc01,apc02',g_showmsg,'upd apc10,11,13',STATUS,1)                    #NO.FUN-710050
           LET g_success='N'
           RETURN
        END IF
     END IF
  END IF
END FUNCTION

FUNCTION p402_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t

   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION

FUNCTION p402_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
                                              AND apa02 <= g_ooa.ooa02 #MOD-A30146 add
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION

