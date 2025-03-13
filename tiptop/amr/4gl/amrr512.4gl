# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: amrr512.4gl
# Descriptions...: MRP 模擬明細表
# Input parameter:
# Return code....:
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-510046 05/03/01 By pengu 修改報表單價、金額欄位寬度
# Modify.........: No.MOD-530457 05/03/26 By pengu  在報表段將列印資料存入demdan1，supply1兩陣列中，以防止列印資料無法對齊
# Modify.........: No.FUN-550055 05/05/24 By day   單據編號加大
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.FUN-580014 05/08/17 By jackie 轉XML
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610074 06/01/21 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/21 By xumin ARRAY 改為DYNAMIC ARRAY
# Modify.........: No.MOD-6A0049 06/12/13 By pengu 報表供給段有問題 ,會有上一筆的殘留資料
# Modify.........: No.TQC-750041 07/05/17 By mike 報表格式修改
# Modify.........: No.TQC-770031 07/07/05 By chenl  報表格式修改。
# Modify.........: No.MOD-7C0067 07/12/10 By Pengu 在Informix環境中執行會出現 database index could not be created的錯誤訊息
# Modify.........: No.FUN-880057 08/05/21 By mike 報表輸出方式轉為Crystal Reports
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910  
# Modify.........: No.TQC-960291 09/06/23 By chenmoyan 多個特性代碼時，STATUS會報錯
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                  # Print condition RECORD
              wc        LIKE type_file.chr1000,   #NO.FUN-680082 VARCHAR(600)
              n         LIKE type_file.chr1,      #NO.FUN-680082 VARCHAR(1)
              ver_no    LIKE mss_file.mss_v,      #NO.FUN-680082 VARCHAR(2)
              part1     LIKE bma_file.bma01,    #FUN-560011         #NO.FUN-680082  VARCHAR(40)
              part2     LIKE ima_file.ima01,    #FUN-560011         #NO.FUN-680082  VARCHAR(40)
              print_adj LIKE type_file.chr1,      #NO.FUN-680082 VARCHAR(1)
              print_plp LIKE type_file.chr1,      #NO.FUN-680082 VARCHAR(1)
              order_way LIKE type_file.chr1,      #NO.FUN-680082 VARCHAR(1)
              more      LIKE type_file.chr1       # Input more condition(Y/N)    #NO.FUN-680082 VARCHAR(1)
              END RECORD,
          g_msg1        LIKE type_file.chr1000        #FUN-560011
 
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose   #NO.FUN-680082 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #NO.FUN-680082 VARCHAR(72)
DEFINE   l_table         STRING                       #No.FUN-880057  
DEFINE   g_sql           STRING                       #No.FUN-880057
DEFINE   g_str           STRING                       #No.FUN-880057 
 
