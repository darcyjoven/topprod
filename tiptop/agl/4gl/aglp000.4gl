# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: aglp000.4gl
# Descriptions...: 合併個體科餘匯入作業
# Input parameter: 
# Modify.......... No.FUN-A90027 10/09/13 BY yiting 
# Modify.........: NO.TQC-AA0098 10/10/16 yiting 畫面qbe改為axz01
# Modify.........: NO.FUN-AA0098 10/11/04 BY yiting 取axq_file為資料時，異動碼axq13亦不可為空字串
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN  
# Modify.........: No.MOD-B30236 11/03/12 By lutingting db后不跟:,改為.
# Modify.........: No.MOD-B30441 11/03/14 By huangrh aeklegal
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-B70099 11/07/12 BY Dido 訊息說明調整 
# Modify.........: No.TQC-B70117 11/07/13 By guoch 修改g_aed循環中報錯信息
# Modify.........: No.MOD-B70230 11/07/22 By Sarah 抓aeh_file的SQL,增加過濾aeh31,aeh32,aeh33,aeh34其中一者有值時才抓
# Modify.........: No.FUN-B70103 11/08/19 By zhangweib 將aed02和axq13轉換成aal03
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: NO.FUN-B90093 11/10/14 By belle 判斷aaz130是否為'2'，如果是則將axq_file 本期(axq08,axq09) 減掉上期 (axq08,axq09)(追單)
# Modify.........: No.MOD-BA0104 11/10/17 By Polly 抓無前期金額，l_axq08、l_axq09若是空值應給預設值0
# Modify.........: No.MOD-BB0138 11/11/15 By Polly PREPARE p000_axq_p3 取消 GROUP BY axq14,axq15,axq16,axq17此段
# Modify.........: No:MOD-BB0291 11/11/24 By Sarah 修正FUN-B90093,關系人欄位有值的時後,SQL裡應增加過濾axq13
# Modify.........: No:TQC-BB0218 11/11/25 By Sarah 延續MOD-BB0291,寫入aej_file的那一段應判斷同一科目處理過就不再處理
# Modify.........: No.FUN-BA0111 12/04/17 By Belle 將總帳的異動碼科餘1~4碼納入合併資料
# Modify.........: No.MOD-D10196 13/01/22 By Belle aglp000增加綜合損益IS科目(tat05)排除
# Modify.........: NO.FUN-CA0085 13/02/23 By apo 科目轉換提供二種入口(agli001/agli020)
# Modify.........: NO.CHI-D20029 13/03/18 By apo 1.因年結時並無針對aaa14~aaa16處理aeh_file(此三個科目不會做異動碼管理)，所以會造成取GL的科餘時
#                                                  此三個科目會取不到值，因此取得aed_file時比對是否和來源的個體公司agli101設定的aaa14~aaa16相同
#                                                  如果科目符合時，此三個科目皆回頭取aah_file即可
#                                                2.取合併科目時需依照axz10的設定來決定取axe_file or ayf_file 
# Modify.........: No.FUN-D20047 13/03/20 By Lori 取科目對應檔ayf_file時，先依目前的年度+期別抓取，如果抓不到則取最靠近的年度+期別
# Modify.........: No.FUN-D20046 13/03/21 By Lori 捲算成功後回寫至agli002現行年度(axa10/axb14),現行期別(axa11/axb15)
# Modify.........: No.FUN-D40019 13/04/08 By Lori aap-021改agl1067

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm      RECORD   
               yy        LIKE type_file.num5,   #匯入會計年度   #FUN-A90027
               bm        LIKE type_file.num5,   #起始期間     
               em        LIKE type_file.num5,   #截止期間    
               axa01     LIKE axa_file.axa01    #族群代號
               END RECORD,
       tm1     RECORD
               wc     LIKE type_file.chr1000
               END RECORD,
       x_aaa03    LIKE aaa_file.aaa03,             #上層公司記帳幣別
       g_aaa04    LIKE aaa_file.aaa04,             #現行會計年度
       g_aaa05    LIKE aaa_file.aaa05,             #現行期別
       g_aaa07    LIKE aaa_file.aaa07,             #關帳日期
       g_bdate    LIKE type_file.dat,              #期間起始日期 
       g_edate    LIKE type_file.dat,              #期間起始日期 
       g_dbs_gl   LIKE type_file.chr21,                          
       g_bookno   LIKE aea_file.aea00,             #帳別
       ls_date         STRING,                    
       l_flag          LIKE type_file.chr1,      
       g_change_lang   LIKE type_file.chr1,     
       g_rate     LIKE type_file.num20_6,  
       g_aac      RECORD LIKE aac_file.*,
       g_i        LIKE type_file.num5,    
       g_amt      LIKE axg_file.axg08,   
       g_affil    LIKE axj_file.axj05,             
       g_dc       LIKE axj_file.axj06,            
       g_flag_r   LIKE type_file.chr1,           
       g_yy       LIKE type_file.num5,          
       g_mm       LIKE type_file.num5,         
       g_em       LIKE type_file.chr10       
DEFINE g_aaz641        LIKE aaz_file.aaz641    
DEFINE g_aaz113        LIKE aaz_file.aaz113   
DEFINE g_aaz130        LIKE aaz_file.aaz130   #FUN-B90093 add   
DEFINE g_dbs_axz03     LIKE type_file.chr21   
DEFINE g_axz03         LIKE axz_file.axz03   
DEFINE g_sql           STRING               
DEFINE g_aaz641_axa03  LIKE aaz_file.aaz641    
DEFINE g_dbs_axa03     LIKE type_file.chr21  
DEFINE g_newno         LIKE axi_file.axi01    
DEFINE g_axa        DYNAMIC ARRAY OF RECORD        
                    axa01      LIKE axa_file.axa01,  #族群代號
                    axa02      LIKE axa_file.axa02   #上層公司
                    END RECORD 
DEFINE g_dept       DYNAMIC ARRAY OF RECORD        
                    axa01      LIKE axa_file.axa01,  #族群代號
                    axa02      LIKE axa_file.axa02,  #合併個體
                    axa03      LIKE axa_file.axa03,  #合併個體帳別
                    aaz641     LIKE aaz_file.aaz641, #合併帳別
                    axz06      LIKE axz_file.axz06   #記帳幣別
                    #--CHI-D20029 start--
                   ,axz10      LIKE axz_file.axz10
                   ,aaa14      LIKE aaa_file.aaa14
                   ,aaa15      LIKE aaa_file.aaa15
                   ,aaa16      LIKE aaa_file.aaa16
                    #--CHI-D20029 end----
                    END RECORD
DEFINE l_rate       LIKE axp_file.axp05             #功能幣別匯率    
DEFINE l_rate1      LIKE axp_file.axp05             #記帳幣別匯率   
DEFINE g_azw02      LIKE azw_file.azw02      
#DEFINE g_aah        RECORD LIKE aah_file.*         #FUN-CA0085 mark
#DEFINE g_aed        RECORD LIKE aed_file.*         #FUN-CA0085 add
DEFINE g_axq        RECORD LIKE axq_file.*
#--FUN-CA0085 start---
DEFINE g_aah        RECORD 
                    aah01  LIKE aah_file.aah01,
                    aeh02  LIKE aeh_file.aeh02,  
                    aah02  LIKE aah_file.aah02,
                    aah03  LIKE aah_file.aah03,
                    aah04  LIKE aah_file.aah04,
                    aah05  LIKE aah_file.aah05,
                    aah06  LIKE aah_file.aah06,
                    aah07  LIKE aah_file.aah07
                    END RECORD
DEFINE g_aed        RECORD 
                    aed01  LIKE aed_file.aed01, 
                    aeh02  LIKE aeh_file.aeh02,
                    aed011 LIKE aed_file.aed011,
                    aed02  LIKE aed_file.aed02,
                    aed03  LIKE aed_file.aed03,
                    aed04  LIKE aed_file.aed04,
                    aed05  LIKE aed_file.aed05,
                    aed06  LIKE aed_file.aed06,
                    aed07  LIKE aed_file.aed07,
                    aed08  LIKE aed_file.aed08
                    END RECORD
#--FUN-CA0085 end-----
DEFINE g_aeh        RECORD 
                    aeh01  LIKE aeh_file.aeh01,
                    aeh02  LIKE aeh_file.aeh02,   #FUN-CA0085
                    aeh09  LIKE aeh_file.aeh09,
                    aeh10  LIKE aeh_file.aeh10,
                    aeh11  LIKE aeh_file.aeh11,
                    aeh12  LIKE aeh_file.aeh12,
                    aeh13  LIKE aeh_file.aeh13,
                    aeh14  LIKE aeh_file.aeh14,
                    aeh31  LIKE aeh_file.aeh31,
                    aeh32  LIKE aeh_file.aeh32,
                    aeh33  LIKE aeh_file.aeh33,
                    aeh34  LIKE aeh_file.aeh34
                   ,aeh04  LIKE aeh_file.aeh04   #FUN-BA0111
                   ,aeh05  LIKE aeh_file.aeh05   #FUN-BA0111
                   ,aeh06  LIKE aeh_file.aeh06   #FUN-BA0111
                   ,aeh07  LIKE aeh_file.aeh07   #FUN-BA0111
                    END RECORD
MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
  #CHI-D20029--Begin Mark--
  #IF g_bookno IS NULL OR g_bookno = ' ' THEN
  #   SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
  #END IF
  #CHI-D20029---End Mark---
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy    = ARG_VAL(1)
   LET tm.bm    = ARG_VAL(2)
   LET tm.em    = ARG_VAL(3)
   LET tm.axa01 = ARG_VAL(4)
   LET tm1.wc   = ARG_VAL(5)                         #QBE條件
   LET g_bgjob  = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

  #CHI-D20029--Begin--
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
  #CHI-D20029---End---

  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL aglp000_tm(0,0)
        IF cl_sure(21,21) THEN
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p000()
           CALL s_showmsg()         
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag    #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag    #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW aglp000_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07    
          FROM aaa_file WHERE aaa01 = g_bookno
        LET g_success = 'Y'
        BEGIN WORK
        CALL p000()
        CALL s_showmsg()                     
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END  IF
  END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN

FUNCTION aglp000_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,   
           l_cnt          LIKE type_file.num5   
   DEFINE  lc_cmd         LIKE type_file.chr1000    
   DEFINE  l_axa09        LIKE axa_file.axa09       
        
   IF s_shut(0) THEN RETURN END IF
   CALL s_dsmark(g_bookno)

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW aglp000_w AT p_row,p_col WITH FORM "agl/42f/aglp000" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07   
        FROM aaa_file 
       WHERE aaa01 = g_bookno
      LET tm.yy = g_aaa04
      LET tm.bm = 0              
      DISPLAY tm.bm TO FORMONLY.bm 
      LET tm.em = g_aaa05
      LET g_bgjob = 'N'     

      INPUT BY NAME tm.yy,tm.em,tm.axa01
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE   
            EXIT INPUT                

         AFTER FIELD em    
            IF NOT cl_null(tm.em) THEN
               IF tm.bm >tm.em  THEN 
                  CALL cl_err('','9011',0) NEXT FIELD em 
               END IF
            END IF
            

         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01 
               IF STATUS THEN
                  CALL cl_err(tm.axa01,'agl031',1) 
                  NEXT FIELD axa01 
               END IF
            END IF

         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_axa"
                  LET g_qryparam.form = "q_axa1"    #TQC-AA0098
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01
                  DISPLAY BY NAME tm.axa01
                  NEXT FIELD axa01
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM

         BEFORE INPUT
             CALL cl_qbe_init()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW aglp000_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

   #CONSTRUCT BY NAME tm1.wc ON axa02
   CONSTRUCT BY NAME tm1.wc ON axz01   #TQC-AA0098

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
        CASE
            #WHEN INFIELD(axa02)
            WHEN INFIELD(axz01)    #TQC-AA0098
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_axz"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO axa02
               DISPLAY g_qryparam.multiret TO axz01   #TQC-AA0098
               #NEXT FIELD axa02
               NEXT FIELD axz01         #TQC-AA0098
         END CASE

      ON ACTION locale
        LET g_change_lang = TRUE         
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
         
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT CONSTRUCT
  
      ON ACTION qbe_select
         CALL cl_qbe_select()

     END CONSTRUCT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp000_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF

     INPUT BY NAME g_bgjob 
           WITHOUT DEFAULTS 

        ON ACTION locale
           LET g_change_lang = TRUE   
           EXIT INPUT                

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(axa01) 
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_axa"
                 LET g_qryparam.form = "q_axa1"   #TQC-AA0098
                 LET g_qryparam.default1 = tm.axa01
                 CALL cl_create_qry() RETURNING tm.axa01
                 DISPLAY BY NAME tm.axa01
                 NEXT FIELD axa01
           END CASE

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

        ON ACTION exit                            #加離開功能
           LET INT_FLAG = 1
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM

        BEFORE INPUT
            CALL cl_qbe_init()

        ON ACTION qbe_select
           CALL cl_qbe_select()

        ON ACTION qbe_save
           CALL cl_qbe_save()

     END INPUT

     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW aglp000_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01= 'aglp000'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aglp000','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " ''",
                       " '",tm.yy CLIPPED,"'",
                       " '",tm.bm CLIPPED,"'",
                       " '",tm.em CLIPPED,"'",
                       " '",tm.axa01 CLIPPED,"'",
                       " '",tm1.wc CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('aglp000',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW aglp000_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE

END FUNCTION
   
FUNCTION p000()
DEFINE l_sql        STRING,                   
       l_sql_axr    LIKE type_file.chr1000,  
       i,g_no       LIKE type_file.num5,    
       #g_aedd        RECORD LIKE aedd_file.*,   #TQC-AA0098
       l_aei16       LIKE aei_file.aei16,
       l_aei17       LIKE aei_file.aei17,
       l_aeii        RECORD LIKE aeii_file.*,
       l_n           LIKE type_file.num5,          
       l_cut         LIKE type_file.num5,             #幣別取位(功能幣別)                  #No.FUN-680098  SMALLINT
       l_cut1        LIKE type_file.num5,             #幣別取位(記帳幣別) 
       l_axz04       LIKE axz_file.axz04,             #使用TIPTOP否
       l_axz06       LIKE axz_file.axz06,             #上層公司記帳幣別   
       l_axz         RECORD LIKE axz_file.*,                            
       l_axz03       LIKE axz_file.axz03,             
       l_aag06       LIKE aag_file.aag06              
DEFINE l_aag04       LIKE aag_file.aag04              
DEFINE l_bs_yy       LIKE type_file.num5              
DEFINE l_bs_mm       LIKE type_file.num5              
DEFINE l_axe         RECORD LIKE axe_file.*
DEFINE l_axe04       LIKE axr_file.axr07              
DEFINE l_axe04_cnt   LIKE type_file.num5              
DEFINE l_axz01       LIKE axz_file.axz01   #TQC-AA0098 add
DEFINE l_aal03       LIKE aal_file.aal03   #FUN-B70103   Add
DEFINE l_month       LIKE axq_file.axq07   #FUN-B90093
DEFINE l_axq08       LIKE axq_file.axq08   #FUN-B90093
DEFINE l_axq09       LIKE axq_file.axq09   #FUN-B90093
DEFINE l_axz10       LIKE axz_file.axz10   #CHI-D20029
DEFINE l_ayf10       LIKE ayf_file.ayf10   #FUN-D20047 add
DEFINE l_ayf11       LIKE ayf_file.ayf11   #FUN-D20047 add
DEFINE l_axq29       LIKE axq_file.axq29   #CHI-D20029 

    #-->資料匯入,更換科目(axe,axee)
    #-->aah_file->aej_file;aed_file->aek_file
    #-->axq_file->aej_file;axq_file->aek_file   
    #-->aeh_file->aem_file;

    LET g_no = 1 
    FOR g_no = 1 TO 300 
        INITIALIZE g_dept[g_no].* TO NULL 
    END FOR

    #--TQC-AA0098 start--
   #LET l_sql = "SELECT axz01 ",        #CHI-D20029 mark
    LET l_sql = "SELECT axz01,axz10 ",  #CHI-D20029 
                "  FROM axz_file",
                " WHERE ",tm1.wc CLIPPED
    PREPARE p000_axz_p FROM l_sql
    DECLARE p000_axz_c CURSOR FOR p000_axz_p
    LET g_no = 1 
   #FOREACH p000_axz_c INTO l_axz01            #CHI-D20029 mark
    FOREACH p000_axz_c INTO l_axz01,l_axz10    #CHI-D20029 
    #-TQC-AA0098 end--
        LET l_sql=" SELECT UNIQUE axa01,axa02,axa03",
                  "   FROM axa_file ",
                  "  WHERE axa01='",tm.axa01,"'",
                  #"    AND ",tm1.wc CLIPPED,
                  "    AND axa02 = '",l_axz01,"'",   #TQC-AA0098
                  "  UNION ",
                  " SELECT UNIQUE axa01,axb04,axb05",
                  "   FROM axb_file,axa_file ",
                  "  WHERE axa01=axb01 AND axa02=axb02",
                  "    AND axa01='",tm.axa01,"'",
                  #"    AND ",tm1.wc CLIPPED,
                  "    AND axb04 = '",l_axz01,"'",   #10101
                  "  ORDER BY 1,2 "
        PREPARE p000_axa_p FROM l_sql
        IF STATUS THEN 
           CALL cl_err('prepare:1',STATUS,1)             
           CALL cl_batch_bg_javamail('N')  
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
        DECLARE p000_axa_c CURSOR FOR p000_axa_p
#        LET g_no = 1   #TQC-AA0098 mark
        CALL s_showmsg_init()         
        FOREACH p000_axa_c INTO g_dept[g_no].*
           #合併帳別
           CALL s_aaz641_dbs(g_dept[g_no].axa01,g_dept[g_no].axa02)
           RETURNING g_dbs_axz03   
           CALL s_get_aaz641(g_dbs_axz03) RETURNING g_dept[g_no].aaz641

           #-->step 1 刪除資料
           CALL p000_del(g_no)
           IF g_success = 'N' THEN RETURN END IF

           IF g_success='N' THEN
             LET g_totsuccess='N'
             LET g_success='Y'
           END IF 
           IF SQLCA.SQLCODE THEN 
              CALL s_errmsg(' ',' ','for_axa_c:',STATUS,1) 
              LET g_success = 'N'
              RETURN                                     
           END IF
           #--CHI-D20029 start---
           LET g_dept[g_no].axz10 = l_axz10
           SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01=g_dept[g_no].axa02
           LET g_sql = "SELECT aaa14,aaa15,aaa16 FROM ",cl_get_target_table(l_axz03,'aaa_file'), 
                       " WHERE aaa01 = '",g_dept[g_no].axa03,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
           CALL cl_parse_qry_sql(g_sql,l_axz03) RETURNING g_sql 
           PREPARE p000_aaa_p1 FROM g_sql
           DECLARE p000_aaa_c1 CURSOR FOR p000_aaa_p1
           OPEN p000_aaa_c1
           FETCH p000_aaa_c1 
           INTO g_dept[g_no].aaa14,
                  g_dept[g_no].aaa15,
                  g_dept[g_no].aaa16
           CLOSE p000_aaa_c1
           #--CHI-D20029 end-----
           LET g_no=g_no+1
        END FOREACH
    END FOREACH   #TQC-AA0098
    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
    LET g_no=g_no-1

    FOR i =1 TO g_no 
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y'                                                      
       END IF
       SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01=g_dept[i].axa02
       SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = l_axz03  
       SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_axz03
       IF STATUS THEN LET g_dbs_new = NULL END IF
       IF NOT cl_null(g_dbs_new) THEN 
          #LET g_dbs_new=g_dbs_new CLIPPED,':'   #MOD-B30236 
          LET g_dbs_new=g_dbs_new CLIPPED,'.'    #MOD-B30236 
       END IF
       LET g_dbs_gl = g_dbs_new CLIPPED

       #合併帳別
       CALL s_aaz641_dbs(g_dept[i].axa01,g_dept[i].axa02)
       RETURNING g_dbs_axz03   
       CALL s_get_aaz641(g_dbs_axz03) RETURNING g_dept[i].aaz641

       #記帳幣別
       SELECT axz06 INTO g_dept[i].axz06
         FROM axz_file 
        WHERE axz01=g_dept[i].axa02
     
      #LET g_sql = "SELECT aaz113 FROM ",g_dbs_axz03,"aaz_file",          #FUN-B90093 mark
      #LET g_sql = "SELECT aaz113,aaz130 FROM ",g_dbs_axz03,"aaz_file",   #FUN-BA0006 mark #FUN-B90093 mod
       LET g_sql = "SELECT aaz113,aaz130 FROM ",cl_get_target_table(g_dbs_axz03,'aaz_file'),    #FUN-BA0006
                   " WHERE aaz00 = '0'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_dbs) RETURNING g_sql  #FUN-BA0006
       PREPARE p000_pre_01 FROM g_sql
       DECLARE p000_cur_01 CURSOR FOR p000_pre_01
       OPEN p000_cur_01
      #FETCH p000_cur_01 INTO g_aaz113			  #FUN-B90093 mark
	   FETCH p000_cur_01 INTO g_aaz113,g_aaz130   #FUN-B90093 mod
       CLOSE p000_cur_01

       LET l_rate = 1 
       LET l_cut  = 0
       LET l_cut1 = 0   #FUN-5A0020

       SELECT axz04 INTO l_axz04 FROM axz_file WHERE axz01=g_dept[i].axa02
       IF l_axz04='Y' THEN   #是否屬於TIPTOP公司
         #FUN-CA0085 mark start---
         # LET l_sql=
         # " SELECT * ",
         ##" FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",       #FUN-BA0006 mark
         # "   FROM ",cl_get_target_table(l_axz03,'aah_file'),",",   #FUN-BA0006
         # "        ",cl_get_target_table(l_axz03,'aag_file'),       #FUN-BA0006
         # " WHERE aah02=",tm.yy,
         # " AND aah03 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
         # " AND aah00='",g_dept[i].axa03,"' ",
         # " AND aah01 = aag01 ",
         # " AND aah00 = aag00 ",
#        # " AND aag07 MATCHES '[23]'",      #No..TQC-B30100 Mark
         # " AND aag07 IN ('2','3')  ",      #No..TQC-B30100 add
         # " AND aag09 = 'Y' ",
         # " AND aag01 <> '",g_aaz113,"'",
         # " AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
         # "                  WHERE tat05=aag01 AND tat01=aah00 AND tat02=aah02)",   #MOD-D10196
         # " ORDER BY aah01"
         #FUN-CA0085 mark end------
          #--FUN-CA0085 add start-----
          #科目編號/部門/會計年度/期別/借方金額/貸方金額/借方筆數/貸方筆數/
           LET l_sql=" SELECT aeh01,aeh02,aeh09,aeh10,SUM(aeh11),",  
                     " SUM(aeh12),SUM(aeh13),SUM(aeh14)",
                     "   FROM ",cl_get_target_table(l_axz03,'aeh_file'),",", 
                     "        ",cl_get_target_table(l_axz03,'aag_file'),    
                     " WHERE aeh09 =",tm.yy,
                     " AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                     " AND aeh00 ='",g_dept[i].axa03,"'",
                     " AND aeh01 = aag01 ",
                     " AND aeh00 = aag00 ",
                     " AND aag07 IN ('2','3')  ",    
                     " AND aag09 = 'Y' ",
                     " AND aag01 <> '",g_aaz113,"'",
                     " AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
                     "                  WHERE tat05=aag01 AND tat01=aeh00 AND tat02=aeh09)",   #MOD-D10196
                     " GROUP BY aeh01,aeh02,aeh09,aeh10", 
                     " ORDER BY aeh01"
          #FUN-CA0085 add end--------
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql  #FUN-BA0006
           PREPARE p000_aah_p5 FROM l_sql
           IF STATUS THEN
               LET g_showmsg=tm.yy,"/",g_dept[i].axa03
               CALL s_errmsg('aah02,aah00',g_showmsg,'prepare:2',STATUS,1)
               LET g_success = 'N'
               CONTINUE FOR
           END IF
           DECLARE p000_aah_c5 CURSOR FOR p000_aah_p5
           FOREACH p000_aah_c5 INTO g_aah.*
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg(' ',' ','p000_aah_c5',STATUS,1)
                  LET g_success = 'N'
                  CONTINUE FOREACH
               END IF
               #--CHI-D20029 start---
               IF (g_aah.aah04 = 0 AND g_aah.aah05 = 0) THEN CONTINUE FOREACH END IF
               #如果遇到科目為aaa14~aaa16其中符合者，則取table的來源一律為aah_file
               IF (g_aah.aah01 = g_dept[g_no].aaa14) OR (g_aah.aah01 = g_dept[g_no].aaa15) OR (g_aah.aah01 = g_dept[g_no].aaa16) THEN            
                   LET l_sql=
                   "SELECT aah01,'',aah02,aah03,aah04,aah05,aah06,aah07 ",
                   "   FROM ",cl_get_target_table(l_axz03,'aah_file'),",", 
                   "        ",cl_get_target_table(l_axz03,'aag_file'),    
                   " WHERE aah02=",tm.yy,
                   " AND aah03 = '",g_aah.aah03,"'", 
                   " AND aah00='",g_dept[i].axa03,"' ",
                   " AND aah01 = aag01 ",
                   " AND aah00 = aag00 ",
                   " AND aag09 = 'Y' ",
                   " AND aag01 = '",g_aah.aah01,"'"

                   CALL cl_replace_sqldb(l_sql) RETURNING g_sql	
                   CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql 
                   PREPARE p000_aah_p2 FROM l_sql
                   DECLARE p000_aah_c2 CURSOR FOR p000_aah_p2
                   OPEN p000_aah_c2
                   FETCH p000_aah_c2 INTO g_aah.*
                   CLOSE p000_aah_c2
               END IF
               #--CHI-D20029 end------
               LET l_axe.axe06 = g_aah.aah01
               LET l_axe.axe11 = '1'
               LET l_axe.axe12 = '1'
               DISPLAY g_aah.aah03,'->',l_axe.axe06,' ',g_aah.aah01,' ',g_aah.aah04,' ',g_aah.aah05

              #--FUN-CA0085 start--
              #依agli009的axz10設定判斷科目轉換的來源檔案為agli001 or agli020
              IF (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN      #CHI-D20029
              #FUN-CA0085 end---
               #抓取合併個體公司的科目的合併財報科目編號(axe06),
               SELECT * INTO l_axe.* FROM axe_file    
                WHERE axe01 = g_dept[i].axa02 
                  AND axe00 = g_dept[i].axa03
		  AND axe04 = g_aah.aah01 
                  AND axe13 = g_dept[i].axa01
              #--FUN-CA0085 start----
              ELSE
                  #--CHI-D20029 start---假設取到的科餘資料沒有部門別存在，則不把部門當做條件
                  IF cl_null(g_aah.aeh02) OR g_aah.aeh02 ='' THEN                
                 SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                              '','','',ayfacti,ayfuser,ayfgrup,
                              ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                              ayf09,ayforig,ayforiu
                         INTO l_axe.* 
                         FROM ayf_file    
                        WHERE ayf01 = g_dept[i].axa02 
                          AND ayf00 = g_dept[i].axa03
	                  AND ayf04 = g_aah.aah01
                          AND ayf09 = g_dept[i].axa01
                          AND ayf02 = ' '
                          AND ayf03 = ' '
                          AND ayf10 = g_aah.aah02      #FUN-D20047 add 
                          AND ayf11 = g_aah.aah03      #FUN-D20047 add
                  ELSE
                  #---CHI-D20029 end------------------------------
                       SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                        '','','',ayfacti,ayfuser,ayfgrup,
                        ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                        ayf09,ayforig,ayforiu
                   INTO l_axe.* 
                   FROM ayf_file    
                  WHERE ayf01 = g_dept[i].axa02 
                    AND ayf00 = g_dept[i].axa03
	            AND ayf04 = g_aah.aah01
                    AND ayf09 = g_dept[i].axa01
                    AND (ayf02 <= g_aah.aeh02 AND ayf03 >= g_aah.aeh02)
                          AND ayf10 = g_aah.aah02     #FUN-D20047 add
                          AND ayf11 = g_aah.aah03     #FUN-D20047 add
                  END IF                                                       #CHI-D20029 add
              END IF 
              #--FUN-CA0085 end----
               IF STATUS  THEN     
                  #FUN-D20047 add begin---
                  IF STATUS = 100 THEN
                     SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                       FROM ayf_file
                      WHERE ayf01 = g_dept[i].axa02
                        AND ayf09 = g_dept[i].axa01    
                     IF NOT (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN
                        IF cl_null(g_aah.aeh02) OR g_aah.aeh02 ='' THEN
                           SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                                  '','','',ayfacti,ayfuser,ayfgrup,
                                  ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                                  ayf09,ayforig,ayforiu
                             INTO l_axe.*
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axa02
                              AND ayf00 = g_dept[i].axa03
                              AND ayf04 = g_aah.aah01
                              AND ayf09 = g_dept[i].axa01
                              AND ayf02 = ' '
                              AND ayf03 = ' '
                              AND ayf10 = l_ayf10 
                              AND ayf11 = l_ayf11
                        ELSE
                           SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                                  '','','',ayfacti,ayfuser,ayfgrup,
                                  ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                                  ayf09,ayforig,ayforiu
                             INTO l_axe.*
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axa02
                              AND ayf00 = g_dept[i].axa03
                              AND ayf04 = g_aah.aah01
                              AND ayf09 = g_dept[i].axa01
                              AND (ayf02 <= g_aah.aeh02 AND ayf03 >= g_aah.aeh02)
                              AND ayf10 = l_ayf10
                              AND ayf11 = l_ayf11
                        END IF
                     END IF 
                  END IF
                  #FUN-D20047 add end-----
                  IF cl_null(l_axe.axe01) THEN   #FUN-D20047 add
                   #LET g_showmsg=g_dept[i].axa03,"/",g_aah.aah01
                   LET g_showmsg = g_dept[i].axa02,"/",g_dept[i].axa03,"/",g_aah.aah01        #TQC-AA0098
                  #CALL s_errmsg('axz01,,aah00,aah01',g_showmsg,g_aah.aah01,'aap-021',1)      #TQC-AA0098     #FUN-D40019 mark
                   CALL s_errmsg('axz01,,aah00,aah01',g_showmsg,g_aah.aah01,'agl1067',1)      #FUN-D40019 add
                   LET g_success = 'N' 
                   CONTINUE FOREACH       
                  END IF    #FUN-D20047 add      
               END IF

               INSERT INTO aej_file                                                                                                                        
                 (aej00,aej01,aej02,aej03,
                  aej04,aej05,aej06,aej07,
                  aej08,aej09,aej10,aej11,aejlegal)
               VALUES                                                                                                                                     
                 (g_dept[i].aaz641,g_dept[i].axa01,
                  g_dept[i].axa02,  
                  g_dept[i].axa03,l_axe.axe06,
                  g_aah.aah02,g_aah.aah03,
                  g_aah.aah04,g_aah.aah05,
                  g_aah.aah06,g_aah.aah07,
                  g_dept[i].axz06,g_azw02)
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                   UPDATE aej_file SET aej07 = aej07 + g_aah.aah04,
                                       aej08 = aej08 + g_aah.aah05,
                                       aej09 = aej09 + g_aah.aah06,
                                       aej10 = aej10 + g_aah.aah07
                    WHERE aej00 = g_dept[i].aaz641
                      AND aej01 = g_dept[i].axa01                                                                                                         
                      AND aej02 = g_dept[i].axa02                                                                                                         
                      AND aej03 = g_dept[i].axa03                                                                                                         
                      AND aej04 = l_axe.axe06
                      AND aej05 = g_aah.aah02
                      AND aej06 = g_aah.aah03                                                                                                             
                      AND aej11 = g_dept[i].axz06
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                       CALL s_errmsg('axg01',g_dept[i].axa01,'upd_aej',SQLCA.sqlcode,1)                                                                       
                       LET g_success = 'N'                                                                                                                    
                       CONTINUE FOREACH     
                   END IF                                                                                                                                    
               ELSE                                                                                                                                        
                   IF STATUS THEN                                                                                                                            
                      CALL s_errmsg('axg01',g_dept[i].axa01,'ins_aej',status,1)                                                                              
                      LET g_success = 'N'                                                                                                                    
                      CONTINUE FOREACH   
                   END IF                                                                                                                                    
               END IF                                        
           END FOREACH

          #FUN-CA0085 mark start---
          #LET l_sql=
          #      " SELECT * ",
          #     #" FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",      #FUN-BA0006 mark
          #      "   FROM ",cl_get_target_table(l_axz03,'aed_file'),",",  #FUN-BA0006
          #      "        ",cl_get_target_table(l_axz03,'aag_file'),      #FUN-BA0006
          #      " WHERE aed03=",tm.yy,
          #      " AND aed04 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
          #      " AND aed00='",g_dept[i].axa03,"' AND aed011='99' ",
          #      " AND aed01 = aag01 ",
          #      " AND aed00 = aag00 ",
#         #      " AND aag07 MATCHES '[23]'",       #No.No.TQC-B30100 Mark
          #      " AND aag07 IN ('2','3')  ",      #No..TQC-B30100 add
          #      " AND aag01 <> '",g_aaz113,"'",
          #      " AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
          #      "                  WHERE tat05=aag01 AND tat01=aed00 AND tat02=aed03)",   #MOD-D10196
          #      " AND aag09 = 'Y' ",
          #      " ORDER BY aed01 "
          #FUN-CA0085 mark end---
          #--FUN-CA0085 add start-----
          #科目編號/部門/會計年度/期別/借方金額/貸方金額/借方筆數/貸方筆數/
           LET l_sql=" SELECT aeh01,aeh02,'99',aeh37,aeh09,aeh10,SUM(aeh11),",  
                     " SUM(aeh12),SUM(aeh13),SUM(aeh14)",
                     "   FROM ",cl_get_target_table(l_axz03,'aeh_file'),",", 
                     "        ",cl_get_target_table(l_axz03,'aag_file'),    
                     " WHERE aeh09 =",tm.yy,
                     " AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                     " AND aeh00 ='",g_dept[i].axa03,"'",
                     " AND aeh01 = aag01 ",
                     " AND aeh00 = aag00 ",
                     " AND aag07 IN ('2','3')  ",    
                     " AND aag09 = 'Y' ",
                     " AND aag01 <> '",g_aaz113,"'",
                     " AND aeh37 <> ' '",                                                      #CHI-D20029 ADD
                     " AND aeh37 IS NOT NULL ",                                                #CHI-D20029 ADD 
                     " AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
                     "                  WHERE tat05=aag01 AND tat01=aeh00 AND tat02=aeh09)",   #MOD-D10196
                     " GROUP BY aeh01,aeh02,aeh37,aeh09,aeh10", 
                     " ORDER BY aeh01"
          #FUN-CA0085 add end--------
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql  #FUN-BA0006
           PREPARE p000_aed_p5 FROM l_sql
           IF STATUS THEN
                LET g_showmsg=tm.yy,"/",g_dept[i].axa03,'99'
                CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) 
                LET g_success ='N' 
                CONTINUE FOR
           END IF
           DECLARE p000_aed_c5 CURSOR FOR p000_aed_p5
           FOREACH p000_aed_c5 INTO g_aed.*
              IF (g_aed.aed05 = 0 AND g_aed.aed06 = 0) THEN CONTINUE FOREACH END IF  #CHI-D20029
#FUN-B70103   ---start   Add
               LET l_aal03 = NULL
               SELECT aal03 INTO l_aal03 FROM aal_file
                WHERE aal01 = g_dept[i].axa02
                  AND aal02 = g_aed.aed02
               IF NOT cl_null(l_aal03) THEN
                  LET g_aed.aed02 = l_aal03
               END IF
#FUN-B70103   ---end     Add

               #--CHI-D20029 start---
               #如果遇到科目為aaa14~aaa16其中符合者，則取table的來源一律為aah_file
               IF (g_aed.aed01 = g_dept[g_no].aaa14) OR (g_aed.aed01 = g_dept[g_no].aaa15) OR (g_aed.aed01 = g_dept[g_no].aaa16) THEN            
                   LET l_sql=
                   "SELECT aah01,' ','99',' ',aah02,aah03,aah04,aah05,aah06,aah07 ",
                   "   FROM ",cl_get_target_table(l_axz03,'aah_file'),",", 
                   "        ",cl_get_target_table(l_axz03,'aag_file'),    
                   " WHERE aah02=",tm.yy,
                   " AND aah03 = '",g_aed.aed04,"'", 
                   " AND aah00='",g_dept[i].axa03,"' ",
                   " AND aah01 = aag01 ",
                   " AND aah00 = aag00 ",
                   " AND aag09 = 'Y' ",
                   " AND aag01 = '",g_aed.aed01,"'"

                   CALL cl_replace_sqldb(l_sql) RETURNING g_sql	
                   CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql
                   PREPARE p000_aed_p2 FROM l_sql
                   DECLARE p000_aed_c2 CURSOR FOR p000_aed_p2
                   OPEN p000_aed_c2
                   FETCH p000_aed_c2 INTO g_aed.*
                   CLOSE p000_aed_c2
               END IF
               #--CHI-D20029 end------

               LET l_axe.axe06 = g_aed.aed01
               LET l_axe.axe11 = '1'
               LET l_axe.axe12 = '1'
               DISPLAY g_aed.aed04,'->',l_axe.axe06,' ',g_aed.aed01,' ',g_aed.aed05,' ',g_aed.aed06

              #--FUN-CA0085 start--
              #依agli009的axz10設定判斷科目轉換的來源檔案為agli001 or agli020
               IF (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN      #CHI-D20029 
              #--FUN-CA0085 end---
               SELECT * INTO l_axe.* FROM axe_file    
                WHERE axe01 = g_dept[i].axa02 
                  AND axe00 = g_dept[i].axa03
		  AND axe04 = g_aed.aed01
                  AND axe13 = g_dept[i].axa01
              #--FUN-CA0085 start----
               ELSE
                   #--CHI-D20029 start---假設取到的科餘資料沒有部門別存在，則不把部門當做條件
                   IF cl_null(g_aed.aeh02) THEN                
                        SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                               '','','',ayfacti,ayfuser,ayfgrup,
                               ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                               ayf09,ayforig,ayforiu
                          INTO l_axe.* 
                          FROM ayf_file    
                         WHERE ayf01 = g_dept[i].axa02 
                           AND ayf00 = g_dept[i].axa03
	                   AND ayf04 = g_aed.aed01
                           AND ayf09 = g_dept[i].axa01
                           AND ayf02 = ' '
                           AND ayf03 = ' '
                           AND ayf10 = g_aah.aah02   #FUN-D20047 add
                           AND ayf11 = g_aah.aah03   #FUN-D20047 add
                   ELSE
                   #---CHI-D20029 end------------------------------
                  SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                         '','','',ayfacti,ayfuser,ayfgrup,
                         ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                         ayf09,ayforig,ayforiu
                    INTO l_axe.* 
                    FROM ayf_file    
                   WHERE ayf01 = g_dept[i].axa02 
                     AND ayf00 = g_dept[i].axa03
	             AND ayf04 = g_aed.aed01
                     AND ayf09 = g_dept[i].axa01
                     AND (ayf02 <= g_aed.aeh02 AND ayf03 >= g_aed.aeh02)
                     AND ayf10 = g_aah.aah02   #FUN-D20047 add
                     AND ayf11 = g_aah.aah03   #FUN-D20047 add
                   END IF                                                       #CHI-D20029 add
              END IF 
              #--FUN-CA0085 end----
               IF STATUS  THEN                   
                  #FUN-D20047 add begin---
                  IF STATUS = 100 THEN
                     SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                       FROM ayf_file
                      WHERE ayf01 = g_dept[i].axa02
                        AND ayf09 = g_dept[i].axa01
                     IF NOT (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN
                        IF cl_null(g_aed.aeh02) THEN
                           SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                                  '','','',ayfacti,ayfuser,ayfgrup,
                                  ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                                  ayf09,ayforig,ayforiu
                             INTO l_axe.*
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axa02
                              AND ayf00 = g_dept[i].axa03
                              AND ayf04 = g_aed.aed01
                              AND ayf09 = g_dept[i].axa01
                              AND ayf02 = ' '
                              AND ayf03 = ' '
                              AND ayf10 = l_ayf10 
                              AND ayf11 = l_ayf11 
                        ELSE
                           SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                                  '','','',ayfacti,ayfuser,ayfgrup,
                                  ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                                  ayf09,ayforig,ayforiu
                             INTO l_axe.*
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axa02
                              AND ayf00 = g_dept[i].axa03
                              AND ayf04 = g_aed.aed01
                              AND ayf09 = g_dept[i].axa01
                              AND (ayf02 <= g_aed.aeh02 AND ayf03 >= g_aed.aeh02)  
                              AND ayf10 = l_ayf10
                              AND ayf11 = l_ayf11
                        END IF
                     END IF
                  END IF
                  #FUN-D20047 add end-----
           
                  IF cl_null(l_axe.axe01) THEN   #FUN-D20047 add
                   #LET g_showmsg=g_dept[i].axa03,"/",g_aed.aed01 
                   #CALL s_errmsg('axe01,axe04',g_showmsg,g_aed.aed01,'aap-021',1)   
                   #LET g_showmsg = g_dept[i].axa02,"/",g_dept[i].axa03,"/",g_aah.aah01            #TQC-AA0098  #TQC-B70117 mark
                   LET g_showmsg = g_dept[i].axa02,"/",g_dept[i].axa03,"/",g_aed.aed01  #TQC-B70117
                   #CALL s_errmsg('axz01,,aah00,aah01',g_showmsg,g_aah.aah01,'aap-021',1)          #TQC-AA0098  #FUN-D40019 mark
                   CALL s_errmsg('axz01,,aah00,aah01',g_showmsg,g_aah.aah01,'agl1067',1)           #FUN-D40019 add
                   LET g_success = 'N'
                   CONTINUE FOREACH    
                  END IF   #FUN-D20047 add
               END IF
               INSERT INTO aek_file 
                  (aek00,aek01,aek02,aek03,aek04,aek05,
                   aek06,aek07,aek08,aek09,aek10,aek11,aek12,aeklegal)    #MOD-B30441 aeklegal
               VALUES 
                  (g_dept[i].aaz641,g_dept[i].axa01,g_dept[i].axa02,  
                   g_dept[i].axa03,l_axe.axe06,g_aed.aed02,  
                   g_aed.aed03,g_aed.aed04,g_aed.aed05,
                   g_aed.aed06,g_aed.aed07,g_aed.aed08,
                   g_dept[i].axz06,g_azw02)
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                  UPDATE aek_file SET aek08 = aek08 + g_aed.aed05, 
                                      aek09 = aek09 + g_aed.aed06,
                                      aek10 = aek10 + g_aed.aed07,
                                      aek11 = aek11 + g_aed.aed08
                      WHERE aek00 = g_dept[i].aaz641
                        AND aek01 = g_dept[i].axa01
                        AND aek02 = g_dept[i].axa02
                        AND aek03 = g_dept[i].axa03
                        AND aek04 = l_axe.axe06
                        AND aek05 = g_aed.aed02
                        AND aek06 = g_aed.aed03
                        AND aek07 = g_aed.aed04
                        AND aek12 = g_dept[i].axz06 
                  #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                     CALL s_errmsg('aek01',g_dept[i].axa01,'upd_aek',SQLCA.sqlcode,1) 
                     LET g_success = 'N' 
                     CONTINUE FOREACH  
                  END IF
               ELSE
                  IF STATUS THEN 
                     LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_dept[i].aaz641,"/",g_dept[i].axa03      
                     CALL s_errmsg('aek01,aek02,aek03,aek04,aek05',g_showmsg,'ins_aek',status,1)                
                     LET g_success = 'N'
                     CONTINUE FOREACH       
                  END IF
               END IF                          
           END FOREACH
            
          #LET l_sql=" SELECT aeh01,aeh09,aeh10,SUM(aeh11),",
           LET l_sql=" SELECT aeh01,aeh02,aeh09,aeh10,SUM(aeh11),",   #FUN-CA0085 mod
                     " SUM(aeh12),SUM(aeh13),SUM(aeh14),",
                     " aeh31,aeh32,aeh33,aeh34",
                     ",aeh04,aeh05,aeh06,aeh07",            #FUN-BA0111
                    #" FROM ",g_dbs_gl,"aeh_file,",g_dbs_gl,"aag_file ",       #FUN-BA0006 mark
                     "   FROM ",cl_get_target_table(l_axz03,'aeh_file'),",",   #FUN-BA0006
                     "        ",cl_get_target_table(l_axz03,'aag_file'),       #FUN-BA0006
                     " WHERE aeh09 =",tm.yy,
                     " AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                     " AND aeh00 ='",g_dept[i].axa03,"'",
                     " AND aeh01 = aag01 ",
                     " AND aeh00 = aag00 ",
#                    " AND aag07 MATCHES '[23]'",      #No.TQC-B30100 Mark
                     " AND aag07 IN ('2','3')  ",      #No..TQC-B30100 add
                     " AND aag09 = 'Y' ",
                     " AND aag01 <> '",g_aaz113,"'",
                     " AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
                     "                  WHERE tat05=aag01 AND tat01=aeh00 AND tat02=aeh09)",   #MOD-D10196
                     " AND (aeh31<>' ' OR aeh32<>' ' OR aeh33<>' ' OR aeh34<>' '",   #FUN-BA0111 del '(' #MOD-B70230 add 
                     "   OR aeh04<>' ' OR aeh05<>' ' OR aeh06<>' ' OR aeh07<>' ')",  #FUN-BA0111 
                    #" GROUP BY aeh01,aeh09,aeh10,aeh31,aeh32,aeh33,aeh34",
                     " GROUP BY aeh01,aeh02,aeh09,aeh10,aeh31,aeh32,aeh33,aeh34",  #FUN-CA0085
                     "         ,aeh04,aeh05,aeh06,aeh07",   #FUN-BA0111
                     " ORDER BY aeh01"

           CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
           CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql   #FUN-BA0006
           PREPARE p000_aeh_p1 FROM l_sql
           IF STATUS THEN
              LET g_showmsg=tm.yy,"/",g_dept[i].axa03
              CALL s_errmsg('aeh00,aeh01',g_showmsg,'prepare:aeh_p1',STATUS,1) LET g_success='N' CONTINUE FOR 
           END IF
           DECLARE p000_aeh_c1 CURSOR FOR p000_aeh_p1
           FOREACH p000_aeh_c1 INTO g_aeh.*
               IF SQLCA.SQLCODE THEN
                  LET g_showmsg=tm.yy,"/",g_dept[i].axa03
                  CALL s_errmsg('aeh00,aeh01',g_showmsg,'foreach:aeh_c1',STATUS,1) LET g_success ='N' CONTINUE FOR
               END IF
               IF g_aeh.aeh11 =0 AND g_aeh.aeh12=0 THEN CONTINUE FOREACH END IF

               #--CHI-D20029 start---
               #如果遇到科目為aaa14~aaa16其中符合者，則取table的來源一律為aah_file
               IF (g_aeh.aeh01 = g_dept[g_no].aaa14) OR (g_aeh.aeh01 = g_dept[g_no].aaa15) OR (g_aeh.aeh01 = g_dept[g_no].aaa16) THEN            
                   LET l_sql=
                   "SELECT aah01,' ',aah02,aah03,aah04,aah05,aah06,aah07,",
                   "       ' ',' ',' ',' ',' ',' ',' ',' '",
                   "   FROM ",cl_get_target_table(l_axz03,'aah_file'),",", 
                   "        ",cl_get_target_table(l_axz03,'aag_file'),    
                   " WHERE aah02=",tm.yy,
                   " AND aah03 = '",g_aeh.aeh10,"'", 
                   " AND aah00='",g_dept[i].axa03,"' ",
                   " AND aah01 = aag01 ",
                   " AND aah00 = aag00 ",
                   " AND aag09 = 'Y' ",
                   " AND aag01 = '",g_aeh.aeh01,"'"

                   CALL cl_replace_sqldb(l_sql) RETURNING g_sql	
                   CALL cl_parse_qry_sql(l_sql,l_axz03) RETURNING l_sql
                   PREPARE p000_aeh_p2 FROM l_sql
                   DECLARE p000_aeh_c2 CURSOR FOR p000_aeh_p2
                   OPEN p000_aeh_c2
                   FETCH p000_aeh_c2 INTO g_aeh.*
                   CLOSE p000_aeh_c2
               END IF
               #--CHI-D20029 .nd------
               LET l_axe.axe06 = g_aeh.aeh01
               LET l_axe.axe11 = '1'
               LET l_axe.axe12 = '1'
               DISPLAY g_aeh.aeh10,'->',l_axe.axe06,' ',g_aeh.aeh01,' ',g_aeh.aeh11,' ',g_aeh.aeh12

               #--FUN-CA0085 start--
               #依agli009的axz10設定判斷科目轉換的來源檔案為agli001 or agli020
               IF (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN      #CHI-D20029 
               #--FUN-CA0085 end---
               SELECT * INTO l_axe.* FROM axe_file    
                WHERE axe01 = g_dept[i].axa02 
                  AND axe00 = g_dept[i].axa03
		  AND axe04 = g_aeh.aeh01
                  AND axe13 = g_dept[i].axa01
               #--FUN-CA0085 start----
               ELSE  
                  #--CHI-D20029 start---假設取到的科餘資料沒有部門別存在，則不把部門當做條件
                  IF cl_null(g_aeh.aeh02) THEN                
                       SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                              '','','',ayfacti,ayfuser,ayfgrup,
                              ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                              ayf09,ayforig,ayforiu
                         INTO l_axe.* 
                         FROM ayf_file    
                        WHERE ayf01 = g_dept[i].axa02 
                          AND ayf00 = g_dept[i].axa03
	                  AND ayf04 = g_aeh.aeh01
                          AND ayf09 = g_dept[i].axa01
                          AND ayf02 = ' '
                          AND ayf03 = ' '
                          AND ayf10 = g_aeh.aeh09     #FUN-D20047 add
                          AND ayf11 = g_aeh.aeh10     #FUN-D20047 add
                  ELSE
                  #---CHI-D20029 end------------------------------
                   SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                          '','','',ayfacti,ayfuser,ayfgrup,
                          ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                          ayf09,ayforig,ayforiu
                     INTO l_axe.* 
                     FROM ayf_file    
                    WHERE ayf01 = g_dept[i].axa02 
                      AND ayf00 = g_dept[i].axa03
	              AND ayf04 = g_aeh.aeh01
                      AND ayf09 = g_dept[i].axa01
                      AND (ayf02 <= g_aeh.aeh02 AND ayf03 >= g_aeh.aeh02)
                      AND ayf10 = g_aeh.aeh09     #FUN-D20047 add
                      AND ayf11 = g_aeh.aeh10     #FUN-D20047 add
                  END IF                                                       #CHI-D20029 add
               END IF 
               #--FUN-CA0085 end----
               IF STATUS  THEN
                  #FUN-D20047 add begin---
                  IF STATUS = 100 THEN
                     SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                       FROM ayf_file
                      WHERE ayf01 = g_dept[i].axa02
                        AND ayf09 = g_dept[i].axa01
                     IF NOT (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN      #CHI-D20029 mod
                        IF cl_null(g_aeh.aeh02) THEN
                           SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                                  '','','',ayfacti,ayfuser,ayfgrup,
                                  ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                                  ayf09,ayforig,ayforiu
                             INTO l_axe.*
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axa02
                              AND ayf00 = g_dept[i].axa03
                              AND ayf04 = g_aeh.aeh01
                              AND ayf09 = g_dept[i].axa01
                              AND ayf02 = ' '
                              AND ayf03 = ' '
                              AND ayf10 = l_ayf10
                              AND ayf11 = l_ayf11
                        ELSE
                           SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                                  '','','',ayfacti,ayfuser,ayfgrup,
                                  ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                                  ayf09,ayforig,ayforiu
                             INTO l_axe.*
                             FROM ayf_file
                            WHERE ayf01 = g_dept[i].axa02
                              AND ayf00 = g_dept[i].axa03
                              AND ayf04 = g_aeh.aeh01
                              AND ayf09 = g_dept[i].axa01
                              AND (ayf02 <= g_aeh.aeh02 AND ayf03 >= g_aeh.aeh02)
                              AND ayf10 = l_ayf10
                              AND ayf11 = l_ayf11
                        END IF             
                     END IF
                  END IF
                  #FUN-D20047 add end-----

                  IF cl_null(l_axe.axe01) THEN   #FUN-D20047 add
                  #LET g_showmsg=g_dept[i].axa03,"/",g_aeh.aeh01
                  #CALL s_errmsg('axe01,axe04',g_showmsg,g_aeh.aeh01,'aap-021',1)
                  LET g_showmsg = g_dept[i].axa02,"/",g_dept[i].axa03,"/",g_aah.aah01             #TQC-AA0098 
                  #CALL s_errmsg('axz01,,aah00,aah01',g_showmsg,g_aah.aah01,'aap-021',1)          #TQC-AA0098    #FUN-D40019 mark
                  CALL s_errmsg('axz01,,aah00,aah01',g_showmsg,g_aah.aah01,'agl1067',1)           #FUN-D40019 add
                  LET g_success = 'N'
                  CONTINUE FOREACH       
                  END IF    #FUN-D20047 add
               END IF
               IF cl_null(g_aeh.aeh31) THEN LET g_aeh.aeh31 = ' ' END IF
               IF cl_null(g_aeh.aeh32) THEN LET g_aeh.aeh32 = ' ' END IF
               IF cl_null(g_aeh.aeh33) THEN LET g_aeh.aeh33 = ' ' END IF
               IF cl_null(g_aeh.aeh34) THEN LET g_aeh.aeh34 = ' ' END IF
              #FUN-BA0111--Begin--
               IF cl_null(g_aeh.aeh04) THEN LET g_aeh.aeh04 = ' ' END IF
               IF cl_null(g_aeh.aeh05) THEN LET g_aeh.aeh05 = ' ' END IF
               IF cl_null(g_aeh.aeh06) THEN LET g_aeh.aeh06 = ' ' END IF
               IF cl_null(g_aeh.aeh07) THEN LET g_aeh.aeh07 = ' ' END IF
              #FUN-BA0111---End---

               INSERT INTO aem_file
                 (aem00,aem01,aem02,aem03,aem04,
                  aem05,aem06,aem07,aem08,aem09,aem10,
                  aem11,aem12,aem13,aem14,
                  aem15,aemlegal
                 ,aem16,aem17,aem18,aem19)                   #FUN-BA0111
               VALUES
                (g_dept[i].aaz641,g_dept[i].axa01,g_dept[i].axa02,
                 g_dept[i].axa03,l_axe.axe06,g_aeh.aeh31,
                 g_aeh.aeh32,g_aeh.aeh33,g_aeh.aeh34,
                 g_aeh.aeh09,g_aeh.aeh10,
                 g_aeh.aeh11,g_aeh.aeh12,
                 g_aeh.aeh13,g_aeh.aeh14,
                 g_dept[i].axz06,g_azw02
                ,g_aeh.aeh04,g_aeh.aeh05,g_aeh.aeh06,g_aeh.aeh07)  #FUN-BA0111
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                   UPDATE aem_file SET aem11 = aem11 + g_aeh.aeh11,
                                       aem12 = aem12 + g_aeh.aeh12,
                                       aem13 = aem13 + g_aeh.aeh13,
                                       aem14 = aem14 + g_aeh.aeh14
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                      CALL s_errmsg('aem01',g_dept[i].axa01,'upd_aem',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               ELSE
                   IF STATUS THEN
                      LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_dept[i].aaz641,"/",g_dept[i].axa03
                      CALL s_errmsg('aem01,aem02,aem00,aem04',g_showmsg,'ins_aem',status,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               END IF
           END FOREACH	　	　	　	　
       ELSE
           #不使用TIPTOP(axz04='N')資料抓aglt003(axq_file)資料匯入
           #1.axq13(關係人) 空白--> insert into aej_file
           #2.axq13(關係人) 非空白 --> insert into aek_file
           #3.group by axq14,axq15,axq16,axq17(異動碼5~8) -->insert into aem_file

          #str TQC-BB0218 mod
          #將同一公司、科目、年期、幣別的資料GROUP起來再做處理
          #LET l_sql="SELECT * FROM axq_file ",
          #          " WHERE axq01 ='",g_dept[i].axa01,"'",
          #         #"   AND axq04 ='",g_dept[i].axa03,"'",
          #          "   AND axq04 ='",g_dept[i].axa02,"'",    #TQC-AA0098
          #          "   AND axq041='",g_dept[i].axa03,"'",
          #          "   AND axq05 <> '",g_aaz113,"'",
          #          "   AND axq06 = ",tm.yy,
          #          "   AND axq07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
          #         #"   AND (axq13 IS NULL OR axq13 = '')",    #關係人      #TQC-AA0098
          #          "   ORDER BY axq04,axq06,axq07,axq05"
          #LET l_sql="SELECT axq04,axq05,axq06,axq07,SUM(axq08),SUM(axq09),SUM(axq10),SUM(axq11),axq12",	#CHI-D20029 mark
           LET l_sql="SELECT axq29,axq04,axq05,axq06,axq07,SUM(axq08),SUM(axq09),SUM(axq10),SUM(axq11),axq12",  #CHI-D20029 
                     "  FROM axq_file ",
                     " WHERE axq01 ='",g_dept[i].axa01,"'",
                     "   AND axq04 ='",g_dept[i].axa02,"'",    #TQC-AA0098
                     "   AND axq041='",g_dept[i].axa03,"'",
                     "   AND axq05 <> '",g_aaz113,"'",
                     "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
                     "                    WHERE tat05=axq05 AND tat01=axq041 AND tat02=axq06)",  #MOD-D10196
                     "   AND axq06 = ",tm.yy,
                     "   AND axq07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                    #" GROUP BY axq04,axq05,axq06,axq07,axq12",		#CHI-D20029 mark
                     " GROUP BY axq29,axq04,axq05,axq06,axq07,axq12",   #CHI-D20029
                     " ORDER BY axq04,axq06,axq07,axq05"
          #end TQC-BB0218 mod
           PREPARE p000_axq_p1 FROM l_sql
           IF STATUS THEN
               LET g_showmsg= tm.yy,"/",g_dept[i].axa03,"/",g_dept[i].axa03     #NO.FUN-710023
               CALL s_errmsg('axq06,axq04,axq041',g_showmsg ,'prepare:3',STATUS,1)  #NO.FUN-710023
               LET g_success = 'N'
               CONTINUE FOR           
           END IF
           DECLARE p000_axq_c1 CURSOR FOR p000_axq_p1
           INITIALIZE g_axq.* TO NULL
          #FOREACH p000_axq_c1 INTO g_axq.*                                                      #TQC-BB0218 mark
          #FOREACH p000_axq_c1 INTO g_axq.axq04,g_axq.axq05,g_axq.axq06,g_axq.axq07,             #CHI-D20029 mark   #TQC-BB0218        
           FOREACH p000_axq_c1 INTO l_axq29,g_axq.axq04,g_axq.axq05,g_axq.axq06,g_axq.axq07,     #FUN-D20029 
                                    g_axq.axq08,g_axq.axq09,g_axq.axq10,g_axq.axq11,g_axq.axq12  #TQC-BB0218

               IF SQLCA.sqlcode THEN 
                  LET g_showmsg= tm.yy,"/",g_dept[i].axa03,"/",g_dept[i].axa03      
                  CALL s_errmsg('axq06,axq04,axq041',g_showmsg,'p000_axq_c1',SQLCA.sqlcode,1)  
                  LET g_success = 'N'   
                  CONTINUE FOREACH     
               END IF
               IF g_axq.axq08 =0 AND g_axq.axq09=0 THEN CONTINUE FOREACH END IF   #CHI-D20029
               LET l_axe.axe11 = '1'
               LET l_axe.axe12 = '1'
               DISPLAY g_axq.axq07,'->',l_axe.axe06,' ',g_axq.axq05,' ',g_axq.axq08,' ',g_axq.axq09
               
               #--CHI-D20029 START--
               IF g_dept[i].axz10 = 'Y' THEN
                   SELECT UNIQUE ayf10,ayf11 INTO l_ayf10,l_ayf11
                     FROM ayf_file    
                    WHERE ayf01 = g_dept[i].axa02
                      AND ayf09 = g_dept[i].axa01    
                      AND ayf10 = g_axq.axq06
                      AND ayf11 = g_axq.axq07
                   IF STATUS  THEN
                       SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                         FROM ayf_file    
                        WHERE ayf01 = g_dept[i].axa02
                          AND ayf09 = g_dept[i].axa01
                   END IF
               END IF
               #--CHI-D20029 end--
               IF (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN      #CHI-D20029 mod
               #抓取合併財報科目編號(axe06),
               SELECT * INTO l_axe.* FROM axe_file    
                WHERE axe01 = g_dept[i].axa02 
                  AND axe00 = g_dept[i].axa03
		  AND axe04 = g_axq.axq05
                  AND axe13 = g_dept[i].axa01
               #--CHI-D20029 start--
               ELSE
                   IF cl_null(l_axq29) OR l_axq29 ='' THEN                
                        SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                               '','','',ayfacti,ayfuser,ayfgrup,
                               ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                               ayf09,ayforig,ayforiu
                          INTO l_axe.* 
                          FROM ayf_file    
                         WHERE ayf01 = g_dept[i].axa02 
                           AND ayf00 = g_dept[i].axa03
	                   AND ayf04 = g_axq.axq05
                           AND ayf09 = g_dept[i].axa01
                           AND ayf02 = ' '
                           AND ayf03 = ' '
                           AND ayf10 = l_ayf10
                           AND ayf11 = l_ayf11
                   ELSE
                        SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                               '','','',ayfacti,ayfuser,ayfgrup,
                               ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                               ayf09,ayforig,ayforiu
                          INTO l_axe.* 
                          FROM ayf_file    
                         WHERE ayf01 = g_dept[i].axa02 
                           AND ayf00 = g_dept[i].axa03
	                   AND ayf04 = g_axq.axq05
                           AND ayf09 = g_dept[i].axa01
                           AND (ayf02 <= g_aah.aeh02 AND ayf03 >= g_aah.aeh02)
                           AND ayf10 = l_ayf10
                           AND ayf11 = l_ayf11
                   END IF                          
               END IF 
               #---CHI-D20029 end--------
               IF STATUS THEN 
                  LET g_showmsg = g_dept[i].axa02,"/",g_dept[i].axa03,"/",g_axq.axq05    #MOD-B70099
                 #CALL s_errmsg(' ',' ',g_axq.axq05,'aap-021',1)                         #MOD-B70099 mark 
                 #CALL s_errmsg('axz01,aah00,aah01',g_showmsg,g_axq.axq05,'aap-021',1)   #MOD-B70099   #FUN-D40019 mark
                  CALL s_errmsg('axz01,aah00,aah01',g_showmsg,g_axq.axq05,'agl1067',1)   #FUN-D40019 add
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               #---FUN-B90093 start--
               IF g_aaz130 = '2' THEN
                   LET l_month = 0
                   LET l_axq08 = 0
                   LET l_axq09 = 0
                   SELECT MAX(axq07) INTO l_month
                     FROM axq_file
                    WHERE axq01 =g_dept[i].axa01
                      AND axq04 =g_dept[i].axa02
                      AND axq041=g_dept[i].axa03
                      AND axq06 = tm.yy
                      AND axq07 < g_axq.axq07
                   IF l_month <> 0 THEN
                      SELECT SUM(axq08),SUM(axq09) INTO l_axq08,l_axq09
                        FROM axq_file
                       WHERE axq01 =g_dept[i].axa01
                         AND axq04 =g_dept[i].axa02
                         AND axq041=g_dept[i].axa03
                         AND axq05 = g_axq.axq05
                         AND axq06 = tm.yy
                         AND axq07 = l_month
                     #---------------MOD-BA0104------------START
                      IF cl_null(l_axq08) THEN
                         LET l_axq08 = 0
                      END IF
                      IF cl_null(l_axq09) THEN
                         LET l_axq09 = 0
                      END IF
                     #---------------MOD-BA0104--------------END
                      LET g_axq.axq08 = g_axq.axq08 - l_axq08
                      LET g_axq.axq09 = g_axq.axq09 - l_axq09
                   END IF
               END IF
               #---FUN-B90093 end---------
               INSERT INTO aej_file                                                                                                                        
                 (aej00,aej01,aej02,aej03,
                  aej04,aej05,aej06,aej07,
                  aej08,aej09,aej10,aej11,aejlegal)
               VALUES                                                                                                                                     
                 (g_dept[i].aaz641,g_dept[i].axa01,
                  g_dept[i].axa02,g_dept[i].axa03,  
                  l_axe.axe06,g_axq.axq06,
                  g_axq.axq07,g_axq.axq08,
                  g_axq.axq09,g_axq.axq10,
                  g_axq.axq11,g_axq.axq12,g_azw02)
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                   UPDATE aej_file SET aej07 = aej07 + g_axq.axq08,
                                       aej08 = aej08 + g_axq.axq09,
                                       aej09 = aej09 + g_axq.axq10,
                                       aej10 = aej10 + g_axq.axq11
                    WHERE aej00 = g_dept[i].aaz641
                      AND aej01 = g_dept[i].axa01                                                                                                         
                      AND aej02 = g_dept[i].axa02                                                                                                         
                      AND aej03 = g_dept[i].axa03                                                                                                         
                      AND aej04= l_axe.axe06
                      AND aej05 = g_axq.axq06
                      AND aej06 = g_axq.axq07
                      AND aej11 = g_axq.axq12
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                       CALL s_errmsg('axg01',g_dept[i].axa01,'upd_aej',SQLCA.sqlcode,1)                                                                       
                       LET g_success = 'N'                                                                                                                    
                       CONTINUE FOREACH     
                   END IF                                                                                                                                    
               ELSE                                                                                                                                        
                   IF STATUS THEN                                                                                                                            
                      CALL s_errmsg('axg01',g_dept[i].axa01,'ins_aej',status,1)                                                                              
                      LET g_success = 'N'                                                                                                                    
                      CONTINUE FOREACH   
                   END IF                                                                                                                                    
               END IF                                        
           END FOREACH   
  
           LET l_sql="SELECT * FROM axq_file ", 
                     " WHERE axq01 ='",g_dept[i].axa01,"'", 
                     #"   AND axq04 ='",g_dept[i].axa03,"'", 
                     "   AND axq04 ='",g_dept[i].axa02,"'",   #TQC-AA0098
                     "   AND axq041='",g_dept[i].axa03,"'",
                     "   AND axq05 <> '",g_aaz113,"'",
                     "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
                     "                    WHERE tat05=axq05 AND tat01=axq041 AND tat02=axq06)",  #MOD-D10196
                     "   AND axq06 = ",tm.yy,
                     "   AND axq07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                     #"   AND axq13 IS NOT NULL",    #關係人     
                     "   AND (axq13 IS NOT NULL AND axq13 <> ' ')",    #關係人     #FUN-AA0098
                     "   ORDER BY axq04,axq06,axq07,axq05"
           PREPARE p000_axq_p2 FROM l_sql
           IF STATUS THEN
               LET g_showmsg= tm.yy,"/",g_dept[i].axa03,"/",g_dept[i].axa03     
               CALL s_errmsg('axq06,axq04,axq041',g_showmsg ,'prepare:p000_axq_p2',STATUS,1) 
               LET g_success = 'N'
               CONTINUE FOR           
           END IF
           DECLARE p000_axq_c2 CURSOR FOR p000_axq_p2
           INITIALIZE g_axq.* TO NULL
           FOREACH p000_axq_c2 INTO g_axq.*
               IF SQLCA.sqlcode THEN 
                  LET g_showmsg= tm.yy,"/",g_dept[i].axa03,"/",g_dept[i].axa03      
                  CALL s_errmsg('axq06,axq04,axq041',g_showmsg,'p000_axq_c2',SQLCA.sqlcode,1)  
                  LET g_success = 'N'   
                  CONTINUE FOREACH     
               END IF
               IF g_axq.axq08 =0 AND g_axq.axq09=0 THEN CONTINUE FOREACH END IF   #CHI-D20029
               LET l_axe.axe11 = '1'
               LET l_axe.axe12 = '1'
               DISPLAY g_axq.axq07,'->',l_axe.axe06,' ',g_axq.axq05,' ',g_axq.axq08,' ',g_axq.axq09
               
#FUN-B70103   ---start   Add
               LET l_aal03 = NULL
               SELECT aal03 INTO l_aal03 FROM aal_file
                WHERE aal01 = g_dept[i].axa02
                  AND aal02 = g_axq.axq13
               IF NOT cl_null(l_aal03) THEN
                  LET g_axq.axq13 = l_aal03
               END IF
#FUN-B70103   ---end     Add

               #--CHI-D20029 START--
               IF g_dept[i].axz10 = 'Y' THEN
                   SELECT UNIQUE ayf10,ayf11 INTO l_ayf10,l_ayf11
                     FROM ayf_file    
                    WHERE ayf01 = g_dept[i].axa02
                      AND ayf09 = g_dept[i].axa01    
                      AND ayf10 = tm.yy
                      AND ayf11 = tm.em
                   IF STATUS  THEN
                       SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                         FROM ayf_file    
                        WHERE ayf01 = g_dept[i].axa02
                          AND ayf09 = g_dept[i].axa01
                   END IF
               END IF
               #--CHI-D20029 end--

               IF (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN      #CHI-D20029 mod
               #抓取合併財報科目編號(axe06),
               SELECT * INTO l_axe.* FROM axe_file    
                WHERE axe01 = g_dept[i].axa02 
                  AND axe00 = g_dept[i].axa03
		  AND axe04 = g_axq.axq05
                  AND axe13 = g_dept[i].axa01
               #--CHI-D20029 start--
               ELSE
                   IF cl_null(g_axq.axq29) OR g_axq.axq29 ='' THEN                
                        SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                               '','','',ayfacti,ayfuser,ayfgrup,
                               ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                               ayf09,ayforig,ayforiu
                          INTO l_axe.* 
                          FROM ayf_file    
                         WHERE ayf01 = g_dept[i].axa02 
                           AND ayf00 = g_dept[i].axa03
	                   AND ayf04 = g_axq.axq05
                           AND ayf09 = g_dept[i].axa01
                           AND ayf02 = ' '
                           AND ayf03 = ' '
                           AND ayf10 = l_ayf10
                           AND ayf11 = l_ayf11
                   ELSE
                        SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                               '','','',ayfacti,ayfuser,ayfgrup,
                               ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                               ayf09,ayforig,ayforiu
                          INTO l_axe.* 
                          FROM ayf_file    
                         WHERE ayf01 = g_dept[i].axa02 
                           AND ayf00 = g_dept[i].axa03
	                   AND ayf04 = g_axq.axq05
                           AND ayf09 = g_dept[i].axa01
                           AND (ayf02 <= g_aah.aeh02 AND ayf03 >= g_aah.aeh02)
                           AND ayf10 = l_ayf10
                           AND ayf11 = l_ayf11
                   END IF                          
               END IF 
               #---CHI-D20029 end--------
               IF STATUS THEN 
                  LET g_showmsg = g_dept[i].axa02,"/",g_dept[i].axa03,"/",g_axq.axq05     #MOD-B70099
                 #CALL s_errmsg(' ',' ',g_axq.axq05,'aap-021',1)                          #MOD-B70099 mark 
                 #CALL s_errmsg('axz01,aah00,aah01',g_showmsg,g_axq.axq05,'aap-021',1)    #MOD-B70099    #FUN-D40019 mark
                  CALL s_errmsg('axz01,aah00,aah01',g_showmsg,g_axq.axq05,'agl1067',1)    #FUN-D40019 add 
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               #---FUN-B90093 start--
               IF g_aaz130 = '2' THEN
                   LET l_month = 0
                   LET l_axq08 = 0
                   LET l_axq09 = 0
                   SELECT MAX(axq07) INTO l_month
                     FROM axq_file
                    WHERE axq01 =g_dept[i].axa01
                      AND axq04 =g_dept[i].axa02
                      AND axq041=g_dept[i].axa03
                      AND axq06 = tm.yy
                     #AND (axq13 IS NOT NULL AND axq13 <> ' ')  #MOD-BB0291 mark
                      AND axq13 = g_axq.axq13                   #MOD-BB0291
                      AND axq07 < g_axq.axq07
                   IF l_month <> 0 THEN
                      SELECT SUM(axq08),SUM(axq09)
                        INTO l_axq08,l_axq09
                        FROM axq_file
                       WHERE axq01 =g_dept[i].axa01
                         AND axq04 =g_dept[i].axa02
                         AND axq041=g_dept[i].axa03
                         AND axq05 = g_axq.axq05
                         AND axq06 = tm.yy
                        #AND (axq13 IS NOT NULL AND axq13 <> ' ')  #MOD-BB0291 mark
                         AND axq13 = g_axq.axq13                   #MOD-BB0291
                         AND axq07 = l_month
                     #---------------MOD-BA0104------------START
                      IF cl_null(l_axq08) THEN
                         LET l_axq08 = 0
                      END IF
                      IF cl_null(l_axq09) THEN
                         LET l_axq09 = 0
                      END IF
                     #---------------MOD-BA0104--------------END
                      LET g_axq.axq08 = g_axq.axq08 - l_axq08
                      LET g_axq.axq09 = g_axq.axq09 - l_axq09
                   END IF
               END IF
               #---FUN-B90093 end---------
               INSERT INTO aek_file 
                  (aek00,aek01,aek02,aek03,aek04,aek05,
                   aek06,aek07,aek08,aek09,aek10,aek11,aek12,aeklegal)    #MOD-B30441 aeklegal
               VALUES 
                  (g_dept[i].aaz641,g_dept[i].axa01,g_dept[i].axa02,  
                   g_dept[i].axa03,l_axe.axe06,g_axq.axq13,  
                   g_axq.axq06,g_axq.axq07,g_axq.axq08,
                   g_axq.axq09,g_axq.axq10,g_axq.axq11,
                   g_axq.axq12,g_azw02)
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                  UPDATE aek_file SET aek08 = aek08 + g_axq.axq08,
                                      aek09 = aek09 + g_axq.axq09,
                                      aek10 = aek10 + g_axq.axq10,
                                      aek11 = aek11 + g_axq.axq11
                      WHERE aek00 = g_dept[i].aaz641
                        AND aek01 = g_dept[i].axa01
                        AND aek02 = g_dept[i].axa02
                        AND aek03 = g_dept[i].axa03
                        AND aek04 = l_axe.axe06
                        AND aek05 = g_axq.axq13
                        AND aek06 = g_axq.axq06
                        AND aek07 = g_axq.axq07
                        AND aek12 = g_axq.axq12
                  #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                     CALL s_errmsg('aek01',g_dept[i].axa01,'upd_aek',SQLCA.sqlcode,1) 
                     LET g_success = 'N' 
                     CONTINUE FOREACH  
                  END IF
               ELSE
                  IF STATUS THEN 
                     LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_dept[i].aaz641,"/",g_dept[i].axa03      
                     CALL s_errmsg('aek01,aek02,aek03,aek04,aek05',g_showmsg,'ins_aek',status,1)                
                     LET g_success = 'N'
                     CONTINUE FOREACH       
                  END IF
               END IF                          
           END FOREACH

           LET l_sql="SELECT * FROM axq_file ", 
                     " WHERE axq01 ='",g_dept[i].axa01,"'", 
                     #"   AND axq04 ='",g_dept[i].axa03,"'", 
                     "   AND axq04 ='",g_dept[i].axa02,"'",   #TQC-AA0098
                     "   AND axq041='",g_dept[i].axa03,"'",
                     "   AND axq05 <> '",g_aaz113,"'",
                     "   AND NOT EXISTS (SELECT 1 FROM ",cl_get_target_table(l_axz03,'tat_file'),#MOD-D10196
                     "                    WHERE tat05=axq05 AND tat01=axq041 AND tat02=axq06)",  #MOD-D10196
                     "   AND axq06 = ",tm.yy,
                     "   AND axq07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                   # "   GROUP BY axq14,axq15,axq16,axq17 ",                    #No.MOD-BB0138 mark
                     "   ORDER BY axq04,axq06,axq07,axq05"

           PREPARE p000_axq_p3 FROM l_sql
           IF STATUS THEN
               LET g_showmsg= tm.yy,"/",g_dept[i].axa03,"/",g_dept[i].axa03     
               CALL s_errmsg('axq06,axq04,axq041',g_showmsg ,'prepare:p000_axq_p3',STATUS,1) 
               LET g_success = 'N'
               CONTINUE FOR           
           END IF
           DECLARE p000_axq_c3 CURSOR FOR p000_axq_p3
           INITIALIZE g_axq.* TO NULL
           FOREACH p000_axq_c3 INTO g_axq.*
               IF SQLCA.sqlcode THEN 
                  LET g_showmsg= tm.yy,"/",g_dept[i].axa03,"/",g_dept[i].axa03      
                  CALL s_errmsg('axq06,axq04,axq041',g_showmsg,'p000_axq_c3',SQLCA.sqlcode,1)  
                  LET g_success = 'N'   
                  CONTINUE FOREACH     
               END IF
               IF g_axq.axq08 =0 AND g_axq.axq09=0 THEN CONTINUE FOREACH END IF   #CHI-D20029
               LET l_axe.axe11 = '1'
               LET l_axe.axe12 = '1'
               DISPLAY g_axq.axq07,'->',l_axe.axe06,' ',g_axq.axq05,' ',g_axq.axq08,' ',g_axq.axq09
               
               #--CHI-D20029 START--
               IF g_dept[i].axz10 = 'Y' THEN
                   SELECT UNIQUE ayf10,ayf11 INTO l_ayf10,l_ayf11
                     FROM ayf_file    
                    WHERE ayf01 = g_dept[i].axa02
                      AND ayf09 = g_dept[i].axa01    
                      AND ayf10 = g_axq.axq06
                      AND ayf11 = g_axq.axq07
                   IF STATUS  THEN
                       SELECT MAX(ayf10),MAX(ayf11) INTO l_ayf10,l_ayf11
                         FROM ayf_file    
                        WHERE ayf01 = g_dept[i].axa02
                          AND ayf09 = g_dept[i].axa01
                   END IF
               END IF
               #--CHI-D20029 end--
               IF (g_dept[i].axz10 = 'N' OR cl_null(g_dept[i].axz10)) THEN      #CHI-D20029 mod
               #抓取合併財報科目編號(axe06),
               SELECT * INTO l_axe.* FROM axe_file    
                WHERE axe01 = g_dept[i].axa02 
                  AND axe00 = g_dept[i].axa03
		  AND axe04 = g_axq.axq05
                  AND axe13 = g_dept[i].axa01
               #--CHI-D20029 start--
               ELSE
                   IF cl_null(l_axq29) OR l_axq29 ='' THEN                
                        SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                               '','','',ayfacti,ayfuser,ayfgrup,
                               ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                               ayf09,ayforig,ayforiu
                          INTO l_axe.* 
                          FROM ayf_file    
                         WHERE ayf01 = g_dept[i].axa02 
                           AND ayf00 = g_dept[i].axa03
	                   AND ayf04 = g_axq.axq05
                           AND ayf09 = g_dept[i].axa01
                           AND ayf02 = ' '
                           AND ayf03 = ' '
                           AND ayf10 = l_ayf10
                           AND ayf11 = l_ayf11
                   ELSE
                        SELECT ayf01,'','','',ayf04,ayf05,ayf06,'',
                               '','','',ayfacti,ayfuser,ayfgrup,
                               ayfmodu,ayfdate,ayf07,ayf08,ayf00,
                               ayf09,ayforig,ayforiu
                          INTO l_axe.* 
                          FROM ayf_file    
                         WHERE ayf01 = g_dept[i].axa02 
                           AND ayf00 = g_dept[i].axa03
	                   AND ayf04 = g_axq.axq05
                           AND ayf09 = g_dept[i].axa01
                           AND (ayf02 <= g_aah.aeh02 AND ayf03 >= g_aah.aeh02)
                           AND ayf10 = l_ayf10
                           AND ayf11 = l_ayf11
                   END IF                          
               END IF 
               #---CHI-D20029 end--------
               IF STATUS THEN 
                  LET g_showmsg = g_dept[i].axa02,"/",g_dept[i].axa03,"/",g_axq.axq05     #MOD-B70099
                 #CALL s_errmsg(' ',' ',g_axq.axq05,'aap-021',1)                          #MOD-B70099 mark 
                 #CALL s_errmsg('axz01,aah00,aah01',g_showmsg,g_axq.axq05,'aap-021',1)    #MOD-B70099   #FUN-D40019 mark
                  CALL s_errmsg('axz01,aah00,aah01',g_showmsg,g_axq.axq05,'agl1067',1)    #FUN-D40019 add
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               IF cl_null(g_axq.axq14) THEN LET g_axq.axq14 = ' ' END IF
               IF cl_null(g_axq.axq15) THEN LET g_axq.axq15 = ' ' END IF
               IF cl_null(g_axq.axq16) THEN LET g_axq.axq16 = ' ' END IF
               IF cl_null(g_axq.axq17) THEN LET g_axq.axq17 = ' ' END IF
               INSERT INTO aem_file
                 (aem00,aem01,aem02,aem03,aem04,
                  aem05,aem06,aem07,aem08,aem09,
                  aem10,aem11,aem12,aem13,aem14,
                  aem15,aemlegal)
               VALUES
                (g_dept[i].aaz641,g_dept[i].axa01,g_dept[i].axa02,
                 g_dept[i].axa03,l_axe.axe06,g_axq.axq14,
                 g_axq.axq15,g_axq.axq16,g_axq.axq17,
                 g_axq.axq06,g_axq.axq07,g_axq.axq08,
                 g_axq.axq09,g_axq.axq10,g_axq.axq11,
                 g_axq.axq12,g_azw02)
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                   UPDATE aem_file SET aem11 = aem11 + g_axq.axq08,
                                       aem12 = aem12 + g_axq.axq09,
                                       aem13 = aem13 + g_axq.axq10,
                                       aem14 = aem14 + g_axq.axq11
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                      CALL s_errmsg('aem01',g_dept[i].axa01,'upd_aem',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               ELSE
                   IF STATUS THEN
                      LET g_showmsg=g_dept[i].axa01,"/",g_dept[i].axa02,"/", g_dept[i].aaz641,"/",g_dept[i].axa03
                      CALL s_errmsg('aem01,aem02,aem00,aem04',g_showmsg,'ins_aem',status,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               END IF
           END FOREACH	　	　	　	　
       END IF 
       #FUN-D20046 add begin---
       IF g_success = 'Y' THEN
          SELECT COUNT(*) INTO l_n
            FROM axa_file
           WHERE axa01 = g_dept[i].axa01
             AND axa02 = g_dept[i].axa02
             AND axa03 = g_dept[i].axa03
          IF l_n > 0 THEN
             UPDATE axa_file SET axa10 = tm.yy,
                                 axa11= tm.em
              WHERE axa01 = g_dept[i].axa01
                AND axa02 = g_dept[i].axa02
                AND axa03 = g_dept[i].axa03
          END IF

          SELECT COUNT(*) INTO l_n
            FROM axb_file
           WHERE axb01 = g_dept[i].axa01
             AND axb04 = g_dept[i].axa02
             AND axb05 = g_dept[i].axa03
          IF l_n > 0 THEN
             UPDATE axb_file SET axb14 = tm.yy,
                                 axb15= tm.em
              WHERE axb01 = g_dept[i].axa01
                AND axb04 = g_dept[i].axa02
                AND axb05 = g_dept[i].axa03
          END IF
       END IF
       #FUN-D20046 add end-----

    END FOR

    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
  
    IF g_success="N" THEN
       RETURN
    END IF 
END FUNCTION
   
FUNCTION p000_del(p_i) 
DEFINE p_i   LIKE type_file.num5

  #-->delete aej_file
  DELETE FROM aej_file
   WHERE aej00 = g_dept[p_i].aaz641
     AND aej01 = g_dept[p_i].axa01
     AND aej02 = g_dept[p_i].axa02
     AND aej05 = tm.yy
     AND aej06 BETWEEN tm.bm AND tm.em
  IF SQLCA.sqlcode THEN
     LET g_showmsg=g_dept[p_i].aaz641,"/",g_dept[p_i].axa01,"/",g_dept[p_i].axa02
     CALL s_errmsg('aaz641,axa01,axa02',g_showmsg,'DELETE aej_file',STATUS,1)
     LET g_success = 'N'
     RETURN
  END IF

  #-->delete aek_file
  DELETE FROM aek_file
   WHERE aek00 = g_dept[p_i].aaz641
     AND aek01 = g_dept[p_i].axa01
     AND aek02 = g_dept[p_i].axa02
     AND aek06 = tm.yy
     AND aek07 BETWEEN tm.bm AND tm.em
  IF SQLCA.sqlcode THEN 
     LET g_showmsg=g_dept[p_i].aaz641,"/",g_dept[p_i].axa01,"/",g_dept[p_i].axa02
     CALL s_errmsg('aaz641,axa01,axa02',g_showmsg,'DELETE aek_file',STATUS,1)
     LET g_success = 'N'
     RETURN 
  END IF 

  #-->delete aem_file
  DELETE FROM aem_file
   WHERE aem00 = g_dept[p_i].aaz641
     AND aem01 = g_dept[p_i].axa01
     AND aem02 = g_dept[p_i].axa02
     AND aem09 = tm.yy
     AND aem10 BETWEEN tm.bm AND tm.em
  IF SQLCA.sqlcode THEN 
     LET g_showmsg=g_dept[p_i].aaz641,"/",g_dept[p_i].axa01,"/",g_dept[p_i].axa02
     CALL s_errmsg('aaz641,axa01,axa02',g_showmsg,'DELETE aem_file',STATUS,1)
     LET g_success = 'N'
     RETURN 
  END IF 
END FUNCTION
