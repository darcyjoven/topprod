# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmr120.4gl
# Descriptions...: 自領應付票據廠商簽收回條列印作業
# Input parameter:
# Return code....:
# Date & Author..: 93/04/11 By Felicity Tseng
# Modify.........: No.FUN-4C0098 05/03/02 By pengu 修改單價、金額欄位寬度
# Modify.........: NO.FUN-550057 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-550114 05/05/26 By echo 新增報表備註
# Modify.........: No.MOD-590097 05/09/08 By will 全型報表修改
# Modify.........: No.MOD-590485 05/09/30 By Smapmin 報表列印方式修改
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710085 07/03/06 By Rayven Crystal Report修改
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740326 07/04/28 By dxfwo  條件選項第2欄位未有默認值
# Modify.........: No.TQC-760039 07/06/06 By Smapmin 加印開票公司
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C10034 12/01/18 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD			
              wc  LIKE type_file.chr1000,  #No.FUN-680107 #Where Condiction
              s   LIKE type_file.chr2,     #No.FUN-680107 VARCHAR(2)
              t   LIKE type_file.chr2,     #No.FUN-680107 VARCHAR(2)
           more   LIKE type_file.chr1      #No.FUN-680107 VARCHAR(1)
              END RECORD,
          g_qq    LIKE type_file.num5,     #No.FUN-680107 SMALLINT
          g_counter1 LIKE type_file.num5   #No.FUN-680107 SMALLINT
 
DEFINE   g_i      LIKE type_file.num5      #count/index for any purpose #No.FUN-680107 SMALLINT
#No.FUN-710085 --start--
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING
#No.FUN-710085 --end--
DEFINE  g_zo07     LIKE zo_file.zo07   #TQC-760039
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-710085 --start--
   LET g_sql = "nmd01.nmd_file.nmd01,nmd02.nmd_file.nmd02,",
               "nmd03.nmd_file.nmd03,nmd04.nmd_file.nmd04,",
               "nmd05.nmd_file.nmd05,nmd06.nmd_file.nmd06,",
               "nmd07.nmd_file.nmd07,nmd08.nmd_file.nmd08,",
               "nmd09.nmd_file.nmd09,nmd11.nmd_file.nmd11,",
               "nmd14.nmd_file.nmd14,nmd20.nmd_file.nmd20,",
               "str.type_file.chr1000,azi04.azi_file.azi04,",    #No.TQC-C10034 add , ,
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
 
   LET l_table = cl_prt_temptable('anmr120',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,? ,?,?,?,?)"  #No.TQC-C10034 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-710085 --end--
 
   #-----TQC-610058---------
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #-----END TQC-610058-----
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL r120_tm()	
   ELSE
      CALL r120()	
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION r120_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_cmd          LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
       l_jmp_flag     LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
 # CALL s_dsmark(g_bookno)
   LET p_row = 4 LET p_col = 13
   OPEN WINDOW anmr120_w AT p_row,p_col
        WITH FORM "anm/42f/anmr120"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 # CALL s_shwact(3,2,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
#  LET tm.s = '1 '
   LET tm.s = '12'                              # TQC-740326    
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET l_jmp_flag = 'N'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmd01,nmd03,nmd07,nmd14,nmd08,nmd06,nmd20
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]"
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
   AFTER INPUT
      LET l_jmp_flag = 'N'
      LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
      LET tm.t = tm2.t1,tm2.t2
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
      LET INT_FLAG = 0 CLOSE WINDOW anmr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	
             WHERE zz01='anmr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr120','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,	
                         #-----TQC-610058---------
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         #-----END TQC-610058-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr120',g_time,l_cmd)  # Execute cmd at later time
         CLOSE WINDOW anmr120_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
   END IF
   CALL cl_wait()
   CALL r120()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr120_w
END FUNCTION
 
