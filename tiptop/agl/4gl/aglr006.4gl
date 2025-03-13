# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr006.4gl
# Descriptions...: 現金流量表列印
# Date & Author..: 01/10/16 By Debbie Hsu
# Modify.........: No.MOD-4C0156 2004/12/24 by Kitty 帳別問題修改,畫面調整
# Modify.........: No.TQC-650058 06/05/11 By Joe 修改憑證類的報表因報表寬度(p_zz)為0或NULL,導致報表當掉的錯誤 
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-670005 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-740015 07/04/04 By Judy 語言功能失效
# Modify.........: No.FUN-740020 07/04/13 By mike  會計科目加帳套
# Modify.........: No.TQC-740093 07/04/17 By mike  會計科目加帳套 
# Modify.........: No.FUN-780068 07/09/20 By Sarah 1.本期淨利(損)科目改抓aaz86
#                                                  2.抓axh_file的key值增加版本axh13
# Modify.........: No.FUN-780058 08/03/12 By sherry 報表改由CR輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990209 09/10/18 By mike 1.原先抓取aaz86的地方改抓aaz114                                                   
#                                                 2.所有用到g_ver的地方都mark                                                       
#                                                 3.抓取本期凈利(損)-aaz86的SQL,原本只抓取SUM(axh09)貸方異動額,請改成SUM(axh08-axh09
# Modify.........: No:FUN-950111 09/10/29 by yiting 選擇aag02時還要判斷axa09 
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现                                                    
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-A30122 10/08/24 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No:FUN-A90032 11/01/24 By wangxin 屬於合併報表者，取消起始期別'輸入, 也就是若該合併主體採季報實施,則該報表無法以單月呈現
# Modify.........: NO:CHI-B10030 11/01/26 BY Summer 抓取aznn_file的SQL要改為跨DB的寫法,跨到這次合併的上層公司所在DB去抓取
# Modify.........: No:CHI-AC0033 11/02/09 By Summer FUN-780058改寫為CR時寫法與aglr940差太多,導致兩支報表印出來的格式差太多!
#                                                   參考aglr940.4gl的寫法調整
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN
# Modify.........: No:MOD-B40082 11/04/14 By Sarah 1.本期淨利應考慮借貸餘來顯示金額正負號 2.本期異動金額計算有誤
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為aaw_file 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           title   LIKE type_file.chr20,        #輸入報表名稱   #No.FUN-680098    VARCHAR(20)  
           axa01   LIKE axa_file.axa01,
           axa02   LIKE axa_file.axa02,
           axa03   LIKE axa_file.axa03,
           y1      LIKE type_file.num5,         #輸入起始年度    #No.FUN-680098    smallint
           axa06   LIKE axa_file.axa06,         #FUN-A90032
           m1      LIKE type_file.num5,         #Begin 期別      #No.FUN-680098    smallint
           q1      LIKE type_file.chr1,         #FUN-A90032
           h1      LIKE type_file.chr1,         #FUN-A90032
           y2      LIKE type_file.num5,         #輸入截止年度    #No.FUN-680098    smallint
           m2      LIKE type_file.num5,         #End   期別      #No.FUN-680098    smallint
           b       LIKE aaa_file.aaa01,         #帳別編號        #No.FUN-670039
           c       LIKE type_file.chr1,         #異動額及餘額為0者是否列印 #No.FUN-680098  VARCHAR(1)     
           e       LIKE type_file.num5,         #小數位數        #No.FUN-680098     smallint
           d       LIKE type_file.chr1,         #金額單位        #No.FUN-680098     VARCHAR(1) 
           o       LIKE type_file.chr1,         #轉換幣別否      #No.FUN-680098     VARCHAR(1) 
           r       LIKE azi_file.azi01,         #總帳幣別
           p       LIKE azi_file.azi01,         #轉換幣別
           q       LIKE azj_file.azj03,         #匯率
           amt     LIKE type_file.num20_6,      #現金流量期初餘額 #No.FUN-680098    decimal(20,6)
           s       LIKE type_file.chr1,         #是否有揭露事項   #No.FUN-680098      VARCHAR(1) 
           t       LIKE type_file.chr1          #列印明細         #CHI-AC0033 add
           END RECORD,
       bdate,edate LIKE type_file.dat,          #No.FUN-680098    date
       i,j,k       LIKE type_file.num5,         #No.FUN-680098   smallint
       g_unit      LIKE type_file.num10,        #金額單位基數 #No.FUN-680098    integer
       g_bookno    LIKE axh_file.axh00,         #帳別 
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_gim       DYNAMIC ARRAY OF RECORD
            gim01   LIKE gim_file.gim01,   #CHI-990066 add
            gim02   LIKE gim_file.gim02,
            gim03   LIKE gim_file.gim03
                   END RECORD,
       g_tot1      ARRAY[100] OF LIKE type_file.num20_6,    #No.FUN-680098     decimal(20,6)
       g_tot1_1    ARRAY[100] OF LIKE type_file.num20_6     #No.FUN-680098     decimal(20,6)
DEFINE g_aaa03     LIKE aaa_file.aaa03
DEFINE g_cnt       LIKE type_file.num10      #No.FUN-680098 integer
DEFINE g_i         LIKE type_file.num5       #count/index for any purpose        #No.FUN-680098 smallint
DEFINE g_str       STRING
DEFINE g_sql       STRING
DEFINE l_table     STRING
#DEFINE l_table1    STRING                   #CHI-AC0033 mark
DEFINE g_msg       LIKE type_file.chr1000    #No.FUN-680098  VARCHAR(72)
#DEFINE g_ver       LIKE axh_file.axh13,      #No.FUN-780068 add 09/20 #MOD-990209 
DEFINE  g_value1    LIKE axh_file.axh08       #No.FUN-780068 add 09/20 #MOD-990209 add DEFINE
DEFINE g_dbs_axz03 LIKE type_file.chr21      #No.FUN-950111 add                                                                     
DEFINE g_plant_axz03 LIKE type_file.chr21    #FUN-A30122 add
#DEFINE g_aaz641    LIKE type_file.chr21      #No.FUN-950111 add   #FUN-B50001 
DEFINE g_aaw01     LIKE type_file.chr21      #FUN-B50001
DEFINE g_axa05     LIKE axa_file.axa05       #FUN-A90032  
DEFINE g_aaw       RECORD LIKE aaw_file.*    #FUN-B50001 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   SELECT * INTO g_aaw.* FROM aaw_file WHERE aaw00 = '0'   #FUN-B50001

   LET g_bookno = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)        # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   #-----TQC-610056---------
   LET tm.title = ARG_VAL(8)
   LET tm.y1 = ARG_VAL(9)
#  LET tm.m1 = ARG_VAL(10)    #FUN-A90032
   LET tm.axa06= ARG_VAL(10)  #FUN-A90032
   LET tm.m2 = ARG_VAL(11)
   LET tm.axa01 = ARG_VAL(12)
   LET tm.axa02 = ARG_VAL(13)
   LET tm.axa03 = ARG_VAL(14)
   LET tm.b = ARG_VAL(15)
   LET tm.e = ARG_VAL(16)
   LET tm.d = ARG_VAL(17)
   LET tm.c = ARG_VAL(18)
   LET tm.s = ARG_VAL(19)
   LET tm.t = ARG_VAL(20)     #CHI-AC0033 add
  #CHI-AC0033 mod +1 --start--
   LET tm.o = ARG_VAL(21)
   LET tm.r = ARG_VAL(22)
   LET tm.p = ARG_VAL(23)
   LET tm.q = ARG_VAL(24)
   LET g_rep_user = ARG_VAL(25)
   LET g_rep_clas = ARG_VAL(26)
   LET g_template = ARG_VAL(27)
   #-----END TQC-610056-----
   LET tm.q1= ARG_VAL(28) #FUN-A90032
   LET tm.h1= ARG_VAL(29) #FUN-A90032
  #CHI-AC0033 mod +1 --end--

  #str CHI-AC0033 mark
  ##No.FUN-780058---Begin
  #LET g_sql = "title.type_file.chr20,",  
  #            "l_amt.type_file.num20_6,",
  #            "l_amt_s.type_file.num20_6,",
  #            "l_sub_amt.type_file.num20_6,",
  #            "l_str1.type_file.chr1000,",
  #            "l_str2.type_file.chr1000,",
  #            "l_str3.type_file.chr1000,",
  #            "l_str4.type_file.chr1000,",
  #            "l_str5.type_file.chr1000,",
  #            "l_str6.type_file.chr1000,",
  #            "l_str7.type_file.chr1000,",
  #            "l_str8.type_file.chr1000,",
  #            "l_str9.type_file.chr1000,",
  #            "l_str10.type_file.chr1000,",
  #            "l_gir02_1.gir_file.gir02,",
  #            "l_gir02_2.gir_file.gir02,",
  #            "l_gir02_3.gir_file.gir02,",
  #            "l_gir02_4.gir_file.gir02,",
  #            "l_gir02_5.gir_file.gir02,",
  #            "l_diff.type_file.num20_6,",
  #            "l_last.type_file.num20_6,",
  #            "l_this.type_file.num20_6"
  #LET l_table = cl_prt_temptable('aglr006',g_sql) CLIPPED      
  #IF l_table = -1 THEN EXIT PROGRAM END IF                  
 
  #LET g_sql = "title.type_file.chr20,",
  #            "gim02.gim_file.gim02,",
  #            "gim03.gim_file.gim03"
  #LET l_table1 = cl_prt_temptable('aglr0061',g_sql) CLIPPED     
  #IF l_table1 = -1 THEN EXIT PROGRAM END IF                  
  ##No.FUN-780058---End
  #end CHI-AC0033 mark
 
  #str CHI-AC0033 add
   LET g_sql = "type.type_file.chr1,",
               "str1.type_file.chr50,",
               "gir02.type_file.chr1000,",  #FUN-940035
               "str2.type_file.chr50,",
               "gir05.gir_file.gir05"       #CHI-990066 add
   LET l_table = cl_prt_temptable('aglr006',g_sql) CLIPPED      
   IF l_table = -1 THEN EXIT PROGRAM END IF                  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
  #end CHI-AC0033 add
 
# genero  script marked    LET g_gim_arrno = 200
   LET tm.b = tm.axa03   #FUN-780068 10/16
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.b)  THEN LET tm.b = g_aza.aza81 END IF #No.FUN-740020
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r006_tm()         # Input print condition
   ELSE
      CALL r006()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r006_tm()
   DEFINE p_row,p_col,p  LIKE type_file.num5,    #No.FUN-680098      smallint
          l_sw      LIKE type_file.chr1,     #重要欄位是否空白   #No.FUN-680098   VARCHAR(1)     
          l_cnt     LIKE type_file.num5,          #No.FUN-680098 smllint
          l_cmd     LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
   DEFINE li_chk_bookno   LIKE type_file.num5     #No.FUN-670005    #No.FUN-680098      smallint
   DEFINE l_aaa05   LIKE aaa_file.aaa05          #FUN-A90032
   DEFINE l_aznn01  LIKE aznn_file.aznn01        #FUN-A90032
   DEFINE l_axz03   LIKE axz_file.axz03          #CHI-B10030 add

   CALL s_dsmark(g_bookno)
 
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW r006_w AT p_row,p_col WITH FORM "agl/42f/aglr006"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL  s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   #No.TQC-740093 --BEGIN--
   IF tm.b IS NULL THEN 
      LET tm.b=g_aza.aza81   
   END IF
   #No.TQC-740093  --END--
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 =tm.b  #No.FUN-740020 
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel aaa:',SQLCA.sqlcode,0)  # NO.FUN-660123
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)  # NO.FUN-660123  #No.FUN-740020
   END IF 
   #使用預設帳別之幣別之小數位數
   SELECT azi05 INTO tm.e FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN
#     CALL cl_err('sel azi:',SQLCA.sqlcode,0) # NO.FUN-660123
      CALL cl_err3("sel","azi_file",g_aaa03,"",SQLCA.sqlcode,"","sel azi:",0)  # NO.FUN-660123
   END IF
   #LET tm.b = g_bookno
   LET tm.b=g_aza.aza81   #No.FUN-740020
   LET tm.c = 'Y'
   LET tm.d = '1'
   LET tm.o = 'N'
   LET tm.r = g_aaa03
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.amt  = 0
   LET tm.s    = 'N'
   LET tm.t = 'N'      #CHI-AC0033 add
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
WHILE TRUE
    LET l_sw = 1
#FUN-A90032 --Begin
#    INPUT BY NAME tm.title,tm.y1,tm.m1,tm.m2,tm.axa01,tm.axa02,tm.axa03,tm.b,   #No:MOD-4C0156 #FUN-A90032 mark
#                  tm.e,tm.d,tm.c,tm.s,tm.o,
     INPUT BY NAME tm.axa01,tm.axa02,tm.axa03,tm.b,tm.title,tm.y1,
                   tm.m2,tm.q1,tm.h1,tm.e,tm.d,tm.c,tm.s,tm.t,tm.o,  #CHI-AC0033 add tm.t
#FUN-A90032 --End
                   tm.r,tm.p,tm.q
                   WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
#FUN-A90032 --Beign
             CALL r006_set_entry()
             CALL r006_set_no_entry()
#FUN-A90032 --End         
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_dynamic_locale()  #TQC-740015
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
      BEFORE FIELD title
         LET tm.title = g_x[1] clipped
 
      AFTER FIELD title
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.title IS NULL THEN NEXT FIELD title END IF
 
      AFTER FIELD axa01
         IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
         SELECT COUNT(*) INTO l_cnt FROM axa_file
                        WHERE axa01=tm.axa01
         IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
         IF l_cnt <=0  THEN
            CALL cl_err(tm.axa01,'agl-223',0) NEXT FIELD axa01
            NEXT FIELD axa01
         END IF
#FUN-A90032 --Begin
         LET tm.axa06 = '2'
         SELECT axa05,axa06 
           INTO g_axa05,tm.axa06
          FROM axa_file
         WHERE axa01 = tm.axa01
           AND axa04 = 'Y'
         DISPLAY BY NAME tm.axa06
         CALL r006_set_entry()
         CALL r006_set_no_entry()
         IF tm.axa06 = '1' THEN
             LET tm.q1 = '' 
             LET tm.h1 = '' 
             LET l_aaa05 = 0
             SELECT aaa05 INTO l_aaa05 FROM aaa_file 
              WHERE aaa01=tm.b 
