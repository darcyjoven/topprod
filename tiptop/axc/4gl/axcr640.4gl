# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axcr640.4gl
# Descriptions...: 在製品跌價損失分析表
# Input parameter:
# Return code....:
# Date & Author..: 99/03/30 By plum
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.MOD-570083 05/07/05 By kim 沒有進行單位換算(tlf10->tlf10*tlf60)
# Modify.........: No.FUN-580014 05/08/02 By vivien 2.0憑証類報表修改,轉XML格式
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-710021 07/01/26 By pengu 列印內容錯誤,合計部分位置錯誤
# Mofify.........: No.FUN-7C0101 08/01/25 By lala 成本改善增加成本計算類型(type)
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.FUN-970102 09/08/12 By jan 1.移除k1欄位 2.銷售費用率改抓cma32
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-C30190 12/03/16 By yangxf 将原报表转换为CR报表
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc            STRING,              # Where Condition #TQC-630166
              type          LIKE type_file.chr1,           #No.FUN-7C0101CHAR(1)
              yy      LIKE type_file.num5,          #FUN-8B0047
              mm      LIKE type_file.num5,          #FUN-8B0047
              bdate         LIKE type_file.dat,            #No.FUN-680122DATE                # 比較基準日
              i10           LIKE type_file.num10,          #No.FUN-680122INTGER             # 呆滯天數起始天數
              i11           LIKE type_file.num10,          #No.FUN-680122INTGER             # 呆滯天數截止天數
             #k1            LIKE cmz_file.cmz02,    #No.FUN-680122DEC(5,2)#FUN-970102 mark # 銷售費用率
              a             LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01)            # 資料排序 1.work order 2.item
              more          LIKE type_file.chr1            # Prog. Version..: '5.30.06-13.03.12(01)             # 特殊列印條件
              END RECORD,
          g_cmz01           LIKE cmz_file.cmz01,
          g_cmz02           LIKE cmz_file.cmz02,
          g_cmz   RECORD LIKE cmz_file.*,
          l_name            LIKE type_file.chr20          #No.FUN-680122CHAR(20)           # External(Disk) file name
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_head1         LIKE type_file.chr1000        #No.FUN-680122CHAR(400)
DEFINE   l_table         STRING                 #FUN-C30190 add
DEFINE   g_sql           STRING                 #FUN-C30190 add
DEFINE   g_str           STRING                 #FUN-C30190 add
DEFINE   g_wc            STRING                 #FUN-C30190 add

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                             # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
 
   LET g_pdate  = ARG_VAL(1)                   # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate  = ARG_VAL(8)
   LET tm.i10   = ARG_VAL(9)
   LET tm.i11   = ARG_VAL(10)
  #LET tm.k1    = ARG_VAL(11)  #FUN-970102
   LET tm.a     = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(15)          #FUN-7C0101
   LET tm.yy      = ARG_VAL(16) #FUN-8B0047
   LET tm.mm      = ARG_VAL(17) #FUN-8B0047
 
