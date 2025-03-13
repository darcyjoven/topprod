# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name...: s_wccap.4gl
# Descriptions...: 工單負荷明細資料
# Date & Author..: 92/12/03 By Keith
# Usage..........: IF s_wccap(p_wo)
# Input Parameter: p_wo    工單編號
# Return Code....: 0    OK
#                  1    FAIL
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.FUN-670091 06/08/02 By rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-790001 07/09/03 By jamie PK問題
# Modify.........: No.TQC-790089 07/09/14 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-A60076 10/06/25 By huangtao GP5.25 製造功能優化-平行製程(批量修改) 
# Modify.........: No.FUN-A80044 10/08/06 By Hiko 宣告變數不參考zld_file

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_wccap(g_wonum_t)
    DEFINE
        g_wonum_t                LIKE sff_file.sff01,     # 工單編號 	#No.FUN-680147 VARCHAR(10)
        g_back                   LIKE type_file.chr1,        # 成功與否  0:成功  1:失敗 #No.FUN-680147 VARCHAR(1)
        l_cnt                    LIKE type_file.num5,   	#No.FUN-680147 SMALLINT
        l_sff01        LIKE      sff_file.sff01,         
        l_sff02        LIKE      sff_file.sff02,         
        l_sff03        LIKE      sff_file.sff03,         
        l_ecm01        LIKE      ecm_file.ecm01,         
        l_ecm03        LIKE      ecm_file.ecm03,         
        l_ecm04        LIKE      ecm_file.ecm04,         
        l_ecm06        LIKE      ecm_file.ecm06,         
        l_ecm11        LIKE      ecm_file.ecm11,         
        l_ecm13        LIKE      ecm_file.ecm13,         
        l_ecm14        LIKE      ecm_file.ecm14,         
        l_ecm15        LIKE      ecm_file.ecm15,         
        l_ecm16        LIKE      ecm_file.ecm16,         
        l_eca06        LIKE      eca_file.eca06,        
        l_sfb02        LIKE      sfb_file.sfb02,        
        l_sfb05        LIKE      sfb_file.sfb05,        
        l_sfb071       LIKE      sfb_file.sfb071,       
        l_sfb08        LIKE      sfb_file.sfb08,        
        l_sfb13        LIKE      sfb_file.sfb13,        
        l_sfb15        LIKE      sfb_file.sfb15,        
        l_sfb06        LIKE      sfb_file.sfb06,        
        l_ima56        LIKE      ima_file.ima56,        
        l_tmp02                  LIKE sfb_file.sfb27,                   #No.FUN-680147 VARCHAR(10)
        l_tmp03                  LIKE type_file.num5,                 	#No.FUN-680147 SMALLINT
        l_tmp04                  LIKE aab_file.aab02,                	#No.FUN-680147 VARCHAR(6)
        l_tmp05                  LIKE ima_file.ima18,            	#No.FUN-680147 DECIMAL(8,2)
        l_ttp01                  LIKE sfb_file.sfb01,                   #No.FUN-560002 #No.FUN-680147 VARCHAR(16)
        l_ttp02                  LIKE sfb_file.sfb27,                   #No.FUN-680147 VARCHAR(10)
        l_ttp03                  LIKE type_file.num5,                 	#No.FUN-680147 SMALLINT
        l_ttp04                  LIKE type_file.dat,                    #No.FUN-680147 DATE
        l_ttp05                  LIKE type_file.dat,                    #No.FUN-680147 DATE
        l_ttp06                  LIKE tup_file.tup05,                   #No.FUN-680147 DECIMAL(12,3)
        l_tup02                  LIKE sfb_file.sfb27,                   #No.FUN-680147 VARCHAR(10)
        l_tup03                  LIKE type_file.num5,                 	#No.FUN-680147 SMALLINT
        l_tup04                  LIKE type_file.dat,                   	#No.FUN-680147 DATE
        l_tup05                  LIKE type_file.dat,                   	#No.FUN-680147 DATE
        l_tup06                  LIKE tup_file.tup05,                   #No.FUN-680147 DECIMAL(12,3)
        l_tup07                  LIKE type_file.chr1,                  	#No.FUN-680147 VARCHAR(1)
        l_sum06                  LIKE tup_file.tup05,                   #No.FUN-680147 DECIMAL(12,3) 
        i                        LIKE type_file.num5,                   #No.FUN-680147 SMALLINT
        pt                       LIKE type_file.num5,                   #No.FUN-680147 SMALLINT
        l_loading                LIKE tup_file.tup05,                   #No.FUN-680147 DECIMAL(12,3)
        l_load                   LIKE tup_file.tup05,                   #No.FUN-680147 DECIMAL(12,3)
        l_wkdaytot               LIKE type_file.num5,                   #No.FUN-680147 SMALLINT
        l_wkday                  LIKE type_file.num5,                   #No.FUN-680147 SMALLINT
        l_monday                 LIKE type_file.dat,                    #No.FUN-680147 DATE
        l_sunday                 LIKE type_file.dat                     #No.FUN-680147 DATE
 
   WHENEVER ERROR CALL cl_err_msg_log
   MESSAGE 'Calculate Loading'
   IF s_shut(0) THEN
      RETURN
   END IF
