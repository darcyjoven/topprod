# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr500.4gl
# Descriptions...: 工單下階用料需求明細表
# Date & Author..: 91/11/19 By Keith
# Modify.........: No.MOD-4A0041 04/10/05 By Mandy Oracle DEFINE ROWID_NO INTEGER  應該轉為char(18)
# Modify.........: No.MOD-4A0041 在convert 作業中_rowid 才會做正確的轉換
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.FUN-550067  05/06/01 By yoyo單據編號格式放大
# Modify.........: No.FUN-590110  05/09/26 By will  報表轉xml格式
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5A0061 05/11/21 By Pengu 報表缺規格
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-670041 06/08/10 By Pengu 將sma29 [虛擬產品結構展開與否] 改為 no use
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-750041 07/05/14 By sherry 頁次格式有誤
# Modify.........: No.CHI-790021 07/09/17 By kim 修改-239的寫法
# Modify.........: NO.TQC-7B0143 07/11/27 By Mandy FUNCTION alloc_bom名在$SUB/s_alloc.4gl內也有相同的FUNCTION 名,所以更名為r500_alloc_bom,否則r.l2不會過
# Modify.........: No.FUN-710073 07/06/28 By jamie 1.UI將 '天' -> '天/生產批量'
#                                                  2.將程式有用到 'XX前置時間'改為乘以('XX前置時間' 除以 '生產單位批量(ima56)')
# Modify.........: No.FUN-7C0007 07/12/12 By baofei  報表輸出至 Crystal Reports功能       
# Modify.........: No.CHI-810015 08/01/17 By jamie 將FUN-710073修改部份還原
# Modify.........: No.FUN-840194 08/06/24 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-940340 09/04/24 By Smapmin 程式段位置修改
# Modify.........: No.FUN-940008 09/05/13 By hongmei 發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A40058 10/04/26 By lilingyu bmb16增加7.規格替代的內容
# Modify.........: No:TQC-A60097 10/05/27 By Carrier 加LET l_sql = l_sql CLIPPED,cl_get_extra_cond
# Modify.........: No.FUN-A60027 10/06/12 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A60097 10/06/22 By liuxqa TQC-A60097拆单过来，不做修改，过单用
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-D40109 13/07/17 By yangtt 1.程序中加上CALL cl_show_help()函數2.修改rpt模版
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   tm       RECORD                       # Print condition RECORD
     a     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 1.是否包含確任生產工單的下階用料需求明細(Y/N)
     b     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 2.供給明細是否包含請購單(Y/N)
     c     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 3.是否僅列印供給不足之料件明細(Y/N)
        END RECORD,
   g_sql         string,                 #No.FUN-580092 HCN
   g_tot_bal     LIKE ccq_file.ccq03,    #No.FUN-680121 DECIMAL(13,2)# User defined variable
   g_ima86       LIKE ima_file.ima86,
   g_ima86_fac   LIKE ima_file.ima86_fac,
   g_opseq       LIKE type_file.num5,          #No.FUN-680121 SMALLINT#operation sequence number
   g_offset      LIKE type_file.num5,          #No.FUN-680121 SMALLINT#offset
   g_btflg       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#blow through flag
   g_wo          LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#No.FUN-550067
   g_wotype      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#work order type
   g_level       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   level         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   g_lvl         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   g_ccc         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   g_SOUCode     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
   g_mps         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
   g_yld         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
   g_minopseq    LIKE ecb_file.ecb03,
   g_date        LIKE type_file.dat            #No.FUN-680121 DATE
 
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-7C0007---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING                                                   
                                                       
#No.FUN-7C0007---End  
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
#No.FUN-7C0007---Begin                                                          
   LET g_sql = "out01.type_file.chr1000,",                                         
               "out02.oea_file.oea01,",                                         
               "out03.type_file.dat,",                                         
               "out04.bed_file.bed07,",                                         
               "out05.bed_file.bed07,",                                         
               "out06.bed_file.bed07,",    
               "out08.type_file.chr1,",
               "ima02.ima_file.ima02,",                                         
               "ima021.ima_file.ima021,",                                         
               "ima08.ima_file.ima08,",
               "ima25.ima_file.ima25,",
               "l_qty.rpf_file.rpf04,",   
               "l_qty1.bed_file.bed07,",
               "l_qty2.bed_file.bed07,", 
               "l_sfb05.sfb_file.sfb05,",
               "l_ima02.ima_file.ima02,",     #No.TQC-D40109   Add
               "l_ima021.ima_file.ima021"     #No.TQC-D40109   Add   
                                                        
   LET l_table = cl_prt_temptable('asfr500',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "   #No.TQC-D40109   Add 2?      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF  
#No.FUN-7C0007---End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asfr500_tm(0,0)        # Input print condition
      ELSE CALL asfr500()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr500_tm(p_row,p_col)
   DEFINE
      p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
      l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 7 LET p_col = 25
   ELSE LET p_row = 7 LET p_col = 11
   END IF
   OPEN WINDOW asfr500_w AT p_row,p_col
     WITH FORM "asf/42f/asfr500"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.a = 'Y'
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   WHILE TRUE
   #No.FUN-680121-BEGIN
      CREATE TEMP TABLE tmp_file(
        tmp01     LIKE oea_file.oea01,
        tmp03     LIKE type_file.chr1000,
        tmp04     LIKE bed_file.bed07,
        tmp05     LIKE bed_file.bed07,
        tmp06     LIKE bed_file.bed07,
        tmp07     LIKE bed_file.bed07,
        tmp08     LIKE type_file.num5,  
        tmp09     LIKE type_file.num5,  
        tmp11     LIKE type_file.chr1,  
        tmp12     LIKE ade_file.ade04,
        tmp13     LIKE ade_file.ade34,
        tmp15     LIKE ade_file.ade34,
#       tmp161    LIKE ima_file.ima26,
        tmp161    LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044 
        tmp25     LIKE bed_file.bed07,
        tmp26     LIKE type_file.chr1);
   #No.FUN-680121-END   
      CREATE  INDEX tmp_01 ON tmp_file (tmp01,tmp03,tmp08,tmp12);
   #No.FUN-680121-BEGIN   
    CREATE TEMP TABLE out_file(
       out01      LIKE type_file.chr1000,
       out02      LIKE oea_file.oea01,
       out03      LIKE type_file.dat,   
       out04      LIKE bed_file.bed07,
       out05      LIKE bed_file.bed07,
       out06      LIKE bed_file.bed07,
       out08      LIKE type_file.chr1);
  #No.FUN-680121-END     
       CREATE  INDEX out_01 ON out_file (out01);
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW asfr500_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
          EXIT PROGRAM
       END IF
       DISPLAY BY NAME tm.a,tm.b,tm.c      # Condition
       INPUT BY NAME tm.a, tm.b, tm.c  WITHOUT DEFAULTS
           ON ACTION locale
               LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
               EXIT INPUT
 
          AFTER FIELD a
             IF tm.a NOT MATCHES "[YN]" OR tm.a IS NULL
                THEN NEXT FIELD a
             END IF
          AFTER FIELD b
             IF tm.b NOT MATCHES "[YN]" OR tm.b IS NULL
                THEN NEXT FIELD b
             END IF
             IF g_sma.sma31 = "N" AND tm.b ="Y" THEN
                CALL cl_err('','asf-510',0)
                LET tm.b = "N"
                NEXT FIELD b
             END IF
          AFTER FIELD c
             IF tm.c NOT MATCHES "[YN]" OR tm.c IS NULL
                THEN NEXT FIELD c
             END IF
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          ON ACTION CONTROLG
              CALL cl_cmdask()     # Command execution
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
          ON ACTION exit
             LET INT_FLAG = 1
             EXIT INPUT
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---

        #No.TQC-D40109 ---add--- str
         ON ACTION help
            CALL cl_show_help()
        #No.TQC-D40109 ---add--- end
 
       END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          EXIT WHILE
       END IF
       IF g_sma.sma18 = 'Y' THEN    #顯示低階是否需重新計算
          IF NOT s_recode(0,0,"1") THEN
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
             EXIT PROGRAM
          END IF
       END IF
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                  WHERE zz01='asfr500'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('asfr500','9031',1)  
          ELSE
             LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
             " '",g_pdate CLIPPED,"'",
             " '",g_towhom CLIPPED,"'",
             #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
             " '",g_bgjob CLIPPED,"'",
             " '",g_prtway CLIPPED,"'",
             " '",g_copies CLIPPED,"'",
             " '",tm.a CLIPPED,"'",
             " '",tm.b CLIPPED,"'",
             " '",tm.c CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
             CALL cl_cmdat('asfr500',g_time,l_cmd)
          END IF
          CLOSE WINDOW asfr500_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
          EXIT PROGRAM
       END IF
       CALL cl_wait()
       CALL asfr500()
       ERROR ""
    END WHILE
    CLOSE WINDOW asfr500_w
END FUNCTION
 
FUNCTION asfr500()
   DEFINE
      l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time      LIKE type_file.chr8        #No.FUN-6A0090
      l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
      l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
      l_sfa01   LIKE sfa_file.sfa01,
      l_sfa03   LIKE sfa_file.sfa03,
      l_sfa04   LIKE sfa_file.sfa04,
      l_sfa05   LIKE sfa_file.sfa05,
      l_sfa06   LIKE sfa_file.sfa06,
      l_sfa07   LIKE sfa_file.sfa07,
      l_sfa08   LIKE sfa_file.sfa08,
      l_sfa09   LIKE sfa_file.sfa09,
      l_sfa11   LIKE sfa_file.sfa11,
      l_sfa12   LIKE sfa_file.sfa12,
      l_sfa13   LIKE sfa_file.sfa13,
      l_sfa15   LIKE sfa_file.sfa15,
      l_sfa161  LIKE sfa_file.sfa161,
      l_sfa25   LIKE sfa_file.sfa25,
      l_sfa26   LIKE sfa_file.sfa26,
      l_sfb01   LIKE sfb_file.sfb01,
      l_sfb02   LIKE sfb_file.sfb02,
      l_sfb05   LIKE sfb_file.sfb05,
      l_sfb06   LIKE sfb_file.sfb06,
      l_sfb08   LIKE sfb_file.sfb08,
      l_sfb13   LIKE sfb_file.sfb13,
      l_sfb23   LIKE sfb_file.sfb23,
      l_sfb42   LIKE sfb_file.sfb42,
      l_sfb071  LIKE sfb_file.sfb071,
      l_sfb04   LIKE sfb_file.sfb04,
      l_tmp01   LIKE sfa_file.sfa01,
      l_tmp03   LIKE sfa_file.sfa03,
      l_tmp05   LIKE sfa_file.sfa05,
      l_tmp06   LIKE sfa_file.sfa06,
      l_tmp07   LIKE sfa_file.sfa07,
      l_tmp09   LIKE sfa_file.sfa09,
      l_tmp25   LIKE sfa_file.sfa25,
      l_ttp01   LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#No.FUN-550067
      l_ttp02   LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#No.FUN-550067
      l_ttp03   LIKE type_file.dat,           #No.FUN-680121 DATE
      l_ttp04   LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
      l_pmk25   LIKE pmk_file.pmk25,
      l_pml21   LIKE pml_file.pml21,
#     l_ima262  LIKE ima_file.ima262,
#     l_sum1    LIKE ima_file.ima262,          #No.FUN-680121 DECIMAL(12,3)
#     l_sum2    LIKE ima_file.ima262,          #No.FUN-680121 DECIMAL(12,3)
#     l_sum3    LIKE ima_file.ima262,          #No.FUN-680121 DECIMAL(12,3)
      l_avl_stk LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044 
      l_sum1    LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
      l_sum2    LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
      l_sum3    LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
      l_out01   LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#No.FUN-550067
      l_date    LIKE type_file.dat,           #No.FUN-680121 DATE
      l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#     l_qty     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
      l_qty     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044 
#     l_qty1    LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
      l_qty1    LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
      l_order   ARRAY[5] OF LIKE oea_file.oea01,#No.FUN-680121 VARCHAR(16)#No.FUN-550067
      l_minopseq LIKE ecb_file.ecb03,
      l_ima02      LIKE ima_file.ima02,          #No.FUN-7C0007
      l_ima021     LIKE ima_file.ima021,         #No.FUN-7C0007 
      l_ima08      LIKE ima_file.ima08,          #No.FUN-7C0007 
      l_ima25      LIKE ima_file.ima25,          #No.FUN-7C0007 
      l_ima50      LIKE ima_file.ima50,          #No.FUN-7C0007 
      l_ima48      LIKE ima_file.ima48,          #No.FUN-7C0007 
      l_ima49      LIKE ima_file.ima49,          #No.FUN-7C0007 
      l_ima491     LIKE ima_file.ima491,         #No.FUN-7C0007 
      l_ima59      LIKE ima_file.ima59,          #No.FUN-7C0007 
      l_ima60      LIKE ima_file.ima60,          #No.FUN-7C0007 
      l_ima601     LIKE ima_file.ima601,         #No.FUN-840194
      l_ima61      LIKE ima_file.ima61,          #No.FUN-7C0007 
      l_ima56      LIKE ima_file.ima56,          #No.FUN-7C0007 
      l_qty2       LIKE bed_file.bed07,          #No.FUN-7C0007 
      l_short_qty  LIKE sfa_file.sfa07,          #No.FUN-940008 add
      l_sfa27      LIKE sfa_file.sfa27,          #No.FUN-940008 add
      sr   RECORD
          out01      LIKE ima_file.ima01,          #No.FUN-680121 VARCHAR(40)#料件編號        #No.FUN-550067
          out02      LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#單據號碼        #No.FUN-550067
          out03      LIKE type_file.dat,           #No.FUN-680121 DATE#需求或供給日期
          out04      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(9,2)#需求或供給數量
          out05      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(9,2)#未備料量(對需求而言)
          out06      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(9,2)#缺料量(對需求而言)
          out08      LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)#需求:1  供給:2
          END RECORD,
      tp1   RECORD
          ttp01     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#料件編號   #No.FUN-550067
          ttp02     LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#No.FUN-550067
          ttp03     LIKE type_file.dat,           #No.FUN-680121 DATE#供給日期
          ttp04     LIKE bed_file.bed07           #No.FUN-680121 DECIMAL(12,3)#供給量
          END RECORD
   DEFINE   l_n1    LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2    LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3    LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044 
   DEFINE  l_sfa012 LIKE sfa_file.sfa012          #FUN-A60027
   DEFINE  l_sfa013 LIKE sfa_file.sfa013          #FUN-A60027 
   DEFINE  l_temp   LIKE type_file.chr1000        #FUN-A60027
   DEFINE  l_temp01 LIKE bed_file.bed07           #FUN-A60027
   DEFINE  l_temp02 LIKE bed_file.bed07           #FUN-A60027
   DEFINE l_ima02_1    LIKE ima_file.ima02        #No.TQC-D40109   Add
   DEFINE l_ima021_1   LIKE ima_file.ima021       #No.TQC-D40109   Add

    CALL cl_del_data(l_table)                                  #No.FUN-7C0007
 
    SELECT zo02 INTO g_company FROM zo_file
     WHERE zo01 = g_rlang
