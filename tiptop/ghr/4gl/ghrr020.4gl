# Prog. Version..: '5.25.02-11.04.01(00010)'     #
#
# Pattern name...: ghrr020.4gl
# Descriptions...: 考勤年报
# Date & Author..: 13/08/29 By wangxh

DATABASE ds
 
#GLOBALS "../../config/top.global"
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE tm  RECORD                         
            wc      LIKE type_file.chr1000,
            hrat03  LIKE hrat_file.hrat03,
            hrat04  LIKE hrat_file.hrat04,
            l_year  LIKE type_file.chr20,           
            qj      LIKE type_file.chr3         #其他查询条件
            END RECORD
DEFINE g_rpt_name  LIKE type_file.chr20         
DEFINE g_oea01     LIKE oea_file.oea01   
DEFINE g_sma115    LIKE sma_file.sma115  
DEFINE g_sma116    LIKE sma_file.sma116  
DEFINE l_table     STRING                 
DEFINE g_sql       STRING                   
DEFINE g_str       STRING,
       l_company      LIKE type_file.chr20
DEFINE l_hrat03       LIKE hrat_file.hrat03
dEFINE g_hrcp    DYNAMIC ARRAY OF RECORD
       MONTH            LIKE type_file.num20
       END RECORD 
 DEFINE   g_hrcp11     LIKE   hrcp_file.hrcp11,
          g_hrcp13     LIKE   hrcp_file.hrcp13,
          g_hrcp15     LIKE   hrcp_file.hrcp15,
          g_hrcp17     LIKE   hrcp_file.hrcp17,
          g_hrcp19     LIKE   hrcp_file.hrcp19
