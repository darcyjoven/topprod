# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrg211.4gl
# Descriptions...: 修改信用狀申請書(axrg211)
# Date & Author..: 99/01/21      by plum
# Modify.........: No.FUN-4C0100 05/01/26 By Smapmin 調整單價.金額.匯率大小
# Modify.........: NO.FUN-550071 05/05/19 By jackie 單據編號加大
# Modify.........: No.FUN-550111 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580010 05/08/05 By yoyo 憑証類報表原則修改
# Modify.........: No.MOD-590513 05/10/03 By Dido 報表調整
# Modify.........: No.TQC-5B0042 05/11/08 By kim 報表調整
# Modify.........: NO.FUN-590118 06/01/10 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-720053 07/02/28 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730113 07/03/26 By Nicole 增加CR參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/12 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-B40087 11/06/01 By yangtt  憑證報表轉GRW
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C40019 12/04/11 By yangtt GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.CHI-C80041 13/01/03 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                            # Print condition RECORD
              wc      LIKE type_file.chr1000,   # Where condition #No.FUN-680123 VARCHAR(1000)
              more    LIKE type_file.chr1       # Input more condition(Y/N) #No.FUN-680123 VARCHAR(01)
              END RECORD
 
DEFINE   g_i          LIKE type_file.num5       #count/index for any purpose        #No.FUN-680123 SMALLINT
DEFINE l_table        STRING                      #FUN-720053 add
DEFINE g_sql          STRING                      #FUN-720053 add
DEFINE g_str          STRING                      #FUN-720053 add
###GENGRE###START
TYPE sr1_t RECORD
    ole01_ole02 LIKE ole_file.ole01, 
    ole01 LIKE ole_file.ole01,
    ole02 LIKE ole_file.ole02,
    ole03 LIKE ole_file.ole03,
    ole04 LIKE ole_file.ole04,
    ole05 LIKE ole_file.ole05,
    ole07 LIKE ole_file.ole07,
    ole09 LIKE ole_file.ole09,
    ole10 LIKE ole_file.ole10,
    ole15 LIKE ole_file.ole15,
    ole14 LIKE ole_file.ole14,
    ola05 LIKE ola_file.ola05,
    ola04 LIKE ola_file.ola04,
    ola09 LIKE ola_file.ola09,
    ola21 LIKE ola_file.ola21,
    olf03 LIKE olf_file.olf03,
    olf04 LIKE olf_file.olf04,
    olf05 LIKE olf_file.olf05,
    olf06 LIKE olf_file.olf06,
    olf07 LIKE olf_file.olf07,
    olf08 LIKE olf_file.olf08,
    tax LIKE olf_file.olf08,
    olf11 LIKE olf_file.olf11,
    azi03 LIKE azi_file.azi03,
    azi04 LIKE azi_file.azi04,
    occ02 LIKE occ_file.occ02,
    sign_type LIKE type_file.chr1,     #FUN-C40019 add
    sign_img LIKE type_file.blob,      #FUN-C40019 add
    sign_show LIKE type_file.chr1,     #FUN-C40019 add
    sign_str LIKE type_file.chr1000    #FUN-C40019 add
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                              # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
#No.FUN-720053--begin
   LET g_sql = "ole01_ole02.ole_file.ole01,", 
               "ole01.ole_file.ole01,",
               "ole02.ole_file.ole02,",
               "ole03.ole_file.ole03,",
               "ole04.ole_file.ole04,",
               "ole05.ole_file.ole05,",
               "ole07.ole_file.ole07,",
               "ole09.ole_file.ole09,",
               "ole10.ole_file.ole10,",
               "ole15.ole_file.ole15,",
               "ole14.ole_file.ole14,",
               "ola05.ola_file.ola05,",
               "ola04.ola_file.ola04,",
               "ola09.ola_file.ola09,",
               "ola21.ola_file.ola21,",
               "olf03.olf_file.olf03,",
               "olf04.olf_file.olf04,",
               "olf05.olf_file.olf05,",
               "olf06.olf_file.olf06,",
               "olf07.olf_file.olf07,",
               "olf08.olf_file.olf08,",
               "tax.olf_file.olf08,",
               "olf11.olf_file.olf11,",
               "azi03.azi_file.azi03,",
               "azi04.azi_file.azi04,",
               "occ02.occ_file.occ02,",
               "sign_type.type_file.chr1,",  #簽核方式            #FUN-C40019 add
               "sign_img.type_file.blob,",   #簽核圖檔            #FUN-C40019 add
               "sign_show.type_file.chr1,",                       #FUN-C40019 add
               "sign_str.type_file.chr1000"                       #FUN-C40019 add
   LET l_table = cl_prt_temptable('axrg211',g_sql) CLIPPED  
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM 
   END IF                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   #FUN-C40019 add 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087
      CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
      EXIT PROGRAM
   END IF
