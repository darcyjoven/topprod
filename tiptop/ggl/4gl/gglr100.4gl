# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Descriptions...: 合併抵銷調整憑證
# Date & Author..: No:FUN-B60134 11/07/12 By Lujh
# Modify.........: No:FUN-B60134 11/08/11 By Lujh     增加期别asj04,修改报表单据日期显示格式，增加合计
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-BC0008 11/12/08 By bart 增加金額取位欄位
 
DATABASE ds    #FUN-BB0036
 
GLOBALS "../../config/top.global"
 
DEFINE  tm        RECORD                    #Print condition RECORD
        s         LIKE type_file.chr1000,   #排序方式 
        wc        LIKE type_file.chr1000,   #Where Condiction
        e         LIKE type_file.chr1,      #審核否
        m         LIKE type_file.chr1       #是否輸入其它特殊列印條件
                  END RECORD 

DEFINE  g_asj05   LIKE asj_file.asj05         
DEFINE  g_i       LIKE type_file.num5       #count/index for any purpose
DEFINE  g_sql     STRING            
DEFINE  l_table   STRING             
DEFINE  g_str     STRING            
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

   LET g_sql="asj01.asj_file.asj01,",
             "asj05.asj_file.asj05,",
             "asj08.ze_file.ze03,",
             "asj03.asj_file.asj01,",
             "asj04.asj_file.asj01,",          #FUN-B60134   添加期别
             "asj06.asj_file.asj06,",
             "asj081.ze_file.ze03,",
             "asj02.asj_file.asj02,",
             "zx02.zx_file.zx02,",
             "ask02.ask_file.ask02,",   
             "ask04_1.ask_file.ask04,",     #
             "l_aag_all_1.type_file.chr1000,",
             "ask05_1.ask_file.ask05,",
             "l_ask07_l_1.ask_file.ask07,",
             "l_ask07_r_1.ask_file.ask07,",
             "ask04_2.ask_file.ask04,",     #
             "l_aag_all_2.type_file.chr1000,",
             "ask05_2.ask_file.ask05,",
             "l_ask07_l_2.ask_file.ask07,",
             "l_ask07_r_2.ask_file.ask07,",
             "ask04_3.ask_file.ask04,",     #
             "l_aag_all_3.type_file.chr1000,",
             "ask05_3.ask_file.ask05,",
             "l_ask07_l_3.ask_file.ask07,",
             "l_ask07_r_3.ask_file.ask07,",
             "ask04_4.ask_file.ask04,",      #
             "l_aag_all_4.type_file.chr1000,",
             "ask05_4.ask_file.ask05,",
             "l_ask07_l_4.ask_file.ask07,",
             "l_ask07_r_4.ask_file.ask07,",
             "ask04_5.ask_file.ask04,",       #
             "l_aag_all_5.type_file.chr1000,",
             "ask05_5.ask_file.ask05,",
             "l_ask07_l_5.ask_file.ask07,",
             "l_ask07_r_5.ask_file.ask07,",
             "l_ask07_l_s.ask_file.ask07,",   #FUN-B60134    借方合计
             "l_ask07_r_s.ask_file.ask07,",   #FUN-B60134    贷方合计
             " l_cur_p.type_file.num5,",
             " l_tot_p.type_file.num5,",
             " l_n.type_file.num5,",                                                                                       
             "sign_type.type_file.chr1,",   #簽核方式     
             "sign_img.type_file.blob,",    #簽核圖檔     
             "sign_show.type_file.chr1,",    #是否顯示簽核資料(Y/N)  
             "azi04.azi_file.azi04,",  #NO.TQC-BC0008
             "azi05.azi_file.azi05 "   #NO.TQC-BC0008
             

   LET l_table=cl_prt_temptable("gglr100",g_sql) CLIPPED                                                                           
   IF l_table=-1 THEN EXIT PROGRAM 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
   END IF                                                                                          
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?  )         "      #NO.TQC-BC0008 增加2個?                                                                 
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
      THEN CALL gglr100_tm()	        	# Input print condition
      ELSE CALL gglr100()			        # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION gglr100_tm()
   DEFINE  lc_qbe_sn     LIKE gbm_file.gbm01   
   DEFINE  p_row,p_col	 LIKE type_file.num5,    
           l_cmd		 LIKE type_file.chr1000  
 

   IF g_gui_type = '1' AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE 
      LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW gglr100_w AT p_row,p_col
        WITH FORM "ggl/42f/gglr100"
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
   CONSTRUCT BY NAME tm.wc ON asj05,asj01,asj02,asj03,asj04,asj08,asj081
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

       ON ACTION controlp
          CASE 
             WHEN INFIELD (asj05)
                CALL cl_init_qry_var()
                LET g_qryparam.state='c'
                LET g_qryparam.form="q_asa1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO asj05
                NEXT FIELD asj05 
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
       CLOSE WINDOW gglr100_w 
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

       ON ACTION CONTROLZ
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
      CLOSE WINDOW gglr100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
             WHERE zz01='gglr100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglr100','9031',1)   
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
         CALL cl_cmdat('gglr100',g_time,l_cmd)	# Execute cmd at later time
      END IF
      CLOSE WINDOW gglr100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL gglr100()
   ERROR ""
   END WHILE
   CLOSE WINDOW gglr100_w
