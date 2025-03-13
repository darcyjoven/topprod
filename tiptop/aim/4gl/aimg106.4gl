# Prog. Version..: '5.30.06-13.04.08(00002)'     #
#
# Pattern name...: aimg106.4gl
# Descriptions...: 庫存數量表列印
# Date & Author..: 2002/07/22 By Mandy
# Modify.........: No:9314 By Melody 1.資料是錯誤的 ,以前期的期末當初始值 ,但是tlf_file 又是抓上期的
#                                    2.sr.imk09 未塞值 ,所以算出來也有問題
# Modify.........: No.MOD-4C0105 04/12/16 By Mandy imk 有同月份資料時，會抓到當月底而不會抓到前月底
# Modify.........: No.MOD-510083 05/01/12 By ching 邏輯錯誤處理
# Modify.........: No.FUN-510017 05/02/17 By Mandy 報表轉XML
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/25 By vivien 料件編號欄位增加controlp
# Modify.........: No.MOD-580027 05/12/15 By Pengu 1.應該抓取本期異動資料而不是前期異動資料
                                          #        2.異動數量img10應乘上單位轉換率
# Modify.........: No.MOD-620087 06/03/01 By Claire 發料單位與庫存單位不同的料號會有問題
# Modify.........: No.TQC-610072 06/03/07 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/08 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.MOD-710183 07/02/08 By pengu 調整庫存數量的計算邏輯
# Modify.........: No.FUN-770006 07/08/03 By zhoufeng 報表產出改為Crystal Report
# Modify.........: No.MOD-8C0015 08/12/02 By clover l_sql VARCHAR(1000)不夠,改為String
# Modify.........: No.MOD-970290 09/08/03 By sherry 計算tlf中的數量的時候，沒有乘上tlf60（與庫存單位的轉換率）
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A40108 10/04/20 By Sarah 目前g_yy與g_mm是抓出e_date的年月,應改成抓出年期
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:MOD-B40005 11/04/01 By sabrina 在計算異動單據數量時已轉換成庫存單位。不需再乘轉換率
# Modify.........: No:FUN-C70024 12/07/05 By xjll 提供列印款號料件或明細料件的庫存數量
# Modify.........: No:FUN-CB0055 12/11/14 By xjll 清楚aimg106的子報表2Detail01中欄位使用的定位點
# Modify.........: No:TQC-D40004 13/04/03 By bart aimg106_subrep01、aimg106_subrep02應為aimg106_slk_subrep01、aimg106_slk_subrep02

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              #wc      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
              wc      STRING,                  #MOD-8C0015
              edate   LIKE type_file.dat,     #No.FUN-690026 DATE
              detail  LIKE type_file.chr1,    #FUN-C70024--add
              a       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
              more    LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
              END RECORD,
          i           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          g_yy        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          g_mm        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          last_y      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          last_m      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cnt       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          m_bdate     LIKE type_file.dat,     #No.FUN-690026 DATE
          m_edate     LIKE type_file.dat,     #No.FUN-690026 DATE
          l_imk09     LIKE imk_file.imk09,    #No:9314 #MOD-530179
          l_flag      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
DEFINE   g_chr        LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE   g_sql        STRING                  #No.FUN-770006
DEFINE   g_str        STRING                  #No.FUN-770006
DEFINE   l_table      STRING                  #No.FUN-770006
DEFINE   l_table1     STRING                  #FUN-C70024--add
DEFINE   l_table2     STRING                  #FUN-C70024--add
 
###GENGRE###START
TYPE sr1_t RECORD
    img01 LIKE img_file.img01,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    img02 LIKE img_file.img02,
    img03 LIKE img_file.img03,
    img04 LIKE img_file.img04,
    img10 LIKE img_file.img10,
    imk09 LIKE imk_file.imk09,
    ima25 LIKE ima_file.ima25,
    total LIKE img_file.img10    #FUN-C70024--add
END RECORD
###GENGRE###END
#FUN-C70024----add---begin-----------
TYPE sr2_t RECORD
    agd03_1  LIKE agd_file.agd03,
    agd03_2  LIKE agd_file.agd03,
    agd03_3  LIKE agd_file.agd03,
    agd03_4  LIKE agd_file.agd03,
    agd03_5  LIKE agd_file.agd03,
    agd03_6  LIKE agd_file.agd03,
    agd03_7  LIKE agd_file.agd03,
    agd03_8  LIKE agd_file.agd03,
    agd03_9  LIKE agd_file.agd03,
    agd03_10 LIKE agd_file.agd03,
    agd03_11 LIKE agd_file.agd03,
    agd03_12 LIKE agd_file.agd03,
    agd03_13 LIKE agd_file.agd03,
    agd03_14 LIKE agd_file.agd03,
    agd03_15 LIKE agd_file.agd03,
    ima01    LIKE ima_file.ima01    
END RECORD

TYPE sr3_t RECORD     
    imx01    LIKE imx_file.imx01, 
    number1  LIKE type_file.chr5,             
    number2  LIKE type_file.chr5,
    number3  LIKE type_file.chr5,
    number4  LIKE type_file.chr5,
    number5  LIKE type_file.chr5,
    number6  LIKE type_file.chr5,
    number7  LIKE type_file.chr5,
    number8  LIKE type_file.chr5,
    number9  LIKE type_file.chr5,
    number10 LIKE type_file.chr5,
    number11 LIKE type_file.chr5,
    number12 LIKE type_file.chr5,
    number13 LIKE type_file.chr5,
    number14 LIKE type_file.chr5,
    number15 LIKE type_file.chr5,
    img01    LIKE img_file.img01,
    img02    LIKE img_file.img02,
    img03    LIKE img_file.img03,
    img04    LIKE img_file.img04
END RECORD