#               AND aaaacti MATCHES '[Yy]'   #No.TQC-B30100 Mark
                AND aaaacti IN ('Y','y')       #No.TQC-B30100 add
             LET tm.m2 = l_aaa05
         END IF
         IF tm.axa06 = '2' THEN
             LET tm.h1 = '' 
             LET tm.m2 = '' 
         END IF
         IF tm.axa06 = '3' THEN
             LET tm.m2 = '' 
             LET tm.q1 = ''
         END IF
         IF tm.axa06 = '4' THEN
             LET tm.m2 = '' 
             LET tm.q1 = ''
             let tm.h1 = ''
         END IF
         DISPLAY BY NAME tm.m2
         DISPLAY BY NAME tm.q1
         DISPLAY BY NAME tm.h1

      AFTER FIELD q1
         IF cl_null(tm.q1) AND  tm.axa06 = '2' THEN
            NEXT FIELD q1
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF

      AFTER FIELD h1
         IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.axa06='4' THEN
            NEXT FIELD h1
         END IF
#FUN-A90032 --End         
 
      AFTER FIELD axa02
         IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
         SELECT COUNT(*) INTO l_cnt FROM axa_file
                        WHERE axa01=tm.axa01 AND axa02=tm.axa02
         IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
         IF l_cnt <=0  THEN
            CALL cl_err(tm.axa02,'agl-223',0) NEXT FIELD axa02
            NEXT FIELD axa02
         END IF
 
      AFTER FIELD axa03
         IF cl_null(tm.axa03) THEN NEXT FIELD axa03 END IF
         SELECT COUNT(*) INTO l_cnt FROM axa_file
          WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
         IF SQLCA.sqlcode THEN LET l_cnt = 0 END IF
         IF l_cnt <=0  THEN
            CALL cl_err(tm.axa03,'agl-223',0) NEXT FIELD axa03
            NEXT FIELD axa03
         END IF
         LET tm.b = tm.axa03   #FUN-780068 10/16
 
      AFTER FIELD y1
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.y1 IS NULL OR tm.y1 = 0 THEN
            NEXT FIELD y1
         END IF
         IF tm.y1 > YEAR(g_pdate) THEN
            CALL cl_err('','agl-920',0)
            NEXT FIELD y1
         END IF
         LET tm.y2=tm.y1
 
#FUN-A90032 --Begin 
#      AFTER FIELD m1
## genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
#         IF tm.m1 IS NULL THEN NEXT FIELD m1 END IF
#         IF tm.m1 <1 OR tm.m1 > 13 THEN
#            CALL cl_err('','agl-013',0)
#            NEXT FIELD m1
#         END IF
#         IF tm.y1 = YEAR(g_pdate) AND tm.m1 > MONTH(g_pdate) THEN
#            CALL cl_err('','agl-920',0)
#            NEXT FIELD m1
#         END IF
#FUN-A90032 --End         
 
      AFTER FIELD m2
         IF tm.m2 IS NULL THEN NEXT FIELD m2 END IF
         IF tm.m2 <1 OR tm.m2 > 13 THEN
            CALL cl_err('','agl-013',0) NEXT FIELD m2
         END IF
         IF tm.y2 = YEAR(g_pdate) AND tm.m2 > MONTH(g_pdate) THEN
            CALL cl_err('','agl-920',0)
            NEXT FIELD m2
         END IF
#FUN-A90032 --Begin         
#         IF tm.y1 = tm.y2 AND tm.m1 > tm.m2 THEN
#            CALL cl_err('','9011',0) NEXT FIELD m1
#         END IF
#FUN-A90032 --End         
 
      AFTER FIELD b
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.b IS NULL THEN 
            NEXT FIELD b END IF
         #No.FUN-670005--begin
            CALL s_check_bookno(tm.b,g_user,g_plant)
                 RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
              NEXT FIELD b
            END IF
         #No.FUN-670005--end
 
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN
#           CALL cl_err('sel aaa:',STATUS,0)  # NO.FUN-660123
            CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
            NEXT FIELD b 
         END IF
 
      AFTER FIELD c
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
      AFTER FIELD e
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.e < 0 THEN
            LET tm.e = 0
            DISPLAY BY NAME tm.e
         END IF
 
      AFTER FIELD d
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
            NEXT FIELD d
         END IF
 
      AFTER FIELD o
# genero  script marked          IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
         IF tm.o = 'N' THEN
            LET tm.p = g_aaa03
            LET tm.q = 1
            DISPLAY g_aaa03 TO p
            DISPLAY BY NAME tm.q
           #NEXT FIELD s
         END IF
 
      AFTER FIELD p
# genero  script marked         #IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         SELECT azi01 FROM azi_file WHERE azi01 = tm.p
         IF SQLCA.sqlcode THEN
#           CALL cl_err(tm.p,'agl-109',0)  # NO.FUN-660123
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)  # NO.FUN-660123
            NEXT FIELD p 
         END IF
 
      AFTER FIELD q
# genero  script marked         #IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.q <= 0 THEN
            NEXT FIELD q
         END IF
 
      AFTER FIELD s
# genero  script marked         #IF cl_ku() THEN NEXT FIELD PREVIOUS END IF
         IF tm.s IS NULL OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD s END IF
        #IF tm.s = 'Y' THEN
        #   LET g_msg='agli920'
        #   CALL cl_cmdrun(g_msg)
        #END IF
 
       #str CHI-AC0033 add
        AFTER FIELD t
           IF tm.t IS NULL OR tm.t NOT MATCHES'[YN]' THEN
              NEXT FIELD t
           END IF
       #end CHI-AC0033 add

      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
         IF tm.d = '1' THEN LET g_unit = 1 END IF
         IF tm.d = '2' THEN LET g_unit = 1000 END IF
         IF tm.d = '3' THEN LET g_unit = 1000000 END IF
         IF tm.o = 'N' THEN
            LET tm.p = g_aaa03
            LET tm.q = 1
         END IF
         #--FUN-A90026 start--
         IF NOT cl_null(tm.axa06) THEN
             CASE
                 WHEN tm.axa06 = '1'  #月 
                      LET tm.m1 = 0
                #CHI-B10030 add --start--
                 OTHERWISE      
                      CALL s_axz03_dbs(tm.axa02) RETURNING l_axz03 
                      CALL s_get_aznn01(l_axz03,tm.axa06,tm.axa03,tm.y1,tm.q1,tm.h1) RETURNING tm.m2
                #CHI-B10030 add --end--
             END CASE
         END IF
         #--FUN-A90026
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()     # Command execution
 
      ON ACTION mntn_labor_amount
         CALL cl_cmdrun("agli932")
 
      ON ACTION mntn_expose_item
         CALL cl_cmdrun("agli920")
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axa01)
#              CALL q_axa(5,2,tm.axa01) RETURNING tm.axa01,tm.axa02,tm.axa03
#              CALL FGL_DIALOG_SETBUFFER( tm.axa01 )
#              CALL FGL_DIALOG_SETBUFFER( tm.axa02 )
#              CALL FGL_DIALOG_SETBUFFER( tm.axa03 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_axa'
               LET g_qryparam.default1 = tm.axa01
               LET g_qryparam.default2 = tm.axa02
               LET g_qryparam.default3 = tm.axa03
               CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
#               CALL FGL_DIALOG_SETBUFFER( tm.axa01 )
#               CALL FGL_DIALOG_SETBUFFER( tm.axa02 )
#               CALL FGL_DIALOG_SETBUFFER( tm.axa03 )
               DISPLAY BY NAME tm.axa01
               DISPLAY BY NAME tm.axa02
               DISPLAY BY NAME tm.axa03
               NEXT FIELD axa01
 
            WHEN INFIELD(axa02)
#              CALL q_axa(5,2,tm.axa01) RETURNING tm.axa01,tm.axa02,tm.axa03
#              CALL FGL_DIALOG_SETBUFFER( tm.axa01 )
#              CALL FGL_DIALOG_SETBUFFER( tm.axa02 )
#              CALL FGL_DIALOG_SETBUFFER( tm.axa03 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_axa'
               LET g_qryparam.default1 = tm.axa01
               LET g_qryparam.default2 = tm.axa02
               LET g_qryparam.default3 = tm.axa03
               CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
#               CALL FGL_DIALOG_SETBUFFER( tm.axa01 )
#               CALL FGL_DIALOG_SETBUFFER( tm.axa02 )
#               CALL FGL_DIALOG_SETBUFFER( tm.axa03 )
               DISPLAY BY NAME tm.axa01
               DISPLAY BY NAME tm.axa02
               DISPLAY BY NAME tm.axa03
               NEXT FIELD axa02
 
            WHEN INFIELD(p)
#              CALL q_azi(6,10,tm.p) RETURNING tm.p
#              CALL FGL_DIALOG_SETBUFFER( tm.p )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_azi'
               LET g_qryparam.default1 = tm.p
               CALL cl_create_qry() RETURNING tm.p
#               CALL FGL_DIALOG_SETBUFFER( tm.p )
               DISPLAY BY NAME tm.p
               NEXT FIELD p
 
            WHEN INFIELD(b)
#              CALL q_aaa(6,6,tm.b) RETURNING tm.b
#              CALL FGL_DIALOG_SETBUFFER( tm.b )
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
#               CALL FGL_DIALOG_SETBUFFER( tm.b )
               DISPLAY BY NAME tm.b
               NEXT FIELD b
      END CASE
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r006_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL r006()
   ERROR ""
END WHILE
   CLOSE WINDOW r006_w
END FUNCTION
 