END FUNCTION
 
FUNCTION gglr100()
   DEFINE l_name	    LIKE type_file.chr20,   
          l_sql 	    LIKE type_file.chr1000, 
          l_za05	    LIKE type_file.chr1000,   #標題內容
          l_asjuser     LIKE asj_file.asjuser,              
          l_zx02        LIKE zx_file.zx02,   
          l_ask03       LIKE ask_file.ask03, 
          l_ze01        LIKE ze_file.ze01,
          l_ze03        LIKE ze_file.ze03,         
          l_i           LIKE type_file.num5,    
          l_temp1       LIKE type_file.num5,    
          l_temp2       LIKE type_file.num5,    
          l_n           LIKE type_file.num5,    
          sr            RECORD
          asj01         LIKE asj_file.asj01,
          asj05         LIKE asj_file.asj05,
          asj08         LIKE ze_file.ze03,
          asj03         LIKE asj_file.asj01,
          asj04         LIKE asj_file.asj01,
          asj06         LIKE asj_file.asj06,
          asj081        LIKE ze_file.ze03,
          asj02         LIKE asj_file.asj02,
          asj07         LIKE asj_file.asj07,
          ask02         LIKE ask_file.ask02,#項次
          ask04         LIKE ask_file.ask04,#摘要
          ask05         LIKE ask_file.ask05,
          ask06         LIKE ask_file.ask06,
          aag01         LIKE aag_file.aag01,
          aag02         LIKE aag_file.aag02,#科目名稱
          aag13         LIKE aag_file.aag13,#額外名稱
          aag07         LIKE aag_file.aag07,
          aag08         LIKE aag_file.aag08,
          ask07         LIKE ask_file.ask07,    
          l_pageno      LIKE type_file.num5,   
          l_aag01_l     LIKE aag_file.aag01,    
          l_aag01_r     LIKE aag_file.aag01,   
          l_aag02_l     LIKE aag_file.aag02,    
          l_aag02_r     LIKE aag_file.aag02,   
          l_aag_all     LIKE type_file.chr1000, 
          l_ask07_l     LIKE ask_file.ask07,    
          l_ask07_r     LIKE ask_file.ask07     
                        END RECORD
   DEFINE l_l_ask07_l   LIKE ask_file.ask07
   DEFINE l_l_ask07_r   LIKE ask_file.ask07
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_asj01       LIKE asj_file.asj01
   DEFINE l_str1        STRING                      
   DEFINE l_str2        STRING                     
   DEFINE sr1           RECORD
          asj01         LIKE   asj_file.asj01,
          asj05         LIKE   asj_file.asj05,
          asj08         LIKE   ze_file.ze03,
          asj03         LIKE   asj_file.asj01,
          asj04         LIKE   asj_file.asj01,
          asj06         LIKE   asj_file.asj06,  
          asj081        LIKE   ze_file.ze03,
          asj02         LIKE   asj_file.asj02,
          zx02          LIKE   zx_file.zx02,
          ask02         LIKE   ask_file.ask02,   
          ask04_1       LIKE   ask_file.ask04, 
          l_aag_all_1   LIKE   type_file.chr1000,
          ask05_1       LIKE   ask_file.ask05,
          l_ask07_l_1   LIKE   ask_file.ask07,
          l_ask07_r_1   LIKE   ask_file.ask07,
          ask04_2       LIKE   ask_file.ask04,     #
          l_aag_all_2   LIKE   type_file.chr1000,
          ask05_2       LIKE   ask_file.ask05,
          l_ask07_l_2   LIKE   ask_file.ask07,
          l_ask07_r_2   LIKE   ask_file.ask07,
          ask04_3       LIKE   ask_file.ask04,     #
          l_aag_all_3   LIKE   type_file.chr1000,
          ask05_3       LIKE   ask_file.ask05,
          l_ask07_l_3   LIKE   ask_file.ask07,
          l_ask07_r_3   LIKE   ask_file.ask07,
          ask04_4       LIKE   ask_file.ask04,      #
          l_aag_all_4   LIKE   type_file.chr1000,
          ask05_4       LIKE   ask_file.ask05,
          l_ask07_l_4   LIKE   ask_file.ask07,
          l_ask07_r_4   LIKE   ask_file.ask07,
          ask04_5       LIKE   ask_file.ask04,       #
          l_aag_all_5   LIKE   type_file.chr1000,
          ask05_5       LIKE   ask_file.ask05,
          l_ask07_l_5   LIKE   ask_file.ask07,
          l_ask07_r_5   LIKE   ask_file.ask07,
          l_ask07_l_s   LIKE   ask_file.ask07,   #
          l_ask07_r_s   LIKE   ask_file.ask07,
          l_cur_p       LIKE   type_file.num5,
          l_tot_p       LIKE   type_file.num5
                        END RECORD
   DEFINE l_img_blob    LIKE type_file.blob
   DEFINE l_ii          INTEGER
   DEFINE l_key         RECORD                  #主鍵
          v1            LIKE aba_file.aba01
                        END RECORD
   DEFINE l_str         LIKE type_file.chr1000 
                                

   CALL cl_del_data(l_table)     
   LOCATE l_img_blob IN MEMORY   #blob初始化 
     
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'gglr100'

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('abauser', 'abagrup')

   LET l_sql = "SELECT DISTINCT asj01,asj05,asj08,asj03,asj04,asj06,asj081,asj02,asj07,",
               "  ask02,ask04,ask05,ask06,aag01,aag02,aag13,aag07,aag08,ask07,",
               "  0,'','','','','',0,0 ",
               "  FROM asj_file,ask_file,aag_file",
               "  WHERE asj00 = ask00",
               "    AND asj00 = aag00",
               "    AND asj01 = ask01",
               "    AND ask03 = aag01",
               "    AND aag07 IN ('2','3')",
               "    AND ",tm.wc CLIPPED
                 
   IF tm.e = 'Y' THEN
      LET l_sql = l_sql CLIPPED, " AND asjconf = 'Y' "
   ELSE
      LET l_sql = l_sql CLIPPED, " AND asjconf = 'N' "
   END IF
        
   CASE WHEN tm.s = '1' LET l_sql = l_sql CLIPPED ,"  ORDER BY asj01,ask06"
      WHEN tm.s = '2' LET l_sql = l_sql CLIPPED ,"  ORDER BY asj01,ask02 "
   END CASE

   PREPARE gglr100_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   DECLARE gglr100_curs1 CURSOR FOR gglr100_prepare1
   LET l_asj01 = NULL
   LET l_i = 0
   LET l_l_ask07_l = 0
   LET l_l_ask07_r = 0
   LET l_n = 1        
   INITIALIZE sr1.* TO NULL
   FOREACH gglr100_curs1 INTO sr.*
      IF sr.ask06 = '1' THEN 
         LET sr.l_ask07_l = sr.ask07
         LET sr.l_ask07_r = null
      ELSE 
         IF sr.ask06 = '2' THEN
            LET sr.l_ask07_l = null
            LET sr.l_ask07_r = sr.ask07
         END IF
      END IF
 
      LET sr.l_aag01_l = sr.aag01

      SELECT aag02 INTO sr.l_aag02_r FROM aag_file
           WHERE aag01 = sr.l_aag01_l
             AND aag00 = sr.asj07
      SELECT ask03 INTO l_ask03 FROM ask_file
           WHERE ask03 = sr.l_aag01_l
             AND ask01 = sr.asj01

      LET sr.l_aag_all = l_ask03 CLIPPED,'-(',sr.l_aag02_r CLIPPED,')'
                          
      IF NOT cl_null(l_asj01) THEN
         #新一筆憑証
         IF l_asj01 <> sr.asj01 THEN
            #當前頁
            LET sr1.l_cur_p = l_i / 5
            IF l_i MOD 5 <> 0 THEN
               LET sr1.l_cur_p = sr1.l_cur_p + 1
            END IF
 
            LET sr1.l_ask07_l_s = l_l_ask07_l     #FUN-B60134
            LET sr1.l_ask07_r_s = l_l_ask07_r     #FUN-B60134     

            #FUN-B60134---modify---start---
            #IF g_lang = '0' OR g_lang = '2' THEN                              
            #     LET sr1.l_ask07_l_c = s_satu2(l_l_ask07_l,50)                  
            #  ELSE                                                              
            #     CALL cl_say(l_l_ask07_l,80) RETURNING l_str1,l_str2            
            #     LET sr1.l_ask07_l_c = l_str1 CLIPPED," ",l_str2 CLIPPED        
            #  END IF   
            #FUN-B60134---modify---end---
            EXECUTE insert_prep USING sr1.*,l_n,       
                                      "",l_img_blob,"N",g_azi04,g_azi05    #NO.TQC-BC0008  g_azi04,g_azi05
            INITIALIZE sr1.* TO NULL 
            LET l_n = l_n + 1                          
            LET l_i = 0
            LET l_l_ask07_l = 0         #FUN-B60134
            LET l_l_ask07_r = 0         #FUN-B60134
         ELSE
            #每5筆,打一頁,加入AND條件,否則可能多打一頁
            IF l_i MOD 5 = 0 THEN   
               LET sr1.l_cur_p = l_i / 5        
               EXECUTE insert_prep USING sr1.*,l_n,    
                                           "",l_img_blob,"N",g_azi04,g_azi05  #NO.TQC-BC0008 g_azi04,g_azi05
               INITIALIZE sr1.* TO NULL
               LET l_n = l_n + 1                       
            END IF
         END IF
      END IF
      SELECT COUNT(*) INTO sr1.l_tot_p FROM asj_file,ask_file,aag_file 
       WHERE asj00 = ask00
         AND asj01 = ask01
         AND asj00 = aag00
         AND ask03 = aag01
         AND asj01 = sr.asj01
      LET l_temp1 = sr1.l_tot_p/5
      IF sr1.l_tot_p MOD 5 <> 0 THEN 
         LET sr1.l_tot_p = l_temp1 + 1
      ELSE
         LET sr1.l_tot_p = l_temp1
      END IF
      SELECT asjuser INTO l_asjuser FROM asj_file WHERE asj01=sr.asj01
      SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=l_asjuser
        
        #每一筆處理
      LET sr1.asj01 = sr.asj01
      LET sr1.asj02 = sr.asj02
      LET sr1.asj05 = sr.asj05
      LET sr1.asj08 = sr.asj08
      LET sr1.asj03 = sr.asj03
      LET sr1.asj04 = sr.asj04
      LET sr1.asj06 = sr.asj06
      LET sr1.asj081= sr.asj081                     
      LET sr1.ask02 = sr.ask02
      LET sr1.zx02  = l_zx02

      CASE l_i MOD 5
         WHEN 0 LET sr1.ask04_1 = sr.ask04
                LET sr1.l_aag_all_1 = sr.l_aag_all
                LET sr1.ask05_1 = sr.ask05
                LET sr1.l_ask07_l_1 = sr.l_ask07_l
                LET sr1.l_ask07_r_1 = sr.l_ask07_r

         WHEN 1 LET sr1.ask04_2 = sr.ask04
                LET sr1.l_aag_all_2 = sr.l_aag_all
                LET sr1.ask05_2 = sr.ask05
                LET sr1.l_ask07_l_2 = sr.l_ask07_l
                LET sr1.l_ask07_r_2 = sr.l_ask07_r

         WHEN 2 LET sr1.ask04_3 = sr.ask04
                LET sr1.l_aag_all_3 = sr.l_aag_all
                LET sr1.ask05_3 = sr.ask05
                LET sr1.l_ask07_l_3 = sr.l_ask07_l
                LET sr1.l_ask07_r_3 = sr.l_ask07_r
                   
         WHEN 3 LET sr1.ask04_4 = sr.ask04
                LET sr1.l_aag_all_4 = sr.l_aag_all
                LET sr1.ask05_4 = sr.ask05
                LET sr1.l_ask07_l_4 = sr.l_ask07_l
                LET sr1.l_ask07_r_4 = sr.l_ask07_r

         WHEN 4 LET sr1.ask04_5 = sr.ask04
                LET sr1.l_aag_all_5 = sr.l_aag_all
                LET sr1.ask05_5 = sr.ask05
                LET sr1.l_ask07_l_5 = sr.l_ask07_l
                LET sr1.l_ask07_r_5 = sr.l_ask07_r

      END CASE
        
      LET l_i = l_i + 1
      LET l_asj01 = sr.asj01
      IF sr.l_ask07_l IS NULL THEN LET sr.l_ask07_l = 0 END IF
      IF sr.l_ask07_r IS NULL THEN LET sr.l_ask07_r = 0 END IF
      LET l_l_ask07_l = l_l_ask07_l + sr.l_ask07_l         #FUN-B60134
      LET l_l_ask07_r = l_l_ask07_r + sr.l_ask07_r         #FUN-B60134 
   END FOREACH
     #最后一筆
   IF l_i > 0 THEN
     #當前頁
      LET sr1.l_cur_p = l_i / 5
      IF l_i MOD 5 <> 0 THEN
         LET sr1.l_cur_p = sr1.l_cur_p + 1
      END IF
 
      LET sr1.l_ask07_l_s = l_l_ask07_l         #FUN-B60134
      LET sr1.l_ask07_r_s = l_l_ask07_r         #FUN-B60134 

      #FUN-B60134---modify---start---                                          
       # IF g_lang = '0' OR g_lang = '2' THEN                                    
       #    LET sr1.l_ask07_l_c = s_satu2(l_l_ask07_l,50)                        
       # ELSE                                                                    
       #    CALL cl_say(l_l_ask07_l,80) RETURNING l_str1,l_str2                  
       #    LET sr1.l_ask07_l_c = l_str1 CLIPPED," ",l_str2 CLIPPED              
       # END IF                                                                  
       #FUN-B60134---modify---end---
      
      EXECUTE insert_prep USING sr1.*,l_n,     
                                  "",l_img_blob,"N",g_azi04,g_azi05   #NO.TQC-BC0008 g_azi04,g_azi05
      INITIALIZE sr1.* TO NULL
      LET l_n = l_n + 1                       
      LET l_i = 0
   END IF

   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"  ORDER BY asj01,L_CUR_P "
     
   IF g_zz05='Y' THEN                                                                                                              
      CALL cl_wcchp(tm.wc,'asj05,asj01,asj02,asj03,asj04,asj08,asj081')                                                           
      RETURNING tm.wc                                                                                                              
   END IF
   LET g_str = tm.wc
   LET g_cr_table = l_table                 #主報表的temp table名稱
   LET g_cr_gcx01 = "agli108"               #單別維護程式
   LET g_cr_apr_key_f = "asj01"             #報表主鍵欄位名稱，用"|"隔開 
   CALL  cl_prt_cs3('gglr100','gglr100',g_sql,g_str)
END FUNCTION


