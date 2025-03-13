# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asfr817.4gl
# Descriptions...: 工作中心Run Card在製量狀況表列印
# Date & Author..: 00/08/16 By Mandy
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: NO.FUN-510040 05/02/16 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0105 05/12/26 By Rosayu 排列順序有料件的長度要設成40
#
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.TQC-770003 07/07/03 By zhoufeng 維護幫助按鈕
# Modify.........: No.FUN-840053 08/05/07 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 過單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60080 10/07/08 By destiny 报表显示增加制程段号字段
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                # Print condition RECORD
#              wc       VARCHAR(600),   # Where condition  #NO.TQC-630166 MARK
              wc       STRING,   # Where condition
              s        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Order by sequence
              t        LIKE type_file.chr3,          #No.FUN-680121 VARCHAR(3)# Eject sw
              more     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
 
#DEFINE   g_dash          VARCHAR(400)   #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
DEFINE l_table            STRING     #No.FUN-840053                                                             
DEFINE l_sql              STRING     #No.FUN-840053
DEFINE g_sql              STRING     #No.FUN-840053                                                             
DEFINE g_str              STRING     #No.FUN-840053
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
#No.FUN-840053---Begin 
   LET g_sql = " shm01.shm_file.shm01,",
               " shm05.shm_file.shm05,",
               " shm08.shm_file.shm08,",
               " sgm03.sgm_file.sgm03,",
               " sgm04.sgm_file.sgm04,",
               " sgm301.sgm_file.sgm301,",
               " sgm303.sgm_file.sgm303,",
               " sgm311.sgm_file.sgm311,",
               " sgm316.sgm_file.sgm316,",
               " sgm313.sgm_file.sgm313,",
               " sgm315.sgm_file.sgm315,",
               " sgm321.sgm_file.sgm321,",
               " sgm291.sgm_file.sgm291,",
               " shm012.shm_file.shm012,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " sgm45.sgm_file.sgm45,",
               " sgm302.sgm_file.sgm302,",
               " sgm304.sgm_file.sgm304,",
               " sgm312.sgm_file.sgm312,",
               " sgm317.sgm_file.sgm317,",
               " sgm314.sgm_file.sgm314,",
               " l_wipqty.sgm_file.sgm302,",
               " sgm322.sgm_file.sgm322,",
               " l_waitqty.sgm_file.sgm302,",
               " l_woqty.sgm_file.sgm302,",
               " sgm06.sgm_file.sgm06,",  
               " eca02.eca_file.eca02, ",
               " sgm012.sgm_file.sgm012 "  #NO.FUN-A60080 add sgm012             
   LET l_table = cl_prt_temptable('asfr817',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? )" #NO.FUN-A60080 add ?  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-840053---End   
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
    LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
    LET g_towhom = ARG_VAL(2)
    LET g_rlang  = ARG_VAL(3)
    LET g_bgjob  = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc    = ARG_VAL(7)
    LET tm.s     = ARG_VAL(8)
    LET tm.t     = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   #No.FUN-570264 ---end---
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN # If background job sw is off
        CALL r817_tm(0,0)                  # Input print condition
    ELSE
        CALL r817()                        # Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r817_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_cmd          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
           l_n,l_cnt      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_a            LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
    IF p_row = 0 THEN LET p_row = 6 LET p_col = 12 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 6 LET p_col = 12
   END IF
 
    OPEN WINDOW r817_w AT p_row,p_col
        WITH FORM "asf/42f/asfr817"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL            # Default condition
    LET tm.s    = '123'
    LET tm.t    = ''
    LET tm.more = 'N'
    LET g_pdate = g_today
    LET g_rlang = g_lang
    LET g_bgjob = 'N'
    LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
