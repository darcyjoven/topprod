# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axcr630.4gl
# Descriptions...: WIP貨齡分析表
# Input parameter: 
# Return code....: 
# Date & Author..: 99/03/29 By plum
# Modify.........: No.MOD-530181 05/03/23 By kim Define金額單價位數改為DEC(20,6)
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大 
# Modify.........: No.MOD-590022 05/09/07 by yoyo報表修改 
# Modify.........: NO.TQC-5A0038 05/10/14 By Rosayu 1. 列印後出現 A report output file cannot be opened.
# Modify.........: No.FUN-670098 06/07/24 By rainy 排除不納入成本計算倉庫
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換 
# Modify.........: No.FUN-690125 06/10/16 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0064 06/11/14 By Carrier 長度為CHAR(21)的azp03定義改為type_file.chr21
# Modify.........: No.CHI-690007 06/12/27 By kim GP3.5 成本報表數量印出小數位數(ccz27)的處理
# Modify.........: No.MOD-770070 07/07/18 By Carol 將azi05,azi04取位改為使用azi03
# Mofify.........: No.FUN-7C0101 08/01/25 By lala
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.MOD-8C0017 08/12/02 By wujie 報表格式不對，有部分內容被覆蓋
# Modify.........: No.MOD-940154 09/05/20 By Pengu 列印確定後會先出現錯誤訊息lib-301
# Modify.........: No.MOD-950016 09/05/20 By Pengu 以excel匯出時，欄位名稱與資料不對齊
# Modify.........: NO.FUN-970102 09/08/12 By jan 計價基准日 重新賦初
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-C30040 12/03/12 By Elise 報表輸出至Crystal Reports功能
# Modify.........: No.MOD-C40043 12/04/06 By ck2yuan 針對金額及數量作取位
# Modify.........: No.MOD-C40196 12/05/08 By ck2yuan 工單首發日排除非成本倉的話，會造成末存批量與明細總和不相等( DL+OH+SUB)
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26
# Modify.........: No:MOD-CA0022 12/10/12 By Elise 修改CR報表依畫面顯示天數方式

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                             # Print condition RECORD
              wc            STRING,              # Where Condition #TQC-630166
              type          LIKE type_file.chr1,           #No.FUN-7C0101 VARCHAR(1)
              bdate         LIKE type_file.dat,            #No.FUN-680122DATE                # 比較基準日
              i10           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數起始天數
              i11           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數截止天數
              i20           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數起始天數
              i21           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數截止天數
              i30           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數起始天數
              i31           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數截止天數
              i40           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數起始天數
              i41           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數截止天數
              i50           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數起始天數
              i51           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數截止天數
              i60           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數起始天數
              i61           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數截止天數
              i70           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數起始天數
              i71           LIKE type_file.num10,          #No.FUN-680122INTEGER             # 呆滯天數截止天數
              a             LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01)            # 資料排序 1.work order 2.item
              more          LIKE type_file.chr1            # Prog. Version..: '5.30.06-13.03.12(01)             # 特殊列印條件
              END RECORD,
          g_cmz01           LIKE cmz_file.cmz01,
          g_cmz   RECORD LIKE cmz_file.*,
          p_len   LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_name            LIKE type_file.chr20,          #No.FUN-680122CHAR(20)            # External(Disk) file name
          l_name1           LIKE type_file.chr20,          #No.MOD-8C0017
          m_dash            LIKE type_file.chr1000,        #No.FUN-680122CHAR(400)
          m_dash1           LIKE type_file.chr1000         #No.FUN-680122CHAR(400)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
