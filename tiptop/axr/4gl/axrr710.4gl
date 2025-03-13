# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr710.4gl
# Descriptions...: 客戶業務明細帳列印
# Date & Author..: 03/05/19 by Carrier
# Modify.........: No.FUN-4C0100 05/03/01 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-540057 05/05/10 By wujie 發票號碼調整
# Modify.........: No.FUN-550071 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.TQC-640197 06/06/28 By Echo 設定g_len應放在cl_outnam之後
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-630155 06/06/22 By Smapmin 將報表轉為XML格式
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳套權限修改
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.TQC-670076 06/07/21 By cl ooo10和npp06對應g_ooz.ooz02p
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/13 By xufeng 修改報表格式         
# Modify.........: No.FUN-730073 07/04/02 By sherry 會計科目加帳套
# Modify.........: No.TQC-790085 07/09/13 By lumxa  表名和制表日期位置顛倒。
# Modify.........: NO.FUN-7B0026 07/11/16 BY zhaijie報表輸出改為Crystal Report
# Modify.........: No.MOD-830081 08/03/17 By Smapmin 修正foreach語法/幣別取位
# Modify.........: No.MOD-970139 09/07/16 By mike 抓取oma_file資料前,先判斷有沒有這筆資料,有資料才抓,                               
#                                                 否則直接抓當抓不到oma09不會是null而是99/12/31,造成報表資料錯誤                    
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/20 By yinhy 科目查询自动过滤,調整帳套位置
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD                                # Print condition RECORD
	   	  wc      LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000) # Where condition
                  a       LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20)
		  bdate   LIKE type_file.dat,           #No.FUN-680123 DATE
		  edate   LIKE type_file.dat,           #No.FUN-680123 DATE
                  o       LIKE aaa_file.aaa01,          #No.FUN-670039
                  b       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
                  c       LIKE type_file.chr4,          #No.FUN-680123 VARCHAR(4)
                  d       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
                  e       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
	  	  more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01) # Input more condition(Y/N)
                  END RECORD,
       g_d                LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
       g_print            LIKE type_file.num5,          #No.FUN-680123 SMALLINT
       g_aaa03            LIKE aaa_file.aaa03,
       g_aza17            LIKE aza_file.aza17,
       g_azi01            LIKE aza_file.aza17,
       g_qcyef            LIKE npq_file.npq07,
       g_qcye             LIKE npq_file.npq07,
       g_npq07f_l         LIKE npq_file.npq07,
       g_npq07f_r         LIKE npq_file.npq07,
       g_npq07_l          LIKE npq_file.npq07,
       g_npq07_r          LIKE npq_file.npq07
 