WHILE TRUE
    CONSTRUCT BY NAME tm.wc ON sgm06,shm01,shm012,shm05
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
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
     ON ACTION help
        CALL cl_show_help()                         #No.TQC-770003
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
        LET INT_FLAG = 0 CLOSE WINDOW r817_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
    END IF
    IF tm.wc = ' 1=1' THEN
        CALL cl_err('','9046',0) CONTINUE WHILE
    END IF
 
    INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,
                   tm2.t1,tm2.t2,tm2.t3,
                   tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD more
            IF tm.more = 'Y' THEN
                CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
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
      AFTER INPUT
         LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
         LET tm.t = tm2.t1,tm2.t2,tm2.t3
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
          ON ACTION help
             CALL cl_show_help()              #No.TQC-770003
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
 
    IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW r817_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
            WHERE zz01='asfr817'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asfr817','9031',1)
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
                         " '",tm.s CLIPPED,"'",
                         " '",tm.t CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('asfr817',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW r817_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
    END IF
    CALL cl_wait()
    CALL r817()
    ERROR ""
END WHILE
    CLOSE WINDOW r817_w
END FUNCTION
 
FUNCTION r817()
    DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time           LIKE type_file.chr8        #No.FUN-6A0090
           l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1200)
           l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
           l_wipqty  LIKE sgm_file.sgm302,         #No.FUN-840053
           l_waitqty LIKE sgm_file.sgm302,         #No.FUN-840053
           l_woqty   LIKE sgm_file.sgm302,         #No.FUN-840053
           l_order   ARRAY[3] OF LIKE shm_file.shm05,                 #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
           sr        RECORD        order1 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                   order2 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                   order3 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                   shm01  LIKE shm_file.shm01,  #Run Card
                                   shm012 LIKE shm_file.shm012, #工單編號
                                   shm05  LIKE shm_file.shm05,  #產品編號
                                   shm08  LIKE shm_file.shm08,  #生產數量
                                   sgm03  LIKE sgm_file.sgm03,  #製程序號
                                   sgm04  LIKE sgm_file.sgm04,  #作業編號
                                   sgm06  LIKE sgm_file.sgm06,  #工作中心編號
                                   sgm45  LIKE sgm_file.sgm45,  #作業名稱
                                   sgm301 LIKE sgm_file.sgm301, #良品轉入量
                                   sgm302 LIKE sgm_file.sgm302, #重工轉入量
                                   sgm303 LIKE sgm_file.sgm303, #分割轉入量
                                   sgm304 LIKE sgm_file.sgm304, #合併轉入量
                                   sgm311 LIKE sgm_file.sgm311, #良品轉出量
                                   sgm312 LIKE sgm_file.sgm312, #重工轉出
                                   sgm316 LIKE sgm_file.sgm316, #分割轉出量
                                   sgm317 LIKE sgm_file.sgm317, #合併轉出量
                                   sgm313 LIKE sgm_file.sgm313, #當站報廢量
                                   sgm314 LIKE sgm_file.sgm314, #當站下線量
                                   sgm315 LIKE sgm_file.sgm315, #Bonus量
                                   sgm321 LIKE sgm_file.sgm321, #委外加工量
                                   sgm322 LIKE sgm_file.sgm322, #委外完工量
                                   sgm291 LIKE sgm_file.sgm291, #Check in量
                                   sgm54  LIKE sgm_file.sgm54,  #Check in 否
                                   sgm59  LIKE sgm_file.sgm59,  #Check in 否
                                   eca02  LIKE eca_file.eca02,  #簡述工作站特性說明
                                   ima02  LIKE ima_file.ima02,   #品名規格
                                   ima021  LIKE ima_file.ima021   #規格
                                   ,sgm012 LIKE sgm_file.sgm012 #NO.FUN-A60080 add sgm012
                         END RECORD
    DEFINE  l_t          STRING    #NO.FUN-A60080 
    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'asfr817'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 133 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET tm.wc= tm.wc clipped," AND sgmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET tm.wc= tm.wc clipped," AND sgmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc= tm.wc clipped," AND sgmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sgmuser', 'sgmgrup')
    #End:FUN-980030
 
 
    LET l_sql = "SELECT '','','',shm01,shm012,shm05,shm08,sgm03,sgm04,sgm06,sgm45,",
                "sgm301,sgm302,sgm303,sgm304,sgm311,sgm312,sgm316,sgm317,",
                "sgm313,sgm314,sgm315,sgm321,",
                "sgm322,sgm291,sgm54,sgm59,eca02,ima02,ima021,sgm012 ",  #NO.FUN-A60080 add sgm012
                "  FROM sgm_file,shm_file,OUTER eca_file,OUTER ima_file ",
                " WHERE ",tm.wc CLIPPED,
                "   AND shm01 = sgm01 ",
                "   AND sgm_file.sgm06 = eca_file.eca01 ",
                "   AND shm_file.shm05 = ima_file.ima01 ",
                " ORDER BY sgm06,shm01,sgm03 " CLIPPED
 
    PREPARE r817_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
    END IF
    DECLARE r817_curs1 CURSOR FOR r817_prepare1
 
