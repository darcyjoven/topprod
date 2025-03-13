# Prog. Version..: '5.30.14-14.08.14(00008)'     #
#
# Pattern name...: afar208.4gl
# Descriptions...: 固定資產處分變動明細表
# Date & Author..: 97/01/21 By Apple
# Modify.........: No:7661 03/07/18 By Wiky 列印的英文名稱改為中文名稱
# Modify.........: No.CHI-480001 04/08/16 By Danny   新增大陸版報表段(減值準備)
# Modify.........: No.FUN-FUN-510035 05/03/01 By pengu 修改報表單價、金額欄位寬度
# Modify         : No.MOD-530844 05/03/30 by alexlin VARCHAR->CHAR
#
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: No.FUN-580010 05/08/02 By vivien 憑証類報表轉XML
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-780046 07/08/07 By destiny 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-C30229 12/03/20 By Sakura 增加"列印項目"1.財簽、2.財簽二
# Modify.........: No:CHI-C60010 12/06/12 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:TQC-C70099 12/07/16 By lujh 目前是直接抓afat110單身的出售金額(fbf07)帶入，若稅別為單價含稅時，會直接以含稅金額帶出顯示于報表，應在計算售價時
#                                                 依含稅否來計算其未稅金額，顯示于售價。
# Modify.........: No:FUN-D70122 13/07/29 BY yuhuabao 會計年期會不按照自然年月設置,修改全系統邏輯，年期的判斷需要按照aooq011的設置來
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580010  --start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   #FUN-560079
  DEFINE g_seq_item    LIKE type_file.num5         #No.FUN-680070 SMALLINT
END GLOBALS
 
 
    DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition       #No.FUN-680070 VARCHAR(1000)
              bdate   LIKE type_file.dat,          #No.FUN-680070 DATE
              edate   LIKE type_file.dat,          #No.FUN-680070 DATE
              s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # group by jump       #No.FUN-680070 VARCHAR(3)
              v       LIKE type_file.chr3,          # Order by summary       #No.FUN-680070 VARCHAR(3)
			  p       LIKE type_file.chr1,          #FUN-C30229 add  #列印項目
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD,
          g_head1    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
          g_descripe ARRAY[4] OF LIKE type_file.chr20,   # Report Heading & prompt       #No.FUN-680070 VARCHAR(14)
          prog_name_l  LIKE type_file.chr1000 # 報表名稱長度       #No.FUN-680070 VARCHAR(40)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#No.FUN-580010  --end
DEFINE g_sql    STRING                                                     #No.FUN-780046                                           
DEFINE g_str    STRING                                                     #No.FUN-780046                                           
DEFINE l_table  STRING                                                     #No.FUN-780046 
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_azi05_1  LIKE azi_file.azi05,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
DEFINE   g_flag          LIKE type_file.chr1     #FUN-D70122 add
DEFINE   g_bookno1       LIKE aza_file.aza81     #FUN-D70122 add
DEFINE   g_bookno2       LIKE aza_file.aza82     #FUN-D70122 add

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
#No.FUN-780046--start--                                                                                                             
   LET g_sql="fanb.fan_file.fan07,",
             "fanc.fan_file.fan07,",
             "fand.fan_file.fan07,",
             "fane.fan_file.fan07,",
             "faj02.faj_file.faj02,",                                                                                               
             "faj022.faj_file.faj022,",                                                                                               
             "faj04.faj_file.faj04,",                                                                                             
             "faj06.faj_file.faj06,",                                                                                               
             "faj20.faj_file.faj20,",                                                                                               
             "faj26.faj_file.faj26,",                                                                                               
             "faj29.faj_file.faj29,",                                                                                               
             "faj83.faj_file.faj83,",                                                                                               
             "faj89.faj_file.faj89,",                                                                                               
             "fap03.fap_file.fap03,",                                                                                               
             "fap04.fap_file.fap04,",                                                                                               
             "fap50.fap_file.fap50,",                                                                                               
             "fap56.fap_file.fap56,",                                                                                               
             "fbf04.fbf_file.fbf04,",                                                                                               
             "fbf07.fbf_file.fbf07,",                                                                                               
             "fbf09.fbf_file.fbf09,",                                                                                               
             "fbf11.fbf_file.fbf11,", 
             "glno.fbe_file.fbe14,",
             "l_fch07.fch_file.fch07"                                                                                              
   LET l_table = cl_prt_temptable('afar208',g_sql) CLIPPED                                                                          
   IF l_table= -1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                              
             " VALUES(?,?,?,?, ?,?,?,?,",                                                                                           
             "        ?,?,?,?, ?,?,?,?,",
             "        ?,?,?,?, ?,?,?)"                                                                                            
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN
      CALL cl_err('insert_prep',status,1) EXIT PROGRAM                                                                              
   END IF                                                                                                                           
