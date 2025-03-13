# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: armg210.4gl
# Descriptions...: RMA倉非Keypart盤點卡列印
# Date & Author..: 98/03/29 by alen
# Modi           : 98/04/10 by plum
# Modify.........: No.FUN-570243 05/07/25 By jackie 料件編號欄位加CONTROLP
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-730009 07/03/12 By Ray Crystal Report修改
# Modify.........: No.FUN-710080 07/04/04 By Sarah CR報表串cs1()增加傳一個參數
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B40097 11/05/28 By chenying 憑證類CR報表轉成GR
# Modify.........: No.FUN-B40087 11/06/09 By yangtt  憑證報表轉GRW
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-C10036 12/01/11 By qirl  程式規範調整
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No.FUN-C20052 12/02/09 By chenyign GR調整
# Modify.........: No:FUN-C40026 12/04/11 By xumm GR動態簽核
# Modify.........: No:FUN-C40026 12/07/26 By chenying GR動態簽核還原

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              yy      LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
              mm      LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
              more    LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD
 
DEFINE    g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE    l_table     STRING               #FUN-B40087          
DEFINE    g_sql       STRING                #FUN-B40087
#FUN-B40097---add---str------------------
TYPE sr1_t   RECORD
             rmh03     LIKE rmh_file.rmh03,      
             ima02     LIKE ima_file.ima02,       
             ima021    LIKE ima_file.ima021,      
             rmh09     LIKE rmh_file.rmh09,       
             rmh04     LIKE rmh_file.rmh04,      
             rmh05     LIKE rmh_file.rmh05,       
             rmh06     LIKE rmh_file.rmh06     #FUN-C40026 add,  #FUN-C40026 del , 
            #FUN-C40026--mark--str----
            ##FUN-C40026----add---str---
            #sign_type LIKE type_file.chr1,
            #sign_img  LIKE type_file.blob,
            #sign_show LIKE type_file.chr1,
            #sign_str  LIKE type_file.chr1000
            ##FUN-C40026----add---end---
            #FUN-C40026--mark--end----