#FUN-C70024----add---end-------------

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo
   #No.FUN-770006 --start--
   LET g_sql="img01.img_file.img01,ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,img02.img_file.img02,",
             "img03.img_file.img03,img04.img_file.img04,img10.img_file.img10,",
             "imk09.imk_file.imk09,ima25.ima_file.ima25,total.img_file.img10"
 
   LET l_table = cl_prt_temptable('aimg106',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
#FUN-C70024----mark---begin-------------
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   #LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
   #            " VALUES(?,?,?,?,?,?,?,?,?)"
   #PREPARE insert_prep FROM g_sql
   #IF STATUS THEN 
   #   CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   #END IF
#FUN-C70024----mark----end---------------
#FUN-C70024----add---begin------------
   LET g_sql = "agd03_1.agd_file.agd03,",
               "agd03_2.agd_file.agd03,",
               "agd03_3.agd_file.agd03,",
               "agd03_4.agd_file.agd03,",
               "agd03_5.agd_file.agd03,",
               "agd03_6.agd_file.agd03,",
               "agd03_7.agd_file.agd03,",
               "agd03_8.agd_file.agd03,",
               "agd03_9.agd_file.agd03,",
               "agd03_10.agd_file.agd03,",
               "agd03_11.agd_file.agd03,",
               "agd03_12.agd_file.agd03,",
               "agd03_13.agd_file.agd03,",
               "agd03_14.agd_file.agd03,",
               "agd03_15.agd_file.agd03,",
               "ima01.ima_file.ima01"
   LET l_table1 = cl_prt_temptable('aimg1061',g_sql) CLIPPED
   IF l_table1 = -1 THEN EXIT PROGRAM END IF

   LET g_sql="imx01.imx_file.imx01,number1.type_file.num5,",
             "number2.type_file.num5,",
             "number3.type_file.num5,",
             "number4.type_file.num5,",
             "number5.type_file.num5,",
             "number6.type_file.num5,",
             "number7.type_file.num5,",
             "number8.type_file.num5,",
             "number9.type_file.num5,",
             "number10.type_file.num5,number11.type_file.num5,",
             "number12.type_file.num5,number13.type_file.num5,",
             "number14.type_file.num5,number15.type_file.num5,",
             "img01.img_file.img01,img02.img_file.img02,",
             "img03.img_file.img03,img04.img_file.img04"
   LET l_table2 = cl_prt_temptable('aimg1062',g_sql) CLIPPED
   IF l_table2 = -1 THEN
      EXIT PROGRAM
   END IF
   #FUN-C70024----add---end--------------
   #No.FUN-770006 --end--
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.edate = ARG_VAL(8)   #TQC-610072 順序下推 
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL g106_tm(0,0)
   ELSE
       CALL g106()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
END MAIN
 
FUNCTION g106_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01    #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5,   #No.FUN-690026 SMALLINT
       l_cmd          LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 12 END IF
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 18
   ELSE
       LET p_row = 4 LET p_col = 12
   END IF
   OPEN WINDOW g106_w AT p_row,p_col
        WITH FORM "aim/42f/aimg106"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
#FUN-C70024---add--begin---------------  
  IF s_industry("slk") AND g_azw.azw04 = '2' THEN
     CALL cl_set_comp_visible("more",FALSE)  
     CALL cl_set_comp_visible("detail",TRUE)
  ELSE
     CALL cl_set_comp_visible("detail",FALSE)
     CALL cl_set_comp_visible("more",TRUE) 
  END IF
#FUN-C70024---add--end-----------------
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.edate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   IF s_industry('slk') AND g_azw.azw04='2' THEN
      LET tm.detail  = 'Y'   #FUN-C70081---ADD---
   ELSE
      LET tm.detail  = 'N'   #FUN-C70081---ADD---
   END IF
WHILE TRUE
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON ima01,img02,img03,img04
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
            IF INFIELD(ima01) THEN
               CALL cl_init_qry_var()
            #FUN-C70024----add---begin-------------
               IF s_industry("slk") AND g_azw.azw04 = '2' THEN
                  LET g_qryparam.form = "q_ima01_slk"
               ELSE
            #FUN-C70024----add---end---------------
                  LET g_qryparam.form = "q_ima"
               END IF                    #FUN-C70024--add
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            END IF
#No.FUN-570240 --end
 
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
         LET INT_FLAG = 0
         CLOSE WINDOW g106_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
         EXIT PROGRAM
      END IF
      IF tm.wc = " 1=1" THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.wc != ' 1=1' THEN EXIT WHILE END IF
      CALL cl_err('',9046,0)
   END WHILE
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.edate,tm.detail,tm.more WITHOUT DEFAULTS  #FUN-C70024--add
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         DISPLAY tm.detail TO FORMONLY.detail                 #FUN-C70024--add
      #No.FUN-580031 ---end---
 
      AFTER FIELD edate
         IF  cl_null(tm.edate) THEN NEXT FIELD edate END IF
        #LET g_yy = YEAR(tm.edate)                #MOD-A40108 mark
        #LET g_mm = MONTH(tm.edate)               #MOD-A40108 mark
         CALL s_yp(tm.edate) RETURNING g_yy,g_mm  #MOD-A40108

      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF  INT_FLAG THEN EXIT INPUT END IF
         LET l_flag = 'N'
         IF  cl_null(tm.edate) THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.edate
         END IF
         IF  cl_null(tm.more) OR tm.more NOT MATCHES '[YN]' THEN
             LET l_flag = 'Y'
             DISPLAY BY NAME tm.more
         END IF
         IF  l_flag = 'Y' THEN
             CALL cl_err('','9033',0)
             NEXT FIELD edate
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF  INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW g106_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
       CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
       EXIT PROGRAM
   END IF
 
   LET last_y = g_yy LET last_m = g_mm - 1
   IF last_m = 0 THEN LET last_y = last_y - 1 LET last_m = 12 END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='aimg106'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aimg106','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",             #TQC-610072
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('aimg106',g_time,l_cmd)
      END IF
      CLOSE WINDOW g106_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g106()
   ERROR ""
END WHILE
   CLOSE WINDOW g106_w
END FUNCTION
 
FUNCTION g106()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0074
          #l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(1000)
          l_sql     STRING,                 #MOD-8C0015
          l_chr     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_za05    LIKE za_file.za05,      #No.FUN-690026 VARCHAR(40)
          sr        RECORD
                    img01 LIKE img_file.img01,   #--料號
                    img02 LIKE img_file.img02,   #--倉
                    img03 LIKE img_file.img03,   #--儲
                    img04 LIKE img_file.img04,   #--批
                    img10 LIKE img_file.img10,   #--出入庫量
                    ima25 LIKE ima_file.ima25,   #--料件主檔單位
                    imk09 LIKE imk_file.imk09,   #--上期期末庫存
                    tmp01 LIKE imk_file.imk05,   #--上期期末年度  #No.FUN-690026 SMALLINT
                    tmp02 LIKE imk_file.imk06    #--上期期末期別  #No.FUN-690026 SMALLINT
                    END RECORD,
          l_img09       LIKE img_file.img09,     #--來源單位
          l_img2ima_fac LIKE ima_file.ima31_fac  #--轉換率 #MOD-530179
   DEFINE l_ima02   LIKE ima_file.ima02,         #No.FUN-770006
          l_ima021  LIKE ima_file.ima021         #No.FUN-770006 
   DEFINE l_number  LIKE img_file.img10 
#FUN-C70024---add--begin-----------
DEFINE  l_imx   DYNAMIC ARRAY OF RECORD
                imx01    LIKE type_file.chr10                  
                END RECORD

DEFINE  l_num   DYNAMIC ARRAY OF RECORD
                 number  LIKE type_file.num5
                END RECORD

DEFINE l_imx_t  RECORD
       agd03_1  LIKE agd_file.agd03,
       agd03_2  LIKE agd_file.agd03,
       agd03_3  LIKE agd_file.agd03,
       agd03_4  LIKE agd_file.agd03,
       agd03_5  LIKE agd_file.agd03,
       agd03_6  LIKE agd_file.agd03,
       agd03_7  LIKE agd_file.agd03,
       agd03_8  LIKE agd_file.agd03,
       agd03_9  LIKE agd_file.agd03,
       agd03_10 LIKE agd_file.agd03,
       agd03_11 LIKE agd_file.agd03,
       agd03_12 LIKE agd_file.agd03,
       agd03_13 LIKE agd_file.agd03,
       agd03_14 LIKE agd_file.agd03,
       agd03_15 LIKE agd_file.agd03
                END RECORD
DEFINE l_num_t  RECORD
       num_1  LIKE type_file.chr5,
       num_2  LIKE type_file.chr5,
       num_3  LIKE type_file.chr5,
       num_4  LIKE type_file.chr5,
       num_5  LIKE type_file.chr5,
       num_6  LIKE type_file.chr5,
       num_7  LIKE type_file.chr5,
       num_8  LIKE type_file.chr5,
       num_9  LIKE type_file.chr5,
       num_10 LIKE type_file.chr5,
       num_11 LIKE type_file.chr5,
       num_12 LIKE type_file.chr5,
       num_13 LIKE type_file.chr5,
       num_14 LIKE type_file.chr5,
       num_15 LIKE type_file.chr5
                END RECORD
DEFINE l_n           LIKE type_file.num5,
       l_img10       LIKE img_file.img10,
       l_ima25       LIKE ima_file.ima25
DEFINE l_imx02  LIKE imx_file.imx02
DEFINE l_imx01  LIKE imx_file.imx01 
DEFINE l_agd04  LIKE agd_file.agd04
DEFINE l_i      LIKE type_file.num5
DEFINE l_sql2   STRING
DEFINE l_ps     LIKE sma_file.sma46
DEFINE l_ima01  LIKE ima_file.ima01 
DEFINE l_color  LIKE agd_file.agd03
DEFINE l_imk09_1 LIKE imk_file.imk09
DEFINE l_ima151 LIKE ima_file.ima151
DEFINE l_imx00  LIKE imx_file.imx00
DEFINE l_total  LIKE img_file.img10             #FUN-C70024--add

#FUN-C70024--------add---begin------------
 DROP TABLE tmpa_file      
 CREATE TEMP TABLE tmpa_file(
    tmpa01 LIKE img_file.img01,
    tmpa02 LIKE img_file.img02,
    tmpa03 LIKE img_file.img03,
    tmpa04 LIKE img_file.img04,
    tmpa05 LIKE img_file.img10,
    tmpa06 LIKE imk_file.imk09,
    tmpa00 LIKE ima_file.ima01)
#FUN-C70024---add---end------------
 
     CALL cl_del_data(l_table)                   #No.FUN-770006
     CALL cl_del_data(l_table1)                  #FUN-C70024
     CALL cl_del_data(l_table2)                  #FUN-C70024
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                        #只能使用自己的資料
     #        LET tm.wc = tm.wc clipped," AND imauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                         #只能使用相同群的資料
     #        LET tm.wc = tm.wc clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm.wc = tm.wc clipped," AND imagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
     #End:FUN-980030
 
     DROP TABLE aimg106_tmp
     #CREATE TEMP TABLE aimg106_tmp
     #    ( img01 VARCHAR(40),              #--料號    #FUN-560011
     #      img02 VARCHAR(10),              #--倉
     #      img03 VARCHAR(10),              #--儲
     #      img04 VARCHAR(24),              #--批
     #      img10 DEC(15,3),             #--出入庫量
     #      ima25 VARCHAR(04),              #--料件主檔單位
     #      imk09 DEC(15,3),             #--上期期末庫存
     #      tmp01 smallint,              #--上期期末年度
     #      tmp02 smallint)              #--上期期末期別
     CREATE TEMP TABLE aimg106_tmp(
           img01 LIKE img_file.img01,
           img02 LIKE img_file.img02,
           img03 LIKE img_file.img03,
           img04 LIKE img_file.img04,
           img10 LIKE img_file.img10,
           ima25 LIKE ima_file.ima25,
           imk09 LIKE imk_file.imk09,
           tmp01 LIKE imk_file.imk05,
           tmp02 LIKE imk_file.imk06)
     DELETE FROM aimg106_tmp
 
     #No:9314
     DROP TABLE aimg106_tmp2
     #CREATE TEMP TABLE aimg106_tmp2
     #    ( img01 VARCHAR(40),              #--料號    #FUN-560011
     #      img02 VARCHAR(10),              #--倉
     #      img03 VARCHAR(10),              #--儲
     #      img04 VARCHAR(24),              #--批
     #      img10 DEC(15,3),             #--出入庫量
     #      ima25 VARCHAR(04),              #--料件主檔單位
     #      imk09 DEC(15,3),             #--上期期末庫存
     #      tmp01 smallint,              #--上期期末年度
     #      tmp02 smallint)              #--上期期末期別
     CREATE TEMP TABLE aimg106_tmp2(
           img01 LIKE img_file.img01,
           img02 LIKE img_file.img02,
           img03 LIKE img_file.img03,
           img04 LIKE img_file.img04,
           img10 LIKE img_file.img10,
           ima25 LIKE ima_file.ima25,
           imk09 LIKE imk_file.imk09,
           tmp01 LIKE imk_file.imk05,
           tmp02 LIKE imk_file.imk06)
     DELETE FROM aimg106_tmp2
     #No:9314
 
 
#FUN-C70024----add-------------begin-----------------
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
               " VALUES(?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
      EXIT PROGRAM
   END IF    
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep2:",STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
      EXIT PROGRAM
   END IF 
#FUN-C70024-----add----end----------------------------
     IF cl_null(tm.wc) THEN LET tm.wc=" 1=1" END IF
 
#FUN-C70024--------------add---begin---------------
     IF s_industry("slk") AND g_azw.azw04 = '2' AND tm.detail = 'Y' THEN
        LET l_sql = " SELECT img01,img02,img03,img04,imk05, imk06",
                    "   FROM ima_file,imx_file,img_file LEFT OUTER JOIN imk_file ",
                    "   ON img01 = imk01 AND img02 = imk02",
                    "   AND img03 = imk03 AND img04 = imk04",
                    "   AND imk05 =",last_y,
                    "   AND imk06 =",last_m,
                    " WHERE imx000 = img01 AND ima01 = imx00 AND  ", tm.wc,
                    " UNION SELECT img01,img02,img03,img04,imk05, imk06",
                    " FROM ima_file,img_file LEFT OUTER JOIN imk_file",
                    "    ON img01 = imk01 AND img02 = imk02",
                    "   AND img03 = imk03 AND img04 = imk04",
                    "   AND imk05 =",last_y,
                    "   AND imk06 =",last_m,
                    " WHERE ima01 = img01 AND ima151 <> 'Y' AND  ", tm.wc,
                    " GROUP BY img01,img02,img03,img04,imk05,imk06",
                    " ORDER BY img01 "

     ELSE
#FUN-C70024--------------add---end-----------------    
     LET l_sql = "SELECT img01, img02, img03, img04, imk05, imk06",
                 "  FROM ima_file,img_file LEFT OUTER JOIN imk_file",
                 "    ON img01 = imk01 AND img02 = imk02",
                 "   AND img03 = imk03 AND img04 = imk04",
                 "   AND imk05 =",last_y,
                 "   AND imk06 =",last_m,
                 " WHERE ima01 = img01 AND  ", tm.wc
               # " GROUP BY img01,img02,img03,img04,imk05,imk06",
               # " ORDER BY img01 " 
     END IF    #FUN-C70024--add
 
     PREPARE g106_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2)  #FUN-C70024--add
        EXIT PROGRAM 
     END IF
     DECLARE g106_curs1 CURSOR FOR g106_prepare1
 
     LET g_success = 'Y'
     BEGIN WORK
     FOREACH g106_curs1 INTO sr.img01,sr.img02,sr.img03,sr.img04,
                             sr.tmp01,sr.tmp02
         SELECT COUNT(*) INTO l_cnt FROM aimg106_tmp  #--己存在不覆蓋
             WHERE img01 = sr.img01 AND img02 = sr.img02
             AND   img03 = sr.img03 AND img04 = sr.img04
         IF  NOT cl_null(l_cnt) AND l_cnt <> 0 THEN
             CONTINUE FOREACH
         END IF
          #MOD-4C0105
         IF sr.tmp02 = g_mm  THEN
            LET sr.tmp02 = sr.tmp02 - 1
              IF sr.tmp02 = 0 THEN
                 LET sr.tmp02 = 12
                 LET sr.tmp01 = sr.tmp01 - 1
              END IF
         END IF
          #MOD-4C0105(end)
         LET sr.img10 = 0
         SELECT imk09,img09 INTO sr.imk09,l_img09 FROM img_file LEFT OUTER JOIN imk_file
            ON img01 = imk01 AND img02 = imk02
             AND img03 = imk03 AND img04 = imk04
             AND imk05 = sr.tmp01 AND imk06 = sr.tmp02
            WHERE img01 = sr.img01 AND img02 = sr.img02
              AND img03 = sr.img03 AND img04 = sr.img04
         IF  SQLCA.sqlcode THEN
             LET g_success = 'N'