#No.FUN-590110  --begin
#  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file
#    WHERE zz01 = 'asfr500'
#     LET g_len = 144              #No.FUN-550067
#  FOR g_i = 1 TO g_len
#      LET g_dash[g_i,g_i] = '='
#  END FOR
#No.FUN-590110  --end
   # Part 1 產生需求之資料
   LET l_sql = "SELECT sfb01,sfb02,sfb05,sfb23,",
               " sfb071,sfb06,sfb08,sfb04,sfb42",
               " FROM sfb_file ",
               " WHERE sfb87!='X' AND (sfb86 IS NULL OR sfb86 = ' ') ",
               " AND sfb23 = 'N' AND sfb08 > sfb09  "
   IF tm.a = "Y" THEN   # 包含確任生產工單的下階用料需求明細
      LET l_sql = l_sql clipped," AND sfb04 IN ('1','2','3','4','5','6','7') "
   ELSE
      LET l_sql = l_sql clipped," AND sfb04 IN ('2','3','4','5','6','7')  "
   END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
 
   PREPARE asfr500_pre1 FROM l_sql
   DECLARE asfr500_curs1 CURSOR WITH HOLD FOR asfr500_pre1
   FOREACH asfr500_curs1 INTO l_sfb01,l_sfb02,
      l_sfb05,l_sfb23,l_sfb071,l_sfb06,l_sfb08 ,l_sfb04,l_sfb42
      IF SQLCA.SQLCODE THEN
         CALL cl_err('Foreach asfr500_curs1:',SQLCA.sqlcode,1)
      END IF
      CALL s_minopseq(l_sfb05,l_sfb06,l_sfb071) RETURNING l_minopseq
     #-----------No.FUN-670041 modify
     #CALL s_alloc(l_sfb01,l_sfb02,l_sfb05,g_sma.sma29,l_sfb08,l_sfb071,
      CALL s_alloc(l_sfb01,l_sfb02,l_sfb05,'Y',l_sfb08,l_sfb071,
     #-----------No.FUN-670041 end
                  'Y',g_sma.sma71,l_minopseq,99)
      RETURNING g_cnt
   END FOREACH
   # Part 2 ------產生供給之暫存資料(含W/O , P/O)
   SELECT COUNT(*) INTO l_cnt FROM tmp_file
   IF l_cnt > 0 THEN
      LET l_sql = " SELECT UNIQUE tmp03 FROM tmp_file ",
                  " UNION ",
                  " SELECT UNIQUE sfa03 FROM sfa_file ",
                  " WHERE sfa03 NOT IN (SELECT UNIQUE tmp03 FROM tmp_file)"
   ELSE
      LET l_sql = " SELECT UNIQUE sfa03 FROM sfa_file "
   END IF
   PREPARE r500_psu FROM l_sql
   DECLARE r500_suply CURSOR WITH HOLD FOR r500_psu
   #==>供給方面之採購資料
   LET l_sql = " SELECT UNIQUE pmn04,pmn01,pmn35,pmn20 ",
              "   FROM pmm_file,pmn_file ",
              "  WHERE pmn01 = pmm01 AND pmm18!='X' ",
              "  AND pmm25 NOT IN ('6','7','8','9')",
              "  AND pmn16 IN ('0','1','2') AND pmn20 >= pmn50 ",
              "  AND pmn011 != 'SUB' AND pmn04 = ? "
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND pmmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')  #No.TQC-A60097
    #End:FUN-980030
 
   PREPARE asfr500_pre3 FROM l_sql
   DECLARE asfr500_curs3 CURSOR WITH HOLD FOR asfr500_pre3
   #==>供給方面之工單尋找
   LET l_sql = " SELECT sfb05,sfb01,sfb15,sfb08 - sfb09 - sfb11 ",
                " FROM sfb_file ",
                " WHERE sfb05 = ? AND sfb87!= 'X' ",
                " AND sfb04 != '8' "
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')  #No.TQC-A60097
    #End:FUN-980030
 
   PREPARE asfr500_pre4 FROM l_sql
   DECLARE asfr500_curs4 CURSOR WITH HOLD FOR asfr500_pre4
   #==>供給方面之請購單尋找
   LET l_sql =  " SELECT UNIQUE pml04,pml01,pml35,pml20,pmk25,pml21 ",
                " FROM pmk_file,pml_file ",
                " WHERE pmk01 = pml01 AND pmk18!= 'X' ",
                " AND pmk25 IN ('X','0','1','2') ",
                " AND pml04 = ? "
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND pmkuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND pmkgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND pmkgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup')  #No.TQC-A60097
    #End:FUN-980030
 
   PREPARE asfr500_pre5 FROM l_sql
   DECLARE asfr500_curs5 CURSOR WITH HOLD FOR asfr500_pre5
 
   MESSAGE 'Part No. Searching'
   CALL ui.Interface.refresh()
   FOREACH r500_suply INTO l_sfa03
      IF SQLCA.SQLCODE THEN
         CALL cl_err('Foreach suply:',SQLCA.sqlcode,1)
      END IF
      #取採購單供給資料
      FOREACH asfr500_curs3 USING l_sfa03 INTO tp1.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err('foreach asfr500_curs3:',SQLCA.sqlcode,1)
         END IF
         #將供給資料存入輸出暫存檔
         INSERT INTO out_file VALUES(tp1.*,0,0,'2')
         MESSAGE 'Insert Supply P/O: ',tp1.ttp01
         CALL ui.Interface.refresh()
         IF SQLCA.SQLCODE THEN
