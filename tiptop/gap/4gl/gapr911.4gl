# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gapr911.4gl
# Descriptions...: 供應商業務匯總帳列印
# Date & Author..: 03/05/21 by Carrier
# Modify.........: No.MOD-530675 05/03/26 By Day 期別判別錯誤
# Modify.........: No.MOD-580353 05/09/15 By Smapmin 選了期別之後還是會把其他的期別打印出來
# Modify.........; NO.TQC-650054 06/05/12 by yiting 報表錯誤
# Modify.........: No.FUN-660071 06/06/13 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: No.FUN-670107 06/08/24 By cheunl voucher型報表轉template1
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-740064 07/04/16 By arman  會計科目加帳套
# Modify.........: No.FUN-840076 08/07/16 By liuxqa 修改報表的分組
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/20 By yinhy 科目查询自动过滤,調整帳套位置
# Modify.........: No:FUN-B80049 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
		wc      LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1000)     # Where condition
                a       LIKE apm_file.apm00,     #NO FUN-690009 VARCHAR(20)
                yy      LIKE type_file.num5,     #NO FUN-690009 SMALLINT
                m1      LIKE type_file.num5,     #NO FUN-690009 SMALLINT
                m2      LIKE type_file.num5,     #NO FUN-690009 SMALLINT
                o       LIKE aaa_file.aaa01,     #NO.FUN-670003 
                b       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
                c       LIKE azi_file.azi01,     #NO FUN-690009 VARCHAR(4)
                d       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
                e       LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(01)
		more    LIKE type_file.chr1      # Prog. Version..: '5.30.06-13.03.12(01)       # Input more condition(Y/N)
           END RECORD,
           g_d      LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(01)
           g_null   LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(01) 
           g_print  LIKE type_file.num5,         #NO FUN-690009 SMALLINT
           g_aza17  LIKE aza_file.aza17,
           l_aza17  LIKE aza_file.aza17,
           l_aaz64  LIKE aaz_file.aaz64,
           l_aaa    RECORD LIKE aaa_file.*,
           l_aag02  LIKE aag_file.aag02,
           g_qcyef  LIKE apm_file.apm06f,
           g_qcye   LIKE apm_file.apm06f,
           g_apm06f LIKE apm_file.apm06f,
           g_apm07f LIKE apm_file.apm06f,
           g_apm06  LIKE apm_file.apm06f,
           g_apm07  LIKE apm_file.apm06f,
           t_qcyef  LIKE apm_file.apm06f,
           t_qcye   LIKE apm_file.apm06f,
           t_apm06f LIKE apm_file.apm06f,
           t_apm07f LIKE apm_file.apm06f,
           t_apm06  LIKE apm_file.apm06f,
           t_apm07  LIKE apm_file.apm06f
 
DEFINE   g_i        LIKE type_file.num5     #NO FUN-690009 SMALLINT  #count/index for any purpose
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
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time         #FUN-B80049   ADD    #FUN-BB0047 mark 

   INITIALIZE tm.* TO NULL            # Default condition
 
   SELECT aza17 INTO l_aza17 FROM aza_file WHERE aza01 = '0'
   IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF
   SELECT aaz64 INTO l_aaz64 FROM aaz_file WHERE aaz00 = '0'
   #No.FUN-660071  --Begin
   IF SQLCA.sqlcode THEN 
      CALL cl_err('aaz_file',-100,0) 
      CALL cl_err3("sel","aaz_file","","",-100,"","aaz_file",0) #No.FUN-660071
      EXIT PROGRAM
   END IF
   SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = l_aaz64
   IF SQLCA.sqlcode THEN 
      #CALL cl_err('aaa_file',-100,0) 
      CALL cl_err3("sel","aaa_file","","",-100,"","aaa_file",0) #No.FUN-660071
      EXIT PROGRAM 
   END IF
   SELECT aaf03 INTO g_company FROM aaf_file
    WHERE aaf01 = l_aaa.aaa01
      AND aaf02 = g_lang
   IF SQLCA.sqlcode THEN 
      #CALL cl_err('aaf_file',-100,0) 
      CALL cl_err3("sel","aaf_file","","",-100,"","aaf_file",0) #No.FUN-660071
      EXIT PROGRAM
   END IF
   #No.FUN-660071  --End  
 
  CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
  #-----TQC-610053---------
  LET g_pdate = ARG_VAL(1)
  LET g_towhom = ARG_VAL(2)
  LET g_rlang = ARG_VAL(3)
  LET g_bgjob = ARG_VAL(4)
  LET g_prtway = ARG_VAL(5)
  LET g_copies = ARG_VAL(6)
  LET tm.wc = ARG_VAL(7)
  LET tm.a = ARG_VAL(8)
  LET tm.yy = ARG_VAL(9)
  LET tm.m1 = ARG_VAL(10)
  LET tm.m2 = ARG_VAL(11)
  LET tm.o = ARG_VAL(12)
  LET tm.b = ARG_VAL(13)
  LET tm.c = ARG_VAL(14)
  LET tm.d = ARG_VAL(15)
  LET tm.e = ARG_VAL(16)
  LET g_rep_user = ARG_VAL(17)
  LET g_rep_clas = ARG_VAL(18)
  LET g_template = ARG_VAL(19)
  #-----END TQC-610053-----
 
   IF cl_null(tm.wc) THEN
       CALL gapr911_tm(0,0)             # Input print condition
   ELSE
       CALL gapr911()   #TQC-610053
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
END MAIN
 
