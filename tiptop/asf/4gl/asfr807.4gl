# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: asfr807.4gl
# Descriptions...: 產品/Run Card資料表
# Input parameter:
# Return code....: 00/08/17 By Mandy
# Modify ........: No:9353 04/03/17 By Melody shb_file 前應加 OUTER ，使得尚未報工之 RUN CARD 也可列印
# Modify.........: NO.FUN-510040 05/02/16 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0015 05/11/02 BY Yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.MOD-6C0106 06/12/25 By Sarah 抓取sr.a值的WHERE條件增加shb06 = sr.sgm03
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A60092 10/07/09 By lilingyu 平行工藝
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                   # Print condition RECORD
#                   wc     VARCHAR(600),    # Where condition
                   wc     STRING,    # Where condition  #NO.TQC-630166 
                   more   LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
               END RECORD
#DEFINE   g_dash          VARCHAR(400)              #Dash line
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#DEFINE   g_len           SMALLINT   #Report width(79/132/136)
#DEFINE   g_pageno        SMALLINT   #Report page no
#DEFINE   g_zz05          VARCHAR(1)   #Print tm.wc ?(Y/N)
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                 # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
 
 
    LET g_pdate  = ARG_VAL(1)       # Get arguments from command line
    LET g_towhom = ARG_VAL(2)
    LET g_rlang  = ARG_VAL(3)
    LET g_bgjob  = ARG_VAL(4)
    LET g_prtway = ARG_VAL(5)
    LET g_copies = ARG_VAL(6)
    LET tm.wc    = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN # If background job sw is off
        CALL r807_tm(0,0)     # Input print condition
    ELSE
        CALL asfr807()        # Read data and create out-file
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r807_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
    DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_cmd          LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(400)
    IF p_row = 0 THEN LET p_row = 4 LET p_col = 14 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 7 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 14
   END IF
    OPEN WINDOW r807_w AT p_row,p_col
        WITH FORM "asf/42f/asfr807"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
    CALL cl_opmsg('p')
    INITIALIZE tm.* TO NULL            # Default condition
    LET tm.more  = 'N'
    LET g_pdate  = g_today
    LET g_rlang  = g_lang
    LET g_bgjob  = 'N'
    LET g_copies = '1'
WHILE TRUE
    DISPLAY BY NAME tm.more  # Condition
    CONSTRUCT BY NAME tm.wc ON shm05,shm01
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
 
    IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r807_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM 
    END IF
    IF tm.wc= " 1=1 " THEN CALL cl_err(' ','9046',0) CONTINUE WHILE END IF
    DISPLAY BY NAME tm.more  # Condition
    INPUT BY NAME tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
        AFTER FIELD more
             IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
                 NEXT FIELD more
             END IF
             IF tm.more = 'Y' THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                 RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
             END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW r807_w 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
       EXIT PROGRAM 
    END IF
    IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file  WHERE zz01='asfr807'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('asfr807','9031',1)
        ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('asfr807',g_time,l_cmd)      # Execute cmd at later time
        END IF
        CLOSE WINDOW r807_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
    END IF
    CALL cl_wait()
    CALL asfr807()
    ERROR ""
END WHILE
    CLOSE WINDOW r807_w
END FUNCTION
 
FUNCTION asfr807()
    DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time           LIKE type_file.chr8        #No.FUN-6A0090
           l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000)
           l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_shb111  LIKE shb_file.shb111,
           l_shb113  LIKE shb_file.shb113,
           ss        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_s1      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           i         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           j         LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           sr        RECORD
                         shm05  LIKE shm_file.shm05,  #產品編號
                         ima02  LIKE ima_file.ima02,  #料品名稱
                         ima021  LIKE ima_file.ima021,  #規格
                         shm01  LIKE shm_file.shm01,  #Run Card
                         shm012 LIKE shm_file.shm012, #工單編號
                         shm08  LIKE shm_file.shm08,  #生產量
                         shm09  LIKE shm_file.shm09,  #入庫量
                         shm12  LIKE shm_file.shm12,  #報廢量
                         sgm03  LIKE sgm_file.sgm03,  #op#
                         sgm45  LIKE sgm_file.sgm45,  #作業名稱
                         sgm14  LIKE sgm_file.sgm14,  #標準人工生產時間(秒)