#No.FUN-780046--end-- 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)   #TQC-610055
   LET tm.edate = ARG_VAL(9)   #TQC-610055
   LET tm.s  = ARG_VAL(10)   #TQC-610055
   LET tm.t  = ARG_VAL(11)   #TQC-610055
   LET tm.v  = ARG_VAL(12)   #TQC-610055
   LET tm.p  = ARG_VAL(13)   #FUN-C30229 add
  #FUN-C30229---mark--START
  ##No:FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(13)
  #LET g_rep_clas = ARG_VAL(14)
  #LET g_template = ARG_VAL(15)
  #LET g_rpt_name = ARG_VAL(16)  #No:FUN-7C0078
  ##No:FUN-570264 ---end---
  #FUN-C30229---mark--END
  #FUN-C30229---add--START
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No:FUN-7C0078
  #FUN-C30229---add--END
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afar208_tm(0,0)        # Input print condition
      ELSE CALL afar208()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afar208_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW afar208_w AT p_row,p_col WITH FORM "afa/42f/afar208"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.more = 'N'
   LET tm.p    = '1' #FUN-C30229 add
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
         LET INT_FLAG = 0 CLOSE WINDOW afar208_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
         INPUT BY NAME
            tm.bdate,tm.edate,tm2.s1,tm2.s2,tm2.s3,
            tm2.t1,tm2.t2,tm2.t3,tm2.u1,tm2.u2,tm2.u3,tm.p,tm.more #FUN-C30229 add tm.p
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
           #FUN-C30229 add START
            AFTER FIELD p
               IF tm.p NOT MATCHES "[12]" OR cl_null(tm.p) THEN
                  NEXT FIELD p
               END IF
           #FUN-C30229 add END
            AFTER FIELD more
               IF tm.more NOT MATCHES "[YN]" THEN
                  NEXT FIELD FORMONLY.more
               END IF
               IF tm.more = 'Y' THEN
                  CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
               END IF
            AFTER INPUT
               LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
               LET tm.t = tm2.t1,tm2.t2,tm2.t3
               LET tm.v = tm2.u1,tm2.u2,tm2.u3
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
            ON ACTION CONTROLG
               CALL cl_cmdask()     # Command execution
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
         LET INT_FLAG = 0 CLOSE WINDOW afar208_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afar208'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afar208','9031',1)
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
							" '",tm.p CLIPPED,"'", #FUN-C30229 add
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afar208',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afar208_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afar208()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afar208_w
END FUNCTION
 
