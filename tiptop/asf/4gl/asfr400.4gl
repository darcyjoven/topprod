# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr400.4gl
# Descriptions...: 在製工單管制表
# Date & Author..: 00/06/02 By Kammy
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5A0054 05/10/18 By pengu  1.若是委外工單和委外重工工單,需排除委外收貨量,
                                           #          否則會和委外入庫量重復到
                                           #        2.重工或委外重工工單,發料和生產料號相同時,
                                           #          顯示的時候就會重復,並且wip量也會重復計算
# Modify.........: No.TQC-5B0111 05/11/12 By Carol 單頭品名規格欄位放大,位置調整
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-650118 06/06/28 By Sarah 增加列印在製盤盈(損)量(sfa064) 
# Modify.........: No.TQC-670055 06/07/14 By pengu 1.當料是替代料時，無法正確的顯示入庫量
# Modify.........: No.MOD-670011 06/07/14 By Clarie s_wipqty 多傳一個是否為重工工單且發料料號=完工料號的參數
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.FUN-750101 07/06/20 By mike 報表格式修改為crystal report
# Modify.........: No.FUN-7B0054 08/05/13 By jamie "工單單號"增加開窗
# Modify.........: No.MOD-8B0140 08/11/14 By Sarah 重工工單若發的料非生產料件時發料資料抓取錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A60027 10/06/12 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A70016 10/07/02 By Sarah 當不同元件替代成同一個料時,在製量的計算有問題,需重算
# Modify.........: No:MOD-A70221 10/08/18 By Carrier asfr400的明细资料和s_wipqty的计算量不一致
# Modify.........: No:MOD-AB0190 10/11/23 By sabrina temp table欄位型態錯誤
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.MOD-C60174 12/06/21 By bart 單身數量應以全部數量計算
# Modify.........: No.TQC-D40103 13/04/27 By zhangweib 1.程序中加上CALL cl_show_help()函數 2.修改畫面檔,增加欄位長度

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
#             wc      VARCHAR(600),        # Where condition   #TQAC-630166
              wc      STRING,           # Where condition   #TQAC-630166
              more    LIKE type_file.chr1        #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件?
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_sql           STRING                  #No.FUN-750101 
DEFINE   g_str           STRING                  #No.FUN-750101
DEFINE   l_table         STRING                  #No.FUN-750101
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                    # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
#No.FUN-750101 --begin --
   LET g_sql="tlf01.tlf_file.tlf01,",
             "tlf905.tlf_file.tlf905,",
             "tlf907.tlf_file.tlf907,",
             "tlf62.tlf_file.tlf62,",
             "tlf10.tlf_file.tlf10,",
             "tlf13.tlf_file.tlf13,",
             "sfb01.sfb_file.sfb01,",
             "sfb02.sfb_file.sfb02,",
             "sfb05.sfb_file.sfb05,",
             "ima55.ima_file.ima55,",
             "sfb09.sfb_file.sfb09,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "sfa03.sfa_file.sfa03,",
             "sfa08.sfa_file.sfa08,",
             "sfa12.sfa_file.sfa12,",
             "sfa27.sfa_file.sfa27,",
             "sfa26.sfa_file.sfa26,",
             "sfa28.sfa_file.sfa28,",
             "sfa161.sfa_file.sfa161,",
             "sfa064.sfa_file.sfa064,",
             "sfa012.sfa_file.sfa012,",
             "sfa013.sfa_file.sfa013,",
             "l_qty.tlf_file.tlf10,",
             "l_wip.tlf_file.tlf10,",
             "l_ima02.ima_file.ima02,",
             "l_ima021.ima_file.ima021"
   LET l_table=cl_prt_temptable('asfr400',g_sql)
   IF l_table=-1 THEN EXIT PROGRAM END IF
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             "  VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err("insert_prep:",status,1)  EXIT PROGRAM 
   END IF
#No.FUN-750101  --end--
  #str MOD-A70016 add
   LET g_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
               "   SET l_wip = ?",
               " WHERE tlf01 = ? AND sfb01 = ? AND sfa03 = ? AND sfa27 = ?"
   PREPARE update_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err("update_prep:",status,1)  EXIT PROGRAM 
   END IF
  #end MOD-A70016 add
 
   LET g_pdate = ARG_VAL(1)           # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610080-begin
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #LET tm.more  = ARG_VAL(8)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(9)
   #LET g_rep_clas = ARG_VAL(10)
   #LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   ##No.FUN-570264 ---end---
   #TQC-610080-begin
