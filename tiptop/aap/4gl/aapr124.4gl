# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr124.4gl 
# Descriptions...: 應付帳款科目期報表列印作業
# Date & Author..: 94/07/30 By Roger
# Modify.........: No.9623 04/06/03 By kitty 程式里合計都設INTEGER,改為DEC(15,3)
# Modify.........: No.FUN-4C0097 05/01/27 By Nicola 報表架構修改,增加列印部門名稱gem02
# Modify.........: No.MOD-550184 05/06/07 By ching fix group by                                                                     
# Modify.........: No.MOD-590088 05/10/20 By Smapmin title顯示錯誤                                                                  
# Modify.........: No.TQC-5B0119 05/11/13 By Echo 沒有判斷隱藏欄位顯示問題...所以報表很長                                           
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行                                          
# Modify.........: No.FUN-660060 06/06/26 By Rainy 期間置於中間                                                                     
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3                                                              
# Modify.........: No.FUN-660141 06/07/10 By cheunl  帳別權限修改                                                                   
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5XX
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0039 06/11/15 By Smapmin 列印排列順序
# Modify.........: No.MOD-6C0052 06/12/11 By Smapmin 依原幣幣別抓取資料
# Modify.........: No.FUN-730064 07/04/04 By lora    會計科目加帳套
# Modify.........: No.MOD-740023 07/04/10 By Smapmin 如果該資料庫設定的總帳資料庫不同, 會跑不出資料
# Modify.........: No.FUN-770005 07/06/29 By ve  報表改為使用crystal report
# Modify.........: NO.MOD-780051 07/08/08 By Smapmin 修改幣別位數取位
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.MOD-850087 08/05/14 By Sarah Temptable裡的tmt_d欄位誤寫入amt_d值,修正
# Modify.........: No.MOD-850104 08/05/14 By Sarah 抓l_aag02的SQL,AND aag00='",tm.o CLIPPED,"'應改為 AND aag00=tm.o
# Modify.........: No.FUN-940013 09/04/21 By jan 會計科目 欄位增加開窗功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm       RECORD
                   wc       LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
                   s        LIKE type_file.chr2,    # No.FUN-690028 VARCHAR(2),   
                   t,u      LIKE type_file.chr2,    # No.FUN-690028 VARCHAR(2)
                   yy,m1,m2 LIKE type_file.num10,   # No.FUN-690028 INTEGER,
                   o        LIKE aaa_file.aaa01,    #帳別編號  #No.FUN-670039
                   a        LIKE type_file.chr1,    # No.FUN-690028 VARCHAR(01),
                   b        LIKE azi_file.azi01,    # No.FUN-690028 VARCHAR(04),
                   more     LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)         # Input more condition(Y/N)
                END RECORD,
       l_aza17  LIKE aza_file.aza17
DEFINE l_order  ARRAY[3] OF LIKE apm_file.apm02      # No.FUN-690028 VARCHAR(20)
DEFINE g_orderA ARRAY[3] OF LIKE zaa_file.zaa08      # No.FUN-690028 VARCHAR(20)
DEFINE g_chr    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE g_i      LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
#     DEFINEl_time LIKE type_file.chr8         #No.FUN-6A0055
DEFINE p_plant   LIKE apz_file.apz02p   #MOD-740023
DEFINE l_table   STRING                 #FUN-770005
DEFINE g_str     STRING                 #No.FUN-770005
DEFINE g_sql     STRING                 #No.FUN-770005
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
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055  #FUN-BB0047 add
#No.FUN-770005--begin--
   LET g_sql = "aag02.aag_file.aag02,",
               "apm01.apm_file.apm01,",
               "apm02.apm_file.apm02,",
               "apm03.apm_file.apm03,",
               "gem02.gem_file.gem02,",
               "amt_b.apm_file.apm06,",
               "amt_d.apm_file.apm06,",
               "amt_c.apm_file.apm07,",
               "tmt_d.apm_file.apm06f,",
               "tmt_c.apm_file.apm07f,",
               "tmt_b.apm_file.apm06,",
               "apm00.apm_file.apm00"
   LET l_table=cl_prt_temptable('aapr124',g_sql) CLIPPED
   IF  l_table=-1 THEN EXIT PROGRAM END IF
#  LET g_sql=" INSERT INTO ds_report.",l_table CLIPPED,                 # TQC-780054
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,        # TQC-780054
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770005--end--
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add 
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
   LET tm.yy  = ARG_VAL(11)
   LET tm.m1  = ARG_VAL(12)
   LET tm.m2  = ARG_VAL(13)
   LET tm.o     = ARG_VAL(14)
   LET tm.a     = ARG_VAL(15)
   LET tm.b     = ARG_VAL(16)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(17)
   LET g_rep_clas = ARG_VAL(18)
   LET g_template = ARG_VAL(19)
   LET g_rpt_name = ARG_VAL(20)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET p_plant = g_apz.apz02p   #MOD-740023
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL aapr124_tm(0,0) 
   ELSE
      CALL aapr124()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
END MAIN
 
