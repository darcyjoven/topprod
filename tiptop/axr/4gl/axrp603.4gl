# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrp603.4gl
# Descriptions...: 退款單整批生成沖帳作業
# Date & Author..: FUN-C20020	 12/02/06 By lujh 
# Modify.........: NO:TQC-C20375 12/02/22 By xuxz 交款單立賬時溢收科目修改為ool25,ool251
# Modify.........: NO:TQC-C20359 12/02/22 By lujh 检查分录底稿改成s_chknpq()
# Modify.........: NO:TQC-C20430 12/02/23 By wangrr 設置退款類型ooa35的值
# Modify.........: NO:MOD-C30114 12/03/09 By zhangweib 透過artt610所有自動產生的單據,確認後,狀態碼oma64應為1.已核准
# Modify.........: NO:MOD-C30607 12/03/12 By zhangweib 自動編號時若未在營收參數設定作業(axrs020)中找到對應單別,需要給與正確的報錯訊息
# Modify.........: NO:MOD-C30636 12/03/12 By zhangweib 修改g_wc段的BEFORE CONSTRUCT語句,使之只會在初始狀態下賦默認值
#                                                      新增AFTER FIELD ar_slip,ar_slip2段資料有效性的判斷
# Modify.........: NO:TQC-C30188 12/03/14 By zhangweib 1.產生的axrt300,axrt400,axrt410的資料根據單別的判斷是否拋轉總帳
#                                                      2.拋轉總帳拿到批次的事物結束后再做拋轉
# Modify.........: NO:FUN-C30029 12/03/19 By lujh  由於axrt400新增了來源類型ooa38字段  所以產生axrt400資料時 ooa38默認給值1
#                                                  原來單身的財務編號拿到了單頭  重新判斷是否已拋轉
#                                                  LET g_ooa.ooa38='2' 还原成 '1'
#                                                  直接产生审核的财务单据  不在需要根据单别设置来判断
# Modify.........: NO:FUN-C30029 12/04/01 By zhangweib 產生的單據都為已審核狀態,去掉ooyconf = 'Y'的判斷
# Modify.........: NO:TQC-C40103 12/04/13 By lujh azp01再次執行時也能默認值
# Modify.........: NO:TQC-C40121 12/04/16 By lujh 產生財務單據axrt400,axrt410時,單身轉票據給默認值N
# Modify.........: NO:TQC-C50049 12/05/08 By xuxz 單別默認值
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_wc       STRING                   #QBE_1的條件
DEFINE g_wc2      STRING                   #QBE_2的條件
DEFINE g_sql      STRING                   #組sql

DEFINE tm         RECORD                   #條件選項
         ar_slip     LIKE ooa_file.ooa01,  #收款單別
         ar_slip2    LIKE ooa_file.ooa01   #退款單別
                  END RECORD
DEFINE g_t1           LIKE ooy_file.ooyslip
DEFINE p_row,p_col    LIKE type_file.num5 
DEFINE li_result      LIKE type_file.num5
DEFINE l_ac           LIKE type_file.num5
DEFINE l_ac_a         LIKE type_file.num5
DEFINE g_change_lang  LIKE type_file.chr1 
DEFINE g_bookno1      LIKE aza_file.aza81                
DEFINE g_bookno2      LIKE aza_file.aza82 
DEFINE g_flag         LIKE type_file.chr1  
DEFINE g_forupd_sql     STRING     
DEFINE g_wc_gl          STRING  
DEFINE g_wc_gl2         STRING                  #No.TQC-C30188   Add
DEFINE g_str            STRING   
DEFINE tot,tot1,tot2    LIKE type_file.num20_6,          
       tot3             LIKE type_file.num20_6,          
       un_pay1,un_pay2  LIKE type_file.num20_6  
DEFINE g_luj07          LIKE luj_file.luj07
#QBE1條件sql賦值
DEFINE g_plant_l  LIKE type_file.chr21     #營運中心
#抓取退款單賦值
DEFINE g_luc   RECORD LIKE luc_file.*
DEFINE g_lud   RECORD LIKE lud_file.*
DEFINE g_lua   RECORD LIKE lua_file.*
DEFINE g_luo   RECORD LIKE luo_file.* 
DEFINE g_lup   RECORD LIKE lup_file.*
DEFINE b_oob   RECORD LIKE oob_file.*
DEFINE g_oow   RECORD LIKE oow_file.*
#insert操作
DEFINE g_nme   RECORD LIKE nme_file.*
DEFINE g_oob   RECORD LIKE oob_file.*
DEFINE g_ooa   RECORD LIKE ooa_file.*


   
MAIN 
   DEFINE l_flag  LIKE type_file.chr1

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE tm.* TO NULL
   LET g_wc        = ARG_VAL(1)
   LET g_wc        = cl_replace_str(g_wc, "\\\"", "'")    #No.TQC-C30188  Add
   LET g_wc2       = ARG_VAL(2)
   LET g_wc2       = cl_replace_str(g_wc2, "\\\"", "'")   #No.TQC-C30188  Add
   LET tm.ar_slip  = ARG_VAL(3)
   LET tm.ar_slip2 = ARG_VAL(4)
   LET g_bgjob     = ARG_VAL(5)

   IF cl_null(g_bgjob) THEN 
      LET g_bgjob ="N"
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
         CALL p603()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p603_1()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL p603_axrp590()   #No.TQC-C30188   Add
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p603_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p603_1()
         IF g_success = "Y" THEN
            COMMIT WORK
            CALL p603_axrp590()   #No.TQC-C30188   Add
            CALL cl_err('','lib-284',1) #TQC-C20430
         ELSE
            ROLLBACK WORK
            CALL cl_err('','abm-020',0) #TQC-C20430
         END IF
         #CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END MAIN

