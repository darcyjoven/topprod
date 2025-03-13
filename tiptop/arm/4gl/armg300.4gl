# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: armg300.4gl
# Descriptions...: 庫存雜項發料/收料/報廢單列印
# Date & Author..: 95/03/20 By Danny
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.FUN-550122 05/05/30 By echo 新增報表備註
# Modify.........: No.TQC-590053 05/10/03 By Rosayu 無法列印資料
# Modify.........: No.MOD-5A0029 05/10/03 By Rosayu aimg300修正為armg300
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-660079 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-670066 06/07/18 By ice voucher型報表轉template1
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.TQC-930069 09/03/18 By Sunyanchun 替換'\'
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50070 10/05/31 By liuxqa 追单TQC-980051
# Modify.........: No.FUN-B50018 11/05/30 By xumm CR轉GRW
# Modify.........: No.FUN-B80073 11/08/03 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
# Modify.........: No.FUN-C10036 12/01/16 By xuxz 程序規範修改
# Modify.........: No:FUN-C40026 12/04/11 By xumm GR動態簽核
# Modify.........: No:FUN-C50004 12/05/02 By nanbing GR優化 
# Modify.........: No:FUN-C30085 12/06/28 By lixiang 修改切換語言別時會當出的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(600),    # Where condition
              a       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),      # 列印
              b       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),      # 過帳
              more    LIKE type_file.chr1     #No.FUN-690010 VARCHAR(1)       # Input more condition(Y/N)
              END RECORD,
          g_dash1_1   LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(136),
          g_buf       LIKE type_file.chr20    #No.FUN-690010 VARCHAR(20)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   l_table      STRING   #FUN-A50070
DEFINE   g_sql        STRING   #FUN-A50070
DEFINE   g_str        STRING   #FUN-A50070

###GENGRE###START
TYPE sr1_t RECORD
    ina01 LIKE ina_file.ina01,
    ina00 LIKE ina_file.ina00,
    l_smydesc LIKE smy_file.smydesc,
    ina04 LIKE ina_file.ina04,
    gem02 LIKE gem_file.gem02,
    ina02 LIKE ina_file.ina02,
    inb03 LIKE inb_file.inb03,
    inb04 LIKE inb_file.inb04,
    inb07 LIKE inb_file.inb07,
    inb05 LIKE inb_file.inb05,
    inb06 LIKE inb_file.inb06,
    inb08 LIKE inb_file.inb08,
    inb09 LIKE inb_file.inb09,
    inb11 LIKE inb_file.inb11,
    ima02 LIKE ima_file.ima02,
    inb08_fac LIKE inb_file.inb08_fac,
    inb12 LIKE inb_file.inb12,
    inb15 LIKE inb_file.inb15,
    g_buf LIKE azf_file.azf03,   #FUN-C40026 add,
#FUN-C40026----add---str---
    sign_type LIKE type_file.chr1,
    sign_img  LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000