FUNCTION aapr124_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-690028 SMALLINT
          l_n            LIKE type_file.num5,       #A074  #No.FUN-690028 SMALLINT
          l_flag         LIKE type_file.num5,       #A074  #No.FUN-690028 SMALLINT
          l_cmd          LIKE type_file.chr1000,    #No.FUN-690028 VARCHAR(400)
          li_chk_bookno  LIKE type_file.num5        # No.FUN-690028 SMALLINT   #No.FUN-660141
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW aapr124_w AT p_row,p_col
     WITH FORM "aap/42f/aapr124"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.yy   = YEAR(TODAY)
   LET tm.m1   = MONTH(TODAY)
   LET tm.m2   = MONTH(TODAY)
   LET tm.s = '24'
   LET tm.t     = ' '
   LET tm.o     = g_apz.apz02b
   LET tm.a     = 'N'
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
 
      CONSTRUCT BY NAME tm.wc ON apm00,apm01,apm02,apm03  
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #FUN-940013--begin--add
         ON ACTION controlp
           CASE
              WHEN INFIELD(apm00)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_aag"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO apm00
                   NEXT FIELD apm00
              OTHERWISE EXIT CASE
           END CASE
         #FUN-940013--end--add
 
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
         CLOSE WINDOW aapr124_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      
      INPUT BY NAME tm.yy,tm.m1,tm.m2,tm.o,tm.a,tm.b,tm2.s1,tm2.s2,
                      tm2.t1,tm2.t2,tm2.u1,tm2.u2,tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
            LET l_flag = 0
            IF cl_null(tm.yy) THEN
               CALL cl_err('','aap-099',0)
               NEXT FIELD yy
            END IF
 
         AFTER FIELD m1
            IF cl_null(tm.m1) THEN
               CALL cl_err('','aap-099',0) 
               NEXT FIELD m1
            END IF
 
         AFTER FIELD m2
            IF cl_null(tm.m2) THEN
               CALL cl_err('','aap-099',0)
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
           #No.FUN-660141--begin
             #CALL s_check_bookno(tm.o,g_user,g_plant)    #MOD-740023
             CALL s_check_bookno(tm.o,g_user,p_plant)    #MOD-740023
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD o
             END IF 
             #No.FUN-660141--end
            SELECT * FROM aaa_file WHERE aaa01 = tm.o
            IF SQLCA.sqlcode THEN
#              CALL cl_err('',SQLCA.sqlcode,0) #No.FUN-660122
               CALL cl_err3("sel","aaa_file",tm.o,"",SQLCA.sqlcode,"","",0)  #No.FUN-660122
               NEXT FIELD o
            END IF
            SELECT aaa03 INTO l_aza17 FROM aaa_file WHERE aaa01 = tm.o
            IF SQLCA.sqlcode THEN 
               LET l_aza17 = g_aza.aza17
            END IF 
      
         AFTER FIELD a
            LET l_flag = 1
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
               NEXT FIELD a
            END IF
         
            IF tm.a = 'N' THEN
               LET tm.b = ''
               DISPLAY BY NAME tm.b
            END IF
         
         BEFORE FIELD b
            IF l_flag = 1 THEN
               IF tm.a = 'N' THEN
                  NEXT FIELD s1 
               END IF
            ELSE
               IF l_flag = 2 THEN
                  IF tm.a = 'N' THEN 
                     NEXT FIELD o
                  END IF
               END IF
            END IF
         
         AFTER FIELD b
            IF tm.a = 'Y' THEN
               IF cl_null(tm.b) THEN
                  NEXT FIELD b 
               END IF
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM azi_file
                WHERE azi01 = tm.b
               IF l_n = 0 THEN
                  CALL cl_err('',-100,0)
                  NEXT FIELD b
               #-----MOD-780051---------
               ELSE
                  SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file 
                    WHERE azi01 = tm.b
               #-----END MOD-780051-----
               END IF
            END IF
         
         AFTER FIELD s1
           LET l_flag = 2
         
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
         
         ON ACTION CONTROLP                                                       
            CASE
               WHEN INFIELD(b)     #幣別代號                               
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = tm.b
                  CALL cl_create_qry() RETURNING tm.b 
                  DISPLAY BY NAME tm.b                               
                  NEXT FIELD b            
            END CASE
         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         
         ON ACTION CONTROLG
            CALL cl_cmdask()
         
         AFTER INPUT  
            IF tm.a = 'N' THEN
               LET tm.b = ''
               DISPLAY BY NAME tm.b 
            END IF
         
            IF tm.a = 'Y' AND cl_null(tm.b) THEN
               NEXT FIELD b
            END IF
         
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1]
            LET tm.t = tm2.t1,tm2.t2
            LET tm.u = tm2.u1,tm2.u2
         
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
         CLOSE WINDOW aapr124_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr124'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr124','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
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
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.m1 CLIPPED,"'",
                        " '",tm.m2 CLIPPED,"'",
                        " '",tm.o CLIPPED,"'",
                        " '",tm.a CLIPPED,"'",
                        " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr124',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW aapr124_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL aapr124()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW aapr124_w
 
