# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr180.4gl
# Descriptions...: 潛在應收帳款計算表
# Date & Author..: 98/11/05 By Connie
# Modify.........: No.FUN-4C0100 04/12/27 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: No.FUN-610020 06/01/18 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.TQC-5C0086 05/12/19 By Carrier AR月底重評修改
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10098 10/01/20 By baofei GP5.2跨DB報表--財務類
# Modify.........: No.FUN-A60056 10/07/12 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056問題 
# Modify.........: No:FUN-B20020 11/02/15 By destiny 增加收款单条件

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                    # Print condition RECORD
              wc      STRING,                           # Where condition
              plant   ARRAY[12] OF LIKE azp_file.azp01, #No.FUN-680123 VARCHAR(10)
              bdate   LIKE type_file.dat,               #No.FUN-680123 DATE
              more    LIKE type_file.chr1               # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD,
          g_format    LIKE oea_file.oea01,              #No.FUN-680123 VARCHAR(16)
          g_atot      LIKE type_file.num5               # total array #No.FUN-680123 SMALLINT
 
 
DEFINE   g_cnt        LIKE type_file.num10              #No.FUN-680123 INTEGER
DEFINE   g_i          LIKE type_file.num5               #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   i,j          LIKE type_file.num5               #No.FUN-680123 SMALLINT
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
 
 
   INITIALIZE tm.* TO NULL               # Default condition
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #-----TQC-610059---------
#FUN-A10098---BEGIN
#   LET tm.plant[1] = ARG_VAL(8)
#   LET tm.plant[2] = ARG_VAL(9)
#   LET tm.plant[3] = ARG_VAL(10)
#   LET tm.plant[4] = ARG_VAL(11)
#   LET tm.plant[5] = ARG_VAL(12)
#   LET tm.plant[6] = ARG_VAL(13)
#   LET tm.plant[7] = ARG_VAL(14)
#   LET tm.plant[8] = ARG_VAL(15)
#   LET tm.plant[9] = ARG_VAL(16)
#   LET tm.plant[10] = ARG_VAL(17)
#   LET tm.plant[11] = ARG_VAL(18)
#   LET tm.plant[12] = ARG_VAL(19)
#   FOR i = 1 TO 12
#       IF NOT cl_null(ARG_VAL(i+7)) THEN
#          LET g_atot = g_atot + 1
#       END IF
#   END FOR
#   LET tm.bdate = ARG_VAL(20)
#   #-----END TQC-610059-----
#   #No.FUN-570264 --start--
#   LET g_rep_user = ARG_VAL(21)
#   LET g_rep_clas = ARG_VAL(22)
#   LET g_template = ARG_VAL(23)
   LET tm.bdate = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
