# Prog. Version..: '5.30.07-13.05.16(00002)'     #
#
# Pattern name...: gnmx620.4gl
# Descriptions...: 應收/付票據月底重評價資料列印
# Date & Author..: 03/06/13 By danny
# Modify.........: No:7952 03/09/01 By Wiky 修改匯率
# Modify.........: No.FUN-520004 05/03/04 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-550057 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.FUN-580110 05/08/23 By vivien 報表轉XML格式
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680145 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-850005 08/05/06 By Sunyanchun  老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80038 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-D40020 12/12/24 By wangrr CR轉xtragrid
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc      VARCHAR(1000),            # Where condition
	      wc      STRING,
              a       LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(01) 
              b       LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(01)
              more    LIKE type_file.chr1    # Prog. Version..: '5.30.07-13.05.16(01)   # Input more condition(Y/N)
              END RECORD,
          yy,m1,m2    LIKE type_file.num10,  #NO FUN-680145 INTEGER
          y1,mm       LIKE type_file.num10,  #NO FUN-680145 INTEGER
          g_bookno    LIKE aaa_file.aaa01,	
          g_aaa03     LIKE aaa_file.aaa03,	
          g_aaz64     LIKE aaz_file.aaz64	
 
DEFINE   g_i          LIKE type_file.chr1     #NO FUN-680145 SMALLINT  #count/index for any purpose
DEFINE   g_str        STRING    #NO.FUN-850005
DEFINE   l_table      STRING    #NO.FUN-850005
DEFINE   l_table1      STRING    #NO.FUN-850005
DEFINE   l_table2      STRING    #NO.FUN-850005
DEFINE   l_table3      STRING    #NO.FUN-850005
DEFINE   g_sql         STRING    #NO.FUN-850005
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
 
   #NO.FUN-850005----BEGIN-----
   LET g_sql = "oox01.oox_file.oox01,",
               "oox02.oox_file.oox02,",
               "oox03.oox_file.oox03,",
               "oox05.oox_file.oox05,",
               "oox07.oox_file.oox07,",
               "oox08.oox_file.oox08,",
               "oox09.oox_file.oox09,",
               "oox10.oox_file.oox10,",
               "azi07.azi_file.azi07,",
               "azi05.azi_file.azi05"
   LET l_table = cl_prt_temptable('gnmx620',g_sql)
   IF l_table =-1 THEN EXIT PROGRAM END IF
 
   LET l_table1 = cl_prt_temptable('gnmx620_1',g_sql)
   IF l_table1 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "oox01.oox_file.oox01,",
               "oox02.oox_file.oox02,",
               "oox05.oox_file.oox05,",
               "oox10.oox_file.oox10,",
               "azi05.azi_file.azi05"
   LET l_table2 = cl_prt_temptable('gnmx620_2',g_sql)                              
   IF l_table2 = -1 THEN EXIT PROGRAM END IF                                      
                                                                                
   LET l_table3 = cl_prt_temptable('gnmx620_3',g_sql)                           
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
   #NO.FUN-850005----END------
 
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)
   LET yy  = ARG_VAL(11)   #TQC-610056
   LET m1  = ARG_VAL(12)   #TQC-610056
   LET m2  = ARG_VAL(13)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   #No.FUN-570264 ---end---
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz64
   END IF
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF #使用本國幣別
  #SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03   #No.CHI-6A0004
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80038--add-- 
   IF NOT cl_null(tm.wc) THEN
      CALL gnmx620()
   ELSE
      CALL gnmx620_tm(0,0)
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
END MAIN
 