#           CALL cl_err('Insert fail:ckp#01',SQLCA.sqlcode,1)   #No.FUN-660128
            CALL cl_err3("ins","out_file","","",SQLCA.sqlcode,"","Insert fail:ckp#01",1)    #No.FUN-660128
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
         END IF
      END FOREACH
 
      FOREACH asfr500_curs4 USING l_sfa03 INTO tp1.*
         IF SQLCA.SQLCODE THEN
            CALL cl_err('Foreach asfr500_curs4:',SQLCA.sqlcode,1)
         END IF
         #將供給資料存入輸出暫存檔
         INSERT INTO out_file VALUES(tp1.*,0,0,'2')
         MESSAGE 'Insert Supply W/O: ',tp1.ttp01
         CALL ui.Interface.refresh()
         IF SQLCA.SQLCODE THEN
#           CALL cl_err('Insert fail:ckp#02',SQLCA.sqlcode,1)   #No.FUN-660128
            CALL cl_err3("ins","out_file","","",SQLCA.sqlcode,"","Insert fail:ckp#02",1)    #No.FUN-660128
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
         END IF
      END FOREACH
 
      IF tm.b = "Y" AND g_sma.sma32 = "Y" THEN  #供給明細含請購單
         FOREACH asfr500_curs5 USING l_sfa03 INTO tp1.*,l_pmk25,l_pml21
            IF SQLCA.SQLCODE THEN
               CALL cl_err('Foreach asfr500_curs5:',SQLCA.sqlcode,1)
            END IF
            LET l_qty = tp1.ttp04 - l_pml21
            #將供給資料存入輸出暫存檔
            INSERT INTO out_file VALUES(tp1.ttp01,tp1.ttp02,
                                     tp1.ttp03,l_qty,0,0,'2')
            MESSAGE 'Insert Supply P/R: ',tp1.ttp01
            CALL ui.Interface.refresh()
            IF SQLCA.SQLCODE THEN
#              CALL cl_err('Insert fail:ckp#03',SQLCA.sqlcode,1)   #No.FUN-660128
               CALL cl_err3("ins","out_file","","",SQLCA.sqlcode,"","Insert fail:ckp#03",1)    #No.FUN-660128
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
               EXIT PROGRAM
            END IF
         END FOREACH
      END IF
   END FOREACH
 
   LET l_sql = " SELECT tmp03,tmp01,tmp05,tmp06,tmp25,tmp07,tmp09,sfb13 ",
               " FROM tmp_file,OUTER sfb_file WHERE tmp05-tmp06>0 AND ",
               "  tmp_file.tmp01 = sfb_file.sfb01 "
   PREPARE out1_pre FROM l_sql
   DECLARE out1_cur CURSOR WITH HOLD FOR out1_pre
   FOREACH out1_cur INTO l_tmp03,l_tmp01,l_tmp05,l_tmp06,
         l_tmp25,l_tmp07,l_tmp09, l_sfb13
      IF SQLCA.SQLCODE THEN
         CALL cl_err('Foreach out1_cur:',SQLCA.sqlcode,1)
      END IF
      LET l_date = l_sfb13 - l_tmp09   #l_tmp09正值表多少天前,負值表多少天後
      LET l_qty1 = l_tmp05 - l_tmp06
      #將模擬產生備料需求資料存入輸出暫存檔
      INSERT INTO out_file VALUES(l_tmp03,l_tmp01,l_date,l_qty1,l_tmp25,
                  l_tmp07,'1')
      MESSAGE 'Insert Fancy Needed : ',l_tmp03
      CALL ui.Interface.refresh()
      IF SQLCA.SQLCODE THEN
#        CALL cl_err('Insert fail:ckp#04',SQLCA.sqlcode,1)   #No.FUN-660128
         CALL cl_err3("ins","out_file","","",SQLCA.sqlcode,"","Insert fail:ckp#04",1)    #No.FUN-660128
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
      END IF
   END FOREACH
   #將已產生備料之工單備料資料insert 至報表列印暫存檔
