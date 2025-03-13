# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axcp321.4gl
# Descriptions...: 工单入库分录底稿整批生成作业
# Date & Author..: 10/07/07 By wujie #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 根据币种取位:369
# Modify.........: No:FUN-BB0038 11/11/08 By elva 成本改善
# Modify.........: No:MOD-C10125 12/01/13 By yinhy 科目cdh08，cdg09取反
# Modify.........: No:MOD-C70264 12/08/21 By yinhy 修正MOD-C10125
# Modify.........: No:MOD-C80017 12/08/21 By yinhy cdh08取不到時，依次再抓取azf14，ccz17
# Modify.........: No:FUN-C90002 12/09/04 By minpp 成本类型给默认值ccz28
# Modify.........: No:MOD-CB0110 12/11/12 By wujie 默认账套带ccz12,默认成本计算类型带ccz28，默认年月带ccz01，ccz02
# Modify.........: No:MOD-CB0205 12/12/03 By wujie b--->tm.b
# Modify.........: No.MOD-CC0001 12/12/03 By wujie 金额小数位数用ccz26截位
# Modify.........: No.FUN-CB0120 12/12/28 By wangrr 增加字段cdg13工單類型,判斷是否走委外加工,如果是抓取對應科目ccz44/ccz441
# Modify.........: No.MOD-D20061 13/02/07 By wujie ins_cgg()的where条件有错
# Modify.........: No.FUN-D20040 13/02/18 By wujie 增加插入cdg14
# Modify.........: No.MOD-D20160 13/02/26 By wujie select cdh插入cdi时要分类型
# Modify.........: No.MOD-D30149 13/02/07 By wujie ins_cdh()的where条件有错
# Modify.........: No.MOD-D40058 13/04/10 By wujie 修正委托加工物资科目取值问题
# Modify.........: No.MOD-D50130 13/05/15 By wujie chk()中sql变量用错  
# Modify.........: No:MOD-D50133 13/05/15 By suncx 參數設置存貨科目取自料件分群碼檔時，應該根據ima06去imz39，而不是根據ima12
# Modify.........: No.MOD-D70099 13/07/16 By wujie 增加cdg08为key
# Modify.........: No.MOD-DB0128 13/11/19 By suncx 存在已審核cdg_file資料，提示已審核，不可重新產生

DATABASE ds   

GLOBALS "../../config/top.global"

#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE g_cdg               RECORD LIKE cdg_file.*
DEFINE g_cdh               RECORD LIKE cdh_file.*
DEFINE g_cdi               RECORD LIKE cdi_file.*
DEFINE g_wc                STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1
DEFINE tm                  RECORD 
                           b    LIKE aaa_file.aaa01
                           END RECORD 
#主程式開始
DEFINE g_flag              LIKE type_file.chr1
DEFINE l_flag              LIKE type_file.chr1
DEFINE g_change_lang       LIKE type_file.chr1
DEFINE g_ccg06             LIKE ccg_file.ccg06        #FUN-C90002   #No.MOD-CB0110 ccg06 -->g_ccg06
#No.MOD-CB0110 --begin
DEFINE g_ccg02             LIKE ccg_file.ccg02
DEFINE g_ccg03             LIKE ccg_file.ccg03
#No.MOD-CB0110 --end

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
    
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #FUN-BB0038 --begin
   LET g_argv1 = ARG_VAL(1)
   IF g_argv1 IS NULL THEN LET g_argv1 = '1' END IF   #No.MOD-D70099
   IF g_argv1='2' THEN
      LET g_prog='axcp327'
   ELSE
      LET g_prog='axcp328'
      LET g_argv1 = '1'    #No.MOD-D20160
   END IF
   #FUN-BB0038 --end
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
         CALL p321_tm()
         IF cl_sure(18,20) THEN 
            CALL p321_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p321_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p321_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p321_w
      ELSE
         CALL p321_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p321_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p321_w AT p_row,p_col WITH FORM "axc/42f/axcp321" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR ''
   WHILE TRUE  
   CONSTRUCT BY NAME g_wc ON ccg06,ccg02,ccg03
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()

