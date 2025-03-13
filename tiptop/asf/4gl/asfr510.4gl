# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfr510.4gl
# Descriptions...: 工單發料列印
# Date & Author..: 91/11/17 By Keith
# Note ..........: 修改時請同時檢查(apmt207.4gl)
# Modify.........: No:8512 03/10/31 Sophia where條件少了and sfe14=sfa08 and sfe17=sfa12
# Modify.........: No.MOD-4A0338 04/11/02 By Smapmin 以za_file方式取代PRINT中文字的部份
# Modify.........: No.FUN-4B0022 04/11/05 By Yuna 新增工單號開窗
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-570240 05/07/26 By Trisy 料件編號開窗
# Modify.........: No.FUN-580005 05/08/05 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-8C0072 08/12/11 By sherry sfe27為被替代料
# Modify.........: No.FUN-940008 09/05/19 By hongmei發料改善
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60076 10/06/12 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60095 10/07/28 By jan 調整FUN-A60076的問題
# Modify.........: No.FUN-C30141 12/05/10 By bart 1.將報表轉為CR呈現 
#                                                 2.提供一個勾選選項"是否列印料號小計"，為"Y"時，by 單號+料號列印小計

DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-580005 --start--
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17          #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5          #No.FUN-680121 SMALLINT
END GLOBALS
#No.FUN-580005 --end--
 
   DEFINE tm  RECORD                # Print condition RECORD
#             wc      VARCHAR(600),       # 工單單號、發料單號、料表批號、  #TQC-630166
              wc      STRING,          # 工單單號、發料單號、料表批號、  #TQC-630166
                                       # 料件編號、發料日期範圍
              a        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# 異動別
              b        LIKE type_file.chr1,          #FUN-C30141
              more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# 是否輸入其它特殊列印條件(Y|N)
              END RECORD,
              g_sfe01_t  LIKE sfe_file.sfe01,
              g_p              LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              g_point          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
              g_num            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
              g_tot_bal  LIKE ccq_file.ccq03                 #No.FUN-680121 DECIMAL(13,2)# User defined variable
DEFINE   g_i             LIKE type_file.num5                 #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-580005 --start--
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
#No.FUN-580005 --end--
DEFINE   g_str           STRING   #FUN-C30141
DEFINE   g_sql           STRING   #FUN-C30141
DEFINE   l_table         STRING   #FUN-C30141
 
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123

   #FUN-C30141---begin
   LET g_sql = "sfe01.sfe_file.sfe01,",
               "sfe03.sfe_file.sfe03,",
               "sfc02.sfc_file.sfc02,",
               "sfe02.sfe_file.sfe02,", 
               "sfe07.sfe_file.sfe07,",
               "sfa05.sfa_file.sfa05,", 
               "sfa06.sfa_file.sfa06,",
               "sfe04.sfe_file.sfe04,", 
               "sfe08.sfe_file.sfe08,",
               "sfe09.sfe_file.sfe09,",
               "sfe10.sfe_file.sfe10,",
               "sfe16.sfe_file.sfe16,", 
               "sfe17.sfe_file.sfe17,",
               "sfe33.sfe_file.sfe33,",
               "sfe35.sfe_file.sfe35,",
               "sfe30.sfe_file.sfe30,",
               "sfe32.sfe_file.sfe32,",
               "sfe012.sfe_file.sfe012,",
               "sfe013.sfe_file.sfe013,",
               "sfe06.sfe_file.sfe06,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021"
               
   LET l_table = cl_prt_temptable('asfr510',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #FUN-C30141---end

   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)     #FUN-C30141
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)  #FUN-C30141 9->10
   LET g_rep_clas = ARG_VAL(11)  #FUN-C30141 10->11
   LET g_template = ARG_VAL(12)  #FUN-C30141 11->12
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL asfr510_tm(0,0)        # Input print condition
   ELSE
      CALL asfr510()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfr510_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680121 SMALLINT
          l_sta          LIKE type_file.chr1000,  #No.FUN-680121 VARCHAR(40)
          l_cmd          LIKE type_file.chr1000   #No.FUN-680121 VARCHAR(400)
   DEFINE l_sfa03        LIKE sfa_file.sfa03      #No.FUN-940008 add
   DEFINE l_sfa27        LIKE sfa_file.sfa27      #No.FUN-940008 add
   DEFINE l_sfa28        LIKE sfa_file.sfa28      #No.FUN-940008 add
   DEFINE g_sfe01        LIKE sfe_file.sfe01      #No.FUN-940008 add
   DEFINE g_sfe07        LIKE sfe_file.sfe07      #No.FUN-940008 add
   DEFINE g_sfe14        LIKE sfe_file.sfe14      #No.FUN-940008 add
   DEFINE g_sfe17        LIKE sfe_file.sfe17      #No.FUN-940008 add   
   DEFINE li_where       STRING                   #No.FUN-940008 add
 
   IF p_row = 0 THEN
      LET p_row = 3
      LET p_col = 12
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 12
   END IF
   OPEN WINDOW asfr510_w AT p_row,p_col
        WITH FORM "asf/42f/asfr510"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a       = '3'
   LET tm.b       = 'N'   #FUN-C30141
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfe01,sfe02,sfe03,sfe07,sfe04
       #--No.FUN-4B0022-------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION CONTROLP
         CASE WHEN INFIELD(sfe01)      #工單單號
                  #FUN-940008---Begin                 
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.state= "c"
                  #LET g_qryparam.form = "q_sfa9"
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  #DISPLAY g_qryparam.multiret TO sfe01  
                   LET li_where = " AND (sfa01,sfa03,sfa08,sfa12,sfa27)", 
                                  "  IN (SELECT sfe01,sfe07,sfe14,sfe17,sfe27",
                                  "        FROM sfe_file)"  
                   CALL q_short_qty(TRUE,TRUE,g_sfe01,'',li_where,'4') 
                        RETURNING g_sfe01
                   DISPLAY g_sfe01 TO sfe01
                  #FUN-940008---End      
                   NEXT FIELD sfe01
              WHEN INFIELD(sfe02)      #發料單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_sfe"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfe02
                   NEXT FIELD sfe02
