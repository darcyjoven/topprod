# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr120.4gl
# Descriptions...: 客戶應收未收帳款明細表
# Date & Author..: 98/07/06 By Danny
# Modify.........: 98/08/03 By Jimmy(增加報表可選擇輸出內容)
#                : 98/09/16 By Ivy讀取商用發票時(oga,ofa),若不存在之資料也需顯示
#                : 98/09/17 By Ivy  計算出之未沖預收需再減去己確認金額
#                : 98/09/17 By Ivy  業務用之合計(總計)值不等於明細加總,show錯值
# Modified By Thomas 增加資料截止日期 sdate 99/03/02
# Modify.........: No.FUN-4C0100 04/12/22 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.MOD-580227 05/08/23 By Smapmin 取消報表'商用發票號碼'欄位
# Modify.........: No.TQC-5C0086 05/12/19 By Carrier AR月底重評修改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0102 06/11/15 By johnray 報表修改
# Modify.........: No.TQC-6B0007 06/12/11 By johnray 報表修改
# Modify.........: No.MOD-730058 07/04/03 By Smapmin 增加是否列印待抵帳款選項
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/19 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: No:FUN-B20020 11/02/15 By destiny 增加收款单条件
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING,                # Where condition
              rdate   LIKE type_file.dat,    # 發票截止日期 #No.FUN-680123 DATE
              sdate   LIKE type_file.dat,    # 資料截止日期 #No.FUN-680123 DATE
             # Prog. Version..: '5.30.06-13.03.12(01),              # Choose report   #TQC-610059
              y       LIKE type_file.chr1,    #MOD-730058
              more    LIKE type_file.chr1    # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD,
        #plant        ARRAY[12] OF LIKE azp_file.azp01,   #工廠編號 #No.FUN-680123 ARRAY[12] OF VARCHAR(12) #No.FUN-A10098
         g_sql        STRING,
         g_atot       LIKE type_file.num5,                #No.FUN-680123 SMALLINT
         g_p1,g_p2    LIKE type_file.chr1000              #No.FUN-680123 VARCHAR(1000)
 