#----------------------No.TQC-670055 mark
#  DROP TABLE tmp
#  CREATE TEMP TABLE tmp
#  (a         VARCHAR(40),   #FUN-560011
#   c         dec(13,3));
#----------------------No.TQC-670055 end
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL asfr400_tm()        # Input print condition
      ELSE CALL asfr400()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr400_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   LET p_row = 6 LET p_col = 20
   OPEN WINDOW asfr400_w AT p_row,p_col WITH FORM "asf/42f/asfr400"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies= '1'
   WHILE TRUE
#----------------No.TQC-670055 add
   DROP TABLE tmp
 #No.FUN-680121-BEGIN
  CREATE TEMP TABLE tmp(
    a         LIKE sfa_file.sfa01,
    b         LIKE sfb_file.sfb05,     #MOD-AB0190 modify
    c         LIKE sfb_file.sfb08);    #MOD-AB0190 modify
 #No.FUN-680121-END 
 
   DROP TABLE sub_tmp
 #No.FUN-680121-BEGIN
   CREATE TEMP TABLE sub_tmp(
    a         LIKE sfa_file.sfa01,
    b         LIKE sfb_file.sfb05,     #MOD-AB0190 modify
    c         LIKE sfb_file.sfb08);    #MOD-AB0190 modify
 #No.FUN-680121-END
