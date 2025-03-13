# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmr840.4gl
# Descriptions...: 三角貿易訂單單價為零檢查表
# Input parameter:
# Return code....:
# Date & Author..: 99/02/08 By Linda
# Modify.........: NO.FUN-4C0096 04/12/21 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-660167 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690126 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-750093 07/06/15 By jan報表改為使用crystal report
# Modify.........: No.FUN-760086 07/07/20 By jan 打印條件修改
# Modify.........: No.TQC-780056 07/08/17 By Carrier oracle語法轉至ora文檔
# Modify.........: NO.TQC-7C0082 07/12/07 by fangyan 增加訂單單號的開窗查詢
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.TQC-950032 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-A10056 10/01/13 By lutingting 跨DB寫法修改 
# Modify.........: NO.TQC-A50044 10/05/18 By Carrier MAIN中结构调整
# Modify.........: No.FUN-A70084 10/07/19 By lutingting GP5.2報表修改 INPUT營運中心改為QBE
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(500)    # Where condition
             #FUN-A70084--mark--str--
             #plant_1 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
             #plant_2 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
             #plant_3 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
             #plant_4 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
             #plant_5 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
             #plant_6 LIKE faj_file.faj02,        # No.FUN-680137 VARCHAR(10)
             #FUN-A70084--mark--end
              more    LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)    # Input more condition(Y/N)
              END RECORD,
         #m_dbs    ARRAY[6] OF LIKE faj_file.faj02        # No.FUN-680137 VARCHAR(10)   #FUN-A70084
          m_plant  LIKE azw_file.azw01                    #FUN-A70084 
 
DEFINE   g_head1         STRING
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_str           STRING                  #No.FUN-750093
DEFINE   l_table         STRING                  #No.FUN-750093
DEFINE   g_sql           STRING                  #No.FUN-750093
DEFINE   g_wc            LIKE type_file.chr1000  #No.FUN-A70084
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   #No.TQC-A50044  --Begin
   LET g_pdate    = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom   = ARG_VAL(2)
   LET g_rlang    = ARG_VAL(3)
   LET g_bgjob    = ARG_VAL(4)
   LET g_prtway   = ARG_VAL(5)
   LET g_copies   = ARG_VAL(6)
   LET tm.wc      = ARG_VAL(7)
#FUN-A70084--mod--str--
#  LET tm.plant_1 = ARG_VAL(8)
#  LET tm.plant_2 = ARG_VAL(9)
#  LET tm.plant_3 = ARG_VAL(10)
#  LET tm.plant_4 = ARG_VAL(11)
#  LET tm.plant_5 = ARG_VAL(12)
#  LET tm.plant_6 = ARG_VAL(13)
#  #No.FUN-570264 --start--
#  LET g_rep_user = ARG_VAL(14)
#  LET g_rep_clas = ARG_VAL(15)
#  LET g_template = ARG_VAL(16)
#  LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
#  #No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
   LET g_wc = ARG_VAL(12)
#FUN-A70084--mod--end

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126
   #No.TQC-A50044  --End  

   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr840_tm(0,0)        # Input print condition
      ELSE CALL axmr840()            # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr840_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr840_w AT p_row,p_col WITH FORM "axm/42f/axmr840"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
  #LET tm.plant_1=g_plant      #FUN-A70084
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
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
     CLOSE WINDOW axmr840_w 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF
