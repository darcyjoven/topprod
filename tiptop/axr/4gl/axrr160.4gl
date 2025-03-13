# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr160.4gl
# Descriptions...: 客戶收款沖銷明細表
# Date & Author..: 98/11/03 By Connie
# Modify.........: No.FUN-4C0100 04/12/27 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-560239 05/07/12 By Nicola 多工廠資料欄位輸入開窗
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.MOD-680076 06/08/24 By Smapmin 輸入工廠別時,新增與刪除的功能取消
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-830151 08/04/02 By sherry 報表改由CR輸出 
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990201 09/10/18 By mike 資料庫名稱超過10位的話,則無法產生資料,其定義長度欄位不足                          
# Modify.........: No.FUN-A10098 10/01/20 By baofei GP5.2跨DB報表--財務類
# Modify.........: No:MOD-B10113 11/01/17 By Dido 第二個 FOREACH 改用判斷式處理
# Modify.........: No:FUN-B20020 11/02/15 By destiny 增加收款单条件
# Modify.........: No:MOD-B30048 11/03/07 By Dido 移除 DISTINCT 
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                       # Print condition RECORD
              wc      STRING,                              # Where condition
#              plant   ARRAY[12] OF LIKE azp_file.azp01,    #No.FUN-680123 VARCHAR(10),  #FUN-A10098
              sdate   LIKE type_file.dat,                  #No.FUN-680123  DATE,
              rdate   LIKE type_file.dat,                  #No.FUN-680123 DATE,
              more    LIKE type_file.chr1                  # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD,
          g_amt       DYNAMIC ARRAY OF RECORD
                  amt1   LIKE type_file.num20_6,           #No.FUN-680123 DECIMAL(20,6) ,
                  amt2   LIKE type_file.num20_6,           #No.FUN-680123 DECIMAL(20,6) ,
                  amt3   LIKE type_file.num20_6,           #No.FUN-680123 DECIMAL(20,6) ,
                  amt4   LIKE type_file.num20_6,           #No.FUN-680123 DECIMAL(20,6) ,
                  amt5   LIKE type_file.num20_6            #No.FUN-680123 DECIMAL(20,6)
              END RECORD,
          g_format       LIKE oea_file.oea01,              #No.FUN-680123 VARCHAR(16),
          g_atot         LIKE type_file.num5               #No.FUN-680123 SMALLINT  # total array
 
 
DEFINE   g_cnt           LIKE type_file.num10             #No.FUN-680123 INTEGER
DEFINE   g_i             LIKE type_file.num5              #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE   i,j             LIKE type_file.num5              #No.FUN-680123 SMALLINT
DEFINE   l_amt     ARRAY[5] OF LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)  #MOD-680076
DEFINE   k         LIKE type_file.num5                    #No.FUN-680123 SMALLINT   #MOD-680076
DEFINE   l_sql     STRING                                #MOD-680076
#No.FUN-830151---Begin                                                          
DEFINE   g_sql           STRING                                                 
DEFINE   g_str           STRING                                                 
DEFINE   l_table1        STRING                                                 
DEFINE   l_table2        STRING                                                 
DEFINE   l_table3        STRING                                                 
#No.FUN-830151---End    
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
  
   #No.FUN-830151---Begin
   LET g_sql = "ooa01.ooa_file.ooa01,",
               "ooa02.ooa_file.ooa02,",
               "ooa03.ooa_file.ooa03,",
               "ooa032.ooa_file.ooa032,",
               "l_amt_1.type_file.num20_6,",
               "l_amt_2.type_file.num20_6,",
               "oob10.oob_file.oob10,",
               "azp01.type_file.chr21 "  #MOD-990201 azp_file.azp01-->type_file.chr21  
 
   LET l_table1 = cl_prt_temptable('axrr1601',g_sql) CLIPPED                    
   IF l_table1 = -1 THEN EXIT PROGRAM END IF   
 
   LET g_sql = "oob01.oob_file.oob01,",
               "oob04.oob_file.oob04,",
               "oob03.oob_file.oob03,",
               "oob06.oob_file.oob06,",
               "oob10.oob_file.oob10,",
               "l_qty.type_file.num5,",
               "dbs.type_file.chr21 "   #MOD-990201 azp_file.azp01-->type_file.chr21 
   LET l_table2 = cl_prt_temptable('axrr1602',g_sql) CLIPPED                    
   IF l_table2 = -1 THEN EXIT PROGRAM END IF 
 
   LET g_sql = "plant.azp_file.azp01,",
               "amt1.type_file.num20_6,",
               "amt2.type_file.num20_6,",
               "amt3.type_file.num20_6,",
               "amt4.type_file.num20_6,",
               "amt5.type_file.num20_6 "
   LET l_table3 = cl_prt_temptable('axrr1603',g_sql) CLIPPED                    
   IF l_table3 = -1 THEN EXIT PROGRAM END IF 
                    
   #No.FUN-830151---End
   INITIALIZE tm.* TO NULL               # Default condition
   LET g_pdate = ARG_VAL(1)
   LET g_towhom= ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway= ARG_VAL(5)
   LET g_copies= ARG_VAL(6)
   LET tm.wc   = ARG_VAL(7)
   #-----TQC-610059---------
