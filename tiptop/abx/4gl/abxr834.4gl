# Prog. Version..: '5.30.06-13.03.14(00006)'     #
#
# Pattern name...: abxr834.4gl
# Descriptions...: 在製品折合原料清冊作業(abxr834)
# Date & Author..:
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin放寬ima021
# Modify.........: No.FUN-550033 05/05/19 By day   單據編號加大
# Modify.........: No.MOD-580323 05/08/28 By jackie 將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換  
# Modify.........: No.FUN-690108 06/10/13 By xumin cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-740021 07/06/28 By xufeng 將報表改為p_zaa寫法 
#                                                   將報表改為Crystal Report寫法
# Modify.........: No.TQC-860021 08/06/11 By Sarah INPUT漏了ON IDLE控制
# Modify.........: No.FUN-850089 08/06/09 By TSD.liquor CR報表修正
# Modify.........: No.FUN-890101 08/09/24 By dxfwo  CR 追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-CB0230 12/12/26 By Elise 修正程式
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_level LIKE type_file.num5          #No.FUN-680062         smallint
   DEFINE p_exist LIKE type_file.chr1          #No.FUN-680062         VARCHAR(1)
   DEFINE tm  RECORD                           # Print condition RECORD
              wc     LIKE type_file.chr1000,   # Where condition      #No.FUN-680062  VARCHAR(1000)    
              yy     LIKE type_file.chr4,      #No.FUN-680062         VARCHAR(4)    
              ima15  LIKE ima_file.ima15,      #No.FUN-680062         VARCHAR(1)
              a      LIKE type_file.chr1,      #No.FUN-680062         VARCHAR(1)
              b      LIKE type_file.chr1       #No.FUN-680062         VARCHAR(1)
              END RECORD,
              l_outbill  LIKE oga_file.oga01     # 出貨單號,傳參數用
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680062 smallint
DEFINE   l_table         STRING                  #No.FUN-740021
DEFINE   l_sql           STRING                  #No.FUN-740021
DEFINE   l_str           STRING                  #No.FUN-740021
DEFINE   g_sql           STRING                  #No.FUN-740021
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690108
 
 
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.wc= ARG_VAL(1)
  
   #定義零時表
   #FUN-740021  --begin
   LET g_sql = "bwb01.bwb_file.bwb01,",
               "bwb02.bwb_file.bwb02,",
               "bwb03.bwb_file.bwb03,",
               "bwb011.bwb_file.bwb011,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "levela.type_file.num5,",
               "bwe03.bwe_file.bwe03,",
               "imaa02.ima_file.ima02,",
               "imaa021.ima_file.ima021,",
               "ima15.ima_file.ima15,",
               "bne08.bne_file.bne08,",
               "bwe04.bwe_file.bwe04"
 
    LET l_table = cl_prt_temptable('abxr834',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                "(bwb01,bwb02,bwb03,bwb011,ima02,ima021)",
                " VALUES(?,?,?,?,?, ?)"
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #MOD-CB0230 minus 1 ?
    PREPARE insert_prep1 FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF
    LET g_sql = "UPDATE ds_report.",l_table CLIPPED,                                                                           
                " SET levela=?,bwe03=?,imaa02=?,imaa021=?,ima15=?,bne08=?,bwe04=?",
                " WHERE bwb01=? AND bwb011=?"
    PREPARE update_prep FROM g_sql 
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF
   #FUN-740021  --end  
   IF cl_null(tm.wc)
   THEN
       CALL abxr834_tm(0,0)             # Input print condition
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
END MAIN
 
FUNCTION abxr834_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680062 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680062 VARCHAR(1000)
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 6 LET p_col = 18
   ELSE
      LET p_row = 5 LET p_col = 18
   END IF
 
   OPEN WINDOW abxr834_w AT p_row,p_col WITH FORM "abx/42f/abxr834"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
WHILE TRUE
   LET tm.wc = ""
   LET tm.yy = YEAR(TODAY)-1
   LET tm.ima15 = "1"
   LET tm.a   = '4'
   LET tm.b   = 'N'
 
   CONSTRUCT BY NAME tm.wc ON bwb01
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
      LET INT_FLAG = 0 CLOSE WINDOW abxr834_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
      EXIT PROGRAM
   END IF
 
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   INPUT tm.yy,tm.ima15,tm.a,tm.b WITHOUT DEFAULTS
          FROM formonly.yy,ima15,formonly.a,formonly.b
      #No.FUN-580031 --start--
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      AFTER FIELD ima15
         IF tm.ima15 NOT MATCHES "[12]" THEN
            NEXT FIELD ima15
         END IF
      AFTER FIELD a
         IF tm.a  NOT MATCHES "[1234]" THEN
           NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b  NOT MATCHES "[YN]" THEN
           NEXT FIELD b
         END IF
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE INPUT        #TQC-860021
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 EXIT WHILE
   END IF
   CALL cl_wait()
   CALL abxr834()
   ERROR ""
END WHILE
   CLOSE WINDOW abxr834_w
END FUNCTION
 
FUNCTION abxr834()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name             #No.FUN-680062  VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0062
          l_sql     LIKE type_file.chr1000,       #No.FUN-680062  VARCHAR(1000)
          xima15    LIKE ima_file.ima15,          #No.FUN-680062  VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.FUN-680062  smallint
          l_za05    LIKE za_file.za05,            #No.FUN-680062  VARCHAR(40)
          bwb       RECORD LIKE bwb_file.*,
          bwc       RECORD LIKE bwc_file.*,
          #No.FUN-740021  --begin
          bwe       RECORD LIKE bwe_file.*,       
          l_ima02   LIKE ima_file.ima02,          
          l_ima021  LIKE ima_file.ima021,         
          l_imaa02  LIKE ima_file.ima02,          
          l_imaa021 LIKE ima_file.ima021,         
          l_ima15   LIKE ima_file.ima15,          
          l_ima106  LIKE ima_file.ima106,         
          l_flag    LIKE type_file.num5,          
          l_bne08   LIKE bne_file.bne08           
          #No.FUN-740021  --end   
     DEFINE l_str1,l_str2  STRING      #No.MOD-580323
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     DECLARE abxr834_za_cur CURSOR FOR
             SELECT za02,za05 FROM za_file
              WHERE za01 = "abxr834" AND za03 = g_rlang
     FOREACH abxr834_za_cur INTO g_i,l_za05
        LET g_x[g_i] = l_za05
     END FOREACH
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abxr834'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 132 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
     CALL cl_del_data(l_table)        #No.FUN-740021
     LET l_sql="SELECT bwb_file.* ",
              "  FROM bwb_file ",
              " WHERE ",tm.wc clipped
 
     PREPARE abxr834_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690108
        EXIT PROGRAM
     END IF
     DECLARE abxr834_curs1 CURSOR FOR abxr834_prepare1
#No.FUN-740021  --begin
     LET g_sql="SELECT bwe03,sum(bwe04) FROM bwe_file,bwc_file",
               " WHERE bwe00 = 'W' ",
               " AND   bwe01 =  ? ",
               " AND   bwe01 =  bwc01 ",
               " AND   bwe03 =  bwc03 ",
               " AND   bwe03 <> ? ",
               " GROUP BY bwe00,bwe01,bwe03 "
    PREPARE abxr834_prepare2 FROM g_sql
    DECLARE abxr834_curs2 CURSOR FOR  abxr834_prepare2
 
    FOREACH abxr834_curs1 INTO bwb.*
      IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
      END IF
      IF bwb.bwb04 = 0 THEN 
         CONTINUE FOREACH 
      END IF
      IF tm.ima15 = "1" THEN
         SELECT ima15 INTO xima15 FROM ima_file WHERE ima01 = bwb.bwb03
         IF xima15 <> "Y"
         THEN
             continue foreach
         END IF
      END IF
      IF tm.b='N' THEN
         LET l_cnt = 0
         SELECT count(*) INTO l_cnt FROM bne_file WHERE bne01 = bwb.bwb03
         IF l_cnt = 0 THEN 
            CONTINUE FOREACH 
         END IF
      END IF
      SELECT ima02,ima021 INTO l_ima02,l_ima021 
        FROM ima_file 
       WHERE ima01=bwb.bwb03
      EXECUTE insert_prep USING bwb.bwb01,bwb.bwb02,bwb.bwb03,bwb.bwb011,
                                l_ima02,l_ima021
      LET l_flag=1
      FOREACH abxr834_curs2 USING bwb.bwb01,bwb.bwb03 INTO bwe.bwe03,bwe.bwe04 
        #CALL bom(0,bwb.bwb01,bwe.bwe03) RETURNING g_level        #MOD-CB0230 mark
         CALL r834_bom(0,bwb.bwb03,bwe.bwe03) RETURNING g_level   #MOD-CB0230
         SELECT ima02,ima021,ima15,ima106 INTO l_imaa02,l_imaa021,l_ima15,l_ima106
           FROM ima_file WHERE ima01 = bwe.bwe03
         IF tm.ima15 = "1" AND l_ima15 <> "Y" THEN
             CONTINUE FOREACH
         END IF
         IF tm.a<>'4' AND tm.a <> l_ima106 THEN
             CONTINUE FOREACH
         END IF
         DECLARE selbne08 CURSOR FOR 
         SELECT bne08 FROM bne_file,bnd_file 
          WHERE bnd01 = bne01 
            AND bnd01 = bwb.bwb03 
            AND bne05 = bwe.bwe03
 
         FOREACH selbne08 INTO l_bne08
             EXIT FOREACH
         END FOREACH
         IF l_bne08 <= 0 OR l_bne08 IS NULL THEN
           CONTINUE FOREACH
         END IF
         IF l_flag=1 THEN
#No.FUN-890101
#            EXECUTE update_prep USING  g_level,bwb.bwb03,l_ima02,l_ima021,l_ima15,
#                                       l_bne08,bwe.bwe04,bwb.bwb01,bwb.bwb011
#            LET l_flag=l_flag+1
#         ELSE
#            EXECUTE insert_prep1 USING bwb.bwb01,bwb.bwb02,bwb.bwb03,bwb.bwb011,
#                                       l_ima02,l_ima021,g_level,bwb.bwb03,l_imaa02,
#                                       l_imaa021,l_ima15,l_bne08,bwe.bwe04
#No.FUN-890101
            #FUN-850089 TSD.liquor mod bwb.bwb03,l_ima02,l_ima021 
            #改成 bwe.bwe03,l_imaa02,l_imaa021 才對
            #EXECUTE update_prep USING  g_level,bwb.bwb03,l_ima02,l_ima021,l_ima15,
            EXECUTE update_prep USING  g_level,bwe.bwe03,l_imaa02,l_imaa021,l_ima15,
                                       l_bne08,bwe.bwe04,bwb.bwb01,bwb.bwb011
            LET l_flag=l_flag+1
         ELSE
            EXECUTE insert_prep1 USING bwb.bwb01,bwb.bwb02,bwb.bwb03,bwb.bwb011,
                                       #FUN-850089 TSD.liquor mod bwb.bwb03 改成 bwe.bwe03 才對
                                       #l_ima02,l_ima021,g_level,bwb.bwb03,l_imaa02,
                                       l_ima02,l_ima021,g_level,bwe.bwe03,l_imaa02,
                                       l_imaa021,l_ima15,l_bne08,bwe.bwe04
         END IF
      END FOREACH
    END FOREACH
#     LET l_str="tm.wc"
    #FUN-850089 列印選擇條件要加上
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'bwb01')
             RETURNING l_str
     ELSE
        LET l_str = ''
     END IF
     LET l_str = l_str,";",tm.yy
    #FUN-850089 add end 
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('abxr834','abxr834',l_sql,l_str)
#No.FUN-740021  --end  
 