#FUN-A70084--add--end
   CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea03,oea14,oea904
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
  #..:NO.TQC-7C0082.....BEGIN.....
      ON ACTION controlp
         CASE
            WHEN INFIELD(oea01)
            CALL cl_init_qry_var()
            LET g_qryparam.state = 'c'
            LET g_qryparam.form ="q_oea01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO oea01
            NEXT FIELD oea01
         END CASE
  #..:NO.TQC-7C0082.....END......
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr840_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #FUN-A70084--mod--str--
  #INPUT BY NAME tm.plant_1,tm.plant_2,tm.plant_3,
  #         tm.plant_4,tm.plant_5,tm.plant_6,
  #         tm.more  WITHOUT DEFAULTS
   INPUT BY NAME  tm.more  WITHOUT DEFAULTS
  #FUN-A70084--mod--end
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
#FUN-A70084--mark--str--
#     AFTER  FIELD plant_1
#        IF cl_null(tm.plant_1) THEN
#           NEXT FIELD plant_1
#        END IF
#       SELECT azp01 FROM azp_file WHERE azp01 = tm.plant_1
#       IF STATUS THEN 
##          CALL cl_err('sel azp',STATUS,1)
#          CALL cl_err3("sel","azp_file",tm.plant_1,"",STATUS,"","sel azp",1)  #No.FUN-660167  
#       NEXT FIELD plant_1 
#       END IF
#       #No.FUN-940102--begin    
#       IF NOT cl_null(tm.plant_1) THEN 
#          IF NOT s_chk_demo(g_user,tm.plant_1) THEN              
#             NEXT FIELD plant_1          
#          END IF  
#       END IF              
#       #No.FUN-940102--end 
#
#     AFTER  FIELD plant_2
#        IF NOT cl_null(tm.plant_2) THEN
#           SELECT azp01 FROM azp_file
#              WHERE azp01 = tm.plant_2
#           IF STATUS THEN
##              CALL cl_err('sel azp',STATUS,1)   #No.FUN-660167
#              CALL cl_err3("sel","azp_file",tm.plant_2,"",STATUS,"","sel azp",1)   #No.FUN-660167
#              NEXT FIELD plant_2
#           END IF
#           #No.FUN-940102--begin   
#           IF NOT s_chk_demo(g_user,tm.plant_2) THEN  
#              NEXT FIELD plant_2 
#           END IF              
#           #No.FUN-940102--end 
#        END IF
#
#     AFTER  FIELD plant_3
#        IF NOT cl_null(tm.plant_3) THEN
#           SELECT azp01 FROM azp_file
#              WHERE azp01 = tm.plant_3
#           IF STATUS THEN
##              CALL cl_err('sel azp',STATUS,1)   #No.FUN-660167
#              CALL cl_err3("sel","azp_file",tm.plant_3,"",STATUS,"","sel azp",1)   #No.FUN-660167
#              NEXT FIELD plant_3
#           END IF
#           #No.FUN-940102--begin   
#           IF NOT s_chk_demo(g_user,tm.plant_3) THEN  
#              NEXT FIELD plant_3 
#           END IF              
#           #No.FUN-940102--end 
#        END IF
#
#     AFTER  FIELD plant_4
#        IF NOT cl_null(tm.plant_4) THEN
#           SELECT azp01 FROM azp_file
#              WHERE azp01 = tm.plant_4
#           IF STATUS THEN
##              CALL cl_err('sel azp',STATUS,1)   #No.FUN-660167
#              CALL cl_err3("sel","azp_file",tm.plant_4,"",STATUS,"","sel azp",1)   #No.FUN-660167
#              NEXT FIELD plant_4
#           END IF
#           #No.FUN-940102--begin   
#           IF NOT s_chk_demo(g_user,tm.plant_4) THEN  
#              NEXT FIELD plant_4 
#           END IF              
#           #No.FUN-940102--end 
#        END IF
#
#     AFTER  FIELD plant_5
#        IF NOT cl_null(tm.plant_5) THEN
#           SELECT azp01 FROM azp_file
#              WHERE azp01 = tm.plant_5
#           IF STATUS THEN
##              CALL cl_err('sel azp',STATUS,1)   #No.FUN-660167
#              CALL cl_err3("sel","azp_file",tm.plant_5,"",STATUS,"","sel azp",1)   #No.FUN-660167
#              NEXT FIELD plant_5
#           END IF
#           #No.FUN-940102--begin   
#           IF NOT s_chk_demo(g_user,tm.plant_5) THEN  
#              NEXT FIELD plant_5 
#           END IF              
#           #No.FUN-940102--end 
#        END IF
#
#     AFTER  FIELD plant_6
#        IF NOT cl_null(tm.plant_6) THEN
#           SELECT azp01 FROM azp_file
#              WHERE azp01 = tm.plant_6
#           IF STATUS THEN
##              CALL cl_err('sel azp',STATUS,1)   #No.FUN-660167
#              CALL cl_err3("sel","azp_file",tm.plant_6,"",STATUS,"","sel azp",1)   #No.FUN-660167
#              NEXT FIELD plant_6
#           END IF
#           #No.FUN-940102--begin   
#           IF NOT s_chk_demo(g_user,tm.plant_6) THEN  
#              NEXT FIELD plant_6 
#           END IF              
#           #No.FUN-940102--end 
#        END IF
#FUN-A70084--mark--end
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr840_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axmr840'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axmr840','9031',1)   
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
                        #FUN-A70084--mark--str--
                        #" '",tm.plant_1 CLIPPED,"'",
                        #" '",tm.plant_2 CLIPPED,"'",
                        #" '",tm.plant_3 CLIPPED,"'",
                        #" '",tm.plant_4 CLIPPED,"'",
                        #" '",tm.plant_5 CLIPPED,"'",
                        #" '",tm.plant_6 CLIPPED,"'",
                        #" '",tm.more CLIPPED,"'",
                        #FUN-A70084--mark--end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'",           #No.FUN-7C0078
                         " '",g_wc CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axmr840',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axmr840_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL axmr840()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr840_w
