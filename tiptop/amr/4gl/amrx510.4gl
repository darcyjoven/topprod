# Prog. Version..: '5.30.07-13.05.30(00003)'     #
#
# Pattern name...: amrx510.4gl
# Descriptions...: MRP 模擬明細表
# Input parameter: 
# Return code....: 
# Date & Author..: 96/06/10 By Roger
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: No.FUN-550055 05/05/24 By day   單據編號加大
# Modify.........: No.FUN-550110 05/05/26 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570240 05/07/22 By vivien 料件編號欄位增加controlp
# Modify.........: No.TQC-5B0019 05/11/07 By Sarah 印報表時,料號、品名留的位置太小,料號應留40碼,品名應留60碼
# Modify.........: No.TQC-5C0059 05/12/12 By kevin 欄位沒對齊
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610074 06/01/21 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE
# Modify.........: No.FUN-690116 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah 沒有列印(接下頁)、(結束)
# Modify.........: No.TQC-750041 07/05/22 By mike ‘序’欄位下出現‘#####’ 報表上面和底部沒有用雙橫線
# Modify.........: No.MOD-7C0066 07/12/10 By Pengu 在Informix環境中l_sql組出來會錯誤
# Modify.........: No.MOD-830078 08/03/11 By Carol l_buf變數改為char(20)
# Modify.........: No.FUN-830153 08/07/02 By xiaofeizhu 將報表輸出改為CR 
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.TQC-960291 09/06/23 By chenmoyan select bma01 from bma_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0008 09/12/02 By Smapmin 抓取bmb_file時,要考慮生失效日
# Modify.........: No:MOD-B20029 11/02/10 By sabrina 當tm.print_adj='Y'時，insert_prep第五個變數要傳mst.mst08
# Modify.........: No:FUN-CB0004 12/11/05 By dongsz CR轉XtraGrid
# Modify.........: No:FUN-D30070 13/03/21 By yangtt 去掉頁脚排序顯示 
# Modify.........: No.FUN-D40128 13/05/08 By wangrr "來源碼"增加開窗
# Modify.........: No.FUN-D60114 13/06/25 By wangrr 修改報表分組和排序
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
              wc        LIKE type_file.chr1000, # Where condition            #NO.FUN-680082 VARCHAR(600)
              n         LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
              ver_no    LIKE mss_file.mss_v,    #NO.FUN-680082 VARCHAR(2)
              part1     LIKE type_file.chr1000, #FUN-560011                  #NO.FUN-680082 VARCHAR(40)
              part2     LIKE type_file.chr1000, #FUN-560011                  #NO.FUN-680082 VARCHAR(40)
              print_adj LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
              print_plp LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
              order     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
              more      LIKE type_file.chr1     # Input more condition(Y/N)  #NO.FUN-680082 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose #NO.FUN-680082 SMALLINT
