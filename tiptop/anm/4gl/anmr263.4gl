# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr263.4gl
# Descriptions...: 應收票據月底重評價表
# Date & Author..: 96/05/04 by Roger
# Modify.........: No.FUN-4C0098 04/12/30 By pengu 報表轉XML
# Modify.........: No.FUN-550119 05/05/27 By Smapmin 新增INPUT "匯率選項"
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/11/06 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-780025 07/08/07 By wujie 調整報表格式 
# Modify.........: No.FUN-780011 07/09/18 By Carrier 報表轉Crystal Report格式
# Modify.........: No.CHI-830003 08/11/03 By xiaofeizhu 依程式畫面上的〔截止基准日〕回抓當月重評價匯率, 
# Modify.........:                                      若當月未產生重評價則往回抓前一月資料，若又抓不到再往上一個月找，找到有值為止
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0018 09/11/04 By xiaofeizhu 標準SQL修改
# Modify.........: No.TQC-B10083 11/01/19 By yinhy l_nmh28應給予預設值'',抓不到值不應為'1'
# Modify.........: No.MOD-B30358 11/03/15 By lixia nmz20改用nmz59
# Modify.........: No:MOD-B50041 11/05/06 By Dido 匯兌損益金額先取位 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE yymm   	LIKE azj_file.azj02         #No.FUN-680107 VARCHAR(6)
   DEFINE tm  RECORD                                # Print condition RECORD
		wc      LIKE type_file.chr1000,     #No.FUN-680107 VARCHAR(600) # Where condition
		detail	LIKE type_file.chr1,        #No.FUN-680107 VARCHAR(1)
		edate   LIKE type_file.dat,         #No.FUN-680107 DATE
                rate_op LIKE type_file.chr1,        #No.FUN-680107 VARCHAR(1)  #FUN-550119
		more    LIKE type_file.chr1         #No.FUN-680107 VARCHAR(1)  # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_i            LIKE type_file.num5         #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_head1        STRING
DEFINE   l_table        STRING  #No.FUN-780011
DEFINE   g_str          STRING  #No.FUN-780011
DEFINE   g_sql          STRING  #No.FUN-780011
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
 
   #No.FUN-780011  --Begin
   LET g_sql = " nmh03.nmh_file.nmh03,",
               " nmh04.nmh_file.nmh04,",
               " nmh21.nmh_file.nmh21,",
               " nmh01.nmh_file.nmh01,",
               " nmh31.nmh_file.nmh31,",
               " nmh11.nmh_file.nmh11,",
               " nmh30.nmh_file.nmh30,",
               " old_ex.nmh_file.nmh28,",
               " new_ex.azj_file.azj06,",
               " amt1.nmh_file.nmh02,",
               " amt2.nmh_file.nmh32,",
               " new_amt.nmh_file.nmh02,",
               " ex_prof.nmh_file.nmh02,",
               " ex_loss.nmh_file.nmh02,",
               " azi04.azi_file.azi04,",
               " azi05.azi_file.azi05,",
               " azi07.azi_file.azi07 " 
 
   LET l_table = cl_prt_temptable('anmr263',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?         ) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780011  --End
 
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8)
   LET tm.rate_op = ARG_VAL(9)
   LET tm.detail = ARG_VAL(10) 
   #-----END TQC-610058-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL anmr263_tm(0,0)             # Input print condition
   ELSE
      CALL anmr263()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr263_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01        #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW anmr263_w AT p_row,p_col
        WITH FORM "anm/42f/anmr263"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.detail='Y'
   LET tm.rate_op = 'B'   #FUN-550119
   LET tm.edate=g_today
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh03,nmh11,nmh01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr263_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   #INPUT BY NAME tm.edate,tm.detail,tm.more WITHOUT DEFAULTS    #FUN-550119
   INPUT BY NAME tm.edate,tm.rate_op,tm.detail,tm.more WITHOUT DEFAULTS   #FUN-550119
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         LET yymm=tm.edate USING 'yyyymmdd'
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr263_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr263'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr263','9031',1)
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
                         " '",tm.edate CLIPPED,"'" ,
                         " '",tm.rate_op CLIPPED,"'" ,   #TQC-610058
                         " '",tm.detail CLIPPED,"'" ,   #TQC-610058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr263',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr263_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr263()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr263_w
END FUNCTION
 
