# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: apjp200.4gl
# Descriptions...: 活動網絡進度推算作業
# Date & Author..: No.FUN-790025 07/11/23 By douzh
# Modify.........: No.TQC-840042 08/04/18 By douzh 正推計算倒推計算bug調整
# Modify.........: No.TQC-840048 08/04/18 By douzh l_days天數-1
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0025 09/10/13 By Dido 過濾不存在 pjl_file 時,應增加 pjl01 key 值
# Modify.........: No:TQC-9B0020 09/11/24 By Dido 檢核 pjl_file 是否存在
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm RECORD 
           d_date  LIKE type_file.dat
           END RECORD
DEFINE  g_pjj01         LIKE pjj_file.pjj01 
DEFINE  g_pjj01_t       LIKE pjj_file.pjj01 
DEFINE  g_pjj04         LIKE pjj_file.pjj04
DEFINE  g_pjj04_t       LIKE pjj_file.pjj04
DEFINE  ls_date         STRING,             
        l_flag          LIKE type_file.chr1,
        g_change_lang   LIKE type_file.chr1
DEFINE  gv_time         LIKE type_file.chr8 
DEFINE  g_wc            STRING 
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_wc    = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(3)
 
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL apjp200_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
           CALL p200_process()
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW apjp200_w
              EXIT WHILE
           END IF
         ELSE
           CONTINUE WHILE
         END IF
     ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p200_process()
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
 