#                        a      LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)#實工
#                        b      LIKE ima_file.ima26,  #No.FUN-680121 DEC(15,3)#標工
#                        c      LIKE ima_file.ima26   #No.FUN-680121 DEC(15,3)#效率
                         a      LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
                         b      LIKE type_file.num15_3,  ###GP5.2  #NO.FUN-A20044
                         c      LIKE type_file.num15_3   ###GP5.2  #NO.FUN-A20044
                        ,sgm012 like sgm_file.sgm012     #FUN-A60092 add 
                     END RECORD
 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET tm.wc = tm.wc clipped," AND shmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET tm.wc = tm.wc clipped," AND shmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET tm.wc = tm.wc clipped," AND shmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('shmuser', 'shmgrup')
    #End:FUN-980030
 
    LET l_sql = " SELECT shm05,ima02,ima021,shm01,shm012,shm08,shm09,shm12,",
                "        sgm03,sgm45,sgm14,'','','',sgm012",   #FUN-A60092 add sgm012
                " FROM shm_file,sgm_file,OUTER shb_file,OUTER ima_file", #No:9353
             #  " WHERE shm_file.shm01 = shb_file.shb16",                      #巳產生製程追蹤檔  #FUN-A60092
                " WHERE sgm_file.sgm01 = shb_file.shb16",                                         #FUN-A60092
                "   AND shm01 = sgm01",
                "   AND sgm_file.sgm012 = shb_file.shb012",                                       #FUN-A60092 add
                "   AND shm_file.shm05 = ima_file.ima01",
                "   AND shbconf = 'Y' ",   #FUN-A70095
                "   AND ",tm.wc CLIPPED
    PREPARE r807_prepare1 FROM l_sql
    IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
    END IF
    DECLARE r807_cs1 CURSOR FOR r807_prepare1
    CALL cl_outnam('asfr807') RETURNING l_name
    START REPORT r807_rep TO l_name
    LET g_pageno = 0
    FOREACH r807_cs1 INTO sr.*
        IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        SELECT SUM(shb032) INTO sr.a FROM shb_file
            WHERE shb16 = sr.shm01   #Run Card
              AND shb06 = sr.sgm03   #製程序號   #MOD-6C0106 add
              AND shb012= sr.sgm012   #FUN-A60092 add
              AND shbconf = 'Y'      #FUN-A70095
        IF sr.a IS NULL THEN LET sr.a = 0 END IF
        SELECT shb111,shb113 INTO l_shb111,l_shb113 FROM shb_file
         WHERE shb16 = sr.shm01
           AND shb012= sr.sgm012    #FUN-A60092 add
           AND shbconf = 'Y'        #FUN-A70095 add
        LET sr.b = ((sr.sgm14)/60)*(l_shb111+l_shb113)
        IF sr.b IS NULL THEN LET sr.b = 0 END IF
        LET sr.c = sr.b/sr.a*100
        IF sr.c IS NULL THEN LET sr.c = 0 END IF
 #FUN-A60092--start---
      IF g_sma.sma541 = 'Y' THEN
          LET g_zaa[45].zaa06 = 'N'  
       ELSE
          LET g_zaa[45].zaa06 = 'Y'
       END IF 
 #FUN-A60092 --end---        
        OUTPUT TO REPORT r807_rep(sr.*)
    END FOREACH
    FINISH REPORT r807_rep
    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT r807_rep(sr)
    DEFINE l_last_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_str         LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)
           l_sw          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_sta         LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(12)
           l_sta1        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(22)
#          l_a           LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(15,3)
#          l_b           LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(15,3)
#          l_c           LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(15,3)
           l_a           LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
           l_b           LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
           l_c           LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
           l_n           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_n1          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           sr            RECORD
                             shm05  LIKE shm_file.shm05,  #產品編號
                             ima02  LIKE ima_file.ima02,  #料品名稱
                             ima021  LIKE ima_file.ima021,  #規格
                             shm01  LIKE shm_file.shm01,  #Run Card
                             shm012 LIKE shm_file.shm012, #工單編號
                             shm08  LIKE shm_file.shm08,  #生產量
                             shm09  LIKE shm_file.shm09,  #入庫量
                             shm12  LIKE shm_file.shm12,  #報廢量
                             sgm03  LIKE sgm_file.sgm03,  #op#
                             sgm45  LIKE sgm_file.sgm45,  #作業名稱
                             sgm14  LIKE sgm_file.sgm14,  #標準人工生產時間(秒)