FUNCTION anmr263()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0082
          l_sql     LIKE type_file.chr1000,	  #No.FUN-680107 VARCHAR(1200)
          amt1,amt2 LIKE type_file.num20_6,       #No.FUN-680107 DEC(20,6)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          sr        RECORD
			nmh03	  LIKE nmh_file.nmh03,
			nmh04	  LIKE nmh_file.nmh04,
			nmh21	  LIKE nmh_file.nmh21,
			nmh01	  LIKE nmh_file.nmh01,
			nmh31	  LIKE nmh_file.nmh31,
			nmh11	  LIKE nmh_file.nmh11,	#客戶
			nmh30     LIKE nmh_file.nmh30,	#簡稱
			old_ex    LIKE nmh_file.nmh28,
			new_ex    LIKE azj_file.azj06,
			amt1      LIKE nmh_file.nmh02,
			amt2      LIKE nmh_file.nmh32,
			new_amt   LIKE nmh_file.nmh02,
			ex_prof   LIKE nmh_file.nmh02,
			ex_loss   LIKE nmh_file.nmh02
                    END RECORD
   DEFINE l_oox01   STRING                           #CHI-830003 add
   DEFINE l_oox02   STRING                           #CHI-830003 add
   DEFINE l_sql_1   STRING                           #CHI-830003 add
   DEFINE l_sql_2   STRING                           #CHI-830003 add
   DEFINE l_count   LIKE type_file.num5              #CHI-830003 add
   DEFINE l_nmh28   LIKE nmh_file.nmh28              #CHI-830003 add                    
 
     #No.FUN-780011  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780011  --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmhuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmhgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmhgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
     #End:FUN-980030
 
     IF g_aza.aza19 = '1' THEN
        LET l_sql="SELECT nmh03,nmh04,nmh21,nmh01,nmh31,nmh11,nmh30,",
                  "       nmh28,azj06,nmh02,nmh32,0,0,0",
                  " FROM nmh_file, OUTER azj_file",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND nmh_file.nmh03=azj_file.azj01 AND azj_file.azj02='",yymm,"'",
                  "   AND nmh04 <= '",tm.edate,"'",
                  "   AND nmh38 <> 'X' ",
                  "   AND (nmh35 IS NULL OR nmh35 > '",tm.edate,"')"
     ELSE
        LET l_sql="SELECT nmh03,nmh04,nmh21,nmh01,nmh31,nmh11,nmh30,",
                  "       nmh28,0,nmh02,nmh32,0,0,0",
                  " FROM nmh_file",
                  " WHERE ",tm.wc CLIPPED,
                  "   AND nmh04 <= '",tm.edate,"'",
                  "   AND nmh38 <> 'X' ",
                  "   AND (nmh35 IS NULL OR nmh35 > '",tm.edate,"')"
     END IF
     LET l_sql= l_sql CLIPPED
     PREPARE anmr263_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE anmr263_curs1 CURSOR FOR anmr263_prepare1
 
     #No.FUN-780011  --Begin
     #CALL cl_outnam('anmr263') RETURNING l_name
     #START REPORT anmr263_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-780011  --End  
 
     FOREACH anmr263_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.nmh03=g_aza.aza17 THEN CONTINUE FOREACH END IF       
       
      #CHI-830003--Add--Begin--#    
      #IF g_nmz.nmz20 = 'Y' THEN
      IF g_nmz.nmz59 = 'Y' THEN  #MOD-B30358
         LET l_oox01 = YEAR(tm.edate)
         LET l_oox02 = MONTH(tm.edate)                      	 
         LET l_nmh28 = ''  #TQC-B10083 add
         WHILE cl_null(l_nmh28)
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'NM' AND oox01 <= '",l_oox01,"'",
#                            "   AND convert(decimal(8,2),oox02) <= '",l_oox02,"'",     #TQC-9B0018 Mark
                             "   AND cast(oox02 AS decimal(8,2)) <= '",l_oox02,"'",     #TQC-9B0018 Add
                             "   AND oox03 = '",sr.nmh01,"'",
                             "   AND oox04 = '0'",
                             "   AND oox041 = '0'"                             
               PREPARE r263_prepare7 FROM l_sql_2
               DECLARE r263_oox7 CURSOR FOR r263_prepare7
               OPEN r263_oox7
               FETCH r263_oox7 INTO l_count
               CLOSE r263_oox7                       
               IF l_count = 0 THEN
                  #LET l_nmh28 = '1'    #TQC-B10083 mark
                  EXIT WHILE            #TQC-B10083 add
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'NM' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.nmh01,"'",
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
               PREPARE r263_prepare07 FROM l_sql_1
               DECLARE r263_oox07 CURSOR FOR r263_prepare07
               OPEN r263_oox07
               FETCH r263_oox07 INTO l_nmh28
               CLOSE r263_oox07
            END IF              
         END WHILE                       
      END IF
      #CHI-830003--Add--End--#       
       
       ### 02/09/19 add by connie
       IF g_aza.aza19 = '2' THEN
          #CALL s_curr3(sr.nmh03,tm.edate,'B') RETURNING sr.new_ex   #FUN-550119
          CALL s_curr3(sr.nmh03,tm.edate,tm.rate_op) RETURNING sr.new_ex   #FUN-550119
       END IF
       ###
       LET sr.new_amt = sr.amt1 * sr.new_ex
       LET sr.amt2 = sr.amt1 * sr.old_ex
       
      #CHI-830003--Begin--#
      #IF g_nmz.nmz20 = 'Y' AND l_count <> 0 THEN          #TQC-B10083 mark
      #IF g_nmz.nmz20 = 'Y' AND NOT cl_null(l_nmh28) THEN  #TQC-B10083 mod
      IF g_nmz.nmz59 = 'Y' AND NOT cl_null(l_nmh28) THEN   #MOD-B30358
         LET sr.amt2 = sr.amt1 * l_nmh28
      END IF    
      #CHI-830003--End--#       
       
       LET amt1 = sr.amt2 - sr.new_amt
       IF amt1 = 0 THEN CONTINUE FOREACH END IF
       IF amt1 < 0
          THEN LET sr.ex_prof = amt1*-1 LET sr.ex_loss = 0
          ELSE LET sr.ex_prof = 0       LET sr.ex_loss = amt1
       END IF
       CALL cl_digcut(sr.ex_prof,g_azi04) RETURNING sr.ex_prof    #MOD-B50041 
       CALL cl_digcut(sr.ex_loss,g_azi04) RETURNING sr.ex_loss    #MOD-B50041 
       #No.FUN-780011  --Begin
       #OUTPUT TO REPORT anmr263_rep(sr.*)
       SELECT azi04,azi05,azi07
         INTO t_azi04,t_azi05,t_azi07    #NO.CHI-6A0004
         FROM azi_file
        WHERE azi01=sr.nmh03
       EXECUTE insert_prep USING sr.*,t_azi04,t_azi05,t_azi07
       #No.FUN-780011  --End  
     END FOREACH
 
     #No.FUN-780011  --Begin
     #FINISH REPORT anmr263_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmh03,nmh11,nmh01')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.edate,";",tm.detail,";",
                 g_azi04,";",g_azi05
     CALL cl_prt_cs3('anmr263','anmr263',g_sql,g_str)
     #No.FUN-780011  --End  