#FUN-A10098---begin
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
#   LET tm.sdate = ARG_VAL(20)
#   LET tm.rdate = ARG_VAL(21)
#   #-----END TQC-610059-----
#   #No.FUN-570264 --start--
#   LET g_rep_user = ARG_VAL(22)
#   LET g_rep_clas = ARG_VAL(23)
#   LET g_template = ARG_VAL(24)
#   LET g_rpt_name = ARG_VAL(25)  #No.FUN-7C0078
   LET tm.sdate = ARG_VAL(8)
   LET tm.rdate = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)
#FUN-A10098---end
   #No.FUN-570264 ---end---
   LET tm.sdate= g_today
   LET tm.rdate= g_today
   IF cl_null(g_bgjob) OR g_bgjob='N'  THEN
      CALL axrr160_tm(0,0)             # Input print condition
   ELSE
      CALL axrr160()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr160_tm(p_row,p_col)
   DEFINE p_row,p_col  LIKE type_file.num5,              #No.FUN-680123 SMALLINT,
          i            LIKE type_file.num5,              #No.FUN-680123 SMALLINT,
          l_ac         LIKE type_file.num5,              #No.FUN-680123 SMALLINT,
          l_cmd        LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(400),
          l_oob05      LIKE oob_file.oob05               #No.FUN-680123 VARCHAR(10)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 11
   END IF
 
   OPEN WINDOW axrr160_w AT p_row,p_col
        WITH FORM "axr/42f/axrr160"
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
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa03
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr160_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
   #----- 工廠編號 -B---#
   CALL SET_COUNT(1)    # initial array argument
 
