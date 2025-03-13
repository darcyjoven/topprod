# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: gxrr712.4gl
# Descriptions...: 客戶業務彙總帳列印
# Date & Author..: 05/04/05 by Trisy
# Modify.........: No.MOD-580154 05/08/19 By CoCo PAGE LENGTH改為 g_page_line
# Modify.........: No.FUN-580110 05/08/23 By jackie 報表轉XML格式
# Modify.........: No.MOD-580255 05/09/08 By Smapmin 選擇列印原幣,期初餘額為0
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670003 06/07/10 By Czl  帳別權限修改
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740009 07/04/03 By Judy 會計科目加帳套
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/21 By yinhy 科目查询自动过滤
# Modify.........: No.FUN-B80036 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm        RECORD                            # Print condition RECORD
		 wc      LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(1000)          # Where condition
                 a       LIKE type_file.chr20,        #NO.FUN-680145 VARCHAR(20)
                 yy      LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
                 m1      LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
                 m2      LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
                 o       LIKE aaa_file.aaa01,         #FUN-670003
                 b       LIKE type_file.chr1,         #NO.FUN-680145 VARCHAR(01)
                 c       LIKE aza_file.aza17,         #NO.FUN-680145 VARCHAR(4)
                 d       LIKE type_file.chr1,         #NO.FUN-680145 VARCHAR(01)
 		 more    LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)            # Input more condition(Y/N)
                 END RECORD,
       g_bookno   LIKE aah_file.aah00,  #帳別   #TQC-610056
       g_msg      LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(72)       
       g_before_input_done LIKE type_file.num5,         #NO.FUN-680145 
       g_d       LIKE type_file.chr1,         #NO.FUN-680145 VARCHAR(01)
       g_null    LIKE type_file.chr1,         #NO.FUN-680145 VARCHAR(01)
       g_print   LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
       g_aza17   LIKE aza_file.aza17,
       l_aza17   LIKE aza_file.aza17,
       l_aag02   LIKE aag_file.aag02,
       g_qcyef   LIKE ooo_file.ooo08d,
       g_qcye    LIKE ooo_file.ooo08d,
       g_ooo08_l LIKE ooo_file.ooo08d,
       g_ooo08_r LIKE ooo_file.ooo08d,
       g_ooo09_l LIKE ooo_file.ooo08d,
       g_ooo09_r LIKE ooo_file.ooo08d,
       t_qcyef   LIKE ooo_file.ooo08d,
       t_qcye    LIKE ooo_file.ooo08d,
       t_qmye    LIKE ooo_file.ooo08d,     
       t_qmyef   LIKE ooo_file.ooo08d,     
       t_ooo08_l LIKE ooo_file.ooo08d,
       t_ooo08_r LIKE ooo_file.ooo08d,
       t_ooo09_l LIKE ooo_file.ooo08d,
       t_ooo09_r LIKE ooo_file.ooo08d
 
DEFINE   g_i              LIKE type_file.num5   #NO.FUN-680145 SMALLINT        #count/index for any purpose
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GXR")) THEN
      EXIT PROGRAM
   END IF
  CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-B80036 ADD
  #-----TQC-610056---------
  LET g_bookno= ARG_VAL(1)
  LET g_pdate  = ARG_VAL(2)                # Get arguments from command line
  LET g_towhom = ARG_VAL(3)
  LET g_rlang  = ARG_VAL(4)
  LET g_bgjob  = ARG_VAL(5)
  LET g_prtway = ARG_VAL(6)
  LET g_copies = ARG_VAL(7)
  LET tm.wc = ARG_VAL(8)
  LET tm.a = ARG_VAL(9)
  LET tm.yy = ARG_VAL(10)
  LET tm.m1 = ARG_VAL(11)
  LET tm.m2 = ARG_VAL(12)
  LET tm.o = ARG_VAL(13)
  LET tm.b = ARG_VAL(14)
  LET tm.c = ARG_VAL(15)
  LET tm.d = ARG_VAL(16)
  #-----END TQC-610056-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL gxrr712_tm(0,0)                  # Input print condition
   ELSE
      CALL gxrr712()
   END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
