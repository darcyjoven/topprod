# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: axrp607.4gl
# Descriptions...: 退款單整批生成沖帳還原作業
# Date & Author..: FUN-C30029 12/03/19 By lujh
# Modify.........: No:TQC-C50044 By xuxz QBE條件azp01清空問題修改

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
DEFINE   g_azp01          LIKE azp_file.azp01,
         g_luc01          LIKE luc_file.luc01,
         g_wc             STRING,              
         g_wc2            STRING,
         g_sql            STRING,
         g_change_lang    LIKE type_file.chr1,
         g_t1             LIKE ooy_file.ooyslip,
         p_row,p_col      LIKE type_file.num5
DEFINE   g_luc            RECORD LIKE luc_file.*
DEFINE   g_lud            RECORD LIKE lud_file.*
DEFINE   g_ooa            RECORD LIKE ooa_file.*
DEFINE   b_oob            RECORD LIKE oob_file.*
DEFINE   g_luo            RECORD LIKE luo_file.* 
DEFINE   g_lup            RECORD LIKE lup_file.*
DEFINE   l_ooy            RECORD LIKE ooy_file.*
DEFINE   l_dbs            STRING
DEFINE   g_str            STRING  
DEFINE   g_plant_l        LIKE type_file.chr21     #營運中心
DEFINE   tot,tot1,tot2    LIKE type_file.num20_6,          
         tot3             LIKE type_file.num20_6,          
         un_pay1,un_pay2  LIKE type_file.num20_6 