FUNCTION gapr911_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031 
   DEFINE li_chk_bookno  LIKE type_file.num5     #No.FUN-670003 #NO FUN-690009 SMALLINT
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_n            LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_flag         LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO FUN-690009 VARCHAR(1000)
 
   LET p_row = 4 LET p_col =25
 
   OPEN WINDOW gapr911_w AT p_row,p_col WITH FORM "gap/42f/gapr911"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   LET tm.yy    = l_aaa.aaa04
   LET tm.m1    = l_aaa.aaa05
   LET tm.m2    = l_aaa.aaa05
   LET tm.o     = l_aaa.aaa01
   LET tm.b     = 'N'
   LET tm.c     = ''
   LET tm.d     = 'N'
   LET tm.e     = 'N'
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
 
   DISPLAY BY NAME tm.a,tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON apm01
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
      LET INT_FLAG = 0
      CLOSE WINDOW gapr911_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #INPUT BY NAME tm.a,tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.c,tm.d,tm.e,tm.more  #FUN-B10053 mark
   INPUT BY NAME tm.o,tm.a,tm.yy,tm.m1,tm.m2,tm.b,tm.c,tm.d,tm.e,tm.more   #FUN-B10053
   WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
     AFTER FIELD a
        LET l_flag = 0
        #No.FUN-B10053  --Begin
        #IF cl_null(tm.a) THEN
        #   CALL cl_err('','mfg3018',0)
        #   NEXT FIELD a
        #ELSE
        #   SELECT COUNT(*) INTO l_n FROM aag_file
        #    WHERE aag01 = tm.a
        #      AND aag00 = tm.o      #NO.FUN-740064
        #     AND ( aag07 ='2' or aag07='3')
        #   IF l_n = 0 THEN
        #      CALL cl_err(tm.a,'aap-021',0)
        #      NEXT FIELD a
        #   ELSE
        #      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = tm.a   AND aag00 = tm.o     #NO.FUN-740064
        #   END IF
        #END IF
        IF NOT cl_null(tm.a) THEN
           CALL gapr911_a(tm.a,tm.o)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(tm.a,g_errno,0)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = tm.a
              LET g_qryparam.arg1 = tm.o
              LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",tm.a CLIPPED,"%'"
              CALL cl_create_qry() RETURNING tm.a
              DISPLAY BY NAME tm.a
              NEXT FIELD a
            END IF
        END IF
        #No.FUN-B10053  --End
 
     AFTER FIELD yy
        IF cl_null(tm.yy) THEN
           CALL cl_err('','mfg3018',0)
           NEXT FIELD yy
        END IF
 
     AFTER FIELD m1
        IF cl_null(tm.m1) OR tm.m1 > 13 OR tm.m1 < 1 THEN
           CALL cl_err(tm.m1,'agl-013',0)
           NEXT FIELD m1
        END IF
 
     AFTER FIELD m2
        IF cl_null(tm.m2) OR tm.m2 > 13 OR tm.m2 < 1 THEN
           CALL cl_err(tm.m1,'agl-013',0)
           NEXT FIELD m2
        END IF
        IF tm.m2 < tm.m1 THEN
           CALL cl_err('','agl-157',0)
           NEXT FIELD m1
        END IF
 
     AFTER FIELD o
        IF cl_null(tm.o) THEN
           CALL cl_err('','mfg3018',0)
           NEXT FIELD o
        END IF
         #No.FUN-670003--begin
         CALL s_check_bookno(tm.o,g_user,g_plant) 
              RETURNING li_chk_bookno
         IF (NOT li_chk_bookno) THEN
              NEXT FIELD o
         END IF 
         #No.FUN-670003--end
        SELECT * FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN
           #CALL cl_err('',SQLCA.sqlcode,0)  #No.FUN-660071
           CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0) #No.FUN-660071
           NEXT FIELD o
        END IF
        #No.FUN-B10053 --Begin
        IF NOT cl_null(tm.a) THEN
           CALL gapr911_a(tm.a,tm.o)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(tm.a,g_errno,0)
              NEXT FIELD a
           END IF
        END IF
        #No.FUN-B10053 --End
        SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF   #使用本國幣別
 
     AFTER FIELD b
        LET l_flag = 1
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
           NEXT FIELD b
        END IF
        IF tm.b = 'N' THEN
           LET tm.c = ''
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
        LET l_flag = 2
        IF tm.b = 'Y' THEN
           IF cl_null(tm.c) THEN
              CALL cl_err('','mfg3018',0)
              NEXT FIELD c
           END IF
           LET l_n = 0
           SELECT COUNT(*) INTO l_n FROM azi_file
            WHERE azi01 = tm.c
           IF l_n = 0 THEN CALL cl_err('',-100,0) NEXT FIELD c END IF
        END IF
 
     AFTER FIELD d
        LET l_flag = 2
# genero  script marked         IF cl_ku() THEN
# genero  script marked            IF tm.b = 'N' THEN
# genero  script marked               NEXT FIELD b
# genero  script marked            ELSE
# genero  script marked               NEXT FIELD c
# genero  script marked            END IF
# genero  script marked         END IF
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
     AFTER FIELD e
        IF cl_null(tm.e) OR tm.e NOT MATCHES '[YN]' THEN
           NEXT FIELD e
        END IF
 
     AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     ON ACTION CONTROLP
        CASE
           WHEN INFIELD(a)     #科目代號
#             CALL q_aag(8,5,tm.a,'23','','') RETURNING tm.a
#             CALL FGL_DIALOG_SETBUFFER( tm.a )
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aag'
              LET g_qryparam.default1 = tm.a
              LET g_qryparam.arg1 = tm.o       #NO.FUN-740064
              CALL cl_create_qry() RETURNING tm.a
#              CALL FGL_DIALOG_SETBUFFER( tm.a )
              DISPLAY BY NAME tm.a
              NEXT FIELD a
 
           WHEN INFIELD(c)     #科目代號
#             CALL q_azi(8,5,tm.c) RETURNING tm.c
#             CALL FGL_DIALOG_SETBUFFER( tm.c )
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 = tm.c
              CALL cl_create_qry() RETURNING tm.c
