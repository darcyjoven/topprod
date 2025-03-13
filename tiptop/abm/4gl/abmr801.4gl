# Prog. Version..: '5.30.06-13.04.01(00008)'     #
#
# Pattern name...: abmr801.4gl
# Descriptions...: 多階材料用量明細表
# Date & Author..: 91/08/02 By Lee
# Modify.........: 92/03/27 By Nora
#                  Add 主件料號數量
# Modify.........: 92/10/26 By Apple(全面整修)
# Modify.........: 94/08/16 By Danny 改由bmt_file取插件位置
# Modify.........: 99/09/15 By Carol:數量check生產單位及庫存單位之換算
# Modify.........: No.MOD-4A0359 04/11/01 By Mandy 列印頁次
# Modify.........: No.FUN-4B0001 04/11/02 By Smapmin 主件編號開窗
# Modify.........: No.MOD-520129 05/02/25 By Mandy 將g_x[30][1,2]改成g_x[30].substring(1,2)
# Modify.........: No.FUN-550093 05/05/27 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.TQC-5A0028 05/10/12 By Carrier 報表格式調整
# Modify.........: No.TQC-5B0030 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.CHI-6A0034 07/01/30 By jamie abmq601->abmr801 
# Modify.........: No.TQC-7A0013 07/10/11 By sherry 報表轉Crystal Report格式   
# Modify.........: No.CHI-810006 08/01/18 By zhoufeng 調整插件位置及說明的列印  
# Modify.........: No.MOD-830071 08/03/11 By Carol 無法列出替代料->加key
# Modify.........: No.MOD-830063 08/03/20 By Pengu 排序會異常
# Modify.........: No.TQC-830028 08/03/21 By liuxqa   
# Modify.........: No.MOD-850322 08/05/30 By claire 子報表的替代料中,bmd04塞值成bmd03  
# Modify.........: No.FUN-890106 08/10/10 By jan 增加打印 set取替代資料 內容
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-A40058 10/04/27 By lilingyu bmb16曾加規格替代的內容
# Modify.........: No:MOD-A40183 10/04/30 By Sarah 將l_bmc05變數放大LIKE bmc_file.bmc05
# Modify.........: No:MOD-B40114 11/07/17 By Vampire 單身項次打0時資料不會印出來
# Modify.........: No.FUN-B80100 11/08/10 By fengrui 程式撰寫規範修正
# Modify.........: No.TQC-C50135 12/05/15 By fengrui sql語句中少單引號 
# Modify.........: No:TQC-CA0025 12/10/29 By Elise 將呼叫cl_used(1)及cl_used(2)移到MAIN段
# Modify.........: No:MOD-D10141 13/01/28 By bart "主件料件數量"同sfb08可入小數位數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD				# Print condition RECORD
            wc         LIKE type_file.chr500,	# Where condition
            revision   LIKE type_file.chr2,     # 版本
            effective  LIKE type_file.dat,      # 有效日期
            #a          LIKE type_file.num10,    # Assembly Part QTY #MOD-D10141
            a         LIKE sfb_file.sfb08,    #MOD-D10141
            s          LIKE type_file.chr1,     # Sort Sequence
            loc        LIKE type_file.chr1,     # 報表格式
            c          LIKE type_file.chr1,     # 是否列印說明
            b          LIKE type_file.chr1,     # 是否列印說明
            x          LIKE type_file.chr1,     # BugNo:5347
            y          LIKE type_file.chr1,     # BugNo:5347
            d          LIKE type_file.chr1,     # 是否打印SET取替代料件 FUN-890106
            more       LIKE type_file.chr1 	# Input more condition(Y/N)
           END RECORD