#            CALL cl_err(sr.img01,SQLCA.sqlcode,1) #No.FUN-660156
             CALL cl_err3("sel","imk_file",sr.img01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
         END IF
         IF  cl_null(sr.imk09) THEN LET sr.imk09 = 0  END IF
         IF  cl_null(l_img09)  THEN LET l_img09 = ' ' END IF
         SELECT ima25 INTO sr.ima25 FROM ima_file WHERE ima01 = sr.img01
         LET l_img2ima_fac  = 1
         IF  l_img09 <> sr.ima25 THEN
             CALL s_umfchk(sr.img01,l_img09,sr.ima25)
                  RETURNING g_i,l_img2ima_fac
             IF  g_i = 1 THEN
                 LET l_img2ima_fac = 1
                 CALL cl_err(sr.img01,'mfg3075',0)
             END IF
         END IF
         LET sr.imk09 = sr.imk09 * l_img2ima_fac #--期末庫存量(轉換後)
         INSERT INTO aimg106_tmp VALUES(sr.*)
         IF  SQLCA.sqlcode THEN
             LET g_success = "N"
#            CALL cl_err('ins g106_tmp 1:',SQLCA.sqlcode,1)
             CALL cl_err3("ins","aimg106_tmp",sr.img01,"",SQLCA.sqlcode,"",
                          "ins g106_tmp 1",1)   #NO.FUN-640266 #No.FUN-660156
         END IF
     END FOREACH
 
     LET l_sql = " SELECT tlf01,tlf902,tlf903,tlf904, ",
                       # " (tlf907*tlf10),' ',0,0,0,tlf11 ",        #MOD-620087  #No.MOD-710183 delete mark #MOD-970290 mark 
                        " (tlf907*tlf10*tlf60),' ',0,0,0,tlf11 ",        #MOD-620087  #No.MOD-710183 delete mark #MOD-970290 add
                       #" (tlf907*tlf10*tlf60),' ',0,0,0,tlf11 ",  #MOD-620087  #No.MOD-710183 mark
                 " FROM img_file,tlf_file",
                 " WHERE img01 = tlf01 ",
                 " AND (img02 = tlf902 AND img03 = tlf903 AND img04 = tlf904) ",
                 " AND img01 = ? AND img02 = ? AND img03 = ? AND img04 = ? ",
                 " AND tlf06 BETWEEN ? AND '",tm.edate,"'",
                 " AND tlf907 IN (1,-1)"   #入出庫碼 (1:入庫 -1:出庫 0:其它
     PREPARE g106_prepare2 FROM l_sql
     IF SQLCA.sqlcode THEN CALL cl_err('prepare2:',SQLCA.sqlcode,1) LET g_success = 'N' END IF
     DECLARE g106_curs2 CURSOR WITH HOLD FOR g106_prepare2
 
     DECLARE g106_cur3 CURSOR FOR
     SELECT * FROM aimg106_tmp
 
     FOREACH g106_cur3 INTO sr.*
         # CALL s_azm(sr.tmp01,sr.tmp02)     #MOD-510083   #No.MOD-580027 mark
          CALL s_azm(g_yy,g_mm)              #No.MOD-580027 抓取本期的起始日期
         RETURNING g_chr,m_bdate,m_edate
         LET l_imk09 = sr.imk09
         INSERT INTO aimg106_tmp2 VALUES(sr.*)
         IF SQLCA.SQLCODE THEN
#           CALL cl_err('ins g106 tmp2:',SQLCA.SQLCODE,0)
            CALL cl_err3("ins","aimg106_tmp2",sr.img01,"",SQLCA.sqlcode,"",
                         "ins g106 tmp2",0)   #NO.FUN-640266
            LET g_success='N'
         END IF
     #No:9314
 
         FOREACH g106_curs2 USING sr.img01,sr.img02,sr.img03,sr.img04,m_bdate
                            INTO sr.*,l_img09
             IF  SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
             SELECT ima25 INTO sr.ima25 FROM ima_file WHERE ima01 = sr.img01
             LET l_img2ima_fac  = 1
             IF  l_img09 <> sr.ima25 THEN
                 CALL s_umfchk(sr.img01,l_img09,sr.ima25)
                      RETURNING g_i,l_img2ima_fac
                 IF  g_i = 1 THEN
                      LET l_img2ima_fac = 1
                      CALL cl_err(sr.img01,'mfg3075',0)
                 END IF
             END IF
             LET sr.imk09 = sr.imk09 * l_img2ima_fac #--期末庫存量(轉換後)
            #LET sr.img10 = sr.img10 * l_img2ima_fac #No:MOD-580027 期間異動數量(轉換後)   #MOD-B40005 mark
             INSERT INTO aimg106_tmp2 VALUES(sr.*)
             IF  SQLCA.sqlcode THEN
                 LET g_success = 'N'
#                CALL cl_err('ins g106_tmp 1:',SQLCA.sqlcode,1)
                 CALL cl_err3("ins","aimg106_tmp2",sr.img01,"",SQLCA.sqlcode,
                              "ins g106_tmp 1","",1)   #NO.FUN-640266 #No.FUN-660156
             END IF
         END FOREACH
     END FOREACH
     IF g_success = 'Y' THEN
         CALL cl_cmmsg(1) COMMIT WORK
     ELSE
         CALL cl_rbmsg(1) ROLLBACK WORK RETURN
     END IF
 
#     CALL cl_outnam('aimg106') RETURNING l_name      #No.FUN-770006
#     START REPORT g106_rep TO l_name                 #No.FUN-770006
     DECLARE aimg106_tmp_cur CURSOR FOR
      SELECT * FROM aimg106_tmp2   #MOD-510083
     FOREACH aimg106_tmp_cur INTO sr.*
        IF  SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
#       OUTPUT TO REPORT g106_rep(sr.*)               #No.FUN-770006
        #No.FUN-770006 --start--
        SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file                   
              WHERE ima01 = sr.img01                                                
        IF SQLCA.sqlcode THEN                                                     
           LET l_ima02 = ' '                                                     
           LET l_ima021 = ' '                                                    
        END IF 
#FUN-C70024----add----begin-----------------
        IF s_industry("slk") AND g_azw.azw04 = '2' AND tm.detail = 'Y' THEN
           SELECT imx00 INTO l_imx00 FROM imx_file WHERE imx000 = sr.img01
           IF cl_null(l_imx00) THEN
              LET l_imx00 = sr.img01
           END IF 
           INSERT INTO tmpa_file (tmpa01,tmpa02,tmpa03,tmpa04,tmpa05,tmpa06,tmpa00)
                       VALUES (sr.img01,sr.img02,sr.img03,sr.img04,sr.img10,sr.imk09,l_imx00)
        ELSE
           LET l_total = sr.img10 + sr.imk09   #FUN-C70024--add
           IF cl_null(l_total) THEN
              LET l_total = 0
           END IF
           EXECUTE insert_prep USING sr.img01,l_ima02,l_ima021,sr.img02,sr.img03,
                                   sr.img04,sr.img10,sr.imk09,sr.ima25,l_total
        END IF
#FUN-C70024----add----end-------------------
        #No.FUN-770006 --end--
     END FOREACH
#FUN-C70024----------------add----begin----------------
     IF s_industry("slk") AND g_azw.azw04 = '2' AND tm.detail = 'Y' THEN 
        INITIALIZE sr.* TO NULL 
        LET l_sql = " SELECT tmpa00,tmpa02,tmpa03,tmpa04,SUM(tmpa05),SUM(tmpa06) FROM tmpa_file",
                    " GROUP BY tmpa00,tmpa02,tmpa03,tmpa04",
                    " ORDER BY tmpa00,tmpa02"
        PREPARE g106_slk_pre FROM l_sql
        DECLARE g106_slk_cs CURSOR FOR g106_slk_pre
        FOREACH g106_slk_cs INTO sr.img01,sr.img02,sr.img03,sr.img04,sr.img10,sr.imk09
           IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
           SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,sr.ima25 FROM ima_file 
             WHERE ima01 = sr.img01

           IF cl_null(sr.img10) THEN
              LET sr.img10 = 0
           END IF
           IF cl_null(sr.imk09) THEN
              LET sr.imk09 = 0
           END IF
           LET l_total = sr.img10 + sr.imk09   
           EXECUTE insert_prep USING sr.img01,l_ima02,l_ima021,sr.img02,sr.img03,
                                   sr.img04,sr.img10,sr.imk09,sr.ima25,l_total
#子報表一
           SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01 = sr.img01
           IF l_ima151 = 'Y' THEN 
              LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
                          " WHERE imx00 = '",sr.img01,"'",
                          "   AND imx02=agd02",
                          "   AND agd01 IN ",
                          " (SELECT ima941 FROM ima_file WHERE ima01='",sr.img01,"')",
                          " ORDER BY agd04"
              PREPARE g106_sr2_pre FROM l_sql
              DECLARE g106_sr2_cs CURSOR FOR g106_sr2_pre
              LET l_imx02 = NULL
              INITIALIZE l_imx_t.* TO NULL
              LET l_i = 1
              FOREACH g106_sr2_cs INTO l_imx02,l_agd04
                SELECT agd03 INTO l_imx[l_i].imx01  FROM agd_file,ima_file
                 WHERE agd01 = ima941 AND agd02 = l_imx02
                   AND ima01 = sr.img01
                 LET l_i = l_i + 1
              END FOREACH
              FOR l_i = 1 TO 15
                  IF cl_null(l_imx[l_i].imx01) THEN
                     LET l_imx[l_i].imx01 = ' '
                  END IF
              END FOR
              LET l_imx_t.agd03_1 = l_imx[1].imx01
              LET l_imx_t.agd03_2 = l_imx[2].imx01
              LET l_imx_t.agd03_3 = l_imx[3].imx01
              LET l_imx_t.agd03_4 = l_imx[4].imx01
              LET l_imx_t.agd03_5 = l_imx[5].imx01
              LET l_imx_t.agd03_6 = l_imx[6].imx01
              LET l_imx_t.agd03_7 = l_imx[7].imx01
              LET l_imx_t.agd03_8 = l_imx[8].imx01
              LET l_imx_t.agd03_9 = l_imx[9].imx01
              LET l_imx_t.agd03_10 = l_imx[10].imx01
              LET l_imx_t.agd03_11 = l_imx[11].imx01
              LET l_imx_t.agd03_12 = l_imx[12].imx01
              LET l_imx_t.agd03_13 = l_imx[13].imx01
              LET l_imx_t.agd03_14 = l_imx[14].imx01
              LET l_imx_t.agd03_15 = l_imx[15].imx01
              EXECUTE insert_prep1 USING l_imx_t.*,sr.img01 

#子报表二
              LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
                          " WHERE imx00 = '",sr.img01,"'",
                          "   AND imx01=agd02",
                          "   AND agd01 IN ",
                          " (SELECT ima940 FROM ima_file WHERE ima01='",sr.img01,"')",
                          " ORDER BY agd04"
              PREPARE g106_colslk_pre FROM l_sql
              DECLARE g106_colslk_cs CURSOR FOR g106_colslk_pre
              LET l_imx01 = NULL
              LET l_agd04 = NULL
              LET l_cnt = 1
              LET l_i = 1
              FOREACH g106_colslk_cs INTO l_imx01,l_agd04
              FOR l_i = 1 TO 15
                  SELECT DISTINCT agd02 INTO l_imx02 FROM agd_file WHERE agd03 = l_imx[l_i].imx01   #尺碼屬性值
                  IF l_imx[l_i].imx01 == ' ' THEN
                     LET l_num[l_i].number = ' '  #FUN-CB0055--0--> ' '
                     CONTINUE FOR
                  END IF
                  SELECT sma46 INTO l_ps FROM sma_file
                  IF cl_null(l_ps) THEN LET l_ps = ' ' END IF
                  LET l_ima01 = sr.img01,l_ps,l_imx01,l_ps,l_imx02
                  SELECT COUNT(*) INTO l_n FROM img_file WHERE img01 = l_ima01  AND img02 = sr.img02 
                                                           AND img03 = sr.img03 AND img04 = sr.img04
                  IF l_n > 0 THEN
                     SELECT tmpa05,tmpa06 INTO l_img10,l_imk09_1 FROM tmpa_file WHERE tmpa01 = l_ima01
                                                                                  AND tmpa02 = sr.img02
                                                                                  AND tmpa03 = sr.img03
                                                                                  AND tmpa04 = sr.img04
                     IF cl_null(l_img10) THEN
                        LET l_img10 = 0
                     END IF

                     IF cl_null(l_imk09_1) THEN
                        LET l_imk09_1 = 0
                     END IF
                     LET l_number =  l_imk09_1 + l_img10
                     LET l_num[l_i].number = l_number
                     #FUN-CB0055---add--begin----------
                     IF l_num[l_i].number = '0' THEN
                        LET l_num[l_i].number = ' '
                     END IF 
                     #FUN-CB0055---add--end------------
                  ELSE
                     LET l_num[l_i].number = ' '  #FUN-CB0055 0-->' '
            
                  END IF
             END FOR
             LET l_num_t.num_1 = l_num[1].number
             LET l_num_t.num_2 = l_num[2].number
             LET l_num_t.num_3 = l_num[3].number
             LET l_num_t.num_4 = l_num[4].number
             LET l_num_t.num_5 = l_num[5].number
             LET l_num_t.num_6 = l_num[6].number
             LET l_num_t.num_7 = l_num[7].number
             LET l_num_t.num_8 = l_num[8].number
             LET l_num_t.num_9 = l_num[9].number
             LET l_num_t.num_10 = l_num[10].number
             LET l_num_t.num_11 = l_num[11].number
             LET l_num_t.num_12 = l_num[12].number
             LET l_num_t.num_13 = l_num[13].number
             LET l_num_t.num_14 = l_num[14].number
             LET l_num_t.num_15 = l_num[15].number
             EXECUTE insert_prep2 USING l_imx01,l_num_t.*,sr.img01,sr.img02,sr.img03,sr.img04 
           END FOREACH
         END IF
       END FOREACH 
     END IF  
#FUN-C70024----------------add----end------------------
#    FINISH REPORT g106_rep                           #No.FUN-770006
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)      #No.FUN-770006
#No.FUN-770006 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'img01,img02,img03,img04')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###GENGRE###     LET g_str = g_str
###GENGRE###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
###GENGRE###     CALL cl_prt_cs3('aimg106','aimg106',l_sql,g_str)
    IF s_industry("slk") AND g_azw.azw04 = '2' AND tm.detail = 'Y'THEN
       LET g_template = 'aimg106_slk'
       CALL aimg106_slk_grdata()
    ELSE                                         #FUN-C70024--add
       LET g_template = 'aimg106_1'              #FUN-C70024--add
       CALL aimg106_1_grdata()    ###GENGRE###   #FUN-C70024--add
    END IF                                       #FUN-C70024--add
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT g106_rep(sr)
   DEFINE l_last_sw   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          sr          RECORD
                      img01 LIKE img_file.img01,   #--料號
                      img02 LIKE img_file.img02,   #--倉
                      img03 LIKE img_file.img03,   #--儲
                      img04 LIKE img_file.img04,   #--批
                      img10 LIKE img_file.img10,   #--出入庫量
                      ima25 LIKE ima_file.ima25,   #--料件主檔單位
                      imk09 LIKE imk_file.imk09,   #--上期期末庫存
                      tmp01 LIKE imk_file.imk05,   #--上期期末年度  #No.FUN-690026 SMALLINT
                      tmp02 LIKE imk_file.imk06    #--上期期末期別  #No.FUN-690026 SMALLINT
                      END RECORD,
          l_ima02     LIKE ima_file.ima02,
          l_ima021    LIKE ima_file.ima021 #FUN-510017
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.img01,sr.img02,sr.img03,sr.img04
  FORMAT
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT ' '
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.img01
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
          WHERE ima01 = sr.img01
      IF SQLCA.sqlcode THEN
          LET l_ima02 = ' '
          LET l_ima021 = ' '
      END IF
      PRINT COLUMN g_c[31],sr.img01 ,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021;
      LET l_imk09 = 0 #MOD-580027
 
   AFTER GROUP OF sr.img04
     #-------------No.MOD-710183 mark
     ##MOD-580027................begin
     #SELECT imk09 INTO sr.imk09 FROM img_file,imk_file
     # WHERE img01 = imk_file.imk01    AND img02 = imk_file.imk02
     #   AND img03 = imk03    AND img04 = imk04
     #   AND img01 = sr.img01 AND img02 = sr.img02
     #   AND img03 = sr.img03 AND img04 = sr.img04
     #   AND imk_file.imk05 = last_y   AND imk_file.imk06 = last_m
     # #MOD-580027................end
     #-------------No.MOD-710183 mark
 
     #IF tm.a = 'Y' THEN
     #    PRINT COLUMN  53,sr.img02,"/",sr.img03,"/",sr.img04,
     #          COLUMN 100,GROUP SUM(sr.imk09+sr.img10) USING "------------&.&&&",' ',sr.ima25
     #END IF
      PRINT COLUMN g_c[34],sr.img02,
            COLUMN g_c[35],sr.img03,
            COLUMN g_c[36],sr.img04,
            COLUMN g_c[37],cl_numfor(GROUP SUM(sr.imk09+sr.img10),37,3), #No.MOD-710183
           #COLUMN g_c[37],cl_numfor(sr.imk09+GROUP SUM(sr.img10),37,3), #MOD-580027 #No.MOD-710183 mark
            COLUMN g_c[38],sr.ima25
   #No:9314
   #  LET l_imk09=l_imk09=sr.imk09
      LET l_imk09=l_imk09+sr.imk09
 
   AFTER GROUP OF sr.img01
          PRINT g_dash2
          PRINT COLUMN g_c[36],g_x[19] CLIPPED,
                COLUMN g_c[37],cl_numfor(GROUP SUM(sr.imk09+sr.img10),37,3) #No.MOD-710183
               #COLUMN g_c[37],cl_numfor(l_imk09+GROUP SUM(sr.img10),37,3)  #MOD-580027  #No.MOD-710183 mark
          PRINT
 
   ON LAST ROW
 #    PRINT COLUMN  85,g_x[20] CLIPPED,
 #          COLUMN 100, SUM(sr.imk09+sr.img10) USING "------------&.&&&" ,' ',sr.ima25
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF  l_last_sw = 'n' THEN
          PRINT g_dash
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
          SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-770006  --end--