END RECORD
#FUN-B40097---add---end------------------

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073    ADD #FUN-BB0047 mark
   #FUN-B40087------add-----str-----
   LET g_sql = "rmh03.rmh_file.rmh03,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "rmh09.rmh_file.rmh09,",
               "rmh04.rmh_file.rmh04,",
               "rmh05.rmh_file.rmh05,",
               "rmh06.rmh_file.rmh06 "    #FUN-C40026 add 2,  #FUN-C40026 del 2 ,
             #FUN-C40026--mark--str----
              ##FUN-C40026----add---str----
              #"sign_type.type_file.chr1,",  #簽核方式
              #"sign_img.type_file.blob,",   #簽核圖檔
              #"sign_show.type_file.chr1,",
              #"sign_str.type_file.chr1000"
              ##FUN-C40026----add---end----
             #FUN-C40026--mark--end----

   LET l_table = cl_prt_temptable('armg210',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087 #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM
    END IF                  # Temp Table產生
   #LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED, 
               " VALUES(?,?,?,?,?,?,?)"                #FUN-C40026 add 4?  #FUN-C40026 del 4?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087 #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087#FUN-C10036 mark
      EXIT PROGRAM
   END IF
   #FUN-B40087------add-----end-----
   
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   INITIALIZE tm.* TO NULL                # Default condition
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc= ARG_VAL(7)
   LET tm.yy= ARG_VAL(8)
   LET tm.mm= ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   LET tm.more = 'N'
   IF cl_null(g_bgjob) OR g_bgjob='N' THEN
      CALL armg210_tm(0,0)             # Input print condition
   ELSE
      CALL armg210()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
   CALL cl_gre_drop_temptable(l_table)            #FUN-C10036 ADD 
END MAIN
 
FUNCTION armg210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 18
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW armg210_w AT p_row,p_col
        WITH FORM "arm/42f/armg210"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
  #INITIALIZE tm.* TO NULL                        #Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
       CONSTRUCT BY NAME tm.wc ON rmh03
 
 
 
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
 
#No.FUN-570243  --start-
      ON ACTION CONTROLP
            IF INFIELD(rmh03) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ima"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rmh03
               NEXT FIELD rmh03
            END IF
#No.FUN-570243 --end--
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
          LET INT_FLAG = 0 CLOSE WINDOW armg210_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
          CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
          EXIT PROGRAM
       END IF
       IF tm.wc=" 1=1" THEN
          CALL cl_err('','9046',0) CONTINUE WHILE
       END IF
 
       INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD yy
           IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
         AFTER FIELD mm
           IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
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
         ON ACTION CONTROLG CALL cl_cmdask()     # Command execution
 
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
          LET INT_FLAG = 0 CLOSE WINDOW armg210_w 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
          CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
          EXIT PROGRAM
       END IF
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file   #get exec cmd (fglgo xxxx)
                 WHERE zz01='armg210'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('armg210','9031',1)
          ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
             LET l_cmd = l_cmd CLIPPED,    #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.yy CLIPPED,"'" ,
                         " '",tm.mm CLIPPED,"'" ,
                        #" '",tm.more CLIPPED,"'",              #No.TQC-610087 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
              CALL cl_cmdat('armg210',g_time,l_cmd)  # Execute cmd at later time
            END IF
            CLOSE WINDOW armg210_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
            CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
            EXIT PROGRAM
          END IF
          CALL cl_wait()
          CALL armg210()
          ERROR ""
   END WHILE
   CLOSE WINDOW armg210_w
END FUNCTION
 
FUNCTION armg210()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000)
          sr        RECORD
                    rmh03     LIKE rmh_file.rmh03,      # 料件編號
                    ima02     LIKE ima_file.ima02,      # 品名
                    ima021    LIKE ima_file.ima021,     # 規格
                    rmh09     LIKE rmh_file.rmh09,      # 盤存數量
                    rmh04     LIKE rmh_file.rmh04,      # RMA倉庫別
                    rmh05     LIKE rmh_file.rmh05,      # RMA儲別
                    rmh06     LIKE rmh_file.rmh06       # RMA批號
                    END RECORD

#    DEFINE l_img_blob      LIKE type_file.blob  #FUN-C40026 add   #FUN-C40026 mark
#    LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add   #FUN-C40026 mark 
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
 
#No.FUN-730009 --begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'armg210'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80  END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-730009 --end
 
     LET l_sql="SELECT rmh03,ima02,ima021,rmh09,rmh04,rmh05,rmh06 ",
               "  FROM rmh_file,ima_file ", 
               "  WHERE rmh03=ima01 ", 
               "  AND   rmh01=",tm.yy," AND rmh02=",tm.mm, 
               "  AND ",tm.wc CLIPPED
 
   # LET l_sql= l_sql CLIPPED," ORDER BY rmh03 "
#No.FUN-730009 --begin
#    PREPARE armg210_prepare1 FROM l_sql
#    IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('prepare1:',SQLCA.sqlcode,1)
#       EXIT PROGRAM
#    END IF
#    DECLARE armg210_curs1 CURSOR FOR armg210_prepare1
 
#    CALL cl_outnam('armg210') RETURNING l_name
#    START REPORT armg210_rep TO l_name
 
#    LET g_pageno = 0
#    FOREACH armg210_curs1 INTO sr.*
#      IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         EXIT FOREACH
#      END IF
 
#      OUTPUT TO REPORT armg210_rep(sr.*)
#    END FOREACH
 
#    FINISH REPORT armg210_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#    CALL cl_prt_cs1('armg210','armg210',l_sql,'')   #FUN-710080 modify   #FUN-B40087 mark
#FUN-B40087---------str-----
     PREPARE armg210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE armg210_curs1 CURSOR FOR armg210_prepare1
 
 
     LET g_pageno = 0
     FOREACH armg210_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
     EXECUTE insert_prep USING sr.*    #FUN-C40026 mark  #FUN-C40026 remark
    #EXECUTE insert_prep USING sr.*,"",l_img_blob,"N",""    #FUN-C40026 add  #FUN-C40026 mark
     END FOREACH
