# Prog. Version..: '5.30.06-13.03.18(00004)'     #
#
# Pattern name...: afag600.4gl
# Descriptions...: 固定資產盤點卡列印作業
# Date & Author..: 96/05/07 By Sophia
# Modify.........: No.FUN-550102 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-580098 05/10/26 By CoCo BOTTOM MARGIN 0改5
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0085 06/11/08 By ice 修正報表格式錯誤
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 語言功能無效
# Modify.........: No.FUN-710083 07/01/30 By Ray Crystal Report修改
# Modify.........: No.TQC-730088 07/03/25 By Nicole 增加CR參數
# Modify.........: No.TQC-760094 07/06/12 By Sarah 增加以fca02排序
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/09 By vealxu 增加"族群"之欄位fca21
# Modify.........: No.FUN-B40097 11/06/10 By chenying 憑證類CR轉GR
# Modify.........: No.FUN-B40097 11/08/17 By chenying 程式規範修改
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-CC0093 12/12/20 By wangrr GR程式修改
# Modify.........: No.FUN-D10098 13/02/01 By lujh FUN-CC0093 還原
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD	       		# Print condition RECORD
              stk       LIKE type_file.chr20,        # 盤點編號       #No.FUN-680070 VARCHAR(10)
              bno       LIKE type_file.num5,         # 起始號碼       #No.FUN-680070 SMALLINT
              eno       LIKE type_file.num5,         # 截止號碼       #No.FUN-680070 SMALLINT
       	      size  	LIKE type_file.chr1,         # 是否套版列印       #No.FUN-680070 VARCHAR(01)
              more	LIKE type_file.chr1  	        # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
#FUN-B40097---add----str-----------
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
TYPE sr1_t RECORD
           fca01_fca02 LIKE fca_file.fca01,
           fca01  LIKE fca_file.fca01,      
           fca02  LIKE fca_file.fca02,      
           faj04  LIKE faj_file.faj04,      
           fab02  LIKE fab_file.fab02,      
           fca03  LIKE fca_file.fca03,      
           fca031 LIKE fca_file.fca031,     
           fca04  LIKE fca_file.fca04,      
           faj06  LIKE faj_file.faj06,      
           faj07  LIKE faj_file.faj07,      
           faj08  LIKE faj_file.faj08,      
           fca09  LIKE fca_file.fca09,      
           fca05  LIKE fca_file.fca05,      
           gem02  LIKE gem_file.gem02,      
           fca06  LIKE fca_file.fca06,      
           gen02  LIKE gen_file.gen02,      
           fca07  LIKE fca_file.fca07,      
           fca21  LIKE fca_file.fca21,
           sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
           sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
           sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
           sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
           END RECORD
#FUN-B40097---add----end-----------
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
 
 
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.stk = ARG_VAL(7)
   LET tm.bno = ARG_VAL(8)
   LET tm.eno = ARG_VAL(9)
   LET tm.size = ARG_VAL(10)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---

   #FUN-B40097-----add---str------------
   LET g_sql = "fca01_fca02.fca_file.fca01,",      
               "fca01.fca_file.fca01,",      
               "fca02.fca_file.fca02,",      
               "faj04.faj_file.faj04,",     
               "fab02.fab_file.fab02,",      
               "fca03.fca_file.fca03,",      
               "fca031.fca_file.fca031,",     
               "fca04.fca_file.fca04,",      
               "faj06.faj_file.faj06,",      
               "faj07.faj_file.faj07,",      
               "faj08.faj_file.faj08,",      
               "fca09.fca_file.fca09,",      
               "fca05.fca_file.fca05,",      
               "gem02.gem_file.gem02,",      
               "fca06.fca_file.fca06,",      
               "gen02.gen_file.gen02,",      
               "fca07.fca_file.fca07,",      
               "fca21.fca_file.fca21,",
               "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
               "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('afag600',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM 
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "?,?,?,?,      ?,?,?,?,?, ?,?,? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-B40097
      CALL cl_gre_drop_temptable(l_table)    #FUN-B40097
      EXIT PROGRAM
   END IF
 
   #FUN-B40097-----add---end------------


   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g600_tm(0,0)		# Input print condition
      ELSE CALL g600()		# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
   CALL cl_gre_drop_temptable(l_table)