#FUN-A10098---BEGIN
#   CALL tm.plant.clear()   #MOD-680076
#  LET tm.plant[1] = g_plant
#  INPUT ARRAY tm.plant WITHOUT DEFAULTS FROM s_plant.*
#        ATTRIBUTE( DELETE ROW = FALSE,   #是否允許刪除    #MOD-680076
#                   INSERT ROW = FALSE)   #是否允許新增    #MOD-680076
#
#
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
#            IF l_ac > 1 THEN
#               FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
#                   IF tm.plant[i] = tm.plant[l_ac] THEN
#                      CALL cl_err('','aom-492',1) NEXT FIELD plant
#                   END IF
#               END FOR
#            END IF
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
#  IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW axrr160_w RETURN END IF
#  #----- 工廠編號 -E---#
#FUN-A10098---END
      INPUT BY NAME tm.sdate,tm.rdate,tm.more WITHOUT DEFAULTS
      AFTER FIELD sdate
         IF cl_null(tm.sdate) THEN
            NEXT FIELD sdate
         END IF
      AFTER FIELD rdate
         IF cl_null(tm.rdate) THEN
            NEXT FIELD rdate
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr160_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr160'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr160','9031',1)
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
                    #FUN-A10098---begin
                        # " '",tm.plant[1] CLIPPED,"'" ,
                        # " '",tm.plant[2] CLIPPED,"'" ,
                        # " '",tm.plant[3] CLIPPED,"'" ,
                        # " '",tm.plant[4] CLIPPED,"'" ,
                        # " '",tm.plant[5] CLIPPED,"'" ,
                        # " '",tm.plant[6] CLIPPED,"'" ,
                        # " '",tm.plant[7] CLIPPED,"'" ,
                        # " '",tm.plant[8] CLIPPED,"'" ,
                        # " '",tm.plant[9] CLIPPED,"'" ,
                        # " '",tm.plant[10] CLIPPED,"'" ,
                        # " '",tm.plant[11] CLIPPED,"'" ,
                        # " '",tm.plant[12] CLIPPED,"'" ,
                   #FUN-A10098---end 
                        " '",tm.sdate CLIPPED,"'" ,
                         " '",tm.rdate CLIPPED,"'" ,
                         #-----END TQC-610059-----
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr160',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr160_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr160()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr160_w
END FUNCTION
 
FUNCTION axrr160()
   DEFINE l_name    LIKE type_file.chr20,             #No.FUN-680123 VARCHAR(20),        # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          #l_sql    LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(1000),   #MOD-680076
          l_cmd     LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(1000),
          l_za05    LIKE type_file.chr1000,           #No.FUN-680123 VARCHAR(40),
          l_dbs     LIKE type_file.chr21,             #No.FUN-680123 VARCHAR(22),
          l_rate    LIKE oma_file.oma24,
          sr        RECORD
                 ooa03  LIKE ooa_file.ooa03  ,
                 ooa032 LIKE ooa_file.ooa032 ,
                 ooa01  LIKE ooa_file.ooa01  ,
                 ooa02  LIKE ooa_file.ooa02  ,
                 oob03  LIKE oob_file.oob03  ,
                 oob04  LIKE oob_file.oob04  ,
                 oob06  LIKE oob_file.oob06  ,
                 oob10  LIKE oob_file.oob10  ,
                 dbs    LIKE type_file.chr21         #MOD-680076 #No.FUN-680123 VARCHAR(22)  
              END RECORD
   #No.FUN-830151---Begin
   DEFINE l_qty     LIKE type_file.num5 
   DEFINE l_oma11   LIKE oma_file.oma11
   DEFINE r_amt     ARRAY[5] OF LIKE type_file.num20_6
   DEFINE l_no      ARRAY[3] OF LIKE ooa_file.ooa01
   DEFINE rr        RECORD
          oob03  LIKE oob_file.oob03  ,
          oob04  LIKE oob_file.oob04  ,
          oob06  LIKE oob_file.oob06  ,
          oob10  LIKE oob_file.oob10
          END RECORD 
   DEFINE l_flag    LIKE type_file.chr1              #MOD-B10113
 
     CALL cl_del_data(l_table1)                                                 
     CALL cl_del_data(l_table2)                                                 
     CALL cl_del_data(l_table3)                                                 
                                                                                
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,           
                 " VALUES(?,?,?,?,?, ?,?,? )"                   
     PREPARE insert_prep FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                       
     END IF                                                                     
                                                                                
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,           
                 " VALUES(?,?,?,?,?, ?,? )        "                                    
     PREPARE insert_prep1 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                      
     END IF                                                                     
                                        
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,           
                 " VALUES(?,?,?,?,?, ? )        "                             
     PREPARE insert_prep2 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        EXIT PROGRAM                      
     END IF                                            
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     #No.FUN-830151---End
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ooauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ooagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ooagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup')
     #End:FUN-980030
 
 
     #CALL cl_outnam('axrr160') RETURNING l_name     #No.FUN-830151
 #FUN-A10098---begin