#FUN-A10098---END
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob='N'  THEN
      CALL axrr180_tm(0,0)             # Input print condition
   ELSE
      CALL axrr180()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr180_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          i            LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_ac         LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd        LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(400)
          l_oob05      LIKE oob_file.oob05           #No.FUN-680123 VARCHAR(10)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW axrr180_w AT p_row,p_col
        WITH FORM "axr/42f/axrr180"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   LET g_pdate=g_today
   LET g_rlang=g_lang
   LET g_bgjob='N'
   LET g_copies='1'
   LET tm.more='N'
   LET tm.bdate= g_today
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON occ01
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#FUN-A10098---BEGIN
#  #----- 工廠編號 -B---#
#  CALL SET_COUNT(1)    # initial array argument
#  LET tm.plant[1] = g_plant
#  INPUT ARRAY tm.plant WITHOUT DEFAULTS FROM s_plant.*
#      BEFORE ROW               #No.FUN-560239
#         LET l_ac = ARR_CURR()
#
#      AFTER FIELD plant
#       # LET l_ac = ARR_CURR()   #No.FUN-560239 Mark
#         IF NOT cl_null(tm.plant[l_ac]) THEN
#            SELECT azp01 FROM azp_file WHERE azp01 = tm.plant[l_ac]
#            IF STATUS THEN
##               CALL cl_err('sel azp',STATUS,1)   #No.FUN-660116
#               CALL cl_err3("sel","azp_file",tm.plant[l_ac],"",STATUS,"","sel azp",1)   #No.FUN-660116
#               NEXT FIELD plant  
#            END IF
#            FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
#                IF tm.plant[i] = tm.plant[l_ac] THEN
#                   CALL cl_err('','aom-492',1) NEXT FIELD plant
#                END IF
#            END FOR
#            IF NOT s_chkdbs(g_user,tm.plant[l_ac],g_rlang) THEN
#               NEXT FIELD plant
#            END IF
#         END IF
#      AFTER INPUT                    # 檢查至少輸入一個工廠
#         IF INT_FLAG THEN EXIT INPUT END IF
#         LET g_atot = ARR_COUNT()
#         FOR i = 1 TO g_atot
#             IF NOT cl_null(tm.plant[i]) THEN
#                EXIT INPUT
#             END IF
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
#         LET g_qryparam.default1 = tm.plant[l_ac]
#         CALL cl_create_qry() RETURNING tm.plant[l_ac]
#         CALL FGL_DIALOG_SETBUFFER(tm.plant[l_ac])
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
#  IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW axrr180_w RETURN END IF
#  #----- 工廠編號 -E---#
#FUN-A10098---END
      INPUT BY NAME tm.bdate,tm.more WITHOUT DEFAULTS
      AFTER FIELD bdate
         IF cl_null(tm.bdate) THEN
            NEXT FIELD bdate
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr180_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr180'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr180','9031',1)
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
#FUN-A10098---begin
                  #       " '",tm.plant[1] CLIPPED,"'" ,
                  #       " '",tm.plant[2] CLIPPED,"'" ,
                  #       " '",tm.plant[3] CLIPPED,"'" ,
                  #       " '",tm.plant[4] CLIPPED,"'" ,
                  #       " '",tm.plant[5] CLIPPED,"'" ,
                  #       " '",tm.plant[6] CLIPPED,"'" ,
                  #       " '",tm.plant[7] CLIPPED,"'" ,
                  #       " '",tm.plant[8] CLIPPED,"'" ,
                  #       " '",tm.plant[9] CLIPPED,"'" ,
                  #       " '",tm.plant[10] CLIPPED,"'" ,
                   #      " '",tm.plant[11] CLIPPED,"'" ,
                   #      " '",tm.plant[12] CLIPPED,"'" ,
#FUN-A10098---end
                         " '",tm.bdate CLIPPED,"'" ,
                         #-----END TQC-610059-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr180',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr180_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr180()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr180_w
END FUNCTION
 
FUNCTION axrr180()
   DEFINE
          l_name    LIKE type_file.chr20,       # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(1000)
          l_cmd     LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,     #No.FUN-680123 VARCHAR(40)
          l_dbs     LIKE type_file.chr21,       #No.FUN-680123 VARCHAR(22)
          l_cnt     LIKE type_file.num5,        #FUN-A60056
          l_azw01   LIKE azw_file.azw01,        #FUN-A60056
          sr        RECORD
                occ01  LIKE occ_file.occ01,     #No.FUN-680123 VARCHAR(10)
                amt1   LIKE type_file.num20_6,  #No.FUN-680123 DECIMAL(20,6)
                amt2   LIKE type_file.num20_6,  #No.FUN-680123 DECIMAL(20,6)
                amt3   LIKE type_file.num20_6,  #No.FUN-680123 DECIMAL(20,6)
                amt4   LIKE type_file.num20_6,  #No.FUN-680123 DECIMAL(20,6)
                amt5   LIKE type_file.num20_6,  #No.FUN-680123 DECIMAL(20,6)
                amt6   LIKE type_file.num20_6   #No.FUN-680123 DECIMAL(20,6)
              END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND occuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND occgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
     #End:FUN-980030
 
 
     CALL cl_outnam('axrr180') RETURNING l_name
           #No.FUN-680123 begin
     CREATE TEMP TABLE tmp_r180
   (plant  LIKE azp_file.azp01,
    occ01  LIKE occ_file.occ01,
    amt1   LIKE type_file.num20_6,
    amt2   LIKE type_file.num20_6,
    amt3   LIKE type_file.num20_6,
    amt4   LIKE type_file.num20_6,
    amt5   LIKE type_file.num20_6,
    amt6   LIKE type_file.num20_6)        #No.FUN-680123 end
 
     START REPORT axrr180_rep TO l_name
     LET g_pageno = 0
     LET j = 1
     LET g_format = "----,---,---,--&"