#  LET l_sql = " SELECT sfa03,sfa01,sfa05,sfa06,sfa25,sfa07,sfa09,sfb13 ",  #FUN-940008 mark
   LET l_sql = " SELECT sfa03,sfa01,sfa05,sfa06,sfa25,'',sfa09,sfb13,sfa08,sfa12,sfa27,sfa012,sfa013 ",  #FUN-940008 add    #FUN-A60027 add sfa012,sfa013
               " FROM sfa_file,sfb_file ",
               " WHERE sfa01 = sfb01 AND sfa05-sfa06 >0 AND sfb23 = 'Y' ",
               " AND sfb04 != '8' AND sfb87!='X' "
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')  #No.TQC-A60097
    #End:FUN-980030
 
   PREPARE out3_pre FROM l_sql
   DECLARE out3_cur CURSOR WITH HOLD FOR out3_pre
 
   FOREACH out3_cur INTO l_sfa03,l_sfa01,l_sfa05,l_sfa06,
                         l_sfa25,l_sfa07,l_sfa09,l_sfb13,
                         l_sfa08,l_sfa12,l_sfa27,l_sfa012,l_sfa013   #FUN-940008 add    #FUN-A60027 add sfa012,sfa013
      IF SQLCA.SQLCODE THEN
         CALL cl_err('Foreach out3_cur:',SQLCA.sqlcode,1)
      END IF
      LET l_date = l_sfb13 - l_sfa09   #l_sfa09正值表多少天前,負值表多少天後
      LET l_qty1 = l_sfa05 - l_sfa06
      #FUN-940008---Begin add  #欠料量計算
      CALL s_shortqty(l_sfa01,l_sfa03,l_sfa08,l_sfa12,l_sfa27,l_sfa012,l_sfa013)   #FUN-A60027 add l_sfa012,l_sfa013
           RETURNING l_short_qty
      IF cl_null(l_short_qty) THEN LET l_short_qty = 0 END IF
      LET l_sfa07 = l_short_qty
      #No.FUN-A60027 ----------------start-------------------
      LET l_temp = NULL
      LET l_temp01 = NULL
      LET l_temp02 = NULL
      SELECT out01,out04,out06 INTO l_temp,l_temp01,l_temp02 
        FROM out_file 
       WHERE out01 = l_sfa03
      IF NOT cl_null(l_temp) THEN
         #跟新需求資料 
         UPDATE out_file 
            SET out04 = l_temp01 + l_qty1 ,
                out06 = l_temp02 + l_sfa07
          WHERE out01 = l_sfa03
         MESSAGE 'Update Real Needed :' ,l_sfa03
         CALL ui.Interface.refresh()
         IF SQLCA.SQLCODE THEN
            CALL cl_err3("upd","out_file","","",SQLCA.sqlcode,"","Update fail:ckp#04",1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF 
      ELSE
      #No.FUN-A60027------------------end--------------------
         #FUN-940008---End
         #將需求資料存入輸出暫存檔
         INSERT INTO out_file VALUES(l_sfa03,l_sfa01,l_date,l_qty1,l_sfa25,
                                     l_sfa07,'1')
         MESSAGE 'Insert Real Needed :' ,l_sfa03
         CALL ui.Interface.refresh()
         IF SQLCA.SQLCODE THEN
#           CALL cl_err('Insert fail:ckp#04',SQLCA.sqlcode,1)   #No.FUN-660128
            CALL cl_err3("ins","out_file","","",SQLCA.sqlcode,"","Insert fail:ckp#04",1)    #No.FUN-660128
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
         END IF
      END IF          #No.FUN-A60027 add
   END FOREACH
 
#   LET l_name = 'asfr500.out'                    #No.FUN-7C0007
#   CALL cl_outnam('asfr500') RETURNING l_name    #No.FUN-7C0007
#   START REPORT asfr500_rep TO l_name            #No.FUN-7C0007
 
#   LET g_pageno = 0                              #No.FUN-7C0007
   IF tm.c = "Y" THEN      #列印供給不足之料件明細
      DECLARE asfr500_curs7 CURSOR FOR SELECT UNIQUE out01
       FROM out_file ORDER BY out01
      LET g_sql =  "SELECT * FROM out_file ",
                   " WHERE out01 = ?   ",
                   " ORDER BY out01,out03,out08,out02"
      PREPARE asfr500_pre8 FROM g_sql
      DECLARE asfr500_curs8 CURSOR FOR asfr500_pre8
      MESSAGE 'Data Ordering.....'
      CALL ui.Interface.refresh()
      FOREACH asfr500_curs7 INTO l_out01
         IF SQLCA.SQLCODE THEN
            CALL cl_err('Foreach asfr500_curs7:',SQLCA.sqlcode,1)
         END IF
         SELECT SUM(out04) INTO l_sum1 FROM out_file
                     WHERE out01 = l_out01 AND out08 = '1'
         SELECT SUM(out04) into l_sum2 FROM out_file
                     WHERE out01 = l_out01 AND out08 = '2'
#        SELECT ima262 INTO l_ima262 FROM ima_file
#                    WHERE ima01 = l_out01
         CALL s_getstock(l_out01,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
         LET l_avl_stk = l_n3                                #NO.FUN-A20044 
         IF l_sum1 IS NULL THEN LET l_sum1 = 0 END IF
         IF l_sum2 IS NULL THEN LET l_sum2 = 0 END IF
         IF l_sum3 IS NULL THEN LET l_sum3 = 0 END IF
#        LET l_sum3 = l_ima262
         LET l_sum3 = l_avl_stk   
         IF l_sum3 - l_sum1 + l_sum2 < 0 THEN
            MESSAGE 'Process Done , Printing.....'
            CALL ui.Interface.refresh()
            FOREACH asfr500_curs8 USING l_out01 INTO sr.*
               IF SQLCA.sqlcode != 0  THEN
                  CALL cl_err('Foreach asfr500_curs8:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
#No.FUN-7C0007---Begin
      SELECT ima02,ima021,ima08,ima25,ima50,ima48,ima49,        
             #ima491,ima59,ima60,ima61,ima262,ima56        #No.FUN-840194     
#            ima491,ima59,ima60,ima601,ima61,ima262,ima56  #No.FUN-840194   #NO.FUN-A20044            
             ima491,ima59,ima60,ima601,ima61,0,ima56       #NO.FUN-A20044
      INTO l_ima02,l_ima021,l_ima08,l_ima25,l_ima50,l_ima48,   
           #l_ima49,l_ima491,l_ima59,l_ima60,l_ima61,         #No.FUN-840194   
           l_ima49,l_ima491,l_ima59,l_ima60,l_ima601,l_ima61, #No.FUN-840194    
#          l_ima262,l_ima56   #NO.FUN-A20044                                 
           l_avl_stk,l_ima56  #NO.FUN-A20044
      FROM ima_file WHERE ima01 = sr.out01
      IF l_ima08 = "P" THEN
         LET l_qty1= l_ima50 + l_ima48 + l_ima49 + l_ima491
#        LET l_qty2 = l_ima262   #NO.FUN-A20044
         LET l_qty2 = l_avl_stk  #NO.FUN-A20044 
      END IF
      IF l_ima08 = "M" THEN
        #CHI-810015---mod---str---
        #LET l_qty1= l_ima59+l_ima60+l_ima61            #No.FUN-840194  
         LET l_qty1= l_ima59+l_ima60/l_ima601+l_ima61   #No.FUN-840194
        #LET l_qty1= (l_ima59/l_ima56) + 
        #            (l_ima60/l_ima56) + 
        #            (l_ima61/l_ima56)        
        #CHI-810015---mod---end---
#        LET l_qty2 = l_ima262      #NO.FUN-A20044
         LET l_qty2 = l_avl_stk     #NO.FUN-A20044
      END IF
      IF l_ima08 NOT MATCHES '[MP]' THEN
#        LET l_qty1 = l_ima262      #NO.FUN-A20044
         LET l_qty1 = l_avl_stk     #NO.FUN-A20044
      END IF
 
#     LET l_qty = l_ima262          #NO.FUN-A20044
      LET l_qty = l_avl_stk         #NO.FUN-A20044 
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file WHERE ima01 = l_sfb05   #No.TQC-D40109   Add
      IF sr.out08 = '1' THEN  
         LET l_qty = l_qty - sr.out04
         SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = sr.out02
         EXECUTE insert_prep USING sr.out01,sr.out02,sr.out03,sr.out04,sr.out05,                                                    
                                   sr.out06,sr.out08,l_ima02,l_ima021,l_ima08,l_ima25,                                                       
                                   l_qty,l_qty1,l_qty2,l_sfb05
                                   ,l_ima02,l_ima021   #No.TQC-D40109   Add l_ima02,l_ima021 
      END IF
      IF sr.out08 = '2' THEN  
         LET l_qty = l_qty + sr.out04
      #END IF   #MOD-940340
         LET sr.out05=''                                                                                                            
         LET sr.out06=''                                                                                                            
         LET l_sfb05=''                                                                                                             
         EXECUTE insert_prep USING sr.out01,sr.out02,sr.out03,sr.out04,sr.out05,                                                    
                                   sr.out06,sr.out08,l_ima02,l_ima021,l_ima08,l_ima25,                                                       
                                   l_qty,l_qty1,l_qty2,l_sfb05   
                                   ,l_ima02,l_ima021   #No.TQC-D40109   Add l_ima02,l_ima021
      END IF   #MOD-940340
#               OUTPUT TO REPORT asfr500_rep(sr.*)
 
#No.FUN-7C0007---End
               INITIALIZE sr.* TO NULL
            END FOREACH
         ELSE
            CONTINUE FOREACH
         END IF
      END FOREACH
   END IF
   IF tm.c = "N" THEN   #列印供需所有之料件明細
      DECLARE asfr500_curs6 CURSOR FOR SELECT *
                          FROM out_file
                          ORDER BY out01,out03,out08,out02
      MESSAGE 'Process Done , Printing.....'
      CALL ui.Interface.refresh()
      FOREACH asfr500_curs6 INTO sr.*
         IF SQLCA.sqlcode != 0  THEN
            CALL cl_err('Foreach asfr500_curs6:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
#No.FUN-7C0007---Begin
      SELECT ima02,ima021,ima08,ima25,ima50,ima48,ima49,        
             #ima491,ima59,ima60,ima61,ima262,ima56        #No.FUN-840194
#            ima491,ima59,ima60,ima601,ima61,ima262,ima56  #No.FUN-840194   #NO.FUN-A20044        
             ima491,ima59,ima60,ima601,ima61,0,ima56       #NO.FUN-A20044  
      INTO l_ima02,l_ima021,l_ima08,l_ima25,l_ima50,l_ima48,   
           #l_ima49,l_ima491,l_ima59,l_ima60,l_ima61,         #No.FUN-840194
           l_ima49,l_ima491,l_ima59,l_ima60,l_ima601,l_ima61, #No.FUN-840194 
#          l_ima262,l_ima56                                #NO.FUN-A20044    
           l_avl_stk,l_ima56                                       #NO.FUN-A20044                                 
      FROM ima_file WHERE ima01 = sr.out01
      IF l_ima08 = "P" THEN
         LET l_qty1= l_ima50 + l_ima48 + l_ima49 + l_ima491
#        LET l_qty2 = l_ima262    #NO.FUN-A20044
         LET l_qty2 = l_avl_stk   #NO.FUN-A20044
 
      END IF
      IF l_ima08 = "M" THEN
       
        #CHI-810015---mod---str---
        #LET l_qty1= l_ima59+l_ima60+l_ima61   #No.FUN-840194
         LET l_qty1= l_ima59+l_ima60/l_ima601+l_ima61 #No.FUN-840194  
        #LET l_qty1= (l_ima59/l_ima56) + 
        #            (l_ima60/l_ima56) + 
        #            (l_ima61/l_ima56)        
#        LET l_qty2 = l_ima262    #NO.FUN-A20044
         LET l_qty2 = l_avl_stk   #NO.FUN-A20044 
        #CHI-810015---mod---end---
      END IF
      IF l_ima08 NOT MATCHES '[MP]' THEN
#        LET l_qty1 = l_ima262    #NO.FUN-A20044
         LET l_qty1 = l_avl_stk   #NO.FUN-A20044
      END IF
 
#     LET l_qty = l_ima262        #NO.FUN-A20044
      LET l_qty = l_avl_stk       #NO.FUN-A20044 
      IF sr.out08 = '1' THEN  
         LET l_qty = l_qty - sr.out04
         SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = sr.out02
         EXECUTE insert_prep USING sr.out01,sr.out02,sr.out03,sr.out04,sr.out05,
                                   sr.out06,sr.out08,l_ima02,l_ima021,l_ima08,l_ima25,
                                   l_qty,l_qty1,l_qty2,l_sfb05
      END IF
      IF sr.out08 = '2' THEN 
         LET l_qty = l_qty + sr.out04
         LET sr.out05=''
         LET sr.out06=''
         LET l_sfb05=''
         EXECUTE insert_prep USING sr.out01,sr.out02,sr.out03,sr.out04,sr.out05,                                                    
                                   sr.out06,sr.out08,l_ima02,l_ima021,l_ima08,l_ima25,                                                       
                                   l_qty,l_qty1,l_qty2,l_sfb05       
      END IF
#         OUTPUT TO REPORT asfr500_rep(sr.*)
#No.FUN-7C0007---End
         INITIALIZE sr.* TO NULL
      END FOREACH
   END IF
#No.FUN-7C0007---Begin 
#   FINISH REPORT asfr500_rep
    LET g_str=''
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('asfr500','asfr500',l_sql,g_str) 
#No.FUN-7C0007---End
   DROP TABLE tmp_file
   DROP TABLE out_file
   MESSAGE ' '
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)    #No.FUN-7C0007
END FUNCTION
#No.FUN-7C0007---Begin
#REPORT asfr500_rep(sr)
#  DEFINE
#     l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#     l_ima02      LIKE ima_file.ima02,
#     l_ima021     LIKE ima_file.ima021,         #No.FUN-5A0061 add
#     l_ima08      LIKE ima_file.ima08,
#     l_ima25      LIKE ima_file.ima25,
#     l_ima50      LIKE ima_file.ima50,
#     l_ima48      LIKE ima_file.ima48,
#     l_ima49      LIKE ima_file.ima49,
#     l_ima491     LIKE ima_file.ima491,
#     l_ima262     LIKE ima_file.ima262,
#     l_ima59      LIKE ima_file.ima59,
#     l_ima60      LIKE ima_file.ima60,
#     l_ima61      LIKE ima_file.ima61,
#     l_sfb05      LIKE sfb_file.sfb05,
#     l_ima56      LIKE ima_file.ima56,          #FUN-710073 add
#     l_ttp101     LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
#     l_qty        LIKE rpf_file.rpf04,          #No.FUN-680121 DECIMAL(11,2)
#     l_qty1       LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
#     l_qty2       LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
#     l_qty3       LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
#     l_qty4       LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(12,3)
#     sr           RECORD
#       out01      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#料件編號           #No.FUN-550067
#       out02      LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#單據號碼           #No.FUN-550067
#       out03      LIKE type_file.dat,           #No.FUN-680121 DATE#需求或供給日期
#       out04      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(9,2)#需求或供給數量
#       out05      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(9,2)#未備料量(對需求而言)
#       out06      LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(9,2)#缺料量(對需求而言)
#       out08      LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)#需求:1  供給:2
#              END RECORD
 
#  OUTPUT   TOP MARGIN g_top_margin
#          LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#          PAGE LENGTH g_page_line
#  ORDER BY sr.out01
#  FORMAT
#  PAGE HEADER
#No.FUN-590110  --begin
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#     PRINT
#  #No.TQC-750041---begin                                                                                                     
#  #    PRINT g_x[2] CLIPPED,g_today,' ',TIME,                                                                                     
#  #          COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'                                                                     
#       LET g_pageno = g_pageno + 1                                                                                                
#       LET pageno_total = PAGENO USING '<<<','/pageno'                                                                            
#       PRINT g_head CLIPPED, pageno_total                                                                                         
#       PRINT ' '                                                                                                                  
##     LET g_pageno = g_pageno + 1
##     LET pageno_total = PAGENO USING '<<<'
##     PRINT g_head CLIPPED,pageno_total
##     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#  #No.TQC-750041---end  
##     PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2 ,g_company CLIPPED
##     IF cl_null(g_towhom) THEN
##         PRINT '';
##     ELSE
##         PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2 ,g_x[1] CLIPPED
##     PRINT ' '
##     LET g_pageno = g_pageno + 1
##     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME,
##           COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<<'
#     PRINT g_dash[1,g_len]
##     PRINT '          ===========================【 ',g_x[11] CLIPPED,
##           ' 】===========================  ======【 ',g_x[12] CLIPPED,
##NO.FUN-550067 --start--
##           ' 】==============================='
#     PRINT COLUMN g_c[36],g_x[51],g_x[11] CLIPPED,g_x[52],' ',g_x[53],g_x[12] CLIPPED,g_x[54]
##     PRINT g_x[13] CLIPPED,'  ',g_x[14] CLIPPED,'         ',g_x[15] CLIPPED,      #No.FUN-550067
##           '             ',g_x[16] CLIPPED,'    ',g_x[17] CLIPPED,'     ',
##           g_x[18] CLIPPED,'    ',g_x[19] CLIPPED,'  ',g_x[20] CLIPPED,'         ',    #No.FUN-550067
##           g_x[21] CLIPPED,'       ',g_x[22] CLIPPED,'     ',g_x[23] CLIPPED
##     PRINT '          ---------------- -------------------- -------- ---------',       #No.FUN-550067
##          '-- ---------- ----------- ---------------- -------- ------------   ',        #No.FUN-550067
##          '----------'
#     PRINT g_x[31],g_x[32],g_x[47],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],     #No.FUN-5A0061 add
#           g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
#
#  BEFORE GROUP OF sr.out01
#     SELECT ima02,ima021,ima08,ima25,ima50,ima48,ima49,        #No.FUN-5A0061 add
#            ima491,ima59,ima60,ima61,ima262,ima56              #FUN-710073 add ima56
#     INTO l_ima02,l_ima021,l_ima08,l_ima25,l_ima50,l_ima48,    #No.FUN-5A0061 add
#          l_ima49,l_ima491,l_ima59,l_ima60,l_ima61,
#          l_ima262,l_ima56                                     #FUN-710073 add l_ima56
#     FROM ima_file WHERE ima01 = sr.out01
#     IF l_ima08 = "P" THEN
#        LET l_qty1= l_ima50 + l_ima48 + l_ima49 + l_ima491
#        LET l_qty2 = l_ima262
##        PRINT sr.out01 CLIPPED,' ',l_ima02,'  ',g_x[24] CLIPPED,l_ima08,'  ',
##              g_x[25] CLIPPED,l_ima25,'  ',g_x[26] CLIPPED,
##              l_qty1, COLUMN 117,
##              l_qty2
#        #PRINT COLUMN g_c[31],sr.out01[1,20],
#        PRINT COLUMN g_c[31],sr.out01 CLIPPED, #NO.FUN-5B0015
#              #COLUMN g_c[32],l_ima02[1,30],
#              COLUMN g_c[32],l_ima02 CLIPPED, #NO.FUN-5B0015
#              COLUMN g_c[47],l_ima021 CLIPPED, #No.FUN-5A0061 add
#              COLUMN g_c[33],l_ima08,
#              COLUMN g_c[34],l_ima25,
#              COLUMN g_c[35],cl_numfor(l_qty1,35,3),
#              COLUMN g_c[44],cl_numfor(l_qty2,44,3)
#     END IF
#     IF l_ima08 = "M" THEN
#       #FUN-710073---mod---str---
#       #LET l_qty1= l_ima59 + l_ima60 + l_ima61      
#        LET l_qty1= (l_ima59/l_ima56) + 
#                    (l_ima60/l_ima56) + 
#                    (l_ima61/l_ima56) 
#       #FUN-710073---mod---end---
 
#         LET l_qty2 = l_ima262
##        PRINT COLUMN 01,sr.out01 CLIPPED,
##              COLUMN 22,l_ima02 CLIPPED,
##              COLUMN 54,g_x[24] CLIPPED,l_ima08 CLIPPED,
##              COLUMN 62,g_x[25] CLIPPED,l_ima25 CLIPPED,
##              COLUMN 77,g_x[26] CLIPPED,l_qty1 CLIPPED,
##              COLUMN 117,l_qty2
#        #PRINT COLUMN g_c[31],sr.out01[1,20],
#        PRINT COLUMN g_c[31],sr.out01 CLIPPED, #NO.FUN-5B0015
#              #COLUMN g_c[32],l_ima02[1,30],
#              COLUMN g_c[32],l_ima02 CLIPPED, #NO.FUN-5B0015
#              COLUMN g_c[47],l_ima021 CLIPPED, #No.FUN-5A0061 add
#              COLUMN g_c[33],l_ima08,
#              COLUMN g_c[34],l_ima25,
#              COLUMN g_c[35],cl_numfor(l_qty1,35,3),
#              COLUMN g_c[44],cl_numfor(l_qty2,44,3)
#
#     END IF
#     IF l_ima08 NOT MATCHES '[MP]' THEN
#         LET l_qty1 = l_ima262
##        PRINT COLUMN 01,sr.out01 CLIPPED,
##              COLUMN 22,l_ima02 CLIPPED,
##              COLUMN 54,g_x[24] CLIPPED,l_ima08 CLIPPED,
##              COLUMN 62,g_x[25] CLIPPED,l_ima25 CLIPPED,
##              COLUMN 77,g_x[26] CLIPPED,l_qty1
#        #PRINT COLUMN g_c[31],sr.out01[1,20],
#        PRINT COLUMN g_c[31],sr.out01 CLIPPED, #NO.FUN-5B0015
#              #COLUMN g_c[32],l_ima02[1,30],
#              COLUMN g_c[32],l_ima02 CLIPPED,  #NO.FUN-5B0015
#              COLUMN g_c[47],l_ima021 CLIPPED, #No.FUN-5A0061 add
#              COLUMN g_c[33],l_ima08,
#              COLUMN g_c[34],l_ima25,
#              COLUMN g_c[35],cl_numfor(l_qty1,35,3)
#     END IF
##     PRINT '          -------------------------------------------------',
##           '-----------------------------------------------------------',
##           '-------------------------'
##No.FUN-550067 --end--
#     LET l_qty = l_ima262
 
#  ON EVERY ROW
#     IF sr.out08 = '1' THEN #需求資料
#        LET l_qty = l_qty - sr.out04
#        SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = sr.out02
#        IF l_qty >= 0 THEN
##           PRINT COLUMN 11,sr.out02,
###No.FUN-550067 --start--
##                 COLUMN 28,l_sfb05 CLIPPED,
##                 COLUMN 49,sr.out03 CLIPPED,
##                 COLUMN 58,sr.out04 CLIPPED,
##                 COLUMN 69,sr.out05 CLIPPED,
##                 COLUMN 81,sr.out06 CLIPPED,
##                 COLUMN 130,l_qty CLIPPED
#           PRINT COLUMN g_c[36],sr.out02,
#                 COLUMN g_c[37],l_sfb05 CLIPPED,
#                 COLUMN g_c[38],sr.out03 CLIPPED,
#                 COLUMN g_c[39],cl_numfor(sr.out04,39,2),
#                 COLUMN g_c[40],cl_numfor(sr.out05,40,2),
#                 COLUMN g_c[41],cl_numfor(sr.out06,41,2),
#                 COLUMN g_c[45],cl_numfor(l_qty,45,2)
#        END IF
#        IF l_qty < 0 THEN    #如果供需差異和為負,加MARK "*"
##           PRINT COLUMN 11,sr.out02 CLIPPED,
##                 COLUMN 28,l_sfb05 CLIPPED,
##                 COLUMN 49,sr.out03 CLIPPED,
##                 COLUMN 58,sr.out04 CLIPPED,
##                 COLUMN 69,sr.out05 CLIPPED,
##                 COLUMN 81,sr.out06 CLIPPED,
##                 COLUMN 130,l_qty CLIPPED,'*'
#           PRINT COLUMN g_c[36],sr.out02,
#                 COLUMN g_c[37],l_sfb05 CLIPPED,
#                 COLUMN g_c[38],sr.out03 CLIPPED,
#                 COLUMN g_c[39],cl_numfor(sr.out04,39,2),
#                 COLUMN g_c[40],cl_numfor(sr.out05,40,2),
#                 COLUMN g_c[41],cl_numfor(sr.out06,41,2),
#                 COLUMN g_c[45],cl_numfor(l_qty,45,2),
#                 COLUMN g_c[46],'*'
#        END IF
#     END IF
#     IF sr.out08 = '2' THEN #供給資料
#        LET l_qty = l_qty + sr.out04
#        IF l_qty >= 0 THEN
##        PRINT COLUMN 93,sr.out02 CLIPPED,
##              COLUMN 110,sr.out03 CLIPPED,
##              COLUMN 119,sr.out04 CLIPPED,
##              COLUMN 130,l_qty CLIPPED
#        PRINT COLUMN g_c[42],sr.out02 CLIPPED,
#              COLUMN g_c[43],sr.out03 CLIPPED,
#              COLUMN g_c[44],cl_numfor(sr.out04,44,2),
#              COLUMN g_c[45],cl_numfor(l_qty,45,2)
#        END IF
#        IF l_qty < 0 THEN
##        PRINT COLUMN 93,sr.out02 CLIPPED,
##              COLUMN 110,sr.out03 CLIPPED,
##              COLUMN 119,sr.out04 CLIPPED,
##              COLUMN 130,l_qty CLIPPED,'*'
#        PRINT COLUMN g_c[42],sr.out02 CLIPPED,
#              COLUMN g_c[43],sr.out03 CLIPPED,
#              COLUMN g_c[44],cl_numfor(sr.out04,44,2),
#              COLUMN g_c[45],cl_numfor(l_qty,45,2),
#              COLUMN g_c[46],'*'
##No.FUN-550067 --end--
#        END IF
#     END IF
##No.FUN-590110  --end
 
#  AFTER GROUP OF sr.out01
#      PRINT
 
#  ON LAST ROW
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     LET l_last_sw = 'y'
#
#  PAGE TRAILER
#     PRINT COLUMN 5,g_x[27] CLIPPED,g_x[28] CLIPPED
#     IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE
#         SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-7C0007---End
FUNCTION s_alloc(p_wo,p_wotype,p_part,p_btflg,p_woq,p_date,p_mps,p_yld,
    p_minopseq,p_lvl)
#  DEFINE p_wo         VARCHAR(10), #work order number
   DEFINE p_wo         LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(16)#No.FUN-550067
          p_wotype     LIKE type_file.num5,          #No.FUN-680121 SMALLINT#work order type
          p_part       LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)#part number
          p_btflg      LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)#blow through flag
          p_woq        LIKE bed_file.bed07,          #No.FUN-680121 DECIMAL(11,3)#work order quantity
          p_date       LIKE type_file.dat,           #No.FUN-680121 DATE#effective date
          p_mps        LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)#if MPS phantom, blow through flag (Y/N)
          p_yld        LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)#inflate yield factor (Y/N)
          p_minopseq   LIKE ecb_file.ecb03,
          p_lvl        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_pt         LIKE type_file.num5,          #No.FUN-680121 SMALLINT#階層
          l_ima562     LIKE ima_file.ima562
   DEFINE l_ima910     LIKE ima_file.ima910          #FUN-550112
 
   MESSAGE ' Allocating '
   CALL ui.Interface.refresh()
   LET g_ccc=0
   LET g_date=p_date
   LET g_btflg=p_btflg
   LET g_wo=p_wo
   LET g_wotype=p_wotype
   LET g_opseq=''
   LET g_offset=''
   LET g_mps=p_mps
   LET g_lvl=p_lvl+1
   LET g_yld=p_yld
   LET g_errno=' '
   LET g_minopseq=p_minopseq
   SELECT ima562,ima86,ima86_fac INTO l_ima562,g_ima86,g_ima86_fac
    FROM ima_file WHERE ima01=p_part AND imaacti='Y'
   IF SQLCA.sqlcode THEN RETURN 0 END IF
   IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
   #檢查該料件是否有產品結構
   SELECT COUNT(*) INTO g_cnt FROM bmb_file WHERE bmb01=p_part
   IF g_cnt IS NULL OR g_cnt=0 THEN
      LET g_errno='asf-015'        #無產品結構
   ELSE
      #FUN-550112
      LET l_ima910=''
      SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part
      IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
      #--
      CALL r500_alloc_bom(0,p_part,l_ima910,p_woq,1,p_pt)  #FUN-550112 #TQC-7B0143
      IF g_ccc=0 THEN
         LET g_errno='asf-014'
      END IF    #有BOM但無有效者
   END IF
 
   MESSAGE ""
   RETURN g_ccc
