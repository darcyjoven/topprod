# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gapr912.4gl
# Descriptions...: 供應商業務匯總帳列印
# Date & Author..: 05/04/03 by Jackie
# Modify.........: No.MOD-580154 05/08/19 By CoCo PAGE LENGTH改為 g_page_line
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.FUN-660071 06/06/13 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-670003 06/07/10 By Czl   
# Modify.........: No.FUN-670106 06/08/24 By douzh voucher型報表轉template1
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
 
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.FUN-740064 07/04/17 By lora    會計科目加帳套 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/20 By yinhy 科目查询自动过滤,調整帳套位置
# Modify.........: No:FUN-B80049 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD                         # Print condition RECORD
		wc      LIKE type_file.chr1000, #TQC-5A0134 VARCHAR-->CHAR # Where condition  #NO FUN-690009 VARCHAR(1000)
                a       LIKE type_file.chr1000, #TQC-5A0134 VARCHAR-->CHA  #NO.FUN-690009  VARCHAR(20)     
                yy      LIKE type_file.num5,    #NO.FUN-690009 SMALLINT
                m1      LIKE type_file.num5,    #NO.FUN-690009 SMALLINT
                m2      LIKE type_file.num5,    #NO.FUN-690009 SMALLINT
                o       LIKE aaa_file.aaa01,    #TQC-5A0134 VARCHAR-->CHAR #NO.FUN-670003 
                b       LIKE type_file.chr1000, #TQC-5A0134 VARCHAR-->CHAR #NO.FUN-690009 VARCHAR(01)
                c       LIKE azi_file.azi01,    #TQC-5A0134 VARCHAR-->CHAR #NO.FUN-690009 VARCHAR(4)
                d       LIKE type_file.chr1,    #TQC-5A0134 VARCHAR-->CHAR #NO.FUN-690009 VARCHAR(01)
                e       LIKE type_file.chr1,    #TQC-5A0134 VARCHAR-->CHAR #NO.FUN-690009 VARCHAR(01)
		more    LIKE type_file.chr1     #TQC-5A0134 VARCHAR-->CHAR # Input more condition(Y/N)  #NO FUN-690009 VARCHAR(01)
           END RECORD,
           g_msg    LIKE ze_file.ze03,      #TQC-5A0134 VARCHAR-->CHAR  #NO FUN-690009 VARCHAR(72) 
           g_before_input_done LIKE type_file.num5,      #NO FUN-690009 SMALLINT
           g_null   LIKE type_file.chr1,    #TQC-5A0134 VARCHAR-->CHAR  #NO FUN-690009 VARCHAR(01)
           g_print  LIKE type_file.num5,    #NO FUN-690009 SMALLINT
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
           t_qmye   LIKE apm_file.apm06f,
           t_qmyef  LIKE apm_file.apm06f,
           t_apm06f LIKE apm_file.apm06f,
           t_apm07f LIKE apm_file.apm06f,
           t_apm06  LIKE apm_file.apm06f,
           t_apm07  LIKE apm_file.apm06f
#           g_x      ARRAY[50] OF LIKE type_file.chr1000 #TQC-5A0134 VARCHAR-->CHAR  #NO FUN-690009 VARCHAR(40)
 
DEFINE   g_i  LIKE type_file.num5     #count/index for any purpose   #NO FUN-690009 SMALLINT
 
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
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80049   ADD #FUN-BB0047 mark
 
   INITIALIZE tm.* TO NULL            # Default condition
 
   SELECT aza17 INTO l_aza17 FROM aza_file WHERE aza01 = '0'
   IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF
   SELECT aaz64 INTO l_aaz64 FROM aaz_file WHERE aaz00 = '0'
   #No.FUN-660071  -Begin
   IF SQLCA.sqlcode THEN 
      #CALL cl_err('aaz_file',-100,0) 
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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add 
   #No.FUN-660071  -Begin
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
  LET g_rep_user = ARG_VAL(16)
  LET g_rep_clas = ARG_VAL(17)
  LET g_template = ARG_VAL(18)
  #-----END TQC-610053-----
 
    #No.FUN-740064  --Begin                                                                                                          
   IF cl_null(tm.o) THEN LET tm.o=g_aza.aza81 END IF                                                                                
   #No.FUN-740064  --End   
   IF cl_null(tm.wc) THEN
       CALL gapr912_tm(0,0)             # Input print condition
   ELSE
       CALL gapr912()   #TQC-610053
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
END MAIN
 
