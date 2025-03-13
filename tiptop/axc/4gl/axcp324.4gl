# Prog. Version..: '5.30.06-13.03.29(00010)'     #
#
# Pattern name...: axcp324.4gl
# Descriptions...: 杂项进出分录底稿整批生成作业
# Date & Author..: 10/07/08 By wujie #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B70020 11/07/04 By wujie    cdl08取值改为先抓axci101，为空再抓理由码
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 分錄底稿根據幣種取位
# Modify.........: No:FUN-BB0038 11/11/10 By elva 成本改善
# Modify.........: No:MOD-C20151 12/02/16 By yinhy 雜收發為0的也應該產生到cdl_file中
# Modify.........: No:FUN-C90002 12/09/04 By minpp 成本类型给默认值ccz28
# Modify.........: No:MOD-CB0056 12/11/09 By Elise g_cdl.cdl10修改為l_cdl10
# Modify.........: No.MOD-CC0001 12/12/03 By wujie 金额小数位数用ccz26截位
# Modify.........: No.FUN-CC0153 13/01/23 By wujie 增加cdl14项目编号cdl15WBS编号
# Modify.........: No:MOD-D50111 13/05/14 By suncx 根據部門和理由碼未取到科目需要報錯提醒
# Modify.........: No.MOD-D50123 13/05/15 By wujie tlf排除非成本仓的
# Modify.........: No:MOD-D50133 13/05/15 By suncx 參數設置存貨科目取自料件分群碼檔時，應該根據ima06去imz39，而不是根據ima12
# Modify.........: No.MOD-DB0128 13/11/19 By suncx 存在已審核cdl_file資料，提示已審核，不可重新產生
# Modify.........: No:FUN-D80089 13/12/12 By fengmy 加入部门所属成本中心的判断

DATABASE ds   

GLOBALS "../../config/top.global"

#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE g_cdl               RECORD LIKE cdl_file.*
DEFINE g_wc                STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1
DEFINE tm                  RECORD 
                           tlfctype    LIKE tlfc_file.tlfctype,
                           yy          LIKE type_file.num5,
                           mm          LIKE type_file.num5,
                           b           LIKE aaa_file.aaa01
                           END RECORD 
#主程式開始
DEFINE g_flag              LIKE type_file.chr1
DEFINE l_flag              LIKE type_file.chr1
DEFINE g_change_lang       LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
    
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_time = TIME   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p324_tm()
         IF cl_sure(18,20) THEN 
            CALL p324_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p324_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p324_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p324_w
      ELSE
         CALL p324_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p324_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p324_w AT p_row,p_col WITH FORM "axc/42f/axcp324" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR '' 
   #carrier 20130618  --Begin
   #SELECT sma51,sma52 INTO tm.yy,tm.mm FROM sma_file    
   LET tm.yy = g_ccz.ccz01
   LET tm.mm = g_ccz.ccz02
   LET tm.b  = g_ccz.ccz12
   DISPLAY BY NAME tm.tlfctype,tm.yy,tm.mm,tm.b
   #carrier 20130618  --End  
   LET g_bgjob = 'N'   
   INPUT BY NAME
      tm.tlfctype,tm.yy,tm.mm,tm.b      
      WITHOUT DEFAULTS 
     
      
      BEFORE INPUT                        #FUN-C90002
         LET tm.tlfctype = g_ccz.ccz28    #FUN-C90002 
      AFTER FIELD b
         IF tm.b IS NULL THEN
            NEXT FIELD b
         END IF

      AFTER FIELD tlfctype
         IF tm.tlfctype NOT MATCHES '[12345]' THEN 
            LET tm.tlfctype =NULL 
            NEXT FIELD tlfctype
         END IF  
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p324_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
         IF cl_null(tm.tlfctype)THEN 
         NEXT FIELD tlfctype 
         END IF  
         IF cl_null(tm.yy) THEN
            NEXT FIELD yy 
         END IF  
         IF cl_null(tm.mm) THEN
            NEXT FIELD mm 
         END IF 
         IF cl_null(tm.b) THEN
            NEXT FIELD b 
         END IF 

 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
      ON ACTION qbe_save
           CALL cl_qbe_save()
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
         END CASE
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p324_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

END FUNCTION

