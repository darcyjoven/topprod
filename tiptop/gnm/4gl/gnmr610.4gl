# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: gnmr610.4gl
# Descriptions...: 銀行存款月底重評價資料列印
# Date & Author..: 03/03/14 By Maggie
# Modify.........: No:7952 03/09/01 By Wiky 修改匯率
# Modify.........: No.FUN-520004 05/03/04 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.FUN-580110 05/08/23 By will 報表轉XML格式
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680145 06/08/31 By Dxfwo  欄位類型定義
# Modify.........: No.CHI-6A0004 06/10/23 By atsea g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-770078 07/07/13 By Judy 制表日期所在行數與報表名稱顛倒
# Modify.........: No.FUN-7C0007 07/12/17 By baofei 報表輸出至  Crystal Reports 功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80038 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.MOD-C50157 12/05/24 By Polly 調整幣別抓取錯誤
# Modify.........: No.FUN-CC0093 13/01/21 By zhangweib 異動單號增加開窗
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
             #wc      VARCHAR(1000),            # Where condition
	      wc      STRING,
              a       LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(01)  # No:A071,A080又用回
              b       LIKE type_file.chr1,   #NO FUN-680145 VARCHAR(01)
              more    LIKE type_file.chr1    #NO FUN-680145 VARCHAR(01)  # Input more condition(Y/N)
              END RECORD,
          yy,m1,m2    LIKE type_file.num10,  #NO FUN-680145 INTEGER
          y1,mm       LIKE type_file.num10,  #NO FUN-680145 INTEGER
          g_bookno    LIKE aaa_file.aaa01,	
          g_aaz64     LIKE aaz_file.aaz64	
 
DEFINE   g_aaa03         LIKE aaa_file.aaa03
DEFINE   g_i             LIKE type_file.num5       #NO FUN-680145 SMALLINT  #count/index for any purpose
#No.FUN-580110  --begin
#DEFINE   g_dash          LIKE type_file.chr1000   #NO FUN-680145 VARCHAR(400) #Dash line
#DEFINE   g_len           LIKE type_file.num5      #NO FUN-680145 SMALLINT  #Report width(79/132/136)
#DEFINE   g_pageno        LIKE type_file.num5      #NO FUN-680145 SMALLINT  #Report page no
#DEFINE   g_zz05          LIKE type_file.chr1      #NO FUN-680145 VARCHAR(1)   #Print tm.wc ?(Y/N)
#No.FUN-580110  --end
#No.FUN-7C0007---Begin                                                          
DEFINE l_table        STRING,
       l_table1       STRING,
       g_str          STRING,                                                   
       g_sql          STRING                                                  
                                                 
#No.FUN-7C0007---End 
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
#No.FUN-7A0036---Begin                                                          
   LET g_sql = "oox01.oox_file.oox01,",   
               "oox02.oox_file.oox02,",
               "oox03.oox_file.oox03,",        
               "oox05.oox_file.oox05,",
               "oox07.oox_file.oox07,",         
               "oox08.oox_file.oox08,",   
               "oox09.oox_file.oox09,",        
               "oox10.oox_file.oox10,",                  
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",                                         
               "azi07.azi_file.azi07"                                                                 
   LET l_table = cl_prt_temptable('gnmr610',g_sql) CLIPPED                      
   IF l_table = -1 THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add #No.FUN-BB0047  mark
      EXIT PROGRAM
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
               " VALUES(?,?,?,?,?,?,?,?,?,?,?) "      
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1)
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add #No.FUN-BB0047  mark
      EXIT PROGRAM                         
   END IF  
#No.FUN-7C0007---End
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)   #No:A071
   LET tm.b     = ARG_VAL(10)   #No:A071
   LET yy       = ARG_VAL(11)   #TQC-610056
   LET m1       = ARG_VAL(12)   #TQC-610056
   LET m2       = ARG_VAL(13)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz64
   END IF
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF #使用本國幣別
  # SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03  #No.CHI-6A0004
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-B80038---add---
   IF NOT cl_null(tm.wc) THEN
      CALL gnmr610()
   ELSE
      CALL gnmr610_tm(0,0)
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
END MAIN
 
