# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gglp208.4gl
# Descriptions...:结转损益-- for会计师调整&冲销
# Date & Author..: 10/11/17 by  lutingting
# Modify.........: NO.FUN-B40104 11/05/05 By jll 报表回收产品
# Modify.........: No.FUN-B60134 11/08/01 BY lutingting 条件ADD asjconf = 'Y'
# Modify.........: No.FUN-B80135 11/08/22 By lujh       相關日期欄位不可小於關帳日期 
# Modify.........: No.FUN-B90045 11/09/05 By lutingting調整差異計入asz06
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr
# Modify.........: No.TQC-C90057 12/09/11 By Carrier asj09/asj11/asj12空时赋值
# Modify.........: No.TQC-CA0063 12/10/31 By fengmy 去掉askconf = 'Y'

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                        #FUN-BB0036 
           asj03  LIKE asj_file.asj03,   #年度
           asj04  LIKE asj_file.asj04,   #期别
           asj05  LIKE asj_file.asj05,   #族群
           aac01  LIKE aac_file.aac01    #单别
           END RECORD,
       g_bookno        LIKE aea_file.aea00    
DEFINE ls_date         STRING,                #No.FUN-570145
       l_flag          LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
       g_change_lang   LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1) 
DEFINE g_sql           STRING                 
DEFINE g_asz01        LIKE asz_file.asz01
DEFINE g_aaa07          LIKE aaa_file.aaa07   #No.FUN-B80135
DEFINE g_year           LIKE type_file.chr4   #No.FUN-B80135
DEFINE g_month          LIKE type_file.chr2   #No.FUN-B80135

MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.asj03 = ARG_VAL(2)
   LET tm.asj04 = ARG_VAL(3)
   LET tm.asj05 = ARG_VAL(4)
   LET tm.aac01 = ARG_VAL(5)
   LET g_bgjob  = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0' 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07) 
   #FUN-B80135--add--end
   
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF
   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL gglp208_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL s_showmsg_init()
            CALL p011()
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
               CLOSE WINDOW gglp208_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL s_showmsg_init()
         CALL p011()
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