FUNCTION r120()
   DEFINE l_name	LIKE type_file.chr20, 		    # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0082
          l_sql 	LIKE type_file.chr1000,		    # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_za05	LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[2] OF LIKE nmd_file.nmd03,    #No.FUN-680107 ARRAY[2] OF VARCHAR(8)
          l_i           LIKE type_file.num5,                #No.FUN-680107 SMALLINT
          sr               RECORD
                           order1    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(8)
                           order2    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(8)
			   g_nmd     RECORD LIKE nmd_file.*,
			   azi04     LIKE azi_file.azi04    #No.FUN-710085
			  #azi05     LIKE azi_file.azi05    #No.FUN-710085 mark
                        END RECORD
   #No.FUN-710085 --start--
   DEFINE l_nmo02_1     LIKE nmo_file.nmo02
   DEFINE l_nmo02_2     LIKE nmo_file.nmo02
   DEFINE l_nmd09       LIKE nmd_file.nmd09
   DEFINE l_str         LIKE type_file.chr1000
   DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
   LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
 
     CALL cl_del_data(l_table)
   #No.FUN-710085 --end--
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zo07 INTO g_zo07 FROM zo_file WHERE zo01 = g_rlang   #TQC-760039
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr120'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND nmduser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND nmdgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND nmdgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nmduser', 'nmdgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','',nmd_file.* ,azi04 ",
                 " FROM nmd_file,",
                 " OUTER azi_file ",
                 " WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED,
                 " AND azi_file.azi01 = nmd_file.nmd21 "
 
     PREPARE r120_p1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     DECLARE r120_c1 CURSOR FOR r120_p1
     LET l_sql = "SELECT COUNT(*)",
                 " FROM nmd_file,",
                 " OUTER azi_file ",
                 " WHERE nmd30 <> 'X' AND ",tm.wc CLIPPED,
                 " AND azi_file.azi01 = nmd_file.nmd21 "
     PREPARE r120_p2 FROM l_sql
     DECLARE r120_c2 CURSOR FOR r120_p2
     OPEN r120_c2
     FETCH r120_c2 INTO g_qq
     CLOSE r120_c2
 
#No.FUN-710085 --start-- mark
#    CALL cl_outnam('anmr120') RETURNING l_name
#    START REPORT r120_rep TO l_name
#    LET g_counter1 = 0
#No.FUN-710085 --end--
 
     FOREACH r120_c1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
#No.FUN-710085 --start--
#      FOR l_i = 1 TO 2
#          CASE WHEN tm.s[l_i,l_i] = '1' LET l_order[l_i] = sr.g_nmd.nmd01
#               WHEN tm.s[l_i,l_i] = '2' LET l_order[l_i] = sr.g_nmd.nmd03
#               WHEN tm.s[l_i,l_i] = '3' LET l_order[l_i] = sr.g_nmd.nmd07
#       						USING 'yyyymmdd'
#               WHEN tm.s[l_i,l_i] = '4' LET l_order[l_i] = sr.g_nmd.nmd14
#               WHEN tm.s[l_i,l_i] = '5' LET l_order[l_i] = sr.g_nmd.nmd08
#               WHEN tm.s[l_i,l_i] = '6' LET l_order[l_i] = sr.g_nmd.nmd06
#               WHEN tm.s[l_i,l_i] = '7' LET l_order[l_i] = sr.g_nmd.nmd20
#               OTHERWISE LET l_order[l_i] = '-'
#          END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      OUTPUT TO REPORT r120_rep(sr.*)
 
       LET l_nmo02_1 = ' ' LET l_nmo02_2 = ' '
       IF NOT cl_null(sr.g_nmd.nmd06) THEN
          SELECT nmo02 INTO l_nmo02_1 FROM nmo_file WHERE nmo01 = sr.g_nmd.nmd06
       END IF
       IF NOT cl_null(sr.g_nmd.nmd20) THEN
          SELECT nmo02 INTO l_nmo02_2 FROM nmo_file WHERE nmo01 = sr.g_nmd.nmd20
       END IF
       LET l_str = sr.g_nmd.nmd06,' ',l_nmo02_1,' ',
                   sr.g_nmd.nmd20,' ',l_nmo02_2
       LET l_nmd09 = sr.g_nmd.nmd09[1,32]
       EXECUTE insert_prep USING sr.g_nmd.nmd01,sr.g_nmd.nmd02,sr.g_nmd.nmd03,
                                 sr.g_nmd.nmd04,sr.g_nmd.nmd05,sr.g_nmd.nmd06,
                                 sr.g_nmd.nmd07,sr.g_nmd.nmd08,l_nmd09,
                                 sr.g_nmd.nmd11,sr.g_nmd.nmd14,sr.g_nmd.nmd20,
                                 l_str,sr.azi04
                                 ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add