FUNCTION gnmr610_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,  #NO FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000#NO FUN-680145 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 24
 
   OPEN WINDOW gnmr610_w AT p_row,p_col WITH FORM "gnm/42f/gnmr610"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = g_today
   INITIALIZE tm.* TO NULL            # Default condition
   LET yy      = y1
   LET m1      = mm
   LET m2      = mm
   LET tm.a    = 'Y'   #No:A071
   LET tm.b    = '1'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON oox03
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

     #No.FUN-CC0093 ---start---   Add
      ON ACTION controlp
         CASE
            WHEN INFIELD(oox03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oox03"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "oox00 = 'NM'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oox03
               NEXT FIELD oox03
            OTHERWISE EXIT CASE
         END CASE
     #No.FUN-CC0093 ---start---   Add 
 
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
 
     INPUT BY NAME yy,m1,m2,tm.a,tm.b,tm.more WITHOUT DEFAULTS   #No:A071
###   INPUT BY NAME yy,m1,m2,tm.b,tm.more WITHOUT DEFAULTS       #No:A080
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD yy
          IF yy IS NULL THEN
             NEXT FIELD yy
          END IF
 
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
#          IF m1 IS NULL OR m1 <= 0 OR m1 > 13 THEN
#             NEXT FIELD m1
#          END IF
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
#No.TQC-720032 -- end --
#          IF m2 IS NULL OR m2 <= 0 OR m2 > 13 THEN
#             NEXT FIELD m2
#          END IF
#No.TQC-720032 -- end --
 
        AFTER FIELD a
        #modify NO.A080 030616
          IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN NEXT FIELD a END IF
 
        AFTER FIELD b
        #modify NO.A080 030616
          IF cl_null(tm.b) OR tm.b NOT MATCHES '[12]' THEN NEXT FIELD b END IF
 
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
        LET INT_FLAG = 0
        EXIT WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='gnmr610'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gnmr610','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_bookno CLIPPED,"'",   #TQC-610056
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.wc CLIPPED,"'" ,
                           " '",tm.a CLIPPED,"'" ,
                           " '",tm.b CLIPPED,"'" ,
                           " '",yy CLIPPED,"'"  ,   #TQC-610056
                           " '",m1 CLIPPED,"'"  ,   #TQC-610056
                           " '",m2 CLIPPED,"'"  ,   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('gnmr610',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW gnmr610_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
 
     CALL cl_wait()
     CALL gnmr610()
     ERROR ""
   END WHILE
   CLOSE WINDOW gnmr610_w
END FUNCTION
 
FUNCTION gnmr610()
   DEFINE l_name    LIKE type_file.chr20,    #NO FUN-680145 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0098
          l_sql     LIKE type_file.chr1000,  #NO FUN-680145 VARCHAR(1000)
          sr        RECORD
                       oox01   LIKE  oox_file.oox01,
                       oox02   LIKE  oox_file.oox02,
                       oox03   LIKE  oox_file.oox03,  #No.FUN-580110  --add
                       oox05   LIKE  oox_file.oox05,
                       oox07   LIKE  oox_file.oox07,
                       oox08   LIKE  oox_file.oox08,
                       oox09   LIKE  oox_file.oox09,
                       oox10   LIKE  oox_file.oox10
                    END RECORD,
          sr1       RECORD
                       oox01   LIKE  oox_file.oox01,
                       oox02   LIKE  oox_file.oox02,
                       oox03   LIKE  oox_file.oox03,
                       oox05   LIKE  oox_file.oox05,
                       oox07   LIKE  oox_file.oox07,
                       oox08   LIKE  oox_file.oox08,
                       oox09   LIKE  oox_file.oox09,
                       oox10   LIKE  oox_file.oox10
                    END RECORD,
          l_za05    LIKE type_file.chr1000,      #NO FUN-680145 VARCHAR(40)
          l_temp    LIKE type_file.chr1000       #NO FUN-680145 VARCHAR(90)
       CALL cl_del_data(l_table)   #No.FUN-7C0007
#       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098  #No.FUN-B80038---mark---
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-7C0007
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     DECLARE gnmr610_za_cur CURSOR FOR
             SELECT za02,za05 FROM za_file
              WHERE za01 = "gnmr610" AND za03 = g_lang
#No.FUN-580110  --begin
#    FOREACH gnmr610_za_cur INTO g_i,l_za05
#       LET g_x[g_i] = l_za05
#    END FOREACH
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gnmr610'
#  #No.FUN-550057  --start--
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 88 END IF
#    IF tm.b ='1'   THEN
#       LET g_len = 87
#    ELSE
#       LET g_len = 93
#    END IF
#  #No.FUN-550057  --end--
#    IF tm.a = 'Y' THEN
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    END IF
#No.FUN-580110  --end
     IF tm.a = 'Y' THEN
        LET l_temp =" oox03v = '2' "
     ELSE
        LET l_temp =" oox03v = '1' "
     END IF
 
     LET l_sql="SELECT oox01,oox02,'',oox05,oox07,SUM(oox08),SUM(oox09),SUM(oox10)",
               "  FROM oox_file ",
               " WHERE oox00 = 'NM' ",
               "   AND oox01 = ",yy,
               "   AND oox02 BETWEEN ",m1," AND ",m2,
               "   AND ",tm.wc CLIPPED,
               "   AND ",l_temp CLIPPED,
               " GROUP BY oox01,oox02,oox05,oox07",
               " ORDER BY 1,2,3"
 
     PREPARE gnmr610_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmr610_curs1 CURSOR FOR gnmr610_prepare1
 
     LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
               " WHERE oox00 = 'NM' ",
               "   AND oox01 = ?",
               "   AND oox02 BETWEEN ",m1," AND ",m2,
               "   AND ",tm.wc CLIPPED,
               "   AND ",l_temp CLIPPED,
               " GROUP BY oox05",
               " ORDER BY 1"
     PREPARE gnmr610_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmr610_curs3 CURSOR FOR gnmr610_prepare3
 
     LET l_sql="SELECT oox01,oox02,oox03,oox05,oox07,oox08,",
               "       oox09,oox10 ",
               "  FROM oox_file ",
               " WHERE oox00 = 'NM' ",
               "   AND oox01 = ",yy,
               "   AND oox02 BETWEEN ",m1," AND ",m2,
               "   AND ",tm.wc CLIPPED,
               "   AND ",l_temp CLIPPED,
               " ORDER BY 1,2,5 "
 
     PREPARE gnmr610_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmr610_curs2 CURSOR FOR gnmr610_prepare2
 
     LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
               " WHERE oox00 = 'NM'",
               "   AND oox01 = ?",
               "   AND oox02 = ?",
               "   AND ",tm.wc CLIPPED,
               "   AND ",l_temp CLIPPED,
               " GROUP BY oox05",
               " ORDER BY 1"
     PREPARE gnmr610_prepare4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare4:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80038--add--
        EXIT PROGRAM
     END IF
     DECLARE gnmr610_curs4 CURSOR FOR gnmr610_prepare4
 
     CALL cl_outnam('gnmr610') RETURNING l_name
 
#No.FUN-580110  --begin
#No.FUN-7C0007---Begin
#     IF tm.b = '1' THEN            #統計報表 #modify NO.A080 030616
#        LET g_zaa[35].zaa06 = 'Y'
#     ELSE                          #明細報表
#        LET g_zaa[31].zaa06 = 'Y'
#        LET g_zaa[32].zaa06 = 'Y'
#     END IF
      IF tm.b = '1' THEN
         LET l_name ='gnmr610_1'
      ELSE
         LET l_name ='gnmr610'
      END IF
#     CALL cl_prt_pos_len()           
#     START REPORT gnmr610_rep TO l_name   
#No.FUN-580110  --end
 
#     LET g_pageno     = 0          
#No.FUN-7C0007---End
     IF tm.b = '1' THEN              #統計報表 #modify NO.A080 030616
        FOREACH gnmr610_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
#No.FUN-7C0007---Begin 
         SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file   
          WHERE azi01=sr.oox05
         IF SQLCA.sqlcode THEN
            LET t_azi04 = g_azi04  
            LET t_azi05 = g_azi05  
            LET t_azi07 = g_azi07  
         END IF
         EXECUTE insert_prep USING sr.oox01,sr.oox02,sr.oox03,sr.oox05,
                                      sr.oox07,sr.oox08,sr.oox09,sr.oox10,
                                      t_azi04,t_azi05,t_azi07
#           OUTPUT TO REPORT gnmr610_rep(sr.*)
#No.FUN-7C0007---End
        END FOREACH
     ELSE                          #明細報表
        FOREACH gnmr610_curs2 INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
#          OUTPUT TO REPORT gnmr610_rep1(sr1.*)
#No.FUN-7C0007---Begin
         SELECT azi04,azi05,azi07 
           INTO t_azi04,t_azi05,t_azi07 
           FROM azi_file   
         #WHERE azi01 = sr.oox05                     #MOD-C50157 mark
          WHERE azi01 = sr1.oox05                    #MOD-C50157 add
         IF SQLCA.sqlcode THEN
            LET t_azi04 = g_azi04 
            LET t_azi05 = g_azi05  
            LET t_azi07 = g_azi07  
         END IF
         EXECUTE insert_prep USING sr1.oox01,sr1.oox02,sr1.oox03,sr1.oox05,
                                   sr1.oox07,sr1.oox08,sr1.oox09,sr1.oox10,
                                   t_azi04,t_azi05,t_azi07
#           OUTPUT TO REPORT gnmr610_rep(sr1.*)    #No.FUN-580110
#No.FUN-7C0007---End 
        END FOREACH
     END IF
#No.FUN-7C0007---Begin
#     FINISH REPORT gnmr610_rep
      IF g_zz05 = 'Y' THEN                                                      
         CALL cl_wcchp(tm.wc,'oox03')                         
              RETURNING tm.wc                                                   
      END IF                                                                    
      LET g_str=tm.wc ,";",tm.a
   LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
   CALL cl_prt_cs3('gnmr610',l_name,l_sql,g_str)
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-7C0007---End
   #No.FUN-BB0047--mark--Begin---
   #    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
   #No.FUN-BB0047--mark--End-----
END FUNCTION
#No.FUN-7C0007---Begin
#REPORT gnmr610_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1      #NO FUN-680145 VARCHAR(1)
#  DEFINE t_azi04      LIKE azi_file.azi04      #No.CHI-6A0004
#  DEFINE t_azi05      LIKE azi_file.azi05      #No.CHI-6A0004
#  DEFINE sr           RECORD
#                         oox01   LIKE  oox_file.oox01,
#                         oox02   LIKE  oox_file.oox02,
#                         oox03   LIKE  oox_file.oox03,   #No.FUN-580110
#                         oox05   LIKE  oox_file.oox05,
#                         oox07   LIKE  oox_file.oox07,
#                         oox08   LIKE  oox_file.oox08,
#                         oox09   LIKE  oox_file.oox09,
#                         oox10   LIKE  oox_file.oox10
#                      END RECORD
#  DEFINE gum          RECORD
#                         oox05   LIKE  oox_file.oox05,
#                         oox10   LIKE  oox_file.oox10
#                      END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin  #FUN-580098
#        PAGE LENGTH g_page_line
# ORDER BY sr.oox01,sr.oox02,sr.oox05,sr.oox03
# FORMAT
##No.FUN-580110  -begin
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#     PRINT
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
##     PRINT g_head CLIPPED,pageno_total   #TQC-770078
#     IF tm.b = '1' THEN
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#        SKIP 1 LINE
#     ELSE
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[16]))/2)+1,g_x[16]
#        PRINT g_x[15] CLIPPED,sr.oox01 USING '####',' ',
#              g_x[19] CLIPPED,sr.oox02 USING '##'
#     END IF
#     IF tm.a = 'Y' THEN
#        LET g_zaa[36].zaa08 = g_x[23]
#     ELSE
#        LET g_zaa[36].zaa08 = g_x[24]
#     END IF
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
##     IF g_towhom IS NULL OR g_towhom = ' ' THEN PRINT '';
##     ELSE PRINT 'TO:',g_towhom;
##     END IF
##     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##     PRINT ' '
##     LET g_pageno = g_pageno +1
##     PRINT g_x[2] CLIPPED,g_pdate,' ',TIME;
##     PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_head CLIPPED,pageno_total   #TQC-770078
#     PRINT g_dash[1,g_len]
##     IF tm.a = 'Y' THEN
##        PRINT COLUMN 01,g_x[11] CLIPPED,
##              COLUMN 32,g_x[12] CLIPPED,
##              COLUMN 74,g_x[13]
##     ELSE
##        PRINT COLUMN 01,g_x[11] CLIPPED,
##              COLUMN 32,g_x[17] CLIPPED,
##              COLUMN 74,g_x[13]
##     END IF
##     PRINT '----  --  ----',
##           COLUMN 17,'-----------',
##           COLUMN 29,'-------------------',
##           COLUMN 49,'-------------------', #No:7952
##           COLUMN 69,'-------------------'
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#     PRINT g_dash1
#     LET l_last_sw ='n'
#
#  BEFORE GROUP OF sr.oox01
#     IF tm.b = '1' THEN
#        PRINT COLUMN g_c[31],sr.oox01 USING '&&&&';
#     END IF
 
