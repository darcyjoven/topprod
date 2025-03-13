# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gglp101.4gl
# Descriptions...: 合併個體科餘匯入作業
# Input parameter: 
# Modify.......... No.FUN-A90027 10/09/13 BY yiting 
# Modify.........: No.TQC-AA0098 10/10/16 yiting 畫面qbe改為asg01
# Modify.........: No.FUN-AA0098 10/11/04 BY yiting 取asi_file為資料時，異動碼asi13亦不可為空字串
# Modify.........: No.TQC-B30100 11/03/11 BY zhangweib 將程序中的MATCHES修改成ORACLE能識別的IN  
# Modify.........: No.MOD-B30236 11/03/12 By lutingting db后不跟:,改為.
# Modify.........: No.MOD-B30441 11/03/14 By huangrh asnlegal
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-B40015 11/04/01 BY yiting   sql錯誤
# Modify.........: No.FUN-B50001 11/05/04 By zhangweib 考慮族群是否为分层合并
#                                                       asm,asn新加栏位给值
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數改為asz_file
# Modify.........: No.FUN-B60159 11/07/01 By lutingting 非TIPTOP公司在刪除時應只刪除當期資料
# Modify.........: No.MOD-B70099 11/07/12 BY Dido 訊息說明調整 
# Modify.........: No.TQC-B70117 11/07/13 By guoch 修改g_aed循環中報錯信息
# Modify.........: No.MOD-B70230 11/07/22 By Sarah 抓aeh_file的SQL,增加過濾aeh31,aeh32,aeh33,aeh34其中一者有值時才抓
# Modify.........: No.FUN-B70103 11/08/19 By zhangweib 將aed02和asi13轉換成aal03
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No.FUN-B90019 11/09/02 By lutingting增加匯率的處理
# Modify.........: No.FUN-B90034 11/09/05 By lutingting若分層合併且合併個體既是上層公司又是下層公司,也從asi_file中撈資料
#                                                      從asi_file撈取資料時也要增加匯率的處理;
#                                                      處理合併價差時要講同一年度以前月份已計提的合併價差扣減掉
# Modify.........: No.FUN-B90051 11/09/05 By lutingting從asi_file抓資料無論是否為分層合併都要重新計算匯率
# Modify.........: No.FUN-B90057 11/09/06 By lutingting 1:增加損益類科目價差處理,產生至調整憑證
#                                                       2:同一科目合併前金額相等,若合併后金額不等,則將差額調整至最大一筆ass_file中
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr
# Modify.........: NO.TQC-C70091 12/07/18 By lujh asa01開窗時，應加判斷，asa04=Y（是最上層公司）
# Modify.........: NO.FUN-C80020 12/08/08 By Carrier 增加key 值字段 asm20 合并年度 asm21 合并期别
# Modify.........: No.TQC-C90057 12/09/11 By Carrier asj09/asj11/asj12空时赋值
# Modify.........: No.MOD-CB0173 12/11/19 By Carrier INSERT ask_file时赋值错误
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm      RECORD   
               yy        LIKE type_file.num5,   #匯入會計年度   #FUN-A90027
               bm        LIKE type_file.num5,   #起始期間     
               em        LIKE type_file.num5,   #截止期間    
               asa01     LIKE asa_file.asa01    #族群代號    #FUN-BB0036
              ,aac01     LIKE aac_file.aac01    #調整單別       #FUN-B90057
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
       g_amt      LIKE asr_file.asr08,   
       g_affil    LIKE ask_file.ask05,             
       g_dc       LIKE ask_file.ask06,            
       g_flag_r   LIKE type_file.chr1,           
       g_yy       LIKE type_file.num5,          
       g_mm       LIKE type_file.num5,         
       g_em       LIKE type_file.chr10       
#DEFINE g_aaz641        LIKE aaz_file.aaz641   #FUN-B50001 
DEFINE g_asz01         LIKE asz_file.asz01
#DEFINE g_aaz113        LIKE aaz_file.aaz113  #FUN-B50001 
DEFINE g_asz05         LIKE asz_file.asz05
DEFINE g_dbs_asg03     LIKE type_file.chr21   
DEFINE g_asg03         LIKE asg_file.asg03   
DEFINE g_sql           STRING               
#DEFINE g_aaz641_asa03  LIKE aaz_file.aaz641   #FUN-B50001 
DEFINE g_asz01_asa03   LIKE asz_file.asz01
DEFINE g_dbs_asa03     LIKE type_file.chr21  
DEFINE g_newno         LIKE asj_file.asj01    
DEFINE g_asa        DYNAMIC ARRAY OF RECORD        
                    asa01      LIKE asa_file.asa01,  #族群代號
                    asa02      LIKE asa_file.asa02   #上層公司
                    END RECORD 
DEFINE g_dept       DYNAMIC ARRAY OF RECORD        
                    asa01      LIKE asa_file.asa01,  #族群代號
                    asa02      LIKE asa_file.asa02,  #合併個體
                    asa03      LIKE asa_file.asa03,  #合併個體帳別
                    #aaz641     LIKE aaz_file.aaz641, #合併帳別  #FUN-B50001
                    asz01      LIKE asz_file.asz01, #合併帳別
                    asg06      LIKE asg_file.asg06   #記帳幣別
                    END RECORD
DEFINE l_rate       LIKE ase_file.ase05             #功能幣別匯率    
DEFINE l_rate1      LIKE ase_file.ase05             #記帳幣別匯率   
DEFINE g_azw02      LIKE azw_file.azw02      
DEFINE g_aah        RECORD LIKE aah_file.*
DEFINE g_aed        RECORD LIKE aed_file.*
DEFINE g_asi        RECORD LIKE asi_file.*
DEFINE g_aeh        RECORD 
                    aeh01  LIKE aeh_file.aeh01,
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
                    END RECORD
#FUN-B80135--add--str--
DEFINE g_year              LIKE type_file.chr4
DEFINE g_month             LIKE type_file.chr2
#FUN-B80135--add—end--
#FUN-B90019--add--str--
DEFINE g_asa05      LIKE asa_file.asa05
DEFINE g_asa06      LIKE asa_file.asa06
DEFINE g_date_e     LIKE type_file.dat 
DEFINE g_asz        RECORD LIKE asz_file.*
#FUN-B90019--add--end
MAIN

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy    = ARG_VAL(1)
   LET tm.bm    = ARG_VAL(2)
   LET tm.em    = ARG_VAL(3)
   LET tm.asa01 = ARG_VAL(4)
   LET tm1.wc   = ARG_VAL(5)                         #QBE條件
   LET g_bgjob  = ARG_VAL(6)
   LET tm.aac01 = ARG_VAL(7)      #FUN-B90057
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00='0'  #FUN-B80135

   #FUN-B80135--add--str--
    SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0'
    LET g_year = YEAR(g_aaa07)
    LET g_month= MONTH(g_aaa07)
    #FUN-B80135--add--end
     SELECT * INTO g_asz.* FROM asz_file WHERE asz00 = '0' #FUN-B90019 
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL gglp101_tm(0,0)
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
              CLOSE WINDOW gglp101_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        #FUN-B80135--mod--str--
        #SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07    
        #FROM aaa_file WHERE aaa01 = g_bookno
        #現行會計年度(aaa04)、現行期別(aaa05)
        SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
          FROM aaa_file WHERE aaa01 = g_asz01
        #FUN-B80135--mod--end--
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

