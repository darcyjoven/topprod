# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: axrg400.4gl
# Descriptions...: 收款沖帳單
# Date & Author..: 95/02/06 by Nick
# Modify.........: No.FUN-4C0100 04/12/28 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.MOD-610021 06/01/05 By Smapmin 增加列印備註
# Modify.........: No.MOD-610050 06/01/12 By Smapmin 類別名稱列印有誤
# Modify.........: No.MOD-640088 06/04/09 By Smapmin 條件選已確認,仍會印出未確認資料
# Modify.........: No.TQC-660010 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/09 By king 改正報表中有關錯誤
# Modify.........: No.TQC-6B0190 06/12/04 By Smapmin 增加報表列印條件
# Modify.........: No.TQC-6B0051 06/12/12 By xufeng  修改報表格式
# Modify.........: No.FUN-740009 07/04/04 By Ray 會計科目加帳套 
# Modify.........: No.TQC-770028 07/07/05 By Rayven 制表日期與報表名稱所在的行數顛倒
# Modify.........: No.FUN-7A0025 07/10/18 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.MOD-810076 08/01/11 By Smapmin 修改備註列印
# Modify.........: No.TQC-810052 08/01/16 By Smapmin 增加整張單據尾顯示備註
# Modify.........: No.FUN-940042 09/05/06 By TSD.Wind 在CR報表列印簽核欄
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-A50082 10/05/24 By Carrier blob变量先使用前需要用LOCATE先初始化
# Modify.........: No.FUN-B20014 11/02/12 By lilingyu SQL增加ooa37='1'的條件
# Modify.........: No.FUN-B40087 11/05/23 By yangtt  憑證報表轉GRW 
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修
# Modify.........: No:FUN-C10036 12/01/11 By yangtt 1、程序撰寫規範修
#                                                   2、MOD-BC0160追單
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片 
# Modify.........: No.FUN-C90130 12/09/28 By yangtt 增加開窗功能
# Modify.........: No.FUN-D20056 13/02/19 By lujh FUN-CA0102還原

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                # Print condition RECORD
              wc      LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000) # Where condition
              n       LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)   # 列印條件(1.確認2.未確認3.全部)
              more    LIKE type_file.chr1           # Prog. Version..: '5.30.06-13.03.12(01)   # Input more condition(Y/N)
              END RECORD,
          l_n         LIKE type_file.num5           #No.FUN-680123 SMALLINT
 
DEFINE   g_i          LIKE type_file.num5           #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   g_sql        STRING                        #No.FUN-7A0025
DEFINE   g_str        STRING                        #No.FUN-7A0025
DEFINE   l_table      STRING                        #No.FUN-7A0025
DEFINE   l_table1     STRING                        #No.FUN-7A0025
DEFINE   l_table2     STRING                        #No.FUN-7A0025
DEFINE   l_table3     STRING                        #MOD-810076
DEFINE   l_table4     STRING                        #TQC-810052
 
###GENGRE###START
TYPE sr1_t RECORD
    ooa01 LIKE ooa_file.ooa01,
    ooa02 LIKE ooa_file.ooa02,
    ooa03 LIKE ooa_file.ooa03,
    ooa032 LIKE ooa_file.ooa032,
    ooa15 LIKE ooa_file.ooa15,
    gem02 LIKE gem_file.gem02,
    ooa13 LIKE ooa_file.ooa13,
    oob02 LIKE oob_file.oob02,
    oob03 LIKE oob_file.oob03,
    ooc02 LIKE ooc_file.ooc02,
    oob05 LIKE oob_file.oob05,
    oob06 LIKE oob_file.oob06,
    oob07 LIKE oob_file.oob07,
    oob08 LIKE oob_file.oob08,
    oob09 LIKE oob_file.oob09,
    oob10 LIKE oob_file.oob10,
    oob11 LIKE oob_file.oob11,
    aag02 LIKE aag_file.aag02,
    oob12 LIKE oob_file.oob12,
    azi04 LIKE azi_file.azi04,
    azi05 LIKE azi_file.azi05,
    azi07 LIKE azi_file.azi07,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str LIKE type_file.chr1000  #FUN-C40019 add
END RECORD

TYPE sr2_t RECORD
    oao01 LIKE oao_file.oao01,
    oao03 LIKE oao_file.oao03,
    oao05 LIKE oao_file.oao05,
    oao06 LIKE oao_file.oao06
END RECORD

TYPE sr3_t RECORD
    oao01_1 LIKE oao_file.oao01,
    oao03_1 LIKE oao_file.oao03,
    oao05_1 LIKE oao_file.oao05,
    oao06_1 LIKE oao_file.oao06
END RECORD

TYPE sr4_t RECORD
    oao01_2 LIKE oao_file.oao01,
    oao03_2 LIKE oao_file.oao03,
    oao05_2 LIKE oao_file.oao05,
    oao06_2 LIKE oao_file.oao06
END RECORD

