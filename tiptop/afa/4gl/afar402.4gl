# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: afar402.4gl
# Descriptions...: 固定資產處分變動明細表(稅簽)
# Date & Author..: 97/01/21 By Apple
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-510035 05/02/02 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-590002 05/09/06 By vivien 報表格式調整
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-770052 07/07/30 By xiaofeizhu 制作水晶報表
# Modify.........: No.MOD-8B0016 08/11/04 By Sarah 1.稅簽未折減額應抓fbh11,不應抓fbh08
#                                                  2.稅簽資料應抓fao_file,不應抓fan_file
# Modify.........: No.MOD-8B0046 08/11/06 By Sarah 1.b,c計算前需判斷fap54,NULL則照原先方式計算,非NULL則c=fap54,b=fap57-c
#                                                  2.d,e漏計算,d=b+c,e=fap56-d
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-B50193 11/05/23 By Dido fap54/fap56/fap57 改用 fap71/fap73/fap74 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.MOD-590002 --start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa13_value  LIKE zaa_file.zaa13
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item    LIKE type_file.num5         #No.FUN-680070 SMALLINT
END GLOBALS
#No.MOD-590002 --end
 
    DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition       #No.FUN-680070 VARCHAR(1000)
              bdate   LIKE type_file.dat,          #No.FUN-680070 DATE
              edate   LIKE type_file.dat,          #No.FUN-680070 DATE
              s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # group by jump       #No.FUN-680070 VARCHAR(3)
              v       LIKE type_file.chr3,          # Order by summary       #No.FUN-680070 VARCHAR(3)
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_descripe ARRAY[4] OF LIKE type_file.chr20,   # Report Heading & prompt       #No.FUN-680070 VARCHAR(14)
          prog_name_l  LIKE type_file.chr1000 # 報表名稱長度       #No.FUN-680070 VARCHAR(40)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE   l_table         STRING,                   ### FUN-770052 ###                                                               
         g_str           STRING,                   ### FUN-770052 ###                                                               
         g_sql           STRING                    ### FUN-770052 ###
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
   ### *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
   LET g_sql = "faj04.faj_file.faj04,faj20.faj_file.faj20,",
               "faj07.faj_file.faj07,fbf04.fbf_file.fbf04,",
               "faj26.faj_file.faj26,faj64.faj_file.faj64,",
               "fap04.fap_file.fap04,fap73.fap_file.fap73,",   #MOD-B50193 mod fap56 -> fap73
               "fao07.fao_file.fao07,fao07c.fao_file.fao07,",  #MOD-8B0016 mod fan->fao
               "fao07d.fao_file.fao07,fao07e.fao_file.fao07,", #MOD-8B0016 mod fan->fao
               "fbf12.fbf_file.fbf12,fbf07.fbf_file.fbf07,",
               "fbf09.fbf_file.fbf09,fbe14.fbe_file.fbe14,",
               "fap50.fap_file.fap50,faj89.faj_file.faj89,",
               "faj83.faj_file.faj83,fch07.fch_file.fch07,",
               "faj02.faj_file.faj02,faj022.faj_file.faj022,",
               "fap03.fap_file.fap03"
 
   LET l_table = cl_prt_temptable('afar402',g_sql) CLIPPED   # 產生Temp Table                                                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?)"
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                  
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
   END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#                   
 
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)   #TQC-610055
   LET tm.edate = ARG_VAL(9)   #TQC-610055
   LET tm.s     = ARG_VAL(10)
   LET tm.t     = ARG_VAL(11)  #TQC-610055
   LET tm.v     = ARG_VAL(12)  #TQC-610055
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar402_tm(0,0)        # Input print condition
      ELSE CALL afar402()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar402_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afar402_w AT p_row,p_col WITH FORM "afa/42f/afar402"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   LET tm2.u1   = tm.v[1,1]
   LET tm2.u2   = tm.v[2,2]
   LET tm2.u3   = tm.v[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
   IF cl_null(tm2.u1) THEN LET tm2.u1 = "N" END IF
   IF cl_null(tm2.u2) THEN LET tm2.u2 = "N" END IF
   IF cl_null(tm2.u3) THEN LET tm2.u3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj20,fap50,fap02,fap021,faj04,fap03
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
         LET INT_FLAG = 0 CLOSE WINDOW afar402_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
 
      INPUT BY NAME
         tm.bdate,tm.edate,tm2.s1,tm2.s2,tm2.s3,
         tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.more
         WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
         AFTER FIELD bdate
            IF cl_null(tm.bdate) THEN
               NEXT FIELD bdate
            END IF
         AFTER FIELD edate
            IF cl_null(tm.edate) OR tm.edate < tm.bdate THEN
               NEXT FIELD bdate
            END IF
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
            LET tm.v = tm2.u1,tm2.u2,tm2.u3
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
         LET INT_FLAG = 0 CLOSE WINDOW afar402_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar402'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar402','9031',1)
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
                        " '",tm.bdate CLIPPED,"'",
                        " '",tm.edate CLIPPED,"'",
                        " '",tm.s CLIPPED,"'",
                        " '",tm.t CLIPPED,"'",
                        " '",tm.v CLIPPED,
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                        " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar402',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar402_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar402()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar402_w
END FUNCTION
 