#  BEFORE GROUP OF sr.oox02
#     IF tm.b = '1' THEN
#        PRINT COLUMN g_c[32],sr.oox02 USING '&&';
#     ELSE
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF sr.oox05
#     IF tm.b = '2' THEN
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file    #No.CHI-6A0004
#         WHERE azi01=sr.oox05
#        IF SQLCA.sqlcode THEN
#           LET t_azi04 = g_azi04   #No.CHI-6A0004
#           LET t_azi05 = g_azi05    #使用本國幣別
#           LET t_azi07 = g_azi07   #No.CHI-6A0004
#        END IF
#        #No:7852
#        PRINT COLUMN g_c[33],sr.oox05 CLIPPED,
#              COLUMN g_c[34],cl_numfor(sr.oox07,34,t_azi07);
#     END IF
 
#  ON EVERY ROW
#     IF tm.b = '1' THEN
#        SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file   #No.CHI-6A0004
#         WHERE azi01=sr.oox05
#        IF SQLCA.sqlcode THEN
#           LET t_azi04 = g_azi04    #No.CHI-6A0004
#           LET t_azi05 = g_azi05    #使用本國幣別  #No.CHI-6A0004
#           LET t_azi07 = g_azi07
#        END IF
#        #No:7852
#        PRINT COLUMN g_c[33],sr.oox05 CLIPPED,
#              COLUMN g_c[34],cl_numfor(sr.oox07,34,t_azi07),
#              COLUMN g_c[36],cl_numfor(sr.oox08,36,t_azi05),    #No.CHI-6A0004
#              COLUMN g_c[37],cl_numfor(sr.oox09,37,t_azi05),    #No.CHI-6A0004
#              COLUMN g_c[38],cl_numfor(sr.oox10,38,t_azi05)     #No.CHI-6A0004
#     ELSE
#        PRINT COLUMN g_c[35],sr.oox03,
#              COLUMN g_c[36],cl_numfor(sr.oox08,36,t_azi04),    #No.CHI-6A0004
#              COLUMN g_c[37],cl_numfor(sr.oox09,37,t_azi04),    #No.CHI-6A0004
#              COLUMN g_c[38],cl_numfor(sr.oox10,38,t_azi04)     #No.CHI-6A0004
#     END IF
#
#  AFTER GROUP OF sr.oox05
#     IF tm.b = '2' THEN
#        PRINT COLUMN g_c[35],g_dash2[g_c[33]+1,g_len]
#        PRINT COLUMN g_c[34],g_x[21] CLIPPED,
#              COLUMN g_c[38],cl_numfor(GROUP SUM(sr.oox10),38,t_azi05)  #No.CHI-6A0004
#        PRINT ''
#     END IF
 