#str CHI-AC0033 mod
FUNCTION r006()   #整段改寫
   DEFINE l_sql      LIKE type_file.chr1000,       # RDSQL STATEMENT
          l_unit     LIKE zaa_file.zaa08,
          l_str1     LIKE type_file.chr50,
          l_str2     LIKE type_file.chr50,
          l_d1       LIKE type_file.num5,
          l_d2       LIKE type_file.num5,
          l_flag     LIKE type_file.chr1,
          l_str      LIKE type_file.chr21,
          l_bdate    LIKE type_file.dat,  
          l_edate    LIKE type_file.dat,  
          l_type     LIKE aag_file.aag06,          #正常餘額型態(1.借餘/2.貨餘)
          l_cnt      LIKE type_file.num5,          #揭露事項筆數
          l_last_y   LIKE type_file.num5,          #期初年份
          l_last_m   LIKE type_file.num5,          #期初月份
          l_this     LIKE type_file.num20_6,       #本期餘額
          l_last     LIKE type_file.num20_6,       #期初餘額
          l_diff     LIKE type_file.num20_6,       #差異
          l_modamt   LIKE type_file.num20_6,       #調整金額
          l_amt      LIKE type_file.num20_6,       #科目現金流量
          l_amt_s    LIKE type_file.num20_6,       #群組現金流量
          l_sub_amt  LIKE type_file.num20_6,       #各活動產生之淨現金
          l_tot_amt  LIKE type_file.num20_6,       #本期現金淨增數
          l_tmp_amt  LIKE type_file.num20_6        #折舊科目之合計
   DEFINE tmp RECORD
          aag01      LIKE aag_file.aag01,
          aag02      LIKE aag_file.aag02,
          gis02      LIKE gis_file.gis02,    #FUN-950111 add
          gis03      LIKE gis_file.gis03,
          gis04      LIKE gis_file.gis04,
          #FUN-950111--mod--str--                                                                                                 
          gis05      LIKE gis_file.gis05,                                                                                         
          gis06      LIKE gis_file.gis06,                                                                                         
          axz03      LIKE axz_file.axz03,                                                                                         
          axz04      LIKE axz_file.axz04                                                                                          
          #FUN-950111--mod--end
              END RECORD
   DEFINE gir RECORD                               #群組代號
          gir01      LIKE gir_file.gir01,
          gir02      LIKE gir_file.gir02,
          gir05      LIKE gir_file.gir05
              END RECORD
   DEFINE l_gir02    LIKE type_file.chr1000                   
   DEFINE git RECORD 
          git02      LIKE git_file.git02,
          aag02      LIKE aag_file.aag02,
          git05      LIKE git_file.git05
              END RECORD
   DEFINE l_git  DYNAMIC ARRAY OF RECORD 
          gir02      LIKE type_file.chr1000,
          git05      LIKE git_file.git05
                 END RECORD       
   DEFINE l_i_1      LIKE type_file.num5       
   DEFINE l_i_2      LIKE type_file.num5
   DEFINE l_str_1    STRING
   DEFINE l_space    STRING
   DEFINE l_len      LIKE type_file.num5 
   DEFINE l_num      LIKE type_file.num5 
   DEFINE l_gir05    LIKE gir_file.gir05      #行次
   #FUN-950111--mod--str--
   DEFINE l_axz03    LIKE axz_file.axz03
   DEFINE l_axz04    LIKE axz_file.axz04
   DEFINE l_axa09    LIKE axa_file.axa09
   #FUN-950111--mod--end
   DEFINE l_aag06    LIKE aag_file.aag06      #MOD-B40082 add

   CALL cl_del_data(l_table) 

   LET tm.m1 = tm.m2   #CHI-AC0033 add 
   #制表日期,期間,頁次                                                       
   #CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate  #CHI-A70007 mark                
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y1,tm.m1,g_plant,tm.axa03) RETURNING l_flag,l_bdate,l_edate
   ELSE
     CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate                  
   END IF
   #CHI-A70007 add --end--
   LET l_d1 = DAY(l_bdate)                                                   
   #CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark                  
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.y2,tm.m2,g_plant,tm.axa03) RETURNING l_flag,l_bdate,l_edate
   ELSE
     CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate                  
   END IF
   #CHI-A70007 add --end--
   LET l_d2 = DAY(l_edate)                                                   
   #1期的前一期是0期,0期的前一期是前一年的12期                                
   IF tm.m1=0 THEN   #FUN-780068 mod 09/20 1->0                              
      LET l_last_y = tm.y1 - 1                                               
      LET l_last_m = 12                                                      
   ELSE                                                                      
      LET l_last_y = tm.y1                                                   
      LET l_last_m = tm.m1 - 1                                               
   END IF                                                                    
  #LET g_ver = l_last_m              #上期版本   #FUN-780068 add 09/20 #MOD-990209

   LET l_amt = 0                                                             
   LET l_amt_s = 0                                                           
   LET l_this = 0                                                            
   LET l_last = 0                                                            
   LET l_sub_amt = 0                                                         
   LET l_tot_amt = 0                                                         
   LET l_tmp_amt = 0
   LET l_gir05 = 0

   #營業活動之現金流量
   LET l_type = '1'
   LET l_flag = 'N'
   #---------------------本期淨利(損)------------------------------
   SELECT SUM(axh08-axh09) INTO l_amt FROM axh_file       #MOD-990209 axh09-->axh08-axh09                         
    WHERE axh00=tm.b                           #帳別                         
      #AND axh05=g_aaz.aaz114                   #科目      #MOD-990209 aaz86-->aaz114   #FUN-B50001                
      AND axh05=g_aaw.aaw06                   #科目 
      AND axh06=tm.y1                          #年度                         
     #AND axh07 BETWEEN tm.m1 AND tm.m2        #期別      #FUN-A90032 mark                   
      AND axh07 = tm.m2                        #期別      #FUN-A90032
      AND axh01=tm.axa01                       #族群                         
      AND axh02=tm.axa02                       #上層公司                     
      AND axh03=tm.axa03                       #上層帳別                     
      AND axh13='00'   #FUN-780068 add 09/20   #版本                         
  #end FUN-780068 mod 09/20                                                  
   IF cl_null(l_amt) THEN LET l_amt = 0 END IF                               
  #str MOD-B40082 add
   #aag06正常餘額型態(1.借餘 2.貸餘)
   LET l_aag06=''
   SELECT aag06 INTO l_aag06 FROM aag_file 
    #WHERE aag01=g_aaz.aaz114 AND aag00=tm.b   #FUN-B50001
    WHERE aag01=g_aaw.aaw06 AND aag00=tm.b
   IF l_aag06='2' THEN LET l_amt=l_amt*-1 END If
  #end MOD-B40082 add
  #LET l_amt=l_amt*-1  #FUN-780068 mark 09/20                                
  #將本期淨利(損)金額加至 營業活動產生之淨現金l_sub_amt
  #LET l_tot_amt = l_tot_amt + l_amt        #計算本期現金淨增數
   LET l_sub_amt = l_sub_amt + l_amt
   LET l_amt = l_amt*tm.q/g_unit            #依匯率及單位換算   
   IF l_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_amt,20,tm.e)
   ELSE
      CALL r006_str(l_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF

   #調整項目
   #-------------------------營業科目-------------------------------
   LET l_amt = 0
   LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",   #CHI-990066 add gir05
             " WHERE gir03 = '1' AND gir04 = 'Y'"
   PREPARE r006_gir_p1 FROM l_sql
   DECLARE r006_gir_cs1 CURSOR FOR r006_gir_p1
   #FUN-950111--mod--str--                                                                           
   #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
   #          "  FROM aag_file,gis_file,gir_file",                            
   #          " WHERE aag01=gis02 AND gis01=gir01 AND aag00='",tm.b,"' ",  #No
   #          " AND gir04='Y' AND gis01 = ? " 
   LET l_sql = "SELECT '','',gis02,gis03,gis04,gis05,gis06,axz03,axz04 ",
               "  FROM gis_file,gir_file,axz_file",
               " WHERE gis01 = gir01 AND axz01 = gis06 AND gir04='Y' AND gis01 = ?" 
   PREPARE r006_p31 FROM l_sql                                                
   DECLARE r006_cu31 CURSOR FOR r006_p31                                 
   FOREACH r006_gir_cs1 INTO gir.*                                           
     LET l_amt_s = 0                                                         
     LET l_i_1 = 1  #FUN-940035 add
     FOREACH r006_cu31 USING gir.gir01 INTO tmp.*
         CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_dbs_axz03
         #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641  #FUN-B50001
         CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
         LET l_sql = "SELECT aag01,aag02 FROM ",g_dbs_axz03 CLIPPED,"aag_file ",
                     #" WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"   #FUN-B50001
                     " WHERE aag00 = '",g_aaw01,"' AND aag01 = '",tmp.gis02,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-A60013 add
         PREPARE aag_sel1 FROM l_sql
         EXECUTE aag_sel1 INTO tmp.aag01,tmp.aag02
   #FUN-950111--mod--end

         CASE tmp.gis04
           WHEN '1'
             CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)
                  RETURNING l_amt
           WHEN '2'
             CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
           WHEN '3'
             CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
           WHEN '4'
             SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
              WHERE git01 = gir.gir01 AND git02 = tmp.aag01
                AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
                AND git01 = gir01 AND gir04 = 'Y'
             #FUN-940035 add
             LET l_str_1 = tmp.aag01
             LET l_len = LENGTH(l_str_1)
             LET l_num = 26 - l_len
             LET l_space = l_num spaces
             LET l_git[l_i_1].gir02 = tmp.aag01||l_space||tmp.aag02
             LET l_git[l_i_1].git05=l_amt
             LET l_i_1 = l_i_1 + 1
             #FUN-940035 add
           WHEN '5'  #借方異動
            #str FUN-780068 mod 09/20                                         
             CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
                  RETURNING l_amt       
           WHEN '6'  #貸方異動                                                
             CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
                  RETURNING l_amt
         END CASE
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
        #-MOD-AC0013-add-
         IF tmp.gis04 <> '4' THEN
            SELECT SUM(git05) INTO l_modamt 
              FROM git_file,gir_file
             WHERE git01 = gir.gir01 AND git02 = tmp.aag01
               AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
               AND git01 = gir01 AND gir04 = 'Y'
            IF cl_null(l_modamt) THEN LET l_modamt = 0 END IF
            LET l_amt = l_amt + l_modamt
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_git[l_i_1].gir02 = tmp.aag01||l_space||tmp.aag02
            LET l_git[l_i_1].git05=l_amt
            LET l_i_1 = l_i_1 + 1
         END IF
        #-MOD-AC0013-end-
         #若為減項
         IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
         LET l_amt_s = l_amt_s + l_amt
      END FOREACH
      LET l_i_1 = l_i_1 - 1   #FUN-940035 add

      IF l_amt_s = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      LET l_sub_amt = l_sub_amt + l_amt_s   #計算營業活動產生之淨現金
      LET l_amt_s = l_amt_s*tm.q/g_unit     #依匯率及單位換算
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r006_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,')'
      END IF
      LET l_flag = 'Y'
      #FUN-940035---Begin
      IF tm.t = 'N' THEN 
         EXECUTE insert_prep USING l_type,l_str1,gir.gir02,l_str2,gir.gir05   #CHI-990066 add gir05
      ELSE 
      	 FOR l_i_2 = 1 TO l_i_1
            IF l_git[l_i_2].git05 >= 0 THEN
               LET l_str2 = cl_numfor(l_git[l_i_2].git05,20,tm.e)
               EXECUTE insert_prep USING l_type,l_str1,l_git[l_i_2].gir02,l_str2,gir.gir05   #CHI-990066 add gir05
            ELSE
               CALL r006_str(l_git[l_i_2].git05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
               EXECUTE insert_prep USING l_type,l_str1,'','',gir.gir05   #CHI-990066 add gir05
            END IF
      	 END FOR     
      END IF
     #FUN-940035---End	   
   END FOREACH
   IF l_flag = 'N' THEN
      EXECUTE insert_prep USING l_type,l_str1,'','',l_gir05   #CHI-990066 add l_gir05
   END IF

   #營業活動產生之淨現金
   LET l_type = '2' 
   LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
   LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
   IF l_sub_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL r006_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   EXECUTE insert_prep USING l_type,l_str1,'','',l_gir05   #CHI-990066 add l_gir05
   LET l_sub_amt = 0
   LET l_amt_s = 0

   #----------------------投資活動之現金流量-----------------------
   LET l_type = '3'
   LET l_flag = 'N'
   LET l_amt = 0

   LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",   #CHI-990066 add gir05
             " WHERE gir03 = '2' AND gir04 = 'Y'"
   PREPARE r006_gir_p2 FROM l_sql
   DECLARE r006_gir_cs2 CURSOR FOR r006_gir_p2

   #FUN-950111--mod--str--                                                                          
   #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
   #        " FROM aag_file,gis_file,gir_file",                               
   #        " WHERE aag01=gis02 AND gis01=gir01 AND gir04='Y' AND gis01 = ?  AND aag00='",tm.b,"'"
   LET l_sql = "SELECT '','',gis02,gis03,gis04,gis05,gis06,axz03,axz04 ",                                                        
               "  FROM gis_file,gir_file,axz_file",                                                                              
               " WHERE gis01 = gir01 AND axz01 = gis06 AND gir04='Y' AND gis01 = ?"                                              
   PREPARE r006_p4 FROM l_sql                                                
   DECLARE r006_cu4 CURSOR FOR r006_p4                                       
   FOREACH r006_gir_cs2 INTO gir.*                                           
      LET l_amt_s = 0                                                        
      LET l_i_1 = 1  #FUN-940035 add
      FOREACH r006_cu4 USING gir.gir01 INTO tmp.*
        CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_dbs_axz03
        #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641   #FUN-B50001
        CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
        LET l_sql = "SELECT aag01,aag02 FROM ",g_dbs_axz03 CLIPPED,"aag_file ",
                    #" WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"   #FUN-B50001
                    " WHERE aag00 = '",g_aaw01,"' AND aag01 = '",tmp.gis02,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-A60013 add
        PREPARE aag_sel2 FROM l_sql
        EXECUTE aag_sel2 INTO tmp.aag01,tmp.aag02
   #FUN-950111--mod--end

        CASE tmp.gis04
          WHEN '1'
            CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)
                 RETURNING l_amt
          WHEN '2'
            CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
          WHEN '3'
            CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
          WHEN '4'
            SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
             WHERE git01 = gir.gir01 AND git02 = tmp.aag01
               AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
               AND git01 = gir01 AND gir04 = 'Y'
           #FUN-940035---Begin
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_git[l_i_1].gir02 = tmp.aag01||l_space||tmp.aag02   
            LET l_git[l_i_1].git05=l_amt
            LET l_i_1 = l_i_1 + 1
           #FUN-940035---End    
          WHEN '5'  #借方異動
            CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
                 RETURNING l_amt
          WHEN '6'  #貸方異動
            CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
                 RETURNING l_amt
        END CASE
        IF cl_null(l_amt) THEN LET l_amt = 0 END IF
        #若為減項
        IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
        LET l_amt_s = l_amt_s + l_amt
      END FOREACH
      LET l_i_1 = l_i_1 - 1   #FUN-940035 add
      IF l_amt_s = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      #計算投資活動產生之淨現金
      LET l_sub_amt = l_sub_amt + l_amt_s
      LET l_amt_s = l_amt_s*tm.q/g_unit       #依匯率及單位換算
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r006_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")" 
      END IF
      LET l_flag = 'Y'
      #FUN-940035---Begin
      IF tm.t = 'N' THEN 
         EXECUTE insert_prep USING l_type,'',gir.gir02,l_str2,gir.gir05   #CHI-990066 add gir05
      ELSE 
      	 FOR l_i_2 = 1 TO l_i_1
     	    IF l_git[l_i_2].git05 >= 0 THEN
               LET l_str2 = cl_numfor(l_git[l_i_2].git05,20,tm.e)
      	       EXECUTE insert_prep USING l_type,'',l_git[l_i_2].gir02,l_str2,gir.gir05   #CHI-990066 add gir05
            ELSE
               CALL r006_str(l_git[l_i_2].git05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
               EXECUTE insert_prep USING l_type,'','','',gir.gir05   #CHI-990066 add gir05
            END IF
     	 END FOR     
      END IF
      #FUN-940035--End	  
   END FOREACH
   IF l_flag = 'N' THEN
      EXECUTE insert_prep USING l_type,'','','',l_gir05   #CHI-990066 add l_gir05
   END IF

   LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
   LET l_type = '4'
   LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
   IF l_sub_amt >= 0 THEN
      LET l_str1 =cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL r006_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   EXECUTE insert_prep USING l_type,l_str1,'','',l_gir05   #CHI-990066 add l_gir05
   LET l_sub_amt = 0
   LET l_amt_s = 0

   #-------------------理財活動之現金流量------------------------------
   #理財活動之現金流量
   LET l_type = '5'
   LET l_flag = 'N'
   LET l_amt = 0
   LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",   #CHI-990066 add gir05
             " WHERE gir03 = '3' AND gir04='Y'"
   PREPARE r006_gir_p3 FROM l_sql
   DECLARE r006_gir_cs3 CURSOR FOR r006_gir_p3

   #FUN-950111--mod--str--
   #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
   #       " FROM aag_file,gis_file,gir_file",                                
   #       " WHERE aag01=gis02 AND gir01=gis01 AND gir04='Y' AND gis01 = ?  AND aag00='",tm.b,"'"
   LET l_sql = "SELECT '','',gis02,gis03,gis04,gis05,gis06,axz03,axz04 ",                                                        
               "  FROM gis_file,gir_file,axz_file",                                                                              
               " WHERE gis01 = gir01 AND axz01 = gis06 AND gir04='Y' AND gis01 = ?"                                              
   PREPARE r006_p5 FROM l_sql                                                
   DECLARE r006_cu5 CURSOR FOR r006_p5                                       
   FOREACH r006_gir_cs3 INTO gir.*                                           
      LET l_amt_s = 0                                                        
      LET l_i_1 = 1  #FUN-940035 add
      FOREACH r006_cu5 USING gir.gir01 INTO tmp.*
        CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_dbs_axz03
        #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641   #FUN-B50001
        CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01     #FUN-B50001
        LET l_sql = "SELECT aag01,aag02 FROM ",g_dbs_axz03 CLIPPED,"aag_file ",
                    #" WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"   #FUN-B50001
                    " WHERE aag00 = '",g_aaw01,"' AND aag01 = '",tmp.gis02,"'"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-A60013 add
        PREPARE aag_sel3 FROM l_sql
        EXECUTE aag_sel3 INTO tmp.aag01,tmp.aag02
   #FUN-950111--mod--end

        CASE tmp.gis04
          WHEN '1'
            CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)
                 RETURNING l_amt
          WHEN '2'
            CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt      
          WHEN '3'                                                           
            CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
          WHEN '4'
            SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
             WHERE git01 = gir.gir01 AND git02 = tmp.aag01
               AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
               AND git01 = gir01 AND gir04 = 'Y'
           #FUN-940035---Begin
            LET l_str_1 = tmp.aag01
            LET l_len = LENGTH(l_str_1)
            LET l_num = 26 - l_len
            LET l_space = l_num spaces
            LET l_git[l_i_1].gir02 = tmp.aag01||l_space||tmp.aag02
            LET l_git[l_i_1].git05=l_amt
            LET l_i_1 = l_i_1 + 1  
           #FUN-940035--End    
          WHEN '5'  #借方異動
            CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
                 RETURNING l_amt
          WHEN '6'  #貸方異動
            CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
                 RETURNING l_amt
        END CASE
        IF cl_null(l_amt) THEN LET l_amt = 0 END IF
        #若為減項
        IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
        LET l_amt_s = l_amt_s + l_amt
      END FOREACH
      LET l_i_1 = l_i_1 - 1   #FUN-940035 add
      IF l_amt_s = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      #計算理財活動產生之淨現金
      LET l_sub_amt = l_sub_amt + l_amt_s
      LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r006_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
      LET l_flag = 'Y'
      #FUN-940035---Begin
      IF tm.t = 'N' THEN 
         EXECUTE insert_prep USING l_type,'',gir.gir02,l_str2,gir.gir05   #CHI-990066 add gir05
      ELSE 
         FOR l_i_2 = 1 TO l_i_1
    	    IF l_git[l_i_2].git05 >= 0 THEN
               LET l_str2 = cl_numfor(l_git[l_i_2].git05,20,tm.e)
               EXECUTE insert_prep USING l_type,'',l_git[l_i_2].gir02,l_str2,gir.gir05   #CHI-990066 add gir05
            ELSE
               CALL r006_str(l_git[l_i_2].git05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
               EXECUTE insert_prep USING l_type,'','','',gir.gir05   #CHI-990066 add gir05
            END IF
    	 END FOR     
      END IF
      #FUN-940035---End	  
   END FOREACH
   IF l_flag = 'N' THEN
      EXECUTE insert_prep USING l_type,'','','',l_gir05   #CHI-990066 add l_gir05
   END IF

   LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
   LET l_type = '6'
   LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
   IF l_sub_amt >= 0 THEN
      LET l_str1 = cl_numfor(l_sub_amt,20,tm.e)
   ELSE
      CALL r006_str(l_sub_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   EXECUTE insert_prep USING l_type,l_str1,'','',l_gir05   #CHI-990066 add l_gir05

   LET l_type = '7'
   LET l_flag = 'N'
   LET l_amt = l_tot_amt                  #本期現金淨增數
   LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
   IF l_amt >=0 THEN
      LET l_str1 = cl_numfor(l_amt,20,tm.e)
   ELSE
      CALL r006_str(l_amt,l_str1) RETURNING l_str1
      LET l_str1 = l_str1 CLIPPED,')'
   END IF
   EXECUTE insert_prep USING l_type,l_str1,'','',l_gir05   #CHI-990066 add

   #-------------------期初現金及約當現金餘額 -------------------------
   LET l_amt = 0
   LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",   #CHI-990066 add gir05
             " WHERE gir03 = '4' AND gir04='Y'"
   PREPARE r006_gir_p4 FROM l_sql
   DECLARE r006_gir_cs4 CURSOR FOR r006_gir_p4

   #FUN-950111--mod--str--                                                                          
   #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
   #         " FROM aag_file,gis_file,gir_file",                              
   #         " WHERE aag01=gis02 AND gir01=gis01 AND gir04='Y' AND gis01 = ? AND aag00='",tm.b,"'"
   LET l_sql = "SELECT '','',gis02,gis03,gis04,gis05,gis06,axz03,axz04 ",                                                        
               "  FROM gis_file,gir_file,axz_file",                                                                              
               " WHERE gis01 = gir01 AND axz01 = gis06 AND gir04='Y' AND gis01 = ?"                                              
   PREPARE r006_p6 FROM l_sql                                                
   DECLARE r006_cu6 CURSOR FOR r006_p6                                       
   FOREACH r006_gir_cs4 INTO gir.*                                                   
      LET l_amt_s = 0                                                        
      LET l_i_1 = 1  #FUN-940035 add
      FOREACH r006_cu6 USING gir.gir01 INTO tmp.*
         CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_dbs_axz03
         #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641   #FUN-B50001
         CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
         LET l_sql = "SELECT aag01,aag02 FROM ",g_dbs_axz03 CLIPPED,"aag_file ",
                     #" WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"   #FUN-B50001
                     " WHERE aag00 = '",g_aaw01,"' AND aag01 = '",tmp.gis02,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-A60013 add
         PREPARE aag_sel4 FROM l_sql
         EXECUTE aag_sel4 INTO tmp.aag01,tmp.aag02
   #FUN-950111--mod--end

         CASE tmp.gis04
           WHEN '1'
             CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)
                  RETURNING l_amt
           WHEN '2'
             CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
           WHEN '3'
             CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
           WHEN '4'
             SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
              WHERE git01 = gir.gir01 AND git02 = tmp.aag01
                AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
                AND git01 = gir01 AND gir04 = 'Y'
            #FUN-940035---Begin
             LET l_str_1 = tmp.aag01
             LET l_len = LENGTH(l_str_1)
             LET l_num = 26 - l_len
             LET l_space = l_num spaces
             LET l_git[l_i_1].gir02 = tmp.aag01||l_space||tmp.aag02  
             LET l_git[l_i_1].git05=l_amt
             LET l_i_1 = l_i_1 + 1    
            #FUN-940035---End    
           WHEN '5'  #借方異動
             CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
                  RETURNING l_amt
           WHEN '6'  #貸方異動
             CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
                  RETURNING l_amt
         END CASE
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         #若為減項
         IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
         LET l_amt_s = l_amt_s + l_amt
      END FOREACH
      LET l_i_1 = l_i_1 - 1   #FUN-940035 add
      IF l_amt_s = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
     #LET l_this = l_amt_s            #MOD-920154 mark
      LET l_this = l_this + l_amt_s   #MOD-920154
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r006_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
      LET l_flag = 'Y'
      #FUN-940035---Begin
      IF tm.t = 'N' THEN 
         EXECUTE insert_prep USING l_type,l_str1,gir.gir02,l_str2,gir.gir05   #CHI-990066 add gir05
      ELSE 
         FOR l_i_2 = 1 TO l_i_1
            IF l_git[l_i_2].git05 >= 0 THEN
               LET l_str2 = cl_numfor(l_git[l_i_2].git05,20,tm.e)
               EXECUTE insert_prep USING l_type,l_str1,l_git[l_i_2].gir02,l_str2,gir.gir05   #CHI-990066 add gir05
            ELSE
               CALL r006_str(l_git[l_i_2].git05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
               EXECUTE insert_prep USING l_type,l_str1,'','',gir.gir05   #CHI-990066 add gir05
            END IF
         END FOR     
      END IF 
   #FUN-940035---End	     
   END FOREACH
   IF l_flag = 'N' THEN
      EXECUTE insert_prep USING l_type,l_str1,'','',l_gir05   #CHI-990066 add l_gir05
   END IF

   #--------------------期未現金及約當現金餘額---------------------
   LET l_type ='8'
   LET l_flag = 'N'
   INITIALIZE gir.* TO NULL
   LET l_amt = 0
   LET l_sql="SELECT gir01,gir02,gir05 FROM gir_file ",   #CHI-990066 add gir05
             " WHERE gir03 = '5' AND gir04='Y'"
   PREPARE r006_gir_p5 FROM l_sql
   DECLARE r006_gir_cs5 CURSOR FOR r006_gir_p5

   #FUN-950111--mod--str--                                                                          
   #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
   #        " FROM aag_file,gis_file,gir_file",                               
   #        " WHERE aag01=gis02 AND gis01=gir01 AND gir04='Y' AND gis01 = ? AND aag00='",tm.b,"'"
   LET l_sql = "SELECT '','',gis02,gis03,gis04,gis05,gis06,axz03,axz04 ",                                                        
               "  FROM gis_file,gir_file,axz_file",                                                                              
               " WHERE gis01 = gir01 AND axz01 = gis06 AND gir04='Y' AND gis01 = ?"                                              
   PREPARE r006_p7 FROM l_sql                                                
   DECLARE r006_cu7 CURSOR FOR r006_p7                                       
   FOREACH r006_gir_cs5 INTO gir.*                                                    
      LET l_amt_s = 0                                                        
      LET l_i_1 = 1  #FUN-940035 add
      FOREACH r006_cu7 USING gir.gir01 INTO tmp.*
         CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_dbs_axz03
         #CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaz641   #FUN-B50001
         CALL s_get_aaz641(g_dbs_axz03) RETURNING g_aaw01
         LET l_sql = "SELECT aag01,aag02 FROM ",g_dbs_axz03 CLIPPED,"aag_file ",
                     #" WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"   #FUN-B50001
                     " WHERE aag00 = '",g_aaw01,"' AND aag01 = '",tmp.gis02,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql #CHI-A60013 add
         PREPARE aag_sel5 FROM l_sql
         EXECUTE aag_sel5 INTO tmp.aag01,tmp.aag02
   #FUN-950111--mod--end

         CASE tmp.gis04
           WHEN '1'
             CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)
                  RETURNING l_amt
           WHEN '2'
             CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
           WHEN '3'
             CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
           WHEN '4'
             SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
              WHERE git01 = gir.gir01 AND git02 = tmp.aag01
                AND git06 = tm.y1 AND git07 BETWEEN tm.m1 AND tm.m2
                AND git01 = gir01 AND gir04 = 'Y'
            #FUN-940035---Begin
             LET l_str_1 = tmp.aag01
             LET l_len = LENGTH(l_str_1)
             LET l_num = 26 - l_len
             LET l_space = l_num spaces
             LET l_git[l_i_1].gir02 = tmp.aag01||l_space||tmp.aag02    
             LET l_git[l_i_1].git05=l_amt 
             LET l_i_1 = l_i_1 + 1  
            #FUN-940035---End    
           WHEN '5'  #借方異動
             CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
                  RETURNING l_amt
           WHEN '6'  #貸方異動
             CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
                  RETURNING l_amt
         END CASE
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         #若為減項
         IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
         LET l_amt_s = l_amt_s + l_amt
      END FOREACH
      LET l_i_1 = l_i_1 - 1   #FUN-940035 add
      IF l_amt_s = 0 AND tm.c = 'N' THEN
         CONTINUE FOREACH
      END IF
      LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
     #LET l_last = l_amt_s            #MOD-920154 mark
      LET l_last = l_last + l_amt_s   #MOD-920154
      IF l_amt_s >= 0 THEN
         LET l_str2 = cl_numfor(l_amt_s,20,tm.e)
      ELSE
         CALL r006_str(l_amt_s,l_str2) RETURNING l_str2
         LET l_str2 = l_str2 CLIPPED,")"
      END IF
      LET l_flag = 'Y'
      #FUN-940035---Begin
      IF tm.t = 'N' THEN 
         EXECUTE insert_prep USING l_type,'',gir.gir02,l_str2,gir.gir05   #CHI-990066 add gir05
      ELSE 
      	  FOR l_i_2 = 1 TO l_i_1
     	     IF l_git[l_i_2].git05 >= 0 THEN
               LET l_str2 = cl_numfor(l_git[l_i_2].git05,20,tm.e)
               EXECUTE insert_prep USING l_type,'',l_git[l_i_2].gir02,l_str2,gir.gir05   #CHI-990066 add gir05
            ELSE
               CALL r006_str(l_git[l_i_2].git05,l_str2) RETURNING l_str2
               LET l_str2 = l_str2 CLIPPED,')'
               EXECUTE insert_prep USING l_type,'','','',gir.gir05   #CHI-990066 add gir05
            END IF
     	  END FOR     
      END IF
      #FUN-940035---End	     
   END FOREACH
   IF l_flag = 'N' THEN
      EXECUTE insert_prep USING l_type,'','','',l_gir05   #CHI-990066 add l_gir05
   END IF

   LET l_amt = l_tot_amt                  #本期現金淨增數
   LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
   #若期未餘額 !=期初餘額+本期現金淨增數 show 緊告訊息 ....
   LET l_type = '9'
   IF l_last != l_this  + l_amt THEN
      LET l_diff = l_last - (l_this  + l_amt)
      LET l_str1 =  cl_numfor(l_diff,20,tm.e)
      EXECUTE insert_prep USING l_type,l_str1,'','',l_gir05   #CHI-990066 add l_gir05
   END IF
   IF tm.s = 'Y' THEN
      LET l_type = 'A'
      LET l_flag = 'N'
      LET g_cnt = 1
      DECLARE r006_gim CURSOR FOR
         SELECT gim01,gim02,gim03 FROM gim_file WHERE gim00='N'
      FOREACH r006_gim INTO g_gim[g_cnt].*
         IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)  
             EXIT FOREACH
         END IF
         LET g_cnt = g_cnt + 1
         IF g_cnt > g_max_rec THEN
            CALL cl_err('','9035',0)
            EXIT FOREACH
         END IF
      END FOREACH
      LET g_cnt = g_cnt - 1
      FOR i = 1 TO g_cnt
        #LET l_str2 = g_gim[i].gim03   #MOD-820135
         LET l_str2 = cl_numfor(g_gim[i].gim03,20,tm.e)   #MOD-820135
         LET l_flag = 'Y'
         EXECUTE insert_prep USING l_type,'',g_gim[i].gim02,l_str2,g_gim[i].gim01   #CHI-990066 add gim01
      END FOR
      IF l_flag = 'N' THEN
         EXECUTE insert_prep USING l_type,'','','',l_gir05   #CHI-990066 add l_gir05
      END IF
   END IF
         
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = tm.d,";",tm.title,";",tm.p,";","",";",tm.y1,";",tm.m1,";",
               l_d1,";",tm.y2,";",tm.m2,";",l_d2

   CALL cl_prt_cs3('aglr006','aglr006',g_sql,g_str)