#FUN-C40026----add---end---
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80073    ADD #FUN-BB0047 mark
#FUN-A50070---begin
   LET g_sql = "ina01.ina_file.ina01,",
               "ina00.ina_file.ina00,",
               "l_smydesc.smy_file.smydesc,",
               "ina04.ina_file.ina04,",
               "gem02.gem_file.gem02,",
               "ina02.ina_file.ina02,",
               "inb03.inb_file.inb03,",
               "inb04.inb_file.inb04,",
               "inb07.inb_file.inb07,",
               "inb05.inb_file.inb05,",
               "inb06.inb_file.inb06,",
               "inb08.inb_file.inb08,",
               "inb09.inb_file.inb09,",
               "inb11.inb_file.inb11,",
               "ima02.ima_file.ima02,",
               "inb08_fac.inb_file.inb08_fac,",
               "inb12.inb_file.inb12,",
               "inb15.inb_file.inb15,",
               "g_buf.azf_file.azf03,",    #FUN-C40026 add 2,
               #FUN-C40026----add---str----
               "sign_type.type_file.chr1,",  #簽核方式
               "sign_img.type_file.blob,",   #簽核圖檔
               "sign_show.type_file.chr1,",
               "sign_str.type_file.chr1000"
               #FUN-C40026----add---end----
   LET l_table = cl_prt_temptable('armg300',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add  #FUN-BB0047 mark
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add#FUN-C10036 mark
      EXIT PROGRAM
   END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "       #FUN-C40026 add 4?                                                       
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time   #FUN-B50018  add #FUN-BB0047 mark 
      #CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add#FUN-C10036 mark
      EXIT PROGRAM                                                                             
   END IF                 
#FUN-A50070---end
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
#--------------No.TQC-610087 modify-------------
#  LET tm.a    = '3'
#  LET tm.b    = '3'
#  LET tm.more = 'N'
#  LET g_pdate = g_today
#  LET g_rlang = g_lang
#  LET g_bgjob = 'N'
#  LET g_copies = '1'
   LET g_pdate = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6) 
   LET tm.wc    = ARG_VAL(7) 
   LET tm.a     = ARG_VAL(8) 
   LET tm.b     = ARG_VAL(9) 
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET tm.wc = cl_replace_str(tm.wc,"\"","'")  #No.TQC-930069
   LET tm.wc = cl_replace_str(tm.wc,"\\","")   #No.TQC-930069
   #No.FUN-570264 ---end---
#--------------No.TQC-610087 end-------------
   IF cl_null(tm.wc)
      THEN CALL armg300_tm(0,0)             # Input print condition #MOD-5A0029 aimg300->armg300
      ELSE 
     #LET tm.wc="ina01 in (",tm.wc CLIPPED,")"     #No.TQC-610087 mark
           CALL armg300()                   # Read data and create out-file#MOD-5A0029 aimg300->armg300
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
   CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
END MAIN
 
FUNCTION armg300_tm(p_row,p_col) #MOD-5A0029 aimg300->armg300
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          l_cmd        LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 14
   ELSE LET p_row = 3 LET p_col = 12
   END IF
   OPEN WINDOW armg300_w AT p_row,p_col #MOD-5A0029 aimg300->armg300
        WITH FORM "arm/42f/armg300"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
#--------------No.TQC-610087 add-------------
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a    = '3'
   LET tm.b    = '3'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
