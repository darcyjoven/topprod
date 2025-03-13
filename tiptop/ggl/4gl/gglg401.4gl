# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglg401.4gl
# Descriptions...: 明細帳套表
# Input parameter:
# Return code....:
# Date & Author..: 06/10/11 By Rayven
# Modify.........: No.FUN-6C0012 06/12/29 By Judy 增加是否打印額外名稱
# Modify.........: No.TQC-710095 07/02/28 By Rayven 報表格式沒對齊，過次頁承上頁金額有時空白
# Modify.........: No.FUN-740055 07/04/13 By sherry 會計科目加帳套
# Modify.........: No.FUN-7C0064 07/12/25 By Carrier 報表格式轉CR
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-860252 09/02/18 By chenl  增加打印時是否打印貨幣性科目或全部科目的選擇。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40020 10/04/09 By Carrier 独立科目层及设置为1
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用
# Modify.........: No.FUN-B20010 11/02/15 By yinhy 先選擇帳套，根據帳套判斷科目開窗開哪個帳套的科目資料
# Modify.........: No.FUN-B40087 11/06/09 By yangtt  憑證報表轉GRW
# Modify.........: No:FUN-B80096 11/08/10 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-C10036 12/01/11 By qirl 程式規範修改
# Modify.........: No:FUN-C10036 12/01/16 By lujh 程式規範修改
# Modify.........: No:FUN-C50007 12/05/09 By minpp GR程式規範修改 
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD				# Print condition RECORD
		wc1	STRING,
                wc2     STRING,
   		a    	LIKE type_file.chr1,    #期初為零且當期無異動科目打印
   		b    	LIKE type_file.chr1,    #打印獨立性質科目
   		c    	LIKE type_file.chr1,    #僅打印末級科目
   		d    	LIKE type_file.chr1,    #打印非貨幣性科目
   		e    	LIKE type_file.chr1,    #打印外幣
   		f    	LIKE azi_file.azi01,    #外幣幣種
                s       LIKE type_file.chr1,    #MOD-860252僅貨幣性科目
                g       LIKE type_file.chr1,    #對應科目顯示方
                h       LIKE type_file.chr1     #資料選項
             END RECORD,
          yy,mm         LIKE type_file.num10,
          mm1,nn1       LIKE type_file.num10,
          bdate,edate   LIKE type_file.dat,
          l_flag        LIKE type_file.chr1,
          g_aaa         RECORD LIKE aaa_file.*,
          g_cnnt        LIKE type_file.num5
   DEFINE g_aaa03       LIKE aaa_file.aaa03
   DEFINE g_cnt         LIKE type_file.num10
   DEFINE g_i           LIKE type_file.num5
   DEFINE #g_sql         LIKE type_file.chr1000
          g_sql       STRING     #No.FUN-910082
 
DEFINE    l_table       STRING                  #No.FUN-7C0064
DEFINE    g_str         STRING                  #No.FUN-7C0064
 
###GENGRE###START
TYPE sr1_t RECORD
    abb07_1 LIKE abb_file.abb07,
    abb07_2 LIKE abb_file.abb07,
    abb07f_1 LIKE abb_file.abb07f,
    abb07f_2 LIKE abb_file.abb07f,
    aag01 LIKE aag_file.aag01,
    aag02 LIKE aag_file.aag02,
    mm LIKE type_file.num10,
    aba01 LIKE aba_file.aba01,
    aba02 LIKE aba_file.aba02,
    abb02 LIKE abb_file.abb02,
    abb04 LIKE abb_file.abb04,
    abb24 LIKE abb_file.abb24,
    abb25 LIKE abb_file.abb25,
    abb06 LIKE abb_file.abb06,
    abb07 LIKE abb_file.abb07,
    abb07f LIKE abb_file.abb07f,
    qcye LIKE abb_file.abb07,
    qcyef LIKE abb_file.abb07,
    abb03_s LIKE type_file.chr10,
    l_md LIKE abb_file.abb07,
    l_mdf LIKE abb_file.abb07,
    l_mc LIKE abb_file.abb07,
    l_mcf LIKE abb_file.abb07,
    l_yd LIKE abb_file.abb07,
    l_ydf LIKE abb_file.abb07,
    l_yc LIKE abb_file.abb07,
    l_ycf LIKE abb_file.abb07,
    azi04 LIKE azi_file.azi04,
    azi07 LIKE azi_file.azi07,
    line LIKE type_file.num10,
    pageno LIKE type_file.num10
  



END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
 
 
   IF g_aaa.aaa01 IS NULL OR g_aaa.aaa01 = ' ' THEN
#     LET g_aaa.aaa01 = g_aaz.aaz64
      LET g_aaa.aaa01 = g_aza.aza81    #No.FUN-740055
   END IF
   #-->使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = g_aaa.aaa01
   IF SQLCA.sqlcode THEN LET g_aaa03 = g_aza.aza17 END IF     #使用本國幣別
   SELECT azi04,azi05 INTO g_azi04,g_azi05 FROM azi_file WHERE azi01 = g_aaa03
   IF SQLCA.sqlcode THEN 
      CALL cl_err(g_aaa03,SQLCA.sqlcode,0)
   END IF
 
   #No.FUN-7C0064  --Begin
   LET g_sql = " abb07_1.abb_file.abb07,",
               " abb07_2.abb_file.abb07,",
               " abb07f_1.abb_file.abb07f,",
               " abb07f_2.abb_file.abb07f,",
               " aag01.aag_file.aag01,",
               " aag02.aag_file.aag02,",
               " mm.type_file.num10,  ",
               " aba01.aba_file.aba01,",
               " aba02.aba_file.aba02,",
               " abb02.abb_file.abb02,",
               " abb04.abb_file.abb04,",
               " abb24.abb_file.abb24,",
               " abb25.abb_file.abb25,",
               " abb06.abb_file.abb06,",
               " abb07.abb_file.abb07,",
               " abb07f.abb_file.abb07f,",
               " qcye.abb_file.abb07, ",
               " qcyef.abb_file.abb07,",
               " abb03_s.type_file.chr10,",
               " l_md.abb_file.abb07,",
               " l_mdf.abb_file.abb07,",
               " l_mc.abb_file.abb07,",
               " l_mcf.abb_file.abb07,",
               " l_yd.abb_file.abb07,",
               " l_ydf.abb_file.abb07,",
               " l_yc.abb_file.abb07,",
               " l_ycf.abb_file.abb07,",
               " azi04.azi_file.azi04,",
               " azi07.azi_file.azi07,",
               " line.type_file.num10,",
               " pageno.type_file.num10 "
 
   LET l_table = cl_prt_temptable('gglg401',g_sql) CLIPPED
   IF l_table = -1 THEN 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087    #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087    #FUN-C10036   mark
      EXIT PROGRAM  
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?)          "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) 
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time          #FUN-B40087    #FUN-C10036   mark
      #CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087    #FUN-C10036   mark
      EXIT PROGRAM
   END IF
   #No.FUN-7C0064  --End
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80096   ADD
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL gglg401_tm()	        	# Input print condition
      ELSE CALL gglg401()			# Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
   CALL cl_gre_drop_temptable(l_table)    #FUN-C10036 ADD
END MAIN
 
FUNCTION gglg401_tm()
   DEFINE p_row,p_col	LIKE type_file.num5,
          l_i           LIKE type_file.num5,  
          l_cmd		LIKE type_file.chr1000,
          l_aaaacti     LIKE aaa_file.aaaacti,
          l_aziacti     LIKE azi_file.aziacti 
   DEFINE li_chk_bookno LIKE type_file.num5   #FUN-B20010
   CALL s_dsmark(g_aaa.aaa01)
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW gglg401_w AT p_row,p_col
        WITH FORM "ggl/42f/gglg401"
 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
 
 
   CALL s_shwact(0,0,g_aaa.aaa01)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   
   LET bdate   = g_today
   LET edate   = g_today
   LET tm.a    = 'N'
   LET tm.b    = 'N'
   LET tm.c    = 'N'
   LET tm.d    = 'Y'
   LET tm.e    = 'N'
   LET tm.f    = g_aza.aza17
   LET tm.s    = 'Y'     #MOD-860252
   LET tm.g  = '1'
   LET tm.h  = '1'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
     #No.FUN-B20010  --Begin
     DIALOG ATTRIBUTE(unbuffered)
     INPUT BY NAME g_aaa.aaa01  ATTRIBUTE(WITHOUT DEFAULTS)
        AFTER FIELD aaa01
            IF NOT cl_null(g_aaa.aaa01) THEN
	          CALL s_check_bookno(g_aaa.aaa01,g_user,g_plant) 
               RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD aaa01
            END IF
         SELECT aaa02 FROM aaa_file WHERE aaa01 = g_aaa.aaa01
            IF STATUS THEN 
               CALL cl_err3("sel","aaa_file",g_aaa.aaa01,"","agl-043","","",0)
               NEXT FIELD a 
            END IF
         END IF
          
      
    END INPUT
   
    #No.FUN-B20010  --End
     CONSTRUCT BY NAME tm.wc1 ON aag01
       #No.FUN-B20010  --Mark Begin
       #ON ACTION locale
       #   CALL cl_show_fld_cont() 
       #  LET g_action_choice = "locale"
       #  EXIT CONSTRUCT
       #
       #ON IDLE g_idle_seconds
       #   CALL cl_on_idle()
       #   CONTINUE CONSTRUCT
       #
       # ON ACTION about       
       #    CALL cl_about()   
       #
       # ON ACTION help      
       #    CALL cl_show_help()
       #
       # ON ACTION controlg   
       #    CALL cl_cmdask() 
       #
       
       #ON ACTION controlp
       #   CASE
       #      WHEN INFIELD(aag01)
       #         CALL cl_init_qry_var()                                                                                               
       #         LET g_qryparam.form = 'q_aag04'
       #         LET g_qryparam.state = "c"
       #         LET g_qryparam.where = " aag00 = '",g_aaa.aaa01 CLIPPED,"'"  #FUN-B20010
       #         CALL cl_create_qry() RETURNING g_qryparam.multiret
       #         DISPLAY g_qryparam.multiret TO aag01                                                                                   
       #         NEXT FIELD aag01        
       #   END CASE
       
       
       #ON ACTION exit
       #    LET INT_FLAG = 1
       #    EXIT CONSTRUCT
       #No.FUN-B20010  --Mark End
     END CONSTRUCT
     #No.FUN-B20010  --Mark Begin
     #IF g_action_choice = "locale" THEN
     #   LET g_action_choice = ""
     #   CALL cl_dynamic_locale()
     #   CONTINUE WHILE
     #END IF
     
     #IF INT_FLAG THEN
     #   LET INT_FLAG = 0 CLOSE WINDOW gglg401_w EXIT PROGRAM
     #END IF
     #No.FUN-B20010  --Mark End
     
     CONSTRUCT BY NAME tm.wc2 ON aba11
       #No.FUN-B20010  --Mark Begin
       #ON IDLE g_idle_seconds
       #   CALL cl_on_idle()
       #   CONTINUE CONSTRUCT      
       #
       #ON ACTION about     
       #   CALL cl_about() 
       #
       #ON ACTION help    
       #   CALL cl_show_help()
       #
       #ON ACTION controlg   
       #   CALL cl_cmdask() 
       #
       #ON ACTION exit
       #   LET INT_FLAG = 1
       #   EXIT CONSTRUCT  
       #No.FUN-B20010  --Mark End    
     
     END CONSTRUCT
     #No.FUN-B20010  --Begin
     #IF g_action_choice = "locale" THEN
     #   LET g_action_choice = ""
     #   CALL cl_dynamic_locale()
     #   CONTINUE WHILE
     #END IF
 
     #IF INT_FLAG THEN
     #    LET INT_FLAG = 0 CLOSE WINDOW gglg401_w EXIT PROGRAM
     #END IF
     #No.FUN-B20010  --End
     
     #DISPLAY BY NAME g_aaa.aaa01,tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.s,tm.g,tm.h  #No.MOD-860252 add tm.s  #FUN-B20010 mark
     #INPUT BY NAME g_aaa.aaa01,bdate,edate,tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.s,tm.g,tm.h #No.MOD-860252 add tm.s #FUN-B20010 mark
     INPUT BY NAME bdate,edate,tm.a,tm.b,tm.c,tm.d,tm.e,tm.f,tm.s,tm.g,tm.h ATTRIBUTE(WITHOUT DEFAULTS) #No.FUN-B20010 
         #No.FUN-B20010  --Mark Begin 
         # WITHOUT DEFAULTS
         
         #AFTER FIELD aaa01
         #   SELECT COUNT(*) INTO l_i FROM aaa_file
         #    WHERE aaa01 = g_aaa.aaa01
         #   IF l_i = 0 THEN
         #      CALL cl_err(g_aaa.aaa01,'anm-009',0)
         #      NEXT FIELD aaa01
         #   ELSE
         #      SELECT aaaacti INTO l_aaaacti FROM aaa_file
         #       WHERE aaa01 = g_aaa.aaa01
         #      IF l_aaaacti <> 'Y' THEN
         #         CALL cl_err(g_aaa.aaa01,'ggl-999',0)
         #         NEXT FIELD aaa01
         #      END IF
         #   END IF
         #No.FUN-B20010  --Mark End
         
          AFTER FIELD bdate
             IF cl_null(bdate) THEN
                NEXT FIELD bdate
             END IF
 
          AFTER FIELD edate
             IF cl_null(edate) THEN
                LET edate =g_lastdat
             ELSE
                IF YEAR(bdate) <> YEAR(edate) THEN NEXT FIELD edate END IF
             END IF
             IF edate < bdate THEN
                CALL cl_err(' ','agl-031',0)
                NEXT FIELD edate
             END IF
 
          AFTER FIELD a
             IF tm.a NOT MATCHES "[YN]" THEN NEXT FIELD a END IF
 
          AFTER FIELD b
             IF tm.b NOT MATCHES "[YN]" THEN NEXT FIELD b END IF
 
          AFTER FIELD c
             IF tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
          AFTER FIELD d
             IF tm.d NOT MATCHES "[YN]" THEN NEXT FIELD d END IF
 
          AFTER FIELD e
             IF cl_null(tm.e) OR tm.e NOT MATCHES'[YN]' THEN NEXT FIELD e END IF
             IF tm.e = 'N' THEN
                LET tm.f = NULL
                DISPLAY BY NAME tm.f
             END IF
             IF tm.e = 'Y' THEN                                                                                                     
                CALL cl_set_comp_entry('f',TRUE)                                                                                    
             ELSE                                                                                                                   
                CALL cl_set_comp_entry('f',FALSE)                                                                                   
             END IF                                                                                                                 
                                                                                                                                    
          BEFORE FIELD f                                                                                                            
             IF tm.e = 'Y' THEN                                                                                                     
                CALL cl_set_comp_entry('f',TRUE)                                                                                    
             ELSE                                                                                                                   
                CALL cl_set_comp_entry('f',FALSE)                                                                                   
             END IF             
 
          AFTER FIELD f
             SELECT azi01 FROM azi_file WHERE azi01 = tm.f
             IF SQLCA.sqlcode THEN
                CALL cl_err(tm.f,'agl-109',0)
                NEXT FIELD f
             END IF
             SELECT aziacti INTO l_aziacti FROM azi_file
              WHERE zai01 = tm.f
             IF l_aziacti <> 'Y' THEN
                CALL cl_err(tm.f,'ggl-998',0)
                NEXT FIELD f
             END IF
             IF tm.e = 'N' THEN
                LET tm.f = NULL
                DISPLAY BY NAME tm.f
             END IF
 
          AFTER FIELD g