FUNCTION afar208()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
         #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT #No.FUN-680070 VARCHAR(1000) #FUN-C30229 mark
          l_sql     STRING, #FUN-C30229 add
          l_za05    LIKE za_file.za05,            #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE fap_file.fap50,            #No.FUN-680070 VARCHAR(20)
          sr        RECORD order1 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
                           order2 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
                           order3 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
                           faj04 LIKE faj_file.faj04,    # 資產類別
                           faj02 LIKE faj_file.faj02,    # 財產編號
                           faj022 LIKE faj_file.faj022,  # 附號
                           faj01 LIKE faj_file.faj01,    # 序號
                           faj20 LIKE faj_file.faj20,    # 保管部門
                           faj06 LIKE faj_file.faj06,    # 中文名稱No:7661
                           faj08 LIKE faj_file.faj08,    # 規格型號
                           faj17 LIKE faj_file.faj17,    # 數量
                           faj26 LIKE faj_file.faj26,    # 入帳日期
                           faj29 LIKE faj_file.faj29,    # 耐用年限
                           faj82 LIKE faj_file.faj82,    #
                           faj83 LIKE faj_file.faj83,    #
                           faj88 LIKE faj_file.faj88,    #
                           faj89 LIKE faj_file.faj89,    #
                           fap03 LIKE fap_file.fap03,    # 異動代號
                           fap04 LIKE fap_file.fap04,    # 異動日期
                           fap07 LIKE fap_file.fap07,    # 未使用年限
                           fap56 LIKE fap_file.fap56,    # 銷帳成本
                           fap50 LIKE fap_file.fap50,    # 單據編號
                           fap501 LIKE fap_file.fap501,  #     項次
                           fap20 LIKE fap_file.fap20,    # 異動前數量
                           fap21 LIKE fap_file.fap21,    #     銷帳量
                           fap54 LIKE fap_file.fap54,    # 本期銷帳累折
                           fap57 LIKE fap_file.fap57,    #     銷帳累折
                           fbf04 LIKE fbf_file.fbf04,    #     數量
                           fbf07 LIKE fbf_file.fbf07,    # 處份累折
                           fbf09 LIKE fbf_file.fbf09,    # 處份損益
                           code  LIKE fap_file.fap03,    # 異動代號
                           desc  LIKE type_file.chr4,    # 中文       #No.FUN-680070 VARCHAR(04)
                           reson LIKE fag_file.fag03,    # 說明
                           glno  LIKE fbe_file.fbe14,    # 傳票編號
                           fbf11 LIKE fbf_file.fbf11     #No.CHI-480001
                        END RECORD,
          b,c LIKE fan_file.fan07,
          l_fch07   LIKE fch_file.fch07
     DEFINE l_i,l_cnt         LIKE type_file.num5               #No.FUN-680070 SMALLINT
     DEFINE l_zaa02           LIKE zaa_file.zaa02
     DEFINE d                 LIKE fan_file.fan07               #No.FUN-780046
     DEFINE e                 LIKE fan_file.fan07               #No.FUN-780046
     DEFINE fanb              LIKE fan_file.fan07               #No.FUN-780046
     DEFINE fanc              LIKE fan_file.fan07               #No.FUN-780046
     DEFINE fand              LIKE fan_file.fan07               #No.FUN-780046
     DEFINE fane              LIKE fan_file.fan07               #No.FUN-780046
     DEFINE l_fbe073          LIKE fbe_file.fbe073              #TQC-C70099
     DEFINE l_fbe09           LIKE fbe_file.fbe09               #TQC-C70099
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-780046                                                     
     CALL cl_del_data(l_table)                                   #No.FUN-780046
     #No.CHI-480001
     #end
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     IF tm.p = '1' THEN #FUN-C30229 
        LET l_sql = "SELECT '','','',",
                    " faj04, faj02, faj022, faj01, faj20, faj06,",  #No:7661
                    " faj08, faj17, faj26, faj29, ",
                    " faj82, faj83,faj88,faj89,",
                    " fap03, fap04, fap07, fap56,fap50,fap501,",
                    " fap20,fap21,fap54,fap57,",
                    " '','','','','','','','' ",         #No.CHI-480001
                    " FROM faj_file,fap_file ",
                    " WHERE faj02= fap02 AND faj022 = fap021 ",
                    "  AND fap03 IN ('4','5','6') ",
                    "  AND fap04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                    "  AND ",tm.wc CLIPPED
    #FUN-C30229 add START
     ELSE
        LET l_sql = "SELECT '','','',",
                    " faj04, faj02, faj022, faj01, faj20, faj06,",  #No:7661
                    " faj08, faj17, faj262, faj292, ",
                    " faj82, faj83,faj88,faj89,",
                    " fap03, fap042, fap072, fap562,fap50,fap501,",
                    " fap20,fap21,fap542,fap572,",
                    " '','','','','','','','' ",         #No.CHI-480001
                    " FROM faj_file,fap_file ",
                    " WHERE faj02= fap02 AND faj022 = fap021 ",
                    "  AND fap03 IN ('4','5','6') ",
                    "  AND fap04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                    "  AND ",tm.wc CLIPPED
     END IF
    #FUN-C30229 add END 
     PREPARE afar208_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afar208_curs1 CURSOR FOR afar208_prepare1
#No.FUN-780046--start--
#     CALL cl_outnam('afar208') RETURNING l_name
 
#No.FUN-580010 --start
           IF g_aza.aza26 = '2' THEN
#           LET g_zaa[44].zaa06 = "N"
            LET l_name='afar208_1'
           ELSE
#           LET g_zaa[44].zaa06 = "Y"
            LET l_name='afar208'
           END IF
      CALL cl_prt_pos_len()
#No.FUN-580010 --end
 
#     START REPORT afar208_rep TO l_name
#     LET g_pageno = 0
     FOREACH afar208_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#FUN-D70122 add ------- begin#获取帐套
       CALL s_get_bookno(YEAR(sr.fap04))
             RETURNING g_flag,g_bookno1,g_bookno2
       IF g_flag= '1' THEN  
          CALL cl_err(YEAR(sr.fap04),'aoo-081',1)    
       END IF
