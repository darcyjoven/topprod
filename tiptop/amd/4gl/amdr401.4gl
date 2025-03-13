# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: amdr401.4gl
# Descriptions...:
# Date & Author..: 98/10/27 By Jimmy
# Modify.........: 01/05/23 by plum
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: NO.TQC-5B0201 05/12/22 BY yiting 年月輸入模式統一為：年/起始月份-截止月份
# Modify.........: No.TQC-610057 06/01/20 By Kevin 修改外部參數接收
# Modify.........: No.TQC-630076 06/03/30 By Smapmin 合併稅籍列印
# Modify.........: No.MOD-650091 06/05/23 By Smapmin 修改二聯式發票稅額計算
# Modify.........: No.FUN-660093 06/06/15 By xumin  cl_err To cl_err3
# Modify.........: No.FUN-670109 06/08/04 By Smapmin 加上進項不得扣抵金額申報,且課稅別為應稅的也要納入
#                                                    退稅金額要四捨五入.
# Modify.........: No.FUN-680074 06/08/24 By huchenghao 類型轉換
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710085 07/03/14 By Rayven 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/03/30 By Nicole 增加CR參數
# Modify.........: No.CHI-750019 07/05/24 By Smapmin 修改金額(48/49)計算邏輯
# Modify.........: No.MOD-830129 08/03/17 By Smapmin 修改SQL語法
# Modify.........: No.FUN-860041 08/06/11 By Carol 民國年欄位放大為3位
# Modify.........: No.MOD-870303 08/07/28 By chenl 修正年度欄位
# Modify.........: No.FUN-7B0011 08/12/01 By rainy 新增格式二
# Modify.........: No.MOD-930142 09/03/12 By lilingyu l_tot25沒有給值
# Modify.........: No.MOD-930145 09/03/12 By lilingyu 修改本期應實繳稅額>0時,造成又要繳稅又可退稅的問題
# Modify.........: No.MOD-970199 09/07/22 By mike  amdr401營業人申報書,選擇合并稅籍,月份:5,6,報表表頭沒有印出統一編號,稅籍編號..    
# Modify.........: No.FUN-970106 09/07/30 By hongmei CR add ama17~ama20
# Modify.........: No.FUN-8B0081 09/08/04 By hongmei add l_tot27銷售固定資產金額 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-980024 09/10/29 BY yiting ama19產出時，改為ama21(4碼) + ama19(11碼) + ama21(5碼)
# Modify.........: NO.FUN-990034 09/10/29 by Yiting 身份證號碼後四碼以星號呈現
# Modify.........: No:MOD-9C0151 09/12/16 By Sarah 增加處理報表右上角註記欄的列印
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:FUN-A10039 10/01/20 By jan 程式段中用到amd172 = 'D'或amd172 <> 'D'皆改為amd172 = 'F'或amd172 <> 'F'
# Modify.........: No:TQC-A40101 10/04/22 By Carrier GP5.2追单
# Modify.........: No:MOD-AC0006 10/12/01 By Dido 調整進項合計格式22和27依發票聯數來決定是採內含稅或是分稅垂直 
# Modify.........: No.TQC-C10034 12/01/17 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.TQC-C20047 12/02/09 By dongsz 套表不需添加簽核內容 
# Modify.........: No:MOD-C50042 12/05/14 By Elise 調整 l_flag 變數,如ama15 = '1'時,也須為'N'與計數是否有ama15 = '1'資料
# Modify.........: No:MOD-C70050 12/07/05 By Polly 還原MOD-AC0006作法，維持手工申報與amdp100申報方式的計算差異
# Modify.........: No:TQC-CB0052 12/11/16 By zhangweib 得退稅額合計 g_tot113 如為負數,應改為 0 呈現
# Modify.........: No:MOD-D30096 13/03/11 By apo 還原l_tot36計算方式
# Modify.........: No.MOD-D40106 13/04/16 By apo 發票份數改用num20型態

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
           a        LIKE type_file.chr1,       #No.FUN-680074 VARCHAR(01) #TQC-630076
           amd173_b LIKE type_file.num10,      #No.FUN-680074 INTEGER
           amd174_b LIKE type_file.num10,      #No.FUN-680074 INTEGER
           amd174_e LIKE type_file.num10,      #No.FUN-680074 INTEGER
           pdate    LIKE type_file.dat,        #No.FUN-680074 DATE
           amd22    LIKE amd_file.amd22,
           t        LIKE type_file.chr1,       #No.FUN-7B0011
           more     LIKE type_file.chr1        #No.FUN-680074 VARCHAR(1)
           END RECORD,
       g_ama        RECORD  LIKE ama_file.*,
       g_ame        RECORD  LIKE ame_file.*,
       g_tot7       LIKE type_file.num10,      #No.FUN-680074  INTEGER# 7:不經海關出口應附證明文件者
       g_tot15      LIKE type_file.num10,      #No.FUN-680074  INTEGER#15:經海關出口免附證明文件者
       g_tot19      LIKE type_file.num10,      #No.FUN-680074  INTEGER#19:零稅率之退回及折讓
       g_tot23      LIKE type_file.num10,      #No.FUN-680074  INTEGER#23:非經海關(7)+經海關(15)
       g_tot48      LIKE type_file.num10,      #No.FUN-680074  INTEGER#48:讀取進項總金額之進費及費用
       g_tot49      LIKE type_file.num10,      #No.FUN-680074  INTEGER#49:讀取進項總金額之固定資產
       l_tot48      LIKE type_file.num10,      #No.FUN-680074  INTEGER#進資及費用之零稅率折讓金額
       l_tot49      LIKE type_file.num10,      #No.FUN-680074  INTEGER#固定資產之零稅率折讓金額
       g_tot101     LIKE type_file.num10,      #No.FUN-680074  INTEGER#101:本月銷項稅額合計(=2:l_tot2)
       g_tot107     LIKE type_file.num10,      #No.FUN-680074  INTEGER#107:得抵扣進項稅額合計
       g_tot108     LIKE type_file.num10,      #No.FUN-680074  INTEGER#108:上期(月)累積留抵稅額
       g_tot110     LIKE type_file.num10,      #No.FUN-680074  INTEGER#110:小計(107+108)
       g_tot111     LIKE type_file.num10,      #No.FUN-680074  INTEGER#111:本期(月)應實繳稅額(101-110)
       g_tot112     LIKE type_file.num10,      #No.FUN-680074  INTEGER#112:本期(月)申報留抵稅額(110-101)
       g_tot113     LIKE type_file.num20_6,    #No.FUN-680074  DEC(20,6)#113:得退稅額合計   #FUN-670109
       g_tot114     LIKE type_file.num10,      #No.FUN-680074  INTEGER#114:本期(月)應退稅額
       g_tot115     LIKE type_file.num10,      #No.FUN-680074  INTEGER#115:本期(月)累積留抵稅額(112-114)
       g_abx        LIKE type_file.num10,      #No.FUN-680074  INTEGER#免開立發票銷售額
      #g_inv_all    LIKE type_file.num5,       #MOD-D40106 mark  #No.FUN-680074  SMALLINT#使用發票分數
       g_inv_all    LIKE type_file.num20,      #MOD-D40106 
       g_inv1       LIKE type_file.num5,       #No.FUN-680074  SMALLINT#No use
       g_inv2       LIKE type_file.num5,       #No.FUN-680074  SMALLINT#No use
       g_inv3       LIKE type_file.num5,       #No.FUN-680074  SMALLINT#No use
       g_inv4       LIKE type_file.num5        #No.FUN-680074  SMALLINT#No use