#            IF cl_null(tm.g) OR tm.g NOT MATCHES '[12]'   #FUN-6C0012
             IF cl_null(tm.g) OR tm.g NOT MATCHES '[123]'  #FUN-6C0012
             THEN NEXT FIELD g END IF
 
          AFTER FIELD h
             IF cl_null(tm.h) OR tm.h NOT MATCHES '[123]'
             THEN NEXT FIELD h END IF
      #No.FUN-B20010  --Mark Begin 
      #ON ACTION CONTROLP
      #   CASE   
      #     
      #     WHEN INFIELD(aaa01)
      #        CALL cl_init_qry_var()                                                                                               
      #        LET g_qryparam.form = 'q_aaa3'                                                                                       
      #        LET g_qryparam.default1 = g_aaa.aaa01
      #        CALL cl_create_qry() RETURNING g_aaa.aaa01                                                                              
      #        DISPLAY g_aaa.aaa01 TO FORMONLY.aaa01                                                                                   
      #        NEXT FIELD aaa01   
      #     
      #      WHEN INFIELD(f)
      #         CALL cl_init_qry_var()                                                                                               
      #         LET g_qryparam.form = 'q_azi'                                                                                        
      #         LET g_qryparam.default1 = tm.f                                                                                       
      #         CALL cl_create_qry() RETURNING tm.f                                                                                  
      #         DISPLAY tm.f TO FORMONLY.f
      #         NEXT FIELD f
      #   END CASE
      #   
      #ON ACTION CONTROLR
      #   CALL cl_show_req_fields()
      #
      #ON ACTION CONTROLG
      #   CALL cl_cmdask()
      #
      #ON IDLE g_idle_seconds
      #   CALL cl_on_idle()
      #   CONTINUE INPUT
      #
      #ON ACTION about    
      #   CALL cl_about()
      #
      #ON ACTION help   
      #   CALL cl_show_help()
      #
      #ON ACTION exit
      #   LET INT_FLAG = 1
      #   EXIT INPUT
      #No.FUN-B20010  --Mark End
    END INPUT
    #No.FUN-B20010  --Begin
     ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aaa01)
                CALL cl_init_qry_var()                                                                                               
                LET g_qryparam.form = 'q_aaa3'                                                                                       
                LET g_qryparam.default1 = g_aaa.aaa01
                CALL cl_create_qry() RETURNING g_aaa.aaa01                                                                              
                DISPLAY g_aaa.aaa01 TO FORMONLY.aaa01                                                                                   
                NEXT FIELD aaa01  
             WHEN INFIELD(aag01)                                                         
               CALL cl_init_qry_var()                                                   
               LET g_qryparam.form = 'q_aag04'                                          
               LET g_qryparam.state = "c"                                               
               LET g_qryparam.where = " aag00 = '",g_aaa.aaa01 CLIPPED,"'"  #FUN-B20010 
               CALL cl_create_qry() RETURNING g_qryparam.multiret                       
               DISPLAY g_qryparam.multiret TO aag01                                     
               NEXT FIELD aag01                                                         
             OTHERWISE EXIT CASE
          END CASE
       ON ACTION locale
          CALL cl_show_fld_cont() 
          LET g_action_choice = "locale"
          EXIT DIALOG
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG
 
       ON ACTION about    
          CALL cl_about()
  
       ON ACTION help   
          CALL cl_show_help()
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT DIALOG
          
       ON ACTION accept
          EXIT DIALOG
         
       ON ACTION cancel
          LET INT_FLAG=1
          EXIT DIALOG   
     END DIALOG
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLOSE WINDOW gglg401_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
       EXIT PROGRAM
    END IF
    
    #No.FUN-B20010  --END
    
    LET mm1 = MONTH(bdate)
    LET nn1 = MONTH(edate)
 
    SELECT azn02,azn04 INTO yy,mm FROM azn_file WHERE azn01 = bdate
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
        WHERE zz01='gglg401'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('gglg401','9031',1)   
       ELSE
          LET tm.wc1=cl_wcsub(tm.wc1)
          LET l_cmd = l_cmd CLIPPED,
                     " '",g_aaa.aaa01 CLIPPED,"'",
                     " '",g_pdate CLIPPED,"'",
                     " '",g_towhom CLIPPED,"'",
                     #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                     " '",g_bgjob CLIPPED,"'",
                     " '",g_prtway CLIPPED,"'",
                     " '",g_copies CLIPPED,"'",
                     " '",tm.wc1 CLIPPED,"'",
                     " '",tm.wc2 CLIPPED,"'",
                     " '",tm.a CLIPPED,"'",
                     " '",tm.b CLIPPED,"'",
                     " '",tm.e CLIPPED,"'",
                     " '",tm.f CLIPPED,"'",
                    " '",tm.h CLIPPED,"'",  
                    " '",bdate CLIPPED,"'",
                    " '",edate CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",   
                         " '",g_rep_clas CLIPPED,"'",  
                         " '",g_template CLIPPED,"'"  
          CALL cl_cmdat('gglg401',g_time,l_cmd)	# Execute cmd at later time
       END IF
       CLOSE WINDOW gglg401_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
       CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
       EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL gglg401()
    ERROR ""
   END WHILE
   CLOSE WINDOW gglg401_w
END FUNCTION
 

FUNCTION gglg401()
   DEFINE l_name     	   LIKE type_file.chr20,
          #l_sql,l_sql1 	   LIKE type_file.chr1000,
          l_sql,l_sql1       STRING,     #No.FUN-910082
          l_aea03          LIKE type_file.chr5,  
          l_bal,l_bal2     LIKE type_file.num20_6,
          s_abb07,s_abb07f LIKE type_file.num20_6,
          l_za05	   LIKE type_file.chr1000,
          l_date,l_date1   LIKE aba_file.aba02,
          p_aag02          LIKE type_file.chr1000,
          l_i              LIKE type_file.num5, 
          l_creid          LIKE abb_file.abb07,
          l_creidf         LIKE abb_file.abb07f,
          l_debit          LIKE abb_file.abb07,
          l_debitf         LIKE abb_file.abb07f,
          sr1    RECORD
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                    aag08  LIKE aag_file.aag08,
                    aag07  LIKE aag_file.aag07,
                    aag24  LIKE aag_file.aag24
                 END RECORD,
          sr     RECORD
                    abb07_1 LIKE abb_file.abb07,   #FUN-B40087 
                    abb07_2 LIKE abb_file.abb07,   #FUN-B40087
                    abb07f_1 LIKE abb_file.abb07f, #FUN-B40087
                    abb07f_2 LIKE abb_file.abb07f, #FUN-B40087
                    aag01  LIKE aag_file.aag01,
                    aag02  LIKE aag_file.aag02,
                    mm     LIKE type_file.num10,  
                    aba01  LIKE aba_file.aba01,
                    aba02  LIKE aba_file.aba02,
                    abb02  LIKE abb_file.abb02,
                    abb04  LIKE abb_file.abb04,
                    abb24  LIKE abb_file.abb24,
                    abb25  LIKE abb_file.abb25,
                    abb06  LIKE abb_file.abb06,
                    abb07  LIKE abb_file.abb07,
                    abb07f LIKE abb_file.abb07f,
                    qcye   LIKE abb_file.abb07, 
                    qcyef  LIKE abb_file.abb07 
                 END RECORD
#No.FUN-7C0064  --Begin
  DEFINE l_abb03_s        LIKE type_file.chr20
  DEFINE l_md             LIKE abb_file.abb07 
  DEFINE l_mdf            LIKE abb_file.abb07f
  DEFINE l_mc             LIKE abb_file.abb07 
  DEFINE l_mcf            LIKE abb_file.abb07f
  DEFINE l_yd             LIKE abb_file.abb07 
  DEFINE l_ydf            LIKE abb_file.abb07f
  DEFINE l_yc             LIKE abb_file.abb07 
  DEFINE l_ycf            LIKE abb_file.abb07f
  DEFINE l_type1          LIKE type_file.chr1
  DEFINE l_begin          LIKE type_file.dat
  DEFINE l_end            LIKE type_file.dat
  DEFINE l_line           LIKE type_file.num10
  DEFINE l_pageno         LIKE type_file.num10
#No.FUN-7C0064  --End  
     #No.FUN-B80096--mark--Begin---
     #CALL cl_used(g_prog,g_time,1) RETURNING g_time
     #No.FUN-B80096--mark--End-----
     #No.FUN-7C0064  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-7C0064  --End
 
       SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = g_aaa.aaa01
          AND aaf02 = g_lang
 
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaguser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN
     #        LET tm.wc1 = tm.wc1 CLIPPED," AND aaggrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc1 = tm.wc1 CLIPPED,cl_get_extra_cond('aaguser', 'aaggrup')
     #End:FUN-980030
 
     LET l_sql1= "SELECT aag01,aag02,aag08,aag07,aag24 ",
                 "  FROM aag_file ",
                 " WHERE aag03 ='2' AND aagacti = 'Y'",
                 "   AND aag00 = '",g_aaa.aaa01,"'",    #No.FUN-740055  
                 "   AND ",tm.wc1 CLIPPED
     IF tm.b = 'Y' THEN
        LET l_sql1 = l_sql1 CLIPPED," AND aag07 IN ('2','3')"
     ELSE
        LET l_sql1 = l_sql1 CLIPPED," AND aag07 = '2'"
     END IF
     IF tm.c = 'Y' THEN
        #No.FUN-A40020  --Begin                                                 
       #LET l_sql1 = l_sql1 CLIPPED," AND aag24 = 99"                           
        LET l_sql1 = l_sql1 CLIPPED," AND (aag24 = 99 OR aag07 = '3') "         
        #No.FUN-A40020  --End
     END IF
     IF tm.d = 'N' THEN
        LET l_sql1 = l_sql1 CLIPPED," AND aag19 = '1'"
     END IF
     #No.MOD-860252--begin--
     IF tm.s = 'Y' THEN 
        LET l_sql1 = l_sql1 CLIPPED," AND aag09 ='Y'   "
     END IF 
     #No.MOD-860252---end---
 
     PREPARE gglg401_prepare1 FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE gglg401_curs1 CURSOR FOR gglg401_prepare1
 
     LET l_sql = "SELECT '','','','',abb03,'',aba04,aba01,aba02,abb02,",
                 "       abb04,abb24,abb25,abb06,",
                 "       abb07,abb07f,0 ",
                 "  FROM aba_file,abb_file ",
                 " WHERE abb03 =  ? ",
                 "   AND abb00 = '",g_aaa.aaa01,"'",
                 "   AND aba00 = abb00 ",
                 "   AND aba01 = abb01 ",
                 "   AND aba02 BETWEEN '",bdate,"' AND '",edate,"' ",
                 "   AND abaacti='Y' ",
                 "   AND aba19 <> 'X' ",  #CHI-C80041
                 "   AND aba04 = ? ",
                 "   AND ",tm.wc2 CLIPPED
     IF tm.h = '2' THEN
        LET l_sql = l_sql CLIPPED," AND aba19 = 'Y' "
     END IF
     IF tm.h = '3' THEN
        LET l_sql = l_sql CLIPPED," AND abapost = 'Y' "
     END IF
     LET l_sql = l_sql CLIPPED," ORDER BY abb03,aba02,aba04"
 
     PREPARE gglg401_prepare2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE gglg401_curs2 CURSOR FOR gglg401_prepare2
 
     LET g_sql = "SELECT SUM(abb07),SUM(abb07f) FROM abb_file,aba_file",
                 " WHERE abb00 = aba00  AND abb01 = aba01",
                 "   AND aba00 = '",g_aaa.aaa01,"'",
                 "   AND abb03 = ? ",
                 "   AND aba02 < '",bdate,"'",
                 "   AND aba03 = '",YEAR(bdate),"'",
                 "   AND abb06 =? ",
                 "   AND aba19 <> 'X' ",  #CHI-C80041
                 "   AND abapost = 'N'",
                 "   AND abaacti = 'Y'"
     IF tm.h = '2' THEN
        LET g_sql = g_sql CLIPPED, " AND aba19 = 'Y' "
     END IF
     IF tm.e = 'Y' THEN
        LET g_sql= g_sql CLIPPED,"  AND abb24 = ? "
     END IF
 
     PREPARE gglg401_prepare3 FROM g_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE qcye_curs1 CURSOR FOR gglg401_prepare3
 
     LET g_sql = "SELECT SUM(abb07),SUM(abb07f) FROM abb_file,aba_file",
                 " WHERE abb00 = aba00  AND abb01 = aba01",
                 "   AND aba00 = '",g_aaa.aaa01,"'",
                 "   AND abb03 = ? ",
              #  "   AND aba02 >= '",bdate,"' AND aba02 <= '",edate,"'",  #No.FUN-7C0064
              #  "   AND aba02 >= ?           AND aba02 <= ?          ",  #No.FUN-7C0064  #FUN-C50007
                 "   AND aba02 BETWEEN ? AND ? ",                         #FUN-C50007
                 "   AND abb06 = ? ",                                     #No.FUN-7C0064
                 "   AND aba03 = '",YEAR(bdate),"'",
                 "   AND aba19 <> 'X' ",  #CHI-C80041
                 "   AND abaacti = 'Y'"
     IF tm.h = '2' THEN
        LET g_sql = g_sql CLIPPED, " AND aba19 = 'Y' "
     END IF
     IF tm.h = '3' THEN
        LET g_sql = g_sql CLIPPED, " AND abapost = 'Y' "
     END IF
     IF tm.e = 'Y' THEN
        LET g_sql= g_sql CLIPPED,"  AND abb24 = ? "
     END IF
 
     PREPARE gglg401_prepare4 FROM g_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE qjyd_curs1 CURSOR FOR gglg401_prepare4
 
     #No.FUN-7C0064  --Begin
     LET g_sql = "SELECT DISTINCT abb03 FROM abb_file ",
                 " WHERE abb01 = ? ", 
                 "   AND abb00 = '",g_aaa.aaa01,"'",
                 "   AND abb06 <> ? "
     PREPARE abb03_prepare2 FROM g_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80096   ADD
        CALL cl_gre_drop_temptable(l_table)                     #FUN-B40087
        EXIT PROGRAM
     END IF
     DECLARE abb03_curs2 CURSOR FOR abb03_prepare2
     
     #CALL cl_outnam('gglg401') RETURNING l_name
 
     #IF tm.e = 'N' THEN
     #   START REPORT gglg401_rep1 TO l_name
     #ELSE
     #   START REPORT gglg401_rep2 TO l_name
     #END IF
 
     #LET g_pageno = 0
     #CALL cl_prt_pos_len()
     IF tm.e = 'N' THEN 
         LET l_name = 'gglg401'
     ELSE
         LET l_name = 'gglg401_1'
     END IF
     #No.FUN-7C0064  --End  
 
     FOREACH gglg401_curs1 INTO sr1.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        CALL gglg401_qcye(sr1.aag01)      #期初余額
             RETURNING l_bal,l_bal2
        IF tm.a = 'N' THEN
           CALL gglg401_qjyd(sr1.aag01)
                RETURNING l_flag
           IF tm.e = 'N' THEN
              IF l_bal = 0 AND l_flag = 0 THEN
                 CONTINUE FOREACH
              END IF
           ELSE
              IF l_bal = 0 AND l_bal2 = 0 AND l_flag = 0 THEN
                 CONTINUE FOREACH
              END IF
           END IF
        END IF
