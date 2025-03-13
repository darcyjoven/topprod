# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapr190.4gl
# Descriptions...: 應付帳款帳齡分析表列印
# Date & Author..: 93/08/11  By  Felicity  Tseng
# Modify         : No.MOD-530780 05/03/28 by alexlin VARCHAR->CHAR
# Modify.........: No.FUN-570011 05/07/08 By Nicola 此表末包括折讓
# Modify.........: No.FUN-580010 05/08/08 By will 報表轉XML格式
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.MOD-5C0070 05/12/13 By Carrier apz27='N'-->apa34-apa35,
#                                                    apz27='Y'-->apa73
# Modify.........: No.TQC-610098 06/01/23 By Smapmin 未付金額需扣除留置金額
# Modify.........: No.MOD-650073 06/05/16 By Smapmin 修改SQL之Where條件
# Modify.........: No.FUN-580184 06/06/20 By alexstar 一進入報表與批次作業, 即開始記錄執行
# Modify.........: No.TQC-610053 06/07/03 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680027 06/08/29 By cl      多帳期修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-690141 06/11/16 By Smapmin 修正TQC-610053
# Modify.........: No.MOD-720043 07/02/12 By TSD.Martin 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/30 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-720128 07/05/04 By Smapmin 金額不需扣除留置金額
# Modify.........: No.TQC-750228 07/05/29 By Rayven 不應包含應付立暫估資料
# Modify.........: No.MOD-760068 07/06/15 By Smapmin 修改WHERE 條件寫法
# Modify.........: No.TQC-770052 07/07/12 By Rayven 是否需要打印明細帳資料的地方,系統沒有自動帶出缺省值
# Modify.........: No.MOD-7C0113 07/12/17 By Smapmin 修改變數定義
# Modify.........: No.MOD-8B0245 09/05/06 By wujie   去掉apa55=1的條件
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990220 09/10/18 By mike 針對折讓部份(aph_file)也應將大於截止日之金額加回。                                
# Modify.........: No:MOD-9A0060 09/10/22 By mike TQC-750228排除UNAP资料,但若该AP为多角单据,apa08为NULL,会影响资料列印              
# Modify.........: No:TQC-A40116 10/04/23 By fumk 更改sql语句 
# Modify.........: No:FUN-B40099 10/05/23 By wujie 调整多帐期帐龄的显示
# Modify.........: No:MOD-B40121 11/04/15 By Sarah 因應MOD-A80130的修改,金額負數的判斷式也應改為apa00 MATCHES '2*'
# Modify.........: No:TQC-B70203 11/07/28 By Sarah 未付金額計算應包含apc15
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/25 By fengrui  調整時間函數問題
# Modify.........: No:MOD-C70277 12/07/27 By Polly 開放外購部分取消相關 apa74 條件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
                 wc      LIKE type_file.chr1000,     # Where condition  #No.FUN-690028 VARCHAR(600)
                 a1      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
                 a2      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
                 a3      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
                 a4      LIKE type_file.num5,        # No.FUN-690028 SMALLINT,
#                 a5      SMALLINT,   #TQC-610053
# Prog. Version..: '5.30.06-13.03.12(01),   #TQC-610053
# Prog. Version..: '5.30.06-13.03.12(01),   #TQC-610053
# Prog. Version..: '5.30.06-13.03.12(01),   #TQC-610053
                 detail  LIKE type_file.chr1,       # No.FUN-690028 VARCHAR(01),
                 edate   LIKE type_file.dat,        #No.FUN-690028 DATE
                 more    LIKE type_file.chr1        # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   l_table        STRING,                 ### CR11 ###
         g_str          STRING,                 ### CR11 ###
         g_sql          STRING                  ### CR11 ###