END FUNCTION
 
FUNCTION axmr840()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_chr        LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_dbs     LIKE azp_file.azp03,
          sr         RECORD
                 plant    LIKE azp_file.azp01,   #工廠編號
                 oea01    LIKE oea_file.oea01,   #訂單單號
                 oea02    LIKE oea_file.oea02,   #訂單日期
                 oeb03    LIKE oeb_file.oeb03,   #訂單項次
                 oeb04    LIKE oeb_file.oeb04,   #產品編號
                 oeb06    LIKE oeb_file.oeb06,
                 ima021   LIKE ima_file.ima021,  #No.FUN-750093
                 oeb12    LIKE oeb_file.oeb12,   #訂單數量
                 oeb13    LIKE oeb_file.oeb13,   #單價
                 oeb15    LIKE oeb_file.oeb15    #預定交貨日
          END RECORD
#No.FUN-750093--Begin
     LET g_sql = "plant.azp_file.azp01,",
                 "oea01.oea_file.oea01,",
                 "oea02.oea_file.oea02,",
                 "oeb03.oeb_file.oeb03,",
                 "oeb04.oeb_file.oeb04,",
                 "oeb06.oeb_file.oeb06,",
                 "ima021.ima_file.ima021,",
                 "oeb12.oeb_file.oeb12,",
                 "oeb15.oeb_file.oeb15"
     LET l_table = cl_prt_temptable('axmr840',g_sql)CLIPPED
     IF l_table = -1 THEN 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?)"
       PREPARE insert_prep FROM g_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
#No.FUN-750093--End
 
     CALL cl_wait()
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oeauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
     #End:FUN-980030
 
#    CALL cl_outnam('axmr840') RETURNING l_name     #No.FUN-750093
#    START REPORT axmr840_rep TO l_name             #No.FUN-750093
#FUN-A70084--mark--str--
#    FOR i=1 TO 6
#        LET m_dbs[i]=NULL    
#    END FOR
#    LET m_dbs[1] = tm.plant_1
#    LET m_dbs[2] = tm.plant_2
#    LET m_dbs[3] = tm.plant_3
#    LET m_dbs[4] = tm.plant_4
#    LET m_dbs[5] = tm.plant_5
#    LET m_dbs[6] = tm.plant_6
#FUN-A70084--mark--end

#FUN-A70084--mod--str--
#    FOR i = 1 TO 6
#        IF cl_null(m_dbs[i]) THEN CONTINUE FOR END IF
#        SELECT azp03  INTO l_dbs
#          FROM azp_file
#         WHERE azp01=m_dbs[i]   
#       #LET l_dbs=l_dbs CLIPPED,"."           #TQC-950032 MARK                                                                     
#        LET l_dbs=s_dbstring(l_dbs CLIPPED)  #TQC-950032 ADD        
     LET g_sql = "SELECT azw01 FROM azw_file,azp_file ",
                 " WHERE azp01 = azw01 AND azwacti = 'Y'",
                 "   AND azw01 IN (SELECT zxy03 FROM zxy_file WHERE zxy01 = '",g_user,"')",
                 "   AND ",g_wc CLIPPED
     PREPARE sel_azw01_pre FROM g_sql
     DECLARE sel_azw01_cur CURSOR FOR sel_azw01_pre
     FOREACH sel_azw01_cur INTO m_plant
     IF cl_null(m_plant) THEN CONTINUE FOREACH END IF
#FUN-A70084--mod--end
#No.FUN-750093--Begin
#         LET l_sql = " SELECT '',oea01,oea02,oeb03,oeb04,oeb06,oeb12,oeb13,oeb15 " ,
#                 "   FROM ",l_dbs CLIPPED,"oea_file,",
#                            l_dbs CLIPPED,"oeb_file ",
#                 "  WHERE oea901='Y' ",    #三角貿易
#                 "    AND oea01=oeb01 ",
#                 "    AND oeb13=0 ",      #單價為零
#                 "    AND oeaconf = 'Y' ", #01/08/16 mandy
#                 "    AND ", tm.wc  CLIPPED
LET l_sql = " SELECT '',oea01,oea02,oeb03,oeb04,oeb06,ima021,oeb12,oeb13,oeb15 " , 
           #FUN-A10056--mod--str--
           #"   FROM ",l_dbs CLIPPED,"oea_file,",
           #           l_dbs CLIPPED,"oeb_file ",
           #"   LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ON oeb04=ima01",
            "   FROM ",cl_get_target_table(m_plant,'oea_file'),",",   #FUN-A70084 m_dbs-->m_plant
                       cl_get_target_table(m_plant,'oeb_file'),     #FUN-A70084 m_dbs-->m_plant
            "   LEFT OUTER JOIN ",cl_get_target_table(m_plant,'ima_file')," ON oeb04=ima01 ", #FUN-A70084 m_dbs-->m_plant
           #FUN-A10056--mod--end
            "  WHERE oea901='Y' ", 
            "    AND oea01=oeb01 ",
            "    AND oeb13=0 ",
            "    AND oeaconf = 'Y' ",
            "    AND ", tm.wc  CLIPPED
