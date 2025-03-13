# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr019.4gl
# Descriptions...: 用人单位退工（减员）登记表
# Date & Author..: 13/08/21 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc        LIKE type_file.chr1000,  
            hrat03    LIKE hrat_file.hrat03,      #公司编号
            hrcp03_y  LIKE type_file.num20,        #基准年份
            hrcp03_m  LIKE type_file.num20,        #基准月份
            qj      LIKE type_file.chr3           #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING                 
DEFINE g_sql       STRING                   
DEFINE g_str       STRING,
       g_date1     STRING
DEFINE g_hrag    RECORD LIKE hrag_file.*
        
DEFINE g_hrcp    DYNAMIC ARRAY OF RECORD
       hrcp04        LIKE hrcp_file.hrcp04,
       hrcp04_name   LIKE type_file.chr50,
       hrcp09        LIKE hrcp_file.hrcp09,
       job           LIKE type_file.num20,
       q1            LIKE type_file.num20,
       q2            LIKE type_file.num20,
       q3            LIKE type_file.num20,
       q4            LIKE type_file.num20,
       q5            LIKE type_file.num20,
       q6            LIKE type_file.num20,
       q7            LIKE type_file.num20,
       q8            LIKE type_file.num20

       END RECORD 
   DEFINE g_hrcp11     LIKE   hrcp_file.hrcp11,
          g_hrcp13     LIKE   hrcp_file.hrcp13,
          g_hrcp15     LIKE   hrcp_file.hrcp15,
          g_hrcp17     LIKE   hrcp_file.hrcp17,
          g_hrcp19     LIKE   hrcp_file.hrcp19
   DEFINE l_sum         LIKE   type_file.num20
                   
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                     
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ghr")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = " l_com.type_file.chr20, l_year.type_file.chr20 ,",
               " l_month.type_file.chr20,",
               " l_n.type_file.num20,         hrat01.hrat_file.hrat01 ,",
               " hrat02.hrat_file.hrat02,    hrat04.hrat_file.hrat04      ,",
               " hrcp04_1.hrcp_file.hrcp04,  hrcp04_name1.type_file.chr50 ,",
               " hrcp09_1.hrcp_file.hrcp09,  job1.type_file.num20          ,",
               " hrcp04_2.hrcp_file.hrcp04,  hrcp04_name2.type_file.chr50 ,",
               " hrcp09_2.hrcp_file.hrcp09,  job2.type_file.num20          ,",
               " hrcp04_3.hrcp_file.hrcp04,  hrcp04_name3.type_file.chr50 ,",
               " hrcp09_3.hrcp_file.hrcp09,  job3.type_file.num20          ,",
               " hrcp04_4.hrcp_file.hrcp04,  hrcp04_name4.type_file.chr50 ,",
               " hrcp09_4.hrcp_file.hrcp09,  job4.type_file.num20          ,",
               " hrcp04_5.hrcp_file.hrcp04,  hrcp04_name5.type_file.chr50 ,",
               " hrcp09_5.hrcp_file.hrcp09,  job5.type_file.num20          ,",
               " hrcp04_6.hrcp_file.hrcp04,  hrcp04_name6.type_file.chr50 ,",
               " hrcp09_6.hrcp_file.hrcp09,  job6.type_file.num20          ,",
               " hrcp04_7.hrcp_file.hrcp04,  hrcp04_name7.type_file.chr50 ,",
               " hrcp09_7.hrcp_file.hrcp09,  job7.type_file.num20          ,",
               " hrcp04_8.hrcp_file.hrcp04,  hrcp04_name8.type_file.chr50 ,",
               " hrcp09_8.hrcp_file.hrcp09,  job8.type_file.num20          ,",
               " hrcp04_9.hrcp_file.hrcp04,  hrcp04_name9.type_file.chr50 ,",
               " hrcp09_9.hrcp_file.hrcp09,  job9.type_file.num20          ,",
               " hrcp04_10.hrcp_file.hrcp04,  hrcp04_name10.type_file.chr50 ,",
               " hrcp09_10.hrcp_file.hrcp09,  job10.type_file.num20          ,",
               " hrcp04_11.hrcp_file.hrcp04,  hrcp04_name11.type_file.chr50 ,",
               " hrcp09_11.hrcp_file.hrcp09,  job11.type_file.num20          ,",
               " hrcp04_12.hrcp_file.hrcp04,  hrcp04_name12.type_file.chr50 ,",
               " hrcp09_12.hrcp_file.hrcp09,  job12.type_file.num20          ,",
               " hrcp04_13.hrcp_file.hrcp04,  hrcp04_name13.type_file.chr50 ,",
               " hrcp09_13.hrcp_file.hrcp09,  job13.type_file.num20          ,",
               " hrcp04_14.hrcp_file.hrcp04,  hrcp04_name14.type_file.chr50 ,",
               " hrcp09_14.hrcp_file.hrcp09,  job14.type_file.num20          ,",
               " hrcp04_15.hrcp_file.hrcp04,  hrcp04_name15.type_file.chr50 ,",
               " hrcp09_15.hrcp_file.hrcp09,  job15.type_file.num20          ,",
               " hrcp04_16.hrcp_file.hrcp04,  hrcp04_name16.type_file.chr50 ,",
               " hrcp09_16.hrcp_file.hrcp09,  job16.type_file.num20          ,",
               " hrcp04_17.hrcp_file.hrcp04,  hrcp04_name17.type_file.chr50 ,",
               " hrcp09_17.hrcp_file.hrcp09,  job17.type_file.num20          ,",
               " hrcp04_18.hrcp_file.hrcp04,  hrcp04_name18.type_file.chr50 ,",
               " hrcp09_18.hrcp_file.hrcp09,  job18.type_file.num20          ,",
               " hrcp04_19.hrcp_file.hrcp04,  hrcp04_name19.type_file.chr50 ,",
               " hrcp09_19.hrcp_file.hrcp09,  job19.type_file.num20          ,",
               " hrcp04_20.hrcp_file.hrcp04,  hrcp04_name20.type_file.chr50 ,",
               " hrcp09_20.hrcp_file.hrcp09,  job20.type_file.num20          ,",
               " hrcp04_21.hrcp_file.hrcp04,  hrcp04_name21.type_file.chr50 ,",
               " hrcp09_21.hrcp_file.hrcp09,  job21.type_file.num20          ,",
               " hrcp04_22.hrcp_file.hrcp04,  hrcp04_name22.type_file.chr50 ,",
               " hrcp09_22.hrcp_file.hrcp09,  job22.type_file.num20          ,",
               " hrcp04_23.hrcp_file.hrcp04,  hrcp04_name23.type_file.chr50 ,",
               " hrcp09_23.hrcp_file.hrcp09,  job23.type_file.num20          ,",
               " hrcp04_24.hrcp_file.hrcp04,  hrcp04_name24.type_file.chr50 ,",
               " hrcp09_24.hrcp_file.hrcp09,  job24.type_file.num20          ,",
               " hrcp04_25.hrcp_file.hrcp04,  hrcp04_name25.type_file.chr50 ,",
               " hrcp09_25.hrcp_file.hrcp09,  job25.type_file.num20          ,",
               " hrcp04_26.hrcp_file.hrcp04,  hrcp04_name26.type_file.chr50 ,",
               " hrcp09_26.hrcp_file.hrcp09,  job26.type_file.num20          ,",
               " hrcp04_27.hrcp_file.hrcp04,  hrcp04_name27.type_file.chr50 ,",
               " hrcp09_27.hrcp_file.hrcp09,  job27.type_file.num20          ,",
               " hrcp04_28.hrcp_file.hrcp04,  hrcp04_name28.type_file.chr50 ,",
               " hrcp09_28.hrcp_file.hrcp09,  job28.type_file.num20          ,",
               " hrcp04_29.hrcp_file.hrcp04,  hrcp04_name29.type_file.chr50 ,",
               " hrcp09_29.hrcp_file.hrcp09,  job29.type_file.num20          ,",
               " hrcp04_30.hrcp_file.hrcp04,  hrcp04_name30.type_file.chr50 ,",
               " hrcp09_30.hrcp_file.hrcp09,  job30.type_file.num20          ,",
               " hrcp04_31.hrcp_file.hrcp04,  hrcp04_name31.type_file.chr50 ,",
               " hrcp09_31.hrcp_file.hrcp09,  job31.type_file.num20          ,",
               " m1.type_file.num20, m2.type_file.num20 ,",
               " m3.type_file.num20, m4.type_file.num20 ,",
               " m5.type_file.num20, m6.type_file.num20 ,",
               " sum1.type_file.num20, q1.type_file.num20 ,",
               " q2.type_file.num20, q3.type_file.num20  ,",
               " q4.type_file.num20, q5.type_file.num20  ,",
               " q6.type_file.num20, q7.type_file.num20  ,", 
               " q8.type_file.num20, sum2.type_file.num20 "                                                     
               


                             
   LET l_table = cl_prt_temptable('ghrr019',g_sql) CLIPPED   # 产生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table产生

   LET g_pdate  = ARG_VAL(1)                #報表列印參數設定.Print date # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)              #報表列印參數設定.Background job
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)                          
   LET g_rep_user = ARG_VAL(11)                       
   LET g_rep_clas = ARG_VAL(12)                       
   LET g_template = ARG_VAL(13)                      
   LET g_xml.subject = ARG_VAL(14)
   LET g_xml.body = ARG_VAL(15)
   LET g_xml.recipient = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)  
 
   IF (cl_null(g_bgjob) OR g_bgjob = 'N') THEN  
      CALL ghrr019_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr019()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr019_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num20,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
   DEFINE l_hrat03       LIKE hrat_file.hrat03,
          l_company      LIKE type_file.chr20
 
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr019_w AT p_row,p_col WITH FORM "ghr/42f/ghrr019"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   INITIALIZE tm.* TO NULL       
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'       
   LET g_copies = '1'
 
