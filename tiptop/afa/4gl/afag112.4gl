# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# Pattern name...: afag112.4gl
# Desc/riptions..: 固定資產族群編號異動申請單
# Date & Author..: 11/10/03  FUN-B70092 By Sakura
# Modify.........: No:FUN-BB0163 12/01/13 By Sakura l_sql/tm.wc-->STRING,修改l_sql中order by位置
# Modify.........: No:FUN-C10066 12/01/31 By Sakura 憑證CR轉GR
# Modify.........: No:FUN-C20080 12/02/28 By xuxz GR調整
# Modify.........: No.FUN-C40020 12/04/10 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50008 12/05/08 By wangrr GR程式優化

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD				# Print condition RECORD
       #wc     	LIKE type_file.chr1000,		# Where condition #FUN-BB0163 mark
       wc     	STRING, #FUN-BB0163 add       
       a        LIKE type_file.chr1,        
       b      	LIKE type_file.chr1,         
       more     LIKE type_file.chr1         
       END RECORD,
        g_zo       RECORD LIKE zo_file.*
DEFINE  g_i        LIKE type_file.num5     #count/index for any purpose       
DEFINE  g_sql      STRING
DEFINE  l_table    STRING
DEFINE  g_str      STRING

###GENGRE###START
TYPE sr1_t RECORD
    fbo01 LIKE fbo_file.fbo01,
    fbo02 LIKE fbo_file.fbo02,
    fbo03 LIKE fbo_file.fbo03,
    fbo04 LIKE fbo_file.fbo04,
    fbo05 LIKE fbo_file.fbo05,
    fbp02 LIKE fbp_file.fbp02,
    fbp03 LIKE fbp_file.fbp03,
    fbp031 LIKE fbp_file.fbp031,
    faj06 LIKE faj_file.faj06,
    fbp04 LIKE fbp_file.fbp04,
    fbp05 LIKE fbp_file.fbp05,
    gen02 LIKE gen_file.gen02,
    gem02 LIKE gem_file.gem02,
    sign_type LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_img  LIKE type_file.blob,   # No.FUN-C40020 add
    sign_show LIKE type_file.chr1,   # No.FUN-C40020 add
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
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
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 


   LET g_pdate = ARG_VAL(1)	             # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.a  = ARG_VAL(8)
   LET tm.b  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  

   LET g_sql ="fbo01.fbo_file.fbo01,",
              "fbo02.fbo_file.fbo02,",
              "fbo03.fbo_file.fbo03,",
              "fbo04.fbo_file.fbo04,",
              "fbo05.fbo_file.fbo05,",
              "fbp02.fbp_file.fbp02,",
              "fbp03.fbp_file.fbp03,",
              "fbp031.fbp_file.fbp031,",
              "faj06.faj_file.faj06,",
              "fbp04.fbp_file.fbp04,",
              "fbp05.fbp_file.fbp05,",
              "gen02.gen_file.gen02,",
              "gem02.gem_file.gem02,", #FUN-C10066 delete-->,
              "sign_type.type_file.chr1,sign_img.type_file.blob,",  # No.FUN-C40020 add
              "sign_show.type_file.chr1,sign_str.type_file.chr1000" # No.FUN-C40020 add
   LET l_table = cl_prt_temptable('afag112',g_sql) CLIPPED #FUN-C10066 afar-->afag
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-C10066
      CALL cl_gre_drop_temptable(l_table)    #FUN-C10066
      EXIT PROGRAM 
   END IF
   LET g_sql = "INSERT INTO ds_report.",l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
      CALL cl_used(g_prog, g_time,2) RETURNING g_time  #FUN-C10066
      CALL cl_gre_drop_temptable(l_table)    #FUN-C10066      
   END IF


   IF cl_null(g_bgjob) OR g_bgjob = 'N'	# If background job sw is off
      THEN CALL g112_tm(0,0)		# Input print condition #FUN-C10066 r-->g
      ELSE CALL afag112()		# Read data and create out-file #FUN-C10066 afar-->afag
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION g112_tm(p_row,p_col) #FUN-C10066 r-->g
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
   DEFINE   p_row,p_col   LIKE type_file.num5,         
            l_cmd         LIKE type_file.chr1000      

   LET p_row = 4 LET p_col = 16

   OPEN WINDOW g112_w AT p_row,p_col WITH FORM "afa/42f/afag112" #FUN-C10066 afar-->afag,r-->g
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()


   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Defbllt condition
   LET tm.a    = '2'
   LET tm.b    = '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_ptime = g_time   #FUN-C50008    

   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON fbo01,fbo02,fbo03,fbo04,fbo05

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

      ON ACTION locale
          CALL cl_show_fld_cont()                  
         LET g_action_choice = "locale"
         EXIT CONSTRUCT

    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT

         ON ACTION qbe_select
            CALL cl_qbe_select()


 END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW g112_w #FUN-C10066 r-->g 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF

      INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
 

         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)


         AFTER FIELD a
            IF cl_null(tm.a) OR tm.a NOT MATCHES "[123]" THEN
               NEXT FIELD a
            END IF
 
         AFTER FIELD b
            IF cl_null(tm.b) OR tm.b NOT MATCHES "[123]" THEN
               NEXT FIELD b
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()


      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW g112_w  #FUN-C10066 r-->g
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
          WHERE zz01='afag112' #FUN-C10066 afar-->afag
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afag112','9031',1) #FUN-C10066 afar-->afag
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_rlang CLIPPED,"'", 
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'" ,
                            " '",g_rep_user CLIPPED,"'",           
                            " '",g_rep_clas CLIPPED,"'",           
                            " '",g_template CLIPPED,"'",           
                            " '",g_rpt_name CLIPPED,"'"          
            CALL cl_cmdat('afag112',g_time,l_cmd)      # Execute cmd at later time #FUN-C10066 afar-->afag
         END IF
         CLOSE WINDOW g112_w #FUN-C10066 r-->g
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afag112() #FUN-C10066 afar-->afag
      ERROR ""
   END WHILE

   CLOSE WINDOW g112_w #FUN-C10066 r-->g