FUNCTION apjp200_tm(p_row,p_col)
    DEFINE  p_row,p_col    LIKE type_file.num5
    DEFINE  lc_cmd         STRING
    DEFINE  l_cnt          LIKE type_file.num5
    DEFINE  l_zz08         LIKE zz_file.zz08
 
   OPEN WINDOW apjp200_w WITH FORM "apj/42f/apjp200" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   WHILE TRUE 
	  IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      LET g_bgjob = 'N'
      LET tm.d_date = g_today
 
      CONSTRUCT BY NAME g_wc ON pjj04,pjj01 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pjj04) #項目編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pja2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjj04
               NEXT FIELD pjj04
            WHEN INFIELD(pjj01) #網絡編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_pjj5"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO pjj01
               NEXT FIELD pjj01
            OTHERWISE EXIT CASE
          END CASE
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
        CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about      
         CALL cl_about()  
 
      ON ACTION help     
         CALL cl_show_help()
 
      ON ACTION exit    
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT CONSTRUCT
 
   END CONSTRUCT 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjjuser', 'pjjgrup') #FUN-980030
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW apjp200_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   INPUT BY NAME tm.d_date,g_bgjob WITHOUT DEFAULTS
 
   AFTER INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0            
         CLOSE WINDOW p200_w          
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM               
      END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()   
 
      ON ACTION help         
         CALL cl_show_help()
 
      ON ACTION controlg   
         CALL cl_cmdask()  
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION locale            
         LET g_change_lang = TRUE  
         EXIT INPUT                 
 
   END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
  IF g_bgjob = "Y" THEN
     LET lc_cmd = NULL
     SELECT zz08 INTO l_zz08 FROM zz_file
      WHERE zz01 = "apjp200"
     IF SQLCA.sqlcode OR cl_null(l_zz08) THEN
        CALL cl_err('apjp200','9031',1)  
     ELSE
        LET lc_cmd = l_zz08 CLIPPED,
                     " ''",
                     " '",g_wc CLIPPED,"'",
                     " '",tm.d_date CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('apjp200',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW apjp200_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
   END IF
   EXIT WHILE
 
   ERROR ""
   END WHILE
END FUNCTION
 
FUNCTION p200_process()
DEFINE l_sql   STRING
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_pjk   RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk18  LIKE pjk_file.pjk18,
               pjk19  LIKE pjk_file.pjk19,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
 
   DROP TABLE tmp_pjk
 
   CREATE TEMP TABLE tmp_pjk(
          pjk01  LIKE pjk_file.pjk01,
          pjk02  LIKE pjk_file.pjk02,
          pjk18  LIKE pjk_file.pjk18,
          pjk19  LIKE pjk_file.pjk19,
          pjk08  LIKE pjk_file.pjk08,
          pjk14  LIKE pjk_file.pjk14,
          pjk20  LIKE pjk_file.pjk20,
          pjk21  LIKE pjk_file.pjk21,
          pjk22  LIKE pjk_file.pjk22,
          pjk23  LIKE pjk_file.pjk23,
          l_z    LIKE type_file.chr1,
          l_d    LIKE type_file.chr1);
 
  IF g_success = 'N' THEN
     IF g_bgjob = 'N' THEN CALL cl_rbmsg(1) END IF
     RETURN
  END IF
 
  LET l_sql="SELECT pjk01,pjk02,pjk18,pjk19,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,'N','N'",
            " FROM pjk_file,pjj_file",
            " WHERE pjk01=pjj01", 
            " AND ",g_wc CLIPPED  
            
  DECLARE p200_cur CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cur INTO l_pjk.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cur',STATUS,1)
        EXIT FOREACH
     END IF
    #-TQC-9B0020-add-
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt
       FROM pjl_file
      WHERE pjl01 = l_pjk.pjk01
     IF l_cnt = 0 THEN
        CALL cl_err('','apj-014',1)
        LET g_success = 'N'
        EXIT FOREACH   
     END IF
    #-TQC-9B0020-end-
 
     INSERT INTO tmp_pjk VALUES(l_pjk.*)
 
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("ins","tmp_pjk",l_pjk.pjk01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
  
     CALL p200_upd_1()
     CALL p200_upd_2()
     CALL p200_upd_3()
     CALL p200_upd_4()
     CALL p200_upd_5()
     CALL p200_upd_6()
 
  IF g_success = 'Y' THEN
     CALL p200_upd()
  END IF
  IF g_success = 'Y' THEN
     CALL p200_upd_net()
  END IF
  IF g_success = 'Y' THEN
     CALL p200_upd_wbs()
  END IF
 
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION p200_upd_1()              #先處理有實際完工日期資料的
DEFINE   sr1   RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk18  LIKE pjk_file.pjk18,
               pjk19  LIKE pjk_file.pjk19,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
DEFINE l_sql   STRING
 
  LET l_sql="SELECT pjk01,pjk02,pjk18,pjk19,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,l_z,l_d FROM tmp_pjk",
            " WHERE pjk19 IS NOT NULL " 
            
  DECLARE p200_cs1 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs1 INTO sr1.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs1',STATUS,1)
        EXIT FOREACH
     END IF
 
     UPDATE tmp_pjk  SET pjk20 = sr1.pjk18,
                         pjk21 = sr1.pjk19, 
                         pjk22 = sr1.pjk18, 
                         pjk23 = sr1.pjk19,
                         l_z = 'Y',
                         l_d = 'Y' 
                   WHERE pjk01 = sr1.pjk01
                     AND pjk02 = sr1.pjk02
 
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","tmp_pjk",sr1.pjk01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
 
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION p200_upd_2()        #處理有實際開工日，但無實際完工日的資料
DEFINE sr2     RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk18  LIKE pjk_file.pjk18,
               pjk19  LIKE pjk_file.pjk19,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
DEFINE l_days  LIKE type_file.num5
DEFINE l_maxdate LIKE type_file.dat
DEFINE l_sql   STRING
 
  LET l_sql="SELECT pjk01,pjk02,pjk18,pjk19,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,l_z,l_d FROM tmp_pjk",
            " WHERE pjk18 IS NOT NULL ",
            " AND pjk19 IS NULL ",
            " AND l_z = 'N' "
            
  DECLARE p200_cs2 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs2 INTO sr2.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs2',STATUS,1)
        EXIT FOREACH
     END IF
 
     IF sr2.pjk20 < tm.d_date THEN
         LET l_maxdate = tm.d_date
     ELSE
         LET l_maxdate = sr2.pjk20 
     END IF
 
     IF cl_null(sr2.pjk08) THEN LET sr2.pjk08 = 0 END IF
     LET l_days = sr2.pjk14 * (1-sr2.pjk08/100)-1           #No.TQC-840048
 
     LET sr2.pjk21= l_maxdate+l_days
 
     UPDATE tmp_pjk  SET pjk20 = sr2.pjk18,
                         pjk21 = sr2.pjk21,
                         l_z = 'Y' 
                   WHERE pjk01 = sr2.pjk01
                     AND pjk02 = sr2.pjk02
 
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","tmp_pjk",sr2.pjk01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
 
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
#正推循環
FUNCTION p200_upd_3()    #選出無緊前任務的資料，且正推否＝'N'的資料處理 
DEFINE sr3     RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
DEFINE l_days  LIKE type_file.num5
DEFINE l_maxdate LIKE type_file.dat
DEFINE l_sql   STRING
DEFINE l_pjk16 LIKE pjk_file.pjk16
DEFINE l_pjk17 LIKE pjk_file.pjk17
 
  LET l_sql="SELECT pjk01,pjk02,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,l_z,l_d FROM tmp_pjk",
            " WHERE l_z = 'N' ",
           #" AND pjk02 NOT IN (SELECT pjl03 FROM pjl_file) " 					#CHI-9A0025 mark
            " AND pjk02 NOT IN (SELECT pjl03 FROM pjl_file,tmp_pjk WHERE pjl01 = pjk01 ) " 	#CHI-9A0025
            
  DECLARE p200_cs3 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs3 INTO sr3.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs3',STATUS,1)
        EXIT FOREACH
     END IF
     SELECT pjk16,pjk17 INTO l_pjk16,l_pjk17 FROM pjk_file
      WHERE pjk01=sr3.pjk01 AND pjk02=sr3.pjk02
 
     IF l_pjk16 IS NOT NULL THEN
        LET sr3.pjk20 = l_pjk16 
     ELSE
        LET sr3.pjk20 = tm.d_date
     END IF
 
     IF cl_null(sr3.pjk08) THEN LET sr3.pjk08 = 0 END IF
     LET l_days = sr3.pjk14 * (1-sr3.pjk08/100)-1       #No.TQC-840048  
 
     LET sr3.pjk21 = sr3.pjk20+l_days
   
     UPDATE tmp_pjk  SET pjk20 = sr3.pjk20,
                         pjk21 = sr3.pjk21,
                         l_z = 'Y' 
                   WHERE pjk01 = sr3.pjk01
                     AND pjk02 = sr3.pjk02
 
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","tmp_pjk",sr3.pjk01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
 
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION p200_upd_4()    #選出有緊前任務且正推否＝'Y',但本身正推否＝'N' 的資料處理 
DEFINE sr4     RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk18  LIKE pjk_file.pjk18,
               pjk19  LIKE pjk_file.pjk19,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
 
DEFINE l_days     LIKE type_file.num5
DEFINE l_maxdate  LIKE type_file.dat
DEFINE l_sql      STRING
DEFINE l_pjk21    LIKE pjk_file.pjk21   #FS最早完工日
DEFINE l_pjk20    LIKE pjk_file.pjk20   #SS最早開工日
DEFINE l_pjk21_2  LIKE pjk_file.pjk21   #FF最早完工日
DEFINE l_pjk20_2  LIKE pjk_file.pjk20   #SF最早開工日
DEFINE l_bdate    LIKE type_file.dat    #最早開工日
DEFINE l_edate    LIKE type_file.dat    #最早完工日
DEFINE l_flag_z   LIKE type_file.chr1   #繼續正推標識  #No.TQC-840042
 
  LET l_flag_z ='N'                     #No.TQC-840042
 
  LET l_sql="SELECT pjk01,pjk02,pjk18,pjk19,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,l_z,l_d FROM tmp_pjk,pjl_file",
            " WHERE l_z = 'N' ",
            " AND pjk01 = pjl01 ",
            " AND pjl03 = pjk02 ",
            " AND pjl02 IN (SELECT pjk02 FROM tmp_pjk WHERE l_z = 'Y')",
            " ORDER BY pjk01,pjk02"
            
  DECLARE p200_cs4 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
  
  FOREACH p200_cs4 INTO sr4.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs4',STATUS,1)
        EXIT FOREACH
     END IF
     LET l_flag_z ='Y'      #No.TQC-840042
     SELECT MAX(pjk21) INTO l_pjk21 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr4.pjk01 AND pjl03=sr4.pjk02 
        AND pjl04 = '1' AND pjl01 = pjk01 AND pjl02 = pjk02
     IF cl_null(l_pjk21) THEN LET l_pjk21='99/12/31' END IF
     LET l_bdate=l_pjk21
     SELECT MAX(pjk20) INTO l_pjk20 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr4.pjk01 AND pjl03=sr4.pjk02 
        AND pjl04 = '2' AND pjl01 = pjk01 AND pjl02 = pjk02
     IF cl_null(l_pjk20) THEN LET l_pjk20='99/12/31' END IF
     IF l_bdate <= l_pjk20 THEN
        LET l_bdate=l_pjk20
     END IF
     IF l_bdate <= tm.d_date THEN
        LET l_bdate=tm.d_date
     END IF
 
     SELECT MAX(pjk21) INTO l_pjk21_2 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr4.pjk01 AND pjl03=sr4.pjk02 
        AND pjl04 = '3' AND pjl01 = pjk01 AND pjl02 = pjk02
     IF cl_null(l_pjk21_2) THEN LET l_pjk21_2='99/12/31' END IF
     LET l_edate=l_pjk21_2
     SELECT MAX(pjk20) INTO l_pjk20_2 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr4.pjk01 AND pjl03=sr4.pjk02 
        AND pjl04 = '4' AND pjl01 = pjk01 AND pjl02 = pjk02
     IF cl_null(l_pjk20_2) THEN LET l_pjk20_2='99/12/31' END IF
     IF l_edate <= l_pjk20_2 THEN
        LET l_edate=l_pjk20_2
     END IF
 
     IF cl_null(sr4.pjk08) THEN LET sr4.pjk08 = 0 END IF
     LET l_days = sr4.pjk14 * (1-sr4.pjk08/100)-1             #No.TQC-840048 
     LET sr4.pjk21= l_bdate+l_days
     IF l_edate <= sr4.pjk21 THEN
        LET l_edate=sr4.pjk21
     END IF
 
     UPDATE tmp_pjk  SET pjk20 = l_bdate,
                         pjk21 = l_edate,
                         l_z = 'Y' 
                   WHERE pjk01 = sr4.pjk01
                     AND pjk02 = sr4.pjk02
 
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","tmp_pjk",sr4.pjk01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
 
#TQC-840042--begin 
  IF g_success = 'Y' AND l_flag_z='Y' THEN
     CALL p200_upd_4()
  END IF
#TQC-840042--end 
 
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION p200_upd_5()    #選出無緊后任務且倒推否＝'N'的資料處理 
DEFINE sr5     RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk18  LIKE pjk_file.pjk18,
               pjk19  LIKE pjk_file.pjk19,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
DEFINE l_days    LIKE type_file.num5
DEFINE l_maxdate LIKE type_file.dat
DEFINE l_sql     STRING
 
  LET l_sql="SELECT pjk01,pjk02,pjk18,pjk19,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,l_z,l_d FROM tmp_pjk,pjl_file",
            " WHERE l_d = 'N' ",
            " AND pjk01 = pjl01 ",
            " AND pjl03 = pjk02 ",
           #" AND pjk02 NOT IN (SELECT pjl02 FROM pjl_file) " 					#CHI-9A0025 mark
            " AND pjk02 NOT IN (SELECT pjl02 FROM pjl_file,tmp_pjk WHERE pjl01 = pjk01 ) " 	#CHI-9A0025
            
  DECLARE p200_cs5 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs5 INTO sr5.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs5',STATUS,1)
        EXIT FOREACH
     END IF
    
     LET sr5.pjk23= sr5.pjk21 
     IF sr5.pjk18 IS NOT NULL THEN
        LET sr5.pjk22=sr5.pjk18
     ELSE
        IF cl_null(sr5.pjk08) THEN LET sr5.pjk08 = 0 END IF
        LET l_days = sr5.pjk14 * (1-sr5.pjk08/100)-1       #No.TQC-840048 
        LET sr5.pjk22= sr5.pjk23-l_days
     END IF
     UPDATE tmp_pjk  SET pjk22 = sr5.pjk22,
                         pjk23 = sr5.pjk23,
                         l_d = 'Y' 
                   WHERE pjk01 = sr5.pjk01
                     AND pjk02 = sr5.pjk02
 
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","tmp_pjk",sr5.pjk01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
 
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION p200_upd_6()    #選出有緊后任務且倒推否＝'Y',但本身倒推否＝'N' 的資料處理 
DEFINE sr6     RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk18  LIKE pjk_file.pjk18,
               pjk19  LIKE pjk_file.pjk19,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
DEFINE l_days  LIKE type_file.num5
DEFINE l_maxdate LIKE type_file.dat
DEFINE l_sql   STRING
DEFINE l_bdate LIKE type_file.dat     #最晚開工日
DEFINE l_edate LIKE type_file.dat     #最晚完工日
DEFINE l_pjk22_1 LIKE pjk_file.pjk22  #FS最晚開工日
DEFINE l_pjk22_2 LIKE pjk_file.pjk22  #SS最晚開工日
DEFINE l_pjk23_1 LIKE pjk_file.pjk23  #FF最晚完工日
DEFINE l_pjk23_2 LIKE pjk_file.pjk23  #SF最晚完工日
DEFINE l_flag_d  LIKE type_file.chr1  #繼續倒推標識    #No.TQC-840042
 
 
  LET l_flag_d='N'                    #No.TQC-840042
 
  LET l_sql="SELECT pjk01,pjk02,pjk18,pjk19,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,l_z,l_d FROM tmp_pjk,pjl_file",
            " WHERE l_d = 'N' ",
            " AND pjk01 = pjl01 ",
            " AND pjl02 = pjk02 ",
            " AND pjl03 IN (SELECT pjk02 FROM tmp_pjk WHERE l_d = 'Y')",
            " ORDER BY pjk01,pjk02"
 
  DECLARE p200_cs6 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs6 INTO sr6.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs6',STATUS,1)
        EXIT FOREACH
     END IF
     LET l_flag_d='Y'            #No.TQC-840042
     LET l_bdate = NULL          #No.TQC-840042
     LET l_edate = NULL          #No.TQC-840042
  
     SELECT MIN(pjk23) INTO l_pjk23_1 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr6.pjk01 AND pjl02=sr6.pjk02 
        AND pjl04 = '3' AND pjl01 = pjk01 AND pjl03 = pjk02
     IF NOT cl_null(l_pjk23_1) THEN
        LET l_edate=l_pjk23_1
     END IF
     SELECT MIN(pjk22) INTO l_pjk22_1 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr6.pjk01 AND pjl02=sr6.pjk02 
        AND pjl04 = '1' AND pjl01 = pjk01 AND pjl03 = pjk02
     IF NOT cl_null(l_pjk22_1) THEN 
        IF cl_null(l_edate) THEN
           LET l_edate=l_pjk22_1
        ELSE
           IF l_edate >= l_pjk22_1 THEN
              LET l_edate=l_pjk22_1
           END IF
        END IF
     END IF
     
     IF cl_null(l_pjk22_1) AND cl_null(l_pjk23_1) THEN 
        LET l_edate=g_today
     ELSE
        IF l_edate >= g_today THEN
           LET l_edate=g_today
        END IF
     END IF
       
     SELECT MIN(pjk23) INTO l_pjk23_2 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr6.pjk01 AND pjl02=sr6.pjk02 
        AND pjl04 = '4' AND pjl01 = pjk01 AND pjl03 = pjk02
     IF NOT cl_null(l_pjk23_2) THEN 
        LET l_bdate=l_pjk23_2
     END IF
     SELECT MIN(pjk22) INTO l_pjk22_2 FROM tmp_pjk,pjl_file
      WHERE pjl01 = sr6.pjk01 AND pjl02=sr6.pjk02 
        AND pjl04 = '2' AND pjl01 = pjk01 AND pjl03 = pjk02
     IF NOT cl_null(l_pjk22_2) THEN 
        IF cl_null(l_bdate) THEN 
           LET l_bdate=l_pjk22_2
        ELSE
           IF l_bdate >= l_pjk22_2 THEN
              LET l_bdate=l_pjk22_2
           END IF
        END IF
     END IF
     IF cl_null(sr6.pjk08) THEN LET sr6.pjk08 = 0 END IF
     LET l_days = sr6.pjk14 * (1-sr6.pjk08/100)-1       #No.TQC-840048 
     IF cl_null(l_pjk23_2) AND cl_null(l_pjk22_2) THEN
        LET sr6.pjk23= l_edate-l_days
        LET l_bdate=sr6.pjk23
     ELSE
        IF l_bdate >= sr6.pjk23 THEN
           LET l_bdate=sr6.pjk23
        END IF
     END IF
     
     IF sr6.pjk18 IS NOT NULL THEN  
        LET l_bdate = sr6.pjk18 
     ELSE
        LET l_bdate = sr6.pjk23
     END IF
 
     UPDATE tmp_pjk  SET pjk22 = l_bdate,
                         pjk23 = l_edate,
                         l_d = 'Y' 
                   WHERE pjk01 = sr6.pjk01
                     AND pjk02 = sr6.pjk02
 
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","tmp_pjk",sr6.pjk01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
 
#No.TQC-840042--begin  
  IF g_success = 'Y' AND l_flag_d='Y' THEN
     CALL p200_upd_6()
  END IF
#No.TQC-840042--end  
 
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION p200_upd()    #將TEMP TABLE中的資料UPDATE 回活動資料 pjk_file 并且更新pjk30為g_today
DEFINE sr      RECORD
               pjk01  LIKE pjk_file.pjk01,
               pjk02  LIKE pjk_file.pjk02,
               pjk18  LIKE pjk_file.pjk18,
               pjk19  LIKE pjk_file.pjk19,
               pjk08  LIKE pjk_file.pjk08,
               pjk14  LIKE pjk_file.pjk14,
               pjk20  LIKE pjk_file.pjk20,
               pjk21  LIKE pjk_file.pjk21,
               pjk22  LIKE pjk_file.pjk22,
               pjk23  LIKE pjk_file.pjk23,
               l_z    LIKE type_file.chr1,     #正推否
               l_d    LIKE type_file.chr1      #倒推否
               END RECORD
DEFINE l_days  LIKE type_file.num5
DEFINE l_maxdate LIKE type_file.dat
DEFINE l_sql   STRING
 
  LET l_sql="SELECT pjk01,pjk02,pjk18,pjk19,pjk08,pjk14,pjk20,pjk21,pjk22,pjk23,l_z,l_d FROM tmp_pjk" 
            
  DECLARE p200_cs7 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs7 INTO sr.*
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs7',STATUS,1)
        EXIT FOREACH
     END IF
 
     UPDATE pjk_file  SET pjk20 = sr.pjk20,
                          pjk21 = sr.pjk21,
                          pjk22 = sr.pjk22,
                          pjk23 = sr.pjk23,
                          pjk30 = g_today               
                    WHERE pjk01 = sr.pjk01
                      AND pjk02 = sr.pjk02
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","pjk_file",sr.pjk01,sr.pjk02,SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
     IF g_success = 'N' THEN
        EXIT FOREACH
     END IF
 
  END FOREACH
  IF g_success = 'N' THEN
     RETURN
  END IF
 
END FUNCTION
 
FUNCTION p200_upd_net()    #更新網絡的推算開工日期 /推算完工日期 UPDATE pjj_file
DEFINE  l_pja19   LIKE pja_file.pja19  
DEFINE  l_pjj01   LIKE pjj_file.pjj01  
DEFINE  l_pjj07   LIKE pjj_file.pjj07    #推算開工日期  
DEFINE  l_pjj08   LIKE pjj_file.pjj08    #推算完工日期 
DEFINE  l_sql     STRING
 
  LET l_sql="SELECT pjj01,pja19 FROM pja_file,pjj_file WHERE pja01=pjj04 ",
            " AND ",g_wc CLIPPED
 
  DECLARE p200_cs8 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs8 INTO l_pjj01,l_pja19
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs8',STATUS,1)
        EXIT FOREACH
     END IF
     IF l_pja19 = '1' THEN
        SELECT MIN(pjk20) INTO l_pjj07 FROM pjk_file WHERE pjk01 = l_pjj01
        SELECT MAX(pjk21) INTO l_pjj08 FROM pjk_file WHERE pjk01 = l_pjj01
     ELSE
        IF l_pja19 = '2' THEN
           SELECT MIN(pjk22) INTO l_pjj07 FROM pjk_file WHERE pjk01 = l_pjj01
           SELECT MAX(pjk23) INTO l_pjj08 FROM pjk_file WHERE pjk01 = l_pjj01
        END IF
     END IF
     UPDATE pjj_file  SET pjj07 = l_pjj07,
                          pjj08 = l_pjj08 
                    WHERE pjj01 = l_pjj01
     IF SQLCA.sqlcode THEN                     #置入資料庫不成功
        CALL cl_err3("upd","pjj_file",l_pjj01,"",SQLCA.sqlcode,"","",1)  
        LET g_success = 'N' 
     END IF
 
 END FOREACH
 
END FUNCTION
 
FUNCTION p200_upd_wbs()    #更新WBS的推算日期/UPDATE pjb_file
DEFINE  l_pja19   LIKE pja_file.pja19  
DEFINE  l_pja20   LIKE pja_file.pja20  
DEFINE  l_pjb17   LIKE pjb_file.pjb17  
DEFINE  l_pjb18   LIKE pjb_file.pjb18  
DEFINE  l_pjj01   LIKE pjj_file.pjj01  
DEFINE  l_pjj04   LIKE pjj_file.pjj04    #專案編號 
DEFINE  l_pjk11   LIKE pjk_file.pjk11    #WBS編碼 
DEFINE  l_sql     STRING
 
  LET l_sql="SELECT pjj01,pjj04,pja19,pja20,pjk11 FROM pja_file,pjj_file,pjk_file",
            " WHERE pja01=pjj04 ",
            " AND pjk01 = pjj01",
            " AND ",g_wc CLIPPED
 
  DECLARE p200_cs9 CURSOR FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  FOREACH p200_cs9 INTO l_pjj01,l_pjj04,l_pja19,l_pja20,l_pjk11
   
     IF STATUS THEN
        LET g_success='N'
        CALL cl_err('foreach p200_cs9',STATUS,1)
        EXIT FOREACH
     END IF
     IF l_pja20 ='Y' THEN
        IF l_pja19 = '1' THEN
           SELECT MIN(pjk20) INTO l_pjb17 FROM pjk_file 
            WHERE pjk01=l_pjj01 AND pjk11 = l_pjk11
           SELECT MAX(pjk21) INTO l_pjb18 FROM pjk_file 
            WHERE pjk01=l_pjj01 AND pjk11 = l_pjk11
        ELSE
           IF l_pja19 = '2' THEN
              SELECT MIN(pjk22) INTO l_pjb17 FROM pjk_file 
               WHERE pjk01=l_pjj01 AND pjk11 = l_pjk11
              SELECT MAX(pjk23) INTO l_pjb18 FROM pjk_file 
               WHERE pjk01=l_pjj01 AND pjk11 = l_pjk11
           END IF
        END IF
        UPDATE pjb_file SET pjb17=l_pjb17,
                            pjb18=l_pjb18
                        WHERE pjb02 = l_pjk11
                          AND pjb01 = l_pjj04
        IF SQLCA.sqlcode THEN                     #置入資料庫不成功
           CALL cl_err3("upd","pjb_file",l_pjj04,l_pjk11,SQLCA.sqlcode,"","",1)  
           LET g_success = 'N' 
        END IF
     END IF
  END FOREACH
 
END FUNCTION
#No.FUN-790025
