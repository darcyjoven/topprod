# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr130.4gl
# Descriptions...: 客戶應收未收帳款彙總表
# Date & Author..: 98/07/06 By Danny
# Modify.........: 98/08/04 By Jimmy(增加報表可選擇輸出內容)
# 990419 Ivy 此表之授信業務因數字不正確,授信又不用,所以拿掉選擇項目
# 990420 Ivy sdate本只輸入無功能, 現加上 (for會計才能有此功能)
# 990506 Ivy 關係人,非關係人要加總,
# Modify.........: No.FUN-4C0100 05/03/01 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.FUN-580010 05/08/03 By yoyo 憑証類報表原則修改
# Modify.........: No.TQC-5C0086 05/12/19 By Carrier AR月底重評修改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-770028 07/07/05 By Rayven 制表日期與報表名稱所在的行數顛倒
# Modify.........: NO.FUN-810010 08/01/30 By zhaijie報表打印改為 Crystal Report
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0115 09/11/20 By wujie 报表改抓多帐期资料
# Modify.........: No:FUN-A10098 10/01/19 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: No:FUN-B20020 11/02/15 By destiny 增加收款单条件 
# Modify.........: No:MOD-C80063 12/08/13 By Polly 報表需印出ooa37=2溢退的金額出來，故取消ooa37的條件
# Modify.........: No.TQC-CC0032 12/12/06 By qirl  oma03開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                     # Print condition RECORD
              wc      STRING,                            # Where condition
              rdate   LIKE type_file.dat,                #No.FUN-680123 DATE
              sdate   LIKE type_file.dat,                #No.FUN-680123 DATE
              # Prog. Version..: '5.30.06-13.03.12(01),                          # Ivy 990506  關係人否   #TQC-610059
              more    LIKE type_file.chr1,               # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              s       LIKE type_file.chr1                #No.FUN-680123 VARCHAR(01)
              END RECORD,
        #plant        ARRAY[12] OF LIKE azp_file.azp01,  #工廠編號 #No.FUN-680123 VARCHAR(12) #No.FUN-A10098
         g_sql        STRING,
         g_atot       LIKE type_file.num5,               #No.FUN-680123 SMALLINT
         g_p1,g_p2    LIKE type_file.chr1000             #No.FUN-680123 VARCHAR(300)
 
DEFINE   g_i            LIKE type_file.num5              #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i              LIKE type_file.num5              #No.FUN-680123 SMALLINT
#NO.FUN-810010------------------------start---------------
 
DEFINE   g_str        STRING                             
DEFINE   l_table      STRING
 
#NO.FUN-810010-----------------end-----------------
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17              #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5              #No.FUN-680123 SMALLINT
END GLOBALS
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
#NO.FUN-810010--------------START------------
   LET g_sql = "plant.azp_file.azp01,",
               "oma00.oma_file.oma00,",
               "oma01.oma_file.oma01,",
               "oma02.oma_file.oma02,",
               "oma03.oma_file.oma03,",
               "oma16.oma_file.oma16,",
               "oma23.oma_file.oma23,",
               "amt1.oma_file.oma55,",
               "amt2.oma_file.oma55,",
               "amta.type_file.num20_6,",
               "amtb.type_file.num20_6,",
               "amtc.type_file.num20_6,",
               "amtd.type_file.num20_6,",
               "occ37.occ_file.occ37,",
               "occ02.occ_file.occ02,",
               "t_azi04.azi_file.azi04"  
   LET l_table = cl_prt_temptable('axrr130',g_sql)
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
         CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF 
 
