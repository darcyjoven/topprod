# Prog. Version..: '5.25.04-11.09.15(00004)'     #
#
# Pattern name...: aglp010.4gl
# Descriptions...:结转损益-for调整
# Date & Author..: 10/11/16 by  lutingting
# Modify.........: NO.FUN-B40104 11/05/05 By jll     报表合并作业產品
# Modify.........: No.FUN-B60134 11/08/01 BY lutingting 条件ADD axiconf = 'Y'
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No.FUN-B90045 11/09/05 By lutingting調整差異計入aaw06
# Modify.........: NO.130805     13/08/05 by xiayan aaw_file替换为aaz_file
# Modify.........: no.130806     13/08/06 by xiayan axi09 = 'N'
# Modify.........: NO.130809     13/08/09 by lily 产生的调整作业单据日期应为调整月的最后一天

DATABASE ds
 
#GLOBALS "../../config/top.global"     #yangtt 130819
GLOBALS "../../../tiptop/config/top.global"  #yangtt 130819

DEFINE tm  RECORD 
           axi03  LIKE axi_file.axi03,   #年度
           axi04  LIKE axi_file.axi04,   #期别
           axi05  LIKE axi_file.axi05,   #族群
           aac01  LIKE aac_file.aac01    #单别
           END RECORD,
       g_bookno        LIKE aea_file.aea00    
DEFINE ls_date         STRING,                #No.FUN-570145
       l_flag          LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
       g_change_lang   LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1) 
DEFINE g_sql           STRING                 
DEFINE g_aaw01         LIKE aaw_file.aaw01
#FUN-B80135--add--str--
DEFINE g_aaa07         LIKE aaa_file.aaa07
DEFINE g_year          LIKE type_file.chr4
DEFINE g_month         LIKE type_file.chr2
#FUN-B80135--add—end--