FUNCTION p324_p()
   
   BEGIN WORK 
   CALL p324_chk()
   IF g_flag ='N' THEN ROLLBACK WORK RETURN END IF 
   CALL p324_ins_cdl()
   
   #add by cathree 20201216  重新取价
   IF g_success = 'Y' THEN
      CALL p324_get_new()
   END IF
   
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
   LET g_prog = 'axct324' #add by cathree 20201227
   CALL p324_gl_1(tm.*)
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
   LET g_prog = 'axcp324' #add by cathree 20201227
END FUNCTION 

FUNCTION p324_ins_cdl()
DEFINE l_cdllegal LIKE cdl_file.cdllegal
DEFINE l_cdl05    LIKE cdl_file.cdl05
DEFINE l_cdl06    LIKE cdl_file.cdl06
DEFINE l_cdl07    LIKE cdl_file.cdl07 
DEFINE l_cdl10    LIKE cdl_file.cdl10
DEFINE l_cdl13    LIKE cdl_file.cdl13
DEFINE l_sql      STRING 
DEFINE l_ccz12    LIKE ccz_file.ccz12 
DEFINE l_ccz07    LIKE ccz_file.ccz07
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag07    LIKE aag_file.aag07
#No.FUN-CC0153 --begin
DEFINE l_cdl14    LIKE cdl_file.cdl14
DEFINE l_cdl15    LIKE cdl_file.cdl15
#No.FUN-CC0153 --end
DEFINE l_msg      STRING              #No.MOD-D50111 add


 # LET l_sql ="SELECT tlfclegal,tlfccost,tlf01,tlf14,tlf19,SUM(tlfc907*(tlfc221+tlfc2231+tlfc2232+tlfc224+tlfc2241+tlfc2242+tlfc2243)) ",
   LET l_sql ="SELECT tlfclegal,tlfccost,tlf01,tlf14,tlf19,tlf20,tlf41,SUM(tlfc907*tlfc21)",    #No.FUN-CC0153 add tlf20,tlf41   
              "  FROM tlf_file,tlfc_file  ",
              " WHERE tlfctype = '",tm.tlfctype,"'",
              "   AND tlfc01 = tlf01 ",
              "   AND tlfc06 = tlf06 ",
              "   AND tlfc02 = tlf02 ",
              "   AND tlfc03 = tlf03 ",
              "   AND tlfc13 = tlf13 ",
              "   AND tlfc902 = tlf902 ",
              "   AND tlfc903 = tlf903 ",
              "   AND tlfc904 = tlf904 ",
              "   AND tlfc905 = tlf905 ",
              "   AND tlfc906 = tlf906 ",
              "   AND tlfc907 = tlf907 ",
              "   AND YEAR(tlf06)  = '",tm.yy,"'",
              "   AND MONTH(tlf06) = '",tm.mm,"'",
              "   AND (tlf13 ='aimt301' OR tlf13 ='aimt311' ",
              "         OR tlf13 ='aimt302' OR tlf13 ='aimt312' ",
              "         OR tlf13 ='aimt303' OR tlf13 ='aimt313' ",
              "         OR tlf13 ='atmt260' OR tlf13 ='atmt261') ",
              "   AND tlf902 not in (select jce02 from jce_file)",    #No.MOD-D50123
              " GROUP BY tlfclegal,tlfccost,tlf01,tlf14,tlf19,tlf20,tlf41 ",  #No.FUN-CC0153 add tlf20,tlf41
              " ORDER BY tlfclegal,tlfccost,tlf01,tlf14,tlf19,tlf20,tlf41 "   #No.FUN-CC0153 add tlf20,tlf41
   
   PREPARE p324_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   CALL s_showmsg_init()    #MOD-D50111 add
   DECLARE p324_c1 CURSOR FOR p324_p1
   FOREACH p324_c1 INTO l_cdllegal,l_cdl13,l_cdl07,l_cdl06,l_cdl05,l_cdl14,l_cdl15,l_cdl10     #No.FUN-CC0153 add cdl14,cdl15
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdl.* TO NULL
      LET g_cdl.cdl01 = tm.b
      LET g_cdl.cdl02 = tm.yy
      LET g_cdl.cdl03 = tm.mm
      LET g_cdl.cdl04 = tm.tlfctype
      LET g_cdl.cdl05 = l_cdl05
      LET g_cdl.cdl06 = l_cdl06
      LET g_cdl.cdl07 = l_cdl07 
      IF g_cdl.cdl05 IS NULL THEN LET g_cdl.cdl05 = ' ' END IF   #MOD-D50111 add 
