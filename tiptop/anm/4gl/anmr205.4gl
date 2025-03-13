# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anmr205.4gl
# Descriptions...: 外幣支票兌現擬表列表
# Input parameter:
# Return code....:
# Date & Author..:
# Modify ........: No.FUN-580010 05/08/02 By will 報表轉XML格式
# Modify ........: No.MOD-5B0308 05/11/23 By kim 報表合計不對齊
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
#
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6B0013 06/11/27 By Smapmin 修改取位方式
# Modify.........: No.FUN-6B0073 06/11/29 By Smapmin 將報表改為XML格式
# Modify.........: No.FUN-780011 07/08/17 By Carrier 報表轉Crystal Report格式
# Modify.........: No.TQC-830031 08/04/03 By Carol lc_cmd 型態改為type_file.chr1000
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-C20358 12/02/21 By Polly 拿除WHENEVER ERROR stop 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
                wc      STRING,                #TQC-630166
                a1      LIKE nmh_file.nmh03,   #No.FUN-680107 VARCHAR(4) #MOD-5B0308 3->4
                a2      LIKE csd_file.csd04,   #No.FUN-680107 DEC(8,4)
                s       LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
                t       LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
                u       LIKE type_file.chr2,   #No.FUN-680107 VARCHAR(2)
                more    LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
              END RECORD,
          l_orderA      ARRAY[2] OF LIKE zaa_file.zaa08, #No.FUN-680107 ARRAY[2] OF VARCHAR(8)
          g_tot_bal     LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6)
          m_cnt_tot     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_dash        LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
 
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose #No.FUN-680107 SMALLINT
#No.FUN-580010  --begin
#DEFINE   g_dash          VARCHAR(400)  #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)    #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
DEFINE    l_table       STRING  #No.FUN-780011
DEFINE    g_str         STRING  #No.FUN-780011
DEFINE    g_sql         STRING  #No.FUN-780011
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
   #No.FUN-780011  --Begin
   LET g_sql = " order1.nmh_file.nmh01,",
               " order2.nmh_file.nmh01,",
               " nmh04.nmh_file.nmh04, ",
               " nmh05.nmh_file.nmh05, ",
               " nmh08.nmh_file.nmh08, ",
               " nmh09.nmh_file.nmh09, ",
               " nmh01.nmh_file.nmh01, ",
               " nmh10.nmh_file.nmh10, ",
               " nmh03.nmh_file.nmh03, ",
               " nmh02.nmh_file.nmh02, ",
               " nmh21.nmh_file.nmh21, ",
               " nmh11.nmh_file.nmh11, ",
               " nmh24.nmh_file.nmh24, ",
               " nmh31.nmh_file.nmh31, ",
               " nmh29.nmh_file.nmh29, ",
               " azi04.azi_file.azi04, ",
               " azi05.azi_file.azi05, ",
               " azi07.azi_file.azi07, ",
               " nmh28.nmh_file.nmh28, ",
               " nmh32.nmh_file.nmh32, ",
               " nmh32n.nmh_file.nmh32,",
               " diff.nmh_file.nmh02,  ",
               " nma02.nma_file.nma02, ",
               " nmh241.nmh_file.nmh24  "
 
   LET l_table = cl_prt_temptable('anmr205',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?                 )  "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #No.FUN-780011  --End
 
  #WHENEVER ERROR stop                     #TQC-C20358 mark
   LET g_pdate  = ARG_VAL(1)               # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a1    = ARG_VAL(8)
   LET tm.a2    = ARG_VAL(9)
   LET tm.s     = ARG_VAL(10)
   LET tm.t     = ARG_VAL(11)
   LET tm.u     = ARG_VAL(12)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
   THEN  CALL anmr205_tm(0,0)              # Input print condition
   ELSE  CALL anmr205()                    # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr205_tm(p_row,p_col)