WHILE TRUE

       IF g_action_choice = "locale" THEN
          LET g_action_choice = " "
          CALL cl_dynamic_locale()        #动态转换画面语言
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW ghrr019_w  
      EXIT WHILE        
   END IF
   CONSTRUCT BY NAME tm.wc ON hrat03,hrcp03_y,hrcp03_m

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       INITIALIZE tm.* TO NULL
        AFTER FIELD hrat03
          LET tm.hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(tm.hrat03) THEN
            NEXT FIELD hrat03
          END IF 
          SELECT hraa02 INTO l_company FROM hraa_file WHERE hraa01=tm.hrat03 
          DISPLAY l_company TO hrat03_name   
        AFTER FIELD hrcp03_y
          LET tm.hrcp03_y=GET_FLDBUF(hrcp03_y)
           IF cl_null(tm.hrcp03_y) THEN
             NEXT FIELD hrcp03_y
          END IF
        AFTER FIELD hrcp03_m
          LET tm.hrcp03_m=GET_FLDBUF(hrcp03_m)
          IF cl_null(tm.hrcp03_m) THEN
             NEXT FIELD hrcp03_m
          END IF
         
          
        ON ACTION controlp
          CASE
          	  WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = tm.hrat03
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING tm.hrat03
              DISPLAY BY NAME tm.hrat03
              NEXT FIELD hrat03
                                         
                         	
              OTHERWISE
                 EXIT CASE
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
    
    INPUT BY NAME tm.qj WITHOUT DEFAULTS  
       
       BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       AFTER FIELD qj
          IF tm.qj = 'Y' THEN
             CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
                  RETURNING g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies
          END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG 
          CALL cl_cmdask()    # Command execution
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION EXIT
          LET INT_FLAG = 1
          EXIT INPUT
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
       