MAIN 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690116
 
   #No.FUN-880057  --BEGIN
   LET g_sql = "order1.mst_file.mst06,",
               "ima02.ima_file.ima02,",
               "ima08.ima_file.ima08,",
               "ima25.ima_file.ima25,",
               "smst04.mst_file.mst04,",
               "smst05.mst_file.mst05,",
               "smst06.mst_file.mst06,",
               "smst07.mst_file.mst07,",
               "smst08.mst_file.mst08,",
               "mss01.mss_file.mss01,",
               "mss02.mss_file.mss02,",
               "mss03.mss_file.mss03,",
               "mss00.mss_file.mss00,",
               "mst04.mst_file.mst04,",
               "mst05.mst_file.mst05,",
               "mst061.mst_file.mst061,",
               "mst08.mst_file.mst08,",
               "flag.type_file.chr1"
   LET l_table = cl_prt_temptable("amrr512",g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF  
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql                                                                                                
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                          
     END IF                       
   #No.FUN-880057  --END   
                
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #TQC-610074-begin
   LET tm.ver_no = ARG_VAL(8)
   LET tm.part1 = ARG_VAL(9)
   LET tm.part2 = ARG_VAL(10)
   LET tm.print_adj = ARG_VAL(11)
   LET tm.print_plp = ARG_VAL(12)
   LET tm.order_way = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   ##No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(8)
   #LET g_rep_clas = ARG_VAL(9)
   #LET g_template = ARG_VAL(10)
   ##No.FUN-570264 ---end---
   #TQC-610074-end
   IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL amrr512_tm(0,0)        # Input print condition
      ELSE CALL amrr512()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrr512_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
   DEFINE l_cnt          LIKE type_file.num5     #No.TQC-960291
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 12
   ELSE LET p_row = 4 LET p_col = 15
   END IF
 
   OPEN WINDOW amrr512_w AT p_row,p_col
        WITH FORM "amr/42f/amrr512"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.n    = '2'
   LET tm.print_adj = 'Y'
   LET tm.print_plp = 'Y'
display by name tm.print_plp
   LET tm.order_way = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mss01,ima67,mss02,ima08,ima43,mss03
 
#No.FUN-570240 --start
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION controlp
         IF INFIELD(mss01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO mss01
            NEXT FIELD mss01
         END IF
#No.FUN-570240 --end
 
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr512_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   INPUT BY NAME tm.ver_no, tm.part1, tm.part2,
                 tm.print_adj, tm.print_plp, tm.order_way, tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD ver_no
         IF cl_null(tm.ver_no) THEN NEXT FIELD ver_no END IF
      AFTER FIELD part1
         IF NOT cl_null(tm.part1) THEN
#No.TQC-960291 --Begin
            LET l_cnt = 0
#           SELECT bma01 FROM bma_file WHERE bma01=tm.part1
            SELECT COUNT(*) INTO l_cnt FROM bma_file WHERE bma01=tm.part1
#           IF STATUS THEN
            IF l_cnt = 0 THEN
#No.TQC-960291 --End
#               CALL cl_err('sel bma:',STATUS,0)  #No.FUN-660107
                CALL cl_err3("sel","bma_file",tm.part1,"",STATUS,"","sel bma:",0)        #NO.FUN-660107
                NEXT FIELD part1
                
            END IF
         END IF
      AFTER FIELD part2
         IF NOT cl_null(tm.part2) THEN
            SELECT ima01 FROM ima_file WHERE ima01=tm.part2
            IF STATUS THEN
#               CALL cl_err('sel ima:',STATUS,0) #No.FUN-660107
                CALL cl_err3("sel","ima_file",tm.part2,"",STATUS,"","sel ima:",0)        #NO.FUN-660107 
               NEXT FIELD part2
            END IF
         END IF
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLP
         CASE WHEN INFIELD(part1)
#                  CALL q_bma(0,0,tm.part1) RETURNING tm.part1
#                  CALL FGL_DIALOG_SETBUFFER( tm.part1 )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_bma'
    LET g_qryparam.default1 = tm.part1
    CALL cl_create_qry() RETURNING tm.part1
#    CALL FGL_DIALOG_SETBUFFER( tm.part1 )
# END genero shell script ADD
################################################################################
                   DISPLAY BY NAME tm.part1
              WHEN INFIELD(part2)
#                  CALL q_ima(0,0,tm.part2) RETURNING tm.part2
#                  CALL FGL_DIALOG_SETBUFFER( tm.part2 )
################################################################################
# START genero shell script ADD
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_ima'
    LET g_qryparam.default1 = tm.part2
    CALL cl_create_qry() RETURNING tm.part2
#    CALL FGL_DIALOG_SETBUFFER( tm.part2 )
                    DISPLAY BY NAME tm.part2     #No.MOD-490371
# END genero shell script ADD
################################################################################
                   DISPLAY BY NAME tm.part2
         END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW amrr512_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrr512'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrr512','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #TQC-610074-begin
                         " '",tm.ver_no CLIPPED,"'",
                         " '",tm.part1 CLIPPED,"'",
                         " '",tm.part2 CLIPPED,"'",
                         " '",tm.print_adj CLIPPED,"'",
                         " '",tm.print_plp CLIPPED,"'",
                         " '",tm.order_way CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrr512',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrr512_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrr512()
   ERROR ""
END WHILE
   CLOSE WINDOW amrr512_w
END FUNCTION
 
FUNCTION amrr512()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name       #NO.FUN-680082 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT                #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40)
          mss	RECORD LIKE mss_file.*,
          mst	RECORD LIKE mst_file.*,
          ima	RECORD LIKE ima_file.*,
          sr	RECORD
          	order1	LIKE mst_file.mst06, #NO.FUN-680082 VARCHAR(20)
          	ima02	LIKE ima_file.ima02,
          	ima08	LIKE ima_file.ima08,
          	ima25	LIKE ima_file.ima25
          	END RECORD
   #No.FUN-880057  --BEGIN
   DEFINE l_buf         LIKE mst_file.mst05                                                                
   DEFINE qty           LIKE mst_file.mst08                                                              
   DEFINE i,j,k         LIKE type_file.num10                                                            
   DEFINE demand1 DYNAMIC ARRAY OF RECORD                                                                            
          mst04   LIKE mst_file.mst04,     
          mst05   LIKE mst_file.mst05,                                                                   
          mst06   LIKE mst_file.mst06,                                                                             
          mst07   LIKE mst_file.mst07,                                                                                              
          mst08   LIKE mst_file.mst08                                                                                               
          END RECORD                                                                                                                
   DEFINE supply1 DYNAMIC ARRAY OF RECORD                                                                                
          mst04   LIKE mst_file.mst04,                                                                                              
          mst05   LIKE mst_file.mst05,                                                                 
          mst06   LIKE mst_file.mst06,                                                                            
          mst07   LIKE mst_file.mst07,                                                                                              
          mst08   LIKE mst_file.mst08                                                                                               
          END RECORD 
   DEFINE sr_null DYNAMIC ARRAY OF RECORD
          order1  LIKE mst_file.mst06,
          ima02   LIKE ima_file.ima02,
          ima08   LIKE ima_file.ima08,
          ima25   LIKE ima_file.ima25,
          dmst04  LIKE mst_file.mst04,
          dmst05  LIKE mst_file.mst05,
          dmst06  LIKE mst_file.mst06,
          dmst07  LIKE mst_file.mst07,
          dmst08  LIKE mst_file.mst08,
          smst04  LIKE mst_file.mst04,
          smst05  LIKE mst_file.mst05,
          smst06  LIKE mst_file.mst06,
          smst07  LIKE mst_file.mst07,
          smst08  LIKE mst_file.mst08,
          mss01   LIKE mss_file.mss01,
          mss02   LIKE mss_file.mss02,
          mss03   LIKE mss_file.mss03,
          mss00   LIKE mss_file.mss00,
          mst04   LIKE mst_file.mst04,
          mst05   LIKE mst_file.mst05,
          mst061  LIKE mst_file.mst061,
          mst08   LIKE mst_file.mst08,
          bal     LIKE mst_file.mst08
          END RECORD
     DEFINE g_cnt LIKE type_file.num5
       
     CALL cl_del_data(l_table)
 
     #No.FUN-880057  --end
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CASE WHEN tm.part1 IS NOT NULL
               CALL r512_bom1_main()
               LET l_sql = "SELECT mss_file.*, ima_file.*",
                           "  FROM r512_tmp, mss_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,    #No.MOD-7C0067 add clipped
                           "   AND partno=mss01",
                           "   AND mss01=ima01 ",
                           "   AND mss_v='",tm.ver_no,"'"
          WHEN tm.part2 IS NOT NULL
               CALL r512_bom2_main()
               LET l_sql = "SELECT mss_file.*, ima_file.*",
                           "  FROM r512_tmp, mss_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,    #No.MOD-7C0067 add clipped
                           "   AND partno=mss01",
                           "   AND mss01=ima01 ",
                           "   AND mss_v='",tm.ver_no,"'"
          OTHERWISE
               LET l_sql = "SELECT mss_file.*, ima_file.*",
                           "  FROM mss_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,    #No.MOD-7C0067 add clipped
                           "   AND mss01=ima01 ",
                           "   AND mss_v='",tm.ver_no,"'"
     END CASE
     PREPARE amrr512_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrr512_curs1 CURSOR FOR amrr512_prepare1
 
#     CALL cl_outnam('amrr512') RETURNING l_name    #No.FUN-880057
#No.FUN-550055-begin
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-550055-end
#     START REPORT amrr512_rep TO l_name        #No.FUN-880057
     LET g_pageno = 0
 
     FOREACH amrr512_curs1 INTO mss.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       message mss.mss01 clipped
       CALL ui.Interface.refresh()
       LET sr.ima02=ima.ima02
       LET sr.ima08=ima.ima08
       LET sr.ima25=ima.ima25
       DECLARE amrr512_curs2 CURSOR FOR
          SELECT * FROM mst_file
            WHERE mst01=mss.mss01 AND mst02=mss.mss02 AND mst03=mss.mss03
              AND mst_v=mss.mss_v
       FOREACH amrr512_curs2 INTO mst.*
         #message 'mst:',mst.mst01 clipped
         CASE WHEN tm.order_way='1' LET sr.order1=mst.mst03
              WHEN tm.order_way='2' LET sr.order1=mst.mst04
              OTHERWISE             LET sr.order1=mst.mst04,mst.mst05,mst.mst06
         END CASE
 
#No.FUN-880057---BEGIN
#         OUTPUT TO REPORT amrr512_rep(mss.*, mst.*, sr.*)
      IF (mst.mst05 = '53' AND mst.mst08 < 0) OR
         (mst.mst05 = '71' AND mst.mst08 < 0)
         THEN LET qty=mst.mst08*-1
         ELSE LET qty=mst.mst08
      END IF
      LET l_buf=s_mst05(g_lang,mst.mst05)      
      IF (mst.mst05 MATCHES '4*') OR
         (mst.mst05 = '53' AND mst.mst08 < 0) OR
         (mst.mst05 = '71' AND mst.mst08 < 0)   THEN
         LET i=i+1
         LET demand1[i].mst04=mst.mst04
         LET demand1[i].mst05=mst.mst05,' ',l_buf
         LET demand1[i].mst06=mst.mst06   # , ' ',mst.mst061 USING '###'
         LET demand1[i].mst07=mst.mst07
         LET demand1[i].mst08=qty
         EXECUTE insert_prep USING sr.order1,sr.ima02,sr.ima08,sr.ima25,demand1[i].mst04,                                        
           demand1[i].mst05,demand1[i].mst06,demand1[i].mst07,demand1[i].mst08,mss.mss01,                                           
           mss.mss02,mss.mss03,mss.mss00,mst.mst04,mst.mst05,mst.mst061,mst.mst08,'1'
      ELSE
         LET j=j+1
         LET supply1[j].mst04=mst.mst04
         LET supply1[j].mst05=mst.mst05,' ',l_buf
         LET supply1[j].mst06=mst.mst06     #,' ',mst.mst061 USING '###'
         LET supply1[j].mst07=mst.mst07
         LET supply1[j].mst08=qty
         EXECUTE insert_prep USING sr.order1,sr.ima02,sr.ima08,sr.ima25,supply1[j].mst04,                                    
           supply1[j].mst05,supply1[j].mst06,supply1[j].mst07,supply1[j].mst08,mss.mss01,                                           
           mss.mss02,mss.mss03,mss.mss00,mst.mst04,mst.mst05,mst.mst061,mst.mst08,'2'
     END IF
#No.FUN-880057---END
       END FOREACH
       INITIALIZE mst.* TO NULL
       LET mst.mst01=mss.mss01
       LET mst.mst02=mss.mss02
       LET mst.mst03=mss.mss03
       LET mst.mst04=mss.mss03
       LET sr.order1=mss.mss03
       IF tm.print_adj='Y' THEN     #是否列印交期調整建議資料
          IF mss.mss072-mss.mss071 != 0 THEN
             LET mst.mst05='71'
             LET mst.mst08=mss.mss072-mss.mss071
#No.FUN-880057---BEGIN
#            OUTPUT TO REPORT amrr512_rep(mss.*, mst.*, sr.*)
      IF (mst.mst05 = '53' AND mst.mst08 < 0) OR
         (mst.mst05 = '71' AND mst.mst08 < 0)
         THEN LET qty=mst.mst08*-1
         ELSE LET qty=mst.mst08
      END IF
      LET l_buf=s_mst05(g_lang,mst.mst05)
      IF (mst.mst05 MATCHES '4*') OR
         (mst.mst05 = '53' AND mst.mst08 < 0) OR
         (mst.mst05 = '71' AND mst.mst08 < 0)   THEN
         LET i=i+1
         LET demand1[i].mst04=mst.mst04
         LET demand1[i].mst05=mst.mst05,' ',l_buf
         LET demand1[i].mst06=mst.mst06   # , ' ',mst.mst061 USING '###'
         LET demand1[i].mst07=mst.mst07
         LET demand1[i].mst08=qty
         EXECUTE insert_prep USING sr.order1,sr.ima02,sr.ima08,sr.ima25,demand1[i].mst04,                                        
           demand1[i].mst05,demand1[i].mst06,demand1[i].mst07,demand1[i].mst08,mss.mss01,                                           
           mss.mss02,mss.mss03,mss.mss00,mst.mst04,mst.mst05,mst.mst061,mst.mst08,'1'
      ELSE
         LET j=j+1
         LET supply1[j].mst04=mst.mst04
         LET supply1[j].mst05=mst.mst05,' ',l_buf
         LET supply1[j].mst06=mst.mst06     #,' ',mst.mst061 USING '###'
         LET supply1[j].mst07=mst.mst07
         LET supply1[j].mst08=qty
         EXECUTE insert_prep USING sr.order1,sr.ima02,sr.ima08,sr.ima25,supply1[j].mst04,                                    
           supply1[j].mst05,supply1[j].mst06,supply1[j].mst07,supply1[j].mst08,mss.mss01,                                           
           mss.mss02,mss.mss03,mss.mss00,mst.mst04,mst.mst05,mst.mst061,mst.mst08,'2'
     END IF
#No.FUN-880057---END
          END IF
       END IF
       IF tm.print_plp='Y' THEN     #是否列印PLM/PLP建議資料
          IF mss.mss09 != 0 THEN
             IF ima.ima08='M'
                THEN LET mst.mst05=' M' # 這樣才會排在前面
                ELSE LET mst.mst05=' P' # 這樣才會排在前面
             END IF
             LET mst.mst08=mss.mss09
#No.FUN-880057---BEGIN
#             OUTPUT TO REPORT amrr512_rep(mss.*, mst.*, sr.*)
      IF (mst.mst05 = '53' AND mst.mst08 < 0) OR
         (mst.mst05 = '71' AND mst.mst08 < 0)
         THEN LET qty=mst.mst08*-1
         ELSE LET qty=mst.mst08
      END IF
      LET l_buf=s_mst05(g_lang,mst.mst05)
      IF (mst.mst05 MATCHES '4*') OR
         (mst.mst05 = '53' AND mst.mst08 < 0) OR
         (mst.mst05 = '71' AND mst.mst08 < 0)   THEN
         LET i=i+1
         LET demand1[i].mst04=mst.mst04
         LET demand1[i].mst05=mst.mst05,' ',l_buf
         LET demand1[i].mst06=mst.mst06   # , ' ',mst.mst061 USING '###'
         LET demand1[i].mst07=mst.mst07
         LET demand1[i].mst08=qty
         EXECUTE insert_prep USING sr.order1,sr.ima02,sr.ima08,sr.ima25,demand1[i].mst04,                                        
           demand1[i].mst05,demand1[i].mst06,demand1[i].mst07,demand1[i].mst08,mss.mss01,                                           
           mss.mss02,mss.mss03,mss.mss00,mst.mst04,mst.mst05,mst.mst061,mst.mst08,'1'
      ELSE
         LET j=j+1
         LET supply1[j].mst04=mst.mst04
         LET supply1[j].mst05=mst.mst05,' ',l_buf
         LET supply1[j].mst06=mst.mst06     #,' ',mst.mst061 USING '###'
         LET supply1[j].mst07=mst.mst07
         LET supply1[j].mst08=qty
         EXECUTE insert_prep USING sr.order1,sr.ima02,sr.ima08,sr.ima25,supply1[j].mst04,                                    
           supply1[j].mst05,supply1[j].mst06,supply1[j].mst07,supply1[j].mst08,mss.mss01,                                           
           mss.mss02,mss.mss03,mss.mss00,mst.mst04,mst.mst05,mst.mst061,mst.mst08,'2'
     END IF
#No.FUN-880057---END
          END IF
       END IF
     END FOREACH
 
#     FINISH REPORT amrr512_rep    #No.FUN-880057
     #No.FUN-880057  --BEGIN
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                         
                                                                                                                                    
     LET g_str = ''                                                                                                                 
     #是否列印選擇條件     
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'mss01,ima67,mss02,ima08,ima43,mss03')                                                                       
        RETURNING  tm.wc                                                                                                            
     END IF                                                                                                                         
     LET g_str = tm.wc,';',tm.ver_no,';',tm.order_way                                                                                            
     CALL cl_prt_cs3('amrr512','amrr512',g_sql,g_str)                                                                               
     #No.FUN-880057  --END 
END FUNCTION
 
FUNCTION r512_bom1_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM r512_tmp
   IF STATUS THEN
      CREATE TEMP TABLE r512_tmp(
                                 partno LIKE ima_file.ima01)    #No.MOD-7C0067 modify       
      CREATE UNIQUE INDEX r512_tmp_i1 ON r512_tmp(partno)
   END IF
   INSERT INTO r512_tmp VALUES(tm.part1)
   IF STATUS THEN 
# Prog. Version..: '5.30.06-13.03.12(0) r512_tmp:',STATUS,1) #No.FUN-660107
    CALL cl_err3("ins","r512_tmp",tm.part1,"",STATUS,"","ins(0) r512_tmp:",1)        #NO.FUN-660107 
   END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.part1
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL r512_bom1(0,tm.part1,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION r512_bom2_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM r512_tmp
   IF STATUS THEN
      CREATE TEMP TABLE r512_tmp(
                                 partno LIKE ima_file.ima01)   #No.MOD-7C0067 modify
      CREATE UNIQUE INDEX r512_tmp_i1 ON r512_tmp(partno)
   END IF
   INSERT INTO r512_tmp VALUES(tm.part2)
   IF STATUS THEN 
# Prog. Version..: '5.30.06-13.03.12(0) r512_tmp:',STATUS,1)  #No.FUN-660107
    CALL cl_err3("ins","r512_tmp",tm.part2,"",STATUS,"","ins(0) r512_tmp:",1)        #NO.FUN-660107
   END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.part2
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL r512_bom2(0,tm.part2,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION r512_bom1(p_level,p_key,p_key2)        #FUN-550110
   DEFINE p_level	LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          p_key		LIKE bma_file.bma01,    #主件料件編號
          p_key2        LIKE ima_file.ima910,   #FUN-550110
          l_ac,i	LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          arrno		LIKE type_file.num5,    #BUFFER SIZE (可存筆數)         #NO.FUN-680082 SMALLINT	
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              bmb03     LIKE bmb_file.bmb03,    #元件料號
              bma01     LIKE bma_file.bma01
          END RECORD,
          l_sql		LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT bmb03,bma01",
               " FROM bmb_file, OUTER bma_file",
               " WHERE bmb01='", p_key,"' AND bmb_file.bmb03 = bma_file.bma01",
               "   AND bmb29 ='",p_key2,"' "  #FUN-550110
    PREPARE r512_ppp FROM l_sql
    DECLARE r512_cur CURSOR FOR r512_ppp
    LET l_ac = 1
    FOREACH r512_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN--                                                                                                    
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03 
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END-- 
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore r512_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb03 clipped
        CALL ui.Interface.refresh()
        INSERT INTO r512_tmp VALUES(sr[i].bmb03)
        IF sr[i].bma01 IS NOT NULL THEN
          #CALL r512_bom1(p_level,sr[i].bmb03,' ')  #FUN-550110#FUN-8B0035
           CALL r512_bom1(p_level,sr[i].bmb03,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
FUNCTION r512_bom2(p_level,p_key,p_key2)         #FUN-550110
   DEFINE p_level	LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          p_key		LIKE bma_file.bma01,     #元件料件編號           #NO.FUN-680082 VARCHAR(20)
          p_key2        LIKE ima_file.ima910,    #FUN-550110
          l_ac,i	LIKE type_file.num5,     #NO.FUN-680082 SMALLINT
          arrno		LIKE type_file.num5,     #BUFFER SIZE (可存筆數) #NO.FUN-680082 SMALLINT
          sr DYNAMIC ARRAY OF RECORD             #每階存放資料
              bmb01     LIKE bmb_file.bmb01,	 #主件料號
              bmb03     LIKE bmb_file.bmb03      #還有沒有
          END RECORD,
          l_sql		LIKE type_file.chr1000   #NO.FUN-680082 VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT a.bmb01, b.bmb03",
               " FROM bmb_file a, OUTER bmb_file b",
               " WHERE a.bmb03='", p_key,"' AND a.bmb01 = b.bmb03",
               "   AND a.bmb29 ='",p_key2,"' "  #FUN-550110
    PREPARE r512_ppp2 FROM l_sql
    DECLARE r512_cur2 CURSOR FOR r512_ppp2
    LET l_ac = 1
    FOREACH r512_cur2 INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN--                                                                                                    
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb01
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END--
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore r512_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb01 clipped
        CALL ui.Interface.refresh()
        INSERT INTO r512_tmp VALUES(sr[i].bmb01)
        IF sr[i].bmb03 IS NOT NULL THEN
          #CALL r512_bom2(p_level,sr[i].bmb01,' ')  #FUN-550110#FUN-8B0035
           CALL r512_bom2(p_level,sr[i].bmb01,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
#No.FUN-880057---BEGIN
#REPORT amrr512_rep(mss, mst, sr)
#   DEFINE l_last_sw     LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
#   DEFINE l_buf		LIKE mst_file.mst05     #NO.FUN-680082 VARCHAR(8)
##   DEFINE order1	LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(20)
#  DEFINE order1	LIKE zaa_file.zaa08  #NO.FUN-680082 VARCHAR(20)  #TQC-6A0080
#  DEFINE mss		RECORD LIKE mss_file.*
#  DEFINE mst		RECORD LIKE mst_file.*
#  DEFINE sr	RECORD
##          	order1	LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(20)
#              #---------No.MOD-7C0066 modify
#              #order1	LIKE zaa_file.zaa08, #TQC-6A0080
#         	order1	LIKE mst_file.mst01, 
#              #---------No.MOD-7C0066 end
#         	ima02	LIKE ima_file.ima02,
#         	ima08	LIKE ima_file.ima08,
#         	ima25	LIKE ima_file.ima25
#         	END RECORD
#  DEFINE qty,bal	LIKE mst_file.mst08     #NO.FUN-680082 DEC(15,3) 
#  DEFINE i,j,k		LIKE type_file.num10    #NO.FUN-680082 INTEGER
#   DEFINE demand,supply     ARRAY[100] OF LIKE type_file.chr1000#--No.MOD-530457   #NO.FUN-680082 VARCHAR(70)
#  #----------------------------No.MOD-530457----------------------
##   DEFINE demand1 ARRAY[100] OF RECORD
#  DEFINE demand1 DYNAMIC ARRAY OF RECORD  #TQC-6A0080
#         mst04   LIKE mst_file.mst04,               
#         mst05   LIKE mst_file.mst05,               #NO.FUN-680082 VARCHAR(15)
#         mst06   LIKE mst_file.mst06,               #No.FUN-550055
#         mst07   LIKE mst_file.mst07,
#         mst08   LIKE mst_file.mst08
#         END RECORD
#   DEFINE supply1 ARRAY[100] OF RECORD
#  DEFINE supply1 DYNAMIC ARRAY OF RECORD  #TQC-6A0080
#         mst04   LIKE mst_file.mst04,
#         mst05   LIKE mst_file.mst05,               #NO.FUN-680082 VARCHAR(15)
#         mst06   LIKE mst_file.mst06,               #No.FUN-550055
#         mst07   LIKE mst_file.mst07,
#         mst08   LIKE mst_file.mst08
#         END RECORD
#  #-----------------------------No.MOD-530457 END-----TQC-6A0080
 
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY mss.mss01,mss.mss02,mss.mss03,sr.order1,mst.mst04,mst.mst05
# FORMAT
#  PAGE HEADER
 
##No.FUN-580014 --start--
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<',"/pageno"
#    #PRINT g_head CLIPPED,pageno_total    #No.TQC-770031 mark
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2+1),g_x[1] CLIPPED
#     PRINT COLUMN (g_len-7)/2,g_x[16] CLIPPED,tm.ver_no CLIPPED
#     PRINT g_head CLIPPED,pageno_total    #No.TQC-770031 add
#      PRINT g_dash[1,g_len]
##No.FUN-550055-begin
#     PRINTX name=H1 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],
#                    g_x[49],g_x[50],g_x[51],g_x[52],g_x[53],g_x[54],g_x[55]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF mss.mss02
#     PRINT g_x[17] CLIPPED,mss.mss01 CLIPPED,g_x[18] CLIPPED,sr.ima02, #FUN-5B0014 mss.mss01[1,20]
#           g_x[19] CLIPPED,sr.ima25, g_x[20] CLIPPED,mss.mss02
#     PRINT
#     LET bal=0
#  BEFORE GROUP OF mss.mss03
#     PRINTX name=D1
#           COLUMN g_c[41], mss.mss00 USING '###&', #FUN-590118
#           COLUMN g_c[42], mss.mss03 USING 'mm/dd';
#  BEFORE GROUP OF sr.order1
#     FOR i=1 TO 100 LET demand[i]=' ' LET supply[i]=' ' END FOR
#     LET i=0 LET j=0
#  ON EVERY ROW
#     IF (mst.mst05 = '53' AND mst.mst08 < 0) OR
#        (mst.mst05 = '71' AND mst.mst08 < 0)
#        THEN LET qty=mst.mst08*-1
#        ELSE LET qty=mst.mst08
#     END IF
#     LET l_buf=s_mst05(g_lang,mst.mst05)
#  #-----------------------------No.MOD-530457----------------------------------
#     IF (mst.mst05 MATCHES '4*') OR
#        (mst.mst05 = '53' AND mst.mst08 < 0) OR
#        (mst.mst05 = '71' AND mst.mst08 < 0)   THEN
#        LET i=i+1
#        LET demand1[i].mst04=mst.mst04
#        LET demand1[i].mst05=mst.mst05,' ',l_buf
#        LET demand1[i].mst06=mst.mst06   # , ' ',mst.mst061 USING '###'
#        LET demand1[i].mst07=mst.mst07
#        LET demand1[i].mst08=qty
#     ELSE
#        LET j=j+1
#        LET supply1[j].mst04=mst.mst04
#        LET supply1[j].mst05=mst.mst05,' ',l_buf
#        LET supply1[j].mst06=mst.mst06     #,' ',mst.mst061 USING '###'
#        LET supply1[j].mst07=mst.mst07
#        LET supply1[j].mst08=qty
#    END IF
#
 
#    #LET g_msg=mst.mst04,'  ',mst.mst05,' ',l_buf,'  ',
#    #          mst.mst06[1,10], mst.mst061 USING '###',
#    #          ' ',mst.mst07,
#    #          cl_numfor(qty,15,0)
#    #LET g_msg1= mst.mst04,'  ',mst.mst05,' ',l_buf,' ',
#    #           mst.mst06[1,10],' ', mst.mst061 USING '###',
#    #          ' ',mst.mst07 ,
#    #          cl_numfor(qty,15,0)
#    #IF (mst.mst05 MATCHES '4*') OR
#    #   (mst.mst05 = '53' AND mst.mst08 < 0) OR
#    #   (mst.mst05 = '71' AND mst.mst08 < 0)
#    #   THEN LET i=i+1 LET demand[i]=g_msg
#    #   ELSE LET j=j+1 LET supply[j]=g_msg1
#    #END IF
#  #-------------------------------No.MOD-530457 END--------------------------
#     IF mst.mst05 MATCHES '4*'
#        THEN LET bal=bal-mst.mst08
#        ELSE LET bal=bal+mst.mst08
#     END IF
#  
#  AFTER GROUP OF sr.order1
#     IF i>j THEN LET k=i ELSE LET k=j END IF
#     FOR i=1 TO k
#       #-------No.MOD-6A0049 add
#        IF cl_null(demand1[i].mst04) THEN
#           LET demand1[i].mst04 = supply1[i].mst04 CLIPPED
#        END IF
# 
#        IF cl_null(supply1[i].mst04) THEN
#           LET supply1[i].mst04 = demand1[i].mst04 CLIPPED
#        END IF
#       #-------No.MOD-6A0049 end
#     #--------------------------No.MOD-530457-------------------------
#      PRINTX name=D1
#              COLUMN g_c[43],demand1[i].mst04,
#              COLUMN g_c[44],demand1[i].mst05,
#              COLUMN g_c[45],demand1[i].mst06,
#              COLUMN g_c[46],mst.mst061 USING '###&', #FUN-590118
#              COLUMN g_c[47],demand1[i].mst07,
#              COLUMN g_c[48],cl_numfor(demand1[i].mst08,48,0),
#              COLUMN g_c[49],supply1[i].mst04 CLIPPED,
#              COLUMN g_c[50],supply1[i].mst05,
#              COLUMN g_c[51],supply1[i].mst06,
#              COLUMN g_c[52],mst.mst061 USING '###&', #FUN-590118
#              COLUMN g_c[53],supply1[i].mst07,
#              COLUMN g_c[54],cl_numfor(supply1[i].mst08,54,0);
#       #-----------------------No.MOD-530457 END---------------------
#       #No.FUN-880057  --BEGIN                                                                                                    
#        INSERT INTO r512_temp VALUES(sr.order1,sr.ima02,sr.ima08,sr.ima25,demand1[i].mst04,                                        
#          demand1[i].mst05,demand1[i].mst06,demand1[i].mst07,demand1[i].mst08,supply1[i].mst04,                                    
#          supply1[i].mst05,supply1[i].mst06,supply1[i].mst07,supply1[i].mst08,mss.mss01,                                           
#          mss.mss02,mss.mss03,mss.mss00,mst.mst04,mst.mst05,mst.mst061,mst.mst08,bal)
#       #No.FUN-880057  --END 
#       IF i=k
#          THEN PRINTX name=D1 COLUMN g_c[55],cl_numfor(bal,55,0)
#          ELSE PRINT ''
#       END IF
#     END FOR
#    #-------No.MOD-6A0049 add
#     CALL demand1.clear()
#     CALL supply1.clear()
#     LET i=j=0
#    #-------No.MOD-6A0049 add
##No.FUN-550055-end
#  AFTER GROUP OF mss.mss03
#     PRINT
#  AFTER GROUP OF mss.mss02
#     PRINT g_dash2[1,g_len] CLIPPED
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len] CLIPPED
#     PRINT g_x[04], COLUMN g_len-9 ,g_x[7] CLIPPED  #No.TQC-750041
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#             PRINT g_x[04],COLUMN g_len-9,g_x[6] CLIPPED  #No.TQC-750041
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#No.FUN-580014 --end--
#No.FUN-880057---END
#Patch....NO.TQC-610035 <> #
