# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcq551.4gl
# Descriptions...: PQC出貨品質狀態查詢
# Date & Author..: 99/05/17 By Iceman
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 報表對齊調整
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-750064 07/06/13 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850047 08/05/13 By lilingyu 改成CR報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
     tm  RECORD
        bdate                   LIKE type_file.dat,        #No.FUN-680104 DATE
        edate                   LIKE type_file.dat         #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            bdate               LIKE type_file.dat,        #No.FUN-680104 DATE          #檢驗日期起
            edate               LIKE type_file.dat,        #No.FUN-680104 DATE          #檢驗日期
            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)      #送貨批號
            qcm22               LIKE qcm_file.qcm22,       #送貨量
            stkqty              LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)       #入庫日期
           #qcm06               DECIMAL(10,3),        #檢驗量     #No.TQC-750064 mark
            crqty               LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)      #不良數 #TQC-5B0034(9,3)->(12,3)
            crrate              LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)     #不量率 #TQC-5B0034(9,3)->(12,3)
            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)        #不合格批數
            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)       #不合格批率
        END RECORD,
    g_state DYNAMIC ARRAY OF RECORD
            sta     LIKE type_file.chr2,        #No.FUN-680104 VARCHAR(2)
            code    LIKE type_file.chr4,        #No.FUN-680104 VARCHAR(4)
            desc    LIKE cob_file.cob08,        #No.FUN-680104 VARCHAR(30)
            lot     LIKE type_file.num10        #No.FUN-680104 INTEGER
        END RECORD,
    g_rec_b         LIKE type_file.num5,        #No.FUN-680104 SMALLINT
    m_cnt           LIKE type_file.num5,        #No.FUN-680104 SMALLINT
    g_sql           STRING,                     #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_dash_1        LIKE type_file.chr1000,     #No.FUN-680104 VARCHAR(132)
    cr,ma,mi        LIKE qcf_file.qcf06         #No.FUN-680104 DEC(12,3)
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE  l_table          STRING                   #NO.FUN-850047
DEFINE  gg_sql          STRING                   #NO.FUN-850047
DEFINE  g_str          STRING                   #NO.FUN-850047
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col          LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
         
#NO.FUN-850047  --Begin--
   LET gg_sql = "dat.type_file.dat,", 
                "dat1.type_file.dat,",
                "lot.tod_file.tod08,", 
                "qcm22.qcm_file.qcm22,", 
                "stkqty.qcf_file.qcf06,", 
                "crqty.qcf_file.qcf06,", 
                "crrate.qcf_file.qcf06,",
                "rejqty.tod_file.tod08,",              
                "rejrate.ima_file.ima18" 
   LET l_table = cl_prt_temptable('aqcq551',gg_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM gg_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1)
      EXIT PROGRAM
   END IF
                 
#NO.FUN-850047  --End--
         
    LET p_row = 5 LET p_col = 3
    OPEN WINDOW q551_w AT p_row,p_col
       WITH FORM "aqc/42f/aqcq551"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q551_q()
#    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q551_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q551_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q551_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
   CLEAR FORM #清除畫面
   CALL g_state.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bdate=TODAY
   LET tm.edate=TODAY
   DISPLAY BY NAME tm.bdate,tm.edate
   INPUT tm.bdate,tm.edate WITHOUT DEFAULTS FROM bdate,edate
           AFTER FIELD bdate
              IF cl_null(tm.bdate) THEN CALL cl_err('','aap-099',0)
                 NEXT FIELD bdate
              END IF
              LET g_qcm.bdate=tm.bdate
           AFTER FIELD edate
              IF cl_null(tm.edate) THEN CALL cl_err('','aap-099',0)
                 NEXT FIELD edate
              END IF
              IF tm.edate<tm.bdate THEN NEXT FIELD edate END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN RETURN END IF
#bugno:6062modify...........................
        LET g_qcm.bdate=tm.bdate
        LET g_qcm.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT count(*) FROM qcm_file ",
             " WHERE qcm14='Y' AND qcm18='2' AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('qcmuser', 'qcmgrup')
   #End:FUN-980030
 
   PREPARE q551_prepare1 FROM g_sql
   DECLARE q551_count CURSOR FOR q551_prepare1