FUNCTION gapr912_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE li_chk_bookno  LIKE type_file.num5      #No.FUN-670003 SMALLINT  #NO FUN-690009
   DEFINE p_row,p_col    LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_n            LIKE type_file.num5,     #NO FUN-690009 SMALLINT
          l_flag         LIKE type_file.chr1,     #NO FUN-690009 VARCHAR(1000)
          l_cmd          LIKE type_file.chr1000   #TQC-5A0134 VARCHAR-->CHAR   #NO FUN-690009
 
   LET p_row = 4 LET p_col =25
 
   OPEN WINDOW gapr912_w AT p_row,p_col WITH FORM "gap/42f/gapr912" 
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
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   LET tm.o = g_aza.aza81   #No.FUN-740064
   DISPLAY BY NAME tm.a,tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.c,tm.d,tm.more
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
      CLOSE WINDOW gapr912_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #INPUT BY NAME tm.a,tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.c,tm.d,tm.more 
   INPUT BY NAME tm.o,tm.a,tm.yy,tm.m1,tm.m2,tm.b,tm.c,tm.d,tm.more 
   WITHOUT DEFAULTS 
      
      BEFORE INPUT
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
         CALL cl_set_comp_entry("c",FALSE)
 
         #No.FUN-580031 --start--
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
        LET l_flag = 0 
        #No.FUN-B10053  --Begin
        #IF NOT cl_null(tm.a) THEN
        #   SELECT COUNT(*) INTO l_n FROM aag_file
        #    WHERE aag01 = tm.a   
        #      AND aag00 = tm.o    #No.FUN-740064 
        #     AND ( aag07 ='2' or aag07='3')
        #   IF l_n = 0 THEN
        #      CALL cl_err(tm.a,'aap-021',0)
        #      NEXT FIELD a     
        #   ELSE
        #      SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = tm.a
        #                                                AND aag00 = tm.o  #No.FUN-740064
        #   END IF
        IF NOT cl_null(tm.a) THEN
           CALL gapr912_a(tm.a,tm.o)
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
 
     AFTER FIELD m2
        IF NOT cl_null(tm.m2) THEN 
           IF tm.m2>13 OR tm.m2<1 THEN
              CALL cl_err(tm.m1,'agl-013',0)
              NEXT FIELD m2 
           END IF
           IF tm.m2 < tm.m1 THEN
           CALL cl_err('','agl-157',0)
           NEXT FIELD m1
           END IF
        END IF
 
     AFTER FIELD o
     #No.FUN-670003--begin                                                                                                       
        CALL s_check_bookno(tm.o,g_user,g_plant)                                                                                    
             RETURNING li_chk_bookno          
        IF cl_null(tm.o) THEN NEXT FIELD o  END IF  #No.FUN-740064                                                                                      
 
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
           CALL gapr912_a(tm.a,tm.o)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(tm.a,g_errno,0)
              NEXT FIELD a
           END IF
        END IF
        #No.FUN-B10053 --End
        SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF   #使用本國幣別
 
     ON CHANGE b
        LET l_flag=1
        IF tm.b='Y' THEN
           CALL cl_set_comp_entry("c",TRUE)
           NEXT FIELD c
        END IF
        IF tm.b='N' THEN
           LET tm.c=""
           DISPLAY BY NAME tm.c
           CALL cl_set_comp_entry("c",FALSE)
        END IF
  
      BEFORE FIELD c
        IF l_flag = 1 THEN
           IF tm.b = 'N' THEN NEXT FIELD d END IF
        ELSE
           IF l_flag = 2 THEN
              IF tm.b = 'N' THEN NEXT FIELD o END IF
           END IF
        END IF
 
     AFTER FIELD d
        LET l_flag = 2
        IF tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
 
     AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF 
 
      AFTER INPUT
        IF tm.b='Y' AND cl_null(tm.c) THEN
           CALL cl_getmsg('gap-001',g_lang) RETURNING g_msg
           MESSAGE g_msg
           NEXT FIELD c
        ELSE 
           MESSAGE ""
        END IF
 
     ON ACTION CONTROLP                                                       
        CASE
           WHEN INFIELD(a)     #科目代號                               
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aag'
              LET g_qryparam.default1 = tm.a
              LET g_qryparam.arg1 = tm.o    #No.FUN-740064 
              CALL cl_create_qry() RETURNING tm.a 
              DISPLAY BY NAME tm.a                               
              NEXT FIELD a
 
           WHEN INFIELD(c)     #科目代號                               
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 = tm.c
              CALL cl_create_qry() RETURNING tm.c
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
 
     ON ACTION CONTROLT
       LET g_trace = 'Y'     #TRACE ON
    
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
      CLOSE WINDOW gapr912_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gapr912'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gapr912','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         IF g_trace = 'Y' THEN ERROR l_cmd END IF
         CALL cl_cmdat('gapr912',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gapr912_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gapr912()
   ERROR ""
END WHILE
   CLOSE WINDOW gapr912_w
END FUNCTION
 
FUNCTION gapr912()
   DEFINE l_name    LIKE type_file.chr20,   #TQC-5A0134 VARCHAR-->CHAR VARCHAR(20)  # External(Disk) file name    #NO FUN-690009
#       l_time          LIKE type_file.chr8        #No.FUN-6A0097
          l_sql     LIKE type_file.chr1000, #TQC-5A0134 VARCHAR-->CHAR VARCHAR(1000)#NO.FUN-690009 VARCHAR(1000) 
          l_sql1    LIKE type_file.chr1000, #TQC-5A0134 VARCHAR-->CHAR VARCHAR(1000)#NO.FUN-690009 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000, #NO FUN-690009#TQC-5A0134 VARCHAR-->CHAR  #NO FUN-690009 VARCHAR(40)
          l_i       LIKE type_file.num5,    #NO FUN-690009   #NO FUN-690009 SMALLINT
          l_qcyef   LIKE apm_file.apm06f,
          l_qcye    LIKE apm_file.apm06f,
          l_qcyeo   LIKE apm_file.apm06f,                                       
          l_qcyefo  LIKE apm_file.apm06f, 
          m_apm06f  LIKE apm_file.apm06f,
          m_apm07f  LIKE apm_file.apm07f,
          m_apm06   LIKE apm_file.apm06f,
          m_apm07   LIKE apm_file.apm07f,
          m_ooo09c  LIKE ooo_file.ooo09c,                                       
          m_ooo09d  LIKE ooo_file.ooo09d,                                       
          m_ooo08c  LIKE ooo_file.ooo08c,                                       
          m_ooo08d  LIKE ooo_file.ooo08d,  
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
                    prt      LIKE type_file.chr1    #TQC-5A0134 VARCHAR-->CHAR #NO FUN-690009 VARCHAR(01)
                    END RECORD
 
     #No.FUN-BB0047--mark--Begin---
     # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End----- 
     CALL cl_outnam('gapr912') RETURNING l_name
#FUN-670106--begin
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file #列印選擇條件否、報表寬度
#      WHERE zz01 = 'gapr912'   #程序資料檔
#    IF g_len = 0 OR g_len IS NULL THEN 
#       IF tm.b = 'N' THEN
#          LET g_len = 130
#       ELSE
#          LET g_len = 191
#       END IF
#    END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#FUN-670106--end
     IF tm.b = 'Y' THEN
        LET g_aza17 = tm.c
     ELSE
        LET g_aza17 = l_aza17
     END IF
     SELECT azi04 INTO t_azi04
       FROM azi_file WHERE azi01=g_aza17                     #No.CHI-6A0004
     IF SQLCA.sqlcode THEN
        #CALL cl_err('azi04',SQLCA.sqlcode,0)  #No.FUN-660071
        CALL cl_err3("sel","azi_file",g_aza17,"",SQLCA.sqlcode,"","azi04",0) #No.FUN-660071
     END IF
     LET l_sql = " SELECT UNIQUE apm01,apm02 FROM apm_file ",
                 "  WHERE apm00 = '",tm.a    CLIPPED,"'",
                 "    AND apm08 = '",g_plant CLIPPED,"'",
                 "    AND apm09 = '",tm.o    CLIPPED,"'",
                 "    AND ",tm.wc CLIPPED
     IF tm.b = 'Y' THEN
        LET l_sql = l_sql CLIPPED," AND apm11 = '",g_aza17 CLIPPED,"'"
     END IF
     PREPARE gapr912_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time            #FUN-B80049   ADD 
        EXIT PROGRAM 
     END IF
     DECLARE gapr912_curs1 CURSOR FOR gapr912_pr1
 
 
     IF tm.b = 'N' THEN   #本幣
        START REPORT gapr912_rep TO l_name                                      
        LET g_pageno = 0 
     ELSE                 #原幣
        START REPORT gapr912_rep1 TO l_name                                     
     END IF
     LET g_pageno  = 0                                                         
     LET t_apm06 = 0                                                            
     let t_apm06f = 0                                                           
     LET t_apm07 = 0                                                            
     let t_apm07f = 0                                                           
     LET t_qcye  = 0                                                            
     let t_qcyef = 0                                                            
     LET t_qmye  = 0                                                            
     let t_qmyef = 0
#FUN-670106--begin
     IF tm.b='N' THEN
        LET g_zaa[34].zaa06='N'
        LET g_zaa[35].zaa06='N'
        LET g_zaa[36].zaa06='N'
        LET g_zaa[37].zaa06='N'
        LET g_zaa[38].zaa06='N'
        LET g_zaa[39].zaa06='Y'
        LET g_zaa[40].zaa06='Y'
        LET g_zaa[41].zaa06='Y'
        LET g_zaa[42].zaa06='Y'
        LET g_zaa[43].zaa06='Y'
        LET g_zaa[44].zaa06='Y'
        LET g_zaa[45].zaa06='Y'
        LET g_zaa[46].zaa06='Y'
        LET g_zaa[47].zaa06='Y'
        LET g_zaa[48].zaa06='N'
     ELSE
        LET g_zaa[34].zaa06='Y'
        LET g_zaa[35].zaa06='Y'
        LET g_zaa[36].zaa06='Y'
        LET g_zaa[37].zaa06='Y'
        LET g_zaa[38].zaa06='Y'
        LET g_zaa[39].zaa06='N'
        LET g_zaa[40].zaa06='N'
        LET g_zaa[41].zaa06='N'
        LET g_zaa[42].zaa06='N'
        LET g_zaa[43].zaa06='N'
        LET g_zaa[44].zaa06='N'
        LET g_zaa[45].zaa06='N'
        LET g_zaa[46].zaa06='N'
        LET g_zaa[47].zaa06='N'
        LET g_zaa[48].zaa06='N'
     END IF    
     CALL cl_prt_pos_len()    
 #FUN-670106--end
 
     FOREACH gapr912_curs1 INTO sr1.*
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
 
       #add by sam for kc 050226                                                
       IF cl_null(l_qcyefo)  THEN LET l_qcyefo  = 0 END IF                      
       IF cl_null(l_qcyeo )  THEN LET l_qcyeo   = 0 END IF                      
       IF cl_null(m_ooo08c)  THEN LET m_ooo08c  = 0 END IF                      
       IF cl_null(m_ooo08d)  THEN LET m_ooo08d  = 0 END IF                     
       IF cl_null(m_ooo09c)  THEN LET m_ooo09c  = 0 END IF                      
       IF cl_null(m_ooo09d)  THEN LET m_ooo09d  = 0 END IF                      
       LET l_qcyef = l_qcyef+l_qcyefo                                           
       LET l_qcye  = l_qcye + l_qcyeo                                           
       LET m_apm06f = m_apm06f + m_ooo08d                                       
       LET m_apm06  = m_apm06 + m_ooo09d                                        
       LET m_apm07f = m_apm07f + m_ooo08c                                       
       LET m_apm07  = m_apm07 + m_ooo09c                                        
       #end add             
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
          LET sr.apm01  = sr1.apm01
          LET sr.apm02  = sr1.apm02
          LET sr.apm04  = tm.yy
          LET sr.apm06f = m_apm06f
          LET sr.apm07f = m_apm07f
          LET sr.apm06  = m_apm06
          LET sr.apm07  = m_apm07
          LET sr.qcye   = l_qcye
          LET sr.qcyef  = l_qcyef
          LET sr.prt    = '0'
          IF tm.b = 'N' THEN   #本幣
             OUTPUT TO REPORT gapr912_rep(sr.*)
          ELSE                 #原幣
             OUTPUT TO REPORT gapr912_rep1(sr.*)
          END IF                                                                     
          CONTINUE FOREACH
     END FOREACH 
 
     IF tm.b = 'N' THEN   #本幣
        FINISH REPORT gapr912_rep
     ELSE                 #原幣
        FINISH REPORT gapr912_rep1
     END IF                                                                     
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0097
     #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-B10053  --Begin
FUNCTION gapr912_a(p_key,p_bookno)
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
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#No.FUN-B10053  --End 
 
REPORT gapr912_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1   #TQC-5A0134 VARCHAR-->CHAR #NO FUN-690009 VARCHAR(1) 
   DEFINE l_qmye    LIKE apm_file.apm06f
   DEFINE l_qmyef   LIKE apm_file.apm06f
   define l_pmc081  like pmc_file.pmc081,
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
                        prt      LIKE type_file.chr1    #NO FUN-690009 VARCHAR(1)
                    END RECORD
   DEFINE g_k      LIKE cre_file.cre08    #NO FUN-690009  VARCHAR(10)
   OUTPUT TOP MARGIN g_top_margin 
   LEFT MARGIN g_left_margin 
   BOTTOM MARGIN g_bottom_margin 
   PAGE LENGTH g_page_line 
   ORDER BY sr.apm01,sr.apm02,sr.apm04,sr.apm05
   FORMAT
   PAGE HEADER 
#FUN-670106--begin
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
 
      LET g_pageno = g_pageno + 1 
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
 
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
#FUN-670106--end
#     LET g_pageno = g_pageno + 1
#     PRINT ' '                                    #FUN-670106
      PRINT COLUMN 01,g_x[11] CLIPPED,
            l_aag02 CLIPPED,'(',tm.a CLIPPED,')'
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,
      PRINT COLUMN 01,g_x[27] CLIPPED,
            tm.yy USING '&&&&','/',tm.m1 USING '&&','-',
            tm.yy USING '&&&&','/',tm.m2 USING '&&',
            COLUMN 30,g_x[26] CLIPPED,tm.o
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<' 
     PRINT g_dash[1,g_len]
#FUN-670106-begin
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                     g_x[36],g_x[37],g_x[38],g_x[48]
      PRINT g_dash1   
#     PRINT'---------- ---------- ---- --------------- ----------------- ----------------- ---- ---------------- ----------------------------'
#FUN-670106--end
      LET l_last_sw ='n'
 
  ON EVERY ROW
     LET l_qmye = sr.qcye + sr.apm06 - sr.apm07 
     LET t_qcye = t_qcye + sr.qcye
     LET t_apm06 = t_apm06 + sr.apm06
     let t_apm07 = t_apm07 + sr.apm07
     let t_qmye  = t_qmye + l_qmye
     let g_k = g_x[22]
     select pmc081 into l_pmc081
      from pmc_file
     where pmc01=sr.apm01
#FUN-670106--begin 
     PRINTX name=D1 COLUMN g_c[31],sr.apm01 CLIPPED,
                    COLUMN g_c[32],sr.apm02 CLIPPED;
     IF sr.qcye > 0 THEN 
     PRINTX name=D1  COLUMN g_c[33],g_k[1,2], 
                     COLUMN g_c[34],cl_numfor(sr.qcye,34,t_azi04) CLIPPED;     #No.CHI-6A0004 
     END IF 
     IF sr.qcye = 0 THEN
      PRINTX name=D1 COLUMN g_c[33],g_k[5,6],                                            
                     COLUMN g_c[34],cl_numfor(sr.qcye,34,t_azi04) CLIPPED;      #No.CHI-6A0004 
     END IF  
     IF sr.qcye < 0 THEN                                                        
      PRINTX name=D1 COLUMN g_c[33],g_k[3,4],                                             
                     COLUMN g_c[34],cl_numfor(sr.qcye*-1,34,t_azi04) CLIPPED;   #No.CHI-6A0004                                        
     END IF   
     PRINTX name=D1 COLUMN g_c[35],cl_numfor(sr.apm06,35,t_azi04) CLIPPED,      #No.CHI-6A0004 
                    COLUMN g_c[36],cl_numfor(sr.apm07,36,t_azi04) CLIPPED;      #No.CHI-6A0004 
     IF l_qmye > 0 THEN
     PRINTX name=D1 COLUMN g_c[37],g_k[1,2], 
                    COLUMN g_c[38],cl_numfor(l_qmye,38,t_azi04);        #No.CHI-6A0004 
     END IF 
     IF l_qmye =  0 THEN
       PRINTX name=D1 COLUMN g_c[37],g_k[5,6],
                      COLUMN g_c[38],cl_numfor(l_qmye,38,t_azi04);      #No.CHI-6A0004 
     END IF
     IF l_qmye <  0 THEN                                                        
       PRINTX name=D1 COLUMN g_c[37],g_k[3,4],                                            
                      COLUMN g_c[38],cl_numfor(l_qmye*-1,38,t_azi04);    #No.CHI-6A0004 
     END IF 
     PRINT COLUMN 114,l_pmc081
#FUN-670106--end 
 
   ON LAST ROW
 #    PRINT'                      ---- --------------- ----------------- ----------------- ---- ---------------- ----------------------------'
      PRINT g_dash2
#FUN-670106--begin
#      PRINT COLUMN 01,g_x[25] CLIPPED;
      PRINTX name=D1 COLUMN g_c[31],g_x[25] CLIPPED; 
      IF t_qcye > 0 THEN
      PRINTX name=D1 COLUMN g_c[33],g_k[1,2],
                     COLUMN g_c[34],cl_numfor(t_qcye,34,t_azi04);     #No.CHI-6A0004 
      END IF
      IF t_qcye = 0 THEN                                                        
      PRINTX name=D1 COLUMN g_c[33],g_k[5,6],                                             
                     COLUMN g_c[34],cl_numfor(t_qcye,34,t_azi04);     #No.CHI-6A0004                            
      END IF 
      IF t_qcye < 0 THEN                                                        
      PRINTX name=D1 COLUMN g_c[33],g_k[3,4],                                             
                     COLUMN g_c[34],cl_numfor(t_qcye*-1,34,t_azi04);   #No.CHI-6A0004 
      END IF    
      PRINTX name=D1 COLUMN g_c[35],cl_numfor(t_apm06,35,t_azi04),     #No.CHI-6A0004 
                     COLUMN g_c[36],cl_numfor(t_apm07,36,t_azi04);     #No.CHI-6A0004 
      IF t_qmye > 0 THEN
         PRINTX name=D1 COLUMN g_c[37],g_k[1,2],
                        COLUMN g_c[38],cl_numfor(t_qmye,38,t_azi04)     #No.CHI-6A0004 
      ELSE 
         IF t_qmye = 0 THEN
            PRINTX name=D1 COLUMN g_c[37],g_k[5,6],
                           COLUMN g_c[38],cl_numfor(t_qmye,38,t_azi04)    #No.CHI-6A0004 
         ELSE
            PRINTX name=D1 COLUMN g_c[37],g_k[3,4],
                           COLUMN g_c[38],cl_numfor(t_qmye*-1,38,t_azi04)    #No.CHI-6A0004 
         END IF
      END IF
#FUN-670106--end
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'                                                       
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED             
    PAGE TRAILER                                                                
      IF l_last_sw = 'n' THEN                                                   
         PRINT g_dash[1,g_len]                                             
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED     
      ELSE
         SKIP 2 LINE                                                       
      END IF                                                              
 
END REPORT
 
REPORT gapr912_rep1(sr)
   DEFINE l_last_sw  LIKE type_file.chr1,  #TQC-5A0134 VARCHAR-->CHAR #NO FUN-690009 VARCHAR(1)
          l_qmye     LIKE apm_file.apm06f,
          l_qmyef    LIKE apm_file.apm06f, 
          l_pmc081   like pmc_file.pmc081, 
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
DEFINE g_j              LIKE cre_file.cre08    #NO FUN-690009  VARCHAR(10)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line 
  ORDER BY sr.apm01,sr.apm02,sr.apm04,sr.apm05
  FORMAT
   PAGE HEADER
#FUN-670106--begin  
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
 
      LET  g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
#     PRINT '  ' 
#     LET g_pageno = g_pageno + 1
#FUN-670106--end  
      PRINT COLUMN 01,g_x[11] CLIPPED,
            l_aag02 CLIPPED,'(',tm.a CLIPPED,')'
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,   #FUN-670106
      PRINT COLUMN 01,g_x[27] CLIPPED,
            tm.yy USING '&&&&','/',tm.m1 USING '&&','-',
            tm.yy USING '&&&&','/',tm.m2 USING '&&',
            COLUMN 32,g_x[12] CLIPPED,g_aza17 CLIPPED,' ',
            COLUMN 47,g_x[26] CLIPPED,tm.o
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<' #FUN-670106 
      PRINT g_dash[1,g_len]
#FUN-670106--begin
#     PRINT g_x[34],g_x[35], g_x[36],g_x[47]
#     PRINT '                           -------------------------------  -------------------------------  -------------------------------        -------------------------------'
      PRINT g_x[31],g_x[32],g_x[33],g_x[39],g_x[40],g_x[41],g_x[42],
                    g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48]
      PRINT g_dash1