END MAIN
 
FUNCTION g600_tm(p_row,p_col)
   DEFINE   p_row,p_col	      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_direct,l_flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
            l_eno             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cnt             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd	      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 5 LET p_col = 20
 
   OPEN WINDOW g600_w AT p_row,p_col WITH FORM "afa/42f/afag600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.bno  = 0
   LET tm.size = 'N'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      INPUT BY NAME tm.stk,tm.bno,tm.eno,tm.size,tm.more WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
          CALL cl_dynamic_locale()                  #No.TQC-6C0009 取消mark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET g_action_choice = "locale"            #No.TQC-6C0009 mark
 
 
 
         AFTER FIELD stk
            IF cl_null(tm.stk)  THEN
               NEXT FIELD stk
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM fca_file WHERE fca01 = tm.stk
               IF l_cnt = 0 THEN
                  CALL cl_err(tm.stk,'afa-032',0)
                  NEXT FIELD stk
               END IF
               LET tm.eno = l_cnt
               DISPLAY BY NAME tm.eno
            END IF
 
      #   96-06-10 Modify by Lynn 起始盤點序號不可空白
         AFTER FIELD bno
            IF cl_null(tm.bno) THEN
               NEXT FIELD bno
            END IF
 
         BEFORE FIELD eno
            CALL cl_err('eno','afa-031',0)
 
         AFTER FIELD eno
            IF tm.eno IS NOT NULL AND tm.eno < tm.bno  THEN
               CALL cl_err('','afa-033',0)
               NEXT FIELD eno
            ELSE
           #   CALL cl_err('eno','afa-031',0)
      #   96-06-10 Modify by Lynn 截止盤點序號如為null ,為此盤點編號 max(序號)
               IF tm.eno IS NULL THEN
                  SELECT max(fca02) INTO l_eno FROM fca_file WHERE fca01 = tm.stk
                  LET tm.eno = l_eno
                  DISPLAY BY NAME tm.eno
               END IF
            END IF
            LET l_direct = 'D'
 
         AFTER FIELD size
            IF cl_null(tm.size) OR tm.size NOT MATCHES "[YN]" THEN
               NEXT FIELD size
            END IF
            LET l_direct ='U'
 
         AFTER FIELD more
            IF cl_null(tm.more) OR tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            LET l_flag = 'N'
            IF tm.stk IS NULL OR tm.stk =' ' THEN
               LET l_flag = 'Y'
               DISPLAY BY NAME tm.stk
            END IF
            IF l_flag='Y' THEN
               CALL cl_err('','9033',0)
               NEXT FIELD stk
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
    
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      #FUN-CC0093--add--str--
    ON ACTION CONTROLP
       CASE
          WHEN INFIELD(stk)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_fca"
             LET g_qryparam.state = "i"
             CALL cl_create_qry() RETURNING tm.stk
             DISPLAY tm.stk TO stk
             NEXT FIELD stk
       END CASE
    #FUN-CC0093--add--end
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afag600'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afag600','9031',1)
         ELSE
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.stk CLIPPED,"'",
                            " '",tm.bno CLIPPED,"'",
                            " '",tm.eno CLIPPED,"'",
                            " '",tm.size CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afag600',g_time,l_cmd)
         END IF
         CLOSE WINDOW g600_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         CALL cl_gre_drop_temptable(l_table)
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g600()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW g600_w
END FUNCTION
 
