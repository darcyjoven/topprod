# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asdp140.4gl
# Descriptions...: 產銷量值統計作業
# Date & Author..: 98/10/21 By Eric
# Modify.........: No:9762 04/07/19 Carol 1.增加處理完時能show訊息,不要直接跳出
#                                         2.修改SQL
# Modify.........: No.FUN-4C0026 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify ........: No.FUN-570150 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-660120 06/06/16 By CZH cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By zdyllq 類型轉換   
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2) 

DATABASE ds
 
GLOBALS "../../config/top.global"
    DEFINE l_last_sw  LIKE type_file.chr1,         #No.FUN-690010 VARCHAR(1),
          g_stg RECORD LIKE stg_file.*,
          g_stf RECORD LIKE stf_file.*,
          g_stm RECORD LIKE stm_file.*,
          g_stn RECORD LIKE stn_file.*,
          g_stk RECORD LIKE stk_file.*,
          g_stk1 RECORD LIKE stk1_file.*,
          g_stl RECORD LIKE stl_file.*
   DEFINE tm  RECORD                # Print condition RECORD
              wc      LIKE type_file.chr1000,      #No.FUN-690010CHAR(400),    # Where condition
              bdate   LIKE type_file.dat,          #No.FUN-690010DATE,
              edate   LIKE type_file.dat,          #No.FUN-690010DATE,
              yea     LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              mo      LIKE type_file.num5,         #No.FUN-690010SMALLINT,
              #TQC-840066---str---
              a1      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4), 
              a2      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a3      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a4      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a5      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a6      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a7      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a8      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a9      LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              a10     LIKE oga_file.oga25,         #No.FUN-690010CHAR(4),
              #TQC-840066---end---
              more    LIKE type_file.chr1          #No.FUN-690010CHAR(1)         # Input more condition(Y/N)
              END RECORD,
          g_dash0       LIKE type_file.chr1000       #No.FUN-690010CHAR(300)               # Dash line