DEFINE   g_i          LIKE type_file.num5                 #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i            LIKE type_file.num5                 #No.FUN-680123 SMALLINT
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
 
       #No.FUN-680123 begin
   CREATE TEMP TABLE r120m_tmp
     (type LIKE type_file.chr1,  
      plant LIKE azp_file.azp01,
      cust LIKE oma_file.oma03,
      curr LIKE azi_file.azi01,
      oma02 LIKE oma_file.oma02,
      amt1 LIKE type_file.num20_6,
      amt2 LIKE type_file.num20_6,
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
   LET tm.rdate = ARG_VAL(8)
   LET tm.sdate = ARG_VAL(9)
  #No.FUN-A10098 -BEGIN-----
  #LET plant[1] = ARG_VAL(10)
  #LET plant[2] = ARG_VAL(11)
  #LET plant[3] = ARG_VAL(12)
  #LET plant[4] = ARG_VAL(13)
  #LET plant[5] = ARG_VAL(14)
  #LET plant[6] = ARG_VAL(15)
  #LET plant[7] = ARG_VAL(16)
  #LET plant[8] = ARG_VAL(17)
  #LET plant[9] = ARG_VAL(18)
  #LET plant[10] = ARG_VAL(19)
  #LET plant[11] = ARG_VAL(20)
  #LET plant[12] = ARG_VAL(21)
  #FOR i = 1 TO 12
  #    IF NOT cl_null(ARG_VAL(i+9)) THEN
  #       LET g_atot = g_atot + 1
  #    END IF
  #END FOR
  ##-----END TQC-610059-----
  #LET tm.y = ARG_VAL(22)   #MOD-730058
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(23)
  #LET g_rep_clas = ARG_VAL(24)
  #LET g_template = ARG_VAL(25)
  ##No.FUN-570264 ---end---
   LET tm.y = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
  #No.FUN-A10098 -END-------
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL axrr120_tm(0,0)        # Input print condition
      ELSE CALL axrr120()              # Read data and create out-file
   END IF
   DROP TABLE r120m_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr120_tm(p_row,p_col)
  DEFINE  p_row,p_col   LIKE type_file.num5,     #No.FUN-680123 SMALLINT
          l_ac          LIKE type_file.num10,    #No.FUN-680123 INTEGER
          l_cmd         LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW axrr120_w AT p_row,p_col
        WITH FORM "axr/42f/axrr120"
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
#  LET plant[1]=g_plant  #預設現行工廠 #No.FUN-A10098
   LET tm.rdate = g_today
   LET tm.sdate = g_today
   LET tm.y = 'Y'   #MOD-730058
   LET tm.more = 'N'
   #LET tm.s = '1'   #TQC-610059
WHILE TRUE
   DELETE FROM r120m_tmp
   CONSTRUCT BY NAME tm.wc ON oma03
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
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#No.FUN-A10098 -BEGIN-------
#  #----- 工廠編號 -B---#
#  CALL SET_COUNT(1)    # initial array argument
#  INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.*
#
#      BEFORE ROW               #No.FUN-560239
#         LET l_ac = ARR_CURR()
#
#      AFTER FIELD plant
#       # LET l_ac = ARR_CURR()   #No.FUN-560239 Mark
#         IF NOT cl_null(plant[l_ac]) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = plant[l_ac]
#            IF STATUS THEN
#               CALL cl_err('sel azp',STATUS,1)  #No.FUN-660116
#               CALL cl_err3("sel","azp_file",plant[l_ac],"",STATUS,"","sel azp",1)   #No.FUN-660116
#               NEXT FIELD plant 
#            END IF
#            FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
#                IF plant[i] = plant[l_ac] THEN
#                   CALL cl_err('','aom-492',1) NEXT FIELD plant
#                END IF
#            END FOR
#            IF NOT s_chkdbs(g_user,plant[l_ac],g_rlang) THEN
#               NEXT FIELD plant
#            END IF
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
#  IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW axrr120_w RETURN END IF
#No.FUN-A10098 -END-------
 
   #INPUT BY NAME tm.rdate,tm.sdate,tm.more WITHOUT DEFAULTS   #MOD-730058
   INPUT BY NAME tm.rdate,tm.sdate,tm.y,tm.more WITHOUT DEFAULTS   #MOD-730058
#  INPUT BY NAME tm.rdate,tm.sdate,tm.s,tm.more WITHOUT DEFAULTS
      AFTER FIELD rdate
         IF cl_null(tm.rdate) THEN NEXT FIELD rdate END IF
      AFTER FIELD sdate
         IF cl_null(tm.sdate) THEN NEXT FIELD sdate END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      AFTER INPUT
         IF  tm.rdate < tm.sdate  THEN
             ERROR "InvoDate < DataDate --> Error"
             NEXT FIELD  rdate
         ENd IF
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
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr120_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr120'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr120','9031',1)
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
                         " '",tm.rdate CLIPPED,"'",
                         #-----TQC-610059---------
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
                         " '",tm.y CLIPPED,"'",   #MOD-730058
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr120',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr120_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr120()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr120_w
END FUNCTION
 
FUNCTION axrr120()
   DEFINE 
          l_name    LIKE type_file.chr20,        # External(Disk) file name   #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE za_file.za05,           #No.FUN-680123 VARCHAR(40)
          l_i,l_j   LIKE type_file.num5,         #No.FUN-680123 SMALLINT 
          l_dbs     LIKE type_file.chr21,        #No.FUN-680123 VARCHAR(22)
          l_npk05   LIKE npk_file.npk05,
          l_nmh11   LIKE nmh_file.nmh11,
          l_nmh01   LIKE nmh_file.nmh01,
          l_npn02   LIKE npn_file.npn02,
          l_amta    LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6)
          l_amtb    LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6)
          l_amt1,l_amt2 LIKE oma_file.oma55,
          l_amt3,l_amt4 LIKE oma_file.oma55,
          sr        RECORD
                    plant     LIKE azp_file.azp01,    #No.FUN-680123 VARCHAR(10)
                    oma00     LIKE oma_file.oma00,    #帳款類別
                    oma01     LIKE oma_file.oma01,    #帳款編號
                    oma03     LIKE oma_file.oma03,    #客戶編號
                    oma032    LIKE oma_file.oma032,   #簡稱
                    oma02     LIKE oma_file.oma02,    #發票日期
                    oma10     LIKE oma_file.oma10,    #發票號碼
                    oma11     LIKE oma_file.oma11,    #應收款日
                    oma14     LIKE oma_file.oma14,    #人員編號
                    oma16     LIKE oma_file.oma16,    #訂單編號
                    oma23     LIKE oma_file.oma23,    #幣別
                    gen01     LIKE gen_file.gen01,    #業務員編號
                    gen02     LIKE gen_file.gen02,    #業務員
                    amt1      LIKE oma_file.oma55,    #應收外幣
                    amt2      LIKE oma_file.oma57,    #應收本幣
                    amta      LIKE type_file.num20_6, #已確認外幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtb      LIKE type_file.num20_6, #已確認本幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtc      LIKE type_file.num20_6, #未收外幣 (amt1 - amta) #No.FUN-680123 DEC(20,6)
                    amtd      LIKE type_file.num20_6  #未收本幣 (amt2 - amtb) #No.FUN-680123 DEC(20,6)