END FUNCTION
#end CHI-AC0033 mod

#str CHI-AC0033 mark
#FUNCTION r006()
#     DEFINE l_name    LIKE type_file.chr20    # External(Disk) file name             #No.FUN-680098  VARCHAR(20) 
##     DEFINE     l_time LIKE type_file.chr8        #No.FUN-6A0073
#     DEFINE l_chr     LIKE type_file.chr1     #No.FUN-680098   VARCHAR(1) 
#     DEFINE l_za05    LIKE za_file.za05       #No.FUN-680098   VARCHAR(40) 
#     DEFINE amt1      LIKE type_file.num20_6  #No.FUN-680098  decimal(20,6)
#     DEFINE amt1_1    LIKE type_file.num20_6  #No.FUN-680098  decimal(20,6)
#     DEFINE l_tmp     LIKE type_file.num20_6  #No.FUN-680098  decimal(20,6)
#     #No.FUN-780058---Begin
#     DEFINE l_sql       LIKE type_file.chr1000        # RDSQL STATEMENT        #No
#     DEFINE l_last_sw   LIKE type_file.chr1           #No.FUN-680098   VARCHAR(1)    
#     DEFINE l_unit      LIKE zaa_file.zaa08           #No.FUN-680098   VARCHAR(4)    
#     DEFINE l_per1      LIKE fid_file.fid03           #No.FUN-680098   decimal(8,3
#     DEFINE l_d1        LIKE type_file.num5,          #No.FUN-680098   smallint   
#            l_d2        LIKE type_file.num5,          #No.FUN-680098   smallint   
#            l_flag      LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1)    
#            l_str       LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str1      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str2      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str3      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str4      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str5      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str6      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str7      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str8      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str9      LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_str10     LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21)   
#            l_bdate,l_edate    LIKE type_file.dat,    #No.FUN-680098   date    
#            l_type        LIKE type_file.chr1,        #正常餘額型態(1.借餘/2.貨>
#            l_cnt         LIKE type_file.num5,        #揭露事項筆數        #No.F
#            l_last_y      LIKE type_file.num5,        #期初年份            #No.F
#            l_last_m      LIKE type_file.num5,        #期初月份            #No.F
#            l_this        LIKE type_file.num20_6,     #本期餘額            #No.F
#            l_last        LIKE type_file.num20_6,     #期初餘額            #No.F
#            l_diff        LIKE type_file.num20_6,     #差異                #No.F
#            l_amt         LIKE type_file.num20_6,     #科目現金流量        #No.F
#            l_amt1        LIKE type_file.num20_6,     #本期損益金額        #No.F
#            l_amt_s       LIKE type_file.num20_6,     #群組現金流量        #No.F
#            l_sub_amt     LIKE type_file.num20_6,     #各活動產生之凈現金  #No.F
#            l_tot_amt     LIKE type_file.num20_6,     #本期現金凈增數      #No.F
#            l_tmp_amt     LIKE type_file.num20_6      #折舊科目之合計      #N
#     DEFINE tmp RECORD                                                            
#            aag01      LIKE aag_file.aag01,                                       
#            aag02      LIKE aag_file.aag02,                                       
#            gis02      LIKE gis_file.gis02,    #FUN-950111 add                                      
#            gis03      LIKE gis_file.gis03,                                       
#            gis04      LIKE gis_file.gis04,                                        
#            #FUN-950111--mod--str--                                                                                                 
#            gis05      LIKE gis_file.gis05,                                                                                         
#            gis06      LIKE gis_file.gis06,                                                                                         
#            axz03      LIKE axz_file.axz03,                                                                                         
#            axz04      LIKE axz_file.axz04                                                                                          
#            #FUN-950111--mod--end 
#            END RECORD                                                            
#     DEFINE gir RECORD                     # s艙 N腹                              
#            gir01      LIKE gir_file.gir01,                                       
#            gir02      LIKE gir_file.gir02                                        
#            END RECORD        
#     DEFINE l_gir02_1  LIKE gir_file.gir01                 
#     DEFINE l_gir02_2  LIKE gir_file.gir01                 
#     DEFINE l_gir02_3  LIKE gir_file.gir01                 
#     DEFINE l_gir02_4  LIKE gir_file.gir01                 
#     DEFINE l_gir02_5  LIKE gir_file.gir01                 
#     #FUN-950111--mod--str--
#     DEFINE l_axz03    LIKE axz_file.axz03
#     DEFINE l_axz04    LIKE axz_file.axz04
#     DEFINE l_axa09    LIKE axa_file.axa09
#     #FUN-950111--mod--end
# 
#     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
#                 " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                 
#                 "        ?,?,?,?,?, ?,?,?,?,?,",
#                 "        ?,?  )"                                         
#     PREPARE insert_prep FROM g_sql                                               
#     IF STATUS THEN                                                               
#        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
#     END IF      
# 
#     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                        
#                 " VALUES(?,?,? )"                                 
#     PREPARE insert_prep1 FROM g_sql                                               
#     IF STATUS THEN                                                               
#        CALL cl_err('insert_prep1:',status,1) EXIT PROGRAM                         
#     END IF  
#     #No.FUN-780058---End
#                        
#     CALL cl_del_data(l_table)                 #No.FUN-780058
#     CALL cl_del_data(l_table1)                #No.FUN-780058
#     SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
#            AND aaf02 = g_rlang
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr006'
#     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#     FOR g_i = 1 TO 70 LET g_dash2[g_i,g_i] = '-' END FOR
# 
#     #CALL cl_outnam('aglr006') RETURNING l_name      #No.FUN-780058
# 
#     ## TQC-650058 By Joe -------------------------------------
#     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr006'
#     #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF  #No.FUN-780058
#     #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR    #No.FUN-780058
#     #FOR g_i = 1 TO 70 LET g_dash2[g_i,g_i] = '-' END FOR      #No.FUN-780058
#     ## TQC-650058 By Joe -------------------------------------
# 
#     #No.FUN-780058---Begin
#     #START REPORT r006_rep TO l_name
#     #LET g_pageno = 0
#         
#     #--------CR----------------------------------------------------
#     #制表日期,期間,頁次                                                       
#     #CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate  #CHI-A70007 mark                
#     #CHI-A70007 add --start--
#     IF g_aza.aza63 = 'Y' THEN
#        CALL s_azmm(tm.y1,tm.m1,g_plant,tm.axa03) RETURNING l_flag,l_bdate,l_edate
#     ELSE
#       CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate                  
#     END IF
#     #CHI-A70007 add --end--
#     LET l_d1 = DAY(l_bdate)                                                   
#     #CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark                  
#     #CHI-A70007 add --start--
#     IF g_aza.aza63 = 'Y' THEN
#        CALL s_azmm(tm.y2,tm.m2,g_plant,tm.axa03) RETURNING l_flag,l_bdate,l_edate
#     ELSE
#       CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate                  
#     END IF
#     #CHI-A70007 add --end--
#     LET l_d2 = DAY(l_edate)                                                   
#     #1期的前一期是0期,0期的前一期是前一年的12期                                
#     IF tm.m1=0 THEN   #FUN-780068 mod 09/20 1->0                              
#        LET l_last_y = tm.y1 - 1                                               
#        LET l_last_m = 12                                                      
#     ELSE                                                                      
#        LET l_last_y = tm.y1                                                   
#        LET l_last_m = tm.m1 - 1                                               
#     END IF                                                                    
#    #LET g_ver = l_last_m              #上期版本   #FUN-780068 add 09/20 #MOD-990209    
# 
#     LET l_amt = 0                                                             
#     LET l_amt_s = 0                                                           
#     LET l_this = 0                                                            
#     LET l_last = 0                                                            
#     LET l_sub_amt = 0                                                         
#     LET l_tot_amt = 0                                                         
#     LET l_tmp_amt = 0   
#     #營業活動之現金流量
#     #---------------------本期凈利(損)------------------------------          
#      SELECT SUM(axh08-axh09) INTO l_amt FROM axh_file    #MOD-990209 axh09-->axh08-axh09                             
#       WHERE axh00=tm.b                           #帳別                         
#         AND axh05=g_aaz.aaz114                   #科目   #MOD-990209 aaz86-->aaz114                         
#         AND axh06=tm.y1                          #年度                         
##        AND axh07 BETWEEN tm.m1 AND tm.m2        #期別      #FUN-A90032 mark                   
#         AND axh07 = tm.m2                        #期別    #FUN-A90032                
#         AND axh01=tm.axa01                       #族群                         
#         AND axh02=tm.axa02                       #上層公司                     
#         AND axh03=tm.axa03                       #上層帳別                     
#         AND axh13='00'   #FUN-780068 add 09/20   #版本                         
#     #end FUN-780068 mod 09/20                                                  
#      IF cl_null(l_amt) THEN LET l_amt = 0 END IF                               
#     #LET l_amt=l_amt*-1  #FUN-780068 mark 09/20                                
#      LET l_tot_amt = l_tot_amt + l_amt        #計算本期現金凈增數              
#      LET l_amt = l_amt*tm.q/g_unit            #依匯率及單位換算   
#      CALL r006_str(l_amt,l_str1) RETURNING l_str1
# 
#      #調整項目                                                                 
#      #-------------------------營業科目-------------------------------         
#      LET l_amt = 0                                                             
#      LET l_sql="SELECT gir01,gir02 FROM gir_file ",                            
#                " WHERE gir03 = '1' AND gir04='Y'"                              
#      PREPARE r006_gir_p1 FROM l_sql                                            
#      DECLARE r006_gir_cs1 CURSOR FOR r006_gir_p1                               
#                                                                                
#      #FUN-950111--mod--str--                                                                           
#      #LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
#      #          "  FROM aag_file,gis_file,gir_file",                            
#      #          " WHERE aag01=gis02 AND gis01=gir01 AND aag00='",tm.b,"' ",  #No
#      #          " AND gir04='Y' AND gis01 = ? " 
#      LET l_sql = "SELECT '','',gis02,gis03,gis04,gis05,gis06,axz03,axz04 ",
#                  "  FROM gis_file,gir_file,axz_file",
#                  " WHERE gis01 = gir01 AND axz01 = gis06 AND gir04='Y' AND gis01 = ?" 
#      #FUN-950111--mod--end                                
#      PREPARE r006_p31 FROM l_sql                                                
#      DECLARE r006_cu31 CURSOR FOR r006_p31                                 
#      FOREACH r006_gir_cs1 INTO gir.*                                           
#        LET l_amt_s = 0                                                         
#        FOREACH r006_cu31 USING gir.gir01 INTO tmp.*                             
##FUN-A30122 -----------------mark start---------------------------
##          #FUN-950111--mod--str--
##          LET g_plant_new = tmp.axz03
##          CALL s_getdbs()
##          LET g_dbs_axz03 = g_dbs_new
##          IF tmp.axz04 = 'N' THEN  #為不使用tiptop
##             LET g_dbs_axz03= s_dbstring(g_dbs CLIPPED) 
##             LET g_plant_new = g_plant   #FUN-A50102
##          ELSE 
##             SELECT axa09 INTO l_axa09 FROM axa_file
##              WHERE axa01 = tmp.gis05
##                AND axa02 = tmp.gis06
##             IF l_axa09 = 'Y' THEN
##                SELECT axz03 INTO tmp.axz03 FROM axz_file
##                 WHERE axz01 = tmp.gis06
##                LET g_plant_new = tmp.axz03   #營運中心
##                CALL s_getdbs()
##                LET g_dbs_axz03= g_dbs_new
##             ELSE
##                LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
##                LET g_plant_new = g_plant   #FUN-A50102
##             END IF    
##          END IF   
##         #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102                                                                
##          LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
##                      " WHERE aaz00 = '0'"                                                                                           
##          CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
##          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
##          PREPARE r008_pre4 FROM g_sql                                                                                                
##          DECLARE r008_cur4 CURSOR FOR r008_pre4                                                                                       
##          OPEN r008_cur4                                                                                                              
##          FETCH r008_cur4 INTO g_aaz641    #合并後帳別                                                                             
##          IF cl_null(g_aaz641) THEN                                                                                               
##              CALL cl_err(tmp.gis06,'agl-601',1)                                                                                   
##          END IF  
##FUN-A30122 -------------------------------mark start------------------------------------------
#           CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_plant_axz03          #FUN-A30122 add 
#           CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                     #FUN-A30122 add
#           LET g_plant_new = g_plant_axz03                                         #FUN-A30122 add
#          #LET l_sql = "SELECT aag01,aag02 FROM ",g_dbs_axz03 CLIPPED,"aag_file ",  #FUN-A50102
#           LET l_sql = "SELECT aag01,aag02 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A50102
#                       " WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql   #FUN-A50102
#           CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-A50102
#           PREPARE aag_sel1 FROM l_sql
#           EXECUTE aag_sel1 INTO tmp.aag01,tmp.aag02
#           #FUN-950111--mod--end                           
#           CASE tmp.gis04                                                       
#             WHEN '1'   #異動                                                   
#              #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FU
#               CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FU
#                    RETURNING l_amt    
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '2'   #期初                                                   
#               CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt      
#             WHEN '3'   #期末                                                   
#               CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt            
#             WHEN '4'   #人工輸入                                               
#               SELECT SUM(git05) INTO l_amt FROM git_file,gir_file              
#                WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
#                  AND git06 = tm.y1 AND git07 = tm.m2                           
#                  AND  git01=gir01 AND gir04='Y'                                
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '5'  #借方異動                                                
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
#                    RETURNING l_amt       
#             WHEN '6'  #貸方異動                                                
#               CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#           END CASE                                                             
#           #若為減項                                                            
#           IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF               
#           LET l_amt_s = l_amt_s + l_amt                                        
#        END FOREACH     
# 
#        IF l_amt_s = 0 AND tm.c = 'N' THEN                                      
#           CONTINUE FOREACH                                                     
#        END IF                                                                  
#        Let l_sub_amt = l_sub_amt + l_amt_s   #計算營業活動產生之凈現金         
#        LET l_amt_s = l_amt_s*tm.q/g_unit     #依匯率及單位換算                 
#        CALL r006_str(l_amt_s,l_str2) RETURNING l_str2                         
#      END FOREACH         
# 
#      #營業活動產生之凈現金                                                     
#      LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金凈增數                
#      LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算                  
#      CALL r006_str(l_sub_amt,l_str3) RETURNING l_str3                         
#      LET l_sub_amt = 0                                                         
#      LET l_amt_s = 0       
# 
#      #----------------------投資活動之現金流量-----------------------
#      LET l_amt = 0                                                             
#                                                                                
#      LET l_sql="SELECT gir01,gir02 FROM gir_file ",                            
#                " WHERE gir03 = '2' AND gir04='Y' "                             
#      PREPARE r006_gir_p2 FROM l_sql                                            
#      DECLARE r006_gir_cs2 CURSOR FOR r006_gir_p2                               
#                                                                                
#      LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
#              " FROM aag_file,gis_file,gir_file",                               
#              " WHERE aag01=gis02 AND gis01=gir01 AND gir04='Y' ",
#              " AND gis01 = ?  AND aag00='",tm.b,"'"
#      PREPARE r006_p4 FROM l_sql                                                
#      DECLARE r006_cu4 CURSOR FOR r006_p4                                       
#      FOREACH r006_gir_cs2 INTO gir.*                                           
#         LET l_amt_s = 0                                                        
#         FOREACH r006_cu4 USING gir.gir01 INTO tmp.*                            
##FUN-A30122 ---------------------add start------------------------------------------------
#           CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_plant_axz03         
#           CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641
#           LET g_plant_new = g_plant_axz03  
#           LET l_sql = "SELECT aag01,aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), 
#                       " WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
#           CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql 
#           PREPARE aag_sel2 FROM l_sql                                          
#           EXECUTE aag_sel2 INTO tmp.aag01,tmp.aag02 
##FUN-A30122 ---------------------add end--------------------------------------
#           CASE tmp.gis04                                                       
#             WHEN '1'                                                           
#              #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FU
#               CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FU
#                    RETURNING l_amt                                             
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '2'                                                           
#               CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt 
#             WHEN '3'                                                           
#               CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt            
#             WHEN '4'                                                           
#               SELECT SUM(git05) INTO l_amt FROM git_file,gir_file              
#                WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
#                  AND git06 = tm.y1 AND git07 = tm.m2                           
#                  AND git01 = gir01 AND gir04 = 'Y'                             
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '5'  #借方異動                                                
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh08) INTO l_amt FROM axh_file                       
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#             WHEN '6'  #貸方異動                                                
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh09) INTO l_amt FROM axh_file   
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#           END CASE                                                             
#           #若為減項                                                            
#           IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF               
#           LET l_amt_s = l_amt_s + l_amt                                        
#         END FOREACH                                                            
#                                                                                
#         IF l_amt_s = 0 AND tm.c = 'N' THEN                                     
#            CONTINUE FOREACH                                                    
#         END IF                                                                 
#         #計算投資活動產生之凈現金                                              
#         LET l_sub_amt = l_sub_amt + l_amt_s                                    
#         LET l_amt_s = l_amt_s*tm.q/g_unit       #依匯率及單位換算              
#            CALL r006_str(l_amt_s,l_str4) RETURNING l_str4                      
#      END FOREACH                                                               
#      LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金凈增數                
#      LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算                  
#      CALL r006_str(l_sub_amt,l_str5) RETURNING l_str5                         
#      LET l_sub_amt = 0                                                         
#      LET l_amt_s = 0                                                           
#                                                                                
#      #-------------------理財活動之現金流量------------------------------      
#      #理財活動之現金流量                                                       
#      LET l_amt = 0                                                             
#      LET l_sql="SELECT gir01,gir02 FROM gir_file ",                            
#                " WHERE gir03 = '3' AND gir04='Y' "                             
#      PREPARE r006_gir_p3 FROM l_sql                                            
#      DECLARE r006_gir_cs3 CURSOR FOR r006_gir_p3 
#      LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
#             " FROM aag_file,gis_file,gir_file",                                
#             " WHERE aag01=gis02 AND gir01=gis01 AND gir04='Y' AND gis01 = ?  AND aag00='",tm.b,"'"
#      PREPARE r006_p5 FROM l_sql                                                
#      DECLARE r006_cu5 CURSOR FOR r006_p5                                       
#      FOREACH r006_gir_cs3 INTO gir.*                                           
#         LET l_amt_s = 0                                                        
#         FOREACH r006_cu5 USING gir.gir01 INTO tmp.*                            
##FUN-A30122 ----------------------add start--------------------------------------
#           CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_plant_axz03         
#           CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641
#           LET l_sql = "SELECT aag01,aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), 
#                       " WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
#           CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql
#           PREPARE aag_sel3 FROM l_sql                                          
#           EXECUTE aag_sel3 INTO tmp.aag01,tmp.aag02      
##FUN-A30122 -----------------------add end-------------------------------------------
#           CASE tmp.gis04                                                       
#             WHEN '1'                                                           
#              #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FU
#               CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FU
#                    RETURNING l_amt                                             
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '2'                                                           
#               CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt      
#             WHEN '3'                                                           
#               CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt            
#             WHEN '4'                                                           
#               SELECT SUM(git05) INTO l_amt FROM git_file,gir_file              
#                WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
#                  AND git06 = tm.y1 AND git07 = tm.m2                           
#                  AND git01 = gir01 AND gir04 = 'Y'  
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '5'  #借方異動                                                
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh08) INTO l_amt FROM axh_file                       
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#             WHEN '6'  #貸方異動                                                
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh09) INTO l_amt FROM axh_file                       
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#           END CASE                                                             
#           #若為減項       
#           IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF               
#           LET l_amt_s = l_amt_s + l_amt                                        
#         END FOREACH                                                            
#         IF l_amt_s = 0 AND tm.c = 'N' THEN                                     
#            CONTINUE FOREACH                                                    
#         END IF                                                                 
#         #計算理財活動產生之凈現金                                              
#         LET l_sub_amt = l_sub_amt + l_amt_s                                    
#         LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算               
#         CALL r006_str(l_amt_s,l_str6) RETURNING l_str6                        
#      END FOREACH                                                               
#      LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金凈增數                
#      LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算                  
#         CALL r006_str(l_sub_amt,l_str7) RETURNING l_str7                         
#                                                                                
###########################################################################      
#      LET l_amt = l_tot_amt                  #本期現金凈增數                    
#      LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算                  
#      CALL r006_str(l_amt,l_str8) RETURNING l_str8                             
# 
#      #-------------------期初現金及約當現金餘額 -------------------------      
#      #SKIP 1 LINE                                                               
#      LET l_amt = 0                                                             
#      LET l_sql="SELECT gir01,gir02 FROM gir_file ",                            
#                " WHERE gir03 = '4' AND gir04='Y' "                             
#      PREPARE r006_gir_p4 FROM l_sql                                            
#      DECLARE r006_gir_cs4 CURSOR FOR r006_gir_p4                               
#                                                                                
#      LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
#               " FROM aag_file,gis_file,gir_file",                              
#               " WHERE aag01=gis02 AND gir01=gis01 AND gir04='Y' AND gis01 = ? AND aag00='",tm.b,"'"
#      PREPARE r006_p6 FROM l_sql                                                
#      DECLARE r006_cu6 CURSOR FOR r006_p6                                       
#      FOREACH r006_gir_cs4 INTO gir.*                                           
#         LET l_amt_s = 0                                                        
#         FOREACH r006_cu6 USING gir.gir01 INTO tmp.*                            
##FUN-A30122 ------------------------add start----------------------------------
#           CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_plant_axz03         
#           CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641
#           LET g_plant_new = g_plant_axz03 
#           LET l_sql = "SELECT aag01,aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), 
#                       " WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql          
#           CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql   
#           PREPARE aag_sel4 FROM l_sql                                          
#           EXECUTE aag_sel4 INTO tmp.aag01,tmp.aag02   
##FUN-A30122 -------------------------add end---------------------------------------
#           CASE tmp.gis04                                                       
#             WHEN '1'   #異動                                                   
#              #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FU
#               CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FU
#                    RETURNING l_amt                                             
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '2'   #期初 
#               CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt      
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '3'   #期末                                                   
#               CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt            
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '4'   #人工輸入                                               
#               SELECT SUM(git05) INTO l_amt FROM git_file,gir_file              
#                WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
#                  AND git06 = tm.y1 AND git07 = tm.m2                           
#                  AND gir01 = git01 AND gir04 = 'Y'                             
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '5'   #借方異動                                               
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh08) INTO l_amt FROM axh_file                       
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#             WHEN '6'   #貸方異動 
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh09) INTO l_amt FROM axh_file                       
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#           END CASE                                                             
#           #若為減項                                                            
#           IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF               
#           LET l_amt_s = l_amt_s + l_amt                                        
#         END FOREACH                                                            
#         IF l_amt_s = 0 AND tm.c = 'N' THEN                                     
#            CONTINUE FOREACH                                                    
#         END IF                                                                 
#         LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算               
#         LET l_this  = l_amt_s                                                  
#         CALL r006_str(l_amt_s,l_str9) RETURNING l_str9                       
#      END FOREACH      
#      #--------------------期未現金及約當現金餘額---------------------          
#      INITIALIZE gir.* TO NULL                                                  
#      #SKIP 1 LINE                                                               
#      LET l_amt = 0                                                             
#      LET l_sql="SELECT gir01,gir02 FROM gir_file ",                            
#                " WHERE gir03 = '5' AND gir04='Y' "                             
#      PREPARE r006_gir_p5 FROM l_sql                                            
#      DECLARE r006_gir_cs5 CURSOR FOR r006_gir_p5                               
#                                                                                
#      LET l_sql="SELECT aag01,aag02,gis03,gis04 ",                              
#              " FROM aag_file,gis_file,gir_file",                               
#              " WHERE aag01=gis02 AND gis01=gir01 AND gir04='Y' AND gis01 = ? AND aag00='",tm.b,"'"
#      PREPARE r006_p7 FROM l_sql                                                
#      DECLARE r006_cu7 CURSOR FOR r006_p7                                       
#      FOREACH r006_gir_cs5 INTO gir.*                                           
#         LET l_amt_s = 0                                                        
#         FOREACH r006_cu7 USING gir.gir01 INTO tmp.*                            
##FUN-A30122 ------------------------------add start-------------------------
#           CALL s_aaz641_dbs(tmp.gis05,tmp.gis06) RETURNING g_plant_axz03         
#           CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641
#           LET g_plant_new = g_plant_axz03 
#           LET l_sql = "SELECT aag01,aag02 FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), 
#                       " WHERE aag00 = '",g_aaz641,"' AND aag01 = '",tmp.gis02,"'"
#           CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
#           CALL cl_parse_qry_sql(l_sql,g_plant_axz03) RETURNING l_sql
#           PREPARE aag_sel5 FROM l_sql                                          
#           EXECUTE aag_sel5 INTO tmp.aag01,tmp.aag02
##FUN-A30122 ------------------------------add end--------------------------
#           CASE tmp.gis04                                                       
#             WHEN '1'                                                           
#              #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FU
#               CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FU
#                    RETURNING l_amt                                             
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF     
#             WHEN '2'                                                           
#               CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt      
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '3'                                                           
#               CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt            
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '4'                                                           
#               SELECT SUM(git05) INTO l_amt FROM git_file,gir_file              
#                WHERE git01 = gir.gir01 AND git02 = tmp.aag01                   
#                  AND git06 = tm.y1 AND git07 = tm.m2                           
#                  AND git01 = gir01 AND gir04 = 'Y'                             
#               IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#             WHEN '5'  #借方異動                                                
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh08) INTO l_amt FROM axh_file                       
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#             WHEN '6'  #貸方異動                                                                                                
#              #str FUN-780068 mod 09/20                                         
#               CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m)                
#                    RETURNING l_amt                                             
#              #SELECT SUM(axh09) INTO l_amt FROM axh_file                       
#              # WHERE axh00=tm.b AND axh05=tmp.aag01                            
#              #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2             
#              #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03      
#              #IF cl_null(l_amt) THEN LET l_amt = 0 END IF                      
#              #end FUN-780068 mod 09/20                                         
#           END CASE                                                             
#           #若為減項                                                            
#           IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF               
#           LET l_amt_s = l_amt_s + l_amt                                        
#         END FOREACH                                                            
#         IF l_amt_s = 0 AND tm.c = 'N' THEN                                     
#            CONTINUE FOREACH                                                    
#         END IF                                                                 
#         LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算               
#         LET l_last = l_amt_s                                                   
#         CALL r006_str(l_amt_s,l_str10) RETURNING l_str10                        
#      END FOREACH                                                               
#      LET l_amt = l_tot_amt                  #本期現金凈增數                    
#      LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算                  
#                                                                                
#      #若期未餘額 !=期初餘額+本期現金凈增數 show 緊告訊息 ....                  
#      IF l_last != l_this  + l_amt THEN                                         
#         LET l_diff = l_last - (l_this  + l_amt)                                
#      END IF                                                                    
#      IF tm.s = 'Y' THEN                                                        
#         LET g_cnt = 1                                                          
#         DECLARE r006_gim CURSOR FOR                                            
#          SELECT gim02,gim03 FROM gim_file WHERE gim00 = 'Y'                    
#         FOREACH r006_gim INTO g_gim[g_cnt].*                                   
#           IF SQLCA.sqlcode THEN       
#               CALL cl_err('foreach:',SQLCA.sqlcode,1)                          
#               EXIT FOREACH                                                     
#           END IF                                                               
#           LET g_cnt = g_cnt + 1                                                
#           IF g_cnt > g_max_rec THEN                                            
#              CALL cl_err('','9035',0)                                          
#              EXIT FOREACH                                                      
#           END IF                                                               
#         END FOREACH                                                            
#         LET g_cnt = g_cnt - 1                                                  
#         FOR i = 1 TO g_cnt                                                     
#             EXECUTE insert_prep1 USING tm.title,g_gim[i].gim02,g_gim[i].gim03      
#         END FOR                                                                
#      END IF    
#      EXECUTE insert_prep USING tm.title,l_amt1,l_amt_s,l_sub_amt,l_str1,l_str2,  #FUN-780068      10/19
#                                l_str3,l_str4,l_str5,l_str6,l_str7,
#                                l_str8,l_str9,l_str10,l_gir02_1,l_gir02_2,l_gir02_3,
#                                l_gir02_4,l_gir02_5,l_diff,l_last,l_this                                                     
#     #OUTPUT TO REPORT r006_rep()
# 
#     #FINISH REPORT r006_rep
# 
#     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
# 
#     LET g_str = tm.p,";",l_unit,";",g_mai02,";",g_pdate,";",l_str,";",            
#                 tm.y1,";",tm.m1,";",l_d1,";",tm.y2,";",tm.m2,";",
#                 l_d2,";",tm.d,";",tm.s,";",tm.e         
#     #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",  
#     #            "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED                               
#     LET l_sql = "SELECT B.gim02,B.gim03,A.* ",     
#                 " FROM ",g_cr_db_str CLIPPED, l_table CLIPPED," A ",
#                 " LEFT OUTER JOIN ", g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
#                 " ON A.title=B.title" 
#     CALL cl_prt_cs3('aglr006','aglr006',l_sql,g_str)
#     #No.FUN-780058---End 
#END FUNCTION
#end CHI-AC0033 mark
 
