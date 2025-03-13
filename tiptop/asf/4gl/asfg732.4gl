# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asfg732.4gl
# Descriptions...: 移轉單
# Date & Author..: 00/05/24 by plum
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580014 05/08/19 By jackie 轉XML
# Modify.........: No.TQC-5B0023 05/11/07 By kim 報表單頭品名規格移位
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-640281 06/04/010 By pengu 作業編號沒有列印出來
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-740008 07/04/09 By pengu 增加(ctrl-g)功能
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕灰色
# Modify.........: No.MOD-840140 08/04/17 By Sarah 修改傳到Crystal Report的SQL寫法
# Modify.........: No.MOD-8A0149 08/10/16 By claire 單身的作業編號同單頭的作業編號不合理
# Modify.........: No.MOD-8A0158 08/10/17 By claire 單身的作業編號同單頭的作業編號不合理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/23 By huangtao 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/28 By huangtao 製造功能優化-平行制程（批量修改）
# Modify.........: No.TQC-A70109 10/07/22 By huangtao 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-B40087 11/06/02 By yangtt  憑證報表轉GRW
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50003 12/05/09 By yangtt GR程式優化
# Modify.........: No.FUN-C30085 12/06/15 By chenying GR修改 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                   # Print condition RECORD
#                    wc     VARCHAR(600),      # Where condition  #NO.TQC-630166 mark
                    wc     STRING,
                    more   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-710082--begin
DEFINE  g_sql      STRING                                                       
DEFINE  l_table    STRING                                                       
DEFINE  l_table1   STRING                                                       
DEFINE  l_str      STRING   
#No.FUN-710082--end  
 
###GENGRE###START
TYPE sr1_t RECORD
    shb01 LIKE shb_file.shb01,
    shb03 LIKE shb_file.shb03,
    shb032 LIKE shb_file.shb032,
    shb04 LIKE shb_file.shb04,
    shb05 LIKE shb_file.shb05,
    shb06 LIKE shb_file.shb06,
    shb07 LIKE shb_file.shb07,
    shb08 LIKE shb_file.shb08,
    shb081 LIKE shb_file.shb081,
    shb082 LIKE shb_file.shb082,
    shb10 LIKE shb_file.shb10,
    shb12 LIKE shb_file.shb12,
    shb111 LIKE shb_file.shb111,
    shb112 LIKE shb_file.shb112,
    shb113 LIKE shb_file.shb113,
    shb114 LIKE shb_file.shb114,
    shb115 LIKE shb_file.shb115,
    shb16 LIKE shb_file.shb16,
    shb012 LIKE shb_file.shb012,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    gen02 LIKE gen_file.gen02,
    ecm03 LIKE ecm_file.ecm03,
    ecm04 LIKE ecm_file.ecm04,
    ecm45 LIKE ecm_file.ecm45,
    ecm06 LIKE ecm_file.ecm06,
    ecm41 LIKE ecm_file.ecm41,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
END RECORD