DEFINE lc_qbe_sn        LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000, #TQC-830031-modify #No.FUN-680107 VARCHAR(500) #No.FUN-570127
          l_jmp_flag    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
   LET p_row = 5 LET p_col = 12
   OPEN WINDOW anmr205_w AT p_row,p_col
        WITH FORM "anm/42f/anmr205"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.s    = '1'
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
   LET tm2.u1   = tm.u[1,1]
   LET tm2.u2   = tm.u[2,2]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON nmh04,nmh05,nmh09,nmh11,nmh01,
                              nmh21,nmh24
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
 
   IF  INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW anmr205_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
       EXIT PROGRAM
          
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a1,tm.a2,
                 tm2.s1,tm2.s2,
                 tm2.t1,tm2.t2,
                 tm2.u1,tm2.u2,
                 tm.more
                 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
       AFTER FIELD a1
             IF tm.a1 is null then
                CALL cl_err('anmr205','anm-040',1)
                next field a1
             end if
 
       AFTER FIELD a2
             IF  tm.a2 is null or tm.a2 = 0  then
                 CALL cl_err('anmr205','anm-067',1)
                 next field a2
             end if
 
       AFTER FIELD more
             IF  tm.more = 'Y'  THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies)
                     RETURNING g_pdate,g_towhom,g_rlang,
                               g_bgjob,g_time,g_prtway,g_copies
             END IF
       AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
         LET tm.u = tm2.u1,tm2.u2
         LET l_jmp_flag = 'N'
 
       ON ACTION controlp
             CASE
                 WHEN INFIELD(a1) #幣別
#                   CALL q_azi(10,3,g_nmd.nmd21)
#                        RETURNING g_nmd.nmd21
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.default1 = tm.a1
                    CALL cl_create_qry() RETURNING tm.a1
