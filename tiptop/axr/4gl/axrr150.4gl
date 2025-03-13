# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: axrr150.4gl
# Descriptions...: 客戶逾期應收帳款明細表
# Date & Author..: 98/08/07 By Jimmy(增加報表可選擇輸出內容)
# Modify.........: No.FUN-4C0100 05/03/01 By Smapmin 放寬金額欄位
# Modify.........: No.MOD-530866 05/03/30 By Smapmin 將VARCHAR轉為CHAR
# Modify.........: No.FUN-540057 05/05/09 By jackie 發票號碼及其他欄位調整
# Modify.........: No.FUN-550071 05/05/24 By day  單據編號加大
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.FUN-580010 05/08/03 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.TQC-5C0051 05/12/09 By kevin 欄位沒對齊
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.MOD-8A0107 08/10/16 By Sarah 當ooz07為Y時,SQL段以oma61>0為條件,ooz07為N時,以oma56t-oma57>0為條件
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法 
# Modify.........: No.TQC-970040 09/07/03 BY wujie   SQL的長度不夠，改為string
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A10098 10/01/18 By shiwuying GP5.2跨DB報表--財務類
# Modify.........: No:TQC-A50082 10/05/19 By Carrier main中结构调整
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:FUN-B20020 11/02/15 By destiny 增加收款单条件
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                  # Print condition RECORD
              wc      STRING,                         # Where condition
              rdate   LIKE type_file.dat,             # 發票截止日期 #No.FUN-680123 DATE
              sdate   LIKE type_file.dat,             # 發票截止日期 #No.FUN-680123 DATE
              base    LIKE type_file.dat,             # 逾期基准日期 #No.FUN-680123 DATE
              s       LIKE type_file.chr1,            # Choose report #No.FUN-680123 VARCHAR(01)
              more    LIKE type_file.chr1             # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD,
        #No.FUN-A10098 -BEGIN-----
        #plant     ARRAY[12] OF  LIKE azp_file.azp01, #工廠編號 #No.FUN-680123 ARRAY[12] OF VARCHAR(12)
        #No.FUN-A10098 -END-------
         g_sql     STRING,
         g_atot    LIKE type_file.num5,               #No.FUN-680123 SMALLINT
         g_p1,g_p2 LIKE type_file.chr1000             #No.FUN-680123 VARCHAR(300)
 
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i               LIKE type_file.num5          #No.FUN-680123 SMALLINT
#No.FUN-580010--start
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17
  DEFINE g_seq_item     LIKE type_file.num5            #No.FUN-680123 SMALLINT
END GLOBALS
#No.FUN-580010--end
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #No.TQC-A50082  --Begin
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
   LET tm.base = ARG_VAL(11)
  #No.FUN-A10098 -BEGIN-----
  #LET plant[1] = ARG_VAL(12)
  #LET plant[2] = ARG_VAL(13)
  #LET plant[3] = ARG_VAL(14)
  #LET plant[4] = ARG_VAL(15)
  #LET plant[5] = ARG_VAL(16)
  #LET plant[6] = ARG_VAL(17)
  #LET plant[7] = ARG_VAL(18)
  #LET plant[8] = ARG_VAL(19)
  #LET plant[9] = ARG_VAL(20)
  #LET plant[10] = ARG_VAL(21)
  #LET plant[11] = ARG_VAL(22)
  #LET plant[12] = ARG_VAL(23)
  #FOR i = 1 TO 12
  #    IF NOT cl_null(ARG_VAL(i+11)) THEN
  #       LET g_atot = g_atot + 1
  #    END IF
  #END FOR
  ##-----END TQC-610059-----
 
  ##No.FUN-570264 --start--
  #LET g_rep_user = ARG_VAL(24)
  #LET g_rep_clas = ARG_VAL(25)
  #LET g_template = ARG_VAL(26)
  ##No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
  #No.FUN-A10098 -END-------

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
     #No.FUN-680123 begin
   DROP TABLE r150m_tmp
   CREATE TEMP TABLE r150m_tmp
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
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127

   #No.TQC-A50082  --End  
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL axrr150_tm(0,0)           # Input print condition
      ELSE CALL axrr150()                 # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr150_tm(p_row,p_col)
  DEFINE  p_row,p_col    LIKE type_file.num5,        #No.FUN-680123 SMALLINT 
          l_ac           LIKE type_file.num10,       #No.FUN-680123 INTEGER
          l_cmd          LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
 
   OPEN WINDOW axrr150_w AT p_row,p_col
        WITH FORM "axr/42f/axrr150"
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
  #LET plant[1]=g_plant  #預設現行工廠 #No.FUN-A10098
   LET tm.rdate = g_today
   LET tm.sdate = g_today
   LET tm.base = g_today
   LET tm.more = 'N'
   LET tm.s = '1'
WHILE TRUE
   DELETE FROM r150m_tmp
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr150_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
  #No.FUN-A10098 -BEGIN-----
  ##----- 工廠編號 -B---#
  #CALL SET_COUNT(1)    # initial array argument
  #INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.*
  #    BEFORE ROW               #No.FUN-560239
  #       LET l_ac = ARR_CURR()
 
  #    AFTER FIELD plant
  #     # LET l_ac = ARR_CURR()   #No.FUN-560239 Mark
  #       IF NOT cl_null(plant[l_ac]) THEN
  #          SELECT azp01 FROM azp_file WHERE azp01 = plant[l_ac]
  #          IF STATUS THEN