DEFINE l_table      STRING                     #No.FUN-710085
DEFINE g_sql        STRING                     #No.FUN-710085
DEFINE g_str        STRING                     #No.FUN-710085
DEFINE g_ama19      LIKE ama_file.ama02        #FUN-980024
DEFINE g_ama17      STRING                     #FUN-990034
DEFINE l_length1    LIKE type_file.num5        #FUN-990034
DEFINE l_length2    LIKE type_file.num5        #FUN-990034
 
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
 
   LET g_sql = "abx.type_file.num10,ama02.ama_file.ama02,",
               "ama03.ama_file.ama03,ama05.ama_file.ama05,",
               "ama07.ama_file.ama07,ama11.ama_file.ama11,",
               "amd173_b.type_file.chr3,amd174_b.type_file.chr2,",   #FUN-7B0011
               "amd174_e.type_file.chr2,ame04.ame_file.ame04,",
               "ame05.ame_file.ame05,ame06.ame_file.ame06,",
               "ame08.ame_file.ame08,inv_all.type_file.num5,",
               "pdate_1.type_file.chr3,pdate_2.type_file.chr2,",     #FUN-7B0011
               "pdate_3.type_file.chr2,tot1.type_file.num10,",
               "tot10.type_file.num10,tot101.type_file.num10,",
               "tot107.type_file.num10,tot108.type_file.num10,",
               "tot110.type_file.num10,tot111.type_file.num10,",
               "tot112.type_file.num10,tot113.type_file.num10,",
               "tot114.type_file.num10,tot115.type_file.num10,",
               "tot13.type_file.num10,tot14.type_file.num10,",
               "tot15.type_file.num10,tot171.type_file.num10,",
               "tot172.type_file.num10,tot181.type_file.num10,",
               "tot182.type_file.num10,tot19.type_file.num10,",
               "tot2.type_file.num10,tot21.type_file.num10,",
               "tot22.type_file.num10,tot23.type_file.num10,",
               "tot25.type_file.num10,tot28.type_file.num10,",
               "tot29.type_file.num10,tot30.type_file.num10,",
               "tot31.type_file.num10,tot32.type_file.num10,",
               "tot33.type_file.num10,tot34.type_file.num10,",
               "tot35.type_file.num10,tot36.type_file.num10,",
               "tot37.type_file.num10,tot38.type_file.num10,",
               "tot39.type_file.num10,tot401.type_file.num10,",
               "tot402.type_file.num10,tot403.type_file.num10,",
               "tot411.type_file.num10,tot412.type_file.num10,",
               "tot413.type_file.num10,tot421.type_file.num10,",
               "tot422.type_file.num10,tot423.type_file.num10,",
               "tot431.type_file.num10,tot432.type_file.num10,",
               "tot433.type_file.num10,tot44.type_file.num10,",
               "tot45.type_file.num10,tot46.type_file.num10,",
               "tot47.type_file.num10,tot48.type_file.num10,",
               "tot49.type_file.num10,tot5.type_file.num10,",
               "tot6.type_file.num10,tot7.type_file.num10,",
               "tot78.type_file.num10,tot79.type_file.num10,",
               "tot80.type_file.num10,tot81.type_file.num10,",
               "tot9.type_file.num10,ama17.ama_file.ama17,",  #FUN-970106
               "ama18.ama_file.ama18,ama19.type_file.chr20,", #FUN-970106  #FUN-980024
               "ama20.ama_file.ama20,ama16.ama_file.ama16,",  #FUN-970106
               "tot27.type_file.num10 "                       #FUN-8B0081 add #No.TQC-C10034 add , , #No.TQC-C20047 del , ,