#No.FUN-780058---Begin
#REPORT r006_rep()
#  DEFINE l_sql       LIKE type_file.chr1000        # RDSQL STATEMENT        #No.FUN-680098 VARCHAR(1000) 
#  DEFINE l_last_sw   LIKE type_file.chr1           #No.FUN-680098   VARCHAR(1) 
#  DEFINE l_unit      LIKE zaa_file.zaa08           #No.FUN-680098   VARCHAR(4)  
#  DEFINE l_per1      LIKE fid_file.fid03           #No.FUN-680098   decimal(8,3)
#  DEFINE l_d1        LIKE type_file.num5,          #No.FUN-680098   smallint
#         l_d2        LIKE type_file.num5,          #No.FUN-680098   smallint
#         l_flag      LIKE type_file.chr1,          #No.FUN-680098   VARCHAR(1) 
#         l_str       LIKE type_file.chr1000,       #No.FUN-680098   VARCHAR(21) 
#         l_bdate,l_edate    LIKE type_file.dat,    #No.FUN-680098   date
#         l_type        LIKE type_file.chr1,        #正常餘額型態(1.借餘/2.貨餘)  #No.FUN-680098    VARCHAR(1) 
#         l_cnt         LIKE type_file.num5,        #揭露事項筆數        #No.FUN-680098 SMALLINT
#         l_last_y      LIKE type_file.num5,        #期初年份            #No.FUN-680098 SMALLINT
#         l_last_m      LIKE type_file.num5,        #期初月份            #No.FUN-680098 SMALLINT
#         l_this        LIKE type_file.num20_6,     #本期餘額            #No.FUN-680098 DECIMAL(20,6)
#         l_last        LIKE type_file.num20_6,     #期初餘額            #No.FUN-680098 DECIMAL(20,6)
#         l_diff        LIKE type_file.num20_6,     #差異                #No.FUN-680098 DECIMAL(20,6)
#         l_amt         LIKE type_file.num20_6,     #科目現金流量        #No.FUN-680098 DECIMAL(20,6)
#         l_amt1        LIKE type_file.num20_6,     #上期餘額            #No.FUN-780068 add 09/20
#         l_amt_s       LIKE type_file.num20_6,     #群組現金流量        #No.FUN-680098 DECIMAL(20,6)
#         l_sub_amt     LIKE type_file.num20_6,     #各活動產生之淨現金  #No.FUN-680098 DECIMAL(20,6)
#         l_tot_amt     LIKE type_file.num20_6,     #本期現金淨增數      #No.FUN-680098 DECIMAL(20,6)
#         l_tmp_amt     LIKE type_file.num20_6      #折舊科目之合計      #No.FUN-680098 DECIMAL(20,6)
#  DEFINE tmp RECORD
#         aag01      LIKE aag_file.aag01,
#         aag02      LIKE aag_file.aag02,
#         gis03      LIKE gis_file.gis03,
#         gis04      LIKE gis_file.gis04
#         END RECORD
#  DEFINE gir RECORD                     #群組代號
#         gir01      LIKE gir_file.gir01,
#         gir02      LIKE gir_file.gir02
#         END RECORD
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-6),' FROM:',g_user CLIPPED
 