#     PRINT '---------- ---------- ---- --------------- ---------------  --------------- ---------------  --------------- ---------------   ---- --------------- ---------------  --------------------------'
#FUN-670106--end   
      LET l_last_sw ='n'
   
  ON EVERY ROW
     LET l_qmye = sr.qcye + sr.apm06 - sr.apm07                                 
     LET l_qmyef = sr.qcyef + sr.apm06f - sr.apm07f 
     LET t_qcye = t_qcye + sr.qcye                                              
     let t_qcyef = t_qcyef + sr.qcyef 
     LET t_apm06 = t_apm06 + sr.apm06                                           
     let t_apm06f = t_apm06f + sr.apm06f 
     let t_apm07 = t_apm07 + sr.apm07                                           
     let t_apm07f = t_apm07f + sr.apm07f
     let t_qmye  = t_qmye + l_qmye                                              
     let t_qmyef = t_qmyef + l_qmyef   
     let g_j=g_x[22]
                                                                        
     select pmc081 into l_pmc081 
      from pmc_file
      where pmc01 = sr.apm01
#FUN-670106--begin
     PRINT COLUMN g_c[31],sr.apm01 CLIPPED,                                          
           COLUMN g_c[32],sr.apm02 CLIPPED;                                         
     IF sr.qcye > 0 THEN                                                        
     PRINT COLUMN g_c[33],g_j[1,2],                             
           COLUMN g_c[39],cl_numfor(sr.qcyef,39,t_azi04) CLIPPED,      #No.CHI-6A0004 
           COLUMN g_c[40],cl_numfor(sr.qcye,40,t_azi04) CLIPPED;       #No.CHI-6A0004               
     END IF                                                                     
     IF sr.qcye = 0 THEN                                                        
      PRINT COLUMN g_c[33],g_j[5,6],                                    
            COLUMN g_c[39],cl_numfor(sr.qcyef,39,t_azi04) CLIPPED,     #No.CHI-6A0004                
            COLUMN g_c[40],cl_numfor(sr.qcye,40,t_azi04) CLIPPED;      #No.CHI-6A0004 
     END IF                                                                     
     IF sr.qcye < 0 THEN                                                        
      PRINT COLUMN g_c[33],g_j[3,4],                                     
            COLUMN g_c[39],cl_numfor(sr.qcyef*-1,39,t_azi04) CLIPPED,     #No.CHI-6A0004   
            COLUMN g_c[40],cl_numfor(sr.qcye*-1,40,t_azi04);              #No.CHI-6A0004 
      END IF      
     PRINT COLUMN g_c[41],cl_numfor(sr.apm06f,41,t_azi04) CLIPPED,        #No.CHI-6A0004 
           COLUMN g_c[42],cl_numfor(sr.apm06,42,t_azi04),                 #No.CHI-6A0004            
           COLUMN g_c[43],cl_numfor(sr.apm07f,43,t_azi04) CLIPPED,        #No.CHI-6A0004 
           COLUMN g_c[44],cl_numfor(sr.apm07,44,t_azi04);                #No.CHI-6A0004             
     IF l_qmye > 0 THEN                                                         
     PRINT COLUMN g_c[45],g_j[1,2],      
           COLUMN g_c[46],cl_numfor(l_qmyef,46,t_azi04),              #No.CHI-6A0004  
           COLUMN g_c[47],cl_numfor(l_qmye,47,t_azi04);               #No.CHI-6A0004 
     END IF                                                                     
     IF l_qmye =  0 THEN                                                        
       PRINT COLUMN g_c[45],g_j[5,6],  
             COLUMN g_c[46],cl_numfor(l_qmyef,46,t_azi04),         #No.CHI-6A0004 
             COLUMN g_c[47],cl_numfor(l_qmye,47,t_azi04);           #No.CHI-6A0004 
                             
     END IF                                                                     
     IF l_qmye <  0 THEN                                                        
       PRINT  COLUMN g_c[45],g_j[3,4],   
              COLUMN g_c[46],cl_numfor(l_qmyef*-1,46,t_azi04),     #No.CHI-6A0004 
              COLUMN g_c[47],cl_numfor(l_qmye*-1,47,t_azi04);      #No.CHI-6A0004                      
     END IF   
     PRINT COLUMN g_c[48],l_pmc081 
 
  ON LAST ROW