FUNCTION afar402()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#         l_time    LIKE type_file.chr8           #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE fap_file.fap50,     #No.FUN-680070 VARCHAR(20)
          sr        RECORD 
                     order1 LIKE fap_file.fap50,  #No.FUN-680070 VARCHAR(20)
                     order2 LIKE fap_file.fap50,  #No.FUN-680070 VARCHAR(20)
                     order3 LIKE fap_file.fap50,  #No.FUN-680070 VARCHAR(20)
                     faj04  LIKE faj_file.faj04,  # 資產類別
                     faj02  LIKE faj_file.faj02,  # 財產編號
                     faj022 LIKE faj_file.faj022, # 附號
                     faj01  LIKE faj_file.faj01,  # 序號
                     faj20  LIKE faj_file.faj20,  # 保管部門
                     faj07  LIKE faj_file.faj07,  # 英文名稱
                     faj08  LIKE faj_file.faj08,  # 規格型號
                     faj17  LIKE faj_file.faj17,  # 數量
                     faj26  LIKE faj_file.faj26,  # 入帳日期
                     faj64  LIKE faj_file.faj64,  # 耐用年限
                     faj82  LIKE faj_file.faj82,  #
                     faj83  LIKE faj_file.faj83,  #
                     faj88  LIKE faj_file.faj88,  #
                     faj89  LIKE faj_file.faj89,  #
                     fap03  LIKE fap_file.fap03,  # 異動代號
                     fap04  LIKE fap_file.fap04,  # 異動日期
                     fap07  LIKE fap_file.fap07,  # 未使用年限
                     fap73  LIKE fap_file.fap73,  # 稅簽銷帳成本    #MOD-B50193 mod fap56 -> fap73
                     fap50  LIKE fap_file.fap50,  # 單據編號
                     fap501 LIKE fap_file.fap501, #     項次
                     fap71  LIKE fap_file.fap71,  # 稅簽調整成本    #MOD-8B0046 add #MOD-B50193 mod fap54 -> fap71
                     fap74  LIKE fap_file.fap74,  # 稅簽銷帳累折    #MOD-8B0046 add #MOD-B50193 mod fap57 -> fap74
                     fbf04  LIKE fbf_file.fbf04,  #     數量
                     fbf07  LIKE fbf_file.fbf07,  # 處份累折
                     fbf09  LIKE fbf_file.fbf09,  # 處份損益
                     code   LIKE fap_file.fap03,  # 異動代號
                     desc   LIKE type_file.chr4,  # 中文       #No.FUN-680070 VARCHAR(04)
                     reson  LIKE fag_file.fag03,  # 說明
                     glno   LIKE fbe_file.fbe14,  # 傳票編號
                     fbf12  LIKE fbf_file.fbf12   #No.CHI-480001
                    END RECORD,
          b,c       LIKE fao_file.fao07,          #MOD-8B0016 mod fan->fao
          l_fch07   LIKE fch_file.fch07