#FUN-6C0012.....begin
#        CALL gglg401_sjkm(sr1.aag01)
#             RETURNING p_aag02
        IF tm.g ='1' THEN                                                       
           LET p_aag02 =NULL                                                    
        END IF                                                                  
        IF tm.g ='2' THEN                                                       
           SELECT aag02 INTO p_aag02 FROM aag_file                              
            WHERE aag01 =sr1.aag01        
              AND aag00 =g_aaa.aaa01   #No.FUN-740055  #No.FUN-7C0064
        END IF                                                                  
        IF tm.g ='3' THEN                                                       
           SELECT aag13 INTO p_aag02 FROM aag_file                              
            WHERE aag01 =sr1.aag01                                              
              AND aag00 =g_aaa.aaa01   #No.FUN-740055  #No.FUN-7C0064
        END IF
#FUN-6C0012.....end
 
        #No.FUN-7C0064  --Begin
        #打印"年初余額"還是"期初余額"的flag
        #CALL s_azm(yy,mm1) RETURNING l_flag,l_begin,l_end #CHI-A70007 mark
        #CHI-A70007 add --start--
        IF g_aza.aza63 = 'Y' THEN
           CALL s_azmm(yy,mm1,g_plant,g_aaa.aaa01) RETURNING l_flag,l_begin,l_end
        ELSE
           CALL s_azm(yy,mm1) RETURNING l_flag,l_begin,l_end 
        END IF
        #CHI-A70007 add --end--
        IF bdate = l_begin THEN
           LET l_type1 = '1'
        ELSE
           LET l_type1 = '2'
        END IF
        LET l_line = 1
        #No.FUN-7C0064  --End   
        IF mm1 = 1 THEN
           LET l_pageno = 1
        ELSE
           SELECT tpg04 INTO l_pageno FROM tpg_file
            WHERE tpg01 = YEAR(bdate)
              AND tpg02 = mm1 - 1
              AND tpg03 = sr1.aag01
               AND tpg05 = g_prog
           LET l_pageno = l_pageno + 1
        END IF
        FOR l_i = mm1 TO nn1
            #No.FUN-7C0064  --Begin
            #compute monthly summary & yearly summary
            CALL g401_cpt(sr1.aag01,l_i) RETURNING l_md,l_mdf,l_mc,l_mcf
            CALL g401_cpt1(sr1.aag01,l_i) RETURNING l_yd,l_ydf,l_yc,l_ycf
            #No.FUN-7C0064  --End
            LET g_cnt = 0
            LET l_flag='N'
            FOREACH gglg401_curs2 USING sr1.aag01,l_i INTO sr.*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               #No.FUN-7C0064  --Begin
               IF tm.e = 'Y' THEN
                  IF sr.abb24 <> tm.f THEN
                     CONTINUE FOREACH
                  END IF
               END IF
               #No.FUN-7C0064  --End  
               CALL s_azn01(yy,l_i) RETURNING l_date,l_date1
               LET l_flag='Y'
               LET sr.aag02=p_aag02
               LET sr.qcye = l_bal
               LET sr.qcyef = l_bal2

               #FUN-B40087-----add-----str--
               IF sr.abb06 = '1' THEN 
                  LET sr.abb07_1 = sr.abb07
               ELSE
                  LET sr.abb07_1 = 0
               END IF
               IF sr.abb06 = '2' THEN 
                  LET sr.abb07_2 = sr.abb07
               ELSE
                  LET sr.abb07_2 = 0
               END IF
               IF sr.abb06 = '1' THEN 
                  LET sr.abb07f_1 = sr.abb07f
               ELSE
                  LET sr.abb07f_1 = 0
               END IF
               IF sr.abb06 = '2' THEN 
                  LET sr.abb07f_2 = sr.abb07f
               ELSE
                  LET sr.abb07f_2 = 0
               END IF
               #FUN-B40087-----add-----end--

               #No.FUN-7C0064  --Begin
               SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file
                WHERE azi01 = sr.abb24
               CALL g401_abb03(sr.aba01,sr.abb06) RETURNING l_abb03_s
               #IF tm.e = 'N' THEN
               #   OUTPUT TO REPORT gglg401_rep1(sr.*)
               #ELSE
               #   OUTPUT TO REPORT gglg401_rep2(sr.*)
               #END IF
               LET l_line = l_line + 1
               EXECUTE insert_prep USING sr.*,l_abb03_s,l_md,l_mdf,l_mc,
                       l_mcf,l_yd,l_ydf,l_yc,l_ycf,t_azi04,t_azi07,nn1,
                       l_pageno
               #No.FUN-7C0064  --End
            END FOREACH
            LET l_line = l_line + 2  #No.FUN-7C0064
            IF l_flag = "N" THEN  #當期沒異動
               LET sr.mm = l_i
               LET sr.aag01 = sr1.aag01
               LET sr.aag02 = p_aag02
               LET sr.aba01 = NULL
               LET sr.aba02 = NULL
               LET sr.abb02 = NULL
               LET sr.abb04 = NULL
               LET sr.abb24 = NULL
               LET sr.abb25 = NULL
               LET sr.abb06 = NULL
               LET sr.abb07 = 0    #No.FUN-7C0064
               LET sr.abb07f= 0    #No.FUN-7C0064
               LET sr.qcye = l_bal
               LET sr.qcyef = l_bal2
               LET l_abb03_s = NULL   #No.FUN-7C0064
               #FUN-B40087-----add-----str--
               IF sr.abb06 = '1' THEN 
                  LET sr.abb07_1 = sr.abb07
               ELSE
                  LET sr.abb07_1 = 0
               END IF
               IF sr.abb06 = '2' THEN 
                  LET sr.abb07_2 = sr.abb07
               ELSE
                  LET sr.abb07_2 = 0
               END IF
               IF sr.abb06 = '1' THEN 
                  LET sr.abb07f_1 = sr.abb07f
               ELSE
                  LET sr.abb07f_1 = 0
               END IF
               IF sr.abb06 = '2' THEN 
                  LET sr.abb07f_2 = sr.abb07f
               ELSE
                  LET sr.abb07f_2 = 0
               END IF
               #FUN-B40087-----add-----end--

               #No.FUN-7C0064  --Begin
               #IF tm.e = 'N' THEN
               #   OUTPUT TO REPORT gglg401_rep1(sr.*)
               #ELSE
               #   OUTPUT TO REPORT gglg401_rep2(sr.*)
               #END IF
               EXECUTE insert_prep USING sr.*,l_abb03_s,l_md,l_mdf,l_mc,
                       l_mcf,l_yd,l_ydf,l_yc,l_ycf,'0','0',nn1,
                       l_pageno
               #No.FUN-7C0064  --End  
            END IF
            #No.FUN-7C0064  --Begin
            IF l_line > 30 THEN
               LET l_pageno = l_pageno + 1
               LET l_line = 0
            END IF
            UPDATE tpg_file SET tpg04 = l_pageno
             WHERE tpg01 = YEAR(bdate)
               AND tpg02 = l_i
               AND tpg03 = sr1.aag01
               AND tpg05 = g_prog 
            #No.FUN-7C0064  --End  
        END FOR
     END FOREACH
     #No.FUN-7C0064  --Begin
     #IF tm.e = 'N' THEN
     #   FINISH REPORT gglg401_rep1
     #ELSE
     #   FINISH REPORT gglg401_rep2
     #END IF
     #CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###GENGRE###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     LET g_str = ''
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc1,'aag01')
             RETURNING g_str
     END IF
###GENGRE###     LET g_str = g_str,";",YEAR(bdate),";",g_azi04,";",l_type1
###GENGRE###     CALL cl_prt_cs3('gglg401',l_name,g_sql,g_str)

  
    CALL gglg401_grdata()    ###GENGRE###
     #No.FUN-7C0064  --End 

     #No.FUN-B80096--mark--Begin---
     #CALL cl_used(g_prog,g_time,2) RETURNING g_time
     #No.FUN-B80096--mark--End-----
 
     CALL cl_gre_drop_temptable(l_table)
END FUNCTION
#FUN-6C0012.....begin mark
#FUNCTION gglg401_sjkm(l_aag01)   #追溯上級科目名稱且將其連成一體
#   DEFINE l_aag24 LIKE aag_file.aag24
#   DEFINE l_aag01 LIKE aag_file.aag01
#   DEFINE s_aag08 LIKE aag_file.aag08
#   DEFINE s_aag24 LIKE aag_file.aag24
#   DEFINE s_aag02 LIKE aag_file.aag02
#   DEFINE p_aag02,p_aag021    LIKE type_file.chr1000
#   DEFINE l_success,l_i       LIKE type_file.num5  
 
