# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: gglg406.4gl
# Descriptions...: 應交增值稅明細帳
# Date & Author..: 06/10/11 By Judy
# Modify.........: No.FUN-6C0012 06/12/30 By Judy 報表加入打印額外名稱
# Modify.........: No.TQC-730072 07/03/19 By Judy 期初為零時打印0
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740055 07/04/12 By lora 會計科目加帳套
# Modify.........: No.TQC-740341 07/04/28 By johnray 帳套顯示設默認值
# Modify.........: No.FUN-7C0064 07/12/20 By Carrier 報表格式轉CR
# Modify.........: No.MOD-860078 08/06/10 BY yiting ON IDLE處理
# Modify.........: No.MOD-8B0101 08/11/11 By Sarah g_ary裡的aag變數改為LIKE aag_file.aag01
# Modify.........: No.MOD-860252 09/02/18 By chenl   增加打印時是否打印貨幣性科目或全部科目的選擇。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10053 11/01/24 By yinhy 科目查询自动过滤

# Modify.........: No.FUN-B20054 10/02/22 By yangtingting 先錄入帳套,科目根據帳套過濾;結構改為DIALOG
# Modify.........: No.FUN-B40087 11/06/09 By yangtt  憑證報表轉GRW
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C10036 12/01/11 By qirl 程式規範修改
# Modify.........: No.FUN-CC0084 12/12/17 By chenying 4fd當出
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm    RECORD                   # Print condition RECORD
              b       LIKE aaa_file.aaa01,    # apf_file.apf00 VARCHAR(2)
              yy      LIKE type_file.num5,    # apf_file.apf00 SMALLINT
              bm      LIKE type_file.num5,    # apf_file.apf00 SMALLINT
              em      LIKE type_file.num5,    # apf_file.apf00 SMALLINT
              h       LIKE type_file.chr1,    #MOD-860252
              e       LIKE type_file.chr1,    #FUN-6C0012
              more    LIKE type_file.chr1     # Input more condition(Y/N) VARCHAR(1)
             END RECORD,
       g_ary ARRAY [08] OF RECORD    #列印科目
              aag     LIKE aag_file.aag01,    #MOD-8B0101 mod #LIKE type_file.chr8,  #CHAR(08)
              aag02   LIKE aag_file.aag02,    #No.FUN-7C0064
              cnt     LIKE type_file.num5     #SMALLINT
             END RECORD 
DEFINE g_bal          ARRAY [08] OF LIKE type_file.num20_6  #DEC(20,6)
DEFINE g_idx          LIKE type_file.num10    #INTEGER
DEFINE g_tot_bal      LIKE type_file.num20_6  # User defined variable DECIMAL(20,6)
DEFINE g_aaa03        LIKE aaa_file.aaa03
DEFINE g_cnt          LIKE type_file.num10    #INTEGER
DEFINE g_i            LIKE type_file.num5     #count/index for any purpose SMALLINT
DEFINE l_table        STRING                  #No.FUN-7C0064
DEFINE g_str          STRING                  #No.FUN-7C0064
DEFINE g_sql          STRING                  #No.FUN-7C0064
 
###GENGRE###START
TYPE sr1_t RECORD
    sw LIKE type_file.chr1,
    ps LIKE type_file.chr1,
    aag01 LIKE aag_file.aag01,
    aba01 LIKE aba_file.aba01,
    abb03 LIKE abb_file.abb03,
    abb04 LIKE abb_file.abb04,
    abb07 LIKE abb_file.abb07,
    bal LIKE abb_file.abb07,
    year LIKE type_file.chr4,
    month LIKE type_file.chr2,
    day LIKE type_file.chr2
#FUN-B40087-----add-----str---------------
    ,abb07_1  LIKE abb_file.abb07,
    abb07_2  LIKE abb_file.abb07,
    abb07_3  LIKE abb_file.abb07,
    abb07_4  LIKE abb_file.abb07,
    abb07_5  LIKE abb_file.abb07,
    abb07_6  LIKE abb_file.abb07,
    abb07_7  LIKE abb_file.abb07,
    abb07_8  LIKE abb_file.abb07,
    bal_e1   LIKE abb_file.abb07,
    bal_e2   LIKE abb_file.abb07
