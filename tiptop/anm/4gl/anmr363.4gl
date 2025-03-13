# Prog. Version..: '5.30.06-13.03.28(00009)'     #
#
# Pattern name...: anmr363.4gl
# Descriptions...: 外幣存款月底重評價表
# Date & Author..: 96/05/04 by Roger
# Modify.........: No.9040 04/01/09 Kammy sql 應抓取azj07 而非 azj06
# Modify.........: No.FUN-4C0098 05/01/06 By pengu 報表轉XML
# Modify.........: No.FUN-550119 05/06/01 By Smapmin 新增INPUT "匯率選項"
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-790059 07/09/13 By Smapmin 進入報表段前先做幣別位數取位
# Modify.........: No.FUN-7A0036 07/11/09 By Lutingting 修改為使用Crystal Report
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
#                                                       若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.MOD-940049 09/04/03 By Sarah 匯兌收益=本幣存款金額amt2-重估本幣金額new_amt,amt2與new_amt應先取位後再計算匯兌收益
# Modify.........: No.MOD-960038 09/06/04 By baofei 修改 IF sr.amt1 IS NULL OR sr.amt1 = 0 THEN CONTINUE FOREACH END IF判斷
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0018 09/11/04 By xiaofeizhu 標準SQL修改
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_nme07應給予預設值'',抓不到值不應為'1'
# Modify.........: No:CHI-C30048 11/05/04 By belle  建議畫面增加列印金額為零選項，辨識金額為零者是否印出
# Modify.........: No:MOD-C60043 12/06/08 By Elise sr.amt1幣別取位調整為t_azi04 
# Modify.........: No:MOD-D10075 13/01/09 By Polly 抓取匯率時，改用期別抓取對應截止日

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE yymm  LIKE aab_file.aab02             #No.FUN-680107
   DEFINE tm  RECORD                            # Print condition RECORD
             #wc      LIKE type_file.chr1000,   #No.FUN-680107 VARCHAR(600) # Where condition #MOD-D10075 mark
              wc      STRING,                   #MOD-D10075 add
              detail  LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
              yy      LIKE type_file.num5,      #No.FUN-680107 SMALLINT
              mm      LIKE type_file.num5,      #No.FUN-680107 SMALLINT
              rate_op LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1) #FUN-550119
              more    LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1) # Input more condition(Y/N)
              c       LIKE type_file.chr1       #CHI-C30048
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_table         STRING                 #No.FUN-7A0036
DEFINE   g_str           STRING                 #No.FUN-7A0036
DEFINE   g_sql           STRING                 #No.FUN-7A0036
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
#No.FUN-7A0036--start--
   LET g_sql = "nma10.nma_file.nma10,",
               "new_ex.azj_file.azj07,",
               "nma01.nma_file.nma01,",
               "nma02.nma_file.nma02,",
               "amt1.nmp_file.nmp16,",
               "old_ex.azj_file.azj07,",
               "amt2.nmp_file.nmp19,",
               "new_amt.nmp_file.nmp19,",
               "ex_prof.nmp_file.nmp19,",
               "ex_loss.nmp_file.nmp19,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "l_azi07.azi_file.azi07,",
               "t_azi07.azi_file.azi07"
   LET l_table = cl_prt_temptable('anmr363',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-7A0036--end-- 
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.yy = ARG_VAL(8)
   LET tm.mm = ARG_VAL(9)
   LET tm.rate_op = ARG_VAL(10)
   LET tm.detail = ARG_VAL(11)
   #-----END TQC-610058-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   LET g_rpt_name = ARG_VAL(15)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL anmr363_tm(0,0)             # Input print condition
   ELSE 
      CALL anmr363()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr363_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW anmr363_w AT p_row,p_col
        WITH FORM "anm/42f/anmr363"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET tm.c = 'N'                     #CHI-C30048
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.detail='Y'
   LET tm.yy=YEAR(TODAY)
   LET tm.mm=MONTH(TODAY)
   LET tm.rate_op = 'B'   #FUN-550119
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nma10,nma09,nma01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
         LET g_action_choice = "locale"
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr363_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   #INPUT BY NAME tm.yy,tm.mm,tm.detail,tm.more WITHOUT DEFAULTS   #FUN-550119
   INPUT BY NAME tm.yy,tm.mm,tm.rate_op,tm.detail,tm.c,tm.more WITHOUT DEFAULTS    #CHI-C30048 add #FUN-550119
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD mm
         LET yymm=tm.yy USING '&&&&',tm.mm USING '&&'
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
    AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr363_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr363'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr363','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.yy CLIPPED,"'" ,
                         " '",tm.mm CLIPPED,"'"  ,   #TQC-610058
                         " '",tm.rate_op CLIPPED,"'"  ,   #TQC-610058
                         " '",tm.detail CLIPPED,"'"  ,   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr363',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr363_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr363()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr363_w
END FUNCTION
 
FUNCTION anmr363()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#        #l_time    LIKE type_file.chr8        #No.FUN-6A0082
         #l_sql     LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(1200) #MOD-D10075 mark
          l_sql     STRING,                      #MOD-D10075 add
          l_za05    LIKE type_file.chr1000,      #No.FUN-680107 VARCHAR(40)
          amt1,amt2 LIKE type_file.num20_6,      #No.FUN-680107 DEC(20,6)
          l_date    LIKE type_file.dat,          #No.FUN-680107 VARCHAR(10)  #FUN-550119
           sr        RECORD
			nma09	  LIKE nma_file.nma09,
			nma01	  LIKE nma_file.nma01,
			nma02	  LIKE nma_file.nma02,
			nma10	  LIKE nma_file.nma10,
			old_ex    LIKE azj_file.azj07,
			new_ex    LIKE azj_file.azj07,
			amt1      LIKE nmp_file.nmp16,
			amt2      LIKE nmp_file.nmp19,
			new_amt   LIKE nmp_file.nmp19,
			ex_prof   LIKE nmp_file.nmp19,
			ex_loss   LIKE nmp_file.nmp19
                    END RECORD
   DEFINE l_azi03   LIKE azi_file.azi03          #No.FUN-7A0036                                                             
   DEFINE l_azi04   LIKE azi_file.azi04          #No.FUN-7A0036                                                             
   DEFINE l_azi05   LIKE azi_file.azi05          #No.FUN-7A0036                                                             
   DEFINE l_azi07   LIKE azi_file.azi07          #No.FUN-7A0036
   DEFINE l_oox01   STRING                           #CHI-830003 add
   DEFINE l_oox02   STRING                           #CHI-830003 add
   DEFINE l_sql_1   STRING                           #CHI-830003 add
   DEFINE l_sql_2   STRING                           #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5              #CHI-830003 add
   DEFINE l_nme07   LIKE nme_file.nme07              #CHI-830003 add   
   DEFINE l_nme12   LIKE nme_file.nme12              #CHI-830003 add   
   DEFINE l_bdate   LIKE type_file.dat           #MOD-D10075 add
   DEFINE l_edate   LIKE type_file.dat           #MOD-D10075 add
   DEFINE g_chr     LIKE type_file.chr1          #MOD-D10075 add
     
     CALL cl_del_data(l_table)                   #No.FUN-7A0036
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='anmr363'   #No.FUN-7A0036
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
     #End:FUN-980030
 
     #LET l_sql="SELECT nma09,nma01,nma02,nma10,0,azj07,0,0,0,0,0",    #No:9040   #FUN-550119
     LET l_sql="SELECT nma09,nma01,nma02,nma10,0,0,0,0,0,0,0",    #No:9040   #FUN-550119
               #" FROM nma_file, OUTER azj_file",   #FUN-550119
               " FROM nma_file ",   #FUN-550119
               #" WHERE nma10=azj_file.azj01 AND azj_file.azj02='",yymm,"'",  #FUN-550119
               #" AND ",tm.wc CLIPPED
               " WHERE ",tm.wc CLIPPED
     LET l_sql= l_sql CLIPPED
     PREPARE anmr363_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr363_curs1 CURSOR FOR anmr363_prepare1
#    CALL cl_outnam('anmr363') RETURNING l_name            #No.FUN-7A0036 Mark
#    START REPORT anmr363_rep TO l_name                    #No.FUN-7A0036 Mark
 
#    LET g_pageno = 0                                      #No.FUN-7A0036 Mark
     FOREACH anmr363_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#       IF sr.amt1 IS NULL OR sr.amt1 = 0 THEN CONTINUE FOREACH END IF     #MOD-960038    
       
       #CHI-830003--Add--Begin--#    
       IF g_nmz.nmz20 = 'Y' THEN
          SELECT nme12 INTO l_nme12 FROM nme_file
           WHERE nme01 = sr.nma01
          LET l_oox01 = tm.yy
          LET l_oox02 = tm.mm                      	 
          LET l_nme07 = ''  #TQC-B10083 add
          WHILE cl_null(l_nme07)
                LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                              " WHERE oox00 = 'NM' AND oox01 <= '",l_oox01,"'",
#                             "   AND convert(decimal(8,2),oox02) <= '",l_oox02,"'",     #TQC-9B0018 Mark
                              "   AND cast(oox02 AS decimal(8,2)) <= '",l_oox02,"'",     #TQC-9B0018 Add
                              "   AND oox03 = '",l_nme12,"'",
                              "   AND oox04 = '0'",
                              "   AND oox041 = '0'"                             
                PREPARE r363_prepare7 FROM l_sql_2
                DECLARE r363_oox7 CURSOR FOR r363_prepare7
                OPEN r363_oox7
                FETCH r363_oox7 INTO l_count
                CLOSE r363_oox7                       
                IF l_count = 0 THEN
                   #LET l_nme07 = '1'   #TQC-B10083 mark
                   EXIT WHILE           #TQC-B10083 add
                ELSE                  
                   LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                 " WHERE oox00 = 'NM' AND oox01 = '",l_oox01,"'",
                                 "   AND oox02 = '",l_oox02,"'",
                                 "   AND oox03 = '",l_nme12,"'",
                                 "   AND oox04 = '0'",
                                 "   AND oox041 = '0'"
                END IF                  
             IF l_oox02 = '01' THEN
                LET l_oox02 = '12'
                LET l_oox01 = l_oox01-1
             ELSE    
                LET l_oox02 = l_oox02-1
             END IF            
             
             IF l_count <> 0 THEN        
                PREPARE r363_prepare07 FROM l_sql_1
                DECLARE r363_oox07 CURSOR FOR r363_prepare07
                OPEN r363_oox07
                FETCH r363_oox07 INTO l_nme07
                CLOSE r363_oox07
             END IF              
          END WHILE                       
       END IF
       #CHI-830003--Add--End--#       
       
       IF sr.nma10=g_aza.aza17 THEN CONTINUE FOREACH END IF
       SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nma10   #MOD-790059
       LET sr.amt1 = 0 LET sr.amt2 = 0
       SELECT nmp16,nmp19 INTO sr.amt1,sr.amt2 FROM nmp_file
         WHERE nmp01=sr.nma01 AND nmp02=tm.yy AND nmp03=tm.mm
       LET sr.amt1 = cl_digcut(sr.amt1,t_azi04)   #MOD-940049 add
         
       #CHI-830003--Begin--#
       #IF g_nmz.nmz20 = 'Y' AND l_count <> 0 THEN            #TQC-B10083 mark
       IF g_nmz.nmz20 = 'Y' AND NOT cl_null(l_nme07) THEN     #TQC-B10083 mod 
          LET sr.amt2 = sr.amt1 * l_nme07
       END IF    
       #CHI-830003--End--#
       LET sr.amt2 = cl_digcut(sr.amt2,g_azi04)   #MOD-940049 add
       IF tm.c = 'N' THEN                         #CHI-C30048
          IF sr.amt1 IS NULL OR sr.amt1 = 0 THEN CONTINUE FOREACH END IF         
       END IF                                     #CHI-C30048
#FUN-550119
      #--------------------MOD-D10075-----------------(S)
      #--MOD-D10075--mark
      #IF tm.mm = '12' THEN
      #   LET l_date = MDY(1,1,tm.yy+1) - 1
      #ELSE
      #   LET l_date = MDY(tm.mm+1,1,tm.yy) - 1
      #END IF
      #--MOD-D10075--mark
       IF g_aza.aza63 = 'Y' THEN
          CALL s_azmm(tm.yy,tm.mm,g_nmz.nmz02p,g_nmz.nmz02b)
               RETURNING g_chr,l_bdate,l_edate
       ELSE
          CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,l_bdate,l_edate
       END IF
       LET l_date = l_edate
      #--------------------MOD-D10075-----------------(E)
       CALL s_curr3(sr.nma10,l_date,tm.rate_op) RETURNING sr.new_ex
#END FUN-550119
       LET sr.old_ex = sr.amt2 / sr.amt1
       LET sr.new_amt = sr.amt1 * sr.new_ex
       LET sr.new_amt = cl_digcut(sr.new_amt,g_azi04)   #MOD-940049 add 
       LET amt1 = sr.amt2 - sr.new_amt
      #LET amt1 = cl_digcut(amt1,g_azi04)               #MOD-940049 add  #MOD-C60043 mark
       LET amt1 = cl_digcut(amt1,t_azi04)               #MOD-C60043
       IF amt1 = 0 THEN CONTINUE FOREACH END IF
       IF amt1 < 0 THEN
          LET sr.ex_prof = amt1*-1 LET sr.ex_loss = 0
       ELSE
          LET sr.ex_prof = 0       LET sr.ex_loss = amt1
       END IF
       #-----MOD-790059---------
       LET sr.ex_prof = cl_digcut(sr.ex_prof,g_azi04)
       LET sr.ex_loss = cl_digcut(sr.ex_loss,g_azi04)
       #-----END MOD-790059-----
       SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.nma10   #No.FUN-7A0036
       SELECT azi03,azi04,azi05,azi07  #No.FUN-7A0036                                                                                   
         INTO l_azi03,l_azi04,l_azi05,l_azi07   #No.FUN-7A0036                                                                           
         FROM azi_file                          #No.FUN-7A0036                                                                                         
        WHERE azi01=sr.nma10                    #No.FUN-7A0036 
       EXECUTE insert_prep USING                                                 #No.FUN-7A0036
          sr.nma10,sr.new_ex,sr.nma01,sr.nma02,sr.amt1,sr.old_ex,sr.amt2,  #No.FUN-7A0036
          sr.new_amt,sr.ex_prof,sr.ex_loss,l_azi03,l_azi04,l_azi05,l_azi07,   #No.FUN-7A0036 
          t_azi07                                                       #No.FUN-7A0036
#      OUTPUT TO REPORT anmr363_rep(sr.*)                        #No.FUN-7A0036 Mark  
     END FOREACH
#No.FUN-7A0036--start--
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'nma10,nma09,nma01')
              RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.mm,";",tm.yy,";",g_azi04,";",g_azi05,";",tm.detail
     CALL cl_prt_cs3('anmr363','anmr363',g_sql,g_str)