#   LET p_aag02 = NULL
#   LET l_success = 1
#   LET l_i = 1
#   WHILE l_success
#   SELECT aag02,aag08,aag24 INTO s_aag02,s_aag08,s_aag24 FROM aag_file
#    WHERE aag01 = l_aag01
#   IF SQLCA.sqlcode THEN
#      LET l_success = 0
#      EXIT WHILE
#   END IF
#   IF l_i = 1 THEN
#      LET p_aag02 = s_aag02
#   ELSE
#      LET p_aag021 = p_aag02
#      LET p_aag02 = s_aag02 CLIPPED,'-',p_aag021 CLIPPED
#   END IF
#   LET l_i = l_i + 1
#   IF s_aag24 = 1 OR s_aag08 = l_aag01 THEN LET l_success = 1 EXIT WHILE END IF
#   LET l_aag01 = s_aag08
#   END WHILE
#   RETURN p_aag02   #結果
#END FUNCTION
#FUN-6C0012.....end
FUNCTION gglg401_qcye(l_aag01)   #計算列印期間前的余額
   DEFINE l_aag01 LIKE aag_file.aag01
   DEFINE l_bal,l_bal1,l_bal2,n_bal,n_bal1,l_d,l_c,l_d1,l_c1 LIKE type_file.num20_6 
   LET l_bal = 0
   LET l_bal1 = 0
   LET l_d = 0
   LET l_d1 = 0
   LET l_c = 0
   LET l_c1 = 0
   LET n_bal = 0
   LET n_bal1 = 0
   IF tm.e = "N" THEN
      IF g_aaz.aaz51 = 'Y' THEN   #每日餘額檔
         SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
          WHERE aah01 = l_aag01 AND aah02 = yy AND aah03 = 0
            AND aah00 = g_aaa.aaa01
         SELECT SUM(aas04-aas05) INTO l_bal1   FROM aas_file
          WHERE aas00 = g_aaa.aaa01 AND aas01 = l_aag01
            AND YEAR(aas02) = yy AND aas02 < bdate
      ELSE
         SELECT SUM(aah04-aah05) INTO l_bal FROM aah_file
          WHERE aah01 = l_aag01 AND aah02 = yy AND aah03 < mm
            AND aah00 = g_aaa.aaa01
         SELECT SUM(abb07) INTO l_d FROM abb_file,aba_file
          WHERE abb03 = l_aag01 AND aba01 = abb01 AND abb06='1'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = g_aaa.aaa01 AND abapost='Y'
            AND aba03=yy AND aba04=mm
         SELECT SUM(abb07) INTO l_c FROM aba_file,abb_file
          WHERE abb03 = l_aag01 AND aba01 = abb01 AND abb06='2'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = g_aaa.aaa01 AND abapost='Y'
            AND aba03=yy AND aba04=mm
      END IF
   ELSE
      IF g_aaz.aaz51 = 'Y' THEN   #每日餘額檔
         SELECT SUM(tah04-tah05),SUM(tah09-tah10)
           INTO l_bal,n_bal FROM tah_file
          WHERE tah01 = l_aag01 AND tah02 = yy AND tah03 = 0
            AND tah00 = g_aaa.aaa01
            AND tah08 = tm.f
         SELECT SUM(tas04-tas05),SUM(tas09-tas10)
           INTO l_bal1,n_bal1 FROM tas_file
          WHERE tas00 = g_aaa.aaa01 AND tas01 = l_aag01
            AND YEAR(tas02) = yy AND tas02 < bdate
            AND tas08 = tm.f
      ELSE
         SELECT SUM(tah04-tah05),SUM(tah09-tah10)
           INTO l_bal,n_bal FROM tah_file
          WHERE tah01 = l_aag01 AND tah02 = yy AND tah03 < mm
            AND tah00 = g_aaa.aaa01
            AND tah08 = tm.f
         SELECT SUM(abb07),SUM(abb07f)
           INTO l_d,l_d1 FROM abb_file,aba_file
          WHERE abb03 = l_aag01 AND aba01 = abb01 AND abb06='1'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = g_aaa.aaa01 AND abapost='Y'
            AND aba03=yy AND aba04=mm
            AND abb24 = tm.f
         SELECT SUM(abb07),SUM(abb07f)
           INTO l_c,l_c1 FROM aba_file,abb_file
          WHERE abb03 = l_aag01 AND aba01 = abb01 AND abb06='2'
            AND aba02 < bdate AND abb00 = aba00
            AND aba00 = g_aaa.aaa01 AND abapost='Y'
            AND aba03=yy AND aba04=mm
            AND abb24 = tm.f
      END IF
   END IF
 
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   IF cl_null(l_bal1) THEN LET l_bal1 = 0 END IF
   IF cl_null(n_bal) THEN LET n_bal = 0 END IF
   IF cl_null(n_bal1) THEN LET n_bal1 = 0 END IF
   IF cl_null(l_d) THEN LET l_d = 0 END IF
   IF cl_null(l_c) THEN LET l_c = 0 END IF
   IF cl_null(l_d1) THEN LET l_d1 = 0 END IF
   IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
   LET l_bal = l_bal + l_d - l_c + l_bal1   # 期初餘額
   LET l_bal2 = n_bal + l_d1 - l_c1 + n_bal1
   IF cl_null(l_bal) THEN LET l_bal = 0 END IF
   IF cl_null(l_bal2) THEN LET l_bal2 = 0 END IF
 
   IF tm.h <> '3' THEN
      IF tm.e = 'N' THEN
         OPEN qcye_curs1 USING l_aag01,'1'
         FETCH qcye_curs1 INTO l_d,l_d1
         OPEN qcye_curs1 USING l_aag01,'2'
         FETCH qcye_curs1 INTO l_c,l_c1
      ELSE
         OPEN qcye_curs1 USING l_aag01,'1',tm.f
         FETCH qcye_curs1 INTO l_d,l_d1
         OPEN qcye_curs1 USING l_aag01,'2',tm.f
         FETCH qcye_curs1 INTO l_c,l_c1
      END IF
      IF cl_null(l_d) THEN LET l_d = 0 END IF
      IF cl_null(l_c) THEN LET l_c = 0 END IF
      IF cl_null(l_d1) THEN LET l_d1 = 0 END IF
      IF cl_null(l_c1) THEN LET l_c1 = 0 END IF
      LET l_bal = l_bal+l_d-l_c
      LET l_bal2 = l_bal2+l_d1-l_c1
   END IF
 
   RETURN l_bal,l_bal2
END FUNCTION
 
FUNCTION gglg401_qjyd(l_aag01)
   DEFINE l_aag01     LIKE aag_file.aag01
   DEFINE l_flag      LIKE type_file.num5  
   DEFINE l_num,n_num LIKE abb_file.abb07
   DEFINE l_num_1     LIKE abb_file.abb07  #No.FUN-7C0064
   DEFINE n_num_1     LIKE abb_file.abb07  #No.FUN-7C0064
   
   LET l_flag = 0
   #No.FUN-7C0064  --Begin
   LET l_num = 0    LET l_num_1 = 0
   LET n_num = 0    LET n_num_1 = 0 
   #No.FUN-7C0064  --End
   IF tm.e = 'N' THEN
      #No.FUN-7C0064  --Begin
      OPEN qjyd_curs1 USING l_aag01,bdate,edate,'1'
      FETCH qjyd_curs1 INTO l_num,n_num
      OPEN qjyd_curs1 USING l_aag01,bdate,edate,'2'
      FETCH qjyd_curs1 INTO l_num_1,n_num_1
      IF cl_null(l_num) THEN LET l_num = 0 END IF
      IF cl_null(l_num_1) THEN LET l_num_1 = 0 END IF
      IF l_num <> 0 OR l_num_1 <> 0 THEN
         LET l_flag = 1
      END IF
      #No.FUN-7C0064  --End
   ELSE
      #No.FUN-7C0064  --Begin
      OPEN qjyd_curs1 USING l_aag01,bdate,edate,'1',tm.f
      FETCH qjyd_curs1 INTO l_num,n_num
      OPEN qjyd_curs1 USING l_aag01,bdate,edate,'2',tm.f
      FETCH qjyd_curs1 INTO l_num_1,n_num_1
      IF cl_null(l_num) THEN LET l_num = 0 END IF
      IF cl_null(l_num_1) THEN LET l_num_1 = 0 END IF
      IF cl_null(n_num) THEN LET n_num = 0 END IF
      IF cl_null(n_num_1) THEN LET n_num_1 = 0 END IF
      IF l_num <> 0 OR l_num_1 <> 0 OR n_num <> 0 OR n_num_1 <> 0THEN
         LET l_flag = 1
      END IF
      #No.FUN-7C0064  --End
   END IF
   RETURN l_flag
END FUNCTION
 
#No.FUN-7C0064  --Begin
#monthly qjyd
FUNCTION g401_cpt(p_aag01,p_i)
  DEFINE p_aag01   LIKE aag_file.aag01
  DEFINE p_i       LIKE type_file.num5
  DEFINE l_bdate   LIKE aba_file.aba02
  DEFINE l_edate   LIKE aba_file.aba02
  DEFINE l_flag    LIKE type_file.chr1
  DEFINE l_num     LIKE abb_file.abb07
  DEFINE l_num1    LIKE abb_file.abb07
  DEFINE r_num     LIKE abb_file.abb07
  DEFINE r_num1    LIKE abb_file.abb07
  
    LET l_num = 0   LET l_num1 = 0
    LET r_num = 0   LET r_num1 = 0
    #CALL s_azm(yy,p_i) RETURNING l_flag,l_bdate,l_edate #CHI-A70007 mark
    #CHI-A70007 add --start--
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(yy,p_i,g_plant,g_aaa.aaa01) RETURNING l_flag,l_bdate,l_edate
    ELSE
       CALL s_azm(yy,p_i) RETURNING l_flag,l_bdate,l_edate 
    END IF
    #CHI-A70007 add --end--
    IF tm.e = 'N' THEN
      OPEN qjyd_curs1 USING p_aag01,l_bdate,l_edate,'1'
      FETCH qjyd_curs1 INTO l_num,l_num1
      OPEN qjyd_curs1 USING p_aag01,l_bdate,l_edate,'2'
      FETCH qjyd_curs1 INTO r_num,r_num1
   ELSE
      OPEN qjyd_curs1 USING p_aag01,l_bdate,l_edate,'1',tm.f
      FETCH qjyd_curs1 INTO l_num,l_num1
      OPEN qjyd_curs1 USING p_aag01,l_bdate,l_edate,'2',tm.f
      FETCH qjyd_curs1 INTO r_num,r_num1
   END IF
   IF cl_null(l_num)  THEN LET l_num  = 0 END IF
   IF cl_null(l_num1) THEN LET l_num1 = 0 END IF
   IF cl_null(r_num)  THEN LET r_num  = 0 END IF
   IF cl_null(r_num1) THEN LET r_num1 = 0 END IF
 
   RETURN l_num,l_num1,r_num,r_num
 
END FUNCTION
 
#yearly qjyd
FUNCTION g401_cpt1(p_aag01,p_i)
  DEFINE p_aag01   LIKE aag_file.aag01
  DEFINE p_i       LIKE type_file.num5
  DEFINE l_bdate   LIKE aba_file.aba02
  DEFINE l_edate   LIKE aba_file.aba02
  DEFINE l_bdate1  LIKE aba_file.aba02
  DEFINE l_edate1  LIKE aba_file.aba02
  DEFINE l_flag    LIKE type_file.chr1
  DEFINE l_num     LIKE abb_file.abb07
  DEFINE l_num1    LIKE abb_file.abb07
  DEFINE r_num     LIKE abb_file.abb07
  DEFINE r_num1    LIKE abb_file.abb07
  
    LET l_num = 0   LET l_num1 = 0
    LET r_num = 0   LET r_num1 = 0
  
    #CALL s_azm(yy,1) RETURNING l_flag,l_bdate1,l_edate1 #CHI-A70007 mark
    #CHI-A70007 add --start--
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(yy,1,g_plant,g_aaa.aaa01) RETURNING l_flag,l_bdate1,l_edate1
    ELSE
       CALL s_azm(yy,1) RETURNING l_flag,l_bdate1,l_edate1
    END IF
    #CHI-A70007 add --end--
    #CALL s_azm(yy,p_i) RETURNING l_flag,l_bdate,l_edate  #CHI-A70007 mark
    #CHI-A70007 add --start--
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(yy,p_i,g_plant,g_aaa.aaa01) RETURNING l_flag,l_bdate,l_edate
    ELSE
       CALL s_azm(yy,p_i) RETURNING l_flag,l_bdate,l_edate 
    END IF
    #CHI-A70007 add --end--
    IF tm.e = 'N' THEN
       OPEN qjyd_curs1 USING p_aag01,l_bdate1,l_edate,'1'
       FETCH qjyd_curs1 INTO l_num,l_num1
       OPEN qjyd_curs1 USING p_aag01,l_bdate1,l_edate,'2'
       FETCH qjyd_curs1 INTO r_num,r_num1
    ELSE
       OPEN qjyd_curs1 USING p_aag01,l_bdate1,l_edate,'1',tm.f
       FETCH qjyd_curs1 INTO l_num,l_num1
       OPEN qjyd_curs1 USING p_aag01,l_bdate1,l_edate,'2',tm.f
       FETCH qjyd_curs1 INTO r_num,r_num1
    END IF
 
    IF cl_null(l_num)  THEN LET l_num  = 0 END IF
    IF cl_null(l_num1) THEN LET l_num1 = 0 END IF
    IF cl_null(r_num)  THEN LET r_num  = 0 END IF
    IF cl_null(r_num1) THEN LET r_num1 = 0 END IF
    RETURN l_num,l_num1,r_num,r_num
 
END FUNCTION
#No.FUN-7C0064  --End
 