FUNCTION g600()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
          l_stkbno  LIKE fca_file.fca02,
          l_stkeno  LIKE fca_file.fca02,
          sr        RECORD
                    fca01_fca02 LIKE fca_file.fca01, #FUN-B40097 add
                    fca01  LIKE fca_file.fca01,     #盤點編號
                    fca02  LIKE fca_file.fca02,     #盤點序號
                    faj04  LIKE faj_file.faj04,     #資產類別
                    fab02  LIKE fab_file.fab02,     #類別名稱
                    fca03  LIKE fca_file.fca03,     #財產編號
                    fca031 LIKE fca_file.fca031,    #財產附號
                    fca04  LIKE fca_file.fca04,     #序號
                    faj06  LIKE faj_file.faj06,     #中文名稱
                    faj07  LIKE faj_file.faj07,     #英文名稱
                    faj08  LIKE faj_file.faj08,     #規格型號
                    fca09  LIKE fca_file.fca09,     #數量
                    fca05  LIKE fca_file.fca05,     #保管部門
                    gem02  LIKE gem_file.gem02,     #部門名稱
                    fca06  LIKE fca_file.fca06,     #保管人
                    gen02  LIKE gen_file.gen02,     #保管人名稱
                    fca07  LIKE fca_file.fca07      #存放位置
                   ,fca21  LIKE fca_file.fca21      #FUN-9A0036 add fca21 
                    END RECORD
     DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
     LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add
     CALL cl_del_data(l_table)    #FUN-B40097 add 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afag600'
#No.FUN-710083 --begin
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#No.FUN-710083 --end
     LET l_sql = " SELECT '',fca01,fca02,faj04,fab02,fca03,fca031,",   #FUN-B40097 add ''
                 "        fca04,faj06,faj07,faj08,fca09,fca05,",
                 "        gem02,fca06,gen02,fca07,fca21",                #FUN-9A0036 add fca21
"   FROM fca_file ",
"LEFT OUTER JOIN gem_file ON fca05  = gem01 ",
"LEFT OUTER JOIN gen_file ON fca06  = gen01 , ",
"faj_file LEFT OUTER JOIN fab_file ON faj04  = fab01 ",
"  WHERE fca03  = faj02 ",
"    AND fca031 = faj022", 
                 "    AND fca01  = '",tm.stk,"'",
                 "    AND fca02 BETWEEN ",tm.bno," AND ",tm.eno,"",
                 " ORDER BY fca01,fca02"   #TQC-760094 add fca02
 
     PREPARE g600_prepare FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
           
     END IF
     DECLARE g600_cs CURSOR FOR g600_prepare
#No.FUN-710083 --begin
   # CALL cl_prt_cs1('afag600',l_sql,'')             #TQC-730088
   # CALL cl_prt_cs1('afag600','afag600',l_sql,'')   #FUN-B40097 mark
#    CALL cl_outnam('afag600') RETURNING l_name
 
#    START REPORT g600_rep TO l_name
#    LET g_pageno = 0
      
     FOREACH g600_cs INTO sr.*                                   #FUN-B40097 remark
       IF SQLCA.sqlcode != 0 THEN                                #FUN-B40097 remark  
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH   #FUN-B40097 remark
       END IF                                                    #FUN-B40097 remark
       LET sr.fca01_fca02 = sr.fca01,sr.fca02                 #FUN-B40097 add 
       EXECUTE insert_prep USING sr.*  ,"",  l_img_blob,"N",""  # No.FUN-C40020 add                          #FUN-B40097 add 
#      OUTPUT TO REPORT g600_rep(sr.*)
     END FOREACH                                                 #FUN-B40097 remark  
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "fca01"          # No.FUN-C40020 add
     CALL afag600_grdata()                                       #FUN-B40097 add 
#    FINISH REPORT g600_rep
 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
#No.FUN-710083 --end
END FUNCTION

