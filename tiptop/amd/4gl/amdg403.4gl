# Prog. Version..: '5.30.06-13.04.17(00004)'     #
#
# Pattern name...: amdg403.4gl
# Descriptions...: 營業人銷售額與稅額申報書(403)
# Date & Author..: 99/11/02 By Kammy
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: NO.TQC-5B0201 05/12/2222 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.TQC-620014 06/02/27 By Smapmin 報表新增三個欄位:
#                                         ame09 特種稅額計算之應納稅額(104)
#                                         ame10 中途歇業補微應繳稅額(105)
#                                         ame11 中途歇業應退稅額(109)
# Modify.........: No.TQC-630076 06/03/30 By Smapmin 合併稅籍列印
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-5B0141 06/06/28 By rainy 列印銷項格式 37(58)/38(63)
# Modify.........: No.FUN-680074 06/08/25 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710085 07/03/15 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.FUN-860041 08/06/11 By Carol 民國年欄位放大為3位
# Modify.........: No.MOD-920065 09/02/05 By Sarah 調整列印金額(25),(50),(51)
# Modify.........: No.TQC-950109 09/05/26 By baofei 程式做到 EXECUTE insert_prep會產生錯誤
# Modify.........: No.FUN-970101 09/08/07 By hongmei 增加列印26銷售土地金額，27固定資產金額
# Modify.........: No.CHI-8B0031 09/08/10 By hongmei 增加列印格式二(有格線)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-980024 09/10/29 BY yiting ama19產出時，改為ama21(4碼) + ama19(11碼) + ama21(5碼)
# Modify.........: NO.FUN-990034 09/10/29 by Yiting 身份證號碼後四碼以星號呈現
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:FUN-A10039 10/01/20 By jan 程式段中用到amd172 = 'D'或amd172 <> 'D'皆改為amd172 = 'F'或amd172 <> 'F'
# Modify.........: No.CHI-A10008 10/01/29 By chenmoyan 清空g_ame的值
# Modify.........: No.MOD-A30080 10/03/17 By Dido 增加 26/27 資料 
# Modify.........: No.TQC-A40101 10/04/22 By Carrier GP5.2报表追单
# Modify.........: No:MOD-A10172 10/09/29 By sabrina 申報表右上角的註記欄,當申報公司為單一機構時是不需勾選的
# Modify.........: No.MOD-B10117 11/01/17 By Dido 若 l_flag = 'Y' or ' ' 皆須印出稅額合計 
# Modify.........: No.FUN-B40054 11/04/26 By zhangweib 增加列印選項:直接扣抵法-進項稅額分攤明細表(403附表一)
#                                                      增加列印選項:直接扣抵法-購買國外勞務應納營業稅額計算表(403附表二)
# Modify.........: No.FUN-B40087 11/05/23 By yangtt  憑證報表轉GRW 
# Modify.........: No.FUN-C10036 12/01/11 By lujh  FUN-B80050,FUN-BA0021  追單
# Modify.........: No.MOD-D40106 13/04/16 By apo 發票份數改用num20型態

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
         wc          LIKE type_file.chr1000,    #No.FUN-680074 VARCHAR(1000)
         a           LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(1) #TQC-630076
         amd173_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
         amd174_b    LIKE type_file.num10,      #No.FUN-680074 INTEGER
         amd174_e    LIKE type_file.num10,      #No.FUN-680074 INTEGER
         pdate       LIKE type_file.dat,        #No.FUN-680074 DATE
         amd22       LIKE amd_file.amd22,
         deduct      LIKE type_file.chr1,       #FUN-B40054 Add
         rep         LIKE type_file.chr1,       #FUN-B40054 Add
         t           LIKE type_file.chr1,       #列印格式 #CHI-8B0031
         more        LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD,
       g_ama RECORD  LIKE ama_file.*,
       g_ame RECORD  LIKE ame_file.*,
       g_amk RECORD  LIKE amk_file.*,           #FUN-C10036
       l_cnt    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
 
       g_tot7       LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot15      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot19      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot25      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot23      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot24      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot48      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot49      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       l_tot48      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       l_tot49      LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot101     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot107     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot108     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot110     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot111     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot112     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot113     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot114     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_tot115     LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
       g_abx        LIKE type_file.num20_6,       #No.FUN-680074 DECIMAL(20,6)
      #g_inv_all    LIKE type_file.num5,          #MOD-D40106 mark  #No.FUN-680074 SMALLINT
       g_inv_all    LIKE type_file.num20,         #MOD-D40106 
       g_inv1       LIKE type_file.num5,          #No.FUN-680074 SMALLINT
       g_inv2       LIKE type_file.num5,          #No.FUN-680074 SMALLINT
       g_inv3       LIKE type_file.num5,          #No.FUN-680074 SMALLINT
       g_inv4       LIKE type_file.num5           #No.FUN-680074 SMALLINT
DEFINE l_table      STRING                        #No.FUN-710085
DEFINE g_sql        STRING                        #No.FUN-710085
DEFINE g_str        STRING                        #No.FUN-710085
DEFINE g_tot7_26     LIKE type_file.num20_6
DEFINE g_tot15_26    LIKE type_file.num20_6
DEFINE g_tot19_26    LIKE type_file.num20_6
DEFINE g_tot23_26    LIKE type_file.num20_6
DEFINE g_tot24_26    LIKE type_file.num20_6
DEFINE g_tot7_27     LIKE type_file.num20_6
DEFINE g_tot15_27    LIKE type_file.num20_6
DEFINE g_tot19_27    LIKE type_file.num20_6
DEFINE g_tot23_27    LIKE type_file.num20_6
DEFINE g_tot24_27    LIKE type_file.num20_6
DEFINE g_ama19      LIKE ama_file.ama02        #FUN-980024
DEFINE g_ama17      STRING                     #FUN-990034
DEFINE l_length1    LIKE type_file.num5        #FUN-990034
DEFINE l_length2    LIKE type_file.num5        #FUN-990034
 
###GENGRE###START
TYPE sr1_t RECORD
    ama02 LIKE ama_file.ama02,
    ama03 LIKE ama_file.ama03,
    ama05 LIKE ama_file.ama05,
    ama07 LIKE ama_file.ama07,
    ama11 LIKE ama_file.ama11,
    amd173_b LIKE type_file.chr5,
    amd174_b LIKE type_file.chr5,
    amd174_e LIKE type_file.chr5,
    ame06 LIKE ame_file.ame06,
    ame08 LIKE ame_file.ame08,
    ame09 LIKE ame_file.ame09,
    ame10 LIKE ame_file.ame10,
    ame11 LIKE ame_file.ame11,
    a21a LIKE type_file.num10,
    a21b LIKE type_file.num10,
    a22a LIKE type_file.num10,
    a22b LIKE type_file.num10,
    a23a LIKE type_file.num10,
    a23b LIKE type_file.num10,
    a24a LIKE type_file.num10,
    a24b LIKE type_file.num10,
    a25a LIKE type_file.num10,
    a25b LIKE type_file.num10,
    a28a LIKE type_file.num10,
    a28b LIKE type_file.num10,
    a29a LIKE type_file.num10,
    a29b LIKE type_file.num10,
    a311 LIKE amd_file.amd08,
    a321 LIKE amd_file.amd08,
    a331 LIKE amd_file.amd08,
    a341 LIKE amd_file.amd08,
    a351 LIKE amd_file.amd08,
    aa LIKE amd_file.amd08,
    ab LIKE amd_file.amd08,
    b21a LIKE type_file.num10,
    b21b LIKE type_file.num10,
    b22a LIKE type_file.num10,
    b22b LIKE type_file.num10,
    b23a LIKE type_file.num10,
    b23b LIKE type_file.num10,
    b24a LIKE type_file.num10,
    b24b LIKE type_file.num10,
    b25a LIKE type_file.num10,
    b25b LIKE type_file.num10,
    b28a LIKE type_file.num10,
    b28b LIKE type_file.num10,
    b29a LIKE type_file.num10,
    b29b LIKE type_file.num10,
    b311 LIKE amd_file.amd08,
    b321 LIKE amd_file.amd08,
    b331 LIKE amd_file.amd08,
    b341 LIKE amd_file.amd08,
    b351 LIKE amd_file.amd08,
    ba LIKE amd_file.amd08,
    bb LIKE amd_file.amd08,
    c31 LIKE amd_file.amd08,
    c32 LIKE amd_file.amd08,
    c33 LIKE amd_file.amd08,
    c34 LIKE amd_file.amd08,
    c35 LIKE amd_file.amd08,
    c36 LIKE amd_file.amd08,
    c37 LIKE amd_file.amd08,
    c38 LIKE amd_file.amd08,
    inv_all LIKE type_file.num5,
    l75 LIKE amd_file.amd08,
    pdate_1 LIKE type_file.chr5,
    pdate_2 LIKE type_file.chr5,
    pdate_3 LIKE type_file.chr5,
    sum1 LIKE amd_file.amd08,
    sum2 LIKE amd_file.amd08,
    tot101 LIKE type_file.num20_6,
    tot107 LIKE type_file.num20_6,
    tot108 LIKE type_file.num20_6,
    tot11 LIKE type_file.num20_6,
    tot111 LIKE type_file.num20_6,
    tot112 LIKE type_file.num20_6,
    tot113 LIKE type_file.num20_6,
    tot114 LIKE type_file.num20_6,
    tot115 LIKE type_file.num20_6,
    tot12 LIKE type_file.num20_6,
    tot15 LIKE type_file.num20_6,
    tot16 LIKE type_file.num20_6,
    tot17 LIKE type_file.num20_6,
    tot18 LIKE type_file.num20_6,
    tot19 LIKE type_file.num20_6,
    tot23 LIKE type_file.num20_6,
    tot24 LIKE type_file.num20_6,
    tot48 LIKE type_file.num20_6,
    tot49 LIKE type_file.num20_6,
    tot5 LIKE type_file.num20_6,
    tot7_1 LIKE type_file.num20_6,
    tot7_2 LIKE type_file.num20_6,
    ama17 LIKE ama_file.ama17,
    ama18 LIKE ama_file.ama18,
    ama19 LIKE type_file.chr20,
    ama20 LIKE ama_file.ama20,
    ama16 LIKE ama_file.ama16,
    tot26 LIKE type_file.num10,
    tot27 LIKE type_file.num10
END RECORD

TYPE sr2_t RECORD
    ama25 LIKE ama_file.ama25,
    ama26 LIKE ama_file.ama26,
    ama27 LIKE ama_file.ama27,
    ama28 LIKE ama_file.ama28,
    ama29 LIKE ama_file.ama29,
    ama30 LIKE ama_file.ama30,
    ama31 LIKE ama_file.ama31,
    ama32 LIKE ama_file.ama32,
    ama33 LIKE ama_file.ama33,
    ama34 LIKE ama_file.ama34,
    ama35 LIKE ama_file.ama35,
    ama36 LIKE ama_file.ama36,
    ama37 LIKE ama_file.ama37,
    ama38 LIKE ama_file.ama38,
    ama39 LIKE ama_file.ama39,
    ama40 LIKE ama_file.ama40,
    ama41 LIKE ama_file.ama41,
    ama42 LIKE ama_file.ama42,
    ama43 LIKE ama_file.ama43,
    ama44 LIKE ama_file.ama44,
    ama45 LIKE ama_file.ama45,
    ama46 LIKE ama_file.ama46,
    ama47 LIKE ama_file.ama47,
    ama48 LIKE ama_file.ama48,
    ama49 LIKE ama_file.ama49,
    ama50 LIKE ama_file.ama50,
    ama51 LIKE ama_file.ama51,
    ama52 LIKE ama_file.ama52,
    ama53 LIKE ama_file.ama53,
    ama54 LIKE ama_file.ama54,
    ama55 LIKE ama_file.ama55,
    ama56 LIKE ama_file.ama56,
    ama57 LIKE ama_file.ama57,
    ama58 LIKE ama_file.ama58,
    ama59 LIKE ama_file.ama59,
    ama60 LIKE ama_file.ama60,
    ama61 LIKE ama_file.ama61,
    ama62 LIKE ama_file.ama62,
    ama63 LIKE ama_file.ama63,
    ama64 LIKE ama_file.ama64,
    ama65 LIKE ama_file.ama65,
    ama66 LIKE ama_file.ama66,
    ama67 LIKE ama_file.ama67,
    ama68 LIKE ama_file.ama68,
    ama69 LIKE ama_file.ama69,
    ama70 LIKE ama_file.ama70,
    ama71 LIKE ama_file.ama71,
    ama72 LIKE ama_file.ama72,
    ama73 LIKE ama_file.ama73,
    ama74 LIKE ama_file.ama74,
    ama75 LIKE ama_file.ama75,
    ama76 LIKE ama_file.ama76,
    ama77 LIKE ama_file.ama77,
    ama78 LIKE ama_file.ama78,
    ama79 LIKE ama_file.ama79,
    ama80 LIKE ama_file.ama80,
    ama81 LIKE ama_file.ama81,
    ama82 LIKE ama_file.ama82,
    ama83 LIKE ama_file.ama83,
    ama84 LIKE ama_file.ama84,
    ama85 LIKE ama_file.ama85,
    ama86 LIKE ama_file.ama86,
    ama87 LIKE ama_file.ama87,
    ama88 LIKE ama_file.ama88,
    ama89 LIKE ama_file.ama89,
    ama90 LIKE ama_file.ama90,
    ama91 LIKE ama_file.ama91,
    ama92 LIKE ama_file.ama92,
    ama93 LIKE ama_file.ama93,
    ama94 LIKE ama_file.ama94,
    ama95 LIKE ama_file.ama95,
    ama96 LIKE ama_file.ama96,
    ama97 LIKE ama_file.ama97