TYPE sr5_t RECORD
    oao01_3 LIKE oao_file.oao01,
    oao03_3 LIKE oao_file.oao03,
    oao05_3 LIKE oao_file.oao05,
    oao06_3 LIKE oao_file.oao06
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                  # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127   #FUN-C10036   mark
 
   #No.FUN-7A0025 --start--
   LET g_sql="ooa01.ooa_file.ooa01,ooa02.ooa_file.ooa02,ooa03.ooa_file.ooa03,",
             "ooa032.ooa_file.ooa032,ooa15.ooa_file.ooa15,",
             #"gem02.gem_file.gem02,ooa13.ooa_file.ooa13,oob03.oob_file.oob03,",   #MOD-810076
             "gem02.gem_file.gem02,ooa13.ooa_file.ooa13,oob02.oob_file.oob02,oob03.oob_file.oob03,",   #MOD-810076
             "ooc02.ooc_file.ooc02,oob05.oob_file.oob05,oob06.oob_file.oob06,",
             "oob07.oob_file.oob07,oob08.oob_file.oob08,oob09.oob_file.oob09,",
             "oob10.oob_file.oob10,oob11.oob_file.oob11,aag02.aag_file.aag02,",
             "oob12.oob_file.oob12,azi04.azi_file.azi04,azi05.azi_file.azi05,",
             "azi07.azi_file.azi07,",
             "sign_type.type_file.chr1, sign_img.type_file.blob,",    #簽核方式, 簽核圖檔     #FUN-940042
             "sign_show.type_file.chr1,",                             #是否顯示簽核資料(Y/N)  #FUN-940042
             "sign_str.type_file.chr1000"                       #FUN-C40019 add
   LET l_table = cl_prt_temptable('axrg400',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087    #FUN-C10036   mark                                                     
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
 
   #-----MOD-810076---------
   #LET g_sql="oao01.oao_file.oao01,oao05.oao_file.oao05,oao06.oao_file.oao06"
   #LET l_table1 = cl_prt_temptable('axrg4001',g_sql) CLIPPED
   #IF l_table1 = -1 THEN EXIT PROGRAM END IF
   #
   #LET g_sql="oao01_1.oao_file.oao01,oao05_1.oao_file.oao05,",
   #          "oao06_1.oao_file.oao06"
   #LET l_table2 = cl_prt_temptable('axrg4002',g_sql) CLIPPED
   #IF l_table2 = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = "oao01.oao_file.oao01,",
               "oao03.oao_file.oao03,",
               "oao05.oao_file.oao05,",
               "oao06.oao_file.oao06 "
   LET l_table1 = cl_prt_temptable('axrg4001',g_sql) CLIPPED                      
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087     #FUN-C10036   mark                                                     
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF
 
   LET g_sql = "oao01_1.oao_file.oao01,",                                         
               "oao03_1.oao_file.oao03,",                                         
               "oao05_1.oao_file.oao05,",                                         
               "oao06_1.oao_file.oao06 "                                          
                                                                                
   LET l_table2 = cl_prt_temptable('axrg4002',g_sql) CLIPPED                    
   IF l_table2 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087     #FUN-C10036   mark                                                    
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF      
 
   LET g_sql = "oao01_2.oao_file.oao01,",                                         
               "oao03_2.oao_file.oao03,",                                         
               "oao05_2.oao_file.oao05,",                                         
               "oao06_2.oao_file.oao06 "                                          
                                                                                
   LET l_table3 = cl_prt_temptable('axrg4003',g_sql) CLIPPED                    
   IF l_table3 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087      #FUN-C10036   mark                                                   
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                          
 
   LET g_sql = "oao01_3.oao_file.oao01,",                                         
               "oao03_3.oao_file.oao03,",                                         
               "oao05_3.oao_file.oao05,",                                         
               "oao06_3.oao_file.oao06 "                                          
                                                                                
   LET l_table4 = cl_prt_temptable('axrg4004',g_sql) CLIPPED                    
   IF l_table4 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time     #FUN-B40087     #FUN-C10036   mark                                                    
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087   #FUN-C10036   mark
      EXIT PROGRAM 
   END IF                          
   #-----END MOD-810076-----
 
   #No.FUN-7A0025 --end--
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #FUN-C10036  add
   INITIALIZE tm.* TO NULL            # Default condition
   #-----TQC-660010---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.n = ARG_VAL(8)
   #-----END TQC-660010-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---   #No.FUN-680123
#FUN-B40087 ---MARK----STR----
#  CREATE TEMP TABLE g400_tmp
#  (tmp01 LIKE azi_file.azi01,
#   tmp02 LIKE type_file.chr1,  
#   tmp03 LIKE type_file.num20_6,
#   tmp04 LIKE type_file.num20_6)
#         #No.FUN-680123 end
#  create unique index g400_tmp_01 on g400_tmp(tmp01,tmp02);
#FUN-B40087 ---MARK----END------
   IF cl_null(tm.wc) THEN
      CALL axrg400_tm(0,0)             # Input print condition
   ELSE 
      CALL axrg400()                   # Read data and create out-file
   END IF
#  DROP TABLE g400_tmp     #FUN-B40087
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
END MAIN
 
FUNCTION axrg400_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01        #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000     #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW axrg400_w AT p_row,p_col
        WITH FORM "axr/42f/axrg400"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   #-----TQC-660010---------
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.n ='1'
   #-----END TQC-660010-----
 
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ooa01,ooa02,ooa03,ooa15
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

        #No.FUN-C90130  --Begin
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ooa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ooa3"  
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa01
                 NEXT FIELD ooa01
              WHEN INFIELD(ooa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ11"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa03
                 NEXT FIELD ooa03
              WHEN INFIELD(ooa15)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ooa15
                 NEXT FIELD ooa15
              END CASE
        #No.FUN-C90130  --End
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrg400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.n,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD n
         IF cl_null(tm.n) OR tm.n NOT MATCHES '[123]' THEN
            NEXT FIELD n
         END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW axrg400_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrg400'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrg400','9031',1)
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
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.n CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrg400',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrg400_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrg400()
   ERROR ""
END WHILE
   CLOSE WINDOW axrg400_w
END FUNCTION
 
FUNCTION axrg400()
   DEFINE l_name    LIKE type_file.chr20,        #No.FUN-680123 VARCHAR(20) # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,      #No.FUN-680123 VARCHAR(40)
          sr        RECORD
                    ooa01     LIKE ooa_file.ooa01,
                    ooa02     LIKE ooa_file.ooa02,
                    ooa03     LIKE ooa_file.ooa03,
                    ooa032    LIKE ooa_file.ooa032,
                    ooa15     LIKE ooa_file.ooa15,
                    gem02     LIKE gem_file.gem02,
                    ooa13     LIKE ooa_file.ooa13,
                    ooaconf   LIKE ooa_file.ooaconf,
                    oob02     LIKE oob_file.oob02,   #MOD-810076
                    oob03     LIKE oob_file.oob03,
                    oob04     LIKE oob_file.oob04,
                    oob05     LIKE oob_file.oob05,
                    oob06     LIKE oob_file.oob06,
                    oob07     LIKE oob_file.oob07,
                    oob08     LIKE oob_file.oob08,
                    oob09     LIKE oob_file.oob09,
                    oob10     LIKE oob_file.oob10,
                    oob11     LIKE oob_file.oob11,        #No.FUN-680123 VARCHAR(12) 
                    aag00     LIKE aag_file.aag00,        #No.FUN-740009  
                    aag02     LIKE aag_file.aag02,
                    oob12     LIKE oob_file.oob12,
                    azi03     LIKE azi_file.azi03,
                    azi04     LIKE azi_file.azi04,
                    azi05     LIKE azi_file.azi05,
                    azi07     LIKE azi_file.azi07
                    END RECORD
   DEFINE l_flag1    LIKE type_file.chr1       #No.FUN-740009                                                                       
   DEFINE l_bookno1  LIKE aza_file.aza81       #No.FUN-740009                                                                       
   DEFINE l_bookno2  LIKE aza_file.aza82       #No.FUN-740009 
   DEFINE l_oob04a   LIKE ooc_file.ooc02       #No.FUN-7A0025
   DEFINE l_oao06    LIKE oao_file.oao06       #No.FUN-7A0025
   ###FUN-940042 START ###
   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_ii           INTEGER
   DEFINE l_sql_2        LIKE type_file.chr1000        # RDSQL STATEMENT
   DEFINE l_key          RECORD                  #主鍵
             v1          LIKE ooa_file.ooa01
                         END RECORD
   ###FUN-940042 END ###

     LOCATE l_img_blob IN MEMORY   #No.TQC-A50082
 
     #No.FUN-7A0025 --start--
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,              
                 #" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"    #MOD-810076           
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",   #MOD-810076           
                 "        ?, ?, ? ,?)"  #FUN-940042     #FUN-C40019 add 1?
     PREPARE insert_prep FROM g_sql                                               
     IF STATUS THEN                                                               
        CALL cl_err('insert_prep',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087
        EXIT PROGRAM                          
     END IF             
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 #" VALUES(?,?,?)"   #MOD-810076
                 " VALUES(?,?,?,?)"   #MOD-810076
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep1',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087
        EXIT PROGRAM
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,            
                 #" VALUES(?,?,?)"    #MOD-810076                                               
                 " VALUES(?,?,?,?)"    #MOD-810076                                               
     PREPARE insert_prep2 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep2',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087
        EXIT PROGRAM                       
     END IF 
 
     #-----MOD-810076---------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,            
                 " VALUES(?,?,?,?)"                                                  
     PREPARE insert_prep3 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep3',status,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087
        EXIT PROGRAM                       
     END IF 
     #-----END MOD-810076-----
 
     #-----TQC-810052---------
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table4 CLIPPED,            
                 " VALUES(?,?,?,?)"                                                  
     PREPARE insert_prep4 FROM g_sql                                            
     IF STATUS THEN                                                             
        CALL cl_err('insert_prep4',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087
        EXIT PROGRAM                       
     END IF 
     #-----END TQC-810052-----
 
     CALL cl_del_data(l_table)             
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)   #MOD-810076
     CALL cl_del_data(l_table4)   #TQC-810052
     #No.FUN-7A0025 --end--
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ooauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ooagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ooagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ooauser', 'ooagrup')
     #End:FUN-980030
 
 
     LET l_sql="SELECT ooa01,ooa02,ooa03,ooa032,ooa15,gem02,ooa13,ooaconf, ",
               #"       oob03,oob04,oob05,oob06,oob07,oob08,oob09,oob10, ",   #MOD-810076
               "       oob02,oob03,oob04,oob05,oob06,oob07,oob08,oob09,oob10, ",   #MOD-810076
#              "       oob11,aag02,oob12,",       #No.FUN-740009                                                                    
               "       oob11,aag00,aag02,oob12,", 
               "       azi03,azi04,azi05,azi07",
               "  FROM ooa_file,OUTER gem_file,",
               "       oob_file,OUTER aag_file, OUTER azi_file",
               " WHERE ooa01=oob01 and ooa_file.ooa15=gem_file.gem01 ",
               "   AND oob_file.oob11=aag_file.aag01 and oob_file.oob07=azi_file.azi01 ",
               "   AND ooaconf != 'X' ",    #010803增
        #      "   AND ooa37 = '1'",        #FUN-B20014   #FUN-C10036 mark
               "   AND ",tm.wc CLIPPED,
               " ORDER BY ooa01 "
     PREPARE axrg400_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)
        EXIT PROGRAM
     END IF
     DECLARE axrg400_curs1 CURSOR FOR axrg400_prepare1
 
#     CALL cl_outnam('axrg400') RETURNING l_name       #No.FUN-7A0025
#     START REPORT axrg400_rep TO l_name               #No.FUN-7A0025
#
#     LET g_pageno = 0                                 #No.FUN-7A0025
     FOREACH axrg400_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)     #FUN-C10036 ADD
          EXIT FOREACH
       END IF
       #No.FUN-740009 --begin                                                                                                       
       CALL s_get_bookno(YEAR(sr.ooa02)) RETURNING l_flag1,l_bookno1,l_bookno2                                                      
       IF l_flag1 = '1' THEN                                                                                                        
          CALL cl_err(YEAR(sr.ooa02),'aoo-081',1)  
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80072   ADD                                                                                 
          CALL cl_gre_drop_temptable(l_table||"|"||l_table1||"|"||l_table2||"|"||l_table3||"|"||l_table4)         #FUN-B40087
          EXIT PROGRAM                                                                                                              
       END IF                                                                                                                       
       #No.FUN-740009 --end                                                                                                         
       IF sr.aag00 <> l_bookno1 THEN CONTINUE FOREACH END IF       #No.FUN-740009 
       IF tm.n = '1' AND sr.ooaconf = 'N' THEN CONTINUE FOREACH END IF   #MOD-640088
       IF tm.n='2' AND sr.ooaconf ='Y' THEN CONTINUE FOREACH END IF