#No.FUN-580010  --begin
#DEFINE   g_dash          VARCHAR(400)   #Dash line
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580010  --end
#     DEFINEl_time    LIKE type_file.chr8         #No.FUN-6A0055
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-580184  #No.FUN-6A0055 #FUN-BB0047 mark
 
   #MOD-720043 -START
   ## *** CR11 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.Martin  *** ##
   LET g_sql = "apa21.apa_file.apa21,",  #業務員編號
               "gen02.gen_file.gen02,",  #業務員name
               "apa22.apa_file.apa22,",  #部門
               "apa06.apa_file.apa06,",  #客戶
               "apa07.apa_file.apa07,",  #簡稱
               "apa02.apa_file.apa02,",  #Date
               "apa01.apa_file.apa01,",
               "num1.apg_file.apg05,",
               "num2.apg_file.apg05,",
               "num3.apg_file.apg05,",
               "num4.apg_file.apg05,",
               "num5.apg_file.apg05,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05 " 
 
   LET l_table = cl_prt_temptable('aapr190',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF                  # Temp Table產生
 #  LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,         #TQC-A40116 mark  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,#TQC-A40116 modify     
            " VALUES(?, ?, ?, ?, ?,   ?, ? , ?, ? , ?, ",
               "        ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055 #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
   #----------------------------------------------------------CR (1) ------------#
   #MOD-720043 -END
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047
   INITIALIZE tm.* TO NULL            # Default condition
#  LET tm.s='1234'   #TQC-610053
#  LET tm.t='   '   #TQC-610053
#  LET tm.u='YY '   #TQC-610053
#  LET tm.n='N'   #TQC-610053
   LET tm.detail='N'
   LET tm.edate=g_today
  #-----TQC-610053---------
  LET g_pdate = ARG_VAL(1)
  LET g_towhom = ARG_VAL(2)
  LET g_rlang = ARG_VAL(3)
  LET g_bgjob = ARG_VAL(4)
  LET g_prtway = ARG_VAL(5)
  LET g_copies = ARG_VAL(6)
  LET tm.wc = ARG_VAL(7)
  LET tm.a1 = ARG_VAL(8)
  LET tm.a2 = ARG_VAL(9)
  LET tm.a3 = ARG_VAL(10)
  LET tm.a4 = ARG_VAL(11)
  LET tm.edate = ARG_VAL(12)
  LET tm.detail = ARG_VAL(13)
  #-----END TQC-610053-----
  #No.FUN-570264 --start--
  LET g_rep_user = ARG_VAL(14)
  LET g_rep_clas = ARG_VAL(15)
  LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
  #No.FUN-570264 ---end---
 
   IF cl_null(tm.wc) THEN
      CALL r190_tm(0,0)
   ELSE
      LET tm.wc="apa01= '",tm.wc CLIPPED,"'"
      CALL r190()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80105    ADD 
END MAIN
 
FUNCTION r190_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690028 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 16
   OPEN WINDOW r190_w AT p_row,p_col #p_row,p_col
     WITH FORM "aap/42f/aapr190"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   #-----MOD-690141---------
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #-----END MOD-690141-----
   LET tm.detail = 'N' #No.TQC-770052
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON apa22,apa21,apa06
 
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
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r190_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
 
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
 
      LET tm.a1 = g_apz.apz45
      LET tm.a2 = g_apz.apz46
      LET tm.a3 = g_apz.apz47
      LET tm.a4 = g_apz.apz48
 
      INPUT BY NAME tm.a1,tm.a2,tm.a3,tm.a4,tm.edate,tm.detail,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD edate
            IF tm.edate IS NULL THEN
               NEXT FIELD edate
            END IF
            IF MONTH(tm.edate) = MONTH(tm.edate+1) THEN
 #No.MOD-580325-begin
               CALL cl_err('','aap-993',1)
#              ERROR "請輸入月底日期!"
 #No.MOD-580325-end
               NEXT FIELD edate
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW r190_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aapr190'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aapr190','9031',1)
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
                        " '",tm.wc CLIPPED,"'" ,
                       # " '",tm.s CLIPPED,"'" ,   #TQC-610053
                       # " '",tm.t CLIPPED,"'" ,   #TQC-610053
                       # " '",tm.u CLIPPED,"'" ,   #TQC-610053
                        " '",tm.a1 CLIPPED,"'" ,
                        " '",tm.a2 CLIPPED,"'" ,
                        " '",tm.a3 CLIPPED,"'" ,
                        " '",tm.a4 CLIPPED,"'" ,
                        " '",tm.edate CLIPPED,"'" ,
                        " '",tm.detail CLIPPED,"'" ,   #TQC-610053
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aapr190',g_time,l_cmd)    # Execute cmd at later time
         END IF
 
         CLOSE WINDOW r190_w
         CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL r190()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW r190_w
 
