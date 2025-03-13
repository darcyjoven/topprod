# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: ammg210.4gl
# Desc/riptions..: 加工通知單列印
# Date & Author..: 00/12/16 By Chihming
# Modify.........: No.FUN-4C0099 05/02/03 By kim 報表轉XML功能
 # Modify.........: No.MOD-530775 05/03/28 By day 報表打印格式未對齊  
# Modify.........: No.FUN-550114 05/05/31 By echo 新增報表備註
# Modify.........: No.FUN-570174 05/07/18 By yoyo 項次欄位增大
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0087 06/11/16 By king 改正報表中有關錯誤
# Modify.........: No.FUN-710091 07/02/15 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730113 07/04/02 By Nicole 增加CR參數
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-930113 09/03/18 By mike 將oah_file-->pnz_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50018 11/05/20 By xumm CR轉GRW
# Modify.........: No.FUN-B80065 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B50018 11/08/11 By xumm 程式規範修改
# Modify.........: No:FUN-C40026 12/04/10 By xumm GR動態簽核
# Modify.........: No.FUN-C50008 12/05/14 By wangrr GR程式優化
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD		  	              # Print condition RECORD
       	    	wc     	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(600)# Where condition
                a       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
   		more	LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
              END RECORD,
          g_zo          RECORD LIKE zo_file.*
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680100 SMALLINT
#No.FUN-710091  --begin
DEFINE   g_sql     STRING
DEFINE   g_str     STRING
DEFINE   l_table   STRING
#No.FUN-710091  --end  
###GENGRE###START
TYPE sr1_t RECORD
    mmg10 LIKE mmg_file.mmg10,
    mme01 LIKE mme_file.mme01,
    mme02 LIKE mme_file.mme02,
    mme03 LIKE mme_file.mme03,
    mme10 LIKE mme_file.mme10,
    mme14 LIKE mme_file.mme14,
    mmeprno LIKE mme_file.mmeprno,
    mmf02 LIKE mmf_file.mmf02,
    mmf03 LIKE mmf_file.mmf03,
    mmf04 LIKE mmf_file.mmf04,
    mmf05 LIKE mmf_file.mmf05,
    mmf06 LIKE mmf_file.mmf06,
    mmf07 LIKE mmf_file.mmf07,
    mmf09 LIKE mmf_file.mmf09,
    mmf10 LIKE mmf_file.mmf10,
    mmf11 LIKE mmf_file.mmf11,
    mmf12 LIKE mmf_file.mmf12,
    mmf13 LIKE mmf_file.mmf13,
    mmf14 LIKE mmf_file.mmf14,
    mmf15 LIKE mmf_file.mmf15,
    mmf031 LIKE mmf_file.mmf031,
    mmf091 LIKE mmf_file.mmf091,
    mmf111 LIKE mmf_file.mmf111,
    pmc081 LIKE pmc_file.pmc081,
    pmc091 LIKE pmc_file.pmc081,
    gec02 LIKE gec_file.gec02,
    azi02 LIKE azi_file.azi02,
    pma02 LIKE pma_file.pma02,
    oah02 LIKE oah_file.oah02,
    l_Amount  LIKE mmg_file.mmg10,        #FUN-B50018 add
    l_Amount1 LIKE mmg_file.mmg10,        #FUN-B50018 add
    zo041 LIKE zo_file.zo041,
    zo042 LIKE zo_file.zo042,
    zo05 LIKE zo_file.zo05,
    zo09 LIKE zo_file.zo09,
    azi03 LIKE azi_file.azi03,
    azi05 LIKE azi_file.azi05,           #FUN-C40026 add,
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
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   #No.FUN-710091  --begin
   LET g_sql ="mmg10.mmg_file.mmg10,",
              "mme01.mme_file.mme01,",
              "mme02.mme_file.mme02,",
              "mme03.mme_file.mme03,",
              "mme10.mme_file.mme10,",
              "mme14.mme_file.mme14,",
              "mmeprno.mme_file.mmeprno,",
              "mmf02.mmf_file.mmf02,",
              "mmf03.mmf_file.mmf03,",
              "mmf04.mmf_file.mmf04,",
              "mmf05.mmf_file.mmf05,",
              "mmf06.mmf_file.mmf06,",
              "mmf07.mmf_file.mmf07,",
              "mmf09.mmf_file.mmf09,",
              "mmf10.mmf_file.mmf10,",
              "mmf11.mmf_file.mmf11,",
              "mmf12.mmf_file.mmf12,",
              "mmf13.mmf_file.mmf13,",
              "mmf14.mmf_file.mmf14,",
              "mmf15.mmf_file.mmf15,",
              "mmf031.mmf_file.mmf031,",
              "mmf091.mmf_file.mmf091,",
              "mmf111.mmf_file.mmf111,",
              "pmc081.pmc_file.pmc081,",
              "pmc091.pmc_file.pmc081,",
              "gec02.gec_file.gec02,",
              "azi02.azi_file.azi02,",
              "pma02.pma_file.pma02,",
              "oah02.oah_file.oah02,",
              "l_Amount.mmg_file.mmg10,",       #FUN-B50018 add
              "l_Amount1.mmg_file.mmg10,",      #FUN-B50018 add
              "zo041.zo_file.zo041,",
              "zo042.zo_file.zo042,",
              "zo05.zo_file.zo05,",
              "zo09.zo_file.zo09,",
              "azi03.azi_file.azi03,",
              "azi05.azi_file.azi05,",          #FUN-C40026 add 2,
              #FUN-C40026----add---str----
              "sign_type.type_file.chr1,",  #簽核方式
              "sign_img.type_file.blob,",   #簽核圖檔
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000"
              #FUN-C40026----add---end----
   LET l_table = cl_prt_temptable('ammg210',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   #No.FUN-710091  --end  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80065--add--
   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g210_tm(0,0)		# Input print condition
      ELSE CALL ammg210()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
   CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
END MAIN
 
FUNCTION g210_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col	LIKE type_file.num5,          #No.FUN-680100 SMALLINT
          l_cmd		LIKE type_file.chr1000        #No.FUN-680100 VARCHAR(600)
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 16 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 7 LET p_col = 18
   ELSE LET p_row = 4 LET p_col = 16
   END IF
 
   OPEN WINDOW g210_w AT p_row,p_col
        WITH FORM "amm/42f/ammg210" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a    = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON mme01,mme03,mme02 
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
LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('mmeuser', 'mmegrup') #FUN-980030
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW g210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
   INPUT BY NAME tm.a,tm.more WITHOUT DEFAULTS 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF cl_null(tm.a) THEN LET tm.a='N' END IF           
         IF cl_null(tm.a) OR tm.a NOT MATCHES "[YN]" THEN
            NEXT FIELD a
         END IF
      AFTER FIELD more
         IF cl_null(tm.more) THEN LET tm.more='N' END IF
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
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
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW g210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='ammg210'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ammg210','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.a CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('ammg210',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW g210_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
      CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ammg210()
   ERROR ""
END WHILE
   CLOSE WINDOW g210_w
END FUNCTION
 
FUNCTION ammg210()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name        #No.FUN-680100 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0076
          l_sql 	STRING,		# RDSQL STATEMENT        #No.FUN-680100
          l_chr		LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_za05	LIKE type_file.chr1000,       #No.FUN-680100 VARCHAR(40)
          sr   RECORD 
                     mmg10     LIKE mmg_file.mmg10,    #採購單號
                     mme01     LIKE mme_file.mme01,    #採購單號
                     mme02     LIKE mme_file.mme02,    #採購單號
                     mme03     LIKE mme_file.mme03,    #採購單號
                     mme10     LIKE mme_file.mme10,    #採購單號
                     mme14     LIKE mme_file.mme14,    #採購單號
                     mmeprno   LIKE mme_file.mmeprno,    #採購單號
                     mmf02     LIKE mmf_file.mmf02,    #採購單號
                     mmf03     LIKE mmf_file.mmf03,    #採購單號
                     mmf04     LIKE mmf_file.mmf04,    #採購單號
                     mmf05     LIKE mmf_file.mmf05,    #採購單號
                     mmf06     LIKE mmf_file.mmf06,    #採購單號
                     mmf07     LIKE mmf_file.mmf07,    #採購單號
                     mmf09     LIKE mmf_file.mmf09,    #採購單號
                     mmf10     LIKE mmf_file.mmf10,    #採購單號
                     mmf11     LIKE mmf_file.mmf11,    #採購單號
                     mmf12     LIKE mmf_file.mmf12,    #採購單號
                     mmf13     LIKE mmf_file.mmf13,    #採購單號
                     mmf14     LIKE mmf_file.mmf14,    #採購單號
                     mmf15     LIKE mmf_file.mmf15,    #採購單號 Jason 010208 
                     mmf031    LIKE mmf_file.mmf031,   #採購單號
                     mmf091    LIKE mmf_file.mmf091,   #採購單號
                     mmf111    LIKE mmf_file.mmf111,   #採購單號
                     pmc081    LIKE pmc_file.pmc081,   #供應商全名
                     pmc091    LIKE pmc_file.pmc081,   #供應商地址
                     gec02     LIKE gec_file.gec02,    #稅別
                     azi02     LIKE azi_file.azi02,    
                     pma02     LIKE pma_file.pma02,    #項次
                     pnz02     LIKE pnz_file.pnz02    #價格條件說明 #FUN-930113
                     ,l_Amount LIKE mmg_file.mmg10,    #FUN-B50018 add
                     l_Amount1 LIKE mmg_file.mmg10     #FUN-B50018 add
        END RECORD
  DEFINE l_img_blob       LIKE type_file.blob  #FUN-C40026 add
       #No.FUN-B80065--mark--Begin--- 
       #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
       #No.FUN-B80065--mark--End-----
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-710091  --begin
     LOCATE l_img_blob      IN MEMORY            #FUN-C40026 add
     CALL cl_del_data(l_table)
     LET l_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  #TQC-780049
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"               #FUN-B50018  add 2?    #FUN-C40026 add 4?
     PREPARE insert_prep FROM l_sql
     IF STATUS THEN 
        CALL cl_err("insert_prep:",STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
        EXIT PROGRAM
     END IF
     #No.FUN-710091  --end  
     #mark數量不從庫存取  by chien 01/04/16
   # LET l_sql = "SELECT mmg10,mme01,mme02,mme03,mme10,mme14,mmeprno,",
     LET l_sql = "SELECT mmf10,mme01,mme02,mme03,mme10,mme14,mmeprno,",
                 "       mmf02,mmf03,mmf04,mmf05,mmf06,mmf07,mmf09,mmf10,",
                 "       mmf11,mmf12,mmf13,mmf14,mmf15,mmf031,mmf091,mmf111,",
                 "       pmc081,pmc091,gec02,azi02,pma02,pnz02,'','' ", #FUN-930113  oah-->pnz    #FUN-B50018 add'',''
                # " FROM mme_file , mmf_file , OUTER pmc_file, OUTER gec_file ,",  #FUN-C50008 mark--
                # "       OUTER azi_file , OUTER pma_file , OUTER pnz_file ", #FUN-930113  oah-->pnz  #FUN-C50008 mark--
                #FUN-C50008--add--str ADD LEFT OUTER
                 " FROM mmf_file,mme_file LEFT OUTER JOIN pmc_file ON (pmc01=mme03) ",
                 "      LEFT OUTER JOIN gec_file ON (gec01=mme11) ",
                 "      LEFT OUTER JOIN azi_file ON (azi01=mme12) ",
                 "      LEFT OUTER JOIN pma_file ON (pma01=mme10) ",
                 "      LEFT OUTER JOIN pnz_file ON (pnz01=mme14) ",
                #FUN-C50008--add--end         
                 " WHERE mmf01 = mme01 ",
                #FUN-C50008--mark--str 
                # "   AND pmc_file.pmc01 = mme_file.mme03 ",
                # "   AND gec_file.gec01 = mme_file.mme11 ",
                # "   AND azi_file.azi01 = mme_file.mme12 ",
                # "   AND pma_file.pma01 = mme_file.mme10 ",
                # "   AND pnz_file.pnz01 = mme14 ", #FUN-930113  oah-->pnz
                #FUN-C50008--mark--end
             #   "   AND mmg04 = mmf03 ",
                 "   AND ",tm.wc CLIPPED 
    IF tm.a='N' THEN LET l_sql=l_sql CLIPPED," AND mmeprno = 0 " 
    END IF
 
     PREPARE g210_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80065--add--
        CALL cl_gre_drop_temptable(l_table)              #FUN-B50018  add
        EXIT PROGRAM 
     END IF
     DECLARE g210_cs1 CURSOR FOR g210_prepare1
     SELECT * INTO g_zo.* FROM zo_file WHERE zo01=g_rlang
    #LET l_name = 'ammg210.out'   #No.FUN-710091
    #CALL cl_outnam('ammg210') RETURNING l_name  #No.FUN-710091
    #START REPORT g210_rep TO l_name  #No.FUN-710091
     LET g_pageno = 0
     FOREACH g210_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN 
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH 
       END IF
       SELECT pmc081,pmc091 INTO sr.pmc081,sr.pmc091
           FROM pmc_file WHERE pmc01 = sr.mme03
       IF STATUS THEN
          SELECT gem02,gem03 INTO sr.pmc081,sr.pmc091 FROM gem_file
          WHERE gem01 = sr.mme03
           IF STATUS THEN 
#           CALL cl_err(sr.mme03,'mme1216',1) #No.FUN-660094
            CALL cl_err3("sel","gem_file",sr.mme03,"","mme1216","","",1)        #NO.FUN-660094 
           END IF
       END IF 
       LET  sr.l_Amount = sr.mmg10 * sr.mmf12          #FUN-B50018 add 
       LET  sr.l_Amount1 = sr.mmg10 * sr.mmf13         #FUN-B50018 add 
      #OUTPUT TO REPORT g210_rep(sr.*)  #No.FUN-710091
       #EXECUTE insert_prep USING sr.*,g_zo.zo041,g_zo.zo042,g_zo.zo05,g_zo.zo09,g_azi03,g_azi05 #No.FUN-710091         #FUN-C40026 mark
       EXECUTE insert_prep USING sr.*,g_zo.zo041,g_zo.zo042,g_zo.zo05,g_zo.zo09,g_azi03,g_azi05,"",l_img_blob,"N",""    #FUN-C40026 add
     END FOREACH
     LET g_cr_table = l_table                 #FUN-C40026 add
     LET g_cr_apr_key_f = "mme01"             #FUN-C40026 add
     #No.FUN-710091  --begin
   # LET g_sql ="SELECT * FROM ",l_table CLIPPED   #TQC-730113
###GENGRE###     LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'mme01,mme03,mme02')  RETURNING  tm.wc
###GENGRE###     LET g_str = tm.wc
   # CALL cl_prt_cs3("ammg210",g_sql,g_str)        #TQC-730113
###GENGRE###     CALL cl_prt_cs3('ammg210','ammg210',g_sql,g_str)
    CALL ammg210_grdata()    ###GENGRE###
     #No.FUN-710091  --end  
 
    #FINISH REPORT g210_rep  #No.FUN-710091
 
    #CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-710091
       #No.FUN-B80065--mark--Begin---
       #CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
       #No.FUN-B80065--mark--End-----
       CALL cl_gre_drop_temptable(l_table)
END FUNCTION
#No.FUN-710091  --begin
#REPORT g210_rep(sr)
#   DEFINE l_last_sw	LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
#          l_dash        LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
#          l_count       LIKE type_file.num5,          #No.FUN-680100 SMALLINT
#          l_n           LIKE type_file.num5,          #No.FUN-680100 SMALLINT
#          sr   RECORD 
#                     mmg10     LIKE mmg_file.mmg10,    #採購單號
#                     mme01     LIKE mme_file.mme01,    #採購單號
#                     mme02     LIKE mme_file.mme02,    #採購單號
#                     mme03     LIKE mme_file.mme03,    #採購單號
#                     mme10     LIKE mme_file.mme10,    #採購單號
#                     mme14     LIKE mme_file.mme14,    #採購單號
#                     mmeprno   LIKE mme_file.mmeprno,  #採購單號
#                     mmf02     LIKE mmf_file.mmf02,    #採購單號
#                     mmf03     LIKE mmf_file.mmf03,    #採購單號
#                     mmf04     LIKE mmf_file.mmf04,    #採購單號
#                     mmf05     LIKE mmf_file.mmf05,    #採購單號
#                     mmf06     LIKE mmf_file.mmf06,    #採購單號
#                     mmf07     LIKE mmf_file.mmf07,    #採購單號
#                     mmf09     LIKE mmf_file.mmf09,    #採購單號
#                     mmf10     LIKE mmf_file.mmf10,    #採購單號
#                     mmf11     LIKE mmf_file.mmf11,    #採購單號
#                     mmf12     LIKE mmf_file.mmf12,    #採購單號
#                     mmf13     LIKE mmf_file.mmf13,    #採購單號
#                     mmf14     LIKE mmf_file.mmf14,    #採購單號
#                     mmf15     LIKE mmf_file.mmf15,    #採購單號 Jason 010208
#                     mmf031    LIKE mmf_file.mmf031,   #採購單號
#                     mmf091    LIKE mmf_file.mmf091,   #採購單號
#                     mmf111    LIKE mmf_file.mmf111,   #採購單號
#                     pmc081    LIKE pmc_file.pmc081,   #供應商全名
#                     pmc091    LIKE pmc_file.pmc081,   #供應商地址
#                     gec02     LIKE gec_file.gec02,    #稅別
#                     azi02     LIKE azi_file.azi02,    
#                     pma02     LIKE pma_file.pma02,    #項次
#                     oah02     LIKE oah_file.oah02    #價格條件說明
#        END RECORD,
#        l_flag       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
#        l_str        LIKE type_file.chr50,         #No.FUN-680100 VARCHAR(40)
#        l_mmc02    LIKE mmc_file.mmc02,                #Jason 010208
#        l_amt      LIKE mme_file.mme13,
#        l_whr      LIKE mme_file.mme13,
#        l_acti     LIKE mmf_file.mmfacti
#   
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 6
#         PAGE LENGTH g_page_line
#  ORDER BY sr.mme01,sr.mmf02
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED #No.TQC-6A0087 add CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_zo.zo041 CLIPPED))/2 SPACES,g_zo.zo041 CLIPPED #No.TQC-6A0087 add CLIPPED
#      PRINT (g_len-FGL_WIDTH(g_zo.zo042 CLIPPED))/2 SPACES,g_zo.zo042 CLIPPED #No.TQC-6A0087 add CLIPPED
#      LET l_str=g_x[17] CLIPPED,g_zo.zo05,' ',g_x[18] CLIPPED,g_zo.zo09
#      PRINT (g_len-FGL_WIDTH(l_str CLIPPED))/2 SPACES,l_str CLIPPED #No.TQC-6A0087 add CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED #No.TQC-6A0087 add CLIPPED
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT 
#      PRINT g_x[9] CLIPPED,sr.mme01
#      PRINT g_x[10] CLIPPED,sr.mme02
#      PRINT g_x[11] CLIPPED,sr.mme03,COLUMN 25,sr.pmc081
#      PRINT COLUMN 25,sr.pmc091
#      PRINT g_x[14] CLIPPED,sr.gec02,COLUMN 55,g_x[12] CLIPPED,sr.mme10,
#            COLUMN 75, sr.pma02
#      PRINT g_x[15] CLIPPED,sr.azi02,COLUMN 55,g_x[13] CLIPPED,sr.mme14,
#            COLUMN 75,sr.oah02
#      PRINT g_dash
# #No.MOD-530775--begin
#      PRINT  g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#             g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#             g_x[41],g_x[43],g_x[44],g_x[45]
# #No.MOD-530775--end
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#      UPDATE mme_file SET mmeprno=sr.mmeprno+1 where mme01=sr.mme01
#
#BEFORE GROUP OF sr.mme01
#      SKIP TO TOP OF PAGE
#      LET l_amt = 0 LET l_whr = 0 LET l_flag = 'N'
#
#ON EVERY ROW
#      SELECT mmfacti INTO l_acti FROM mmf_file WHERE mmf01=sr.mme01 
#                                                 AND mmf02=sr.mmf02
#      IF SQLCA.sqlcode THEN LET l_acti = ' ' END IF
#      PRINT COLUMN g_c[31],sr.mmf02 USING '####',                         #No.FUN-570174
#            COLUMN g_c[32],sr.mmf03,
#            COLUMN g_c[33],cl_numfor(sr.mmf10,33,2),
#            COLUMN g_c[34],cl_numfor(sr.mmf12,34,g_azi03),
#            COLUMN g_c[35],sr.mmf05,
#            COLUMN g_c[36],sr.mmf09,
# #No.MOD-530775--begin
#            COLUMN g_c[37],sr.mmf091;
#{      IF l_acti='X' THEN
#         PRINT COLUMN g_c[32],'*';
#      ELSE PRINT ' '; 
#      END IF
#}
# #No.MOD-530775--end
#      SELECT mmc02 INTO l_mmc02 FROM mmc_file WHERE             #Jason 010208
#            mmc01 = sr.mmf15
#      IF SQLCA.sqlcode THEN LET l_mmc02 = ' '  END IF
#      PRINT COLUMN g_c[43],sr.mmf11,
#            COLUMN g_c[44],cl_numfor(sr.mmf13,44,2),
#            COLUMN g_c[45],sr.mmf15 CLIPPED,' ',l_mmc02 
#
#AFTER GROUP OF sr.mmf02
#      PRINT g_dash2
#
#AFTER GROUP OF sr.mme01
#      LET l_amt = GROUP SUM(sr.mmg10*sr.mmf12)
#      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
#      LET l_whr = GROUP SUM(sr.mmg10*sr.mmf13)
#      IF cl_null(l_whr) THEN LET l_whr = 0 END IF
#      
#      PRINT ''
# #No.MOD-530775--begin
#      PRINT COLUMN 06,g_x[16] CLIPPED,cl_numfor(l_amt,16,g_azi05)
#      PRINT COLUMN 06,g_x[22] CLIPPED,cl_numfor(l_whr,16,2);                    
#      PRINT COLUMN 42,g_x[23] CLIPPED  
# #No.MOD-530775--end
#      PRINT g_dash[1,g_len]
##     LET g_pageno=0
#      LET l_flag='Y'
#  
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT g_dash
#      IF l_last_sw = 'n'
#         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#      END IF
### FUN-550114
#     #IF l_flag= 'Y' THEN
#     #   PRINT COLUMN 01,g_x[19] CLIPPED,
#     #         COLUMN 42,g_x[20] CLIPPED,
#     #         COLUMN 62,g_x[21] CLIPPED
#     #   SKIP 1 LINE
#     #ELSE
#     #  SKIP 2 LINE
#     #END IF
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[19]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[19]
#            PRINT g_memo
#     END IF
### END FUN-550114
#END REPORT
#No.FUN-710091  --end  
 

###GENGRE###START
FUNCTION ammg210_grdata()
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
        LET handler = cl_gre_outnam("ammg210")
        IF handler IS NOT NULL THEN
            START REPORT ammg210_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," ORDER BY mme01,mmf02"  #FUN-B50018
          
            DECLARE ammg210_datacur1 CURSOR FROM l_sql
            FOREACH ammg210_datacur1 INTO sr1.*
                OUTPUT TO REPORT ammg210_rep(sr1.*)
            END FOREACH
            FINISH REPORT ammg210_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT ammg210_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B50018----add-----end-----------------
    DEFINE l_AmountDisplay   LIKE mmg_file.mmg10
    DEFINE l_AmountDisplay1   LIKE mmg_file.mmg10
    DEFINE l_mmf12_fmt         STRING
    DEFINE l_AmountDisplay_fmt STRING
    #FUN-B50018----add-----str-----------------    
    ORDER EXTERNAL BY sr1.mme01,sr1.mmf02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.mme01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.mmf02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            LET l_mmf12_fmt = cl_gr_numfmt('mmf_file','mmf12',g_azi03)    #FUN-B50018 add
            PRINTX l_mmf12_fmt                                            #FUN-B50018 add
            PRINTX l_lineno
             
            PRINTX sr1.*

        AFTER GROUP OF sr1.mme01

            #FUN-B50018----add-----end-----------------
            LET    l_AmountDisplay = GROUP SUM(sr1.l_Amount)
            PRINTX l_AmountDisplay

            LET    l_AmountDisplay1 = GROUP SUM(sr1.l_Amount1)
            PRINTX l_AmountDisplay1

            LET    l_AmountDisplay_fmt = cl_gr_numfmt('mmg_file','mmg10',g_azi05)
            PRINTX l_AmountDisplay_fmt
            #FUN-B50018----add-----str-----------------

        AFTER GROUP OF sr1.mmf02

        
        ON LAST ROW

END REPORT
###GENGRE###END