#FUN-D70122 add ------- end
       SELECT fbe073,fbe09 INTO l_fbe073,l_fbe09 FROM fbe_file WHERE fbe01 = sr.fap50       #TQC-C70099   add
       CASE
        WHEN  sr.fap03 = '4'  #出售
#              LET sr.desc = g_x[27] clipped
              IF tm.p = '1' THEN #FUN-C30229 add
              SELECT fbe14,fag03,fbf04,fbf07,fbf09,fbf11        #No.CHI-480001
                INTO sr.glno,sr.reson,sr.fbf04,sr.fbf07,sr.fbf09,sr.fbf11  #end
                FROM fbe_file,fbf_file,OUTER fag_file
               WHERE fbe01 = fbf01 AND fbf_file.fbf05=fag_file.fag02
                 AND fbf01 = sr.fap50 AND fbf02 = sr.fap501
                 AND fbeconf='Y'  AND fbepost = 'Y'
             #FUN-C30229---add---START
              ELSE
                 SELECT fbe142,fag03,fbf04,fbf072,fbf092,fbf112        #No.CHI-480001
                  INTO sr.glno,sr.reson,sr.fbf04,sr.fbf07,sr.fbf09,sr.fbf11  #end
                  FROM fbe_file,fbf_file,OUTER fag_file
                 WHERE fbe01 = fbf01 AND fbf_file.fbf05=fag_file.fag02
                   AND fbf01 = sr.fap50 AND fbf02 = sr.fap501
                   AND fbeconf='Y'  AND fbepost = 'Y'
              END IF
             #FUN-C30229---add---END
              #TQC-C70099--add--str--
              IF l_fbe073 = 'Y' THEN 
                 LET sr.fbf07 = l_fbe09   
              END IF 
              #TQC-C70099--add--end--
              IF SQLCA.sqlcode<>0 THEN
                 LET sr.glno= ' '  LET sr.reson = ' ' LET sr.fbf09 = ' '
                 LET sr.fbf07= ' ' LET sr.fbf04= ' '
                 LET sr.fbf11= ' '        #No.CHI-480001
              END IF
        WHEN  sr.fap03 = '5'  #報廢
#              LET sr.desc = g_x[28] clipped
			  IF tm.p = '1' THEN #FUN-C30229 add
              SELECT fbg08,fag03,fbh04,(fbh08*-1),fbh12          #No.CHI-480001
                INTO sr.glno,sr.reson,sr.fbf04,sr.fbf09,sr.fbf11      #end
                FROM fbg_file,fbh_file,OUTER fag_file
               WHERE fbg01 = fbh01 AND fbh_file.fbh05=fag_file.fag02 AND fbg00 = '1'
                 AND fbh01 = sr.fap50 AND fbh02 = sr.fap501
                 AND fbgconf='Y' AND fbgpost = 'Y'
             #FUN-C30229---add---START
              ELSE
                 SELECT fbg082,fag03,fbh04,(fbh082*-1),fbh122          #No.CHI-480001
                  INTO sr.glno,sr.reson,sr.fbf04,sr.fbf09,sr.fbf11      #end
                  FROM fbg_file,fbh_file,OUTER fag_file
                 WHERE fbg01 = fbh01 AND fbh_file.fbh05=fag_file.fag02 AND fbg00 = '1'
                   AND fbh01 = sr.fap50 AND fbh02 = sr.fap501
                   AND fbgconf='Y' AND fbgpost = 'Y'
              END IF
             #FUN-C30229---add---END
              #TQC-C70099--add--str--
              IF l_fbe073 = 'Y' THEN
                 LET sr.fbf07 = l_fbe09
              END IF
              #TQC-C70099--add--end--
              IF SQLCA.sqlcode<>0 THEN
                 LET sr.glno= ' '  LET sr.reson = ' ' LET sr.fbf09 = ' '
                 LET sr.fbf07= ' ' LET sr.fbf04= ' '
                 LET sr.fbf11= ' '        #No.CHI-480001
              END IF
        WHEN  sr.fap03 = '6'  #銷帳
