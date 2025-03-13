# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axcr620.4gl
# Descriptions...: 存貨貨齡分析表(3)
# Date & Author..: 99/03/29 By Kammy
# Modify.........: No.MOD-530122 05/03/16 By Carol QBE欄位順序調整
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/06 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-580014 05/08/16 by day   報表轉xml
# Modify.........: No.FUN-580121 05/08/22 by saki 報表背景執行功能
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610051 06/02/10 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.FUN-7B0121 08/05/09 By Sarah 1.將庫齡開帳(cao_file)納入計算來源
#                                                  2.將銷售費用率(k1)欄位移除
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.MOD-970240 09/07/27 By sabrina l_cao03應將舊值清空，後續列印報表時才不會造成其他筆的數量異常 
# Modify.........: NO.FUN-970102 09/08/12 By jan 計價基准日 重新賦初值 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9C0025 09/12/22 By kim add 成本計算類別(cma07)及類別編號(cma08)
# Modify.........: No:CHI-9A0051 10/01/25 By jan 移除l_cao02/l_cao03相關程式段
# Modify.........: No:FUN-C30190 12/03/28 By chenjing 將原報表轉成CR輸出
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300),      # Where condition
              yy      LIKE type_file.num5,          #FUN-8B0047
              mm      LIKE type_file.num5,          #FUN-8B0047
              cma02   LIKE cma_file.cma02,
              c       LIKE type_file.chr1,           #No.FUN-680122CHAR(1),
             #k1      LIKE cmz_file.cmz02,           #FUN-7B0121 mark
              i10     LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              i11     LIKE type_file.num5,           #No.FUN-680122SMALLINT,
              ctype   LIKE ccc_file.ccc07,           #CHI-9C0025
              more    LIKE type_file.chr1            #No.FUN-680122CHAR(1)              # Input more condition(Y/N)
              END RECORD,
          g_cmz   RECORD LIKE cmz_file.*,
          g_tot_qty    LIKE cma_file.cma15, # User defined variable
          g_tot_amt    LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6),
          g_tot_LCM    LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6),
          g_tot_value  LIKE type_file.num20_6,        #No.FUN-680122DEC(20,6),
          g_cma15  LIKE cma_file.cma15,
          A_cma15  LIKE cma_file.cma15,
          O_cma15  LIKE cma_file.cma15,
          t_cma15  LIKE cma_file.cma15,
          g_cma14  LIKE cma_file.cma15,
          A_cma14  LIKE cma_file.cma15,
          O_cma14  LIKE cma_file.cma15,
          t_cma14  LIKE cma_file.cma15,
          g_buf   LIKE type_file.chr1000,       #No.FUN-680122CHAR(60),
          g_buf1  LIKE type_file.chr1000,       #No.FUN-680122CHAR(60),
          g_buf2  LIKE type_file.chr1000,       #No.FUN-680122CHAR(60),
          g_buf3  LIKE type_file.chr1000       #No.FUN-680122CHAR(60)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122SMALLINT