#--------------No.TQC-610087 end-------------
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ina00,ina01,ina04,ina02
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
      LET INT_FLAG = 0 CLOSE WINDOW armg300_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM #MOD-5A0029 aimg300->armg300
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[1-3]' THEN NEXT FIELD a END IF
      AFTER FIELD b
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[1-3]' THEN NEXT FIELD b END IF
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
      LET INT_FLAG = 0 CLOSE WINDOW armg300_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM #MOD-5A0029 aimg300->armg300
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='armg300' #TQC-590053 aimg300-->armg300
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('armg300','9031',1)
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
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('armg300',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW armg300_w #MOD-5A0029 aimg300->armg300
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL armg300() #MOD-5A0029 aimg300->armg300
   ERROR ""
END WHILE
   CLOSE WINDOW armg300_w #MOD-5A0029 aimg300->armg300
END FUNCTION
 
FUNCTION armg300() #MOD-5A0029 aimg300->armg300
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0085
          l_sql     LIKE type_file.chr1000,    # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_smydesc    LIKE smy_file.smydesc,      #FUN-A50070                                                                                   
          l_x          LIKE type_file.chr5,        #FUN-A50070          
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          sr        RECORD
                    ina00     LIKE ina_file.ina00,    #類別
                    ina01     LIKE ina_file.ina01,    #編號
                    ina02     LIKE ina_file.ina02,    #日期
                    ina04     LIKE ina_file.ina04,    #部門
                    gem02     LIKE gem_file.gem02,    #名稱
                    ina05     LIKE ina_file.ina05,    #原因
                    azf03     LIKE azf_file.azf03,    #說明
                    ina06     LIKE ina_file.ina06,    #專案
                    ina07     LIKE ina_file.ina07,    #備註
                    inb03     LIKE inb_file.inb03,    #項次
                    inb04     LIKE inb_file.inb04,    #料件
                    ima02     LIKE ima_file.ima02,    #品名
                    inb05     LIKE inb_file.inb05,    #倉庫
                    inb06     LIKE inb_file.inb06,    #儲位
                    inb07     LIKE inb_file.inb07,    #批號
                    inb08     LIKE inb_file.inb08,    #單位
                    inb08_fac LIKE inb_file.inb08_fac,#轉換率
                    inb09     LIKE inb_file.inb09,    #異動量
                    inb11     LIKE inb_file.inb11,    #來源單號
                    inb12     LIKE inb_file.inb12,    #參考單號
                    inb15     LIKE inb_file.inb15,
                    inaprsw   LIKE ina_file.inaprsw,  #列印
                    inapost   LIKE ina_file.inapost   #過帳
                    END RECORD
     DEFINE l_img_blob   LIKE type_file.blob  #FUN-C40026 add

     LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add 
#       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085     #FUN-B500187 mark
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#No.FUN-670066 --Begin
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'armg300' #TQC-590053 aimg300-->armg300
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash1_1[g_i,g_i] = '-' END FOR
#No.FUN-670066 --End
     CALL cl_del_data(l_table)      #FUN-A50070  
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND inauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND inagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND inagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT ina00,ina01,ina02,ina04,gem02,ina05,azf03,",
                 "       ina06,ina07,inb03,inb04,ima02,inb05,inb06,",
                 "       inb07,inb08,inb08_fac,inb09,inb11,inb12,inb15,",
                 "       inaprsw,inapost",
               #  "  FROM ina_file,inb_file,OUTER gem_file,", #FUN-C50004 mark
               #  " OUTER azf_file,OUTER ima_file ", #FUN-C50004 mark
                 "   FROM ina_file LEFT OUTER JOIN gem_file ON ina04 = gem01, ", #FUN-C50004 add
                 "        inb_file LEFT OUTER JOIN azf_file ON inb15 = azf01   ", #FUN-C50004 add
                 "                 LEFT OUTER JOIN ima_file ON ima01 = inb04 ", #FUN-C50004 add 
                 " WHERE ",tm.wc CLIPPED,
                 "   AND ina01=inb01 ",
                # "   AND ima_file.ima01=inb_file.inb04 ",#FUN-C50004 mark
               #  "   AND gem_file.gem01=ina_file.ina04 ", #FUN-C50004 mark
               #  "   AND azf_file.azf01=inb_file.inb15 ",  #6818 #FUN-C50004 mark
                 "   AND azf02='2'   ",  #6818 
                #"   AND inapost != 'X' ", #mandy #FUN-660079
                 "   AND inaconf != 'X' ", #FUN-660079
                 " ORDER BY ina01,inb03 "
 
     PREPARE armg300_prepare1 FROM l_sql #MOD-5A0029 aimg300->armg300
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80073    ADD
        CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
        EXIT PROGRAM
     END IF
     DECLARE armg300_curs1 CURSOR FOR armg300_prepare1 #MOD-5A0029 aimg300->armg300
 
#     CALL cl_outnam('armg300') RETURNING l_name #TQC-590053 aimg300-->armg300  #FUN-A50070 mark
#     START REPORT armg300_rep TO l_name #MOD-5A0029 aimg300->armg300           #FUN-A50070 mark
 
     LET g_pageno = 0
     FOREACH armg300_curs1 INTO sr.* #MOD-5A0029 aimg300->armg300 
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF cl_null(sr.inaprsw) THEN LET sr.inaprsw=0 END IF
       IF tm.a='1' AND sr.inaprsw = 0 THEN CONTINUE FOREACH END IF   #已列印
       IF tm.a='2' AND sr.inaprsw > 0 THEN CONTINUE FOREACH END IF   #未列印
       IF tm.b='1' AND sr.inapost !='Y' THEN CONTINUE FOREACH END IF   #已過帳
       IF tm.b='2' AND sr.inapost !='N' THEN CONTINUE FOREACH END IF   #未過帳
       IF cl_null(sr.inb09) THEN LET sr.inb09=0 END IF
       IF cl_null(sr.inb08_fac) THEN LET sr.inb08_fac=0 END IF
#FUN-A50070---begin
       LET l_x=sr.ina01[1,g_doc_len]         #No.FUN-550064                                                                          
       SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_x                                                                 
###GENGRE###       IF SQLCA.SQLCODE THEN LET l_smydesc='' END IF         
       #SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.inb15 AND azf02='2' #6818  #FUN-C50004 mark                                               
       EXECUTE insert_prep USING  sr.ina01,sr.ina00,l_smydesc,sr.ina04,sr.gem02,sr.ina02,
                                  sr.inb03,sr.inb04,sr.inb07,sr.inb05,sr.inb06,sr.inb08,sr.inb09,
                                  #sr.inb11,sr.ima02,sr.inb08_fac,sr.inb12,sr.inb15,g_buf,     #FUN-C40026 add , #FUN-C50004 mark
                                  sr.inb11,sr.ima02,sr.inb08_fac,sr.inb12,sr.inb15,sr.azf03, #FUN-C50004 add
                                  "",l_img_blob,"N",""                    #FUN-C40026 add
#       OUTPUT TO REPORT aimg300_rep(sr.*) #MOD-5A0029 aimg300->aimg300
#FUN-A50070---end       
     END FOREACH
     LET g_cr_table = l_table                 #FUN-C40026 add
     LET g_cr_apr_key_f = "ina01"             #FUN-C40026 add
     CALL cl_wcchp(tm.wc,'ina00,ina01,ina04,ina02') RETURNING tm.wc     #FUN-C40026 add
#     FINISH REPORT aimg300_rep #MOD-5A0029 aimg300->aimg300    #FUN-A50070
###GENGRE###      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED  #FUN-A50070
###GENGRE###      CALL cl_prt_cs3('armg300','armg300',l_sql,'')        #FUN-A50070
    CALL armg300_grdata()    ###GENGRE###
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #FUN-A50070 
 
    #No.FUN-BB0047--mark--Begin---
    #   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    #No.FUN-BB0047--mark--End-----
     # CALL cl_gre_drop_temptable(l_table) #FUN-C30085 mark
END FUNCTION
 
REPORT aimg300_rep(sr) #MOD-5A0029 aimg300->aimg300
   DEFINE l_last_sw    LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
          l_smydesc    LIKE smy_file.smydesc,
#         l_x          VARCHAR(03),
          l_x          LIKE type_file.chr5,    # Prog. Version..: '5.30.06-13.03.12(05),            #No.FUN-550064
          lc_inb04     LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40),            #No.FUN-670066
          sr        RECORD
                    ina00     LIKE ina_file.ina00,    #類別
                    ina01     LIKE ina_file.ina01,    #編號
                    ina02     LIKE ina_file.ina02,    #日期
                    ina04     LIKE ina_file.ina04,    #部門
                    gem02     LIKE gem_file.gem02,    #名稱
                    ina05     LIKE ina_file.ina05,    #原因
                    azf03     LIKE azf_file.azf03,    #說明
                    ina06     LIKE ina_file.ina06,    #專案
                    ina07     LIKE ina_file.ina07,    #備註
                    inb03     LIKE inb_file.inb03,    #項次
                    inb04     LIKE inb_file.inb04,    #料件
                    ima02     LIKE ima_file.ima02,    #品名
                    inb05     LIKE inb_file.inb05,    #倉庫
                    inb06     LIKE inb_file.inb06,    #儲位
                    inb07     LIKE inb_file.inb07,    #批號
                    inb08     LIKE inb_file.inb08,    #單位
                    inb08_fac LIKE inb_file.inb08_fac,#轉換率
                    inb09     LIKE inb_file.inb09,    #異動量
                    inb11     LIKE inb_file.inb11,    #來源單號
                    inb12     LIKE inb_file.inb12,    #參考單號
                    inb15     LIKE inb_file.inb15,
                    inaprsw   LIKE ina_file.inaprsw,  #列印
                    inapost   LIKE ina_file.inapost   #過帳
                    END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.ina00,sr.ina01,sr.inb03
  FORMAT
   PAGE HEADER