#                    CALL FGL_DIALOG_SETBUFFER( tm.a1 )
                    DISPLAY BY NAME tm.a1
                    NEXT FIELD a1
                 OTHERWISE
             END CASE
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW anmr205_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='anmr205'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('anmr205','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a1 CLIPPED,"'",
                         " '",tm.a2 CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('anmr205',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW anmr205_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL anmr205()
   ERROR ""
END WHILE
   CLOSE WINDOW anmr205_w
END FUNCTION
 
FUNCTION anmr205()
   DEFINE l_name        LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0082
          l_sql         LIKE type_file.chr1000,		            # RDSQL STATEMENT #No.FUN-680107 VARCHAR(1200)
          l_chr         LIKE type_file.chr1,                  #No.FUN-680107 VARCHAR(1)
          l_za05        LIKE type_file.chr1000,               #No.FUN-680107 VARCHAR(40)
          l_order       ARRAY[5] OF LIKE nmh_file.nmh01,      #No.FUN-680107 ARRAY[5] OF VARCHAR(10)
          l_nmh24       LIKE nmh_file.nmh24,   #No.FUN-780011
          l_nma02       LIKE nma_file.nma02,   #No.FUN-780011
          sr               RECORD order1 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
                                  order2 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
                                  nmh04 LIKE nmh_file.nmh04,    #
                                  nmh05 LIKE nmh_file.nmh05,
                                  nmh08 LIKE nmh_file.nmh08,
                                  nmh09 LIKE nmh_file.nmh09,
                                  nmh01 LIKE nmh_file.nmh01,
                                  nmh10 LIKE nmh_file.nmh10,
                                  nmh03 LIKE nmh_file.nmh03,
                                  nmh02 LIKE nmh_file.nmh02,
                                  nmh21 LIKE nmh_file.nmh21,
                                  nmh11 LIKE nmh_file.nmh11,
                                  nmh24 LIKE nmh_file.nmh24,
                                  nmh31 LIKE nmh_file.nmh31,
                                  nmh29 LIKE nmh_file.nmh29,
                                  azi04 LIKE azi_file.azi04,
                                  azi05 LIKE azi_file.azi05,
                                  azi07 LIKE azi_file.azi07,   #TQC-6B0013
                                  nmh28 LIKE nmh_file.nmh28,
                                  nmh32 LIKE nmh_file.nmh32,
                                  nmh32n LIKE nmh_file.nmh32,
                                  diff  LIKE nmh_file.nmh02
                        END RECORD
 
     #No.FUN-780011  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-780011  --End
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'anmr205'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
     FOR g_i = 1 TO g_len LET l_dash[g_i,g_i] = '-' END FOR
 
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
 
     LET l_sql = "SELECT '','',",
                 " nmh04, nmh05, nmh08, nmh09, nmh01, nmh10,",
                 " nmh03, nmh02, nmh21, nmh11,",
                 #" nmh24, nmh31, nmh29, azi04, azi05,nmh28,nmh32,",   #TQC-6B0013
                 " nmh24, nmh31, nmh29, azi04, azi05, azi07, nmh28,nmh32,",   #TQC-6B0013
                 "0,0",
"  FROM nmh_file LEFT OUTER JOIN azi_file ON nmh03 = azi01 WHERE nmh38 <> 'X' AND ",tm.wc
     PREPARE anmr205_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('prepare:',SQLCA.sqlcode,1)
                CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
                EXIT PROGRAM
     END IF
     DECLARE anmr205_curs1 CURSOR FOR anmr205_prepare1
 
     #No.FUN-780011  --Begin
     #CALL cl_outnam('anmr205') RETURNING l_name
     #START REPORT anmr205_rep TO l_name
     #LET g_pageno = 0
     #No.FUN-780011  --End  
 
     LET m_cnt_tot = 0
     FOREACH anmr205_curs1 INTO sr.*
       #No.FUN-780011  --Begin
       #FOR g_i = 1 TO 2
       #    CASE WHEN tm.s[g_i,g_i] = '1'
       #              LET l_order[g_i] = sr.nmh04 using 'yyyymmdd'
       #              LET l_orderA[g_i] = g_x[21]
       #         WHEN tm.s[g_i,g_i] = '2'
       #              LET l_order[g_i] = sr.nmh05 using 'yyyymmdd'
       #              LET l_orderA[g_i] = g_x[22]
       #         WHEN tm.s[g_i,g_i] = '3'
       #              LET l_order[g_i] = sr.nmh09 using 'yyyymmdd'
       #              LET l_orderA[g_i] = g_x[23]
       #         WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.nmh11
       #                                  LET l_orderA[g_i] = g_x[24]
       #         WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.nmh01
       #                                  LET l_orderA[g_i] = g_x[25]
       #         WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.nmh21
       #                                  LET l_orderA[g_i] = g_x[26]
       #         WHEN tm.s[g_i,g_i] = '7' LET l_order[g_i] = sr.nmh24
       #                                  LET l_orderA[g_i] = g_x[27]
       #         OTHERWISE LET l_order[g_i] = '-'
       #                   LET l_orderA[g_i] = ' '
       #    END CASE
       #END FOR
       #LET sr.order1 = l_order[1]
       #LET sr.order2 = l_order[2]
       #IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
       #IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
       #No.FUN-780011  --End  
       IF  tm.a1 =  sr.nmh03  THEN
	   LET  sr.nmh32n  =  sr.nmh02 * tm.a2
	   LET  sr.diff    =  sr.nmh32n - sr.nmh32
       ELSE
	   LET  sr.nmh32n  =  0
	   LET  sr.diff    =  0
       END IF
       #No.FUN-780011  --Begin
       CALL s_nmhsta(sr.nmh24) RETURNING l_nmh24
       LET l_nma02 = ''
       SELECT nma02 INTO l_nma02 FROM nma_file
         WHERE nma01 = sr.nmh21
       #OUTPUT TO REPORT anmr205_rep(sr.*)
       EXECUTE insert_prep USING sr.*,l_nma02,l_nmh24
       #No.FUN-780011  --End  
     END FOREACH
 
     #No.FUN-780011  --Begin
     #FINISH REPORT anmr205_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nmh04,nmh05,nmh09,nmh11,nmh01,nmh21,nmh24')
             RETURNING g_str
     END IF
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.u,";",
                 g_azi04,";",g_azi05
     CALL cl_prt_cs3('anmr205','anmr205',g_sql,g_str)
     #No.FUN-780011  --End  
END FUNCTION
 
#No.FUN-780011  --Begin
#REPORT anmr205_rep(sr)
#   DEFINE l_last_sw     LIKE type_file.chr1,                  #No.FUN-680107 VARCHAR(1)
#          l_cnt1        LIKE type_file.num5,                  #合計票據張數 order1 #No.FUN-680107 SMALLINT
#          l_cnt2        LIKE type_file.num5,                  #合計票據張數 order2 #No.FUN-680107 SMALLINT
#          sr               RECORD order1 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
#                                  order2 LIKE nmh_file.nmh01, #No.FUN-680107 VARCHAR(10)
#                                  nmh04 LIKE nmh_file.nmh04,
#                                  nmh05 LIKE nmh_file.nmh05,
#                                  nmh08 LIKE nmh_file.nmh08,
#                                  nmh09 LIKE nmh_file.nmh09,
#                                  nmh01 LIKE nmh_file.nmh01,
#                                  nmh10 LIKE nmh_file.nmh10,
#                                  nmh03 LIKE nmh_file.nmh03,
#                                  nmh02 LIKE nmh_file.nmh02,
#                                  nmh21 LIKE nmh_file.nmh21,
#                                  nmh11 LIKE nmh_file.nmh11,
#                                  nmh24 LIKE nmh_file.nmh24,
#                                  nmh31 LIKE nmh_file.nmh31,
#                                  nmh29 LIKE nmh_file.nmh29,
#                                  azi04 LIKE azi_file.azi04,
#                                  azi05 LIKE azi_file.azi05,
#                                  azi07 LIKE azi_file.azi07,   #TQC-6B0013
#                                  nmh28 LIKE nmh_file.nmh28,
#                                  nmh32  LIKE nmh_file.nmh32,
#                                  nmh32n LIKE nmh_file.nmh32,
#                                  diff   LIKE nmh_file.nmh02
#                        END RECORD,
#          l_nmh24       LIKE nmh_file.nmh24,   #No.FUN-680107 VARCHAR(4)
#          l_amt         LIKE nmh_file.nmh02,   #DECIMAL(15,3),
#          l_amt1        LIKE nmh_file.nmh32,   # DECIMAL(15,3),
#          l_amt2        LIKE nmh_file.nmh32,   # DECIMAL(15,3),
#          l_amt3        LIKE nmh_file.nmh02,   # DECIMAL(15,3),
#          l_chr         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#          l_nma02       LIKE nma_file.nma02    #FUN-6B0073
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.nmh04
#  FORMAT
#   PAGE HEADER
##No.FUN-580010  -begin
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_x[20] CLIPPED, ' ', l_orderA[1] CLIPPED,'-',l_orderA[2]
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],
#            g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
##     PRINT COLUMN 35,tm.a1
##           COLUMN g_c[37],g_aza.aza17,
##           COLUMN g_c[38],g_aza.aza17
#      PRINT g_dash1
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' '
##        THEN PRINT '';
##        ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
##           COLUMN (g_len/2)-10,g_x[20]CLIPPED,' ',
##           l_orderA[1] CLIPPED," - ",l_orderA[2],
##           COLUMN g_len-36,g_x[36] CLIPPED,tm.a1," ",
##		    g_x[37] CLIPPED,tm.a2 using "<<<.<<<<<",
##           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##     PRINT g_dash[1,g_len]
##     PRINT g_x[11],COLUMN 42,g_x[12] clipped,g_x[13] clipped,g_x[14] CLIPPED
##     PRINT COLUMN 44,tm.a1,COLUMN 70,g_aza.aza17, COLUMN 84,g_aza.aza17
##     PRINT "-------- -------- -------- ---------- ",
##           "-------------- ---------- -------------- ",
##           "-------------- ----------- ---------- -----------",
##           " ---- "
##No.FUN-580010  -end
#      LET l_last_sw = 'n'
#
#   BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' AND (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
#
#   ON EVERY ROW
#      CALL s_nmhsta(sr.nmh24) RETURNING l_nmh24
#      #-----FUN-6B0073---------
#      LET l_nma02 = ''
#      SELECT nma02 INTO l_nma02 FROM nma_file
#        WHERE nma01 = sr.nmh21
##No.FUN-580010  - begin
#      PRINT COLUMN g_c[31],sr.nmh04,
#            COLUMN g_c[32],sr.nmh05,
#            COLUMN g_c[33],sr.nmh09,
#            COLUMN g_c[34],sr.nmh31,
#            COLUMN g_c[35],cl_numfor(sr.nmh02,35,sr.azi04) CLIPPED,
#            #COLUMN g_c[36],sr.nmh28 using  '-----.----',   #TQC-6B0013
#            COLUMN g_c[36],cl_numfor(sr.nmh28,36,sr.azi07),   #TQC-6B0013
#            COLUMN g_c[37],cl_numfor(sr.nmh32,37,g_azi04)  CLIPPED,
#            COLUMN g_c[38],cl_numfor(sr.nmh32n,38,g_azi04) CLIPPED,
#            COLUMN g_c[39],cl_numfor(sr.diff ,39,g_azi04)  CLIPPED,
#            COLUMN g_c[40],sr.nmh11,
#            COLUMN g_c[41],sr.nmh21,   
#            COLUMN g_c[42],l_nma02, 
#            COLUMN g_c[43],l_nmh24 CLIPPED
##     PRINT COLUMN 01,sr.nmh04,
##           COLUMN 10,sr.nmh05,
##           COLUMN 19,sr.nmh09,
##           COLUMN 28,sr.nmh31,
##           COLUMN 39,cl_numfor(sr.nmh02,13,sr.azi04) CLIPPED,
##           COLUMN 54,sr.nmh28 using  '-----.----',
##           COLUMN 64,cl_numfor(sr.nmh32,14,g_azi04)  clipped,
##           COLUMN 79,cl_numfor(sr.nmh32n,14,g_azi04) clipped,
##           COLUMN 94,cl_numfor(sr.diff ,11,g_azi04)  clipped,
##           COLUMN 108,sr.nmh11,
##           COLUMN 119,sr.nmh21,
##           COLUMN 130,l_nmh24  clipped
##No.FUN-580010  -end
#      LET l_cnt1 = l_cnt1 + 1
#      LET l_cnt2 = l_cnt2 + 1
#      LET m_cnt_tot = m_cnt_tot + 1
#
#   AFTER GROUP OF sr.order1
#      IF tm.u[1,1] = 'Y' THEN      #跳頁
#      #  LET l_amt = GROUP SUM(sr.nmh02)
#         LET l_amt1= GROUP SUM(sr.nmh32)
#         LET l_amt2= GROUP SUM(sr.nmh32n)
#         LET l_amt3= GROUP SUM(sr.diff)
#         PRINT " "
#         PRINT 3 SPACES,l_orderA[1],"  ",
#               g_x[16] CLIPPED,l_cnt1," ",g_x[15] CLIPPED,
#          #    COLUMN 37,cl_numfor(l_amt,15,sr.azi05) CLIPPED,
##No.FUN-580010  -begin
#               COLUMN g_c[37],cl_numfor(l_amt1,37,g_azi04) CLIPPED,
#               COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi04) CLIPPED,
#               COLUMN g_c[39],cl_numfor(l_amt3,39,g_azi04) CLIPPED
##              COLUMN 63,cl_numfor(l_amt1,15,g_azi04) CLIPPED,
##              COLUMN 78,cl_numfor(l_amt2,14,g_azi04) CLIPPED,
##              COLUMN 94,cl_numfor(l_amt3,11,g_azi04) CLIPPED
##No.FUN-580010  -end
#         PRINT l_dash[1,g_len]
#         LET l_cnt1 = 0
#      ELSE IF tm.t[1,1] = 'Y'      #合計
#              THEN  PRINT l_dash[1,g_len]
#              PRINT COLUMN (g_len-29),l_orderA[1],"  ",
#                    sr.order1, g_x[30] CLIPPED
#           END IF
#      END IF
#
#   AFTER GROUP OF sr.order2
#      IF tm.u[2,2] = 'Y' THEN
#       # LET l_amt = GROUP SUM(sr.nmh02)
#         LET l_amt1= GROUP SUM(sr.nmh32)
#         LET l_amt2= GROUP SUM(sr.nmh32n)
#         LET l_amt3= GROUP SUM(sr.diff)
#         SKIP 1 LINE
#{*}      PRINT 3 SPACES,l_orderA[2],'  ',
#               g_x[16] CLIPPED,l_cnt2,' ',g_x[15] CLIPPED,
#         #     COLUMN 37,cl_numfor(l_amt,15,sr.azi05) CLIPPED,
##No.FUN-580010  -begin
#               COLUMN g_c[37],cl_numfor(l_amt1,37,g_azi04) CLIPPED,
#               COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi04) CLIPPED,
#               COLUMN g_c[39],cl_numfor(l_amt3,39,g_azi04) CLIPPED
##              COLUMN 63,cl_numfor(l_amt1,15,g_azi04) CLIPPED,
##              COLUMN 78,cl_numfor(l_amt2,14,g_azi04) CLIPPED,
##              COLUMN 94,cl_numfor(l_amt3,11,g_azi04) CLIPPED
##No.FUN-580010  -end
#         LET l_cnt2 = 0
#      ELSE IF tm.t[2,2] = 'Y'
#              THEN  PRINT l_dash[1,g_len]
#              PRINT COLUMN (g_len-29),l_orderA[2],"  ",
#                    sr.order2, g_x[30] CLIPPED
#           END IF
#      END IF
#
#   ON LAST ROW
#    # LET l_amt = SUM(sr.nmh02)
#      LET l_amt1= SUM(sr.nmh32)
#      LET l_amt2= SUM(sr.nmh32n)
#      LET l_amt3= SUM(sr.diff)
#      SKIP 1 LINE
#     #PRINT COLUMN 23,g_x[17] CLIPPED,' ', #MOD-5B0308 mark
#      PRINT COLUMN 16,g_x[17] CLIPPED,' ', #MOD-5B0308
#            COLUMN g_c[33],cl_numfor(m_cnt_tot,33,0), #MOD-5B0308
#            COLUMN g_c[34],g_x[15] CLIPPED, #MOD-5B0308
##                     m_cnt_tot USING '####&',' ',g_x[31] CLIPPED,
#                     #m_cnt_tot USING '####&',' ',g_x[15] CLIPPED,  #No.FUN-580010 #MOD-5B0308 mark
#             # COLUMN 37,cl_numfor(l_amt,15,sr.azi05) CLIPPED,
##No.FUN-580010  -begin
#               COLUMN g_c[37],cl_numfor(l_amt1,37,g_azi04) CLIPPED,
#               COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi04) CLIPPED,
#               COLUMN g_c[39],cl_numfor(l_amt3,39,g_azi04) CLIPPED
##              COLUMN 63,cl_numfor(l_amt1,15,g_azi04) CLIPPED,
##              COLUMN 78,cl_numfor(l_amt2,14,g_azi04) CLIPPED,
##              COLUMN 94,cl_numfor(l_amt3,11,g_azi04) CLIPPED
##No.FUN-580010  -begin
#
#      IF  g_zz05 = 'Y' THEN     # (80)-70,140,210,280  /   (132)-120,240,300
#          CALL cl_wcchp(tm.wc,'nmh04,nmh01,nmh21,nmh24')
#               RETURNING tm.wc
#          PRINT g_dash
#          #TQC-630166 Start
#          #IF tm.wc[001,120] > ' ' THEN                      # for 132
#          #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#          #IF tm.wc[121,240] > ' ' THEN
#          #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#          #IF tm.wc[241,300] > ' ' THEN
#          #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#
#          CALL cl_prt_pos_wc(tm.wc)
#          #TQC-630166 End
#      END IF
#      PRINT g_dash
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #FUN-6B0073
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      #-----FUN-6B0073---------
#      #IF g_pageno = 0 OR l_last_sw = 'y'
#      #   THEN PRINT g_dash
#      #        #No.FUN-580010  -begin
#      #        #PRINT g_x[32] clipped,25 spaces,g_x[33] clipped,
#      #              25 spaces,g_x[34] clipped,
#      #        #PRINT g_x[18] clipped,25 spaces,g_x[19] clipped,
#      #              25 spaces,g_x[28] clipped,
#      #        #No.FUN-580010  -end
#      #              COLUMN (g_len-9),g_x[7] CLIPPED
#      #   ELSE SKIP 2 LINE
#      #END IF
#      IF l_last_sw = 'n' THEN 
#          PRINT g_dash
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#          SKIP 2 LINE 
#      END IF
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[18]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[18]
#             PRINT g_memo
#      END IF
#      #-----END FUN-6B0073-----
#END REPORT
#No.FUN-780011  --End  
#Patch....NO.TQC-610036 <> #
