# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: abxp501.4gl
# Descriptions...: 保稅機器設備盤點資料產生作業
# Date & Author..: 2006/10/14 By kim
 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
         tm RECORD
            wc        STRING,
            sure1     LIKE type_file.chr1,
            sure2     LIKE type_file.chr1,
            bze01  LIKE bze_file.bze01,
            bze02  LIKE bze_file.bze02,
            bze04  LIKE bze_file.bze04
         END RECORD,
         g_bzb     RECORD LIKE bzb_file.*,
         g_cnt        LIKE type_file.num5,
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
   CALL p501_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p501_tm() 
   DEFINE   p_row,p_col   LIKE type_file.num5,
            l_cnt         LIKE type_file.num5
 
   LET p_row = 6 LET p_col = 25
   OPEN WINDOW p501_w AT p_row,p_col WITH FORM "abx/42f/abxp501" 
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.sure1 = 'N'
      LET tm.sure2 = 'N'
 
      CONSTRUCT BY NAME tm.wc ON bza01,bza05,bzb03,bzb04,bza12,bza13
 
         ON ACTION controlp
            CASE 
             WHEN INFIELD(bza01) #機器設備編號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_bza1"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bza01
               NEXT FIELD bza01
             WHEN INFIELD(bzb03) #保管部門
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bzb03
               NEXT FIELD bzb03
             WHEN INFIELD(bzb04) #保管人
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO bzb04
               NEXT FIELD bzb04
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         ON ACTION locale
            CALL cl_dynamic_locale()
         ON ACTION exit        
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION about
            CALL cl_about()
         ON ACTION help
            CALL cl_show_help()
         ON ACTION controlg
            CALL cl_cmdask()
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bzauser', 'bzagrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF 
      
      INPUT BY NAME tm.sure1,tm.sure2,tm.bze01,tm.bze02,tm.bze04
                    WITHOUT DEFAULTS 
         AFTER FIELD sure1
            IF NOT cl_null(tm.sure1) THEN
               IF tm.sure1 NOT MATCHES '[YN]' THEN
                  NEXT FIELD sure1
               END IF  
            END IF 
         
         AFTER FIELD sure2
            IF NOT cl_null(tm.sure2) THEN
               IF tm.sure2 NOT MATCHES '[YN]' THEN
                  NEXT FIELD sure2
               END IF  
            END IF 
         
         AFTER FIELD bze01
            IF NOT cl_null(tm.bze01) THEN
               LET l_cnt = 0
               SELECT count(*) INTO l_cnt FROM bze_file
                WHERE bze01=tm.bze01
               IF l_cnt > 0  THEN 
                  CALL cl_err(tm.bze01,-239,0)
                  NEXT FIELD bze01
               END IF  
            END IF  
 
         AFTER FIELD bze04
            IF NOT cl_null(tm.bze04) THEN
               IF tm.bze04 <= 0 THEN
                  CALL cl_err('','aap-022',0)
                  NEXT FIELD bze04
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
         CALL abxp501()     #資料處理
         IF g_success = 'Y' AND g_cnt > 0 THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag     #批次作業正確結束
         ELSE 
            IF g_cnt = 0 THEN
               CALL cl_err('','mfg2601',0)         #無符合條件的資料
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
   CLOSE WINDOW p501_w
END FUNCTION
 
FUNCTION abxp501()
    DEFINE l_sql STRING
    DEFINE l_cnt LIKE type_file.num5
 
    LET l_sql= "SELECT bzb_file.* FROM bza_file,bzb_file ",
               " WHERE bza01 = bzb01  ",
               " AND bzaacti = 'Y'    ",
               " AND ",tm.wc CLIPPED
 
    IF tm.sure1 = 'N' THEN   #結餘帳面數量為零者是否產生
       LET l_sql = l_sql CLIPPED," AND bzb07 !=0 "
    END IF 
    IF tm.sure2 = 'N' THEN   #已除帳者是否產生
       LET l_sql = l_sql CLIPPED," AND bzb05 != bzb13 "
    END IF 
 
    PREPARE abxp501_prepare1 FROM l_sql
    DECLARE p501_curs CURSOR FOR abxp501_prepare1 
    LET g_success = 'Y'
 
    BEGIN WORK
    CALL p501_bze()  #INSERT 保稅機器設備盤點底稿單頭檔
    LET g_cnt = 0
    FOREACH p501_curs INTO g_bzb.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       SELECT COUNT(*) INTO l_cnt
         FROM bze_file,bzf_file
        WHERE bze01 = bzf01
          AND bze04 = tm.bze04            #年度
          AND bzf03 = g_bzb.bzb01         #機器設備編號
          AND bzf04 = g_bzb.bzb02         #序號
       IF l_cnt > 0 THEN CONTINUE FOREACH END IF
       LET g_cnt = g_cnt + 1
       CALL p501_bzf()  #INSERT 保稅機器設備盤點底稿單身檔
       IF g_success = 'N' THEN
          EXIT FOREACH 
       END IF
    END FOREACH
    MESSAGE " "
END FUNCTION
 
#INSERT 保稅機器設備盤點底稿單頭檔
FUNCTION p501_bze()
   DEFINE l_bze RECORD LIKE bze_file.*
 
   INITIALIZE l_bze.* TO NULL
   LET l_bze.bze01 = tm.bze01
   LET l_bze.bze02 = tm.bze02
   LET l_bze.bze03 = ''
   LET l_bze.bze04 = tm.bze04
   LET l_bze.bze05 = ''
   LET l_bze.bze06 = ''
   LET l_bze.bze07 = 'N'
   LET l_bze.bze08 = ''
   LET l_bze.bze09 = ''
   LET l_bze.bze10 = ''
   LET l_bze.bzeacti = 'Y'
   LET l_bze.bzeuser = g_user
   LET l_bze.bzegrup = g_grup
   LET l_bze.bzemodu = ''
   LET l_bze.bzedate = g_today
   
   LET l_bze.bzeoriu = g_user      #No.FUN-980030 10/01/04
   LET l_bze.bzeorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO bze_file VALUES(l_bze.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
      LET g_success = 'N' 
      #新增保稅機器設備盤點底稿單頭檔失敗!
      CALL cl_err(l_bze.bze01,'abx-035',1)
   END IF
END FUNCTION
 
#INSERT 保稅機器設備盤點底稿單身檔
FUNCTION p501_bzf()
   DEFINE l_bzf RECORD LIKE bzf_file.*
 
   IF g_success = 'N' THEN RETURN END IF 
   INITIALIZE l_bzf.* TO NULL
 
   LET l_bzf.bzf01 = tm.bze01
   LET l_bzf.bzf02 = g_cnt
   LET l_bzf.bzf03 = g_bzb.bzb01
   LET l_bzf.bzf04 = g_bzb.bzb02
   LET l_bzf.bzf05 = g_bzb.bzb07
   LET l_bzf.bzf06 = g_bzb.bzb10
   LET l_bzf.bzf07 = g_bzb.bzb07 + g_bzb.bzb10
   LET l_bzf.bzf08 = ''
   LET l_bzf.bzf09 = ''
   LET l_bzf.bzf10 = ''
 
   INSERT INTO bzf_file VALUES(l_bzf.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
      LET g_success = 'N' 
      #新增保稅機器設備盤點底稿單身檔失敗!
      CALL cl_err(l_bzf.bzf01,'abx-036',1)
   END IF
END FUNCTION