DEFINE   g_srum         LIKE   type_file.num20
 
                
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
 
   LET g_sql = " l_company.type_file.chr50, l_date.type_file.chr50,",
               " l_n.type_file.num5,        hrat01.hrat_file.hrat01,",
               " hrat02.hrat_file.hrat02,   hrao02.hrao_file.hrao02,",
               " lbie.type_file.chr20,      mcheng.type_file.chr20, ",
               " n1.type_file.num5,         n2.type_file.num5,      ",
               " n3.type_file.num5,         n4.type_file.num5,      ",
               " n5.type_file.num5,         n6.type_file.num5,      ",
               " n7.type_file.num5,         n8.type_file.num5,      ",
               " n9.type_file.num5,         n10.type_file.num5,      ",
               " n11.type_file.num5,        n12.type_file.num5,      ",
               " sum.type_file.num5,        yxiu.type_file.num5,    ",
               " sxiu.type_file.num5,       rem.type_file.chr50     "
               
                             
   LET l_table = cl_prt_temptable('ghrr020',g_sql) CLIPPED   # 产生Temp Table
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
      CALL ghrr020_tm(0,0)             # Input print condition
   ELSE 
      CALL ghrr020()                   # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION ghrr020_tm(p_row,p_col)
   DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,       #No.FUN-680137 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)
           
   LET p_row = 7
   LET p_col = 17
 
   OPEN WINDOW ghrr020_w AT p_row,p_col WITH FORM "ghr/42f/ghrr020"
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
      CLOSE WINDOW ghrr020_w  
      EXIT WHILE        
   END IF
   
  CONSTRUCT BY NAME tm.wc ON hrat03,hrat04,l_year

       BEFORE CONSTRUCT
          CALL cl_qbe_init()
        AFTER FIELD hrat03
          LET l_hrat03 = GET_FLDBUF(hrat03)
          IF cl_null(l_hrat03) THEN
                 NEXT FIELD hrat03
          END IF
          SELECT hraa02 INTO l_company FROM hraa_file WHERE hraa01=l_hrat03 
          DISPLAY l_company TO hrat03_name 
        AFTER FIELD hrat04
          LET tm.hrat04 = GET_FLDBUF(hrat04)
        AFTER FIELD l_year
           LET tm.l_year=GET_FLDBUF(l_year)
           IF cl_null(tm.l_year) THEN
              NEXT FIELD l_year
           END IF
       ON ACTION controlp
          CASE
              WHEN INFIELD(hrat03)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 =l_hrat03
              LET g_qryparam.construct = 'N'
              CALL cl_create_qry() RETURNING l_hrat03
              DISPLAY l_hrat03 TO hrat03
              NEXT FIELD hrat03
               
             WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
                                                                   
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
     IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF
 
    IF tm.wc=" 1=1 " THEN
       CALL cl_err(' ','9046',0)
       CONTINUE WHILE
    END IF
    DISPLAY BY NAME tm.qj                  
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
 
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
       AFTER INPUT
          IF NOT cl_null(tm.hrat04) THEN
             LET tm.wc=" hrat03='",l_hrat03,"'" CLIPPED," AND hrat04='",tm.hrat04,"'" CLIPPED,
                       " AND YEAR(hrcp03)='",tm.l_year,"'" CLIPPED
          END IF
          IF cl_null(tm.hrat04) THEN
             LET tm.wc=" hrat03='",l_hrat03,"'" CLIPPED,
                        " AND YEAR(hrcp03)='",tm.l_year,"'" CLIPPED
                       
          END IF
 
    END INPUT
   IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW ghrr020_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
   END IF
      
      IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file  
             WHERE zz01='ghrr020'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('ghrr020','9031',1)
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
         CALL cl_cmdat('ghrr020',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW ghrr020_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL ghrr020()
   ERROR ""
END WHILE
   CLOSE WINDOW ghrr020_w
END FUNCTION
 
FUNCTION ghrr020()        # Read data and create out-file
  DEFINE l_cmd      LIKE     type_file.chr1000, 
         l_sql      LIKE  type_file.chr1000,
         l_sql2      LIKE  type_file.chr1000
          
   DEFINE l_n      LIKE   type_file.num20 
   DEFINE l_msg    STRING   
   DEFINE l_msg2   STRING     
   DEFINE l_lang_t    LIKE type_file.chr1
    DEFINE sr       RECORD
                 l_company  LIKE    type_file.chr50, 
                 l_date     LIKE    type_file.chr50, 
                 l_n        LIKE    type_file.num5,        
                 hrat01     LIKE    hrat_file.hrat01, 
                 hrat02     LIKE    hrat_file.hrat02,   
                 hrao02     LIKE    hrao_file.hrao02, 
                 lbie       LIKE    type_file.chr20,     
                 mcheng     LIKE    type_file.chr20,  
                 n1         LIKE    type_file.num5,         
                 n2         LIKE    type_file.num5,       
                 n3         LIKE    type_file.num5,         
                 n4         LIKE    type_file.num5,       
                 n5         LIKE    type_file.num5,         
                 n6         LIKE    type_file.num5,       
                 n7         LIKE    type_file.num5,        
                 n8         LIKE    type_file.num5,      
                 n9         LIKE    type_file.num5,         
                 n10        LIKE    type_file.num5,      
                 n11        LIKE    type_file.num5,       
                 n12        LIKE    type_file.num5,      
                 sum        LIKE    type_file.num5,       
                 yxiu       LIKE    type_file.num5,     
                 sxiu       LIKE    type_file.num5,       
                 rem        LIKE    type_file.chr50             
                   END RECORD 
   DEFINE   l_hratid    LIKE   hrat_file.hratid,
            l_hrat04    LIKE   hrat_file.hrat04,
            l_i         LIKE   type_file.num5,
            l_hrbm02    LIKE   hrbm_file.hrbm02,
            l_hrbm03    LIKE   hrbm_file.hrbm03
   DEFINE   l_hrch09    LIKE   hrch_file.hrch09,
            l_hrch10    LIKE   hrch_file.hrch10,
            l_hrch11    LIKE   hrch_file.hrch11,
            l_hrch20    LIKE   hrch_file.hrch20,
            l_hrch21    LIKE   hrch_file.hrch21,
            l_hrch22    LIKE   hrch_file.hrch22

   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
  
   LET sr.l_company=l_company,tm.l_year,"年度"
   LET sr.l_date=tm.l_year,'年'
   LET sr.l_n=0
   LET sr.rem=' '
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup')
   LET l_sql=" SELECT DISTINCT hratid,hrat02,hrat04 ",
             " FROM hrat_file,hrcp_file            ",
             " WHERE hratacti='Y' AND hratid=hrcp02 AND ",                                     
             tm.wc,
             " ORDER BY hratid "
   PREPARE ghrr020_prepare1 FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
   END IF
   DECLARE ghrr020_curs1 CURSOR FOR ghrr020_prepare1
   IF STATUS THEN 
      CALL cl_err('declare:',STATUS,1) 
      RETURN 
   END IF
 
   FOREACH ghrr020_curs1 INTO l_hratid,sr.hrat02,l_hrat04
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) EXIT FOREACH 
      END IF
      LET sr.l_n=sr.l_n+1
     
      SELECT hrat01 INTO sr.hrat01 FROM hrat_file WHERE hratid=l_hratid
      SELECT hrao02 INTO sr.hrao02 FROM hrao_file WHERE hrao01=l_hrat04
      LET l_sql2=" SELECT DISTINCT hrbm02,hrbm03 ",
               " FROM hrbm_file ",
               " WHERE hrbm02<>'007' AND hrbm02<>'009' AND hrbm03<>'92' "
      PREPARE ghrr020_prepare2 FROM l_sql2
      IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM 
      END IF
      DECLARE ghrr020_curs2 CURSOR FOR ghrr020_prepare2
      IF STATUS THEN 
         CALL cl_err('declare:',STATUS,1) 
         RETURN 
      END IF
      FOREACH ghrr020_curs2 INTO l_hrbm02,l_hrbm03
       LET sr.sum=0

        IF l_hrbm02='999' AND l_hrbm03='91' THEN
          LET sr.lbie='出勤'
          LET sr.mcheng='全勤'
          FOR l_i=1 TO 12
             SELECT sum(hrcp09) INTO g_hrcp[l_i].month
             FROM hrbo_file,hrcp_file
             WHERE hrbo02=hrcp04 AND hrbo06='N' AND hrcp02=l_hratid AND YEAR(hrcp03)=l_i
             IF cl_null(g_hrcp[l_i].month) THEN
                LET g_hrcp[l_i].month=0
             END IF
             LET sr.sum=sr.sum+g_hrcp[l_i].month
           END FOR
        END IF
        IF l_hrbm02='008' THEN
          LET sr.lbie='加班'
          
            CASE l_hrbm03
               WHEN '017' LET sr.mcheng='节日'
                          FOR l_i=1 TO 12
                          CALL r020_sql('008','017',l_hratid,l_i)
                          RETURNING g_hrcp[l_i].month
                          LET sr.sum=sr.sum+g_hrcp[l_i].month
                          END FOR
               WHEN '016' LET sr.mcheng='假日'
                          FOR l_i=1 TO 12
                          CALL r020_sql('008','017',l_hratid,l_i)
                          RETURNING g_hrcp[l_i].month
                          LET sr.sum=sr.sum+g_hrcp[l_i].month
                          END FOR
               WHEN '015' LET sr.mcheng='平日'
                          FOR l_i=1 TO 12
                          CALL r020_sql('008','017',l_hratid,l_i)
                          RETURNING g_hrcp[l_i].month 
                          LET sr.sum=sr.sum+g_hrcp[l_i].month
                          END FOR
            END CASE 
        END IF
         IF l_hrbm02='001' OR l_hrbm02='002' OR l_hrbm02='003' OR l_hrbm02='004' OR l_hrbm02='005'
            OR l_hrbm02='006' OR l_hrbm02='010' OR l_hrbm02='' OR l_hrbm02='011' THEN
           LET sr.lbie='缺勤'
           CASE l_hrbm02
                WHEN '001' LET sr.mcheng='迟到'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('001',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                WHEN '002' LET sr.mcheng='早退'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('002',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                WHEN '003' LET sr.mcheng='旷工'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('003',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                WHEN '004' LET sr.mcheng='请假'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('004',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                WHEN '005' LET sr.mcheng='出差'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('005',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                WHEN '006' LET sr.mcheng='年假'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('006',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                WHEN '010' LET sr.mcheng='特殊假'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('010',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                WHEN '011' LET sr.mcheng='调休假'
                           FOR l_i=1 TO 12
                           CALL r020_sql2('011',l_hratid,l_i)
                           RETURNING g_hrcp[l_i].month  
                           LET sr.sum=sr.sum+g_hrcp[l_i].month
                           END FOR
                END CASE                         
         END IF
                
          LET sr.n1=g_hrcp[1].month
          LET sr.n2=g_hrcp[2].month
          LET sr.n3=g_hrcp[3].month
          LET sr.n4=g_hrcp[4].month
          LET sr.n5=g_hrcp[5].month
          LET sr.n6=g_hrcp[6].month
          LET sr.n7=g_hrcp[7].month
          LET sr.n8=g_hrcp[8].month
          LET sr.n9=g_hrcp[9].month
          LET sr.n10=g_hrcp[10].month
          LET sr.n11=g_hrcp[11].month
          LET sr.n12=g_hrcp[12].month    
         
     #--本年应休天数--#
     SELECT hrch09,hrch10,hrch11 INTO l_hrch09,l_hrch10,l_hrch11
     FROM hrch_file
     WHERE hrch01=l_hrat03 AND hrch02=tm.l_year AND hrch03=l_hratid
     IF cl_null(l_hrch09) THEN
        LET l_hrch09=0
     END IF
     IF cl_null(l_hrch10) THEN
        LET l_hrch10=0
     END IF
     IF cl_null(l_hrch11) THEN
        LET l_hrch11=0
     END IF
     LET sr.yxiu=l_hrch09+l_hrch10+l_hrch11
     
      #--本年实休天数--#
     SELECT hrch20,hrch21,hrch22 INTO l_hrch20,l_hrch21,l_hrch22
     FROM hrch_file
     WHERE hrch01=l_hrat03 AND hrch02=tm.l_year AND hrch03=l_hratid
     IF cl_null(l_hrch22) THEN
        LET l_hrch22=0
     END IF
     IF cl_null(l_hrch20) THEN
        LET l_hrch20=0
     END IF
     IF cl_null(l_hrch21) THEN
        LET l_hrch21=0
     END IF
     LET sr.sxiu=sr.yxiu-(l_hrch20+l_hrch21+l_hrch22)
     
       EXECUTE insert_prep USING sr.*  
       END FOREACH
  #-----测试-----#
  #    IF sr.l_n>2 THEN 
  #       EXIT FOREACH
  #    END IF
  #----测试------#
   END FOREACH 
  
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED    
   LET g_str = tm.wc
   CALL cl_prt_cs3('ghrr020','ghrr020',g_sql,g_str)     #第一个ghrr020是程序名字  第二是模板名字 p_zaw
END FUNCTION

FUNCTION r020_sql(p_hrbm02,p_hrbm03,p_hrat01,l_month)
  DEFINE p_hrbm02 LIKE hrbm_file.hrbm02,
         p_hrbm03 LIKE hrbm_file.hrbm03,
         p_hrat01 LIKE hrat_file.hrat01,
         l_month    LIKE type_file.num20
  LET g_hrcp11=0
  LET g_hrcp13=0
  LET g_hrcp15=0
  LET g_hrcp17=0
  LET g_hrcp19=0
  
           SELECT hrcp11 INTO g_hrcp11 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp10 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month   
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 AND hrcp10=p_hrbm03
           IF cl_null(g_hrcp11) THEN
              LET g_hrcp11=0
           END IF
           SELECT sum(hrcp13) INTO g_hrcp13 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp12 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 AND hrcp10=p_hrbm03
           IF cl_null(g_hrcp13) THEN
              LET g_hrcp13=0
           END IF           
           SELECT sum(hrcp15) INTO g_hrcp15 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp14 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 AND hrcp10=p_hrbm03
           IF cl_null(g_hrcp15) THEN
              LET g_hrcp15=0
           END IF
           SELECT sum(hrcp17) INTO g_hrcp17 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp16 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 AND hrcp10=p_hrbm03
           IF cl_null(g_hrcp17) THEN
              LET g_hrcp17=0
           END IF
           SELECT sum(hrcp19) INTO g_hrcp19 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp18 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 AND hrcp10=p_hrbm03
           IF cl_null(g_hrcp19) THEN
              LET g_hrcp19=0
           END IF
           LET g_srum=g_hrcp11+g_hrcp13+g_hrcp15+g_hrcp17+g_hrcp19 
           RETURN g_srum
END FUNCTION
FUNCTION r020_sql2(p_hrbm02,p_hrat01,l_month)
  DEFINE p_hrbm02 LIKE hrbm_file.hrbm02,
         p_hrat01 LIKE hrat_file.hrat01,
         l_month    LIKE type_file.num20
  LET g_hrcp11=0
  LET g_hrcp13=0
  LET g_hrcp15=0
  LET g_hrcp17=0
  LET g_hrcp19=0
  
           SELECT hrcp11 INTO g_hrcp11 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp10 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month   
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 
           IF cl_null(g_hrcp11) THEN
              LET g_hrcp11=0
           END IF
           SELECT sum(hrcp13) INTO g_hrcp13 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp12 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 
           IF cl_null(g_hrcp13) THEN
              LET g_hrcp13=0
           END IF           
           SELECT sum(hrcp15) INTO g_hrcp15 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp14 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 
           IF cl_null(g_hrcp15) THEN
              LET g_hrcp15=0
           END IF
           SELECT sum(hrcp17) INTO g_hrcp17 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp16 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 
           IF cl_null(g_hrcp17) THEN
              LET g_hrcp17=0
           END IF
           SELECT sum(hrcp19) INTO g_hrcp19 
           FROM hrcp_file,hrbm_file 
           WHERE hrbm03=hrcp18 AND YEAR(hrcp03)=tm.l_year AND MONTH(hrcp03)=l_month 
                 AND hrcp02=p_hrat01 AND hrbm02=p_hrbm02 
           IF cl_null(g_hrcp19) THEN
              LET g_hrcp19=0
           END IF
           LET g_srum=g_hrcp11+g_hrcp13+g_hrcp15+g_hrcp17+g_hrcp19 
           RETURN g_srum
END FUNCTION