#              LET sr.desc = g_x[29] clipped
			  IF tm.p = '1' THEN #FUN-C30229 add
              SELECT fbg08,fag03,fbh04,(fbh08*-1),fbh12          #No.CHI-480001
                INTO sr.glno,sr.reson,sr.fbf04,sr.fbf09,sr.fbf11    #end
                FROM fbg_file,fbh_file,OUTER fag_file
               WHERE fbg01 = fbh01 AND fbh_file.fbh05=fag_file.fag02 AND fbg00 = '2'
                 AND fbh01 = sr.fap50 AND fbh02 = sr.fap501
                 AND fbgconf='Y' AND fbgpost = 'Y'
             #FUN-C30229---add---START
              ELSE
                 SELECT fbg082,fag03,fbh04,(fbh082*-1),fbh122          #No.CHI-480001
                  INTO sr.glno,sr.reson,sr.fbf04,sr.fbf09,sr.fbf11    #end
                  FROM fbg_file,fbh_file,OUTER fag_file
                 WHERE fbg01 = fbh01 AND fbh_file.fbh05=fag_file.fag02 AND fbg00 = '2'
                   AND fbh01 = sr.fap50 AND fbh02 = sr.fap501
                   AND fbgconf='Y' AND fbgpost = 'Y'
              END IF
             #FUN-C30229---add---END
              #TQC-C70099--add--str--
              IF l_fbe073 = 'Y' THEN
                 LET sr.fbf07 = l_fbe09
              END IF
              #TQC-C70099--add--end--
              IF SQLCA.sqlcode<>0 THEN
                 LET sr.glno= ' '  LET sr.reson = ' ' LET sr.fbf09 = ' '
                 LET sr.fbf04= ' ' LET sr.fbf11= ' '        #No.CHI-480001
              END IF
       END CASE
       #-->抵押文號日期判斷
       IF sr.faj88 > tm.edate THEN LET sr.faj89 = ' ' END IF
       #-->投資底減文號日期判斷
       IF sr.faj82 > tm.edate THEN LET sr.faj83 = ' ' END IF
       #-->免稅文號日期判斷
       SELECT fch07 INTO l_fch07 FROM fch_file,fci_file
                         WHERE fch01 = fci01
                         AND fch03 = sr.faj02 AND fch031 = sr.faj022
                         AND fch06 between tm.bdate and tm.edate
                         AND fchconf !='X'   #010803增
       IF SQLCA.sqlcode THEN LET l_fch07 = ' ' END IF
       #--->本期銷帳累折/前期銷帳累折
       IF cl_null(sr.fap54) THEN
            #--->前期銷帳累折
            IF tm.p = '1' THEN #FUN-C30229 add
#FUN-D70122 mark 130729 ------- begin
#           SELECT SUM(fan07) INTO b FROM fan_file
#            WHERE fan01=sr.faj02 AND fan02=sr.faj022
#              AND fan03 < YEAR(sr.fap04)
#              AND fan041 = '1'
#FUN-D70122 mark 130729 ------- end
#FUN-D70122 add 130729 ---------- begin
            SELECT SUM(fan07) INTO b FROM fan_file,aznn_file
             WHERE fan01=sr.faj02 AND fan02=sr.faj022
               AND fan03 < aznn02
               AND fan041 = '1'
               AND aznn00 = g_bookno1
               AND aznn01 = sr.fap04
#FUN-D70122 add 130729 ---------- end
           #FUN-C30229---add START 
            ELSE
#FUN-D70122 mark 130729 ------- begin
#              SELECT SUM(fbn07) INTO b FROM fbn_file
#               WHERE fbn01=sr.faj02 AND fbn02=sr.faj022
#                 AND fbn03 < YEAR(sr.fap04)
#                 AND fbn041 = '1'
#FUN-D70122 mark 130729 ------- end
#FUN-D70122 add 130729 ---------- begin
               SELECT SUM(fbn07) INTO b FROM fbn_file,aznn_file
                WHERE fbn01=sr.faj02 AND fbn02=sr.faj022
                  AND fbn03 < aznn02
                  AND fbn041 = '1'
                  AND aznn00 = g_bookno1
                  AND aznn01 = sr.fap04
#FUN-D70122 add 130729 ---------- end
            END IF 
           #FUN-C30229---add END
            IF cl_null(b)  THEN LET b = 0 END IF
            #--->本期銷帳累折
            IF tm.p = '1' THEN #FUN-C30229 add
#FUN-D70122 mark 130729 ------- begin
#           SELECT SUM(fan07) INTO c FROM fan_file
#            WHERE fan01=sr.faj02 AND fan02=sr.faj022
#              AND fan03=YEAR(sr.fap04) AND fan04<=MONTH(sr.fap04)
#              AND fan041 = '1'
#FUN-D70122 mark 130729 ------- end
#FUN-D70122 add  130729 ---------- begin
            SELECT SUM(fan07) INTO c FROM fan_file,aznn_file
             WHERE fan01=sr.faj02 AND fan02=sr.faj022
               AND fan03  = aznn02 AND fan04<=aznn04
               AND fan041 = '1'
               AND aznn00 = g_bookno1
               AND aznn01 = sr.fap04