#FUN-680147 -- begin --                        #No.TQC-6A0079
   #FUN-A80044:tmp_file內不能有註解,所以在這裡說明:zld_file.zld19改為type_file.chr50.
   CREATE TEMP TABLE tmp_file(   
   tmp01 LIKE type_file.chr50,
   tmp02 LIKE sfb_file.sfb27,
   tmp03 LIKE type_file.num5,  
   tmp04 LIKE aab_file.aab02,
   tmp05 LIKE ima_file.ima18,
   tmp06 LIKE ima_file.ima18);
#FUN-680147 -- end --
   CREATE  INDEX tmp_01 ON tmp_file (tmp01);
   DELETE FROM tmp_file WHERE 1=1  
#FUN-680147 -- begin --             #No.TQC-6A0079
   #FUN-A80044:tmp_file內不能有註解,所以在這裡說明:zld_file.zld19改為type_file.chr50.
   CREATE TEMP TABLE ttp_file(
   ttp01 LIKE type_file.chr50,
   ttp02 LIKE sfb_file.sfb27,
   ttp03 LIKE type_file.num5,  
   ttp04 LIKE type_file.dat,   
   ttp05 LIKE type_file.dat,   
   ttp06 LIKE bnf_file.bnf12);
#FUN-680147 -- end --
   CREATE  INDEX ttp_01 ON ttp_file (ttp01);
   DELETE FROM ttp_file WHERE 1=1
#FUN-680147 -- begin --
   CREATE TEMP TABLE tup_file(
   tup01 LIKE sfb_file.sfb27,
   tup02 LIKE sfb_file.sfb27,
   tup03 LIKE type_file.num5,  
   tup04 LIKE type_file.dat,   
   tup05 LIKE type_file.dat,   
   tup06 LIKE bnf_file.bnf12,
   tup07 LIKE type_file.chr1);