#No.FUN-710085 --end--
     END FOREACH
 
 
#    FINISH REPORT r120_rep                       #No.FUN-710085 mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710085 mark
 
     #No.FUN-710085 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'nmd01,nmd03,nmd07,nmd14,nmd08,nmd06,nmd20')
          RETURNING tm.wc
     #LET g_str = tm.wc,";",g_zz05,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",tm.t[2,2]   #TQC-760039
     LET g_str = tm.wc,";",g_zz05,";",tm.s[1,1],";",tm.s[2,2],";",tm.t[1,1],";",tm.t[2,2],";",g_zo07   #TQC-760039
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088
   # CALL cl_prt_cs3('anmr120',l_sql,g_str)
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "nmd01"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
     CALL cl_prt_cs3('anmr120','anmr120',l_sql,g_str)
     #No.FUN-710085 --end--
END FUNCTION
 
REPORT r120_rep(sr)
   DEFINE l_last_sw	LIKE type_file.chr1,     #No.FUN-680107 VARCHAR(1)
          l_nmo02_1,l_nmo02_2 LIKE nmo_file.nmo02,
          l_counter LIKE type_file.num5,     #No.FUN-680107 SMALLINT
          l_nmd09   LIKE nmd_file.nmd09,     #No.FUN-680107 VARCHAR(32)
          l_str     LIKE type_file.chr1000,	 #No.FUN-680107 VARCHAR(100) #MOD-590485
          sr               RECORD
                           order1    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(8)
                           order2    LIKE nmd_file.nmd03,   #No.FUN-680107 VARCHAR(8)
			   g_nmd     RECORD LIKE nmd_file.*,
			   azi04     LIKE azi_file.azi04
                        END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
      PRINT ' '
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#No.MOD-590097  --begin
#     PRINT '┌──────────────────────┬',
#            '──────────────────┐'
      PRINT g_x[26],g_x[33],g_x[27]
      LET l_counter = 0
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1]='Y' THEN SKIP TO TOP OF PAGE END IF
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2]='Y' THEN SKIP TO TOP OF PAGE END IF
   ON EVERY ROW
      LET l_counter = l_counter +1
      LET g_counter1 = g_counter1 +1
{1}   PRINT COLUMN 01,g_x[28],
            COLUMN 03,g_x[11] CLIPPED, sr.g_nmd.nmd01,