END FUNCTION
 
#FUNCTION alloc_bom(p_level,p_key,p_key2,p_total,p_QPA,l_pt)  #FUN-550112 #TQC-7B0143
FUNCTION r500_alloc_bom(p_level,p_key,p_key2,p_total,p_QPA,l_pt)  #FUN-550112 #TQC-7B0143
DEFINE
   p_level        LIKE type_file.num5,          #No.FUN-680121 SMALLINT#level code
   p_total        LIKE bmb_file.bmb06,          #No.FUN-680121 DECIMAL(13,5)
   p_QPA          LIKE bmb_file.bmb06,          #No.FUN-680121 DECIMAL(11,7)
   l_total        LIKE bmb_file.bmb06,          #No.FUN-680121 DECIMAL(13,5)#原發數量
   l_total2       LIKE bmb_file.bmb06,          #No.FUN-680121 DECIMAL(13,5)#應發數量
   p_key          LIKE bma_file.bma01,          #assembly part number
   p_key2	  LIKE ima_file.ima910,         #FUN-550112
   l_ac,l_i,l_x   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   arrno          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    b_seq         LIKE type_file.num10,         #No.FUN-680121 INTEGER#MOD-4A0041
   l_double       LIKE type_file.num10,         #No.FUN-680121 INTEGER
   sr     DYNAMIC ARRAY OF RECORD  #array for storage
      bmb02       LIKE bmb_file.bmb02,
      bmb03       LIKE bmb_file.bmb03,
      bmb10       LIKE bmb_file.bmb10,
      bmb10_fac   LIKE bmb_file.bmb10_fac,
      bmb10_fac2  LIKE bmb_file.bmb10_fac2,
      bmb15       LIKE bmb_file.bmb15,
      bmb16       LIKE bmb_file.bmb16,
      bmb06       LIKE bmb_file.bmb06,
      bmb08       LIKE bmb_file.bmb08,
      bmb09       LIKE bmb_file.bmb09,
      bmb18       LIKE bmb_file.bmb18,
      ima08       LIKE ima_file.ima08,
      ima37       LIKE ima_file.ima37,
      ima25       LIKE ima_file.ima25,
      ima86       LIKE ima_file.ima86,
      ima86_fac   LIKE ima_file.ima86_fac,
      bma01       LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
      level       LIKE type_file.num5           #No.FUN-680121 SMALLINT
   END RECORD,
   g_tmp    RECORD