#                   ofa01     LIKE ofa_file.ofa01
                    END RECORD
 
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
 
 
     CALL cl_outnam('axrr120') RETURNING l_name
     START REPORT axrr120_rep TO l_name
     LET g_pageno = 0

    #No.FUN-A10098 -BEGIN----- 
    #LET l_i = 1
    #FOR l_i = 1 TO g_atot
    #    IF cl_null(plant[l_i]) THEN CONTINUE FOR END IF
    #    SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = plant[l_i]
    #    LET l_dbs = s_dbstring(l_dbs CLIPPED)
    #No.FUN-A10098 -END-------
         #No.TQC-5C0086  --Begin                                                                                                    
         IF g_ooz.ooz07 = 'N' THEN
            LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma10,oma11,",
                    #--modi by kitty Bug NO:A057
                    # "       oma14,oma16,oma23,gen01,gen02,oma54t-oma55,oma56t-oma57,",
                      "       oma14,oma16,oma23,gen01,gen02,oma54t-oma55,oma61,",
                      "       0,0,0,0",
                    #No.FUN-A10098 -BEGIN-----
                    # "  FROM ",l_dbs CLIPPED,"oma_file,OUTER ",
                    #           l_dbs CLIPPED,"gen_file  ",
                      "  FROM oma_file LEFT OUTER JOIN gen_file ON gen01=oma14",
                    #No.FUN-A10098 -END-------
                      " WHERE oma02 <='",tm.rdate,"'",
                      "   AND (oma00 MATCHES '1*' OR oma00 matches '2*') ",
                      "   AND omaconf = 'Y' AND omavoid = 'N' ",
                    #--modi by kitty Bug NO:A057
                    # "   AND (oma56t>oma57 OR ",
                      "   AND (oma61>0      OR ",
                    #No.FUN-A10098 -BEGIN-----
                    # "        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,
                    # "        ooa_file,",l_dbs CLIPPED,"oob_file",
                      "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                    #No.FUN-A10098 -END-------
                      "        WHERE ooa01=oob01 AND ooaconf !='X' ", #010804增
                      "   AND ooa37='1' ",               #FUN-B20020
                      "   AND ooa02 > '", tm.rdate,"'))",
                    # "   AND gen_file.gen01 = oma_file.oma14 ", #No.FUN-A10098
                      "   AND ",tm.wc CLIPPED
         ELSE                                                                                                                       
            LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma10,oma11,",                                                      
                      "       oma14,oma16,oma23,gen01,gen02,oma54t-oma55,oma61,",
                      "       0,0,0,0",
                     #No.FUN-A10098 -BEGIN-----
                     #"  FROM ",l_dbs CLIPPED,"oma_file,OUTER ",
                     #          l_dbs CLIPPED,"gen_file  ",
                      "  FROM oma_file LEFT OUTER JOIN gen_file ON gen01=oma14",
                     #No.FUN-A10098 -END-------
                      " WHERE oma02 <='",tm.rdate,"'",                                                                              
                      "   AND (oma00 MATCHES '1*' OR oma00 matches '2*') ",                                                         
                      "   AND omaconf = 'Y' AND omavoid = 'N' ",                                                                    
                      "   AND (oma61>0      OR ",
                     #No.FUN-A10098 -BEGIN-----
                     #"        oma01 IN (SELECT oob06 FROM ",l_dbs CLIPPED,
                     #"        ooa_file,",l_dbs CLIPPED,"oob_file",
                      "        oma01 IN (SELECT oob06 FROM ooa_file,oob_file",
                     #No.FUN-A10098 -END-------
                      "        WHERE ooa01=oob01 AND ooaconf !='X' ", #010804增   
                      "   AND ooa37='1' ",               #FUN-B20020                                                  
                      "   AND ooa02 > '", tm.rdate,"'))",                                                                           
                     #"   AND gen_file.gen01 = oma_file.oma14 ", #No.FUN-A10098
                      "   AND ",tm.wc CLIPPED
         END IF                                                                                                                     
         #No.TQC-5C0086  --End
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr120_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr120_curs1 CURSOR FOR axrr120_prepare1
 
         FOREACH axrr120_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
           IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
         # LET sr.plant = plant[l_i]  #No.FUN-A10098
           LET l_amt1 = 0
           LET l_amt2 = 0
           LET l_amt3 = 0
           LET l_amt4 = 0
           IF sr.oma00 MATCHES '1*' THEN
              LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                        #No.FUN-A10098 -BEGIN-----
                        #"  FROM ",l_dbs CLIPPED,"oob_file,",
                        #          l_dbs CLIPPED,"ooa_file",
                         "  FROM oob_file,ooa_file",
                        #No.FUN-A10098 -END-------
                         " WHERE oob06='",sr.oma01,"'",
                         "   AND oob03='2' AND oob04='1' ", # 貸項,應收帳款
                         "   AND ooaconf='Y' AND ooa01=oob01 ", # 已確認
                         "   AND ooa37='1' ",               #FUN-B20020
                         "   AND ooa02 > '",tm.rdate,"'"   # 沖帳日期 > 基準日期
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
              PREPARE ooa_pre FROM l_sql
              IF STATUS THEN CALL cl_err('ooa_pre',STATUS,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                 EXIT PROGRAM 
              END IF
              DECLARE ooa_curs CURSOR FOR ooa_pre
              OPEN ooa_curs
              FETCH ooa_curs INTO l_amt1,l_amt2
              IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
              IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
              LET sr.amt1 = sr.amt1 + l_amt1
              LET sr.amt2 = sr.amt2 + l_amt2
              LET l_amt1 = 0
              LET l_amt2 = 0
              LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",  #統計已沖帳未確認
                        #No.FUN-A10098 -BEGIN-----
                        #"  FROM ",l_dbs CLIPPED,"oob_file,",
                        #          l_dbs CLIPPED,"ooa_file",
                         "  FROM oob_file,ooa_file",
                        #No.FUN-A10098 -END-------
                         " WHERE oob06='",sr.oma01,"'",
                         "   AND oob03='2' AND oob04='1' ",     # 貸項,應收帳款
                         "   AND ooa01=oob01 ", # 未確認
                         "   AND ooa37='1' ",               #FUN-B20020
                         "   AND ooaconf='N'  ", # 未確認
                         "   AND ooa02 <='",tm.rdate,"'"   # 沖帳日期 > 基準日期
# Thomas 98/09/08 加上日期考量
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
              LET sr.amta = l_amt1
              LET sr.amtb = l_amt2
              IF sr.amt1 > 0 OR sr.amt2 > 0 THEN
                 LET sr.amtc=sr.amt1-sr.amta   #未收外幣 (amt1 - amta)
                 LET sr.amtd=sr.amt2-sr.amtb   #未收本幣 (amt2 - amtb)
                 INSERT INTO r120m_tmp
                        VALUES('1',sr.plant,sr.oma03,sr.oma23,sr.oma02,
                               sr.amt1,sr.amt2,
                               sr.amta,sr.amtb,sr.amtc,sr.amtd)
                 IF STATUS OR STATUS=100 THEN
#                   CALL cl_err('ins tmp',STATUS,1)  #No.FUN-660116
                    CALL cl_err3("ins","r120m_tmp",sr.plant,sr.oma03,STATUS,"","ins tmp",1)   #No.FUN-660116
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                    EXIT PROGRAM 
                 END IF
                 OUTPUT TO REPORT axrr120_rep(sr.*)
              END IF
           ELSE
            #IF sr.oma02 < '99/01/01' AND sr.oma00 = '21' THEN CONTINUE FOREACH END IF
              IF tm.y='Y' THEN   #MOD-730058
                 LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                           #No.FUN-A10098 -BEGIN-----
                           #"  FROM ",l_dbs CLIPPED,"oob_file,",
                           #          l_dbs CLIPPED,"ooa_file ",
                            "  FROM oob_file,ooa_file ",
                           #No.FUN-A10098 -END-------
                            " WHERE oob06='",sr.oma01,"'",
                            "   AND oob03='1' AND oob04='3' ",
                            "   AND ooaconf='Y' AND ooa01=oob01 ",
                            "   AND ooa37='1' ",               #FUN-B20020
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
                 INSERT INTO r120m_tmp
                        VALUES('2',sr.plant,sr.oma03,sr.oma23,sr.oma02,
                               sr.amt1,sr.amt2,
                               sr.amta,sr.amtb,sr.amtc,sr.amtd)
                 IF STATUS OR STATUS=100 THEN
#                   CALL cl_err('ins tmp #2',STATUS,1)   #No.FUN-660116
                    CALL cl_err3("ins","r120m_tmp",sr.plant,sr.oma03,SQLCA.sqlcode,"","ins tmp #2",1)   #No.FUN-660116
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                    EXIT PROGRAM 
                 END IF
                 OUTPUT TO REPORT axrr120_rep(sr.*)    #NO:4731
              END IF   #MOD-730058
           END IF
         END FOREACH
         LET l_sql = "SELECT nmh03,nmh11,nmh02-nmh17, ",
                   # " (nmh02-nmh17)*nmh28,nmh01 ",    #bug no:A049
                     " nmh40,nmh01 ",
                     " FROM nmh_file ",
                     " LEFT OUTER JOIN gem_file ON gem01 = nmh15", #No.FUN-A10098 Add
                     "    WHERE nmh24='8' ",   # 兌現才可拿來算
                     "    AND nmh11 in ( SELECT cust from r120m_tmp ",
                   #No.FUN-A10098 -BEGIN-----
                   # "    WHERE type = '1' AND plant='",plant[l_i],"')",
                   # "   AND nmh15 in ",
                   #" (SELECT gem01 FROM gem_file WHERE gem04='",plant[l_i],
                   # "') "
                     "    WHERE type = '1')"
                   #No.FUN-A10098 -END-------
         PREPARE axrr120_preparea FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
         END IF
         DECLARE axrr120_cursa CURSOR FOR axrr120_preparea
         FOREACH axrr120_cursa INTO l_npk05,l_nmh11,l_amta,l_amtb,l_nmh01
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           SELECT npn02 INTO l_npn02 from npo_file,npn_file
            WHERE npo03 = l_nmh01
              AND npo01 = npn01 AND npn03 = '8' AND npnconf <> 'X'
           IF STATUS OR (l_npn02 > tm.rdate) THEN CONTINUE FOREACH END IF
           IF l_amta!=0 OR l_amtb != 0 THEN
              INSERT INTO r120m_tmp
                    #VALUES('2',plant[l_i],l_nmh11,l_npk05,"",l_amta, #No.FUN-A10098
                     VALUES('2','',l_nmh11,l_npk05,"",l_amta,         #No.FUN-A10098
                            l_amtb,0,0,0,0)
              IF STATUS OR STATUS=100 THEN
#                 CALL cl_err('ins tmp #2',STATUS,1)  #No.FUN-660116
                 #CALL cl_err3("ins","r120m_tmp",plant[l_i],l_nmh11,STATUS,"","ins tmp #2",1)   #No.FUN-660116 #No.FUN-A10098
                  CALL cl_err3("ins","r120m_tmp",'',l_nmh11,STATUS,"","ins tmp #2",1) #No.FUN-A10098
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                  EXIT PROGRAM 
              END IF
           END IF
         END FOREACH
 
   # END FOR  #No.FUN-A10098
     FINISH REPORT axrr120_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axrr120_rep(sr)
   DEFINE
          l_last_sw LIKE type_file.chr1,                  #No.FUN-680123 VARCHAR(1)
          g_head1   STRING,
          sr        RECORD
                    plant     LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
                    oma00     LIKE oma_file.oma00,
                    oma01     LIKE oma_file.oma01,
                    oma03     LIKE oma_file.oma03,
                    oma032    LIKE oma_file.oma032,
                    oma02     LIKE oma_file.oma02,
                    oma10     LIKE oma_file.oma10,
                    oma11     LIKE oma_file.oma11,
                    oma14     LIKE oma_file.oma14,
                    oma16     LIKE oma_file.oma16,
                    oma23     LIKE oma_file.oma23,
                    gen01     LIKE gen_file.gen01,
                    gen02     LIKE gen_file.gen02,
                    amt1      LIKE oma_file.oma55,   #應收外幣
                    amt2      LIKE oma_file.oma57,   #應收本幣
                    amta      LIKE type_file.num20_6,#已確認外幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtb      LIKE type_file.num20_6,#已確認本幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtc      LIKE type_file.num20_6,#未收外幣 (amt1 - amta) #No.FUN-680123 DEC(20,6)
                    amtd      LIKE type_file.num20_6 #未收本幣 (amt2 - amtb) #No.FUN-680123 DEC(20,6)
#                   ofa01     LIKE ofa_file.ofa01
                    END RECORD,
          l_plant_o LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
          l_plant   LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
 #        l_ogaa49  LIKE ogaa_file.ogaa49,      #MOD-580227
          l_curr    LIKE azi_file.azi01,        #No.FUN-680123 VARCHAR(04)
          l_i       LIKE type_file.num5,        #No.FUN-680123 SMALLINT
          l_amt1,l_amt2  LIKE oma_file.oma55,
          l_amt3,l_amt4  LIKE oma_file.oma55,
          l_amta    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
          l_amtb    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
          l_amtc    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
          l_amtd    LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
 #        l_db      VARCHAR(22),                   #MOD-580227
          l_oag02   LIKE oag_file.oag02,
          str       STRING
  DEFINE  l_flag    LIKE type_file.chr1         #No.FUN-A10098
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.oma03,sr.plant,sr.oma02, sr.oma10 #No.FUN-A10098
  ORDER BY sr.oma03,sr.oma02, sr.oma10          #No.FUN-A10098
 
  FORMAT
   PAGE HEADER
 
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6B0007
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6B0007
      LET g_head1 = g_x[9] CLIPPED,tm.rdate
      PRINT g_head1
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
 #            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]   #MOD-580227
             g_x[39],g_x[40],g_x[41],g_x[42]   #MOD-580227
      PRINT g_dash1
      LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.oma03
       PRINT COLUMN g_c[31],sr.oma03,COLUMN g_c[32],sr.oma032;
 
    BEFORE GROUP OF sr.plant
 #MOD-580227
#        SELECT azp03 INTO l_db FROM azp_file WHERE azp01 = sr.plant
#        let l_db = l_db clipped,":"
#        LET g_sql = "SELECT ogaa49 FROM ", l_db CLIPPED, "ogaa_file WHERE ",
#                    "ogaa01 = ?"
#        PREPARE ogaa_stm FROM g_sql
#        DECLARE cur_ogaa CURSOR FOR ogaa_stm
 #END MOD-580227
 
    ON EVERY ROW
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
         FROM azi_file
        WHERE azi01=sr.oma23
 #MOD-580227
#       OPEN cur_ogaa USING sr.oma16
#       FETCH cur_ogaa INTO l_ogaa49
#       IF  SQLCA.SQLCODE  !=  0  THEN  LET  l_ogaa49  =  " "  END IF
#       CLOSE cur_ogaa
 #END MOD-580227
       IF sr.oma02<= tm.sdate THEN
       PRINT COLUMN g_c[33],sr.gen01,
             COLUMN g_c[34],sr.gen02,
             COLUMN g_c[35],sr.oma10,
             COLUMN g_c[36],sr.oma02,
             COLUMN g_c[37],sr.oma16,
 #             COLUMN g_c[38],l_ogaa49[1,13],   #MOD-580227
             COLUMN g_c[39],sr.oma11,
             COLUMN g_c[40],sr.oma23;
       #No.8908
       IF sr.oma00 MATCHES '2*' THEN
          LET sr.amt1=sr.amt1*-1
          LET sr.amt2=sr.amt2*-1
       END IF
                 PRINT COLUMN g_c[41],cl_numfor(sr.amt1,41,t_azi04),
                       COLUMN g_c[42],cl_numfor(sr.amt2,42,g_azi04)
      END IF
 
    AFTER GROUP OF sr.oma03
       DECLARE tot_curs CURSOR FOR
      #  SELECT r120m_tmp.plant,curr,SUM(amt1),SUM(amt2), #No.FUN-A10098
         SELECT curr,SUM(amt1),SUM(amt2),                 #No.FUN-A10098
                SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
           FROM r120m_tmp
          WHERE cust = sr.oma03 AND type = '1'
           AND  oma02 <= tm.sdate
      #   GROUP BY r120m_tmp.plant,curr ORDER BY r120m_tmp.plant,curr #No.FUN-A10098
          GROUP BY curr ORDER BY curr #No.FUN-A10098
      #LET l_plant_o = ' '            #No.FUN-A10098
          PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
                COLUMN g_c[41],g_dash2[1,g_w[41]],
                COLUMN g_c[42],g_dash2[1,g_w[42]]
       LET l_i = 0
       LET l_flag = 'Y'  #No.FUN-A10098
      #FOREACH tot_curs INTO l_plant,l_curr,l_amt1,l_amt2, #No.FUN-A10098
       FOREACH tot_curs INTO l_curr,l_amt1,l_amt2,         #No.FUN-A10098
                             l_amta,l_amtb,l_amtc,l_amtd
          SELECT SUM(amt1),SUM(amt2) INTO l_amt3,l_amt4 FROM r120m_tmp
         #No.FUN-A10098 -BEGIN-----
         # WHERE r120m_tmp.plant = l_plant
         #   AND cust = sr.oma03 AND curr = l_curr AND type = '2'
           WHERE cust = sr.oma03 AND curr = l_curr AND type = '2'
         #No.FUN-A10098 -END-------
             AND  oma02 <= tm.sdate    # Ivy 99/03/02
 
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
            FROM azi_file
           WHERE azi01=l_curr
 
          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
          LET l_i = l_i + 1
         #IF l_plant_o != l_plant THEN  #No.FUN-A10098
          IF l_flag = 'Y' THEN          #No.FUN-A10098
             SELECT oag02 INTO l_oag02 from occ_file,oag_file
                WHERE occ01 = sr.oma03 AND occ45 = oag01
         #   LET str = '(',l_plant CLIPPED,')'  #No.FUN-A10098
             LET str = ' '                      #No.FUN-A10098
             LET l_flag = 'N'                   #No.FUN-A10098
             PRINT COLUMN g_c[32],l_oag02 CLIPPED,
                   COLUMN g_c[35],sr.oma032 CLIPPED,
                   COLUMN g_c[37],str CLIPPED;
#                   COLUMN g_c[38],g_x[10] CLIPPED;   #No.TQC-6A0102
                   #COLUMN g_c[39],g_x[10] CLIPPED;   #No.TQC-6A0102   #MOD-730058
          END IF
          PRINT COLUMN g_c[39],g_x[10] CLIPPED,   #MOD-730058
                COLUMN g_c[40],l_curr,
                COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi05),
                COLUMN g_c[42],cl_numfor(l_amt2,42,g_azi05)
          #-----MOD-730058---------
          IF tm.y = 'Y' THEN
             PRINT COLUMN g_c[39],g_x[14] CLIPPED,
                   COLUMN g_c[41],cl_numfor(l_amt3*-1,41,t_azi05),
                   COLUMN g_c[42],cl_numfor(l_amt4*-1,42,g_azi05)
          END IF
          #-----END MOD-730058-----
         #LET l_plant_o = l_plant  #No.FUN-A10098
 
       END FOREACH
       skip  1 line
 
    ON LAST ROW
      #No.FUN-A10098 -BEGIN-----
      ##工廠總計
      #DECLARE tot_curs2 CURSOR FOR
      #   SELECT r120m_tmp.plant,curr,SUM(amt1),SUM(amt2),
      #          SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
      #     FROM r120m_tmp
      #    WHERE type = '1'
      #     AND  oma02  <=  tm.sdate       #Ivy 99/03/02
      #    GROUP BY r120m_tmp.plant,curr  ORDER BY r120m_tmp.plant,curr
      #LET l_plant_o = ' '
      #LET l_i = 0
      #FOREACH tot_curs2 INTO l_plant,l_curr,l_amt1,l_amt2,
      #                       l_amta,l_amtb,l_amtc,l_amtd
      #   SELECT SUM(amt1),SUM(amt2) INTO l_amt3,l_amt4 FROM r120m_tmp
      #    WHERE r120m_tmp.plant = l_plant
      #      AND curr = l_curr AND type = '2'
      #       AND  oma02  <=  tm.sdate       #Ivy 99/03/02
 
      #   SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
      #     FROM azi_file
      #    WHERE azi01=l_curr
      #   IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
      #   IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
      #   IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
      #   IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
      #   IF cl_null(l_amta) THEN LET l_amta = 0 END IF
      #   IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
      #   IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
      #   IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
      #   LET l_i = l_i + 1
      #   IF l_plant_o != l_plant THEN
      #            PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
      #                  COLUMN g_c[41],g_dash2[1,g_w[41]],
      #                  COLUMN g_c[42],g_dash2[1,g_w[42]]
      #      PRINT COLUMN g_c[37],l_plant CLIPPED;