#     FOR g_i = 1 TO 12
#         LET g_amt[g_i].amt1 = 0
#         LET g_amt[g_i].amt2 = 0
#         LET g_amt[g_i].amt3 = 0
#         LET g_amt[g_i].amt4 = 0
#         LET g_amt[g_i].amt5 = 0
#     END FOR
#     #LET g_format = '####,###,###,##&'
#     #START REPORT axrr160_rep TO l_name       #No.FUN-830151
#     #LET g_pageno = 0                         #No.FUN-830151
#     LET j = 1
#     FOR j = 1 TO g_atot
#         IF cl_null(tm.plant[j]) THEN CONTINUE FOR END IF
#         LET g_cnt = j
#         SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = tm.plant[j]
#         LET l_dbs = s_dbstring(l_dbs CLIPPED)
         LET g_i =1
         LET g_amt[g_i].amt1 = 0
         LET g_amt[g_i].amt2 = 0
         LET g_amt[g_i].amt3 = 0
         LET g_amt[g_i].amt4 = 0
         LET g_amt[g_i].amt5 = 0
#FUN-A10098---end
         LET l_sql="SELECT ooa03,ooa032,ooa01,ooa02,oob03,oob04,oob06,oob10",
                #   "  FROM ",l_dbs CLIPPED,"ooa_file, ",  #FUN-A10098
                #             l_dbs CLIPPED,"oob_file  ",  #FUN-A10098
                   "  FROM ooa_file, ",  #FUN-A10098
                           "oob_file  ",  #FUN-A10098
                   " WHERE ooa02 <='",tm.rdate,"'",
                   "   AND ooa02 >='",tm.sdate,"'",
                   "   AND ooa37='1' ",               #FUN-B20020
                   "   AND ooaconf = 'Y' AND ooa01 = oob01 ",
                   "   AND ",tm.wc CLIPPED
 
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         PREPARE axrr160_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
            EXIT PROGRAM
               
         END IF
         DECLARE axrr160_curs1 CURSOR FOR axrr160_prepare1
         FOREACH axrr160_curs1 INTO sr.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            #-----MOD-680076---------
            #FUN-A10098---begin
            #   LET sr.dbs = l_dbs
               LET g_cnt = 1
            #FUN-A10098--end
               CASE
                  WHEN sr.oob04 MATCHES '[82]' AND sr.oob03 = '1'  ## TT/CASH
                       LET g_amt[g_cnt].amt1 = g_amt[g_cnt].amt1 + sr.oob10
                  WHEN sr.oob04 = '1' AND sr.oob03 = '1'           ## CHECK
                       LET g_amt[g_cnt].amt2 = g_amt[g_cnt].amt2 + sr.oob10
                  WHEN sr.oob04 = '1' AND sr.oob03 = '2'           ## AR
                       LET g_amt[g_cnt].amt3 = g_amt[g_cnt].amt3 + sr.oob10
                  WHEN sr.oob04 = '2' AND sr.oob03 = '2'           ## DM/AR
                       LET g_amt[g_cnt].amt4 = g_amt[g_cnt].amt4 + sr.oob10
                  WHEN sr.oob04 MATCHES'[56]' AND sr.oob03 = '1'
                       LET g_amt[g_cnt].amt5 = g_amt[g_cnt].amt5 + sr.oob10
               END CASE
            #-----END MOD-680076-----
            #No.FUN-830151---Begin 
            #OUTPUT TO REPORT axrr160_rep(sr.*)
            LET l_no[1] = ' '
            LET l_no[2] = ' '
            LET l_no[3] = ' '
            FOR k = 1 TO 5
                LET l_amt[k] = 0
            END FOR
            CASE
              WHEN sr.oob04 MATCHES '[82]' AND sr.oob03 = '1'  ## TT/CASH
                   LET l_amt[1] = l_amt[1] + sr.oob10
              WHEN sr.oob04 = '1' AND sr.oob03 = '1'           ## CHECK
                   LET l_amt[2] = l_amt[2] + sr.oob10
            END CASE
            EXECUTE insert_prep USING sr.ooa01,sr.ooa02,sr.ooa03,sr.ooa032,
                                       l_amt[1],l_amt[2],sr.oob10,sr.dbs
     
           #-MOD-B10113-mark- 
           ##LET l_sql = "SELECT oob03,oob04,oob06,oob10 FROM ",sr.dbs,"oob_file", #FUN-A10098
           #LET l_sql = "SELECT oob03,oob04,oob06,oob10 FROM oob_file", #FUN-A10098
           #            "   WHERE oob01='",sr.ooa01,"'",
           #            "    AND ((oob03 = '2' AND oob04 IN ('1','2')) OR",
           #            "    (oob03 = '1' AND oob04 IN ('5','6')))"
 	   #CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           #PREPARE axrr160_prepare2 FROM l_sql
           #DECLARE axrr160_curs2 CURSOR FOR axrr160_prepare2
           #FOREACH axrr160_curs2 INTO rr.*
           #  IF STATUS THEN
           #     EXIT FOREACH
           #  END IF
           #-MOD-B10113-end- 
              LET l_qty = 0
           #-MOD-B10113-add-
            LET l_flag = 'N' 
            CASE
              WHEN sr.oob04 MATCHES '[12]' AND sr.oob03 = '2'  
                   LET l_flag = 'Y' 
              WHEN sr.oob04 MATCHES '[56]' AND sr.oob03 = '1'      
                   LET l_flag = 'Y' 
            END CASE
            IF l_flag = 'Y' THEN
           #-MOD-B10113-end-
              SELECT oma11 INTO l_oma11 FROM oma_file WHERE oma01=sr.oob06     #MOD-B10113 mod rr -> sr  
              LET l_qty = sr.ooa02 - tm.sdate
              IF cl_null(l_qty) THEN LET l_qty = 0 END IF
              EXECUTE insert_prep1 USING sr.ooa01,sr.oob04,sr.oob03,sr.oob06,  #MOD-B10113 mod rr -> sr
                                         sr.oob10,l_qty,sr.dbs                 #MOD-B10113 mod rr -> sr
            END IF          #MOD-B10113
           #END FOREACH     #MOD-B10113 mark 
            #No.FUN-830151---End
         END FOREACH
         #No.FUN-830151---Begin 
         FOR k = 1 TO 5
             LET r_amt[k] = 0
         END FOR
 #FUN-A10098---begin
 #        FOR k = 1 TO 12
 #            IF tm.plant[k] = ' ' OR tm.plant[k] IS NULL THEN
 #               CONTINUE FOR
 #            END IF
 #FUN-A10098---end 
           LET k= 1
      #      EXECUTE insert_prep2 USING tm.plant[k],g_amt[k].amt1,g_amt[k].amt2, ##FUN-A10098
            EXECUTE insert_prep2 USING ' ',g_amt[k].amt1,g_amt[k].amt2, ##FUN-A10098
                                       g_amt[k].amt3,g_amt[k].amt4,
                                       g_amt[k].amt5 
 #        END FOR  #FUN-A10098
        #No.FUN-830151---End
