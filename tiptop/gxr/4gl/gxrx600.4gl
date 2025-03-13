# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: gxrx600.4gl
# Descriptions...: 應收帳款月底重評價資料列印
# Date & Author..: 03/03/12 Maggie
# Modify.........: FUN-4C0100 05/03/01 Smapmin 放寬金額欄位
#                  MOD-530859 05/03/30 alex 將定義改回 CHAR
# Modify.........: No.FUN-550071 05/05/28 By vivien 單據編號格式放大
# Modify.........: No.FUN-580110 05/08/22 By jackie 報表轉XML格式
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN g_bottom_margin改5
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610056 06/06/30 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-770078 07/07/13 By Judy 選擇明細時，報表表頭應列印"應收帳款月底重評價明細表"
# Modify.........: No.FUN-7B0026 07/11/21 By Lutingting 修改為Crystal Report 輸出
# Modify.........: No.FUN-870151 08/08/13 By xiaofeizhu 報表中匯率欄位小數位數沒有依 aooi050 做取位
# Modify.........: No.MOD-8B0099 08/11/11 By Sarah 報表類別為2:明細時,合計重覆列印多筆
# Modify.........: No.FUN-B80036 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-BA0022 11/10/08 By Dido 語法調整與變數運用錯誤 
# Modify.........: No.FUN-BB0047 11/11/15 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-D40020 12/12/24 By wangrr CR轉xtragrid
# Modify.........: No.FUN-D40129 13/05/20 By yangtt 報表中添加類別說明欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              #wc      VARCHAR(1000),            # Where condition   #TQC-630166
              wc      STRING,            # Where condition   #TQC-630166
              b       LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)
              more    LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)      # Input more condition(Y/N)
              END RECORD,
          yy,m1,m2    LIKE type_file.num10,   #NO.FUN-680145 INTEGER
          y1,mm       LIKE type_file.num10,   #NO.FUN-680145 INTEGER
          g_bookno    LIKE aaa_file.aaa01,	
          g_aaa03     LIKE aaa_file.aaa03,	
          g_aaz64     LIKE aaz_file.aaz64	
 
   DEFINE   g_i          LIKE type_file.num5     #NO.FUN-680145 SMALLINT  #count/index for any purpose
#No.FUN-7B0026--START--
   DEFINE   l_table      STRING                  
   DEFINE   l_table1     STRING                  
   DEFINE   l_table2     STRING              
   DEFINE   l_table3     STRING  #FUN-D40020 
   DEFINE   g_sql        STRING                   
   DEFINE   g_str        STRING                   