#No.FUN-720053--end
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(tm.wc) THEN
      CALL axrg211_tm(0,0)             # Input print condition
   ELSE
      CALL axrg211()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION axrg211_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01      #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,     #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 6 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 16
   ELSE LET p_row = 6 LET p_col = 16
   END IF
 
   OPEN WINDOW axrg211_w AT p_row,p_col
        WITH FORM "axr/42f/axrg211"
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
   CONSTRUCT BY NAME tm.wc ON ole01,ole02,ola04
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
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrg211_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127       
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axrg211_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127  
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrg211'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrg211','9031',1)
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
         CALL cl_cmdat('axrg211',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrg211_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127  
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrg211()
   ERROR ""
END WHILE
   CLOSE WINDOW axrg211_w
END FUNCTION
 
FUNCTION axrg211()
   DEFINE l_ole02   LIKE   ole_file.ole02 
   DEFINE 
          l_name    LIKE type_file.num20_6,   # External(Disk) file name #No.FUN-680123 VARCHAR(20)  
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(40)
          l_big5    LIKE type_file.chr1000,   #No.FUN-680123 VARCHAR(100) 
          sr        RECORD
                    ole01_ole02 LIKE ole_file.ole01,  
                    ole01     LIKE   ole_file.ole01 ,
                    ole02     LIKE   ole_file.ole02 ,
                    ole03     LIKE   ole_file.ole03 ,
                    ole04     LIKE   ole_file.ole04 ,
                    ole05     LIKE   ole_file.ole05 ,
                    ole07     LIKE   ole_file.ole07 ,
                    ole09     LIKE   ole_file.ole09 ,
                    ole10     LIKE   ole_file.ole10 ,
                    ole15     LIKE   ole_file.ole15 ,
                    ole14     LIKE   ole_file.ole14 ,
                    ola05     LIKE   ola_file.ola05 ,
                    ola04     LIKE   ola_file.ola04 ,
                    ola09     LIKE   ola_file.ola09 ,
                    ola21     LIKE   ola_file.ola21 ,
                    olf03     LIKE   olf_file.olf03 ,
                    olf04     LIKE   olf_file.olf04 ,
                    olf05     LIKE   olf_file.olf05 ,
                    olf06     LIKE   olf_file.olf06 ,
                    olf07     LIKE   olf_file.olf07 ,
                    olf08     LIKE   olf_file.olf08 ,
                    tax       LIKE   olf_file.olf08 ,
                    olf11     LIKE   olf_file.olf11 ,
                    azi03     LIKE   azi_file.azi03 ,
                    azi04     LIKE   azi_file.azi04 ,
                    occ02     LIKE   occ_file.occ02 
                    END RECORD
 DEFINE l_ole31     LIKE ole_file.ole31          #FUN-A60056 
 DEFINE l_img_blob     LIKE type_file.blob     #FUN-C40019 add

     LOCATE l_img_blob    IN MEMORY                #FUN-C40019 add

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
#No.FUN-720053--begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'axrg211'
#No.FUN-720053--end
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND oleuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND olegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND olegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oleuser', 'olegrup')
     #End:FUN-980030
 
 
     LET l_sql = "SELECT '',ole01, ole02, ole03, ole04, ole05, ole07,ole09,",
                 "  ole10,ole15,ole14, ola05,ola04,ola09,ola21,olf03,olf04,olf05, ",
                 "       olf06,olf07, olf08,0, olf11,azi03,azi04,occ02,ole31 ",    #FUN-A60056 add ole31
                 "  FROM ole_file,OUTER (olf_file),ola_file,OUTER occ_file, ",
                 "  OUTER azi_file ",
                 " WHERE ole_file.ole01 =olf_file.olf01 AND ole_file.ole01=ola_file.ola01 AND ola_file.ola05=occ_file.occ01 " ,
                 "   AND ole_file.ole15=azi_file.azi01   AND olaconf !='X' ",#010806增
                 "   AND oleconf <> 'X' ",  #CHI-C80041
                 "   AND ", tm.wc CLIPPED
 
     PREPARE axrg211_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127   
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE axrg211_curs1 CURSOR FOR axrg211_prepare1
 
#No.FUN-720053--begin
#     CALL cl_outnam('axrg211') RETURNING l_name
#     START REPORT axrg211_rep TO l_name
#
#     LET g_pageno = 0
#No.FUN-720053--end
     FOREACH axrg211_curs1 INTO sr.*,l_ole31     #FUN-A60056 add ole31
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_ole02 = sr.ole02  
       LET sr.ole01_ole02 = sr.ole01,l_ole02 
      #FUN-A60056--mod--str--
      #SELECT oea211 INTO sr.tax
      #    FROM oea_file WHERE oea01 = sr.olf04
       LET l_sql = "SELECT oea211 FROM ",cl_get_target_table(l_ole31,'oea_file'),
                   " WHERE oea01 = '",sr.olf04,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,l_ole31) RETURNING l_sql
       PREPARE sel_oea211 FROM l_sql
       EXECUTE sel_oea211 INTO sr.tax
      #FUN-A60056--mod--end