#FUN-B40087-----add----end--------------
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_pdate  = ARG_VAL(2)            # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.b     = ARG_VAL(8)
   LET tm.yy    = ARG_VAL(9)
   LET tm.bm    = ARG_VAL(10)
   LET tm.em    = ARG_VAL(11)
   LET tm.more  = ARG_VAL(12)
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
 
   #No.FUN-7C0064  --Begin
   LET g_sql = " sw.type_file.chr1,",
               " ps.type_file.chr1,",
               " aag01.aag_file.aag01,",
               " aba01.aba_file.aba01,",
               " abb03.abb_file.abb03,",
               " abb04.abb_file.abb04,",
               " abb07.abb_file.abb07,",
               " bal.abb_file.abb07,",
               " year.type_file.chr4,",
               " month.type_file.chr2,",
              # " day.type_file.chr2"      #FUN-B40087 mark
               #FUN-B40087-----add----str-----------
               " day.type_file.chr2,",
               "abb07_1.abb_file.abb07,",
               "abb07_2.abb_file.abb07,",
               "abb07_3.abb_file.abb07,",
               "abb07_4.abb_file.abb07,",
               "abb07_5.abb_file.abb07,",
               "abb07_6.abb_file.abb07,",
               "abb07_7.abb_file.abb07,",
               "abb07_8.abb_file.abb07,",
               "bal_e1.abb_file.abb07,",
               "bal_e2.abb_file.abb07"
               #FUN-B40087-----add----end-----------
 
   LET l_table = cl_prt_temptable('gglg406',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087   #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?)"    #FUN-B40087---add 10?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087   #FUN-C10036  mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087   #FUN-C10036  mark
      EXIT PROGRAM
   END IF
   #No.FUN-7C0064  --End

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'   # If background job sw is off
      THEN CALL g406_tm(0,0)        # Input print condition
      ELSE CALL g406()              # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
   CALL cl_gre_drop_temptable(l_table)                     #FUN-C10036 ADD 
END MAIN
 
FUNCTION g406_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5, #SMALLINT
          l_aag_1      LIKE aag_file.aag01,
          l_aag_2      LIKE aag_file.aag01,
          l_aag_3      LIKE aag_file.aag01,
          l_aag_4      LIKE aag_file.aag01,
          l_aag_5      LIKE aag_file.aag01,
          l_aag_6      LIKE aag_file.aag01,
          l_aag_7      LIKE aag_file.aag01,
          l_aag_8      LIKE aag_file.aag01,
          l_cmd        LIKE type_file.chr1000  # VARCHAR(400)
  DEFINE li_chk_bookno LIKE type_file.num5    #FUN-B20054
 
   OPEN WINDOW g406_w AT p_row,p_col WITH FORM "ggl/42f/gglg406"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.e    = 'N'  #FUN-6C0012
   LET tm.h    = 'Y'  #No.MOD-860252
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.b = g_aza.aza81   #No.FUN-740055
 
WHILE TRUE
   DISPLAY BY NAME tm.b     #No.TQC-740341
   CALL g_ary.clear()
 
#FUN-B20054--add--str-- 
   DIALOG ATTRIBUTE(unbuffered)
   #FUN-B20054--add--str--
     INPUT BY NAME tm.b ATTRIBUTE(WITHOUT DEFAULTS)
           AFTER FIELD b 
              IF NOT cl_null(tm.b) THEN
                 CALL s_check_bookno(tm.b,g_user,g_plant)
                 RETURNING li_chk_bookno
                 IF (NOT li_chk_bookno) THEN
                     NEXT FIELD b
                 END IF
                 SELECT aaa02 FROM aaa_file WHERE aaa01 = tm.b
                 IF STATUS THEN
                    CALL cl_err3("sel","aaa_file",tm.b,"","agl-043","","",0)
                    NEXT FIELD b
                 END IF
             END IF
     END INPUT
      #TQC-730072.....begin 還原位置
      INPUT l_aag_1, l_aag_2, l_aag_3, l_aag_4 ,                                                                                       
         l_aag_5, l_aag_6, l_aag_7, l_aag_8                                                                                         
         FROM aag_1, aag_2, aag_3, aag_4,                                                                                           
              aag_5, aag_6, aag_7, aag_8
        
#FUN-B20054--add--end--

#FUN-B20054--mark--str--
#      ON ACTION CONTROLP                                                                                                           
#         CASE                                                                                                                       
#            WHEN INFIELD(aag_1)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                               
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_1
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                     
#                 CALL cl_create_qry() RETURNING l_aag_1                                                             
#                 DISPLAY BY NAME l_aag_1                                                                           
#                 NEXT FIELD aag_1                                                                                               
#            WHEN INFIELD(aag_2)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_2    
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                 
#                 CALL cl_create_qry() RETURNING l_aag_2                                                             
#                 DISPLAY BY NAME l_aag_2                                                                           
#                 NEXT FIELD aag_2                                                                                               
#            WHEN INFIELD(aag_3)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_3
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                     
#                 CALL cl_create_qry() RETURNING l_aag_3                                                           
#                 DISPLAY BY NAME l_aag_3                                                                           
#                 NEXT FIELD aag_3
#            WHEN INFIELD(aag_4)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_4  
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                      
#                 CALL cl_create_qry() RETURNING l_aag_4                                                            
#                 DISPLAY BY NAME l_aag_4                                                                           
#                 NEXT FIELD aag_4                                                                                               
#            WHEN INFIELD(aag_5)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_5       
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                              
#                 CALL cl_create_qry() RETURNING l_aag_5                                                             
#                 DISPLAY BY NAME l_aag_5                                                                           
#                 NEXT FIELD aag_5                                                                                               
#            WHEN INFIELD(aag_6)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_6
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                     
#                 CALL cl_create_qry() RETURNING l_aag_6                                                          
#                 DISPLAY BY NAME l_aag_6                                                                           
#                 NEXT FIELD aag_6
#             WHEN INFIELD(aag_7)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_7       
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                              
#                 CALL cl_create_qry() RETURNING l_aag_7                                                           
#                 DISPLAY BY NAME l_aag_7                                                                           
#                 NEXT FIELD aag_7                                                                                               
#            WHEN INFIELD(aag_8)                                                                                                     
#                 CALL cl_init_qry_var()                                                                                              
#                 LET g_qryparam.form ="q_aag"                                                                                   
#                 LET g_qryparam.default1 = l_aag_8 
#                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                    
#                 CALL cl_create_qry() RETURNING l_aag_8                                                             
#                 DISPLAY BY NAME l_aag_8                                                                           
#                 NEXT FIELD aag_8 
#         END CASE
#      ON ACTION CONTROLG
#         CALL cl_cmdask()    # Command execution
#      ON ACTION locale
#        #CALL cl_dynamic_locale()
#         LET g_action_choice = "locale"
#         EXIT INPUT
#FUN-B20054--mark--end--
 
      AFTER FIELD aag_1
         IF NOT cl_null(l_aag_1) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_1
               AND aag00=tm.b     #No.FUN-740055
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_1
               LET g_qryparam.arg1 = tm.b
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_1 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_1
               DISPLAY BY NAME l_aag_1 
               #No.FUN-B10053  --End
               NEXT FIELD aag_1
            END IF
         END IF
         LET g_ary[1].aag=l_aag_1
         LET g_ary[1].cnt="1"
 
      AFTER FIELD aag_2
         LET l_aag_2 = duplicate(l_aag_2)   #不使"工廠編號"重覆
         IF NOT cl_null(l_aag_2) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_2
               AND aag00=tm.b     #No.FUN-740055
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_2
               LET g_qryparam.arg1 = tm.b    
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_2 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_2
               DISPLAY BY NAME l_aag_2
               #No.FUN-B10053  --End
               NEXT FIELD aag_2
            END IF
         END IF
         LET g_ary[2].aag = l_aag_2
         LET g_ary[2].cnt="2"
 
      AFTER FIELD aag_3
         LET l_aag_3 = duplicate(l_aag_3)   #不使"工廠編號"重覆
         IF NOT cl_null(l_aag_3) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_3
               AND aag00=tm.b     #No.FUN-740055
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_3
               LET g_qryparam.arg1 = tm.b
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_3 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_3
               DISPLAY BY NAME l_aag_3
               #No.FUN-B10053  --End
               NEXT FIELD aag_3
            END IF
         END IF
         LET g_ary[3].aag = l_aag_3
         LET g_ary[3].cnt="3"
 
      AFTER FIELD aag_4
         LET l_aag_4 = duplicate(l_aag_4)   #不使"工廠編號"重覆
         IF NOT cl_null(l_aag_4) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_4
               AND aag00=tm.b     #No.FUN-740055 
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_4
               LET g_qryparam.arg1 = tm.b
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_4 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_4
               DISPLAY BY NAME l_aag_4
               #No.FUN-B10053  --End
               NEXT FIELD aag_4
            END IF
         END IF
         LET g_ary[4].aag = l_aag_4
         LET g_ary[4].cnt="4"
 
      AFTER FIELD aag_5
         LET l_aag_5 = duplicate(l_aag_5)   #不使"工廠編號"重覆
         IF NOT cl_null(l_aag_5) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_5
               AND aag00=tm.b     #No.FUN-740055
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_5
               LET g_qryparam.arg1 = tm.b
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_5 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_5
               DISPLAY BY NAME l_aag_5
               #No.FUN-B10053  --End
               NEXT FIELD aag_5
            END IF
         END IF
         LET g_ary[5].aag = l_aag_5
         LET g_ary[5].cnt="5"
 
      AFTER FIELD aag_6
         LET l_aag_6 = duplicate(l_aag_6)   #不使"工廠編號"重覆
         IF NOT cl_null(l_aag_6) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_6
               AND aag00=tm.b     #No.FUN-740055
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_6
               LET g_qryparam.arg1 = tm.b
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_6 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_6
               DISPLAY BY NAME l_aag_6
               #No.FUN-B10053  --End
               NEXT FIELD aag_6
            END IF
         END IF
         LET g_ary[6].aag = l_aag_6
         LET g_ary[6].cnt="6"
 
      AFTER FIELD aag_7
         LET l_aag_7 = duplicate(l_aag_7)   #不使"工廠編號"重覆
         IF NOT cl_null(l_aag_7) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_7
               AND aag00=tm.b     #No.FUN-740055
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_7
               LET g_qryparam.arg1 = tm.b
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_7 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_7
               DISPLAY BY NAME l_aag_7
               #No.FUN-B10053  --End
               NEXT FIELD aag_7
            END IF
         END IF
         LET g_ary[7].aag = l_aag_7
         LET g_ary[7].cnt="7"
 
      AFTER FIELD aag_8
         LET l_aag_8 = duplicate(l_aag_8)   #不使"工廠編號"重覆
         IF NOT cl_null(l_aag_8) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM aag_file
             WHERE aag01=l_aag_8
               AND aag00=tm.b     #No.FUN-740055
               AND aag07<>"1"
            IF g_cnt=0 THEN
               #No.FUN-B10053  --Begin
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aag"
               LET g_qryparam.construct = 'N'
               LET g_qryparam.default1 = l_aag_8
               LET g_qryparam.arg1 = tm.b
               LET g_qryparam.where = " aag07 IN ('2','3')  AND aagacti='Y' AND aag01 LIKE '",l_aag_8 CLIPPED,"%'"
               CALL cl_create_qry() RETURNING l_aag_8
               DISPLAY BY NAME l_aag_8
               #No.FUN-B10053  --End
               NEXT FIELD aag_8
            END IF
         END IF
         LET g_ary[8].aag = l_aag_8
         LET g_ary[8].cnt="8"
         IF cl_null(l_aag_1) AND cl_null(l_aag_2) AND
            cl_null(l_aag_3) AND cl_null(l_aag_4) AND
            cl_null(l_aag_5) AND cl_null(l_aag_6) AND
            cl_null(l_aag_7) AND cl_null(l_aag_8) THEN
            CALL cl_err(0,'agl-136',0)
            NEXT FIELD aag_1
         END IF

#FUN-B20054--mark--str--
#      ON ACTION exit
#         LET INT_FLAG = 1
#         EXIT INPUT
#FUN-B20054--mark--end--
#--NO.MOD-860078 start---
#FUN-B20054--mark--str--
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about         
#         CALL cl_about()      
# 
#      ON ACTION help          
#         CALL cl_show_help()
#FUN-B20054--mark--end--  
#--NO.MOD-860078 end------- 
   END INPUT
   
#FUN-B20054--mark--str--
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW g406_w
#      EXIT PROGRAM
#   END IF
#FUN-B20054--mark--end--
#TQC-730072....end 還原位置
#No.FUN-740055  ---begin--------by bnlent  調換位置
   #DISPLAY BY NAME tm.e,tm.more         # Condition  #FUN-6C0012  #FUN-B20054
    INPUT BY NAME tm.yy,tm.bm,tm.em,tm.h,tm.e,tm.more  #FUN-6C0012 #No.MOD-860252 add tm.h #FUN-B20054 del tm.b
		  #WITHOUT DEFAULTS   #FUN-B20054  
		  ATTRIBUTE(WITHOUT DEFAULTS)  #FUN-B20054
		  
		  #FUN-B20054--mark--str--
      #AFTER FIELD b
      #   IF cl_null(tm.b) THEN NEXT FIELD b END IF
      #   SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
      #   IF STATUS THEN CALL cl_err('sel aaa:',STATUS,0) NEXT FIELD b END IF
      #FUN-B20054--mark--end--
      
      AFTER FIELD yy
         IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
      AFTER FIELD bm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.bm) THEN NEXT FIELD bm END IF