#              CALL FGL_DIALOG_SETBUFFER( tm.c )
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
      LET INT_FLAG = 0
      CLOSE WINDOW gapr911_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gapr911'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gapr911','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,
                         " '",tm.a     CLIPPED,"'",
                         " '",tm.yy    CLIPPED,"'" ,
                         " '",tm.m1    CLIPPED,"'" ,
                         " '",tm.m2    CLIPPED,"'" ,
                         " '",tm.o     CLIPPED,"'",
                         " '",tm.b     CLIPPED,"'",
                         " '",tm.c     CLIPPED,"'",
                         " '",tm.d     CLIPPED,"'",
                         " '",tm.e     CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('gapr911',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gapr911_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gapr911()
   ERROR ""
END WHILE
   CLOSE WINDOW gapr911_w
END FUNCTION
 
FUNCTION gapr911()
   DEFINE l_name    LIKE type_file.chr20,   #NO FUN-690009 VARCHAR(20)       # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0097
          l_sql     LIKE type_file.chr1000, #NO FUN-690009 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000, #NO FUN-690009 VARCHAR(1000)
          l_i       LIKE type_file.num5,    #NO FUN-690009 SMALLINT
          l_qcyef   LIKE apm_file.apm06f,
          l_qcye    LIKE apm_file.apm06f,
          m_apm06f  LIKE apm_file.apm06f,
          m_apm07f  LIKE apm_file.apm07f,
          m_apm06   LIKE apm_file.apm06f,
          m_apm07   LIKE apm_file.apm07f,
          sr1       RECORD
                    apm01    LIKE apm_file.apm01,
                    apm02    LIKE apm_file.apm02
                    END RECORD,
          sr        RECORD
                    apm01    LIKE apm_file.apm01,
                    apm02    LIKE apm_file.apm02,
                    apm04    LIKE apm_file.apm04,
                    apm05    LIKE apm_file.apm05,
                    apm06f   LIKE apm_file.apm06f,
                    apm07f   LIKE apm_file.apm07f,
                    apm06    LIKE apm_file.apm06,
                    apm07    LIKE apm_file.apm07,
                    qcyef    LIKE apm_file.apm06f,
                    qcye     LIKE apm_file.apm06f,
                    prt      LIKE type_file.chr1          #NO FUN-690009
                    END RECORD
 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End-----
     CALL cl_outnam('gapr911') RETURNING l_name  #NO.TQC-650054
# No.FUN-670107-------start---------------------------
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file #列印選擇條件否、報表寬度
#      WHERE zz01 = 'gapr911'   #程序資料檔
#    IF g_len = 0 OR g_len IS NULL THEN
#       IF tm.b = 'N' THEN
#          LET g_len = 101
#       ELSE
#          LET g_len = 155
#       END IF
#    END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     IF tm.b = 'Y' THEN                                                                                                             
      LET g_zaa[31].zaa06 = "N"                                                                                                     
      LET g_zaa[32].zaa06 = "N"                                                                                                     
      LET g_zaa[33].zaa06 = "N"                                                                                                     
      LET g_zaa[34].zaa06 = "N"                                                                                                     
      LET g_zaa[35].zaa06 = "N"                                                                                                     
      LET g_zaa[36].zaa06 = "N"                                                                                                     
      LET g_zaa[37].zaa06 = "N"                                                                                                     
      LET g_zaa[38].zaa06 = "N"                                                                                                     
      LET g_zaa[39].zaa06 = "N"                                                                                                     
      LET g_zaa[40].zaa06 = "N"                                                                                                     
      LET g_zaa[41].zaa06 = "N"                                                                                                     
      LET g_zaa[42].zaa06 = "N"                                                                                                     
      LET g_zaa[43].zaa06 = "Y"                                                                                                     
      LET g_zaa[44].zaa06 = "Y"                                                                                                     
      LET g_zaa[45].zaa06 = "Y"                                                                                                     
    ELSE
       LET g_zaa[31].zaa06 = "N"                                                                                                     
      LET g_zaa[32].zaa06 = "N"                                                                                                     
      LET g_zaa[33].zaa06 = "N"                                                                                                     
      LET g_zaa[34].zaa06 = "N"                                                                                                     
      LET g_zaa[35].zaa06 = "N"                                                                                                     
      LET g_zaa[36].zaa06 = "Y"                                                                                                     
      LET g_zaa[37].zaa06 = "Y"                                                                                                     
      LET g_zaa[38].zaa06 = "Y"                                                                                                     
      LET g_zaa[39].zaa06 = "Y"                                                                                                     
      LET g_zaa[40].zaa06 = "N"                                                                                                     
      LET g_zaa[41].zaa06 = "Y"                                                                                                     
      LET g_zaa[42].zaa06 = "Y"                                                                                                     
      LET g_zaa[43].zaa06 = "N"                                                                                                     
      LET g_zaa[44].zaa06 = "N"                                                                                                     
      LET g_zaa[45].zaa06 = "N"                                                                                                     
    END IF
    CALL cl_prt_pos_len()
# No.FUN-670107-------end------
     IF tm.b = 'Y' THEN
        LET g_aza17 = tm.c
     ELSE
        LET g_aza17 = l_aza17
     END IF
#    SELECT azi04 INTO t_azi04
#       FROM azi_file WHERE azi01=g_aza17                 #No.CHI-6A0004
     IF SQLCA.sqlcode THEN
        #CALL cl_err('azi04',SQLCA.sqlcode,0)  #No.FUN-660071
        CALL cl_err3("sel","azi_file",g_aza17,"",SQLCA.sqlcode,"","",0) #No.FUN-660071
     END IF
     LET l_sql = " SELECT UNIQUE apm01,apm02 FROM apm_file ",
                 "  WHERE apm00 = '",tm.a    CLIPPED,"'",
                 "    AND apm08 = '",g_plant CLIPPED,"'",
                 "    AND apm09 = '",tm.o    CLIPPED,"'",
                 "    AND ",tm.wc CLIPPED
     IF tm.b = 'Y' THEN
        LET l_sql = l_sql CLIPPED," AND apm11 = '",g_aza17 CLIPPED,"'"
     END IF
     PREPARE gapr911_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
        EXIT PROGRAM
     END IF
     DECLARE gapr911_curs1 CURSOR FOR gapr911_pr1
 
     LET l_sql1="SELECT apm01,apm02,apm04,apm05,SUM(apm06f),",
                "       SUM(apm07f),SUM(apm06),SUM(apm07),0,0,'' ",
                "  FROM apm_file ",
                " WHERE apm00 = '",tm.a    CLIPPED,"'",
                "   AND apm08 = '",g_plant CLIPPED,"'",
                "   AND apm09 = '",tm.o    CLIPPED,"'",
                "   AND apm01 = ?          AND apm02 = ? ",
                "   AND apm04 = ",tm.yy,
                "   AND ",tm.wc CLIPPED
     IF tm.b = 'Y' THEN
        LET l_sql1 = l_sql1 CLIPPED," AND apm11 = '",g_aza17 CLIPPED,"'"
     END IF
        LET l_sql1 = l_sql1 CLIPPED,
                " GROUP BY apm01,apm02,apm04,apm05 ",
                " ORDER BY apm01,apm02,apm04,apm05 "
     PREPARE gapr911_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
        EXIT PROGRAM
     END IF
     DECLARE gapr911_curs CURSOR FOR gapr911_prepare1
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
        EXIT PROGRAM
     END IF
 
#     CALL cl_outnam('gapr911') RETURNING l_name    #NO.TQC-650054
 
     IF tm.b = 'N' THEN   #本幣
        START REPORT gapr911_rep TO l_name
        LET g_pageno = 0
     ELSE                 #原幣
        START REPORT gapr911_rep1 TO l_name
        LET g_pageno = 0
     END IF
     LET t_qcyef   = 0
     LET t_qcye    = 0
     LET t_apm06f  = 0
     LET t_apm07f  = 0
     LET t_apm06   = 0
     LET t_apm07   = 0
 
     FOREACH gapr911_curs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       LET g_null = 'N'
       IF tm.b = 'N' THEN
          SELECT SUM(apm06-apm07)  #期初余額
            INTO l_qcye    FROM apm_file
           WHERE apm01 = sr1.apm01 AND apm02 = sr1.apm02
             AND apm00 = tm.a
             AND apm04 = tm.yy     AND apm05 < tm.m1
             AND apm08 = g_plant   AND apm09 = tm.o
          SELECT SUM(apm06),SUM(apm07)  #期間余額
            INTO m_apm06,m_apm07
            FROM apm_file
           WHERE apm01 = sr1.apm01 AND apm02 = sr1.apm02
             AND apm00 = tm.a
             AND apm04 = tm.yy     AND apm05 BETWEEN tm.m1 AND tm.m2
             AND apm08 = g_plant   AND apm09 = tm.o
       ELSE
          SELECT SUM(apm06f-apm07f),SUM(apm06-apm07)  #期初余額
            INTO l_qcyef,l_qcye    FROM apm_file
           WHERE apm01 = sr1.apm01 AND apm02 = sr1.apm02
             AND apm00 = tm.a      AND apm11 = g_aza17
             AND apm04 = tm.yy     AND apm05 < tm.m1
             AND apm08 = g_plant   AND apm09 = tm.o
          SELECT SUM(apm06f),SUM(apm07f),SUM(apm06),SUM(apm07)  #期間余額
            INTO m_apm06f,m_apm07f,m_apm06,m_apm07
            FROM apm_file
           WHERE apm01 = sr1.apm01 AND apm02 = sr1.apm02
             AND apm00 = tm.a      AND apm11 = g_aza17
             AND apm04 = tm.yy     AND apm05 BETWEEN tm.m1 AND tm.m2
             AND apm08 = g_plant   AND apm09 = tm.o
       END IF
       IF cl_null(l_qcyef)  THEN LET l_qcyef  = 0 END IF
       IF cl_null(l_qcye )  THEN LET l_qcye   = 0 END IF
       IF cl_null(m_apm06f) THEN LET m_apm06f = 0 END IF
       IF cl_null(m_apm07f) THEN LET m_apm07f = 0 END IF
       IF cl_null(m_apm06)  THEN LET m_apm06  = 0 END IF
       IF cl_null(m_apm07)  THEN LET m_apm07  = 0 END IF
 
       IF tm.b = 'N'   AND l_qcye = 0  AND      #本幣
          m_apm06 = 0 AND m_apm07 = 0 THEN
          LET g_null = 'Y'                       #期初為零且無異動
       END IF
       IF tm.b='Y' AND l_qcyef=0 AND l_qcye=0 AND m_apm06f=0   #外幣
          AND m_apm07f=0  AND m_apm06=0 AND m_apm07=0 THEN
          LET g_null = 'Y'
       END IF
       IF tm.d = 'N' THEN         #期初為零且無異動不打印
          IF g_null = 'Y' THEN
             CONTINUE FOREACH
          END IF
       END IF
       IF tm.d = 'Y' AND g_null = 'Y' OR
          tm.b = 'N' AND m_apm06 = 0 AND m_apm07 = 0  OR
          tm.b='Y' AND m_apm06f=0 AND m_apm07f=0 AND m_apm06=0 AND m_apm07=0
       THEN
             LET sr.apm01  = sr1.apm01
             LET sr.apm02  = sr1.apm02
             LET sr.apm04  = tm.yy
             LET sr.apm06f = 0
             LET sr.apm07f = 0
             LET sr.apm06  = 0
             LET sr.apm07  = 0
             LET sr.qcye   = l_qcye
             LET sr.qcyef  = l_qcyef
             LET sr.prt    = '0'
             IF tm.b = 'N' THEN   #本幣
                OUTPUT TO REPORT gapr911_rep(sr.*)
             ELSE                 #原幣
                OUTPUT TO REPORT gapr911_rep1(sr.*)
             END IF
             CONTINUE FOREACH
       END IF
       FOREACH gapr911_curs USING sr1.apm01,sr1.apm02 INTO sr.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
#MOD-580353
         IF sr.apm05 < tm.m1 OR sr.apm05 > tm.m2 THEN
            CONTINUE FOREACH
         END IF
#END MOD-580353
         IF cl_null(sr.apm06f) THEN LET sr.apm06f = 0 END IF
         IF cl_null(sr.apm07f) THEN LET sr.apm07f = 0 END IF
         IF cl_null(sr.apm06)  THEN LET sr.apm06 = 0 END IF
         IF cl_null(sr.apm07)  THEN LET sr.apm07 = 0 END IF
         IF tm.b = 'N' THEN
            IF sr.apm06 = 0 AND sr.apm07 = 0 THEN
               CONTINUE FOREACH
            END IF
         ELSE
            IF sr.apm06=0 AND sr.apm07=0 AND sr.apm06f=0 AND sr.apm07f=0 THEN
               CONTINUE FOREACH
            END IF
         END IF
         LET sr.qcyef = l_qcyef
         LET sr.qcye  = l_qcye
         LET sr.prt   = '1'
         IF tm.b = 'N' THEN   #本幣
            OUTPUT TO REPORT gapr911_rep(sr.*)
         ELSE                 #原幣
            OUTPUT TO REPORT gapr911_rep1(sr.*)
         END IF
         LET g_print = g_print + 1
       END FOREACH
     END FOREACH
 
     IF tm.b = 'N' THEN   #本幣
        FINISH REPORT gapr911_rep
     ELSE                 #原幣
        FINISH REPORT gapr911_rep1
     END IF
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-B10053  --Begin
FUNCTION gapr911_a(p_key,p_bookno)
    DEFINE p_key        LIKE aag_file.aag01
    DEFINE p_bookno     LIKE aag_file.aag00
    DEFINE l_aag02      LIKE aag_file.aag02
    DEFINE l_aag07      LIKE aag_file.aag07
    DEFINE l_acti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aag07,aagacti
      INTO l_aag02,l_aag07,l_acti
      FROM aag_file
     WHERE aag01 = p_key AND aag07 IN ('2','3')
       AND aag00 = p_bookno

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-027'
         WHEN l_acti  ='N'         LET g_errno = '9028'
         WHEN l_aag07  = '1'       LET g_errno = 'agl-015'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#No.FUN-B10053  --End
 
REPORT gapr911_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(1)
          sr        RECORD
                        apm01    LIKE apm_file.apm01,
                        apm02    LIKE apm_file.apm02,
                        apm04    LIKE apm_file.apm04,
                        apm05    LIKE apm_file.apm05,
                        apm06f   LIKE apm_file.apm06f,
                        apm07f   LIKE apm_file.apm07f,
                        apm06    LIKE apm_file.apm06,
                        apm07    LIKE apm_file.apm07,
                        qcyef    LIKE apm_file.apm06f,
                        qcye     LIKE apm_file.apm06f,
                        prt      LIKE type_file.chr1   #NO FUN-690009 VARCHAR(1)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.apm01,sr.apm02,sr.apm04,sr.apm05
  FORMAT
   PAGE HEADER
#No.FUN-670107 ------------------------start--------------------------------
      PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1]
      LET g_pageno = g_pageno + 1                                                                                                   
      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1 ,g_x[1]