#------------No.TQC-670055 end
     CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb81,sfb15
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
 
          #FUN-7B0054---add---str---
           IF INFIELD(sfb01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_sfb3"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb01
              NEXT FIELD sfb01
           END IF
          #FUN-7B0054---add---end---
 
           IF INFIELD(sfb05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
           END IF
 
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
         ON ACTION CONTROLG               #No.FUN-750101                                                                                            
               CALL cl_cmdask()           #No.FUN-750101


        #No.TQC-D40103 ---add--- str
         ON ACTION help
            CALL cl_show_help()
        #No.TQC-D40103 ---add--- end
 
     END CONSTRUCT
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
     IF tm.wc=" 1=1 " THEN
        CALL cl_err(' ','9046',0)
        CONTINUE WHILE
     END IF
     DISPLAY BY NAME tm.more      # Condition
     INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD more
           IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
              THEN NEXT FIELD more
           END IF
           IF tm.more = "Y" THEN
                   CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
               CALL cl_cmdask()    # Command execution
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
        EXIT WHILE
     END IF
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asfr400'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr400','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'",
                          #" '",tm.more CLIPPED,"'",            #TQC-610080
                           " '",g_rep_user CLIPPED,"'",         #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",         #No.FUN-570264
                           " '",g_template CLIPPED,"'",         #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
           CALL cl_cmdat('asfr400',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asfr400_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asfr400()
     ERROR ""
   END WHILE
   CLOSE WINDOW asfr400_w
END FUNCTION
 
FUNCTION asfr400()
   DEFINE l_name     LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8         #No.FUN-6A0090
#         l_sql      LIKE type_file.chr1000,       # RDSQL STATEMENT    #TQC-630166        #No.FUN-680121 VARCHAR(1000)
          l_sql      STRING,                       # RDSQL STATEMENT    #TQC-630166
          l_chr      LIKE type_file.chr1,          # No.TQC-5A0054 add        #No.FUN-680121 VARCHAR(1)
          l_qty      LIKE tlf_file.tlf10,
          l_tmp      LIKE tlf_file.tlf10,
          l_tmp1     LIKE tlf_file.tlf10,          #No.TQC-670055 add
          l_wip      LIKE tlf_file.tlf10,
          l_out      LIKE tlf_file.tlf10,
          l_wip_c    LIKE tlf_file.tlf10,
          l_wip_1    LIKE tlf_file.tlf10,        #MOD-A70016 add
          l_wip_2    LIKE tlf_file.tlf10,        #MOD-A70016 add
          l_wip_sub  LIKE tlf_file.tlf10,        #MOD-A70016 add
          l_tmp_qty  LIKE tlf_file.tlf10,
          l_tmp_wip  LIKE tlf_file.tlf10,
          l_s_wip    LIKE tlf_file.tlf10,
          l_s_wip_c  LIKE tlf_file.tlf10,
          l_sfa03    LIKE sfa_file.sfa03,
          l_sfa28    LIKE sfa_file.sfa28,
          sr  RECORD
              sfb01  LIKE sfb_file.sfb01,
              sfb02  LIKE sfb_file.sfb02,        #No.TQC-5A0054 add
              sfb05  LIKE sfb_file.sfb05,
              ima55  LIKE ima_file.ima55,
              sfb09  LIKE sfb_file.sfb09,
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,
              sfa03  LIKE sfa_file.sfa03,
              sfa08  LIKE sfa_file.sfa08,
              sfa12  LIKE sfa_file.sfa12,
              sfa27  LIKE sfa_file.sfa27,
              sfa26  LIKE sfa_file.sfa26,
              sfa28  LIKE sfa_file.sfa28,
              sfa161 LIKE sfa_file.sfa161,
              sfa064 LIKE sfa_file.sfa064,         #FUN-650118 add
              sfa012 LIKE sfa_file.sfa012,         #FUN-A60027 add
              sfa013 LIKE sfa_file.sfa013          #FUN-A60027 add
              END RECORD,
          sr1 RECORD
              tlf01  LIKE tlf_file.tlf01,         #料件編號
              tlf905 LIKE tlf_file.tlf905,        #單據編號
              tlf907 LIKE tlf_file.tlf907,        #入出庫(+-)
              tlf62  LIKE tlf_file.tlf62,         #工單編號
              tlf10  LIKE tlf_file.tlf10,         #異動數量
              tlf13  LIKE tlf_file.tlf13          #異動命令
              END RECORD,
          l_tlf906   LIKE tlf_file.tlf906,       #單據項次   #MOD-A70016 add
          l_cnt      LIKE type_file.num5,        #MOD-A70016 add
          l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021 
   DEFINE l_tlf036   LIKE tlf_file.tlf036        #No.MOD-A70221

#No.FUN-750101  --begin--
     LET g_str=''
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
#No.FUN-750101 --end--
     SELECT zo02 INTO g_company FROM zo_file
      WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
    #str MOD-A70016 add
     LET g_sql = "SELECT SUM(l_qty) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE sfb01 = ? AND tlf01=? AND sfa03=?"
     PREPARE asfr400_pre_wip1 FROM g_sql
     LET g_sql = "SELECT SUM(l_qty) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " WHERE sfb01 = ? AND tlf01!=? AND sfa03=?"
     PREPARE asfr400_pre_wip2 FROM g_sql
    #end MOD-A70016 add

     LET l_sql = " SELECT tlf01,tlf905,tlf907,tlf62,tlf10,tlf13,tlf906,",   #MOD-A70016 add tlf906
                 "        tlf036   ",                                       #No.MOD-A70221 add tlf036
                 "   FROM tlf_file ",
                 "  WHERE tlf01 = ? ",
                 "    AND tlf62 = ? ",
     #s_wipqty中有下阶料报废,tlf907=0,故此处也要把报废的信息show出来
     #           "    AND tlf907 != '0' ",    #No.TQC-5A0054 add   #No.MOD-A70221 mark
                 "   ORDER BY tlf907 "
     PREPARE tlf_pre FROM l_sql
     DECLARE tlf_cs CURSOR FOR tlf_pre
     #MOD-C60174---begin
     LET l_sql = " SELECT DISTINCT '',tlf905,tlf907,tlf62,'',tlf13,tlf036",                                     
                 "   FROM tlf_file ",
                 "  WHERE (tlf01 = ? ",
                 "  OR EXISTS (SELECT 1 FROM bmm_file WHERE bmm01 = ? AND bmm03 = tlf01))",
                 "    AND tlf62 = ? ",
                 "   ORDER BY tlf907 "
     PREPARE tlf_pre1 FROM l_sql
     DECLARE tlf_cs1 CURSOR FOR tlf_pre1
     #MOD-C60174---end
     LET l_sql = " SELECT sfb01,sfb02,sfb05,ima55,sfb09,ima02,ima021,sfa03,sfa08,sfa12,",   #No.TQC-5A0054 add
                 " sfa27,sfa26,sfa28,sfa161,sfa064,sfa012,sfa013 ",   #FUN-650118 add sfa064 #FUN-A60027 add sfa012,sfa013
                 "   FROM sfb_file,sfa_file ,OUTER ima_file ",
                 "  WHERE sfa01 = sfb01 ",
                 "    AND  ima_file.ima01 = sfb_file.sfb05  ",
                 "    AND sfb04 IN ('2','3','4','5','6','7') ",
                 "    AND ",tm.wc CLIPPED,
                 "   ORDER BY sfb01,sfa26 "      #No.TQC-670055 add
 
     PREPARE asfr400_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
     END IF
     DECLARE asfr400_curs1 CURSOR FOR asfr400_prepare1
 
     #CALL cl_outnam('asfr400') RETURNING l_name    #No.FUN-750101 
     #START REPORT asfr400_rep TO l_name            #No.FUN-750101 
 
     #LET g_pageno = 0                              #No.FUN-750101 
     FOREACH asfr400_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0  THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
     
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file             #No.FUN-750101                                                            
        WHERE ima01 = sr.sfa03                                             #No.FUN-750101                                                          
       IF SQLCA.sqlcode THEN LET l_ima02 = ' ' END IF                      #No.FUN-750101                                                          
       IF SQLCA.sqlcode THEN LET l_ima021= ' ' END IF                      #No.FUN-750101
     
       LET l_wip = 0     LET l_wip_c = 0
 
       LET l_tmp_wip = 0      #No.TQC-670055 add
       LET l_s_wip = 0 LET l_s_wip_c = 0
#------------------------------No.TQC-670055 modify ----------------------------
      #CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161) RETURNING l_wip_c #在製量  #MOD-670011 mark
       IF sr.sfa26 MATCHES '[SUTZ]' THEN  #取替代   #MODNO:7111 add 'T'   #FUN-A20037 add 'Z'
          SELECT sfa161 INTO sr.sfa161 FROM sfa_file
           WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa27
             AND sfa08 = sr.sfa08 AND sfa12 = sr.sfa12
             AND sfa012 = sr.sfa012 AND sfa013 = sr.sfa013  #FUN-A60027 add
 
          SELECT sfa28 INTO l_sfa28 FROM sfa_file 
             WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa03
             AND sfa08 = sr.sfa08 AND sfa12 = sr.sfa12
             AND sfa27 = sr.sfa27
             AND sfa012 = sr.sfa012 AND sfa013 = sr.sfa013  #FUN-A60027 add
          LET sr.sfa161 = sr.sfa161 * l_sfa28
       #CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161) RETURNING l_wip_c #在製量     #MOD-670011 mark
        CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161,'',sr.sfa27) RETURNING l_wip_c #在製量  #MOD-670011 add  #MOD-A70016 add sr.sfa27
 
          DECLARE sfa_su CURSOR FOR
           SELECT sfa03 FROM sfa_file
            WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa03
              AND sfa27 = sr.sfa27   #MOD-A70016 add
              AND sfa26 IN ('S','U','T','Z')           #MODNO:7111 add 'T' #FUN-A20037 add 'Z'
              AND sfa012 = sr.sfa012 AND sfa013 = sr.sfa013  #FUN-A60027 add
          FOREACH sfa_su INTO l_sfa03
           #CALL s_wipqty(sr.sfb01,l_sfa03,sr.sfa161)     #MOD-670011 mark
            CALL s_wipqty(sr.sfb01,l_sfa03,sr.sfa161,'',sr.sfa27)  #MOD-670011 modify  #MOD-A70016 add sr.sfa27
                 RETURNING l_s_wip_c   #在製量
            LET l_s_wip = l_s_wip + l_s_wip_c
          END FOREACH 
 
          SELECT SUM(c) INTO l_tmp_wip FROM sub_tmp 
                 WHERE a = sr.sfb01
                 AND b = sr.sfa27
          LET l_tmp_wip = l_tmp_wip * sr.sfa161
          IF (l_tmp_wip + l_wip_c) < 0 THEN
             LET l_wip = l_s_wip + l_tmp_wip + l_wip_c
          ELSE
             LET l_wip = l_s_wip
          END IF
          INSERT INTO sub_tmp 
            VALUES(sr.sfb01,sr.sfa27,(l_s_wip/sr.sfa161))
       ELSE
          LET l_chr = 'N'
          CASE sr.sfb02
               WHEN '5'   LET l_chr ='N'
               WHEN '8'   LET l_chr ='N'
               WHEN '11'  LET l_chr ='N'
               OTHERWISE  LET l_chr ='Y'
          END CASE
 
          IF l_chr ='Y' OR (l_chr ='N' AND sr.sfa27 !=sr.sfb05) THEN
            #MOD-670011-begin
            #CALL s_wipqty(sr.sfb01,sr.sfa27,sr.sfa161) RETURNING l_wip  #在製量
             CALL s_wipqty(sr.sfb01,sr.sfa27,sr.sfa161,'',sr.sfa27) RETURNING l_wip  #在製量  #MOD-A70016 add sr.sfa27
             CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161,'Y',sr.sfa27) RETURNING l_wip_c #在製量  #MOD-A70016 add sr.sfa27
          ELSE
             CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161,'',sr.sfa27) RETURNING l_wip_c #在製量  #MOD-A70016 add sr.sfa27
            #MOD-670011-end
          END IF
          INSERT INTO sub_tmp 
            VALUES(sr.sfb01,sr.sfa27,(l_wip/sr.sfa161))
          LET l_wip = l_wip + l_wip_c
       END IF
 