DEFINE g_flag           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE g_change_lang    LIKE type_file.chr1          # Prog. Version..: '5.30.06-13.03.12(01)            #No.FUN-570150
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
#NO.FUN-570150 start--
   INITIALIZE g_bgjob_msgfile TO NULL  #No.FUN-570150
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
#NO.FUN-570150 end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  # If background job sw is off
      CALL asdp140_tm(4,15)                   # Input print condition
   ELSE
      CALL asdp140()                          # Read data and create out-file
   END IF

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION asdp140_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
            l_cmd         LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
   LET p_row = 3 LET p_col = 30
  

   OPEN WINDOW asdp140_w AT p_row,p_col WITH FORM "asd/42f/asdp140"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.yea  = YEAR(g_today)
   LET tm.mo   = MONTH(g_today)
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.edate=MDY(tm.mo,1,tm.yea)-1
   LET tm.bdate=MDY(MONTH(tm.edate),1,YEAR(tm.edate))
   LET tm.yea  = YEAR(tm.bdate)
   LET tm.mo   = MONTH(tm.bdate)
 
   WHILE TRUE
      #INPUT BY NAME tm.yea,tm.mo,tm.a1, tm.a2, tm.a3, tm.a4, tm.a5, tm.a6, tm.a7, tm.a8, tm.a9, tm.a10
      INPUT BY NAME tm.yea,tm.mo,tm.a1, tm.a2, tm.a3, tm.a4, tm.a5, tm.a6, tm.a7, tm.a8, tm.a9, tm.a10,
                    g_bgjob  #NO.FUN-570150
         WITHOUT DEFAULTS
 
         AFTER FIELD yea
            IF tm.yea IS NULL OR tm.yea=0 THEN
               NEXT FIELD yea
            END IF
 
         AFTER FIELD mo
            IF tm.mo IS NULL OR tm.mo=0 THEN
               NEXT FIELD mo
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION locale                    #genero
#NO.FUN-570150 mark
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570150 mark
            LET g_change_lang = TRUE                 #NO.FUN-570150 
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
#NO.FUN-570150 start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
#      IF g_action_choice = "locale" THEN  #genero
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#         CONTINUE WHILE
#      END IF
#NO.FUN-570150 end---
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW asdp140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='asdp140'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asdp140','9031',1)   
            
         ELSE
            LET l_cmd = l_cmd CLIPPED,      #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            " '",g_lang CLIPPED,"'",
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('asdp140',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW asdp140_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF cl_sure(20,20) THEN
         CALL cl_wait()
         CALL asdp140()
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
         END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            #No.FUN-570150--start------
            IF g_bgjob = 'Y' THEN
               CALL cl_batch_bg_javamail(g_success)    #No.FUN-570150
            END IF
            #No.FUN-570150--end--------
            EXIT WHILE
         END IF
      END IF
      ERROR ""
   END WHILE
   CLOSE WINDOW asdp140_w
  
END FUNCTION
 
FUNCTION strtran( wstr ,wfstr,wrepl )
  DEFINE wstr   LIKE type_file.chr1000       #No.FUN-690010char(1000)
  DEFINE wfstr  LIKE cre_file.cre08          #No.FUN-690010char(10)
  DEFINE wrepl  LIKE cre_file.cre08          #No.FUN-690010char(10)
  DEFINE mstr   LIKE cre_file.cre08          #No.FUN-690010char(10)
  DEFINE nu     LIKE type_file.num10         #No.FUN-690010integer
  DEFINE nu1    LIKE type_file.num10         #No.FUN-690010integer
 
#display 'wstr:',wstr   #CHI-A70049 mark
  LET nu1= length(wfstr)
  FOR nu = 1 TO ( 1000 - nu1 + 1 )
     LET mstr = wstr[nu,nu+nu1 - 1 ] CLIPPED
     IF mstr  = '   ' THEN EXIT FOR  END IF
     IF wfstr = mstr  THEN
        IF nu = 1 THEN
           LET wstr = wrepl CLIPPED, wstr[nu+nu1,1000] CLIPPED
        ELSE
           LET wstr = wstr[1, nu-1], wrepl CLIPPED, wstr[nu+nu1,1000] CLIPPED
        END IF
     END IF
  END FOR
#display 'wstr:',wstr   #CHI-A70049 mark
  RETURN wstr
 
END FUNCTION
 
FUNCTION asdp140()
   DEFINE l_name    LIKE type_file.chr20,        # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0089
          l_sql     LIKE type_file.chr1000,      # RDSQL STATEMENT  #No.FUN-690010 VARCHAR(1000)
          l_sfb05   LIKE sfb_file.sfb05,
          l_oga08   LIKE type_file.chr1,          #No.FUN-690010CHAR(01),
          l_ima06   LIKE ima_file.ima06,
          l_oha09   LIKE oha_file.oha09,
          l_up      LIKE alb_file.alb06,         #No.FUN-690010DEC(20,6), #FUN-4C0026
          l_cnt     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          ss RECORD ima09  LIKE ima_file.ima09,
                    ima131 LIKE ima_file.ima131,
                    oga01 LIKE oga_file.oga01,
                    oga24 LIKE oga_file.oga24,
                    oga25 LIKE oga_file.oga25,
                    ogb04 LIKE ogb_file.ogb04,
                    ogb12 LIKE ogb_file.ogb12,
                    ogb14 LIKE ogb_file.ogb14
                           END RECORD,
          sr RECORD ima09  LIKE ima_file.ima09,
                    ima131 LIKE ima_file.ima131,
                    part   LIKE type_file.chr20,        #No.FUN-690010CHAR(20),
                    qty    LIKE ccq_file.ccq03,       #No.FUN-690010DEC(13,2),
                    amt    LIKE ccq_file.ccq03,       #No.FUN-690010DEC(13,2),
                    ma     LIKE ccq_file.ccq03,       #No.FUN-690010DEC(13,2),
                    la     LIKE ccq_file.ccq03,       #No.FUN-690010DEC(13,2),
                    oh     LIKE ccq_file.ccq03,       #No.FUN-690010DEC(13,2),
                    ooh    LIKE ccq_file.ccq03        #No.FUN-690010DEC(13,2)
                           END RECORD
       CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0089
     LET g_success='Y'
     BEGIN WORK
     DELETE FROM stk_file WHERE stk01=tm.yea AND stk02=tm.mo
     DELETE FROM stk1_file WHERE stk01=tm.yea AND stk02=tm.mo
     DELETE FROM stl_file WHERE stl01=tm.yea AND stl02=tm.mo
     DELETE FROM stm_file WHERE stm01=tm.yea AND stm02=tm.mo
     DELETE FROM stn_file WHERE stn01=tm.yea AND stn02=tm.mo
 
#No:9762 modify........................................
     IF cl_null(g_bgjob) OR g_bgjob='N' THEN
        LET l_cnt = 0
        LET tm.wc = ''
        IF NOT cl_null(tm.a1) THEN
           LET tm.wc = tm.wc  CLIPPED ,"'",  tm.a1 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a2) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a2 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a3) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a3 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a4) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a4 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a5) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a5 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a6) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a6 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a7) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a7 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a8) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a8 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a9) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'", tm.a9 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF NOT cl_null(tm.a10) THEN
           IF l_cnt > 0 THEN
              LET tm.wc = tm.wc CLIPPED,"," CLIPPED
           END IF
           LET  tm.wc = tm.wc CLIPPED ,"'",tm.a10 CLIPPED ,"'"
           LET l_cnt = l_cnt + 1
        END IF
        IF l_cnt > 0 THEN
           LET tm.wc =" oga25 NOT IN (",tm.wc CLIPPED,")"
        ELSE
           LET tm.wc = " 1=1 "
        END IF
      END IF
 
      LET tm.bdate=MDY(tm.mo,1,tm.yea)
      IF tm.mo=12 THEN
         LET tm.edate=MDY(1,1,tm.yea+1)
      ELSE
         LET tm.edate=MDY(tm.mo+1,1,tm.yea)-1
      END IF
      LET g_stk.stk01=tm.yea
      LET g_stk.stk02=tm.mo
      LET g_stl.stl01=tm.yea
      LET g_stl.stl02=tm.mo
      LET g_stk1.stk01=tm.yea
      LET g_stk1.stk02=tm.mo
 
