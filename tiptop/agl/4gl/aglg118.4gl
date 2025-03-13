# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Descriptions...: 合併抵銷調整憑證
# Date & Author..: No:FUN-B60134 11/07/12 By Lujh
# Modify.........: No:FUN-B60134 11/08/11 By Lujh     增加期别axi04,修改报表单据日期显示格式，增加合计
# Modify.........: NO.MOD-BB0262 11/11/23 By xuxz 註釋中版本號修改
# Modify.........: No:FUN-C10036 12/01/19 By yangtt CR轉換成GRW
# Modify.........: No.FUN-C40020 12/05/11 By qirl  GR報表列印TIPTOP與EasyFlow簽核圖片
# Modify.........: No.FUN-C50004 12/05/14 By nanbing GR優化  
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  tm        RECORD                    #Print condition RECORD
        s         LIKE type_file.chr1000,   #排序方式 
        wc        LIKE type_file.chr1000,   #Where Condiction
        e         LIKE type_file.chr1,      #審核否
        m         LIKE type_file.chr1       #是否輸入其它特殊列印條件
                  END RECORD 

DEFINE  g_axi05   LIKE axi_file.axi05         
DEFINE  g_i       LIKE type_file.num5       #count/index for any purpose
DEFINE  g_sql     STRING            
DEFINE  l_table   STRING             
DEFINE  g_str     STRING            
###GENGRE###START
TYPE sr1_t RECORD
    axi01 LIKE axi_file.axi01,
    axi05 LIKE axi_file.axi05,
    axi08 LIKE ze_file.ze03,
    axi03 LIKE axi_file.axi01,
    axi04 LIKE axi_file.axi01,
    axi06 LIKE axi_file.axi06,
    axi081 LIKE ze_file.ze03,
    axi02 LIKE axi_file.axi02,
    zx02 LIKE zx_file.zx02,
    axj02 LIKE axj_file.axj02,
    axj06 LIKE axj_file.axj06,     #FUN-C10036 add
    axj04_1 LIKE axj_file.axj04,
    l_aag_all_1 LIKE type_file.chr1000,
    axj05_1 LIKE axj_file.axj05,
    l_axj07_l_1 LIKE axj_file.axj07,
    l_axj07_r_1 LIKE axj_file.axj07,
    axj04_2 LIKE axj_file.axj04,
    l_aag_all_2 LIKE type_file.chr1000,
    axj05_2 LIKE axj_file.axj05,
    l_axj07_l_2 LIKE axj_file.axj07,
    l_axj07_r_2 LIKE axj_file.axj07,
    axj04_3 LIKE axj_file.axj04,
    l_aag_all_3 LIKE type_file.chr1000,
    axj05_3 LIKE axj_file.axj05,
    l_axj07_l_3 LIKE axj_file.axj07,
    l_axj07_r_3 LIKE axj_file.axj07,
    axj04_4 LIKE axj_file.axj04,
    l_aag_all_4 LIKE type_file.chr1000,
    axj05_4 LIKE axj_file.axj05,
    l_axj07_l_4 LIKE axj_file.axj07,
    l_axj07_r_4 LIKE axj_file.axj07,
    axj04_5 LIKE axj_file.axj04,
    l_aag_all_5 LIKE type_file.chr1000,
    axj05_5 LIKE axj_file.axj05,
    l_axj07_l_5 LIKE axj_file.axj07,
    l_axj07_r_5 LIKE axj_file.axj07,
    l_axj07_l_s LIKE axj_file.axj07,
    l_axj07_r_s LIKE axj_file.axj07,
    l_cur_p LIKE type_file.num5,
    l_tot_p LIKE type_file.num5,
    axz02 LIKE axz_file.axz02, #FUN-C50004 add
    l_n LIKE type_file.num5,
    sign_type LIKE type_file.chr1,
    sign_img LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000 # No.FUN-C40020 add
    
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
 
   IF (NOT cl_setup("agl")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql="axi01.axi_file.axi01,",
             "axi05.axi_file.axi05,",
             "axi08.ze_file.ze03,",
             "axi03.axi_file.axi01,",
             "axi04.axi_file.axi01,",          #FUN-B60134   添加期别
             "axi06.axi_file.axi06,",
             "axi081.ze_file.ze03,",
             "axi02.axi_file.axi02,",
             "zx02.zx_file.zx02,",
             "axj02.axj_file.axj02,",   
             "axj06.axj_file.axj06,",     #FUN-C10036 add
             "axj04_1.axj_file.axj04,",     #
             "l_aag_all_1.type_file.chr1000,",
             "axj05_1.axj_file.axj05,",
             "l_axj07_l_1.axj_file.axj07,",
             "l_axj07_r_1.axj_file.axj07,",
             "axj04_2.axj_file.axj04,",     #
             "l_aag_all_2.type_file.chr1000,",
             "axj05_2.axj_file.axj05,",
             "l_axj07_l_2.axj_file.axj07,",
             "l_axj07_r_2.axj_file.axj07,",
             "axj04_3.axj_file.axj04,",     #
             "l_aag_all_3.type_file.chr1000,",
             "axj05_3.axj_file.axj05,",
             "l_axj07_l_3.axj_file.axj07,",
             "l_axj07_r_3.axj_file.axj07,",
             "axj04_4.axj_file.axj04,",      #
             "l_aag_all_4.type_file.chr1000,",
             "axj05_4.axj_file.axj05,",
             "l_axj07_l_4.axj_file.axj07,",
             "l_axj07_r_4.axj_file.axj07,",
             "axj04_5.axj_file.axj04,",       #
             "l_aag_all_5.type_file.chr1000,",
             "axj05_5.axj_file.axj05,",
             "l_axj07_l_5.axj_file.axj07,",
             "l_axj07_r_5.axj_file.axj07,",
             "l_axj07_l_s.axj_file.axj07,",   #FUN-B60134    借方合计
             "l_axj07_r_s.axj_file.axj07,",   #FUN-B60134    贷方合计
             " l_cur_p.type_file.num5,",
             " l_tot_p.type_file.num5,",
             "axz02.axz_file.axz02, ", #FUN-C50004 add          
             " l_n.type_file.num5,",         
             "sign_type.type_file.chr1,",   #簽核方式     
             "sign_img.type_file.blob,",    #簽核圖檔     
             "sign_show.type_file.chr1, ",    #是否顯示簽核資料(Y/N)  
             "sign_str.type_file.chr1000" # No.FUN-C40020 add             
             
   LET l_table=cl_prt_temptable("aglg118",g_sql) CLIPPED                                                                           
   IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"     #FUN-C10036 add 1?    #FUN-C40020 add 1?  #FUN-C50004 add 1?                                                    
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                  
      CALL cl_err("insert_prep:",status,1)                                                                                         
   END IF
         
   LET g_pdate = ARG_VAL(1)		# Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc  = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.e  = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
    
   IF cl_null(g_bgjob) OR g_bgjob = 'N'		# If background job sw is off
      THEN CALL aglg118_tm()	        	# Input print condition
      ELSE CALL aglg118()			        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION aglg118_tm()
   DEFINE  lc_qbe_sn     LIKE gbm_file.gbm01   
   DEFINE  p_row,p_col	 LIKE type_file.num5,    
           l_cmd		 LIKE type_file.chr1000  
 

   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW aglg118_w AT p_row,p_col
        WITH FORM "agl/42f/aglg118"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
   
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.e = 'Y'  
   LET tm.s = '1'
   LET tm.m = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON axi05,axi01,axi02,axi03,axi04,axi08,axi081
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

       ON ACTION controlp
          CASE 
             WHEN INFIELD (axi05)
                CALL cl_init_qry_var()
                LET g_qryparam.state='c'
                LET g_qryparam.form="q_axa1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO axi05
                NEXT FIELD axi05 
           END CASE
 
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
       LET INT_FLAG = 0 
       CLOSE WINDOW aglg118_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
   END IF
   INPUT BY NAME tm.e,tm.s,tm.m WITHOUT DEFAULTS  
       BEFORE INPUT   
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD e
          IF tm.e NOT MATCHES "[YN]" THEN NEXT FIELD e END IF
       AFTER FIELD s
          IF tm.s NOT MATCHES "[12]" THEN NEXT FIELD s END IF
       AFTER FIELD m
          IF tm.m NOT MATCHES "[YN]" THEN NEXT FIELD m END IF
          IF tm.m = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
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
      LET INT_FLAG = 0 
      CLOSE WINDOW aglg118_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='aglg118'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('aglg118','9031',1)   
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
                         " '",tm.e CLIPPED,"'",
                         " '",tm.s CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           
                         " '",g_rep_clas CLIPPED,"'",          
                         " '",g_template CLIPPED,"'",          
                         " '",g_rpt_name CLIPPED,"'"           
         CALL cl_cmdat('aglg118',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW aglg118_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL aglg118()
   ERROR ""
   END WHILE
   CLOSE WINDOW aglg118_w
END FUNCTION
 
FUNCTION aglg118()
   DEFINE l_name	    LIKE type_file.chr20,   
          l_sql 	    LIKE type_file.chr1000, 
          l_za05	    LIKE type_file.chr1000,   #標題內容
          l_axiuser     LIKE axi_file.axiuser,              
          l_zx02        LIKE zx_file.zx02,   
          l_axj03       LIKE axj_file.axj03, 
          l_ze01        LIKE ze_file.ze01,
          l_ze03        LIKE ze_file.ze03,         
          l_i           LIKE type_file.num5,    
          l_temp1       LIKE type_file.num5,    
          l_temp2       LIKE type_file.num5,    
          l_n           LIKE type_file.num5,    
          sr            RECORD
          axi01         LIKE axi_file.axi01,
          axi05         LIKE axi_file.axi05,
          axi08         LIKE ze_file.ze03,
          axi03         LIKE axi_file.axi01,
          axi04         LIKE axi_file.axi01,
          axi06         LIKE axi_file.axi06,
          axi081        LIKE ze_file.ze03,
          axi02         LIKE axi_file.axi02,
          axi07         LIKE axi_file.axi07,
          axj02         LIKE axj_file.axj02,#項次
          axj04         LIKE axj_file.axj04,#摘要
          axj05         LIKE axj_file.axj05,
          axj06         LIKE axj_file.axj06,
          aag01         LIKE aag_file.aag01,
          aag02         LIKE aag_file.aag02,#科目名稱
          aag13         LIKE aag_file.aag13,#額外名稱
          aag07         LIKE aag_file.aag07,
          aag08         LIKE aag_file.aag08,
          axj07         LIKE axj_file.axj07,    
          l_pageno      LIKE type_file.num5,   
          l_aag01_l     LIKE aag_file.aag01,    
          l_aag01_r     LIKE aag_file.aag01,   
          l_aag02_l     LIKE aag_file.aag02,    
          l_aag02_r     LIKE aag_file.aag02,   
          l_aag_all     LIKE type_file.chr1000, 
          l_axj07_l     LIKE axj_file.axj07,    
          l_axj07_r     LIKE axj_file.axj07,
          axz02         LIKE axz_file.axz02, #FUN-C50004 add
          zx02          LIKE zx_file.zx02   #FUN-C50004 add  
                        END RECORD
   DEFINE l_l_axj07_l   LIKE axj_file.axj07
   DEFINE l_l_axj07_r   LIKE axj_file.axj07
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_axi01       LIKE axi_file.axi01
   DEFINE l_str1        STRING                      
   DEFINE l_str2        STRING                     
   DEFINE sr1           RECORD
          axi01         LIKE   axi_file.axi01,
          axi05         LIKE   axi_file.axi05,
          axi08         LIKE   ze_file.ze03,
          axi03         LIKE   axi_file.axi01,
          axi04         LIKE   axi_file.axi01,
          axi06         LIKE   axi_file.axi06,  
          axi081        LIKE   ze_file.ze03,
          axi02         LIKE   axi_file.axi02,
          zx02          LIKE   zx_file.zx02,
          axj02         LIKE   axj_file.axj02,   
          axj06         LIKE   axj_file.axj06,     #FUN-C10036 add   
          axj04_1       LIKE   axj_file.axj04, 
          l_aag_all_1   LIKE   type_file.chr1000,
          axj05_1       LIKE   axj_file.axj05,
          l_axj07_l_1   LIKE   axj_file.axj07,
          l_axj07_r_1   LIKE   axj_file.axj07,
          axj04_2       LIKE   axj_file.axj04,     #
          l_aag_all_2   LIKE   type_file.chr1000,
          axj05_2       LIKE   axj_file.axj05,
          l_axj07_l_2   LIKE   axj_file.axj07,
          l_axj07_r_2   LIKE   axj_file.axj07,
          axj04_3       LIKE   axj_file.axj04,     #
          l_aag_all_3   LIKE   type_file.chr1000,
          axj05_3       LIKE   axj_file.axj05,
          l_axj07_l_3   LIKE   axj_file.axj07,
          l_axj07_r_3   LIKE   axj_file.axj07,
          axj04_4       LIKE   axj_file.axj04,      #
          l_aag_all_4   LIKE   type_file.chr1000,
          axj05_4       LIKE   axj_file.axj05,
          l_axj07_l_4   LIKE   axj_file.axj07,
          l_axj07_r_4   LIKE   axj_file.axj07,
          axj04_5       LIKE   axj_file.axj04,       #
          l_aag_all_5   LIKE   type_file.chr1000,
          axj05_5       LIKE   axj_file.axj05,
          l_axj07_l_5   LIKE   axj_file.axj07,
          l_axj07_r_5   LIKE   axj_file.axj07,
          l_axj07_l_s   LIKE   axj_file.axj07,   #
          l_axj07_r_s   LIKE   axj_file.axj07,
          l_cur_p       LIKE   type_file.num5,
          l_tot_p       LIKE   type_file.num5,
          axz02         LIKE   axz_file.axz02 #FUN-C50004 add
                        END RECORD
   DEFINE l_img_blob    LIKE type_file.blob
   DEFINE l_ii          INTEGER
   DEFINE l_key         RECORD                  #主鍵
          v1            LIKE aba_file.aba01
                        END RECORD
   DEFINE l_str         LIKE type_file.chr1000 
                                

   CALL cl_del_data(l_table)     
   LOCATE l_img_blob IN MEMORY   #blob初始化 
     
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg118'

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')

   LET l_sql = "SELECT DISTINCT axi01,axi05,axi08,axi03,axi04,axi06,axi081,axi02,axi07,",
               "  axj02,axj04,axj05,axj06,aag01,aag02,aag13,aag07,aag08,axj07,",
               #"  0,'','','','','',0,0 ", #FUN-C50004 mark
               "  0,'','','','','',0,0,axz02,zx02 ", #FUN-C50004 add
               #"  FROM axi_file,axj_file,aag_file", #FUN-C50004 mark
               "  FROM axi_file LEFT OUTER JOIN axz_file ON axz01 = axi06 ", #FUN-C50004 add
               "                LEFT OUTER JOIN zx_file ON zx01= axiuser ,axj_file,aag_file", #FUN-C50004 add
               "  WHERE axi00 = axj00",
               "    AND axi00 = aag00",
               "    AND axi01 = axj01",
               "    AND axj03 = aag01",
               "    AND aag07 IN ('2','3')",
               "    AND axiconf <> 'X' ",  #CHI-C80041
               "    AND ",tm.wc CLIPPED
                 
   IF tm.e = 'Y' THEN
      LET l_sql = l_sql CLIPPED, " AND axiconf = 'Y' "
   ELSE
      LET l_sql = l_sql CLIPPED, " AND axiconf = 'N' "
   END IF
        
   CASE WHEN tm.s = '1' LET l_sql = l_sql CLIPPED ,"  ORDER BY axi01,axj06"
      WHEN tm.s = '2' LET l_sql = l_sql CLIPPED ,"  ORDER BY axi01,axj02 "
   END CASE

   PREPARE aglg118_prepare1 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE aglg118_curs1 CURSOR FOR aglg118_prepare1
   LET l_axi01 = NULL
   LET l_i = 0
   LET l_l_axj07_l = 0
   LET l_l_axj07_r = 0
   LET l_n = 1        
   INITIALIZE sr1.* TO NULL
   FOREACH aglg118_curs1 INTO sr.*
      IF sr.axj06 = '1' THEN 
         LET sr.l_axj07_l = sr.axj07
         LET sr.l_axj07_r = null
      ELSE 
         IF sr.axj06 = '2' THEN
            LET sr.l_axj07_l = null
            LET sr.l_axj07_r = sr.axj07
         END IF
      END IF
 
      LET sr.l_aag01_l = sr.aag01

      SELECT aag02 INTO sr.l_aag02_r FROM aag_file
           WHERE aag01 = sr.l_aag01_l
             AND aag00 = sr.axi07
      SELECT axj03 INTO l_axj03 FROM axj_file
           WHERE axj03 = sr.l_aag01_l
             AND axj01 = sr.axi01

      LET sr.l_aag_all = l_axj03 CLIPPED,'-(',sr.l_aag02_r CLIPPED,')'
                          
      IF NOT cl_null(l_axi01) THEN
         #新一筆憑証
         IF l_axi01 <> sr.axi01 THEN
            #當前頁
            LET sr1.l_cur_p = l_i / 5
            IF l_i MOD 5 <> 0 THEN
               LET sr1.l_cur_p = sr1.l_cur_p + 1
            END IF
 
            LET sr1.l_axj07_l_s = l_l_axj07_l     #FUN-B60134
            LET sr1.l_axj07_r_s = l_l_axj07_r     #FUN-B60134     

            #FUN-B60134---modify---start---
            #IF g_lang = '0' OR g_lang = '2' THEN                              
            #     LET sr1.l_axj07_l_c = s_sayc2(l_l_axj07_l,50)                  
            #  ELSE                                                              
            #     CALL cl_say(l_l_axj07_l,80) RETURNING l_str1,l_str2            
            #     LET sr1.l_axj07_l_c = l_str1 CLIPPED," ",l_str2 CLIPPED        
            #  END IF   
            #FUN-B60134---modify---end---
            EXECUTE insert_prep USING sr1.*,l_n,       
                                      "",l_img_blob,"N",""  # No.FUN-C40020 add    
            INITIALIZE sr1.* TO NULL 
            LET l_n = l_n + 1                          
            LET l_i = 0
            LET l_l_axj07_l = 0         #FUN-B60134
            LET l_l_axj07_r = 0         #FUN-B60134
         ELSE
            #每5筆,打一頁,加入AND條件,否則可能多打一頁
            IF l_i MOD 5 = 0 THEN   
               LET sr1.l_cur_p = l_i / 5        
               EXECUTE insert_prep USING sr1.*,l_n,    
                                           "",l_img_blob,"N",""  # No.FUN-C40020 add   
               INITIALIZE sr1.* TO NULL
               LET l_n = l_n + 1                       
            END IF
         END IF
      END IF
      SELECT COUNT(*) INTO sr1.l_tot_p FROM axi_file,axj_file,aag_file 
       WHERE axi00 = axj00
         AND axi01 = axj01
         AND axi00 = aag00
         AND axj03 = aag01
         AND axi01 = sr.axi01
         AND axiconf <> 'X'  #CHI-C80041
      LET l_temp1 = sr1.l_tot_p/5
      IF sr1.l_tot_p MOD 5 <> 0 THEN 
         LET sr1.l_tot_p = l_temp1 + 1
      ELSE
         LET sr1.l_tot_p = l_temp1
      END IF
     # SELECT axiuser INTO l_axiuser FROM axi_file WHERE axi01=sr.axi01 #FUN-C50004 mark
     # SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=l_axiuser #FUN-C50004 mark
        
        #每一筆處理
      LET sr1.axi01 = sr.axi01
      LET sr1.axi02 = sr.axi02
      LET sr1.axi05 = sr.axi05
      LET sr1.axi08 = sr.axi08
      LET sr1.axi03 = sr.axi03
      LET sr1.axi04 = sr.axi04
      LET sr1.axi06 = sr.axi06
      LET sr1.axi081= sr.axi081                     
      LET sr1.axj02 = sr.axj02
      LET sr1.axj06 = sr.axj06              #FUN-C10036 add
      #LET sr1.zx02  = l_zx02 #FUN-C50004 mark
      LET sr1.axz02 = sr.axz02 #FUN-C50004 add
      LET sr1.zx02  = sr.zx02  #FUN-C50004 add

      CASE l_i MOD 5
         WHEN 0 LET sr1.axj04_1 = sr.axj04
                LET sr1.l_aag_all_1 = sr.l_aag_all
                LET sr1.axj05_1 = sr.axj05
                LET sr1.l_axj07_l_1 = sr.l_axj07_l
                LET sr1.l_axj07_r_1 = sr.l_axj07_r

         WHEN 1 LET sr1.axj04_2 = sr.axj04
                LET sr1.l_aag_all_2 = sr.l_aag_all
                LET sr1.axj05_2 = sr.axj05
                LET sr1.l_axj07_l_2 = sr.l_axj07_l
                LET sr1.l_axj07_r_2 = sr.l_axj07_r

         WHEN 2 LET sr1.axj04_3 = sr.axj04
                LET sr1.l_aag_all_3 = sr.l_aag_all
                LET sr1.axj05_3 = sr.axj05
                LET sr1.l_axj07_l_3 = sr.l_axj07_l
                LET sr1.l_axj07_r_3 = sr.l_axj07_r
                   
         WHEN 3 LET sr1.axj04_4 = sr.axj04
                LET sr1.l_aag_all_4 = sr.l_aag_all
                LET sr1.axj05_4 = sr.axj05
                LET sr1.l_axj07_l_4 = sr.l_axj07_l
                LET sr1.l_axj07_r_4 = sr.l_axj07_r

         WHEN 4 LET sr1.axj04_5 = sr.axj04
                LET sr1.l_aag_all_5 = sr.l_aag_all
                LET sr1.axj05_5 = sr.axj05
                LET sr1.l_axj07_l_5 = sr.l_axj07_l
                LET sr1.l_axj07_r_5 = sr.l_axj07_r

      END CASE
        
      LET l_i = l_i + 1
      LET l_axi01 = sr.axi01
      IF sr.l_axj07_l IS NULL THEN LET sr.l_axj07_l = 0 END IF
      IF sr.l_axj07_r IS NULL THEN LET sr.l_axj07_r = 0 END IF
      LET l_l_axj07_l = l_l_axj07_l + sr.l_axj07_l         #FUN-B60134
      LET l_l_axj07_r = l_l_axj07_r + sr.l_axj07_r         #FUN-B60134 
   END FOREACH
     #最后一筆
   IF l_i > 0 THEN
     #當前頁
      LET sr1.l_cur_p = l_i / 5
      IF l_i MOD 5 <> 0 THEN
         LET sr1.l_cur_p = sr1.l_cur_p + 1
      END IF
 
      LET sr1.l_axj07_l_s = l_l_axj07_l         #FUN-B60134
      LET sr1.l_axj07_r_s = l_l_axj07_r         #FUN-B60134 

      #FUN-B60134---modify---start---                                          
       # IF g_lang = '0' OR g_lang = '2' THEN                                    
       #    LET sr1.l_axj07_l_c = s_sayc2(l_l_axj07_l,50)                        
       # ELSE                                                                    
       #    CALL cl_say(l_l_axj07_l,80) RETURNING l_str1,l_str2                  
       #    LET sr1.l_axj07_l_c = l_str1 CLIPPED," ",l_str2 CLIPPED              
       # END IF                                                                  
       #FUN-B60134---modify---end---
      
      EXECUTE insert_prep USING sr1.*,l_n,     
                                  "",l_img_blob,"N"   
      INITIALIZE sr1.* TO NULL
      LET l_n = l_n + 1                       
      LET l_i = 0
   END IF

###GENGRE###   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"  ORDER BY axi01,L_CUR_P "
     
   IF g_zz05='Y' THEN                                                                                                              
      CALL cl_wcchp(tm.wc,'axi05,axi01,axi02,axi03,axi04,axi08,axi081')                                                           
      RETURNING tm.wc                                                                                                              
   END IF
###GENGRE###   LET g_str = tm.wc
   LET g_cr_table = l_table                 #主報表的temp table名稱
   LET g_cr_gcx01 = "agli108"               #單別維護程式
   LET g_cr_apr_key_f = "axi01"             #報表主鍵欄位名稱，用"|"隔開 
###GENGRE###   CALL  cl_prt_cs3('aglg118','aglg118',g_sql,g_str)
    CALL aglg118_grdata()    ###GENGRE###
END FUNCTION

#MOD-BB0262

###GENGRE###START
FUNCTION aglg118_grdata()
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
        LET handler = cl_gre_outnam("aglg118")
        IF handler IS NOT NULL THEN
            START REPORT aglg118_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED

            #FUN-C10036----add--str--
            CASE WHEN tm.s = '1' LET l_sql = l_sql CLIPPED ,"  ORDER BY axi01,axj06"
                 WHEN tm.s = '2' LET l_sql = l_sql CLIPPED ,"  ORDER BY axi01,axj02 "
            END CASE
            #FUN-C10036----add--end--
          
            DECLARE aglg118_datacur1 CURSOR FROM l_sql
            FOREACH aglg118_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg118_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg118_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg118_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-C10036-----add---str--
    DEFINE l_name1       STRING
    DEFINE l_name2       STRING
    DEFINE l_q1          LIKE axj_file.axj07
    DEFINE l_q2          LIKE axj_file.axj07
    #FUN-C10036-----add---end--

    ORDER EXTERNAL BY sr1.axi01 
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-C10036 add g_ptime,g_user_name
            PRINTX tm.*
              
         BEFORE GROUP OF sr1.axi01
            LET l_lineno = 0

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-C10036-----add---str--
            IF sr1.axi08 = '1' OR sr1.axi08 = '2' OR sr1.axi08 = '3' OR sr1.axi08 = '4' OR sr1.axi08 = '5' OR sr1.axi08 = '6' THEN
               LET l_name1 = cl_gr_getmsg("gre-255",g_lang,sr1.axi08)
            ELSE
               LET l_name1 = " "
            END IF
            PRINTX l_name1

            IF sr1.axi081 = '1' OR sr1.axi081 = '2' OR sr1.axi081 = '3' 
               OR sr1.axi081 = '4' OR sr1.axi081 = '5' OR sr1.axi081 = '6' OR sr1.axi081 = '7'
               OR sr1.axi081 = 'U' OR sr1.axi081 = 'V' OR sr1.axi081 = 'W' THEN
               LET l_name2 = cl_gr_getmsg("gre-256",g_lang,sr1.axi081)
            ELSE
               LET l_name2 = " "
            END IF
            PRINTX l_name2

            IF sr1.l_axj07_l_s = 0 THEN
               LET l_q1 = 0.00
            ELSE
               LET l_q1 = sr1.l_axj07_l_s
            END IF
            PRINTX l_q1

            IF sr1.l_axj07_r_s = 0 THEN
               LET l_q2 = 0.00
            ELSE
               LET l_q2 = sr1.l_axj07_r_s
            END IF
            PRINTX l_q2
            #FUN-C10036-----add---end--

            PRINTX sr1.*

         AFTER GROUP OF sr1.axi01

        
        ON LAST ROW

END REPORT
###GENGRE###END