#FUN-C30190--add--start--
DEFINE l_table     STRING
DEFINE g_sql       STRING
DEFINE g_str       STRING
#FUN-C30190--add-end--

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate    = ARG_VAL(1)
   LET g_towhom   = ARG_VAL(2)
   LET g_lang     = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.cma02   = ARG_VAL(7)
   LET tm.c       = ARG_VAL(8)
  #LET tm.k1      = ARG_VAL(9)            #FUN-7B0121 mark
   LET tm.i10     = ARG_VAL(9)
   LET tm.i11     = ARG_VAL(10)
   LET tm.wc      = ARG_VAL(11)
   #LET tm.more   = ARG_VAL(12)           #TQC-610051
   LET g_rep_user = ARG_VAL(12)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(13)           #No.FUN-570264
   LET g_template = ARG_VAL(14)           #No.FUN-570264
   #No.FUN-580121 ---end---
   LET tm.yy      = ARG_VAL(15) #FUN-8B0047 #CHI-9C0025
   LET tm.mm      = ARG_VAL(16) #FUN-8B0047 #CHI-9C0025
   LET tm.ctype   = ARG_VAL(17) #CHI-9C0025
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
#FUN-C30190--add--start--
   LET g_sql = "order1.type_file.chr50,    cma01.cma_file.cma01,",
               "cma02.cma_file.cma02,      cma03.cma_file.cma03,",
               "cma04.cma_file.cma04,      cma05.cma_file.cma05,",
               "cma07.cma_file.cma07,      cma08.cma_file.cma08,",
               "cma11.cma_file.cma11,      cma12.cma_file.cma12,",
               "cma13.cma_file.cma13,      cma14.cma_file.cma14,",
               "cma15.cma_file.cma15,      cma16.cma_file.cma16,",
               "cmc03.cmc_file.cmc03,      cmc04.cmc_file.cmc04,",
               "price.cma_file.cma11,      l_qty.cma_file.cma15,",
               "l_amt.type_file.num20_6,   l_LCM.type_file.num20_6,",
               "l_value.type_file.num20_6 "
   LET l_table = cl_prt_temptable('axcr620',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED ,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#FUN-C30190--add--end--
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 
 
   IF cl_null(tm.wc) THEN
      CALL axcr620_tm(0,0)          # Input print condition
   ELSE
      CALL axcr620()                # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr620_tm(p_row,p_col)
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col LIKE type_file.num5,          #No.FUN-680122SMALLINT,
          l_cmd       LIKE type_file.chr1000       #No.FUN-680122CHAR(400) 
   DEFINE l_correct   LIKE type_file.chr1 #FUN-8B0047
   DEFINE l_date      LIKE type_file.dat  #FUN-8B0047

   IF p_row = 0 THEN LET p_row = 5 LET p_col = 8 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 8
   END IF
   OPEN WINDOW axcr620_w AT p_row,p_col
        WITH FORM "axc/42f/axcr620"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
 
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL            # Default condition
   SELECT * INTO g_cmz.* FROM cmz_file WHERE cmz00='0'
  #LET tm.cma02= g_cmz.cmz01    #FUN-970102
   LET tm.c    = g_cmz.cmz09
  #LET tm.k1   = g_cmz.cmz02   #FUN-7B0121 mark
   LET tm.i10  = g_cmz.cmz20
   LET tm.i11  = g_cmz.cmz21
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-580121 ---end---
   LET tm.yy    = g_ccz.ccz01 #FUN-8B0047
   LET tm.mm    = g_ccz.ccz02 #FUN-8B0047
   LET tm.ctype = g_ccz.ccz28 #CHI-9C0025
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.cma02  #FUN-970102 
 
 
WHILE TRUE
 #MOD-530122
   CONSTRUCT BY NAME tm.wc ON cma01,cma05,cma03
##
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
 
#No.FUN-570240 --start
     ON ACTION controlp
        IF INFIELD(cma01) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO cma01
           NEXT FIELD cma01
        END IF
#No.FUN-570240 --end
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     ON ACTION exit
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
     ON ACTION cancel
        LET INT_FLAG = 1
        EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cmauser', 'cmagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
   CALL cl_set_comp_entry('cma02',FALSE) #FUN-8B0047
 
  #INPUT BY NAME tm.cma02,tm.c,tm.k1,tm.i10,tm.i11,tm.more    #FUN-7B0121 mark
   INPUT BY NAME tm.yy,tm.mm,tm.cma02,tm.c,tm.i10,tm.i11,tm.ctype,tm.more          #FUN-7B0121 #FUN-8B0047  #CHI-9C0025
            WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
               CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.cma02
               DISPLAY BY NAME tm.cma02
            END IF
         #--
 
 
      AFTER FIELD cma02
         IF cl_null(tm.cma02) THEN NEXT FIELD cma02 END IF
      AFTER FIELD c
         IF tm.c NOT MATCHES '[12]' THEN NEXT FIELD c END IF
     #AFTER FIELD k1                              #FUN-7B0121 mark
     #   IF tm.k1 < 0 THEN NEXT FIELD k1 END IF   #FUN-7B0121 mark
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axcr620_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr620','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_lang CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.cma02 CLIPPED,"'",
                     " '",tm.c CLIPPED,"'",
                    #" '",tm.k1 CLIPPED,"'",          #FUN-7B0121 mark
                     " '",tm.i10 CLIPPED,"'",
                     " '",tm.i11 CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     #" '",tm.more CLIPPED,"'",       #TQC-610051
                     " '",g_rep_user CLIPPED,"'",     #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",     #No.FUN-570264
                     " '",g_template CLIPPED,"'",     #No.FUN-570264
                     " '",tm.yy    CLIPPED,"'", #FUN-8B0047
                     " '",tm.mm    CLIPPED,"'", #FUN-8B0047
                     " '",tm.ctype CLIPPED,"'"  #CHI-9C0025
 
         CALL cl_cmdat('axcr620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr620()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr620_w
END FUNCTION
 
FUNCTION axcr620()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20),         # External(Disk) file name
#         l_time    LIKE type_file.chr8           #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680122CHAR(600),
          l_chr     LIKE type_file.chr1,          #No.FUN-680122CHAR(1),
          l_za05    LIKE za_file.za05,
          l_order   ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10),
         #l_cao02   LIKE cao_file.cao02,          #FUN-7B0121 add  #CHI-9A0051
         #l_cao03   LIKE cao_file.cao03,          #FUN-7B0121 add  #CHI-9A0051
          sr        RECORD
                    order1   LIKE type_file.chr50, #CHI-9C0025
                    cma01    LIKE cma_file.cma01,
                    cma02    LIKE cma_file.cma02,
                    cma03    LIKE cma_file.cma03,
                    cma04    LIKE cma_file.cma04,
                    cma05    LIKE cma_file.cma05,
                    cma07    LIKE cma_file.cma07, #CHI-9C0025
                    cma08    LIKE cma_file.cma08, #CHI-9C0025
                    cma11    LIKE cma_file.cma11,
                    cma12    LIKE cma_file.cma12,
                    cma13    LIKE cma_file.cma13,
                    cma14    LIKE cma_file.cma14,
                    cma15    LIKE cma_file.cma15,
                    cma16    LIKE cma_file.cma16,
                    cmc03    LIKE cmc_file.cmc03,
                    cmc04    LIKE cmc_file.cmc04,
                    price    LIKE cma_file.cma11
                    END RECORD
  #FUN-C30190--add--start--
     DEFINE  l_qty    LIKE cma_file.cma15,
             l_amt    LIKE type_file.num20_6,
             l_LCM    LIKE type_file.num20_6,
             l_value  LIKE type_file.num20_6
     DEFINE  l_date   LIKE type_file.num5
  #FUN-C30190--add--end--

     CALL cl_del_data(l_table)       #FUN-C30190--add--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #FUN-C30190--add--
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_cma15=0    LET A_cma15=0     LET O_cma15=0     LET t_cma15=0
     LET g_cma14=0    LET A_cma14=0     LET O_cma14=0     LET t_cma14=0
  #  CALL cl_outnam('axcr620') RETURNING l_name           #FUN-C30190--mark--
  #  START REPORT axcr620_rep TO l_name                   #FUN-C30190--mark--   
     LET g_pageno = 0
     IF tm.c = '1' THEN
        LET l_sql = "SELECT '',cma01,cma02,cma03,cma04,cma05,cma07,cma08,cma11,cma12,", #CHI-9C0025
                    "       cma13,cma14,cma15,cma16,cmc03,cmc04,0 ",
                    "  FROM cma_file,cmc_file",
                    " WHERE ",tm.wc,
                    "   AND cma01=cmc01 ",
                    "   AND cma07=cmc07 ",  #CHI-9C0025
                    "   AND cma08=cmc08 ",  #CHI-9C0025
                    "   AND cma07='",tm.ctype,"' ",  #CHI-9C0025
                    "   AND cma15 <> 0 ",
                    "   AND cma021=",tm.yy, #FUN-8B0047
                    "   AND cma022=",tm.mm, #FUN-8B0047
                    "   AND cmc021=",tm.yy, #FUN-8B0047
                    "   AND cmc022=",tm.mm, #FUN-8B0047
                    "   AND cma02= '",tm.cma02,"'",
                    "   AND cmc02= '",tm.cma02,"'"
     ELSE
        LET l_sql = "SELECT '',cma01,cma02,cma03,cma04,cma05,cma07,cma08,cma11,cma12,", #CHI-9C0025
                    "       cma13,cma14,cma15,cma16,'','',0 ",
                    "  FROM cma_file ",
                    " WHERE ",tm.wc,
                    "   AND cma15 <> 0 ",
                    "   AND cma021=",tm.yy, #FUN-8B0047
                    "   AND cma022=",tm.mm, #FUN-8B0047
                    "   AND cma02= '",tm.cma02,"'",
                    "   AND cma07= '",tm.ctype,"' "   #CHI-9C0025
     END IF
     LET g_tot_qty = 0    LET g_tot_amt = 0
     LET g_tot_LCM = 0    LET g_tot_value =0
     PREPARE axcr620_prepare FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM 
     END IF
     DECLARE axcr620_curs CURSOR FOR axcr620_prepare
 
    #str FUN-7B0121 add
    #抓取庫齡開帳資料
    #CHI-9A0051--BEGIN--mark------------------ 
    #LET l_sql="SELECT cao02,cao03 FROM cao_file",
    #          " WHERE cao01 = ? ",
    #          "   AND cao07 = ? ",  #CHI-9C0025
    #          "   AND cao08 = ? ",  #CHI-9C0025
    #          "   AND cao02+",tm.i11,">='",tm.cma02,"'"
    #PREPARE axcr620_prepare2 FROM l_sql
    #DECLARE axcr620_curs2 CURSOR WITH HOLD FOR axcr620_prepare2
    #CHI-9A0051--end--mark---------------------
    #end FUN-7B0121 add
 
     FOREACH axcr620_curs INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      # IF tm.c='1' THEN
      #    LET l_date =sr.cmc03 USING 'yyyymmdd'
      # ELSE
      #    LET l_date =sr.cma16 USING 'yyyymmdd'
      # END IF
       #str FUN-7B0121 add
       #抓取庫齡開帳資料
       #CHI-9A0051--begin--mark-----
       #OPEN axcr620_curs2 USING sr.cma01,sr.cma07,sr.cma08  #CHI-9C0025
       #LET l_cao03 = NULL        #MOD-970240 add
       #FETCH axcr620_curs2 INTO l_cao02,l_cao03
       #CLOSE axcr620_curs2
       #IF cl_null(l_cao03) THEN LET l_cao03=0 END IF
       #CHI-9A0051--end--mark-------
       #end FUN-7B0121 add
        LET sr.order1=sr.cma01,sr.cma08  #CHI-9C0025
       #OUTPUT TO REPORT axcr620_rep(sr.*,l_cao02,l_cao03) #FUN-7B0121 add l_cao02,l_cao03
       #OUTPUT TO REPORT axcr620_rep(sr.*)                 #CHI-9A0051   #FUN-C30190--mark
    #FUN-C30190--add--start--
        LET l_date= 0
        LET l_qty = 0
        LET l_amt = 0
        LET l_LCM = 0
        LET l_value = 0
        IF tm.c='1' THEN
           LET l_date = tm.cma02 - sr.cmc03
           IF l_date >= tm.i10 AND l_date <= tm.i11 THEN
              LET l_qty = l_qty + sr.cmc04
              LET l_amt = l_amt +sr.cmc04 * sr.cma14
           END IF
        END IF
        CASE sr.cma05                                      #市價
             WHEN 'I' LET sr.price=sr.cma11
             WHEN 'S' LET sr.price=sr.cma12
             WHEN 'B' LET sr.price=sr.cma13
             WHEN 'C' LET sr.price=sr.cma14
             OTHERWISE EXIT CASE
        END CASE
        IF tm.c='2' THEN
           LET l_date = tm.cma02 - sr.cma16
           IF l_date >= tm.i10 AND l_date <= tm.i11 THEN
               LET l_qty = sr.cma15
               LET l_amt = l_qty * sr.cma14
           ELSE
               LET l_qty=0
               LET l_amt=0
           END IF
        END IF
        EXECUTE insert_prep USING sr.order1,sr.cma01,sr.cma02,sr.cma03,sr.cma04,
                                  sr.cma05,sr.cma07,sr.cma08,sr.cma11,sr.cma12,sr.cma13,
                                  sr.cma14,sr.cma15,sr.cma16,sr.cmc03,sr.cmc04,sr.price,
                                  l_qty,l_amt,l_LCM,l_value
    #FUN-C30190--add--end--
     END FOREACH
 
  #  FINISH REPORT axcr620_rep      #FUN-C30190--mark--
 
  #  CALL cl_prt(l_name,g_prtway,g_copies,g_len)     #FUN-C30190--mark
  #FUN-C30190--add--start--
     IF g_zz05='Y' THEN
        LET g_str = " "
        CALL cl_wcchp(tm.wc,'cma01,cma05,cma03')
        RETURNING tm.wc
     END IF
     #LET g_str = tm.wc,";",sr.cma05,";",tm.c,";",tm.yy,";",tm.mm,";",tm.i10,";",tm.i11,";",g_ccz.ccz27,";",g_azi03  #CHI-C30012
     LET g_str = tm.wc,";",sr.cma05,";",tm.c,";",tm.yy,";",tm.mm,";",tm.i10,";",tm.i11,";",g_ccz.ccz27,";",g_ccz.ccz26  #CHI-C30012
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED, l_table CLIPPED
     CALL cl_prt_cs3("axcr620","axcr620",l_sql,g_str)
  #FUN-C30190--add--end--
     