#       AFTER INPUT
#          LET g_date1="'",tm.hrcp03_y,"/" CLIPPED,tm.hrcp03_m,"/'" CLIPPED 
#          LET tm.wc="hrat03='",tm.hrat03,"'" CLIPPED

    END INPUT
            
   IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW ghrr019_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr019'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr019','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,     
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",    
                         " '",g_rep_clas CLIPPED,"'",     
                         " '",g_template CLIPPED,"'",       
                         " '",g_rpt_name CLIPPED,"'"          
         CALL cl_cmdat('ghrr019',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr019_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr019()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr019_w
END FUNCTION
 
FUNCTION ghrr019()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000,
         l_sql2      LIKE  type_file.chr1000        
   
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING     
   DEFINE l_lang_t    LIKE type_file.chr1
   DEFINE sr       RECORD
 l_comp    LIKE   type_file.chr20,
 l_year    LIKE   type_file.chr20,
 l_month   LIKE   type_file.chr20,
 l_n       LIKE   type_file.num20,         
 hrat01    LIKE   hrat_file.hrat01,     
 hrat02   LIKE   hrat_file.hrat02,    
 hrat04   LIKE   hrat_file.hrat04,
 hrcp04_1  LIKE   hrcp_file.hrcp04,  
 hrcp04_name1  LIKE   type_file.chr50,
 hrcp09_1  LIKE   hrcp_file.hrcp09,  
 job1      LIKE   type_file.num20,
 hrcp04_2  LIKE   hrcp_file.hrcp04, 
 hrcp04_name2  LIKE   type_file.chr50 ,
 hrcp09_2  LIKE   hrcp_file.hrcp09,  
 job2  LIKE   type_file.num20 ,
 hrcp04_3  LIKE   hrcp_file.hrcp04, 
 hrcp04_name3  LIKE   type_file.chr50 ,
 hrcp09_3  LIKE   hrcp_file.hrcp09, 
 job3  LIKE   type_file.num20          ,
 hrcp04_4  LIKE   hrcp_file.hrcp04, 
 hrcp04_name4  LIKE   type_file.chr50 ,
 hrcp09_4  LIKE   hrcp_file.hrcp09,  
 job4  LIKE   type_file.num20          ,
 hrcp04_5  LIKE   hrcp_file.hrcp04, 
 hrcp04_name5  LIKE   type_file.chr50 ,
 hrcp09_5  LIKE   hrcp_file.hrcp09,  
 job5  LIKE   type_file.num20          ,
 hrcp04_6  LIKE   hrcp_file.hrcp04, 
 hrcp04_name6  LIKE   type_file.chr50 ,
 hrcp09_6  LIKE   hrcp_file.hrcp09, 
 job6  LIKE   type_file.num20          ,
 hrcp04_7  LIKE   hrcp_file.hrcp04,  
 hrcp04_name7  LIKE   type_file.chr50 ,
 hrcp09_7  LIKE   hrcp_file.hrcp09, 
 job7  LIKE   type_file.num20          ,
 hrcp04_8  LIKE   hrcp_file.hrcp04,  
 hrcp04_name8  LIKE   type_file.chr50 ,
 hrcp09_8  LIKE   hrcp_file.hrcp09, 
 job8  LIKE   type_file.num20          ,
 hrcp04_9  LIKE   hrcp_file.hrcp04, 
 hrcp04_name9  LIKE   type_file.chr50 ,
 hrcp09_9  LIKE   hrcp_file.hrcp09, 
 job9  LIKE   type_file.num20          ,
 hrcp04_10  LIKE   hrcp_file.hrcp04, 
 hrcp04_name10  LIKE   type_file.chr50 ,
 hrcp09_10  LIKE   hrcp_file.hrcp09, 
 job10  LIKE   type_file.num20          ,
 hrcp04_11  LIKE   hrcp_file.hrcp04,
 hrcp04_name11  LIKE   type_file.chr50 ,
 hrcp09_11  LIKE   hrcp_file.hrcp09, 
 job11  LIKE   type_file.num20          ,
 hrcp04_12  LIKE   hrcp_file.hrcp04,  
 hrcp04_name12  LIKE   type_file.chr50 ,
 hrcp09_12  LIKE   hrcp_file.hrcp09, 
 job12  LIKE   type_file.num20          ,
 hrcp04_13  LIKE   hrcp_file.hrcp04,  
 hrcp04_name13  LIKE   type_file.chr50 ,
 hrcp09_13  LIKE   hrcp_file.hrcp09, 
 job13  LIKE   type_file.num20          ,
 hrcp04_14  LIKE   hrcp_file.hrcp04, 
 hrcp04_name14  LIKE   type_file.chr50 ,
 hrcp09_14  LIKE   hrcp_file.hrcp09, 
 job14  LIKE   type_file.num20          ,
 hrcp04_15  LIKE   hrcp_file.hrcp04, 
 hrcp04_name15  LIKE   type_file.chr50 ,
 hrcp09_15  LIKE   hrcp_file.hrcp09, 
 job15  LIKE   type_file.num20          ,
 hrcp04_16  LIKE   hrcp_file.hrcp04, 
 hrcp04_name16  LIKE   type_file.chr50 ,
 hrcp09_16  LIKE   hrcp_file.hrcp09, 
 job16  LIKE   type_file.num20          ,
 hrcp04_17  LIKE   hrcp_file.hrcp04, 
 hrcp04_name17  LIKE   type_file.chr50 ,
 hrcp09_17  LIKE   hrcp_file.hrcp09, 
 job17  LIKE   type_file.num20          ,
 hrcp04_18  LIKE   hrcp_file.hrcp04, 
 hrcp04_name18  LIKE   type_file.chr50 ,
 hrcp09_18  LIKE   hrcp_file.hrcp09,  
 job18  LIKE   type_file.num20          ,
 hrcp04_19  LIKE   hrcp_file.hrcp04,  
 hrcp04_name19  LIKE   type_file.chr50 ,
 hrcp09_19  LIKE   hrcp_file.hrcp09, 
 job19  LIKE   type_file.num20          ,
 hrcp04_20  LIKE   hrcp_file.hrcp04, 
 hrcp04_name20  LIKE   type_file.chr50 ,
 hrcp09_20  LIKE   hrcp_file.hrcp09, 
 job20  LIKE   type_file.num20          ,
 hrcp04_21  LIKE   hrcp_file.hrcp04, 
 hrcp04_name21  LIKE   type_file.chr50 ,
 hrcp09_21  LIKE   hrcp_file.hrcp09, 
 job21  LIKE   type_file.num20          ,
 hrcp04_22  LIKE   hrcp_file.hrcp04, 
 hrcp04_name22  LIKE   type_file.chr50 ,
 hrcp09_22  LIKE   hrcp_file.hrcp09, 
 job22  LIKE   type_file.num20          ,
 hrcp04_23  LIKE   hrcp_file.hrcp04,  
 hrcp04_name23  LIKE   type_file.chr50 ,
 hrcp09_23  LIKE   hrcp_file.hrcp09, 
 job23  LIKE   type_file.num20,          
 hrcp04_24  LIKE   hrcp_file.hrcp04, 
 hrcp04_name24  LIKE   type_file.chr50, 
 hrcp09_24  LIKE   hrcp_file.hrcp09, 
 job24  LIKE   type_file.num20,          
 hrcp04_25  LIKE   hrcp_file.hrcp04, 
 hrcp04_name25  LIKE   type_file.chr50, 
 hrcp09_25  LIKE   hrcp_file.hrcp09,  
 job25  LIKE   type_file.num20,          
 hrcp04_26  LIKE   hrcp_file.hrcp04, 
 hrcp04_name26  LIKE   type_file.chr50, 
 hrcp09_26  LIKE   hrcp_file.hrcp09,  
 job26  LIKE   type_file.num20,          
 hrcp04_27  LIKE   hrcp_file.hrcp04, 
 hrcp04_name27  LIKE   type_file.chr50, 
 hrcp09_27  LIKE   hrcp_file.hrcp09, 
 job27  LIKE   type_file.num20,          
 hrcp04_28  LIKE   hrcp_file.hrcp04, 
 hrcp04_name28  LIKE   type_file.chr50, 
 hrcp09_28  LIKE   hrcp_file.hrcp09, 
 job28  LIKE   type_file.num20,          
 hrcp04_29  LIKE   hrcp_file.hrcp04, 
 hrcp04_name29  LIKE   type_file.chr50, 
 hrcp09_29  LIKE   hrcp_file.hrcp09,
 job29  LIKE   type_file.num20,          
 hrcp04_30  LIKE   hrcp_file.hrcp04, 
 hrcp04_name30  LIKE   type_file.chr50 ,
 hrcp09_30  LIKE   hrcp_file.hrcp09, 
 job30  LIKE   type_file.num20 ,         
 hrcp04_31  LIKE   hrcp_file.hrcp04,
 hrcp04_name31  LIKE   type_file.chr50, 
 hrcp09_31  LIKE   hrcp_file.hrcp09, 
 job31  LIKE   type_file.num20 ,        
 m1  LIKE   type_file.num20,              
 m2  LIKE   type_file.num20,                 
 m3  LIKE   type_file.num20,              
 m4  LIKE   type_file.num20 ,                 
 m5  LIKE   type_file.num20,              
 m6  LIKE   type_file.num20,                 
 sum1  LIKE   type_file.num20,           
 q1  LIKE   type_file.num20,                  
 q2  LIKE   type_file.num20 ,            
 q3  LIKE   type_file.num20 ,                 
 q4  LIKE   type_file.num20 ,            
 q5  LIKE   type_file.num20 ,                
 q6  LIKE   type_file.num20 ,           
 q7  LIKE   type_file.num20 ,                 
 q8  LIKE   type_file.num20 ,           
 sum2  LIKE type_file.num20       
                  END RECORD
  DEFINE  l_hrat22     LIKE   hrat_file.hrat22,
          l_hratid     LIKE   hrat_file.hratid
  DEFINE  l_i          LIKE   type_file.num5,
          l_hrbo02     LIKE   hrbo_file.hrbo02,
          l_hrat04     LIKE   hrat_file.hrat04
 

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,
                        ?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?) "
   LET sr.l_n=0 
   LET sr.m1=0
   LET sr.m2=0
   LET sr.m3=0
   LET sr.m4=0
   LET sr.m5=0
   LET sr.m6=0 
   LET sr.q1=0
   LET sr.q2=0
   LET sr.q3=0
   LET sr.q4=0
   LET sr.q5=0
   LET sr.q6=0
   LET sr.q7=0
   LET sr.q8=0   
   LET sr.sum1=0
   LET sr.sum2=0
   LET sr.l_year=tm.hrcp03_y
   LET sr.l_month=tm.hrcp03_m
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file
   SELECT hraa02 INTO sr.l_comp FROM hraa_file WHERE hraa01=tm.hrat03  

   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT DISTINCT hratid,hrat02,hrat04", 
             " FROM hrat_file,hrcp_file ",
             " WHERE hratacti='Y' AND hratid=hrcp02 ",                                     
             " AND YEAR(hrcp03)='",tm.hrcp03_y,"'" CLIPPED,
             " AND MONTH(hrcp03)='",tm.hrcp03_m,"'" CLIPPED                                  
             
   PREPARE ghrr019_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr019_curs1 CURSOR FOR ghrr019_prepare1
   IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
   
   FOREACH ghrr019_curs1 INTO l_hratid,sr.hrat02,l_hrat04
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
      IF NOT cl_null(l_hratid) THEN
      LET sr.l_n=sr.l_n+1
      SELECT hrat01 INTO sr.hrat01 FROM hrat_file WHERE hratid=l_hratid
      SELECT hrao02 INTO sr.hrat04 FROM hrao_file WHERE hrao01=l_hrat04
      END IF         
         FOR l_i=1 TO 31
           
           