#No.MOD-CB0110 --begin
#          LET ccg06 = g_ccz.ccz28          #FUN-C90002
#          DISPLAY BY NAME ccg06            #FUN-C90002
          LET g_ccg06 = g_ccz.ccz28
          LET g_ccg02 = g_ccz.ccz01
          LET g_ccg03 = g_ccz.ccz02
          DISPLAY g_ccg06,g_ccg02,g_ccg03 TO  ccg06,ccg02,ccg03
#No.MOD-CB0110 --end
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
      ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
  
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
   END CONSTRUCT

   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   
      LET g_flag = 'N'
      RETURN
   END IF
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      CLOSE WINDOW p321_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF cl_null(g_wc) THEN
      LET g_wc = ' 1=1' 
   END IF 
 
 
   DISPLAY BY NAME tm.b
   
   LET g_bgjob = 'N'   
   INPUT BY NAME
      tm.b      
      WITHOUT DEFAULTS 
#No.MOD-CB0110 --begin
      BEFORE INPUT 
         LET tm.b = g_ccz.ccz12
         DISPLAY BY NAME tm.b    #No.MOD-CB0205
#No.MOD-CB0110 --end
 
      AFTER FIELD b
         IF tm.b IS NULL THEN
            NEXT FIELD b
         END IF
 
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p321_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
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
         END case
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p321_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   EXIT WHILE
END WHILE
END FUNCTION

FUNCTION p321_p()
   
   BEGIN WORK 
   CALL p321_chk()
   IF g_flag ='N' THEN ROLLBACK WORK RETURN END IF 
   CALL p321_ins_cdg()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p321_ins_cdi()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p321_gl(g_argv1,g_wc,tm.b) #FUN-BB0038 ADD g_argv1
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
END FUNCTION 

FUNCTION p321_ins_cdg()
DEFINE l_ccg01    LIKE ccg_file.ccg01
DEFINE l_ccg02    LIKE ccg_file.ccg02
DEFINE l_ccg03    LIKE ccg_file.ccg03
DEFINE l_ccg04    LIKE ccg_file.ccg04
DEFINE l_ccg06    LIKE ccg_file.ccg06
DEFINE l_ccg07    LIKE ccg_file.ccg07
DEFINE l_ccg31    LIKE ccg_file.ccg31 
DEFINE l_ccg32    LIKE ccg_file.ccg32
DEFINE l_ccg32a   LIKE ccg_file.ccg32a  
DEFINE l_ccg32b   LIKE ccg_file.ccg32b 
DEFINE l_ccg32c   LIKE ccg_file.ccg32c 
DEFINE l_ccg32d   LIKE ccg_file.ccg32d
DEFINE l_ccg32e   LIKE ccg_file.ccg32e
DEFINE l_ccg32f   LIKE ccg_file.ccg32f
DEFINE l_ccg32g   LIKE ccg_file.ccg32g
DEFINE l_ccg32h   LIKE ccg_file.ccg32h
DEFINE l_ima132   LIKE ima_file.ima132
DEFINE l_ima1321  LIKE ima_file.ima1321
DEFINE l_ccglegal LIKE ccg_file.ccglegal
DEFINE l_sql      STRING 
DEFINE l_ccz12    LIKE ccz_file.ccz12 
DEFINE l_ccz18    LIKE ccz_file.ccz18 #FUN-BB0038 
DEFINE l_ccz07    LIKE ccz_file.ccz07
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag07    LIKE aag_file.aag07
DEFINE l_aag43    LIKE aag_file.aag43  #No.FUN-D20040  
DEFINE l_wc1      STRING               #No.MOD-D70099

   #FUN-BB0038 --begin
   IF g_argv1='2' THEN
      LET l_sql ="SELECT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07,ccglegal,ccg41,ccg42,ccg42a,ccg42b,ccg42c,ccg42d,ccg42e,ccg42f,ccg42g,ccg42h ",
                 "  FROM ccg_file  ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND ccg42<>0 "   #No.MOD-D20061
#                 "   AND ccg42<0 "
   ELSE
      LET l_sql ="SELECT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07,ccglegal,ccg31,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e,ccg32f,ccg32g,ccg32h ",
                 "  FROM ccg_file  ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND ccg32<>0 "   #No.MOD-D20061
#                 "   AND ccg32<0 