#       OUTPUT TO REPORT axrg400_rep(sr.*)                  #No.FUN-7A0025
       #-----MOD-810076---------
       #No.FUN-7A0025 --start--
       #DECLARE memo_c CURSOR FOR
       # SELECT oao06 FROM oao_file
       #   WHERE oao01=sr.ooa01 AND oao05= '1'
       #LET l_oao06=''
       #FOREACH memo_c INTO l_oao06
       #   EXECUTE insert_prep1 USING sr.ooa01,'1',l_oao06
       #END FOREACH
       #
       #DECLARE memo_c2 CURSOR FOR
       # SELECT oao06 FROM oao_file
       #   WHERE oao01=sr.ooa01 AND oao05= '2'
       #LET l_oao06=''
       #FOREACH memo_c2 INTO l_oao06  
       #   EXECUTE insert_prep2 USING sr.ooa01,'2',l_oao06                       
       #END FOREACH
       #-----TQC-810052---------
       #DECLARE memo_c1 CURSOR FOR 
       # SELECT oao06 FROM oao_file                 
       #   WHERE oao01=sr.ooa01                     
       #     AND oao03=0 AND oao05='1'                
       #FOREACH memo_c1 INTO l_oao06                                          
       #   IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
       #   EXECUTE insert_prep1 USING sr.ooa01,sr.oob02,'1',l_oao06  
       #END FOREACH              
       #-----END TQC-810052-----                                              
 
       DECLARE memo_c2 CURSOR FOR 
        SELECT oao06 FROM oao_file                 
          WHERE oao01=sr.ooa01                     
            AND oao03=sr.oob02 AND oao05='1'                
       FOREACH memo_c2 INTO l_oao06                                          
          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
          EXECUTE insert_prep2 USING sr.ooa01,sr.oob02,'1',l_oao06  
       END FOREACH                                                            
 
       DECLARE memo_c3 CURSOR FOR 
        SELECT oao06 FROM oao_file                 
          WHERE oao01=sr.ooa01                     
            AND oao03=sr.oob02 AND oao05='2'                
       FOREACH memo_c3 INTO l_oao06                                          
          IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
          EXECUTE insert_prep3 USING sr.ooa01,sr.oob02,'2',l_oao06  
       END FOREACH                                                            
       #-----END MOD-810076-----
 
       LET l_oob04a=''
           IF sr.oob03 = '1' THEN
              CASE sr.oob04
                   WHEN '1' LET l_oob04a=cl_getmsg('axr-920',g_lang)
                   WHEN '2' LET l_oob04a=cl_getmsg('axr-921',g_lang)
                   WHEN '3' LET l_oob04a=cl_getmsg('axr-922',g_lang)
                   WHEN '4' LET l_oob04a=cl_getmsg('axr-923',g_lang)
                   WHEN '5' LET l_oob04a=cl_getmsg('axr-924',g_lang)
                   WHEN '6' LET l_oob04a=cl_getmsg('axr-925',g_lang)
                   WHEN '7' LET l_oob04a=cl_getmsg('axr-926',g_lang)
                   WHEN '8' LET l_oob04a=cl_getmsg('axr-927',g_lang)
                   WHEN '9' LET l_oob04a=cl_getmsg('axr-928',g_lang)
              END CASE
           ELSE
              CASE sr.oob04
                   WHEN '1' LET l_oob04a=cl_getmsg('axr-929',g_lang)
                   WHEN '2' LET l_oob04a=cl_getmsg('axr-930',g_lang)
                   WHEN '4' LET l_oob04a=cl_getmsg('axr-931',g_lang)
                   WHEN '7' LET l_oob04a=cl_getmsg('axr-932',g_lang)
                   WHEN '9' LET l_oob04a=cl_getmsg('axr-922',g_lang)
              END CASE
           END IF
       IF cl_null(l_oob04a) THEN
          SELECT ooc02 INTO l_oob04a FROM ooc_file WHERE ooc01 = sr.oob04
       END IF 
       LET l_oob04a = sr.oob04,' ',l_oob04a CLIPPED
       EXECUTE insert_prep USING sr.ooa01,sr.ooa02,sr.ooa03,sr.ooa032,sr.ooa15,
                                 #sr.gem02,sr.ooa13,sr.oob03,l_oob04a,sr.oob05,   #MOD-810076
                                 sr.gem02,sr.ooa13,sr.oob02,sr.oob03,l_oob04a,sr.oob05,   #MOD-810076
                                 sr.oob06,sr.oob07,sr.oob08,sr.oob09,sr.oob10,
                                 sr.oob11,sr.aag02,sr.oob12,sr.azi04,sr.azi05,
                                 sr.azi07,
                                 "",l_img_blob,"N",""    #FUN-940042   #FUN-C40019 add ""
     #No.FUN-7A0025 --end--
     END FOREACH
     #-----TQC-810052---------
     LET l_sql = "SELECT DISTINCT ooa01 FROM ",
                  g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE g400_p FROM l_sql
     DECLARE g400_curs CURSOR FOR g400_p
     FOREACH g400_curs INTO sr.ooa01
        DECLARE memo_c1 CURSOR FOR 
         SELECT oao06 FROM oao_file                 
           WHERE oao01=sr.ooa01                     
             AND oao03=0 AND oao05='1'                
        FOREACH memo_c1 INTO l_oao06                                          
           IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
           EXECUTE insert_prep1 USING sr.ooa01,'','1',l_oao06  
        END FOREACH              
        DECLARE memo_c4 CURSOR FOR 
         SELECT oao06 FROM oao_file                 
           WHERE oao01=sr.ooa01                     
             AND oao03=0 AND oao05='2'                
        FOREACH memo_c4 INTO l_oao06                                          
           IF SQLCA.SQLCODE THEN LET l_oao06=' ' END IF                        
           EXECUTE insert_prep4 USING sr.ooa01,'','2',l_oao06  
        END FOREACH              
     END FOREACH
     #-----END TQC-810052-----                                              
 