END FUNCTION
 
 
#中文的MENU
FUNCTION q551_menu()
    MENU ""
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q551_q()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                CALL q551_out()
            END IF
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION q551_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q551_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
   #-----------------No.TQC-750064 modify
   #SELECT count(*), sum(qcm06), sum(qcm22), sum(qcm091)
   #         INTO g_qcm.lot, g_qcm.qcm06, g_qcm.qcm22, g_qcm.stkqty
    SELECT count(*), sum(qcm22), sum(qcm091)
             INTO g_qcm.lot, g_qcm.qcm22, g_qcm.stkqty
   #-----------------No.TQC-750064 end
             FROM qcm_file
             WHERE qcm04 BETWEEN tm.bdate AND tm.edate  AND qcm14='Y' AND qcm18='2'
    IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660115
        CALL cl_err3("sel","qcm_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660115
    ELSE
       OPEN q551_count
       FETCH q551_count INTO m_cnt
       DISPLAY m_cnt TO FORMONLY.cnt
        #------- CR
        SELECT SUM(qcn07) INTO cr FROM qcm_file,qcn_file
           WHERE qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='1' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO ma FROM qcm_file,qcn_file
           WHERE qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='2' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO mi FROM qcm_file,qcn_file
           WHERE qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='3' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
        #-------- 不良數總計
       #---------------No.TQC-750064 modify
       #LET g_qcm.crqty=(cr*g_qcz.qcz02/g_qcz.qcz021)+
       #                (ma*g_qcz.qcz03/g_qcz.qcz031)+
       #                (mi*g_qcz.qcz04/g_qcz.qcz041)
        LET g_qcm.crqty=g_qcm.qcm22 - g_qcm.stkqty
       #---------------No.TQC-750064 end
 
        SELECT count(*) INTO g_qcm.rejqty FROM qcm_file
         WHERE qcm09 != '1' AND qcm04 BETWEEN tm.bdate AND tm.edate
           AND qcm14='Y' AND qcm18='2'
       #---------No.TQC-750064 modify
       #IF g_qcm.qcm06 = 0 THEN      # 分母為零, 另作處理
        IF g_qcm.qcm22 = 0 THEN      # 分母為零, 另作處理
       #---------No.TQC-750064 end
           LET g_qcm.crrate = 0
        ELSE
          #------------No.TQC-750064 modify
          #LET g_qcm.crrate = (g_qcm.crqty/g_qcm.qcm06)*100
           LET g_qcm.crrate = (g_qcm.crqty/g_qcm.qcm22)*100
          #------------No.TQC-750064 end
        END IF
        IF g_qcm.lot = 0 THEN       # 分母為零, 另作處理
           LET g_qcm.rejrate = 0
        ELSE
           LET g_qcm.rejrate = g_qcm.rejqty/g_qcm.lot * 100
        END IF
        CALL q551_show()                  # Display result
    END IF
    MESSAGE ''
END FUNCTION
 
 
 
FUNCTION q551_show()
   DISPLAY BY NAME g_qcm.*
   DISPLAY g_qcm.rejrate TO FROMONLY.rejqty
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION q551_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000             #        #No.FUN-680104 VARCHAR(40)
DEFINE     l_dat    LIKE type_file.dat           #NO.FUN-850047    
DEFINE     l_dat1    LIKE type_file.dat           #NO.FUN-850047
 
    CALL cl_wait()
#    CALL cl_outnam('aqcq551') RETURNING l_name    #NO.FUN-850047
     CALL cl_del_data(l_table)                     #NO.FUN-850047
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcq551'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '-' END FOR
 
#NO.FUN-850047   --Begin--
    LET l_dat = tm.bdate
    LET l_dat1 = tm.edate
    EXECUTE insert_prep USING
            l_dat,l_dat1,g_qcm.lot,g_qcm.qcm22,g_qcm.stkqty,
            g_qcm.crqty,g_qcm.crrate,g_qcm.rejqty,g_qcm.rejrate
    LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    
    CALL cl_prt_cs3('aqcq551','aqcq551',gg_sql,'')       
          
#    START REPORT q551_rep TO l_name
 #   OUTPUT TO REPORT q551_rep()
 #   FINISH REPORT q551_rep
 #   ERROR ""
 #   CALL cl_prt(l_name,' ','1',g_len)
 #NO.FUN-850047  --End--
END FUNCTION
 
#NO.FUN-850047 --Begin--
#REPORT q551_rep()
#  OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    FORMAT
#    PAGE HEADER
#            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#            PRINT ' '
#            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#            PRINT g_dash[1,g_len]
#    ON EVERY ROW
#            PRINT COLUMN 4,g_x[17] CLIPPED,tm.bdate,'-',tm.edate
#            PRINT ''
#            PRINT COLUMN  4,g_x[11] CLIPPED, g_qcm.lot, # USING '999999999999',
#                  COLUMN 28,g_x[12] CLIPPED, g_qcm.qcm22, # USING '#####$.$$$',
#                  COLUMN 55,g_x[13] CLIPPED, g_qcm.stkqty # USING '#######$.$'
#            PRINT ""
#           #-------------------------No.TQC-750064 modify
#           #PRINT COLUMN  4,g_x[14] CLIPPED, g_qcm.qcm06, # USING '#######$',
#           #      COLUMN 28,g_x[15] CLIPPED, g_qcm.crqty, # USING '########$',
#           #      COLUMN 55,g_x[16] CLIPPED, g_qcm.crrate # USING '########$'
#            PRINT COLUMN 4,g_x[15] CLIPPED, g_qcm.crqty, # USING '########$',
#                  COLUMN 28,g_x[16] CLIPPED, g_qcm.crrate # USING '########$'
#           #-------------------------No.TQC-750064 end
#            PRINT g_dash_1[1,g_len]
#            PRINT COLUMN 4, g_x[18] CLIPPED, g_qcm.rejqty,
#                  COLUMN 28, g_x[19] CLIPPED, g_qcm.rejrate,'%'
#            PRINT ''
#            PRINT ''
#            PRINT ''
#    ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#END REPORT
 
##Patch....NO.TQC-610036 <001,002,003> #
#NO.FUN-850047 --End--
 
 
 