#     #報表結構,報表名稱,幣別,單位
#     CASE tm.d
#          WHEN '1'  LET l_unit = g_x[31]
#          WHEN '2'  LET l_unit = g_x[32]
#          WHEN '3'  LET l_unit = g_x[33]
#          OTHERWISE LET l_unit = ' '
#     END CASE
#     PRINT g_x[11] CLIPPED,COLUMN (g_len-FGL_WIDTH(g_x[1]))/2,
#           tm.title CLIPPED,COLUMN 60,g_x[12] CLIPPED,tm.p,' ',
#           g_x[13] CLIPPED,l_unit
#     LET g_x[1] = g_mai02
#     PRINT
#     LET g_pageno = g_pageno + 1
#     #製表日期,期間,頁次
#     CALL s_azm(tm.y1,tm.m1) RETURNING l_flag,l_bdate,l_edate
#     LET l_d1 = DAY(l_bdate)
#     CALL s_azm(tm.y2,tm.m2) RETURNING l_flag,l_bdate,l_edate
#     LET l_d2 = DAY(l_edate)
#    #1期的前一期是0期,0期的前一期是前一年的12期
#     IF tm.m1=0 THEN   #FUN-780068 mod 09/20 1->0
#        LET l_last_y = tm.y1 - 1
#        LET l_last_m = 12
#     ELSE
#        LET l_last_y = tm.y1
#        LET l_last_m = tm.m1 - 1
#     END IF
#     LET g_ver = l_last_m              #上期版本   #FUN-780068 add 09/20
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,'  ',
#           tm.y1 USING '<<<<',g_x[28] CLIPPED,tm.m1 USING '&&',
#           g_x[29] CLIPPED,l_d1 USING '&&',g_x[30] CLIPPED,'∼',
#           tm.y2 USING '<<<<',g_x[28] CLIPPED,
#           tm.m2 USING '&&',g_x[29] CLIPPED,
#           l_d2 USING '&&',g_x[30] CLIPPED,
#           COLUMN g_len-11,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'n'
 
