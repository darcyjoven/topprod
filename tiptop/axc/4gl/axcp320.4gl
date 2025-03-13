# Prog. Version..: '5.30.06-13.04.19(00009)'     #
#
# Pattern name...: axcp320.4gl
# Descriptions...: 工单发料分录底稿整批生成作业
# Date & Author..: 10/06/25 By wujie #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B50096 11/05/18 By yinhy 費用科目cde09,抓不到ima132或者ima1321的值時,再去抓azf14的值
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 根據幣種取位
# Modify.........: No:FUN-BB0038 11/11/08 By elva 成本改善
# Modify.........: No:MOD-C10133 12/01/16 By yinhy 年度期別，預設主帳套，同時檢查帳套是否存在
# Modify.........: No:MOD-C70135 12/07/11 By elva 修正S件时借贷不符的问题
# Modify.........: No:FUN-C90002 12/09/04 By minpp 成本类型给默认值ccz28
# Modify.........: No.MOD-CC0001 12/12/03 By wujie 金额小数位数用ccz26截位
# Modify.........: No.MOD-CC0110 12/12/13 By wujie 增加领用S件的工单
# Modify.........: No.FUN-CB0120 12/12/28 By wangrr 增加字段cde12工單類型,判斷是否走委外加工,如果是抓取對應科目ccz44/ccz441
# Modify.........: No.FUN-D20040 13/02/18 By wujie 增加插入cde13
# Modify.........: No.MOD-D20113 13/02/21 By wujie cde10需要考虑扣除cch22
# Modify.........: No.TQC-D20037 13/02/21 By wujie MOD-D20113与MOD-C70135重复，去掉
# Modify.........: No:MOD-D50133 13/05/15 By suncx 參數設置存貨科目取自料件分群碼檔時，應該根據ima06去imz39，而不是根據ima12
# Modify.........: No.MOD-D60079 13/06/09 By wujie 扣除ccg22全部的
# Modify.........: No.MOD-DB0128 13/11/19 By suncx 存在已審核cde_file資料，提示已審核，不可重新產生

DATABASE ds   

GLOBALS "../../config/top.global"
#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE g_cde               RECORD LIKE cde_file.*
DEFINE g_cdf               RECORD LIKE cdf_file.*
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
DEFINE ccg02               LIKE ccg_file.ccg02  #MOD-C10133
DEFINE ccg03               LIKE ccg_file.ccg03  #MOD-C10133
DEFINE ccg06               LIKE ccg_file.ccg06  #MOD-C10133


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
         CALL p320_tm()
         IF cl_sure(18,20) THEN 
            CALL p320_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p320_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p320_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p320_w
      ELSE
         CALL p320_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION p320_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
DEFINE l_aaaacti      LIKE aaa_file.aaaacti #MOD-C10133
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p320_w AT p_row,p_col WITH FORM "axc/42f/axcp320" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR ''
   WHILE TRUE  
   CONSTRUCT BY NAME g_wc ON ccg06,ccg02,ccg03
 
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
          #No.MOD-C10133  --Begin
         #LET ccg06 = '1'                  #FUN-C90002
          LET ccg06 = g_ccz.ccz28          #FUN-C90002
          LET ccg02  = g_ccz.ccz01
          LET ccg03  = g_ccz.ccz02
          LET tm.b   = g_aza.aza81
          DISPLAY BY NAME ccg02,ccg03,ccg06,tm.b
          #No.MOD-C10133  --End
 
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
      CLOSE WINDOW p320_w
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
 
      AFTER FIELD b
         IF tm.b IS NULL THEN
            NEXT FIELD b
         #No.MOD-C10133  --Begin
         ELSE
            SELECT aaaacti INTO l_aaaacti FROM aaa_file
             WHERE aaa01=tm.b
            IF SQLCA.SQLCODE=100 THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",100,"","",1)
               NEXT FIELD b
            END IF
            IF l_aaaacti='N' THEN
               CALL cl_err(tm.b,"9028",1)
               NEXT FIELD b
            END IF
         #No.MOD-C10133  --End
         END IF
 
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p320_w
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
      CLOSE WINDOW p320_w
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

FUNCTION p320_p()
   
   BEGIN WORK 
   CALL p320_chk()
   IF g_flag ='N' THEN ROLLBACK WORK RETURN END IF 
   CALL p320_ins_cde()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p320_gl(g_wc,tm.b)
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
END FUNCTION 