END MAIN
 
FUNCTION gxrr712_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE li_chk_bookno  LIKE type_file.num5          #NO.FUN-680145 SMALLINT
   DEFINE p_row,p_col    LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
          l_n            LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
          l_flag         LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000       #NO.FUN-680145 VARCHAR(1000)
 
   LET p_row = 4 
   LET p_col =25
 
   OPEN WINDOW gxrr712_w AT p_row,p_col WITH FORM "gxr/42f/gxrr712" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  # Default condition
   SELECT ool11 INTO tm.a FROM ooz_file,ool_file
     WHERE ooz00 = '0' AND ool01 = ooz08
   LET tm.yy = YEAR(g_today)
   LET tm.m1 = MONTH(g_today)
   LET tm.m2 = MONTH(g_today)
   LET tm.o  = g_ooz.ooz02b
   LET tm.b = 'N'
   LET tm.c = ''
   LET tm.d = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooo01 
 
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
          LET INT_FLAG = 0 CLOSE WINDOW gxrr712_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
          EXIT PROGRAM
       END IF
 
   IF tm.wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   #INPUT BY NAME tm.a,tm.yy,tm.m1,tm.m2,tm.o,tm.b,tm.c,tm.d,tm.more 
   INPUT BY NAME tm.o,tm.a,tm.yy,tm.m1,tm.m2,tm.b,tm.c,tm.d,tm.more 
   WITHOUT DEFAULTS
 
     BEFORE INPUT              
         #No.FUN-580031 --start--
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         LET g_before_input_done = FALSE  
         LET g_before_input_done = TRUE     
         CALL cl_set_comp_entry("c",FALSE) 
 
     AFTER FIELD a
        LET l_flag = 0
        IF cl_null(tm.a) THEN
           NEXT FIELD a
        ELSE 
           SELECT aag02 INTO l_aag02 FROM aag_file
             WHERE aag01 = tm.a AND aag07 IN ('2','3') 
               AND aag00 = tm.o    #FUN-740009
           IF STATUS THEN 
#             CALL cl_err(tm.a,'mfg1004',0)        #No.FUN-660146
              CALL cl_err3("sel","aag_file",tm.a,"","mfg1004","","",0)   #No.FUN-660146
              #No.FUN-B10053  --Begin
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_aag"
              LET g_qryparam.construct = 'N'
              LET g_qryparam.default1 = tm.a
              LET g_qryparam.arg1 = tm.o
              LET g_qryparam.where = " aag07 IN ('2','3') AND aagacti='Y' AND aag01 LIKE '",tm.a CLIPPED,"%'"
              CALL cl_create_qry() RETURNING tm.a
              DISPLAY BY NAME tm.a
              #No.FUN-B10053  --Begin
              NEXT FIELD a 
           END IF   
        END IF  
 
     
     AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.m1 > 12 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF tm.m1 > 13 OR tm.m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#        IF tm.m1 > 13 OR tm.m1 < 1 THEN 
#           NEXT FIELD m1 
#        END IF
#No.TQC-720032 -- end --
 
     AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.m2 > 12 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF tm.m2 > 13 OR tm.m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#        IF tm.m2 > 13 OR tm.m2 < 1 OR tm.m2 < tm.m1 THEN 
#           NEXT FIELD m2 
#        END IF
#No.TQC-720032 -- end --
     AFTER FIELD o
        IF cl_null(tm.o) THEN NEXT FIELD o END IF
        #No.FUN-670003--begin
        CALL s_check_bookno(tm.o,g_user,g_plant) 
             RETURNING li_chk_bookno
        IF (NOT li_chk_bookno) THEN
             NEXT FIELD o
        END IF 
        #No.FUN-B10053  --Begin
        IF NOT cl_null(tm.a) THEN
           SELECT aag02 INTO l_aag02 FROM aag_file
             WHERE aag01 = tm.a AND aag07 IN ('2','3')
               AND aag00 = tm.o
           IF STATUS THEN
              CALL cl_err3("sel","aag_file",tm.a,"","mfg1004","","",0)
              NEXT FIELD tm.a
           END IF
        END IF
        #No.FUN-B10053  --End
        SELECT * FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN 
