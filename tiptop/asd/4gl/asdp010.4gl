# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdp010.4gl
# Descriptions...: COST ROLL UP
# Date & Author..: 98/06/23 By Eric
# Modify.........: No.MOD-530738 05/08/28 By kim 修正"stb07未考慮發料/成本單位換算率"
# Modify ........: No.FUN-570150 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.MOD-930007 09/03/02 By Pengu 在INSERT/UPDTE _imb_file時會出現不可將null寫入不可空白欄位訊息
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-C50140 12/05/21 By ck2yuan 抓取bom資料應串主件於aimi100的主特性代碼

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   tm       RECORD
                   wc    LIKE type_file.chr1000,      #No.FUN-690010 VARCHAR(300),
                  yy     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
                  mm     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
                  dd     LIKE type_file.dat          #No.FUN-690010DATE
                  END RECORD,
         g_sql    string  #No.FUN-580092 HCN
DEFINE   g_flag   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE ls_date         STRING,               #No.FUN-570150
       g_date          LIKE type_file.dat,          #No.FUN-690010DATE,                 #No.FUN-570150  
       g_change_lang   LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)              #No.FUN-570150  
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #-->No.FUN-570150 --start
    INITIALIZE g_bgjob_msgfile TO NULL
    LET tm.yy    = ARG_VAL(1)                         #計算年
    LET tm.mm    = ARG_VAL(2)                         #計算月
    LET ls_date  = ARG_VAL(3)                         #基準日
    LET g_date   = cl_batch_bg_date_convert(ls_date)
    LET g_bgjob  = ARG_VAL(4)
 
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = 'N'
    END IF
   #--- No.FUN-570150 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
 
    WHILE TRUE
        LET g_flag = 'Y'
        IF g_bgjob = "N" THEN         --> add FUN-570150
            CALL p010_tm()
            IF g_flag = 'N' THEN
               CONTINUE WHILE
            END IF
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
            IF cl_sure(21,21) THEN
               BEGIN WORK
               LET g_success='Y'
               CALL p010_process()
               IF g_success = 'Y' THEN
                   COMMIT WORK
                   CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
               ELSE
                   ROLLBACK WORK
                   CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
               END IF
               IF g_flag THEN
                  CONTINUE WHILE
               ELSE
                  CLOSE WINDOW p010_w   #NO.FUN-570150
                  EXIT WHILE
               END IF
            END IF
        ELSE 
            BEGIN WORK
            LET g_success = 'Y'
            CALL p010_process()
            IF g_success = "Y" THEN
                COMMIT WORK
            ELSE
                ROLLBACK WORK
            END IF
            CALL cl_batch_bg_javamail(g_success)
            EXIT WHILE
        END IF
        IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
    END WHILE
    UPDATE STATISTICS FOR TABLE sta_file
    UPDATE STATISTICS FOR TABLE stb_file
    ERROR ''
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION p010_tm()
DEFINE   lc_cmd                 LIKE type_file.chr1000       #No.FUN-690010CHAR(500)               #No.FUN-570150
 
    OPEN WINDOW p010_w WITH FORM "asd/42f/asdp010"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
   CLEAR FORM
   CALL cl_opmsg('z')
   INITIALIZE tm.* TO NULL
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   LET g_bgjob = 'N'                      #add FUN-570150
#-->No.FUN-570150 --start
   WHILE TRUE                              #add FUN-570150
 
   #INPUT BY NAME tm.yy,tm.mm,tm.dd WITHOUT DEFAULTS    #modi FUN-570150
   INPUT BY NAME tm.yy,tm.mm,tm.dd,g_bgjob WITHOUT DEFAULTS    #modi FUN-570150
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            NEXT FIELD yy 
         END IF
 
      AFTER FIELD mm
         IF cl_null(tm.mm) THEN
            NEXT FIELD mm 
         END IF
 
      AFTER FIELD dd
         IF cl_null(tm.dd) THEN
            LET tm.dd=g_today
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
 
      ON ACTION locale   #genero