FUNCTION p320_ins_cde()
DEFINE l_ccg01    LIKE ccg_file.ccg01
DEFINE l_ccg02    LIKE ccg_file.ccg02
DEFINE l_ccg03    LIKE ccg_file.ccg03
DEFINE l_ccg04    LIKE ccg_file.ccg04
DEFINE l_ccg06    LIKE ccg_file.ccg06
DEFINE l_ccg07    LIKE ccg_file.ccg07
DEFINE l_ccg23    LIKE ccg_file.ccg23
DEFINE l_ima132   LIKE ima_file.ima132
DEFINE l_ima1321  LIKE ima_file.ima1321
DEFINE l_ccglegal LIKE ccg_file.ccglegal
DEFINE l_sql      STRING 
DEFINE l_ccz12    LIKE ccz_file.ccz12 
DEFINE l_ccz17    LIKE ccz_file.ccz17
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag07    LIKE aag_file.aag07
DEFINE l_azf14    LIKE azf_file.azf14  #No.TQC-B50096
DEFINE l_cch22    LIKE cch_file.cch22  #MOD-C70135
DEFINE l_aag43    LIKE aag_file.aag43  #No.FUN-D20040  
#DEFINE l_cch_sum  LIKE cch_file.cch22  #No.MOD-D20113   TQC-D20037

  #LET l_sql ="SELECT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07,ccg22a+ccg23,ccglegal,ima132,ima1321 ",  #MOD-C70135
   LET l_sql ="SELECT ccg01,ccg02,ccg03,ccg04,ccg06,ccg07,ccg22+ccg23,ccglegal,ima132,ima1321 ",  #MOD-C70135
              "  FROM ccg_file ,ima_file",
             #" WHERE ccg04 = ima01 AND ccg22a+ccg23 >0 ", #FUN-BB0038
              " WHERE ccg04 = ima01 AND ccg22+ccg22+ccg23 <>0 ", #FUN-BB0038   No.MOD-CC0110 add ccg22d  MOD-D60079  ccg22a+ccg22d -->ccg22
              "   AND ",g_wc CLIPPED
   
   PREPARE p320_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p320_c1 CURSOR FOR p320_p1
   FOREACH p320_c1 INTO l_ccg01,l_ccg02,l_ccg03,l_ccg04,l_ccg06,l_ccg07,l_ccg23,l_ccglegal,l_ima132,l_ima1321
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cde.* TO NULL
      #MOD-C70135 --begin
      LET l_cch22=0
      SELECT SUM(cch22) INTO l_cch22 FROM cch_file 
      WHERE cch01=l_ccg01
      AND cch02=l_ccg02 AND cch03=l_ccg03 
      AND cch06=l_ccg06 AND cch07=l_ccg07
      AND (cch04=' DL+OH+SUB' OR cch04=' ADJUST')
      IF cl_null(l_cch22) THEN LET l_cch22=0 END IF
      LET l_ccg23=l_ccg23-l_cch22
      #MOD-C70135 --end
      LET g_cde.cde01 = tm.b
      LET g_cde.cde02 = l_ccg02
      LET g_cde.cde03 = l_ccg03
      LET g_cde.cde04 = l_ccg06
      LET g_cde.cde06 = l_ccg07
      LET g_cde.cde07 = l_ccg01
      LET g_cde.cde08 = l_ccg04
      SELECT ccz12,ccz17 INTO l_ccz12,l_ccz17 FROM ccz_file 
      IF g_cde.cde01 = l_ccz12 THEN 
            LET g_cde.cde09 = l_ima132
      ELSE 
            LET g_cde.cde09 = l_ima1321
      END IF  
      #No.TQC-B50096  --Begin
      IF cl_null(g_cde.cde09) THEN
         SELECT azf14 INTO l_azf14 FROM azf_file,ima_file
                                  WHERE ima01 = g_cde.cde08
                                    AND azf01 = ima12
                                    AND azf02 = 'G'
         LET g_cde.cde09 = l_azf14
      END IF
      #No.TQC-B50096  --End
      IF cl_null(g_cde.cde09) THEN  
         LET g_cde.cde09 = l_ccz17
      END IF  
      #FUN-CB0120--add--str--
      SELECT sfb02,sfb82 INTO g_cde.cde12,g_cde.cde13 FROM sfb_file    #No.FUN-D20040 add cde13  
       WHERE sfb01 = g_cde.cde07
    
      SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
      IF g_ccz.ccz43='Y' AND (g_cde.cde12='7' OR g_cde.cde12='8') THEN
         IF g_aza.aza63='Y' THEN
            IF g_cde.cde01=g_ccz.ccz12 THEN
               LET g_cde.cde09=g_ccz.ccz44
            END IF
            IF g_cde.cde01=g_ccz.ccz121 THEN
               LET g_cde.cde09=g_ccz.ccz441
            END IF
         ELSE
            IF g_cde.cde01=g_ccz.ccz12 THEN
               LET g_cde.cde09=g_ccz.ccz44
            END IF 
         END IF
      END IF
      #FUN-CB0120--add--end
      SELECT aag03,aag07,aag43 INTO l_aag03,l_aag07,l_aag43 FROM aag_file    #No.FUN-D20040 add aag43
       WHERE aag00 = g_cde.cde01 AND aag01 = g_cde.cde09
      IF l_aag07 NOT MATCHES '[23]' THEN  LET g_cde.cde09 = NULL END IF 
      IF l_aag03 <> '2' THEN LET g_cde.cde09 = NULL END IF