#---------------No.TQC-670055 mark
#---No.TQC-5A0054 add 判斷若sfb02='5,8,11'且sfb05=sfa27時不計算sfa27的wip量
#      LET l_chr = 'N'
#      CASE sr.sfb02
#           WHEN '5'   LET l_chr ='N'
#           WHEN '8'   LET l_chr ='N'
#           WHEN '11'  LET l_chr ='N'
#           OTHERWISE  LET l_chr ='Y'
#      END CASE
 
#      IF l_chr ='Y' OR (l_chr ='N' AND sr.sfa27 !=sr.sfb05) THEN
#         CALL s_wipqty(sr.sfb01,sr.sfa27,sr.sfa161) RETURNING l_wip   #在製量
#      END IF
 
#      CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161) RETURNING l_wip_c #在製量
 
#      CALL s_wipqty(sr.sfb01,sr.sfa27,sr.sfa161) RETURNING l_wip   #在製量
 
#      CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161) RETURNING l_wip_c #在製量
#------end
#---------------No.TQC-670055 end
       IF l_wip <= 0 THEN CONTINUE FOREACH END IF
#------------------------------No.TQC-670055 end ----------------------------
 
       LET l_out = 0
       FOREACH tlf_cs USING sr.sfa03,sr.sfb01 INTO sr1.*,l_tlf906,  #MOD-A70016 add l_tlf906
                                                   l_tlf036         #No.MOD-A70221 add tlf036
          IF SQLCA.sqlcode != 0  THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
          END IF
         #str MOD-A70016 add
         #若元件有做取替代,需判斷此筆tlf資料是否為該元件的替代料在製量
          IF sr.sfa26 MATCHES '[SUT]' THEN  #取替代
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM sfe_file
              WHERE sfe01=sr.sfb01
                AND sfe07=sr.sfa03   AND sfe27=sr.sfa27
                AND sfe02=sr1.tlf905 AND sfe28=l_tlf906
             IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
             IF l_cnt = 0 THEN CONTINUE FOREACH END IF
          END IF
         #end MOD-A70016 add

          #No.MOD-A70221  --Begin
          IF sr1.tlf13 = 'asft670' THEN
             LET sr1.tlf10 = sr1.tlf10 * -1
             LET sr1.tlf905= l_tlf036
          END IF
          #No.MOD-A70221  --End  

          LET l_qty = sr1.tlf10
          LET l_out = l_out + l_qty
       #------No.TQC-5A0054 add
          #IF l_chr ='Y' THEN #MOD-670011 OR (l_chr ='N' AND sr.sfa27 !=sr.sfb05) THEN   #MOD-8B0140 mark
           IF l_chr ='Y' OR (l_chr ='N' AND sr.sfa27 !=sr.sfb05) THEN                    #MOD-8B0140
              #OUTPUT TO REPORT asfr400_rep(sr.*,sr1.*,l_qty,l_wip)                          #No.FUN-750101
              EXECUTE insert_prep USING sr1.*,sr.*,l_qty,l_wip,l_ima02,l_ima021              #No.FUN-750101
           END IF
       #---end
 
       END FOREACH
 
       #FOREACH tlf_cs USING sr.sfb05,sr.sfb01 INTO sr1.*,l_tlf906,l_tlf036     #No.MOD-A70221  #MOD-C60174 mark
       FOREACH tlf_cs1 USING sr.sfb05,sr.sfb05,sr.sfb01 INTO sr1.*,l_tlf036   #MOD-C60174
          IF SQLCA.sqlcode != 0  THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
          END IF
          #MOD-C60174---begin
          SELECT SUM(tlf10) INTO sr1.tlf10
            FROM tlf_file
           WHERE tlf62 = sr1.tlf62
             AND tlf905 = sr1.tlf905 
          #MOD-C60174---end
         #CASE sr1.tlf13                           #MODNO:7111 add 'T'  #MOD-670011
          CASE                                     #MOD-670011
              #WHEN 'asft6201' IF sr.sfa26 MATCHES '[SUT]' THEN                #MOD-670011
               WHEN (sr1.tlf13='asft6201' OR sr1.tlf13='asft6231')
                  IF sr.sfa26 MATCHES '[SUTZ]' THEN  #MOD-670011 add   #FUN-A20037 add 'Z'