#No:9762(end)
 
      LET g_stk.stkplant  = g_plant #FUN-980008 add
      LET g_stk.stklegal  = g_legal #FUN-980008 add
      LET g_stl.stlplant  = g_plant #FUN-980008 add
      LET g_stl.stllegal  = g_legal #FUN-980008 add
      LET g_stk1.stk1plant = g_plant #FUN-980008 add
      LET g_stk1.stk1legal = g_legal #FUN-980008 add
 
       LET l_sql = "SELECT ima09,ima131,oga01,oga24,oga25,ogb04,",
                   " ogb12,ogb14,oga08,ima06",
                   "  FROM oga_file,ogb_file,ima_file,imd_file ",
                   " WHERE ogapost = 'Y' AND ogaconf='Y' AND oga09 IN ('2','8') ",  #No.FUN-610020
                   "   AND oga65 ='N' ",  #No.FUN-610020
                     " AND ogb04 = ima01 ",
                     " AND oga01 = ogb01 ",
                     " AND oga02 >='",tm.bdate,"'",
                     " AND oga02 <='",tm.edate,"'",
                     " AND ogb09 = imd01 AND imd09='Y' ",
                     " AND ",tm.wc CLIPPED
#display 'l_sql:',l_sql   #CHI-A70049 mark
     PREPARE asdp140_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        LET g_success='N'
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE asdp140_curs1 CURSOR FOR asdp140_prepare1
     FOREACH asdp140_curs1 INTO ss.*,l_oga08,l_ima06
         IF SQLCA.sqlcode != 0 THEN
            LET g_success='N'
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF l_oga08 IS NULL OR l_oga08 = ' ' THEN LET l_oga08='1' END IF
         IF ss.ima09 IS NULL THEN LET ss.ima09=' ' END IF
         IF ss.ima131 IS NULL THEN LET ss.ima131=' ' END IF
         IF ss.oga24 IS NULL OR ss.oga24<=0 THEN
            LET ss.oga24=1
         END IF
         SELECT stb07+stb08+stb09+stb09a INTO l_up FROM stb_file
          WHERE stb01 = ss.ogb04 AND stb02 = tm.yea AND stb03 = tm.mo
         IF STATUS <> 0 THEN LET l_up=0 END IF
         LET g_stk.stk03=ss.ima09
         LET g_stk.stk04=ss.ogb12
         LET g_stk.stk05=ss.oga24*ss.ogb14
         LET g_stk.stk06=g_stk.stk04*l_up
         LET g_stk.stk07=0
         LET g_stk.stk08=0
         LET g_stk.stk09=0
         SELECT * FROM stk_file
          WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk.stk03
         IF STATUS <> 0 THEN
            INSERT INTO stk_file VALUES(g_stk.*)
         ELSE
            UPDATE stk_file
               SET stk04=stk04+g_stk.stk04, stk05=stk05+g_stk.stk05,
                   stk06=stk06+g_stk.stk06
             WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk.stk03
            IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stk_file",tm.yea,tm.mo,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
            END IF
         END IF