#     #             COLUMN g_c[38],g_x[11] CLIPPED;      #No.TQC-6A0102
      #      #      COLUMN g_c[39],g_x[11] CLIPPED;      #No.TQC-6A0102   #MOD-730058
      #   END IF
      #   PRINT COLUMN g_c[39],g_x[11] CLIPPED,   #MOD-730058
      #         COLUMN g_c[40],l_curr,
      #         COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi05),
      #         COLUMN g_c[42],cl_numfor(l_amt2,42,g_azi05)
      #         #No.8908
#     #          PRINT COLUMN g_c[38],g_x[14] CLIPPED,  #No.TQC-6A0102
      #   IF tm.y = 'Y'   THEN   #MOD-730058
      #         PRINT COLUMN g_c[39],g_x[14] CLIPPED,  #No.TQC-6A0102
      #               COLUMN g_c[41], cl_numfor(l_amt3*-1,41,t_azi05),
      #               COLUMN g_c[42], cl_numfor(l_amt4*-1,42,g_azi05)
      #   END IF   #MOD-730058
      #   LET l_plant_o = l_plant
      #END FOREACH
      #            PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
      #                  COLUMN g_c[41],g_dash2[1,g_w[41]],
      #                  COLUMN g_c[42],g_dash2[1,g_w[42]]
      #No.FUN-A10098 -END-------
       #公司總計
       DECLARE tot_curs3 CURSOR FOR
           SELECT curr,SUM(amt1),SUM(amt2),SUM(amta),
                  SUM(amtb),SUM(amtc),SUM(amtd)
             FROM r120m_tmp
            WHERE type = '1'
            AND  oma02  <=  tm.sdate       #Ivy 99/03/02
            GROUP BY curr ORDER BY curr