#No.TQC-720032 -- begin --
#         IF tm.bm <1 OR tm.bm > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD bm
#         END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD em
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em 
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(tm.em) THEN NEXT FIELD em END IF
#No.TQC-720032 -- begin --
#         IF tm.em <1 OR tm.em > 13 THEN
#            CALL cl_err('','agl-013',0) NEXT FIELD em
#         END IF
#No.TQC-720032 -- end --
         IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
      AFTER FIELD more
         IF tm.more = 'Y' THEN
            CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                          g_bgjob,g_time,g_prtway,g_copies)
            RETURNING g_pdate,g_towhom,g_rlang,
                      g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
#FUN-B20054--mark--str--
#   ON ACTION CONTROLR
#      CALL cl_show_req_fields()  
#FUN-B20054--mark--end--
################################################################################
#FUN-B20054--mark--str--
#      ON ACTION CONTROLG
#         CALL cl_cmdask()    # Command execution
#      ON ACTION CONTROLP
#         CASE
#            WHEN INFIELD(b)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = 'q_aaa'
#               LET g_qryparam.default1 = tm.b
#               CALL cl_create_qry() RETURNING tm.b
#               DISPLAY BY NAME tm.b
#               NEXT FIELD b
#         END CASE
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
# 
#      ON ACTION about      
#         CALL cl_about()  
# 
#      ON ACTION help        
#         CALL cl_show_help()
# 
# 
#          ON ACTION exit
#          LET INT_FLAG = 1
#          EXIT INPUT   
#FUN-B20054--mark--end--
   END INPUT     
   
   #FUN-B20054--add--str--
   ON ACTION CONTROLG
         CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLP
      CASE                                                                                                                       
            WHEN INFIELD(aag_1)                                                                                                     
                 CALL cl_init_qry_var()                                                                                               
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_1
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                     
                 CALL cl_create_qry() RETURNING l_aag_1                                                             
                 DISPLAY BY NAME l_aag_1                                                                           
                 NEXT FIELD aag_1                                                                                               
            WHEN INFIELD(aag_2)                                                                                                     
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_2    
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                 
                 CALL cl_create_qry() RETURNING l_aag_2                                                             
                 DISPLAY BY NAME l_aag_2                                                                           
                 NEXT FIELD aag_2                                                                                               
            WHEN INFIELD(aag_3)                                                                                                     
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_3
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                     
                 CALL cl_create_qry() RETURNING l_aag_3                                                           
                 DISPLAY BY NAME l_aag_3                                                                           
                 NEXT FIELD aag_3
            WHEN INFIELD(aag_4)                                                                                                     
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_4  
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                      
                 CALL cl_create_qry() RETURNING l_aag_4                                                            
                 DISPLAY BY NAME l_aag_4                                                                           
                 NEXT FIELD aag_4                                                                                               
            WHEN INFIELD(aag_5)                                                                                                     
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_5       
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                              
                 CALL cl_create_qry() RETURNING l_aag_5                                                             
                 DISPLAY BY NAME l_aag_5                                                                           
                 NEXT FIELD aag_5                                                                                               
            WHEN INFIELD(aag_6)                                                                                                     
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_6
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                     
                 CALL cl_create_qry() RETURNING l_aag_6                                                          
                 DISPLAY BY NAME l_aag_6                                                                           
                 NEXT FIELD aag_6
             WHEN INFIELD(aag_7)                                                                                                     
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_7       
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                              
                 CALL cl_create_qry() RETURNING l_aag_7                                                           
                 DISPLAY BY NAME l_aag_7                                                                           
                 NEXT FIELD aag_7                                                                                               
            WHEN INFIELD(aag_8)                                                                                                     
                 CALL cl_init_qry_var()                                                                                              
                 LET g_qryparam.form ="q_aag"                                                                                   
                 LET g_qryparam.default1 = l_aag_8 
                 LET g_qryparam.arg1 = tm.b    #No.FUN-740055                                                                                    
                 CALL cl_create_qry() RETURNING l_aag_8                                                             
                 DISPLAY BY NAME l_aag_8                                                                           
                 NEXT FIELD aag_8 
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aaa'
               LET g_qryparam.default1 = tm.b
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
         END CASE
 
      ON ACTION locale
         CALL cl_show_fld_cont()
         LET g_action_choice = "locale"
         EXIT DIALOG

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT DIALOG

      ON ACTION accept
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG=1
         EXIT DIALOG  
    END DIALOG       
   #FUN-B20054--add--end--
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW g406_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
#No.FUN-740055   ----End-----  by bnlent  調換位置
 
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gglg406'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gglg406','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",l_aag_1 CLIPPED,"'",
                         " '",l_aag_2 CLIPPED,"'",
                         " '",l_aag_3 CLIPPED,"'",
                         " '",l_aag_4 CLIPPED,"'",
                         " '",l_aag_5 CLIPPED,"'",
                         " '",l_aag_6 CLIPPED,"'",
                         " '",l_aag_7 CLIPPED,"'",
                         " '",l_aag_8 CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.bm CLIPPED,"'",
                         " '",tm.em CLIPPED,"'",
                         " '",tm.more CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",         
                         " '",g_template CLIPPED,"'"         
         CALL cl_cmdat('gglg406',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW g406_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL g406()
   ERROR ""
END WHILE
   CLOSE WINDOW g406_w
END FUNCTION
 
FUNCTION g406()
   DEFINE l_name    LIKE type_file.chr20, # External(Disk) file name CHAE(20)
          l_time    LIKE type_file.chr8,  # Used time for running the job VARCHAR(8)
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT VARCHAR(1000)
          l_chr     LIKE type_file.chr2,  #CHAR(2)
          l_aag06   LIKE aag_file.aag06,
          l_order   ARRAY[5] OF LIKE cre_file.cre08, #CHAR(10)
          l_year_bal LIKE abb_file.abb07,   #No.FUN-7C0064
          sr               RECORD
                                  sw  LIKE type_file.chr1, #CHAR(1)
                                  aag LIKE aag_file.aag01,
                                  aba01 LIKE aba_file.aba01,
                                  aba02 LIKE aba_file.aba02,
                                  abb03 LIKE abb_file.abb03,
                                  abb04 LIKE abb_file.abb04,
                                  abb07 LIKE abb_file.abb07,
                                  aah04 LIKE aah_file.aah04,
                                  aah05 LIKE aah_file.aah05,
                                  YY    LIKE type_file.chr4, #CHAR(04)
                                  MM    LIKE type_file.chr2, #CHAR(02)
                                  DD    LIKE type_file.chr2,  #CHAR(02)   
                                  #FUN-B40087--------add------str---------------
                                  abb07_1  LIKE abb_file.abb07,
                                  abb07_2  LIKE abb_file.abb07,
                                  abb07_3  LIKE abb_file.abb07,
                                  abb07_4  LIKE abb_file.abb07,
                                  abb07_5  LIKE abb_file.abb07,
                                  abb07_6  LIKE abb_file.abb07,
                                  abb07_7  LIKE abb_file.abb07,
                                  abb07_8  LIKE abb_file.abb07,
                                  bal_e1   LIKE abb_file.abb07,
                                  bal_e2   LIKE abb_file.abb07
                                  #FUN-B40087--------add------end--------------
                        END RECORD
 
     #No.FUN-7C0064  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-7C0064  --End
 
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglg406'
     SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b
     IF SQLCA.sqlcode THEN CALL cl_err('',SQLCA.sqlcode,0) END IF
     SELECT azi04 INTO g_azi04 FROM azi_file
      WHERE azi01 = g_aaa03
 
     #No.FUN-7C0064  --Begin
     #CALL cl_outnam('gglg406') RETURNING l_name
     #LET g_len=168      #TQC-5B0102
     #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     #START REPORT g406_rep TO l_name
     #No.FUN-7C0064  --End  
 
     FOR g_idx = 1 TO 8
         IF cl_null(g_ary[g_idx].aag) THEN
            CONTINUE FOR
         END IF
         SELECT SUM(aah04-aah05) INTO g_bal[g_idx] FROM aah_file
          WHERE aah01=g_ary[g_idx].aag AND aah02=tm.yy 
            AND aah00=tm.b  AND aah03=tm.bm-1
         #No.FUN-7C0064  --Begin
         IF cl_null(g_bal[g_idx]) THEN LET g_bal[g_idx]=0 END IF
         LET l_year_bal = 0
         SELECT SUM(abb07) INTO l_year_bal FROM abb_file,aba_file
          WHERE abb00=aba00 AND abb01=aba01 
            AND aba03=tm.yy AND aba04<tm.bm-1
            AND aba00=tm.b  AND abb03=g_ary[g_idx].aag 
            AND aba19='Y' AND abapost='Y'
         IF cl_null(l_year_bal) THEN LET l_year_bal = 0 END IF
         IF tm.e = 'Y' THEN  
            SELECT aag13 INTO g_ary[g_idx].aag02 FROM aag_file
             WHERE aag01=g_ary[g_idx].aag
               AND aag00=tm.b 
         ELSE                
            SELECT aag02 INTO g_ary[g_idx].aag02 FROM aag_file
             WHERE aag01=g_ary[g_idx].aag
               AND aag00=tm.b
         END IF            
         #No.FUN-7C0064  --End  
         LET l_sql = "SELECT  distinct aag06,'',aba01,aba02,abb03,abb04,abb07 ",
                     " FROM aba_file,abb_file,aag_file",                                                                            
                     " WHERE YEAR(aba02) = ",tm.yy,                                                                                 
                     " AND MONTH(aba02) BETWEEN '",tm.bm,"' AND '",tm.em,"'",                                                       
                     " AND aba19 = 'Y' ",                                                                                           
                     " AND abapost= 'Y' ",                                                                                          
                     " AND aba01=abb01",                                                                                            
                     " AND aba00=abb00",  #No.FUN-7C0064
                     " AND aba00=aag00",  #No.FUN-7C0064
                     " AND abb03='",g_ary[g_idx].aag,"'", 
                     " AND aag00= '",tm.b,"' ",    #No.FUN-740055                                                                          
                     " AND aag01 = abb03 "
         #No.MOD-860252--begin--
         IF tm.h = 'Y' THEN 
            LET l_sql = l_sql CLIPPED," AND aag09 = 'Y' " 
         END IF
         #No.MOD-860252---end---
         PREPARE g406_prepare1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
            CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
            EXIT PROGRAM
         END IF
         DECLARE g406_curs1 CURSOR FOR g406_prepare1
         LET g_pageno = 0
         FOREACH g406_curs1 INTO sr.*
              IF SQLCA.sqlcode != 0 THEN
                 CALL cl_err('foreach:',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              LET sr.aag = g_ary[g_idx].aag
              LET sr.YY=YEAR(sr.aba02)                                                                                                      
              LET sr.MM=MONTH(sr.aba02) USING"&&"                                                                                           
              LET sr.DD=DAY(sr.aba02) USING"&&"

#FUN-B40087---------------add-----------str---------
              LET sr.bal_e1 = 0
              LET sr.bal_e2 = 0
              
              IF g_idx = '1' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_1 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_1
                 ELSE
                    LET sr.abb07_1 = sr.abb07 * (-1)
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_1 
                    END IF
                 END IF
              ELSE
                 LET sr.abb07_1 = 0
              END IF
              
              
              IF g_idx = '2' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_2 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_2
                 ELSE
                    LET sr.abb07_2 = sr.abb07 * (-1)    
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_2 
                    END IF
                 END IF
              ELSE
                 LET sr.abb07_2 = 0
              END IF
              
              IF g_idx = '3' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_3 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_3
                 ELSE
                    LET sr.abb07_3 = sr.abb07 * (-1)    
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_3 
                    END IF
                 END IF
              ELSE
                 LET sr.abb07_3 = 0
              END IF
              
              IF g_idx = '4' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_4 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_4
                 ELSE
                    LET sr.abb07_4 = sr.abb07 * (-1)  
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_4
                    END IF  
                 END IF
              ELSE
                 LET sr.abb07_4 = 0
              END IF
              
              IF g_idx = '5' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_5 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_5
                 ELSE
                    LET sr.abb07_5 = sr.abb07 * (-1)  
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_5 
                    END IF  
                 END IF
              ELSE
                 LET sr.abb07_5 = 0
              END IF
              
              IF g_idx = '6' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_6 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_6
                 ELSE
                    LET sr.abb07_6 = sr.abb07 * (-1)    
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_6 
                    END IF
                 END IF
              ELSE
                 LET sr.abb07_6 = 0
              END IF
              
              IF g_idx = '7' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_7 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_7
                 ELSE
                    LET sr.abb07_7 = sr.abb07 * (-1)    
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_7 
                    END IF
                 END IF
              ELSE
                 LET sr.abb07_7 = 0
              END IF
              
              
              IF g_idx = '8' THEN 
                 IF sr.sw = '1' THEN 
                    LET sr.abb07_8 = sr.abb07
                    LET sr.bal_e1  = sr.bal_e1 + sr.abb07_8
                 ELSE
                    LET sr.abb07_8 = sr.abb07 * (-1)  
                    IF sr.sw = '2' THEN          
                       LET sr.bal_e2  = sr.bal_e2 + sr.abb07_8 
                    END IF  
                 END IF
              ELSE
                 LET sr.abb07_8 = 0
              END IF

#FUN-B40087-----------add------------end-----------------
              #No.FUN-7C0064  --Begin
              #OUTPUT TO REPORT g406_rep(sr.*)
              EXECUTE insert_prep USING
                      sr.sw, g_idx, sr.aag, sr.aba01, sr.abb03, sr.abb04,
                      sr.abb07, l_year_bal, sr.YY, sr.MM, sr.DD,
                      sr.abb07_1,sr.abb07_2,sr.abb07_3,sr.abb07_4,sr.abb07_5,   #FUN-B40087 add
                      sr.abb07_6,sr.abb07_7,sr.abb07_8                          #FUN-B40087 add 
             #No.FUN-7C0064  --End
         END FOREACH
     END FOR
     #No.FUN-7C0064  --Begin
     #FINISH REPORT g406_rep
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     FOR g_idx = 1 TO 8
         IF cl_null(g_bal[g_idx]) THEN LET g_bal[g_idx] = 0 END IF
     END FOR
###GENGRE###     LET g_str = g_ary[1].aag02,';',g_ary[2].aag02,';',g_ary[3].aag02,';',
###GENGRE###                 g_ary[4].aag02,';',g_ary[5].aag02,';',g_ary[6].aag02,';',
###GENGRE###                 g_ary[7].aag02,';',g_ary[8].aag02,';',
###GENGRE###                 g_bal[1],';', g_bal[2],';', g_bal[3],';', g_bal[4],';',
###GENGRE###                 g_bal[5],';', g_bal[6],';', g_bal[7],';', g_bal[8],';',
###GENGRE###                 g_azi04
###GENGRE###     CALL cl_prt_cs3('gglg406','gglg406',g_sql,g_str)
    CALL gglg406_grdata()    ###GENGRE###
     #No.FUN-7C0064  --End
    
     #No.FUN-B80096--mark--Begin---
     #CALL cl_used(g_prog,l_time,2) RETURNING l_time 
     #No.FUN-B80096--mark--End-----
  
   # CALL cl_gre_drop_temptable(l_table)   #FUN-CC0084
END FUNCTION
 
#No.FUN-7C0064  --Begin
#REPORT g406_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1, #CHAR(1)
#          l_i,l_a,n    LIKE type_file.num5, #SMALLINT
#          l_chr2       LIKE type_file.chr2, #CHAR(02)
#          l_pma02      LIKE pma_file.pma02,
#          sr               RECORD
#                                  sw  LIKE type_file.chr1, #CHAR(1)
#                                  aag LIKE aag_file.aag01,
#                                  aba01 LIKE aba_file.aba01,
#                                  aba02 LIKE aba_file.aba02,
#                                  abb03 LIKE abb_file.abb03,
#                                  abb04 LIKE abb_file.abb04,
#                                  abb07 LIKE abb_file.abb07,
#                                  aah04 LIKE aah_file.aah04,
#                                  aah05 LIKE aah_file.aah05,
#                                  YY    LIKE type_file.chr4, #CHAR(04)
#                                  MM    LIKE type_file.chr2, #CHAR(02)
#                                  DD    LIKE type_file.chr2  #CHAR(02)
#                        END RECORD,
#          sr1              RECORD
#                                  curr  LIKE type_file.chr4, #CHAR(04)
#                                  amt   LIKE abb_file.abb07
#                        END RECORD,
#      l_mon        LIKE type_file.num5, #SMALLINT
#      l_mark       LIKE type_file.num10, #INTEGER
#      l_day        LIKE type_file.num5, #SMALLINT
#      l_amt_1      LIKE type_file.num20_6, #DECIMAL(20,6)
#      s_amt_1      LIKE type_file.num20_6, #DECIMAL(20,6)
#      l_bal1       LIKE type_file.num20_6, #DEC(20,6)   
#      l_bal2       LIKE type_file.num20_6, #DEC(20,6)  
#      l_bal        LIKE type_file.num20_6, #DEC(20,6)   
#      l_amt_2      LIKE type_file.num20_6, #DEC(20,6)
#      l_name1      LIKE aag_file.aag02,    #CHAR(30)
#      l_name2      LIKE aag_file.aag02,    #CHAR(30)
#      l_name3      LIKE aag_file.aag02,    #CHAR(30)
#      l_name4      LIKE aag_file.aag02,    #CHAR(30)
#      l_name5      LIKE aag_file.aag02,    #CHAR(30)
#      l_name6      LIKE aag_file.aag02,    #CHAR(30)
#      l_name7      LIKE aag_file.aag02,    #CHAR(30)
#      l_name8      LIKE aag_file.aag02,    #CHAR(30)
#      l_total1     LIKE type_file.num20_6, #DEC(20,6)
#      l_total2     LIKE type_file.num20_6, #DEC(20,6)
#      l_total3     LIKE type_file.num20_6, #DEC(20,6)
#      l_total4     LIKE type_file.num20_6, #DEC(20,6)
#      l_total5     LIKE type_file.num20_6, #DEC(20,6)
#      l_total6     LIKE type_file.num20_6, #DEC(20,6)
#      l_total7     LIKE type_file.num20_6, #DEC(20,6)
#      l_total8     LIKE type_file.num20_6, #DEC(20,6)
#      l_tot1       LIKE type_file.num20_6, #DEC(20,6)
#      l_tot2       LIKE type_file.num20_6, #DEC(20,6)
#      s_total1     LIKE type_file.num20_6, #DEC(20,6)
#      s_total2     LIKE type_file.num20_6, #DEC(20,6)
#      s_total3     LIKE type_file.num20_6, #DEC(20,6)
#      s_total4     LIKE type_file.num20_6, #DEC(20,6)
#      s_total5     LIKE type_file.num20_6, #DEC(20,6)
#      s_total6     LIKE type_file.num20_6, #DEC(20,6)
#      s_total7     LIKE type_file.num20_6, #DEC(20,6)
#      s_total8     LIKE type_file.num20_6, #DEC(20,6)
#      l_chr        LIKE type_file.chr2  #CHAR(02)
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN 0
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.MM,sr.aba01
#  FORMAT
#   PAGE HEADER
#      PRINT '~T28X0L19;',(g_len-FGL_WIDTH(g_x[6]))/2 SPACES,g_x[6]
#      PRINT COLUMN 083,
#            sr.YY USING "###&" 
#      PRINT ' '
#      PRINT ' '
#      LET g_pageno = g_pageno + 1
#      LET l_name1=NULL
#      LET l_name2=NULL
#      LET l_name3=NULL
#      LET l_name4=NULL
#      LET l_name5=NULL
#      LET l_name6=NULL
#      LET l_name7=NULL
#      LET l_name8=NULL
#       
#      FOR l_i = 1 TO 8
#          CASE WHEN g_ary[l_i].cnt="1"
#                    IF tm.e = 'Y' THEN                        #FUN-6C0012        
#                       SELECT aag13 INTO l_name1 FROM aag_file #FUN-6C0012       
#                      WHERE aag01=g_ary[l_i].aag               #FUN-6C0012
#                        AND aag00=tm.b     #No.FUN-740055       
#                    ELSE                                       #FUN-6C0012 
#                       SELECT aag02 INTO l_name1 FROM aag_file  
#                      WHERE aag01=g_ary[l_i].aag
#                        AND aag00=tm.b     #No.FUN-740055
#                     END IF                                     #FUN-6C0012 
#               WHEN g_ary[l_i].cnt="2"
#                    IF tm.e = 'Y' THEN                        #FUN-6C0012        
#                       SELECT aag13 INTO l_name2 FROM aag_file #FUN-6C0012       
#                      WHERE aag01=g_ary[l_i].aag               #FUN-6C0012      
#                        AND aag00=tm.b     #No.FUN-740055 
#                    ELSE                                       #FUN-6C0012
#                       SELECT aag02 INTO l_name2 FROM aag_file
#                      WHERE aag01=g_ary[l_i].aag
#                        AND aag00=tm.b     #No.FUN-740055
#                    END IF                                     #FUN-6C0012
#               WHEN g_ary[l_i].cnt="3"
#                    IF tm.e = 'Y' THEN                        #FUN-6C0012        
#                       SELECT aag13 INTO l_name3 FROM aag_file #FUN-6C0012       
#                      WHERE aag01=g_ary[l_i].aag               #FUN-6C0012      
#                        AND aag00=tm.b     #No.FUN-740055 
#                    ELSE                                       #FUN-6C0012
#                       SELECT aag02 INTO l_name3 FROM aag_file  
#                      WHERE aag01=g_ary[l_i].aag
#                        AND aag00=tm.b     #No.FUN-740055
#                    END IF                                     #FUN-6C0012
#               WHEN g_ary[l_i].cnt="4"
#                     IF tm.e = ' Y' THEN                        #FUN-6C0012       
#                        SELECT aag13 INTO l_name4 FROM aag_file #FUN-6C0012       
#                       WHERE aag01=g_ary[l_i].aag               #FUN-6C0012      
#                         AND aag00=tm.b     #No.FUN-740055 
#                     ELSE                                       #FUN-6C0012
#                        SELECT aag02 INTO l_name4 FROM aag_file  
#                       WHERE aag01=g_ary[l_i].aag
#                         AND aag00=tm.b     #No.FUN-740055
#                     END IF                                     #FUN-6C0012
#               WHEN g_ary[l_i].cnt="5"
#                    IF tm.e = 'Y' THEN                        #FUN-6C0012        
#                       SELECT aag13 INTO l_name5 FROM aag_file #FUN-6C0012       
#                      WHERE aag01=g_ary[l_i].aag               #FUN-6C0012      
#                        AND aag00=tm.b     #No.FUN-740055 
#                    ELSE                                       #FUN-6C0012
#                       SELECT aag02 INTO l_name5 FROM aag_file  
#                      WHERE aag01=g_ary[l_i].aag
#                        AND aag00=tm.b     #No.FUN-740055
#                    END IF                                     #FUN-6C0012
#               WHEN g_ary[l_i].cnt="6"
#                    IF tm.e = 'Y' THEN                        #FUN-6C0012        
#                       SELECT aag13 INTO l_name6 FROM aag_file #FUN-6C0012       
#                      WHERE aag01=g_ary[l_i].aag               #FUN-6C0012      
#                        AND aag00=tm.b     #No.FUN-740055 
#                    ELSE                                       #FUN-6C0012
#                       SELECT aag02 INTO l_name6 FROM aag_file  
#                      WHERE aag01=g_ary[l_i].aag
#                        AND aag00=tm.b     #No.FUN-740055
#                    END IF                                     #FUN-6C0012
#               WHEN g_ary[l_i].cnt="7"
#                    IF tm.e = 'Y' THEN                        #FUN-6C0012        
#                       SELECT aag13 INTO l_name7 FROM aag_file #FUN-6C0012       
#                      WHERE aag01=g_ary[l_i].aag               #FUN-6C0012     
#                        AND aag00=tm.b     #No.FUN-740055  
#                    ELSE                                       #FUN-6C0012
#                       SELECT aag02 INTO l_name7 FROM aag_file  
#                      WHERE aag01=g_ary[l_i].aag
#                        AND aag00=tm.b     #No.FUN-740055
#                    END IF                                     #FUN-6C0012
#               WHEN g_ary[l_i].cnt="8"
#                    IF tm.e = 'Y' THEN                        #FUN-6C0012        
#                       SELECT aag13 INTO l_name8 FROM aag_file #FUN-6C0012       
#                      WHERE aag01=g_ary[l_i].aag               #FUN-6C0012      
#                        AND aag00=tm.b     #No.FUN-740055 
#                    ELSE                                       #FUN-6C0012
#                       SELECT aag02 INTO l_name8 FROM aag_file  
#                      WHERE aag01=g_ary[l_i].aag
#                        AND aag00=tm.b     #No.FUN-740055
#                    END IF                                     #FUN-6C0012
#       END CASE
#     END FOR
#       PRINT COLUMN 049, l_name1[1,12] CLIPPED,
#             COLUMN 062, l_name2[1,12] CLIPPED,
#             COLUMN 075, l_name3[1,12] CLIPPED,
#             COLUMN 088, l_name4[1,12] CLIPPED,
#             COLUMN 101, l_name5[1,12] CLIPPED,
#             COLUMN 114, l_name6[1,12] CLIPPED,
#             COLUMN 127, l_name7[1,12] CLIPPED,
#             COLUMN 142, l_name8[1,12] CLIPPED
#      LET l_last_sw = 'n'
#     IF g_pageno=1 THEN
#      LET l_bal1 = 0 
#      FOR g_idx=1 TO 4                                                                                                               
#           IF g_bal[g_idx] IS NOT NULL THEN                                                                                         
#              LET l_bal1=g_bal[g_idx]+l_bal1                                                                       
#           END IF                           
#      END FOR                                                                                        
#      LET l_bal2 = 0      
#      FOR g_idx=5 TO 8                                                                                                          
#           IF g_bal[g_idx] IS NOT NULL THEN
#              LET g_bal[g_idx]=g_bal[g_idx]*-1                                                                                         
#              LET l_bal2=g_bal[g_idx]+l_bal2                                                                       
#           END IF     
#      END FOR                                                                                                              
#      LET l_bal=0                
#      LET l_bal=l_bal1-l_bal2
#      IF l_bal<0  THEN   
#              LET l_chr2=g_x[4]                                                                                                        
#              LET l_bal=l_bal*-1                                                                                                    
#      ELSE    
#           IF l_bal>0 THEN
#              LET l_chr2=g_x[3]         
#           ELSE   
#              LET l_chr2=g_x[5]
#           END IF
#      END IF
#    ELSE
#      LET l_bal=l_amt_1
#    END IF     
##TQC-730072.....begin                                                           
#      IF cl_null(g_bal[1]) THEN LET g_bal[1] = 0 END IF                         
#      IF cl_null(g_bal[2]) THEN LET g_bal[2] = 0 END IF                         
#      IF cl_null(g_bal[3]) THEN LET g_bal[3] = 0 END IF                         
#      IF cl_null(g_bal[4]) THEN LET g_bal[4] = 0 END IF                         
#      IF cl_null(g_bal[5]) THEN LET g_bal[5] = 0 END IF                         
#      IF cl_null(g_bal[6]) THEN LET g_bal[6] = 0 END IF                         
#      IF cl_null(g_bal[7]) THEN LET g_bal[7] = 0 END IF                         
#      IF cl_null(g_bal[8]) THEN LET g_bal[8] = 0 END IF                         
##TQC-730072.....end
#      IF g_pageno >1 THEN                                                                                                           
#       PRINT COLUMN 021,g_x[10] CLIPPED                                                                                             
#      ELSE                                                                                                                           
#       PRINT COLUMN 021,g_x[9] CLIPPED,                                                                                             
#             COLUMN 049, cl_numfor(g_bal[1],11,g_azi04) CLIPPED,                                                                    
#             COLUMN 061, cl_numfor(g_bal[2],11,g_azi04) CLIPPED,                                                                    
#             COLUMN 075, cl_numfor(g_bal[3],11,g_azi04) CLIPPED,                                                                    
#             COLUMN 088, cl_numfor(g_bal[4],11,g_azi04) CLIPPED,                                                                    
#             COLUMN 101, cl_numfor(g_bal[5],11,g_azi04) CLIPPED,                                                                    
#             COLUMN 114, cl_numfor(g_bal[6],11,g_azi04) CLIPPED,                                                                    
#             COLUMN 127, cl_numfor(g_bal[7],11,g_azi04) CLIPPED,                                                                    
#             COLUMN 140, cl_numfor(g_bal[8],11,g_azi04) CLIPPED,
#             COLUMN 153, l_chr2 CLIPPED,
#             COLUMN 156, cl_numfor(l_bal,12,g_azi04) CLIPPED 
#      END IF
#    
#   ON EVERY ROW
#      IF LINENO=34 THEN 
#         PRINT COLUMN 021,g_x[8] CLIPPED
#         SKIP TO TOP OF PAGE
#      END IF
#      IF l_amt_1 IS NULL THEN LET l_amt_1=0 END IF
#      IF l_amt_2 IS NULL THEN LET l_amt_2=0 END IF 
#      IF l_total1 IS NULL THEN LET l_total1=0 END IF
#      IF l_total2 IS NULL THEN LET l_total2=0 END IF
#      IF l_total3 IS NULL THEN LET l_total3=0 END IF
#      IF l_total4 IS NULL THEN LET l_total4=0 END IF
#      IF l_total5 IS NULL THEN LET l_total5=0 END IF
#      IF l_total6 IS NULL THEN LET l_total6=0 END IF
#      IF l_total7 IS NULL THEN LET l_total7=0 END IF
#      IF l_total8 IS NULL THEN LET l_total8=0 END IF
#      IF g_bal[1] IS NULL THEN LET g_bal[1]=0 END IF
#      IF g_bal[2] IS NULL THEN LET g_bal[2]=0 END IF
#      IF g_bal[3] IS NULL THEN LET g_bal[3]=0 END IF
#      IF g_bal[4] IS NULL THEN LET g_bal[4]=0 END IF
#      IF g_bal[5] IS NULL THEN LET g_bal[5]=0 END IF 
#      IF g_bal[6] IS NULL THEN LET g_bal[6]=0 END IF
#      IF g_bal[7] IS NULL THEN LET g_bal[7]=0 END IF
#      IF g_bal[8] IS NULL THEN LET g_bal[8]=0 END IF
#      PRINT COLUMN 007,sr.MM USING"&&";
#      PRINT COLUMN 010,sr.DD USING"&&",
#            COLUMN 013,sr.aba01,
#            COLUMN 026,sr.abb04 CLIPPED;
#             IF sr.sw="1" AND sr.aag=g_ary[1].aag THEN
#               PRINT COLUMN 049, cl_numfor(sr.abb07,11,g_azi04) CLIPPED; 
#               LET l_total1=l_total1+sr.abb07
#             END IF
#             IF sr.sw="1" AND  sr.aag=g_ary[2].aag THEN
#               PRINT COLUMN 061, cl_numfor(sr.abb07,11,g_azi04) CLIPPED; 
#               LET l_total2=l_total2+sr.abb07
#             END IF
#             IF sr.sw="1" AND sr.aag=g_ary[3].aag THEN
#               PRINT COLUMN 075, cl_numfor(sr.abb07,11,g_azi04) CLIPPED;
#               LET l_total3=l_total3+sr.abb07
#             END IF
#             IF sr.sw="1" AND sr.aag=g_ary[4].aag THEN
#               PRINT COLUMN 088, cl_numfor(sr.abb07,11,g_azi04) CLIPPED;
#               LET l_total4=l_total4+sr.abb07
#             END IF
#             IF sr.sw="2" AND sr.aag=g_ary[5].aag THEN
#               PRINT COLUMN 101, cl_numfor(sr.abb07,11,g_azi04) CLIPPED;
#               LET l_total5=l_total5+sr.abb07
#             END IF
#             IF sr.sw="2" AND sr.aag=g_ary[6].aag THEN
#               PRINT COLUMN 114, cl_numfor(sr.abb07,11,g_azi04) CLIPPED; 
#               LET l_total6=l_total6+sr.abb07
#             END IF
#             IF sr.sw="2" AND sr.aag=g_ary[7].aag THEN
#               PRINT COLUMN 127, cl_numfor(sr.abb07,11,g_azi04) CLIPPED; 
#               LET l_total7=l_total7+sr.abb07
#             END IF
#             IF sr.sw="2" AND sr.aag=g_ary[8].aag THEN
#               PRINT COLUMN 140, cl_numfor(sr.abb07,11,g_azi04) CLIPPED; 
#               LET l_total8=l_total8+sr.abb07
#             END IF
#                                                                                                                      
#                                                                                                                                    
#
#       LET l_tot1=l_total1+l_total2+l_total3+l_total4
#       LET l_tot2=l_total5+l_total6+l_total7+l_total8
#       LET l_amt_2=l_tot1-l_tot2
#       LET l_amt_1=l_amt_2+l_bal*-1
#       IF sr.sw="2" THEN LET sr.abb07=sr.abb07*-1 END IF
#       IF l_amt_1<0 THEN
#           LET l_chr=g_x[4]     
#           LET l_amt_1=l_amt_1*-1          
#       ELSE
#           IF l_amt_1>0 THEN
#              LET l_chr=g_x[3] 
#           ELSE
#              LET l_chr=g_x[5] 
#           END IF
#       END IF   
#       PRINT COLUMN 153,l_chr CLIPPED,                              
#             COLUMN 156,cl_numfor(l_amt_1,12,g_azi04) CLIPPED  
#   AFTER GROUP OF sr.MM
#     IF LINENO=33 THEN
#        PRINT ' ' 
#        PRINT COLUMN 021,g_x[8] CLIPPED 
#        SKIP TO TOP OF PAGE
#     END IF
#     IF LINENO=34 THEN
#        PRINT COLUMN 021,g_x[8] CLIPPED
#        SKIP TO TOP OF PAGE
#     END IF
#    IF LINENO<=32 THEN
#      LET sr.abb07 = NULL
#       PRINT COLUMN 021,g_x[7] CLIPPED;
#          PRINT COLUMN 049, cl_numfor(l_total1,11,g_azi04) CLIPPED,                                                                     
#                COLUMN 061, cl_numfor(l_total2,11,g_azi04) CLIPPED,                                                                     
#                COLUMN 075, cl_numfor(l_total3,11,g_azi04) CLIPPED,                                                                     
#                COLUMN 088, cl_numfor(l_total4,11,g_azi04) CLIPPED,                                                                     
#                COLUMN 101, cl_numfor(l_total5,11,g_azi04) CLIPPED,                                                                     
#                COLUMN 114, cl_numfor(l_total6,11,g_azi04) CLIPPED,                                                                     
#                COLUMN 127, cl_numfor(l_total7,11,g_azi04) CLIPPED,                                                                     
#                COLUMN 140, cl_numfor(l_total8,11,g_azi04) CLIPPED,           
#                COLUMN 153, l_chr CLIPPED,                                                          
#                COLUMN 156, cl_numfor(l_amt_1,12,g_azi04) CLIPPED  
#
#      SELECT SUM(abb07) INTO s_total1 FROM abb_file,aba_file
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[1].aag AND aba19='Y' AND abapost='Y'
#      SELECT SUM(abb07) INTO s_total2 FROM abb_file,aba_file                                                                        
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[2].aag AND aba19='Y' AND abapost='Y'
#      SELECT SUM(abb07) INTO s_total3 FROM abb_file,aba_file                                                                        
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[3].aag AND aba19='Y' AND abapost='Y'
#      SELECT SUM(abb07) INTO s_total4 FROM abb_file,aba_file                                                                        
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[4].aag AND aba19='Y' AND abapost='Y'
#      SELECT SUM(abb07) INTO s_total5 FROM abb_file,aba_file                                                                        
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[5].aag AND aba19='Y' AND abapost='Y'
#      SELECT SUM(abb07) INTO s_total6 FROM abb_file,aba_file                                                                        
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[6].aag AND aba19='Y' AND abapost='Y'
#      SELECT SUM(abb07) INTO s_total7 FROM abb_file,aba_file                                                                        
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[7].aag AND aba19='Y' AND abapost='Y'
#      SELECT SUM(abb07) INTO s_total8 FROM abb_file,aba_file                                                                        
#       WHERE abb00=aba00 AND abb01=aba01 AND aba03=sr.YY AND aba04<=sr.MM 
#         AND abb03=g_ary[8].aag AND aba19='Y' AND abapost='Y'
#         
#      IF s_total1 IS NULL THEN LET s_total1=0 END IF                                                                                
#      IF s_total2 IS NULL THEN LET s_total2=0 END IF                                                                                
#      IF s_total3 IS NULL THEN LET s_total3=0 END IF                                                                                
#      IF s_total4 IS NULL THEN LET s_total4=0 END IF                                                                                
#      IF s_total5 IS NULL THEN LET s_total5=0 END IF                                                                                
#      IF s_total6 IS NULL THEN LET s_total6=0 END IF                                                                                
#      IF s_total7 IS NULL THEN LET s_total7=0 END IF                                                                                
#      IF s_total8 IS NULL THEN LET s_total8=0 END IF   
#   
#      PRINT COLUMN 021,g_x[2] CLIPPED;
#          PRINT COLUMN 049, cl_numfor(s_total1,11,g_azi04) CLIPPED,                                                                 
#                COLUMN 061, cl_numfor(s_total2,11,g_azi04) CLIPPED,                                                                 
#                COLUMN 075, cl_numfor(s_total3,11,g_azi04) CLIPPED,                                                                 
#                COLUMN 088, cl_numfor(s_total4,11,g_azi04) CLIPPED,                                                                 
#                COLUMN 101, cl_numfor(s_total5,11,g_azi04) CLIPPED,                                                                 
#                COLUMN 114, cl_numfor(s_total6,11,g_azi04) CLIPPED,                                                                 
#                COLUMN 127, cl_numfor(s_total7,11,g_azi04) CLIPPED,                                                                 
#                COLUMN 140, cl_numfor(s_total8,11,g_azi04) CLIPPED, 
#                COLUMN 153, l_chr CLIPPED,                                                                
#                COLUMN 156, cl_numfor(l_amt_1,12,g_azi04) CLIPPED   
#
#
#      LET l_bal=l_amt_1
#
#
#      LET l_last_sw = 'y'
#      LET l_amt_1=0
#      LET l_amt_2=0
#      LET l_total1=0
#      LET l_total2=0
#      LET l_total3=0
#      LET l_total4=0
#      LET l_total5=0
#      LET l_total6=0
#      LET l_total7=0
#      LET l_total8=0
#      LET g_bal[1]=0
#      LET g_bal[2]=0
#      LET g_bal[3]=0
#      LET g_bal[4]=0
#      LET g_bal[5]=0
#      LET g_bal[6]=0
#      LET g_bal[7]=0
#      LET g_bal[8]=0
#   END IF
#END REPORT
#No.FUN-7C0064  --End  
 
FUNCTION duplicate(l_aag)     #檢查輸入之工廠編號是否重覆
   DEFINE l_aag      LIKE aag_file.aag01
   DEFINE l_idx, n   LIKE type_file.num10   #INTEGER
 
   FOR l_idx = 1 TO n
       IF g_ary[l_idx].aag = l_aag THEN
          LET l_aag = ''
       END IF
   END FOR
   RETURN l_aag
END FUNCTION

###GENGRE###START
FUNCTION gglg406_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gglg406")
        IF handler IS NOT NULL THEN
            START REPORT gglg406_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE gglg406_datacur1 CURSOR FROM l_sql
            FOREACH gglg406_datacur1 INTO sr1.*
                OUTPUT TO REPORT gglg406_rep(sr1.*)
            END FOREACH
            FINISH REPORT gglg406_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gglg406_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno          LIKE type_file.num5
    #FUN-B40087-----------add--------str-----
    DEFINE l_abb07_1         LIKE abb_file.abb07
    DEFINE l_abb07_2         LIKE abb_file.abb07
    DEFINE l_abb07_3         LIKE abb_file.abb07
    DEFINE l_abb07_4         LIKE abb_file.abb07
    DEFINE l_abb07_5         LIKE abb_file.abb07
    DEFINE l_abb07_6         LIKE abb_file.abb07
    DEFINE l_abb07_7         LIKE abb_file.abb07
    DEFINE l_abb07_8         LIKE abb_file.abb07
    DEFINE l_b_bal_1         LIKE type_file.num20_6
    DEFINE l_b_bal_2         LIKE type_file.num20_6
    DEFINE l_bal_1           LIKE type_file.num20_6
    DEFINE l_bal_2           LIKE type_file.num20_6
    DEFINE l_bal_3           LIKE type_file.num20_6
    DEFINE l_bal_4           LIKE type_file.num20_6
    DEFINE l_bal_5           LIKE type_file.num20_6
    DEFINE l_bal_6           LIKE type_file.num20_6
    DEFINE l_bal_7           LIKE type_file.num20_6
    DEFINE l_bal_8           LIKE type_file.num20_6
    DEFINE l_h1              LIKE type_file.chr4
    DEFINE l_chr1            STRING
    DEFINE l_chr2            STRING 
    DEFINE l_e_abb07         LIKE type_file.num20_6
    DEFINE l_e_abb07_1       LIKE type_file.num20_6
    DEFINE l_bal_e1_1        LIKE abb_file.abb07
    DEFINE l_bal_e2_1        LIKE abb_file.abb07    
    DEFINE l_bal_e1          LIKE abb_file.abb07
    DEFINE l_bal_e2          LIKE abb_file.abb07
    DEFINE l_ary             RECORD 
                             a      LIKE aag_file.aag02,
                             b      LIKE aag_file.aag02,
                             c      LIKE aag_file.aag02,
                             d      LIKE aag_file.aag02,
                             e      LIKE aag_file.aag02,
                             f      LIKE aag_file.aag02,
                             g      LIKE aag_file.aag02,
                             h      LIKE aag_file.aag02
                             END RECORD
           
    DEFINE l_abb07_1_sum   LIKE abb_file.abb07
    DEFINE l_abb07_2_sum   LIKE abb_file.abb07
    DEFINE l_abb07_3_sum   LIKE abb_file.abb07
    DEFINE l_abb07_4_sum   LIKE abb_file.abb07
    DEFINE l_abb07_5_sum   LIKE abb_file.abb07
    DEFINE l_abb07_6_sum   LIKE abb_file.abb07
    DEFINE l_abb07_7_sum   LIKE abb_file.abb07
    DEFINE l_abb07_8_sum   LIKE abb_file.abb07

    DEFINE l_bal1 LIKE type_file.num10
    DEFINE l_bal2 LIKE type_file.num10
    DEFINE l_bal3 LIKE type_file.num10
    DEFINE l_bal4 LIKE type_file.num10
    DEFINE l_bal5 LIKE type_file.num10
    DEFINE l_bal6 LIKE type_file.num10
    DEFINE l_bal7 LIKE type_file.num10
    DEFINE l_bal8 LIKE type_file.num10

    DEFINE l_y_1  LIKE type_file.num10
    DEFINE l_y_2  LIKE type_file.num10
    DEFINE l_y_3  LIKE type_file.num10
    DEFINE l_y_4  LIKE type_file.num10
    DEFINE l_y_5  LIKE type_file.num10
    DEFINE l_y_6  LIKE type_file.num10
    DEFINE l_y_7  LIKE type_file.num10
    DEFINE l_y_8  LIKE type_file.num10
    #FUN-B40087------------add-------------end-----------
    
    ORDER EXTERNAL BY sr1.month
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.month
            LET l_ary.a = g_ary[1].aag02
            LET l_ary.b = g_ary[2].aag02
            LET l_ary.c = g_ary[3].aag02
            LET l_ary.d = g_ary[4].aag02
            LET l_ary.e = g_ary[5].aag02
            LET l_ary.f = g_ary[6].aag02
            LET l_ary.g = g_ary[7].aag02
            LET l_ary.h = g_ary[8].aag02
            PRINTX l_ary.*
            LET l_lineno = 0
            #FUN-B40087-----------add--------str-----
            IF sr1.ps = '1' THEN
               LET l_bal1 = sr1.bal
            ELSE 
               LET l_bal1 = 0
            END IF 
            PRINTX l_bal1

            IF sr1.ps = '2' THEN
               LET l_bal2 = sr1.bal
            ELSE
               LET l_bal2 = 0
            END IF
            PRINTX l_bal2

            IF sr1.ps = '3' THEN
               LET l_bal3 = sr1.bal
            ELSE
               LET l_bal3 = 0
            END IF
            PRINTX l_bal3
   
            IF sr1.ps = '4' THEN
               LET l_bal4 = sr1.bal
            ELSE
               LET l_bal4 = 0
            END IF
            PRINTX l_bal4

            IF sr1.ps = '5' THEN
               LET l_bal5 = sr1.bal
            ELSE
               LET l_bal5 = 0
            END IF
            PRINTX l_bal5

            IF sr1.ps = '6' THEN
               LET l_bal6 = sr1.bal
            ELSE
               LET l_bal6 = 0
            END IF
            PRINTX l_bal6

            IF sr1.ps = '7' THEN
               LET l_bal7 = sr1.bal
            ELSE
               LET l_bal7 = 0
            END IF
            PRINTX l_bal7

            IF sr1.ps = '8' THEN
               LET l_bal8 = sr1.bal
            ELSE
               LET l_bal8 = 0
            END IF
            PRINTX l_bal8

            LET l_bal_1 = g_bal[1]
            PRINTX l_bal_1
            LET l_bal_2 = g_bal[2]
            PRINTX l_bal_2
            LET l_bal_3 = g_bal[3]
            PRINTX l_bal_3
            LET l_bal_4 = g_bal[4]
            PRINTX l_bal_4
            LET l_bal_5 = g_bal[5] *(-1)
            PRINTX l_bal_5
            LET l_bal_6 = g_bal[6] *(-1)
            PRINTX l_bal_6
            LET l_bal_7 = g_bal[7] *(-1)
            PRINTX l_bal_7
            LET l_bal_8 = g_bal[8] *(-1)
            PRINTX l_bal_8
 
            LET l_b_bal_1 = l_bal_1 + l_bal_2 + l_bal_3 + l_bal_4 -l_bal_5 - l_bal_6 - l_bal_7 - l_bal_8
            PRINTX l_b_bal_1
            IF l_b_bal_1 > 0 THEN  
               LET l_b_bal_2 = l_b_bal_1
            ELSE
               LET l_b_bal_2 = l_b_bal_1 *(-1)
            END IF 
            PRINTX l_b_bal_2
          
            LET l_h1 = sr1.year
            PRINTX l_h1

            IF l_b_bal_1 >0 THEN
               LET l_chr1 = cl_gr_getmsg("gre-30",g_lang,'1')
            ELSE IF l_bal_1 < 0 THEN
                    LET l_chr1 = cl_gr_getmsg("gre-30",g_lang,'2')
                 ELSE
                    LET l_chr1 = cl_gr_getmsg("gre-30",g_lang,'3')
                 END IF
            END IF
            PRINTX l_chr1
            
            
            #FUN-B40087-----------add--------end-----

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.month
            #FUN-B40087-----------add--------str-------

            LET l_bal_e1_1 = GROUP SUM(sr1.bal_e1)
            IF cl_null(l_bal_e1_1) THEN
               LET l_bal_e1_1 = 0
            END IF
            PRINTX l_bal_e1_1
            LET l_bal_e2_1 = GROUP SUM(sr1.bal_e2)
            IF cl_null(l_bal_e2_1) THEN
               LET l_bal_e2_1 = 0
            END IF
            PRINTX l_bal_e2_1

            LET l_e_abb07 = l_bal_e1_1 - l_bal_e2_1 + l_b_bal_1
            PRINTX l_e_abb07
            IF l_e_abb07 < 0 THEN
               LET l_e_abb07_1 = l_e_abb07 * (-1)
            ELSE
               LET l_e_abb07_1 = l_e_abb07
            END IF
            PRINTX l_e_abb07_1 

 
            IF l_e_abb07 >0 THEN
               LET l_chr1 = cl_gr_getmsg("gre-30",g_lang,'1')
            ELSE IF l_e_abb07 < 0 THEN
                    LET l_chr2 = cl_gr_getmsg("gre-30",g_lang,'2')
                 ELSE
                    LET l_chr2 = cl_gr_getmsg("gre-30",g_lang,'3')
                 END IF
            END IF
            PRINTX l_chr2

            LET l_abb07_1_sum =  GROUP SUM(sr1.abb07_1)
            LET l_abb07_2_sum =  GROUP SUM(sr1.abb07_2)
            LET l_abb07_3_sum =  GROUP SUM(sr1.abb07_3)
            LET l_abb07_4_sum =  GROUP SUM(sr1.abb07_4)
            LET l_abb07_5_sum =  GROUP SUM(sr1.abb07_5)
            LET l_abb07_6_sum =  GROUP SUM(sr1.abb07_6)
            LET l_abb07_7_sum =  GROUP SUM(sr1.abb07_7)
            LET l_abb07_8_sum =  GROUP SUM(sr1.abb07_8)


            LET l_y_1 = l_abb07_1_sum + l_bal1
            LET l_y_2 = l_abb07_2_sum + l_bal2
            LET l_y_3 = l_abb07_3_sum + l_bal3
            LET l_y_4 = l_abb07_4_sum + l_bal4
            LET l_y_5 = l_abb07_5_sum + l_bal5
            LET l_y_6 = l_abb07_6_sum + l_bal6
            LET l_y_7 = l_abb07_7_sum + l_bal7
            LET l_y_8 = l_abb07_8_sum + l_bal8

            PRINTX l_abb07_1_sum
            PRINTX l_abb07_2_sum
            PRINTX l_abb07_3_sum
            PRINTX l_abb07_4_sum
            PRINTX l_abb07_5_sum
            PRINTX l_abb07_6_sum
            PRINTX l_abb07_7_sum
            PRINTX l_abb07_8_sum
            PRINTX l_y_1       
            PRINTX l_y_2
            PRINTX l_y_3
            PRINTX l_y_4
            PRINTX l_y_5
            PRINTX l_y_6
            PRINTX l_y_7
            PRINTX l_y_8
            #FUN-B40087----------add----------end------------

        
        ON LAST ROW

END REPORT
###GENGRE###END