#No.FUN-720053--begin
       EXECUTE insert_prep USING  sr.*,"",l_img_blob,"N",""    #FUN-C40019 add "",l_img_blob,"N",""
#      OUTPUT TO REPORT axrg211_rep(sr.*)
#No.FUN-720053--end
     END FOREACH
 
#No.FUN-720053--begin
#    FINISH REPORT axrg211_rep
     CALL cl_wcchp(tm.wc,'ole01,ole02,ola04') 
          RETURNING tm.wc 
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED     #TQC-730113
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
###GENGRE###     LET g_str = tm.wc
   # CALL cl_prt_cs3('axrg211',g_sql,g_str)           #TQC-730113
###GENGRE###     CALL cl_prt_cs3('axrg211','axrg211',g_sql,g_str)            
    LET g_cr_table = l_table                   #主報表的temp table名稱          #FUN-C40019 add
    LET g_cr_apr_key_f = "ole01|ole02"         #報表主鍵欄位名稱，用"|"隔開     #FUN-C40019 add
    CALL axrg211_grdata()    ###GENGRE###
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-720053--end
END FUNCTION
 
#No.FUN-720053--begin
#REPORT axrg211_rep(sr)
#   DEFINE 
#          l_last_sw    LIKE type_file.chr1,      #No.FUN-680123 VARCHAR(1)
#          l_occ        LIKE occ_file.occ02,
#          sr        RECORD
#                    ole01     LIKE   ole_file.ole01 ,
#                    ole02     LIKE   ole_file.ole02 ,
#                    ole03     LIKE   ole_file.ole03 ,
#                    ole04     LIKE   ole_file.ole04 ,
#                    ole05     LIKE   ole_file.ole05 ,
#                    ole07     LIKE   ole_file.ole07 ,
#                    ole09     LIKE   ole_file.ole09 ,
#                    ole10     LIKE   ole_file.ole10 ,
#                    ole15     LIKE   ole_file.ole15 ,
#                    ole14     LIKE   ole_file.ole14 ,
#                    ola05     LIKE   ola_file.ola05 ,
#                    ola04     LIKE   ola_file.ola04 ,
#                    ola09     LIKE   ola_file.ola09 ,
#                    ola21     LIKE   ola_file.ola21 ,
#                    olf03     LIKE   olf_file.olf03 ,
#                    olf04     LIKE   olf_file.olf04 ,
#                    olf05     LIKE   olf_file.olf05 ,
#                    olf06     LIKE   olf_file.olf06 ,
#                    olf07     LIKE   olf_file.olf07 ,
#                    olf08     LIKE   olf_file.olf08 ,
#                    tax       LIKE   olf_file.olf08 ,
#                    olf11     LIKE   olf_file.olf11 ,
#                    azi03     LIKE   azi_file.azi03 ,
#                    azi04     LIKE   azi_file.azi04 ,
#                    occ02     LIKE   occ_file.occ02
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.ole01,sr.ole02, sr.olf04 , sr.olf05
#  FORMAT
#   PAGE HEADER
#     #PRINT ' ' #TQC-5B0042
##ruby 1999/2/1
##No.FUN-580010--start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      LET g_pageno = g_pageno+1
#      LET pageno_total=PAGENO USING '<<<',"/pageno"
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      PRINT g_head CLIPPED,pageno_total
##No.FUN-580010--end
#      PRINT g_dash #TQC-5B0042
##No.FUN-550071--begin
#      PRINT COLUMN 3,g_x[15] CLIPPED ,
#            COLUMN 15, sr.ole01 CLIPPED ,COLUMN 32,'[',
#            COLUMN 33, sr.ole02 USING '##&' ,']',COLUMN 33,'[',
#            COLUMN 40, sr.ole03 CLIPPED,']'
##No.FUN-550071--end
#      PRINT ''
#      PRINT COLUMN 3,g_x[16] CLIPPED ,
#            COLUMN 15, sr.ola05 CLIPPED ,
#            COLUMN 26, sr.occ02 CLIPPED
#      PRINT ''
#      PRINT COLUMN 3, g_x[17] CLIPPED ,
#            COLUMN 15, sr.ola21 CLIPPED
#      PRINT ''
#      PRINT COLUMN 3, g_x[18] CLIPPED ,
#            COLUMN 15, sr.ola04 CLIPPED
#      PRINT ''
##ruby 1999/2/1  ole15
#      PRINT COLUMN 3, g_x[19] CLIPPED ,sr.ole15 clipped,
#            COLUMN 13, cl_numfor(sr.ole10,18,sr.azi04),COLUMN 28,'(',
#            COLUMN 29, g_x[20] CLIPPED ,
#            COLUMN 40, cl_numfor(sr.ole07,18,sr.azi04),
#            COLUMN 54, g_x[21] CLIPPED ,
#            COLUMN 65, cl_numfor(sr.ola09,18,sr.azi04),
#            COLUMN 79,')'
#      PRINT ''
#      PRINT COLUMN 3, g_x[22] CLIPPED ,
#            COLUMN 15, sr.ole05 CLIPPED
#      PRINT ''
#      PRINT COLUMN 3, g_x[23] CLIPPED ,
#            COLUMN 17, sr.ole04 ClIPPED
#     #SKIP 3 LINE #TQC-5B0042
#      PRINT g_dash #TQC-5B0042
##No.FUN-580010-start
#      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
#      PRINTX name=H2 g_x[38]
#      PRINT g_dash1
##No.FUN-550071 --start--
##No.FUN-580010--end
#      LET l_last_sw = 'n'             #FUN-550111
#
#  BEFORE GROUP OF sr.ole01
##     LET g_pageno = 0
#      SKIP TO TOP OF  PAGE
#
#  BEFORE GROUP OF sr.ole02
##     LET g_pageno = 0
#      SKIP TO TOP OF  PAGE
#
#  ON EVERY ROW
##No.FUN-580010--start
#     PRINTX name=D1
#           COLUMN g_c[31], sr.olf04 CLIPPED,
##MOD-590513
#           #COLUMN g_c[32], sr.olf05 USING '####&', #FUN-590118 mark
#           COLUMN g_c[32], sr.olf05 USING '###&',  #FUN-590118 unmark
##MOD-590513 End
#           COLUMN g_c[33], cl_numfor(sr.olf07,33,0),
#           COLUMN g_c[34], sr.olf03 CLIPPED,
#           COLUMN g_c[35], cl_numfor(sr.olf06,35,sr.azi03),
#           COLUMN g_c[36], cl_numfor(sr.olf08,36,sr.azi04),
#           COLUMN g_c[37], cl_numfor(sr.olf08*((sr.tax/100) / (1+sr.tax/100)) ,37,sr.azi04)
#     PRINTX name=D2
#           COLUMN g_c[38],sr.olf11
##No.FUn-580010--end
##No.FUN-550071 ---end--
### FUN-550111
#ON LAST ROW
#      LET l_last_sw = 'y'
#
#PAGE TRAILER
#    #PRINT COLUMN 04, g_x[11] CLIPPED
#    #PRINT COLUMN 04, g_x[12] CLIPPED ,
#    #      COLUMN 42, g_x[13] CLIPPED
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[11]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[11]
#             PRINT g_memo
#      END IF
### END FUN-550111
# 
#
#END REPORT
##Patch....NO.TQC-610037 <> #
#No.FUN-720053--end