#FUN-C30190 add begin ---
   LET g_sql = "order1.type_file.chr20,",
               "order2.type_file.chr20,",
               "cma04.cma_file.cma04,",
               "ccg01.ccg_file.ccg01,",
               "ccg04.ccg_file.ccg04,",
               "ccg07.ccg_file.ccg07,",
               "sfb08.sfb_file.sfb08,",
               "fdate.type_file.dat,",
               "qty1.sfb_file.sfb08,",
               "ccg91.ccg_file.ccg91,",
               "ccg92.ccg_file.ccg92,",
               "amt.ccg_file.ccg92,",
               "cma14.cma_file.cma14,",
               "amt1.ccg_file.ccg92,",
               "amt2.ccg_file.ccg92,",
               "cma05.cma_file.cma05,",
               "l_cma32.cma_file.cma32"
   LET l_table = cl_prt_temptable('axcr640',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
#FUN-C30190 add end ---
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'            # If background job sw is off
      THEN CALL r640_tm(0,0)                    # Input print condition
      ELSE CALL r640()
   END IF
   DROP TABLE axcr640_temp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r640_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_count LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE l_correct   LIKE type_file.chr1 #FUN-8B0047
   DEFINE l_date      LIKE type_file.dat  #FUN-8B004
 
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 6 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 6
   END IF
   OPEN WINDOW r640_w AT p_row,p_col
        WITH FORM "axc/42f/axcr640"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
  #FUN-970102--begin--mark--
  #SELECT cmz01,cmz02 INTO g_cmz01,g_cmz02 FROM cmz_file
  #IF NOT cl_null(g_cmz01) THEN
  #   LET tm.bdate=g_cmz01
  #ELSE
  #   LET tm.bdate   = g_today
  #END IF
  #IF NOT cl_null(g_cmz02) THEN
  #   LET tm.k1=g_cmz02
  #END IF
  #FUN-970102--end--mark
   LET tm.a      = '1'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
   LET tm.type   = g_ccz.ccz28   #No.FUN-7C0101
 
   LET tm.yy    = g_ccz.ccz01 #FUN-8B0047
   LET tm.mm    = g_ccz.ccz02 #FUN-8B0047
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.bdate #FUN-970102
 
WHILE TRUE
   CONSTRUCT BY NAME  tm.wc ON ccg01
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ccguser', 'ccggrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
#  IF tm.wc =  " 1=1" THEN
#     CALL cl_err('','9046',0)
#     CONTINUE WHILE
#   END IF
 
   LET tm.i10=0   LET tm.i11=90
  #DISPLAY BY NAME tm.bdate,tm.i10,tm.i11,tm.k1,tm.a,tm.more   #FUN-970102
   DISPLAY BY NAME tm.bdate,tm.i10,tm.i11,tm.a,tm.more         #FUN-970102
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r640_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
 
   CALL cl_set_comp_entry('bdate',FALSE) #FUN-8B0047
  #INPUT tm.type,tm.yy,tm.mm,tm.bdate,tm.i10,tm.i11,tm.k1,tm.a,tm.more  #No.FUN-7C0101 add tm.type #FUN-8B0047#FUN-970102 mark
   INPUT tm.type,tm.yy,tm.mm,tm.bdate,tm.i10,tm.i11,tm.a,tm.more  #No.FUN-7C0101 add tm.type #FUN-8B0047 #FUN-970102 
         WITHOUT DEFAULTS FROM
         type,yy,mm, bdate,i10,i11,a,more   #No.FUN-7C0101 add type #FUN-8B0047 #FUN-970102拿掉k1
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
      
      #No.FUN-7C0101--start--
      AFTER FIELD type
         IF cl_null(tm.type) OR tm.type NOT MATCHES '[12345]' THEN
            NEXT FIELD type
         END IF
      #No.FUN-7C0101---end---
 
         #FUN-8B0047
         AFTER FIELD yy
            IF NOT cl_null(tm.yy) THEN
               IF tm.yy < 0 THEN
                  CALL cl_err('','mfg5034',0)
                  NEXT FIELD yy
               END IF
            END IF
 
         AFTER FIELD mm
            IF NOT cl_null(tm.mm) THEN
               IF tm.mm < 1 OR tm.mm > 12 THEN
                  CALL cl_err('','aom-580',0)
                  NEXT FIELD mm
               END IF
               CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.bdate
               DISPLAY BY NAME tm.bdate
            END IF
         #--
 
      
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD i10    #起始呆滯天數
         IF tm.i10 IS NULL THEN NEXT FIELD i10 END IF
 
      AFTER FIELD i11    #截止呆滯天數
         IF NOT cl_null(tm.i11)  AND cl_null(tm.i11) THEN
            NEXT FIELD i11
         END IF
         IF tm.i11 < tm.i10 THEN NEXT FIELD i11 END IF
 
     #FUN-970102--begin--mark--
     #AFTER FIELD k1     #截止呆滯天數
     #   IF cl_null(tm.k1)  OR tm.k1 <0 THEN
     #      NEXT FIELD k1
     #   END IF
     #FUN-970102--end--mark--
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      AFTER INPUT
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG 
         CALL cl_cmdask()        # Command execution
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
      #MOD-860081------add-----str---
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       
       ON ACTION about         
          CALL cl_about()      
       
       ON ACTION help          
          CALL cl_show_help()  
      #MOD-860081------add-----end---
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r640_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr640'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr640','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",    #No.FUN-7C0101
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.i10 CLIPPED,"'",
                         " '",tm.i11 CLIPPED,"'",
                        #" '",tm.k1  CLIPPED,"'",  #FUN-970102
                         " '",tm.a   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",tm.yy   CLIPPED,"'", #FUN-8B0047
                         " '",tm.mm   CLIPPED,"'" #FUN-8B0047
 
          CALL cl_cmdat('axcr640',g_time,l_cmd)  # Execute cmd at later time
      END IF
      CLOSE WINDOW r640_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r640()
   ERROR ""
END WHILE
CLOSE WINDOW r640_w
END FUNCTION
 
FUNCTION r640()
   DEFINE
#       l_time          LIKE type_file.chr8         #No.FUN-6A0146
          l_sql      LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_date     LIKE type_file.dat,            #No.FUN-680122DATE
          l_delay    LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_sfm      RECORD LIKE sfm_file.*,
          l_tlf10            LIKE tlf_file.tlf10,    #已入庫量
          l_flag     LIKE type_file.chr1,        #是否為90天        #No.FUN-680122 VARCHAR(1)
          sr         RECORD
                     order1  LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
                     order2  LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
                     cma04   LIKE cma_file.cma04,    #ABC
                     ccg01   LIKE ccg_file.ccg01,    #工單
                     ccg04   LIKE ccg_file.ccg04,    #料號
                     ccg07   LIKE ccg_file.ccg07,    #No.FUN-7C0101
                     sfb08   LIKE sfb_file.sfb08,    #開工批量:sfb08
                     fdate   LIKE type_file.dat,            #No.FUN-680122DATE                   #開工日期:min(tlf06)
                     qty1    LIKE sfb_file.sfb08,    #末存批量=sfb08-sum(tlf10)
                     ccg91   LIKE ccg_file.ccg91,    #結存數量
                     ccg92   LIKE ccg_file.ccg92,    #末存金額:sum(tlf10)
                     amt     LIKE ccg_file.ccg92,    #tm.i11天
                     cma14   LIKE cma_file.cma14,    #單位成本
                     amt1    LIKE ccg_file.ccg92,    #市價
                     amt2    LIKE ccg_file.ccg92,    #跌價損失
                     cma05   LIKE cma_file.cma05     #單價別
                    ,l_cma32 LIKE cma_file.cma32     #FUN-C30190 add
                     END RECORD,
           l_cma     RECORD  LIKE cma_file.*,
           l_year    LIKE type_file.num10,          #No.FUN-680122INTGER
           l_mon     LIKE type_file.num5,           #No.FUN-680122SMALLINT
           l_ccc91   LIKE ccc_file.ccc91,
           l_ccc92   LIKE ccc_file.ccc92,
           l_azp03            LIKE type_file.chr21,          #No.FUN-680122 VARCHAR(21)
           i    LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
#FUN-C30190 add begin ---
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,
                          ?, ?, ?, ?, ?,  ?, ?) "
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
#FUN-C30190 add end ----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#NO.CHI-6A0004 --START
#    SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#      FROM azi_file WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004 --END
 #  No.FUN-550025 --start--
 #    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 163 END IF
     CALL cl_outnam('axcr640') RETURNING l_name
 #  No.FUN-550025 --end--
     #No.FUN-7C0101--start--
     IF tm.type MATCHES '[12]' THEN
        LET g_zaa[33].zaa06='Y'
     END IF
     IF tm.type MATCHES '[345]' THEN
        LET g_zaa[33].zaa06='N'
     END IF
     #No.FUN-7C0101---end---
     LET l_year=YEAR(tm.bdate)
     LET l_mon =MONTH(tm.bdate)
     LET l_sql="SELECT '','','',ccg01,ccg04,ccg07,sfb08,'',0,ccg91,",    #FUN-7C0101 add ccg07
               " ccg92,ccg92,0,0,0,' ','' ",                             #FUN-C30190 add ''
               "  FROM ccg_file,sfb_file ",
               " WHERE ccg01 = sfb01 AND ",tm.wc CLIPPED,
               "   AND ccg02 = ",l_year," AND ccg03 = ",l_mon ,
               "   AND ccg06 = '",tm.type,"'",                           #FUN-7C0101
               "   AND ccg92 <>0 "
 
     PREPARE ccg_pre  FROM l_sql
     DECLARE ccg_c  CURSOR FOR ccg_pre
 
     LET l_sql="SELECT MIN(tlf06) FROM tlf_file ",   #工單之首日發料日
               " WHERE tlf62= ?  ",                  #工單=ccg01
               "   AND tlf13 MATCHES 'asfi5*' ",     #異動命令
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
               "   AND tlf02='50' "                  #來源為倉庫
 
     PREPARE tlf_pre1 FROM l_sql
     DECLARE tlf_c1 CURSOR FOR tlf_pre1
 
      LET l_sql="SELECT SUM(tlf10*tlf60) FROM tlf_file ",   #工單之首日發料日 #MOD-570083
               " WHERE tlf01= ? AND tlf62= ?  ",     #料號=ccg04,工單=ccg01
               "   AND tlf13='asft6201'       ",     #異動命令
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add
               "   AND tlf06 <='",tm.bdate,"' "
 
     PREPARE tlf_pre2 FROM l_sql
     DECLARE tlf_c2 CURSOR FOR tlf_pre2
 
     #是否有工單變更
     LET l_sql="SELECT  * ",
               "  FROM sfm_file ",
               " WHERE sfm01=? ",   #工單
               "   AND sfm10='1' ",  #記錄型態 1.工單挪料
               " AND sfm03 <='",tm.bdate,"' ",
               " ORDER BY sfm03 DESC,sfm04 DESC "
     PREPARE sfm_pre1 FROM l_sql
     DECLARE sfm_c1 CURSOR FOR sfm_pre1
     #是否有工單變更(基準日之後)
     LET l_sql="SELECT  * ",
               "  FROM sfm_file ",
               " WHERE sfm01=? ",   #工單
               "   AND sfm10='1' ",  #記錄型態 1.工單挪料
               " AND sfm03 >'",tm.bdate,"' ",
               " ORDER BY sfm03 ,sfm04  "
     PREPARE sfm_pre2 FROM l_sql
     DECLARE sfm_c2 CURSOR FOR sfm_pre2
 