##FUN-A10098---begin
#     FOR j = 1 TO g_atot
#         IF cl_null(tm.plant[j]) THEN CONTINUE FOR END IF
#         LET g_cnt = j
#         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = tm.plant[j]
#         LET l_dbs = s_dbstring(l_dbs CLIPPED)
         LET tm.plant[j]= ' ' 
##FUN-A10098---end
###  得客戶信用餘額
         LET l_sql="SELECT occ01,occ63",
                 #  "  FROM ",l_dbs CLIPPED,"occ_file",   #FUN-A10098
                   "  FROM occ_file",   #FUN-A10098
                   " WHERE ",tm.wc CLIPPED
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr180_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare1:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr180_curs1 CURSOR FOR axrr180_prepare1
         FOREACH axrr180_curs1 INTO sr.occ01,sr.amt1
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            INSERT INTO tmp_r180 VALUES(tm.plant[j],sr.occ01,sr.amt1,
            0,0,0,0,0)
         END FOREACH
 
###  得應收帳款餘額
         CALL trs_str('occ01','oma03')
         CALL trs_str('occuser','omauser')
         CALL trs_str('occgrup','omagrup')
         #No.TQC-5C0086  --Begin                                                                                                    
         IF g_ooz.ooz07 = 'N' THEN
       #---modi by kitty Bug NO:A053
            LET l_sql="SELECT oma03,SUM(oma56t-oma57)",
           #LET l_sql="SELECT oma03,SUM(oma61)",
                  #    "  FROM ",l_dbs CLIPPED,"oma_file",  #FUN-A10098
                      "  FROM oma_file",  #FUN-A10098
                      " WHERE ",tm.wc CLIPPED,
                      "   AND oma02 <= '",tm.bdate,"'",
         #             "   AND SUBSTRING(oma00,1,1) = '1' AND omaconf = 'Y'",  #FUN-A10098
                      "   AND SUBSTR(oma00,1,1) = '1' AND omaconf = 'Y'",  #FUN-A10098
      "   AND omavoid = 'N' ",
      " GROUP BY oma03"
         ELSE                                                                                                                       
              LET l_sql="SELECT oma03,SUM(oma61)",                                                                                  
                    #    "  FROM ",l_dbs CLIPPED,"oma_file",   #FUN-A10098                                                                      
                        "  FROM oma_file",   #FUN-A10098                                                                      
                        " WHERE ",tm.wc CLIPPED,                                                                                    
                        "   AND oma02 <= '",tm.bdate,"'",                                                                           
                     #   "   AND SUBSTRING(oma00,1,1) = '1' AND omaconf = 'Y'",   #FUN-A10098                                                              
                        "   AND SUBSTR(oma00,1,1) = '1' AND omaconf = 'Y'",   #FUN-A10098                                                              
                        "   AND omavoid = 'N' ",                                                                                    
                        " GROUP BY oma03"                                                                                           
         END IF                                                                                                                     
         #No.TQC-5C0086  --End 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr180_prepare2 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr180_curs2 CURSOR FOR axrr180_prepare2
         FOREACH axrr180_curs2 INTO sr.occ01,sr.amt1
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            INSERT INTO tmp_r180 VALUES(tm.plant[j],sr.occ01,0,sr.amt1,
            0,0,0,0)
         END FOREACH
 