###GENGRE###START
FUNCTION aimg106_slk_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aimg106")
        IF handler IS NOT NULL THEN
            START REPORT aimg106_slk_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            DECLARE aimg106_datacur1 CURSOR FROM l_sql
            FOREACH aimg106_datacur1 INTO sr1.*
                OUTPUT TO REPORT aimg106_slk_rep(sr1.*)
            END FOREACH
            FINISH REPORT aimg106_slk_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION
#FUN-C70024-----add---begin----------
FUNCTION aimg106_1_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("aimg106")
        IF handler IS NOT NULL THEN
            START REPORT aimg106_1_rep TO XML HANDLER handler
         #  LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
            LET l_sql = " SELECT img01,ima02,ima021,img02,img03,img04,'','',ima25,SUM(total) FROM ",
                         g_cr_db_str CLIPPED,l_table CLIPPED, " GROUP BY img01,ima02,ima021,img02,img03,img04,ima25",
                        " ORDER BY img01,img02,img03,img04"
            DECLARE aimg106_datacur4 CURSOR FROM l_sql
            FOREACH aimg106_datacur4 INTO sr1.*
                OUTPUT TO REPORT aimg106_1_rep(sr1.*)
            END FOREACH
            FINISH REPORT aimg106_1_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION
#FUN-C70024-----add---end------------