# #             CALL cl_err('sel azp',STATUS,1)   #No.FUN-660116
  #             CALL cl_err3("sel","azp_file",plant[l_ac],"",STATUS,"","sel azp",1)   #No.FUN-660116
  #             NEXT FIELD plant 
  #          END IF
  #          FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
  #              IF plant[i] = plant[l_ac] THEN
  #                 CALL cl_err('','aom-492',1) NEXT FIELD plant
  #              END IF
  #          END FOR
  #          #No.FUN-940102--begin    
  #          IF NOT s_chk_demo(g_user,plant[l_ac]) THEN              
  #             NEXT FIELD plant         
  #          END IF            
  #          #No.FUN-940102--end 
  #       END IF
  #    AFTER INPUT                    # 檢查至少輸入一個工廠
  #       IF INT_FLAG THEN EXIT INPUT END IF
  #       LET g_atot = ARR_COUNT()
  #       FOR i = 1 TO g_atot
  #           IF NOT cl_null(plant[i]) THEN EXIT INPUT END IF
  #       END FOR
  #       IF i = g_atot+1 THEN
  #          CALL cl_err('','aom-423',1) NEXT FIELD plant
  #       END IF
 
  #    #-----No.FUN-560239-----
  #    ON ACTION CONTROLP
  #       CALL cl_init_qry_var()
  #      #LET g_qryparam.form = 'q_azp'               #No.FUN-940102
  #       LET g_qryparam.form = "q_zxy"               #No.FUN-940102
  #       LET g_qryparam.arg1 = g_user                #No.FUN-940102
  #       LET g_qryparam.default1 = plant[l_ac]
  #       CALL cl_create_qry() RETURNING plant[l_ac]
  #       CALL FGL_DIALOG_SETBUFFER(plant[l_ac])
  #    #-----No.FUN-560239 END-----
 
  #   ON IDLE g_idle_seconds
  #      CALL cl_on_idle()
  #      CONTINUE INPUT
 
  #   ON ACTION about         #MOD-4C0121
  #      CALL cl_about()      #MOD-4C0121
 
  #   ON ACTION help          #MOD-4C0121
  #      CALL cl_show_help()  #MOD-4C0121
 
  #   ON ACTION controlg      #MOD-4C0121
  #      CALL cl_cmdask()     #MOD-4C0121
 
 
  #       ON ACTION exit
  #       LET INT_FLAG = 1
  #       EXIT INPUT
  #END INPUT
  #IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW axrr150_w RETURN END IF
  #No.FUN-A10098 -END-------
 
   INPUT BY NAME tm.s,tm.rdate,tm.sdate,tm.base,tm.more WITHOUT DEFAULTS
      AFTER FIELD rdate
         IF cl_null(tm.rdate) THEN NEXT FIELD rdate END IF
      AFTER FIELD sdate
         IF cl_null(tm.sdate) THEN NEXT FIELD sdate END IF
      AFTER FIELD s
         IF tm.s!='1' AND tm.s!='2' AND tm.s!='3' THEN
 #No.MOD-580325-begin
            CALL cl_err('','mfg0051',0)
#           ERROR "請輸入[1,2,3]!"
 #No.MOD-580325-end
            NEXT FIELD s
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
#990420
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr150_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr150'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr150','9031',1)
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
                         #-----TQC-610059---------
                         " '",tm.s CLIPPED,"'" ,
                         " '",tm.rdate CLIPPED,"'",
                         " '",tm.sdate CLIPPED,"'",
                         " '",tm.base CLIPPED,"'",
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
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr150',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr150()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr150_w
END FUNCTION
 
FUNCTION axrr150()
   DEFINE 
          l_name    LIKE type_file.chr20,          # External(Disk) file name #No.FUN-680123 VARCHAR(20)   
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
#         l_sql     LIKE type_file.chr1000,        #No.FUN-680123 VARCHAR(1200)
          l_sql     STRING,                        #No.TQC-970040
          l_za05    LIKE type_file.chr1000,        #No.FUN-680123 VARCHAR(40)
          l_i,l_j,i LIKE type_file.num5,           #No.FUN-680123 SMALLINT
          l_dbs     LIKE azp_file.azp03,           #No.FUN-680123 VARCHAR(22)
          l_amt1,l_amt2 LIKE oma_file.oma55,
         #l_amt3,l_amt4 LIKE oma_file.oma55,    #FUN-A60056
          l_zaa02       LIKE zaa_file.zaa02,
          sr        RECORD
                    type      LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1)
                   #plant     LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10) #No.FUN-A10098
                    oma66     LIKE oma_file.oma66,     #No.FUN-A10098
                    oma00     LIKE oma_file.oma00,     #帳款類別
                    oma01     LIKE oma_file.oma01,     #帳款編號
                    oma03     LIKE oma_file.oma03,     #客戶編號
                    oma032    LIKE oma_file.oma032,    #簡稱
                    oma02     LIKE oma_file.oma02,     #發票日期
                    oma10     LIKE oma_file.oma10,     #發票號碼
                    oma11     LIKE oma_file.oma11,     #應收款日
                    oma14     LIKE oma_file.oma14,     #人員編號
                    oma16     LIKE oma_file.oma16,     #訂單編號
                    oma23     LIKE oma_file.oma23,     #幣別
                    gen02     LIKE gen_file.gen02,     #業務員
                    amt1      LIKE oma_file.oma55,     #應收外幣
                    amt2      LIKE oma_file.oma57,     #應收本幣
                    amta      LIKE type_file.num20_6,  #已確認外幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtb      LIKE type_file.num20_6,  #已確認本幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtc      LIKE type_file.num20_6,  #未收外幣 (amt1 - amta) #No.FUN-680123 DEC(20,6)
                    amtd      LIKE type_file.num20_6,  #未收本幣 (amt2 - amtb) #No.FUN-680123 DEC(20,6)
                    overday   LIKE type_file.num5      #逾期天數 #No.FUN-680123 SMALLINT
                    END RECORD
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   #====>資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                 #只能使用自己的資料
   #      LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                 #只能使用相同群的資料
   #      LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
   #End:FUN-980030
 
   CALL cl_outnam('axrr150') RETURNING l_name