DEFINE   g_cnt            LIKE type_file.num10

 
MAIN
   DEFINE l_flag  LIKE type_file.chr1
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_wc        = ARG_VAL(1)
   LET g_wc        = cl_replace_str(g_wc, "\\\"", "'")    
   LET g_wc2       = ARG_VAL(2)
   LET g_wc2       = cl_replace_str(g_wc2, "\\\"", "'")   
   LET g_bgjob = ARG_VAL(3)
   
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p607()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p607_1()
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
               CLOSE WINDOW p607_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p607_1()
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL cl_err('','lib-284',1) 
         ELSE
            ROLLBACK WORK
            CALL cl_err('','abm-020',1) 
         END IF
         EXIT WHILE
      END IF
   END WHILE
     CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p607()
  DEFINE   lc_cmd      LIKE type_file.chr1000    
  DEFINE l_azp01       LIKE azp_file.azp01 #TQC-C50044
 
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p607_w AT p_row,p_col WITH FORM "axr/42f/axrp607"
   ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
  CLEAR FORM
    DIALOG attributes(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON azp01
         BEFORE CONSTRUCT
           # IF cl_null(g_wc) THEN DISPLAY g_plant TO azp01 END IF#TQC-C50044 Mark
            #TQC-C50044--add--str
            LET l_azp01 = GET_FLDBUF(azp01)
            IF cl_null(l_azp01) THEN
               DISPLAY g_plant TO azp01
            END IF
            #TQC-C50044--add--end
      END CONSTRUCT

      CONSTRUCT BY NAME g_wc2 ON luc01

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT
      
      INPUT BY NAME g_bgjob
      END INPUT 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(azp01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azw"
               LET g_qryparam.where ="azw02 = '",g_legal,"'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azp01
               NEXT FIELD azp01
            WHEN INFIELD(luc01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_luc01"
               LET g_qryparam.where ="luc14 = 'Y' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO luc01
               NEXT FIELD luc01
            OTHERWISE
               EXIT CASE
         END CASE 
         
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
                
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
                 
      ON ACTION about         
         CALL cl_about()      
                  
      ON ACTION help          
         CALL cl_show_help()  
                  
      ON ACTION controlg      
         CALL cl_cmdask()     
              
      ON ACTION accept
         EXIT DIALOG
         
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG
             
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION locale 
         LET g_change_lang = TRUE
         EXIT DIALOG
   END DIALOG
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p607_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      
      EXIT PROGRAM
      RETURN
   END IF

END FUNCTION
 
FUNCTION p607_1()
  DEFINE l_luo03    LIKE luo_file.luo03
  DEFINE l_luc28    LIKE luc_file.luc28
  
  BEGIN WORK 
   CALL s_showmsg_init() 
   #--FUN-C30029--12/03/29--add--str--
   CALL p607_chk() 
   IF g_success = 'N' THEN 
      CALL s_showmsg()
      RETURN 
   END IF
   #--FUN-C30029--12/03/29--add--end--
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "    AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p607_azp01_pre FROM g_sql
   DECLARE p607_azp01_cs CURSOR FOR p607_azp01_pre

   FOREACH p607_azp01_cs INTO g_plant_l
      LET g_sql = " SELECT * ",
               "   FROM ",cl_get_target_table(g_plant_l,'luc_file'),
               "       ,",cl_get_target_table(g_plant_l,'lud_file'),
               "  WHERE ", g_wc2 CLIPPED ,
               "    AND lucplant = ? ",
               "    AND  luc01 = lud01 ",
               "    AND  luc10 = '1' ",
               "    AND  luc14 = 'Y' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p607_luc_pre FROM g_sql
      DECLARE p607_luc_cs CURSOR FOR p607_luc_pre

      FOREACH p607_luc_cs USING g_plant_l INTO g_luc.*,g_lud.* 
         SELECT luc28 INTO l_luc28   
           FROM luc_file
          WHERE luc01 = g_luc.luc01
          IF cl_null(l_luc28) THEN    
             CALL cl_err(g_luc.luc01,'axr-393',1)
             LET g_success = 'N' 
             RETURN 
          END IF
 
         #查出支出單的資料
         LET g_sql = " SELECT * ",
                     "   FROM ",cl_get_target_table(g_plant_l,'luo_file'),
                     "       ,",cl_get_target_table(g_plant_l,'lup_file'),
                     "  WHERE luo01 = lup01",
                     "    AND luoconf = 'Y'",
                     "    AND luo01 = '",g_lud.lud03,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
         PREPARE p603_luo_pre FROM g_sql
         DECLARE p603_luo_cs CURSOR FOR p603_luo_pre

         FOREACH p603_luo_cs INTO g_luo.*,g_lup.*
            SELECT luo03 INTO l_luo03 FROM luo_file WHERE luo01 = g_lud.lud03
            IF g_luc.luc25 = 'Y' THEN  #產生的是axrt400的資料
               IF l_luo03 = '1' THEN  #待抵單 
                  CALL p607_del_axrt400()
                  CALL p607_2()
                  CALL p607_3()
               ELSE 
                  CALL p607_del_axrt400()
                  CALL p607_2()
               END IF 
            ELSE    #產生的是axrt410的資料   
               IF l_luo03 = '1' THEN  #待抵單
                  CALL p607_del_axrt410()
                  CALL p607_2() 
               ELSE
                  CALL p607_del_axrt410()
                  CALL p607_2() 
               END IF 
            END IF 
         END FOREACH    
      END FOREACH 
   END FOREACH 
   CALL s_showmsg()
END FUNCTION

FUNCTION p607_2()
   
   #還原費用退款單的財務單號 
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'luc_file'),
               " SET luc28 = NULL WHERE luc01 = '",g_luc.luc01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p607_up_luc_01 FROM g_sql
   EXECUTE p607_up_luc_01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('luc28','',"upd luc",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION 

FUNCTION p607_3()
    #還原待抵單的財務單號
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'luk_file'),
               " SET luk16 = NULL WHERE luk04 = '2' AND luk05 = '",g_luc.luc01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p607_up_luk_01 FROM g_sql
   EXECUTE p607_up_luk_01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('luk16','',"upd luk",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF 

   #還原費用退款單的待抵單號
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'lud_file'),
               " SET lud10 = NULL WHERE lud01 = '",g_luc.luc01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p607_up_lud_01 FROM g_sql
   EXECUTE p607_up_lud_01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('lud28','',"upd lud",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF 
END FUNCTION 
 
FUNCTION p607_del_axrt400()
   DEFINE l_aba19 LIKE aba_file.aba19

   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_luc.luc28

   #判斷是否作廢
   IF g_ooa.ooaconf = 'X' THEN
      CALL s_errmsg('','','','9024',1)
      LET g_success = 'N' 
      RETURN
   END  IF 

   #判斷是否已經送簽或已經核准
   IF g_ooa.ooa34 matches '[Ss]' THEN          
      CALL s_errmsg('','','','mfg3557',1)
      LET g_success = 'N'
      RETURN
   END IF

   #--FUN-C30029--12/03/29--add--str--
   IF l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooa.ooa33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
   END IF
   #--FUN-C30029--12/03/29--add--end--

   CALL p607_z()

   #判斷是否已拋轉總帳,若已拋轉，則退出
   #--FUN-C30029--12/03/29--mark--str--
   #IF NOT cl_null(g_ooa.ooa33) THEN
   #   CALL s_errmsg('',g_ooa.ooa01,'','axr-370',1) 
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #--FUN-C30029--12/03/29--mark--str--
   
   #刪除產生的axrt400的資料及分錄底稿等資料
   DELETE FROM ooa_file WHERE ooa01 = g_ooa.ooa01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','',"del ooa",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF 

   DELETE FROM oob_file WHERE oob01 = g_ooa.ooa01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','',"del oob",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   DELETE FROM npp_file WHERE npp01 = g_ooa.ooa01 AND nppsys = 'AR'
                          AND npp00 = 3  AND npp011 = 1
   DELETE FROM npq_file WHERE npq01 = g_ooa.ooa01 AND npqsys = 'AR'
                          AND npq00 = 3 AND npq011 = 1
   DELETE FROM tic_file WHERE tic04 = g_ooa.ooa01
END FUNCTION 

FUNCTION p607_del_axrt410()
   DEFINE l_aba19 LIKE aba_file.aba19

   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_luc.luc28

   #判斷是否作廢
   IF g_ooa.ooaconf = 'X' THEN
      CALL s_errmsg('','','','9024',1)
      LET g_success = 'N' 
      RETURN
   END IF 

   #判斷是否已經送簽或已經核准
   IF g_ooa.ooa34 matches '[Ss]' THEN          
      CALL s_errmsg('','','','mfg3557',0)
      LET g_success = 'N'
      RETURN
   END IF

   #--FUN-C30029--12/03/29--add--str--
   IF l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooa.ooa33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
   END IF
   #--FUN-C30029--12/03/29--add--end--

   CALL p607_z()

   #判斷是否已拋轉總帳,若已拋轉，則退出
   #--FUN-C30029--12/03/29--mark--str--
   #IF NOT cl_null(g_ooa.ooa33) THEN
   #   CALL s_errmsg('',g_ooa.ooa01,'','axr-370',1) 
   #   LET g_success = 'N'
   #   RETURN
   #END IF
   #--FUN-C30029--12/03/29--mark--end--

   #刪除產生的axrt410的資料及分錄底稿等資料
   DELETE FROM ooa_file WHERE ooa01 = g_ooa.ooa01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','',"del ooa",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF 

   DELETE FROM oob_file WHERE oob01 = g_ooa.ooa01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('','',"del oob",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF

   DELETE FROM npp_file WHERE npp01 = g_ooa.ooa01 AND nppsys = 'AR'
                          AND npp00 = 3  AND npp011 = 1
   DELETE FROM npq_file WHERE npq01 = g_ooa.ooa01 AND npqsys = 'AR'
                          AND npq00 = 3 AND npq011 = 1
   DELETE FROM tic_file WHERE tic04 = g_ooa.ooa01
   DELETE FROM nme_file WHERE nme12 = g_ooa.ooa01

END FUNCTION 

FUNCTION p607_z()

   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   IF g_ooa.ooa02<=g_ooz.ooz09 THEN CALL cl_err('','axr-164',0) RETURN END IF
   IF g_ooa.ooaconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
   CALL p607_z1()
   CALL p607_del_oma()
END FUNCTION 

FUNCTION p607_z1()
   DEFINE n      LIKE type_file.num5     
   DEFINE l_cnt  LIKE type_file.num5      
   DEFINE l_flag LIKE type_file.chr1     
   UPDATE ooa_file SET ooaconf = 'N',ooa34 = '0' WHERE ooa01 = g_ooa.ooa01  
    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooaconf",1)  
       LET g_success = 'N'
       RETURN
    END IF
  
   DECLARE p607_z1_c CURSOR FOR
         SELECT * FROM oob_file WHERE oob01 = g_ooa.ooa01 ORDER BY oob02
   LET l_cnt = 1
   LET l_flag = '0'            
   FOREACH p607_z1_c INTO b_oob.*
    IF STATUS THEN
       CALL s_errmsg('oob01',g_ooa.ooa01,'z1 foreach',STATUS,1) 
       LET g_success = 'N' RETURN 
    END IF
    IF g_success='N' THEN                                                    
      LET g_totsuccess='N'                                                   
      LET g_success='Y' 
    END IF                                                     
    IF l_flag = '0' THEN LET l_flag = b_oob.oob03 END IF
    IF l_flag != b_oob.oob03 THEN
       LET l_cnt = l_cnt + 1
    END IF

    IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN CALL p607_bu_13('-') END IF
    IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
       CALL p607_bu_22('-',l_cnt)
    END IF

    LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
   END IF                                                                          

END FUNCTION 

FUNCTION p607_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1         # +:更新 -:還原
  DEFINE l_omaconf      LIKE oma_file.omaconf,   
         l_omavoid      LIKE oma_file.omavoid,  
         l_cnt          LIKE type_file.num5     
  DEFINE l_oma00        LIKE oma_file.oma00,
         l_oma55        LIKE oma_file.oma55,     
         l_oma57        LIKE oma_file.oma57      
  DEFINE tot4,tot4t     LIKE type_file.num20_6   
  DEFINE tot5,tot6      LIKE type_file.num20_6  
  DEFINE tot8           LIKE type_file.num20_6   
  DEFINE l_omc10        LIKE omc_file.omc10,
         l_omc11        LIKE omc_file.omc11,
         l_omc13        LIKE omc_file.omc13 
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      DISPLAY "bu_13:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
   END IF
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='3'  
            AND oob06=b_oob.oob06
  IF l_cnt>0 THEN RETURN END IF
 
 #預防在收款沖帳確認前,多沖待抵貨款
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob01=ooa01
     AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'    
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
 
 
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07 
  CALL cl_digcut(tot1,t_azi04) RETURNING tot1   
  CALL cl_digcut(tot2,g_azi04) RETURNING tot2    
 

  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t,oma55,oma57 ",    
            "  FROM oma_file ",
            " WHERE oma01=?"
  PREPARE p607_bu_13_p1 FROM g_sql
  DECLARE p607_bu_13_c1 CURSOR FOR p607_bu_13_p1
  OPEN p607_bu_13_c1 USING b_oob.oob06
  FETCH p607_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2,l_oma55,l_oma57          
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL p607_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4      
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t    
  IF l_oma00 = '23' THEN
     SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
      WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND ooaconf <> 'X'  
        AND oob03='1'  AND oob04 = '3' 
        AND ooa01=g_ooa.ooa01
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot2) THEN LET tot2 = 0 END IF
  ELSE
     SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
      WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
        AND oob03='1'  AND oob04 = '3'
     IF cl_null(tot1) THEN LET tot1 = 0 END IF
     IF cl_null(tot2) THEN LET tot2 = 0 END IF
     LET l_oma55 = 0 
     LET l_oma57 = 0 
  END IF                                 

     IF l_oma00 = '23' THEN 
        LET tot1 = un_pay1 - tot1 
        LET tot2 = un_pay2 - tot2
     END IF

    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
       LET tot3 = tot3 - tot4t
    ELSE
       LET tot3 = un_pay2 - tot2 - tot4t
    END IF

    LET g_sql="UPDATE oma_file ", 
                " SET oma55=?,oma57=?,oma61=? ",
              " WHERE oma01=? "
    PREPARE p607_bu_13_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1        
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2        
    EXECUTE p607_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06  
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)             
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN  
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p607_omc(l_oma00,p_sw)  
    END IF
END FUNCTION

FUNCTION p607_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
  DEFINE p_sw            LIKE type_file.chr1                    # +:產生 -:刪除
  DEFINE p_cnt           LIKE type_file.num5     
  DEFINE l_oma            RECORD LIKE oma_file.*
  DEFINE l_omc            RECORD LIKE omc_file.*
  DEFINE li_result       LIKE type_file.num5       
  DEFINE l_cnt           LIKE type_file.num5      

  IF g_bgjob='N' OR cl_null(g_bgjob) THEN
     IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        MESSAGE "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
     ELSE
        DISPLAY "bu_22:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
     END IF
  END IF
  INITIALIZE l_oma.* TO NULL
  IF p_sw = '-' THEN
   # 若溢收款在後已被沖帳,則不可取消確認
     IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
        SELECT COUNT(*) INTO g_cnt FROM oob_file,ooa_file                  
         WHERE oob06 = b_oob.oob06
           AND oob03 = '1' AND oob04 = '3'
           AND ooa01 = oob01 AND ooaconf!='X'                              
        IF g_cnt > 0 THEN
           LET g_showmsg=b_oob.oob06,"/",'1',"/",'3'                       
           CALL s_errmsg('oob06,oob03,oob04',g_showmsg,b_oob.oob06,'axr-206',1) 
           LET g_success = 'N' RETURN                                             
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
       LET g_showmsg=b_oob.oob01,"/",b_oob.oob02                                    
       CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)          
       LET g_success = 'N' 
       RETURN
     ELSE        
        LET b_oob.oob06 = NULL
     END IF
     LET l_cnt = 0
     SELECT count(*) INTO l_cnt
       FROM npq_file
      WHERE npq01 = b_oob.oob01 AND npq02 = b_oob.oob02
     IF l_cnt > 0 THEN
        UPDATE npq_file SET npq23=NULL
          WHERE npq01=b_oob.oob01 AND npq02=b_oob.oob02
        IF STATUS OR SQLCA.SQLCODE THEN
          LET g_showmsg=b_oob.oob01,"/",b_oob.oob02     
          CALL s_errmsg('npq01,npq02',g_showmsg,'upd npq23',SQLCA.SQLCODE,1)   
          LET g_success = 'N' 
          RETURN
        END IF
     END IF
  END IF
END FUNCTION 

FUNCTION p607_omc(p_oma00,p_sw)  
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_omc13           LIKE omc_file.omc13
DEFINE   l_oob09           LIKE oob_file.oob09   
DEFINE   l_oob10           LIKE oob_file.oob10   
DEFINE   l_oox10           LIKE oox_file.oox10   
DEFINE   p_oma00           LIKE oma_file.oma00   
DEFINE   tot4,tot4t        LIKE type_file.num20_6 
DEFINE   p_sw              LIKE type_file.chr1    
 
   LET l_oox10 = 0 
   SELECT SUM(oox10) INTO l_oox10 FROM oox_file 
    WHERE oox00 = 'AR'
      AND oox03 = b_oob.oob06 
      AND oox041 = b_oob.oob19
   IF cl_null(l_oox10) THEN LET l_oox10 = 0 END IF 
   IF p_oma00 MATCHES '2*' THEN 
      LET l_oox10 = l_oox10 * -1
   END IF 
   IF p_oma00 = '23' THEN
      SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19
         AND oob01=ooa01 AND ooa01=g_ooa.ooa01  
         AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))   
      IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
      IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
     
      SELECT omc10,omc11 INTO l_omc10,l_omc11 FROM omc_file
       WHERE omc01 = b_oob.oob06
         AND omc02 = b_oob.oob19 

      IF p_sw='+' THEN
         LET l_oob09 = l_omc10 + l_oob09 
         LET l_oob10 = l_omc11 + l_oob10
      ELSE
         LET l_oob09 = l_omc10 - l_oob09 
         LET l_oob10 = l_omc11 - l_oob10
      END IF
   ELSE
      SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
       WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19 
         AND oob01=ooa01  AND ooaconf = 'Y'
         AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))   
      IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
      IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
   END IF                                                  
                                                          
    #取得冲帐单的待抵金额                                                       
    CALL p607_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t                 
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4               
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t                
    LET l_oob09 = l_oob09 +tot4                                                 
    LET l_oob10 = l_oob10 +tot4t                                                

     LET g_sql=" UPDATE omc_file ", 
                  " SET omc10=?,omc11=? ",
               " WHERE omc01=? AND omc02=? "

     PREPARE p607_bu_13_p3 FROM g_sql
     EXECUTE p607_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc10,11','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
     LET g_sql=" UPDATE omc_file ",
                 " SET omc13=omc09-omc11+ ",l_oox10, 
               " WHERE omc01=? AND omc02=? "
     PREPARE p607_bu_13_p4 FROM g_sql
     EXECUTE p607_bu_13_p4 USING b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc13','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