DEFINE g_bma01_a       LIKE bma_file.bma01
DEFINE g_tot           LIKE type_file.num10
DEFINE g_chr           LIKE type_file.chr1
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5      #count/index for any purpose
DEFINE l_table1        STRING                         
DEFINE l_table2        STRING                            
DEFINE l_table3        STRING                    
DEFINE l_table4        STRING                          
DEFINE l_table5        STRING                          
DEFINE l_table6        STRING                   #No.FUN-890106                    
DEFINE g_str           STRING                        
DEFINE g_sql           STRING    
DEFINE g_no            LIKE type_file.num10     #No.MOD-830063 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #TQC-CA0025 move
 
   LET g_sql = " g_bma01_a.bma_file.bma01,",   
            " l_ver.ima_file.ima05,",
            " p_i.type_file.num5,",  
            " l_ima05.ima_file.ima05, ",
            " l_ima08.ima_file.ima08,",
            " l_ima63.ima_file.ima63,",
            " l_ima55.ima_file.ima55,",
            " l_ima02.ima_file.ima02,",
            " l_ima021.ima_file.ima021,",
            " p_acode.bma_file.bma06,",
            " g_str.type_file.chr1000,",
            " p_level.type_file.num5,",
            " bmb01.bmb_file.bmb01,", 
            " bmb02.bmb_file.bmb02,",
            " bmb03.bmb_file.bmb03,",
            " l_point.type_file.chr10,",
            " ima08.ima_file.ima08,",
            " bmb10.bmb_file.bmb10,",
            " p_total.type_file.num20_6,",
            " bmb04.bmb_file.bmb04,",
            " bmb08.bmb_file.bmb08,",
            " bmb16.bmb_file.bmb16,",
            " ima15.ima_file.ima15,",
            " ima02.ima_file.ima02,",
            " bmb05.bmb_file.bmb05,",
            " bmb29.bmb_file.bmb29,",
            " ima021.ima_file.ima021,",
            " l_bmt06.bmt_file.bmt06,",
            " l_bmc05.bmc_file.bmc05,",
            " bmd04.bmd_file.bmd04,",
            " bmd05.bmd_file.bmd05,",
            " bmd06.bmd_file.bmd06,",
            " bmd09.bmd_file.bmd09,",
            " bmd07.bmd_file.bmd07,",
            " l_ima02_1.ima_file.ima02,",
            " l_ima021_1.ima_file.ima021,",
            " bmj02.bmj_file.bmj02,",
            " bmj04.bmj_file.bmj04,",
            " bmj03.bmj_file.bmj03,",
            " bmj10.bmj_file.bmj10,",
            " bmj11.bmj_file.bmj11, ",    #No.MOD-830063 add , 
            " g_no.type_file.num10 "      #No.MOD-830063 add  
 
   LET l_table1 = cl_prt_temptable('abmr8011',g_sql) CLIPPED                    
   IF l_table1 = -1 THEN EXIT PROGRAM END IF     
 
   LET g_sql = " bmt01.bmt_file.bmt01,",
               " bmt02.bmt_file.bmt02,",
               " bmt03.bmt_file.bmt03,",
               " bmt04.bmt_file.bmt04,",
               " bmt08.bmt_file.bmt08,",
               " bmt05.bmt_file.bmt05,",
               " bmt06.type_file.chr1000 "          #No.CHI-810006 
 
   LET l_table2 = cl_prt_temptable('abmr8012',g_sql) CLIPPED
   IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " bmc01.bmc_file.bmc01,",
               " bmc02 .bmc_file.bmc02 ,",
               " bmc021.bmc_file.bmc021,",
               " bmc03.bmc_file.bmc03,",
               " bmc06.bmc_file.bmc06,",
               " bmc04.bmc_file.bmc04,",
               " bmc05.type_file.chr1000 "          #No.CHI-810006  
 
   LET l_table3 = cl_prt_temptable('abmr8013',g_sql) CLIPPED
   IF l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " bmd02.bmd_file.bmd02,",
               " bmd04.bmd_file.bmd04,",
               " bmd05.bmd_file.bmd05,",
               " bmd06.bmd_file.bmd06,",
               " bmd07.bmd_file.bmd07,",
               " bmd09.bmd_file.bmd09,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",          #MOD-830071-modify                               
               " bmd01.bmd_file.bmd01,",            #MOD-830071-add
               " bmd08.bmd_file.bmd08 "             #MOD-830071-add
                                                                                
   LET l_table4 = cl_prt_temptable('abmr8014',g_sql) CLIPPED                    
   IF l_table4 = -1 THEN EXIT PROGRAM END IF     
 
   LET g_sql = " bmj02.bmj_file.bmj02,",                                        
               " bmj04.bmj_file.bmj04 ,",                                      
               " bmj03.bmj_file.bmj03,",                                        
               " bmj10.bmj_file.bmj10,",                                        
               " bmj11.bmj_file.bmj11,",           #MOD-830071-modify
               " bmj01.bmj_file.bmj01 "            #MOD-830071-add
                                                                                
   LET l_table5 = cl_prt_temptable('abmr8015',g_sql) CLIPPED                    
   IF l_table5 = -1 THEN EXIT PROGRAM END IF      
 
   LET g_sql = " boa02.boa_file.boa02,",                                        
               " str1.type_file.chr1000 ,",                                      
               " bob03.bob_file.bob03,",                                        
               " bob04.bob_file.bob04,",                                        
               " bob10.bob_file.bob10,",                                        
               " bob11.bob_file.bob11,",                                        
               " bob12.bob_file.bob12,",                                        
               " bob07.bob_file.bob07,",                                        
               " ima02_b.ima_file.ima02,",                                        
               " ima021_b.ima_file.ima021,",
               " boa01.boa_file.boa01 "                                        
                                                                                
   LET l_table6 = cl_prt_temptable('abmr8016',g_sql) CLIPPED                    
   IF l_table6 = -1 THEN EXIT PROGRAM END IF      
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.revision  = ARG_VAL(8)
   LET tm.effective  = ARG_VAL(9)
   LET tm.a       = ARG_VAL(10)
   LET tm.s       = ARG_VAL(11)
   LET tm.loc     = ARG_VAL(12)
   LET tm.c       = ARG_VAL(13)
   LET tm.b       = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
  #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80100--add--   #TQC-CA0025 mark
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL r801_tm(0,0)			# Input print condition
      ELSE CALL r801()			# Read bmata and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--      
END MAIN
 
FUNCTION r801_tm(p_row,p_col)
   DEFINE   p_row,p_col	  LIKE type_file.num5,
            l_flag        LIKE type_file.num5,
            l_one         LIKE type_file.chr1,
            l_bdate       LIKE bmx_file.bmx07,	
            l_edate       LIKE bmx_file.bmx08,	
            l_bma01       LIKE bma_file.bma01,
            l_ima06       LIKE ima_file.ima06,	
            l_cmd	  LIKE type_file.chr1000
 
   OPEN WINDOW r801_w WITH FORM "abm/42f/abmr801"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.effective = g_today	#有效日期
   LET tm.a  = 1
   LET tm.s  = g_sma.sma65
   LET tm.loc= '1'
   LET tm.c  = 'N'
   LET tm.b  = 'N'
   LET tm.x  = 'N'
   LET tm.y  = 'N'
   LET tm.d  = 'N'   #No.FUN-890106
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_prtway = NULL
   LET g_copies = '1'
 
   WHILE TRUE
      CONSTRUCT tm.wc ON bma01,ima06,ima09,ima10,ima11,ima12,bma06 #FUN-550093
                    FROM item,class,ima09,ima10,ima11,ima12,bma06  #FUN-550093
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
   ON ACTION CONTROLP    #FUN-4B0001
      CASE WHEN INFIELD(item)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_bma3"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO item
           NEXT FIELD item
      END CASE
 
 
   ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