#No.FUN-7C0064  --Begin
#REPORT gglg401_rep1(sr)
#   DEFINE
#          sr     RECORD
#                 aag01  LIKE aag_file.aag01,
#                 aag02  LIKE aag_file.aag02,
#                 mm     LIKE type_file.num10,
#                 aba01  LIKE aba_file.aba01,
#                 aba02  LIKE aba_file.aba02,
#                 abb02  LIKE abb_file.abb02,
#                 abb04  LIKE abb_file.abb04,
#                 abb24  LIKE abb_file.abb24,
#                 abb25  LIKE abb_file.abb25,
#                 abb06  LIKE abb_file.abb06,
#                 abb07  LIKE abb_file.abb07,
#                 abb07f LIKE abb_file.abb07f,
#                 qcye   LIKE abb_file.abb07,
#                 qcyef  LIKE abb_file.abb07 
#                 END RECORD,
#          l_abb03                      LIKE abb_file.abb03,
#          m_abb03,t_abb03              LIKE type_file.chr1000,
#          m_abb03t,t_abb03t            LIKE type_file.chr1000,
#          l_aag02                      LIKE aag_file.aag02,
#          l_aag13                      LIKE aag_file.aag13,
#          l_aag01                      LIKE aag_file.aag01,
#          l_aba02                      LIKE aba_file.aba02,
#	  l_abb07,t_abb07              LIKE type_file.num20_6,
#	  l_abb07_day,t_abb07_day      LIKE type_file.num20_6,
#	  l_abb07_dsum,t_abb07_dsum    LIKE type_file.num20_6,
#	  l_abb07_sum,t_abb07_sum      LIKE type_file.num20_6,
#          l_mm                         LIKE type_file.num10,
#          l_n                          LIKE type_file.num10,
#          l_i,l_aba02t                 LIKE type_file.num10,
#          l_qcye                       LIKE type_file.num20_6,
#          l_sum ,t_sum                 LIKE type_file.num20_6,
#          l_sum1,t_sum1                LIKE type_file.num20_6,
#          l_begin,l_end                LIKE type_file.dat
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN 0
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.aag01,sr.mm,sr.aba02
#
#  FORMAT
#    FIRST PAGE HEADER
#      LET l_aag01 = sr.aag01
#      IF sr.mm = 1 THEN
#         LET g_pageno = 0
#      ELSE
#         SELECT tpg04 INTO g_pageno FROM tpg_file
#          WHERE tpg01 = YEAR(bdate)
#            AND tpg02 = sr.mm - 1
#            AND tpg03 = sr.aag01
#            AND tpg05 = g_prog
#      END IF
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#      LET g_pageno = g_pageno+1
#      LET l_n = (170-(LENGTH(sr.aag01)+LENGTH(sr.aag02)+9))/2
#      PRINT '~T28X0L19.05947;';
#      PRINT COLUMN 68,sr.aag01,'(',sr.aag02,')',' ',g_x[1]
#      PRINT COLUMN 68,YEAR(bdate)
#      PRINT COLUMN 118,g_pageno
#      PRINT
#      PRINT
#   
#    PAGE HEADER
#      IF sr.mm = 1 THEN
#         LET g_pageno = 0
#      ELSE
#         SELECT tpg04 INTO g_pageno FROM tpg_file
#          WHERE tpg01 = YEAR(bdate)
#            AND tpg02 = sr.mm - 1
#            AND tpg03 = sr.aag01
#            AND tpg05 = g_prog
#      END IF
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#      PRINT COLUMN 58,sr.aag01,'(',sr.aag02,')',' ',g_x[1]
#      PRINT COLUMN 68,YEAR(bdate)
#      IF l_aag01 <> sr.aag01 THEN
#         LET g_pageno = 0
#         LET l_aag01 = sr.aag01
#      END IF
#      LET g_pageno = g_pageno+1
#      PRINT COLUMN 118,g_pageno
#      PRINT
#      PRINT
# 
#   BEFORE GROUP OF sr.aag01
#      SKIP TO TOP OF PAGE
#      LET l_aba02 = sr.aba02
#      LET l_mm = MONTH(sr.aba02)
#      LET l_abb07 = 0
#      LET t_abb07 = 0
#      LET l_abb07_day = 0
#      LET t_abb07_day = 0
#      LET l_abb07_sum = 0
#      LET t_abb07_sum = 0
#      LET l_abb07_dsum = 0   #No.TQC-710095
#      LET t_abb07_dsum = 0   #No.TQC-710095
#      LET l_qcye = sr.qcye
#      LET l_sum = 0
#      LET t_sum = 0
#      LET l_sum1= 0
#      LET t_sum1= 0
#      LET l_i = 0
#      LET g_pageno = 0
#      IF sr.mm = 1 THEN
#         LET g_pageno = 0
#      ELSE
#         SELECT tpg04 INTO g_pageno FROM tpg_file
#          WHERE tpg01 = YEAR(bdate)
#            AND tpg02 = sr.mm - 1
#            AND tpg03 = sr.aag01
#            AND tpg05 = g_prog
#      END IF
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#      LET g_pageno = g_pageno+1
#      CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end 
#      IF bdate = l_begin THEN
#         PRINT COLUMN 29,g_x[6];
#      ELSE
#         PRINT COLUMN 29,g_x[7];
#      END IF
#      IF sr.qcye > 0 THEN PRINT COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(sr.qcye),13,g_azi04) END IF
#      IF sr.qcye = 0 THEN PRINT COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(sr.qcye),13,g_azi04) END IF 
#      IF sr.qcye < 0 THEN PRINT COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(sr.qcye),13,g_azi04) END IF
#
#   ON EVERY ROW
#      IF NOT cl_null(sr.aba01) THEN
#        #IF cl_null(l_abb07) THEN LET l_abb07_day = 0 END IF       #No.TQC-710095 mark
#        #IF cl_null(t_abb07) THEN LET t_abb07_day = 0 END IF       #No.TQC-710095 mark
#         IF cl_null(l_abb07_day) THEN LET l_abb07_day = 0 END IF   #No.TQC-710095
#         IF cl_null(t_abb07_day) THEN LET t_abb07_day = 0 END IF   #No.TQC-710095
#         IF cl_null(l_abb07_sum) THEN LET l_abb07_sum = 0 END IF
#         IF cl_null(t_abb07_sum) THEN LET t_abb07_sum = 0 END IF
#         IF LINENO =34 THEN
#            IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            SKIP TO TOP OF PAGE
#            IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#            IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#            IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#         END IF
#         LET g_sql = "SELECT DISTINCT abb03 FROM abb_file ",
#                     " WHERE abb01 = '",sr.aba01,"'", 
#                     "   AND abb00 = '",g_aaa.aaa01,"'",
#                     "   AND abb06 <> '",sr.abb06,"'"
#         PREPARE abb03_prepare1 FROM g_sql
#         IF SQLCA.sqlcode != 0 THEN
#            CALL cl_err('prepare:',SQLCA.sqlcode,1)
#            EXIT PROGRAM
#         END IF
#         DECLARE abb03_curs1 CURSOR FOR abb03_prepare1
#         FOREACH abb03_curs1 INTO l_abb03 
#            IF tm.g ='1' THEN 
#               IF cl_null(t_abb03) THEN
#                  LET t_abb03 = l_abb03
#               ELSE
#                  LET t_abb03 = t_abb03 CLIPPED,',',l_abb03 CLIPPED
#               END IF
#               IF LENGTH(t_abb03)>24 AND LENGTH(t_abb03t) <= 24 THEN
#                  EXIT FOREACH
#               END IF
#               LET t_abb03t = t_abb03
#            END IF
#            IF tm.g = '2' THEN
#               SELECT aag02 INTO l_aag02 FROM aag_file
#                WHERE aag01 = l_abb03
#                  AND aag00 =g_aaa.aaa01     #No.FUN-740055                                       
#               IF cl_null(m_abb03) THEN
#                  LET m_abb03 = l_abb03 CLIPPED,'(',l_aag02 CLIPPED,')'
#               ELSE
#                  LET m_abb03 = m_abb03 CLIPPED,',',l_abb03 CLIPPED,'(',l_aag02 CLIPPED,')'
#               END IF
#               IF LENGTH(m_abb03)>17 AND LENGTH(m_abb03t) <= 17 THEN
#                  EXIT FOREACH
#               END IF
#               LET m_abb03t = m_abb03
#            END IF
#            #FUN-6C0012.....begin
#            IF tm.g = '3' THEN                                                  
#               SELECT aag13 INTO l_aag13 FROM aag_file                          
#                WHERE aag01 = l_abb03          
#                  AND aag00 = g_aaa.aaa01   #No.FUN-740055                                 
#               IF cl_null(m_abb03) THEN                                         
#                  LET m_abb03 = l_abb03 CLIPPED,'(',l_aag13 CLIPPED,')'         
#               ELSE                                                             
#                  LET m_abb03 = m_abb03 CLIPPED,',',l_abb03 CLIPPED,'(',l_aag13 
#               END IF                                                           
#               IF LENGTH(m_abb03)>17 AND LENGTH(m_abb03t) <=17 THEN             
#                  EXIT FOREACH                                                  
#               END IF                                                           
#               LET m_abb03t = m_abb03                                           
#            END IF
#            #FUN-6C0012.....end
#         END FOREACH
#         PRINT COLUMN 15,MONTH(sr.aba02) USING '<<',COLUMN 18,DAY(sr.aba02) USING '<<',COLUMN 21,sr.aba01 CLIPPED,COLUMN 34,sr.abb04;
#         IF tm.g ='1' THEN
#            PRINT COLUMN 66,t_abb03t[1,17]; #FUN-6C0012
#         END IF   #FUN-6C0012
##        ELSE     #FUN-6C0012
#         IF tm.g ='2' THEN #FUN-6C0012
#            PRINT COLUMN 66,m_abb03t[1,17]; #FUN-6C0012
#         END IF
#         #FUN-6C0012.....begin
#         IF tm.g ='3' THEN                                                      
#            IF cl_null(m_abb03t) THEN                                           
#               LET m_abb03t=m_abb03                                             
#            END IF                                                              
#            PRINT COLUMN 66,m_abb03t[1,17]; #FUN-6C0012                                           
#         END IF
#         #FUN-6C0012.....end
#         IF sr.abb06 ='1' THEN
#            LET l_qcye = l_qcye+sr.abb07
#            IF l_qcye > 0 THEN PRINT COLUMN 84,cl_numfor(sr.abb07,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye = 0 THEN PRINT COLUMN 84,cl_numfor(sr.abb07,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye < 0 THEN PRINT COLUMN 84,cl_numfor(sr.abb07,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#         ELSE
#            LET l_qcye = l_qcye-sr.abb07
#            IF l_qcye > 0 THEN PRINT COLUMN 99,cl_numfor(sr.abb07,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye = 0 THEN PRINT COLUMN 99,cl_numfor(sr.abb07,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye < 0 THEN PRINT COLUMN 99,cl_numfor(sr.abb07,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#         END IF
#         IF l_aba02 = sr.aba02  THEN
#            LET l_abb07_day = 0  #No.TQC-710095
#            LET t_abb07_day = 0  #No.TQC-710095
#            IF sr.abb06 = '1' THEN
#               LET l_abb07_day = l_abb07_day + sr.abb07   #借方金額合計
#            ELSE
#               LET t_abb07_day = t_abb07_day + sr.abb07   #貸方金額合計
#            END IF
#         ELSE
#            LET l_aba02 = sr.aba02
#            LET l_abb07_day = 0
#            LET t_abb07_day = 0
#            IF sr.abb06 = '1' THEN
#               LET l_abb07_day = l_abb07_day + sr.abb07   #借方金額合計
#            ELSE
#               LET t_abb07_day = t_abb07_day + sr.abb07   #貸方金額合計
#            END IF
#         END IF
#         LET l_abb07_dsum = l_abb07_dsum + l_abb07_day
#         LET t_abb07_dsum = t_abb07_dsum + t_abb07_day
#         LET t_abb03 = NULL
#         LET m_abb03 = NULL
#         LET l_i = l_i + 1   
#      END IF
# 
#   AFTER GROUP OF sr.aba02
#         IF NOT cl_null(sr.aba01) THEN
#            IF tm.h = '1' THEN
#               SELECT SUM(abb07) INTO l_abb07 FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '1'
#                  AND abaacti = 'Y'
#               SELECT SUM(abb07) INTO t_abb07 FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '2'
#                  AND abaacti = 'Y'
#            END IF
#            IF tm.h = '2' THEN
#               SELECT SUM(abb07) INTO l_abb07 FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '1'
#                  AND abaacti = 'Y'
#                  AND aba19 = 'Y'
#               SELECT SUM(abb07) INTO t_abb07 FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '2'
#                  AND abaacti = 'Y'
#                  AND aba19 = 'Y'
#            END IF
#            IF tm.h = '3' THEN
#               SELECT SUM(abb07) INTO l_abb07 FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '1'
#                  AND abaacti = 'Y'
#                  AND abapost = 'Y'
#               SELECT SUM(abb07) INTO t_abb07 FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '2'
#                  AND abaacti = 'Y'
#                  AND abapost = 'Y'
#            END IF
#            IF cl_null(l_abb07) THEN LET l_abb07 = 0 END IF
#            IF cl_null(t_abb07) THEN LET t_abb07 = 0 END IF
#            LET l_abb07_sum = l_abb07_sum + l_abb07
#            LET t_abb07_sum = t_abb07_sum + t_abb07
#            IF cl_null(l_abb07_sum) THEN LET l_abb07_sum = 0 END IF
#            IF cl_null(t_abb07_sum) THEN LET t_abb07_sum = 0 END IF
#            IF LINENO >= 34 THEN
#               IF l_mm <> MONTH(sr.aba02) THEN
#                  IF LINENO = 32 THEN
#                     PRINT
#                     PRINT
#                     IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     SKIP TO TOP OF PAGE
#                     IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                  END IF
#                  IF LINENO = 33 THEN
#                     PRINT
#                     IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     SKIP TO TOP OF PAGE
#                     IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                  END IF
#                  LET l_mm = MONTH(sr.aba02)
#               ELSE
#                  IF LINENO =34 THEN 
#                     IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     SKIP TO TOP OF PAGE
#                     IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                  END IF
#               END IF
#            END IF
#         END IF
#         IF NOT cl_null(sr.aba01) THEN
#            IF tm.h ='1' THEN
#               SELECT COUNT(aba02) INTO l_aba02t FROM aba_file,abb_file
#                WHERE aba00 = abb_file.abb00
#                  AND aba01 = abb_file.abb01
#                  AND abb03 = sr.aag01
#                  AND aba04 = sr.mm
#                  AND aba03 = YEAR(sr.aba02)
#                  AND abb00 = g_aaa.aaa01
#                  AND abaacti = 'Y'
#            END IF
#            IF tm.h ='2' THEN
#               SELECT COUNT(aba02) INTO l_aba02t FROM aba_file,abb_file
#                WHERE aba00 = abb_file.abb00
#                  AND aba01 = abb_file.abb01
#                  AND abb03 = sr.aag01
#                  AND aba04 = sr.mm
#                  AND aba03 = YEAR(sr.aba02)
#                  AND abb00 = g_aaa.aaa01
#                  AND abaacti = 'Y'
#                  AND aba19 = 'Y'
#            END IF
#            IF tm.h ='3' THEN
#               SELECT COUNT(aba02) INTO l_aba02t FROM aba_file,abb_file
#                WHERE aba00 = abb_file.abb00
#                  AND aba01 = abb_file.abb01
#                  AND abb03 = sr.aag01
#                  AND aba04 = sr.mm
#                  AND aba03 = YEAR(sr.aba02)
#                  AND abb00 = g_aaa.aaa01
#                  AND abaacti = 'Y'
#                  AND abapost = 'Y'
#            END IF
#            IF l_i = l_aba02t THEN
#               IF tm.h = '1' THEN
#                  SELECT SUM(abb07) INTO l_sum FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                  SELECT SUM(abb07) INTO t_sum FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                  SELECT SUM(abb07) INTO l_sum1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                  SELECT SUM(abb07) INTO t_sum1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#               END IF
#               IF tm.h = '2' THEN
#                  SELECT SUM(abb07) INTO l_sum FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#                  SELECT SUM(abb07) INTO t_sum FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#                  SELECT SUM(abb07) INTO l_sum1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#                  SELECT SUM(abb07) INTO t_sum1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#               END IF
#               IF tm.h = '3' THEN
#                  SELECT SUM(abb07) INTO l_sum FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#                  SELECT SUM(abb07) INTO t_sum FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#                  SELECT SUM(abb07) INTO l_sum1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#                  SELECT SUM(abb07) INTO t_sum1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#               END IF
#               IF cl_null(l_sum) THEN LET l_sum = 0 END IF
#               IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
#               IF cl_null(t_sum) THEN LET t_sum = 0 END IF
#               IF cl_null(t_sum1) THEN LET t_sum1 = 0 END IF
#               PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[11],COLUMN 84,cl_numfor(l_sum,13,g_azi04),COLUMN 99,cl_numfor(t_sum,13,g_azi04);
#               IF l_qcye > 0 THEN 
#                  PRINT COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#                  PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[12],COLUMN 84,cl_numfor(l_sum1,13,g_azi04),COLUMN 99,cl_numfor(t_sum1,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#               END IF
#               IF l_qcye = 0 THEN 
#                  PRINT COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#                  PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[12],COLUMN 84,cl_numfor(l_sum1,13,g_azi04),COLUMN 99,cl_numfor(t_sum1,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#               END IF
#               IF l_qcye < 0 THEN 
#                  PRINT COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#                  PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[12],COLUMN 84,cl_numfor(l_sum1,13,g_azi04),COLUMN 99,cl_numfor(t_sum1,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#               END IF
#               LET l_sum =0
#               LET t_sum =0
#               LET l_i = 0
#            END IF
#         ELSE
#            IF LINENO > 32 THEN
#               IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#               IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#               IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[9],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#               SKIP TO TOP OF PAGE
#               IF l_qcye > 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#               IF l_qcye = 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#               IF l_qcye < 0 THEN PRINT COLUMN 29,g_x[8],COLUMN 84,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 99,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#            END IF
#            PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[11],COLUMN 84,cl_numfor(l_sum,13,g_azi04),COLUMN 99,cl_numfor(t_sum,13,g_azi04);
#            IF l_qcye > 0 THEN 
#               PRINT COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#               PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[12],COLUMN 84,cl_numfor(l_sum1,13,g_azi04),COLUMN 99,cl_numfor(t_sum1,13,g_azi04),COLUMN 114,g_x[2],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#            END IF
#            IF l_qcye = 0 THEN 
#               PRINT COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#               PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[12],COLUMN 84,cl_numfor(l_sum1,13,g_azi04),COLUMN 99,cl_numfor(t_sum1,13,g_azi04),COLUMN 114,g_x[3],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#            END IF
#            IF l_qcye < 0 THEN 
#               PRINT COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#               PRINT COLUMN 15,sr.mm USING '<<',COLUMN 29,g_x[12],COLUMN 84,cl_numfor(l_sum1,13,g_azi04),COLUMN 99,cl_numfor(t_sum1,13,g_azi04),COLUMN 114,g_x[4],COLUMN 117,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#            END IF
#         END IF
#            SELECT * FROM tpg_file 
#             WHERE tpg01 = YEAR(bdate)
#               AND tpg02 = sr.mm
#               AND tpg03 = sr.aag01
#               AND tpg05 = g_prog 
#            IF SQLCA.sqlcode THEN
#               INSERT INTO tpg_file VALUES(YEAR(bdate),sr.mm,sr.aag01,g_pageno,g_prog,'','')
#            ELSE
#               UPDATE tpg_file SET tpg04 = g_pageno
#                WHERE tpg01 = YEAR(bdate)
#                  AND tpg02 = sr.mm
#                  AND tpg03 = sr.aag01
#                  AND tpg05 = g_prog 
#            END IF
#END REPORT
# 
#REPORT gglg401_rep2(sr)
#   DEFINE
#          sr     RECORD
#                 aag01  LIKE aag_file.aag01,
#                 aag02  LIKE aag_file.aag02,
#                 mm     LIKE type_file.num10,
#                 aba01  LIKE aba_file.aba01,
#                 aba02  LIKE aba_file.aba02,
#                 abb02  LIKE abb_file.abb02,
#                 abb04  LIKE abb_file.abb04,
#                 abb24  LIKE abb_file.abb24,
#                 abb25  LIKE abb_file.abb25,
#                 abb06  LIKE abb_file.abb06,
#                 abb07  LIKE abb_file.abb07,
#                 abb07f LIKE abb_file.abb07f,
#                 qcye   LIKE abb_file.abb07,
#                 qcyef  LIKE abb_file.abb07 
#                 END RECORD,
#          l_abb03                      LIKE abb_file.abb03,
#          m_abb03,t_abb03              LIKE type_file.chr1000,
#          m_abb03t,t_abb03t            LIKE type_file.chr1000,
#          l_aag02                      LIKE aag_file.aag02,
#          l_aag13                      LIKE aag_file.aag13,  #FUN-6C0012
#          l_aag01                      LIKE aag_file.aag01,
#          l_aba02                      LIKE aba_file.aba02,
#	  l_abb07,t_abb07              LIKE type_file.num20_6,
#	  l_abb07f,t_abb07f            LIKE type_file.num20_6,
#	  l_abb07_day,t_abb07_day      LIKE type_file.num20_6,
#	  l_abb07_dsum,t_abb07_dsum    LIKE type_file.num20_6,
#	  l_abb07_sum,t_abb07_sum      LIKE type_file.num20_6,
#	  l_abb07f_day,t_abb07f_day    LIKE type_file.num20_6,
#	  l_abb07f_dsum,t_abb07f_dsum  LIKE type_file.num20_6,
#	  l_abb07f_sum,t_abb07f_sum    LIKE type_file.num20_6,
#          l_mm                         LIKE type_file.num10,
#          l_n                          LIKE type_file.num10,
#          l_i,l_aba02t                 LIKE type_file.num10,
#          l_qcye,t_qcye                LIKE type_file.num20_6,
#          l_qcyef,t_qcyef              LIKE type_file.num20_6,
#          l_sum ,t_sum                 LIKE type_file.num20_6,
#          l_sum1,t_sum1                LIKE type_file.num20_6,
#          l_sumf,t_sumf                LIKE type_file.num20_6,
#          l_sumf1,t_sumf1              LIKE type_file.num20_6,
#          l_begin,l_end                LIKE type_file.dat
#
#
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN 0
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#
#  ORDER BY sr.aag01,sr.mm,sr.aba02
#
#  FORMAT
#    FIRST PAGE HEADER
#      LET l_aag01 = sr.aag01
#      IF sr.mm = 1 THEN
#         LET g_pageno = 0
#      ELSE
#         SELECT tpg04 INTO g_pageno FROM tpg_file
#          WHERE tpg01 = YEAR(bdate)
#            AND tpg02 = sr.mm - 1
#            AND tpg03 = sr.aag01
#            AND tpg05 = g_prog
#      END IF
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#      LET g_pageno = g_pageno+1
#      PRINT '~T28X0L19.772754;',COLUMN 89,sr.aag01,'(',sr.aag02,')',' ',g_x[1]
#      PRINT COLUMN 83,YEAR(bdate)
#      PRINT COLUMN 160,g_pageno
#      PRINT
#      PRINT
#   
#    PAGE HEADER
#      IF sr.mm = 1 THEN
#         LET g_pageno = 0
#      ELSE
#         SELECT tpg04 INTO g_pageno FROM tpg_file
#          WHERE tpg01 = YEAR(bdate)
#            AND tpg02 = sr.mm - 1
#            AND tpg03 = sr.aag01
#            AND tpg05 = g_prog
#      END IF
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#      PRINT COLUMN 72,sr.aag01,'(',sr.aag02,')',' ',g_x[1]
#      PRINT COLUMN 83,YEAR(bdate)
#      IF l_aag01 <> sr.aag01 THEN
#         LET g_pageno = 0 
#         LET l_aag01 = sr.aag01
#      END IF
#      LET g_pageno = g_pageno+1
#      PRINT COLUMN 160,g_pageno
#      PRINT
#      PRINT
# 
#   BEFORE GROUP OF sr.aag01
#      SKIP TO TOP OF PAGE
#      LET l_aba02 = sr.aba02
#      LET l_mm = MONTH(sr.aba02)
#      LET l_abb07 = 0
#      LET t_abb07 = 0
#      LET l_abb07_day = 0
#      LET t_abb07_day = 0
#      LET l_abb07_sum = 0
#      LET t_abb07_sum = 0
#      LET l_abb07_dsum = 0  #No.TQC-710095
#      LET t_abb07_dsum = 0  #No.TQC-710095
#      LET l_qcye = sr.qcye
#      LET t_qcye = 0
#      LET l_sum = 0
#      LET t_sum = 0
#      LET l_sum1= 0
#      LET t_sum1= 0
#      LET l_abb07f = 0
#      LET t_abb07f = 0
#      LET l_abb07f_day = 0
#      LET t_abb07f_day = 0
#      LET l_abb07f_sum = 0
#      LET t_abb07f_sum = 0
#      LET l_abb07f_dsum = 0 #No.TQC-710095
#      LET t_abb07f_dsum = 0 #No.TQC-710095
#      LET l_qcyef= sr.qcyef
#      LET t_qcyef= 0
#      LET l_sumf= 0
#      LET t_sumf= 0
#      LET l_sumf1= 0
#      LET t_sumf1= 0
#      LET l_i = 0
#      LET g_pageno = 0
#      IF sr.mm = 1 THEN
#         LET g_pageno = 0
#      ELSE
#         SELECT tpg04 INTO g_pageno FROM tpg_file
#          WHERE tpg01 = YEAR(bdate)
#            AND tpg02 = sr.mm - 1
#            AND tpg03 = sr.aag01
#            AND tpg05 = g_prog
#      END IF
#      IF cl_null(g_pageno) THEN LET g_pageno = 0 END IF
#      LET g_pageno = g_pageno+1
#      CALL s_azm(yy,mm) RETURNING l_flag,l_begin,l_end 
#      IF bdate = l_begin THEN
#         PRINT COLUMN 27,g_x[6];
#      ELSE
#         PRINT COLUMN 27,g_x[7];
#      END IF
#      IF sr.qcye > 0 THEN PRINT COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(sr.qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(sr.qcye),13,g_azi04) END IF
#      IF sr.qcye = 0 THEN PRINT COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(sr.qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(sr.qcye),13,g_azi04) END IF 
#      IF sr.qcye < 0 THEN PRINT COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(sr.qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(sr.qcye),13,g_azi04) END IF
#
#   ON EVERY ROW
#      IF NOT cl_null(sr.aba01) THEN
#         IF cl_null(l_abb07_day) THEN LET l_abb07_day = 0 END IF 
#         IF cl_null(t_abb07_day) THEN LET t_abb07_day = 0 END IF 
#         IF cl_null(l_abb07_sum) THEN LET l_abb07_sum = 0 END IF
#         IF cl_null(t_abb07_sum) THEN LET t_abb07_sum = 0 END IF
#         IF cl_null(l_abb07f_day) THEN LET l_abb07f_day = 0 END IF 
#         IF cl_null(t_abb07f_day) THEN LET t_abb07f_day = 0 END IF 
#         IF cl_null(l_abb07f_sum) THEN LET l_abb07f_sum = 0 END IF
#         IF cl_null(t_abb07f_sum) THEN LET t_abb07f_sum = 0 END IF
#         IF LINENO =34 THEN
#            IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_dsum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_dsum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_dsum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_dsum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_dsum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_dsum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            SKIP TO TOP OF PAGE
#            IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_dsum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_dsum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_dsum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_dsum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_dsum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_dsum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_dsum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_dsum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#         END IF
#         LET g_sql = "SELECT DISTINCT abb03 FROM abb_file ",
#                     " WHERE abb01 = '",sr.aba01,"'", 
#                     "   AND abb00 = '",g_aaa.aaa01,"'",
#                     "   AND abb06 <> '",sr.abb06,"'"
#         PREPARE abb03_prepare2 FROM g_sql
#         IF SQLCA.sqlcode != 0 THEN
#            CALL cl_err('prepare:',SQLCA.sqlcode,1)
#            EXIT PROGRAM
#         END IF
#         DECLARE abb03_curs2 CURSOR FOR abb03_prepare2
#         FOREACH abb03_curs2 INTO l_abb03 
#            IF tm.g ='1' THEN 
#               IF cl_null(t_abb03) THEN
#                  LET t_abb03 = l_abb03
#               ELSE
#                  LET t_abb03 = t_abb03 CLIPPED,',',l_abb03 CLIPPED
#               END IF
#               IF LENGTH(t_abb03)>8 AND LENGTH(t_abb03t) <=8 THEN
#                  EXIT FOREACH
#               END IF
#               LET t_abb03t = t_abb03
#            END IF
#            IF tm.g = '2' THEN
#               SELECT aag02 INTO l_aag02 FROM aag_file
#                WHERE aag01 = l_abb03
#                  AND aag00 = g_aaa.aaa01    #No.FUN-740055   
#               IF cl_null(m_abb03) THEN
#                  LET m_abb03 = l_abb03 CLIPPED,'(',l_aag02 CLIPPED,')'
#               ELSE
#                  LET m_abb03 = m_abb03 CLIPPED,',',l_abb03 CLIPPED,'(',l_aag02 CLIPPED,')'
#               END IF
#               IF LENGTH(m_abb03)>8 AND LENGTH(m_abb03t) <=8 THEN
#                  EXIT FOREACH
#               END IF
#               LET m_abb03t = m_abb03
#            END IF
#            #FUN-6C0012.....begin
#            IF tm.g = '3' THEN                                                  
#               SELECT aag13 INTO l_aag13 FROM aag_file                          
#                WHERE aag01 = l_abb03                                           
#                  AND aag00 = g_aaa.aaa01    #No.FUN-740055   
#               IF cl_null(m_abb03) THEN                                         
#                  LET m_abb03 = l_abb03 CLIPPED,'(',l_aag13 CLIPPED,')'         
#               ELSE                                                             
#                  LET m_abb03 = m_abb03 CLIPPED,',',l_abb03 CLIPPED,'(',l_aag13 
#               END IF                                                           
#               IF LENGTH(m_abb03)>8 AND LENGTH(m_abb03t) <=8 THEN               
#                  EXIT FOREACH                                                  
#               END IF                                                           
#               LET m_abb03t = m_abb03                                           
#            END IF
#            #FUN-6C0012.....end
#         END FOREACH
#         PRINT COLUMN 14,MONTH(sr.aba02) USING '<<',COLUMN 17,DAY(sr.aba02) USING '<<',COLUMN 20,sr.aba01,COLUMn 33,sr.abb04;
#         IF tm.g ='1' THEN
#           #PRINT COLUMN 64,t_abb03t;       #No.TQC-710095 mark
#            PRINT COLUMN 64,t_abb03t[1,8];  #No.TQC-710095
#         END IF    #FUN-6C0012
##        ELSE      #FUN-6C0012
#         IF tm.g ='2' THEN  #FUN-6C0012
#           #PRINT COLUMN 64,m_abb03t;       #No.TQC-710095 mark
#            PRINT COLUMN 64,m_abb03t[1,8];  #No.TQC-710095
#         END IF
#         #FUN-6C0012.....begin
#         IF tm.g ='3' THEN                                                      
#            IF cl_null(m_abb03t) THEN                                           
#               LET m_abb03t = m_abb03
#            END IF                                                              
#           #PRINT COLUMN 64,m_abb03t;       #No.TQC-710095 mark
#            PRINT COLUMN 64,m_abb03t[1,8];  #No.TQC-710095
#         END IF
#         #FUN-6C0012.....end
#         IF sr.abb06 ='1' THEN
#            LET l_qcye = l_qcye+sr.abb07
#            LET l_qcyef = l_qcyef+sr.abb07f
#            IF l_qcye > 0 THEN PRINT COLUMN 73,cl_numfor(sr.abb25,6,g_azi04),COLUMN 82,cl_numfor(sr.abb07f,13,g_azi04),COLUMN 97,cl_numfor(sr.abb07,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye = 0 THEN PRINT COLUMN 73,cl_numfor(sr.abb25,6,g_azi04),COLUMN 82,cl_numfor(sr.abb07f,13,g_azi04),COLUMN 97,cl_numfor(sr.abb07,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye < 0 THEN PRINT COLUMN 73,cl_numfor(sr.abb25,6,g_azi04),COLUMN 82,cl_numfor(sr.abb07f,13,g_azi04),COLUMN 97,cl_numfor(sr.abb07,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#         ELSE
#            LET l_qcye = l_qcye-sr.abb07
#            LET l_qcyef = l_qcyef-sr.abb07f
#            IF l_qcye > 0 THEN PRINT COLUMN 73,cl_numfor(sr.abb25,6,g_azi04),COLUMN 112,cl_numfor(sr.abb07f,13,g_azi04),COLUMN 127,cl_numfor(sr.abb07,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye = 0 THEN PRINT COLUMN 73,cl_numfor(sr.abb25,6,g_azi04),COLUMN 112,cl_numfor(sr.abb07f,13,g_azi04),COLUMN 127,cl_numfor(sr.abb07,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#            IF l_qcye < 0 THEN PRINT COLUMN 73,cl_numfor(sr.abb25,6,g_azi04),COLUMN 112,cl_numfor(sr.abb07f,13,g_azi04),COLUMN 127,cl_numfor(sr.abb07,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#         END IF
#         IF l_aba02 = sr.aba02  THEN
#            LET l_abb07_day = 0   #No.TQC-710095
#            LET t_abb07_day = 0   #No.TQC-710095
#            LET l_abb07f_day = 0  #No.TQC-710095
#            LET t_abb07f_day = 0  #No.TQC-710095
#            IF sr.abb06 = '1' THEN
#               LET l_abb07_day = l_abb07_day + sr.abb07   #借方金額合計
#               LET l_abb07f_day = l_abb07f_day + sr.abb07f   #借方金額合計
#            ELSE
#               LET t_abb07_day = t_abb07_day + sr.abb07   #貸方金額合計
#               LET t_abb07f_day = t_abb07f_day + sr.abb07f   #貸方金額合計
#            END IF
#         ELSE
#            LET l_aba02 = sr.aba02
#            LET l_abb07_day = 0
#            LET t_abb07_day = 0
#            LET l_abb07f_day = 0
#            LET t_abb07f_day = 0
#            IF sr.abb06 = '1' THEN
#               LET l_abb07_day = l_abb07_day + sr.abb07   #借方金額合計
#               LET l_abb07f_day = l_abb07f_day + sr.abb07f   #借方金額合計
#            ELSE
#               LET t_abb07_day = t_abb07_day + sr.abb07   #貸方金額合計
#               LET t_abb07f_day = t_abb07f_day + sr.abb07f   #貸方金額合計
#            END IF
#         END IF
#         LET l_abb07_dsum = l_abb07_dsum + l_abb07_day
#         LET t_abb07_dsum = t_abb07_dsum + t_abb07_day
#         LET l_abb07f_dsum = l_abb07f_dsum + l_abb07f_day
#         LET t_abb07f_dsum = t_abb07f_dsum + t_abb07f_day
#         LET t_abb03 = NULL
#         LET m_abb03 = NULL
#         LET l_i = l_i + 1   
#      END IF
# 
#   AFTER GROUP OF sr.aba02
#         IF NOT cl_null(sr.aba01) THEN
#            IF tm.h = '1' THEN
#               SELECT SUM(abb07),SUM(abb07f) INTO l_abb07,l_abb07f FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '1'
#                  AND abaacti = 'Y'
#               SELECT SUM(abb07),SUM(abb07f) INTO t_abb07,t_abb07f FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '2'
#                  AND abaacti = 'Y'
#            END IF
#            IF tm.h = '2' THEN
#               SELECT SUM(abb07),SUM(abb07f) INTO l_abb07,l_abb07f FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '1'
#                  AND abaacti = 'Y'
#                  AND aba19 = 'Y'
#               SELECT SUM(abb07),SUM(abb07f) INTO t_abb07,t_abb07f FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '2'
#                  AND abaacti = 'Y'
#                  AND aba19 = 'Y'
#            END IF
#            IF tm.h = '3' THEN
#               SELECT SUM(abb07),SUM(abb07f) INTO l_abb07,l_abb07f FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '1'
#                  AND abaacti = 'Y'
#                  AND abapost = 'Y'
#               SELECT SUM(abb07),SUM(abb07f) INTO t_abb07,t_abb07f FROM abb_file,aba_file
#                WHERE abb00 = aba00
#                  AND abb01 = aba01
#                  AND abb03 = sr.aag01
#                  AND abb00 = g_aaa.aaa01
#                  AND aba02 = sr.aba02
#                  AND abb06 = '2'
#                  AND abaacti = 'Y'
#                  AND abapost = 'Y'
#            END IF
#            IF cl_null(l_abb07) THEN LET l_abb07 = 0 END IF
#            IF cl_null(t_abb07) THEN LET t_abb07 = 0 END IF
#            IF cl_null(l_abb07f) THEN LET l_abb07f = 0 END IF
#            IF cl_null(t_abb07f) THEN LET t_abb07f = 0 END IF
#            LET l_abb07_sum = l_abb07_sum + l_abb07
#            LET t_abb07_sum = t_abb07_sum + t_abb07
#            LET l_abb07f_sum = l_abb07f_sum + l_abb07f
#            LET t_abb07f_sum = t_abb07f_sum + t_abb07f
#            IF cl_null(l_abb07_sum) THEN LET l_abb07_sum = 0 END IF
#            IF cl_null(t_abb07_sum) THEN LET t_abb07_sum = 0 END IF
#            IF cl_null(l_abb07f_sum) THEN LET l_abb07f_sum = 0 END IF
#            IF cl_null(t_abb07f_sum) THEN LET t_abb07f_sum = 0 END IF
#            IF LINENO >= 32 THEN
#               IF l_mm <> MONTH(sr.aba02) THEN
#                  IF LINENO = 32 THEN
#                     PRINT
#                     PRINT
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     SKIP TO TOP OF PAGE
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                  END IF
#                  IF LINENO = 33 THEN
#                     PRINT
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     SKIP TO TOP OF PAGE
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                  END IF
#                  IF LINENO = 34 THEN
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     SKIP TO TOP OF PAGE
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                  END IF
#                  LET l_mm = MONTH(sr.aba02)
#               ELSE
#                  IF LINENO =34 THEN 
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF
#                     SKIP TO TOP OF PAGE
#                     IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                     IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) END IF #過次頁
#                  END IF
#               END IF
#            END IF
#         END IF
#         IF NOT cl_null(sr.aba01) THEN
#            IF tm.h ='1' THEN
#               SELECT COUNT(aba02) INTO l_aba02t FROM aba_file,abb_file
#                WHERE aba00 = abb_file.abb00
#                  AND aba01 = abb_file.abb01
#                  AND abb03 = sr.aag01
#                  AND aba04 = sr.mm
#                  AND aba03 = YEAR(sr.aba02)
#                  AND abb00 = g_aaa.aaa01
#                  AND abaacti = 'Y'
#            END IF
#            IF tm.h ='2' THEN
#               SELECT COUNT(aba02) INTO l_aba02t FROM aba_file,abb_file
#                WHERE aba00 = abb_file.abb00
#                  AND aba01 = abb_file.abb01
#                  AND abb03 = sr.aag01
#                  AND aba04 = sr.mm
#                  AND aba03 = YEAR(sr.aba02)
#                  AND abb00 = g_aaa.aaa01
#                  AND abaacti = 'Y'
#                  AND aba19 = 'Y'
#            END IF
#            IF tm.h ='3' THEN
#               SELECT COUNT(aba02) INTO l_aba02t FROM aba_file,abb_file
#                WHERE aba00 = abb_file.abb00
#                  AND aba01 = abb_file.abb01
#                  AND abb03 = sr.aag01
#                  AND aba04 = sr.mm
#                  AND aba03 = YEAR(sr.aba02)
#                  AND abb00 = g_aaa.aaa01
#                  AND abaacti = 'Y'
#                  AND abapost = 'Y'
#            END IF
#            IF l_i = l_aba02t THEN
#               IF tm.h = '1' THEN
#                  SELECT SUM(abb07),SUM(abb07f) INTO l_sum,l_sumf FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                  SELECT SUM(abb07),SUM(abb07f) INTO t_sum,t_sumf FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                  SELECT SUM(abb07),SUM(abb07f) INTO l_sum1,l_sumf1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                  SELECT SUM(abb07),SUM(abb07f) INTO t_sum1,t_sumf1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#               END IF
#               IF tm.h = '2' THEN
#                  SELECT SUM(abb07),SUM(abb07f) INTO l_sum,l_sumf FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#                  SELECT SUM(abb07),SUM(abb07f) INTO t_sum,t_sumf FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#                  SELECT SUM(abb07),SUM(abb07f) INTO l_sum1,l_sumf1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#                  SELECT SUM(abb07),SUM(abb07f) INTO t_sum1,t_sumf1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND aba19 = 'Y' 
#               END IF
#               IF tm.h = '3' THEN
#                  SELECT SUM(abb07),SUM(abb07f) INTO l_sum,l_sumf FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#                  SELECT SUM(abb07),SUM(abb07f) INTO t_sum,t_sumf FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 = sr.mm
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#                  SELECT SUM(abb07),SUM(abb07f) INTO l_sum1,l_sumf1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '1'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#                  SELECT SUM(abb07),SUM(abb07f) INTO t_sum1,t_sumf1 FROM abb_file,aba_file
#                   WHERE abb00 = aba00
#                     AND abb01 = aba01
#                     AND abb03 = sr.aag01
#                     AND aba04 < sr.mm+1
#                     AND aba02 >= bdate
#                     AND aba03 = YEAR(sr.aba02)
#                     AND abb00 = g_aaa.aaa01
#                     AND abb06 = '2'
#                     AND abaacti = 'Y'
#                     AND abapost = 'Y' 
#               END IF
#               IF cl_null(l_sum) THEN LET l_sum = 0 END IF
#               IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
#               IF cl_null(t_sum) THEN LET t_sum = 0 END IF
#               IF cl_null(t_sum1) THEN LET t_sum1 = 0 END IF
#               IF cl_null(l_sumf) THEN LET l_sumf = 0 END IF
#               IF cl_null(l_sumf1) THEN LET l_sumf1 = 0 END IF
#               IF cl_null(t_sumf) THEN LET t_sumf = 0 END IF
#               IF cl_null(t_sumf1) THEN LET t_sumf1 = 0 END IF
#               PRINT COLUMN 14,sr.mm USING '<<',COLUMN 27,g_x[11],COLUMN 82,cl_numfor(l_sumf,13,g_azi04),COLUMN 97,cl_numfor(l_sum,13,g_azi04),COLUMN 112,cl_numfor(t_sumf,13,g_azi04),COLUMN 127,cl_numfor(t_sum,13,g_azi04);
#               IF l_qcye > 0 THEN 
#                  PRINT COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#                  PRINT COLUMN 14,sr.mm USING '<<',COLUMn 27,g_x[12],COLUMN 82,cl_numfor(l_sumf1,13,g_azi04),COLUMN 97,cl_numfor(l_sum1,13,g_azi04),COLUMN 112,cl_numfor(t_sumf1,13,g_azi04),COLUMN 127,cl_numfor(t_sum1,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#               END IF
#               IF l_qcye = 0 THEN 
#                  PRINT COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#                  PRINT COLUMN 14,sr.mm USING '<<',COLUMn 27,g_x[12],COLUMN 82,cl_numfor(l_sumf1,13,g_azi04),COLUMN 97,cl_numfor(l_sum1,13,g_azi04),COLUMN 112,cl_numfor(t_sumf1,13,g_azi04),COLUMN 127,cl_numfor(t_sum1,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#               END IF
#               IF l_qcye < 0 THEN 
#                  PRINT COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#                  PRINT COLUMN 14,sr.mm USING '<<',COLUMn 27,g_x[12],COLUMN 82,cl_numfor(l_sumf1,13,g_azi04),COLUMN 97,cl_numfor(l_sum1,13,g_azi04),COLUMN 112,cl_numfor(t_sumf1,13,g_azi04),COLUMN 127,cl_numfor(t_sum1,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#               END IF
#               LET l_sum =0
#               LET t_sum =0
#               LET l_sumf =0
#               LET t_sumf =0
#               LET l_i = 0
#            END IF
#         ELSE
#            IF LINENO > 32 THEN
#               IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04),' ' END IF
#               IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04),' ' END IF
#               IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[9],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04),' ' END IF
#               SKIP TO TOP OF PAGE
#               IF l_qcye > 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04),' ' END IF #過次頁
#               IF l_qcye = 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04),' ' END IF #過次頁
#               IF l_qcye < 0 THEN PRINT COLUMn 27,g_x[8],COLUMN 82,cl_numfor(l_abb07f_sum,13,g_azi04),COLUMN 97,cl_numfor(l_abb07_sum,13,g_azi04),COLUMN 112,cl_numfor(t_abb07f_sum,13,g_azi04),COLUMN 127,cl_numfor(t_abb07_sum,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04),' ' END IF #過次頁
#            END IF
#            PRINT COLUMN 14,sr.mm USING '<<',COLUMN 27,g_x[11],COLUMN 82,cl_numfor(l_sumf,13,g_azi04),COLUMN 97,cl_numfor(l_sum,13,g_azi04),COLUMN 112,cl_numfor(t_sumf,13,g_azi04),COLUMN 127,cl_numfor(t_sum,13,g_azi04);
#            IF l_qcye > 0 THEN 
#               PRINT COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#               PRINT COLUMN 14,sr.mm USING '<<',COLUMn 27,g_x[12],COLUMN 82,cl_numfor(l_sumf1,13,g_azi04),COLUMN 97,cl_numfor(l_sum1,13,g_azi04),COLUMN 112,cl_numfor(t_sumf1,13,g_azi04),COLUMN 127,cl_numfor(t_sum1,13,g_azi04),COLUMN 142,g_x[2],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#            END IF
#            IF l_qcye = 0 THEN 
#               PRINT COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#               PRINT COLUMN 14,sr.mm USING '<<',COLUMn 27,g_x[12],COLUMN 82,cl_numfor(l_sumf1,13,g_azi04),COLUMN 97,cl_numfor(l_sum1,13,g_azi04),COLUMN 112,cl_numfor(t_sumf1,13,g_azi04),COLUMN 127,cl_numfor(t_sum1,13,g_azi04),COLUMN 142,g_x[3],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#            END IF
#            IF l_qcye < 0 THEN 
#               PRINT COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04) 
#               PRINT COLUMN 14,sr.mm USING '<<',COLUMn 27,g_x[12],COLUMN 82,cl_numfor(l_sumf1,13,g_azi04),COLUMN 97,cl_numfor(l_sum1,13,g_azi04),COLUMN 112,cl_numfor(t_sumf1,13,g_azi04),COLUMN 127,cl_numfor(t_sum1,13,g_azi04),COLUMN 142,g_x[4],COLUMN 145,cl_numfor(gglg401_abs(l_qcyef),13,g_azi04),COLUMN 160,cl_numfor(gglg401_abs(l_qcye),13,g_azi04)
#            END IF
#         END IF
#         SELECT * FROM tpg_file 
#          WHERE tpg01 = YEAR(bdate)
#            AND tpg02 = sr.mm
#            AND tpg03 = sr.aag01
#            AND tpg05 = g_prog 
#         IF SQLCA.sqlcode THEN
#            INSERT INTO tpg_file VALUES(YEAR(bdate),sr.mm,sr.aag01,g_pageno,g_prog,'','')
#         ELSE
#            UPDATE tpg_file SET tpg04 = g_pageno
#             WHERE tpg01 = YEAR(bdate)
#               AND tpg02 = sr.mm
#               AND tpg03 = sr.aag01
#               AND tpg05 = g_prog 
#         END IF
#END REPORT
#No.FUN-7C0064  --End
 