TYPE sr2_t RECORD
    shc01 LIKE shc_file.shc01,
    shc03 LIKE shc_file.shc03,
    shc04 LIKE shc_file.shc04,
    qce02 LIKE qce_file.qce02,
    qce03 LIKE qce_file.qce03,
    shc05 LIKE shc_file.shc05,
    shc06 LIKE shc_file.shc06,
    shc012 LIKE shc_file.shc012,
    ecm04_1 LIKE ecm_file.ecm04
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   #No.FUN-710082--begin
   LET g_sql ="shb01.shb_file.shb01,",
              "shb03.shb_file.shb03,",
              "shb032.shb_file.shb032,",
              "shb04.shb_file.shb04,",
              "shb05.shb_file.shb05,",
              "shb06.shb_file.shb06,",
              "shb07.shb_file.shb07,",
              "shb08.shb_file.shb08,",
              "shb081.shb_file.shb081,",
              "shb082.shb_file.shb082,",
              "shb10.shb_file.shb10,",
              "shb12.shb_file.shb12,",
              "shb111.shb_file.shb111,",
              "shb112.shb_file.shb112,",
              "shb113.shb_file.shb113,",
              "shb114.shb_file.shb114,",
              "shb115.shb_file.shb115,",
              "shb16.shb_file.shb16,",
              "shb012.shb_file.shb012,",      #FUN-A60027 add by huangtao
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "gen02.gen_file.gen02,",
              "ecm03.ecm_file.ecm03,",
              "ecm04.ecm_file.ecm04,",
              "ecm45.ecm_file.ecm45,",
              "ecm06.ecm_file.ecm06,",
              "ecm41.ecm_file.ecm41,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
 
   LET l_table = cl_prt_temptable('asfg732',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B40087 #FUN-BB0047
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1)   #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM 
   END IF
 
   LET g_sql ="shc01.shc_file.shc01,",
              "shc03.shc_file.shc03,",
              "shc04.shc_file.shc04,",
              "qce02.qce_file.qce02,",
              "qce03.qce_file.qce03,",
              "shc05.shc_file.shc05,",
              "shc06.shc_file.shc06,",
              "shc012.shc_file.shc012,",   #TQC-A70109 add
              "ecm04_1.ecm_file.ecm04"   #MOD-8A0149 modify ecm04->ecm04_1
 
   LET l_table1 = cl_prt_temptable('asfg7321',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B40087 #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table||"|"||l_table1)     #FUN-B40087 #FUN-C10036 mark
      EXIT PROGRAM 
   END IF
   #No.FUN-710082--end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL g732_tm(0,0)        # Input print condition
      ELSE CALL asfg732()        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
END MAIN
 
FUNCTION g732_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680121 SMALLINT
          l_cmd        LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col =20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
   OPEN WINDOW g732_w AT p_row,p_col
        WITH FORM "asf/42f/asfg732"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON shb01,shb07,shb05,shb10,shb03,shb04
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
    ON ACTION help                                  #No.TQC-770004                                                                             
         #CALL cl_dynamic_locale()                                 #No.TQC-770004                                                                  
          CALL cl_show_help()                   #No.FUN-550037 hmf                #No.TQC-770004                                               
         LET g_action_choice = "help"                           #No.TQC-770004                                  
         CONTINUE CONSTRUCT                      #No.TQC-770004
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
 
   ON ACTION CONTROLG CALL cl_cmdask()    #No.TQC-740008 add
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW g732_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM 
   END IF
   IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
 
   DISPLAY BY NAME tm.more # Condition
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
             NEXT FIELD more
         END IF
         IF tm.more = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
             RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
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
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
         ON ACTION help                                  #No.TQC-770004                                                                  
         #CALL cl_dynamic_locale()                                 #No.TQC-770004                                                   
          CALL cl_show_help()                   #No.FUN-550037 hmf                #No.TQC-770004                                    
         LET g_action_choice = "help"                           #No.TQC-770004                                                      
         CONTINUE INPUT                      #No.TQC-770004        
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW g732_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM 
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfg732'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfg732','9031',1)
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
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfg732',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g732_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
      EXIT PROGRAM
         
   END IF
   CALL cl_wait()
   CALL asfg732()
   ERROR ""
END WHILE
   CLOSE WINDOW g732_w
END FUNCTION
 
FUNCTION asfg732()
   DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
  # LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name

#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1200)
          sr        RECORD
                  shb01  LIKE shb_file.shb01,
                  shb03  LIKE shb_file.shb03,
                  shb032 LIKE shb_file.shb032,
                  shb04  LIKE shb_file.shb04,
                  shb05  LIKE shb_file.shb05,
                  shb06  LIKE shb_file.shb06,
                  shb07  LIKE shb_file.shb07,
                  shb08  LIKE shb_file.shb08,
                  shb081 LIKE shb_file.shb081,
                  shb082 LIKE shb_file.shb082,
                  shb10  LIKE shb_file.shb10,
                  shb12  LIKE shb_file.shb12,
                  shb111 LIKE shb_file.shb111,
                  shb112 LIKE shb_file.shb112,
                  shb113 LIKE shb_file.shb113,
                  shb114 LIKE shb_file.shb114,
                  shb115 LIKE shb_file.shb115,
                  shb16  LIKE shb_file.shb16,        #No.MOD-640281 add
                  shb012 LIKE shb_file.shb012,      #FUN-A60027 add by huangtao
                  ima02  LIKE ima_file.ima02,
                  ima021 LIKE ima_file.ima021,   #No.FUN-710082
                  gen02  LIKE gen_file.gen02,
                  ecm03  LIKE ecm_file.ecm03,
                  ecm04  LIKE ecm_file.ecm04,
                  ecm45  LIKE ecm_file.ecm45,
                  ecm06  LIKE ecm_file.ecm06,
                  ecm41  LIKE ecm_file.ecm41
                    END RECORD
            #No.FUN-710082--begin