#NO.FUN-570150 MARK
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570150 MARK
         LET g_change_lang = TRUE                    #NO.FUN-570150
         EXIT INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570150 start--
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      LET g_flag = 'N'
#      RETURN
#   END IF
#   IF INT_FLAG THEN
#      RETURN
#   END IF
   #-->No.FUN-570150 --start--
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW p010_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "asdp010"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('asdp010','9031',1)   
          
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",tm.yy CLIPPED,"'",
                       " '",tm.mm CLIPPED,"'",
                       " '",tm.dd CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('asdp010',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p010_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
   END IF
   EXIT WHILE
 END WHILE
 #No.FUN-570150 ---end--
 
END FUNCTION
 
FUNCTION p010_process()
DEFINE l_max_llc LIKE type_file.num5          #No.FUN-690010SMALLINT #最大低階碼
DEFINE l_level   LIKE type_file.num5          #No.FUN-690010SMALLINT #本階低階碼
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_ima08 LIKE ima_file.ima08
DEFINE l_sta   RECORD LIKE sta_file.*
DEFINE l_stb   RECORD LIKE stb_file.*
DEFINE l_lstb   RECORD LIKE stb_file.* #下階 stb
DEFINE l_bmb   RECORD LIKE bmb_file.*
DEFINE l_lastyy,l_lastmm LIKE type_file.num5          #No.FUN-690010SMALLINT
DEFINE l_sql    LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(300)
DEFINE l_chr    LIKE type_file.chr1,
       l_bdate  LIKE pmm_file.pmm04,
       l_edate  LIKE pmm_file.pmm04,
       l_bz     LIKE pmj_file.pmj05,
       l_hl     LIKE rvw_file.rvw12



  #No.FUN-570150 --start--
   IF g_bgjob = "N" THEN
      CALL cl_wait()
   END IF
  #No.FUN-570150 ---end---
 
  IF tm.dd IS NULL THEN
     LET tm.dd=TODAY
  END IF
  LET l_lastmm=tm.mm-1
  LET l_lastyy=tm.yy
  IF l_lastmm=0 THEN LET l_lastmm=12 LET l_lastyy=tm.yy-1 END IF
  #-->得出所有料件之最大低階碼 l_max_llc
  SELECT MAX(ima16) INTO l_max_llc FROM ima_file
 
  #-->刪除原先已存在的資料
  DELETE FROM stb_file WHERE stb02=tm.yy AND stb03=tm.mm
  IF SQLCA.SQLCODE THEN
     LET g_success='N'
     RETURN
  END IF
  #-->準備cursor
  #LET l_sql = "SELECT * FROM bmb_file  WHERE bmb01= ? "         　　　　　　　　　　　　　         #MOD-C50140 mark
   LET l_sql = "SELECT * FROM bmb_file,ima_file  WHERE bmb01= ? AND bmb01=ima01 AND bmb29=ima910 "  #MOD-C50140 add
   PREPARE p010_prebmb   FROM l_sql 
   DECLARE p010_curbmb CURSOR FOR p010_prebmb  
 
  FOR l_level=l_max_llc TO 0 STEP -1
    #DECLARE p010_curs CURSOR WITH HOLD FOR
    DECLARE p010_curs CURSOR FOR
      SELECT ima01,ima08 FROM ima_file WHERE ima16=l_level
    FOREACH p010_curs INTO l_ima01,l_ima08
      IF SQLCA.SQLCODE THEN
        CALL cl_err('p010_curs',SQLCA.SQLCODE,0)   
         
         LET g_success='N'
         RETURN
      END IF
      SELECT * INTO l_sta.* FROM sta_file WHERE sta01=l_ima01
      IF SQLCA.sqlcode THEN
         LET l_sta.sta01=l_ima01 LET l_sta.sta02='1'
         LET l_sta.sta03=0       LET l_sta.sta04=0  LET l_sta.sta05=0
         LET l_sta.sta06=0       LET l_sta.sta06a=0 LET l_sta.sta07='XXXXXX'
         LET l_sta.sta08=0       LET l_sta.sta09=0
         INSERT INTO sta_file VALUES(l_sta.*)
      END IF
         #-->本階直接材料成本
      #   LET l_stb.stb04=l_sta.sta04      #tianry add 170303

          #抓取最近小于等于最近月份的采购单价
         CALL s_azm(tm.yy,tm.mm) RETURNING l_chr,l_bdate,l_edate   #tm.b_date,tm.e_date
         LET l_stb.stb04=0
         DECLARE sel_pmn_cur  CURSOR FOR
         SELECT pmj07,pmj05 FROM pmj_file,pmi_file WHERE pmi01=pmj01 AND pmiconf='Y' AND 
         pmj03=l_ima01  ORDER BY pmj09 DESC
      #   SELECT pmn31 FROM pmn_file,pmm_file WHERE pmn01=pmm01 AND pmn04=l_ima01 
      #   AND pmm18='Y' AND pmm04<=l_edate AND pmm02!='SUB' ORDER BY pmm04 DESC 
         OPEN sel_pmn_cur 
         FOREACH sel_pmn_cur  INTO  l_stb.stb04,l_bz
            CALL s_curr3(l_bz,l_edate,'S')  #TQC-840062 mark
                    RETURNING l_hl
            IF cl_null(l_hl) THEN LET l_hl = 1 END IF
            LET l_stb.stb04 = l_stb.stb04 * l_hl
            IF l_stb.stb04 > 0 THEN EXIT FOREACH END IF
         END FOREACH
         CLOSE sel_pmn_cur
         IF cl_null(l_stb.stb04) THEN LET l_stb.stb04=0 END IF 

         IF l_sta.sta05 IS NULL THEN LET l_sta.sta05 = 0 END IF
         IF l_sta.sta03 IS NULL THEN LET l_sta.sta03 = 0 END IF
         IF l_sta.sta09 IS NULL THEN LET l_sta.sta09 = 0 END IF
         IF l_sta.sta08 IS NULL THEN LET l_sta.sta08 = 0 END IF
 
         #-->本階直接人工成本=
         #   (本階直接人工工資率 * 標準工時) * (1-(內製外包率/100)) +
         #   (加工費用 * (內製外包率/100)
         LET l_stb.stb05=(l_sta.sta05*l_sta.sta03)*(1-(l_sta.sta09/100))+
                         (l_sta.sta08*(l_sta.sta09/100))
 
         #-->本階間接製造費用 = 本階間接製造費用分攤率 *  標準工時
         LET l_stb.stb06=l_sta.sta06*l_sta.sta03
 
         #-->本階其他製造費用
         LET l_stb.stb06a=l_sta.sta06a
 
         IF cl_null(l_stb.stb05)  THEN LET l_stb.stb05 = 0 END IF
         IF cl_null(l_stb.stb06)  THEN LET l_stb.stb06 = 0 END IF
         IF cl_null(l_stb.stb06a) THEN LET l_stb.stb06a = 0 END IF
         LET l_stb.stb07=l_stb.stb04    #累計直接材料成本(含本階)
         LET l_stb.stb08=l_stb.stb05    #累計直接人工(含本階)
         LET l_stb.stb09=l_stb.stb06    #累計間接製造費用(含本階)
         LET l_stb.stb09a=l_stb.stb06a  #累計其他製造費用(含本階)
 
      #-->如果sta02='0'(不重新計算)
      IF l_sta.sta02='0' THEN
         SELECT * INTO l_stb.* FROM stb_file
          WHERE stb01=l_ima01 AND stb02=l_lastyy AND stb03=l_lastmm
           IF SQLCA.sqlcode  THEN
              LET l_stb.stb04=0  LET l_stb.stb05=0  LET l_stb.stb06=0
              LET l_stb.stb07=0  LET l_stb.stb08=0  LET l_stb.stb09=0
              LET l_stb.stb06a=0 LET l_stb.stb09a=0
           END IF
      ELSE
         IF l_ima08 not matches '[PVZ]' THEN
            FOREACH p010_curbmb USING l_ima01 INTO l_bmb.*
              IF SQLCA.SQLCODE THEN
                 CALL cl_err('p010_curbmb',SQLCA.SQLCODE,0)
                 LET g_success='N'
                 RETURN
              END IF
              #-->日期不符合不做
              IF l_bmb.bmb04 IS NOT NULL THEN      
                 IF tm.dd < l_bmb.bmb04 THEN CONTINUE FOREACH END IF
              END IF
              IF l_bmb.bmb05 IS NOT NULL THEN
                 IF tm.dd >= l_bmb.bmb05 THEN
                    CONTINUE FOREACH
                 END IF
              END IF
              SELECT * INTO l_lstb.* FROM stb_file
               WHERE stb01=l_bmb.bmb03 AND stb02=tm.yy AND stb03=tm.mm
             #CHI-A70049---mark---start---
             #if status then display status,'  ',l_bmb.bmb03 at 2,1 end if
             #IF cl_null(l_lstb.stb07) THEN LET l_lstb.stb07 = 0 END IF
             #IF cl_null(l_lstb.stb08) THEN LET l_lstb.stb08 = 0 END IF
             #IF cl_null(l_lstb.stb09) THEN LET l_lstb.stb09 = 0 END IF
             #IF cl_null(l_lstb.stb09a) THEN LET l_lstb.stb09a = 0 END IF
             #CHI-A70049---mark---end---
 
              #-->當要不考慮損耗率時
              IF l_sta.sta02='1' THEN
                 LET l_stb.stb07=l_stb.stb07+
                     #MOD-530738................begin
                   #(l_lstb.stb07*l_bmb.bmb06/l_bmb.bmb07)
                    (l_lstb.stb07*l_bmb.bmb10_fac2*l_bmb.bmb06/l_bmb.bmb07)
                     #MOD-530738................end
                 LET l_stb.stb08=l_stb.stb08+
                     (l_lstb.stb08*l_bmb.bmb06/l_bmb.bmb07)
                 LET l_stb.stb09=l_stb.stb09+
                     (l_lstb.stb09*l_bmb.bmb06/l_bmb.bmb07)
                 LET l_stb.stb09a=l_stb.stb09a+
                     (l_lstb.stb09a*l_bmb.bmb06/l_bmb.bmb07)
              END IF
              #-->當要考慮損耗率時
              IF l_sta.sta02='2' THEN
                 LET l_stb.stb07=l_stb.stb07+
                      #MOD-530738................begin
                    #(l_lstb.stb07*l_bmb.bmb06/l_bmb.bmb07)*(1+l_bmb.bmb08/100)
                     (l_lstb.stb07*l_bmb.bmb10_fac2*l_bmb.bmb06/l_bmb.bmb07)*(1+l_bmb.bmb08/100)
                     #MOD-530738................end
                 LET l_stb.stb08=l_stb.stb08+
                     (l_lstb.stb08*l_bmb.bmb06/l_bmb.bmb07)*(1+l_bmb.bmb08/100)
                 LET l_stb.stb09=l_stb.stb09+
                     (l_lstb.stb09*l_bmb.bmb06/l_bmb.bmb07)*(1+l_bmb.bmb08/100)
                 LET l_stb.stb09a=l_stb.stb09a+
                     (l_lstb.stb09a*l_bmb.bmb06/l_bmb.bmb07)*(1+l_bmb.bmb08/100)
              END IF
            END FOREACH
         END IF
      END IF
      LET l_stb.stb01=l_ima01
      LET l_stb.stb02=tm.yy
      LET l_stb.stb03=tm.mm
      LET l_stb.stb10=0
      IF l_stb.stb05 IS NULL THEN LET l_stb.stb05 = 0 END IF
     #-----------------No.MOD-930007 add
      IF cl_null(l_stb.stb04) THEN LET l_stb.stb04 = 0 END IF
      IF cl_null(l_stb.stb05) THEN LET l_stb.stb05 = 0 END IF
      IF cl_null(l_stb.stb06) THEN LET l_stb.stb06 = 0 END IF
      IF cl_null(l_stb.stb06a) THEN LET l_stb.stb06a = 0 END IF
      IF cl_null(l_stb.stb07) THEN LET l_stb.stb07 = 0 END IF
      IF cl_null(l_stb.stb08) THEN LET l_stb.stb08 = 0 END IF
      IF cl_null(l_stb.stb09) THEN LET l_stb.stb09 = 0 END IF
      IF cl_null(l_stb.stb09a) THEN LET l_stb.stb09a = 0 END IF
     #-----------------No.MOD-930007 end
      INSERT INTO stb_file VALUES(l_stb.*)
      IF SQLCA.SQLCODE THEN
         LET g_success='N'
#        CALL cl_err('',SQLCA.SQLCODE,0)   #No.FUN-660120
         CALL cl_err3("ins","stb_file",l_stb.stb01,l_stb.stb02,SQLCA.sqlcode,"","",0)   #No.FUN-660120
         RETURN
      END IF 
    END FOREACH 
  END FOR       
END FUNCTION    
