# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: apmx505.4gl
# Descriptions...: 採購單交貨數量確認表
# Input parameter:
# Return code....:
# Date & Author..: 91/10/02 By Nora
# Modify.........: No.FUN-4A0031 04/10/02 By Yuna 料件編號開窗
# Modify.........: No.FUN-4C0095 05/01/06 By Mandy 報表轉XML
# Modify.........: No.FUN-550060 05/06/01 By yoyo單據編號格式放大
# Modify.........: No.MOD-5A0373 05/11/21 By Nicola 日期區段異常
# Modify.........: No.TQC-5B0212 05/11/30 By kevin 總頁數不對
# Modify.........: No.FUN-680136 06/09/04 By Jackho 欄位類型修改
# Modify.........: No.FUN-690119 06/10/16 By carrier cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.TQC-6B0076 06/11/16 By Ray 1.在AFTER INPUT段加入起始日期不可為空的控管
#                                                2.第一次進入rep()時g_pageno的值為0，因此應將IF g_pageno =1改為IF g_pageno =0從而保証第一頁的抬頭日期的正確性
# Modify.........: No.FUN-750110 07/06/20 By dxfwo CR報表的制作
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.TQC-970064 09/07/07 By lilingyu 報表應該顯示交貨數量,目前顯示的是未交貨數量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No:TQC-A50009 10/05/10 By liuxqa modify sql
# Modify.........: No:FUN-CB0004 12/12/19 By dongsz CR轉XtraGrid

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                     # Print condition RECORD
            #     wc        VARCHAR(500),                   # Where Condition
                 wc        STRING,      #TQC-630166      # Where Condition
                 base_flag LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
                 bdate     LIKE type_file.dat,           #No.FUN-680136 DATE      # 起始到廠日期
                 dayno     LIKE type_file.num5,          #No.FUN-680136 SMALLINT  # 日期區間
                 more      LIKE type_file.chr1           #No.FUN-680136 VARCHAR(1)   # 特殊列印條件
              END RECORD
 