#   CALL cl_outnam('asfr817') RETURNING l_name #No.FUN-840053
#   START REPORT r817_rep TO l_name            #No.FUN-840053
    CALL cl_del_data(l_table)                  #No.FUN-840053
   
    LET g_pageno = 0
    FOREACH r817_curs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
#No.FUN-840053---Begin
      LET l_wipqty = (sr.sgm301 + sr.sgm302 + sr.sgm303 + sr.sgm304)
                   - sr.sgm59*(sr.sgm311 + sr.sgm312 + sr.sgm316 + sr.sgm317
                               + sr.sgm313 + sr.sgm314 )
      IF sr.sgm54 = 'Y' THEN  # 須check in
          LET l_waitqty = (sr.sgm301 + sr.sgm302 + sr.sgm303 + sr.sgm304) - sr.sgm291
          LET l_woqty  =  sr.sgm291 - sr.sgm59*(sr.sgm311 + sr.sgm312 + sr.sgm316 + sr.sgm317 + sr.sgm313 + sr.sgm314 )
      ELSE
          LET l_waitqty = 0
          LET l_woqty  = l_wipqty
      END IF
#       FOR g_i = 1 TO 3
#         CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.sgm06
#              WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.shm01
#              WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.shm012
#              WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.shm05
#              OTHERWISE LET l_order[g_i] = '-'
#         END CASE
#      END FOR
#      LET sr.order1 = l_order[1]
#      LET sr.order2 = l_order[2]
#      LET sr.order3 = l_order[3]
#      OUTPUT TO REPORT r817_rep(sr.*)
       EXECUTE insert_prep USING sr.shm01, sr.shm05, sr.shm08, sr.sgm03, sr.sgm04, sr.sgm301,sr.sgm303,
                                 sr.sgm311,sr.sgm316,sr.sgm313,sr.sgm315,sr.sgm321,sr.sgm291,sr.shm012,
                                 sr.ima02, sr.ima021,sr.sgm45, sr.sgm302,sr.sgm304,sr.sgm312,sr.sgm317, 
                                 sr.sgm314,l_wipqty, sr.sgm322,l_waitqty,l_woqty,  sr.sgm06, sr.eca02 
                                 ,sr.sgm012 #NO.FUN-A60080 add sgm012 
    END FOREACH
 
#   FINISH REPORT r817_rep
 
#   CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'sgm06,shm01,shm012,shm05')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",tm.t                                                            
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED     
     #NO.FUN-A60080--begin
     IF g_sma.sma541='Y' THEN  
        LET l_t='asfr817_1'
     ELSE 
     	  LET l_t='asfr817'
     END IF   
     CALL cl_prt_cs3('asfr817',l_t,l_sql,g_str)                                          
     #CALL cl_prt_cs3('asfr817','asfr817',l_sql,g_str)   
     #NO.FUN-A60080--end 
#No.FUN-840053---End  
END FUNCTION
 