# 99/09/17 Eric Add
         LET g_stk1.stk03=ss.ima09
         LET g_stk1.stk031=l_oga08
         LET g_stk1.stk04=ss.ogb12
         LET g_stk1.stk05=ss.oga24*ss.ogb14
         LET g_stk1.stk06=g_stk1.stk04*l_up
         LET g_stk1.stk07=0
         LET g_stk1.stk08=0
         LET g_stk1.stk09=0
         SELECT * FROM stk1_file
          WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk1.stk03
            AND stk031=l_oga08
         IF STATUS <> 0 THEN
            INSERT INTO stk1_file VALUES(g_stk1.*)
         ELSE
            UPDATE stk1_file
               SET stk04=stk04+g_stk1.stk04, stk05=stk05+g_stk1.stk05,
                   stk06=stk06+g_stk1.stk06
             WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk1.stk03
               AND stk031=l_oga08
            IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stk1_file",tm.yea,tm.mo,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
            END IF
         END IF
         LET g_stl.stl03=ss.ima131
         LET g_stl.stl04=ss.ogb12
         LET g_stl.stl05=ss.oga24*ss.ogb14
         LET g_stl.stl06=g_stl.stl04*l_up
         LET g_stl.stl07=0
         LET g_stl.stl08=0
         LET g_stl.stl09=0
         SELECT * FROM stl_file
          WHERE stl01=tm.yea AND stl02=tm.mo AND stl03=g_stl.stl03
         IF STATUS <> 0 THEN
            INSERT INTO stl_file VALUES(g_stl.*)
         ELSE
            UPDATE stl_file
               SET stl04=stl04+g_stl.stl04, stl05=stl05+g_stl.stl05,
                   stl06=stl06+g_stl.stl06
             WHERE stl01=tm.yea AND stl02=tm.mo AND stl03=g_stl.stl03
            IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stl_file",tm.yea,tm.mo,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
            END IF
         END IF
     END FOREACH
        #-->處理銷退
       LET tm.wc = strtran ( tm.wc , 'oga' , 'oha' )
       LET l_sql = "SELECT ima09,ima131,oha01,oha24,oha25,ohb04,",
                   " ohb12,ohb14,oha08,ima06,oha09",
                   "  FROM oha_file,ohb_file,ima_file,imd_file ",
                   " WHERE ohapost = 'Y' AND ohaconf='Y'",
                     " AND ohb04 = ima01 ",
                     " AND oha01 = ohb01 ",
                     " AND oha02 >='",tm.bdate,"'",
                     " AND oha02 <='",tm.edate,"'" ,
                     " AND ohb09 = imd01 AND imd09='Y' ",
                     " AND ",tm.wc CLIPPED
       PREPARE asdp140_prepare3 FROM l_sql
       IF SQLCA.sqlcode != 0 THEN
          LET g_success='N'
          CALL cl_err('prepare:',SQLCA.sqlcode,1)
          RETURN
       END IF
     DECLARE asdp140_curs2 CURSOR FOR asdp140_prepare3
     FOREACH asdp140_curs2 INTO ss.*,l_oga08,l_ima06,l_oha09
         IF SQLCA.sqlcode != 0 THEN
            LET g_success='N'
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF l_oga08 IS NULL OR l_oga08 = ' ' THEN LET l_oga08='1' END IF
         IF ss.ima09 IS NULL THEN LET ss.ima09=' ' END IF
         IF ss.ima131 IS NULL THEN LET ss.ima131=' ' END IF
         IF ss.oga24 IS NULL OR ss.oga24<=0 THEN
            LET ss.oga24=1
         END IF
         SELECT stb07+stb08+stb09+stb09a INTO l_up FROM stb_file
          WHERE stb01 = ss.ogb04 AND stb02 = tm.yea AND stb03 = tm.mo
         IF STATUS <> 0 THEN LET l_up=0 END IF
         LET g_stk.stk03=ss.ima09
         IF l_oha09='1' OR l_oha09='3' THEN
            LET g_stk.stk07=ss.ogb12
            LET g_stk.stk08=ss.oga24*ss.ogb14
            LET g_stk.stk09=g_stk.stk07*l_up
            LET g_stk.stk04=0
            LET g_stk.stk05=0
            LET g_stk.stk06=0
         ELSE
            LET g_stk.stk04=ss.ogb12*-1
            LET g_stk.stk05=ss.oga24*ss.ogb14*-1
            LET g_stk.stk06=g_stk.stk04*l_up
            LET g_stk.stk07=0
            LET g_stk.stk08=0
            LET g_stk.stk09=0
         END IF
         SELECT * FROM stk_file
          WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk.stk03
         IF STATUS <> 0 THEN
            INSERT INTO stk_file VALUES(g_stk.*)
         ELSE
            UPDATE stk_file
               SET stk04=stk04+g_stk.stk04, stk05=stk05+g_stk.stk05,
                   stk06=stk06+g_stk.stk06,
                   stk07=stk07+g_stk.stk07, stk08=stk08+g_stk.stk08,
                   stk09=stk09+g_stk.stk09
             WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk.stk03
             IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stk_file",tm.yea,tm.mo,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
             END IF
         END IF
         LET g_stk1.stk03=ss.ima09
         LET g_stk1.stk031=l_oga08
         IF l_oha09='1' THEN
            LET g_stk1.stk07=ss.ogb12
            LET g_stk1.stk08=ss.oga24*ss.ogb14
            LET g_stk1.stk09=g_stk1.stk07*l_up
            LET g_stk1.stk04=0
            LET g_stk1.stk05=0
            LET g_stk1.stk06=0
         ELSE
            LET g_stk1.stk04=ss.ogb12*-1
            LET g_stk1.stk05=ss.oga24*ss.ogb14*-1
            LET g_stk1.stk06=g_stk1.stk04*l_up
            LET g_stk1.stk07=0
            LET g_stk1.stk08=0
            LET g_stk1.stk09=0
         END IF
         SELECT * FROM stk1_file
          WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk1.stk03
            AND stk031=l_oga08
         IF STATUS <> 0 THEN
            INSERT INTO stk1_file VALUES(g_stk1.*)
         ELSE
            UPDATE stk1_file
               SET stk04=stk04+g_stk1.stk04, stk05=stk05+g_stk1.stk05,
                   stk06=stk06+g_stk1.stk06,
                   stk07=stk07+g_stk1.stk07, stk08=stk08+g_stk1.stk08,
                   stk09=stk09+g_stk1.stk09
             WHERE stk01=tm.yea AND stk02=tm.mo AND stk03=g_stk1.stk03
               AND stk031=l_oga08
             IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stk1_file",tm.yea,tm.mo,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
             END IF
         END IF
         LET g_stl.stl03=ss.ima131
         IF l_oha09='1' THEN
            LET g_stl.stl07=ss.ogb12
            LET g_stl.stl08=ss.oga24*ss.ogb14
            LET g_stl.stl09=g_stl.stl07*l_up
            LET g_stl.stl04=0
            LET g_stl.stl05=0
            LET g_stl.stl06=0
         ELSE
            LET g_stl.stl04=ss.ogb12*-1
            LET g_stl.stl05=ss.oga24*ss.ogb14*-1
            LET g_stl.stl06=g_stl.stl04*l_up
            LET g_stl.stl07=0
            LET g_stl.stl08=0
            LET g_stl.stl09=0
         END IF
         SELECT * FROM stl_file
          WHERE stl01=tm.yea AND stl02=tm.mo AND stl03=g_stl.stl03
         IF STATUS <> 0 THEN
            INSERT INTO stl_file VALUES(g_stl.*)
         ELSE
            UPDATE stl_file
               SET stl04=stl04+g_stl.stl04, stl05=stl05+g_stl.stl05,
                   stl06=stl06+g_stl.stl06,
                   stl07=stl07+g_stl.stl07, stl08=stl08+g_stl.stl08,
                   stl09=stl09+g_stl.stl09
             WHERE stl01=tm.yea AND stl02=tm.mo AND stl03=g_stl.stl03
             IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stl_file",tm.yea,tm.mo,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
             END IF
         END IF
     END FOREACH
     LET g_stm.stm01=tm.yea
     LET g_stm.stm02=tm.mo
     LET g_stn.stn01=tm.yea
     LET g_stn.stn02=tm.mo
     LET g_stm.stmplant = g_plant #FUN-980008 add
     LET g_stm.stmlegal = g_legal #FUN-980008 add
     LET g_stn.stnplant = g_plant #FUN-980008 add
     LET g_stn.stnlegal = g_legal #FUN-980008 add
 
