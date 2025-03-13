# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglp131.4gl
# Descriptions...: 子系統統計資料年底結轉作業
# Date & Author..: NO.FUN-5C0015 05/12/20 By TSD.kevin
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型   
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.MOD-6A0117 06/11/15 By Claire add 期別
# Modify.........: No.FUN-710023 07/01/18 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-740020 07/04/13 By Carrier 會計科目加帳套 - 財務
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9B0035 09/11/27 By Sarah 批次作業背景執行功能
# Modify.........: No:FUN-A30110 10/04/12 By Carrier 客户/厂商简称修改
# Modify.........: No:MOD-A70061 10/07/08 By Dido 取消 afa-131 訊息;增加後面年月檢核
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-C10186 12/02/02 By Polly aglp130已正確抓取npq22，故mark此段不需重抓
# Modify.........: No.CHI-C20022 12/05/31 By jinjj ‘agl-194’回警告訊息,移至 cl_sure(0,0) 前提示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE bookno          LIKE aaa_file.aaa01,     #No.FUN-740020
       yy              LIKE type_file.num10,    #No.FUN-680098  INTEGER
       mm              LIKE type_file.num10,    #CHI-9B0035 add
       g_wc,g_sql      LIKE type_file.chr1000,  #No.FUN-680098   STRING          
       g_npr           RECORD
                        npr08    LIKE npr_file.npr08,
                        npr09    LIKE npr_file.npr09,
                        npr00    LIKE npr_file.npr00,
                        npr01    LIKE npr_file.npr01,
                        npr02    LIKE npr_file.npr02,
                        npr03    LIKE npr_file.npr03,
                        npr11    LIKE npr_file.npr11,  
                        npr04    LIKE npr_file.npr04,
                        npr06    LIKE npr_file.npr06,
                        npr07    LIKE npr_file.npr07,
                        npr06f   LIKE npr_file.npr06f, 
                        npr07f   LIKE npr_file.npr07f  
                       END RECORD
DEFINE l_flag          LIKE type_file.chr1                      #CHI-9B0035 add
DEFINE g_change_lang   LIKE type_file.chr1   #是否有做語言切換  #CHI-9B0035 add
DEFINE p_row,p_col     LIKE type_file.num5                      #CHI-9B0035 add
 
MAIN
#  DEFINE l_time        LIKE type_file.chr8  #No.FUN-6A0073
#  DEFINE p_row,p_col   LIKE type_file.num5  #No.FUN-680098 SMALLINT   #CHI-9B0035 mark
   DEFINE l_cnt         LIKE type_file.num5                     #MOD-A70061  

   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
  #str CHI-9B0035 add
   INITIALIZE g_bgjob_msgfile TO NULL
   LET bookno  = ARG_VAL(1)    #帳別
   LET yy      = ARG_VAL(2)    #結轉年度
   LET g_bgjob = ARG_VAL(3)    #背景作業
   LET g_success = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
  #end CHI-9B0035 add

  #str CHI-9B0035 mark
  #OPEN WINDOW p131_w AT p_row,p_col WITH FORM "agl/42f/aglp131"
  #    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  #CALL cl_ui_init()
  #end CHI-9B0035 mark

  #str CHI-9B0035 add
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p131()
       # CHI-C20022-str-
        LET l_cnt = 0
        SELECT count(*) INTO l_cnt
          FROM npr_file
           WHERE (npr04 = yy AND npr05 >= 1 OR npr04 > yy)
        IF l_cnt > 0 THEN
           CALL cl_err(' ','agl-194',1)
        END IF
       # CHI-C20022-end-
        #-MOD-A70061-mark-
        #IF ((g_aza.aza02='1' AND mm=12) OR      
        #    (g_aza.aza02='2' AND mm=13)) THEN         
            IF NOT cl_sure(0,0) THEN EXIT WHILE END IF
        #ELSE                                  
        #   CALL cl_err(' ','afa-131',1)     
        #   EXIT WHILE                 
        #END IF    
        #-MOD-A70061-end-
         LET g_success = 'Y'
         BEGIN WORK
         CALL p131_process()
         CALL s_showmsg()
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
       # CHI-C20022-str-mark-
           ##-MOD-A70061-add-
            #LET l_cnt = 0
            #SELECT count(*) INTO l_cnt 
            #  FROM npr_file
            # WHERE (npr04 = yy AND npr05 >= 1 OR npr04 > yy)
            #IF l_cnt > 0 THEN
            #   CALL cl_err(' ','agl-194',1)     
            #END IF  
           ##-MOD-A70061-add-
       # CHI-C20022-end-mark-
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p131_w
            EXIT WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p131_process()
         CALL s_showmsg()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
  #end CHI-9B0035 add

  #str CHI-9B0035 mark
  #LET yy = YEAR(TODAY) - 1
  #CALL p131()
  #IF INT_FLAG THEN LET INT_FLAG = 0 END IF
  #end CHI-9B0035 mark
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION p131()
   DEFINE l_flag  LIKE type_file.num5      #No.FUN-680098  SMALLINT
   DEFINE lc_cmd  LIKE type_file.chr1000   #CHI-9B0035 add
 
  #str CHI-9B0035 add
   OPEN WINDOW p131_w AT p_row,p_col WITH FORM "agl/42f/aglp131"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
  #end CHI-9B0035 add