DEFINE   g_i              LIKE type_file.num5           #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   g_sql            STRING                        #NO.FUN-7B0026
DEFINE   g_str            STRING                        #NO.FUN-7B0026
DEFINE   l_table          STRING                        #NO.FUN-7B0026
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
#NO.FUN-7B0026----------start----------
   LET g_sql = "npp01.npp_file.npp01,",
               "npp02.npp_file.npp02,",
               "npq03.npq_file.npq03,",
               "aag02.aag_file.aag02,",
               "npq06.npq_file.npq06,",
               "npq07f.npq_file.npq07f,",
               "npq07.npq_file.npq07,",
               "npq21.npq_file.npq21,",
               "npq22.occ_file.occ18,",
               "npq24.npq_file.npq24,",
               "oma09.oma_file.oma09,",
               "oma10.oma_file.oma10,",
               "qcyef.npq_file.npq07,",
               "qcye.npq_file.npq07,",
               "azi04.azi_file.azi04,",   #MOD-830081
               "azi05.azi_file.azi05"   #MOD-830081
   LET l_table = cl_prt_temptable('axrr710',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,",
               #"        ?,?,?,?)"   #MOD-830081
               "        ?,?,?,?,?,?)"   #MOD-830081
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#NO.FUN-7B0026-----------end-----
   INITIALIZE tm.* TO NULL            # Default condition
 
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_azi01 FROM aaa_file WHERE aaa01 = g_ooz.ooz02b
   IF SQLCA.sqlcode THEN LET g_azi01 = g_aza.aza17 END IF     #使用本國幣別
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.edate = ARG_VAL(10)
   LET tm.o = ARG_VAL(11)
   LET tm.b = ARG_VAL(12)
   LET tm.c = ARG_VAL(13)
   LET tm.d = ARG_VAL(14)
   LET tm.e = ARG_VAL(15)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
       CALL axrr710_tm(0,0)             # Input print condition
   ELSE 
       CALL axrr710()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr710_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_n            LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_flag         LIKE type_file.num5,         #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680123 VARCHAR(1000)
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-680123 SMALLINT  #No.FUN-670006
 
   LET p_row = 4 LET p_col = 13
 
   OPEN WINDOW axrr710_w AT p_row,p_col WITH FORM "axr/42f/axrr710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   SELECT ool11 INTO tm.a FROM ooz_file,ool_file
    WHERE ooz00 = '0' AND ool01 = ooz08
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.o = g_ooz.ooz02b
   LET tm.b = 'N'
   LET tm.c = g_aza.aza17
   LET tm.d = '1'
   LET tm.e = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   DISPLAY BY NAME tm.a,tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON npq21,npp01
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
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #INPUT BY NAME tm.a,tm.bdate,tm.edate,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more   #FUN-B10053 mark
   INPUT BY NAME tm.o,tm.a,tm.bdate,tm.edate,tm.b,tm.c,tm.d,tm.e,tm.more    #FUN-B10053 mod
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
        LET l_flag = 0
        IF cl_null(tm.a) THEN
           CALL cl_err('','mfg3018',0)
           NEXT FIELD a
        ELSE
           SELECT COUNT(*) INTO l_n FROM aag_file
            WHERE aag01 = tm.a 
              AND aag00 = tm.o        #No.FUN-730073  
              #AND aag07 MATCHES '[23]'   #No.FUN-730073
              AND aag07 IN ('2','3')      #No.FUN-730073 
           #No.FUn-B10053 --Begin
           #IF l_n = 0 THEN CALL cl_err(tm.a,'mfg1004',0) NEXT FIELD a END IF
           IF l_n = 0 THEN 
              CALL cl_err(tm.a,'mfg1004',0) 
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aag'
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = tm.a
              LET g_qryparam.arg1 = tm.o
              LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",tm.a CLIPPED ,"%'"
              CALL cl_create_qry() RETURNING tm.a
              DISPLAY BY NAME tm.a
              NEXT FIELD a 
           END IF
           #No.FUn-B10053 --End
        END IF
 
      AFTER FIELD bdate
        IF cl_null(tm.bdate) THEN
           CALL cl_err('','mfg0037',0) NEXT FIELD bdate
        END IF
 
      AFTER FIELD edate
        IF cl_null(tm.edate) THEN
           CALL cl_err('','mfg0037',0) NEXT FIELD edate
        END IF
        IF YEAR(tm.bdate) <> YEAR(tm.edate) THEN
           CALL cl_err('','gxr-001',0) NEXT FIELD bdate
        END IF
        IF tm.bdate > tm.edate THEN
           CALL cl_err(tm.edate,'aap-100',0) NEXT FIELD bdate
        END IF
 
      AFTER FIELD o
        LET l_flag = 1
        IF cl_null(tm.o) THEN
           CALL cl_err('','mfg0037',0) NEXT FIELD o
        END IF
        #No.FUN-670006--begin
             CALL s_check_bookno(tm.o,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD o
             END IF 
             #No.FUN-670006--end
        SELECT * FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN
#          CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660116
           CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
           NEXT FIELD o
        END IF
        #No.FUN-B10053 --Begin
           SELECT COUNT(*) INTO l_n FROM aag_file
            WHERE aag01 = tm.a
              AND aag00 = tm.o
              AND aag07 IN ('2','3')
           IF l_n = 0 THEN CALL cl_err(tm.a,'mfg1004',0) NEXT FIELD a END IF
        #No.FUN-B10053 --End
        SELECT aaa03 INTO g_azi01 FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN LET g_azi01 = g_aza.aza17 END IF   #使用本國幣別
 
      AFTER FIELD b
        LET l_flag = 1
# genero  script marked         IF cl_ku() THEN NEXT FIELD o END IF
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN NEXT FIELD b END IF
        IF tm.b = 'N' THEN
           LET tm.c = NULL
           DISPLAY BY NAME tm.c
        END IF
 
      BEFORE FIELD c
        IF l_flag = 1 THEN
           IF tm.b = 'N' THEN NEXT FIELD d END IF
        ELSE
           IF l_flag = 2 THEN
              IF tm.b = 'N' THEN NEXT FIELD o END IF
           END IF
        END IF
 
      AFTER FIELD c
        IF tm.b = 'Y' THEN
           IF cl_null(tm.c) THEN NEXT FIELD c END IF
           SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01 = tm.c
           IF l_n = 0 THEN CALL cl_err(tm.c,'aap-002',0) NEXT FIELD c END IF
        END IF
 
      AFTER FIELD d
        LET l_flag = 2
# genero  script marked         IF cl_ku() THEN NEXT FIELD b END IF
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[123]' THEN NEXT FIELD d END IF
 
      AFTER FIELD e
        IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN NEXT FIELD e END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF tm.b = 'N' THEN LET tm.c = '' DISPLAY BY NAME tm.c END IF
         IF tm.b = 'Y' AND cl_null(tm.c) THEN NEXT FIELD c END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(a)     #科目代號
#              CALL q_aag(8,5,tm.a,'23','','') RETURNING tm.a
#              CALL FGL_DIALOG_SETBUFFER( tm.a )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aag'
	       LET g_qryparam.default1 = tm.a
               LET g_qryparam.arg1 = tm.o
               CALL cl_create_qry() RETURNING tm.a
#               CALL FGL_DIALOG_SETBUFFER( tm.a )
               DISPLAY BY NAME tm.a
               NEXT FIELD a
 
            WHEN INFIELD(c)     #幣別代號
#              CALL q_azi(8,5,tm.c) RETURNING tm.c
#              CALL FGL_DIALOG_SETBUFFER( tm.c )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.c
               CALL cl_create_qry() RETURNING tm.c
#               CALL FGL_DIALOG_SETBUFFER( tm.c )
               DISPLAY BY NAME tm.c
               NEXT FIELD c
 
            OTHERWISE
               EXIT CASE
 
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr710_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr710'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr710','9031',1) 
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang   CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.o     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",tm.c     CLIPPED,"'",
                         " '",tm.d     CLIPPED,"'",
                         " '",tm.e     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr710',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr710_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr710()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr710_w
END FUNCTION
 
FUNCTION axrr710()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680123 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_term    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(300)
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
          l_npp01   LIKE npp_file.npp01,
          l_oma09   LIKE oma_file.oma09,
          l_oma10   LIKE oma_file.oma10,
          l_ooo08   LIKE ooo_file.ooo08d,
          l_ooo09   LIKE ooo_file.ooo09d,
          d_npq07f  LIKE npq_file.npq07f,
          d_npq07   LIKE npq_file.npq07f,
          c_npq07f  LIKE npq_file.npq07f,
          c_npq07   LIKE npq_file.npq07f,
          m_npq07   LIKE npq_file.npq07f,
          m_npq07f  LIKE npq_file.npq07f,
          l_npq07   LIKE npq_file.npq07f,
          l_npq07f  LIKE npq_file.npq07f,
          l_qcye    LIKE npq_file.npq07,
          l_qcyef   LIKE npq_file.npq07,
          l_flag    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_i       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          sr1       RECORD
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE npq_file.npq22
                    END RECORD,
          sr        RECORD
                    npp01    LIKE npp_file.npp01,
                    npp02    LIKE npp_file.npp02,
                    npq03    LIKE npq_file.npq03,
                    aag02    LIKE aag_file.aag02,
                    npq06    LIKE npq_file.npq06,
                    npq07f   LIKE npq_file.npq07f,
                    npq07    LIKE npq_file.npq07,
                    npq21    LIKE npq_file.npq21,
                    npq22    LIKE occ_file.occ18,
                    npq24    LIKE npq_file.npq24,
                    oma09    LIKE oma_file.oma09,
                    oma10    LIKE oma_file.oma10,
                    qcyef    LIKE npq_file.npq07,
                    qcye     LIKE npq_file.npq07
                    END RECORD
 
    CALL cl_del_data(l_table)                       #NO.FUN-7B0026
#    CALL cl_outnam('axrr710') RETURNING l_name     #TQC-640197  #FUN-7B0026
    #-----TQC-630155---------
    IF tm.b = 'N' THEN
       LET g_zaa[38].zaa06='Y'
       LET g_zaa[39].zaa06='Y'
       LET g_zaa[40].zaa06='Y'
       LET g_zaa[41].zaa06='Y'
       LET g_zaa[42].zaa06='Y'
       LET g_zaa[43].zaa06='Y'
       LET g_zaa[44].zaa06='Y'
    ELSE
       LET g_zaa[34].zaa06='Y'
       LET g_zaa[35].zaa06='Y'
       LET g_zaa[36].zaa06='Y'
       LET g_zaa[37].zaa06='Y'
    END IF
    CALL cl_prt_pos_len()
    #-----END TQC-630155-----
 
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
#No.TQC-6B0051 --begin
#   SELECT aaf03 INTO g_company FROM aaf_file
#    WHERE aaf01 = tm.o AND aaf02 = g_rlang
    SELECT zo02 INTO g_company FROM zo_file
     WHERE zo01 = g_rlang
#No.TQC-6B0051  --end
 
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='axrr710'    #FUN-7B0026
 
     IF tm.b = 'Y' THEN
        LET g_aza17 = tm.c
     ELSE
        LET g_aza17 = g_azi01
     END IF
     IF tm.d = '1' THEN
        LET g_d = 'Y'
     ELSE
        LET g_d = 'N'
     END IF
  #  SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01=g_aza17   #No.CHI-6A0004
  #  IF SQLCA.sqlcode THEN         #No.CHI-6A0004
# #     CALL cl_err('azi04',SQLCA.sqlcode,0)   #No.FUN-660116  #No.CHI-6A0004
  #      CALL cl_err3("sel","azi_file",g_aza17,"",SQLCA.sqlcode,"","azi04",0)    #No.FUN-660116  #No.CHI-6A0004
  #   END IF      #No.CHI-6A0004
     LET l_term= "  WHERE nppsys = npqsys AND npp00 = npq00 ",
                 "    AND npp01 = npq01 AND npp011 = npq011 ",
                 "    AND nppsys = 'AR' AND npp011 = 1 ",
                 "    AND npq03 = '",tm.a CLIPPED,"'",
              #  "    AND npp06 = '",g_plant,"'",       #TQC-670076
                 "    AND npp06 = '",g_ooz.ooz02p,"'",  #TQC-670076 
                 "    AND npp07 = '",tm.o,"'",
                 "    AND ",tm.wc CLIPPED
     IF tm.b = "Y" THEN
        LET l_term = l_term CLIPPED," AND npq24 = '",tm.c CLIPPED,"' "
     END IF
     LET l_sql = " SELECT UNIQUE npq21,npq22 ",
                 "   FROM npq_file,npp_file ",l_term CLIPPED
     PREPARE axrr710_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('axrr710_pr1',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
           
     END IF
     DECLARE axrr710_curs1 CURSOR FOR axrr710_pr1
 
     LET l_sql1="SELECT npp01,npp02,npq03,aag02,npq06,SUM(npq07f),",
                "       SUM(npq07),npq21,npq22,npq24,'','',0,0 ",
                "  FROM npp_file,npq_file,aag_file ", l_term CLIPPED,
                "   AND npq03 = aag01 ",
                "   AND aag00 ='",tm.o,"'",   #No.FUN-730073
                "   AND npq21 = ? AND npq22 = ? ",
                "   AND npp02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                " GROUP BY npp01,npp02,npq03,aag02,npq06,npq21,npq22,npq24 ",
                " ORDER BY npq21,npq22,npq03,npp02,npp01,npq06 "
 
     PREPARE axrr710_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
           
     END IF
     DECLARE axrr710_curs CURSOR FOR axrr710_prepare1
 
     LET l_sql1=" SELECT npp01,SUM(npq07f),SUM(npq07) ",
                "   FROM npq_file,npp_file ",l_term CLIPPED,
                "    AND npq21 = ? AND npq06 = ?",
                "    AND YEAR(npp02) = ",YEAR(tm.bdate),
                "    AND MONTH(npp02)= ",MONTH(tm.bdate),
                "    AND npp02 < '",tm.bdate,"'",
                "  GROUP BY npp01 "
     PREPARE axrr710_prepare3 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,0) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
           
     END IF
     DECLARE axrr710_curd CURSOR FOR axrr710_prepare3
 
    #CALL cl_outnam('axrr710') RETURNING l_name     #TQC-640197
#NO.FUN-7B0026--------------start ----mark----
{
     IF tm.b = 'N' THEN   #本幣
        START REPORT axrr710_rep TO l_name
        LET g_pageno = 0
     ELSE                 #原幣
        START REPORT axrr710_rep1 TO l_name
        LET g_pageno = 0
     END IF
}
#NO.FUN-7B0026-----------end----
     FOREACH axrr710_curs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
       END IF
       IF tm.b = 'Y' THEN
          SELECT SUM(ooo08d-ooo08c),SUM(ooo09d-ooo09c)  #前幾期的余額
            INTO l_ooo08,l_ooo09 FROM ooo_file
           WHERE ooo01 = sr1.npq21
             AND ooo03 = tm.a
             AND ooo05 = g_aza17
             AND ooo06 = YEAR(tm.bdate)
             AND ooo07 < MONTH(tm.bdate)
           # AND ooo10 = g_plant       #TQC-670076
             AND ooo10 = g_ooz.ooz02p  #TQC-670076
             AND ooo11 = tm.o
       ELSE
          SELECT SUM(ooo09d-ooo09c)  #前幾期的余額
            INTO l_ooo09 FROM ooo_file
           WHERE ooo01 = sr1.npq21
             AND ooo03 = tm.a
             AND ooo06 = YEAR(tm.bdate)
             AND ooo07 < MONTH(tm.bdate)
           # AND ooo10 = g_plant       #TQC-670076
             AND ooo10 = g_ooz.ooz02p  #TQC-670076
             AND ooo11 = tm.o
       END IF
       IF cl_null(l_ooo08) THEN LET l_ooo08 = 0 END IF
       IF cl_null(l_ooo09) THEN LET l_ooo09 = 0 END IF
 
       LET d_npq07f = 0     LET d_npq07 = 0
       #-----MOD-830081---------
       #OPEN axrr710_curd USING sr1.npq21,'1'
       #FOREACH axrr710_curd INTO l_npp01,l_npq07f,l_npq07
       FOREACH axrr710_curd USING sr1.npq21,'1' INTO l_npp01,l_npq07f,l_npq07
       #-----END MOD-830081-----
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
          END IF
          CALL r710_oma(0,l_npp01) RETURNING l_flag,l_oma09,l_oma10
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET d_npq07  = d_npq07  + l_npq07
          LET d_npq07f = d_npq07f + l_npq07f
       END FOREACH
       IF cl_null(d_npq07f) THEN LET d_npq07f = 0 END IF
       IF cl_null(d_npq07)  THEN LET d_npq07  = 0 END IF
 
       LET c_npq07f = 0     LET c_npq07 = 0
       FOREACH axrr710_curd USING sr1.npq21,'2' INTO l_npp01,l_npq07f,l_npq07
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          CALL r710_oma(0,l_npp01) RETURNING l_flag,l_oma09,l_oma10
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET c_npq07  = c_npq07  + l_npq07
          LET c_npq07f = c_npq07f + l_npq07f
       END FOREACH
       IF cl_null(c_npq07f) THEN LET c_npq07f = 0 END IF
       IF cl_null(c_npq07)  THEN LET c_npq07  = 0 END IF
 
       LET l_qcyef = l_ooo08 + d_npq07f - c_npq07f  #原幣期初余額
       LET l_qcye  = l_ooo09 + d_npq07  - c_npq07   #本幣期初余額
 
       IF tm.b = 'Y' THEN
          SELECT SUM(npq07f),SUM(npq07) INTO m_npq07f,m_npq07  #當期異動
            FROM npp_file,npq_file
           WHERE nppsys=npqsys and npp00=npq00
             AND npp01=npq01   AND npp011 = npq011
             AND nppsys = 'AR' AND npp011 = 1
             AND npq03 = tm.a  AND npq24 = g_aza17
             AND npq21 = sr1.npq21
             AND npp02 BETWEEN tm.bdate AND tm.edate
           # AND npp06 = g_plant      #TQC-670076 
             AND npp06 = g_ooz.ooz02p #TQC-670076 
             AND npp07 = tm.o
        ELSE
          SELECT SUM(npq07) INTO m_npq07  #當期異動
            FROM npp_file,npq_file
           WHERE nppsys=npqsys and npp00=npq00
             AND npp01=npq01   AND npp011 = npq011
             AND nppsys = 'AR' AND npp011 = 1
             AND npq03 = tm.a
             AND npq21 = sr1.npq21
             AND npp02 BETWEEN tm.bdate AND tm.edate
           # AND npp06 = g_plant      #TQC-670076 
             AND npp06 = g_ooz.ooz02p #TQC-670076 
             AND npp07 = tm.o
        END IF
        IF cl_null(m_npq07f) THEN LET m_npq07f = 0 END IF
        IF cl_null(m_npq07)  THEN LET m_npq07  = 0 END IF
 
        IF tm.e = 'N' THEN  #期初為零且無異動不打印
           IF tm.b = 'N' AND l_qcye = 0 AND m_npq07 = 0 THEN  #本幣
              CONTINUE FOREACH
           END IF
           IF tm.b = 'Y' AND l_qcyef = 0 AND l_qcye = 0   #外幣
              AND m_npq07f = 0 AND m_npq07 = 0 THEN
                 CONTINUE FOREACH
           END IF
        END IF
        LET g_print = 0
        FOREACH axrr710_curs USING sr1.npq21,sr1.npq22 INTO sr.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          CALL r710_oma(1,sr.npp01) RETURNING l_flag,l_oma09,l_oma10
          IF l_flag = 'N' THEN CONTINUE FOREACH END IF
          LET sr.oma09 = l_oma09
          LET sr.oma10 = l_oma10
          LET sr.qcyef = l_qcyef
          LET sr.qcye  = l_qcye
          #-----MOD-830081---------
          SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file
            WHERE azi01=sr.npq24
          #-----END MOD-830081-----
#NO.FUN-7B0026--------start---mark---
{
          IF tm.b = 'N' THEN   #本幣
             OUTPUT TO REPORT axrr710_rep(sr.*)
          ELSE                 #原幣
             OUTPUT TO REPORT axrr710_rep1(sr.*)
          END IF
          LET g_print = g_print + 1
} 
#NO.FUN-7B0026--------end-------
#NO.FUN-7B0026--------start-----------
          EXECUTE insert_prep USING 
             sr.npp01,sr.npp02,sr.npq03,sr.aag02,sr.npq06,
             sr.npq07f,sr.npq07,sr.npq21,sr.npq22,sr.npq24,
             sr.oma09,sr.oma10,sr.qcyef,sr.qcye,
             t_azi04,t_azi05   #MOD-830081
#NO.FUN-7B0026--------end-------
       END FOREACH
        IF g_print = 0 THEN   #沒有打印過
           IF tm.e = 'N' THEN  #這時存在一種情況是它是有異動的，但是它的異動
              IF tm.b = 'N' AND l_qcyef = 0 THEN  #沒有被打印，即不滿足打印
                 CONTINUE FOREACH                 #條件，則判斷是否要打印
              END IF
              IF tm.b = 'Y' AND l_qcyef = 0 AND l_qcye = 0 THEN
                 CONTINUE FOREACH
              END IF
           END IF
           LET sr.npp01 = ''
           LET sr.npp02 =''
           LET sr.npq03 = tm.a
           SELECT aag02 INTO sr.aag02 FROM aag_file
            WHERE aag01 = tm.a
              AND aag00 = tm.o        #No.FUN-730073  
           LET sr.npq07f =0
           LET sr.npq07 = 0
           LET sr.npq21 = sr1.npq21
           LET sr.npq22 = sr1.npq22
           LET sr.npq24 = g_aza17
           LET sr.oma09 =''
           LET sr.oma10 =''
           LET sr.qcye = l_qcye
           LET sr.qcyef = l_qcyef
           #-----MOD-830081---------
           SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file
             WHERE azi01=sr.npq24
           #-----END MOD-830081-----
#NO.FUN-7B0026-------start----mark------
{           IF tm.b = 'N' THEN   #本幣
              OUTPUT TO REPORT axrr710_rep(sr.*)
           ELSE                 #原幣
              OUTPUT TO REPORT axrr710_rep1(sr.*)
           END IF
}
#NO.FUN-7B0026--------end----------
         END IF  
#NO.FUN-7B0026--------start-----------
          EXECUTE insert_prep USING 
             sr.npp01,sr.npp02,sr.npq03,sr.aag02,sr.npq06,
             sr.npq07f,sr.npq07,sr.npq21,sr.npq22,sr.npq24,
             sr.oma09,sr.oma10,sr.qcyef,sr.qcye,
             t_azi04,t_azi05   #MOD-830081
#NO.FUN-7B0026--------end-------
     END FOREACH
#NO.FUN-7B0026--------start-----mark----- 
{     IF tm.b = 'N' THEN   #本幣
        FINISH REPORT axrr710_rep
     ELSE                 #原幣
        FINISH REPORT axrr710_rep1
     END IF
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
}
#NO.FUN-7B0026------end-----
#NO.FUN-7B0026------start------
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'npq21,npp01')
             RETURNING tm.wc
     END IF
     #LET g_str=tm.wc,";",tm.bdate,";",tm.edate,";",tm.o,";",tm.c,";",g_azi04   #MOD-830081
     LET g_str=tm.wc,";",tm.bdate,";",tm.edate,";",tm.o,";",tm.c,";",g_azi04,";",g_azi05   #MOD-830081
               
     IF tm.b = 'N' THEN 
        CALL cl_prt_cs3('axrr710','axrr710',g_sql,g_str)
     ELSE
        CALL cl_prt_cs3('axrr710','axrr710_1',g_sql,g_str)
     END IF