# 統計生產量值
# 99/09/06 僅需成品
     DECLARE asdp140_curs3 CURSOR FOR
      SELECT stg_file.* FROM stg_file ,sfb_file,ima_file
       WHERE stg02=tm.yea AND stg03=tm.mo
         AND stg04=sfb01 AND sfb05=ima01
     FOREACH asdp140_curs3 INTO g_stg.*
         IF SQLCA.sqlcode != 0 THEN
            LET g_success='N'
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            
            EXIT FOREACH
         END IF
         SELECT ima09,ima131,sfb05 INTO g_stm.stm03,g_stn.stn03,l_sfb05
           FROM ima_file,sfb_file
          WHERE sfb01=g_stg.stg04 AND sfb05=ima01
         IF STATUS <> 0 THEN CONTINUE FOREACH END IF
         IF g_stm.stm03 IS NULL THEN LET g_stm.stm03=' ' END IF
         IF g_stn.stn03 IS NULL THEN LET g_stn.stn03=' ' END IF
         SELECT stb07+stb08+stb09+stb09a INTO l_up FROM stb_file
          WHERE stb01 = l_sfb05 AND stb02 = tm.yea AND stb03 = tm.mo
         IF STATUS <> 0 THEN LET l_up=0 END IF
         LET g_stm.stm04=g_stg.stg07
         LET g_stm.stm05=g_stm.stm04*l_up
         LET g_stm.stm06=g_stm.stm04
         LET g_stm.stm07=g_stm.stm05
         SELECT * FROM stm_file
          WHERE stm01=g_stm.stm01 AND stm02=g_stm.stm02
            AND stm03=g_stm.stm03
         IF STATUS <> 0 THEN
            INSERT INTO stm_file VALUES(g_stm.*)
         ELSE
            UPDATE stm_file
               SET stm04=stm04+g_stm.stm04, stm05=stm05+g_stm.stm05,
                   stm06=stm06+g_stm.stm06, stm07=stm07+g_stm.stm07
             WHERE stm01=g_stm.stm01 AND stm02=g_stm.stm02
               AND stm03=g_stm.stm03
             IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stm_file",g_stm.stm01,g_stm.stm02,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
             END IF
         END IF
         LET g_stn.stn04=g_stg.stg07
         LET g_stn.stn05=g_stn.stn04*l_up
         LET g_stn.stn06=g_stn.stn04
         LET g_stn.stn07=g_stn.stn05
         SELECT * FROM stn_file
          WHERE stn01=g_stn.stn01 AND stn02=g_stn.stn02
            AND stn03=g_stn.stn03
         IF STATUS <> 0 THEN
            INSERT INTO stn_file VALUES(g_stn.*)
         ELSE
            UPDATE stn_file
               SET stn04=stn04+g_stn.stn04, stn05=stn05+g_stn.stn05,
                   stn06=stn06+g_stn.stn06, stn07=stn07+g_stn.stn07
             WHERE stn01=g_stn.stn01 AND stn02=g_stn.stn02
               AND stn03=g_stn.stn03
             IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stn_file",g_stn.stn01,g_stn.stn02,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
            END IF
         END IF
     END FOREACH