END FUNCTION
 
FUNCTION afag112() #FUN-C10066 afar-->afag
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name      
          l_gem02       LIKE gem_file.gem02,           #部門名稱     
          l_gen02       LIKE gen_file.gen02,           #申請人名稱    
          #l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #FUN-BB0163 mark
          l_sql 	STRING, #FUN-BB0163 add      
          l_chr		LIKE type_file.chr1,         
          l_za05	LIKE type_file.chr1000,
          sr   RECORD
                     fbo01     LIKE fbo_file.fbo01,    #異動單號
                     fbo02     LIKE fbo_file.fbo02,    #日期
                     fbo03     LIKE fbo_file.fbo03,    #申請人
                     fbo04     LIKE fbo_file.fbo04,    #申請部門
                     fbo05     LIKE fbo_file.fbo05,    #申請日期
                     fbp02     LIKE fbp_file.fbp02,    #項次
                     fbp03     LIKE fbp_file.fbp03,    #財產編號
                     fbp031    LIKE fbp_file.fbp031,   #附號
                     faj06     LIKE faj_file.faj06,    #中文名稱
                     fbp04     LIKE fbp_file.fbp04,    #原族群編號
                     fbp05     LIKE fbp_file.fbp05     #變更後族群編號 
        END RECORD
     DEFINE l_img_blob        LIKE type_file.blob  # No.FUN-C40020 add
     LOCATE l_img_blob        IN MEMORY            # No.FUN-C40020 add

     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     CALL cl_del_data(l_table)

     #====>資料權限的檢查
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shhuser', 'shhgrup')

     LET l_sql = "SELECT fbo01,fbo02,fbo03,fbo04,fbo05,",
                 "       fbp02,fbp03,fbp031,",
                 "       faj06,fbp04,fbp05,",
                 "       '','' ",
                #"  FROM fbo_file,fbp_file, OUTER faj_file  ", #FUN-C50008 mark--
                 "  FROM fbo_file,fbp_file LEFT OUTER JOIN faj_file ON (fbp03=faj02 AND fbp031=faj022) ", #FUN-C50008 add
                 " WHERE fbo01 = fbp01 ",
                 "   AND fboconf !='X' ",        
                #"   AND fbp03=faj02 ",    #FUN-C50008 mark--
                #"   AND fbp031=faj022 ",  #FUN-C50008 mark--
                 "   AND ",tm.wc CLIPPED
                 #" ORDER BY fbp02 " #FUN-BB0163 mark

     IF tm.a='1' THEN LET l_sql=l_sql CLIPPED," AND fboconf='Y' " END IF
     IF tm.a='2' THEN LET l_sql=l_sql CLIPPED," AND fboconf='N' " END IF
     IF tm.b='1' THEN LET l_sql=l_sql CLIPPED," AND fbopost='Y' " END IF
     IF tm.b='2' THEN LET l_sql=l_sql CLIPPED," AND fbopost='N' " END IF
     LET l_sql = l_sql CLIPPED," ORDER BY fbp02 " #FUN-BB0163 add
     PREPARE g112_prepare1 FROM l_sql #FUN-C10066 r-->g
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
           
     END IF
     DECLARE g112_cs1 CURSOR FOR g112_prepare1 #FUN-C10066 r-->g
 
     FOREACH g112_cs1 INTO sr.* #FUN-C10066 r-->g
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

      LET l_gen02=' '
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=sr.fbo03
      LET l_gem02=' '
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.fbo04
      EXECUTE insert_prep USING sr.*,l_gen02,l_gem02,"",  l_img_blob,"N",""  # No.FUN-C40020 add

     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(tm.wc,'fbo01,fbo02,fbo03,fbo04,fbo05')
          RETURNING tm.wc
###GENGRE###     LET g_str = tm.wc,";",g_zz05

###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

###GENGRE###     CALL cl_prt_cs3('afar112','afar112',l_sql,g_str)
    LET g_cr_table = l_table                    # No.FUN-C40020 add
    LET g_cr_apr_key_f = "fbo01"          # No.FUN-C40020 add
    CALL afag112_grdata()    ###GENGRE###

END FUNCTION
#FUN-B70092

###GENGRE###START
FUNCTION afag112_grdata()
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
        LET handler = cl_gre_outnam("afag112")
        IF handler IS NOT NULL THEN
            START REPORT afag112_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
          
            DECLARE afag112_datacur1 CURSOR FROM l_sql
            FOREACH afag112_datacur1 INTO sr1.*
                OUTPUT TO REPORT afag112_rep(sr1.*)
            END FOREACH
            FINISH REPORT afag112_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT afag112_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-C10066----add----str--------------
    DEFINE l_fbo03_gen02 STRING
    DEFINE l_fbo04_gem02 STRING
    #FUN-C10066----add----end--------------    

    
    ORDER EXTERNAL BY sr1.fbo01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name #FUN-C20080
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.fbo01
            LET l_lineno = 0

            #FUN-C10066----add----str--------------
            LET l_fbo03_gen02=sr1.fbo03,' ',sr1.gen02
            LET l_fbo04_gem02=sr1.fbo04,' ',sr1.gem02
            PRINTX l_fbo03_gen02
            PRINTX l_fbo04_gem02
            #FUN-C10066----add----end--------------

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.fbo01

        
        ON LAST ROW

END REPORT
###GENGRE###END