END FUNCTION
 
#REPORT axcr620_rep(sr,l_cao02,l_cao03)  #FUN-7B0121 add l_cao02,l_cao03 #CHI-9A0051
#FUN-C30190--mark--start--
#REPORT axcr620_rep(sr)                   #CHI-9A0051
#DEFINE l_last_sw LIKE type_file.chr1,          #No.FUN-680122CHAR(1),
#     #l_cao02   LIKE cao_file.cao02,          #FUN-7B0121 add #CHI-9A0051
#     #l_cao03   LIKE cao_file.cao03,          #FUN-7B0121 add #CHI-9A0051
#      sr        RECORD
#                 order1   LIKE type_file.chr50, #CHI-9C0025
#                 cma01    LIKE cma_file.cma01,
#                 cma02    LIKE cma_file.cma02,
#                 cma03    LIKE cma_file.cma03,
#                 cma04    LIKE cma_file.cma04,
#                 cma05    LIKE cma_file.cma05,
#                 cma07    LIKE cma_file.cma07, #CHI-9C0025
#                 cma08    LIKE cma_file.cma08, #CHI-9C0025
#                 cma11    LIKE cma_file.cma11,
#                 cma12    LIKE cma_file.cma12,
#                 cma13    LIKE cma_file.cma13,
#                 cma14    LIKE cma_file.cma14,
#                 cma15    LIKE cma_file.cma15,
#                 cma16    LIKE cma_file.cma16,
#                 cmc03    LIKE cmc_file.cmc03,
#                 cmc04    LIKE cmc_file.cmc04,
#                 price    LIKE cma_file.cma11
#                END RECORD,
#      p_date    LIKE type_file.dat,           #No.FUN-680122DATE,
#      l_date    LIKE type_file.num5,          #No.FUN-680122SMALLINT,
#      l_qty     LIKE cma_file.cma15,
#      l_qty1    LIKE cma_file.cma15,
#      l_qty2    LIKE cma_file.cma15,
#      l_qty3    LIKE cma_file.cma15,
#      l_amt     LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_amt1    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_amt2    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_amt3    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_LCM     LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_LCM1    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_LCM2    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_LCM3    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_value   LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_value1  LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_value2  LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_value3  LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_value4  LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6),
#      l_chr     LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.cma03,sr.cma01,sr.cma08,sr.cmc03  #CHI-9C0025
##No.FUN-580014-begin
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#     PRINT g_x[11] CLIPPED,tm.cma02
#     PRINT g_dash[1,g_len]
#     LET g_zaa[36].zaa08='Q -',tm.i11 USING '##&'
#     LET g_zaa[37].zaa08='A -',tm.i11 USING '##&'
#     PRINT g_x[33],g_x[42],g_x[34],g_x[35],  #CHI-9C0025
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
# #BEFORE GROUP OF sr.cma01  #CHI-9C0025
#  BEFORE GROUP OF sr.order1  #CHI-9C0025
#     LET l_date= 0
#     LET l_qty = 0  LET l_amt = 0  LET l_LCM = 0 LET l_value = 0
#  #  LET l_qty1= 0  LET l_amt1= 0  LET l_LCM1= 0 LET l_value1= 0
#  #  LET l_qty2= 0  LET l_amt2= 0  LET l_LCM2= 0 LET l_value2= 0
#  #  LET l_qty3= 0  LET l_amt3= 0  LET l_LCM3= 0 LET l_value3= 0
#     LET g_cma15 = g_cma15+sr.cma15   #FUN-7B0121 add l_cao03 #CHI-9A0051
#     LET t_cma15 = t_cma15+sr.cma15   #FUN-7B0121 add l_cao03 #CHI-9A0051
#     LET g_cma14 = g_cma14+sr.cma15*sr.cma14  #FUN-7B0121 add l_cao03*sr.cma14  #CHI-9A0051
#     LET t_cma14 = t_cma14+sr.cma15*sr.cma14  #FUN-7B0121 add l_cao03*sr.cma14  #CHI-9A0051
#     IF sr.cma04 = 'A' THEN
#        LET A_cma15 = A_cma15 + sr.cma15           #FUN-7B0121 add l_cao03 #CHI-9A0051        
#        LET A_cma14 = A_cma14 + sr.cma15*sr.cma14  #FUN-7B0121 add l_cao03*sr.cma14#CHI-9A0051 
#     ELSE
#        LET O_cma15 = O_cma15 + sr.cma15           #FUN-7B0121 add l_cao03 #CHI-9A0051
#        LET O_cma14 = O_cma14 + sr.cma15*sr.cma14  #FUN-7B0121 add l_cao03*sr.cma14 #CHI-9A0051
#     END IF
#
#  BEFORE GROUP OF sr.cma03
#     LET t_cma15=0
#     LET A_cma15=0
#     LET O_cma15=0
#     LET t_cma14=0
#     LET A_cma14=0
#     LET O_cma14=0
#     LET l_qty1= 0  LET l_amt1= 0  LET l_LCM1= 0 LET l_value1= 0
#     LET l_qty2= 0  LET l_amt2= 0  LET l_LCM2= 0 LET l_value2= 0
#     LET l_qty3= 0  LET l_amt3= 0  LET l_LCM3= 0 LET l_value3= 0
#
#  ON EVERY ROW
#     IF tm.c='1' THEN
#        LET l_date = tm.cma02 - sr.cmc03
#        IF l_date >= tm.i10 AND l_date <= tm.i11 THEN
#           LET l_qty = l_qty + sr.cmc04
#           LET l_amt = l_amt +sr.cmc04 * sr.cma14
#        END IF
#       #str FUN-7B0121 add
#       #CHI-9A0051--begin--mark--------
#       #IF NOT cl_null(l_cao02) THEN
#       #   LET l_date = tm.cma02 - l_cao02
#       #   IF l_date >= tm.i10 AND l_date <= tm.i11 THEN
#       #      LET l_qty = l_qty +l_cao03
#       #      LET l_amt = l_amt +l_cao03 * sr.cma14
#       #   END IF
#       #END IF
#       #CHI-9A0051--end--mark----------
#       #end FUN-7B0121 add
#     END IF
#
# #AFTER GROUP OF sr.cma01  #CHI-9C0025
#  AFTER GROUP OF sr.order1  #CHI-9C0025