END FUNCTION
 
FUNCTION r190()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#         l_time    LIKE type_file.chr8,           # Used time for running the job  #No.FUN-690028 VARCHAR(8)
          l_sql     STRING, #No.FUN-690028 VARCHAR(1200)   #MOD-7C0113
          amt1,amt2 LIKE apg_file.apg05,
          l_za05    LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(40)
          l_bucket  LIKE type_file.num5,    # No.FUN-690028 SMALLINT,
          l_order   ARRAY[5] OF  LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(10),
          sr        RECORD
                       apa21     LIKE apa_file.apa21,  #業務員編號
                       gen02     LIKE gen_file.gen02,  #業務員name
                       apa22     LIKE apa_file.apa22,  #部門
                       apa06     LIKE apa_file.apa06,  #客戶
                       apa07     LIKE apa_file.apa07,  #簡稱
                       apa02     LIKE apa_file.apa02,  #Date
                       apa01     LIKE apa_file.apa01,
                       num1      LIKE apg_file.apg05,
                       num2      LIKE apg_file.apg05,
                       num3      LIKE apg_file.apg05,
                       num4      LIKE apg_file.apg05,
                       num5      LIKE apg_file.apg05,
                       tot       LIKE apg_file.apg05
                    END RECORD
   DEFINE l_apa00   LIKE apa_file.apa00   #No.FUN-570011
   DEFINE l_apc02   LIKE apc_file.apc02   #No.FUN-680027 add
   DEFINE l_apc04   LIKE apc_file.apc04   #No.FUN-B40099 
 
     #MOD-720043 -START
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
     CALL cl_del_data(l_table)
     #------------------------------ CR (2) ------------------------------#
     #MOD-720043 -END
 
#      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #MOD-720043 add
 