#No.FUN-670107 -------------------------end-------------------------------------      
      PRINT ' '
 
#     LET g_pageno = g_pageno + 1                                #No.FUN-670107 
      PRINT COLUMN 01,g_x[11] CLIPPED,
            l_aag02 CLIPPED,'(',tm.a CLIPPED,')'
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
      PRINT COLUMN 1,g_x[27] CLIPPED,
            tm.yy USING '&&&&','/',tm.m1 USING '&&','-',
            tm.yy USING '&&&&','/',tm.m2 USING '&&',
            COLUMN 32,g_x[26] CLIPPED,tm.o
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
      PRINT g_dash[1,g_len]
#     PRINT COLUMN  1,g_x[13] CLIPPED,
#           COLUMN 38,g_x[14] CLIPPED,
#           COLUMN 85,g_x[15] CLIPPED
#     PRINT '---------- -------- ---- -- -------- ------------------ ',
#           '------------------  --  ------------------'
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],                                                                                
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],                                                                                
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]                                                                                 
      PRINT g_dash1
      LET l_last_sw ='n'
 
   BEFORE GROUP OF sr.apm02   #No.FUN-840076 modify by liuxqa
     IF tm.e = 'Y' THEN
        SKIP TO TOP OF PAGE
     END IF
     LET g_qcye = sr.qcye
     LET g_apm06 = 0
     LET g_apm07 = 0