END FUNCTION
 
FUNCTION aapr124()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,          # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690028 VARCHAR(1200)
          l_wc      LIKE type_file.chr1000,       #   #No.FUN-690028 VARCHAR(300)
          i         LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_chr     LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          l_aag02   LIKE aag_file.aag02,    #No.FUN-770005
          sr        RECORD 
                       order1,order2 LIKE apm_file.apm02,      # No.FUN-690028 VARCHAR(10),
                       apm00 LIKE apm_file.apm00,   #Act no
                       apm01 LIKE apm_file.apm01,   #付款廠商編號
                       apm02 LIKE apm_file.apm02,   #廠商簡稱
                       apm03 LIKE apm_file.apm03,   #DEPT
                       gem02 LIKE gem_file.gem02,   #DEPT
                       amt_b LIKE apm_file.apm06,   #No:9623
                       tmt_b LIKE apm_file.apm06,   #No:9623
                       amt_d LIKE apm_file.apm06,   #No:9623
                       tmt_d LIKE apm_file.apm06f,  #No:9623
                       amt_c LIKE apm_file.apm07,   #No:9623
                       tmt_c LIKE apm_file.apm07f   #No:9623
                   END RECORD
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
   CALL cl_del_data(l_table)           #No.FUN-770005
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-770005 --start-- mark   
{   CALL cl_outnam('aapr124') RETURNING l_name
   LET g_pageno = 0
   #TQC-5B0119
   IF tm.a = 'N' THEN
           LET g_zaa[41].zaa06 = "Y"
           LET g_zaa[42].zaa06 = "Y"
           LET g_zaa[43].zaa06 = "Y"
           LET g_zaa[44].zaa06 = "Y"
           LET g_zaa[45].zaa06 = "Y"
           LET g_zaa[46].zaa06 = "Y"
           LET g_zaa[47].zaa06 = "Y"
           LET g_zaa[48].zaa06 = "Y"
           LET g_zaa[49].zaa06 = "Y"
           LET g_zaa[50].zaa06 = "Y"
           LET g_zaa[51].zaa06 = "Y"
           LET g_zaa[52].zaa06 = "Y"
   ELSE
           LET g_zaa[35].zaa06 = "Y"
           LET g_zaa[36].zaa06 = "Y"
           LET g_zaa[37].zaa06 = "Y"
           LET g_zaa[38].zaa06 = "Y"
           LET g_zaa[39].zaa06 = "Y"
           LET g_zaa[40].zaa06 = "Y"
   END IF
   CALL cl_prt_pos_len()
   #END TQC-5B0119
   IF tm.a = 'N' THEN
     START REPORT aapr124_rep TO l_name
   ELSE
     START REPORT aapr124_rep1 TO l_name
   END IF
}
#No.FUN-770005--end--
   LET l_sql = "SELECT '','',apm00,apm01,apm02,apm03,'',SUM(apm06-apm07),",
               "       SUM(apm06f-apm07f),0,0,0,0",
               "  FROM apm_file WHERE ",tm.wc CLIPPED,
               "   AND apm04=",tm.yy," AND apm05<",tm.m1,
               #"   AND apm08 = '",g_plant,"'",   #MOD-740023
               "   AND apm08 = '",p_plant,"'",   #MOD-740023
               "   AND apm09 = '",tm.o CLIPPED,"'" 
 
   IF tm.a = 'Y' THEN
      #LET l_sql = l_sql CLIPPED,"  AND apm11 = '",l_aza17 CLIPPED,"'"    #MOD-6C0052
      LET l_sql = l_sql CLIPPED,"  AND apm11 = '",tm.b CLIPPED,"'"    #MOD-6C0052
   END IF
 
   LET l_sql = l_sql CLIPPED,
              #" GROUP BY apm00,apm01,apm02,apm03,'',0,0,0,0",
                " GROUP BY apm00,apm01,apm02,apm03",  #MOD-550184
               " UNION ",
               "SELECT '','',apm00,apm01,apm02,apm03,'',0,0,SUM(apm06),",
               "       SUM(apm06f),SUM(apm07),SUM(apm07f) ",
               "  FROM apm_file WHERE ",tm.wc CLIPPED,
               "   AND apm04=",tm.yy," AND apm05 BETWEEN ",tm.m1," AND ",tm.m2,
               #"   AND apm08 = '",g_plant,"'",   #MOD-740023
               "   AND apm08 = '",p_plant,"'",   #MOD-740023
               "   AND apm09 = '",tm.o CLIPPED,"'"
 
   IF tm.a = 'Y' THEN
      #LET l_sql = l_sql CLIPPED,"  AND apm11 = '",l_aza17 CLIPPED,"'"   #MOD-6C0052
      LET l_sql = l_sql CLIPPED,"  AND apm11 = '",tm.b CLIPPED,"'"   #MOD-6C0052
   END IF
 
  #LET l_sql = l_sql CLIPPED," GROUP BY apm00,apm01,apm02,apm03,'',0,0 "
    LET l_sql = l_sql CLIPPED," GROUP BY apm00,apm01,apm02,apm03 " #MOD-550184
 
   PREPARE aapr124_p1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('prepare1:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD
      EXIT PROGRAM
   END IF
   DECLARE aapr124_c1 CURSOR FOR aapr124_p1
 
   FOREACH aapr124_c1 INTO sr.*
      IF STATUS != 0 THEN
         CALL cl_err('fore1:',STATUS,1) 
         EXIT FOREACH
      END IF
    
      IF tm.a ='N' THEN
         IF sr.amt_b = 0 AND sr.amt_d = 0 AND sr.amt_c = 0 THEN
            CONTINUE FOREACH
         END IF
      ELSE
         IF sr.amt_b = 0 AND sr.amt_d = 0 AND sr.amt_c = 0 
            AND sr.tmt_b = 0 AND sr.tmt_d = 0 AND sr.tmt_c = 0 THEN
            CONTINUE FOREACH
         END IF
      END IF
 
      IF sr.amt_b = 0 AND sr.amt_d = 0 AND sr.amt_c = 0 THEN
         CONTINUE FOREACH
      END IF
 
      IF sr.apm03 IS NULL THEN
         LET sr.apm03 = ' '
      END IF
 
#No.FUN-770005 --start--
{      FOR g_i = 1 TO 2
         CASE 
              WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.apm00   #TQC-6B0039
                                       LET g_orderA[g_i]= g_x[14]   #TQC-6B0039
              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.apm01
                                       LET g_orderA[g_i]= g_x[11]
              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.apm02
                                       LET g_orderA[g_i]= g_x[12]
              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.apm03
                                       LET g_orderA[g_i]= g_x[13]
              OTHERWISE                LET l_order[g_i] = '-'       
                                       LET g_orderA[g_i]= 'xxxx'
         END CASE
      END FOR
 
      LET sr.order1=l_order[1]
      LET sr.order2=l_order[2]
      IF sr.order1 IS NULL THEN LET sr.order1 = ' '  END IF
      IF sr.order2 IS NULL THEN LET sr.order2 = ' '  END IF
}
#No.FUN-770005 --end--     
      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.apm03
      SELECT aag02 INTO l_aag02 FROM aag_file                                                             
       WHERE aag01 = sr.apm00 AND aag00 = tm.o   #No.FUN-730064   #MOD-850104 mod
#No.FUN-770005--bgin--
   #IF tm.a = 'N' THEN
   #   OUTPUT TO REPORT aapr124_rep(sr.*)
   #ELSE
   #   OUTPUT TO REPORT aapr124_rep1(sr.*)
   #END IF
    EXECUTE insert_prep USING 
       l_aag02,sr.apm01,sr.apm02,sr.apm03,sr.gem02,
       sr.amt_b,sr.amt_d,sr.amt_c,sr.tmt_d,sr.tmt_c,sr.tmt_b,sr.apm00   #MOD-850087 mod
   END FOREACH
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'apm00,apm01,apm02,apm03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
   LET l_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str=tm.s[1,1],";",tm.s[2,2],";",tm.yy,";",tm.m1,";",tm.m2,";",tm.o,";"
             #,tm.b,";",tm.t,";",tm.u,";",g_azi04,";",g_azi05   #MOD-780051
             ,tm.b,";",tm.t,";",tm.u,";",g_azi04,";",g_azi05,";",t_azi04,";",t_azi05,";",g_str   #MOD-780051
{  IF tm.a = 'N' THEN
      FINISH REPORT aapr124_rep
   ELSE
      FINISH REPORT aapr124_rep1
   END IF
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
 }
 
   IF tm.a = 'N' THEN 
     CALL cl_prt_cs3('aapr124','aapr124',l_sql,g_str)                                                                                                              
   ELSE
     CALL cl_prt_cs3('aapr124','aapr124_1',l_sql,g_str)                                                                                                                             
   END IF
#No.FUN-770005--end-- 
END FUNCTION
#No.FUN-750015--begin--
{
REPORT aapr124_rep(sr)
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr        RECORD 
                       order1,order2 LIKE apm_file.apm02,      # No.FUN-690028 VARCHAR(20),
                       apm00 LIKE apm_file.apm00,   #Act no
                       apm01 LIKE apm_file.apm01,   #付款廠商編號
                       apm02 LIKE apm_file.apm02,   #廠商簡稱
                       apm03 LIKE apm_file.apm03,   #DEPT
                       gem02 LIKE gem_file.gem02,   #DEPT
                       amt_b LIKE apm_file.apm06,   #No:9623
                       tmt_b LIKE apm_file.apm06,   #No:9623
                       amt_d LIKE apm_file.apm06,   #No:9623
                       tmt_d LIKE apm_file.apm06f,  #No:9623
                       amt_c LIKE apm_file.apm07,   #No:9623
                       tmt_c LIKE apm_file.apm07f   #No:9623
                    END RECORD,
          l_amt     LIKE apm_file.apm06,        #No:9623
          tot_b,tot_d,tot_c,tot_e LIKE apm_file.apm06,    #No:9623
          l_aag02   LIKE aag_file.aag02
   DEFINE g_head1    STRING 
   DEFINE g_head2   STRING   #TQC-6B0039
 
   OUTPUT
      TOP MARGIN g_top_margin 
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.apm00,sr.order1,sr.order2,sr.apm01,sr.apm02,sr.apm03
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.apm00
                                                   AND aag00 = sr.apm09  #No.FUN-730064
         LET g_head1 = g_x[10] CLIPPED,sr.apm00 CLIPPED,' ',l_aag02
         PRINT g_head1
         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '####','/',tm.m1 USING '&&',
                       '-',tm.yy USING '####','/',tm.m2 USING '&&','     ',
                       g_x[19] CLIPPED,' ',tm.o CLIPPED
         #PRINT g_head1                      #FUN-660060 remark
         PRINT COLUMN (g_len-25)/2+1,g_head1 #FUN-660060
         LET g_head2 = g_x[24],g_orderA[1],'-',g_orderA[2]   #TQC-6B0039
         PRINT g_head2   #TQC-6B0039
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#               g_x[38],g_x[40]   #MOD-590088
               g_x[39],g_x[40]   #MOD-590088
         PRINT g_dash1
         LET l_last_sw = 'n'
     
      BEFORE GROUP OF sr.apm00
         SKIP TO TOP OF PAGE
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE 
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      AFTER GROUP OF sr.apm03
         LET tot_b = GROUP SUM(sr.amt_b)
         LET tot_d = GROUP SUM(sr.amt_d)
         LET tot_c = GROUP SUM(sr.amt_c)
         LET tot_e = tot_b + tot_d - tot_c
         PRINT COLUMN g_c[31],sr.apm01,
               COLUMN g_c[32],sr.apm02,
               COLUMN g_c[33],sr.apm03,
               COLUMN g_c[34],sr.gem02;
 
         IF tot_b > 0 THEN 
            LET l_amt = tot_b     
            LET g_chr = 'D'
         ELSE
            LET l_amt = tot_b * -1 LET g_chr = 'C'
         END IF
 
         PRINT COLUMN g_c[35],cl_numfor(l_amt,35,0),
               COLUMN g_c[36],g_chr,
               COLUMN g_c[37],cl_numfor(tot_d,37,g_azi05),
               COLUMN g_c[38],cl_numfor(tot_c,38,g_azi05);
 
         IF tot_e > 0 THEN
            LET l_amt = tot_e
            LET g_chr = 'D'
         ELSE
            LET l_amt = tot_e * -1
            LET g_chr = 'C'
         END IF
 
         PRINT COLUMN g_c[39],cl_numfor(l_amt,39,g_azi05),
               COLUMN g_c[40],g_chr
     
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            LET tot_b = GROUP SUM(sr.amt_b)
            LET tot_d = GROUP SUM(sr.amt_d)
            LET tot_c = GROUP SUM(sr.amt_c)
            LET tot_e = tot_b + tot_d - tot_c
            PRINT COLUMN g_c[33],g_orderA[2] CLIPPED,
                  COLUMN g_c[34],g_x[15] CLIPPED;
            IF tot_b > 0 THEN
               LET l_amt = tot_b
               LET g_chr = 'D'
            ELSE
               LET l_amt = tot_b * -1
               LET g_chr = 'C'
            END IF
            PRINT COLUMN g_c[35],cl_numfor(l_amt,35,g_azi05),
                  COLUMN g_c[36],g_chr,
                  COLUMN g_c[37],cl_numfor(tot_d,37,g_azi05),
                  COLUMN g_c[38],cl_numfor(tot_c,38,g_azi05);
            IF tot_e > 0 THEN 
               LET l_amt = tot_e
               LET g_chr = 'D'
            ELSE
               LET l_amt = tot_e * -1
               LET g_chr = 'C'
            END IF
            PRINT COLUMN g_c[39],cl_numfor(l_amt,39,g_azi05),
                  COLUMN g_c[40],g_chr
            PRINT g_dash2
         END IF
     
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            LET tot_b = GROUP SUM(sr.amt_b)
            LET tot_d = GROUP SUM(sr.amt_d)
            LET tot_c = GROUP SUM(sr.amt_c)
            LET tot_e = tot_b + tot_d - tot_c
            PRINT COLUMN g_c[33],g_orderA[1] CLIPPED,
                  COLUMN g_c[34],g_x[16] CLIPPED;
            IF tot_b > 0 THEN
               LET l_amt = tot_b
               LET g_chr = 'D'
            ELSE
               LET l_amt = tot_b * -1
               LET g_chr = 'C'
            END IF
            PRINT COLUMN g_c[35],cl_numfor(l_amt,35,g_azi05),
                  COLUMN g_c[36],g_chr,
                  COLUMN g_c[37],cl_numfor(tot_d,37,g_azi05),
                  COLUMN g_c[38],cl_numfor(tot_c,38,g_azi05);
            IF tot_e > 0 THEN 
               LET l_amt = tot_e
               LET g_chr = 'D'
            ELSE
               LET l_amt = tot_e * -1
               LET g_chr = 'C'
            END IF
            PRINT COLUMN g_c[39],cl_numfor(l_amt,39,g_azi05),
                  COLUMN g_c[40],g_chr
            PRINT g_dash2
         END IF
     
      AFTER GROUP OF sr.apm00
         LET tot_b = GROUP SUM(sr.amt_b)
         LET tot_d = GROUP SUM(sr.amt_d)
         LET tot_c = GROUP SUM(sr.amt_c)
         LET tot_e = tot_b + tot_d - tot_c
         PRINT COLUMN g_c[33],g_x[14] CLIPPED,
               COLUMN g_c[34],g_x[17] CLIPPED;
         IF tot_b > 0 THEN
            LET l_amt = tot_b
            LET g_chr = 'D'
         ELSE
            LET l_amt = tot_b * -1 
            LET g_chr = 'C'
         END IF
         PRINT COLUMN g_c[35],cl_numfor(l_amt,35,g_azi05),
               COLUMN g_c[36],g_chr,
               COLUMN g_c[37],cl_numfor(tot_d,37,g_azi05),
               COLUMN g_c[38],cl_numfor(tot_c,38,g_azi05);
         IF tot_e > 0 THEN 
            LET l_amt = tot_e
            LET g_chr = 'D'
         ELSE
            LET l_amt = tot_e * -1
            LET g_chr = 'C'
         END IF
         PRINT COLUMN g_c[39],cl_numfor(l_amt,39,g_azi05),
               COLUMN g_c[40],g_chr
         #PRINT g_dash   #TQC-6B0039
 
      ON LAST ROW   #TQC-6B0039
         #PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0039   
         LET l_last_sw = 'y'
     
      PAGE TRAILER
         PRINT g_dash[1,g_len]   #TQC-6B0039
         IF l_last_sw = 'n' THEN
            #PRINT g_dash[1,g_len]   #TQC-6B0039
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0039   
            #SKI 2 LINE   #TQC-6B0039
         END IF
 
END REPORT
 
REPORT aapr124_rep1(sr)
   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
          sr        RECORD 
                       order1,order2 LIKE apm_file.apm02,      # No.FUN-690028 VARCHAR(20),
                       apm00 LIKE apm_file.apm00,   #Act no
                       apm01 LIKE apm_file.apm01,   #付款廠商編號
                       apm02 LIKE apm_file.apm02,   #廠商簡稱
                       apm03 LIKE apm_file.apm03,   #DEPT
                       gem02 LIKE gem_file.gem02,   #DEPT
                       amt_b LIKE apm_file.apm06,   #No:9623
                       tmt_b LIKE apm_file.apm06,   #No:9623
                       amt_d LIKE apm_file.apm06,   #No:9623
                       tmt_d LIKE apm_file.apm06f,  #No:9623
                       amt_c LIKE apm_file.apm07,   #No:9623
                       tmt_c LIKE apm_file.apm07f   #No:9623
                    END RECORD,
          l_amt     LIKE apm_file.apm06,   #No:9623
          f_amt     LIKE apm_file.apm06,   #No:9623
          tot_b,tot_d,tot_c,tot_e LIKE apm_file.apm06,   #No:9623
          fot_b,fot_d,fot_c,fot_e LIKE apm_file.apm06,   #No:9623
          l_aag02   LIKE aag_file.aag02
   DEFINE g_head1   STRING
   DEFINE g_head2   STRING   #TQC-6B0039
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.apm00,sr.order1,sr.order2,sr.apm01,sr.apm02,sr.apm03
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01 = sr.apm00
                                                   AND aag00 = sr.apm09   #No.FUN-730064
         LET g_head1 = g_x[10] CLIPPED,sr.apm00 CLIPPED,' ',l_aag02
         PRINT g_head1
         LET g_head1 = g_x[9] CLIPPED,tm.yy USING '####','/',tm.m1 USING '&&',
                       '-',tm.yy USING '####','/',tm.m2 USING '&&','     ',
                       #g_x[18] CLIPPED,l_aza17,'     ',   #MOD-6C0052
                       g_x[18] CLIPPED,tm.b,'     ',   #MOD-6C0052
                       g_x[19] CLIPPED,' ',tm.o CLIPPED
         PRINT g_head1
         LET g_head2 = g_x[24],g_orderA[1],'-',g_orderA[2]   #TQC-6B0039
         PRINT g_head2   #TQC-6B0039
         PRINT g_dash[1,g_len]
          
        #TQC-5B0119
         PRINT COLUMN 41,g_x[20],
               COLUMN 83,g_x[21],
               COLUMN 121,g_x[22],
               COLUMN 159,g_x[23]
        #PRINT COLUMN 41,g_dash2[1,(g_w[41]++1)*2+1],' ',
        #                g_dash2[1,g_w[45]*2+1],' ',
        #                g_dash2[1,g_w[47]*2+1],' ',
        #                g_dash2[1,(g_w[49]+1)*2+1]
         PRINT COLUMN 41,g_dash2[1,(g_w[41]+g_w[42]+g_w[43]+g_w[44]+3)],' ',
                         g_dash2[1,(g_w[45]+g_w[46]+1)],' ',
                         g_dash2[1,(g_w[47]+g_w[48]+1)],' ',
                         g_dash2[1,(g_w[49]+g_w[50]+g_w[51]+g_w[52]+3)]
        #END TQC-5B0119
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[41],g_x[42],g_x[43],g_x[44],
               g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52]
         PRINT g_dash1
         LET l_last_sw = 'n'
     
      BEFORE GROUP OF sr.apm00
         SKIP TO TOP OF PAGE
 
      BEFORE GROUP OF sr.order1
         IF tm.t[1,1] = 'Y' THEN
            SKIP TO TOP OF PAGE 
         END IF
 
      BEFORE GROUP OF sr.order2
         IF tm.t[2,2] = 'Y' THEN
            SKIP TO TOP OF PAGE
         END IF
 
      AFTER GROUP OF sr.apm03
         LET tot_b = GROUP SUM(sr.amt_b)
         LET tot_d = GROUP SUM(sr.amt_d)
         LET tot_c = GROUP SUM(sr.amt_c)
         LET tot_e = tot_b + tot_d - tot_c
         LET fot_b = GROUP SUM(sr.tmt_b)
         LET fot_d = GROUP SUM(sr.tmt_d)
         LET fot_c = GROUP SUM(sr.tmt_c)
         LET fot_e = fot_b + fot_d - fot_c
         PRINT COLUMN g_c[31],sr.apm01,
               COLUMN g_c[32],sr.apm02,
               COLUMN g_c[33],sr.apm03,
               COLUMN g_c[34],sr.gem02;
         IF fot_b > 0 THEN 
            LET f_amt = fot_b     
            LET l_amt = tot_b     
            LET g_chr = 'D'
         ELSE
            LET f_amt = fot_b * -1 LET g_chr = 'C'
            LET l_amt = tot_b * -1 
         END IF
         PRINT COLUMN g_c[41],cl_numfor(f_amt,41,g_azi04),
               COLUMN g_c[42],g_chr,
               COLUMN g_c[43],cl_numfor(l_amt,43,g_azi04),
               COLUMN g_c[44],g_chr,
               COLUMN g_c[45],cl_numfor(fot_d,45,g_azi04),
               COLUMN g_c[46],cl_numfor(tot_d,46,g_azi04),
               COLUMN g_c[47],cl_numfor(fot_c,47,g_azi04),
               COLUMN g_c[48],cl_numfor(tot_c,48,g_azi04);
     
         IF fot_e > 0 THEN
            LET f_amt = fot_e
            LET g_chr = 'D'
            LET l_amt = tot_e    
         ELSE
            LET f_amt = fot_e * -1
            LET g_chr = 'C'
            LET l_amt = tot_e * -1
         END IF
         PRINT COLUMN g_c[49],cl_numfor(f_amt,49,g_azi04),
               COLUMN g_c[50],g_chr,
               COLUMN g_c[51],cl_numfor(l_amt,51,g_azi04),
               COLUMN g_c[52],g_chr
 
      AFTER GROUP OF sr.order2
         IF tm.u[2,2] = 'Y' THEN
            LET tot_b = GROUP SUM(sr.amt_b)
            LET tot_d = GROUP SUM(sr.amt_d)
            LET tot_c = GROUP SUM(sr.amt_c)
            LET tot_e = tot_b + tot_d - tot_c
            LET fot_b = GROUP SUM(sr.tmt_b)
            LET fot_d = GROUP SUM(sr.tmt_d)
            LET fot_c = GROUP SUM(sr.tmt_c)
            LET fot_e = fot_b + fot_d - fot_c
            PRINT COLUMN g_c[33],g_orderA[2] CLIPPED,
                  COLUMN g_c[34],g_x[15] CLIPPED;
            IF fot_b > 0 THEN
               LET f_amt = fot_b 
               LET g_chr = 'D'
               LET l_amt = tot_b  
            ELSE
               LET f_amt = fot_b * -1
               LET g_chr = 'C'
               LET l_amt = tot_b * -1
            END IF
            PRINT COLUMN g_c[41],cl_numfor(f_amt,41,g_azi04),
                  COLUMN g_c[42],g_chr,
                  COLUMN g_c[43],cl_numfor(l_amt,43,g_azi04),
                  COLUMN g_c[44],g_chr,
                  COLUMN g_c[45],cl_numfor(fot_d,45,g_azi04),
                  COLUMN g_c[46],cl_numfor(tot_d,46,g_azi04),
                  COLUMN g_c[47],cl_numfor(fot_c,47,g_azi04),
                  COLUMN g_c[48],cl_numfor(tot_c,48,g_azi04);
            IF fot_e > 0 THEN 
               LET f_amt = fot_e
               LET g_chr = 'D'
               LET l_amt = tot_e    
            ELSE
               LET f_amt = fot_e * -1
               LET g_chr = 'C'
               LET l_amt = tot_e * -1
            END IF
            PRINT COLUMN g_c[49],cl_numfor(f_amt,49,g_azi04),
                  COLUMN g_c[50],g_chr,
                  COLUMN g_c[51],cl_numfor(l_amt,51,g_azi04),
                  COLUMN g_c[52],g_chr
            PRINT g_dash2
         END IF
     
      AFTER GROUP OF sr.order1
         IF tm.u[1,1] = 'Y' THEN
            LET tot_b = GROUP SUM(sr.amt_b)
            LET tot_d = GROUP SUM(sr.amt_d)
            LET tot_c = GROUP SUM(sr.amt_c)
            LET tot_e = tot_b + tot_d - tot_c
            LET fot_b = GROUP SUM(sr.tmt_b)
            LET fot_d = GROUP SUM(sr.tmt_d)
            LET fot_c = GROUP SUM(sr.tmt_c)
            LET fot_e = fot_b + fot_d - fot_c
            PRINT COLUMN g_c[33],g_orderA[1] CLIPPED,
                  COLUMN g_c[34],g_x[16] CLIPPED;
            IF fot_b > 0 THEN
               LET f_amt = fot_b
               LET g_chr = 'D'
               LET l_amt = tot_b  
            ELSE
               LET f_amt = fot_b * -1
               LET g_chr = 'C'
               LET l_amt = tot_b * -1
            END IF
            PRINT COLUMN g_c[41],cl_numfor(f_amt,41,g_azi04),
                  COLUMN g_c[42],g_chr,
                  COLUMN g_c[43],cl_numfor(l_amt,43,g_azi04),
                  COLUMN g_c[44],g_chr,
                  COLUMN g_c[45],cl_numfor(fot_d,45,g_azi04),
                  COLUMN g_c[46],cl_numfor(tot_d,46,g_azi04),
                  COLUMN g_c[47],cl_numfor(fot_c,47,g_azi04),
                  COLUMN g_c[48],cl_numfor(tot_c,48,g_azi04);
            IF fot_e > 0 THEN 
               LET f_amt = fot_e
               LET g_chr = 'D'
               LET l_amt = tot_e    
            ELSE
               LET f_amt = fot_e * -1
               LET g_chr = 'C'
               LET l_amt = tot_e * -1
            END IF
            PRINT COLUMN g_c[49],cl_numfor(f_amt,49,g_azi04),
                  COLUMN g_c[50],g_chr,
                  COLUMN g_c[51],cl_numfor(l_amt,51,g_azi04),
                  COLUMN g_c[52],g_chr
            PRINT g_dash2
         END IF
     
      AFTER GROUP OF sr.apm00
         LET tot_b = GROUP SUM(sr.amt_b)
         LET tot_d = GROUP SUM(sr.amt_d)
         LET tot_c = GROUP SUM(sr.amt_c)
         LET tot_e = tot_b + tot_d - tot_c
         LET fot_b = GROUP SUM(sr.tmt_b)
         LET fot_d = GROUP SUM(sr.tmt_d)
         LET fot_c = GROUP SUM(sr.tmt_c)
         LET fot_e = fot_b + fot_d - fot_c
         PRINT COLUMN g_c[33],g_x[14] CLIPPED,
               COLUMN g_c[34],g_x[17] CLIPPED;
         IF fot_b > 0 THEN
            LET f_amt = fot_b
            LET g_chr = 'D'
            LET l_amt = tot_b  
         ELSE
            LET f_amt = fot_b * -1
            LET g_chr = 'C'
            LET l_amt = tot_b * -1
         END IF
         PRINT COLUMN g_c[41],cl_numfor(f_amt,41,g_azi04),
               COLUMN g_c[42],g_chr,
               COLUMN g_c[43],cl_numfor(l_amt,43,g_azi04),
               COLUMN g_c[44],g_chr,
               COLUMN g_c[45],cl_numfor(fot_d,45,g_azi04),
               COLUMN g_c[46],cl_numfor(tot_d,46,g_azi04),
               COLUMN g_c[47],cl_numfor(fot_c,47,g_azi04),
               COLUMN g_c[48],cl_numfor(tot_c,48,g_azi04);
         IF fot_e > 0
            THEN LET f_amt = fot_e      LET g_chr = 'D'
                 LET l_amt = tot_e    
            ELSE LET f_amt = fot_e * -1 LET g_chr = 'C'
                 LET l_amt = tot_e * -1
         END IF
         PRINT COLUMN g_c[49],cl_numfor(f_amt,49,g_azi04),
               COLUMN g_c[50],g_chr,
               COLUMN g_c[51],cl_numfor(l_amt,51,g_azi04),
               COLUMN g_c[52],g_chr
         #PRINT g_dash   #TQC-6B0039
     
      ON LAST ROW   #TQC-6B0039
         #PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0039
         LET l_last_sw = 'y'
     
      PAGE TRAILER
         PRINT g_dash[1,g_len]   #TQC-6B0039
         IF l_last_sw = 'n' THEN
            #PRINT g_dash[1,g_len]   #TQC-6B0039
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
         ELSE
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED   #TQC-6B0039
            #SKIP 2 LINE   #TQC-6B0039
         END IF
 
END REPORT
}
#No.FUN-770005--end--