#No.FUN-670066 --Begin
#     PRINT (g_len-FGL_WIDTH(g_company))/2 SPACES,g_company
#     IF cl_null(g_towhom)
#        THEN PRINT '';
#        ELSE PRINT 'TO:',g_towhom;
#     END IF
#     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#   LET g_pageno = g_pageno + 1                     #FUN-670066 
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
#No.FUN-670066 --End
      CASE WHEN sr.ina00='1' LET g_x[1]=g_x[19]
           WHEN sr.ina00='2' LET g_x[1]=g_x[22]
           WHEN sr.ina00='3' LET g_x[1]=g_x[20]
           WHEN sr.ina00='4' LET g_x[1]=g_x[23]
           WHEN sr.ina00='5' LET g_x[1]=g_x[21]
           WHEN sr.ina00='6' LET g_x[1]=g_x[24]
      END CASE
#     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]        #No.FUN-670066
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]   #No.FUN-670066
      PRINT ' '
      LET g_pageno = g_pageno + 1
#     LET l_x=sr.ina01[1,3]
      LET l_x=sr.ina01[1,g_doc_len]         #No.FUN-550064
      SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=l_x
      IF SQLCA.SQLCODE THEN LET l_smydesc='' END IF
#     PRINT g_x[2] CLIPPED,g_pdate ,' ',TIME,                  #No.FUN-670066
#           COLUMN (g_len-FGL_WIDTH(l_smydesc))/2,l_smydesc,   #No.FUN-670066
#           COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'   #No.FUN-670066
      PRINT COLUMN (g_len-FGL_WIDTH(l_smydesc))/2,l_smydesc    #No.FUN-670066
      PRINT g_dash[1,g_len]
      PRINT g_x[11] CLIPPED,sr.ina01,COLUMN 37,g_x[12] CLIPPED,     #No.FUN-550064
            sr.ina04 CLIPPED,' ',sr.gem02
      PRINT g_x[14] CLIPPED,sr.ina02,COLUMN 37,g_x[15] CLIPPED,    #No.FUN-550064
            COLUMN 72,g_x[16] CLIPPED     #No.FUN-550064