#                            a      LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)#實工
#                            b      LIKE ima_file.ima26,          #No.FUN-680121 DEC(15,3)#標工
#                            c      LIKE ima_file.ima26           #No.FUN-680121 DEC(15,3)#效率
                             a      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
                             b      LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
                             c      LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044 
                            ,sgm012 LIKE sgm_file.sgm012       #FUN-A60092 add 
                         END RECORD
 
    OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   #No.MOD-580242
    ORDER BY sr.shm05,sr.shm01,sr.shm012,sr.sgm03
    FORMAT
    PAGE HEADER
        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
        LET g_pageno = g_pageno + 1
        LET pageno_total = PAGENO USING '<<<',"/pageno"
        PRINT g_head CLIPPED, pageno_total
        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
        PRINT ' '
        PRINT g_dash[1,g_len]

        PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
                       g_x[45],              #FUN-A60092 add
                       g_x[37],g_x[38],g_x[39],g_x[40],g_x[41]
        PRINTX name=H2 g_x[42],g_x[43],g_x[44]
        PRINT g_dash1
        LET l_last_sw = 'n'
 
    BEFORE GROUP OF sr.shm05
       #PRINTX name=D1 COLUMN g_c[31],sr.shm05[1,20],
        PRINTX name=D1 COLUMN g_c[31],sr.shm05 clipped,  #NO.FUN-5B0015
                       COLUMN g_c[32],sr.ima02;
        LET l_n1 = 1
    BEFORE GROUP OF sr.shm01
        LET l_a = 0
        LET l_b = 0
        LET l_c = 0
        LET l_n = 1
       PRINTX name=D1 COLUMN g_c[33],sr.shm01[1,16],
              COLUMN g_c[34],sr.shm08 USING '--------&.&',
              COLUMN g_c[35],sr.shm09 USING '-------&.&',
              COLUMN g_c[36],sr.shm12 USING '------&.&'                            
       PRINTX name=D2 COLUMN g_c[42],' ',
                      COLUMN g_c[43],sr.ima021,
                      COLUMN g_c[44],sr.shm012
    AFTER GROUP OF sr.sgm03
        IF l_n  = 2 THEN
            IF l_n1 = 1 THEN
                LET l_n1 = 0
            END IF
      #      PRINT COLUMN 32,sr.shm012;
        END IF
        PRINTX name=D1 COLUMN g_c[45],sr.sgm012,  #FUN-A60092 --add--        
                       COLUMN g_c[37],sr.sgm03 USING '#####',
                       COLUMN g_c[38],sr.sgm45[1,20],
                       COLUMN g_c[39],sr.a USING '###&.&&',
                       COLUMN g_c[40],sr.b USING '###&.&&',
                       COLUMN g_c[41],sr.c USING '###&.&&'
        IF sr.a IS NULL THEN LET sr.a = 0 END IF
        IF sr.b IS NULL THEN LET sr.b = 0 END IF
        IF sr.c IS NULL THEN LET sr.c = 0 END IF
        LET l_a  = sr.a + l_a
        LET l_b  = sr.b + l_b
        LET l_c  = sr.c + l_c
        LET l_n  = l_n  + 1        
    AFTER GROUP OF sr.shm01
        PRINTX name=S1 COLUMN g_c[37],g_dash2[1,g_w[37]],
                       COLUMN g_c[38],g_dash2[1,g_w[38]],
                       COLUMN g_c[39],g_dash2[1,g_w[39]],
                       COLUMN g_c[40],g_dash2[1,g_w[40]],
                       COLUMN g_c[41],g_dash2[1,g_w[41]]
 
        PRINTX name=S1 COLUMN g_c[38],g_x[9] CLIPPED,
                       COLUMN g_c[39],l_a USING '###&.&&',
                       COLUMN g_c[40],l_b USING '###&.&&',
                       COLUMN g_c[41],l_c USING '###&.&&'
        PRINT ''
    ON LAST ROW
        IF g_zz05 = 'Y'   THEN
            PRINT g_dash[1,g_len]
#NO.TQC-630166 start**
#            IF tm.wc[001,120] > ' ' THEN            # for 132
#                PRINT g_x[8] CLIPPED,tm.wc[001,120] CLIPPED END IF
#                IF tm.wc[121,240] > ' ' THEN
#                    PRINT COLUMN 10,     tm.wc[121,240] CLIPPED END IF
#                     IF tm.wc[241,300] > ' ' THEN
#                         PRINT COLUMN 10,     tm.wc[241,300] CLIPPED END IF
                 CALL cl_prt_pos_wc(tm.wc)
#NO.TQC-631066 end
        END IF
        PRINT g_dash[1,g_len]
        PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        LET l_last_sw = 'y'
    PAGE TRAILER
        IF l_last_sw = 'n' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE
            SKIP 2 LINE
        END IF
END REPORT