#No.FUN-580010--start
   CASE
     WHEN tm.s='1'
       LET g_zaa[31].zaa06="N"
       LET g_zaa[32].zaa06="N"
       LET g_zaa[33].zaa06="N"
       LET g_zaa[34].zaa06="N"
       LET g_zaa[35].zaa06="N"
       LET g_zaa[36].zaa06="N"
       LET g_zaa[37].zaa06="N"
       LET g_zaa[38].zaa06="N"
       LET g_zaa[39].zaa06="N"
       LET g_zaa[40].zaa06="N"
       LET g_zaa[41].zaa06="N"
       LET g_zaa[42].zaa06="N"
       LET g_zaa[43].zaa06="Y"
       LET g_zaa[44].zaa06="Y"
       LET g_zaa[45].zaa06="Y"
       LET g_zaa[46].zaa06="Y"
     WHEN tm.s='2'         	
       LET g_zaa[31].zaa06="N"
       LET g_zaa[32].zaa06="N"
       LET g_zaa[33].zaa06="N"
       LET g_zaa[34].zaa06="N"
       LET g_zaa[35].zaa06="N"
       LET g_zaa[36].zaa06="N"
       LET g_zaa[37].zaa06="N"
       LET g_zaa[38].zaa06="N"
       LET g_zaa[39].zaa06="N"
       LET g_zaa[40].zaa06="N"
       LET g_zaa[41].zaa06="N"
       LET g_zaa[42].zaa06="N"
       LET g_zaa[43].zaa06="N"
       LET g_zaa[44].zaa06="N"
       LET g_zaa[45].zaa06="N"
       LET g_zaa[46].zaa06="N"
     OTHERWISE
       LET g_zaa[31].zaa06="N"
       LET g_zaa[32].zaa06="N"
       LET g_zaa[33].zaa06="N"
       LET g_zaa[34].zaa06="N"
       LET g_zaa[35].zaa06="N"
       LET g_zaa[36].zaa06="N"
       LET g_zaa[37].zaa06="N"
       LET g_zaa[38].zaa06="N"
       LET g_zaa[39].zaa06="N"
       LET g_zaa[40].zaa06="N"
       LET g_zaa[41].zaa06="Y"
       LET g_zaa[42].zaa06="Y"
       LET g_zaa[43].zaa06="Y"
       LET g_zaa[44].zaa06="Y"
       LET g_zaa[45].zaa06="N"
       LET g_zaa[46].zaa06="N"
   END CASE
   CALL cl_prt_pos_len()
   LET g_dash=NULL
   LET g_dash2=NULL
   FOR i=1 TO g_len LET g_dash[i,i]='='  END FOR
   FOR i=1 TO g_len LET g_dash2[i,i]='-'  END FOR
#No.FUN-580010--end
 
   START REPORT axrr150_rep TO l_name
   LET g_pageno = 0

  #No.FUN-A10098 -BEGIN----- 
  #LET l_i = 1
  #FOR l_i = 1 TO g_atot
  #   IF cl_null(plant[l_i]) THEN CONTINUE FOR END IF
  #   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = plant[l_i]
  #   LET l_dbs = s_dbstring(l_dbs CLIPPED)
  #No.FUN-A10098 -END-------
      IF g_ooz.ooz07 = 'Y' THEN   #MOD-8A0107 add
      #  LET l_sql="SELECT '1','',oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
         LET l_sql="SELECT '1',oma66,oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
                   " oma11,oma14,oma16,oma23,gen02,",
                  #--modi by kitty bug NO:A057
                  #" oma54t-oma55,oma56t-oma57,",
                   " oma54t-oma55,oma61       ,",
                   " 0,0,0,0,0",
#No.FUN-A10098 -BEGIN-----
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14 = gen_file.gen01 ",
#                         # l_dbs CLIPPED,"oga_file,",     # Thomas 98/09/07
#                         # l_dbs CLIPPED,"ofa_file ",     # Thomas 98/09/07
                   " FROM oma_file LEFT OUTER JOIN gen_file ON oma14 = gen01 ",
#No.FUN-A10098 -END-------
                   " WHERE oma02 <='" ,tm.rdate,"'",
                     " AND oma11 < '",tm.base,"'",
                     " AND oma00 MATCHES '1*' ",     # 應收
                  #--modi by kitty bug NO:A057
                  #  " AND (oma56t>oma57 OR ",
                     " AND (oma61 >0     OR ",
                          " oma01 IN (SELECT oob06 FROM ",
                  #No.FUN-A10098 -BEGIN-----
                  #         l_dbs CLIPPED,"ooa_file,",
                  #         l_dbs CLIPPED,"oob_file",
                           " ooa_file,oob_file ",
                  #No.FUN-A10098 -END-------
                          " WHERE ooa01=oob01 AND ooaconf !='X' ", #010806增
                          " AND ooa37='1' ",               #FUN-B20020
                          " AND ooa02 > '", tm.rdate,"'))",
                     " AND ",tm.wc CLIPPED,
                     " AND omaconf = 'Y' AND omavoid = 'N' ",
                   " UNION ",
                  #"SELECT '2','',oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
                   "SELECT '2',oma66,oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
                   " oma11,oma14,oma16,oma23,gen02,",
                  #--modi by kitty bug NO:A057
                  #" oma54t-oma55,oma56t-oma57,",
                   " oma54t-oma55,oma61       ,",
                   " 0,0,0,0,0  ",
#No.FUN-A10098 -BEGIN-----
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14 = gen_file.gen01 ",
#                         # l_dbs CLIPPED,"oga_file, ",     # Thomas 98/09/07
#                         # l_dbs CLIPPED,"ofa_file ",     # Thomas 98/09/07
                   " FROM oma_file LEFT OUTER JOIN gen_file ON oma14 = gen01 ",
#No.FUN-A10098 -END-------
                   " WHERE oma02 <='",tm.rdate,"'",
                   "   AND oma00 ='24'",            # 預收
                  #--modi by kitty bug NO:A057
                  #  " AND (oma56t>oma57 OR ",
                     " AND (oma61 >0     OR ",
                          " oma01 IN (SELECT oob06 FROM ",
                  #No.FUN-A10098 -BEGIN-----
                  #         l_dbs CLIPPED, "ooa_file,",
                  #         l_dbs CLIPPED,"oob_file",
                          " ooa_file,oob_file ",
                  #No.FUN-A10098 -END-------
                          " WHERE ooa01=oob01 AND ooaconf !='X' ", #010806增
                          "   AND ooa37='1' ",               #FUN-B20020
                          "   AND ooa02 > '", tm.rdate,"'))",
                     " AND ",tm.wc CLIPPED,
                     " AND omaconf = 'Y' AND omavoid = 'N' "
     #str MOD-8A0107 add
      ELSE
      #  LET l_sql="SELECT '1','',oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
         LET l_sql="SELECT '1',oma66,oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
                   " oma11,oma14,oma16,oma23,gen02,",
                  #--modi by kitty bug NO:A057
                   " oma54t-oma55,oma56t-oma57,",   #MOD-8A0107 mod
                   " 0,0,0,0,0",