#     FINISH REPORT axrg400_rep                   #No.FUN-7A0025
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len) #No.FUN-7A0025
     #No.FUN-7A0025 --start--
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'ooa01,ooa02,ooa03,ooa15')
             RETURNING tm.wc
        LET g_str = tm.wc
     END IF
###GENGRE###     LET g_str = g_str,";",g_azi04
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,"|",    #MOD-810076
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED         #TQC-810052
 
     ###FUN-940042 START ###
     LET g_cr_table = l_table                 #主報表的temp table名稱
     LET g_cr_gcx01 = "axri010"               #單別維護程式
     LET g_cr_apr_key_f = "ooa01"             #報表主鍵欄位名稱，用"|"隔開 
###GENGRE###     LET l_sql_2 = "SELECT DISTINCT ooa01 FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     PREPARE key_pr FROM l_sql_2
     DECLARE key_cs CURSOR FOR key_pr
     LET l_ii = 1
     #報表主鍵值
     CALL g_cr_apr_key.clear()                #清空
     FOREACH key_cs INTO l_key.*            
        LET g_cr_apr_key[l_ii].v1 = l_key.v1
        LET l_ii = l_ii + 1
     END FOREACH
     ###FUN-940042 END ###
###GENGRE###     CALL cl_prt_cs3('axrg400','axrg400',l_sql,g_str)
    CALL axrg400_grdata()    ###GENGRE###
     #No.FUN-7A0025 --end--