#NO.FUN-810010------------------END-----------
#No.FUN-680123 begin
   CREATE TEMP TABLE r130m_tmp
     (plant LIKE azp_file.azp01,
      type LIKE type_file.chr1,
      cust LIKE oma_file.oma03,
      curr LIKE azi_file.azi01,
      amt1 LIKE type_file.num20_6,
      amt2 LIKE type_file.num20_6,
      amt3 LIKE type_file.num20_6,
      amt4 LIKE type_file.num20_6,
      amta LIKE type_file.num20_6,
      amtb LIKE type_file.num20_6,
      amtc LIKE type_file.num20_6,
      amtd LIKE type_file.num20_6)
          #No.FUN-680123 end
   IF STATUS THEN CALL cl_err('create',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM 
   END IF
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #-----TQC-610059---------
   LET tm.s = ARG_VAL(8)
   LET tm.rdate = ARG_VAL(9)
   LET tm.sdate = ARG_VAL(10)
  #No.FUN-A10098 -BEGIN-----
  #LET plant[1] = ARG_VAL(11)
  #LET plant[2] = ARG_VAL(12)
  #LET plant[3] = ARG_VAL(13)
  #LET plant[4] = ARG_VAL(14)
  #LET plant[5] = ARG_VAL(15)
  #LET plant[6] = ARG_VAL(16)
  #LET plant[7] = ARG_VAL(17)
  #LET plant[8] = ARG_VAL(18)
  #LET plant[9] = ARG_VAL(19)
  #LET plant[10] = ARG_VAL(20)
  #LET plant[11] = ARG_VAL(21)
  #LET plant[12] = ARG_VAL(22)
  #FOR i = 1 TO 12
  #    IF NOT cl_null(ARG_VAL(i+10)) THEN
  #       LET g_atot = g_atot + 1
  #    END IF
  #END FOR
  ##-----END TQC-610059-----
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(23)
  #LET g_rep_clas = ARG_VAL(24)
  #LET g_template = ARG_VAL(25)
  #LET g_rpt_name = ARG_VAL(26)  #No.FUN-7C0078
  ##No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)
  #No.FUN-A10098 -END-------
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL axrr130_tm(0,0)        # Input print condition
      ELSE CALL axrr130()              # Read data and create out-file
   END IF
   DROP TABLE r130m_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr130_tm(p_row,p_col)
  DEFINE p_row,p_col   LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          l_ac         LIKE type_file.num10,       #No.FUN-680123 INTEGER
          l_cmd        LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(1000)
 
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 3 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW axrr130_w AT p_row,p_col
        WITH FORM "axr/42f/axrr130"
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
 # LET plant[1]=g_plant  #預設現行工廠 #No.FUN-A10098
   LET tm.rdate = g_today
   LET tm.sdate = g_today
   LET tm.more = 'N'
   LET tm.s = '1'
 # LET tm.a = '3'   # 990506
WHILE TRUE
   DELETE FROM r130m_tmp
   CONSTRUCT BY NAME tm.wc ON oma03
       ON ACTION locale
           #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
         #--TQC-CC0032--add--star--
          ON ACTION CONTROLP
           CASE
             WHEN INFIELD(oma03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_oma03"
                  LET g_qryparam.state    = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oma03
                  NEXT FIELD oma03
           END CASE
         #--TQC-CC0032--add--end---
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
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr130_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#No.FUN-A10098 -BEGIN-----
#  #----- 工廠編號 -B---#
#  CALL SET_COUNT(1)    # initial array argument
#  INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.*
#      BEFORE ROW               #No.FUN-560239
#         LET l_ac = ARR_CURR()
#
#      AFTER FIELD plant
#       # LET l_ac = ARR_CURR()   #No.FUN-560239 Mark
#         IF NOT cl_null(plant[l_ac]) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = plant[l_ac]
#            IF STATUS THEN
#               CALL cl_err('sel azp',STATUS,1)  #No.FUN-660116
#               CALL cl_err3("sel","azp_file",plant[l_ac],"",STATUS,"","",1)   #No.FUN-660116
#               NEXT FIELD plant
#            END IF
#            FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
#                IF plant[i] = plant[l_ac] THEN
#                   CALL cl_err('','aom-492',1) NEXT FIELD plant
#                END IF
#            END FOR
#            #No.FUN-940102--begin    
#            IF NOT s_chk_demo(g_user,plant[l_ac]) THEN              
#               NEXT FIELD plant         
#            END IF            
#            #No.FUN-940102--end 
#         END IF
#      AFTER INPUT                    # 檢查至少輸入一個工廠
#         IF INT_FLAG THEN EXIT INPUT END IF
#         LET g_atot = ARR_COUNT()
#         FOR i = 1 TO g_atot
#             IF NOT cl_null(plant[i]) THEN EXIT INPUT END IF
#         END FOR
#         IF i = g_atot+1 THEN
#            CALL cl_err('','aom-423',1) NEXT FIELD plant
#         END IF
#
#      #-----No.FUN-560239-----
#      ON ACTION CONTROLP
#         CALL cl_init_qry_var()
#        #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
#         LET g_qryparam.form = "q_zxy"               #No.FUN-940102
#         LET g_qryparam.arg1 = g_user                #No.FUN-940102
#         LET g_qryparam.default1 = plant[l_ac]
#         CALL cl_create_qry() RETURNING plant[l_ac]
#         CALL FGL_DIALOG_SETBUFFER(plant[l_ac])
#      #-----No.FUN-560239 END-----
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
#         ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
#  END INPUT
#  IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW axrr130_w RETURN END IF
#No.FUN-A10098 -END-------
 
   INPUT BY NAME tm.s,tm.rdate,tm.sdate,tm.more WITHOUT DEFAULTS
      AFTER FIELD rdate
         IF cl_null(tm.rdate) THEN NEXT FIELD rdate END IF
      AFTER FIELD sdate
         IF cl_null(tm.sdate) THEN NEXT FIELD sdate END IF
      AFTER FIELD s
         IF cl_null(tm.s) THEN NEXT FIELD s END IF
         IF tm.s NOT MATCHES '[123]' THEN
            NEXT FIELD s
         END IF
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
      AFTER INPUT
         IF  tm.rdate < tm.sdate  THEN
             ERROR "InvoDate < DataDate --> Error"
             NEXT FIELD  rdate
         ENd IF
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr130_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr130'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr130','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         #-----TQC-610059---------
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.rdate CLIPPED,"'",
                         " '",tm.sdate CLIPPED,"'",
                        #No.FUN-A10098 -BEGIN-----
                        #" '",plant[1] CLIPPED,"'",
                        #" '",plant[2] CLIPPED,"'",
                        #" '",plant[3] CLIPPED,"'",
                        #" '",plant[4] CLIPPED,"'",
                        #" '",plant[5] CLIPPED,"'",
                        #" '",plant[6] CLIPPED,"'",
                        #" '",plant[7] CLIPPED,"'",
                        #" '",plant[8] CLIPPED,"'",
                        #" '",plant[9] CLIPPED,"'",
                        #" '",plant[10] CLIPPED,"'",
                        #" '",plant[11] CLIPPED,"'",
                        #" '",plant[12] CLIPPED,"'",
                        #No.FUN-A10098 -END-------
                         #-----END TQC-610059-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr130',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr130_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr130()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr130_w
END FUNCTION
 
FUNCTION axrr130()
   DEFINE 
   	  l_name    LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
         #l_za05    VARCHAR(40),
          l_za05    LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(40)
          l_i,l_j   LIKE type_file.num5,          #No.FUN-680123 SMALLINT
         #l_dbs     VARCHAR(22),
          l_dbs     LIKE type_file.chr21,         #No.FUN-680123 VARCHAR(22)
          l_cnt,i   LIKE type_file.num5,          #No.FUN-580010 #No.FUN-680123 SMALLINT
          l_amt1,l_amt2 LIKE oma_file.oma55,
          l_amt3,l_amt4 LIKE oma_file.oma55,
          l_zaa02       LIKE zaa_file.zaa02,
          sr        RECORD
                    plant     LIKE azp_file.azp01,   #No.FUN-680123 VARCHAR(10)
                    oma00     LIKE oma_file.oma00,
                    oma01     LIKE oma_file.oma01,
                    oma02     LIKE oma_file.oma02,
                    oma03     LIKE oma_file.oma03,
                    oma16     LIKE oma_file.oma16,
                    oma23     LIKE oma_file.oma23,
                    amt1      LIKE oma_file.oma55,   #外幣
                    amt2      LIKE oma_file.oma55,   #本幣
                    amta      LIKE type_file.num20_6,#已確認外幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtb      LIKE type_file.num20_6,#已確認本幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtc      LIKE type_file.num20_6,#未收外幣 (amt1 - amta) #No.FUN-680123 DEC(20,6)
                    amtd      LIKE type_file.num20_6,#未收本幣 (amt2 - amtb) #No.FUN-680123 DEC(20,6)
                    occ37     LIKE occ_file.occ37,
                    occ02     LIKE occ_file.occ02
                    END RECORD
           
#NO.FUN-810010------------------start---------------
   DEFINE  l_plant   LIKE  azp_file.azp01
   DEFINE  l_curr    LIKE  azi_file.azi01
   DEFINE  l_s_plant LIKE  azp_file.azp01
   DEFINE  l_occ37   LIKE  occ_file.occ37
   DEFINE  l_amta,l_amtb,l_amtc,l_amtd  LIKE type_file.num20_6
 
#NO.FUN-810010---------------end--------- 
#NO.FUN-810010------------------start---------------
     CALL cl_del_data(l_table)
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrr130'
#NO.FUN-810010---------------end--------- 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
 
#     CALL cl_outnam('axrr130') RETURNING l_name           #NO.FUN-810010
#NO.FUN-810010-----------------START----MARK------------
#No.FUN-580010--start
#CASE WHEN tm.s='1'
#      LET g_zaa[31].zaa06="N"
#      LET g_zaa[32].zaa06="N"
#      LET g_zaa[33].zaa06="N"
#      LET g_zaa[34].zaa06="N"
#      LET g_zaa[35].zaa06="N"
#      LET g_zaa[36].zaa06="N"
#      LET g_zaa[37].zaa06="N"
#      LET g_zaa[38].zaa06="N"
#      LET g_zaa[44].zaa06="N"
#      LET g_zaa[43].zaa06="Y"
#      LET g_zaa[45].zaa06="Y"
#      LET g_zaa[39].zaa06="Y"
#      LET g_zaa[40].zaa06="Y"
#      LET g_zaa[41].zaa06="Y"
#      LET g_zaa[42].zaa06="Y"
#     WHEN tm.s='2'
#      LET g_zaa[31].zaa06="N"
#      LET g_zaa[32].zaa06="N"
#      LET g_zaa[33].zaa06="N"
#      LET g_zaa[34].zaa06="N"
#      LET g_zaa[35].zaa06="N"
#      LET g_zaa[36].zaa06="N"
#      LET g_zaa[37].zaa06="N"
#      LET g_zaa[38].zaa06="Y"
#      LET g_zaa[44].zaa06="Y"
#      LET g_zaa[43].zaa06="N"
#      LET g_zaa[45].zaa06="N"
#      LET g_zaa[39].zaa06="N"
#      LET g_zaa[40].zaa06="N"
#      LET g_zaa[41].zaa06="Y"
#      LET g_zaa[42].zaa06="Y"
#    OTHERWISE
#      LET g_zaa[31].zaa06="N"
#      LET g_zaa[32].zaa06="N"
#      LET g_zaa[33].zaa06="N"
#      LET g_zaa[34].zaa06="Y"
#      LET g_zaa[35].zaa06="Y"
#      LET g_zaa[36].zaa06="Y"
#      LET g_zaa[37].zaa06="Y"
#      LET g_zaa[38].zaa06="Y"
#      LET g_zaa[44].zaa06="Y"
#      LET g_zaa[43].zaa06="Y"
#      LET g_zaa[45].zaa06="Y"
#      LET g_zaa[39].zaa06="N"
#      LET g_zaa[40].zaa06="N"
#      LET g_zaa[41].zaa06="N"
#      LET g_zaa[42].zaa06="N"
#END CASE
#NO.FUN-810010--------------------------END -------MARK-------
#NO.FUN-810010-----------------START---------------
CASE WHEN tm.s='1'    LET l_name = 'axrr130'
     WHEN tm.s='2'    LET l_name = 'axrr130_1'
     OTHERWISE        LET l_name = 'axrr130_2'
END CASE
#NO.FUN-810010---------------END-------------
     CALL cl_prt_pos_len()
     FOR i=1 TO g_len LET g_dash[i,i]='='  END FOR
     FOR i=1 TO g_len LET g_dash2[i,i]='-'  END FOR
 
#No.FUN-580010--end
 
#     START REPORT axrr130_rep TO l_name                   #NO.FUN-810010
#     LET g_pageno = 0                                     #NO.FUN-810010

    #No.FUN-A10098 -BEGIN----- 
    #LET l_i = 1
    #FOR l_i = 1 TO g_atot
    #    IF cl_null(plant[l_i]) THEN CONTINUE FOR END IF
    #    SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = plant[l_i]
    #    LET l_dbs = s_dbstring(l_dbs CLIPPED)
    #No.FUN-A10098 -END-------
         #No.TQC-5C0086  --Begin                                                                                                    
         IF g_ooz.ooz07 = 'N' THEN
#No.MOD-9B0115 --begin
            LET l_sql="SELECT '',oma00,oma01,oma02,oma03,oma16,oma23,omc08-omc10,",
                      "       omc13       ,0,0,0,0,occ37,occ02",
#           LET l_sql="SELECT '',oma00,oma01,oma02,oma03,oma16,oma23,oma54t-oma55,",
#                  #---modi by kitty bug NO:A057
#                  #  "       oma56t-oma57,0,0,0,0,occ37,occ02",
#                     "       oma61       ,0,0,0,0,occ37,occ02",
#No.MOD-9B0115 --end
                     #No.FUN-A10098 -BEGIN-----
                     #"  FROM ",l_dbs CLIPPED,"oma_file,OUTER ",
                     #          l_dbs CLIPPED,"occ_file,",
                     #          l_dbs CLIPPED,"omc_file ",   #No.MOD-9B0115  
                      "  FROM oma_file LEFT OUTER JOIN occ_file ",
                      "    ON occ01 = oma03,omc_file ",
                     #No.FUN-A10098 -END-------
                      " WHERE oma02 <='",tm.rdate,"'",
                      "   AND (oma00 MATCHES '1*' OR oma00 matches '2*') ",
                      "   AND oma01 = omc01",                #No.MOD-9B0115 
                   #---modi by kitty bug NO:A057
                   #  "   AND (oma56t>oma57 OR ", # Thomas 98/12/04
                      "   AND (oma56t>oma57 OR ",
                     #No.FUN-A10098 -BEGIN-----
                     #"        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,
                     #"        ooa_file,",l_dbs CLIPPED,"oob_file",
                      "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                     #No.FUN-A10098 -END-------
                      "        WHERE ooa01=oob01 AND ooaconf !='X'",  #010804增
                     #"          AND ooa37='1' ",                     #FUN-B20020 #MOD-C80063 mark
                      "          AND ooa02 > '", tm.rdate,"'))",
                      "   AND ",tm.wc CLIPPED,
                     #"   AND occ_file.occ01 = oma_file.oma03 ", #No.FUN-A10098
                      "   AND omaconf = 'Y' AND omavoid = 'N' "
         ELSE
#No.MOD-9B0115 --begin                                                                                                                       
            LET l_sql="SELECT '',oma00,oma01,oma02,oma03,oma16,oma23,omc08-omc10,",                                                    
                      "       omc13       ,0,0,0,0,occ37,occ02",                                                                    
#           LET l_sql="SELECT '',oma00,oma01,oma02,oma03,oma16,oma23,oma54t-oma55,",                                                    
#                     "       oma61       ,0,0,0,0,occ37,occ02",                                                                    
#No.MOD-9B0115 --end
                     #No.FUN-A10098 -BEGIN-----
                     #"  FROM ",l_dbs CLIPPED,"oma_file,OUTER ",                                                                    
                     #          l_dbs CLIPPED,"occ_file,",                                                                          
                     #          l_dbs CLIPPED,"omc_file ",       #No.MOD-9B0115 
                      "  FROM oma_file LEFT OUTER JOIN occ_file ",
                      "    ON occ01 = oma03,omc_file ",
                     #No.FUN-A10098 -END-------
                      " WHERE oma02 <='",tm.rdate,"'",                                                                              
                      "   AND (oma00 MATCHES '1*' OR oma00 matches '2*') ",                                                         
                      "   AND oma01 = omc01 ",                   #No.MOD-9B0115 
                      "   AND (oma61 > 0    OR ",                                                                                   
                     #No.FUN-A10098 -BEGIN-----
                     #"        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,                                                         
                     #"        ooa_file,",l_dbs CLIPPED,"oob_file",                                                                 
                      "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                     #No.FUN-A10098 -END-------
                      "        WHERE ooa01=oob01 AND ooaconf !='X'",  #010804增
                     #"          AND ooa37='1' ",                     #FUN-B20020 #MOD-C80063 mark
                      "          AND ooa02 > '", tm.rdate,"'))",                                                                    
                      "   AND ",tm.wc CLIPPED,                                                                                      
                     #"   AND occ_file.occ01 = oma_file.oma03 ", #No.FUN-A10098
                      "   AND omaconf = 'Y' AND omavoid = 'N' "
         END IF
         #No.TQC-5C0086  --End
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr130_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr130_curs1 CURSOR FOR axrr130_prepare1
         FOREACH axrr130_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
           IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
         # LET sr.plant = plant[l_i]  No.FUN-A10098
           LET l_amt1 = 0
           LET l_amt2 = 0
           LET l_amt3 = 0
           LET l_amt4 = 0
           IF sr.oma00 MATCHES '1*' THEN  #----- 應收合計
              LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                        #No.FUN-A10098 -BEGIN-----
                        #"  FROM ",l_dbs CLIPPED,"oob_file,",
                        #          l_dbs CLIPPED,"ooa_file ",
                         "  FROM oob_file,ooa_file ",
                        #No.FUN-A10098 -END-------
                         " WHERE oob06='",sr.oma01,"'",
                         "   AND oob03='2' AND oob04='1' ",
                        #"   AND ooa37='1' ",                     #FUN-B20020 #MOD-C80063 mark
                         "   AND ooaconf='Y' AND ooa01=oob01 ",
                         "   AND ooa02 > '",tm.rdate,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              PREPARE ooa_pre1 FROM l_sql
              IF STATUS THEN
                 CALL cl_err('ooa_pre1',STATUS,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                 EXIT PROGRAM
                    
              END IF
              DECLARE ooa_curs1 CURSOR FOR ooa_pre1
              OPEN ooa_curs1
              FETCH ooa_curs1 INTO l_amt1,l_amt2
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
              IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
              LET sr.amt1 = sr.amt1 + l_amt1 # 外幣
              LET sr.amt2 = sr.amt2 + l_amt2 # 本幣
 
              LET l_sql ="SELECT SUM(oob09),SUM(oob10) ", #已收未確認
                        #No.FUN-A10098 -BEGIN-----
                        #"  FROM ",l_dbs CLIPPED,"oob_file,",
                        #          l_dbs CLIPPED,"ooa_file ",
                         "  FROM oob_file,ooa_file ",
                        #No.FUN-A10098 -END-------
                         " WHERE oob06='",sr.oma01,"'",
                         "   AND oob03='2' AND oob04='1' ",
                        #"   AND ooa37='1' ",                     #FUN-B20020 #MOD-C80063 mark
                         "   AND ooaconf='N' AND ooa01=oob01 " ,
                         "   AND ooa02 <='",tm.rdate,"'"   # 沖帳日期 > 基準日期
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              PREPARE ooa_pre3 FROM l_sql
              IF STATUS THEN
                 CALL cl_err('ooa_pre3',STATUS,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                 EXIT PROGRAM
                    
              END IF
              DECLARE ooa_curs3 CURSOR FOR ooa_pre3
              LET l_amt1 = 0
              LET l_amt2 = 0
              OPEN ooa_curs3
              FETCH ooa_curs3 INTO l_amt1,l_amt2
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
              IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
              LET sr.amta = l_amt1 # 外幣
              LET sr.amtb = l_amt2 # 本幣
              IF sr.amt1 > 0 OR sr.amt2 > 0 THEN # Thomas 98/10/08
                 LET sr.amtc=sr.amt1-sr.amta   #未收外幣 (amt1 - amta)
                 LET sr.amtd=sr.amt2-sr.amtb   #未收本幣 (amt2 - amtb)
#                 OUTPUT TO REPORT axrr130_rep(sr.*)       #NO.FUN-810010
#NO.FUN-810010------------------start-----------------------
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
             FROM azi_file
               WHERE azi01=sr.oma23
           EXECUTE insert_prep USING
             sr.plant,sr.oma00,sr.oma01,sr.oma02,sr.oma03,sr.oma16,sr.oma23,
             sr.amt1,sr.amt2,sr.amta,sr.amtb,sr.amtc,sr.amtd,sr.occ37,
             sr.occ02,t_azi04
#NO.FUN-810010------------------end-----------------------
              END IF # Thomas 98/10/13
           ELSE                    #----- 預收合計
              LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                        #No.FUN-A10098 -BEGIN-----
                        #"  FROM ",l_dbs CLIPPED,"oob_file,",
                        #          l_dbs CLIPPED,"ooa_file ",
                         "  FROM oob_file,ooa_file ",
                        #No.FUN-A10098 -END-------
                         " WHERE oob06='",sr.oma01,"'",
                         "   AND oob03='1' AND oob04='3' ",
                        #"   AND ooa37='1' ",                     #FUN-B20020 #MOD-C80063 mark
                         "   AND ooaconf='Y' AND ooa01=oob01 ",
                         "   AND ooa02 > '",tm.rdate,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              PREPARE ooa_pre2 FROM l_sql
              IF STATUS THEN
                 CALL cl_err('ooa_pre2',STATUS,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                 EXIT PROGRAM
                    
              END IF
              DECLARE ooa_curs2 CURSOR FOR ooa_pre2
              OPEN ooa_curs2
              FETCH ooa_curs2 INTO l_amt1,l_amt2
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
              IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
              LET sr.amt1 = sr.amt1 + l_amt1 # 外幣
              LET sr.amt2 = sr.amt2 + l_amt2 # 本幣
              LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                        #No.FUN-A10098 -BEGIN-----
                        #"  FROM ",l_dbs CLIPPED,"oob_file,",
                        #          l_dbs CLIPPED,"ooa_file ",
                         "  FROM oob_file,ooa_file ",
                        #No.FUN-A10098 -END-------
                         " WHERE oob06='",sr.oma01,"'",
                         "   AND oob03='1' AND oob04='3' ",
                         "   AND ooa01=oob01 ", # 未確認
                        #"   AND ooa37='1' ",                     #FUN-B20020 #MOD-C80063 mark
                         "   AND ooaconf='N'  ", # 未確認
                         "   AND ooa02 <= '",tm.rdate,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              PREPARE ooa_pre4 FROM l_sql
              IF STATUS THEN
                 CALL cl_err('ooa_pre4',STATUS,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                 EXIT PROGRAM
                    
              END IF
              DECLARE ooa_curs4 CURSOR FOR ooa_pre4
              OPEN ooa_curs4
              FETCH ooa_curs4 INTO l_amt1,l_amt2
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
              IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
              LET sr.amt1 = sr.amt1 - l_amt1 # 外幣
              LET sr.amt2 = sr.amt2 - l_amt2 # 本幣
#              OUTPUT TO REPORT axrr130_rep(sr.*)          #NO.FUN-810010
#NO.FUN-810010------------------start-----------------------
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
             FROM azi_file
               WHERE azi01=sr.oma23
           EXECUTE insert_prep USING
             sr.plant,sr.oma00,sr.oma01,sr.oma02,sr.oma03,sr.oma16,sr.oma23,
             sr.amt1,sr.amt2,sr.amta,sr.amtb,sr.amtc,sr.amtd,sr.occ37,
             sr.occ02,t_azi04
#NO.FUN-810010-----------end-----------
           END IF
         END FOREACH
    #END FOR  No.FUN-A10098
#     FINISH REPORT axrr130_rep                            #NO.FUN-810010
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)          #NO.FUN-810010
#NO.FUN-810010--------------start-------------
     LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'oma03') 
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc,";",tm.s,";",tm.sdate,";",g_azi04
     CALL cl_prt_cs3('axrr130',l_name,l_sql,g_str)
#NO.FUN-810010--------------end-------------
END FUNCTION
 
#NO.FUN-810010--------------start-------------
#REPORT axrr130_rep(sr)
#   DEFINE 
#   	  l_last_sw LIKE type_file.chr1,            #No.FUN-680123 VARCHAR(1)
#          sr        RECORD
#                    plant     LIKE azp_file.azp01,  #No.FUN-680123 VARCHAR(10)
#                    oma00     LIKE oma_file.oma00,
#                    oma01     LIKE oma_file.oma01,
#                    oma02     LIKE oma_file.oma02,
#                    oma03     LIKE oma_file.oma03,
#                    oma16     LIKE oma_file.oma16,
#                    oma23     LIKE oma_file.oma23,
#                    amt1      LIKE oma_file.oma55,   #外幣
#                    amt2      LIKE oma_file.oma55,   #本幣
#                    amta      LIKE type_file.num20_6,#已確認外幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
#                    amtb      LIKE type_file.num20_6,#已確認本幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
#                    amtc      LIKE type_file.num20_6,#未收外幣 (amt1 - amta) #No.FUN-680123 DEC(20,6)
#                    amtd      LIKE type_file.num20_6,#未收本幣 (amt2 - amtb) #No.FUN-680123 DEC(20,6)
#                    occ37     LIKE occ_file.occ37,
#                    occ02     LIKE occ_file.occ02
#                    END RECORD,
#          l_plant_o LIKE azp_file.azp01,             #No.FUN-680123 VARCHAR(10)
#          l_plant   LIKE azp_file.azp01,             #No.FUN-680123 VARCHAR(10)
#          l_desc    LIKE type_file.chr1000,          #No.FUN-680123 VARCHAR(22)
#          l_curr    LIKE azi_file.azi01,             #No.FUN-680123 VARCHAR(04)
#          l_occ02   LIKE occ_file.occ02,
#          l_i       LIKE type_file.num5,             #No.FUN-680123 SMALLINT
#          l_amt1,l_amt2,l_amt3,l_amt4  LIKE oma_file.oma55,
#          l_amta,l_amtb,l_amtc,l_amtd  LIKE type_file.num20_6,  #No.FUN-680123 DEC(20,6)
#          l_t1,l_t2 LIKE type_file.num20_6,          #No.FUN-680123  DEC(20,6)
#          l_npk05   LIKE npk_file.npk05,
#       #  l_nab021  LIKE nab_file.nab021,
#          l_occ37   LIKE occ_file.occ37,
#          l_npn02   LIKE npn_file.npn02,
#          l_nmh01   LIKE nmh_file.nmh01,
#          l_nmh24   LIKE nmh_file.nmh24,
#          l_nmh28   LIKE nmh_file.nmh28,
#          l_nmh37   LIKE nmh_file.nmh37
#  DEFINE  
#         #l_s_plant           VARCHAR(10)   #990506
#          l_s_plant           LIKE azp_file.azp01    #No.FUN-680123 VARCHAR(10)
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.occ37 DESC,sr.oma03,sr.plant,sr.oma23
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED            #No.FUN-580010
#No.FUN-580010--start
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
##     PRINT g_head CLIPPED,pageno_total  #No.TQC-770028 mark
#      PRINT                              #No.TQC-770028
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total  #No.TQC-770028
##No.FUN-580010--end
#      PRINT g_dash[1,g_len]
##No.FUN-580010--start
#     PRINT g_p1 CLIPPED
#     PRINT g_p2 CLIPPED
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            g_x[44],g_x[43],g_x[45],g_x[39],g_x[40],g_x[41],g_x[42]
#       PRINT g_dash1
##No.FUN-580010--end
#      LET l_last_sw = 'n'
 
#   BEFORE GROUP OF sr.oma03
#       PRINT COLUMN g_c[31],sr.oma03 CLIPPED;           #No.FUN-580010
#
#    BEFORE GROUP OF sr.plant
#       PRINT COLUMN g_c[32],sr.plant CLIPPED;                   #No.FUN-580010
#
#    BEFORE GROUP OF sr.oma23
#       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#         FROM azi_file
#        WHERE azi01=sr.oma23
#
#    AFTER GROUP OF sr.oma23
#       LET l_amt1= GROUP SUM(sr.amt1) WHERE sr.oma00 MATCHES '1*'   #應收外幣
#                                        AND sr.oma02 <= tm.sdate    #990420
#       LET l_amt2= GROUP SUM(sr.amt2) WHERE sr.oma00 MATCHES '1*'   #應收本幣
#                                        AND sr.oma02 <= tm.sdate    #990420
#       LET l_amt3= GROUP SUM(sr.amt1) WHERE sr.oma00 MATCHES '24'   #預收外幣
#                                        AND sr.oma02 <= tm.sdate    #990420
#       LET l_amt4= GROUP SUM(sr.amt2) WHERE sr.oma00 MATCHES '24'   #預收本幣
#                                        AND sr.oma02 <= tm.sdate    #990420
#       LET l_amta= GROUP SUM(sr.amta) WHERE sr.oma00 MATCHES '1*'   #已確認外幣
#                                        AND sr.oma02 <= tm.sdate    #990420
#       LET l_amtb= GROUP SUM(sr.amtb) WHERE sr.oma00 MATCHES '1*'   #已確認本幣
#                                        AND sr.oma02 <= tm.sdate    #990420
#       LET l_amtc= GROUP SUM(sr.amtc) WHERE sr.oma00 MATCHES '1*'   #未收外幣
#                                        AND sr.oma02 <= tm.sdate
#       LET l_amtd= GROUP SUM(sr.amtd) WHERE sr.oma00 MATCHES '1*'   #未收本幣
#                                        AND sr.oma02 <= tm.sdate
#       IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#       IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#       IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#       IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#       IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#       IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#       IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#       IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#       INSERT INTO r130m_tmp
#              VALUES(sr.plant,sr.occ37,sr.oma03,sr.oma23,
#                     l_amt1,l_amt2,l_amt3,l_amt4,
#                     l_amta,l_amtb,l_amtc,l_amtd)
#       PRINT COLUMN g_c[33],sr.oma23;                         #No.FUN-580010
##No.FUN-580010--start
 
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##No.FUN-580010--end
#    AFTER GROUP OF sr.oma03
#       PRINT COLUMN 01,sr.occ02[1,10] CLIPPED;
##No.FUN-580010--start
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       DECLARE tot_curs CURSOR FOR
#               SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                           SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#               FROM r130m_tmp
#               WHERE cust = sr.oma03
#               GROUP BY curr ORDER BY curr
#       PRINT '(', sr.oma03 CLIPPED, ')';
#       PRINT COLUMN g_c[32], g_x[15] CLIPPED;                 #No.FUN-580010
#       FOREACH tot_curs INTO l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                                    l_amta,l_amtb,l_amtc,l_amtd
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
#          PRINT COLUMN g_c[33],l_curr;            #No.FUN-380010
##No.FUN-580010--start
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##No.FUN-580010--end
#       END FOREACH
#       SKIP 1 LINE
 
 
#    AFTER GROUP OF sr.occ37
#       IF sr.occ37 MATCHES '[nN]' THEN
#          LET l_desc = g_x[18] CLIPPED
#       ELSE
#          LET l_desc = g_x[19] CLIPPED
#       END IF
#       PRINT l_desc CLIPPED;
#No.FUN-580010--start
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       DECLARE sub_curs CURSOR FOR
#               SELECT r130m_tmp.plant,curr,SUM(amt1),SUM(amt2),SUM(amt3),
#                      SUM(amt4),SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#               FROM r130m_tmp
#               WHERE type = sr.occ37
#               GROUP BY r130m_tmp.plant,curr ORDER BY r130m_tmp.plant,curr
#       PRINT g_x[15] CLIPPED;      #No.FUN-580010
# 990506 Ivy
#       FETCH  sub_curs INTO l_plant
#       LET  l_s_plant  =  l_plant
#       CLOSE  sub_curs
##
#       FOREACH sub_curs INTO l_plant,l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                             l_amta,l_amtb,l_amtc,l_amtd
##990506 Ivy
#          IF  l_plant  !=  l_s_plant  THEN
#              LET  l_s_plant  =  l_plant
##             PRINT  22  SPACES;             #No.FUN-580010
##No.FUN-580010--start
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#          END IF
 
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
##         PRINT COLUMN 12,l_plant,COLUMN 23,l_curr;
#          PRINT COLUMN g_c[32],l_plant CLIPPED,COLUMN g_c[33],l_curr CLIPPED;    #No.FUN-580010
##         CASE WHEN tm.s='1'
##No.FUN-580010--start
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##No.FUN-580010--end
#       END FOREACH
## 990506 Ivy
       #PRINT  11  SPACES, '---------- ';
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       DECLARE sub2_curs CURSOR FOR
#               SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),
#                      SUM(amt4),SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#               FROM r130m_tmp
#               WHERE type = sr.occ37
#               GROUP BY curr ORDER BY curr
#       FOREACH sub2_curs INTO l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                              l_amta,l_amtb,l_amtc,l_amtd
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
##         PRINT COLUMN 23,l_curr;
#          PRINT COLUMN g_c[33],l_curr;          #No.FUN-580010
##No.FUN-580010--start
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##No.FUn-580010--end
#      END FOREACH
#       PRINT g_dash1                       #No.FUN-580010
#
#    ON LAST ROW
#       #工廠總計
#       DECLARE tot_curs3 CURSOR FOR
#               SELECT r130m_tmp.plant,curr,
#                      SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                      SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#                FROM r130m_tmp
#                GROUP BY r130m_tmp.plant,curr ORDER BY r130m_tmp.plant,curr
#       LET l_plant_o = ' '
#       FOREACH tot_curs3 INTO l_plant,l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                                             l_amta,l_amtb,l_amtc,l_amtd
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          IF l_plant_o != l_plant THEN
##            PRINT l_plant CLIPPED,COLUMN 12,g_x[16] CLIPPED;
#             PRINT l_plant[1,10] CLIPPED;
#             PRINT COLUMN g_c[32],g_x[16] CLIPPED;              #No.FUN-580010
#          END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
#No.FUN-580010--start
#          PRINT COLUMN g_c[33],l_curr;
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##No.FUN-580010--end
#          LET l_plant_o = l_plant
#       END FOREACH
#NO.FUN-580010--start
#          PRINT COLUMN g_c[33],g_dash2[1,g_w[33]],
#                COLUMN g_c[34],g_dash2[1,g_w[34]],
#                COLUMN g_c[35],g_dash2[1,g_w[35]],
#                COLUMN g_c[36],g_dash2[1,g_w[36]],
#                COLUMN g_c[37],g_dash2[1,g_w[37]],
#                COLUMN g_c[38],g_dash2[1,g_w[38]],
#                COLUMN g_c[44],g_dash2[1,g_w[44]],
#                COLUMN g_c[43],g_dash2[1,g_w[43]],
#                COLUMN g_c[45],g_dash2[1,g_w[45]],
#                COLUMN g_c[39],g_dash2[1,g_w[39]],
#                COLUMN g_c[40],g_dash2[1,g_w[40]],
#                COLUMN g_c[41],g_dash2[1,g_w[41]],
#                COLUMN g_c[42],g_dash2[1,g_w[42]]
##No.FUN-580010--end
#       #公司總計
#       DECLARE tot_curs9 CURSOR FOR
#               SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
#                           SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#               FROM r130m_tmp
#               GROUP BY curr ORDER BY curr
##      PRINT COLUMN 08,g_x[17] CLIPPED;
#       PRINTX name=S1 COLUMN g_c[32],g_x[17] CLIPPED;      #No.FUN-580010
#       FOREACH tot_curs9 INTO l_curr,l_amt1,l_amt2,l_amt3,l_amt4,
#                                     l_amta,l_amtb,l_amtc,l_amtd
#
#          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#            FROM azi_file
#           WHERE azi01=l_curr
##         PRINT COLUMN 23,l_curr;
#          PRINT COLUMN g_c[33],l_curr CLIPPED;                #No.FUN-580010
##No.FUN-580010--start
#             PRINT COLUMN g_c[34],cl_numfor(l_amt1,34,t_azi04),
#                   COLUMN g_c[35],cl_numfor(l_amt2,35,g_azi04),
#                   COLUMN g_c[36],cl_numfor(l_amt3,36,t_azi04),
#                   COLUMN g_c[37],cl_numfor(l_amt4,37,g_azi04),
#                   COLUMN g_c[38],cl_numfor((l_amt1 - l_amt3),38,t_azi04),
#                   COLUMN g_c[44],cl_numfor((l_amt2 - l_amt4),44,g_azi04),
#                   COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#                   COLUMN g_c[45],cl_numfor(l_amtb,45,g_azi04),
#                   COLUMN g_c[39],cl_numfor(l_amtc,39,t_azi04),
#                   COLUMN g_c[40],cl_numfor(l_amtd,40,g_azi04),
#                   COLUMN g_c[41],cl_numfor(l_amt3,41,t_azi04),
#                   COLUMN g_c[42],cl_numfor(l_amt4,42,g_azi04)
##No.FUN-580010--end
#       END FOREACH
#       IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#          CALL cl_wcchp(tm.wc,'oma03') RETURNING tm.wc
#          PRINT g_dash[1,g_len]
#          #TQC-630166
#          #IF tm.s = '2' THEN
#          #   IF tm.wc[001,120] > ' ' THEN            # for 132
#          #      PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#          #   IF tm.wc[121,240] > ' ' THEN
#          #      PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#          #   IF tm.wc[241,300] > ' ' THEN
#          #      PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#          #ELSE
#          #   IF tm.wc[001,070] > ' ' THEN            # for 80
#          #      PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#          #   IF tm.wc[071,140] > ' ' THEN
#          #      PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#          #   IF tm.wc[141,210] > ' ' THEN
#          #      PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#          #   IF tm.wc[211,280] > ' ' THEN
#          #      PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
          #END IF
#          CALL cl_prt_pos_wc(tm.wc)
#          #END TQC-630166
#
#       END IF
#       LET l_last_sw = 'y'
#       PRINT g_dash[1,g_len]
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#    PAGE TRAILER
#       IF l_last_sw = 'n'
#          THEN PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          ELSE SKIP 2 LINE
#       END IF
#END REPORT
#Patch....NO.TQC-610037 <> #
