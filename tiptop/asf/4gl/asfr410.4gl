# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfr410.4gl
# Descriptions...: 在製材料狀況表
# Date & Author..: 00/06/03 By Kammy
# Modify.........: No:9715 04/07/21 Carol 若只發替代料時,無法顯示
#                                   -->LET l_wip = l_wip + l_s_wip 不要再作判斷
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.MOD-5A0198 05/10/17 By pengu 當工單型態是'重工委外工單'時，報表(asfr410)的在製量會算到2次
# Modify.........: No.TQC-610080 06/03/02 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.MOD-670011 06/07/19 By Clarie s_wipqty 多傳一個是否為重工工單且發料料號=完工料號的參數
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-720005 07/01/25 By TSD.Ken 報表改寫由Crystal Report產出
# Modify.........: No.FUN-710080 07/03/29 By Sarah CR報表串cs3()增加傳一個參數
# Modify.........: No.MOD-760099 07/06/22 By pengu 當有替代料時期計算在製量會異常
# Modify.........: No.MOD-770037 07/07/23 By pengu 當有替代料時計算在製量會異常
# Modify.........: No.FUN-7B0096 08/05/13 By jamie 1. QBE 增加開窗功能 2. 報表產出欄位title調整
# Modify.........: No.MOD-970151 09/07/17 By lilingyu 計算l_tmp_wip時,如果為NULL,沒有做賦0的動作,導致在制量不對
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:TQC-A50156 10/05/26 By Carrier MOD-9B0117 追单
# Modify.........: No.FUN-A60027 10/06/12 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A70016 10/07/02 By Sarah CURSOR sfa_su的SQL需增加串sfa27條件
# Modify.........: No:MOD-B30479 10/03/14 By zhangll 替代料跟原料单位不一致的情况下，在制量异常
# Modify.........: No:MOD-B70115 11/07/11 by destiny 调用s_wipqty时应该传发料料号，不应该传BOM料号
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                    # Print condition RECORD
#             wc      VARCHAR(600),        # Where condition    #TQC-630166
              wc      STRING,           # Where condition    #TQC-630166
              more    LIKE type_file.chr1        #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件?
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE l_table     STRING                       ### FUN-720005 add ###
DEFINE g_sql       STRING                       ### FUN-720005 add ###
DEFINE g_str       STRING                       ### FUN-720005 add ###
 
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
 
   #str FUN-720005 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> FUN-720005 *** ##
   LET g_sql =  "sfb01.sfb_file.sfb01,",
                "sfb02.sfb_file.sfb02,", 
                "sfb05.sfb_file.sfb05,",
                "sfa03.sfa_file.sfa03,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "sfa08.sfa_file.sfa08,",
                "sfa12.sfa_file.sfa12,",
                "sfa012.sfa_file.sfa012,",     #FUN-A60027
                "sfa013.sfa_file.sfa013,",     #FUN-A60027
                "sfa27.sfa_file.sfa27,",
                "sfa26.sfa_file.sfa26,",
                "sfa28.sfa_file.sfa28,",
                "sfa161.sfa_file.sfa161,",