#    PRINT COLUMN  1,sr.apm01 CLIPPED,
#          COLUMN 12,sr.apm02 CLIPPED,
#          COLUMN 21,sr.apm04 USING "&&&&",
#          COLUMN 29,g_x[21]  CLIPPED;
     IF sr.qcye > 0 THEN
#       PRINT COLUMN 77,g_x[22].substring(1,2),
#             COLUMN 80,cl_numfor(sr.qcye,18,g_azi04)
        PRINT COLUMN g_c[31],sr.apm01 CLIPPED,                                                                                      
              COLUMN g_c[32],sr.apm02 CLIPPED,                                                                                      
              COLUMN g_c[33],sr.apm04 USING "&&&&",                                                                                 
              COLUMN g_c[34],sr.apm05 USING "#&",                                                                                   
              COLUMN g_c[35],g_x[21]  CLIPPED,                                                                                      
              COLUMN g_c[40],g_x[22].substring(1,2),                                                                                
              COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)     #No.CHI-6A0004 
     ELSE
        IF sr.qcye = 0 THEN
#          PRINT COLUMN 77,g_x[22].substring(5,6),
#                COLUMN 80,cl_numfor(sr.qcye,18,g_azi04)
           PRINT COLUMN g_c[31],sr.apm01 CLIPPED,                                                                                   
                 COLUMN g_c[32],sr.apm02 CLIPPED,                                                                                   
                 COLUMN g_c[33],sr.apm04 USING "&&&&",                                                                              
                 COLUMN g_c[34],sr.apm05 USING "#&",                                                                                
                 COLUMN g_c[35],g_x[21]  CLIPPED,                                                                                   
                 COLUMN g_c[40],g_x[22].substring(5,6),                                                                             
                 COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)      #No.CHI-6A0004 
        ELSE
#          PRINT COLUMN 77,g_x[22].substring(3,4),
#                COLUMN 80,cl_numfor(sr.qcye*-1,18,g_azi04)
           PRINT COLUMN g_c[31],sr.apm01 CLIPPED,                                                                                   
                 COLUMN g_c[32],sr.apm02 CLIPPED,                                                                                   
                 COLUMN g_c[33],sr.apm04 USING "&&&&",                                                                              
                 COLUMN g_c[34],sr.apm05 USING "#&",                                                                                
                 COLUMN g_c[35],g_x[21]  CLIPPED,                                                                                   
                 COLUMN g_c[40],g_x[22].substring(3,4),                                                                             
                 COLUMN g_c[45],cl_numfor(sr.qcye*-1,45,t_azi04)   #No.CHI-6A0004  
        END IF
     END IF
 
   ON EVERY ROW
 #No.MOD-530675--begin
     IF sr.prt = '1' THEN
        IF sr.apm05<>0 THEN
#          PRINT COLUMN  26,sr.apm05 USING "#&",
#                COLUMN  29,g_x[23] CLIPPED,
#                COLUMN  37,cl_numfor(sr.apm06,18,g_azi04),
#                COLUMN  56,cl_numfor(sr.apm07,18,g_azi04);
           PRINT COLUMN  g_c[34],sr.apm05 USING "#&",                                                                               
                 COLUMN  g_c[35],g_x[23] CLIPPED,                                                                                   
                 COLUMN  g_c[41],cl_numfor(sr.apm06,41,t_azi04),     #No.CHI-6A0004                                                                 
                 COLUMN  g_c[42],cl_numfor(sr.apm07,42,t_azi04);     #No.CHI-6A0004 
           LET g_apm06 = g_apm06 + sr.apm06
           LET g_apm07 = g_apm07 + sr.apm07
           LET g_qcye  = g_qcye  + sr.apm06 - sr.apm07
           IF g_qcye > 0 THEN
#             PRINT COLUMN 77,g_x[22].substring(1,2),
#                   COLUMN 80,cl_numfor(g_qcye,18,g_azi04)
              PRINT COLUMN g_c[40],g_x[22].substring(1,2),                                                                          
                    COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)     #No.CHI-6A0004 
           ELSE
              IF g_qcye = 0 THEN
#                PRINT COLUMN 77,g_x[22].substring(5,6),
#                      COLUMN 80,cl_numfor(g_qcye,18,g_azi04)
                 PRINT COLUMN g_c[40],g_x[22].substring(5,6),                                                                       
                       COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)   #No.CHI-6A0004  
              ELSE
#                PRINT COLUMN 77,g_x[22].substring(3,4),
#                      COLUMN 80,cl_numfor(g_qcye*-1,18,g_azi04)
                 PRINT COLUMN g_c[40],g_x[22].substring(3,4),                                                                       
                       COLUMN g_c[45],cl_numfor(sr.qcye*-1,45,t_azi04)    #No.CHI-6A0004 
              END IF
           END IF
        END IF
     END IF
 #No.MOD-530675--end
 
   AFTER GROUP OF sr.apm02     #No.FUN-840076 modify by liuxqa