#    tmp01        VARCHAR(10),                   #工單編號
     tmp01        LIKE oea_file.oea01,        #No.FUN-680121 VARCHAR(16)#No.FUN-550067
     tmp03        LIKE type_file.chr20,       #No.FUN-680121 VARCHAR(20)#料件編號
#    tmp04        LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(12,3)#原發數量
     tmp04        LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
#    tmp05        LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(12,3)#應發數量
#    tmp06        LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(12,3)#已發數量
#    tmp07        LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(12,3)#缺料數量
     tmp05        LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
     tmp06        LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
     tmp07        LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
     tmp08        LIKE type_file.num5,        #No.FUN-680121 SMALLINT#作業序號
     tmp09        LIKE type_file.num5,        #No.FUN-680121 SMALLINT#前置時間調整(天)
     tmp11        LIKE type_file.chr1,        # Prog. Version..: '5.30.06-13.03.12(01)#旗標
     tmp12        LIKE gfe_file.gfe01,        # Prog. Version..: '5.30.06-13.03.12(04)#發料單位
     tmp13        LIKE ima_file.ima31_fac,    #No.FUN-680121 DECIMAL(16,8)#發料單位/庫存單位換算率
     tmp15        LIKE ima_file.ima31_fac,    #No.FUN-680121 DECIMAL(16,8)#成本單位/材料成本檔成本單位之換算率
     tmp161       LIKE bmb_file.bmb06,        #No.FUN-680121 DECIMAL(13,5)#儲存該工單備料料件在備料時所使用的單位用
#    tmp25        LIKE ima_file.ima26,        #No.FUN-680121 DECIMAL(12,3)#未備料量
     tmp25        LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
     tmp26        LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1)#資料來源
        END RECORD,
   l_pt           LIKE type_file.num5,        #No.FUN-680121 SMALLINT
   l_ima08        LIKE ima_file.ima08, #source code
#  l_ima26        LIKE ima_file.ima26, #QOH
   l_avl_stk      LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044 
   l_SafetyStock  LIKE ima_file.ima27,
   l_ima37        LIKE ima_file.ima37, #OPC
   l_ima108       LIKE ima_file.ima108,
   l_ima64        LIKE ima_file.ima64,     #Issue Pansize
   l_ima641       LIKE ima_file.ima641,    #Minimum Issue QTY
   l_uom          LIKE ima_file.ima25,     #Stock UOM
   l_chr          LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
   l_tmp07        LIKE sfa_file.sfa07, #quantity owed
   l_tmp11        LIKE sfa_file.sfa11, #consumable flag
#  l_qty          LIKE ima_file.ima26, #issuing to stock qty
   l_qty          LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