#No.MOD-590002 --start
DEFINE l_i          LIKE type_file.num10          #No.FUN-680070 INTEGER
DEFINE l_zaa02      LIKE zaa_file.zaa02
DEFINE l_cnt        LIKE type_file.num10          #No.FUN-680070 INTEGER
DEFINE d,e          LIKE fao_file.fao07           #No.FUN-770052 #MOD-8B0016 mod fan->fao
DEFINE p_str        LIKE type_file.chr50          #No.FUN-770052
DEFINE l_name1      LIKE type_file.chr20          #No.FUN-770052 
#No.MOD-590002 --end
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN              #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
   #End:FUN-980030
 
   LET l_sql = "SELECT '','','',",
               " faj04, faj02, faj022,faj01, faj20, faj07,",
               " faj08, faj17, faj26, faj64, ",
               " faj82, faj83, faj88, faj89,",
               " fap03, fap04, fap07, fap73, fap50, fap501,",  #MOD-B50193 mod fap56 -> fap73
               " fap71, fap74,",   #MOD-8B0046 add #MOD-B50193 mod fap54 -> fap71,fap57->74
               " '','','','','','','',''",               #No.CHI-480001
               " FROM faj_file,fap_file ",
               " WHERE faj02= fap02 AND faj022 = fap021 ",
               "  AND fap03 IN ('4','5','6') ",
               "  AND fap04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
               "  AND ",tm.wc CLIPPED
 
   PREPARE afar402_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
      EXIT PROGRAM
   END IF
   DECLARE afar402_curs1 CURSOR FOR afar402_prepare1
 
#  CALL cl_outnam('afar402') RETURNING l_name                     #FUN-770052
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
   CALL cl_del_data(l_table)                                                                                                      
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
   #------------------------------ CR (2) ------------------------------#  
 
#No.MOD-590002 --start
   IF g_aza.aza26 = '2' THEN
#     LET g_zaa[44].zaa06 = "N"                                  #FUN-770052
      LET l_name1 = 'afar402_1'                                  #FUN-770052
   ELSE
#     LET g_zaa[44].zaa06 = "Y"                                  #FUN-770052
      LET l_name1 = 'afar402'                                    #FUN-770052
   END IF
   CALL cl_prt_pos_len()
#No.MOD-590002 --end
 