#    PRINT COLUMN 29,g_x[24] CLIPPED,
#          COLUMN 37,cl_numfor(g_apm06,18,g_azi04),
#          COLUMN 56,cl_numfor(g_apm07,18,g_azi04);
     PRINT COLUMN g_c[35],g_x[24] CLIPPED,                                                                                          
           COLUMN g_c[43],cl_numfor(g_apm06,43,t_azi04),      #No.CHI-6A0004                                                                        
           COLUMN g_c[44],cl_numfor(g_apm07,44,t_azi04);      #No.CHI-6A0004 
     IF g_qcye > 0 THEN
#       PRINT COLUMN 77,g_x[22].substring(1,2),
#             COLUMN 80,cl_numfor(g_qcye,18,g_azi04)
        PRINT COLUMN g_c[40],g_x[22].substring(1,2),                                                                                
              COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)     #No.CHI-6A0004 
     ELSE
        IF g_qcye = 0 THEN
#          PRINT COLUMN 77,g_x[22].substring(5,6),
#                COLUMN 80,cl_numfor(g_qcye,18,g_azi04)
           PRINT COLUMN g_c[40],g_x[22].substring(5,6),                                                                             
                 COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)   #No.CHI-6A0004 
        ELSE
#          PRINT COLUMN 77,g_x[22].substring(3,4),
#                COLUMN 80,cl_numfor(g_qcye*-1,18,g_azi04)
           PRINT COLUMN g_c[40],g_x[22].substring(3,4),                                                                             
                 COLUMN g_c[45],cl_numfor(sr.qcye*-1,45,t_azi04)    #No.CHI-6A0004 
        END IF
     END IF
     LET t_qcye  = t_qcye  + g_qcye
     LET t_apm06 = t_apm06 + g_apm06
     LET t_apm07 = t_apm07 + g_apm07
     PRINT
 
   ON LAST ROW
#     PRINT COLUMN 29,g_x[25] CLIPPED,
#           COLUMN 37,cl_numfor(t_apm06,18,g_azi04),
#           COLUMN 56,cl_numfor(t_apm07,18,g_azi04);
      PRINT COLUMN g_c[35],g_x[25] CLIPPED,                                                                                         
            COLUMN g_c[43],cl_numfor(t_apm06,43,t_azi04),    #No.CHI-6A0004                                                                         
            COLUMN g_c[44],cl_numfor(t_apm07,44,t_azi04);    #No.CHI-6A0004 
      IF t_qcye > 0 THEN
#        PRINT COLUMN 77,g_x[22].substring(1,2),
#              COLUMN 80,cl_numfor(t_qcye,18,g_azi04)
         PRINT COLUMN g_c[40],g_x[22].substring(1,2),                                                                               
               COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)    #No.CHI-6A0004 
      ELSE
         IF t_qcye = 0 THEN
#           PRINT COLUMN 77,g_x[22].substring(5,6),
#                 COLUMN 80,cl_numfor(t_qcye,18,g_azi04)
            PRINT COLUMN g_c[40],g_x[22].substring(5,6),                                                                            
                  COLUMN g_c[45],cl_numfor(sr.qcye,45,t_azi04)    #No.CHI-6A0004 
         ELSE
#           PRINT COLUMN 77,g_x[22].substring(3,4),
#                 COLUMN 80,cl_numfor(t_qcye*-1,18,g_azi04)
            PRINT COLUMN g_c[40],g_x[22].substring(3,4),                                                                            
                  COLUMN g_c[45],cl_numfor(sr.qcye*-1,45,t_azi04)    #No.CHI-6A0004 
         END IF
      END IF
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
 
REPORT gapr911_rep1(sr)
   DEFINE l_last_sw LIKE type_file.chr1,         #NO FUN-690009 VARCHAR(1)
          sr        RECORD
                        apm01    LIKE apm_file.apm01,
                        apm02    LIKE apm_file.apm02,
                        apm04    LIKE apm_file.apm04,
                        apm05    LIKE apm_file.apm05,
                        apm06f   LIKE apm_file.apm06f,
                        apm07f   LIKE apm_file.apm07f,
                        apm06    LIKE apm_file.apm06,
                        apm07    LIKE apm_file.apm07,
                        qcyef    LIKE apm_file.apm06f,
                        qcye     LIKE apm_file.apm06f,
                        prt      LIKE type_file.chr1     #NO FUN-690009 VARCHAR(1)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.apm01,sr.apm02,sr.apm04,sr.apm05
  FORMAT
   PAGE HEADER
#No.FUN-670107-----------------------------start---------------------------
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2 SPACES,g_x[1]
      PRINT COLUMN(g_len-FGL_WIDTH(g_company CLIPPED))/2+1 ,g_company CLIPPED
      LET g_pageno = g_pageno + 1                                                                                                   
      LET pageno_total = PAGENO USING '<<<',"/pageno"                                                                               
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[1] CLIPPED))/2+1,g_x[1]
      PRINT ' '
 
#     LET g_pageno = g_pageno + 1
      PRINT COLUMN 01,g_x[11] CLIPPED,
            l_aag02 CLIPPED,'(',tm.a CLIPPED,')'
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
#           COLUMN 51,g_x[27] CLIPPED,
      PRINT COLUMN g_c[2],g_x[27] CLIPPED,                                                                                          
            tm.yy USING '&&&&','/',tm.m1 USING '&&','-',
            tm.yy USING '&&&&','/',tm.m2 USING '&&',
            COLUMN 85,g_x[12] CLIPPED,g_aza17 CLIPPED,' ',
            COLUMN 100,g_x[26] CLIPPED,tm.o
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
      PRINT g_dash
#     PRINT COLUMN 38,g_x[16] CLIPPED,COLUMN 76,g_x[17] CLIPPED,
#           COLUMN 119,g_x[18] CLIPPED
#     PRINT '                                    ',
#           ' ------------------------------------- -------------------------------------',
#           '      -------------------------------------'
#     PRINT COLUMN  1,g_x[13] CLIPPED, COLUMN 38,g_x[19] CLIPPED,
#           COLUMN 76,g_x[19] CLIPPED, COLUMN 114,g_x[20] CLIPPED,
#           COLUMN 119,g_x[19] CLIPPED
#     PRINT '---------- -------- ---- -- -------- ------------------ ',
#           '------------------ ------------------ ------------------',
#           '  --  ------------------ ------------------'
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],                                                                                
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],                                                                                
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]                                                                                 
      PRINT g_dash1
#No.FUN-670107-----------------------------------------end------------------------------------
      LET l_last_sw ='n'
 
   BEFORE GROUP OF sr.apm02   #No.FUN-840076 modify by liuxqa
     IF tm.e = 'Y' THEN
        SKIP TO TOP OF PAGE
     END IF
     LET g_qcyef  = sr.qcyef
     LET g_qcye   = sr.qcye
     LET g_apm06f = 0
     LET g_apm07f = 0
     LET g_apm06  = 0
     LET g_apm07  = 0