# 扣除重工金額
     DECLARE asdp140_curs4 CURSOR FOR
      SELECT stf_file.* FROM stf_file , ima_file
       WHERE stf02=tm.yea AND stf03=tm.mo AND stf07=ima01
     FOREACH asdp140_curs4 INTO g_stf.*
         IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1) 
            EXIT FOREACH
         END IF
         SELECT ima09,ima131 INTO g_stm.stm03,g_stn.stn03
           FROM ima_file WHERE g_stf.stf07=ima01
         IF STATUS <> 0 THEN CONTINUE FOREACH END IF
         IF g_stm.stm03 IS NULL THEN LET g_stm.stm03=' ' END IF
         IF g_stn.stn03 IS NULL THEN LET g_stn.stn03=' ' END IF
         LET g_stm.stm04=0
         LET g_stm.stm05=0
         LET g_stm.stm06=g_stf.stf08*-1
         LET g_stm.stm07=g_stf.stf10*-1
         SELECT * FROM stm_file
          WHERE stm01=g_stm.stm01 AND stm02=g_stm.stm02
            AND stm03=g_stm.stm03
         IF STATUS <> 0 THEN
            INSERT INTO stm_file VALUES(g_stm.*)
            IF STATUS <> 0 THEN
               LET g_success='N'