#No.FUN-550057 --start--
            COLUMN 30,g_x[12] CLIPPED, sr.g_nmd.nmd07,
            COLUMN 47,g_x[28],
            COLUMN 50,g_x[19] CLIPPED,
            COLUMN 66,g_x[21] CLIPPED,
            COLUMN 85,g_x[28]
{2}   PRINT COLUMN 01,g_x[28],
            COLUMN 47,g_x[28],
            COLUMN 85,g_x[28]
{3}   PRINT COLUMN 01,g_x[28],
            COLUMN 03,g_x[13] CLIPPED, sr.g_nmd.nmd02,
            COLUMN 30,g_x[14] CLIPPED, sr.g_nmd.nmd05,
            COLUMN 47,g_x[28],
            COLUMN 85,g_x[28]
{4}   PRINT COLUMN 01,g_x[28],
            COLUMN 47,g_x[28],
            COLUMN 85,g_x[28]
{5}   PRINT COLUMN 01,g_x[28],
            COLUMN 03,g_x[15] CLIPPED,
            COLUMN 12,cl_numfor(sr.g_nmd.nmd04,18,sr.azi04),
            COLUMN 47,g_x[28],
            COLUMN 85,g_x[28]
{2}   PRINT COLUMN 01,g_x[28],
            COLUMN 03,g_x[16] CLIPPED;
            CASE WHEN sr.g_nmd.nmd14 ='1' PRINT '寄出';
                 WHEN sr.g_nmd.nmd14 ='2' PRINT g_x[22] CLIPPED;
                 WHEN sr.g_nmd.nmd14 ='3' PRINT g_x[23] CLIPPED;
            END CASE
      PRINT COLUMN 47,g_x[28],
            COLUMN 85,g_x[28]
{6}   PRINT COLUMN 01,g_x[28],
            COLUMN 47,g_x[28],
            COLUMN 85,g_x[28]
      LET l_nmd09 = sr.g_nmd.nmd09[1,32]
{7}   PRINT COLUMN 01,g_x[28],
            COLUMN 03,g_x[17] CLIPPED,l_nmd09
                ,      #         USING'################################',
            COLUMN 47,g_x[28],
            COLUMN 85,g_x[28]
LET l_nmo02_1 = ' ' LET l_nmo02_2 = ' '
IF NOT cl_null(sr.g_nmd.nmd06) THEN
   SELECT nmo02 INTO l_nmo02_1 FROM nmo_file WHERE nmo01 = sr.g_nmd.nmd06
END IF
IF NOT cl_null(sr.g_nmd.nmd20) THEN
   SELECT nmo02 INTO l_nmo02_2 FROM nmo_file WHERE nmo01 = sr.g_nmd.nmd20
END IF
      LET l_str = sr.g_nmd.nmd06,' ',l_nmo02_1,' ',   #MOD-590485
                  sr.g_nmd.nmd20,' ',l_nmo02_2   #MOD-590485
{8}   PRINT COLUMN 01,g_x[28],
#            COLUMN 03,g_x[24] CLIPPED,sr.g_nmd.nmd06,' ',l_nmo02_1,' ',   #MOD-590485
#                              sr.g_nmd.nmd20,' ',l_nmo02_2,   #MOD-590485
            COLUMN 03,g_x[24] CLIPPED,l_str CLIPPED,   #MOD-590485
            COLUMN 47,g_x[28],
            COLUMN 50,l_nmd09
             ,    #   USING'##################################',
            COLUMN 85,g_x[28]
{9}   PRINT COLUMN 01,g_x[28],
#            COLUMN 03,g_x[18] CLIPPED, sr.g_nmd.nmd11,   #MOD-590485
            COLUMN 03,g_x[18] CLIPPED, sr.g_nmd.nmd11 CLIPPED,   #MOD-590485
            COLUMN 47,g_x[28],
            COLUMN 50,sr.g_nmd.nmd08,
            COLUMN 85,g_x[28]
      IF l_counter !=5 AND g_counter1 != g_qq THEN
#        PRINT '├──────────────────────┼',
#              '──────────────────┤'
         PRINT g_x[29],g_x[34],g_x[30]
      ELSE
#        PRINT '└──────────────────────┴',
#              '──────────────────┘'
         PRINT g_x[31],g_x[35],g_x[32]
#No.FUN-550057--end
      LET l_counter = 0
## FUN-550114
   #   SKIP TO TOP OF PAGE
      END IF
ON LAST ROW
     LET l_last_sw = 'y'
#No.MOD-590097  --end
 
PAGE TRAILER
     IF l_last_sw = 'n' THEN
        IF g_memo_pagetrailer THEN
            PRINT g_x[25]
            PRINT g_memo
        ELSE
            PRINT
            PRINT
        END IF
     ELSE
            PRINT g_x[25]
            PRINT g_memo
     END IF
## END FUN-550114
 
 
END REPORT
#Patch....NO.TQC-610036 <001> #