#FUN-C30040--str-- 
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE l_str      STRING
#FUN-C30040--end--
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

   #FUN-C30040--str---
    LET g_sql ="order1.type_file.chr20,",
               "order2.type_file.chr20,",
               "ccg01.ccg_file.ccg01,",
               "ccg04.ccg_file.ccg04,",
               "ccg07.ccg_file.ccg07,",

               "ccg91.ccg_file.ccg91,",
               "ccg92.ccg_file.ccg92,",
               "sfb08.sfb_file.sfb08,",
               "fdate.type_file.dat,",
               "qty1.sfb_file.sfb08,",

               "amt30.ccg_file.ccg92,",
               "amt60.ccg_file.ccg92,",
               "amt90.ccg_file.ccg92,",
               "amt120.ccg_file.ccg92,",
               "amt150.ccg_file.ccg92,",

               "amt180.ccg_file.ccg92,",
               "amt181.ccg_file.ccg92,",
               "bdate.type_file.dat,",
               "g_azi03.azi_file.azi03,",   #MOD-C40043 add
               "g_ccz27.ccz_file.ccz27"     #MOD-C40043 add

    LET l_table = cl_prt_temptable('axcr6301',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF

    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                "      VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"      #MOD-C40043 add ,?,?
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
        CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
    END IF
#FUN-C30040--end--- 
 
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
   LET tm.i20    = ARG_VAL(11)
   LET tm.i21   = ARG_VAL(12)
   LET tm.i30   = ARG_VAL(13)
   LET tm.i31   = ARG_VAL(14)
   LET tm.i40   = ARG_VAL(15)
   LET tm.i41   = ARG_VAL(16)
   LET tm.i50   = ARG_VAL(17)
   LET tm.i51   = ARG_VAL(18)
   LET tm.i60   = ARG_VAL(19)
   LET tm.i61   = ARG_VAL(20)
   LET tm.i70   = ARG_VAL(21)
   LET tm.i71   = ARG_VAL(22)
   LET tm.a     = ARG_VAL(23)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   #No.FUN-570264 ---end---
   LET tm.type = ARG_VAL(27)                 #FUN-7C0101
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off 
      THEN CALL r630_tm(0,0)                    # Input print condition
      ELSE CALL r630()             
   END IF
   DROP TABLE axcr630_temp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
END MAIN
 
FUNCTION r630_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_flag    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_count LIKE type_file.num5,           #No.FUN-680122SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680122CHAR(400)
   DEFINE l_correct   LIKE type_file.chr1    #FUN-970102
   DEFINE l_date      LIKE type_file.dat     #FUN-970102
   DEFINE l_yy,l_mm   LIKE type_file.num5    #FUN-970102
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 8 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 8
   END IF
   OPEN WINDOW r630_w AT p_row,p_col
        WITH FORM "axc/42f/axcr630" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   SELECT cmz01 INTO g_cmz01 FROM cmz_file
  #FUN-970102--begin--mod--
  #IF NOT cl_null(g_cmz01) THEN 
  #   LET tm.bdate=g_cmz01 
  #ELSE 
  #   LET tm.bdate   = g_today
  #END IF
   LET l_yy = YEAR(g_today)   #FUN-970102
   LET l_mm = MONTH(g_today)  #FUN-970102
   CALL s_azm(l_yy,l_mm) RETURNING l_correct, l_date, tm.bdate
  #FUN-970102--end--mod--
   LET tm.a      = '1'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'   
   LET g_copies  = '1'
   LET tm.type   = g_ccz.ccz28   #No.FUN-7C0101 
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
 # IF tm.wc =  " 1=1" THEN
 #    CALL cl_err('','9046',0)
 #    CONTINUE WHILE
 #  END IF
      
   LET tm.i10=0   LET tm.i11=30
   LET tm.i20=31  LET tm.i21=60
   LET tm.i30=61  LET tm.i31=90
   LET tm.i40=91  LET tm.i41=120
   LET tm.i50=121 LET tm.i51=150
   LET tm.i60=151 LET tm.i61=180
   LET tm.i70=181 LET tm.i71=9999
   DISPLAY BY NAME
         tm.bdate,tm.i10,tm.i11,tm.i20,tm.i21,tm.i30,tm.i31,tm.i40,tm.i41,
         tm.i50,tm.i51,tm.i60,tm.i61,tm.i70,tm.i71,tm.a,tm.more
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM 
   END IF
 
   INPUT tm.i10,tm.i11,tm.i20,tm.i21,tm.i30,tm.i31,tm.i40,tm.i41,  
         tm.i50,tm.i51,tm.i60,tm.i61,tm.i70,tm.i71,tm.a,tm.type,tm.bdate,tm.more  #No.FUN-7C0101 add tm.type
         WITHOUT DEFAULTS FROM
         i10,i11,i20,i21,i30,i31,i40,i41,i50,i51,i60,i61,i70,i71,   #No.FUN-7C0101 add type
         a,type,bdate,more 
 
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
      
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN NEXT FIELD bdate END IF
 
      AFTER FIELD i10    #起始呆滯天數
         IF tm.i10 IS NULL THEN NEXT FIELD i10 END IF
 
      AFTER FIELD i11    #截止呆滯天數
         IF NOT cl_null(tm.i11)  AND cl_null(tm.i11) THEN
            NEXT FIELD i11
         END IF
         IF tm.i11 < tm.i10 THEN NEXT FIELD i11 END IF
 
      AFTER FIELD i20    #起始呆滯天數
         IF tm.i20 IS NULL THEN NEXT FIELD i20 END IF
 
      AFTER FIELD i21    #截止呆滯天數
         IF NOT cl_null(tm.i21)  AND cl_null(tm.i21) THEN
            NEXT FIELD i21
         END IF
         IF tm.i21 < tm.i20 THEN NEXT FIELD i21 END IF
 
      AFTER FIELD i30    #起始呆滯天數
         IF tm.i30 IS NULL THEN NEXT FIELD i30 END IF
 
      AFTER FIELD i31    #截止呆滯天數
         IF NOT cl_null(tm.i31)  AND cl_null(tm.i31) THEN
            NEXT FIELD i31
         END IF
         IF tm.i31 < tm.i30 THEN NEXT FIELD i31 END IF
 
      AFTER FIELD i40    #起始呆滯天數
         IF tm.i40 IS NULL THEN NEXT FIELD i40 END IF
 
      AFTER FIELD i41    #截止呆滯天數
         IF NOT cl_null(tm.i41)  AND cl_null(tm.i41) THEN
            NEXT FIELD i41
         END IF
         IF tm.i41 < tm.i40 THEN NEXT FIELD i41 END IF
 
      AFTER FIELD i50    #起始呆滯天數
         IF tm.i50 IS NULL THEN NEXT FIELD i50 END IF
 
      AFTER FIELD i51    #截止呆滯天數
         IF NOT cl_null(tm.i51)  AND cl_null(tm.i51) THEN
            NEXT FIELD i51
         END IF
          IF tm.i51 < tm.i50 THEN NEXT FIELD i51 END IF
 
      AFTER FIELD i60    #起始呆滯天數
         IF tm.i60 IS NULL THEN NEXT FIELD i60 END IF
 
      AFTER FIELD i61    #截止呆滯天數
         IF NOT cl_null(tm.i61)  AND cl_null(tm.i61) THEN
            NEXT FIELD i61
         END IF
         IF tm.i61 < tm.i60 THEN NEXT FIELD i61 END IF
 
      AFTER FIELD i70    #起始呆滯天數
         IF tm.i70 IS NULL THEN NEXT FIELD i70 END IF
 
      AFTER FIELD i71    #截止呆滯天數
         IF NOT cl_null(tm.i71)  AND cl_null(tm.i71) THEN
            NEXT FIELD i71
         END IF
         IF tm.i71 < tm.i70 THEN NEXT FIELD i71 END IF
 
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
      LET INT_FLAG = 0 CLOSE WINDOW r630_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr630'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr630','9031',1)   
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
                         " '",tm.type CLIPPED,"'",   #No.FUN-7C0101 add
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.i10 CLIPPED,"'",
                         " '",tm.i11 CLIPPED,"'",
                         " '",tm.i20 CLIPPED,"'",
                         " '",tm.i21 CLIPPED,"'",
                         " '",tm.i30 CLIPPED,"'",
                         " '",tm.i31 CLIPPED,"'",
                         " '",tm.i40 CLIPPED,"'",
                         " '",tm.i41 CLIPPED,"'",
                         " '",tm.i50 CLIPPED,"'",
                         " '",tm.i51 CLIPPED,"'",
                         " '",tm.i60 CLIPPED,"'",
                         " '",tm.i61 CLIPPED,"'",
                         " '",tm.i70 CLIPPED,"'",
                         " '",tm.i71 CLIPPED,"'",
                         " '",tm.a   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
          CALL cl_cmdat('axcr630',g_time,l_cmd)  # Execute cmd at later time 
      END IF
      CLOSE WINDOW r630_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690125 BY dxfwo 
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r630()
   ERROR ""