#  AFTER GROUP OF sr.oox02
#     IF tm.b = '1' THEN
#        PRINT COLUMN g_c[33],g_dash2[g_c[33]+1,g_len]
#        PRINT COLUMN g_c[31],g_x[22] CLIPPED,
#              COLUMN g_c[38],cl_numfor(GROUP SUM(sr.oox10),38,t_azi05)  #No.CHI-6A0004
#        PRINT ''
#     ELSE
#        PRINT COLUMN g_c[35],g_dash2[g_c[33]+1,g_len]
#        PRINT COLUMN g_c[34],g_x[22] CLIPPED,
#              COLUMN g_c[38],cl_numfor(GROUP SUM(sr.oox10),38,t_azi05)  #No.CHI-6A0004
#        PRINT ''
#        PRINT COLUMN g_c[34],g_x[20] CLIPPED;
#        FOREACH gnmr610_curs4 USING sr.oox01,sr.oox02 INTO gum.*
#           SELECT azi05 INTO t_azi05 FROM azi_file          #No.CHI-6A0004
#            WHERE azi01=gum.oox05
#           IF SQLCA.sqlcode THEN
#              LET t_azi05 = g_azi05    #使用本國幣別   #No.CHI-6A0004
#           END IF
#           PRINT COLUMN g_c[35],gum.oox05,
#                 COLUMN g_c[38],cl_numfor(gum.oox10,38,t_azi05)       #No.FUN-550057    #No.CHI-6A0004
#        END FOREACH
#     END IF
#
#  ON LAST ROW
#     IF tm.b = '1' THEN
#        PRINT COLUMN g_c[31],g_x[20] CLIPPED;
#        FOREACH gnmr610_curs3 USING sr.oox01 INTO gum.*
#           SELECT azi05 INTO t_azi05 FROM azi_file                   #No.CHI-6A0004
#            WHERE azi01=gum.oox05
#           IF SQLCA.sqlcode THEN
#              LET t_azi05 = g_azi05    #使用本國幣別   #No.CHI-6A0004
#           END IF
#           PRINT COLUMN g_c[33],gum.oox05,
#                 COLUMN g_c[38],cl_numfor(gum.oox10,38,t_azi05)    #No.CHI-6A0004
#        END FOREACH
#     END IF
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
#       #END TQC-630166
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
##No.FUN-580111  --end
#END REPORT
 