#No.MOD-D70099 --begin
      LET l_wc1 = cl_replace_str(g_wc,'ccg','cce')
      LET l_sql =  l_sql ,"  AND ccg01 NOT IN (SELECT cce01 FROM cce_file ", 
                         "                     WHERE ",l_wc1 CLIPPED ,")"
      LET l_sql = l_sql ," UNION ALL ",
                 "SELECT cce01,cce02,cce03,cce04,cce06,cce07,ccelegal,-cce21,-cce22,-cce22a,-cce22b,-cce22c,-cce22d,-cce22e,-cce22f,-cce22g,-cce22h ",
                 "  FROM cce_file  ",
                 " WHERE ",l_wc1 CLIPPED,
                 "   AND cce22<>0 " 
#No.MOD-D70099 --end
   END IF
   #FUN-BB0038 --end
   PREPARE p321_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p321_c1 CURSOR FOR p321_p1
   FOREACH p321_c1 INTO l_ccg01,l_ccg02,l_ccg03,l_ccg04,l_ccg06,l_ccg07,l_ccglegal,l_ccg31,l_ccg32,l_ccg32a,l_ccg32b,l_ccg32c,l_ccg32d,l_ccg32e,l_ccg32f,l_ccg32g,l_ccg32h   
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdg.* TO NULL
      LET g_cdg.cdg01 = tm.b
      LET g_cdg.cdg02 = l_ccg02
      LET g_cdg.cdg03 = l_ccg03
      LET g_cdg.cdg04 = l_ccg06
      LET g_cdg.cdg06 = l_ccg07
      LET g_cdg.cdg07 = l_ccg01
      LET g_cdg.cdg08 = l_ccg04
      SELECT ccz07,ccz12,ccz18 INTO l_ccz07,l_ccz12,l_ccz18 FROM ccz_file  #FUN-BB0038 ADD ccz18
      #No.MOD-C70264  --Begin
      #No.MOD-C10125  --Begin
      IF g_argv1 = '1' THEN  #FUN-BB0038
         IF g_cdg.cdg01 = l_ccz12 THEN 
            IF l_ccz07 = '2' THEN 
                  SELECT imz39 INTO g_cdg.cdg09
                    FROM ima_file,imz_file
                   WHERE ima01 = g_cdg.cdg08
                    #AND ima06 = imz01  #FUN-BB0038
                    #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                     AND ima06 = imz01  #MOD-D50133 ima12->ima06
            ELSE 
                  SELECT ima39 INTO g_cdg.cdg09
                    FROM ima_file
                   WHERE ima01 = g_cdg.cdg08
            END IF  
         ELSE
            IF l_ccz07 = '2' THEN 
                  SELECT imz391 INTO g_cdg.cdg09
                    FROM ima_file,imz_file
                   WHERE ima01 = g_cdg.cdg08
                    #AND ima06 = imz01  #FUN-BB0038
                    #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                     AND ima06 = imz01  #MOD-D50133 ima12->ima06
            ELSE 
                  SELECT ima391 INTO g_cdg.cdg09
                    FROM ima_file
                   WHERE ima01 = g_cdg.cdg08
            END IF  
         END IF  
      ELSE
         LET g_cdg.cdg09 = l_ccz18 #FUN-BB0038
      END IF  
      #IF g_cdg.cdg01 = l_ccz12 THEN
      #    SELECT ima132 INTO g_cdh.cdh08
      #      FROM ima_file
      #     WHERE ima01 = g_cdh.cdh07
      #ELSE
      #    SELECT ima1321 INTO g_cdh.cdh08
      #      FROM ima_file
      #     WHERE ima01 = g_cdh.cdh07
      #END IF
      #No.MOD-C10125  --End
      #No.MOD-C70264  --End
      #FUN-CB0120--add--str--
      SELECT sfb02 INTO g_cdg.cdg13 FROM sfb_file
       WHERE sfb01 = g_cdg.cdg07
      SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
     #No.MOD-D40058--begin--  这个地方就是要取存货科目
     #IF g_ccz.ccz42='Y' AND (g_cdg.cdg13='7' OR g_cdg.cdg13='8') THEN
     #   IF g_aza.aza63='Y' THEN
     #      IF g_cdg.cdg01=g_ccz.ccz12 THEN
     #         LET g_cdg.cdg09=g_ccz.ccz43
     #      END IF
     #      IF g_cdg.cdg01=g_ccz.ccz121 THEN
     #         LET g_cdg.cdg09=g_ccz.ccz431
     #      END IF
     #   ELSE
     #      IF g_cdg.cdg01=g_ccz.ccz12 THEN
     #         LET g_cdg.cdg09=g_ccz.ccz43
     #      END IF
     #   END IF
     #END IF
     ##FUN-CB0120--add--end
     #No.MOD-D40058---end---
      #FUN-CB0120--add--end
      SELECT aag03,aag07,aag43 INTO l_aag03,l_aag07,l_aag43 FROM aag_file WHERE aag00 = g_cdg.cdg01 AND aag01 = g_cdg.cdg09    #No.FUN-D20040 add aag43     
      IF l_aag07 NOT MATCHES '[23]' THEN LET g_cdg.cdg09 = NULL  END IF 
      IF l_aag03 <> '2' THEN LET g_cdg.cdg09 = NULL END IF
      LET g_cdg.cdg10 = l_ccg31      
      LET g_cdg.cdg11 = l_ccg32
      LET g_cdg.cdg11a= l_ccg32a
      LET g_cdg.cdg11b= l_ccg32b
      LET g_cdg.cdg11c= l_ccg32c
      LET g_cdg.cdg11d= l_ccg32d
      LET g_cdg.cdg11e= l_ccg32e
      LET g_cdg.cdg11f= l_ccg32f
      LET g_cdg.cdg11g= l_ccg32g
      LET g_cdg.cdg11h= l_ccg32h
      LET g_cdg.cdg11 = cl_digcut(g_cdg.cdg11 ,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11a= cl_digcut(g_cdg.cdg11a,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11b= cl_digcut(g_cdg.cdg11b,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11c= cl_digcut(g_cdg.cdg11c,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11d= cl_digcut(g_cdg.cdg11d,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11e= cl_digcut(g_cdg.cdg11e,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11f= cl_digcut(g_cdg.cdg11f,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11g= cl_digcut(g_cdg.cdg11g,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdg.cdg11h= cl_digcut(g_cdg.cdg11h,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26 
      LET g_cdg.cdgplant = g_plant
      LET g_cdg.cdglegal = l_ccglegal
      LET g_cdg.cdgorig  = g_grup
      LET g_cdg.cdgoriu  = g_user
      LET g_cdg.cdg00 = g_argv1 #FUN-BB0038
      SELECT sfb82,sfb98 INTO g_cdg.cdg14,g_cdg.cdg12 FROM sfb_file WHERE sfb01 = g_cdg.cdg07    #No.FUN-D20040 add cdg14
      IF l_aag43 <>'Y' THEN LET g_cdg.cdg14 = ' ' END IF               #No.FUN-D20040 
      LET g_cdg.cdgconf ='N'
      #FUN-CB0120--add--str--
#      SELECT sfb02 INTO g_cdg.cdg13 FROM sfb_file
#       WHERE sfb01 = g_cdg.cdg07
#      SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
#      IF g_ccz.ccz43='Y' AND (g_cdg.cdg13='7' OR g_cdg.cdg13='8') THEN
#         IF g_aza.aza63='Y' THEN
#            IF g_cdg.cdg01=g_ccz.ccz12 THEN
#               LET g_cdg.cdg09=g_ccz.ccz44
#            END IF
#            IF g_cdg.cdg01=g_ccz.ccz121 THEN
#               LET g_cdg.cdg09=g_ccz.ccz441
#            END IF
#         ELSE
#            IF g_cdg.cdg01=g_ccz.ccz12 THEN
#               LET g_cdg.cdg09=g_ccz.ccz44
#            END IF
#         END IF
#      END IF
      #FUN-CB0120--add--end
      INSERT INTO cdg_file VALUES(g_cdg.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdg',SQLCA.sqlcode,1)
         LET g_success ='N'
         EXIT FOREACH 
      END IF 
#No.MOD-D70099 --begin
#      CALL p321_ins_cdh()
#      IF g_success ='N' THEN 
#         RETURN 
#      END IF       
#No.MOD-D70099 --end
   END FOREACH 
#No.MOD-D70099 --begin
   LET l_sql = " SELECT DISTINCT cdg02,cdg03,cdg04,cdg06,cdg07,cdg13 FROM cdg_file ",
               "  WHERE cdg01 = '",tm.b,"'",
               "    AND cdg02 = ",g_cdg.cdg02,
               "    AND cdg03 = ",g_cdg.cdg03,
               "    AND cdg04 = '",g_cdg.cdg04,"'"
   PREPARE p321_p3 FROM l_sql
   IF SQLCA.SQLCODE THEN
       CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
       RETURN
   END IF
   DECLARE p321_c3 CURSOR FOR p321_p3
   FOREACH p321_c3 INTO g_cdg.cdg02,g_cdg.cdg03,g_cdg.cdg04,g_cdg.cdg06,g_cdg.cdg07,g_cdg.cdg13
      CALL p321_ins_cdh()
      IF g_success ='N' THEN 
         RETURN 
      END IF  
   END FOREACH 
#No.MOD-D70099 --end
END FUNCTION 

FUNCTION p321_ins_cdh()
DEFINE l_cch      RECORD LIKE cch_file.*
DEFINE l_sql      STRING
DEFINE l_wc       STRING
DEFINE l_ccz07    LIKE ccz_file.ccz07
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag07    LIKE aag_file.aag07
DEFINE l_ccz17    LIKE ccz_file.ccz17   #MOD-C10125
DEFINE l_azf14    LIKE azf_file.azf14   #MOD-C80017


   INITIALIZE l_cch.* TO NULL

   LET l_wc = cl_replace_str(g_wc,"ccg","cch")
   
   #FUN-BB0038 --begin
   LET l_sql ="SELECT * ",
              "  FROM cch_file ",
              " WHERE cch02 = '",g_cdg.cdg02,"'",
              "   AND cch03 = '",g_cdg.cdg03,"'",
              "   AND cch06 = '",g_cdg.cdg04,"'",
              "   AND cch07 = '",g_cdg.cdg06,"'", 
               "  AND cch01 = '",g_cdg.cdg07,"'",
           #  "   AND cch32 < 0 ",
              "   AND ",l_wc CLIPPED
#No.MOD-D30149 --begin
   IF g_argv1='2' THEN LET l_sql=l_sql CLIPPED," AND cch42<>0 "
                  ELSE LET l_sql=l_sql CLIPPED," AND cch32<>0 "
   END IF
#   IF g_argv1='2' THEN LET l_sql=l_sql CLIPPED," AND cch42<0 "
#                  ELSE LET l_sql=l_sql CLIPPED," AND cch32<0 "
#   END IF
#No.MOD-D30149 --end
   
   #FUN-BB0038 --end
   PREPARE p321_p2 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p321_c2 CURSOR FOR p321_p2
   FOREACH p321_c2 INTO l_cch.*  
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdh.* TO NULL
      LET g_cdh.cdh01 = g_cdg.cdg01
      LET g_cdh.cdh02 = l_cch.cch02
      LET g_cdh.cdh03 = l_cch.cch03
      LET g_cdh.cdh04 = l_cch.cch06
      LET g_cdh.cdh05 = l_cch.cch07
      LET g_cdh.cdh06 = l_cch.cch01
      LET g_cdh.cdh07 = l_cch.cch04
      #FUN-BB0038 --begin
      IF g_argv1 = '2' THEN
         LET g_cdh.cdh09 = l_cch.cch41
         LET g_cdh.cdh10 = l_cch.cch42
         LET g_cdh.cdh10a = l_cch.cch42a
         LET g_cdh.cdh10b = l_cch.cch42b
         LET g_cdh.cdh10c = l_cch.cch42c
         LET g_cdh.cdh10d = l_cch.cch42d
         LET g_cdh.cdh10e = l_cch.cch42e
         LET g_cdh.cdh10f = l_cch.cch42f
         LET g_cdh.cdh10g = l_cch.cch42g
         LET g_cdh.cdh10h = l_cch.cch42h
      ELSE
         LET g_cdh.cdh09 = l_cch.cch31
         LET g_cdh.cdh10 = l_cch.cch32
         LET g_cdh.cdh10a = l_cch.cch32a
         LET g_cdh.cdh10b = l_cch.cch32b
         LET g_cdh.cdh10c = l_cch.cch32c
         LET g_cdh.cdh10d = l_cch.cch32d
         LET g_cdh.cdh10e = l_cch.cch32e
         LET g_cdh.cdh10f = l_cch.cch32f
         LET g_cdh.cdh10g = l_cch.cch32g
         LET g_cdh.cdh10h = l_cch.cch32h
      END IF
      #FUN-BB0038 --end
      LET g_cdh.cdh10 = cl_digcut(g_cdh.cdh10,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10a = cl_digcut(g_cdh.cdh10a,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10b = cl_digcut(g_cdh.cdh10b,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10c = cl_digcut(g_cdh.cdh10c,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10d = cl_digcut(g_cdh.cdh10d,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10e = cl_digcut(g_cdh.cdh10e,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10f = cl_digcut(g_cdh.cdh10f,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10g = cl_digcut(g_cdh.cdh10g,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdh.cdh10h = cl_digcut(g_cdh.cdh10h,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26 
      LET g_cdh.cdhplant = g_cdg.cdgplant
      LET g_cdh.cdhlegal = g_cdg.cdglegal
      LET g_cdh.cdhorig  = g_grup
      LET g_cdh.cdhoriu  = g_user 
      SELECT ccz07,ccz12,ccz17 INTO l_ccz07,l_ccz12,l_ccz17 FROM ccz_file    #MOD-C10125 add ccz17
      #No.MOD-C10125  --Begin
      IF g_cdg.cdg01 = l_ccz12 THEN 
            SELECT ima132 INTO g_cdh.cdh08
              FROM ima_file
             WHERE ima01 = g_cdh.cdh07
      ELSE
            SELECT ima1321 INTO g_cdh.cdh08
              FROM ima_file
             WHERE ima01 = g_cdh.cdh07
      END IF   
      #No.MOD-C80017  --Begin
      IF cl_null(g_cdh.cdh08) THEN
         SELECT azf14 INTO l_azf14 FROM azf_file,ima_file
                                  WHERE ima01 = g_cdh.cdh07
                                    AND azf01 = ima12
                                    AND azf02 = 'G'
         LET g_cdh.cdh08= l_azf14
      END IF

      IF cl_null(g_cdh.cdh08) THEN
         LET g_cdh.cdh08 = l_ccz17
      END IF
      #No.MOD-C80017  --End
      #IF g_argv1 = '1' THEN
      #    IF g_cdg.cdg01 = l_ccz12 THEN
      #       IF l_ccz07 = '2' THEN
      #             SELECT imz39 INTO g_cdg.cdg09
      #               FROM ima_file,imz_file
      #              WHERE ima01 = g_cdg.cdg08
      #                AND ima12 = imz01
      #       ELSE
      #             SELECT ima39 INTO g_cdg.cdg09
      #               FROM ima_file
      #              WHERE ima01 = g_cdg.cdg08
      #       END IF
      #    ELSE
      #       IF l_ccz07 = '2' THEN
      #             SELECT imz391 INTO g_cdg.cdg09
      #               FROM ima_file,imz_file
      #              WHERE ima01 = g_cdg.cdg08
      #                AND ima12 = imz01
      #       ELSE
      #             SELECT ima391 INTO g_cdg.cdg09
      #               FROM ima_file
      #              WHERE ima01 = g_cdg.cdg08
      #       END IF
      #    END IF
      # ELSE
      #    LET g_cdg.cdg09 = l_ccz18
      # END IF
      # #No.MOD-C10125  --End
     #No.MOD-D40058--begin--  根据cdh对应的cdg判断，非 DL+OH+SUB且走委托加工物资并且工单委外类型，则科目取委托加工物资
     #IF g_cdh.cdh07 <> ' DL+OH+SUB' THEN
          IF g_ccz.ccz43='Y' AND (g_cdg.cdg13='7' OR g_cdg.cdg13='8') THEN   #No.MOD-D40058  42-->43
             IF g_aza.aza63='Y' THEN
                IF g_cdg.cdg01=g_ccz.ccz12 THEN
                   LET g_cdh.cdh08=g_ccz.ccz44       #No.MOD-D40058  43-->44
                END IF
                IF g_cdg.cdg01=g_ccz.ccz121 THEN    
                   LET g_cdh.cdh08=g_ccz.ccz441      #No.MOD-D40058  43-->44
                END IF
             ELSE
                IF g_cdg.cdg01=g_ccz.ccz12 THEN
                   LET g_cdh.cdh08=g_ccz.ccz44       #No.MOD-D40058  43-->44
                END IF
             END IF
          END IF
     #END IF
     #No.MOD-D40058---end---
      SELECT aag03,aag07 INTO l_aag03,l_aag07 FROM aag_file WHERE aag00 = g_cdh.cdh01 AND aag01 = g_cdh.cdh08
      IF l_aag07 NOT MATCHES '[23]' THEN  LET g_cdh.cdh08 = NULL END IF 
      IF l_aag03 <> '2' THEN LET g_cdh.cdh08 = NULL END IF
      SELECT sfb98 INTO g_cdh.cdh11 FROM sfb_file WHERE sfb01 = g_cdh.cdh06
      LET g_cdh.cdh00 = g_argv1 #FUN-BB0038
      INSERT INTO cdh_file VALUES(g_cdh.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdh',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN 
      END IF       
   END FOREACH 
END FUNCTION 

FUNCTION p321_ins_cdi()
DEFINE l_ccz       RECORD LIKE ccz_file.*
DEFINE l_wc        STRING
DEFINE l_cdg01     LIKE cdg_file.cdg01
DEFINE l_cdg02     LIKE cdg_file.cdg02
DEFINE l_cdg03     LIKE cdg_file.cdg03
DEFINE l_cdg04     LIKE cdg_file.cdg04

   LET l_wc = cl_replace_str(g_wc,"ccg06","cdg04")
   LET l_wc = cl_replace_str(l_wc,"ccg02","cdg02")
   LET l_wc = cl_replace_str(l_wc,"ccg03","cdg03")
   SELECT * INTO l_ccz.* FROM ccz_file
   LET g_sql = "SELECT DISTINCT cdg01,cdg02,cdg03,cdg04 ",
               "  FROM cdg_file ",
               " WHERE ",l_wc CLIPPED ,
               "   AND cdg01 = '",tm.b,"'"    #carrier 20130619

   #FUN-BB0038 --begin
   IF g_argv1 = '2' THEN
      LET g_sql = g_sql CLIPPED," AND cdg00='2' "
   ELSE
      LET g_sql = g_sql CLIPPED," AND cdg00='1' "
   END IF
   #FUN-BB0038 --end
   PREPARE p320_p9 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p320_c9 CURSOR FOR p320_p9
   FOREACH p320_c9 INTO l_cdg01,l_cdg02,l_cdg03,l_cdg04   
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdi.* TO NULL      
      LET g_cdi.cdi01 = l_cdg01
      LET g_cdi.cdi02 = l_cdg02
      LET g_cdi.cdi03 = l_cdg03
      LET g_cdi.cdi04 = l_cdg04
      LET g_cdi.cdi05 = l_ccz.ccz14
      LET g_cdi.cdi06 = l_ccz.ccz15
      LET g_cdi.cdi07 = l_ccz.ccz16
      LET g_cdi.cdi08 = l_ccz.ccz33
      LET g_cdi.cdi09 = l_ccz.ccz34
      LET g_cdi.cdi10 = l_ccz.ccz35
      LET g_cdi.cdi11 = l_ccz.ccz36
      SELECT SUM(cdh10b),SUM(cdh10c),SUM(cdh10d),SUM(cdh10e),SUM(cdh10f),SUM(cdh10g),SUM(cdh10h) 
        INTO g_cdi.cdi12b,g_cdi.cdi12c,g_cdi.cdi12d,g_cdi.cdi12e,g_cdi.cdi12f,g_cdi.cdi12g,g_cdi.cdi12h 
        FROM cdh_file
       WHERE cdh01 = l_cdg01
         AND cdh02 = l_cdg02
         AND cdh03 = l_cdg03
         AND cdh04 = l_cdg04
         AND cdh07 = ' DL+OH+SUB' 
         AND cdh00 = g_argv1    #No.MOD-D20160
      IF cl_null(g_cdi.cdi12b) THEN
         LET g_cdi.cdi12b =0 
      END IF  
      IF cl_null(g_cdi.cdi12c) THEN
         LET g_cdi.cdi12c =0 
      END IF 
      IF cl_null(g_cdi.cdi12d) THEN
         LET g_cdi.cdi12d =0 
      END IF 
      IF cl_null(g_cdi.cdi12e) THEN
         LET g_cdi.cdi12e =0 
      END IF 
      IF cl_null(g_cdi.cdi12f) THEN
         LET g_cdi.cdi12f =0 
      END IF 
      IF cl_null(g_cdi.cdi12g) THEN
         LET g_cdi.cdi12g =0 
      END IF 
      IF cl_null(g_cdi.cdi12h) THEN
         LET g_cdi.cdi12h =0 
      END IF 
      LET g_cdi.cdi00 = g_argv1 #FUN-BB0038
      LET g_cdi.cdi12b = cl_digcut(g_cdi.cdi12b,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdi.cdi12c = cl_digcut(g_cdi.cdi12c,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdi.cdi12d = cl_digcut(g_cdi.cdi12d,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdi.cdi12e = cl_digcut(g_cdi.cdi12e,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdi.cdi12f = cl_digcut(g_cdi.cdi12f,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdi.cdi12g = cl_digcut(g_cdi.cdi12g,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdi.cdi12h = cl_digcut(g_cdi.cdi12h,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      INSERT INTO cdi_file VALUES(g_cdi.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdi',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN 
      END IF  
   END FOREACH 
END FUNCTION 

FUNCTION p321_chk()
DEFINE l_wc        STRING
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cdgconf   LIKE cdg_file.cdgconf  #MOD-DB0128

   LET l_wc = cl_replace_str(g_wc,"ccg06","cdg04")   
   LET l_wc = cl_replace_str(l_wc,"ccg02","cdg02")
   LET l_wc = cl_replace_str(l_wc,"ccg03","cdg03")
   
   
   LET l_sql = "SELECT count(*) ",
               "  FROM cdg_file ",
               " WHERE cdg01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED 

   #FUN-BB0038 --begin
   IF g_argv1 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND cdg00='2' "      #No.MOD-D50130 g_sql -->l_sql
   ELSE
      LET l_sql = l_sql CLIPPED," AND cdg00='1' "      #No.MOD-D50130 g_sql -->l_sql
   END IF
   #FUN-BB0038 --end
   PREPARE p321_p6 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p321_c6 CURSOR FOR p321_p6
#MOD-DB0128 add begin-------------------------
   LET l_sql = "SELECT UNIQUE cdgconf ",
               "  FROM cdg_file ",
               " WHERE cdg01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED
   IF g_argv1 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND cdg00='2' "
   ELSE
      LET l_sql = l_sql CLIPPED," AND cdg00='1' "
   END IF
   PREPARE p321_p9 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
#MOD-DB0128 add end---------------------------
   LET l_sql = "DELETE ",
               "  FROM cdg_file ",
               " WHERE cdg01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED 
   #FUN-BB0038 --begin
   IF g_argv1 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND cdg00='2' "      #No.MOD-D50130 g_sql -->l_sql
   ELSE
      LET l_sql = l_sql CLIPPED," AND cdg00='1' "      #No.MOD-D50130 g_sql -->l_sql
   END IF
   #FUN-BB0038 --end

   PREPARE p321_p7 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   LET l_wc = cl_replace_str(l_wc,"cdg","cdh")
   LET l_sql = "DELETE ",
               "  FROM cdh_file ",
               " WHERE cdh01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED 
   #FUN-BB0038 --begin
   IF g_argv1 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND cdh00='2' "      #No.MOD-D50130 g_sql -->l_sql
   ELSE
      LET l_sql = l_sql CLIPPED," AND cdh00='1' "      #No.MOD-D50130 g_sql -->l_sql
   END IF
   #FUN-BB0038 --end

   PREPARE p321_p8 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   LET l_wc = cl_replace_str(l_wc,"cdh","cdi")
   LET l_sql = "DELETE ",
               "  FROM cdi_file ",
               " WHERE cdi01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED 
   #FUN-BB0038 --begin
   IF g_argv1 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND cdi00='2' "      #No.MOD-D50130 g_sql -->l_sql
   ELSE
      LET l_sql = l_sql CLIPPED," AND cdi00='1' "      #No.MOD-D50130 g_sql -->l_sql
   END IF
   #FUN-BB0038 --end

   PREPARE p321_p11 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   OPEN p321_c6 
   FETCH p321_c6 INTO l_cnt
   IF l_cnt >0 THEN 
     #MOD-DB0128 add sta---------------
      EXECUTE p321_p9 INTO l_cdgconf
      IF l_cdgconf='Y' THEN
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
      EXECUTE p321_p7
      EXECUTE p321_p8 
      EXECUTE p321_p11    
   END IF 
   CLOSE p321_c6
END FUNCTION 