FUNCTION gglp101_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,   
           l_cnt          LIKE type_file.num5   
   DEFINE  lc_cmd         LIKE type_file.chr1000    
   DEFINE  l_asa09        LIKE asa_file.asa09       
        
   IF s_shut(0) THEN RETURN END IF
  #CALL s_dsmark(g_bookno)   #FUN-B80135

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW gglp101_w AT p_row,p_col WITH FORM "ggl/42f/gglp101" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()

  # Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)  #FUN-B80135
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL                   # Defaealt condition
   #FUN-B80135--mark--str--
   # SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07   
   #   FROM aaa_file 
   #  WHERE aaa01 = g_bookno
   #FUN-B80135--mark—end--
   #FUN-B80135--add--str-- 
   #現行會計年度(aaa04)、現行期別(aaa05)
      SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05
        FROM aaa_file WHERE aaa01 = g_asz01
   #FUN-B80135--add--end--
      LET tm.yy = g_aaa04
      LET tm.bm = 0              
      DISPLAY tm.bm TO FORMONLY.bm 
      LET tm.em = g_aaa05
      LET g_bgjob = 'N'     

      INPUT BY NAME tm.yy,tm.em,tm.asa01,tm.aac01   #FUN-B90057 add aac01
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE   
            EXIT INPUT         
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               NEXT FIELD yy
            END IF
         #FUN-B80135--add--str--
             IF NOT cl_null(tm.yy) THEN
                IF tm.yy < 0 THEN
                   CALL cl_err(tm.yy,'apj-035',0)
                   NEXT FIELD yy
                END IF
                IF tm.yy<g_year  THEN
                   CALL cl_err(tm.yy,'atp-164',0)
                   NEXT FIELD yy
                END IF
                IF tm.yy=g_year AND tm.em<=g_month  THEN
                   CALL cl_err(tm.em,'atp-164',0)
                   NEXT FIELD em
                END IF
             END IF        
         #FUN-B80135--add--end --      

         AFTER FIELD em    
            IF NOT cl_null(tm.em) THEN
               IF tm.bm >tm.em  THEN 
                  CALL cl_err('','9011',0) NEXT FIELD em 
               END IF
               #FUN-B80135---ADD--STR---
                IF NOT cl_null(tm.yy) AND tm.yy=g_year AND tm.em<=g_month THEN
                   CALL cl_err(tm.em,'atp-164',0)
                   NEXT FIELD em
                END IF
               #FUN-B80135---ADD--END---
               LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))   #FUN-B90019
            END IF

         AFTER FIELD asa01
            IF NOT cl_null(tm.asa01) THEN
               SELECT DISTINCT asa01 FROM asa_file WHERE asa01=tm.asa01 
               IF STATUS THEN
                  CALL cl_err(tm.asa01,'agl031',1) 
                  NEXT FIELD asa01 
               END IF
            END IF
         #FUN-B90057--add--str--
         AFTER FIELD aac01
           IF NOT cl_null(tm.aac01) THEN
              CALL p000_aac01(tm.aac01)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('aac01',g_errno,0)
                 NEXT FIELD aac01
              END IF
           ELSE
              NEXT FIELD aac01
           END IF
         #FUN-B90057--add--end

         #ON ACTION CONTROLZ    #TQC-C40010  mark
         ON ACTION CONTROLR     #TQC-C40010  add
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asa01) 
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_asa"
                  LET g_qryparam.form = "q_asa1"    #TQC-AA0098
                  LET g_qryparam.default1 = tm.asa01
                  LET g_qryparam.where = " asa04 = 'Y' "    #TQC-C70091  add
                  CALL cl_create_qry() RETURNING tm.asa01
                  DISPLAY BY NAME tm.asa01
                  NEXT FIELD asa01
              #FUN-B90057--add--str--
               WHEN INFIELD(aac01)
                   CALL q_aac(FALSE,TRUE,tm.aac01,'A','','','GGL') RETURNING tm.aac01
                   DISPLAY tm.aac01 TO aac01
                   NEXT FIELD aac01
              #FUN-B90057--add--end
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
      CLOSE WINDOW gglp101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF

   #CONSTRUCT BY NAME tm1.wc ON asa02
   CONSTRUCT BY NAME tm1.wc ON asg01   #TQC-AA0098

      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      ON ACTION CONTROLP
        CASE
            #WHEN INFIELD(asa02)
            WHEN INFIELD(asg01)    #TQC-AA0098
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_asg"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               #DISPLAY g_qryparam.multiret TO asa02
               DISPLAY g_qryparam.multiret TO asg01   #TQC-AA0098
               #NEXT FIELD asa02
               NEXT FIELD asg01         #TQC-AA0098
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
        CLOSE WINDOW gglp101_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF

     INPUT BY NAME g_bgjob 
           WITHOUT DEFAULTS 

        ON ACTION locale
           LET g_change_lang = TRUE   
           EXIT INPUT                

        #ON ACTION CONTROLZ    #TQC-C40010  mark
        ON ACTION CONTROLR     #TQC-C40010  add
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(asa01) 
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_asa"
                 LET g_qryparam.form = "q_asa1"   #TQC-AA0098
                 LET g_qryparam.default1 = tm.asa01
                 LET g_qryparam.where = " asa04 = 'Y' "    #TQC-C70091  add
                 CALL cl_create_qry() RETURNING tm.asa01
                 DISPLAY BY NAME tm.asa01
                 NEXT FIELD asa01
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
        CLOSE WINDOW gglp101_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        EXIT PROGRAM
     END IF
     LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))   #FUN-B90019
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01= 'gglp101'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('gglp101','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " ''",
                       " '",tm.yy CLIPPED,"'",
                       " '",tm.bm CLIPPED,"'",
                       " '",tm.em CLIPPED,"'",
                       " '",tm.asa01 CLIPPED,"'",
                       " '",tm1.wc CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('gglp101',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW gglp101_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE

END FUNCTION
   
FUNCTION p000()
DEFINE l_sql        STRING,                   
       l_sql_asf    LIKE type_file.chr1000,  
       i,g_no       LIKE type_file.num5,    
       #g_aedd        RECORD LIKE aedd_file.*,   #TQC-AA0098
       l_asl16       LIKE asl_file.asl16,
       l_asl17       LIKE asl_file.asl17,
       l_asll        RECORD LIKE asll_file.*,
       l_n           LIKE type_file.num5,          
       l_amt1        LIKE aah_file.aah04,             #FUN-B50001 luttb
       l_amt2        LIKE aah_file.aah04,             #FUN-B50001 luttb
       l_cut         LIKE type_file.num5,             #幣別取位(功能幣別)                  #No.FUN-680098  SMALLINT
       l_cut1        LIKE type_file.num5,             #幣別取位(記帳幣別) 
       l_asg04       LIKE asg_file.asg04,             #使用TIPTOP否
       l_asg06       LIKE asg_file.asg06,             #上層公司記帳幣別   
       l_asg         RECORD LIKE asg_file.*,                            
       l_asg03       LIKE asg_file.asg03,             
       l_aag06       LIKE aag_file.aag06              
DEFINE l_aag04       LIKE aag_file.aag04              
DEFINE l_bs_yy       LIKE type_file.num5              
DEFINE l_bs_mm       LIKE type_file.num5              
DEFINE l_ash         RECORD LIKE ash_file.*
DEFINE l_ash04       LIKE asf_file.asf07              
DEFINE l_ash04_cnt   LIKE type_file.num5              
DEFINE l_asg01       LIKE asg_file.asg01   #TQC-AA0098 add
DEFINE l_asa07       LIKE asa_file.asa07   #FUN-B50001 Add
DEFINE l_aal03       LIKE aal_file.aal03   #FUN-B70103   Add
#FUN-B90019--add--str--
DEFINE l_chg_aah04   LIKE aah_file.aah04              #功能幣別借方金額
DEFINE l_chg_aah05   LIKE aah_file.aah05              #功能幣別貸方金額
DEFINE l_chg_aah04_1 LIKE aah_file.aah04              #記帳幣別借方金額  
DEFINE l_chg_aah05_1 LIKE aah_file.aah05              #記帳幣別貸方金額 
DEFINE l_chg_dr      LIKE aah_file.aah04              #借方金額 
DEFINE l_chg_cr      LIKE aah_file.aah05              #貸方金額
DEFINE l_fun_dr      LIKE aah_file.aah04              #借方金額  
DEFINE l_fun_cr      LIKE aah_file.aah04              #借方金額 
DEFINE l_acc_dr      LIKE aah_file.aah05              #貸方金額
DEFINE l_acc_cr      LIKE aah_file.aah05
DEFINE l_dr          LIKE aah_file.aah04 
DEFINE l_cr          LIKE aah_file.aah05
DEFINE l_chg_aah04_a LIKE aah_file.aah04
DEFINE l_chg_aah05_a LIKE aah_file.aah05
DEFINE l_asf_count   LIKE type_file.num5
DEFINE l_asm         RECORD LIKE asm_file.*
DEFINE l_amt         LIKE asm_file.asm07
#FUN-B90019--add--end
#FUN-B90034--add--str--
DEFINE l_cnt         LIKE type_file.num5 
DEFINE l_fag         LIKE type_file.chr1   #N:分層合併且合併個體無下層公司(非最上層公司)
                                           #Y:分層合併且合併個體既是上層公司又是下層公司
DEFINE l_sql1        STRING               
DEFINE l_sql2        STRING  
DEFINE l_amt3        LIKE aah_file.aah04
DEFINE l_amt4        LIKE aah_file.aah04   
#FUN-B90034--add--end
#FUN-B90057--add--str--
DEFINE l_asm07,l_asm08,l_asm12,l_asm13 LIKE asm_file.asm07
DEFINE l_asn08,l_asn09,l_asn13,l_asn14 LIKE asn_file.asn08
DEFINE l_asm04       LIKE asm_file.asm04
DEFINE l_asn05       LIKE asn_file.asn05
DEFINE l_asn07       LIKE asn_file.asn07
DEFINE l_asn12       LIKE asn_file.asn12
DEFINE l_asn19       LIKE asn_file.asn19
#FUN-B90047--add--end

    #FUN-B90019--add--str--
    SELECT asa05,asa06
      INTO g_asa05,g_asa06  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
      FROM asa_file
     WHERE asa01 = tm.asa01     #族群編號
       AND asa04 = 'Y'   #最上層公司否
    #FUN-B90019--add--end

    #-->資料匯入,更換科目(ash,ashh)
    #-->aah_file->asm_file;aed_file->asn_file
    #-->asi_file->asm_file;asi_file->asn_file   
    #-->aeh_file->asnn_file;

    LET g_no = 1 
    FOR g_no = 1 TO 300 
        INITIALIZE g_dept[g_no].* TO NULL 
    END FOR

#FUN-B50001 start--
   SELECT asa07 INTO l_asa07 FROM asa_file
    WHERE asa01 = tm.asa01 AND asa04 = 'Y'
#FUN-B50001 end--
    #--TQC-AA0098 start--
    LET l_sql = "SELECT asg01 ",
                "  FROM asg_file",
                " WHERE ",tm1.wc CLIPPED
    PREPARE p000_asg_p FROM l_sql
    DECLARE p000_asg_c CURSOR FOR p000_asg_p
    LET g_no = 1 
    FOREACH p000_asg_c INTO l_asg01
    #-TQC-AA0098 end--
#FUN-B50001 start--
       IF l_asa07 = 'Y' THEN   #为分层合并,则只抓最上层单头单身公司
          LET l_sql = " SELECT UNIQUE asa01,asa02,asa03",
                      "   FROM asa_file ",
                      "  WHERE asa01='",tm.asa01,"'",
                      "    AND asa02 = '",l_asg01,"'",
                      "    AND asa04 = 'Y' ",
                      "  UNION ",
                      " SELECT UNIQUE asa01,asb04,asb05",
                      "   FROM asb_file,asa_file ",
                      "  WHERE asa01=asb01 AND asa02=asb02",
                      "    AND asa01='",tm.asa01,"'",
                      "    AND asa04 = 'Y' ",
                      "    AND asb04 = '",l_asg01,"'",
                      "    AND asb06 = 'Y'",
                      "  ORDER BY 1,2 "
       ELSE
#FUN-B50001 end--
          LET l_sql=" SELECT UNIQUE asa01,asa02,asa03",
                    "   FROM asa_file ",
                    "  WHERE asa01='",tm.asa01,"'",
                   #"    AND ",tm1.wc CLIPPED,
                    "    AND asa02 = '",l_asg01,"'",   #TQC-AA0098
                    "  UNION ",
                    " SELECT UNIQUE asa01,asb04,asb05",
                    "   FROM asb_file,asa_file ",
                    "  WHERE asa01=asb01 AND asa02=asb02",
                    "    AND asa01='",tm.asa01,"'",
                   #"    AND ",tm1.wc CLIPPED,
                    "    AND asb04 = '",l_asg01,"'",   #10101
                    "    AND asb06 = 'Y'",   #FUN-B50001 luttb
                    "  ORDER BY 1,2 "
       END IF   #FUN-B50001 Add
        PREPARE p000_asa_p FROM l_sql
        IF STATUS THEN 
           CALL cl_err('prepare:1',STATUS,1)             
           CALL cl_batch_bg_javamail('N')  
           CALL cl_used(g_prog,g_time,2) RETURNING g_time
           EXIT PROGRAM 
        END IF
        DECLARE p000_asa_c CURSOR FOR p000_asa_p
#        LET g_no = 1   #TQC-AA0098 mark
        CALL s_showmsg_init()         
        FOREACH p000_asa_c INTO g_dept[g_no].*
           #合併帳別
           CALL s_aaz641_asg(g_dept[g_no].asa01,g_dept[g_no].asa02)
           RETURNING g_dbs_asg03   
           #CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_dept[g_no].aaz641   #FUN-B50001
           CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_dept[g_no].asz01     #FUN-B50001

           #-->step 1 刪除資料
           CALL p000_del(g_no)
           IF g_success = 'N' THEN RETURN END IF

           IF g_success='N' THEN
             LET g_totsuccess='N'
             LET g_success='Y'
           END IF 
           IF SQLCA.SQLCODE THEN 
              CALL s_errmsg(' ',' ','for_asa_c:',STATUS,1) 
              LET g_success = 'N'
              RETURN                                     
           END IF
           LET g_no=g_no+1
        END FOREACH
    END FOREACH   #TQC-AA0098
    IF g_totsuccess="N" THEN                                                        
       LET g_success="N"                                                           
    END IF                                                                          
    LET g_no=g_no-1

    #FUN-B90019--add--str--     
    LET l_sql_asf=
        "SELECT '2',SUM(asf16),SUM(asf13)",
        "  FROM asf_file,asg_file",
        " WHERE asf01=? AND asf02=? ",
        "   AND asf02=asg01 ",
        "   AND asf04=asg06 ",
        "   AND asf03=? ",
        "   AND asf06<=? "  #異動日期
    PREPARE p000_asf_p FROM l_sql_asf
    
    LET l_sql_asf=
        "SELECT COUNT(*) ",       
        "  FROM asf_file,asg_file",
        " WHERE asf01=? AND asf02=? ",
        "   AND asf02=asg01 ",
        "   AND asf04=asg06 ",
        "   AND asf03=? ",
        "   AND asf06<=? "
    PREPARE p000_asf_p2 FROM l_sql_asf
    #FUN-B90019--add--end
    
    FOR i =1 TO g_no 
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y'                                                      
       END IF
       #FUN-B90019--add--str--       
       SELECT asg06 INTO x_aaa03 FROM asg_file,asa_file
        WHERE asg01 = asa02 AND asa01 = g_dept[i].asa01
          AND asa04 = 'Y'       
       #FUN-B90019--add--end          
       SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01=g_dept[i].asa02
       SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01 = l_asg03  
       SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_asg03
       IF STATUS THEN LET g_dbs_new = NULL END IF
       IF NOT cl_null(g_dbs_new) THEN 
          #LET g_dbs_new=g_dbs_new CLIPPED,':'   #MOD-B30236 
          LET g_dbs_new=g_dbs_new CLIPPED,'.'    #MOD-B30236 
       END IF
       LET g_dbs_gl = g_dbs_new CLIPPED

       #合併帳別
       CALL s_aaz641_asg(g_dept[i].asa01,g_dept[i].asa02)
       RETURNING g_dbs_asg03   
       #CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_dept[i].aaz641   #FUN-B50001
       CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_dept[i].asz01

       #記帳幣別
       SELECT asg06 INTO g_dept[i].asg06
         FROM asg_file 
        WHERE asg01=g_dept[i].asa02
     
        #LET g_sql = "SELECT aaz113 FROM ",g_dbs_asg03,"aaz_file", 
 #FUN-B50001--mod--str--
 #      LET g_sql = "SELECT aaz113 FROM ",cl_get_target_table(g_dbs_asg03,'aaz_file'), #MOD-B40015
 #                  " WHERE aaz00 = '0'"
        LET g_sql = "SELECT asz05 FROM ",cl_get_target_table(g_dbs_asg03,'asz_file'), 
                    " WHERE asz00 = '0'"
 #FUN-B50001--mod--end
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_dbs_new) RETURNING g_sql  #MOD-B40015
       PREPARE p000_pre_01 FROM g_sql
       DECLARE p000_cur_01 CURSOR FOR p000_pre_01
       OPEN p000_cur_01
       #FETCH p000_cur_01 INTO g_aaz113   #FUN-B50001
       FETCH p000_cur_01 INTO g_asz05
       CLOSE p000_cur_01

       LET l_rate = 1 
       LET l_cut  = 0
       LET l_cut1 = 0   #FUN-5A0020

       #FUN-B90034--add--str--
       IF l_asa07 = 'Y' THEN  ###分層合併
          SELECT COUNT(*) INTO l_cnt FROM asa_file,asb_file
           WHERE asa01 = asb01 AND asa02 = asb02 
             AND asa02 = g_dept[i].asa02 AND asa01 = g_dept[i].asa01 
          IF l_cnt>0 THEN   ###是上層公司        
             SELECT COUNT(*) INTO l_cnt FROM asa_file,asb_file
              WHERE asa01 = asb01 AND asa02 = asb02
                AND asb04 = g_dept[i].asa02 AND asa01 = g_dept[i].asa01
             IF l_cnt>0 THEN  ###既是上層公司又是下層公司
                LET l_fag = 'Y'
             ELSE
                LET l_fag = 'N'
             END IF 
          ELSE
             LET l_fag = 'N'
          END IF 
       END IF 
       #FUN-B90034--add--end
       SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01=g_dept[i].asa02
       #IF l_asg04='Y' THEN   #是否屬於TIPTOP公司    #FUN-B90034
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN   #FUN-B90034
           LET l_sql=
           " SELECT * ",
           "   FROM ",cl_get_target_table(l_asg03,'aah_file'),",",   #MOD-B40015
           "        ",cl_get_target_table(l_asg03,'aag_file'),       #MOD-B40015
           #" FROM ",g_dbs_gl,"aah_file,",g_dbs_gl,"aag_file ",
           " WHERE aah02=",tm.yy,
           " AND aah03 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
           " AND aah00='",g_dept[i].asa03,"' ",
           " AND aah01 = aag01 ",
           " AND aah00 = aag00 ",
#          " AND aag07 MATCHES '[23]'",      #No..TQC-B30100 Mark
           " AND aag07 IN ('2','3')  ",      #No..TQC-B30100 add
           " AND aag09 = 'Y' ",
           #" AND aag01 <> '",g_aaz113,"'",   #FUN-B50001
           #" AND aag01 <> '",g_asz05,"'",    #FUN-B90019
           " AND aag03 = '2'",                #FUN-B90019
           " ORDER BY aah01"

           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING g_sql  #MOD-B40015
           PREPARE p000_aah_p5 FROM l_sql
           IF STATUS THEN
               LET g_showmsg=tm.yy,"/",g_dept[i].asa03
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
               #FUN-B50001 Add --str-- 
               LET l_sql =
                          "SELECT aag04 ",
                         #" FROM ",g_dbs_gl,"aag_file ",   #FUN-B90019
                          " FROM ",cl_get_target_table(l_asg03,'aag_file'),  #FUN-B90019
                          " WHERE aag00 = '",g_aah.aah00,"' ",
                          "   AND aag01 = '",g_aah.aah01,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-B90019
               CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING l_sql #FUN-B90019                
               DECLARE p000_c3  CURSOR FROM l_sql
               OPEN p000_c3
               FETCH p000_c3 INTO l_aag04
               IF l_aag04 = '2' THEN
                  LET l_amt1 = 0
                  LET l_amt2 = 0
                  LET l_sql =
                   "SELECT SUM(abb07) ",
                   #"  FROM ",g_dbs_gl,"abb_file,",g_dbs_gl,"aba_file ", #FUN-B90019
                   "  FROM ",cl_get_target_table(l_asg03,'abb_file'),  #FUN-B90019
                   "      ,",cl_get_target_table(l_asg03,'aba_file'),  #FUN-B90019                   
                   "  WHERE abb00 = '",g_aah.aah00,"' ",
                   "    AND aba00 = abb00 ",
                   "    AND aba01 = abb01 ",
                   "    AND aba06 = 'CE'  ",
                   "    AND abb06 = ? ",
                   "    AND abb03 = '",g_aah.aah01,"' ",
                   "    AND aba03 = '",g_aah.aah02,"' ",
                   "    AND aba04 = '",g_aah.aah03,"' ",
                   "    AND aba19 <> 'X' "   #CHI-C80041
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #FUN-B90019
                  CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING g_sql #FUN-B90019                  
                  DECLARE p000_c2  CURSOR FROM l_sql
                  OPEN p000_c2 USING '1'
                  FETCH p000_c2 INTO l_amt1
                  OPEN p000_c2 USING '2'
                  FETCH p000_c2 INTO l_amt2
                  IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
                  IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
                  LET g_aah.aah04 = g_aah.aah04- l_amt1
                  LET g_aah.aah05 = g_aah.aah05- l_amt2
               END IF
              #FUN-B50001 --add--end

               LET l_ash.ash06 = g_aah.aah01
               LET l_ash.ash11 = '1'
               LET l_ash.ash12 = '1'
               DISPLAY g_aah.aah03,'->',l_ash.ash06,' ',g_aah.aah01,' ',g_aah.aah04,' ',g_aah.aah05

               #抓取合併個體公司的科目的合併財報科目編號(ash06),
               SELECT * INTO l_ash.* FROM ash_file    
                WHERE ash01 = g_dept[i].asa02 
                  AND ash00 = g_dept[i].asa03
		          AND ash04 = g_aah.aah01 
                  AND ash13 = g_dept[i].asa01
               IF STATUS  THEN     
                   #LET g_showmsg=g_dept[i].asa03,"/",g_aah.aah01
                   LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_aah.aah01        #TQC-AA0098
                   CALL s_errmsg('asg01,,aah00,aah01',g_showmsg,g_aah.aah01,'aap-021',1)      #TQC-AA0098
                   LET g_success = 'N' 
                   CONTINUE FOREACH       
               END IF

#FUN-B90019--add--str--增加匯率的處理
               #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
               #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
               #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
               #  乘上匯率逐一算出借貸方計帳金額(asr08,asr09 OR ass10,ass11)
               SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asa02
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('asg01',g_dept[i].asa02,' ',SQLCA.sqlcode,1) 
                  LET g_success = 'N'
                  CONTINUE  FOREACH  
               END IF
               #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
               #金額需抓agli011設定的記帳幣別金額(小於等於本期),
               #一一換算後再加總起來 
               ##否則抓取agli008中的匯率      
               LET l_chg_aah04_1=0
               LET l_chg_aah05_1=0
               LET l_chg_aah04=0
               LET l_chg_aah05=0
               LET l_chg_aah04_a=0
               LET l_chg_aah05_a=0

               LET l_chg_dr = 0 
               LET l_chg_cr = 0
               LET l_fun_dr = 0 
               LET l_fun_cr = 0 
               LET l_acc_dr = 0 
               LET l_acc_cr = 0
               LET l_dr = 0
               LET l_cr = 0 

               #--現時匯率---
               IF l_ash.ash11='1' THEN 
                   CALL p000_fun_amt(l_aag04,g_aah.aah04,g_aah.aah05,
                                     l_ash.ash11,l_asg.asg06,
                                     l_asg.asg07,g_aah.aah02,g_aah.aah03,g_asa05)
                   RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               END IF
               #--歷史匯率---
               IF l_ash.ash11='2'  THEN  
                  #----如果agli011抓不到資料，則依科目餘額計算---- 
                  DECLARE p000_cnt_cs2 CURSOR FOR p000_asf_p2
                  OPEN p000_cnt_cs2
                  USING g_dept[i].asa01,g_dept[i].asa02,
                       g_aah.aah01,g_date_e  
                  FETCH p000_cnt_cs2 INTO l_asf_count
                  CLOSE p000_cnt_cs2
                  IF l_asf_count > 0 THEN   
                     CALL p000_asf(i,l_ash.ash04,g_aah.aah01,g_date_e)  
                      RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                  ELSE
                      #--取不到agli011時一樣用匯率換算---
                      CALL p000_fun_amt(l_aag04,g_aah.aah04,g_aah.aah05,
                                    l_ash.ash11,l_asg.asg06,
                                    l_asg.asg07,g_aah.aah02,g_aah.aah03,g_asa05)  
                      RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                  END IF
               ELSE
                  CALL p000_fun_amt(l_aag04,g_aah.aah04,g_aah.aah05,
                                    l_ash.ash11,l_asg.asg06,
                                    l_asg.asg07,g_aah.aah02,g_aah.aah03,g_asa05)
                  RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               END IF
       
               #--平均匯率---
               IF l_ash.ash11='3' THEN
                   IF g_asa05 = '1' THEN      
                       CALL p000_fun_avg(l_ash.ash11,g_aah.aah01,l_asg.asg06,l_asg.asg07,
                                         g_aah.aah02,g_aah.aah03,i,g_aah.aah04,g_aah.aah05)   
                       RETURNING l_fun_dr,l_fun_cr 
                   ELSE                
                       CALL p000_fun_amt(l_aag04,g_aah.aah04,g_aah.aah05,
                                         l_ash.ash11,l_asg.asg06,
                                         l_asg.asg07,g_aah.aah02,g_aah.aah03,g_asa05)  
                       RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                   END IF
               END IF  

               #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
               #--現時匯率---
               IF l_ash.ash12='1' THEN 
                   CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                     l_ash.ash12,l_asg.asg07,
                                     x_aaa03,g_aah.aah02,g_aah.aah03,g_asa05)   
                   RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               END IF

               #--歷史匯率---
               IF l_ash.ash12='2'  THEN  
                   #----如果agli011抓不到資料，則依科目餘額計算---- 
                   DECLARE p000_cnt_cs24 CURSOR FOR p000_asf_p2
                   OPEN p000_cnt_cs24
                   USING g_dept[i].asa01,g_dept[i].asa02,
                        g_aah.aah01,g_date_e             
                   FETCH p000_cnt_cs24 INTO l_asf_count
                   CLOSE p000_cnt_cs24
                   IF l_asf_count > 0 THEN   
                       CALL p000_asf(i,l_ash.ash04,g_aah.aah01,g_date_e)    
                       RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                   ELSE
                       #--取不到agli011時一樣用匯率換算---
                       CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                         l_ash.ash12,l_asg.asg07,
                                         x_aaa03,g_aah.aah02,g_aah.aah03,g_asa05) 
                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                   END IF
               ELSE
                   CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                     l_ash.ash12,l_asg.asg07,
                                     x_aaa03,g_aah.aah02,g_aah.aah03,g_asa05)     
                   RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               END IF
       
               #--平均匯率---
               IF l_ash.ash12='3' THEN
                   IF g_asa05 = '1' THEN 
                       CALL p000_avg(l_ash.ash11,l_ash.ash12,g_aah.aah01,
                                     l_asg.asg06,l_asg.asg07,
                                     g_aah.aah02,g_aah.aah03,i,g_aah.aah04,g_aah.aah05)
                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                   ELSE
                       CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                         l_ash.ash12,l_asg.asg07,
                                         x_aaa03,g_aah.aah02,g_aah.aah03,g_asa05)  
                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                   END IF
               END IF
               LET l_chg_aah04  =l_chg_aah04   + l_fun_dr  #功能幣借方金額
               LET l_chg_aah05  =l_chg_aah05   + l_fun_cr  #功能幣貸方金額
               LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
               LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額

               SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07                                                                               
               IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
               SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
               IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                                      
               LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
               LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
               LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
               LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
                                                                                                             
               IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
               IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF
#FUN-B90019--add--end               

               INSERT INTO asm_file                                                                                                                        
                 (asm00,asm01,asm02,asm03,
                  asm04,asm05,asm06,asm07,
                  #asm08,asm09,asm10,asm11,asm18,asmlegal)    #FUN-B50001 Add asm18 #FUN-B90019
                   asm08,asm09,asm10,asm11,asm18,asmlegal,    #FUN-B90019
                   asm12,asm13,asm14,asm15,asm16,asm17,       #FUN-B90019
                   asm20,asm21)                               #No.FUN-C80020
               VALUES                                                                                                                                     
                 #(g_dept[i].aaz641,g_dept[i].asa01,    #FUN-B50001
                 (g_dept[i].asz01,g_dept[i].asa01,
                  g_dept[i].asa02,  
                  g_dept[i].asa03,l_ash.ash06,g_aah.aah02,
                  g_aah.aah03,
                  #g_aah.aah04,g_aah.aah05,   #FUN-B90019
                  l_chg_aah04_1,l_chg_aah05_1, #FUN-B90019                   
                  g_aah.aah06,g_aah.aah07,
                  #g_dept[i].asg06,g_dept[i].asa02,g_azw02)   #FUN-B50001 Add g_dept[i].asa02 #FUN-B90019
                  x_aaa03,g_dept[i].asa02,g_azw02,    #FUN-B90019
                  g_aah.aah04,g_aah.aah05,l_asg.asg06,l_chg_aah04,l_chg_aah05, #FUN-B90019
                  l_asg.asg07,tm.yy,tm.em)                    #FUN-B90019      #No.FUN-C80020
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                 #FUN-B90019--mod--str--               
                 #  UPDATE asm_file SET asm07 = asm07 + g_aah.aah04,
                 #                      asm08 = asm08 + g_aah.aah05,
                 #                      asm09 = asm09 + g_aah.aah06,
                 #                      asm10 = asm10 + g_aah.aah07
                  UPDATE asm_file SET asm07 = asm07+l_chg_aah04_1,
                                      asm08 = asm08+l_chg_aah05_1,
                                      asm12 = asm12+g_aah.aah04,
                                      asm13 = asm13+g_aah.aah05,
                                      asm15 = asm15+l_chg_aah04,
                                      asm16 = asm16+l_chg_aah05,
                                      asm09 = asm09 + g_aah.aah06,
                                      asm10 = asm10 + g_aah.aah07                
                 #FUN-B90019--mod--end
                    #WHERE asm00 = g_dept[i].aaz641   #FUN-B50001
                    WHERE asm00 = g_dept[i].asz01
                      AND asm01 = g_dept[i].asa01                                                                                                         
                      AND asm02 = g_dept[i].asa02                                                                                                         
                      AND asm03 = g_dept[i].asa03                                                                                                         
                      AND asm04 = l_ash.ash06
                      AND asm05 = g_aah.aah02
                      AND asm06 = g_aah.aah03                                                                                                             
                      #AND asm11 = g_dept[i].asg06   #FUN-B90019
                      AND asm11 = x_aaa03            #FUN-B90019
                      AND asm18 = g_dept[i].asa02   #FUN-B50001
                      AND asm20 = tm.yy              #No.FUN-C80020
                      AND asm21 = tm.em              #No.FUN-C80020
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                       CALL s_errmsg('asr01',g_dept[i].asa01,'upd_asm',SQLCA.sqlcode,1)                                                                       
                       LET g_success = 'N'                                                                                                                    
                       CONTINUE FOREACH     
                   END IF                                                                                                                                    
               ELSE                                                                                                                                        
                   IF STATUS THEN                                                                                                                            
                      CALL s_errmsg('asr01',g_dept[i].asa01,'ins_asm',status,1)                                                                              
                      LET g_success = 'N'                                                                                                                    
                      CONTINUE FOREACH   
                   END IF                                                                                                                                    
               END IF                                        
           END FOREACH

           LET l_sql=
                 " SELECT * ",
                 "   FROM ",cl_get_target_table(l_asg03,'aed_file'),",",   #MOD-B40015
                 "        ",cl_get_target_table(l_asg03,'aag_file'),       #MOD-B40015
                 #" FROM ",g_dbs_gl,"aed_file,",g_dbs_gl,"aag_file ",
                 " WHERE aed03=",tm.yy,
                 " AND aed04 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                 " AND aed00='",g_dept[i].asa03,"' AND aed011='99' ",
                 " AND aed01 = aag01 ",
                 " AND aed00 = aag00 ",
#                " AND aag07 MATCHES '[23]'",       #No.No.TQC-B30100 Mark
                 " AND aag07 IN ('2','3')  ",      #No..TQC-B30100 add
                 #" AND aag01 <> '",g_aaz113,"'",   #FUN-B50001
                 #" AND aag01 <> '",g_asz05,"'",     #FUN-B90019
                 " AND aag03 = '2'",                #FUN-B90019
                 " AND aag09 = 'Y' ",
                 " ORDER BY aed01 "
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
           CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING g_sql  #MOD-B40015
           PREPARE p000_aed_p5 FROM l_sql
           IF STATUS THEN
                LET g_showmsg=tm.yy,"/",g_dept[i].asa03,'99'
                CALL s_errmsg('aed03,aed00,aed011 ',g_showmsg,'prepare:4',STATUS,1) 
                LET g_success ='N' 
                CONTINUE FOR
           END IF
           DECLARE p000_aed_c5 CURSOR FOR p000_aed_p5
           FOREACH p000_aed_c5 INTO g_aed.*
#FUN-B70103   ---start   Add
               LET l_aal03 = NULL
               SELECT aal03 INTO l_aal03 FROM aal_file
                WHERE aal01 = g_dept[i].asa02
                  AND aal02 = g_aed.aed02
               IF NOT cl_null(l_aal03) THEN
                  LET g_aed.aed02 = l_aal03
               END IF
#FUN-B70103   ---end     Add
               LET l_ash.ash06 = g_aed.aed01
               LET l_ash.ash11 = '1'
               LET l_ash.ash12 = '1'
               DISPLAY g_aed.aed04,'->',l_ash.ash06,' ',g_aed.aed01,' ',g_aed.aed05,' ',g_aed.aed06

               SELECT * INTO l_ash.* FROM ash_file    
                WHERE ash01 = g_dept[i].asa02 
                  AND ash00 = g_dept[i].asa03
		  AND ash04 = g_aed.aed01
                  AND ash13 = g_dept[i].asa01
               IF STATUS  THEN                   
                   #LET g_showmsg=g_dept[i].asa03,"/",g_aed.aed01 
                   #CALL s_errmsg('ash01,ash04',g_showmsg,g_aed.aed01,'aap-021',1)   
                   #LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_aah.aah01            #TQC-AA0098  #TQC-B70117 mark
                   LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_aed.aed01  #TQC-B70117
                   CALL s_errmsg('asg01,,aah00,aah01',g_showmsg,g_aah.aah01,'aap-021',1)          #TQC-AA0098
                   LET g_success = 'N'
                   CONTINUE FOREACH    
               END IF
#FUN-B90019--add--str--增加匯率的處理
               LET l_sql =
                          "SELECT aag04 ",
                          " FROM ",cl_get_target_table(l_asg03,'aag_file'),
                          " WHERE aag00 = '",g_aed.aed00,"' ",
                          "   AND aag01 = '",g_aed.aed01,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
               CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING l_sql 
               PREPARE p000_sel_aag04 FROM l_sql               
               EXECUTE p000_sel_aag04 INTO l_aag04               
               #luttb--110928--add--str--
               IF l_aag04 = '2' THEN
                  LET l_amt1 = 0
                  LET l_amt2 = 0
                  LET l_sql =
                   "SELECT SUM(abb07) ",
                   "  FROM ",cl_get_target_table(l_asg03,'abb_file'), 
                   "      ,",cl_get_target_table(l_asg03,'aba_file'),
                   "  WHERE abb00 = '",g_aed.aed00,"' ",
                   "    AND aba00 = abb00 ",
                   "    AND aba01 = abb01 ",
                   "    AND aba06 = 'CE'  ",
                   "    AND abb06 = ? ",
                   "    AND abb37 = '",g_aed.aed02,"'",
                   "    AND abb03 = '",g_aed.aed01,"' ",
                   "    AND aba03 = '",g_aed.aed03,"' ",
                   "    AND aba04 = '",g_aed.aed04,"' ",
                   "    AND aba19 <> 'X' "   #CHI-C80041
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql         
                  CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING g_sql 
                  DECLARE p000_c22  CURSOR FROM l_sql
                  OPEN p000_c22 USING '1'
                  FETCH p000_c22 INTO l_amt1
                  OPEN p000_c22 USING '2'
                  FETCH p000_c22 INTO l_amt2
                  IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
                  IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
                  LET g_aed.aed05 = g_aed.aed05- l_amt1
                  LET g_aed.aed06 = g_aed.aed06- l_amt2
               END IF
               #luttb 110928--add--end
               #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
               #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
               #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
               #  乘上匯率逐一算出借貸方計帳金額(asr08,asr09 OR ass10,ass11)
               SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asa02
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('asg01',g_dept[i].asa02,' ',SQLCA.sqlcode,1) 
                  LET g_success = 'N'
                  CONTINUE  FOREACH  
               END IF
               #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
               #金額需抓agli011設定的記帳幣別金額(小於等於本期),
               #一一換算後再加總起來 
               ##否則抓取agli008中的匯率      
               LET l_chg_aah04_1=0
               LET l_chg_aah05_1=0
               LET l_chg_aah04=0
               LET l_chg_aah05=0
               LET l_chg_aah04_a=0
               LET l_chg_aah05_a=0

               LET l_chg_dr = 0 
               LET l_chg_cr = 0
               LET l_fun_dr = 0 
               LET l_fun_cr = 0 
               LET l_acc_dr = 0 
               LET l_acc_cr = 0
               LET l_dr = 0
               LET l_cr = 0 

               #--現時匯率---
               IF l_ash.ash11='1' THEN 
                   CALL p000_fun_amt(l_aag04,g_aed.aed05,g_aed.aed06,
                                     l_ash.ash11,l_asg.asg06,
                                     l_asg.asg07,g_aed.aed03,g_aed.aed04,g_asa05)
                   RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               END IF
               #--歷史匯率---
               IF l_ash.ash11='2'  THEN  
                  #----如果agli011抓不到資料，則依科目餘額計算---- 
                  DECLARE p000_cnt_cs11 CURSOR FOR p000_asf_p2
                  OPEN p000_cnt_cs11
                  USING g_dept[i].asa01,g_dept[i].asa02,
                       g_aed.aed01,g_date_e  
                  FETCH p000_cnt_cs11 INTO l_asf_count
                  CLOSE p000_cnt_cs11
                  IF l_asf_count > 0 THEN   
                     CALL p000_asf(i,l_ash.ash04,g_aed.aed01,g_date_e)  
                      RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                  ELSE
                      #--取不到agli011時一樣用匯率換算---
                      CALL p000_fun_amt(l_aag04,g_aed.aed05,g_aed.aed06,
                                    l_ash.ash11,l_asg.asg06,
                                    l_asg.asg07,g_aed.aed03,g_aed.aed04,g_asa05)  
                      RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                  END IF
               ELSE
                  CALL p000_fun_amt(l_aag04,g_aed.aed05,g_aed.aed06,
                                    l_ash.ash11,l_asg.asg06,
                                    l_asg.asg07,g_aed.aed03,g_aed.aed04,g_asa05)
                  RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
               END IF
       
               #--平均匯率---
               IF l_ash.ash11='3' THEN
                   IF g_asa05 = '1' THEN      
                       CALL p000_fun_avg(l_ash.ash11,g_aed.aed01,l_asg.asg06,l_asg.asg07,
                                         g_aed.aed03,g_aed.aed04,i,g_aed.aed05,g_aed.aed06)   
                       RETURNING l_fun_dr,l_fun_cr 
                   ELSE                
                       CALL p000_fun_amt(l_aag04,g_aed.aed05,g_aed.aed06,
                                         l_ash.ash11,l_asg.asg06,
                                         l_asg.asg07,g_aed.aed03,g_aed.aed04,g_asa05)  
                       RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                   END IF
               END IF  

               #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
               #--現時匯率---
               IF l_ash.ash12='1' THEN 
                   CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                     l_ash.ash12,l_asg.asg07,
                                     x_aaa03,g_aed.aed03,g_aed.aed04,g_asa05)   
                   RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               END IF

               #--歷史匯率---
               IF l_ash.ash12='2'  THEN  
                   #----如果agli011抓不到資料，則依科目餘額計算---- 
                   DECLARE p000_cnt_cs55 CURSOR FOR p000_asf_p2
                   OPEN p000_cnt_cs55
                   USING g_dept[i].asa01,g_dept[i].asa02,
                        g_aed.aed01,g_date_e             
                   FETCH p000_cnt_cs55 INTO l_asf_count
                   CLOSE p000_cnt_cs55
                   IF l_asf_count > 0 THEN   
                       CALL p000_asf(i,l_ash.ash04,g_aed.aed01,g_date_e)    
                       RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                   ELSE
                       #--取不到agli011時一樣用匯率換算---
                       CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                         l_ash.ash12,l_asg.asg07,
                                         x_aaa03,g_aed.aed03,g_aed.aed04,g_asa05) 
                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                   END IF
               ELSE
                   CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                     l_ash.ash12,l_asg.asg07,
                                     x_aaa03,g_aed.aed03,g_aed.aed04,g_asa05)     
                   RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
               END IF
       
               #--平均匯率---
               IF l_ash.ash12='3' THEN
                   IF g_asa05 = '1' THEN 
                       CALL p000_avg(l_ash.ash11,l_ash.ash12,g_aed.aed01,
                                     l_asg.asg06,l_asg.asg07,
                                     g_aed.aed03,g_aed.aed04,i,g_aed.aed05,g_aed.aed06)
                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                   ELSE
                       CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                         l_ash.ash12,l_asg.asg07,
                                         x_aaa03,g_aed.aed03,g_aed.aed04,g_asa05)  
                       RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                   END IF
               END IF
               LET l_chg_aah04  =l_chg_aah04   + l_fun_dr  #功能幣借方金額
               LET l_chg_aah05  =l_chg_aah05   + l_fun_cr  #功能幣貸方金額
               LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
               LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額

               SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07                                                                               
               IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
               SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
               IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                                      
               LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
               LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
               LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
               LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
                                                                                                             
               IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
               IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF
#FUN-B90019--add--end                
               INSERT INTO asn_file 
                  (asn00,asn01,asn02,asn03,asn04,asn05,
                   asn06,asn07,asn08,asn09,asn10,asn11,asn12,asn19,asnlegal,    #MOD-B30441 asnlegal   #FUN-B50001 Add asn19
                   asn13,asn14,asn15,asn16,asn17,asn18,asn20,asn21)    #FUN-B90019                     #No.FUN-C80020
               VALUES 
                  #(g_dept[i].aaz641,g_dept[i].asa01,g_dept[i].asa02,    #FUN-B50001 
                  (g_dept[i].asz01,g_dept[i].asa01,g_dept[i].asa02,     #FUN-B50001
                   g_dept[i].asa03,l_ash.ash06,g_aed.aed02,  
                   g_aed.aed03,g_aed.aed04,
                   #g_aed.aed05,g_aed.aed06,  #FUN-B90019
                   l_chg_aah04_1,l_chg_aah05_1,   #FUN-B90019                   
                   g_aed.aed07,g_aed.aed08,
                   #g_dept[i].asg06,g_dept[i].asa02,g_azw02,                     #FUN-B50001 Add g_dept[i].asa02 #FUN-B90019
                   x_aaa03,g_dept[i].asa02,g_azw02,                     #FUN-B90019
                  #FUN-B90019--add--str--                   
                   g_aed.aed05,g_aed.aed06,l_asg.asg06,l_chg_aah04,
                   l_chg_aah05,l_asg.asg07,tm.yy,tm.em)                 #No.FUN-C80020
                  #FUN-B90019--add--end                  
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                  UPDATE asn_file SET 
                                     #FUN-B90019--mod--str--                  
                                     # asn08 = asn08 + g_aed.aed05, 
                                     # asn09 = asn09 + g_aed.aed06,
                                      asn08 = asn08 + l_chg_aah04_1,
                                      asn09 = asn09 + l_chg_aah05_1,
                                      asn13 = asn13 + g_aed.aed05,
                                      asn14 = asn14 + g_aed.aed06,                                     
                                      asn16 = asn16 + l_chg_aah04,
                                      asn17 = asn17 + l_chg_aah05,                                      
                                     #FUN-B90019--mod--end                                      
                                      asn10 = asn10 + g_aed.aed07,
                                      asn11 = asn11 + g_aed.aed08
                      #WHERE asn00 = g_dept[i].aaz641    #FUN-B50001
                      WHERE asn00 = g_dept[i].asz01
                        AND asn01 = g_dept[i].asa01
                        AND asn02 = g_dept[i].asa02
                        AND asn03 = g_dept[i].asa03
                        AND asn04 = l_ash.ash06
                        AND asn05 = g_aed.aed02
                        AND asn06 = g_aed.aed03
                        AND asn07 = g_aed.aed04
                        #AND asn12 = g_dept[i].asg06   #FUN-B90019
                        AND asn12 = x_aaa03            #FUN-B90019
                        AND asn19 = g_dept[i].asa02   #FUN-B50001
                        AND asn20 = tm.yy              #No.FUN-C80020
                        AND asn21 = tm.em              #No.FUN-C80020
                  #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                     CALL s_errmsg('asn01',g_dept[i].asa01,'upd_asn',SQLCA.sqlcode,1) 
                     LET g_success = 'N' 
                     CONTINUE FOREACH  
                  END IF
               ELSE
                  IF STATUS THEN 
                     LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_dept[i].asz01,"/",g_dept[i].asa03      
                     CALL s_errmsg('asn01,asn02,asn03,asn04,asn05',g_showmsg,'ins_asn',status,1)                
                     LET g_success = 'N'
                     CONTINUE FOREACH       
                  END IF
               END IF                          
           END FOREACH
            
           LET l_sql=" SELECT aeh01,aeh09,aeh10,SUM(aeh11),",
                     " SUM(aeh12),SUM(aeh13),SUM(aeh14),",
                     " aeh31,aeh32,aeh33,aeh34",
                     #" FROM ",g_dbs_gl,"aeh_file,",g_dbs_gl,"aag_file ",
                     "   FROM ",cl_get_target_table(l_asg03,'aeh_file'),",",   #MOD-B40015
                     "        ",cl_get_target_table(l_asg03,'aag_file'),       #MOD-B40015
                     " WHERE aeh09 =",tm.yy,
                     " AND aeh10 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                     " AND aeh00 ='",g_dept[i].asa03,"'",
                     " AND aeh01 = aag01 ",
                     " AND aeh00 = aag00 ",