END RECORD

TYPE sr3_t RECORD
    ama99 LIKE ama_file.ama99,
    ama100 LIKE ama_file.ama100,
    ama101 LIKE ama_file.ama101,
    ama102 LIKE ama_file.ama102,
    ama103 LIKE ama_file.ama103,
    ama104 LIKE ama_file.ama104,
    ama105 LIKE ama_file.ama105
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   LET g_sql = "ama02.ama_file.ama02,ama03.ama_file.ama03,",
               "ama05.ama_file.ama05,ama07.ama_file.ama07,",
               "ama11.ama_file.ama11,amd173_b.type_file.chr5,",     #TQC-950109 
               "amd174_b.type_file.chr5,amd174_e.type_file.chr5,",  #TQC-950109
               "ame06.ame_file.ame06,ame08.ame_file.ame08,",
               "ame09.ame_file.ame09,ame10.ame_file.ame10,",
               "ame11.ame_file.ame11,a21a.type_file.num10,",
               "a21b.type_file.num10,a22a.type_file.num10,",
               "a22b.type_file.num10,a23a.type_file.num10,",
               "a23b.type_file.num10,a24a.type_file.num10,",
               "a24b.type_file.num10,a25a.type_file.num10,",
               "a25b.type_file.num10,a28a.type_file.num10,",
               "a28b.type_file.num10,a29a.type_file.num10,",
               "a29b.type_file.num10,a311.amd_file.amd08,",
               "a321.amd_file.amd08,a331.amd_file.amd08,",
               "a341.amd_file.amd08,a351.amd_file.amd08,",
               "aa.amd_file.amd08,ab.amd_file.amd08,",
               "b21a.type_file.num10,b21b.type_file.num10,",
               "b22a.type_file.num10,b22b.type_file.num10,",
               "b23a.type_file.num10,b23b.type_file.num10,",
               "b24a.type_file.num10,b24b.type_file.num10,",
               "b25a.type_file.num10,b25b.type_file.num10,",
               "b28a.type_file.num10,b28b.type_file.num10,",
               "b29a.type_file.num10,b29b.type_file.num10,",
               "b311.amd_file.amd08,b321.amd_file.amd08,",
               "b331.amd_file.amd08,b341.amd_file.amd08,",
               "b351.amd_file.amd08,ba.amd_file.amd08,",
               "bb.amd_file.amd08,c31.amd_file.amd08,",
               "c32.amd_file.amd08,c33.amd_file.amd08,",
               "c34.amd_file.amd08,c35.amd_file.amd08,c36.amd_file.amd08,",       #MOD-9A0080 add c35
               "c37.amd_file.amd08,c38.amd_file.amd08,",
               "inv_all.type_file.num5,l75.amd_file.amd08,",
               "pdate_1.type_file.chr5,pdate_2.type_file.chr5,",  #TQC-950109   
               "pdate_3.type_file.chr5,sum1.amd_file.amd08,",     #TQC-950109 
               "sum2.amd_file.amd08,tot101.type_file.num20_6,",
               "tot107.type_file.num20_6,tot108.type_file.num20_6,",
               "tot11.type_file.num20_6,tot111.type_file.num20_6,",
               "tot112.type_file.num20_6,tot113.type_file.num20_6,",
               "tot114.type_file.num20_6,tot115.type_file.num20_6,",
               "tot12.type_file.num20_6,tot15.type_file.num20_6,",
               "tot16.type_file.num20_6,tot17.type_file.num20_6,",
               "tot18.type_file.num20_6,tot19.type_file.num20_6,",
               "tot23.type_file.num20_6,tot24.type_file.num20_6,",
               "tot48.type_file.num20_6,tot49.type_file.num20_6,",
               "tot5.type_file.num20_6,tot7_1.type_file.num20_6,",
               "tot7_2.type_file.num20_6,ama17.ama_file.ama17,",  #CHI-8B0031
	       "ama18.ama_file.ama18,ama19.type_file.chr20,",      #FUN-980024
               "ama20.ama_file.ama20,ama16.ama_file.ama16,",      #CHI-8B0031
               "tot26.type_file.num10,tot27.type_file.num10 "     #FUN-970101
 
   LET l_table = cl_prt_temptable('amdg403',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)"     #FUN-970101 #CHI-8B0031   #MOD-9A0080 add ?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF

#FUN-B40087----------mark------str----- 
#  DROP TABLE x
#  CREATE TEMP TABLE x
#       (amd17  LIKE amd_file.amd17,
#        amd171 LIKE amd_file.amd171,
#        amd172 LIKE amd_file.amd172,
#        amd07  LIKE amd_file.amd07,
#        amd08  LIKE amd_file.amd08,
#        amd03  LIKE amd_file.amd03,
#        amd44  LIKE amd_file.amd44)   #FUN-970101
#FUN-B40087----------mark------end-----
 
   IF STATUS THEN CALL cl_err('create',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
 
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.a = ARG_VAL(7)   #TQC-630076
   LET tm.amd173_b = ARG_VAL(8)
   LET tm.amd174_b = ARG_VAL(9)
   LET tm.amd174_e = ARG_VAL(10)
   LET tm.amd22    = ARG_VAL(11)
   LET tm.pdate    = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL g403_tm(0,0)
      ELSE CALL g403()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g403_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680074 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col =23
   ELSE LET p_row = 6 LET p_col =15
   END IF
   OPEN WINDOW g403_w AT p_row,p_col
        WITH FORM "amd/42f/amdg403"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET tm.a = 'N'   #TQC-630076
   LET tm.t = '1'   #CHI-8B0031
   LET tm.deduct = '1'   #FUN-B40054 add
   LET tm.rep = '1'      #FUN-B40054 add
   LET tm.amd173_b=YEAR(g_today)
   LET tm.amd174_b=MONTH(g_today)
   LET tm.amd174_e=MONTH(g_today)
   LET tm.pdate=g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
#     DELETE FROM x      #No.FUN-710085    #FUN-B40087
 
      LET g_tot7   =0
      LET g_tot15  =0
      LET g_tot25  =0
      LET g_tot23  =0
      LET g_tot24  =0
      LET g_tot48  =0
      LET g_tot49  =0
      LET g_tot101 =0
      LET g_tot107 =0
      LET g_tot108 =0
      LET g_tot110 =0
      LET g_tot111 =0
      LET g_tot112 =0
      LET g_tot113 =0
      LET g_tot114 =0
      LET g_tot115 =0
      LET g_inv_all=0
      LET g_inv1  =0
      LET g_inv2  =0
      LET g_inv3  =0
      LET g_inv4  =0
      LET g_tot23_26 = 0
      LET g_tot23_27 = 0
      LET g_tot24_26 = 0
      LET g_tot24_27 = 0
      LET g_tot7_26 = 0
      LET g_tot7_27 = 0
      LET g_tot15_26 = 0
      LET g_tot15_27 = 0
      LET g_tot19_26 = 0
      LET g_tot19_27 = 0
   INPUT BY NAME tm.a,tm.amd22,tm.amd173_b,tm.amd174_b,tm.amd174_e,   #TQC-630076
                #tm.pdate,tm.t,tm.more    #CHI-8B0031     #FUN-B40054 Mark
                 tm.pdate,tm.deduct,tm.rep,tm.t,tm.more    #FUN-B40054 Add              
                 WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_init()
            CALL cl_set_comp_entry("rep,",FALSE)       #FUN-B40054 Add


      ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD a
        CALL g403_set_entry()
        IF tm.a = 'Y' THEN
           CALL g403_set_no_entry()
           LET tm.amd22 = ''
           DISPLAY BY NAME tm.amd22
        END IF
 
      AFTER FIELD amd173_b
         IF cl_null(tm.amd173_b) THEN NEXT FIELD amd173_b END IF
 
      AFTER FIELD amd174_b
         IF cl_null(tm.amd174_b) THEN NEXT FIELD amd174_b END IF
         IF tm.amd174_b > 12 THEN NEXT FIELD amd174_b END IF  #NO.TQC-5B0201
 
      AFTER FIELD amd174_e
         IF cl_null(tm.amd174_e) THEN NEXT FIELD amd174_e END IF
         IF tm.amd174_e > 12 THEN
             NEXT FIELD amd174_e
         END IF
 
      AFTER FIELD amd22
         IF cl_null(tm.amd22) THEN NEXT FIELD amd22 END IF
         SELECT * INTO g_ama.* FROM ama_file where ama01 = tm.amd22
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("sel","ama_file",tm.amd22,"",SQLCA.sqlcode,"","sel ama",1)  #No.FUN-660093
             NEXT FIELD amd22
         END IF
         LET tm.amd173_b = g_ama.ama08
         LET tm.amd174_b = g_ama.ama09 + 1
         IF tm.amd174_b > 12 THEN
             LET tm.amd173_b = tm.amd173_b + 1
             LET tm.amd174_b = tm.amd174_b - 12
         END IF
         LET tm.amd174_e = tm.amd174_b + g_ama.ama10 - 1
         DISPLAY tm.amd173_b TO FORMONLY.amd173_b
         DISPLAY tm.amd174_b TO FORMONLY.amd174_b
         DISPLAY tm.amd174_e TO FORMONLY.amd174_e

         #FUN-C10036--add--str--
         SELECT * INTO g_amk.* FROM amk_file WHERE amk01 = tm.amd22
                                               AND amk02 = tm.amd173_b
                                               AND amk03 = tm.amd174_e
         #FUN-C10036--add--end---
 
         LET g_ama19 = g_ama.ama21 CLIPPED,g_ama.ama19 CLIPPED
         IF NOT cl_null(g_ama.ama22) THEN
             LET g_ama19 = g_ama19,'-',g_ama.ama22 CLIPPED
         END IF
         IF NOT cl_null(g_ama.ama17) THEN
             LET g_ama17 = g_ama.ama17
             LET l_length1 = g_ama17.getLength()
             LET l_length2 = l_length1 - 4
             LET g_ama.ama17 = g_ama17.substring(1,l_length2),'****' CLIPPED
         END IF
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
#FUN-B40054--add-Begin---
      BEFORE FIELD deduct
         CALL cl_set_comp_entry("rep,t",TRUE)

      AFTER FIELD deduct
         IF tm.deduct = '1' THEN
            CALL cl_set_comp_entry("rep",FALSE)
            LET tm.rep = '1'
            DISPLAY BY NAME tm.rep
         ELSE
            CALL cl_set_comp_entry("rep",TRUE)
         END IF

#FUN-B40087   ---start   Add

      AFTER FIELD rep
         IF tm.rep <> '1' THEN
            CALL cl_set_comp_entry("t",FALSE)
         ELSE
            CALL cl_set_comp_entry("t",TRUE)
         END IF
#FUN-B40087   ---start   Add

      #FUN-C10036--Begin--
      AFTER INPUT
         IF NOT cl_null(tm.amd22) AND NOT cl_null(tm.amd173_b)
                                  AND NOT cl_null(tm.amd174_b) THEN
            SELECT * INTO g_amk.* FROM amk_file WHERE amk01 = tm.amd22
                                                  AND amk02 = tm.amd173_b
                                                  AND amk03 = tm.amd174_e
        END IF
     #FUN-C10036---End---
                    
      BEFORE FIELD t									
         IF tm.rep <> '1' THEN
            CALL cl_set_comp_entry("t",FALSE)
         END IF						

#FUN-B40054--add-End-----
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()
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
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g403_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdg403'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdg403','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",   #TQC-630076
                         " '",tm.amd173_b CLIPPED,"'",
                         " '",tm.amd174_b CLIPPED,"'",
                         " '",tm.amd174_e CLIPPED,"'",
                         " '",tm.amd22 CLIPPED,"'",
                         " '",tm.pdate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('amdg403',g_time,l_cmd)
      END IF
      CLOSE WINDOW g403_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
  #CALL g403()    #FUN-B40054 Mark
#FUN-B40054--add--Begin
   IF tm.rep = '1' THEN
      CALL g403()
   END IF
   IF tm.rep = '2' THEN
      CALL g403_2()
   END IF
   IF tm.rep = '3' THEN
      CALL g403_3()
   END IF
#FUN-B40054--add--End
   ERROR ""
END WHILE
   CLOSE WINDOW g403_w
END FUNCTION
 
FUNCTION g403()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680074 VARCHAR(20) # External(Disk) file name
          l_sql     STRING,        # RDSQL STATEMENT        #No.FUN-680074 
          l_chr     LIKE type_file.chr1,          #No.FUN-680074 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680074 VARCHAR(40)
          l_idx     LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_azp03   LIKE azp_file.azp03,
          l_amd25   LIKE amd_file.amd25,
          l_ome21   LIKE oma_file.oma21,   #稅別
          l_dbs     LIKE type_file.chr21,         #No.FUN-680074 VARCHAR(21)
          l_sql1    STRING,                       #No.FUN-680074
          l_ome16   LIKE ome_file.ome16,
          l_oma21   LIKE oma_file.oma21,
          l_oga16   LIKE oga_file.oga16,
          l_oga909  LIKE oga_file.oga909,   #三角貿易出貨否
          l_oea901  LIKE oea_file.oea901,
          l_oma00   LIKE oma_file.oma00,   #帳款性質
          old_oma01 LIKE oma_file.oma01,
          l_amd35   LIKE amd_file.amd35,
          l_amd36   LIKE amd_file.amd36,
          l_amd37   LIKE amd_file.amd37,
          l_amd38   LIKE amd_file.amd38,
          l_amd39   LIKE amd_file.amd39,
          sr               RECORD
                                  amd17  LIKE amd_file.amd17,   #待抵代碼
                                  amd171 LIKE amd_file.amd171,  #格式
                                  amd172 LIKE amd_file.amd172,  #課稅別
                                  amd07  LIKE amd_file.amd07,   #扣抵稅額
                                  amd08  LIKE amd_file.amd08,   #扣抵金額
                                  amd03  LIKE amd_file.amd03,   #發票號碼
                                  amd44  LIKE amd_file.amd44    #銷售固定資產 #FUN-970101
                           END RECORD
 
     DEFINE l_ome35 LIKE ome_file.ome35
     DEFINE l_a311,l_b311,l_a312,l_a313                 LIKE amd_file.amd08
     DEFINE l_a321,l_b321,l_a322,l_a323                 LIKE amd_file.amd08
     DEFINE l_a331,l_b331,l_a332,l_a333                 LIKE amd_file.amd08
     DEFINE l_a341,l_b341,l_a342,l_a343                 LIKE amd_file.amd08
     DEFINE l_a351,l_b351,l_a352,l_a353                 LIKE amd_file.amd08
     DEFINE l_c31,l_c32,l_c33,l_c34                     LIKE amd_file.amd08
     DEFINE l_c35,l_c36,l_c37,l_c38                     LIKE amd_file.amd08
     DEFINE l_a21a,l_a22a,l_a23a,l_a24a,l_a25a,l_a29a   LIKE type_file.num10
     DEFINE l_a21b,l_a22b,l_a23b,l_a24b,l_a25b,l_a29b   LIKE type_file.num10
     DEFINE l_b21a,l_b22a,l_b23a,l_b24a,l_b25a,l_b29a   LIKE type_file.num10
     DEFINE l_b21b,l_b22b,l_b23b,l_b24b,l_b25b,l_b29b   LIKE type_file.num10
     DEFINE l_a28a,l_a28b,l_b28a,l_b28b                 LIKE type_file.num10
     DEFINE l_sum1,l_sum2                               LIKE amd_file.amd08
     DEFINE l_aa,l_ba                                   LIKE amd_file.amd08
     DEFINE l_ab,l_bb                                   LIKE amd_file.amd08
     DEFINE l_68,l_71,l_75                              LIKE amd_file.amd08
     DEFINE l_tot16,l_tot17,l_tot18                     LIKE type_file.num20_6
     DEFINE l_tot11,l_tot12,l_tot7,l_tot5               LIKE type_file.num20_6
     DEFINE l_amd174_b,l_amd174_e,l_pdate_2,l_pdate_3   LIKE type_file.chr2
     DEFINE l_amd173_b,l_pdate_1                        LIKE type_file.chr3
     DEFINE l_flag        LIKE type_file.chr1           #MOD-970063 add
     DEFINE l_ama15       LIKE ama_file.ama15           #MOD-970063 add
     DEFINE sr26    RECORD
                     amd17  LIKE amd_file.amd17,   #待抵代碼
                     amd171 LIKE amd_file.amd171,  #格式
                     amd172 LIKE amd_file.amd172,  #課稅別
                     amd07  LIKE amd_file.amd07,   #扣抵稅額
                     amd08  LIKE amd_file.amd08,   #扣抵金額
                     amd03  LIKE amd_file.amd03,   #發票號碼
                     amd44  LIKE amd_file.amd44    #銷售固定資產
                    END RECORD
     DEFINE sr27    RECORD
                     amd17  LIKE amd_file.amd17,   #待抵代碼
                     amd171 LIKE amd_file.amd171,  #格式
                     amd172 LIKE amd_file.amd172,  #課稅別
                     amd07  LIKE amd_file.amd07,   #扣抵稅額
                     amd08  LIKE amd_file.amd08,   #扣抵金額
                     amd03  LIKE amd_file.amd03,   #發票號碼
                     amd44  LIKE amd_file.amd44    #銷售固定資產
                    END RECORD  
     DEFINE l_tot26,l_tot27         LIKE type_file.num20_6
     DEFINE l_tot7_26,l_tot7_27     LIKE type_file.num20_6 
     DEFINE l_tot5_26,l_tot5_27     LIKE type_file.num20_6
     DEFINE l_sum1_26,l_sum1_27     LIKE amd_file.amd08                           
     DEFINE l_a311_26,l_a311_27     LIKE amd_file.amd08
     DEFINE l_a321_26,l_a321_27     LIKE amd_file.amd08
     DEFINE l_a331_26,l_a331_27     LIKE amd_file.amd08
     DEFINE l_a341_26,l_a341_27     LIKE amd_file.amd08
     DEFINE l_a351_26,l_a351_27     LIKE amd_file.amd08
     DEFINE l_c31_26,l_c32_26       LIKE amd_file.amd08
     DEFINE l_c33_26,l_c34_26       LIKE amd_file.amd08
     DEFINE l_c35_26,l_c36_26       LIKE amd_file.amd08
     DEFINE l_c37_26,l_c38_26       LIKE amd_file.amd08
     DEFINE l_c31_27,l_c32_27       LIKE amd_file.amd08
     DEFINE l_c33_27,l_c34_27       LIKE amd_file.amd08
     DEFINE l_c35_27,l_c36_27       LIKE amd_file.amd08
     DEFINE l_c37_27,l_c38_27       LIKE amd_file.amd08
     DEFINE l_amd35_26,l_amd35_27   LIKE amd_file.amd35
     DEFINE l_amd36_26,l_amd36_27   LIKE amd_file.amd36
     DEFINE l_amd37_26,l_amd37_27   LIKE amd_file.amd37
     DEFINE l_amd38_26,l_amd38_27   LIKE amd_file.amd38
     DEFINE l_amd39_26,l_amd39_27   LIKE amd_file.amd39
     DEFINE l_amd25_26,l_amd25_27   LIKE amd_file.amd25
     DEFINE l_sql26,l_sql27         STRING
 
     CALL cl_del_data(l_table)
     INITIALIZE g_ame.* TO NULL    #CHI-A10008
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #str MOD-970063 add
     LET g_str = ''
    #注记栏(总机构汇总报缴l_flag='Y'/分单位分别申报l_flag='N')
     LET l_flag = 'N'
     IF tm.a = 'Y' THEN
        LET l_flag='Y'
     ELSE
        LET l_ama15 = ''
        SELECT ama15 INTO l_ama15 FROM ama_file WHERE ama01=tm.amd22
        IF cl_null(l_ama15) THEN LET l_ama15='0' END IF
       #MOD-A10172---modify---start---
       #IF l_ama15 = '0' OR l_ama15 = '1' THEN
       #   LET l_flag = 'Y'
       #END IF
        IF l_ama15 = '0' THEN
           LET l_flag = ' '
        END IF
        IF l_ama15 = '1' THEN
           LET l_flag = 'Y' 
        END IF
       #MOD-A10172---modify---end---
     END IF
     LET g_str = l_flag
    #end MOD-970063 add

     #-->進銷項
     LET l_sql = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,'',amd25, ", #FUN-970101 add ''
               "  amd35,amd36,amd37,amd38,amd39 ",
               " FROM amd_file ",
               " WHERE amd173='",tm.amd173_b,"'",
               "   AND (amd174 BETWEEN ",tm.amd174_b," AND ",tm.amd174_e,")",
               "  AND amd172<>'F' AND amd30='Y' "     #不含作廢資料,要已確認資料no:7393 #FUN-A10039
     IF tm.a <> 'Y' THEN
        LET l_sql = l_sql,"   AND amd22 ='",tm.amd22,"'"
     END IF
 
     PREPARE g403_prepare  FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
     DECLARE g403_curs CURSOR FOR g403_prepare
 
    #媒體申報其他資料
     IF tm.a <> 'Y' THEN   #TQC-630076
        SELECT ame01,ame02,ame03,sum(ame04),sum(ame05),sum(ame06),
               #sum(ame07),sum(ame08)   #TQC-620014
               sum(ame07),sum(ame08),'','','','','',   #TQC-620014
               sum(ame09),sum(ame10),sum(ame11)   #TQC-620014
               INTO g_ame.* FROM ame_file
           WHERE ame01=tm.amd22 AND  ame02 = tm.amd173_b
               AND ame03  BETWEEN tm.amd174_b AND tm.amd174_e
           GROUP BY ame01,ame02,ame03
     ELSE
        SELECT ame01,ame02,ame03,sum(ame04),sum(ame05),sum(ame06),
               #sum(ame07),sum(ame08)   #TQC-620014
               sum(ame07),sum(ame08),'','','','','',   #TQC-620014
               sum(ame09),sum(ame10),sum(ame11)   #TQC-620014
               INTO g_ame.* FROM ame_file
           WHERE ame02 = tm.amd173_b
               AND ame03  BETWEEN tm.amd174_b AND tm.amd174_e
           GROUP BY ame01,ame02,ame03
     END IF
     IF SQLCA.SQLCODE THEN 
        CALL cl_err3("sel","ame_file",tm.amd173_b,"",STATUS,"","sel ame",0)   #No.FUN-660093
     END IF
 
     IF cl_null(g_ame.ame04) THEN LET g_ame.ame04 = 0 END IF
     IF cl_null(g_ame.ame05) THEN LET g_ame.ame05 = 0 END IF
     IF cl_null(g_ame.ame06) THEN LET g_ame.ame06 = 0 END IF
     IF cl_null(g_ame.ame07) THEN LET g_ame.ame07 = 0 END IF
     IF cl_null(g_ame.ame08) THEN LET g_ame.ame08 = 0 END IF
     IF cl_null(g_ame.ame09) THEN LET g_ame.ame09 = 0 END IF   #TQC-620014
     IF cl_null(g_ame.ame10) THEN LET g_ame.ame10 = 0 END IF   #TQC-620014
     IF cl_null(g_ame.ame11) THEN LET g_ame.ame11 = 0 END IF   #TQC-620014
 
     LET g_tot7 = 0
     LET g_tot15 = 0
     LET g_tot19 = 0
     LET g_abx =0   #保稅
     CALL g403_sum1()  #計算發票數
     FOREACH g403_curs INTO sr.*,l_amd25,l_amd35,l_amd36,l_amd37,
                            l_amd38,l_amd39
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(sr.amd07) THEN LET sr.amd07=0 END IF
          IF cl_null(sr.amd08) THEN LET sr.amd08=0 END IF
         #原本依稅別判斷, 改用依amd欄位
         ## 零稅率銷售額
         IF sr.amd171 MATCHES '3*' AND sr.amd172='2'
              AND sr.amd171<>'33'AND  sr.amd171<>'34' THEN
            #經海關證明文件is not null 則為經海關
            IF NOT cl_null(l_amd38) OR NOT cl_null(l_amd39) THEN
               #g_tot15:經海關出口免附證明文件者
               LET g_tot15 = g_tot15 + sr.amd08
            ELSE
               #g_tot7:不經海關出口應附證明文件者
               LET g_tot7 = g_tot7 + sr.amd08
            END IF
          END IF
          #計算免稅金額
          IF sr.amd171 MATCHES '3*' AND sr.amd172='3'  THEN
             LET g_abx = g_abx + sr.amd08
          END IF
          #g_tot19:零稅率之退回及折讓
          IF (sr.amd171='33' OR sr.amd171='34')  AND sr.amd172='2'  THEN
             LET g_tot19 = g_tot19 + sr.amd08
          END IF
 
#         INSERT INTO x VALUES(sr.*)       #No.FUN-710085  #FUN-B40087
 
     END FOREACH
 
#FUN-B40087----------mark------str----
      #-->銷項項目
     SELECT SUM(amd08) INTO l_a311 FROM x WHERE amd171='31' AND amd172='1'
     SELECT SUM(amd07) INTO l_b311 FROM x WHERE amd171='31' AND amd172='1'
 
     SELECT SUM(amd08) INTO l_a321 FROM x WHERE amd171='32' AND amd172='1'
     SELECT SUM(amd07) INTO l_b321 FROM x WHERE amd171='32' AND amd172='1'
 
     SELECT SUM(amd08) INTO l_a331 FROM x WHERE amd171='33' AND amd172='1'
     SELECT SUM(amd07) INTO l_b331 FROM x WHERE amd171='33' AND amd172='1'
 
     SELECT SUM(amd08) INTO l_a341 FROM x WHERE amd171='34' AND amd172='1'
     SELECT SUM(amd07) INTO l_b341 FROM x WHERE amd171='34' AND amd172='1'
 
     SELECT SUM(amd08) INTO l_a351 FROM x WHERE amd171='35' AND amd172='1'
     SELECT SUM(amd07) INTO l_b351 FROM x WHERE amd171='35' AND amd172='1'
 
     #-->免稅銷售額
     SELECT SUM(amd08) INTO l_c31 FROM x WHERE amd171='31' AND amd172='3'
     SELECT SUM(amd08) INTO l_c32 FROM x WHERE amd171='32' AND amd172='3'
     SELECT SUM(amd08) INTO l_c33 FROM x WHERE amd171='33' AND amd172='3'
     SELECT SUM(amd08) INTO l_c34 FROM x WHERE amd171='34' AND amd172='3'
     SELECT SUM(amd08) INTO l_c35 FROM x WHERE amd171='35' AND amd172='3'
     SELECT SUM(amd08) INTO l_c36 FROM x WHERE amd171='36' AND amd172='3'
     SELECT SUM(amd08) INTO l_c37 FROM x WHERE amd171='37' AND amd172='3'
     SELECT SUM(amd08) INTO l_c38 FROM x WHERE amd171='38' AND amd172='3'
 
     #-->進項項目
    #SELECT SUM(amd08) INTO l_a21a FROM x WHERE amd171='21' AND amd17 ='1'            #MOD-A30080 mark
     SELECT SUM(amd08) INTO l_a21a FROM x WHERE amd171 IN ('21','26') AND amd17 ='1'  #MOD-A30080
                                            AND amd172='1'
    #SELECT SUM(amd08) INTO l_b21a FROM x WHERE amd171='21' AND amd17 ='2'            #MOD-A30080 mark
     SELECT SUM(amd08) INTO l_b21a FROM x WHERE amd171 IN ('21','26') AND amd17 ='2'  #MOD-A30080
                                            AND amd172='1'
    #SELECT SUM(amd08) INTO l_a22a FROM x WHERE amd171='22' AND amd17 ='1'            #MOD-A30080 mark
     SELECT SUM(amd08) INTO l_a22a FROM x WHERE amd171 IN ('22','27') AND amd17 ='1'  #MOD-A30080
                                            AND amd172='1'
    #SELECT SUM(amd08) INTO l_b22a FROM x WHERE amd171='22' AND amd17 ='2'            #MOD-A30080 mark
     SELECT SUM(amd08) INTO l_b22a FROM x WHERE amd171 IN ('22','27') AND amd17 ='2'  #MOD-A30080
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_a23a FROM x WHERE amd171='23' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_b23a FROM x WHERE amd171='23' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_a24a FROM x WHERE amd171='24' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_b24a FROM x WHERE amd171='24' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_a25a FROM x WHERE amd171='25' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_b25a FROM x WHERE amd171='25' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_a28a FROM x WHERE amd171='28' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_b28a FROM x WHERE amd171='28' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_a29a FROM x WHERE amd171='29' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd08) INTO l_b29a FROM x WHERE amd171='29' AND amd17 ='2'
                                            AND amd172='1'
 
    #SELECT SUM(amd07) INTO l_a21b FROM x WHERE amd171='21' AND amd17 ='1'             #MOD-A30080 mark
     SELECT SUM(amd07) INTO l_a21b FROM x WHERE amd171 IN ('21','26') AND amd17 ='1'   #MOD-A30080
                                            AND amd172='1'
    #SELECT SUM(amd07) INTO l_b21b FROM x WHERE amd171='21' AND amd17 ='2'             #MOD-A30080 mark
     SELECT SUM(amd07) INTO l_b21b FROM x WHERE amd171 IN ('21','26') AND amd17 ='2'   #MOD-A30080
                                            AND amd172='1'
    #SELECT SUM(amd07) INTO l_a22b FROM x WHERE amd171='22' AND amd17 ='1'             #MOD-A30080 mark
     SELECT SUM(amd07) INTO l_a22b FROM x WHERE amd171 IN ('22','27') AND amd17 ='1'   #MOD-A30080
                                            AND amd172='1'
    #SELECT SUM(amd07) INTO l_b22b FROM x WHERE amd171='22' AND amd17 ='2'             #MOD-A30080 mark
     SELECT SUM(amd07) INTO l_b22b FROM x WHERE amd171 IN ('22','27') AND amd17 ='2'   #MOD-A30080
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_a23b FROM x WHERE amd171='23' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_b23b FROM x WHERE amd171='23' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_a24b FROM x WHERE amd171='24' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_b24b FROM x WHERE amd171='24' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_a25b FROM x WHERE amd171='25' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_b25b FROM x WHERE amd171='25' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_a28b FROM x WHERE amd171='28' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_b28b FROM x WHERE amd171='28' AND amd17 ='2'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_a29b FROM x WHERE amd171='29' AND amd17 ='1'
                                            AND amd172='1'
     SELECT SUM(amd07) INTO l_b29b FROM x WHERE amd171='29' AND amd17 ='2'
                                            AND amd172='1'
 
     #讀取進項免稅/零稅之金額
     SELECT SUM(amd08) INTO g_tot48 FROM x WHERE amd171 MATCHES '2*'
                                             AND amd171<>'23' AND amd171<>'24'
                                             AND amd17='1' AND amd172<>'1'
     IF cl_null(g_tot48) THEN LET g_tot48=0 END IF   #MOD-920065 add
     SELECT SUM(amd07+amd08) INTO g_tot49 FROM x WHERE amd171 MATCHES '2*'
                                                   AND amd171<>'23' AND amd171<>'24'
                                                   AND amd17='2' AND amd172<>'1'
     IF cl_null(g_tot49) THEN LET g_tot49=0 END IF   #MOD-920065 add
     #讀取零稅率折讓金額
     LET l_tot48=0  LET l_tot49=0
     SELECT SUM(amd08) INTO l_tot48 FROM x WHERE (amd171='23' OR amd171='24')
                                             AND  amd17='1' AND amd172<>'1'
     IF cl_null(l_tot48) THEN LET l_tot48=0 END IF
     SELECT SUM(amd08) INTO l_tot49 FROM x WHERE (amd171='23' OR amd171='24')
                                             AND  amd17='2' AND amd172<>'1'
     IF cl_null(l_tot49) THEN LET l_tot49=0 END IF
     LET g_tot48 = g_tot48 - l_tot48
     LET g_tot49 = g_tot49 - l_tot49
 
 
     IF cl_null(l_tot5)  THEN LET l_tot5 = 0 END IF  #FUN-5B0141
     IF cl_null(l_tot7)  THEN LET l_tot7 = 0 END IF
     IF cl_null(l_tot11) THEN LET l_tot11 = 0 END IF
     IF cl_null(l_tot12) THEN LET l_tot12 = 0 END IF
     IF cl_null(l_tot16) THEN LET l_tot16 = 0 END IF
     IF cl_null(l_tot17) THEN LET l_tot17 = 0 END IF
     IF cl_null(l_tot18) THEN LET l_tot18 = 0 END IF
 
     IF cl_null(l_68) THEN LET l_68 = 0 END IF
     IF cl_null(l_71) THEN LET l_71 = 0 END IF
     IF cl_null(l_75) THEN LET l_75 = 0 END IF
 
     IF cl_null(g_tot48) THEN LET g_tot48 = 0 END IF
     IF cl_null(g_tot49) THEN LET g_tot49 = 0 END IF
     IF cl_null(l_a311) THEN LET l_a311=0 END IF
     IF cl_null(l_b311) THEN LET l_b311=0 END IF
     IF cl_null(l_a321) THEN LET l_a321=0 END IF
     IF cl_null(l_b321) THEN LET l_b321=0 END IF
     IF cl_null(l_a331) THEN LET l_a331=0 END IF
     IF cl_null(l_b331) THEN LET l_b331=0 END IF
     IF cl_null(l_a341) THEN LET l_a341=0 END IF
     IF cl_null(l_b341) THEN LET l_b341=0 END IF
     IF cl_null(l_a351) THEN LET l_a351=0 END IF
     IF cl_null(l_b351) THEN LET l_b351=0 END IF
 
     IF cl_null(l_c31) THEN LET l_c31 = 0 END IF
     IF cl_null(l_c32) THEN LET l_c32 = 0 END IF
     IF cl_null(l_c33) THEN LET l_c33 = 0 END IF
     IF cl_null(l_c34) THEN LET l_c34 = 0 END IF
     IF cl_null(l_c35) THEN LET l_c35 = 0 END IF
     IF cl_null(l_c36) THEN LET l_c36 = 0 END IF
     IF cl_null(l_c37) THEN LET l_c37 = 0 END IF
     IF cl_null(l_c38) THEN LET l_c38 = 0 END IF
     IF cl_null(l_a21a) THEN LET l_a21a=0 END IF
     IF cl_null(l_b21a) THEN LET l_b21a=0 END IF
     IF cl_null(l_a22a) THEN LET l_a22a=0 END IF
     IF cl_null(l_b22a) THEN LET l_b22a=0 END IF
     IF cl_null(l_a23a) THEN LET l_a23a=0 END IF
     IF cl_null(l_b23a) THEN LET l_b23a=0 END IF
     IF cl_null(l_a24a) THEN LET l_a24a=0 END IF
     IF cl_null(l_b24a) THEN LET l_b24a=0 END IF
     IF cl_null(l_a25a) THEN LET l_a25a=0 END IF
     IF cl_null(l_b25a) THEN LET l_b25a=0 END IF
     IF cl_null(l_a21b) THEN LET l_a21b=0 END IF
     IF cl_null(l_a28a) THEN LET l_a28a=0 END IF
     IF cl_null(l_b28a) THEN LET l_b28a=0 END IF
     IF cl_null(l_a29a) THEN LET l_a29a=0 END IF
     IF cl_null(l_b29a) THEN LET l_b29a=0 END IF
     IF cl_null(l_b21b) THEN LET l_b21b=0 END IF
     IF cl_null(l_a22b) THEN LET l_a22b=0 END IF
     IF cl_null(l_b22b) THEN LET l_b22b=0 END IF
     IF cl_null(l_a23b) THEN LET l_a23b=0 END IF
     IF cl_null(l_b23b) THEN LET l_b23b=0 END IF
     IF cl_null(l_a24b) THEN LET l_a24b=0 END IF
     IF cl_null(l_b24b) THEN LET l_b24b=0 END IF
     IF cl_null(l_a25b) THEN LET l_a25b=0 END IF
     IF cl_null(l_b25b) THEN LET l_b25b=0 END IF
     IF cl_null(l_a28b) THEN LET l_a28b=0 END IF
     IF cl_null(l_b28b) THEN LET l_b28b=0 END IF
     IF cl_null(l_a29b) THEN LET l_a29b=0 END IF
     IF cl_null(l_b29b) THEN LET l_b29b=0 END IF
     #合計
     LET l_sum1=l_a311+l_a321-l_a331-l_a341+l_a351
     LET l_sum2=l_b311+l_b321-l_b331-l_b341+l_b351
 
     LET g_tot24=l_c31+l_c32-l_c33-l_c34+l_c35+l_c36
 
     LET l_aa = l_a21a+l_a22a-l_a23a-l_a24a-l_a29a+l_a25a+l_a28a
     LET l_ab = l_a21b+l_a22b-l_a23b-l_a24b-l_a29b+l_a25b+l_a28b
     LET l_ba = l_b21a+l_b22a-l_b23a-l_b24a-l_b29a+l_b25a+l_b28a
     LET l_bb = l_b21b+l_b22b-l_b23b-l_b24b-l_b29b+l_b25b+l_b28b
 
     LET g_tot23 = g_tot7 + g_tot15 - g_tot19
     LET g_tot48 = g_tot48 + l_aa
     LET g_tot49 = g_tot49 + l_ba

     #No.TQC-A40101  --Begin
     #LET g_tot101 = l_sum2
     #LET g_tot107 = l_ab+l_bb
     #LET g_tot108 = g_ame.ame07
     #LET g_tot110 = g_tot107 + g_tot108
     #LET g_tot111 = g_tot101 - g_tot110
     #IF g_tot111 <0 THEN LET g_tot111=0 END IF
     #LET g_tot112 = g_tot110 - g_tot101
     #IF g_tot112 <0 THEN LET g_tot112=0 END IF
     #LET g_tot113 = g_tot23 * 0.05 + l_bb
     #IF g_tot112 > g_tot113 THEN
     #   LET g_tot114 = g_tot113
     #ELSE
     #   LET g_tot114 = g_tot112
     #END IF
     #LET g_tot115 = g_tot112 - g_tot114
     #No.TQC-A40101  --End  
 
      #特種稅額合計(65)
      IF cl_null(l_c37) THEN LET l_c37=0 END IF
      IF cl_null(l_c38) THEN LET l_c38=0 END IF
      LET l_tot5 = l_c37 - l_c38
 
      #銷售額總計(25)
      IF cl_null(l_sum1) THEN LET l_sum1=0 END IF
      LET l_tot7 = l_sum1 + g_tot23 + g_tot24 + l_tot5  #FUN-5B0141
 
      #不得扣抵比例(50)
      LET l_tot11 = (g_tot24 + l_tot5) / l_tot7         #FUN-5B1041