#No.TQC-C20047--- mark --- begin
#               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
#               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
#               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
#               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
#No.TQC-C20047--- mark ---end 
   LET l_table = cl_prt_temptable('amdr401',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?  )"   #FUN-970106  #FUN-8B0081 add ? #No.TQC-C10034 add 4? #No.TQC-C20047 del 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   DROP TABLE x
  #----------------------MOD-C70050----------------------(S)
  #---MOD-C70050--mark delet amd031
  #CREATE TEMP TABLE x
  #     (amd17  LIKE amd_file.amd17,
  #      amd171 LIKE amd_file.amd171,
  #      amd172 LIKE amd_file.amd172,
  #      amd07  LIKE amd_file.amd07,
  #      amd08  LIKE amd_file.amd08,
  #      amd03  LIKE amd_file.amd03,
  #      amd031 LIKE amd_file.amd031,       #MOD-AC0006
  #      amd04  LIKE amd_file.amd04,
  #      amd06  LIKE amd_file.amd06,
  #      amd44  LIKE amd_file.amd44)   #FUN-8B0081 add
  #---MOD-C70050--mark

   CREATE TEMP TABLE x
        (amd17  LIKE amd_file.amd17,
         amd171 LIKE amd_file.amd171,
         amd172 LIKE amd_file.amd172,
         amd07  LIKE amd_file.amd07,
         amd08  LIKE amd_file.amd08,
         amd03  LIKE amd_file.amd03,
         amd04  LIKE amd_file.amd04,
         amd06  LIKE amd_file.amd06,
         amd44  LIKE amd_file.amd44)
  #----------------------MOD-C70050----------------------(E)
       
   IF STATUS THEN CALL cl_err('create',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
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
      THEN CALL r401_tm(0,0)
      ELSE CALL r401()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION r401_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680074 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680074 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 23
   ELSE LET p_row = 6 LET p_col = 15
   END IF
   OPEN WINDOW r401_w AT p_row,p_col
        WITH FORM "amd/42f/amdr401"
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
   LET tm.t = '1'   #FUN-7B0011 add
   LET tm.amd173_b=YEAR(g_today)
   LET tm.amd174_b=MONTH(g_today)
   LET tm.amd174_e=MONTH(g_today)
   LET tm.pdate=g_today
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
      DELETE FROM x      #No.FUN-710085
      LET g_tot7   =0
      LET g_tot15  =0
      LET g_tot23  =0
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
 
   INPUT BY NAME tm.a,tm.amd22,tm.amd173_b,tm.amd174_b,tm.amd174_e,tm.pdate,tm.t,tm.more   #TQC-630076   #FUN-7B0011 add tm.t before tm.more
                 WITHOUT DEFAULTS
         BEFORE INPUT
             CALL cl_qbe_init()
 
      ON ACTION locale
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
      AFTER FIELD a
        CALL r401_set_entry()
        IF tm.a = 'Y' THEN
           CALL r401_set_no_entry()
           LET tm.amd22 = ''
           DISPLAY BY NAME tm.amd22
           SELECT * INTO g_ama.* FROM ama_file WHERE ama15='1' #MOD-970199    
        END IF
 
      AFTER FIELD amd173_b
         IF cl_null(tm.amd173_b) THEN NEXT FIELD amd173_b END IF
 
      AFTER FIELD amd174_b
         IF cl_null(tm.amd174_b) THEN NEXT FIELD amd174_b END IF
         IF tm.amd174_b > 12 THEN
             NEXT FIELD amd174_b
         END IF
 
      AFTER FIELD amd174_e
         IF cl_null(tm.amd174_e) THEN NEXT FIELD amd174_e END IF
         IF tm.amd174_e > 12 THEN
             NEXT FIELD amd174_e
         END IF
 
      AFTER FIELD amd22
         IF cl_null(tm.amd22) THEN NEXT FIELD amd22 END IF
         SELECT * INTO g_ama.* FROM ama_file where ama01 = tm.amd22
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("sel","ama_file",tm.amd22,"",SQLCA.sqlcode,"","sel ama",1)   #No.FUN-660093
             NEXT FIELD amd22
         END IF
         LET g_ama19 = g_ama.ama21 CLIPPED,g_ama.ama19 CLIPPED
         IF NOT cl_null(g_ama.ama22) THEN
             LET g_ama19 = g_ama19,'-',g_ama.ama22 CLIPPED
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
      LET INT_FLAG = 0 CLOSE WINDOW r401_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
             WHERE zz01='amdr401'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amdr401','9031',1)
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
         CALL cl_cmdat('amdr401',g_time,l_cmd)
      END IF
      CLOSE WINDOW r401_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r401()
   ERROR ""
END WHILE
   CLOSE WINDOW r401_w
END FUNCTION
 
FUNCTION r401()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680074 VARCHAR(20) # External(Disk) file name
          l_sql     STRING,     # RDSQL STATEMENT        #No.FUN-680074
          l_amd25   LIKE amd_file.amd25,
          l_ome21   LIKE oma_file.oma21,   #稅別
          l_ome16   LIKE ome_file.ome16,
          l_oma21   LIKE oma_file.oma21,
          l_oga16   LIKE oga_file.oga16,
          l_oga909  LIKE oga_file.oga909,  #三角貿易出貨否
          l_oea901  LIKE oea_file.oea901,
          l_oma00   LIKE oma_file.oma00,   #帳款性質
          old_oma01 LIKE oma_file.oma01,
          l_amd35   LIKE amd_file.amd35,
          l_amd36   LIKE amd_file.amd36,
          l_amd37   LIKE amd_file.amd37,
          l_amd38   LIKE amd_file.amd38,
          l_amd39   LIKE amd_file.amd39,
          sr        RECORD
                    amd17  LIKE amd_file.amd17,   #待抵代碼
                    amd171 LIKE amd_file.amd171,  #格式
                    amd172 LIKE amd_file.amd172,  #課稅別
                    amd07  LIKE amd_file.amd07,   #扣抵稅額
                    amd08  LIKE amd_file.amd08,   #扣抵金額
                    amd03  LIKE amd_file.amd03,   #發票號碼
                   #amd031 LIKE amd_file.amd03,   #發票聯數       #MOD-AC0006 #MOD-C70050 mark
                    amd04  LIKE amd_file.amd04,   #廠商統一編號   #MOD-650091
                    amd06  LIKE amd_file.amd06,   #含稅金額       #MOD-650091
                    amd44  LIKE amd_file.amd44    #銷售固定資產   #FUN-8B0081 add
                    END RECORD
     DEFINE l_ome35 LIKE ome_file.ome35
     DEFINE l_tot1,l_tot2                                 LIKE type_file.num10
     DEFINE l_tot9,l_tot10                                LIKE type_file.num10
     DEFINE l_tot13,l_tot14                               LIKE type_file.num10
     DEFINE l_tot171,l_tot181                             LIKE type_file.num10
     DEFINE l_tot172,l_tot182                             LIKE type_file.num10
     DEFINE l_tot5,l_tot6                                 LIKE type_file.num10
     DEFINE l_tot28,l_tot36,l_tot401,l_tot402,l_tot32     LIKE type_file.num10
     DEFINE l_tot403,l_tot413,l_tot423,l_tot433           LIKE type_file.num10
     DEFINE l_tot29,l_tot37,l_tot411,l_tot412,l_tot33     LIKE type_file.num10
     DEFINE l_tot30,l_tot38,l_tot421,l_tot422,l_tot34     LIKE type_file.num10
     DEFINE l_tot31,l_tot39,l_tot431,l_tot432,l_tot35     LIKE type_file.num10
     DEFINE l_tot78,l_tot79,l_tot80,l_tot81               LIKE type_file.num10
     DEFINE l_tot25                                       LIKE type_file.num10
     DEFINE l_tot21,l_tot22                               LIKE type_file.num10
     DEFINE l_tot44,l_tot46                               LIKE type_file.num10
     DEFINE l_tot45,l_tot47                               LIKE type_file.num10
     DEFINE l_tot_1,l_tot_2,l_tot_3                       LIKE type_file.num10
     DEFINE l_amd174_b,l_amd174_e,l_pdate_2,l_pdate_3     LIKE type_file.chr2
     DEFINE l_amd173_b,l_pdate_1                          LIKE type_file.chr3
     DEFINE l_sql_27     STRING
     DEFINE g_tot7_27    LIKE type_file.num10     #7:不經海關出口應附證明文件者
     DEFINE g_tot15_27   LIKE type_file.num10     #15:經海關出口免附證明文件者
     DEFINE g_tot19_27   LIKE type_file.num10     #19:零稅率之退回及折讓
     DEFINE g_tot23_27   LIKE type_file.num10
     DEFINE l_tot27      LIKE type_file.num10
     DEFINE l_tot21_27   LIKE type_file.num10
     DEFINE l_tot1_27,l_tot2_27     LIKE type_file.num10
     DEFINE l_tot3_27,l_tot9_27     LIKE type_file.num10
     DEFINE l_tot13_27,l_tot171_27  LIKE type_file.num10
     DEFINE l_tot172_27,l_tot5_27   LIKE type_file.num10
     DEFINE l_tot_1_27,l_tot_2_27,l_tot_3_27  LIKE type_file.num10
     DEFINE l_amd38_27   LIKE amd_file.amd38
     DEFINE l_amd39_27   LIKE amd_file.amd39
     DEFINE l_flag       LIKE type_file.chr1      #MOD-9C0151 add
     DEFINE l_ama15      LIKE ama_file.ama15      #MOD-9C0151 add
     DEFINE sr27    RECORD
                    amd17  LIKE amd_file.amd17,   #待抵代碼
                    amd171 LIKE amd_file.amd171,  #格式
                    amd172 LIKE amd_file.amd172,  #課稅別
                    amd07  LIKE amd_file.amd07,   #扣抵稅額
                    amd08  LIKE amd_file.amd08,   #扣抵金額
                    amd03  LIKE amd_file.amd03,   #發票號碼
                    amd04  LIKE amd_file.amd04,   #廠商統一編號   
                    amd06  LIKE amd_file.amd06,   #含稅金額
                    amd44  LIKE amd_file.amd44    #銷售固定資產
                    END RECORD
    #---------------------------------MOD-C70050--------------------------mark
    #DEFINE l_amt1      LIKE amd_file.amd06      #進貨4收據未稅    #MOD-AC0006
    #DEFINE l_amt1t     LIKE amd_file.amd06      #進貨4收據稅額    #MOD-AC0006
    #DEFINE l_amt1tot   LIKE amd_file.amd06      #進貨未稅金額     #MOD-AC0006
    #DEFINE l_amt1tax   LIKE amd_file.amd06      #進貨稅額         #MOD-AC0006
    #DEFINE l_amt2      LIKE amd_file.amd06      #固資4收據未稅    #MOD-AC0006
    #DEFINE l_amt2t     LIKE amd_file.amd06      #固資4收據稅額    #MOD-AC0006
    #DEFINE l_amt2tot   LIKE amd_file.amd06      #固資未稅金額     #MOD-AC0006
    #DEFINE l_amt2tax   LIKE amd_file.amd06      #固資稅額         #MOD-AC0006
    #---------------------------------MOD-C70050--------------------------mark
#     DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add #No.TQC-C20047 mark 
#     LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add #No.TQC-C20047 mark
     DEFINE l_cnt       LIKE type_file.num5      #MOD-C50042
 
     CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'amdr401'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF

     LET g_str = ''
    #註記欄(總機構彙總報繳l_flag='Y'/分單位分別申報l_flag='N')
     LET l_flag = 'N'
     IF tm.a = 'Y' THEN
        LET l_flag='Y'
     ELSE
        LET l_ama15 = ''
        SELECT ama15 INTO l_ama15 FROM ama_file WHERE ama01=tm.amd22
        IF cl_null(l_ama15) THEN LET l_ama15='0' END IF
       #TQC-A40101---modify---start---                                          
       #IF l_ama15 = '0' OR l_ama15 = '1' THEN                                  
       #   LET l_flag = 'Y'                                                     
       #END IF                                                                  
        IF l_ama15 = '0' THEN                                                   
           LET l_flag = ' '                                                     
        END IF                                                                  
        IF l_ama15 = '1' THEN                                                   
          #LET l_flag = 'Y'  #MOD-C50042 mark
           LET l_flag = 'N'  #MOD-C50042                                                     
        END IF                                                                  
       #TQC-A40101---modify---end---
     END IF
     LET g_str = l_flag

     #-->進銷項
    #LET l_sql = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,amd031,amd04,amd06,'',amd25, ",   #MOD-650091 #FUN-8B0081 add '' #MOD-AC0006 add amd031 #MOD-C70050 mark
     LET l_sql = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,amd04,amd06,'',amd25, ",          #MOD-C70050 del amd031
               "  amd35,amd36,amd37,amd38,amd39 ",
               " FROM amd_file ",
               " WHERE amd173='",tm.amd173_b,"'",
               "   AND (amd174 BETWEEN ",tm.amd174_b," AND ",tm.amd174_e,")",
               "  AND amd172<>'F' AND amd30='Y' "     #不含作廢資料,要確認的才可no:7393#FUN-A10039
     IF tm.a <> 'Y' THEN
        LET l_sql = l_sql ,"   AND amd22 ='",tm.amd22,"'"
     END IF
 
     PREPARE r401_prepare  FROM l_sql
     IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
     DECLARE r401_curs CURSOR FOR r401_prepare
 
    #媒體申報其他資料
     IF tm.a <> 'Y' THEN   #TQC-630076
        SELECT sum(ame04),sum(ame05),sum(ame08),sum(ame06),sum(ame07)   #NO:4231 ame08(免稅貨物)
          INTO g_ame.ame04, g_ame.ame05,g_ame.ame08,g_ame.ame06,g_ame.ame07                       #NO:5181 增sum(ame04),sum(ame05)
          FROM ame_file
         WHERE ame01=tm.amd22 AND ame02 = tm.amd173_b
           AND ame03 BETWEEN tm.amd174_b AND tm.amd174_e
     ELSE
        SELECT sum(ame04),sum(ame05),sum(ame08),sum(ame06),sum(ame07)   #NO:4231 ame08(免稅貨物)
          INTO g_ame.ame04, g_ame.ame05,g_ame.ame08,g_ame.ame06,g_ame.ame07                       #NO:5181 增sum(ame04),sum(ame05)
          FROM ame_file
         WHERE ame02 = tm.amd173_b
           AND ame03 BETWEEN tm.amd174_b AND tm.amd174_e
     END IF
     IF SQLCA.SQLCODE THEN 
        CALL cl_err3("sel","ame_file",tm.amd173_b,"",STATUS,"","sel ame",0)  #No.FUN-660093
      END IF
 
     IF cl_null(g_ame.ame04) THEN LET g_ame.ame04= 0 END IF
     IF cl_null(g_ame.ame05) THEN LET g_ame.ame05 = 0 END IF
     IF cl_null(g_ame.ame08) THEN LET g_ame.ame08 = 0 END IF
     IF cl_null(g_ame.ame06) THEN LET g_ame.ame06 = 0 END IF
     IF cl_null(g_ame.ame07) THEN LET g_ame.ame07 = 0 END IF
 
     LET g_tot7 = 0
     LET g_tot15 = 0
     LET g_tot19 = 0
     LET g_abx =0   #保稅
     CALL r401_sum1()  #計算發票數
     FOREACH r401_curs INTO sr.*,l_amd25,l_amd35,l_amd36,l_amd37,
                            l_amd38,l_amd39
         IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         IF cl_null(sr.amd07) THEN LET sr.amd07=0 END IF
         IF cl_null(sr.amd08) THEN LET sr.amd08=0 END IF
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
          IF (sr.amd171 = '31' OR sr.amd171= '32' OR sr.amd171= '35' OR sr.amd171= '36')
             AND sr.amd172='3'  THEN
             LET g_abx = g_abx + sr.amd08
          END IF
          #考慮是銷貨or折讓(格式33/34)
          IF (sr.amd171 = '33' OR sr.amd171= '34')  AND sr.amd172='3' THEN
             LET g_abx = g_abx - sr.amd08
          END IF
          #g_tot19:零稅率之退回及折讓
          IF (sr.amd171='33' OR sr.amd171='34')  AND sr.amd172='2'  THEN
             LET g_tot19 = g_tot19 + sr.amd08
          END IF
 
          INSERT INTO x VALUES(sr.*)       #No.FUN-710085
 
     END FOREACH
 
     #-->銷項項目
     #1:三聯式發票,電子計算機發票銷售額 2:三聯式發票,電子計算機發票稅額
     SELECT SUM(amd08) INTO l_tot1 FROM x WHERE amd171='31' AND amd172='1'
                                            AND (amd04 <> '00000000' OR amd04 IS NULL)  #CHI-750019
     SELECT SUM(amd07) INTO l_tot2 FROM x WHERE amd171='31' AND amd172='1'
                                            AND (amd04 <> '00000000' OR amd04 IS NULL)  #CHI-750019
 
     #5:收銀機發票(三聯式)銷售額 6:收銀機發票(三聯式)稅額
     SELECT SUM(amd08) INTO l_tot5 FROM x WHERE amd171='35' AND amd172='1'
     SELECT SUM(amd07) INTO l_tot6 FROM x WHERE amd171='35' AND amd172='1'
 
     #9:二聯式發票,收銀機發票(二聯式)銷售額 10:二聯式發票,收銀機發票(二聯式)稅額
     SELECT SUM(amd06) INTO l_tot_1 FROM x WHERE amd171='31' AND amd172='1'
                                             AND amd04 = '00000000'
     IF cl_null(l_tot_1) THEN LET l_tot_1 = 0 END IF
     SELECT SUM(amd06) INTO l_tot_2 FROM x WHERE amd171='32' AND amd172='1'
     IF cl_null(l_tot_2) THEN LET l_tot_2 = 0 END IF
     LET l_tot_3 = l_tot_1 + l_tot_2
     LET l_tot9 = cl_digcut(l_tot_3 / 1.05,0)
     LET l_tot10 = l_tot_3 - l_tot9
 
     #13:免用發票
     SELECT SUM(amd08) INTO l_tot13 FROM x WHERE amd171='36' AND amd172='1'
     SELECT SUM(amd07) INTO l_tot14 FROM x WHERE amd171='36' AND amd172='1'
 
     #171:三聯式退回及折讓銷售額 172:二聯式退回及折讓銷售額
     SELECT SUM(amd08) INTO l_tot171 FROM x WHERE amd171='33' AND amd172='1'
     SELECT SUM(amd08) INTO l_tot172 FROM x WHERE amd171='34' AND amd172='1'
 
     #181:三聯式退回及折讓稅額 182:二聯式退回及折讓稅額
     SELECT SUM(amd07) INTO l_tot181 FROM x WHERE amd171='33' AND amd172='1'   #MOD-830129
     SELECT SUM(amd07) INTO l_tot182 FROM x WHERE amd171='34' AND amd172='1'   #MOD-830129
 
     #-->進項項目:得扣抵進項稅額
     #28:統一發票扣抵聯(包括電子計算機)進貨及費用金額
     SELECT SUM(amd08) INTO l_tot28 FROM x WHERE (amd171='21' OR amd171='26')
                                             AND  amd17 ='1' AND amd172='1'
     #30:統一發票扣抵聯(包括電子計算機)固定資產金額
     SELECT SUM(amd08) INTO l_tot30 FROM x WHERE (amd171='21' OR amd171='26')
                                             AND  amd17 ='2' AND amd172='1'
     #32:載有稅額其他憑證(包括二聯式收銀)進貨及費用金額
     SELECT SUM(amd08) INTO l_tot32 FROM x WHERE amd171='25' AND amd17 ='1'
                                             AND amd172='1'
     #34:載有稅額其他憑證(包括二聯式收銀)固定資產金額
     SELECT SUM(amd08) INTO l_tot34 FROM x WHERE amd171='25' AND amd17 ='2'
                                             AND amd172='1'
     #36:載有稅額其他憑證(包括二聯式收銀)進資及費用金額 
    #MOD-D30096--
     SELECT SUM(amd08) INTO l_tot36 FROM x WHERE (amd171='22' OR amd171='27')
                                             AND  amd17 ='1' AND amd172='1'
    #MOD-D30096--
   #----------------------------------MOD-C70050-----------------------mark
   ##-MOD-AC0006-add-
   # LET l_amt1    = 0
   # LET l_amt1t   = 0
   # LET l_amt1tot = 0
   # LET l_amt1tax = 0
   ##SELECT SUM(amd08) INTO l_tot36 FROM x WHERE (amd171='22' OR amd171='27')
   ##                                        AND  amd17 ='1' AND amd172='1'
   # SELECT SUM(amd07),SUM(amd08) INTO l_amt1t,l_amt1 
   #   FROM x 
   #  WHERE (amd171='22' OR amd171='27')
   #    AND  amd17 ='1' AND amd031='4'
   # IF cl_null(l_amt1)  THEN LET l_amt1=0  END IF
   # IF cl_null(l_amt1t) THEN LET l_amt1t=0 END IF

   # SELECT SUM(amd07+amd08) INTO l_amt1tot 
   #   FROM x 
   #  WHERE (amd171='22' OR amd171='27')
   #    AND  amd17 ='1' AND amd031<>'4'
   # IF cl_null(l_amt1tot) THEN LET l_amt1tot=0 END IF

   # CALL cl_digcut(((l_amt1tot/1.05)*0.05),0) RETURNING l_amt1tax 
   # CALL cl_digcut((l_amt1tot/1.05),0) RETURNING l_amt1tot 
   # CALL cl_digcut(l_amt1,0) RETURNING  l_amt1 
   # CALL cl_digcut(l_amt1t,0) RETURNING  l_amt1t 
   # LET l_tot36 = l_amt1tot + l_amt1  

   # #37:載有稅額其他憑證(包括二聯式收銀)進貨及費用稅額
   # LET l_tot37 = l_amt1tax + l_amt1t  

   # LET l_amt2    = 0
   # LET l_amt2t   = 0
   # LET l_amt2tot = 0
   # LET l_amt2tax = 0
   # #38:載有稅額其他憑證(包括二聯式收銀)固定資產金額
   ##SELECT SUM(amd08) INTO l_tot38 FROM x WHERE (amd171='22' OR amd171='27')
   ##                                        AND  amd17 ='2' AND amd172='1'
   # SELECT SUM(amd07),SUM(amd08) INTO l_amt2t,l_amt2 
   #   FROM x 
   #  WHERE (amd171='22' OR amd171='27')
   #    AND  amd17 ='2' AND amd031='4'
   # IF cl_null(l_amt2)  THEN LET l_amt2=0  END IF
   # IF cl_null(l_amt2t) THEN LET l_amt2t=0 END IF
   
   # SELECT SUM(amd07+amd08) INTO l_amt2tot 
   #   FROM x 
   #  WHERE (amd171='22' OR amd171='27')
   #    AND  amd17 ='2' AND amd031<>'4'
   # IF cl_null(l_amt2tot) THEN LET l_amt2tot=0 END IF

   # CALL cl_digcut(((l_amt2tot/1.05)*0.05),0) RETURNING l_amt2tax 
   # CALL cl_digcut((l_amt2tot/1.05),0) RETURNING l_amt2tot 
   # CALL cl_digcut(l_amt2,0) RETURNING  l_amt2 
   # CALL cl_digcut(l_amt2t,0) RETURNING  l_amt2t 
   # LET l_tot38 = l_amt2tot + l_amt2  

   # #39:載有稅額其他憑證(包括二聯式收銀)固定資產稅額
   # LET l_tot39 = l_amt2tax + l_amt2t  
   ##-MOD-AC0006-end-
   #----------------------------------MOD-C70050-----------------------mark
     #78:海關代徵營業稅繳納證扣抵聯進貨及費用稅額
     SELECT SUM(amd08) INTO l_tot78 FROM x WHERE amd171='28' AND amd17 ='1'
                                             AND amd172='1'
     #80:海關代徵營業稅繳納證扣抵聯固定資產稅額
     SELECT SUM(amd08) INTO l_tot80 FROM x WHERE amd171='28' AND amd17 ='2'
                                             AND amd172='1'
     #401:三聯式退出及折讓進貨及費用金額
     SELECT SUM(amd08) INTO l_tot401 FROM x WHERE amd171='23' AND amd17 ='1'
                                              AND amd172='1'
     #402:二聯式退出及折讓進貨及費用金額
     SELECT SUM(amd08) INTO l_tot402 FROM x WHERE amd171='24' AND amd17 ='1'
                                              AND amd172='1'
     #403:格式29 bug no:7393
     SELECT SUM(amd08) INTO l_tot403 FROM x WHERE amd171='29' AND amd17 ='1'
                                              AND amd172='1'
     #421:三聯式退出及折讓固定資產金額
     SELECT SUM(amd08) INTO l_tot421 FROM x WHERE amd171='23' AND amd17 ='2'
                                              AND amd172='1'
     #422:二聯式退出及折讓固定資產金額
     SELECT SUM(amd08) INTO l_tot422 FROM x WHERE amd171='24' AND amd17 ='2'
                                              AND amd172='1'
     #423:格式29  bug no:7393
     SELECT SUM(amd08) INTO l_tot423 FROM x WHERE amd171='29' AND amd17 ='2'
                                              AND amd172='1'
 
     #29:統一發票扣抵聯(包括電子計算機)進貨及費用稅額
     SELECT SUM(amd07) INTO l_tot29 FROM x WHERE (amd171='21' OR amd171='26')
                                             AND  amd17 ='1' AND amd172='1'
     #31:統一發票扣抵聯(包括電子計算機)固定資產稅額
     SELECT SUM(amd07) INTO l_tot31 FROM x WHERE amd171='21' AND amd17 ='2'
                                             AND amd172='1'
     #33:載有稅額其他憑證(包括二聯式收銀)進貨及費用稅額
     SELECT SUM(amd07) INTO l_tot33 FROM x WHERE amd171='25' AND amd17 ='1'
                                             AND amd172='1'
     #35:載有稅額其他憑證(包括二聯式收銀)固定資產稅額
     SELECT SUM(amd07) INTO l_tot35 FROM x WHERE amd171='25' AND amd17 ='2'
                                             AND amd172='1'
     #37:載有稅額其他憑證(包括二聯式收銀)進貨及費用稅額
     SELECT SUM(amd07) INTO l_tot37 FROM x WHERE (amd171='22' OR amd171='27') #MOD-AC0006 mark #MOD-C70050 remark
                                             AND  amd17 ='1' AND amd172='1'   #MOD-AC0006 mark #MOD-C70050 remark
     #39:載有稅額其他憑證(包括二聯式收銀)固定資產稅額
     SELECT SUM(amd07) INTO l_tot39 FROM x WHERE amd171='22' AND amd17='2'    #MOD-AC0006 mark #MOD-C70050 remark
                                             AND amd172='1'                   #MOD-AC0006 mark #MOD-C70050 remark
     #79:海關代徵營業稅繳納證扣抵聯進貨及費用稅額
     SELECT SUM(amd07) INTO l_tot79 FROM x WHERE amd171='28' AND amd17='1'
                                             AND amd172='1'
     #81:海關代徵營業稅繳納證扣抵聯固定資產稅額
     SELECT SUM(amd07) INTO l_tot81 FROM x WHERE amd171='28' AND amd17='2'
                                             AND amd172='1'
     #411:三聯式退出及折讓進貨及費用稅額
     SELECT SUM(amd07) INTO l_tot411 FROM x WHERE amd171='23' AND amd17='1'
                                              AND amd172='1'
     #412:二聯式退出及折讓進貨及費用稅額
     SELECT SUM(amd07) INTO l_tot412 FROM x WHERE amd171='24' AND amd17='1'
                                              AND amd172='1'
     #413:格式29 bug no:7393
     SELECT SUM(amd07) INTO l_tot413 FROM x WHERE amd171='29' AND amd17='1'
                                              AND amd172='1'
     #431:三聯式退出及折讓固定資產稅額
     SELECT SUM(amd07) INTO l_tot431 FROM x WHERE amd171='23' AND amd17='2'
                                              AND amd172='1'
     #432:二聯式退出及折讓固定資產稅額
     SELECT SUM(amd07) INTO l_tot432 FROM x WHERE amd171='24' AND amd17='2'
                                              AND amd172='1'
     #433:格式29 bug no:7393
     SELECT SUM(amd07) INTO l_tot433 FROM x WHERE amd171='29' AND amd17='2'
                                              AND amd172='1'
 
     #48:讀取進項免稅/零稅之金額
     SELECT SUM(amd08) INTO g_tot48 FROM x WHERE amd171 MATCHES '2*'
                                             AND amd171<>'23' AND amd171<>'24' AND amd171<>'29'  #CHI-750019
                                             AND (amd17='1' OR amd17='3')
     #49:讀取進項免稅/零稅之稅額
     SELECT SUM(amd08) INTO g_tot49 FROM x WHERE amd171 MATCHES '2*'
                                             AND amd171<>'23' AND amd171<>'24' AND amd171<>'29'  #CHI-750019
                                             AND (amd17='2' OR amd17='4')
     #l_48:讀取免稅/零稅率折讓金額
     LET l_tot48=0  LET l_tot49=0
     SELECT SUM(amd08) INTO l_tot48 FROM x WHERE (amd171='23' OR amd171='24' OR amd171='29')   #CHI-750019
                                             AND (amd17='1' OR amd17='3')
     IF cl_null(l_tot48) THEN LET l_tot48=0 END IF
     #l_49:讀取免稅/零稅率折讓稅額
     SELECT SUM(amd08) INTO l_tot49 FROM x WHERE (amd171='23' OR amd171='24' OR amd171='29')   #CHI-750019
                                             AND (amd17='2' OR amd17='4')
     IF cl_null(l_tot49) THEN LET l_tot49=0 END IF
 
     #48:進項總金額進貨及費用(進貨及費用零稅/免稅金額-零稅率進貨及費用折讓金額)
     LET g_tot48 = g_tot48 - l_tot48   
     #49:進項總金額固定資產(固定資產零稅/免稅金額-零稅率固定資產折讓金額)
     LET g_tot49 = g_tot49 - l_tot49   
 
     IF cl_null(g_tot48) THEN LET g_tot48 = 0 END IF
     IF cl_null(g_tot49) THEN LET g_tot49 = 0 END IF
     IF cl_null(l_tot1) THEN LET l_tot1=0 END IF
     IF cl_null(l_tot2) THEN LET l_tot2=0 END IF
     IF cl_null(l_tot9) THEN LET l_tot9=0 END IF
     IF cl_null(l_tot10) THEN LET l_tot10=0 END IF
     IF cl_null(l_tot13) THEN LET l_tot13=0 END IF
     IF cl_null(l_tot14) THEN LET l_tot14=0 END IF
     IF cl_null(l_tot171) THEN LET l_tot171=0 END IF
     IF cl_null(l_tot181) THEN LET l_tot181=0 END IF
     IF cl_null(l_tot172) THEN LET l_tot172=0 END IF
     IF cl_null(l_tot182) THEN LET l_tot182=0 END IF
     IF cl_null(l_tot5) THEN LET l_tot5=0 END IF
     IF cl_null(l_tot6) THEN LET l_tot6=0 END IF
 
     IF cl_null(l_tot28) THEN LET l_tot28=0 END IF
     IF cl_null(l_tot30) THEN LET l_tot30=0 END IF
     IF cl_null(l_tot36) THEN LET l_tot36=0 END IF
     IF cl_null(l_tot38) THEN LET l_tot38=0 END IF
     IF cl_null(l_tot78) THEN LET l_tot78=0 END IF
     IF cl_null(l_tot80) THEN LET l_tot80=0 END IF
     IF cl_null(l_tot401) THEN LET l_tot401=0 END IF
     IF cl_null(l_tot402) THEN LET l_tot402=0 END IF
     IF cl_null(l_tot403) THEN LET l_tot403=0 END IF
     IF cl_null(l_tot421) THEN LET l_tot421=0 END IF
     IF cl_null(l_tot422) THEN LET l_tot422=0 END IF
     IF cl_null(l_tot423) THEN LET l_tot423=0 END IF
     IF cl_null(l_tot32) THEN LET l_tot32=0 END IF
     IF cl_null(l_tot34) THEN LET l_tot34=0 END IF
     IF cl_null(l_tot29) THEN LET l_tot29=0 END IF
     IF cl_null(l_tot31) THEN LET l_tot31=0 END IF
     IF cl_null(l_tot37) THEN LET l_tot37=0 END IF
     IF cl_null(l_tot39) THEN LET l_tot39=0 END IF
     IF cl_null(l_tot79) THEN LET l_tot79=0 END IF
     IF cl_null(l_tot81) THEN LET l_tot81=0 END IF
     IF cl_null(l_tot411) THEN LET l_tot411=0 END IF
     IF cl_null(l_tot412) THEN LET l_tot412=0 END IF
     IF cl_null(l_tot413) THEN LET l_tot413=0 END IF
     IF cl_null(l_tot431) THEN LET l_tot431=0 END IF
     IF cl_null(l_tot432) THEN LET l_tot432=0 END IF
     IF cl_null(l_tot433) THEN LET l_tot433=0 END IF
     IF cl_null(l_tot33) THEN LET l_tot33=0 END IF
     IF cl_null(l_tot35) THEN LET l_tot35=0 END IF
 
     #21(銷售額合計):31+35+32-退折
     LET l_tot21=l_tot1+l_tot9+l_tot13-l_tot171-l_tot172+l_tot5
     #22(稅額合計):31+35+32-退折
     LET l_tot22=l_tot2+l_tot10+l_tot14-l_tot181-l_tot182+l_tot6
 
     #44(進貨及費用進項金額):21+25+22-(23+24)
     LET l_tot44 = l_tot28+l_tot36-l_tot401-l_tot402-l_tot403+l_tot32+l_tot78
     #45(進貨及費用進項稅額):21+25+22-(23+24)
     LET l_tot45 = l_tot29+l_tot37-l_tot411-l_tot412-l_tot413+l_tot33+l_tot79
     #46(固定資產進項金額):21+25+22-(23+24)
     LET l_tot46 = l_tot30+l_tot38-l_tot421-l_tot422-l_tot423+l_tot34+l_tot80
     #47(固定資產進項稅額):21+25+22-(23+24)
     LET l_tot47 = l_tot31+l_tot39-l_tot431-l_tot432-l_tot433+l_tot35+l_tot81
 
     #23(零稅率銷售額合計):非經海關+經海關 - 退折
     LET g_tot23 = g_tot7 + g_tot15 - g_tot19
     #48(進項總金額進貨及費用):淨額+進貨及費用合計
     #LET g_tot48 = g_tot48 + l_tot44   #CHI-750019
     #49(進項總金額進貨及費用):淨額+固定資產合計
     #LET g_tot49 = g_tot49 + l_tot46   #CHI-750019
     #101:本月銷項稅額合計(=22:銷項稅額合計)
     LET g_tot101 = l_tot22
     #107:得扣抵進項稅額合計(進項進貨及費用稅額合計+進項固定資產稅額合計)
     LET g_tot107 = l_tot45+l_tot47
     #108:上期(月)累積留抵稅額(=ame07)
     LET g_tot108 = g_ame.ame07
     #110:小計(107+108->得扣抵進項稅額合計+上期(月)累積留抵稅額)
     LET g_tot110 = g_tot107 + g_tot108
     #111:本期(月)應實繳稅額(101-110)
     LET g_tot111 = g_tot101 - g_tot110
     IF g_tot111 <0 THEN LET g_tot111=0 END IF
     
     IF g_tot111 > 0 THEN 
        LET g_tot112 = 0      
        LET g_tot113 = 0   
        LET g_tot114 = 0   
        LET g_tot115 = 0
     ELSE
        #112:本期(月)申報留抵稅額(110-101)
        LET g_tot112 = g_tot110 - g_tot101
        IF g_tot112 <0 THEN LET g_tot112=0 END IF
        #113:得退稅額合計(23*0.05+47->
        #                        零稅率銷售額合計*0.05+進項固定資產得扣抵稅額合計)
        LET g_tot113 = g_tot23 * 0.05 + l_tot47
        LET g_tot113 = cl_digcut(g_tot113,0)
        IF g_tot113 < 0 THEN LET g_tot113 = 0 END IF   #No.TQC-CB0052   Add
        #114:本期(月)應退稅額: if 12>13=13 ,if 12<13=12)
        IF g_tot112 > g_tot113 THEN
           LET g_tot114 = g_tot113
        ELSE
           LET g_tot114 = g_tot112
        END IF
        #115:本期(月)累積留抵稅額(112-114)
        LET g_tot115 = g_tot112 - g_tot114
     END IF          #MOD-930145   
 
     LET l_amd173_b = tm.amd173_b - 1911 USING '&&&'  #No.MOD-870303
     LET l_amd174_b = tm.amd174_b
     LET l_amd174_e = tm.amd174_e
     LET l_pdate_1  = YEAR(tm.pdate)-1911 USING '&&&' #No.MOD-870303
     LET l_pdate_2  = MONTH(tm.pdate)
     LET l_pdate_3  = DAY(tm.pdate)
 
     LET l_tot25 = l_tot21 + g_tot23  #MOD-930142
     
     LET l_sql_27 = "SELECT amd17,amd171,amd172,amd07,amd08,amd03,amd04,amd06,amd44 ", 
                    "       amd38,amd39 ",
                    "  FROM amd_file ",
                    " WHERE amd173='",tm.amd173_b,"'",
                    "   AND (amd174 BETWEEN ",tm.amd174_b," AND ",tm.amd174_e,")",
                    "   AND amd172<>'F' AND amd30='Y' AND amd44<>'3' " #FUN-A10039
     IF tm.a <> 'Y' THEN
        LET l_sql_27 = l_sql_27 ,"   AND amd22 ='",tm.amd22,"'"
     END IF
     
     PREPARE r401_prepare_27  FROM l_sql_27
     IF SQLCA.SQLCODE THEN CALL cl_err('prepare',STATUS,0) END IF
     DECLARE r401_curs_27 CURSOR FOR r401_prepare_27
     
     LET g_tot7_27 = 0
     LET g_tot15_27 = 0
     LET g_tot19_27 = 0
     LET g_tot23_27 = 0
     
     FOREACH r401_curs_27 INTO sr27.*,l_amd38_27,l_amd39_27
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
     
     SELECT SUM(amd08) INTO l_tot1_27 FROM x
      WHERE amd171='31' AND amd172='1'
        AND (amd04 <> '00000000' OR amd04 IS NULL) and amd44 <> '3'
     IF cl_null(l_tot1_27) THEN LET l_tot1_27 = 0 END IF   
     #9:二聯式發票,收銀機發票(二聯式)銷售額 10:二聯式發票,收銀機發票(二聯式)稅額
     SELECT SUM(amd06) INTO l_tot_1_27 FROM x 
      WHERE amd171='31' AND amd172='1'
        AND amd04 = '00000000' AND amd44 <> '3'
     IF cl_null(l_tot_1_27) THEN LET l_tot_1_27 = 0 END IF
     SELECT SUM(amd06) INTO l_tot_2_27 FROM x 
      WHERE amd171='32' AND amd172='1' AND amd44 <> '3'
     IF cl_null(l_tot_2_27) THEN LET l_tot_2_27 = 0 END IF
     LET l_tot_3_27 = l_tot_1_27 + l_tot_2_27
     LET l_tot9_27 = cl_digcut(l_tot_3_27 / 1.05,0)
     #13:免用發票
     SELECT SUM(amd08) INTO l_tot13_27 FROM x 
      WHERE amd171='36' AND amd172='1' AND amd44 <> '3'
     IF cl_null(l_tot13_27) THEN LET l_tot13_27 = 0 END IF 
     #171:三聯式退回及折讓銷售額 172:二聯式退回及折讓銷售額
     SELECT SUM(amd08) INTO l_tot171_27 FROM x 
      WHERE amd171='33' AND amd172='1' AND amd44 <> '3'
     IF cl_null(l_tot171_27) THEN LET l_tot171_27 = 0 END IF    
     SELECT SUM(amd08) INTO l_tot172_27 FROM x
      WHERE amd171='34' AND amd172='1' AND amd44 <> '3'
     IF cl_null(l_tot172_27) THEN LET l_tot172_27 = 0 END IF    
     #5:收銀機發票(三聯式)銷售額 
     SELECT SUM(amd08) INTO l_tot5_27 FROM x
      WHERE amd171='35' AND amd172='1' AND amd44 <> '3'
     IF cl_null(l_tot5_27) THEN LET l_tot5_27 = 0 END IF    
     
     LET l_tot21_27 =l_tot1_27+l_tot9_27+l_tot13_27-l_tot171_27-l_tot172_27+l_tot5_27
     LET g_tot23_27 = g_tot7_27 + g_tot15_27 - g_tot19_27
     LET l_tot27 = l_tot21_27 + g_tot23_27
          
     EXECUTE insert_prep USING g_abx,g_ama.ama02,g_ama.ama03,
                               g_ama.ama05,g_ama.ama07,g_ama.ama11,
                               l_amd173_b,l_amd174_b,l_amd174_e,
                               g_ame.ame04,g_ame.ame05,g_ame.ame06,
                               g_ame.ame08,g_inv_all,l_pdate_1,
                               l_pdate_2,l_pdate_3,l_tot1,l_tot10,
                               g_tot101,g_tot107,g_tot108,g_tot110,
                               g_tot111,g_tot112,g_tot113,g_tot114,
                               g_tot115,l_tot13,l_tot14,g_tot15,
                               l_tot171,l_tot172,l_tot181,l_tot182,
                               g_tot19,l_tot2,l_tot21,l_tot22,g_tot23,
                               l_tot25,l_tot28,l_tot29,l_tot30,l_tot31,
                               l_tot32,l_tot33,l_tot34,l_tot35,l_tot36,
                               l_tot37,l_tot38,l_tot39,l_tot401,l_tot402,
                               l_tot403,l_tot411,l_tot412,l_tot413,l_tot421,
                               l_tot422,l_tot423,l_tot431,l_tot432,l_tot433,
                               l_tot44,l_tot45,l_tot46,l_tot47,g_tot48,
                               g_tot49,l_tot5,l_tot6,g_tot7,l_tot78,l_tot79,
                               l_tot80,l_tot81,l_tot9,
                               #g_ama.ama17,g_ama.ama18,g_ama.ama19,    #FUN-970106
                               g_ama.ama17,g_ama.ama18,g_ama19,         #FUN-970106  #FUN-980024
                               g_ama.ama20,g_ama.ama16,l_tot27         #FUN-970106  #FUN-8B0081 add l_tot27
#                               ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add  #No.TQC-C20047 mark

   #MOD-C50042---S---          
    SELECT count(*) INTO l_cnt FROM ama_file WHERE ama15 = '1'
    LET g_str = g_str,";",l_cnt
   #MOD-C50042---E---
 
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    IF tm.t = "1" THEN
      LET l_name = "amdr401"
    ELSE
      LET l_name = "amdr401_2"
    END IF
#   LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add #No.TQC-C20047 mark
#   LET g_cr_apr_key_f = "abx|ama02"       #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add #No.TQC-C20047 mark 
     CALL cl_prt_cs3('amdr401',l_name,l_sql,g_str)  #MOD-9C0151 mod
 
 
END FUNCTION
 
FUNCTION r401_sum1()  # 計算發票數
 
  IF tm.a <> 'Y' THEN   #TQC-630076
     SELECT count(*) INTO g_inv_all FROM amd_file
      WHERE amd173 = tm.amd173_b
        AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
        AND amd22 = tm.amd22 AND amd171 MATCHES '3*'
        AND amd171<>'36'     #不含虛擬發票
        AND amd171<>'33'     #NO:4276
        AND amd171<>'34'
        AND amd172<>'F'      #No.B589..010524 by plum add #FUN-A10039
        AND amd30='Y'        #No.7393
  ELSE
     SELECT count(*) INTO g_inv_all FROM amd_file
      WHERE amd173 = tm.amd173_b
        AND amd174 BETWEEN tm.amd174_b  AND tm.amd174_e
        AND amd171 MATCHES '3*'
        AND amd171<>'36'     #不含虛擬發票
        AND amd171<>'33'     #NO:4276
        AND amd171<>'34'
        AND amd172<>'F'      #No.B589..010524 by plum add #FUN-A10039
        AND amd30='Y'        #No.7393
  END IF
 
  IF SQLCA.SQLCODE THEN 
     CALL cl_err3("sel","amd_file","","",STATUS,"","sel oma",0)  #No.FUN-660093
   END IF
 
  IF cl_null(g_inv_all) THEN LET g_inv_all = 0    END IF
  IF cl_null(g_inv1) THEN LET g_inv1 = 0          END IF
  IF cl_null(g_inv2) THEN LET g_inv2 = 0          END IF
  IF cl_null(g_inv3) THEN LET g_inv3 = 0          END IF
  LET g_inv4 = 1      ##  固定印 1
 
END FUNCTION
 
 
FUNCTION r401_set_entry()
  CALL cl_set_comp_entry("amd22",TRUE)
END FUNCTION
 
FUNCTION r401_set_no_entry()
  CALL cl_set_comp_entry("amd22",FALSE)
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
