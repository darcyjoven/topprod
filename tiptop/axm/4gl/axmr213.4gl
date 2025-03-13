# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr213.4gl
# Descriptions...: 信用額度排名表
# Date & Author..: 98/06/02 by Chet
# Modify.........: No.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-640324 06/04/10 By Mandy occ175有效期為空白的資料亦納進來計算
# Modify.........: No.MOD-640559 06/05/15 By pengu 報表排名應該考慮幣別匯率換算
# Modify.........: No.TQC-610089 06/05/17 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/05 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-710071 07/01/26 By CoCo 報表輸出至Crystal Reports功能
# Modify.........: No.FUN-8C0097 08/12/22 By Smapmin 增加營運中心開窗功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50044 10/05/14 By Carrier FUN-940102追单
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70084 10/07/20 By lutingting INPUT營運中心改為QBE,可以跑用戶當前法人下具有營運中心權限得資料 
# Modify.........: No.FUN-A80097 10/08/17 By lutingting 修正FUN-A70084問題
# Modify.........: No.MOD-B70203 11/07/21 By suncx 報表營運中心無法顯示BUG修正    

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
           #   wc      VARCHAR(500),            # Where condition
              wc      STRING,                #TQC-630166    # Where condition
             #plant array[12] of LIKE cre_file.cre08,        #No.FUN-680137  VARCHAR(10),   #  #FUN-A70084
              sdate   LIKE type_file.dat,           #No.FUN-680137 DATE
              edate   LIKE type_file.dat,           #No.FUN-680137 DATE
              more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
          END RECORD,
          g_rank      LIKE type_file.num5,          #No.FUN-680137 SMALLINT              # Rank
         #g_atot      LIKE type_file.num5,          #No.FUN-680137 SMALLINT              # total array   #FUN-A70084
          g_dash_1    LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(400)
DEFINE    l_table     STRING,                       ### FUN-710071 ###
          g_sql       STRING                        ### FUN-710071 ###         
DEFINE    g_i         LIKE type_file.num5           #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE    g_rec_b     LIKE type_file.num10          #No.FUN-680137   INTEGER
DEFINE    m_plant     LIKE azw_file.azw01           #No.FUN-A70084 
DEFINE    g_wc        LIKE type_file.chr1000        #No.FUN-A70084
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
 
   ### FUN-710071 Start ### 
   LET g_sql = "occ01.occ_file.occ01,occ02.occ_file.occ02,",
                 "occ63.occ_file.occ63,oag02.oag_file.oag02,",
                 #"occ53.occ_file.occ53,occ175.occ_file.occ175,",  #MOD-B70203 mark
                 #"cre08.cre_file.cre08" #MOD-B70203 mark
                 "occ36.occ_file.occ36,occ175.occ_file.occ175,",   #MOD-B70203 add
                 "plant.cre_file.cre08"  #MOD-B70203 add
 
    LET l_table = cl_prt_temptable('axmr213',g_sql) CLIPPED   # 產生Temp Table
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?, ?, ?, ?, ?, ?, ?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF
   ### FUN-710071 End ### 
 
 
   DROP TABLE x
   DROP TABLE y
#No.FUN-680137---Begin-----
   CREATE TEMP TABLE x(
          x01 LIKE cre_file.cre08,  
          x02 LIKE type_file.chr20, 
          x63 LIKE type_file.num10, 
          x45 LIKE cre_file.cre08,
          xg02 LIKE cob_file.cob08,
          x53  LIKE type_file.num5,  
          x175 LIKE type_file.dat,   
          xplant  LIKE cre_file.cre08,
          x631 LIKE ade_file.ade04,
          xrate LIKE abb_file.abb25);
 