FUNCTION gglp208_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5      
   DEFINE  lc_cmd          LIKE type_file.chr1000  
   DEFINE  l_cnt           LIKE type_file.num5
   DEFINE  l_azm02         LIKE azm_file.azm02

   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 26

   OPEN WINDOW gglp208_w AT p_row,p_col WITH FORM "ggl/42f/gglp208" 
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
      INPUT tm.asj03,tm.asj04,tm.asj05,tm.aac01,g_bgjob WITHOUT DEFAULTS  
       FROM asj03,asj04,asj05,aac01,g_bgjob     

      #No.FUN-B80135--add--str--
      AFTER FIELD asj03
         IF NOT cl_null(tm.asj03) THEN
            IF tm.asj03 < 0 THEN
               CALL cl_err(tm.asj03,'apj-035',0)
               NEXT FIELD asj03
            END IF
            IF tm.asj03<g_year THEN
               CALL cl_err(tm.asj03,'atp-164',0)
               NEXT FIELD asj03
            ELSE 
               IF tm.asj03=g_year AND tm.asj04<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD asj04  
               END IF 
            END IF 
         END IF
 
      AFTER FIELD asj04
         IF NOT cl_null(tm.asj04) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.asj03
            IF g_azm.azm02 = 1 THEN
               IF tm.asj04 > 12 OR tm.asj04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD asj04
               END IF
            ELSE
               IF tm.asj04 > 13 OR tm.asj04 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD asj04
               END IF
            END IF
            IF NOT cl_null(tm.asj03) AND tm.asj03=g_year 
               AND tm.asj04<=g_month THEN
               CALL cl_err('','atp-164',0)
               NEXT FIELD asj04
            END IF 
         END IF
         #FUN-B80135--add--end
        
         AFTER FIELD asj05  #族群 
           IF NOT cl_null(tm.asj05) THEN
              SELECT COUNT(*) INTO l_cnt FROM asa_file
               WHERE asa01 = tm.asj05
              IF l_cnt<1 THEN
                 CALL cl_err('','agl-246',0)
                 NEXT FIELD asj05
              END IF 
           END IF 
         AFTER FIELD aac01   
           IF NOT cl_null(tm.aac01) THEN
              CALL p011_aac01(tm.aac01)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('aac01',g_errno,0)
                 NEXT FIELD aac01
              END IF
           ELSE
              NEXT FIELD aac01
           END IF
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(asj05)  
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_asa1"
                   LET g_qryparam.default1 = tm.asj05
                   CALL cl_create_qry() RETURNING tm.asj05
                   DISPLAY tm.asj05 TO asj05
                   NEXT FIELD asj05
                WHEN INFIELD(aac01)
                   CALL q_aac(FALSE,TRUE,tm.aac01,'A','','','GGL') RETURNING tm.aac01
                   DISPLAY tm.aac01 TO aac01
                   NEXT FIELD aac01
               OTHERWISE EXIT CASE
            END CASE

         #ON ACTION CONTROLZ     #TQC-C40010  mark
          ON ACTION CONTROLR     #TQC-C40010  add
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
         CLOSE WINDOW gglp208_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'gglp208'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('gglp208','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.asj03 CLIPPED,"'",
                         " '",tm.asj04 CLIPPED,"'",
                         " '",tm.asj05 CLIPPED,"'",   
                         " '",tm.aac01 CLIPPED,"'",  
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gglp208',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW gglp208_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p011()
DEFINE l_asj RECORD LIKE asj_file.*
DEFINE l_ask RECORD LIKE ask_file.*
DEFINE l_sum_c LIKE ask_file.ask07
DEFINE l_sum_d LIKE ask_file.ask07
DEFINE l_sum   LIKE ask_file.ask07
DEFINE l_aag06 LIKE aag_file.aag06
DEFINE l_ask03 LIKE ask_file.ask03
DEFINE t_ask03 LIKE ask_file.ask03
DEFINE l_asj11 LIKE asj_file.asj11
DEFINE l_asj12 LIKE asj_file.asj12
DEFINE l_cnt   LIKE type_file.num5
DEFINE li_result LIKE type_file.num5
DEFINE l_asj01   LIKE asj_file.asj01
DEFINE l_ask05   LIKE ask_file.ask05
DEFINE l_asa02   LIKE asa_file.asa02
   ######INSERT 前先删除
   ######指定[年度],[期别],[族群]只对应一笔asj08='4' 的调整分录
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'
   SELECT COUNT(*) INTO l_cnt FROM asj_file
    WHERE asj00 = g_asz01 AND asj03 = tm.asj03 AND asj04 = tm.asj04
      AND asj05 = tm.asj05
      AND asj08  = '4'    #结转 
      AND asjconf = 'Y'   #FUN-B60134
   IF l_cnt > 0 THEN
      SELECT asj01 INTO l_asj01 FROM asj_file WHERE asj00 = g_asz01
         AND asj03 = tm.asj03 AND asj04 = tm.asj04 AND asj05 = tm.asj05
         AND asj08 = '4' 
         AND asjconf = 'Y'   #FUN-B60134
      IF NOT s_ask_entry(l_asj01) THEN RETURN END IF #Genero
   END IF
   DELETE FROM asj_file WHERE asj00 = g_asz01 AND asj01 = l_asj01
      AND asjconf = 'Y'    #FUN-B60134
   DELETE FROM ask_file WHERE ask00 = g_asz01 AND ask01 = l_asj01
      #AND askconf = 'Y'    #FUN-B60134     #TQC-CA0063 mark
   ####step1  insert asj_file
   INITIALIZE l_asj.* TO NULL
   LET l_asj.asj00 = g_asz01
  #CALL s_auto_assign_no("GGL",tm.aac01,g_today,"","asj_file","asj01",g_plant,2,l_asj.asj00)  #carrier 20111024
   CALL s_auto_assign_no("AGL",tm.aac01,g_today,"","asj_file","asj01",g_plant,2,l_asj.asj00)  #carrier 20111024
               RETURNING li_result,l_asj.asj01
   IF (NOT li_result) THEN
      CALL s_errmsg('asj_file','asj01',l_asj.asj01,'abm-621',1)
      LET g_success = 'N'
   END IF
   LET l_asj.asj02 = g_today
   LET l_asj.asj03 = tm.asj03
   LET l_asj.asj04 = tm.asj04
   LET l_asj.asj05 = tm.asj05
   SELECT asa02 INTO l_asj.asj06 FROM asa_file
    WHERE asa01 = l_asj.asj05 AND asa04 = 'Y'
   SELECT asg05 INTO l_asj.asj07 FROM asg_file
    WHERE asg01 = l_asj.asj06
   LET l_asj.asj08  = '4'    #结转
   #No.TQC-C90057  --Begin
   #LET l_asj.asj09 = ' ' 
   LET l_asj.asj09 = 'N' 
   #No.TQC-C90057  --End  
   LET l_asj.asj10 = ' '
   LET l_asj.asj11 = 0  #单身产生后回写
   LET l_asj.asj12 = 0  #单身产生后回写
   LET l_asj.asj13 = ' '
   LET l_asj.asj14 = ' '
   LET l_asj.asj15 = ' '
    LET l_asj.asj16 = ' '
    LET l_asj.asj17 = ' '
    LET l_asj.asj18 = ' '
    LET l_asj.asj19 = ' '
    LET l_asj.asj20 = ' '
   LET l_asj.asjconf = 'Y'
   LET l_asj.asjuser = g_user
   LET l_asj.asjgrup = g_grup
   LET l_asj.asjmodu =  g_user
   LET l_asj.asjdate = g_today
   LET l_asj.asj21 = '00'
   LET l_asj.asjlegal = g_legal   #所属法人
   LET l_asj.asjoriu =  g_grup 
   LET l_asj.asjorig =  g_grup
   LET l_asj.asj081 = ' ' 
   LET l_asj.asjlegal = g_legal

   #FUN-B80135--add--str--
      IF l_asj.asj03 <g_year OR (l_asj.asj03=g_year AND l_asj.asj04<=g_month) THEN 
         LET g_showmsg=l_asj.asj03,"/",l_asj.asj04
         CALL s_errmsg('asj03,asj04',g_showmsg,'','atp-164',1)
      END IF 
   #FUN-B80135--add--end
   
   INSERT INTO asj_file VALUES(l_asj.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('asj_file','insert',l_asj.asj01,SQLCA.sqlcode,1)    
      LET g_success = 'N'
   END IF  

   ###step2  依科目insert ask_file  
   LET g_sql = "SELECT UNIQUE ask03,ask05 FROM asj_file,ask_file,aag_file ",
               " WHERE asj00 = ask00 AND asj01 = ask01 ",
               "   AND ask03 = aag01 AND aag00 = ask00 AND aag04 = '2' ", #损益
               "   AND aag03 = '2' AND aag07<>'1' AND aag09 = 'Y'",           
               "   AND asj03 = '",tm.asj03,"'",
               "   AND asj04 = '",tm.asj04,"'",
               "   AND asj05 = '",tm.asj05,"'",
               "   AND asj08 IN ('2','3') ",   #冲销&会计师调整
               "   AND asjconf = 'Y'",   #FUN-B60134
               " GROUP BY ask03,ask05",
               " ORDER BY ask03,ask05"
   PREPARE sel_pre FROM g_sql
   DECLARE sel_pre_cur CURSOR FOR sel_pre
   FOREACH sel_pre_cur INTO l_ask03,l_ask05
      IF STATUS THEN 
      END IF 
      LET l_ask.ask00 = l_asj.asj00
      LET l_ask.ask01 = l_asj.asj01
      LET l_ask.ask05 = l_ask05
      SELECT max(ask02) INTO l_ask.ask02 FROM ask_file
       WHERE ask00 = l_asj.asj00 AND ask01 = l_ask.ask01
      IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 = 0 END IF
      LET l_ask.ask02 = l_ask.ask02 + 1
      LET l_ask.ask03 = l_ask03
      ###科目借方金额
      SELECT SUM(ask07) INTO l_sum_d FROM asj_file,ask_file
       WHERE asj00 = ask00 AND asj01 = ask01 
         AND asj08 IN ('2','3')
         AND asj03 = tm.asj03  #年度
         AND asj04 = tm.asj04  #期别
         AND asj05 = tm.asj05  #族群
         AND ask03 = l_ask03  #科目         
         AND ask05 = l_ask05  #关系人
         AND ask06 = '1'   #借
      IF cl_null(l_sum_d) THEN LET l_sum_d = 0 END IF    
      ###科目贷方金额
      SELECT SUM(ask07) INTO l_sum_c FROM asj_file,ask_file
       WHERE asj00 = ask00 AND asj01 = ask01 
         AND asj08 IN ('2','3')
         AND asj03 = tm.asj03  #年度
         AND asj04 = tm.asj04  #期别
         AND asj05 = tm.asj05  #族群
         AND ask03 = l_ask03  #科目         
         AND ask05 = l_ask05  #关系人
         AND ask06 = '2'   #贷 
      IF cl_null(l_sum_c) THEN LET l_sum_c = 0 END IF    
      SELECT aag06 INTO l_aag06 FROM aag_file WHERE aag00 = l_ask.ask00
        AND aag01 = l_ask.ask03
      IF l_aag06 = '1' THEN   #余额在借方
         LET l_ask.ask07 = l_sum_d-l_sum_c 
         LET l_ask.ask06 = '2'           
      ELSE   #余额在贷方
         LET l_ask.ask07 = l_sum_c-l_sum_d
         LET l_ask.ask06 = '1'
      END IF   
      LET l_ask.ask08= ' '
      LET l_ask.ask09= ' '
      LET l_ask.ask09= ' '
      LET l_ask.ask10= ' '
      LET l_ask.ask11= ' '
      LET l_ask.ask12= ' '
      LET l_ask.asklegal=g_legal    #所属法人
      INSERT INTO ask_file VALUES(l_ask.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END FOREACH
   
   ###step 3 调整差异计入asz06
   #差额计入asz06
   SELECT SUM(ask07) INTO l_asj11 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '1'   #借方
   SELECT SUM(ask07) INTO l_asj12 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '2'   #贷方
   IF cl_null(l_asj11) THEN LET l_asj11 = 0 END IF 
   IF cl_null(l_asj12) THEN LET l_asj12 = 0 END IF   
   IF l_asj11 = l_asj12 THEN  #借方=贷方则没有差异
   ELSE 
      #SELECT asz04 INTO l_ask.ask03 FROM asz_file WHERE asz00 = '0'   #FUN-B90045
      SELECT asz06 INTO l_ask.ask03 FROM asz_file WHERE asz00 = '0'    #FUN-B90045
      IF l_asj11>l_asj12 THEN   #借方>贷方则差异放在贷方 
         LET l_ask.ask06 = '2'
         LET l_ask.ask07 = l_asj11-l_asj12
      ELSE
         LET l_ask.ask06 = '1'
         LET l_ask.ask07 = l_asj12-l_asj11
      END IF 
      SELECT MAX(ask02) INTO l_ask.ask02 FROM ask_file 
       WHERE ask00 = l_asj.asj00 AND ask01 = l_asj.asj01
      IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 = 0 END IF
      LET l_ask.ask02 = l_ask.ask02+1
      #luttb--101213--mod--str--
      #LET l_ask.ask05 = ' '  
      SELECT asa02 INTO l_ask.ask05 FROM asa_file 
       WHERE asa01 = tm.asj05 AND asa04 = 'Y'
      #lutbt--101213--mod--end
      LET l_ask.asklegal = g_legal
      INSERT INTO ask_file VALUES(l_ask.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF 
   
   ####step 4 UPDATE 单头
   #UPDATE asj_file 借方总金额 贷方总金额 
   LET l_asj11 = 0 LET l_asj12 = 0
   SELECT SUM(ask07) INTO l_asj11 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '1'   #借方
   SELECT SUM(ask07) INTO l_asj12 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '2'   #贷方
   IF cl_null(l_asj11) THEN LET l_asj11 = 0 END IF 
   IF cl_null(l_asj12) THEN LET l_asj12 = 0 END IF 
   UPDATE asj_file SET asj11 = l_asj11,
                       asj12 = l_asj12
    WHERE asj00 = l_asj.asj00
      AND asj01 = l_asj.asj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('asj_file','update',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF    
END FUNCTION

FUNCTION p011_aac01(p_t1)
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