#No.FUN-580010  --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapr190'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 142 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-580010  --end
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND apauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND apagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND apagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('apauser', 'apagrup')
     #End:FUN-980030
 
     #No.MOD-5C0070  --Begin
     IF g_apz.apz27 = 'N' THEN
        LET l_sql="SELECT apa21, gen02, apa22,",
                  "       apa06, apa07,apa02, apa01,",
                 #"       apa34-apa35,0,0,0,0,0,apa00",     #No.FUN-570011   #TQC-610098
                 #"       apa34-apa35-apa20*apa14,0,0,0,0,0,apa00",  #TQC-610098  #No.FUN-680027 mark
                 #"       apc09-apc11-apc16*apa14,0,0,0,0,0,apa00,apc02",  #No.FUN-680027    #MOD-720128
                  "       apc09-apc11-apc15,0,0,0,0,0,apa00,apc02,apc04",    #MOD-720128   #No.FUN-B40099 add apc04  #TQC-B70203 add apc15
                 #" FROM apa_file,OUTER gen_file",          #No.FUN-680027 mark
                  " FROM apc_file,apa_file LEFT OUTER JOIN gen_file ON(apa_file.apa21=gen_file.gen01)", #No.FUN-680027 add
                  " WHERE ",tm.wc CLIPPED,   #MOD-760068
                  "   AND apa01 = apc01 ",   #No.FUN-680027 
                 #"   AND apa08 <> 'UNAP' ",  #No.TQC-750228 #MOD-9A0060                                                            
                  "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)", #MOD-9A0060  
                 #"   AND apa00 LIKE '1%' AND apa41='Y' AND apa55='1'",
                  "   AND apa00 MATCHES '1*' AND apa41='Y' ",    #No.MOD-8B0245
                 #"   AND apa00 LIKE '1*' AND apa41='Y' AND apa55='1'",
                 #"   AND apa02 <= '",tm.edate,"' ANd apa42='N' AND apa74='N'",               #MOD-C70277 mark
                  "   AND apa02 <= '",tm.edate,"' ANd apa42='N' ",                            #MOD-C70277 add
                 #"   AND (apa34>apa35 OR",   #TQC-610098
                 #"   AND (apa34>apa35+apa20*apa14 OR",   #TQC-610098 #No.FUN-680027 mark
                 #"   AND (apc09>apc11+apc16*apa14 OR",   #No.FUN-680027    #MOD-720128
                  "   AND (apc09>apc11+apc15 OR",    #MOD-720128  #TQC-B70203 add apc15
                  "        apa01 IN (SELECT apg04 FROM apf_file,apg_file",
                  "              WHERE apf01=apg01 AND apf41 <> 'X' ",
                  "                AND apf02 > '",tm.edate,"'))"
        #-----No.FUN-570011-----
        LET l_sql = l_sql CLIPPED," UNION ",
                    "SELECT apa21, gen02, apa22,",
                    "       apa06, apa07,apa02, apa01,",
                   #"       apa34-apa35,0,0,0,0,0,apa00",   #TQC-610098
                   #"       apa34-apa35-apa20*apa14,0,0,0,0,0,apa00",   #TQC-610098 #No.FUN-680027 mark
                    #"       apc09-apc11-apc16*apa14,0,0,0,0,0,apa00,apc02",   #TQC-610098   #MOD-720128
                    "       apc09-apc11-apc15,0,0,0,0,0,apa00,apc02,apc04",    #MOD-720128   #No.FUN-B40099 add apc04  #TQC-B70203 add apc15
                   #" FROM apa_file,OUTER gen_file",            #No.FUN-680027 mark
                    " FROM apc_file,apa_file LEFT OUTER JOIN gen_file ON(apa_file.apa21=gen_file.gen01)",   #No.FUN-680027 
                    " WHERE ",tm.wc CLIPPED,   #MOD-760068
                    "   AND apa01 = apc01 ",    #No.FUN-680027 
                   #"   AND (apa00 = '21' OR apa00 = '22') AND apa41='Y' AND apa55='1'",
                    "   AND (apa00 = '21' OR apa00 = '22') AND apa41='Y' ",     #No.MOD-8B0245
                   #"   AND apa08 <> 'UNAP' ",  #No.TQC-750228 #MOD-9A0060                                                          
                    "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)",  #MOD-9A0060   
                   #"   AND apa02 <= '",tm.edate,"' ANd apa42='N' AND apa74='N'",         #MOD-C70277 mark
                    "   AND apa02 <= '",tm.edate,"' ANd apa42='N' ",                      #MOD-C70277 add
                   #"   AND (apa34-apa35 > 0  OR",   #TQC-610098
                   #"   AND ((apa34 > apa35+apa20*apa14 )  OR",   #TQC-610098   #No.FUN-680027  mark
                   #"   AND ((apc09 > apc11+apc16*apa14 )  OR",   #No.FUN-680027    #MOD-720128
                    "   AND ((apc09 > apc11+apc15)  OR",     #MOD-720128  #TQC-B70203 add apc15
                    "        apa01 IN (SELECT aph04 FROM apf_file,aph_file",   #MOD-650073
                    "              WHERE apf01=aph01 AND apf41 <> 'X' ",   #MOD-650073
                   #"        apa01 IN (SELECT apg04 FROM apf_file,apg_file",   #MOD-650073
                   #"              WHERE apf01=apg01 AND apf41 <> 'X' ",   #MOD-650073
                    "                AND apf02 > '",tm.edate,"'))"
        #-----No.FUN-570011 END-----
     ELSE
        LET l_sql="SELECT apa21, gen02, apa22,",
                  "       apa06, apa07,apa02, apa01,",
                 #"       apa73,0,0,0,0,0,apa00",     #No.FUN-570011   #TQC-610098
                 #"       apa73-apa20*apa72,0,0,0,0,0,apa00",    #TQC-610098 #No.FUN-680027 mark
                 #"       apc13-apc16*apa72,0,0,0,0,0,apa00,apc02",    #No.FUN-680027    #MOD-720128
                  "       apc13,0,0,0,0,0,apa00,apc02,apc04",    #No.FUN-680027    #MOD-720128  #No.FUN-B40099 add apc04
                 #" FROM apa_file,OUTER gen_file",          #No.FUN-680027 mark
                  " FROM apc_file,apa_file LEFT OUTER JOIN gen_file ON(apa_file.apa21=gen_file.gen01)", #No.FUN-680027 add
                  " WHERE ",tm.wc CLIPPED,   #MOD-760068
                  "   AND apa01 = apc01 ",   #No.FUN-680027 
                 #"   AND apa08 <> 'UNAP' ",  #No.TQC-750228 #MOD-9A0060                                                            
                  "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)",  #MOD-9A0060  
                 #"   AND apa00 LIKE '1%' AND apa41='Y' AND apa55='1'",
                  "   AND apa00 MATCHES '1*' AND apa41='Y' ",    #No.MOD-8B0245
                 # "   AND apa00 LIKE '1*' AND apa41='Y' AND apa55='1'",
                 #"   AND apa02 <= '",tm.edate,"' ANd apa42='N' AND apa74='N'",         #MOD-C70277 mark
                  "   AND apa02 <= '",tm.edate,"' ANd apa42='N' ",                      #MOD-C70277 add
                 #"   AND (apa73 > 0  OR",   #TQC-610098
                 #"   AND (apa73 > apa20*apa72  OR",   #TQC-610098   #No.FUN-680027 mark
                 #"   AND (apc13 > apc16*apa72  OR",   #No.FUN-680027    #MOD-720128
                  "   AND (apc13 > 0  OR",      #MOD-720128
                  "        apa01 IN (SELECT apg04 FROM apf_file,apg_file",
                  "              WHERE apf01=apg01 AND apf41 <> 'X' ",
                  "                AND apf02 > '",tm.edate,"'))"
        #-----No.FUN-570011-----
        LET l_sql = l_sql CLIPPED," UNION ",
                    "SELECT apa21, gen02, apa22,",
                    "       apa06, apa07,apa02, apa01,",
                    #"       apa73,0,0,0,0,0,apa00",   #TQC-610098
                   #"       apa73-apa20*apa72,0,0,0,0,0,apa00",   #TQC-610098   #No.FUN-680027 mark
                   #"       apc13-apc16*apa72,0,0,0,0,0,apa00,apc02",   #No.FUN-680027    #MOD-720128
                    "       apc13,0,0,0,0,0,apa00,apc02,apc04",    #MOD-720128    #No.FUN-B40099 add apc04
                   #" FROM apa_file,OUTER gen_file",          #No.FUN-680027 mark
                    " FROM apc_file,apa_file LEFT OUTER JOIN gen_file ON(apa_file.apa21=gen_file.gen01)", #NO.FUN-680027
                    " WHERE ",tm.wc CLIPPED,   #MOD-760068
                    "   AND apa01 = apc01 ",  #No.FUN-680027
                   #"   AND (apa00 = '21' OR apa00 = '22') AND apa41='Y' AND apa55='1'",
                    "   AND (apa00 = '21' OR apa00 = '22') AND apa41='Y' ",    #No.MOD-8B0245
                   #"   AND apa08 <> 'UNAP' ",  #No.TQC-750228 #MOD-9A0060                                                          
                    "   AND (apa08 <> 'UNAP' OR apa08 IS NULL)",  #MOD-9A0060   
                   #"   AND apa02 <= '",tm.edate,"' ANd apa42='N' AND apa74='N'",              #MOD-C70277 mark
                    "   AND apa02 <= '",tm.edate,"' ANd apa42='N' ",                           #MOD-C70277 add
                   #"   AND (apa73 > 0  OR",   #TQC-610098
                   #"   AND (apa73 > apa20*apa72  OR",   #TQC-610098  #NO.FUN-680027 mark
                   #"   AND (apc13 > apc16*apa72  OR",   #No.FUN-680027   #MOD-720128
                    "   AND (apc13 > 0 OR",    #MOD-720128
                    "        apa01 IN (SELECT aph04 FROM apf_file,aph_file",   #MOD-650073
                    "              WHERE apf01=aph01 AND apf41 <> 'X' ",   #MOD-650073
                   #"        apa01 IN (SELECT apg04 FROM apf_file,apg_file",   #MOD-650073
                   #"              WHERE apf01=apg01 AND apf41 <> 'X' ",   #MOD-650073
                    "                AND apf02 > '",tm.edate,"'))"
        #-----No.FUN-570011 END-----
     END IF
     #No.MOD-5C0070  --End
 
     PREPARE r190_prepare1 FROM l_sql
     IF STATUS THEN
        CALL cl_err('prepare:',STATUS,1)
        CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
        EXIT PROGRAM
     END IF
     DECLARE r190_curs1 CURSOR FOR r190_prepare1
     LET g_rlang=g_lang