#    PRINT COLUMN  1,sr.apm01 CLIPPED,
#          COLUMN 12,sr.apm02 CLIPPED,
#          COLUMN 21,sr.apm04 USING "&&&&",
#          COLUMN 29,g_x[21];
     PRINT COLUMN g_c[31],sr.apm01 CLIPPED,                                                                                         
           COLUMN g_c[32],sr.apm02 CLIPPED,                                                                                         
           COLUMN g_c[33],sr.apm04 USING "&&&&",                                                                                    
           COLUMN g_c[34],sr.apm05 USING "#&",                                                                                      
           COLUMN g_c[35],g_x[21],                                                                                                  
           COLUMN g_c[36],cl_numfor(sr.apm06f,36,t_azi04),     #No.CHI-6A0004                                                                       
           COLUMN g_c[37],cl_numfor(sr.apm06 ,37,t_azi04),     #No.CHI-6A0004                                                                       
           COLUMN g_c[38],cl_numfor(sr.apm07f,38,t_azi04),     #No.CHI-6A0004                                                                       
           COLUMN g_c[39],cl_numfor(sr.apm07 ,39,t_azi04);     #No.CHI-6A0004 
     IF sr.qcyef > 0 THEN
#       PRINT COLUMN 115,g_x[22].substring(1,2),
#             COLUMN 118,cl_numfor(sr.qcyef,18,g_azi04),
#             COLUMN 137,cl_numfor(sr.qcye ,18,g_azi04)
        PRINT COLUMN g_c[40],g_x[22].substring(1,2),                                                                                
              COLUMN g_c[41],cl_numfor(sr.qcyef,41,t_azi04),   #No.CHI-6A0004                                                                       
              COLUMN g_c[42],cl_numfor(sr.qcye ,42,t_azi04)    #No.CHI-6A0004 
     ELSE
        IF sr.qcyef = 0 THEN
#          PRINT COLUMN 115,g_x[22].substring(5,6),
#                COLUMN 118,cl_numfor(sr.qcyef,18,g_azi04),
#                COLUMN 137,cl_numfor(sr.qcye ,18,g_azi04)
           PRINT COLUMN g_c[40],g_x[22].substring(5,6),                                                                             
                 COLUMN g_c[41],cl_numfor(sr.qcyef,41,t_azi04),    #No.CHI-6A0004                                                                   
                 COLUMN g_c[42],cl_numfor(sr.qcye ,42,t_azi04)     #No.CHI-6A0004 
        ELSE
#          PRINT COLUMN 115,g_x[22].substring(3,4),
#                COLUMN 118,cl_numfor(sr.qcyef*-1,18,t_azi04),     #No.CHI-6A0004 
#                COLUMN 137,cl_numfor(sr.qcye *-1,18,t_azi04)      #No.CHI-6A0004 
           PRINT COLUMN g_c[40],g_x[22].substring(3,4),                                                                             
                 COLUMN g_c[41],cl_numfor(sr.qcyef*-1,41,t_azi04),  #No.CHI-6A0004                                                                  
                 COLUMN g_c[42],cl_numfor(sr.qcye*-1 ,42,t_azi04)   #No.CHI-6A0004 
        END IF
     END IF
 
   ON EVERY ROW
     IF sr.prt = '1' THEN
#No.FUN-670107 ---------------start-----------------------------
#       PRINT COLUMN 26,sr.apm05 USING "#&",
#             COLUMN 29,g_x[23] CLIPPED,
#             COLUMN 37,cl_numfor(sr.apm06f,18,g_azi04),
#             COLUMN 56,cl_numfor(sr.apm06 ,18,g_azi04),
#             COLUMN 75,cl_numfor(sr.apm07f,18,g_azi04),
#             COLUMN 94,cl_numfor(sr.apm07 ,18,g_azi04);
        PRINT COLUMN g_c[34],sr.apm05 USING "#&",                                                                                   
              COLUMN g_c[35],g_x[23] CLIPPED,                                                                                       
              COLUMN g_c[36],cl_numfor(sr.apm06f,36,t_azi04),    #No.CHI-6A0004                                                                     
              COLUMN g_c[37],cl_numfor(sr.apm06 ,37,t_azi04),    #No.CHI-6A0004                                                                     
              COLUMN g_c[38],cl_numfor(sr.apm07f,38,t_azi04),    #No.CHI-6A0004                                                                     
              COLUMN g_c[39],cl_numfor(sr.apm07 ,39,t_azi04);    #No.CHI-6A0004 
        LET g_apm06f = g_apm06f + sr.apm06f
        LET g_apm07f = g_apm07f + sr.apm07f
        LET g_qcyef  = g_qcyef  + sr.apm06f - sr.apm07f
        LET g_apm06  = g_apm06  + sr.apm06
        LET g_apm07  = g_apm07  + sr.apm07
        LET g_qcye   = g_qcye   + sr.apm06  - sr.apm07
        IF g_qcyef > 0 THEN
#          PRINT COLUMN 115,g_x[22].substring(1,2),
#                COLUMN 118,cl_numfor(g_qcyef,18,g_azi04),
#                COLUMN 137,cl_numfor(g_qcye ,18,g_azi04)
           PRINT COLUMN g_c[40],g_x[22].substring(1,2),                                                                             
                 COLUMN g_c[41],cl_numfor(g_qcyef,41,t_azi04),    #No.CHI-6A0004                                                                    
                 COLUMN g_c[42],cl_numfor(g_qcye ,42,t_azi04)     #No.CHI-6A0004 
        ELSE
           IF g_qcyef = 0 THEN
#             PRINT COLUMN 115,g_x[22].substring(5,6),
#                   COLUMN 118,cl_numfor(g_qcyef,18,g_azi04),
#                   COLUMN 137,cl_numfor(g_qcye ,18,g_azi04)
              PRINT COLUMN g_c[40],g_x[22].substring(5,6),                                                                          
                    COLUMN g_c[41],cl_numfor(g_qcyef,41,t_azi04),    #No.CHI-6A0004                                                                 
                    COLUMN g_c[42],cl_numfor(g_qcye ,42,t_azi04)     #No.CHI-6A0004 
           ELSE
#             PRINT COLUMN 115,g_x[22].substring(3,4),
#                   COLUMN 118,cl_numfor(g_qcyef*-1,18,g_azi04),
#                   COLUMN 137,cl_numfor(g_qcye *-1,18,g_azi04)
              PRINT COLUMN g_c[40],g_x[22].substring(3,4),                                                                          
                    COLUMN g_c[41],cl_numfor(g_qcyef,41,t_azi04),     #No.CHI-6A0004                                                                
                    COLUMN g_c[42],cl_numfor(g_qcye ,42,t_azi04)       #No.CHI-6A0004 
           END IF
        END IF
     END IF
 
   AFTER GROUP OF sr.apm02  #No.FUN-840076 modify by liuxqa
