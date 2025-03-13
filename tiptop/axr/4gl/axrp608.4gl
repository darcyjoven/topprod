# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: axrp608.4gl
# Descriptions...: 待抵变更单整批生成账款还原作业
# Date & Author..: FUN-C30029 12/03/19 By minpp

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_wc          STRING                   #QBE_1的條件
DEFINE g_wc2            STRING                #QBE_2條件
DEFINE p_row,p_col   LIKE type_file.num5
DEFINE g_change_lang LIKE type_file.chr1 
DEFINE g_luk16       LIKE luk_file.luk16
DEFINE g_lum         RECORD LIKE lum_file.*
DEFINE g_oob27       LIKE oob_file.oob27  
DEFINE g_ooa01       LIKE ooa_file.ooa01
DEFINE g_ooa33       LIKE ooa_file.ooa33
DEFINE g_sql         STRING 
DEFINE g_t1          LIKE ooy_file.ooyslip
DEFINE g_str         STRING
DEFINE g_plant_l     LIKE type_file.chr10  
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
         CALL p608()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p608_1()
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
               CLOSE WINDOW p608_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p608_1()
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

FUNCTION p608()
   LET p_row = 5 LET p_col = 28
   OPEN WINDOW p608_w AT p_row,p_col WITH FORM "axr/42f/axrp608"
      ATTRIBUTE(STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')
   CLEAR FORM 

   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON azp01
         BEFORE CONSTRUCT
           IF cl_null(g_wc) THEN DISPLAY g_plant TO azp01 END IF
      END CONSTRUCT

      CONSTRUCT BY NAME g_wc2 ON lum01
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
            WHEN INFIELD(lum01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_lum01"
               LET g_qryparam.where ="lumconf = 'Y' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lum01
               NEXT FIELD lum01
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
      CLOSE WINDOW p608_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
END FUNCTION 

FUNCTION p608_1()
   DEFINE  amt       LIKE type_file.num20_6    #小数点
   DEFINE l_ooy      RECORD LIKE ooy_file.* 
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      STRING
   DEFINE l_oma01    LIKE oma_file.oma01
   DEFINE l_oma33    LIKE oma_file.oma33
   DEFINE l_dbs      STRING	

   BEGIN WORK
   LET g_success = 'Y'
   CALL s_showmsg_init()
   #判断是否符合还原条件
   CALL p608_chk()
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF 
   #1.根据QBE条件选取需要的营运中心，根据营运中心用跨库的方式选取待抵变更单artt613的资料
      #抓取符合用戶QBE1條件的當前法人下的所有營運中心
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "  AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p608_sel_azw FROM g_sql
   DECLARE p608_azw_curs CURSOR FOR p608_sel_azw
   FOREACH p608_azw_curs INTO g_plant_new
      #逐个抓取对应营运中心下已拋磚的待抵变更单资料
       LET g_sql = "SELECT * ",
                  "  FROM ",cl_get_target_table(g_plant_new,'lum_file'),
                  " WHERE ",g_wc2 CLIPPED,
                  "   and lumplant = ? ",
                  "   and lumconf = 'Y'",
                  "   and lum17 is not null"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p608_lum_pre FROM g_sql
      DECLARE p608_lum_cs CURSOR FOR p608_lum_pre
      FOREACH p608_lum_cs USING g_plant_new INTO g_lum.*

         #抓出抛转财务产生的ooa_file及oob_file的资料
         LET g_ooa01=null
         LET g_ooa33=null
         LET g_oob27=null
         SELECT ooa01,ooa33 INTO g_ooa01,g_ooa33 FROM ooa_file WHERE ooa01=g_lum.lum17
         SELECT oob27 INTO g_oob27 FROM oob_file WHERE oob01=g_ooa01 and oob03='2'
       
         #若axrt401單據別設為"系統自動拋轉總帳",則可自動拋轉還原
         CALL s_get_doc_no(g_ooa01) RETURNING g_t1
         SELECT * INTO l_ooy.* FROM ooy_file WHERE ooyslip=g_t1
         IF NOT cl_null(g_ooa33) THEN
            IF NOT (l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y') THEN
               CALL s_errmsg('ooa01',g_ooa01,'','axr-370',1)
               LET g_success ='N'
            END IF
         END If
         IF l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y' THEN
            LET g_plant_l=g_ooz.ooz02p
            LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_l,'aba_file'),
                        "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                        "    AND aba01 = '",g_ooa33,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_plant_l) RETURNING l_sql
            PREPARE aba_pre FROM l_sql
            DECLARE aba_cs CURSOR FOR aba_pre
            OPEN aba_cs
            FETCH aba_cs INTO l_aba19
            IF l_aba19 = 'Y' THEN
               CALL s_errmsg('ooa33',g_ooa33,'','axr-071',1)
               CALL s_showmsg()
               LET g_success ='N'
               RETURN 
            END IF
         END IF

         IF l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
            LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooa33,"' 'Y'"
            CALL cl_cmdrun_wait(g_str)
         END IF
 
         #1.删除产生的杂项待抵单的资料
         IF g_success='Y' THEN 
            DELETE FROM oma_file WHERE oma01=g_oob27
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
               CALL s_errmsg('oma_file','delete',g_oob27,'',1)
               LET g_success = 'N'
            END IF 
            IF g_success='Y' THEN
                DELETE FROM omc_file WHERE omc01=g_oob27
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
                   CALL s_errmsg('omc_file','delete',g_oob27,'',1)
                   LET g_success = 'N'
                END IF 
           END IF 
        END IF
        
        #2.刪除分錄底稿資料npp_file，npq_file
         IF g_success='Y' THEN
            DELETE FROM npp_file WHERE npp01=g_ooa01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
               CALL s_errmsg('npp_file','delete',g_ooa01,'',1)
               LET g_success = 'N'
            END IF
            IF g_success='Y' THEN  
               DELETE FROM npq_file WHERE npq01=g_ooa01
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
                  CALL s_errmsg('npq_file','delete',g_ooa01,'',1)
                  LET g_success = 'N'
               END IF
            END IF
          END IF
         
         #3.删除产生的axrt401的单身资料及单头资料
          IF g_success='Y' THEN 
             DELETE FROM oob_file WHERE oob01=g_ooa01
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
                 CALL s_errmsg('omc_file','delete',g_ooa01,'',1)
                 LET g_success = 'N'
              END IF 
             IF g_success='Y' THEN
                DELETE FROM ooa_file WHERE ooa01=g_ooa01 
                IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
                   CALL s_errmsg('oma_file','delete',g_ooa01,'',1)
                   LET g_success = 'N'
                END IF    
             END IF 
         END IF 
      IF g_success='Y' THEN 
       #1.还原更新原财务待抵单的已冲金额
        LET g_sql = "SELECT luk16", 
                    "  FROM ",cl_get_target_table(g_plant_new,'luk_file'),
                    " WHERE luk01 = ?",
                    "  and lukconf = 'Y'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
        PREPARE p608_luk_pre FROM g_sql
        EXECUTE p608_luk_pre USING g_lum.lum02 INTO g_luk16
       
        LET amt=g_lum.lum10-g_lum.lum11-g_lum.lum12
        UPDATE oma_file SET oma55=oma55-amt,
                            oma57=oma57-amt
         WHERE oma01 = g_luk16
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
           CALL s_errmsg('oma_file','update',g_luk16,'',1)
           LET g_success = 'N'
        END IF

      #2.还原已更新业务端待抵变更单的财务单号
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'lum_file')," SET lum17 = null",
                   " WHERE lum01 = '",g_lum.lum01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
       PREPARE p608_upd_lum FROM g_sql
       EXECUTE p608_upd_lum
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN
          CALL s_errmsg('lum_file','update',g_lum.lum01,'',1)
          LET g_success = 'N'
       END IF

     #3.还原已更新的业务端产生的新的待抵单的财务待抵单号luk16 
       LET g_sql = "UPDATE ",cl_get_target_table(g_plant_new,'luk_file')," SET luk16 = null",
                   " WHERE luk05 = '",g_lum.lum01,"'",
                   "   AND luk04='3'",
                   "   AND lukconf='Y'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
       PREPARE p608_upd_luk FROM g_sql
       EXECUTE p608_upd_luk
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0  THEN 
          CALL s_errmsg('luk_file','update',g_lum.lum01,'',1)
          LET g_success = 'N'
       END IF 
    END IF    
   END FOREACH  
  END FOREACH
   CALL s_showmsg()
END FUNCTION 


FUNCTION p608_chk()

   DEFINE l_ooy      RECORD LIKE ooy_file.*
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      STRING

#1.根据QBE条件选取需要的营运中心，根据营运中心用跨库的方式选取待抵变更单artt613的资料
      #抓取符合用戶QBE1條件的當前法人下的所有營運中心
   LET g_sql = " SELECT azp01 FROM azp_file,azw_file ",
               "  WHERE ",g_wc CLIPPED ,
               "  AND azw01 = azp01 AND azw02 = '",g_legal,"'"
   PREPARE p608_sel_azw_1 FROM g_sql
   DECLARE p608_azw_curs_1 CURSOR FOR p608_sel_azw_1
   FOREACH p608_azw_curs_1 INTO g_plant_new
      #逐个抓取对应营运中心下已拋磚的待抵变更单资料
       LET g_sql = "SELECT * ",
                  "  FROM ",cl_get_target_table(g_plant_new,'lum_file'),
                  " WHERE ",g_wc2 CLIPPED,
                  "   and lumplant = ? ",
                  "   and lumconf = 'Y'",
                  "   and lum17 is not null"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
      PREPARE p608_lum_pre_1 FROM g_sql
      DECLARE p608_lum_cs_1 CURSOR FOR p608_lum_pre_1
      FOREACH p608_lum_cs_1 USING g_plant_new INTO g_lum.*

         #抓出抛转财务产生的ooa_file及oob_file的资料
         LET g_ooa01=null
         LET g_ooa33=null
         LET g_oob27=null
         SELECT ooa01, ooa33 INTO g_ooa01,g_ooa33 FROM ooa_file WHERE ooa01=g_lum.lum17 
         #若axrt401單據別設為"系統自動拋轉總帳",則可自動拋轉還原
         CALL s_get_doc_no(g_ooa01) RETURNING g_t1
         SELECT * INTO l_ooy.* FROM ooy_file WHERE ooyslip=g_t1
         IF NOT cl_null(g_ooa33) THEN
            IF NOT (l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y') THEN
               CALL s_errmsg('ooa01',g_ooa01,'','axr-370',1)
               LET g_success ='N'
            END IF
         END If
         IF l_ooy.ooydmy1 = 'Y' AND l_ooy.ooyglcr = 'Y' THEN
            LET g_plant_l=g_ooz.ooz02p
            LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_l,'aba_file'),
                        "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                        "    AND aba01 = '",g_ooa33,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,g_plant_l) RETURNING l_sql
            PREPARE aba_pre1 FROM l_sql
            DECLARE aba_cs1 CURSOR FOR aba_pre1
            OPEN aba_cs1
            FETCH aba_cs INTO l_aba19
            IF l_aba19 = 'Y' THEN
               CALL s_errmsg('ooa33',g_ooa33,'','axr-071',1)
               CALL s_showmsg()
               LET g_success ='N'
               RETURN
            END IF
         END IF   
      END FOREACH
   END FOREACH
END FUNCTION
#FUN-C30029