#NO.FUN-7B0026--------end---
END FUNCTION
 
#NO.FUN-7B0026---------start------mark----
{REPORT axrr710_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
          sr        RECORD
                        npp01    LIKE npp_file.npp01,
                        npp02    LIKE npp_file.npp02,
                        npq03    LIKE npq_file.npq03,
                        aag02    LIKE aag_file.aag02,
                        npq06    LIKE npq_file.npq06,
                        npq07f   LIKE npq_file.npq07f,
                        npq07    LIKE npq_file.npq07,
                        npq21    LIKE npq_file.npq21,
                        npq22    LIKE occ_file.occ18,
                        npq24    LIKE npq_file.npq24,
                        oma09    LIKE oma_file.oma09,
                        oma10    LIKE oma_file.oma10,
                        qcyef    LIKE npq_file.npq07,
                        qcye     LIKE npq_file.npq07
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npq21,sr.npq22,sr.npq03,sr.npp02,sr.npp01,sr.npq06
  FORMAT
   PAGE HEADER
#-----TQC-630155---------
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]    #No.TQC-6B0051 
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-790085
        LET g_pageno = g_pageno + 1
        LET pageno_total = PAGENO USING '<<<',"/pageno"
        PRINT g_head CLIPPED,pageno_total
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051 #TQC-790085 mark
        PRINT COLUMN 01,g_x[11] CLIPPED,
              COLUMN 10,sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED
        PRINT COLUMN 01,g_x[12] CLIPPED,
              COLUMN 10,sr.aag02 CLIPPED,'(',sr.npq03 CLIPPED,')'
        #No.TQC-6B0051 --begin  --mark--
      #  PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
      #        #COLUMN 31,g_x[14] CLIPPED,tm.bdate,'-',tm.edate,                    #FUN-660060 remark
      #        COLUMN (g_len-25)/2+1,g_x[14] CLIPPED,tm.bdate,'-',tm.edate,'  ',  #FUN-660060
      #        COLUMN 62,g_x[26] CLIPPED,tm.o,
      #        COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
         #No.TQC-6B0051 --end    --mark--
        #No.TQC-6B0051 --begin
        PRINT g_x[14] CLIPPED,tm.bdate,'-',tm.edate,'  ',COLUMN 30,g_x[26] CLIPPED, tm.o
        #No.TQC-6B0051 --end
        PRINT g_dash
        PRINT g_x[30],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
        PRINT g_dash1
        LET l_last_sw = 'n'
 
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1]
#      PRINT ' '
#
#      LET g_pageno=g_pageno+1
#      PRINT COLUMN 01,g_x[11] CLIPPED,
#            COLUMN 10,sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED
#      PRINT COLUMN 01,g_x[12] CLIPPED,
#            COLUMN 10,sr.aag02 CLIPPED,'(',sr.npq03 CLIPPED,')'
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#            COLUMN 31,g_x[14] CLIPPED,tm.bdate,'-',tm.edate,
#            COLUMN 62,g_x[26] CLIPPED,tm.o,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
##No.FUN540057--begin
##No.FUN-550071 --start--
#      PRINT COLUMN  1,g_x[15] CLIPPED,
#            COLUMN 28,g_x[29] CLIPPED,
#            COLUMN 56,g_x[16] CLIPPED,
#            COLUMN 99,g_x[17] CLIPPED
#      PRINT '-------- ----------------- -------- ---------------- ',
#            ' ------------------ ------------------ ---- ------------------'
##No.FUN-580010--end
##No.FUN540057--end
##No.FUN-550071 --end--
#      LET l_last_sw ='n'
#-----END TQC-630155-----
 
   BEFORE GROUP OF sr.npq21
     SKIP TO TOP OF PAGE
     LET g_qcye = sr.qcye
     LET g_npq07_l = 0
     LET g_npq07_r = 0