#               "l_wip.ima_file.ima26"           #NO.FUN-A20044   
                "l_wip.type_file.num15_3"   #NO.FUN-A20044
 
   LET l_table = cl_prt_temptable('asfr410',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"    #FUN-A60027 add 2?
 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-720005 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
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
   #TQC-610080-end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL asfr410_tm()        # Input print condition
      ELSE CALL asfr410()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr410_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(700)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW asfr410_w AT p_row,p_col WITH FORM "asf/42f/asfr410"
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
#-----------No.MOD-770037 add
   DROP TABLE sub_tmp
   CREATE TEMP TABLE sub_tmp
   (a         LIKE sfb_file.sfb01,
    b         LIKE sfb_file.sfb05,
    c         LIKE sfb_file.sfb08);
#-----------No.MOD-770037 end
     CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfa03
#No.FUN-570240 --start--
        #No.FUN-580031 --start--
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No.FUN-580031 ---end---
 
        ON ACTION controlp
 
          #FUN-7B0096---add---str---
           IF INFIELD(sfb01) THEN   #工單編號"
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_sfb3"     #No:TQC-A50156 modify
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb01
              NEXT FIELD sfb01
           END IF
          #FUN-7B0096---add---end---
 
           IF INFIELD(sfb05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
           END IF
           IF INFIELD(sfa03) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfa03
              NEXT FIELD sfa03
           END IF
#No.FUN-570240 --end--
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
               WHERE zz01='asfr410'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfr410','9031',1)
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
                          #" '",tm.more CLIPPED,"'",           #TQC-610080 
                           " '",g_rep_user CLIPPED,"'",        #No.FUN-570264
                           " '",g_rep_clas CLIPPED,"'",        #No.FUN-570264
                           " '",g_template CLIPPED,"'",        #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
           CALL cl_cmdat('asfr410',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW asfr410_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL asfr410()
     ERROR ""
   END WHILE
   CLOSE WINDOW asfr410_w
END FUNCTION
 
FUNCTION asfr410()
   DEFINE l_name     LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql      STRING,                       # RDSQL STATEMENT  TQC-630166
          l_chr      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#         l_qty      LIKE ima_file.ima26,          #No.FUN-680121 DEC(13,3)
#         l_wip      LIKE ima_file.ima26,          #No.FUN-680121 DEC(13,3)
#         l_wip_c    LIKE ima_file.ima26,          #No.FUN-680121 DEC(13,3) 
#         l_s_wip    LIKE ima_file.ima26,          #No.FUN-680121 DEC(13,3)
#         l_s_wip_c  LIKE ima_file.ima26,          #No.FUN-680121 DEC(13,3)
          l_qty      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_wip      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_wip_c    LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_s_wip    LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_s_wip_c  LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_tmp_wip  LIKE sfb_file.sfb08,     #No.MOD-770037 add
          l_sfa03    LIKE sfa_file.sfa03,     #No.MOD-770037 add
          l_sfa28    LIKE sfa_file.sfa28,     #No.MOD-770037 add
          l_za05     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE apm_file.apm08,        #No.FUN-680121 VARCHAR(10)
          sr  RECORD
              sfb01  LIKE sfb_file.sfb01,
              sfb02  LIKE sfb_file.sfb02,   #bugno:6203 add
              sfb05  LIKE sfb_file.sfb05,
              sfa03  LIKE sfa_file.sfa03,
              ima02  LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021,
              sfa08  LIKE sfa_file.sfa08,
              sfa12  LIKE sfa_file.sfa12,
              sfa012 LIKE sfa_file.sfa012,    #FUN-A60027
              sfa013 LIKE sfa_file.sfa013,    #FUN-A60027 
              sfa27  LIKE sfa_file.sfa27,
              sfa26  LIKE sfa_file.sfa26,
              sfa28  LIKE sfa_file.sfa28,
              sfa161 LIKE sfa_file.sfa161,
#             l_wip  LIKE ima_file.ima26    #FUN-720005
              l_wip  LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
              END RECORD
   DEFINE l_sfa12    LIKE sfa_file.sfa12 #Add No:MOD-B30479  #替代料时原料的单位
   DEFINE l_cnt      LIKE type_file.num5 #Add No:MOD-B30479
  
   #str FUN-720005 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-720005 *** ##
   CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
   #end FUN-720005 add
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-720005 add ###
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
   #End:FUN-980030
 
   #bugno:6203 add sfb02
   LET l_sql = " SELECT sfb01,sfb02,sfb05,sfa03,ima02,ima021,sfa08,sfa12,sfa012,sfa013,",   #FUN-A60027 add sfa012,sfa013
               " sfa27,sfa26,sfa28,sfa161,0 ",               #FUN-720005
               "   FROM sfb_file,sfa_file ,OUTER ima_file ", #Ora
               "  WHERE sfa01 = sfb01 ",          
               "    AND  ima_file.ima01 = sfa_file.sfa03  ",                     #Ora
               "    AND sfb04 IN ('2','3','4','5','6','7') ",          #Ora
               "    AND ",tm.wc CLIPPED,
               "    ORDER BY sfb01,sfa26 "      #No.MOD-770037
 
   PREPARE asfr410_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
   END IF
   DECLARE asfr410_curs1 CURSOR FOR asfr410_prepare1
 
   LET g_pageno = 0
   FOREACH asfr410_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0  THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_wip = 0
      LET l_wip_c = 0
 
     #bugno:6203 add ......
      #非重工工單 or 重工但 sfb05 !=sfa27 才計算
      #-----No.MOD-5A0198 重工、委外重工、拆件式工單但 sfb05 !=sfa27 才計算
      LET l_chr = 'N'
      CASE sr.sfb02
           WHEN '5'   LET l_chr ='N'
           WHEN '8'   LET l_chr ='N'
           WHEN '11'  LET l_chr ='N'
           OTHERWISE  LET l_chr ='Y'
      END CASE
 
      IF sr.sfa26 NOT MATCHES '[SUTZ]' THEN     #No.MOD-760099 add  #FUN-A20037 add 'Z'
         IF l_chr ='Y' OR (l_chr ='N' AND sr.sfa27 !=sr.sfb05) THEN 
            #CALL s_wipqty(sr.sfb01,sr.sfa27,sr.sfa161,' ',sr.sfa27) RETURNING l_wip   #在製量  #MOD-A70016 add sfa27 #MOD-B70115
            CALL s_wipqty(sr.sfb01,sr.sfa03,sr.sfa161,' ',sr.sfa27) RETURNING l_wip   #MOD-B70115
            CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161,'Y',sr.sfa27) RETURNING l_wip_c #在製量  #MOD-A70016 add sfa27
         ELSE
            CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161,'',sr.sfa27) RETURNING l_wip_c #在製量   #MOD-A70016 add sfa27   
         END IF          
         #MOD-670011-end
         
        #bugno:6203 end ......
         #----------No.MOD-770037 add
          INSERT INTO sub_tmp
            VALUES(sr.sfb01,sr.sfa27,(l_wip/sr.sfa161))
         #----------No.MOD-770037 end
         LET l_wip = l_wip + l_wip_c
      #IF sr.sfa26 MATCHES '[SUT]' THEN   #MODNO:7111 add 'T'    #No.MOD-760099 mark
       ELSE                                                      #No.MOD-760099 add
         LET l_s_wip = 0    LET l_s_wip_c = 0
         #------------------No.MOD-770037 modify
         #Add No:MOD-B30479
         LET l_sfa12=''
         SELECT COUNT(UNIQUE sfa12) INTO l_cnt FROM sfa_file
          WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa27
            AND sfa27 = sr.sfa27 AND sfa08 = sr.sfa08
         IF l_cnt = 1 THEN
            SELECT UNIQUE sfa12 INTO l_sfa12 FROM sfa_file
             WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa27
               AND sfa27 = sr.sfa27 AND sfa08 = sr.sfa08
         ELSE  #如果抓到不只一笔，就需要检查单据是否正常了
            LET l_sfa12 = sr.sfa12
         END IF
         #End Add No:MOD-B30479
          LET l_tmp_wip = 0
          SELECT sfa161 INTO sr.sfa161 FROM sfa_file 
           WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa27
            #AND sfa08 = sr.sfa08 AND sfa12 = sr.sfa12
             AND sfa08 = sr.sfa08 AND sfa12 = l_sfa12  #Mod No:MOD-B30479
             AND sfa012 = sr.sfa012 AND sfa013 = sr.sfa013    #FUN-A60027 add
#MOD-970151 --begin--
          IF cl_null(sr.sfa161) THEN
             LET sr.sfa161 = 0 
          END IF 
#MOD-970151 --end-- 
          SELECT sfa28 INTO l_sfa28 FROM sfa_file
                 WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa03
                   AND sfa08 = sr.sfa08 AND sfa12 = sr.sfa12
                   AND sfa27 = sr.sfa27
                   AND sfa012 = sr.sfa012 AND sfa013 = sr.sfa013    #FUN-A60027  add 
#MOD-970151 --begin--
          IF cl_null(l_sfa28) THEN
             LET l_sfa28 = 0 
          END IF 
#MOD-970151 --end--                     
          LET sr.sfa161 = sr.sfa161 * l_sfa28
          CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161,'Y',sr.sfa27) RETURNING l_wip_c  #MOD-A70016 add sfa27
          DECLARE sfa_su CURSOR FOR
              SELECT sfa03 FROM sfa_file
               WHERE sfa01 = sr.sfb01 AND sfa03 = sr.sfa03
                 AND sfa27 = sr.sfa27   #MOD-A70016 add
                 AND sfa012 = sr.sfa012 AND sfa013 = sr.sfa013    #FUN-A60027      
                 AND sfa26 IN ('S','U','T','Z')       #FUN-A20037 add 'Z' 
          FOREACH sfa_su INTO l_sfa03
             CALL s_wipqty(sr.sfb01,l_sfa03,sr.sfa161,'',sr.sfa27)  #MOD-A70016 add sfa27
                  RETURNING l_s_wip_c   
             LET l_s_wip = l_s_wip + l_s_wip_c
          END FOREACH
          SELECT SUM(c) INTO l_tmp_wip FROM sub_tmp
              WHERE a = sr.sfb01
              AND b = sr.sfa27