#                    " AND aag07 MATCHES '[23]'",      #No.TQC-B30100 Mark
                     " AND aag07 IN ('2','3')  ",      #No..TQC-B30100 add
                     " AND aag09 = 'Y' ",
                     #" AND aag01 <> '",g_aaz113,"'",   #FUN-B50001
                     #" AND aag01 <> '",g_asz05,"'",    #FUN-B90019
                     " AND aag03 = '2'",                #FUN-B90019
                     " AND (aeh31<>' ' OR aeh32<>' ' OR aeh33<>' ' OR aeh34<>' ')",  #MOD-B70230 add 
                     " GROUP BY aeh01,aeh09,aeh10,aeh31,aeh32,aeh33,aeh34",
                     " ORDER BY aeh01"

           CALL cl_replace_sqldb(l_sql) RETURNING l_sql      
           CALL cl_parse_qry_sql(l_sql,l_asg03) RETURNING g_sql  #MOD-B40015
           PREPARE p000_aeh_p1 FROM l_sql
           IF STATUS THEN
              LET g_showmsg=tm.yy,"/",g_dept[i].asa03
              CALL s_errmsg('aeh00,aeh01',g_showmsg,'prepare:aeh_p1',STATUS,1) LET g_success='N' CONTINUE FOR 
           END IF
           DECLARE p000_aeh_c1 CURSOR FOR p000_aeh_p1
           FOREACH p000_aeh_c1 INTO g_aeh.*
               IF SQLCA.SQLCODE THEN
                  LET g_showmsg=tm.yy,"/",g_dept[i].asa03
                  CALL s_errmsg('aeh00,aeh01',g_showmsg,'foreach:aeh_c1',STATUS,1) LET g_success ='N' CONTINUE FOR
               END IF
               IF g_aeh.aeh11 =0 AND g_aeh.aeh12=0 THEN CONTINUE FOREACH END IF
               LET l_ash.ash06 = g_aeh.aeh01
               LET l_ash.ash11 = '1'
               LET l_ash.ash12 = '1'
               DISPLAY g_aeh.aeh10,'->',l_ash.ash06,' ',g_aeh.aeh01,' ',g_aeh.aeh11,' ',g_aeh.aeh12

               SELECT * INTO l_ash.* FROM ash_file    
                WHERE ash01 = g_dept[i].asa02 
                  AND ash00 = g_dept[i].asa03
		  AND ash04 = g_aeh.aeh01
                  AND ash13 = g_dept[i].asa01
               IF STATUS  THEN
                  #LET g_showmsg=g_dept[i].asa03,"/",g_aeh.aeh01
                  #CALL s_errmsg('ash01,ash04',g_showmsg,g_aeh.aeh01,'aap-021',1)
                  LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_aah.aah01                                            #TQC-AA0098 
                  CALL s_errmsg('asg01,,aah00,aah01',g_showmsg,g_aah.aah01,'aap-021',1)                                          #TQC-AA0098 
                  LET g_success = 'N'
                  CONTINUE FOREACH       
               END IF
               IF cl_null(g_aeh.aeh31) THEN LET g_aeh.aeh31 = ' ' END IF
               IF cl_null(g_aeh.aeh32) THEN LET g_aeh.aeh32 = ' ' END IF
               IF cl_null(g_aeh.aeh33) THEN LET g_aeh.aeh33 = ' ' END IF
               IF cl_null(g_aeh.aeh34) THEN LET g_aeh.aeh34 = ' ' END IF

               INSERT INTO asnn_file
                 (asnn00,asnn01,asnn02,asnn03,asnn04,
                  asnn05,asnn06,asnn07,asnn08,asnn09,asnn10,
                  asnn11,asnn12,asnn13,asnn14,
                  asnn15,asnnlegal,asnn16,asnn20,asnn21)                     #No.FUN-C80020
               VALUES
                #(g_dept[i].aaz641,g_dept[i].asa01,g_dept[i].asa02,   #FUN-B50001
                (g_dept[i].asz01,g_dept[i].asa01,g_dept[i].asa02,
                 g_dept[i].asa03,l_ash.ash06,g_aeh.aeh31,
                 g_aeh.aeh32,g_aeh.aeh33,g_aeh.aeh34,
                 g_aeh.aeh09,g_aeh.aeh10,
                 g_aeh.aeh11,g_aeh.aeh12,
                 g_aeh.aeh13,g_aeh.aeh14,
                 g_dept[i].asg06,g_azw02,g_dept[i].asa02,tm.yy,tm.em)                  #No.FUN-C80020
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                   UPDATE asnn_file SET asnn11 = asnn11 + g_aeh.aeh11,
                                       asnn12 = asnn12 + g_aeh.aeh12,
                                       asnn13 = asnn13 + g_aeh.aeh13,
                                       asnn14 = asnn14 + g_aeh.aeh14
                   #No.FUN-C80020  --Begin
                    WHERE asnn00 = g_dept[i].asz01
                      AND asnn01 = g_dept[i].asa01 
                      AND asnn02 = g_dept[i].asa02 
                      AND asnn03 = g_dept[i].asa03 
                      AND asnn04 = l_ash.ash06 
                      AND asnn05 = g_aeh.aeh31 
                      AND asnn06 = g_aeh.aeh32 
                      AND asnn07 = g_aeh.aeh33 
                      AND asnn08 = g_aeh.aeh34 
                      AND asnn09 = g_aeh.aeh09 
                      AND asnn10 = g_aeh.aeh10 
                      AND asnn15 = g_dept[i].asg06
                      AND asnn16 = g_dept[i].asa02 
                      AND asnn20 = tm.yy
                      AND asnn21 = tm.em
                   #No.FUN-C80020  --End  
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                      CALL s_errmsg('asnn01',g_dept[i].asa01,'upd_asnn',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               ELSE
                   IF STATUS THEN
                      LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_dept[i].asz01,"/",g_dept[i].asa03
                      CALL s_errmsg('asnn01,asnn02,asnn00,asnn04',g_showmsg,'ins_asnn',status,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               END IF
           END FOREACH	　	　	　	　
       ELSE
           #不使用TIPTOP(asg04='N')資料抓aglt003(asi_file)資料匯入
           #1.asi13(關係人) 空白--> insert into asm_file
           #2.asi13(關係人) 非空白 --> insert into asn_file
           #3.group by asi14,asi15,asi16,asi17(異動碼5~8) -->insert into asnn_file

           LET l_sql="SELECT * FROM asi_file ", 
                     " WHERE asi01 ='",g_dept[i].asa01,"'", 
                     #"   AND asi04 ='",g_dept[i].asa03,"'", 
                     "   AND asi04 ='",g_dept[i].asa02,"'",    #TQC-AA0098
                     "   AND asi041='",g_dept[i].asa03,"'",
                     #"   AND asi05 <> '",g_aaz113,"'",   #FUN-B50001
                     "   AND asi05 <> '",g_asz05,"'",     #FUN-B50001
                     "   AND asi06 = ",tm.yy,
                     #"   AND asi07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",   #FUN-B50001
                     "   AND asi07 = '",tm.em,"'",    #FUN-B50001
                     #"   AND (asi13 IS NULL OR asi13 = '')",    #關係人      #TQC-AA0098
                     "   ORDER BY asi04,asi06,asi07,asi05"

           PREPARE p000_asi_p1 FROM l_sql
           IF STATUS THEN
               LET g_showmsg= tm.yy,"/",g_dept[i].asa03,"/",g_dept[i].asa03     #NO.FUN-710023
               CALL s_errmsg('asi06,asi04,asi041',g_showmsg ,'prepare:3',STATUS,1)  #NO.FUN-710023
               LET g_success = 'N'
               CONTINUE FOR           
           END IF
           DECLARE p000_asi_c1 CURSOR FOR p000_asi_p1
           INITIALIZE g_asi.* TO NULL
           FOREACH p000_asi_c1 INTO g_asi.*

               IF SQLCA.sqlcode THEN 
                  LET g_showmsg= tm.yy,"/",g_dept[i].asa03,"/",g_dept[i].asa03      
                  CALL s_errmsg('asi06,asi04,asi041',g_showmsg,'p000_asi_c1',SQLCA.sqlcode,1)  
                  LET g_success = 'N'   
                  CONTINUE FOREACH     
               END IF
               LET l_ash.ash11 = '1'
               LET l_ash.ash12 = '1'
               DISPLAY g_asi.asi07,'->',l_ash.ash06,' ',g_asi.asi05,' ',g_asi.asi08,' ',g_asi.asi09
               
               #抓取合併財報科目編號(ash06),
               SELECT * INTO l_ash.* FROM ash_file    
                WHERE ash01 = g_dept[i].asa02 
                  AND ash00 = g_dept[i].asa03
		          AND ash04 = g_asi.asi05
                  AND ash13 = g_dept[i].asa01
               IF STATUS THEN 
                  LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_asi.asi05  #MOD-B70099
                 #CALL s_errmsg(' ',' ',g_asi.asi05,'aap-021',1)                       #MOD-B70099 mark 
                  CALL s_errmsg('asg01,aah00,aah01',g_showmsg,g_asi.asi05,'aap-021',1) #MOD-B70099
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
#FUN-B90034--add--str--增加匯率的處理
              #IF l_asa07 = 'N' THEN   ##單層合併   #FUN-B90051
                  SELECT aag04 INTO l_aag04 FROM aag_file
                   WHERE aag00 = g_dept[i].asz01 AND aag01 = l_ash.ash06
                  LET g_asi.asi18 = g_asi.asi08
                  LET g_asi.asi19 = g_asi.asi09
                  #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
                  #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
                  #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
                  #  乘上匯率逐一算出借貸方計帳金額(asr08,asr09 OR ass10,ass11)
                  SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asa02
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('asg01',g_dept[i].asa02,' ',SQLCA.sqlcode,1) 
                     LET g_success = 'N'
                     CONTINUE  FOREACH  
                  END IF
                  #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
                  #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                  #一一換算後再加總起來 
                  ##否則抓取agli008中的匯率      
                  LET l_chg_aah04_1=0
                  LET l_chg_aah05_1=0
                  LET l_chg_aah04=0
                  LET l_chg_aah05=0
                  LET l_chg_aah04_a=0
                  LET l_chg_aah05_a=0

                  LET l_chg_dr = 0 
                  LET l_chg_cr = 0
                  LET l_fun_dr = 0 
                  LET l_fun_cr = 0 
                  LET l_acc_dr = 0 
                  LET l_acc_cr = 0
                  LET l_dr = 0
                  LET l_cr = 0 

                  #--現時匯率---
                  IF l_ash.ash11='1' THEN 
                      CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                        l_ash.ash11,l_asg.asg06,
                                        l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)
                      RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                  END IF
                  #--歷史匯率---
                  IF l_ash.ash11='2'  THEN  
                     #----如果agli011抓不到資料，則依科目餘額計算---- 
                     DECLARE p000_cnt_cs13 CURSOR FOR p000_asf_p2
                     OPEN p000_cnt_cs13
                     USING g_dept[i].asa01,g_dept[i].asa02,
                          g_asi.asi05,g_date_e  
                     FETCH p000_cnt_cs13 INTO l_asf_count
                     CLOSE p000_cnt_cs13
                     IF l_asf_count > 0 THEN   
                        CALL p000_asf(i,l_ash.ash04,g_asi.asi05,g_date_e)  
                         RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                     ELSE
                         #--取不到agli011時一樣用匯率換算---
                         CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                       l_ash.ash11,l_asg.asg06,
                                       l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)  
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF
                  ELSE
                     CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                       l_ash.ash11,l_asg.asg06,
                                       l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)
                     RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                  END IF
       
                  #--平均匯率---
                  IF l_ash.ash11='3' THEN
                      IF g_asa05 = '1' THEN      
                          CALL p000_fun_avg(l_ash.ash11,g_asi.asi05,l_asg.asg06,l_asg.asg07,
                                            g_asi.asi06,g_asi.asi07,i,g_asi.asi18,g_asi.asi19)   
                          RETURNING l_fun_dr,l_fun_cr 
                      ELSE                
                          CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                            l_ash.ash11,l_asg.asg06,
                                            l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)  
                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                      END IF
                  END IF  

                  #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                  #--現時匯率---
                  IF l_ash.ash12='1' THEN 
                      CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                        l_ash.ash12,l_asg.asg07,
                                        x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05)   
                      RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                  END IF

                  #--歷史匯率---
                  IF l_ash.ash12='2'  THEN  
                      #----如果agli011抓不到資料，則依科目餘額計算---- 
                      DECLARE p000_cnt_cs25 CURSOR FOR p000_asf_p2
                      OPEN p000_cnt_cs25
                      USING g_dept[i].asa01,g_dept[i].asa02,
                            g_asi.asi05,g_date_e             
                      FETCH p000_cnt_cs25 INTO l_asf_count
                      CLOSE p000_cnt_cs25
                      IF l_asf_count > 0 THEN   
                          CALL p000_asf(i,l_ash.ash04,g_asi.asi05,g_date_e)    
                          RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                      ELSE
                          #--取不到agli011時一樣用匯率換算---
                          CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                            l_ash.ash12,l_asg.asg07,
                                            x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05) 
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                      END IF
                  ELSE
                      CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                        l_ash.ash12,l_asg.asg07,
                                        x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05)     
                      RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                  END IF
          
                  #--平均匯率---
                  IF l_ash.ash12='3' THEN
                      IF g_asa05 = '1' THEN 
                          CALL p000_avg(l_ash.ash11,l_ash.ash12,g_asi.asi05,
                                        l_asg.asg06,l_asg.asg07,
                                        g_asi.asi06,g_asi.asi07,i,g_asi.asi18,g_asi.asi19)
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                      ELSE
                          CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                            l_ash.ash12,l_asg.asg07,
                                            x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05)  
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                      END IF
                  END IF
                  LET l_chg_aah04  =l_chg_aah04   + l_fun_dr  #功能幣借方金額
                  LET l_chg_aah05  =l_chg_aah05   + l_fun_cr  #功能幣貸方金額
                  LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
                  LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額

                  SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07                                                                               
                  IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
                  SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
                  IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                                      
                  LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
                  LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
                  LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
                  LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
                                                                                                             
                  IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
                  IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF
                  LET g_asi.asi21 = l_chg_aah04
                  LET g_asi.asi22 = l_chg_aah05
                  LET g_asi.asi08 = l_chg_aah04_1
                  LET g_asi.asi09 = l_chg_aah05_1                  
              #END IF                  #FUN-B90051 