FUNCTION gnmx620_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000#NO FUN-680145 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 24
 
   OPEN WINDOW gnmx620_w AT p_row,p_col WITH FORM "gnm/42f/gnmx620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = g_today
   INITIALIZE tm.* TO NULL            # Default condition
   LET yy      = y1
   LET m1      = mm
   LET m2      = mm
   LET tm.a    = '1'
   LET tm.b    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oox03,oox03v
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
         LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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

     #No.FUN-D40020 ---start---   Add
      ON ACTION controlp
         CASE
            WHEN INFIELD(oox03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oox03"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "oox00 IN('AR','AP')"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oox03
               NEXT FIELD oox03
            WHEN INFIELD(oox03v)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oox03v"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "oox00 IN('AR','AP')"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oox03v
               NEXT FIELD oox03v
            OTHERWISE EXIT CASE
         END CASE
     #No.FUN-D40020 ---start---   Add
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME yy,m1,m2,tm.a,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
        IF cl_null(yy) THEN NEXT FIELD yy END IF
 
      AFTER FIELD m1
#No.TQC-720032 -- begin --
         IF NOT cl_null(m1) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF m1 > 12 OR m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            ELSE
               IF m1 > 13 OR m1 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m1
               END IF
            END IF
         END IF
#        IF cl_null(m1) OR m1 <= 0 OR m1 > 13 THEN NEXT FIELD m1 END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD m2
#No.TQC-720032 -- begin --
         IF NOT cl_null(m2) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = yy
            IF g_azm.azm02 = 1 THEN
               IF m2 > 12 OR m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            ELSE
               IF m2 > 13 OR m2 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD m2
               END IF
            END IF
         END IF
#        IF cl_null(m2) OR m2 <= 0 OR m2 > 13 THEN NEXT FIELD m2 END IF
#No.TQC-720032 -- end --
 
      AFTER FIELD a
        IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN NEXT FIELD a END IF
 
      AFTER FIELD b
        IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN NEXT FIELD b END IF
 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gnmx620'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gnmx620','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno  CLIPPED,"'",   #TQC-610056
                         " '",g_pdate  CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang   CLIPPED,"'",
                         " '",g_bgjob  CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc    CLIPPED,"'" ,
                         " '",tm.a     CLIPPED,"'" ,
                         " '",tm.b     CLIPPED,"'" ,
                        " '",yy  CLIPPED,"'"  ,   #TQC-610056
                        " '",m1  CLIPPED,"'"  ,   #TQC-610056
                        " '",m2  CLIPPED,"'"  ,   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('gnmx620',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gnmx620_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gnmx620()
   ERROR ""
END WHILE
   CLOSE WINDOW gnmx620_w
END FUNCTION
 
FUNCTION gnmx620()
   DEFINE l_name    LIKE type_file.chr20,   #NO FUN-680145 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0098
          l_sql     LIKE type_file.chr1000, #NO FUN-680145 VARCHAR(1000)
          sr        RECORD
                       oox01   LIKE  oox_file.oox01,
                       oox02   LIKE  oox_file.oox02,
                       oox03   LIKE  oox_file.oox03,
                       oox05   LIKE  oox_file.oox05,
                       oox07   LIKE  oox_file.oox07,
                       oox08   LIKE  oox_file.oox08,
                       oox09   LIKE  oox_file.oox09,
                       oox10   LIKE  oox_file.oox10
                    END RECORD,
          l_za05    LIKE type_file.chr1000   #NO FUN-680145 VARCHAR(40)
     #NO.FUN-850005---BEGIN---
     DEFINE gum        RECORD
                          oox05   LIKE  oox_file.oox05,
                          oox10   LIKE  oox_file.oox10
                       END RECORD
     DEFINE t_azi04      LIKE azi_file.azi04 
     DEFINE t_azi05      LIKE azi_file.azi05
     DEFINE t_azi05_1    LIKE azi_file.azi05
     #NO.FUN-850005---END---
    
#     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098 #No.FUN-B80038---mark---
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
     #NO.FUN-850005---BEGIN-----
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                                                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM                                                                                                                 
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,            
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"                          
     PREPARE insert_prep1 FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep1:',status,1)                                    
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM                                                            
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,            
               " VALUES(?, ?, ?, ?, ?)"                          
     PREPARE insert_prep2 FROM g_sql                                             
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep2:',status,1)                                    
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM                                                            
     END IF
    
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,           
               " VALUES(?, ?, ?, ?, ?)"                                         
     PREPARE insert_prep3 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep3:',status,1)                                   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM                                                            
     END IF
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     #NO.FUN-850005---END------
     LET l_sql="SELECT oox01,oox02,'',oox05,oox07,SUM(oox08),SUM(oox09),SUM(oox10)",
               "  FROM oox_file ",
                " WHERE oox01 = ",yy,
                "   AND oox02 BETWEEN ",m1," AND ",m2,
                "   AND ",tm.wc CLIPPED
     IF tm.a = '1' THEN     #應收票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NR' "
     ELSE                   #應付票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NP' "
     END IF
     LET l_sql = l_sql CLIPPED,
                 " GROUP BY oox01,oox02,oox05,oox07 ORDER BY 1,2,3,5 "
     PREPARE gnmx620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmx620_curs1 CURSOR FOR gnmx620_prepare1
 
     LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
               " WHERE oox01 = ?",
                "   AND oox02 BETWEEN ",m1," AND ",m2,
                "   AND ",tm.wc CLIPPED
     IF tm.a = '1' THEN     #應收票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NR' "
     ELSE                   #應付票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NP' "
     END IF
     LET l_sql = l_sql CLIPPED," GROUP BY oox05 ORDER BY oox05"
     PREPARE gnmx620_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmx620_curs3 CURSOR FOR gnmx620_prepare3
 
     LET l_sql="SELECT oox01,oox02,oox03,oox05,oox07,oox08,",
                "       oox09,oox10 ",
                "  FROM oox_file ",
                " WHERE oox01 = ",yy,
                "   AND oox02 BETWEEN ",m1," AND ",m2,
                "   AND ",tm.wc CLIPPED
     IF tm.a = '1' THEN     #應收票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NR' "
     ELSE                   #應付票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NP' "
     END IF
     LET l_sql = l_sql CLIPPED," ORDER BY 1,2,6,4 "
     PREPARE gnmx620_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add-- 
        EXIT PROGRAM
     END IF
     DECLARE gnmx620_curs2 CURSOR FOR gnmx620_prepare2
 
     LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
               " WHERE oox01 = ?",
               "   AND oox02 = ?",
               "   AND ",tm.wc CLIPPED
     IF tm.a = '1' THEN     #應收票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NR' "
     ELSE                   #應付票據
        LET l_sql = l_sql CLIPPED," AND oox00 = 'NP' "
     END IF
     LET l_sql = l_sql CLIPPED," GROUP BY oox05 ORDER BY oox05"
     PREPARE gnmx620_prepare4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare4:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmx620_curs4 CURSOR FOR gnmx620_prepare4
 
    #CALL cl_outnam('gnmx620') RETURNING l_name    #No.FUN-D40020
#NO.FUN-850005----BEGIN---------- 
#No.FUN-580110 --start
#    IF tm.b = '1' THEN              #統計報表
#       LET g_zaa[31].zaa06 = "N"
#       LET g_zaa[32].zaa06 = "N"
#       LET g_zaa[33].zaa06 = "N"
#       LET g_zaa[34].zaa06 = "N"
#       LET g_zaa[35].zaa06 = "Y"
#       LET g_zaa[36].zaa06 = "Y"
#       LET g_zaa[37].zaa06 = "Y"
#       LET g_zaa[38].zaa06 = "Y"
#    ELSE
#       IF tm.a='1' THEN
#          LET g_zaa[31].zaa06 = "Y"
#          LET g_zaa[32].zaa06 = "Y"
#          LET g_zaa[33].zaa06 = "Y"
#          LET g_zaa[34].zaa06 = "Y"
#          LET g_zaa[35].zaa06 = "N"
#          LET g_zaa[36].zaa06 = "N"
#          LET g_zaa[37].zaa06 = "N"
#          LET g_zaa[38].zaa06 = "Y"
#       ELSE
#          LET g_zaa[31].zaa06 = "Y"
#          LET g_zaa[32].zaa06 = "Y"
#          LET g_zaa[33].zaa06 = "Y"
#          LET g_zaa[34].zaa06 = "Y"
#          LET g_zaa[35].zaa06 = "N"
#          LET g_zaa[36].zaa06 = "N"
#          LET g_zaa[37].zaa06 = "Y"
#          LET g_zaa[38].zaa06 = "N"
#       END IF
#    END IF
#    CALL cl_prt_pos_len()
#No.FUN-580110 --end
#NO.FUN-850005----END-----
#No.FUN-580110 --start
#        START REPORT gnmx620_rep TO l_name
 
#    LET g_pageno = 0
     IF tm.b='1' THEN
        FOREACH gnmx620_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           #NO.FUN-850005----BEGIN-----
           SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file  #No.CHI-6A0004
                WHERE azi01=sr.oox05
           IF SQLCA.sqlcode THEN
               LET t_azi04 = g_azi04
               LET t_azi05 = g_azi05 
               LET t_azi07 = g_azi07
           END IF
           FOREACH gnmx620_curs3 USING sr.oox01 INTO gum.*
              SELECT azi05 INTO t_azi05_1 FROM azi_file 
                   WHERE azi01=gum.oox05
              IF SQLCA.sqlcode THEN
                 LET t_azi05 = g_azi05 
              END IF
              EXECUTE insert_prep2 USING sr.oox01,sr.oox02,gum.oox05,
                                         gum.oox10,t_azi05_1
           END FOREACH
          #EXECUTE insert_prep USING sr.oox01,sr.oox02,sr.oox05,sr.oox05,   #No.FUN-D40020   Mark
           EXECUTE insert_prep USING sr.oox01,sr.oox02,sr.oox03,sr.oox05,   #No.FUN-D40020   Add
                                     sr.oox07,sr.oox08,sr.oox09,sr.oox10,
                                     t_azi07,t_azi05
           #OUTPUT TO REPORT gnmx620_rep(sr.*)
           #NO.FUN-850005-----BEGIN-------
        END FOREACH
     ELSE
        FOREACH gnmx620_curs2 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
           END IF
           SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file  #No.CHI-6A0004
                WHERE azi01=sr.oox05
           IF SQLCA.sqlcode THEN
              LET t_azi04 = g_azi04
              LET t_azi05 = g_azi05 
              LET t_azi07 = g_azi07
          END IF
          FOREACH gnmx620_curs4 USING sr.oox01,sr.oox02 INTO gum.*
             SELECT azi05 INTO t_azi05_1 FROM azi_file
                 WHERE azi01=gum.oox05
             IF SQLCA.sqlcode THEN
                LET t_azi05 = g_azi05 
             END IF
             EXECUTE insert_prep3 USING sr.oox01,sr.oox02,gum.oox05,           
                                        gum.oox10,t_azi05_1
          END FOREACH
         #EXECUTE insert_prep1 USING sr.oox01,sr.oox02,sr.oox05,sr.oox05,   #No.FUN-D40020   Mark
          EXECUTE insert_prep1 USING sr.oox01,sr.oox02,sr.oox03,sr.oox05,   #No.FUN-D40020   Add
                                     sr.oox07,sr.oox08,sr.oox09,sr.oox10,       
                                     t_azi07,t_azi05
          #OUTPUT TO REPORT gnmx620_rep(sr.*)
        END FOREACH
     END IF
     #NO.FUN-850005----BEGIN----
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'oox03')
            RETURNING tm.wc
     ELSE
        LET tm.wc=""
     END IF
###XtraGrid###     LET g_str = tm.wc,";",tm.b,";",tm.a
     #FUN-D40020--add--str--
     IF tm.a='1' THEN
        LET g_xgrid.title2=cl_getmsg('gnm-002',g_lang)
     ELSE
        LET g_xgrid.title2=cl_getmsg('gnm-003',g_lang)
     END IF
     LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
     #FUN-D40020--add--end
     IF tm.b = '1' THEN
###XtraGrid###        LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
###XtraGrid###                    "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
###XtraGrid###        CALL cl_prt_cs3('gnmx620','gnmx620',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.template = 'gnmx620'        #FUN-D40020
    LET g_xgrid.grup_field = "oox02,oox05"  #FUN-D40020
    CALL cl_xg_view()    ###XtraGrid###
     ELSE
       #LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|", #FUN-D40020 mark
       #            "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED      #FUN-D40020 mark
       IF tm.a = '1' THEN
###XtraGrid###           CALL cl_prt_cs3('gnmx620','gnmx620_1',g_sql,g_str)
    LET g_xgrid.table = l_table1        #FUN-D40020
    LET g_xgrid.template = 'gnmx620_1'  #FUN-D40020
    LET g_xgrid.grup_field = "oox05"    #FUN-D40020
    CALL cl_xg_view()    ###XtraGrid###
        ELSE
###XtraGrid###           CALL cl_prt_cs3('gnmx620','gnmx620_2',g_sql,g_str)
    LET g_xgrid.table = l_table1        #FUN-D40020
    LET g_xgrid.template = 'gnmx620_2'  #FUN-D40020
    LET g_xgrid.grup_field = "oox05"    #FUN-D40020
    CALL cl_xg_view()    ###XtraGrid###
        END IF
     END IF
     
     #FINISH REPORT gnmx620_rep
#No.FUN-580110 -end
 
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
    #NO.FUN-850005----END------
END FUNCTION
#NO.FUN-850005----BEGIN-----
#REPORT gnmx620_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1      #NO FUN-680145 VARCHAR(1)
#  DEFINE t_azi04      LIKE azi_file.azi04      #No.CHI-6A0004
#  DEFINE t_azi05      LIKE azi_file.azi05      #No.CHI-6A0004
#  DEFINE sr           RECORD
#                        oox01   LIKE  oox_file.oox01,
#                        oox02   LIKE  oox_file.oox02,
#                        oox03   LIKE  oox_file.oox03,
#                        oox05   LIKE  oox_file.oox05,
#                        oox07   LIKE  oox_file.oox07,
#                        oox08   LIKE  oox_file.oox08,
#                        oox09   LIKE  oox_file.oox09,
#                        oox10   LIKE  oox_file.oox10
#                      END RECORD
#  DEFINE gum          RECORD
#                         oox05   LIKE  oox_file.oox05,
#                         oox10   LIKE  oox_file.oox10
#                      END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
#No.FUN-580110 --start
# ORDER BY sr.oox01,sr.oox02,sr.oox03,sr.oox05
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     IF tm.b = '1' THEN
#        IF tm.a = '1' THEN
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#        ELSE
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[23]))/2)+1 ,g_x[23]
#        END IF
#     ELSE
#        IF tm.a = '1' THEN
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[16]))/2)+1,g_x[16]
#        ELSE
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[24]))/2)+1,g_x[24]
#        END IF
#     END IF
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     PRINT ' '
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#           g_x[41]
#     PRINT  g_dash1
#     LET l_last_sw ='n'
#No.FUN-580110 --end
#
#No.FUN-580110 --start
#  BEFORE GROUP OF sr.oox01
#     PRINT COLUMN g_c[31],sr.oox01 USING '&&&&';
 