END CONSTRUCT
 
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r801_w
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
         EXIT PROGRAM
      END IF
      LET l_one='N'
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.wc != ' 1=1' THEN
         LET l_cmd="SELECT bma01,ima06 ",
                   " FROM bma_file,ima_file",
                   " WHERE bma01=ima01 AND ima08 != 'A' AND ",
                    tm.wc CLIPPED
         PREPARE r801_precnt FROM l_cmd
         IF SQLCA.sqlcode THEN
            CALL cl_err('Prepare:',SQLCA.sqlcode,1)
           #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
            EXIT PROGRAM
         END IF
         DECLARE r801_cnt
         CURSOR FOR r801_precnt
         MESSAGE " SEARCHING ! "
         FOREACH r801_cnt INTO l_bma01,l_ima06
           IF SQLCA.sqlcode  THEN
              CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
              CONTINUE WHILE
           ELSE
              LET l_one = 'Y'
              EXIT FOREACH
           END IF
         END FOREACH
         MESSAGE " "
         IF l_bma01 IS NULL OR l_bma01 = ' ' THEN
            CALL cl_err(SQLCA.sqlcode,'mfg2601',0)
            CONTINUE WHILE
         END IF
      END IF
 
      INPUT BY NAME tm.revision,tm.effective,tm.a,
                    tm.s,tm.loc,tm.c,tm.b,tm.x,tm.y,tm.d,tm.more WITHOUT DEFAULTS  #No.FUN-890106
 
         BEFORE FIELD revision
            IF l_one='N' THEN
               NEXT FIELD effective
            END IF
 
         AFTER FIELD revision
            IF tm.revision IS NOT NULL THEN
               CALL s_version(l_bma01,tm.revision)
               RETURNING l_bdate,l_edate,l_flag
               LET tm.effective = l_bdate
               IF cl_null(tm.effective) THEN
                   LET tm.effective = g_today	#有效日期
               END IF
               DISPLAY BY NAME tm.effective
            END IF
 
         AFTER FIELD a
            IF tm.a IS NULL OR tm.a < 0 THEN
               LET tm.a = 1
               DISPLAY BY NAME tm.a
            END IF
 
         AFTER FIELD s
            IF tm.s IS NULL OR tm.s NOT MATCHES'[1-3]' THEN
               NEXT FIELD s
            END IF
 
         AFTER FIELD loc
            IF tm.loc IS NULL OR tm.loc NOT MATCHES'[1-2]' THEN
               NEXT FIELD loc
            END IF
 
         AFTER FIELD b
            IF tm.b   IS NULL OR tm.b   NOT MATCHES'[YNyn]' THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD c
            IF tm.c   IS NULL OR tm.c   NOT MATCHES'[YNyn]' THEN
               NEXT FIELD c
            END IF
 
         AFTER FIELD x
            IF cl_null(tm.x) OR tm.x NOT MATCHES'[YNyn]' THEN
               NEXT FIELD x
            END IF
 
         AFTER FIELD y
            IF cl_null(tm.y) OR tm.y NOT MATCHES'[YNyn]' THEN
               NEXT FIELD y
            END IF
 
 
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES'[YNyn]' THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD more
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
         ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r801_w
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='abmr801'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('abmr801','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.revision CLIPPED,"'",
                            " '",tm.effective CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.loc CLIPPED,"'",
                            " '",tm.c   CLIPPED,"'",
                            " '",tm.b   CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('abmr801',g_time,l_cmd)	# Execute cmd at later time
         END IF
         CLOSE WINDOW r801_w
        #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r801()
      ERROR ""
   END WHILE
   CLOSE WINDOW r801_w
END FUNCTION
 
FUNCTION r801()
   DEFINE l_name    LIKE type_file.chr20,     # External(Disk) file name
          l_time    LIKE type_file.chr8,      # Usima time for running the job
          l_sql     STRING,                   #NO.FUN-910082
          l_za05    LIKE type_file.chr50,
          l_bma01   LIKE bma_file.bma01,      #主件料件
          l_bma01_a LIKE bma_file.bma01,
          l_bma06   LIKE bma_file.bma06       #FUN-550093
  #DEFINE l_sql1    LIKE type_file.chr1000
   DEFINE l_sql1    STRING                    #NO.FUN-910082
   DEFINE l_count   LIKE type_file.num5
   DEFINE l_cmd1    LIKE type_file.chr1000    #No.MOD-830063 add
 
    DROP TABLE bma_tmp
   CREATE TEMP TABLE bma_tmp(
     bma01   LIKE bma_file.bma01,
     bma06   LIKE bma_file.bma02)
   CREATE UNIQUE INDEX bma_tmp_01 on bma_tmp(bma01);
     CALL cl_del_data(l_table1)                                                 
     CALL cl_del_data(l_table2)                                                 
     CALL cl_del_data(l_table3)                                                 
     CALL cl_del_data(l_table4)   
     CALL cl_del_data(l_table5)
     CALL cl_del_data(l_table6)  #No.FUN-890106
 
     LET g_no = 1      #No.MOD-830063 add
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
                 "        ?,?                          ) "       #No.MOD-830063 modify
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?  )        "
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1:',status,1)
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?  )        "
     PREPARE insert_prep2 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep2:',status,1)
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                 " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ? )  "  #MOD-830071-modify
     PREPARE insert_prep3 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep3:',status,1)
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table5 CLIPPED,                     
                 " VALUES(?, ?, ?, ?, ?, ? )      "     #MOD-830071-modify
     PREPARE insert_prep4 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep4:',status,1)
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
        EXIT PROGRAM                      
     END IF          
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table6 CLIPPED,                     
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ? )      "     
     PREPARE insert_prep5 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep5:',status,1)
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
        EXIT PROGRAM                      
     END IF          
 
     #No.FUN-B80100--mark--Begin---
     #CALL cl_used(g_prog,l_time,1) RETURNING l_time #No.MOD-580088  HCN 20050818
     #No.FUN-B80100--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'abmr801'
     IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR

     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
 
     LET l_sql = "SELECT bma01,bma06 ", #FUN-550093
                 " FROM bma_file,ima_file",
                 " WHERE bma01 = ima01",
                 " AND ima08 !='A' AND ",tm.wc
     PREPARE r801_prepare1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
       #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
        EXIT PROGRAM
     END IF
     DECLARE r801_c1 CURSOR FOR r801_prepare1
 
 
     CALL r801_cur()
     FOREACH r801_c1 INTO l_bma01,l_bma06 #FUN-550093
       IF SQLCA.sqlcode THEN
          CALL cl_err('F1:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       LET g_bma01_a=l_bma01
       CALL r801_bom(0,l_bma01,tm.a,l_bma06)
       INSERT INTO bma_tmp VALUES(l_bma01,l_bma06)  #No.FUN-890106
     END FOREACH
     LET l_sql1 = "SELECT bma01 FROM bma_tmp"
     PREPARE bma_pretmp    FROM l_sql1
     DECLARE bma_tmp CURSOR FOR bma_pretmp  
     FOREACH bma_tmp INTO l_bma01_a
        CALL r801_bob(l_bma01_a)
     END FOREACH
 
 
     LET INT_FLAG = 0  ######add for prompt bug
     IF INT_FLAG THEN
        LET INT_FLAG = 0
     END IF
 
     LET l_cmd1=" ORDER BY g_no"      #No.MOD-830063 add
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,l_cmd1 CLIPPED,"|",   #No.MOD-830063 modify
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table5 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table6 CLIPPED        #No.FUN-890106
     LET g_str = ''                                                             
     #是否列印選擇條件                                                          
     IF g_zz05 = 'Y' THEN                                                       
        CALL cl_wcchp(tm.wc,'bma01,ima06,ima09,ima10,ima11,ima12,bma06')        
             RETURNING g_str                                                    
     END IF                                                                     
     LET g_str = g_str,";",tm.effective,";",g_sma.sma118,";",
                 g_sma.sma888[1,1],";",          
                 tm.loc,";",tm.x,";",tm.y,";",tm.c,";",tm.b,";",tm.a,";",tm.d                            
     CALL cl_prt_cs3('abmr801','abmr801',g_sql,g_str)                           
       #No.FUN-B80100--mark--Begin---
       #CALL cl_used(g_prog,l_time,2) RETURNING l_time #No.MOD-580088  HCN 20050818
       #No.FUN-B80100--mark--End-----
END FUNCTION
 
FUNCTION r801_bom(p_level,p_key,p_total,p_acode) #FUN-550093
   DEFINE p_level     LIKE type_file.num5,
          p_total     LIKE type_file.num26_10,
          p_total_1   LIKE type_file.num26_10,  #No:TQC-7A0013
          p_acode     LIKE bma_file.bma06, #FUN-550093
          l_tot       LIKE type_file.num10,
          l_times     LIKE type_file.num5,
          p_key	      LIKE bma_file.bma01,    #主件料件編號
          l_ac,i      LIKE type_file.num5,
          arrno	      LIKE type_file.num5,    #BUFFER SIZE (可存筆數)
         #b_seq	      LIKE type_file.num10,   #當BUFFER滿時,重新讀單身之起始ROWID   #MOD-B40114 mark
          l_chr,l_cnt LIKE type_file.chr1,
          l_fac       LIKE type_file.num26_10,
          l_order2    LIKE type_file.chr20,
          sr  DYNAMIC ARRAY OF RECORD         #每階存放資料
               bma01  LIKE bma_file.bma01,    #主件料件
               bmb01  LIKE bmb_file.bmb01,    #本階主件
               bmb02  LIKE bmb_file.bmb02,    #項次
               bmb03  LIKE bmb_file.bmb03,    #元件料號
               bmb04  LIKE bmb_file.bmb04,    #有效日期
               bmb05  LIKE bmb_file.bmb05,    #失效日期
               bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
               bmb08  LIKE bmb_file.bmb08,    #損耗率%
               bmb10  LIKE bmb_file.bmb10,    #發料單位
               bmb13  LIKE bmb_file.bmb13,    #插件位置
               bmb16  LIKE bmb_file.bmb16,    #替代特性
               ima02  LIKE ima_file.ima02,    #品名規格
               ima021 LIKE ima_file.ima02,    #品名規格
               ima05  LIKE ima_file.ima05,    #版本
               ima08  LIKE ima_file.ima08,    #來源
               ima15  LIKE ima_file.ima15,    #保稅否
               ima55  LIKE ima_file.ima55,    #生產單位
               ima63  LIKE ima_file.ima63,    #發料單位
               bmb29  LIKE bmb_file.bmb29     #FUN-550093
              END RECORD,
          l_cmd       LIKE type_file.chr1000 
   DEFINE l_bmd RECORD  #BugNo:5347                                             
                  bmd02  LIKE bmd_file.bmd02,                                   
                  bmd04  LIKE bmd_file.bmd04,                                   
                  bmd05  LIKE bmd_file.bmd05,                                   
                  bmd06  LIKE bmd_file.bmd06,                                   
                  bmd09  LIKE bmd_file.bmd09,                                   
                  bmd07  LIKE bmd_file.bmd07,                                   
                  ima02  LIKE ima_file.ima02,                                   
                  ima021 LIKE ima_file.ima021                                   
                END RECORD                                                      
   DEFINE l_bmj RECORD  #BugNo:5347                                             
                  bmj02  LIKE bmj_file.bmj02,                                   
                  bmj04  LIKE bmj_file.bmj04,                                   
                  bmj03  LIKE bmj_file.bmj03,                                   
                  bmj10  LIKE bmj_file.bmj10,                                   
                  bmj11  LIKE bmj_file.bmj11                                    
                END RECORD                  
   DEFINE l_ima02     LIKE ima_file.ima02,    # ~ W W  
          l_ima021    LIKE ima_file.ima02,    # ~ W W  
          l_ima05     LIKE ima_file.ima05,    #  Й
          l_ima06     LIKE ima_file.ima06,    #  Й
          l_ima08     LIKE ima_file.ima08,    #ㄓ方
          l_ima37     LIKE ima_file.ima37,    #干 f
          l_ima63     LIKE ima_file.ima63,    # o  蟲  
          l_ima55     LIKE ima_file.ima55,    #б玻蟲  
          l_bma02     LIKE bma_file.bma02,    # ~ W W  
          l_bma03     LIKE bma_file.bma03,    # ~ W W  
          l_bma04     LIKE bma_file.bma04,    # ~ W W  
          l_imz02     LIKE imz_file.imz02,    #弧  ォ e
          l_use_flag  LIKE type_file.chr2,           
          l_ute_flag  LIKE type_file.chr3,   #FUN-A40058 chr2->chr3        
          l_level     LIKE type_file.num5,
          l_pmh01     LIKE pmh_file.pmh01,
          l_pmh02     LIKE pmh_file.pmh02,
          l_pmh03     LIKE pmh_file.pmh03,
          l_pmh04     LIKE pmh_file.pmh04,
          l_pmh05     LIKE pmh_file.pmh05,
          l_pmh12     LIKE pmh_file.pmh12,
          l_pmh13     LIKE pmh_file.pmh13,
          l_pmc03     LIKE pmc_file.pmc03,
          l_ver       LIKE ima_file.ima05,
          l_k         LIKE type_file.num5,          
          l_str2      LIKE type_file.chr20,         
          l_bmb06     LIKE type_file.chr20,  
          l_total     LIKE type_file.chr20,  
          t_total     LIKE bmb_file.bmb06,
          l_bmt05     LIKE bmt_file.bmt05,
          l_bmc04     LIKE bmc_file.bmc04,
          l_bmt06_s   LIKE bmc_file.bmc06,
          l_now       LIKE type_file.num5,                                               
          l_now2      LIKE type_file.num5,                                               
          l_bmt06     ARRAY[200] OF LIKE type_file.chr20,                                       
          l_byte      LIKE type_file.num5,                                              
          l_len       LIKE type_file.num5,                                              
          l_bmtstr    LIKE bmc_file.bmc06,                                    
          l_bmc05     ARRAY[200] OF LIKE bmc_file.bmc05,  #MOD-A40183 mod  #CHAR(10)
         #l_bmc051    ARRAY[200] OF CHAR(30),             #MOD-A40183 mark
          l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
 
	IF p_level > 20 THEN
           CALL cl_err('','mfg2733',1) 
          #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
           EXIT PROGRAM
	END IF
        LET p_level = p_level + 1
        IF p_level = 1 THEN					#第0階主件資料
        INITIALIZE sr[1].* TO NULL
         LET g_pageno = 0 #MOD-4A0359
        LET sr[1].bmb03 = p_key
        CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver
        SELECT ima02,ima021,ima05,ima08,ima63,ima55
          INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55
          FROM ima_file
          WHERE ima01 = g_bma01_a
       IF SQLCA.sqlcode THEN
          LET l_ima02='' LET l_ima05='' LET l_ima08=''
          LET l_ima63='' LET l_ima55=''
       END IF  
       EXECUTE insert_prep USING g_bma01_a,l_ver,'0',l_ima05,l_ima08,l_ima63,
               l_ima55,l_ima02,l_ima021,p_acode,'','1',sr[1].bmb01,sr[1].bmb02,
               sr[1].bmb03,'',sr[1].ima08,sr[1].bmb10,tm.a,sr[1].bmb04,sr[1].bmb08,
               sr[1].bmb16,sr[1].ima15,sr[1].ima02,sr[1].bmb05,sr[1].bmb29,
               sr[1].ima021,
               '','','','','','','','','','','','','','',g_no    #No.MOD-830063 add g_no 
       LET g_no = g_no + 1   #No.MOD-830063 add
    
   END IF
	LET l_times=1
    LET arrno = 601
    WHILE TRUE
        LET l_cmd=
            "SELECT bma01, bmb01,bmb02, bmb03, bmb04, bmb05,",
            "       bmb06/bmb07,  bmb08, bmb10,",
            "       bmb13, bmb16, ",
            "       ima02,ima021,ima05, ima08, ima15,ima55,ima63,bmb29 ", #FUN-550093
            "  FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 LEFT OUTER JOIN bma_file ON bmb03 = bma01",
           #" WHERE bmb01='", p_key,"' AND bmb02 >",b_seq,     #MOD-B40114 mark
           #" WHERE bmb01='", p_key,                           #MOD-B40114 add  #TQC-C50135 mark
            " WHERE bmb01='", p_key,"'",                       #TQC-C50135 add
            "   AND bmb29 ='",p_acode,"'" #FUN-550093
 
        #---->生效日及失效日的判斷
        IF tm.effective IS NOT NULL THEN
            LET l_cmd=l_cmd CLIPPED,
                      " AND (bmb04 <='",tm.effective,"' OR bmb04 IS NULL)",
                      " AND (bmb05 > '",tm.effective,"' OR bmb05 IS NULL)"
        END IF
 
        #---->排列方式
        LET l_cmd=l_cmd CLIPPED, " ORDER BY "
    	CASE WHEN tm.s = '1'
                  LET l_cmd = l_cmd CLIPPED, ' bmb02'
                 WHEN tm.s = '2'
                  LET l_cmd = l_cmd CLIPPED, ' bmb03'
                 WHEN tm.s = '3'
                  LET l_cmd = l_cmd CLIPPED, ' bmb13'
        END CASE
 
        PREPARE r801_precur FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',STATUS,1)
          #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
           EXIT PROGRAM
        END IF
        DECLARE r801_cur CURSOR FOR r801_precur
        LET l_ac = 1
        FOREACH r801_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
            LET l_ac = l_ac + 1		    	# 但BUFFER不宜太大
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_tot = l_ac - 1
        FOR i = 1 TO l_tot    	        	# 讀BUFFER傳給REPORT
            LET l_fac = 1
            IF sr[i].ima55 !=sr[i].bmb10 THEN
               CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,sr[i].ima55)
                    RETURNING l_cnt,l_fac    #單位換算
               IF l_cnt = '1'  THEN #有問題
                  CALL cl_err(sr[i].bmb03,'abm-731',1)
                  LET g_success = 'N'
                  EXIT FOR
                  RETURN
               END IF
            END IF
            LET l_total=p_total*sr[i].bmb06*l_fac
            CALL s_effver(g_bma01_a,tm.effective) RETURNING l_ver                   
            SELECT ima02,ima021,ima05,ima08,ima63,ima55                             
              INTO l_ima02,l_ima021,l_ima05,l_ima08,l_ima63,l_ima55                 
              FROM ima_file                                                         
              WHERE ima01 = g_bma01_a                                               
            IF SQLCA.sqlcode THEN                                                    
               LET l_ima02='' LET l_ima05='' LET l_ima08=''                          
               LET l_ima63='' LET l_ima55=''                                         
            END IF  
            #---->�改變替代特性的表示方式 
            IF sr[i].bmb16 MATCHES '[127]' THEN         #FUN-A40058 ADD '7'
               LET g_cnt=sr[i].bmb16 USING '&'
               LET sr[i].bmb16=l_ute_flag[g_cnt,g_cnt]
            ELSE
               LET sr[i].bmb16=' '
            END IF
            LET p_total_1 = p_total*sr[i].bmb06
            EXECUTE insert_prep USING g_bma01_a,l_ver,i,l_ima05,l_ima08,l_ima63,   
               l_ima55,l_ima02,l_ima021,p_acode,'',p_level,sr[i].bmb01,sr[i].bmb02,       
               sr[i].bmb03,'',sr[i].ima08,sr[i].bmb10,p_total_1,sr[i].bmb04,sr[i].bmb08,    
               sr[i].bmb16,sr[i].ima15,sr[i].ima02,sr[i].bmb05,sr[i].bmb29,
               sr[i].ima021,          
               '','','','','','','','','','','','','','',g_no    #No.MOD-830063 add g_no    
            #子報表--插件
            LET g_no = g_no +1    #No.MOD-830063 add
            IF tm.c = 'Y' THEN                                                  
               FOR g_cnt=1 TO 200                                               
                   LET l_bmt06[g_cnt]=NULL                                      
               END FOR                                                          
               LET l_now2=1                                                     
               LET l_len =20                                                    
               LET l_bmtstr = ''                                                
               LET l_cmd  = " SELECT bmt05,bmt06 FROM bmt_file ",
                            " WHERE bmt01=?  AND bmt02= ? AND ",
                            " bmt03=? AND ",
                            " (bmt04 IS NULL OR bmt04 >= ?) ",
                            " AND bmt08 = ?",  #FUN-550093
                            " ORDER BY 1"
               PREPARE r801_prebmt FROM l_cmd
               IF SQLCA.sqlcode THEN
                  CALL cl_err('prepare:',SQLCA.sqlcode,1)
                 #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
                  EXIT PROGRAM
               END IF
               DECLARE r801_bmt  CURSOR FOR r801_prebmt
               FOREACH r801_bmt
                   USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,sr[i].bmb29 #FUN-550093
                   INTO l_bmt05,l_bmt06_s
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
                   END IF
                   IF l_now2 > 200 THEN                                         
                      CALL cl_err('','9036',1)                                  
                     #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
                      EXIT PROGRAM                                              
                   END IF                                                       
                   LET l_byte = length(l_bmt06_s) + 1                           
                   IF l_len >= l_byte THEN                                      
                      LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','     
                      LET l_len = l_len - l_byte                                
                   ELSE                                                         
                      LET l_bmt06[l_now2] = l_bmtstr                            
                      LET l_now2 = l_now2 + 1                                   
                      LET l_len = 20                                            
                      LET l_len = l_len - l_byte                                
                      LET l_bmtstr = ''                                         
                      LET l_bmtstr = l_bmtstr clipped,l_bmt06_s clipped,','     
                   END IF                                                       
               END FOREACH
                LET l_bmt06[l_now2] = l_bmtstr                                  
                FOR g_cnt = 1 TO l_now2                                         
                    IF l_bmt06[g_cnt] IS NULL OR l_bmt06[g_cnt] = ' '           
                     THEN                                                       
                         EXIT FOR                                               
                    END IF                                                      
                                                                                
                    EXECUTE insert_prep1 USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,
                                               sr[i].bmb29,l_bmt05,l_bmt06[g_cnt]
                 END FOR                                                        
             END IF                                                             
                  
             #子報表---說明
             IF tm.b ='Y' THEN
             FOR g_cnt=1 TO 200
                 LET l_bmc05[g_cnt]=NULL
             END FOR
             LET l_now = 1                                      #No.CHI-810006 
             LET l_cmd  = " SELECT bmc04,bmc05 FROM bmc_file ",
                          " WHERE bmc01=?  AND bmc02= ? AND ",
                          " bmc021=? AND ",
                          " (bmc03 IS NULL OR bmc03 >= ?) ",
                          " AND bmc06 = ? ", #FUN-550093
                          " ORDER BY 1"
             PREPARE r801_prebmc    FROM l_cmd
             IF SQLCA.sqlcode THEN
                CALL cl_err('prepare:',SQLCA.sqlcode,1)
               #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
                EXIT PROGRAM
             END IF
             DECLARE r801_bmc CURSOR FOR r801_prebmc
             FOREACH r801_bmc
             USING sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,sr[i].bmb29 #FUN-550093
             INTO l_bmc04,l_bmc05[l_now]                                       #No.CHI-810006
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('Foreach:',SQLCA.sqlcode,0) EXIT FOREACH
                 END IF
                 IF l_now > 200 THEN                                            
                    CALL cl_err('','9036',1)                                    
                   #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
                    EXIT PROGRAM                                                
                 END IF                                                         
                 LET l_now=l_now+1 
             END FOREACH
             LET l_now=l_now-1                                                  
             #--->列印剩下說明                                                  
             IF l_now >= 1 THEN                                                 
                FOR g_cnt = 1 TO l_now   #MOD-A40183 mod  #STEP 2                                   
                  #LET l_bmc051[g_cnt] = l_bmc05[g_cnt],' ',l_bmc05[g_cnt+1]   #MOD-A40183 mark
                   EXECUTE insert_prep2 USING
                      sr[i].bmb01,sr[i].bmb02,sr[i].bmb03,sr[i].bmb04,
                      sr[i].bmb29,l_bmc04,l_bmc05[g_cnt]   #MOD-A40183 mod #l_bmc051->l_bmc05
                END FOR                                                         
             END IF                                                             
             END IF
             #子報表---列印元件取代料件資料
             IF tm.x ='Y' THEN
                INITIALIZE l_bmd.* TO NULL
                LET g_i = 1          
                LET l_cmd = "SELECT bmd02,bmd04,bmd05,bmd06,bmd09,bmd07,'','' FROM bmd_file",
                            " WHERE bmd01 = ?",
                            "   AND (bmd08 = ? OR bmd08 = 'ALL')",
                            "   AND bmdacti = 'Y'"                                           #CHI-910021
                IF NOT cl_null(tm.effective) THEN
                   LET l_cmd = l_cmd CLIPPED,
                           " AND (bmd05 <='",tm.effective,"' OR bmd05 IS NULL)",
                           " AND (bmd06 > '",tm.effective,"' OR bmd06 IS NULL)"
                END IF
                PREPARE r801_prebmd    FROM l_cmd
                IF SQLCA.sqlcode THEN
                   CALL cl_err('prebmd',SQLCA.sqlcode,1)
                  #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
                   EXIT PROGRAM
                END IF
                DECLARE r801_bmd CURSOR FOR r801_prebmd   
                FOREACH r801_bmd USING sr[i].bmb03,sr[i].bmb01
                   INTO l_bmd.*           
                   SELECT ima02,ima021
                       INTO l_bmd.ima02,l_bmd.ima021
                       FROM ima_file
                      WHERE ima01 = l_bmd.bmd04   
                   EXECUTE insert_prep3 USING l_bmd.bmd02,l_bmd.bmd04,  #MOD-850322
                                              l_bmd.bmd05,l_bmd.bmd06,
                                              l_bmd.bmd07,l_bmd.bmd09,l_bmd.ima02,
                                              l_bmd.ima021,                #MOD-830071-modify
                                              sr[i].bmb03,sr[i].bmb01      #MOD-830071-modify
                                             
                   LET g_i = 0
              END FOREACH
          END IF
          #子報表--列印料件承認資料
          IF tm.y ='Y' THEN
              INITIALIZE l_bmj.* TO NULL
 
              LET g_i = 1
              LET l_cmd = "SELECT bmj02,bmj04,bmj03,bmj10,bmj11 FROM bmj_file",   #MOD-830071-modify
                          " WHERE bmj01 = ?",
                          "   AND bmj08 = '3'"
              IF NOT cl_null(tm.effective) THEN
                 LET l_cmd = l_cmd CLIPPED,
                             " AND (bmj11 <='",tm.effective,"' OR bmj11 IS NULL)"
              END IF
              PREPARE r801_prebmj    FROM l_cmd
              IF SQLCA.sqlcode THEN
                 CALL cl_err('prebmj',SQLCA.sqlcode,1)
                #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
                 EXIT PROGRAM
              END IF
              DECLARE r801_bmj CURSOR FOR r801_prebmj
              FOREACH r801_bmj USING sr[i].bmb03
                 INTO l_bmj.*
                 EXECUTE insert_prep4 USING l_bmj.bmj02,l_bmj.bmj04, #MOD-830071-modify 
                                            l_bmj.bmj03,l_bmj.bmj10, #MOD-830071-modify
                                            l_bmj.bmj11,sr[i].bmb03  #MOD-830071-modify 
                 LET g_i = 0
              END FOREACH
       END IF                 
            IF sr[i].bma01 IS NOT NULL THEN #若為主件
               CALL r801_bom(p_level,sr[i].bmb03,p_total*sr[i].bmb06*l_fac,l_ima910[i]) #FUN-8B0015
            END IF
        END FOR
        IF l_tot < arrno OR l_tot=0 THEN                 # BOM單身已讀完
            EXIT WHILE
        ELSE
           # LET b_seq = sr[l_tot].bmb02                 #MOD-B40114 mark
		LET l_times=l_times+1
        END IF
    END WHILE
