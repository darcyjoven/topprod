# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: almi400_sub1.4gl
# Descriptions...: 產生帳單
# Date & Author..: No:FUN-BA0118 11/11/09 By huangtao
# Modify.........: No:FUN-C20078 12/02/14 By shiwuying 比例日核算更新
# Modify.........: No:TQC-C20395 12/02/23 By shiwuying 延期的0账单不结案
# Modify.........: No:FUN-C40097 12/04/27 By baogc 帳單計算調整
# Modify.........: No:CHI-C70019 12/07/23 By pauline 產生帳單時跳出"出帳日設置過大"問題調整
# Modify.........: No:FUN-C80006 12/08/03 By xumeimei 優惠金額調整為正的表示優惠
# Modify.........: No:FUN-CA0081 13/01/09 By baogc 邏輯調整

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE     gs_lnt     RECORD LIKE lnt_file.*
DEFINE     gs_lla     RECORD LIKE lla_file.*
DEFINE     gs_llc     RECORD LIKE llc_file.*
DEFINE     gs_liw     RECORD LIKE liw_file.*

DEFINE     gs_lji     RECORD LIKE lji_file.*
DEFINE     gs_ljq     RECORD LIKE ljq_file.*
DEFINE     gs_success LIKE type_file.chr1
DEFINE     gs_msg     LIKE type_file.chr1000
DEFINE     g_cnt      LIKE type_file.num5

#p_no              #合同单号    
#p_type            #类型：1、合同账单 2、合同变更账单     
FUNCTION i400sub_generate_bill(p_no,p_type)
DEFINE p_no        LIKE lnt_file.lnt01
DEFINE p_type      LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cnt1      LIKE type_file.num5
DEFINE l_cnt2      LIKE type_file.num5

   WHENEVER ERROR CALL cl_err_msg_log
   LET gs_success = 'Y'
   CALL s_showmsg_init()
   IF cl_null(p_no) THEN RETURN END IF
   DROP TABLE x
   DROP TABLE y
   SELECT * FROM liw_file WHERE 1=1 INTO TEMP x
   SELECT * FROM ljq_file WHERE 1=1 INTO TEMP y
   BEGIN WORK
   
   IF p_type = '1' THEN
      SELECT * INTO gs_lnt.* FROM lnt_file WHERE lnt01 = p_no
      IF STATUS = 100 THEN  RETURN END IF
      IF gs_lnt.lnt26 <> 'N' THEN 
         CALL cl_err(gs_lnt.lnt01,'alm1198',0)
         ROLLBACK WORK
         RETURN
      END IF
      SELECT COUNT(*) INTO l_cnt FROM liw_file
       WHERE liw01 = gs_lnt.lnt01
         AND liw16 IS NOT NULL
      IF l_cnt > 0 THEN
         CALL cl_err(gs_lnt.lnt01,'alm1199',0)
         ROLLBACK WORK
         RETURN
      END IF
      SELECT COUNT(*) INTO l_cnt1 FROM liu_file WHERE liu01 = p_no 
      IF l_cnt1 = 0 THEN
         CALL cl_err(gs_lnt.lnt01,'alm1201',0)
         ROLLBACK WORK
         RETURN
      END IF  
      SELECT * INTO gs_lla.* FROM lla_file WHERE llastore = gs_lnt.lntplant
      IF STATUS = 100 THEN 
         CALL cl_err('','alm1448',0)
         ROLLBACK WORK
         RETURN
      END IF
      SELECT * INTO gs_llc.* FROM llc_file WHERE llc01 = gs_lnt.lnt31 AND llcstore = gs_lnt.lntplant
      IF STATUS = 100 THEN 
         CALL cl_err('','alm-996',0)
         ROLLBACK WORK
         RETURN
      END IF
      SELECT COUNT(*) INTO l_cnt2 FROM liw_file WHERE liw01 = gs_lnt.lnt01
      IF l_cnt2 > 0 THEN  
         IF cl_confirm('alm1253') THEN
            DELETE FROM liw_file WHERE liw01 = gs_lnt.lnt01 
            IF SQLCA.sqlcode THEN
               CALL cl_err('',SQLCA.sqlcode,1)
               ROLLBACK WORK
               RETURN 
            END IF
         ELSE
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      DELETE FROM liv_file WHERE liv01 = gs_lnt.lnt01 AND liv08 = '4'
      IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN 
      END IF
      CALL i400_generate_bill()
      CALL i400_update_bill_order()
   ELSE
      SELECT * INTO gs_lji.* FROM lji_file WHERE lji01 = p_no
      IF STATUS = 100 THEN  RETURN END IF
      IF gs_lji.ljiconf <> 'N' THEN 
         CALL cl_err(gs_lji.lji01,'',0)
         ROLLBACK WORK
         RETURN
      END IF
      SELECT * INTO gs_lla.* FROM lla_file WHERE llastore = gs_lji.ljiplant
      IF STATUS = 100 THEN 
         CALL cl_err('','alm1448',0)
         ROLLBACK WORK
         RETURN
      END IF
      SELECT * INTO gs_llc.* FROM llc_file WHERE llc01 = gs_lji.lji49 AND llcstore = gs_lji.ljiplant
      IF STATUS = 100 THEN 
         CALL cl_err('','alm-996',0)
         ROLLBACK WORK
         RETURN
      END IF
      SELECT COUNT(*) INTO l_cnt1 FROM ljm_file WHERE ljm01 = p_no 
      IF l_cnt1 = 0 THEN
         CALL cl_err(gs_lji.lji01,'alm1201',0)
         ROLLBACK WORK
         RETURN
      END IF 
      
      DELETE FROM ljq_file WHERE ljq01 = gs_lji.lji01  AND ljq02 = gs_lji.lji05
      IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN 
      END IF
      DELETE FROM ljp_file WHERE ljp01 = gs_lji.lji01 AND ljp02 = gs_lji.lji05 AND ljp08 = '4'
      IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN 
      END IF
      IF gs_lji.lji02 <> '2' THEN
         CALL t410_generate_bill()
         CALL t410_update_bill_order()
      END IF
   END IF
   IF gs_success = 'Y' THEN
      COMMIT WORK
      CALL cl_err('','alm1187',0)
   ELSE
      ROLLBACK WORK
      CALL s_showmsg()
      CALL cl_err('','alm1186',0)
   END IF
   DROP TABLE x
   DROP TABLE y 
END FUNCTION


