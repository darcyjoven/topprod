# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr120.4gl
# Descriptions...: 應付帳款分類帳列印作業
# Input parameter:
# Return code....:
# Date & Author..: 93/11/30 By Roger
# Modify.........: 97/04/16 By Danny (將apc_file改成npp_file,npq_file)
# Modify.........: No.FUN-540057 05/05/09 By wujie 發票號碼調整
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.FUN-580110 05/08/24 By jackie 報表轉XML格式
# Modify.........: No.MOD-660006 06/06/02 By Smapmin 修正小計
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/13 By baogui金額未對齊
# Modify.........: No.MOD-720026 07/02/06 By Smapmin 修改幣別取位問題
# Modify.........: No.FUN-730064 07/03/28 By atsea 會計科目加帳套
# Modify.........: No.MOD-740023 07/04/10 By Smapmin 如果該資料庫設定的總帳資料庫不同, 會跑不出資料
# Modify.........: No.MOD-780057 07/08/24 By Smapmin 原幣金額列印有錯
# Modify.........: No.FUN-770093 07/10/11 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT,CONSTRUCT段漏了about,help功能
# Modify.........: No.MOD-860074 08/06/06 By chenl   修改字符替換方法。
# Modify.........: No.MOD-970020 09/07/09 By wujie   沒有列出應付衝應收的資料 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:MOD-A30210 10/03/26 By sabrina 增加npq04欄位
# Modify.........: No:CHI-A70005 10/07/12 By Summer 增加aza63判斷使用s_azmm
# Modify.........: No:MOD-A90074 10/09/09 By Dido 增加npq04欄位 
# Modify.........: No:MOD-AA0019 10/10/06 By Dido union 調整為 union all 
# Modify.........: No:MOD-B20132 11/02/23 By Dido 抓取統計資料時,給予npq06邏輯調整 
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數問題
# Modify.........: No.MOD-BC0090 11/12/12 By Polly 修正條件，列印axrt400未拋轉傳票的應付帳款
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      # Where condition  #No.FUN-690028 VARCHAR(600)
              bdate  LIKE type_file.dat,     #No.FUN-690028 DATE
              edate  LIKE type_file.dat,     #No.FUN-690028 DATE
             #modify 030528 NO.A074
             #dig_no   SMALLINT,
              o        LIKE aaa_file.aaa01,    #帳別編號  #No.FUN-670039
              a        LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01)
              b        LIKE azi_file.azi01,        # No.FUN-690028 VARCHAR(04)
              s        LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(2)  
              t,u      LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(2)
              more     LIKE type_file.chr1         # No.FUN-690028 VARCHAR(1)        # Input more condition(Y/N)
              END RECORD
   DEFINE g_bdate,g_edate		LIKE type_file.dat     #No.FUN-690028 DATE
   DEFINE g_orderA ARRAY[3] OF LIKE zaa_file.zaa08           # No.FUN-690028 VARCHAR(20)
   DEFINE g_yy,g_mm			LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE p_plant   LIKE apz_file.apz02p   #MOD-740023
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#     DEFINEl_time    LIKE type_file.chr8         #No.FUN-6A0055
#No.FUN-770093 -- begin --
DEFINE g_sql      STRING
DEFINE l_table    STRING   #MOD-9A0192 mod chr20->STRING
DEFINE g_str      STRING
#No.FUN-770093 -- end --
 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #FUN-BB0047
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   LET tm.t = ARG_VAL(9)
   LET tm.u = ARG_VAL(10)
   LET tm.bdate  = ARG_VAL(11)
   LET tm.edate  = ARG_VAL(12)
#modify 030528 NO.A074
  #LET tm.dig_no= ARG_VAL(13)
   LET tm.o     = ARG_VAL(13)
   LET tm.a     = ARG_VAL(14)
   LET tm.b     = ARG_VAL(15)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(16)
   LET g_rep_clas = ARG_VAL(17)
   LET g_template = ARG_VAL(18)
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#####
   LET p_plant = g_apz.apz02p   #MOD-740023
 
#No.FUN-770093 -- begin --
   LET g_sql = "npq21.npq_file.npq21,",
               "npq22.npq_file.npq22,",
               "npq03.npq_file.npq03,",
               "npq04.npq_file.npq04,",           #MOD-A30210 add
               "aag02.aag_file.aag02,",
               "npp02.npp_file.npp02,",
               "apa44.apa_file.apa44,",
               "npp01.npp_file.npp01,",
               "apa08.apa_file.apa08,",
               "npq07.npq_file.npq07,",
               "npq07f.npq_file.npq07f,",
               "npq06.npq_file.npq06,",
               "date_flag.type_file.chr1"
   LET l_table = cl_prt_temptable('aapr120',g_sql) CLIPPED
   IF l_table = -1 THEN
      EXIT PROGRAM
   END IF
#No.FUN-770093 -- end --
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL aapr120_tm(0,0)        # Input print condition
      ELSE CALL aapr120()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapr120_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_n            LIKE type_file.num5,    #A074  #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(400)
          li_chk_bookno  LIKE type_file.num5     # No.FUN-690028 SMALLINT   #No.FUN-660141
 
   LET p_row = 2 LET p_col = 18
 
   OPEN WINDOW aapr120_w AT p_row,p_col WITH FORM "aap/42f/aapr120"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   #modify 030528 NO.A074
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.bdate = g_today
   LET tm.edate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
  #modify 030528 NO.A074
  #LET tm.dig_no= 0
   LET tm.o     = g_apz.apz02b
   LET tm.a     = 'N'
   ###
   LET tm.s = '13'
   LET tm.t = ' '
   LET tm.u = 'Y'
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
#modify 030528 NO.A074
   DISPLAY BY NAME tm.bdate,tm.edate,tm.o,tm.a
   CONSTRUCT BY NAME tm.wc ON npq21,npq22,npq03
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale
        #CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
 
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
      LET INT_FLAG = 0 CLOSE WINDOW aapr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   DISPLAY BY NAME tm.more         # Condition
 
     INPUT BY NAME tm.bdate,tm.edate,tm.o,tm.a,tm.b,
                   tm2.s1,tm2.s2,
                   tm2.t1,tm2.t2,
                   tm2.u1,tm2.u2,
                   tm.more
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         #No.FUN-580029 --start--
         CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         CALL r120_set_entry()
         CALL r120_set_no_entry()
 
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            CALL cl_err('','aap-099',0) NEXT FIELD bdate
         END IF
         IF cl_null(tm.edate) THEN
            LET tm.edate = tm.bdate
            DISPLAY BY NAME tm.edate
         END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) THEN
            CALL cl_err('','aap-099',0) NEXT FIELD edate
         END IF
         IF tm.edate < tm.bdate THEN
            CALL cl_err('','aap-100',0) NEXT FIELD bdate
         END IF
      #add 030528 NO.A074
      AFTER FIELD o
         IF cl_null(tm.o) THEN
            CALL cl_err('','mfg3018',0)
            NEXT FIELD o
         END IF
             #No.FUN-660141--begin
             #CALL s_check_bookno(tm.o,g_user,g_plant)    #MOD-740023
             CALL s_check_bookno(tm.o,g_user,p_plant)    #MOD-740023
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD o
             END IF 
             #No.FUN-660141--end
         SELECT aaa01 FROM aaa_file WHERE aaa01 = tm.o
         IF SQLCA.sqlcode THEN
