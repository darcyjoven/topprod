# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: admr115.4gl
# Descriptions...: 應收帳款提示表
# Date & Author..: 02/08/08 By Kitty
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.TQC-610083 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.TQC-5C0086 06/05/08 By ice AR月底重評修改 
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/30 By king 改正被誤定義為apm08類型的
# Modify.........: No.TQC-6A0116 06/11/08 By king 改正報表中有關錯誤
# Modify.........: NO.FUN-750027 07/07/12 BY TSD.c123k 改為crystal report
# Modify.........: No.FUN-940102 09/04/20 By dxfwo  新增使用者對營運中心的權限管控
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10056 10/01/14 By wuxj 去掉plant，mark FOR回圈，跨DB語法改為非跨DB 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      STRING, # Where condition  No.TQC-630166  
              bdate   LIKE type_file.dat,    # 發票截止日期                    #No.FUN-680097 DATE
              edate   LIKE type_file.dat,    # 資料截止日期                    #No.FUN-680097 DATE
              type    LIKE type_file.chr1,   # Choose report                   #No.FUN-680097 VARCHAR(01)
              jmp     LIKE type_file.chr1,   # Choose report                   #No.FUN-680097 VARCHAR(01) 
              more    LIKE type_file.chr1    # Input more condition(Y/N)       #No.FUN-680097 VARCHAR(01)
              END RECORD,