#------------------------------No.TQC-670055 modify----------------------------
                     LET sr1.tlf10 =  sr1.tlf10 * sr.sfa161
 
                     SELECT SUM(c) INTO l_tmp1 FROM sub_tmp
                        WHERE a = sr.sfb01    
                        AND b = sr.sfa27    
                     LET l_tmp1 = l_tmp1 * sr.sfa161
 
                     SELECT c INTO l_tmp FROM tmp
                      WHERE a = sr.sfb01    
                      AND b = sr.sfa27    
 
                     IF STATUS = 100 THEN
                    #-----------------No.TQC-670055 modify
                        LET l_tmp1 = l_tmp1 - l_out
                        IF (l_tmp1 - sr1.tlf10) < 0 THEN
                           LET l_qty = sr1.tlf10 - l_tmp1
                           LET l_tmp_qty = l_out - l_qty
                           INSERT INTO tmp 
                             VALUES(sr.sfb01,sr.sfa27,l_tmp_qty)  
                        ELSE
                           LET l_tmp_qty = l_out + l_tmp1 - sr1.tlf10 
                           INSERT INTO tmp 
                             VALUES(sr.sfb01,sr.sfa27,l_tmp_qty)  
                           CONTINUE FOREACH
                        END IF
 
                       #--------------No.TQC-670055 mark
                       #IF sr1.tlf10 > l_out THEN
                       #   LET l_qty = l_out
                       #ELSE
                       #   LET l_qty = sr1.tlf10
                       #END IF
                       #LET l_tmp_qty = sr1.tlf10 - l_qty
                       #INSERT INTO tmp
                       #  VALUES(sr.sfa27,l_tmp_qty)
                       #LET l_qty = l_qty * (-1)
                       #LET l_wip = l_out + l_qty
                       #--------------No.TQC-670055 end
                     ELSE
                        IF l_tmp > sr1.tlf10 THEN 
                           IF (l_tmp - l_out - sr1.tlf10) >= 0 THEN
                              LET l_tmp_qty = l_tmp - sr1.tlf10 
                              UPDATE tmp SET c = l_tmp_qty
                                 WHERE a = sr.sfb01    
                                 AND b = sr.sfa27    
                              CONTINUE FOREACH
                           ELSE
                              LET l_qty = sr1.tlf10 - (l_tmp - l_out)
                              LET l_tmp_qty = l_tmp - sr1.tlf10
                              UPDATE tmp SET c = l_tmp_qty
                                 WHERE a = sr.sfb01    
                                 AND b = sr.sfa27    
                           END IF   
                        ELSE
                           LET l_qty = sr1.tlf10 - l_tmp
                           UPDATE tmp SET c = 0
                              WHERE a = sr.sfb01    
                              AND b = sr.sfa27    
                        END IF
 
                       #--------------No.TQC-670055 mark
                       #IF l_tmp > l_out THEN
                       #   LET l_qty = l_out
                       #ELSE
                       #   LET l_qty = l_tmp
                       #END IF
                       #UPDATE tmp SET c = c - l_qty
                       # WHERE a = sr.sfa27
                       #LET l_qty = l_qty * (-1)
                       #LET l_wip = l_out + l_qty
                       #--------------No.TQC-670055 end