#No.FUN-750093--End	
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         #CALL cl_parse_qry_sql(l_sql,m_dbs[i]) RETURNING l_sql   #FUN-A10056  #FUN-A70084
          CALL cl_parse_qry_sql(l_sql,m_plant) RETURNING l_sql   #FUN-A70084
          PREPARE axmr840_prepare1 FROM l_sql
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('prepare:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
             EXIT PROGRAM  
                
          END IF
          DECLARE axmr840_curs1 CURSOR FOR axmr840_prepare1
          FOREACH axmr840_curs1 INTO sr.*
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('foreach:',SQLCA.sqlcode,1)
                EXIT FOREACH
             END IF
            #LET sr.plant = m_dbs[i]    #FUN-A70084
             LET sr.plant = m_plant    #FUN-A70084
 
#            OUTPUT TO REPORT axmr840_rep(sr.*)       #No.FUN-750093
             EXECUTE insert_prep USING                #No.FUN-750093
                    #m_dbs[i],sr.oea01,sr.oea02,sr.oeb03,sr.oeb04,sr.oeb06,sr.ima021,    #No.FUN-750093   #FUN-A70084
                     m_plant,sr.oea01,sr.oea02,sr.oeb03,sr.oeb04,sr.oeb06,sr.ima021,    #No.FUN-A70084
                     sr.oeb12,sr.oeb15                                                   #No.FUN-750093
          END FOREACH
    #END FOR     #FUN-A70084
     END FOREACH     #FUN-A70084
#No.FUN-750093--Begin
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
#No.FUN-760086--Begin                                                           
     IF g_zz05 = 'Y' THEN                                                         
         CALL cl_wcchp(tm.wc,'oea01,oea02,oea03,oea14,oea904')                        
               RETURNING g_str
     END IF
     LET g_str = g_str
#No.FUN_760086--End
     CALL cl_prt_cs3('axmr840','axmr840',l_sql,g_str)
 
#    FINISH REPORT axmr840_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-750093--End
END FUNCTION
 
#No.FUN-750093--Begin
{
REPORT axmr840_rep(sr)
   DEFINE  p_mode    LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)
   DEFINE l_last_sw  LIKE type_file.chr1        # No.FUN-680137  VARCHAR(1)
   DEFINE l_ima021   LIKE ima_file.ima021
   DEFINE sr         RECORD
                 plant    LIKE azp_file.azp01,   #工廠編號
                 oea01    LIKE oea_file.oea01,   #訂單單號
                 oea02    LIKE oea_file.oea02,   #訂單日期
                 oeb03    LIKE oeb_file.oeb03,   #訂單項次
                 oeb04    LIKE oeb_file.oeb04,   #產品編號
                 oeb06    LIKE oeb_file.oeb06,
                 oeb12    LIKE oeb_file.oeb12,   #訂單數量
                 oeb13    LIKE oeb_file.oeb13,   #單價
                 oeb15    LIKE oeb_file.oeb15    #預定交貨日
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.plant,sr.oea01,sr.oeb03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT g_dash[1,g_len]
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38],
            g_x[39]
 
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.plant
      PRINT sr.plant;
 
   ON EVERY ROW
      SELECT ima021 INTO l_ima021 FROM ima_file
       WHERE ima01 = sr.oeb04
      PRINT COLUMN g_c[32],sr.oea01,
            COLUMN g_c[33],sr.oea02,
            COLUMN g_c[34],sr.oeb03 USING "###&",
            COLUMN g_c[35],sr.oeb04,
            COLUMN g_c[36],sr.oeb06,
            COLUMN g_c[37],l_ima021,
            COLUMN g_c[38],sr.oeb12 USING "##############&",
            COLUMN g_c[39],sr.oeb15
 
   ON LAST ROW
      LET l_last_sw='y'
      PRINT g_dash[1,g_len]
      PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[7] CLIPPED
    PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED, COLUMN g_c[39], g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT}
#No.FUN-750093--End