FUNCTION gglg401_abs(p_sqlerrd2)                                                                                                      
  DEFINE p_sqlerrd2  LIKE type_file.num10                                                                                                     
                                                                                                                                    
     IF p_sqlerrd2<0 THEN                                                                                                           
        LET p_sqlerrd2=-(p_sqlerrd2)                                                                                                
     END IF                                                                                                                         
     RETURN p_sqlerrd2                                                                                                              
END FUNCTION
 
#No.FUN-7C0064  --Begin
FUNCTION g401_abb03(p_aba01,p_abb06)
  DEFINE p_aba01   LIKE aba_file.aba01
  DEFINE p_abb06   LIKE abb_file.abb06
  DEFINE l_abb03   LIKE abb_file.abb03
  DEFINE t_abb03   LIKE type_file.chr1000
  DEFINE l_aag02   LIKE aag_file.aag02
  DEFINE l_aag13   LIKE aag_file.aag13
  
    FOREACH abb03_curs2 USING p_aba01,p_abb06 INTO l_abb03 
       IF tm.g ='1' THEN 
          IF cl_null(t_abb03) THEN
             LET t_abb03 = l_abb03
          ELSE
             LET t_abb03 = t_abb03 CLIPPED,',',l_abb03 CLIPPED
          END IF
          IF LENGTH(t_abb03)>8 THEN
             EXIT FOREACH
          END IF
       END IF
       IF tm.g = '2' THEN
          SELECT aag02 INTO l_aag02 FROM aag_file
           WHERE aag01 = l_abb03
             AND aag00 = g_aaa.aaa01
          IF cl_null(t_abb03) THEN
             LET t_abb03 = l_abb03 CLIPPED,'(',l_aag02 CLIPPED,')'
          ELSE
             LET t_abb03 = t_abb03 CLIPPED,',',l_abb03 CLIPPED,'(',l_aag02 CLIPPED,')'
          END IF
          IF LENGTH(t_abb03)>8 THEN
             EXIT FOREACH
          END IF
       END IF
       IF tm.g = '3' THEN                                                  
          SELECT aag13 INTO l_aag13 FROM aag_file                          
           WHERE aag01 = l_abb03                                           
             AND aag00 = g_aaa.aaa01    #No.FUN-740055   
          IF cl_null(t_abb03) THEN                                         
             LET t_abb03 = l_abb03 CLIPPED,'(',l_aag13 CLIPPED,')'         
          ELSE                                                             
             LET t_abb03 = t_abb03 CLIPPED,',',l_abb03 CLIPPED,'(',l_aag13 
          END IF                                                           
          IF LENGTH(t_abb03)>8 THEN               
             EXIT FOREACH                                                  
          END IF                                                           
       END IF
    END FOREACH
    RETURN t_abb03[1,8]
