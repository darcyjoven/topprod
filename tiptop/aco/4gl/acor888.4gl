# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: acor888.4gl
# Descriptions...: 進出口材料平衡表 (FOR 華南)
# Date & Author..: 05/01/31 By Carrier  
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-750026 07/07/09 By TSD.pinky 報表改成Crystal Report方
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AB0171 10/11/28 By vealxu acor888運行無資料,原因insert_prep的個數內容和sr.*不符
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm      RECORD                  # Print condition RECORD
                  wc      LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(300) # Where condition
                  y       LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1) #Input more condition(Y/N)
                  more    LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1) #Input more condition(Y/N)
                  END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680069 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   l_table        STRING, #FUN-750026###
        g_str          STRING, #FUN-750026###
        g_sql          STRING  #FUN-750026###
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
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
   LET g_sql=" cok00.cok_file.cok00, ",                                     
             " cok01.cok_file.cok01," ,                       
             " cok02.cok_file.cok02," ,                       
             " cok03.cok_file.cok03," ,                       
             " cok04.cok_file.cok04," ,                       
             " cok05.cok_file.cok05," ,                       
             " cok06.cok_file.cok06," ,                       
             " cok07.cok_file.cok07," ,                       
             " cok08.cok_file.cok08," ,                      
             " cok09.cok_file.cok09," ,                     
             " cok10.cok_file.cok10," ,                    
             " cok11.cok_file.cok11," ,                       
             " cok12.cok_file.cok12," ,                       
             " cok13.cok_file.cok13," ,                       
             " cok14.cok_file.cok14," ,                       
             " cok15.cok_file.cok15," ,                       
             " cok16.cok_file.cok16," ,                       
             " cok17.cok_file.cok17," ,                       
             " cok18.cok_file.cok18," ,                       
             " cok19.cok_file.cok19," ,                      
             " cok20.cok_file.cok20," ,                      
             " cok21.cok_file.cok21," ,                       
             "qty04.cod_file.cod05," ,
             "qty05.cod_file.cod05,",
             "qty08.cod_file.cod05,",
             "qty09.cod_file.cod05,",
             "cob02.cob_file.cob02,",
             "cob021.cob_file.cob021"
  LET l_table = cl_prt_temptable('acor888',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
  LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
  #------------------------------ CR (1) ------------------------------#
  #end FUN-750026 add
 
 
 
 
 
 
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more  = 'N'
   LET tm.y     = 'N'
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.y     = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET g_trace  = 'N'                       # default trace off
 
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL acor888_tm(0,0)
      ELSE CALL acor888()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION acor888_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680069 SMALLINT
         l_cmd        LIKE type_file.chr1000        #No.FUN-680069 VARCHAR(400)
 
   LET p_row = 5 LET p_col = 15
 
   OPEN WINDOW acor888_w AT p_row,p_col WITH FORM "aco/42f/acor888"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more= 'N'
   LET tm.y   = 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON cok00,cok01,cok02 HELP 1
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
        LET INT_FLAG = 0 CLOSE WINDOW acor888_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
     END IF
     IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
     INPUT BY NAME tm.y,tm.more WITHOUT DEFAULTS HELP 1
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD y
           IF tm.y NOT MATCHES '[YN]' THEN
              NEXT FIELD y
           END IF
        AFTER FIELD more
           IF tm.more NOT MATCHES '[YN]' THEN
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
  
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
  
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
        LET INT_FLAG = 0 CLOSE WINDOW acor888_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
           
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='acor888'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('acor888','9031',1)
        ELSE
           LET tm.wc=cl_wcsub(tm.wc)
           LET l_cmd = l_cmd CLIPPED,
                           " '",g_pdate  CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob  CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc    CLIPPED,"'",
                           " '",tm.y     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
  
           IF g_trace = 'Y' THEN ERROR l_cmd END IF
           CALL cl_cmdat('acor888',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW acor888_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL acor888()
     ERROR ""
   END WHILE
   CLOSE WINDOW acor888_w
END FUNCTION
 
FUNCTION acor888()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680069 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0063
          l_sql     LIKE type_file.chr1000,      #No.FUN-680069 VARCHAR(600)
          l_za05    LIKE za_file.za05,
          l_i       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_n       LIKE type_file.num5,         #No.FUN-680069 SMALLINT
          l_con01           LIKE con_file.con01,
          l_con05           LIKE con_file.con05,
          l_con06           LIKE con_file.con06,
          l_crd06           LIKE crd_file.crd06,
          l_crf03           LIKE crf_file.crf03,
          l_crf05           LIKE crf_file.crf05,
          l_qty1,l_qty2     LIKE coo_file.coo16,
          l_coc10           LIKE coc_file.coc10,
          l_cost            LIKE con_file.con06,  #單耗
          l_cob09           LIKE cob_file.cob09, 
          l_crd12           LIKE crd_file.crd12,
       sr        RECORD
                    cok RECORD LIKE cok_file.*,
                    qty04 LIKE cod_file.cod05,   #收貨未結轉
                    qty05 LIKE cod_file.cod05,   #結轉未收貨
                    qty08 LIKE cod_file.cod05,   #結轉未送貨
                    qty09 LIKE cod_file.cod05,   #送貨未結轉
                    cob02 LIKE cob_file.cob02,
                    cob021 LIKE cob_file.cob021
                    END RECORD
 
       #str FUN-750026 add
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
    #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-750026 add
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql="SELECT cok_file.*,0,0,0,0,cob02,cob021 FROM cok_file,cob_file",
               " WHERE cob01 = cok01"
     IF NOT cl_null(tm.wc) THEN
        LET l_sql=l_sql CLIPPED," AND ",tm.wc CLIPPED
     END IF
     IF g_trace='Y' THEN CALL cl_wcshow(l_sql) END IF
     PREPARE acor888_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
        EXIT PROGRAM 
     END IF
     DECLARE acor888_curs1 CURSOR FOR acor888_prepare1
 
#     CALL cl_outnam('acor888') RETURNING l_name #FUN-750026 mark
 
 
#     START REPORT acor888_rep TO l_name  #FUN-750026mark
     LET g_pageno = 0
     FOREACH acor888_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
   ###############################################################
        #sr.qty04 收貨未結轉
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(crd12) INTO l_qty1 FROM crd_file,cop_file 
         WHERE crd06 = sr.cok.cok01  AND cop01 = crd01       
           AND crd02 = cop02     AND crd00 = '2'
           AND cop18=sr.cok.cok00
           AND (crd08='1' OR crd08='2' OR crd08='3')
        SELECT SUM(crd12) INTO l_qty2 FROM crd_file,cop_file 
         WHERE crd06 = sr.cok.cok01  AND cop01 = crd01       
           AND crd02 = cop02     AND crd00 = '2'
           AND cop18=sr.cok.cok00
           AND (crd08='4' OR crd08='5' OR crd08='6')
         IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
         IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
         LET sr.qty04=l_qty1-l_qty2
   ###############################################################
        #sr.qty05 結轉未收貨
        LET l_qty1 = 0   
        LET l_qty2 = 0 
        SELECT SUM(crf05) INTO l_qty1 FROM crf_file,cre_file 
         WHERE cre10 = sr.cok.cok00  AND crf03 = sr.cok.cok01
           AND crf01 = cre01     AND cre03 = '2'
           AND cre031= '1'       AND creacti = 'Y' 
           AND (cre04='1' OR cre04='2' OR cre04='6')
            IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
        SELECT SUM(crf05) INTO l_qty2 FROM crf_file,cre_file 
         WHERE cre10 = sr.cok.cok00  AND crf03 = sr.cok.cok01
           AND crf01 = cre01     AND cre03 = '2'
           AND cre031= '2'       AND creacti = 'Y'
           AND (cre04='2' OR cre04='3' OR cre04='6')
            IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
        LET sr.qty05=l_qty1-l_qty2
   ###############################################################
       #sr.qty08 結轉未送貨
       LET l_qty1 = 0   
       LET l_qty2 = 0 
       SELECT coc10 INTO l_coc10 FROM coc_file WHERE coc03=sr.cok.cok00 
       DECLARE r888_cl1 CURSOR FOR    #選出用過當前材料的成品數量及單耗 
        SELECT con01,con05,con06,crf05 FROM con_file,crf_file,cre_file
         WHERE cre03='1' AND cre01=crf01         
           AND con03=sr.cok.cok01 AND con013=' '
           AND cre10=sr.cok.cok00 AND con08=l_coc10 
           AND con01=crf03        AND cre031='1'
           AND (cre04='1' OR cre04='2' OR cre04='4')
       FOREACH r888_cl1 INTO l_con01,l_con05,l_con06,l_crf05
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            LET l_cost = l_con05 /(1-l_con06/100) # 確定材料的單耗
            LET l_qty1 = l_qty1+l_crf05*l_cost
       END FOREACH
       LET l_con01=''
       LET l_con05=0
       LET l_con06=0
       LET l_crf05=0
       DECLARE r888_cl2 CURSOR FOR  
        SELECT con01,con05,con06,crf05 FROM con_file,crf_file,cre_file
         WHERE cre03='1' AND cre01=crf01         
           AND con03=sr.cok.cok01 AND con013=' '
           AND cre10=sr.cok.cok00 AND con08=l_coc10 
           AND con01=crf03        AND cre031='2'
           AND (cre04='2' OR cre04='3' OR cre04='4')
       FOREACH r888_cl2 INTO l_con01,l_con05,l_con06,l_crf05
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            LET l_cost = l_con05 /(1-l_con06/100)
            LET l_qty2 = l_qty2+l_crf05*l_cost
       END FOREACH
       LET l_con01=''
       LET l_con05=0
       LET l_con06=0
       LET l_crf05=0
       IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
       IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
       LET sr.qty08=l_qty1-l_qty2
   ###############################################################
        #sr.qty09 送貨未結轉
        LET l_qty1 = 0   
        LET l_qty2 = 0 
       DECLARE r888_cs1 CURSOR FOR    #選出用過當前材料的成品數量及單耗 
        SELECT con01,con05,con06,crd12 FROM con_file,crd_file,cop_file
         WHERE con03=sr.cok.cok01 AND con013=' '
           AND con08=l_coc10 AND con01=crd06
           AND crd00='1'
           AND (crd08='1' OR crd08='2' OR crd08='0')
           AND cop18=sr.cok.cok00
           AND crd02 = cop02     AND crd01 = cop01
       FOREACH r888_cs1 INTO l_con01,l_con05,l_con06,l_crd12
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            LET l_cost = l_con05 /(1-l_con06/100) # 確定材料的單耗
            LET l_qty1 = l_qty1+l_crd12*l_cost
       END FOREACH
       LET l_con01=''
       LET l_con05=0
       LET l_con06=0
       LET l_crd12=0
       DECLARE r888_cs2 CURSOR FOR    #選出用過當前材料的成品數量及單耗 
        SELECT con01,con05,con06,crd12 FROM con_file,crd_file,cop_file
         WHERE con03=sr.cok.cok01 AND con013=' '
           AND con08=l_coc10 AND con01=crd06
           AND crd00='1'
           AND (crd08='5' OR crd08='6' OR crd08='7')
           AND cop18=sr.cok.cok00
           AND crd02 = cop02     AND crd01 = cop01
       FOREACH r888_cs2 INTO l_con01,l_con05,l_con06,l_crd12
            IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
            LET l_cost = l_con05 /(1-l_con06/100) # 確定材料的單耗
            LET l_qty2 = l_qty2+l_crd12*l_cost
       END FOREACH
       LET l_con01=''
       LET l_con05=0
       LET l_con06=0
       LET l_crd12=0
       IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
       IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
       LET sr.qty09=l_qty1-l_qty2
   ###############################################################
        IF tm.y='Y' THEN
           SELECT cob09 INTO l_cob09 FROM cob_file WHERE cob01=sr.cok.cok01
           IF NOT cl_null(l_cob09) THEN LET sr.cok.cok01=l_cob09 END IF
        END IF
        #FUN-750026 add end
       IF cl_null(sr.cok.cok03) THEN LET sr.cok.cok03 = 0 END IF
       IF cl_null(sr.cok.cok15) THEN LET sr.cok.cok15 = 0 END IF
       IF cl_null(sr.cok.cok17) THEN LET sr.cok.cok17 = 0 END IF
       LET sr.cok.cok03 = sr.cok.cok03+sr.cok.cok15+sr.cok.cok17
       
       IF cl_null(sr.cok.cok07) THEN LET sr.cok.cok07 = 0 END IF
       IF cl_null(sr.cok.cok16) THEN LET sr.cok.cok16 = 0 END IF
       IF cl_null(sr.cok.cok20) THEN LET sr.cok.cok20 = 0 END IF
       LET sr.cok.cok07 = sr.cok.cok07+sr.cok.cok16+sr.cok.cok20
              
      # LET l_a=sr.cok.cok03+sr.qty04-sr.qty05-sr.cok.cok07+sr.qty08-sr.qty09
      # IF cl_null(l_a) THEN LET l_a=0 END IF
      # LET l_b=sr.cok.cok10+sr.cok.cok11+sr.cok.cok12+sr.cok.cok13+sr.cok.cok14
      # IF cl_null(l_b) THEN LET l_b=0 END IF
      # LET l_c=l_b-l_a
      # IF cl_null(l_c) THEN LET l_c=0 END IF
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      #EXECUTE insert_prep USING sr.*          #TQC-AB0171
       EXECUTE insert_prep USING sr.cok.cok00,sr.cok.cok01,sr.cok.cok02,sr.cok.cok03,sr.cok.cok04,
                                 sr.cok.cok05,sr.cok.cok06,sr.cok.cok07,sr.cok.cok08,sr.cok.cok09,
                                 sr.cok.cok10,sr.cok.cok11,sr.cok.cok12,sr.cok.cok13,sr.cok.cok14,sr.cok.cok15,
                                 sr.cok.cok16,sr.cok.cok17,sr.cok.cok18,sr.cok.cok19,sr.cok.cok20,sr.cok.cok21,
                                 sr.qty04,sr.qty05,sr.qty08,sr.qty09,sr.cob02,sr.cob021                           #TQC-AB0171
     END FOREACH
 
   #  FINISH REPORT acor888_rep
 #str FUN-750026 add
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'cok00,cok01,cok02') RETURNING tm.wc
       LET g_str = tm.wc
    END IF
    LET g_str = g_str,";",tm.y
    CALL cl_prt_cs3('acor888','acor888',l_sql,g_str)
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #------------------------------ CR (4) ------------------------------#
END FUNCTION
#函式說明:算出一字串,位於數個連續表頭的中央位置                                 
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度                    
#傳回值 - 字串起始位置                                                          
FUNCTION r888_getStartPos(l_sta,l_end,l_str)                                    
DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5                                    #No.FUN-680069 SMALLINT
DEFINE l_str        STRING       #No.FUN-680069                                                            
   LET l_str=l_str.trim()                                                       
   LET l_length=l_str.getLength()                                               
   LET l_w_tot=0                                                                
   FOR l_i=l_sta to l_end                                                       
      LET l_w_tot=l_w_tot+g_w[l_i]                                              
   END FOR                                                                      
   LET l_pos=(l_w_tot/2)-(l_length/2)                                           
   IF l_pos<0 THEN LET l_pos=0 END IF                                           
   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)                                     
   RETURN l_pos                                                                 
END FUNCTION 