DEFINE   g_head1         STRING
DEFINE   l_table         STRING,                  ### FUN-830153 ###                                                                
         g_str           STRING,                  ### FUN-830153 ###                                                                
         g_sql           STRING                   ### FUN-830153 ### 
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
### *** FUN-830153 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                     
    LET g_sql = "mss03.mss_file.mss03,",                                                                                            
                "mss02.mss_file.mss02,",                                                                                            
                "mss01.mss_file.mss01,",                                                                                            
                "mss00.mss_file.mss00,",                                                                                            
                "mst08.mst_file.mst08,",                                                                                            
                "mst07.mst_file.mst07,",                                                                                            
                "mst061.mst_file.mst061,",                                                                                          
                "mst06.mst_file.mst06,",                                                                                            
                "mst05.mst_file.mst05,",                                                                                            
                "mst04.mst_file.mst04,",                                                                                            
                "ima25.ima_file.ima25,",                                                                                            
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",                 #FUN-CB0004 add                                                                                            
                "ima67.ima_file.ima67,",                                                                                            
                "ima43.ima_file.ima43,",                                                                                            
                "l_buf.type_file.chr20,", 
                "mst08_1.mst_file.mst08,",                 #FUN-CB0004 add
                "mst08_2.mst_file.mst08,",                 #FUN-CB0004 add
                "mst08_3.mst_file.mst08,",                 #FUN-CB0004 add       
                "l_pot.type_file.num5"                     #FUN-CB0004 add                                                                                 
    LET l_table = cl_prt_temptable('amrx510',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?,                                                                                    
                         ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"       #FUN-CB0004 add 5?                                                                                     
   PREPARE insert_prep FROM g_sql     
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#  
 
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
   LET tm.order = ARG_VAL(13)
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
      THEN CALL amrx510_tm(0,0)        # Input print condition
      ELSE CALL amrx510()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
END MAIN
 
FUNCTION amrx510_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          l_cmd          LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(400)
   DEFINE l_cnt          LIKE type_file.num5     #No.TQC-960291
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 10
   ELSE LET p_row = 3 LET p_col = 15
   END IF
 
   OPEN WINDOW amrx510_w AT p_row,p_col
        WITH FORM "amr/42f/amrx510" 
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
   LET tm.order = '1'
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
        #IF INFIELD(mss01) THEN                #FUN-CB0004 mark
         CASE                                  #FUN-CB0004 add
            WHEN INFIELD(mss01)                #FUN-CB0004 add                                                                   
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form = "q_ima"                                                                                       
               LET g_qryparam.state = "c"                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO mss01                                                                                 
               NEXT FIELD mss01 
        #FUN-CB0004--add--str---
            WHEN INFIELD(ima67)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima67
               NEXT FIELD ima67
            #FUN-D40128--add--str--
            WHEN INFIELD(ima08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima7"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima08
               NEXT FIELD ima08
            #FUN-D40128--add--end
            WHEN INFIELD(ima43)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ima43
               NEXT FIELD ima43
            WHEN INFIELD(mss02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc2"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO mss02
               NEXT FIELD mss02
         END CASE
        #FUN-CB0004--add--end---                                                                                                    
        #END IF                          #FUN-CB0004 mark                                                   
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx510_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   DISPLAY BY NAME tm.ver_no, tm.part1, tm.part2,
                 tm.print_adj, tm.print_plp, tm.order,tm.more
   INPUT BY NAME tm.ver_no, tm.part1, tm.part2,
                 tm.print_adj, tm.print_plp, tm.order,tm.more WITHOUT DEFAULTS 
 
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
 #          SELECT bma01 FROM bma_file WHERE bma01=tm.part1
            SELECT COUNT(*) INTO l_cnt FROM bma_file WHERE bma01=tm.part1
            IF l_cnt = 0 THEN
 #          IF STATUS THEN
 #No.TQC-960291 --End
 #              CALL cl_err('sel bma:',STATUS,0) #No.FUN-660107
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
      AFTER FIELD order
         IF cl_null(tm.order) THEN NEXT FIELD order END IF
         IF tm.order NOT MATCHES '[123]' THEN
            LET tm.order='1'
            NEXT FIELD order
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
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_bma'
                   LET g_qryparam.default1 = tm.part1
                   CALL cl_create_qry() RETURNING tm.part1
#                   CALL FGL_DIALOG_SETBUFFER( tm.part1 )
                   DISPLAY BY NAME tm.part1
              WHEN INFIELD(part2)
#                  CALL q_ima(0,0,tm.part2) RETURNING tm.part2
#                  CALL FGL_DIALOG_SETBUFFER( tm.part2 )
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_ima'
                   LET g_qryparam.default1 = tm.part2
                   CALL cl_create_qry() RETURNING tm.part2
#                   CALL FGL_DIALOG_SETBUFFER( tm.part2 )
                   DISPLAY BY NAME tm.part2
         END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW amrx510_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='amrx510'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('amrx510','9031',1)
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
                         " '",tm.order CLIPPED,"'",
                         #TQC-610074-end
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('amrx510',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW amrx510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL amrx510()
   ERROR ""
END WHILE
   CLOSE WINDOW amrx510_w
END FUNCTION
 
FUNCTION amrx510()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name       #NO.FUN-680082 VARCHAR(20) 
#       l_time          LIKE type_file.chr8        #No.FUN-6A0076
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT                #NO.FUN-680082 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #NO.FUN-680082 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #NO.FUN-680082 VARCHAR(40) 
          l_order   LIKE ima_file.ima67,    #NO.FUN-680082 VARCHAR(20)
          mss	RECORD LIKE mss_file.*,
          mst	RECORD LIKE mst_file.*,
          ima	RECORD LIKE ima_file.*
   DEFINE l_buf     LIKE type_file.chr20    #FUN-830153                                                                             
   DEFINE l_str     LIKE mst_file.mst08     #FUN-830153                                                                             
   DEFINE l_str1    LIKE mst_file.mst05     #FUN-830153 
   DEFINE l_qty1    LIKE mst_file.mst08     #FUN-CB0004 add
   DEFINE l_qty2    LIKE mst_file.mst08     #FUN-CB0004 add
   DEFINE l_bal     LIKE mst_file.mst08     #FUN-CB0004 add
   DEFINE l_pot     LIKE type_file.num5     #FUN-CB0004 add
   DEFINE l_str2    STRING                  #FUN-CB0004 add
   DEFINE l_str3    STRING                  #FUN-CB0004 add 
   DEFINE l_str4    STRING                  #FUN-CB0004 add
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-830153 *** ##                                                      
   CALL cl_del_data(l_table)                                                                                                        
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                           #FUN-830153                                   
   #------------------------------ CR (2) ------------------------------#  
     CASE WHEN tm.part1 IS NOT NULL
               CALL x510_bom1_main()
               LET l_sql = "SELECT mss_file.*, ima_file.*",
                           "  FROM x510_tmp, mss_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,    #No.MOD-7C0066 add clipped
                           "   AND partno=mss01",
                           "   AND mss01=ima01 ",
                           "   AND mss_v='",tm.ver_no,"'"
          WHEN tm.part2 IS NOT NULL
               CALL x510_bom2_main()
               LET l_sql = "SELECT mss_file.*, ima_file.*",
                           "  FROM x510_tmp, mss_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,    #No.MOD-7C0066 add clipped
                           "   AND partno=mss01",
                           "   AND mss01=ima01 ",
                           "   AND mss_v='",tm.ver_no,"'"
          OTHERWISE
               LET l_sql = "SELECT mss_file.*, ima_file.*",
                           "  FROM mss_file, ima_file",
                           " WHERE ",tm.wc CLIPPED,     #No.MOD-7C0066 add clipped
                           "   AND mss01=ima01 ",
                           "   AND mss_v='",tm.ver_no,"'"
     END CASE
     PREPARE amrx510_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
        EXIT PROGRAM 
     END IF
     DECLARE amrx510_curs1 CURSOR FOR amrx510_prepare1 #No.FUN-830153
 
#     CALL cl_outnam('amrx510') RETURNING l_name     #No.FUN-830153 
#     START REPORT amrx510_rep TO l_name
#     LET g_pageno = 0                               #No.FUN-830153
     FOREACH amrx510_curs1 INTO mss.*, ima.*
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       message mss.mss01 clipped
       CALL ui.Interface.refresh()
#No.FUN-830153--Mark--Begin-- 
#       IF tm.order='1' THEN
#          LET l_order=ima.ima67
#       END IF
#       IF tm.order='2' THEN
#          LET l_order=ima.ima43
#       END IF
#       IF tm.order='3' THEN
#        LET l_order=' '
#       END IF
#No.FUN-830153--Mark--Begin--  
       DECLARE amrx510_curs2 CURSOR FOR
          SELECT * FROM mst_file
            WHERE mst01=mss.mss01 AND mst02=mss.mss02 AND mst03=mss.mss03
              AND mst_v=mss.mss_v
     LET l_qty1 = 0   LET l_qty2 = 0   LET l_bal = 0     #FUN-CB0004 add
       FOREACH amrx510_curs2 INTO mst.*
         #message 'mst:',mst.mst01 clipped
#         OUTPUT TO REPORT amrx510_rep(l_order,mss.*, mst.*, ima.*)   #No.FUN-830153
#No.FUN-830153--Add--Begin--                                                                                                        
     LET l_buf=s_mst05(g_lang,mst.mst05)                                                                                            
     LET l_buf=mst.mst05,l_buf                                                                                                      
#No.FUN-830153--Add--End-- 
    #FUN-CB0004--add--str---
     IF mst.mst05 MATCHES '4*'
        THEN LET l_qty1 = mst.mst08   LET l_qty2 = 0 
        ELSE LET l_qty2 = mst.mst08   LET l_qty1 = 0
     END IF
     LET l_bal = l_bal - l_qty1 + l_qty2
     LET l_pot = 0
    #FUN-CB0004--add--end--- 
    ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830153 *** ##                                                       
        EXECUTE insert_prep USING                                                                                                   
               mss.mss03,mss.mss02,mss.mss01,mss.mss00,mst.mst08,mst.mst07,mst.mst061,                                              
               mst.mst06,mst.mst05,mst.mst04,ima.ima25,ima.ima02,ima.ima021,ima.ima67,ima.ima43,l_buf,l_qty1,l_qty2,l_bal,l_pot  #FUN-CB0004 add l_qty1,l_qty2,l_bal,l_pot,ima.ima021                                          
    #------------------------------ CR (3) ------------------------------#     
 
       END FOREACH
       INITIALIZE mst.* TO NULL
       LET mst.mst01=mss.mss01
       LET mst.mst02=mss.mss02
       LET mst.mst03=mss.mss03
       LET mst.mst04=mss.mss03
       IF tm.print_adj='Y' THEN
          IF mss.mss072-mss.mss071 != 0 THEN
             LET mst.mst05='71'
             LET mst.mst08=mss.mss072-mss.mss071
#             OUTPUT TO REPORT amrx510_rep(l_order,mss.*, mst.*, ima.*)
#No.FUN-830153--Add--Begin--                                                                                                        
     LET l_buf=s_mst05(g_lang,mst.mst05)                                                                                            
     LET l_buf=mst.mst05,l_buf                                                                                                      
#No.FUN-830153--Add--End--                                                                                                          
                                                                                                                                    
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830153 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
               #mss.mss03,mss.mss02,mss.mss01,mss.mss00,l_str,mst.mst07,mst.mst061,          #MOD-B20029 mark                                        
                mss.mss03,mss.mss02,mss.mss01,mss.mss00,mst.mst08,mst.mst07,mst.mst061,      #MOD-B20029 add                                            
                mst.mst06,'71',mss.mss03,ima.ima25,ima.ima02,ima.ima021,ima.ima67,ima.ima43,l_buf,l_qty1,l_qty2,l_bal,l_pot  #FUN-CB0004 add l_qty1,l_qty2,l_bal,l_pot,ima.ima021                                              
     #------------------------------ CR (3) ------------------------------#  
          END IF
       END IF
       IF tm.print_plp='Y' THEN
          IF mss.mss09 != 0 THEN
             IF ima.ima08='M'
                THEN LET mst.mst05=' M' # 這樣才會排在前面
                ELSE LET mst.mst05=' P' # 這樣才會排在前面
             END IF
             LET mst.mst08=mss.mss09
#             OUTPUT TO REPORT amrx510_rep(l_order,mss.*, mst.*, ima.*)
#No.FUN-830153--Add--Begin--                                                                                                        
      LET l_buf=s_mst05(g_lang,mst.mst05)                                                                                           
      LET l_buf=mst.mst05,l_buf                                                                                                     
#No.FUN-830153--Add--End--                                                                                                          
                                                                                                                                    
     ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-830153 *** ##                                                      
         EXECUTE insert_prep USING                                                                                                  
                mss.mss03,mss.mss02,mss.mss01,mss.mss00,mss.mss09,mst.mst07,mst.mst061,                                             
                mst.mst06,l_str1,mst.mst04,ima.ima25,ima.ima02,ima.ima021,ima.ima67,ima.ima43,l_buf,l_qty1,l_qty2,l_bal,l_pot  #FUN-CB0004 add l_qty1,l_qty2,l_bal,l_pot,ima.ima021                                            
     #------------------------------ CR (3) ------------------------------#  
 
          END IF
       END IF
     END FOREACH
 
#     FINISH REPORT amrx510_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-830153--begin                 
    LET l_str4 = tm.wc               #FUN-CB0004 add                                                                                              
    LET g_xgrid.table = l_table    ###XtraGrid###
      IF g_zz05 = 'Y' THEN                                                                                                          
         CALL cl_wcchp(tm.wc,'mss01,ima67,mss02,ima08,ima43,mss03')                                                                 
             #RETURNING tm.wc       #FUN-CB0004
              RETURNING l_str4      #FUN-CB0004 add                                                                                           
      END IF                                                                                                                        
#No.FUN-830153--end                                                                                                                 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-830153 **** ##                                                        
###XtraGrid###    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
###XtraGrid###    LET g_str = tm.wc,";",tm.order,";",tm.ver_no,";",tm.part1,";",tm.part2,";",tm.print_adj,";",tm.print_plp                        
###XtraGrid###    CALL cl_prt_cs3('amrx510','amrx510',g_sql,g_str)                                                                                
   #FUN-CB0004--add--str---
    CASE tm.order
       WHEN '1'
          #LET g_xgrid.order_field = "ima67,mss01,mss02,mss03,mst04,mst05" #FUN-D60114 mark
          #LET g_xgrid.grup_field = "ima67,mss02,mss03" #FUN-D60114 mark
          LET g_xgrid.skippage_field = "mss01"
          LET g_xgrid.order_field = "ima67,mss02,mss03"#FUN-D60114
          LET g_xgrid.grup_field = "ima67,mss02,mss03" #FUN-D60114
          LET l_str2 = cl_getmsg('ima-003',g_lang)
          LET l_str2 = l_str2,': ',ima.ima67
          LET l_str3 = cl_getmsg('ima-003',g_lang)
       WHEN '2'
          #LET g_xgrid.order_field = "ima43,mss01,mss02,mss03,mst04,mst05" #FUN-D60114 mark
          #LET g_xgrid.grup_field = "ima43,mss02,mss03" #FUN-D60114 mark
          LET g_xgrid.skippage_field = "mss01"
          LET g_xgrid.order_field = "ima43,mss02,mss03"#FUN-D60114
          LET g_xgrid.grup_field = "ima43,mss02,mss03" #FUN-D60114
          LET l_str2 = cl_getmsg('ima-004',g_lang)
          LET l_str2 = l_str2,': ',ima.ima43
          LET l_str3 = cl_getmsg('ima-004',g_lang)
       WHEN '3'
         #LET g_xgrid.order_field = "mss01"
         #LET g_xgrid.grup_field = "mss01"
          LET g_xgrid.skippage_field = "mss01"
          LET g_xgrid.order_field = "mss02,mss03" #FUN-D60114
          LET g_xgrid.grup_field = "mss02,mss03"  #FUN-D60114
          LET l_str2 = null
          LET l_str3 = cl_getmsg('asf-176',g_lang)
    END CASE
    IF tm.print_adj = 'Y'  THEN 
       #LET g_xgrid.footerinfo1 = cl_getmsg('mss-002',g_lang),': ',tm.part1,"|",l_str2,"|",cl_getmsg('mss-004',g_lang) #FUN-D60114 mark
       LET g_xgrid.footerinfo1 = cl_getmsg('mss-002',g_lang),': ',tm.part1,"|",cl_getmsg('mss-004',g_lang) #FUN-D60114
    ELSE 
       #LET g_xgrid.footerinfo1 = cl_getmsg('mss-002',g_lang),': ',tm.part1,"|",l_str2 #FUN-D60114 mark
       LET g_xgrid.footerinfo1 = cl_getmsg('mss-002',g_lang),': ',tm.part1 #FUN-D60114
    END IF
    IF tm.print_plp = 'Y' THEN
       LET g_xgrid.footerinfo2 = cl_getmsg('mss-003',g_lang),': ',tm.part2,"|",cl_getmsg('azz-211',g_lang),': ',tm.ver_no,"|",cl_getmsg('mss-005',g_lang)
    ELSE
       LET g_xgrid.footerinfo2 = cl_getmsg('mss-003',g_lang),': ',tm.part2,"|",cl_getmsg('azz-211',g_lang),': ',tm.ver_no
    END IF
   #LET g_xgrid.footerinfo3 = cl_getmsg("lib-626",g_lang),l_str3  #FUN-D30070  mark
    LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),l_str4
   #FUN-CB0004--add--end---
    CALL cl_xg_view()    ###XtraGrid###
    #------------------------------ CR (4) ------------------------------#   
END FUNCTION
 
FUNCTION x510_bom1_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM x510_tmp
   IF STATUS THEN
      CREATE TEMP TABLE x510_tmp (
                                  partno LIKE type_file.chr1000)      
      CREATE UNIQUE INDEX x510_tmp_i1 ON x510_tmp(partno)
   END IF
   INSERT INTO x510_tmp VALUES(tm.part1)
   IF STATUS THEN 
#   CALL cl_err('ins(0) x510_tmp:',STATUS,1)  #No.FUN-660107
    CALL cl_err3("ins","x510_tmp","","",STATUS,"","ins(0) x510_tmp:",1)        #NO.FUN-660107
   END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.part1
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL x510_bom1(0,tm.part1,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION x510_bom2_main()
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550110
   DELETE FROM x510_tmp
   IF STATUS THEN
      CREATE TEMP TABLE x510_tmp (
                                  partno LIKE type_file.chr1000)         
      CREATE UNIQUE INDEX x510_tmp_i1 ON x510_tmp(partno)
   END IF
   INSERT INTO x510_tmp VALUES(tm.part2)
   IF STATUS THEN 
#   CALL cl_err('ins(0) x510_tmp:',STATUS,1) #No.FUN-660107
    CALL cl_err3("ins","x510_tmp","","",STATUS,"","ins(0) x510_tmp:",1)        #NO.FUN-660107 
   END IF
   #FUN-550110
   LET l_ima910=''
   SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=tm.part2
   IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
   #--
   CALL x510_bom2(0,tm.part2,l_ima910)  #FUN-550110
END FUNCTION
 
FUNCTION x510_bom1(p_level,p_key,p_key2)  #FUN-550110
   DEFINE p_level	LIKE type_file.num5,          #NO.FUN-680082 SMALLINT
          p_key		LIKE bma_file.bma01,          #主件料件編號
          p_key2        LIKE ima_file.ima910,         #FUN-550110
          l_ac,i	LIKE type_file.num5,          #NO.FUN-680082 SMALLINT
          arrno		LIKE type_file.num5,  	      #BUFFER SIZE (可存筆數)    #NO.FUN-680082 SMALLINT
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bmb03 LIKE bmb_file.bmb03,       #元件料號
              bma01 LIKE bma_file.bma01        #NO.FUN-680082 VARCHAR(20)
          END RECORD,
          l_sql		LIKE type_file.chr1000 #NO.FUN-680082 VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT bmb03,bma01",
               #" FROM bmb_file, OUTER bma_file",   #MOD-9C0008
               " FROM bmb_file LEFT OUTER JOIN bma_file ON bmb03=bma01",   #MOD-9C0008
               #" WHERE bmb01='", p_key,"' AND bmb_file.bmb03 = bma_file.bma01",   #MOD-9C0008
               " WHERE bmb01='", p_key,"' ",   #MOD-9C0008
               "   AND bmb29 ='",p_key2,"' ",  #FUN-550110
               "   AND (bmb04 <='",g_today,"' ",   #MOD-9C0008
               "    OR bmb04 IS NULL) AND (bmb05 >'",g_today,"' ",   #MOD-9C0008
               "    OR bmb05 IS NULL)"   #MOD-9C0008
    PREPARE x510_ppp FROM l_sql
    DECLARE x510_cur CURSOR FOR x510_ppp
    LET l_ac = 1
    FOREACH x510_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN-- 
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END--  
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore x510_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb03 clipped
        CALL ui.Interface.refresh()
        INSERT INTO x510_tmp VALUES(sr[i].bmb03)
        IF sr[i].bma01 IS NOT NULL THEN 
          #CALL x510_bom1(p_level,sr[i].bmb03,' ')  #FUN-550110#FUN-8B0035
           CALL x510_bom1(p_level,sr[i].bmb03,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
 
FUNCTION x510_bom2(p_level,p_key,p_key2)  #FUN-550110
   DEFINE p_level	LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          p_key		LIKE bma_file.bma01,    #元件料件編號            #NO.FUN-680082 VARCHAR(40)
          p_key2        LIKE ima_file.ima910,   #FUN-550110
          l_ac,i	LIKE type_file.num5,    #NO.FUN-680082 SMALLINT
          arrno		LIKE type_file.num5,  	#BUFFER SIZE (可存筆數)  #NO.FUN-680082 SMALLINT
          sr DYNAMIC ARRAY OF RECORD            #每階存放資料
              bmb01     LIKE bmb_file.bmb01,	#主件料號       
              bmb03     LIKE bmb_file.bmb03 	#還有沒有                #NO.FUN-680082 VARCHAR(20)
          END RECORD,
          l_sql		LIKE type_file.chr1000  #NO.FUN-680082 VARCHAR(1000)
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690116
       EXIT PROGRAM 
    END IF
    LET p_level = p_level + 1
    LET arrno = 600
    LET l_sql= "SELECT a.bmb01, b.bmb03",
               #" FROM bmb_file a, OUTER bmb_file b",   #MOD-9C0008
               " FROM bmb_file a LEFT OUTER JOIN bmb_file b ON a.bmb01=b.bmb03",   #MOD-9C0008
               #" WHERE a.bmb03='", p_key,"' AND a.bmb01 = b.bmb03",   #MOD-9C0008
               " WHERE a.bmb03='", p_key,"' ",   #MOD-9C0008
               "   AND a.bmb29 ='",p_key2,"' ",  #FUN-550110
               "   AND (a.bmb04 <='",g_today,"' ",   #MOD-9C0008
               "    OR a.bmb04 IS NULL) AND (a.bmb05 >'",g_today,"' ",   #MOD-9C0008
               "    OR a.bmb05 IS NULL)"   #MOD-9C0008
    PREPARE x510_ppp2 FROM l_sql
    DECLARE x510_cur2 CURSOR FOR x510_ppp2
    LET l_ac = 1
    FOREACH x510_cur2 INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
       #FUN-8B0035--BEGIN--                                                                                                    
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb01
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END--
       LET l_ac = l_ac + 1			# 但BUFFER不宜太大
       IF l_ac > arrno THEN EXIT FOREACH END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore x510_cur:',STATUS,1) END IF
    FOR i = 1 TO l_ac-1		# 讀BUFFER傳給REPORT
        message p_level,' ',sr[i].bmb01 clipped
        CALL ui.Interface.refresh()
        INSERT INTO x510_tmp VALUES(sr[i].bmb01)
        IF sr[i].bmb03 IS NOT NULL THEN 
          #CALL x510_bom2(p_level,sr[i].bmb01,' ')  #FUN-550110#FUN-8B0035
           CALL x510_bom2(p_level,sr[i].bmb01,l_ima910[i])  #FUN-8B0035
        END IF
    END FOR
END FUNCTION
#NO.FUN-830153 -Mark--Begin--#   
#REPORT amrx510_rep(l_order,mss, mst, ima)
#  DEFINE l_last_sw     LIKE type_file.chr1     #NO.FUN-680082 VARCHAR(1)
#  DEFINE l_buf		LIKE type_file.chr20    #MOD-830078-modify #NO.FUN-680082 VARCHAR(12)
#  DEFINE mss		RECORD LIKE mss_file.*
#  DEFINE mst		RECORD LIKE mst_file.*
#  DEFINE ima		RECORD LIKE ima_file.*
#  DEFINE l_order       LIKE ima_file.ima67     #NO.FUN-680082 VARCHAR(20)
#  DEFINE qty1,qty2,bal	LIKE mst_file.mst08
# OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
# ORDER BY l_order,mss.mss01,mss.mss02,mss.mss03,mst.mst04,mst.mst05
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
 
#     IF tm.order = '1' THEN
#        LET g_head1= g_x[38],l_order
#        PRINT g_head1
#     ELSE
#        IF tm.order = '2' THEN
#           LET g_head1= g_x[39],l_order
#           PRINT g_head1
#        ELSE
#           PRINT ' '
#        END IF
#     END IF
#     LET g_head1=g_x[16] CLIPPED,tm.ver_no
#     PRINT g_head1
#    # PRINT g_dash2[1,g_len] CLIPPED   #No.TQC-750041
#     PRINT g_dash[1,g_len] CLIPPED     #No.TQC-750041
#     PRINT g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED,g_x[43] CLIPPED,
#           g_x[44] CLIPPED,g_x[45] CLIPPED,g_x[46] CLIPPED,g_x[47] CLIPPED,
#           g_x[48] CLIPPED,g_x[49] CLIPPED
#     PRINT g_dash1 
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF l_order
#     IF tm.order MATCHES '[12]' THEN
#        SKIP TO TOP OF PAGE
#     END IF
 
#  BEFORE GROUP OF mss.mss02
#    #start TQC-5B0019
#    #PRINT COLUMN g_c[40],g_x[17] CLIPPED,
#    #      COLUMN g_c[41],mss.mss01,
#    #      COLUMN g_c[42],g_x[18] CLIPPED,
#    #      COLUMN g_c[43],ima.ima02,
#    #      COLUMN g_c[44],g_x[19] CLIPPED,
#    #      COLUMN g_c[45],ima.ima25 
#     PRINT COLUMN g_c[40],g_x[17] CLIPPED,mss.mss01 CLIPPED,
#           COLUMN g_c[46],g_x[19] CLIPPED,ima.ima25 CLIPPED
#     PRINT COLUMN g_c[40],g_x[18] CLIPPED,ima.ima02 CLIPPED 
#    #end TQC-5B0019
#     LET qty1=0 LET qty2=0 LET bal=0
 
#  BEFORE GROUP OF mss.mss03
#     PRINT COLUMN g_c[40],mss.mss00 USING '###&', #FUN-590118
#           #COLUMN g_c[41],mss.mss03 USING 'yy/mm/dd'; #FUN-570250 mark
#           COLUMN g_c[41],mss.mss03; #FUN-570250 add
 
#  ON EVERY ROW
#     LET l_buf=s_mst05(g_lang,mst.mst05)
#     LET l_buf=mst.mst05,l_buf
#     IF mst.mst05 MATCHES '4*'
#        THEN LET qty1=mst.mst08 LET qty2=0
#        ELSE LET qty2=mst.mst08 LET qty1=0
#     END IF
#     LET bal=bal-qty1+qty2
#     PRINT COLUMN g_c[42],mst.mst04,
#           COLUMN g_c[43],l_buf,
#           COLUMN g_c[44],cl_numfor(qty1,44,0), 
#           COLUMN g_c[45],cl_numfor(qty2,45,0), 
#           COLUMN g_c[46],cl_numfor(bal,46,0),  
#           COLUMN g_c[47],mst.mst06,          #No.FUN-550055
#           COLUMN g_c[48],mst.mst061 USING '###&', #No.TQC-5C0059 #FUN-590118
#           COLUMN g_c[49],mst.mst07 CLIPPED
#  AFTER GROUP OF mss.mss03
#     PRINT ' '
#  AFTER GROUP OF mss.mss02
#     PRINT g_dash[1,g_len] CLIPPED
#  ON LAST ROW
#     LET l_last_sw = 'y'
##     PRINT g_dash2[1,g_len] CLIPPED
#    #PRINT '(amrx510)'                                                       #TQC-6B0011 mark
#     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #TQC-6B0011
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        #THEN PRINT g_dash2[1,g_len] CLIPPED  #No.TQC-750041
#         THEN PRINT g_dash[1,g_len] CLIPPED   #No.TQC-750041
#            #PRINT '(amrx510)'                                                       #TQC-6B0011 mark
#             PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED   #TQC-6B0011
#        ELSE SKIP 2 LINE
#     END IF
#END REPORT
#NO.FUN-830153 -Mark--End--#


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