#           CALL cl_err(tm.o,'aap-229',0) #No.FUN-660122
            CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)  #No.FUN-660122
            NEXT FIELD o
         END IF
 
      BEFORE FIELD a
         CALL r120_set_entry()
 
      #add 030528 NO.A074
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
         END IF
         CALL r120_set_no_entry()
 
      #add 030528 NO.A074
      AFTER FIELD b
      # IF tm.a = 'Y' THEN
      #    IF cl_null(tm.b) THEN NEXT FIELD b END IF
        IF NOT cl_null(tm.b) THEN
           SELECT COUNT(*) INTO l_n FROM azi_file WHERE azi01 = tm.b
           IF l_n = 0 THEN CALL cl_err(tm.b,'aap-002',0) NEXT FIELD b END IF
           SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01=tm.b   #MOD-720026
        END IF
      # END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#add 030604 NO.A074
      ON ACTION CONTROLP
         CASE WHEN INFIELD(b)     #幣別代號
#                  CALL q_azi(8,5,tm.b) RETURNING tm.b
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azi"
                   LET g_qryparam.default1 = tm.b
                   CALL cl_create_qry() RETURNING tm.b
#                   CALL FGL_DIALOG_SETBUFFER( tm.b )
                   DISPLAY BY NAME tm.b
                   NEXT FIELD b
           END CASE
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.a = 'N' THEN LET tm.b = '' DISPLAY BY NAME tm.b END IF
         IF tm.a = 'Y' AND cl_null(tm.b) THEN NEXT FIELD b END IF
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
         LET tm.t = tm2.t1,tm2.t2
         LET tm.u = tm2.u1,tm2.u2
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aapr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aapr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aapr120','9031',1)
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
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'",
                         " '",tm.u CLIPPED,"'",
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
#modify 030528 NO.A074
                        #"'",tm.dig_no CLIPPED,"'"
                         " '",tm.o     CLIPPED,"'",
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
#####
         CALL cl_cmdat('aapr120',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW aapr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aapr120()
   ERROR ""
END WHILE
   CLOSE WINDOW aapr120_w
END FUNCTION
 
FUNCTION r120_set_entry()
 
   CALL cl_set_comp_entry("b",TRUE)
 
END FUNCTION
 
FUNCTION r120_set_no_entry()
 
   IF tm.a = 'N' THEN
      CALL cl_set_comp_entry("b",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION aapr120()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,          # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_wc      LIKE type_file.chr1000,       #  #No.FUN-690028 VARCHAR(600)
          i         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_chr        LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          sr               RECORD
                    order1,order2 LIKE npq_file.npq03,      # No.FUN-690028 VARCHAR(20),
                    flag  LIKE type_file.chr1,   # 1.期初 2.本期  #No.FUN-690028 VARCHAR(1)
                    #add 030528 NO.A074
                    npp00  LIKE npp_file.npp00,
                    npp01  LIKE npp_file.npp01,   #帳款編號
                    npq03  LIKE npq_file.npq03,   #Act no
                    npq04  LIKE npq_file.npq04,                   #MOD-A30210 add
                    npq06  LIKE npq_file.npq06,   #D/C
                    npq07  LIKE npq_file.npq07,   #AMT
                    #add 030528 NO.A074
                    npq07f LIKE npq_file.npq07f,
                    npq21  LIKE npq_file.npq21,   #付款廠商編號
                    npq22  LIKE npq_file.npq22,   #廠商簡稱
                    npp02  LIKE npp_file.npp02,   #帳款日期
                    apa08  LIKE apa_file.apa08,   #發票號碼
                    apa44  LIKE apa_file.apa44,   #Voucher no
                    apf44  LIKE apf_file.apf44    #Voucher no
                        END RECORD
   DEFINE l_aag02 LIKE aag_file.aag02         #No.FUN-770093
   DEFINE buf     base.StringBuffer           #No.MOD-860074
 
#No.FUN-770093 -- begin --
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"           #MOD-A30210 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
#No.FUN-770093 -- end --
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 
     #modify 030528 NO.A074
{
     SELECT aaf03 INTO g_company FROM aaf_file
      WHERE aaf01 = tm.o AND aaf02 = g_rlang
}
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#     CALL cl_outnam('aapr120') RETURNING l_name    #No.FUN-770093
     LET g_pageno = 0
     #modify 030528 NO.A074
#No.FUN-770093 -- begin --
##No.FUN-580110 --start--
#     IF tm.a='N' THEN
#        LET g_zaa[35].zaa06='N'
#        LET g_zaa[36].zaa06='N'
#        LET g_zaa[37].zaa06='N'
#        LET g_zaa[38].zaa06='Y'
#        LET g_zaa[39].zaa06='Y'
#        LET g_zaa[40].zaa06='Y'
#        LET g_zaa[41].zaa06='Y'
#        LET g_zaa[42].zaa06='Y'
#        LET g_zaa[43].zaa06='Y'
#     ELSE
#        LET g_zaa[35].zaa06='Y'
#        LET g_zaa[36].zaa06='Y'
#        LET g_zaa[37].zaa06='Y'
#        LET g_zaa[38].zaa06='N'
#        LET g_zaa[39].zaa06='N'
#        LET g_zaa[40].zaa06='N'
#        LET g_zaa[41].zaa06='N'
#        LET g_zaa[42].zaa06='N'
#        LET g_zaa[43].zaa06='N'
#     END IF
#No.FUN-770093 -- end --
     CALL cl_prt_pos_len()
 
#     IF tm.a = 'N' THEN
#      START REPORT aapr120_rep TO l_name    #No.FUN-770093
#     ELSE
#        START REPORT aapr120_rep1 TO l_name
#     END IF
     CALL s_yp(tm.bdate) RETURNING g_yy,g_mm
     #CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_bdate,g_edate #CHI-A70005 mark
     #CHI-A70005 add --start--
     IF g_aza.aza63 = 'Y' THEN
        CALL s_azmm(g_yy,g_mm,g_apz.apz02p,g_apz.apz02b) RETURNING g_chr,g_bdate,g_edate
     ELSE   
        CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_bdate,g_edate
     END IF
     #CHI-A70005 add --end--
 
    #No.MOD-860074--begin-- modify
    #LET l_wc = tm.wc
    #FOR i = 1 TO 300
    #   IF l_wc[i,i] != 'n' THEN CONTINUE FOR END IF
    #   IF l_wc[i,i+4] = 'npq21' THEN LET l_wc[i,i+4] = 'apm01' END IF
    #   IF l_wc[i,i+4] = 'npq22' THEN LET l_wc[i,i+4] = 'apm02' END IF
    #   IF l_wc[i,i+4] = 'npq03' THEN LET l_wc[i,i+4] = 'apm00' END IF
    #  #modify 030528 NO.A074
    #  #IF l_wc[i,i+4] = 'npp07' THEN LET l_wc[i,i+4] = 'apm09' END IF
    #END FOR
     LET buf = base.StringBuffer.create()
     CALL buf.append(tm.wc)
     CALL buf.replace("npq21","apm01",0)
     CALL buf.replace("npq22","apm02",0)
     CALL buf.replace("npq03","apm00",0)
     LET l_wc = buf.toString()
    #No.MOD-860074---end--- modify
     #modify 030528 NO.A074
     LET l_sql = "SELECT apm01,apm02,apm00,SUM(apm06-apm07),",
                 "       SUM(apm06f-apm07f) ",
                 "  FROM apm_file",
                 " WHERE ",l_wc CLIPPED,
                 "   AND apm04=",g_yy," AND apm05<",g_mm,
                 "   AND apm09 = '",tm.o    CLIPPED,"'",
                 #"   AND apm08 = '",g_plant CLIPPED,"'"   #MOD-740023
                 "   AND apm08 = '",p_plant CLIPPED,"'"   #MOD-740023
     IF NOT cl_null(tm.b) THEN
        LET l_sql = l_sql CLIPPED," AND apm11 = '",tm.b,"'"
     END IF
     LET l_sql = l_sql CLIPPED," GROUP BY apm01,apm02,apm00"
 
     PREPARE aapr120_p1 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare1:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM 
     END IF
     DECLARE aapr120_c1 CURSOR FOR aapr120_p1
     INITIALIZE sr.* TO NULL
     LET sr.npq06 = '1'
     LET sr.flag = '1'
     #modify 030528 NO.A074
     FOREACH aapr120_c1 INTO sr.npq21,sr.npq22,sr.npq03,sr.npq07,sr.npq07f
       IF STATUS != 0 THEN CALL cl_err('fore1:',STATUS,1) EXIT FOREACH END IF
       IF cl_null(sr.npq07) THEN LET sr.npq07 = 0 END IF   #MOD-660006
       IF cl_null(sr.npq07f) THEN LET sr.npq07f = 0 END IF   #MOD-660006
       #modify 030528 NO.A074
       IF tm.a = 'N' THEN
          IF sr.npq07 = 0 THEN CONTINUE FOREACH END IF
       ELSE
          IF sr.npq07 = 0 AND sr.npq07f = 0 THEN CONTINUE FOREACH END IF
       END IF
 
       CALL r120_order(sr.npq21,sr.npq22,sr.npq03)
             RETURNING sr.order1,sr.order2
       #modify 030528 NO.A074
#       IF tm.a = 'N' THEN
#No.FUN-770093 -- begin --
#          OUTPUT TO REPORT aapr120_rep(sr.*)
           IF sr.apa44 IS NULL THEN LET sr.apa44 = sr.apf44 END IF
           LET l_aag02 = NULL
           SELECT aag02 INTO l_aag02 FROM aag_file
              WHERE aag01 = sr.npq03 AND aag00 = tm.o
           IF sr.npq07 IS NULL THEN
              LET sr.npq07 = 0
           END IF
           IF sr.npq07f IS NULL THEN
              LET sr.npq07f = 0
           END IF
          #-MOD-B20132-add-
           IF sr.npq07f < 0 THEN
              LET sr.npq06 = '2'
           END IF
          #-MOD-B20132-end-
          #-MOD-B20132-mark-
          #IF sr.npq06 = '2' THEN
          #   LET sr.npq07 = sr.npq07 * -1
          #   LET sr.npq07f = sr.npq07f * -1
          #END IF
          #-MOD-B20132-end-
          #EXECUTE insert_prep USING sr.npq21,sr.npq22,sr.npq03,l_aag02,sr.npp02,sr.apa44,                #MOD-A90074 mark
           EXECUTE insert_prep USING sr.npq21,sr.npq22,sr.npq03,sr.npq04,l_aag02,sr.npp02,sr.apa44,       #MOD-A90074 
                                     sr.npp01,sr.apa08,sr.npq07,sr.npq07f,sr.npq06,sr.flag
           IF STATUS THEN
              CALL cl_err("execute insert_prep:",STATUS,1)
              EXIT FOREACH
           END IF
#No.FUN-770093 -- end --
#       ELSE
#          OUTPUT TO REPORT aapr120_rep1(sr.*)
#       END IF
     END FOREACH
 
#modify 030523 NO.A074
     LET l_sql = "SELECT '','','',npp00,npp01,npq03,npq04,npq06,npq07,npq07f,",      #MOD-A30210 add npq04
                 "       npq21,npq22,npp02,'','',''",
                 "  FROM npp_file, npq_file",
                 " WHERE npq01  = npp01 ",
                 "   AND nppsys = 'AP'",
                 "   AND nppsys = npqsys",
                 "   AND npp011 = npq011",
                 "   AND npp02 >= '",g_bdate ,"'",
                 "   AND npp02 <= '",tm.edate,"'",
                 #"   AND npp06  = '",g_plant ,"'",   #MOD-740023
                 "   AND npp06  = '",p_plant ,"'",   #MOD-740023
                 "   AND npp07  = '",tm.o,"'",
                 "   AND ",tm.wc CLIPPED
     IF NOT cl_null(tm.b) THEN
        LET l_sql = l_sql CLIPPED," AND npq24 = '",tm.b,"'"
     END IF
 
#No.MOD-970020 --begin                                                          
     LET l_sql = l_sql,                                                         
                #" union ",       #MOD-AA0019 mark      
                 " UNION ALL ",   #MOD-AA0019 
                 " SELECT '','','',npp00,npp01,npq03,npq04,npq06,npq07,npq07f,",             #MOD-A30210 add npq04     
                 "       npq21,npq22,npp02,'','',''",                           
                 "  FROM npp_file, npq_file",                                   
                 " WHERE npq01  = npp01 ",                                      
                 "   AND nppsys = 'AR'",                                        
                 "   AND nppsys = npqsys",                                      
                 "   AND npp011 = npq011",                                      
                 "   AND npp02 >= '",g_bdate ,"'",                              
                 "   AND npp02 <= '",tm.edate,"'",                              
                #"   AND npp06  = '",g_plant ,"'",     #MOD-BC0090 mark
                #"   AND npp07  = '",tm.o,"'",         #MOD-BC0090 mark
                 "   AND ",tm.wc CLIPPED,                                       
                #"   AND npq23 in (select apg04 from apg_file)"                                               #MOD-BC0090 mark
                 "   AND (npq23 in (SELECT apg04 FROM apg_file) OR npq23 in (SELECT aph04 FROM aph_file))",   #MOD-BC0090 add
                 "   AND nppglno IS NULL "                                                                    #MOD-BC0090 add
     IF NOT cl_null(tm.b) THEN                                                  
        LET l_sql = l_sql CLIPPED," AND npq24 = '",tm.b,"'"                     
     END IF                                                                     
#No.MOD-970020 --end 
 
     PREPARE aapr120_p2 FROM l_sql
     IF STATUS != 0 THEN CALL cl_err('prepare2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
        EXIT PROGRAM 
     END IF
     DECLARE aapr120_c2 CURSOR FOR aapr120_p2
     FOREACH aapr120_c2 INTO sr.*
       IF STATUS != 0 THEN CALL cl_err('fore2:',STATUS,1) 
          EXIT FOREACH
       END IF
       #add 030528 NO.A074
       IF sr.npp00 != 5 THEN
          SELECT apa08,apa44 INTO sr.apa08,sr.apa44
            FROM apa_file
           WHERE apa01 = sr.npp01 AND apa41 = 'Y' AND apa42 = 'N'
          IF SQLCA.sqlcode THEN
             SELECT apf44 INTO sr.apf44
               FROM apf_file WHERE apf01 = sr.npp01 AND apf41 = 'Y'
             IF STATUS THEN
                CONTINUE FOREACH
             END IF
          END IF
       END IF
 
       CALL r120_order(sr.npq21,sr.npq22,sr.npq03)
             RETURNING sr.order1,sr.order2
       IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
       IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
 
       IF sr.npp02 < tm.bdate
          THEN LET sr.flag = '1'
          ELSE LET sr.flag = '2'
       END IF
#modify 030528 NO.A074
#       IF tm.a = 'N' THEN
#No.FUN-770093 -- begin --
#       OUTPUT TO REPORT aapr120_rep(sr.*)
           IF sr.apa44 IS NULL THEN LET sr.apa44 = sr.apf44 END IF
           LET l_aag02 = NULL
           SELECT aag02 INTO l_aag02 FROM aag_file
              WHERE aag01 = sr.npq03 AND aag00 = tm.o
           IF sr.npq07 IS NULL THEN
              LET sr.npq07 = 0
           END IF
           IF sr.npq07f IS NULL THEN
              LET sr.npq07f = 0
           END IF
           IF sr.npq06 = '2' THEN
              LET sr.npq07 = sr.npq07 * -1
              LET sr.npq07f = sr.npq07f * -1
           END IF
           EXECUTE insert_prep USING sr.npq21,sr.npq22,sr.npq03,sr.npq04,l_aag02,sr.npp02,sr.apa44,     #MOD-A30210 add sr.npq04
                                     sr.npp01,sr.apa08,sr.npq07,sr.npq07f,sr.npq06,sr.flag
          IF STATUS THEN
             CALL cl_err("execute insert_prep:",STATUS,1)
             EXIT FOREACH
          END IF
#No.FUN-770093 -- end --
#       ELSE
#          OUTPUT TO REPORT aapr120_rep1(sr.*)
#       END IF
     END FOREACH
 
#modify 030528 NO.A074
#     IF tm.a = 'N' THEN
#      FINISH REPORT aapr120_rep  #No.FUN-770093
#      ELSE
#        FINISH REPORT aapr120_rep1
#     END IF
#No.FUN-580110 --end--
#No.FUN-770093 -- begin --
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF tm.a='N' THEN
        LET l_name = "aapr120"
     ELSE
        LET l_name = "aapr120_1"
     END IF
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'aaa00,aaa01')
          RETURNING tm.wc
     LET g_str = tm.wc,";",g_zz05,";",g_azi03,";",g_azi04,";",g_azi05,";",t_azi05,";",
                 tm.s[1,1],";",tm.s[2,2],";",tm.t,";",tm.u
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('aapr120',l_name,g_sql,g_str)
#No.FUN-770093 -- end --
  #   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105 MARK
END FUNCTION
 
FUNCTION r120_order(l_npq21,l_npq22,l_npq03)
     DEFINE l_npq21,l_npq22,l_npq03  LIKE npq_file.npq03,      # No.FUN-690028   VARCHAR(20),
#           l_order    ARRAY[5] OF   LIKE faj_file.faj02,      # No.FUN-690028 VARCHAR(10)
            l_order    ARRAY[5] OF   LIKE npq_file.npq03      # No.FUN-690028 VARCHAR(20)     #No.FUN-550030
     FOR g_i = 1 TO 2
         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = l_npq21
                                       LET g_orderA[g_i]= g_x[12]
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = l_npq22
                                       LET g_orderA[g_i]= g_x[15]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = l_npq03
                                       LET g_orderA[g_i]= g_x[13]
              OTHERWISE                LET l_order[g_i] = '-'
                                       LET g_orderA[g_i]= 'xxxx'
         END CASE
     END FOR
     RETURN l_order[1],l_order[2]
END FUNCTION
 
REPORT aapr120_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr               RECORD
                       order1,order2 LIKE npq_file.npq03,      # No.FUN-690028 VARCHAR(20),
                       flag  LIKE type_file.chr1,   # 1.期初 2.本期  #No.FUN-690028 VARCHAR(1)
                       #modify 030528 NO.A074
                       npp00  LIKE npp_file.npp00,
                       npp01  LIKE npp_file.npp01,   #帳款編號
                       npq03  LIKE npq_file.npq03,   #Act no
                       npq06  LIKE npq_file.npq06,   #D/C
                       npq07  LIKE npq_file.npq07,   #AMT
                       npq07f LIKE npq_file.npq07,   #AMT add 030528 NO.A074
                       npq21  LIKE npq_file.npq21,   #付款廠商編號
                       npq22  LIKE npq_file.npq22,   #廠商簡稱
                       npp02  LIKE npp_file.npp02,   #帳款日期
                       apa08  LIKE apa_file.apa08,   #發票號碼
                       apa44  LIKE apa_file.apa44,   #Voucher no
                       apf44  LIKE apf_file.apf44    #Voucher no
                 END RECORD,
#No.FUN-580110 --start--
      l_amt,l_bal   LIKE type_file.num20_6,     # No.FUN-690028 DECIMAL(20,6),
      t_amt,t_bal   LIKE type_file.num20_6,     # No.FUN-690028 DECIMAL(20,6),
      l_d,l_c       LIKE type_file.num20_6,     # No.FUN-690028 DECIMAL(20,6),
      l_tot0,l_tot1,l_tot2       LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
      #l_aag02       VARCHAR(30),           #FUN-660117 remark
      l_aag02       LIKE aag_file.aag02, #FUN-660117
      t_d,t_c,t_tot2  LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
      t_tot0,t_tot1   LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
      l_period      LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),
      l_chr         LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      p_tot1,p_tot2,p_tot3 LIKE type_file.num20_6  #MOD-660006  #No.FUN-690028 DECIMAL(20,6)
 
 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.npq21,sr.npq22,sr.npq03,sr.flag,sr.npp02
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      IF g_towhom IS NULL OR g_towhom = ' '
#         THEN PRINT '';
#         ELSE PRINT 'TO:',g_towhom;
#      END IF
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
       #PRINT g_x[11] CLIPPED,tm.bdate,'-',tm.edate;                      #FUN-660060 remark
       PRINT COLUMN (g_len-25)/2+1,g_x[11] CLIPPED,tm.bdate,'-',tm.edate ,'  ' ; #FUN-660060
       IF tm.a='N' THEN
          PRINT COLUMN 35,g_x[23] CLIPPED,tm.o CLIPPED
       ELSE
          PRINT COLUMN 35,g_c[24] CLIPPED,tm.b CLIPPED,
                COLUMN 48,g_x[23] CLIPPED,tm.o CLIPPED
       END IF
#            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#      PRINT g_x[17],
#No.FUN-550030 start
#            COLUMN 51,g_x[18],
#            COLUMN 97,g_x[19] CLIPPED
#      PRINT '-------- ---------------- ---------------- ----------------',
#            ' ---------------- ---------------- ------------------'
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[44],g_x[45],g_x[46],g_x[47],g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                     g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[48]
      PRINT g_dash1
      LET l_last_sw = 'n'
      IF PAGENO = 1 THEN LET l_tot0 = 0 LET t_tot0 = 0 END IF   #MOD-780057
      IF PAGENO = 1 THEN LET p_tot3 = 0 END IF   #MOD-660006
 
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_tot1 = 0
      LET t_tot1 = 0
      LET p_tot1 = 0    #MOD-660006
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_tot2 = 0
      LET t_tot2 = 0
      LET p_tot2 = 0    #MOD-660006
   BEFORE GROUP OF sr.npq03
      LET l_period = 'N'
      LET l_bal = 0
      LET t_bal = 0
   ON EVERY ROW
      IF sr.flag = '1' THEN
         IF sr.npq06 = '1'
            THEN LET l_bal = l_bal + sr.npq07
                 LET t_bal = t_bal + sr.npq07f
            ELSE LET l_bal = l_bal - sr.npq07
                 LET t_bal = t_bal - sr.npq07f
         END IF
      END IF
      IF sr.flag = '2' THEN
         IF sr.apa44 IS NULL THEN LET sr.apa44 = sr.apf44 END IF
         IF l_period = 'N' THEN
            LET l_aag02 = NULL
            SELECT aag02 INTO l_aag02 
              FROM aag_file 
             WHERE aag01 = sr.npq03
               AND aag00 = tm.o                  #No.FUN-730064                           
#            PRINT g_x[12] CLIPPED,':',sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED,' ',
#                  g_x[13] CLIPPED,':',sr.npq03 CLIPPED,' ',l_aag02 CLIPPED,
            PRINTX name=D1 COLUMN g_c[36],g_x[14] CLIPPED,
                           COLUMN g_c[41],g_x[14] CLIPPED;
            IF l_bal > 0 THEN LET
               l_amt = l_bal
               LET g_chr = 'D'
               LET t_amt = t_bal   #MOD-780057
            ELSE
               LET l_amt = l_bal * -1
               LET g_chr = 'C'
               LET t_amt = t_bal * -1   #MOD-780057
            END IF
            #-----MOD-660006---------
            LET p_tot1 = p_tot1 + l_bal 
            LET p_tot2 = p_tot2 + l_bal 
            #-----END MOD-660006-----
            PRINTX name=D1
                   COLUMN g_c[37],cl_numfor(l_amt,37,g_azi04),
                   COLUMN g_c[42],cl_numfor(t_amt,42,t_azi04),   #MOD-720026   #MOD-780057
                   COLUMN g_c[43],cl_numfor(l_amt,43,g_azi04),   #MOD-780057
                   COLUMN g_c[48],g_chr
            LET l_period = 'Y'
         END IF
      END IF
      IF sr.flag = '2' THEN
         PRINTX name=D1
              COLUMN g_c[44],sr.npq21 CLIPPED,
              COLUMN g_c[45],sr.npq22 CLIPPED,
              COLUMN g_c[46],sr.npq03 CLIPPED,
              COLUMN g_c[47],l_aag02 CLIPPED,
              COLUMN g_c[31],sr.npp02 CLIPPED,
              COLUMN g_c[32],sr.apa44 CLIPPED,
              COLUMN g_c[33],sr.npp01 CLIPPED,
              COLUMN g_c[34],sr.apa08 CLIPPED;
#         PRINT sr.npp02,COLUMN 10,sr.apa44,
#                        COLUMN 27,sr.npp01 CLIPPED,
#                        COLUMN 44,sr.apa08;
               IF sr.npq06 = '1'
                  THEN PRINTX name=D1
                       COLUMN g_c[35],cl_numfor(sr.npq07,35,g_azi04),
                       COLUMN g_c[38],cl_numfor(sr.npq07f,38,t_azi04),   #MOD-720026
                       COLUMN g_c[39],cl_numfor(sr.npq07 ,39,g_azi04);
                       LET l_bal = l_bal + sr.npq07
                       LET t_bal = t_bal + sr.npq07f
                  ELSE PRINTX name=D1
                       COLUMN g_c[36],cl_numfor(sr.npq07,36,g_azi04),
                       COLUMN g_c[40],cl_numfor(sr.npq07f,40,t_azi04),   #MOD-720026
                       COLUMN g_c[41],cl_numfor(sr.npq07 ,41,g_azi04);
                       LET l_bal = l_bal - sr.npq07
                       LET t_bal = t_bal - sr.npq07f
               END IF
               IF l_bal > 0
                  THEN LET l_amt = l_bal      LET g_chr = 'D'
                       LET t_amt = t_bal   #MOD-780057
                  ELSE LET l_amt = l_bal * -1 LET g_chr = 'C'
                       LET t_amt = t_bal * -1   #MOD-780057
               END IF
               PRINTX name=D1
                      COLUMN g_c[37],cl_numfor(l_amt,37,g_azi04),
                      COLUMN g_c[42],cl_numfor(t_amt,42,t_azi04),   #MOD-720026   #MOD-780057
                      COLUMN g_c[43],cl_numfor(l_amt,43,g_azi04),   #MOD-780057
                      COLUMN g_c[48],g_chr
      END IF
 
   AFTER GROUP OF sr.npq03
      IF sr.flag = '1' THEN
            LET l_aag02 = NULL
            SELECT aag02 INTO l_aag02 
              FROM aag_file 
             WHERE aag01 = sr.npq03
               AND aag00 = tm.o                  #No.FUN-730064                           
#            PRINT g_x[12] CLIPPED,':',sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED,' ',
#                  g_x[13] CLIPPED,':',sr.npq03 CLIPPED,' ',l_aag02 CLIPPED,
#                  COLUMN 72,g_x[14] CLIPPED;
            PRINTX name=S1
                 COLUMN g_c[44],sr.npq21 CLIPPED,
                 COLUMN g_c[45],sr.npq22 CLIPPED,
                 COLUMN g_c[46],sr.npq03 CLIPPED,
                 COLUMN g_c[47],l_aag02 CLIPPED,
                 COLUMN g_c[36],g_x[14] CLIPPED;
 
                  IF l_bal > 0
                     THEN LET l_amt = l_bal      LET g_chr = 'D'
                          LET t_amt = t_bal   #MOD-780057
                     ELSE LET l_amt = l_bal * -1 LET g_chr = 'C'
                          LET t_amt = t_bal * -1   #MOD-780057
                  END IF
                  #-----MOD-660006---------
                  LET p_tot1 = p_tot1 + l_bal 
                  LET p_tot2 = p_tot2 + l_bal 
                  #-----END MOD-660006-----
                  PRINTX name=S1
                         COLUMN g_c[37],cl_numfor(l_amt,37,g_azi05),   #MOD-720026
                         COLUMN g_c[42],cl_numfor(t_amt,42,t_azi05),   #MOD-720026   #MOD-780057
                         COLUMN g_c[43],cl_numfor(l_amt,43,g_azi05),   #MOD-720026   #MOD-780057
                         COLUMN g_c[48],g_chr
      ELSE
         LET l_d = GROUP SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET l_c = GROUP SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '2'
         LET t_d = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET t_c = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
 
         PRINTX name=S1
               COLUMN g_c[34],g_x[20] CLIPPED,
               COLUMN g_c[35],cl_numfor(l_d,35,g_azi05) CLIPPED,    #A074   #MOD-720026
               COLUMN g_c[36],cl_numfor(l_c,36,g_azi05) CLIPPED,     #A074   #MOD-720026
               COLUMN g_c[38],cl_numfor(t_d,38,t_azi05) CLIPPED,   #MOD-720026
               COLUMN g_c[39],cl_numfor(l_d,39,g_azi05) CLIPPED,   #MOD-720026
               COLUMN g_c[40],cl_numfor(t_c,40,t_azi05) CLIPPED,   #MOD-720026
               COLUMN g_c[41],cl_numfor(l_c,41,g_azi05) CLIPPED   #MOD-720026
      END IF
      PRINT g_dash2[1,g_len]
#      PRINT '------------------------------------------------------',
#            '----------------------------------------------------------'
      LET l_tot0 = l_tot0 + l_bal
      LET l_tot1 = l_tot1 + l_bal
      LET l_tot2 = l_tot2 + l_bal
      LET t_tot0 = t_tot0 + t_bal
      LET t_tot1 = t_tot1 + t_bal
      LET t_tot2 = t_tot2 + t_bal
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
      LET l_d = GROUP SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET l_c = GROUP SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '2'
      LET t_d = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET t_c = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
      IF p_tot2 < 0 THEN LET p_tot2 = p_tot2 * -1 END IF   #MOD-660006
      PRINTX name=S1
            #-----MOD-660006---------
            #COLUMN g_c[33],sr.order2 CLIPPED,   
            #COLUMN g_c[34],g_orderA[2] CLIPPED,g_x[21] CLIPPED,
            COLUMN g_c[31],sr.order2 CLIPPED,   
            COLUMN g_c[32],g_orderA[2] CLIPPED,g_x[21] CLIPPED,
            COLUMN g_c[33],g_x[9],
           #COLUMN g_c[34],cl_numfor(p_tot2,17,g_azi04),
            COLUMN g_c[34],cl_numfor(p_tot2,34,g_azi05),   #MOD-720026
            #-----END MOD-660006-----
            COLUMN g_c[35],cl_numfor(l_d,35,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[36],cl_numfor(l_c,36,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[38],cl_numfor(t_d,38,t_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[39],cl_numfor(l_d,39,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[40],cl_numfor(t_c,40,t_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[41],cl_numfor(l_c,41,g_azi05) CLIPPED;   #MOD-720026
               IF l_tot2 > 0
                  THEN LET l_amt = l_tot2      LET g_chr = 'D'
                       LET t_amt = t_tot2   #MOD-780057
                  ELSE LET l_amt = l_tot2 * -1 LET g_chr = 'C'   #MOD-780057
                       LET t_amt = t_tot2 * -1   #MOD-780057
               END IF
               PRINTX name=S1
                    COLUMN g_c[37],cl_numfor(l_amt,37,g_azi05),     #MOD-720026
                    COLUMN g_c[42],cl_numfor(t_amt,42,t_azi05),     #MOD-720026   #MOD-780057
                    COLUMN g_c[43],cl_numfor(l_amt,43,g_azi05),     #MOD-720026   #MOD-780057
                    COLUMN g_c[48],g_chr
      PRINT g_dash2[1,g_len]
#      PRINT '------------------------------------------------',
#            '----------------------------------------------------------------'
      END IF
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
      LET l_d = GROUP SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET l_c = GROUP SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '2'
      LET t_d = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET t_c = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
      LET p_tot3 = p_tot3 + p_tot1   #MOD-660006
      IF p_tot1 < 0 THEN LET p_tot1 = p_tot1 * -1 END IF   #MOD-660006
 
      PRINTX name=S1
            #-----MOD-660006---------
            #COLUMN g_c[33],sr.order2 CLIPPED,   
            #COLUMN g_c[34],g_orderA[1] CLIPPED,g_x[21] CLIPPED,
            COLUMN g_c[31],sr.order1 CLIPPED,  
            COLUMN g_c[32],g_orderA[1] CLIPPED,g_x[21] CLIPPED,
            COLUMN g_c[33],g_x[9],
         #  COLUMN g_c[34],cl_numfor(p_tot1,17,g_azi04),
            COLUMN g_c[34],cl_numfor(p_tot1,34,g_azi05),   #MOD-720026
            #-----END MOD-660006-----
            COLUMN g_c[35],cl_numfor(l_d,35,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[36],cl_numfor(l_c,36,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[38],cl_numfor(t_d,38,t_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[39],cl_numfor(l_d,39,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[40],cl_numfor(t_c,40,t_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[41],cl_numfor(l_c,41,g_azi05) CLIPPED;   #MOD-720026
               #-----MOD-660006---------
               #IF l_tot2 > 0   
               #   THEN LET l_amt = l_tot2      LET g_chr = 'D' 
               #        LET t_amt = l_tot2  
               #   ELSE LET l_amt = t_tot2 * -1 LET g_chr = 'C'   
               #        LET t_amt = l_tot2 * -1  
               #END IF
               IF l_tot1 > 0   
                  THEN LET l_amt = l_tot1      LET g_chr = 'D' 
                       LET t_amt = t_tot1     #MOD-780057
                  ELSE LET l_amt = l_tot1 * -1 LET g_chr = 'C'      #MOD-780057
                       LET t_amt = t_tot1 * -1     #MOD-780057
               END IF
               #-----END MOD-660006-----
               PRINTX name=S1
                    COLUMN g_c[37],cl_numfor(l_amt,37,g_azi05),   #MOD-720026
                    COLUMN g_c[42],cl_numfor(t_amt,42,t_azi05),   #MOD-720026   #MOD-780057
                    COLUMN g_c[43],cl_numfor(l_amt,43,g_azi05),   #MOD-720026   #MOD-780057
                    COLUMN g_c[48],g_chr
      PRINT g_dash2[1,g_len]
      END IF
 
   ON LAST ROW
      LET l_d = SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET l_c = SUM(sr.npq07) WHERE sr.flag = '2' AND sr.npq06 = '2'
      LET t_d = SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET t_c = SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
      IF p_tot3 < 0 THEN LET p_tot3 = p_tot3 * -1 END IF   #MOD-660006
      PRINTX name=S1
            #-----MOD-660006---------
            #COLUMN g_c[34],g_x[21] CLIPPED,
            COLUMN g_c[32],g_x[21] CLIPPED,
            COLUMN g_c[33],g_x[9] CLIPPED,                  #TQC-6A0088 加CLIPPED
     #      COLUMN g_c[34],cl_numfor(p_tot3,17,g_azi04) CLIPPED,  
            COLUMN g_c[34],cl_numfor(p_tot3,34,g_azi05) CLIPPED,       #TQC-6A0088   #MOD-720026
            #-----END MOD-660006-----
            COLUMN g_c[35],cl_numfor(l_d,35,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[36],cl_numfor(l_c,36,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[38],cl_numfor(t_d,38,t_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[39],cl_numfor(l_d,39,g_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[40],cl_numfor(t_c,40,t_azi05) CLIPPED,   #MOD-720026
            COLUMN g_c[41],cl_numfor(l_c,41,g_azi05) CLIPPED;   #MOD-720026
               IF l_tot0 > 0
                  THEN LET l_amt = l_tot0      LET g_chr = 'D'
                       LET t_amt = t_tot0   #MOD-780057
                  #ELSE LET l_amt = t_tot0 * -1 LET g_chr = 'C'   #MOD-660006
                  ELSE LET l_amt = l_tot0 * -1 LET g_chr = 'C'   #MOD-660006
                       LET t_amt = t_tot0 * -1   #MOD-780057
               END IF
               PRINTX name=S1
                    COLUMN g_c[37],cl_numfor(l_amt,37,g_azi05),   #MOD-720026
                    COLUMN g_c[42],cl_numfor(t_amt,42,t_azi05),   #MOD-720026   #MOD-780057
                    COLUMN g_c[43],cl_numfor(l_amt,43,g_azi05),   #MOD-720026   #MOD-780057
                    COLUMN g_c[48],g_chr
      PRINT g_dash2[1,g_len]
#      PRINT COLUMN 44,g_x[22] CLIPPED,
#            COLUMN 61,cl_numfor(l_d,15,g_azi04) CLIPPED,      #A074
#            COLUMN 78,cl_numfor(l_c,15,g_azi04) CLIPPED;      #A074
#               IF l_tot0 > 0
#                  THEN LET l_amt = l_tot0      LET g_chr = 'D'
#                  ELSE LET l_amt = l_tot0 * -1 LET g_chr = 'C'
#               END IF
#               PRINT COLUMN 89,cl_numfor(l_amt,15,g_azi04),' ',g_chr   #A074
#      PRINT '------------------------------------------------',
#            '----------------------------------------------------------------'
#No.FUN-580110 --end--
#No.FUN-550030 end
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
 
{
#add 030528 NO.A074
REPORT aapr120_rep1(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr           RECORD
                       order1,order2 LIKE npq_file.npq03,      # No.FUN-690028 VARCHAR(20),
                       flag   LIKE type_file.chr1,   # 1.期初 2.本期  #No.FUN-690028 VARCHAR(1)
                       npp00  LIKE npp_file.npp00,
                       npp01  LIKE npp_file.npp01,   #帳款編號
                       npq03  LIKE npq_file.npq03,   #Act no
                       npq06  LIKE npq_file.npq06,   #D/C
                       npq07  LIKE npq_file.npq07,   #AMT
                       npq07f LIKE npq_file.npq07,   #AMT
                       npq21  LIKE npq_file.npq21,   #付款廠商編號
                       npq22  LIKE npq_file.npq22,   #廠商簡稱
                       npp02  LIKE npp_file.npp02,   #帳款日期
                       apa08  LIKE apa_file.apa08,   #發票號碼
                       apa44  LIKE apa_file.apa44,   #Voucher no
                       apf44  LIKE apf_file.apf44    #Voucher no
                       END RECORD,
       l_amt,l_bal     LIKE type_file.num20_6, # No.FUN-690028 DECIMAL(20,6),
       t_amt,t_bal     LIKE type_file.num20_6, # No.FUN-690028 DECIMAL(20,6),
       l_d,l_c,l_tot2  LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
       t_d,t_c,t_tot2  LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
       l_tot0,l_tot1   LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
       t_tot0,t_tot1   LIKE type_file.num20_6, #No.FUN-690028 DECIMAL(20,6)
      #l_aag02         VARCHAR(30),             #FUN-660117 remark
       l_aag02         LIKE aag_file.aag02,  #FUN-660117
       l_period        LIKE type_file.chr1,   # No.FUN-690028 VARCHAR(1),
       l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.npq21,sr.npq22,sr.npq03,sr.flag,sr.npp02
  FORMAT
   PAGE HEADER
      PRINT (g_len-FGL_WIDTH(g_company CLIPPED CLIPPED))/2 SPACES,g_company CLIPPED
      IF g_towhom IS NULL OR g_towhom = ' '
         THEN PRINT '';
         ELSE PRINT 'TO:',g_towhom;
      END IF
      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1]
      PRINT ' '
      LET g_pageno = g_pageno + 1
      PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
            COLUMN 54,g_x[11] CLIPPED,tm.bdate,'-',tm.edate,
            COLUMN 82,g_x[24] CLIPPED,tm.b CLIPPED,
            COLUMN 94,g_x[23] CLIPPED,tm.o CLIPPED,
            COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
#No.FUN-550030 start
      PRINT COLUMN  61,g_x[25] CLIPPED,
            COLUMN  89,g_x[26] CLIPPED,
            COLUMN 117,g_x[27] CLIPPED
      PRINT '                                                            ',
            '--------------------------- --------------------------- ',
            '-----------------------------'
      PRINT COLUMN  01,g_x[29] CLIPPED,
            COLUMN  38,g_x[30] CLIPPED,
            COLUMN  61,g_x[28] CLIPPED,
            COLUMN  89,g_x[28] CLIPPED,
            COLUMN 117,g_x[28] CLIPPED
      PRINT '-------- ---------------- ---------------- ---------------- ',
            '------------- ------------- ------------- ',
            '------------- ------------- ---------------'
      LET l_last_sw = 'n'
      IF PAGENO = 1 THEN LET l_tot0 = 0 LET t_tot0 = 0 END IF
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_tot1 = 0
      LET t_tot1 = 0
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
      LET l_tot2 = 0
      LET t_tot2 = 0
   BEFORE GROUP OF sr.npq03
      LET l_period = 'N' LET l_bal = 0 LET t_bal = 0
   ON EVERY ROW
      IF sr.flag = '1' THEN
         IF sr.npq06 = '1'
            THEN LET l_bal = l_bal + sr.npq07
                 LET t_bal = t_bal + sr.npq07f
            ELSE LET l_bal = l_bal - sr.npq07
                 LET t_bal = t_bal - sr.npq07f
         END IF
      END IF
      IF sr.flag = '2' THEN
         IF sr.apa44 IS NULL THEN LET sr.apa44 = sr.apf44 END IF
         IF l_period = 'N' THEN
            LET l_aag02 = NULL
            SELECT aag02 INTO l_aag02 
              FROM aag_file 
             WHERE aag01 = sr.npq03
               AND aag00 = tm.o                  #No.FUN-730064                           
            PRINT g_x[12] CLIPPED,':',sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED,' ',
                  g_x[13] CLIPPED,':',sr.npq03 CLIPPED,' ',l_aag02  CLIPPED,
                  COLUMN 98,g_x[14] CLIPPED;
            IF t_bal > 0
               THEN LET l_amt = t_bal      LET g_chr = 'D'
                    LET t_amt = l_bal
               ELSE LET l_amt = t_bal * -1 LET g_chr = 'C'
                    LET t_amt = l_bal * -1
            END IF
            PRINT COLUMN 117,cl_numfor(l_amt,12,g_azi04),
                  COLUMN 131,cl_numfor(t_amt,12,g_azi04),' ',g_chr
            LET l_period = 'Y'
         END IF
      END IF
      IF sr.flag = '2' THEN
         PRINT sr.npp02,COLUMN 10,sr.apa44,
                        COLUMN 27,sr.npp01 CLIPPED,
                        COLUMN 44,sr.apa08;
         IF sr.npq06 = '1'
            THEN PRINT COLUMN 61,cl_numfor(sr.npq07f,12,g_azi04),
                       COLUMN 75,cl_numfor(sr.npq07 ,12,g_azi04);
                 LET l_bal = l_bal + sr.npq07
                 LET t_bal = t_bal + sr.npq07f
            ELSE PRINT COLUMN 89,cl_numfor(sr.npq07f,12,g_azi04),
                       COLUMN 103,cl_numfor(sr.npq07 ,12,g_azi04);
                 LET l_bal = l_bal - sr.npq07
                 LET t_bal = t_bal - sr.npq07f
         END IF
         IF t_bal > 0
            THEN LET l_amt = t_bal      LET g_chr = 'D'
                 LET t_amt = l_bal
            ELSE LET l_amt = t_bal * -1 LET g_chr = 'C'
                 LET t_amt = l_bal * -1
         END IF
         PRINT COLUMN 117,cl_numfor(l_amt,12,g_azi04),
               COLUMN 131,cl_numfor(t_amt,12,g_azi04),' ',g_chr
      END IF
 
   AFTER GROUP OF sr.npq03
      IF sr.flag = '1' THEN
         LET l_aag02 = NULL
         SELECT aag02 INTO l_aag02 
           FROM aag_file 
          WHERE aag01 = sr.npq03
            AND aag00 = tm.o                  #No.FUN-730064                           
         PRINT g_x[12] CLIPPED,':',sr.npq21 CLIPPED,' ',sr.npq22 CLIPPED,' ',
               g_x[13] CLIPPED,':',sr.npq03 CLIPPED,' ',l_aag02  CLIPPED,
               COLUMN 97,g_x[14] CLIPPED;
         IF t_bal > 0
            THEN LET l_amt = t_bal      LET g_chr = 'D'
                 LET t_amt = l_bal
            ELSE LET l_amt = t_bal * -1 LET g_chr = 'C'
                 LET t_amt = l_bal * -1
         END IF
         PRINT COLUMN 111,cl_numfor(l_amt,12,g_azi04),
               COLUMN 125,cl_numfor(t_amt,12,g_azi04),' ',g_chr
      ELSE
         LET l_d = GROUP SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET l_c = GROUP SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '2'
         LET t_d = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET t_c = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
         PRINT COLUMN 44,g_x[20] CLIPPED,
               COLUMN 61,cl_numfor(t_d,12,g_azi04) CLIPPED,
               COLUMN 75,cl_numfor(l_d,12,g_azi04) CLIPPED,
               COLUMN 89,cl_numfor(t_c,12,g_azi04) CLIPPED,
               COLUMN 103,cl_numfor(l_c,12,g_azi04) CLIPPED
      END IF
      PRINT '-------------------------------------------------------',
            '-------------------------------------------------------',
            '------------------------------------'
      LET l_tot0 = l_tot0 + l_bal
      LET l_tot1 = l_tot1 + l_bal
      LET l_tot2 = l_tot2 + l_bal
      LET t_tot0 = t_tot0 + t_bal
      LET t_tot1 = t_tot1 + t_bal
      LET t_tot2 = t_tot2 + t_bal
 
   AFTER GROUP OF sr.order2
      IF tm.u[2,2] = 'Y' THEN
         LET l_d = GROUP SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET l_c = GROUP SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '2'
         LET t_d = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET t_c = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
         PRINT COLUMN (39-LENGTH(sr.order2)),sr.order2 CLIPPED,
               COLUMN 40,g_orderA[2] CLIPPED,g_x[21] CLIPPED,
               COLUMN 61,cl_numfor(t_d,12,g_azi04) CLIPPED,
               COLUMN 75,cl_numfor(l_d,12,g_azi04) CLIPPED,
               COLUMN 89,cl_numfor(t_c,12,g_azi04) CLIPPED,
               COLUMN 103,cl_numfor(l_c,12,g_azi04) CLIPPED;
         IF t_tot2 > 0
            THEN LET l_amt = t_tot2      LET g_chr = 'D'
                 LET t_amt = l_tot2
            ELSE LET l_amt = t_tot2 * -1 LET g_chr = 'C'
                 LET t_amt = l_tot2 * -1
         END IF
         PRINT COLUMN 117,cl_numfor(l_amt,12,g_azi04),
               COLUMN 131,cl_numfor(t_amt,12,g_azi04),' ',g_chr
         PRINT '-------------------------------------------------------',
               '-------------------------------------------------------',
               '------------------------------------'
      END IF
 
   AFTER GROUP OF sr.order1
      IF tm.u[1,1] = 'Y' THEN
         LET l_d = GROUP SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET l_c = GROUP SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '2'
         LET t_d = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
         LET t_c = GROUP SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
         PRINT COLUMN (39-LENGTH(sr.order1)),sr.order1 CLIPPED,
               COLUMN 40,g_orderA[1] CLIPPED,g_x[21] CLIPPED,
               COLUMN 61,cl_numfor(t_d,12,g_azi04) CLIPPED,
               COLUMN 75,cl_numfor(l_d,12,g_azi04) CLIPPED,
               COLUMN 89,cl_numfor(t_c,12,g_azi04) CLIPPED,
               COLUMN 103,cl_numfor(l_c,12,g_azi04) CLIPPED;
         IF t_tot1 > 0
            THEN LET l_amt = t_tot1      LET g_chr = 'D'
                 LET t_amt = l_tot1
            ELSE LET l_amt = t_tot1 * -1 LET g_chr = 'C'
                 LET t_amt = l_tot1 * -1
         END IF
         PRINT COLUMN 117,cl_numfor(l_amt,12,g_azi04),
               COLUMN 131,cl_numfor(t_amt,12,g_azi04),' ',g_chr
         PRINT '-------------------------------------------------------',
               '-------------------------------------------------------',
               '------------------------------------'
      END IF
 
   ON LAST ROW
      LET l_d = SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET l_c = SUM(sr.npq07)  WHERE sr.flag = '2' AND sr.npq06 = '2'
      LET t_d = SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '1'
      LET t_c = SUM(sr.npq07f) WHERE sr.flag = '2' AND sr.npq06 = '2'
      PRINT COLUMN 44,g_x[22] CLIPPED,
            COLUMN 61,cl_numfor(t_d,12,g_azi04) CLIPPED,
            COLUMN 75,cl_numfor(l_d,12,g_azi04) CLIPPED,
            COLUMN 89,cl_numfor(t_c,12,g_azi04) CLIPPED,
            COLUMN 103,cl_numfor(l_c,12,g_azi04) CLIPPED;
      IF t_tot0 > 0
         THEN LET l_amt = t_tot0      LET g_chr = 'D'
              LET t_amt = l_tot0
         ELSE LET l_amt = t_tot0 * -1 LET g_chr = 'C'
              LET t_amt = l_tot0 * -1
      END IF
      PRINT COLUMN 117,cl_numfor(l_amt,12,g_azi04),
            COLUMN 131,cl_numfor(t_amt,12,g_azi04),' ',g_chr
      PRINT '-------------------------------------------------------',
            '-------------------------------------------------------',
            '------------------------------------'
#No.FUN-550030 end
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash[1,g_len]
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
}
#Patch....NO.TQC-610035 <> #