MAIN

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.axi03 = ARG_VAL(2)
   LET tm.axi04 = ARG_VAL(3)
   LET tm.axi05 = ARG_VAL(4)
   LET tm.aac01 = ARG_VAL(5)
   LET g_bgjob  = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF

   #FUN-B80135--add--str--
   #SELECT aaa07 INTO g_aaa07 FROM aaa_file,aaw_file  #NO.130805 mark
   # WHERE aaa01 = aaw01 AND aaw00 = '0'  #NO.130805 mark
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,aaz_file  #NO.130805 modify
    WHERE aaa01 = aaz641 AND aaz00 = '0'   #NO.130805 modify
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add--end

   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL aglp010_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL s_showmsg_init()
            CALL p010()
            CALL s_showmsg()     
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aglp010_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL s_showmsg_init()
         CALL p010()
         CALL s_showmsg()                             #NO.FUN-710023    
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END  IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION aglp010_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5      
   DEFINE  lc_cmd          LIKE type_file.chr1000  
   DEFINE  l_cnt           LIKE type_file.num5
   DEFINE  l_azm02         LIKE azm_file.azm02

   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 26

   OPEN WINDOW cglp010_w AT p_row,p_col WITH FORM "cgl/42f/cglp010" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CALL cl_set_comp_visible("f",FALSE)
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Defaealt condition

      LET g_bgjob = 'N'                              #FUN-570145
      INPUT tm.axi03,tm.axi04,tm.axi05,tm.aac01,g_bgjob WITHOUT DEFAULTS  
       FROM axi03,axi04,axi05,aac01,g_bgjob    
         
        #No.FUN-B80135--add--str--
         AFTER FIELD axi03
         IF NOT cl_null(tm.axi03) THEN
            IF tm.axi03 < 0 THEN
               CALL cl_err(tm.axi03,'apj-035',0)
              NEXT FIELD axi03
            END IF
            IF tm.axi03 < g_year  THEN
               CALL cl_err(tm.axi03,'axm-164',0)
               NEXT FIELD axi03
            ELSE
               IF tm.axi03 = g_year AND tm.axi04<=g_month THEN
                  CALL cl_err(tm.axi04,'axm-164',0)
                  NEXT FIELD axi04
               END IF
            END IF
         END IF

         AFTER FIELD axi04   
          IF NOT cl_null(tm.axi04) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.axi03
            IF g_azm.azm02 = 1 THEN
               IF tm.axi04>12 OR tm.axi04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD axi04
               END IF
            ELSE
               IF tm.axi04>13 OR tm.axi04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD axi04
               END IF
            END IF
             IF NOT cl_null(tm.axi03) AND tm.axi03=g_year
               AND tm.axi04<=g_month THEN
               CALL cl_err(tm.axi04,'axm-164',0)
               NEXT FIELD axi04
            END IF
         END IF    
        #No.FUN-B80135--add--end-- 

         AFTER FIELD axi05   
           IF NOT cl_null(tm.axi05) THEN
              SELECT COUNT(*) INTO l_cnt FROM axa_file
               WHERE axa01 = tm.axi05
              IF l_cnt<1 THEN
                 CALL cl_err('','agl-246',0)
                 NEXT FIELD axi05
              END IF 
           END IF 
         AFTER FIELD aac01   
           IF NOT cl_null(tm.aac01) THEN
              CALL p010_aac01(tm.aac01)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('aac01',g_errno,0)
                 NEXT FIELD aac01
              END IF
           ELSE
              NEXT FIELD aac01
           END IF
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(axi05)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_axa1"
                   LET g_qryparam.default1 = tm.axi05
                   CALL cl_create_qry() RETURNING tm.axi05
                   DISPLAY tm.axi05 TO axi05
                   NEXT FIELD axi05
                WHEN INFIELD(aac01)
                   CALL q_aac(FALSE,TRUE,tm.aac01,'A','','','AGL') RETURNING tm.aac01
                   DISPLAY tm.aac01 TO aac01
                   NEXT FIELD aac01
               OTHERWISE EXIT CASE
            END CASE

        #ON ACTION CONTROLZ    #yangtt 130819
         ON ACTION CONTROLR    #yangtt 130819
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about      
            CALL cl_about()    
 
         ON ACTION help        
            CALL cl_show_help()
 
         ON ACTION exit                            
            LET INT_FLAG = 1
            EXIT INPUT
   
         #No:FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_init()
         #No:FUN-580031 ---end---

         #No:FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No:FUN-580031 ---end---

         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---

         #->FUN-570145-start----------
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No:FUN-550037 hmf
            LET g_change_lang = TRUE
            EXIT INPUT
         #->FUN-570145-end------------

      END INPUT
     #FUN-570145 --start--
      #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()               #No:FUN-550037 hmf
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp010'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp010','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.axi03 CLIPPED,"'",
                         " '",tm.axi04 CLIPPED,"'",
                         " '",tm.axi05 CLIPPED,"'",   
                         " '",tm.aac01 CLIPPED,"'",  
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp010',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW aglp010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p010()
DEFINE l_axi RECORD LIKE axi_file.*
DEFINE l_axj RECORD LIKE axj_file.*
DEFINE l_sum_c LIKE axj_file.axj07
DEFINE l_sum_d LIKE axj_file.axj07
DEFINE l_sum   LIKE axj_file.axj07
DEFINE l_aag06 LIKE aag_file.aag06
DEFINE l_axj03 LIKE axj_file.axj03
DEFINE t_axj03 LIKE axj_file.axj03
DEFINE l_axi11 LIKE axi_file.axi11
DEFINE l_axi12 LIKE axi_file.axi12
DEFINE l_cnt   LIKE type_file.num5
DEFINE li_result LIKE type_file.num5
DEFINE l_axi01   LIKE axi_file.axi01
DEFINE l_axj05   LIKE axj_file.axj05
DEFINE l_axa02   LIKE axa_file.axa02
DEFINE l_sql     STRING 
DEFINE l_cn       LIKE type_file.num5
#130809 add by lily--str
DEFINE g_yy             LIKE type_file.chr4  
DEFINE g_mm             LIKE type_file.chr2
DEFINE g_bdate          LIKE axi_file.axi02
DEFINE g_edate          LIKE axi_file.axi02
#130809 add by lily--end  
   ######INSERT 前先删除
   ######指定[年度],[期别],[族群]只对应一笔axi08='1' ,axi081 = 'W'的调整分录
   #SELECT aaw01 INTO g_aaw01 FROM aaw_file WHERE aaw00 = '0'  #NO.130805 mark
   SELECT aaz641 INTO g_aaw01 FROM aaz_file WHERE aaz00 = '0'  #NO.130805 modify
   SELECT COUNT(*) INTO l_cnt FROM axi_file
    WHERE axi00 = g_aaw01 AND axi03 = tm.axi03 AND axi04 = tm.axi04
      AND axi05 = tm.axi05
      AND axi08  = '1' AND axi081 = 'W'
      AND axiconf = 'Y'    #FUN-B60134
   IF l_cnt > 0 THEN
      LET l_sql = "SELECT axi01 FROM axi_file WHERE axi00 = '",g_aaw01,"'",
                  "   AND axi03 = '",tm.axi03,"' AND axi04 = '",tm.axi04,"'",
                  "   AND axiconf = 'Y' ",   #FUN-B60134
                  "   AND axi05 = '",tm.axi05,"' AND axi08 = '1' AND axi081 = 'W'"
      PREPARE sel_axi01 FROM l_sql
      DECLARE sel_axi01_cur CURSOR FOR sel_axi01
      LET l_cn = 1
      FOREACH sel_axi01_cur INTO l_axi01
      #SELECT axi01 INTO l_axi01 FROM axi_file WHERE axi00 = g_aaw01
      #   AND axi03 = tm.axi03 AND axi04 = tm.axi04 AND axi05 = tm.axi05
      #   AND axi08 = '1' AND axi081 = 'W'
          IF l_cn = 1 THEN
          IF NOT s_ask_entry(l_axi01) THEN RETURN END IF #Genero
          END IF 
          DELETE FROM axi_file WHERE axi00 = g_aaw01 AND axi01 = l_axi01
             AND axiconf = 'Y'   #FUN-B60134
          DELETE FROM axj_file WHERE axj00 = g_aaw01 AND axj01 = l_axi01
            # AND axjconf = 'Y'   #FUN-B60134  #NO.130806 mark
          LET l_cn = l_cn+1
      END FOREACH
   END IF
   
