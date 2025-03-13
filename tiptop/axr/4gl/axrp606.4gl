# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axrp606.4gl
# Descriptions...: 交款單整批生成收款沖帳还原作業
# Date & Author..: FUN-C30029  12/03/19 By xuxz  非直接收款

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc             STRING              #QBE條件
DEFINE g_wc2            STRING              #QBE條件
DEFINE g_change_lang    LIKE type_file.chr1
DEFINE p_row,p_col      LIKE type_file.num5
DEFINE g_sql            STRING 
DEFINE g_lui            RECORD LIKE lui_file.*
DEFINE g_ooa33          LIKE ooa_file.ooa33
DEFINE g_oob03          LIKE oob_file.oob03
DEFINE g_oob04          LIKE oob_file.oob04 
DEFINE g_oob06          LIKE oob_file.oob06
DEFINE g_ooaconf        LIKE ooa_file.ooaconf
DEFINE g_luk16          LIKE luk_file.luk16
DEFINE g_oma33          LIKE oma_file.oma33
DEFINE g_oma55          LIKE oma_file.oma55
DEFINE g_oma57          LIKE oma_file.oma57
DEFINE g_nmh33          LIKE nmh_file.nmh33
DEFINE g_nmg13          LIKE nmg_file.nmg13
DEFINE g_nme10          LIKE nme_file.nme10
DEFINE g_ooa            RECORD LIKE ooa_file.*
DEFINE b_oob            RECORD LIKE oob_file.*
DEFINE tot,tot1,tot2    LIKE type_file.num20_6,           
       tot3             LIKE type_file.num20_6,           
       un_pay1,un_pay2  LIKE type_file.num20_6
DEFINE g_plant_l  LIKE type_file.chr21
DEFINE g_ooa34          LIKE ooa_file.ooa34
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_nme13          LIKE nme_file.nme13
DEFINE g_t1             LIKE type_file.chr5
DEFINE g_str            STRING
   
MAIN 
   DEFINE l_flag LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   LET g_wc = ARG_VAL(1)
   LET g_wc       = cl_replace_str(g_wc, "\\\"", "'")
   LET g_wc2 = ARG_VAL(2)
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
         CALL p606()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p606_1()
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
               CLOSE WINDOW p606_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p606_1()
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