###  得收款未確認
         CALL trs_str('oma03','ooa03')
         CALL trs_str('omauser','ooauser')
         CALL trs_str('omagrup','ooagrup')
         LET l_sql="SELECT ooa03,SUM(oob10) ",
                #   "  FROM ",l_dbs CLIPPED,"ooa_file,",#FUN-A10098
               #              l_dbs CLIPPED,"oob_file", #FUN-A10098
                   "  FROM ooa_file,",#FUN-A10098
                           "oob_file", #FUN-A10098
                   " WHERE ooa02 <= '",tm.bdate,"'",
                   "   AND ",tm.wc CLIPPED,
                   "   AND ooaconf = 'N' ",
                   "   AND ooa37='1' ",               #FUN-B20020
                   "   AND ooa01 = oob01 ",
      "   AND oob03 = '1' AND oob04 IN ('1','2','8') ", 
      " GROUP BY ooa03"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr180_prepare3 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare3:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr180_curs3 CURSOR FOR axrr180_prepare3
         FOREACH axrr180_curs3 INTO sr.occ01,sr.amt1
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            INSERT INTO tmp_r180 VALUES(tm.plant[j],sr.occ01,0,0,sr.amt1,
            0,0,0)
         END FOREACH
 
###  得預收/溢收確認
         LET l_sql="SELECT ooa03,SUM(oob10) ",
             #      "  FROM ",l_dbs CLIPPED,"ooa_file,",  #FUN-A10098
             #                l_dbs CLIPPED,"oob_file",   #FUN-A10098
                   "  FROM ooa_file,",  #FUN-A10098
                           "oob_file",   #FUN-A10098
                   " WHERE ooa02 <= '",tm.bdate,"'",
                   "   AND ",tm.wc CLIPPED,
                   "   AND ooaconf = 'Y' ",
                   "   AND ooa37='1' ",               #FUN-B20020
                   "   AND ooa01 = oob01 ",
       "   AND oob03 = '2' AND oob04 IN ('1','2') ",
       " GROUP BY ooa03"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr180_prepare4 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare4:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr180_curs4 CURSOR FOR axrr180_prepare4
         FOREACH axrr180_curs4 INTO sr.occ01,sr.amt1
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            INSERT INTO tmp_r180 VALUES(tm.plant[j],sr.occ01,0,0,0,sr.amt1,
            0,0)
         END FOREACH
 
###  得未出貨預計出貨額(出貨通知單,未稅)
         CALL trs_str('ooa03','oga03')
         CALL trs_str('ooauser','ogauser')
         CALL trs_str('ooagrup','ogagrup')
#FUN-A60056--add--str--
     LET l_sql = "SELECT azw01 FROM azw_file WHERE azwacti = 'Y' ",
                 "   AND azw02 = '",g_legal,"'"
     PREPARE sel_azw01_pre FROM l_sql
     DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
     FOREACH sel_azw01_cur INTO l_azw01 
#FUN-A60056--add--end
         LET l_sql="SELECT oga03,SUM(ogb14*oga24)",
                #   "  FROM ",l_dbs CLIPPED,"oga_file,",  #FUN-A10098
                #             l_dbs CLIPPED,"ogb_file",   #FUN-A10098
                  #FUN-A60056--mod--str--
                  #"  FROM oga_file,",  #FUN-A10098
                  #        "ogb_file",   #FUN-A10098
                   "  FROM ",cl_get_target_table(l_azw01,'oga_file'),",",
                   "       ",cl_get_target_table(l_azw01,'ogb_file'),
                  #FUN-A60056--mod--end
                   " WHERE oga02 <= '",tm.bdate,"'",
                   "   AND ",tm.wc CLIPPED,
                   "   AND ogaconf = 'Y' ",
                   "   AND oga09 = '1' AND oga01 = ogb01 ",
                  #"   AND oga01 NOT IN (SELECT oga011 FROM oga_file ",   #FUN-A70139
                   "   AND oga01 NOT IN (SELECT oga011 FROM  ",cl_get_target_table(l_azw01,'oga_file'),   #FUN-A70139
     #"   WHERE oga01 IS NOT NULL AND oga09 IN ('2','8') AND oga65='N' ) ",   #FUN-A60056
      "   WHERE oga01 IS NOT NULL AND oga09 IN ('2','8') AND oga65='N' AND oga011 IS NOT NULL) ",   #FUN-A60056
      " GROUP BY oga03"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_azw01) RETURNING l_sql  #FUN-A70139
         PREPARE axrr180_prepare5 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare5:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
         END IF
         DECLARE axrr180_curs5 CURSOR FOR axrr180_prepare5
         FOREACH axrr180_curs5 INTO sr.occ01,sr.amt1
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
           #FUN-A60056--add--str--該客戶當前法人下所有PLANT得總和
            SELECT COUNT(*) INTO l_cnt FROM tmp_r180 WHERE occ01 = sr.occ01 
               AND amt5>0
            IF l_cnt > 0  THEN
               UPDATE tmp_r180 SET amt5 = amt5 + sr.amt1
                WHERE occ01 = sr.occ01
            ELSE
           #FUN-A60056--add--end 
               INSERT INTO tmp_r180 VALUES(tm.plant[j],sr.occ01,0,0,0,0,sr.amt1,0)
            END IF    #FUN-A60056 
         END FOREACH
     END FOREACH    #FUN-A60056 
 