#------------------------------No.TQC-670055 end----------------------------
                     END IF
                  ELSE
                     LET l_qty = sr1.tlf10 * sr.sfa161 * (-1)
                  END IF
               WHEN sr1.tlf13='asft660'
                  LET l_qty = sr1.tlf10 * sr.sfa161  #MOD-670011 add sr1.tlf13
               OTHERWISE
                  IF l_chr ='Y' OR (l_chr ='N' AND sr.sfa27 = sr.sfb05) THEN   #MOD-8B0140 add
                     #No.FUN-A70221  --Begin
                     #LET l_qty = sr1.tlf10 #報廢
                     IF sr1.tlf13 = 'asft670' THEN
                        LET l_qty = sr1.tlf10 * -1
                        LET sr1.tlf905= l_tlf036
                     ELSE
                        LET l_qty = sr1.tlf10 
                     END IF
                     #No.FUN-A70221  --End  
                  
                 #str MOD-8B0140 add
                  ELSE
                     CONTINUE FOREACH
                  END IF
                 #end MOD-8B0140 add
          END CASE
 
          #OUTPUT TO REPORT asfr400_rep(sr.*,sr1.*,l_qty,l_wip)                  #No.FUN-750101
          EXECUTE insert_prep USING sr1.*,sr.*,l_qty,l_wip,l_ima02,l_ima021      #No.FUN-750101
         #str MOD-A70016 add
         #當不同元件替代成同一個料時,在製量的計算有問題,需重算
          LET l_wip_1 = 0   LET l_wip_2 = 0
          EXECUTE asfr400_pre_wip1 USING sr.sfb01,sr.sfb05,sr.sfa03 INTO l_wip_1
          EXECUTE asfr400_pre_wip2 USING sr.sfb01,sr.sfb05,sr.sfa03 INTO l_wip_2
          IF cl_null(l_wip_1) THEN LET l_wip_1=0 END IF
          IF cl_null(l_wip_2) THEN LET l_wip_2=0 END IF
          IF l_wip_1 > 0 THEN LET l_wip_1 =  l_wip_1 * -1 END IF
          IF l_wip_1+l_wip_2 != l_wip THEN
             LET l_wip_sub = l_wip_1+l_wip_2
             EXECUTE update_prep USING l_wip_sub,sr.sfb01,sr.sfb05,sr.sfa03,sr.sfa27
          END IF 
         #end MOD-A70016 add
       END FOREACH
       DELETE FROM tmp WHERE a = sr.sfb01 AND b= sr.sfa27  #No.TQC-670055 add
     END FOREACH
     IF g_zz05='Y' THEN                                                          #No.FUN-750101
        CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb81,sfb15')                           #No.FUN-750101
          RETURNING tm.wc                                                        #No.FUN-750101
        LET g_str=tm.wc                                                          #No.FUN-750101
     END IF                                                                      #No.FUN-750101
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED              #No.FUN-750101
     IF g_sma.sma541 <> 'Y' THEN
        CALL cl_prt_cs3("asfr400","asfr400",l_sql,g_str)                            #No.FUN-750101
     ELSE
        CALL cl_prt_cs3("asfr400","asfr400_1",l_sql,g_str)                       #FUN-A60027 add
     END IF                                                                      #FUN-A60027 add
     #FINISH REPORT asfr400_rep                                                  #No.FUN-750101
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                #No.FUN-750101
END FUNCTION
 
 #No.FUN-750101  --begin--
{
 
REPORT asfr400_rep(sr,sr1,l_qty,l_wip)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         l_qty        LIKE ima_file.ima26,          #No.FUN-680121 DEC(13,3)
#         l_wip        LIKE ima_file.ima26,          #No.FUN-680121 DEC(13,3)
          l_qty        LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_wip        LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044  
          l_str        STRING,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          sr  RECORD
              sfb01  LIKE sfb_file.sfb01,
              sfb02  LIKE sfb_file.sfb02,       #No.TQC-5A0054 add
              sfb05  LIKE sfb_file.sfb05,
              ima55  LIKE ima_file.ima55,
              sfb09  LIKE sfb_file.sfb09,
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,
              sfa03  LIKE sfa_file.sfa03,
              sfa08  LIKE sfa_file.sfa08,
              sfa12  LIKE sfa_file.sfa12,
              sfa27  LIKE sfa_file.sfa27,
              sfa26  LIKE sfa_file.sfa26,
              sfa28  LIKE sfa_file.sfa28,
              sfa161 LIKE sfa_file.sfa161,
              sfa064 LIKE sfa_file.sfa064         #FUN-650118 add
              END RECORD,
          sr1 RECORD
              tlf01  LIKE tlf_file.tlf01,         #料件編號
              tlf905 LIKE tlf_file.tlf905,        #單據編號
              tlf907 LIKE tlf_file.tlf907,        #入出庫(+-)
              tlf62  LIKE tlf_file.tlf62,         #工單編號
              tlf10  LIKE tlf_file.tlf10,         #異動數量
              tlf13  LIKE tlf_file.tlf13          #異動命令
              END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.sfb01,sr.sfa03
  FORMAT
   PAGE HEADER
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_x[09] CLIPPED,sr.sfb01 CLIPPED,   #No.FUN-550067
            COLUMN 27,g_x[10] CLIPPED,sr.sfb05 CLIPPED,
#TQC-5B0111 &051112
    #       COLUMN 71,g_x[12] CLIPPED,sr.ima55
            COLUMN 94,g_x[12] CLIPPED,sr.ima55
      PRINT g_x[13] CLIPPED,sr.sfb09 USING '<<<,<<<,<<<',
    #       COLUMN 27,g_x[11] CLIPPED,sr.ima02 CLIPPED,
    #       COLUMN 71,g_x[15] CLIPPED,sr.ima021
            COLUMN 27,g_x[11] CLIPPED,sr.ima02 CLIPPED
     PRINT  COLUMN 27,g_x[15] CLIPPED,sr.ima021 CLIPPED
#TQC-5B0111 &051112  -end
 
      PRINT g_dash
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.sfb01
      SKIP TO TOP OF PAGE
 
   BEFORE GROUP OF sr.sfa03
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.sfa03
      IF SQLCA.sqlcode THEN LET l_ima02 = ' ' END IF
      IF SQLCA.sqlcode THEN LET l_ima021= ' ' END IF
      PRINT COLUMN g_c[31],sr.sfa03,
            COLUMN g_c[32],l_ima02,
            COLUMN g_c[33],l_ima021,
            COLUMN g_c[34],sr.sfa12;
 
   ON EVERY ROW
      CASE sr1.tlf13
           WHEN 'asft670'  LET l_str ="(-)"
           OTHERWISE
              IF sr1.tlf907 = 1 THEN LET l_str = l_qty USING '###,###,###,###',"(-)"  END IF
              IF sr1.tlf907 =-1 THEN LET l_str = l_qty USING '###,###,###,###',"(+)"  END IF
      END CASE
 
      PRINT COLUMN g_c[35],sr1.tlf905,
            COLUMN g_c[36],l_str CLIPPED
 
   AFTER GROUP OF sr.sfa03
     #start FUN-650118 add
      IF sr.sfa064 != 0 THEN
         LET l_str = ''
         IF sr.sfa064 <0 THEN 
            LET l_str = sr.sfa064 USING '###,###,###,###',"(-)"
         ELSE
            LET l_str = sr.sfa064 USING '###,###,###,###',"(+)"
         END IF
         PRINT COLUMN g_c[35],g_x[16] CLIPPED,
               COLUMN g_c[36],l_str CLIPPED
         LET l_wip = l_wip + sr.sfa064
      END IF
     #end FUN-650118 add
      PRINT g_dash2
      LET l_str = sr.sfa03 CLIPPED,g_x[14] CLIPPED
      PRINT COLUMN g_c[33],l_str CLIPPED,
            COLUMN g_c[36],l_wip USING '---,---,---,---'
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb81,sfb15')    #TQC-630166
              RETURNING tm.wc
         PRINT g_dash
 
#TQC-630166-start
          CALL cl_prt_pos_wc(tm.wc) 
#        IF tm.wc[001,070] > ' ' THEN            # for 80
#             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        IF tm.wc[071,140] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        IF tm.wc[141,210] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        IF tm.wc[211,280] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash
#     PRINT g_x[4] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED     #No.TQC-710016
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-710016
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
#        PRINT g_x[4] CLIPPED, COLUMN g_c[36], g_x[6] CLIPPED     #No.TQC-710016
         PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-710016
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
}
 #No.FUN-750101  --end--