END FUNCTION
#No.FUN-7A0025 --start-- mark
{REPORT axrg400_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
          str          STRING,
          g_head1      STRING,
          str3         STRING,
          sr        RECORD
                    ooa01     LIKE ooa_file.ooa01,
                    ooa02     LIKE ooa_file.ooa02,
                    ooa03     LIKE ooa_file.ooa03,
                    ooa032    LIKE ooa_file.ooa032,
                    ooa15     LIKE ooa_file.ooa15,
                    gem02     LIKE gem_file.gem02,
                    ooa13     LIKE ooa_file.ooa13,
                    ooaconf   LIKE ooa_file.ooaconf,
                    oob03     LIKE oob_file.oob03,
                    oob04     LIKE oob_file.oob04,
                    oob05     LIKE oob_file.oob05,
                    oob06     LIKE oob_file.oob06,
                    oob07     LIKE oob_file.oob07,
                    oob08     LIKE oob_file.oob08,
                    oob09     LIKE oob_file.oob09,
                    oob10     LIKE oob_file.oob10,
                    oob11     LIKE oob_file.oob11,        #No.FUN-680123 VARCHAR(12)
                    aag00     LIKE aag_file.aag00,        #No.FUN-740009 
                    aag02     LIKE aag_file.aag02,
                    oob12     LIKE oob_file.oob12,
                    azi03     LIKE azi_file.azi03,
                    azi04     LIKE azi_file.azi04,
                    azi05     LIKE azi_file.azi05,
                    azi07     LIKE azi_file.azi07
                    END RECORD,
          st        RECORD
                    tmp01     LIKE azi_file.azi01,        #No.FUN-680123 VARCHAR(04)
                    tmp02     LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(01)
                    tmp03     LIKE type_file.num20_6,     #No.FUN-680123 DEC(20,6)
                    tmp04     LIKE type_file.num20_6      #No.FUN-680123 DEC(20,6)
                    END RECORD,
         l_flag     LIKE type_file.chr1,                  #No.FUN-680123 VARCHAR(01)
         l_oob091   LIKE oob_file.oob09,
         l_oob092   LIKE oob_file.oob09,
         l_oob101   LIKE oob_file.oob10,
         l_oob102   LIKE oob_file.oob10,
         l_oob04a   LIKE ooc_file.ooc02,                  #No.FUN-680123 VARCHAR(12)
         l_gen02    LIKE gen_file.gen02,
         l_oao06    LIKE oao_file.oao06,
         l_oah02    LIKE oah_file.oah02,
         l_oag02    LIKE oag_file.oag02,
         l_gem02    LIKE gem_file.gem02
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ooa01,sr.oob03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED, pageno_total  #No.TQC-770028 mark
      PRINT                               #No.TQC-770028
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]    #No.TQC-6B0051
      LET str = sr.ooa03,' ',sr.ooa032
      LET g_head1 =  g_x[11] CLIPPED,' ',sr.ooa01 CLIPPED,#No.TQC-6A0087
                     '    ',g_x[12] CLIPPED,' ',sr.ooa02 CLIPPED,#No.TQC-6A0087
                     '  ',g_x[13] CLIPPED,' ',str CLIPPED #No.TQC-6A0087
      PRINT g_head1
      LET str = sr.ooa15,' ',sr.gem02
      LET g_head1 =  g_x[14] CLIPPED,' ',str CLIPPED, #No.TQC-6A0087
                   #  '  ',g_x[15] CLIPPED,' ',sr.ooa13
                     COLUMN 25,g_x[15] CLIPPED,' ',sr.ooa13 #No.TQC-6A0087
      PRINT g_head1
      PRINT g_head CLIPPED, pageno_total  #No.TQC-770028
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ooa01
#     DELETE FROM g400_tmp  #FUN-B40087
      SKIP TO TOP OF PAGE
      #-----MOD-610021---------
      DECLARE memo_c CURSOR FOR
        SELECT oao06 FROM oao_file
          WHERE oao01=sr.ooa01 AND oao05= '1'
      LET l_oao06=''
      FOREACH memo_c INTO l_oao06
         PRINT l_oao06
      END FOREACH
      #-----END MOD-610021-----
 
   ON EVERY ROW