#FUN-680147 -- end --
   CREATE  INDEX tup_01 ON tup_file (tup01);
   DELETE FROM tup_file WHERE 1=1
   DECLARE wccap_curs CURSOR FOR 
     SELECT sff01,sff02,sff03 FROM sff_file WHERE sff01 = g_wonum_t
   FOREACH wccap_curs INTO l_sff01,l_sff02,l_sff03
      IF l_sff01 = g_wonum_t THEN
         DELETE FROM sff_file WHERE sff01 = l_sff01 AND sff02 = l_sff02
                 AND sff03 = l_sff03   #如果sff_file中存在,殺掉!
         IF SQLCA.SQLCODE THEN
            CALL cl_err('ckp#10',SQLCA.sqlcode,1)
            RETURN 1
         END IF
      END IF
   END FOREACH
   SELECT sfb06 INTO l_sfb06 FROM sfb_file
      where sfb01=g_wonum_t
   DECLARE wccap_curs1 CURSOR FOR 
   SELECT ecm01,ecm06,ecm11,ecm03,ecm04,ecm13,ecm14,ecm15,ecm16
     FROM ecm_file WHERE ecm01 = g_wonum_t 
     AND ecm11=l_sfb06 ORDER BY ecm012,ecm03            #FUN-A60076 add   ecm012, 
   FOREACH wccap_curs1 INTO l_ecm01,l_ecm06,l_ecm11,l_ecm03,l_ecm04,
               l_ecm13,l_ecm14,l_ecm15,l_ecm16
      IF SQLCA.sqlcode THEN
         CALL cl_err('chk#1',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT eca06 INTO l_eca06 FROM eca_file WHERE eca01 = l_ecm06
      IF l_eca06 = "1" THEN      #機器產能
         INSERT INTO tmp_file
             VALUES(l_ecm01,l_ecm06,l_ecm03,l_ecm04,l_ecm15,l_ecm16)
         IF SQLCA.sqlcode THEN
            #CALL cl_err('chk#2',SQLCA.sqlcode,1)  #FUN-670091
            CALL cl_err3("ins","tmp_file","","",STATUS,"","chk#2",1)  #FUN-670091
            RETURN 1
         END IF
      ELSE    #人工產能
         INSERT INTO tmp_file
             VALUES(l_ecm01,l_ecm06,l_ecm03,l_ecm04,l_ecm13,l_ecm14)
         IF SQLCA.sqlcode THEN
            #CALL cl_err('chk#3',SQLCA.sqlcode,1)   #FUN-670091
            CALL cl_err3("ins","tmp_file","","",STATUS,"","chk#3",1)  #FUN-670091
            RETURN 1
         END IF
      END IF
   END FOREACH
   SELECT sfb13,sfb15,sfb071,sfb02,sfb05,sfb08 
       INTO l_sfb13,l_sfb15,l_sfb071,l_sfb02,l_sfb05,l_sfb08 
       FROM sfb_file WHERE sfb01 = g_wonum_t
       #取其Global之start day & end day(array)             
   CALL s_taskdat(0,l_sfb13,l_sfb15,l_sfb071,g_wonum_t,l_ecm11,l_sfb02,
                 l_sfb05,l_sfb08)   RETURNING pt
   IF SQLCA.sqlcode THEN
      #CALL cl_err('chk#4',SQLCA.sqlcode,1)  #FUN-670091
       CALL cl_err3("sel","sfb_file",g_wonum_t,"",SQLCA.sqlcode,"","chk#4",1) #FUN-670091
      RETURN 1
   END IF
 
   SELECT ima56 INTO l_ima56 FROM ima_file WHERE ima01 = l_sfb05
   IF l_ima56 IS NULL OR l_ima56 = 0 THEN   #找批量
      LET l_ima56 = 1
   END IF
   DECLARE wccap_curs2 CURSOR FOR
     SELECT tmp02,tmp03,tmp04,tmp05 FROM tmp_file
     WHERE tmp01 = g_wonum_t ORDER BY tmp03
   LET l_cnt = 0
   FOREACH wccap_curs2 INTO l_tmp02,l_tmp03,l_tmp04,l_tmp05
      IF SQLCA.sqlcode THEN
         #CALL cl_err('chk#5',SQLCA.sqlcode,1)  #FUN-670091
         CALL cl_err3("sel","tmp_file",g_wonum_t,"",SQLCA.sqlcode,"","chk#5",1)  #FUN-670091
         RETURN 1
      END IF
      LET l_cnt = l_cnt + 1
      LET l_loading = (l_tmp04*l_sfb08/l_ima56 + l_tmp05*l_sfb08)/60
      INSERT INTO ttp_file   #將start day & end day 寫入暫存檔
          VALUES(g_wonum_t,l_tmp02,l_tmp03,g_takdate[l_cnt].srtdt,
                     g_takdate[l_cnt].duedt,l_loading)
      IF SQLCA.sqlcode THEN
         #CALL cl_err('chk#6',SQLCA.sqlcode,1)
         CALL cl_err3("ins","ttp_file","","",SQLCA.sqlcode,"","chk#6",1)  #FUN-670091
         RETURN 1
      END IF
   END FOREACH
 
   DECLARE wccap_curs3 CURSOR FOR
    SELECT ttp01,ttp02,ttp03,ttp04,ttp05, ttp06 FROM ttp_file
     WHERE ttp01 = g_wonum_t ORDER BY ttp03
   FOREACH wccap_curs3 INTO l_ttp01,l_ttp02,l_ttp03,
                       l_ttp04,l_ttp05,l_ttp06  
      IF SQLCA.sqlcode THEN
         CALL cl_err('chk#7',SQLCA.sqlcode,1)
         RETURN 1
      END IF
      LET l_cnt = (l_ttp05 - l_ttp04) / 7 + 2
      CALL s_ofday(l_ttp04,l_ttp05) RETURNING l_wkdaytot #有多少工作天
      IF l_wkdaytot = 0 THEN
         LET l_wkdaytot = 1
      END IF
      CALL s_monck(l_ttp04) RETURNING l_monday #找第一個星期天
      INITIALIZE l_sunday TO NULL
      FOR i = 1 TO l_cnt            # 切割成以一星期為單位
         IF l_sunday > l_ttp05 THEN
            EXIT FOR
         END IF
         IF l_monday < l_ttp04 AND i = 1 THEN
            LET l_sunday = l_monday + 6
            IF l_sunday <= l_ttp05 THEN
               CALL s_ofday(l_ttp04,l_sunday) RETURNING l_wkday
               IF l_wkday = 0 THEN
                  LET l_wkday = 1
               END IF
               LET l_load = l_ttp06 * l_wkday / l_wkdaytot
               IF cl_null(l_ttp03) THEN LET l_ttp03=' '  END IF   #FUN-790001 add
               INSERT INTO tup_file
               VALUES(l_ttp01,l_ttp02,l_ttp03,l_monday,l_sunday,l_load,"0")
               IF SQLCA.sqlcode THEN
                  #CALL cl_err('chk#8',SQLCA.sqlcode,1) #FUN-670091
                  CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","chk#8",1)  #FUN-670091
                  RETURN 1
               END IF
               IF l_sunday = l_ttp05 THEN
                  EXIT FOR
               END IF
               LET l_monday = l_sunday + 1
            END IF
            IF l_sunday > l_ttp05 THEN
               CALL s_ofday(l_ttp04,l_ttp05) RETURNING l_wkday
               IF l_wkday = 0 THEN
                  LET l_wkday = 1
               END IF
               LET l_load = l_ttp06 * l_wkday / l_wkdaytot
               IF cl_null(l_ttp03) THEN LET l_ttp03=' '  END IF   #FUN-790001 add
               INSERT INTO tup_file
               VALUES(l_ttp01,l_ttp02,l_ttp03,l_monday,l_sunday,l_load,"0")
               IF SQLCA.sqlcode THEN
                  #CALL cl_err('chk#9',SQLCA.sqlcode,1)  #FUN-670091
                  CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","chk#9",1)  #FUN-670091
                  RETURN 1
               END IF
               IF l_sunday = l_ttp05 THEN
                  EXIT FOR
               END IF
            END IF
         END IF
         IF l_monday = l_ttp04 OR i > 1 THEN
            LET l_sunday = l_monday + 6
            IF l_sunday <= l_ttp05 THEN
               CALL s_ofday(l_monday,l_sunday) RETURNING l_wkday
               IF l_wkday = 0 THEN
                  LET l_wkday = 1
               END IF
               IF cl_null(l_ttp03) THEN LET l_ttp03=' '  END IF   #FUN-790001 add
               LET l_load = l_ttp06 * l_wkday / l_wkdaytot
               INSERT INTO tup_file
               VALUES(l_ttp01,l_ttp02,l_ttp03,l_monday,l_sunday,l_load,"0")
               IF SQLCA.sqlcode THEN
                  #CALL cl_err('chk#10',SQLCA.sqlcode,1)  #FUN-670091
                  CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","chk#10",1)  #FUN-670091
                  RETURN 1
               END IF
               IF l_sunday = l_ttp05 THEN
                  EXIT FOR
               END IF
               LET l_monday = l_sunday + 1
            END IF
            IF l_sunday > l_ttp05 THEN
               CALL s_ofday(l_monday,l_ttp05) RETURNING l_wkday
               IF l_wkday = 0 THEN
                  LET l_wkday = 1
               END IF
               LET l_load = l_ttp06 * l_wkday / l_wkdaytot
               IF cl_null(l_ttp03) THEN LET l_ttp03=' '  END IF   #FUN-790001 add
               INSERT INTO tup_file
               VALUES(l_ttp01,l_ttp02,l_ttp03,l_monday,l_sunday,l_load,"0")
               IF SQLCA.sqlcode THEN
                  #CALL cl_err('chk#11',SQLCA.sqlcode,1)  #FUN-670091
                   CALL cl_err3("ins","tup_file","","",SQLCA.sqlcode,"","chk#11",1)  #FUN-670091
                  RETURN 1
               END IF
               EXIT FOR
            END IF
         END IF
      END FOR
   END FOREACH
   DECLARE wccap_curs4 CURSOR FOR SELECT tup02,tup03,tup04,tup05,
               tup06,tup07 FROM tup_file
   FOREACH wccap_curs4 INTO
      l_tup02,l_tup03,l_tup04,l_tup05,l_tup06,l_tup07 
      IF SQLCA.sqlcode THEN
         CALL cl_err('chk#12',SQLCA.sqlcode,1)
         RETURN 1
      END IF
      IF l_tup07 = "1" THEN
         CONTINUE FOREACH
      ELSE
         SELECT SUM(tup06) INTO l_sum06 
         FROM tup_file WHERE tup02 = l_tup02 AND
                             tup04 = l_tup04 AND tup05 = l_tup05
         GROUP BY tup02,tup04,tup05
         INSERT INTO sff_file
           VALUES(g_wonum_t,l_tup02,l_tup04,l_tup05,l_sum06,g_plant,g_legal)  #FUN-980012 add
#        IF SQLCA.SQLCODE THEN
         IF SQLCA.SQLCODE  THEN
           #IF SQLCA.SQLCODE !=-239 THEN                                       #TQC-790089 mark
            IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN  #TQC-790089 mod
            #CALL cl_err('ckp#11',SQLCA.sqlcode,1) #FUN-670091
            CALL cl_err3("ins","sff_file","","",SQLCA.sqlcode,"","chk#11",1)  #FUN-670091
            RETURN 1
           END IF
         END IF
         UPDATE tup_file SET tup07 = "1" 
          WHERE tup02 = l_tup02 AND tup04 = l_tup04
            AND tup05 = l_tup05
         IF SQLCA.SQLCODE THEN
            #CALL cl_err('ckp#12',SQLCA.sqlcode,1)  #FUN-670091
            CALL cl_err3("upd","tup_file","","",SQLCA.sqlcode,"","chk#12",1) #FUN-670091
            RETURN 1
         END IF
      END IF
   END FOREACH
   RETURN 0
END FUNCTION
