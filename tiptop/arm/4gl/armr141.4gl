# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: armr141.4gl
# Descriptions...: RMA覆出單彙總列印
# Date & Author..: 98/06/30 by plum
# Modify ........: MOD-490221 04/09/13 By Smapmin 修正收貨日期 LINK 時的錯誤
# Modify.........: No.FUN-550122 05/05/27 By echo 新增報表備註
# Modify.........: No.FUN-580013 05/08/17 By trisy 2.0憑証類報表修改,轉XML格式
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-650081 06/05/30 By Sarah Remove yba*
# Modify.........: No.FUN-650017 06/06/15 By Echo 報表段的LEFT MARGIN的值改為 g_left_margin
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-720014 07/04/10 By rainy 地址欄位擴充成5欄
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-C30190 12/03/15 By yangxf 将原报表转换成CR报表
# Modify.........: No.CHI-C80041 12/12/20 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                         # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),             # Where condition
              more    LIKE type_file.chr1     # Prog. Version..: '5.30.06-13.03.12(01)               # Input more condition(Y/N)
              END RECORD,
        g_name        LIKE zx_file.zx02
       #g_yba01       LIKE yba_file.yba01,   # FUN-650081 mark
       #g_yba92       LIKE yba_file.yba92    # FUN-650081 mark
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_str           STRING                 #FUN-C30190 add
DEFINE   l_table         STRING                 #FUN-C30190 add
DEFINE   g_sql           STRING                 #FUN-C30190 add
DEFINE   l_img_blob      LIKE type_file.blob    #FUN-C30190 add
DEFINE   l_ii            INTEGER                #FUN-C30190 add
DEFINE   l_key           LIKE rme_file.rme01    #FUN-C30190 add
DEFINE   g_wc            STRING                 #FUN-C30190 add

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
#--------------No.TQC-610087 modify
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6) 
   LET tm.wc    = ARG_VAL(7) 
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
  #INITIALIZE tm.* TO NULL                # Default condition
  #LET g_rlang = g_lang            
  #LET tm.wc   = ARG_VAL(1)        