END FUNCTION
 
FUNCTION r801_bob(p_bma01_a)
          DEFINE l_boa   RECORD LIKE boa_file.*
          DEFINE l_bob   RECORD LIKE bob_file.*
          DEFINE p_bma01_a      LIKE bma_file.bma01
          DEFINE l_ima02_a      LIKE ima_file.ima02
          DEFINE l_ima021_a     LIKE ima_file.ima021
          DEFINE l_ima02_b      LIKE ima_file.ima02
          DEFINE l_ima021_b     LIKE ima_file.ima021
          DEFINE l_boa01        LIKE boa_file.boa01
          DEFINE l_boa02        LIKE boa_file.boa02
          DEFINE l_boa03        LIKE boa_file.boa03
          DEFINE l_boa06        LIKE boa_file.boa06
          DEFINE l_boa07        LIKE boa_file.boa07
          DEFINE l_bob03        LIKE bob_file.bob03
          DEFINE l_bob04        LIKE bob_file.bob04
          DEFINE l_bob05        LIKE bob_file.bob05
          DEFINE l_bob06        LIKE bob_file.bob06
          DEFINE l_bob10        LIKE bob_file.bob10
          DEFINE l_bob11        LIKE bob_file.bob11
          DEFINE l_bob12        LIKE bob_file.bob12
          DEFINE l_bob07        LIKE bob_file.bob07
          DEFINE l_cmd          STRING
          DEFINE l_str          LIKE type_file.chr1000
          DEFINE l_str1         LIKE type_file.chr1000
 
    DROP TABLE r801_tmp
   CREATE TEMP TABLE r801_tmp(
     bob01   LIKE bob_file.bob01,
     bob02   LIKE bob_file.bob02,
     l_str   LIKE type_file.chr1000,
     bob03   LIKE bob_file.bob03,
     bob04   LIKE bob_file.bob04,
     bob05   LIKE bob_file.bob05,
     bob06   LIKE bob_file.bob06,
     bob10   LIKE bob_file.bob10,
     bob11   LIKE bob_file.bob11,
     bob12   LIKE bob_file.bob12,
     bob07   LIKE bob_file.bob07)
       IF tm.d ='Y' THEN
          LET l_cmd = "SELECT UNIQUE boa01,boa02 from boa_file WHERE boa01 = ?"
          PREPARE r801_preboa    FROM l_cmd
          IF SQLCA.sqlcode THEN
             CALL cl_err('preboa',SQLCA.sqlcode,1)
            #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
             EXIT PROGRAM
          END IF
          DECLARE r801_boa CURSOR FOR r801_preboa  
          LET l_cmd = "SELECT * from bob_file WHERE bob01 = ? and bob02 = ? "
          IF NOT cl_null(tm.effective) THEN
             LET l_cmd = l_cmd CLIPPED,
                 " AND (bob10 <='",tm.effective,"' OR bob10 IS NULL)",
                 " AND (bob11 > '",tm.effective,"' OR bob11 IS NULL)"
          END IF
          PREPARE r801_prebob    FROM l_cmd
          IF SQLCA.sqlcode THEN
             CALL cl_err('prebob',SQLCA.sqlcode,1)
            #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add--  #TQC-CA0025 mark
             EXIT PROGRAM
          END IF
          DECLARE r801_bob CURSOR FOR r801_prebob  
          LET l_cmd = "SELECT boa03 FROM boa_file WHERE boa01=? and boa02=? "
          PREPARE r801_preboa03    FROM l_cmd
          DECLARE r801_boa03 CURSOR FOR r801_preboa03
          LET l_cmd = "SELECT * FROM r801_tmp "
          PREPARE r801_pretmp    FROM l_cmd
          DECLARE r801_tmp CURSOR FOR r801_pretmp  
          FOREACH r801_boa USING p_bma01_a
                   INTO l_boa.boa01,l_boa.boa02
            LET l_str = NULL
            FOREACH r801_boa03 USING l_boa.boa01,l_boa.boa02
                    INTO l_boa.boa03
               IF cl_null(l_str) THEN
                  LET l_str = l_str,l_boa.boa03 CLIPPED
               ELSE
                 LET l_str = l_str,',',l_boa.boa03 CLIPPED        
               END IF   
            END FOREACH
              FOREACH r801_bob USING l_boa.boa01,l_boa.boa02
                 INTO l_bob.*
               INSERT INTO r801_tmp VALUES(l_boa.boa01,l_boa.boa02,l_str,
                                        l_bob.bob03,l_bob.bob04,l_bob.bob05,l_bob.bob06,
                                        l_bob.bob10,l_bob.bob11,l_bob.bob12,l_bob.bob07)
             END FOREACH
          END FOREACH
           FOREACH r801_tmp INTO l_boa01,l_boa02,l_str1,
                                 l_bob03,l_bob04,l_bob05,
                                 l_bob06,l_bob10,l_bob11,l_bob12,l_bob07
           SELECT ima02,ima021
             INTO l_ima02_b,l_ima021_b
             FROM ima_file
            WHERE ima01 = l_bob04   
           EXECUTE insert_prep5 USING l_boa02,l_str1,
                                      l_bob03,l_bob04,
                                      l_bob10,l_bob11,l_bob12,l_bob07,
                                      l_ima02_b,l_ima021_b,p_bma01_a
           END FOREACH
       END IF
END FUNCTION
 
 
FUNCTION r801_cur()
END FUNCTION
 
 
#No.FUN-9C0077 程式精簡