#-----TQC-630155---------    
     PRINT COLUMN g_c[30],g_x[23] CLIPPED;   
     IF sr.qcye > 0 THEN
        PRINT COLUMN g_c[36],g_x[24],   
              COLUMN g_c[37],cl_numfor(sr.qcye,37,g_azi04)
     ELSE
        IF sr.qcye = 0 THEN
          PRINT COLUMN g_c[36],g_x[28],
                COLUMN g_c[37],cl_numfor(sr.qcye,37,g_azi04)
        ELSE
          PRINT COLUMN g_c[36],g_x[27],
                COLUMN g_c[37],cl_numfor(sr.qcye*-1,37,g_azi04)
        END IF
     END IF
 
#     PRINT COLUMN 1,g_x[23] CLIPPED;   
#     IF sr.qcye > 0 THEN
##No.FUN540057--begin
#        PRINT COLUMN 93,g_x[24],     #No.FUN-550071
#              COLUMN 97,cl_numfor(sr.qcye,18,g_azi04)
#     ELSE
#        IF sr.qcye = 0 THEN
#          PRINT COLUMN 93,g_x[28],
#                COLUMN 97,cl_numfor(sr.qcye,18,g_azi04)
#        ELSE
#          PRINT COLUMN 93,g_x[27],
#                COLUMN 97,cl_numfor(sr.qcye*-1,18,g_azi04)
#
##No.FUN540057--end
#        END IF
#     END IF
#-----END TQC-630155-----
 
   ON EVERY ROW
     IF sr.npq07 <> 0 THEN
