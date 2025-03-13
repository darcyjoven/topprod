# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: gapx600.4gl
# Descriptions...: 應付帳款月底重評價資料列印
# Date & Author..: 03/03/12 By Maggie
# Modify.........: No:7952 03/09/01 By Wiky 修改匯率
# Modify.........: No.FUN-550030 05/05/20 By ice 單據編號欄位放大
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: No.TQC-630166 06/03/16 By 整批修改，將g_wc[1,70]改為g_wc.subString(1,......)寫法
# Modify.........: No.TQC-630193 06/03/21 By Smapmin 重新抓取g_len
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: NO.FUN-670107 06/08/24 By flowld voucher型報表轉template1
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-720032 07/04/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-770069 07/07/12 By wujie   報表表頭格式不規範
# Modify.........: No.FUN-7C0034 07/12/25 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:FUN-B80049 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:MOD-BA0023 11/10/09 By Dido 調整抓取取位變數 
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-D40020 12/11/05 By zhangweib CR轉XtraGrid
# Modify.........: No.FUN-D40129 13/05/22 By yangtt 1、添加取位欄位l_n1 2、分組添加oox01欄位
#                                                   3、添加列印條件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
          #wc      VARCHAR(1000),            # Where condition
           wc      STRING,                #TQC-630166       
           b       LIKE type_file.chr1,   #NO FUN-690009 VARCHAR(01)
           more    LIKE type_file.chr1    #NO FUN-690009 VARCHAR(01)  # Input more condition(Y/N)
           END RECORD,
       yy,m1,m2    LIKE type_file.num10,  #NO FUN-690009 INTEGER
       y1,mm       LIKE type_file.num10,  #NO FUN-690009 INTEGER
       g_bookno    LIKE aaa_file.aaa01,	
       g_aaa03     LIKE aaa_file.aaa03,	
       g_aaz64     LIKE aaz_file.aaz64