END WHILE
CLOSE WINDOW r630_w
END FUNCTION
 
FUNCTION r630()
   DEFINE 
#       l_time          LIKE type_file.chr8         #No.FUN-6A0146
          l_sql      LIKE type_file.chr1000,        # RDSQL STATEMENT        #No.FUN-680122CHAR(600)
          l_za05     LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_date     LIKE type_file.dat,           #No.FUN-680122DATE
          l_delay    LIKE type_file.num5,          #No.FUN-680122SMALLINT
          l_sfm      RECORD LIKE sfm_file.*,
          l_tlf10            LIKE tlf_file.tlf10,    #已入庫量
          sr         RECORD
                     order1  LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
                     order2  LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
                     ccg01   LIKE ccg_file.ccg01,    #工單
                     ccg04   LIKE ccg_file.ccg04,    #料號
                     ccg07   LIKE ccg_file.ccg07,    #No.FUN-7C0101
                     sfb08   LIKE sfb_file.sfb08,    #開工批量:sfb08
                     fdate   LIKE type_file.dat,           #No.FUN-680122 DATE                  #開工日期:min(tlf06)
                     qty1    LIKE sfb_file.sfb08,    #末存批量=sfb08-sum(tfl10)
                     ccg91   LIKE ccg_file.ccg91,    #結存數量
                     ccg92   LIKE ccg_file.ccg92,    #末存金額:sum(tlf10)
                     amt30   LIKE ccg_file.ccg92,    #30天
                     amt60   LIKE ccg_file.ccg92,    #60天
                     amt90   LIKE ccg_file.ccg92,    #90天
                     amt120  LIKE ccg_file.ccg92,    #120天
                     amt150  LIKE ccg_file.ccg92,    #150天
                     amt180  LIKE ccg_file.ccg92,    #180天
                     amt181  LIKE ccg_file.ccg92     #>180天
                     END RECORD,
           l_year    LIKE type_file.num10,         #No.FUN-680122INTGER
           l_mon     LIKE type_file.num5,          #No.FUN-680122SMALLINT
           l_ccc91   LIKE ccc_file.ccc91,
           l_ccc92   LIKE ccc_file.ccc92,
           l_azp03   LIKE type_file.chr21,        #No.FUN-680122CHAR(21) #No.TQC-6B0064
           i    LIKE type_file.num5,          #No.FUN-680122 SMALLINT
           l_flag             LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
    DEFINE l_cmd         LIKE type_file.chr1000      #No.MOD-8C0017   

   #FUN-C30040---add--str---
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   #FUN-C30040---add---end--- 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #LET g_len=226                      #MOD-590022  #No.MOD-940154 mark
#NO.CHI-6A0004 --START
#    SELECT azi03,azi04,azi05 INTO g_azi03,g_azi04,g_azi05
#      FROM azi_file WHERE azi01 = g_aza.aza17
#NO.CHI-6A0004 --END
    #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcr630'  #FUN-C30040 mark
 #No.FUN-550025 --start--
   #  IF g_len = 0 OR g_len IS NULL THEN LET g_len = 226 END IF  
    #CALL cl_outnam('axcr630') RETURNING l_name   #FUN-C30040 mark
    #LET g_len=232   #No.MOD-940154 mark
 #No.FUN-550025 --end--  
    #FUN-C30040 mark---srt---
    #FOR  g_i = 1 TO g_len LET m_dash1[g_i,g_i] = '=' LET m_dash[g_i,g_i]='-' 
    #END FOR
    #FUN-C30040 mark---end--- 
     # FOR  g_i = 1 TO 80 LET g_dash[g_i,g_i] = '=' END FOR  #No.FUN-550025
    #CALL cl_outnam('axcr630') RETURNING l_name #FUN-C30040 mark
    #LET g_len=232   #No.MOD-940154 mark
     LET l_year=YEAR(tm.bdate)
     LET l_mon =MONTH(tm.bdate)
     LET l_sql="SELECT '','',ccg01,ccg04,ccg07,sfb08,'',0,ccg91,ccg92,0,0,0,0,0,0,0 ",  #FUN-7C0101 add ccg07
               "  FROM ccg_file,sfb_file ",
               " WHERE ccg01 = sfb01 AND ",tm.wc CLIPPED,
               "   AND ccg02 = ",l_year," AND ccg03 = ",l_mon,
               "   AND ccg06 = '",tm.type,"'",                #FUN-7C0101
               "   AND ccg92 <>0 "
 
     PREPARE ccg_pre  FROM l_sql
     DECLARE ccg_c  CURSOR FOR ccg_pre
 
 
     LET l_sql="SELECT MIN(tlf06) FROM tlf_file ",   #工單之首日發料日
               " WHERE tlf62= ?  ",                  #工單
               "   AND tlf13 MATCHES 'asfi5*' ",     #異動命令
              #"   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add #MOD-C40196 mark
               "   AND tlf02='50' "                  #來源為倉庫
     PREPARE tlf_pre1 FROM l_sql
     DECLARE tlf_c1 CURSOR FOR tlf_pre1
 
     LET l_sql="SELECT SUM(tlf10) FROM tlf_file ",   #已入庫量
               " WHERE tlf01  = ?  AND tlf62= ? ",   #料號
               "   AND tlf06 <= '",tm.bdate,"' ",
              #"   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)",  #FUN-670098 add #MOD-C40196 mark
               "   AND (tlf13 = 'asft6201' OR tlf13='asft6101') "
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
 
    #LET p_len=86  #FUN-C30040 mark