#No.FUN-550071 --start--
 
#-----TQC-630155--------- 
       PRINT COLUMN g_c[30],sr.npp02,
             COLUMN g_c[31],sr.npp01 CLIPPED,
             COLUMN g_c[32],sr.oma09,
             COLUMN g_c[33],sr.oma10;
        IF sr.npq06 = '1' THEN
          PRINT COLUMN g_c[34],cl_numfor(sr.npq07,34,g_azi04);
           LET g_qcye = g_qcye + sr.npq07
           LET g_npq07_l = g_npq07_l + sr.npq07
        ELSE
           PRINT COLUMN g_c[35],cl_numfor(sr.npq07,35,g_azi04);
           LET g_qcye = g_qcye - sr.npq07
           LET g_npq07_r = g_npq07_r + sr.npq07
        END IF
        IF g_qcye > 0 THEN
           PRINT COLUMN g_c[36],g_x[24],
                 COLUMN g_c[37],cl_numfor(g_qcye,37,g_azi04)
        ELSE
           IF g_qcye = 0 THEN
              PRINT COLUMN g_c[36],g_x[28],
                    COLUMN g_c[37],cl_numfor(g_qcye,37,g_azi04)
           ELSE
              PRINT COLUMN g_c[36],g_x[27],
                    COLUMN g_c[37],cl_numfor(g_qcye*-1,37,g_azi04)
           END IF
        END IF
     END IF
 