#No.FUN-740021   --begin
#     CALL cl_outnam('abxr834') RETURNING l_name
#     START REPORT abxr834_rep TO l_name
#
#     LET g_pageno = 0
#     FOREACH abxr834_curs1 INTO bwb.*
#     IF SQLCA.sqlcode != 0 THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
#       IF bwb.bwb04 = 0 THEN continue FOREACH END IF
#       IF tm.ima15 = "1"
#       THEN
#           SELECT ima15 INTO xima15 FROM ima_file WHERE ima01 = bwb.bwb03
#           IF xima15 <> "Y"
#           THEN
#               continue foreach
#           END IF
#       END IF
##     ------ 無保稅BOM 是否列印
#      IF tm.b='N' THEN
#         let l_cnt = 0
#         select count(*) into l_cnt from bne_file where bne01 = bwb.bwb03
#         if l_cnt = 0 then continue foreach end if
#
#     #   select count(*) into l_cnt  from bwe_file,bwc_file
#     #        where bwe00 = "W"
#     #              AND   bwe01 =  bwb.bwb01
#     #              AND   bwe01 =  bwc01
#     #              AND   bwe03 =  bwc03
#     #              AND   bwe03 <> bwb.bwb03
#     #   if cl_null(l_cnt) then continue foreach end if
#      END IF
##     --------------------------
##No.MOD-580323 --start--
#       CALL cl_getmsg('abx-010',g_lang) RETURNING l_str1
#       CALL cl_getmsg('abx-832',g_lang) RETURNING l_str2
#       MESSAGE l_str1,bwb.bwb01,l_str2,bwb.bwb03
##      MESSAGE "盤點標簽=",bwb.bwb01," 料號=",bwb.bwb03
##No.MOD-580323 --end--
#       CALL ui.Interface.refresh()
#       OUTPUT TO REPORT abxr834_rep(bwb.*)
#     END FOREACH
#
#     FINISH REPORT abxr834_rep
#
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-740021  --end
END FUNCTION
##No.FUN-740021  --begin
#REPORT abxr834_rep(bwb)
#   DEFINE l_last_sw   LIKE type_file.chr1,      #No.FUN-680062     VARCHAR(1) 
#          g_count  LIKE type_file.num5,         #No.FUN-680062     smallint 
#          x_ima25 LIKE ima_file.ima25,
#          x_ima15 LIKE ima_file.ima15,
#          x_ima02 LIKE ima_file.ima02,
#          x_ima021 LIKE ima_file.ima021,
#          x_ima106 LIKE ima_file.ima106,
#          x_bne08 LIKE bne_file.bne08,
#          x_bnd02 LIKE bnd_file.bnd02,
#          x_bnd04 LIKE bnd_file.bnd04,
#          xx  LIKE type_file.chr1000,           #No.FUN-680062   VARCHAR(100)   
#          bwb RECORD LIKE bwb_file.*,
#          bwe RECORD LIKE bwe_file.*
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY bwb.bwb01
#
#  FORMAT
#   PAGE HEADER
#      LET xx        = "財政部台北關稅局監管大騰電子企業股份有限公司立德廠",
#                      "保稅工廠"
#    # LET g_x[1]    = (tm.yy-1911) USING "&&","年度 在製品盤存數折合原料分析清表"#No.FUN-740021
#      LET g_x[1]    = (tm.yy-1911) USING "&&",g_x[9]," ",g_x[1] CLIPPED#No.FUN-740021
#    # LET g_x[3]    = "頁次:"  #No.FUN-740021
#    # LET g_len     = 110  #No.FUN-740021
#      #PRINT COLUMN (g_len-FGL_WIDTH(xx)),xx
#      PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      PRINT
#      PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#      LET g_pageno = g_pageno + 1
#      PRINT  COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#      LET l_last_sw = "n"
#      #No.FUN-740021  --begin
#      PRINT g_dash
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34]
#      PRINTX name=H2 g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#      #No.FUN-740021  --end  
#
#   BEFORE GROUP OF bwb.bwb01
#    #No.FUN-740021  --begin
#    # PRINT "=========================================================================================================="
#    # PRINT " 工單號碼        盤點標籤   料件編號        上階品名規格                         "
#    # PRINT "1.3.5.7.9 下階用料           下階用料品名規格                               保稅否 單位用量       折合數量"
#    # PRINT "--------- ------------------------------------------------------------------------ ----------- -----------"
#    #No.FUN-740021  --end  
#    select ima02,ima021,ima25,ima15 into x_ima02,x_ima021,x_ima25,x_ima15
#    from ima_file where ima01 = bwb.bwb03
#  # select bnd04 into x_bnd04 FROM bnd_file where bnd01 = bwb.bwb03
#
#       declare selbnd01 cursor for
#       select bnd02,bnd04 from bnd_file
#       where bnd01 = bwb.bwb03
#       order by bnd02 desc
#       foreach selbnd01 into x_bnd02,x_bnd04
#           exit foreach
#       end foreach
#
##No.FUN-740021  --begin
##No.FUN-550033-begin
##   PRINT COLUMN 01,bwb.bwb02   ,
##         COLUMN 16,bwb.bwb01   ,
##         COLUMN 29,bwb.bwb03   ,
##         COLUMN 45,x_ima02 clipped ,' ',x_ima021 clipped
##No.FUN-740021  --end  
##No.FUN-740021  --begin
#    PRINTX name=D1 COLUMN g_c[31],bwb.bwb02   ,
#                   COLUMN g_c[32],bwb.bwb01   ,
#                   COLUMN g_c[33],bwb.bwb03   ,
#                   COLUMN g_c[34],x_ima02 clipped ,'/',x_ima021 clipped
##No.FUN-740021  --end  
#
#   ON EVERY ROW
#    LET g_count = 1
#    declare selbwe cursor for
#       select bwe00,bwe01,bwe03,sum(bwe04) from bwe_file,bwc_file
#    where bwe00 = "W"
#    AND   bwe01 =  bwb.bwb01
#    AND   bwe01 =  bwc01
#    AND   bwe03 =  bwc03
#    AND   bwe03 <> bwb.bwb03
#    GROUP BY bwe00,bwe01,bwe03
#
#    foreach selbwe into bwe.bwe00,bwe.bwe01,bwe.bwe03,bwe.bwe04
#       select ima02,ima021,ima25,ima15,ima106
#            into x_ima02,x_ima021,x_ima25,x_ima15 ,x_ima106
#       from ima_file where ima01 = bwe.bwe03
#       IF tm.ima15 = "1" AND x_ima15 <> "Y"
#       THEN
#           continue foreach
#       END IF
#       IF tm.a<>'4' AND tm.a <> x_ima106 THEN
#           continue foreach
#       END IF
#       declare selbne08 cursor for
#       select bnd02,bne08 from bne_file,bnd_file
#       where bnd01 = bwb.bwb03
#       and   bnd01 = bne01
#       and   bne05 = bwe.bwe03
#       order by bnd02 desc
#       foreach selbne08 INTO x_bnd02,x_bne08
#           exit foreach
#       end foreach
#       IF x_bne08 = 0
#       THEN
#           continue foreach
#       END IF
#       LET g_level = 0
#       LET p_exist  = "N"
#       CALL bom(0,bwb.bwb01,bwe.bwe03) returning g_level
#
#       declare selbnd02 cursor for
#       select bnd02,bnd04 from bnd_file
#       where bnd01 = bwe.bwe03
#       order by bnd02 desc
#       foreach selbnd02 into x_bnd02,x_bnd04
#           exit foreach
#       end foreach
#       if x_bne08 > 0 THEN
#       
#       #No.FUN-740021  --begin
#       #  PRINT COLUMN g_level,g_level,
#       #        COLUMN 11,bwe.bwe03,
#       #        COLUMN 30,x_ima02,
#       #         COLUMN 53,x_ima021 CLIPPED                ,  #MOD-4A0238
#       #        COLUMN 78,x_ima15                  ,
#       #        COLUMN 85,x_bne08  using "###,##&.&&",
#       #        COLUMN 95,bwe.bwe04 using "#,###,##&.&&"
#       #No.FUN-740021  --end   
#       #No.FUN-740021  --begin
#          PRINTX name=D2 COLUMN g_c[35],g_level,
#                         COLUMN g_c[36],bwe.bwe03 ,
#                         COLUMN g_c[37],x_ima02,"/",x_ima021 CLIPPED  ,  #MOD-4A0238
#                         COLUMN g_c[38],x_ima15 ,
#                         COLUMN g_c[39],x_bne08  using "###,##&.&&",
#                         COLUMN g_c[40],bwe.bwe04 using "#,###,##&.&&"
#       #No.FUN-740021  --end  
#         end if
#   end foreach
#
#   AFTER GROUP OF bwb.bwb01
#   PRINT
#
#   ON LAST ROW
##   PRINT "==================================================================================" #No.FUN-740021  --begin
##        PRINT "=================================================================================================================="#No.FUN-740021  --begin
#    #No.FUN-740021  --begin
#    PRINT g_dash
#    PRINT COLUMN 1,g_x[4],
#          COLUMN g_len-9,g_x[7]
#    #No.FUN-740021  --end  
#      LET l_last_sw = 'n'
#
#   PAGE TRAILER
#      IF l_last_sw = 'y'
#      THEN
#    PRINT g_dash
#    PRINT COLUMN 1,g_x[4],
#          COLUMN g_len-9,g_x[6]
#   #     PRINT "=================================================================================================================="#No.FUN-740021  
#   #     PRINT "(abxr834)                                                                                            (接 下 頁) "#No.FUN-740021 
#      ELSE
#        SKIP 2 LINE
#      END IF
##No.FUN-550033-end
#
#END REPORT
#No.FUN-740021  --end
 