#No.MOD-B70020 --begin
     #IF g_cdl.cdl10 >= 0 THEN    #MOD-CB0056 mark
      IF l_cdl10 >= 0 THEN        #MOD-CB0056
        #SELECT cxi04 INTO g_cdl.cdl08 FROM cxi_file WHERE cxi01 = g_cdl.cdl05 AND cxi02 = g_cdl.cdl06 AND cxi03 IN ('1','3')
         SELECT cxi04,cxi05 INTO g_cdl.cdl08,g_cdl.cdl16 FROM cxi_file WHERE cxi01 = g_cdl.cdl05 AND cxi02 = g_cdl.cdl06 AND cxi03 IN ('1','3')   #FUN-D80089 add cxi05,g_cdl.cdl16
      ELSE 
        #SELECT cxi04 INTO g_cdl.cdl08 FROM cxi_file WHERE cxi01 = g_cdl.cdl05 AND cxi02 = g_cdl.cdl06 AND cxi03 IN ('2','3')
         SELECT cxi04,cxi05 INTO g_cdl.cdl08,g_cdl.cdl16 FROM cxi_file WHERE cxi01 = g_cdl.cdl05 AND cxi02 = g_cdl.cdl06 AND cxi03 IN ('2','3')   #FUN-D80089 add cxi05,g_cdl.cdl16
      END IF 
      #FUN-D80089--add--str--
      IF cl_null(g_cdl.cdl16) THEN
         LET g_cdl.cdl16 = l_cdl05
      END IF
      #FUN-D80089--add--end--
      IF cl_null(g_cdl.cdl08) THEN 
         SELECT azf07 INTO g_cdl.cdl08 FROM azf_file WHERE azf01 = g_cdl.cdl06 AND azf02 ='2' 
      END IF 
#No.MOD-B70020 --end
#No.MOD-D50111 add begin-------------------
      IF g_dbs='flymn3' THEN LET g_cdl.cdl05='660401' END IF    #add by lifang 200705
      IF cl_null(g_cdl.cdl08) THEN
         IF NOT cl_null(g_cdl.cdl05) THEN
            LET l_msg = g_cdl.cdl05,"|",g_cdl.cdl06
            CALL s_errmsg('cdl05,cdl06',l_msg,'','axc-991',1)
         ELSE 
            CALL s_errmsg('cdl06',g_cdl.cdl06,'','axc-993',1)
         END IF 
         LET g_success ='N'
         CONTINUE FOREACH
      END IF 