#              CALL cl_err('insert:',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("ins","stm_file",g_stm.stm01,g_stm.stm02,SQLCA.sqlcode,"","insert:",1)   #No.FUN-660120
            END IF
         ELSE
            UPDATE stm_file
               SET stm06=stm06+g_stm.stm06, stm07=stm07+g_stm.stm07
             WHERE stm01=g_stm.stm01 AND stm02=g_stm.stm02
               AND stm03=g_stm.stm03
            IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stm_file",g_stm.stm01,g_stm.stm02,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
            END IF
         END IF
         LET g_stn.stn04=0
         LET g_stn.stn05=0
         LET g_stn.stn06=g_stf.stf08*-1
         LET g_stn.stn07=g_stf.stf10*-1
         SELECT * FROM stn_file
          WHERE stn01=g_stn.stn01 AND stn02=g_stn.stn02
            AND stn03=g_stn.stn03
         IF STATUS <> 0 THEN
            INSERT INTO stn_file VALUES(g_stn.*)
            IF STATUS <> 0 THEN
               LET g_success='N'
#              CALL cl_err('insert:',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("ins","stn_file",g_stn.stn01,g_stn.stn02,SQLCA.sqlcode,"","insert:",1)   #No.FUN-660120
               EXIT FOREACH
            END IF
         ELSE
            UPDATE stn_file
               SET stn06=stn06+g_stn.stn06, stn07=stn07+g_stn.stn07
             WHERE stn01=g_stn.stn01 AND stn02=g_stn.stn02
               AND stn03=g_stn.stn03
            IF STATUS <> 0 OR SQLCA.SQLERRD[3]=0 THEN
               LET g_success='N'
#              CALL cl_err('update',SQLCA.sqlcode,1)   #No.FUN-660120
               CALL cl_err3("upd","stn_file",g_stn.stn01,g_stn.stn02,SQLCA.sqlcode,"","update",1)   #No.FUN-660120
               EXIT FOREACH
            END IF
         END IF
     END FOREACH
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
