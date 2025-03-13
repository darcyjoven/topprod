# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asmp630.4gl
# Descriptions...: 日關帳backgroup作業
# Date & Author..: 06/02/21 FUN-620048 By TSD.miki
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
   tm       RECORD
            sma53   LIKE sma_file.sma53,
            apz57   LIKE apz_file.apz57,
            ooz09   LIKE ooz_file.ooz09,
            nmz10   LIKE nmz_file.nmz10,
            faa09   LIKE faa_file.faa09,
            faa13   LIKE faa_file.faa13,
            m       LIKE type_file.chr1   #No.FUN-690010   VARCHAR(1)
            END RECORD,
   g_aaa    DYNAMIC ARRAY OF RECORD
            aaa01   LIKE aaa_file.aaa01,
            aaa02   LIKE aaa_file.aaa02,
            aaa07   LIKE aaa_file.aaa07
            END RECORD,
   g_rec_b  LIKE type_file.num10, #No.FUN-690010 INTEGER,     #單身筆數
   l_ac     LIKE type_file.num5,      #目前處理的ARRAY CNT   #No.FUN-690010 SMALLINT
   g_cnt    LIKE type_file.num10                                                   #No.FUN-690010 INTEGER
 
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0089
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ASM")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_bgjob  = ARG_VAL(1)
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)  #No.FUN-6A0089
 
    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL p630_tm()
    ELSE
       CALL p630()
    END IF
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (退出時間)  #No.FUN-6A0089
END MAIN
 
FUNCTION p630_tm()
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_cmd         LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
    DEFINE l_flag        LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    LET p_row = 4 LET p_col = 2
    OPEN WINDOW p630_w AT p_row,p_col WITH FORM "asm/42f/asmp630" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
 
    CALL p630_q()
    WHILE TRUE
       LET tm.m = 'N'
      #DISPLAY tm.m TO FORMONLY.m
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
       INPUT BY NAME tm.m WITHOUT DEFAULTS
           AFTER FIELD m
              IF tm.m NOT MATCHES '[YN]' THEN
                 NEXT FIELD m
              END IF
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
           ON ACTION CONTROLG
              CALL cl_cmdask()    # Command execution
#NO.FUN-6B0031--BEGIN                                                                                                               
           ON ACTION CONTROLS                                                                                                          
              CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
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
       END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          EXIT WHILE
       END IF
 
       IF tm.m = 'Y' THEN
          SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
           WHERE zz01='asmp630'
          IF SQLCA.sqlcode OR l_cmd IS NULL THEN
             CALL cl_err('asmp630','9031',1)  
          ELSE
             LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.m  CLIPPED,"'"
             CALL cl_cmdat('asmp630',g_time,l_cmd)  #Execute cmd at later time
          END IF
          CLOSE WINDOW p630_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
 
       IF cl_sure(0,0) THEN
          CALL p630()
          IF g_success='Y' THEN
             CALL p630_q()
             CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
          ELSE
             CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             EXIT WHILE
          END IF
       END IF
    END WHILE
    ERROR ""
    CLOSE WINDOW p630_w
END FUNCTION
 
#查詢資料
FUNCTION p630_q()
    CALL cl_opmsg('q')
    INITIALIZE tm.* TO NULL
    SELECT sma53 INTO tm.sma53 FROM sma_file WHERE sma00='0'
    SELECT apz57 INTO tm.apz57 FROM apz_file WHERE apz00='0'
    SELECT ooz09 INTO tm.ooz09 FROM ooz_file WHERE ooz00='0'
    SELECT nmz10 INTO tm.nmz10 FROM nmz_file WHERE nmz00='0'
    SELECT faa09,faa13 INTO tm.faa09,tm.faa13 FROM faa_file WHERE faa00='0'
    DISPLAY BY NAME tm.*
    CALL p630_b_fill() #單身
    DISPLAY ARRAY g_aaa TO s_aaa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
       BEFORE DISPLAY
       EXIT DISPLAY
 
       #NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
       #NO.FUN-6B0031--END
 
       #MOD-860081------add-----str---
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION controlg      
           CALL cl_cmdask()     
        
        ON ACTION help          
           CALL cl_show_help()  
        #MOD-860081------add-----end---
 
    END DISPLAY
END FUNCTION
 