END FUNCTION
#No.FUN-7C0064  --End

###GENGRE###START
FUNCTION gglg401_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF



    
    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("gglg401")
        IF handler IS NOT NULL THEN
            START REPORT gglg401_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY aag01" 
            DECLARE gglg401_datacur1 CURSOR FROM l_sql
            FOREACH gglg401_datacur1 INTO sr1.*
                OUTPUT TO REPORT gglg401_rep(sr1.*)
            END FOREACH
            FINISH REPORT gglg401_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT gglg401_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno        LIKE type_file.num5
    #FUN-B40087---------add---------str-------
    DEFINE l_abb07_1         LIKE abb_file.abb07
    DEFINE l_abb07_2         LIKE abb_file.abb07
    DEFINE l_abb07f_1        LIKE abb_file.abb07
    DEFINE l_abb07f_2        LIKE abb_file.abb07
    DEFINE l_abs_qcye        LIKE abb_file.abb07
    DEFINE l_abs_qcyef       LIKE abb_file.abb07
    DEFINE l_d_aba02         LIKE type_file.num5 
    DEFINE l_desc            STRING
    DEFINE l_h1              STRING
    DEFINE l_cc1_before      LIKE abb_file.abb07
    DEFINE l_cc1             LIKE abb_file.abb07
    DEFINE l_cc2_before      LIKE abb_file.abb07
    DEFINE l_cc2             LIKE abb_file.abb07
    DEFINE l_chr1            STRING
    DEFINE l_chr2            STRING
    DEFINE l_m_aba02         LIKE type_file.num5
    DEFINE l_pd_abb07_1      LIKE abb_file.abb07
    DEFINE l_pd_abb07_2      LIKE abb_file.abb07
    DEFINE l_pd_abb07f_1     LIKE abb_file.abb07
    DEFINE l_pd_abb07f_2     LIKE abb_file.abb07 
    DEFINE l_year            STRING
    DEFINE l_abb07_1_sum     LIKE abb_file.abb07
    DEFINE l_abb07_2_sum     LIKE abb_file.abb07
    DEFINE l_abb07f_1_sum    LIKE abb_file.abb07
    DEFINE l_abb07f_2_sum    LIKE abb_file.abb07
    DEFINE l_d_abb07_1_sum   LIKE abb_file.abb07
    DEFINE l_d_abb07_2_sum   LIKE abb_file.abb07
    DEFINE l_d_abb07f_1_sum  LIKE abb_file.abb07
    DEFINE l_d_abb07f_2_sum  LIKE abb_file.abb07
    DEFINE l_type1           LIKE type_file.chr1
    DEFINE l_begin           LIKE type_file.dat
    DEFINE l_end             LIKE type_file.dat
    DEFINE l_cc1_fmt         STRING      
    DEFINE l_abb07_1_fmt     STRING
    DEFINE l_abb07_2_fmt     STRING
    DEFINE l_md_fmt          STRING
    DEFINE l_mc_fmt          STRING
    DEFINE l_yd_fmt          STRING
    DEFINE l_yc_fmt          STRING
    DEFINE l_cc2_fmt         STRING
    DEFINE l_mdf_fmt         STRING 
    DEFINE l_ydf_fmt         STRING
    DEFINE l_mcf_fmt         STRING
    DEFINE l_ycf_fmt         STRING
    DEFINE l_display         STRING
    DEFINE l_abs_qcye_fmt    STRING
    DEFINE l_abs_qcyef_fmt   STRING
    #FUN-B40087---------add---------end-------

    
    ORDER EXTERNAL BY sr1.aag01,sr1.mm,sr1.aba02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B70118
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.aag01
            LET l_lineno = 0
            #FUN-B40087---------add---------str-------
            IF g_aza.aza63 = 'Y' THEN
               CALL s_azmm(yy,mm1,g_plant,g_aaa.aaa01) RETURNING l_flag,l_begin,l_end
            ELSE
               CALL s_azm(yy,mm1) RETURNING l_flag,l_begin,l_end
            END IF
            IF bdate = l_begin THEN
               LET l_type1 = '1'
            ELSE
               LET l_type1 = '2'
            END IF
            IF l_type1 = '1' THEN 
               LET l_desc = cl_gr_getmsg("gre-067",g_lang,'2')
            ELSE 
               LET l_desc = cl_gr_getmsg("gre-067",g_lang,'3')
            END IF
            PRINTX l_desc

            IF sr1.qcyef >0 THEN
               LET l_chr1 = cl_gr_getmsg("gre-030",g_lang,'1')
            ELSE IF sr1.qcyef < 0 THEN
                    LET l_chr1 = cl_gr_getmsg("gre-030",g_lang,'2')
                 ELSE
                    LET l_chr1 = cl_gr_getmsg("gre-030",g_lang,'3')
                 END IF
            END IF
            PRINTX l_chr1
            #FUN-B40087---------add---------end-------
        BEFORE GROUP OF sr1.mm
        BEFORE GROUP OF sr1.aba02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B40087---------add---------str-------
            IF sr1.qcye < 0 THEN
               LET l_abs_qcye = sr1.qcye * (-1)
            ELSE
               LET l_abs_qcye = sr1.qcye
            END IF
            PRINTX l_abs_qcye
            IF sr1.qcyef < 0 THEN
               LET l_abs_qcyef = sr1.qcyef * (-1)
            ELSE
               LET l_abs_qcyef = sr1.qcyef
            END IF
            PRINTX l_abs_qcyef

            LET l_d_aba02 = DAY(sr1.aba02)
            PRINTX l_d_aba02

            LET l_h1 = sr1.aag01,'(',sr1.aag02,')',g_grPageHeader.title2
            PRINTX l_h1

            LET l_m_aba02 = MONTH(sr1.aba02)
            PRINTX l_m_aba02

            LET l_year = YEAR(bdate) USING "####"
            PRINTX  l_year          

            LET l_abb07_1_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_abb07_1_fmt

            LET l_abb07_2_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_abb07_2_fmt
  
            #FUN-B40087---------add---------end-------

            PRINTX sr1.*

        AFTER GROUP OF sr1.aag01
            #FUN-B40087---------add---------str-------
            IF sr1.abb07 != 0 OR sr1.abb07f != 0 THEN
               LET l_display = "Y"
            ELSE 
               LET l_display = "N"
            END IF
            PRINTX l_display
            LET l_abb07_1_sum  = GROUP SUM(sr1.abb07_1)
            LET l_abb07_2_sum  = GROUP SUM(sr1.abb07_2)
            LET l_abb07f_1_sum = GROUP SUM(sr1.abb07f_1)
            LET l_abb07f_2_sum = GROUP SUM(sr1.abb07f_2)
            PRINTX l_abb07_1_sum
            PRINTX l_abb07_2_sum
            PRINTX l_abb07f_1_sum
            PRINTX l_abb07f_2_sum
             
            LET l_cc1_before = sr1.qcye + l_abb07_1_sum - l_abb07_2_sum
            PRINTX l_cc1_before
            IF l_cc1_before < 0 THEN
               LET l_cc1 = l_cc1_before * (-1)
            ELSE
               LET l_cc1 = l_cc1_before
            END IF 
            PRINTX l_cc1

            LET l_cc1_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04) 
            PRINTX l_cc1_fmt

            LET l_md_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_md_fmt

            LET l_mc_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_mc_fmt

            LET l_yd_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_yd_fmt

            LET l_yc_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_yc_fmt

            LET l_cc2_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)
            PRINTX l_cc2_fmt
       
            LET l_mdf_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_mdf_fmt

            LET l_mcf_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_mcf_fmt

            LET l_ydf_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_ydf_fmt

            LET l_ycf_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_ycf_fmt

            LET l_abs_qcye_fmt = cl_gr_numfmt('abb_file','abb07',g_azi04)
            PRINTX l_abs_qcye_fmt

            LET l_abs_qcyef_fmt = cl_gr_numfmt('abb_file','abb07',sr1.azi04)
            PRINTX l_abs_qcyef_fmt

            LET l_cc2_before = sr1.qcyef + l_abb07f_1_sum - l_abb07f_2_sum
            PRINTX l_cc2_before
            IF l_cc2_before < 0 THEN
               LET l_cc2 = l_cc2_before * (-1)
            ELSE
               LET l_cc2 = l_cc2_before
            END IF
            PRINTX l_cc2

            IF l_cc2_before >0 THEN
               LET l_chr2 = cl_gr_getmsg("gre-030",g_lang,'1')
            ELSE IF l_cc2_before < 0 THEN
                    LET l_chr2 = cl_gr_getmsg("gre-030",g_lang,'2')
                 ELSE
                    LET l_chr2 = cl_gr_getmsg("gre-030",g_lang,'3')
                 END IF
            END IF
            PRINTX l_chr2
            
            LET l_pd_abb07_1  = l_abb07_1_sum  - l_abb07_1
            PRINTX l_pd_abb07_1
            LET l_pd_abb07_2  = l_abb07_2_sum  - l_abb07_2
            PRINTX l_pd_abb07_2
            LET l_pd_abb07f_1 = l_abb07f_1_sum - l_abb07f_1
            PRINTX l_pd_abb07f_1
            LET l_pd_abb07f_2 = l_abb07f_2_sum - l_abb07f_2
            PRINTX l_pd_abb07f_2

            #FUN-B40087---------add---------end-------
        AFTER GROUP OF sr1.mm
        AFTER GROUP OF sr1.aba02

        
        ON LAST ROW

END REPORT
###GENGRE###END