WHILE TRUE
   LET g_action_choice = ""
 
   CLEAR FORM
   LET bookno = g_aza.aza81  #No.FUN-740020
   DISPLAY BY NAME bookno    #No.FUN-740020
  #str CHI-9B0035 add
   IF g_aza.aza63 = 'Y' THEN
      SELECT aznn02,aznn04 INTO yy,mm FROM aznn_file
       WHERE aznn01 = g_today AND aznn00 = bookno
   ELSE
      SELECT azn02,azn04 INTO yy,mm  FROM azn_file
       WHERE azn01 = g_today
   END IF
   LET g_bgjob = "N"
   DISPLAY BY NAME yy
  #end CHI-9B0035 add

   INPUT BY NAME bookno,yy WITHOUT DEFAULTS    #No.FUN-740020
 
      #No.FUN-740020  --Begin
      AFTER FIELD bookno
         IF NOT cl_null(bookno) THEN
            CALL p131_bookno(bookno)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(bookno,g_errno,0)
               LET bookno = g_aza.aza81
               DISPLAY BY NAME bookno
               NEXT FIELD bookno
            END IF
         END IF
      #No.FUN-740020  --End  
 
      AFTER FIELD yy
         IF cl_null(yy) THEN
            NEXT FIELD yy
         END IF
         IF yy <= 0 THEN
            NEXT FIELD yy
         END IF
 
      #No.FUN-740020  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(bookno) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               LET g_qryparam.default1 = bookno
               CALL cl_create_qry() RETURNING bookno
               DISPLAY BY NAME bookno
               NEXT FIELD bookno
         END CASE
      #No.FUN-740020  --End  
 
      ON ACTION locale
        #LET g_action_choice='locale'  #CHI-9B0035 mark
        #CALL cl_show_fld_cont()       #CHI-9B0035 mark            
         LET g_change_lang = TRUE      #CHI-9B0035 add
         EXIT INPUT
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
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
  #str CHI-9B0035 mod
  #IF g_action_choice = 'locale' THEN
  #   CALL cl_dynamic_locale()
  #   CONTINUE WHILE
  #END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      CONTINUE WHILE
   END IF
  #end CHI-9B0035 mod
   IF INT_FLAG THEN 
      LET INT_FLAG=0        #CHI-9B0035 add
      CLOSE WINDOW p131_w   #CHI-9B0035 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM          #CHI-9B0035 add
      RETURN
   END IF
  #str CHI-9B0035 add
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01="aglp131"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aglp131','9031',1)  
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",bookno CLIPPED,"'",
                      " '",yy CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " 'Y'"
         CALL cl_cmdat('aglp131',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p131_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
  #end CHI-9B0035 add

  #str CHI-9B0035 mark
  #IF cl_sure(0,0) THEN 
  #   LET g_success = 'Y'
  #   BEGIN WORK
  #   CALL p131_process()
  #   CALL s_showmsg()        #NO.FUN-710023
  #   IF g_success = 'Y' THEN
  #      COMMIT WORK
  #      CALL cl_end2(1) RETURNING l_flag
  #   ELSE
  #      ROLLBACK WORK
  #      CALL cl_end2(2) RETURNING l_flag
  #   END IF
  #   IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
  #END IF
  #end CHI-9B0035 mark
  EXIT WHILE      #No.FUN-A30110
END WHILE
END FUNCTION
 
#No.FUN-740020  --Begin
FUNCTION p131_bookno(p_bookno)
  DEFINE p_bookno   LIKE aaa_file.aaa01,
         l_aaaacti  LIKE aaa_file.aaaacti
 
    LET g_errno = ' '
    SELECT aaaacti INTO l_aaaacti FROM aaa_file WHERE aaa01=p_bookno
    CASE
        WHEN l_aaaacti = 'N' LET g_errno = '9028'
        WHEN STATUS=100      LET g_errno = 'anm-062' #No.7926
        OTHERWISE LET g_errno = SQLCA.sqlcode USING'-------'
	END CASE
END FUNCTION
#No.FUN-740020  --End  
 
FUNCTION p131_process()
   DEFINE l_aag04 LIKE aag_file.aag04
   DEFINE l_npr   RECORD LIKE npr_file.*      #No.FUN-A30110
 
   LET g_sql =
        "SELECT npr08,npr09,npr00,npr01,npr02,npr03,npr11,npr04,",         
        "       SUM(npr06),SUM(npr07),",  
        "       SUM(npr06f),SUM(npr07f)", 
        "  FROM npr_file WHERE npr04 = ",yy,
        "   AND npr09 = '",bookno,"'",      #No.FUN-740020
        " GROUP BY npr08,npr09,npr00,npr01,npr02,npr03,npr11,npr04"
   PREPARE p131_prepare FROM g_sql
   DECLARE p131_cs CURSOR WITH HOLD FOR p131_prepare
   IF STATUS THEN 
      CALL cl_err('Lock npr_file fail:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      CLOSE WINDOW p131_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   LET yy = yy + 1
   DELETE FROM npr_file WHERE npr04 = yy
      AND npr05=0  #MOD-6A0117 add
      AND npr09=bookno   #No.FUN-740020
   CALL s_showmsg_init()                 #NO.FUN-710023
   FOREACH p131_cs INTO g_npr.*
      IF STATUS THEN
#        CALL cl_err('p131(ckp#1):',SQLCA.sqlcode,1)     #NO.FUN-710023
         LET g_showmsg=yy,"/",'0'                        #NO.FUN-710023 
         CALL s_errmsg('npr04,npr05',g_showmsg,'p131(ckp#1):',SQLCA.sqlcode,1)   #NO.FUN-710023
         LET g_success = 'N'
         EXIT FOREACH
      END IF
#NO.FUN-710023--BEGIN                                                           
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
#NO.FUN-710023--END
      # 科目(npr00)若為損益類的，不做年底結轉
      SELECT aag04 INTO l_aag04 FROM aag_file 
        WHERE aag01 = g_npr.npr00
          AND aag00 = bookno  #No.FUN-740020
      IF STATUS THEN
         CONTINUE FOREACH
      END IF
      IF l_aag04 = '2' THEN
         CONTINUE FOREACH
      END IF

     #------------------------------------MOD-C10186-----------------------mark
     ##No.FUN-A30110  --Begin                                                   
     #IF g_npr.npr01 MATCHES 'MISC*' OR g_npr.npr01 MATCHES 'EMPL*' THEN        
     #ELSE                                                                      
     #   SELECT pmc03 INTO g_npr.npr02 FROM pmc_file                            
     #    WHERE pmc01 = g_npr.npr01                                             
     #   IF SQLCA.sqlcode = 100 THEN                                            
     #      SELECT occ02 INTO g_npr.npr02 FROM occ_file                         
     #       WHERE occ01 = g_npr.npr01                                          
     #   END IF                                                                 
     #END IF                                                                    
     ##No.FUN-A30110  --End 
     #------------------------------------MOD-C10186-----------------------mark

      IF g_bgjob = 'N' THEN   #CHI-9B0035 add
         MESSAGE "Insert npr:",g_npr.npr00,' ',g_npr.npr01,' ',g_npr.npr02,' ',yy
         CALL ui.Interface.refresh()
      END IF                  #CHI-9B0035 add
      INSERT INTO npr_file(npr00,npr01,npr02,npr03,npr04,npr05,
                           npr06,npr07,
                           npr06f,npr07f,       
                           npr08,npr09,npr10,npr11,nprlegal)  #FUN-980003 add nprlegal  
      VALUES(g_npr.npr00 ,g_npr.npr01,g_npr.npr02,g_npr.npr03,yy,0,
             g_npr.npr06 ,g_npr.npr07,
             g_npr.npr06f,g_npr.npr07f,      
             g_npr.npr08 ,g_npr.npr09,'1',g_npr.npr11,g_legal)  #FUN-980003 add g_legal
      #No.FUN-A30110  --Begin
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
         SELECT * INTO l_npr.* FROM npr_file
          WHERE npr08 = g_npr.npr08
            AND npr09 = g_npr.npr09
            AND npr00 = g_npr.npr00
            AND npr10 = '1'
            AND npr01 = g_npr.npr01
            AND npr02 = g_npr.npr02
            AND npr03 = g_npr.npr03
            AND npr11 = g_npr.npr11
            AND npr04 = yy
            AND npr05 = 0
         IF SQLCA.sqlcode THEN
            LET g_showmsg = g_npr.npr08,"/",g_npr.npr09,"/",g_npr.npr00,"/1/",
                            g_npr.npr01,"/",g_npr.npr02,"/",g_npr.npr03,"/",
                            g_npr.npr11,"/",yy,"/0"
            CALL s_errmsg("npr08,npr09,npr00,npr10,npr01,npr02,npr03,npr11,npr04,npr05",g_showmsg,"select npr",SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
         IF cl_null(l_npr.npr06f) THEN LET l_npr.npr06f = 0 END IF
         IF cl_null(l_npr.npr07f) THEN LET l_npr.npr07f = 0 END IF
         IF cl_null(l_npr.npr06)  THEN LET l_npr.npr06  = 0 END IF
         IF cl_null(l_npr.npr07)  THEN LET l_npr.npr07  = 0 END IF
         IF cl_null(g_npr.npr06f) THEN LET g_npr.npr06f = 0 END IF
         IF cl_null(g_npr.npr07f) THEN LET g_npr.npr07f = 0 END IF
         IF cl_null(g_npr.npr06)  THEN LET g_npr.npr06  = 0 END IF
         IF cl_null(g_npr.npr07)  THEN LET g_npr.npr07  = 0 END IF
         LET l_npr.npr06f  = l_npr.npr06f + g_npr.npr06f
         LET l_npr.npr07f  = l_npr.npr07f + g_npr.npr07f
         LET l_npr.npr06   = l_npr.npr06  + g_npr.npr06
         LET l_npr.npr07   = l_npr.npr07  + g_npr.npr07
         UPDATE npr_file SET npr06f = l_npr.npr06f,
                             npr07f = l_npr.npr07f,
                             npr06  = l_npr.npr06,
                             npr07  = l_npr.npr07
          WHERE npr08 = g_npr.npr08
            AND npr09 = g_npr.npr09
            AND npr00 = g_npr.npr00
            AND npr10 = '1'
            AND npr01 = g_npr.npr01
            AND npr02 = g_npr.npr02
            AND npr03 = g_npr.npr03
            AND npr11 = g_npr.npr11
            AND npr04 = yy
            AND npr05 = 0
         IF SQLCA.sqlcode <> 0 THEN
            LET g_showmsg = g_npr.npr08,"/",g_npr.npr09,"/",g_npr.npr00,"/1/",
                            g_npr.npr01,"/",g_npr.npr02,"/",g_npr.npr03,"/",
                            g_npr.npr11,"/",g_npr.npr04,"/0"
            CALL s_errmsg("npr08,npr09,npr00,npr10,npr01,npr02,npr03,npr11,npr04,npr05",g_showmsg,"update npr",SQLCA.sqlcode,1)
            LET g_success='N' 
            CONTINUE FOREACH
         END IF
      ELSE
         IF SQLCA.sqlcode <> 0 THEN
            LET g_showmsg=g_npr.npr00,"/",g_npr.npr01,"/",g_npr.npr02,"/",g_npr.npr03,                 #NO.FUN-710023  
                         "/",g_npr.npr06,"/",g_npr.npr07,"/",g_npr.npr06f,"/",g_npr.npr07f,"/",        #NO.FUN-710023   
                         g_npr.npr08,"/",g_npr.npr09,"/",g_npr.npr11                                   #NO.FUN-710023 
            CALL s_errmsg('npr00,npr01,npr02,npr03,npr06,npr07,npr06f,npr07f,npr08,npr09,npr11',g_showmsg,'p131(ckp#4):',SQLCA.sqlcode,1)         #NO.FUN-710023
            LET g_success = 'N'
            CONTINUE FOREACH                                          #NO.FUN-710023  
         END IF
      END IF
      #No.FUN-A30110  --End  
   END FOREACH
#NO.FUN-710023--BEGIN                                                           
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
#NO.FUN-710023--END
END FUNCTION