#No.FUN-A10098 -BEGIN-----
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14 = gen_file.gen01 ",
#                         # l_dbs CLIPPED,"oga_file,",     # Thomas 98/09/07
#                         # l_dbs CLIPPED,"ofa_file ",     # Thomas 98/09/07
                   " FROM oma_file LEFT OUTER JOIN gen_file ON oma14 = gen01 ",
#No.FUN-A10098 -END-------
                   " WHERE oma02 <='" ,tm.rdate,"'",
                     " AND oma11 < '",tm.base,"'",
                     " AND oma00 MATCHES '1*' ",     # 應收
                  #--modi by kitty bug NO:A057
                  #  " AND (oma56t>oma57 OR ",
                     " AND (oma56t-oma57 >0 OR ",   #MOD-8A0107 mod
                          " oma01 IN (SELECT oob06 FROM ",
                  #No.FUN-A10098 -BEGIN-----
                  #         l_dbs CLIPPED,"ooa_file,",
                  #         l_dbs CLIPPED,"oob_file",
                          " ooa_file,oob_file ",
                  #No.FUN-A10098 -END-------
                          " WHERE ooa01=oob01 AND ooaconf !='X' ", #010806增
                          " AND ooa37='1' ",               #FUN-B20020
                          " AND ooa02 > '", tm.rdate,"'))",
                     " AND ",tm.wc CLIPPED,
                     " AND omaconf = 'Y' AND omavoid = 'N' ",
                   " UNION ",
                 # "SELECT '2','',oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
                   "SELECT '2',oma66,oma00,oma01,oma03, oma032, oma02, oma10,", #No.FUN-A10098
                   " oma11,oma14,oma16,oma23,gen02,",
                  #--modi by kitty bug NO:A057
                   " oma54t-oma55,oma56t-oma57,",   #MOD-8A0107 mod
                   " 0,0,0,0,0  ",
#No.FUN-A10098 -BEGIN-----
#" FROM ",l_dbs CLIPPED,"oma_file LEFT OUTER JOIN ",l_dbs CLIPPED,"gen_file ON oma_file.oma14 = gen_file.gen01 ",
#                         # l_dbs CLIPPED,"oga_file, ",     # Thomas 98/09/07
#                         # l_dbs CLIPPED,"ofa_file ",     # Thomas 98/09/07
                   " FROM oma_file LEFT OUTER JOIN gen_file ON oma14 = gen01 ",