END FUNCTION

FUNCTION p607_del_oma()
DEFINE  l_oof RECORD LIKE oof_file.*

   IF g_success ='N' THEN RETURN END IF 
   DECLARE p607_sel_oma1 CURSOR FOR 
      SELECT * FROM oof_file WHERE oof01 = g_ooa.ooa01
   
   FOREACH p607_sel_oma1 INTO l_oof.*
      IF STATUS THEN CALL cl_err('sel oma',STATUS,1) EXIT FOREACH END IF   
      DELETE FROM oma_file WHERE oma01 = l_oof.oof05
      IF SQLCA.sqlcode THEN                    
         CALL cl_err3("del","oma_file",l_oof.oof05,"",SQLCA.sqlcode,"","",1) 
         LET g_success = 'N'
         EXIT FOREACH 
      ELSE
         LET g_success ='Y'
      END IF
   END FOREACH 
END FUNCTION

FUNCTION p607_mntn_offset_inv(p_oob06)
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

#--FUN-C30029--12/03/29--add--str--
FUNCTION p607_chk()
   DEFINE l_ooa33    LIKE ooa_file.ooa33
   DEFINE l_aba19    LIKE aba_file.aba19

   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "    AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p607_azp01_pre_01 FROM g_sql
   DECLARE p607_azp01_cs_01 CURSOR FOR p607_azp01_pre_01

   FOREACH p607_azp01_cs_01 INTO g_plant_l
      LET g_sql = " SELECT * ",
               "   FROM ",cl_get_target_table(g_plant_l,'luc_file'),
               "       ,",cl_get_target_table(g_plant_l,'lud_file'),
               "  WHERE ", g_wc2 CLIPPED ,
               "    AND lucplant = ? ",
               "    AND  luc01 = lud01 ",
               "    AND  luc10 = '1' ",
               "    AND  luc14 = 'Y' "
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p607_luc_pre_01 FROM g_sql
      DECLARE p607_luc_cs_01 CURSOR FOR p607_luc_pre_01

      FOREACH p607_luc_cs_01 USING g_plant_l INTO g_luc.*,g_lud.* 
         SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_luc.luc28

         LET g_sql = " SELECT ooa33 FROM ooa_file ",
                     "  WHERE ooa01 = '",g_luc.luc28,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
         PREPARE p607_ooa_pre FROM g_sql
         DECLARE p607_ooa_cs CURSOR FOR p607_ooa_pre

         FOREACH p607_ooa_cs INTO l_ooa33
         CALL s_get_doc_no(g_ooa.ooa01) RETURNING g_t1
         SELECT * INTO l_ooy.* FROM ooy_file WHERE ooyslip=g_t1
            IF NOT cl_null(l_ooa33) THEN
               IF NOT (l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y') THEN
                  CALL s_errmsg('',g_ooa.ooa01,'','axr-370',1) 
                  LET g_success ='N'
                  CONTINUE FOREACH
               END IF
            END IF
            IF l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y' THEN
               LET g_plant_new=g_ooz.ooz02p 
               CALL s_getdbs() 
               LET l_dbs=g_dbs_new
               LET l_dbs=l_dbs.trimRight()
      
               LET g_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),
                           "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                           "    AND aba01 = '",l_ooa33,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE aba_pre22_1 FROM g_sql
               DECLARE aba_cs22_1 CURSOR FOR aba_pre22_1
               OPEN aba_cs22_1
               FETCH aba_cs22_1 INTO l_aba19
               #EXECUTE aba_cs22_1 INTO l_aba19
               IF l_aba19 = 'Y' THEN
                  CALL s_errmsg('',l_ooa33,'','axr-071',1)
                  LET g_success ='N'
                  CONTINUE FOREACH 
               END IF
            END IF
         END FOREACH 
      END FOREACH 
   END FOREACH    
END FUNCTION 
#--FUN-C30029--12/03/29--add--end--

#FUN-C30029