#     LET l_tot11 = cl_digcut(l_tot11,2)                #MOD-920065 add  #FUN-B40087
      LET l_tot11 = s_trunc(l_tot11,2)                  #FUN-B40087
 
      #得扣抵之進項稅額
     #LET l_tot12 = (l_ab + l_bb) * (1 - l_tot11)       #FUN-B40054 Mark
#FUN-B40054--add-Begin--
      IF tm.deduct = '1' THEN
          LET l_tot12 = (l_ab + l_bb) * (1 - l_tot11)
      ELSE
          #LET l_tot12 = g_ama.ama97   #FUN-C10036  mark
          LET l_tot12 = g_amk.amk76    #FUN-C10036  add
      END IF
#FUN-B40054--add-End----
 
      #應比例計算之進項稅額
      LET l_68 = g_ame.ame04 * 0.05
      LET l_71 = g_ame.ame05 * 0.05
      LET l_75 = g_ame.ame06 * 0.05
 
      #應納稅額
      LET l_tot16 = l_68 * l_tot11
      LET l_tot17 = l_71 * l_tot11
     #LET l_tot18 = l_75 * l_tot11       #FUN-B40054 Mark
#FUN-B40054--add-Begin--
      IF  tm.deduct = '1' THEN
          LET l_tot18 = l_75 * l_tot11
      ELSE
          LET l_tot18 = g_ama.ama103
      END IF