#  l_bal          LIKE ima_file.ima26, #balance (QOH-issue)
   l_bal          LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
   l_ActualQPA    LIKE bmb_file.bmb06, #No.FUN-680121 DECIMAL(11,7)
   l_tmp12        LIKE sfa_file.sfa12,    #發料單位
   l_tmp13        LIKE sfa_file.sfa13,    #發料/庫存單位換算率
   l_unaloc       LIKE sfa_file.sfa25, #unallocated quantity
   l_uuc          LIKE sfa_file.sfa25, #unallocated quantity
   l_cmd          LIKE type_file.chr1000#No.FUN-680121 VARCHAR(1200)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
   LET p_level = p_level + 1
   LET level = level + 1
   LET arrno = 500
   LET l_cmd=
       "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
       "bmb15,bmb16,bmb06/bmb07,bmb08,bmb09,bmb18,ima08,ima37,ima25, ",
       " ima86,ima86_fac,bma01,0 ",
       " FROM bmb_file,OUTER ima_file,OUTER bma_file",
       " WHERE bmb01='", p_key,"' ",
       "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
       "   AND bmb02>?",
       "   AND  bma_file.bma01 = bmb_file.bmb03   AND  ima_file.ima01 = bmb_file.bmb03  ",
       "   AND (bmb04 <='",g_date,"' OR bmb04 IS NULL) ",
       "   AND (bmb05 >'",g_date,"' OR bmb05 IS NULL)",
       "  ORDER BY bmb02"
   PREPARE alloc_ppp FROM l_cmd
   IF SQLCA.sqlcode THEN
      CALL cl_err('P1:',SQLCA.sqlcode,1)
      RETURN 0
   END IF
   DECLARE alloc_cur CURSOR FOR alloc_ppp
 
   #put BOM data into buffer
   LET b_seq=0
   WHILE TRUE
      LET l_ac = 1
      FOREACH alloc_cur USING b_seq INTO sr[l_ac].*
         MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
         CALL ui.Interface.refresh()
         #若換算率有問題, 則設為1
         IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
            LET sr[l_ac].bmb10_fac=1.0
         END IF
         IF sr[l_ac].ima08 = 'X' THEN
            LET sr[l_ac].level = level -1
         ELSE
            LET sr[l_ac].level = level
         END IF
         IF sr[l_ac].bmb16 IS NULL THEN    #若未定義, 則給予'正常'
            LET sr[l_ac].bmb16='0'
         END IF
         #FUN-8B0035--BEGIN-- 
         LET l_ima910[l_ac]=''
         SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
         IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
         #FUN-8B0035--END-- 
         LET l_ac = l_ac + 1    #check limitation
         IF l_ac > arrno THEN EXIT FOREACH END IF
      END FOREACH
      LET l_x=l_ac-1
      #insert into allocation file
      FOR l_i = 1 TO l_x
         #operation sequence number
         IF sr[l_i].bmb09 IS NOT NULL AND g_opseq IS NULL THEN
            LET g_level=p_level
            LET g_opseq=sr[l_i].bmb09
            LET g_offset=sr[l_i].bmb18
         END IF
         #無製程序號
         IF g_opseq IS NULL THEN LET g_opseq=g_minopseq END IF
         IF g_offset IS NULL THEN LET g_offset=0 END IF
         LET g_SOUCode='0'
         IF sr[l_i].bmb16='2' OR sr[l_i].bmb16 = '7' THEN    #FUN-A40058 add '7'
            LET g_SOUCode=g_sma.sma67
         ELSE
            IF sr[l_i].bmb16='1' THEN        #UTE
               LET g_SOUCode=g_sma.sma66    #保留安全庫存, 以備不時之需
            END IF
         END IF
         #inflate yield
         IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF
         #Actual QPA
         LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
         LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100
         LET l_total2=l_total
         LET l_tmp07=0
         LET l_tmp11='N'
         IF sr[l_i].ima08='R' THEN #routable part
            LET l_tmp07=l_total
            LET l_tmp11='R'
         ELSE
            IF sr[l_i].bmb15='Y' THEN #comsumable
               LET l_tmp11='E'
            ELSE
               IF sr[l_i].ima08 MATCHES '[UV]' THEN
                  LET l_tmp11=sr[l_i].ima08
               END IF
            END IF #consumable
         END IF
         IF g_sma.sma78='1' THEN        #使用庫存單位
            LET sr[l_i].bmb10=sr[l_i].ima25
            LET l_total=l_total*sr[l_i].bmb10_fac    #原發
            LET l_total2=l_total2*sr[l_i].bmb10_fac    #應發
            LET sr[l_i].bmb10_fac=1.0
         END IF
         IF sr[l_i].ima08 != 'M' AND sr[l_i].ima08 != 'X'  THEN
            LET g_ccc=g_ccc+1
            LET l_uuc=0
            INSERT INTO tmp_file
             VALUES(g_wo,sr[l_i].bmb03,l_total,l_total2, 0,l_tmp07,
                    g_opseq,g_offset,l_tmp11,sr[l_i].bmb10,
                    sr[l_i].bmb10_fac,sr[l_i].bmb10_fac2,l_ActualQPA,
                    l_uuc,sr[l_i].bmb16)
            IF SQLCA.SQLCODE THEN    #Duplicate
              #IF SQLCA.SQLCODE=-239 THEN #CHI-790021
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
                  #因為相同的料件可能有不同的發料單位, 故宜換算之
                  SELECT tmp13 INTO l_tmp13
                    FROM tmp_file
                    WHERE tmp01=g_wo AND tmp03=sr[l_i].bmb03
                        AND tmp08=g_opseq
                  LET l_tmp13=sr[l_i].bmb10_fac/l_tmp13
                  LET l_total=l_total*l_tmp13
                  LET l_total2=l_total2*l_tmp13
                  UPDATE tmp_file
                    SET tmp04=tmp04+l_total,
                        tmp05=tmp05+l_total2
                    WHERE tmp01=g_wo AND tmp03=sr[l_i].bmb03
                        AND tmp08=g_opseq AND tmp12=sr[l_i].bmb10
               ELSE
#                 CALL cl_err('Insert fail:ckp#05',SQLCA.sqlcode,1)   #No.FUN-660128
                  CALL cl_err3("upd","tmp_file","","",SQLCA.sqlcode,"","Insert fail:ckp#05",1)    #No.FUN-660128
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                  EXIT PROGRAM
               END IF
            END IF
         END IF
         IF sr[l_i].ima08 = 'M' AND  sr[l_i].level = g_lvl  THEN
            LET g_ccc=g_ccc+1
            LET l_uuc=0
            INSERT INTO tmp_file
            VALUES(g_wo,sr[l_i].bmb03,l_total,
                  l_total2, 0,l_tmp07, g_opseq,g_offset,
                  l_tmp11,sr[l_i].bmb10,sr[l_i].bmb10_fac,
                  sr[l_i].bmb10_fac2,l_ActualQPA,l_uuc,sr[l_i].bmb16)
            IF SQLCA.SQLCODE THEN    #Duplicate
              #IF SQLCA.SQLCODE=-239 THEN #CHI-790021
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
                  #因為相同的料件可能有不同的發料單位, 故宜換算之
                  SELECT tmp13 INTO l_tmp13
                    FROM tmp_file
                    WHERE tmp01=g_wo AND tmp03=sr[l_i].bmb03
                        AND tmp08=g_opseq
                  LET l_tmp13=sr[l_i].bmb10_fac/l_tmp13
                  LET l_total=l_total*l_tmp13
                  LET l_total2=l_total2*l_tmp13
                  UPDATE tmp_file
                    SET tmp04=tmp04+l_total,
                        tmp05=tmp05+l_total2
                  WHERE tmp01=g_wo AND tmp03=sr[l_i].bmb03
                    AND tmp08=g_opseq AND tmp12=sr[l_i].bmb10
               ELSE
#                 CALL cl_err('Insert fail:ckp#06',SQLCA.sqlcode,1)   #No.FUN-660128
                  CALL cl_err3("upd","tmp_file","","",SQLCA.sqlcode,"","Insert fail:ckp#06",1)    #No.FUN-660128
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                  EXIT PROGRAM
               END IF
            END IF
         END IF
         IF sr[l_i].ima08 ='M' AND  sr[l_i].level < g_lvl  THEN
            IF sr[l_i].bma01 IS NOT NULL THEN
              #CALL r500_alloc_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112 #TQC-7B0143#FUN-8B0035
               CALL r500_alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0035
                    p_total*sr[l_i].bmb06,l_ActualQPA,l_pt)
            ELSE
               LET g_ccc=g_ccc+1
               LET l_uuc=0
               INSERT INTO tmp_file
               VALUES(g_wo,sr[l_i].bmb03,l_total,l_total2, 0,l_tmp07,
                      g_opseq,g_offset,l_tmp11,sr[l_i].bmb10,
                      sr[l_i].bmb10_fac,sr[l_i].bmb10_fac2,l_ActualQPA,
                      l_uuc,sr[l_i].bmb16)
               IF SQLCA.SQLCODE THEN    #Duplicate
                 #IF SQLCA.SQLCODE=-239 THEN #CHI-790021
                  IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
                     #因為相同的料件可能有不同的發料單位, 故宜換算之
                     SELECT tmp13 INTO l_tmp13
                       FROM tmp_file
                       WHERE tmp01=g_wo AND tmp03=sr[l_i].bmb03
                           AND tmp08=g_opseq
                     LET l_tmp13=sr[l_i].bmb10_fac/l_tmp13
                     LET l_total=l_total*l_tmp13
                     LET l_total2=l_total2*l_tmp13
                     UPDATE tmp_file
                       SET tmp04=tmp04+l_total,
                           tmp05=tmp05+l_total2
                     WHERE tmp01=g_wo AND tmp03=sr[l_i].bmb03
                       AND tmp08=g_opseq AND tmp12=sr[l_i].bmb10
                  ELSE
#                    CALL cl_err('Insert fail:ckp#07',SQLCA.sqlcode,1)   #No.FUN-660128
                     CALL cl_err3("upd","tmp_file","","",SQLCA.sqlcode,"","Insert fail:ckp#07",1)    #No.FUN-660128
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
                     EXIT PROGRAM
                  END IF
               END IF
            END IF
         END IF
         IF sr[l_i].ima08='X' THEN
            IF g_btflg='N' THEN #phantom
               CONTINUE FOR #do'nt blow through
            ELSE
               IF sr[l_i].ima37='1' AND g_mps='N' THEN
                  CONTINUE FOR #do'nt blow through
               ELSE
                  IF sr[l_i].bma01 IS NOT NULL THEN
                     LET level = level -1
                    #CALL r500_alloc_bom(p_level,sr[l_i].bmb03,' ',  #FUN-550112 #TQC-7B0143#FUN-8B0035
                     CALL r500_alloc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],  #FUN-8B0035
                     p_total*sr[l_i].bmb06,l_ActualQPA,l_pt)
                  END IF
               END IF
            END IF
         END IF
         IF g_level=p_level THEN
            LET g_opseq=''
            LET g_offset=''
         END IF
      END FOR
      IF l_x < arrno OR l_ac=1 THEN #nothing left
         EXIT WHILE
      ELSE
         LET b_seq = sr[l_x].bmb02
      END IF
   END WHILE
   IF p_level >1 THEN RETURN END IF
   DECLARE cr_cr2 CURSOR FOR
    SELECT tmp_file.*,