#No.FUN-570240 --start--
              WHEN INFIELD(sfe07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO sfe07
                   NEXT FIELD sfe07
#No.FUN-570240 --end--
         OTHERWISE EXIT CASE
         END CASE
       #--END---------------
 
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
   DISPLAY BY NAME tm.a, tm.b, tm.more      # Condition   #FUN-C30141 add b
   INPUT BY NAME tm.a, tm.b, tm.more WITHOUT DEFAULTS   #FUN-C30141 add b
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a = ' ' THEN                    #輸入異動別
            NEXT FIELD a
         END IF
         IF tm.a NOT MATCHES '[123]' THEN
            NEXT FIELD a
         END IF
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
            NEXT FIELD more
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
          CALL cl_cmdask()           # COMMAND EXECUTION
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
      CLOSE WINDOW asfr510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                  WHERE zz01='asfr510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr510','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",   #FUN-C30141
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
 
         CALL cl_cmdat('asfr510',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW asfr510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfr510()
   ERROR ""
END WHILE
CLOSE WINDOW asfr510_w
END FUNCTION
 
FUNCTION asfr510()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166         #No.FUN-680121 VARCHAR(1000)
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima34,        #No.FUN-680121 VARCHAR(10)
          sr        RECORD
                       sfe01 LIKE sfe_file.sfe01,
                       sfe03 LIKE sfe_file.sfe03,
                       sfc02 LIKE sfc_file.sfc02,
                       sfe02 LIKE sfe_file.sfe02,
                       sfe07 LIKE sfe_file.sfe07,
                       sfa05 LIKE sfa_file.sfa05,
                       sfa06 LIKE sfa_file.sfa06,
                       sfe04 LIKE sfe_file.sfe04,
                       sfe08 LIKE sfe_file.sfe08,
                       sfe09 LIKE sfe_file.sfe09,
                       sfe10 LIKE sfe_file.sfe10,
                       sfe16 LIKE sfe_file.sfe16,
                       sfe17 LIKE sfe_file.sfe17,
                       #No.FUN-580005 --start--
                       sfe33 LIKE sfe_file.sfe33,
                       sfe35 LIKE sfe_file.sfe35,
                       sfe30 LIKE sfe_file.sfe30,
                       sfe32 LIKE sfe_file.sfe32,
                       #No.FUN-580005 --end--
                       sfe012 LIKE sfe_file.sfe012,     #FUN-A60076
                       sfe013 LIKE sfe_file.sfe013,     #FUN-A60076 
                       sfe06 LIKE sfe_file.sfe06
                    END RECORD
   DEFINE l_i,l_cnt          LIKE type_file.num5      #No.FUN-580005        #No.FUN-680121 SMALLINT
   DEFINE l_zaa02            LIKE zaa_file.zaa02      #No.FUN-580005
   DEFINE l_ima02            LIKE ima_file.ima02      #FUN-C30141
   DEFINE l_ima021           LIKE ima_file.ima021     #FUN-C30141
 
   SELECT zo02 INTO g_company FROM zo_file
                  WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET tm.wc = tm.wc clipped," AND sfeuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET tm.wc = tm.wc clipped," AND sfegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET tm.wc = tm.wc clipped," AND sfegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfeuser', 'sfegrup')
   #End:FUN-980030
 
 
   LET l_sql =
            "SELECT sfe01, sfe03, sfc02, sfe02, ",
            "       sfe07, sfa05, sfa06, sfe04, sfe08, ",
            "       sfe09, sfe10, sfe16, sfe17, ",
            "       sfe33,sfe35,sfe30,sfe32,sfe012,sfe013,sfe06 ",  #No.FUM-580005                 #FUN-A60076 add sfe012,sfe013
            "  FROM sfe_file,OUTER(sfa_file),OUTER(sfc_file)",                                  
            " WHERE  sfa_file.sfa01 = sfe_file.sfe01  AND sfa_file.sfa03 = sfe_file.sfe07  ",   
            "   AND sfa08 = sfe14 AND sfa12 = sfe17 ",   #NO:8512                             
            "   AND  sfa_file.sfa27 = sfe_file.sfe27   ",   # #FUN-8C0072                 
            "   AND  sfe_file.sfe012 = sfa_file.sfa012 AND sfe_file.sfe013 = sfa_file.sfa013 " ,   #FUN-A60076
            "   AND  sfe_file.sfe01 = sfc_file.sfc01 "                               
   IF tm.a = "1" THEN
      LET l_sql = l_sql CLIPPED," AND sfe06 = '1'  ",
               "   AND ",tm.wc CLIPPED, "  ORDER BY 1,5 "
   END IF
   IF tm.a = "2" THEN
      LET l_sql = l_sql CLIPPED,"  AND sfe06 = '3'  ",
               "   AND ",tm.wc CLIPPED," ORDER BY 1,5 "
   END IF
   IF tm.a = "3" THEN
      LET l_sql = l_sql CLIPPED," AND sfe06 IN ('1','3','4','A')",
               "   AND ",tm.wc CLIPPED,"  ORDER BY 1,5 "
   END IF
 
   PREPARE asfr510_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM
   END IF
   DECLARE asfr510_curs1 CURSOR FOR asfr510_prepare1
   #FUN-C30141---begin
   #CALL cl_outnam('asfr510') RETURNING l_name
   #  #No.FUN-580005 --start--
   #  SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
   #  IF g_sma115 = "Y" THEN
   #     LET g_zaa[43].zaa06 = "N"
   #  ELSE
   #     LET g_zaa[43].zaa06 = "Y"
   #  END IF
   #  CALL cl_prt_pos_len()
   #  #No.FUN-580005 --end--
   #
   #START REPORT asfr510_rep TO l_name
   #
   #LET g_pageno = 0
   CALL cl_del_data(l_table)
   #FUN-C30141---end
   FOREACH asfr510_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0  THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
 
      IF sr.sfa05 IS NULL THEN
          LET sr.sfa05 = 0
      END IF
 
      IF sr.sfa06 IS NULL THEN
          LET sr.sfa06 = 0
      END IF
 
      IF sr.sfe16 IS NULL THEN
          LET sr.sfe16 = 0
      END IF

      #FUN-C30141---begin
      ##No.FUN-A60076 ------------start---------------
      #IF g_sma.sma541 = 'Y' THEN
      #   LET g_zaa[44].zaa06 = 'N'
      #   LET g_zaa[45].zaa06 = 'N'
      #ELSE
      #   LET g_zaa[44].zaa06 = 'Y'
      #   LET g_zaa[45].zaa06 = 'Y'
      #END IF 
      ##No.FUN-A60076 ------------end------------- 
      #OUTPUT TO REPORT asfr510_rep(sr.*)  
      LET l_ima02 = ''
      LET l_ima021= ''
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.sfe07

      IF sr.sfe06='4' THEN
         LET sr.sfe16 = sr.sfe16 * (-1)
      END IF
       
      EXECUTE insert_prep USING sr.*,l_ima02,l_ima021
      #FUN-C30141 end
   END FOREACH
   #FUN-C30141---begin
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
   IF g_zz05='Y' THEN
      CALL cl_wcchp(tm.wc,'sfe01,sfe02,sfe03,sfe07,sfe04')
           RETURNING tm.wc
   ELSE
      LET tm.wc = ""
   END IF
   LET g_str = tm.wc
   IF tm.b = 'Y' THEN 
      CALL cl_prt_cs3('asfr510','asfr510_1',g_sql,g_str)
   ELSE 
      CALL cl_prt_cs3('asfr510','asfr510',g_sql,g_str)
   END IF 

   #FINISH REPORT asfr510_rep
   #
   #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   #FUN-C30141---end
END FUNCTION
#FUN-C30141---begin mark
#REPORT asfr510_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#          l_pointer    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#          l_pt         LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
#          l_sta        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
#          l_cnt,l_n    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#          l_ima02      LIKE ima_file.ima02,
#          l_ima021     LIKE ima_file.ima021,
#          sr        RECORD
#                       sfe01 LIKE sfe_file.sfe01,
#                       sfe03 LIKE sfe_file.sfe03,
#                       sfc02 LIKE sfc_file.sfc02,
#                       sfe02 LIKE sfe_file.sfe02,
#                       sfe07 LIKE sfe_file.sfe07,
#                       sfa05 LIKE sfa_file.sfa05,
#                       sfa06 LIKE sfa_file.sfa06,
#                       sfe04 LIKE sfe_file.sfe04,
#                       sfe08 LIKE sfe_file.sfe08,
#                       sfe09 LIKE sfe_file.sfe09,
#                       sfe10 LIKE sfe_file.sfe10,
#                       sfe16 LIKE sfe_file.sfe16,
#                       sfe17 LIKE sfe_file.sfe17,
#                       #No.FUN-580005 --start--
#                       sfe33 LIKE sfe_file.sfe33,
#                       sfe35 LIKE sfe_file.sfe35,
#                       sfe30 LIKE sfe_file.sfe30,
#                       sfe32 LIKE sfe_file.sfe32,
#                       #No.FUN-580005 --end--
#                       sfe012 LIKE sfe_file.sfe012,  #FUN-A60076
#                       sfe013 LIKE sfe_file.sfe013,  #FUN-A60076 
#                       sfe06 LIKE sfe_file.sfe06
#                    END RECORD
#   DEFINE l_str2        LIKE type_file.chr1000,         #No.FUN-680121 VARCHAR(100)#No.FUN-580005
#          l_sfe35       STRING,    #No.FUN-580005
#          l_sfe32       STRING     #No.FUN-580005
#   DEFINE l_ima906      LIKE ima_file.ima906           #FUN-580005
# 
#   OUTPUT   TOP MARGIN g_top_margin
#           LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#           PAGE LENGTH g_page_line
#   ORDER BY sr.sfe01,sr.sfe02
#   FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      PRINT g_x[09] CLIPPED,COLUMN 11,sr.sfe01
#      PRINT g_x[10] CLIPPED,COLUMN 11,sr.sfe03,'      ',sr.sfc02
# 
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],        #FUN-A60076
#            g_x[44],        #FUN-A60076
#            g_x[45],        #FUN-A60076
#            g_x[32],
#            g_x[33],
#            g_x[34],
#            g_x[35],
#            g_x[36],
#            g_x[37],
#            g_x[38],
#            g_x[39],
#            g_x[40],
#            g_x[41],
#            g_x[42],
#            g_x[43]      #No.FUN-580005
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   BEFORE GROUP OF sr.sfe01
#      IF  (PAGENO > 1 OR LINENO > 9)
#         THEN SKIP TO TOP OF PAGE
#      END IF
# 
#   ON EVERY ROW
#      LET l_ima02 = ''
#      LET l_ima021= ''
#      SELECT ima02,ima021,ima906 INTO l_ima02,l_ima021,l_ima906 FROM ima_file
#       WHERE ima01 = sr.sfe07
# 
#      IF sr.sfe06='4' THEN
#         LET sr.sfe16 = sr.sfe16 * (-1)
#      END IF
##No.FUN-560069 ---start--
#      LET l_str2 = ""
#      IF g_sma115 = "Y" THEN
#         IF NOT cl_null(sr.sfe35) AND sr.sfe35 <> 0 THEN
#            CALL cl_remove_zero(sr.sfe35) RETURNING l_sfe35
#            LET l_str2 = l_sfe35, sr.sfe33 CLIPPED
#         END IF
#         IF l_ima906 = "2" THEN
#            IF cl_null(sr.sfe35) OR sr.sfe35 = 0 THEN
#               CALL cl_remove_zero(sr.sfe32) RETURNING l_sfe32
#               LET l_str2 = l_sfe32, sr.sfe30 CLIPPED
#            ELSE
#               IF NOT cl_null(sr.sfe32) AND sr.sfe32 <> 0 THEN
#                  CALL cl_remove_zero(sr.sfe32) RETURNING l_sfe32
#                  LET l_str2 = l_str2 CLIPPED,',',l_sfe32, sr.sfe30 CLIPPED
#               END IF
#            END IF
#         END IF
#      END IF
##No.FUN-560069 ---end--
#      PRINT COLUMN g_c[31],sr.sfe02,          #FUN-A60076
#            COLUMN g_c[44],sr.sfe012,         #FUN-A60076
#            COLUMN g_c[45],cl_numfor(sr.sfe013,45,0),  #FUN-A60076  #FUN-A60095
#            #COLUMN g_c[32],sr.sfe07[1,20],
#            COLUMN g_c[32],sr.sfe07 CLIPPED,  #NO.FUN-5B0015
#            COLUMN g_c[33],l_ima02,
#            COLUMN g_c[34],l_ima021,
#            COLUMN g_c[35],sr.sfa05 USING '-----------.---',
#            COLUMN g_c[36],sr.sfa06 USING '-----------.---',
#            COLUMN g_c[37],sr.sfe04,
#            COLUMN g_c[38],sr.sfe08,
#            COLUMN g_c[39],sr.sfe09,
#            COLUMN g_c[40],sr.sfe10,
#            COLUMN g_c[41],sr.sfe16 USING '-----------.---',
#            COLUMN g_c[42],sr.sfe17,
#            COLUMN g_c[43],l_str2 CLIPPED     #No.FUN-580005
# 
#   AFTER GROUP OF sr.sfe01
#      LET g_point = "Y"
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#          CALL cl_wcchp(tm.wc,'sfe01,sfe02,sfe03,sfe07,sfe04')  #TQC-630166
#                  RETURNING tm.wc
#          PRINT g_dash[1,g_len]
# 
##TQC-630166-start
#          CALL cl_prt_pos_wc(tm.wc) 
##         IF tm.wc[001,070] > ' ' THEN            # for 80
##             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##         IF tm.wc[071,140] > ' ' THEN
##             PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##         IF tm.wc[141,210] > ' ' THEN
##             PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##         IF tm.wc[211,280] > ' ' THEN
##             PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##TQC-630166-end
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.FUN-580005
#      LET l_last_sw = 'y'
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash[1,g_len]
#         PRINT g_x[11]
#         IF g_point = "Y" THEN
#            PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.FUN-580005
#            LET g_point = "N"
#         ELSE
#            PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         END IF
#      ELSE
#          SKIP 3 LINE
#      END IF
#END REPORT
#FUN-C30141---end