#FUN-B90034--add--end             
               INSERT INTO asm_file                                                                                                                        
                 (asm00,asm01,asm02,asm03,
                  asm04,asm05,asm06,asm07,
                  asm08,asm09,asm10,asm11,
                  asm12,asm13,asm14,asm15,asm16,asm17,asm18,  #FUN-B50001  Add
                  asmlegal,asm20,asm21)                       #No.FUN-C80020
               VALUES                                                                                                                                     
                 #(g_dept[i].aaz641,g_dept[i].asa01,   #FUN-B50001
                 (g_dept[i].asz01,g_dept[i].asa01,
                  g_dept[i].asa02,g_dept[i].asa03,  
                  l_ash.ash06,g_asi.asi06,
                  g_asi.asi07,g_asi.asi08,
                  g_asi.asi09,g_asi.asi10,
                  #g_asi.asi11,g_asi.asi12,    #FUN-B90034
                  g_asi.asi11,x_aaa03,
                  g_asi.asi18,g_asi.asi19,   #FUN-B50001 Add
                  g_asi.asi20,g_asi.asi21,   #FUN-B50001 Add
                  g_asi.asi22,g_asi.asi23,   #FUN-B50001 Add
                  g_asi.asi24,               #FUN-B50001 Add
                  g_azw02,tm.yy,tm.em)       #No.FUN-C80020
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                   UPDATE asm_file SET asm07 = asm07 + g_asi.asi08,
                                       asm08 = asm08 + g_asi.asi09,
                                       asm09 = asm09 + g_asi.asi10,
                                       asm10 = asm10 + g_asi.asi11
                                       #FUN-B50001--add--str--
                                      ,asm12 = asm12 + g_asi.asi18,
                                       asm13 = asm13 + g_asi.asi19,
                                       asm15 = asm15 + g_asi.asi21,
                                       asm16 = asm16 + g_asi.asi22
                                       #FUN-B50001--add--end
                    #WHERE asm00 = g_dept[i].aaz641   #FUN-B50001
                    WHERE asm00 = g_dept[i].asz01
                      AND asm01 = g_dept[i].asa01                                                                                                         
                      AND asm02 = g_dept[i].asa02                                                                                                         
                      AND asm03 = g_dept[i].asa03                                                                                                         
                      AND asm04= l_ash.ash06
                      AND asm05 = g_asi.asi06
                      AND asm06 = g_asi.asi07
                      #AND asm11 = g_asi.asi12   #FUN-B90034
                      AND asm11 = x_aaa03
                      AND asm18 = g_asi.asi24   #FUN-B50001
                      AND asm20 = tm.yy          #No.FUN-C80020  
                      AND asm21 = tm.em          #No.FUN-C80020  
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)                                                                                        
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN                                                                                               
                       CALL s_errmsg('asr01',g_dept[i].asa01,'upd_asm',SQLCA.sqlcode,1)                                                                       
                       LET g_success = 'N'                                                                                                                    
                       CONTINUE FOREACH     
                   END IF                                                                                                                                    
               ELSE                                                                                                                                        
                   IF STATUS THEN                                                                                                                            
                      CALL s_errmsg('asr01',g_dept[i].asa01,'ins_asm',status,1)                                                                              
                      LET g_success = 'N'                                                                                                                    
                      CONTINUE FOREACH   
                   END IF                                                                                                                                    
               END IF                                        
           END FOREACH   
  
           LET l_sql="SELECT * FROM asi_file ", 
                     " WHERE asi01 ='",g_dept[i].asa01,"'", 
                     #"   AND asi04 ='",g_dept[i].asa03,"'", 
                     "   AND asi04 ='",g_dept[i].asa02,"'",   #TQC-AA0098
                     "   AND asi041='",g_dept[i].asa03,"'",
                     #"   AND asi05 <> '",g_aaz113,"'",   #FUN-B50001
                     "   AND asi05 <> '",g_asz05,"'",
                     "   AND asi06 = ",tm.yy,
                     "   AND asi07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                     #"   AND asi13 IS NOT NULL",    #關係人     
                     "   AND (asi13 IS NOT NULL AND asi13 <> ' ')",    #關係人     #FUN-AA0098
                     "   ORDER BY asi04,asi06,asi07,asi05"
           PREPARE p000_asi_p2 FROM l_sql
           IF STATUS THEN
               LET g_showmsg= tm.yy,"/",g_dept[i].asa03,"/",g_dept[i].asa03     
               CALL s_errmsg('asi06,asi04,asi041',g_showmsg ,'prepare:p000_asi_p2',STATUS,1) 
               LET g_success = 'N'
               CONTINUE FOR           
           END IF
           DECLARE p000_asi_c2 CURSOR FOR p000_asi_p2
           INITIALIZE g_asi.* TO NULL
           FOREACH p000_asi_c2 INTO g_asi.*
               IF SQLCA.sqlcode THEN 
                  LET g_showmsg= tm.yy,"/",g_dept[i].asa03,"/",g_dept[i].asa03      
                  CALL s_errmsg('asi06,asi04,asi041',g_showmsg,'p000_asi_c2',SQLCA.sqlcode,1)  
                  LET g_success = 'N'   
                  CONTINUE FOREACH     
               END IF
               LET l_ash.ash11 = '1'
               LET l_ash.ash12 = '1'
               DISPLAY g_asi.asi07,'->',l_ash.ash06,' ',g_asi.asi05,' ',g_asi.asi08,' ',g_asi.asi09
               
#FUN-B70103   ---start   Add
               LET l_aal03 = NULL
               SELECT aal03 INTO l_aal03 FROM aal_file
                WHERE aal01 = g_dept[i].asa02
                  AND aal02 = g_asi.asi13
               IF NOT cl_null(l_aal03) THEN
                  LET g_asi.asi13 = l_aal03
               END IF
#FUN-B70103   ---end     Add

               #抓取合併財報科目編號(ash06),
               SELECT * INTO l_ash.* FROM ash_file    
                WHERE ash01 = g_dept[i].asa02 
                  AND ash00 = g_dept[i].asa03
		  AND ash04 = g_asi.asi05
                  AND ash13 = g_dept[i].asa01
               IF STATUS THEN 
                  LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_asi.asi05  #MOD-B70099
                 #CALL s_errmsg(' ',' ',g_asi.asi05,'aap-021',1)                       #MOD-B70099 mark 
                  CALL s_errmsg('asg01,aah00,aah01',g_showmsg,g_asi.asi05,'aap-021',1) #MOD-B70099
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
#FUN-B90034--add--str--增加匯率的處理
              #IF l_asa07 = 'N' THEN   ##單層合併    #FUN-B90057
                  SELECT aag04 INTO l_aag04 FROM aag_file
                   WHERE aag00 = g_dept[i].asz01 AND aag01 = l_ash.ash06
                  LET g_asi.asi18 = g_asi.asi08
                  LET g_asi.asi19 = g_asi.asi09
                  #2.匯率依agli001科目匯率類別(ash11)設定,對應agli008
                  #  年度期別來源幣別轉換匯率(ase05 or ase06 or ase07)設定,
                  #  金額(asi08,asi09 OR aah04,aah05 OR aed05,aed06),
                  #  乘上匯率逐一算出借貸方計帳金額(asr08,asr09 OR ass10,ass11)
                  SELECT * INTO l_asg.* FROM asg_file WHERE asg01=g_dept[i].asa02
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('asg01',g_dept[i].asa02,' ',SQLCA.sqlcode,1) 
                     LET g_success = 'N'
                     CONTINUE  FOREACH  
                  END IF
                  #當再衡量匯率類別(ash11),換算匯率類別(ash12)選擇的是歷史匯率時,
                  #金額需抓agli011設定的記帳幣別金額(小於等於本期),
                  #一一換算後再加總起來 
                  ##否則抓取agli008中的匯率      
                  LET l_chg_aah04_1=0
                  LET l_chg_aah05_1=0
                  LET l_chg_aah04=0
                  LET l_chg_aah05=0
                  LET l_chg_aah04_a=0
                  LET l_chg_aah05_a=0

                  LET l_chg_dr = 0 
                  LET l_chg_cr = 0
                  LET l_fun_dr = 0 
                  LET l_fun_cr = 0 
                  LET l_acc_dr = 0 
                  LET l_acc_cr = 0
                  LET l_dr = 0
                  LET l_cr = 0 

                  #--現時匯率---
                  IF l_ash.ash11='1' THEN 
                      CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                        l_ash.ash11,l_asg.asg06,
                                        l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)
                      RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                  END IF
                  #--歷史匯率---
                  IF l_ash.ash11='2'  THEN  
                     #----如果agli011抓不到資料，則依科目餘額計算---- 
                     DECLARE p000_cnt_cs21 CURSOR FOR p000_asf_p2
                     OPEN p000_cnt_cs21
                     USING g_dept[i].asa01,g_dept[i].asa02,
                          g_asi.asi05,g_date_e  
                     FETCH p000_cnt_cs21 INTO l_asf_count
                     CLOSE p000_cnt_cs21
                     IF l_asf_count > 0 THEN   
                        CALL p000_asf(i,l_ash.ash04,g_asi.asi05,g_date_e)  
                         RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                     ELSE
                         #--取不到agli011時一樣用匯率換算---
                         CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                       l_ash.ash11,l_asg.asg06,
                                       l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)  
                         RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                     END IF
                  ELSE
                     CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                       l_ash.ash11,l_asg.asg06,
                                       l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)
                     RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                  END IF
       
                  #--平均匯率---
                  IF l_ash.ash11='3' THEN
                      IF g_asa05 = '1' THEN      
                          CALL p000_fun_avg(l_ash.ash11,g_asi.asi05,l_asg.asg06,l_asg.asg07,
                                            g_asi.asi06,g_asi.asi07,i,g_asi.asi18,g_asi.asi19)   
                          RETURNING l_fun_dr,l_fun_cr 
                      ELSE                
                          CALL p000_fun_amt(l_aag04,g_asi.asi18,g_asi.asi19,
                                            l_ash.ash11,l_asg.asg06,
                                            l_asg.asg07,g_asi.asi06,g_asi.asi07,g_asa05)  
                          RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
                      END IF
                  END IF  

                  #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
                  #--現時匯率---
                  IF l_ash.ash12='1' THEN 
                      CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                        l_ash.ash12,l_asg.asg07,
                                        x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05)   
                      RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                  END IF

                  #--歷史匯率---
                  IF l_ash.ash12='2'  THEN  
                      #----如果agli011抓不到資料，則依科目餘額計算---- 
                      DECLARE p000_cnt_cs26 CURSOR FOR p000_asf_p2
                      OPEN p000_cnt_cs26
                      USING g_dept[i].asa01,g_dept[i].asa02,
                            g_asi.asi05,g_date_e             
                      FETCH p000_cnt_cs26 INTO l_asf_count
                      CLOSE p000_cnt_cs26
                      IF l_asf_count > 0 THEN   
                          CALL p000_asf(i,l_ash.ash04,g_asi.asi05,g_date_e)    
                          RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
                      ELSE
                          #--取不到agli011時一樣用匯率換算---
                          CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                            l_ash.ash12,l_asg.asg07,
                                            x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05) 
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                      END IF
                  ELSE
                      CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                        l_ash.ash12,l_asg.asg07,
                                        x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05)     
                      RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                  END IF
          
                  #--平均匯率---
                  IF l_ash.ash12='3' THEN
                      IF g_asa05 = '1' THEN 
                          CALL p000_avg(l_ash.ash11,l_ash.ash12,g_asi.asi05,
                                        l_asg.asg06,l_asg.asg07,
                                        g_asi.asi06,g_asi.asi07,i,g_asi.asi18,g_asi.asi19)
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                      ELSE
                          CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                                            l_ash.ash12,l_asg.asg07,
                                            x_aaa03,g_asi.asi06,g_asi.asi07,g_asa05)  
                          RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
                      END IF
                  END IF
                  LET l_chg_aah04  =l_chg_aah04   + l_fun_dr  #功能幣借方金額
                  LET l_chg_aah05  =l_chg_aah05   + l_fun_cr  #功能幣貸方金額
                  LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣別借方金額
                  LET l_chg_aah05_1=l_chg_aah05_1 + l_acc_cr  #記帳幣別貸方金額

                  SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07                                                                               
                  IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
                  SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
                  IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                                      
                  LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)                                                                                                
                  LET l_chg_aah05=cl_digcut(l_chg_aah05,l_cut)                                                                                                
                  LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)                                                                                           
                  LET l_chg_aah05_1=cl_digcut(l_chg_aah05_1,l_cut1)                                                                                           
                                                                                                             
                  IF cl_null(l_chg_aah04_1) THEN LET l_chg_aah04_1=0 END IF                                                                                   
                  IF cl_null(l_chg_aah05_1) THEN LET l_chg_aah05_1=0 END IF
                  LET g_asi.asi21 = l_chg_aah04
                  LET g_asi.asi22 = l_chg_aah05
                  LET g_asi.asi08 = l_chg_aah04_1
                  LET g_asi.asi09 = l_chg_aah05_1                  
              #END IF                  #FUN-B90057 
#FUN-B90034--add--end               
               INSERT INTO asn_file 
                  (asn00,asn01,asn02,asn03,asn04,asn05,
                   asn06,asn07,asn08,asn09,asn10,asn11,asn12,
                   asn13,asn14,asn15,asn16,asn17,asn18,asn19,    #FUN-B50001 Add
                   asnlegal,asn20,asn21)    #MOD-B30441 asnlegal #No.FUN-C80020
               VALUES 
                  #(g_dept[i].aaz641,g_dept[i].asa01,g_dept[i].asa02,   #FUN-B50001 
                  (g_dept[i].asz01,g_dept[i].asa01,g_dept[i].asa02,  
                   g_dept[i].asa03,l_ash.ash06,g_asi.asi13,  
                   g_asi.asi06,g_asi.asi07,g_asi.asi08,
                   g_asi.asi09,g_asi.asi10,g_asi.asi11,
                   #g_asi.asi12,   #FUN-B90034
                   x_aaa03,
                   g_asi.asi18,g_asi.asi19,g_asi.asi20,         #FUN-B50001 Add
                   g_asi.asi21,g_asi.asi22,g_asi.asi23,         #FUN-B50001 Add
                   g_asi.asi24,                                 #FUN-B50001 Add
                   g_azw02,tm.yy,tm.em)                         #No.FUN-C80020
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
                  UPDATE asn_file SET asn08 = asn08 + g_asi.asi08,
                                      asn09 = asn09 + g_asi.asi09,
                                      asn10 = asn10 + g_asi.asi10,
                                      asn11 = asn11 + g_asi.asi11
                                     #FUN-B50001--add--str--
                                     ,asn13 = asn13 + g_asi.asi18,
                                      asn14 = asn14 + g_asi.asi19,
                                      asn16 = asn16 + g_asi.asi21,
                                      asn17 = asn17 + g_asi.asi22
                                     #FUN-B50001--add--end
                      #WHERE asn00 = g_dept[i].aaz641    #FUN-B50001
                      WHERE asn00 = g_dept[i].asz01
                        AND asn01 = g_dept[i].asa01
                        AND asn02 = g_dept[i].asa02
                        AND asn03 = g_dept[i].asa03
                        AND asn04 = l_ash.ash06
                        AND asn05 = g_asi.asi13
                        AND asn06 = g_asi.asi06
                        AND asn07 = g_asi.asi07
                        #AND asn12 = g_asi.asi12   #FUN-B90034
                        AND asn12 = x_aaa03
                        AND asn19 = g_asi.asi24   #FUN-B50001
                        AND asn20 = tm.yy          #No.FUN-C80020
                        AND asn21 = tm.em          #No.FUN-C80020
                  #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
                     CALL s_errmsg('asn01',g_dept[i].asa01,'upd_asn',SQLCA.sqlcode,1) 
                     LET g_success = 'N' 
                     CONTINUE FOREACH  
                  END IF
               ELSE
                  IF STATUS THEN 
                     LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_dept[i].asz01,"/",g_dept[i].asa03      
                     CALL s_errmsg('asn01,asn02,asn03,asn04,asn05',g_showmsg,'ins_asn',status,1)                
                     LET g_success = 'N'
                     CONTINUE FOREACH       
                  END IF
               END IF                          
           END FOREACH

           LET l_sql="SELECT * FROM asi_file ", 
                     " WHERE asi01 ='",g_dept[i].asa01,"'", 
                     #"   AND asi04 ='",g_dept[i].asa03,"'", 
                     "   AND asi04 ='",g_dept[i].asa02,"'",   #TQC-AA0098
                     "   AND asi041='",g_dept[i].asa03,"'",
                     #"   AND asi05 <> '",g_aaz113,"'",   #FUN-B50001
                     "   AND asi05 <> '",g_asz05,"'",
                     "   AND asi06 = ",tm.yy,
                     "   AND asi07 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                     "   GROUP BY asi14,asi15,asi16,asi17 ",
                     "   ORDER BY asi04,asi06,asi07,asi05"

           PREPARE p000_asi_p3 FROM l_sql
           IF STATUS THEN
               LET g_showmsg= tm.yy,"/",g_dept[i].asa03,"/",g_dept[i].asa03     
               CALL s_errmsg('asi06,asi04,asi041',g_showmsg ,'prepare:p000_asi_p3',STATUS,1) 
               LET g_success = 'N'
               CONTINUE FOR           
           END IF
           DECLARE p000_asi_c3 CURSOR FOR p000_asi_p3
           INITIALIZE g_asi.* TO NULL
           FOREACH p000_asi_c3 INTO g_asi.*
               IF SQLCA.sqlcode THEN 
                  LET g_showmsg= tm.yy,"/",g_dept[i].asa03,"/",g_dept[i].asa03      
                  CALL s_errmsg('asi06,asi04,asi041',g_showmsg,'p000_asi_c3',SQLCA.sqlcode,1)  
                  LET g_success = 'N'   
                  CONTINUE FOREACH     
               END IF
               LET l_ash.ash11 = '1'
               LET l_ash.ash12 = '1'
               DISPLAY g_asi.asi07,'->',l_ash.ash06,' ',g_asi.asi05,' ',g_asi.asi08,' ',g_asi.asi09
               
               #抓取合併財報科目編號(ash06),
               SELECT * INTO l_ash.* FROM ash_file    
                WHERE ash01 = g_dept[i].asa02 
                  AND ash00 = g_dept[i].asa03
		  AND ash04 = g_asi.asi05
                  AND ash13 = g_dept[i].asa01
               IF STATUS THEN 
                  LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_asi.asi05  #MOD-B70099
                 #CALL s_errmsg(' ',' ',g_asi.asi05,'aap-021',1)                       #MOD-B70099 mark 
                  CALL s_errmsg('asg01,aah00,aah01',g_showmsg,g_asi.asi05,'aap-021',1) #MOD-B70099
                  LET g_success = 'N'
                  CONTINUE FOREACH 
               END IF
               IF cl_null(g_asi.asi14) THEN LET g_asi.asi14 = ' ' END IF
               IF cl_null(g_asi.asi15) THEN LET g_asi.asi15 = ' ' END IF
               IF cl_null(g_asi.asi16) THEN LET g_asi.asi16 = ' ' END IF
               IF cl_null(g_asi.asi17) THEN LET g_asi.asi17 = ' ' END IF
               INSERT INTO asnn_file
                 (asnn00,asnn01,asnn02,asnn03,asnn04,
                  asnn05,asnn06,asnn07,asnn08,asnn09,
                  asnn10,asnn11,asnn12,asnn13,asnn14,
                  asnn15,asnnlegal,asnn16,asnn20,asnn21)         #No.FUN-C80020
               VALUES
                #(g_dept[i].aaz641,g_dept[i].asa01,g_dept[i].asa02,   #FUN-B50001
                (g_dept[i].asz01,g_dept[i].asa01,g_dept[i].asa02,
                 g_dept[i].asa03,l_ash.ash06,g_asi.asi14,
                 g_asi.asi15,g_asi.asi16,g_asi.asi17,
                 g_asi.asi06,g_asi.asi07,g_asi.asi08,
                 g_asi.asi09,g_asi.asi10,g_asi.asi11,
                 g_asi.asi12,g_azw02,g_dept[i].asa02,tm.yy,tm.em)         #No.FUN-C80020
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  
                   UPDATE asnn_file SET asnn11 = asnn11 + g_asi.asi08,
                                       asnn12 = asnn12 + g_asi.asi09,
                                       asnn13 = asnn13 + g_asi.asi10,
                                       asnn14 = asnn14 + g_asi.asi11
                   #No.FUN-C80020  --Begin
                    WHERE asnn00 = g_dept[i].asz01
                      AND asnn01 = g_dept[i].asa01 
                      AND asnn02 = g_dept[i].asa02 
                      AND asnn03 = g_dept[i].asa03 
                      AND asnn04 = l_ash.ash06 
                      AND asnn05 = g_asi.asi14
                      AND asnn06 = g_asi.asi15 
                      AND asnn07 = g_asi.asi16 
                      AND asnn08 = g_asi.asi17 
                      AND asnn09 = g_asi.asi06 
                      AND asnn10 = g_asi.asi07 
                      AND asnn15 = g_asi.asi12
                      AND asnn16 = g_dept[i].asa02 
                      AND asnn20 = tm.yy
                      AND asnn21 = tm.em
                   #No.FUN-C80020  --End  
                   #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                      CALL s_errmsg('asnn01',g_dept[i].asa01,'upd_asnn',SQLCA.sqlcode,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               ELSE
                   IF STATUS THEN
                      LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_dept[i].asz01,"/",g_dept[i].asa03
                      CALL s_errmsg('asnn01,asnn02,asnn00,asnn04',g_showmsg,'ins_asnn',status,1)
                      LET g_success = 'N'
                      CONTINUE FOREACH
                   END IF
               END IF
           END FOREACH	　	　	　	　
       END IF 