#No.FUN-7B0026--END
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GXR")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time        #FUN-B80036 ADD #FUN-BB0047 mark
#No.FUN-7B0026--start
   LET g_sql = "oox01.oox_file.oox01,",
               "oox02.oox_file.oox02,",
               "oox05.oox_file.oox05,",
               "oox07.oox_file.oox07,",
               "oox03v.oox_file.oox03v,",
               "oox03.oox_file.oox03,",
               "oox04.oox_file.oox04,",
               "oox08.oox_file.oox08,",
               "oox09.oox_file.oox09,",
               "oox10.oox_file.oox10,",
               "azi04.azi_file.azi04,",
               "azi05.azi_file.azi05,",
               "azi07.azi_file.azi07,",    #FUN-870151
               "oox03v_a.type_file.chr50"  #FUN-D40129
   LET l_table = cl_prt_temptable('gxrx600',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF

   LET l_table3 = cl_prt_temptable('gxrx6003',g_sql) CLIPPED #FUN-D40020   
   IF l_table3=-1 THEN EXIT PROGRAM END IF #FUN-D40020

   LET g_sql = "oox01_1.oox_file.oox01,",
               "oox05.oox_file.oox05,",
               "oox10.oox_file.oox10,",
               "azi05.azi_file.azi05"
   LET l_table1 = cl_prt_temptable('gxrx6001',g_sql) CLIPPED
   IF l_table1=-1 THEN EXIT PROGRAM END IF 
   LET g_sql = "oox01.oox_file.oox01,",
               "oox02.oox_file.oox02,",
               "oox05.oox_file.oox05,",
               "oox10.oox_file.oox10,",
               "azi05.azi_file.azi05"
   LET l_table2 = cl_prt_temptable('gxrx6002',g_sql) CLIPPED
   IF l_table2 =-1 THEN EXIT PROGRAM END IF  
#No.FUN-7B0026--end
   LET g_bookno = ARG_VAL(1)
   LET g_pdate  = ARG_VAL(2)             # Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc    = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   LET yy       = ARG_VAL(10)   #TQC-610056
   LET m1       = ARG_VAL(11)   #TQC-610056
   LET m2       = ARG_VAL(12)   #TQC-610056
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      LET g_bookno = g_aaz64
   END IF
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_bookno
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF #使用本國幣別
   SELECT azi04,azi05 INTO t_azi04,t_azi05 FROM azi_file WHERE azi01 = g_aaa03
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   IF NOT cl_null(tm.wc) THEN
      CALL gxrx600()
   ELSE
      CALL gxrx600_tm(0,0)
   END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B80036 ADD
END MAIN
 
FUNCTION gxrx600_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
          l_cmd          LIKE type_file.chr1000       #NO.FUN-680145 VARCHAR(1000)
 
   LET p_row = 3 LET p_col = 24
 
   OPEN WINDOW gxrx600_w AT p_row,p_col WITH FORM "gxr/42f/gxrx600"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   SELECT azn02,azn04 INTO y1,mm FROM azn_file WHERE azn01 = g_today
   INITIALIZE tm.* TO NULL            # Default condition
   LET yy      = y1
   LET m1      = mm
   LET m2      = mm
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
 
     #No.FUN-D40020 ---start---   Add
      ON ACTION controlp
         CASE
            WHEN INFIELD(oox03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oox03"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "oox00 = 'AR'"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oox03
               NEXT FIELD oox03
            WHEN INFIELD(oox03v)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oox03v1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = "oox00 = 'AR' AND gae03 = '",g_lang,"'"
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
      LET INT_FLAG = 0 CLOSE WINDOW gxrx600_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME yy,m1,m2,tm.b,tm.more WITHOUT DEFAULTS
 
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
#        IF m1 IS NULL OR m1 <= 0 OR m1 > 13 THEN
#           NEXT FIELD m1
#        END IF
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
#        IF m2 IS NULL OR m2 <= 0 OR m2 > 13 THEN
#           NEXT FIELD m2
#        END IF
#No.TQC-720032 -- end --
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
      LET INT_FLAG = 0 CLOSE WINDOW gxrx600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='gxrx600'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('gxrx600','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_bookno CLIPPED,"'",
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.b CLIPPED,"'" ,
                        " '",yy CLIPPED,"'" ,   #TQC-610056
                        " '",m1 CLIPPED,"'" ,   #TQC-610056
                        " '",m2 CLIPPED,"'" ,   #TQC-610056
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('gxrx600',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW gxrx600_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gxrx600()
   ERROR ""
END WHILE
   CLOSE WINDOW gxrx600_w
END FUNCTION
 
FUNCTION gxrx600()
   DEFINE l_name    LIKE type_file.chr20,     #NO.FUN-680145 VARCHAR(20)    # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0099
          #l_sql    VARCHAR(1000),   #TQC-630166
          l_sql     STRING,   #TQC-630166
  
#No.FUN-580110 --start--
          sr        RECORD
                       oox01   LIKE  oox_file.oox01,
                       oox02   LIKE  oox_file.oox02,
                       oox03   LIKE  oox_file.oox03,
                       oox03v  LIKE  oox_file.oox03v,
                       oox04   LIKE  oox_file.oox04,
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
                       oox03v  LIKE  oox_file.oox03v,
                       oox04   LIKE  oox_file.oox04,
                       oox05   LIKE  oox_file.oox05,
                       oox07   LIKE  oox_file.oox07,
                       oox08   LIKE  oox_file.oox08,
                       oox09   LIKE  oox_file.oox09,
                       oox10   LIKE  oox_file.oox10
                    END RECORD,
          l_za05    LIKE type_file.chr1000         #NO.FUN-680145 VARCHAR(40)
#No.FUN-7B0026--start--
     DEFINE l_azi04      LIKE azi_file.azi04       
     DEFINE l_azi05      LIKE azi_file.azi05
     DEFINE l_azi07      LIKE azi_file.azi07       #NO.FUN-870151   
     DEFINE gum          RECORD                                                                                                       
                          oox05   LIKE  oox_file.oox05,                                                                             
                          oox10   LIKE  oox_file.oox10                                                                              
                       END RECORD
#No.FUN-7B0026--end
     DEFINE l_oox03v_a     LIKE type_file.chr50   #FUN-D40129

     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     #No.FUN-BB0047--mark--End-----
#No.FUN-7B0026--start--
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"        #FUN-D40129 add 1?                                                                            
     PREPARE insert_prep FROM g_sql                                                                                                   
     IF STATUS THEN                                                                                                                   
         CALL cl_err('insert_prep:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
         EXIT PROGRAM                                                                             
     END IF

     #FUN-D40020--add--str--
     CALL cl_del_data(l_table3)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?, ?,?,?,?)"      #FUN-D40129 add
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
         CALL cl_err('insert_prep3:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
     END IF
     #FUN-D40020--add--end 

     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?)"
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN 
         CALL cl_err('insert_prep1:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
         EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?,?,?,?,?)" 
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN 
         CALL cl_err('insert_prep2:',status,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
         EXIT PROGRAM
     END IF                                      
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='gxrx600'
#No.FUN-7B0026--end        
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     LET l_sql="SELECT oox01,oox02,oox03,oox03v,oox04,oox05,oox07,oox08,oox09,oox10",
               "  FROM oox_file ",
               " WHERE oox00 = 'AR' ",                 #MOD-BA0022 remark
               "   AND oox01 = ",yy,                   #MOD-BA0022 remark
               "   AND oox02 BETWEEN ",m1," AND ",m2,  #MOD-BA0022 remark
               "   AND ",tm.wc CLIPPED,                #MOD-BA0022 remark
               " ORDER BY 1,2,3,5 "                    #MOD-BA0022 remark
 
     PREPARE gxrx600_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
        EXIT PROGRAM
     END IF
     DECLARE gxrx600_curs1 CURSOR FOR gxrx600_prepare1
 
     LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
               " WHERE oox00 = 'AR'",
               "   AND oox01 = ?",
               "   AND oox02 BETWEEN ",m1," AND ",m2,   #MOD-BA0022 remark
               "   AND ",tm.wc CLIPPED,
               " GROUP BY oox05",
               " ORDER BY 1"
     PREPARE gxrx600_prepare3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare3:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
        EXIT PROGRAM
     END IF
     DECLARE gxrx600_curs3 CURSOR FOR gxrx600_prepare3
 
     LET l_sql="SELECT oox01,oox02,oox03,oox03v,oox04,oox05,oox07,oox08,",
                "       oox09,oox10 ",
                "  FROM oox_file ",
                " WHERE oox00 = 'AR' ",
                "   AND oox01 = ",yy,
                "   AND oox02 BETWEEN ",m1," AND ",m2,
                "   AND ",tm.wc CLIPPED,
                " ORDER BY 1,2,6,4 "
 
     PREPARE gxrx600_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
        EXIT PROGRAM
     END IF
     DECLARE gxrx600_curs2 CURSOR FOR gxrx600_prepare2
 
    #str MOD-8B0099 add
     LET l_sql="SELECT DISTINCT oox01,oox02",
               "  FROM oox_file ",
               " WHERE oox00 = 'AR' ",
               "   AND oox01 = ",yy,
               "   AND oox02 BETWEEN ",m1," AND ",m2,
               "   AND ",tm.wc CLIPPED,
               " ORDER BY 1,2"
 
     PREPARE gxrx600_prepare4_1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare4_1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
        EXIT PROGRAM
     END IF
     DECLARE gxrx600_curs4_1 CURSOR FOR gxrx600_prepare4_1
    #end MOD-8B0099 add
 
     LET l_sql="SELECT oox05,SUM(oox10) FROM oox_file ",
               " WHERE oox00 = 'AR'",
               "   AND oox01 = ?",
               "   AND oox02 = ?",
               "   AND ",tm.wc CLIPPED,
               " GROUP BY oox05",
               " ORDER BY 1"
     PREPARE gxrx600_prepare4 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare4:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B80036 ADD
        EXIT PROGRAM
     END IF
     DECLARE gxrx600_curs4 CURSOR FOR gxrx600_prepare4
 
#     #CALL cl_outnam('gxrx600') RETURNING l_name  #No.FUN-7B0026 #FUN-D40020 mark
#No.FUN-7B0026--start--
     IF tm.b='1' THEN
      # LET g_zaa[31].zaa06='N'
      # LET g_zaa[32].zaa06='N'
      # LET g_zaa[36].zaa06='Y'
      # LET g_zaa[37].zaa06='Y'
        LET l_name ='gxrx600'
     ELSE
      # LET g_zaa[36].zaa06='N'
      # LET g_zaa[37].zaa06='N'
      # LET g_zaa[31].zaa06='Y'
      # LET g_zaa[32].zaa06='Y'
        LET l_name ='gxrx600_1'
     END IF
#No.FUN-7B0026--end
#     CALL cl_prt_pos_len()                      #No.FUN-7B0026
#     START REPORT gxrx600_rep TO l_name         #No.FUN-7B0026
 
#    LET g_pageno     = 0                        #No.FUN-7B0026
     IF tm.b = '1' THEN              #統計報表 #modify NO.A080 030616
        FOREACH gxrx600_curs1 INTO sr.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
           IF sr.oox03v MATCHES '1*' THEN
              LET sr.oox03v = '1'
           ELSE
              LET sr.oox03v = '2'
           END IF
#          OUTPUT TO REPORT gxrx600_rep(sr.*)                  #No.FUN-7B0026
#No.FUN-7B0026--start--
           SELECT azi04,azi05,azi07 INTO l_azi04,l_azi05,l_azi07 FROM azi_file       #FUN-870151 Add azi07                                                                         
              WHERE azi01=sr.oox05                                                                                                         
           IF SQLCA.sqlcode THEN                                                                                                         
              LET l_azi04 = g_azi04                                                                                                      
              LET l_azi05 = g_azi05    #使用本國幣別
              LET l_azi07 = g_azi07                                                  #FUN-870151 Add                                                                                     
           END IF

           LET l_oox03v_a = cl_gr_getmsg('gre-367',g_lang,sr.oox03v)  #FUN-D40129 
           #EXECUTE insert_prep USING  #FUN-D40020 mark
            EXECUTE insert_prep3 USING #FUN-D40020 add
              sr.oox01,sr.oox02,sr.oox05,sr.oox07,sr.oox03v,sr.oox03,sr.oox04,
              sr.oox08,sr.oox09,sr.oox10,l_azi04,l_azi05,l_azi07
              ,l_oox03v_a    #FUN-D40129 add
 
           FOREACH gxrx600_curs3 USING sr.oox01 INTO gum.*                                                                               
              SELECT azi05 INTO l_azi05 FROM azi_file                                                                                    
              WHERE azi01=gum.oox05                                                                                                     
              IF SQLCA.sqlcode THEN                                                                                                      
                  LET l_azi05 = g_azi05    #使用本國幣別                                                                                  
              END IF
              EXECUTE insert_prep1 USING
                 sr.oox01,gum.oox05,gum.oox10,l_azi05
           END FOREACH
#No.FUN-7B0026--end
        END FOREACH
        #FUN-D40020--add--str--
        LET l_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " (oox01,oox02,oox05,oox03v,oox03v_a,oox08,oox09,oox10)",   #FUN-D40129 add oox03v_a
                  " SELECT oox01,oox02,oox05,oox03v,oox03v_a,",           #FUN-D40129 add oox03v_a
                  "        SUM(oox08) oox08,SUM(oox09) oox09,SUM(oox10) oox10",
                  "   FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                  "  GROUP BY oox01,oox02,oox05,oox03v,oox03v_a "   #FUN-D40129 add oox03v_a
        PREPARE ins_pr FROM l_sql          
        EXECUTE ins_pr
        LET l_sql=" MERGE INTO ",g_cr_db_str CLIPPED,l_table CLIPPED," o ",
                  "      USING (SELECT DISTINCT oox01,oox02,oox05,oox07,azi04,azi05,azi07 ",
                  "               FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                  "              ) n ",
                  "         ON (o.oox01 = n.oox01 AND o.oox02 = n.oox02 AND o.oox05=n.oox05 ) ",
                  " WHEN MATCHED ",
                  " THEN ",
                  "    UPDATE ",
                  "       SET o.oox07 = n.oox07, o.azi05 = n.azi05,o.azi07 = n.azi07 "
        PREPARE upd_pr FROM l_sql
        EXECUTE upd_pr
        #FUN-D40020--add--end 
#       FINISH REPORT gxrx600_rep                              #No.FUN-7B0026
     ELSE                          #明細報表
        FOREACH gxrx600_curs2 INTO sr1.*
           IF SQLCA.sqlcode != 0 THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
           END IF
#          OUTPUT TO REPORT gxrx600_rep(sr1.*)                 #No.FUN-7B0026
#No.FUN-7B0026--start--                                                                                                             
           SELECT azi04,azi05,azi07 INTO l_azi04,l_azi05,l_azi07 FROM azi_file       #FUN-870151 Add azi07                                                                     
              WHERE azi01=sr1.oox05    #MOD-BA0022 mod sr -> sr1
           IF SQLCA.sqlcode THEN                                                                                                    
              LET l_azi04 = g_azi04                                                                                                 
              LET l_azi05 = g_azi05    #使用本國幣別
              LET l_azi07 = g_azi07                                                                                                                                  
           END IF                                                                    #FUN-870151                                                
           LET l_oox03v_a = cl_gr_getmsg('gre-366',g_lang,sr1.oox03v)   #FUN-D40129
           EXECUTE insert_prep USING                                                                                                
              sr1.oox01,sr1.oox02,sr1.oox05,sr1.oox07,sr1.oox03v,sr1.oox03,
              sr1.oox04,sr1.oox08,sr1.oox09,sr1.oox10,l_azi04,l_azi05,l_azi07                                                                            
              ,l_oox03v_a    #FUN-D40129 add
        END FOREACH   #MOD-8B0099 add
 
        FOREACH gxrx600_curs4_1 INTO sr1.oox01,sr1.oox02   #MOD-8B0099 add
           FOREACH gxrx600_curs4 USING sr1.oox01,sr1.oox02 INTO gum.*                                                                     
              SELECT azi05 INTO l_azi05 FROM azi_file                                                                                   
              WHERE azi01=gum.oox05                                                                                                    
              IF SQLCA.sqlcode THEN                                                                                                     
                 LET l_azi05 = g_azi05    #使用本國幣別
              END IF
              EXECUTE insert_prep2 USING
               sr1.oox01,sr1.oox02,gum.oox05,gum.oox10,l_azi05
           END FOREACH
#No.FUN-7B0026--end
        END FOREACH
#       FINISH REPORT gxrx600_rep                              #No.FUN-7B0026
     END IF
#No.FUN-580110 --end--
#No.FUN-7B0026--start--
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     IF tm.b = "1"  THEN 
         LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                   "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
     ELSE 
###XtraGrid###         LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",                                                            
###XtraGrid###                   "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED
     END IF
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'oox03,oox03v') 
             RETURNING tm.wc
        LET g_str=tm.wc
     END IF
###XtraGrid###     LET g_str = g_str,";",tm.b
###XtraGrid###     CALL cl_prt_cs3('gxrx600',l_name,l_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    #FUN-D40020--add--str-
    IF tm.b='1' THEN
       LET g_xgrid.template ='gxrx600'
       LET g_xgrid.grup_field = "oox02,oox05"
    ELSE
       LET g_xgrid.template ='gxrx600_1'
       LET g_xgrid.grup_field = "oox05"
    END IF
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc 
    #FUN-D40020--add--end
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-7B0026--end       
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#No.FUN-7B0026--start--
# REPORT gxrx600_rep(sr)
##No.FUN-580010 --start--
#   DEFINE l_last_sw    LIKE type_file.chr1       #NO.FUN-680145 VARCHAR(1)
#   DEFINE l_azi04      LIKE azi_file.azi04
#   DEFINE l_azi05      LIKE azi_file.azi05
#   DEFINE sr           RECORD
#                          oox01   LIKE  oox_file.oox01,
#                          oox02   LIKE  oox_file.oox02,
#                          oox03   LIKE  oox_file.oox03,
#                          oox03v  LIKE  oox_file.oox03v,
#                          oox04   LIKE  oox_file.oox04,
#                          oox05   LIKE  oox_file.oox05,
#                          oox07   LIKE  oox_file.oox07,
#                          oox08   LIKE  oox_file.oox08,
#                          oox09   LIKE  oox_file.oox09,
#                          oox10   LIKE  oox_file.oox10
#                       END RECORD
#   DEFINE gum          RECORD
#                          oox05   LIKE  oox_file.oox05,
#                          oox10   LIKE  oox_file.oox10
#                       END RECORD
#
#   OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin  #FUN-580098
#         PAGE LENGTH g_page_line
#   ORDER BY sr.oox01,sr.oox02,sr.oox05,sr.oox03v,sr.oox03
 
#   FORMAT
#    PAGE HEADER
#       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##TQC-770078.....begin
#      IF tm.b = '1' THEN
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                  
#      ELSE
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[15]))/2)+1,g_x[15] CLIPPED
#      END IF
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]                  
##TQC-770078.....end
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED, pageno_total
#      IF tm.b='2' THEN
#         PRINT g_x[16] CLIPPED,sr.oox01 USING '####',' ',
#               g_x[17] CLIPPED,sr.oox02 USING '##'
#      ELSE
#         PRINT
#      END IF
#      PRINT g_dash[1,g_len]
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#      LET l_last_sw ='n'
 