#FUN-B40054--add-End----

    #IF l_flag ='Y' THEN   #MOD-970063    #MOD-B10117 mark           
     IF l_flag ='Y' OR l_flag =' ' THEN   #MOD-B10117
       #str MOD-970063 mod
       #將下面變數計算移到MOD-920065後
        LET g_tot101 = l_sum2
       #LET g_tot107 = l_ab+l_bb   #MOD-970063 mark
        LET g_tot107 = l_tot12     #MOD-970063
        LET g_tot108 = g_ame.ame07
        LET g_tot110 = g_tot107 + g_tot108
        LET g_tot111 = g_tot101 - g_tot110
        IF g_tot111 <0 THEN LET g_tot111=0 END IF
        LET g_tot112 = g_tot110 - g_tot101
        IF g_tot112 <0 THEN LET g_tot112=0 END IF
        LET g_tot113 = g_tot23 * 0.05 + l_bb
        IF g_tot112 > g_tot113 THEN
           LET g_tot114 = g_tot113
        ELSE
           LET g_tot114 = g_tot112
        END IF
        LET g_tot115 = g_tot112 - g_tot114
       #end MOD-970063 mod
    #str MOD-970063 add
     ELSE
        LET g_tot101 =0
        LET g_tot107 =0
        LET g_tot108 =0
        LET g_tot110 =0
        LET g_tot111 =0
        LET g_tot112 =0
        LET g_tot113 =0
        LET g_tot114 =0
        LET g_tot115 =0
        LET l_tot17  =0
        LET l_tot18  =0
        LET g_ame.ame09=0
        LET g_ame.ame10=0
        LET g_ame.ame11=0
     END IF
    #end MOD-970063 add
 
     LET l_amd173_b = (tm.amd173_b - 1911)    USING "&&&"
     LET l_amd174_b = tm.amd174_b
     LET l_amd174_e = tm.amd174_e
     LET l_pdate_1  = (YEAR(tm.pdate)-1911)  USING "&&&"
     LET l_pdate_2  = MONTH(tm.pdate)
     LET l_pdate_3  = DAY(tm.pdate)
     LET l_tot11 = l_tot11 * 100    #MOD-920065 add
 
     #計算土地金額
     #-->進銷項
     LET l_sql26 = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,amd44,amd25, ",
                   "       amd35,amd36,amd37,amd38,amd39 ",
                   "  FROM amd_file ",
                   " WHERE amd173='",tm.amd173_b,"'",
                   "   AND (amd174 BETWEEN ",tm.amd174_b," AND ",tm.amd174_e,")",
                   "   AND amd172<>'F' AND amd30='Y' ",     #不含作廢資料,要已確認資料 #FUN-A10039
                   "   AND amd44='1' "  #土地
     IF tm.a <> 'Y' THEN
        LET l_sql26 = l_sql26,"   AND amd22 ='",tm.amd22,"'"
     END IF
 
     PREPARE g403_pre_26  FROM l_sql26
     IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
     DECLARE g403_curs_26 CURSOR FOR g403_pre_26
 
     LET g_tot7_26 = 0
     LET g_tot15_26  = 0
     LET g_tot19_26  = 0
 
     FOREACH g403_curs_26 INTO sr26.*,l_amd25_26,l_amd35_26,l_amd36_26,
                               l_amd37_26,l_amd38_26,l_amd39_26
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(sr26.amd07) THEN LET sr26.amd07=0 END IF
          IF cl_null(sr26.amd08) THEN LET sr26.amd08=0 END IF
         ## 零稅率銷售額
         IF sr26.amd171 MATCHES '3*' AND sr26.amd172='2'
              AND sr26.amd171<>'33'AND  sr26.amd171<>'34' THEN
            #經海關證明文件is not null 則為經海關
            IF NOT cl_null(l_amd38_26) OR NOT cl_null(l_amd39_26) THEN
               #g_tot15:經海關出口免附證明文件者
               LET g_tot15_26 = g_tot15_26 + sr26.amd08
            ELSE
               #g_tot7:不經海關出口應附證明文件者
               LET g_tot7_26 = g_tot7_26 + sr26.amd08
            END IF
         END IF
          #g_tot19:零稅率之退回及折讓
          IF (sr26.amd171='33' OR sr26.amd171='34')  AND sr26.amd172='2'  THEN
             LET g_tot19_26 = g_tot19_26 + sr26.amd08
          END IF
 
          INSERT INTO x VALUES(sr26.*)    #FUN-B40087 
 
     END FOREACH
 
 