REPORT aimg106_slk_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_img10_imk09      LIKE img_file.img10  #FUN-C70024
    DEFINE l_img10_imk09_sum  LIKE img_file.img10  #FUN-C70024
    DEFINE l_img10_imk09_sum1 LIKE img_file.img10  #FUN-C70024
    DEFINE sr2 sr2_t                               #FUN-C70024
    DEFINE sr3 sr3_t                               #FUN-C70024
    DEFINE l_sql              STRING               #FUN-C70024 
    DEFINE l_ima151           LIKE ima_file.ima151 #FUN-C70024
    DEFINE l_show             LIKE type_file.chr1  #FUN-C70024

    
    ORDER EXTERNAL BY sr1.img01,sr1.img02,sr1.img03,sr1.img04
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.img01
        BEFORE GROUP OF sr1.img02
        BEFORE GROUP OF sr1.img03
        BEFORE GROUP OF sr1.img04

        
        ON EVERY ROW
            LET l_img10_imk09 = sr1.total  
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*
            PRINTX l_img10_imk09

#FUN-C70024----add--begin-------
            SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=sr1.img01
            IF l_ima151='Y' AND l_img10_imk09 > 0 THEN
               LET l_show = 'Y'
            ELSE
               LET l_show = 'N'
            END IF
            PRINTX l_show

            LET l_sql = " SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        "  WHERE ima01 = '",sr1.img01 CLIPPED,"'" 

            DECLARE aimg106_datacur2 CURSOR FROM l_sql
            START REPORT aimg106_slk_subrep01   #TQC-D40004 
            FOREACH aimg106_datacur2 INTO sr2.*
                OUTPUT TO REPORT aimg106_slk_subrep01(sr2.*)  #TQC-D40004
            END FOREACH
            FINISH REPORT aimg106_slk_subrep01  #TQC-D40004
         