#No.FUN-670066 --Begin
#     PRINT g_dash1_1[1,g_len]
#     PRINT g_x[17] CLIPPED,COLUMN 46,g_x[18] CLIPPED
#     PRINT '---- ------------------------------ -------- -------- ',
#           '---- ---------- ----------'
      PRINT g_dash2[1,g_len]
      PRINTX name = H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
      PRINTX name = H2 g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44]
      PRINTX name = H3 g_x[45],g_x[46]
      PRINT g_dash1
#No.FUN-670066 --End
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.ina01
      SKIP TO TOP OF PAGE
 
   ON EVERY ROW
#No.FUN-670066 --Begin
#     PRINT sr.inb03 USING '####';
#           COLUMN 06,sr.inb04 CLIPPED;
#     IF NOT cl_null(sr.inb07) THEN
#        PRINT '-',sr.inb07; END IF
#     PRINT COLUMN 37,sr.inb05 CLIPPED,
#           COLUMN 46,sr.inb06 CLIPPED,
#           COLUMN 55,sr.inb08,
#           COLUMN 59,sr.inb09 USING '####,###.&&',
#           COLUMN 71,sr.inb11
#     PRINT COLUMN 6,sr.ima02;
#     IF sr.inb08_fac>1 THEN
#        PRINT COLUMN 55,sr.inb08_fac USING '&.&&';
#     END IF
#     PRINT COLUMN 71,sr.inb12
#     SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.inb15 AND azf02='2' #6818
#     PRINT COLUMN 06,g_x[13] CLIPPED,
#           COLUMN 12,sr.inb15,
#           COLUMN 17,g_buf
      PRINTX name = D1 
         COLUMN g_c[31],sr.inb03 USING '####';
      IF NOT cl_null(sr.inb07) THEN
         LET lc_inb04 = sr.inb04 CLIPPED,'-',sr.inb07
         PRINTX name = D1 
            COLUMN g_c[32],lc_inb04 CLIPPED;
      ELSE
         PRINTX name = D1
            COLUMN g_c[32],sr.inb04 CLIPPED;
      END IF
      PRINTX name = D1
            COLUMN g_c[33],sr.inb05 CLIPPED,
            COLUMN g_c[34],sr.inb06 CLIPPED,
            COLUMN g_c[35],sr.inb08 CLIPPED,
         #  COLUMN g_c[36],cl_numfor(sr.inb09,36,g_azi03),
            COLUMN g_c[36],sr.inb09 CLIPPED USING '####,##&.&&',      #FUN-670066
            COLUMN g_c[37],sr.inb11 CLIPPED
      PRINTX name = D2
            COLUMN g_c[39],sr.ima02;
      IF sr.inb08_fac>1 THEN
         PRINTX name = D2
            COLUMN g_c[42],sr.inb08_fac USING '&&&.&&';
      END IF
      PRINTX name = D2
            COLUMN g_c[44],sr.inb12 CLIPPED
      SELECT azf03 INTO g_buf FROM azf_file WHERE azf01=sr.inb15 AND azf02='2' #6818
      LET lc_inb04 = g_x[13] CLIPPED,' ',sr.inb15 CLIPPED,' ',g_buf
      PRINTX name = D3
            COLUMN g_c[46],lc_inb04 CLIPPED