#          CALL cl_err(tm.o,'aap-229',0)   #No.FUN-660146
           CALL cl_err3("sel","aaa_file",tm.o,"","aap-229","","",0)   #No.FUN-660146
           NEXT FIELD o  
        END IF
        SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
        IF SQLCA.sqlcode THEN LET l_aza17 = g_aza.aza17 END IF   #使用本國幣別
 
     ON CHANGE b                
        LET l_flag=1            
        IF tm.b='Y' THEN        
           CALL cl_set_comp_entry("c",TRUE)
           LET tm.c = g_aza.aza17   
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
        ELSE IF l_flag = 2 THEN
                IF tm.b = 'N' THEN NEXT FIELD b END IF
             END IF
        END IF
 
      AFTER FIELD d
        LET l_flag = 2
        IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN NEXT FIELD d END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF tm.b = 'Y' AND cl_null(tm.c) THEN 
            CALL cl_getmsg('gxr-001',g_lang) RETURNING g_msg  
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
               LET g_qryparam.arg1 = tm.o   #FUN-740009
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a                               
               NEXT FIELD a
 
            WHEN INFIELD(c)     #幣別代號                               
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
   
      ON ACTION exit
         LET INT_FLAG = 1
          EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW gxrr712_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gxrr712'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gxrr712','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno  CLIPPED,"'",   #TQC-610056
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
         CALL cl_cmdat('gxrr712',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gxrr712_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gxrr712()
   ERROR ""
END WHILE
   CLOSE WINDOW gxrr712_w
END FUNCTION
 
FUNCTION gxrr712()
   DEFINE l_name    LIKE type_file.chr20,        #NO.FUN-680145 VARCHAR(20)     # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0099
          l_sql     LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(1000)
          l_sql1    LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(40)
          l_i       LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
          l_qcyef   LIKE ooo_file.ooo08d,
          l_qcye    LIKE ooo_file.ooo08d,
          m_ooo08d  LIKE ooo_file.ooo08d,
          m_ooo08c  LIKE ooo_file.ooo08c,
          m_ooo09d  LIKE ooo_file.ooo08d,
          m_ooo09c  LIKE ooo_file.ooo08c,
          sr1       RECORD
                    ooo01    LIKE ooo_file.ooo01,
                    ooo02    LIKE ooo_file.ooo02 
                    END RECORD,
          sr        RECORD        
                    ooo01    LIKE ooo_file.ooo01,
                    ooo02    LIKE ooo_file.ooo02,
                    ooo06    LIKE ooo_file.ooo06,
                    ooo07    LIKE ooo_file.ooo07,
                    ooo08d   LIKE ooo_file.ooo08d,
                    ooo08c   LIKE ooo_file.ooo08c,
                    ooo09d   LIKE ooo_file.ooo09d,
                    ooo09c   LIKE ooo_file.ooo09c,
                    qcyef    LIKE ooo_file.ooo08d,
                    qcye     LIKE ooo_file.ooo08d,
                    prt      LIKE type_file.chr1      #NO.FUN-680145 VARCHAR(01)
                    END RECORD
 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     #No.FUN-BB0047--mark--End-----
     SELECT aaf03 INTO g_company FROM aaf_file 
      WHERE aaf01 = tm.o AND aaf02 = g_rlang
# No.FUN-580110 --start--
     CALL cl_outnam('gxrr712') RETURNING l_name
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     IF tm.b = 'Y' THEN
        LET g_aza17 = tm.c
     ELSE
        LET g_aza17 = l_aza17
     END IF
#    SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01=g_aza17    #No.CHI-6A0004
 
     LET l_sql = " SELECT UNIQUE ooo01,ooo02 FROM ooo_file ",
                 "  WHERE ooo03 = '",tm.a,"'",
                 "    AND ooo10 = '",g_plant,"'",
                 "    AND ooo11 = '",tm.o,"'",
                 "    AND ",tm.wc CLIPPED
     IF tm.b = 'Y' THEN
        LET l_sql = l_sql CLIPPED," AND ooo05 = '",g_aza17,"'"
     END IF
     PREPARE gxrr712_pr1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
        EXIT PROGRAM 
     END IF
     DECLARE gxrr712_curs1 CURSOR FOR gxrr712_pr1
 
     LET l_sql1="SELECT ooo01,ooo02,ooo06,ooo07,SUM(ooo08d),",
                "       SUM(ooo08c),SUM(ooo09d),SUM(ooo09c),0,0,'' ",
                "  FROM ooo_file ",
                " WHERE ooo03 = '",tm.a,"'",
                "   AND ooo10 = '",g_plant,"'",
                "   AND ooo11 = '",tm.o,"'",
                "   AND ooo01 = ?  AND ooo02 = ? ",             
                "   AND ooo06 = ",tm.yy,
                "   AND ooo07 BETWEEN ",tm.m1," AND ",tm.m2,
                "   AND ",tm.wc CLIPPED 
     IF tm.b = 'Y' THEN
        LET l_sql1 = l_sql1 CLIPPED," AND ooo05 = '",g_aza17,"'"
     END IF
     LET l_sql1 = l_sql1 CLIPPED,
                " GROUP BY ooo01,ooo02,ooo06,ooo07 ",                        
                " ORDER BY ooo01,ooo02,ooo06,ooo07 "  
     PREPARE gxrr712_prepare1 FROM l_sql1
     IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
        EXIT PROGRAM 
     END IF
     DECLARE gxrr712_curs CURSOR FOR gxrr712_prepare1
 
     IF tm.b='N' THEN
        LET g_zaa[34].zaa06='N'
        LET g_zaa[35].zaa06='N'
        LET g_zaa[36].zaa06='N'
        LET g_zaa[44].zaa06='N'
        LET g_zaa[37].zaa06='Y'
        LET g_zaa[38].zaa06='Y'
        LET g_zaa[39].zaa06='Y'
        LET g_zaa[40].zaa06='Y'
        LET g_zaa[41].zaa06='Y'
        LET g_zaa[42].zaa06='Y'
        LET g_zaa[45].zaa06='Y'
        LET g_zaa[46].zaa06='Y'
     ELSE
        LET g_zaa[34].zaa06='Y'
        LET g_zaa[35].zaa06='Y'
        LET g_zaa[36].zaa06='Y'
        LET g_zaa[44].zaa06='Y'
        LET g_zaa[37].zaa06='N'
        LET g_zaa[38].zaa06='N'
        LET g_zaa[39].zaa06='N'
        LET g_zaa[40].zaa06='N'
        LET g_zaa[41].zaa06='N'
        LET g_zaa[42].zaa06='N'
        LET g_zaa[45].zaa06='N'
        LET g_zaa[46].zaa06='N'
     END IF
     CALL cl_prt_pos_len()   
 
     START REPORT gxrr712_rep TO l_name                                      
     LET g_pageno  = 0 
     LET t_qcyef   = 0 
     LET t_qcye    = 0 
     LET t_ooo08_l = 0
     LET t_ooo08_r = 0
     LET t_ooo09_l = 0
     LET t_ooo09_r = 0
     let t_qmye    = 0  
     let t_qmyef   = 0  
 
     FOREACH gxrr712_curs1 INTO sr1.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0) EXIT FOREACH
       END IF
       LET g_null = 'N'
       IF tm.b = 'Y' THEN
          SELECT SUM(ooo08d-ooo08c),SUM(ooo09d-ooo09c)  #期初余額
            INTO l_qcyef,l_qcye    FROM ooo_file
           WHERE ooo01 = sr1.ooo01 AND ooo02 = sr1.ooo02
             AND ooo03 = tm.a      AND ooo05 = g_aza17
             AND ooo06 = tm.yy     AND ooo07 < tm.m1
             AND ooo10 = g_plant   AND ooo11 = tm.o 
          SELECT SUM(ooo08d),SUM(ooo08c),SUM(ooo09d),SUM(ooo09c)  #期間余額
            INTO m_ooo08d,m_ooo08c,m_ooo09d,m_ooo09c
            FROM ooo_file
           WHERE ooo01 = sr1.ooo01 AND ooo02 = sr1.ooo02
             AND ooo03 = tm.a      AND ooo05 = g_aza17
             AND ooo06 = tm.yy     AND ooo07 BETWEEN tm.m1 AND tm.m2
             AND ooo10 = g_plant   AND ooo11 = tm.o          
       ELSE
          SELECT SUM(ooo09d-ooo09c)  #期初余額
            INTO l_qcye    FROM ooo_file
           WHERE ooo01 = sr1.ooo01 AND ooo02 = sr1.ooo02
             AND ooo03 = tm.a    
             AND ooo06 = tm.yy     AND ooo07 < tm.m1
             AND ooo10 = g_plant   AND ooo11 = tm.o 
          SELECT SUM(ooo09d),SUM(ooo09c)  #期間余額
            INTO m_ooo09d,m_ooo09c
            FROM ooo_file
           WHERE ooo01 = sr1.ooo01 AND ooo02 = sr1.ooo02
             AND ooo03 = tm.a      
             AND ooo06 = tm.yy     AND ooo07 BETWEEN tm.m1 AND tm.m2
             AND ooo10 = g_plant   AND ooo11 = tm.o          
       END IF
       IF cl_null(l_qcyef)  THEN LET l_qcyef = 0 END IF
       IF cl_null(l_qcye )  THEN LET l_qcye  = 0 END IF
       IF cl_null(m_ooo08d) THEN LET m_ooo08d = 0 END IF
       IF cl_null(m_ooo08c) THEN LET m_ooo08c = 0 END IF
       IF cl_null(m_ooo09d) THEN LET m_ooo09d = 0 END IF
       IF cl_null(m_ooo09c) THEN LET m_ooo09c = 0 END IF
 
       IF tm.b = 'N' AND l_qcye = 0 AND      #本幣
          m_ooo09d = 0 AND m_ooo09c = 0 THEN 
          LET g_null = 'Y'   #期初為零且無異動
       END IF
       IF tm.b='Y' AND l_qcyef=0 AND l_qcye=0 AND m_ooo08d=0   #外幣
          AND m_ooo08c=0  AND m_ooo09d=0 AND m_ooo09c=0 THEN 
          LET g_null = 'Y'
       END IF
       IF tm.d = 'N' THEN  #期初為零且無異動不打印
          IF g_null = 'Y' THEN
             CONTINUE FOREACH
          END IF
       END IF
       IF tm.d = 'Y' AND g_null = 'Y' OR 
          tm.b = 'N' AND m_ooo09d = 0 AND m_ooo09c = 0  OR 
          tm.b='Y' AND m_ooo08d=0 AND m_ooo08c=0 AND m_ooo09d=0 AND m_ooo09c=0
          THEN 
             LET sr.ooo01  = sr1.ooo01
             LET sr.ooo02  = sr1.ooo02
             LET sr.ooo06  = tm.yy
             LET sr.ooo08d = 0
             LET sr.ooo08c = 0
             LET sr.ooo09d = 0
             LET sr.ooo09c = 0
             LET sr.qcye   = l_qcye
             LET sr.qcyef  = l_qcyef
             LET sr.prt    = '0'
             OUTPUT TO REPORT gxrr712_rep(sr.*)
             CONTINUE FOREACH
       END IF
       FOREACH gxrr712_curs USING sr1.ooo01,sr1.ooo02 INTO sr.*  
         IF SQLCA.sqlcode THEN                                  
            CALL cl_err('foreach:',SQLCA.sqlcode,0)            
            EXIT FOREACH                                      
         END IF                                              
         IF tm.b = 'N' THEN                                 
            IF sr.ooo09d = 0 AND sr.ooo09c = 0 THEN        
               CONTINUE FOREACH                           
            END IF                                       
         ELSE                                           
            IF sr.ooo09d=0 AND sr.ooo09c=0 AND sr.ooo08d=0 AND sr.ooo08c=0 THEN
               CONTINUE FOREACH                                               
            END IF                                                           
         END IF                                                             
         LET sr.qcyef = l_qcyef                                            
         LET sr.qcye  = l_qcye                                            
         LET sr.prt   = '1'          
         OUTPUT TO REPORT gxrr712_rep(sr.*)   
         LET g_print = g_print + 1          
       END FOREACH                         
 
    END FOREACH          
    FINISH REPORT gxrr712_rep