#           SELECT hrcp11 INTO g_hrcp11 
#           FROM hrcp_file,hrbm_file 
#           WHERE hrbm03=hrcp10 AND hrcp03=g_date1 AND hrcp02=sr.hrat01 AND  hrbm02='008'
#           IF cl_null(g_hrcp11) THEN
#              LET g_hrcp11=0
#           END IF
#           SELECT hrcp13 INTO g_hrcp13 
#           FROM hrcp_file,hrbm_file 
#           WHERE hrbm03=hrcp12 AND hrcp03=g_date1 AND hrcp02=sr.hrat01 AND hrbm02='008' 
#           IF cl_null(g_hrcp13) THEN
#              LET g_hrcp13=0
#           END IF           
#           SELECT hrcp15 INTO g_hrcp15 
#           FROM hrcp_file,hrbm_file 
#           WHERE hrbm03=hrcp14 AND hrcp03=g_date1 AND hrcp02=sr.hrat01 AND hrbm02='008'
#           IF cl_null(g_hrcp15) THEN
#              LET g_hrcp15=0
#           END IF
#           SELECT hrcp17 INTO g_hrcp17 
#           FROM hrcp_file,hrbm_file 
#           WHERE hrbm03=hrcp16 AND hrcp03=g_date1 AND hrcp02=sr.hrat01 AND hrbm02='008'
#           IF cl_null(g_hrcp17) THEN
#              LET g_hrcp17=0
#           END IF
#           SELECT hrcp19 INTO g_hrcp19 
#           FROM hrcp_file,hrbm_file 
#           WHERE hrbm03=hrcp18 AND hrcp03=g_date1 AND hrcp02=sr.hrat01 AND hrbm02='008'
#           IF cl_null(g_hrcp19) THEN
#              LET g_hrcp19=0
#           END IF
#           LET g_hrcp[l_i].job=g_hrcp11+g_hrcp13+g_hrcp15+g_hrcp17+g_hrcp19 
                       #--获取 加班时数--#
            CALL r019_sql('008',l_hratid,l_i) RETURNING g_hrcp[l_i].job
                       #--获取 缺勤时数--#
            CALL r019_sql('001',l_hratid,l_i) RETURNING g_hrcp[l_i].q1
            CALL r019_sql('002',l_hratid,l_i) RETURNING g_hrcp[l_i].q2
            CALL r019_sql('003',l_hratid,l_i) RETURNING g_hrcp[l_i].q3
            CALL r019_sql('004',l_hratid,l_i) RETURNING g_hrcp[l_i].q4
            CALL r019_sql('005',l_hratid,l_i) RETURNING g_hrcp[l_i].q5
            CALL r019_sql('006',l_hratid,l_i) RETURNING g_hrcp[l_i].q6
            CALL r019_sql('010',l_hratid,l_i) RETURNING g_hrcp[l_i].q7
            CALL r019_sql('011',l_hratid,l_i) RETURNING g_hrcp[l_i].q8
            
           
          SELECT hrcp09 INTO g_hrcp[l_i].hrcp09 
          FROM hrcp_file 
          WHERE YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_i AND hrcp02=l_hratid
          IF cl_null(g_hrcp[l_i].hrcp09) THEN
             LET g_hrcp[l_i].hrcp09=0
          END IF
          SELECT hrbo03 INTO g_hrcp[l_i].hrcp04_name
          FROM hrbo_file,hrcp_file
          WHERE YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_i AND hrcp02=l_hratid AND hrbo02=hrcp04 AND hrbo06='N'
          IF cl_null(g_hrcp[l_i].hrcp04_name) THEN
             LET g_hrcp[l_i].hrcp04_name='无'
          END IF
          SELECT hrcp04 INTO g_hrcp[l_i].hrcp04 
          FROM hrcp_file 
          WHERE YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_i AND hrcp02=l_hratid
          IF cl_null(g_hrcp[l_i].hrcp04) THEN
            LET g_hrcp[l_i].hrcp04=0
          END IF
          LET sr.sum1=sr.sum1+g_hrcp[l_i].job+g_hrcp[l_i].hrcp09 
          LET sr.q1=sr.q1+g_hrcp[l_i].q1
          LET sr.q2=sr.q2+g_hrcp[l_i].q2
          LET sr.q3=sr.q3+g_hrcp[l_i].q3
          LET sr.q4=sr.q4+g_hrcp[l_i].q4
          LET sr.q5=sr.q5+g_hrcp[l_i].q5
          LET sr.q6=sr.q6+g_hrcp[l_i].q6
          LET sr.q7=sr.q7+g_hrcp[l_i].q7
          LET sr.q8=sr.q8+g_hrcp[l_i].q8
                                    
         END FOR
         
         LET l_sql2=" SELECT hrbo02 FROM hrbo_file,hrcp_file ",
                  " WHERE hrbo02=hrcp04 AND hrbo06='N' AND ",
                  " hrcp02='",l_hratid,"'" CLIPPED,
                  " AND YEAR(hrcp03)='",tm.hrcp03_y,"'" CLIPPED,
                  " AND MONTH(hrcp03)='",tm.hrcp03_m,"'" CLIPPED
       PREPARE ghrr019_prepare2 FROM l_sql2
       IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
           EXIT PROGRAM 
       END IF
      DECLARE ghrr019_curs2 CURSOR FOR ghrr019_prepare2
      IF STATUS THEN CALL cl_err('declare:',STATUS,1) RETURN END IF
       FOREACH ghrr019_curs2 INTO l_hrbo02
         
         CASE l_hrbo02
              WHEN '1'  LET sr.m1=sr.m1+1
              WHEN '3'  LET sr.m2=sr.m2+1
              WHEN '4'  LET sr.m3=sr.m3+1
              WHEN '5'  LET sr.m4=sr.m4+1
              WHEN '6'  LET sr.m5=sr.m5+1
              WHEN '7'  LET sr.m6=sr.m6+1
         END CASE
             
       END FOREACH
      LET sr.sum2=sr.q1+sr.q2+sr.q3+sr.q4+sr.q5+sr.q6+sr.q7+sr.q8
      LET sr.hrcp04_1=g_hrcp[1].hrcp04
      LET sr.hrcp04_name1=g_hrcp[1].hrcp04_name
      LET sr.hrcp09_1=g_hrcp[1].hrcp09
      LET sr.job1=g_hrcp[1].job
      LET sr.hrcp04_2=g_hrcp[2].hrcp04
      LET sr.hrcp04_name2=g_hrcp[2].hrcp04_name
      LET sr.hrcp09_2=g_hrcp[2].hrcp09
      LET sr.job2=g_hrcp[2].job
      LET sr.hrcp04_3=g_hrcp[3].hrcp04
      LET sr.hrcp04_name3=g_hrcp[3].hrcp04_name
      LET sr.hrcp09_3=g_hrcp[3].hrcp09
      LET sr.job3=g_hrcp[3].job
      LET sr.hrcp04_4=g_hrcp[4].hrcp04
      LET sr.hrcp04_name4=g_hrcp[4].hrcp04_name
      LET sr.hrcp09_4=g_hrcp[4].hrcp09
      LET sr.job4=g_hrcp[4].job
      LET sr.hrcp04_5=g_hrcp[5].hrcp04
      LET sr.hrcp04_name5=g_hrcp[5].hrcp04_name
      LET sr.hrcp09_5=g_hrcp[5].hrcp09
      LET sr.job5=g_hrcp[5].job
      LET sr.hrcp04_6=g_hrcp[6].hrcp04
      LET sr.hrcp04_name6=g_hrcp[6].hrcp04_name
      LET sr.hrcp09_6=g_hrcp[6].hrcp09
      LET sr.job6=g_hrcp[6].job
      LET sr.hrcp04_7=g_hrcp[7].hrcp04
      LET sr.hrcp04_name7=g_hrcp[7].hrcp04_name
      LET sr.hrcp09_7=g_hrcp[7].hrcp09
      LET sr.job7=g_hrcp[7].job
      LET sr.hrcp04_8=g_hrcp[8].hrcp04
      LET sr.hrcp04_name8=g_hrcp[8].hrcp04_name
      LET sr.hrcp09_8=g_hrcp[8].hrcp09
      LET sr.job8=g_hrcp[8].job
      LET sr.hrcp04_9=g_hrcp[9].hrcp04
      LET sr.hrcp04_name9=g_hrcp[9].hrcp04_name
      LET sr.hrcp09_9=g_hrcp[9].hrcp09
      LET sr.job9=g_hrcp[9].job
      LET sr.hrcp04_10=g_hrcp[10].hrcp04
      LET sr.hrcp04_name10=g_hrcp[10].hrcp04_name
      LET sr.hrcp09_10=g_hrcp[10].hrcp09
      LET sr.job10=g_hrcp[10].job
      LET sr.hrcp04_11=g_hrcp[11].hrcp04
      LET sr.hrcp04_name11=g_hrcp[11].hrcp04_name
      LET sr.hrcp09_11=g_hrcp[11].hrcp09
      LET sr.job11=g_hrcp[11].job
      LET sr.hrcp04_12=g_hrcp[12].hrcp04
      LET sr.hrcp04_name12=g_hrcp[12].hrcp04_name
      LET sr.hrcp09_12=g_hrcp[12].hrcp09
      LET sr.job12=g_hrcp[12].job
      LET sr.hrcp04_13=g_hrcp[13].hrcp04
      LET sr.hrcp04_name13=g_hrcp[13].hrcp04_name
      LET sr.hrcp09_13=g_hrcp[13].hrcp09
      LET sr.job13=g_hrcp[13].job
      LET sr.hrcp04_14=g_hrcp[14].hrcp04
      LET sr.hrcp04_name14=g_hrcp[14].hrcp04_name
      LET sr.hrcp09_14=g_hrcp[14].hrcp09
      LET sr.job14=g_hrcp[14].job
      LET sr.hrcp04_15=g_hrcp[15].hrcp04
      LET sr.hrcp04_name15=g_hrcp[15].hrcp04_name
      LET sr.hrcp09_15=g_hrcp[15].hrcp09
      LET sr.job15=g_hrcp[15].job
      LET sr.hrcp04_16=g_hrcp[16].hrcp04
      LET sr.hrcp04_name16=g_hrcp[16].hrcp04_name
      LET sr.hrcp09_16=g_hrcp[16].hrcp09
      LET sr.job16=g_hrcp[16].job
      LET sr.hrcp04_17=g_hrcp[17].hrcp04
      LET sr.hrcp04_name17=g_hrcp[17].hrcp04_name
      LET sr.hrcp09_17=g_hrcp[17].hrcp09
      LET sr.job17=g_hrcp[17].job
      LET sr.hrcp04_18=g_hrcp[18].hrcp04
      LET sr.hrcp04_name18=g_hrcp[18].hrcp04_name
      LET sr.hrcp09_18=g_hrcp[18].hrcp09
      LET sr.job18=g_hrcp[18].job
      LET sr.hrcp04_19=g_hrcp[19].hrcp04
      LET sr.hrcp04_name19=g_hrcp[19].hrcp04_name
      LET sr.hrcp09_19=g_hrcp[19].hrcp09
      LET sr.job19=g_hrcp[19].job
      LET sr.hrcp04_20=g_hrcp[20].hrcp04
      LET sr.hrcp04_name20=g_hrcp[20].hrcp04_name
      LET sr.hrcp09_20=g_hrcp[20].hrcp09
      LET sr.job20=g_hrcp[20].job
      LET sr.hrcp04_21=g_hrcp[21].hrcp04
      LET sr.hrcp04_name21=g_hrcp[21].hrcp04_name
      LET sr.hrcp09_21=g_hrcp[21].hrcp09
      LET sr.job21=g_hrcp[21].job
      LET sr.hrcp04_22=g_hrcp[22].hrcp04
      LET sr.hrcp04_name22=g_hrcp[22].hrcp04_name
      LET sr.hrcp09_22=g_hrcp[22].hrcp09
      LET sr.job22=g_hrcp[22].job
      LET sr.hrcp04_name23=g_hrcp[23].hrcp04_name
      LET sr.hrcp09_23=g_hrcp[23].hrcp09
      LET sr.job23=g_hrcp[23].job
      LET sr.hrcp04_23=g_hrcp[23].hrcp04
      LET sr.hrcp04_name24=g_hrcp[24].hrcp04_name
      LET sr.hrcp09_24=g_hrcp[24].hrcp09
      LET sr.job24=g_hrcp[24].job
      LET sr.hrcp04_24=g_hrcp[24].hrcp04
      LET sr.hrcp04_name25=g_hrcp[25].hrcp04_name
      LET sr.hrcp09_25=g_hrcp[25].hrcp09
      LET sr.job25=g_hrcp[25].job
      LET sr.hrcp04_25=g_hrcp[25].hrcp04
      LET sr.hrcp04_name26=g_hrcp[26].hrcp04_name
      LET sr.hrcp09_26=g_hrcp[26].hrcp09
      LET sr.job26=g_hrcp[26].job
      LET sr.hrcp04_26=g_hrcp[26].hrcp04
      LET sr.hrcp04_name27=g_hrcp[27].hrcp04_name
      LET sr.hrcp09_27=g_hrcp[27].hrcp09
      LET sr.job27=g_hrcp[27].job
      LET sr.hrcp04_27=g_hrcp[27].hrcp04
      LET sr.hrcp04_name28=g_hrcp[28].hrcp04_name
      LET sr.hrcp09_28=g_hrcp[28].hrcp09
      LET sr.job28=g_hrcp[28].job
      LET sr.hrcp04_28=g_hrcp[28].hrcp04
      LET sr.hrcp04_name29=g_hrcp[29].hrcp04_name
      LET sr.hrcp09_29=g_hrcp[29].hrcp09
      LET sr.job29=g_hrcp[29].job
      LET sr.hrcp04_29=g_hrcp[29].hrcp04
      LET sr.hrcp04_name30=g_hrcp[30].hrcp04_name
      LET sr.hrcp09_30=g_hrcp[30].hrcp09
      LET sr.job30=g_hrcp[30].job
      LET sr.hrcp04_30=g_hrcp[30].hrcp04
      LET sr.hrcp04_name31=g_hrcp[31].hrcp04_name
      LET sr.hrcp09_31=g_hrcp[31].hrcp09
      LET sr.job31=g_hrcp[31].job
      LET sr.hrcp04_31=g_hrcp[31].hrcp04
               
      EXECUTE insert_prep USING sr.*   
   END FOREACH  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
   LET g_str = tm.wc
   CALL cl_prt_cs3('ghrr019','ghrr019',g_sql,'')     #第一个ghrr019是程序名字  第二是模板名字 p_zaw