#No.FUN-670066 --End
 
   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash[1,g_len]                                                                                                         
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED  #FUN-670066
 
   PAGE TRAILER
#No.FUN-670066--Begin   
   IF l_last_sw = 'n' THEN
      PRINT g_dash[1,g_len] 
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED   
   ELSE 
      SKIP 2 LINE
   END IF
#  PRINT g_dash[1,g_len]
## FUN-550122
     # PRINT g_x[27] CLIPPED,'                    ',
     #       g_x[28] CLIPPED,'                    ',
     #       g_x[29] CLIPPED
#No.FUN-670066--End 
   IF l_last_sw = 'n' THEN
      IF g_memo_pagetrailer THEN
         PRINT g_x[27]
         PRINT g_memo
      ELSE
         PRINT
         PRINT
      END IF
   ELSE
      PRINT g_x[27]
      PRINT g_memo
   END IF
## END FUN-550122
 
END REPORT
#Patch....NO.TQC-610037 <001,002,003,004> #

###GENGRE###START
FUNCTION armg300_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
   
    LOCATE sr1.sign_img IN MEMORY    #FUN-C40026 add
    CALL cl_gre_init_apr()           #FUN-C40026 add
 
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("armg300")
        IF handler IS NOT NULL THEN
            START REPORT armg300_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY ina00,ina01,inb03" 
            DECLARE armg300_datacur1 CURSOR FROM l_sql
            FOREACH armg300_datacur1 INTO sr1.*
                OUTPUT TO REPORT armg300_rep(sr1.*)
            END FOREACH
            FINISH REPORT armg300_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT armg300_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lc_inb    STRING                  #FUN-B50018
    DEFINE l_lc_inb04  STRING                  #FUN-B50018
    DEFINE l_x1        STRING                  #FUN-B50018
    

    ORDER EXTERNAL BY sr1.ina01,sr1.inb03
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.ina01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B50018----add-----str-----------------
            LET l_lc_inb = '原因:',' ',sr1.inb15,' ',sr1.g_buf
            PRINTX l_lc_inb

            IF cl_null(sr1.inb07) OR sr1.inb07= ' ' THEN
               LET l_lc_inb04 = sr1.inb04
            ELSE 
               LET l_lc_inb04 = sr1.inb04,'-',sr1.inb07
            END IF
            PRINTX l_lc_inb04


            IF  sr1.ina00 != '1' AND  sr1.ina00 != '2' AND sr1.ina00 != '3' AND sr1.ina00 != '4' AND sr1.ina00 != '5' AND sr1.ina00 != '6' THEN
                LET l_x1 = ' '
            ELSE
                LET l_x1 =cl_gr_getmsg("gre-069",g_lang,sr1.ina00)
            END IF
            PRINTX l_x1
            #FUN-B50018----add-----end-----------------

            PRINTX sr1.*

        AFTER GROUP OF sr1.ina01

        
        ON LAST ROW

END REPORT
###GENGRE###END