#       PRINT COLUMN   1,sr.npp02,
#             COLUMN  10,sr.npp01 CLIPPED,
#             COLUMN  28,sr.oma09,
##No.FUN540057--begin
#             COLUMN  37,sr.oma10;
#        IF sr.npq06 = '1' THEN
#          PRINT COLUMN  54,cl_numfor(sr.npq07,18,g_azi04);
#           LET g_qcye = g_qcye + sr.npq07
#           LET g_npq07_l = g_npq07_l + sr.npq07
#        ELSE
#           PRINT COLUMN  73,cl_numfor(sr.npq07,18,g_azi04);
#           LET g_qcye = g_qcye - sr.npq07
#           LET g_npq07_r = g_npq07_r + sr.npq07
#        END IF
#        IF g_qcye > 0 THEN
#           PRINT COLUMN 93,g_x[24],
#                 COLUMN 97,cl_numfor(g_qcye,18,g_azi04)
#        ELSE
#           IF g_qcye = 0 THEN
#              PRINT COLUMN 93,g_x[28],
#                    COLUMN 97,cl_numfor(g_qcye,18,g_azi04)
#           ELSE
#              PRINT COLUMN 93,g_x[27],
#                    COLUMN 97,cl_numfor(g_qcye*-1,18,g_azi04)
#           END IF
#        END IF
#     END IF
#-----END TQC-630155-----
 
   AFTER GROUP OF sr.npq21
#-----TQC-630155---------
     PRINT COLUMN g_c[30],g_x[25] CLIPPED,
           COLUMN g_c[34],cl_numfor(g_npq07_l,34,g_azi04),
           COLUMN g_c[35],cl_numfor(g_npq07_r,35,g_azi04);
     IF g_qcye > 0 THEN
        PRINT COLUMN g_c[36],g_x[24],
              COLUMN g_c[37],cl_numfor(g_qcye,37,g_azi04)
     ELSE
        IF g_qcye = 0 THEN
           PRINT COLUMN g_c[36],g_x[28],
                 COLUMN g_c[37],cl_numfor(g_qcye,37,g_azi04)
        ELSE
           PRINT COLUMN g_c[36],g_x[27],
                 COLUMN g_c[37],cl_numfor(g_qcye*-1,37,g_azi04)
        END IF
     END IF
 
#     PRINT COLUMN 1,g_x[25] CLIPPED,
#           COLUMN 54,cl_numfor(g_npq07_l,18,g_azi04),
#           COLUMN 68,cl_numfor(g_npq07_r,18,g_azi04);
#     IF g_qcye > 0 THEN
#        PRINT COLUMN 93,g_x[24],
#              COLUMN 97,cl_numfor(g_qcye,18,g_azi04)
#     ELSE
#        IF g_qcye = 0 THEN
#           PRINT COLUMN 93,g_x[28],
#                 COLUMN 97,cl_numfor(g_qcye,18,g_azi04)
#        ELSE
#           PRINT COLUMN 93,g_x[27],
#                 COLUMN 97,cl_numfor(g_qcye*-1,18,g_azi04)
#        END IF
#     END IF
#-----END TQC-630155-----
#No.FUN-550071 --end--
#No.FUN540057--end
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
 
END REPORT
 
REPORT axrr710_rep1(sr)
   DEFINE l_last_sw LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
          sr        RECORD
                        npp01    LIKE npp_file.npp01,
                        npp02    LIKE npp_file.npp02,
                        npq03    LIKE npq_file.npq03,
                        aag02    LIKE aag_file.aag02,
                        npq06    LIKE npq_file.npq06,
                        npq07f   LIKE npq_file.npq07f,
                        npq07    LIKE npq_file.npq07,
                        npq21    LIKE npq_file.npq21,
                        npq22    LIKE occ_file.occ18,
                        npq24    LIKE npq_file.npq24,
                        oma09    LIKE oma_file.oma09,
                        oma10    LIKE oma_file.oma10,
                        qcyef    LIKE npq_file.npq07,
                        qcye     LIKE npq_file.npq07
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.npq21,sr.npq22,sr.npq03,sr.npp02,sr.npp01,sr.npq06
  FORMAT
   PAGE HEADER
#-----TQC-630155---------
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
        LET g_pageno = g_pageno + 1
        LET pageno_total = PAGENO USING '<<<',"/pageno"
        PRINT g_head CLIPPED,pageno_total
        PRINT COLUMN 01,g_x[11] CLIPPED,
              COLUMN 10,sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED
        PRINT COLUMN 01,g_x[12] CLIPPED,
              COLUMN 10,sr.aag02 CLIPPED,'(',sr.npq03 CLIPPED,')'
        PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
              COLUMN 52,g_x[14] CLIPPED,tm.bdate,'-',tm.edate,
              COLUMN 88,g_x[13] CLIPPED,g_aza17 CLIPPED,
              COLUMN 100,g_x[26] CLIPPED,tm.o,
              COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
        PRINT g_dash
        PRINT COLUMN 62,g_x[18] CLIPPED,
              COLUMN 100,g_x[19] CLIPPED,
              COLUMN 143,g_x[20] CLIPPED
        PRINT COLUMN 47,g_x[21],
              COLUMN 85,g_x[21],
              COLUMN 128,g_x[21]
        PRINT g_x[30],g_x[31],g_x[32],g_x[33],g_x[38],g_x[39],g_x[40],g_x[41],
              g_x[42],g_x[43],g_x[44]
        PRINT g_dash1
        LET l_last_sw = 'n'
 
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1]
#      PRINT ' '
#
#      LET g_pageno = g_pageno + 1
#      PRINT COLUMN 01,g_x[11] CLIPPED,
#            COLUMN 10,sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED
#      PRINT COLUMN 01,g_x[12] CLIPPED,
#            COLUMN 10,sr.aag02 CLIPPED,'(',sr.npq03 CLIPPED,')'
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME;
#      PRINT COLUMN 52,g_x[14] CLIPPED,tm.bdate,'-',tm.edate,
#            COLUMN 88,g_x[13] CLIPPED,g_aza17 CLIPPED,
#            COLUMN 100,g_x[26] CLIPPED,tm.o,
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_dash[1,g_len]
##No.FUN-550071 --start--
#      PRINT COLUMN 54,g_x[18] CLIPPED,
#            COLUMN 92,g_x[19] CLIPPED,
#            COLUMN 135,g_x[20] CLIPPED
#      PRINT '                                         ',
#            '             ------------------------------------- ',
#            '-------------------------------------      ',
#            '-------------------------------------'
#      PRINT COLUMN  1,g_x[15] CLIPPED,
##No.FUN540057--begind
#            COLUMN 28,g_x[29] CLIPPED,
#            COLUMN 54,g_x[21] CLIPPED,
#            COLUMN 95,g_x[21] CLIPPED,
#            COLUMN 131,g_x[22] CLIPPED,
#            COLUMN 137,g_x[21] CLIPPED
#      PRINT '-------- ----------------  -------- ----------------  ',
#            '------------------ ------------------ ------------------ ',
#            '------------------  --  ------------------ ------------------'
##No.FUN540057--end
##No.FUN-550071 --end--
#      LET l_last_sw ='n'
#-----END TQC-630155
 
   BEFORE GROUP OF sr.npq21
     SKIP TO TOP OF PAGE
     LET g_qcyef = sr.qcyef
     LET g_qcye  = sr.qcye
     LET g_npq07f_l = 0
     LET g_npq07f_r = 0
     LET g_npq07_l = 0
     LET g_npq07_r = 0
