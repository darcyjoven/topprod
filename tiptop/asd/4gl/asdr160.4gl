# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asdr160.4gl
# Descriptions...: 其他領退明細表列印作業
# Input parameter: 
# Return code....: 
# Date & Author..: 
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-5100337 05/01/19 By pengu 報表轉XML
# Modify.........: No.MOD-570244 05/07/22 By yoyo 料件編號欄位加controlp
# Modify.........: No.FUN-5A0059 05/11/02 By Sarah 補印ima021
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850086 08/05/20 By Sunyanchun 老報表轉CR
#                                08/09/24 By Cockroach CR 21-->31 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B80062 11/08/03 By minpp程序撰寫規範修改	
 
DATABASE ds
GLOBALS "../../config/top.global"
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(400),    # Where condition
              bdate   LIKE type_file.dat,          #No.FUN-690010DATE,
              edate   LIKE type_file.dat,          #No.FUN-690010 DATE,
              yy      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mm      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_head1         STRING
DEFINE   g_sql           STRING      #NO.FUN-850086
DEFINE   g_str           STRING      #NO.FUN-850086
DEFINE   l_table         STRING      #NO.FUN-850086
 
MAIN
#     DEFINE  l_time  LIKE type_file.chr8             #No.FUN-6A0089
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                   # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
   #NO.FUN-850086-----BEGIN-----
   LET g_sql = "inb15.inb_file.inb15,",
    	        "ina04.ina_file.ina04,",
    	        "gem02.gem_file.gem02,",
    	        "ina02.ina_file.ina02,",
    	        "ina01.ina_file.ina01,",
    	        "inb05.inb_file.inb05,",
    	        "inb04.inb_file.inb04,",
    	        "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "inb09.inb_file.inb09,",
                "price.alb_file.alb06,",
                "cost.alb_file.alb06,",
                "azf03.azf_file.azf03,",
                "type.type_file.num5,",
                "ima12.ima_file.ima12"
   LET l_table = cl_prt_temptable('asdr160',g_sql)
   IF l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?)"                                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)                                                                                        
      EXIT PROGRAM                                                                                                                 
   END IF
   #NO.FUN-850086-----END-------
   LET g_pdate  = ARG_VAL(1)         # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.bdate = ARG_VAL(8)
   LET tm.edate = ARG_VAL(9)
   LET tm.yy    = ARG_VAL(10)
   LET tm.mm    = ARG_VAL(11)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(12)
   LET g_rep_clas = ARG_VAL(13)
   LET g_template = ARG_VAL(14)
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL asdr160_tm()               # Input print condition
   ELSE 
      CALL asdr160()                  # Read data and create out-file
   END IF
 
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
 
END MAIN
 
FUNCTION asdr160_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col  LIKE type_file.num5,   l_cmd        LIKE type_file.chr1000 #No.FUN-690010 SMALLINT  #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW asdr160_w AT p_row,p_col WITH FORM "asd/42f/asdr160" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yy   = YEAR(g_today)
   LET tm.mm   = MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.edate=MDY(tm.mm,1,tm.yy)-1
   LET tm.bdate=MDY(MONTH(tm.edate)  ,1,YEAR(tm.edate))
   LET tm.yy  = YEAR(tm.bdate)
   LET tm.mm  = MONTH(tm.bdate)
 
   WHILE TRUE
     CONSTRUCT BY NAME tm.wc ON ima12,inb04,ina01,ima08,inb15,ina04 
#No.FUN-570244 --start                                                          
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP                                                      
            IF INFIELD(inb04) THEN                                              
               CALL cl_init_qry_var()                                           
               LET g_qryparam.form = "q_ima"                                    
               LET g_qryparam.state = "c"                                       
               CALL cl_create_qry() RETURNING g_qryparam.multiret               
               DISPLAY g_qryparam.multiret TO inb04                             
               NEXT FIELD inb04                                                 
            END IF                                                              
#No.FUN-570244 --end     
         ON ACTION locale
            LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
  
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        EXIT WHILE 
     END IF
 
     INPUT BY NAME tm.bdate,tm.edate,tm.yy,tm.mm,tm.more 
              WITHOUT DEFAULTS 
     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD edate
           IF NOT cl_null(tm.edate) THEN 
              IF tm.edate < tm.bdate THEN 
                 NEXT FIELD bdate 
              END IF
           END IF 
     
        AFTER FIELD more
           IF tm.more = 'Y' THEN 
              CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies)
                   RETURNING g_pdate,g_towhom,g_rlang,
                             g_bgjob,g_time,g_prtway,g_copies
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
      
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
         LET INT_FLAG = 0 
         EXIT WHILE   
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='asdr160'
         IF SQLCA.sqlcode OR cl_null(l_cmd) THEN
           CALL cl_err('asdr160','9031',1)   
            
            CONTINUE WHILE 
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.bdate CLIPPED,"'",
                            " '",tm.edate CLIPPED,"'",
                            " '",tm.yy    CLIPPED,"'",
                            " '",tm.mm    CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('asdr160',g_time,l_cmd)    # Execute cmd at later time
            EXIT WHILE  
         END IF
      END IF
 
      CALL cl_wait()
      CALL asdr160()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW asdr160_w
 