#MOD-CB0230---mark---S
#function bom(p_level,a1,a2)
#  DEFINE a1         LIKE bne_file.bne01                       #No.FUN-680062 VARCHAR(20) 
#  DEFINE a2,a3      LIKE bne_file.bne05                       #No.FUN-680062 VARCHAR(20) 
#  DEFINE p_level    LIKE type_file.num5                       #No.FUN-680062 smallint 
#  DEFINE l_n,ii,jj  LIKE type_file.num5                       #No.FUN-680062 smallint 
#  DEFINE KK ARRAY[500] OF LIKE  type_file.chr20               #No.FUN-680062 VARCHAR(20)
# 
#  LET p_level = p_level + 1
#  LET ii = 1
#  FOR ii = 1 TO 500
#      LET KK[ii] = " "
#  END FOR
#  LET ii = 1
# 
#  declare selxxx cursor for
#     select bne05 from bne_file
#  where bne01 = a1
#  foreach selxxx into a3
#      IF a3 is null then let a3 = " " end if
#      LET KK[ii] = a3
#      LET ii = ii + 1
#  end foreach
#  let  jj = ii - 1
#  call set_count(jj)
# 
#  for ii = 1 to jj
#      if a2 = kk[ii]
#      then
#          let p_exist = "Y"
#          return p_level
#      end if
#  end for
# 
# IF p_exist = "N"
# then
#  for ii = 1 TO jj
# 
#          select count(*) into l_n from bnd_file where bnd01 = kk[ii]
#          if l_n > 0
#          then
#              IF p_exist = "N"
#              THEN
#               call bom(p_level,kk[ii],a2) returning p_level
#               IF p_exist = "N" AND p_level > 0
#               THEN
#                   LET p_level = p_level - 1
#               END IF
#              END IF
#          end if
#  end for
# end if
# return p_level
#end function
#MOD-CB0230---mark---E