#FUN-B40087----MARK-----str-------
#     SELECT COUNT(*) INTO l_n FROM g400_tmp
#      WHERE tmp01=sr.oob07 AND tmp02=sr.oob03
#     IF NOT cl_null(sr.oob07) THEN
#        IF l_n > 0 THEN
#           UPDATE g400_tmp SET tmp03=tmp03+sr.oob09,
#                               tmp04=tmp04+sr.oob10
#            WHERE tmp01=sr.oob07 AND tmp02=sr.oob03
#        ELSE
#          INSERT INTO g400_tmp VALUES(sr.oob07,sr.oob03,sr.oob09,sr.oob10)
#        END IF
#     END IF
#FUN-B40087----MARK-----end--------
      LET l_oob04a=''   #MOD-610050
	  IF sr.oob03 = '1' THEN
		 CASE sr.oob04
                       #-----MOD-610050---------
                       WHEN '1' LET l_oob04a=cl_getmsg('axr-920',g_lang)
                       WHEN '2' LET l_oob04a=cl_getmsg('axr-921',g_lang)
                       WHEN '3' LET l_oob04a=cl_getmsg('axr-922',g_lang)
                       WHEN '4' LET l_oob04a=cl_getmsg('axr-923',g_lang)
                       WHEN '5' LET l_oob04a=cl_getmsg('axr-924',g_lang)
                       WHEN '6' LET l_oob04a=cl_getmsg('axr-925',g_lang)
                       WHEN '7' LET l_oob04a=cl_getmsg('axr-926',g_lang)
                       WHEN '8' LET l_oob04a=cl_getmsg('axr-927',g_lang)
                       WHEN '9' LET l_oob04a=cl_getmsg('axr-928',g_lang)
		       #WHEN '1' LET l_oob04a=cl_getmsg('axr-221',g_lang)
		       #WHEN '2' LET l_oob04a=cl_getmsg('axr-222',g_lang)
		       #WHEN '3' LET l_oob04a=cl_getmsg('axr-223',g_lang)
		       #WHEN '4' LET l_oob04a=cl_getmsg('axr-224',g_lang)
		       #WHEN '5' LET l_oob04a=cl_getmsg('axr-225',g_lang)
		       #WHEN '6' LET l_oob04a=cl_getmsg('axr-226',g_lang)
		       #WHEN '7' LET l_oob04a=cl_getmsg('axr-227',g_lang)
		       #WHEN '8' LET l_oob04a=cl_getmsg('axr-259',g_lang)
		       #WHEN '9' LET l_oob04a=cl_getmsg('axr-260',g_lang)
                       #-----END MOD-610050-----
		END CASE
	  ELSE
		CASE sr.oob04
                      #-----MOD-610050---------
                       WHEN '1' LET l_oob04a=cl_getmsg('axr-929',g_lang)
                       WHEN '2' LET l_oob04a=cl_getmsg('axr-930',g_lang)
                       WHEN '4' LET l_oob04a=cl_getmsg('axr-931',g_lang)
                       WHEN '7' LET l_oob04a=cl_getmsg('axr-932',g_lang)
                       WHEN '9' LET l_oob04a=cl_getmsg('axr-922',g_lang)
                      #WHEN '1' LET l_oob04a=cl_getmsg('axr-228',g_lang)
                      #WHEN '2' LET l_oob04a=cl_getmsg('axr-229',g_lang)
                      #WHEN '3' LET l_oob04a=cl_getmsg('axr-230',g_lang)
                      #-----END MOD-610050-----
		END CASE
	  END IF
     #-----MOD-610050---------
     IF cl_null(l_oob04a) THEN
        SELECT ooc02 INTO l_oob04a FROM ooc_file WHERE ooc01 = sr.oob04
     END IF
     #-----END MOD-610050-----
      LET str3 = sr.oob04,' ',l_oob04a CLIPPED
      PRINT COLUMN g_c[31],sr.oob03;
      PRINT COLUMN g_c[32],str3;
      PRINT COLUMN g_c[33],sr.oob05 CLIPPED,
	    COLUMN g_c[34],sr.oob06 CLIPPED,
            COLUMN g_c[35],sr.oob07 CLIPPED,
            COLUMN g_c[36],cl_numfor(sr.oob08,36,sr.azi07),
            COLUMN g_c[37], cl_numfor(sr.oob09,37,sr.azi04),
            COLUMN g_c[38], cl_numfor(sr.oob10,38,g_azi04)
      PRINT COLUMN g_c[33],g_x[16] CLIPPED,COLUMN g_c[34],sr.oob11,
            COLUMN g_c[35],sr.aag02
      PRINT COLUMN g_c[33],g_x[17] CLIPPED,COLUMN g_c[34],sr.oob12
 
   AFTER GROUP OF sr.ooa01
      #  LET l_oob091= GROUP SUM(sr.oob09) WHERE sr.oob03 = '1'
      #  LET l_oob092= GROUP SUM(sr.oob09) WHERE sr.oob03 = '2'
      #  LET l_oob101= GROUP SUM(sr.oob10) WHERE sr.oob03 = '1'
      #  LET l_oob102= GROUP SUM(sr.oob10) WHERE sr.oob03 = '2'
      #依幣別總計