#     END FOR   #FUN-A10098
     #No.FUN-830151---Begin  
     #FINISH REPORT axrr160_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",  
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",    #MOD-B30048 mod DISTINCT 
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED            
                                                                                
        LET g_str = ''                                                          
        #是否列印選擇條件                                                       
        IF g_zz05 = 'Y' THEN                                                    
           CALL cl_wcchp(tm.wc,'ooa03')                                        
                RETURNING g_str                                                 
        END IF                                                                  
        LET g_str = g_str,";",g_azi04,";",g_azi05,";",tm.sdate,";",
                    tm.rdate,";",g_plant     
        CALL cl_prt_cs3('axrr160','axrr160',g_sql,g_str)     
     #No.FUN-830151---End
END FUNCTION
 
#No.FUN-830151---Begin
#REPORT axrr160_rep(sr)
#  DEFINE l_last_sw,l_sw LIKE type_file.chr1,           #No.FUN-680123 VARCHAR(1),
#         l_flag    LIKE type_file.chr1,                #No.FUN-680123 VARCHAR(01),
##       l_time          LIKE type_file.chr8        #No.FUN-6A0095
#         l_xxx     LIKE type_file.chr8,                #No.FUN-680123 VARCHAR(8),
#         l_qty     LIKE ooa_file.ooa02,                #No.FUN-680123 DEC(4,0),
#         l_oma11   LIKE oma_file.oma11,
#         l_rate    LIKE oma_file.oma24,
#         r_amt     ARRAY[5] OF LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6),
#         #l_amt    ARRAY[5] OF LIKE type_file.num20_6, #No.FUN-680123 DEC(20,6), #MOD-680076
#         l_no      ARRAY[3] OF LIKE ooa_file.ooa01,    #No.FUN-680123 VARCHAR(10),
#         #k        SMALLINT,                           #MOD-680076
#         g_head1   STRING,
#         rr        RECORD
#                oob03  LIKE oob_file.oob03  ,
#                oob04  LIKE oob_file.oob04  ,
#                oob06  LIKE oob_file.oob06  ,
#                oob10  LIKE oob_file.oob10
#              END RECORD ,
#         sr        RECORD
#                ooa03  LIKE ooa_file.ooa03  ,
#                ooa032 LIKE ooa_file.ooa032 ,
#                ooa01  LIKE ooa_file.ooa01  ,
#                ooa02  LIKE ooa_file.ooa02  ,
#                oob03  LIKE oob_file.oob03  ,
#                oob04  LIKE oob_file.oob04  ,
#                oob06  LIKE oob_file.oob06  ,
#                oob10  LIKE oob_file.oob10  ,
#                dbs    LIKE type_file.chr21       #MOD-680076  #No.FUN-680123 VARCHAR(22)
#              END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#  ORDER BY sr.ooa03,sr.ooa02,sr.ooa01,sr.oob06
#  FORMAT
#    PAGE HEADER
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#       LET g_pageno = g_pageno + 1
#       LET pageno_total = PAGENO USING '<<<',"/pageno"
#       PRINT g_head CLIPPED, pageno_total
#       LET g_head1 = g_x[8] CLIPPED,tm.sdate,'-',tm.rdate
#       PRINT g_head1
#       PRINT g_dash[1,g_len]
#       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#             g_x[39],g_x[40],g_x[41],g_x[42]
#       PRINT g_dash1
#       LET l_last_sw = 'n'
#   BEFORE GROUP OF sr.ooa03
#       PRINT COLUMN g_c[31],sr.ooa03 ,
#             COLUMN g_c[32],sr.ooa032;
#   BEFORE GROUP OF sr.ooa02
#       #PRINT COLUMN g_c[33],sr.ooa02 USING 'YY/MM/DD';#FUN-570250 mark
#       PRINT COLUMN g_c[33],sr.ooa02; #FUN-570250 add
#   BEFORE GROUP OF sr.ooa01
#       LET l_no[1] = ' '
#       LET l_no[2] = ' '
#       LET l_no[3] = ' '
#       FOR k = 1 TO 5
#           LET l_amt[k] = 0
#       END FOR
#       PRINT COLUMN g_c[34],sr.ooa01 ;
#   #-----MOD-680076---------
#   ON EVERY ROW
#      CASE
#         WHEN sr.oob04 MATCHES '[82]' AND sr.oob03 = '1'  ## TT/CASH
#              LET l_amt[1] = l_amt[1] + sr.oob10
#         WHEN sr.oob04 = '1' AND sr.oob03 = '1'           ## CHECK
#              LET l_amt[2] = l_amt[2] + sr.oob10
#      END CASE
#   #ON EVERY ROW
#   #   CASE
#   #      WHEN sr.oob04 MATCHES '[82]' AND sr.oob03 = '1'  ## TT/CASH
#   #           LET g_amt[g_cnt].amt1 = g_amt[g_cnt].amt1 + sr.oob10
#   #           LET l_amt[1] = l_amt[1] + sr.oob10
#   #      WHEN sr.oob04 = '1' AND sr.oob03 = '1'           ## CHECK
#   #           LET g_amt[g_cnt].amt2 = g_amt[g_cnt].amt2 + sr.oob10
#   #           LET l_amt[2] = l_amt[2] + sr.oob10
#   #      WHEN sr.oob04 = '1' AND sr.oob03 = '2'           ## AR
#   #           LET g_amt[g_cnt].amt3 = g_amt[g_cnt].amt3 + sr.oob10
#   #      WHEN sr.oob04 = '2' AND sr.oob03 = '2'           ## DM/AR
#   #           LET g_amt[g_cnt].amt4 = g_amt[g_cnt].amt4 + sr.oob10
#   #      WHEN sr.oob04 MATCHES'[56]' AND sr.oob03 = '1'
#   #           LET g_amt[g_cnt].amt5 = g_amt[g_cnt].amt5 + sr.oob10
#   #   END CASE
#   #-----END MOD-680076-----
#   AFTER GROUP OF sr.ooa01
#      LET l_sw = 'Y'
#      PRINT COLUMN  g_c[35],cl_numfor(l_amt[1],35,g_azi04),
#            COLUMN  g_c[36],cl_numfor(l_amt[2],36,g_azi04),
#            COLUMN  g_c[37],cl_numfor((l_amt[1]+l_amt[2]),37,g_azi04);
#      #-----MOD-680076---------
#      LET l_sql = "SELECT oob03,oob04,oob06,oob10 FROM ",sr.dbs,"oob_file",
#                  "   WHERE oob01='",sr.ooa01,"'",
#                  "    AND ((oob03 = '2' AND oob04 IN ('1','2')) OR",
#                  "    (oob03 = '1' AND oob04 IN ('5','6')))"
#      PREPARE axrr160_prepare2 FROM l_sql
#      DECLARE axrr160_curs2 CURSOR FOR axrr160_prepare2
#      FOREACH axrr160_curs2 INTO rr.*
#      #DECLARE a_curs CURSOR FOR
#      # SELECT oob03,oob04,oob06,oob10 FROM oob_file
#      #  WHERE oob01 = sr.ooa01
#      #     AND ((oob03 = '2' AND oob04 IN ('1','2')) OR
#      #          (oob03 = '1' AND oob04 IN ('5','6')))
#      #  ORDER BY oob03 DESC,oob04
#      #FOREACH a_curs INTO rr.*
#      #-----END MOD-680076-----
#        IF STATUS THEN
#           EXIT FOREACH
#        END IF
#        IF l_sw = 'Y' THEN
#           LET l_sw = 'N'
#        END IF
#        CASE
#           WHEN rr.oob04 = '1' AND rr.oob03 = '2'           ## AR
#                LET l_qty = 0
#                SELECT oma11 INTO l_oma11 FROM oma_file WHERE oma01=rr.oob06
#                LET l_qty = sr.ooa02 - l_oma11
#                IF cl_null(l_qty) THEN LET l_qty = 0 END IF
#                PRINT COLUMN g_c[38],rr.oob06 ,
#                      COLUMN g_c[39],cl_numfor(rr.oob10,39,g_azi04),
#                      COLUMN g_c[42],l_qty USING '---&'
#
#           WHEN rr.oob04 = '2' AND rr.oob03 = '2'           ## DM/AR
#                PRINT COLUMN g_c[38],rr.oob06 ,
#                      COLUMN g_c[40],cl_numfor(rr.oob10,40,g_azi04)
#           WHEN rr.oob04 MATCHES '[56]' AND rr.oob03 = '1'  ## DM/AR
#                PRINT COLUMN g_c[38],rr.oob06 ,
#                      COLUMN g_c[41],cl_numfor(rr.oob10,41,g_azi04)
#        END CASE
#      END FOREACH
#      IF l_sw = 'Y' THEN
#         PRINT
#      END IF
#   AFTER GROUP OF sr.ooa03
#      PRINT
#  ON LAST ROW
#      FOR k = 1 TO 5
#          LET r_amt[k] = 0
#      END FOR
#      PRINT COLUMN g_c[35],g_dash2[1,g_w[35]],
#            COLUMN g_c[36],g_dash2[1,g_w[36]],
#            COLUMN g_c[37],g_dash2[1,g_w[37]],
#            COLUMN g_c[39],g_dash2[1,g_w[39]],
#            COLUMN g_c[40],g_dash2[1,g_w[40]],
#            COLUMN g_c[41],g_dash2[1,g_w[41]]
#      PRINT COLUMN g_c[32],g_x[10] CLIPPED ;
#      FOR k = 1 TO 12
#          IF tm.plant[k] = ' ' OR tm.plant[k] IS NULL THEN
#             CONTINUE FOR
#          END IF
#          LET r_amt[1] = r_amt[1] + g_amt[k].amt1
#          LET r_amt[2] = r_amt[2] + g_amt[k].amt2
#          LET r_amt[3] = r_amt[3] + g_amt[k].amt3
#          LET r_amt[4] = r_amt[4] + g_amt[k].amt4
#          LET r_amt[5] = r_amt[5] + g_amt[k].amt5
#          PRINT COLUMN  g_c[34],tm.plant[k] ,
#                COLUMN  g_c[35],cl_numfor(g_amt[k].amt1,35,g_azi05),
#                COLUMN  g_c[36],cl_numfor(g_amt[k].amt2,36,g_azi05),
#                COLUMN  g_c[37],cl_numfor((g_amt[k].amt1+g_amt[k].amt2),37,g_azi05),
#                COLUMN  g_c[39],cl_numfor(g_amt[k].amt3,39,g_azi05),
#                COLUMN  g_c[40],cl_numfor(g_amt[k].amt4,40,g_azi05),
#                COLUMN  g_c[41],cl_numfor(g_amt[k].amt5,41,g_azi05)
#      END FOR
#      PRINT COLUMN  g_c[32],g_x[11] CLIPPED ,
#            COLUMN  g_c[35],cl_numfor(r_amt[1],35,g_azi05),
#            COLUMN  g_c[36],cl_numfor(r_amt[2],36,g_azi05),
#            COLUMN  g_c[37],cl_numfor((r_amt[1]+r_amt[2]),37,g_azi05),
#            COLUMN  g_c[39],cl_numfor(r_amt[3],39,g_azi05),
#            COLUMN  g_c[40],cl_numfor(r_amt[4],40,g_azi05),
#            COLUMN  g_c[41],cl_numfor(r_amt[5],41,g_azi05)
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#         CALL cl_wcchp(tm.wc,'ooa03') RETURNING tm.wc
#         PRINT g_dash[1,g_len]
#         #TQC-630166
#         #IF tm.wc[001,120] > ' ' THEN            # for 132
#         #   PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#         #IF tm.wc[121,240] > ' ' THEN
#         #   PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#         #IF tm.wc[241,300] > ' ' THEN
#         #   PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
#         CALL cl_prt_pos_wc(tm.wc)
#         #END TQC-630166
 
#     END IF
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
 
#END REPORT
#No.FUN-830151---End