#    LET g_cr_table = l_table                 #FUN-C40026 add   #FUN-C40026 mark
#    LET g_cr_apr_key_f = "rmh03"             #FUN-C40026 add   #FUN-C40026 mark
#FUN-B40087---------end-----  

     CALL armg210_grdata()      #FUN-B40087  add
#No.FUN-730009 --end
     #No.FUN-BB0047--mark--Begin---
     #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     # CALL cl_gre_drop_temptable(l_table)   #FUN-C20052 mark
END FUNCTION
 
#No.FUN-730009 --begin
#REPORT armg210_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#          sr        RECORD
#                    rmh03     LIKE rmh_file.rmh03,      # 料件編號
#                    ima02     LIKE ima_file.ima02,      # 品名
#                    ima021    LIKE ima_file.ima021,     # 規格
#                    rmh09     LIKE rmh_file.rmh09,      # 盤存數量
#                    rmh04     LIKE rmh_file.rmh04,      # RMA倉庫別
#                    rmh05     LIKE rmh_file.rmh05,      # RMA儲別
#                    rmh06     LIKE rmh_file.rmh06       # RMA批號
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.rmh03
#
#  FORMAT
#   PAGE HEADER
#     #LET g_pageno= g_pageno+1
#     #PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#     #PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5), 'FROM:', g_user CLIPPED
#      PRINT
# 
#   ON EVERY ROW
#         PRINT g_x[10] CLIPPED,' ',sr.rmh03 CLIPPED
#         PRINT
#         PRINT g_x[11] CLIPPED,' ',sr.ima02 CLIPPED,sr.ima021 CLIPPED
#         PRINT
#         PRINT g_x[12] CLIPPED,' ',sr.rmh09
#         PRINT
#         PRINT g_x[13] CLIPPED,' ',sr.rmh04,' ',sr.rmh05,' ',sr.rmh06
#         PRINT
#         PRINT
# {
#  PAGE TRAILER
#    PRINT g_dash[1,g_len]
#    PRINT '(armg210)'
# }
#END REPORT
#No.FUN-730009 --end
#Patch....NO.TQC-610037 <001> #
#FUN-B40087------add-------str----------
FUNCTION armg210_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

#   LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add  #FUN-C40026 mark
#   CALL cl_gre_init_apr()           #FUN-C40026 add  #FUN-C40026 mark  

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("armg210")
        IF handler IS NOT NULL THEN
            START REPORT armg210_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

            DECLARE armg210_datacur1 CURSOR FROM l_sql
            FOREACH armg210_datacur1 INTO sr1.*
                OUTPUT TO REPORT armg210_rep(sr1.*)
            END FOREACH
            FINISH REPORT armg210_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    
    CALL cl_gre_close_report()
END FUNCTION

REPORT armg210_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno          LIKE type_file.num5
    DEFINE l_ima02_ima021    STRING
    DEFINE l_rmh03           STRING
    DEFINE l_rmh04_05_06     STRING
    DEFINE l_rmh09           STRING


    FORMAT
        FIRST PAGE HEADER
            LET l_lineno = 0
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            IF cl_null(sr1.ima02) THEN
               LET l_ima02_ima021 = sr1.ima021
            ELSE IF cl_null(sr1.ima021) THEN
                    LET l_ima02_ima021 = sr1.ima02
                 ELSE
                    LET l_ima02_ima021 = sr1.ima02,sr1.ima021
                 END IF
            END IF
            PRINTX l_ima02_ima021
            LET l_rmh03 = cl_gr_getmsg("gre-091",g_lang,1),': ',sr1.rmh03
            PRINTX l_rmh03
            LET l_rmh04_05_06 = cl_gr_getmsg("gre-092",g_lang,1),': ',sr1.rmh04,' ',sr1.rmh05,' ',sr1.rmh06      
            PRINTX l_rmh04_05_06
            LET l_rmh09 = cl_gr_getmsg("gre-093",g_lang,1),': '     
            PRINTX l_rmh09 

            PRINTX sr1.*


         ON LAST ROW


END REPORT
#FUN-B40087------add-------end----------