END FUNCTION
 
FUNCTION asdr160()
   DEFINE l_name    LIKE type_file.chr20,          # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(800)
          l_chr     LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
          l_za05    LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(40)
          sr        RECORD 
                    type   LIKE type_file.num5,         #No.FUN-690010SMALLINT,
                    ina00  LIKE ina_file.ina00,  #單據類別
                    ina01  LIKE ina_file.ina01,  #單據編號
                    ina02  LIKE ina_file.ina02,  #單據日期
                    ina04  LIKE ina_file.ina04,  #部門編號
                    ina07  LIKE ina_file.ina07,  #備註
                    inb04  LIKE inb_file.inb04,  #料號
                    inb05  LIKE inb_file.inb05,  #倉庫
                    inb09  LIKE inb_file.inb09,  #數量
                    inb15  LIKE inb_file.inb15,  #理由
                    ima02  LIKE ima_file.ima02,  #品名
                    ima021 LIKE ima_file.ima021, #規格   #FUN-5A0059
                    ima12  LIKE ima_file.ima12,  #成本分群
                    price  LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),            #標準單價
                    cost   LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)             #標準成本
                    END RECORD
 
   DEFINE  l_gem02    LIKE gem_file.gem02,       #NO.FUN-850086
           l_azf03    LIKE azf_file.azf03,       #NO.FUN-850086
           l_ima12_t  LIKE ima_file.ima12        #NO.FUN-850086
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET l_sql = "SELECT '',ina00,ina01,ina02,ina04,ina07,", 
                #" inb04,inb05,inb09,inb15,ima02,ima12,0,0 ",          #FUN-5A0059 mark
                 " inb04,inb05,inb09,inb15,ima02,ima021,ima12,0,0 ",   #FUN-5A0059
                 " FROM ina_file,inb_file,ima_file",
                 " WHERE ina01 = inb01 ",
                 " AND ina00 IN ('1','2','3','4') ",
                 " AND inb04 = ima01 ",
                 " AND inapost = 'Y' ",
                 " AND ina02 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
                 " AND ",tm.wc CLIPPED
 
     PREPARE asdr160_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80062    ADD
        EXIT PROGRAM  
     END IF
     DECLARE asdr160_curs1 CURSOR FOR asdr160_prepare1
#     CALL cl_outnam('asdr160') RETURNING l_name         #NO.FUN-850086
#     START REPORT asdr160_rep TO l_name                 #NO.FUN-850086
#     LET g_pageno = 0                                   #NO.FUN-850086
     CALL cl_del_data(l_table)                           #NO.FUN-850086
     
     FOREACH asdr160_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET sr.type = 1
       IF sr.ina00 = '1' OR sr.ina00 = '2'  THEN LET sr.type = -1 END IF
 
       #-->取標準單價
       SELECT stb07+stb08+stb09+stb09a INTO sr.price FROM stb_file
        WHERE stb01 = sr.inb04 AND stb02 = tm.yy AND stb03 = tm.mm
       IF STATUS OR cl_null(sr.price) THEN LET sr.price = 0 END IF
 
       IF sr.ina00 MATCHES '[34]' THEN LET sr.inb09 = sr.inb09 * (-1) END IF
       IF cl_null(sr.inb09) THEN LET sr.inb09 = 0 END IF
 
       #-->標準成本
       LET sr.cost = sr.price * sr.inb09
       IF cl_null(sr.cost) THEN LET sr.cost = 0 END IF
       #NO.FUN-850086------BEGIN------
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.ina04
       IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
 
       IF l_ima12_t <> sr.ima12 OR cl_null(sr.ima12) THEN
          IF NOT cl_null(sr.ima12) THEN
             SELECT azf03 INTO l_azf03 FROM azf_file 
                WHERE azf01=sr.ima12 AND azf02='G'
             IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF
             IF cl_null(l_azf03) THEN LET l_azf03 = sr.ima12 END IF
          END IF
       END IF
       LET l_ima12_t = sr.ima12
       EXECUTE insert_prep USING sr.inb15,sr.ina04,l_gem02,sr.ina02,
                                 sr.ina01,sr.inb05,sr.inb04,sr.ima02,
                                 sr.ima021,sr.inb09,sr.price,sr.cost,
                                 l_azf03,sr.type,sr.ima12