REPORT r817_rep(sr)
    DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680121 VARCHAR(1)
           l_wipqty     LIKE sgm_file.sgm302,          #No.FUN-680121 DEC(11,3)
           l_waitqty    LIKE sgm_file.sgm302,          #No.FUN-680121 DEC(11,3)
           l_woqty      LIKE sgm_file.sgm302,          #No.FUN-680121 DEC(11,3)
           l_ima02      LIKE ima_file.ima02,
           sr        RECORD        order1 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                   order2 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                   order3 LIKE shm_file.shm05,        #No.FUN-680121 VARCHAR(40)#FUN-5B0105 20->40
                                   shm01  LIKE shm_file.shm01,  #Run Card
                                   shm012 LIKE shm_file.shm012, #工單編號
                                   shm05  LIKE shm_file.shm05,  #產品編號
                                   shm08  LIKE shm_file.shm08,  #生產數量
                                   sgm03  LIKE sgm_file.sgm03,  #製程序號
                                   sgm04  LIKE sgm_file.sgm04,  #作業編號
                                   sgm06  LIKE sgm_file.sgm06,  #工作中心編號
                                   sgm45  LIKE sgm_file.sgm45,  #作業名稱
                                   sgm301 LIKE sgm_file.sgm301, #良品轉入量
                                   sgm302 LIKE sgm_file.sgm302, #重工轉入量
                                   sgm303 LIKE sgm_file.sgm303, #分割轉入量
                                   sgm304 LIKE sgm_file.sgm304, #合併轉入量
                                   sgm311 LIKE sgm_file.sgm311, #良品轉出量
                                   sgm312 LIKE sgm_file.sgm312, #重工轉出
                                   sgm316 LIKE sgm_file.sgm316, #分割轉出量
                                   sgm317 LIKE sgm_file.sgm317, #合併轉出量
                                   sgm313 LIKE sgm_file.sgm313, #當站報廢量
                                   sgm314 LIKE sgm_file.sgm314, #當站下線量
                                   sgm315 LIKE sgm_file.sgm315, #Bonus量
                                   sgm321 LIKE sgm_file.sgm321, #委外加工量
                                   sgm322 LIKE sgm_file.sgm322, #委外完工量
                                   sgm291 LIKE sgm_file.sgm291, #Check in量
                                   sgm54  LIKE sgm_file.sgm54,  #Check in 否
                                   sgm59  LIKE sgm_file.sgm59,  #Check in 否
                                   eca02  LIKE eca_file.eca02,  #簡述工作站特性說明
                                   ima02  LIKE ima_file.ima02,   #品名規格
                                   ima021 LIKE ima_file.ima021   #品名規格
                     END RECORD,
      l_chr,l_a      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    OUTPUT TOP MARGIN g_top_margin
           LEFT MARGIN g_left_margin
           BOTTOM MARGIN g_bottom_margin
           PAGE LENGTH g_page_line   #No.MOD-580242
 
    ORDER BY sr.sgm06,sr.order1,sr.order2,sr.order3,sr.shm01,sr.sgm03
    FORMAT
    PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        LET g_pageno = g_pageno + 1
        LET pageno_total = PAGENO USING '<<<',"/pageno"
        PRINT g_head CLIPPED, pageno_total
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
        PRINT ' '
        PRINT g_dash[1,g_len]
        PRINT g_x[10] CLIPPED,sr.sgm06 CLIPPED,' ',sr.eca02 CLIPPED
        PRINT ''
        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
               g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
        PRINTX name=H2 g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
               g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57]
        PRINT g_dash1
        LET l_last_sw = 'n'
        LET l_chr = 'Y'
        LET l_a ='Y'
 
    BEFORE GROUP OF sr.sgm06
        LET l_chr = 'Y'
        NEED 5 LINES
        IF l_a = 'N' THEN
            PRINT g_x[10] CLIPPED,sr.sgm06 CLIPPED,' ',sr.eca02 CLIPPED
            PRINT ''
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
                   g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]
            PRINTX name=H2 g_x[44],g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],
                   g_x[51],g_x[52],g_x[53],g_x[54],g_x[55],g_x[56],g_x[57]
            PRINT g_dash1
        END IF
 
    BEFORE GROUP OF sr.order1
        IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
    BEFORE GROUP OF sr.order2
        IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
    BEFORE GROUP OF sr.order3
        IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
    ON EVERY ROW
 
      #WIP量(wipqty)=  總投入量(良品轉入量sgm301+重工轉入量sgm302+分割轉入sgm303+合併轉入sgm304)
      #               -總轉出量(良品轉出量sgm311+重工轉出量sgm312+分割轉出sgm316+合併轉出sgm317)
      #               -當站報廢量sgm313
      #               -當站下線量(入庫量)sgm314
      #等待上線數量(Waitqyt)=總投入量(良品轉入量sgm301+重工轉入量sgm302
      #                              +分割轉入量sgm303+合併轉入量sgm304 )
      #                      -Check In量sgm291
      #上線處理數量(Woqty)=Check In量sgm291
      #                   -總轉出量(良品轉出量sgm311+重工轉出量sgm312
      #                            +分割轉出量sgm316+合併轉出量sgm317)
      #                   -當站報廢量sgm313
      #                   -當站下線量(入庫量)sgm314
      LET l_wipqty = (sr.sgm301 + sr.sgm302 + sr.sgm303 + sr.sgm304)
                   - sr.sgm59*(sr.sgm311 + sr.sgm312 + sr.sgm316 + sr.sgm317
                               + sr.sgm313 + sr.sgm314 )
      IF sr.sgm54 = 'Y' THEN  # 須check in
          LET l_waitqty = (sr.sgm301 + sr.sgm302 + sr.sgm303 + sr.sgm304) - sr.sgm291
          LET l_woqty  =  sr.sgm291 - sr.sgm59*(sr.sgm311 + sr.sgm312 + sr.sgm316 + sr.sgm317 + sr.sgm313 + sr.sgm314 )
      ELSE
          LET l_waitqty = 0
          LET l_woqty  = l_wipqty
      END IF
      NEED 2 LINES
      PRINTX name=D1 COLUMN g_c[31],sr.shm01,
            COLUMN g_c[32],sr.shm05,
            COLUMN g_c[33],sr.shm08 USING '######&.&',
            COLUMN g_c[34], sr.sgm03 USING '####',
            COLUMN g_c[35],sr.sgm04,
            COLUMN g_c[36],sr.sgm301 USING '-----&.&',
            COLUMN g_c[37],sr.sgm303 USING '-----&.&',
            COLUMN g_c[38],sr.sgm311 USING '-----&.&',
            COLUMN g_c[39],sr.sgm316 USING '-----&.&',
            COLUMN g_c[40],sr.sgm313 USING '-----&.&',
            COLUMN g_c[41],sr.sgm315 USING '-----&.&',
            COLUMN g_c[42],sr.sgm321 USING '-----&.&',
            COLUMN g_c[43],sr.sgm291 USING '-----&.&'
      PRINTX name=D2 COLUMN g_c[44],sr.shm012,
             COLUMN g_c[45],sr.ima02 CLIPPED,  #MOD-4A0238
            COLUMN g_c[46],sr.ima021 CLIPPED,
            COLUMN g_c[47],' ',
            COLUMN g_c[48],sr.sgm45[1,20],
            COLUMN g_c[49],sr.sgm302 USING '-----&.&',
            COLUMN g_c[50],sr.sgm304 USING '-----&.&',
            COLUMN g_c[51],sr.sgm312 USING '-----&.&',
            COLUMN g_c[52],sr.sgm317 USING '-----&.&',
            COLUMN g_c[53],sr.sgm314 USING '-----&.&',
            COLUMN g_c[54],l_wipqty  USING '-----&.&',
            COLUMN g_c[55],sr.sgm322 USING '-----&.&',
            COLUMN g_c[56],l_waitqty USING '-----&.&',
            COLUMN g_c[57],l_woqty   USING '-----&.&'
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
       CALL cl_wcchp(tm.wc,'sgm06,shm01,shm012,shm05') RETURNING tm.wc
         PRINT g_dash[1,g_len]
#NO.TQC-630166 start
#              IF tm.wc[001,120] > ' ' THEN            # for 132
#          PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#              IF tm.wc[121,240] > ' ' THEN
#          PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#              IF tm.wc[241,300] > ' ' THEN
#          PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
           CALL cl_prt_pos_wc(tm.wc)
#NO.TQC-630166 end---
      END IF
      PRINT g_dash[1,g_len]
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#No.FUN-870144
