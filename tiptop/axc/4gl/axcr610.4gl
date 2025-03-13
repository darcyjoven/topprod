# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: axcr610.4gl
# Descriptions...: 存貨貨齡分析表(2)
# Date & Author..: 99/03/26 By Sophia
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-570240 05/07/25 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-570190 05/08/08 by Rosayu 單價、金額全部抓azi03取位
# Modify.........: No.FUN-580014 05/08/16 by day   報表轉xml
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-610051 06/02/22 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換    
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-6C0043 06/12/11 By Sarah per檔增加抓cmz20~cmz22的區段
# Modify.........: No.CHI-690007 06/12/26 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-7B0121 08/05/09 By Sarah 將庫齡開帳(cao_file)納入計算來源
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.FUN-940049 09/04/15 By jan 拿掉部分程式
# Modify.........: NO.FUN-970102 09/08/12 By jan 計價基准日 重新賦初值 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9C0025 09/12/22 By kim add 成本計算類別(cma07)及類別編號(cma08)
# Modify.........: No:CHI-9A0051 10/01/25 By jan 移除l_cao02/l_cao03相關程式段
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:MOD-A10158 10/11/24 By sabrina 1.天數超過4位數時，會變成###呈現
#                                                    2.將title改成中文說明
# Modify.........: No.MOD-B80071 11/08/18 By Vampire g_cma14,A_cma14,O_cma14,t_cma14 變數宣告應該為 cma14
# Modify.........: No.MOD-C20138 12/02/23 By Elise i02,i12,i22,i32,i42要定義NUMBER(9,4)
# Modify.........: No.MOD-C30038 12/03/05 By Elise 在抓出sr.cma15時就先依ccz27作取位
# Modify.........: No.FUN-C30190 12/03/28 By xumeimei 原報表轉CR報表
# Modify.........: No.FUN-C40067 12/07/13 By bart 條件加入成本分群
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-D30257 13/03/29 By ck2yuan EXECUTE前才進行取位 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
                wc      LIKE type_file.chr1000,        #No.FUN-680122CHAR(300)             # Where condition
                yy      LIKE type_file.num5,           #FUN-8B0047
                mm      LIKE type_file.num5,           #FUN-8B0047
                cma02   LIKE cma_file.cma02,
                c       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
                ctype   LIKE ccc_file.ccc07,           #CHI-9C0025
                d       LIKE type_file.chr1,           #No.FUN-680122CHAR(1)
                i00     LIKE type_file.num5,           #MOD-6C0043 add
                i01     LIKE type_file.num5,           #MOD-6C0043 add
               #i02     LIKE type_file.num5,           #MOD-6C0043 add         #MOD-C20138 mark
                i02     LIKE cmz_file.cmz22,           #MOD-6C0043 add         #MOD-C20138
                i10     LIKE type_file.num5,           #No.FUN-680122SMALLINT
                i11     LIKE type_file.num5,           #No.FUN-680122SMALLINT
               #i12     LIKE type_file.num5,           #No.FUN-680122SMALLINT  #MOD-C20138 mark
                i12     LIKE cmz_file.cmz32,           #No.FUN-680122SMALLINT  #MOD-C20138
                i20     LIKE type_file.num5,           #No.FUN-680122SMALLINT
                i21     LIKE type_file.num5,           #No.FUN-680122SMALLINT
               #i22     LIKE type_file.num5,           #No.FUN-680122SMALLINT  #MOD-C20138 mark
                i22     LIKE cmz_file.cmz42,           #No.FUN-680122SMALLINT  #MOD-C20138
                i30     LIKE type_file.num5,           #No.FUN-680122SMALLINT
                i31     LIKE type_file.num5,           #No.FUN-680122SMALLINT
               #i32     LIKE type_file.num5,           #No.FUN-680122SMALLINT  #MOD-C20138 mark
                i32     LIKE cmz_file.cmz52,           #No.FUN-680122SMALLINT  #MOD-C20138
                i40     LIKE type_file.num5,           #No.FUN-680122SMALLINT
                i41     LIKE type_file.num5,           #No.FUN-680122SMALLINT
               #i42     LIKE type_file.num5,           #No.FUN-680122SMALLINT  #MOD-C20138 mark
                i42     LIKE cmz_file.cmz62,           #No.FUN-680122SMALLINT  #MOD-C20138
                k1      LIKE type_file.num5,           #No.FUN-680122SMALLINT
                k2      LIKE type_file.num5,           #No.FUN-680122SMALLINT
                k3      LIKE type_file.num5,           #No.FUN-680122SMALLINT
                more    LIKE type_file.chr1            #No.FUN-680122CHAR(01)               # Input more condition(Y/N)
              END RECORD,
          g_cmz   RECORD LIKE cmz_file.*,
          A_tot_qty0  LIKE cma_file.cma15,           #MOD-6C0043 add
          A_tot_qty1  LIKE cma_file.cma15,
          A_tot_qty2  LIKE cma_file.cma15,
          A_tot_qty3  LIKE cma_file.cma15,
          A_tot_qty4  LIKE cma_file.cma15,
          A_tot_amt0  LIKE type_file.num20_6,        #MOD-6C0043 add
          A_tot_amt1  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          A_tot_amt2  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          A_tot_amt3  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          A_tot_amt4  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          A_tot_slow  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          O_tot_qty0  LIKE cma_file.cma15,           #MOD-6C0043 add
          O_tot_qty1  LIKE cma_file.cma15,
          O_tot_qty2  LIKE cma_file.cma15,
          O_tot_qty3  LIKE cma_file.cma15,
          O_tot_qty4  LIKE cma_file.cma15,
          O_tot_amt0  LIKE type_file.num20_6,        #MOD-6C0043 add
          O_tot_amt1  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          O_tot_amt2  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          O_tot_amt3  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          O_tot_amt4  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          O_tot_slow  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          t_tot_qty0  LIKE cma_file.cma15,           #MOD-6C0043 add
          t_tot_qty1  LIKE cma_file.cma15,
          t_tot_qty2  LIKE cma_file.cma15,
          t_tot_qty3  LIKE cma_file.cma15,
          t_tot_qty4  LIKE cma_file.cma15,
          t_tot_amt0  LIKE type_file.num20_6,        #MOD-6C0043 add
          t_tot_amt1  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          t_tot_amt2  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          t_tot_amt3  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          t_tot_amt4  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          t_tot_slow  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          g_tot_qty0  LIKE cma_file.cma15,           #MOD-6C0043 add
          g_tot_qty1  LIKE cma_file.cma15,
          g_tot_qty2  LIKE cma_file.cma15,
          g_tot_qty3  LIKE cma_file.cma15,
          g_tot_qty4  LIKE cma_file.cma15,
          g_tot_amt0  LIKE type_file.num20_6,        #MOD-6C0043 add
          g_tot_amt1  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          g_tot_amt2  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          g_tot_amt3  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          g_tot_amt4  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          g_tot_slow  LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
          g_cma15  LIKE cma_file.cma15,
          A_cma15  LIKE cma_file.cma15,
          O_cma15  LIKE cma_file.cma15,
          t_cma15  LIKE cma_file.cma15,
          #MOD-B80071 --- modify --- start ---
          #g_cma14  LIKE cma_file.cma15,
          #A_cma14  LIKE cma_file.cma15,
          #O_cma14  LIKE cma_file.cma15,
          #t_cma14  LIKE cma_file.cma15
          g_cma14  LIKE cma_file.cma14,
          A_cma14  LIKE cma_file.cma14,
          O_cma14  LIKE cma_file.cma14,
          t_cma14  LIKE cma_file.cma14
          #MOD-B80071 --- modify ---  end  ---
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#No.FUN-C30190---Begin
DEFINE g_sql     STRING
DEFINE g_str     STRING
DEFINE l_table   STRING
#No.FUN-C30190---End 

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690125 BY dxfwo 

   #No.FUN-C30190---add---Begin
   LET g_sql = "l_order.cma_file.cma01,",
               "cma01.cma_file.cma01,",
               "cma02.cma_file.cma02,",
               "cma03.cma_file.cma03,",
               "cma04.cma_file.cma04,",
               "cma07.cma_file.cma07,",
               "cma08.cma_file.cma08,",
               "cma14.cma_file.cma14,",
               "cma15.cma_file.cma15,",
               "cmc03.cmc_file.cmc03,",
               "cmc04.cmc_file.cmc04,",
               "l_qty0.cma_file.cma15,",
               "l_qty1.cma_file.cma15,",
               "l_qty2.cma_file.cma15,",
               "l_qty3.cma_file.cma15,",
               "l_qty4.cma_file.cma15,",
               "l_amt0.oeb_file.oeb13,",
               "l_amt1.oeb_file.oeb13,",
               "l_amt2.oeb_file.oeb13,",
               "l_amt3.oeb_file.oeb13,",
               "l_amt4.oeb_file.oeb13,",
               "l_slow.oeb_file.oeb13"

   LET l_table = cl_prt_temptable('axcr610',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   #NO.FUN-C30190---add---End 
  #TQC-610051-begin
   #INITIALIZE tm.* TO NULL            # Default condition
   #SELECT * INTO g_cmz.* FROM cmz_file WHERE cmz00='0'
   #LET tm.more = 'N'
   #LET g_pdate = g_today
   #LET g_rlang = g_lang
   #LET g_bgjob = 'N'
   #LET g_copies = '1'
   #LET tm.c=g_cmz.cmz09
   #LET tm.d=g_cmz.cmz10
   #LET tm.cma02=g_cmz.cmz01
   #LET tm.i10=g_cmz.cmz30
   #LET tm.i11=g_cmz.cmz31
   #LET tm.i12=g_cmz.cmz32
   #LET tm.i20=g_cmz.cmz40
   #LET tm.i21=g_cmz.cmz41
   #LET tm.i22=g_cmz.cmz42
   #LET tm.i30=g_cmz.cmz50
   #LET tm.i31=g_cmz.cmz51
   #LET tm.i32=g_cmz.cmz52
   #LET tm.i40=g_cmz.cmz60
   #LET tm.i41=g_cmz.cmz61
   #LET tm.i42=g_cmz.cmz62
   #LET tm.k1 =g_cmz.cmz06
   #LET tm.k2 =g_cmz.cmz07
   #LET tm.k3 =g_cmz.cmz08
   #LET tm.wc = ARG_VAL(1)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(2)
   #LET g_rep_clas = ARG_VAL(3)
   #LET g_template = ARG_VAL(4)
   ##No.FUN-570264 ---end---
   LET g_pdate  = ARG_VAL(1)        
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.cma02 = ARG_VAL(8)
   LET tm.c     = ARG_VAL(9)
   LET tm.d     = ARG_VAL(10)
   LET tm.i00   = ARG_VAL(11)   #MOD-6C0043 add
   LET tm.i01   = ARG_VAL(12)   #MOD-6C0043 add
   LET tm.i02   = ARG_VAL(13)   #MOD-6C0043 add
   LET tm.i10   = ARG_VAL(14)
   LET tm.i11   = ARG_VAL(15)
   LET tm.i12   = ARG_VAL(16)
   LET tm.i20   = ARG_VAL(17)
   LET tm.i21   = ARG_VAL(18)
   LET tm.i22   = ARG_VAL(19)
   LET tm.i30   = ARG_VAL(20)
   LET tm.i31   = ARG_VAL(21)
   LET tm.i32   = ARG_VAL(22)
   LET tm.i40   = ARG_VAL(23)
   LET tm.i41   = ARG_VAL(24)
   LET tm.i42   = ARG_VAL(25)
   LET tm.k1    = ARG_VAL(26)
   LET tm.k2    = ARG_VAL(27)
   LET tm.k3    = ARG_VAL(28)
   LET g_rep_user = ARG_VAL(29)
   LET g_rep_clas = ARG_VAL(30)
   LET g_template = ARG_VAL(31)
   LET tm.yy      = ARG_VAL(32) #FUN-8B0047
   LET tm.mm      = ARG_VAL(33) #FUN-8B0047 #CHI-9C0025
   LET tm.ctype   = ARG_VAL(34) #FUN-8B0047 #CHI-9C0025
  #TQC-610051-end
   IF cl_null(tm.wc)
      THEN CALL axcr610_tm(0,0)             # Input print condition
      ELSE CALL axcr610()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION axcr610_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE l_correct   LIKE type_file.chr1 #FUN-8B0047
   DEFINE l_date      LIKE type_file.dat  #FUN-8B0047
 
 
   LET p_row = 1 LET p_col = 20
   OPEN WINDOW axcr610_w AT p_row,p_col WITH FORM "axc/42f/axcr610"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
  #TQC-610051-begin
   INITIALIZE tm.* TO NULL            # Default condition
   SELECT * INTO g_cmz.* FROM cmz_file WHERE cmz00='0'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.c=g_cmz.cmz09
   LET tm.d=g_cmz.cmz10
  #LET tm.cma02=g_cmz.cmz01 #FUN-970102
   LET tm.i00=g_cmz.cmz20   #MOD-6C0043 add
   LET tm.i01=g_cmz.cmz21   #MOD-6C0043 add
   LET tm.i02=g_cmz.cmz22   #MOD-6C0043 add
   LET tm.i10=g_cmz.cmz30
   LET tm.i11=g_cmz.cmz31
   LET tm.i12=g_cmz.cmz32
   LET tm.i20=g_cmz.cmz40
   LET tm.i21=g_cmz.cmz41
   LET tm.i22=g_cmz.cmz42
   LET tm.i30=g_cmz.cmz50
   LET tm.i31=g_cmz.cmz51
   LET tm.i32=g_cmz.cmz52
   LET tm.i40=g_cmz.cmz60
   LET tm.i41=g_cmz.cmz61
   LET tm.i42=g_cmz.cmz62
   LET tm.k1 =g_cmz.cmz06
   LET tm.k2 =g_cmz.cmz07
   LET tm.k3 =g_cmz.cmz08
  #TQC-610051-end
   LET tm.yy    = g_ccz.ccz01  #FUN-8B0047
   LET tm.mm    = g_ccz.ccz02  #FUN-8B0047
   LET tm.ctype = g_ccz.ccz28  #CHI-9C0025
   CALL s_azm(tm.yy,tm.mm) RETURNING l_correct, l_date, tm.cma02  #FUN-970102
 WHILE TRUE
   #CONSTRUCT BY NAME tm.wc ON cma01,cma03  #FUN-C40067
   CONSTRUCT BY NAME tm.wc ON cma01,cma03,ima12  #FUN-C40067
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
#FUN-C40067---begin
        IF INFIELD(ima12) THEN
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_azf_1"
           LET g_qryparam.state = "c"
           LET g_qryparam.arg1 = 'G'
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO ima12
           NEXT FIELD ima12
        END IF
##FUN-C40067---end

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
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('cmauser', 'cmagrup') #FUN-980030
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
   CALL cl_set_comp_entry('cma02',FALSE) #FUN-8B0047
 
  #INPUT BY NAME tm.cma02,tm.c,tm.d,tm.i10,tm.i11,tm.i12,tm.i20,tm.i21,tm.i22,                        #MOD-6C0043 mark
   INPUT BY NAME tm.yy,tm.mm,tm.cma02,tm.c,tm.ctype,tm.d,tm.i00,tm.i01,tm.i02,  #CHI-9C0025
                 tm.i10,tm.i11,tm.i12,tm.i20,tm.i21,tm.i22,   #MOD-6C0043 add tm.i00,tm.i01,tm.i02 #FUN-8B0047
                 tm.i30,tm.i31,tm.i32,tm.i40,tm.i41,tm.i42,tm.k1,tm.k2,tm.k3,
                 tm.more   WITHOUT DEFAULTS
 
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
         IF cl_null(tm.c) OR tm.c NOT MATCHES '[12]' THEN
            NEXT FIELD c
         END IF
 
      AFTER FIELD d
         IF cl_null(tm.d) OR tm.d NOT MATCHES '[12]' THEN
            NEXT FIELD d
         END IF
 
     #start MOD-6C0043 add
      AFTER FIELD i02
         IF NOT cl_null(tm.i02) THEN
            IF tm.i02 < 0 THEN NEXT FIELD i02 END IF
         END IF
         IF cl_null(tm.i02) THEN LET tm.i02 = 0 END IF
     #end MOD-6C0043 add
 
      AFTER FIELD i12
         IF NOT cl_null(tm.i12) THEN
            IF tm.i12 < 0 THEN NEXT FIELD i12 END IF
         END IF
         IF cl_null(tm.i12) THEN LET tm.i12 = 0 END IF
 
      AFTER FIELD i22
         IF NOT cl_null(tm.i22) THEN
            IF tm.i22 < 0 THEN NEXT FIELD i22 END IF
         END IF
         IF cl_null(tm.i22) THEN LET tm.i22 = 0 END IF
 
      AFTER FIELD i32
         IF NOT cl_null(tm.i32) THEN
            IF tm.i32 < 0 THEN NEXT FIELD i32 END IF
         END IF
         IF cl_null(tm.i32) THEN LET tm.i32 = 0 END IF
 
      AFTER FIELD i42
         IF NOT cl_null(tm.i42) THEN
            IF tm.i42 < 0 THEN NEXT FIELD i42 END IF
         END IF
         IF cl_null(tm.i42) THEN LET tm.i42 = 0 END IF
 
      AFTER FIELD k1
         IF NOT cl_null(tm.k1) THEN
            IF tm.k1 < 0 THEN NEXT FIELD k1 END IF
         END IF
         IF cl_null(tm.k1) THEN LET tm.k1 = 0 END IF
 
      AFTER FIELD k2
         IF NOT cl_null(tm.k2) THEN
            IF tm.k2 < 0 THEN NEXT FIELD k2 END IF
         END IF
         IF cl_null(tm.k2) THEN LET tm.k2 = 0 END IF
 
      AFTER FIELD k3
         IF NOT cl_null(tm.k3) THEN
            IF tm.k3 < 0 THEN NEXT FIELD k3 END IF
         END IF
         IF cl_null(tm.k3) THEN LET tm.k3 = 0 END IF
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
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
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
       WHERE zz01='axcr610'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr610','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.cma02 CLIPPED,"'" ,
                         " '",tm.c CLIPPED,"'" ,
                         " '",tm.d CLIPPED,"'" ,
                         " '",tm.i00 CLIPPED,"'" ,   #MOD-6C0043 add
                         " '",tm.i01 CLIPPED,"'" ,   #MOD-6C0043 add
                         " '",tm.i02 CLIPPED,"'" ,   #MOD-6C0043 add
                         " '",tm.i10 CLIPPED,"'" ,
                         " '",tm.i11 CLIPPED,"'" ,
                         " '",tm.i12 CLIPPED,"'" ,
                         " '",tm.i20 CLIPPED,"'" ,
                         " '",tm.i21 CLIPPED,"'" ,
                         " '",tm.i22 CLIPPED,"'" ,
                         " '",tm.i30 CLIPPED,"'" ,
                         " '",tm.i31 CLIPPED,"'" ,
                         " '",tm.i32 CLIPPED,"'" ,
                         " '",tm.i40 CLIPPED,"'" ,
                         " '",tm.i41 CLIPPED,"'" ,
                         " '",tm.i42 CLIPPED,"'" ,
                         " '",tm.k1 CLIPPED,"'" ,
                         " '",tm.k2 CLIPPED,"'" ,
                         " '",tm.k3 CLIPPED,"'" ,
                         #" '",tm.more CLIPPED,"'"  ,           #TQC-610051  
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",            #No.FUN-570264
                         " '",tm.yy    CLIPPED,"'", #FUN-8B0047
                         " '",tm.mm    CLIPPED,"'", #FUN-8B0047
                         " '",tm.ctype CLIPPED,"'"  #CHI-9C0025

         CALL cl_cmdat('axcr610',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr610_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr610()
   ERROR ""
 END WHILE
 CLOSE WINDOW axcr610_w
 
END FUNCTION
 
FUNCTION axcr610()
   DEFINE l_name    LIKE type_file.chr20,          #No.FUN-680122HAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0146
          l_sql     LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          amt1,amt2 LIKE oeb_file.oeb13,         #No.FUN-680122 DECIMAL(20,6)
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_bucket      LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_order   ARRAY[5] OF LIKE cre_file.cre08,           #No.FUN-680122CHAR(10)
         #l_cao02   LIKE cao_file.cao02,          #FUN-7B0121 add  #CHI-9A0051
         #l_cao03   LIKE cao_file.cao03,          #FUN-7B0121 add  #CHI-9A0051
          sr        RECORD
                    #order     LIKE type_file.chr50,           #No.FUN-680122CHAR(10) #MOD-9C0347   #FUN-C30190 mark
                    l_order   LIKE cma_file.cma01,  #FUN-C30190 add
                    cma01     LIKE cma_file.cma01,    #料號
                    cma02     LIKE cma_file.cma02,    #計算基準
                    cma03     LIKE cma_file.cma03,    #
                    cma04     LIKE cma_file.cma04,    #材料分類
                    cma07     LIKE cma_file.cma07,    #CHI-9C0025
                    cma08     LIKE cma_file.cma08,    #CHI-9C0025
                    cma14     LIKE cma_file.cma14,    #月平均單價
                    cma15     LIKE cma_file.cma15,    #庫存量
                    cmc03     LIKE cmc_file.cmc03,    #異動日(cma16)
                    cmc04     LIKE cmc_file.cmc04,    #數量         #FUN-C30190 add ,
                    #FUN-C30190---add---Str
                    l_qty0    LIKE cma_file.cma15,
                    l_qty1    LIKE cma_file.cma15,
                    l_qty2    LIKE cma_file.cma15,
                    l_qty3    LIKE cma_file.cma15,
                    l_qty4    LIKE cma_file.cma15,
                    l_amt0    LIKE oeb_file.oeb13,
                    l_amt1    LIKE oeb_file.oeb13,
                    l_amt2    LIKE oeb_file.oeb13,
                    l_amt3    LIKE oeb_file.oeb13,
                    l_amt4    LIKE oeb_file.oeb13,
                    l_slow    LIKE oeb_file.oeb13
                    #FUN-C30190---add---End
                    END RECORD
  
     #FUN-C30190---add---Str
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
     #FUN-C30190---add---End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     IF tm.c = '1' THEN     #先進先出
        #LET l_sql="SELECT '',cma01,cma02,cma03,cma04,cma07,cma08,cma14,cma15,cmc03,cmc04", #CHI-9C0025  #FUN-C30190 mark
        LET l_sql="SELECT '',cma01,cma02,cma03,cma04,cma07,cma08,cma14,cma15,cmc03,cmc04,'','','','','','','','','','',''",   #FUN-C30190 add
                  #"  FROM cma_file,cmc_file",  #FUN-C40067
                  "  FROM cma_file,cmc_file,ima_file",  #FUN-C40067
                  " WHERE cma01 = cmc01",
                  "   AND cma01 = ima01",  #FUN-C40067
                  "   AND cma02 = '",tm.cma02,"'",
                  "   AND cmc02 = '",tm.cma02,"'",
                  "   AND cma15 <> 0 ",    #不包括零庫存
                  "   AND cma021=",tm.yy,  #FUN-8B0047
                  "   AND cma022=",tm.mm,  #FUN-8B0047
                  "   AND cma021 = cmc021 ", #CHI-9C0025
                  "   AND cma022 = cmc022 ", #CHI-9C0025
                  "   AND cma07 = '",tm.ctype,"' ", #CHI-9C0025
                  "   AND cma07 = cmc07 ", #CHI-9C0025
                  "   AND cma08 = cmc08 ", #CHI-9C0025
                  "   AND ",tm.wc CLIPPED
     ELSE
        #LET l_sql="SELECT '',cma01,cma02,cma03,cma04,cma07,cma08,cma14,cma15,cma16,0", #CHI-9C0025  #FUN-C30190 mark
        LET l_sql="SELECT '',cma01,cma02,cma03,cma04,cma07,cma08,cma14,cma15,cma16,0,'','','','','','','','','','',''",   #FUN-C30190 add
                  #"  FROM cma_file",   #FUN-C40067
                  "  FROM cma_file,ima_file",   #FUN-C40067
                  " WHERE cma02 = '",tm.cma02,"'",
                  "   AND cma01 = ima01", #FUN-C40067
                  "   AND cma15 <> 0 ",    #不包括零庫存
                  "   AND cma07 = '",tm.ctype,"' ", #CHI-9C0025
                  "   AND cma021=",tm.yy, #FUN-8B0047
                  "   AND cma022=",tm.mm, #FUN-8B0047
                  "   AND ",tm.wc CLIPPED
     END IF

     PREPARE axcr610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
        EXIT PROGRAM
     END IF
     DECLARE axcr610_curs1 CURSOR FOR axcr610_prepare1
 
    #str FUN-7B0121 add
    #抓取庫齡開帳資料
    #CHI-9A0051--begin--mark-----
    #LET l_sql="SELECT cao02,cao03 FROM cao_file",
    #          " WHERE cao01 = ? ",
    #          "   AND cao07 = ? ",  #CHI-9C0025
    #          "   AND cao08 = ? ",  #CHI-9C0025
    #          "   AND cao02+",tm.i41,">='",tm.cma02,"'"
    #PREPARE axcr610_prepare2 FROM l_sql
    #DECLARE axcr610_curs2 CURSOR WITH HOLD FOR axcr610_prepare2
    #CHI-9A0051--end--mark-----
    #end FUN-7B0121 add
 
     #CALL cl_outnam('axcr610') RETURNING l_name    #FUN-C30190 mark
     #START REPORT axcr610_rep TO l_name            #FUN-C30190 mark
 
     LET g_pageno = 0
     LET g_cma15=0    LET A_cma15=0     LET O_cma15=0     LET t_cma15=0
     LET g_cma14=0    LET A_cma14=0     LET O_cma14=0     LET t_cma14=0
     LET g_tot_qty0=0   #MOD-6C0043 add
     LET g_tot_qty1=0 LET g_tot_qty2=0  LET g_tot_qty3=0  LET g_tot_qty4=0
     LET g_tot_amt0=0   #MOD-6C0043 add
     LET g_tot_amt1=0 LET g_tot_amt2=0  LET g_tot_amt3=0  LET g_tot_amt4=0
     LET g_tot_slow=0
     LET t_tot_qty0=0   #MOD-6C0043 add
     LET t_tot_qty1=0 LET t_tot_qty2=0  LET t_tot_qty3=0  LET t_tot_qty4=0
     LET t_tot_amt0=0   #MOD-6C0043 add
     LET t_tot_amt1=0 LET t_tot_amt2=0  LET t_tot_amt3=0  LET t_tot_amt4=0
     LET t_tot_slow=0
     LET A_tot_qty0=0   #MOD-6C0043 add
     LET A_tot_qty1=0 LET A_tot_qty2=0  LET A_tot_qty3=0  LET A_tot_qty4=0
     LET A_tot_amt0=0   #MOD-6C0043 add
     LET A_tot_amt1=0 LET A_tot_amt2=0  LET A_tot_amt3=0  LET A_tot_amt4=0
     LET A_tot_slow=0
     LET O_tot_qty0=0   #MOD-6C0043 add
     LET O_tot_qty1=0 LET O_tot_qty2=0  LET O_tot_qty3=0  LET O_tot_qty4=0
     LET O_tot_amt0=0   #MOD-6C0043 add
     LET O_tot_amt1=0 LET O_tot_amt2=0  LET O_tot_amt3=0  LET O_tot_amt4=0
     LET O_tot_slow=0
     FOREACH axcr610_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #LET sr.order = sr.cma01,sr.cma08 #CHI-9C0025   #FUN-C30190 mark
        LET sr.l_order = sr.cma01,sr.cma08              #FUN-C30190 add
       #CALL cl_digcut(sr.cma15,g_ccz.ccz27) RETURNING sr.cma15 #MOD-C30038       #MOD-D30257 mark
       #str FUN-7B0121 add
       #抓取庫齡開帳資料
       #CHI-9A0051--begin--mark-------
       #OPEN axcr610_curs2 USING sr.cma01,sr.cma07,sr.cma08  #CHI-9C0025
       #FETCH axcr610_curs2 INTO l_cao02,l_cao03
       #CLOSE axcr610_curs2
       #IF cl_null(l_cao03) THEN LET l_cao03=0 END IF
       #CHI-9A0051--end--mark----------
       #end FUN-7B0121 add
       #OUTPUT TO REPORT axcr610_rep(sr.*,l_cao02,l_cao03)   #FUN-7B0121 add l_cao02,l_cao03
       #OUTPUT TO REPORT axcr610_rep(sr.*)   #FUN-7B0121 add l_cao02,l_cao03   #FUN-C30190 mark
       #FUN-C30190---add---Str
       LET sr.l_slow = 0
       LET sr.l_qty0 = 0
       LET sr.l_qty1 = 0
       LET sr.l_qty2 = 0
       LET sr.l_qty3 = 0
       LET sr.l_qty4 = 0
       LET sr.l_amt0 = 0
       LET sr.l_amt1 = 0
       LET sr.l_amt2 = 0
       LET sr.l_amt3 = 0
       LET sr.l_amt4 = 0
       LET g_cma15 = g_cma15+sr.cma15 
       LET t_cma15 = t_cma15+sr.cma15  
       LET g_cma14 = g_cma14+sr.cma15*sr.cma14  
       LET t_cma14 = t_cma14+sr.cma15*sr.cma14  
       IF sr.cma04 = 'A' THEN
          LET A_cma15 = A_cma15 + sr.cma15            
          LET A_cma14 = A_cma14 + sr.cma15*sr.cma14  
       ELSE
          LET O_cma15 = O_cma15 + sr.cma15           
          LET O_cma14 = O_cma14 + sr.cma15*sr.cma14  
       END IF
       LET t_cma15=0
       LET A_cma15=0
       LET O_cma15=0
       LET t_cma14=0
       LET A_cma14=0
       LET O_cma14=0
       IF tm.c = '1' THEN     #先進先出
          LET l_bucket=tm.cma02 - sr.cmc03
          CASE WHEN l_bucket>=tm.i00 AND l_bucket<=tm.i01
                        LET sr.l_qty0=sr.l_qty0+sr.cmc04
                        LET sr.l_amt0=sr.l_amt0+sr.cmc04*sr.cma14
                        LET t_tot_qty0 = t_tot_qty0 + sr.cmc04
                        LET t_tot_amt0 = t_tot_amt0 + sr.cmc04*sr.cma14
                        LET g_tot_qty0 = g_tot_qty0 +  sr.cmc04
                        LET g_tot_amt0 = g_tot_amt0 +  sr.cmc04*sr.cma14
                        IF sr.cma04 = 'A' THEN
                           LET A_tot_qty0 = A_tot_qty0 + sr.cmc04
                           LET A_tot_amt0 = A_tot_amt0 + sr.cmc04*sr.cma14
                        ELSE
                           LET O_tot_qty0 = O_tot_qty0 + sr.cmc04
                           LET O_tot_amt0 = O_tot_amt0 + sr.cmc04*sr.cma14
                        END IF
                 WHEN l_bucket>=tm.i10 AND l_bucket<=tm.i11
                        LET sr.l_qty1=sr.l_qty1+sr.cmc04
                        LET sr.l_amt1=sr.l_amt1+sr.cmc04*sr.cma14
                        LET t_tot_qty1 = t_tot_qty1 + sr.cmc04
                        LET t_tot_amt1 = t_tot_amt1 + sr.cmc04*sr.cma14
                        LET g_tot_qty1 = g_tot_qty1 +  sr.cmc04
                        LET g_tot_amt1 = g_tot_amt1 +  sr.cmc04*sr.cma14
                        IF sr.cma04 = 'A' THEN
                           LET A_tot_qty1 = A_tot_qty1 + sr.cmc04
                           LET A_tot_amt1 = A_tot_amt1 + sr.cmc04*sr.cma14
                        ELSE
                           LET O_tot_qty1 = O_tot_qty1 + sr.cmc04
                           LET O_tot_amt1 = O_tot_amt1 + sr.cmc04*sr.cma14
                        END IF
                 WHEN l_bucket>=tm.i20 AND l_bucket<=tm.i21
                        LET sr.l_qty2=sr.l_qty2+sr.cmc04
                        LET sr.l_amt2=sr.l_amt2+sr.cmc04*sr.cma14
                        LET t_tot_qty2 = t_tot_qty2 +sr.cmc04
                        LET t_tot_amt2 = t_tot_amt2 + sr.cmc04*sr.cma14
                        LET g_tot_qty2 = g_tot_qty2 + sr.cmc04
                        LET g_tot_amt2 = g_tot_amt2 + sr.cmc04*sr.cma14
                        IF sr.cma04 = 'A' THEN
                           LET A_tot_qty2 = A_tot_qty2 +sr.cmc04
                           LET A_tot_amt2 = A_tot_amt2 +sr.cmc04*sr.cma14
                        ELSE
                           LET O_tot_qty2 = O_tot_qty2 +sr.cmc04
                           LET O_tot_amt2 = O_tot_amt2 +sr.cmc04*sr.cma14
                        END IF
                 WHEN l_bucket>=tm.i30 AND l_bucket<=tm.i31
                        LET sr.l_qty3=sr.l_qty3+sr.cmc04
                        LET sr.l_amt3=sr.l_amt3+sr.cmc04*sr.cma14
                        LET t_tot_qty3 = t_tot_qty3 + sr.cmc04
                        LET t_tot_amt3 = t_tot_amt3 + sr.cmc04*sr.cma14
                        LET g_tot_qty3 = g_tot_qty3 + sr.cmc04
                        LET g_tot_amt3 = g_tot_amt3 + sr.cmc04*sr.cma14
                        IF sr.cma04 = 'A' THEN
                           LET A_tot_qty3 = A_tot_qty3 + sr.cmc04
                           LET A_tot_amt3 = A_tot_amt3 + sr.cmc04*sr.cma14
                        ELSE
                           LET O_tot_qty3 = O_tot_qty3 + sr.cmc04
                           LET O_tot_amt3 = O_tot_amt3 + sr.cmc04*sr.cma14
                        END IF
                 WHEN l_bucket>=tm.i40
                        LET sr.l_qty4=sr.l_qty4+sr.cmc04
                        LET sr.l_amt4=sr.l_amt4+sr.cmc04*sr.cma14
                        LET t_tot_qty4 = t_tot_qty4 + sr.cmc04
                        LET t_tot_amt4 = t_tot_amt4 + sr.cmc04*sr.cma14
                        LET g_tot_qty4 = g_tot_qty4 + sr.cmc04
                        LET g_tot_amt4 = g_tot_amt4 + sr.cmc04*sr.cma14
                        IF sr.cma04 = 'A' THEN
                           LET A_tot_qty4 = A_tot_qty4 + sr.cmc04
                           LET A_tot_amt4 = A_tot_amt4 + sr.cmc04*sr.cma14
                        ELSE
                           LET O_tot_qty4 = O_tot_qty4 + sr.cmc04
                           LET O_tot_amt4 = O_tot_amt4 + sr.cmc04*sr.cma14
                        END IF
                 OTHERWISE EXIT CASE
            END CASE
            END IF
            IF tm.c = '2' THEN      #最近異動日
            LET l_bucket=tm.cma02 - sr.cmc03
            CASE WHEN l_bucket>=tm.i00 AND l_bucket<=tm.i01
                      LET sr.l_qty0=sr.cma15
                      LET sr.l_amt0=sr.l_amt0+sr.cma15*sr.cma14
                      LET t_tot_qty0 = t_tot_qty0 + sr.l_qty0
                      LET t_tot_amt0 = t_tot_amt0 + sr.l_amt0
                      LET g_tot_qty0 = g_tot_qty0 + sr.l_qty0
                      LET g_tot_amt0 = g_tot_amt0 + sr.l_amt0
                      IF sr.cma04 = 'A' THEN
                         LET A_tot_qty0 = A_tot_qty0 + sr.l_qty0
                         LET A_tot_amt0 = A_tot_amt0 + sr.l_amt0
                      ELSE
                         LET O_tot_qty0 = O_tot_qty0 + sr.l_qty0
                         LET O_tot_amt0 = O_tot_amt0 + sr.l_amt0
                      END IF
               WHEN l_bucket>=tm.i10 AND l_bucket<=tm.i11
                      LET sr.l_qty1=sr.cma15
                      LET sr.l_amt1=sr.l_amt1+sr.cma15*sr.cma14
                      LET t_tot_qty1 = t_tot_qty1 + sr.l_qty1
                      LET t_tot_amt1 = t_tot_amt1 + sr.l_amt1
                      LET g_tot_qty1 = g_tot_qty1 + sr.l_qty1
                      LET g_tot_amt1 = g_tot_amt1 + sr.l_amt1
                      IF sr.cma04 = 'A' THEN
                         LET A_tot_qty1 = A_tot_qty1 + sr.l_qty1
                         LET A_tot_amt1 = A_tot_amt1 + sr.l_amt1
                      ELSE
                         LET O_tot_qty1 = O_tot_qty1 + sr.l_qty1
                         LET O_tot_amt1 = O_tot_amt1 + sr.l_amt1
                      END IF
               WHEN l_bucket>=tm.i20 AND l_bucket<=tm.i21
                      LET sr.l_qty2=sr.cma15
                      LET sr.l_amt2=sr.l_amt2+sr.cma15*sr.cma14
                      LET t_tot_qty2 = t_tot_qty2 + sr.l_qty2
                      LET t_tot_amt2 = t_tot_amt2 + sr.l_amt2
                      LET g_tot_qty2 = g_tot_qty2 + sr.l_qty2
                      LET g_tot_amt2 = g_tot_amt2 + sr.l_amt2
                      IF sr.cma04 = 'A' THEN
                         LET A_tot_qty2 = A_tot_qty2 + sr.l_qty2
                         LET A_tot_amt2 = A_tot_amt2 + sr.l_amt2
                      ELSE
                         LET O_tot_qty2 = O_tot_qty2 + sr.l_qty2
                         LET O_tot_amt2 = O_tot_amt2 + sr.l_amt2
                      END IF
               WHEN l_bucket>=tm.i30 AND l_bucket<=tm.i31
                      LET sr.l_qty3=sr.cma15
                      LET sr.l_amt3=sr.l_amt3+sr.cma15*sr.cma14
                      LET t_tot_qty3 = t_tot_qty3 + sr.l_qty3
                      LET t_tot_amt3 = t_tot_amt3 + sr.l_amt3
                      LET g_tot_qty3 = g_tot_qty3 + sr.l_qty3
                      LET g_tot_amt3 = g_tot_amt3 + sr.l_amt3
                      IF sr.cma04 = 'A' THEN
                         LET A_tot_qty3 = A_tot_qty3 + sr.l_qty3
                         LET A_tot_amt3 = A_tot_amt3 + sr.l_amt3
                      ELSE
                         LET O_tot_qty3 = O_tot_qty3 + sr.l_qty3
                         LET O_tot_amt3 = O_tot_amt3 + sr.l_amt3
                      END IF
               WHEN l_bucket>=tm.i40
                      LET sr.l_qty4=sr.cma15
                      LET sr.l_amt4=sr.l_amt4+sr.cma15*sr.cma14
                      LET t_tot_qty4 = t_tot_qty4 + sr.l_qty4
                      LET t_tot_amt4 = t_tot_amt4 + sr.l_amt4
                      LET g_tot_qty4 = g_tot_qty4 + sr.l_qty4
                      LET g_tot_amt4 = g_tot_amt4 + sr.l_amt4
                      IF sr.cma04 = 'A' THEN
                         LET A_tot_qty4 = A_tot_qty4 + sr.l_qty4
                         LET A_tot_amt4 = A_tot_amt4 + sr.l_amt4
                      ELSE
                         LET O_tot_qty4 = O_tot_qty4 + sr.l_qty4
                         LET O_tot_amt4 = O_tot_amt4 + sr.l_amt4
                      END IF
               OTHERWISE EXIT CASE
          END CASE
       END IF
       IF tm.d = '1' THEN    #材料分類
          CASE sr.cma04
             WHEN 'A'
                LET sr.l_slow = (sr.l_amt0+sr.l_amt1+sr.l_amt2+sr.l_amt3+sr.l_amt4)
                                 * tm.k1 /100
             WHEN 'B'
                LET sr.l_slow = (sr.l_amt0+sr.l_amt1+sr.l_amt2+sr.l_amt3+sr.l_amt4)
                                 * tm.k2 /100
             WHEN 'C'
                LET sr.l_slow = (sr.l_amt0+sr.l_amt1+sr.l_amt2+sr.l_amt3+sr.l_amt4)
                                 * tm.k3 /100
          END CASE
       ELSE
          LET sr.l_slow = sr.l_amt0*tm.i02/100 + sr.l_amt1*tm.i12/100 + sr.l_amt2*tm.i22/100 +
                       sr.l_amt3*tm.i32/100 + sr.l_amt4*tm.i42/100
       END IF
       LET t_tot_slow = t_tot_slow + sr.l_slow
       LET g_tot_slow = g_tot_slow + sr.l_slow
       IF sr.cma04 = 'A' THEN
          LET A_tot_slow = A_tot_slow + sr.l_slow
       ELSE
          LET O_tot_slow = O_tot_slow + sr.l_slow
       END IF
       CALL cl_digcut(sr.cma15,g_ccz.ccz27) RETURNING sr.cma15    #MOD-D30257
       CALL cl_digcut(sr.l_qty0,g_ccz.ccz27) RETURNING sr.l_qty0  #MOD-D30257
       CALL cl_digcut(sr.l_qty1,g_ccz.ccz27) RETURNING sr.l_qty1  #MOD-D30257
       CALL cl_digcut(sr.l_qty2,g_ccz.ccz27) RETURNING sr.l_qty2  #MOD-D30257
       CALL cl_digcut(sr.l_qty3,g_ccz.ccz27) RETURNING sr.l_qty3  #MOD-D30257
       CALL cl_digcut(sr.l_qty4,g_ccz.ccz27) RETURNING sr.l_qty4  #MOD-D30257
       EXECUTE  insert_prep  USING sr.*  
       #FUN-C30190---add---End
     END FOREACH
 
     #FINISH REPORT axcr610_rep   #FUN-C30190 mark
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #FUN-C30190 mark
     #FUN-C30190-----add---str----
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY cma03,cma01,cma08,cmc03" 
     CALL cl_wcchp(tm.wc,'cma01')
          RETURNING tm.wc
     LET g_str = tm.wc,";",tm.c,";",tm.d,";",tm.i02,";",tm.i12,";",tm.i22,";",tm.i32,";",tm.i42,";",tm.k1,";",tm.k2,";",tm.k3,";",
                 #g_ccz.ccz27,";",g_azi03,";",tm.i01,";",tm.i11,";",tm.i21,";",tm.i31  #CHI-C30012
                 g_ccz.ccz27,";",g_ccz.ccz26,";",tm.i01,";",tm.i11,";",tm.i21,";",tm.i31  #CHI-C30012
     CALL cl_prt_cs3("axcr610","axcr610",l_sql,g_str)
     #FUN-C30190-----add---end----
END FUNCTION
 
#REPORT axcr610_rep(sr,l_cao02,l_cao03)  #FUN-7B0121 add l_cao02,l_cao03 #CHI-9A0051
#FUN-C30190-------mark----str----
#REPORT axcr610_rep(sr)                   #CHI-9A0051  
#   DEFINE l_last_sw LIKE type_file.chr1,    #No.FUN-680122CHAR(1)
#          l_bucket  LIKE type_file.num5,    #No.FUN-680122SMALLINT
#          l_bucket1 LIKE type_file.num5,    #FUN-7B0121 add
#          l_qty0    LIKE cma_file.cma15,    #MOD-6C0043 add
#          l_qty1    LIKE cma_file.cma15,
#          l_qty2    LIKE cma_file.cma15,
#          l_qty3    LIKE cma_file.cma15,
#          l_qty4    LIKE cma_file.cma15,
#         # l_A_qty   LIKE ima_file.ima26,    #No.FUN-680122DEC(15,3)#FUN-A20044
#          l_A_qty   LIKE type_file.num15_3,    #No.FUN-680122DEC(15,3)#FUN-A20044
#        #  l_O_qty   LIKE ima_file.ima26,    #No.FUN-680122DEC(15,3)#FUN-A20044
#          l_O_qty   LIKE type_file.num15_3 ,    #No.FUN-680122DEC(15,3)#FUN-A20044
#          l_A_sum   LIKE oeb_file.oeb13,    #No.FUN-680122DEC(20,6)
#          l_O_sum   LIKE oeb_file.oeb13,    #No.FUN-680122DEC(20,6)
#          l_amt0    LIKE oeb_file.oeb13,    #MOD-6C0043 add
#          l_amt1    LIKE oeb_file.oeb13,    #No.FUN-680122 DECIMAL(20,6)
#          l_amt2    LIKE oeb_file.oeb13,    #No.FUN-680122 DECIMAL(20,6)
#          l_amt3    LIKE oeb_file.oeb13,    #No.FUN-680122 DECIMAL(20,6)
#          l_amt4    LIKE oeb_file.oeb13,    #No.FUN-680122 DECIMAL(20,6)
#          l_slow    LIKE oeb_file.oeb13,    #No.FUN-680122DEC(20,6)
#          l_str     LIKE type_file.chr4,    #No.FUN-680122CHAR(04) #TQC-840066
#         #l_cao02   LIKE cao_file.cao02,    #FUN-7B0121 add  #CHI-9A0051
#         #l_cao03   LIKE cao_file.cao03,    #FUN-7B0121 add  #CHI-9A0051
#          sr        RECORD
#                    order     LIKE type_file.chr50,           #No.FUN-680122CHAR(10)  #CHI-9C0025
#                    cma01     LIKE cma_file.cma01,    #料號
#                    cma02     LIKE cma_file.cma02,    #計算基準
#                    cma03     LIKE cma_file.cma03,    #
#                    cma04     LIKE cma_file.cma04,    #材料分類
#                    cma07     LIKE cma_file.cma07,    #CHI-9C0025
#                    cma08     LIKE cma_file.cma08,    #CHI-9C0025
#                    cma14     LIKE cma_file.cma14,    #月平均單價
#                    cma15     LIKE cma_file.cma15,    #庫存量
#                    cmc03     LIKE cmc_file.cmc03,    #異動日(cma16)
#                    cmc04     LIKE cmc_file.cmc04     #數量
#                    END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
# #ORDER BY sr.cma03,sr.cma01,sr.cmc03   #CHI-9C0025
#  ORDER BY sr.cma03,sr.cma01,sr.order,sr.cmc03   #CHI-9C0025
##No.FUN-580014-begin
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#      PRINT g_x[15] CLIPPED,tm.cma02
#      PRINT g_dash[1,g_len]
#      LET g_zaa[54].zaa08='Q -',tm.i01 USING '#####&'   #MOD-6C0043 add     #MOD-A10158 add ###            
#      LET g_zaa[55].zaa08='A -',tm.i01 USING '#####&'   #MOD-6C0043 add     #MOD-A10158 add ###              
#      LET g_zaa[44].zaa08='Q -',tm.i11 USING '#####&'                       #MOD-A10158 add ###   
#      LET g_zaa[45].zaa08='A -',tm.i11 USING '#####&'                       #MOD-A10158 add ###  
#      LET g_zaa[46].zaa08='Q -',tm.i21 USING '#####&'                       #MOD-A10158 add ### 
#      LET g_zaa[47].zaa08='A -',tm.i21 USING '#####&'                       #MOD-A10158 add ###  
#      LET g_zaa[48].zaa08='Q -',tm.i31 USING '#####&'                       #MOD-A10158 add ###  
#      LET g_zaa[49].zaa08='A -',tm.i31 USING '#####&'                       #MOD-A10158 add ###   
#      LET g_zaa[50].zaa08='Q -',tm.i31 USING '#####&','UP'                  #MOD-A10158 add ###        
#      LET g_zaa[51].zaa08='A -',tm.i31 USING '#####&','UP'                  #MOD-A10158 add ###         
#     #PRINT g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],                   #MOD-6C0043 mark
#      PRINT g_x[41],g_x[57],g_x[42],g_x[43],g_x[54],g_x[55],g_x[44],g_x[45],g_x[46],   #MOD-6C0043 add g_x[54],g_x[55] #CHI-9C0025
#            g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],g_x[52],g_x[53]
#      PRINT g_dash1
# 
#  #BEFORE GROUP OF sr.cma01
#   BEFORE GROUP OF sr.order #CHI-9C0025
#       LET l_slow = 0
#       LET l_qty0 = 0   #MOD-6C0043 add
#       LET l_qty1 = 0   LET l_qty2 = 0    LET l_qty3 = 0    LET l_qty4 = 0
#       LET l_amt0 = 0   #MOD-6C0043 add
#       LET l_amt1 = 0   LET l_amt2 = 0    LET l_amt3 = 0    LET l_amt4 = 0
#       LET g_cma15 = g_cma15+sr.cma15   #FUN-7B0121 add l_cao03 #CHI-9A0051
#       LET t_cma15 = t_cma15+sr.cma15   #FUN-7B0121 add l_cao03 #CHI-9A0051
#       LET g_cma14 = g_cma14+sr.cma15*sr.cma14   #FUN-7B0121 add l_cao03*sr.cma14 #CHI-9A0051
#       LET t_cma14 = t_cma14+sr.cma15*sr.cma14   #FUN-7B0121 add l_cao03*sr.cma14 #CHI-9A0051
#       IF sr.cma04 = 'A' THEN
#          LET A_cma15 = A_cma15 + sr.cma15            #FUN-7B0121 add l_cao03 #CHI-9A0051
#          LET A_cma14 = A_cma14 + sr.cma15*sr.cma14   #FUN-7B0121 add l_cao03*sr.cma14 #CHI-9A0051
#       ELSE
#          LET O_cma15 = O_cma15 + sr.cma15            #FUN-7B0121 add l_cao03 #CHI-9A0051
#          LET O_cma14 = O_cma14 + sr.cma15*sr.cma14   #FUN-7B0121 add l_cao03*sr.cma14 #CHI-9A0051
#       END IF
#   
#   BEFORE GROUP OF sr.cma03    #分類
#       LET t_cma15=0
#       LET A_cma15=0
#       LET O_cma15=0
#       LET t_cma14=0
#       LET A_cma14=0
#       LET O_cma14=0
# 
#   ON EVERY ROW
#       IF tm.c = '1' THEN     #先進先出
#          LET l_bucket=tm.cma02 - sr.cmc03
#         #start MOD-6C0043 add
#          CASE WHEN l_bucket>=tm.i00 AND l_bucket<=tm.i01
#                      LET l_qty0=l_qty0+sr.cmc04
#                      LET l_amt0=l_amt0+sr.cmc04*sr.cma14
#                      LET t_tot_qty0 = t_tot_qty0 + sr.cmc04
#                      LET t_tot_amt0 = t_tot_amt0 + sr.cmc04*sr.cma14
#                      LET g_tot_qty0 = g_tot_qty0 +  sr.cmc04
#                      LET g_tot_amt0 = g_tot_amt0 +  sr.cmc04*sr.cma14
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty0 = A_tot_qty0 + sr.cmc04
#                         LET A_tot_amt0 = A_tot_amt0 + sr.cmc04*sr.cma14
#                      ELSE
#                         LET O_tot_qty0 = O_tot_qty0 + sr.cmc04
#                         LET O_tot_amt0 = O_tot_amt0 + sr.cmc04*sr.cma14
#                      END IF
#         #end MOD-6C0043 add
#               WHEN l_bucket>=tm.i10 AND l_bucket<=tm.i11
#                      LET l_qty1=l_qty1+sr.cmc04
#                      LET l_amt1=l_amt1+sr.cmc04*sr.cma14
#                      LET t_tot_qty1 = t_tot_qty1 + sr.cmc04
#                      LET t_tot_amt1 = t_tot_amt1 + sr.cmc04*sr.cma14
#                      LET g_tot_qty1 = g_tot_qty1 +  sr.cmc04
#                      LET g_tot_amt1 = g_tot_amt1 +  sr.cmc04*sr.cma14
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty1 = A_tot_qty1 + sr.cmc04
#                         LET A_tot_amt1 = A_tot_amt1 + sr.cmc04*sr.cma14
#                      ELSE
#                         LET O_tot_qty1 = O_tot_qty1 + sr.cmc04
#                         LET O_tot_amt1 = O_tot_amt1 + sr.cmc04*sr.cma14
#                      END IF
#               WHEN l_bucket>=tm.i20 AND l_bucket<=tm.i21
#                      LET l_qty2=l_qty2+sr.cmc04
#                      LET l_amt2=l_amt2+sr.cmc04*sr.cma14
#                      LET t_tot_qty2 = t_tot_qty2 +sr.cmc04
#                      LET t_tot_amt2 = t_tot_amt2 + sr.cmc04*sr.cma14
#                      LET g_tot_qty2 = g_tot_qty2 + sr.cmc04
#                      LET g_tot_amt2 = g_tot_amt2 + sr.cmc04*sr.cma14
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty2 = A_tot_qty2 +sr.cmc04
#                         LET A_tot_amt2 = A_tot_amt2 +sr.cmc04*sr.cma14
#                      ELSE
#                         LET O_tot_qty2 = O_tot_qty2 +sr.cmc04
#                         LET O_tot_amt2 = O_tot_amt2 +sr.cmc04*sr.cma14
#                      END IF
#               WHEN l_bucket>=tm.i30 AND l_bucket<=tm.i31
#                      LET l_qty3=l_qty3+sr.cmc04
#                      LET l_amt3=l_amt3+sr.cmc04*sr.cma14
#                      LET t_tot_qty3 = t_tot_qty3 + sr.cmc04
#                      LET t_tot_amt3 = t_tot_amt3 + sr.cmc04*sr.cma14
#                      LET g_tot_qty3 = g_tot_qty3 + sr.cmc04
#                      LET g_tot_amt3 = g_tot_amt3 + sr.cmc04*sr.cma14
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty3 = A_tot_qty3 + sr.cmc04
#                         LET A_tot_amt3 = A_tot_amt3 + sr.cmc04*sr.cma14
#                      ELSE
#                         LET O_tot_qty3 = O_tot_qty3 + sr.cmc04
#                         LET O_tot_amt3 = O_tot_amt3 + sr.cmc04*sr.cma14
#                      END IF
#               WHEN l_bucket>=tm.i40
#                      LET l_qty4=l_qty4+sr.cmc04
#                      LET l_amt4=l_amt4+sr.cmc04*sr.cma14
#                      LET t_tot_qty4 = t_tot_qty4 + sr.cmc04
#                      LET t_tot_amt4 = t_tot_amt4 + sr.cmc04*sr.cma14
#                      LET g_tot_qty4 = g_tot_qty4 + sr.cmc04
#                      LET g_tot_amt4 = g_tot_amt4 + sr.cmc04*sr.cma14
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty4 = A_tot_qty4 + sr.cmc04
#                         LET A_tot_amt4 = A_tot_amt4 + sr.cmc04*sr.cma14
#                      ELSE
#                         LET O_tot_qty4 = O_tot_qty4 + sr.cmc04
#                         LET O_tot_amt4 = O_tot_amt4 + sr.cmc04*sr.cma14
#                      END IF
#               OTHERWISE EXIT CASE
#          END CASE
#         #str FUN-7B0121 add
##FUN-940049--mark--
##         IF NOT cl_null(l_cao02) THEN
##            LET l_bucket1=tm.cma02 - l_cao02   #計算庫齡開帳資料落在哪個區段
##            CASE WHEN l_bucket1>=tm.i00 AND l_bucket1<=tm.i01
##                      LET l_qty0=l_qty0+l_cao03
##                      LET l_amt0=l_amt0+l_cao03*sr.cma14
##                      LET t_tot_qty0 = t_tot_qty0 + l_cao03
##                      LET t_tot_amt0 = t_tot_amt0 + l_cao03*sr.cma14
##                      LET g_tot_qty0 = g_tot_qty0 + l_cao03
##                      LET g_tot_amt0 = g_tot_amt0 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty0 = A_tot_qty0 + l_cao03
##                         LET A_tot_amt0 = A_tot_amt0 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty0 = O_tot_qty0 + l_cao03
##                         LET O_tot_amt0 = O_tot_amt0 + l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i10 AND l_bucket1<=tm.i11
##                      LET l_qty1=l_qty1+l_cao03
##                      LET l_amt1=l_amt1+l_cao03*sr.cma14
##                      LET t_tot_qty1 = t_tot_qty1 + l_cao03
##                      LET t_tot_amt1 = t_tot_amt1 + l_cao03*sr.cma14
##                      LET g_tot_qty1 = g_tot_qty1 + l_cao03
##                      LET g_tot_amt1 = g_tot_amt1 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty1 = A_tot_qty1 + l_cao03
##                         LET A_tot_amt1 = A_tot_amt1 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty1 = O_tot_qty1 + l_cao03
##                         LET O_tot_amt1 = O_tot_amt1 + l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i20 AND l_bucket1<=tm.i21
##                      LET l_qty2=l_qty2+l_cao03
##                      LET l_amt2=l_amt2+l_cao03*sr.cma14
##                      LET t_tot_qty2 = t_tot_qty2 + l_cao03
##                      LET t_tot_amt2 = t_tot_amt2 + l_cao03*sr.cma14
##                      LET g_tot_qty2 = g_tot_qty2 + l_cao03
##                      LET g_tot_amt2 = g_tot_amt2 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty2 = A_tot_qty2 +l_cao03
##                         LET A_tot_amt2 = A_tot_amt2 +l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty2 = O_tot_qty2 +l_cao03
##                         LET O_tot_amt2 = O_tot_amt2 +l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i30 AND l_bucket1<=tm.i31
##                      LET l_qty3=l_qty3+l_cao03
##                      LET l_amt3=l_amt3+l_cao03*sr.cma14
##                      LET t_tot_qty3 = t_tot_qty3 + l_cao03
##                      LET t_tot_amt3 = t_tot_amt3 + l_cao03*sr.cma14
##                      LET g_tot_qty3 = g_tot_qty3 + l_cao03
##                      LET g_tot_amt3 = g_tot_amt3 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty3 = A_tot_qty3 + l_cao03
##                         LET A_tot_amt3 = A_tot_amt3 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty3 = O_tot_qty3 + l_cao03
##                         LET O_tot_amt3 = O_tot_amt3 + l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i40
##                      LET l_qty4=l_qty4+l_cao03
##                      LET l_amt4=l_amt4+l_cao03*sr.cma14
##                      LET t_tot_qty4 = t_tot_qty4 + l_cao03
##                      LET t_tot_amt4 = t_tot_amt4 + l_cao03*sr.cma14
##                      LET g_tot_qty4 = g_tot_qty4 + l_cao03
##                      LET g_tot_amt4 = g_tot_amt4 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty4 = A_tot_qty4 + l_cao03
##                         LET A_tot_amt4 = A_tot_amt4 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty4 = O_tot_qty4 + l_cao03
##                         LET O_tot_amt4 = O_tot_amt4 + l_cao03*sr.cma14
##                      END IF
##                 OTHERWISE EXIT CASE
##            END CASE
##         END IF
##FUN-940049--end--mark--
#         #end FUN-7B0121 add
#       END IF
# 
#  #AFTER GROUP OF sr.cma01  #CHI-9C0025
#   AFTER GROUP OF sr.order  #CHI-9C0025
#      IF tm.c = '2' THEN      #最近異動日
#          LET l_bucket=tm.cma02 - sr.cmc03
#         #start MOD-6C0043 add
#          CASE WHEN l_bucket>=tm.i00 AND l_bucket<=tm.i01
#                      LET l_qty0=sr.cma15
#                      LET l_amt0=l_amt0+sr.cma15*sr.cma14
#                      LET t_tot_qty0 = t_tot_qty0 + l_qty0
#                      LET t_tot_amt0 = t_tot_amt0 + l_amt0
#                      LET g_tot_qty0 = g_tot_qty0 + l_qty0
#                      LET g_tot_amt0 = g_tot_amt0 + l_amt0
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty0 = A_tot_qty0 + l_qty0
#                         LET A_tot_amt0 = A_tot_amt0 + l_amt0
#                      ELSE
#                         LET O_tot_qty0 = O_tot_qty0 + l_qty0
#                         LET O_tot_amt0 = O_tot_amt0 + l_amt0
#                      END IF
#         #end MOD-6C0043 add
#               WHEN l_bucket>=tm.i10 AND l_bucket<=tm.i11
#                      LET l_qty1=sr.cma15
#                      LET l_amt1=l_amt1+sr.cma15*sr.cma14
#                      LET t_tot_qty1 = t_tot_qty1 + l_qty1
#                      LET t_tot_amt1 = t_tot_amt1 + l_amt1
#                      LET g_tot_qty1 = g_tot_qty1 + l_qty1
#                      LET g_tot_amt1 = g_tot_amt1 + l_amt1
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty1 = A_tot_qty1 + l_qty1
#                         LET A_tot_amt1 = A_tot_amt1 + l_amt1
#                      ELSE
#                         LET O_tot_qty1 = O_tot_qty1 + l_qty1
#                         LET O_tot_amt1 = O_tot_amt1 + l_amt1
#                      END IF
#               WHEN l_bucket>=tm.i20 AND l_bucket<=tm.i21  #MOD-580349
#                      LET l_qty2=sr.cma15
#                      LET l_amt2=l_amt2+sr.cma15*sr.cma14
#                      LET t_tot_qty2 = t_tot_qty2 + l_qty2
#                      LET t_tot_amt2 = t_tot_amt2 + l_amt2
#                      LET g_tot_qty2 = g_tot_qty2 + l_qty2
#                      LET g_tot_amt2 = g_tot_amt2 + l_amt2
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty2 = A_tot_qty2 + l_qty2
#                         LET A_tot_amt2 = A_tot_amt2 + l_amt2
#                      ELSE
#                         LET O_tot_qty2 = O_tot_qty2 + l_qty2
#                         LET O_tot_amt2 = O_tot_amt2 + l_amt2
#                      END IF
#               WHEN l_bucket>=tm.i30 AND l_bucket<=tm.i31
#                      LET l_qty3=sr.cma15
#                      LET l_amt3=l_amt3+sr.cma15*sr.cma14
#                      LET t_tot_qty3 = t_tot_qty3 + l_qty3
#                      LET t_tot_amt3 = t_tot_amt3 + l_amt3
#                      LET g_tot_qty3 = g_tot_qty3 + l_qty3
#                      LET g_tot_amt3 = g_tot_amt3 + l_amt3
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty3 = A_tot_qty3 + l_qty3
#                         LET A_tot_amt3 = A_tot_amt3 + l_amt3
#                      ELSE
#                         LET O_tot_qty3 = O_tot_qty3 + l_qty3
#                         LET O_tot_amt3 = O_tot_amt3 + l_amt3
#                      END IF
#               WHEN l_bucket>=tm.i40
#                      LET l_qty4=sr.cma15
#                      LET l_amt4=l_amt4+sr.cma15*sr.cma14
#                      LET t_tot_qty4 = t_tot_qty4 + l_qty4
#                      LET t_tot_amt4 = t_tot_amt4 + l_amt4
#                      LET g_tot_qty4 = g_tot_qty4 + l_qty4
#                      LET g_tot_amt4 = g_tot_amt4 + l_amt4
#                      IF sr.cma04 = 'A' THEN
#                         LET A_tot_qty4 = A_tot_qty4 + l_qty4
#                         LET A_tot_amt4 = A_tot_amt4 + l_amt4
#                      ELSE
#                         LET O_tot_qty4 = O_tot_qty4 + l_qty4
#                         LET O_tot_amt4 = O_tot_amt4 + l_amt4
#                      END IF
#               OTHERWISE EXIT CASE
#          END CASE
#         #str FUN-7B0121 add
##FUN-940049--begin--mark--
##         IF NOT cl_null(l_cao02) THEN
##            LET l_bucket1=tm.cma02 - l_cao02   #計算庫齡開帳資料落在哪個區段
##            CASE WHEN l_bucket1>=tm.i00 AND l_bucket1<=tm.i01
##                      LET l_qty0=l_qty0+l_cao03
##                      LET l_amt0=l_amt0+l_cao03*sr.cma14
##                      LET t_tot_qty0 = t_tot_qty0 + l_cao03
##                      LET t_tot_amt0 = t_tot_amt0 + l_cao03*sr.cma14
##                      LET g_tot_qty0 = g_tot_qty0 + l_cao03
##                      LET g_tot_amt0 = g_tot_amt0 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty0 = A_tot_qty0 + l_cao03
##                         LET A_tot_amt0 = A_tot_amt0 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty0 = O_tot_qty0 + l_cao03
##                         LET O_tot_amt0 = O_tot_amt0 + l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i10 AND l_bucket1<=tm.i11
##                      LET l_qty1=l_qty1+l_cao03
##                      LET l_amt1=l_amt1+l_cao03*sr.cma14
##                      LET t_tot_qty1 = t_tot_qty1 + l_cao03
##                      LET t_tot_amt1 = t_tot_amt1 + l_cao03*sr.cma14
##                      LET g_tot_qty1 = g_tot_qty1 + l_cao03
##                      LET g_tot_amt1 = g_tot_amt1 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty1 = A_tot_qty1 + l_cao03
##                         LET A_tot_amt1 = A_tot_amt1 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty1 = O_tot_qty1 + l_cao03
##                         LET O_tot_amt1 = O_tot_amt1 + l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i20 AND l_bucket1<=tm.i21  #MOD-580349
##                      LET l_qty2=l_qty2+l_cao03
##                      LET l_amt2=l_amt2+l_cao03*sr.cma14
##                      LET t_tot_qty2 = t_tot_qty2 + l_cao03
##                      LET t_tot_amt2 = t_tot_amt2 + l_cao03*sr.cma14
##                      LET g_tot_qty2 = g_tot_qty2 + l_cao03
##                      LET g_tot_amt2 = g_tot_amt2 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty2 = A_tot_qty2 + l_cao03
##                         LET A_tot_amt2 = A_tot_amt2 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty2 = O_tot_qty2 + l_cao03
##                         LET O_tot_amt2 = O_tot_amt2 + l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i30 AND l_bucket1<=tm.i31
##                      LET l_qty3=l_qty3+l_cao03
##                      LET l_amt3=l_amt3+l_cao03*sr.cma14
##                      LET t_tot_qty3 = t_tot_qty3 + l_cao03
##                      LET t_tot_amt3 = t_tot_amt3 + l_cao03*sr.cma14
##                      LET g_tot_qty3 = g_tot_qty3 + l_cao03
##                      LET g_tot_amt3 = g_tot_amt3 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty3 = A_tot_qty3 + l_cao03
##                         LET A_tot_amt3 = A_tot_amt3 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty3 = O_tot_qty3 + l_cao03
##                         LET O_tot_amt3 = O_tot_amt3 + l_cao03*sr.cma14
##                      END IF
##                 WHEN l_bucket1>=tm.i40
##                      LET l_qty4=l_qty4+l_cao03
##                      LET l_amt4=l_amt4+l_cao03*sr.cma14
##                      LET t_tot_qty4 = t_tot_qty4 + l_cao03
##                      LET t_tot_amt4 = t_tot_amt4 + l_cao03*sr.cma14
##                      LET g_tot_qty4 = g_tot_qty4 + l_cao03
##                      LET g_tot_amt4 = g_tot_amt4 + l_cao03*sr.cma14
##                      IF sr.cma04 = 'A' THEN
##                         LET A_tot_qty4 = A_tot_qty4 + l_cao03
##                         LET A_tot_amt4 = A_tot_amt4 + l_cao03*sr.cma14
##                      ELSE
##                         LET O_tot_qty4 = O_tot_qty4 + l_cao03
##                         LET O_tot_amt4 = O_tot_amt4 + l_cao03*sr.cma14
##                      END IF
##                 OTHERWISE EXIT CASE
##            END CASE
##         END IF
##FUN-940049--end--mark--
#         #end FUN-7B0121 add
#       END IF
#       IF tm.d = '1' THEN    #材料分類
#          CASE sr.cma04 
#             WHEN 'A'
#                LET l_slow = (l_amt0+l_amt1+l_amt2+l_amt3+l_amt4)   #MOD-6C0043 add l_amt0
#                              * tm.k1 /100
#             WHEN 'B'
#                LET l_slow = (l_amt0+l_amt1+l_amt2+l_amt3+l_amt4)   #MOD-6C0043 add l_amt0
#                              * tm.k2 /100
#             WHEN 'C'
#                LET l_slow = (l_amt0+l_amt1+l_amt2+l_amt3+l_amt4)   #MOD-6C0043 add l_amt0
#                              * tm.k3 /100
#          END CASE
#       ELSE
#          LET l_slow = l_amt0*tm.i02/100 + l_amt1*tm.i12/100 + l_amt2*tm.i22/100 +   #MOD-6C0043 add l_amt0*tm.i02/100
#                       l_amt3*tm.i32/100 + l_amt4*tm.i42/100
#       END IF
#       LET t_tot_slow = t_tot_slow + l_slow
#       LET g_tot_slow = g_tot_slow + l_slow
#       IF sr.cma04 = 'A' THEN
#          LET A_tot_slow = A_tot_slow + l_slow
#       ELSE
#          LET O_tot_slow = O_tot_slow + l_slow
#       END IF
#       #PRINT COLUMN g_c[41],sr.cma01[1,20],
#       PRINT COLUMN g_c[41],sr.cma01 CLIPPED, #NO.FUN-5B0015
#             COLUMN g_c[57],sr.cma08 CLIPPED, #CHI-9C0025
#             COLUMN g_c[42],cl_numfor(sr.cma15,42,g_ccz.ccz27), #CHI-690007 0->ccz27   #FUN-7B0121 add l_cao03 #CHI-9A0051
#             COLUMN g_c[43],cl_numfor(sr.cma14*sr.cma15,43,g_azi03),                   #FUN-7B0121 add l_cao03 #CHI-9A0051
#             COLUMN g_c[54],cl_numfor(l_qty0,54,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27         #MOD-6C0043 add
#             COLUMN g_c[55],cl_numfor(l_amt0,55,g_azi03),   #MOD-6C0043 add
#             COLUMN g_c[44],cl_numfor(l_qty1,44,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[45],cl_numfor(l_amt1,45,g_azi03),
#             COLUMN g_c[46],cl_numfor(l_qty2,46,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[47],cl_numfor(l_amt2,47,g_azi03),
#             COLUMN g_c[48],cl_numfor(l_qty3,48,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[49],cl_numfor(l_amt3,49,g_azi03),
#             COLUMN g_c[50],cl_numfor(l_qty4,50,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[51],cl_numfor(l_amt4,51,g_azi03),
#             COLUMN g_c[52],sr.cma04 CLIPPED,
#             COLUMN g_c[53],cl_numfor(l_slow,53,g_azi03) #CHI-690007 2->g_azi03
#       LET l_qty0 = 0   #MOD-6C0043 add
#       LET l_qty1 = 0   LET l_qty2 = 0    LET l_qty3 = 0    LET l_qty4 = 0
#       LET l_amt0 = 0   #MOD-6C0043 add
#       LET l_amt1 = 0   LET l_amt2 = 0    LET l_amt3 = 0    LET l_amt4 = 0
#       LET l_slow = 0
# 
#   AFTER GROUP OF sr.cma03    #分類
#       IF sr.cma03 = '0' THEN  #原料
#          LET l_str = g_x[33] CLIPPED
#       ELSE
#          LET l_str = g_x[34] CLIPPED
#       END IF
#       PRINT l_str,' ',g_x[17]CLIPPED,
#             COLUMN g_c[42],cl_numfor(t_cma15,42,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[43],cl_numfor(t_cma14,43,g_azi03),
#             COLUMN g_c[54],cl_numfor(t_tot_qty0,54,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27         #MOD-6C0043 add
#             COLUMN g_c[55],cl_numfor(t_tot_amt0,55,g_azi03),   #MOD-6C0043 add
#             COLUMN g_c[44],cl_numfor(t_tot_qty1,44,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[45],cl_numfor(t_tot_amt1,45,g_azi03),
#             COLUMN g_c[46],cl_numfor(t_tot_qty2,46,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[47],cl_numfor(t_tot_amt2,47,g_azi03),
#             COLUMN g_c[48],cl_numfor(t_tot_qty3,48,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[49],cl_numfor(t_tot_amt3,49,g_azi03),
#             COLUMN g_c[50],cl_numfor(t_tot_qty4,50,g_ccz.ccz27), #CHI-690007 0->g_ccz.ccz27
#             COLUMN g_c[51],cl_numfor(t_tot_amt4,51,g_azi03),
#             COLUMN g_c[53],cl_numfor(t_tot_slow,53,g_azi03)
#       LET l_A_qty = GROUP SUM(sr.cma15) WHERE sr.cma04 = 'A'
#       LET l_O_qty = GROUP SUM(sr.cma15) WHERE sr.cma04 <> 'A'
#       LET l_A_sum = GROUP SUM(sr.cma15*sr.cma14) WHERE sr.cma04 = 'A'
#       LET l_O_sum = GROUP SUM(sr.cma15*sr.cma14) WHERE sr.cma04 <> 'A'
#       IF cl_null(l_A_qty) THEN LET l_A_qty = 0 END IF
#       IF cl_null(l_O_qty) THEN LET l_O_qty = 0 END IF
#       IF cl_null(l_A_sum) THEN LET l_A_sum = 0 END IF
#       IF cl_null(l_O_sum) THEN LET l_O_sum = 0 END IF
#       PRINT g_x[35] CLIPPED,l_str,' ',g_x[16]CLIPPED,
#             COLUMN g_c[42],cl_numfor(A_cma15,42,g_ccz.ccz27),
#             COLUMN g_c[43],cl_numfor(A_cma14,43,g_azi03),
#             COLUMN g_c[54],cl_numfor(A_tot_qty0,54,g_ccz.ccz27),   #MOD-6C0043 add
#             COLUMN g_c[55],cl_numfor(A_tot_amt0,55,g_azi03),   #MOD-6C0043 add
#             COLUMN g_c[44],cl_numfor(A_tot_qty1,44,g_ccz.ccz27),
#             COLUMN g_c[45],cl_numfor(A_tot_amt1,45,g_azi03),
#             COLUMN g_c[46],cl_numfor(A_tot_qty2,46,g_ccz.ccz27),
#             COLUMN g_c[47],cl_numfor(A_tot_amt2,47,g_azi03),
#             COLUMN g_c[48],cl_numfor(A_tot_qty3,48,g_ccz.ccz27),
#             COLUMN g_c[49],cl_numfor(A_tot_amt3,49,g_azi03),
#             COLUMN g_c[50],cl_numfor(A_tot_qty4,50,g_ccz.ccz27),
#             COLUMN g_c[51],cl_numfor(A_tot_amt4,51,g_azi03),
#             COLUMN g_c[53],cl_numfor(A_tot_slow,53,g_azi03)
#       PRINT g_x[36] CLIPPED,l_str,' ',g_x[16]CLIPPED,
#             COLUMN g_c[42],cl_numfor(O_cma15,42,g_ccz.ccz27),
#             COLUMN g_c[43],cl_numfor(O_cma14,43,g_azi03),
#             COLUMN g_c[54],cl_numfor(O_tot_qty0,54,g_ccz.ccz27),   #MOD-6C0043 add
#             COLUMN g_c[55],cl_numfor(O_tot_amt0,55,g_azi03),   #MOD-6C0043 add
#             COLUMN g_c[44],cl_numfor(O_tot_qty1,44,g_ccz.ccz27),
#             COLUMN g_c[45],cl_numfor(O_tot_amt1,45,g_azi03),
#             COLUMN g_c[46],cl_numfor(O_tot_qty2,46,g_ccz.ccz27),
#             COLUMN g_c[47],cl_numfor(O_tot_amt2,47,g_azi03),
#             COLUMN g_c[48],cl_numfor(O_tot_qty3,48,g_ccz.ccz27),
#             COLUMN g_c[49],cl_numfor(O_tot_amt3,49,g_azi03),
#             COLUMN g_c[50],cl_numfor(O_tot_qty4,50,g_ccz.ccz27),
#             COLUMN g_c[51],cl_numfor(O_tot_amt4,51,g_azi03),
#             COLUMN g_c[53],cl_numfor(O_tot_slow,53,g_azi03)
#     LET t_tot_qty0=0   #MOD-6C0043 add
#     LET t_tot_qty1=0 LET t_tot_qty2=0  LET t_tot_qty3=0  LET t_tot_qty4=0
#     LET t_tot_amt0=0   #MOD-6C0043 add
#     LET t_tot_amt1=0 LET t_tot_amt2=0  LET t_tot_amt3=0  LET t_tot_amt4=0
#     LET t_tot_slow=0
#     LET A_tot_qty0=0   #MOD-6C0043 add
#     LET A_tot_qty1=0 LET A_tot_qty2=0  LET A_tot_qty3=0  LET A_tot_qty4=0
#     LET A_tot_amt0=0   #MOD-6C0043 add
#     LET A_tot_amt1=0 LET A_tot_amt2=0  LET A_tot_amt3=0  LET A_tot_amt4=0
#     LET A_tot_slow=0
#     LET O_tot_qty0=0   #MOD-6C0043 add
#     LET O_tot_qty1=0 LET O_tot_qty2=0  LET O_tot_qty3=0  LET O_tot_qty4=0
#     LET O_tot_amt0=0   #MOD-6C0043 add
#     LET O_tot_amt1=0 LET O_tot_amt2=0  LET O_tot_amt3=0  LET O_tot_amt4=0
#     LET O_tot_slow=0
# 
#   ON LAST ROW
#       PRINT COLUMN 14,g_x[18] CLIPPED,
#             COLUMN g_c[42],cl_numfor(g_cma15,42,g_ccz.ccz27),
#             COLUMN g_c[43],cl_numfor(g_cma14,43,g_azi03),
#             COLUMN g_c[54],cl_numfor(g_tot_qty0,54,g_ccz.ccz27),   #MOD-6C0043 add
#             COLUMN g_c[55],cl_numfor(g_tot_amt0,55,g_azi03),   #MOD-6C0043 add
#             COLUMN g_c[44],cl_numfor(g_tot_qty1,44,g_ccz.ccz27),
#             COLUMN g_c[45],cl_numfor(g_tot_amt1,45,g_azi03),
#             COLUMN g_c[46],cl_numfor(g_tot_qty2,46,g_ccz.ccz27),
#             COLUMN g_c[47],cl_numfor(g_tot_amt2,47,g_azi03),
#             COLUMN g_c[48],cl_numfor(g_tot_qty3,48,g_ccz.ccz27),
#             COLUMN g_c[49],cl_numfor(g_tot_amt3,49,g_azi03),
#             COLUMN g_c[50],cl_numfor(g_tot_qty4,50,g_ccz.ccz27),
#             COLUMN g_c[51],cl_numfor(g_tot_amt4,51,g_azi03),
#             COLUMN g_c[53],cl_numfor(g_tot_slow,53,g_azi03)
##No.FUN-580014-end
#      PRINT
#      PRINT
#      PRINT g_x[23] CLIPPED
#      IF tm.c = '1' THEN
#         PRINT COLUMN 8,g_x[24] CLIPPED,' ',g_x[37] CLIPPED
#      ELSE
#         PRINT COLUMN 8,g_x[24] CLIPPED,' ',g_x[38] CLIPPED
#      END IF
#      IF tm.d = '1' THEN
#         PRINT COLUMN 8,g_x[25] CLIPPED,' ',g_x[39] CLIPPED
#      ELSE
#         PRINT COLUMN 8,g_x[25] CLIPPED,' ',g_x[40] CLIPPED
#      END IF
#      PRINT COLUMN 12,g_x[26] CLIPPED,' ',tm.i02,'  %'   #MOD-6C0043 add
#      PRINT COLUMN 12,g_x[27] CLIPPED,' ',tm.i12,'  %'   #MOD-6C0043 g_x[26]->g_x[27]
#      PRINT COLUMN 12,g_x[28] CLIPPED,' ',tm.i22,'  %'   #MOD-6C0043 g_x[27]->g_x[28]
#      PRINT COLUMN 12,g_x[29] CLIPPED,' ',tm.i32,'  %'   #MOD-6C0043 g_x[29]->g_x[29]
#      PRINT COLUMN 12,g_x[56] CLIPPED,' ',tm.i42,'  %'   #MOD-6C0043 g_x[29]->g_x[56]
#      PRINT COLUMN 20,g_x[30] CLIPPED,' ',tm.k1,'  %'
#      PRINT COLUMN 20,g_x[31] CLIPPED,' ',tm.k2,'  %'
#      PRINT COLUMN 20,g_x[32] CLIPPED,' ',tm.k3,'  %'
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
# 
#END REPORT
#FUN-C30190-------mark----end----
#Patch....NO.TQC-610037 <> #