#-----TQC-630155---------
     PRINT COLUMN g_c[30],g_x[23] CLIPPED;
     IF sr.qcyef > 0 THEN
        PRINT COLUMN g_c[42],g_x[24],
              COLUMN g_c[43],cl_numfor(sr.qcyef,43,g_azi04),   #No.CHI-6A0004
              COLUMN g_c[44],cl_numfor(sr.qcye,44,g_azi04)
     ELSE
        IF sr.qcyef = 0 THEN
           PRINT COLUMN g_c[42],g_x[28],
                 COLUMN g_c[43],cl_numfor(sr.qcyef,43,g_azi04),  #No.CHI-6A0004
                 COLUMN g_c[44],cl_numfor(sr.qcye,44,g_azi04)
        ELSE
           PRINT COLUMN g_c[42],g_x[27],
                 COLUMN g_c[43],cl_numfor(sr.qcyef*-1,43,g_azi04),  #No.CHI-6A0004
                 COLUMN g_c[44],cl_numfor(sr.qcye*-1,44,g_azi04)
        END IF
     END IF
#    PRINT COLUMN 1,g_x[23] CLIPPED;
#    IF sr.qcyef > 0 THEN
#       PRINT COLUMN 132,g_x[24],
#             COLUMN 135,cl_numfor(sr.qcyef,18,g_azi04),       #No.CHI-6A0004
#             COLUMN 153,cl_numfor(sr.qcye,18,g_azi04)
#    ELSE
#       IF sr.qcyef = 0 THEN
#          PRINT COLUMN 132,g_x[28],
#                COLUMN 134,cl_numfor(sr.qcyef,18,g_azi04),    #No.CHI-6A0004 
#                COLUMN 153,cl_numfor(sr.qcye,18,g_azi04)
#       ELSE
#          PRINT COLUMN 132,g_x[27],
#                COLUMN 135,cl_numfor(sr.qcyef*-1,18,g_azi04),   #No.CHI-6A0004
#                COLUMN 153,cl_numfor(sr.qcye*-1,18,g_azi04)
#       END IF
#    END IF
#-----END TQC-630155-----
 
   ON EVERY ROW
#-----TQC-630155---------
     IF sr.npq07f <> 0 OR sr.npq07 <> 0 THEN
        PRINT COLUMN g_c[30],sr.npp02,
              COLUMN g_c[31],sr.npp01 CLIPPED,
              COLUMN g_c[32],sr.oma09,
              COLUMN g_c[33],sr.oma10;
        IF sr.npq06 = '1' THEN
           PRINT COLUMN  g_c[38],cl_numfor(sr.npq07f,38,g_azi04),   #No.CHI-6A0004
                 COLUMN  g_c[39],cl_numfor(sr.npq07,39,g_azi04);
           LET g_qcyef = g_qcyef + sr.npq07f
           LET g_qcye  = g_qcye  + sr.npq07
           LET g_npq07f_l = g_npq07f_l + sr.npq07f
           LET g_npq07_l  = g_npq07_l  + sr.npq07
        ELSE
           PRINT COLUMN g_c[40],cl_numfor(sr.npq07f,40,g_azi04),   #No.CHI-6A0004
                 COLUMN g_c[41],cl_numfor(sr.npq07,41,g_azi04);
           LET g_qcyef = g_qcyef - sr.npq07f
           LET g_qcye  = g_qcye - sr.npq07
           LET g_npq07f_r = g_npq07f_r + sr.npq07f
           LET g_npq07_r  = g_npq07_r  + sr.npq07
        END IF
        IF g_qcyef > 0 THEN
           PRINT COLUMN g_c[42],g_x[24],
                 COLUMN g_c[43],cl_numfor(g_qcyef,43,g_azi04),      #No.CHI-6A0004
                 COLUMN g_c[44],cl_numfor(g_qcye,44,g_azi04)
        ELSE
           IF g_qcyef = 0 THEN
              PRINT COLUMN g_c[42],g_x[28],
                    COLUMN g_c[43],cl_numfor(g_qcyef,43,g_azi04),   #No.CHI-6A0004
                    COLUMN g_c[44],cl_numfor(g_qcye,44,g_azi04)
           ELSE
             PRINT COLUMN g_c[42],g_x[27],
                   COLUMN g_c[43],cl_numfor(g_qcyef*-1,43,g_azi04),  #No.CHI-6A0004
                   COLUMN g_c[44],cl_numfor(g_qcye*-1,44,g_azi04)
           END IF
        END IF
     END IF
#    IF sr.npq07f <> 0 OR sr.npq07 <> 0 THEN
#       PRINT COLUMN   1,sr.npp02,
#             COLUMN  10,sr.npp01 CLIPPED,
#             COLUMN  28,sr.oma09,
#             COLUMN  37,sr.oma10;
#       IF sr.npq06 = '1' THEN
#          PRINT COLUMN  54,cl_numfor(sr.npq07f,18,g_azi04),       #No.CHI-6A0004
#                COLUMN  73,cl_numfor(sr.npq07,18,g_azi04);
#          LET g_qcyef = g_qcyef + sr.npq07f
#          LET g_qcye  = g_qcye  + sr.npq07
#          LET g_npq07f_l = g_npq07f_l + sr.npq07f
#          LET g_npq07_l  = g_npq07_l  + sr.npq07
#       ELSE
#          PRINT COLUMN  92,cl_numfor(sr.npq07f,18,g_azi04),       #No.CHI-6A0004
#                COLUMN 111,cl_numfor(sr.npq07,18,g_azi04);
#          LET g_qcyef = g_qcyef - sr.npq07f
#          LET g_qcye  = g_qcye - sr.npq07
#          LET g_npq07f_r = g_npq07f_r + sr.npq07f
#          LET g_npq07_r  = g_npq07_r  + sr.npq07
#       END IF
#       IF g_qcyef > 0 THEN
#          PRINT COLUMN 132,g_x[24],
#                COLUMN 135,cl_numfor(g_qcyef,18,g_azi04),       #No.CHI-6A0004
#                COLUMN 153,cl_numfor(g_qcye,18,g_azi04)
#       ELSE
#          IF g_qcyef = 0 THEN
#             PRINT COLUMN 132,g_x[28],
#                   COLUMN 135,cl_numfor(g_qcyef,18,g_azi04),    #No.CHI-6A0004
#                   COLUMN 153,cl_numfor(g_qcye,18,g_azi04)
#          ELSE
#            PRINT COLUMN 132,g_x[27],
#                  COLUMN 135,cl_numfor(g_qcyef*-1,18,g_azi04),  #No.CHI-6A0004
#                  COLUMN 153,cl_numfor(g_qcye*-1,18,g_azi04)
#          END IF
#       END IF
#    END IF
#-----END TQC-630155---------
 
   AFTER GROUP OF sr.npq21
