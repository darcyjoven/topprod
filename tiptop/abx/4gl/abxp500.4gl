# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abxp500.4gl
# Descriptions...: 保稅機器設備擷取作業
# Date & Author..: 2006/10/14 By kim
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A20012 10/09/30 By sabrina 擷取時沒有根據(faj38保稅否)作篩選
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No:MOD-BB0110 11/11/12 By johung 修改擷取faj_file保稅否的條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
         tm RECORD
            wc     STRING
         END RECORD,
         g_faj     RECORD LIKE faj_file.*,
         g_cnt     LIKE type_file.num5,
         g_flag    LIKE type_file.chr1
 
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
   CALL p500_tm()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p500_tm()
   DEFINE   p_row,p_col   LIKE type_file.num5
 
   LET p_row = 6 LET p_col = 25
   OPEN WINDOW p500_w AT p_row,p_col WITH FORM "abx/42f/abxp500" 
        ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   WHILE TRUE
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
 
      CONSTRUCT BY NAME tm.wc ON faj04,faj05,faj09,faj021,faj02,faj20,faj19
 
         ON ACTION controlp
            CASE 
                WHEN INFIELD(faj02) #資產編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_faj01"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO faj02
                     NEXT FIELD faj02
                WHEN INFIELD(faj20) #保管部門
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_gem"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO faj20
                     NEXT FIELD faj20
                WHEN INFIELD(faj19) #保管人
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_gen"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO faj19
                     NEXT FIELD faj19
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
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF 
      IF cl_sure(0,0) THEN
         CALL abxp500()     #資料處理
         IF g_success = 'Y' AND g_cnt > 0 THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
         ELSE 
            IF g_cnt = 0 THEN
               CALL cl_err('','mfg2601',0)          #無符合條件的資料
            END IF
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
         END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW p500_w
END FUNCTION
 
FUNCTION abxp500()
    DEFINE l_sql STRING
 
    LET l_sql= "SELECT * FROM faj_file ",
               " WHERE faj43 IN ('1','2','3','4','7','8','9') ",
               "   AND faj021 IN ('1','2') ",
               "   AND (faj115 = 'N' OR faj115 = ' ' OR faj115 IS NULL) ",
               "   AND fajconf = 'Y' ",
              #"   AND faj38 = 'Y' ",          #MOD-A20012 add   #MOD-BB0110 mark
               "   AND faj38 = '1' ",          #MOD-BB0110
               "   AND ",tm.wc CLIPPED,
               " ORDER BY faj02 "
 
    PREPARE abxp500_prepare1 FROM l_sql
    DECLARE p500_curs CURSOR FOR abxp500_prepare1 
    LET g_success = 'Y'
    LET g_cnt = 0
    BEGIN WORK
    FOREACH p500_curs INTO g_faj.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       CALL p500_bza()  #INSERT 保稅機器設備單頭檔
       CALL p500_bzb()  #INSERT 保稅機器設備單身檔
       IF g_success = 'Y' THEN
          UPDATE faj_file SET faj115 = 'Y'
            WHERE faj01 = g_faj.faj01
              AND faj02 = g_faj.faj02
              AND faj022 = g_faj.faj022
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
             LET g_success = 'N' 
             #此固定資產之保稅擷取否欄位更新失敗!
             CALL cl_err(g_faj.faj02,'abx-032',1)
             EXIT FOREACH 
          END IF
       ELSE
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
    MESSAGE " "
END FUNCTION
 
#INSERT 保稅機器設備單頭檔
FUNCTION p500_bza()
   DEFINE l_bza RECORD LIKE bza_file.*
 
   INITIALIZE l_bza.* TO NULL
   IF g_faj.faj021 = '1' THEN
      LET l_bza.bza01 = g_faj.faj02 CLIPPED
   ELSE
      LET l_bza.bza01 = g_faj.faj02 CLIPPED,'-',g_faj.faj021
   END IF
   LET l_bza.bza02 = g_faj.faj06
   LET l_bza.bza03 = g_faj.faj07
   LET l_bza.bza04 = g_faj.faj08
   LET l_bza.bza05 = g_faj.faj021
   LET l_bza.bza06 = g_faj.faj02 
   LET l_bza.bza07 = ' '
   LET l_bza.bza08 = g_faj.faj18 
   LET l_bza.bza09 = g_faj.faj17 
   LET l_bza.bza10 = 0 
   LET l_bza.bza11 = ' '
   LET l_bza.bza12 = ''
   LET l_bza.bza13 = ''
   LET l_bza.bza14 = ''
   LET l_bza.bza15 = ''
   LET l_bza.bza16 = g_faj.faj17
   LET l_bza.bza17 = ''
   LET l_bza.bza18 = ''
   LET l_bza.bza19 = '' 
   LET l_bza.bza20 = ''
   LET l_bza.bzaacti = 'Y'
   LET l_bza.bzauser = g_user
   LET l_bza.bzagrup = g_grup
   LET l_bza.bzamodu = ''
   LET l_bza.bzadate = g_today
   
   LET l_bza.bzaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_bza.bzaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO bza_file VALUES(l_bza.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
      LET g_success = 'N' 
      #新增保稅機器設備單頭檔失敗!
      CALL cl_err(l_bza.bza01,'abx-033',1)
   END IF
END FUNCTION
 
#INSERT 保稅機器設備單身檔
FUNCTION p500_bzb()
   DEFINE l_bzb RECORD LIKE bzb_file.*
 
   IF g_success = 'N' THEN RETURN END IF 
   INITIALIZE l_bzb.* TO NULL
 
   IF g_faj.faj021 = '1' THEN
      LET l_bzb.bzb01 = g_faj.faj02 CLIPPED
   ELSE
      LET l_bzb.bzb01 = g_faj.faj02 CLIPPED,'-',g_faj.faj021
   END IF
   LET l_bzb.bzb02 = 1
   LET l_bzb.bzb03 = g_faj.faj20
   LET l_bzb.bzb04 = g_faj.faj19
   LET l_bzb.bzb05 = g_faj.faj17
   LET l_bzb.bzb06 = g_faj.faj21
   LET l_bzb.bzb07 = g_faj.faj17 
   LET l_bzb.bzb08 = '1'
   LET l_bzb.bzb09 = ''
   LET l_bzb.bzb10 = 0 
   LET l_bzb.bzb11 = 0
   LET l_bzb.bzb12 = 0
   LET l_bzb.bzb13 = 0 
   LET l_bzb.bzb14 = ''
   LET l_bzb.bzb15 = ''
 
   INSERT INTO bzb_file VALUES(l_bzb.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
      LET g_success = 'N' 
      #新增保稅機器設備單身檔失敗!
      CALL cl_err(l_bzb.bzb01,'abx-034',1)
   END IF
END FUNCTION