#FUN-B40097----add----str-------------
FUNCTION afag600_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF
    LOCATE sr1.sign_img IN MEMORY      # No.FUN-C40020 add
    CALL cl_gre_init_apr()             # No.FUN-C40020 add

    WHILE TRUE
        CALL cl_gre_init_pageheader()
        LET handler = cl_gre_outnam("afag600")
        IF handler IS NOT NULL THEN
            START REPORT afag600_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY fca01,fca02"
                 
            DECLARE afag600_datacur1 CURSOR FROM l_sql
            FOREACH afag600_datacur1 INTO sr1.*
                OUTPUT TO REPORT afag600_rep(sr1.*)
            END FOREACH
            FINISH REPORT afag600_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report() 
END FUNCTION

REPORT afag600_rep(sr1)
   DEFINE sr1 sr1_t
   DEFINE l_lineno LIKE type_file.num5
   DEFINE l_faj04_fab02 STRING
   DEFINE l_fca03_fca031 STRING
  
   ORDER EXTERNAL BY sr1.fca01_fca02

   FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*

        BEFORE GROUP OF sr1.fca01_fca02
            LET l_lineno = 0
 

        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno        

            LET l_faj04_fab02 = sr1.faj04,' ',sr1.fab02
            LET l_fca03_fca031 = sr1.fca03,' ',sr1.fca031 
            PRINTX l_faj04_fab02
            PRINTX l_fca03_fca031
            PRINTX sr1.*

        AFTER GROUP OF sr1.fca01_fca02       
        ON LAST ROW           
END REPORT
#FUN-B40097----add----end-------------
 