#FUN-B40087----------mark------end-----
#FUN-B40087----------mark------str-----
     #-->銷項項目
     SELECT SUM(amd08) INTO l_a311_26 FROM x WHERE amd171='31' AND amd172='1' AND amd44='1'
     SELECT SUM(amd08) INTO l_a321_26 FROM x WHERE amd171='32' AND amd172='1' AND amd44='1'
     SELECT SUM(amd08) INTO l_a331_26 FROM x WHERE amd171='33' AND amd172='1' AND amd44='1'
     SELECT SUM(amd08) INTO l_a341_26 FROM x WHERE amd171='34' AND amd172='1' AND amd44='1'
     SELECT SUM(amd08) INTO l_a351_26 FROM x WHERE amd171='35' AND amd172='1' AND amd44='1'
 
     #-->免稅銷售額
     SELECT SUM(amd08) INTO l_c31_26 FROM x WHERE amd171='31' AND amd172='3' AND amd44='1'
     SELECT SUM(amd08) INTO l_c32_26 FROM x WHERE amd171='32' AND amd172='3' AND amd44='1'
     SELECT SUM(amd08) INTO l_c33_26 FROM x WHERE amd171='33' AND amd172='3' AND amd44='1'
     SELECT SUM(amd08) INTO l_c34_26 FROM x WHERE amd171='34' AND amd172='3' AND amd44='1'
     SELECT SUM(amd08) INTO l_c35_26 FROM x WHERE amd171='35' AND amd172='3' AND amd44='1'
     SELECT SUM(amd08) INTO l_c36_26 FROM x WHERE amd171='36' AND amd172='3' AND amd44='1'
     SELECT SUM(amd08) INTO l_c37_26 FROM x WHERE amd171='37' AND amd172='3' AND amd44='1'
     SELECT SUM(amd08) INTO l_c38_26 FROM x WHERE amd171='38' AND amd172='3' AND amd44='1'
 
     IF cl_null(l_tot5_26)  THEN LET l_tot5_26 = 0 END IF  
     IF cl_null(l_tot7_26)  THEN LET l_tot7_26 = 0 END IF
 
     IF cl_null(l_a311_26) THEN LET l_a311_26=0 END IF
     IF cl_null(l_a321_26) THEN LET l_a321_26=0 END IF
     IF cl_null(l_a331_26) THEN LET l_a331_26=0 END IF
     IF cl_null(l_a341_26) THEN LET l_a341_26=0 END IF
     IF cl_null(l_a351_26) THEN LET l_a351_26=0 END IF
 
     IF cl_null(l_c31_26) THEN LET l_c31_26 = 0 END IF
     IF cl_null(l_c32_26) THEN LET l_c32_26 = 0 END IF
     IF cl_null(l_c33_26) THEN LET l_c33_26 = 0 END IF
     IF cl_null(l_c34_26) THEN LET l_c34_26 = 0 END IF
     IF cl_null(l_c35_26) THEN LET l_c35_26 = 0 END IF
     IF cl_null(l_c36_26) THEN LET l_c36_26 = 0 END IF
     IF cl_null(l_c37_26) THEN LET l_c37_26 = 0 END IF
     IF cl_null(l_c38_26) THEN LET l_c38_26 = 0 END IF
 
     #合計
     LET l_sum1_26=l_a311_26+l_a321_26-l_a331_26-l_a341_26+l_a351_26
     LET g_tot24_26=l_c31_26+l_c32_26-l_c33_26-l_c34_26+l_c35_26+l_c36_26
     LET g_tot23_26 = g_tot7_26 + g_tot15_26 - g_tot19_26
 
      #特種稅額合計(65)
      IF cl_null(l_c37_26) THEN LET l_c37_26=0 END IF
      IF cl_null(l_c38_26) THEN LET l_c38_26=0 END IF
      LET l_tot5_26 = l_c37_26 - l_c38_26
 
      #銷售額總計(25)
      IF cl_null(l_sum1_26) THEN LET l_sum1_26=0 END IF
      LET l_tot26 = l_sum1_26 + g_tot23_26 + g_tot24_26 + l_tot5_26
     
     #計算固定資產金額 
     #-->進銷項
     LET l_sql27 = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,amd44,amd25, ",
                   "       amd35,amd36,amd37,amd38,amd39 ",
                   "  FROM amd_file ",
                   " WHERE amd173='",tm.amd173_b,"'",
                   "   AND (amd174 BETWEEN ",tm.amd174_b," AND ",tm.amd174_e,")",
                   "   AND amd172<>'F' AND amd30='Y' ",     #不含作廢資料,要已確認資料 #FUN-A10039
                   "   AND amd44='2' "   #固定資產
     IF tm.a <> 'Y' THEN
        LET l_sql27 = l_sql27,"   AND amd22 ='",tm.amd22,"'"
     END IF
 
     PREPARE g403_pre_27  FROM l_sql27
     IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
     DECLARE g403_curs_27 CURSOR FOR g403_pre_27
 
     LET g_tot7_27 = 0
     LET g_tot15_27  = 0
     LET g_tot19_27  = 0
 
     FOREACH g403_curs_27 INTO sr27.*,l_amd25_27,l_amd35_27,l_amd36_27,
                               l_amd37_27,l_amd38_27,l_amd39_27
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
          IF cl_null(sr27.amd07) THEN LET sr27.amd07=0 END IF
          IF cl_null(sr27.amd08) THEN LET sr27.amd08=0 END IF
         ## 零稅率銷售額
         IF sr27.amd171 MATCHES '3*' AND sr27.amd172='2'
              AND sr27.amd171<>'33'AND  sr27.amd171<>'34' THEN
            #經海關證明文件is not null 則為經海關
            IF NOT cl_null(l_amd38_27) OR NOT cl_null(l_amd39_27) THEN
               #g_tot15:經海關出口免附證明文件者
               LET g_tot15_27 = g_tot15_27 + sr27.amd08
            ELSE
               #g_tot7:不經海關出口應附證明文件者
               LET g_tot7_27 = g_tot7_27 + sr27.amd08
            END IF
          END IF
          #g_tot19:零稅率之退回及折讓
          IF (sr27.amd171='33' OR sr27.amd171='34')  AND sr27.amd172='2'  THEN
             LET g_tot19_27 = g_tot19_27 + sr27.amd08
          END IF
 
          INSERT INTO x VALUES(sr27.*) 
 
     END FOREACH
 
     #-->銷項項目
     SELECT SUM(amd08) INTO l_a311_27 FROM x WHERE amd171='31' AND amd172='1' AND amd44='2'
     SELECT SUM(amd08) INTO l_a321_27 FROM x WHERE amd171='32' AND amd172='1' AND amd44='2'
     SELECT SUM(amd08) INTO l_a331_27 FROM x WHERE amd171='33' AND amd172='1' AND amd44='2'
     SELECT SUM(amd08) INTO l_a341_27 FROM x WHERE amd171='34' AND amd172='1' AND amd44='2'
     SELECT SUM(amd08) INTO l_a351_27 FROM x WHERE amd171='35' AND amd172='1' AND amd44='2'
 
     #-->免稅銷售額
     SELECT SUM(amd08) INTO l_c31_27 FROM x WHERE amd171='31' AND amd172='3' AND amd44='2'
     SELECT SUM(amd08) INTO l_c32_27 FROM x WHERE amd171='32' AND amd172='3' AND amd44='2'
     SELECT SUM(amd08) INTO l_c33_27 FROM x WHERE amd171='33' AND amd172='3' AND amd44='2'
     SELECT SUM(amd08) INTO l_c34_27 FROM x WHERE amd171='34' AND amd172='3' AND amd44='2'
     SELECT SUM(amd08) INTO l_c35_27 FROM x WHERE amd171='35' AND amd172='3' AND amd44='2'
     SELECT SUM(amd08) INTO l_c36_27 FROM x WHERE amd171='36' AND amd172='3' AND amd44='2'
     SELECT SUM(amd08) INTO l_c37_27 FROM x WHERE amd171='37' AND amd172='3' AND amd44='2'
     SELECT SUM(amd08) INTO l_c38_27 FROM x WHERE amd171='38' AND amd172='3' AND amd44='2'
 
     IF cl_null(l_tot5_27)  THEN LET l_tot5_27 = 0 END IF  
     IF cl_null(l_tot7_27)  THEN LET l_tot7_27 = 0 END IF
 
     IF cl_null(l_a311_27) THEN LET l_a311_27=0 END IF
     IF cl_null(l_a321_27) THEN LET l_a321_27=0 END IF
     IF cl_null(l_a331_27) THEN LET l_a331_27=0 END IF
     IF cl_null(l_a341_27) THEN LET l_a341_27=0 END IF
     IF cl_null(l_a351_27) THEN LET l_a351_27=0 END IF
 
     IF cl_null(l_c31_27) THEN LET l_c31_27 = 0 END IF
     IF cl_null(l_c32_27) THEN LET l_c32_27 = 0 END IF
     IF cl_null(l_c33_27) THEN LET l_c33_27 = 0 END IF
     IF cl_null(l_c34_27) THEN LET l_c34_27 = 0 END IF
     IF cl_null(l_c35_27) THEN LET l_c35_27 = 0 END IF
     IF cl_null(l_c36_27) THEN LET l_c36_27 = 0 END IF
     IF cl_null(l_c37_27) THEN LET l_c37_27 = 0 END IF
     IF cl_null(l_c38_27) THEN LET l_c38_27 = 0 END IF
 
     #合計
     LET l_sum1_27=l_a311_27+l_a321_27-l_a331_27-l_a341_27+l_a351_27
     LET g_tot24_27=l_c31_27+l_c32_27-l_c33_27-l_c34_27+l_c35_27+l_c36_27
     LET g_tot23_27 = g_tot7_27 + g_tot15_27 - g_tot19_27
 
      #特種稅額合計(65)
      IF cl_null(l_c37_27) THEN LET l_c37_27=0 END IF
      IF cl_null(l_c38_27) THEN LET l_c38_27=0 END IF
      LET l_tot5_27 = l_c37_27 - l_c38_27
 
      #銷售額總計(25)
      IF cl_null(l_sum1_27) THEN LET l_sum1_27=0 END IF
      LET l_tot27 = l_sum1_27 + g_tot23_27 + g_tot24_27 + l_tot5_27 
#FUN-B40087-mark----------end--------- 
     EXECUTE insert_prep USING g_ama.ama02,g_ama.ama03,g_ama.ama05,
                               g_ama.ama07,g_ama.ama11,l_amd173_b,
                               l_amd174_b,l_amd174_e,g_ame.ame06,
                               g_ame.ame08,g_ame.ame09,g_ame.ame10,
                               g_ame.ame11,l_a21a,l_a21b,l_a22a,l_a22b,
                               l_a23a,l_a23b,l_a24a,l_a24b,l_a25a,l_a25b,
                               l_a28a,l_a28b,l_a29a,l_a29b,l_a311,l_a321,
                               l_a331,l_a341,l_a351,l_aa,l_ab,l_b21a,l_b21b,
                               l_b22a,l_b22b,l_b23a,l_b23b,l_b24a,l_b24b,
                               l_b25a,l_b25b,l_b28a,l_b28b,l_b29a,l_b29b,
                               l_b311,l_b321,l_b331,l_b341,l_b351,l_ba,l_bb,
                               l_c31,l_c32,l_c33,l_c34,l_c35,l_c36,l_c37,l_c38,        #MOD-9A0080 add l_c35
                               g_inv_all,l_75,l_pdate_1,l_pdate_2,l_pdate_3,
                               l_sum1,l_sum2,g_tot101,g_tot107,g_tot108,
                               l_tot11,g_tot111,g_tot112,g_tot113,g_tot114,
                               g_tot115,l_tot12,g_tot15,l_tot16,l_tot17,
                               l_tot18,g_tot19,g_tot23,g_tot24,g_tot48,
                               g_tot49,l_tot5,g_tot7,l_tot7,
                               g_ama.ama17,g_ama.ama18,g_ama19,      #CHI-8B0031  #FUN-980024
                               g_ama.ama20,g_ama.ama16,l_tot26,l_tot27   #CHI-8B0031 #FUN-970101add tot26,tot27
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF tm.t = "1" THEN 
#       LET l_name = "amdg403"         #無格    #FUN-B40087 mark 
        LET g_template = "amdg403"     #無格    #FUN-B40087 add  
        CALL amdg403_grdata()                   #FUN-B40087  add
     ELSE  
#       LET l_name = "amdg403_2"       #有格    #FUN-B40087 mark
        LET g_template = "amdg403_2"   #有格    #FUN-B40087 add
        CALL amdg403_grdata()                   #FUN-B40087  add
     END IF
#    CALL cl_prt_cs3('amdg403',l_name,l_sql,g_str)   #CHI-8B0031   #FUN-B40087
 
 
END FUNCTION
 