#FUN-B40087 -----mark-----str------
#     DECLARE g400_tmp_cs CURSOR FOR SELECT * FROM g400_tmp ORDER BY tmp01,tmp02
#     FOREACH g400_tmp_cs INTO st.*
#        SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓原幣取位
#          FROM azi_file
#         WHERE azi01=st.tmp01
#FUN-B40087 -----mark-----end------- 
         IF st.tmp02='1' THEN
            PRINT COLUMN g_c[33],g_x[18] CLIPPED,
                  COLUMN g_c[35],st.tmp01,
                  COLUMN g_c[37],cl_numfor(st.tmp03,37,sr.azi05),
                  COLUMN g_c[38],cl_numfor(st.tmp04,38,g_azi05)
         END IF
         IF st.tmp02='2' THEN
            PRINT COLUMN g_c[33],g_x[19] CLIPPED,
                  COLUMN g_c[35],st.tmp01,
                  COLUMN g_c[37],cl_numfor(st.tmp03,37,sr.azi05),
                  COLUMN g_c[38],cl_numfor(st.tmp04,38,g_azi05)
         END IF
      END FOREACH
      #-----MOD-610021---------
      DECLARE memo_c2 CURSOR FOR
        SELECT oao06 FROM oao_file
          WHERE oao01=sr.ooa01 AND oao05= '2'
      LET l_oao06=''
      FOREACH memo_c2 INTO l_oao06
         PRINT l_oao06
      END FOREACH
      #-----END MOD-610021-----
      ##
      #  PRINT COLUMN g_c[33],g_x[18] CLIPPED,' ',l_oob091 USING '---,---,---.--',
      #                                  ' ',l_oob101 USING '---,---,---.--'
      #  PRINT COLUMN g_c[33],g_x[19] CLIPPED,' ',l_oob092 USING '---,---,---.--',
      #                                  ' ',l_oob102 USING '---,---,---.--'
      LET l_flag='Y'
 
## FUN-550111
   ON LAST ROW
      #-----TQC-6B0190---------
      IF  g_zz05 = 'Y' THEN
          CALL cl_wcchp(tm.wc,'ooa01,ooa02,ooa03,ooa15')
               RETURNING tm.wc
          PRINT g_dash
          CALL cl_prt_pos_wc(tm.wc)
      END IF
      PRINT g_dash
      PRINT g_x[5],COLUMN (g_len-9), g_x[7] CLIPPED
      #-----END TQC-6B0190-----
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      #-----TQC-6B0190---------
      #PRINT g_dash[1,g_len]
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[5],COLUMN (g_len-9), g_x[6] CLIPPED
      ELSE
         SKIP 2 LINE
      END IF
      #-----END TQC-6B0190-----
      #PRINT COLUMN g_c[31],g_x[4],
      #      COLUMN g_c[33],g_x[5],
      #      COLUMN g_c[35],g_x[6],
      #      COLUMN g_c[37],g_x[7]
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[4]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
             PRINT g_x[4]
             PRINT g_memo
      END IF
## END FUN-550111
 
END REPORT}
#No.FUN-7A0025 --end--