#-----TQC-630155---------
     PRINT COLUMN g_c[30],g_x[25] CLIPPED,
          COLUMN g_c[38],cl_numfor(g_npq07f_l,38,g_azi04),    #No.CHI-6A0004
          COLUMN g_c[39],cl_numfor(g_npq07_l,39,g_azi04),
          COLUMN g_c[40],cl_numfor(g_npq07f_r,40,g_azi04),
          COLUMN g_c[41],cl_numfor(g_npq07_r,41,g_azi04);     #No.CHI-6A0004
     IF g_qcyef > 0 THEN
        PRINT COLUMN g_c[42],g_x[24],
              COLUMN g_c[43],cl_numfor(g_qcyef,43,g_azi04),   #No.CHI-6A0004 
              COLUMN g_c[44],cl_numfor(g_qcye,44,g_azi04)
     ELSE
        IF g_qcyef = 0 THEN
           PRINT COLUMN g_c[42],g_x[28],
                 COLUMN g_c[43],cl_numfor(g_qcyef,43,g_azi04),  #No.CHI-6A0004
                 COLUMN g_c[44],cl_numfor(g_qcye,44,g_azi04)
        ELSE
           PRINT COLUMN g_c[42],g_x[27],
                 COLUMN g_c[43],cl_numfor(g_qcyef*-1,43,g_azi04),   #No.CHI-6A0004
                 COLUMN g_c[44],cl_numfor(g_qcye*-1,44,g_azi04)
        END IF
     END IF
 
#     PRINT COLUMN 1,g_x[25] CLIPPED,
#          COLUMN 54,cl_numfor(g_npq07f_l,18,g_azi04),         #No.CHI-6A0004
#          COLUMN 73,cl_numfor(g_npq07_l,18,g_azi04),
#          COLUMN 92,cl_numfor(g_npq07f_r,18,g_azi04),         #No.CHI-6A0004
#          COLUMN 105,cl_numfor(g_npq07_r,18,g_azi04);
#     IF g_qcyef > 0 THEN
#        PRINT COLUMN 132,g_x[24],
#              COLUMN 135,cl_numfor(g_qcyef,18,g_azi04),      #No.CHI-6A0004
#              COLUMN 153,cl_numfor(g_qcye,18,g_azi04)
#     ELSE
#        IF g_qcyef = 0 THEN
#           PRINT COLUMN 132,g_x[28],
#                 COLUMN 135,cl_numfor(g_qcyef,18,g_azi04),   #No.CHI-6A0004
#                 COLUMN 153,cl_numfor(g_qcye,18,g_azi04)
#        ELSE
#           PRINT COLUMN 132,g_x[27],
#                 COLUMN 135,cl_numfor(g_qcyef*-1,18,g_azi04), #No.CHI-6A0004
#                 COLUMN 153,cl_numfor(g_qcye*-1,18,g_azi04)
##No.FUN-550071 --end--
##No.FUN540057--end
#        END IF
#     END IF
#-----END TQC-630155
 
   ON LAST ROW
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash[1,g_len]
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE SKIP 2 LINE
      END IF
END REPORT
}
#NO.FUN-7B0026--------end---------
 
FUNCTION r710_oma(p_i,p_oma01)
  DEFINE  l_oma09   LIKE oma_file.oma09,
          l_oma10   LIKE oma_file.oma10,
          l_omaconf LIKE oma_file.omaconf,
          l_ooaconf LIKE ooa_file.ooaconf,
          p_oma01   LIKE oma_file.oma01,
          p_i       LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          l_oox00   LIKE oox_file.oox00,
          l_oox01   LIKE oox_file.oox01,        #No.FUN-680123 SMALLINT
          l_oox02   LIKE oox_file.oox02,        #No.FUN-680123 SMALLINT
          l_i       LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          l_flag    LIKE type_file.chr1         #No.FUN-680123 VARCHAR(01)
  DEFINE  l_cnt     LIKE type_file.num10        #MOD-970139   
   LET l_flag = 'Y'   #it is valid
   LET l_oma09=NULL              #MOD-970139     
   SELECT COUNT(*) INTO l_cnt FROM oma_file WHERE oma01=p_oma01 #MOD-970139                                                         
   IF l_cnt>0 THEN                                              #MOD-970139 
      SELECT oma09,oma10,omaconf INTO l_oma09,l_oma10,l_omaconf
        FROM oma_file
       WHERE oma01 = p_oma01
      IF SQLCA.sqlcode THEN
         SELECT ooaconf INTO l_ooaconf FROM ooa_file
          WHERE ooa01 = p_oma01
         IF SQLCA.sqlcode THEN
            LET l_oox00 = p_oma01[1,2]
            LET l_oox01 = p_oma01[3,6] USING "&&&&"
            LET l_oox02 = p_oma01[7,8] USING "&&"
            SELECT COUNT(*) INTO l_i FROM oox_file
             WHERE oox00 = l_oox00
               AND oox01 = l_oox01
               AND oox02 = l_oox02
            IF l_i = 0 OR tm.d = '2' THEN
               LET l_flag = 'N'
            END IF
         ELSE
            IF p_i = 0 THEN           #before period
               IF l_ooaconf <> 'Y' THEN
                  LET l_flag = 'N'
               END IF
            ELSE                      #middle period
               IF tm.d <> '3' THEN
                  IF l_ooaconf <> g_d THEN
                     LET l_flag = 'N' #it is unvalid
                  END IF
               END IF
            END IF
         END IF
      ELSE
         IF p_i = 0 THEN
            IF l_omaconf <> 'Y' THEN
               LET l_flag = 'N'
            END IF
         ELSE
            IF tm.d <> '3' THEN
               IF l_omaconf <> g_d THEN
                  LET l_flag = 'N'
               END IF
            END IF
         END IF
      END IF
   END IF  #MOD-970139      
   RETURN l_flag,l_oma09,l_oma10
END FUNCTION
#Patch....NO.TQC-610037 <001> #