#No.FUN-7A0036--end--    
#    FINISH REPORT anmr363_rep                                #No.FUN-7A0036 Mark
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)              #No.FUN-7A0036 Mark
END FUNCTION
 
#No.FUN-7A0036--start--
{
REPORT anmr363_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,         #No.FUN-680107 VARCHAR(1)
          l_azi03   LIKE azi_file.azi03,         
          l_azi04   LIKE azi_file.azi04,         
          l_azi05   LIKE azi_file.azi05,         
          l_azi07   LIKE azi_file.azi07,         #FUN-550119  
          sr        RECORD
			nma09	  LIKE nma_file.nma09,
			nma01	  LIKE nma_file.nma01,
			nma02	  LIKE nma_file.nma02,
			nma10	  LIKE nma_file.nma10,
			old_ex    LIKE azj_file.azj07,
			new_ex    LIKE azj_file.azj07,
			amt1      LIKE nmp_file.nmp16,
			amt2      LIKE nmp_file.nmp19,
			new_amt   LIKE nmp_file.nmp19,
			ex_prof   LIKE nmp_file.nmp19,
			ex_loss   LIKE nmp_file.nmp19
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
  ORDER BY sr.nma10,sr.nma01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1=g_x[10] CLIPPED,tm.yy USING '&&&&','/',tm.mm USING '&&'
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
   BEFORE GROUP OF sr.nma10
 
      #SELECT azi03,azi04,azi05   #FUN-550119
      SELECT azi03,azi04,azi05,azi07   #FUN-550119
        #INTO l_azi03,l_azi04,l_azi05   #FUN-550119
        INTO l_azi03,l_azi04,l_azi05,l_azi07   #FUN-550119  
        FROM azi_file
       WHERE azi01=sr.nma10
      PRINT COLUMN g_c[31],sr.nma10,COLUMN g_c[32],cl_numfor(sr.new_ex,32,l_azi07) 
 
   ON EVERY ROW
      IF tm.detail='Y' THEN
         SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.nma10
         PRINT COLUMN g_c[33],sr.nma01,
               COLUMN g_c[34],sr.nma02,
	       COLUMN g_c[35],cl_numfor(sr.amt1,35,l_azi04), 
	       COLUMN g_c[36],cl_numfor(sr.old_ex,36,t_azi07),
	       COLUMN g_c[37],cl_numfor(sr.amt2,37,g_azi04),
	       COLUMN g_c[38],cl_numfor(sr.new_amt,38,g_azi04),
	       COLUMN g_c[39],cl_numfor(sr.ex_prof,39,g_azi04),
	       COLUMN g_c[40],cl_numfor(sr.ex_loss,40,g_azi04)
      END IF
 
   AFTER GROUP OF sr.nma10
      PRINT
      PRINT COLUMN g_c[34],g_x[11] CLIPPED,
	    COLUMN g_c[35],cl_numfor(GROUP SUM(sr.amt1),35,l_azi05), 
	    COLUMN g_c[37],cl_numfor(GROUP SUM(sr.amt2),37,g_azi05),
	    COLUMN g_c[38],cl_numfor(GROUP SUM(sr.new_amt),38,g_azi05),
	    COLUMN g_c[39],cl_numfor(GROUP SUM(sr.ex_prof),39,g_azi05),
	    COLUMN g_c[40],cl_numfor(GROUP SUM(sr.ex_loss),40,g_azi05)
      PRINT
 
   ON LAST ROW
      PRINT COLUMN g_c[34],g_x[12] CLIPPED,
	    COLUMN g_c[35],cl_numfor(SUM(sr.amt1),35,l_azi05),
	    COLUMN g_c[37],cl_numfor(SUM(sr.amt2),37,g_azi05),
	    COLUMN g_c[38],cl_numfor(SUM(sr.new_amt),38,g_azi05),
	    COLUMN g_c[39],cl_numfor(SUM(sr.ex_prof),39,g_azi05),
	    COLUMN g_c[40],cl_numfor(SUM(sr.ex_loss),40,g_azi05)
 
   PAGE TRAILER
       	 PRINT '(anmr363)'
         PRINT g_dash[1,g_len]
         PRINT COLUMN 01,g_x[04] CLIPPED,COLUMN 41,g_x[05] CLIPPED
END REPORT
}
#No.FUN-7A0036--end--