#No.FUN-580010  -begin
     LET g_zaa[33].zaa08 = '0-',tm.a1 USING '###'
     LET g_zaa[34].zaa08 = tm.a1+1 USING '###','-',tm.a2 USING '###'
     LET g_zaa[35].zaa08 = tm.a2+1 USING '###','-',tm.a3 USING '###'
     LET g_zaa[36].zaa08 = tm.a3+1 USING '###','-',tm.a4 USING '###'
     LET g_zaa[37].zaa08 = tm.a4+1 USING '###',g_x[12] CLIPPED
#No.FUN-580010  -end
 
     LET g_pageno = 0
     FOREACH r190_curs1 INTO sr.*,l_apa00,l_apc02,l_apc04   #No.FUN-570011 #No.FUN-680027 add apc    #No.FUN-B40099 add apc04
        IF STATUS THEN
           CALL cl_err('Foreach:',STATUS,1)
           CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
           EXIT PROGRAM
        END IF
        LET amt1=0 LET amt2=0
        SELECT SUM(apg05) INTO amt1
             FROM apf_file, apg_file
            WHERE apg04=sr.apa01 AND apg01=apf01 AND apf41='Y'
                 AND apg06 = l_apc02   #NO.FUN-680027 add
                 AND apf02 > tm.edate

        IF amt1 IS NULL THEN LET amt1=0 END IF
       #MOD-990220   ---start                                                                                                       
        SELECT SUM(aph05) INTO amt2                                                                                                 
          FROM apf_file, aph_file                                                                                                  
         WHERE aph04=sr.apa01 AND aph01=apf01 AND apf41='Y'                                                                         
           AND aph17 = l_apc02   #NO.FUN-680027 add                                                                                 
           AND apf02 > tm.edate                                                                                                     
        IF amt2 IS NULL THEN LET amt2=0 END IF   
       #LET amt1=sr.num1+amt1 LET sr.num1=0
        LET amt1=sr.num1+amt1+amt2 LET sr.num1=0                                                                                    
       #MOD-990220   ---end 
        #-----No.FUN-570011-----
       #IF l_apa00 = "21" OR l_apa00 = "22" THEN  #MOD-B40121 mark
        IF l_apa00 MATCHES "2*" THEN              #MOD-B40121
           LET amt1 = amt1 * -1
        END IF
        #-----No.FUN-570011 END-----
 