#  ON EVERY ROW
#     LET l_amt = 0
#     LET l_amt_s = 0
#     LET l_this = 0
#     LET l_last = 0
#     LET l_sub_amt = 0
#     LET l_tot_amt = 0
#     LET l_tmp_amt = 0
#     #營業活動之現金流量
#     PRINT g_x[14] CLIPPED
#     #---------------------本期淨利(損)------------------------------
#    #str FUN-780068 mod 09/20
#    #CALL r006_axh(g_aaz.aaz31,tm.y1,tm.m2,l_amt) RETURNING l_amt
#     SELECT SUM(axh09) INTO l_amt FROM axh_file
#      WHERE axh00=tm.b                           #帳別  
#        AND axh05=g_aaz.aaz86                    #科目 
#        AND axh06=tm.y1                          #年度 
#        AND axh07 BETWEEN tm.m1 AND tm.m2        #期別
#        AND axh01=tm.axa01                       #族群 
#        AND axh02=tm.axa02                       #上層公司 
#        AND axh03=tm.axa03                       #上層帳別 
#        AND axh13='00'   #FUN-780068 add 09/20   #版本
#    #end FUN-780068 mod 09/20
#     IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#    #LET l_amt=l_amt*-1  #FUN-780068 mark 09/20
#     LET l_tot_amt = l_tot_amt + l_amt        #計算本期現金淨增數
#     PRINT g_x[15] CLIPPED;
#     LET l_amt = l_amt*tm.q/g_unit            #依匯率及單位換算
#     IF l_amt >= 0 THEN
#        PRINT COLUMN 39,cl_numfor(l_amt,20,tm.e)
#     ELSE
#        CALL r006_str(l_amt,l_str) RETURNING l_str
#        PRINT COLUMN 39,l_str,')'
#     END IF
#     #調整項目
#     PRINT g_x[16]
#     #-------------------------營業科目-------------------------------
#     LET l_amt = 0
#     LET l_sql="SELECT gir01,gir02 FROM gir_file ",
#               " WHERE gir03 = '1' AND gir04='Y'"
#     PREPARE r006_gir_p11 FROM l_sql
#     DECLARE r006_gir_cs11 CURSOR FOR r006_gir_p11
 
#     LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
#               "  FROM aag_file,gis_file,gir_file",
#               " WHERE aag01=gis02 AND gis01=gir01 AND aag00='",tm.b,"' ",  #No.FUN-740020
#               " AND gir04='Y' AND gis01 = ? "
#     PREPARE r006_p3 FROM l_sql
#     DECLARE r006_cu3 CURSOR FOR r006_p3
#     FOREACH r006_gir_cs11 INTO gir.*
#       LET l_amt_s = 0
#       FOREACH r006_cu3 USING gir.gir01 INTO tmp.*
#          CASE tmp.gis04
#            WHEN '1'   #異動
#             #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FUN-780068 mark 09/20
#              CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FUN-780068      09/20
#                   RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '2'   #期初
#              CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
#            WHEN '3'   #期末
#              CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
#            WHEN '4'   #人工輸入
#              SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
#               WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#                 AND git06 = tm.y1 AND git07 = tm.m2
#                 AND  git01=gir01 AND gir04='Y'
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '5'  #借方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh08) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b 
#             #   AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 
#             #   AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#            WHEN '6'  #貸方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh09) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b 
#             #   AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 
#             #   AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#          END CASE
#          #若為減項
#          IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
#          LET l_amt_s = l_amt_s + l_amt
#       END FOREACH
 
#       IF l_amt_s = 0 AND tm.c = 'N' THEN
#          CONTINUE FOREACH
#       END IF
#       Let l_sub_amt = l_sub_amt + l_amt_s   #計算營業活動產生之淨現金
#       PRINT 8 SPACE,gir.gir02 CLIPPED;
#       LET l_amt_s = l_amt_s*tm.q/g_unit     #依匯率及單位換算
#       IF l_amt_s >= 0 THEN
#          PRINT COLUMN 59,cl_numfor(l_amt_s,20,tm.e)
#       ELSE
#          CALL r006_str(l_amt_s,l_str) RETURNING l_str
#          PRINT COLUMN 59,l_str,')'
#       END IF
#     END FOREACH
 
#     #營業活動產生之淨現金
#     LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
#     PRINT g_x[20] CLIPPED;
#     LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
#     IF l_sub_amt >= 0 THEN
#        PRINT COLUMN 59,cl_numfor(l_sub_amt,20,tm.e)
#     ELSE
#        CALL r006_str(l_sub_amt,l_str) RETURNING l_str
#        PRINT COLUMN 59,l_str,')'
#     END IF
#     LET l_sub_amt = 0
#     LET l_amt_s = 0
#     SKIP 1 LINE
 
#     #----------------------投資活動之現金流量-----------------------
#     PRINT g_x[21]
#     LET l_amt = 0
 
#     LET l_sql="SELECT gir01,gir02 FROM gir_file ",
#               " WHERE gir03 = '2' AND gir04='Y' "
#     PREPARE r006_gir_p21 FROM l_sql
#     DECLARE r006_gir_cs21 CURSOR FOR r006_gir_p21
 
#     LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
#             " FROM aag_file,gis_file,gir_file",
#             " WHERE aag01=gis02 AND gis01=gir01 AND gir04='Y' AND gis01 = ?  AND aag00='",tm.b,"' " #No.FUN-740020
#     PREPARE r006_p41 FROM l_sql
#     DECLARE r006_cu41 CURSOR FOR r006_p41
#     FOREACH r006_gir_cs21 INTO gir.*
#        LET l_amt_s = 0
#        FOREACH r006_cu41 USING gir.gir01 INTO tmp.*
#          CASE tmp.gis04
#            WHEN '1'
#             #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FUN-780068 mark 09/20
#              CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FUN-780068      09/20
#                   RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '2'
#              CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
#            WHEN '3'
#              CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
#            WHEN '4'
#              SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
#               WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#                 AND git06 = tm.y1 AND git07 = tm.m2
#                 AND git01 = gir01 AND gir04 = 'Y'
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '5'  #借方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh08) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#            WHEN '6'  #貸方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh09) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#          END CASE
#          #若為減項
#          IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
#          LET l_amt_s = l_amt_s + l_amt
#        END FOREACH
 
#        IF l_amt_s = 0 AND tm.c = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#        #計算投資活動產生之淨現金
#        LET l_sub_amt = l_sub_amt + l_amt_s
#        PRINT 8 SPACE,gir.gir02 CLIPPED;
#        LET l_amt_s = l_amt_s*tm.q/g_unit       #依匯率及單位換算
#        IF l_amt_s >= 0 THEN
#           PRINT COLUMN 59,cl_numfor(l_amt_s,20,tm.e)
#        ELSE
#           CALL r006_str(l_amt_s,l_str) RETURNING l_str
#           PRINT COLUMN 59,l_str,")"
#        END IF
#     END FOREACH
#     LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
#     PRINT g_x[22] CLIPPED;
#     LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
#     IF l_sub_amt >= 0 THEN
#        PRINT COLUMN 59,cl_numfor(l_sub_amt,20,tm.e)
#     ELSE
#        CALL r006_str(l_sub_amt,l_str) RETURNING l_str
#        PRINT COLUMN 59,l_str,')'
#     END IF
#     LET l_sub_amt = 0
#     LET l_amt_s = 0
 
#     #-------------------理財活動之現金流量------------------------------
#     #理財活動之現金流量
#     SKIP 1 LINE
#     PRINT g_x[23]
#     LET l_amt = 0
#     LET l_sql="SELECT gir01,gir02 FROM gir_file ",
#               " WHERE gir03 = '3' AND gir04='Y' "
#     PREPARE r006_gir_p31 FROM l_sql
#     DECLARE r006_gir_cs31 CURSOR FOR r006_gir_p31
 
#     LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
#            " FROM aag_file,gis_file,gir_file",
#            " WHERE aag01=gis02 AND gir01=gis01 AND gir04='Y' AND gis01 = ?  AND aag00='",tm.b,"'" #No.FUN-740020
#     PREPARE r006_p51 FROM l_sql
#     DECLARE r006_cu51 CURSOR FOR r006_p51
#     FOREACH r006_gir_cs31 INTO gir.*
#        LET l_amt_s = 0
#        FOREACH r006_cu51 USING gir.gir01 INTO tmp.*
#          CASE tmp.gis04
#            WHEN '1'
#             #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FUN-780068 mark 09/20
#              CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FUN-780068      09/20
#                   RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '2'
#              CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
#            WHEN '3'
#              CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
#            WHEN '4'
#              SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
#               WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#                 AND git06 = tm.y1 AND git07 = tm.m2
#                 AND git01 = gir01 AND gir04 = 'Y'
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '5'  #借方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh08) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#            WHEN '6'  #貸方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh09) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#          END CASE
#          #若為減項
#          IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
#          LET l_amt_s = l_amt_s + l_amt
#        END FOREACH
#        IF l_amt_s = 0 AND tm.c = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#        #計算理財活動產生之淨現金
#        LET l_sub_amt = l_sub_amt + l_amt_s
#        PRINT 8 SPACE,gir.gir02 CLIPPED;
#        LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
#        IF l_amt_s >= 0 THEN
#           PRINT COLUMN 59,cl_numfor(l_amt_s,20,tm.e)
#        ELSE
#           CALL r006_str(l_amt_s,l_str) RETURNING l_str
#           PRINT COLUMN 59,l_str,")"
#        END IF
#     END FOREACH
#     LET l_tot_amt = l_tot_amt + l_sub_amt  #計算本期現金淨增數
#     PRINT g_x[24] CLIPPED;
#     LET l_sub_amt = l_sub_amt*tm.q/g_unit  #依匯率及單位換算
#     IF l_sub_amt >= 0 THEN
#        PRINT COLUMN 59,cl_numfor(l_sub_amt,20,tm.e)
#     ELSE
#        CALL r006_str(l_sub_amt,l_str) RETURNING l_str
#        PRINT COLUMN 59,l_str,')'
#     END IF
#     PRINT COLUMN 59,'----------------------'
 
##########################################################################
#     PRINT g_x[25] CLIPPED;
#     LET l_amt = l_tot_amt                  #本期現金淨增數
#     LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
#     IF l_amt >=0 THEN
#        PRINT COLUMN 59,cl_numfor(l_amt,20,tm.e)
#     ELSE
#        CALL r006_str(l_amt,l_str) RETURNING l_str
#        PRINT COLUMN 59,l_str,')'
#     END IF
#     PRINT COLUMN 59,'======================'
#     SKIP 1 LINE
 
#     #-------------------期初現金及約當現金餘額 -------------------------
#     SKIP 1 LINE
#     LET l_amt = 0
#     LET l_sql="SELECT gir01,gir02 FROM gir_file ",
#               " WHERE gir03 = '4' AND gir04='Y' "
#     PREPARE r006_gir_p41 FROM l_sql
#     DECLARE r006_gir_cs41 CURSOR FOR r006_gir_p41
 
