# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: abxp502.4gl
# Descriptions...: 保稅機器設備年度結算統計作業
# Date & Author..: 2006/10/14 By kim
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
         tm           RECORD
                      bzg01  LIKE bzg_file.bzg01
                      END RECORD,
         g_bza     RECORD LIKE bza_file.*,
         g_cnt        LIKE type_file.num5,
         g_no         LIKE bzg_file.bzg01,
         g_flag       LIKE type_file.chr1
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   CALL p502_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p502_tm() 
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_cnt         LIKE type_file.num5
 
   LET p_row = 6 LET p_col = 25
 
   OPEN WINDOW p502_w AT p_row,p_col WITH FORM "abx/42f/abxp502" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   WHILE TRUE
     IF s_shut(0) THEN
        RETURN
     END IF
     CLEAR FORM 
     LET tm.bzg01 = ''
      
     INPUT BY NAME tm.bzg01 WITHOUT DEFAULTS 
 
         AFTER FIELD bzg01
            IF NOT cl_null(tm.bzg01) THEN
               IF tm.bzg01 <= 0 THEN
                  CALL cl_err('','aap-022',0)
                  NEXT FIELD bzg01
               END IF
            END IF
 
         ON ACTION CONTROLR
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
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF cl_sure(0,0) THEN
         CALL abxp502()     #資料處理
         IF g_success = 'Y' AND g_cnt > 0 THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag     #批次作業正確結束
         ELSE 
            IF g_cnt = 0 THEN
               CALL cl_err('','mfg2601',0)       #無符合條件的資料
            END IF
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag     #批次作業失敗
         END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW p502_w
END FUNCTION
 
FUNCTION abxp502()
 
    DECLARE p502_curs CURSOR 
      FOR SELECT * FROM bza_file WHERE bzaacti = 'Y'
 
    LET g_success = 'Y'
    BEGIN WORK
    LET g_cnt = 0
    LET g_no = tm.bzg01 - 1
    DELETE FROM bzg_file WHERE bzg01 = tm.bzg01
    IF SQLCA.sqlcode THEN
       LET g_success = 'N'
       RETURN
    END IF 
    FOREACH p502_curs INTO g_bza.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       CALL p502_bzg()  #INSERT 保稅機器設備年統計檔 
       IF g_success = 'N' THEN
          EXIT FOREACH 
       END IF
    END FOREACH
    MESSAGE " "
END FUNCTION
 
#INSERT 保稅機器設備年統計檔
FUNCTION p502_bzg()
   DEFINE l_bzg RECORD LIKE bzg_file.*
 
   IF g_success = 'N' THEN RETURN END IF 
   INITIALIZE l_bzg.* TO NULL
 
   LET l_bzg.bzg01 = tm.bzg01
   LET l_bzg.bzg02 = g_bza.bza01
   LET l_bzg.bzg03 = 0
   #抓上期期末數量
   SELECT bzg10 INTO l_bzg.bzg03 FROM bzg_file
          WHERE bzg01 = g_no AND bzg02 = g_bza.bza01
   IF cl_null(l_bzg.bzg03) THEN
      LET l_bzg.bzg03 = 0
   END IF
   LET l_bzg.bzg04   = g_bza.bza09
   SELECT SUM(bzb10-bzb11) INTO l_bzg.bzg05 FROM bzb_file
          WHERE bzb01=g_bza.bza01
   SELECT SUM(bzb12) INTO l_bzg.bzg06 FROM bzb_file
          WHERE bzb01=g_bza.bza01
   SELECT SUM(bzb13) INTO l_bzg.bzg07 FROM bzb_file
          WHERE bzb01=g_bza.bza01
   IF cl_null(l_bzg.bzg04) THEN
      LET l_bzg.bzg04 = 0
   END IF
   IF cl_null(l_bzg.bzg05) THEN
      LET l_bzg.bzg05 = 0
   END IF
   IF cl_null(l_bzg.bzg06) THEN
      LET l_bzg.bzg06 = 0
   END IF
   IF cl_null(l_bzg.bzg07) THEN
      LET l_bzg.bzg07 = 0
   END IF
   LET l_bzg.bzg08   = l_bzg.bzg04 - l_bzg.bzg05 - l_bzg.bzg06 - l_bzg.bzg07 + l_bzg.bzg03
 
   SELECT SUM(bzf07) INTO l_bzg.bzg09 
     FROM bzf_file,bze_file
    WHERE bzf03=g_bza.bza01
      AND bzf01=bze01
      AND bze04=tm.bzg01            #年度
   IF cl_null(l_bzg.bzg09) THEN
      LET l_bzg.bzg09 = 0
   END IF
   LET l_bzg.bzg10   = l_bzg.bzg09
   LET l_bzg.bzgacti = 'Y'
   LET l_bzg.bzguser = g_user
   LET l_bzg.bzggrup = g_grup
   LET l_bzg.bzgmodu = ''
   LET l_bzg.bzgdate = g_today
 
   LET l_bzg.bzgplant = g_plant  ##FUN-980001 add
   LET l_bzg.bzglegal = g_legal  ##FUN-980001 add
 
   LET l_bzg.bzgoriu = g_user      #No.FUN-980030 10/01/04
   LET l_bzg.bzgorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO bzg_file VALUES(l_bzg.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
      LET g_success = 'N' 
      #新增保稅機器設備年統計檔失敗!
      CALL cl_err(l_bzg.bzg01,'abx-037',1)
   END IF
END FUNCTION