#No.FUN-A10098 -END-------
                   " WHERE oma02 <='",tm.rdate,"'",
                   "   AND oma00 ='24'",            # 預收
                  #--modi by kitty bug NO:A057
                  #  " AND (oma56t>oma57 OR ",
                     " AND (oma56t-oma57 >0 OR ",   #MOD-8A0107 mod
                          " oma01 IN (SELECT oob06 FROM ",
                  #No.FUN-A10098 -BEGIN-----
                  #         l_dbs CLIPPED, "ooa_file,",
                  #         l_dbs CLIPPED,"oob_file",
                          " ooa_file,oob_file ",
                  #No.FUN-A10098 -END-------
                          " WHERE ooa01=oob01 AND ooaconf !='X' ", #010806增
                          "   AND ooa37='1' ",               #FUN-B20020
                          "   AND ooa02 > '", tm.rdate,"'))",
                     " AND ",tm.wc CLIPPED,
                     " AND omaconf = 'Y' AND omavoid = 'N' "
      END IF
     #end MOD-8A0107 add
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      PREPARE axrr150_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
      END IF
      DECLARE axrr150_curs1 CURSOR FOR axrr150_prepare1
 
      FOREACH axrr150_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
         END IF
         IF cl_null(sr.amt1) THEN LET sr.amt1 = 0 END IF
         IF cl_null(sr.amt2) THEN LET sr.amt2 = 0 END IF
      #  LET sr.plant = plant[l_i] #No.FUN-A10098
         IF cl_null(sr.oma66) THEN LET sr.oma66 = g_plant END IF #No.FUN-A10098
         LET l_amt1 = 0
         LET l_amt2 = 0
        #LET l_amt3 = 0     #FUN-A60056
        #LET l_amt4 = 0     #FUN-A60056
         CASE
            WHEN sr.type='1'    #----- 應收合計
               LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                         #No.FUN-A10098 -BEGIN-----
                         #"  FROM ",l_dbs CLIPPED,"oob_file,",
                         #          l_dbs CLIPPED,"ooa_file",
                          "  FROM oob_file,ooa_file",
                         #No.FUN-A10098 -END-------
                          " WHERE oob06='",sr.oma01,"'",
                          "   AND oob03='2' AND oob04='1' ",
                          "   AND ooaconf='Y' AND ooa01=oob01 ",
                          "   AND ooa37='1' ",               #FUN-B20020
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
               LET sr.overday=tm.base-sr.oma11 #逾期天數
 
               LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",  #已收未確認
                         #No.FUN-A10098 -BEGIN-----
                         #"  FROM ",l_dbs CLIPPED,"oob_file,",
                         #          l_dbs CLIPPED,"ooa_file",
                          "  FROM oob_file,ooa_file",
                         #No.FUN-A10098 -END-------
                          " WHERE oob06='",sr.oma01,"'",
                          "   AND oob03='2' AND oob04='1' ",
                          "   AND ooaconf='N' AND ooa01=oob01 ",
                          "   AND ooa02 <= '",tm.rdate,"'",
                          "   AND ooa37='1' "                #FUN-B20020
                          # "   AND ooa02 > '",tm.rdate,"'"
                          # Thomas 98/09/18   日期判斷錯誤
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               PREPARE ooa_pre3 FROM l_sql
               IF STATUS THEN
                  CALL cl_err('ooa_pre3',STATUS,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                  EXIT PROGRAM
               END IF
               DECLARE ooa_curs3 CURSOR FOR ooa_pre3
               OPEN ooa_curs3
               FETCH ooa_curs3 INTO l_amt1,l_amt2
               IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
               IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
               LET sr.amta = sr.amta + l_amt1 # 外幣
               LET sr.amtb = sr.amtb + l_amt2 # 本幣
               LET sr.amtc = sr.amt1 - sr.amta # 外幣
               LET sr.amtd = sr.amt2 - sr.amtb # 本幣
 
#FUN-A60056--mark--str--
#              #modi by kitty bug NO:A057
#              IF g_ooz.ooz07 = 'Y' THEN   #MOD-8A0107 add
#                #LET l_sql = " SELECT SUM(oma54t-oma55),SUM(oma56t-oma57) ",
#                 LET l_sql = " SELECT SUM(oma54t-oma55),SUM(oma61) ",
#                           #No.FUN-A10098 -BEGIN-----
#                           # "  FROM ",l_dbs CLIPPED,"oma_file,",
#                           #           l_dbs CLIPPED,"oha_file",
#                           # " WHERE oha16 = '",sr.oma16,"'",
#                           # "   AND oma01 = oha10 AND oma00 = '21' ",
#                           # "   AND oma02 <='" ,tm.rdate,"'",
#                           # "   AND ohaconf != 'X' " #01/08/17 mandy
#                             "  FROM oma_file ",
#                             " WHERE oma16 = '",sr.oma16,"'",
#                             "   AND oma00 = '21' ",
#                             "   AND oma02 <='" ,tm.rdate,"'"
#                           #No.FUN-A10098 -END-------
#             #str MOD-8A0107 add
#              ELSE
#                 LET l_sql = " SELECT SUM(oma54t-oma55),SUM(oma56t-oma57) ",
#                           #No.FUN-A10098 -BEGIN-----
#                           # "  FROM ",l_dbs CLIPPED,"oma_file,",
#                           #           l_dbs CLIPPED,"oha_file",
#                             "  FROM oma_file,oha_file",
#                           #No.FUN-A10098 -END-------
#                             " WHERE oha16 = '",sr.oma16,"'",
#                             "   AND oma01 = oha10 AND oma00 = '21' ",
#                             "   AND oma02 <='" ,tm.rdate,"'",
#                             "   AND ohaconf != 'X' " #01/08/17 mandy
#              END IF
#             #end MOD-8A0107 add
#	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
#              PREPARE oma_pre FROM l_sql
#              IF STATUS THEN
#                 CALL cl_err('oma_pre',STATUS,1) 
#                 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
#                 EXIT PROGRAM
#              END IF
#              DECLARE oma_curs CURSOR FOR oma_pre
#              OPEN oma_curs
#              FETCH oma_curs INTO l_amt3,l_amt4
#              IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#              IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#              # Thomas 98/09/18 如果是雜項應收就不能再找折讓單
#              IF sr.oma00 = '14' THEN
#                 LET l_amt3 = 0
#                 LET l_amt4 = 0
#              END IF
#              # Thomas End #
#FUN-A60056--mark--end
#              LET sr.amt1 = sr.amt1 - l_amt3  # 折讓己含在己沖中
#              LET sr.amt2 = sr.amt2 - l_amt4
               IF sr.amt1 > 0 OR sr.amt2 > 0 THEN
                  LET sr.amtc=sr.amt1-sr.amta   #未收外幣 (amt1 - amta)
                  LET sr.amtd=sr.amt2-sr.amtb   #未收本幣 (amt2 - amtb)
                  INSERT INTO r150m_tmp
                #  VALUES('1',sr.plant,sr.oma03,sr.oma23,sr.oma02,sr.amt1, #No.FUN-A10098
                   VALUES('1',sr.oma66,sr.oma03,sr.oma23,sr.oma02,sr.amt1, #No.FUN-A10098
                          sr.amt2,sr.amta,sr.amtb,sr.amtc,sr.amtd)
                  IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#                    CALL cl_err('ins tmp',STATUS,1)    #No.FUN-660116
                     CALL cl_err3("ins","r150m_tmp",sr.oma66,sr.oma03,STATUS,"","ins tmp",1)   #No.FUN-660116 #No.FUN-A10098 plant->oma66
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                     EXIT PROGRAM
                  END IF
                  OUTPUT TO REPORT axrr150_rep(sr.*)
               END IF
            WHEN sr.type='2'    #----- 預收合計
               LET l_sql ="SELECT SUM(oob09),SUM(oob10) ",
                         #No.FUN-A10098 -BEGIN-----
                         #"  FROM ",l_dbs CLIPPED,"oob_file,",
                         #          l_dbs CLIPPED,"ooa_file",
                          "  FROM oob_file,ooa_file",
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
               INSERT INTO r150m_tmp
               #VALUES('2',sr.plant,sr.oma03,sr.oma23,sr.oma02,sr.amt1,sr.amt2, #No.FUN-A10098
                VALUES('2',sr.oma66,sr.oma03,sr.oma23,sr.oma02,sr.amt1,sr.amt2, #No.FUN-A10098
                       sr.amta,sr.amtb,sr.amtc,sr.amtd)
               IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err('ins tmp #2',STATUS,1)  #No.FUN-660116
                  CALL cl_err3("ins","r150m_tmp",sr.oma66,sr.oma03,STATUS,"","ins tmp #2",1)   #No.FUN-660116 #No.FUN-A10098
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                  EXIT PROGRAM
               END IF
               #No.B145 010406 by linda add
               IF tm.s='2' THEN
                  INSERT INTO r150m_tmp
               #   VALUES('1',sr.plant,sr.oma03,sr.oma23,sr.oma02, #No.FUN-A10098
                   VALUES('1',sr.oma66,sr.oma03,sr.oma23,sr.oma02, #No.FUN-A10098
                          0,0,0,0,0,0)
                  IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#                    CALL cl_err('ins tmp #2',STATUS,1)    #No.FUN-660116
                     CALL cl_err3("ins","r150m_tmp",sr.oma66,sr.oma03,SQLCA.sqlcode,"","ins tmp #2",1)   #No.FUN-660116 #No.FUN-A10098
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
                     EXIT PROGRAM
                  END IF
                  OUTPUT TO REPORT axrr150_rep(sr.*)
               END IF
               #No.B145 end----
         END CASE
      END FOREACH
  #END FOR #No.FUN-A10098 mark
   FINISH REPORT axrr150_rep
   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axrr150_rep(sr)
   DEFINE
          l_last_sw LIKE type_file.chr1,               #No.FUN-680123 VARCHAR(1)
          sr        RECORD
                    type      LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1)
                  # plant     LIKE azp_file.azp01,     #No.FUN-680123 VARCHAR(10) #No.FUN-A10098
                    oma66     LIKE oma_file.oma66,     #No.FUN-A10098
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
                    gen02     LIKE gen_file.gen02,
                    amt1      LIKE oma_file.oma55,     #應收外幣
                    amt2      LIKE oma_file.oma57,     #應收本幣
                    amta      LIKE type_file.num20_6,  #已確認外幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtb      LIKE type_file.num20_6,  #已確認本幣(已衝帳未確認之金額) #No.FUN-680123 DEC(20,6)
                    amtc      LIKE type_file.num20_6,  #未收外幣 (amt1 - amta) #No.FUN-680123 DEC(20,6)
                    amtd      LIKE type_file.num20_6,  #未收本幣 (amt2 - amtb) #No.FUN-680123 DEC(20,6)
                    overday   LIKE type_file.num5      #逾期天數 #No.FUN-680123 SMALLINT
                    END RECORD,
         #No.FUN-A10098 -BEGIN-----
         #l_plant_o LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
         #l_plant   LIKE azp_file.azp01,        #No.FUN-680123 VARCHAR(10)
          l_flag    LIKE type_file.chr1,
          #No.FUN-A10098 -END-------
          l_oga011  LIKE oga_file.oga011,
          l_ofa01   LIKE ofa_file.ofa01,
         #l_curr    VARCHAR(04),
          l_curr    LIKE azi_file.azi01,        #No.FUN-680123 VARCHAR(04)
         #l_db      VARCHAR(22),
          l_db      LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(22)
          l_i       LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_amt1,l_amt2  LIKE oma_file.oma55,
          l_amt3,l_amt4  LIKE oma_file.oma55,
          l_amta    LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
          l_amtb    LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
          l_amtc    LIKE type_file.num20_6,       #No.FUN-680123 DEC(20,6)
          l_amtd    LIKE type_file.num20_6        #No.FUN-680123 DEC(20,6)
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY sr.oma03,sr.plant,sr.oma23,sr.oma11 #No.FUN-A10098
  ORDER BY sr.oma03,sr.oma66,sr.oma23,sr.oma11 #No.FUN-A10098
  FORMAT
   PAGE HEADER