#REPORT gnmr610_rep1(sr)
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
#        BOTTOM MARGIN g_bottom_margin  #FUN-580098
#        PAGE LENGTH g_page_line
# ORDER BY sr.oox01,sr.oox02,sr.oox05,sr.oox03
# FORMAT
#  PAGE HEADER
#     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#     IF g_towhom IS NULL OR g_towhom = ' ' THEN PRINT '';
#     ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#     PRINT (g_len-FGL_WIDTH(g_x[16]))/2 SPACES,g_x[16]
#     PRINT ' '
#     LET g_pageno = g_pageno +1
#     PRINT g_x[15] CLIPPED,sr.oox01 USING '####',' ',
#           g_x[19] CLIPPED,sr.oox02 USING '##';
#     PRINT COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#     PRINT g_dash[1,g_len]
#     IF tm.a = 'Y' THEN
#        PRINT COLUMN 01,g_x[18] CLIPPED,
#              COLUMN 38,g_x[12] CLIPPED;
#     ELSE
#        PRINT COLUMN 01,g_x[14] CLIPPED,
#              COLUMN 32,g_x[17] CLIPPED;
#     END IF
#     PRINT COLUMN 75,g_x[13]
#     PRINT '----',
#           COLUMN 6,'----------- ----------------',
#           COLUMN 35,'-------------------',
#           COLUMN 55,'-------------------', #No:7952
#           COLUMN 75,'-------------------'
 