#       PRINT COLUMN g_c[38],g_x[12] CLIPPED;      #No.TQC-6A0102
       #PRINT COLUMN g_c[39],g_x[12] CLIPPED;      #No.TQC-6A0102   #MOD-730058
       FOREACH tot_curs3 INTO l_curr,l_amt1,l_amt2,
                              l_amta,l_amtb,l_amtc,l_amtd
          SELECT SUM(amt1),SUM(amt2) INTO l_amt3,l_amt4 FROM r120m_tmp
           WHERE curr = l_curr AND type = '2'
            AND  oma02  <=  tm.sdate       #Ivy 99/03/02
          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
          PRINT COLUMN g_c[39],g_x[12] CLIPPED,   #MOD-730058
                COLUMN g_c[40],l_curr,
                COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi05),
                COLUMN g_c[42],cl_numfor(l_amt2,42,g_azi05)
          #-----MOD-730058---------
          IF tm.y = 'Y' THEN
             PRINT COLUMN g_c[39],g_x[14] CLIPPED,
                   COLUMN g_c[41],cl_numfor(l_amt3*-1,41,t_azi05),
                   COLUMN g_c[42],cl_numfor(l_amt4*-1,42,g_azi05)
          END IF
          #-----END MOD-730058-----
       END FOREACH
       IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
          CALL cl_wcchp(tm.wc,'oma03') RETURNING tm.wc
          PRINT g_dash[1,g_len]
          #TQC-630166
          #IF tm.s = '2' THEN
          #   IF tm.wc[001,120] > ' ' THEN            # for 132
          #      PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
          #   IF tm.wc[121,240] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
          #   IF tm.wc[241,300] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
          #ELSE
          #   IF tm.wc[001,070] > ' ' THEN            # for 80
          #      PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
          #   IF tm.wc[071,140] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
          #   IF tm.wc[141,210] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
          #   IF tm.wc[211,280] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
          CALL cl_prt_pos_wc(tm.wc)
          #END TQC-630166
 
          #END IF
       END IF
       LET l_last_sw = 'y'
       PRINT g_dash[1,g_len]
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
    PAGE TRAILER
       IF l_last_sw = 'n'
          THEN PRINT g_dash[1,g_len]
               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
          ELSE SKIP 2 LINE
       END IF
END REPORT
