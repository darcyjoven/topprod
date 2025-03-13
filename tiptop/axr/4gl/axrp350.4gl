# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: axrp350.4gl
# Descriptions...: 發票確認(應收帳款整批確認)
# Date & Author..: 95/02/21 By Roger
# Modify.........: 97/08/04 By Sophia 整批確認也須檢查分錄底稿,關帳日期
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-570156 06/03/09 By saki 批次背景執行
# Modify.........: No.MOD-640207 06/04/09 By Smapmin 檢核帳款金額與分錄金額不符
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-670047 06/09/28 By Ray 多帳套修改 
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-710050 07/01/23 By bnlent 錯誤信息匯整
# Modify.........: No.FUN-740009 07/04/03 By Elva   會計科目加帳套
# Modify.........: No.MOD-920239 09/02/19 By Smapmin 需簽核但狀況碼不為已核准的不可確認.確認後一併更新狀況碼為已核准.
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying s_ar_conf 增加一參數
# Modify.........: No:MOD-A30027 10/04/08 By wujie   审核后应回写未收金额 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql	        string                 #No.FUN-580092 HCN 
DEFINE g_oma                    RECORD LIKE oma_file.*
DEFINE g_oma59,g_oma59x		LIKE oma_file.oma59    #FUN-4C0013
DEFINE g_t1             	LIKE oay_file.oayslip  #No.FUN-550071 #No.FUN-680123 VARCHAR(5)
DEFINE p_row,p_col              LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680123 INTEGER
DEFINE   i               LIKE type_file.num5          #No.FUN-680123 SMALLINT
DEFINE  # Prog. Version..: '5.30.06-13.03.12(01)   #是否有做語言切換 No.FUN-570156
         g_change_lang   LIKE type_file.chr1          #No.FUN-680123 VARCHAR(01)
   DEFINE g_bookno1     LIKE aza_file.aza81      #No.FUN-740009
   DEFINE g_bookno2     LIKE aza_file.aza82      #No.FUN-740009
   DEFINE g_flag        LIKE type_file.chr1      #No.FUN-740009
 
MAIN
#   DEFINE l_time  	LIKE type_file.chr8          #No.FUN-680123 VARCHAR(8)   #No.FUN-6A0095
   DEFINE l_flag        LIKE type_file.chr1     #No.FUN-570156         #No.FUN-680123 VARCHAR(1)
 
   OPTIONS
        MESSAGE   LINE  LAST-1,
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   #LET g_wc = cl_replace_str(g_wc, "\"", "'")
   LET g_bgjob = ARG_VAL(2)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570156 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570156 --start--
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
#  OPEN WINDOW p350_w AT p_row,p_col WITH FORM "axr/42f/axrp350"
#      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#   CALL cl_ui_init()
 
#  CALL p350()
#  CLOSE WINDOW p350_w
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p350()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p350_process()
            CALL s_showmsg()   #No.FUN-710050
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
               CLOSE WINDOW p350_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p350_process()
         CALL s_showmsg()      #No.FUN-710050
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570156 ---end---
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
FUNCTION p350()
   #No.FUN-570156 --start--
#  DEFINE l_flag        LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
#  DEFINE l_ok,l_fail	SMALLINT
 
   DEFINE #lc_cmd        VARCHAR(500)     #No.FUN-570156
           lc_cmd        LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(500)
   OPEN WINDOW p350_w AT p_row,p_col WITH FORM "axr/42f/axrp350"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   #No.FUN-570156 --end--
 
    WHILE TRUE
       CLEAR FORM
       MESSAGE   ""
       CALL cl_opmsg('w')
       CONSTRUCT BY NAME g_wc ON oma01,oma02,oma05,oma10  
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
           #No.FUN-570156 --start--
#          CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#          LET g_action_choice = "locale"
           LET g_change_lang = TRUE
           #No.FUN-570156 ---end---
           EXIT CONSTRUCT
 
        ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup') #FUN-980030
       #No.FUN-570156 --start--
#      IF g_action_choice = "locale" THEN
       IF g_change_lang THEN