#   BEFORE GROUP OF sr.oox01
#      PRINTX name=D1 COLUMN g_c[31],sr.oox01 USING '&&&&';
 
#   BEFORE GROUP OF sr.oox02
#      PRINTX name=D1 COLUMN g_c[32],sr.oox02 USING '&&';
 
#   BEFORE GROUP OF sr.oox05
#      SELECT azi04,azi05 INTO l_azi04,l_azi05 FROM azi_file
#       WHERE azi01=sr.oox05
#      IF SQLCA.sqlcode THEN
#         LET l_azi04 = g_azi04
#         LET l_azi05 = g_azi05    #使用本國幣別
#      END IF
#      #No:7952
#      PRINTX name=D1 COLUMN g_c[33],sr.oox05 CLIPPED,
#                     COLUMN g_c[34],cl_numfor(sr.oox07,34,l_azi04);
 
#   BEFORE GROUP OF sr.oox03v
#      IF tm.b='1' THEN
#       PRINTX name=D1 COLUMN g_c[35],sr.oox03v USING '####' CLIPPED;
#      END IF
 
#   AFTER GROUP OF sr.oox03v
#      IF tm.b='1' THEN
#       IF sr.oox03v = '1' THEN
#          PRINTX name=D1 COLUMN g_c[35],'1*';
#       ELSE
#          PRINTX name=D1 COLUMN g_c[35],'2*';
#       END IF
#       PRINTX name=D1 COLUMN g_c[38],cl_numfor(GROUP SUM(sr.oox08),38,l_azi05),
#                      COLUMN g_c[39],cl_numfor(GROUP SUM(sr.oox09),39,l_azi05),
#                      COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)
#      END IF
 
