# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: acor210.4gl
# Descriptions...: 加工貿易產品流向情況表
# Date & Author..: 05/02/28 By Carrier
# Modify.........: No.TQC-610082 06/04/19 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-750026 07/07/09 By TSD.liquor 報表改成Crystal Report方式
# Modify.........: No.FUN-8A0029 09/02/23 By destiny 打印報錯
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                          # Print condition RECORD
           wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600) # Where condition
           a       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           b       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
           more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) # Input more condition(Y/N)
           END RECORD,
           g_sql   STRING      #No.FUN-580092 HCN        #No.FUN-680069
DEFINE     g_i     LIKE type_file.num5                  #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   l_table        STRING, #FUN-750026###
         g_str          STRING  #FUN-750026### 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
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
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   #str FUN-750026 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "coc03.coc_file.coc03,",  #手冊編號 
               "cod03.cod_file.cod03,",  #商品編號 
               "cob02.cob_file.cob02,",  #合同料名 
               "cob021.cob_file.cob021,",#合同料名 
               "cod06.cod_file.cod06,",  #單位   
               "qty01.cod_file.cod05,",  #期初庫存   
               "qty02.cod_file.cod05,",  #直接報關出口
               "qty03.cod_file.cod05,",  #結轉報關出口
               "qty04.cod_file.cod05,",  #已結轉未交貨
               "qty05.cod_file.cod05,",  #未結轉已交貨
               "qty06.cod_file.cod05,",  #海關批准內銷
               "qty07.cod_file.cod05,",  #其他內銷  
               "qty08.cod_file.cod05,",  #受托加工返回
               "qty09.cod_file.cod05,",  #其他處理
               "qty10.cod_file.cod05,",  #期末庫存  
               "qty11.cod_file.cod05"    #產量合計  
 
   LET l_table = cl_prt_temptable('acor210',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-750026 add
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor210_tm(0,0)
      ELSE CALL acor210()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   OPEN WINDOW acor210_w WITH FORM "aco/42f/acor210" 
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
   CONSTRUCT BY NAME tm.wc ON coc03,coc10,cod03
 
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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cocuser', 'cocgrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW acor210_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW acor210_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='acor210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('acor210','9031',1)
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
                        #" '",tm.more  CLIPPED,"'",         #No.TQC-610082 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('acor210',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW acor210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL acor210()
   ERROR ""
END WHILE
   CLOSE WINDOW acor210_w
END FUNCTION
 
FUNCTION acor210()
   DEFINE l_name        LIKE type_file.chr20,          #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8            #No.FUN-6A0063
          l_sql         LIKE type_file.chr1000,        #No.FUN-680069 VARCHAR(1200)
          l_za05        LIKE za_file.za05,
          l_qty1,l_qty2 LIKE coo_file.coo16,
          l_cob09       LIKE cob_file.cob09,
          l_coo18       LIKE coo_file.coo18,
          l_coo18a      LIKE coo_file.coo18,
          sr            RECORD 
                        coc03  LIKE coc_file.coc03,  #手冊編號 
                        cod03  LIKE cod_file.cod03,  #商品編號 
                        cob02  LIKE cob_file.cob02,  #合同料名 
                        cob021 LIKE cob_file.cob021,  #合同料名 
                        cod06  LIKE cod_file.cod06,  #單位   
                        qty01  LIKE cod_file.cod05,  #期初庫存   
                        qty02  LIKE cod_file.cod05,  #直接報關出口
                        qty03  LIKE cod_file.cod05,  #結轉報關出口
                        qty04  LIKE cod_file.cod05,  #已結轉未交貨
                        qty05  LIKE cod_file.cod05,  #未結轉已交貨
                        qty06  LIKE cod_file.cod05,  #海關批准內銷
                        qty07  LIKE cod_file.cod05,  #其他內銷  
                        qty08  LIKE cod_file.cod05,  #受托加工返回
                        qty09  LIKE cod_file.cod05,  #其他處理
                        qty10  LIKE cod_file.cod05,  #期末庫存  
                        qty11  LIKE cod_file.cod05   #產量合計  
                        END RECORD
     #str FUN-750026 add
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-750026 add
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     
     LET l_sql = "SELECT unique coc03,cod03,cob02,cob021,cod06,",
                 "       0,0,0,0,0,0,0,0,0,0,0 ",
                 "  FROM coc_file,cod_file,cob_file",
                 " WHERE coc01=cod01 AND cod03=cob01",
                 "   AND ",tm.wc CLIPPED,
                 " ORDER BY coc03,cod03"
     PREPARE acor210_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor210_curs CURSOR FOR acor210_prepare1
 
     #CALL cl_outnam('acor210') RETURNING l_name       #No.FUN-8A0029 by destiny 
 
 
     FOREACH acor210_curs INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach acor210_curs',SQLCA.sqlcode,0)
           CONTINUE FOREACH
        END IF
   ###############################################################
        #sr.qty01
        SELECT cnd09 INTO sr.qty01 FROM cnd_file
         WHERE cnd01=sr.cod03 AND cnd02=sr.coc03
           AND cnd05='1'      AND cndconf='Y'
           AND cndacti='Y'
           AND cnd03*12+cnd04=(SELECT MAX(cnd03*12+cnd04) FROM cnd_file
               WHERE cnd01=sr.cod03 AND cnd02=sr.coc03
                 AND cnd05='1'      AND cndconf='Y'
                 AND cndacti='Y')
        IF cl_null(sr.qty01) THEN LET sr.qty01=0 END IF
   ###############################################################
        #直接報關出口
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(coo16) INTO l_qty1 FROM coo_file    ##直接出口
         WHERE coo18 = sr.coc03  AND coo11 = sr.cod03    
           AND coo20 = 'Y'       AND cooacti = 'Y'
           AND coo07 <> ' '      AND coo07 IS NOT NULL
           AND coo10 = '1'
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        SELECT SUM(coo16) INTO l_qty2 FROM coo_file    ##國外退貨
         WHERE coo18 = sr.coc03  AND coo11 = sr.cod03    
           AND coo20 = 'Y'       AND cooacti = 'Y'
           AND coo07 <> ' '      AND coo07 IS NOT NULL
           AND coo10 = '6'
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty02=l_qty1-l_qty2
   ###############################################################
        #結轉報關出口
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(coo16) INTO l_qty1 FROM coo_file    ##轉廠出口
         WHERE coo18 = sr.coc03  AND coo11 = sr.cod03    
           AND coo20 = 'Y'       AND cooacti = 'Y'
           AND coo07 <> ' '      AND coo07 IS NOT NULL
           AND coo10 = '2'
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        SELECT SUM(coo16) INTO l_qty2 FROM coo_file    ##轉廠退貨
         WHERE coo18 = sr.coc03  AND coo11 = sr.cod03    
           AND coo20 = 'Y'       AND cooacti = 'Y'
           AND coo07 <> ' '      AND coo07 IS NOT NULL
           AND coo10 = '7'
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty03=l_qty1-l_qty2
 
   ###############################################################
        #sr.qty04 已結轉未交貨
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(crf05) INTO l_qty1 FROM crf_file,cre_file 
         WHERE cre10 = sr.coc03  AND crf03 = sr.cod03    
           AND crf01 = cre01     AND cre03 = '1'
           AND cre031= '1'
           AND (cre04='1' OR cre04='2' OR cre04='4')
           AND creacti = 'Y'    
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        SELECT SUM(crf05) INTO l_qty2 FROM crf_file,cre_file 
         WHERE cre10 = sr.coc03  AND crf03 = sr.cod03    
           AND crf01 = cre01     AND cre03 = '1'
           AND cre031= '2'
           AND (cre04='2' OR cre04='3' OR cre04='4')
           AND creacti = 'Y'    
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty04=l_qty1-l_qty2
   ###############################################################
        #sr.qty05 未結轉已交貨
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(crd12) INTO l_qty1 FROM crd_file,coo_file 
         WHERE crd06 = sr.cod03  AND coo01 = crd01       
           AND crd02 = coo02     AND crd00 = '1'
           AND coo18=sr.coc03
           AND (crd08='2' OR crd08='0' OR crd08='1')
        SELECT SUM(crd12) INTO l_qty2 FROM crd_file,coo_file 
         WHERE crd06 = sr.cod03  AND coo01 = crd01       
           AND crd02 = coo02     AND crd00 = '1'
           AND coo18=sr.coc03
           AND (crd08='5' OR crd08='6' OR crd08='7')
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty05=l_qty1-l_qty2
   ###############################################################
 
        #海關批准內銷
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(coo16) INTO l_qty1 FROM coo_file    ##內銷出口
         WHERE coo18 = sr.coc03  AND coo11 = sr.cod03    
           AND coo20 = 'Y'       AND cooacti = 'Y'
           AND coo07 <> ' '      AND coo07 IS NOT NULL
           AND coo10 = '0'
        IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        SELECT SUM(coo16) INTO l_qty2 FROM coo_file    ##內銷退貨
         WHERE coo18 = sr.coc03  AND coo11 = sr.cod03    
           AND coo20 = 'Y'       AND cooacti = 'Y'
           AND coo07 <> ' '      AND coo07 IS NOT NULL
           AND coo10 = '5'
        IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty06=l_qty1-l_qty2
   ###############################################################
        #其他內銷
        IF cl_null(sr.qty07) THEN LET sr.qty07=0 END IF
        #受托加工返回
        IF cl_null(sr.qty08) THEN LET sr.qty08=0 END IF
        #其他處理
        IF cl_null(sr.qty09) THEN LET sr.qty09=0 END IF
        #期末庫存
        IF cl_null(sr.qty10) THEN LET sr.qty10=0 END IF
        #產量合計
        LET sr.qty11=sr.qty02-sr.qty01+sr.qty03-sr.qty04+sr.qty05
                    +sr.qty06+sr.qty07+sr.qty08+sr.qty09+sr.qty10
        IF cl_null(sr.qty11) THEN LET sr.qty11 = 0 END IF
        IF tm.a='Y' THEN
           SELECT cob09 INTO l_cob09 FROM cob_file WHERE cob01=sr.cod03
           IF NOT cl_null(l_cob09) THEN LET sr.cod03=l_cob09 END IF
           LET sr.cob02=NULL
        END IF
        IF tm.b='N' THEN
           LET sr.coc03=NULL
        END IF
        #---------TSD.liquor add end----------------
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
       EXECUTE insert_prep USING sr.*
       #------------------------------ CR (3) ------------------------------#
       #end FUN-750026 add
     END FOREACH
 
     #str FUN-750026 add
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'coc03,coc10,cod03') RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.a,";",tm.b 
     CALL cl_prt_cs3('acor210','acor210',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
 
END FUNCTION