FUNCTION p630_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(1000)
 
    LET l_sql = "SELECT aaa01,aaa02,aaa07 FROM aaa_file ORDER BY aaa01"
    PREPARE p630_pb FROM l_sql
    DECLARE p630_bcs CURSOR WITH HOLD FOR p630_pb    #BODY CURSOR
 
    CALL g_aaa.CLEAR()               #單身 ARRAY 乾洗
 
    LET g_cnt = 1
    FOREACH p630_bcs INTO g_aaa[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('', 9035, 0 )
	  EXIT FOREACH
       END IF
    END FOREACH
    CALL g_aaa.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
END FUNCTION
 
FUNCTION p630()
    DEFINE l_smp   RECORD LIKE smp_file.*
    DEFINE l_smq   RECORD LIKE smq_file.*
    DEFINE l_date  LIKE type_file.dat     #No.FUN-690010 DATE
 
    LET g_success = 'Y'
    BEGIN WORK
    SELECT * INTO l_smp.* FROM smp_file WHERE smp00=0
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('sel smp: ',SQLCA.SQLCODE,1)   #No.FUN-660138
       CALL cl_err3("sel","smp_file","","",SQLCA.sqlcode,"","sel smp:",1) #No.FUN-660138
       LET g_success = 'N'
    ELSE
       IF l_smp.smp01 = 'Y' THEN    #庫存日關帳
          LET l_date = g_today - l_smp.smp011
          UPDATE sma_file SET sma53 = l_date WHERE sma00='0'
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd sma: ',SQLCA.SQLCODE,1)   #No.FUN-660138
             CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","upd sma:",1) #No.FUN-660138
             LET g_success = 'N'
          END IF
       END IF
       IF l_smp.smp02 = 'Y' THEN    #應付日關帳
          LET l_date = g_today - l_smp.smp021
          UPDATE apz_file SET apz57 = l_date WHERE apz00='0'
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd apz: ',SQLCA.SQLCODE,1)   #No.FUN-660138
             CALL cl_err3("upd","apz_file","","",SQLCA.sqlcode,"","upd apz:",1) #No.FUN-660138
             LET g_success = 'N'
          END IF
       END IF
       IF l_smp.smp03 = 'Y' THEN    #應收日關帳
          LET l_date = g_today - l_smp.smp031
          UPDATE ooz_file SET ooz09 = l_date WHERE ooz00='0'
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd ooz: ',SQLCA.SQLCODE,1)   #No.FUN-660138
             CALL cl_err3("upd","ooz_file","","",SQLCA.sqlcode,"","upd ozz:",1) #No.FUN-660138
             LET g_success = 'N'
          END IF
       END IF
       IF l_smp.smp04 = 'Y' THEN    #票據日關帳
          LET l_date = g_today - l_smp.smp041
          UPDATE nmz_file SET nmz10 = l_date WHERE nmz00='0'
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd nmz: ',SQLCA.SQLCODE,1)   #No.FUN-660138
             CALL cl_err3("upd","nmz_file","","",SQLCA.sqlcode,"","upd nmz:",1) #No.FUN-660138
             LET g_success = 'N'
          END IF
       END IF
       IF l_smp.smp05 = 'Y' THEN    #固資財簽日關帳
          LET l_date = g_today - l_smp.smp051
          UPDATE faa_file SET faa09 = l_date WHERE faa00='0'
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd faa: ',SQLCA.SQLCODE,1)   #No.FUN-660138
             CALL cl_err3("upd","faa_file","","",SQLCA.sqlcode,"","upd faa:",1) #No.FUN-660138
             LET g_success = 'N'
          END IF
       END IF
       IF l_smp.smp06 = 'Y' THEN    #固資稅簽日關帳
          LET l_date = g_today - l_smp.smp061
          UPDATE faa_file SET faa13 = l_date WHERE faa00='0'
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err('upd faa: ',SQLCA.SQLCODE,1)   #No.FUN-660138
             CALL cl_err3("upd","faa_file","","",SQLCA.sqlcode,"","upd faa:",1) #No.FUN-660138
             LET g_success = 'N'
          END IF
       END IF
       IF l_smp.smp07 = 'Y' THEN    #總帳日關帳
          DECLARE smq_cs CURSOR FOR
             SELECT * FROM smq_file
          FOREACH smq_cs INTO l_smq.*
             IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)   
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_date = g_today - l_smq.smq03
             UPDATE aaa_file SET aaa07 = l_date WHERE aaa01=l_smq.smq01
             IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#               CALL cl_err('upd aaa: ',SQLCA.SQLCODE,1)   #No.FUN-660138
                CALL cl_err3("upd","aaa_file",l_smq.smq01,"",SQLCA.sqlcode,"","upd aaa:",1) #No.FUN-660138
                LET g_success = 'N'
             END IF
          END FOREACH
       END IF
    END IF
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION
 