#子报表2
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE img01 = '",sr1.img01,"' AND img02 = '",sr1.img02,"'",
                        "   AND img03 = '",sr1.img03,"' AND img04 = '",sr1.img04,"' "
            DECLARE aimg106_datacur3 CURSOR FROM l_sql
            START REPORT aimg106_slk_subrep02  #TQC-D40004
            FOREACH aimg106_datacur3 INTO sr3.*
               OUTPUT TO REPORT aimg106_slk_subrep02(sr3.*)  #TQC-D40004
            END FOREACH
            FINISH REPORT aimg106_slk_subrep02  #TQC-D40004
#FUN-C70024---add---end----------
        AFTER GROUP OF sr1.img01
            LET l_img10_imk09_sum1 = GROUP SUM(sr1.total)      #FUN-C70024--add
            PRINTX l_img10_imk09_sum1                          #FUN-C70024--add
        AFTER GROUP OF sr1.img02
        AFTER GROUP OF sr1.img03
        AFTER GROUP OF sr1.img04
      #     LET l_img10_imk09_sum = GROUP SUM(l_img10_imk09)   #FUN-C70024--add
      #     PRINTX l_img10_imk09_sum                           #FUN-C70024--add

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C70024----add---begin---------
 REPORT aimg106_slk_subrep01(sr2)  #TQC-D40004
    DEFINE sr2 sr2_t
    DEFINE l_show  LIKE type_file.chr1

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*

 END REPORT

 REPORT aimg106_slk_subrep02(sr3)  #TQC-D40004
    DEFINE sr3 sr3_t
    DEFINE l_color    LIKE agd_file.agd03
    DEFINE p_n        LIKE type_file.num5 
    DEFINE l_display2 LIKE type_file.chr1
    FORMAT
        ON EVERY ROW
        SELECT agd03 INTO l_color FROM agd_file,ima_file
           WHERE agd01 = ima940 AND agd02 = sr3.imx01
             AND ima01 = sr3.img01
            PRINTX l_color
            PRINTX sr3.*

        #FUN-CB0055--modify---begin-----------0----> ''
        IF sr3.number1 is null AND sr3.number2 is null AND sr3.number3 is null AND sr3.number4 is null
           AND sr3.number5 is null AND sr3.number6 is null AND sr3.number7 is null AND sr3.number8 is null
           AND sr3.number9 is null AND sr3.number10 is null AND sr3.number11 is null AND sr3.number12 is null
           AND sr3.number13 is null AND sr3.number14 is null AND sr3.number15 is null THEN
           LET l_display2 = 'N' 
        ELSE
           LET l_display2 = 'Y' 
        END IF
        PRINTX l_display2 
 END REPORT