#  BEFORE GROUP OF sr.oox02
#     IF tm.b='1' THEN
#        PRINT COLUMN g_c[32],sr.oox02 USING '&&';
#     ELSE
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.oox05
#     IF tm.b='2' THEN
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file   #No.CHI-6A0004
#         WHERE azi01=sr.oox05
#        IF SQLCA.sqlcode THEN
#           LET t_azi04 = g_azi04                    #No.CHI-6A0004
#           LET t_azi05 = g_azi05    #使用本國幣別   #No.CHI-6A0004
#           LET t_azi07 = g_azi07
#        END IF
#     #No:7952
#        PRINT COLUMN g_c[35],sr.oox05 CLIPPED,
#              COLUMN g_c[36],cl_numfor(sr.oox07,36,t_azi07);
#     END IF
#
#  ON EVERY ROW
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file  #No.CHI-6A0004
#      WHERE azi01=sr.oox05
#     IF SQLCA.sqlcode THEN
#        LET t_azi04 = g_azi04                   #No.CHI-6A0004
#        LET t_azi05 = g_azi05    #使用本國幣別  #No.CHI-6A0004
#        LET t_azi07 = g_azi07
#     END IF
#     #No:7952
#     IF tm.b='1' THEN
#        PRINT COLUMN g_c[33],sr.oox05 CLIPPED,
#              COLUMN g_c[34],cl_numfor(sr.oox07,34,t_azi07);
#     ELSE
#        IF tm.a='1' THEN
#           PRINT COLUMN g_c[37],sr.oox03;
#        ELSE
#           PRINT COLUMN g_c[38],sr.oox03;
#        END IF
#     END IF
#     PRINT COLUMN g_c[39],cl_numfor(sr.oox08,39,t_azi05),  #No.CHI-6A0004
#           COLUMN g_c[40],cl_numfor(sr.oox09,40,t_azi05),  #No.CHI-6A0004
#           COLUMN g_c[41],cl_numfor(sr.oox10,41,t_azi05)   #No.CHI-6A0004
 