FUNCTION i400_generate_bill()
DEFINE l_liu       RECORD LIKE liu_file.*
DEFINE l_liv       RECORD LIKE liv_file.*
DEFINE l_liw       RECORD LIKE liw_file.*
DEFINE l_lnr03     LIKE lnr_file.lnr03
DEFINE l_month     LIKE type_file.num5
DEFINE l_day       LIKE type_file.num5
DEFINE l_year      LIKE type_file.num5
DEFINE l_date      LIKE type_file.dat
DEFINE l_bdate     LIKE type_file.dat
DEFINE l_edate     LIKE type_file.dat
DEFINE l_azi04     LIKE azi_file.azi04
DEFINE l_n         LIKE type_file.num5
DEFINE l_n1        LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_y         LIKE type_file.num5  
DEFINE l_y_t       LIKE type_file.num5  
DEFINE l_m         LIKE type_file.num5  
DEFINE l_m_t       LIKE type_file.num5
DEFINE l_day1      LIKE type_file.num5  
DEFINE l_month1    LIKE type_file.num5
DEFINE l_year1     LIKE type_file.num5   
DEFINE l_tonum     LIKE type_file.num5
DEFINE l_chk_date1 LIKE type_file.dat
DEFINE l_day_std   LIKE type_file.num5
DEFINE l_date_1    LIKE type_file.dat
DEFINE l_date_2    LIKE type_file.dat


 
   DECLARE bill_liu_curs  CURSOR FOR  
    SELECT liu04,liu05,liu06,liu07,liu08  
      FROM liu_file WHERE liu01 = gs_lnt.lnt01 ORDER BY liu04
   FOREACH bill_liu_curs INTO l_liu.liu04,l_liu.liu05,l_liu.liu06,l_liu.liu07,l_liu.liu08 
      SELECT lnr03 INTO l_lnr03 FROM lnr_file WHERE lnr01 = l_liu.liu05
      IF l_lnr03 = 0 THEN                  #處理一次性付款
         LET gs_liw.liw01 = gs_lnt.lnt01 
         LET gs_liw.liw02 = gs_lnt.lnt02 
         
         LET gs_liw.liw04 = l_liu.liu04  
         LET gs_liw.liw05 = ''   
         IF gs_lnt.lnt58 = 'Y' THEN
            IF gs_llc.llc03 = '1' THEN 
               IF MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 > 12 OR MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 <0 THEN
                  LET l_tonum = (MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 )/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 ) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 -12*l_tonum
                  LET l_year = YEAR(gs_lnt.lnt21) + l_tonum 
               END IF
               IF MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(gs_lnt.lnt21)-1
               END IF
               IF  MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 <=12 AND MONTH(l_date) + l_liu.liu06 > 0 THEN
                  LET l_month = MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06
                  LET l_year = YEAR(gs_lnt.lnt21)
               END IF   
               LET l_day =  l_liu.liu07
               IF l_day > cl_days(l_year,l_month) THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                 LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
               END IF
               LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
            ELSE   
               IF MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 > 12 OR MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 <0 THEN
                  LET l_tonum = (MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 )/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 ) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 -12*l_tonum
                  LET l_year = YEAR(gs_lnt.lnt21) + l_tonum 
               END IF
               IF MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(gs_lnt.lnt21)-1
               END IF
               IF MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06 <=12 AND MONTH(l_date) + l_liu.liu06 >0 THEN
                  LET l_month = MONTH(gs_lnt.lnt21) + 1 + l_liu.liu06
                  LET l_year = YEAR(gs_lnt.lnt21)
               END IF 
               LET l_day =  cl_days(l_year,l_month)-l_liu.liu07+1
               IF l_day < = 0 THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                 LET l_day = cl_days(l_year,l_month)      #CHI-C70019 add 
               END IF
               LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
            END IF     
         ELSE
            IF gs_llc.llc03 = '1' THEN 
               IF MONTH(gs_lnt.lnt21) + l_liu.liu06 >12 OR MONTH(gs_lnt.lnt21)  + l_liu.liu06 <0 THEN
                 LET l_tonum = (MONTH(gs_lnt.lnt21) + l_liu.liu06)/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(gs_lnt.lnt21) + l_liu.liu06) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                 LET l_month = MONTH(gs_lnt.lnt21) + l_liu.liu06 -12*l_tonum
                 LET l_year = YEAR(gs_lnt.lnt21)+l_tonum
               END IF
               IF MONTH(gs_lnt.lnt21)  + l_liu.liu06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(gs_lnt.lnt21)-1
               END IF
               IF  MONTH(gs_lnt.lnt21)  + l_liu.liu06 <=12 AND MONTH(gs_lnt.lnt21) + l_liu.liu06 > 0 THEN 
                  LET l_month = MONTH(gs_lnt.lnt21) + l_liu.liu06 
                  LET l_year = YEAR(gs_lnt.lnt21)
               END IF
               LET l_day =  l_liu.liu07
               IF l_day > cl_days(l_year,l_month) THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                  LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
               END IF
               LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
            ELSE
               IF MONTH(gs_lnt.lnt21) + l_liu.liu06 >12 OR MONTH(gs_lnt.lnt21)  + l_liu.liu06 <0 THEN
                  LET l_tonum = (MONTH(gs_lnt.lnt21) + l_liu.liu06)/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(gs_lnt.lnt21) + l_liu.liu06) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(gs_lnt.lnt21) + l_liu.liu06 -12*l_tonum
                  LET l_year = YEAR(gs_lnt.lnt21)+l_tonum
               END IF
               IF MONTH(gs_lnt.lnt21)  + l_liu.liu06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(gs_lnt.lnt21)-1
               END IF
               IF MONTH(gs_lnt.lnt21)  + l_liu.liu06 <=12 AND MONTH(gs_lnt.lnt21) + l_liu.liu06 > 0 THEN 
                  LET l_month = MONTH(gs_lnt.lnt21) + l_liu.liu06 
                  LET l_year = YEAR(gs_lnt.lnt21)
               END IF
               LET l_day =  cl_days(l_year,l_month)-l_liu.liu07+1
               IF l_day < = 0 THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                  LET l_day = cl_days(l_year,l_month)          #CHI-C70019 add
               END IF
               LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
            END IF
         END IF 

         LET gs_liw.liw11 = 0                          #終止結算額         
         LET gs_liw.liw14 = 0                          #已收金額
         LET gs_liw.liw15 = 0                          #清算金額
         LET gs_liw.liw16 = ''                         #費用單號
         LET gs_liw.liw18 = ''                         #费用单项次
         LET gs_liw.liw17 = 'N'                        #結案否
         LET gs_liw.liwplant = gs_lnt.lntplant         #門店編號
         LET gs_liw.liwlegal = gs_lnt.lntlegal         #法人

         IF l_liu.liu08 = '1' OR gs_lla.lla05 = 'N' THEN
            SELECT MAX(liw03) INTO gs_liw.liw03 FROM liw_file WHERE liw01 = gs_lnt.lnt01
            IF cl_null(gs_liw.liw03) THEN 
               LET gs_liw.liw03 = 1
            ELSE 
               LET gs_liw.liw03 = gs_liw.liw03 +1
            END IF 
            LET gs_liw.liw07 = gs_lnt.lnt21
            LET gs_liw.liw08 = gs_lnt.lnt22  
            SELECT SUM(liv06) INTO gs_liw.liw09           #標準費用
              FROM liv_file
             WHERE liv01 = gs_lnt.lnt01
               AND liv02 = gs_lnt.lnt02
               AND liv05 = l_liu.liu04 
               AND liv04 BETWEEN gs_lnt.lnt21 AND gs_lnt.lnt22
               AND liv08 ='1'  
            IF cl_null(gs_liw.liw09) THEN         
               LET gs_liw.liw09=0
            END IF
          
            SELECT SUM(liv06) INTO gs_liw.liw10           #優惠費用
              FROM liv_file
             WHERE liv01 = gs_lnt.lnt01
               AND liv02 = gs_lnt.lnt02
               AND liv05 = l_liu.liu04 
               AND liv04 BETWEEN gs_lnt.lnt21 AND gs_lnt.lnt22
               AND liv08 ='2'  
            IF cl_null(gs_liw.liw10) THEN         
               LET gs_liw.liw10=0
            END IF
          #LET gs_liw.liw13 = gs_liw.liw09+gs_liw.liw10  #實際應收    #FUN-C80006 mark
          LET gs_liw.liw13 = gs_liw.liw09-gs_liw.liw10  #實際應收     #FUN-C80006 add
          IF gs_liw.liw13 = 0 THEN 
            #LET gs_liw.liw17 = 'Y'  #FUN-CA0081 Mark
          END IF
          SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
          LET gs_liw.liw13 = cl_digcut(gs_liw.liw13,l_azi04)
          #LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09+gs_liw.liw10)   #抹零金額    #FUN-C80006 mark
          LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09-gs_liw.liw10)   #抹零金額     #FUN-C80006 add
          
         #找出最大的日核算项次
            SELECT MAX(liv03) INTO l_n
              FROM liv_file
             WHERE liv01=gs_lnt.lnt01
            IF cl_null(l_n) THEN
               LET l_n=1
            ELSE
               LET l_n=l_n+1
            END IF
            LET l_liv.liv01=gs_lnt.lnt01
            LET l_liv.liv02=gs_lnt.lnt02
            LET l_liv.liv03=l_n
            LET l_liv.liv04=gs_liw.liw08
            LET l_liv.liv05=gs_liw.liw04
            LET l_liv.liv06=gs_liw.liw12
            LET l_liv.liv071 =''
            LET l_liv.liv08='4'
            LET l_liv.liv09='0'
            LET l_liv.livlegal = gs_lnt.lntlegal
            LET l_liv.livplant = gs_lnt.lntplant 
          #费用+账款日期+抹零类型 存在否
           SELECT COUNT(*) INTO l_n1 
             FROM liv_file
            WHERE liv01=gs_lnt.lnt01 #合同编号
              AND liv05=gs_liw.liw04 #费用编号
              AND liv04=gs_liw.liw08 
              AND liv08='4'          #抹零类型
         #不存在，则插入
           IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
              IF gs_liw.liw12 !=0 THEN
                 INSERT INTO liv_file VALUES(l_liv.*)
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','ins liv_file',SQLCA.sqlcode,1)
                     LET gs_success = 'N'
                  END IF
              END IF
           ELSE
              UPDATE liv_file SET liv06= gs_liw.liw12
               WHERE liv01=gs_lnt.lnt01
                 AND liv05=gs_liw.liw04
                 AND liv04=gs_liw.liw08 
                 AND liv08='4'
              IF SQLCA.sqlcode THEN
                 CALL s_errmsg('','','upd liv_file',SQLCA.sqlcode,1)
                 LET gs_success = 'N'
              END IF
            END IF
           #FUN-C20078 Begin---
           #IF gs_liw.liw10 <>0 OR gs_liw.liw11 <>0 OR gs_liw.liw12 <>0
           #   OR gs_liw.liw13 <>0 OR gs_liw.liw14 <>0 OR gs_liw.liw15 <>0 THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM liv_file
             WHERE liv01 = gs_lnt.lnt01
               AND liv04 BETWEEN gs_liw.liw07 AND gs_liw.liw08
               AND liv05 = gs_liw.liw04
            IF g_cnt > 0 THEN
           #FUN-C20078 End-----
               INSERT INTO liw_file VALUES (gs_liw.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins liw_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            CALL i400_ins_liw(l_liu.liu04,gs_lnt.lnt21,gs_lnt.lnt22,'Y')       #拆分出账区间
         END IF 
         CONTINUE FOREACH
      END IF
      
      #處理非一次性付款(不按自然月處理)
      #从开始账期+账期月份长度得到截止账期，出账日=开始账期-出账月+出账日
      IF gs_lnt.lnt45 ='N' THEN  
         LET l_bdate = gs_lnt.lnt21
         LET l_day_std = DAY(gs_lnt.lnt21)
         WHILE TRUE 
            IF (YEAR(gs_lnt.lnt21) <>  YEAR(gs_lnt.lnt22) OR MONTH(gs_lnt.lnt21) <> MONTH(gs_lnt.lnt22))
               AND  l_bdate=gs_lnt.lnt21 THEN
              IF MONTH(gs_lnt.lnt21)+l_lnr03 > 12 THEN
                 LET l_tonum = (MONTH(gs_lnt.lnt21)+l_lnr03)/12
                 LET l_year1 = YEAR(gs_lnt.lnt21) + l_tonum
                 LET l_month1 = MONTH(gs_lnt.lnt21)+l_lnr03-l_tonum*12
              ELSE
                 LET l_year1 = YEAR(gs_lnt.lnt21) 
                 LET l_month1 = MONTH(gs_lnt.lnt21)+l_lnr03
              END IF
              LET l_day1 = l_day_std-1
              IF l_day1 = 0 THEN
                 LET l_month1= l_month1 -1
                 IF l_month1 = 0 THEN 
                    LET l_month1 = 12 
                    LET l_year1 = l_year1 - 1
                 END IF
                 LET l_day1 = cl_days(l_year1,l_month1)
              ELSE
                 IF cl_days(l_year1,l_month1) < l_day1 THEN
                    LET l_day1 = cl_days(l_year1,l_month1)
                 END IF
              END IF
              LET l_edate = MDY(l_month1,l_day1,l_year1)
              IF l_edate  > gs_lnt.lnt22 THEN
                 LET l_edate = gs_lnt.lnt22
              END IF
              LET l_date = l_bdate
            ELSE
              LET l_year1 = YEAR(l_bdate)
              IF MONTH(l_bdate)+l_lnr03+1 >12 THEN
                 LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                 LET l_year1 = YEAR(l_bdate) + l_tonum
                 LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12+1
              ELSE
                 LET l_year1 = YEAR(l_bdate) 
                 LET l_month1 = MONTH(l_bdate)+l_lnr03+1
              END IF
              LET l_day1= l_day_std-1
              IF l_day1 = 0 THEN
                 LET l_month1= l_month1 -1
                 IF l_month1 = 0 THEN 
                    LET l_month1 = 12 
                    LET l_year1 = l_year1 - 1
                 END IF
                 LET l_day1 = cl_days(l_year1,l_month1)
              ELSE
                 IF cl_days(l_year1,l_month1) < l_day1 THEN
                    LET l_day1 = cl_days(l_year1,l_month1)
                 END IF
              END IF
              LET l_chk_date1 = MDY(l_month1,l_day1,l_year1)
              IF (YEAR(gs_lnt.lnt21)<>  YEAR(gs_lnt.lnt22) OR MONTH(gs_lnt.lnt21) <> MONTH(gs_lnt.lnt22))
                   AND l_chk_date1 > gs_lnt.lnt22    #最后零头小于1个月
                   AND gs_lnt.lnt59 = 'Y' THEN
                 
                 LET l_edate = gs_lnt.lnt22
                 LET l_date = l_bdate
                 
              ELSE
               #尾零不合并 或者 尾零合并零头大于1个月，单独为一个账期
                 IF MONTH(l_bdate)+l_lnr03 > 12 THEN
                    LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                    LET l_year1 = YEAR(l_bdate) + l_tonum
                    LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12
                 ELSE
                    LET l_year1 = YEAR(l_bdate) 
                    LET l_month1 = MONTH(l_bdate)+l_lnr03
                 END IF
                 LET l_day1 = l_day_std-1
                 IF l_day1 = 0 THEN
                    LET l_month1= l_month1 -1
                    IF l_month1 = 0 THEN 
                       LET l_month1 = 12 
                       LET l_year1 = l_year1 - 1
                    END IF
                    LET l_day1 = cl_days(l_year1,l_month1)
                 ELSE
                    IF cl_days(l_year1,l_month1) < l_day1 THEN
                       LET l_day1 = cl_days(l_year1,l_month1)
                    END IF
                 END IF
                 LET l_edate = MDY(l_month1,l_day1,l_year1)
                 IF l_edate > gs_lnt.lnt22 THEN
                    LET l_edate = gs_lnt.lnt22
                 END IF
                 LET l_date = l_bdate
              END IF
            END IF
            
            LET gs_liw.liw01 = gs_lnt.lnt01   #合同编号
            LET gs_liw.liw02 = gs_lnt.lnt02   #合同版本号
            LET gs_liw.liw04 = l_liu.liu04  
            LET gs_liw.liw05 = ''  
           
            IF gs_llc.llc03 = '1' THEN 
               IF MONTH(l_date) + l_liu.liu06 > 12 OR MONTH(l_date) + l_liu.liu06 < 0 THEN
                  LET l_tonum = (MONTH(l_date) + l_liu.liu06)/12 
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(l_date) + l_liu.liu06) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(l_date) + l_liu.liu06 -12*l_tonum
                  LET l_year = YEAR(l_date)  + l_tonum
               END IF
               IF MONTH(l_date) + l_liu.liu06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(l_date) -1
               END IF
               IF  MONTH(l_date) + l_liu.liu06 <=12 AND MONTH(l_date) + l_liu.liu06 >0 THEN 
                   LET l_month = MONTH(l_date) + l_liu.liu06
                   LET l_year = YEAR(l_date)
               END IF
               LET l_day =  l_liu.liu07
               IF l_day > cl_days(l_year,l_month) THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                  LET l_day = cl_days(l_year,l_month)         #CHI-C70019 add
               END IF
               LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
            ELSE
               IF MONTH(l_date) + l_liu.liu06 > 12 OR MONTH(l_date) + l_liu.liu06 < 0 THEN
                  LET l_tonum = (MONTH(l_date) + l_liu.liu06)/12 
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(l_date) + l_liu.liu06) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(l_date) + l_liu.liu06 -12*l_tonum
                  LET l_year = YEAR(l_date)  + l_tonum
               END IF
               IF MONTH(l_date) + l_liu.liu06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(l_date) -1
               END IF
               IF  MONTH(l_date) + l_liu.liu06 <=12  AND MONTH(l_date) + l_liu.liu06  > 0 THEN 
                   LET l_month = MONTH(l_date) + l_liu.liu06
                   LET l_year = YEAR(l_date)
               END IF
               LET l_day =  cl_days(l_year,l_month)-l_liu.liu07+1
               IF l_day < = 0 THEN
                  #CHI-C70019 mark START
                  #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
                  #LET  gs_success = 'N'
                  #EXIT FOREACH
                  #CHI-C70019 mark END
                   LET l_day = cl_days(l_year,l_month)     #CHI-C70019 add
               END IF
               LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
            END IF
            LET gs_liw.liw11 = 0              #终止结算额 
            LET gs_liw.liw14 = 0 
            LET gs_liw.liw15 = 0              #清算金额
            LET gs_liw.liw16 = ''             #费用单号
            LET gs_liw.liw18 = ''             #费用单项次
            LET gs_liw.liw17 = 'N'            #结案否
            LET gs_liw.liwplant = gs_lnt.lntplant 
            LET gs_liw.liwlegal = gs_lnt.lntlegal 

            IF gs_lla.lla05 = 'N' THEN
               SELECT MAX(liw03) INTO gs_liw.liw03 FROM liw_file WHERE liw01 = gs_lnt.lnt01
               IF cl_null(gs_liw.liw03) THEN 
                  LET gs_liw.liw03 = 1
               ELSE 
                  LET gs_liw.liw03 = gs_liw.liw03 +1
               END IF 
               LET gs_liw.liw07 = l_bdate        #账单起日
               LET gs_liw.liw08 = l_edate        #账单止日
         
               SELECT SUM(liv06) INTO gs_liw.liw09           #標準費用
                 FROM liv_file
                WHERE liv01 = gs_lnt.lnt01
                  AND liv02 = gs_lnt.lnt02
                  AND liv05 = l_liu.liu04 
                  AND liv04 BETWEEN l_bdate AND l_edate
                  AND liv08 ='1'  
               IF cl_null(gs_liw.liw09) THEN         
                  LET gs_liw.liw09=0
               END IF
          
               SELECT SUM(liv06) INTO gs_liw.liw10           #優惠費用
                 FROM liv_file
                WHERE liv01 = gs_lnt.lnt01
                  AND liv02 = gs_lnt.lnt02
                  AND liv05 = l_liu.liu04 
                  AND liv04 BETWEEN l_bdate AND l_edate
                  AND liv08 ='2'  
               IF cl_null(gs_liw.liw10) THEN         
                  LET gs_liw.liw10=0
               END IF
         
               #LET gs_liw.liw13 = gs_liw.liw09+gs_liw.liw10  #實際應收         #FUN-C80006 mark
               LET gs_liw.liw13 = gs_liw.liw09-gs_liw.liw10  #實際應收          #FUN-C80006 add
               SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
               LET gs_liw.liw13 = cl_digcut(gs_liw.liw13,l_azi04)
               #LET gs_liw.liw12 = gs_liw.liw13 -(gs_liw.liw09+gs_liw.liw10)   #抹零金額     #FUN-C80006 mark
               LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09-gs_liw.liw10)   #抹零金額     #FUN-C80006 add
          
              #找出最大的日核算项次
               SELECT MAX(liv03) INTO l_n
                 FROM liv_file
                WHERE liv01=gs_lnt.lnt01
               IF cl_null(l_n) THEN
                  LET l_n=1
               ELSE
                  LET l_n=l_n+1
               END IF
               LET l_liv.liv01=gs_lnt.lnt01
               LET l_liv.liv02=gs_lnt.lnt02
               LET l_liv.liv03=l_n
               LET l_liv.liv04=gs_liw.liw08
               LET l_liv.liv05=gs_liw.liw04
               LET l_liv.liv06=gs_liw.liw12
               LET l_liv.liv071=''
               LET l_liv.liv08='4'
               LET l_liv.liv09='0'
               LET l_liv.livlegal = gs_lnt.lntlegal
               LET l_liv.livplant = gs_lnt.lntplant

            #费用+账款日期+抹零类型 存在否
               SELECT COUNT(*) INTO l_n1 
                 FROM liv_file
                WHERE liv01=gs_lnt.lnt01 #合同编号
                  AND liv05=gs_liw.liw04 #费用编号
                  AND liv04=gs_liw.liw08
                  AND liv08='4'          #抹零类型
            #不存在，则插入
               IF l_n1 =0 THEN
            #且抹零金额不等于0,才插入资料则插入
                  IF gs_liw.liw12 !=0 THEN
                     INSERT INTO liv_file VALUES(l_liv.*)
                     IF SQLCA.sqlcode THEN
                        CALL s_errmsg('','','ins liv_file',SQLCA.sqlcode,1)
                        LET gs_success = 'N'
                     END IF
                  END IF
               ELSE
                  UPDATE liv_file SET liv06= gs_liw.liw12
                   WHERE liv01=gs_lnt.lnt01
                     AND liv05=gs_liw.liw04
                     AND liv04=gs_liw.liw08
                     AND liv08='4'
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','upd liv_file',SQLCA.sqlcode,1)
                     LET gs_success = 'N'
                  END IF
               END IF
              #FUN-C20078 Begin---
              #IF gs_liw.liw10 <>0 OR gs_liw.liw11 <>0 OR gs_liw.liw12 <>0
              #   OR gs_liw.liw13 <>0 OR gs_liw.liw14 <>0 OR gs_liw.liw15 <>0 THEN
               LET g_cnt = 0
               SELECT COUNT(*) INTO g_cnt FROM liv_file
                WHERE liv01 = gs_lnt.lnt01
                  AND liv04 BETWEEN gs_liw.liw07 AND gs_liw.liw08
                  AND liv05 = gs_liw.liw04
               IF g_cnt > 0 THEN
              #FUN-C20078 End-----
                  INSERT INTO liw_file VALUES (gs_liw.*)
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','ins liw_file',SQLCA.sqlcode,1)
                     LET gs_success = 'N'
                  END IF
               END IF
            ELSE
               CALL i400_ins_liw(l_liu.liu04,l_bdate,l_edate,'Y')
            END IF 
            IF l_edate >= gs_lnt.lnt22 THEN
               EXIT WHILE
            END IF 
            LET l_bdate = l_edate + 1
           
            END WHILE
      ELSE
      #處理非一次性付款(按自然月處理)
         LET l_bdate = gs_lnt.lnt21
         WHILE TRUE 
             
         ##產生第一個帳期時判斷合同期間大於1個月 + 殘月 + 首零合併 
         IF (YEAR(gs_lnt.lnt21) <>  YEAR(gs_lnt.lnt22) OR MONTH(gs_lnt.lnt21) <> MONTH(gs_lnt.lnt22))
             AND  l_bdate=gs_lnt.lnt21 AND gs_lnt.lnt21 <> MDY(MONTH(gs_lnt.lnt21),1,YEAR(gs_lnt.lnt21))
             AND gs_lnt.lnt58 = 'Y' THEN
             IF MONTH(gs_lnt.lnt21)+l_lnr03 > 12 THEN
                LET l_tonum = (MONTH(gs_lnt.lnt21)+l_lnr03)/12
                LET l_year1 = YEAR(gs_lnt.lnt21) + l_tonum
                LET l_month1 = MONTH(gs_lnt.lnt21)+l_lnr03-l_tonum*12
             ELSE
                LET l_year1 = YEAR(gs_lnt.lnt21) 
                LET l_month1 = MONTH(gs_lnt.lnt21)+l_lnr03
             END IF
             LET l_day1 = cl_days(l_year1,l_month1)
            LET l_edate = MDY(l_month1,l_day1,l_year1)
            IF l_edate  > gs_lnt.lnt22 THEN
               LET l_edate = gs_lnt.lnt22
            END IF
            IF MONTH(gs_lnt.lnt21)+1 > 12 THEN
                LET l_year1 = YEAR(gs_lnt.lnt21) +1
                LET l_month1 = MONTH(gs_lnt.lnt21) +1-12
            ELSE
                LET l_year1  = YEAR(gs_lnt.lnt21)
                LET l_month1 = MONTH(gs_lnt.lnt21) +1
            END IF
            LET l_date = MDY(l_month1,1,l_year1)
         ELSE
            ##產生最後幾個帳期的時候判斷是否尾零合併
            IF MONTH(l_bdate)+l_lnr03-1 >12 THEN
               LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
               LET l_year1 =  YEAR(l_bdate)+ l_tonum
               LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12-1
            ELSE
               LET l_year1 = YEAR(l_bdate)
               LET l_month1 = MONTH(l_bdate)+l_lnr03-1
            END IF
           #Add By shi Begin---
            LET l_date_1 = MDY(l_month1,1,l_year1)
            IF MONTH(gs_lnt.lnt22) -1 = 0 THEN
               LET l_date_2 = MDY(12,1,YEAR(gs_lnt.lnt22)-1)
            ELSE
               LET l_date_2 = MDY(MONTH(gs_lnt.lnt22)-1,1,YEAR(gs_lnt.lnt22))
            END IF
           #Add By shi End-----
            IF (YEAR(gs_lnt.lnt21)<>  YEAR(gs_lnt.lnt22) OR MONTH(gs_lnt.lnt21) <> MONTH(gs_lnt.lnt22))
               #AND MONTH(l_bdate)+l_lnr03-1= MONTH(gs_lnt.lnt22) -1 
                AND l_date_1 = l_date_2 #Mod By shi
                AND DAY(gs_lnt.lnt22) <> cl_days(YEAR(gs_lnt.lnt22),MONTH(gs_lnt.lnt22))
                AND gs_lnt.lnt59 = 'Y' THEN
               LET l_edate = gs_lnt.lnt22
               LET l_date = l_bdate   
            ELSE
               IF MONTH(l_bdate)+l_lnr03-1 >12 THEN
                  LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                  LET l_year1 =  YEAR(l_bdate)+ l_tonum
                  LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12-1
               ELSE
                  LET l_year1 = YEAR(l_bdate) 
                  LET l_month1 = MONTH(l_bdate)+l_lnr03-1
               END IF 
               LET l_day1 = cl_days(l_year1,l_month1)
               LET l_edate = MDY(l_month1,l_day1,l_year1)
               IF l_edate>gs_lnt.lnt22 THEN LET l_edate = gs_lnt.lnt22 END IF
               LET l_date = l_bdate 
            END IF
         END IF
         LET gs_liw.liw01 = gs_lnt.lnt01   #合同编号
         LET gs_liw.liw02 = gs_lnt.lnt02   #合同版本号
        
         LET gs_liw.liw04 = l_liu.liu04  
         LET gs_liw.liw05 = ''  
         IF gs_llc.llc03 = '1' THEN 
            IF MONTH(l_date) + l_liu.liu06 > 12 OR MONTH(l_date) + l_liu.liu06 < 0 THEN
               LET l_tonum = (MONTH(l_date) + l_liu.liu06)/12 
              #FUN-C40097 Add Begin ---
               IF (MONTH(l_date) + l_liu.liu06) < 0 THEN
                  LET l_tonum = l_tonum - 1
               END IF
              #FUN-C40097 Add End -----
               LET l_month = MONTH(l_date) + l_liu.liu06 -12*l_tonum
               LET l_year = YEAR(l_date)  + l_tonum
            END IF
            IF MONTH(l_date) + l_liu.liu06 = 0 THEN
               LET l_month = 12
               LET l_year = YEAR(l_date) -1
            END IF
            IF  MONTH(l_date) + l_liu.liu06 <=12 AND MONTH(l_date) + l_liu.liu06 >0 THEN 
                LET l_month = MONTH(l_date) + l_liu.liu06
                LET l_year = YEAR(l_date)
            END IF
            LET l_day =  l_liu.liu07
            IF l_day > cl_days(l_year,l_month) THEN
              #CHI-C70019 mark START
              #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
              #LET  gs_success = 'N'
              #EXIT FOREACH
              #CHI-C70019 mark END
               LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
            END IF
            LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
         ELSE
            IF MONTH(l_date) + l_liu.liu06 > 12 OR MONTH(l_date) + l_liu.liu06 < 0 THEN
               LET l_tonum = (MONTH(l_date) + l_liu.liu06)/12 
              #FUN-C40097 Add Begin ---
               IF (MONTH(l_date) + l_liu.liu06) < 0 THEN
                  LET l_tonum = l_tonum - 1
               END IF
              #FUN-C40097 Add End -----
               LET l_month = MONTH(l_date) + l_liu.liu06 -12*l_tonum
               LET l_year = YEAR(l_date)  + l_tonum
            END IF
            IF MONTH(l_date) + l_liu.liu06 = 0 THEN
               LET l_month = 12
               LET l_year = YEAR(l_date) -1
            END IF
            IF  MONTH(l_date) + l_liu.liu06 <=12  AND MONTH(l_date) + l_liu.liu06  > 0 THEN 
                  LET l_month = MONTH(l_date) + l_liu.liu06
                  LET l_year = YEAR(l_date)
            END IF
            LET l_day =  cl_days(l_year,l_month)-l_liu.liu07+1
            IF l_day < = 0 THEN
               #CHI-C70019 mar START
               #CALL s_errmsg('liu04',l_liu.liu04,'','alm-900',1)
               #LET  gs_success = 'N'
               #EXIT FOREACH
               #CHI-C70019 mark END
                LET l_day = cl_days(l_year,l_month)        #CHI-C70019 add
            END IF
            LET gs_liw.liw06 = MDY(l_month,l_day,l_year)
         END IF
         
         LET gs_liw.liw11 = 0              #终止结算额 
         LET gs_liw.liw14 = 0 
         LET gs_liw.liw15 = 0              #清算金额
         LET gs_liw.liw16 = ''             #费用单号
         LET gs_liw.liw18 = ''             #费用单项次
         LET gs_liw.liw17 = 'N'            #结案否
         LET gs_liw.liwplant = gs_lnt.lntplant 
         LET gs_liw.liwlegal = gs_lnt.lntlegal 

         IF gs_lla.lla05 = 'N' THEN
            SELECT MAX(liw03) INTO gs_liw.liw03 FROM liw_file WHERE liw01 = gs_lnt.lnt01
            IF cl_null(gs_liw.liw03) THEN 
               LET gs_liw.liw03 = 1
            ELSE 
               LET gs_liw.liw03 = gs_liw.liw03 +1
            END IF 
            LET gs_liw.liw07 = l_bdate        #账单起日
            LET gs_liw.liw08 = l_edate        #账单止日
         
            SELECT SUM(liv06) INTO gs_liw.liw09           #標準費用
              FROM liv_file
             WHERE liv01 = gs_lnt.lnt01
               AND liv02 = gs_lnt.lnt02
               AND liv05 = l_liu.liu04 
               AND liv04 BETWEEN l_bdate AND l_edate
               AND liv08 ='1'  
            IF cl_null(gs_liw.liw09) THEN         
               LET gs_liw.liw09=0
            END IF
          
            SELECT SUM(liv06) INTO gs_liw.liw10           #優惠費用
              FROM liv_file
             WHERE liv01 = gs_lnt.lnt01
               AND liv02 = gs_lnt.lnt02
               AND liv05 = l_liu.liu04 
               AND liv04 BETWEEN l_bdate AND l_edate
               AND liv08 ='2'  
            IF cl_null(gs_liw.liw10) THEN         
               LET gs_liw.liw10=0
            END IF
         
            #LET gs_liw.liw13 = gs_liw.liw09+gs_liw.liw10  #實際應收          #FUN-C80006 mark
            LET gs_liw.liw13 = gs_liw.liw09-gs_liw.liw10  #實際應收           #FUN-C80006 add
            SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
            LET gs_liw.liw13 = cl_digcut(gs_liw.liw13,l_azi04)
            #LET gs_liw.liw12 = gs_liw.liw13 -(gs_liw.liw09+gs_liw.liw10)   #抹零金額     #FUN-C80006 mark
            LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09-gs_liw.liw10)   #抹零金額     #FUN-C80006 add
          
          #找出最大的日核算项次
            SELECT MAX(liv03) INTO l_n
              FROM liv_file
             WHERE liv01=gs_lnt.lnt01
            IF cl_null(l_n) THEN
               LET l_n=1
            ELSE
               LET l_n=l_n+1
            END IF
            LET l_liv.liv01=gs_lnt.lnt01
            LET l_liv.liv02=gs_lnt.lnt02
            LET l_liv.liv03=l_n
            LET l_liv.liv04=gs_liw.liw08
            LET l_liv.liv05=gs_liw.liw04
            LET l_liv.liv06=gs_liw.liw12
            LET l_liv.liv071=''
            LET l_liv.liv08='4'
            LET l_liv.liv09='0'
            LET l_liv.livlegal = gs_lnt.lntlegal
            LET l_liv.livplant = gs_lnt.lntplant

         #费用+账款日期+抹零类型 存在否
            SELECT COUNT(*) INTO l_n1 
              FROM liv_file
             WHERE liv01=gs_lnt.lnt01 #合同编号
               AND liv05=gs_liw.liw04 #费用编号
               AND liv04=gs_liw.liw08
               AND liv08='4'          #抹零类型
         #不存在，则插入
            IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
               IF gs_liw.liw12 !=0 THEN
                  INSERT INTO liv_file VALUES(l_liv.*)
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','ins liw_file',SQLCA.sqlcode,1)
                     LET gs_success = 'N'
                  END IF
               END IF
            ELSE
               UPDATE liv_file SET liv06= gs_liw.liw12
                WHERE liv01=gs_lnt.lnt01
                  AND liv05=gs_liw.liw04
                  AND liv04=gs_liw.liw08
                  AND liv08='4'
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','upd liv_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
           #FUN-C20078 Begin---
           #IF gs_liw.liw10 <>0 OR gs_liw.liw11 <>0 OR gs_liw.liw12 <>0
           #    OR gs_liw.liw13 <>0 OR gs_liw.liw14 <>0 OR gs_liw.liw15 <>0 THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM liv_file
             WHERE liv01 = gs_lnt.lnt01
               AND liv04 BETWEEN gs_liw.liw07 AND gs_liw.liw08
               AND liv05 = gs_liw.liw04
            IF g_cnt > 0 THEN
           #FUN-C20078 End-----
               INSERT INTO liw_file VALUES (gs_liw.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins liw_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            CALL i400_ins_liw(l_liu.liu04,l_bdate,l_edate,'Y')
         END IF
         IF l_edate >= gs_lnt.lnt22 THEN
            EXIT WHILE
         END IF 
         IF MONTH(l_edate )+1 > 12 THEN
            LET l_bdate = MDY(MONTH(l_edate)+1- 12,1,YEAR(l_edate)+1)
         ELSE
            LET l_bdate = MDY(MONTH(l_edate)+ 1,1,YEAR(l_edate))
         END IF
         
         END WHILE
       END IF   
     END FOREACH
    
     IF gs_success = 'Y'  THEN
        DECLARE  sel_liw_curs CURSOR FOR SELECT * FROM liw_file
                                          WHERE liw01 = gs_lnt.lnt01 
                                       ORDER BY liw06 
        LET l_cnt = 0
        FOREACH sel_liw_curs INTO l_liw.*
          LET l_y = YEAR(l_liw.liw06)
          LET l_m = MONTH(l_liw.liw06)
          IF l_cnt = 0 THEN
             LET l_cnt = 1
             LET l_liw.liw05 = 1
          ELSE
             IF l_y <> l_y_t OR l_m <> l_m_t THEN
                LET l_cnt = l_cnt +1
                LET l_liw.liw05 = l_cnt
             ELSE
                LET l_liw.liw05 = l_cnt
             END IF
          END IF
          UPDATE liw_file SET liw05 = l_liw.liw05
           WHERE liw01 = gs_lnt.lnt01
             AND liw03 = l_liw.liw03
          IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','upd liw_file',SQLCA.sqlcode,1)
              LET gs_success = 'N'
          END IF 
          LET l_y_t = l_y
          LET l_m_t = l_m  
       END FOREACH
    END IF

END FUNCTION

FUNCTION t410_generate_bill()
DEFINE l_ljm       RECORD LIKE ljm_file.*
DEFINE l_ljp       RECORD LIKE ljp_file.*
DEFINE l_ljq       RECORD LIKE ljq_file.*
DEFINE l_lnr03     LIKE lnr_file.lnr03
DEFINE l_month     LIKE type_file.num5
DEFINE l_day       LIKE type_file.num5
DEFINE l_year      LIKE type_file.num5
DEFINE l_date      LIKE type_file.dat
DEFINE l_bdate     LIKE type_file.dat
DEFINE l_edate     LIKE type_file.dat
DEFINE l_azi04     LIKE azi_file.azi04
DEFINE l_n         LIKE type_file.num5
DEFINE l_n1        LIKE type_file.num5
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_y         LIKE type_file.num5  
DEFINE l_y_t       LIKE type_file.num5  
DEFINE l_m         LIKE type_file.num5  
DEFINE l_m_t       LIKE type_file.num5
DEFINE l_day1      LIKE type_file.num5  
DEFINE l_month1    LIKE type_file.num5
DEFINE l_year1     LIKE type_file.num5   
DEFINE l_tonum     LIKE type_file.num5
DEFINE l_begin_date LIKE type_file.dat
DEFINE l_end_date   LIKE type_file.dat
DEFINE l_day_std   LIKE type_file.num5
DEFINE l_chk_date1 LIKE type_file.dat
DEFINE l_date_1    LIKE type_file.dat
DEFINE l_date_2    LIKE type_file.dat

   DECLARE bill_ljm_curs  CURSOR FOR  
    SELECT DISTINCT ljm04,ljm05,ljm06,ljm07,ljm08  
      FROM ljp_file,ljm_file
      WHERE ljp05 = ljm04
        AND ljp01 = ljm01
        AND ljp01 = gs_lji.lji01
        AND ljp02 = gs_lji.lji05 ORDER BY ljm04
   FOREACH bill_ljm_curs  INTO l_ljm.ljm04,l_ljm.ljm05,l_ljm.ljm06,l_ljm.ljm07,l_ljm.ljm08
      SELECT lnr03 INTO l_lnr03 FROM lnr_file WHERE lnr01 = l_ljm.ljm05
      IF  gs_lji.lji02 = '3' THEN
          SELECT MIN(ljp04) INTO l_begin_date FROM ljp_file
           WHERE ljp01 = gs_lji.lji01 AND ljp02 = gs_lji.lji05
          SELECT MAX(ljp04) INTO l_end_date FROM ljp_file
           WHERE ljp01 = gs_lji.lji01 AND ljp02 = gs_lji.lji05
      ELSE
         LET l_begin_date = gs_lji.lji25
         LET l_end_date = gs_lji.lji26
      END IF
      IF l_lnr03 = 0 THEN                  #一次性付款
         LET gs_ljq.ljq01 = gs_lji.lji01   #合同編號
         LET gs_ljq.ljq02 = gs_lji.lji05   #合同版本
         
         LET gs_ljq.ljq04 = l_ljm.ljm04  
         LET gs_ljq.ljq05 = ''   
        
         IF gs_lji.lji20 = 'Y' AND gs_lji.lji02 <> '3' THEN         #首零合併且变更类型不为延期（延期单独算）
            IF gs_llc.llc03 = '1' THEN 
               IF MONTH(l_begin_date) + 1 + l_ljm.ljm06 > 12 OR MONTH(l_begin_date) + 1 + l_ljm.ljm06 <0 THEN
                  LET l_tonum = (MONTH(l_begin_date) + 1 + l_ljm.ljm06 )/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(l_begin_date) + 1 + l_ljm.ljm06 ) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(l_begin_date) + 1 + l_ljm.ljm06 -12*l_tonum
                  LET l_year = YEAR(l_begin_date) + l_tonum 
               END IF
               IF MONTH(l_begin_date) + 1 + l_ljm.ljm06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(l_begin_date) -1
               END IF
               IF  MONTH(l_begin_date) + 1 + l_ljm.ljm06 <=12 AND MONTH(l_date) + l_ljm.ljm06 > 0 THEN
                  LET l_month = MONTH(l_begin_date) + 1 + l_ljm.ljm06
                  LET l_year = YEAR(l_begin_date)
               END IF   
               LET l_day =  l_ljm.ljm07
               IF l_day > cl_days(l_year,l_month) THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('','','','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                  LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
               END IF
               LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
            ELSE   
               IF MONTH(l_begin_date) + 1 + l_ljm.ljm06 > 12 OR MONTH(l_begin_date) + 1 + l_ljm.ljm06 <0 THEN
                  LET l_tonum = (MONTH(l_begin_date) + 1 + l_ljm.ljm06 )/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(l_begin_date) + 1 + l_ljm.ljm06 ) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(l_begin_date) + 1 + l_ljm.ljm06 -12*l_tonum
                  LET l_year = YEAR(l_begin_date) + l_tonum 
               END IF
               IF MONTH(l_begin_date) + 1 + l_ljm.ljm06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(l_begin_date) -1
               END IF
               IF MONTH(l_begin_date) + 1 + l_ljm.ljm06 <=12 AND MONTH(l_date) + l_ljm.ljm06 >0 THEN
                  LET l_month = MONTH(l_begin_date) + 1 + l_ljm.ljm06
                  LET l_year = YEAR(l_begin_date)
               END IF 
               LET l_day =  cl_days(l_year,l_month)-l_ljm.ljm07+1
               IF l_day < = 0 THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('','','','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                  LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
               END IF
               LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
            END IF     
         ELSE
            IF gs_llc.llc03 = '1' THEN 
               IF MONTH(l_begin_date) + l_ljm.ljm06 >12 OR MONTH(l_begin_date)+ l_ljm.ljm06 <0 THEN
                  LET l_tonum = (MONTH(l_begin_date) + l_ljm.ljm06)/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(l_begin_date) + l_ljm.ljm06) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(l_begin_date) + l_ljm.ljm06 -12*l_tonum
                  LET l_year = YEAR(l_begin_date)+l_tonum
               END IF
               IF MONTH(l_begin_date)  + l_ljm.ljm06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(l_begin_date) -1
               END IF
               IF  MONTH(l_begin_date) + l_ljm.ljm06 <=12 AND MONTH(l_begin_date) + l_ljm.ljm06 > 0 THEN 
                  LET l_month = MONTH(l_begin_date) + l_ljm.ljm06 
                  LET l_year = YEAR(l_begin_date)
               END IF
               LET l_day =  l_ljm.ljm07
               IF l_day > cl_days(l_year,l_month) THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('','','','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                  LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
               END IF
               LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
            ELSE
               IF MONTH(l_begin_date) + l_ljm.ljm06 >12 OR MONTH(l_begin_date)  + l_ljm.ljm06 <0 THEN
                  LET l_tonum = (MONTH(l_begin_date) + l_ljm.ljm06)/12
                 #FUN-C40097 Add Begin ---
                  IF (MONTH(l_begin_date) + l_ljm.ljm06) < 0 THEN
                     LET l_tonum = l_tonum - 1
                  END IF
                 #FUN-C40097 Add End -----
                  LET l_month = MONTH(l_begin_date) + l_ljm.ljm06 -12*l_tonum
                  LET l_year = YEAR(l_begin_date)+l_tonum
               END IF
               IF MONTH(l_begin_date)  + l_ljm.ljm06 = 0 THEN
                  LET l_month = 12
                  LET l_year = YEAR(l_begin_date) -1
               END IF
               IF MONTH(l_begin_date)  + l_ljm.ljm06 <=12 AND MONTH(l_date) + l_ljm.ljm06 > 0 THEN 
                  LET l_month = MONTH(l_begin_date) + l_ljm.ljm06 
                  LET l_year = YEAR(l_begin_date)
               END IF
               LET l_day =  cl_days(l_year,l_month)-l_ljm.ljm07+1
               IF l_day < = 0 THEN
                 #CHI-C70019 mark START
                 #CALL s_errmsg('','','','alm-900',1)
                 #LET  gs_success = 'N'
                 #EXIT FOREACH
                 #CHI-C70019 mark END
                  LET l_day = cl_days(l_year,l_month)    #CHI-C70019 add
               END IF
               LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
            END IF
         END IF 
         LET gs_ljq.ljq11 = 0                          #終止結算額
         LET gs_ljq.ljq14 = 0                          #已收金額
         LET gs_ljq.ljq15 = 0                          #清算金額
         LET gs_ljq.ljq16 = ''                         #費用單號
         LET gs_ljq.ljq18 = ''                         #费用项次
         LET gs_ljq.ljq17 = 'N'                        #結案否
         LET gs_ljq.ljqplant = gs_lji.ljiplant         #門店編號
         LET gs_ljq.ljqlegal = gs_lji.ljilegal         #法人
         
         IF l_ljm.ljm08 = '1' THEN
            SELECT MAX(ljq03) INTO gs_ljq.ljq03 FROM ljq_file WHERE ljq01 = gs_lji.lji01 
            IF cl_null(gs_ljq.ljq03) THEN 
               LET gs_ljq.ljq03 = 1
            ELSE 
               LET gs_ljq.ljq03 = gs_ljq.ljq03 +1
            END IF 
            LET gs_ljq.ljq07 = l_begin_date
            LET gs_ljq.ljq08 = l_end_date 
            IF gs_lji.lji02 = '5' THEN
               SELECT SUM(ljp06) INTO gs_ljq.ljq11           #終止費用
                 FROM ljp_file
                WHERE ljp01 = gs_lji.lji01
                  AND ljp02 = gs_lji.lji05
                  AND ljp05 = l_ljm.ljm04 
                  AND ljp04 BETWEEN l_begin_date AND l_end_date
                  AND ljp08 ='3'  
               IF cl_null(gs_ljq.ljq11) THEN         
                  LET gs_ljq.ljq11=0
               END IF
               LET gs_ljq.ljq09 = 0 
               LET gs_ljq.ljq10 = 0
               LET gs_ljq.ljq13 = gs_ljq.ljq11
               IF gs_ljq.ljq13 = 0 THEN
                 #LET gs_ljq.ljq17 ='Y' #TQC-C20395
               END IF
               SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
               LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
               LET gs_ljq.ljq12 = gs_ljq.ljq13 - gs_ljq.ljq11  #抹零金額
            ELSE
               SELECT SUM(ljp06) INTO gs_ljq.ljq09           #標準費用
                 FROM ljp_file
                WHERE ljp01 = gs_lji.lji01
                  AND ljp02 = gs_lji.lji05
                  AND ljp05 = l_ljm.ljm04 
                  AND ljp04 BETWEEN l_begin_date AND l_end_date
                  AND ljp08 ='1'  
               IF cl_null(gs_ljq.ljq09) THEN         
                  LET gs_ljq.ljq09=0
               END IF
           
               SELECT SUM(ljp06) INTO gs_ljq.ljq10           #優惠費用
                 FROM ljp_file
                WHERE ljp01 = gs_lji.lji01
                  AND ljp02 = gs_lji.lji05
                  AND ljp05 = l_ljm.ljm04 
                  AND ljp04 BETWEEN l_begin_date AND l_end_date
                  AND ljp08 ='2'  
               IF cl_null(gs_ljq.ljq10) THEN         
                  LET gs_ljq.ljq10=0
               END IF
            
               #LET gs_ljq.ljq13 = gs_ljq.ljq09+gs_ljq.ljq10  #實際應收       #FUN-C80006 mark
               LET gs_ljq.ljq13 = gs_ljq.ljq09-gs_ljq.ljq10  #實際應收        #FUN-C80006 add
               IF gs_ljq.ljq13 = 0 THEN
                 #LET gs_ljq.ljq17 ='Y' #TQC-C20395
               END IF
               SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
               LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
               #LET gs_ljq.ljq12 = gs_ljq.ljq13 -(gs_ljq.ljq09+gs_ljq.ljq10)  #抹零金額  #FUN-C80006 mark
               LET gs_ljq.ljq12 = gs_ljq.ljq13 -(gs_ljq.ljq09-gs_ljq.ljq10)  #抹零金額   #FUN-C80006 add
            END IF
         #找出最大的日核算项次
            SELECT MAX(ljp03) INTO l_n
              FROM ljp_file
             WHERE ljp01=gs_lji.lji01
            IF cl_null(l_n) THEN
               LET l_n=1
            ELSE
               LET l_n=l_n+1
            END IF
            LET l_ljp.ljp01=gs_lji.lji01
            LET l_ljp.ljp02=gs_lji.lji05
            LET l_ljp.ljp03=l_n
            LET l_ljp.ljp04=gs_ljq.ljq08
            LET l_ljp.ljp05=gs_ljq.ljq04
            LET l_ljp.ljp06=gs_ljq.ljq12
            LET l_ljp.ljp08='4'
            LET l_ljp.ljp09='0'
            LET l_ljp.ljplegal = gs_lji.ljilegal
            LET l_ljp.ljpplant = gs_lji.ljiplant 
          #费用+账款日期+抹零类型 存在否
            SELECT COUNT(*) INTO l_n1 
              FROM ljp_file
             WHERE ljp01=gs_lji.lji01 #合同编号
               AND ljp02=gs_lji.lji05
               AND ljp05=gs_ljq.ljq04 #费用编号
               AND ljp04=gs_ljq.ljq08 
               AND ljp08='4'          #抹零类型
         #不存在，则插入
            IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
               IF gs_ljq.ljq12 !=0 THEN
                  INSERT INTO ljp_file VALUES(l_ljp.*)
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','ins ljp_file',SQLCA.sqlcode,1)
                     LET gs_success = 'N'
                  END IF
               END IF
            ELSE
               UPDATE ljp_file SET ljp06= gs_ljq.ljq12
                WHERE ljp01=gs_lji.lji01
                  AND ljp02=gs_lji.lji05
                  AND ljp05=gs_ljq.ljq04
                  AND ljp04=gs_ljq.ljq08 
                  AND ljp08='4'
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','upd ljp_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
           #FUN-C20078 Begin---
           #IF gs_ljq.ljq10 <>0 OR gs_ljq.ljq11 <>0 OR gs_ljq.ljq12 <>0
           #   OR gs_ljq.ljq13 <>0 OR gs_ljq.ljq14 <>0 OR gs_ljq.ljq15 <>0 THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM ljp_file
             WHERE ljp01 = gs_lji.lji01
               AND ljp02 = gs_lji.lji05
               AND ljp04 BETWEEN gs_ljq.ljq07 AND gs_ljq.ljq08
               AND ljp05 = gs_ljq.ljq04
            IF g_cnt > 0 THEN
           #FUN-C20078 End-----
               INSERT INTO ljq_file VALUES (gs_ljq.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins ljq_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            CALL t410_ins_ljq(l_ljm.ljm04,l_begin_date,l_end_date,'Y')
         END IF
         CONTINUE FOREACH
      END IF

      #處理非一次性付款(不按自然月處理)
      IF gs_lji.lji19 = 'N' THEN
         LET l_bdate = l_begin_date
         LET l_day_std = DAY(l_begin_date)
         WHILE TRUE
          
         IF gs_lji.lji02 = '3' THEN
         
            IF MONTH(l_bdate)+l_lnr03+1 >12 THEN
               LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
               LET l_year1 = YEAR(l_bdate) + l_tonum
               LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12+1
            ELSE
               LET l_year1 = YEAR(l_bdate) 
               LET l_month1 = MONTH(l_bdate)+l_lnr03+1
            END IF
            LET l_day1= l_day_std-1
            IF l_day1 = 0 THEN
               LET l_month1= l_month1 -1
               IF l_month1 = 0 THEN 
                  LET l_month1 = 12 
                  LET l_year1 = l_year1 - 1
               END IF
               LET l_day1 = cl_days(l_year1,l_month1)
            ELSE
               IF cl_days(l_year1,l_month1) < l_day1 THEN
                  LET l_day1 = cl_days(l_year1,l_month1)
               END IF
            END IF
            LET l_chk_date1 = MDY(l_month1,l_day1,l_year1)

           IF (YEAR(l_begin_date) <>  YEAR(l_end_date) OR MONTH(l_begin_date) <> MONTH(l_end_date))
               AND  l_chk_date1 > l_end_date THEN
               LET l_edate = l_end_date
               LET l_date = l_bdate 
           ELSE
               IF MONTH(l_bdate)+l_lnr03-1 >12 THEN
                  LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                  LET l_year1 =  YEAR(l_bdate)+ l_tonum
                  LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12-1
               ELSE
                  LET l_year1 = YEAR(l_bdate) 
                  LET l_month1 = MONTH(l_bdate)+l_lnr03-1
               END IF 
               LET l_day1= l_day_std-1
               IF l_day1 = 0 THEN
                  LET l_month1= l_month1 -1
                  IF l_month1 = 0 THEN 
                     LET l_month1 = 12 
                     LET l_year1 = l_year1 - 1
                  END IF
                  LET l_day1 = cl_days(l_year1,l_month1)
               ELSE
                  IF cl_days(l_year1,l_month1) < l_day1 THEN
                     LET l_day1 = cl_days(l_year1,l_month1)
                  END IF
               END IF
                LET l_edate = MDY(l_month1,l_day1,l_year1)
                IF l_edate>l_end_date THEN LET l_edate = l_end_date END IF
                LET l_date = l_bdate 
            END IF
         ELSE
            IF  (YEAR(l_begin_date) <>  YEAR(l_end_date) OR MONTH(l_begin_date) <> MONTH(l_end_date))
               AND  l_bdate=l_begin_date THEN
              IF MONTH(l_begin_date)+l_lnr03 > 12 THEN
                 LET l_tonum = (MONTH(l_begin_date)+l_lnr03)/12
                 LET l_year1 = YEAR(l_begin_date) + l_tonum
                 LET l_month1 = MONTH(l_begin_date)+l_lnr03-l_tonum*12
              ELSE
                 LET l_year1 = YEAR(l_begin_date) 
                 LET l_month1 = MONTH(l_begin_date)+l_lnr03
              END IF
              LET l_day1 = l_day_std-1
              IF l_day1 = 0 THEN
                 LET l_month1= l_month1 -1
                 IF l_month1 = 0 THEN 
                    LET l_month1 = 12 
                    LET l_year1 = l_year1 - 1
                 END IF
                 LET l_day1 = cl_days(l_year1,l_month1)
              ELSE
                 IF cl_days(l_year1,l_month1) < l_day1 THEN
                    LET l_day1 = cl_days(l_year1,l_month1)
                 END IF
              END IF
              LET l_edate = MDY(l_month1,l_day1,l_year1)
              IF l_edate  > l_end_date THEN
                 LET l_edate = l_end_date
              END IF
              LET l_date = l_bdate
            ELSE
              IF MONTH(l_bdate)+l_lnr03+1 >12 THEN
                 LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                 LET l_year1 = YEAR(l_bdate) + l_tonum
                 LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12+1
              ELSE
                 LET l_year1 = YEAR(l_bdate) 
                 LET l_month1 = MONTH(l_bdate)+l_lnr03+1
              END IF
              LET l_day1= l_day_std-1
              IF l_day1 = 0 THEN
                 LET l_month1= l_month1 -1
                 IF l_month1 = 0 THEN 
                    LET l_month1 = 12 
                    LET l_year1 = l_year1 - 1
                 END IF
                 LET l_day1 = cl_days(l_year1,l_month1)
              ELSE
                 IF cl_days(l_year1,l_month1) < l_day1 THEN
                    LET l_day1 = cl_days(l_year1,l_month1)
                 END IF
              END IF
              LET l_chk_date1 = MDY(l_month1,l_day1,l_year1)

              IF (YEAR(l_begin_date) <>  YEAR(l_end_date) OR MONTH(l_begin_date) <> MONTH(l_end_date))
                  AND l_chk_date1 > l_end_date THEN
                  LET l_edate = l_end_date
                  LET l_date = l_bdate
              ELSE
                  IF MONTH(l_bdate)+l_lnr03 > 12 THEN
                     LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                     LET l_year1 = YEAR(l_bdate) + l_tonum
                     LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12
                  ELSE
                     LET l_year1 = YEAR(l_bdate) 
                     LET l_month1 = MONTH(l_bdate)+l_lnr03
                  END IF
                  LET l_day1 = l_day_std-1
                  IF l_day1 = 0 THEN
                     LET l_month1= l_month1 -1
                     IF l_month1 = 0 THEN 
                        LET l_month1 = 12 
                        LET l_year1 = l_year1 - 1
                     END IF
                     LET l_day1 = cl_days(l_year1,l_month1)
                  ELSE
                     IF cl_days(l_year1,l_month1) < l_day1 THEN
                        LET l_day1 = cl_days(l_year1,l_month1)
                     END IF
                  END IF
                  LET l_edate = MDY(l_month1,l_day1,l_year1)
                  IF l_edate > l_end_date THEN
                     LET l_edate = l_end_date
                  END IF
                  LET l_date = l_bdate
               END IF
            END IF
         END IF
         LET gs_ljq.ljq01 = gs_lji.lji01   #合同变更编号
         LET gs_ljq.ljq02 = gs_lji.lji05   #合同版本号
         LET gs_ljq.ljq04 = l_ljm.ljm04  
         LET gs_ljq.ljq05 = ''  
         IF gs_llc.llc03 = '1' THEN 
            IF MONTH(l_date) + l_ljm.ljm06 > 12 OR MONTH(l_date) + l_ljm.ljm06 < 0 THEN
               LET l_tonum = (MONTH(l_date) + l_ljm.ljm06)/12 
              #FUN-C40097 Add Begin ---
               IF (MONTH(l_date) + l_ljm.ljm06) < 0 THEN
                  LET l_tonum = l_tonum - 1
               END IF
              #FUN-C40097 Add End -----
               LET l_month = MONTH(l_date) + l_ljm.ljm06 -12*l_tonum
               LET l_year = YEAR(l_date)  + l_tonum
            END IF
            IF MONTH(l_date)  + l_ljm.ljm06 = 0 THEN
               LET l_month = 12
               LET l_year = YEAR(l_date) -1
            END IF
            IF  MONTH(l_date) + l_ljm.ljm06 <=12 AND MONTH(l_date) + l_ljm.ljm06 >0 THEN 
                LET l_month = MONTH(l_date) + l_ljm.ljm06
                LET l_year = YEAR(l_date)
            END IF
            LET l_day =  l_ljm.ljm07
            IF l_day > cl_days(l_year,l_month) THEN
              #CHI-C70019 mark START
              #CALL s_errmsg('','','','alm-900',1)
              #LET  gs_success = 'N'
              #EXIT FOREACH
              #CHI-C70019 mark END
               LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
            END IF
            LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
         ELSE
            IF MONTH(l_date) + l_ljm.ljm06 > 12 OR MONTH(l_date) + l_ljm.ljm06 < 0 THEN
               LET l_tonum = (MONTH(l_date) + l_ljm.ljm06)/12 
              #FUN-C40097 Add Begin ---
               IF (MONTH(l_date) + l_ljm.ljm06) < 0 THEN
                  LET l_tonum = l_tonum - 1
               END IF
              #FUN-C40097 Add End -----
               LET l_month = MONTH(l_date) + l_ljm.ljm06 -12*l_tonum
               LET l_year = YEAR(l_date)  + l_tonum
            END IF
            IF MONTH(l_date)  + l_ljm.ljm06 = 0 THEN
               LET l_month = 12
               LET l_year = YEAR(l_date) -1
            END IF
            IF  MONTH(l_date) + l_ljm.ljm06 <=12  AND MONTH(l_date) + l_ljm.ljm06  > 0 THEN 
                LET l_month = MONTH(l_date) + l_ljm.ljm06
                LET l_year = YEAR(l_date)
            END IF
            LET l_day =  cl_days(l_year,l_month)-l_ljm.ljm07+1
            IF l_day < = 0 THEN
               #CHI-C70019 mark START
               #CALL s_errmsg('','','','alm-900',1)
               #LET  gs_success = 'N'
               #EXIT FOREACH
               #CHI-C70019 mark END
                LET l_day = cl_days(l_year,l_month)    #CHI-C70019 add
            END IF
            LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
         END IF

         LET gs_ljq.ljq11 = 0              #终止结算额 
         LET gs_ljq.ljq14 = 0 
         LET gs_ljq.ljq15 = 0              #清算金额
         LET gs_ljq.ljq16 = ''             #费用单号
         LET gs_ljq.ljq18 = ''             #费用项次
         LET gs_ljq.ljq17 = 'N'            #结案否
         LET gs_ljq.ljqplant = gs_lji.ljiplant 
         LET gs_ljq.ljqlegal = gs_lji.ljilegal 
         
         IF gs_lla.lla05 = 'N' THEN
            LET gs_ljq.ljq07 = l_bdate        #账单起日
            LET gs_ljq.ljq08 = l_edate        #账单止日
            SELECT MAX(ljq03) INTO gs_ljq.ljq03 FROM ljq_file WHERE ljq01 = gs_lji.lji01 
            IF cl_null(gs_ljq.ljq03) THEN 
               LET gs_ljq.ljq03 = 1
            ELSE 
               LET gs_ljq.ljq03 = gs_ljq.ljq03 +1
            END IF 
            IF gs_lji.lji02 = '5' THEN
               SELECT SUM(ljp06) INTO gs_ljq.ljq11           #終止費用
                 FROM ljp_file
                WHERE ljp01 = gs_lji.lji01
                  AND ljp02 = gs_lji.lji05
                  AND ljp05 = l_ljm.ljm04
                  AND ljp04 BETWEEN l_bdate AND l_edate
                  AND ljp08 ='3'  
               IF cl_null(gs_ljq.ljq11) THEN         
                 LET gs_ljq.ljq11=0
               END IF
               LET gs_ljq.ljq09 = 0 
               LET gs_ljq.ljq10 = 0 
               LET gs_ljq.ljq13 = gs_ljq.ljq11
               IF gs_ljq.ljq13 = 0 THEN
                 #LET gs_ljq.ljq17 ='Y' #TQC-C20395
               END IF
              SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
              LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
              LET gs_ljq.ljq12 = gs_ljq.ljq13 - gs_ljq.ljq11   #抹零金額
           ELSE
              SELECT SUM(ljp06) INTO gs_ljq.ljq09           #標準費用
                FROM ljp_file
               WHERE ljp01 = gs_lji.lji01
                 AND ljp02 = gs_lji.lji05
                 AND ljp05 = l_ljm.ljm04 
                 AND ljp04 BETWEEN l_bdate AND l_edate
                 AND ljp08 ='1'  
              IF cl_null(gs_ljq.ljq09) THEN         
                 LET gs_ljq.ljq09=0
              END IF
          
              SELECT SUM(ljp06) INTO gs_ljq.ljq10           #優惠費用
                FROM ljp_file
               WHERE ljp01 = gs_lji.lji01
                 AND ljp02 = gs_lji.lji05
                 AND ljp05 = l_ljm.ljm04 
                 AND ljp04 BETWEEN l_bdate AND l_edate
                 AND ljp08 ='2'  
              IF cl_null(gs_ljq.ljq10) THEN         
                 LET gs_ljq.ljq10=0
              END IF
              #LET gs_ljq.ljq13 = gs_ljq.ljq09+gs_ljq.ljq10  #實際應收     #FUN-C80006 mark
              LET gs_ljq.ljq13 = gs_ljq.ljq09-gs_ljq.ljq10  #實際應收      #FUN-C80006 add
              IF gs_ljq.ljq13 = 0 THEN
                #LET gs_ljq.ljq17 ='Y' #TQC-C20395
              END IF
              SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
              LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
              #LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09+gs_ljq.ljq10)  #抹零金額  #FUN-C80006 mark
              LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09-gs_ljq.ljq10)  #抹零金額   #FUN-C80006 add
           END IF


          #找出最大的日核算项次
            SELECT MAX(ljp03) INTO l_n
              FROM ljp_file
             WHERE ljp01=gs_lji.lji01
            IF cl_null(l_n) THEN
               LET l_n=1
            ELSE
               LET l_n=l_n+1
            END IF
            LET l_ljp.ljp01=gs_lji.lji01
            LET l_ljp.ljp02=gs_lji.lji05
            LET l_ljp.ljp03=l_n
            LET l_ljp.ljp04=gs_ljq.ljq08
            LET l_ljp.ljp05=gs_ljq.ljq04
            LET l_ljp.ljp06=gs_ljq.ljq12
            LET l_ljp.ljp08='4'
            LET l_ljp.ljp09='0'
            LET l_ljp.ljplegal = gs_lji.ljilegal
            LET l_ljp.ljpplant = gs_lji.ljiplant

         #费用+账款日期+抹零类型 存在否
            SELECT COUNT(*) INTO l_n1 
              FROM ljp_file
             WHERE ljp01=gs_lji.lji01 #合同变更编号
               AND ljp02=gs_lji.lji05
               AND ljp05=gs_ljq.ljq04 #费用编号
               AND ljp04=gs_ljq.ljq08
               AND ljp08='4'          #抹零类型
         #不存在，则插入
            IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
               IF gs_ljq.ljq12 !=0 THEN
                  INSERT INTO ljp_file VALUES(l_ljp.*)
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('','','ins ljq_file',SQLCA.sqlcode,1)
                     LET gs_success = 'N'
                  END IF
               END IF
            ELSE
               UPDATE ljp_file SET ljp06= gs_ljq.ljq12
                WHERE ljp01=gs_lji.lji01
                  AND ljp02=gs_lji.lji05
                  AND ljp05=gs_ljq.ljq04
                  AND ljp04=gs_ljq.ljq08
                  AND ljp08='4'
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','upd ljp_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         
           #FUN-C20078 Begin---
           #IF gs_ljq.ljq10 <>0 OR gs_ljq.ljq11 <>0 OR gs_ljq.ljq12 <>0
           #   OR gs_ljq.ljq13 <>0 OR gs_ljq.ljq14 <>0 OR gs_ljq.ljq15 <>0 THEN
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM ljp_file
             WHERE ljp01 = gs_lji.lji01
               AND ljp02 = gs_lji.lji05
               AND ljp04 BETWEEN gs_ljq.ljq07 AND gs_ljq.ljq08
               AND ljp05 = gs_ljq.ljq04
            IF g_cnt > 0 THEN
           #FUN-C20078 End-----
               INSERT INTO ljq_file VALUES (gs_ljq.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins ljq_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            CALL t410_ins_ljq(l_ljm.ljm04,l_bdate,l_edate,'Y')
         END IF
         IF l_edate >=  l_end_date THEN
            EXIT WHILE
         END IF 
         LET l_bdate = l_edate +1    
         END WHILE
      ELSE
         #處理非一次性付款(按自然月處理)
         LET l_bdate = l_begin_date
         WHILE TRUE
         
         IF gs_lji.lji02 = '3' THEN
           IF (YEAR(l_begin_date) <>  YEAR(l_end_date) OR MONTH(l_begin_date) <> MONTH(l_end_date))
               AND  MONTH(l_bdate)+l_lnr03-1= MONTH(l_end_date) -1 
               AND DAY(l_end_date) <> cl_days(YEAR(l_end_date),MONTH(l_end_date)) THEN
               LET l_edate = l_end_date
               LET l_date = l_bdate 
           ELSE
             IF MONTH(l_bdate)+l_lnr03-1 >12 THEN
                LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                LET l_year1 =  YEAR(l_bdate)+ l_tonum
                LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12-1
             ELSE
                LET l_year1 = YEAR(l_bdate) 
                LET l_month1 = MONTH(l_bdate)+l_lnr03-1
             END IF 
             LET l_day1 = cl_days(l_year1,l_month1)
             LET l_edate = MDY(l_month1,l_day1,l_year1)
             IF l_edate>l_end_date THEN LET l_edate = l_end_date END IF
             LET l_date = l_bdate 
           END IF
         ELSE
         ##產生第一個帳期時判斷合同期間大於1個月 + 殘月 + 首零合併 
         IF (YEAR(l_begin_date) <>  YEAR(l_end_date) OR MONTH(l_begin_date) <> MONTH(l_end_date))
             AND  l_bdate=l_begin_date AND l_begin_date <> MDY(MONTH(l_begin_date),1,YEAR(l_begin_date))
             AND gs_lji.lji20 = 'Y' THEN
             IF MONTH(l_begin_date)+l_lnr03 > 12 THEN
                LET l_tonum = (MONTH(l_begin_date)+l_lnr03)/12
                LET l_year1 = YEAR(l_begin_date) + l_tonum
                LET l_month1 = MONTH(l_begin_date)+l_lnr03-l_tonum*12
             ELSE
                LET l_year1 = YEAR(l_begin_date) 
                LET l_month1 = MONTH(l_begin_date)+l_lnr03
             END IF
             LET l_day1 = cl_days(l_year1,l_month1)
            LET l_edate = MDY(l_month1,l_day1,l_year1)
            IF l_edate  > l_end_date THEN
               LET l_edate = l_end_date
            END IF
            IF MONTH(l_begin_date)+1 > 12 THEN
                LET l_year1 = YEAR(l_begin_date) +1
                LET l_month1 = MONTH(l_begin_date) +1-12
            ELSE
                LET l_year1  = YEAR(l_begin_date)
                LET l_month1 = MONTH(l_begin_date) +1
            END IF
            LET l_date = MDY(l_month1,1,l_year1)
         ELSE
            IF MONTH(l_bdate)+l_lnr03-1 >12 THEN
               LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
               LET l_year1 =  YEAR(l_bdate)+ l_tonum
               LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12-1
            ELSE
               LET l_year1 = YEAR(l_bdate)
               LET l_month1 = MONTH(l_bdate)+l_lnr03-1
            END IF
            LET l_date_1 = MDY(l_month1,1,l_year1)
            IF MONTH(l_end_date) -1 = 0 THEN
               LET l_date_2 = MDY(12,1,YEAR(l_end_date)-1)
            ELSE
               LET l_date_2 = MDY(MONTH(l_end_date)-1,1,YEAR(l_end_date))
            END IF
            ##產生最後幾個帳期的時候判斷是否尾零合併
            IF (YEAR(l_begin_date)<>  YEAR(l_end_date) OR MONTH(l_begin_date) <> MONTH(l_end_date))
                AND l_date_1 = l_date_2
                AND DAY(l_end_date) <> cl_days(YEAR(l_end_date),MONTH(l_end_date))
                AND gs_lji.lji21 = 'Y' THEN
               LET l_edate = l_end_date
               LET l_date = l_bdate   
            ELSE
                  IF MONTH(l_bdate)+l_lnr03-1 >12 THEN
                     LET l_tonum = (MONTH(l_bdate)+l_lnr03)/12
                     LET l_year1 =  YEAR(l_bdate)+ l_tonum
                     LET l_month1 = MONTH(l_bdate)+l_lnr03-l_tonum*12-1
                  ELSE
                    LET l_year1 = YEAR(l_bdate) 
                    LET l_month1 = MONTH(l_bdate)+l_lnr03-1
                  END IF 
                  LET l_day1 = cl_days(l_year1,l_month1)
                  LET l_edate = MDY(l_month1,l_day1,l_year1)
                  IF l_edate>l_end_date THEN LET l_edate = l_end_date END IF
                  LET l_date = l_bdate 
            END IF
         END IF
         END IF
         LET gs_ljq.ljq01 = gs_lji.lji01   #合同变更编号
         LET gs_ljq.ljq02 = gs_lji.lji05   #合同版本号
        
         LET gs_ljq.ljq04 = l_ljm.ljm04  
         LET gs_ljq.ljq05 = ''  
         IF gs_llc.llc03 = '1' THEN 
            IF MONTH(l_date) + l_ljm.ljm06 > 12 OR MONTH(l_date) + l_ljm.ljm06 < 0 THEN
               LET l_tonum = (MONTH(l_date) + l_ljm.ljm06)/12 
              #FUN-C40097 Add Begin ---
               IF (MONTH(l_date) + l_ljm.ljm06) < 0 THEN
                  LET l_tonum = l_tonum - 1
               END IF
              #FUN-C40097 Add End -----
               LET l_month = MONTH(l_date) + l_ljm.ljm06 -12*l_tonum
               LET l_year = YEAR(l_date)  + l_tonum
            END IF
            IF MONTH(l_date)  + l_ljm.ljm06 = 0 THEN
               LET l_month = 12
               LET l_year = YEAR(l_date) -1
            END IF
            IF  MONTH(l_date) + l_ljm.ljm06 <=12 AND MONTH(l_date) + l_ljm.ljm06 >0 THEN 
                LET l_month = MONTH(l_date) + l_ljm.ljm06
                LET l_year = YEAR(l_date)
            END IF
            LET l_day =  l_ljm.ljm07
            IF l_day > cl_days(l_year,l_month) THEN
              #CHI-C70019 mark START
              #CALL s_errmsg('','','','alm-900',1)
              #LET  gs_success = 'N'
              #EXIT FOREACH
              #CHI-C70019 mark END
               LET l_day = cl_days(l_year,l_month)   #CHI-C70019 add
            END IF
            LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
         ELSE
            IF MONTH(l_date) + l_ljm.ljm06 > 12 OR MONTH(l_date) + l_ljm.ljm06 < 0 THEN
               LET l_tonum = (MONTH(l_date) + l_ljm.ljm06)/12 
              #FUN-C40097 Add Begin ---
               IF (MONTH(l_date) + l_ljm.ljm06) < 0 THEN
                  LET l_tonum = l_tonum - 1
               END IF
              #FUN-C40097 Add End -----
               LET l_month = MONTH(l_date) + l_ljm.ljm06 -12*l_tonum
               LET l_year = YEAR(l_date)  + l_tonum
            END IF
            IF MONTH(l_date)  + l_ljm.ljm06 = 0 THEN
               LET l_month = 12
               LET l_year = YEAR(l_date) -1
            END IF
            IF  MONTH(l_date) + l_ljm.ljm06 <=12  AND MONTH(l_date) + l_ljm.ljm06  > 0 THEN 
                LET l_month = MONTH(l_date) + l_ljm.ljm06
                LET l_year = YEAR(l_date)
            END IF
            LET l_day =  cl_days(l_year,l_month)-l_ljm.ljm07+1
            IF l_day < = 0 THEN
               #CHI-C70019 mark START
               #CALL s_errmsg('','','','alm-900',1)
               #LET  gs_success = 'N'
               #EXIT FOREACH
               #CHI-C70019 mark END
                LET l_day = cl_days(l_year,l_month)    #CHI-C70019 add
            END IF
            LET gs_ljq.ljq06 = MDY(l_month,l_day,l_year)
         END IF

         LET gs_ljq.ljq11 = 0              #终止结算额 
         LET gs_ljq.ljq14 = 0 
         LET gs_ljq.ljq15 = 0              #清算金额
         LET gs_ljq.ljq16 = ''             #费用单号
         LET gs_ljq.ljq18 = ''             #费用项次
         LET gs_ljq.ljq17 = 'N'            #结案否
         LET gs_ljq.ljqplant = gs_lji.ljiplant 
         LET gs_ljq.ljqlegal = gs_lji.ljilegal 
         IF gs_lla.lla05 = 'N' THEN
         
            LET gs_ljq.ljq07 = l_bdate        #账单起日
            LET gs_ljq.ljq08 = l_edate        #账单止日

            SELECT MAX(ljq03) INTO gs_ljq.ljq03 FROM ljq_file WHERE ljq01 = gs_lji.lji01
            IF cl_null(gs_ljq.ljq03) THEN 
               LET gs_ljq.ljq03 = 1
            ELSE 
               LET gs_ljq.ljq03 = gs_ljq.ljq03 +1
            END IF 
            IF gs_lji.lji02 = '5' THEN
               SELECT SUM(ljp06) INTO gs_ljq.ljq11           #終止費用
                 FROM ljp_file
                WHERE ljp01 = gs_lji.lji01
                  AND ljp02 = gs_lji.lji05
                  AND ljp05 = l_ljm.ljm04
                  AND ljp04 BETWEEN l_bdate AND l_edate
                  AND ljp08 ='3'  
               IF cl_null(gs_ljq.ljq11) THEN         
                 LET gs_ljq.ljq11=0
               END IF
               LET gs_ljq.ljq09 = 0 
               LET gs_ljq.ljq10 = 0 
               LET gs_ljq.ljq13 = gs_ljq.ljq11
               IF gs_ljq.ljq13 = 0 THEN
                 #LET gs_ljq.ljq17 ='Y' #TQC-C20395
               END IF
              SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
              LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
              LET gs_ljq.ljq12 = gs_ljq.ljq13 - gs_ljq.ljq11   #抹零金額
           ELSE
              SELECT SUM(ljp06) INTO gs_ljq.ljq09           #標準費用
                FROM ljp_file
               WHERE ljp01 = gs_lji.lji01
                 AND ljp02 = gs_lji.lji05
                 AND ljp05 = l_ljm.ljm04 
                 AND ljp04 BETWEEN l_bdate AND l_edate
                 AND ljp08 ='1'  
              IF cl_null(gs_ljq.ljq09) THEN         
                 LET gs_ljq.ljq09=0
              END IF
          
              SELECT SUM(ljp06) INTO gs_ljq.ljq10           #優惠費用
                FROM ljp_file
               WHERE ljp01 = gs_lji.lji01
                 AND ljp02 = gs_lji.lji05
                 AND ljp05 = l_ljm.ljm04 
                 AND ljp04 BETWEEN l_bdate AND l_edate
                 AND ljp08 ='2'  
              IF cl_null(gs_ljq.ljq10) THEN         
                 LET gs_ljq.ljq10=0
              END IF
              #LET gs_ljq.ljq13 = gs_ljq.ljq09+gs_ljq.ljq10  #實際應收   #FUN-C80006 mark
              LET gs_ljq.ljq13 = gs_ljq.ljq09-gs_ljq.ljq10  #實際應收    #FUN-C80006 add
              IF gs_ljq.ljq13 = 0 THEN
                #LET gs_ljq.ljq17 ='Y' #TQC-C20395
              END IF
              SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
              LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
              #LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09+gs_ljq.ljq10)  #抹零金額   #FUN-C80006 mark
              LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09-gs_ljq.ljq10)  #抹零金額    #FUN-C80006 add
           END IF
  
          #找出最大的日核算项次
             SELECT MAX(ljp03) INTO l_n
               FROM ljp_file
              WHERE ljp01=gs_lji.lji01
             IF cl_null(l_n) THEN
                LET l_n=1
             ELSE
                LET l_n=l_n+1
             END IF
             LET l_ljp.ljp01=gs_lji.lji01
             LET l_ljp.ljp02=gs_lji.lji05
             LET l_ljp.ljp03=l_n
             LET l_ljp.ljp04=gs_ljq.ljq08
             LET l_ljp.ljp05=gs_ljq.ljq04
             LET l_ljp.ljp06=gs_ljq.ljq12
             LET l_ljp.ljp08='4'
             LET l_ljp.ljp09='0'
             LET l_ljp.ljplegal = gs_lji.ljilegal
             LET l_ljp.ljpplant = gs_lji.ljiplant

         #费用+账款日期+抹零类型 存在否
             SELECT COUNT(*) INTO l_n1 
               FROM ljp_file
              WHERE ljp01=gs_lji.lji01 #合同变更编号
                AND ljp02=gs_lji.lji05
                AND ljp05=gs_ljq.ljq04 #费用编号
                AND ljp04=gs_ljq.ljq08
                AND ljp08='4'          #抹零类型
         #不存在，则插入
             IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
                IF gs_ljq.ljq12 !=0 THEN
                   INSERT INTO ljp_file VALUES(l_ljp.*)
                   IF SQLCA.sqlcode THEN
                      CALL s_errmsg('','','ins ljq_file',SQLCA.sqlcode,1)
                      LET gs_success = 'N'
                   END IF
                END IF
             ELSE
                UPDATE ljp_file SET ljp06= gs_ljq.ljq12
                 WHERE ljp01=gs_lji.lji01
                   AND ljp02=gs_lji.lji05
                   AND ljp05=gs_ljq.ljq04
                   AND ljp04=gs_ljq.ljq08
                   AND ljp08='4'
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('','','upd ljp_file',SQLCA.sqlcode,1)
                   LET gs_success = 'N'
                END IF
             END IF
         
            #FUN-C20078 Begin---
            #IF gs_ljq.ljq10 <>0 OR gs_ljq.ljq11 <>0 OR gs_ljq.ljq12 <>0
            #   OR gs_ljq.ljq13 <>0 OR gs_ljq.ljq14 <>0 OR gs_ljq.ljq15 <>0 THEN
             LET g_cnt = 0
             SELECT COUNT(*) INTO g_cnt FROM ljp_file
              WHERE ljp01 = gs_lji.lji01
                AND ljp02 = gs_lji.lji05
                AND ljp04 BETWEEN gs_ljq.ljq07 AND gs_ljq.ljq08
                AND ljp05 = gs_ljq.ljq04
             IF g_cnt > 0 THEN
            #FUN-C20078 End-----
                INSERT INTO ljq_file VALUES (gs_ljq.*)
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('','','ins ljq_file',SQLCA.sqlcode,1)
                   LET gs_success = 'N'
                END IF
             END IF
         ELSE
             CALL t410_ins_ljq(l_ljm.ljm04,l_bdate,l_edate,'Y')
         END IF
         IF l_edate >=  l_end_date THEN
            EXIT WHILE
         END IF 
         IF MONTH(l_edate )+1 > 12 THEN
            LET l_bdate = MDY(MONTH(l_edate)+1- 12,1,YEAR(l_edate)+1)
         ELSE
            LET l_bdate = MDY(MONTH(l_edate)+ 1,1,YEAR(l_edate))
         END IF
         
         END WHILE
       END IF
       
     END FOREACH
    
     IF gs_success = 'Y'  THEN
        DECLARE  sel_ljq_curs CURSOR FOR SELECT * FROM ljq_file
                                          WHERE ljq01 = gs_lji.lji01 
                                       ORDER BY ljq06 
        LET l_cnt = 0
        FOREACH sel_ljq_curs INTO l_ljq.*
          LET l_y = YEAR(l_ljq.ljq06)
          LET l_m = MONTH(l_ljq.ljq06)
          IF l_cnt = 0 THEN
             LET l_cnt = 1
             LET l_ljq.ljq05 = 1
          ELSE
             IF l_y <> l_y_t OR l_m <> l_m_t THEN
                LET l_cnt = l_cnt +1
                LET l_ljq.ljq05 = l_cnt
             ELSE
                LET l_ljq.ljq05 = l_cnt
             END IF
          END IF
          UPDATE ljq_file SET ljq05 = l_ljq.ljq05
           WHERE ljq01 = gs_lji.lji01
             AND ljq03 = l_ljq.ljq03
          IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','upd ljq_file',SQLCA.sqlcode,1)
              LET gs_success = 'N'
          END IF 
          LET l_y_t = l_y
          LET l_m_t = l_m  
       END FOREACH
      
    END IF


END FUNCTION

#同一个出账日，产生费用单之前要拆分出账区间。按月来拆分
FUNCTION  i400_ins_liw(p_fno,p_bdate,p_edate,p_m)
DEFINE  p_fno        LIKE liu_file.liu04
DEFINE  p_bdate      LIKE type_file.dat     #出账开始时间
DEFINE  p_edate      LIKE type_file.dat     #出账截止日期
DEFINE  p_m          LIKE type_file.chr1    #按自然月与否
DEFINE  l_month      LIKE type_file.num5
DEFINE  l_day        LIKE type_file.num5
DEFINE  l_year       LIKE type_file.num5
DEFINE  l_bdate      LIKE type_file.dat
DEFINE  l_edate      LIKE type_file.dat
DEFINE  l_date       LIKE type_file.dat
DEFINE  l_azi04      LIKE azi_file.azi04
DEFINE  l_liv        RECORD LIKE liv_file.*
DEFINE  l_n         LIKE type_file.num5
DEFINE  l_n1        LIKE type_file.num5
DEFINE  l_cnt       LIKE type_file.num5
DEFINE  l_day_std   LIKE type_file.num5

    IF YEAR(p_bdate) = YEAR(p_edate) AND MONTH(p_bdate) = MONTH(p_edate) THEN
       SELECT MAX(liw03) INTO gs_liw.liw03 FROM liw_file WHERE liw01 = gs_lnt.lnt01
       IF cl_null(gs_liw.liw03) THEN 
          LET gs_liw.liw03 = 1
       ELSE 
          LET gs_liw.liw03 = gs_liw.liw03 +1
       END IF 
       LET gs_liw.liw07 = p_bdate
       LET gs_liw.liw08 = p_edate  
       SELECT SUM(liv06) INTO gs_liw.liw09           #標準費用
         FROM liv_file
        WHERE liv01 = gs_lnt.lnt01
          AND liv02 = gs_lnt.lnt02
          AND liv05 = p_fno 
          AND liv04 BETWEEN p_bdate AND p_edate
          AND liv08 ='1'  
       IF cl_null(gs_liw.liw09) THEN         
          LET gs_liw.liw09=0
       END IF
          
       SELECT SUM(liv06) INTO gs_liw.liw10           #優惠費用
         FROM liv_file
        WHERE liv01 = gs_lnt.lnt01
          AND liv02 = gs_lnt.lnt02
          AND liv05 = p_fno 
          AND liv04 BETWEEN p_bdate AND p_edate
          AND liv08 ='2'  
       IF cl_null(gs_liw.liw10) THEN         
          LET gs_liw.liw10=0
       END IF
       #LET gs_liw.liw13 = gs_liw.liw09+gs_liw.liw10  #實際應收          #FUN-C80006 mark
       LET gs_liw.liw13 = gs_liw.liw09-gs_liw.liw10  #實際應收           #FUN-C80006 add
       IF gs_liw.liw13 = 0 THEN 
         #LET gs_liw.liw17 = 'Y'  #FUN-CA0081 Mark
       END IF
       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
       LET gs_liw.liw13 = cl_digcut(gs_liw.liw13,l_azi04)
       #LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09+gs_liw.liw10)   #抹零金額    #FUN-C80006 mark
       LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09-gs_liw.liw10)   #抹零金額     #FUN-C80006 add

      #找出最大的日核算项次
          SELECT MAX(liv03) INTO l_n
            FROM liv_file
           WHERE liv01=gs_lnt.lnt01
          IF cl_null(l_n) THEN
             LET l_n=1
          ELSE
             LET l_n=l_n+1
          END IF
          LET l_liv.liv01=gs_lnt.lnt01
          LET l_liv.liv02=gs_lnt.lnt02
          LET l_liv.liv03=l_n
          LET l_liv.liv04=gs_liw.liw08
          LET l_liv.liv05=gs_liw.liw04
          LET l_liv.liv06=gs_liw.liw12
          LET l_liv.liv071 =''
          LET l_liv.liv08='4'
          LET l_liv.liv09='0'
          LET l_liv.livlegal = gs_lnt.lntlegal
          LET l_liv.livplant = gs_lnt.lntplant 
          #费用+账款日期+抹零类型 存在否
          SELECT COUNT(*) INTO l_n1 
            FROM liv_file
           WHERE liv01=gs_lnt.lnt01 #合同编号
             AND liv05=gs_liw.liw04 #费用编号
             AND liv04=gs_liw.liw08
             AND liv08='4'          #抹零类型
         #不存在，则插入
         IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
            IF gs_liw.liw12 !=0 THEN
               INSERT INTO liv_file VALUES(l_liv.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins liv_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            UPDATE liv_file SET liv06= gs_liw.liw12
             WHERE liv01=gs_lnt.lnt01
               AND liv05=gs_liw.liw04
               AND liv04=gs_liw.liw08
               AND liv08='4'
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','upd liv_file',SQLCA.sqlcode,1)
               LET gs_success = 'N'
            END IF
         END IF
      #FUN-C20078 Begin---
      #IF gs_liw.liw10 <>0 OR gs_liw.liw11 <>0 OR gs_liw.liw12 <>0
      #     OR gs_liw.liw13 <>0 OR gs_liw.liw14 <>0 OR gs_liw.liw15 <>0 THEN
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt FROM liv_file
        WHERE liv01 = gs_lnt.lnt01
          AND liv04 BETWEEN gs_liw.liw07 AND gs_liw.liw08
          AND liv05 = gs_liw.liw04
       IF g_cnt > 0 THEN
      #FUN-C20078 End-----
          INSERT INTO liw_file VALUES (gs_liw.*)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','ins liw_file',SQLCA.sqlcode,1)
             LET gs_success = 'N'
          END IF
       END IF
    ELSE
       LET l_bdate = p_bdate
       LET l_day_std = DAY(p_bdate)
       WHILE TRUE
          LET gs_liw.liw17 = 'N' 
          LET gs_liw.liw09 = ''
          LET gs_liw.liw10 = ''
          IF l_bdate = p_bdate THEN
             IF p_m = 'Y' THEN    #按自然月拆分
                LET l_year = YEAR(p_bdate)
                LET l_month = MONTH(p_bdate)
                LET l_day = cl_days(l_year,l_month)
                LET l_edate = MDY(l_month,l_day,l_year)
             ELSE                 #不按自然月拆分
                IF MONTH(p_bdate)+1 >12 THEN
                   LET l_year = YEAR(p_bdate)+1
                   LET l_month = 1
                ELSE
                   LET l_year = YEAR(p_bdate)
                   LET l_month = MONTH(p_bdate)+1
                END IF
                IF l_day_std-1 = 0 THEN
                   LET l_month = l_month -1
                   IF l_month = 0 THEN
                      LET l_year = l_year-1
                      LET l_month=12
                   END IF
                   LET l_day = cl_days(l_year,l_month)
                ELSE
                   IF cl_days(l_year,l_month)<=l_day_std-1 THEN
                      LET l_day = cl_days(l_year,l_month)
                   ELSE
                      LET l_day = l_day_std-1
                   END IF
                END IF
                LET l_edate = MDY(l_month,l_day,l_year)
                IF l_edate > p_edate THEN
                   LET l_edate = p_edate
                END IF
             END IF
          ELSE
             IF p_m = 'Y' THEN    #按自然月拆分
                LET l_year = YEAR(l_bdate)
                LET l_month = MONTH(l_bdate)
                LET l_day = cl_days(l_year,l_month)
                LET l_edate = MDY(l_month,l_day,l_year)
                IF l_edate > p_edate THEN
                   LET l_edate = p_edate
                END IF
             ELSE                  #不按自然月拆分
                IF MONTH(l_bdate)+1 >12 THEN
                   LET l_year = YEAR(l_bdate)+1
                   LET l_month = 1
                ELSE
                   LET l_year = YEAR(l_bdate)
                   LET l_month = MONTH(l_bdate)+1
                END IF
                IF l_day_std-1 = 0 THEN
                   LET l_month = l_month -1
                   IF l_month = 0 THEN
                      LET l_year = l_year-1
                      LET l_month=12
                   END IF
                   LET l_day = cl_days(l_year,l_month)
                ELSE
                   IF cl_days(l_year,l_month)<=l_day_std-1 THEN
                      LET l_day = cl_days(l_year,l_month)
                   ELSE
                      LET l_day = l_day_std-1
                   END IF
                END IF
                LET l_edate = MDY(l_month,l_day,l_year)
                IF l_edate > p_edate THEN
                   LET l_edate = p_edate
                END IF
             END IF
          END IF
          SELECT MAX(liw03) INTO gs_liw.liw03 FROM liw_file WHERE liw01 = gs_lnt.lnt01
          IF cl_null(gs_liw.liw03) THEN 
             LET gs_liw.liw03 = 1
          ELSE 
             LET gs_liw.liw03 = gs_liw.liw03 +1
          END IF 
          LET gs_liw.liw07 = l_bdate
          LET gs_liw.liw08 = l_edate 
          SELECT SUM(liv06) INTO gs_liw.liw09           #標準費用
            FROM liv_file
           WHERE liv01 = gs_lnt.lnt01
             AND liv02 = gs_lnt.lnt02
             AND liv05 = p_fno 
             AND liv04 BETWEEN l_bdate AND l_edate
             AND liv08 ='1'  
          IF cl_null(gs_liw.liw09) THEN         
             LET gs_liw.liw09=0
          END IF
          
          SELECT SUM(liv06) INTO gs_liw.liw10           #優惠費用
            FROM liv_file
           WHERE liv01 = gs_lnt.lnt01
             AND liv02 = gs_lnt.lnt02
             AND liv05 = p_fno 
             AND liv04 BETWEEN l_bdate AND l_edate
             AND liv08 ='2'  
          IF cl_null(gs_liw.liw10) THEN         
             LET gs_liw.liw10=0
          END IF
          #LET gs_liw.liw13 = gs_liw.liw09+gs_liw.liw10  #實際應收     #FUN-C80006 mark
          LET gs_liw.liw13 = gs_liw.liw09-gs_liw.liw10  #實際應收      #FUN-C80006 add
          IF gs_liw.liw13 = 0 THEN 
            #LET gs_liw.liw17 = 'Y'  #FUN-CA0081 Mark
          END IF
          SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
          LET gs_liw.liw13 = cl_digcut(gs_liw.liw13,l_azi04)
          #LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09+gs_liw.liw10) #抹零金額       #FUN-C80006 mark
          LET gs_liw.liw12 = gs_liw.liw13 - (gs_liw.liw09-gs_liw.liw10) #抹零金額        #FUN-C80006 add

          #找出最大的日核算项次
          SELECT MAX(liv03) INTO l_n
            FROM liv_file
           WHERE liv01=gs_lnt.lnt01
          IF cl_null(l_n) THEN
             LET l_n=1
          ELSE
             LET l_n=l_n+1
          END IF
          LET l_liv.liv01=gs_lnt.lnt01
          LET l_liv.liv02=gs_lnt.lnt02
          LET l_liv.liv03=l_n
          LET l_liv.liv04=gs_liw.liw08
          LET l_liv.liv05=gs_liw.liw04
          LET l_liv.liv06=gs_liw.liw12
          LET l_liv.liv071=''
          LET l_liv.liv08='4'
          LET l_liv.liv09='0'
          LET l_liv.livlegal = gs_lnt.lntlegal
          LET l_liv.livplant = gs_lnt.lntplant

         #费用+账款日期+抹零类型 存在否
          SELECT COUNT(*) INTO l_n1 
            FROM liv_file
           WHERE liv01=gs_lnt.lnt01 #合同编号
             AND liv05=gs_liw.liw04 #费用编号
             AND liv04=gs_liw.liw08
             AND liv08='4'          #抹零类型
         #不存在，则插入
         IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
            IF gs_liw.liw12 !=0 THEN
               INSERT INTO liv_file VALUES(l_liv.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins liv_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            UPDATE liv_file SET liv06= gs_liw.liw12
             WHERE liv01=gs_lnt.lnt01
               AND liv05=gs_liw.liw04
               AND liv04=gs_liw.liw08
               AND liv08='4'
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','upd liv_file',SQLCA.sqlcode,1)
               LET gs_success = 'N'
            END IF
         END IF
         #FUN-C20078 Begin---
         #IF gs_liw.liw10 <>0 OR gs_liw.liw11 <>0 OR gs_liw.liw12 <>0
         #  OR gs_liw.liw13 <>0 OR gs_liw.liw14 <>0 OR gs_liw.liw15 <>0 THEN
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM liv_file
           WHERE liv01 = gs_lnt.lnt01
             AND liv04 BETWEEN gs_liw.liw07 AND gs_liw.liw08
             AND liv05 = gs_liw.liw04
          IF g_cnt > 0 THEN
         #FUN-C20078 End-----
             INSERT INTO liw_file VALUES (gs_liw.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','ins liw_file',SQLCA.sqlcode,1)
                LET gs_success = 'N'
             END IF
          END IF
          IF MONTH(l_bdate)+1 >12 THEN
             LET l_year = YEAR(l_bdate) +1
             LET l_month = MONTH(l_bdate)+1-12
          ELSE
             LET l_year = YEAR(l_bdate)
             LET l_month = MONTH(l_bdate)+1
          END IF
          IF p_m = 'Y' THEN
             LET l_bdate = MDY(l_month,1,l_year)
          ELSE
             IF l_day_std-1 = 0 THEN
                LET l_month = l_month-1
                IF l_month = 0 THEN
                   LET l_month =12
                   LET l_year = l_year-1
                END IF
                LET l_day = cl_days(l_year,l_month)
             ELSE
                IF cl_days(l_year,l_month) <= l_day_std-1 THEN
                   LET l_day = cl_days(l_year,l_month)
                ELSE
                   LET l_day = l_day_std-1
                END IF
             END IF
             LET l_bdate = MDY(l_month,l_day,l_year)+1
          END IF
          IF l_bdate > p_edate THEN
             EXIT WHILE
          END IF
       END WHILE
    END IF

END FUNCTION


FUNCTION t410_ins_ljq(p_fno,p_bdate,p_edate,p_m)
DEFINE  p_fno        LIKE liu_file.liu04
DEFINE  p_bdate      LIKE type_file.dat     #出账开始时间
DEFINE  p_edate      LIKE type_file.dat     #出账截止日期
DEFINE  p_m          LIKE type_file.chr1    #按自然月与否
DEFINE  l_month      LIKE type_file.num5
DEFINE  l_day        LIKE type_file.num5
DEFINE  l_year       LIKE type_file.num5
DEFINE  l_bdate      LIKE type_file.dat
DEFINE  l_edate      LIKE type_file.dat
DEFINE  l_date       LIKE type_file.dat
DEFINE  l_azi04      LIKE azi_file.azi04
DEFINE  l_ljp        RECORD LIKE ljp_file.*
DEFINE  l_n         LIKE type_file.num5
DEFINE  l_n1        LIKE type_file.num5
DEFINE  l_cnt       LIKE type_file.num5
DEFINE  l_day_std    LIKE type_file.num5

    IF YEAR(p_bdate) = YEAR(p_edate) AND MONTH(p_bdate) = MONTH(p_edate) THEN
       SELECT MAX(ljq03) INTO gs_ljq.ljq03 FROM ljq_file WHERE ljq01 = gs_lji.lji01
       IF cl_null(gs_ljq.ljq03) THEN 
          LET gs_ljq.ljq03 = 1
       ELSE 
          LET gs_ljq.ljq03 = gs_ljq.ljq03 +1
       END IF 
       LET gs_ljq.ljq07 = p_bdate
       LET gs_ljq.ljq08 = p_edate  
       IF gs_lji.lji02 = '5' THEN
          SELECT SUM(ljp06) INTO gs_ljq.ljq11           #終止費用
            FROM ljp_file
           WHERE ljp01 = gs_lji.lji01
             AND ljp02 = gs_lji.lji05
             AND ljp05 = p_fno
             AND ljp04 BETWEEN p_bdate AND p_edate
             AND ljp08 ='3'  
          IF cl_null(gs_ljq.ljq11) THEN         
             LET gs_ljq.ljq11=0
          END IF
          LET gs_ljq.ljq09 = 0 
          LET gs_ljq.ljq10 = 0 
          LET gs_ljq.ljq13 = gs_ljq.ljq11
          IF gs_ljq.ljq13 = 0 THEN
            #LET gs_ljq.ljq17 ='Y' #TQC-C20395
          END IF
          SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
          LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
          LET gs_ljq.ljq12 = gs_ljq.ljq13 - gs_ljq.ljq11   #抹零金額
       ELSE
          SELECT SUM(ljp06) INTO gs_ljq.ljq09           #標準費用
            FROM ljp_file
           WHERE ljp01 = gs_lji.lji01
             AND ljp02 = gs_lji.lji05
             AND ljp05 = p_fno 
             AND ljp04 BETWEEN p_bdate AND p_edate
             AND ljp08 ='1'  
          IF cl_null(gs_ljq.ljq09) THEN         
             LET gs_ljq.ljq09=0
          END IF
          
          SELECT SUM(ljp06) INTO gs_ljq.ljq10           #優惠費用
            FROM ljp_file
           WHERE ljp01 = gs_lji.lji01
             AND ljp02 = gs_lji.lji05
             AND ljp05 = p_fno 
             AND ljp04 BETWEEN p_bdate AND p_edate
             AND ljp08 ='2'  
          IF cl_null(gs_ljq.ljq10) THEN         
             LET gs_ljq.ljq10=0
          END IF
          #LET gs_ljq.ljq13 = gs_ljq.ljq09+gs_ljq.ljq10  #實際應收    #FUN-C80006 mark
          LET gs_ljq.ljq13 = gs_ljq.ljq09-gs_ljq.ljq10  #實際應收     #FUN-C80006 add
          IF gs_ljq.ljq13 = 0 THEN
            #LET gs_ljq.ljq17 ='Y' #TQC-C20395
          END IF
          SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
          LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
          #LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09+gs_ljq.ljq10)  #抹零金額   #FUN-C80006 mark
          LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09-gs_ljq.ljq10)  #抹零金額    #FUN-C80006 add
       END IF
        #找出最大的日核算项次
          SELECT MAX(ljp03) INTO l_n
            FROM ljp_file
           WHERE ljp01=gs_lji.lji01
          IF cl_null(l_n) THEN
             LET l_n=1
          ELSE
             LET l_n=l_n+1
          END IF
          LET l_ljp.ljp01=gs_lji.lji01
          LET l_ljp.ljp02=gs_lji.lji05
          LET l_ljp.ljp03=l_n
          LET l_ljp.ljp04=gs_ljq.ljq08
          LET l_ljp.ljp05=gs_ljq.ljq04
          LET l_ljp.ljp06=gs_ljq.ljq12
          LET l_ljp.ljp08='4'
          LET l_ljp.ljp09='0'
          LET l_ljp.ljplegal = gs_lji.ljilegal
          LET l_ljp.ljpplant = gs_lji.ljiplant

         #费用+账款日期+抹零类型 存在否
          SELECT COUNT(*) INTO l_n1 
            FROM ljp_file
           WHERE ljp01=gs_lji.lji01 #合同变更编号
             AND ljp02=gs_lji.lji05
             AND ljp05=gs_ljq.ljq04 #费用编号
             AND ljp04=gs_ljq.ljq08
             AND ljp08='4'          #抹零类型
         #不存在，则插入
         IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
            IF gs_ljq.ljq12 !=0 THEN
               INSERT INTO ljp_file VALUES(l_ljp.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins ljp_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            UPDATE ljp_file SET ljp06= gs_ljq.ljq12
             WHERE ljp01=gs_lji.lji01
               AND ljp02=gs_lji.lji05
               AND ljp05=gs_ljq.ljq04
               AND ljp04=gs_ljq.ljq08
               AND ljp08='4'
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','upd ljp_file',SQLCA.sqlcode,1)
               LET gs_success = 'N'
            END IF
         END IF
      #FUN-C20078 Begin---
      #IF gs_ljq.ljq10 <>0 OR gs_ljq.ljq11 <>0 OR gs_ljq.ljq12 <>0
      #     OR gs_ljq.ljq13 <>0 OR gs_ljq.ljq14 <>0 OR gs_ljq.ljq15 <>0 THEN
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt FROM ljp_file
        WHERE ljp01 = gs_lji.lji01
          AND ljp02 = gs_lji.lji05
          AND ljp04 BETWEEN gs_ljq.ljq07 AND gs_ljq.ljq08
          AND ljp05 = gs_ljq.ljq04
       IF g_cnt > 0 THEN
      #FUN-C20078 End-----
          INSERT INTO ljq_file VALUES (gs_ljq.*)
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','ins ljq_file',SQLCA.sqlcode,1)
             LET gs_success = 'N'
          END IF
       END IF
    ELSE
       LET l_bdate = p_bdate
       LET l_day_std = DAY(p_bdate)
       WHILE TRUE
          LET gs_ljq.ljq09 = ''
          LET gs_ljq.ljq10 = ''
          LET gs_ljq.ljq11 = 0 
          LET gs_ljq.ljq17 = 'N'
          
          IF l_bdate = p_bdate THEN
             IF p_m = 'Y' THEN
                LET l_year = YEAR(p_bdate)
                LET l_month = MONTH(p_bdate)
                LET l_day = cl_days(l_year,l_month)
                LET l_edate = MDY(l_month,l_day,l_year)
             ELSE                 #不按自然月拆分
                IF MONTH(p_bdate)+1 >12 THEN
                   LET l_year = YEAR(p_bdate)+1
                   LET l_month = 1
                ELSE
                   LET l_year = YEAR(p_bdate)
                   LET l_month = MONTH(p_bdate)+1
                END IF
                IF l_day_std-1 = 0 THEN
                   LET l_month = l_month -1
                   IF l_month = 0 THEN
                      LET l_year = l_year-1
                      LET l_month=12
                   END IF
                   LET l_day = cl_days(l_year,l_month)
                ELSE
                   IF cl_days(l_year,l_month)<=l_day_std-1 THEN
                      LET l_day = cl_days(l_year,l_month)
                   ELSE
                      LET l_day = l_day_std-1
                   END IF
                END IF
                LET l_edate = MDY(l_month,l_day,l_year)
                IF l_edate > p_edate THEN
                   LET l_edate = p_edate
                END IF
             END IF
          ELSE
             IF p_m = 'Y' THEN
                LET l_year = YEAR(l_bdate)
                LET l_month = MONTH(l_bdate)
                LET l_day = cl_days(l_year,l_month)
                LET l_edate = MDY(l_month,l_day,l_year)
                IF l_edate > p_edate THEN
                   LET l_edate = p_edate
                END IF
             ELSE                  #不按自然月拆分
                IF MONTH(l_bdate)+1 >12 THEN
                   LET l_year = YEAR(l_bdate)+1
                   LET l_month = 1
                ELSE
                   LET l_year = YEAR(l_bdate)
                   LET l_month = MONTH(l_bdate)+1
                END IF
                IF l_day_std-1 = 0 THEN
                   LET l_month = l_month -1
                   IF l_month = 0 THEN
                      LET l_year = l_year-1
                      LET l_month=12
                   END IF
                   LET l_day = cl_days(l_year,l_month)
                ELSE
                   IF cl_days(l_year,l_month)<=l_day_std-1 THEN
                      LET l_day = cl_days(l_year,l_month)
                   ELSE
                      LET l_day = l_day_std-1
                   END IF
                END IF
                LET l_edate = MDY(l_month,l_day,l_year)
                IF l_edate > p_edate THEN
                   LET l_edate = p_edate
                END IF
             END IF
          END IF
          SELECT MAX(ljq03) INTO gs_ljq.ljq03 FROM ljq_file WHERE ljq01 = gs_lji.lji01
          IF cl_null(gs_ljq.ljq03) THEN 
             LET gs_ljq.ljq03 = 1
          ELSE 
             LET gs_ljq.ljq03 = gs_ljq.ljq03 +1
          END IF 
          LET gs_ljq.ljq07 = l_bdate
          LET gs_ljq.ljq08 = l_edate 
          IF gs_lji.lji02 = '5' THEN
             SELECT SUM(ljp06) INTO gs_ljq.ljq11           #終止費用
               FROM ljp_file
              WHERE ljp01 = gs_lji.lji01
                AND ljp02 = gs_lji.lji05
                AND ljp05 = p_fno
                AND ljp04 BETWEEN l_bdate AND l_edate
                AND ljp08 ='3'  
             IF cl_null(gs_ljq.ljq11) THEN         
                LET gs_ljq.ljq11=0
             END IF
             LET gs_ljq.ljq09 = 0 
             LET gs_ljq.ljq10 = 0
             LET gs_ljq.ljq13 = gs_ljq.ljq11
             IF gs_ljq.ljq13 = 0 THEN
               #LET gs_ljq.ljq17 ='Y' #TQC-C20395
             END IF
             SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
             LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
             LET gs_ljq.ljq12 = gs_ljq.ljq13 - gs_ljq.ljq11  #抹零金額
          ELSE
             SELECT SUM(ljp06) INTO gs_ljq.ljq09           #標準費用
               FROM ljp_file
              WHERE ljp01 = gs_lji.lji01
                AND ljp02 = gs_lji.lji05
                AND ljp05 = p_fno 
                AND ljp04 BETWEEN l_bdate AND l_edate
                AND ljp08 ='1'  
             IF cl_null(gs_ljq.ljq09) THEN         
                LET gs_ljq.ljq09=0
             END IF
          
             SELECT SUM(ljp06) INTO gs_ljq.ljq10           #優惠費用
               FROM ljp_file
              WHERE ljp01 = gs_lji.lji01
                AND ljp02 = gs_lji.lji05
                AND ljp05 = p_fno 
                AND ljp04 BETWEEN l_bdate AND l_edate
                AND ljp08 ='2'  
             IF cl_null(gs_ljq.ljq10) THEN         
                LET gs_ljq.ljq10=0
             END IF
             #LET gs_ljq.ljq13 = gs_ljq.ljq09+gs_ljq.ljq10  #實際應收  #FUN-C80006 mark
             LET gs_ljq.ljq13 = gs_ljq.ljq09-gs_ljq.ljq10  #實際應收   #FUN-C80006 add
             IF gs_ljq.ljq13 = 0 THEN
               #LET gs_ljq.ljq17 ='Y' #TQC-C20395
             END IF 
             SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = g_aza.aza17
             LET gs_ljq.ljq13 = cl_digcut(gs_ljq.ljq13,l_azi04)
             #LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09+gs_ljq.ljq10) #抹零金額   #FUN-C80006 mark
             LET gs_ljq.ljq12 = gs_ljq.ljq13 - (gs_ljq.ljq09-gs_ljq.ljq10) #抹零金額    #FUN-C80006 add
          END IF
           #找出最大的日核算项次
          SELECT MAX(ljp03) INTO l_n
            FROM ljp_file
           WHERE ljp01=gs_lji.lji01
          IF cl_null(l_n) THEN
             LET l_n=1
          ELSE
             LET l_n=l_n+1
          END IF
          LET l_ljp.ljp01=gs_lji.lji01
          LET l_ljp.ljp02=gs_lji.lji05
          LET l_ljp.ljp03=l_n
          LET l_ljp.ljp04=gs_ljq.ljq08
          LET l_ljp.ljp05=gs_ljq.ljq04
          LET l_ljp.ljp06=gs_ljq.ljq12
          LET l_ljp.ljp08='4'
          LET l_ljp.ljp09='0'
          LET l_ljp.ljplegal = gs_lji.ljilegal
          LET l_ljp.ljpplant = gs_lji.ljiplant

         #费用+账款日期+抹零类型 存在否
          SELECT COUNT(*) INTO l_n1 
            FROM ljp_file
           WHERE ljp01=gs_lji.lji01 #合同变更编号
             AND ljp02=gs_lji.lji05
             AND ljp05=gs_ljq.ljq04 #费用编号
             AND ljp04=gs_ljq.ljq08
             AND ljp08='4'          #抹零类型
         #不存在，则插入
         IF l_n1 =0 THEN
         #且抹零金额不等于0,才插入资料则插入
            IF gs_ljq.ljq12 !=0 THEN
               INSERT INTO ljp_file VALUES(l_ljp.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins ljp_file',SQLCA.sqlcode,1)
                  LET gs_success = 'N'
               END IF
            END IF
         ELSE
            UPDATE ljp_file SET ljp06= gs_ljq.ljq12
             WHERE ljp01=gs_lji.lji01
               AND ljp02=gs_lji.lji05
               AND ljp05=gs_ljq.ljq04
               AND ljp04=gs_ljq.ljq08
               AND ljp08='4'
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','upd ljp_file',SQLCA.sqlcode,1)
               LET gs_success = 'N'
            END IF
         END IF
          
         #FUN-C20078 Begin---
         #IF gs_ljq.ljq10 <>0 OR gs_ljq.ljq11 <>0 OR gs_ljq.ljq12 <>0
         #  OR gs_ljq.ljq13 <>0 OR gs_ljq.ljq14 <>0 OR gs_ljq.ljq15 <>0 THEN
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM ljp_file
           WHERE ljp01 = gs_lji.lji01
             AND ljp02 = gs_lji.lji05
             AND ljp04 BETWEEN gs_ljq.ljq07 AND gs_ljq.ljq08
             AND ljp05 = gs_ljq.ljq04
          IF g_cnt > 0 THEN
         #FUN-C20078 End-----
             INSERT INTO ljq_file VALUES (gs_ljq.*)
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','ins ljq_file',SQLCA.sqlcode,1)
                LET gs_success = 'N'
             END IF
          END IF
          IF MONTH(l_bdate)+1 >12 THEN
             LET l_year = YEAR(l_bdate) +1
             LET l_month = MONTH(l_bdate)+1-12
          ELSE
             LET l_year = YEAR(l_bdate)
             LET l_month = MONTH(l_bdate)+1
          END IF
          IF p_m = 'Y' THEN
             LET l_bdate = MDY(l_month,1,l_year)
          ELSE
             IF l_day_std-1 = 0 THEN
                LET l_month = l_month-1
                IF l_month = 0 THEN
                   LET l_month =12
                   LET l_year = l_year-1
                END IF
                LET l_day = cl_days(l_year,l_month)
             ELSE
                IF cl_days(l_year,l_month) <= l_day_std-1 THEN
                   LET l_day = cl_days(l_year,l_month)
                ELSE
                   LET l_day = l_day_std-1
                END IF
             END IF
             LET l_bdate = MDY(l_month,l_day,l_year)+1
          END IF
          IF l_bdate > p_edate THEN
             EXIT WHILE
          END IF
       END WHILE
    END IF

END FUNCTION

FUNCTION i400_update_bill_order()
    DEFINE l_order         LIKE type_file.num5,
           l_liw           RECORD LIKE liw_file.*
           
    #复制账单资料到临时表
    
    DELETE FROM x WHERE 1=1
    INSERT INTO x SELECT * FROM liw_file
     WHERE liw01 = gs_lnt.lnt01
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg("","",'create temp x fail','',1)
       LET gs_success='N'
    END IF
           
    #(目标：费用编号+账期编号+版本号 |条件：按照账期编号 +费用编号 +版本号 排序)
    DECLARE liw_order_update CURSOR FROM "SELECT * FROM x WHERE 1=1 ORDER BY liw06,liw04,liw02,liw07"

    
    #(目标：依次更新项次 | 条件：费用编号+账期编号+版本号)
    LET l_order=1
    FOREACH liw_order_update INTO l_liw.*
       
       UPDATE x SET liw03=l_order
        WHERE liw01 = l_liw.liw01
          AND liw06 = l_liw.liw06
          AND liw04 = l_liw.liw04
          AND liw07 = l_liw.liw07
         
          
       IF STATUS THEN
          LET gs_msg=l_liw.liw04,"||",l_liw.liw06,"||",l_liw.liw07
          CALL s_errmsg("liw04,liw05,liw07",gs_msg,'update temp x fail','',1)
          LET gs_success='N'
       END IF
       
       LET l_order=l_order+1
       
    END FOREACH
    IF STATUS THEN
       LET gs_msg=l_liw.liw04,"||",l_liw.liw06,"||",l_liw.liw07
       CALL s_errmsg("liw04,liw05,liw07",gs_msg,'sel liw fail','',1)
       LET gs_success='N'
    END IF  
    
    #删除liw_file资料
    DELETE FROM liw_file
     WHERE liw01=gs_lnt.lnt01
       
    #复制临时表资料到liw_file
    INSERT INTO liw_file SELECT * FROM x
    IF STATUS THEN
       CALL s_errmsg("","",'ins liw fail','',1)
       LET gs_success='N'
    END IF 
    
END FUNCTION

FUNCTION t410_update_bill_order()
    DEFINE l_order         LIKE type_file.num5,
           l_ljq           RECORD LIKE ljq_file.*
           
    #复制账单资料到临时表
    
    DELETE FROM y WHERE 1=1
    INSERT INTO y SELECT * FROM ljq_file
     WHERE ljq01 = gs_lji.lji01
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg("","",'create temp y fail','',1)
       LET gs_success='N'
    END IF
           
    #(目标：费用编号+账期编号+版本号 |条件：按照账期编号 +费用编号 +版本号 排序)
    DECLARE ljq_order_update CURSOR FROM "SELECT * FROM y WHERE 1=1 ORDER BY ljq06,ljq04,ljq02,ljq07 "

    
    #(目标：依次更新项次 | 条件：费用编号+账期编号+版本号)
    LET l_order=1
    FOREACH ljq_order_update INTO l_ljq.*
       UPDATE y SET ljq03=l_order
        WHERE ljq01 = l_ljq.ljq01
          AND ljq06 = l_ljq.ljq06
          AND ljq04 = l_ljq.ljq04
          AND ljq07 = l_ljq.ljq07
          AND ljq02 = l_ljq.ljq02
          
       IF SQLCA.sqlcode THEN
          LET gs_msg=l_ljq.ljq04,"||",l_ljq.ljq06,"||",l_ljq.ljq07,"||",l_ljq.ljq02
          CALL s_errmsg("ljq04,ljq05,ljq07,ljq02",gs_msg,'update temp y fail',SQLCA.sqlcode,1)
          LET gs_success='N'
       END IF
       
       LET l_order=l_order+1
       
    END FOREACH
    IF STATUS THEN
       LET gs_msg=l_ljq.ljq04,"||",l_ljq.ljq06,"||",l_ljq.ljq07,"||",l_ljq.ljq02
       CALL s_errmsg("ljq04,ljq05,ljq07,ljq02",gs_msg,'sel ljq fail','',1)
       LET gs_success='N'
    END IF  
    
    #删除ljq_file资料
    DELETE FROM ljq_file
     WHERE ljq01=gs_lji.lji01
     
    #复制临时表资料到ljq_file
    INSERT INTO ljq_file SELECT * FROM y
    
    IF SQLCA.sqlcode THEN
       CALL s_errmsg("","",'ins ljq fail',SQLCA.sqlcode,1)
       LET gs_success='N'
    END IF 
    
END FUNCTION
#FUN-BA0118