#  START REPORT afar402_rep TO l_name                            #FUN-770052
   LET g_pageno = 0
 
   FOREACH afar402_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CASE
         WHEN sr.fap03 = '4'  #出售
              LET sr.desc = g_x[15] clipped
              SELECT fbe14,fag03,fbf04,fbf07,fbf09,fbf12    #No.CHI-480001
                INTO sr.glno,sr.reson,sr.fbf04,sr.fbf07,sr.fbf09,sr.fbf12
                FROM fbe_file,fbf_file,OUTER fag_file
               WHERE fbe01 = fbf01 AND fbf_file.fbf05=fag_file.fag02
                 AND fbf01 = sr.fap50 AND fbf02 = sr.fap501
                 AND fbeconf='Y'  AND fbepost = 'Y'
              IF SQLCA.sqlcode<>0 THEN
                 LET sr.glno= ' '  LET sr.reson = ' ' LET sr.fbf09 = ' '
                 LET sr.fbf07= ' ' LET sr.fbf04= ' '  LET sr.fbf12 = ' '  #No.CHI-480001
              END IF
         WHEN sr.fap03 = '5'  #報廢
              LET sr.desc = g_x[16] clipped
             #SELECT fbg08,fag03,fbh04,fbh08,fbh13          #No.CHI-480001   #MOD-8B0016 mark
              SELECT fbg08,fag03,fbh04,fbh11,fbh13          #No.CHI-480001   #MOD-8B0016
                INTO sr.glno,sr.reson,sr.fbf04,sr.fbf09,sr.fbf12
                FROM fbg_file,fbh_file,OUTER fag_file
               WHERE fbg01 = fbh01 AND fbh_file.fbh05=fag_file.fag02 AND fbg00 = '1'
                 AND fbh01 = sr.fap50 AND fbh02 = sr.fap501
                 AND fbgconf='Y' AND fbgpost = 'Y'
              IF SQLCA.sqlcode<>0 THEN
                 LET sr.glno= ' '  LET sr.reson = ' ' LET sr.fbf09 = ' '
                 LET sr.fbf07= ' ' LET sr.fbf04= ' '  LET sr.fbf12 = ' '  #No.CHI-480001
              END IF
         WHEN sr.fap03 = '6'  #銷帳
              LET sr.desc = g_x[17] clipped
             #SELECT fbg08,fag03,fbh04,fbh08,fbh13          #No.CHI-480001   #MOD-8B0016 mark
              SELECT fbg08,fag03,fbh04,fbh11,fbh13          #No.CHI-480001   #MOD-8B0016
                INTO sr.glno,sr.reson,sr.fbf04,sr.fbf09,sr.fbf12
                FROM fbg_file,fbh_file,OUTER fag_file
               WHERE fbg01 = fbh01 AND fbh_file.fbh05=fag_file.fag02 AND fbg00 = '2'
                 AND fbh01 = sr.fap50 AND fbh02 = sr.fap501
                 AND fbgconf='Y' AND fbgpost = 'Y'
              IF SQLCA.sqlcode<>0 THEN
                 LET sr.glno= ' '  LET sr.reson = ' ' LET sr.fbf09 = ' '
                 LET sr.fbf04= ' ' LET sr.fbf12 = ' '        #No.CHI-480001
              END IF
      END CASE
      #--->前期累折
     #str MOD-8B0016 mod
     #SELECT SUM(fan07) INTO b FROM fan_file
     # WHERE fan01=sr.faj02 AND fan02=sr.faj022
     #   AND fan03 < YEAR(sr.fap04)
     #   AND fan041 = '1'
      SELECT SUM(fao07) INTO b FROM fao_file
       WHERE fao01=sr.faj02 AND fao02=sr.faj022
         AND fao03 < YEAR(sr.fap04)
         AND fao041 = '1'
     #end MOD-8B0016 mod
      IF cl_null(b)  THEN LET b = 0 END IF
      #--->本期折舊
     #str MOD-8B0016 mod
     #SELECT SUM(fan07) INTO c FROM fan_file
     # WHERE fan01=sr.faj02 AND fan02=sr.faj022
     #   AND fan03=YEAR(sr.fap04) AND fan04<=MONTH(sr.fap04)
     #   AND fan041 = '1'
      SELECT SUM(fao07) INTO c FROM fao_file
       WHERE fao01=sr.faj02 AND fao02=sr.faj022
         AND fao03=YEAR(sr.fap04) AND fao04<=MONTH(sr.fap04)
         AND fao041 = '1'
     #end MOD-8B0016 mod
      IF cl_null(c)  THEN LET c = 0 END IF
      #-->抵押文號日期判斷
      IF sr.faj88 > tm.edate THEN LET sr.faj89 = ' ' END IF
      #-->投資底減文號日期判斷
      IF sr.faj82 > tm.edate THEN LET sr.faj83 = ' ' END IF
      #-->免稅文號日期判斷
      SELECT fch07 INTO l_fch07 FROM fch_file,fci_file
       WHERE fch01 = fci01
         AND fch03 = sr.faj02 AND fch031 = sr.faj022
         AND fch06 between tm.bdate AND tm.edate
         AND fchconf !='X'  #010803增
      IF SQLCA.sqlcode THEN LET l_fch07 = ' ' END IF
      IF cl_null(sr.fap71) THEN   #MOD-8B0046 add       #MOD-B50193 mod fap54 -> fap71
         #-->部份出售時
         IF sr.faj17 != sr.fbf04 THEN
            LET c = (c / sr.faj17) * sr.fbf04           #本期折舊
            LET b = (b / sr.faj17) * sr.fbf04           #前期累折
         END IF
     #str MOD-8B0046 add
      ELSE
         LET c = sr.fap71                               #MOD-B50193 mod fap54 -> fap71
         LET b = sr.fap74 - c                           #MOD-B50193 mod fap57 -> fap74
      END IF
     #nd MOD-8B0046 add
 
     #str MOD-8B0046 add
      LET d = b + c                                  #B+C處分日累折
      LET e = sr.fap73 - d                           #帳面價值          #MOD-B50193 mod fap56 -> fap73
     #end MOD-8B0046 add
 
     #FOR g_i = 1 TO 3                                                  #FUN-770052
     #   CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj20
     #                                 LET g_descripe[g_i]=g_x[9]
     #        WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fap50
     #                                 LET g_descripe[g_i]=g_x[10]
     #        WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
     #                                 LET g_descripe[g_i]=g_x[11]
     #        WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
     #                                 LET g_descripe[g_i]=g_x[12]
     #        WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj04
     #                                 LET g_descripe[g_i]=g_x[13]
     #        WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fap03
     #                                 LET g_descripe[g_i]=g_x[14]
     #        OTHERWISE LET l_order[g_i+1] = '-'
     #   END CASE
     #END FOR
     #LET sr.order1 = l_order[1]
     #LET sr.order2 = l_order[2]
     #LET sr.order3 = l_order[3]
     #
     #LET p_str= tm.bdate,' ','至' CLIPPED,' ',tm.edate       #FUN-770052