#     LET l_last_sw ='n'
#
#  BEFORE GROUP OF sr.oox02
#     SKIP TO TOP OF PAGE
 
#  BEFORE GROUP OF sr.oox05
#     SELECT azi04,azi05,azi07 INTO t_azi04,t_azi05,t_azi07 FROM azi_file             #No.CHI-6A0004
#      WHERE azi01=sr.oox05
#     IF SQLCA.sqlcode THEN
#        LET t_azi04 = g_azi04    #No.CHI-6A0004
#        LET t_azi05 = g_azi05    #使用本國幣別  #No.CHI-6A0004
#        LET t_azi07 = g_azi07
#     END IF
#     #No:7852
#     PRINT COLUMN 01,sr.oox05 CLIPPED,
#           COLUMN 06,cl_numfor(sr.oox07,10,t_azi07);
#
#  ON EVERY ROW
#     PRINT COLUMN 18,sr.oox03;
#  #No.FUN-550057 --start--
#     PRINT COLUMN 35,cl_numfor(sr.oox08,18,t_azi04),  #No.CHI-6A0004
#           COLUMN 55,cl_numfor(sr.oox09,18,t_azi04),
#           COLUMN 75,cl_numfor(sr.oox10,18,t_azi04)   #No.CHI-6A0004
#  #No.FUN-550057 --end--
#
#  AFTER GROUP OF sr.oox05
#  #No.FUN-550057 --start--
#     PRINT COLUMN 18,"----------------------------------------------",
#                     "------------------------------"
#     PRINT COLUMN 06,g_x[21] CLIPPED,
#           COLUMN 75,cl_numfor(GROUP SUM(sr.oox10),18,t_azi05)   #No.CHI-6A0004
#  #No.FUN-550057 --end--
#     PRINT ''
#
#  AFTER GROUP OF sr.oox02
#  #No.FUN-550057 --start--
#     PRINT COLUMN 18,"----------------------------------------------------",
#                     "------------------------"
#     PRINT COLUMN 02,g_x[22] CLIPPED,
#           COLUMN 75,cl_numfor(GROUP SUM(sr.oox10),18,t_azi05)    #No.CHI-6A0004
#  #No.FUN-550057 --end--
#     PRINT ''
#     PRINT COLUMN 06,g_x[20] CLIPPED;
#     FOREACH gnmr610_curs4 USING sr.oox01,sr.oox02 INTO gum.*
#        SELECT azi05 INTO t_azi05 FROM azi_file          #No.CHI-6A0004
#         WHERE azi01=gum.oox05
#        IF SQLCA.sqlcode THEN
#           LET t_azi05 = g_azi05    #使用本國幣別   #No.CHI-6A0004
#        END IF
#        PRINT COLUMN 18,gum.oox05,
#              COLUMN 75,cl_numfor(gum.oox10,18,t_azi05)       #No.FUN-550057    #No.CHI-6A0004
#     END FOREACH
#     ##
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
#       #END TQC-630166
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