DEFINE      sr1   RECORD
                  shc01  LIKE shc_file.shc01,  #No.FUN-710082
                  shc03  LIKE shc_file.shc03,
                  shc04  LIKE shc_file.shc04,
                  qce02  LIKE qce_file.qce02,
                  qce03  LIKE qce_file.qce03,
                  shc05  LIKE shc_file.shc05,
                  shc06  LIKE shc_file.shc06,
                  shc012 LIKE shc_file.shc012, #TQC-A70109 add
                  ecm04  LIKE ecm_file.ecm04 
                        END RECORD
            #No.FUN-710082--end  
DEFINE    l_ecm012   LIKE ecm_file.ecm012   #FUN-A60076 add by vealxu  
   LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND shbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND shbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND shbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shbuser', 'shbgrup')
    #End:FUN-980030
 
 
     LET l_sql =" SELECT shb01,shb03,shb032,shb04,shb05,shb06,shb07,shb08,",
                "   shb081,shb082,shb10,shb12,shb111,shb112,shb113,shb114, ",
                "   shb115,shb16,shb012,ima02,ima021,gen02,ecm03,ecm04,ecm45,ecm06,ecm41 ",        #No.MOD-640281 add  #No.FUN-710082  #No.FUN-A60027
#               "   shb115,shb16,ima02,gen02,ecm03,ecm04,ecm45,ecm06,ecm41 ",        #No.MOD-640281 add         #No.FUN-710082
              #FUN-C50003----mod----str---
              # " FROM shb_file,OUTER gen_file,OUTER ecm_file,OUTER ima_file ",
              # " WHERE shb_file.shb05 = ecm_file.ecm01 ",
              # "   AND shb_file.shb06 = ecm_file.ecm03 ",
              # "   AND shb_file.shb012= ecm_file.ecm012 ",      #FUN-A60027  add by huangtao
              # "   AND shb_file.shb04 = gen_file.gen01 AND ima_file.ima01=shb_file.shb10 ",
              ##"   AND shc_file.shc01 = shb01 AND qce_file.qce01=shc_file.shc04",
              # "   AND shb_file.shbconf = 'Y' ",   #FUN-B40087 
                " FROM shb_file LEFT OUTER JOIN gen_file ON shb04=gen01",
                "               LEFT OUTER JOIN ecm_file ON shb05=ecm01 AND shb06=ecm03 AND shb012=ecm012",
                "               LEFT OUTER JOIN ima_file ON ima01=shb10",
                " WHERE shbconf = 'Y' ",
              #FUN-C50003----mod----str---
                "   AND ",tm.wc CLIPPED
     LET l_sql=l_sql CLIPPED," ORDER BY shb01"   #No.FUN-710082
 
     PREPARE g732_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM
           
     END IF
     DECLARE g732_cs1 CURSOR FOR g732_prepare1
 
     LET l_sql = " SELECT shc01,shc03,shc04,qce02,qce03,shc05,shc06,shc012,ecm04,ecm012  ",  #No.FUN-710082  #FUN-A60076 add ecm012 by vealxu  #TQC-A70109 add 
#    LET l_sql = " SELECT shc03,shc04,qce02,qce03,shc05,shc06,ecm04 ",        #No.FUN-710082
                #FUN-C50003------mod----str--
                 " FROM shc_file LEFT OUTER JOIN ecm_file ON ecm03=shc06 AND ecm012=shc012 AND ecm01 = ?",
                 "               LEFT OUTER JOIN qce_file ON qce01=shc04",
                #" FROM shc_file,OUTER ecm_file,OUTER qce_file ",
                 " WHERE shc01 = ? ",
                #"   AND ecm_file.ecm03= shc_file.shc06 AND ecm_file.ecm01= ? ",
                #"   AND qce_file.qce01=shc_file.shc04 ",
                #"   AND ecm_file.ecm012=shc_file.shc012 ",   #TQC-A70109  add 
                #FUN-C50003------mod----end--
                 " ORDER BY shc01,shc03"  #No.FUN-710082