#MOD-CB0230------S
FUNCTION r834_bom(p_level,p_bwb03,p_bwe03)
 DEFINE p_bwb03      LIKE bwb_file.bwb03,
        p_bwe03      LIKE bwe_file.bwe03,
        l_flag       LIKE type_file.chr1,
        p_level      LIKE type_file.num5,
        l_bne05      DYNAMIC ARRAY OF LIKE bne_file.bne05,
        i,n,l_cnt    LIKE type_file.num5


  LET p_level = p_level + 1

  DECLARE r834_bne05 CURSOR FOR
   SELECT bne05 FROM bne_file WHERE bne01 = p_bwb03
  LET i=1
  FOREACH r834_bne05 INTO l_bne05[i]
     IF cl_null(l_bne05[i]) THEN
        LET l_bne05[i] = ' '
     END IF
     LET i=i+1
  END FOREACH

  FOR n=1 TO i-1
     IF p_bwe03 = l_bne05[i] THEN
        LET l_flag ='Y'
     END IF
  END FOR

  IF l_flag ='N' THEN
     FOR n=1 TO i-1
        SELECT COUNT(*) INTO l_cnt FROM bnd_file WHERE bnd01 = l_bne05[i]
        IF l_cnt > 0 THEN
           IF l_flag ='N' THEN
              CALL r834_bom(p_level,l_bne05[i],p_bwe03)
                 RETURNING p_level
              IF p_level > 0 THEN
                 LET p_level = p_level - 1
              END IF
           END IF
        END IF
     END FOR
  END IF
  RETURN p_level

END FUNCTION
#MOD-CB0230------E
#Patch....NO.TQC-610035 <001,002> #