#       OUTPUT TO REPORT asdr160_rep(sr.*)
       #NO.FUN-850086------END--------
     END FOREACH
     #NO.FUN-850086------begin----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'ima12,inb04,ina01,ima08,inb15,ina04')
            RETURNING tm.wc
     ELSE
        LET tm.wc = ""
     END IF
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate,";",g_azi03,";",tm.yy,";",tm.mm
     CALL cl_prt_cs3('asdr160','asdr160',g_sql,g_str)     
#     FINISH REPORT asdr160_rep
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #NO.FUN-850086------END-------- 
END FUNCTION
 
#NO.FUN-850086----BEGIN------
#REPORT asdr160_rep(sr)
#  DEFINE l_last_sw    LIKE type_file.chr1,         #No.FUN-690010CHAR(1),
#         l_qtyamt,l_qtysum  LIKE inb_file.inb09,         #No.FUN-690010DEC(15,3), #TQC-840066
#         l_costamt,l_costsum LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),
#         l_gem02   LIKE gem_file.gem02,
#         l_azf03   LIKE azf_file.azf03,
#         sr        RECORD 
#                   type   LIKE type_file.num5,         #No.FUN-690010SMALLINT, 
#                   ina00  LIKE ina_file.ina00,  #單據類別
#                   ina01  LIKE ina_file.ina01,  #單據編號
#                   ina02  LIKE ina_file.ina02,  #單據日期
#                   ina04  LIKE ina_file.ina04,  #部門編號
#                   ina07  LIKE ina_file.ina07,  #備註
#                   inb04  LIKE inb_file.inb04,  #料號
#                   inb05  LIKE inb_file.inb05,  #倉庫
#                   inb09  LIKE inb_file.inb09,  #數量
#                   inb15  LIKE inb_file.inb15,  #理由
#                   ima02  LIKE ima_file.ima02,  #品名
#                   ima021 LIKE ima_file.ima021, #規格   #FUN-5A0059
#                   ima12  LIKE ima_file.ima12,  #成本分群
#                   price  LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6),            #標準單價
#                   cost   LIKE alb_file.alb06          #No.FUN-690010DEC(20,6)             #標準成本
#                   END RECORD
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# ORDER BY sr.ima12,sr.inb15,sr.ina04,sr.ina02  #成本分群/理由/部門/日期
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     LET g_head1=g_x[9] CLIPPED,' ',tm.bdate,'-',tm.edate
#     PRINT g_head1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
#           g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED  
#          ,g_x[42] CLIPPED   #FUN-5A0059
#     PRINT g_dash1
#     LET l_last_sw='n'
 
#  ON EVERY ROW
#      #-->取部門名稱
#      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = sr.ina04
#      IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
#      PRINT COLUMN g_c[31],sr.inb15,                #理由
#            COLUMN g_c[32],sr.ina04,
#            COLUMN g_c[33],l_gem02,                                 #部門
#            COLUMN g_c[34],sr.ina02,                                #單據日期
#            COLUMN g_c[35],sr.ina01,                                #單據編號
#            COLUMN g_c[36],sr.inb05,                                #庫別
#            COLUMN g_c[37],sr.inb04 CLIPPED,                        #料號
#            COLUMN g_c[38],sr.ima02 CLIPPED,                        #品名 #MOD-4A0238
#           #start FUN-5A0059
#            COLUMN g_c[39],sr.ima021 CLIPPED,                       #規格
#            COLUMN g_c[40],cl_numfor(sr.inb09,15,2) clipped,        #異動數量
#            COLUMN g_c[41],cl_numfor(sr.price,41,g_azi03) clipped,  #單價 
#            COLUMN g_c[42],cl_numfor(sr.cost,42,g_azi03)            #成本
#           #end FUN-5A0059
 
#  AFTER GROUP OF sr.ina04  #部門小計
#      LET l_qtyamt  = GROUP SUM(sr.inb09)
#      LET l_costamt = GROUP SUM(sr.cost)
#      IF cl_null(l_qtyamt)  THEN LET l_qtyamt = 0 END IF
#      IF cl_null(l_costamt) THEN LET l_costamt= 0 END IF
#     #PRINT COLUMN g_c[32],g_dash2   #FUN-5A0059 mark
#      PRINT g_dash2[1,g_len]         #FUN-5A0059
#      PRINT COLUMN g_c[32],g_x[10] CLIPPED,
#            COLUMN g_c[40],cl_numfor(l_qtyamt,15,2)  CLIPPED,       #FUN-5A0059
#            COLUMN g_c[42],cl_numfor(l_costamt,42,g_azi03) CLIPPED  #FUN-5A0059
 