#    START REPORT r640_rep TO l_name         #FUN-C30190 mark
     LET g_pageno = 0
     LET l_date=' '
     FOREACH ccg_c  INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach ccg:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
        LET l_flag='Y'
       IF  cl_null(sr.sfb08) THEN LET sr.sfb08=0 END IF
       IF  cl_null(sr.ccg91) THEN LET sr.ccg91=0 END IF
       IF  cl_null(sr.ccg92) THEN LET sr.ccg92=0 END IF
       IF  cl_null(sr.amt  ) THEN LET sr.amt  =0 END IF
      #開工日期: 取工單之首日發料日
       OPEN tlf_c1 USING sr.ccg01
       FETCH tlf_c1 INTO l_date
       IF cl_null(l_date) THEN LET l_date=' ' END IF
       LET sr.fdate=l_date
      #呆滯天數=基準日(tm.bdate) - 工單首日發料日(fdate)
       LET l_delay=tm.bdate - sr.fdate
      #IF l_delay > tm.i11 THEN CONTINUE FOREACH END IF
       IF l_delay > tm.i11 THEN
          LET l_flag='N'
       END IF
 
       LET l_date=' ' LET l_tlf10=0
       OPEN tlf_c2 USING sr.ccg04,sr.ccg01
       FETCH tlf_c2 INTO l_tlf10
       IF cl_null(l_tlf10) THEN LET l_tlf10=0 END IF
      #判斷是否有工單變更(基準日之後)
       OPEN sfm_c2 USING sr.ccg01
       FETCH sfm_c2 INTO l_sfm.*
       IF SQLCA.SQLCODE =0 AND l_sfm.sfm05 IS NOT NULL  #No.7926
          THEN
            LET sr.sfb08=l_sfm.sfm05
       ELSE
          #判斷是否有工單變更(基準日之前)
           OPEN sfm_c1 USING sr.ccg01
           FETCH sfm_c1 INTO l_sfm.*
           IF SQLCA.SQLCODE =0 #No.7926
               AND l_sfm.sfm06 IS NOT NULL THEN
              LET sr.sfb08=l_sfm.sfm06
           END IF
       END IF
      #末存批量=開工批量(sfb08) - 已入庫量(sum(tlf10))
       LET sr.qty1=sr.sfb08 - l_tlf10
       INITIALIZE l_cma.* TO NULL
       SELECT * INTO l_cma.* FROM cma_file WHERE cma01=sr.ccg04
          AND cma021=tm.yy #FUN-8B0047
          AND cma022=tm.mm #FUN-8B0047
       LET sr.cma14 = l_cma.cma14
       LET sr.cma05 = l_cma.cma05
       LET sr.cma04 = l_cma.cma04
       IF l_cma.cma14 IS NULL OR l_cma.cma14=0 THEN
          SELECT cca23 INTO sr.cma14 FROM cca_file
           WHERE cca01=sr.ccg04 AND cca02=l_year AND cca03=l_mon
           AND cca06=tm.type                #FUN-7C0101
          IF cl_null(sr.cma14) THEN LET sr.cma14=0 END IF
          LET sr.amt1=0 LET sr.cma05=' '  LET sr.amt2=0
       ELSE
          CASE
            WHEN l_cma.cma05='I'  LET sr.amt1=l_cma.cma11
            WHEN l_cma.cma05='S'  LET sr.amt1=l_cma.cma12
            WHEN l_cma.cma05='B'  LET sr.amt1=l_cma.cma13
            WHEN l_cma.cma05='C'  LET sr.amt1=l_cma.cma14
          END CASE
          IF l_cma.cma05='S' THEN
           #跌價損失=[ (市價 * (1-銷售費用率(tm.k1)/100)) - 單位成本] * 末存批量
          # LET sr.amt2=( (sr.amt1 * (1-tm.k1/100))  - sr.cma14 ) * sr.qty1
          # LET sr.amt2=( (sr.amt1 * (1-tm.k1/100))  - sr.cma14 ) * sr.ccg91  #FUN-970102
            LET sr.amt2=( (sr.amt1 * (1-l_cma.cma32/100))  - sr.cma14 ) * sr.ccg91 #FUN-970102
          ELSE
           #跌價損失=[ 市價 * - 單位成本) * 末存批量
           #LET sr.amt2=( sr.amt1 - sr.cma14) * sr.qty1
            LET sr.amt2=( sr.amt1 - sr.cma14) * sr.ccg91
          END IF
       END IF
       IF tm.a ='1' THEN          #工單
           LET sr.order1=sr.ccg01 LET sr.order2=sr.ccg04
       ELSE                       #料號
           LET sr.order1=sr.ccg04 LET sr.order2=sr.ccg01
       END IF
       IF l_flag='N' THEN     #非90天
          LET sr.amt = 0      #90天金額
          LET sr.amt2=0       #跌價損失
       END IF