#        LET l_bucket=YEAR(tm.edate)*12+MONTH(tm.edate)-
        LET l_bucket=YEAR(l_apc04)*12+MONTH(l_apc04)-         #No.FUN-B40099
                    (YEAR(sr.apa02)*12+MONTH(sr.apa02))+1
        CASE WHEN l_bucket<=tm.a1/30 LET sr.num1=amt1
             WHEN l_bucket<=tm.a2/30 LET sr.num2=amt1
             WHEN l_bucket<=tm.a3/30 LET sr.num3=amt1
             WHEN l_bucket<=tm.a4/30 LET sr.num4=amt1
             OTHERWISE               LET sr.num5=amt1
        END CASE
     
        #MOD-720043 -START
        ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
        EXECUTE insert_prep USING 
                 sr.apa21, sr.gen02, sr.apa22, sr.apa06, sr.apa07,
                 sr.apa02, sr.apa01, sr.num1 , sr.num2 , sr.num3 ,
                 sr.num4 , sr.num5 , g_azi04 , g_azi05
        #------------------------------ CR (3) ------------------------------#
        #MOD-720043 -END
     END FOREACH
 
     #MOD-720043 -START
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'apa22,apa21,apa06') 
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.a1,";",tm.a2,";",tm.a3,";",tm.a4
                      ,";",tm.edate,";",tm.detail
     CALL cl_prt_cs3('aapr190','aapr190',l_sql,g_str)   #FUN-710080 modify
     #------------------------------ CR (4) ------------------------------#
     #MOD-720043 -END
 
   #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055   #FUN-B80105  MARK
END FUNCTION