LET l_sql = "SELECT axa02 FROM axa_file WHERE axa01 = '",tm.axi05,"'"
PREPARE sel_axa02_pre FROM l_sql
DECLARE sel_axa02_cur CURSOR FOR sel_axa02_pre
FOREACH sel_axa02_cur INTO l_axa02
   ####step1  insert axi_file
   INITIALIZE l_axi.* TO NULL
   LET l_axi.axi00 = g_aaw01
   CALL s_auto_assign_no("AGL",tm.aac01,g_today,"","axi_file","axi01",g_plant,2,l_axi.axi00)  #NO.FUN-B40104
               RETURNING li_result,l_axi.axi01
   IF (NOT li_result) THEN
      CALL s_errmsg('axi_file','axi01',l_axi.axi01,'abm-621',1)
      LET g_success = 'N'
   END IF
 # LET l_axi.axi02 = g_today  # mark 130809
  #130809 mod by lily--str  
   LET g_yy = YEAR(g_today)  
   LET g_mm = tm.axi04     
   CALL s_azn01(g_yy,g_mm) RETURNING g_bdate,g_edate
   LET l_axi.axi02 = g_edate
  #130809 mod by lily--end 
   LET l_axi.axi03 = tm.axi03
   LET l_axi.axi04 = tm.axi04
   LET l_axi.axi05 = tm.axi05
   #SELECT axa02 INTO l_axi.axi06 FROM axa_file
   # WHERE axa01 = l_axi.axi05 AND axa04 = 'Y'
   LET l_axi.axi06 = l_axa02
   SELECT axz05 INTO l_axi.axi07 FROM axz_file
    WHERE axz01 = l_axi.axi06
   LET l_axi.axi08  = '1'  #调整 
#  LET l_axi.axi081 = 'W'  #损益结转
   #LET l_axi.axi09 = ' '  #NO.130806 mark
   LET l_axi.axi09 = 'N'   #NO.130806 modify
   LET l_axi.axi10  = ' ' 
   LET l_axi.axi11 = 0  #单身产生后回写
   LET l_axi.axi12 = 0  #单身产生后回写
   LET l_axi.axi13 = ' '
   LET l_axi.axi14 = ' '
   LET l_axi.axi15 = ' '
   LET l_axi.axi16 = ' '
   LET l_axi.axi17 = ' '
   LET l_axi.axi18 = ' '
   LET l_axi.axi19 = ' '
   LET l_axi.axi20 = ' '