#  AFTER GROUP OF sr.inb15  #原因小計
#      LET l_qtyamt  = GROUP SUM(sr.inb09)
#      LET l_costamt = GROUP SUM(sr.cost)
#      IF cl_null(l_qtyamt)  THEN LET l_qtyamt = 0 END IF
#      IF cl_null(l_costamt) THEN LET l_costamt= 0 END IF
#     #PRINT COLUMN g_c[32],g_dash2   #FUN-5A0059 mark
#      PRINT g_dash2[1,g_len]         #FUN-5A0059
#      PRINT COLUMN g_c[32],g_x[11] CLIPPED,
#            COLUMN g_c[40],cl_numfor(l_qtyamt,15,2)  CLIPPED,       #FUN-5A0059
#            COLUMN g_c[42],cl_numfor(l_costamt,42,g_azi03) CLIPPED  #FUN-5A0059
#
#  AFTER GROUP OF sr.ima12  #成本分群
#      LET l_qtyamt  = GROUP SUM(sr.inb09)
#      LET l_costamt = GROUP SUM(sr.cost)
#      IF cl_null(l_qtyamt)  THEN LET l_qtyamt = 0 END IF
#      IF cl_null(l_costamt) THEN LET l_costamt= 0 END IF
#     #PRINT COLUMN g_c[32],g_dash2   #FUN-5A0059 mark
#      PRINT g_dash2[1,g_len]         #FUN-5A0059
#      IF NOT cl_null(sr.ima12) THEN
#         SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.ima12 AND azf02='G' #6818
#         IF SQLCA.sqlcode THEN LET l_azf03 = ' ' END IF
#         IF cl_null(l_azf03) THEN LET l_azf03 = sr.ima12 END IF
#         PRINT COLUMN g_c[31],l_azf03 CLIPPED,COLUMN g_c[32],g_x[15] CLIPPED;
#      END IF
#      PRINT COLUMN g_c[40],cl_numfor(l_qtyamt,15,2)  CLIPPED,       #FUN-5A0059
#            COLUMN g_c[42],cl_numfor(l_costamt,42,g_azi03) CLIPPED  #FUN-5A0059
 
#  ON LAST ROW  
#      PRINT g_dash2[1,g_len] CLIPPED
#      #-->雜入小計
#      LET l_qtysum  =SUM(sr.inb09) WHERE sr.type=1
#      LET l_costsum =SUM(sr.cost)  WHERE sr.type=1
#      IF cl_null(l_qtysum)  THEN LET l_qtysum  = 0 END IF
#      IF cl_null(l_costsum) THEN LET l_costsum = 0 END IF
#      PRINT COLUMN g_c[32],g_x[12] CLIPPED,
#            COLUMN g_c[40],cl_numfor(l_qtysum,15,2)  CLIPPED,       #FUN-5A0059
#            COLUMN g_c[42],cl_numfor(l_costsum,42,g_azi03) CLIPPED  #FUN-5A0059
 
#      #-->雜出小計
#      LET l_qtysum  =SUM(sr.inb09) WHERE sr.type= -1
#      LET l_costsum =SUM(sr.cost)  WHERE sr.type= -1
#      IF cl_null(l_qtysum)  THEN LET l_qtysum  = 0 END IF
#      IF cl_null(l_costsum) THEN LET l_costsum = 0 END IF
#      PRINT COLUMN g_c[32],g_x[13] CLIPPED,
#            COLUMN g_c[40],cl_numfor(l_qtysum,15,2)  CLIPPED,       #FUN-5A0059
#            COLUMN g_c[42],cl_numfor(l_costsum,42,g_azi03) CLIPPED  #FUN-5A0059
 
#      #-->總計 
#      LET l_qtysum  =SUM(sr.inb09) 
#      LET l_costsum =SUM(sr.cost) 
#      IF cl_null(l_qtysum)  THEN LET l_qtysum  = 0 END IF
#      IF cl_null(l_costsum) THEN LET l_costsum = 0 END IF
#      PRINT g_dash2[1,g_len] CLIPPED
#      PRINT COLUMN g_c[32],g_x[14] CLIPPED,
#            COLUMN g_c[40],cl_numfor(l_qtysum,15,2)  CLIPPED,       #FUN-5A0059
#            COLUMN g_c[42],cl_numfor(l_costsum,42,g_azi03) CLIPPED  #FUN-5A0059
 
#     PRINT g_dash[1,g_len] CLIPPED
#     LET l_last_sw = 'y'
#     PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#  PAGE TRAILER
#     IF l_last_sw = 'n'
#        THEN PRINT g_dash[1,g_len] CLIPPED
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE SKIP 2 LINE
#     END IF
 
#END REPORT
#NO.FUN-850086----END-----
