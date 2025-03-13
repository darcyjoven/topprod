# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcp402.4gl
# Descriptions...: 工單重工自動設定作業
# Date & Author..: 96/01/30 By Roger
# Modify.........: 03/05/14 By Jiunn (No.7266)
#                  拆件式工單(sfb02=11)認定為重工
# Modify.........: No.6943 03/07/18 By Kammy 開單日不可大於現行年月之判斷
#                                            未考慮到年度
# Modify.........: No.MOD-570202 05/07/22 By pengu 1.組SQL部份應涵蓋目前未做成會結案或成會結案日在當月者
# Modify.........: No.MOD-590309 05/09/26 By pengu  l_sql語法錯誤
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次作業修改
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.MOD-870106 08/07/10 By Sarah 結案日sfb38在成本結算期別之後,也需納入考慮
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息修改 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B60075 11/07/17 By Pengu 未考慮委外代採買情況
# Modify.........: No:CHI-C60009 12/08/13 By ck2yuan sfe_ima57抓不到資料時，改抓sfa_file的資料
# Modify.........: No:FUN-C80092 12/09/12 By xujing 成本相關作業程式日誌
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE sw_1             LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE sw_2             LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE g_wc             string  #No.FUN-580092 HCN
DEFINE g_flag           LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
DEFINE g_change_lang    LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)        #FUN-570153
DEFINE g_cka00          LIKE cka_file.cka00           #FUN-C80092 add
DEFINE g_cka09          LIKE cka_file.cka09           #FUN-C80092 add
 
MAIN
#     DEFINE   l_time   LIKE type_file.chr8       #No.FUN-6A0146
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
#FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET sw_1    = ARG_VAL(2)
   LET sw_2    = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
#NO.FUN-570153 end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
#NO.FUN-570153 mark--
#   LET p_row = 1 LET p_col = 1 
 
#   OPEN WINDOW p402_w AT p_row,p_col WITH FORM "axc/42f/axcp402" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#   CALL cl_opmsg('q')
#   WHILE TRUE 
#      LET g_flag = 'Y'
#      CALL p402_ask()
#      IF g_flag = 'N' THEN
#          CONTINUE WHILE
#      END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#     IF cl_sure(21,21) THEN 
#         CALL cl_wait()
#         CALL p402()
#         ERROR ''
#         IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#         IF g_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
#   END WHILE
#   CLOSE WINDOW p402_w
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start--
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL p402_ask()
         IF cl_sure(21,21) THEN 
            CALL cl_wait()
            LET g_cka09 = "sw_1='",sw_1,"';sw_2='",sw_2,"';g_bgjob='",g_bgjob,"'"   #FUN-C80092 add
            CALL s_log_ins(g_prog,'','',g_wc,g_cka09) RETURNING g_cka00             #FUN-C80092 add
            BEGIN WORK
            CALL p402()
            CALL s_showmsg()        #No.FUN-710027  
            IF g_success = 'Y' THEN 
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')             #FUN-C80092 add
               CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
            ELSE 
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')             #FUN-C80092 add
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
            END IF 
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p402_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p402_w
      ELSE
         LET g_cka09 = "sw_1='",sw_1,"';sw_2='",sw_2,"';g_bgjob='",g_bgjob,"'"   #FUN-C80092 add
         CALL s_log_ins(g_prog,'','',g_wc,g_cka09) RETURNING g_cka00   #FUN-C80092 add
         BEGIN WORK
         CALL p402()
         CALL s_showmsg()        #No.FUN-710027  
         IF g_success = 'Y' THEN 
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
         ELSE 
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         END IF 
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570153 end------
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p402_ask()
   DEFINE   c   LIKE cre_file.cre08         #No.FUN-680122 VARCHAR(10)
   DEFINE lc_cmd         LIKE type_file.chr1000        #No.FUN-680122  VARCHAR(500)        #FUN-570153
   DEFINE p_row,p_col    LIKE type_file.num5               #FUN-570153        #No.FUN-680122 SMALLINT
 
#NO.FUN-570153 start-
   LET p_row = 1 LET p_col = 1 
 
   OPEN WINDOW p402_w AT p_row,p_col WITH FORM "axc/42f/axcp402" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
  WHILE TRUE  
#NO.FUN-570153 end--
 
   CONSTRUCT BY NAME g_wc ON sfb01,sfb13,sfb81 #BugNO:3392 mandy
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
#NO.FUN-570153 start--
#        LET g_action_choice = "locale"
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE                    #FUN-570153
#NO.FUN-570153 end----
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
     ON ACTION exit              #加離開功能genero
        LET INT_FLAG = 1
        EXIT CONSTRUCT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup') #FUN-980030
#NO.FUN-570153 start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE 
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p402_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
#
#   IF INT_FLAG THEN
#      LET INT_FLAG = 1 RETURN
#   END IF
#NO.FUN-570153 end--
 
   LET sw_1='Y'
   LET sw_2='Y'
   LET g_bgjob = 'N'      #FUN-570153
   #INPUT BY NAME sw_1, sw_2 WITHOUT DEFAULTS 
   INPUT BY NAME sw_1, sw_2 ,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570153 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit             #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      ON ACTION locale               #FUN-570153
         LET g_change_lang = TRUE    #FUN-570153
         EXIT INPUT                  #FUN-570153
 
   END INPUT