FUNCTION g403_sum1()  # 計算發票數
  IF tm.a <> 'Y' THEN   #TQC-630076
     SELECT count(*) INTO g_inv_all FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
                    AND amd22 = tm.amd22
                    AND amd171 MATCHES '3*'
                    AND amd171<>'36' AND amd30='Y'    #不含虛擬發票,已確認資料no:7393
     IF SQLCA.SQLCODE THEN 
        CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)    #No.FUN-660093
     END IF
     
     SELECT count(*) INTO g_inv1 FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
              AND amd22 = tm.amd22 AND amd30='Y'                  #no:7393
              AND (amd171='31' OR amd171='32' OR amd171='35')
     IF SQLCA.SQLCODE THEN 
      CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)  #No.FUN-660093 
     END IF
     
     SELECT count(*) INTO g_inv2 FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
              AND amd22 = tm.amd22 AND amd30='Y'                  #no:7393
              AND (amd171='21' OR amd171='22' OR amd171='25')
     IF SQLCA.SQLCODE THEN 
      CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)   #No.FUN-660093
     END IF
     
     SELECT count(*) INTO g_inv3 FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
              AND amd22 = tm.amd22 AND amd30='Y'              #no:7393
              AND (amd171='33' OR amd171='34' OR amd171='23' OR amd171='24')
     IF SQLCA.SQLCODE THEN 
       CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)   #No.FUN-660093
     END IF
  ELSE
     SELECT count(*) INTO g_inv_all FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
                    AND amd171 MATCHES '3*'
                    AND amd171<>'36' AND amd30='Y'    #不含虛擬發票,已確認資料no:7393
     IF SQLCA.SQLCODE THEN
       CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)   #No.FUN-660093
     END IF
     
     SELECT count(*) INTO g_inv1 FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
              AND amd30='Y'                  #no:7393
              AND (amd171='31' OR amd171='32' OR amd171='35')
     IF SQLCA.SQLCODE THEN
       CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)   #No.FUN-660093
     END IF
     
     SELECT count(*) INTO g_inv2 FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
              AND amd30='Y'                  #no:7393
              AND (amd171='21' OR amd171='22' OR amd171='25')
     IF SQLCA.SQLCODE THEN
      CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)   #No.FUN-660093
     END IF
     
     SELECT count(*) INTO g_inv3 FROM amd_file
            WHERE amd173 = tm.amd173_b
              AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
              AND amd30='Y'              #no:7393
              AND (amd171='33' OR amd171='34' OR amd171='23' OR amd171='24')
     IF SQLCA.SQLCODE THEN 
       CALL cl_err('sel oma',STATUS,0)    #No.FUN-660093
       CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)  #No.FUN-660093
     END IF
  ENd IF
  IF cl_null(g_inv_all) THEN LET g_inv_all = 0    END IF
  IF cl_null(g_inv1) THEN LET g_inv1 = 0          END IF
  IF cl_null(g_inv2) THEN LET g_inv2 = 0          END IF
  IF cl_null(g_inv3) THEN LET g_inv3 = 0          END IF
  LET g_inv4 = 1      ##  固定印 1
 
END FUNCTION
 
 
FUNCTION g403_set_entry()
  CALL cl_set_comp_entry("amd22",TRUE)
END FUNCTION
 
FUNCTION g403_set_no_entry()
  CALL cl_set_comp_entry("amd22",FALSE)
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
#FUN-B40054--add--Begin
FUNCTION g403_2()
DEFINE l_sql       STRING
#FUN-C10036--Begin--
#DEFINE g_ama_1     RECORD
#          ama25    LIKE ama_file.ama25,
#          ama26    LIKE ama_file.ama26,
#          ama27    LIKE ama_file.ama27,
#          ama28    LIKE ama_file.ama28,
#          ama29    LIKE ama_file.ama29,
#          ama30    LIKE ama_file.ama30,
#          ama31    LIKE ama_file.ama31,
#          ama32    LIKE ama_file.ama32,
#          ama33    LIKE ama_file.ama33,
#          ama34    LIKE ama_file.ama34,
#          ama35    LIKE ama_file.ama35,
#          ama36    LIKE ama_file.ama36,
#          ama37    LIKE ama_file.ama37,
#          ama38    LIKE ama_file.ama38,
#          ama39    LIKE ama_file.ama39,
#          ama40    LIKE ama_file.ama40,
#          ama41    LIKE ama_file.ama41,
#          ama42    LIKE ama_file.ama42,
#          ama43    LIKE ama_file.ama43,
#          ama44    LIKE ama_file.ama44,
#          ama45    LIKE ama_file.ama45,
#          ama46    LIKE ama_file.ama46,
#          ama47    LIKE ama_file.ama47,
#          ama48    LIKE ama_file.ama48,
#          ama49    LIKE ama_file.ama49,
#          ama50    LIKE ama_file.ama50,
#          ama51    LIKE ama_file.ama51,
#          ama52    LIKE ama_file.ama52,
#          ama53    LIKE ama_file.ama53,
#          ama54    LIKE ama_file.ama54,
#          ama55    LIKE ama_file.ama55,
#          ama56    LIKE ama_file.ama56,
#          ama57    LIKE ama_file.ama57,
#          ama58    LIKE ama_file.ama58,
#          ama59    LIKE ama_file.ama59,
#          ama60    LIKE ama_file.ama60,
#          ama61    LIKE ama_file.ama61,
#          ama62    LIKE ama_file.ama62,
#          ama63    LIKE ama_file.ama63,
#          ama64    LIKE ama_file.ama64,
#          ama65    LIKE ama_file.ama65,
#          ama66    LIKE ama_file.ama66,
#          ama67    LIKE ama_file.ama67,
#          ama68    LIKE ama_file.ama68,
#          ama69    LIKE ama_file.ama69,
#          ama70    LIKE ama_file.ama70,
#          ama71    LIKE ama_file.ama71,
#          ama72    LIKE ama_file.ama72,
#          ama73    LIKE ama_file.ama73,
#          ama74    LIKE ama_file.ama74,
#          ama75    LIKE ama_file.ama75,
#          ama76    LIKE ama_file.ama76,
#          ama77    LIKE ama_file.ama77,
#          ama78    LIKE ama_file.ama78,
#          ama79    LIKE ama_file.ama79,
#          ama80    LIKE ama_file.ama80,
#          ama81    LIKE ama_file.ama81,
#          ama82    LIKE ama_file.ama82,
#          ama83    LIKE ama_file.ama83,
#          ama84    LIKE ama_file.ama84,
#          ama85    LIKE ama_file.ama85,
#          ama86    LIKE ama_file.ama86,
#          ama87    LIKE ama_file.ama87,
#          ama88    LIKE ama_file.ama88,
#          ama89    LIKE ama_file.ama89,
#          ama90    LIKE ama_file.ama90,
#          ama91    LIKE ama_file.ama91,
#          ama92    LIKE ama_file.ama92,
#          ama93    LIKE ama_file.ama93,
#          ama94    LIKE ama_file.ama94,
#          ama95    LIKE ama_file.ama95,
#          ama96    LIKE ama_file.ama96,
#          ama97    LIKE ama_file.ama97
#                   END RECORD
#
#   SELECT ama25,ama26,ama27,ama28,ama29,ama30,ama31,ama32,ama33,ama34,ama35,ama36,
#          ama37,ama38,ama39,ama40,ama41,ama42,ama43,ama44,ama45,ama46,ama47,ama48,
#          ama49,ama50,ama51,ama52,ama53,ama54,ama55,ama56,ama57,ama58,ama59,ama60,
#          ama61,ama62,ama63,ama64,ama65,ama66,ama67,ama68,ama69,ama70,ama71,ama72,
#          ama73,ama74,ama75,ama76,ama77,ama78,ama79,ama80,ama81,ama82,ama83,ama84,
#          ama85,ama86,ama87,ama88,ama89,ama90,ama91,ama92,ama93,ama94,ama95,ama96,
#          ama97 INTO g_ama_1.* FROM ama_file 
#    WHERE ama01 = tm.amd22
#
#   LET l_sql = "ama25.ama_file.ama25,ama26.ama_file.ama26,",
#               "ama27.ama_file.ama27,ama28.ama_file.ama28,",
#               "ama29.ama_file.ama29,ama30.ama_file.ama30,",
#               "ama31.ama_file.ama31,ama32.ama_file.ama32,",
#               "ama33.ama_file.ama33,ama34.ama_file.ama34,",
#               "ama35.ama_file.ama35,ama36.ama_file.ama36,",
#               "ama37.ama_file.ama37,ama38.ama_file.ama38,",
#               "ama39.ama_file.ama39,ama40.ama_file.ama40,",
#               "ama41.ama_file.ama41,ama42.ama_file.ama42,",
#               "ama43.ama_file.ama43,ama44.ama_file.ama44,",
#               "ama45.ama_file.ama45,ama46.ama_file.ama46,",
#               "ama47.ama_file.ama47,ama48.ama_file.ama48,",
#               "ama49.ama_file.ama49,ama50.ama_file.ama50,",
#               "ama51.ama_file.ama51,ama52.ama_file.ama52,",
#               "ama53.ama_file.ama53,ama54.ama_file.ama54,",
#               "ama55.ama_file.ama55,ama56.ama_file.ama56,",
#               "ama57.ama_file.ama57,ama58.ama_file.ama58,",
#               "ama59.ama_file.ama59,ama60.ama_file.ama60,",
#               "ama61.ama_file.ama61,ama62.ama_file.ama62,",
#               "ama63.ama_file.ama63,ama64.ama_file.ama64,",
#               "ama65.ama_file.ama65,ama66.ama_file.ama66,",
#               "ama67.ama_file.ama67,ama68.ama_file.ama68,",
#               "ama69.ama_file.ama69,ama70.ama_file.ama70,",
#               "ama71.ama_file.ama71,ama72.ama_file.ama72,",
#               "ama73.ama_file.ama73,ama74.ama_file.ama74,",
#               "ama75.ama_file.ama75,ama76.ama_file.ama76,",
#               "ama77.ama_file.ama77,ama78.ama_file.ama78,",
#               "ama79.ama_file.ama79,ama80.ama_file.ama80,",
#               "ama81.ama_file.ama81,ama82.ama_file.ama82,",
#               "ama83.ama_file.ama83,ama84.ama_file.ama84,",
#               "ama85.ama_file.ama85,ama86.ama_file.ama86,",
#               "ama87.ama_file.ama87,ama88.ama_file.ama88,",
#               "ama89.ama_file.ama89,ama90.ama_file.ama90,",
#               "ama91.ama_file.ama91,ama92.ama_file.ama92,",
#               "ama93.ama_file.ama93,ama94.ama_file.ama94,",
#               "ama95.ama_file.ama95,ama96.ama_file.ama96,",
#               "ama97.ama_file.ama97"
DEFINE g_amk_1     RECORD
          amk04    LIKE amk_file.amk04,
          amk05    LIKE amk_file.amk05,
          amk06    LIKE amk_file.amk06,
          amk07    LIKE amk_file.amk07,
          amk08    LIKE amk_file.amk08,
          amk09    LIKE amk_file.amk09,
          amk10    LIKE amk_file.amk10,
          amk11    LIKE amk_file.amk11,
          amk12    LIKE amk_file.amk12,
          amk13    LIKE amk_file.amk13,
          amk14    LIKE amk_file.amk14,
          amk15    LIKE amk_file.amk15,
          amk16    LIKE amk_file.amk16,
          amk17    LIKE amk_file.amk17,
          amk18    LIKE amk_file.amk18,
          amk19    LIKE amk_file.amk19,
          amk20    LIKE amk_file.amk20,
          amk21    LIKE amk_file.amk21,
          amk22    LIKE amk_file.amk22,
          amk23    LIKE amk_file.amk23,
          amk24    LIKE amk_file.amk24,
          amk25    LIKE amk_file.amk25,
          amk26    LIKE amk_file.amk26,
          amk27    LIKE amk_file.amk27,
          amk28    LIKE amk_file.amk28,
          amk29    LIKE amk_file.amk29,
          amk30    LIKE amk_file.amk30,
          amk31    LIKE amk_file.amk31,
          amk32    LIKE amk_file.amk32,
          amk33    LIKE amk_file.amk33,
          amk34    LIKE amk_file.amk34,
          amk35    LIKE amk_file.amk35,
          amk36    LIKE amk_file.amk36,
          amk37    LIKE amk_file.amk37,
          amk38    LIKE amk_file.amk38,
          amk39    LIKE amk_file.amk39,
          amk40    LIKE amk_file.amk40,
          amk41    LIKE amk_file.amk41,
          amk42    LIKE amk_file.amk42,
          amk43    LIKE amk_file.amk43,
          amk44    LIKE amk_file.amk44,
          amk45    LIKE amk_file.amk45,
          amk46    LIKE amk_file.amk46,
          amk47    LIKE amk_file.amk47,
          amk48    LIKE amk_file.amk48,
          amk49    LIKE amk_file.amk49,
          amk50    LIKE amk_file.amk50,
          amk51    LIKE amk_file.amk51,
          amk52    LIKE amk_file.amk52,
          amk53    LIKE amk_file.amk53,
          amk54    LIKE amk_file.amk54,
          amk55    LIKE amk_file.amk55,
          amk56    LIKE amk_file.amk56,
          amk57    LIKE amk_file.amk57,
          amk58    LIKE amk_file.amk58,
          amk59    LIKE amk_file.amk59,
          amk60    LIKE amk_file.amk60,
          amk61    LIKE amk_file.amk61,
          amk62    LIKE amk_file.amk62,
          amk63    LIKE amk_file.amk63,
          amk64    LIKE amk_file.amk64,
          amk65    LIKE amk_file.amk65,
          amk66    LIKE amk_file.amk66,
          amk67    LIKE amk_file.amk67,
          amk68    LIKE amk_file.amk68,
          amk69    LIKE amk_file.amk69,
          amk70    LIKE amk_file.amk70,
          amk71    LIKE amk_file.amk71,
          amk72    LIKE amk_file.amk72,
          amk73    LIKE amk_file.amk73,
          amk74    LIKE amk_file.amk74,
          amk75    LIKE amk_file.amk75,
          amk76    LIKE amk_file.amk76
                   END RECORD

   SELECT amk04,amk05,amk06,amk07,amk08,amk09,amk10,amk11,amk12,amk13,amk14,amk15,
          amk16,amk17,amk18,amk19,amk20,amk21,amk22,amk23,amk24,amk25,amk26,amk27,
          amk28,amk29,amk30,amk31,amk32,amk33,amk34,amk35,amk36,amk37,amk38,amk39,
          amk40,amk41,amk42,amk43,amk44,amk45,amk46,amk47,amk48,amk49,amk50,amk51,
          amk52,amk53,amk54,amk55,amk56,amk57,amk58,amk59,amk60,amk61,amk62,amk63,
          amk64,amk65,amk66,amk67,amk68,amk69,amk70,amk71,amk72,amk73,amk74,amk75,
          amk76 INTO g_amk_1.* FROM amk_file 
    WHERE amk01 = tm.amd22 AND amk02 = tm.amd173_b AND amk03 = tm.amd174_e

   LET l_sql = "amk04.amk_file.amk04,amk05.amk_file.amk05,",
               "amk06.amk_file.amk06,amk07.amk_file.amk07,",
               "amk08.amk_file.amk08,amk09.amk_file.amk09,",
               "amk10.amk_file.amk10,amk11.amk_file.amk11,",
               "amk12.amk_file.amk12,amk13.amk_file.amk13,",
               "amk14.amk_file.amk14,amk15.amk_file.amk15,",
               "amk16.amk_file.amk16,amk17.amk_file.amk17,",
               "amk18.amk_file.amk18,amk19.amk_file.amk19,",
               "amk20.amk_file.amk20,amk21.amk_file.amk21,",
               "amk22.amk_file.amk22,amk23.amk_file.amk23,",
               "amk24.amk_file.amk24,amk25.amk_file.amk25,",
               "amk26.amk_file.amk26,amk27.amk_file.amk27,",
               "amk28.amk_file.amk28,amk29.amk_file.amk29,",
               "amk30.amk_file.amk30,amk31.amk_file.amk31,",
               "amk32.amk_file.amk32,amk33.amk_file.amk33,",
               "amk34.amk_file.amk34,amk35.amk_file.amk35,",
               "amk36.amk_file.amk36,amk37.amk_file.amk37,",
               "amk38.amk_file.amk38,amk39.amk_file.amk39,",
               "amk40.amk_file.amk40,amk41.amk_file.amk41,",
               "amk42.amk_file.amk42,amk43.amk_file.amk43,",
               "amk44.amk_file.amk44,amk45.amk_file.amk45,",
               "amk46.amk_file.amk46,amk47.amk_file.amk47,",
               "amk48.amk_file.amk48,amk49.amk_file.amk49,",
               "amk50.amk_file.amk50,amk51.amk_file.amk51,",
               "amk52.amk_file.amk52,amk53.amk_file.amk53,",
               "amk54.amk_file.amk54,amk55.amk_file.amk55,",
               "amk56.amk_file.amk56,amk57.amk_file.amk57,",
               "amk58.amk_file.amk58,amk59.amk_file.amk59,",
               "amk60.amk_file.amk60,amk61.amk_file.amk61,",
               "amk62.amk_file.amk62,amk63.amk_file.amk63,",
               "amk64.amk_file.amk64,amk65.amk_file.amk65,",
               "amk66.amk_file.amk66,amk67.amk_file.amk67,",
               "amk68.amk_file.amk68,amk69.amk_file.amk69,",
               "amk70.amk_file.amk70,amk71.amk_file.amk71,",
               "amk72.amk_file.amk72,amk73.amk_file.amk73,",
               "amk74.amk_file.amk74,amk75.amk_file.amk75,",
               "amk76.amk_file.amk76"