#    #OUTPUT TO REPORT afar402_rep(sr.*,b,c,l_fch07)          #FUN-770052
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
      EXECUTE insert_prep USING                                                                                                
         sr.faj04,sr.faj20, sr.faj07,sr.fbf04,sr.faj26,
         sr.faj64,sr.fap04, sr.fap73,b,       c,              #MOD-B50193 mod fap56 -> fap73
         d,       e,        sr.fbf12,sr.fbf07,sr.fbf09,
         sr.glno, sr.fap50, sr.faj89,sr.faj83,l_fch07,
         sr.faj02,sr.faj022,sr.fap03
     #------------------------------ CR (3) ------------------------------#  
   END FOREACH
 
#  FINISH REPORT afar402_rep                                 #FUN-770052
#No.FUN-770052--begin                                                                                                               
   IF g_zz05 = 'Y' THEN                                                                                                          
      CALL cl_wcchp(tm.wc,'faj20,fap50,fap02,fap021,faj04,fap03')                                                                                   
           RETURNING tm.wc                                                                                                       
   END IF                              
#No.FUN-770052--end
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
   LET g_str = ''                                                                                                                  
   LET g_str = tm.bdate,";",sr.fap03,";",tm.wc,";",g_azi04,";",
               tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
               tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",
               tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";",
               g_azi05,";",tm.edate
   CALL cl_prt_cs3('afar402',l_name1,l_sql,g_str)                                                                                  
   #------------------------------ CR (4) ------------------------------#   
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)               #FUN-770052
END FUNCTION
 