#     PRINT '---------- ---------- ---- --------------- ---------------  --------------- ---------------  --------------- ---------------   ---- --------------- ---------------  --------------------------' 
      PRINT g_dash2
#      PRINT COLUMN 01,g_x[25] CLIPPED;                                          
      PRINT COLUMN g_c[31],g_x[25] CLIPPED;
      IF t_qcye > 0 THEN                                                        
      PRINT COLUMN g_c[33],g_j[1,2],                                             
            COLUMN g_c[39],cl_numfor(t_qcyef,39,t_azi04),      #No.CHI-6A0004 
            COLUMN g_c[40],cl_numfor(t_qcye,40,t_azi04);       #No.CHI-6A0004                         
      END IF                                                                    
      IF t_qcye = 0 THEN                                                        
      PRINT COLUMN g_c[33],g_j[5,6],                                             
            COLUMN g_c[39],cl_numfor(t_qcyef,39,t_azi04),        #No.CHI-6A0004 
            COLUMN g_c[40],cl_numfor(t_qcye,40,t_azi04);         #No.CHI-6A0004     
      END IF                                                                    
      IF t_qcye < 0 THEN                                                        
      PRINT COLUMN g_c[33],g_j[3,4],                                             
            COLUMN g_c[39],cl_numfor(t_qcyef*-1,39,t_azi04),      #No.CHI-6A0004 
            COLUMN g_c[40],cl_numfor(t_qcye*-1,40,t_azi04);       #No.CHI-6A0004                     
      END IF                                                                    
      PRINT COLUMN g_c[41],cl_numfor(t_apm06f,41,t_azi04),       #No.CHI-6A0004 
            COLUMN g_c[42],cl_numfor(t_apm06,42,t_azi04),        #No.CHI-6A0004                      
            COLUMN g_c[43],cl_numfor(t_apm07f,43,t_azi04),       #No.CHI-6A0004 
            COLUMN g_c[44],cl_numfor(t_apm07,44,t_azi04);        #No.CHI-6A0004 
     IF t_qmyef > 0 THEN
        PRINT COLUMN g_c[45],g_j[1,2],
              COLUMN g_c[46],cl_numfor(t_qmyef,46,t_azi04),      #No.CHI-6A0004 
              COLUMN g_c[47],cl_numfor(t_qmye,47,t_azi04)         #No.CHI-6A0004 
      ELSE 
         IF t_qmyef = 0 THEN
            PRINT COLUMN g_c[45],g_j[5,6],
                  COLUMN g_c[46],cl_numfor(t_qmyef,46,t_azi04),      #No.CHI-6A0004 
                  COLUMN g_c[47],cl_numfor(t_qmye,47,t_azi04)        #No.CHI-6A0004 
         ELSE
            PRINT COLUMN g_c[45],g_j[3,4],
                  COLUMN g_c[46],cl_numfor(t_qmyef*-1,46,t_azi04),    #No.CHI-6A0004 
                  COLUMN g_c[47],cl_numfor(t_qmye*-1,47,t_azi04)      #No.CHI-6A0004  
         END IF
      END IF
#FUN-670106-end
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
