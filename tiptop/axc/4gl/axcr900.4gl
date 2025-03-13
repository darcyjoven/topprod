# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: axcr900.4gl
# Descriptions...: 平均單價比較表 
# Date & Author..: NO.FUN-770023 07/07/11 By rainy
# Mofify.........: No.FUN-7C0101 08/01/25 By lala
# Modify.........: No.CHI-870021 08/07/11 By Smapmin 修改程式名稱
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0053 10/11/26 By sabrina 報表跑不出資料
# Modify.........: No:CHI-C30012 12/07/30 By bart 金額取位改抓ccz26

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,       # Where condition
              more    LIKE type_file.chr1,           # Input more condition(Y/N)
              type      LIKE type_file.chr1       #FUN-7C0101
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_str           STRING                                                                                  
DEFINE   g_sql           STRING                                                                                  
DEFINE   l_table         STRING                                                                                  
 
#FUN-770023
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET g_sql = "imm02.imm_file.imm02,",
               "imm01.imm_file.imm01,",
               "imn02.imn_file.imn02,",
               "imn03.imn_file.imn03,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "ccc08.ccc_file.ccc08,",              #No:MOD-9C0053 add
               "ccc23.ccc_file.ccc23,",
               "imn10.imn_file.imn10,",
               "amt1.type_file.num20_6,",
               "cxk04.cxk_file.cxk04,",
               "amt2.type_file.num20_6,",
               "diff.type_file.num20_6"
   LET l_table = cl_prt_temptable('axcr900',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"         #MOD-9C0053 add                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
 
 
 
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.bdate = ARG_VAL(8)
  #LET tm.edate = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET tm.type = ARG_VAL(11)              #FUN-7C0101
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
  
   IF cl_null(g_bgjob) or g_bgjob = 'N'
      THEN CALL axcr900_tm(0,0)
      ELSE CALL axcr900()
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
 
FUNCTION axcr900_tm(p_row,p_col)
  DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
  DEFINE p_row,p_col    LIKE type_file.num5,         
         l_cmd          LIKE type_file.chr1000       
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW axcr900_w AT p_row,p_col WITH FORM "axc/42f/axcr900" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.type = g_ccz.ccz28          #No.FUN-7C0101
   LET tm.more= 'N'
   LET g_pdate= g_today
   LET g_rlang= g_lang
   LET g_bgjob= 'N'
   LET g_copies= '1'
 
 WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON imm02,imn03
     BEFORE CONSTRUCT
       CALL cl_qbe_init()
 
     ON ACTION locale
        CALL cl_show_fld_cont()                  
        LET g_action_choice = "locale"
        EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION controlp                                                      
        IF INFIELD(imn03) THEN                                              
           CALL cl_init_qry_var()                                           
           LET g_qryparam.form = "q_ima"                                    
           LET g_qryparam.state = "c"                                       
           CALL cl_create_qry() RETURNING g_qryparam.multiret               
           DISPLAY g_qryparam.multiret TO imn03                             
           NEXT FIELD imn03                                                 
        END IF                                                              
 
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
     ON ACTION qbe_save
        CALL cl_qbe_save()
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup') #FUN-980030
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axcr900_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
#No.FUN-7C0101 -- begin --
   INPUT BY NAME tm.type WITHOUT DEFAULTS 
   AFTER FIELD type                                          
         IF tm.type NOT MATCHES '[12345]' THEN NEXT FIELD type END IF
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
   ON ACTION CONTROLG CALL cl_cmdask()
      
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT
 
   ON ACTION about 
      CALL cl_about()
 
   ON ACTION help
      CALL cl_show_help()
 
   
   ON ACTION exit
      LET INT_FLAG = 1
   EXIT INPUT
 
   ON ACTION qbe_save
      CALL cl_qbe_save()
   END INPUT 
#No.FUN-7C0101 -- end --
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axcr900'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('axcr900','9031',1)   
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'",
                     #" '",tm.bdate CLIPPED,"'",
                     #" '",tm.edate CLIPPED,"'",
                     " '",g_rep_user CLIPPED,"'",           
                     " '",g_rep_clas CLIPPED,"'",           
                     " '",g_template CLIPPED,"'"            
 
         CALL cl_cmdat('axcr900',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axcr900_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axcr900()
   ERROR ""
END WHILE
   CLOSE WINDOW axcr900_w
END FUNCTION
 
FUNCTION axcr900()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name
          #l_sql     LIKE type_file.chr1000,
          l_sql     STRING,    #NO.FUN-910082       
          l_chr     LIKE type_file.chr1,          
          l_za05    LIKE type_file.chr1000,        
          l_yy,l_mm LIKE type_file.num5,           
          sr               RECORD imm02   LIKE imm_file.imm02,   #單據日期
                                  imm01   LIKE imm_file.imm01,   #單據編號
                                  imn02   LIKE imn_file.imn02,   #項次
                                  imn03   lIKE imn_file.imn03,   #料號
                                  ima02   LIKE ima_file.ima02,   #品名
                                  ima021  LIKE ima_file.ima021,  #規
                                  ccc08   LIKE ccc_file.ccc08,   #FUN-7C0101
                                  ccc23   LIKE ccc_file.ccc23,   #本月份諝[權單價
                                  imn10   LIKE imn_file.imn10,   #撥出數量
                                  amt1    LIKE imn_file.imn092,  #撥出金額
                                  cxk04   LIKE cxk_file.cxk04,   #轉撥單價
                                  amt2    LIKE imn_file.imn092,  #轉撥
                                  diff    LIKE imn_file.imn092   #差異金額
                        END RECORD
     CALL cl_del_data(l_table)
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT imm02,imm01,imn02,imn03,ima02,ima021,'',",     #MOD-9C0053 add ''
                 "       0,imn10,0,0,0,0 ", 
                 "  FROM imm_file,imn_file,ima_file,smy_file",
                 " WHERE imm01 like ltrim(rtrim(smyslip)) || '-%' ",
                 "   AND UPPER(smysys) = 'AIM' ",
                 "   AND smykind = '4'",#調撥
                #"   AND smydmy2 = '3'",#雜發      #MOD-9C0053 mark
                 "   AND smydmy2 = '4'",           #MOD-9C0053 add
                 "   AND imm01 = imn01",
                 "   AND imn03 = ima01",
                 "   AND ",tm.wc CLIPPED
 
     PREPARE axcr900_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM 
     END IF
     DECLARE axcr900_curs1 CURSOR FOR axcr900_prepare1
 
     LET g_pageno = 0
     FOREACH axcr900_curs1 INTO sr.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET l_yy = YEAR(sr.imm02)
       LET l_mm = MONTH(sr.imm02)
       SELECT ccc08,ccc23 INTO sr.ccc08,sr.ccc23          #FUN-7C0101
         FROM ccc_file
        WHERE ccc01 = sr.imn03
          AND ccc02 = l_yy
          AND ccc03 = l_mm
          AND ccc07 = tm.type                             #FUN-7C0101
       IF SQLCA.sqlcode THEN 
          LET sr.ccc23 = 0 
       END IF
       SELECT cxk04 INTO sr.cxk04 FROM cxk_file
        WHERE cxk01 = sr.imn03 
       LET sr.amt1 = sr.ccc23 * sr.imn10
       LET sr.amt2 = sr.cxk04 * sr.imn10
       LET sr.diff = (sr.ccc23-sr.cxk04) * sr.imn10
       
       EXECUTE insert_prep USING                                                                                                  
                 sr.imm02,sr.imm01,sr.imn02,sr.imn03,sr.ima02,sr.ima021,sr.ccc08,      #FUN-7C0101
                 sr.ccc23,sr.imn10,sr.amt1, sr.cxk04,sr.amt2, sr.diff                                                                            
    END FOREACH
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(tm.wc,'imm02,imn03')
            RETURNING g_str
    ELSE
       LET g_str = " "
    END IF
    LET g_str = g_str,";",g_ccz.ccz27,";",g_ccz.ccz26 #CHI-C30012
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #CALL cl_prt_cs3('axcr900','axcr900',l_sql,g_str)     #FUN-7C0101
#No.FUN-7C0101-------------BEGIN-----------------                                                          
   IF tm.type MATCHES '[12]' THEN
      CALL cl_prt_cs3('axcr900','axcr900_1',l_sql,g_str)
   END IF
   IF tm.type MATCHES '[345]' THEN
      CALL cl_prt_cs3('axcr900','axcr900',l_sql,g_str)
   END IF
#No.FUN-7C0101--------------END------------------
END FUNCTION
#CHI-870021