#     LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
#              " FROM aag_file,gis_file,gir_file",
#              " WHERE aag01=gis02 AND gir01=gis01 AND gir04='Y' AND gis01 = ? AND aag00='",tm.b,"'"  #No.FUN-740020
#     PREPARE r006_p61 FROM l_sql
#     DECLARE r006_cu61 CURSOR FOR r006_p61
#     FOREACH r006_gir_cs41 INTO gir.*
#        LET l_amt_s = 0
#        FOREACH r006_cu6 USING gir.gir01 INTO tmp.*
#          CASE tmp.gis04
#            WHEN '1'   #異動
#             #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FUN-780068 mark 09/20
#              CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FUN-780068      09/20
#                   RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '2'   #期初
#              CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '3'   #期末
#              CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '4'   #人工輸入
#              SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
#               WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#                 AND git06 = tm.y1 AND git07 = tm.m2
#                 AND gir01 = git01 AND gir04 = 'Y'
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '5'   #借方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh08) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#            WHEN '6'   #貸方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh09) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#          END CASE
#          #若為減項
#          IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
#          LET l_amt_s = l_amt_s + l_amt
#        END FOREACH
#        IF l_amt_s = 0 AND tm.c = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#        PRINT 8 SPACE,gir.gir02 CLIPPED;
#        LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
#        LET l_this  = l_amt_s
#        IF l_amt_s >= 0 THEN
#           PRINT COLUMN 59,cl_numfor(l_amt_s,20,tm.e)
#        ELSE
#           CALL r006_str(l_amt_s,l_str) RETURNING l_str
#           PRINT COLUMN 59,l_str,")"
#        END IF
#     END FOREACH
#     #--------------------期未現金及約當現金餘額---------------------
#     INITIALIZE gir.* TO NULL
#     SKIP 1 LINE
#     LET l_amt = 0
#     LET l_sql="SELECT gir01,gir02 FROM gir_file ",
#               " WHERE gir03 = '5' AND gir04='Y' "
#     PREPARE r006_gir_p51 FROM l_sql
#     DECLARE r006_gir_cs51 CURSOR FOR r006_gir_p51
 
#     LET l_sql="SELECT aag01,aag02,gis03,gis04 ",
#             " FROM aag_file,gis_file,gir_file",
#             " WHERE aag01=gis02 AND gis01=gir01 AND gir04='Y' AND gis01 = ? AND aag00='",tm.b,"'"  #No.FUN-740020
#     PREPARE r006_p71 FROM l_sql
#     DECLARE r006_cu71 CURSOR FOR r006_p71
#     FOREACH r006_gir_cs51 INTO gir.*
#        LET l_amt_s = 0
#        FOREACH r006_cu71 USING gir.gir01 INTO tmp.*
#          CASE tmp.gis04
#            WHEN '1'
#             #CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_amt)                    #FUN-780068 mark 09/20
#              CALL r006_axh(tmp.aag01,tm.y2,tm.m2,l_last_y,l_last_m,l_amt)  #FUN-780068      09/20
#                   RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '2'
#              CALL r006_axh2(tmp.aag01,l_last_y,l_last_m) RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '3'
#              CALL r006_axh2(tmp.aag01,tm.y2,tm.m2) RETURNING l_amt
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '4'
#              SELECT SUM(git05) INTO l_amt FROM git_file,gir_file
#               WHERE git01 = gir.gir01 AND git02 = tmp.aag01
#                 AND git06 = tm.y1 AND git07 = tm.m2
#                 AND git01 = gir01 AND gir04 = 'Y'
#              IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#            WHEN '5'  #借方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'5',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh08) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#            WHEN '6'  #貸方異動
#             #str FUN-780068 mod 09/20
#              CALL r006_axh_dc(tmp.aag01,'6',l_last_y,l_last_m) 
#                   RETURNING l_amt
#             #SELECT SUM(axh09) INTO l_amt FROM axh_file
#             # WHERE axh00=tm.b AND axh05=tmp.aag01
#             #   AND axh06=tm.y1 AND axh07 BETWEEN tm.m1 AND tm.m2
#             #   AND axh01=tm.axa01 AND axh02=tm.axa02 AND axh03=tm.axa03
#             #IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#             #end FUN-780068 mod 09/20
#          END CASE
#          #若為減項
#          IF tmp.gis03 = '-' THEN LET l_amt  = l_amt * -1 END IF
#          LET l_amt_s = l_amt_s + l_amt
#        END FOREACH
#        IF l_amt_s = 0 AND tm.c = 'N' THEN
#           CONTINUE FOREACH
#        END IF
#        PRINT 8 SPACE,gir.gir02 CLIPPED;
#        LET l_amt_s= l_amt_s*tm.q/g_unit       #依匯率及單位換算
#        LET l_last = l_amt_s
#        IF l_amt_s >= 0 THEN
#           PRINT COLUMN 59,cl_numfor(l_amt_s,20,tm.e)
#        ELSE
#           CALL r006_str(l_amt_s,l_str) RETURNING l_str
#           PRINT COLUMN 59,l_str,")"
#        END IF
#     END FOREACH
#     LET l_amt = l_tot_amt                  #本期現金淨增數
#     LET l_amt = l_amt*tm.q/g_unit          #依匯率及單位換算
 
#     #若期未餘額 !=期初餘額+本期現金淨增數 show 緊告訊息 ....
#     IF l_last != l_this  + l_amt THEN
#        LET l_diff = l_last - (l_this  + l_amt)
#        PRINT
#        PRINT COLUMN 10,g_x[35] CLIPPED,g_x[36] CLIPPED,
#                        l_diff USING '----------'
#     END IF
#     IF tm.s = 'Y' THEN
#        SKIP 4 LINE
#        PRINT g_x[34] CLIPPED
#        SKIP 1 LINE
#        LET g_cnt = 1
#        DECLARE r006_gim1 CURSOR FOR
#         SELECT gim02,gim03 FROM gim_file WHERE gim00 = 'Y'
#        FOREACH r006_gim1 INTO g_gim[g_cnt].*
#          IF SQLCA.sqlcode THEN
#              CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#              EXIT FOREACH
#          END IF
#          LET g_cnt = g_cnt + 1
#          IF g_cnt > g_max_rec THEN
#             CALL cl_err('','9035',0)
#             EXIT FOREACH
#          END IF
#        END FOREACH
#        LET g_cnt = g_cnt - 1
#        FOR i = 1 TO g_cnt
#            PRINT g_gim[i].gim02,g_gim[i].gim03
#        END FOR
#     END IF
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
#END REPORT
#No.FUN-780058---End
 
FUNCTION r006_axh(p_axh05,p_axh06,p_axh07,p_last_y,p_last_m,p_value)   #FUN-780068 mod 09/20
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_last_y    LIKE axh_file.axh06,      #FUN-780068 add 09/20
          p_last_m    LIKE axh_file.axh07,      #FUN-780068 add 09/20
          p_value     LIKE axh_file.axh08,      #No.FUN-680098 DECIMAL(20,6)
          l_type      LIKE type_file.chr1       #No.FUN-680098 VARCHAR(1) 
 
   LET p_value = 0
   LET g_value1= 0    #FUN-780068 add 09/20
 
   #aag06正常餘額型態(1.借餘 2.貸餘)
   SELECT aag06 INTO l_type FROM aag_file 
    WHERE aag01=p_axh05
      AND aag00=tm.b  #No.FUN-740020
 
  #str FUN-780068 mod 09/20
   #本期餘額
   SELECT SUM(axh08-axh09) INTO p_value FROM axh_file
    WHERE axh00=tm.b                           #帳別
      AND axh05=p_axh05                        #科目
      AND axh06=p_axh06                        #年度
     #AND axh07 BETWEEN tm.m1 AND tm.m2        #期別   #FUN-780068 mark 10/18
      AND axh07 BETWEEN 0 AND tm.m2            #期別   #FUN-780068      10/18  #FUN-A90032  #MOD-B40082 mark回復
     #AND axh07 = tm.m2                        #期別   #FUN-A90032                          #MOD-B40082 mark
      AND axh01=tm.axa01                       #族群
      AND axh02=tm.axa02                       #上層公司
      AND axh03=tm.axa03                       #上層帳別
      AND axh13='00'                           #版本   #FUN-780068 add 09/20
 
   #上期餘額
   SELECT SUM(axh08-axh09) INTO g_value1 FROM axh_file
    WHERE axh00=tm.b                           #帳別
      AND axh05=p_axh05                        #科目
      AND axh06=p_last_y                       #年度
     #AND axh07=p_last_m                       #期別   #FUN-780068 mark 10/18
      AND axh07 BETWEEN 0 AND p_last_m         #期別   #FUN-780068      10/18
      AND axh01=tm.axa01                       #族群
      AND axh02=tm.axa02                       #上層公司
      AND axh03=tm.axa03                       #上層帳別
     #AND axh13=g_ver                          #版本   #FUN-780068 add 09/20 #MOD-990209  
 
   IF l_type = '2' THEN
      LET p_value = p_value * -1
      LET g_value1= g_value1* -1
   END IF
 
   #本期異動   =本期餘額 - 上期餘額
   LET p_value = p_value - g_value1
  #end FUN-780068 mod 09/20
 
   RETURN p_value
END FUNCTION
 
FUNCTION r006_axh2(p_axh05,p_axh06,p_axh07)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_axh06     LIKE axh_file.axh06,
          p_axh07     LIKE axh_file.axh07,
          p_value     LIKE axh_file.axh08     #No.FUN-680098  decimal(20,6)
   DEFINE l_type      LIKE type_file.chr1       #No.FUN-680098  VARCHAR(1)
 
   LET p_value = 0
   SELECT aag06 INTO l_type FROM aag_file
    WHERE aag01=p_axh05
      AND aag00=tm.b  #No.FUN-740020
 
  #str FUN-780068 mod 09/20
   SELECT SUM(axh08-axh09) INTO p_value FROM axh_file
    WHERE axh00=tm.b                   #帳別  
      AND axh05=p_axh05                #科目 
      AND axh06=p_axh06                #年度 
      AND axh07<=p_axh07               #期別
      AND axh01=tm.axa01               #族群 
      AND axh02=tm.axa02               #上層公司 
      AND axh03=tm.axa03               #上層帳別 
      AND axh13='00'                   #版本   #FUN-780068 add 09/20
   IF l_type = '2' THEN   #貸餘
      LET p_value = p_value * -1
   END IF
  #end FUN-780068 mod 09/20
 
   IF cl_null(p_value) THEN LET p_value = 0 END IF
 
   RETURN p_value
END FUNCTION
 
#str FUN-780068 add 09/20
FUNCTION r006_axh_dc(p_axh05,p_dc,p_last_y,p_last_m)
   DEFINE p_axh05     LIKE axh_file.axh05,
          p_dc        LIKE type_file.chr1,
          p_last_y    LIKE axh_file.axh06,      #FUN-780068 add 09/20
          p_last_m    LIKE axh_file.axh07,      #FUN-780068 add 09/20
          l_amt       LIKE type_file.num20_6,     #本期餘額
          l_amt1      LIKE type_file.num20_6,     #上期餘額
          p_value     LIKE axh_file.axh08
 
   IF p_dc = '5' THEN   #借方餘額
      #本期借方餘額
      SELECT SUM(axh08) INTO l_amt FROM axh_file
       WHERE axh00=tm.b
         AND axh05=p_axh05
         AND axh06=tm.y1
#        AND axh07 BETWEEN tm.m1 AND tm.m2 #FUN-A90032 mark
         AND axh07 = tm.m2                 #FUN-A90032
         AND axh01=tm.axa01 
         AND axh02=tm.axa02 
         AND axh03=tm.axa03
         AND axh13='00'
      #上期借方餘額
      SELECT SUM(axh08) INTO l_amt1 FROM axh_file
       WHERE axh00=tm.b
         AND axh05=p_axh05
         AND axh06=p_last_y
         AND axh07=p_last_m
         AND axh01=tm.axa01 
         AND axh02=tm.axa02 
         AND axh03=tm.axa03
        #AND axh13=g_ver #MOD-990209   
   END IF
   IF p_dc = '6' THEN   #貸方餘額
      #本期貸方餘額
      SELECT SUM(axh09) INTO l_amt FROM axh_file
       WHERE axh00=tm.b
         AND axh05=p_axh05
         AND axh06=tm.y1
#        AND axh07 BETWEEN tm.m1 AND tm.m2 #FUN-A90032
         AND axh07 = tm.m2                 #FUN-A90032
         AND axh01=tm.axa01 
         AND axh02=tm.axa02 
         AND axh03=tm.axa03
         AND axh13='00'
      #上期貸方餘額
      SELECT SUM(axh09) INTO l_amt1 FROM axh_file
       WHERE axh00=tm.b
         AND axh05=p_axh05
         AND axh06=p_last_y
         AND axh07=p_last_m
         AND axh01=tm.axa01 
         AND axh02=tm.axa02 
         AND axh03=tm.axa03
        #AND axh13=g_ver #MOD-990209   
   END IF
 
   IF cl_null(l_amt)  THEN LET l_amt = 0 END IF
   IF cl_null(l_amt1) THEN LET l_amt1= 0 END IF
 
   #本期異動 = 本期餘額-上期餘額
   LET p_value = l_amt - l_amt1
 
   IF cl_null(p_value) THEN LET p_value = 0 END IF
 
   RETURN p_value
END FUNCTION
#end FUN-780068 add 09/20
 
FUNCTION r006_str(p_amt,p_str)
   DEFINE p_amt  LIKE type_file.num20_6,       #No.FUN-680098  decimal(20,6)
          p_str  LIKE type_file.chr1000,       #No.FUN-680098  VARCHAR(21)
          l_x    LIKE type_file.num5           #No.FUN-680098  smallint
 
   LET p_str = cl_numfor(p_amt*(-1),20,tm.e)
   FOR l_x = 1 TO 20
       IF p_str[l_x,l_x] != ' ' THEN
           LET l_x = l_x - 1
           EXIT FOR
       END IF
   END FOR
   IF l_x != 0 THEN
      LET p_str[l_x,l_x] = '('
   ELSE
      LET p_str[1,1] = '('
   END IF
 
   RETURN p_str
 
END FUNCTION
#Patch....NO.TQC-610035 <001,002> #

#FUN-A90032 --Begin
FUNCTION r006_set_entry()
  CALL cl_set_comp_entry("q1,m2,h1",TRUE)
END FUNCTION

FUNCTION r006_set_no_entry()
   IF tm.axa06 ="1" THEN
      CALL cl_set_comp_entry("q1,h1",FALSE)
   END IF
   IF tm.axa06 ="2" THEN
      CALL cl_set_comp_entry("m2,h1",FALSE)
   END IF
   IF tm.axa06 ="3" THEN
      CALL cl_set_comp_entry("m2,q1",FALSE)
   END IF
   IF tm.axa06 ="4" THEN
      CALL cl_set_comp_entry("q1,m2,h1",FALSE)
   END IF
END FUNCTION
#FUN-A90032 --End