#No.FUN-580010--start
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      PRINT g_x[14] CLIPPED,tm.rdate,'     ',g_x[24] CLIPPED,tm.base
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],
            g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46]
      PRINT g_dash1
#No.FUN-580010--end
      LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.oma03
      PRINT COLUMN g_c[31], sr.oma03,
            COLUMN g_c[32],sr.oma032;                            #No.FUN-580010
 
#   BEFORE GROUP OF sr.plant #No.FUN-A10098
    BEFORE GROUP OF sr.oma66 #No.FUN-A10098
# Thomas 98/09/18
       #No.FUN-A10098 -BEGIN-----
       # SELECT azp03 INTO l_db FROM azp_file WHERE azp01 = sr.plant
       ##let l_db = s_dbstring(l_db clipped)  #TQC-950020   
       # let l_db = s_dbstring(l_db clipped) #TQC-950020    
       # LET g_sql = "SELECT oga011 FROM ", l_db CLIPPED, "oga_file WHERE ",
       #             "oga01 = ?"
       # PREPARE oga_stm FROM g_sql
       # DECLARE cur_oga CURSOR FOR oga_stm
       # LET g_sql = "SELECT ofa01 FROM ", l_db CLIPPED, "ofa_file WHERE ",
       #             "ofa011 = ?",
       #             " AND ofaconf = 'Y' " #mandy01/08/07 要取已確認的資料
         LET g_sql = "SELECT oga011 FROM ",cl_get_target_table(sr.oma66,"oga_file"),
                     " WHERE oga01 = ?"
         CALL cl_parse_qry_sql(g_sql,sr.oma66) RETURNING g_sql
         PREPARE oga_stm FROM g_sql
         DECLARE cur_oga CURSOR FOR oga_stm

         LET g_sql = "SELECT ofa01 FROM ",cl_get_target_table(sr.oma66,"ofa_file"),
                     " WHERE ofa011 = ?",
                     " AND ofaconf = 'Y' "
         CALL cl_parse_qry_sql(g_sql,sr.oma66) RETURNING g_sql
       #No.FUN-A10098 -END-------
         PREPARE ofa_stm FROM g_sql
         DECLARE cur_ofa CURSOR FOR ofa_stm
# End #
 
#No.FUN-550071-begin
    ON EVERY ROW
     IF sr.type='1' THEN   #No.B145 add一行
       LET l_oga011 = ""
       LET l_ofa01  = ""
       # SELECT oga011 INTO l_oga011 FROM oga_file WHERE oga01  = sr.oma16
       # SELECT ofa01  INTO l_ofa01  FROM ofa_file WHERE ofa011 = l_oga011
       # LET l_ofa01 = sr.ofa01
# Thomas 98/09/18
       OPEN cur_oga USING sr.oma16
       FETCH cur_oga INTO l_oga011
       CLOSE cur_oga
       OPEN cur_ofa USING l_oga011
       FETCH cur_ofa INTO l_ofa01
       CLOSE cur_ofa
# End #
# Thomas 99/03/02
       IF sr.oma02<= tm.sdate THEN
       IF  sr.oma01[1,2]  =  "DM"  AND  # DM的無發票號show,DM號 99/03/10 Ivy
           cl_null(sr.oma10)  THEN
           LET  sr.oma10  =  sr.oma01
       END IF
       SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
         FROM azi_file
        WHERE azi01=sr.oma23
#No.FUN-580010--start
       PRINT COLUMN g_c[33],sr.gen02,
             COLUMN g_c[34],sr.oma10,
             COLUMN g_c[35],sr.oma02,
             COLUMN g_c[36],sr.oma16,
             COLUMN g_c[37],l_ofa01,
             COLUMN g_c[38],sr.oma11,
             COLUMN g_c[39],sr.overday  USING '####,##&', #No.TQC-5C0051
             COLUMN g_c[40],sr.oma23 ;
       PRINT COLUMN g_c[41],cl_numfor(sr.amt1,41,t_azi04),
             COLUMN g_c[42],cl_numfor(sr.amt2,42,g_azi04),
             COLUMN g_c[43],cl_numfor(sr.amta,43,t_azi04),
             COLUMN g_c[44],cl_numfor(sr.amtb,44,g_azi04),
             COLUMN g_c[45],cl_numfor(sr.amtc,45,t_azi04),
             COLUMN g_c[46],cl_numfor(sr.amtd,46,g_azi04)