#                " ORDER BY 1"      #No.FUN-710082
     PREPARE g732_p2 FROM l_sql
     IF STATUS THEN CALL cl_err('p2:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        CALL cl_gre_drop_temptable(l_table||"|"||l_table1)
        EXIT PROGRAM 
     END IF
     DECLARE g732_c2 CURSOR FOR g732_p2
 
     #No.FUN-710082--begin
#    CALL cl_outnam('asfg732') RETURNING l_name
#    START REPORT g732_rep TO l_name
 
     CALL cl_del_data(l_table) 
     CALL cl_del_data(l_table1) 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?,?,?,?,?, ?,?) " # No.FUN-C40020 add 4?     ##FUN-A60076 add ?
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time        #FUN-B80086    MARK
        CALL cl_err("insert_prep:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80086    ADD
        EXIT PROGRAM
     END IF
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?) "     #TQC-A70109 add ?
     PREPARE insert_prep1 FROM g_sql
     IF STATUS THEN
       # CALL cl_used(g_prog,g_time,2) RETURNING g_time         #FUN-B80086    MARK
        CALL cl_err("insert_prep1:",STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B80086    ADD
        EXIT PROGRAM
     END IF
 
     FOREACH g732_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
 
     #----------------No.MOD-640281 add
       IF NOT cl_null(sr.shb16) THEN
          SELECT sgm03,sgm04,sgm45,sgm06,sgm41 INTO sr.ecm03,sr.ecm04,
                 sr.ecm45,sr.ecm06,sr.ecm41 FROM sgm_file 
                 WHERE sgm01=sr.shb16 AND sgm03=sr.shb06
                   AND sgm012 = sr.shb012                    #FUN-A60076 add by vealxu
       END IF
     #----------------No.MOD-640281 end
#      OUTPUT TO REPORT g732_rep(sr.*)
 
         FOREACH g732_c2 USING sr.shb01,sr.shb05 INTO sr1.*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
            END IF
            #MOD-8A0158-begin-add
#FUN-A60076 -----------mark by vealxu start-------------------------------------            
#             SELECT ecm04 INTO sr1.ecm04 FROM ecm_file
#              WHERE ecm01 = sr.shb05
#                AND ecm03 = sr1.shc06
#                AND ecm012 = sr.shb012               #FUN-A60027 add by huangtao  
#FUN-A60076 -----------mark by velaxu end----------------------------------------
             IF NOT cl_null(sr.shb16) THEN
                SELECT sgm04 INTO sr1.ecm04 FROM sgm_file 
                 WHERE sgm01=sr.shb16 AND sgm03=sr1.shc06
                   AND sgm012 = l_ecm012            #FUN-A60076 add by vealxu    
             END IF
            #LET sr1.ecm04 = sr.ecm04   #MOD-8A0149 add 
            #MOD-8A0158-end-add
            EXECUTE insert_prep1 USING sr1.*
         END FOREACH
 
         EXECUTE insert_prep USING sr.*    ,"",  l_img_blob,"N",""  # No.FUN-C40020 add
        
     END FOREACH
#    FINISH REPORT g732_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
 
 #str MOD-840140 mod
 #   LET l_sql ="SELECT ",l_table CLIPPED,".*,",l_table1 CLIPPED,".*",
 ##TQC-730088## "  FROM ",l_table CLIPPED,",OUTER ",l_table1 CLIPPED,
 #              "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
 #              ",OUTER ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
 #              " WHERE shb01 =",l_table1 CLIPPED,".shc01 ",
 #              " ORDER BY shb01,shc01 "
###GENGRE###     LET l_sql ="SELECT A.*,B.*",
###GENGRE###     "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
###GENGRE###               g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.shb01=B.shc01 ",
###GENGRE###                " ORDER BY A.shb01,B.shc01 "
 #end MOD-840140 mod
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN                                                         
        CALL cl_wcchp(tm.wc,'shb01,shb07,shb05,shb10,shb03,shb04')
        RETURNING tm.wc                                                           
     END IF                      
###GENGRE###     LET l_str = tm.wc CLIPPED,";",g_zz05 CLIPPED
 
   # CALL cl_prt_cs3('asfg732',l_sql,l_str)    #TQC-730088
   # CALL cl_prt_cs3('asfg732','asfg732',l_sql,l_str)  # FUN-A60027 mark by huangtao
     #No.FUN-710082--end  
      #FUN-A60027------------------start---------------
     IF g_sma.sma541 = 'Y' THEN
###GENGRE###        CALL cl_prt_cs3('asfg732','asfg732_1',l_sql,l_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "shb01"                    # No.FUN-C40020 add
    CALL asfg732_grdata()    ###GENGRE###
     ELSE
###GENGRE###        CALL cl_prt_cs3('asfg732','asfg732',l_sql,l_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "shb01"                    # No.FUN-C40020 add
    CALL asfg732_grdata()    ###GENGRE###
     END IF 
    #FUN-A60027 -----------------end----------------
 
END FUNCTION
 
#No.FUN-710082--begin
#REPORT g732_rep(sr)
#  DEFINE l_last_sw     LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
#         l_ecd02       LIKE ecd_file.ecd02,
#         i	   	LIKE type_file.num5,          #No.FUN-680121 SMALLINT
#         sr        RECORD
#                 shb01  LIKE shb_file.shb01,
#                 shb03  LIKE shb_file.shb03,
#                 shb032 LIKE shb_file.shb032,
#                 shb04  LIKE shb_file.shb04,
#                 shb05  LIKE shb_file.shb05,
#                 shb06  LIKE shb_file.shb06,
#                 shb07  LIKE shb_file.shb07,
#                 shb08  LIKE shb_file.shb08,
#                 shb081 LIKE shb_file.shb081,
#                 shb082 LIKE shb_file.shb082,
#                 shb10  LIKE shb_file.shb10,
#                 shb12  LIKE shb_file.shb12,
#                 shb111 LIKE shb_file.shb111,
#                 shb112 LIKE shb_file.shb112,
#                 shb113 LIKE shb_file.shb113,
#                 shb114 LIKE shb_file.shb114,
#                 shb115 LIKE shb_file.shb115,
#                 shb16  LIKE shb_file.shb16,          #No.MOD-640281 add
#                 ima02  LIKE ima_file.ima02,
#                 gen02  LIKE gen_file.gen02,
#                 ecm03  LIKE ecm_file.ecm03,
#                 ecm04  LIKE ecm_file.ecm04,
#                 ecm45  LIKE ecm_file.ecm45,
#                 ecm06  LIKE ecm_file.ecm06,
#                 ecm41  LIKE ecm_file.ecm41
#                       END RECORD,
#           sr1   RECORD
#                 shc03  LIKE shc_file.shc03,
#                 shc04  LIKE shc_file.shc04,
#                 qce02  LIKE qce_file.qce02,
#                 qce03  LIKE qce_file.qce03,
#                 shc05  LIKE shc_file.shc05,
#                 shc06  LIKE shc_file.shc06,
#                 ecm04  LIKE ecm_file.ecm04
#                       END RECORD
 
# OUTPUT TOP MARGIN 3 LEFT MARGIN g_left_margin BOTTOM MARGIN 3 PAGE LENGTH g_page_line
# ORDER BY sr.shb01
# FORMAT
#  PAGE HEADER
##No.FUN-580014 --start--
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<','/pageno'
#     PRINT g_head CLIPPED, pageno_total
#     PRINT g_dash[1,g_len]
#     LET l_last_sw='n'
 
#  BEFORE GROUP OF sr.shb01
#    SKIP TO TOP OF PAGE
 
#  AFTER GROUP OF sr.shb01
#     PRINT g_x[11] CLIPPED,sr.shb01,
#           COLUMN 33,g_x[12] CLIPPED,sr.shb03,
#           COLUMN 58,g_x[13] CLIPPED,sr.shb032 USING '#####&',' ',
#                     g_x[35] CLIPPED
#     PRINT g_x[14] CLIPPED,sr.shb04,' ',sr.gen02 CLIPPED,
#           COLUMN 33,g_x[15] CLIPPED,sr.shb08
#     PRINT
#     PRINT g_x[17] CLIPPED,sr.shb05,
#           COLUMN 33,g_x[18] CLIPPED,sr.shb10
#     PRINT g_x[20] CLIPPED,sr.ima02 #TQC-5B0023
#     PRINT g_x[19] CLIPPED,sr.shb07,
#           COLUMN 33,g_x[42] CLIPPED,sr.shb16     #No.MOD-640281 add
#    #      COLUMN 33,g_x[20] CLIPPED,sr.ima02 #TQC-5B0023
#     PRINT g_x[21] CLIPPED,sr.shb06 USING '####&',
#           COLUMN 33,g_x[22] CLIPPED,sr.shb081,' ',sr.shb082 CLIPPED
#     PRINT
#     PRINT g_x[24] CLIPPED,sr.shb111 USING '#######&',
#           COLUMN 33,g_x[25] CLIPPED,sr.shb115 USING '#######&',
#           COLUMN 60,g_x[26] CLIPPED,sr.shb112 USING '#######&'
#     PRINT g_x[27] CLIPPED,sr.shb113 USING '#######&',
#           COLUMN 33,g_x[28] CLIPPED,
#           sr.shb12 USING '####&',' ',sr.ecm45 USING '########',
#           COLUMN 60,g_x[29] CLIPPED,sr.shb114 USING '#######&'
#     PRINT g_dash2[1,g_len]
#      PRINT g_x[31] CLIPPED,COLUMN 55,g_x[32] CLIPPED
#      PRINT g_x[33] CLIPPED,g_x[34] CLIPPED
#     PRINTX name=H1 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
#     PRINT g_dash1
#     FOREACH g732_c2 USING sr.shb01,sr.shb05 INTO sr1.*
#        PRINTX name=D1
#              COLUMN g_c[36],sr1.shc03 USING '###&', #FUN-590118
#              COLUMN g_c[37],sr1.shc04 CLIPPED,
#              COLUMN g_c[38],sr1.qce03 CLIPPED,
#              COLUMN g_c[39],sr1.shc05 USING '###########&',
#              COLUMN g_c[40],sr1.shc06 USING '###########&',
#              COLUMN g_c[41],sr.ecm04 CLIPPED
##No.FUN-580014 --end--
#     END FOREACH
 
#ON LAST ROW
#     IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
#        CALL cl_wcchp(tm.wc,'sfb01,sfb02,sfb03,sfb04,sfb05')
#                      RETURNING tm.wc
#        PRINT g_dash[1,g_len]
##NO.TQC-630166 start**
##         IF tm.wc[001,070] > ' ' THEN# for 80
##            PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
##         IF tm.wc[071,140] > ' ' THEN
##            PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
##         IF tm.wc[141,210] > ' ' THEN
##            PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
##         IF tm.wc[211,280] > ' ' THEN
##            PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
##         CALL cl_prt_pos_wc(tm.wc)
##NO.TQC-631066 end--
#     END IF
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#    PRINT g_dash[1,g_len]
#    IF l_last_sw='n' THEN
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#    ELSE
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#    END IF
### FUN-550124
#     PRINT
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[9]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[9]
#            PRINT g_memo
#     END IF
### END FUN-550124
 
#END REPORT
##Patch....NO.TQC-610037 <> #
#No.FUN-710082--end  

###GENGRE###START
FUNCTION asfg732_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr2      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add
    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("asfg732")
        IF handler IS NOT NULL THEN
            START REPORT asfg732_rep TO XML HANDLER handler
     #       LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  #FUN-B40087 mark

             #FUN-B40087------------add------str----
             LET l_sql ="SELECT A.*,B.*",
                        "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A LEFT OUTER JOIN ",
                        g_cr_db_str CLIPPED,l_table1 CLIPPED," B ON A.shb01=B.shc01 ",
                        " ORDER BY A.shb01,B.shc01 "
             #FUN-B40087------------add------end-----
          
            DECLARE asfg732_datacur1 CURSOR FROM l_sql
            FOREACH asfg732_datacur1 INTO sr1.*,sr2.*
                OUTPUT TO REPORT asfg732_rep(sr1.*,sr2.*)
            END FOREACH
            FINISH REPORT asfg732_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asfg732_rep(sr1,sr2)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B40087---------add-----str-----
    DEFINE l_shb032          STRING
    DEFINE l_shb04_gen02     STRING
    DEFINE l_shb081_shb082   STRING
    DEFINE l_shb12_ecm45     STRING
    DEFINE l_sql             STRING
    DEFINE l_shb12           STRING
    #FUN-B40087---------add-----end-----

    
    ORDER EXTERNAL BY sr1.shb01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              


        BEFORE GROUP OF sr1.shb01
            LET l_lineno = 0
            #FUN-B40087---------add-----str-----
            LET l_shb032 = sr1.shb032 USING '---,---,---,---,--&.&&' ,'',cl_gr_getmsg("gre-066",g_lang,'1')
            PRINTX l_shb032
            LET l_shb04_gen02 = sr1.shb04,' ',sr1.gen02
            PRINTX l_shb04_gen02
            LET l_shb081_shb082 = sr1.shb081,' ',sr1.shb082
            PRINTX l_shb081_shb082
            LET l_shb12 = sr1.shb12 USING '--,---,---,---,--&'
            LET l_shb12_ecm45 = l_shb12,' ',sr1.ecm45
            PRINTX l_shb12_ecm45

            PRINTX g_sma.sma541
            #FUN-B40087---------add-----end-----

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*
            PRINTX sr2.*

        AFTER GROUP OF sr1.shb01

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-C30085