#No.FUN-580110 --end--
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #No.FUN-BB0047--mark--Begin---
    #   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
    #No.FUN-BB0047--mark--End-----
END FUNCTION
 
REPORT gxrr712_rep(sr)
#No.FUN-580110 --start--
   DEFINE l_last_sw LIKE type_file.chr1,          #TQC-5A0134 #NO.FUN-680145 VARCHAR(01)
          l_qmye    LIKE ooo_file.ooo08d,
          l_qmyef   LIKE ooo_file.ooo08d,  
          l_qmyefw  LIKE ooo_file.ooo08d,
          l_occ18   LIKE occ_file.occ18,
          l_drcr    LIKE azz_file.azz08,          #NO.FUN-680145 VARCHAR(7)
          l_drcr1   LIKE azz_file.azz08,          #FUN-740009
          l_drcr2   LIKE azz_file.azz08,          #FUN-740009
          l_drcr3   LIKE azz_file.azz08,          #FUN-740009
          sr        RECORD        
                        ooo01    LIKE ooo_file.ooo01,
                        ooo02    LIKE ooo_file.ooo02,
                        ooo06    LIKE ooo_file.ooo06,
                        ooo07    LIKE ooo_file.ooo07,
                        ooo08d   LIKE ooo_file.ooo08d,
                        ooo08c   LIKE ooo_file.ooo08c,
                        ooo09d   LIKE ooo_file.ooo09d,
                        ooo09c   LIKE ooo_file.ooo09c,
                        qcyef    LIKE ooo_file.ooo08d,
                        qcye     LIKE ooo_file.ooo08d,
                        prt      LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line 
  ORDER BY sr.ooo01,sr.ooo02,sr.ooo06,sr.ooo07
  FORMAT
   PAGE HEADER 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED                                                                        
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                                                                              
      LET g_pageno = g_pageno + 1                                                                                                   
      LET pageno_total = PAGENO USING '<<<','/pageno'                                                                               
      PRINT g_head CLIPPED, pageno_total   
      PRINT g_x[11] CLIPPED,l_aag02 CLIPPED,'(',tm.a CLIPPED,')'
      PRINT g_x[27] CLIPPED,
            tm.yy USING '&&&&','/',tm.m1 USING '&&','-',
            tm.yy USING '&&&&','/',tm.m2 USING '&&',
            COLUMN 33,g_x[26] CLIPPED,tm.o CLIPPED
      PRINT g_dash[1,g_len]
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],          
                     g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47] 
      PRINT g_dash1
      LET l_last_sw ='n'
 
   ON EVERY ROW
       LET t_qcye = t_qcye + sr.qcye   #MOD-580255
       LET t_qcyef = t_qcyef + sr.qcyef   #MOD-580255
       LET l_qmye = sr.qcye + sr.ooo09d - sr.ooo09c
       LET t_qcye = t_qcye + sr.qcye
       LET t_ooo09_l = t_ooo09_l + sr.ooo09d 
       LET t_ooo09_r = t_ooo09_r + sr.ooo09c 
       LET t_qmye  = l_qmye + t_qmye