#      OUTPUT TO REPORT r640_rep(sr.*,l_cma.cma32) #FUN-970102 add cma32         #FUN-C30190 mark
       LET sr.l_cma32 = l_cma.cma32                                              #FUN-C30190 add
       EXECUTE  insert_prep  USING sr.*                                          #FUN-C30190 add
     END FOREACH
#FUN-C30190 add begin ---
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'ccg01') RETURNING g_wc
     #LET g_str = g_wc,";",tm.bdate,";",tm.i11,";",tm.type,";",g_ccz.ccz27,";",g_azi03,";"  #CHI-C30012
     LET g_str = g_wc,";",tm.bdate,";",tm.i11,";",tm.type,";",g_ccz.ccz27,";",g_ccz.ccz26  #CHI-C30012
     CALL cl_prt_cs3('axcr640','axcr640',l_sql,g_str)
#FUN-C30190 add end ----

#    FINISH REPORT r640_rep

#    CALL cl_prt(l_name,g_prtway,g_copies,g_len) 
END FUNCTION
 
#FUN-C30190 mark begin ----
#REPORT r640_rep(sr,l_cma32) #FUN-970102 add cma32
#   DEFINE l_last_sw     LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
#          sr         RECORD
#                     order1  LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
#                     order2  LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
#                     cma04   LIKE cma_file.cma04,    #ABC
#                     ccg01   LIKE ccg_file.ccg01,    #工單
#                     ccg04   LIKE ccg_file.ccg04,    #料號
#                     ccg07   LIKE ccg_file.ccg07,    #No.FUN-7C0101
#                     sfb08   LIKE sfb_file.sfb08,    #開工批量:sfb08
#                     fdate   LIKE type_file.dat,            #No.FUN-680122 DATE                  #開工日期:min(tlf06)
#                     qty1    LIKE sfb_file.sfb08,    #末存批量=sfb08-sum(tlf10)
#                     ccg91   LIKE ccg_file.ccg91,    #結存數量
#                     ccg92   LIKE ccg_file.ccg92,    #末存金額:sum(tlf10)
#                     amt     LIKE ccg_file.ccg92,    #tm.i11天
#                     cma14   LIKE cma_file.cma14,    #單位成本
#                     amt1    LIKE ccg_file.ccg92,    #市價
#                     amt2    LIKE ccg_file.ccg92,    #跌價損失
#                     cma05   LIKE cma_file.cma05     #單價別
#                     END RECORD,
#          l_day      LIKE type_file.num10,          #No.FUN-680122INTGER
#          samt ,samt0 ,samt1 ,samt2          LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
#        #  sqty1                              LIKE ima_file.ima26           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
#          sqty1                              LIKE type_file.num15_3           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
#   DEFINE l_cma32    LIKE cma_file.cma32     #FUN-970102
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
# 
# ORDER BY sr.order1,sr.order2
# 
#   FORMAT
#   PAGE HEADER
##No.FUN-580014 --start--
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      #LET g_head1= g_x[10] CLIPPED, tm.bdate using 'YYYY/MM/DD' #FUN-570250 mark
#      LET g_head1= g_x[10] CLIPPED, tm.bdate  #FUN-570250 add
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_head1
#      LET g_zaa[37].zaa08 = tm.i11 USING '---&',g_x[13] CLIPPED
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#            g_x[41],g_x[42]        #No.FUN-7C0101 add g_x[42]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
##No.FUN-580014 -end
# 
#    ON EVERY ROW
##No.FUN-580014 --start--
#      PRINT COLUMN  g_c[31],sr.ccg01,
#            COLUMN  g_c[32],sr.ccg04,
#            COLUMN  g_c[42],sr.ccg07,                                #FUN-7C0101
#            COLUMN  g_c[33],sr.cma04,
#            COLUMN  g_c[34],sr.fdate,
#            COLUMN  g_c[35],cl_numfor(sr.ccg91 ,35,g_ccz.ccz27) clipped, #CHI-690007
#            COLUMN  g_c[36],cl_numfor(sr.ccg92 ,36,g_azi03) clipped,      #FUN-570190
#            COLUMN  g_c[37],cl_numfor(sr.amt   ,37,g_azi03) clipped,      #FUN-570190
#            COLUMN  g_c[38],cl_numfor(sr.cma14 ,38,g_azi03) clipped,
#            COLUMN  g_c[39],cl_numfor(sr.amt1  ,39,g_azi03) clipped,      #FUN-570190
#            COLUMN  g_c[40],cl_numfor(sr.amt2  ,40,g_azi03) clipped,      #FUN-570190
#            COLUMN  g_c[41],sr.cma05
##No.FUN-580014 -end
# 
#    ON LAST ROW
#      PRINT  g_dash2[1,g_len]
#     #LET sqty1 =SUM(sr.qty1)           LET samt0 =SUM(sr.ccg92)
#      LET sqty1 =SUM(sr.ccg91)          LET samt0 =SUM(sr.ccg92)
#      LET samt1 =SUM(sr.amt1)           LET samt2 =SUM(sr.amt2)
#      LET samt  =SUM(sr.amt)
#      IF cl_null(samt0)   THEN LET samt0  =0 END IF      #末存金額
#      IF cl_null(samt )   THEN LET samt   =0 END IF      #tm.i11天金額
#      IF cl_null(samt1)   THEN LET samt1  =0 END IF      #市價
#      IF cl_null(samt2)   THEN LET samt2  =0 END IF      #跌價損失
#      IF cl_null(sqty1)   THEN LET sqty1  =0 END IF      #末存批量
##No.FUN-580014 -start
#      PRINT COLUMN  g_c[32],g_x[15] CLIPPED,
#            COLUMN  g_c[35],cl_numfor(sqty1 ,35,g_ccz.ccz27) clipped, #CHI-690007
#            COLUMN  g_c[36],cl_numfor(samt0   ,36,g_azi03      ) clipped,      #FUN-570190
#            COLUMN  g_c[37],cl_numfor(samt    ,37,g_azi03      ) clipped,      #FUN-570190
#           #---------------No.TQC-710021 modify
#           #COLUMN  g_c[38],cl_numfor(samt1   ,38,g_azi03      ) clipped,      #FUN-570190
#           #COLUMN  g_c[39],cl_numfor(samt2   ,39,g_azi03      ) clipped      #FUN-570190
#            COLUMN  g_c[39],cl_numfor(samt1   ,39,g_azi03      ) clipped,      #FUN-570190
#            COLUMN  g_c[40],cl_numfor(samt2   ,40,g_azi03      ) clipped      #FUN-570190
#           #---------------No.TQC-710021 modify
##No.FUN-580014 -end
#      IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#         THEN PRINT g_dash[1,g_len]
#              #TQC-630166 Start
#              #IF tm.wc[001,120] > ' ' THEN                      # for 132
#              #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              #IF tm.wc[121,240] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#              #IF tm.wc[241,300] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
# 
#             CALL cl_prt_pos_wc(tm.wc)
#              #TQC-630166 End
#      END IF
#      PRINT COLUMN  4,g_x[16] CLIPPED
#     #PRINT COLUMN  8,g_x[17] CLIPPED ,'  ',tm.k1 USING '---#.&&',' %'   #FUN-970102
#      PRINT COLUMN  8,g_x[17] CLIPPED ,'  ',l_cma32 USING '---#.&&',' %' #FUN-970102
#      PRINT COLUMN  8,g_x[18] CLIPPED ,g_x[19] CLIPPED
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#      #  PRINT COLUMN  4,g_x[16] CLIPPED
#      #  PRINT COLUMN  8,g_x[17] CLIPPED ,'  ',tm.k1 USING '---#.&&',' %'
#      #  PRINT COLUMN  8,g_x[18] CLIPPED ,g_x[19] CLIPPED
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#      ELSE
#         SKIP 2 LINE
#      END IF
#END REPORT
#FUN-C30190 mark end ----
 
#Patch....NO.TQC-610037 <> #