###GENGRE###START
FUNCTION axrg211_grdata()
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
        LET handler = cl_gre_outnam("axrg211")
        IF handler IS NOT NULL THEN
            START REPORT axrg211_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ole01,ole02,ole04,ole05" 
          
            DECLARE axrg211_datacur1 CURSOR FROM l_sql
            FOREACH axrg211_datacur1 INTO sr1.*
                OUTPUT TO REPORT axrg211_rep(sr1.*)
            END FOREACH
            FINISH REPORT axrg211_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT axrg211_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno         LIKE type_file.num5
    #FUN-B40087-----------add-------str------
    DEFINE l_ole10_fmt          STRING
    DEFINE l_ole07_fmt          STRING
    DEFINE l_olf06_fmt          STRING
    DEFINE l_olf08_fmt          STRING
    DEFINE l_tax_fmt            STRING
    DEFINE l_ola05_occ02        STRING
    DEFINE l_tax                LIKE olf_file.olf08
    DEFINE l_ole10              STRING
    #FUN-B40087-----------add-------end------
    
    ORDER EXTERNAL BY sr1.ole01,sr1.ole02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              

        BEFORE GROUP OF sr1.ole01
        BEFORE GROUP OF sr1.ole02
            LET l_lineno = 0
            #FUN-B40087-----------add-------str------
            IF sr1.ole10 < 0 THEN
               LET l_ole10 = -sr1.ole10 USING '##,###,##&'
               LET l_ole10 = '(',l_ole10,')'
            ELSE
               LET l_ole10 = sr1.ole10 USING '##,###,##&'
            END IF
            PRINTX l_ole10

            LET l_ole07_fmt = cl_gr_numfmt('ole_file','ole07',sr1.azi04)
            PRINTX l_ole07_fmt
            LET l_ole10_fmt = cl_gr_numfmt('ole_file','ole10',sr1.azi04)
            PRINTX l_ole10_fmt
           
            LET l_ola05_occ02 = sr1.ola05," ",sr1.occ02
            PRINTX l_ola05_occ02
            #FUN-B40087-----------add-------end------

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40087-----------add-------str------
            LET l_olf06_fmt = cl_gr_numfmt('olf_file','olf06',sr1.azi03)
            PRINTX l_olf06_fmt
            LET l_olf08_fmt = cl_gr_numfmt('olf_file','olf08',sr1.azi04)
            PRINTX l_olf08_fmt
            LET l_tax_fmt = cl_gr_numfmt('olf_file','olf08',sr1.azi04)
            PRINTX l_tax_fmt
            LET l_tax = sr1.olf08 * ((sr1.tax/100)/(1 + sr1.tax/100))
            PRINTX l_tax
            #FUN-B40087-----------add-------end------

            PRINTX sr1.*

        AFTER GROUP OF sr1.ole01
        AFTER GROUP OF sr1.ole02

        
        ON LAST ROW

END REPORT
###GENGRE###END
#FUN-B80072	