#  AFTER GROUP OF sr.oox05
#     IF tm.b='2' THEN
#        IF tm.a='1' THEN
#           PRINT COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[39]+g_w[40]+g_w[41]+3]
#           PRINT COLUMN g_c[36],g_x[21] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.oox10),41,t_azi05)     #No.CHI-6A0004
#        ELSE
#           PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+g_w[41]+3]
#           PRINT COLUMN g_c[36],g_x[21] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.oox10),41,t_azi05)     #No.CHI-6A0004
#        END IF
#        PRINT ''
#     END IF
#
#  AFTER GROUP OF sr.oox02
#     IF tm.b='1' THEN
#        PRINT COLUMN g_c[32],g_dash2[g_c[32],g_len]
#        PRINT COLUMN g_c[31],g_x[22] CLIPPED,
#              COLUMN g_c[41],cl_numfor(GROUP SUM(sr.oox10),41,t_azi05)        #No.CHI-6A0004
#     ELSE
#        IF tm.a='1' THEN
#           PRINT COLUMN g_c[37],g_dash2[1,g_w[37]+g_w[39]+g_w[40]+g_w[41]+3]
#           PRINT COLUMN g_c[36],g_x[22] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.oox10),41,t_azi05)     #No.CHI-6A0004
#        ELSE
#           PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+g_w[40]+g_w[41]+3]
#           PRINT COLUMN g_c[36],g_x[22] CLIPPED,
#                 COLUMN g_c[41],cl_numfor(GROUP SUM(sr.oox10),41,t_azi05)     #No.CHI-6A0004
#        END IF
#     END IF
#     PRINT ''
#     IF tm.b='1' THEN
#        PRINT COLUMN g_c[31],g_x[20] CLIPPED;
#        FOREACH gnmx620_curs3 USING sr.oox01 INTO gum.*
#           SELECT azi05 INTO t_azi05 FROM azi_file        #No.CHI-6A0004
#            WHERE azi01=gum.oox05
#           IF SQLCA.sqlcode THEN
#              LET t_azi05 = g_azi05    #使用本國幣別      #No.CHI-6A0004
#           END IF
#           PRINT COLUMN g_c[33],gum.oox05,
#                 COLUMN g_c[41],cl_numfor(gum.oox10,41,t_azi05)     #No.CHI-6A0004
#        ##
#        END FOREACH
#     ELSE
#        PRINT COLUMN g_c[36],g_x[20] CLIPPED;
#        FOREACH gnmx620_curs4 USING sr.oox01,sr.oox02 INTO gum.*
#           SELECT azi05 INTO t_azi05 FROM azi_file     #No.CHI-6A0004
#            WHERE azi01=gum.oox05
#           IF SQLCA.sqlcode THEN
#              LET t_azi05 = g_azi05    #使用本國幣別   #No.CHI-6A0004
#           END IF
#           IF tm.a='1' THEN
#              PRINT COLUMN g_c[37],gum.oox05;
#           ELSE
#              PRINT COLUMN g_c[38],gum.oox05;
#           END IF
#       PRINT COLUMN g_c[41],cl_numfor(gum.oox10,41,t_azi05)   #No.CHI-6A0004
#No.FUN-550057 --end--
#        END FOREACH
#     END IF
#No.FUN-580110 --end
 
#  ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'oox03')
#             RETURNING tm.wc
#        PRINT g_dash[1,g_len]
#       #TQC-630166
#       #      IF tm.wc[001,070] > ' ' THEN                      # for 80
#       #         PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#       #      IF tm.wc[071,140] > ' ' THEN
#       #         PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#       #      IF tm.wc[141,210] > ' ' THEN
#       #         PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#       #      IF tm.wc[211,280] > ' ' THEN
#       #         PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#       CALL cl_prt_pos_wc(tm.wc)
#                  #END TQC-630166
#     END IF
#     PRINT g_dash[1,g_len]
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#     ELSE SKIP 2 LINE
#     END IF
#END REPORT
#Patch....NO.TQC-610037 <> #
#No.FUN-870144


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