END FUNCTION

FUNCTION r019_sql(p_hrbm02,p_hrat01,l_day)
  DEFINE p_hrbm02 LIKE hrbm_file.hrbm02,
         p_hrat01 LIKE hrat_file.hrat01,
         l_day    LIKE type_file.num20
  LET g_hrcp11=0
  LET g_hrcp13=0
  LET g_hrcp15=0
  LET g_hrcp17=0
  LET g_hrcp19=0
  
  SELECT hrcp11 INTO g_hrcp11 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp10 AND YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_day   
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02
           IF cl_null(g_hrcp11) THEN
              LET g_hrcp11=0
           END IF
           SELECT hrcp13 INTO g_hrcp13 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp12 AND YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_day
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 
           IF cl_null(g_hrcp13) THEN
              LET g_hrcp13=0
           END IF           
           SELECT hrcp15 INTO g_hrcp15 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp14 AND YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_day
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02
           IF cl_null(g_hrcp15) THEN
              LET g_hrcp15=0
           END IF
           SELECT hrcp17 INTO g_hrcp17 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp16 AND YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_day
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02
           IF cl_null(g_hrcp17) THEN
              LET g_hrcp17=0
           END IF
           SELECT hrcp19 INTO g_hrcp19 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp18 AND YEAR(hrcp03)=tm.hrcp03_y AND MONTH(hrcp03)=tm.hrcp03_m AND DAY(hrcp03)=l_day
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02
           IF cl_null(g_hrcp19) THEN
              LET g_hrcp19=0
           END IF
           LET l_sum=g_hrcp11+g_hrcp13+g_hrcp15+g_hrcp17+g_hrcp19 
           RETURN l_sum
END FUNCTION