#No.CHI-480001
#原財編只印7碼, 現調整為10碼, 有些欄位列印位數不足, 故所有位置都需調整
#REPORT afar402_rep(sr,b,c,l_fch07)                         #FUN-770052
#  DEFINE l_last_sw    LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
#         sr           RECORD order1 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
#                             order2 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
#                             order3 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
#                             faj04 LIKE faj_file.faj04,    # 資產類別
#                             faj02 LIKE faj_file.faj02,    # 財產編號
#                             faj022 LIKE faj_file.faj022,  # 附號
#                             faj01 LIKE faj_file.faj01,    # 序號
#                             faj20 LIKE faj_file.faj20,    # 保管部門
#                             faj07 LIKE faj_file.faj07,    # 英文名稱
#                             faj08 LIKE faj_file.faj08,    # 規格型號
#                             faj17 LIKE faj_file.faj17,    # 數量
#                             faj26 LIKE faj_file.faj26,    # 入帳日期
#                             faj64 LIKE faj_file.faj64,    # 耐用年限
#                             faj82 LIKE faj_file.faj82,    #
#                             faj83 LIKE faj_file.faj83,    #
#                             faj88 LIKE faj_file.faj88,    #
#                             faj89 LIKE faj_file.faj89,    #
#                             fap03 LIKE fap_file.fap03,    # 異動代號
#                             fap04 LIKE fap_file.fap04,    # 異動日期
#                             fap07 LIKE fap_file.fap07,    # 未使用年限
#                             fap56 LIKE fap_file.fap56,    # 銷帳成本
#                             fap50 LIKE fap_file.fap50,    # 單據編號
#                             fap501 LIKE fap_file.fap501,  #     項次
#                             fbf04 LIKE fbf_file.fbf04,    #     數量
#                             fbf07 LIKE fbf_file.fbf07,    # 處份累折
#                             fbf09 LIKE fbf_file.fbf09,    # 處份損益
#                             code  LIKE fap_file.fap03,    # 異動代號
#                             desc  LIKE type_file.chr4,    # 中文       #No.FUN-680070 VARCHAR(04)
#                             reson LIKE fag_file.fag03,    # 說明
#                             glno  LIKE fbe_file.fbe14,    # 傳票編號
#                             fbf12 LIKE fbf_file.fbf12     #No.CHI-480001
#                      END RECORD,
#     b,c,d,e      LIKE fan_file.fan07,
#     l_fch07      LIKE fch_file.fch07,
#     p_str        LIKE type_file.chr50,        #No.FUN-680070 VARCHAR(50)
#     l_ymd        LIKE type_file.chr8,         #No.FUN-680070 VARCHAR(8)
#     l_str        STRING
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.order1,sr.order2,sr.order3
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total
#     let p_str= tm.bdate,' ',g_x[19] CLIPPED,' ',tm.edate
#     #PRINT p_str  #FUN-660060 remark                    
#     PRINT COLUMN ((g_len-FGL_WIDTH(p_str))/2)+1, p_str #FUN-660060
#     PRINT g_dash[1,g_len]
#
#     #No.CHI-480001
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],
##No.MOD-590002 --start
#           g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
#           g_x[51],g_x[52]
##No.MOD-590002 --end
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.order1
#     IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#  BEFORE GROUP OF sr.order2
#     IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#  BEFORE GROUP OF sr.order3
#     IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
#
#  ON EVERY ROW
#     LET d = b + c
#     LET e = sr.fap56 - d
#
#     #No.CHI-480001
#     LET l_str = sr.faj02,'-',sr.faj022
#     PRINT COLUMN g_c[31],sr.faj04,
#           COLUMN g_c[32],l_str,           #主類別/財編附號
#           COLUMN g_c[33],sr.faj20,
#           COLUMN g_c[34],sr.faj07,                        #保管部門/英文名稱
#           COLUMN g_c[35],cl_numfor(sr.fbf04,35,0),          #數量
#           COLUMN g_c[36],sr.faj26,
#           COLUMN g_c[37],sr.faj64 USING '<<<<<',          #入帳日期/年限
#           COLUMN g_c[38],sr.fap04,                        #異動日期
#           COLUMN g_c[39],cl_numfor(sr.fap56,39,g_azi04),  #成本
#           COLUMN g_c[40],cl_numfor(b,40,g_azi04),        #前期累折
#           COLUMN g_c[41],cl_numfor(c,41,g_azi04),        #本期折舊
#           COLUMN g_c[42],cl_numfor(d,42,g_azi04),        #處分累折
##No.MOD-590002 --start
#           COLUMN g_c[43],cl_numfor(e,43,g_azi04),        #帳面價值
#           COLUMN g_c[44],cl_numfor(e-sr.fbf12,44,g_azi04), #資產凈額
#           COLUMN g_c[45],cl_numfor(sr.fbf07,45,g_azi04),   #售價
#           COLUMN g_c[46],cl_numfor(sr.fbf09,46,g_azi04),   #處分損益
#           COLUMN g_c[47],sr.desc,
#           COLUMN g_c[48],sr.glno,                   #處分方式/傳票編號
#           COLUMN g_c[49],sr.fap50,
#           COLUMN g_c[50],sr.faj89,                  #單據號碼/扺押文號
#           COLUMN g_c[51],sr.faj83,
#           COLUMN g_c[52],l_fch07                    #扺減文號/免稅/摘要
##No.MOD-590002 --end
#
#  AFTER GROUP OF sr.order1
#     IF tm.v[1,1] = 'Y' THEN
#      PRINT COLUMN g_c[31],g_descripe[1],
#            COLUMN g_c[39],cl_numfor(group sum(sr.fap56),39,g_azi05),  #成本
#            COLUMN g_c[40],cl_numfor(group sum(b),40,g_azi05),        #前期累折
#            COLUMN g_c[41],cl_numfor(group sum(c),41,g_azi05),        #本期折舊
#            COLUMN g_c[42],cl_numfor(group sum(b+c),42,g_azi05),      #處分累折
#            #No.CHI-480001
##No.MOD-590002 --start
#            COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fap56-b-c),43,g_azi05), #帳面
#            COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fap56-b-c-sr.fbf12),44,g_azi05),
#            COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbf07),45,g_azi05),
#            COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fbf09),46,g_azi05)
##No.MOD-590002 --end
#            #end
#        PRINT
#     END IF
#
#  AFTER GROUP OF sr.order2
#     IF tm.v[2,2] = 'Y' THEN
#          PRINT COLUMN g_c[31],g_descripe[2],
#            COLUMN g_c[39],cl_numfor(group sum(sr.fap56),39,g_azi05),  #成本
#            COLUMN g_c[40],cl_numfor(group sum(b),40,g_azi05),        #前期累折
#            COLUMN g_c[41],cl_numfor(group sum(c),41,g_azi05),        #本期折舊
#            COLUMN g_c[42],cl_numfor(group sum(b+c),42,g_azi05),      #處分累折
#            #No.CHI-480001
##No.MOD-590002 --start
#            COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fap56-b-c),43,g_azi05), #帳面
#            COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fap56-b-c-sr.fbf12),44,g_azi05),
#            COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbf07),45,g_azi05),
#            COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fbf09),46,g_azi05)
##No.MOD-590002 --end
#            #end
#        PRINT
#     END IF
#
#  AFTER GROUP OF sr.order3
#     IF tm.v[3,3] = 'Y' THEN
#          PRINT COLUMN g_c[31],g_descripe[3],
#            COLUMN g_c[39],cl_numfor(group sum(sr.fap56),39,g_azi05),  #成本
#            COLUMN g_c[40],cl_numfor(group sum(b),40,g_azi05),        #前期累折
#            COLUMN g_c[41],cl_numfor(group sum(c),41,g_azi05),        #本期折舊
#            COLUMN g_c[42],cl_numfor(group sum(b+c),42,g_azi05),      #處分累折
#            #No.CHI-480001
##No.MOD-590002 --start
#            COLUMN g_c[43],cl_numfor(GROUP SUM(sr.fap56-b-c),43,g_azi05), #帳面
#            COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fap56-b-c-sr.fbf12),44,g_azi05),
#            COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbf07),45,g_azi05),
#            COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fbf09),46,g_azi05)
##No.MOD-590002 --end
#            #end
#        PRINT
#     END IF
#  ON LAST ROW
#     PRINT g_dash2[1,g_len]
#     LET l_last_sw = 'y'
#     print  g_x[18] clipped,
#            COLUMN g_c[39],cl_numfor( sum(sr.fap56),39,g_azi05), #成本
#            COLUMN g_c[40],cl_numfor(sum(b),40,g_azi05),        #前期累折
#            COLUMN g_c[41],cl_numfor(sum(c),41,g_azi05),        #本期折舊
#            COLUMN g_c[42],cl_numfor(sum(b+c),42,g_azi05),      #處分累折
#            #No.CHI-480001
##No.MOD-590002 --start
#            COLUMN g_c[43],cl_numfor(SUM(sr.fap56-b-c),43,g_azi05), #帳面價值
#            COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fap56-b-c-sr.fbf12),44,g_azi05),
#            COLUMN g_c[45],cl_numfor(SUM(sr.fbf07),45,g_azi05),
#            COLUMN g_c[46],cl_numfor(SUM(sr.fbf09),46,g_azi05)
##No.MOD-590002 --end
#            #end
#        PRINT
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT                                                      #FUN-770052