#FUN-D70122 add 130729 ---------- end
           #FUN-C30229---add START
            ELSE
#FUN-D70122 mark 130729 ------- begin
#              SELECT SUM(fbn07) INTO c FROM fbn_file
#               WHERE fbn01=sr.faj02 AND fbn02=sr.faj022
#                 AND fbn03=YEAR(sr.fap04) AND fbn04<=MONTH(sr.fap04)
#                 AND fbn041 = '1'
#FUN-D70122 mark 130729 ------- end
#FUN-D70122 add 130729 ---------- begin
               SELECT SUM(fbn07) INTO c FROM fbn_file,aznn_file
                WHERE fbn01=sr.faj02 AND fbn02=sr.faj022
                  AND fbn03=aznn02 AND fbn04<=aznn04
                  AND fbn041 = '1'
                  AND aznn00 = g_bookno1
                  AND aznn01 = sr.fap04
#FUN-D70122 add 130729 ---------- end
            END IF
           #FUN-C30229---add END
            IF cl_null(c)  THEN LET c = 0 END IF
            #-->部份出售時
            IF (sr.fap20-sr.fap21) != sr.fbf04 THEN
               LET c        = (c / sr.faj17) * sr.fbf04           #本期折舊
               LET b        = (b / sr.faj17) * sr.fbf04           #前期折舊
            END IF
       ELSE
            #--->本期銷帳累折
            LET c = sr.fap54
            #--->前期銷帳累折 = 銷帳累折 - 本期銷帳累折
            LET b = sr.fap57 - c
       END IF
      {FOR g_i = 1 TO 3
       CASE    WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj20
                                        LET g_descripe[g_i]=g_x[21]
               WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.fap50
                                        LET g_descripe[g_i]=g_x[22]
               WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj02
                                        LET g_descripe[g_i]=g_x[23]
               WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj022
                                        LET g_descripe[g_i]=g_x[24]
               WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj04
                                        LET g_descripe[g_i]=g_x[25]
               WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.fap03
                                        LET g_descripe[g_i+1]=g_x[26]
               OTHERWISE LET l_order[g_i+1] = '-'
          END CASE
       END FOR
       LET sr.order1 = l_order[1]
       LET sr.order2 = l_order[2]
       LET sr.order3 = l_order[3]}
 
       LET d=b+c
       LET e=sr.fap56-d
       LET fanb=b
       LET fanc=c
       LET fand=d
       LET fane=e
       EXECUTE insert_prep USING 
               fanb,fanc,fand,fane,sr.faj02,sr.faj022,sr.faj04,sr.faj06,sr.faj20,
               sr.faj26,sr.faj29,sr.faj83,sr.faj89,sr.fap03,sr.fap04,sr.fap50,sr.fap56,sr.fbf04,
               sr.fbf07,sr.fbf09,sr.fbf11,sr.glno,l_fch07
#       OUTPUT TO REPORT afar208_rep(sr.*,b,c,l_fch07)
     END FOREACH
 
#    FINISH REPORT afar208_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(tm.wc,'faj20,fap50,fap02,fap021,faj04,fap03')                                                       
        RETURNING tm.wc                                                                                                             
        LET g_str = tm.wc                                                                                                           
     END IF
   #CHI-C60010---str---
     SELECT aaa03 INTO g_faj143 FROM aaa_file
      WHERE aaa01 = g_faa.faa02c
     IF NOT cl_null(g_faj143) THEN
       SELECT azi04 ,azi05 INTO g_azi04_1,g_azi05_1 FROM azi_file
        WHERE azi01 = g_faj143
     END IF
     IF tm.p = '2' THEN
        LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                    tm.t[2,2],";",tm.t[3,3],";",tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";",
                    g_azi04_1,";",g_azi05_1
     ELSE
    #CHI-C60010---end---                                                                                                                          
     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t[1,1],";",
                 tm.t[2,2],";",tm.t[3,3],";",tm.v[1,1],";",tm.v[2,2],";",tm.v[3,3],";",
                 g_azi04,";",g_azi05            
     END IF    #CHI-C60010                                                     
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
     CALL cl_prt_cs3('afar208',l_name,g_sql,g_str)
#No.FUN-780046--end--  
END FUNCTION
 