FUNCTION p603()
   DEFINE l_ooyacti    LIKE ooy_file.ooyacti    #No.MOD-C30636   Add
   DEFINE l_azp01      LIKE azp_file.azp01    #TQC-C40103  add

   LET p_row = 5 LET p_col = 28
   
   OPEN WINDOW p603_w AT p_row,p_col WITH FORM "axr/42f/axrp603"
      ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')
   CLEAR FORM 

   
   DIALOG attributes(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON azp01
      
         BEFORE CONSTRUCT 
           #DISPLAY g_plant TO azp01   #No.MOD-C30636   Mark
            #IF cl_null(g_wc) THEN DISPLAY g_plant TO azp01 END IF   #No.MOD-C30636   Add  #TQC-C40103  mark
            #TQC-C40103--add--str--
            LET l_azp01 = GET_FLDBUF(azp01)
            IF cl_null(l_azp01) THEN
               DISPLAY g_plant TO azp01
            END IF
            #TQC-C40103--add--end--
            #TQC-C50049---add--str
            IF cl_null(tm.ar_slip) THEN
               #賦初值
               SELECT oow14 INTO tm.ar_slip FROM oow_file
               IF SQLCA.sqlcode THEN
                  LET tm.ar_slip = ""
               END IF
               DISPLAY tm.ar_slip TO ar_slip
            END IF
            IF cl_null(tm.ar_slip2) THEN
               SELECT oow15 INTO tm.ar_slip2 FROM oow_file
               IF SQLCA.sqlcode THEN
                  LET tm.ar_slip2 = ""
               END IF
               DISPLAY tm.ar_slip2 TO ar_slip2
            END IF
            #TQC-C50049--add--end 
      END CONSTRUCT 

      CONSTRUCT BY NAME g_wc2 ON luc01,luc03,luc07

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT

      INPUT BY NAME tm.ar_slip,tm.ar_slip2
         BEFORE INPUT 
            IF cl_null(tm.ar_slip) THEN 
               #賦初值
               SELECT oow14 INTO tm.ar_slip FROM oow_file
               IF SQLCA.sqlcode THEN 
                  LET tm.ar_slip = ""
               END IF
               DISPLAY tm.ar_slip TO ar_slip          
            END IF 
            IF cl_null(tm.ar_slip2) THEN
               SELECT oow15 INTO tm.ar_slip2 FROM oow_file
               IF SQLCA.sqlcode THEN 
                  LET tm.ar_slip2 = ""
               END IF 
               DISPLAY tm.ar_slip2 TO ar_slip2
            END IF 
            
         AFTER FIELD ar_slip
            IF NOT cl_null(tm.ar_slip) THEN 
           #No.MOD-C30636   ---start---   Add
               LET l_ooyacti = NULL
               SELECT ooyacti INTO l_ooyacti FROM ooy_file
                WHERE ooyslip = ar_slip
               IF l_ooyacti <> 'Y' THEN
                  CALL cl_err(tm.ar_slip,'axr-956',1)
                  NEXT FIELD ar_slip
               END IF
               CALL s_check_no("axr",tm.ar_slip,"","30","","","")
                    RETURNING li_result,tm.ar_slip
               IF (NOT li_result) THEN
                  NEXT FIELD ar_slip
               END IF
               DISPLAY BY NAME tm.ar_slip
           #No.MOD-C30636   ---end---     Add
            END IF 

        #No.MOD-C30636   ---start---   Add
         AFTER FIELD ar_slip2 
            IF NOT cl_null(tm.ar_slip2) THEN
               LET l_ooyacti = NULL
               SELECT ooyacti INTO l_ooyacti FROM ooy_file
                WHERE ooyslip = ar_slip2
               IF l_ooyacti <> 'Y' THEN
                  CALL cl_err(tm.ar_slip2,'axr-956',1)
                  NEXT FIELD ar_slip2
               END IF
               CALL s_check_no("axr",tm.ar_slip2,"","32","","","")
                    RETURNING li_result,tm.ar_slip2
               IF (NOT li_result) THEN
                  NEXT FIELD ar_slip2
               END IF
               DISPLAY BY NAME tm.ar_slip2
            END IF
        #No.MOD-C30636   ---end---     Add

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
            WHEN INFIELD(luc03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_occ"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO luc03
               NEXT FIELD luc03
            WHEN INFIELD(ar_slip)
               CALL q_ooy( FALSE,TRUE,tm.ar_slip,'30','AXR') RETURNING g_t1
               LET tm.ar_slip = g_t1
               DISPLAY BY NAME tm.ar_slip
               NEXT FIELD ar_slip    #No.MOD-C30636   Add
            WHEN INFIELD(ar_slip2)
               CALL q_ooy( FALSE,TRUE,tm.ar_slip2,'32','AXR') RETURNING g_t1
               LET tm.ar_slip2 = g_t1
               DISPLAY BY NAME tm.ar_slip2
               NEXT FIELD ar_slip2    #No.MOD-C30636   Add
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
      CLOSE WINDOW p603_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

         
END FUNCTION 

FUNCTION p603_1()
   DEFINE l_luo03    LIKE luo_file.luo03
   DEFINE l_luk16    LIKE luk_file.luk16
   DEFINE l_aag05    LIKE aag_file.aag05
   DEFINE l_oob06    LIKE oob_file.oob06
   DEFINE l_lud06    LIKE lud_file.lud06
   DEFINE l_lud10    LIKE lud_file.lud10
   DEFINE l_luc28    LIKE luc_file.luc28  #FUN-C30029  add
   
     
   BEGIN WORK 
   CALL s_showmsg_init() 

   #抓取QBE1條件中g_legal的營運中心sql
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "    AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p603_azp01_pre FROM g_sql
   DECLARE p603_azp01_cs CURSOR FOR p603_azp01_pre
   
   FOREACH p603_azp01_cs INTO g_plant_l
      #查出类型为支出单的退款单
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
      PREPARE p603_luc_pre FROM g_sql
      DECLARE p603_luc_cs CURSOR FOR p603_luc_pre
      
      FOREACH p603_luc_cs USING g_plant_l INTO g_luc.*,g_lud.* 
          #SELECT lud06,lud10 INTO l_lud06,l_lud10   #FUN-C30029  mark
           SELECT luc28,lud10 INTO l_luc28,l_lud10   #FUN-C30029  add
           FROM luc_file,lud_file
          WHERE luc01 = lud01
            AND luc01 = g_luc.luc01 
          #IF NOT cl_null(l_lud06) OR NOT cl_null(l_lud10) THEN   #FUN-C30029  mark
          IF NOT cl_null(l_luc28) OR NOT cl_null(l_lud10) THEN    #FUN-C30029  add
             CALL cl_err(g_luc.luc01,'aco-228',1)
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
            SELECT luo03 INTO l_luo03 FROM luo_file WHERE luo01=g_lud.lud03
            CALL p603_2()   #借
            CALL p603_3()   #貸
            IF g_luc.luc25 = 'Y' THEN    
               CALL p603_ooa_1()   #插入ooa_file表
               CALL p603_chk()
               IF l_luo03 = '1' THEN  #待抵單
                  #IF g_ooy.ooyconf = 'Y' THEN   #FUN-C30029  mark
                     CALL p603_axrt400_conf()
                     IF g_success = 'Y' THEN  
                        CALL p603_axrt400_upd()
                        SELECT DISTINCT(oob06) INTO l_oob06 FROM oob_file WHERE oob01 = g_ooa.ooa01 AND oob03 = '2'
                        UPDATE luk_file SET luk16 = l_oob06 WHERE luk04 = '2' AND luk05 = g_luc.luc01
                        IF STATUS THEN
                           CALL s_errmsg('',g_luc.luc01,'upd luk16',STATUS,1)              
                           LET g_success = 'N' 
                           RETURN
                        END IF

                        UPDATE lud_file SET lud10 = l_oob06 WHERE lud01 = g_luc.luc01
                        IF STATUS THEN
                           CALL s_errmsg('',g_luc.luc01,'upd lud10',STATUS,1)              
                           LET g_success = 'N' 
                           RETURN
                        END IF
                     END IF 
                  #END IF  #FUN-C30029  mark
               ELSE #費用單
                  #IF g_ooy.ooyconf = 'Y' THEN   #FUN-C30029  mark
                      CALL p603_axrt400_conf()
                      IF g_success = 'Y' THEN 
                         CALL p603_axrt400_upd()
                      END IF 
                   #END IF   #FUN-C30029  mark
               END IF  
              #No.TQC-C30188   ---start---   Add
               SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip 
               IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN                            #No.MOD-C30607   Mark  #No.FUN-C30029   Unmark
              #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_ooy.ooyconf = 'Y' THEN    #No.MOD-C30607   Add   #No.FUN-C30029   Mark
                  IF cl_null(g_wc_gl) THEN
                     LET g_wc_gl = ' npp011 = 1 AND npp01 IN ("',g_ooa.ooa01,'"'
                   ELSE
                      LET g_wc_gl = g_wc_gl,',"',g_ooa.ooa01,'"'
                  END IF
               END IF
              #No.TQC-C30188   ---start---   Add
            ELSE
               CALL p603_ooa_2()   #插入ooa_file表
               CALL p603_chk()
               IF l_luo03 = '1' THEN  #待抵單
                  #IF g_ooy.ooyconf = 'Y' THEN   #FUN-C30029  mark
                     CALL p603_axrt400_conf()
                     IF g_success = 'Y' THEN 
                        CALL p603_axrt400_upd()
                        CALL p603_ins_nme()
                           
                        SELECT DISTINCT(oob06) INTO l_oob06 FROM oob_file WHERE oob01 = g_ooa.ooa01 AND oob03 = '2'
                        UPDATE luk_file SET luk16 = l_oob06 WHERE luk04 = '2' AND luk05 = g_luc.luc01
                        IF STATUS THEN
                           CALL s_errmsg('',g_luc.luc01,'upd luk16',STATUS,1)              
                           LET g_success = 'N' 
                           RETURN
                        END IF
                     END IF 
                  #END IF     #FUN-C30029  mark
               ELSE #費用單
                  #IF g_ooy.ooyconf = 'Y' THEN   #FUN-C30029  mark
                     CALL p603_axrt400_conf()
                     IF g_success = 'Y' THEN 
                        CALL p603_axrt400_upd()
                        CALL p603_ins_nme()
                     END IF 
                  #END IF    #FUN-C30029  mark
               END IF 
              #No.TQC-C30188   ---start---   Add
               SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip2  
               IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN                           #No.MOD-C30607    Mark   #No.FUN-C30029   Unmark
              #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_ooy.ooyconf = 'Y' THEN   #No.MOD-C30607    Add    #No.FUN-C30029   Mark
                  IF cl_null(g_wc_gl2) THEN
                     LET g_wc_gl2 = ' npp011 = 1 AND npp01 IN ("',g_ooa.ooa01,'"'
                  ELSE
                     LET g_wc_gl2 = g_wc_gl,',"',g_ooa.ooa01,'"'
                  END IF
               END IF
              #No.TQC-C30188   ---start---   Add
            END IF  
         END FOREACH 

      END FOREACH
   END FOREACH 
   CALL s_showmsg()
   
END FUNCTION

FUNCTION p603_chk()
  #SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip    #No.TQC-C30188   Mark
   IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN 
      CALL s_t400_gl(g_ooa.ooa01,'0')
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN 
         CALL s_t400_gl(g_ooa.ooa01,'1')
      END IF 
      #CALL s_ar_y_chk()   #TQC-C20359   mark
      #--TQC-C20359--add--str--
      CALL s_get_bookno(YEAR(g_ooa.ooa02)) RETURNING g_flag, g_bookno1,g_bookno2
      CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN 
         CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
      END IF
      #--TQC-C20359--add--end--
   END IF 
END FUNCTION 

FUNCTION p603_2()  #借 
   DEFINE l_oma   RECORD LIKE oma_file.*
   DEFINE l_omc   RECORD LIKE omc_file.* 
   DEFINE l_oob02  LIKE oob_file.oob02
   DEFINE l_luk16  LIKE luk_file.luk16
   DEFINE l_aag05  LIKE aag_file.aag05
   DEFINE l_oma54t LIKE oma_file.oma54t
   DEFINE l_oma55  LIKE oma_file.oma55
   DEFINE l_occ02  LIKE occ_file.occ02
   DEFINE l_omc02  LIKE omc_file.omc02
   DEFINE l_oma18  LIKE oma_file.oma18
   DEFINE l_oma23  LIKE oma_file.oma23
   DEFINE l_oma15  LIKE oma_file.oma15
   DEFINE l_omc07  LIKE omc_file.omc07
   DEFINE l_oma24  LIKE oma_file.oma24
   DEFINE l_oma02  LIKE oma_file.oma02
   DEFINE l_luo03  LIKE luo_file.luo03
   DEFINE l_oaj04  LIKE oaj_file.oaj04

   SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_luc.luc03
   SELECT luo03 INTO l_luo03 FROM luo_file WHERE luo01 = g_lud.lud03

   LET g_sql = " SELECT luk16 ",
               "   FROM ",cl_get_target_table(g_plant_l,'luk_file'),
               "       ,",cl_get_target_table(g_plant_l,'lup_file'),
               "  WHERE luk01 ='", g_lup.lup03,"'",
               "    AND lup02 ='", g_lup.lup02,"'",
               "    AND lukconf = 'Y' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p603_luk_pre FROM g_sql
   EXECUTE p603_luk_pre INTO l_luk16

   IF g_luc.luc25 = 'Y' THEN    #產生axrt400收款資料 
      CALL s_auto_assign_no("AXR",tm.ar_slip,g_today,"30","ooa_file","ooa01","","","")		
      RETURNING li_result,g_ooa.ooa01
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF  
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip    #No.TQC-C30188   Ad
    ELSE   #有退款 產生axrt410退款資料
       CALL s_auto_assign_no("AXR",tm.ar_slip2,g_today,"32","ooa_file","ooa01","","","")	
       RETURNING li_result,g_ooa.ooa01
       IF (NOT li_result) THEN
          LET g_success = 'N'
          RETURN
       END IF
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip2   #No.TQC-C30188   Ad
    END IF 

   LET g_oob.oob01 = g_ooa.ooa01 
   LET g_oob.oob15 = NULL
   LET g_oob.oob09 = g_lud.lud07t		
   LET g_oob.oob10 = g_lud.lud07t		
   LET g_oob.oob12 = ''
   LET g_oob.ooblegal = g_legal 
   
   IF l_luo03 = '1' THEN  #待抵單
      LET g_sql = "SELECT * FROM oma_file,omc_file ",    		
               " WHERE oma68 = '",g_luc.luc03,"' ",
               "   AND oma69 = '",l_occ02,"'",                  
               "   AND oma01 = omc01 ",              		
               "   AND oma00 LIKE '2%' ",                                                                                  		
               "   AND omavoid = 'N' ",                                                                                       		
               "   AND omaconf = 'Y' ",
               "   AND oma01 = '",l_luk16,"'" 
      PREPARE p603_g_b_p1 FROM g_sql                                                                                               		
      DECLARE p603_g_b_c1 CURSOR FOR p603_g_b_p1 

      FOREACH p603_g_b_c1 INTO l_oma.*,l_omc.* 
         CALL s_get_bookno(YEAR(l_oma.oma02)) RETURNING g_flag, g_bookno1,g_bookno2
         IF g_flag='1' THEN		
            CALL s_errmsg('','','','aoo-081',1)  
            LET g_success = 'N'
         END IF 
         
         SELECT MAX(oob02)+1 INTO l_oob02 FROM oob_file WHERE oob01 = g_oob.oob01
         IF cl_null(l_oob02) THEN 
            LET l_oob02 = '1'
         END IF   
         LET g_oob.oob02 = l_oob02
         LET g_oob.oob03 = '1'		
         LET g_oob.oob04 = '3'
         LET g_oob.oob06 = l_luk16	
         LET g_oob.oob19 = l_omc.omc02
         LET g_oob.oob11 = l_oma.oma18
         LET g_oob.oob14 = NULL
         LET g_oob.oob07 = l_oma.oma23	
         LET l_aag05 = ''		
         SELECT aag05 INTO l_aag05 FROM aag_file		
          WHERE aag01 = g_oob.oob11		
            AND aag00 = g_bookno1		
         IF l_aag05 = 'Y' THEN		
            LET g_oob.oob13 = l_oma.oma15		
         ELSE		
            LET g_oob.oob13 = ''		
         END IF 
         IF g_ooz.ooz07 = 'Y' THEN       		
            LET g_oob.oob08 = l_omc.omc07   		
         ELSE                                       		
            LET g_oob.oob08 = l_oma.oma24    		
         END IF  
         
         SELECT oma54t,oma55 INTO l_oma54t,l_oma55 FROM oma_file WHERE oma01 = l_luk16		
         IF l_oma54t - l_oma55 < g_lud.lud07t THEN 		
            CALL s_errmsg('','','','axr-669',1)		
            LET g_success = 'N'		
         END IF 
         INSERT INTO oob_file VALUES (g_oob.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
            LET g_success = 'N'
         END IF
      END FOREACH 
         
   ELSE   #費用單
      SELECT MAX(oob02)+1 INTO l_oob02 FROM oob_file WHERE oob01 = g_oob.oob01
      IF cl_null(l_oob02) THEN 
         LET l_oob02 = '1'
      END IF
      LET g_oob.oob02 = l_oob02
      LET g_oob.oob03 = '1'	
      LET g_oob.oob04 = '6'
      LET g_oob.oob06 = NULL 	
      LET g_oob.oob19 = '1' 
      SELECT oaj04 INTO l_oaj04 FROM oaj_file WHERE oaj01 = g_lup.lup05 
      LET g_oob.oob11 = l_oaj04
      LET g_oob.oob13 = NULL 
      LET g_oob.oob14 = NULL		
      LET g_oob.oob07 = g_aza.aza17
      LET g_oob.oob08 = '1' 
      INSERT INTO oob_file VALUES (g_oob.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
         LET g_success = 'N'
      END IF
   END IF 
END FUNCTION 

FUNCTION p603_3()   #貸
   DEFINE l_rxy  RECORD LIKE rxy_file.*
   DEFINE l_oob02 LIKE oob_file.oob02
   DEFINE l_luk16 LIKE luk_file.luk16
   DEFINE l_oma23 LIKE oma_file.oma23
   DEFINE l_luo03 LIKE luo_file.luo03
   DEFINE l_ooe02 LIKE ooe_file.ooe02
   DEFINE l_oob11 LIKE oob_file.oob11
   DEFINE l_oow04 LIKE oow_file.oow04
   DEFINE l_rxx02 LIKE rxx_file.rxx02

   INITIALIZE g_oob.* TO NULL

   SELECT luo03 INTO l_luo03 FROM luo_file WHERE luo01 = g_lud.lud03
   LET g_sql = " SELECT luk16 ",
               "   FROM ",cl_get_target_table(g_plant_l,'luk_file'),
               "       ,",cl_get_target_table(g_plant_l,'lup_file'),
               "  WHERE luk01 ='", g_lup.lup03,"'",
               "    AND lup02 ='", g_lup.lup02,"'",
               "    AND lukconf = 'Y' "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p603_luk_pre_1 FROM g_sql
   EXECUTE p603_luk_pre_1 INTO l_luk16

   IF l_luo03 = '1' THEN  #待抵單
      SELECT oma23 INTO l_oma23 FROM oma_file WHERE oma01 = l_luk16
      LET g_oob.oob07 = l_oma23
   ELSE  #費用單
      LET g_oob.oob07 = g_aza.aza17
   END IF  
   LET g_oob.oob03 = '2'
   LET g_oob.oob19 = '1'
   LET g_oob.oob20 = 'N'    #TQC-C40121  add
   LET g_oob.ooblegal = g_legal
    
   IF g_luc.luc25 = 'Y' THEN    #產生axrt400收款資料 
      CALL s_auto_assign_no("AXR",tm.ar_slip,g_today,"30","ooa_file","ooa01","","","")		
      RETURNING li_result,g_ooa.ooa01
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF
      LET g_oob.oob01 = g_ooa.ooa01
      SELECT MAX(oob02)+1 INTO l_oob02 FROM oob_file WHERE oob01 = g_oob.oob01
      IF cl_null(l_oob02) THEN 
         LET l_oob02 = 1
      END IF 
      LET g_oob.oob02 = l_oob02
      LET g_oob.oob04 = '2'	
      LET g_oob.oob08 = '1'
      LET g_oob.oob09 = g_lud.lud07t
      LET g_oob.oob10 = g_lud.lud07t
      INSERT INTO oob_file VALUES (g_oob.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
         LET g_success = 'N'
      END IF   
      
    ELSE   #有退款 產生axrt410退款資料
       CALL s_auto_assign_no("AXR",tm.ar_slip2,g_today,"32","ooa_file","ooa01","","","")	
       RETURNING li_result,g_ooa.ooa01
       IF (NOT li_result) THEN
          LET g_success = 'N'
          RETURN
       END IF

       LET g_sql = " SELECT rxx02 ",
                   "   FROM ",cl_get_target_table(g_plant_l,'rxx_file'),
                   "  WHERE rxx01 ='",g_luc.luc01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
       PREPARE p603_rxx_pre FROM g_sql
       EXECUTE p603_rxx_pre INTO l_rxx02
        
       LET g_sql = " SELECT * ",
               "   FROM ", cl_get_target_table(g_plant_l,'rxy_file'),
               "  WHERE rxy01 = '",g_luc.luc01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
       PREPARE p603_rxy_pre FROM g_sql
       DECLARE p603_rxy_cs CURSOR FOR p603_rxy_pre
       FOREACH p603_rxy_cs INTO l_rxy.*
          SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01=l_rxx02 
          SELECT nma05 INTO l_oob11 FROM nma_file WHERE nma01=l_ooe02 AND nmaacti='Y'
          SELECT oow04 INTO l_oow04 FROM oow_file 

          LET g_oob.oob01 = g_ooa.ooa01
          SELECT MAX(oob02)+1 INTO l_oob02 FROM oob_file WHERE oob01 = g_oob.oob01
          IF cl_null(l_oob02) THEN 
             LET l_oob02 = 1
          END IF 
          LET g_oob.oob02 = l_oob02
          LET g_oob.oob04 = 'A'	
          LET g_oob.oob06 = g_ooa.ooa01
          IF cl_null(l_rxy.rxy05) THEN 
             LET l_rxy.rxy05 = 0
          END IF 
          LET g_oob.oob09 = l_rxy.rxy05
          LET g_oob.oob10 = l_rxy.rxy05
          LET g_oob.oob07 = g_aza.aza17
          LET g_oob.oob08 = '1' 
          LET g_oob.oob11 = l_oob11
          LET g_oob.oob17 = l_ooe02
          LET g_oob.oob18 = l_oow04
          SELECT nmc05 INTO g_oob.oob21 FROM nmc_file WHERE nmc01 = g_oob.oob18

          INSERT INTO oob_file VALUES (g_oob.*)
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
             LET g_success = 'N'
          END IF
       END FOREACH    
    END IF
END FUNCTION 

FUNCTION p603_ooa_1()
   DEFINE l_occ02  LIKE occ_file.occ02
   DEFINE l_occ67  LIKE occ_file.occ67
   DEFINE l_ool    RECORD LIKE ool_file.*

   LET g_ooa.ooa00 = '1'
   LET g_ooa.ooa37 = '1' #收款
   LET g_ooa.ooa38 = '1'  #FUN-C30029  add
   LET g_ooa.ooa02 = g_today
   LET g_ooa.ooa03 = g_luc.luc03
   SELECT occ02,occ67 INTO l_occ02,l_occ67 FROM occ_file WHERE occ01 = g_luc.luc03
   LET g_ooa.ooa032 = l_occ02
   LET g_ooa.ooa14 = g_luc.luc26
   LET g_ooa.ooa15 = g_luc.luc27
   LET g_ooa.ooa23 = g_aza.aza17
   IF NOT cl_null(l_occ67) THEN		
      LET g_ooa.ooa13 = l_occ67	
   ELSE		
      LET g_ooa.ooa13 = g_ooz.ooz08		
   END IF		
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31d,g_ooa.ooa32d
     FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='1'
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31c,g_ooa.ooa32c
     FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='2'
   IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
   IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF
   IF cl_null(g_ooa.ooa31c) THEN LET g_ooa.ooa31c=0 END IF
   IF cl_null(g_ooa.ooa32c) THEN LET g_ooa.ooa32c=0 END IF
   LET g_ooa.ooa32d = cl_digcut(g_ooa.ooa32d,g_azi04)  
   LET g_ooa.ooa32c = cl_digcut(g_ooa.ooa32c,g_azi04)  
   LET g_ooa.ooalegal = g_legal
   LET g_ooa.ooa40 = ' '
   LET g_ooa.ooaconf = 'N'
   LET g_ooa.ooauser = g_user
   LET g_ooa.ooaoriu = g_user 
   LET g_ooa.ooaorig = g_grup 
   LET g_ooa.ooagrup = g_grup
   LET g_ooa.ooadate = g_today
   LET g_ooa.ooa35='2'          #TQC-C20430
   LET g_ooa.ooa36=g_luc.luc01  #TQC-C20430
   LET g_ooa.ooa34 = 0       #No.TQC-C30188   Add
   LET g_ooa.ooamksg = 'N'   #No.TQC-C30188   Add
   INSERT INTO ooa_file values(g_ooa.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
      RETURN   #TQC-C20430
   END IF 
   SELECT * INTO l_ool.* FROM ool_file WHERE ool01 = g_ooa.ooa13
   #UPDATE oob_file SET oob11 = l_ool.ool54 #TQC-C20375 mark
   UPDATE oob_file SET oob11 = l_ool.ool25,oob111 = l_ool.ool251#TQC-C20375 add
    WHERE oob01 = g_ooa.ooa01
      AND oob03 = '2'
      AND oob04 = '2' 

   UPDATE lud_file SET lud06 = g_ooa.ooa01 WHERE lud03 = g_lud.lud03
   IF STATUS THEN
      CALL s_errmsg('',g_lud.lud03,'upd lud06',STATUS,1)              
      LET g_success = 'N' 
      RETURN
   END IF
   
   #TQC-C20430--add--begin
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'luc_file'),
               " SET luc28 ='", g_ooa.ooa01,"' WHERE luc01 = '",g_luc.luc01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p603_up_luc_1 FROM g_sql
   EXECUTE p603_up_luc_1
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('luc28',g_ooa.ooa01,"upd luc",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   #TQC-C20430--add--end
END FUNCTION 

FUNCTION p603_ooa_2()
   DEFINE l_occ02  LIKE occ_file.occ02
   DEFINE l_occ67  LIKE occ_file.occ67

   LET g_ooa.ooa00 = '1'
   LET g_ooa.ooa37 = '2' #退款
   LET g_ooa.ooa02 = g_today
   SELECT occ02,occ67 INTO l_occ02,l_occ67 FROM occ_file WHERE occ01 = g_luc.luc03
   LET g_ooa.ooa03 = g_luc.luc03
   LET g_ooa.ooa032 = l_occ02
   LET g_ooa.ooa14 = g_luc.luc26
   LET g_ooa.ooa15 = g_luc.luc27
   LET g_ooa.ooa23 = g_aza.aza17
   IF NOT cl_null(l_occ67) THEN
      LET g_ooa.ooa13 = l_occ67
   ELSE
      LET g_ooa.ooa13 = g_ooz.ooz08
   END IF
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31d,g_ooa.ooa32d
     FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='1'
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31c,g_ooa.ooa32c
     FROM oob_file WHERE oob01=g_ooa.ooa01 AND oob03='2'
   IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
   IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF
   IF cl_null(g_ooa.ooa31c) THEN LET g_ooa.ooa31c=0 END IF
   IF cl_null(g_ooa.ooa32c) THEN LET g_ooa.ooa32c=0 END IF
   LET g_ooa.ooa32d = cl_digcut(g_ooa.ooa32d,g_azi04)  
   LET g_ooa.ooa32c = cl_digcut(g_ooa.ooa32c,g_azi04)  
   LET g_ooa.ooalegal = g_legal
   #LET g_ooa.ooa38 = '1'  #TQC-C20430 mark--
   LET g_ooa.ooa38 = '1'   #FUN-C30029 add
   #LET g_ooa.ooa38='2'     #TQC-C20430    #FUN-C30029
   LET g_ooa.ooa40 = ' '
   LET g_ooa.ooaconf = 'N'
   LET g_ooa.ooauser = g_user
   LET g_ooa.ooaoriu = g_user 
   LET g_ooa.ooaorig = g_grup 
   LET g_ooa.ooagrup = g_grup
   LET g_ooa.ooadate = g_today
   LET g_ooa.ooa35='1'          #TQC-C20430
   LET g_ooa.ooa36=g_luc.luc01  #TQC-C20430
   LET g_ooa.ooa34 = 0       #No.TQC-C30188   Add
   LET g_ooa.ooamksg = 'N'   #No.TQC-C30188   Add
   INSERT INTO ooa_file values(g_ooa.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
      RETURN   #TQC-C20430
   END IF 
   UPDATE lud_file SET lud06 = g_ooa.ooa01 WHERE lud03 = g_lud.lud03
   IF STATUS THEN
      CALL s_errmsg('',g_lud.lud03,'upd lud06',STATUS,1)              
      LET g_success = 'N' 
      RETURN
   END IF
  
   #TQC-C20430--add--begin
   LET g_sql = " UPDATE ",cl_get_target_table(g_plant_l,'luc_file'),
               " SET luc28 ='", g_ooa.ooa01,"' WHERE luc01 = '",g_luc.luc01,"'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_l) RETURNING g_sql
   PREPARE p603_up_luc_2 FROM g_sql
   EXECUTE p603_up_luc_2
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('luc28',g_ooa.ooa01,"upd luc",SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   #TQC-C20430--add--end
END FUNCTION 

FUNCTION p603_axrt400_conf() #axrt400 審核
   DEFINE l_oob RECORD LIKE oob_file.*
   DEFINE l_oma00 LIKE oma_file.oma00
   DEFINE l_apa00 LIKE apa_file.apa00
   DEFINE l_cnt LIKE type_file.num5
   IF g_ooa.ooaconf = 'X' THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','9024',1)
      LET g_success = 'N'
   END IF 
   IF g_ooa.ooaconf = 'X' THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-101',1)
      LET g_success = 'N'
   END IF 
   IF cl_null(g_ooa.ooa33d) THEN 
      LET g_ooa.ooa33d = 0 
   END IF 
   IF g_ooa.ooa32d != g_ooa.ooa32c - g_ooa.ooa33d THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-203',1)
      LET g_success = 'N'
   END IF 
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz0 = '0'
   IF g_ooa.ooa02 <= g_ooz.ooz09 THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-164',1)
      LET g_success = 'N'
   END IF 
   IF g_ooa.ooaconf = 'Y' THEN 
      LET g_success = 'Y'
   END IF 
   SELECT count(*) INTO l_cnt FROM oob_file
    WHERE oob01 = g_ooa.ooa01
   IF l_cnt = 0 THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','mfg-009',1)
      LET g_success = 'N'
   END IF 

   LET l_cnt = 0 
   IF g_ooz.ooz62 = 'Y' THEN 
      SELECT count(*) INTO l_cnt FROM  oob_file
       WHERE oob01 = g_ooa.ooa01
         AND oob03 = '2'
         AND oob04 = '1'
         AND (oob06 IS NULL OR oob06 = ' '  OR oob15 IS NULL OR oob15 <= 0)
      IF cl_null(l_cnt) THEN 
         LET l_cnt = 0 
      END IF 
      IF l_cnt >0 THEN 
         CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-900',1)
         LET g_success = 'N'
      END IF 
   END IF
   LET l_cnt = 0 
   SELECT count(*) INTO l_cnt
     FROM oob_file,oma_file
    WHERE oma02 > g_ooa.ooa02
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01

   IF l_cnt > 0 THEN 
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-371',1)
      LET g_success = 'N'
   END IF
   LET g_sql = "SELECT oob03,oob04,oob06 FROM oob_file ",
               " WHERE oob01 = '",g_ooa.ooa01,"'",
               "   AND ((oob03 = '1' AND (oob04 = '3' OR oob04 = '9'))",
               "    OR  (oob03 = '2' AND (oob04 = '1' OR oob04 = '9')))"
   PREPARE p603_oob06_pre FROM g_sql
   DECLARE p603_oob06_cs CURSOR FOR p603_oob06_pre

   SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00= '0'
   FOREACH p603_oob06_cs INTO l_oob.*
      IF STATUS THEN 
         CALL s_errmsg('','','','Foreach',1)
         LET g_success = 'N'
      END IF 
      IF l_oob.oob03 = '1' THEN 
         IF l_oob.oob04 = '3' THEN 
            SELECT oma00 INTO l_oma00 FROM oma_file
             WHERE oma01 = l_oob.oob06
            IF (l_oma00 != '21') AND (l_oma00 != '22') AND (l_oma00 != '23') AND
               (l_oma00 != '24') AND (l_oma00 != '25') AND (l_oma00 != '26') AND    
               (l_oma00 != '27') AND (l_oma00 != '28') THEN
               CALL s_errmsg('',l_oob.oob06,'','axr-992',1) 
               LET g_success = 'N'
            END IF 
         END IF 
         IF l_oob.oob04 = '9' THEN 
            IF g_ooa.ooa02 <= g_apz.apz57 THEN   #立帳日期不可小於關帳日期
               CALL cl_err('','axr-084',1)
               LET g_errno='N' 
            END IF
            SELECT apa00 INTO l_apa00 FROM apa_file
             WHERE apa01 = l_oob.oob06 
               AND apa02 <= g_ooa.ooa02        
            IF (l_apa00 != '11') AND (l_apa00 != '12') AND (l_apa00 != '15') AND (l_apa00 != '13') THEN   
               CALL s_errmsg('',l_oob.oob06,'','axr-993',1)
               LET g_success = 'N'
            END IF   
         END IF    
      END IF 
      IF l_oob.oob03='2' THEN
         IF l_oob.oob04 = '1' THEN 
            SELECT oma00 INTO l_oma00 FROM oma_file
             WHERE oma01 = l_oob.oob06
            IF (l_oma00 !='11') AND (l_oma00 !='12') AND
               (l_oma00 !='13') AND (l_oma00 !='14') AND (l_oma00 !='15') AND (l_oma00 !='17') THEN   
               CALL s_errmsg('',l_oob.oob06,'','axr-994',1) 
               LET g_success = 'N'
            END IF 
         END IF 
         IF l_oob.oob04 = '9' THEN 
            IF g_ooa.ooa02 <= g_apz.apz57 THEN   #立帳日期不可小於關帳日期
               CALL cl_err('','axr-084',1)
               LET g_errno='N' 
            END IF
            SELECT apa00 INTO l_apa00 FROM apa_file
             WHERE apa01 = l_oob.oob06
               AND apa02 <= g_ooa.ooa02       
            IF l_apa00 NOT MATCHES '2*' THEN 
               CALL s_errmsg('',l_oob.oob06,'','axr-995',1) #CHI-A80031
               LET g_success = 'N'
            END IF   
         END IF                    
      END IF    
   END FOREACH 
END FUNCTION  

FUNCTION p603_axrt400_upd()
   DEFINE l_cnt LIKE type_file.num5
   LET g_forupd_sql = "SELECT * FROM ooa_file WHERE ooa01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p603_cl CURSOR FROM g_forupd_sql
   LET g_sql = " SELECT * FROM ooa_file ",
               "  WHERE ooa01 = '",g_ooa.ooa01,"'",
               "    AND ooaconf = 'N' "
   PREPARE p603_400_pre FROM g_sql
   DECLARE p603_400_cs CURSOR WITH HOLD FOR p603_400_pre
   OPEN p603_cl USING g_ooa.ooa01
   FETCH p603_cl INTO g_ooa.*
   
   FOREACH p603_400_cs INTO g_ooa.*
      CALL s_get_bookno(YEAR(g_ooa.ooa02)) RETURNING g_flag, g_bookno1,g_bookno2
     #SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip    #No.TQC-C30188   Mark
      LET g_ooa.ooa34 = '1'
      UPDATE ooa_file SET ooa34 = g_ooa.ooa34 WHERE ooa01 = g_ooa.ooa01
      IF STATUS THEN 
         LET g_success = 'N'
         LET g_totsuccess='N'
      END IF 

      CALL p603_y1()

      IF g_success = 'N' THEN 
         LET g_totsuccess='N'
         LET g_success = 'Y'
      END IF 

      CALL p603_ins_oma()

      IF g_ooy.ooydmy1 = 'Y' THEN 
         SELECT count(*) INTO l_cnt FROM npq_file
          WHERE npq01 = g_ooa.ooa01
            AND npq00 = 3
            AND npqsys = 'AR'
            AND npq011 = 1
         IF l_cnt = 0 THEN
         
            CALL p603_gen_glcr(g_ooa.*,g_ooy.*)

         END IF 
         IF g_success = 'Y' THEN 
            CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN 
               CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
            END IF
         END IF 
         IF g_success = 'N' THEN 
            CONTINUE FOREACH 
         END IF
      END IF 
   END FOREACH 

   IF g_totsuccess = 'N' THEN 
      LET g_success = 'N' 
   END IF 
   IF g_success = 'Y' THEN 
      LET g_ooa.ooa34 = '1' 
      LET g_ooa.ooaconf = 'Y'
      
      #CALL p603_carry_voucher()#產生的是400的資料，不是401的資料，故mark

      CALL cl_flow_notify(g_ooa.ooa01,'Y')
   ELSE 
      LET g_ooa.ooaconf = 'N'
      LET g_success = 'N'
      LET g_totsuccess = 'N'
   END IF 

   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01

  #No.TQC-C30188   ---start---   Mark
  #IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_wc_gl = 'npp01 = "',g_ooa.ooa01,'" AND npp011 = 1'
  #   LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #No.TQC-810036
  #   CALL cl_cmdrun_wait(g_str)
  #END IF
  #No.TQC-C30188   ---start---   Mark
END FUNCTION 

FUNCTION p603_y1()
   DEFINE n       LIKE type_file.num5      
   DEFINE l_cnt   LIKE type_file.num5     
   DEFINE l_flag  LIKE type_file.chr1      
   

   UPDATE ooa_file SET ooaconf = 'Y',ooa34 = '1' WHERE ooa01 = g_ooa.ooa01  
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'upd ooa_file',SQLCA.sqlcode,1)
      #CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooaconf",1)  
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL p603_hu2()
 
   IF g_success = 'N' THEN
      RETURN
   END IF      
 
   DECLARE p603_y1_c CURSOR FOR SELECT * FROM oob_file
                                 WHERE oob01 = g_ooa.ooa01
                                 ORDER BY oob02
 
   LET l_cnt = 1
   LET l_flag = '0'
   FOREACH p603_y1_c INTO b_oob.*         
      IF STATUS THEN
         CALL s_errmsg('oob01',g_ooa.ooa01,'y1 foreach',STATUS,1) 
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
         CALL p603_bu_11('+')
      END IF
 
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '2' THEN
         CALL p603_bu_12('+')
      END IF
 
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL p603_bu_13('+')
      END IF
 
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '1' THEN
         CALL p603_bu_21('+')
      END IF
 
      IF b_oob.oob03 = '2' AND b_oob.oob04 = '2' THEN
         CALL p603_bu_22('+',l_cnt)
      END IF
 
      LET l_cnt = l_cnt + 1
 
   END FOREACH
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF
END FUNCTION 

FUNCTION p603_ins_oma()
DEFINE  i     LIKE  type_file.num5
DEFINE  l_oma RECORD LIKE oma_file.*
DEFINE  l_occ RECORD LIKE occ_file.*
DEFINE  l_oof RECORD LIKE oof_file.*
DEFINE  li_result    LIKE type_file.num5

   IF g_success ='N' THEN RETURN END IF  
   DECLARE p603_sel_oof CURSOR  FOR 
      SELECT * FROM oof_file WHERE oof01 = g_ooa.ooa01
   
   
   FOREACH p603_sel_oof INTO l_oof.*
      IF STATUS THEN CALL cl_err('sel oof',STATUS,1) EXIT FOREACH END IF   
         LET l_oma.oma00  = '14'
         CALL s_auto_assign_no("axr",l_oof.oof05,l_oof.oof06,"14","oma_file","oma01","","","")
              RETURNING li_result,l_oof.oof05
         IF  li_result THEN
             LET l_oma.oma01  = l_oof.oof05 
             UPDATE oof_file SET oof05 = l_oof.oof05
              WHERE oof01 = g_ooa.ooa01
                AND oof02 = l_oof.oof02
         ELSE
             CALL s_errmsg('','',l_oma.oma01,'mfg-059',1)     #MOD-BC0248 add 
             LET g_success = 'N'
             RETURN 
         END IF
          
         LET l_oma.oma02   = l_oof.oof06
         LET l_oma.oma03   = l_oof.oof03
         LET l_oma.oma032  = l_oof.oof032
         LET l_oma.oma68   = l_oof.oof04
         LET l_oma.oma69   = l_oof.oof042
         LET l_oma.oma18   = l_oof.oof10
         LET l_oma.oma181  = l_oof.oof101
         
         SELECT * INTO l_occ.*
           FROM occ_file
          WHERE occ01 = l_oof.oof03
                  
         LET l_oma.oma05   = l_occ.occ08
         LET l_oma.oma14   = g_ooa.ooa14
         LET l_oma.oma15   = g_ooa.ooa15
         LET l_oma.oma930  = s_costcenter(g_ooa.ooa15)
         LET l_oma.oma21   = l_occ.occ41
         LET l_oma.oma23   = l_oof.oof07
         LET l_oma.oma24   = l_oof.oof08
         LET l_oma.oma25   = l_occ.occ43
         LET l_oma.oma32   = l_occ.occ45
         LET l_oma.oma042  = l_occ.occ11
         LET l_oma.oma043  = l_occ.occ18
         LET l_oma.oma044  = l_occ.occ231
         LET l_oma.oma09   = l_oma.oma02
         
         CALL s_rdatem(l_oma.oma03,l_oma.oma32,l_oma.oma02,l_oma.oma09,l_oma.oma02,g_plant)
              RETURNING l_oma.oma11,l_oma.oma12
              
         SELECT gec04,gec05,gec07
           INTO l_oma.oma211,l_oma.oma212,l_oma.oma213
           FROM gec_file 
          WHERE gec01=l_oma.oma21
            AND gec011='2'
            
         SELECT occ67 INTO l_oma.oma13 FROM occ_file
          WHERE occ01 = l_oof.oof03
         IF cl_null(l_oma.oma13) THEN
            LET l_oma.oma13 = g_ooz.ooz08
         END IF
         
         LET l_oma.oma66  = g_plant
         LET l_oma.omalegal = g_legal
         LET l_oma.omaconf = 'Y'
         LET l_oma.omavoid = 'N'
         LET l_oma.omaprsw = 0
         LET l_oma.omauser = g_user
         LET l_oma.omagrup = g_grup
         LET l_oma.omadate = g_today
         LET l_oma.omamksg = 'N'
        #LET l_oma.oma64 = '0'   #No.MOD-C30114   Mark
         LET l_oma.oma64 = '1'   #No.MOD-C30114   Add
         LET l_oma.oma70 = '1'
         LET l_oma.oma65 = '1'
         LET l_oma.oma54t = l_oof.oof09f
         LET l_oma.oma56t = l_oof.oof09

         IF cl_null(l_oma.oma50) THEN
            LET l_oma.oma50 = 0
         END IF   
         IF cl_null(l_oma.oma50t) THEN
            LET l_oma.oma50t = 0
         END IF
         IF cl_null(l_oma.oma51) THEN
            LET l_oma.oma51 = 0
         END IF
         IF cl_null(l_oma.oma51f) THEN
            LET l_oma.oma51f = 0
         END IF                  
         IF cl_null(l_oma.oma52) THEN
            LET l_oma.oma52 = 0
         END IF         
         IF cl_null(l_oma.oma53) THEN
            LET l_oma.oma53 = 0
         END IF
         IF cl_null(l_oma.oma54) THEN
            LET l_oma.oma54 = 0
         END IF
         IF cl_null(l_oma.oma54x) THEN
            LET l_oma.oma54x = 0
         END IF
         IF cl_null(l_oma.oma54t) THEN
            LET l_oma.oma54t = 0
         END IF
         IF cl_null(l_oma.oma55) THEN
            LET l_oma.oma55 = 0
         END IF
         IF cl_null(l_oma.oma56) THEN
            LET l_oma.oma56 = 0
         END IF
         IF cl_null(l_oma.oma56x) THEN
            LET l_oma.oma56x = 0
         END IF
         IF cl_null(l_oma.oma56t) THEN
            LET l_oma.oma56t = 0
         END IF
         IF cl_null(l_oma.oma57) THEN
            LET l_oma.oma57 = 0
         END IF
            

        IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
        IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
        IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF

        INSERT INTO oma_file VALUES(l_oma.*)  
        IF SQLCA.sqlcode THEN    
           CALL s_errmsg('oma01',l_oma.oma01,'ins oma_file',SQLCA.sqlcode,1)        
           #CALL cl_err3("ins","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","",1) 
           LET g_success = 'N'
           EXIT FOREACH 
        ELSE
           LET g_success ='Y'
        END IF
   END FOREACH 
END FUNCTION

FUNCTION p603_gen_glcr(p_ooa,p_ooy)
    DEFINE p_ooa     RECORD LIKE ooa_file.*
    DEFINE p_ooy     RECORD LIKE ooy_file.*
 
    IF cl_null(p_ooy.ooygslp) THEN
       CALL cl_err(p_ooa.ooa01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_t400_gl(p_ooa.ooa01,'0')     
    IF g_aza.aza63='Y' THEN         
       CALL s_t400_gl(p_ooa.ooa01,'1')  
    END IF                          
    IF g_success = 'N' THEN RETURN END IF
END FUNCTION 

FUNCTION p603_carry_voucher()
   DEFINE l_ooygslp    LIKE ooy_file.ooygslp
   DEFINE li_result    LIKE type_file.num5     
   DEFINE l_dbs        STRING 
   DEFINE l_sql        STRING                                                                                                        
   DEFINE l_n          LIKE type_file.num5       
   DEFINE l_buser      LIKE type_file.chr10   
   DEFINE l_euser      LIKE type_file.chr10
   DEFINE l_ooy        RECORD LIKE ooy_file.*   
   DEFINE l_oma        RECORD LIKE oma_file.*
 
   IF g_prog <> 'axrt401' THEN RETURN END IF 
   DECLARE  t401_sel_oma CURSOR FOR SELECT oma_file.* FROM oma_file,oob_file WHERE oma01 = oob27 AND oob01 = g_ooa.ooa01 AND oob03 ='1'
   FOREACH t401_sel_oma INTO l_oma.* 
      CALL s_get_doc_no(l_oma.oma01) RETURNING g_t1
      SELECT * INTO l_ooy.* FROM ooy_file WHERE ooyslip=g_t1
      IF NOT(l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y') THEN RETURN END IF
      IF l_ooy.ooyglcr = 'Y' THEN
         LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_ooz.ooz02p,'aba_file'),        
             "  WHERE aba00 = '",g_ooz.ooz02b,"'",                                                                               
             "    AND aba01 = '",l_oma.oma33,"'"                                                                                 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql       
         CALL cl_parse_qry_sql(l_sql,g_ooz.ooz02p) RETURNING l_sql 
         PREPARE aba_pre21 FROM l_sql                                                                                                     
         DECLARE aba_cs21 CURSOR FOR aba_pre21                                                                                             
         OPEN aba_cs21                                                                                                                    
         FETCH aba_cs21 INTO l_n                                                                                                          
         IF l_n > 0 THEN                                                                                                                 
            CALL cl_err(l_oma.oma33,'aap-991',1) 
            LET g_success ='N'                                                                                        
            RETURN                                                                                                                       
         END IF   
      
         LET l_ooygslp = l_ooy.ooygslp
      ELSE                                                                                             
         RETURN       
      END IF
      IF cl_null(l_ooygslp) THEN
         CALL cl_err(l_oma.oma01,'axr-070',1)
         LET g_success ='N'
         RETURN
      END IF
      IF NOT cl_null(l_oma.oma99) THEN  
         LET l_buser = '0' 
         LET l_euser = 'z'  
      ELSE                 
         LET l_buser = l_oma.omauser  
         LET l_euser = l_oma.omauser  
      END IF                
      LET g_wc_gl = 'npp01 = "',l_oma.oma01,'" AND npp011 = 1'
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",l_buser,"' '",l_euser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",l_ooygslp,"' '",l_oma.oma02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",l_ooy.ooygslp1,"'"   #No.MOD-840608 add  #No.MOD-860075  #MOD-910250  #No.MOD-920343
      CALL cl_cmdrun_wait(g_str)
   END FOREACH 
END FUNCTION 

FUNCTION p603_hu2()            #最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   IF STATUS THEN 
      CALL s_errmsg('occ01',g_ooa.ooa03,'sel occ_file',SQLCA.sqlcode,1)
      #CALL cl_err3("sel","occ_file",g_ooa.ooa03,"",STATUS,"","s ccc",1)  
      LET g_success='N' 
      RETURN 
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < g_ooa.ooa02 THEN
      LET l_occ.occ174=g_ooa.ooa02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_ooa.ooa03
  IF STATUS THEN 
     CALL s_errmsg('occ01',g_ooa.ooa03,'upd occ_file',SQLCA.sqlcode,1)
     #CALL cl_err3("upd","occ_file",g_ooa.ooa03,"",SQLCA.sqlcode,"","u ccc",1)  
     LET g_success='N' 
     RETURN
   END IF
END FUNCTION

FUNCTION p603_bu_11(p_sw)                   #更新應收票據檔 (nmh_file)
  DEFINE p_sw       LIKE type_file.chr1,                  # +:更新
       l_nmh17      LIKE  nmh_file.nmh17,
       l_nmh38      LIKE  nmh_file.nmh38
  DEFINE l_nmz59        LIKE nmz_file.nmz59
  DEFINE l_amt1,l_amt2 LIKE nmg_file.nmg25   
 
  #判斷此參考單號之單據是否已確認
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
 
  IF p_sw = '+' THEN
     UPDATE nmh_file SET nmh17=nmh17+b_oob.oob09 ,nmh40 = tot3
      WHERE nmh01= b_oob.oob06
     IF STATUS THEN
        CALL s_errmsg('nmh01',b_oob.oob06,'unp nmh17',STATUS,1)                           
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('nmh01',b_oob.oob06,'upd nmh17','axr-198',1)  LET g_success = 'N' RETURN     
     END IF
  END IF
END FUNCTION

FUNCTION p603_bu_12(p_sw)             #更新TT檔 (nmg_file)
  DEFINE p_sw           LIKE type_file.chr1                    # +:更新 
  DEFINE l_nmg23        LIKE nmg_file.nmg23
  DEFINE l_nmg24        LIKE nmg_file.nmg24,
         l_nmg25        LIKE nmg_file.nmg25,      
         l_nmgconf      LIKE nmg_file.nmgconf,
         l_cnt          LIKE type_file.num5      
  DEFINE tot1,tot3,tot2 LIKE type_file.num20_6   
  DEFINE l_nmz20        LIKE nmz_file.nmz20
  DEFINE l_str          STRING                      
 
  LET l_str = "bu_12:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04
  CALL cl_msg(l_str) 
 
##確認時,判斷此參考單號之單據是否已確認
  LET l_nmgconf = ' '
  SELECT nmg25,nmgconf INTO l_nmg25,l_nmgconf
    FROM nmg_file WHERE nmg00= b_oob.oob06
  IF STATUS THEN LET l_nmgconf= 'N' END IF
  IF l_nmgconf != 'Y' THEN
     CALL s_errmsg('nmg00',b_oob.oob06,'','axr-194',1)  LET g_success = 'N' RETURN   
  END IF
  IF cl_null(l_nmg25) THEN LET l_nmg25=0 END IF   #bug NO:A053 by plum
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='2'
            AND oob06=b_oob.oob06
  IF l_cnt>0 THEN RETURN END IF
 
  LET tot1 = 0 LET tot2 = 0  
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
       CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24',STATUS,1)             
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('nmg00',b_oob.oob06,'upd nmg24','axr-198',1) LET g_success = 'N' RETURN   
    END IF
END FUNCTION

FUNCTION p603_bu_22(p_sw,p_cnt)                  # 產生溢收帳款檔 (oma_file)
  DEFINE p_sw            LIKE type_file.chr1                       # +:產生
  DEFINE p_cnt           LIKE type_file.num5      
  DEFINE l_oma            RECORD LIKE oma_file.*
  DEFINE l_omc            RECORD LIKE omc_file.*
  DEFINE li_result       LIKE type_file.num5         
  DEFINE l_cnt           LIKE type_file.num5      

  INITIALIZE l_oma.* TO NULL
  IF p_sw = '+' THEN
     IF cl_null(b_oob.oob06)
        THEN LET l_oma.oma01 = g_ooz.ooz22   
        ELSE LET l_oma.oma01 = b_oob.oob06
     END IF
     CALL s_auto_assign_no("axr",l_oma.oma01,g_ooa.ooa02,"24","","","","","")
     RETURNING li_result,l_oma.oma01
     IF (NOT li_result) THEN
        CALL s_errmsg('','',l_oma.oma01,'mfg-059',1)     
        LET g_success='N'
        RETURN                                           
     END IF
     CALL cl_msg(l_oma.oma01)         
 
     #轉預收時(oma00='24'),重新讀取g_ooa.*變數
     SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01=b_oob.oob01  
 
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
     LET l_oma.oma23 = g_aza.aza17
     LET l_oma.oma24 = '1'
     SELECT occ43 INTO l_oma.oma25  FROM occ_file WHERE occ01 = l_oma.oma03   
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
     LET l_oma.oma70='1'                       
     LET g_sql = "SELECT oga27 FROM ",cl_get_target_table(l_oma.oma66,'oga_file'),
                 " WHERE oga01='",l_oma.oma16,"'"
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql
     CALL cl_parse_qry_sql(g_sql,l_oma.oma66) RETURNING g_sql
     PREPARE sel_oga27 FROM g_sql
     EXECUTE sel_oga27 INTO l_oma.oma67
     LET l_oma.oma930=s_costcenter(l_oma.oma15) 
     LET l_oma.omalegal = g_ooa.ooalegal
     LET l_omc.omclegal = g_ooa.ooalegal
     LET l_oma.omaoriu = g_user      
     LET l_oma.omaorig = g_grup      

    IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
    IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
    IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF

     INSERT INTO oma_file VALUES(l_oma.*)
     IF STATUS OR SQLCA.SQLCODE THEN
        CALL s_errmsg('oma02','g_ooa.ooa02','ins oma',SQLCA.SQLCODE,1)              
        LET g_success='N' 
        RETURN
     END IF
     
     INSERT INTO omc_file VALUES(l_omc.*)
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('omc01','l_oma.oma01','ins omc',SQLCA.SQLCODE,1)                      
        LET g_success='N'
        RETURN
     END IF
     UPDATE oob_file SET oob06=l_oma.oma01,oob19=l_omc.omc02   
       WHERE oob01=b_oob.oob01 AND oob02=b_oob.oob02
     IF STATUS OR SQLCA.SQLCODE THEN
       #CALL cl_err3("upd","oob_file",b_oob.oob01,b_oob.oob02,SQLCA.sqlcode,"","upd oob06",1)  
       LET g_showmsg=b_oob.oob01,"/",b_oob.oob02                                      
       CALL s_errmsg('oob01,oob02',g_showmsg,'upd oob06',SQLCA.SQLCODE,1)            
       LET g_success = 'N' 
       RETURN
     END IF
     LET l_cnt = 0
     SELECT count(*) INTO l_cnt
       FROM npq_file
      WHERE npq01 = b_oob.oob01 AND npq02 = b_oob.oob02
     IF l_cnt > 0 THEN
        UPDATE npq_file SET npq23=l_oma.oma01
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

FUNCTION p603_bu_21(p_sw)                  #更新應收帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1             # +:更新 
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
  PREPARE t400_bu_21_p1 FROM g_sql
  DECLARE t400_bu_21_c1 CURSOR FOR t400_bu_21_p1
  OPEN t400_bu_21_c1 USING b_oob.oob06
  FETCH t400_bu_21_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    IF p_sw='+' AND l_omavoid='Y' THEN
       CALL s_errmsg('oma01',b_oob.oob06,b_oob.oob06,'axr-103',1) LET g_success='N' RETURN   
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       CALL s_errmsg('oma01',b_oob.oob06,b_oob.oob06,'axr-194',1) LET g_success='N' RETURN   
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL p603_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4        
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t      
  # 期末調匯(A008)
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN  
       CALL s_errmsg('oma01',b_oob.oob06,'un_pay<pay','axr-196',1) LET g_success='N' RETURN   
       END IF
    END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
                                                        
       IF tot3 <0 THEN                                                          
          CALL cl_err('','axr-185',1)                                           
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
    PREPARE t400_bu_21_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1          
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2          
    EXECUTE t400_bu_21_p2 USING tot1, tot2, tot3, b_oob.oob06
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)               
       LET g_success = 'N'
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN   
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p603_omc(l_oma00,p_sw)  
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
     PREPARE t400_bu_21_p1b FROM g_sql
     DECLARE t400_bu_21_c1b CURSOR FOR t400_bu_21_p1b
     OPEN t400_bu_21_c1b USING b_oob.oob06,b_oob.oob15
     FETCH t400_bu_21_c1b INTO l_oma00,l_omaconf,un_pay1,un_pay2
     IF p_sw='+' AND l_omaconf='N' THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                       
        CALL s_errmsg('omb01,omb03',g_showmsg,b_oob.oob06,'axr-194',1) LET g_success='N' RETURN   
     END IF
     IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
     IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
     IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
        IF p_sw='+' AND (un_pay1 < tot1 OR un_pay2 < tot2) THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                          
        CALL s_errmsg('omb01,omb03',g_showmsg,'un_pay<pay','axr-196',1)  LET g_success='N' RETURN  
        END IF
     END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       #取得未沖金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,b_oob.oob15) RETURNING tot3
    ELSE
       LET tot3 = un_pay2  - tot2
    END IF
     LET g_sql="UPDATE omb_file ",     
                 " SET omb34=?,omb35=?,omb37=? ",
               " WHERE omb01=? AND omb03=?"
     PREPARE t400_bu_21_p2b FROM g_sql
     EXECUTE t400_bu_21_p2b USING tot1, tot2, tot3, b_oob.oob06,b_oob.oob15
     IF STATUS THEN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                          
        CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35',STATUS,1)    
        LET g_success = 'N' 
        RETURN
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        #CALL cl_err('upd omb34,35','axr-198',3) LET g_success = 'N' RETURN
        LET g_showmsg=b_oob.oob06,"/",b_oob.oob15                          
        CALL s_errmsg('omb01,omb03',g_showmsg,'upd omb34,35','axr-198',1) LET g_success = 'N' RETURN     
     END IF
  END IF
END FUNCTION
 
FUNCTION p603_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1                        # +:更新 -:還原
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

  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t,oma55,oma57 ",     
            "  FROM oma_file ",  
            " WHERE oma01=?"
  PREPARE p603_bu_13_p1 FROM g_sql
  DECLARE p603_bu_13_c1 CURSOR FOR p603_bu_13_p1
  OPEN p603_bu_13_c1 USING b_oob.oob06
  FETCH p603_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2,l_oma55,l_oma57          
    IF p_sw='+' AND l_omavoid='Y' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N' RETURN  
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N' RETURN   
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL p603_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4     
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t    
 
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN   
       CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) LET g_success = 'N' RETURN  
       END IF
    END IF
 
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
     LET tot1 = tot1 + l_oma55
     LET tot2 = tot2 + l_oma57
  ELSE

     IF l_oma00 = '23' THEN 
        LET tot1 = un_pay1 - tot1 
        LET tot2 = un_pay2 - tot2
     END IF
    
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

    PREPARE p603_bu_13_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1        
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2       
    EXECUTE p603_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06  
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)              
       LET g_success = 'N' 
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN   
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL p603_omc(l_oma00,p_sw)   
    END IF
END FUNCTION


FUNCTION p603_omc(p_oma00,p_sw)   
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
    CALL p603_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t                 
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4                    
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t                  
    LET l_oob09 = l_oob09 +tot4                                                 
    LET l_oob10 = l_oob10 +tot4t                                                

     LET g_sql=" UPDATE omc_file ",  
                  " SET omc10=?,omc11=? ",
               " WHERE omc01=? AND omc02=? "
 
     PREPARE p603_bu_13_p3 FROM g_sql
     EXECUTE p603_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc10,11','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
     LET g_sql=" UPDATE omc_file ",  
                 " SET omc13=omc09-omc11+ ",l_oox10, 
               " WHERE omc01=? AND omc02=? "
     PREPARE p603_bu_13_p4 FROM g_sql
     EXECUTE p603_bu_13_p4 USING b_oob.oob06,b_oob.oob19
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('omc01',b_oob.oob06,'upd omc13','axr-198',1)
        LET g_success = 'N' RETURN
     END IF
END FUNCTION

FUNCTION p603_mntn_offset_inv(p_oob06)
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

FUNCTION p603_ins_nme()
   DEFINE l_nme RECORD LIKE nme_file.*
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   

   
   LET l_nme.nme00 = '0' 
   LET l_nme.nme01 = g_oob.oob17
   IF cl_null(l_nme.nme01) THEN 
      LET l_nme.nme01 = ' '
   END IF 
   LET l_nme.nme02 = g_ooa.ooa02
   IF cl_null(l_nme.nme02) THEN 
      LET l_nme.nme02 = ' '
   END IF 
   LET l_nme.nme03 = g_oob.oob18
   IF cl_null(l_nme.nme03) THEN 
      LET l_nme.nme03 = ' '
   END IF 
   LET l_nme.nme04 = g_oob.oob09
   LET l_nme.nme05 = g_oob.oob12  
   LET l_nme.nme07 = g_ooa.ooa24
   LET l_nme.nme08 = g_oob.oob10
   LET l_nme.nme10 = g_ooa.ooa33
   LET l_nme.nme12 = g_oob.oob01
   IF cl_null(l_nme.nme12) THEN 
      LET l_nme.nme12 = ' '
   END IF 
   LET l_nme.nme13 = g_ooa.ooa032
   LET l_nme.nme14 = g_oob.oob21
   LET l_nme.nme15 = g_oob.oob13
   LET l_nme.nme16 = g_ooa.ooa02
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nme21=g_oob.oob02
   IF cl_null(l_nme.nme21) THEN 
      LET l_nme.nme21 = '0'
   END IF 
   LET l_nme.nme22='01'
   LET l_nme.nme23=g_oob.oob04
   LET l_nme.nme24='9'
   LET l_nme.nmelegal=g_ooa.ooalegal
 
   LET l_nme.nmeoriu = g_user      
   LET l_nme.nmeorig = g_grup      


   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END IF

   INSERT INTO nme_file VALUES(l_nme.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","nme_file",l_nme.nme01,l_nme.nme02,SQLCA.sqlcode,"","ins nme",1)
      LET g_success = 'N'
   END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)

   
END FUNCTION 

#No.TQC-C30188   ---start---   Add
FUNCTION p603_axrp590()
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip
   IF NOT cl_null(g_wc_gl) AND g_success = 'Y' THEN
      LET g_wc_gl = g_wc_gl,')'
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #No.TQC-810036
      CALL cl_cmdrun_wait(g_str)
   END IF
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = tm.ar_slip2
   IF NOT cl_null(g_wc_gl2) AND g_success = 'Y' THEN
      LET g_wc_gl2 = g_wc_gl2,')'
      LET g_str="axrp590 '",g_wc_gl2 CLIPPED,"' '",g_ooa.ooauser,"' '",g_ooa.ooauser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",g_ooa.ooa02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"     #No.TQC-810036
      CALL cl_cmdrun_wait(g_str)
   END IF
END FUNCTION
#No.TQC-C30188   ---end---     Add

#FUN-C20020