#FUN-B90057--mark--str--資產類科目匯差調整計入調整憑證
#      #FUN-B90019--add--str--資產類科目-所有者權益科目-負債類科目計入asz04(換算調整科目)
       INITIALIZE l_asm.* TO NULL
       LET l_asm.asm00 = g_dept[i].asz01
       LET l_asm.asm01 = g_dept[i].asa01
       LET l_asm.asm02 = g_dept[i].asa02
       LET l_asm.asm03 = g_dept[i].asa03
       LET l_asm.asm04 = g_asz.asz04
       LET l_asm.asm05 = tm.yy
       LET l_asm.asm06 = tm.em
#FUN-B90057--mark--end
       LET l_amt1= 0 LET l_amt2 = 0
       LET l_amt3= 0 LET l_amt4 = 0   #FUN-B90034
       
       LET l_sql = "SELECT SUM(asm07-asm08) FROM asm_file,aag_file ",   ###借-貸
                   " WHERE asm00 = aag00 AND asm04 = aag01 ",
                   "   AND aag04 = '1' AND aag06 = '1'",  #借余
                   "   AND aag03 = '2' AND aag07<>1 ",
                   "   AND asm00 = '",g_dept[i].asz01,"'",
                   "   AND asm01 = '",g_dept[i].asa01,"'",
                   "   AND asm02 = '",g_dept[i].asa02,"'",
                   "   AND asm03 = '",g_dept[i].asa03,"'",
                   "   AND asm05 = '",tm.yy,"'",  
                   "   AND asm11 = '",x_aaa03,"'",
                   "   AND asm18 = '",g_dept[i].asa02,"'" ,
                   "   AND asm20 = ",tm.yy,                     #No.FUN-C80020
                   "   AND asm21 = ",tm.em                      #No.FUN-C80020
       #FUN-B90034--mod--str--                   
       #IF l_asg04 = 'Y' THEN 
       #   LET l_sql = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       #ELSE
       #   LET l_sql = l_sql CLIPPED," AND asm06 = '",tm.em,"'"
       #END IF 
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN  
          LET l_sql1 = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
          LET l_sql2 = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em-1,"'"   
          PREPARE p000_asz04_cur3 FROM l_sql2
          EXECUTE p000_asz04_cur3 INTO l_amt3       
       ELSE
          LET l_sql1 = l_sql CLIPPED," AND asm06 = '",tm.em,"'"       
       END IF        
       #FUN-B90034--mod--end       
       PREPARE p000_asz04_cur FROM l_sql1
       EXECUTE p000_asz04_cur INTO l_amt1
       IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
       IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF       #FUN-B90034 
       LET l_sql = "SELECT SUM(asm08-asm07) FROM asm_file,aag_file ",   ###貸-借
                   " WHERE asm00 = aag00 AND asm04 = aag01 ",
                   "   AND aag04 = '1' AND aag06 = '2'",  #貸余
                   "   AND aag03 = '2' AND aag07<>1 ",
                   "   AND asm00 = '",g_dept[i].asz01,"'",
                   "   AND asm01 = '",g_dept[i].asa01,"'",
                   "   AND asm02 = '",g_dept[i].asa02,"'",
                   "   AND asm03 = '",g_dept[i].asa03,"'",
                   "   AND asm05 = '",tm.yy,"'",
                   "   AND asm11 = '",x_aaa03,"'",
                   "   AND asm18 = '",g_dept[i].asa02,"'",
                   "   AND asm20 = ",tm.yy,                     #No.FUN-C80020
                   "   AND asm21 = ",tm.em                      #No.FUN-C80020
       #FUN-B90034--mod-str--                   
       #IF l_asg04 = 'Y' THEN   #FUN-B90034
       #   LET l_sql = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       #ELSE
       #   LET l_sql = l_sql CLIPPED," AND asm06 = '",tm.em,"'"
       #END IF
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql1 = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"       
          LET l_sql2 = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em-1,"'"           
          PREPARE p000_asz04_cur4 FROM l_sql2
          EXECUTE p000_asz04_cur4 INTO l_amt4          
       ELSE
          LET l_sql1 = l_sql CLIPPED," AND asm06 = '",tm.em,"'"      
       END IF        
       #FUN-B90034--mod--end
       #PREPARE p000_asz04_cur1 FROM l_sql   #FUN-B90034
       PREPARE p000_asz04_cur1 FROM l_sql1   #FUN-B90034
       EXECUTE p000_asz04_cur1 INTO l_amt2
       IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
       IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF     #FUN-B90034   
       #LET l_amt = l_amt1-l_amt2   #FUN-B90034
       #LET l_amt = l_amt1-l_amt2-(l_amt3-l_amt4)   #FUN-B90034   #luttb 110928
        LET l_amt = l_amt1-l_amt2                   #luttb 110928
#FUN-B90057--mark--str--
       IF l_amt>0 THEN 
          LET l_asm.asm07 = 0
          LET l_asm.asm08 = l_amt
          LET l_asm.asm09 = 0
          LET l_asm.asm10 = 1
       ELSE
          LET l_asm.asm07 = l_amt*-1
          LET l_asm.asm08 = 0
          LET l_asm.asm09 = 1
          LET l_asm.asm10 = 0
       END IF  
       LET l_asm.asm11 = x_aaa03
       LET l_asm.asmlegal = g_legal
       LET l_asm.asm12 = l_asm.asm07
       LET l_asm.asm13 = l_asm.asm08
       LET l_asm.asm14 = ' '
       LET l_asm.asm15 = l_asm.asm07
       LET l_asm.asm16 = l_asm.asm08
       LET l_asm.asm17 = ' '
       LET l_asm.asm18 = ' '
       LET l_asm.asm20 = tm.yy               #No.FUN-C80020
       LET l_asm.asm21 = tm.em               #No.FUN-C80020
       INSERT INTO asm_file VALUES l_asm.*
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_showmsg=g_dept[i].asa01,"/",g_dept[i].asa02,"/", g_dept[i].asz01,"/",g_dept[i].asa03
          CALL s_errmsg('asm01,asm02,asm00,asm03',g_showmsg,'ins_asm',status,1)
          LET g_success = 'N'
       END IF