#No.CHI-480001
#原財編只印7碼, 現調整為10碼, 有些欄位列印位數不足, 故所有位置都需調整
#No.FUN--780046--start--
{REPORT afar208_rep(sr,b,c,l_fch07)
   DEFINE l_last_sw LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
          sr        RECORD order1 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
                           order2 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
                           order3 LIKE fap_file.fap50,   #No.FUN-680070 VARCHAR(20)
                           faj04 LIKE faj_file.faj04,    # 資產類別
                           faj02 LIKE faj_file.faj02,    # 財產編號
                           faj022 LIKE faj_file.faj022,  # 附號
                           faj01 LIKE faj_file.faj01,    # 序號
                           faj20 LIKE faj_file.faj20,    # 保管部門
                           faj06 LIKE faj_file.faj06,    # 中文名稱No:7661
                           faj08 LIKE faj_file.faj08,    # 規格型號
                           faj17 LIKE faj_file.faj17,    # 數量
                           faj26 LIKE faj_file.faj26,    # 入帳日期
                           faj29 LIKE faj_file.faj29,    # 耐用年限
                           faj82 LIKE faj_file.faj82,    #
                           faj83 LIKE faj_file.faj83,    #
                           faj88 LIKE faj_file.faj88,    #
                           faj89 LIKE faj_file.faj89,    #
                           fap03 LIKE fap_file.fap03,    # 異動代號
                           fap04 LIKE fap_file.fap04,    # 異動日期
                           fap07 LIKE fap_file.fap07,    # 未使用年限
                           fap56 LIKE fap_file.fap56,    # 銷帳成本
                           fap50 LIKE fap_file.fap50,    # 單據編號
                           fap501 LIKE fap_file.fap501,  #     項次
                           fap20 LIKE fap_file.fap20,    # 異動前數量
                           fap21 LIKE fap_file.fap21,    #     銷帳量
                           fap54 LIKE fap_file.fap54,    # 本期銷帳累折
                           fap57 LIKE fap_file.fap57,    # 銷帳累折
                           fbf04 LIKE fbf_file.fbf04,    #     數量
                           fbf07 LIKE fbf_file.fbf07,    # 處份累折
                           fbf09 LIKE fbf_file.fbf09,    # 處份損益
                           code  LIKE fap_file.fap03,    # 異動代號
                           desc  LIKE type_file.chr4,    # 中文       #No.FUN-680070 VARCHAR(04)
                           reson LIKE fag_file.fag03,    # 說明
                           glno  LIKE fbe_file.fbe14,    # 傳票編號
                           fbf11 LIKE fbf_file.fbf11     #No.CHI-480001
                    END RECORD,
          b,c,d,e   LIKE fan_file.fan07,
          l_fch07   LIKE fch_file.fch07,
          p_str     LIKE type_file.chr50,                #No.FUN-680070 VARCHAR(50)
          l_ymd     LIKE type_file.chr8                  #No.FUN-680070 VARCHAR(8)
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.order1,sr.order2,sr.order3
  FORMAT
   PAGE HEADER
#No.FUN-580010 --start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      LET g_head1= tm.bdate,g_x[30] CLIPPED,' ',tm.edate
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
            g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],
            g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
            g_x[51],g_x[52]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.order1
      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order2
      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   BEFORE GROUP OF sr.order3
      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
   ON EVERY ROW
      LET d = b + c
      LET e = sr.fap56 - d
      #No.CHI-480001
      PRINT COLUMN g_c[31],sr.faj04,
            COLUMN g_c[32],sr.faj02,'-',sr.faj022,
            COLUMN g_c[33],sr.faj20,
            COLUMN g_c[34],sr.faj06,                  #No:7661
            COLUMN g_c[35],cl_numfor(sr.fbf04,15,0),
            COLUMN g_c[36],sr.faj26,
            COLUMN g_c[37],sr.faj29 USING '<<<<<',
            COLUMN g_c[38],sr.fap04,
            COLUMN g_c[39],cl_numfor(sr.fap56,39,g_azi04),
            COLUMN g_c[40],cl_numfor(b,40,g_azi04),
            COLUMN g_c[41],cl_numfor(c,41,g_azi04),
            COLUMN g_c[42],cl_numfor(d,42,g_azi04),
            COLUMN g_c[43],cl_numfor(e,43,g_azi04),
            COLUMN g_c[44],cl_numfor(e-sr.fbf11,44,g_azi04),
            COLUMN g_c[45],cl_numfor(sr.fbf07,45,g_azi04),
            COLUMN g_c[46],cl_numfor(sr.fbf09,46,g_azi04),
            COLUMN g_c[47],sr.desc,
            COLUMN g_c[48],sr.glno,
            COLUMN g_c[49],sr.fap50,
            COLUMN g_c[50],sr.faj89,
            COLUMN g_c[51],sr.faj83,
            COLUMN g_c[52],l_fch07
            #end No.CHI-480001
 
   AFTER GROUP OF sr.order1
      IF tm.v[1,1] = 'Y'
      THEN PRINT ' '
           #No.CHI-480001
           PRINTX  name=S1
             COLUMN g_c[32],g_descripe[1] CLIPPED,
             COLUMN g_c[39],cl_numfor(group sum(sr.fap56),39,g_azi05),   #成本
	     COLUMN g_c[40],cl_numfor(group sum(b),40,g_azi05),         #前期累折
             COLUMN g_c[41],cl_numfor(group sum(c),41,g_azi05),         #本期折舊
             COLUMN g_c[42],cl_numfor(group sum(b+c),42,g_azi05),       #處分累折
             COLUMN g_c[43],cl_numfor(group sum(sr.fap56-b-c),43,g_azi05), #帳面價值
             COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fap56-b-c-sr.fbf11),44,g_azi05),
   	     COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbf07),45,g_azi05),
    	     COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fbf09),46,g_azi05)
           #end No.CHI-480001
         PRINT
      END IF
 
   AFTER GROUP OF sr.order2
      IF tm.v[2,2] = 'Y'
      THEN PRINT ' '
           #No.CHI-480001
           PRINTX name=S2
             COLUMN g_c[32],g_descripe[2] CLIPPED,
             COLUMN g_c[39],cl_numfor(group sum(sr.fap56),39,g_azi05),   #成本
	     COLUMN g_c[40],cl_numfor(group sum(b),40,g_azi05),         #前期累折
             COLUMN g_c[41],cl_numfor(group sum(c),41,g_azi05),         #本期折舊
             COLUMN g_c[42],cl_numfor(group sum(b+c),42,g_azi05),       #處分累折
             COLUMN g_c[43],cl_numfor(group sum(sr.fap56-b-c),43,g_azi05), #帳面價值
             COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fap56-b-c-sr.fbf11),44,g_azi05),
   	     COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbf07),45,g_azi05),
    	     COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fbf09),46,g_azi05)
           PRINT
      END IF
 
   AFTER GROUP OF sr.order3
      IF tm.v[3,3] = 'Y'
      THEN PRINT ' '
           #No.CHI-480001
           PRINTX name=S3
             COLUMN g_c[32],g_descripe[3] CLIPPED,
             COLUMN g_c[39],cl_numfor(group sum(sr.fap56),39,g_azi05),   #成本
	     COLUMN g_c[40],cl_numfor(group sum(b),40,g_azi05),         #前期累折
             COLUMN g_c[41],cl_numfor(group sum(c),41,g_azi05),         #本期折舊
             COLUMN g_c[42],cl_numfor(group sum(b+c),42,g_azi05),       #處分累折
             COLUMN g_c[43],cl_numfor(group sum(sr.fap56-b-c),43,g_azi05), #帳面價值
             COLUMN g_c[44],cl_numfor(GROUP SUM(sr.fap56-b-c-sr.fbf11),44,g_azi05),
   	     COLUMN g_c[45],cl_numfor(GROUP SUM(sr.fbf07),45,g_azi05),
    	     COLUMN g_c[46],cl_numfor(GROUP SUM(sr.fbf09),46,g_azi05)
         PRINT
      END IF
 
   ON LAST ROW
      PRINT g_dash1
      LET l_last_sw = 'y'
      PRINTX name=S4
             COLUMN g_c[32], g_x[11] clipped,
             COLUMN g_c[39], cl_numfor(sum(sr.fap56),39,g_azi05),     #成本
	     COLUMN g_c[40],cl_numfor(sum(b),40,g_azi05),            #前期累折
             COLUMN g_c[41],cl_numfor(sum(c),41,g_azi05),            #本期折舊
             COLUMN g_c[42],cl_numfor(sum(b+c),42,g_azi05),          #處分累折
             COLUMN g_c[43],cl_numfor(sum(sr.fap56-b-c),43,g_azi05), #帳面價值
             COLUMN g_c[44],cl_numfor(SUM(sr.fap56-b-c-sr.fbf11),44,g_azi05),
     	     COLUMN g_c[45],cl_numfor(SUM(sr.fbf07),45,g_azi05),
      	     COLUMN g_c[46],cl_numfor(SUM(sr.fbf09),46,g_azi05)
         PRINT
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-780046--end--
#Patch....NO.TQC-610035 <> #