#No.FUN-580010--end
       END IF
     END IF  #No.B145 add一行
    AFTER GROUP OF sr.oma23
       LET l_amt1= GROUP SUM(sr.amt1) WHERE sr.type = '1'   #應收外幣
       LET l_amt2= GROUP SUM(sr.amt2) WHERE sr.type = '1'   #應收本幣
       LET l_amt3= GROUP SUM(sr.amt1) WHERE sr.type = '2'   #預收外幣
       LET l_amt4= GROUP SUM(sr.amt2) WHERE sr.type = '2'   #預收本幣
       LET l_amta= GROUP SUM(sr.amta) WHERE sr.type = '1'   #應收本幣
       LET l_amtb= GROUP SUM(sr.amtb) WHERE sr.type = '1'   #應收本幣
       LET l_amtc= GROUP SUM(sr.amtc) WHERE sr.type = '1'   #應收本幣
       LET l_amtd= GROUP SUM(sr.amtd) WHERE sr.type = '1'   #應收本幣
       IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
       IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
       IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
       IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
       IF cl_null(l_amta) THEN LET l_amta = 0 END IF
       IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
       IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
       IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
 
    AFTER GROUP OF sr.oma03
       DECLARE tot_curs CURSOR FOR
    #    SELECT r150m_tmp.plant,curr,SUM(amt1),SUM(amt2), #No.FUN-A10098
          SELECT curr,SUM(amt1),SUM(amt2),                #No.FUN-A10098
                SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
           FROM r150m_tmp
          WHERE cust = sr.oma03 AND type = '1'
            AND  oma02 <= tm.sdate      # Ivy 99/03/02
    #     GROUP BY r150m_tmp.plant,curr ORDER BY r150m_tmp.plant,curr #No.FUN-A10098
          GROUP BY curr ORDER BY curr #No.FUN-A10098
    #  LET l_plant_o = ' '  #No.FUN-A10098
#No.FUN-580010--start
 
          PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
                COLUMN g_c[41],g_dash2[1,g_w[41]],
                COLUMN g_c[42],g_dash2[1,g_w[42]],
                COLUMN g_c[43],g_dash2[1,g_w[43]],
                COLUMN g_c[44],g_dash2[1,g_w[44]],
                COLUMN g_c[45],g_dash2[1,g_w[45]],
                COLUMN g_c[46],g_dash2[1,g_w[46]]
#No.FUN-580010--end
       LET l_flag = 'Y'                                    #No.FUN-A10098
    #  FOREACH tot_curs INTO l_plant,l_curr,l_amt1,l_amt2, #No.FUN-A10098
       FOREACH tot_curs INTO l_curr,l_amt1,l_amt2,         #No.FUN-A10098
                             l_amta,l_amtb,l_amtc,l_amtd
          SELECT SUM(amt1),SUM(amt2) INTO l_amt3,l_amt4 FROM r150m_tmp
         # WHERE r150m_tmp.plant = l_plant AND type = '2'  #No.FUN-A10098
           WHERE type = '2'                                #No.FUN-A10098
             AND cust = sr.oma03 AND curr = l_curr
             AND  oma02 <= tm.sdate      # Ivy 99/03/02
          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
          LET l_i = l_i + 1
        # IF l_plant_o != l_plant THEN  #No.FUN-A10098
          IF l_flag = 'Y' THEN          #No.FUN-A10098
             LET l_flag = 'N'           #No.FUN-A10098
             IF l_i != 1 THEN
#No.FUN-580010--start
{         PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
                COLUMN g_c[41],g_dash2[1,g_w[41]],
                COLUMN g_c[42],g_dash2[1,g_w[42]],
                COLUMN g_c[43],g_dash2[1,g_w[43]],
                COLUMN g_c[44],g_dash2[1,g_w[44]],
                COLUMN g_c[45],g_dash2[1,g_w[45]],
                COLUMN g_c[46],g_dash2[1,g_w[46]]
}
#No.FUN-580010--end
             END IF
             PRINT COLUMN 68,sr.oma03 CLIPPED,
            #      COLUMN 78,'(',l_plant CLIPPED,')'; #No.FUN-A10098
                   COLUMN 78,'';                      #No.FUN-A10098
#                  COLUMN 101,g_x[15] CLIPPED;
             PRINTX name=S1 COLUMN g_c[39],g_x[15] CLIPPED;     #No.FUN-580010
          END IF
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
            FROM azi_file
           WHERE azi01=l_curr
 
#No.FUN-580010--start
          PRINT COLUMN g_c[40],l_curr;
       PRINT COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi04),
             COLUMN g_c[42],cl_numfor(l_amt2,42,g_azi04),
             COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
             COLUMN g_c[44],cl_numfor(l_amtb,44,g_azi04),
             COLUMN g_c[45],cl_numfor(l_amtc,45,t_azi04),
             COLUMN g_c[46],cl_numfor(l_amtd,46,g_azi04)
       IF tm.s='2' THEN
            PRINT  COLUMN g_c[39],g_x[23] CLIPPED,
                   COLUMN g_c[41],cl_numfor((l_amt3-l_amta),41,t_azi05),
                   COLUMN g_c[42],cl_numfor((l_amt4-l_amtb),42,g_azi05)
       ELSE
            SKIP 1 LINE
       END IF
#No.FUN-580010--end
     #    LET l_plant_o = l_plant  #No.FUN-A10098
       END FOREACH
       skip   1  line
{      IF tm.s ='2' THEN
          PRINT COLUMN 94,'---- ------------------ ------------------ ------------------ ',
                          '------------------ ------------------ ------------------'
       ELSE
          PRINT COLUMN 94,'---- ------------------ ------------------'
       END IF
}
 
    ON LAST ROW