#FUN-740009.....begin
#      LET l_drcr = g_x[22]   
       LET l_drcr1 = g_x[48]
       LET l_drcr2 = g_x[49]
       LET l_drcr3 = g_x[50]
#FUN-740009.....end
       LET l_qmyef = sr.qcyef + sr.ooo08d - sr.ooo08c
       LET t_ooo08_l = t_ooo08_l + sr.ooo08d
       LET t_ooo08_r = t_ooo08_r + sr.ooo08c   
       LET t_qmyef   = t_qmyef + l_qmyef
 
     SELECT occ18 INTO l_occ18 
     FROM occ_file
     WHERE occ01=sr.ooo01              
        PRINTX name=D1 COLUMN g_c[31],sr.ooo01 CLIPPED,
                       COLUMN g_c[32],sr.ooo02 CLIPPED; 
        IF sr.qcye > 0 then   
        PRINTX name=D1
              COLUMN g_c[33],l_drcr1,    #FUN-740009 l_drcr[1,2]->l_drcr1    
              COLUMN g_c[34],cl_numfor(sr.qcye,34,g_azi04), 
              COLUMN g_c[37],cl_numfor(sr.qcyef,37,g_azi04) CLIPPED,   
              COLUMN g_c[38],cl_numfor(sr.qcye,38,g_azi04) CLIPPED;
        END IF
        IF sr.qcye = 0 then   
        PRINTX name=D1
              COLUMN g_c[33],l_drcr3,  #FUN-740009 l_drcr[5,6]->l_drcr3
              COLUMN g_c[34],cl_numfor(sr.qcye,34,g_azi04),
              COLUMN g_c[37],cl_numfor(sr.qcyef,37,g_azi04) CLIPPED,   
              COLUMN g_c[38],cl_numfor(sr.qcye,38,g_azi04) CLIPPED;
        END IF        
        IF sr.qcye < 0 THEN  
        PRINTX name=D1
              COLUMN g_c[33],l_drcr2,  #FUN-740009 l_drcr[3,4]->l_drcr2
              COLUMN g_c[34],cl_numfor(sr.qcye*-1,34,g_azi04),
              COLUMN g_c[37],cl_numfor(sr.qcyef*-1,37,g_azi04) CLIPPED,   
              COLUMN g_c[38],cl_numfor(sr.qcye*-1,38,g_azi04) CLIPPED;
        END IF  
        PRINTX name=D1
              COLUMN g_c[35],cl_numfor(sr.ooo09d,35,g_azi04),
              COLUMN g_c[36],cl_numfor(sr.ooo09c,36,g_azi04),
              COLUMN g_c[39],cl_numfor(sr.ooo08d,39,g_azi04) CLIPPED,
              COLUMN g_c[40],cl_numfor(sr.ooo09d,40,g_azi04),
              COLUMN g_c[41],cl_numfor(sr.ooo08c,41,g_azi04) CLIPPED,  
              COLUMN g_c[42],cl_numfor(sr.ooo09c,42,g_azi04); 
 
     IF l_qmye > 0 THEN 
     PRINTX name=D1
            COLUMN g_c[43],l_drcr1,   #FUN-740009 l_drcr[1,2]->l_drcr1
            COLUMN g_c[44],cl_numfor(l_qmye,44,g_azi04),
            COLUMN g_c[45],cl_numfor(l_qmyef,45,g_azi04),                
            COLUMN g_c[46],cl_numfor(l_qmye,46,g_azi04); 
     END IF
     IF l_qmye =  0 THEN
     PRINTX name=D1
            COLUMN g_c[43],l_drcr3,  #FUN-740009 l_drcr[5,6]->l_drcr3
            COLUMN g_c[44],cl_numfor(l_qmye,44,g_azi04),
            COLUMN g_c[45],cl_numfor(l_qmyef,45,g_azi04),                
            COLUMN g_c[46],cl_numfor(l_qmye,46,g_azi04); 
     END IF
     IF l_qmye <  0 THEN  
     PRINTX name=D1
            COLUMN g_c[43],l_drcr2,   #FUN-740009 l_drcr[3,4]->l_drcr2
            COLUMN g_c[44],cl_numfor(l_qmye*-1,44,g_azi04),
            COLUMN g_c[45],cl_numfor(l_qmyef*-1,45,g_azi04),
            COLUMN g_c[46],cl_numfor(l_qmye*-1,46,g_azi04);
     END IF
     PRINTX name=D1 COLUMN g_c[47],l_occ18     
 
   ON LAST ROW
      PRINTX name=S1 COLUMN g_c[31],g_x[25] CLIPPED;
      IF t_qcye > 0 THEN
      PRINTX name=S1
            COLUMN g_c[33],l_drcr1,   #FUN-740009 l_drcr[1,2]->l_drcr1 
            COLUMN g_c[34],cl_numfor(t_qcye,34,g_azi04),
            COLUMN g_c[37],cl_numfor(t_qcyef,37,g_azi04),     
            COLUMN g_c[38],cl_numfor(t_qcye,38,g_azi04);
      END IF    
      IF t_qcye = 0 THEN     
      PRINTX name=S1
            COLUMN g_c[33],l_drcr3,  #FUN-740009 l_drcr[5,6]->l_drcr3 
            COLUMN g_c[34],cl_numfor(t_qcye,34,g_azi04),
            COLUMN g_c[37],cl_numfor(t_qcyef,37,g_azi04),
            COLUMN g_c[38],cl_numfor(t_qcye,38,g_azi04);
      END IF 
      IF t_qcye < 0 THEN   
      PRINTX name=S1
            COLUMN g_c[33],l_drcr2,   #FUN-740009 l_drcr[3,4]->l_drcr2 
            COLUMN g_c[34],cl_numfor(t_qcye*-1,34,g_azi04),
            COLUMN g_c[37],cl_numfor(t_qcyef*-1,37,g_azi04),
            COLUMN g_c[38],cl_numfor(t_qcye*-1,38,g_azi04);
      END IF   
      PRINTX name=S1
            COLUMN g_c[35],cl_numfor(t_ooo09_l,35,g_azi04),  
            COLUMN g_c[36],cl_numfor(t_ooo09_r,36,g_azi04),
            COLUMN g_c[39],cl_numfor(t_ooo08_l,39,g_azi04),          
            COLUMN g_c[40],cl_numfor(t_ooo09_l,40,g_azi04),         
            COLUMN g_c[41],cl_numfor(t_ooo08_r,41,g_azi04),        
            COLUMN g_c[42],cl_numfor(t_ooo09_r,42,g_azi04);
 
      IF t_qmye > 0 THEN  
         PRINTX name=S1
               COLUMN g_c[43],l_drcr1,  #FUN-740009 l_drcr[1,2]->l_drcr1
               COLUMN g_c[44],cl_numfor(t_qmye,44,g_azi04),
               COLUMN g_c[45],cl_numfor(t_qmyef,45,g_azi04), 
               COLUMN g_c[46],cl_numfor(t_qmye ,46,g_azi04) 
      ELSE   
         IF t_qmye = 0 THEN   
            PRINTX name=S1
                  COLUMN g_c[43],l_drcr3,  #FUN-740009 l_drcr[5,6]->l_drcr3
                  COLUMN g_c[44],cl_numfor(t_qmye,44,g_azi04),
                  COLUMN g_c[45],cl_numfor(t_qmyef,45,g_azi04), 
                  COLUMN g_c[46],cl_numfor(t_qmye ,46,g_azi04) 
         ELSE  
            PRINTX name=S1
                  COLUMN g_c[43],l_drcr2,  #FUN-740009 l_drcr[3,4]->l_drcr2
                  COLUMN g_c[44],cl_numfor(t_qmye*-1,44,g_azi04),
                  COLUMN g_c[45],cl_numfor(t_qmyef*-1,45,g_azi04), 
                  COLUMN g_c[46],cl_numfor(t_qmye *-1,46,g_azi04) 
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
#No.FUN-580110 --end--