#--------------No.TQC-610087 end
#FUN-C30190 add begin ---
   LET g_sql =  "no.type_file.num5,",
                "rme01.rme_file.rme01,",
                "rme03.rme_file.rme03,",
                "occ18.occ_file.occ18,",
                "occ09.occ_file.occ09,",
                "l_occ09.occ_file.occ18,",
                "occ07.occ_file.occ07,",
                "l_occ07.occ_file.occ18,",
                "occ21.occ_file.occ21,",
                "l_geb02.geb_file.geb02,",
                "rme12.rme_file.rme12,",
                "gen02.gen_file.gen02,",
                "rme21.rme_file.rme21,",
                "rme073.rme_file.rme073,",
                "rme074.rme_file.rme074,",
                "rme075.rme_file.rme075,",
                "rme076.rme_file.rme076,",
                "rme077.rme_file.rme077,",
                "rme021.rme_file.rme021,",
                "rma20.rma_file.rma20,",
                "ima15.ima_file.ima15,",
                "rmc01.rmc_file.rmc01,",
                "rmc04.rmc_file.rmc04,",
                "rmc06.rmc_file.rmc06,",
                "rmc061.rmc_file.rmc061,",
                "rmc05.rmc_file.rmc05,",
                "rmc31.rmc_file.rmc31,",
                "sign_type.type_file.chr1,",      #簽核方式
                "sign_img.type_file.blob,",       #簽核圖檔
                "sign_show.type_file.chr1"        #是否顯示簽核資料(Y/N)
   LET l_table = cl_prt_temptable('armr141',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
#FUN-C30190 add end ---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
   IF cl_null(tm.wc)
      THEN CALL armr141_tm(0,0)        # Input print condition
      ELSE
        #LET tm.wc = "rme01='",tm.wc CLIPPED,"'"    #No.TQC-610087 mark
        CALL armr141()            # Read data and create out-file
   END IF
 { IF cl_null(g_bgjob) OR g_bgjob='N'        # If background job sw is off
      THEN CALL armr141_tm(0,0)        # Input print condition
      ELSE CALL armr141()            # Read data and create out-file
   END IF  }
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073 ADD #FUN-BB0047 從IF中拉出
END MAIN
 
FUNCTION armr141_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 14
   ELSE LET p_row = 5 LET p_col = 15
   END IF
   OPEN WINDOW armr141_w AT p_row,p_col
        WITH FORM "arm/42f/armr141"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rme01,rme02,rme03
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
      LET INT_FLAG = 0 CLOSE WINDOW armr141_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
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
      LET INT_FLAG = 0 CLOSE WINDOW armr141_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armr141'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armr141','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     " '",g_lang CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc CLIPPED,"'" ,
                    #" '",tm.more CLIPPED,"'"  ,           #No.TQC-610087 mark
                     " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                     " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                     " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('armr141',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armr141_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armr141()
   ERROR ""
END WHILE
   CLOSE WINDOW armr141_w
END FUNCTION
 
FUNCTION armr141()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(1000)
          sr        RECORD
                    no        LIKE type_file.num5,      #FUN-C30190 add
                    rme01     LIKE rme_file.rme01,      # RMA覆出單號
                    rme03     LIKE rme_file.rme03,      # 客戶編號
                    occ18     LIKE occ_file.occ18,      # 客戶全名
                    occ09     LIKE occ_file.occ09,      # 送貨客戶
                    l_occ09   LIKE occ_file.occ18,      # 送貨客戶全名
                    occ07     LIKE occ_file.occ07,      # 帳款客戶
                    l_occ07   LIKE occ_file.occ18,      # 帳款客戶全名
                    occ21     LIKE occ_file.occ21,      # 國別
                    l_geb02   LIKE geb_file.geb02,      # FUN-C30190 add
                    rme12     LIKE rme_file.rme12,      # 業務人員
                    gen02     LIKE gen_file.gen02,      # 業務人員姓名
                    rme21     LIKE rme_file.rme21,      # 備註
                    rme073    LIKE rme_file.rme073,     # 送貨地址1
                    rme074    LIKE rme_file.rme074,     # 送貨地址2
                    rme075    LIKE rme_file.rme075,     # 送貨地址3
                    rme076    LIKE rme_file.rme076,     # 送貨地址4  #FUN-720014
                    rme077    LIKE rme_file.rme077,     # 送貨地址5  #FUN-720014
                    rme021    LIKE rme_file.rme021,     # 覆出日期
                     rma20     LIKE rma_file.rma20,      # 收貨日期 #MOD-490221
                    ima15     LIKE ima_file.ima15,      # 保稅否
                    rmc01     LIKE rmc_file.rmc01,      # RMA單號
                   #rmc02     LIKE rmc_file.rmc02,      # RMA單號項次
                    rmc04     LIKE rmc_file.rmc04,      # 產品編號
                    rmc06     LIKE rmc_file.rmc06,      # 品名
                    rmc061    LIKE rmc_file.rmc061,     # 規格
                    rmc05     LIKE rmc_file.rmc05,      # 單位
                    rmc31     LIKE rmc_file.rmc31       # 數量
                   ,sign_type LIKE type_file.chr1,      #FUN-C30190 add
                    sign_img  LIKE type_file.blob,      #FUN-C30190 add
                    sign_show LIKE type_file.chr1       #FUN-C30190 add
                    END RECORD
   DEFINE l_rme01   LIKE rme_file.rme01                 #FUN-C30190 add
   DEFINE l_n       LIKE type_file.num5                 #FUN-C30190 add 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang   #FUN-650081 unmark
    #SELECT yba02,yba01,yba92 INTO g_company,g_yba01,g_yba92        #FUN-650081 mark
    #  FROM yba_file                                                #FUN-650081 mark
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND rmeuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND rmegrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
     #End:FUN-980030
 
#FUN-C30190 add begin ---
     CALL cl_del_data(l_table)
     LOCATE sr.sign_img IN MEMORY
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,
                          ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,
                          ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?) "
     PREPARE insert_prep FROM g_sql
     IF STATUS THEN
        CALL cl_err('insert_prep:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
#FUN-C30190 add end ----
#    LET l_sql="SELECT rme01,rme03,occ18,occ09,'',occ07,'',occ21,rme12,gen02,",           #FUN-C30190 mark
     LET l_sql="SELECT '',rme01,rme03,occ18,occ09,'',occ07,'',occ21,'',rme12,gen02,",     #FUN-C30190 add
               " rme21,rme073,rme074,rme075,rme076,rme077,rme021,rma20,ima15,rmc01,",  #FUN-720014 add rme076/rme077
               "      rmc04,rmc06,rmc061,rmc05,sum(rmc31) ",
               " ,'','','N' ",                                                             #FUN-C30190 add
               " FROM rme_file,rmp_file,rma_file,occ_file,gen_file, ",
               " rmc_file LEFT OUTER JOIN ima_file ON ima_file.ima01=rmc_file.rmc04 ",
               " WHERE rme01=rmc23 AND rme03=occ01 AND rma01=rmc01 ",
               "   AND rmp06=rmc02 and rmp05=rmc01 and rmp01=rme01 ",
               "   AND gen01=rme12 ",
               "   AND rmp06=rmc02 and rmp05=rmc01 and rmp01=rme01 and rmp00='1'",
               "   and rmevoid='Y'  ",
               "   AND rmeconf <> 'X' ",  #CHI-C80041
               "   AND gen01=rme12 AND ",tm.wc CLIPPED,
      "  GROUP BY rme01,rme03,occ18,occ09,occ07,occ21,rme12,gen02,rme21,rme073,rme074,rme075,rme076,rme077,rme021,rma20,ima15,rmc01,rmc04,rmc06,rmc061,rmc05",
      #"  GROUP BY rme01,rme03,occ18,occ09,occ07,occ21,rme12,gen02,rme21,rme073,rme074,rme075,rme021,rma20,ima15,rmc01,rmc04,rmc06,rmc061,rmc05 ",
      "  ORDER BY rme01,rmc04,rmc06 "
 
     PREPARE armr141_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare1:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        EXIT PROGRAM
     END IF
     DECLARE armr141_curs1 CURSOR FOR armr141_prepare1
 
#    CALL cl_outnam('armr141') RETURNING l_name                   #FUN-C30190 mark
#    START REPORT armr141_rep TO l_name                           #FUN-C30190 mark
 
     SELECT zx02 INTO g_name FROM zx_file WHERE zx01=g_user
     LET g_pageno = 0
     INITIALIZE sr.* TO NULL                                      #FUN-C30190 add
     FOREACH armr141_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#      OUTPUT TO REPORT armr141_rep(sr.*)                         #FUN-C30190 mark
#FUN-C30190 add begin ----
       IF l_rme01 <> sr.rme01 OR cl_null(l_rme01) THEN
          LET l_n = 1
       ELSE
          LET l_n = l_n + 1
       END IF
       SELECT occ18 INTO sr.l_occ09 FROM occ_file
          WHERE occ01=sr.occ09
       SELECT occ18 INTO sr.l_occ07 FROM occ_file
          WHERE occ01=sr.occ07
       SELECT geb02 INTO sr.l_geb02    FROM geb_file
          WHERE geb01=sr.occ21
       LET l_rme01 = sr.rme01
       LET sr.no = l_n
       EXECUTE  insert_prep  USING sr.*
#FUN-C30190 add end ------
     END FOREACH
#FUN-C30190 add begin ---
   LET l_sql="SELECT rme01 ",
             "  FROM rme_file ",
             " WHERE ",tm.wc CLIPPED,
             "  GROUP BY rme01"
   PREPARE r141_pr4 FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare r141_pr4:',SQLCA.sqlcode,0)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE r141_cs4 CURSOR FOR r141_pr4
   LET g_cr_table = l_table
   LET g_cr_gcx01 = "armi001"
   LET g_cr_apr_key_f = "rme01"
   LET l_ii = 1
   CALL g_cr_apr_key.clear()
   FOREACH r141_cs4 INTO l_key
      LET g_cr_apr_key[l_ii].v1 = l_key
      LET l_ii = l_ii + 1
   END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_wcchp(tm.wc,'rme01,rme02,rme03') RETURNING g_wc
   LET g_str = g_wc
   CALL cl_prt_cs3('armr141','armr141',l_sql,g_str)
#FUN-C30190 add end ----
#    FINISH REPORT armr141_rep                                    #FUN-C30190 mark
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                  #FUN-C30190 mark
 
     #No.FUN-BB0047--mark--Begin---
     #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
     #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#FUN-C30190 mark begin ---
#REPORT armr141_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#          l_n          LIKE type_file.num5,    #No.FUN-690010 SMALLINT
#          l_geb02      like geb_file.geb02,
#          l_p          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#          sr        RECORD
#                    rme01     LIKE rme_file.rme01,      # RMA覆出單號
#                    rme03     LIKE rme_file.rme03,      # 客戶編號
#                    occ18     LIKE occ_file.occ18,      # 客戶全名
#                    occ09     LIKE occ_file.occ09,      # 送貨客戶
#                    l_occ09   LIKE occ_file.occ18,      # 送貨客戶全名
#                    occ07     LIKE occ_file.occ07,      # 帳款客戶
#                    l_occ07   LIKE occ_file.occ18,      # 帳款客戶全名
#                    occ21     LIKE occ_file.occ21,      # 國別
#                    rme12     LIKE rme_file.rme12,      # 業務人員
#                    gen02     LIKE gen_file.gen02,      # 業務人員姓名
#                    rme21     LIKE rme_file.rme21,      # 備註
#                    rme073    LIKE rme_file.rme073,     # 送貨地址1
#                    rme074    LIKE rme_file.rme074,     # 送貨地址2
#                    rme075    LIKE rme_file.rme075,     # 送貨地址3
#                    rme076    LIKE rme_file.rme076,     # 送貨地址4 #FUN-720014
#                    rme077    LIKE rme_file.rme077,     # 送貨地址5 #FUN-720014
#                    rme021    LIKE rme_file.rme021,     # 覆出日期
#                     rma20     LIKE rma_file.rma20,      # 收貨日期 #MOD-490221
#                    ima15     LIKE ima_file.ima15,      # 保稅否
#                    rmc01     LIKE rmc_file.rmc01,      # RMA單號
#                   #rmc02     LIKE rmc_file.rmc02,      # RMA單號項次
#                    rmc04     LIKE rmc_file.rmc04,      # 產品編號
#                    rmc06     LIKE rmc_file.rmc06,      # 品名
#                    rmc061    LIKE rmc_file.rmc061,     # 規格
#                    rmc05     LIKE rmc_file.rmc05,      # 單位
#                    rmc31     LIKE rmc_file.rmc31       # 數量
#                    END RECORD
# 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin      #FUN-650017    
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
# 
#  ORDER BY sr.rme01,sr.rmc01,sr.rmc04,sr.rmc06
# 
#  FORMAT
#    PAGE HEADER
#      PRINT
##     PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED    #No.FUN-580013
#      PRINT
##     PRINT g_x[28] CLIPPED,' ',g_yba01   #FUN-650081 mark
#      PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5), 'FROM:', g_user CLIPPED
#      PRINT
##     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1] CLIPPED  #No.FUN-580013
#      LET g_pageno= g_pageno+1
#      PRINT g_x[2] CLIPPED,' ',g_today CLIPPED,' ',TIME,
#            COLUMN g_len-7,g_x[3] CLIPPED,' ',g_pageno USING '<<<'
#      PRINT g_dash
#      SELECT occ18 INTO sr.l_occ09 FROM occ_file
#         WHERE occ01=sr.occ09
#      SELECT occ18 INTO sr.l_occ07 FROM occ_file
#         WHERE occ01=sr.occ07
#      SELECT geb02 INTO l_geb02    FROM geb_file
#         WHERE geb01=sr.occ21
#      PRINT g_x[9] CLIPPED,' ',sr.rme01 CLIPPED,COLUMN 55,
#            g_x[24] CLIPPED,' ',sr.rme021
#      PRINT g_x[21] CLIPPED,' ',sr.rmc01 CLIPPED,COLUMN 55,
#            g_x[25] CLIPPED,' ',sr.rma20
#      PRINT g_x[22] CLIPPED
#      PRINT g_x[23] CLIPPED,' ',sr.rme12 CLIPPED,' ',sr.gen02,
#            COLUMN 55, g_x[26] CLIPPED,' ',l_geb02
#      PRINT g_x[10] CLIPPED,' ',sr.occ09 CLIPPED,'  ',sr.l_occ09
#      PRINT g_x[27] CLIPPED,' ',sr.occ07 CLIPPED,'  ',sr.l_occ07
#      PRINT g_x[11] CLIPPED,' ',sr.rme073 CLIPPED
#      PRINT COLUMN 12,sr.rme074 CLIPPED
#      PRINT COLUMN 12,sr.rme075 CLIPPED
#      PRINT COLUMN 12,sr.rme076 CLIPPED   #FUN-720014
#      PRINT COLUMN 12,sr.rme077 CLIPPED   #FUN-720014
#      PRINT g_dash
##No.FUN-580013 --start--
##     PRINT COLUMN 13,g_x[12] CLIPPED,g_x[13] CLIPPED
##    #PRINT COLUMN 66,g_x[14] CLIPPED
##     PRINT COLUMN 13,'----- --------------- ------------------------------',
##                   ' ----  ----  ------'
#      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#      PRINTX name = H2 g_x[37],g_x[38],g_x[39]
#      PRINT g_dash1
##No.FUN-580013 --end--
#      LET l_last_sw='n'        #FUN-550122
# 
#    BEFORE GROUP OF sr.rme01
#      SKIP TO TOP OF PAGE
#      #LET l_last_sw='n'         #FUN-550122
#      LET l_n=1
# 
#    AFTER GROUP OF sr.rme01
#      #LET l_last_sw ='y'       #FUN-550122
#      PRINT
#      PRINT g_dash
#      PRINT ' ',g_x[4] CLIPPED
# 
#    ON EVERY ROW
##No.FUN-580013 --start--
##     PRINT COLUMN 14,l_n USING '##&',
##           COLUMN 19,sr.rmc04[1,15],
##           COLUMN 35,sr.rmc06,
##           COLUMN 66,sr.rmc05,
##           COLUMN 73,sr.ima15,
##           COLUMN 78,sr.rmc31 USING '-,--&'
##     PRINT COLUMN 35,sr.rmc061
#      PRINTX name = D1
#            COLUMN g_c[31],l_n USING '###&', #FUN-590118
#            COLUMN g_c[32],sr.rmc04[1,15],
#            COLUMN g_c[33],sr.rmc06 CLIPPED,
#            COLUMN g_c[34],sr.rmc05 CLIPPED,
#            COLUMN g_c[35],sr.ima15 CLIPPED,
#            COLUMN g_c[36],sr.rmc31 USING '-,--&'
#      PRINTX name = D2
#            COLUMN g_c[39],sr.rmc061 CLIPPED
##No.FUN-580013 --end--
#      let  l_n=l_n+1
# 
### FUN-550122
#    ON LAST ROW
#      LET l_last_sw = 'y'
# 
#    PAGE TRAILER
#     #IF l_last_sw = 'y' THEN
#     #   PRINT
#     #   PRINT sr.rme21
#     #   PRINT g_x[15] ,g_x[16] CLIPPED,g_x[17] CLIPPED
#     #   PRINT
#     #   PRINT g_x[18] CLIPPED,g_x[19] CLIPPED,' ',g_name,'  ',
#     #         g_x[20] CLIPPED,'  ',g_yba92
#     #   LET l_last_sw='n'
#     #ELSE
#     #   SKIP 5 LINE
#     #END IF
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#            PRINT g_x[15]
#            PRINT g_memo
#         ELSE
#            PRINT
#            PRINT
#         END IF
#      ELSE
#            PRINT g_x[15]
#            PRINT g_memo
#      END IF
### END FUN-550122
# 
#END REPORT
#FUN-C30190 mark end ---
#Patch....NO.TQC-610037 <> #