#   ON EVERY ROW
#     IF tm.b='2' THEN
#       IF sr.oox04 IS NULL OR sr.oox04 = 0 THEN
#          PRINTX name=D1 COLUMN g_c[36],sr.oox03 CLIPPED;
#       ELSE
#          PRINTX name=D1 COLUMN g_c[36],sr.oox03 CLIPPED,
#                        COLUMN g_c[37],sr.oox04 USING "###&" CLIPPED; #FUN-590118
#       END IF
#       PRINTX name=D1 COLUMN g_c[38],cl_numfor(sr.oox08,38,l_azi04),
#                     COLUMN g_c[39],cl_numfor(sr.oox09,39,l_azi04),
#                     COLUMN g_c[40],cl_numfor(sr.oox10,40,l_azi04)
#     END IF
 
#   AFTER GROUP OF sr.oox05
#      PRINT g_dash2[1,g_len]
#      IF tm.b='1' THEN
#         PRINTX name=S1
#             COLUMN g_c[34],g_x[20] CLIPPED,
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)
#      ELSE
#         PRINTX name=S1
#             COLUMN g_c[34],g_x[19] CLIPPED,
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)
#      END IF
#      PRINT ''
 
#   AFTER GROUP OF sr.oox02
#       PRINTX name=S1
#             COLUMN g_c[34],g_x[21] CLIPPED,
#             COLUMN g_c[40],cl_numfor(GROUP SUM(sr.oox10),40,l_azi05)
#       PRINT ''
#      IF tm.b='2' THEN
#       PRINTX name=S1 COLUMN g_c[34],g_x[18] CLIPPED;
#       FOREACH gxrx600_curs4 USING sr.oox01,sr.oox02 INTO gum.*
#          SELECT azi05 INTO l_azi05 FROM azi_file
#           WHERE azi01=gum.oox05
#          IF SQLCA.sqlcode THEN
#             LET l_azi05 = g_azi05    #使用本     e
#          END IF
#          PRINTX name=S1 COLUMN g_c[35],gum.oox05 CLIPPED,
#                         COLUMN g_c[40],cl_numfor(gum.oox10,40,l_azi05)
#       END FOREACH
#      END IF
 
 
#   ON LAST ROW
#     IF tm.b='1' THEN
#      PRINT ''
#      PRINTX name=S1 COLUMN g_c[34],g_x[18] CLIPPED;
#      FOREACH gxrx600_curs3 USING sr.oox01 INTO gum.*
#         SELECT azi05 INTO l_azi05 FROM azi_file
#          WHERE azi01=gum.oox05
#         IF SQLCA.sqlcode THEN
#            LET l_azi05 = g_azi05    #使用本國幣別
#         END IF
#         PRINTX name=S1 COLUMN g_c[34],gum.oox05 CLIPPED,
#                        COLUMN g_c[40],cl_numfor(gum.oox10,40,l_azi05)
#      ##
#      END FOREACH
#     END IF
##No.FUN-580110 --end--
#      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#          CALL cl_wcchp(tm.wc,'oox03')
#               RETURNING tm.wc
#          PRINT g_dash[1,g_len]
#              #TQC-630166
#              #IF tm.wc[001,070] > ' ' THEN                      # for 80
#              #   PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#              #IF tm.wc[071,140] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#              #IF tm.wc[141,210] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#              #IF tm.wc[211,280] > ' ' THEN
#              #   PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#              CALL cl_prt_pos_wc(tm.wc)
#             #END TQC-630166
#       END IF
#       PRINT g_dash[1,g_len]
#       LET l_last_sw = 'y'
#       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#    PAGE TRAILER
#       IF l_last_sw = 'n' THEN
#          PRINT g_dash[1,g_len]
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE SKIP 2 LINE
#       END IF
#  END REPORT
#Patch....NO.TQC-610035 <> #
#No.FUN-7B0026--end
 
 
 
 
 
 
 
 
 


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