#     CASE sr.cma05                                      #市價
#          WHEN 'I' LET sr.price=sr.cma11
#          WHEN 'S' LET sr.price=sr.cma12
#          WHEN 'B' LET sr.price=sr.cma13
#          WHEN 'C' LET sr.price=sr.cma14
#          OTHERWISE EXIT CASE
#     END CASE
#     IF tm.c='2' THEN
#        LET l_date = tm.cma02 - sr.cma16
#        IF l_date >= tm.i10 AND l_date <= tm.i11 THEN
#            LET l_qty = sr.cma15
#            LET l_amt = l_qty * sr.cma14
#        ELSE
#            LET l_qty=0
#            LET l_amt=0
#        END IF
#       #str FUN-7B0121 add
#       #CHI-9A0051--begin--mark----------
#       #IF NOT cl_null(l_cao02) THEN
#       #   LET l_date = tm.cma02 - l_cao02
#       #   IF l_date >= tm.i10 AND l_date <= tm.i11 THEN
#       #      LET l_qty = l_qty + l_cao03
#       #      LET l_amt = l_qty * sr.cma14
#       #   ELSE
#       #      LET l_qty=0
#       #      LET l_amt=0
#       #   END IF
#       #END IF
#       #CHI-9A0051--end--mark-----------
#       #end FUN-7B0121 add
#     END IF
#    #str FUN-7B0121 mark
#    #IF sr.cma05 = 'S' THEN
#    #   LET l_value = sr.price * ( 1-tm.k1/100) * l_qty
#    #ELSE
#    #   LET l_value = sr.price * l_qty
#    #END IF
#    #end FUN-7B0121 mark
#     LET l_value = sr.price * l_qty   #FUN-7B0121 add
#     LET l_LCM = l_amt - l_value
#     #--合計
#     LET l_qty1 = l_qty1 + l_qty
#     LET l_amt1 = l_amt1 + l_amt
#     LET l_LCM1  =l_LCM1  + l_LCM
#     LET l_value1=l_value1+ l_value
#     #--小計
#     CASE sr.cma04
#          WHEN 'A'  LET l_qty2  =l_qty2  + l_qty
#                    LET l_amt2  =l_amt2  + l_amt
#                    LET l_LCM2  =l_LCM2  + l_LCM
#                    LET l_value2=l_value2+ l_value
#        # WHEN 'B'  LET l_qty3=l_qty3 + l_qty
#        #           LET l_amt3=l_amt3 + l_amt
#        #           LET l_LCM3  =l_LCM3  + l_LCM
#        #           LET l_value3=l_value3+ l_value
#          OTHERWISE LET l_qty3=l_qty3 + l_qty
#                    LET l_amt3=l_amt3 + l_amt
#                    LET l_LCM3  =l_LCM3  + l_LCM
#                    LET l_value3=l_value3+ l_value
#     END CASE
#     #--總計
#     LET g_tot_qty  = g_tot_qty   + l_qty
#     LET g_tot_amt  = g_tot_amt   + l_amt
#     LET g_tot_LCM  = g_tot_LCM   + l_LCM
#     LET g_tot_value= g_tot_value + l_value
#     ##-
#     #PRINT COLUMN g_c[33],sr.cma01[1,20],
#     PRINT COLUMN g_c[33],sr.cma01 clipped, #NO.FUN-5B0015
#           COLUMN g_c[42],sr.cma08 clipped, #CHI-9C0025
#           COLUMN g_c[34],cl_numfor(sr.cma15,34,g_ccz.ccz27),  #CHI-690007 0->ccz27   #FUN-7B0121 add l_cao03  #CHI-9A0051
#           COLUMN g_c[35],cl_numfor(sr.cma15 * sr.cma14,35,g_azi03),                  #FUN-7B0121 add l_cao03  #CHI-9A0051
#           COLUMN g_c[36],cl_numfor(l_qty,36,g_ccz.ccz27),  #CHI-690007 0->ccz27
#           COLUMN g_c[37],cl_numfor(l_amt,37,g_azi03),
#           COLUMN g_c[38],cl_numfor(sr.price,38,g_azi03),
#           COLUMN g_c[39],cl_numfor(l_value,39,g_azi03),
#           COLUMN g_c[40],cl_numfor(l_LCM,40,g_azi03),
#           COLUMN g_c[41],sr.cma05
#
#  AFTER GROUP OF sr.cma03
#     IF sr.cma03 = '2' THEN
#        LET g_buf1=g_x[19] LET g_buf2=g_x[20] LET g_buf3=g_x[21]
#     ELSE
#        LET g_buf1=g_x[30] LET g_buf2=g_x[31] LET g_buf3=g_x[32]
#     END IF
#     PRINT g_x[19] CLIPPED,
#           COLUMN  g_c[34],cl_numfor(t_cma15,34,g_ccz.ccz27),  #CHI-690007 0->ccz27
#           COLUMN  g_c[35],cl_numfor(t_cma14,35,g_azi03),
#           COLUMN  g_c[36],cl_numfor(l_qty1,36,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN  g_c[37],cl_numfor(l_amt1,37,g_azi03),
#           COLUMN  g_c[39],cl_numfor(l_value1,39,g_azi03),
#           COLUMN  g_c[40],cl_numfor(l_LCM1,40,g_azi03)
#     PRINT g_x[20] CLIPPED,
#           COLUMN g_c[34], cl_numfor(A_cma15,34,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN g_c[35], cl_numfor(A_cma14,35,g_azi03),
#           COLUMN g_c[36], cl_numfor(l_qty2,36,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN g_c[37], cl_numfor(l_amt2,37,g_azi03),
#           COLUMN g_c[39], cl_numfor(l_value2,39,g_azi03),
#           COLUMN g_c[40], cl_numfor(l_LCM2,40,g_azi03)
#     PRINT g_x[21] CLIPPED,
#           COLUMN g_c[34], cl_numfor(O_cma15,34,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN g_c[35], cl_numfor(O_cma14,35,g_azi03),
#           COLUMN g_c[36], cl_numfor(l_qty3,36,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN g_c[37], cl_numfor(l_amt3,37,g_azi03),
#           COLUMN g_c[39], cl_numfor(l_value3,39,g_azi03),
#           COLUMN g_c[40], cl_numfor(l_LCM3,40,g_azi03)
#     PRINT
#
#  ON LAST ROW
#     PRINT
#     PRINT g_x[22] CLIPPED,
#           COLUMN g_c[34],cl_numfor(g_cma15,34,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN g_c[35],cl_numfor(g_cma14,35,g_azi03),
#           COLUMN g_c[36],cl_numfor(g_tot_qty,36,g_ccz.ccz27), #CHI-690007 0->ccz27
#           COLUMN g_c[37],cl_numfor(g_tot_amt,37,g_azi03),
#           COLUMN g_c[39],cl_numfor(g_tot_value,39,g_azi03),
#           COLUMN g_c[40],cl_numfor(g_tot_LCM,40,g_azi03)
#     PRINT
#     IF tm.c = '1' THEN LET g_buf = g_x[28] ELSE LET g_buf = g_x[29] END IF
#     PRINT COLUMN 2,g_x[23] CLIPPED
#     PRINT COLUMN 8,g_x[24] CLIPPED , g_buf CLIPPED
#    #PRINT COLUMN 8,g_x[25] CLIPPED , tm.k1 , '%'   #FUN-7B0121 mark
#     PRINT COLUMN 8,g_x[26] ,g_x[27]
#     LET l_last_sw = 'y'
##No.FUN-580014-end
#
#  PAGE TRAILER
#     PRINT g_dash[1,g_len] CLIPPED
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
#END REPORT
#Patch....NO.TQC-610037 <> #