#    PRINT COLUMN 29,g_x[24] CLIPPED,
#          COLUMN 37,cl_numfor(g_apm06f,18,g_azi04),
#          COLUMN 56,cl_numfor(g_apm06 ,18,g_azi04),
#          COLUMN 75,cl_numfor(g_apm07f,18,g_azi04),
#          COLUMN 94,cl_numfor(g_apm07 ,18,g_azi04);
     PRINT COLUMN g_c[35],g_x[24] CLIPPED,                                                                                          
           COLUMN g_c[36],cl_numfor(g_apm06f,36,t_azi04),     #No.CHI-6A0004                                                                        
           COLUMN g_c[37],cl_numfor(g_apm06 ,37,t_azi04),     #No.CHI-6A0004                                                                        
           COLUMN g_c[38],cl_numfor(g_apm07f,38,t_azi04),     #No.CHI-6A0004                                                                        
           COLUMN g_c[39],cl_numfor(g_apm07 ,39,t_azi04);     #No.CHI-6A0004  
     IF g_qcyef > 0 THEN
#       PRINT COLUMN 115,g_x[22].substring(1,2),
#             COLUMN 118,cl_numfor(g_qcyef,18,g_azi04),
#             COLUMN 137,cl_numfor(g_qcye ,18,g_azi04)
        PRINT COLUMN g_c[40],g_x[22].substring(1,2),                                                                                
              COLUMN g_c[41],cl_numfor(g_qcyef,41,t_azi04),    #No.CHI-6A0004                                                                       
              COLUMN g_c[42],cl_numfor(g_qcye ,42,t_azi04)     #No.CHI-6A0004 
     ELSE
        IF g_qcyef = 0 THEN
#          PRINT COLUMN 115,g_x[22].substring(5,6),
#                COLUMN 118,cl_numfor(g_qcyef,18,g_azi04),
#                COLUMN 137,cl_numfor(g_qcye ,18,g_azi04)
           PRINT COLUMN g_c[40],g_x[22].substring(5,6),                                                                             
                 COLUMN g_c[41],cl_numfor(g_qcyef,41,t_azi04),   #No.CHI-6A0004                                                                     
                 COLUMN g_c[42],cl_numfor(g_qcye ,42,t_azi04)    #No.CHI-6A0004  
        ELSE
#          PRINT COLUMN 115,g_x[22].substring(3,4),
#                COLUMN 118,cl_numfor(g_qcyef*-1,18,g_azi04),
#                COLUMN 137,cl_numfor(g_qcye *-1,18,g_azi04)
           PRINT COLUMN g_c[40],g_x[22].substring(3,4),                                                                             
                 COLUMN g_c[41],cl_numfor(g_qcyef*-1,41,t_azi04),   #No.CHI-6A0004                                                                  
                 COLUMN g_c[42],cl_numfor(g_qcye *-1,42,t_azi04)    #No.CHI-6A0004 
#No.FUN-670107 ------------------end-----------------------------------
        END IF
     END IF
     LET t_qcyef  = t_qcyef  + g_qcyef
     LET t_apm06f = t_apm06f + g_apm06f
     LET t_apm07f = t_apm07f + g_apm07f
     LET t_qcye   = t_qcye   + g_qcye
     LET t_apm06  = t_apm06  + g_apm06
     LET t_apm07  = t_apm07  + g_apm07
     PRINT
 
   ON LAST ROW
#No.FUN-670107 ------------------start----------------------
#     PRINT COLUMN 29,g_x[25] CLIPPED,
#           COLUMN 37,cl_numfor(t_apm06f,18,g_azi04),
#           COLUMN 56,cl_numfor(t_apm06 ,18,g_azi04),
#           COLUMN 75,cl_numfor(t_apm07f,18,g_azi04),
#           COLUMN 94,cl_numfor(t_apm07 ,18,g_azi04);
      PRINT COLUMN g_c[35],g_x[25] CLIPPED,                                                                                         
            COLUMN g_c[36],cl_numfor(t_apm06f,36,t_azi04),     #No.CHI-6A0004                                                                       
            COLUMN g_c[37],cl_numfor(t_apm06 ,37,t_azi04),     #No.CHI-6A0004                                                                       
            COLUMN g_c[38],cl_numfor(t_apm07f,38,t_azi04),     #No.CHI-6A0004                                                                       
            COLUMN g_c[39],cl_numfor(t_apm07 ,39,t_azi04);     #No.CHI-6A0004 
      IF t_qcyef > 0 THEN
#        PRINT COLUMN 115,g_x[22].substring(1,2),
#              COLUMN 118,cl_numfor(t_qcyef,18,g_azi04),
#              COLUMN 137,cl_numfor(t_qcye ,18,g_azi04)
         PRINT COLUMN g_c[40],g_x[22].substring(1,2),                                                                               
               COLUMN g_c[41],cl_numfor(t_qcyef,41,t_azi04),   #No.CHI-6A0004                                                                       
               COLUMN g_c[42],cl_numfor(t_qcye ,42,t_azi04)    #No.CHI-6A0004 
      ELSE
         IF t_qcyef = 0 THEN
#           PRINT COLUMN 115,g_x[22].substring(5,6),
#                 COLUMN 118,cl_numfor(t_qcyef,18,g_azi04),
#                 COLUMN 137,cl_numfor(t_qcye ,18,g_azi04)
            PRINT COLUMN g_c[40],g_x[22].substring(5,6),                                                                            
                  COLUMN g_c[41],cl_numfor(t_qcyef,41,t_azi04),   #No.CHI-6A0004                                                                    
                  COLUMN g_c[42],cl_numfor(t_qcye ,42,t_azi04)    #No.CHI-6A0004 
         ELSE
#           PRINT COLUMN 115,g_x[22].substring(3,4),
#                 COLUMN 118,cl_numfor(t_qcyef*-1,18,g_azi04),
#                 COLUMN 137,cl_numfor(t_qcye *-1,18,g_azi04)
            PRINT COLUMN g_c[40],g_x[22].substring(3,4),                                                                            
                  COLUMN g_c[41],cl_numfor(t_qcyef*-1,41,t_azi04),   #No.CHI-6A0004                                                                 
                  COLUMN g_c[42],cl_numfor(t_qcye *-1,42,t_azi04)    #No.CHI-6A0004  
#No.FUN-670107------------------end------------------------------
         END IF
      END IF
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
 
#Patch....NO.TQC-610037 <001> #