#         LET g_action_choice = ""
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          CONTINUE WHILE
       END IF
       #No.FUN-570156 ---end---
 
       IF INT_FLAG THEN
          #No.FUN-570156 --start--
          LET INT_FLAG = 0 
          CLOSE WINDOW p350_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
#         RETURN
          #No.FUN-570156 ---end---
       END IF
       IF g_wc = ' 1=1'
          THEN CALL cl_err('','9046',0) CONTINUE WHILE
          #ELSE EXIT WHILE
       END IF
 
       #No.FUN-570156 --start--
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
         CLOSE WINDOW p350_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "axrp350"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('axrp350','9031',1)
         ELSE
            LET g_wc=cl_replace_str(g_wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axrp350',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p350_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
 
      #No.FUN-570156 ----將此段移至 p350_process()
#     LET g_sql="SELECT COUNT(*),SUM(oma59),SUM(oma59x) FROM oma_file",
#               "  WHERE ",g_wc CLIPPED,
#               "    AND omaconf='N' AND omavoid='N' "
#     PREPARE p350_prepare0 FROM g_sql
#     DECLARE p350_cs0 CURSOR WITH HOLD FOR p350_prepare0
#     OPEN p350_cs0 
#     FETCH p350_cs0 INTO g_cnt,g_oma59,g_oma59x
#     DISPLAY BY NAME g_cnt,g_oma59,g_oma59x
#     IF cl_sure(21,21) THEN   #genero
#        CALL cl_wait()
#        LET g_sql="SELECT * FROM oma_file WHERE ",g_wc CLIPPED,
#                 "  AND omaconf='N' AND omavoid='N' "
#        PREPARE p350_prepare FROM g_sql
#        DECLARE p350_cs CURSOR WITH HOLD FOR p350_prepare
#        LET l_ok=0 LET l_fail=0
#        LET g_success = 'Y'
#        FOREACH p350_cs INTO g_oma.*
#          IF STATUS THEN CALL cl_err('p350(foreach):',STATUS,1) EXIT FOREACH END IF
#          MESSAGE   'Invoice No:',g_oma.oma01
#          CALL ui.Interface.refresh() 
#          BEGIN WORK
#          LET g_success = 'Y'
#        #----97/08/04 modify
#          IF g_oma.oma02<=g_ooz.ooz09 THEN 
#             CALL cl_err('','axr-164',0)
#             CONTINUE FOREACH
#          END IF
#         #---97/05/26 modify 檢查存在且平衡
#         # LET g_t1 = g_oma.oma01[1,3]
#          CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1     #No.FUN-550071
#          SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_t1
#          IF g_ooy.ooydmy1 = 'Y' THEN
#          #  CALL s_chknpq(g_oma.oma01,'AR')
#             CALL s_chknpq(g_oma.oma01,'AR',1)   #-->NO:0151
#          END IF
#          IF g_success = 'N' THEN CONTINUE FOREACH END IF
#        #-------------------------
#          CALL s_ar_conf('y',g_oma.oma01) RETURNING i
#          IF i = 0
#             THEN LET l_ok  =l_ok  +1 LET g_success = 'Y'
#             ELSE LET l_fail=l_fail+1 LET g_success = 'N'
#          END IF
#          IF g_success ='Y' THEN COMMIT WORK
#          ELSE ROLLBACK WORK
#          END IF
#        END FOREACH
#        MESSAGE   'Ok:',l_ok,'     Fail:',l_fail
#        CALL ui.Interface.refresh() 
#        #genero若l_ok>1筆表是有1筆以上成功
#        IF l_ok>0 THEN
#            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#      END IF
   END WHILE
   #CALL cl_end(20,20)
END FUNCTION
 
#No.FUN-570156 --start--
FUNCTION p350_process()
   DEFINE l_flag        LIKE type_file.chr1          #No.FUN-680123 VARCHAR(1)
   DEFINE #l_ok,l_fail	SMALLINT
           l_ok,l_fail  LIKE type_file.num5          #No.FUN-680123 SMALLINT
   #-----MOD-640207---------
   DEFINE #l_status VARCHAR(1),
           l_status LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
          l_npq07  LIKE npq_file.npq07,
          l_cnt    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_oot05t LIKE oot_file.oot05t
   #-----END MOD-640207-----
 
   LET g_sql="SELECT COUNT(*),SUM(oma59),SUM(oma59x) FROM oma_file",
             "  WHERE ",g_wc CLIPPED,
             "    AND omaconf='N' AND omavoid='N' ",
             "    AND (omamksg = 'N' OR (omamksg = 'Y' AND oma64 = '1')) "   #MOD-920239
   PREPARE p350_prepare0 FROM g_sql
   DECLARE p350_cs0 CURSOR WITH HOLD FOR p350_prepare0
   OPEN p350_cs0 
   FETCH p350_cs0 INTO g_cnt,g_oma59,g_oma59x
   DISPLAY BY NAME g_cnt,g_oma59,g_oma59x
 
   IF g_bgjob = "N" THEN    #No.FUN-570156
      CALL cl_wait()
   END IF                   #No.FUN-570156
   LET g_sql="SELECT * FROM oma_file WHERE ",g_wc CLIPPED,
             "  AND omaconf='N' AND omavoid='N' ",
             "    AND (omamksg = 'N' OR (omamksg = 'Y' AND oma64 = '1')) "   #MOD-920239
   PREPARE p350_prepare FROM g_sql
   DECLARE p350_cs CURSOR WITH HOLD FOR p350_prepare
   LET l_ok=0 LET l_fail=0
   LET g_success = 'Y'
   CALL s_showmsg_init()     #No.FUN-710050
   FOREACH p350_cs INTO g_oma.*
   #No.FUN-710050--Begin--
   # IF STATUS THEN CALL cl_err('p350(foreach):',STATUS,1) EXIT FOREACH END IF
     IF STATUS THEN CALL s_errmsg('','','p350(foreach):',STATUS,0) EXIT FOREACH END IF
   #No.FUN-710050--End--
     IF g_bgjob = "N" THEN      #No.FUN-570156
        MESSAGE   'Invoice No:',g_oma.oma01
        CALL ui.Interface.refresh() 
     END IF                     #No.FUN-570156
     #No.FUN-710050--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
     #No.FUN-710050--End-
 
     BEGIN WORK
     LET g_success = 'Y'
   #----97/08/04 modify
     IF g_oma.oma02<=g_ooz.ooz09 THEN 
     #No.FUN-710050--Begin--
     #  CALL cl_err('','axr-164',0)
        CALL s_errmsg('','','','axr-164',0)
     #No.FUN-710050--End--
        CONTINUE FOREACH
     END IF
    #---97/05/26 modify 檢查存在且平衡
    # LET g_t1 = g_oma.oma01[1,3]
     CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1     #No.FUN-550071
     SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = g_t1
     #No.FUN-740009  --Begin
     CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING g_flag,g_bookno1,g_bookno2
     IF g_flag =  '1' THEN  #抓不到帳別
        CALL cl_err(g_oma.oma02,'aoo-081',1)
        LET g_success = 'N'
        CONTINUE FOREACH
     END IF
     #No.FUN-740009  --End  
     IF g_ooy.ooydmy1 = 'Y' THEN
     #  CALL s_chknpq(g_oma.oma01,'AR')
        #No.FUN-670047 --begin
       #CALL s_chknpq(g_oma.oma01,'AR',1,'0')   #-->NO:0151 #No.FUN-740009
        CALL s_chknpq(g_oma.oma01,'AR',1,'0',g_bookno1)   #-->NO:0151 #No.FUN-740009
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
          #CALL s_chknpq(g_oma.oma01,'AR',1,'1')   #-->NO:0151 #No.FUN-740009
           CALL s_chknpq(g_oma.oma01,'AR',1,'1',g_bookno2)   #-->NO:0151 #No.FUN-740009
        END IF
        #No.FUN-670047 --end
     END IF
     #-----MOD-640207---------
     IF g_aza.aza26='2' AND g_ooy.ooydmy2='Y' AND g_oma.oma00 MATCHES '2*' THEN
        LET l_status='1'      #借
     ELSE
        LET l_status='2'      #貸
     END IF
     IF g_oma.oma00 MATCHES '2*' THEN   
        SELECT SUM(npq07) INTO l_npq07 FROM npq_file
         WHERE npq01 = g_oma.oma01 AND npq06 = l_status  
           AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma18
           AND npqtype = '0'     #No.FUN-670047
        IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
        IF l_npq07<0 THEN LET l_npq07 = (-1)*l_npq07  END IF  
        IF l_npq07 != g_oma.oma56t THEN   
        #No.FUN-710050--Begin--
        #   CALL cl_err(g_oma.oma01,'aap-278',1)  
            CALL s_errmsg('','',g_oma.oma01,'aap-278',1)
        #No.FUN-710050--End--
            LET g_success = 'N'
        END IF
        #No.FUN-670047 --begin
        IF g_aza.aza63 = 'Y' THEN
           SELECT SUM(npq07) INTO l_npq07 FROM npq_file
            WHERE npq01 = g_oma.oma01 AND npq06 = l_status  
              AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma181
              AND npqtype = '1'
           IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
           IF l_npq07<0 THEN LET l_npq07 = (-1)*l_npq07  END IF  
           IF l_npq07 != g_oma.oma56t THEN   
           #No.FUN-710050--Begin--
           #   CALL cl_err(g_oma.oma01,'aap-278',1)  
               CALL s_errmsg('','',g_oma.oma01,'aap-278',1)
           #No.FUN-710050--End--
               LET g_success = 'N'
           END IF
        END IF
        #No.FUN-670047 --end
     ELSE
        IF g_oma.oma65 != '2' THEN   
           SELECT SUM(npq07) INTO l_npq07 FROM npq_file
            WHERE npq01 = g_oma.oma01 AND npq06 = '1'     
              AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma18 
              AND npqtype = '0'     #No.FUN-670047
           IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
           SELECT COUNT(*),SUM(oot05t) INTO l_cnt,l_oot05t FROM oot_file
             WHERE oot03=g_oma.oma01
           IF l_cnt > 0 THEN
              IF l_npq07 != (g_oma.oma56t-l_oot05t) THEN   
              #No.FUN-710050--Begin--
              #  CALL cl_err(g_oma.oma01,'aap-278',1)   
                 CALL s_errmsg('oot03','g_oma.oma01',g_oma.oma01,'aap-278',1)
              #No.FUN-710050--End--
                 LET g_success = 'N'
              END IF
           ELSE
              IF l_npq07 != g_oma.oma56t THEN  
              #No.FUN-710050--Begin--
              #  CALL cl_err(g_oma.oma01,'aap-278',1)   
                 CALL s_errmsg('','',g_oma.oma01,'aap-278',1)
              #No.FUN-710050--End--
                 LET g_success = 'N'
              END IF
           END IF
           #No.FUN-670047 --begin
           IF g_aza.aza63 = 'Y' THEN
              SELECT SUM(npq07) INTO l_npq07 FROM npq_file
               WHERE npq01 = g_oma.oma01 AND npq06 = '1'     
                 AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma181
                 AND npqtype = '1' 
              IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
              SELECT COUNT(*),SUM(oot05t) INTO l_cnt,l_oot05t FROM oot_file
                WHERE oot03=g_oma.oma01
              IF l_cnt > 0 THEN
                 IF l_npq07 != (g_oma.oma56t-l_oot05t) THEN   
                 #No.FUN-710050--Begin--
                 #  CALL cl_err(g_oma.oma01,'aap-278',1)   
                    CALL s_errmsg('oot03','g_oma.oma01',g_oma.oma01,'aap-278',1)   
                 #No.FUN-710050--End--
                    LET g_success = 'N'
                 END IF
              ELSE
                 IF l_npq07 != g_oma.oma56t THEN  
                 #No.FUN-710050--Begin--
                 #  CALL cl_err(g_oma.oma01,'aap-278',1)   
                    CALL s_errmsg('','',g_oma.oma01,'aap-278',1)
                 #No.FUN-710050--End--
                    LET g_success = 'N'
                 END IF
              END IF
           END IF
           #No.FUN-670047 --end
        END IF
     END IF
     #-----END MOD-640207-----
     IF g_success = 'N' THEN CONTINUE FOREACH END IF
   #-------------------------
   # CALL s_ar_conf('y',g_oma.oma01) RETURNING i    #No.FUN-9C0014
     CALL s_ar_conf('y',g_oma.oma01,'') RETURNING i #No.FUN-9C0014
     IF i = 0
        THEN LET l_ok  =l_ok  +1 LET g_success = 'Y'
        CALL p350_upd_oma()      #No.MOD-A30027 
        ELSE LET l_fail=l_fail+1 LET g_success = 'N'
     END IF
     #-----MOD-920239---------
     UPDATE oma_file SET oma64 = '1' WHERE oma01 = g_oma.oma01
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL s_errmsg('oma01',g_oma.oma01,'upd oma64',STATUS,1)
        LET g_success = 'N'
     END IF
     #-----END MOD-920239-----
     IF g_success ='Y' THEN COMMIT WORK
     ELSE ROLLBACK WORK
     END IF
   END FOREACH
   #No.FUN-710050--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
  #No.FUN-710050--End--
 
   IF g_bgjob = "N" THEN          #No.FUN-570156
      MESSAGE   'Ok:',l_ok,'     Fail:',l_fail
      CALL ui.Interface.refresh() 
   END IF                         #No.FUN-570156
   #genero若l_ok>1筆表是有1筆以上成功
   IF l_ok>0 THEN
      LET g_success = "Y"        #批次作業正確結束
   ELSE
      LET g_success = "N"        #批次作業失敗
   END IF
END FUNCTION
#No.FUN-570156 ---end---
#No.MOD-A30027 --begin                                                          
#更新该张应收账款之已收金额                                                     
FUNCTION p350_upd_oma()                                                         
DEFINE l_oma      RECORD LIKE oma_file.*,                                       
       l_ooa31d   LIKE ooa_file.ooa31d,                                         
       l_ooa32d   LIKE ooa_file.ooa32d                                          
DEFINE l_cnt      LIKE type_file.num5                                           
DEFINE l_tot1     LIKE ooa_file.ooa31d                                          
DEFINE l_tot2     LIKE ooa_file.ooa32d                                          
DEFINE l_omc02    LIKE omc_file.omc02                                           
DEFINE l_omc08    LIKE omc_file.omc08                                           
DEFINE l_omc09    LIKE omc_file.omc09                                           
DEFINE l_omc10    LIKE omc_file.omc10                                           
DEFINE l_omc11    LIKE omc_file.omc11                                           
DEFINE l_oob09    LIKE oob_file.oob09                                           
DEFINE l_oob10    LIKE oob_file.oob10                                           
DEFINE l_sum09    LIKE oob_file.oob09                                           
DEFINE l_sum10    LIKE oob_file.oob10                                           
                                                                                
   INITIALIZE l_oma.* TO NULL                                                   
   #若已经存在冲帐金额，则需累计                                                
   SELECT * INTO l_oma.* FROM oma_file 
    WHERE oma01 = g_oma.oma01                                                   
   IF STATUS THEN                                                               
      IF g_bgerr THEN                                                           
         CALL s_errmsg('oma01',g_oma.oma01,'Sel oma:',STATUS,0)                 
      ELSE                                                                      
         CALL cl_err3("upd","oma_file",g_oma.oma01,"",STATUS,"","Sel oma:",1)   
      END IF                                                                    
      RETURN                                                                    
   END IF                                                                       
   IF cl_null(l_oma.oma55) THEN LET l_oma.oma55 = 0 END IF                      
   IF cl_null(l_oma.oma57) THEN LET l_oma.oma57 = 0 END IF                      
                                                                                
   #计算当前直接收款金额                                                        
   LET l_ooa31d = 0                                                             
   LET l_ooa32d = 0                                                             
   SELECT ooa31d,ooa32d INTO l_ooa31d,l_ooa32d FROM ooa_file                    
    WHERE ooa01 = g_oma.oma01                                                   
   IF cl_null(l_ooa31d) THEN LET l_ooa31d = 0 END IF                            
   IF cl_null(l_ooa32d) THEN LET l_ooa32d = 0 END IF                            
                                                                                
   #更新该应收帐款实际已收金额                                                  
   #若原币金额+当前直接收款原币借方金额合计>原币应收含税金额 ->即溢收    
   IF l_oma.oma55 + l_ooa31d > l_oma.oma54t THEN                                
      UPDATE oma_file SET oma55 = l_oma.oma54t,                                 
                          oma57 = l_oma.oma56t                                  
       WHERE oma01 = g_oma.oma01                                                
                                                                                
      UPDATE omc_file SET omc10 = omc08,                                        
                          omc11 = omc09                                         
       WHERE omc01 = g_oma.oma01                                                
   ELSE                                                                         
      UPDATE oma_file SET oma55 = l_oma.oma55 + l_ooa31d,                       
                          oma57 = l_oma.oma57 + l_ooa32d                        
       WHERE oma01 = g_oma.oma01                                                
        SELECT count(*) INTO l_cnt FROM omc_file                                
         WHERE omc01 =g_oma.oma01 ORDER BY omc02                                
      DECLARE s_yz_h2_c CURSOR FOR                                              
        SELECT omc02 FROM omc_file                                              
         WHERE omc01 =g_oma.oma01 ORDER BY omc02                                
         FOREACH s_yz_h2_c INTO l_omc02                                         
           LET l_oob09 = 0                                                      
           LET l_oob10 = 0                                                      
           DECLARE s_oob09_oob10_cs CURSOR FOR                                  
             SELECT oob09,oob10 FROM oob_file 
               WHERE oob01 = g_oma.oma01                                        
                AND oob19 = l_omc02                                             
                AND oob02 > 0                                                   
           FOREACH s_oob09_oob10_cs INTO l_sum09,l_sum10                        
              IF cl_null(l_sum09) THEN LET l_sum09 = 0 END IF                   
              IF cl_null(l_sum10) THEN LET l_sum10 = 0 END IF                   
              LET l_oob09 = l_oob09 + l_sum09                                   
              LET l_oob10 = l_oob10 + l_sum10                                   
              END FOREACH                                                       
           IF SQLCA.sqlcode THEN                                                
              CONTINUE FOREACH                                                  
           END IF                                                               
                                                                                
           UPDATE omc_file SET omc10 =l_oob09,                                  
                               omc11 =l_oob10                                   
            WHERE omc01 =g_oma.oma01                                            
              AND omc02 =l_omc02                                                
         END FOREACH                                                            
                                                                                
      IF l_oma.oma57 + l_ooa32d > l_oma.oma56t THEN                             
         UPDATE oma_file SET oma57 = l_oma.oma56t                               
          WHERE oma01 = g_oma.oma01  
         UPDATE omc_file SET omc11 = omc09 WHERE omc01 = g_oma.oma01            
      END IF                                                                    
   END IF                                                                       
   IF SQLCA.sqlcode THEN                                                        
      IF g_bgerr THEN                                                           
         CALL s_errmsg('omc01',g_oma.oma01,g_oma.oma01,SQLCA.sqlcode,0)         
      ELSE                                                                      
         CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","",0)    
      END IF                                                                    
      RETURN                                                                    
   ELSE                                                                         
      LET g_success = 'Y'                                                       
   END IF                                                                       
                                                                                
   #更新本币未冲金额 oma61                                                      
   INITIALIZE l_oma.* TO NULL                                                   
   SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = g_oma.oma01                
                                                                                
   #计算未冲金额-当前已冲金额=后续未冲金额                                      
   LET l_oma.oma61 = l_oma.oma61 - l_oma.oma57                                  
                                                                                
   IF l_oma.oma61 < 0 THEN LET l_oma.oma61 = 0  END IF
   UPDATE oma_file SET oma61 = l_oma.oma61                                      
    WHERE oma01 = g_oma.oma01                                                   
   IF SQLCA.sqlcode THEN                                                        
      IF g_bgerr THEN                                                           
         CALL s_errmsg('oma01',g_oma.oma01,g_oma.oma01,SQLCA.sqlcode,0)         
      ELSE                                                                      
         CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","",0)    
      END IF                                                                    
      RETURN                                                                    
   ELSE                                                                         
      LET g_success = 'Y'                                                       
   END IF                                                                       
   UPDATE omc_file SET omc13 = omc09 - omc11 WHERE omc01=g_oma.oma01            
END FUNCTION                                                                    
#No.MOD-A30027 --end  