#FUN-A10056  mark
#         plant   ARRAY[12] OF LIKE oea_file.oea01, #工廠編號                 #No.FUN-680097 VARCHAR(12)
         g_sql   STRING,          #No.FUN-580092 HCN            
         g_atot  LIKE type_file.num5             #No.FUN-680097 SMALLINT
 
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE   i           LIKE type_file.num5          #No.FUN-680097 SMALLINT
DEFINE   g_str       STRING                  # FUN-750027 TSD.c123k
DEFINE   l_table     STRING                  # FUN-750027 TSD.c123k
DEFINE   g_plant     STRING                  # FUN-750027 TSD.c123k 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
   # add FUN-750027
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> TSD.c123k *** ##
   LET g_sql = "oma00.oma_file.oma00,",
               "oma01.oma_file.oma01,",
               "oma03.oma_file.oma03,",
               "oma032.oma_file.oma032,",
               "oma02.oma_file.oma02,", 
               "oma11.oma_file.oma11,", 
               "oma12.oma_file.oma12,", 
               "oma14.oma_file.oma14,", 
               "gen02.gen_file.gen02,", 
               "oma23.oma_file.oma23,", 
               "oma32.oma_file.oma32,", 
               "oag02.oag_file.oag02,", 
               "oma54t.oma_file.oma54t,",
               "azi04.azi_file.azi04"  
 
   LET l_table = cl_prt_temptable('admr115',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------------ CR (1) ------------------------------#
   # end FUN-750027
 
   IF STATUS THEN CALL cl_err('create',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM 
   END IF
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
#----------No.TQC-610083 modify
#NO.FUN-A10056 ----mark----
#   LET plant[1]  = ARG_VAL(8)
#   LET plant[2]  = ARG_VAL(9)
#   LET plant[3]  = ARG_VAL(10)
#   LET plant[4]  = ARG_VAL(11)
#   LET plant[5]  = ARG_VAL(12)
#   LET plant[6]  = ARG_VAL(13)
#   LET plant[7]  = ARG_VAL(14)
#   LET plant[8]  = ARG_VAL(15)
#   LET plant[9]  = ARG_VAL(16)
#   LET plant[10] = ARG_VAL(17)
#   LET plant[11] = ARG_VAL(18)
#   LET plant[12] = ARG_VAL(19)
   LET tm.bdate  = ARG_VAL(20)
   LET tm.edate  = ARG_VAL(21)
   LET tm.type   = ARG_VAL(22)
   LET tm.jmp    = ARG_VAL(23)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(24)
   LET g_rep_clas = ARG_VAL(25)
   LET g_template = ARG_VAL(26)
   LET g_rpt_name = ARG_VAL(27)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
#----------No.TQC-610083 end
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL admr115_tm(0,0)        # Input print condition
      ELSE CALL admr115()              # Read data and create out-file
   END IF
   DROP TABLE r115m_tmp
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION admr115_tm(p_row,p_col)
  DEFINE p_row,p_col    LIKE type_file.num5,           #No.FUN-680097 SMALLINT
         l_ac         LIKE type_file.num10,            #No.FUN-680097 INTEGER
         l_cmd        LIKE type_file.chr1000           #No.FUN-680097 VARCHAR(1000) 
  DEFINE li_result    LIKE type_file.num5              #No.FUN-940102
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 17
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW admr115_w AT p_row,p_col
        WITH FORM "adm/42f/admr115"
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
#   LET plant[1]=g_plant  #預設現行工廠 #NO.FUN-A10056 ----mark----
   LET tm.more = 'N'
   LET tm.type = '3'
   LET tm.jmp = 'N'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma03,oma14
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
      LET INT_FLAG = 0 CLOSE WINDOW admr115_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   #----- 工廠編號 -B---#
   CALL SET_COUNT(1)    # initial array argument
#NO.FUN-A10056  start ---mark
#   INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.*
#       AFTER FIELD plant
#          LET l_ac = ARR_CURR()
#          IF NOT cl_null(plant[l_ac]) THEN
#             SELECT azp01 FROM azp_file WHERE azp01 = plant[l_ac]
#             IF STATUS THEN
#                CALL cl_err('sel azp',STATUS,1) NEXT FIELD plant
#             END IF
#             FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆            
#                 IF plant[i] = plant[l_ac] THEN
#                    CALL cl_err('','aom-492',1) NEXT FIELD plant
#                 END IF
#             END FOR
#     #No.FUN-940102 --begin--
#            CALL s_chk_demo(g_user,plant[l_ac]) RETURNING li_result
#            IF not li_result THEN 
#             NEXT FIELD plant
#            END IF 
#     #No.FUN-940102 --end--
#             IF NOT s_chkdbs(g_user,plant[l_ac],g_rlang) THEN
#                NEXT FIELD plant
#             END IF
#          END IF
#       AFTER INPUT                    # 檢查至少輸入一個工廠
#          IF INT_FLAG THEN EXIT INPUT END IF
#          LET g_atot = ARR_COUNT()
#          FOR i = 1 TO g_atot
#              IF NOT cl_null(plant[i]) THEN EXIT INPUT END IF
#          END FOR
#          IF i = g_atot+1 THEN
#             CALL cl_err('','aom-423',1) NEXT FIELD plant
#          END IF

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
# NO.FUN-A10056 ---END---

   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW admr115_w RETURN END IF
 
   INPUT BY NAME tm.bdate,tm.edate,tm.type,tm.jmp,tm.more WITHOUT DEFAULTS
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
         END IF
      AFTER FIELD edate
         IF cl_null(tm.edate) OR tm.edate<tm.bdate THEN
            NEXT FIELD edate
         END IF
 
      AFTER FIELD type
        IF cl_null(tm.type) OR tm.type NOT MATCHES '[123]' THEN
            NEXT FIELD type
         END IF
 
      AFTER FIELD jmp
        IF cl_null(tm.jmp) OR tm.jmp NOT MATCHES '[YN]' THEN
            NEXT FIELD jmp
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
      LET INT_FLAG = 0 CLOSE WINDOW admr115_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='admr115'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('admr115','9031',1)
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
                    #NO.FUN-A10056 ---mark---
                    #    " '",plant[1] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[2] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[3] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[4] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[5] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[6] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[7] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[8] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[9] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[10] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[11] CLIPPED,"'",     #No.TQC-610083 add
                    #    " '",plant[12] CLIPPED,"'",     #No.TQC-610083 add
                         " '",tm.bdate CLIPPED,"'",
                         " '",tm.edate CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",
                         " '",tm.jmp CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('admr115',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW admr115_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL admr115()
   ERROR ""
END WHILE
   CLOSE WINDOW admr115_w
END FUNCTION
 
FUNCTION admr115()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0100
          l_sql     LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680097 VARCHAR(40)
          l_i,l_j   LIKE type_file.num5,          #No.FUN-680097 SMALLINT
          l_dbs     LIKE type_file.chr21,         #No.FUN-680097 VARCHAR(21)
          sr        RECORD
                    plant     LIKE azp_file.azp01,#No.FUN-680097 VARCHAR(10)
                    oma00     LIKE oma_file.oma00,  #帳款類別
                    oma01     LIKE oma_file.oma01,  #帳款編號
                    oma03     LIKE oma_file.oma03,  #客戶編號
                    oma032    LIKE oma_file.oma032, #簡稱
                    oma02     LIKE oma_file.oma02,  #發票日期
                    oma11     LIKE oma_file.oma11,  #應收款日
                    oma12     LIKE oma_file.oma12,  #
                    oma14     LIKE oma_file.oma14,  #人員編號
                    gen02     LIKE gen_file.gen02,  #
                    oma23     LIKE oma_file.oma23,  #幣別
                    oma32     LIKE oma_file.oma32,  #收款條件
                    oag02     LIKE oag_file.oag02,  #
                    oma54t    LIKE oma_file.oma54t, #
                    azi04     LIKE azi_file.azi04   #
                    END RECORD
 
     # add FUN-750026
     ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> TSD.c123k *** ##
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #------------------------------ CR (2) ----------------------------------#
     # end FUN-750026
 
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
 
 
     #CALL cl_outnam('admr115') RETURNING l_name   #FUN-750027 TSD.c123k mark
     #START REPORT admr115_rep TO l_name   #FUN-750027 TSD.c123k mark
     LET g_pageno = 0
#NO.FUN-A10056 ---START---mark 
#    LET l_i = 1
#    FOR l_i = 1 TO g_atot
#        IF cl_null(plant[l_i]) THEN CONTINUE FOR END IF
#        SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = plant[l_i]
#        LET l_dbs = s_dbstring(l_dbs CLIPPED)
#        #No.TQC-5C0086  --Begin                                                                                                    
         SELECT ooz07 INTO g_ooz.ooz07 FROM ooz_file WHERE ooz00 = '0'                                                              
         IF g_ooz.ooz07 = 'N' THEN
#           #FUN-750027 TSD.c123k modify ---------------------------------------
#           {
#           LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma11,oma12,",
#                     "       oma14,gen02,oma23,oma32,oag02,oma54t-oma55,azi04",
#                     "  FROM ",l_dbs CLIPPED,"oma_file,OUTER ",
#                               l_dbs CLIPPED,"gen_file,OUTER  ",
#                               l_dbs CLIPPED,"oag_file,OUTER  ",
#                               l_dbs CLIPPED,"azi_file,OUTER  ",
#                               l_dbs CLIPPED,"occ_file  ",
#                     " WHERE oma11 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
#                     "   AND oma00 LIKE '1%'  AND oma23=azi_file.azi01 ",
#                     "   AND omaconf = 'Y' AND omavoid = 'N' ",
#                     "   AND oma56t > oma57 AND oma03=occ_file.occ01 ",
#                     "   AND oma14 =gen_file.gen01 AND oma32=oag_file.oag01 ",
#                     "   AND ",tm.wc CLIPPED
#           }
#           LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma11,oma12,",
#                     "       oma14,gen02,oma23,oma32,oag02,oma54t-oma55,azi04",
#                     "  FROM ",l_dbs CLIPPED,"oma_file, ",
#                               l_dbs CLIPPED,"gen_file, ",
#                               l_dbs CLIPPED,"oag_file, ",
#                               l_dbs CLIPPED,"azi_file,  ",
#                               l_dbs CLIPPED,"occ_file  ",
#                     " WHERE oma11 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
#                     "   AND oma00 LIKE '1%'  AND oma23=azi_file.azi01 ",
#                     "   AND omaconf = 'Y' AND omavoid = 'N' ",
#                     "   AND oma56t > oma57 AND oma03=occ_file.occ01 ",
#                     "   AND oma14 =gen_file.gen01 AND oma32=oag_file.oag01 ",
#                     "   AND ",tm.wc CLIPPED
#           #FUN-750027 TSD.c123k end ------------------------------------------
            LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma11,oma12,",
                      "       oma14,gen02,oma23,oma32,oag02,oma54t-oma55,azi04",
                      "  FROM ","oma_file,gen_file,oag_file,azi_file,occ_file ",
                      " WHERE oma11 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                      "   AND oma00 LIKE '1%'  AND oma23=azi_file.azi01 ",
                      "   AND omaconf = 'Y' AND omavoid = 'N' ",
                      "   AND oma56t > oma57 AND oma03=occ_file.occ01 ",
                      "   AND oma14 =gen_file.gen01 AND oma32=oag_file.oag01 ",
                      "   AND ",tm.wc CLIPPED
         ELSE                                                                                                                       
#           #FUN-750027 TSD.c123k modify ---------------------------------------
#           {
#           LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma11,oma12,",                                                      
#                     "       oma14,gen02,oma23,oma32,oag02,oma54t-oma55,azi04",                                                    
#                     "  FROM ",l_dbs CLIPPED,"oma_file,OUTER ",                                                                    
#                               l_dbs CLIPPED,"gen_file,OUTER  ",                                                                   
#                               l_dbs CLIPPED,"oag_file,OUTER  ",                                                                   
#                               l_dbs CLIPPED,"azi_file,OUTER  ",                                                                   
#                               l_dbs CLIPPED,"occ_file  ",                                                                         
#                     " WHERE oma11 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",                                                     
#                     "   AND oma00 LIKE '1%'  AND oma23=azi_file.azi01 ",                                                       
#                     "   AND omaconf = 'Y' AND omavoid = 'N' ",                                                                    
#                     "   AND oma61 > 0 AND oma03=occ_file.occ01 ",                                                                 
#                     "   AND oma14 =gen_file.gen01 AND oma32=oag_file.oag01 ",                                                     
#                     "   AND ",tm.wc CLIPPED                                   
#           }                                                    
#           LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma11,oma12,",                                                      
#                     "       oma14,gen02,oma23,oma32,oag02,oma54t-oma55,azi04",                                                    
#                     "  FROM ",l_dbs CLIPPED,"oma_file, ",                                                                    
#                               l_dbs CLIPPED,"gen_file, ",                                                                   
#                               l_dbs CLIPPED,"oag_file, ",                                                                   
#                               l_dbs CLIPPED,"azi_file, ",                                                                   
#                               l_dbs CLIPPED,"occ_file  ",                                                                         
#                     " WHERE oma11 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",                                                     
#                     "   AND oma00 LIKE '1%'  AND oma23=azi_file.azi01 ",                                                       
#                     "   AND omaconf = 'Y' AND omavoid = 'N' ",                                                                    
#                     "   AND oma61 > 0 AND oma03=occ_file.occ01 ",                                                                 
#                     "   AND oma14 =gen_file.gen01 AND oma32=oag_file.oag01 ",                                                     
#                     "   AND ",tm.wc CLIPPED                                                                                       
#           #FUN-750027 TSD.c123k end -----------------------------------------
            LET l_sql="SELECT '',oma00,oma01,oma03,oma032,oma02,oma11,oma12,",
                      "       oma14,gen02,oma23,oma32,oag02,oma54t-oma55,azi04",
                      "  FROM ","oma_file,gen_file,oag_file,azi_file,occ_file ",
                      " WHERE oma11 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                      "   AND oma00 LIKE '1%'  AND oma23=azi_file.azi01 ",
                      "   AND omaconf = 'Y' AND omavoid = 'N' ",
                      "   AND oma61 > 0 AND oma03=occ_file.occ01 ",
                      "   AND oma14 =gen_file.gen01 AND oma32=oag_file.oag01 ",
                      "   AND ",tm.wc CLIPPED
        END IF                                                                                                                     
#        #No.TQC-5C0086  --End
# NO.FUN-A10056 ----END---
         #---判斷關係人
         IF tm.type='1' THEN
            LET l_sql=l_sql CLIPPED," AND occ37='Y'"
         END IF
         IF tm.type='2' THEN
            LET l_sql=l_sql CLIPPED," AND occ37='N'"
         END IF
         #------
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE admr115_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
            EXIT PROGRAM
               
         END IF
         DECLARE admr115_curs1 CURSOR FOR admr115_prepare1
 
         FOREACH admr115_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
 
           #FUN-750027 TSD.c123k add
           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           EXECUTE insert_prep USING
              sr.oma00,  sr.oma01,  sr.oma03,   sr.oma032,   sr.oma02,
              sr.oma11,  sr.oma12,  sr.oma14,   sr.gen02,    sr.oma23,
              sr.oma32,  sr.oag02,  sr.oma54t,  sr.azi04 
           #------------------------------ CR (3) ------------------------------#
           #FUN-750027 TSD.c123k end
         END FOREACH
 
#     END FOR    #NO.FUN-A10056   mark
     #FINISH REPORT admr115_rep   #FUN-750027 TSD.c123k mark
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)   #FUN-750027 TSD.c123k mark
 
     # FUN-750027 add
#NO.FUN-A10056 ----START----mark
#     LET g_plant = plant[1]
#     FOR i = 2 TO 12 
#         IF NOT cl_null(plant[i]) THEN 
#            LET g_plant = g_plant CLIPPED,',' CLIPPED, plant[i] CLIPPED
#         END IF
#     END FOR 
#NO.FUN-A10056---END---    
     ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'oma03')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
     LET g_str = g_str,";",tm.jmp,";",tm.type,";",tm.bdate,";",tm.edate,";",g_plant
  
     CALL cl_prt_cs3('admr115','admr115',l_sql,g_str)
     #------------------------------ CR (4) ------------------------------#
     # FUN-750027 end
END FUNCTION