#      #FUN-B90019--add--end
#FUN-B90057--mark--end
       CALL p000_ins_asj(l_amt,g_dept[i].asa01,g_dept[i].asa02,g_asz.asz05,g_asz.asz04,'8')   #FUN-B90057


       #FUN-B90057--add--str--損益類科目價差產生至調整憑證
       LET l_amt = 0 LET l_amt1 = 0 LET l_amt2 = 0 LET l_amt3 = 0 LET l_amt4 = 0
       LET l_chg_aah04_1=0 LET l_chg_aah05_1=0 LET l_chg_aah04=0 LET l_chg_aah05=0
       LET l_chg_dr = 0 LET l_fun_dr = 0 LET l_fun_cr = 0 LET l_acc_dr = 0
       LET l_acc_cr = 0 LET l_dr = 0 LET l_cr = 0
       ###費用類科目轉換前以及轉換后金額
       LET l_sql = "SELECT SUM(asm07-asm08),SUM(asm12-asm13) FROM asm_file,aag_file ",   ###借-貸
                   " WHERE asm00 = aag00 AND asm04 = aag01 ",
                   "   AND aag04 = '2' AND aag06 = '1'",  #損益類,借余
                   "   AND aag03 = '2' AND aag07<>1 ",
                   "   AND asm00 = '",g_dept[i].asz01,"'",
                   "   AND asm01 = '",g_dept[i].asa01,"'",
                   "   AND asm02 = '",g_dept[i].asa02,"'",
                   "   AND asm03 = '",g_dept[i].asa03,"'",
                   "   AND asm05 = '",tm.yy,"'",
                   "   AND asm11 = '",x_aaa03,"'",
                   "   AND asm18 = '",g_dept[i].asa02,"'",
                   "   AND asm20 = ",tm.yy,                       #No.FUN-C80020
                   "   AND asm21 = ",tm.em                        #No.FUN-C80020
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       ELSE
          LET l_sql = l_sql CLIPPED," AND asm06 = '",tm.em,"'"
       END IF
       PREPARE p000_asm_cur1 FROM l_sql
       EXECUTE p000_asm_cur1 INTO l_amt1,l_amt2   #換算后以及換算前費用科目金額
       IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF 
       IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF 
       ###收入類科目換算后以及換算前金額
       LET l_sql = "SELECT SUM(asm08-asm07),SUM(asm13-asm12) FROM asm_file,aag_file ",   ###貸-借
                   " WHERE asm00 = aag00 AND asm04 = aag01 ",
                   "   AND aag04 = '2' AND aag06 = '2'",  #損益類,貸余
                   "   AND aag03 = '2' AND aag07<>1 ",
                   "   AND asm00 = '",g_dept[i].asz01,"'",
                   "   AND asm01 = '",g_dept[i].asa01,"'",
                   "   AND asm02 = '",g_dept[i].asa02,"'",
                   "   AND asm03 = '",g_dept[i].asa03,"'",
                   "   AND asm05 = '",tm.yy,"'",
                   "   AND asm11 = '",x_aaa03,"'",
                   "   AND asm18 = '",g_dept[i].asa02,"'",
                   "   AND asm20 = ",tm.yy,                       #No.FUN-C80020
                   "   AND asm21 = ",tm.em                        #No.FUN-C80020
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       ELSE
          LET l_sql = l_sql CLIPPED," AND asm06 = '",tm.em,"'"
       END IF
       PREPARE p000_asm_cur2 FROM l_sql
       EXECUTE p000_asm_cur2 INTO l_amt3,l_amt4   ###換算后以及換算前收入科目金額
       IF cl_null(l_amt3) THEN LET l_amt3 = 0 END IF 
       IF cl_null(l_amt4) THEN LET l_amt4 = 0 END IF 
       LET l_amt = l_amt4-l_amt2    ###換算前淨利潤
       
       LET l_sql =
       " SELECT * FROM ash_file ",  
       "  WHERE ash01 = '",g_dept[i].asa02,"'",
       "    AND ash06 = '",g_asz.asz06,"'",
       "    AND ash00 = '",g_dept[i].asa03,"'",
       "    AND ash13 = '",g_dept[i].asa01,"'"
       PREPARE p000_ash_p1 FROM l_sql
       DECLARE p000_ash_c1 SCROLL CURSOR FOR p000_ash_p1
       OPEN p000_ash_c1
       FETCH FIRST p000_ash_c1 INTO l_ash.*
       CLOSE p000_ash_c1
       IF STATUS  THEN
          LET g_showmsg = g_dept[i].asa02,"/",g_dept[i].asa03,"/",g_asz.asz06
          CALL s_errmsg('asg01,,aah00,asz06',g_showmsg,g_asz.asz06,'aap-021',1)  
          LET g_success = 'N'
          CONTINUE FOR
       END IF
       SELECT aag04 INTO l_aag04 FROM aag_file WHERE aag00 = g_asz.asz01
          AND aag01 = g_asz.asz06       
       LET l_fun_dr = 0 LET l_fun_cr = 0
       LET l_acc_dr = 0 LET l_acc_cr = 0
       #--現時匯率---
       IF l_ash.ash11='1' THEN 
          CALL p000_fun_amt(l_aag04,l_amt,0,
                            l_ash.ash11,l_asg.asg06,
                            l_asg.asg07,tm.yy,tm.em,g_asa05)
               RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
       END IF
       #--歷史匯率---
       IF l_ash.ash11='2'  THEN  
          #----如果agli011抓不到資料，則依科目餘額計算---- 
          DECLARE p000_cnt_cs10 CURSOR FOR p000_asf_p2
             OPEN p000_cnt_cs10
            USING g_dept[i].asa01,g_dept[i].asa02,
                  g_asz.asz06,g_date_e  
            FETCH p000_cnt_cs10 INTO l_asf_count
            CLOSE p000_cnt_cs10
          IF l_asf_count > 0 THEN   
             CALL p000_asf(i,l_ash.ash04,g_asz.asz06,g_date_e)  
                  RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額  
          ELSE
             #--取不到agli011時一樣用匯率換算---
             CALL p000_fun_amt(l_aag04,l_amt,0,
                              l_ash.ash11,l_asg.asg06,
                              l_asg.asg07,tm.yy,tm.em,g_asa05)  
                  RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
          END IF
       ELSE
          CALL p000_fun_amt(l_aag04,l_amt,0,
                            l_ash.ash11,l_asg.asg06,
                            l_asg.asg07,tm.yy,tm.em,g_asa05)
               RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
       END IF
       #--平均匯率---
       IF l_ash.ash11='3' THEN
          IF g_asa05 = '1' THEN
             CALL p000_fun_avg(l_ash.ash11,g_asz.asz06,l_asg.asg06,l_asg.asg07,
                               tm.yy,tm.em,i,l_amt,0)
                  RETURNING l_fun_dr,l_fun_cr
          ELSE
             CALL p000_fun_amt(l_aag04,l_amt,0,
                               l_ash.ash11,l_asg.asg06,
                               l_asg.asg07,tm.yy,tm.em,g_asa05)
                  RETURNING l_fun_dr,l_fun_cr  #下層功能借/貸金額
          END IF
       END IF

       #-----依科目在agli001中(換算)匯率各自取出匯率後計算上層記帳幣金額--
       #--現時匯率---
       IF l_ash.ash12='1' THEN
          CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                            l_ash.ash12,l_asg.asg07,
                            x_aaa03,tm.yy,tm.em,g_asa05)
               RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
       END IF
       #--歷史匯率---
       IF l_ash.ash12='2'  THEN
          #----如果agli011抓不到資料，則依科目餘額計算----
          DECLARE p000_cnt_cs27 CURSOR FOR p000_asf_p2
             OPEN p000_cnt_cs27
            USING g_dept[i].asa01,g_dept[i].asa02,
                  g_asz.asz06,g_date_e
            FETCH p000_cnt_cs27 INTO l_asf_count
            CLOSE p000_cnt_cs27
          IF l_asf_count > 0 THEN
             CALL p000_asf(i,l_ash.ash04,g_asz.asz06,g_date_e)
                  RETURNING l_fun_dr,l_fun_cr,l_acc_dr,l_acc_cr  #回傳借/貸方金額
          ELSE
             #--取不到agli011時一樣用匯率換算---
             CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                               l_ash.ash12,l_asg.asg07,
                               x_aaa03,tm.yy,tm.em,g_asa05)
                RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
          END IF
       ELSE
          CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                            l_ash.ash12,l_asg.asg07,
                            x_aaa03,tm.yy,tm.em,g_asa05)
               RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
       END IF

       #--平均匯率---
       IF l_ash.ash12='3' THEN
          IF g_asa05 = '1' THEN
             CALL p000_avg(l_ash.ash11,l_ash.ash12,g_asz.asz06,
                           l_asg.asg06,l_asg.asg07,
                           tm.yy,tm.em,i,l_amt,0)
                  RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
          ELSE
             CALL p000_acc_amt(l_aag04,l_fun_dr,l_fun_cr,
                               l_ash.ash12,l_asg.asg07,
                               x_aaa03,tm.yy,tm.em,g_asa05)
                  RETURNING l_acc_dr,l_acc_cr  #上層記帳借/貸金額
          END IF
       END IF
       LET l_chg_aah04  =l_chg_aah04   + l_fun_dr  #功能幣利潤金額
       LET l_chg_aah04_1=l_chg_aah04_1 + l_acc_dr  #記帳幣利潤金額

       SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg.asg07
       IF cl_null(l_cut) THEN LET l_cut=0 END IF
       SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03
       IF cl_null(l_cut1) THEN LET l_cut1=0 END IF

       LET l_chg_aah04=cl_digcut(l_chg_aah04,l_cut)
       LET l_chg_aah04_1=cl_digcut(l_chg_aah04_1,l_cut1)
       LET l_amt = l_chg_aah04_1-(l_amt3-l_amt1)

       CALL p000_ins_asj(l_amt,g_dept[i].asa01,g_dept[i].asa02,g_asz.asz06,g_asz.asz04,'9')


       ####同一科目若在asm_file,asn_file中合併前金額相等,則合併後金額也要相等,調整入asn_file金額最大一筆中
       LET l_asm07 = 0 LET l_asm08 = 0 LET l_asm12 = 0 LET l_asm13 = 0
       LET l_asn08 = 0 LET l_asn09 = 0 LET l_asn13 = 0 LET l_asn14 = 0

       LET l_sql = "SELECT SUM(asm07),SUM(asm08),SUM(asm12),SUM(asm13) FROM asm_file ",
                   " WHERE asm00 = '",g_asz.asz01,"' AND asm01 = '",g_dept[i].asa01,"'",
                   "   AND asm02 = '",g_dept[i].asa02,"' AND asm05 = '",tm.yy,"'",
                   "   AND asm04 = ? ",
                   "   AND asm20 = ",tm.yy,                       #No.FUN-C80020
                   "   AND asm21 = ",tm.em                        #No.FUN-C80020
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'" 
       ELSE
          LET l_sql = l_sql CLIPPED," AND asm06  = '",tm.em,"'"
       END IF 
       PREPARE p000_sel_asm FROM l_sql             

       LET l_sql = "SELECT SUM(asn08),SUM(asn09),SUM(asn13),SUM(asn14) FROM asn_file ",
                   " WHERE asn00 = '",g_asz.asz01,"' AND asn01 = '",g_dept[i].asa01,"'",
                   "   AND asn02 = '",g_dept[i].asa02,"' AND asn06 = '",tm.yy,"'",
                   "   AND asn04 = ? ",
                   "   AND asn20 = ",tm.yy," AND asn21 = ",tm.em              #No.FUN-C80020
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql = l_sql CLIPPED," AND asn07 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       ELSE
          LET l_sql = l_sql CLIPPED," AND asn07  = '",tm.em,"'"
       END IF
       PREPARE p000_sel_asn FROM l_sql

       LET l_sql = "SELECT MAX(asn08),asn05,asn07,asn12,asn19 FROM asn_file ",
                   " WHERE asn00 = '",g_dept[i].asz01,"'",
                   "   AND asn01 = '",g_dept[i].asa01,"'",
                   "   AND asn02 = '",g_dept[i].asa02,"'",
                   "   AND asn04 = ? ",
                   "   AND asn06 = '",tm.yy,"'",
                   "   AND asn20 = ",tm.yy," AND asn21 = ",tm.em              #No.FUN-C80020
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql = l_sql CLIPPED," AND asn07 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       ELSE
          LET l_sql = l_sql CLIPPED," AND asn07  = '",tm.em,"'"
       END IF        
       LET l_sql = l_sql CLIPPED," GROUP BY asn05,asn07,asn12,asn19" 
       PREPARE p000_asn08_cur FROM l_sql

       LET l_sql = "SELECT MAX(asn09),asn05,asn07,asn12,asn19 FROM asn_file ",
                   " WHERE asn00 = '",g_dept[i].asz01,"'",
                   "   AND asn01 = '",g_dept[i].asa01,"'",
                   "   AND asn02 = '",g_dept[i].asa02,"'",
                   "   AND asn04 = ? ",
                   "   AND asn06 = '",tm.yy,"'",
                   "   AND asn20 = ",tm.yy," AND asn21 = ",tm.em              #No.FUN-C80020
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql = l_sql CLIPPED," AND asn07 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       ELSE
          LET l_sql = l_sql CLIPPED," AND asn07  = '",tm.em,"'"
       END IF
       LET l_sql = l_sql CLIPPED," GROUP BY asn05,asn07,asn12,asn19"
       PREPARE p000_asn09_cur FROM l_sql

       LET l_sql = " SELECT UNIQUE asm04 FROM asm_file,asn_file ",
                   "  WHERE asm00 = asn00 AND asm01 = asn01 ",
                   "    AND asm02 = asn02 AND asm05 = asn06 ",
                   "    AND asm00 = '",g_dept[i].asz01,"' AND asm01 = '",g_dept[i].asa01,"' ",
                   "    AND asm02 = '",g_dept[i].asa02,"' AND asm05 = '",tm.yy,"'",
                   "    AND asm04 = asn04",
                   "    AND asm20 = asn20 ",                       #No.FUN-C80020
                   "    AND asm21 = asn21 ",                       #No.FUN-C80020
                   "    AND asm20 = ",tm.yy,                       #No.FUN-C80020
                   "    AND asm21 = ",tm.em                        #No.FUN-C80020
       IF l_asg04='Y' AND (l_asa07 = 'N' OR l_fag = 'N') THEN
          LET l_sql = l_sql CLIPPED," AND asm06 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'",
                                    " AND asn07 BETWEEN '",tm.bm,"' AND ","'",tm.em,"'"
       ELSE
          LET l_sql = l_sql CLIPPED," AND asm06  = '",tm.em,"' AND asm06 = asn07"
       END IF
       PREPARE p000_sel_asm04 FROM l_sql
       DECLARE p000_sel_asm04_cur CURSOR FOR p000_sel_asm04
       FOREACH p000_sel_asm04_cur INTO l_asm04
           EXECUTE p000_sel_asm INTO l_asm07,l_asm08,l_asm12,l_asm13
             USING l_asm04
           EXECUTE p000_sel_asn INTO l_asn08,l_asn09,l_asn13,l_asn14
             USING l_asm04
           IF cl_null(l_asm07) THEN LET l_asm07 = 0 END IF 
           IF cl_null(l_asm08) THEN LET l_asm08 = 0 END IF 
           IF cl_null(l_asm12) THEN LET l_asm12 = 0 END IF 
           IF cl_null(l_asm13) THEN LET l_asm13 = 0 END IF 
           IF cl_null(l_asn08) THEN LET l_asn08 = 0 END IF 
           IF cl_null(l_asn09) THEN LET l_asn09 = 0 END IF 
           IF cl_null(l_asn13) THEN LET l_asn13 = 0 END IF 
           IF cl_null(l_asn14) THEN LET l_asn14 = 0 END IF 
           IF l_asm12 = l_asn13 AND l_asm07<>l_asn08 THEN
              FOREACH p000_asn08_cur USING l_asm04 INTO l_asn05,l_asn07,l_asn12,l_asn19
                LET l_amt = l_asm07-l_asn08
                UPDATE asn_file SET asn08 = asn08+l_amt
                 WHERE asn00 = g_dept[i].asz01 AND asn01 = g_dept[i].asa01
                   AND asn02 = g_dept[i].asa02 AND asn04 = l_asm04
                   AND asn05 = l_asn05  AND asn06 = tm.yy AND asn07 = l_asn07
                   AND asn12 = l_asn12 AND asn19 = l_asn19
                   AND asn20 = tm.yy   AND asn21 = tm.em              #No.FUN-C80020
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                   CALL s_errmsg('asn01',g_dept[i].asa01,'upd_asn',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                ELSE
                   EXIT FOREACH
                END IF
              END FOREACH
           END IF 
           IF l_asm13 = l_asn14 AND l_asm08<>l_asn09 THEN
              FOREACH p000_asn09_cur USING l_asm04 INTO l_asn05,l_asn07,l_asn12,l_asn19
                LET l_amt = l_asm08-l_asn09
                UPDATE asn_file SET asn09 = asn09+l_amt
                 WHERE asn00 = g_dept[i].asz01 AND asn01 = g_dept[i].asa01
                   AND asn02 = g_dept[i].asa02 AND asn04 = l_asm04
                   AND asn05 = l_asn05  AND asn06 = tm.yy AND asn07 = l_asn07
                   AND asn12 = l_asn12 AND asn19 = l_asn19
                   AND asn20 = tm.yy   AND asn21 = tm.em              #No.FUN-C80020
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                   CALL s_errmsg('asn01',g_dept[i].asa01,'upd_asn',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                ELSE
                   EXIT FOREACH
                END IF
              END FOREACH 
           END IF 
       END FOREACH    
       #FUN-B90057--add--end
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
DEFINE l_asg04 LIKE asg_file.asg04   #FUN-B60159

  #-->delete asm_file
  #FUN-B60159--add--str--
  SELECT asg04 INTO l_asg04 FROM asg_file WHERE asg01 = g_dept[p_i].asa02
  IF l_asg04 = 'N' THEN
     DELETE FROM asm_file
      WHERE asm00 = g_dept[p_i].asz01
        AND asm01 = g_dept[p_i].asa01
        AND asm02 = g_dept[p_i].asa02
        AND asm05 = tm.yy
        AND asm06 = tm.em
        AND asm20 = tm.yy       #No.FUN-C80020
        AND asm21 = tm.em       #No.FUN-C80020
     IF SQLCA.sqlcode THEN
        LET g_showmsg=g_dept[p_i].asz01,"/",g_dept[p_i].asa01,"/",g_dept[p_i].asa02
        CALL s_errmsg('asz01,asa01,asa02',g_showmsg,'DELETE asm_file',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF     
  ELSE
  #FUN-B60159--add--end
     DELETE FROM asm_file
      #WHERE asm00 = g_dept[p_i].aaz641   #FUNB-B50001
      WHERE asm00 = g_dept[p_i].asz01
        AND asm01 = g_dept[p_i].asa01
        AND asm02 = g_dept[p_i].asa02
        AND asm05 = tm.yy
        AND asm06 BETWEEN tm.bm AND tm.em
        AND asm20 = tm.yy       #No.FUN-C80020
        AND asm21 = tm.em       #No.FUN-C80020
     IF SQLCA.sqlcode THEN
        LET g_showmsg=g_dept[p_i].asz01,"/",g_dept[p_i].asa01,"/",g_dept[p_i].asa02
        CALL s_errmsg('asz01,asa01,asa02',g_showmsg,'DELETE asm_file',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
  END IF    #FUN-B60159
  #-->delete asn_file
  DELETE FROM asn_file
   #WHERE asn00 = g_dept[p_i].aaz641   #FUN-B50001
   WHERE asn00 = g_dept[p_i].asz01
     AND asn01 = g_dept[p_i].asa01
     AND asn02 = g_dept[p_i].asa02
     AND asn06 = tm.yy
     AND asn07 BETWEEN tm.bm AND tm.em
     AND asn20 = tm.yy   AND asn21 = tm.em              #No.FUN-C80020
  IF SQLCA.sqlcode THEN 
     LET g_showmsg=g_dept[p_i].asz01,"/",g_dept[p_i].asa01,"/",g_dept[p_i].asa02
     CALL s_errmsg('asz01,asa01,asa02',g_showmsg,'DELETE asn_file',STATUS,1)
     LET g_success = 'N'
     RETURN 
  END IF 

  #-->delete asnn_file
  DELETE FROM asnn_file
   #WHERE asnn00 = g_dept[p_i].aaz641    #FUN-B50001
   WHERE asnn00 = g_dept[p_i].asz01
     AND asnn01 = g_dept[p_i].asa01
     AND asnn02 = g_dept[p_i].asa02
     AND asnn09 = tm.yy
     AND asnn10 BETWEEN tm.bm AND tm.em
     AND asnn20 = tm.yy AND asnn21 = tm.em     #No.FUN-C80020
  IF SQLCA.sqlcode THEN 
     LET g_showmsg=g_dept[p_i].asz01,"/",g_dept[p_i].asa01,"/",g_dept[p_i].asa02
     CALL s_errmsg('asz01,asa01,asa02',g_showmsg,'DELETE asnn_file',STATUS,1)
     LET g_success = 'N'
     RETURN 
  END IF 
  #FUN-B90057--add--str--
  DELETE FROM ask_file
         WHERE ask00=g_asz.asz01
           AND ask01 IN (SELECT asj01 FROM asj_file
                          WHERE asj00=g_asz.asz01 AND asj05=g_dept[p_i].asa01
                            AND asj06=g_dept[p_i].asa02 AND asj07=g_dept[p_i].asa03
                            AND asj03=tm.yy AND asj04 = tm.em  
                            AND asjconf <> 'X'  #CHI-C80041
                            AND asj08='1' AND asj081 IN('8','9') )
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","ask_file",g_asz.asz01,"",SQLCA.sqlcode,"","del ask_file",1)  
      LET g_success = 'N'
      RETURN
   END IF
 
   #-->delete asj_file
   #-->delete asj_file
   DELETE FROM asj_file
         WHERE asj00=g_asz.asz01
           AND asj05=g_dept[p_i].asa01 AND asj06=g_dept[p_i].asa02 AND asj07=g_dept[p_i].asa03
           AND asj03=tm.yy AND asj04 = tm.em   
           AND asjconf <> 'X'  #CHI-C80041
           AND asj08='1' AND asj081 IN('8','9')
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","asj_file",g_dept[p_i].asa03,"",SQLCA.sqlcode,"","del asj_file",1)  
      LET g_success = 'N'
      RETURN
   END IF
  #FUN-B90057--add--end
END FUNCTION

#FUN-B90019--add--str--
#--依匯率計算下層公司功能幣---------
FUNCTION p000_fun_amt(p_aag04,p_dr,p_cr,p_ash11,p_asg06,p_asg07,p_yy,p_mm,p_asa05)   
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_ash11    LIKE ash_file.ash11
DEFINE p_asg06    LIKE asg_file.asg06
DEFINE p_asg07    LIKE asg_file.asg07
DEFINE p_yy       LIKE aah_file.aah02
DEFINE p_mm       LIKE aah_file.aah03
DEFINE l_bs_yy    LIKE aah_file.aah02
DEFINE l_bs_mm    LIKE aah_file.aah03
DEFINE l_fun_dr   LIKE aah_file.aah04
DEFINE l_fun_cr   LIKE aah_file.aah05
DEFINE p_dr       LIKE aah_file.aah04
DEFINE p_cr       LIKE aah_file.aah05
DEFINE l_cut      LIKE type_file.num5   
DEFINE p_asa05    LIKE asa_file.asa05    

    IF p_aag04='1' THEN #1.BS 2.IS
         LET l_bs_yy=p_yy
         LET l_bs_mm=tm.em
    ELSE
         LET l_bs_yy=p_yy
         LET l_bs_mm=p_mm
    END IF

    LET l_fun_dr=0 
    LET l_fun_cr=0 
    #當子公司記帳幣別與子公司功能幣別不同時才需要抓匯率來計算
    LET l_rate = 1
    IF p_asg06 != p_asg07 THEN 
        #功能幣別匯率
        IF p_ash11 <> '3' THEN    ##不採平均匯率時直接取當期匯率
           CALL p000_getrate(p_ash11,l_bs_yy,l_bs_mm,
                             p_asg06,p_asg07)
           RETURNING l_rate
           IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
        ELSE
           IF p_asa05 != '3' THEN
               CALL p000_getrate1(p_aag04,p_asg06,p_asg07)
               RETURNING l_rate
           ELSE
               CALL p000_getrate3(p_ash11,l_bs_yy,l_bs_mm,
                                 p_asg06,p_asg07)
               RETURNING l_rate
               IF cl_null(l_rate) THEN LET l_rate = 1 END IF 
           END IF
        END IF
    END IF

    #->幣別轉換及取位
    LET l_fun_dr=p_dr * l_rate     #下層公司功能幣別借方金額
    LET l_fun_cr=p_cr * l_rate     #下層公司功能幣別貸方金額
   
    SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_asg07                                                                               
    IF cl_null(l_cut) THEN LET l_cut=0 END IF                                                                                                   
                                                                                                                                         
    LET l_fun_dr=cl_digcut(l_fun_dr,l_cut)                                                                                                
    LET l_fun_cr=cl_digcut(l_fun_cr,l_cut)                                                                                                
    IF cl_null(l_fun_dr) THEN LET l_fun_dr=0 END IF                                                                                   
    IF cl_null(l_fun_cr) THEN LET l_fun_cr=0 END IF                                                                                   
    RETURN l_fun_dr,l_fun_cr
END FUNCTION

#--依agli0111設定股東權益金額作為下層功能/上層記帳金額--
FUNCTION p000_asf(p_i,p_aag01,p_ash06,p_date)  
DEFINE p_aag01  LIKE aag_file.aag01
DEFINE p_ash06  LIKE ash_file.ash06
DEFINE p_date   LIKE type_file.dat 
DEFINE l_aag06  LIKE aag_file.aag06
DEFINE l_asf13  LIKE asf_file.asf13
DEFINE l_chg_dr LIKE aah_file.aah04             #借方金額
DEFINE l_chg_cr LIKE aah_file.aah05             #貸方金額
DEFINE l_cut    LIKE type_file.num5             #幣別取位(功能幣別)                  
DEFINE p_i      LIKE type_file.num5
DEFINE l_asf16  LIKE asf_file.asf16             #
DEFINE l_fun_dr      LIKE aah_file.aah04        #功能幣借方 
DEFINE l_fun_cr      LIKE aah_file.aah04        #功能幣貸方 

    DECLARE p000_asf_cs1 CURSOR FOR p000_asf_p
    OPEN p000_asf_cs1 
    USING g_dept[p_i].asa01,g_dept[p_i].asa02,
          p_ash06,p_date    
    FETCH p000_asf_cs1                      
    INTO l_aag06,l_asf16,l_asf13                

    IF l_asf13 > 0 THEN 
        IF l_aag06='1' THEN                     #正常餘額為1.借餘
             LET l_fun_dr=l_asf16          #
             LET l_chg_dr=l_asf13          #借
             LET l_fun_cr=0                #
             LET l_chg_cr=0                #貸
        ELSE                                    #正常餘額為2.貸餘
            LET l_fun_dr=0               
            LET l_chg_dr=0                 
            LET l_chg_cr=l_asf13          
            LET l_fun_cr=l_asf16         
        END IF
    ELSE
        IF l_aag06='1' THEN                     #正常餘額為1.借餘
            LET l_fun_dr=0                     
            LET l_chg_dr=0
            LET l_chg_cr=(l_asf13 *-1)
            LET l_fun_cr=(l_asf16 *-1)          
        ELSE                                    #正常餘額為2.貸餘
            LET l_fun_dr=(l_asf16*-1)           
            LET l_chg_dr=(l_asf13*-1)
            LET l_chg_cr=0
            LET l_fun_cr=0                    
        END IF
    END IF

    LET l_rate = 1
    LET l_rate1 = 1
    SELECT asf15,asf12
    INTO l_rate,l_rate1  
     FROM asf_file
    WHERE asf01= g_dept[p_i].asa01
      AND asf02= g_dept[p_i].asa02
      AND asf07= p_aag01
      AND asf03= p_ash06
      AND asf06<=p_date
    IF cl_null(l_rate) THEN LET l_rate = 1 END IF  
    IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF  
    RETURN l_fun_dr,l_fun_cr,l_chg_dr,l_chg_cr  
END FUNCTION

#計算為來源功能幣別(採平均匯率者)
FUNCTION p000_fun_avg(p_ash11,p_aah01,p_asg06,p_asg07,p_yy,p_mm,p_i,p_aah04,p_aah05)   
DEFINE l_sql        STRING
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_asg06      LIKE asg_file.asg06
DEFINE p_asg07      LIKE asg_file.asg07
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE p_aah04      LIKE aah_file.aah04
DEFINE p_aah05      LIKE aah_file.aah05  
DEFINE p_yy         LIKE aah_file.aah02   
DEFINE p_mm         LIKE aah_file.aah03   
DEFINE p_ash11      LIKE ash_file.ash11   
DEFINE l_max_month  LIKE type_file.num5   
DEFINE l_asg04      LIKE asg_file.asg04   
DEFINE l_asg03      LIKE asg_file.asg03
DEFINE p_j          LIKE type_file.chr1
DEFINE l_cut        LIKE type_file.num5
  SELECT asg04,asg03 INTO l_asg03,l_asg04
    FROM asg_file WHERE asg01 = g_dept[p_i].asa02
    
  LET l_dr_sum = 0
  LET l_cr_sum = 0

  #--先處理依編製期別取每期金額 0~迄期別
  #功能幣金額：(記帳幣*再衡量匯率)
  #合併幣金額：(記帳幣金額*再衡量*換算匯率)

       IF p_asg06 != p_asg07 THEN 
           #功能幣別匯率
           CALL p000_getrate(p_ash11,p_yy,p_mm,p_asg06,p_asg07)
           RETURNING l_rate
       END IF
       LET l_dr_sum = p_aah04 * l_rate
       LET l_cr_sum = p_aah05 * l_rate
       SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_asg07                                                                               
       IF cl_null(l_cut) THEN LET l_cut=0 END IF
       LET l_dr_sum=cl_digcut(l_dr_sum,l_cut)                                                                                                
       LET l_cr_sum=cl_digcut(l_cr_sum,l_cut)                                                                                                
       IF cl_null(l_dr_sum) THEN LET l_dr_sum=0 END IF                                                                                   
       IF cl_null(l_cr_sum) THEN LET l_cr_sum=0 END IF
  RETURN l_dr_sum,l_cr_sum     
END FUNCTION

#計算asr_file為來源的合併幣別(採平均匯率者)
FUNCTION p000_avg(p_ash11,p_ash12,p_aah01,p_asg06,p_asg07,p_yy,p_mm,p_i,p_aah04,p_aah05)
DEFINE l_sql        STRING
DEFINE p_aah01      LIKE aah_file.aah01
DEFINE p_asg07      LIKE asg_file.asg07
DEFINE p_asg06      LIKE asg_file.asg06
DEFINE l_dr_sum     LIKE aah_file.aah04
DEFINE l_cr_sum     LIKE aah_file.aah05
DEFINE p_i          LIKE type_file.num5
DEFINE p_yy         LIKE type_file.num5 
DEFINE p_mm         LIKE type_file.num5
DEFINE p_ash12      LIKE ash_file.ash12 
DEFINE p_ash11      LIKE ash_file.ash11 
DEFINE p_aah04      LIKE aah_file.aah04
DEFINE p_aah05      LIKE aah_file.aah05

  IF p_asg06 != p_asg07 THEN 
      #功能幣別匯率
      CALL p000_getrate(p_ash11,p_yy,p_mm,p_asg06,p_asg07)
      RETURNING l_rate
  END IF
  IF p_asg07 != x_aaa03 THEN 
      #合併幣別匯率
      CALL p000_getrate(p_ash12,p_yy,p_mm,p_asg07,x_aaa03)
      RETURNING l_rate1
  END IF
  IF cl_null(l_rate) THEN LET l_rate = 1 END IF
  IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
  LET l_dr_sum = p_aah04* l_rate * l_rate1
  LET l_cr_sum = p_aah05* l_rate * l_rate1

  RETURN l_dr_sum,l_cr_sum

END FUNCTION

FUNCTION p000_getrate1(p_aag04,p_asg06,p_asg07)
DEFINE p_aah01       LIKE aah_file.aah01
DEFINE p_asg06       LIKE asg_file.asg07
DEFINE p_asg07       LIKE asg_file.asg07
DEFINE p_aag04       LIKE aag_file.aag04
DEFINE l_bm          LIKE type_file.num5
DEFINE l_month_count LIKE type_file.num5
DEFINE l_sum_ase07   LIKE ase_file.ase07
DEFINE l_rate        LIKE ase_file.ase05
   IF p_aag04 = '1' THEN
      LET l_bm = 0
   ELSE
      LET l_bm = 1
   END IF
   SELECT SUM(ase07) INTO l_sum_ase07
     FROM ase_file
    WHERE ase01 = tm.yy
      AND ase03 = p_asg06
      AND ase04 = p_asg07
      AND ase02 BETWEEN l_bm AND tm.em
      AND (ase07 IS NOT NULL AND ase07<>0)
   SELECT COUNT(ase07) INTO l_month_count
     FROM ase_file
    WHERE ase01 = tm.yy
      AND ase03 = p_asg06
      AND ase04 = p_asg07
      AND ase02 BETWEEN l_bm AND tm.em
      AND (ase07 IS NOT NULL AND ase07<>0)
     
   LET l_rate = l_sum_ase07/l_month_count
   IF cl_null(l_rate) THEN LET l_rate = 1 END IF
   RETURN l_rate
END FUNCTION

FUNCTION p000_getrate(l_value,l_ase01,l_ase02,l_ase03,l_ase04)
DEFINE l_value LIKE ash_file.ash11,
       l_ase01 LIKE ase_file.ase01,
       l_ase02 LIKE ase_file.ase02,
       l_ase03 LIKE ase_file.ase03,
       l_ase04 LIKE ase_file.ase04,
       l_ase05 LIKE ase_file.ase05,    
       l_ase06 LIKE ase_file.ase06,    
       l_ase07 LIKE ase_file.ase07,    
       l_rate  LIKE ase_file.ase05     


   SELECT ase05,ase06,ase07 
     INTO l_ase05,l_ase06,l_ase07 
     FROM ase_file
    WHERE ase01=l_ase01
      AND ase02=(SELECT max(ase02) FROM ase_file
                  WHERE ase01 = l_ase01
                    AND ase02 <=l_ase02
                    AND ase03 = l_ase03
                    AND ase04 = l_ase04)
      AND ase03=l_ase03 
      AND ase04=l_ase04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_ase05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_ase06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_ase07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION

FUNCTION p000_getrate3(l_value,l_ase01,l_ase02,l_ase03,l_ase04)
DEFINE l_value LIKE ash_file.ash11,
       l_ase01 LIKE ase_file.ase01,
       l_ase02 LIKE ase_file.ase02,
       l_ase03 LIKE ase_file.ase03,
       l_ase04 LIKE ase_file.ase04,
       l_ase05 LIKE ase_file.ase05,    
       l_ase06 LIKE ase_file.ase06,   
       l_ase07 LIKE ase_file.ase07,  
       l_rate  LIKE ase_file.ase05  

   SELECT ase05,ase06,ase07 
     INTO l_ase05,l_ase06,l_ase07 
     FROM ase_file
    WHERE ase01=l_ase01
      AND ase02=l_ase02
      AND ase03=l_ase03 
      AND ase04=l_ase04

   CASE
      WHEN l_value='1'   #1.現時匯率
         LET l_rate=l_ase05
      WHEN l_value='2'   #2.歷史匯率
         LET l_rate=l_ase06
      WHEN l_value='3'   #3.平均匯率
         LET l_rate=l_ase07
      OTHERWISE      
         LET l_rate=1
   END CASE

   IF l_rate = 0 THEN LET l_rate = 1 END IF

   RETURN l_rate
END FUNCTION

#--依匯率計算上層記帳幣---------
FUNCTION p000_acc_amt(p_aag04,p_dr,p_cr,p_ash12,p_asg07,p_aaa03,p_yy,p_mm,p_asa05) 
DEFINE p_aag04    LIKE aag_file.aag04
DEFINE p_ash12    LIKE ash_file.ash12
DEFINE p_aaa03    LIKE aaa_file.aaa03
DEFINE p_asg07    LIKE asg_file.asg07
DEFINE p_yy       LIKE aah_file.aah02
DEFINE p_mm       LIKE aah_file.aah03
DEFINE l_bs_yy    LIKE aah_file.aah02
DEFINE l_bs_mm    LIKE aah_file.aah03
DEFINE l_acc_dr   LIKE aah_file.aah04
DEFINE l_acc_cr   LIKE aah_file.aah05
DEFINE p_dr       LIKE aah_file.aah04
DEFINE p_cr       LIKE aah_file.aah05
DEFINE l_cut1     LIKE type_file.num5             #幣別取位(記帳幣別)
DEFINE p_asa05    LIKE asa_file.asa05    

    IF p_aag04='1' THEN #1.BS 2.IS
         LET l_bs_yy=p_yy
         LET l_bs_mm=tm.em
    ELSE
         LET l_bs_yy=p_yy
         LET l_bs_mm=p_mm
    END IF
    LET l_acc_dr=0 
    LET l_acc_cr=0 

    #當子公司功能幣別與母公司記帳幣別不同時才需要抓匯率來計算
    LET l_rate1 = 1
    IF p_asg07 != p_aaa03 THEN
        #記帳幣別匯率
        IF p_ash12 <> '3' THEN   
           CALL p000_getrate(p_ash12,l_bs_yy,l_bs_mm,
                             p_asg07,p_aaa03)
           RETURNING l_rate1
           IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF
        ELSE
           IF p_asa05 != '3' THEN  
               CALL p000_getrate1(p_aag04,p_asg07,p_aaa03)
               RETURNING l_rate1
           ELSE
               CALL p000_getrate3(p_ash12,l_bs_yy,l_bs_mm,
                                 p_asg07,p_aaa03)
               RETURNING l_rate1
               IF cl_null(l_rate1) THEN LET l_rate1 = 1 END IF 
           END IF
        END IF
    END IF

    #->幣別轉換及取位
    LET l_acc_dr=p_dr * l_rate1  #上層公司記帳幣別借方金額
    LET l_acc_cr=p_cr * l_rate1  #上層公司記帳幣別貸方金額

    SELECT azi04 INTO l_cut1 FROM azi_file WHERE azi01=x_aaa03                                                                                  
    IF cl_null(l_cut1) THEN LET l_cut1=0 END IF                                                                                                 
                                                                                                                                         
    LET l_acc_dr=cl_digcut(l_acc_dr,l_cut1)                                                                                           
    LET l_acc_cr=cl_digcut(l_acc_cr,l_cut1) 
    IF cl_null(l_acc_dr) THEN LET l_acc_dr=0 END IF                                                                                   
    IF cl_null(l_acc_cr) THEN LET l_acc_cr=0 END IF                                                                                   
    RETURN l_acc_dr,l_acc_cr

END FUNCTION
#FUN-B90019--add--end

#FUN-B90057--add--str--
FUNCTION p000_aac01(p_t1)
   DEFINE l_aacacti   LIKE aac_file.aacacti
   DEFINE l_aac11     LIKE aac_file.aac11
   DEFINE p_t1        LIKE aac_file.aac01

   LET g_errno = ' '
   SELECT aacacti INTO l_aacacti FROM aac_file
    WHERE aac01 = p_t1

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-035'
         WHEN l_aacacti = 'N'      LET g_errno = 'aic-061'
         WHEN l_aac11<>'A'         LET g_errno = 'agl-609'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION


FUNCTION p000_ins_asj(p_amt,p_asa01,p_asa02,p_dr,p_cr,p_asj081) ##p_asj081 8:資產科目價差 9:損益科目價差
DEFINE l_asj     RECORD LIKE asj_file.*
DEFINE p_amt     LIKE aah_file.aah04
DEFINE li_result LIKE type_file.num5
DEFINE p_asa01   LIKE asa_file.asa01
DEFINE p_asa02   LIKE asa_file.asa02
DEFINE p_dr      LIKE aag_file.aag01
DEFINE p_cr      LIKE aag_file.aag01
DEFINE p_asj081  LIKE asj_file.asj081

   IF p_amt = 0 THEN RETURN END IF 
   INITIALIZE l_asj.* TO NULL
   LET l_asj.asj00 = g_asz.asz01
  #CALL s_auto_assign_no("GGL",tm.aac01,g_today,"","asj_file","asj01",g_plant,2,l_asj.asj00)  #carrier 20111024
   CALL s_auto_assign_no("AGL",tm.aac01,g_today,"","asj_file","asj01",g_plant,2,l_asj.asj00)  #carrier 20111024
               RETURNING li_result,l_asj.asj01
   IF (NOT li_result) THEN
      CALL s_errmsg('asj_file','asj01',l_asj.asj01,'abm-621',1)
      LET g_success = 'N'
   END IF
   LET l_asj.asj02 = g_today
   LET l_asj.asj03 = tm.yy
   LET l_asj.asj04 = tm.em
   LET l_asj.asj05 = p_asa01
   LET l_asj.asj06 = p_asa02
   SELECT asg05 INTO l_asj.asj07 FROM asg_file
    WHERE asg01 = l_asj.asj06
   LET l_asj.asj08  = '1'  #调整
   LET l_asj.asj081 = p_asj081  
   LET l_asj.asj09 = 'Y'
   LET l_asj.asj10  = ' '
   #No.TQC-C90057  --Begin
   IF cl_null(p_amt) THEN LET p_amt = 0 END IF
   #No.TQC-C90057  --End  
   LET l_asj.asj11 = p_amt
   LET l_asj.asj12 = p_amt 
   LET l_asj.asj13 = ' '
   LET l_asj.asj14 = ' '
   LET l_asj.asj15 = ' '
   LET l_asj.asj16 = ' '
   LET l_asj.asj17 = ' '
   LET l_asj.asj18 = ' '
   LET l_asj.asj19 = ' '
   LET l_asj.asj20 = ' '
   LET l_asj.asjconf = 'Y'
   LET l_asj.asjuser = g_user
   LET l_asj.asjgrup = g_grup
   LET l_asj.asjmodu =  g_user
   LET l_asj.asjdate = g_today
   LET l_asj.asj21 = '00'   #版本
   LET l_asj.asjoriu =  g_grup
   LET l_asj.asjorig =  g_grup
   LET l_asj.asjlegal= g_legal   #所属法人
   LET l_asj.asjlegal = g_legal
   INSERT INTO asj_file VALUES(l_asj.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('asj_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CALL p000_ins_ask(l_asj.asj01,p_amt,p_dr,p_cr)
END FUNCTION

FUNCTION p000_ins_ask(p_asj01,p_amt,p_dr,p_cr)
DEFINE l_ask RECORD LIKE ask_file.*
DEFINE p_asj01 LIKE asj_file.asj01
DEFINE p_amt   LIKE aah_file.aah04
DEFINE p_dr    LIKE aag_file.aag01
DEFINE p_cr    LIKE aag_file.aag01

   INITIALIZE l_ask.* TO NULL
   LET l_ask.ask00 = g_asz.asz01
   LET l_ask.ask01 = p_asj01
   LET l_ask.ask02 = 1
   LET l_ask.ask03 = p_dr
   LET l_ask.ask06 = '1'
   LET l_ask.ask07 = p_amt
   LET l_ask.asklegal = g_legal
   INSERT INTO ask_file VALUES(l_ask.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ask_file','insert',l_ask.ask01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   LET l_ask.ask02 = 2
   #No.MOD-CB0173  --Begin
   LET l_ask.ask06 = '2'
   #No.MOD-CB0173  --End   
   LET l_ask.ask03 = p_cr
   INSERT INTO ask_file VALUES(l_ask.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ask_file','insert',l_ask.ask01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION
#FUN-B90057--add--end