#No.FUN-710083 --begin
#REPORT g600_rep(sr)
#DEFINE l_last_sw	LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#          sr        RECORD
#                    fca01  LIKE fca_file.fca01,     #盤點編號
#                    fca02  LIKE fca_file.fca02,     #盤點序號
#                    faj04  LIKE faj_file.faj04,     #資產類別
#                    fab02  LIKE fab_file.fab02,     #類別名稱
#                    fca03  LIKE fca_file.fca03,     #財產編號
#                    fca031 LIKE fca_file.fca031,    #財產附號
#                    fca04  LIKE fca_file.fca04,     #序號
#                    faj06  LIKE faj_file.faj06,     #中文名稱
#                    faj07  LIKE faj_file.faj07,     #英文名稱
#                    faj08  LIKE faj_file.faj08,     #規格型號
#                    fca09  LIKE fca_file.fca09,     #數量
#                    fca05  LIKE fca_file.fca05,     #保管部門
#                    gem02  LIKE gem_file.gem02,     #部門名稱
#                    fca06  LIKE fca_file.fca06,     #保管人
#                    gen02  LIKE gen_file.gen02,     #保管人名稱
#                    fca07  LIKE fca_file.fca07      #存放位置
#                    END RECORD,
#    	l_barcode LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(12)
#    	l_i,l_j,l_len LIKE type_file.num5,         #No.FUN-680070 SMALLINT
#    	l_control LIKE type_file.chr5,         #No.FUN-680070 VARCHAR(5)
#    	l_advance LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
#        l_fca02   LIKE fca_file.fca01,       #No.FUN-680070 VARCHAR(6)
#    	l_ff LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(03)
#    	l_c LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
#    	l_01 LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(300)
#	
# 
#  OUTPUT TOP MARGIN 0
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN 5   #FUN-580098
#         PAGE LENGTH g_page_line
#  ORDER BY sr.fca01
#  FORMAT
#   PAGE HEADER
#        LET l_last_sw = 'n'        #FUN-550102
#
#
#   ON EVERY ROW
#      LET l_fca02 = sr.fca02
#      IF tm.size='Y' THEN
#         PRINT ' '
#      END IF
#      PRINT " "
#      PRINT " "
#
#    IF tm.size='N' THEN
#        PRINT COLUMN 02, g_x[11] CLIPPED,sr.fca01 CLIPPED,   #No.TQC-6A0085
#              COLUMN 20, g_x[12] CLIPPED,l_fca02 CLIPPED,   #No.TQC-6A0085
#              COLUMN 42, g_x[13] CLIPPED
#        PRINT " "
#        PRINT COLUMN 02, g_x[14] CLIPPED,sr.faj04 CLIPPED,'  ',sr.fab02 CLIPPED #No.TQC-6A0085
#        PRINT " "
#        PRINT COLUMN 02,g_x[15] CLIPPED,sr.fca03 CLIPPED,'  ',sr.fca031 CLIPPED #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[16] CLIPPED,sr.fca04 CLIPPED  #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[17] CLIPPED,sr.faj06 CLIPPED  #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[18] CLIPPED,sr.faj07 CLIPPED  #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[19] CLIPPED,sr.faj08 CLIPPED  #No.TQC-6A0085
#        PRINT " "
#        PRINT COLUMN 02,g_x[20] CLIPPED,sr.fca09 CLIPPED,COLUMN 30,g_x[21] CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[22] CLIPPED,sr.fca05 CLIPPED,COLUMN 30,g_x[23] CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 12,sr.gem02 CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[24] CLIPPED,sr.fca06 CLIPPED,COLUMN 30,g_x[25] CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 12,sr.gen02 CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[26] CLIPPED,sr.fca07 CLIPPED,COLUMN 30,g_x[27] CLIPPED   #No.TQC-6A0085
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT COLUMN 02,g_x[28] CLIPPED,g_x[29] CLIPPED   #No.TQC-6A0085
#        SKIP 6 LINE
#    ELSE
#        PRINT COLUMN 02, g_x[11] CLIPPED,sr.fca01 CLIPPED,   #No.TQC-6A0085
#              COLUMN 20, g_x[12] CLIPPED,sr.fca02 CLIPPED,   #No.TQC-6A0085
#              COLUMN 42, g_x[13] CLIPPED
#        PRINT " "
#        PRINT COLUMN 02, g_x[14] CLIPPED,sr.faj04 CLIPPED,'  ',sr.fab02   #No.TQC-6A0085
#        PRINT " "
#        PRINT COLUMN 02,g_x[15] CLIPPED,sr.fca03 CLIPPED,'  ',sr.fca031   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[16] CLIPPED,sr.fca04 CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[17] CLIPPED,sr.faj06 CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[18] CLIPPED,sr.faj07 CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[19] CLIPPED,sr.faj08 CLIPPED   #No.TQC-6A0085
#        PRINT " "
#        PRINT COLUMN 02,g_x[20] CLIPPED,sr.fca09 CLIPPED,COLUMN 30,g_x[21] CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[22] CLIPPED,sr.fca05 CLIPPED,COLUMN 30,g_x[23] CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 12,sr.gem02 CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[24] CLIPPED,sr.fca06 CLIPPED,COLUMN 30,g_x[25] CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 12,sr.gen02 CLIPPED   #No.TQC-6A0085
#        PRINT COLUMN 02,g_x[26] CLIPPED,sr.fca07 CLIPPED,COLUMN 30,g_x[27] CLIPPED   #No.TQC-6A0085
#        PRINT " "
#        PRINT " "
#        PRINT " "
#        PRINT COLUMN 02,g_x[28] CLIPPED,g_x[29] CLIPPED   #No.TQC-6A0085
#        SKIP 6 LINE
#   END IF
### FUN-550102
#   ON LAST ROW
#      LET l_last_sw = 'y'
#
#   PAGE TRAILER
#      PRINT ''
#      IF l_last_sw = 'n' THEN
#         IF g_memo_pagetrailer THEN
#             PRINT g_x[30]
#             PRINT g_memo
#         ELSE
#             PRINT
#             PRINT
#         END IF
#      ELSE
#             PRINT g_x[30]
#             PRINT g_memo
#      END IF
### END FUN-550102
#
#END REPORT
#No.FUN-710083 --end
 
#Patch....NO.TQC-610035 <001> #
#FUN-D10098