#No.MOD-8C0017 --begin            
#NO.FUN-C30040--------------str-----------------
#FUN-C30040 mark---str---                                              
#    CALL cl_outnam('axcr630') RETURNING l_name                                 
#    LET l_name1 = l_name                                                       
#    LET l_name1[11,11]='x'                                                     
#FUN-C30040 mark---end---
#No.MOD-8C0017 --end 
    #START REPORT r630_rep TO l_name   #FUN-C30040 mark
#No.MOD-8C0017 --begin                                                          
    #START REPORT r630_rep1 TO l_name1        #No.MOD-8C0017    #FUN-C30040 mark                 
     #START REPORT r630_rep1 TO 'axcr630.err' #TQC-5A0038 mark                  
#    START REPORT r630_rep1 TO l_name         #TQC-5A0038 add                   
#No.MOD-8C0017 --end  
    #LET g_pageno = 0   #FUN-C30040 mark
     LET l_date=' ' LET l_tlf10=0
     FOREACH ccg_c  INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach ccg:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       IF  cl_null(sr.sfb08) THEN LET sr.sfb08=0 END IF
       IF  cl_null(sr.ccg91) THEN LET sr.ccg91=0 END IF
       IF  cl_null(sr.ccg92) THEN LET sr.ccg92=0 END IF
       LET l_date=' ' LET l_tlf10=0
      #開工日期: 取工單之首日發料日
       OPEN tlf_c1 USING sr.ccg01
       FETCH tlf_c1 INTO l_date
       IF cl_null(l_date) THEN LET l_date=' ' END IF
       LET sr.fdate=l_date
      #末存批量=開工批量(sfb08) - 已入庫量(sum(tlf10))
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
           IF SQLCA.SQLCODE =0  #No.7926
               AND l_sfm.sfm06 IS NOT NULL THEN
              LET sr.sfb08=l_sfm.sfm06
           END IF
       END IF
       LET sr.qty1=sr.sfb08 - l_tlf10
      #呆滯天數=基準日(tm.bdate) - 工單首日發料日(fdate)
       LET l_delay=tm.bdate - sr.fdate
       CASE     
            WHEN l_delay >= tm.i10 AND l_delay <= tm.i11
                 LET sr.amt30  = sr.ccg92
            WHEN l_delay >= tm.i20 AND l_delay <= tm.i21
                 LET sr.amt60  = sr.ccg92
            WHEN l_delay >= tm.i30 AND l_delay <= tm.i31
                 LET sr.amt90  = sr.ccg92
            WHEN l_delay >= tm.i40 AND l_delay <= tm.i41
                 LET sr.amt120 = sr.ccg92
            WHEN l_delay >= tm.i50 AND l_delay <= tm.i51
                 LET sr.amt150 = sr.ccg92
            WHEN l_delay >= tm.i60 AND l_delay <= tm.i61
                 LET sr.amt180 = sr.ccg92
            WHEN l_delay >= tm.i70
                 LET sr.amt181 = sr.ccg92
       END CASE
       IF tm.a ='1' THEN          #工單
           LET sr.order1=sr.ccg01 LET sr.order2=sr.ccg04
       ELSE                       #料號
           LET sr.order1=sr.ccg04 LET sr.order2=sr.ccg01
       END IF
      #FUN-C30040 mark---srt---
      #OUTPUT TO REPORT r630_rep(sr.*)
       #若計算之末存批量與結存數量不同時
      #IF cl_null(sr.qty1) THEN LET sr.qty1=0 END IF
      #IF sr.qty1 <> sr.ccg91 THEN
      #   OUTPUT TO REPORT r630_rep1(sr.*)
      #END IF 
      #FUN-C30040 mark---end---

      #MOD-C40043 str add-----
       LET sr.sfb08 = cl_digcut(sr.sfb08,g_ccz.ccz27)
       LET sr.qty1 = cl_digcut(sr.qty1,g_ccz.ccz27)
       LET sr.ccg91 = cl_digcut(sr.ccg91,g_ccz.ccz27)
       LET sr.ccg92 = cl_digcut(sr.ccg92,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
       LET sr.amt30= cl_digcut(sr.amt30,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
       LET sr.amt60= cl_digcut(sr.amt60,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
       LET sr.amt90= cl_digcut(sr.amt90,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
       LET sr.amt120= cl_digcut(sr.amt120,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
       LET sr.amt150= cl_digcut(sr.amt150,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
       LET sr.amt180= cl_digcut(sr.amt180,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
       LET sr.amt181= cl_digcut(sr.amt181,g_ccz.ccz26) #CHI-C30012 g_azi03->g_ccz.ccz26
      #MOD-C40043 end add-----

      #FUN-C30040 add---srt---
        EXECUTE insert_prep USING sr.order1,sr.order2,sr.ccg01,sr.ccg04,sr.ccg07,
                                  sr.ccg91,sr.ccg92,sr.sfb08,sr.fdate,sr.qty1,
                                  sr.amt30,sr.amt60,sr.amt90,sr.amt120,sr.amt150,
                                  #sr.amt180,sr.amt181,tm.bdate,g_azi03,g_ccz.ccz27   #MOD-C40043 add ,g_azi03,g_ccz.ccz27 #CHI-C30012
                                  sr.amt180,sr.amt181,tm.bdate,g_ccz.ccz26,g_ccz.ccz27 #CHI-C30012
      #FUN-C30040 add---end---
     END FOREACH

    #FUN-C30040 mark---srt---
    #FINISH REPORT r630_rep
    #FINISH REPORT r630_rep1
    #FUN-C30040 mark---end---
 
#No.MOD-8C0017 --begin                                                          
#    LET l_cmd="chmod 777 ", l_name1                     #No.FUN-9C0009                        
#    RUN l_cmd                                           #No.FUN-9C0009                       
    #FUN-C30040 mark---srt---
    #IF os.Path.chrwx(l_name1 CLIPPED,511) THEN END IF   #No.FUN-9C0009
    #LET l_sql='cat ',l_name1,'>> ',l_name                                      
    #RUN l_sql                                                                  
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                
    #FUN-C30040 mark---end---
#No.MOD-8C0017 --end 

   #FUN-C30040 add---srt---
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 ='Y' THEN
       CALL cl_wcchp(tm.wc,'ccg01,type,bdate')
       RETURNING tm.wc
    END IF
    LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED,";",
                tm.i11 CLIPPED,";",tm.i21 CLIPPED,";",tm.i31 CLIPPED,";",   #MOD-CA0022 add
                tm.i41 CLIPPED,";",tm.i51 CLIPPED,";",tm.i61 CLIPPED        #MOD-CA0022 add
       
    CALL cl_prt_cs3('axcr630','axcr630',g_sql,l_str)
   #FUN-C30040 add---end---
#NO.FUN-C30040--------------end-----------------
END FUNCTION

#FUN-C30040---mark---str--- 
#REPORT r630_rep(sr)
#  DEFINE l_last_sw  LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
#         sr         RECORD
#                    order1  LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
#                    order2  LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
#                    ccg01   LIKE ccg_file.ccg01,    #工單
#                    ccg04   LIKE ccg_file.ccg04,    #料號
#                    ccg07   LIKE ccg_file.ccg07,    #No.FUN-7C0101 VARCHAR(40)
#                    sfb08   LIKE sfb_file.sfb08,    #開工批量:sfb08
#                    fdate   LIKE type_file.dat,           #No.FUN-680122DATE                   #開工日期:min(tlf06)
#                    qty1    LIKE sfb_file.sfb08,    #末存批量=sfb08-sum(tfl10)
#                    ccg91   LIKE ccg_file.ccg91,    #結存數量
#                    ccg92   LIKE ccg_file.ccg92,    #末存金額:sum(tlf10)
#                    amt30   LIKE ccg_file.ccg92,    #30天
#                    amt60   LIKE ccg_file.ccg92,    #60天
#                    amt90   LIKE ccg_file.ccg92,    #90天
#                    amt120  LIKE ccg_file.ccg92,    #120天
#                    amt150  LIKE ccg_file.ccg92,    #150天
#                    amt180  LIKE ccg_file.ccg92,    #180天
#                    amt181  LIKE ccg_file.ccg92     #>180天
#                    END RECORD,
#         l_day      LIKE type_file.num10,         #No.FUN-680122INTGER
#         samt1,samt30,samt60,samt90         LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
#         samt120,samt150,samt180,samt181    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
#       #  sqty1                              LIKE ima_file.ima26           #No.FUN-680122DEC(15,3)#FUN-A20044
#         sqty1                              LIKE type_file.num15_3           #No.FUN-680122DEC(15,3)#FUN-A20044
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#
#ORDER BY sr.order1,sr.order2
#
#  FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#           COLUMN 56,g_x[10] CLIPPED, tm.bdate,
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT m_dash1[1,g_len]
##  No.FUN-550025 --start--
#     PRINT COLUMN  01,g_x[11] CLIPPED,
#           COLUMN  20,g_x[17] CLIPPED,
#           COLUMN  61,g_x[18] CLIPPED,
#           COLUMN  80,g_x[12] CLIPPED,
#           COLUMN  123,g_x[13] CLIPPED,    #No.MOD-950016 modify
#           COLUMN 141,tm.i11 USING '##&',' ',g_x[14] CLIPPED,
#           COLUMN 160,tm.i21 USING '##&',' ',g_x[14] CLIPPED,
#           COLUMN 179,tm.i31 USING '##&',' ',g_x[14] CLIPPED,
#           COLUMN 198,tm.i41 USING '##&',' ',g_x[14] CLIPPED,
#           COLUMN 217,tm.i51 USING '##&',' ',g_x[14] CLIPPED,
#           COLUMN 236,tm.i61 USING '##&',' ',g_x[14] CLIPPED,
#           COLUMN 255,'>',tm.i61 USING '##&',' ',g_x[14] CLIPPED
#    #-------------No.MOD-950016 modify
#    #PRINT '---------------- -------------------- --------------- --------- --------------- ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------- ------------------ -------------------'   #No.MOD-940154 modify
#     PRINT '------------------ ---------------------------------------- ------------------ --------------- ---------- --------------- ----------------- ------------------ ------------------ ------------------ ------------------ ------------------ ------------------ ------------------'
#    #-------------No.MOD-950016 end
##  No.FUN-550025 --end--  
#     LET l_last_sw = 'n'
#
#   ON EVERY ROW
##  No.FUN-550025 --start--
#    #---------------No.MOD-950016 modify
#    #PRINT COLUMN 01,sr.ccg01 CLIPPED,
#    #      COLUMN 18,sr.ccg04 CLIPPED,
#    #      COLUMN 59,sr.ccg07 CLIPPED,       #No.FUN-7C0101 add
#    #      COLUMN 80,cl_numfor(sr.sfb08,14,g_ccz.ccz27) CLIPPED, #CHI-690007
#    #      COLUMN 96,sr.fdate CLIPPED,
#    #   #  COLUMN  60,cl_numfor(sr.qty1  ,10,g_azi05) clipped,
#MOD-#70070-modify azi05->azi03
#    #      COLUMN 104,cl_numfor(sr.ccg91 ,14,g_ccz.ccz27) clipped, #CHI-690007
#    #      COLUMN 122,cl_numfor(sr.ccg92 ,17,g_azi03) clipped,
#    #      COLUMN 141,cl_numfor(sr.amt30 ,17,g_azi03) clipped,
#    #      COLUMN 160,cl_numfor(sr.amt60 ,17,g_azi03) clipped,
#    #      COLUMN 179,cl_numfor(sr.amt90 ,17,g_azi03) clipped,
#    #      COLUMN 198,cl_numfor(sr.amt120,17,g_azi03) clipped,
#    #      COLUMN 217,cl_numfor(sr.amt150,17,g_azi03) clipped,
#    #      COLUMN 236,cl_numfor(sr.amt180,17,g_azi03) clipped,
#    #      COLUMN 255,cl_numfor(sr.amt181,18,g_azi03) clipped
#MOD-770070-modify-end
#     PRINT COLUMN 01,sr.ccg01 CLIPPED,
#           COLUMN 20,sr.ccg04 CLIPPED,
#           COLUMN 61,sr.ccg07 CLIPPED,       
#           COLUMN 80,cl_numfor(sr.sfb08,14,g_ccz.ccz27) CLIPPED, 
#           COLUMN 96,sr.fdate CLIPPED,
#           COLUMN 107,cl_numfor(sr.ccg91 ,14,g_ccz.ccz27) clipped, 
#           COLUMN 123,cl_numfor(sr.ccg92 ,16,g_azi03) clipped,
#           COLUMN 141,cl_numfor(sr.amt30 ,17,g_azi03) clipped,
#           COLUMN 160,cl_numfor(sr.amt60 ,17,g_azi03) clipped,
#           COLUMN 179,cl_numfor(sr.amt90 ,17,g_azi03) clipped,
#           COLUMN 198,cl_numfor(sr.amt120,17,g_azi03) clipped,
#           COLUMN 217,cl_numfor(sr.amt150,17,g_azi03) clipped,
#           COLUMN 236,cl_numfor(sr.amt180,17,g_azi03) clipped,
#           COLUMN 255,cl_numfor(sr.amt181,17,g_azi03) clipped
#    #---------------No.MOD-950016 end
##  No.FUN-550025 --end--  
#
#   ON LAST ROW
#     PRINT  m_dash[1,g_len]
#   # LET sqty1 =SUM(sr.qty1)           LET samt1 =SUM(sr.ccg92)
#     LET sqty1 =SUM(sr.ccg91)          LET samt1 =SUM(sr.ccg92)
#     LET samt30=SUM(sr.amt30)          LET samt60=SUM(sr.amt60)
#     LET samt90=SUM(sr.amt90)          LET samt120=SUM(sr.amt120)
#     LET samt150=SUM(sr.amt150)        LET samt180=SUM(sr.amt180)
#     LET samt181=SUM(sr.amt181)
#     IF cl_null(samt1)   THEN LET samt1  =0 END IF
#     IF cl_null(sqty1)   THEN LET sqty1  =0 END IF
#     IF cl_null(samt30)  THEN LET samt30 =0 END IF
#     IF cl_null(samt60)  THEN LET samt60 =0 END IF
#     IF cl_null(samt90)  THEN LET samt90 =0 END IF
#     IF cl_null(samt120) THEN LET samt120=0 END IF
#     IF cl_null(samt150) THEN LET samt150=0 END IF
#     IF cl_null(samt180) THEN LET samt180=0 END IF
#     IF cl_null(samt181) THEN LET samt181=0 END IF
#MOD.590022--start
#     PRINT COLUMN 12,g_x[15] CLIPPED,
#          #-------------No.MOD-950016 modify
#          #COLUMN 106,cl_numfor(sqty1  ,14,g_ccz.ccz27), #CHI-690007
#MOD-770070-modify azi05->azi03
#          #COLUMN 122,cl_numfor(samt1  ,17,g_azi03) clipped,
#           COLUMN 107,cl_numfor(sqty1  ,14,g_ccz.ccz27), #CHI-690007
#           COLUMN 123,cl_numfor(samt1  ,16,g_azi03) clipped,
#          #-------------No.MOD-950016 end
#           COLUMN 141,cl_numfor(samt30 ,17,g_azi03) clipped,
#           COLUMN 160,cl_numfor(samt60 ,17,g_azi03) clipped,
#           COLUMN 179,cl_numfor(samt90 ,17,g_azi03) clipped,
#           COLUMN 198,cl_numfor(samt120,17,g_azi03) clipped,
#           COLUMN 217,cl_numfor(samt150,17,g_azi03) clipped,
#           COLUMN 236,cl_numfor(samt180,17,g_azi03) clipped,
#           COLUMN 255,cl_numfor(samt181,18,g_azi03) clipped
#MOD-770070-modify-end
#MOD.590022--end
#     IF g_zz05 = 'Y'          # (80)-70,140,210,280   /   (132)-120,240,300
#        THEN PRINT m_dash1[1,g_len]
#             #TQC-630166 Start
#             #IF tm.wc[001,120] > ' ' THEN                      # for 132
#             #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#             #IF tm.wc[121,240] > ' ' THEN
#             #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#             #IF tm.wc[241,300] > ' ' THEN
#             #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#
#             CALL cl_prt_pos_wc(tm.wc)
#             #TQC-630166 End
#
#     END IF
#     PRINT m_dash1[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     LET l_last_sw = 'y'
#
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT m_dash1[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#
#末存批量與結存數量不同時
#REPORT r630_rep1(sr)
#  DEFINE l_last_sw   LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
#         sr         RECORD
#                    order1  LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
#                    order2  LIKE type_file.chr20,          #No.FUN-680122CHAR(20)
#                    ccg01   LIKE ccg_file.ccg01,    #工單
#                    ccg04   LIKE ccg_file.ccg04,    #料號
#                    ccg07   LIKE ccg_file.ccg07,    #No.FUN-7C0101 VARCHAR(40)
#                    sfb08   LIKE sfb_file.sfb08,    #開工批量:sfb08
#                    fdate   LIKE type_file.dat,            #No.FUN-680122DATE                   #開工日期:min(tlf06)
#                    qty1    LIKE sfb_file.sfb08,    #末存批量=sfb08-sum(tfl10)
#                    ccg91   LIKE ccg_file.ccg91,    #結存數量
#                    ccg92   LIKE ccg_file.ccg92,    #末存金額:sum(tlf10)
#                    amt30   LIKE ccg_file.ccg92,    #30天
#                    amt60   LIKE ccg_file.ccg92,    #60天
#                    amt90   LIKE ccg_file.ccg92,    #90天
#                    amt120  LIKE ccg_file.ccg92,    #120天
#                    amt150  LIKE ccg_file.ccg92,    #150天
#                    amt180  LIKE ccg_file.ccg92,    #180天
#                    amt181  LIKE ccg_file.ccg92     #>180天
#                    END RECORD,
#         l_day      LIKE type_file.num10,          #No.FUN-680122INTEGER
#         samt1,samt30,samt60,samt90         LIKE type_file.num20_6,        #No.FUN-680122 DECIMAL(20,6)
#         samt120,samt150,samt180,samt181    LIKE type_file.num20_6,       #No.FUN-680122 DECIMAL(20,6)
#       #  sqty1                              LIKE ima_file.ima26           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
#         sqty1                              LIKE type_file.num15_3           #No.FUN-680122DECIMAL(15,3)#FUN-A20044
#
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#
#ORDER BY sr.order1,sr.order2
#
#  FORMAT
#  PAGE HEADER
#     PRINT (p_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#     IF g_towhom IS NULL OR g_towhom = ' '
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (p_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (p_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#     PRINT ' '
#     LET g_pageno = g_pageno + 1
#     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
#           COLUMN 56,g_x[10] CLIPPED, tm.bdate,
#           COLUMN p_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,80]
#     PRINT COLUMN  01,g_x[11] CLIPPED,COLUMN 37,g_x[12] CLIPPED,
#           COLUMN 74,g_x[16]
#     PRINT '---------------- -------------------- ----------- -------- ----------- ',
#           '---------------'
#     LET l_last_sw = 'n'
#
#   ON EVERY ROW
##  No.FUN-550025 --start--
#     PRINT COLUMN  01,sr.ccg01,
#           COLUMN  18,sr.ccg04,
#           COLUMN  59,sr.ccg07,   #No.FUN-7C0101 add
#           COLUMN  80,cl_numfor(sr.sfb08,10,g_ccz.ccz27), #CHI-690007  USING '-------&.##',
#           COLUMN  96,sr.fdate,
#           COLUMN  101,cl_numfor(sr.qty1  ,10,g_ccz.ccz27) clipped, #CHI-690007
#           COLUMN  113,cl_numfor(sr.ccg91  ,14,g_ccz.ccz27) clipped  #CHI-690007
##  No.FUN-550025 --end--  
#
#   ON LAST ROW
#     PRINT g_dash[1,p_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (p_len-9), g_x[7] CLIPPED
#     LET l_last_sw = 'y'
#
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,p_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (p_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#FUN-C30040---mark---end--- 