#No.FUN-A10098 -BEGIN-----
#      #工廠總計
#      DECLARE tot_curs2 CURSOR FOR
#         SELECT r150m_tmp.plant,curr,SUM(amt1),SUM(amt2),
#                SUM(amta),SUM(amtb),SUM(amtc),SUM(amtd)
#           FROM r150m_tmp WHERE type = '1'
#            AND  oma02 <= tm.sdate      # Ivy 99/03/02
#          GROUP BY r150m_tmp.plant,curr ORDER BY r150m_tmp.plant,curr
#      LET l_plant_o = ' '
#      LET l_i = 0
#      FOREACH tot_curs2 INTO l_plant,l_curr,l_amt1,l_amt2,
#                             l_amta,l_amtb,l_amtc,l_amtd
#         SELECT SUM(amt1),SUM(amt2) INTO l_amt3,l_amt4 FROM r150m_tmp
#          WHERE r150m_tmp.plant = l_plant AND type = '2'
#            AND curr = l_curr
#            AND  oma02 <= tm.sdate      # Ivy 99/03/02
#         IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
#         IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
#
#         IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
#         IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
#         IF cl_null(l_amta) THEN LET l_amta = 0 END IF
#         IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
#         IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
#         IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
#         LET l_i = l_i + 1
#         IF l_plant_o != l_plant THEN
#            IF l_i != 1 THEN
#No.FUN-580010--start
#              PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
#                    COLUMN g_c[41],g_dash2[1,g_w[41]],
#                    COLUMN g_c[42],g_dash2[1,g_w[42]],
#                    COLUMN g_c[43],g_dash2[1,g_w[43]],
#                    COLUMN g_c[44],g_dash2[1,g_w[44]],
#                    COLUMN g_c[45],g_dash2[1,g_w[45]],
#                    COLUMN g_c[46],g_dash2[1,g_w[46]]
#            END IF
#            PRINT COLUMN g_c[37],l_plant CLIPPED,
#                  COLUMN g_c[39],g_x[16] CLIPPED;
#No.FUN-580010--end
#         END IF
#         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
#           FROM azi_file
#          WHERE azi01=l_curr
#No.FUN-580010--start
#      PRINT COLUMN g_c[40],l_curr;
#      PRINT COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi04),
#            COLUMN g_c[42],cl_numfor(l_amt2,42,g_azi04),
#            COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
#            COLUMN g_c[44],cl_numfor(l_amtb,44,g_azi04),
#            COLUMN g_c[45],cl_numfor(l_amtc,45,t_azi04),
#            COLUMN g_c[46],cl_numfor(l_amtd,46,g_azi04)
#      IF tm.s='2' THEN
#           PRINT  COLUMN g_c[39],g_x[23] CLIPPED,
#                  COLUMN g_c[41],cl_numfor((l_amt3-l_amta),41,t_azi05),
#                  COLUMN g_c[42],cl_numfor((l_amt4-l_amtb),42,g_azi05)
#      ELSE
#           SKIP 1 LINE
#      END IF
#No.FUN-580010--end
#         LET l_plant_o = l_plant
#      END FOREACH
#No.FUN-580010--start
#         PRINT COLUMN g_c[40],g_dash2[1,g_w[40]],
#               COLUMN g_c[41],g_dash2[1,g_w[41]],
#               COLUMN g_c[42],g_dash2[1,g_w[42]],
#               COLUMN g_c[43],g_dash2[1,g_w[43]],
#               COLUMN g_c[44],g_dash2[1,g_w[44]],
#               COLUMN g_c[45],g_dash2[1,g_w[45]],
#               COLUMN g_c[46],g_dash2[1,g_w[46]]
#No.FUN-580010--end
#No.FUN-A10098 -END-------
       #公司總計
       DECLARE tot_curs3 CURSOR FOR
           SELECT curr,SUM(amt1),SUM(amt2),SUM(amta),
                  SUM(amtb),SUM(amtc),SUM(amtd)
             FROM r150m_tmp WHERE type = '1'
              AND  oma02 <= tm.sdate      # Ivy 99/03/02
            GROUP BY curr ORDER BY curr
#      PRINT COLUMN 97,g_x[17] CLIPPED;
       PRINTX name=S3 COLUMN g_c[39],g_x[17] CLIPPED;         #No.FUN-580010
       FOREACH tot_curs3 INTO l_curr,l_amt1,l_amt2,
                              l_amta,l_amtb,l_amtc,l_amtd
          SELECT SUM(amt1),SUM(amt2) INTO l_amt3,l_amt4 FROM r150m_tmp
           WHERE curr = l_curr AND type = '2'
             AND  oma02 <= tm.sdate      # Ivy 99/03/02
          IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF
          IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF
 
          IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
          IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
          IF cl_null(l_amta) THEN LET l_amta = 0 END IF
          IF cl_null(l_amtb) THEN LET l_amtb = 0 END IF
          IF cl_null(l_amtc) THEN LET l_amtc = 0 END IF
          IF cl_null(l_amtd) THEN LET l_amtd = 0 END IF
          SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓外幣取位
            FROM azi_file
           WHERE azi01=l_curr
#No.FUN-580010--start
#         PRINT COLUMN 110,l_curr;
          PRINT COLUMN g_c[40],l_curr;
       PRINT COLUMN g_c[41],cl_numfor(l_amt1,41,t_azi04),
             COLUMN g_c[42],cl_numfor(l_amt2,42,g_azi04),
             COLUMN g_c[43],cl_numfor(l_amta,43,t_azi04),
             COLUMN g_c[44],cl_numfor(l_amtb,44,g_azi04),
             COLUMN g_c[45],cl_numfor(l_amtc,45,t_azi04),
             COLUMN g_c[46],cl_numfor(l_amtd,46,g_azi04)
       IF tm.s='2' THEN
            PRINT  COLUMN g_c[39],g_x[23] CLIPPED,
                   COLUMN g_c[41],cl_numfor((l_amt3-l_amta),41,t_azi05),
                   COLUMN g_c[42],cl_numfor((l_amt4-l_amtb),42,g_azi05)
       ELSE
            SKIP 1 LINE
       END IF
#No.FUN-580010--end
 
       END FOREACH
#No.FUN-550071-end
       IF g_zz05 = 'Y' THEN     # (80)-70,140,210,281   /   (132)-120,240,300
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
          #   IF tm.wc[001,070] > ' ' THEN            # for 81
          #      PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
          #   IF tm.wc[071,140] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
          #   IF tm.wc[141,210] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
          #   IF tm.wc[211,280] > ' ' THEN
          #      PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
          #END IF
          CALL cl_prt_pos_wc(tm.wc)
          #END TQC-630166
 
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
#Patch....NO.TQC-610037 <> #