DEFINE g_i         LIKE type_file.num5    #NO FUN-690009   #count/index for any purpose
#No.FUN-7C0034 -- begin --
DEFINE g_sql       STRING
DEFINE l_table     STRING   #MOD-9A0192 mod chr20->STRING
DEFINE g_str       STRING
#No.FUN-7C0034 -- end --
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF

   #CALL cl_used(g_prog,g_time,1) RETURNING g_time          #FUN-B80049   ADD #FUN-BB0047 mark
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET yy = ARG_VAL(10)   #TQC-610053
   LET m1 = ARG_VAL(11)   #TQC-610053
   LET m2 = ARG_VAL(12)   #TQC-610053
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#No.FUN-7C0034 -- begin --
   LET g_sql = "oox01.oox_file.oox01,",
               "oox02.oox_file.oox02,",
               "oox03.oox_file.oox03,",
              #"oox03v.oox_file.oox03v,",         #No.FUN-D40020   Mark
               "oox03v.type_file.chr20,",         #NO.FUN-D40020   Add
               "oox04.oox_file.oox04,",
               "oox05.oox_file.oox05,",
               "oox07.oox_file.oox07,",
               "oox08.oox_file.oox08,",
               "oox09.oox_file.oox09,",
               "oox10.oox_file.oox10,",
               "azi04.azi_file.azi04,",                                                                                             
               "azi05.azi_file.azi05,",                                                                                             
               "azi07.azi_file.azi07,",   
               "l_n1.type_file.num5"    #FUN-D40129
   LET l_table = cl_prt_temptable('gapx600',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#No.FUN-7C0034 -- end --
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz64
   END IF
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF #使用本國幣別
   SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file WHERE azi01 = g_aaa03         #No.CHI-6A0004
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time            #FUN-BB0047 add
   IF NOT cl_null(tm.wc) THEN
      CALL gapx600()
   ELSE
      CALL gapx600_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
END MAIN
 
FUNCTION gapx600_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009 SMALLINT
       l_cmd          LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 30
   ELSE LET p_row = 4 LET p_col = 14
   END IF
 
   OPEN WINDOW gapx600_w AT p_row,p_col
        WITH FORM "gap/42f/gapx600"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = g_today
   INITIALIZE tm.* TO NULL            # Default condition
   LET yy      = y1
   LET m1      = mm
   LET m2      = mm
   LET tm.b    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oox03,oox03v
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---

     #No.FUN-D40020 ---start---   Add
      ON ACTION controlp
         CASE
            WHEN INFIELD(oox03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oox03"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "oox00 = 'AP'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oox03
               NEXT FIELD oox03
            OTHERWISE EXIT CASE
         END CASE
     #No.FUN-D40020 ---start---   Add
 
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
      LET INT_FLAG = 0
      CLOSE WINDOW gapx600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME yy,m1,m2,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
        IF yy IS NULL THEN
           NEXT FIELD yy
        END IF
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF m1 > 12 OR m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF m1 > 13 OR m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#        IF m1 IS NULL OR m1 <= 0 OR m1 > 13 THEN
#           NEXT FIELD m1
#        END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF m2 > 12 OR m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF m2 > 13 OR m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#        IF m2 IS NULL OR m2 <= 0 OR m2 > 13 THEN
#           NEXT FIELD m2
#        END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD b
      #modify NO.A080 030616
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN NEXT FIELD b END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
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
      LET INT_FLAG = 0
      CLOSE WINDOW gapx600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gapx600'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gapx600','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'",   #TQC-610053
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                         " '",yy CLIPPED,"'"  ,   #TQC-610053
                         " '",m1 CLIPPED,"'"  ,   #TQC-610053
                         " '",m2 CLIPPED,"'"  ,   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gapx600',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gapx600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gapx600()
   ERROR ""
END WHILE
   CLOSE WINDOW gapx600_w
END FUNCTION
 
FUNCTION gapx600()
   DEFINE l_name    LIKE type_file.chr20,    #NO FUN-690009 VARCHAR(20)   # External(Disk) file name
  #       l_time          LIKE type_file.chr8        #No.FUN-6A0097
          l_sql     STRING,  #NO FUN-690009 VARCHAR(1000) #MOD-BA0023 mod char1000 -> STRING
          sr        RECORD
                       oox01   LIKE  oox_file.oox01,
                       oox02   LIKE  oox_file.oox02,
                       oox05   LIKE  oox_file.oox05,
                       oox07   LIKE  oox_file.oox07,
                       oox03v  LIKE  oox_file.oox03v,
                       oox08   LIKE  oox_file.oox08,
                       oox09   LIKE  oox_file.oox09,
                       oox10   LIKE  oox_file.oox10
                    END RECORD,
          sr1       RECORD
                       oox01   LIKE  oox_file.oox01,
                       oox02   LIKE  oox_file.oox02,
                       oox03   LIKE  oox_file.oox03,
                      #oox03v  LIKE  oox_file.oox03v,   #No.FUN-D40020   Mark
                       oox03v  LIKE  type_file.chr20,   #No.FUN-D40020   Add
                       oox04   LIKE  oox_file.oox04,
                       oox05   LIKE  oox_file.oox05,
                       oox07   LIKE  oox_file.oox07,
                       oox08   LIKE  oox_file.oox08,
                       oox09   LIKE  oox_file.oox09,
                       oox10   LIKE  oox_file.oox10,
#No.FUN-7C0034 -- begin --   取對應oox05的幣別                                                                                      
                       azi04   LIKE  azi_file.azi04,                                                                                
                       azi05   LIKE  azi_file.azi05,                                                                                
                       azi07   LIKE  azi_file.azi07                                                                                 
#No.FUN-7C0034 -- end --   
                    END RECORD
   DEFINE l_n1   LIKE type_file.num5   #FUN-D40129
 
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
   #No.FUN-BB0047--mark--End-----
#No.FUN-7C0034 -- begin --
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"    #FUN-D40129 add 1?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
#No.FUN-7C0034 -- end --
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
##No.FUN-7C0034 -- begin --
#   LET l_sql="SELECT oox01,oox02,oox03,oox03v,oox04,oox05,oox07,oox08,oox09,oox10",
#             "  FROM oox_file ",
#             " WHERE oox00 = 'AP' ",
#             "   AND oox01 = ",yy,
#             "   AND oox02 BETWEEN ",m1," AND ",m2,
#             "   AND ",tm.wc CLIPPED,
#             " ORDER BY 1,2,3,5 "
#
#   PREPARE gapx600_prepare1 FROM l_sql
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
#      EXIT PROGRAM
#   END IF
#   DECLARE gapx600_curs1 CURSOR FOR gapx600_prepare1
#
#   LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
#             " WHERE oox00 = 'AP'",
#             "   AND oox01 = ?",
#             "   AND oox02 BETWEEN ",m1," AND ",m2,
#             "   AND ",tm.wc CLIPPED,
#             " GROUP BY oox05",
#             " ORDER BY 1"
#   PREPARE gapx600_prepare3 FROM l_sql
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('prepare3:',SQLCA.sqlcode,1)
#      EXIT PROGRAM
#   END IF
#   DECLARE gapx600_curs3 CURSOR FOR gapx600_prepare3
#
#   LET l_sql="SELECT oox01,oox02,oox03,oox03v,oox04,oox05,oox07,oox08,",
#             "       oox09,oox10 ",
#             "  FROM oox_file ",
#             " WHERE oox00 = 'AP' ",
#             "   AND oox01 = ",yy,
#             "   AND oox02 BETWEEN ",m1," AND ",m2,
#             "   AND ",tm.wc CLIPPED,
#             " ORDER BY 1,2,6,4 "
#
#   PREPARE gapx600_prepare2 FROM l_sql
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('prepare2:',SQLCA.sqlcode,1)
#      EXIT PROGRAM
#   END IF
#   DECLARE gapx600_curs2 CURSOR FOR gapx600_prepare2
#
#   LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
#             " WHERE oox00 = 'AP'",
#             "   AND oox01 = ?",
#             "   AND oox02 = ?",
#             "   AND ",tm.wc CLIPPED,
#             " GROUP BY oox05",
#             " ORDER BY 1"
#   PREPARE gapx600_prepare4 FROM l_sql
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('prepare4:',SQLCA.sqlcode,1)
#      EXIT PROGRAM
#   END IF
#   DECLARE gapx600_curs4 CURSOR FOR gapx600_prepare4
#
#   CALL cl_outnam('gapx600') RETURNING l_name
## NO.FUN-670107 --start--
##     #-----TQC-630195---------
##     IF tm.b = '2' THEN            #明細報表
##        LET g_len = 99
##     ELSE
##        LET g_len = 86
##     END IF
##     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
##     #-----END TQC-630195-----
## NO.FUN-670107 ---end---
#   # NO.FUN-670107 --start--
#   IF tm.b = '1' THEN
#      LET g_zaa[31].zaa06 = "N"
#      LET g_zaa[32].zaa06 = "N"
#      LET g_zaa[33].zaa06 = "N"
#      LET g_zaa[34].zaa06 = "N"
#      LET g_zaa[35].zaa06 = "N"
#      LET g_zaa[36].zaa06 = "Y"
#      LET g_zaa[37].zaa06 = "Y"
#      LET g_zaa[38].zaa06 = "N"
#      LET g_zaa[39].zaa06 = "N"
#      LET g_zaa[40].zaa06 = "N"
#   ELSE
#      LET g_zaa[31].zaa06 = "Y"
#      LET g_zaa[32].zaa06 = "Y"
#      LET g_zaa[33].zaa06 = "N"
#      LET g_zaa[34].zaa06 = "N"
#      LET g_zaa[35].zaa06 = "N"
#      LET g_zaa[36].zaa06 = "N"
#      LET g_zaa[37].zaa06 = "N"
#      LET g_zaa[38].zaa06 = "N"
#      LET g_zaa[39].zaa06 = "N"
#      LET g_zaa[40].zaa06 = "N"
#   END IF
#   CALL cl_prt_pos_len()
#   # NO.FUN-670107 ---end--- 
#
#   IF tm.b = '1' THEN              #統計報表 #modify NO.A080 030616
#      START REPORT gapx600_rep TO l_name
#   ELSE                          #明細報表
#      START REPORT gapx600_rep1 TO l_name
#   END IF
#
#   LET g_pageno     = 0
#   IF tm.b = '1' THEN              #統計報表 #modify NO.A080 030616
#      FOREACH gapx600_curs1 INTO sr.*
#         IF SQLCA.sqlcode != 0 THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         IF sr.oox03v MATCHES '1*' THEN
#            LET sr.oox03v = '1'
#         ELSE
#            LET sr.oox03v = '2'
#         END IF
#         OUTPUT TO REPORT gapx600_rep(sr.*)
#      END FOREACH
#      FINISH REPORT gapx600_rep
#   ELSE                          #明細報表
#      FOREACH gapx600_curs2 INTO sr1.*
#         IF SQLCA.sqlcode != 0 THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#         END IF
#         OUTPUT TO REPORT gapx600_rep1(sr1.*)
#      END FOREACH
#      FINISH REPORT gapx600_rep1
#   END IF
#
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
#END FUNCTION
#
#REPORT gapx600_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1     #NO FUN-690009 VARCHAR(1) 
#   DEFINE g_head1      LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(40)
#   DEFINE l_azi04      LIKE azi_file.azi04     
#   DEFINE l_azi05      LIKE azi_file.azi05    
#   DEFINE l_azi07      LIKE azi_file.azi07     
#   DEFINE sr           RECORD
#                          oox01   LIKE  oox_file.oox01,
#                          oox02   LIKE  oox_file.oox02,
#                          oox05   LIKE  oox_file.oox05,
#                          oox07   LIKE  oox_file.oox07,
#                          oox03v  LIKE  oox_file.oox03v,
#                          oox08   LIKE  oox_file.oox08,
#                          oox09   LIKE  oox_file.oox09,
#                          oox10   LIKE  oox_file.oox10
#                       END RECORD
#   DEFINE gum          RECORD
#                          oox05   LIKE  oox_file.oox05,
#                          oox10   LIKE  oox_file.oox10
#                       END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin  #FUN-580098
#         PAGE LENGTH g_page_line
#  ORDER BY sr.oox01,sr.oox02,sr.oox05,sr.oox03v
#  FORMAT
#   PAGE HEADER
#
## NO.FUN-670107 --start--
##      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##      IF g_towhom IS NULL OR g_towhom = ' ' THEN PRINT '';
##      ELSE PRINT 'TO:',g_towhom;
##      END IF
##      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##      PRINT ' '
##      LET g_pageno = g_pageno +1
##      PRINT g_x[2] CLIPPED,g_pdate,' ',TIME;
##      PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##      PRINT g_dash[1,g_len]
##      PRINT COLUMN 01,g_x[11] CLIPPED,
##            COLUMN 32,g_x[12] CLIPPED,
##            COLUMN 72,g_x[13]
##      PRINT '----  --  ---- ---------- --  ------------------ ------------------',  #No:7952
##            ' ------------------'
#        
##No.TQC-770069--begin
##     PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED  
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     LET pageno_total = PAGENO USING '<<<',"/pageno"
##     PRINT g_head CLIPPED,pageno_total
##    
##     PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2+1,g_x[1]
##     PRINT ' '
#      PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED                                                       
#      PRINT ' '                                                                                                                     
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED 
#      LET g_pageno = g_pageno + 1                                                                                                   
#      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
#      PRINT g_head CLIPPED,pageno_total                                                                                             
##No.TQC-770069--end 
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#      LET l_last_sw ='n'
# 
#   BEFORE GROUP OF sr.oox01
#      PRINT COLUMN 01,sr.oox01 USING '&&&&';
#
#   BEFORE GROUP OF sr.oox02
#      PRINT COLUMN 07,sr.oox02 USING '&&';
#
#   BEFORE GROUP OF sr.oox05
#      SELECT azi04,azi05,azi07 INTO l_azi04,l_azi05,l_azi07 FROM azi_file    
#       WHERE azi01=sr.oox05
#      IF SQLCA.sqlcode THEN
#         LET l_azi04 = t_azi04    #No.CHI-6A0004   
#         LET l_azi05 = t_azi05    #No.CHI-6A0004 
#         LET l_azi07 = t_azi07    #使用本國幣別   #No.CHI-6A0004 
#      END IF
## NO.FUN-670107 --start--
#
##      PRINT COLUMN 11,sr.oox05 CLIPPED,
##            COLUMN 15,cl_numfor(sr.oox07,10,l_azi07); #No:7952
#       PRINT COLUMN  g_c[33],sr.oox05 CLIPPED,
#             COLUMN  g_c[34],cl_numfor(sr.oox07,34,t_azi07);       #No.CHI-6A0004
## NO.FUN-670107 ---end--- 
#   AFTER GROUP OF sr.oox03v
#      IF sr.oox03v = '1' THEN
## NO.FUN-670107 --start--
##        PRINT COLUMN 27,'1*';      #No:7952
#         PRINT COLUMN g_c[35],'1*';
#      ELSE
##        PRINT COLUMN 27,'2*';      #No:7952
#         PRINT COLUMN g_c[35],'2*';
#      END IF
##     PRINT COLUMN 30,cl_numfor(GROUP SUM(sr.oox08),18,l_azi05),
##           COLUMN 49,cl_numfor(GROUP SUM(sr.oox09),18,l_azi05),
##           COLUMN 68,cl_numfor(GROUP SUM(sr.oox10),18,l_azi05)
#
#      PRINT COLUMN g_c[38],cl_numfor(GROUP SUM(sr.oox08),38,l_azi05),  
#            COLUMN g_c[39],cl_numfor(GROUP SUM(sr.oox09),39,l_azi05), 
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)     
# 
#   AFTER GROUP OF sr.oox05
##      PRINT COLUMN 27,'------------------------------------------------------------'
#       PRINT COLUMN g_c[40],g_dash2[1,g_w[40]]
#
#      PRINT COLUMN 16,g_x[20] CLIPPED,
##           COLUMN 68,cl_numfor(GROUP SUM(sr.oox10),18,l_azi05)
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)      
#      PRINT ''
# 
#   AFTER GROUP OF sr.oox02
#      PRINT COLUMN 16,g_x[21] CLIPPED,
##           COLUMN 68,cl_numfor(GROUP SUM(sr.oox10),18,l_azi05)
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)     
#      PRINT ''
#
#   ON LAST ROW
#      PRINT ''
#      PRINT COLUMN 01,g_x[18] CLIPPED;
#      FOREACH gapx600_curs3 USING sr.oox01 INTO gum.*
#         SELECT azi05 INTO l_azi05 FROM azi_file         
#          WHERE azi01=gum.oox05
#         IF SQLCA.sqlcode THEN
#            LET l_azi05 = t_azi05    #使用本國幣別   #No.CHI-6A0004   
#         END IF
##        PRINT COLUMN 11,gum.oox05,
##              COLUMN 68,cl_numfor(gum.oox10,18,l_azi05)
#         PRINT COLUMN g_c[33],gum.oox05,
#               COLUMN g_c[40],cl_numfor(gum.oox10,40,l_azi05)   
#      END FOREACH
## NO.FUN-670107 ---end---
#
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'oox03')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#             #TQC-630166
#	     # IF tm.wc[001,070] > ' ' THEN                      # for 80
#             #    PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             # IF tm.wc[071,140] > ' ' THEN
#             #    PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             # IF tm.wc[141,210] > ' ' THEN
#             #    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             # IF tm.wc[211,280] > ' ' THEN
#             #    PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#             CALL cl_prt_pos_wc(tm.wc)
#             #END TQC-630166
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE SKIP 2 LINE
#      END IF
### FUN-550114
#      PRINT
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[9]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[9]
#             PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
#
#REPORT gapx600_rep1(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1      #NO FUN-690009 VARCHAR(1)
#   DEFINE l_azi04      LIKE azi_file.azi04    
#   DEFINE l_azi05      LIKE azi_file.azi05      
#   DEFINE l_azi07      LIKE azi_file.azi07      
#   DEFINE sr           RECORD
#                         oox01   LIKE  oox_file.oox01,
#                         oox02   LIKE  oox_file.oox02,
#                         oox03   LIKE  oox_file.oox03,
#                         oox03v  LIKE  oox_file.oox03v,
#                         oox04   LIKE  oox_file.oox04,
#                         oox05   LIKE  oox_file.oox05,
#                         oox07   LIKE  oox_file.oox07,
#                         oox08   LIKE  oox_file.oox08,
#                         oox09   LIKE  oox_file.oox09,
#                         oox10   LIKE  oox_file.oox10
#                       END RECORD
#   DEFINE gum          RECORD
#                          oox05   LIKE  oox_file.oox05,
#                          oox10   LIKE  oox_file.oox10
#                       END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.oox01,sr.oox02,sr.oox05,sr.oox03v,sr.oox03
#  FORMAT
#   PAGE HEADER
## NO.FUN-670107 --start--
#
##      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##      IF g_towhom IS NULL OR g_towhom = ' ' THEN PRINT '';
##      ELSE PRINT 'TO:',g_towhom;
##      END IF
##      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##      PRINT (g_len-FGL_WIDTH(g_x[15]))/2 SPACES,g_x[15]
##      PRINT ' '
##      LET g_pageno = g_pageno +1
##      PRINT g_x[16] CLIPPED,sr.oox01 USING '####',' ',
##            g_x[17] CLIPPED,sr.oox02 USING '##';
##      PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
##      PRINT g_dash[1,g_len]
##      PRINT COLUMN 01,g_x[14] CLIPPED,
## #No.FUN-550030 start
##            COLUMN 45,g_x[12] CLIPPED,
##            COLUMN 82,g_x[13]
##      PRINT '---- ---------- --  ---------------------- ------------------',  #No:7952
##            ' ------------------ ------------------'
#     IF sr.oox04 IS NULL OR sr.oox04 = 0 THEN                                                                                      
#        LET g_zaa[37].zaa06 = "Y"                                                                                                    
#     ELSE                                                                                                                           
#       LET g_zaa[37].zaa06 = "N"                                                                                                    
#     END IF
#     CALL cl_prt_pos_len()            
#
#     PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED
#     PRINT ' '
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<',"/pageno"
#       PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN (g_len-FGL_WIDTH(g_x[15]))/2+1,g_x[15]
#       PRINT ' '
# #      LET g_pageno = g_pageno + 1
#       PRINT g_x[16] CLIPPED,sr.oox01 USING '####',' ',
#             g_x[17] CLIPPED,sr.oox02 USING '##'
#       PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],                                                                                
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]  
#      PRINT g_dash1
## NO.FUN-670107 ---end---
#      LET l_last_sw ='n'
# 
#   BEFORE GROUP OF sr.oox02
#      SKIP TO TOP OF PAGE
#
#   BEFORE GROUP OF sr.oox05
#      SELECT azi04,azi05,azi07 INTO l_azi04,l_azi05,l_azi07 FROM azi_file  
#       WHERE azi01=sr.oox05
#      IF SQLCA.sqlcode THEN
#         LET l_azi04 = t_azi04    #No.CHI-6A0004  
#         LET l_azi05 = t_azi05    #No.CHI-6A0004 
#         LET l_azi07 = t_azi07    #使用本國幣別  #No.CHI-6A0004  
#      END IF
#   #No:7952
## NO.FUN-670107 --start--
##      PRINT COLUMN 01,sr.oox05 CLIPPED,
##            COLUMN 05,cl_numfor(sr.oox07,10,l_azi07);
#       PRINT COLUMN g_c[33],sr.oox05 CLIPPED,
#             COLUMN g_c[34],cl_numfor(sr.oox07,34,l_azi07);  
# 
#   BEFORE GROUP OF sr.oox03v
##      PRINT COLUMN 17,sr.oox03v CLIPPED;
#      PRINT COLUMN g_c[35],sr.oox03v CLIPPED;
#   ON EVERY ROW
#      IF sr.oox04 IS NULL  OR sr.oox04 = 0  THEN
##         PRINT COLUMN 21,sr.oox03;
#         PRINT COLUMN g_c[36],sr.oox03;
#      ELSE
##        PRINT COLUMN 21,sr.oox03 CLIPPED,'-',sr.oox04 CLIPPED
#         PRINT COLUMN g_c[36],sr.oox03 CLIPPED,
#               COLUMN g_c[37],sr.oox04 CLIPPED;
#     END IF
##      PRINT COLUMN 43,cl_numfor(sr.oox08,18,l_azi04),
##            COLUMN 62,cl_numfor(sr.oox09,18,l_azi04),
##            COLUMN 81,cl_numfor(sr.oox10,18,l_azi04)
#       PRINT COLUMN g_c[38],cl_numfor(sr.oox08,38,l_azi04),    
#             COLUMN g_c[39],cl_numfor(sr.oox09,39,l_azi04),   
#             COLUMN g_c[40],cl_numfor(sr.oox10,40,l_azi04)     
# 
#   AFTER GROUP OF sr.oox05
##      PRINT COLUMN 17,"----------------------------------------------",
##                      "-------------------------------------"
#       PRINT COLUMN g_c[40],g_dash2[1,g_w[40]]
#
##      PRINT COLUMN 07,g_x[19] CLIPPED,
#       PRINT COLUMN g_c[34],g_x[19] CLIPPED,
##            COLUMN 81,cl_numfor(GROUP SUM(sr.oox10),18,l_azi05)
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05) 
#      PRINT ''
# 
#   AFTER GROUP OF sr.oox02
##      PRINT COLUMN 17,"----------------------------------------------",
##                      "-------------------------------------"
#        PRINT COLUMN g_c[40],g_dash2[1,g_w[40]]                                                                                     
#
##     PRINT COLUMN 02,g_x[21] CLIPPED,
#      PRINT COLUMN g_c[34],g_x[21] CLIPPED,
##            COLUMN 81,cl_numfor(GROUP SUM(sr.oox10),18,l_azi05)
#            COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)   
#      PRINT ''
##      PRINT COLUMN 07,g_x[18] CLIPPED;
#       PRINT COLUMN g_c[34],g_x[18] CLIPPED;
#      FOREACH gapx600_curs4 USING sr.oox01,sr.oox02 INTO gum.*
#         SELECT azi05 INTO l_azi05 FROM azi_file    
#          WHERE azi01=gum.oox05
#         IF SQLCA.sqlcode THEN
#            LET l_azi05 = t_azi05    #使用本國幣別   #No.CHI-6A0004  
#         END IF
##         PRINT COLUMN 17,gum.oox05,
##               COLUMN 81,cl_numfor(gum.oox10,18,l_azi05)
#          PRINT COLUMN g_c[35],gum.oox05,
#                COLUMN g_c[40],cl_numfor(gum.oox10,40,l_azi05)    
## NO.FUN-670107 ---end---
#
##No.FUN-550030 end
#      END FOREACH
#   ##
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'oox03')
#              RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#	     #TQC-630166
#             # IF tm.wc[001,070] > ' ' THEN                      # for 80
#             #    PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#             # IF tm.wc[071,140] > ' ' THEN
#             #    PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#             # IF tm.wc[141,210] > ' ' THEN
#             #    PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#             # IF tm.wc[211,280] > ' ' THEN
#             #    PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#	      CALL cl_prt_pos_wc(tm.wc)
#             #END TQC-630166
#      END IF
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE SKIP 2 LINE
#      END IF
### FUN-550114
#      PRINT
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[9]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[9]
#             PRINT g_memo
#      END IF
### END FUN-550114
#
#END REPORT
   LET l_sql="SELECT oox01,oox02,oox03,oox03v,oox04, ",
             "       oox05,oox07,oox08,oox09,oox10, ",
             "       azi04,azi05,azi07 ",              #MOD-BA0023 
             "  FROM oox_file,azi_file ",              #MOD-BA0023 add azi_file
             " WHERE oox00 = 'AP' ",
             "   AND oox01 = ",yy,
             "   AND oox02 BETWEEN ",m1," AND ",m2,
             "   AND oox05 = azi01 ",                  #MOD-BA0023
             "   AND ",tm.wc CLIPPED,
             " ORDER BY oox01,oox02,oox05,oox03v,oox03"
 
   PREPARE gapx600_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare1:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   DECLARE gapx600_curs1 CURSOR FOR gapx600_prepare1
   FOREACH gapx600_curs1 INTO sr1.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     #No.FUN-D40020 ---start--- Add
      IF sr1.oox03v[1,1] MATCHES "1" THEN
         LET sr1.oox03v = sr1.oox03v," ",cl_getmsg('gap-006',g_lang)
      ELSE
         LET sr1.oox03v = sr1.oox03v," ",cl_getmsg('axr-253',g_lang)
      END IF
     #No.FUN-D40020 ---end  --- Add
      LET l_n1 = 0   #FUN-D40129
      EXECUTE insert_prep USING sr1.*,l_n1   #FUN-D40129 add l_n1
      IF STATUS THEN
         CALL cl_err("execute insert_prep:",STATUS,1)
         EXIT FOREACH
      END IF
   END FOREACH
   IF tm.b = '1' THEN                #多模板
      LET l_name = 'gapx600'
   ELSE
      LET l_name = 'gapx600_1'
   END IF
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   LET g_str = ''                                                                                                                   
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(tm.wc,'oox03,oox03v') RETURNING tm.wc                                                                           
      LET g_str = tm.wc                                                                                                             
   END IF                                                                                                                           