###GENGRE###START
FUNCTION axrg400_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    LOCATE sr1.sign_img IN MEMORY   #FUN-C40019
    CALL cl_gre_init_apr()          #FUN-C40019
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("axrg400")
        IF handler IS NOT NULL THEN
            START REPORT axrg400_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY ooa01"     #FUN-C10036 add
          
            DECLARE axrg400_datacur1 CURSOR FROM l_sql
            FOREACH axrg400_datacur1 INTO sr1.*
                OUTPUT TO REPORT axrg400_rep(sr1.*)
            END FOREACH
            FINISH REPORT axrg400_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axrg400_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE sr3 sr3_t
    DEFINE sr4 sr4_t
    DEFINE sr5 sr5_t
    DEFINE l_lineno         LIKE type_file.num5
    #FUN-B40087 ---------add----------str------
    DEFINE l_ooa03_ooa032   STRING
    DEFINE l_ooa15_gem02    STRING
    DEFINE l_oob03          STRING
    DEFINE l_sql            STRING
    DEFINE l_oob08_fmt      STRING
    DEFINE l_oob09_fmt      STRING
    DEFINE l_oob10_fmt      STRING
    #FUN-B40087 ---------add----------end------

    
    ORDER EXTERNAL BY sr1.ooa01,sr1.oob02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ooa01
            LET l_lineno = 0
            #FUN-B40087 ---------add----------str------
            LET l_ooa03_ooa032 = sr1.ooa03,' ',sr1.ooa032
            PRINTX l_ooa03_ooa032
            LET l_ooa15_gem02 = sr1.ooa15,' ',sr1.gem02
            PRINTX l_ooa15_gem02
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                        " WHERE oao01 = '",sr1.ooa01 CLIPPED,"'",
                        " AND oao03 = 0 AND oao05='1'"
            START REPORT axrg400_subrep05
            DECLARE axrg400_repcur5 CURSOR FROM l_sql
            FOREACH axrg400_repcur5 INTO sr2.*
                OUTPUT TO REPORT axrg400_subrep05(sr2.*)
            END FOREACH
            FINISH REPORT axrg400_subrep05
            #FUN-B40087 ---------add----------end------
        BEFORE GROUP OF sr1.oob02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40087 ---------add----------str------
            LET l_oob08_fmt  = cl_gr_numfmt('oob_file','oob08',sr1.azi07)
            PRINTX l_oob08_fmt
            LET l_oob09_fmt  = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
            PRINTX l_oob09_fmt
            LET l_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi04)
            PRINTX l_oob10_fmt
            LET l_oob03 = cl_gr_getmsg("gre-030",g_lang,sr1.oob03) 
            PRINTX l_oob03
         
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
                        " WHERE oao01 = '",sr1.ooa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.oob02 CLIPPED,
                        " AND oao05='1'"
            START REPORT axrg400_subrep01
            DECLARE axrg400_repcur1 CURSOR FROM l_sql
            FOREACH axrg400_repcur1 INTO sr3.*
                OUTPUT TO REPORT axrg400_subrep01(sr3.*)
            END FOREACH
            FINISH REPORT axrg400_subrep01

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
                        " WHERE oao01 = '",sr1.ooa01 CLIPPED,"'",
                        " AND oao03 = ",sr1.oob02 CLIPPED,
                        " AND oao05='2'"
            START REPORT axrg400_subrep02
            DECLARE axrg400_repcur2 CURSOR FROM l_sql
            FOREACH axrg400_repcur2 INTO sr4.*
                OUTPUT TO REPORT axrg400_subrep02(sr4.*)
            END FOREACH
            FINISH REPORT axrg400_subrep02
            #FUN-B40087 ---------add----------end------
            PRINTX sr1.*

        AFTER GROUP OF sr1.ooa01
            #FUN-B40087 ---------add----------str------
  
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " WHERE ooa01 = '",sr1.ooa01,"'"
                        ," ORDER BY oob03,oob07"           #FUN-C10036 add
            START REPORT axrg400_subrep04
            DECLARE axrg400_repcur4 CURSOR FROM l_sql
            FOREACH axrg400_repcur4 INTO sr1.*
                OUTPUT TO REPORT axrg400_subrep04(sr1.*)
            END FOREACH
            FINISH REPORT axrg400_subrep04

            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table4 CLIPPED,
                        " WHERE oao01 = '",sr1.ooa01 CLIPPED,"'",
                        " AND oao03 = 0",
                        " AND oao05 = '2'"
            START REPORT axrg400_subrep03
            DECLARE axrg400_repcur3 CURSOR FROM l_sql
            FOREACH axrg400_repcur3 INTO sr5.*
                OUTPUT TO REPORT axrg400_subrep03(sr5.*)
            END FOREACH
            FINISH REPORT axrg400_subrep03
            #FUN-B40087 ---------add----------end------
        AFTER GROUP OF sr1.oob02

        
        ON LAST ROW

END REPORT
#FUN-B40087 ---------add----------str------
REPORT axrg400_subrep01(sr3)
    DEFINE sr3 sr3_t

    FORMAT
        ON EVERY ROW
            PRINTX sr3.*
END REPORT

REPORT axrg400_subrep02(sr4)
    DEFINE sr4 sr4_t

    FORMAT
        ON EVERY ROW
            PRINTX sr4.*
END REPORT

REPORT axrg400_subrep03(sr5)
    DEFINE sr5 sr5_t

    FORMAT
        ON EVERY ROW
            PRINTX sr5.*
END REPORT

REPORT axrg400_subrep04(sr1)
    DEFINE sr1            sr1_t
    DEFINE l_sum_oob09    LIKE oob_file.oob09
    DEFINE l_sum_oob10    LIKE oob_file.oob10
    DEFINE l_oob03        STRING
    DEFINE l_sum_oob09_fmt STRING
    DEFINE l_sum_oob10_fmt STRING

    ORDER EXTERNAL BY sr1.oob03,sr1.oob07

    FORMAT
        ON EVERY ROW
           PRINTX sr1.*

        AFTER GROUP OF sr1.oob07
            LET l_sum_oob09 = GROUP SUM(sr1.oob09)
            PRINTX l_sum_oob09
            LET l_sum_oob10 = GROUP SUM(sr1.oob10)
            PRINTX l_sum_oob10
            LET l_oob03 = cl_gr_getmsg("gre-058",g_lang,sr1.oob03)
            PRINTX l_oob03
 
            LET l_sum_oob09_fmt  = cl_gr_numfmt('oob_file','oob09',sr1.azi04)
            PRINTX l_sum_oob09_fmt
            LET l_sum_oob10_fmt  = cl_gr_numfmt('oob_file','oob10',g_azi04)
            PRINTX l_sum_oob10_fmt

         
END REPORT

REPORT axrg400_subrep05(sr2)
    DEFINE sr2 sr2_t

    FORMAT
        ON EVERY ROW
            PRINTX sr2.*
END REPORT
#FUN-B40087 ---------add----------end------
###GENGRE###END
#FUN-D20056