#No.FUN-680137---End-----          
   IF STATUS THEN CALL cl_err('create',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
#No.FUN-680137---Begin-----  
   CREATE TEMP TABLE y(
          y01 LIKE cre_file.cre08,
          y63 LIKE type_file.num10)
#No.FUN-680137---End-----          
   IF STATUS THEN CALL cl_err('create #2',STATUS,1) EXIT PROGRAM END IF
   INITIALIZE tm.* TO NULL                # Default condition
#-----------No.TQC-610089 modify
  #LET tm.sdate = g_today
  #LET tm.edate = g_today
  #LET tm.more = 'N'
  #LET g_pdate = g_today
  #LET g_rlang = g_lang
  #LET g_bgjob = 'N'
  #LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.sdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
#FUN-A70084--mod--str--
#  LET tm.plant[1] = ARG_VAL(10)
#  LET tm.plant[2] = ARG_VAL(11)
#  LET tm.plant[3] = ARG_VAL(12)
#  LET tm.plant[4] = ARG_VAL(13)
#  LET tm.plant[5] = ARG_VAL(14)
#  LET tm.plant[6] = ARG_VAL(15)
#  LET tm.plant[7] = ARG_VAL(16)
#  LET tm.plant[8] = ARG_VAL(17)
#  LET tm.plant[9] = ARG_VAL(18)
#  LET tm.plant[10] = ARG_VAL(19)
#  LET tm.plant[11] = ARG_VAL(20)
#  LET tm.plant[12] = ARG_VAL(21)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(22)
#  LET g_rep_clas = ARG_VAL(23)
#  LET g_template = ARG_VAL(24)
#  LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
#  #No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)
   LET g_wc = ARG_VAL(14)
#FUN-A70084--mod--end
#-----------No.TQC-610089 end
   IF cl_null(tm.wc) THEN
      CALL axmr213_tm(0,0)               # Input print condition
   ELSE
      CALL axmr213()                     # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr213_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          i            LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_ac         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
   DEFINE l_cnt           LIKE type_file.num5                 #FUN-A80097 
   LET p_row = 4 LET p_col = 10
 
   OPEN WINDOW axmr213_w AT p_row,p_col WITH FORM "axm/42f/axmr213"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL r213_set_entry() RETURNING l_cnt   #FUN-A80097 

#-----------No.TQC-610089 add
   LET tm.sdate = g_today
   LET tm.edate = g_today
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#-----------No.TQC-610089 end
 
   CALL cl_opmsg('p')
   WHILE TRUE
      DELETE FROM x
      DELETE FROM y
#FUN-A70084--add--str--
   CONSTRUCT BY NAME g_wc ON azw01

      BEFORE CONSTRUCT
          CALL cl_qbe_init()

      ON ACTION controlp
            IF INFIELD(azw01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azw"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "azw02 = '",g_legal,"' ",
                                      " AND azw01 IN(SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"' )"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azw01
               NEXT FIELD azw01
            END IF

      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      ON ACTION qbe_select
         CALL cl_qbe_select()

  END CONSTRUCT
  IF g_action_choice = "locale" THEN
     LET g_action_choice = ""
     CALL cl_dynamic_locale()
     CONTINUE WHILE
  END IF

  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW axmr213_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF
#FUN-A70084--add--end

      CONSTRUCT BY NAME tm.wc ON occ01,occ02,occ03,occ45,occ63
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr213_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
#FUN-A70084--mark--str--INPUT改为QBE
#     #----- 工廠編號 -B---#
#     CALL SET_COUNT(1)    # initial array argument
#     LET tm.plant[1] = g_plant
#
#     LET l_allow_insert = cl_detail_input_auth("insert")
#     LET l_allow_delete = cl_detail_input_auth("delete")
#
#     INPUT ARRAY tm.plant WITHOUT DEFAULTS FROM s_plant.*
#           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#                     INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)
#
#        #-----FUN-8C0097---------
#        BEFORE ROW 
#           LET l_ac = ARR_CURR()
#        #-----END FUN-8C0097-----
#
#        AFTER FIELD plant
#           LET l_ac = ARR_CURR()
#           IF NOT cl_null(tm.plant[l_ac]) THEN
#              SELECT azp01 FROM azp_file WHERE azp01 = tm.plant[l_ac]
#              IF STATUS THEN
#                 CALL cl_err('sel azp',STATUS,1)  # No.FUN-660167
#                 CALL cl_err3("sel","azp_file",tm.plant[l_ac],"",STATUS,"","sel azp",1)   #No.FUN-660167
#                 NEXT FIELD plant
#              END IF
#              FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
#                  IF tm.plant[i] = tm.plant[l_ac] THEN
#                    CALL cl_err('','aom-492',1) NEXT FIELD plant
#                  END IF
#              END FOR
#              IF NOT s_chkdbs(g_user,tm.plant[l_ac],g_rlang) THEN
#                 NEXT FIELD plant
#              END IF
#              #No.TQC-A50044--begin                                            
#              IF NOT s_chk_demo(g_user,tm.plant[l_ac]) THEN                    
#                 NEXT FIELD tm.plant                                           
#              END IF                                                           
#              #No.TQC-A50044--end
#           END IF
#        AFTER INPUT                    # 檢查至少輸入一個工廠
#           IF INT_FLAG THEN EXIT INPUT END IF
#           LET g_atot = ARR_COUNT()
#           FOR i = 1 TO g_atot
#              IF NOT cl_null(tm.plant[i]) THEN
#                 EXIT INPUT
#              END IF
#           END FOR
#           IF i = g_atot+1 THEN
#              CALL cl_err('','aom-423',1)
#              NEXT FIELD plant
#           END IF
#
#        #-----FUN-8C0097---------
#        ON ACTION CONTROLP 
#           CASE WHEN INFIELD(plant)
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_zxy"
#              LET g_qryparam.arg1 = g_user
#              LET g_qryparam.construct = 'N'
#              LET g_qryparam.default1 = tm.plant[l_ac]
#              CALL cl_create_qry() RETURNING tm.plant[l_ac] 
#              DISPLAY BY NAME tm.plant[l_ac]
#              NEXT FIELD plant
#           END CASE
#        #-----END FUN-8C0097----- 
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
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
#     END INPUT
##**************************
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW axmr213_w
#        RETURN
#     END IF
#FUN-A70084--mark--end
 
      #----- 工廠編號 -E---#
      LET g_rank = 0
 
      INPUT BY NAME tm.sdate, tm.edate,tm.more WITHOUT DEFAULTS
         AFTER FIELD sdate
            IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
         AFTER FIELD edate
            IF cl_null(tm.edate) THEN NEXT FIELD edate END IF
            IF tm.sdate > tm.edate THEN NEXT FIELD edate END IF
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,
                         g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
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
         LET INT_FLAG = 0 CLOSE WINDOW axmr213_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08
         INTO l_cmd
         FROM zz_file                         #get exec cmd (fglgo xxxx)
         WHERE zz01='axmr213'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('axmr213','9031',1)   
         ELSE
           #LET tm.wc=cl_wcsub(tm.wc)
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
                            " '",tm.sdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                        #FUN-A70084--mark--str--
                        ##---------------No.TQC-610089 add
                        #   " '",tm.plant[1] CLIPPED,"'",
                        #   " '",tm.plant[2] CLIPPED,"'",
                        #   " '",tm.plant[3] CLIPPED,"'",
                        #   " '",tm.plant[4] CLIPPED,"'",
                        #   " '",tm.plant[5] CLIPPED,"'",
                        #   " '",tm.plant[6] CLIPPED,"'",
                        #   " '",tm.plant[7] CLIPPED,"'",
                        #   " '",tm.plant[8] CLIPPED,"'",
                        #   " '",tm.plant[9] CLIPPED,"'",
                        #   " '",tm.plant[10] CLIPPED,"'",
                        #   " '",tm.plant[11] CLIPPED,"'",
                        #   " '",tm.plant[12] CLIPPED,"'",
                        ##---------------No.TQC-610089 end
                        #FUN-A70084--mark--end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",g_wc CLIPPED,"'"            #No.FUN-A70084
            CALL cl_cmdat('axmr213',g_time,l_cmd)  # Execute cmd at later time
         END IF
         CLOSE WINDOW axmr213_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL axmr213()
      ERROR ""
   END WHILE
   CLOSE WINDOW axmr213_w
END FUNCTION
 
FUNCTION axmr213()
   DEFINE l_name    LIKE type_file.chr20,           # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(1000)
          l_rate    LIKE oea_file.oea24,  #No.MOD-640559 add
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_dbs     LIKE azp_file.azp03,  #No.FUN-680137 VARCHAR(22)
          j         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_occ01   LIKE occ_file.occ01,
          l_amt     LIKE occ_file.occ63,
          sr        RECORD
                    occ01  LIKE occ_file.occ01, #客戶編號
                    occ02  LIKE occ_file.occ02, #客戶簡稱
                    occ63  LIKE occ_file.occ63, #信用額度
                    occ45  LIKE occ_file.occ45, #收款條件
                    oag02  LIKE oag_file.oag02,  #收款條件說明
                    occ36  LIKE occ_file.occ36,
                    occ175 LIKE occ_file.occ175,
                    plant  LIKE cre_file.cre08,  #No.FUN-680137 VARCHAR(10)
                    occ631 LIKE occ_file.occ631   #No.MOD-640559 add
                    END RECORD,
          sr1       RECORD
                    occ01  LIKE occ_file.occ01, #客戶編號
                    occ02  LIKE occ_file.occ02, #客戶簡稱
                    occ63  LIKE occ_file.occ63, #信用額度
                    occ45  LIKE occ_file.occ45,
                    oag02  LIKE oag_file.oag02,  #收款條件說明
                    occ36  LIKE occ_file.occ36,
                    occ175 LIKE occ_file.occ175,
                    plant  LIKE cre_file.cre08,  #No.FUN-680137 VARCHAR(10)
                    occ631 LIKE occ_file.occ631,   #No.MOD-640559 add
                    amt    LIKE occ_file.occ63
                    END RECORD
    DEFINE          l_cnt  LIKE type_file.num5    #FUN-A80097
    DEFINE          l_sd   LIKE type_file.chr1    #FUN-A80097 l_sd ='Y' 為single db
 
 
    CALL cl_del_data(l_table)        ### FUN-710071 ###
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                   #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND occuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                   #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
     #End:FUN-980030
 
 
#FUN-A70084--mod--str--
#    FOR j = 1 TO g_atot
#        IF cl_null(tm.plant[j]) THEN CONTINUE FOR END IF
     LET l_sql = "SELECT azw01 FROM azw_file,azp_file ",
                 " WHERE azp01 = azw01 AND azwacti = 'Y'",
                 "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
                 "   AND ",g_wc CLIPPED
     PREPARE sel_azw01_pre FROM l_sql
     DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
     FOREACH sel_azw01_cur INTO m_plant 
         IF cl_null(m_plant) THEN CONTINUE FOREACH END IF 
         #FUN-A80097--add--str--
         IF l_sd = 'Y' THEN EXIT FOREACH END IF
         CALL r213_set_entry() RETURNING l_cnt
         IF l_cnt>1 THEN    #single db以g_plant跨庫
            LET m_plant = g_plant
            LET l_sd = 'Y'
         END IF  
         #FUN-A80097--add--end
#FUN-A70084--mod--end
         #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = tm.plant[j] #FUN-A50102
         #LET l_dbs = s_dbstring(l_dbs CLIPPED)    #FUN-A50102
         LET l_sql="SELECT occ01,occ02,occ63,occ45,oag02,",
                   "       occ36,occ175,'',occ631",          #No.MOD-640559 modify
                   #"  FROM ",l_dbs CLIPPED,"occ_file,",
                   #          l_dbs CLIPPED,"oag_file",
                  #FUN-A70084--mod--str--
                  #"  FROM ",cl_get_target_table(tm.plant[j],'occ_file'),",", #FUN-A50102 
                  #          cl_get_target_table(tm.plant[j],'oag_file'),     #FUN-A50102
                   "  FROM ",cl_get_target_table(m_plant,'occ_file'),",", 
                             cl_get_target_table(m_plant,'oag_file'),    
                  #FUN-A70084--mod--end
                   " WHERE ",tm.wc CLIPPED,
                   "   AND occ45 = oag01 ",
                   "   AND occ62 = 'Y'   ",
                  #MOD-640324-----------mod----------
                  #"   AND occ175 >= '",tm.sdate,"'"  ,
                  #"   AND occ175 <= '",tm.edate,"'"
                   "   AND ((occ175 >= '",tm.sdate,"'",
                   "   AND occ175 <= '",tm.edate,"')",
                   "   OR  occ175 IS NULL )"
                  #MOD-640324-----------end----------
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-920032
        #CALL cl_parse_qry_sql(l_sql,tm.plant[j]) RETURNING l_sql #FUN-A50102   #FUN-A70084
         CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql #FUN-A70084
         PREPARE axmr213_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
            EXIT PROGRAM
         END IF
         DECLARE axmr213_curs1 CURSOR FOR axmr213_prepare1
         FOREACH axmr213_curs1 INTO sr.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            IF cl_null(sr.occ63) THEN LET sr.occ63=0 END IF
           #LET sr.plant = tm.plant[j]   #FUN-A70084
            LET sr.plant = m_plant   #FUN-A70084
 
            IF STATUS = 0 THEN
              #-----------#No.MOD-640559 add
               LET l_rate = 1
               SELECT oaz212 INTO g_oaz.oaz212 FROM oaz_file WHERE oaz00 = '0'
               LET l_rate = s_exrate(sr.occ631,g_aza.aza17,g_oaz.oaz212)
              #-----------#No.MOD-640559 end
               INSERT INTO x VALUES(sr.occ01,sr.occ02,sr.occ63,sr.occ45,
                        sr.oag02,sr.occ36,sr.occ175,sr.plant,sr.occ631,l_rate)     #No.MOD-640559 modify
            END IF
    
        ### FUN-710071 Start ###
        EXECUTE insert_prep USING sr.occ01,sr.occ02,sr.occ63,sr.oag02,
                                  sr.occ36,sr.occ175,sr.plant
        ### FUN-710071 End ###
 
         END FOREACH
     #END FOR         #FUN-A70084
      END FOREACH   #FUN-A70084
         LET l_sql = "SELECT x01,sum(x63 * xrate) FROM x",    #No.MOD-640559 modify
                     " GROUP BY x01"
         PREPARE axmr213_prepare2 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
            EXIT PROGRAM
         END IF
         DECLARE axmr213_curs2 CURSOR FOR axmr213_prepare2
 
         FOREACH axmr213_curs2 INTO l_occ01,l_amt
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            INSERT INTO y VALUES(l_occ01,l_amt)
         END FOREACH
         LET l_sql = "SELECT x01,x02,x63,x45,xg02,x53,x175,xplant,x631,y63",  #No.MOD-640559 modify
                     " FROM x,y WHERE x01=y01 ORDER BY y63"
         PREPARE axmr213_prepare3 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)  
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
            EXIT PROGRAM
         END IF
         DECLARE axmr213_curs3 CURSOR FOR axmr213_prepare3
 
         FOREACH axmr213_curs3 INTO sr1.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
         END FOREACH
      ### FUN-710071 Start ###   
      LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED ,l_table CLIPPED
      CALL cl_prt_cs3("axmr213","axmr213",l_sql,"") 
      ### FUN-710071 End ###   
END FUNCTION
#FUN-A80097--add--str--
FUNCTION r213_set_entry()
DEFINE l_cnt    LIKE type_file.num5
DEFINE l_azw05  LIKE azw_file.azw05

  SELECT azw05 INTO l_azw05 FROM azw_file WHERE azw01 = g_plant
  SELECT count(*) INTO l_cnt FROM azw_file
   WHERE azw05 = l_azw05

  IF l_cnt > 1 THEN   #為single db
     CALL cl_set_comp_visible("gb11",FALSE)
  END IF
  RETURN l_cnt
END FUNCTION
#FUN-A80097--add--end 