#MOD-970151 --begin--
          IF cl_null(l_tmp_wip) THEN
             LET l_tmp_wip = 0 
          END IF 
#MOD-970151 --end--               
          LET l_tmp_wip = l_tmp_wip * sr.sfa161
          IF (l_tmp_wip + l_wip_c) < 0 THEN
             LET l_wip = l_s_wip + l_tmp_wip + l_wip_c
          ELSE
             LET l_wip = l_s_wip
          END IF
          INSERT INTO sub_tmp
            VALUES(sr.sfb01,sr.sfa27,(l_s_wip/sr.sfa161))
 
         #CALL s_wipqty(sr.sfb01,sr.sfa03,sr.sfa161) RETURNING l_s_wip   #在製量
         #CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161) RETURNING l_s_wip_c #在製量
         #CALL s_wipqty(sr.sfb01,sr.sfa03,sr.sfa161,'') RETURNING l_s_wip   #在製量
         #CALL s_wipqty(sr.sfb01,sr.sfb05,sr.sfa161,'') RETURNING l_s_wip_c #在製量
         #LET l_s_wip = l_s_wip + l_s_wip_c
         #LET l_wip = l_wip + l_s_wip         #No:9715     #No.MOD-760099 mark
         #LET l_wip = l_s_wip                              #No.MOD-760099 add
       #----------------No.MOD-770037 end
      END IF
 
      IF l_wip <= 0 THEN CONTINUE FOREACH END IF
      
      LET sr.l_wip = l_wip    #FUN-720005
 
      #str FUN-720005 add
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-720005 *** ##
      EXECUTE insert_prep USING 
         sr.sfb01,sr.sfb02,sr.sfb05,sr.sfa03,sr.ima02,
         sr.ima021,sr.sfa08,sr.sfa12,sr.sfa012,sr.sfa013,sr.sfa27,sr.sfa26,    #FUN-A60027 add sfa012,sfa013
         sr.sfa28,sr.sfa161,sr.l_wip           #FUN-720005, l_wip
      #------------------------------ CR (3) ------------------------------#
      #end FUN-720005 add
   END FOREACH
 
   #str FUN-720005 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-720005 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #FUN-710080 modify
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfa03')
           RETURNING tm.wc
      LET g_str = tm.wc
   END IF
  #CALL cl_prt_cs3('asfr410','asfr410',l_sql,g_str)   #FUN-710080 modify
  #No.FUN-A60027-----------------start-------------------
   IF g_sma.sma541  = 'Y' THEN
      CALL cl_prt_cs3('asfr410','asfr410_1',l_sql,g_str)
   ELSE
      CALL cl_prt_cs3('asfr410','asfr410',l_sql,g_str)
   END IF 
  #No.FUN-A60027 ----------------end---------------------   
   #------------------------------ CR (4) ------------------------------#
   #end FUN-720005 add
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END FUNCTION
