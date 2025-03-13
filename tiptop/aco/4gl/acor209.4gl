# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: acor209.4gl
# Descriptions...: 加工貿易原材料來源與使用情況表
# Date & Author..: 05/02/01 By Carrier
# Modify.........: No.TQC-610082 06/04/07 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-750026 07/07/09 By TSD.Ken報表改寫由Crystal Report產出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B80045 11/08/04 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
           a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           b       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
           END RECORD,
           g_sql   STRING     #No.FUN-580092 HCN        #No.FUN-680069
DEFINE     g_i     LIKE type_file.num5                  #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE l_table      STRING                       ### FUN-750026 add ###
DEFINE g_str       STRING                       ### FUN-750026 add ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   #str FUN-750026 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-750026 *** ##
   LET g_sql = "cok00.cok_file.cok00,",  
               "cok01.cok_file.cok01,",  
               "cob02.cob_file.cob02,",  
               "cob021.cob_file.cob021,", 
               "cok02.cok_file.cok02,",  
               "qty01.cok_file.cok03,",  
               "qty02.cok_file.cok03,",  
               "qty03.cok_file.cok03,",  
               "qty04.cok_file.cok03,",  
               "qty05.cok_file.cok03,",  
               "qty06.cok_file.cok03,",  
               "qty07.cok_file.cok03,",  
               "qty08.cok_file.cok03,",  
               "qty09.cok_file.cok03,",  
               "qty10.cok_file.cok03,",  
               "qty11.cok_file.cok03,",  
               "qty12.cok_file.cok03,",  
               "qty13.cok_file.cok03,",  
               "qty14.cok_file.cok03,",  
               "qty15.cok_file.cok03,",  
               "qty16.cok_file.cok03,",  
               "qty17.cok_file.cok03,",  
               "qty18.cok_file.cok03,",  
               "qty19.cok_file.cok03,",  
               "qty20.cok_file.cok03,",  
               "qty21.cok_file.cok03,",  
               "qty22.cok_file.cok03,",  
               "qty23.cok_file.cok03,",  
               "qty24.cok_file.cok03,",  
               "qty25.cok_file.cok03,",  
               "qty26.cok_file.cok03"   
 
   LET l_table = cl_prt_temptable('acor209',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,",
              "        ?,?,?,?,?,",
              "        ?,?,?,?,?,",
              "        ?,?,?,?,?,",
              "        ?,?,?,?,?,",
              "        ?,?,?,?,?,",
              "        ?)"
 
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
 
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   LET tm.a    = ARG_VAL(8)
   LET tm.b    = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
  
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor209_tm(0,0)
      ELSE CALL acor209()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor209_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW acor209_w AT p_row,p_col WITH FORM "aco/42f/acor209" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.a    = 'N'
   LET tm.b    = 'Y'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON cok00,coc10,cok01,cok02
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT CONSTRUCT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
  
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor209_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' OR tm.more IS NULL THEN
            NEXT FIELD more
         END IF 
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor209_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor209'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor209','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                        #" '",tm.more  CLIPPED,"'",           #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor209',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor209_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor209()
   ERROR ""
END WHILE
   CLOSE WINDOW acor209_w
END FUNCTION
 
FUNCTION acor209()
   DEFINE l_name        LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0063
          l_sql         LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(1200)
          l_za05        LIKE za_file.za05,
          l_qty1,l_qty2 LIKE cok_file.cok03,
          l_cob09       LIKE cob_file.cob09,
          sr            RECORD 
                        cok00  LIKE cok_file.cok00,  #手冊編號 
                        cok01  LIKE cok_file.cok01,  #商品編號 
                        cob02  LIKE cob_file.cob02,  #合同料名 
                        cob021 LIKE cob_file.cob021,  #合同料名 
                        cok02  LIKE cok_file.cok02,  #單位   
                        qty01  LIKE cok_file.cok03,  #期初庫存   
                        qty02  LIKE cok_file.cok03,  #直接報關進口
                        qty03  LIKE cok_file.cok03,  #結轉報關進口
                        qty04  LIKE cok_file.cok03,  #已結轉未收貨
                        qty05  LIKE cok_file.cok03,  #未結轉已收貨
                        qty06  LIKE cok_file.cok03,  #海關征稅進口
                        qty07  LIKE cok_file.cok03,  #國內采購  
                        qty08  LIKE cok_file.cok03,  #受托加工  
                        qty09  LIKE cok_file.cok03,  #外委加工返回原料
                        qty10  LIKE cok_file.cok03,  #其他來源  
                        qty11  LIKE cok_file.cok03,  #來源合計  
                        qty12  LIKE cok_file.cok03,  #直接出口成品耗用
                        qty13  LIKE cok_file.cok03,  #實際結轉成品耗用
                        qty14  LIKE cok_file.cok03,  #海關批准內銷耗用
                        qty15  LIKE cok_file.cok03,  #退運出口
                        qty16  LIKE cok_file.cok03,  #其他內銷耗用
                        qty17  LIKE cok_file.cok03,  #受托加工返回耗用
                        qty18  LIKE cok_file.cok03,  #外發加工  
                        qty19  LIKE cok_file.cok03,  #外發返回成品
                        qty20  LIKE cok_file.cok03,  #損耗    
                        qty21  LIKE cok_file.cok03,  #其他使用    
                        qty22  LIKE cok_file.cok03,  #使用合計  
                        qty23  LIKE cok_file.cok03,  #期末實際庫存
                        qty24  LIKE cok_file.cok03,  #庫存原材料 
                        qty25  LIKE cok_file.cok03,  #庫存在產品耗用
                        qty26  LIKE cok_file.cok03   #庫存量產成品耗用
                        END RECORD
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-750026 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-750026  add
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-750026 add ###
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     
     LET l_sql = "SELECT cok00,cok01,cob02,cob021,cok02,0,cok03,cok15,0,",
                 "       0,0,0,0,0,0,0,cok07,cok16,cok20,0,0,0,0,",
                 "       0,cok06,0,0,0,cok12,cok11+cok13,cok14",
                 "  FROM cok_file,coc_file,cob_file",
                 " WHERE cok00=coc03 AND cok01=cob01",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY cok00,cok01"
     PREPARE acor209_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor209_curs CURSOR FOR acor209_prepare1
 
     #CALL cl_outnam('acor209') RETURNING l_name
     #START REPORT acor209_rep TO l_name
 
     FOREACH acor209_curs INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach acor209_curs',SQLCA.sqlcode,0)
           CONTINUE FOREACH
        END IF
        #期初###有了開帳作業之后補
        #sr.qty01
        ########
        #直接報關進口
        IF cl_null(sr.qty02) THEN LET sr.qty02=0 END IF
        #結轉報關進口
        IF cl_null(sr.qty03) THEN LET sr.qty03=0 END IF
   ###############################################################
        #sr.qty04 已結轉未交貨
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(crf05) INTO l_qty1 FROM crf_file,cre_file 
         WHERE cre10 = sr.cok00  AND crf03 = sr.cok01    
           AND crf01 = cre01     AND cre03 = '2'
           AND cre031= '1'
           AND (cre04='1' OR cre04='2' OR cre04='6')
           AND creacti = 'Y'    
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        SELECT SUM(crf05) INTO l_qty2 FROM crf_file,cre_file 
         WHERE cre10 = sr.cok00  AND crf03 = sr.cok01    
           AND crf01 = cre01     AND cre03 = '2'
           AND cre031= '2'
           AND (cre04='2' OR cre04='3' OR cre04='6')
           AND creacti = 'Y'    
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty04=l_qty1-l_qty2
   ###############################################################
        #sr.qty05 未結轉已收貨
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(crd12) INTO l_qty1 FROM crd_file,cop_file 
         WHERE crd06 = sr.cok01  AND cop01 = crd01       
           AND crd02 = cop02     AND crd00 = '2'
           AND cop18=sr.cok00
           AND (crd08='1' OR crd08='2' OR crd08='3')
        SELECT SUM(crd12) INTO l_qty2 FROM crd_file,cop_file 
         WHERE crd06 = sr.cok01  AND cop01 = crd01       
           AND crd02 = cop02     AND crd00 = '2'
           AND cop18=sr.cok00
           AND (crd08='4' OR crd08='5' OR crd08='6')
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty05 = l_qty1 - l_qty2
   ###############################################################
        #海關征稅進口
        IF cl_null(sr.qty06) THEN LET sr.qty06=0 END IF
        #國內采購
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(cop16) INTO l_qty1 FROM cop_file
         WHERE cop18 = sr.cok00 AND cop11 = sr.cok01
           AND cop20 = 'Y'  AND copacti = 'Y'
           AND cop07 <> ' ' AND cop07 IS NOT NULL
           AND cop10 = '3'
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        SELECT SUM(cop16) INTO l_qty2 FROM cop_file
         WHERE cop18 = sr.cok00 AND cop11 = sr.cok01
           AND cop20 = 'Y'  AND copacti = 'Y'
           AND cop07 <> ' ' AND cop07 IS NOT NULL
           AND cop10 = '6'
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty07 = l_qty1 - l_qty2
        #受托加工
        #外委加工返回原料
        #其他來源
        #來源合計
        LET sr.qty11=sr.qty01+sr.qty02+sr.qty03-sr.qty04+sr.qty05
                    +sr.qty06+sr.qty07+sr.qty08+sr.qty09+sr.qty10
        IF cl_null(sr.qty11) THEN LET sr.qty11 = 0 END IF
        #直接出口成品耗用
        IF cl_null(sr.qty12) THEN LET sr.qty12=0 END IF
        #實際結轉成品耗用
        IF cl_null(sr.qty13) THEN LET sr.qty13=0 END IF
        #海關批准內銷耗用  
        IF cl_null(sr.qty14) THEN LET sr.qty14=0 END IF
        #退運出口
        #其他內銷耗用
        #受托加工返回耗用
        #外發加工
        #外發返回成品
        #損耗
        IF cl_null(sr.qty20) THEN LET sr.qty20=0 END IF
        #其他使用 
        #使用合計
        LET sr.qty22=sr.qty12+sr.qty13+sr.qty14+sr.qty15+sr.qty16
                    +sr.qty17+sr.qty18-sr.qty19+sr.qty20+sr.qty21
        #庫存原材料
        IF cl_null(sr.qty24) THEN LET sr.qty24=0 END IF
        #庫存在產品耗用
        IF cl_null(sr.qty25) THEN LET sr.qty25=0 END IF
        #庫存量產成品耗用
        IF cl_null(sr.qty26) THEN LET sr.qty26=0 END IF
        #期末實際庫存
        LET sr.qty23=sr.qty24+sr.qty25+sr.qty26
        IF tm.a='Y' THEN
           SELECT cob09 INTO l_cob09 FROM cob_file WHERE cob01=sr.cok01
           IF NOT cl_null(l_cob09) THEN LET sr.cok01=l_cob09 END IF
           LET sr.cob02=NULL
        END IF
        IF tm.b='N' THEN
           LET sr.cok00=NULL
        END IF
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-750026 *** ##
        IF cl_null(sr.cok00) THEN LET sr.cok00 = ' ' END IF
        EXECUTE insert_prep USING
        sr.cok00, sr.cok01, sr.cob02, sr.cob021, sr.cok02,
        sr.qty01, sr.qty02, sr.qty03, sr.qty04,  sr.qty05,
        sr.qty06, sr.qty07, sr.qty08, sr.qty09,  sr.qty10,
        sr.qty11, sr.qty12, sr.qty13, sr.qty14,  sr.qty15,
        sr.qty16, sr.qty17, sr.qty18, sr.qty19,  sr.qty20,
        sr.qty21, sr.qty22, sr.qty23, sr.qty24,  sr.qty25,
        sr.qty26
        IF STATUS THEN CALL cl_err('',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80045   ADD   
           EXIT PROGRAM 
        END IF
      #------------------------------ CR (3) ------------------------------#
     END FOREACH
 
     #FINISH REPORT acor209_rep
 
     #str FUN-750026 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-750026 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'cok00,coc10,cok01,cok02')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.b
     CALL cl_prt_cs3('acor209','acor209',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
 
    # CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