#FUN-C10036---End---

   LET l_table = cl_prt_temptable('amdg403',l_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?)" 
   PREPARE insert_prep_1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF

   #EXECUTE insert_prep_1 USING g_ama_1.*    #FUN-C10036   mark
   EXECUTE insert_prep_1 USING g_amk_1.*     #FUN-C10036   add
 
   
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

#  CALL cl_prt_cs3('amdg403','amdg403_3',l_sql,'')   #FUN-B40087
   LET g_template = 'amdg403_3'  
   CALL amdg403_3_grdata(l_table)    #FUN-B40087  add
END FUNCTION

#cy add
FUNCTION amdg403_3_grdata(l_table)
DEFINE l_table   STRING 
DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr2      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("amdg403")
        IF handler IS NOT NULL THEN
            START REPORT amdg403_3_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

            DECLARE amdg403_3_datacur1 CURSOR FROM l_sql
            FOREACH amdg403_3_datacur1 INTO sr2.*
                OUTPUT TO REPORT amdg403_3_rep(sr2.*)
            END FOREACH
            FINISH REPORT amdg403_3_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg403_3_rep(sr2)
DEFINE sr2 sr2_t
DEFINE l_lineno       LIKE type_file.num5
FORMAT
     ON EVERY ROW 
        LET l_lineno = l_lineno + 1
        PRINTX l_lineno
        PRINTX sr2.*
END REPORT


FUNCTION amdg403_4_grdata(l_table)
DEFINE l_table   STRING 
DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr3      sr3_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("amdg403")
        IF handler IS NOT NULL THEN
            START REPORT amdg403_4_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

            DECLARE amdg403_4_datacur1 CURSOR FROM l_sql
            FOREACH amdg403_4_datacur1 INTO sr3.*
                OUTPUT TO REPORT amdg403_4_rep(sr3.*)
            END FOREACH
            FINISH REPORT amdg403_4_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg403_4_rep(sr3)
DEFINE sr3 sr3_t
DEFINE l_lineno       LIKE type_file.num5
FORMAT
     ON EVERY ROW 
        LET l_lineno = l_lineno + 1
        PRINTX l_lineno
        PRINTX sr3.*
END REPORT


#cy add

FUNCTION g403_3()
DEFINE l_sql  STRING
#FUN-C10036--Begin--
#DEFINE g_ama_2     RECORD
#          ama99    LIKE ama_file.ama99,
#          ama100   LIKE ama_file.ama100,
#          ama101   LIKE ama_file.ama101,
#          ama102   LIKE ama_file.ama102,
#          ama103   LIKE ama_file.ama103,
#          ama104   LIKE ama_file.ama104,
#          ama105   LIKE ama_file.ama105
#                   END RECORD
#
#   SELECT ama99,ama100,ama101,ama102,ama103,ama104,ama105 INTO g_ama_2.*
#     FROM ama_file
#    WHERE ama01 = tm.amd22
#   
#   LET l_sql =  "ama99.ama_file.ama99,ama100.ama_file.ama100,",
#               "ama101.ama_file.ama101,ama102.ama_file.ama102,",
#               "ama103.ama_file.ama103,ama104.ama_file.ama104,",
#               "ama105.ama_file.ama105"
DEFINE g_amk_2     RECORD
          amk78    LIKE amk_file.amk78,
          amk79   LIKE amk_file.amk79,
          amk80   LIKE amk_file.amk80,
          amk81   LIKE amk_file.amk81,
          amk82   LIKE amk_file.amk82,
          amk83   LIKE amk_file.amk83,
          amk84   LIKE amk_file.amk84
                   END RECORD

   SELECT amk78,amk79,amk80,amk81,amk82,amk83,amk84 INTO g_amk_2.*
     FROM amk_file
    WHERE amk01 = tm.amd22 AND amk02 = tm.amd173_b AND amk03 = tm.amd174_e

   LET l_sql = "amk78.amk_file.amk78,amk79.amk_file.amk79,",
               "amk80.amk_file.amk80,amk81.amk_file.amk81,",
               "amk82.amk_file.amk82,amk83.amk_file.amk83,",
               "amk84.amk_file.amk84"
#FUN-C10036---End---

   LET l_table = cl_prt_temptable('amdg403',l_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF
   LET l_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?)"

   PREPARE insert_prep_2 FROM l_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF

   #EXECUTE insert_prep_2 USING g_ama_2.*   #FUN-C10036  mark
   EXECUTE insert_prep_2 USING g_amk_2.*    #FUN-C10036  add

###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

###GENGRE###   CALL cl_prt_cs3('amdg403','amdg403_4',l_sql,'')
    LET g_template = 'amdg403_4'
    CALL amdg403_4_grdata(l_table)    ###GENGRE###

END FUNCTION
#FUN-B40054--add--End

###GENGRE###START
FUNCTION amdg403_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("amdg403")
        IF handler IS NOT NULL THEN
            START REPORT amdg403_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE amdg403_datacur1 CURSOR FROM l_sql
            FOREACH amdg403_datacur1 INTO sr1.*
                OUTPUT TO REPORT amdg403_rep(sr1.*)
            END FOREACH
            FINISH REPORT amdg403_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT amdg403_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
#FUN-B40087-----------------add--------str----
    DEFINE l_lineno       LIKE type_file.num5
    DEFINE l_a23_a24a     LIKE type_file.num10 
    DEFINE l_a23b_a24b    LIKE type_file.num10
    DEFINE l_a331_a341    LIKE amd_file.amd08
    DEFINE l_b23a_b24a    LIKE type_file.num10
    DEFINE l_b23b_b24b    LIKE type_file.num10
    DEFINE l_b331_b341    LIKE amd_file.amd08
    DEFINE l_c33_c34      LIKE amd_file.amd08
    DEFINE l_tot101_17    LIKE type_file.num20_6
    DEFINE l_tot107_108   LIKE type_file.num20_6
    DEFINE l_tot101_ame10 LIKE ame_file.ame10
#FUN-B40087----------------add---------end----

    
    ORDER EXTERNAL BY sr1.ama02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
            PRINTX g_str                                                 #FUN-B40087
              
        BEFORE GROUP OF sr1.ama02
            LET l_lineno = 0
            #FUN-B40087-----------------add--------str----
            LET l_tot101_ame10 = sr1.tot101 + sr1.tot17 + sr1.tot18 + sr1.ame10
            PRINTX l_tot101_ame10
            LET l_a23_a24a = sr1.a23a + sr1.a24a + sr1.a29a
            PRINTX l_a23_a24a
            LET l_a23b_a24b = sr1.a23b + sr1.a24b + sr1.a29b
            PRINTX l_a23b_a24b
            LET l_a331_a341 =sr1.a331 + sr1.a341
            PRINTX l_a331_a341
            LET l_b23a_b24a = sr1.b23a +sr1.b24a + sr1.b29a
            PRINTX l_b23a_b24a
            LET l_b23b_b24b = sr1.b23b +sr1.b24b + sr1.b29b
            PRINTX l_b23b_b24b
            LET l_b331_b341 = sr1.b331 + sr1.b341
            PRINTX l_b331_b341
            LET l_c33_c34 = sr1.c33 + sr1.c34
            PRINTX l_c33_c34
            LET l_tot101_17 = sr1.tot101 + sr1.tot17 + sr1.tot18 + sr1.ame10
            PRINTX l_tot101_17
            LET l_tot107_108 = sr1.tot107 + sr1.tot108
            PRINTX l_tot107_108


            #FUN-B40087----------------add---------end----

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.ama02

        
        ON LAST ROW

END REPORT
###GENGRE###END