#No.MOD-D50111 add end---------------------  
      SELECT ccz07,ccz12 INTO l_ccz07,l_ccz12 FROM ccz_file 
      #FUN-BB0038 --begin
      IF g_cdl.cdl01 = l_ccz12 THEN 
         IF l_ccz07 = '2' THEN 
               SELECT imz39 INTO g_cdl.cdl09
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdl.cdl07
                 #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima39 INTO g_cdl.cdl09
                 FROM ima_file
                WHERE ima01 = g_cdl.cdl07
         END IF  
      ELSE
         IF l_ccz07 = '2' THEN 
               SELECT imz391 INTO g_cdl.cdl09
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdl.cdl07
                 #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima391 INTO g_cdl.cdl09
                 FROM ima_file
                WHERE ima01 = g_cdl.cdl07
         END IF  
      END IF  
      #IF g_cdl.cdl01 = l_ccz12 THEN
      #   CASE WHEN g_ccz.ccz07='1' SELECT ima39 INTO g_cdl.cdl09 FROM ima_file
      #                              WHERE ima01=g_cdl.cdl07
      #        WHEN g_ccz.ccz07='2' SELECT imz39 INTO g_cdl.cdl09 FROM ima_file,imz_file
      #                              WHERE ima01=g_cdl.cdl07 AND ima12=imz01 
      #        WHEN g_ccz.ccz07='3' SELECT imd08 INTO g_cdl.cdl09 FROM imd_file
      #                              WHERE imd01=l_tlf031
      #        WHEN g_ccz.ccz07='4' SELECT ime09 INTO g_cdl.cdl09 FROM ime_file
      #                              WHERE ime01=l_tlf031 AND ime02=l_tlf032
      #   END CASE
      #ELSE
      #   CASE WHEN g_ccz.ccz07='1' SELECT ima391 INTO g_cdl.cdl09 FROM ima_file
      #                              WHERE ima01=g_cdl.cdl07
      #        WHEN g_ccz.ccz07='2' SELECT imz391 INTO g_cdl.cdl09 FROM ima_file,imz_file
      #                              WHERE ima01=g_cdl.cdl07 AND ima12=imz01 
      #        WHEN g_ccz.ccz07='3' SELECT imd081 INTO g_cdl.cdl09 FROM imd_file
      #                              WHERE imd01=l_tlf031
      #        WHEN g_ccz.ccz07='4' SELECT ime091 INTO g_cdl.cdl09 FROM ime_file
      #                              WHERE ime01=l_tlf031 AND ime02=l_tlf032
      #   END CASE
      #END IF
      #FUN-BB0038 --end
      SELECT aag03,aag07 INTO l_aag03,l_aag07 FROM aag_file WHERE aag00 = g_cdl.cdl01 AND aag01 = g_cdl.cdl09   
      IF l_aag07 NOT MATCHES '[23]' THEN  LET g_cdl.cdl09 = NULL END IF 
      IF l_aag03 <> '2' THEN LET g_cdl.cdl09 = NULL END IF
      LET g_cdl.cdl10 = l_cdl10  
      IF cl_null(g_cdl.cdl10) THEN 
         LET g_cdl.cdl10 =0
      END IF    
      LET g_cdl.cdl10 = cl_digcut(g_cdl.cdl10,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      #No.MOD-C20151  --Begin
      #IF g_cdl.cdl10 = 0 THEN  
      #   CONTINUE FOREACH  
      #END IF  
      #No.MOD-C20151  --End
      LET g_cdl.cdllegal = l_cdllegal
      LET g_cdl.cdl13 = l_cdl13  
      LET g_cdl.cdlconf ='N' 
      LET g_cdl.cdlconf1 ='N'
#No.FUN-CC0153 --begin
      LET g_cdl.cdl14 = l_cdl14
      LET g_cdl.cdl15 = l_cdl15
      IF g_cdl.cdl14 IS NULL THEN LET g_cdl.cdl14 = ' '  END IF
      IF g_cdl.cdl15 IS NULL THEN LET g_cdl.cdl15 = ' '  END IF
#No.FUN-CC0163 --end
      INSERT INTO cdl_file VALUES(g_cdl.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdl',SQLCA.sqlcode,1)
         LET g_success ='N'
         EXIT FOREACH 
      END IF     
      
      #add by cathree 20201216 #保存一下旧值
      INSERT INTO tc_cdl_file VALUES(g_cdl.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins tc_cdl',SQLCA.sqlcode,1)
         LET g_success ='N'
         EXIT FOREACH 
      END IF 
       
   END FOREACH 
   IF g_success ='N' THEN   #MOD-D50111 add
      CALL s_showmsg()      #MOD-D50111 add
   END IF                   #MOD-D50111 add
END FUNCTION 


FUNCTION p324_chk()
DEFINE l_wc        STRING
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cdlconf   LIKE cdl_file.cdlconf  #MOD-DB0128
   
   LET l_sql = "SELECT count(*) ",
               "  FROM cdl_file ",
               " WHERE cdl01 ='",tm.b CLIPPED,"'",
               "   AND cdl02 = '",tm.yy CLIPPED,"'",
               "   AND cdl03 = '",tm.mm CLIPPED,"'", 
               "   AND cdl04 = '",tm.tlfctype CLIPPED,"'"

   PREPARE p324_p6 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p324_c6 CURSOR FOR p324_p6

#MOD-DB0128 add begin-------------------------
   LET l_sql = "SELECT UNIQUE cdlconf ",
               "  FROM cdl_file ",
               " WHERE cdl01 ='",tm.b CLIPPED,"'",
               "   AND cdl02 = '",tm.yy CLIPPED,"'",
               "   AND cdl03 = '",tm.mm CLIPPED,"'",
               "   AND cdl04 = '",tm.tlfctype CLIPPED,"'"

   PREPARE p324_p9 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
#MOD-DB0128 add end---------------------------

   LET l_sql = "DELETE ",
               "  FROM cdl_file ",
               " WHERE cdl01 ='",tm.b CLIPPED,"'",
               "   AND cdl02 = '",tm.yy CLIPPED,"'",
               "   AND cdl03 = '",tm.mm CLIPPED,"'", 
               "   AND cdl04 = '",tm.tlfctype CLIPPED,"'"


   PREPARE p324_p7 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   
   #add by cathree 20201216
   LET l_sql = "DELETE ",
               "  FROM tc_cdl_file ",
               " WHERE tc_cdl01 ='",tm.b CLIPPED,"'",
               "   AND tc_cdl02 = '",tm.yy CLIPPED,"'",
               "   AND tc_cdl03 = '",tm.mm CLIPPED,"'", 
               "   AND tc_cdl04 = '",tm.tlfctype CLIPPED,"'"


   PREPARE p324_p71 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   OPEN p324_c6 
   FETCH p324_c6 INTO l_cnt
   IF l_cnt >0 THEN 
     #MOD-DB0128 add sta---------------
      EXECUTE p324_p9 INTO l_cdlconf
      IF l_cdlconf='Y' THEN
         CALL cl_err('','afa-364',1)
         LET g_flag='N'
      ELSE
     #MOD-DB0128 add end---------------
         IF cl_confirm('mfg8002') THEN 
            LET g_flag ='Y'
         ELSE 
            LET g_flag ='N'
         END IF 
      END IF   #MOD-DB0128 add
   ELSE 
         LET g_flag ='Y'
   END IF 
   IF g_flag ='Y' THEN 
      EXECUTE p324_p7    
      EXECUTE p324_p71  #add by cathree 20201216
   END IF 
   CLOSE p324_c6
END FUNCTION 

#add by cathree 20201216 重新取价
FUNCTION p324_get_new()
DEFINE l_sql         STRING

CREATE TEMP TABLE p324_tmp(
        cdl01            LIKE cdl_file.cdl01,
        cdl02            LIKE cdl_file.cdl02,
        cdl03            LIKE cdl_file.cdl03,
        cdl04            LIKE cdl_file.cdl04,
        cdl05            LIKE cdl_file.cdl05,
        cdl06            LIKE cdl_file.cdl06,
        cdl07            LIKE cdl_file.cdl07,
        cdl10            LIKE cdl_file.cdl10,
        tlf907           LIKE tlf_file.tlf907,
        tlf905           LIKE tlf_file.tlf905,
        tlf906           LIKE tlf_file.tlf906,
        tlf10            LIKE tlf_file.tlf10,
        tlf902           LIKE tlf_file.tlf902,
        dj               LIKE cdl_file.cdl10,
        lb               LIKE type_file.chr10)
   
   LET g_success = 'Y'
   #根据cdl抓取对应的杂收发单+项次+数量+出库/入库+仓库
   LET l_sql = " SELECT cdl01,cdl02,cdl03,cdl04,cdl05,cdl06,cdl07,cdl10,tlf907,tlf905,tlf906,(tlf10*tlf60) tlf10,tlf902,0.000000 dj,'10' lb",
               "   FROM cdl_file ",
               "   LEFT JOIN (SELECT tlf907,tlf905,tlf906,tlf10,tlf902,tlf19,tlf14,tlf13,tlf06,tlf07,tlfccost,tlf01,tlf60 ",  #关联tflc表会少抓到资料，先去掉
               "                FROM tlf_file ",
               "                LEFT JOIN tlfc_file ON tlfc01 = tlf01  AND tlfc06 = tlf06 AND tlfc02 = tlf02  AND tlfc03 = tlf03 AND tlfc13 = tlf13 ",
               "                                   AND tlfc902= tlf902 AND tlfc903= tlf903 AND tlfc904= tlf904 AND tlfc907= tlf907 AND tlfc905= tlf905 ",
               "                                   AND tlfc906= tlf906 AND tlfclegal = tlflegal) ON tlf01 = cdl07 AND YEAR(tlf06) = cdl02 AND MONTH(tlf06) =  cdl03 ",
               "                                                                                AND tlfccost = cdl13 AND tlf14 = cdl06 AND tlf19 = cdl05 ",
               #"   LEFT JOIN (SELECT tlf907,tlf905,tlf906,tlf10,tlf902,tlf19,tlf14,tlf13,tlf06,tlf07,tlf01 ",
               #"                FROM tlf_file ) ON tlf01 = cdl07 AND YEAR(tlf06) = cdl02 AND MONTH(tlf06) =  cdl03 AND tlf14 = cdl06 AND tlf19 = cdl05 ",
               "  WHERE cdl01 = '",tm.b,"' AND cdl02 = ",tm.yy," AND cdl03 = ",tm.mm," AND cdl04 = '",tm.tlfctype,"' ",
               "    AND (tlf13='aimt301' or tlf13='aimt311' OR  tlf13='aimt302' or tlf13='aimt312' OR  tlf13='aimt303' or tlf13='aimt313') AND tlf902 NOT IN (SELECT jce02 FROM jce_file) "
   LET l_sql = " INSERT INTO p324_tmp ",l_sql
   PREPARE p324_ins_tmp FROM l_sql 
   EXECUTE p324_ins_tmp
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err('ins tmp',SQLCA.sqlcode,1)
      LET g_success ='N'
      RETURN
   END IF 
   
   #带“."料号的杂入/出单位成本 cxcq901_file
   #1、筛选INSTR(tlf01, '.')>1  and tlf021(仓库）<>XBC and  tlf021(仓库）<>P002 的料件，901单位成本=杂入金额ta_ccc22a4/杂入数量ta_ccc214
   #   SELECT ta_ccc01,'1',ta_ccc22a4/ta_ccc214 FROM cxcq901_file WHERE ta_ccc02 = 2020 AND ta_ccc03 = 10 AND ta_ccc214 <> 0
   #   筛选INSTR(tlf01, '.')>1  and tlf021(仓库）<>XBC and  tlf021(仓库）<>P002 的料件，901单位成本=杂发金额ta_ccc42/杂发数量ta_ccc41
   #   SELECT ta_ccc01,'2',ta_ccc42/ta_ccc41 FROM cxcq901_file WHERE ta_ccc02 = 2020 AND ta_ccc03 = 10 AND ta_ccc41 <> 0
   #2、筛选INSTR(tlf01, '.')>1  and tlf021(仓库）in (XBC,P002) 的料件，902单位成本=WIP杂收金额zsje/WIP杂收数量ta_ccc217 就是ta_ccp_file中的ta_cccud07  存在数量为0的情况（只调金额）
   #   筛选INSTR(tlf01, '.')>1  and tlf021(仓库）in (XBC,P002) 的料件，902单位成本=WIP杂发金额wzfje/WIP杂发数量ta_ccc81 就是ta_ccp_file中的ta_cccud07
   #   SELECT ta_ccc01,'3',ta_cccud07 FROM ta_ccp_file WHERE ta_ccc02 = 2020 AND ta_ccc03 = 10 AND ta_cccud07 <> 0 AND INSTR(ta_ccc01, '.') > 1
   #3、以上均未抓取到，则赋值0
   UPDATE p324_tmp SET lb = '1' WHERE INSTR(cdl07, '.')>1 AND tlf902 <> 'XBC' AND tlf902 <> 'P002' AND tlf907 = 1
   UPDATE p324_tmp SET lb = '2' WHERE INSTR(cdl07, '.')>1 AND tlf902 <> 'XBC' AND tlf902 <> 'P002' AND tlf907 = -1
   UPDATE p324_tmp SET lb = '3' WHERE INSTR(cdl07, '.')>1 AND tlf902 IN ('XBC','P002') AND tlf907 = 1
   UPDATE p324_tmp SET lb = '31' WHERE INSTR(cdl07, '.')>1 AND tlf902 IN ('XBC','P002') AND tlf907 = -1 #存在数量为0的情况（只调金额）所以还是要分开算
   
   #带“-"料号的杂入/出单位成本
   #1、INSTR(tlf01, '-')>1 的料件，910单位成本=sum（展算金额zsje/ 异动数量zxl ）where cxcq910_file.lx=杂收
   #   INSTR(tlf01, '-')>1 的料件，910单位成本=sum（展算金额zsje/ 异动数量zxl ）where cxcq910_file.lx=杂发
   #   SELECT tlf01,(CASE lx WHEN '杂收' THEN '4' ELSE '5' END) lx,SUM(zsje/zsl) FROM cxcq910_file WHERE yy = 2020 AND mm = 10 AND INSTR(tlf01, '-')>1 AND zsl <> 0 GROUP BY tlf01,lx
   #2、以上未抓取到，则赋值0
   UPDATE p324_tmp SET lb = '4' WHERE INSTR(cdl07, '-')>1 AND tlf907 = 1
   UPDATE p324_tmp SET lb = '5' WHERE INSTR(cdl07, '-')>1 AND tlf907 = -1
   
   #不带“."、不带“-"料号杂入/出单位成本
   #1、筛选不带“."、不带“-"料号，并且tlf021(仓库）<>XBC and  tlf021(仓库）<>P002，906单位成本=杂入金额zrje/杂入ta_ccc214
   #   筛选不带“."、不带“-"料号，并且tlf021(仓库）<>XBC and  tlf021(仓库）<>P002，906单位成本=杂发金额zfje/杂发ta_ccc41
   #2、筛选不带“."、不带“-"料号， tlf021(仓库）in (XBC,P002)，905单位成本=WIP杂收金额ta_ccc217a/WIP杂收ta_ccc217
   #   筛选不带“."、不带“-"料号， tlf021(仓库）in (XBC,P002)，905单位成本=WIP杂发金额ta_ccc81a/WIP杂发ta_ccc81
   #3、以上均未抓取到，则赋值0
   UPDATE p324_tmp SET lb = '6' WHERE INSTR(cdl07, '-')=0 AND INSTR(cdl07, '.')=0 AND tlf902 <> 'XBC' AND tlf902 <> 'P002' AND tlf907 = 1
   UPDATE p324_tmp SET lb = '7' WHERE INSTR(cdl07, '-')=0 AND INSTR(cdl07, '.')=0 AND tlf902 <> 'XBC' AND tlf902 <> 'P002' AND tlf907 = -1
   UPDATE p324_tmp SET lb = '8' WHERE INSTR(cdl07, '-')=0 AND INSTR(cdl07, '.')=0 AND tlf902 IN ('XBC','P002') AND tlf907 = 1
   UPDATE p324_tmp SET lb = '9' WHERE INSTR(cdl07, '-')=0 AND INSTR(cdl07, '.')=0 AND tlf902 IN ('XBC','P002') AND tlf907 = -1
      
   #更新单价单价
   LET l_sql = "  MERGE INTO p324_tmp o ",
               "  USING ( SELECT ta_ccc01 a,'1' lb,ta_ccc22a4/ta_ccc214 dj FROM cxcq901_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND ta_ccc214 <> 0 UNION ALL ",
               "          SELECT ta_ccc01,'2',ta_ccc42/ta_ccc41 FROM cxcq901_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND ta_ccc41 <> 0 UNION ALL ",
               #只调整金额，没有异动数量的时候，单价为0，有异动数量的时候，根据总金额/数量重新算一下单价
               "          SELECT ta_ccc01,'3',ta_cccud07 FROM ta_ccp_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND ta_cccud07 <> 0 AND INSTR(ta_ccc01, '.') > 1 AND ta_ccc217 <> 0 UNION ALL ",  #增加AND ta_ccc217 <> 0 数量为0的时候，单价也给0
               "          SELECT ta_ccc01,'31',ta_cccud07 FROM ta_ccp_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND ta_cccud07 <> 0 AND INSTR(ta_ccc01, '.') > 1 AND ta_ccc81 <> 0 UNION ALL ",  #增加AND ta_ccc81 <> 0 数量为0的时候，单价也给0
               #4、5抓取cxcp910的情况中，只抓金额，单价根据杂收/发，分别用金额/sum(数量计算)
               "          SELECT tlf01,(CASE lx WHEN '杂收' THEN '4' ELSE '5' END) lx,SUM(zsje) FROM cxcq910_file WHERE yy = ",tm.yy," AND mm = ",tm.mm," AND INSTR(tlf01, '-')>1 GROUP BY tlf01,lx UNION ALL ",
               "          SELECT ta_ccc01,'6',zrje/ta_ccc214 FROM cxcq906_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND INSTR(ta_ccc01, '-') = 0 AND INSTR(ta_ccc01, '.') = 0 AND ta_ccc214 <> 0 UNION ALL ",
               "          SELECT ta_ccc01,'7',zfje/ta_ccc41 FROM cxcq906_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND INSTR(ta_ccc01, '-') = 0 AND INSTR(ta_ccc01, '.') = 0 AND ta_ccc41 <> 0 UNION ALL ",
               "          SELECT ta_ccc01,'8',ta_ccc217a/ta_ccc217 FROM cxcq905_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND INSTR(ta_ccc01, '-') = 0 AND INSTR(ta_ccc01, '.') = 0 AND ta_ccc217 <> 0 UNION ALL ",
               "          SELECT ta_ccc01,'9',ta_ccc81a/ta_ccc81 FROM cxcq905_file WHERE ta_ccc02 = ",tm.yy," AND ta_ccc03 = ",tm.mm," AND INSTR(ta_ccc01, '-') = 0 AND INSTR(ta_ccc01, '.') = 0 AND ta_ccc81 <> 0 ) n ",
               "    ON (n.a = o.cdl07 AND n.lb = o.lb) ",
               "  WHEN MATCHED THEN ",
               #" UPDATE SET o.cdl10 = abs(n.dj) * o.tlf10 * o.tlf907 "  #因为单价可能取出负数，所以这里给一个正数
               " UPDATE SET o.dj = abs(n.dj) "  #只更新单价，这里更新金额会导致未取到单价的部分更新不到金额
   PREPARE p324_upd_tmp FROM l_sql 
   EXECUTE p324_upd_tmp
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err('upd tmp',SQLCA.sqlcode,1)
      LET g_success ='N'
      RETURN
   END IF 
   
   #金额=数量*单价
   LET l_sql = "  MERGE INTO p324_tmp o ",
               "  USING ( SELECT lb,cdl07,dj/SUM(tlf10) dj FROM p324_tmp WHERE lb IN ('4','5') GROUP BY lb,cdl07,dj ) n ",
               "    ON (n.cdl07 = o.cdl07 AND n.lb = o.lb) ",
               "  WHEN MATCHED THEN ",
               " UPDATE SET o.dj = abs(n.dj) "
   PREPARE p324_upd_tmp45 FROM l_sql 
   EXECUTE p324_upd_tmp45
   IF SQLCA.sqlcode THEN 
      CALL cl_err('upd tmp45',SQLCA.sqlcode,1)
      LET g_success ='N'
      RETURN
   END IF 
   
   #更新金额
   UPDATE p324_tmp SET cdl10 = dj * tlf10 * tlf907
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err('upd tmp je',SQLCA.sqlcode,1)
      LET g_success ='N'
      RETURN
   END IF 
   
   #汇总，并更新到cdl_file表
   LET l_sql = "  MERGE INTO cdl_file o ",
               "  USING (SELECT cdl01,cdl02,cdl03,cdl04,cdl05,cdl06,cdl07,SUM(cdl10) cdl10 FROM p324_tmp GROUP BY cdl01,cdl02,cdl03,cdl04,cdl05,cdl06,cdl07 ) n ",
               "     ON (o.cdl01 = n.cdl01 AND o.cdl02 = n.cdl02 AND o.cdl03 = n.cdl03 AND o.cdl04 = n.cdl04 AND o.cdl05 = n.cdl05 AND o.cdl06 = n.cdl06 AND o.cdl07 = n.cdl07) ",
               "   WHEN MATCHED THEN ",
               " UPDATE SET o.cdl10 = n.cdl10 WHERE cdl01 = '",tm.b,"' AND cdl02 = ",tm.yy," AND cdl03 = ",tm.mm," AND cdl04 = '",tm.tlfctype,"' "
   PREPARE p324_upd_cdl FROM l_sql 
   EXECUTE p324_upd_cdl
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      CALL cl_err('upd cdl',SQLCA.sqlcode,1)
      LET g_success ='N'
      RETURN
   END IF 
   
   DROP TABLE p324_tmp
END FUNCTION