#No.TQC-D20037 --begin
#No.MOD-D20113 --begin
#      SELECT SUM(cch22a+cch22b+cch22c+cch22d+cch22e+cch22f+cch22g+cch22h) 
#        INTO l_cch_sum
#        FROM cch_file 
#       WHERE cch01 = l_ccg01
#         AND cch02 = l_ccg02
#         AND cch03 = l_ccg03
#         AND cch06 = g_cde.cde04
#         AND cch04 = ' DL+OH+SUB'
#      IF cl_null(l_cch_sum) THEN 
#          LET l_cch_sum = 0
#      END IF 
      LET g_cde.cde10 = l_ccg23
#      LET g_cde.cde10 = l_ccg23-l_cch_sum
#No.MOD-D20113 --end
#No.TQC-D20037 --end
      LET g_cde.cde10 = cl_digcut(g_cde.cde10,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      SELECT sfb98 INTO g_cde.cde11 FROM sfb_file WHERE sfb01 = g_cde.cde07
      LET g_cde.cdeplant = g_plant
      LET g_cde.cdelegal = l_ccglegal
      LET g_cde.cdeorig  = g_grup
      LET g_cde.cdeoriu  = g_user 
      LET g_cde.cdeconf = 'N'
      #FUN-CB0120--add--str--
#      SELECT sfb02,sfb82 INTO g_cde.cde12,g_cde.cde13 FROM sfb_file    #No.FUN-D20040 add cde13  
#       WHERE sfb01 = g_cde.cde07
      IF l_aag43 <>'Y' THEN LET g_cde.cde13 = ' ' END IF               #No.FUN-D20040      
#      SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
#      IF g_ccz.ccz42='Y' AND (g_cde.cde12='7' OR g_cde.cde12='8') THEN
#         IF g_aza.aza63='Y' THEN
#            IF g_cde.cde01=g_ccz.ccz12 THEN
#               LET g_cde.cde09=g_ccz.ccz44
#            END IF
#            IF g_cde.cde01=g_ccz.ccz121 THEN
#               LET g_cde.cde09=g_ccz.ccz441
#            END IF
#         ELSE
#            IF g_cde.cde01=g_ccz.ccz12 THEN
#               LET g_cde.cde09=g_ccz.ccz44
#            END IF 
#         END IF
#      END IF
      #FUN-CB0120--add--end
      INSERT INTO cde_file VALUES(g_cde.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cde',SQLCA.sqlcode,1)
         LET g_success ='N'
         EXIT FOREACH 
      END IF 
      CALL p320_ins_cdf()
      IF g_success ='N' THEN 
         RETURN 
      END IF       
   END FOREACH 

END FUNCTION 

FUNCTION p320_ins_cdf()
DEFINE l_cch      RECORD LIKE cch_file.*
DEFINE l_sql      STRING
DEFINE l_wc       STRING
DEFINE l_ccz07    LIKE ccz_file.ccz07
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_aag03    LIKE aag_file.aag03
DEFINE l_aag07    LIKE aag_file.aag07


   INITIALIZE l_cch.* TO NULL

   LET l_wc = cl_replace_str(g_wc,"ccg","cch")
   
   LET l_sql ="SELECT * ",
              "  FROM cch_file ",
              " WHERE cch02 = '",g_cde.cde02,"'",
              "   AND cch03 = '",g_cde.cde03,"'",
              "   AND cch06 = '",g_cde.cde04,"'",
              "   AND cch07 = '",g_cde.cde06,"'", 
               "  AND cch01 = '",g_cde.cde07,"'",
              "   AND cch04 <> ' DL+OH+SUB'",
              "   AND cch04 <> ' ADJUST'  ",  #MOD-C70135
             #"   AND cch22 > 0 ",  #FUN-BB0038
              "   AND cch22 <> 0 ",  #FUN-BB0038
              "   AND ",l_wc CLIPPED
   
   PREPARE p320_p2 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p320_c2 CURSOR FOR p320_p2
   FOREACH p320_c2 INTO l_cch.*  
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      INITIALIZE g_cdf.* TO NULL
      LET g_cdf.cdf01 = g_cde.cde01
      LET g_cdf.cdf02 = l_cch.cch02
      LET g_cdf.cdf03 = l_cch.cch03
      LET g_cdf.cdf04 = l_cch.cch06
      LET g_cdf.cdf05 = l_cch.cch07
      LET g_cdf.cdf06 = l_cch.cch01
      LET g_cdf.cdf07 = l_cch.cch04
      LET g_cdf.cdf09 = l_cch.cch22
      LET g_cdf.cdf09a = l_cch.cch22a
      LET g_cdf.cdf09b = l_cch.cch22b
      LET g_cdf.cdf09c = l_cch.cch22c
      LET g_cdf.cdf09d = l_cch.cch22d
      LET g_cdf.cdf09e = l_cch.cch22e
      LET g_cdf.cdf09f = l_cch.cch22f
      LET g_cdf.cdf09g = l_cch.cch22g
      LET g_cdf.cdf09h = l_cch.cch22h
      LET g_cdf.cdf09 = cl_digcut(g_cdf.cdf09,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09a = cl_digcut(g_cdf.cdf09a,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09b = cl_digcut(g_cdf.cdf09b,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09c = cl_digcut(g_cdf.cdf09c,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09d = cl_digcut(g_cdf.cdf09d,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09e = cl_digcut(g_cdf.cdf09e,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09f = cl_digcut(g_cdf.cdf09f,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09g = cl_digcut(g_cdf.cdf09g,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdf09h = cl_digcut(g_cdf.cdf09h,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdf.cdfplant = g_cde.cdeplant
      LET g_cdf.cdflegal = g_cde.cdelegal
      LET g_cdf.cdforig  = g_grup
      LET g_cdf.cdforiu  = g_user 
      SELECT ccz07,ccz12 INTO l_ccz07,l_ccz12 FROM ccz_file 
      IF g_cde.cde01 = l_ccz12 THEN 
         IF l_ccz07 = '2' THEN 
               SELECT imz39 INTO g_cdf.cdf08
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdf.cdf07
                 #AND ima06 = imz01  #FUN-BB0038
                 #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima39 INTO g_cdf.cdf08
                 FROM ima_file
                WHERE ima01 = g_cdf.cdf07
         END IF  
      ELSE
         IF l_ccz07 = '2' THEN 
               SELECT imz391 INTO g_cdf.cdf08
                 FROM ima_file,imz_file
                WHERE ima01 = g_cdf.cdf07
                 #AND ima06 = imz01  #FUN-BB0038
                 #AND ima12 = imz01  #FUN-BB0038 #MOD-D50133 mark
                  AND ima06 = imz01  #MOD-D50133 ima12->ima06
         ELSE 
               SELECT ima391 INTO g_cdf.cdf08
                 FROM ima_file
                WHERE ima01 = g_cdf.cdf07
         END IF  
      END IF   
      SELECT aag03,aag07 INTO l_aag03,l_aag07 
        FROM aag_file 
       WHERE aag00 = g_cdf.cdf01 AND aag01 = g_cdf.cdf08      
         
      IF l_aag07 NOT MATCHES '[23]' THEN  LET g_cdf.cdf08 = NULL  END IF 
      IF l_aag03 <> '2' THEN LET g_cdf.cdf08 = NULL  END IF
      SELECT sfb98 INTO g_cdf.cdf10 FROM sfb_file WHERE sfb01 = g_cdf.cdf06
      INSERT INTO cdf_file VALUES(g_cdf.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdf',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN 
      END IF       
   END FOREACH 
END FUNCTION 

FUNCTION p320_chk()
DEFINE l_wc        STRING
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cdeconf   LIKE cde_file.cdeconf  #MOD-DB0128

   LET l_wc = cl_replace_str(g_wc,"ccg06","cde04")   
   LET l_wc = cl_replace_str(l_wc,"ccg02","cde02")
   LET l_wc = cl_replace_str(l_wc,"ccg03","cde03")
   
   
   LET l_sql = "SELECT count(*) ",
               "  FROM cde_file ",
               " WHERE cde01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED 

   PREPARE p320_p6 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p320_c6 CURSOR FOR p320_p6
#MOD-DB0128 add begin-------------------------
   LET l_sql = "SELECT UNIQUE cdeconf ",
               "  FROM cde_file ",
               " WHERE cde01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED

   PREPARE p320_p9 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
#MOD-DB0128 add end---------------------------
   LET l_sql = "DELETE ",
               "  FROM cde_file ",
               " WHERE cde01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED 

   PREPARE p320_p7 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   LET l_wc = cl_replace_str(l_wc,"cde","cdf")
   LET l_sql = "DELETE ",
               "  FROM cdf_file ",
               " WHERE cdf01 ='",tm.b CLIPPED,"'",
               "   AND ",l_wc CLIPPED 

   PREPARE p320_p8 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   OPEN p320_c6 
   FETCH p320_c6 INTO l_cnt
   IF l_cnt >0 THEN 
     #MOD-DB0128 add sta---------------
      EXECUTE p320_p9 INTO l_cdeconf
      IF l_cdeconf='Y' THEN
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
      EXECUTE p320_p7
      EXECUTE p320_p8     
   END IF 
   CLOSE p320_c6
END FUNCTION 