###XtraGrid###   LET g_str = g_str                                                                                                                
###XtraGrid###   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
###XtraGrid###   CALL cl_prt_cs3('gapx600',l_name,g_sql,g_str)                                                                                    
    IF tm.b = '1' THEN
       LET g_xgrid.template = "gapx600"
       CALL x600_temp()
    ELSE
       LET g_xgrid.template = "gapx600_1"
    END IF
    LET g_xgrid.headerinfo1 = yy
    LET g_xgrid.table = l_table    ###XtraGrid###
   #LET g_xgrid.grup_field = "oox02,oox05"         #FUN-D40129
    LET g_xgrid.grup_field = "oox01,oox02,oox05"   #FUN-D40129 
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc   #FUN-D40129
    CALL cl_xg_view()    ###XtraGrid###
   #No.FUN-BB0047--mark--Begin---
   #CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
   #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-7C0034 -- end --
#Patch....NO.TQC-610037 <001> #

#No.FUN-D40020 ---start--- Add
FUNCTION x600_temp()
   DEFINE sr2        RECORD
             oox01   LIKE oox_file.oox01,
             oox02   LIKE oox_file.oox02,
             oox03   LIKE oox_file.oox03,
            #oox03v  LIKE oox_file.oox03v,  #No.FUN-D40020   Mark
             oox03v  LIKE type_file.chr20,  #No.FUN-D40020   Add
             oox04   LIKE oox_file.oox04,
             oox05   LIKE oox_file.oox05,
             oox07   LIKE oox_file.oox07,
             oox08   LIKE oox_file.oox08,
             oox09   LIKE oox_file.oox09,
             oox10   LIKE oox_file.oox10,
             azi04   LIKE azi_file.azi04,
             azi05   LIKE azi_file.azi05,
             azi07   LIKE azi_file.azi07
                     END RECORD
   DEFINE l_n1   LIKE type_file.num5  #FUN-D40129 
   LET g_sql = "SELECT oox01,oox02,'',substr(oox03v,1,1)||'*','',oox05,oox07,",
               "       SUM(oox08),SUM(oox09),SUM(oox10),azi04,azi05,azi07",
               "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " GROUP BY oox01,oox02,substr(oox03v,1,1)||'*',oox05,oox07,azi04,azi05,azi07 ",
               " ORDER BY oox01,oox02,oox05,oox07 "
   PREPARE sel_oox_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE sel_oox_decl1 CURSOR FOR sel_oox_prep1
   FOREACH sel_oox_decl1 INTO sr2.*
     #No.FUN-D40020 ---start--- Add
      IF sr2.oox03v[1,1] MATCHES "1" THEN
         LET sr2.oox03v = sr2.oox03v," ",cl_getmsg('gap-006',g_lang)
      ELSE
         LET sr2.oox03v = sr2.oox03v," ",cl_getmsg('axr-253',g_lang)
      END IF
     #No.FUN-D40020 ---end  --- Add
      LET l_n1 = 0   #FUN-D40129 
      EXECUTE insert_prep USING sr2.*,l_n1   #FUN-D40129 add l_n1
   END FOREACH
   LET g_sql = "DELETE FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE oox03 IS NOT NULL"
   PREPARE del_oox_prep FROM g_sql
   EXECUTE del_oox_prep
      
END FUNCTION
#No.FUN-D40020 ---end  --- Add

###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

