# Prog. Version..: '5.30.06-13.03.27(00003)'     #
# Pattern name...: afap997.4gl
# Descriptions...: 財簽二固定資產期初轉檔作業
# Date & Author..: 12/01/12 FUN-BB0093 By Sakura
# Modify.........: No.MOD-BC0131 12/01/12 By Sakura 新增fbn20處理                    
# Modify.........: No.CHI-C60010 12/06/15 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.MOD-D30116 13/03/12 By Polly 如果fbn資料重覆，則updaet資料

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc,g_sql       STRING, 
       tm               RECORD
         wc             STRING, 
         yy             LIKE type_file.num5,    
         mm             LIKE type_file.num5     
                        END RECORD,
       b_date,e_date    LIKE type_file.dat,      
       g_dc             LIKE type_file.chr1,     
       g_amt1,g_amt2    LIKE type_file.num20_6   
DEFINE g_flag           LIKE type_file.chr1,     
       g_change_lang    LIKE type_file.chr1      
DEFINE p_row,p_col      LIKE type_file.num5,     
       m_tot            LIKE type_file.num20_6,
       m_tot_curr       LIKE type_file.num20_6,
       g_cnt,g_cnt2     LIKE type_file.num5,
       m_fad05          LIKE fad_file.fad05,
       m_fad031         LIKE fad_file.fad031,
       m_fae08,mm_fae08 LIKE fae_file.fae08,
       m_aao            LIKE type_file.num20_6,
       m_curr           LIKE type_file.num20_6,  
       m_ratio,mm_ratio LIKE type_file.num26_10,   
       m_max_ratio      LIKE type_file.num26_10,
       m_max_fae06      LIKE fae_file.fae06,
       y_curr           LIKE fan_file.fan08,
       m_fae06          LIKE fae_file.fae06,
       l_diff,l_diff2   LIKE fan_file.fan07,
       g_show_msg       DYNAMIC ARRAY OF RECORD  
                         faj02     LIKE faj_file.faj02,
                         faj022    LIKE faj_file.faj022,
                         ze01      LIKE ze_file.ze01,
                         ze03      LIKE ze_file.ze03
                        END RECORD,
       l_msg,l_msg2     STRING,
       lc_gaq03         LIKE gaq_file.gaq03,
       m_tot_fbn07      LIKE fbn_file.fbn07, 
       m_tot_fbn14      LIKE fbn_file.fbn14, 
       m_tot_fbn15      LIKE fbn_file.fbn15, 
       m_tot_fbn17      LIKE fbn_file.fbn17,
       m_fbn07          LIKE fbn_file.fbn07, 
       m_fbn08          LIKE fbn_file.fbn08, 
       m_fbn14          LIKE fbn_file.fbn14, 
       m_fbn15          LIKE fbn_file.fbn15, 
       m_fbn17          LIKE fbn_file.fbn17,
       mm_fbn07         LIKE fbn_file.fbn07,
       mm_fbn08         LIKE fbn_file.fbn08,
       mm_fbn14         LIKE fbn_file.fbn14,
       mm_fbn15         LIKE fbn_file.fbn15,
       mm_fbn17         LIKE fbn_file.fbn17,
       l_fbn07          LIKE fbn_file.fbn07,
       l_fbn08          LIKE fbn_file.fbn08,
       l_li             LIKE type_file.num10       

MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc  = ARG_VAL(1)
   LET tm.yy  = ARG_VAL(2)
   LET tm.mm  = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   SET LOCK MODE TO WAIT
   IF g_bgjob ='N' THEN
      INITIALIZE tm.* TO NULL
   END IF

   SELECT faa072,faa082 INTO tm.yy,tm.mm FROM faa_file
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p997()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL g_show_msg.clear()  
            CALL p997_1()
            IF g_show_msg.getLength() > 0 THEN 
               CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
               CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
               CONTINUE WHILE
            END IF
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p997_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL g_show_msg.clear()   
         CALL p997_1()
         IF g_show_msg.getLength() > 0 THEN 
            CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
            CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
         END IF
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN

FUNCTION p997()
   DEFINE lc_cmd   LIKE type_file.chr1000

   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p997_w AT p_row,p_col WITH FORM "afa/42f/afap997"
     ATTRIBUTE (STYLE = g_win_style)

   CALL cl_ui_init()
   CALL cl_opmsg('z')

   CLEAR FORM
   
   INITIALIZE tm.* TO NULL
   SELECT faa072,faa082 INTO tm.yy,tm.mm FROM faa_file
   DISPLAY tm.yy TO FORMONLY.yy 
   DISPLAY tm.mm TO FORMONLY.mm 
   
   WHILE TRUE
      CALL cl_opmsg('z')
      CONSTRUCT BY NAME tm.wc ON faj04,faj02,faj25

         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION locale
            LET g_change_lang = TRUE  
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
     
         ON ACTION about       
            CALL cl_about()    
     
         ON ACTION help        
            CALL cl_show_help()
     
         ON ACTION controlg    
            CALL cl_cmdask()   
     
         ON ACTION EXIT
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION qbe_select
            CALL cl_qbe_select()

      END CONSTRUCT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF

      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p997_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      LET g_bgjob ='N'

      INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS  
  
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
      
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.yy
               IF g_azm.azm02 = 1 THEN
                  IF tm.mm > 12 OR tm.mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD mm
                  END IF
               ELSE
                  IF tm.mm > 13 OR tm.mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD mm
                  END IF
               END IF
            END IF
            IF cl_null(tm.mm) THEN
               NEXT FIELD mm 
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
      
         ON ACTION EXIT
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM

         ON ACTION qbe_save
            CALL cl_qbe_save()

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT

      END INPUT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()  
         CONTINUE WHILE
      END IF
     
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW p997_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap997'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap997','9031',1)
         ELSE
            LET g_wc = cl_replace_str(g_wc,"'","\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('afap997',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p997_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION p997_1()
 DEFINE l_faj     RECORD LIKE faj_file.*,
        l_fbn     RECORD LIKE fbn_file.*,
        l_sql     STRING,
        i         LIKE type_file.num10,
        j         LIKE type_file.num10,
        l_cnt     LIKE type_file.num5,
        p_yy,p_mm LIKE type_file.num5,   
        g_fae     RECORD LIKE fae_file.*,
        g_fbn     RECORD LIKE fbn_file.*, 
        l_aag04   LIKE aag_file.aag04
 DEFINE l_azi04   LIKE azi_file.azi04  #CHI-C60010 add
 
  LET l_sql ="SELECT * FROM faj_file WHERE ",tm.wc CLIPPED
  PREPARE p997_pre FROM l_sql
  DECLARE p997_cur CURSOR FOR p997_pre
 
  CALL s_showmsg_init()
  LET i = 0
  LET j = 0
  LET g_cnt2 = 1

  FOREACH p997_cur INTO l_faj.*
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('foreach',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
 
       IF l_faj.faj282 ='0' THEN         #'0'.不提折舊
          CONTINUE FOREACH
       END IF

       LET l_fbn.fbn01 = l_faj.faj02
       LET l_fbn.fbn02 = l_faj.faj022
       LET l_fbn.fbn03 = tm.yy
       LET l_fbn.fbn04 = tm.mm
       LET l_fbn.fbn041= '0'
       LET l_fbn.fbn05 = l_faj.faj232
       LET l_fbn.fbn06 = l_faj.faj20
       LET l_fbn.fbn07 = 0
       LET l_fbn.fbn08 = l_faj.faj2032
       LET l_fbn.fbn10 = l_faj.faj432
       LET l_fbn.fbn11 = l_faj.faj531
       LET l_fbn.fbn12 = l_faj.faj551
       LET l_fbn.fbn13 = l_faj.faj242
       LET l_fbn.fbn14 = l_faj.faj142 + l_faj.faj1412 - l_faj.faj592
       LET l_fbn.fbn15 = l_faj.faj322
       LET l_fbn.fbn16 = 0
       LET l_fbn.fbn17 = l_faj.faj1012

       IF cl_null(l_fbn.fbn06) THEN
          LET l_fbn.fbn06=' '
       END IF

      #資料重覆則跳過不新增,但寫入彙總訊息裡
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM fbn_file
        WHERE fbn01 =l_fbn.fbn01  AND fbn02=l_fbn.fbn02
          AND fbn03 =l_fbn.fbn03  AND fbn04=l_fbn.fbn04
          AND fbn041=l_fbn.fbn041
          AND fbn05 =l_fbn.fbn05  AND fbn06=l_fbn.fbn06
      
       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF

      #--MOD-D30116--mark
      #IF l_cnt > 0 THEN
      #   LET g_showmsg=l_fbn.fbn01,"/",l_fbn.fbn02,"/",l_fbn.fbn03,"/",
      #                 l_fbn.fbn04,"/",l_fbn.fbn041,"/",l_fbn.fbn05,"/",
      #                 l_fbn.fbn06
      #   CALL s_errmsg("fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,fbn06",g_showmsg,
      #                 "insert fbn_file",'-239',1)
      #   CONTINUE FOREACH
      #END IF
      #--MOD-D30116--mark
      #CHI-C60010--add--str--
       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_faj.faj143
       LET l_fbn.fbn08=cl_digcut(l_fbn.fbn08,l_azi04)
       LET l_fbn.fbn14=cl_digcut(l_fbn.fbn14,l_azi04)
       LET l_fbn.fbn15=cl_digcut(l_fbn.fbn15,l_azi04)
       LET l_fbn.fbn17=cl_digcut(l_fbn.fbn17,l_azi04)
      #CHI-C60010--add--end
      #----------------------MOD-D30116------------------(S)
      #INSERT INTO fbn_file VALUES (l_fbn.*)             #MOD-D30116 mark
       IF l_cnt > 0 THEN
          UPDATE fbn_file SET fbn_file.* = l_fbn.*
           WHERE fbn01 = l_fbn.fbn01  AND fbn02 = l_fbn.fbn02
             AND fbn03 = l_fbn.fbn03  AND fbn04 = l_fbn.fbn04
             AND fbn041= l_fbn.fbn041
             AND fbn05 = l_fbn.fbn05  AND fbn06 = l_fbn.fbn06
       ELSE
          INSERT INTO fbn_file VALUES (l_fbn.*)
       END IF
      #----------------------MOD-D30116------------------(E)
       IF g_bgjob = 'N' THEN
          MESSAGE l_faj.faj02,l_faj.faj022
          CALL ui.Interface.refresh()
       END IF

       IF l_faj.faj232 = '2' THEN
          #-------- 折舊明細檔 SQL (針對多部門分攤折舊金額) ---------------
          LET g_sql="SELECT * FROM fbn_file ",
                    " WHERE fbn03='",tm.yy,"'",
                    "   AND fbn04='",tm.mm,"'",
                    "   AND fbn05='2' AND fbn041='0' ",
                    "   AND fbn01='",l_faj.faj02,"'"
          PREPARE p997_pre12 FROM g_sql
          DECLARE p997_cur12 CURSOR WITH HOLD FOR p997_pre12
          FOREACH p997_cur12 INTO g_fbn.*
             IF STATUS THEN
                LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                LET g_show_msg[g_cnt2].ze01   = ''
                LET g_show_msg[g_cnt2].ze03   = 'foreach p997_cur12'
                LET g_cnt2 = g_cnt2 + 1
                LET g_success='N'
                CONTINUE FOREACH
             END IF
             #-->讀取分攤方式
             SELECT fad05,fad03 INTO m_fad05,m_fad031 FROM fad_file
              WHERE fad01=g_fbn.fbn03
                AND fad02=g_fbn.fbn04
                AND fad03=g_fbn.fbn11
                AND fad04=g_fbn.fbn13
                AND fad07="2"
             IF SQLCA.sqlcode THEN
                CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
                LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                LET g_show_msg[g_cnt2].ze01   = 'afa-152'
                LET g_show_msg[g_cnt2].ze03   = l_msg
                LET g_cnt2 = g_cnt2 + 1
                LET g_success='N'
                CONTINUE FOREACH
             END IF
             #-->讀取分母
             IF m_fad05='1' THEN
                SELECT SUM(fae08) INTO m_fae08 FROM fae_file
                  WHERE fae01=g_fbn.fbn03
                    AND fae02=g_fbn.fbn04
                    AND fae03=g_fbn.fbn11
                    AND fae04=g_fbn.fbn13
                    AND fae10="2"
                IF SQLCA.sqlcode OR cl_null(m_fae08) THEN
                   CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
                   LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                   LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                   LET g_show_msg[g_cnt2].ze01   = 'afa-152'
                   LET g_show_msg[g_cnt2].ze03   = l_msg
                   LET g_cnt2 = g_cnt2 + 1
                   LET g_success='N'
                   CONTINUE FOREACH
                END IF
                LET mm_fae08 = m_fae08            # 分攤比率合計
             END IF
  
             #-->保留金額以便處理尾差
             LET mm_fbn07=g_fbn.fbn07          # 被分攤金額
             LET mm_fbn08=g_fbn.fbn08          # 本期累折金額
             LET mm_fbn14=g_fbn.fbn14          # 被分攤成本
             LET mm_fbn15=g_fbn.fbn15          # 被分攤累折
             LET mm_fbn17=g_fbn.fbn17          # 被分攤減值
  
             #------- 找 fae_file 分攤單身檔 ---------------
             LET m_tot=0
             DECLARE p997_cur21 CURSOR WITH HOLD FOR
             SELECT * FROM fae_file
              WHERE fae01=g_fbn.fbn03
                AND fae02=g_fbn.fbn04
                AND fae03=g_fbn.fbn11
                AND fae04=g_fbn.fbn13
                AND fae10="2"
             FOREACH p997_cur21 INTO g_fae.*
                IF SQLCA.sqlcode OR (cl_null(m_fae08) AND m_fad05='1') THEN
                   CALL cl_getmsg("afa-152",g_lang) RETURNING l_msg
                   LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                   LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                   LET g_show_msg[g_cnt2].ze01   = 'afa-152'
                   LET g_show_msg[g_cnt2].ze03   = l_msg
                   LET g_cnt2 = g_cnt2 + 1
                   LET g_success='N'
                   CONTINUE FOREACH
                END IF
                CASE m_fad05
                   WHEN '1'
                      SELECT COUNT(*) INTO l_li FROM fbn_file
                       WHERE fbn01=g_fbn.fbn01
                         AND fbn02=g_fbn.fbn02
                         AND fbn03=g_fbn.fbn03
                         AND fbn04=g_fbn.fbn04
                         AND fbn06=g_fae.fae06
                         AND fbn05='3'
                         AND (fbn041 = '1' OR fbn041='0')
                      IF STATUS=100 THEN
                         LET l_li=NULL
                      END IF
                      LET mm_ratio=g_fae.fae08/mm_fae08*100     # 分攤比率(存入fbn16用)
                      LET m_ratio=g_fae.fae08/m_fae08*100       # 分攤比率
                      LET m_fbn07=mm_fbn07*m_ratio/100          # 分攤金額
                      LET m_curr =mm_fbn08*m_ratio/100          # 分攤金額
                      LET m_fbn14=mm_fbn14*m_ratio/100          # 分攤成本
                      LET m_fbn15=mm_fbn15*m_ratio/100          # 分攤累折
                      LET m_fbn17=mm_fbn17*m_ratio/100          # 分攤減值
                      LET m_fae08 = m_fae08 - g_fae.fae08       # 總分攤比率減少
                      #LET m_fbn07 = cl_digcut(m_fbn07,g_azi04) #CHI-C60010 mark
                      LET mm_fbn07 = mm_fbn07 - m_fbn07         # 被分攤總數減少
                      #LET m_curr   = cl_digcut(m_curr,g_azi04) #CHI-C60010 mark
                      LET mm_fbn08 = mm_fbn08 - m_curr          # 被分攤總數減少
                      #LET m_fbn14 = cl_digcut(m_fbn14,g_azi04) #CHI-C60010 mark 
                      LET mm_fbn14 = mm_fbn14 - m_fbn14         # 被分攤總數減少
                      #LET m_fbn15  = cl_digcut(m_fbn15,g_azi04)#CHI-C60010 mark
                      LET mm_fbn15 = mm_fbn15 - m_fbn15         # 被分攤總數減少
                      #LET m_fbn17  = cl_digcut(m_fbn17,g_azi04)#CHI-C60010 mark
                      LET mm_fbn17 = mm_fbn17 - m_fbn17         # 被分攤總數減少
                  #CHI-C60010--add--str--
                      LET m_fbn07 = cl_digcut(m_fbn07,l_azi04)
                      LET m_curr = cl_digcut(m_curr,l_azi04)
                      LET m_fbn14 = cl_digcut(m_fbn14,l_azi04)
                      LET m_fbn15 = cl_digcut(m_fbn15,l_azi04)
                      LET m_fbn17 = cl_digcut(m_fbn17,l_azi04)
                      LET mm_ratio =cl_digcut(mm_ratio,l_azi04)
                  #CHI-C60010--add--end
                      IF l_li<>0 THEN
                         UPDATE fbn_file SET fbn07 = m_fbn07,
                                             fbn08 = m_curr,
                                             fbn09 = g_fbn.fbn06,
                                             fbn14 = m_fbn14,
                                             fbn15 = m_fbn15,
                                             fbn16 = mm_ratio,
                                             fbn17 = m_fbn17,
                                             fbn11 =m_fad031,
                                             fbn12 =g_fae.fae07
                          WHERE fbn01=g_fbn.fbn01
                            AND fbn02=g_fbn.fbn02
                            AND fbn03=g_fbn.fbn03
                            AND fbn04=g_fbn.fbn04
                            AND fbn06=g_fae.fae06
                            AND fbn05='3'
                            AND (fbn041 = '1' OR fbn041='0')
                         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                            LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                            LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                            LET g_show_msg[g_cnt2].ze01   = ''
                            LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                            LET g_cnt2 = g_cnt2 + 1
                            LET g_success='N'
                            CONTINUE FOREACH
                         END IF
                      ELSE
                         IF cl_null(g_fae.fae06) THEN
                            LET g_fae.fae06=' '
                         END IF
                         INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,
                                              fbn05,fbn06,fbn07,fbn08,fbn09,
                                              fbn10,fbn11,fbn12,fbn13,fbn14,
                                              fbn15,fbn16,fbn17,fbn20) #MOD-BC0131 add fbn20
                                       VALUES(g_fbn.fbn01,g_fbn.fbn02,
                                              g_fbn.fbn03,g_fbn.fbn04,'0','3',
                                              g_fae.fae06,m_fbn07,m_curr,
                                              g_fbn.fbn06,l_faj.faj43,g_fbn.fbn11,       
                                              g_fae.fae07,g_fbn.fbn13,m_fbn14,
                                              m_fbn15,mm_ratio,m_fbn17,g_fbn.fbn20) #MOD-BC0131 add fbn20
                         IF STATUS THEN
                            LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                            LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                            LET g_show_msg[g_cnt2].ze01   = ''
                            LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
                            LET g_cnt2 = g_cnt2 + 1
                            LET g_success='N'
                            CONTINUE FOREACH
                         END IF
                      END IF
                   WHEN '2'
                      LET l_aag04 = ''
                      SELECT aag04 INTO l_aag04 FROM aag_file
                       WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
                      IF l_aag04='1' THEN
                         SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                          WHERE aao00 =m_faa02b    AND aao01=g_fae.fae09
                            AND aao02 =g_fae.fae06 AND aao03=tm.yy
                            AND aao04<=tm.mm
                      ELSE
                         SELECT aao05-aao06 INTO m_aao FROM aao_file
                          WHERE aao00=m_faa02b    AND aao01=g_fae.fae09
                            AND aao02=g_fae.fae06 AND aao03=tm.yy
                            AND aao04=tm.mm
                      END IF
                      IF STATUS=100 OR m_aao IS NULL THEN LET m_aao=0 END IF
                      LET m_tot=m_tot+m_aao          ## 累加變動比率分母金額
                END CASE
             END FOREACH
  
             #----- 若為變動比率, 重新 foreach 一次 insert into fbn_file -----------
             IF m_fad05='2' THEN
                LET m_max_ratio = 0
                LET m_max_fae06 =''
                FOREACH p997_cur21 INTO g_fae.*
                   LET l_aag04 = ''
                   SELECT aag04 INTO l_aag04 FROM aag_file
                    WHERE aag01=g_fae.fae09 AND aag00=g_faa.faa02c
                   IF l_aag04='1' THEN
                      SELECT SUM(aao05-aao06) INTO m_aao FROM aao_file
                       WHERE aao00=m_faa02b    AND aao01=g_fae.fae09
                         AND aao02=g_fae.fae06 AND aao03=tm.yy AND aao04<=tm.mm
                   ELSE
                      SELECT aao05-aao06 INTO m_aao FROM aao_file
                       WHERE aao00=m_faa02b AND aao01=g_fae.fae09
                         AND aao02=g_fae.fae06 AND aao03=tm.yy AND aao04=tm.mm
                   END IF
                   IF STATUS=100 OR m_aao IS NULL THEN
                      LET m_aao=0
                   END IF
                   SELECT SUM(fbn07) INTO y_curr FROM fbn_file
                    WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                      AND fbn03=tm.yy       AND fbn04<tm.mm
                      AND fbn06=g_fae.fae06 AND fbn05='3'

                   IF cl_null(y_curr) THEN
                      LET y_curr = 0
                   END IF
                   LET m_ratio = m_aao/m_tot*100
                   IF m_ratio > m_max_ratio THEN
                      LET m_max_fae06 = g_fae.fae06
                      LET m_max_ratio = m_ratio
                   END IF
                   LET m_ratio = cl_digcut(m_ratio,l_azi04) #CHI-C60010 add
                   LET m_fbn07=g_fbn.fbn07*m_ratio/100
                   LET m_curr = y_curr + m_fbn07
                   LET m_fbn14=g_fbn.fbn14*m_ratio/100
                   LET m_fbn15=g_fbn.fbn15*m_ratio/100
                   LET m_fbn17=g_fbn.fbn17*m_ratio/100
                #CHI-C60010--mark--str--
                   #LET m_fbn07 = cl_digcut(m_fbn07,g_azi04)
                   #LET m_curr = cl_digcut(m_curr,g_azi04)
                   #LET m_fbn14 = cl_digcut(m_fbn14,g_azi04)
                   #LET m_fbn15 = cl_digcut(m_fbn15,g_azi04)
                   #LET m_fbn17 = cl_digcut(m_fbn17,g_azi04)
                #CHI-C60010--mark--end
                   LET m_tot_fbn07=m_tot_fbn07+m_fbn07
                   LET m_tot_curr =m_tot_curr +m_curr
                   LET m_tot_fbn14=m_tot_fbn14+m_fbn14
                   LET m_tot_fbn15=m_tot_fbn15+m_fbn15
                   LET m_tot_fbn17=m_tot_fbn17+m_fbn17
                   SELECT COUNT(*) INTO g_cnt FROM fbn_file
                    WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                      AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                      AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041='0'
                #CHI-C60010--add--str--
                   LET m_fbn07 = cl_digcut(m_fbn07,l_azi04)
                   LET m_curr = cl_digcut(m_curr,l_azi04)
                   LET m_fbn14 = cl_digcut(m_fbn14,l_azi04)
                   LET m_fbn15 = cl_digcut(m_fbn15,l_azi04)
                   LET m_fbn17 = cl_digcut(m_fbn17,l_azi04)
                #CHI-C60010--add--end
                   IF g_cnt>0 THEN
                      UPDATE fbn_file SET fbn07 = m_fbn07,
                                          fbn08 = m_curr,
                                          fbn09 = g_fbn.fbn06,
                                          fbn16 = m_ratio,
                                          fbn17 = m_fbn17,
                                          fbn11 =m_fad031,
                                          fbn12 =g_fae.fae07
                       WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                         AND fbn03=g_fbn.fbn03 AND fbn04=g_fbn.fbn04
                         AND fbn06=g_fae.fae06 AND fbn05='3' AND fbn041='0'
                      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                         LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                         LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                         LET g_show_msg[g_cnt2].ze01   = ''
                         LET g_show_msg[g_cnt2].ze03   = 'upd fbn_file'
                         LET g_cnt2 = g_cnt2 + 1
                         LET g_success='N'
                         CONTINUE FOREACH
                      END IF
                   ELSE
                      IF cl_null(g_fae.fae06) THEN
                         LET g_fae.fae06=' '
                      END IF
                      INSERT INTO fbn_file(fbn01,fbn02,fbn03,fbn04,fbn041,fbn05,
                                           fbn06,fbn07,fbn08,fbn09,fbn10,fbn11,
                                           fbn12,fbn13,fbn14,fbn15,fbn16,fbn17,fbn20) #MOD-BC0131 add fbn20
                                    VALUES(g_fbn.fbn01,g_fbn.fbn02,g_fbn.fbn03,       
                                           g_fbn.fbn04,'0','3',g_fae.fae06,m_fbn07,   
                                           m_curr,g_fbn.fbn06,l_faj.faj43,g_fbn.fbn11,       
                                           g_fae.fae07,g_fbn.fbn13,m_fbn14,m_fbn15,   
                                           m_ratio,m_fbn17,g_fbn.fbn20) #MOD-BC0131 add fbn20
                      IF STATUS THEN
                         LET g_show_msg[g_cnt2].faj02  = l_faj.faj02
                         LET g_show_msg[g_cnt2].faj022 = l_faj.faj022
                         LET g_show_msg[g_cnt2].ze01   = ''
                         LET g_show_msg[g_cnt2].ze03   = 'ins fbn_file'
                         LET g_cnt2 = g_cnt2 + 1
                         LET g_success='N'
                         CONTINUE FOREACH
                      END IF
                   END IF
                END FOREACH
                IF cl_null(m_max_fae06) THEN LET m_max_fae06=g_fae.fae06 END IF
             END IF
             IF m_fad05 = '2' THEN
                IF m_tot_fbn07!=mm_fbn07 OR m_tot_curr!=m_curr OR
                   m_tot_fbn14!=mm_fbn14 OR m_tot_fbn15!=mm_fbn15 THEN
                   LET m_fae06 = m_max_fae06
                   SELECT fbn07,fbn08 INTO l_fbn07,l_fbn08 from fbn_file
                    WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                      AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
                      AND fbn05='3'
                   LET l_diff = mm_fbn07 - m_tot_fbn07
                   IF l_diff < 0 THEN
                      LET l_diff = l_diff * -1
                      IF l_fbn07 < l_diff THEN
                         LET l_diff = 0
                      ELSE
                         LET l_diff = l_diff * -1
                      END IF
                   END IF
                   IF cl_null(m_tot_curr) THEN
                      LET m_tot_curr=0
                   END IF
                   LET l_diff2 = mm_fbn08 - m_tot_curr
                   IF l_diff2 < 0 THEN
                      LET l_diff2 = l_diff2 * -1
                      IF l_fbn08 < l_diff2 THEN
                         LET l_diff2 = 0
                      ELSE
                         LET l_diff2 = l_diff2 * -1
                      END IF
                   END IF
                   UPDATE fbn_file SET fbn07=fbn07+l_diff,
                                       fbn08=fbn08+l_diff2,
                                       fbn14=fbn14+mm_fbn14-m_tot_fbn14,
                                       fbn15=fbn15+mm_fbn15-m_tot_fbn15,
                                       fbn17=fbn17+mm_fbn17-m_tot_fbn17,
                                       fbn11= m_fad031,
                                       fbn12= g_fae.fae07
                    WHERE fbn01=g_fbn.fbn01 AND fbn02=g_fbn.fbn02
                      AND fbn03=tm.yy AND fbn04=tm.mm AND fbn06=m_fae06
                      AND fbn05='3'
                   IF STATUS OR SQLCA.sqlerrd[3]=0  THEN
                      LET g_success='N'
                      CALL cl_err3("upd","fbn_file",g_fbn.fbn01,g_fbn.fbn02,STATUS,"","upd fbn",1)
                      EXIT FOREACH
                   END IF
                END IF
                LET m_tot_fbn07=0
                LET m_tot_fbn14=0
                LET m_tot_fbn15=0
                LET m_tot_fbn17=0
                LET m_tot_curr =0
                LET m_tot=0
             END IF
          END FOREACH
       END IF
  END FOREACH
END FUNCTION

#FUN-BB0093