#      ima08,ima262,ima27,ima37,ima108,ima64,ima641,ima25     #NO.FUN-A20044
       ima08,0,ima27,ima37,ima108,ima64,ima641,ima25          #NO.FUN-A20044
   FROM tmp_file,OUTER ima_file
   WHERE tmp01=g_wo AND  ima_file.ima01 = tmp_file.tmp03 
   FOREACH cr_cr2 INTO g_tmp.*,
#     l_ima08,l_ima26,l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom           #NO.FUN-A20044
      l_ima08,l_avl_stk,l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom  #NO.FUN-A20044 
      IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
      MESSAGE '--> ',g_tmp.tmp03,g_tmp.tmp08
      CALL ui.Interface.refresh()
      CALL s_getstock(g_tmp.tmp03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
      LET l_avl_stk = l_n3                             #NO.FUN-A20044  
      IF l_ima108='Y' THEN ELSE LET l_ima64=0 LET l_ima641=0 END IF
      IF l_ima641 != 0 AND g_tmp.tmp05 < l_ima641 THEN
         LET g_tmp.tmp05=l_ima641
      END IF
      IF l_ima64!=0 THEN
         LET l_double=(g_tmp.tmp05/l_ima64)+ 0.999999999
         LET g_tmp.tmp05=l_double*l_ima64
      END IF
      LET l_qty=g_tmp.tmp05*g_tmp.tmp13
      LET l_total2=l_qty
#     LET l_bal=l_ima26-l_qty             #NO.FUN-A20044
      LET l_bal=l_avl_stk - l_qty  #NO.FUN-A20044 
      IF g_SOUCode='1' THEN    #完全取/替代
         IF l_bal <0 THEN    #若庫存量不敷使用, 則另找來源
            LET l_bal=l_qty*-1
            LET l_qty=0        #備料量為零
            IF g_tmp.tmp26='1' THEN    #完全UTE
               LET l_total2=0        #應發數量為零
            END IF
         END IF
      END IF
#     IF l_bal < 0 AND l_qty>0 THEN LET l_qty=l_ima26 END IF           #NO.FUN-A20044
      IF l_bal < 0 AND l_qty>0 THEN LET l_qty=l_avl_stk END IF         #NO.FUN-A20044
      IF l_qty>0 THEN
         IF g_tmp.tmp26='1' THEN    #部份UTE, 應發數量(可用)
            LET l_total2=l_qty/g_tmp.tmp13
         END IF
      END IF
      LET l_unaloc=0
      IF l_bal < 0 THEN
         IF g_tmp.tmp26='0' THEN #normal
            LET l_unaloc=l_bal*-1 #adjust to plus
         ELSE
            CALL alloc_sou(g_tmp.tmp03,g_tmp.tmp26,
             g_tmp.tmp09,g_tmp.tmp161,g_tmp.tmp12,
             g_tmp.tmp13,g_tmp.tmp15,l_bal*-1,
             g_tmp.tmp11)
            RETURNING l_unaloc
            IF l_unaloc THEN    #SUB時的應發數量(UTE時為0)
               LET l_total2=l_unaloc/g_tmp.tmp13
            END IF
         END IF
      END IF
      IF g_tmp.tmp11='R' THEN LET g_tmp.tmp07=l_total2 END IF
      UPDATE tmp_file SET tmp04=g_tmp.tmp04,
            stmp5=l_total2, stmp7=g_tmp.tmp07,
            stmp5=l_unaloc, stmp6='N'
      WHERE  tmp01 = g_tmp.tmp01 and tmp03 = g_tmp.tmp03
 and tmp08 =g_tmp.tmp08 and tmp12 = g_tmp.tmp12
   END FOREACH
END FUNCTION
 
FUNCTION alloc_sou(p_part,p_sou,p_offset,p_qpa,
    p_isuom,p_i2s,p_i2c,p_needqty,p_consumable)
DEFINE
   p_part           LIKE ima_file.ima01,
   p_sou            LIKE bmd_file.bmd02,
   p_offset         LIKE bmb_file.bmb18,
   p_qpa            LIKE bmb_file.bmb06,
   p_isuom          LIKE bmb_file.bmb10,
   p_i2s            LIKE bmb_file.bmb10_fac,
   p_i2c            LIKE bmb_file.bmb10_fac2,
#  p_needqty        LIKE ima_file.ima26,
   p_needqty        LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
   p_consumable     LIKE bmb_file.bmb15,
   l_bmd03          LIKE bmd_file.bmd03,
   l_bmd04          LIKE bmd_file.bmd04,
   l_bmd07          LIKE bmd_file.bmd07,
#  l_qoh            LIKE ima_file.ima26,
   l_qoh            LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
   l_sc             LIKE ima_file.ima08,
#  l_qty,l_sqty     LIKE ima_file.ima26,
   l_qty,l_sqty     LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044 
   l_tmp26          LIKE sfa_file.sfa26,
   l_tmp11          LIKE sfa_file.sfa11,
   l_tmp13          LIKE sfa_file.sfa13,
   l_first          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
#  ss_qty,tt_qty    LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
   ss_qty,tt_qty    LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
   l_unaloc,l_uqty  LIKE sfa_file.sfa25
 
   LET l_unaloc=p_needqty #unallocated qty
 
   DECLARE sou_cur CURSOR FOR
#  SELECT bmd03,bmd04,bmd07,ima26,ima08  #NO.FUN-A20044
   SELECT bmd03,bmd04,bmd07,0,ima08      #NO.FUN-A20044
   FROM bmd_file,OUTER ima_file
   WHERE  ima_file.ima01 = bmd_file.bmd04  AND bmd01=p_part
     AND bmd02=p_sou AND (bmd05<=g_date OR bmd05 IS NULL)
     AND (bmd06>=g_date OR bmd06 IS NULL)
     AND bmdacti = 'Y'                                           #CHI-910021
   ORDER BY 1
 
   IF p_sou='1' THEN
      LET l_tmp26='S'
   ELSE
      LET l_tmp26='U'
   END IF
   FOREACH sou_cur INTO l_bmd03,l_bmd04,l_bmd07,l_qoh,l_sc
      IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
      IF l_bmd07 IS NULL OR l_bmd07 <=0 THEN LET l_bmd07=1 END IF
      IF l_qoh <=0 OR l_qoh IS NULL THEN CONTINUE FOREACH END IF
      LET l_unaloc=l_unaloc*l_bmd07
      LET p_qpa=p_qpa*l_bmd07
      IF l_tmp26='U' THEN LET l_sqty=l_unaloc END IF    #UTE時的應發
      #使用完全取/替代時, 若該料件的現有庫存量不足使用, 則不考慮之
      IF g_SOUCode='1' AND l_qoh<l_unaloc THEN
         IF l_tmp26='S' THEN        #完全替代, 量不足, 不用
            CONTINUE FOREACH
         END IF
      END IF
      #在UTE時, 若完全取代, 並量不足時, 則需產生一筆資料
      #在下列情形才計算應發數量: 1.部份取/替代時
      # 2.完全取/替代時, 並量充足時
      LET l_qty=0
      IF g_SOUCode!='1' OR l_tmp26!='U' OR l_qoh>=l_unaloc THEN
         IF l_qoh < l_unaloc THEN
            LET l_qty=l_qoh
         ELSE
            LET l_qty= l_unaloc
         END IF
      END IF
      IF l_tmp26='S' THEN LET l_sqty=l_qty END IF        #SUB時的應發
      LET l_unaloc=l_unaloc-l_qty
      LET l_uqty=0            #SUB時的未備皆為零
      IF l_tmp26='U' THEN
         LET l_uqty=l_unaloc
         LET l_unaloc=0        #UTE 未備料量完全由UTE承擔
      END IF
      LET l_tmp11='N'
      IF p_consumable='E' THEN #comsumable
         LET l_tmp11='E'
      ELSE
         IF l_sc MATCHES '[UVR]' THEN
            LET l_tmp11=l_sc
         END IF
      END IF
      LET ss_qty=l_sqty/p_i2s
      LET tt_qty=l_uqty/p_i2s
      SELECT ima86 INTO g_ima86 FROM ima_file
      WHERE ima01 = l_bmb04
      INSERT INTO tmp_file
       VALUES(g_wo,l_bmd04,0, ss_qty,0,0, g_opseq,p_offset,
            l_tmp11,p_isuom,p_i2s,p_i2c,p_qpa,tt_qty,l_tmp26)
      IF SQLCA.SQLCODE THEN
        #IF SQLCA.SQLCODE=-239 THEN #CHI-790021
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
            #因為相同的料件可能有不同的發料單位, 故宜換算之
            SELECT tmp13 INTO l_tmp13 FROM tmp_file
            WHERE tmp01=g_wo AND tmp03=l_bmd04
              AND tmp08=g_opseq
            LET l_tmp13=p_i2s/l_tmp13
            LET ss_qty=ss_qty*l_tmp13
            LET tt_qty=tt_qty*l_tmp13
            UPDATE tmp_file SET tmp05=tmp05+ss_qty,
                                tmp25=tmp25+tt_qty
            WHERE tmp01=g_wo AND tmp03=l_bmd04
              AND tmp08=g_opseq
         ELSE
#           CALL cl_err('Insert fail:ckp#08',SQLCA.sqlcode,1)   #No.FUN-660128
            CALL cl_err3("upd","tmp_file","","",SQLCA.sqlcode,"","Insert fail:ckp#08",1)    #No.FUN-660128
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
            EXIT PROGRAM
         END IF
      END IF
      LET g_ccc=g_ccc+1
      IF l_unaloc = 0 THEN EXIT FOREACH END IF
   END FOREACH
   RETURN l_unaloc
END FUNCTION
#Patch....NO.TQC-610037 <> #
#TQC-A60097