FUNCTION p606()
   LET p_row = 5 LET p_col = 28
   OPEN WINDOW p606_w AT p_row,p_col WITH FORM "axr/42f/axrp606"
      ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')
   CLEAR FORM 

   DIALOG attributes(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON azp01
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            IF cl_null(g_wc) THEN DISPLAY g_plant TO azp01 END IF
      END CONSTRUCT
      
      CONSTRUCT BY NAME g_wc2 ON lui01
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
            WHEN INFIELD(lui01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_lui01"
               LET g_qryparam.where ="luiconf = 'Y' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lui01
               NEXT FIELD lui01
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
      CLOSE WINDOW p606_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
END FUNCTION 

FUNCTION p606_1()
   BEGIN WORK 
   CALL s_showmsg_init()
   #2012-03-31--add
   CALL p606_bak_chk()
   IF g_success = 'N' THEN 
      CALL s_showmsg()
      RETURN 
   END IF
   #2012-03-31--add
   #選擇營運中心
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "    AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p606_azp01_pre FROM g_sql
   DECLARE p606_azp01_cs CURSOR FOR p606_azp01_pre
   FOREACH p606_azp01_cs INTO g_plant_l
      #抓取交款單lui_file，artt611
      LET g_sql = " SELECT * ",
                  "   FROM ",cl_get_target_table(g_plant_l,'lui_file'),
                  "  WHERE ",g_wc2
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p606_lui_pre FROM g_sql
      DECLARE p606_lui_cs CURSOR FOR p606_lui_pre

      FOREACH p606_lui_cs INTO g_lui.*
         #對抓取的符合QBE條件的交款進行如下判斷
         #1.不是直接收款 lui15=='N'
         #2.需要是已經拋轉成功的交款單 luiconf = 'Y' and lui14 is not null
         IF g_lui.lui15 <>'N' THEN 
            CALL s_errmsg('lui15',g_lui.lui01,'','axr-392',1)  #報錯：是直接收款不可以通過本作業還原
            LET g_success = 'N'
            CONTINUE FOREACH 
         END IF 
         IF g_lui.luiconf <> 'Y' THEN 
            CALL s_errmsg('luiconf',g_lui.lui01,'','axr-394',1)  #報錯：交款單確認碼Y.交款確認
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF 
         IF cl_null(g_lui.lui14) THEN 
            CALL s_errmsg('lui14',g_lui.lui01,'','axr-393',1)  #報錯：交款單沒有進行拋轉動作
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF 
         
         #滿足條件的交款單進入以下還原動作
         IF g_lui.lui15 = 'N' AND g_lui.luiconf = 'Y' AND NOT cl_null(g_lui.lui14) THEN 
         
            #根據交款單號得到待抵單單號後，根據luk16刪除axrt300的資料
            CALL p606_del_axrt300()
            
            #判斷axrt400對應的g_lui.lui14是否已經拋轉總賬
            LET g_ooa33 = ''
            SELECT ooa33 INTO g_ooa33 FROM ooa_file WHERE ooa01 = g_lui.lui14
            #IF cl_null(g_ooa33) THEN 
            
               #判斷是否已經審核
               LET g_ooaconf = ''
               SELECT ooaconf,ooa34 INTO g_ooaconf,g_ooa34 FROM ooa_file 
                WHERE ooa01 = g_lui.lui14
               
               #axrt400如果已經審核就先取消審核後進行還原操作
               IF g_ooaconf = 'X' THEN
                  CALL s_errmsg('ooa01',g_lui.lui14,'','9024',1)
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               
               IF g_ooa34 matches '[Ss]' THEN         
                  CALL s_errmsg('ooa01',g_lui.lui14,'','mfg3557',1)
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               
               IF g_ooaconf = 'Y' THEN 
                  IF g_ooa34 = 'S' THEN 
                     CALL s_errmsg('ooa01',g_lui.lui14,'','mfg3557',1)
                     LET g_success = 'N'
                     CONTINUE FOREACH 
                  ELSE  
                     #ooaconf='Y'進行取消審核操作中除了ooa_file 外其他表的操作
                     CALL p606_z_axrt400()
                  END IF
               END IF 
               
               
               #根據axrt400單身oob04的類型來判斷，根據參考單號刪除對應表中資料
               CALL p606_oob_del()
               
               #刪除axrt400的資料
               CALL p606_del_axrt400()
            
               #清空artt611上對應交款單的lui14
               CALL p606_up_lui14()
            #ELSE
             #  CALL s_errmsg('ooa01',g_lui.lui14,'','axr-310',1)  #報錯：已經拋轉總賬
             #  LET g_success = 'N'
            #END IF  
         END IF 
      END FOREACH 
   END FOREACH 
   CALL s_showmsg()
END FUNCTION 

#2012-03-31--add
FUNCTION p606_bak_chk()
   #判斷是否符合還原條件
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "    AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p606_azp01_pre_1 FROM g_sql
   DECLARE p606_azp01_cs_1 CURSOR FOR p606_azp01_pre
   FOREACH p606_azp01_cs_1 INTO g_plant_l
      #抓取交款單lui_file，artt611
      LET g_sql = " SELECT * ",
                  "   FROM ",cl_get_target_table(g_plant_l,'lui_file'),
                  "  WHERE ",g_wc2
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p606_lui_pre_1 FROM g_sql
      DECLARE p606_lui_cs_1 CURSOR FOR p606_lui_pre_1

      FOREACH p606_lui_cs_1 INTO g_lui.*
         #對抓取的符合QBE條件的交款進行如下判斷
         #1.不是直接收款 lui15=='N'
         #2.需要是已經拋轉成功的交款單 luiconf = 'Y' and lui14 is not null
         IF g_lui.lui15 <>'N' THEN 
            CALL s_errmsg('lui15',g_lui.lui01,'','axr-392',1)  #報錯：是直接收款不可以通過本作業還原
            LET g_success = 'N'
            CONTINUE FOREACH 
         END IF 
         IF g_lui.luiconf <> 'Y' THEN 
            CALL s_errmsg('luiconf',g_lui.lui01,'','axr-394',1)  #報錯：交款單確認碼Y.交款確認
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF 
         IF cl_null(g_lui.lui14) THEN 
            CALL s_errmsg('lui14',g_lui.lui01,'','axr-393',1)  #報錯：交款單沒有進行拋轉動作
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF 
         
         #滿足條件的交款單進入以下還原判斷動作
         IF g_lui.lui15 = 'N' AND g_lui.luiconf = 'Y' AND NOT cl_null(g_lui.lui14) THEN 
         
            #根據交款單號得到待抵單單號後，根據luk16還原判斷動作
            CALL p606_del_axrt300_1()
            
            #判斷axrt400對應的g_lui.lui14是否已經拋轉總賬
            LET g_ooa33 = ''
            SELECT ooa33 INTO g_ooa33 FROM ooa_file WHERE ooa01 = g_lui.lui14
	    #已經拋轉總帳，判斷總帳是否審核aglt110
            IF NOT cl_null(g_ooa33) THEN 
            
               #判斷是否已經審核
               LET g_ooaconf = ''
               SELECT ooaconf,ooa34 INTO g_ooaconf,g_ooa34 FROM ooa_file 
                WHERE ooa01 = g_lui.lui14

               IF g_ooaconf = 'X' THEN
                  CALL s_errmsg('ooa01',g_lui.lui14,'','9024',1)
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               
               IF g_ooa34 matches '[Ss]' THEN         
                  CALL s_errmsg('ooa01',g_lui.lui14,'','mfg3557',1)
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               
               IF g_ooaconf = 'Y' THEN 
                  IF g_ooa34 = 'S' THEN 
                     CALL s_errmsg('ooa01',g_lui.lui14,'','mfg3557',1)
                     LET g_success = 'N'
                     CONTINUE FOREACH 
		          ELSE
		             CALL p606_z_axrt400_1()
                  END IF
               END IF 
            END IF  
         END IF 
      END FOREACH 
   END FOREACH 
END FUNCTION

FUNCTION p606_del_axrt300_1()
   DEFINE l_plant_new  LIKE type_file.chr21
   DEFINE l_sql        STRING 
   DEFINE l_aba19      LIKE aba_file.aba19
   #根據交款單號得到待抵單單號後，根據luk16還原判斷動作
   LET g_luk16 = ''
   LET g_sql = " SELECT luk16 FROM ",cl_get_target_table(g_plant_l,'luk_file'),
               "  WHERE luk05 = '",g_lui.lui01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p606_luk16_pre_1 FROM g_sql
   EXECUTE p606_luk16_pre_1 INTO g_luk16
   
   #判斷luk16對應的axrt300中的單據是否拋轉傳票 oma33，是否已經存在已收oma55,oma57
   LET g_oma33 = ''
   SELECT oma33,oma55,oma57 INTO g_oma33,g_oma55,g_oma57
     FROM oma_file
    WHERE oma01 = g_luk16

   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原，還原判斷動作
   CALL s_get_doc_no(g_luk16) RETURNING g_t1 
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_oma33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL s_errmsg('oma01',g_luk16,'','axr-370',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET l_plant_new=g_ooz.ooz02p 
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(l_plant_new,'aba_file'), 
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_oma33,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
      PREPARE aba_pre1_1 FROM l_sql
      DECLARE aba_cs1_1 CURSOR FOR aba_pre1_1
      OPEN aba_cs1_1
      FETCH aba_cs1_1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('oma33',g_oma33,'','axr-071',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   
   IF g_oma55 <> 0 THEN 
      CALL s_errmsg('oma55',g_oma55,'','axr-395',1)  #報錯：oma55
      LET g_success = 'N'
      RETURN 
   END IF 
   IF g_oma57 <> 0 THEN
      CALL s_errmsg('oma57',g_oma57,'','axr-395',1)  #報錯：oma57
      LET g_success = 'N'
      RETURN 
   END IF 
END FUNCTION

FUNCTION p606_z_axrt400_1()
   DEFINE l_plant_new  LIKE type_file.chr21
   DEFINE l_sql        STRING 
   DEFINE l_aba19      LIKE aba_file.aba19
   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_lui.lui14
   IF g_ooa.ooa34 = "S" THEN
      CALL s_errmsg('ooa01',g_lui.lui14,'','mfg3557',1)
      RETURN
   END IF
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   IF g_ooa.ooa02<=g_ooz.ooz09 THEN 
      CALL s_errmsg('ooa01',g_lui.lui14,'','axr-164',1)
      LET g_success = 'N'
      RETURN 
   END IF
   IF g_ooa.ooaconf = 'X' THEN
       CALL s_errmsg('ooa01',g_lui.lui14,'','9024',1) RETURN
   END IF
   IF NOT cl_null(g_ooa.ooa992) THEN
      CALL s_errmsg('ooa01',g_lui.lui14,'','axr-950',1)
      LET g_success='N'
      RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原，還原判斷動作
   CALL s_get_doc_no(g_ooa.ooa01) RETURNING g_t1 
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_ooa.ooa33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL s_errmsg('ooa01',g_lui.lui14,'','axr-370',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET l_plant_new=g_ooz.ooz02p 
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(l_plant_new,'aba_file'), 
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_ooa.ooa33,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
      PREPARE aba_pre_1 FROM l_sql
      DECLARE aba_cs_1 CURSOR FOR aba_pre_1
      OPEN aba_cs_1
      FETCH aba_cs_1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('ooa33',g_ooa.ooa33,'','axr-071',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
END FUNCTION 
#2012-03-31--add

FUNCTION p606_z_axrt400()
   DEFINE l_plant_new  LIKE type_file.chr21
   DEFINE l_sql        STRING 
   DEFINE l_aba19      LIKE aba_file.aba19
   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_lui.lui14
   IF g_ooa.ooa34 = "S" THEN
      CALL s_errmsg('ooa01',g_lui.lui14,'','mfg3557',1)
      RETURN
   END IF
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   IF g_ooa.ooa02<=g_ooz.ooz09 THEN 
      CALL s_errmsg('ooa01',g_lui.lui14,'','axr-164',1)
      LET g_success = 'N'
      RETURN 
   END IF
   IF g_ooa.ooaconf = 'X' THEN
       CALL s_errmsg('ooa01',g_lui.lui14,'','9024',1) RETURN
   END IF
   IF NOT cl_null(g_ooa.ooa992) THEN
      CALL s_errmsg('ooa01',g_lui.lui14,'','axr-950',1)
      LET g_success='N'
      RETURN
   END IF
   #FUN-C30029--add--str--2012.03.30
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_ooa.ooa01) RETURNING g_t1 
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_ooa.ooa33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL s_errmsg('ooa01',g_lui.lui14,'','axr-370',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET l_plant_new=g_ooz.ooz02p 
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(l_plant_new,'aba_file'), 
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_ooa.ooa33,"'"
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('ooa33',g_ooa.ooa33,'','axr-071',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooa.ooa33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
   END IF
   #FUN-C30029--add--end--2012.03.30
   CALL p606_z1()
   CALL p606_del_oma()
END FUNCTION 

FUNCTION p606_z1()
   DEFINE n      LIKE type_file.num5     
   DEFINE l_cnt  LIKE type_file.num5      
   DEFINE l_flag LIKE type_file.chr1     
   UPDATE ooa_file SET ooaconf = 'N',ooa34 = '0' WHERE ooa01 = g_ooa.ooa01  
   IF STATUS OR SQLCA.SQLCODE THEN
      LET g_showmsg=g_ooa.ooa01                                   
      CALL s_errmsg('ooa01',g_showmsg,'upd ooaconf',SQLCA.SQLCODE,1)          
      LET g_success = 'N' 
      RETURN
   END IF
  
   DECLARE p606_z1_c CURSOR FOR
         SELECT * FROM oob_file WHERE oob01 = g_ooa.ooa01 ORDER BY oob02
   LET l_cnt = 1
   LET l_flag = '0'            
   FOREACH p606_z1_c INTO b_oob.*
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
    # b_oob.oob03 = '1' AND b_oob.oob04 = '1' 後面資料已經做刪除，故這裡不再進行更新操作
    # b_oob.oob03 = '1' AND b_oob.oob04 = '2' 後面資料已經做刪除，故這裡不再進行更新操作
    IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN CALL p606_bu_13('-') END IF

    IF b_oob.oob03 = '2' AND b_oob.oob04 = '1' THEN CALL p606_bu_21('-') END IF

    IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
       CALL p606_bu_22('-',l_cnt)
    END IF

    LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
   END IF                                                                          

END FUNCTION 

FUNCTION p606_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
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
  PREPARE p606_bu_13_p1 FROM g_sql
  DECLARE p606_bu_13_c1 CURSOR FOR p606_bu_13_p1
  OPEN p606_bu_13_c1 USING b_oob.oob06
  FETCH p606_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2,l_oma55,l_oma57          
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL p606_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
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
    PREPARE p606_bu_13_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1        
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2        
    EXECUTE p606_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06  
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)             
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN  
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p606_omc(l_oma00,p_sw)  
    END IF
END FUNCTION

FUNCTION p606_bu_21(p_sw)                  #更新應收帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1            # +:更新 -:還原
  DEFINE l_omaconf      LIKE oma_file.omaconf, 
         l_omavoid      LIKE oma_file.omavoid,  
         l_cnt          LIKE type_file.num5      
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE l_omc   RECORD LIKE omc_file.*        
  DEFINE l_omc10        LIKE omc_file.omc10     
  DEFINE l_omc11        LIKE omc_file.omc11    
  DEFINE l_omc13        LIKE omc_file.omc13    
  DEFINE l_oob10        LIKE oob_file.oob10    
  DEFINE l_oob09        LIKE oob_file.oob09     
  DEFINE tot4,tot4t     LIKE type_file.num20_6  
  DEFINE tot5,tot6      LIKE type_file.num20_6  
 
  IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      DISPLAY "bu_21:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
  END IF
 
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  IF g_ooz.ooz62='Y' THEN
     SELECT COUNT(*) INTO l_cnt FROM oob_file
      WHERE oob01=b_oob.oob01
        AND oob02<b_oob.oob02
        AND oob03='2'
        AND oob04='1'  
        AND oob06=b_oob.oob06
        AND oob15=b_oob.oob15
        AND oob19=b_oob.oob19      
  ELSE
     SELECT COUNT(*) INTO l_cnt FROM oob_file
      WHERE oob01=b_oob.oob01
        AND oob02<b_oob.oob02
        AND oob03='2'
        AND oob04='1'               
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
            "  FROM oma_file ", 
            " WHERE oma01=?"
  PREPARE p606_bu_21_p1 FROM g_sql
  DECLARE p606_bu_21_c1 CURSOR FOR p606_bu_21_p1
  OPEN p606_bu_21_c1 USING b_oob.oob06
  FETCH p606_bu_21_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL p606_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4       
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t     
    #add by danny 020309 期末調匯(A008)
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN  
       CALL s_errmsg('oma01',b_oob.oob06,'un_pay<pay','axr-196',1) LET g_success='N' RETURN 
       END IF
    END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3                                                       
       IF tot3 <0 THEN                                                          
          CALL s_errmsg('ooa01',g_lui.lui14,'','axr-185',1)          
          LET g_success ='N'                                                    
          RETURN                                                                
       END IF                                                                   
       LET tot3 = tot3 - tot4t
    ELSE
       LET tot3 = un_pay2 - tot2 - tot4t
    END IF
    LET g_sql="UPDATE oma_file ",
                " SET oma55=?,oma57=?,oma61=? ",
               " WHERE oma01=? "
    PREPARE p606_bu_21_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1         
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2        
    EXECUTE p606_bu_21_p2 USING tot1, tot2, tot3, b_oob.oob06
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)             
       LET g_success = 'N'
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN  
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p606_omc(l_oma00,p_sw)  
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
               "  FROM omb_file,oma_file ", 
               " WHERE oma01=omb01 AND omb01=? AND omb03 = ? "
     PREPARE p606_bu_21_p1b FROM g_sql
     DECLARE p606_bu_21_c1b CURSOR FOR p606_bu_21_p1b
     OPEN p606_bu_21_c1b USING b_oob.oob06,b_oob.oob15
     FETCH p606_bu_21_c1b INTO l_oma00,l_omaconf,un_pay1,un_pay2
     IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
     IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       #取得未沖金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,b_oob.oob15) RETURNING tot3
    ELSE
       LET tot3 = un_pay2  - tot2
    END IF
     LET g_sql="UPDATE omb_file ",    
                 " SET omb34=?,omb35=?,omb37=? ",
               " WHERE omb01=? AND omb03=?"
     PREPARE p606_bu_21_p2b FROM g_sql
     EXECUTE p606_bu_21_p2b USING tot1, tot2, tot3, b_oob.oob06,b_oob.oob15
     IF STATUS THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                        
        CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35',STATUS,1)   
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                         
        CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35','axr-198',1) LET g_success = 'N' RETURN  
     END IF
  END IF
END FUNCTION

FUNCTION p606_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
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
## No.2695 modify 1998/10/31 若溢收款在後已被沖帳,則不可取消確認
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
        CALL s_errmsg('oma01',b_oob.oob06,'del oma',STATUS,1)         
        LET g_success = 'N' 
        RETURN 
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('oma01',b_oob.oob06,'del oma','axr-199',1)        
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
        CALL s_errmsg('oov01',b_oob.oob06,'del oov',STATUS,1)            
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

FUNCTION p606_del_oma()
   DEFINE  l_oof RECORD LIKE oof_file.*

   IF g_success ='N' THEN RETURN END IF 
   DECLARE p606_sel_oma1 CURSOR FOR 
      SELECT * FROM oof_file WHERE oof01 = g_ooa.ooa01
   
   FOREACH p606_sel_oma1 INTO l_oof.*
      IF STATUS THEN CALL cl_err('sel oma',STATUS,1) EXIT FOREACH END IF   
      DELETE FROM oma_file WHERE oma01 = l_oof.oof05
      IF SQLCA.sqlcode THEN                    
         CALL s_errmsg('oma01',l_oof.oof05,'del oma',STATUS,1) 
         LET g_success = 'N'
         EXIT FOREACH 
      ELSE
         LET g_success ='Y'
      END IF
   END FOREACH 
END FUNCTION

FUNCTION p606_del_axrt300()
   DEFINE l_plant_new  LIKE type_file.chr21
   DEFINE l_sql        STRING 
   DEFINE l_aba19      LIKE aba_file.aba19
   #根據交款單號得到待抵單單號後，根據luk16刪除axrt300的資料
   LET g_luk16 = ''
   LET g_sql = " SELECT luk16 FROM ",cl_get_target_table(g_plant_l,'luk_file'),
               "  WHERE luk05 = '",g_lui.lui01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p606_luk16_pre FROM g_sql
   EXECUTE p606_luk16_pre INTO g_luk16
   
   #判斷luk16對應的axrt300中的單據是否拋轉傳票 oma33，是否已經存在已收oma55,oma57
   LET g_oma33 = ''
   SELECT oma33,oma55,oma57 INTO g_oma33,g_oma55,g_oma57
     FROM oma_file
    WHERE oma01 = g_luk16
    
   #FUN-C30029--add--str--2012.03.30
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_luk16) RETURNING g_t1 
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_oma33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL s_errmsg('oma01',g_luk16,'','axr-370',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET l_plant_new=g_ooz.ooz02p 
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(l_plant_new,'aba_file'), 
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_oma33,"'"
 	  CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
      CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('oma33',g_oma33,'','axr-071',1)
         LET g_success='N'
         RETURN
      END IF
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_oma33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
   END IF
   #FUN-C30029--add--end--2012.03.30
   
   IF g_oma55 <> 0 THEN 
      CALL s_errmsg('oma55',g_oma55,'','axr-395',1)  #報錯：oma55
      LET g_success = 'N'
      RETURN 
   END IF 
   IF g_oma57 <> 0 THEN
      CALL s_errmsg('oma57',g_oma57,'','axr-395',1)  #報錯：oma57
      LET g_success = 'N'
      RETURN 
   END IF 
   
   #符合刪除條件進行刪除
   IF g_oma55 = 0 AND g_oma57 = 0 AND cl_null(g_oma33) THEN 
      DELETE FROM omc_file WHERE omc01 = g_luk16
      IF STATUS THEN
         LET g_showmsg=g_luk16                                  
         CALL s_errmsg('omc01',g_showmsg,"del omc",STATUS,1)                   
         LET g_success ='N'
         RETURN
      END IF 
      DELETE FROM oma_file WHERE oma01 = g_luk16
      IF STATUS THEN
         LET g_showmsg=g_luk16                                  
         CALL s_errmsg('oma01',g_showmsg,"del oma",STATUS,1)                   
         LET g_success ='N'
         RETURN
      END IF
      LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'luk_file'),
                  "    SET luk16 = '' ",
                  "  WHERE luk05= '",g_lui.lui01,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
      PREPARE p606_up_luk16_pre FROM g_sql
      EXECUTE p606_up_luk16_pre
      IF STATUS OR SQLCA.SQLCODE THEN
         LET g_showmsg=g_lui.lui01                                   
         CALL s_errmsg('luk05',g_showmsg,'upd luk16',SQLCA.SQLCODE,1)          
         LET g_success = 'N' 
         RETURN
      END IF
   END IF 
END FUNCTION 

FUNCTION p606_oob_del() #根據單身刪除對應的表的資料
   LET g_sql = " SELECT oob03,oob04,oob06 ",
               "   FROM oob_file ",
               "  WHERE oob01 = '",g_lui.lui14,"'"
   PREPARE p606_oob04_pre FROM g_sql
   DECLARE p606_oob04_cs CURSOR FOR p606_oob04_pre
   
   #抓取oob_file中的oob03，oob04，oob06來判斷應該進行的刪除動作
   FOREACH p606_oob04_cs INTO g_oob03,g_oob04,g_oob06
   
      #借方
      IF g_oob03 = '1' THEN 
         CASE g_oob04
         
            #支票，刪除nmh_file  anmt200 同時判斷是否拋轉傳票nmh33
            WHEN '1'
               LET g_nmh33 = ''
               SELECT nmh33 INTO g_nmh33 FROM  nmh_file 
                WHERE nmh01 = g_oob06
               IF cl_null(g_nmh33) THEN 
                  DELETE FROM nmh_file WHERE nmh01 = g_oob06
                  IF STATUS THEN
                     LET g_showmsg=g_oob06                                 
                     CALL s_errmsg('nmh01',g_showmsg,"del nmh",STATUS,1)                   
                     LET g_success ='N'
                     RETURN
                  END IF
               ELSE 
                  CALL s_errmsg('nmh01',g_oob06,'','axr-310',1)  #報錯：已經拋轉總賬
                  LET g_success = 'N'
               END IF 
                        
            #T/T刪除nmg_file、npk_file anmt302,同時判斷是否拋轉傳票nmg13
            #刪除nme_file anmt300,同時判斷是否拋轉傳票nme10
            WHEN '2'
               LET g_nmg13 = ''
               SELECT nmg13 INTO g_nmg13 FROM nmg_file 
                WHERE nmg01 = g_oob06
               IF cl_null(g_nme13) THEN
                  DELETE FROM npk_file WHERE npk00 = g_oob06
                  IF STATUS THEN
                     LET g_showmsg=g_oob06                                 
                     CALL s_errmsg('npk01',g_showmsg,"del npk",STATUS,1)                   
                     LET g_success ='N'
                     RETURN
                  END IF
                  DELETE FROM nmg_file WHERE nmg00 = g_oob06
                  IF STATUS THEN
                     LET g_showmsg=g_oob06                                 
                     CALL s_errmsg('nmg00',g_showmsg,"del nmg",STATUS,1)                   
                     LET g_success ='N'
                     RETURN
                  END IF
               ELSE 
                  CALL s_errmsg('nmg01',g_oob06,'','axr-310',1)  #報錯：已經拋轉總賬
                  LET g_success = 'N'
               END IF   
               
               
                  DELETE FROM nme_file WHERE nme12 = g_oob06
                  IF STATUS THEN
                     LET g_showmsg=g_oob06                                 
                     CALL s_errmsg('nme12',g_showmsg,"del nme",STATUS,1)                   
                     LET g_success ='N'
                     RETURN
                  END IF
               

            #待地沖賬，更新oma_file，axrt300,此操作在取消審核時已經進行 oob04= '3'
            #賬款折扣，此類別只需要刪除oob_file的資料，再後面對axrt400的刪除操作已經進行 oob04=  '6'
            OTHERWISE 
               EXIT CASE 
         END CASE 
      END IF 
      #貸方，當axrt400取消審核後，借方資料無需對其他表進行刪除操作
   END FOREACH 
END FUNCTION 

FUNCTION p606_del_axrt400()  #刪除axrt400的資料
   LET g_doc.column1 = "ooa01"        
   LET g_doc.value1 = g_lui.lui14      
   CALL cl_del_doc() 
   #刪除分錄底稿
   DELETE FROM npp_file WHERE npp01 = g_ooa.ooa01 AND nppsys = 'AR'
                          AND npp00 = 3  AND npp011 = 1
   DELETE FROM npq_file WHERE npq01 = g_ooa.ooa01 AND npqsys = 'AR'
                          AND npq00 = 3 AND npq011 = 1
                          
   #刪除oob_file
   DELETE FROM oob_file WHERE oob01 = g_lui.lui14
   IF STATUS THEN
      LET g_showmsg=g_lui.lui14                              
      CALL s_errmsg('oob01',g_showmsg,"del oob",STATUS,1)                   
      LET g_success ='N'
      RETURN
   END IF
   #刪除ooa_file
   DELETE FROM  ooa_file WHERE ooa01 = g_lui.lui14
   IF STATUS THEN
      LET g_showmsg=g_lui.lui14                              
      CALL s_errmsg('ooa01',g_showmsg,"del ooa",STATUS,1)                   
      LET g_success ='N'
      RETURN
   END IF
END FUNCTION 

FUNCTION p606_up_lui14()
   #清空artt611上對應交款單的lui14
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'lui_file'),
               "    SET lui14 = '' ",
               "  WHERE lui01 = '",g_lui.lui01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p606_lui14_pre FROM g_sql
   EXECUTE p606_lui14_pre
   IF STATUS OR SQLCA.SQLCODE THEN
       LET g_showmsg=g_lui.lui01                                   
       CALL s_errmsg('lui01',g_showmsg,'upd lui14',SQLCA.SQLCODE,1)          
       LET g_success = 'N' 
       RETURN
   END IF 
END FUNCTION 

FUNCTION p606_mntn_offset_inv(p_oob06)
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

FUNCTION p606_omc(p_oma00,p_sw)  #No.MOD-B80122 add
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
    CALL p606_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t                 
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4               
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t                
    LET l_oob09 = l_oob09 +tot4                                                 
    LET l_oob10 = l_oob10 +tot4t                                                

     LET g_sql=" UPDATE omc_file ", 
                  " SET omc10=?,omc11=? ",
               " WHERE omc01=? AND omc02=? "

     PREPARE p606_bu_13_p3 FROM g_sql
     EXECUTE p606_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc10,11','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
     LET g_sql=" UPDATE omc_file ", 
                 " SET omc13=omc09-omc11+ ",l_oox10, 
               " WHERE omc01=? AND omc02=? "
     PREPARE p606_bu_13_p4 FROM g_sql
     EXECUTE p606_bu_13_p4 USING b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc13','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
END FUNCTION
#FUN-C30029