#NO.FUN-570153 start---
#   IF INT_FLAG THEN
#      RETURN
#   END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p402_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axcp402'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('axcp402','9031',1)   
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_wc CLIPPED,"'",
                         " '",sw_1 CLIPPED,"'",
                         " '",sw_2 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('axcp402',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p402_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#FUN-570153 ---end---
END FUNCTION
 
FUNCTION p402()
define g_sfb record like sfb_file.*,
       l_ima57  LIKE type_file.num5,          #No.FUN-680122 smallint,
       l_sql     LIKE type_file.chr1000,      #No.FUN-680122 VARCHAR(600), 
       sfe_ima57 LIKE type_file.num5,         #No.FUN-680122 smallint,
       old_sfb99 LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
#No.B328 add by Ostrich 010503 重工設定應考慮工單開單日不可大於現行結算年月
   LET l_sql = "SELECT * FROM sfb_file ",
               #No.7266 03/05/14 By Jiunn Mod.A.a.01 -----
#              " WHERE sfb02 != '13' and sfb02 != '11'",
               " WHERE sfb02 != '13'",
               #No.7266 End.A.a.01 -----------------------
               "   and sfb02 != '15' ",
               "   and ",g_wc clipped,                        #No.MOD-570202 add
               #No.6943
                #---No.MOD-570202 modify
                "   AND ((((MONTH(sfb81) <= ",g_ccz.ccz02,      #No.MOD-570202 add '('
               "        AND YEAR(sfb81)= ",g_ccz.ccz01,") ",
               "        OR YEAR(sfb81) < ",g_ccz.ccz01,")",  #No.MOD-590309  #No.MOD-570202 add ')'
               "      AND (sfb38 = '' OR sfb38 IS NULL )) ",
               #No.6943(end)
              #str MOD-870106 mod
              #結案日在成本結算期別之後,都納入考慮
              #"   OR (MONTH(sfb38) = ",g_ccz.ccz02,      #No.MOD-590309
              #"    AND YEAR(sfb38) = ",g_ccz.ccz01,"))"   #No.MOD-590309
               "   OR ((MONTH(sfb38)>=",g_ccz.ccz02,
               "     AND YEAR(sfb38)= ",g_ccz.ccz01,")",
               "      OR YEAR(sfb38)> ",g_ccz.ccz01,"))"
              #end MOD-870106 mod
                #---No.MOD-570202 end
               #"   and ",g_wc clipped                         #No.MOD-570202 mark
   PREPARE p402_p1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('Prepare p402_p1:',STATUS,1)
      LET g_success = 'N'    #No.FUN-8A0086 
   END IF
   DECLARE p402_c1 CURSOR WITH HOLD FOR p402_p1
 
#   BEGIN WORK   #NO.FUN-570153 
   LET g_success = 'Y' 
 
   CALL s_showmsg_init()   #No.FUN-710027  
   FOREACH p402_c1 INTO g_sfb.*
      IF SQLCA.sqlcode THEN   
#         CALL cl_err('p402_c1',SQLCA.sqlcode,0)          #No.FUN-710027 
         CALL s_errmsg('','','p402_c1',SQLCA.sqlcode,0)   #No.FUN-710027
         LET g_success = 'N'                              #No.FUN-8A0086 
         EXIT FOREACH
      END IF
#No.FUN-710027--begin 
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
#No.FUN-710027--end
      IF sw_1='N' AND g_sfb.sfb02='1' THEN CONTINUE FOREACH end if
      IF sw_2='N' AND g_sfb.sfb02='7' THEN CONTINUE FOREACH end if
      LET old_sfb99=g_sfb.sfb99
      SELECT ima57 INTO l_ima57 FROM ima_file WHERE ima01=g_sfb.sfb05
      SELECT min(ima57) INTO sfe_ima57 FROM sfe_file,ima_file 
              WHERE sfe01=g_sfb.sfb01 AND sfe07 = ima01   
     #CHI-C60009 str add-----
      IF cl_null(sfe_ima57) THEN
         SELECT min(ima57) INTO sfe_ima57 FROM sfa_file,ima_file
          WHERE sfa01=g_sfb.sfb01 AND sfa03 = ima01
      END IF
     #CHI-C60009 end add-----
      IF l_ima57 >= sfe_ima57
         THEN LET g_sfb.sfb99='Y'
         ELSE 
            LET g_sfb.sfb99='N'
           #----------------No:MOD-B60075 add
           #考慮委外代採買情況
            IF g_sfb.sfb02 = '7' OR g_sfb.sfb02 = '8' THEN
               SELECT min(ima57) INTO sfe_ima57 FROM ima_file,tlf_file
                 WHERE tlf62 = g_sfb.sfb01 AND tlf01=ima01 
                   AND tlf13 = 'asfi511' AND tlf03 = '18'
               IF l_ima57 >= sfe_ima57 THEN
                  LET g_sfb.sfb99='Y'
               END IF
            END IF
           #----------------No:MOD-B60075 end
      END IF 
      UPDATE sfb_file SET sfb99=g_sfb.sfb99 WHERE sfb01=g_sfb.sfb01
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
#        CALL cl_err('update error',SQLCA.sqlcode,1)   #No.FUN-660127
#         CALL cl_err3("upd","sfb_file",g_sfb.sfb01,"",SQLCA.SQLCODE,"","UPDATE ERROR",1)   #No.FUN-660127 #No.FUN-710027
          CALL s_errmsg('sfb01',g_sfb.sfb01,'upddate error',SQLCA.sqlcode,1)                               #No.FUN-710027
         LET g_success = 'N' 
      END IF
      IF g_bgjob = 'N' THEN  #NO.FUN-570153 
          CALL ui.Interface.refresh()
          message g_sfb.sfb01,' ',old_sfb99,' -> ',g_sfb.sfb99
      END IF
    END FOREACH 
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
#NO.FUN-570153 mark--
#    IF g_success = 'Y' THEN 
#       COMMIT WORK
#       CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#    ELSE 
#       ROLLBACK WORK
#       CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#    END IF 
#NO.FUN-570153 mark--
  END FUNCTION