###  得應收票據餘額
         CALL trs_str('oga03','nmh11')
         CALL trs_str('ogauser','nmhuser')
         CALL trs_str('ogagrup','nmhgrup')
         LET l_sql="SELECT nmh11,SUM(nmh32)",
              #     "  FROM ",l_dbs CLIPPED,"nmh_file",  #FUN-A10098
                   "  FROM nmh_file",  #FUN-A10098
                   " WHERE nmh04 <= '",tm.bdate,"'",
                   "   AND ",tm.wc CLIPPED ,
      "   AND nmh38 = 'Y' AND nmh24 IN ('1','2','3','4','5') ",
      " GROUP BY nmh11"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr180_prepare6 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare6:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM 
               
         END IF
         DECLARE axrr180_curs6 CURSOR FOR axrr180_prepare6
         FOREACH axrr180_curs6 INTO sr.occ01,sr.amt1
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            INSERT INTO tmp_r180 VALUES(tm.plant[j],sr.occ01,0,0,0,0,0,sr.amt1)
         END FOREACH
         CALL trs_str('nmh11','occ01')
 #    END FOR  #FUN-A10098
 
      DECLARE a_curs CURSOR FOR
      SELECT occ01,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4),
                   SUM(amt5),SUM(amt6) FROM tmp_r180
       GROUP BY occ01
     FOREACH a_curs INTO sr.occ01,sr.amt1,sr.amt2,sr.amt3,sr.amt4,
                         sr.amt5 ,sr.amt6
        IF sr.amt1 = 0 AND sr.amt2 = 0 AND sr.amt3 = 0 AND sr.amt4 = 0 AND
           sr.amt5 = 0 AND sr.amt6 THEN
           CONTINUE FOREACH
        END IF
        OUTPUT TO REPORT axrr180_rep(sr.*)
     END FOREACH
     FINISH REPORT axrr180_rep
     DROP TABLE tmp_r180
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT axrr180_rep(sr)
   DEFINE
          l_last_sw,l_sw LIKE type_file.chr1,     #No.FUN-680123 VARCHAR(1)
          l_flag    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_xxx     LIKE type_file.chr8,          #No.FUN-680123 VARCHAR(8)
          l_occ02   LIKE occ_file.occ02,
          l_amt     LIKE type_file.num20_6,       #No.FUN-680123 DECIMAL(20,6)
          sr        RECORD
                occ01  LIKE occ_file.occ01,       #No.FUN-680123 VARCHAR(10)
                amt1   LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
                amt2   LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
                amt3   LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
                amt4   LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
                amt5   LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
                amt6   LIKE type_file.num20_6     #No.FUN-680123 DECIMAL(20,6)
               END RECORD, 
          rr       RECORD
               plant   LIKE azp_file.azp01,       #No.FUN-680123 VARCHAR(10)
               amt1    LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
               amt2    LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
               amt3    LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
               amt4    LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
               amt5    LIKE type_file.num20_6,    #No.FUN-680123 DECIMAL(20,6)
               amt6    LIKE type_file.num20_6     #No.FUN-680123 DECIMAL(20,6)
               END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
   ORDER BY sr.occ01
 
   FORMAT
     PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
        LET g_pageno = g_pageno + 1
        LET pageno_total = PAGENO USING '<<<',"/pageno"
        PRINT g_head CLIPPED, pageno_total
        PRINT g_dash[1,g_len]
        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
              g_x[38],g_x[39],g_x[40]
        PRINT g_dash1
        LET l_last_sw = 'n'
    ON EVERY ROW
        SELECT occ02 INTO l_occ02 FROM occ_file
         WHERE occ01 = sr.occ01
        IF STATUS THEN
           LET l_occ02 = ' '
        END IF
        PRINT COLUMN g_c[31],sr.occ01 CLIPPED,COLUMN g_c[32],l_occ02 CLIPPED;
        LET l_amt = sr.amt2-sr.amt3-sr.amt4+sr.amt5-sr.amt6
        PRINT COLUMN g_c[33],cl_numfor(sr.amt1,33,g_azi04),
              COLUMN g_c[34],cl_numfor(sr.amt2,34,g_azi04),
              COLUMN g_c[35],cl_numfor(sr.amt3,35,g_azi04),
              COLUMN g_c[36],cl_numfor(sr.amt4,36,g_azi04),
              COLUMN g_c[37],cl_numfor(sr.amt5,37,g_azi04),
              COLUMN g_c[38],cl_numfor(sr.amt6,38,g_azi04),
              COLUMN g_c[39],cl_numfor(l_amt,39,g_azi04),
              COLUMN g_c[40],cl_numfor((sr.amt1 - l_amt),40,g_azi04)
   ON LAST ROW
       PRINT g_dash[1,g_len]
      DECLARE b_curs CURSOR FOR
        SELECT plant,SUM(amt2),SUM(amt3),SUM(amt4),SUM(amt5),SUM(amt6)
         FROM tmp_r180
        GROUP BY plant
        ORDER BY plant
       FOREACH b_curs INTO rr.plant,rr.amt2,rr.amt3,rr.amt4,rr.amt5,rr.amt6
          IF STATUS THEN
             EXIT FOREACH
          END IF
          PRINT COLUMN g_c[31],g_x[8],
             #   COLUMN g_c[33],rr.plant,  #FUN-A10098
                COLUMN g_c[34],cl_numfor(rr.amt2,34,g_azi05),
                COLUMN g_c[35],cl_numfor(rr.amt3,35,g_azi05),
                COLUMN g_c[36],cl_numfor(rr.amt4,36,g_azi05),
                COLUMN g_c[37],cl_numfor(rr.amt5,37,g_azi05),
                COLUMN g_c[38],cl_numfor(rr.amt6,38,g_azi05)
       END FOREACH
       IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
          CALL cl_wcchp(tm.wc,'occ01') RETURNING tm.wc
          PRINT g_dash[1,g_len]
          #TQC-630166
          #IF tm.wc[001,120] > ' ' THEN            # for 132
          #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
          #IF tm.wc[121,240] > ' ' THEN
          #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
          #IF tm.wc[241,300] > ' ' THEN
          #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
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
 
FUNCTION trs_str(s1,s2)
   DEFINE 
         s1,s2    LIKE aba_file.aba00       #No.FUN-680123 VARCHAR(5) 
   DEFINE i       LIKE type_file.num5       #No.FUN-680123 SMALLINT
  #TQC-630166
   DEFINE l_wc    LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(1000)
 
   LET l_wc = tm.wc
   FOR i = 1 TO 100
       IF i > 96 OR LENGTH(l_wc CLIPPED) < i THEN
          EXIT FOR
       END IF
       IF l_wc[i,i+4] = s1 THEN
         LET l_wc[i,i+4] = s2
       END IF
   END FOR
   LET tm.wc = l_wc
  #FOR i = 1 TO 100
  #    IF i > 96 OR LENGTH(tm.wc CLIPPED) < i THEN
  #       EXIT FOR
  #    END IF
  #   #IF tm.wc[i,i+4] = s1 THEN
  #    IF tm.wc.subString(i,i+4) = s1 THEN
 
  #      LET tm.wc.subString(i,i+4) = s2
  #      #LET tm.wc[i,i+4] = s2
  #    END IF
  #END FOR
  #END TQC-630166
END FUNCTION
 