#  LET l_axi.axi21 = '00'   #版本
   LET l_axi.axiconf = 'Y'
   LET l_axi.axiuser = g_user
   LET l_axi.axigrup = g_grup
   LET l_axi.aximodu =  g_user
   LET l_axi.axidate = g_today
   LET l_axi.axi21 = '00'   #版本
   LET l_axi.axioriu =  g_grup
   LET l_axi.axiorig =  g_grup 
   LET l_axi.axilegal= g_legal   #所属法人
   LET l_axi.axi081 = 'W'  #损益结转
   LET l_axi.axilegal = g_legal
   
   #FUN-B80135--add--str--
   IF l_axi.axi03 <g_year OR (l_axi.axi03=g_year AND l_axi.axi04<=g_month) THEN
      LET g_success='N'
      RETURN
    END IF
   #FUN-B80135--add—end--

   INSERT INTO axi_file VALUES(l_axi.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('axi_file','insert',l_axi.axi01,SQLCA.sqlcode,1)    
      LET g_success = 'N'
   END IF  

   ###step2  依科目insert axj_file  
   LET g_sql = "SELECT UNIQUE axj03,axj05 FROM axi_file,axj_file,aag_file ",
               " WHERE axi00 = axj00 AND axi01 = axj01 ",
               "   AND axj03 = aag01 AND aag00 = axj00 AND aag04 = '2' ", #损益
               "   AND aag03 = '2' AND aag07<>'1' AND aag09 = 'Y'",           
               "   AND axi03 = '",tm.axi03,"'",
               "   AND axi04 = '",tm.axi04,"'",
               "   AND axi05 = '",tm.axi05,"'",
               "   AND axi06 = '",l_axa02,"'",    #luttb 101204
               "   AND axi08 = '1' AND axi081 IN ('U','V')",
               "   AND axiconf = 'Y'",   #FUN-B60134
               " GROUP BY axj03,axj05",
               " ORDER BY axj03,axj05"
   PREPARE sel_pre FROM g_sql
   DECLARE sel_pre_cur CURSOR FOR sel_pre
   FOREACH sel_pre_cur INTO l_axj03,l_axj05
      IF STATUS THEN 
      END IF 
      LET l_axj.axj00 = l_axi.axi00
      LET l_axj.axj01 = l_axi.axi01
      LET l_axj.axj05 = l_axj05
      SELECT max(axj02) INTO l_axj.axj02 FROM axj_file
       WHERE axj00 = l_axi.axi00 AND axj01 = l_axj.axj01
      IF cl_null(l_axj.axj02) THEN LET l_axj.axj02 = 0 END IF
      LET l_axj.axj02 = l_axj.axj02 + 1
      LET l_axj.axj03 = l_axj03
      ###科目借方金额
      SELECT SUM(axj07) INTO l_sum_d FROM axi_file,axj_file
       WHERE axi00 = axj00 AND axi01 = axj01 
         AND axi08 = '1' AND axi081 IN('U','V')
         AND axi03 = tm.axi03  #年度
         AND axi04 = tm.axi04  #期别
         AND axi05 = tm.axi05  #族群
         AND axi06 = l_axa02   #luttb
         AND axj03 = l_axj03  #科目         
         AND axj05 = l_axj05  #关系人
         AND axj06 = '1'   #借
      IF cl_null(l_sum_d) THEN LET l_sum_d = 0 END IF    
      ###科目贷方金额
      SELECT SUM(axj07) INTO l_sum_c FROM axi_file,axj_file
       WHERE axi00 = axj00 AND axi01 = axj01 
         AND axi08 = '1' AND axi081 IN('U','V')
         AND axi03 = tm.axi03  #年度
         AND axi04 = tm.axi04  #期别
         AND axi05 = tm.axi05  #族群
         AND axi06 = l_axa02   #luttb
         AND axj03 = l_axj03  #科目         
         AND axj05 = l_axj05  #关系人
         AND axj06 = '2'   #贷 
      IF cl_null(l_sum_c) THEN LET l_sum_c = 0 END IF    
      SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag00 = l_axj.axj00
        AND aag01 = l_axj.axj03
      IF l_aag06 = '1' THEN   #余额在借方
         LET l_axj.axj07 = l_sum_d-l_sum_c 
         LET l_axj.axj06 = '2'           
      ELSE   #余额在贷方
         LET l_axj.axj07 = l_sum_c-l_sum_d
         LET l_axj.axj06 = '1'
      END IF 
       LET l_axj.axj08= ' '
      LET l_axj.axj09= ' '
      LET l_axj.axj09= ' '
      LET l_axj.axj10= ' '
      LET l_axj.axj11= ' '
      LET l_axj.axj12= ' '
      LET l_axj.axjlegal= g_legal    #所属法人 
      INSERT INTO axj_file VALUES(l_axj.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('axj_file','insert',l_axi.axi01,SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END FOREACH
   
   ###step 3 调整差异计入aaw06
   #差额计入aaw06
   SELECT SUM(axj07) INTO l_axi11 FROM axj_file WHERE axj00 = l_axi.axi00
      AND axj01 = l_axi.axi01 AND axj06 = '1'   #借方
   SELECT SUM(axj07) INTO l_axi12 FROM axj_file WHERE axj00 = l_axi.axi00
      AND axj01 = l_axi.axi01 AND axj06 = '2'   #贷方
   IF cl_null(l_axi11) THEN LET l_axi11 = 0 END IF 
   IF cl_null(l_axi12) THEN LET l_axi12 = 0 END IF   
   IF l_axi11 = l_axi12 THEN  #借方=贷方则没有差异
   ELSE 
      #SELECT aaw04 INTO l_axj.axj03 FROM aaw_file WHERE aaw00 = '0'   #FUN-B90045  
      #SELECT aaw06 INTO l_axj.axj03 FROM aaw_file WHERE aaw00 = '0'    #FUN-B90045 #NO.130805 mark
      SELECT aaz114 INTO l_axj.axj03 FROM aaz_file WHERE aaz00 = '0'    #FUN-B90045 #NO.130805 modify
      IF l_axi11>l_axi12 THEN   #借方>贷方则差异放在贷方 
         LET l_axj.axj06 = '2'
         LET l_axj.axj07 = l_axi11-l_axi12
      ELSE
         LET l_axj.axj06 = '1'
         LET l_axj.axj07 = l_axi12-l_axi11
      END IF 
      SELECT MAX(axj02) INTO l_axj.axj02 FROM axj_file 
       WHERE axj00 = l_axi.axi00 AND axj01 = l_axi.axi01
      IF cl_null(l_axj.axj02) THEN LET l_axj.axj02 = 0 END IF
      LET l_axj.axj02 = l_axj.axj02+1
      #LET l_axj.axj05 = ' '     #luttb 101213
      LET l_axj.axj05 = l_axa02  #luttb 101213
      LET l_axj.axjlegal = g_legal
      INSERT INTO axj_file VALUES(l_axj.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('axj_file','insert',l_axi.axi01,SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF 
   
   ####step 4 UPDATE 单头
   #UPDATE axi_file 借方总金额 贷方总金额 
   LET l_axi11 = 0 LET l_axi12 = 0
   SELECT SUM(axj07) INTO l_axi11 FROM axj_file WHERE axj00 = l_axi.axi00
      AND axj01 = l_axi.axi01 AND axj06 = '1'   #借方
   SELECT SUM(axj07) INTO l_axi12 FROM axj_file WHERE axj00 = l_axi.axi00
      AND axj01 = l_axi.axi01 AND axj06 = '2'   #贷方
   IF cl_null(l_axi11) THEN LET l_axi11 = 0 END IF 
   IF cl_null(l_axi12) THEN LET l_axi12 = 0 END IF 
   UPDATE axi_file SET axi11 = l_axi11,
                       axi12 = l_axi12
    WHERE axi00 = l_axi.axi00
      AND axi01 = l_axi.axi01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('axi_file','update',l_axi.axi01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 
END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF    
END FUNCTION

FUNCTION p010_aac01(p_t1)
   DEFINE l_aacacti   LIKE aac_file.aacacti
   DEFINE l_aac11     LIKE aac_file.aac11
   DEFINE p_t1        LIKE aac_file.aac01

   LET g_errno = ' '
   SELECT aacacti INTO l_aacacti FROM aac_file
    WHERE aac01 = p_t1

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-035'   
         WHEN l_aacacti = 'N'      LET g_errno = 'agl-321'
         WHEN l_aac11<>'Y'         LET g_errno = 'agl-322'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
#NO.FUN-B40104