REPORT aimg106_1_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_img10_imk09      LIKE img_file.img10  #FUN-C70024
    DEFINE l_img10_imk09_sum  LIKE img_file.img10  #FUN-C70024
    DEFINE l_img10_imk09_sum1 LIKE img_file.img10  #FUN-C70024


    ORDER EXTERNAL BY sr1.img01,sr1.img02,sr1.img03,sr1.img04

    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*

        BEFORE GROUP OF sr1.img01
        BEFORE GROUP OF sr1.img02
        BEFORE GROUP OF sr1.img03
        BEFORE GROUP OF sr1.img04


        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*
            LET l_img10_imk09 = sr1.total               #FUN-C70024--add
            PRINTX l_img10_imk09                        #FUN-C70024--add  
        AFTER GROUP OF sr1.img01
            LET l_img10_imk09_sum1 = GROUP SUM(sr1.total)      #FUN-C70024--add
            PRINTX l_img10_imk09_sum1                          #FUN-C70024--add
        AFTER GROUP OF sr1.img02
        AFTER GROUP OF sr1.img03
        AFTER GROUP OF sr1.img04
        #   LET l_img10_imk09_sum = GROUP SUM(l_img10_imk09)   #FUN-C70024--add
        #   PRINTX l_img10_imk09_sum                           #FUN-C70024--add


        ON LAST ROW

END REPORT
#FUN-C70024----add---end-----------