DEFINE   g_chr           LIKE type_file.chr1             #No.FUN-680136 VARCHAR(1)
DEFINE   g_i             LIKE type_file.num5             #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   m               LIKE type_file.num5             #No.FUN-750110
DEFINE   l_table         STRING                          #No.FUN-750110                                                                       
DEFINE   g_sql           STRING                          #No.FUN-750110                                                                       
DEFINE   g_str           STRING                          #No.FUN-750110  
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690119
#No.FUN-750110--------begin--------     
   LET g_sql = " pmn01.pmn_file.pmn01,",          #FUN-CB0004 add
               " pmn04.pmn_file.pmn04,",
               " pmn041.pmn_file.pmn041,",
               " ima021.ima_file.ima021,",
               " pml20.pml_file.pml20,",
               " pmn53.pmn_file.pmn53,",
               " pml21.pml_file.pml21,",
               " pmn57.pmn_file.pmn57,", 
               " pmn58.pmn_file.pmn58,",
               " pmn82.pmn_file.pmn82,",
               " pmn85.pmn_file.pmn85,",
               " pmn87.pmn_file.pmn87,",
               " pml82.pml_file.pml82,",
               " num1.type_file.num5"             #FUN-CB0004 add  
   LET l_table = cl_prt_temptable('apmx505',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM  END IF
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED ,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-A50009 mod
               " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?) "               #FUN-CB0004 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF   
#No.FUN-750110--------end--------     
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.base_flag = ARG_VAL(8)
   LET tm.bdate = ARG_VAL(9)
   LET tm.dayno = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL x505_tm(0,0)
   ELSE
      CALL x505()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
END MAIN
 
FUNCTION x505_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col   LIKE type_file.num5,         #No.FUN-680136 SMALLINT
          l_cmd         LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW x505_w AT p_row,p_col
     WITH FORM "apm/42f/apmx505" ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.base_flag= '1'
   LET tm.more   = 'N'
   LET g_pdate   = g_today
   LET g_rlang   = g_lang
   LET g_bgjob   = 'N'
   LET g_copies  = '1'
 
   WHILE TRUE
      CONSTRUCT BY NAME  tm.wc ON pmn04
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
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
 
         #--No.FUN-4A0031--------
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmn04) #料件編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmn04
                  NEXT FIELD pmn04
               OTHERWISE
                  EXIT CASE
            END CASE
         #--END---------------
 
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
         CLOSE WINDOW x505_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      DISPLAY BY NAME tm.more
      INPUT BY NAME tm.base_flag,tm.bdate,tm.dayno,tm.more
                    WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD base_flag
            IF tm.base_flag IS NULL THEN
               NEXT FIELD base_flag
            END IF
            IF tm.base_flag NOT MATCHES "[12345]" THEN
               NEXT FIELD base_flag
            END IF
 
         AFTER FIELD bdate
            IF tm.bdate IS NULL THEN
               NEXT FIELD bdate
            END IF
 
         AFTER FIELD dayno
            IF cl_null(tm.dayno) OR tm.dayno <= 0 THEN
               NEXT FIELD dayno
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
      AFTER INPUT
         #No.TQC-6B0076 --begin
         IF cl_null(tm.bdate) THEN
            CALL cl_err(tm.bdate,'apm-981',0)
            NEXT FIELD bdate
         END IF
         #No.TQC-6B0076 --end
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW x505_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01 = 'apmx505'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('apmx505','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'" ,
                        " '",tm.base_flag CLIPPED,"'" ,
                        " '",tm.bdate CLIPPED,"'" ,
                        " '",tm.dayno CLIPPED,"'" ,
                        " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                        " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('apmx505',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW x505_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
 
      CALL x505()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW x505_w
 
END FUNCTION
 
FUNCTION x505()
   DEFINE l_name     LIKE type_file.chr20,         #No.FUN-680136 VARCHAR(20)
          l_time     LIKE type_file.chr8,          #No.FUN-680136 VARCHAR(8)
          l_i        LIKE type_file.num5,          #No.FUN-680136 SMALLINT
         #l_sql      LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(1000)    #FUN-CB0004 MARK
          l_sql      STRING,                       #FUN-CB0004 add
          l_za05     LIKE type_file.chr1000,       #No.FUN-680136 VARCHAR(40)
          l_pmn34,l_pmn35,l_pmn36,l_pmn37          LIKE type_file.dat,        #No.FUN-680136 DATE
          sr         RECORD
                        pmn01     LIKE pmn_file.pmn01,   #FUN-CB0004 add
                        pmn04     LIKE pmn_file.pmn04,   #料件編號
                        pmn041    LIKE pmn_file.pmn041,  #FUN-4C0095
                        pmn33     LIKE pmn_file.pmn33,   #到廠日期
#                        pmn50_n   LIKE pmn_file.pmn50    #未收貨量    #TQC-970064
                         pmn50_n   LIKE pmn_file.pmn50    #  收貨量    #TQC-970064   
                     END RECORD,
          l_flag     LIKE type_file.num5,                #No.FUN-750110 SMALLINT       #記錄日期區間是否己結束
          l_max      LIKE type_file.num5,                #No.FUN-750110 SMALLINT       #記錄是否是最后1筆資料
          l_pmn50_n  ARRAY[9] of LIKE type_file.num20_6, #No.FUN-750110 DECIMAL(20,6)  #區間內未交貨量
          l_pmn04    LIKE  pmn_file.pmn04,               #No.FUN-750110           料件編號
          l_pmn04_1  LIKE  pmn_file.pmn04,               #No.FUN-750110           料件編號
          l_end_day  ARRAY[9] of LIKE type_file.dat      #No.FUN-750110 DATE  #結束日期
   DEFINE l_tit      ARRAY[9] of LIKE type_file.chr20    #No.FUN-750110 VARCHAR(20)
   DEFINE l_ima021   LIKE ima_file.ima021                #No.FUN-750110
   DEFINE l_num1     LIKE type_file.num5                 #FUN-CB0004 add
 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND pmmuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
   #End:FUN-980030
   
   LET l_pmn04_1= 0        #No.FUN-750110
# LET l_sql = " SELECT pmn04,pmn041,pmn33,pmn20-pmn50+pmn55,pmn34,pmn35,pmn36,pmn37",      #No.FUN-940083
# LET l_sql = " SELECT pmn04,pmn041,pmn33,pmn20-pmn50+pmn55+pmn58,pmn34,pmn35,pmn36,pmn37", #No.FUN-940083 #TQC-970064
  #LET l_sql = " SELECT pmn04,pmn041,pmn33,pmn50,pmn34,pmn35,pmn36,pmn37",         #TQC-970064   
  LET l_sql = " SELECT pmn01,pmn04,pmn041,pmn33,pmn50,pmn34,pmn35,pmn36,pmn37",    #FUN-CB0004 add pmn01
               " FROM pmm_file,pmn_file",
               " WHERE pmm01 = pmn01 ",
#              " AND pmn20 > pmn50-pmn55 ",        #No.FUN-9A0068 mark
               " AND pmn20 > pmn50-pmn55-pmn58 ",  #No.FUN-9A0068 
               " AND pmn16 IN ('2')",
               " AND ", tm.wc CLIPPED,
               " ORDER BY 1"
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET l_sql = l_sql clipped," AND pmmuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET l_sql = l_sql clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET l_sql = l_sql clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
 
   PREPARE x505_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690119
      EXIT PROGRAM
   END IF
 
   DECLARE x505_c1 CURSOR FOR x505_p1
 
#  CALL cl_outnam('apmx505') RETURNING l_name     #No.FUN-750110
#  START REPORT x505_rep TO l_name                #No.FUN-750110  
 
   CALL cl_del_data(l_table)                      #No.FUN-750110
#No.FUN-750110--------begin-------- 
            #計算正確的日期區間
            LET l_end_day[1] = tm.bdate -1  #No.MOD-5A0373
            FOR g_i = 2 TO 9
               LET l_flag = 1
               LET l_end_day[g_i] = l_end_day[g_i-1]
               WHILE l_flag <= tm.dayno
                  LET l_end_day[g_i] = l_end_day[g_i] + 1
                  SELECT sme02 INTO g_chr FROM sme_file
                   WHERE sme01 = l_end_day[g_i]
                  IF SQLCA.sqlcode = 100 THEN
                     LET l_flag = l_flag + 1
                  END IF
                  IF g_chr = 'Y' THEN
                     LET l_flag = l_flag + 1
                  END IF
               END WHILE
            END FOR
         LET l_tit[1] = 'BEFORE-' ,l_end_day[1] USING 'mm/dd'
         FOR g_i = 1 TO 8  #No.MOD-5A0373
            LET l_tit[1+g_i] = l_end_day[g_i]+1 USING 'mm/dd','-',l_end_day[g_i+1] USING 'mm/dd'
         END FOR
             LET l_pmn50_n[1] = 0                                                                                                   
             LET l_pmn50_n[2] = 0                                                                                                   
             LET l_pmn50_n[3] = 0                                                                                                   
             LET l_pmn50_n[4] = 0                                                                                                   
             LET l_pmn50_n[5] = 0                                                                                                   
             LET l_pmn50_n[6] = 0                                                                                                   
             LET l_pmn50_n[7] = 0                                                                                                   
             LET l_pmn50_n[8] = 0                                                                                                   
             LET l_pmn50_n[9] = 0 
#No.FUN-750110--------end--------  
   FOREACH x505_c1 INTO sr.*,l_pmn34,l_pmn35,l_pmn36,l_pmn37
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CASE WHEN tm.base_flag = '2' LET sr.pmn33 = l_pmn34
           WHEN tm.base_flag = '3' LET sr.pmn33 = l_pmn35
           WHEN tm.base_flag = '4' LET sr.pmn33 = l_pmn36
           WHEN tm.base_flag = '5' LET sr.pmn33 = l_pmn37
      END CASE
 
      IF sr.pmn33 IS NULL THEN
         CONTINUE FOREACH
      END IF
#No.FUN-750110--------begin-------- 
         IF l_pmn04_1<>sr.pmn04 THEN 
            FOR m =1 to 8  
            LET l_pmn50_n[m] =0  
            END FOR
         ELSE
         END IF  
         LET l_pmn04 = sr.pmn04                                                                                                     
         SELECT ima021
           INTO l_ima021
           FROM ima_file
          WHERE ima01=l_pmn04
         IF SQLCA.sqlcode THEN
            LET l_ima021 = NULL
         END IF
         CASE
            WHEN sr.pmn33 <  l_end_day[1]
               LET l_pmn50_n[1] =  sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[2] AND sr.pmn33 >= l_end_day[1]
               LET l_pmn50_n[2] =  sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[3] AND sr.pmn33 > l_end_day[2]
               LET l_pmn50_n[3] =  sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[4] AND sr.pmn33 > l_end_day[3]
               LET l_pmn50_n[4] =  sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[5] AND sr.pmn33 > l_end_day[4]
               LET l_pmn50_n[5] =  sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[6] AND sr.pmn33 > l_end_day[5]
               LET l_pmn50_n[6] =  sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[7] AND sr.pmn33 > l_end_day[6]
               LET l_pmn50_n[7] =  sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[8] AND sr.pmn33 > l_end_day[7]
               LET l_pmn50_n[8] =  sr.pmn50_n
         END CASE
         LET l_num1 = 3              #FUN-CB0004 add
         EXECUTE insert_prep USING sr.pmn01,sr.pmn04,sr.pmn041,l_ima021,l_pmn50_n[1], #FUN-CB0004 add sr.pmn01
                                   l_pmn50_n[2],l_pmn50_n[3],l_pmn50_n[4],l_pmn50_n[5],
                                   l_pmn50_n[6],l_pmn50_n[7],l_pmn50_n[8],l_pmn50_n[9],l_num1    #FUN-CB0004 add l_num1      
#No.FUN-750110--------end--------  
#     OUTPUT TO REPORT x505_rep(sr.*)     #No.FUN-750110
   END FOREACH
#  FINISH REPORT x505_rep   #No.FUN-750110
#  CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #No.FUN-750110
#No.FUN-750110--------begin--------  
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                  
  
    LET g_xgrid.table = l_table    ###XtraGrid###
     CALL cl_wcchp(tm.wc,'pmn04')                                                                                       
      RETURNING tm.wc                                                                                                           
###XtraGrid###     LET g_str = tm.wc,";",l_tit[1],";",l_tit[2],";",l_tit[3],";",l_tit[4],";",l_tit[5],";",
###XtraGrid###                 l_tit[6],";",l_tit[7],";",l_tit[8],";",l_tit[9]                                                                                                                       
###XtraGrid###     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                                             
###XtraGrid###     CALL cl_prt_cs3('apmx505','apmx505',l_sql,g_str)                  
   #FUN-CB0004--add--str---
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pml20',l_tit[1]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pmn53',l_tit[2]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pml21',l_tit[3]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pmn57',l_tit[4]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pmn58',l_tit[5]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pmn82',l_tit[6]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pmn85',l_tit[7]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pmn87',l_tit[8]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.dynamic_title = cl_xg_dynamic_title(g_xgrid.dynamic_title,'pml82',l_tit[9]||cl_getmsg('afa-331',g_lang),'')
    LET g_xgrid.order_field = 'pmn04'
    LET g_xgrid.grup_field = 'pmn04'
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-750110--------end--------  
 
 
END FUNCTION
{            #No.FUN-750110
REPORT x505_rep(sr)
   DEFINE l_ima021   LIKE ima_file.ima021         #FUN-4C0095
   DEFINE l_last_sw  LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
          sr         RECORD
                        pmn04     LIKE pmn_file.pmn04,   #料件編號
                        pmn041    LIKE pmn_file.pmn041,  #FUN-4C0095
                        pmn33     LIKE pmn_file.pmn33,   #到廠日期
                        pmn50_n   LIKE pmn_file.pmn50    #未收貨量
                     END RECORD,
          l_flag     LIKE type_file.num5,                #No.FUN-680136 SMALLINT       #記錄日期區間是否己結束
          l_pmn50_n  ARRAY[9] of LIKE type_file.num20_6, #No.FUN-680136 DECIMAL(20,6)  #區間內未交貨量
          l_pmn04    LIKE  pmn_file.pmn04,               #料件編號
          l_end_day  ARRAY[9] of LIKE type_file.dat      #No.FUN-680136 DATE  #結束日期
   DEFINE l_tit      ARRAY[9] of LIKE type_file.chr20    #No.FUN-680136 VARCHAR(20)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.pmn04
 
   FORMAT
      PAGE HEADER
         #LET g_pageno = g_pageno + 1 #No.TQC-5B0212
#        IF g_pageno = 1 THEN     #No.TQC-6B0076
         IF g_pageno = 0 THEN     #No.TQC-6B0076
            #計算正確的日期區間
            LET l_end_day[1] = tm.bdate -1  #No.MOD-5A0373
            FOR g_i = 2 TO 9
               LET l_flag = 1
               LET l_end_day[g_i] = l_end_day[g_i-1]
               WHILE l_flag <= tm.dayno
                  LET l_end_day[g_i] = l_end_day[g_i] + 1
                  SELECT sme02 INTO g_chr FROM sme_file
                   WHERE sme01 = l_end_day[g_i]
                  IF SQLCA.sqlcode = 100 THEN
                     LET l_flag = l_flag + 1
                  END IF
                  IF g_chr = 'Y' THEN
                     LET l_flag = l_flag + 1
                  END IF
               END WHILE
            END FOR
         END IF
 
         LET l_tit[1] = g_x[9] CLIPPED,l_end_day[1] USING 'mm/dd'
 
        #LET l_tit[2] = l_end_day[1] USING 'mm/dd','-',l_end_day[2] USING 'mm/dd'
        #FOR g_i = 2 TO 8
         FOR g_i = 1 TO 8  #No.MOD-5A0373
            LET l_tit[1+g_i] = l_end_day[g_i]+1 USING 'mm/dd','-',l_end_day[g_i+1] USING 'mm/dd'
         END FOR
 
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
 
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT
         PRINT g_dash
         #No.FUN-550060 --start--
         PRINT COLUMN g_c[34],l_tit[1] CLIPPED,
               COLUMN g_c[35],l_tit[2] CLIPPED,
               COLUMN g_c[36],l_tit[3] CLIPPED,
               COLUMN g_c[37],l_tit[4] CLIPPED,
               COLUMN g_c[38],l_tit[5] CLIPPED,
               COLUMN g_c[39],l_tit[6] CLIPPED,
               COLUMN g_c[40],l_tit[7] CLIPPED,
               COLUMN g_c[41],l_tit[8] CLIPPED,
               COLUMN g_c[42],l_tit[9]
         #No.FUN-550060 --end--
         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
         PRINT g_dash1
         LET l_last_sw = 'n'
 
      BEFORE GROUP OF sr.pmn04
         LET l_pmn04 = sr.pmn04
        #FOR g_i = 1 TO 9
            #LET l_pmn50_n[g_i] = 0
             LET l_pmn50_n[1] = 0
             LET l_pmn50_n[2] = 0
             LET l_pmn50_n[3] = 0
             LET l_pmn50_n[4] = 0
             LET l_pmn50_n[5] = 0
             LET l_pmn50_n[6] = 0
             LET l_pmn50_n[7] = 0
             LET l_pmn50_n[8] = 0
             LET l_pmn50_n[9] = 0
        #END FOR
 
      ON EVERY ROW
         CASE
            WHEN sr.pmn33 <  l_end_day[1]
               LET l_pmn50_n[1] = l_pmn50_n[1] + sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[2] AND sr.pmn33 >= l_end_day[1]
               LET l_pmn50_n[2] = l_pmn50_n[2] + sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[3] AND sr.pmn33 > l_end_day[2]
               LET l_pmn50_n[3] = l_pmn50_n[3] + sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[4] AND sr.pmn33 > l_end_day[3]
               LET l_pmn50_n[4] = l_pmn50_n[4] + sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[5] AND sr.pmn33 > l_end_day[4]
               LET l_pmn50_n[5] = l_pmn50_n[5] + sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[6] AND sr.pmn33 > l_end_day[5]
               LET l_pmn50_n[6] = l_pmn50_n[6] + sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[7] AND sr.pmn33 > l_end_day[6]
               LET l_pmn50_n[7] = l_pmn50_n[7] + sr.pmn50_n
            WHEN sr.pmn33 <= l_end_day[8] AND sr.pmn33 > l_end_day[7]
               LET l_pmn50_n[8] = l_pmn50_n[8] + sr.pmn50_n
         END CASE
 
      AFTER GROUP OF sr.pmn04
         SELECT ima021
           INTO l_ima021
           FROM ima_file
          WHERE ima01=l_pmn04
         IF SQLCA.sqlcode THEN
            LET l_ima021 = NULL
         END IF
         PRINT COLUMN g_c[31],l_pmn04,
               COLUMN g_c[32],sr.pmn041,
               COLUMN g_c[33],l_ima021,
               COLUMN g_c[34],cl_numfor(l_pmn50_n[1],34,3),
               COLUMN g_c[35],cl_numfor(l_pmn50_n[2],35,3),
               COLUMN g_c[36],cl_numfor(l_pmn50_n[3],36,3),
               COLUMN g_c[37],cl_numfor(l_pmn50_n[4],37,3),
               COLUMN g_c[38],cl_numfor(l_pmn50_n[5],38,3),
               COLUMN g_c[39],cl_numfor(l_pmn50_n[6],39,3),
               COLUMN g_c[40],cl_numfor(l_pmn50_n[7],40,3),
               COLUMN g_c[41],cl_numfor(l_pmn50_n[8],41,3),
               COLUMN g_c[42],cl_numfor(l_pmn50_n[9],42,3)
        #FOR g_i = 2 TO 9
        #    PRINT l_pmn50_n[g_i] USING'########.###';
        #END FOR
         PRINT
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN
            PRINT g_dash
        #   IF tm.wc[001,120] > ' ' THEN
        #      PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED
        #   END IF
        #   IF tm.wc[121,240] > ' ' THEN
        #      PRINT COLUMN 10,tm.wc[121,240] CLIPPED
        #   END IF
        #   IF tm.wc[241,300] > ' ' THEN
        #      PRINT COLUMN 10,tm.wc[241,300] CLIPPED END IF
	
 	#TQC-630166
		CALL cl_prt_pos_wc(tm.wc)
         END IF
         PRINT g_dash
         LET l_last_sw = 'y'
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
      PAGE TRAILER
         IF l_last_sw = 'n' THEN
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT         }#No.FUN-750110


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