END FUNCTION
 
#No.FUN-780011  --Begin
#REPORT anmr263_rep(sr)
#   DEFINE l_last_sw LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#        #  l_azi03   LIKE azi_file.azi03,  #NO.CHI-6A0004
#        #  l_azi04   LIKE azi_file.azi04,  #NO.CHI-6A0004
#        #  l_azi05   LIKE azi_file.azi05,  #NO.CHI-6A0004
#          sr        RECORD
#                    nmh03     LIKE nmh_file.nmh03,
#                    nmh04     LIKE nmh_file.nmh04,
#                    nmh21     LIKE nmh_file.nmh21,
#                    nmh01     LIKE nmh_file.nmh01,
#                    nmh31     LIKE nmh_file.nmh31,
#                    nmh11     LIKE nmh_file.nmh11,  #客戶
#                    nmh30     LIKE nmh_file.nmh30,  #簡稱
#                    old_ex    LIKE nmh_file.nmh28,
#                    new_ex    LIKE azj_file.azj06,
#                    amt1      LIKE nmh_file.nmh02,
#                    amt2      LIKE nmh_file.nmh32,
#                    new_amt   LIKE nmh_file.nmh02,
#                    ex_prof   LIKE nmh_file.nmh02,
#                    ex_loss   LIKE nmh_file.nmh02
#                END RECORD
#
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#  ORDER BY sr.nmh03,sr.nmh11,sr.nmh30,sr.nmh04
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
#      LET g_head1= g_x[13] CLIPPED,tm.edate
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,
#            g_x[43] CLIPPED
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#   BEFORE GROUP OF sr.nmh03
#      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.nmh03
#      PRINT COLUMN g_c[31],sr.nmh03,
#            COLUMN g_c[32],cl_numfor(sr.new_ex,32,t_azi07);
#
#      SELECT azi03,azi04,azi05,azi07
#        INTO t_azi03,t_azi04,t_azi05,t_azi07    #NO.CHI-6A0004
#        FROM azi_file
#       WHERE azi01=sr.nmh03
#
#   ON EVERY ROW
#      IF tm.detail='Y' THEN
#         #No:7952
#         PRINT COLUMN g_c[33],sr.nmh11[1,8],
#               COLUMN g_c[34],sr.nmh30,
#               COLUMN g_c[35],sr.nmh01,
#               COLUMN g_c[36],sr.nmh31,
#               COLUMN g_c[37],sr.nmh04,
#               COLUMN g_c[38],cl_numfor(sr.amt1,38,t_azi04), #NO.CHI-6A0004
#               COLUMN g_c[39],cl_numfor(sr.old_ex,39,t_azi07),
#               COLUMN g_c[40],cl_numfor(sr.amt2,40,g_azi04),
#               COLUMN g_c[41],cl_numfor(sr.new_amt,41,g_azi04),
#               COLUMN g_c[42],cl_numfor(sr.ex_prof,42,g_azi04),
#               COLUMN g_c[43],cl_numfor(sr.ex_loss,43,g_azi04)
#         ##
#      END IF
#
#   AFTER GROUP OF sr.nmh03
#      PRINT
#      #No:7952
#      PRINT COLUMN g_c[37],g_x[11] CLIPPED,
#		COLUMN g_c[38],cl_numfor(GROUP SUM(sr.amt1),38,t_azi05), #NO.CHI-6A0004
#		COLUMN g_c[40],cl_numfor(GROUP SUM(sr.amt2),40,g_azi05),
#		COLUMN g_c[41],cl_numfor(GROUP SUM(sr.new_amt),41,g_azi05),
#		COLUMN g_c[42],cl_numfor(GROUP SUM(sr.ex_prof),42,g_azi05),
#		COLUMN g_c[43],cl_numfor(GROUP SUM(sr.ex_loss),43,g_azi05)
#      PRINT
#      ##
#   ON LAST ROW
#      #No:7952
#      PRINT COLUMN g_c[37],g_x[12] CLIPPED,
#             #  COLUMN g_c[38],cl_numfor(SUM(sr.amt1),38,t_azi05),  #NO.CHI-6A0004
#		COLUMN g_c[40],cl_numfor(SUM(sr.amt2),40,g_azi05),
#		COLUMN g_c[41],cl_numfor(SUM(sr.new_amt),41,g_azi05),
#		COLUMN g_c[42],cl_numfor(SUM(sr.ex_prof),42,g_azi05),
#		COLUMN g_c[43],cl_numfor(SUM(sr.ex_loss),43,g_azi05)
##No.TQC-780025--begin
#       NEED 4 LINE                                                                                                                  
#       IF g_zz05 = 'Y'  THEN                                                                                                        
#          CALL cl_wcchp(tm.wc,'nmh03,nmh11,nmh01')                                                                                  
#          RETURNING tm.wc                                                                                                           
#          PRINT g_dash[1,g_len]                                                                                                     
#          CALL cl_prt_pos_wc(tm.wc)                                                                                                 
#       END IF                                                                                                                       
#       PRINT g_dash[1,g_len]                                                                                                        
#       PRINT g_x[4] CLIPPED ,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED                                                       
#       LET l_last_sw = 'y'  
##No.TQC-780025--end
#      ##
#   PAGE TRAILER
##No.TQC-780025--begin
##        PRINT g_dash[1,g_len]
##        PRINT g_x[4] CLIPPED, g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]
#         IF l_last_sw = 'n' THEN                                                                                                   
#           PRINT g_dash[1,g_len]                                                                                                   
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED                                                   
#         ELSE                                                                                                                      
#           SKIP 2 LINE                                                                                                             
#         END IF                                                                                                                    
#
#        PRINT g_x[8] CLIPPED, COLUMN(g_len/3),g_x[9] CLIPPED,COLUMN (g_len*2/3),g_x[14]                                                               
#        PRINT g_dash2  
##No.TQC-780025--end
#END REPORT
#No.FUN-780011  --End  
