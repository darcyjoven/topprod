# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: gglp206.4gl
# Descriptions...: 資料匯入合併區作業(整批資料處理作業)_產生調整分錄
# Date & Author..: #FUN-B50001 11/05/09 By zhangweib
# Modify.........: No.FUN-B60134 11/06/27 By mpp  给g_ask.ask05赋值
# Modify.........: No.TQC-B70069 11/07/08 By zhangweib 差生調整分錄前,先刪除原資料
# Modify.........: NO.FUN-B70065 11/08/10 BY belle 追單,少數股權設定抓「累積換算調整數」做金額計算，但無法將換匯產生的累換數納入。
# Modify.........: No.FUN-B80135 11/08/22 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No.FUN-B80195 11/08/31 By lutingting差額科目給來源公司對應的關係人編號
# Modify.........: No.FUN-B90010 11/09/01 By zhangweib 程序改善,當自動生成期別時將期別顯示到畫面上
# Modify.........: No.FUN-B90057 11/09/07 By lutingting 拿掉換匯差額處理
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: NO.TQC-C40010 12/04/05 By lujh 把必要字段controlz換成controlr
# Modify.........: NO.FUN-C80056 12/08/22 By xuxz 抵銷金額計算方式修改
# Modify.........: No.TQC-C90057 12/09/11 By Carrier asj09/asj11/asj12空时赋值
# Modify.........: No.CHI-C80041 12/12/25 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm         RECORD       #FUN-BB0036 
                  yy        LIKE type_file.num5,   #匯入會計年度
                  bm        LIKE type_file.num5,   #起始期間
                  em        LIKE type_file.num5,   #截止期間
                  asa01     LIKE asa_file.asa01,   #族群代號
                  asa02     LIKE asa_file.asa02,   #上層公司編號
                  asa03     LIKE asa_file.asa03,   #帳別
                  gl        LIKE aac_file.aac01,   #調整單別
                  ver       LIKE asr_file.asr17,   #版本
                  hisyy     LIKE asr_file.asr06,   #歷史匯率年度
                  hismm     LIKE asr_file.asr07,    #歷史匯率期別
                  asa06     LIKE asa_file.asa06, 
                  q1        LIKE type_file.chr1,
                  h1        LIKE type_file.chr1
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
       g_ass      RECORD LIKE ass_file.*,
       g_asr      RECORD LIKE asr_file.*,
       g_rate     LIKE type_file.num20_6,
       g_aac      RECORD LIKE aac_file.*,
       g_asj      RECORD LIKE asj_file.*,
       g_ask      RECORD LIKE ask_file.*,
       g_i        LIKE type_file.num5,
       g_amt      LIKE asr_file.asr08,
       g_asr04    LIKE asr_file.asr04,
       g_ass10_d  LIKE ass_file.ass10,
       g_ass10_c  LIKE ass_file.ass10,
       g_asq      RECORD LIKE asq_file.*,
       g_asu03    LIKE asu_file.asu03,
       g_ast03    LIKE ast_file.ast03,
       g_asv03    LIKE asv_file.asv03,
       g_affil    LIKE ask_file.ask05,
       g_dc       LIKE ask_file.ask06,
       g_flag_r   LIKE type_file.chr1,
       g_yy       LIKE type_file.num5,
       g_mm       LIKE type_file.num5,
       g_em       LIKE type_file.chr10
DEFINE g_asz01        LIKE asz_file.asz01
DEFINE g_asz05        LIKE asz_file.asz05
DEFINE g_dbs_asg03     LIKE type_file.chr21
DEFINE g_asg03         LIKE asg_file.asg03
DEFINE g_sql           STRING
DEFINE g_asz01_asb04  LIKE asz_file.asz01
DEFINE g_dbs_asb04     LIKE type_file.chr21
DEFINE g_newno         LIKE asj_file.asj01
DEFINE g_asa        DYNAMIC ARRAY OF RECORD
                    asa01      LIKE asa_file.asa01,  #族群代號
                    asa02      LIKE asa_file.asa02,  #上層公司
                    asa03      LIKE asa_file.asa03   #帳別
                    END RECORD 
DEFINE g_ass09_o    LIKE ass_file.ass09,             #期別
       g_ass09_o1   LIKE ass_file.ass09,             #期別  
       g_ass07_o    LIKE ass_file.ass07,             #異動碼值
       g_ass07_o1   LIKE ass_file.ass07              #異動碼值 
DEFINE g_asr07_o    LIKE asr_file.asr07,             #期別
       g_asr07_o1   LIKE asr_file.asr07              #期別  
DEFINE g_ass07      LIKE ass_file.ass07
DEFINE g_ask07_total  LIKE ask_file.ask07
DEFINE g_date_e     LIKE type_file.dat
DEFINE g_cnt_asq09  LIKE type_file.num5
DEFINE g_cnt_asq10  LIKE type_file.num5
DEFINE g_dbs_asq09  LIKE azp_file.azp03
DEFINE g_dbs_asq10  LIKE azp_file.azp03
DEFINE g_asz01_asq09 LIKE asz_file.asz01
DEFINE g_asz01_asq10 LIKE asz_file.asz01
DEFINE g_asz06       LIKE asz_file.asz06
DEFINE g_dept        DYNAMIC ARRAY OF RECORD        
                     asa01      LIKE asa_file.asa01,  #族群代號
                     asa02      LIKE asa_file.asa02,  #上層公司
                     asa03      LIKE asa_file.asa03,  #帳別
                     asb04      LIKE asb_file.asb04,  #下層公司
                     asb05      LIKE asb_file.asb05   #帳別  
                     END RECORD
DEFINE l_rate        LIKE ase_file.ase05             #功能幣別匯率    
DEFINE l_rate1       LIKE ase_file.ase05             #記帳幣別匯率   
DEFINE g_azw02      LIKE azw_file.azw02
DEFINE g_asq09_asg05 LIKE asg_file.asg05
DEFINE g_asq10_asg05 LIKE asg_file.asg05
DEFINE g_asg08       LIKE asg_file.asg08
DEFINE g_asg08_asq10 LIKE asg_file.asg08
DEFINE g_low_asq09        LIKE type_file.num5
DEFINE g_up_asq09         LIKE type_file.num5
DEFINE g_low_asq10        LIKE type_file.num5
DEFINE g_up_asq10         LIKE type_file.num5
DEFINE g_asa02_asq09      LIKE asa_file.asa02
DEFINE g_asa02_asq10      LIKE asa_file.asa02
DEFINE g_asa09_asq09      LIKE asa_file.asa09
DEFINE g_asa09_asq10      LIKE asa_file.asa09
DEFINE g_asg06_asq09      LIKE asg_file.asg06
DEFINE g_asg06_asq10      LIKE asg_file.asg06
DEFINE g_asm              RECORD 
                          asm04  LIKE asm_file.asm04,
                          asm05  LIKE asm_file.asm05,
                          asm07  LIKE asm_file.asm07,
                          asm08  LIKE asm_file.asm08,
                          asm09  LIKE asm_file.asm09,
                          asm10  LIKE asm_file.asm10,
                          asm11  LIKE asm_file.asm11
                          END RECORD
DEFINE g_asn              RECORD 
                          asn04  LIKE asn_file.asn04,
                          asn05  LIKE asn_file.asn05,
                          asn06  LIKE asn_file.asn06,
                          asn08  LIKE asn_file.asn08,
                          asn09  LIKE asn_file.asn09,
                          asn10  LIKE asn_file.asn10,
                          asn11  LIKE asn_file.asn11
                          END RECORD
DEFINE g_asnn              RECORD 
                          asnn04  LIKE asnn_file.asnn04,
                          asnn05  LIKE asnn_file.asnn05,
                          asnn06  LIKE asnn_file.asnn06,
                          asnn07  LIKE asnn_file.asnn07,
                          asnn08  LIKE asnn_file.asnn08,
                          asnn09  LIKE asnn_file.asnn09,
                          asnn11  LIKE asnn_file.asnn11,
                          asnn12  LIKE asnn_file.asnn12,
                          asnn13  LIKE asnn_file.asnn13,
                          asnn14  LIKE asnn_file.asnn14,
                          asnn15  LIKE asnn_file.asnn15
                          END RECORD
DEFINE g_ask1             RECORD 
                          ask06  LIKE ask_file.ask06,
                          ask07  LIKE ask_file.ask07
                          END RECORD
DEFINE g_asa06            LIKE asa_file.asa06
DEFINE g_asa05            LIKE asa_file.asa05
DEFINE g_type             LIKE type_file.chr1  
DEFINE g_flag             LIKE type_file.chr1
DEFINE g_aaz87            LIKE aaz_file.aaz87   #FUN-B70065
#FUN-C80056 --add--str
DEFINE g_asr081          LIKE asr_file.asr08
DEFINE g_dc1             LIKE ask_file.ask06
DEFINE g_asq18           LIKE asq_file.asq18

#FUN-C80056--add--end
#FUN-B80135--add--str--
DEFINE g_year           LIKE  type_file.chr4
DEFINE g_month          LIKE  type_file.chr2
#FUN-B80135--add--end--


MAIN
DEFINE  l_asg03     LIKE asg_file.asg03

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_bookno = ARG_VAL(1)
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file    #總帳預設帳別
   END IF
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.asa01 = ARG_VAL(1)
   LET tm.asa02 = ARG_VAL(2)
   LET tm.asa03 = ARG_VAL(3)
   LET tm.yy    = ARG_VAL(4)
   LET tm.asa06 = ARG_VAL(5)
   LET tm.em    = ARG_VAL(6)
   LET tm.q1    = ARG_VAL(7)
   LET tm.h1    = ARG_VAL(8)
   LET tm.gl    = ARG_VAL(9)
   LET tm.ver   = ARG_VAL(10)
   LET tm.hisyy = ARG_VAL(11)
   LET tm.hismm = ARG_VAL(12)
   LET g_bgjob  = ARG_VAL(13)
   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(tm.ver) THEN LET tm.ver = '00' END IF
  
   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0'
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add—end--
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00='0'  #FUN-B80135
  WHILE TRUE
     LET g_change_lang = FALSE
     IF g_bgjob = 'N' THEN
        CALL gglp206_tm(0,0)
        IF cl_sure(21,21) THEN
           SELECT asg06 INTO x_aaa03 FROM asg_file where asg01 = tm.asa02
           SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01 = tm.asa02
           SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_asg03
           CALL cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL p007()
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
              CLOSE WINDOW gglp206_w
              EXIT WHILE
           END IF
        END IF
     ELSE
        SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07
          FROM aaa_file 
        #WHERE aaa01 = g_bookno   #FUN-B80135
         WHERE aaa01 = g_asz01    #FUN-B80135
        SELECT asg06 INTO x_aaa03 FROM asg_file where asg01 = tm.asa02
        SELECT asg03 INTO l_asg03 FROM asg_file WHERE asg01 = tm.asa02
        SELECT azw02 INTO g_azw02 FROM azw_file WHERE azw01 = l_asg03
       
        LET g_success = 'Y'
        BEGIN WORK
        CALL p007()
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

FUNCTION gglp206_tm(p_row,p_col)
   DEFINE  p_row,p_col    LIKE type_file.num5,
           l_cnt          LIKE type_file.num5,
           l_asa03        LIKE asa_file.asa03
   DEFINE  lc_cmd         LIKE type_file.chr1000    
   DEFINE  l_asa09        LIKE asa_file.asa09
   DEFINE  l_aznn01       LIKE aznn_file.aznn01
   DEFINE  l_asg03        LIKE asg_file.asg03

   IF s_shut(0) THEN RETURN END IF
#  CALL s_dsmark(g_bookno)    #FUN-BB80135

   LET p_row = 4 LET p_col = 30

   OPEN WINDOW gglp206 AT p_row,p_col WITH FORM "ggl/42f/gglp206" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()

# Prog. Version..: '5.30.06-13.03.12(0,0,g_bookno)  #FUN-B80135
   CALL cl_opmsg('q')
   WHILE TRUE 
      CLEAR FORM 
      INITIALIZE tm.* TO NULL
      SELECT aaa04,aaa05,aaa07 INTO g_aaa04,g_aaa05,g_aaa07
        FROM aaa_file 
#      WHERE aaa01 = g_bookno   #FUN-B80135
       WHERE aaa01 = g_asz01   #FUN-B80135
      SELECT asg06 INTO x_aaa03 FROM asg_file where asg01 = tm.asa02

      LET tm.yy = g_aaa04  
      LET tm.bm = 0
      DISPLAY tm.bm TO FORMONLY.bm
      LET tm.em = g_aaa05
      LET tm.ver = '00'
      LET tm.hisyy = g_aaa04
      LET tm.hismm = g_aaa05
      LET g_bgjob = 'N'

      INPUT BY NAME tm.asa01,tm.asa02,tm.yy,tm.asa06,tm.em,tm.q1,tm.h1,tm.gl,g_bgjob,  
                    tm.ver,tm.hisyy,tm.hismm
            WITHOUT DEFAULTS 

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
         
         #No.FUN-B80135--add--str--
         AFTER FIELD   yy       #会计年度
            IF NOT cl_null(tm.yy) THEN
               IF tm.yy < 0 THEN
                  CALL cl_err(tm.yy,'apj-035',0)
                  NEXT FIELD yy
               END IF
               IF tm.yy < g_year THEN
                  CALL cl_err(tm.yy,'atp-164',0)
                  NEXT FIELD yy
               ELSE
                   IF tm.yy=g_year AND tm.em <= g_month THEN
                     CALL cl_err(tm.em,'atp-164',0)
                     NEXT FIELD  em
                   END IF
               END IF
            END IF 
         #No.FUN-B80135--add—end--

         AFTER FIELD em    
            IF NOT cl_null(tm.em) THEN
               IF tm.bm >tm.em  THEN 
                  CALL cl_err('','9011',0) NEXT FIELD em 
               END IF
               LET g_date_e = s_getlastday(MDY(tm.em ,'1',tm.yy))
           #No.FUN-B80135--add--str--
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_asi.asi06
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em< 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
            
            IF NOT  cl_null(tm.yy) AND (tm.yy=g_year 
               AND tm.em<=g_month) THEN
               CALL cl_err(tm.em,'atp-164',0)
               NEXT FIELD em
            END IF 
           #No.FUN-B80135--add—end--

            END IF

         AFTER FIELD q1
         IF cl_null(tm.q1) AND  g_asa06 = '2' THEN 
            NEXT FIELD q1 
         END IF
         IF cl_null(tm.q1) OR tm.q1 NOT MATCHES '[1234]' THEN
            NEXT FIELD q1
         END IF
 
         AFTER FIELD h1 #半年報
            IF (cl_null(tm.h1) OR tm.h1>2 OR tm.h1<0) AND tm.asa06='4' THEN
               NEXT FIELD h1
            END IF
           
         AFTER FIELD asa01
            IF NOT cl_null(tm.asa01) THEN
               SELECT DISTINCT asa01 FROM asa_file WHERE asa01=tm.asa01
               IF STATUS THEN
                  CALL cl_err3("sel","asa_file",tm.asa01,tm.asa02,"agl-11","","",0)
                  NEXT FIELD asa01 
               END IF
            END IF

         AFTER FIELD asa02  #公司編號
            IF NOT cl_null(tm.asa02) THEN
               SELECT count(*) INTO l_cnt FROM asa_file 
                WHERE asa01=tm.asa01 AND asa02=tm.asa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel asa:','agl-118',0) NEXT FIELD asa02 
               END IF
               SELECT DISTINCT asa03 INTO l_asa03 FROM asa_file
                WHERE asa01=tm.asa01
                  AND asa02=tm.asa02
               LET tm.asa03 = l_asa03
               DISPLAY l_asa03 TO asa03

               LET g_sql = "SELECT asz05,asz06 FROM ",cl_get_target_table(g_plant_new,'asz_file'),
                           " WHERE asz00 = '0'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
               PREPARE p007_pre_01 FROM g_sql
               DECLARE p007_cur_01 CURSOR FOR p007_pre_01
               OPEN p007_cur_01
               FETCH p007_cur_01 INTO g_asz05,g_asz06 #合併帳別
               CLOSE p007_cur_01
               CALL s_aaz641_asg(tm.asa01,tm.asa02) RETURNING g_dbs_asg03
               CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01
            END IF
            DISPLAY l_asa03 TO asa03

            LET g_asa06 = '2'
            SELECT asa05,asa06 
              INTO g_asa05,g_asa06  #平均匯率計算方式 / 編制合併期別 1.月 2.季 3.半年 4.年
             FROM asa_file
            WHERE asa01 = tm.asa01     #族群編號
              AND asa04 = 'Y'   #最上層公司否
            LET tm.asa06 = g_asa06
            DISPLAY BY NAME tm.asa06
            CALL p007_set_entry()    
            CALL p007_set_no_entry()

            IF tm.asa06 = '1' THEN
                LET tm.q1 = '' 
                LET tm.h1 = '' 
                LET tm.em = g_aaa05
            END IF
            IF tm.asa06 = '2' THEN
                LET tm.h1 = '' 
                LET tm.em = '' 
            END IF
            IF tm.asa06 = '3' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
            END IF
            IF tm.asa06 = '4' THEN
                LET tm.em = '' 
                LET tm.q1 = ''
                let tm.h1 = ''
            END IF
            DISPLAY BY NAME tm.em
            DISPLAY BY NAME tm.q1
            DISPLAY BY NAME tm.h1

         AFTER FIELD gl
            IF NOT cl_null(tm.gl) THEN
               SELECT *  FROM aac_file        #讀取單據性質資料
                WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
               IF SQLCA.sqlcode THEN          #抱歉,讀不到
                  CALL cl_err3("sel","aac_file",tm.gl,"","agl-035","","",0)
                  NEXT FIELD gl
               END IF
            END IF
            IF NOT cl_null(tm.asa06) THEN
                CASE
                    WHEN tm.asa06 = '1'  #月 
                         LET tm.bm = 0
                    OTHERWISE      
                         CALL s_asg03_dbs(tm.asa02) RETURNING l_asg03 
                         CALL s_get_aznn01(l_asg03,tm.asa06,tm.asa03,tm.yy,tm.q1,tm.h1) RETURNING tm.em
                         DISPLAY BY NAME tm.em     #FUN-B90010   Ad.
                END CASE
            END IF

         AFTER FIELD ver      #版本 
            IF cl_null(tm.ver) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD ver 
            END IF

         AFTER FIELD hisyy    #歷史匯率年度 
            IF cl_null(tm.hisyy) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD hisyy 
            END IF

         AFTER FIELD hismm    #歷史匯率期別 
            IF cl_null(tm.hismm) THEN
               CALL cl_err('','mfg0037',0) NEXT FIELD hismm
            END IF

         #ON ACTION CONTROLZ    #TQC-C40010  mark
         ON ACTION CONTROLR     #TQC-C40010  add
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asa"
                  LET g_qryparam.default1 = tm.asa01
                  CALL cl_create_qry() RETURNING tm.asa01,tm.asa02,tm.asa03
                  DISPLAY BY NAME tm.asa01,tm.asa02,tm.asa03
                  NEXT FIELD asa01
               WHEN INFIELD(asa02) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_asg"
                  LET g_qryparam.default1 = tm.asa02
                  CALL cl_create_qry() RETURNING tm.asa02
                  DISPLAY BY NAME tm.asa02
                  NEXT FIELD asa02
               WHEN INFIELD(gl) #單據性質
                  CALL q_aac(FALSE,TRUE,tm.gl,'A',' ',' ','GGL')
                       RETURNING tm.gl         
                  DISPLAY  BY NAME tm.gl  
                  NEXT FIELD gl     
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about
             CALL cl_about()
 
          ON ACTION help
             CALL cl_show_help()

         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT

         BEFORE INPUT
             CALL cl_qbe_init()
             CALL p007_set_entry()
             CALL p007_set_no_entry()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW gglp206_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01= 'gglp206'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('gglp206','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " ''",
                       " '",tm.asa01,"'", 
                       " '",tm.asa02,"'", 
                       " '",tm.asa03,"'", 
                       " '",tm.yy,"'",    
                       " '",tm.asa06,"'", 
                       " '",tm.em,"'",    
                       " '",tm.q1,"'",    
                       " '",tm.h1,"'",    
                       " '",tm.gl,"'",
                       " '",tm.gl CLIPPED,"'",
                       " '",tm.ver CLIPPED,"'",
                       " '",tm.hisyy CLIPPED,"'",
                       " '",tm.hismm CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('gglp206',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW gglp206_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE

END FUNCTION
   
FUNCTION p007()
DEFINE l_sql        STRING,
       l_sql_asf    LIKE type_file.chr1000,
       i,g_no       LIKE type_file.num5,  
       l_aah         RECORD 
                     aah01      LIKE aah_file.aah01,  #科目編號
                     aah02      LIKE aah_file.aah02,  #會計年度
                     aah03      LIKE aah_file.aah03,  #期別
                     aah04      LIKE aah_file.aah04,  #借方金額
                     aah05      LIKE aah_file.aah05,  #貸方金額
                     aah06      LIKE aah_file.aah06,  #借方筆數
                     aah07      LIKE aah_file.aah07   #貸方筆數
                     END RECORD,
       l_aed         RECORD
                     aed01      LIKE aed_file.aed01,  #科目年度
                     aed011     LIKE aed_file.aed011, #異動碼順序
                     aed02      LIKE aed_file.aed02,  #異動碼值
                     aed03      LIKE aed_file.aed03,  #會計年度
                     aed04      LIKE aed_file.aed04,  #期別
                     aed05      LIKE aed_file.aed05,  #借方總金額
                     aed06      LIKE aed_file.aed06,  #貸方總金額
                     aed07      LIKE aed_file.aed07,  #借方總筆數
                     aed08      LIKE aed_file.aed08   #貸方總筆數
                     END RECORD,
       l_aeh         RECORD LIKE aeh_file.*,
       l_asl16       LIKE asl_file.asl16,
       l_asl17       LIKE asl_file.asl17,
       l_chg_asll11_1 LIKE asf_file.asf13,
       l_chg_asll12_1 LIKE asf_file.asf13,
       l_chg_asll11   LIKE asf_file.asf13,
       l_chg_asll12   LIKE asf_file.asf13,
       l_chg_asll11_a LIKE asf_file.asf13,
       l_chg_asll12_a LIKE asf_file.asf13,
       l_asll        RECORD LIKE asll_file.*,
       l_asi1        RECORD
                     asi05      LIKE asi_file.asi05,  #科目年度
                     asi06      LIKE asi_file.asi06,  #會計年度
                     asi07      LIKE asi_file.asi07,  #期別
                     asi08      LIKE asi_file.asi08,  #借方金額
                     asi09      LIKE asi_file.asi09,  #貸方金額
                     asi10      LIKE asi_file.asi10,  #借方筆數
                     asi11      LIKE asi_file.asi11,  #貸方筆數
                     asi13      LIKE asi_file.asi13   #關係人代號 
                     END RECORD,
       l_asi         RECORD          
                     asi00      LIKE asi_file.asi00,
                     asi01      LIKE asi_file.asi01,
                     asi02      LIKE asi_file.asi02,
                     asi03      LIKE asi_file.asi03,
                     asi04      LIKE asi_file.asi04,
                     asi041     LIKE asi_file.asi041,
                     asi05      LIKE asi_file.asi05,
                     asi06      LIKE asi_file.asi06,
                     asi07      LIKE asi_file.asi07,
                     asi08      LIKE asi_file.asi08,
                     asi09      LIKE asi_file.asi09,
                     asi10      LIKE asi_file.asi10,
                     asi11      LIKE asi_file.asi11,
                     asi12      LIKE asi_file.asi12,
                     asi13      LIKE asi_file.asi13
                     END RECORD,
       l_ash         RECORD
                     ash04      LIKE ash_file.ash04,
                     ash11      LIKE ash_file.ash11,  #再衡量匯率類別
                     ash12      LIKE ash_file.ash12   #換算匯率類別
                     END RECORD,
       l_ashh        RECORD
                     ashh04     LIKE ashh_file.ashh04,
                     ashh11     LIKE ashh_file.ashh11,  #再衡量匯率類別
                     ashh12     LIKE ashh_file.ashh12   #換算匯率類別
                     END RECORD,
       l_atc         RECORD LIKE atc_file.*,
       l_atcc        RECORD LIKE atcc_file.*,
       l_ash06       LIKE ash_file.ash06,             #合併後財報會計科目編號
       l_ashh06      LIKE ashh_file.ashh06,           #合併後財報會計科目編號
       l_aaa03       LIKE aaa_file.aaa03,             #原工廠本國幣別
       l_chg_aed05   LIKE aed_file.aed05,             #功能幣別借方總金額
       l_chg_aed06   LIKE aed_file.aed06,             #功能幣別貸方總金額
       l_chg_aed05_1 LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aed06_1 LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_chg_aed05_a LIKE aed_file.aed05,             #記帳幣別借方總金額
       l_chg_aed06_a LIKE aed_file.aed06,             #記帳幣別貸方總金額
       l_chg_aah04   LIKE aah_file.aah04,             #功能幣別借方金額
       l_chg_aah05   LIKE aah_file.aah05,             #功能幣別貸方金額
       l_chg_aah04_1 LIKE aah_file.aah04,             #記帳幣別借方金額
       l_chg_aah05_1 LIKE aah_file.aah05,             #記帳幣別貸方金額
       l_chg_aah04_a LIKE aah_file.aah04,             #記帳幣別借方金額
       l_chg_aah05_a LIKE aah_file.aah05,             #記帳幣別貸方金額
       l_chg_asi08   LIKE asi_file.asi08,             #功能幣別借方金額
       l_chg_asi09   LIKE asi_file.asi09,             #功能幣別貸方金額
       l_chg_asi08_1 LIKE asi_file.asi08,             #記帳幣別借方金額
       l_chg_asi09_1 LIKE asi_file.asi09,             #記帳幣別貸方金額
       l_chg_asi08_a LIKE asi_file.asi08,             #記帳幣別借方金額
       l_chg_asi09_a LIKE asi_file.asi09,             #記帳幣別貸方金額
       l_chg_atc08   LIKE atc_file.atc08,             #功能幣別借方金額
       l_chg_atc09   LIKE atc_file.atc09,             #功能幣別貸方金額
       l_chg_atc08_1 LIKE atc_file.atc08,             #記帳幣別借方金額
       l_chg_atc09_1 LIKE atc_file.atc09,             #記帳幣別貸方金額
       l_chg_atc08_a LIKE atc_file.atc08,             #記帳幣別借方金額
       l_chg_atc09_a LIKE atc_file.atc09,             #記帳幣別貸方金額
       l_chg_atcc10   LIKE atcc_file.atcc10,          #功能幣別借方金額
       l_chg_atcc11   LIKE atcc_file.atcc11,          #功能幣別貸方金額
       l_chg_atcc10_1 LIKE atcc_file.atcc10,          #記帳幣別借方金額
       l_chg_atcc11_1 LIKE atcc_file.atcc11,          #記帳幣別貸方金額
       l_chg_atcc10_a LIKE atcc_file.atcc10,          #記帳幣別借方金額
       l_chg_atcc11_a LIKE atcc_file.atcc11,          #記帳幣別貸方金額
       l_n           LIKE type_file.num5,
       l_cut         LIKE type_file.num5,             #幣別取位(功能幣別)
       l_cut1        LIKE type_file.num5,             #幣別取位(記帳幣別)
       l_asg04       LIKE asg_file.asg04,             #使用TIPTOP否
       l_asg06       LIKE asg_file.asg06,             #上層公司記帳幣別
       l_asg         RECORD LIKE asg_file.*,
       l_ase08       LIKE ase_file.ase08,
       l_ase09       LIKE ase_file.ase09,
       l_asg03       LIKE asg_file.asg03,
       l_asf05       LIKE asf_file.asf05,
       l_asf08       LIKE asf_file.asf08,
       l_asf09       LIKE asf_file.asf09,
       l_aag06       LIKE aag_file.aag06
DEFINE l_aag04       LIKE aag_file.aag04
DEFINE l_bs_yy       LIKE type_file.num5
DEFINE l_bs_mm       LIKE type_file.num5
DEFINE l_asz01      LIKE asz_file.asz01
DEFINE l_asf_count   LIKE type_file.num5
DEFINE l_asf13       LIKE asf_file.asf13
DEFINE l_asr18       LIKE asr_file.asr18
DEFINE l_asr19       LIKE asr_file.asr19
DEFINE l_ass16       LIKE ass_file.ass16
DEFINE l_ass17       LIKE ass_file.ass17
DEFINE l_asi05       STRING
DEFINE l_ash04       LIKE asf_file.asf07
DEFINE l_ash04_cnt   LIKE type_file.num5
DEFINE l_asa09       LIKE asa_file.asa09
DEFINE l_aah04       LIKE aah_file.aah04
DEFINE l_chg_dr      LIKE aah_file.aah04              #借方金額
DEFINE l_chg_cr      LIKE aah_file.aah05              #貸方金額
DEFINE l_fun_dr      LIKE aah_file.aah04              #借方金額
DEFINE l_fun_cr      LIKE aah_file.aah04              #借方金額
DEFINE l_acc_dr      LIKE aah_file.aah05              #貸方金額
DEFINE l_acc_cr      LIKE aah_file.aah05              #貸方金額
DEFINE l_aah04_1     LIKE aah_file.aah04
DEFINE l_aah05_1     LIKE aah_file.aah05
DEFINE l_aed05       LIKE aed_file.aed05
DEFINE l_aed06       LIKE aed_file.aed06
DEFINE l_asi08       LIKE asi_file.asi08
DEFINE l_asi09       LIKE asi_file.asi09
DEFINE l_dr          LIKE aah_file.aah04
DEFINE l_cr          LIKE aah_file.aah05
DEFINE l_atc08       LIKE atc_file.atc08
DEFINE l_atc08_1     LIKE atc_file.atc08
DEFINE l_atc08_2     LIKE atc_file.atc08
DEFINE l_atc09       LIKE atc_file.atc09
DEFINE l_atc09_1     LIKE atc_file.atc09
DEFINE l_atc09_2     LIKE atc_file.atc09
DEFINE l_atcc10      LIKE atcc_file.atcc10
DEFINE l_atcc10_1    LIKE atcc_file.atcc10
DEFINE l_atcc10_2    LIKE atcc_file.atcc10
DEFINE l_atcc11      LIKE atcc_file.atcc11
DEFINE l_atcc11_1    LIKE atcc_file.atcc11
DEFINE l_atcc11_2    LIKE atcc_file.atcc11
DEFINE l_asll11      LIKE asll_file.asll11
DEFINE l_asll12      LIKE asll_file.asll12
DEFINE l_asll11_1    LIKE asll_file.asll11
DEFINE l_asll11_2    LIKE asll_file.asll11
DEFINE l_asll12_1    LIKE asll_file.asll12
DEFINE l_asll12_2    LIKE asll_file.asll12
DEFINE l_mm          LIKE type_file.chr4
DEFINE l_asi_cnt     LIKE type_file.num5
DEFINE l_aah_cnt     LIKE type_file.num5
DEFINE l_aed_cnt     LIKE type_file.num5
DEFINE l_aed01       LIKE aed_file.aed01
DEFINE l_aah01       LIKE aah_file.aah01
DEFINE l_aah02       LIKE aah_file.aah02
DEFINE l_aah03       LIKE aah_file.aah03
DEFINE l_aed02       LIKE aed_file.aed02
DEFINE l_ass         RECORD LIKE ass_file.*
DEFINE l_asr         RECORD LIKE asr_file.*
DEFINE l_chg_asnn11_1 LIKE asnn_file.asnn11
DEFINE l_chg_asnn12_1 LIKE asnn_file.asnn12
DEFINE l_chg_asnn11   LIKE asnn_file.asnn11
DEFINE l_chg_asnn12   LIKE asnn_file.asnn12
DEFINE l_chg_asnn11_a LIKE asnn_file.asnn11
DEFINE l_chg_asnn12_a LIKE asnn_file.asnn12
DEFINE l_num         LIKE type_file.num5


    #---FUN-B70065 start--
    #外幣換算損益(aaz86),換算調整數(aaz87)
    SELECT aaz87
      INTO g_aaz87
      FROM aaz_file 
    #---FUN-B70065 end---

   CALL p007_del()    #TQC-B70069   Add

# 先產生換匯差額分錄,並寫入p007_adj_tmp()  換匯分錄寫入
  #CALL p007_adj()   #FUN-B90057

# 產生調整分錄
#-->ref.asq_file insert into asj_file,ask_file
   CALL p007_modi()
   CALL p007_modi_adj()

END FUNCTION

#FUN-B90057--mark--str--
#FUNCTION p007_adj()
#DEFINE l_asz02        LIKE asz_file.asz02   #外幣換算損益
#DEFINE l_asz04        LIKE asz_file.asz04   #換算調整數
#DEFINE l_flag         LIKE type_file.chr1   #判斷是不是第一次進入迴圈
#DEFINE l_asg08_asq10  LIKE asg_file.asg08
#DEFINE l_asa09        LIKE asa_file.asa09
#DEFINE l_aag04        LIKE aag_file.aag04
#DEFINE l_amt_asz05   LIKE asr_file.asr08
#DEFINE l_amt_asz06   LIKE asr_file.asr08
#DEFINE l_asz05       LIKE asz_file.asz05
#DEFINE l_asz06       LIKE asz_file.asz06
#DEFINE l_amt_cnt      LIKE asr_file.asr08
#DEFINE l_amt_tot      LIKE asr_file.asr08
#DEFINE l_amt          LIKE asr_file.asr08
#DEFINE l_asr19        LIKE asr_file.asr19
#DEFINE l_asg06_asq16  LIKE asq_file.asq16
#DEFINE l_cut          LIKE type_file.num5
#DEFINE l_cnt          LIKE type_file.num5
#DEFINE l_sql          STRING
 
#  DROP TABLE p007_ask_tmp
#  CREATE TEMP TABLE p007_ask_tmp(
#     ask03   LIKE ask_file.ask03,
#     ask06   LIKE ask_file.ask06,
#     ask07   LIKE ask_file.ask07)

#  DROP TABLE p007_adj_tmp
#  CREATE TEMP TABLE p007_adj_tmp(
#     ask03   LIKE ask_file.ask03,
#     ask05   LIKE ask_file.ask05,
#     ask06   LIKE ask_file.ask06,
#     ask07   LIKE ask_file.ask07,
#     ask071  LIKE ask_file.ask071)

#  LET l_sql = "INSERT INTO p007_adj_tmp VALUES(?,?,?,?,?)"
#  PREPARE insert_adj_prep FROM l_sql
#  IF STATUS THEN
#     CALL cl_err('insert_prep:p007_adj_tmp',status,1) 
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time
#     EXIT PROGRAM
#  END IF

#  #外幣換算損益(asz02),換算調整數(asz04)
#  #本期損益-IS(asz05),本期損益-BS(asz06)
#  SELECT asz02,asz04,asz05,asz06
#    INTO l_asz02,l_asz04,l_asz05,l_asz06
#    FROM asz_file
#   WHERE asz00 = '0'

#  SELECT asg06 INTO l_asg06_asq16
#    FROM asg_file
#   WHERE asg01 = g_asq.asq16

#  LET l_amt_cnt = 0

#  CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
#  RETURNING g_bdate,g_edate
#  LET g_yy=tm.yy
#  LET g_mm=tm.em

#  LET g_asr04 = ''
#  LET g_amt = 0
#  LET l_flag = "Y"

#  SELECT asa09 INTO l_asa09 FROM asa_file                                     
#   WHERE asa01= tm.asa01                                                      
#    AND asa02= tm.asa02                                                      
#    AND asa03= tm.asa03                                                      
# IF l_asa09 = 'Y' THEN  
#    LET g_dbs_asg03 =  s_dbstring(g_dbs_asg03)                              
# ELSE                                                                        
#    LET g_dbs_asg03 =  s_dbstring(g_dbs)                                    
# END IF                      

# INITIALIZE g_asj.* TO NULL
# INITIALIZE g_ask.* TO NULL

# #將累積換算調整數拆開依各子公司列示
#                                                
# LET g_sql =                                                                
#     "SELECT asr04,SUM(asr09-asr08)",                      
#     "  FROM asr_file,",cl_get_target_table(g_plant_new,'aag_file'),
#     " WHERE asr00='",g_asz01,"'",                                         
#     "   AND asr01='",tm.asa01,"'",                                         
#     "   AND asr02='",tm.asa02,"'",                                         
#     "   AND asr17='",tm.ver,"'",                                           
#     "   AND asr06='",tm.yy,"'",                                            
#     "   AND aag00 ='",g_asz01,"'",                                        
#     "   AND asr05 = aag01",                                                
#     "   AND aag04 != '1'",                                                 
#     "   AND asr05 != '",l_asz05,"'",                                      
#     "   AND asr07 = '",tm.em,"'",
#     " GROUP BY asr04",                                                     
#     " ORDER BY asr04"                                                      
# CALL cl_replace_sqldb(g_sql) RETURNING g_sql
# CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
# PREPARE p007_adj_p2 FROM g_sql                                              
# DECLARE p007_adj_c2 CURSOR FOR p007_adj_p2                                  
# LET l_cnt = 0
# FOREACH p007_adj_c2 INTO g_asr04,l_amt_asz05                               
#    IF SQLCA.sqlcode THEN                                                    
#       LET g_asr04 = ' '                                                     
#       LET l_amt_asz05   = 0                                                
#       CONTINUE FOREACH                                
#    END IF                                                                   

#   #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
#   IF l_flag = "Y" THEN
#      CALL p007_ins_asj()
#      IF g_success = 'N' THEN RETURN  END IF
#      UPDATE asj_file set asj09='Y' 
#       WHERE asj01=g_asj.asj01
#         AND asj00=g_asz01
#      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#         CALL s_errmsg('asj01',g_asj.asj01,'upd_asj',SQLCA.sqlcode,1) 
#         RETURN 
#      END IF
#      LET l_flag = "N"
#   END IF

#   SELECT SUM(asr09-asr08)                                              
#     INTO l_amt_asz06                                                    
#     FROM asr_file                                                        
#    WHERE asr00=g_asz01                                                  
#      AND asr01=tm.asa01                                                  
#      AND asr02=tm.asa02                                                  
#      AND asr04=g_asr04                                                   
#      AND asr17=tm.ver                                                    
#      AND asr06=tm.yy                                                     
#      AND asr05 =l_asz06                                                 
#      AND asr07 = tm.em                                                   

#   IF cl_null(l_amt_asz06) THEN LET l_amt_asz06 = 0 END IF
#   LET l_amt_cnt = l_amt_asz05 - l_amt_asz06                               

#   IF l_amt_cnt <> 0 THEN
#       #判斷是不是第一次進入迴圈,若是的話才需做新增的動作
#       IF l_flag = "Y" THEN   
#          CALL p007_ins_asj()
#          IF g_success = 'N' THEN RETURN  END IF
#          UPDATE asj_file set asj09='Y'
#           WHERE asj01=g_asj.asj01
#             AND asj00=g_asz01
#          #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#             CALL s_errmsg('asj01',g_asj.asj01,'upd_asj',SQLCA.sqlcode,1)
#             RETURN
#          END IF
#          LET l_flag = "N"
#       END IF 
#   END IF
#                                                                    
#     LET g_ask.ask00=g_asz01                                                  
#     LET g_ask.ask01=g_asj.asj01                                               
#     SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#      WHERE ask01=g_ask.ask01                                                  
#        AND ask00=g_ask.ask00                                                  
#     IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#     LET g_ask.ask03=l_asz06                    #科目
#     LET g_ask.ask04=' '                         #摘要                         
#     SELECT asg08 INTO g_ask.ask05 FROM asg_file #關系人                       
#      WHERE asg01=g_asr04                                                      
#                                                                               
#     IF l_amt_cnt >0 THEN                                                      
#        LET g_ask.ask06='2'                      #借貸別                       
#        LET g_ask.ask07= l_amt_cnt               #金額                         
#     ELSE                                                                      
#        LET g_ask.ask06='1'                      #借貸別                       
#        LET g_ask.ask07= l_amt_cnt*-1            #金額                         
#     END IF                                                                    
#     IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#     LET g_ask.asklegal=g_legal
#     IF g_ask.ask07 != 0 THEN                                                  
#        INSERT INTO ask_file VALUES (g_ask.*)                                  
#     END IF                                                                    
#                                                                               
#     #--寫入一筆asz04為對向科目的分錄和asz02為一組---                          
#     LET g_ask.ask00=g_asz01                                                  
#     LET g_ask.ask01=g_asj.asj01                                               
#     SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
#      WHERE ask01=g_ask.ask01
#      AND ask00=g_ask.ask00
#                                                                               
#     IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
#                                                                               
#     LET g_ask.ask03=l_asz04                     #科目                         
#     LET g_ask.ask04=' '                         #摘要                         
#     SELECT asg08 INTO g_ask.ask05 FROM asg_file #關系人                       
#      WHERE asg01=g_asr04

#     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg06_asq16
#     IF cl_null(l_cut) THEN LET l_cut = 0 END IF
#     LET g_ask.ask07=cl_digcut(g_ask.ask07,l_cut)

#     IF l_amt_cnt >0 THEN                                                      
#        LET g_ask.ask06='1'                      #借貸別                       
#        LET g_ask.ask07= l_amt_cnt               #金額                         
#     ELSE                                                                      
#        LET g_ask.ask06='2'                      #借貸別                       
#        LET g_ask.ask07= l_amt_cnt*-1            #金額                         
#     END IF                                                                    
#     IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
#     LET g_ask.asklegal=g_legal
#     IF g_ask.ask07 != 0 THEN                                                  
#        INSERT INTO ask_file VALUES (g_ask.*)                               
#        LET l_cnt = l_cnt + 1
#     END IF                                                                    
#  END FOREACH                                                                  

#  IF l_cnt = 0 THEN
#      DELETE FROM asj_file where asj00 = g_asz01 AND asj01 = g_asj.asj01
#      LET l_flag = 'Y'
#  END IF

#  IF l_amt_cnt = 0 THEN
#     IF l_flag = "Y" THEN   
#        CALL p007_ins_asj()
#        IF g_success = 'N' THEN RETURN  END IF
#        UPDATE asj_file set asj09='Y' 
#         WHERE asj01=g_asj.asj01
#           AND asj00=g_asz01 
#        #增加UPDATE的判斷( SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0)
#        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL s_errmsg('asj01',g_asj.asj01,'upd_asj',SQLCA.sqlcode,1) 
#           RETURN 
#        END IF
#        LET l_flag = "N"
#     END IF  
#  END IF

#  LET g_sql =                                                                  
#      "SELECT asr04,SUM(asr08-asr09)",                                     
#      "  FROM asr_file,",cl_get_target_table(g_plant_new,'asr_file'),                     
#      " WHERE asr00='",g_asz01,"'",                                           
#      "   AND asr01='",tm.asa01,"'",                                           
#      "   AND asr02='",tm.asa02,"'",                                           
#      "   AND asr17='",tm.ver,"'",                                             
#      "   AND asr06='",tm.yy,"'",                                              
#      "   AND asr07 ='",tm.em,"'",                                             
#      "   AND aag00 ='",g_asz01,"'",                                          
#      "   AND asr05 = aag01",                                                  
#      "   AND aag04 = '1'",                                                    
#      " GROUP BY asr04",                                                       
#      " ORDER BY asr04"                                                        
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
#  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
#  PREPARE p007_adj_p1 FROM g_sql                                               
#  DECLARE p007_adj_c1 CURSOR FOR p007_adj_p1                                   
#  LET l_cnt = 0
#  FOREACH p007_adj_c1 INTO g_asr04,g_amt                                       
#     IF SQLCA.sqlcode THEN
#     LET g_asr04 = ' '                                                      
#        LET g_amt   = 0                                                        
#        CONTINUE FOREACH                                                       
#     END IF                                                                    
#     IF g_amt = 0 THEN                                                         
#        CONTINUE FOREACH                                                       
#     END IF                                                                    

#     LET g_ask.ask00=g_asz01
#     LET g_ask.ask01=g_asj.asj01
#     SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file 
#      WHERE ask01=g_ask.ask01
#        AND ask00=g_ask.ask00
#     IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF
#     LET g_ask.ask03=l_asz04                     #科目
#     LET g_ask.ask04=' '                         #摘要
#     SELECT asg08 INTO g_ask.ask05 FROM asg_file #關系人                                                                   
#      WHERE asg01=g_asr04                                                                                                  
#     IF g_amt >0 THEN
#        LET g_ask.ask06='2'                      #借貸別
#        LET g_ask.ask07=g_amt                    #金額
#     ELSE
#        LET g_ask.ask06='1'                      #借貸別
#        LET g_ask.ask07=g_amt*-1                 #金額
#     END IF
#     IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF
#     LET g_ask.asklegal=g_legal
#     IF g_ask.ask07 != 0 THEN
#        INSERT INTO ask_file VALUES (g_ask.*)
#        LET l_cnt = l_cnt + 1
#        #先將資料寫TempTable裡,後續股本累換數使用
#        CALL p007_adj_tmp(g_ask.*)
#     END IF
#  END FOREACH
#  IF l_cnt = 0 THEN
#      DELETE FROM asj_file where asj00 = g_asz01 AND asj01 = g_asj.asj01
#  END IF
#  CALL upd_asj()
#END FUNCTION 
#FUN-B90057--mark--end

FUNCTION p007_modi()   #產生調整分錄
DEFINE l_ass09_o    LIKE ass_file.ass09,             #期別
       l_asr07_m    LIKE asr_file.asr07,
       l_ass09_o1   LIKE ass_file.ass09,             #期別
       l_asr07_m1   LIKE asr_file.asr07,
       l_ass07_o    LIKE ass_file.ass07,             #異動碼值
       l_ass07_o1   LIKE ass_file.ass07,             #異動碼值
       l_asr07_o    LIKE asr_file.asr07,             #期別
       l_cnt        LIKE type_file.num5,
       l_sql,l_sql1 STRING,    
       i,g_no       LIKE type_file.num5  
DEFINE l_asg08      LIKE asg_file.asg08
DEFINE l_asq09_asg05      LIKE asg_file.asg05
DEFINE l_asq10_asg05      LIKE asg_file.asg05
DEFINE l_ass10_ass11_sum  LIKE ass_file.ass10
DEFINE l_i                LIKE type_file.num5
DEFINE l_aag04            LIKE aag_file.aag04
DEFINE l_asq01            STRING
DEFINE l_asq02            STRING

   #建立TempTable以便處理科目為MISC的資料
   DROP TABLE p007_tmp
   CREATE TEMP TABLE p007_tmp(
      asr06   LIKE asr_file.asr06,
      asr07   LIKE asr_file.asr07,
      asr05   LIKE asr_file.asr05,
      asr02   LIKE asr_file.asr02,
      asr04   LIKE asr_file.asr04,
      asr08   LIKE asr_file.asr08,
      asr12   LIKE asr_file.asr12,
      affil   LIKE ask_file.ask05,
      dc      LIKE ask_file.ask06,
      flag_r  LIKE type_file.chr1)   

   DELETE FROM p007_tmp
   LET l_sql = "INSERT INTO p007_tmp VALUES(?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET l_sql = "INSERT INTO p007_ask_tmp VALUES(?,?,?)" 
   PREPARE insert_ask_prep FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('insert_prep:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET l_sql1=
    "SELECT asa01,asa02,asa03 FROM asa_file ",
    " WHERE asa01='",tm.asa01,"'",
    " UNION ",
    "SELECT asb01,asb04,asb05 ",
    "  FROM asb_file,asa_file ",
    " WHERE asa01=asb01 AND asa02=asb02 AND asa03=asb03 ",
    "   AND asa01='",tm.asa01,"'"

   PREPARE p007_asa_p1 FROM l_sql1
	   DECLARE p007_asa_c1 CURSOR FOR p007_asa_p1

   LET g_no = 1
   FOREACH p007_asa_c1 INTO g_asa[g_no].*
      IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
      END IF  
      IF SQLCA.SQLCODE THEN
         LET g_showmsg=tm.asa01,"/",tm.asa02,"/",tm.asa03
         CALL s_errmsg('asa01,asa02,asa03',g_showmsg,'for_asa_c1:',STATUS,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      LET g_no=g_no+1
   END FOREACH
   IF g_totsuccess="N" THEN LET g_success="N" END IF
   LET g_no=g_no-1

   INITIALIZE g_asj.* TO NULL
   INITIALIZE g_ask.* TO NULL

   FOR i =1 TO g_no
     IF g_success='N' THEN                                                    
        LET g_totsuccess='N'                                                   
        LET g_success='Y'                                                      
     END IF 

#配合agli003己開放非股本資料也能設為MISC對沖
#1.先抓來源會科，如果是MISC時，則來源為ast_file，
#接著處理對沖科目，如果亦為MISC則來源為asu_file
#其它狀況可能會一對一 ，一對多，多對一，多對多，所以在程式上要配合
#如果一對多時，asq<->asu, 一對一 asq<->asq, 多對一 ast<->asq, 多對多 ast<->asu
#2.資料來源又可分為asr_file,ass_file,依asq15,asq17決定

     DECLARE p007_asq_cs1 CURSOR FOR
        SELECT *
          FROM asq_file 
          WHERE asq13=g_asa[i].asa01   #族群
           AND asq09=g_asa[i].asa02   #來源公司               
           AND asqacti='Y'            #有效的資料
         ORDER BY asq12,asq10,asq01,asq02,asq03,asq04
     FOREACH p007_asq_cs1 INTO g_asq.*
     IF g_asq.asq16 <> tm.asa02 THEN CONTINUE FOREACH END IF

     LET l_asq01 = g_asq.asq01
     LET l_asq02 = g_asq.asq02
     LET l_asq01 = l_asq01.substring(1,4)
     LET l_asq02 = l_asq02.substring(1,4)
    
     #抓出下層公司asq10在agli009中設定的關係人異動碼值--
     SELECT asg08 INTO g_asg08
       FROM asg_file
      WHERE asg01 = g_asq.asq09

     CALL p007_modi_asq_misc(l_asq01,l_asq02,g_asq.asq15,g_asq.asq17,i)
     
     END FOREACH
   END FOR

   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
END FUNCTION

FUNCTION p007_modi_adj()
DEFINE l_ask03   LIKE ask_file.ask03
DEFINE l_ask06   LIKE ask_file.ask06
DEFINE l_ask07   LIKE ask_file.ask07
DEFINE l_aag06   LIKE aag_file.aag06
DEFINE li_result LIKE type_file.num5     
DEFINE l_cnt     LIKE type_file.num5

   INITIALIZE g_asj.* TO NULL
   INITIALIZE g_ask.* TO NULL

   CALL s_ymtodate(tm.yy,tm.bm,tm.yy,tm.em)
   RETURNING g_bdate,g_edate
   LET g_yy=tm.yy 
   LET g_mm=tm.em 

    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)
       RETURN 
    END IF
    LET g_asj.asj00  = g_asz01      #帳別      
    LET g_asj.asj01  = tm.gl         #傳票編號
    LET g_asj.asj02  = g_edate       #單據日期
    LET g_asj.asj03  = g_yy          #調整年度 
    LET g_asj.asj04  = g_mm          #調整月份 
    LET g_asj.asj05  = tm.asa01      #族群編號
    LET g_asj.asj06  = tm.asa02      #上層公司編號
    LET g_asj.asj07  = tm.asa03      #上層帳別
    LET g_asj.asj08  = '2'           #來源碼
    LET g_asj.asj09  = 'N'           #換匯差額調整否    
    LET g_asj.asjconf= 'Y'           #確認碼
    LET g_asj.asjuser= g_user        #資料所有者
    LET g_asj.asjgrup= g_grup        #資料所有群
    LET g_asj.asjdate= g_today       #最近修改日
    LET g_asj.asj21  = tm.ver        #版本   
    #LET g_asj.asj081 = '1'   #luttb
    LET g_asj.asj081 = '7'
    LET g_asj.asjlegal = g_legal 
    LET g_asj.asjoriu = g_user    
    LET g_asj.asjorig = g_grup  
    LET g_ask.asklegal=g_legal

   #CALL s_auto_assign_no("ggl",g_asj.asj01,g_asj.asj02,"A",  #carrier 20111024
    CALL s_auto_assign_no("AGL",g_asj.asj01,g_asj.asj02,"A",  #carrier 20111024
                         #"asj_file","asj01",g_dbs,"2",g_asz01) 
                          "asj_file","asj01",g_plant,"2",g_asz01) 
    RETURNING li_result,g_asj.asj01
    DISPLAY g_asj.asj01
    IF g_success='N' THEN 
        LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate  
        CALL s_errmsg('asj00,asj01,asj02',g_showmsg,g_asj.asj01,'mfg-059',1)
        RETURN 
    END IF

   #--取出此上層公司的調整分錄非換匯者 ----
     DECLARE p007_ask_cs CURSOR FOR
        SELECT ask03,ask06,ask07
          FROM p007_ask_tmp
     LET l_cnt = 0
     FOREACH p007_ask_cs INTO l_ask03,l_ask06,l_ask07
        IF SQLCA.sqlcode THEN 
           LET g_showmsg= l_ask03,"/",l_ask06,"/"
           CALL s_errmsg('ask03,ask06',g_showmsg,'p007_ask_cs',SQLCA.sqlcode,1) 
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF
        LET l_cnt = l_cnt + 1

##. 取沖銷調整分錄中換匯差額否[asj09<>'Y']者的分錄
#1. 當沖銷銷調整分錄中有借方科目[ask06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益BS [asz06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#           C : 本期損益IS [asz05]==>僅配合借貸平衡暫存科目
#2. 當沖銷銷調整分錄中有貸方科目[ask06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='2']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益IS [asz05]==>僅配合借貸平衡暫存科目
#           C : 本期損益BS [asz06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#3. 當沖銷銷調整分錄中有借方科目[ask06=1]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
#   則切一筆本期損益沖銷分錄
#   D : 本期損益BS [asz06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益
#           C : 本期損益IS [asz05]==>僅配合借貸平衡暫存科目
#4. 當沖銷銷調整分錄中有貸方科目[ask06=2]且科目性質為損益科目[aag04='2']且餘額型態為貸餘[aag06='1']者
#   D : 本期損益IS [asz05]==>僅配合借貸平衡暫存科目
#          C : 本期損益BS [asz06] ==> 目的調整資產負債表上本期損益金額等於損益表上本期損益

      LET g_ask.ask00=g_asz01                                                  
      LET g_ask.ask01=g_asj.asj01                                               

      CASE 
          WHEN l_ask06 = '1'
               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
                WHERE ask01=g_ask.ask01                                                  
                  AND ask00=g_ask.ask00                                                  
               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
               LET g_ask.ask03=g_asz06
               LET g_ask.ask04=' '                      #摘要                         
               LET g_ask.ask06='1'                      #借貸別                       
               LET g_ask.ask07= l_ask07
               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
               IF g_ask.ask07 != 0 THEN                                                  
                  INSERT INTO ask_file VALUES (g_ask.*)                                  
               END IF                                                                    

               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
                WHERE ask01=g_ask.ask01                                                  
                  AND ask00=g_ask.ask00                                                  
               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
               LET g_ask.ask03=g_asz05
               LET g_ask.ask04=' '                      #摘要                         
               LET g_ask.ask06='2'                      #借貸別                       
               LET g_ask.ask07= l_ask07
               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
               IF g_ask.ask07 != 0 THEN                                                  
                  INSERT INTO ask_file VALUES (g_ask.*)                                  
               END IF                                                                    
          WHEN l_ask06 = '2'
               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
                WHERE ask01=g_ask.ask01                                                  
                  AND ask00=g_ask.ask00                                                  
               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
               LET g_ask.ask03=g_asz05
               LET g_ask.ask04=' '                      #摘要                         
               LET g_ask.ask06='1'                      #借貸別                       
               LET g_ask.ask07= l_ask07
               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
               IF g_ask.ask07 != 0 THEN                                                  
                  INSERT INTO ask_file VALUES (g_ask.*)                                  
               END IF                                                                    

               SELECT MAX(ask02)+1 INTO g_ask.ask02 FROM ask_file                        
                WHERE ask01=g_ask.ask01                                                  
                  AND ask00=g_ask.ask00                                                  
               IF cl_null(g_ask.ask02) THEN LET g_ask.ask02 = 1 END IF                   
               LET g_ask.ask03=g_asz06
               LET g_ask.ask04=' '                      #摘要                         
               LET g_ask.ask06='2'                      #借貸別                       
               LET g_ask.ask07= l_ask07
               IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF                      
               IF g_ask.ask07 != 0 THEN                                                  
                  INSERT INTO ask_file VALUES (g_ask.*)                                  
               END IF                                                                    
      END CASE
   END FOREACH

   #--先寫完單身再寫單頭，避免單身無值
   IF l_cnt > 0 THEN
   #FUN-B80135--add--str--
      IF g_asj.asj03 <g_year OR (g_asj.asj03=g_year AND g_asj.asj04<=g_month) THEN
         CALL cl_err('','atp-164',1)
         RETURN
      END IF
  #FUN-B80135--add—end--
       #No.TQC-C90057  --Begin
       IF cl_null(g_asj.asj09) THEN LET g_asj.asj09 = 'N' END IF
       IF cl_null(g_asj.asj11) THEN LET g_asj.asj11 = 0 END IF
       IF cl_null(g_asj.asj12) THEN LET g_asj.asj12 = 0 END IF
       #No.TQC-C90057  --End  
       INSERT INTO asj_file VALUES(g_asj.*)
       IF SQLCA.sqlcode THEN 
          LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate
          CALL s_errmsg('asj00,asj01,asj02 ',g_showmsg,'ins asj',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
          RETURN 
       END IF
       IF NOT cl_null(g_asj.asj01) THEN CALL upd_asj() END IF   
   END IF
END FUNCTION

FUNCTION p007_set_entry() 
    CALL cl_set_comp_entry("q1,em,h1",TRUE) 
END FUNCTION

FUNCTION p007_set_no_entry() 

      CALL cl_set_comp_entry("asa06",FALSE) 

      IF tm.asa06 ="1" THEN  #月
         CALL cl_set_comp_entry("q1,h1",FALSE) 
      END IF
      IF tm.asa06 ="2" THEN  #季
         CALL cl_set_comp_entry("em,h1",FALSE) 
      END IF
      IF tm.asa06 ="3" THEN  #半年
         CALL cl_set_comp_entry("em,q1",FALSE) 
      END IF
      IF tm.asa06 ="4" THEN  #年
         CALL cl_set_comp_entry("q1,em,h1",FALSE) 
      END IF
END FUNCTION

FUNCTION p007_ins_asj()
DEFINE li_result  LIKE type_file.num5

    INITIALIZE g_asj.* TO NULL

    SELECT * INTO g_aac.* FROM aac_file         #讀取單據性質資料
     WHERE aac01=tm.gl AND aacacti = 'Y' AND aac11='A'
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.gl,"/",'Y',"/",'A'     
       CALL s_errmsg('aac01,aacacti,aac11',g_showmsg,'sel aac',SQLCA.sqlcode,0)
       RETURN 
    END IF
    LET g_asj.asj00  = g_asz01      #帳別
    LET g_asj.asj01  = tm.gl         #傳票編號
    LET g_asj.asj02  = g_edate       #單據日期
    LET g_asj.asj03  = g_yy          #調整年度
    LET g_asj.asj04  = g_mm          #調整月份
    LET g_asj.asj05  = tm.asa01      #族群編號
    LET g_asj.asj06  = tm.asa02      #上層公司編號
    LET g_asj.asj07  = tm.asa03      #上層帳別
    LET g_asj.asj08  = '2'           #來源碼 (1.調整作業  2.沖銷 3.會計師調整)
    LET g_asj.asj09  = 'N'           #換匯差額調整否
    LET g_asj.asjconf= 'Y'           #確認碼
    LET g_asj.asjuser= g_user        #資料所有者
    LET g_asj.asjgrup= g_grup        #資料所有群
    LET g_asj.asjdate= g_today       #最近修改日
    LET g_asj.asj21  = tm.ver        #版本
    LET g_asj.asj081 = '7' 
    LET g_asj.asjlegal = g_legal

   #CALL s_auto_assign_no("ggl",g_asj.asj01,g_asj.asj02,"A",  #carrier 20111024
    CALL s_auto_assign_no("AGL",g_asj.asj01,g_asj.asj02,"A",  #carrier 20111024
                          "asj_file","asj01",g_plant,"2",g_asz01)
    RETURNING li_result,g_asj.asj01
    DISPLAY g_asj.asj01
    IF g_success='N' THEN 
        LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate  
        CALL s_errmsg('asj00,asj01,asj02',g_showmsg,g_asj.asj01,'mfg-059',1)
        RETURN 
    END IF

    LET g_asj.asjoriu = g_user
    LET g_asj.asjorig = g_grup
   
    #FUN-B80135--add--str--
    IF g_asj.asj03 <g_year OR (g_asj.asj03=g_year AND g_asj.asj04<=g_month) THEN
       CALL cl_err('','atp-164',1)
       RETURN
    END IF
  #FUN-B80135--add—end--
    #FUN-C80056 --add--str
     IF cl_null(g_asj.asj11) THEN LET g_asj.asj11 = 0 END IF
     IF cl_null(g_asj.asj12) THEN LET g_asj.asj12 = 0 END IF
     #FUN-C80056---add--end

    INSERT INTO asj_file VALUES(g_asj.*)
    IF SQLCA.sqlcode THEN 
       LET g_showmsg= tm.asa03,"/",tm.gl,"/",g_edate
       CALL s_errmsg('asj00,asj01,asj02 ',g_showmsg,'ins asj',SQLCA.sqlcode,1)                                     #NO.FUN-710023 
       RETURN 
    END IF

END FUNCTION

#FUN-B90057--mark--str--
#FUNCTION p007_adj_tmp(p_ask)
#DEFINE p_ask  RECORD LIKE ask_file.*
#DEFINE l_ask  RECORD 
#             ask03    VARCHAR(24),
#             ask05    VARCHAR(15),               
#             ask06    VARCHAR(1),
#             ask07    DECIMAL(20,6),             
#             ask071    DECIMAL(20,6)             
#             END RECORD
#DEFINE l_x    LIKE type_file.num5

#  SELECT COUNT(*) INTO l_x FROM p007_adj_tmp
#   WHERE ask03 = p_ask.ask03
#     AND ask05 = p_ask.ask05

#  LET l_ask.ask03 = p_ask.ask03
#  LET l_ask.ask05 = p_ask.ask05
#  LET l_ask.ask06 = ''

#  IF l_x = 0 THEN
#     IF p_ask.ask06 = '1' THEN
#        LET l_ask.ask07 = p_ask.ask07
#        LET l_ask.ask071 = 0
#     ELSE
#        LET l_ask.ask07 =  0
#        LET l_ask.ask071 = p_ask.ask07
#     END IF
#     EXECUTE insert_adj_prep USING l_ask.ask03,l_ask.ask05,p_ask.ask06,l_ask.ask07,l_ask.ask071    #TQC-AA0098
#  ELSE
#     SELECT * INTO l_ask.*  FROM  p007_adj_tmp
#      WHERE ask03 = p_ask.ask03
#        AND ask05 = p_ask.ask05

#     IF p_ask.ask06 = '1' THEN
#        LET l_ask.ask07 = l_ask.ask07 + p_ask.ask07
#     ELSE
#        LET l_ask.ask071 = l_ask.ask071 + p_ask.ask07
#     END IF

#     UPDATE p007_adj_tmp SET ask07  =  l_ask.ask07,
#                             ask071 =  l_ask.ask071,
#                             ask06 = p_ask.ask06
#      WHERE ask03 = p_ask.ask03
#        AND ask05 = p_ask.ask05
#  END IF

#END FUNCTION
#FUN-B90057--mark--end

FUNCTION upd_asj()
DEFINE l_sum_tot    LIKE ask_file.ask07

    LET l_sum_tot=0
    SELECT SUM(ask07) INTO l_sum_tot  FROM ask_file 
     WHERE ask01=g_asj.asj01 AND ask06='1'
       AND ask00=g_asz01
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF
    IF STATUS OR cl_null(l_sum_tot) THEN 
       RETURN
    END IF
    UPDATE asj_file SET asj11 = l_sum_tot 
     WHERE asj01=g_asj.asj01
       AND asj00=g_asz01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
       RETURN
    END IF

    LET l_sum_tot=0
    SELECT SUM(ask07) INTO l_sum_tot FROM ask_file 
     WHERE ask01=g_asj.asj01 AND ask06='2'
       AND ask00=g_asz01
    IF cl_null(l_sum_tot) THEN LET l_sum_tot=0 END IF
    IF STATUS OR cl_null(l_sum_tot) THEN
       RETURN
    END IF
    UPDATE asj_file SET asj12 = l_sum_tot 
     WHERE asj01=g_asj.asj01
       AND asj00=g_asz01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
       RETURN
    END IF
END FUNCTION

FUNCTION p007_modi_asq_misc(p_asq01,p_asq02,p_asq15,p_asq17,i)
DEFINE p_asq01   STRING
DEFINE p_asq02   STRING
DEFINE p_asq17   LIKE asq_file.asq17
DEFINE p_asq15   LIKE asq_file.asq15,
       l_cnt        LIKE type_file.num5,
       l_sql,l_sql1 STRING,  
       i,g_no       LIKE type_file.num5
DEFINE l_asg08      LIKE asg_file.asg08
DEFINE l_asq09_asg05      LIKE asg_file.asg05
DEFINE l_asq10_asg05      LIKE asg_file.asg05
DEFINE l_ass10_ass11_sum  LIKE ass_file.ass10
DEFINE l_i                LIKE type_file.num5
DEFINE l_aag04            LIKE aag_file.aag04
DEFINE l_asg08_asq10      LIKE asg_file.asg08
DEFINE l_asg03_asq09      LIKE asg_file.asg03
DEFINE l_asg03_asq10      LIKE asg_file.asg03
DEFINE g_dbs_asq09        LIKE azp_file.azp03
DEFINE g_dbs_asq10        LIKE azp_file.azp03
DEFINE l_asb02            LIKE asb_file.asb02
DEFINE l_low_asq09        LIKE type_file.num5
DEFINE l_up_asq09         LIKE type_file.num5
DEFINE l_low_asq10        LIKE type_file.num5
DEFINE l_up_asq10         LIKE type_file.num5
DEFINE l_asa02_asq09      LIKE asa_file.asa02
DEFINE l_asa02_asq10      LIKE asa_file.asa02
DEFINE l_asg06_asq16      LIKE asg_file.asg06
DEFINE l_ask03            LIKE ask_file.ask03
DEFINE l_ask05            LIKE ask_file.ask05
DEFINE l_ask06            LIKE ask_file.ask06
DEFINE l_ask07            LIKE ask_file.ask07
DEFINE l_ask07_d          LIKE ask_file.ask07
DEFINE l_ask07_c          LIKE ask_file.ask07
DEFINE l_asu03            LIKE asu_file.asu03
DEFINE l_asq03            LIKE asq_file.asq03    #FUN-B50001 luttb

     DELETE FROM p007_tmp

     #抓出上層公司asq10在agli009中設定帳別
     SELECT asg05 INTO g_asq09_asg05
       FROM asg_file
      WHERE asg01 = g_asq.asq09
      SELECT asg05 INTO g_asq10_asg05
       FROM asg_file
      WHERE asg01 = g_asq.asq10

     #抓出下層公司asq10在agli009中設定的關係人異動碼值--
     SELECT asg08 INTO g_asg08
       FROM asg_file
      WHERE asg01 = g_asq.asq09
      SELECT asg08 INTO g_asg08_asq10
       FROM asg_file WHERE asg01 = g_asq.asq10

     #因系統目前在處理沖銷分錄時己經不再限於只有上下層公司的關係才能沖銷
     #之前的應用方式為tm.asa02上層公司輸入之後抓取的asr,ass資料都是自己本身
     #或是下層資料,但側流時不一定合併主體和來源/目的公司為同一顆tree，
     #SQL抓資料時分為以下狀況 ：
     #A.來源(目的)公司=合併主體：(順流)
     #  A1.asr02 = 自己, asr04 = 自己
     #  A2.asr02 = 不用加入此條件, asr04 = 自己
     #B.來源(目的)公司 <> 合併主體：(側流或逆流)
     #  IF 屬於上層公司
     #    1.最上層公司：條件=>asr02 = 自己, asr04 = 自己
     #    2.中間層(有上層也有下層),條件=> asr02 = 自己的上層公司,asr04 = 自己 
     #  ELSE
     #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己
     #  END IF
  
     #--先判斷g_asq.asq09(來源)/g_asq.asq10(目的)各自是否為上層公司--
     LET g_cnt_asq09 = 0
     SELECT COUNT(*) INTO g_cnt_asq09 
       FROM asa_file
      WHERE asa01 = g_asq.asq13   #群組
        AND asa02 = g_asq.asq09   #上層公司 

     LET g_cnt_asq10 = 0
     SELECT COUNT(*) INTO g_cnt_asq10 
       FROM asa_file
      WHERE asa01 = g_asq.asq13   #群組
        AND asa02 = g_asq.asq10   #上層公司

     IF g_cnt_asq09 > 0 THEN    #代表為上層公司
        #判斷是否存在下層
        SELECT COUNT(*) INTO g_low_asq09
          FROM asb_file
         WHERE asb01 = tm.asa01
           AND asb04 = g_asq.asq09
        IF g_low_asq09 > 0 THEN
             #--如果l_up_asq09 = 0 代表是最下層
             SELECT COUNT(*) INTO g_up_asq09
               FROM asa_file 
              WHERE asa01 = tm.asa01
                AND asa02 = g_asq.asq09
            IF g_up_asq09 <> 0 THEN
                SELECT asb02 INTO g_asa02_asq09
                  FROM asb_file
                 WHERE asb01 = tm.asa01
                   AND asb04 = g_asq.asq09
                #--如果g_up_asq09 = 0 代表是最下層
                SELECT COUNT(*) INTO g_up_asq09
                  FROM asa_file 
                 WHERE asa01 = tm.asa01
                   AND asa02 = g_asq.asq09
             END IF
         END IF
     ELSE
         SELECT asb02 INTO g_asa02_asq09
           FROM asb_file
          WHERE asb01 = tm.asa01
            AND asb04 = g_asq.asq09
     END IF   

     IF g_cnt_asq10 > 0 THEN   #代表為上層公司
         #判斷是否存在下層
         SELECT COUNT(*) INTO g_low_asq10
           FROM asb_file
          WHERE asb01 = tm.asa01
            AND asb04 = g_asq.asq10
         IF g_low_asq10 > 0 THEN
             #--如果l_up_asq10 = 0 代表是最下層
             SELECT COUNT(*) INTO g_up_asq10
               FROM asa_file 
              WHERE asa01 = tm.asa01
                AND asa02 = g_asq.asq10
            IF g_up_asq10 <> 0 THEN
                SELECT asb02 INTO g_asa02_asq10
                  FROM asb_file
                 WHERE asb01 = tm.asa01
                   AND asb04 = g_asq.asq10
            END IF
         END IF
     ELSE
         SELECT asb02 INTO g_asa02_asq10
           FROM asb_file
          WHERE asb01 = tm.asa01
            AND asb04 = g_asq.asq10
     END IF

     #合併帳別取法： 
     #是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的合併帳別
     #IF 'N' -->則為當下營運中心合併帳別
     #不是上層公司-->判斷是否做獨立合併會科
     #IF 'Y' -->則為目前公司的上層公司的合併帳別
     #IF 'N' -->則為當下營運中心的合併帳別
     
     IF g_cnt_asq09 > 0 THEN   #為上層公司
         SELECT asa09 INTO g_asa09_asq09
           FROM asa_file 
          WHERE asa01 = tm.asa01
            AND asa02 = g_asq.asq09
         SELECT asg03 INTO l_asg03_asq09 
           FROM asg_file 
          WHERE asg01 = g_asq.asq09
         SELECT azp03 INTO g_dbs_asq09 FROM azp_file
          WHERE azp01 = l_asg03_asq09
         IF g_asa09_asq09 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_asq09 = s_dbstring(g_dbs_asq09)
         ELSE
             LET g_dbs_asq09 = s_dbstring(g_dbs)
         END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取asz01
         SELECT asb02 INTO l_asb02
           FROM asb_file 
          WHERE asb01 = tm.asa01
            AND asb04 = g_asq.asq09
         SELECT asa09,asa02 INTO g_asa09_asq09,g_asa02_asq09
           FROM asa_file 
          WHERE asa01 = tm.asa01
            AND asa02 = l_asb02
         SELECT asg03 INTO l_asg03_asq09 
           FROM asg_file 
          WHERE asg01 = l_asb02
         SELECT azp03 INTO g_dbs_asq09 FROM azp_file
          WHERE azp01 = l_asg03_asq09
         IF g_asa09_asq09 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_asq09 = s_dbstring(g_dbs_asq09)
         ELSE
             LET g_dbs_asq09 = s_dbstring(g_dbs)
         END IF
     END IF        
     CALL s_aaz641_asg(tm.asa01,g_asq.asq09) RETURNING g_dbs_asg03
     CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01_asq09
     IF g_cnt_asq10 > 0 THEN   #為上層公司
         SELECT asa09 INTO g_asa09_asq10
           FROM asa_file 
          WHERE asa01 = tm.asa01
            AND asa02 = g_asq.asq10
         SELECT asg03 INTO l_asg03_asq10 
           FROM asg_file 
          WHERE asg01 = g_asq.asq10
         SELECT azp03 INTO g_dbs_asq10 FROM azp_file
          WHERE azp01 = l_asg03_asq10
         IF g_asa09_asq10 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_asq10 = s_dbstring(g_dbs_asq10)
         ELSE
             LET g_dbs_asq10 = s_dbstring(g_dbs)
         END IF
     ELSE    #為下層公司時找自己的媽媽的公司是哪個DB取asz01
         SELECT asb02 INTO l_asb02
           FROM asb_file 
          WHERE asb01 = tm.asa01
            AND asb04 = g_asq.asq10
         SELECT asa09 INTO g_asa09_asq10
           FROM asa_file 
          WHERE asa01 = tm.asa01
            AND asa02 = l_asb02
         SELECT asg03 INTO l_asg03_asq10 
           FROM asg_file 
          WHERE asg01 = l_asb02
         SELECT azp03 INTO g_dbs_asq10 FROM azp_file
          WHERE azp01 = l_asg03_asq10
         IF g_asa09_asq10 = 'Y' THEN     #來源公司合併帳別
             LET g_dbs_asq10 = s_dbstring(g_dbs_asq10)
         ELSE
             LET g_dbs_asq10 = s_dbstring(g_dbs)
         END IF
     END IF        
     CALL s_aaz641_asg(tm.asa01,g_asq.asq10) RETURNING g_dbs_asg03
     CALL s_get_aaz641_asg(g_dbs_asg03) RETURNING g_asz01_asq10

     #取出來源及目的公司各自的記帳幣別供後續沖銷時轉換幣別匯率使用
     SELECT asg06 INTO g_asg06_asq09
       FROM asg_file
      WHERE asg01 = g_asq.asq09   #來源公司記帳幣別
     SELECT asg06 INTO g_asg06_asq10
       FROM asg_file
      WHERE asg01 = g_asq.asq10   #目的公司記帳幣別

     #--#資料來源為asr_file---start----
     IF p_asq15 = '1' THEN        
         LET l_sql =" SELECT 'A','1',asr06,asr07,asr05,asr02,asr04,(asr08-asr09),",
                    "         asr12,'",g_asg08_asq10,"','2','N','' "
         LET l_sql = l_sql CLIPPED,
                    "   FROM asr_file ",
                    "  WHERE asr01 ='",g_asa[i].asa01,"' ",   #群組
                    "     AND asr00 ='",g_asz01_asq09,"' ",  #合併帳別
                    "    AND asr04 ='",g_asq.asq09,"' ",      #來源公司
                    "    AND asr041='",g_asq09_asg05,"' ",    #來源帳別
                    "    AND asr06 = ",tm.yy,                 #年度
                    "    AND asr07 = '",tm.em,"'"             #只抓截止期別的金額
                    #A.來源公司=合併主體：(順流)
                    #  來源:asr02 = 自己(asq09), asr04 = 自己(asq09)
                    #  目的:asr02 = 不用加入此條件, asr04 = 自己(asq10)
                    #B.來源公司 <> 合併主體：(側流或逆流)
                    #  IF 來源屬於上層公司(g_cnt_asq09 > 0)
                    #    1.最上層公司：條件=>asr02 = 自己(asq09), asr04 = 自己(asq09)
                    #    2.中間層(有上層也有下層),
                    #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq09),asr04 = 自己(asq09) 
                    #       b.關係人交易:條件=>asr02 = 自己(asq09),asr04 = 自己(asq09)
                    #  ELSE
                    #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq09)
                    #  END IF
                    #FUN-B50001--luttb--mark--str--
                    #IF g_asq.asq09 = g_asq.asq16 THEN
                    #    IF g_asq.asq14 = 'Y' THEN
                    #        LET l_sql = l_sql CLIPPED,
                    #            "    AND asr02 = '",g_asa02_asq10,"'"
                    #    ELSE
                    #        LET l_sql = l_sql CLIPPED,
                    #        "    AND asr02 = '",g_asq.asq09,"'" 
                    #    END IF
                    #ELSE
                    #    IF g_cnt_asq09 > 0 THEN
                    #        IF g_low_asq09 = 0 THEN #最上層
                    #            LET l_sql = l_sql CLIPPED,
                    #                "    AND asr02 = '",g_asq.asq09,"'" 
                    #        ELSE
                    #            IF g_asq.asq14 = 'Y' THEN
                    #                LET l_sql = l_sql CLIPPED,
                    #                    "    AND asr02 = '",g_asa02_asq09,"'"
                    #            ELSE
                    #                LET l_sql = l_sql CLIPPED,
                    #                    "    AND asr02 = '",g_asq.asq09,"'"
                    #            END IF 
                    #        END IF
                    #    ELSE
                    #        LET l_sql = l_sql CLIPPED,
                    #        "    AND asr02 = '",g_asa02_asq09,"'"
                    #    END IF  
                    #END IF
                    #FUN-B50001--mark--end
#asq15 = '2' 來源科目檔案資料來源:ass_file
     ELSE
         LET l_sql =" SELECT 'A','2',ass08,ass09,ass05,ass02,ass04,(ass10-ass11), ",
                    "        ass14,'",g_asg08_asq10,"','2','N',ass07 ",
                    "   FROM ass_file ",
                    "  WHERE ass01 ='",g_asa[i].asa01,"' ",    #群組
                    "    AND ass00 ='",g_asz01_asq09,"' ",   
                    "    AND ass04 ='",g_asq.asq09,"' ",       #來源公司
                    "    AND ass041='",g_asq09_asg05,"' ",     #來源帳別
                    "    AND ass08 = ",tm.yy,                  #年度
                    "    AND ass07 = '",g_asg08_asq10 ,"'",
                    "    AND ass09 = '",tm.em,"'"           
         #A.來源公司=合併主體：(順流)
         #  來源:asr02 = 自己(asq09), asr04 = 自己(asq09)
         #  目的:asr02 = 不用加入此條件, asr04 = 自己(asq10)
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 來源屬於上層公司(g_cnt_asq09 > 0)
         #    1.最上層公司：條件=>asr02 = 自己(asq09), asr04 = 自己(asq09)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq09),asr04 = 自己(asq09) 
         #       b.關係人交易:條件=>asr02 = 自己(asq09),asr04 = 自己(asq09)
         #  ELSE
         #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq09)
         #  END IF
        #FUN-B50001--mark--str--luttb
        #IF g_asq.asq09 = g_asq.asq16 THEN
        #    IF g_asq.asq14 = 'Y' THEN
        #        LET l_sql = l_sql CLIPPED,
        #        "    AND ass02 = '",g_asa02_asq09,"'"
        #    ELSE
        #        LET l_sql = l_sql CLIPPED,
        #        "    AND ass02 = '",g_asq.asq09,"'" 
        #    END IF
        #ELSE
        #    IF g_cnt_asq09 > 0 THEN
        #         IF g_low_asq09 = 0 THEN #最上層
        #            LET l_sql = l_sql CLIPPED,
        #                "    AND ass02 = '",g_asq.asq09,"'" 
        #        ELSE
        #            IF g_asq.asq14 = 'Y' THEN     
        #                LET l_sql = l_sql CLIPPED,
        #                    "    AND ass02 = '",g_asa02_asq09,"'"
        #            ELSE                         
        #                LET l_sql = l_sql CLIPPED, 
        #                    "    AND ass02 = '",g_asq.asq09,"'"   
        #            END IF                                       
        #        END IF
        #    ELSE
        #         LET l_sql = l_sql CLIPPED,
        #         "    AND ass02 = '",g_asa02_asq09,"'"
        #    END IF  
        #END IF
        #FUN-B50001--mark--end
     END IF

     IF p_asq15 = '1' THEN  #判斷來源檔是否為單一科目或MISC--
         CASE 
           WHEN p_asq01 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND asr05 IN (SELECT DISTINCT ast03 FROM ast_file ",
             "                   WHERE ast00 = '",g_asz01_asq09,"'",   
             "                     AND ast01 = '",g_asq.asq01,"'",
             "                     AND ast09 = '",g_asq.asq09,"'",
             "                     AND ast10 = '",g_asq.asq10,"'",
             "                     AND ast12 = '",g_asz01_asq10,"'",  
             "                     AND ast13 = '",g_asq.asq13,"')" 
           WHEN p_asq01 != 'MISC'
             LET l_sql = l_sql CLIPPED,
             "    AND asr05 = '",g_asq.asq01,"'"
         END CASE
     ELSE   #asq15 = '2'
         CASE WHEN p_asq01 = 'MISC' 
               LET l_sql = l_sql CLIPPED,
               "    AND ass05 IN (SELECT DISTINCT ast03 FROM ast_file ",
               "                   WHERE ast00 = '",g_asz01_asq09,"'",  
               "                     AND ast01 = '",g_asq.asq01,"'",
               "                     AND ast09 = '",g_asq.asq09,"'",
               "                     AND ast10 = '",g_asq.asq10,"'",
               "                     AND ast12 = '",g_asz01_asq10,"'",  
               "                     AND ast13 = '",g_asq.asq13,"')"  
              WHEN p_asq01 != 'MISC'
                LET l_sql = l_sql CLIPPED,
                "    AND ass05 = '",g_asq.asq01,"'"
         END CASE
     END IF

     IF p_asq17 = '1' THEN    #目的檔案資料來源 asq17 = '1'-->asr_file
         LET l_sql = l_sql CLIPPED,   
         "  UNION ",
         " SELECT 'B','1',asr06,asr07,asr05,asr02,asr04,(asr08-asr09)*-1,",
         "        asr12,'",g_asg08,"','1','N','' ",   
         "   FROM asr_file ",
         "  WHERE asr01 ='",g_asa[i].asa01,"' ",
         "    AND asr00 ='",g_asz01_asq10,"' ",               
         "    AND asr04 ='",g_asq.asq10,"' ",                   #對沖公司
         "    AND asr041='",g_asq10_asg05,"' ",                 #對沖帳別  
         "    AND asr06 = ",tm.yy,
         "    AND asr07 = '",tm.em,"'"                         
         CASE 
           WHEN p_asq02 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND asr05 IN (SELECT DISTINCT asu03 FROM asu_file ",
             "                   WHERE asu00 = '",g_asz01_asq09,"'", 
             "                     AND asu01 = '",g_asq.asq02,"'",
             "                     AND asu09 = '",g_asq.asq09,"'",
             "                     AND asu10 = '",g_asq.asq10,"'",
             "                     AND asu12 = '",g_asz01_asq10,"'",  
             "                     AND asu13 = '",g_asq.asq13,"'",  
             "                     AND asu04 != 'Y') "  #是否依據公式設定
           WHEN p_asq02 != 'MISC'
             LET l_sql = l_sql CLIPPED,
             "    AND asr05 = '",g_asq.asq02,"'"
         END CASE

         #A.來源公司=合併主體：(順流)
         #  目的:asr02 = 自己的上層公司(g_asa02_asq10), asr04 = 自己
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 目的屬於上層公司
         #    1.最上層公司：條件=>asr02 = 自己(asq10), asr04 = 自己(asq10)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq10),asr04 = 自己(asq10) 
         #       b.關係人交易:條件=>asr02 = 自己(asq10),asr04 = 自己(asq10)
         #  ELSE
         #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq10)
         #  END IF
        #FUN-B50001--mark-str--
        #IF g_cnt_asq10 > 0 THEN
        #    IF g_low_asq10 = 0 THEN #最上層
        #        LET l_sql = l_sql CLIPPED,
        #            "    AND asr02 = '",g_asq.asq10,"'"
        #    ELSE
        #        IF g_up_asq10 > 0 THEN    #大於0代表不是最下層
        #            IF g_asq.asq14 = 'Y' THEN             
        #                LET l_sql = l_sql CLIPPED,
        #                    "    AND asr02 = '",g_asa02_asq10,"'"
        #            ELSE                                 
        #                LET l_sql = l_sql CLIPPED,      
        #                    "    AND asr02 = '",g_asq.asq10,"'" 
        #            END IF                                      
        #        END IF                
        #    END IF
        #ELSE
        #    LET l_sql = l_sql CLIPPED,
        #    "    AND asr02 = '",g_asa02_asq10,"'"
        #END IF
        #FUN-B50001--mark--end
     ELSE                             #asq17 = '2' -->ass_file        
         LET l_sql = l_sql CLIPPED,       
         "  UNION ",
         " SELECT 'B','2',ass08,ass09,ass05,ass02,ass04,(ass10-ass11)*-1, ",
         "        ass14,'",g_asg08,"','1','N',ass07 ",                  
         "   FROM ass_file ",
         "  WHERE ass01 ='",g_asa[i].asa01,"' ",
         "    AND ass00 ='",g_asz01_asq10,"' ",   
         "    AND ass04 ='",g_asq.asq10,"' ",      #對沖公司
         "    AND ass041='",g_asq10_asg05,"' ",    #對沖帳別  
         "    AND ass08 = ",tm.yy,
         "    AND ass07 = '",g_asg08,"'",         
         "    AND ass09 = '",tm.em,"'"
         CASE 
           WHEN p_asq02 = 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND ass05 IN (SELECT DISTINCT asu03 FROM asu_file ",
             "                   WHERE asu00 = '",g_asz01_asq09,"'",   
             "                     AND asu01 = '",g_asq.asq02,"'",
             "                     AND asu09 = '",g_asq.asq09,"'",
             "                     AND asu10 = '",g_asq.asq10,"'",
             "                     AND asu12 = '",g_asz01_asq10,"'",  
             "                     AND asu13 = '",g_asq.asq13,"'",
             "                     AND asu04 != 'Y') "    #是否依據公式設定
           WHEN p_asq02 != 'MISC' 
             LET l_sql = l_sql CLIPPED,
             "    AND ass05 = '",g_asq.asq02,"'"   
         END CASE
         #A.來源公司=合併主體：(順流)
         #  目的:asr02 = 不用加入此條件, asr04 = 自己
         #B.來源公司 <> 合併主體：(側流或逆流)
         #  IF 目的屬於上層公司
         #    1.最上層公司：條件=>asr02 = 自己(asq10), asr04 = 自己(asq10)
         #    2.中間層(有上層也有下層):
         #       a.股本:條件=> asr02 = 自己的上層公司(l_asa_asq10),asr04 = 自己(asq10) 
         #       b.關係人交易:條件=>asr02 = 自己(asq10),asr04 = 自己(asq10)
         #  ELSE
         #    1.最下層公司: 條件=>asr02 = 不用加入此條件, asr04 = 自己(asq10)
         #  END IF
        #FUN-B50001--mark--str--luttb
        #IF g_cnt_asq10 > 0 THEN
        #    IF g_low_asq10 = 0 THEN #最上層
        #        LET l_sql = l_sql CLIPPED,
        #            "    AND ass02 = '",g_asq.asq10,"'"
        #    ELSE
        #        IF g_up_asq10 > 0 THEN
        #            IF g_asq.asq14 = 'Y' THEN 
        #                LET l_sql = l_sql CLIPPED,
        #                    "    AND ass02 = '",g_asa02_asq10,"'"
        #            ELSE                   
        #                LET l_sql = l_sql CLIPPED,                
        #                    "    AND ass02 = '",g_asq.asq10,"'"  
        #            END IF                                      
        #        END IF   
        #    END IF
        #ELSE
        #    LET l_sql = l_sql CLIPPED,
        #       "    AND ass02 = '",g_asa02_asq10,"'"
        #END IF
        #FUN-B50001--mark--end
     END IF
     PREPARE p007_asr_misc_p1 FROM l_sql
     IF STATUS THEN 
        LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                  
        CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:6',STATUS,1)  
        LET g_success = 'N'  
     END IF 
     DECLARE p007_asr_misc_c1 CURSOR FOR p007_asr_misc_p1
     
     FOREACH p007_asr_misc_c1 INTO g_type,g_flag,g_asr.asr06,g_asr.asr07,g_asr.asr05,
                              g_asr.asr02,g_asr.asr04,g_asr.asr08,
                              g_asr.asr12,
                              g_affil,g_dc,g_flag_r,g_ass07
       IF SQLCA.sqlcode THEN 
          LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy
          CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'p007_asr_misc_1',SQLCA.sqlcode,1) 
          LET g_success = 'N' 
          CONTINUE FOREACH  
       END IF
   
       IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF

       #---FUN-A90026 start--寫入temp table之前先判斷幣別是否同於合併主體
       #不相同時如果為損益類科目且asa05 = '1'要取子公司科餘金額:記帳-->功能-->合併主體幣別)
       SELECT asg06 INTO l_asg06_asq16 
         FROM asg_file
        WHERE asg01 = g_asq.asq16   #合併主體幣別
       IF g_asr.asr12 != l_asg06_asq16 THEN 
           SELECT aag04 INTO l_aag04
            FROM aag_file
            WHERE aag00=g_asz01
              AND aag01=g_asr.asr05
           #依科目性質來判斷取"現時"或"平均"匯率
           IF l_aag04 = '1' THEN   
               CALL p007_getrate('1',tm.yy,tm.em,
                                 g_asr.asr12,l_asg06_asq16)  
               RETURNING l_rate
               LET g_asr.asr08 = g_asr.asr08  * l_rate
           ELSE 
               IF g_asa05 <> '1' THEN
                   CALL p007_getrate('3',tm.yy,tm.em,
                                     g_asr.asr12,l_asg06_asq16)
                   RETURNING l_rate
                   IF cl_null(l_rate) THEN LET l_rate = 1 END IF
                   LET g_asr.asr08 = g_asr.asr08  * l_rate
               ELSE
                   IF g_type = 'A' THEN
                       IF g_cnt_asq09 > 0 THEN
                           CALL p007_ins_ask1_chg1(g_type,g_flag,l_asg06_asq16) RETURNING g_asr.asr08
                       ELSE
                           #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                           #來源或目的/asm_file or asn_file/合併主體幣別
                           CALL p007_ins_ask1_chg(g_type,g_flag,l_asg06_asq16) RETURNING g_asr.asr08
                       END IF
                   ELSE
                       IF g_cnt_asq10 > 0 THEN    #大於0代表不是最下層,資料來源->atcc_file or atc_file  
                           CALL p007_ins_ask1_chg1(g_type,g_flag,l_asg06_asq16) RETURNING g_asr.asr08
                       ELSE
                           #損益科目-取下層公司記帳金額期別計算各月異動額轉換至上層公司合併金額 , 再轉換至合併個體金額
                           #來源或目的/asm_file or asn_file/合併主體幣別
                           CALL p007_ins_ask1_chg(g_type,g_flag,l_asg06_asq16) RETURNING g_asr.asr08
                       END IF
                   END IF
               END IF
           END IF
       END IF

       #先將資料寫進TempTable裡 
       EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,g_asr.asr05,
                                 g_asr.asr02,g_asr.asr04,g_asr.asr08,
                                 g_asr.asr12,
                                 g_affil,g_dc,g_flag_r
     END FOREACH

     IF p_asq02 = 'MISC' THEN
         IF p_asq17 = '1' THEN
             #貸 子公司 少數股權,少數股權淨利
             #依據公式設定(對沖科目中asu04=Y)
             DECLARE p007_asu_cs CURSOR FOR
                SELECT DISTINCT asu03,asu04,asu05 FROM asu_file
                 WHERE asu00 = g_asz01_asq09
                   AND asu01 = g_asq.asq02
                   AND asu09 = g_asq.asq09
                   AND asu10 = g_asq.asq10
                   AND asu12 =  g_asz01_asq10
                   AND asu04 = 'Y'             #是否依據公式設定]
                   AND asu13 = g_asq.asq13
             FOREACH p007_asu_cs INTO g_asv03
                      LET l_sql =
                      " SELECT asr06,asr07,asr05,asr02,asr04,(asr08-asr09),",
                      "        asr12,'",g_asg08_asq10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,
                   "   FROM asr_file ",
                   "  WHERE asr01 ='",g_asa[i].asa01,"' ",
                   "    AND asr00 ='",g_asz01_asq10,"' ",
                   "    AND asr04 ='",g_asq.asq10,"' ",   #對沖公司
                   "    AND asr041='",g_asq10_asg05,"' ", #對沖帳別
                   "    AND asr06 = ",tm.yy,
                   "    AND asr07 = '",tm.em,"'"
                       IF g_cnt_asq10 > 0 THEN
                           IF g_low_asq10 = 0 THEN #最上層
                               LET l_sql = l_sql CLIPPED,
                                   "    AND asr02 = '",g_asq.asq10,"'"
                           ELSE
                               IF g_up_asq10 > 0 THEN
                                   LET l_sql = l_sql CLIPPED,
                                       "    AND asr02 = '",g_asa02_asq10,"'"
                               END IF
                          END IF
                       ELSE
                           LET l_sql = l_sql CLIPPED,
                           "    AND asr02 = '",g_asa02_asq10,"'"
                       END IF
                   LET l_sql = l_sql CLIPPED,
                           "  UNION ",
                           " SELECT asr06,asr07,asr05,asr02,asr04,(asr13-asr14)*-1,",
                           "        '",g_asg06_asq10,"','",g_asg08_asq10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,    
                   "   FROM asr_file ",
                   "  WHERE asr01 ='",g_asa[i].asa01,"' ",
                   "    AND asr00 ='",g_asz01_asq10,"' ",
                   "    AND asr04 ='",g_asq.asq10,"' ",   #對沖公司
                   "    AND asr041='",g_asq10_asg05,"' ", #對沖帳別
                   "    AND asr06 = ",tm.yy,
                   "    AND asr07 = '",tm.em,"'",
                   "    AND asr05 IN (SELECT DISTINCT asv04 FROM asv_file ",
                   "                   WHERE asv00 = '",g_asz01_asq09,"'",
                   "                     AND asv01 = '",g_asq.asq02,"'",
                   "                     AND asv09 = '",g_asq.asq09,"'",
                   "                     AND asv10 = '",g_asq.asq10,"'",
                   "                     AND asv12 = '",g_asz01_asq10,"'",
                   "                     AND asv13 = '",g_asq.asq13,"'",
                   "                     AND asv05 = '-'",
                   "                     AND asv03 = '",g_asv03,"')"
                   #FUN-B50001--mark--str--
                   #   IF g_cnt_asq10 > 0 THEN
                   #       IF g_low_asq10 = 0 THEN #最上層
                   #           LET l_sql = l_sql CLIPPED,
                   #               "    AND asr02 = '",g_asq.asq10,"'" ,
                   #               "   ORDER BY asr06,asr07,asr05,asr02,asr04 "
                   #       ELSE
                   #           IF g_up_asq10 > 0 THEN
                   #               LET l_sql = l_sql CLIPPED,
                   #                   " AND asr02 = '",g_asa02_asq10,"'",
                   #                   " ORDER BY asr06,asr07,asr05,asr02,asr04 "
                   #           END IF
                   #      END IF
                   #   ELSE
                   #       LET l_sql = l_sql CLIPPED,
                   #       "    AND asr02 = '",g_asa02_asq10,"'",
                   #       "   ORDER BY asr06,asr07,asr05,asr02,asr04 "
                   #   END IF
                   #FUN-B50001--mark--end
                   PREPARE p007_misc_p2 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy
                      CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF
                   DECLARE p007_misc_c2 CURSOR FOR p007_misc_p2
                   FOREACH p007_misc_c2 INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
                                             g_asr.asr02,g_asr.asr04,g_asr.asr08,
                                             g_asr.asr12,
                                             g_affil,g_dc,g_flag_r
                      IF SQLCA.sqlcode THEN 
                         LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy
                         CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'p007_misc_c2',SQLCA.sqlcode,1)
                         LET g_success = 'N' 
                         CONTINUE FOREACH  
                      END IF
 
                      IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF
 
                      #先將資料寫進TempTable裡 
                      EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,g_asv03,
                                                g_asr.asr02,g_asr.asr04,g_asr.asr08,
                                                g_asr.asr12,
                                                g_affil,g_dc,g_flag_r
                   END FOREACH
                   #----------------FUN-B70065 start-------------
                   #依對沖設定中有勾選依公式設定之科目，如有累換數科目
                   #取出調整沖銷分錄中屬於累換數科目的借貸方，相減
                   LET l_sql =
                   " SELECT SUM(ask07) FROM asj_file,ask_file ",
                   "  WHERE asj01=ask01 ",
                   "    AND asj03 = '",tm.yy,"'",
                   "    AND asj04 = '",tm.em,"'",
                   "    AND ask06 = '1' ",
                   "    AND asj05 ='",g_asa[i].asa01,"' ", 
                   "    AND asj06 ='",g_asq.asq16,"'",     #合併主體
                   "    AND asj00 ='",g_asz01,"'",
                   "    AND asj00 =ask00 ",
                   "    AND asjconf ='Y' ",
                   "    AND asj09 = 'Y' ",
                   "    AND asj08 = '2' ",
                   "    AND ask03 = '",g_aaz87,"'", 
                   "    AND ask05 = '",g_asg08_asq10,"'",     #關係人
                   "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                   "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                   "                     AND asv01 = '",g_asq.asq02,"'",
                   "                     AND asv09 = '",g_asq.asq09,"'",
                   "                     AND asv10 = '",g_asq.asq10,"'",
                   "                     AND asv12 = '",g_asz01_asq10,"'",
                   "                     AND asv13 = '",g_asq.asq13,"'",
                   "                     AND asv05 = '+'",
                   "                     AND asv03 = '",g_asv03,"')",
                   "  UNION ",
                   " SELECT SUM(ask07) FROM asj_file,ask_file ",
                   "  WHERE asj01=ask01 ",
                   "    AND asj03 = '",tm.yy,"'",
                   "    AND asj04 = '",tm.em,"'",
                   "    AND ask06 = '1' ",
                   "    AND asj05 ='",g_asa[i].asa01,"' ", 
                   "    AND asj06 ='",tm.asa02,"'",
                   "    AND asj00 ='",g_asz01,"'",
                   "    AND asj00 =ask00 ",
                   "    AND asjconf ='Y' ",
                   "    AND asj09 ='Y' ",
                   "    AND asj08 ='2' ",
                   "    AND ask03 = '",g_aaz87,"'", 
                   "    AND ask05 = '",g_asg08_asq10,"'",     #關係人
                   "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                   "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                   "                     AND asv01 = '",g_asq.asq02,"'",
                   "                     AND asv09 = '",g_asq.asq09,"'",
                   "                     AND asv10 = '",g_asq.asq10,"'",
                   "                     AND asv12 = '",g_asz01_asq10,"'",
                   "                     AND asv13 = '",g_asq.asq13,"'",
                   "                     AND asv05 = '-'",
                   "                     AND asv03 = '",g_asv03,"')"

                   PREPARE p001_misc_aaz87_p1 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                    #NO.FUN-710023
                      CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                   DECLARE p001_misc_aaz87_c1 CURSOR FOR p001_misc_aaz87_p1
                   OPEN p001_misc_aaz87_c1
                   FETCH p001_misc_aaz87_c1 INTO l_ask07_d
                   IF cl_null(l_ask07_d) THEN LET l_ask07_d = 0 END IF

                   LET l_sql =
                   " SELECT SUM(ask07) FROM asj_file,ask_file ",
                   "  WHERE asj01=ask01 ",
                   "    AND asj03 = '",tm.yy,"'",
                   "    AND asj04 = '",tm.em,"'",
                   "    AND ask06 = '2' ",
                   "    AND asj05 ='",g_asa[i].asa01,"' ", 
                   "    AND asj06 ='",g_asq.asq16,"'",     #合併主體
                   "    AND asj00 ='",g_asz01,"'",
                   "    AND asj00 =ask00 ",
                   "    AND asjconf ='Y' ",
                   "    AND asj09 ='Y' ",
                   "    AND asj08 ='2' ",
                   "    AND ask03 ='",g_aaz87,"'", 
                   "    AND ask05 ='",g_asg08_asq10,"'",     #關係人
                   "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                   "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                   "                     AND asv01 = '",g_asq.asq02,"'",
                   "                     AND asv09 = '",g_asq.asq09,"'",
                   "                     AND asv10 = '",g_asq.asq10,"'",
                   "                     AND asv12 = '",g_asz01_asq10,"'",
                   "                     AND asv13 = '",g_asq.asq13,"'",
                   "                     AND asv05 = '+'",
                   "                     AND asv03 = '",g_asv03,"')",
                   "  UNION ",
                   " SELECT SUM(ask07) FROM asj_file,ask_file ",
                   "  WHERE asj01=ask01 ",
                   "    AND asj03 = '",tm.yy,"'",
                   "    AND asj04 = '",tm.em,"'",
                   "    AND ask06 = '2' ",
                   "    AND asj05 ='",g_asa[i].asa01,"' ", 
                   "    AND asj06 ='",g_asq.asq16,"'",     #合併主體
                   "    AND asj00 ='",g_asz01,"'",
                   "    AND asj00 =ask00 ",
                   "    AND asjconf ='Y' ",
                   "    AND asj09 ='Y' ",
                   "    AND asj08 ='2' ",
                   "    AND ask03 ='",g_aaz87,"'", 
                   "    AND ask05 ='",g_asg08_asq10,"'",     #關係人
                   "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                   "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                   "                     AND asv01 = '",g_asq.asq02,"'",
                   "                     AND asv09 = '",g_asq.asq09,"'",
                   "                     AND asv10 = '",g_asq.asq10,"'",
                   "                     AND asv12 = '",g_asz01_asq10,"'",
                   "                     AND asv13 = '",g_asq.asq13,"'",
                   "                     AND asv05 = '-'",
                   "                     AND asv03 = '",g_asv03,"')"
                   PREPARE p001_misc_aaz87_p2 FROM l_sql
                   IF STATUS THEN 
                      LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                    #NO.FUN-710023
                      CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                   DECLARE p001_misc_aaz87_c2 CURSOR FOR p001_misc_aaz87_p2
                   OPEN p001_misc_aaz87_c2
                   FETCH p001_misc_aaz87_c2 INTO l_ask07_c
                   IF cl_null(l_ask07_c) THEN LET l_ask07_c = 0 END IF

                   LET l_ask07 = l_ask07_d - l_ask07_c

                   IF l_ask07 <> 0 THEN
                      #先將資料寫進TempTable裡 
                      EXECUTE insert_prep USING tm.yy,tm.em,g_asv03,  
                                                g_asq.asq16,g_asg08_asq10,l_ask07,
                                                x_aaa03,
                                                g_asg08_asq10,'2','Y'
                   END IF
                   #---FUN-B70065 end-----------------------
              END FOREACH
             IF g_asq.asq14 = 'Y' THEN 
                 #換匯差額的累換數是否加入沖銷分錄需依對沖設定
                 DECLARE p007_asu_cs2 CURSOR FOR
                    SELECT DISTINCT asu03 FROM asu_file
                     WHERE asu00 = g_asz01_asq09
                       AND asu01 = g_asq.asq02
                       AND asu09 = g_asq.asq09
                       AND asu10 = g_asq.asq10
                       AND asu12 = g_asz01_asq10
                       AND asu13 = g_asq.asq13
                 FOREACH p007_asu_cs2 INTO l_asu03
                     DECLARE p007_adj_cs CURSOR FOR
                      SELECT ask03,ask05,ask06,(ask07-ask071) FROM p007_adj_tmp
                           WHERE ask05 = g_asg08_asq10
                             AND ask03 = l_asu03

                      FOREACH p007_adj_cs INTO l_ask03,l_ask05,l_ask06,g_asr.asr08

                        IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF

                        LET g_affil  = l_ask05
                        LET g_flag_r = 'N'
                            #借貸需與換匯差額的累換相反加入對沖分錄 
                            IF g_asr.asr08 < 0 THEN
                                IF l_ask06 = '1' THEN LET g_dc = '1' ELSE LET g_dc = '2' END IF
                            ELSE
                                IF l_ask06 = '1' THEN LET g_dc = '2' ELSE LET g_dc = '1' END IF
                            END IF
                        #先將資料進TempTable
                        EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,l_ask03,
                                                  g_asr.asr02,g_asr.asr04,g_asr.asr08,
                                                  g_asr.asr12,
                                                  g_affil,g_dc,g_flag_r
                      END FOREACH
                  END FOREACH
              END IF                 
             #取出換匯差額的累換數值
          ELSE
              #貸 子公司 少數股權,少數股權淨利
              #依據公式設定(對沖科目中asu04=Y)
              DECLARE p007_asu_cs1 CURSOR FOR
                 SELECT DISTINCT asu03,asu04,asu05 FROM asu_file 
                  WHERE asu00 = g_asz01_asq09
                    AND asu01 = g_asq.asq02
                    AND asu09 = g_asq.asq09
                    AND asu10 = g_asq.asq10
                    AND asu12 = g_asz01_asq10
                    AND asu04 = 'Y'             #是否依據公式設定]
                    AND asu13 = g_asq.asq13
              FOREACH p007_asu_cs1 INTO g_asv03
                       LET l_sql =
                       " SELECT ass08,ass09,ass05,ass02,ass04,(ass10-ass11),",  
                       "        ass14,'",g_asq.asq10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,
                   "   FROM ass_file ",
                   "  WHERE ass01 ='",g_asa[i].asa01,"' ",
                   "    AND ass00 ='",g_asz01_asq10,"' ",
                   "    AND ass04 ='",g_asq.asq10,"' ",   #對沖公司
                   "    AND ass041='",g_asq10_asg05,"' ", #對沖帳別
                   "    AND ass07 = '",g_asg08,"'",
                   "    AND ass08 = ",tm.yy,
                   "    AND ass09 = '",tm.em,"'"
                   #FUN-B50001--mark--str--
                   #   IF g_cnt_asq10 > 0 THEN
                   #       IF g_low_asq10 = 0 THEN #最上層 
                   #           LET l_sql = l_sql CLIPPED,
                   #               "    AND ass02 = '",g_asq.asq10,"'"
                   #       ELSE
                   #           IF g_up_asq10 > 0 THEN
                   #               LET l_sql = l_sql CLIPPED,
                   #                   "    AND ass02 = '",g_asa02_asq10,"'"
                   #           END IF
                   #       END IF
                   #   ELSE
                   #       LET l_sql = l_sql CLIPPED,
                   #       "    AND ass02 = '",g_asa02_asq10,"'"
                   #   END IF
                   #FUN-B50001--mark--end
                   LET l_sql = l_sql CLIPPED,
                   "    AND ass05 IN (SELECT DISTINCT asv04 FROM asv_file ",
                   "                   WHERE asv00 = '",g_asz01_asq09,"'",
                   "                     AND asv01 = '",g_asq.asq02,"'",
                   "                     AND asv09 = '",g_asq.asq09,"'",
                   "                     AND asv10 = '",g_asq.asq10,"'",
                   "                     AND asv12 = '",g_asz01_asq10,"'",
                   "                     AND asv13 = '",g_asq.asq13,"'",　
                   "                     AND asv05 = '+'",
                   "                     AND asv03 = '",g_asv03,"')"
                       LET l_sql = l_sql CLIPPED,
                       "  UNION ",
                       " SELECT ass08,ass09,ass05,ass02,ass04,(ass08-ass09)*-1,",
                       "        ass14,'",g_asg08_asq10,"','2','Y' "
                   LET l_sql = l_sql CLIPPED,
                   "   FROM ass_file ",
                   "  WHERE ass01 ='",g_asa[i].asa01,"' ",
                   "    AND ass00 ='",g_asz01_asq10,"' ",
                   "    AND ass04 ='",g_asq.asq10,"' ",   #對沖公司
                   "    AND ass041='",g_asq10_asg05,"' ", #對沖帳別
                   "    AND ass08 = ",tm.yy,
                   "    AND ass07 = '",g_asg08,"'",
                   "    AND ass09 = '",tm.em,"'",
                   "    AND ass05 IN (SELECT DISTINCT asv04 FROM asv_file ",
                   "                   WHERE asv00 = '",g_asz01_asq09,"'",
                   "                     AND asv01 = '",g_asq.asq02,"'",
                   "                     AND asv09 = '",g_asq.asq09,"'",
                   "                     AND asv10 = '",g_asq.asq10,"'",
                   "                     AND asv12 = '",g_asz01_asq10,"'",
                   "                     AND asv13 = '",g_asq.asq13,"'",
                   "                     AND asv05 = '-'",
                   "                     AND asv03 = '",g_asv03,"')"
                   #FUN-B50001--mark--str--luttb
                   #   IF g_cnt_asq10 > 0 THEN
                   #       IF g_low_asq10 = 0 THEN #最上層
                   #           LET l_sql = l_sql CLIPPED,
                   #               "    AND ass02 = '",g_asq.asq10,"'" ,
                   #               "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
                   #       ELSE
                   #           IF g_up_asq10 > 0 THEN
                   #               LET l_sql = l_sql CLIPPED,
                   #                   "    AND ass02 = '",g_asa02_asq10,"'",
                   #                   "  ORDER BY ass08,ass09,ass05,ass02,ass04 "
                   #           END IF
                   #       END IF
                   #   ELSE
                   #       LET l_sql = l_sql CLIPPED,
                   #       "    AND ass02 = '",g_asa02_asq10,"'"
                   #   END IF
                   #FUN-B50001--mark--end

                  PREPARE p007_misc_p3 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy
                     CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF
                  DECLARE p007_misc_c3 CURSOR FOR p007_misc_p3
     
                  FOREACH p007_misc_c3 INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
                                            g_asr.asr02,g_asr.asr04,g_asr.asr08,
                                            g_asr.asr12,
                                            g_affil,g_dc,g_flag_r
                     IF SQLCA.sqlcode THEN 
                        LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy
                        CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'p007_misc_c3',SQLCA.sqlcode,1)
                        LET g_success = 'N' 
                        CONTINUE FOREACH  
                     END IF

                     IF g_asr.asr08=0 THEN CONTINUE FOREACH END IF

                     #先將資料寫進TempTable裡 
                     EXECUTE insert_prep USING g_asr.asr06,g_asr.asr07,g_asv03,
                                               g_asr.asr02,g_asr.asr04,g_asr.asr08,
                                               g_asr.asr12,
                                               g_affil,g_dc,g_flag_r
                  END FOREACH

                  #----------------FUN-B70065 start-------------
                  #依對沖設定中有勾選依公式設定之科目，如有累換數科目
                  #取出調整沖銷分錄中屬於累換數科目的借貸方，相減
                  LET l_sql =
                  " SELECT SUM(ask07) FROM asj_file,ask_file ",
                  "  WHERE asj01=ask01 ",
                  "    AND asj03 = '",tm.yy,"'",
                  "    AND asj04 = '",tm.em,"'",
                  "    AND ask06 = '1' ",
                  "    AND asj05 ='",g_asa[i].asa01,"' ", 
                  "    AND asj06 ='",g_asq.asq16,"'",     #合併主體
                  "    AND asj00 ='",g_asz01,"'",
                  "    AND asj00 =ask00 ",
                  "    AND asjconf ='Y' ",
                  "    AND asj09 = 'Y' ",
                  "    AND asj08 = '2' ",
                  "    AND ask03 = '",g_aaz87,"'", 
                  "    AND ask05 = '",g_asg08_asq10,"'",     #關係人
                  "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                  "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                  "                     AND asv01 = '",g_asq.asq02,"'",
                  "                     AND asv09 = '",g_asq.asq09,"'",
                  "                     AND asv10 = '",g_asq.asq10,"'",
                  "                     AND asv12 = '",g_asz01_asq10,"'",
                  "                     AND asv13 = '",g_asq.asq13,"'",
                  "                     AND asv05 = '+'",
                  "                     AND asv03 = '",g_asv03,"')",
                  "  UNION ",
                  " SELECT SUM(ask07) FROM asj_file,ask_file ",
                  "  WHERE asj01=ask01 ",
                  "    AND asj03 = '",tm.yy,"'",
                  "    AND asj04 = '",tm.em,"'",
                  "    AND ask06 = '1' ",
                  "    AND asj05 ='",g_asa[i].asa01,"' ", 
                  "    AND asj06 ='",tm.asa02,"'",
                  "    AND asj00 ='",g_asz01,"'",
                  "    AND asj00 =ask00 ",
                  "    AND asjconf ='Y' ",
                  "    AND asj09 ='Y' ",
                  "    AND asj08 ='2' ",
                  "    AND ask03 = '",g_aaz87,"'", 
                  "    AND ask05 = '",g_asg08_asq10,"'",     #關係人
                  "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                  "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                  "                     AND asv01 = '",g_asq.asq02,"'",
                  "                     AND asv09 = '",g_asq.asq09,"'",
                  "                     AND asv10 = '",g_asq.asq10,"'",
                  "                     AND asv12 = '",g_asz01_asq10,"'",
                  "                     AND asv13 = '",g_asq.asq13,"'",
                  "                     AND asv05 = '-'",
                  "                     AND asv03 = '",g_asv03,"')"

                  PREPARE p001_misc_aaz87_p3 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                    #NO.FUN-710023
                     CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                  DECLARE p001_misc_aaz87_c3 CURSOR FOR p001_misc_aaz87_p3
                  OPEN p001_misc_aaz87_c3
                  FETCH p001_misc_aaz87_c3 INTO l_ask07_d
                  IF cl_null(l_ask07_d) THEN LET l_ask07_d = 0 END IF

                  LET l_sql =
                  " SELECT SUM(ask07) FROM asj_file,ask_file ",
                  "  WHERE asj01=ask01 ",
                  "    AND asj03 = '",tm.yy,"'",
                  "    AND asj04 = '",tm.em,"'",
                  "    AND ask06 = '2' ",
                  "    AND asj05 ='",g_asa[i].asa01,"' ", 
                  "    AND asj06 ='",g_asq.asq16,"'",     #合併主體
                  "    AND asj00 ='",g_asz01,"'",
                  "    AND asj00 =ask00 ",
                  "    AND asjconf ='Y' ",
                  "    AND asj09 ='Y' ",
                  "    AND asj08 ='2' ",
                  "    AND ask03 ='",g_aaz87,"'", 
                  "    AND ask05 ='",g_asg08_asq10,"'",     #關係人
                  "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                  "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                  "                     AND asv01 = '",g_asq.asq02,"'",
                  "                     AND asv09 = '",g_asq.asq09,"'",
                  "                     AND asv10 = '",g_asq.asq10,"'",
                  "                     AND asv12 = '",g_asz01_asq10,"'",
                  "                     AND asv13 = '",g_asq.asq13,"'",
                  "                     AND asv05 = '+'",
                  "                     AND asv03 = '",g_asv03,"')",
                  "  UNION ",
                  " SELECT SUM(ask07) FROM asj_file,ask_file ",
                  "  WHERE asj01=ask01 ",
                  "    AND asj03 = '",tm.yy,"'",
                  "    AND asj04 = '",tm.em,"'",
                  "    AND ask06 = '2' ",
                  "    AND asj05 ='",g_asa[i].asa01,"' ", 
                  "    AND asj06 ='",g_asq.asq16,"'",     #合併主體
                  "    AND asj00 ='",g_asz01,"'",
                  "    AND asj00 =ask00 ",
                  "    AND asjconf ='Y' ",
                  "    AND asj09 ='Y' ",
                  "    AND asj08 ='2' ",
                  "    AND ask03 ='",g_aaz87,"'", 
                  "    AND ask05 ='",g_asg08_asq10,"'",     #關係人
                  "    AND ask03 IN (SELECT DISTINCT asv04 FROM asv_file ",
                  "                   WHERE asv00 = '",g_asz01_asq09,"'", 
                  "                     AND asv01 = '",g_asq.asq02,"'",
                  "                     AND asv09 = '",g_asq.asq09,"'",
                  "                     AND asv10 = '",g_asq.asq10,"'",
                  "                     AND asv12 = '",g_asz01_asq10,"'",
                  "                     AND asv13 = '",g_asq.asq13,"'",
                  "                     AND asv05 = '-'",
                  "                     AND asv03 = '",g_asv03,"')"
                  PREPARE p001_misc_aaz87_p4 FROM l_sql
                  IF STATUS THEN 
                     LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy                                    #NO.FUN-710023
                     CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'prepare:7',STATUS,1)  LET g_success = 'N' END IF  #NO.FUN-710023
                  DECLARE p001_misc_aaz87_c4 CURSOR FOR p001_misc_aaz87_p4
                  OPEN p001_misc_aaz87_c4
                  FETCH p001_misc_aaz87_c4 INTO l_ask07_c
                  IF cl_null(l_ask07_c) THEN LET l_ask07_c = 0 END IF

                  LET l_ask07 = l_ask07_d - l_ask07_c

                  IF l_ask07 <> 0 THEN
                     #先將資料寫進TempTable裡 
                     EXECUTE insert_prep USING tm.yy,tm.em,g_asv03,  
                                               g_asq.asq16,g_asg08_asq10,l_ask07,
                                               x_aaa03,
                                               g_asg08_asq10,'2','Y'
                  END IF
                  #---FUN-B70065 end-----------------------
             END FOREACH 
         END IF          
     END IF    

     DECLARE p007_tmp_cs CURSOR FOR
        SELECT asr06,asr07,asr05,asr02,asr04,SUM(asr08),asr12,affil,dc,flag_r
          FROM p007_tmp
         GROUP BY asr06,asr07,asr05,asr02,asr04,asr12,affil,dc,flag_r
         ORDER BY asr06,asr07,asr05,asr02,asr04,asr12,affil,dc,flag_r
                 #年    月
     LET g_asr07_o = '' 
     FOREACH p007_tmp_cs INTO g_asr.asr06,g_asr.asr07,g_asr.asr05,
                              g_asr.asr02,g_asr.asr04,g_asr.asr08,
                              g_asr.asr12,
                              g_affil,g_dc,g_flag_r
        IF SQLCA.sqlcode THEN 
           LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa01,"/",g_asa[i].asa01,"/",tm.yy
           CALL s_errmsg('ass01,ass04,ass041,ass08',g_showmsg,'p007_tmp_cs',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CONTINUE FOREACH 
        END IF

        CALL s_ymtodate(g_asr.asr06,g_asr.asr07,g_asr.asr06,g_asr.asr07)
               RETURNING g_bdate,g_edate

        IF NOT cl_null(g_asr07_o) AND g_asr07_o<>g_asr.asr07 AND 
           NOT cl_null(g_asj.asj01) THEN
           CALL p007_ins_ask2()   #寫入差異分錄
           IF NOT cl_null(g_asj.asj01) THEN CALL upd_asj() END IF
        END IF

        #--a抓持股比率
        CALL get_rate()  
        
        #FUN-B50001 add--str--luttb
        SELECT asq03 INTO l_asq03
          FROM asq_file
         WHERE asq02 = g_asr.asr05
           AND asq13 = g_asq.asq13
           AND asq16 = g_asq.asq16
           AND asq00 = g_asq.asq00
           AND asq01 = g_asq.asq01
           AND asq02 = g_asq.asq02
           AND asq09 = g_asq.asq09
           AND asq10 = g_asq.asq10
           AND asq12 = g_asq.asq12
        IF cl_null(l_asq03) THEN
           SELECT asu05 INTO l_asq03
            FROM  asu_file,asq_file
           WHERE asu03 = g_asr.asr05
             AND asu00 = g_asq.asq00
             AND asu09 = g_asq.asq09
             AND asu10 = g_asq.asq10
             AND asu12 = g_asq.asq12
             AND asu13 = g_asq.asq13
             AND asu01 = g_asq.asq02
             AND asu00 = asq00
             AND asu09 = asq09
             AND asu10 = asq10
             AND asu12 = asq12
             AND asu13 = asq13
             AND asu01 = asq02
        END IF
        IF l_asq03 = 'Y' THEN
           LET g_asr.asr08 = g_asr.asr08 * g_rate
        END IF
        #FUN-B50001--add--end

        LET l_cnt = 0
        
        SELECT COUNT(*) INTO l_cnt FROM asj_file  #判斷是否已存在單頭
         WHERE asj00 = g_asz01      #帳別
           AND asj02 = g_edate       #單據日期
           AND asj03 = g_asr.asr06   #調整年度
           AND asj04 = g_asr.asr07   #調整月份
           AND asj05 = tm.asa01      #族群編號
           AND asj06 = g_asq.asq16   #合併主體公司編號
           AND asj07 = tm.asa03      #上層帳別
           AND asj08 = '2'           #資料來源-2.資料匯入
           AND asj21 = tm.ver    
           AND asjconf <> 'X'  #CHI-C80041    
           #AND asj081 = '1'
           AND asj081 = '7'
           AND asj09 = 'N'
        IF l_cnt = 0 THEN     #沒有符合的資料才要新增
           LET g_yy=g_asr.asr06 
           LET g_mm=g_asr.asr07 
           CALL p007_ins_asj() 
        ELSE                  #取出單頭資料以供後續寫入ask時用
           SELECT * INTO g_asj.* FROM asj_file
            WHERE asj00 = g_asz01
              AND asj02 = g_edate
              AND asj03 = g_asr.asr06
              AND asj04 = g_asr.asr07
              AND asj05 = tm.asa01
              AND asj06 = g_asq.asq16
              AND asj07 = tm.asa03
              AND asj08 = '2'
              AND asjconf <> 'X'  #CHI-C80041 
              #AND asj081 = '1'
              AND asj081 = '7'
              AND asj21 = tm.ver
              AND asj09 = 'N'
        END IF
        
        #-->寫入調整與銷除分錄底稿單身
        IF NOT cl_null(g_asj.asj01) THEN    #當單頭檔(asj_file)的傳票號碼(asj01)有值石才需計算差異
           CALL p007_ins_ask1()
        END IF
        IF g_success = 'N' THEN RETURN  END IF
        LET g_asr07_o=g_asr.asr07   #期別舊值備份
     END FOREACH

     #當單頭檔(asj_file)的傳票號碼(asj01)有值時才需計算差異
     IF NOT cl_null(g_asj.asj01) THEN    
        CALL p007_ins_ask2()   #寫入差異分錄
     END IF
     IF NOT cl_null(g_asj.asj01) THEN CALL upd_asj() END IF
     LET p_asq01 = ''
     LET p_asq02 = ''
END FUNCTION

FUNCTION p007_getrate(l_value,l_ase01,l_ase02,l_ase03,l_ase04)
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

FUNCTION p007_ins_ask1_chg1(p_type,p_flag,p_asg06)
DEFINE p_asg06     LIKE asg_file.asg06
DEFINE p_asr12     LIKE asr_file.asr12
DEFINE l_asr08     LIKE asr_file.asr08
DEFINE l_asr09     LIKE asr_file.asr09
DEFINE l_asr08_b   LIKE asr_file.asr08
DEFINE l_asr09_b   LIKE asr_file.asr09
DEFINE l_tot_amt   LIKE asr_file.asr08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_asr12     LIKE asr_file.asr12   
DEFINE l_r         LIKE ase_file.ase05   
DEFINE l_r1        LIKE ase_file.ase05   
DEFINE p_flag      LIKE type_file.chr1   
DEFINE p_type      LIKE type_file.chr1   
DEFINE l_asg07     LIKE asq_file.asq09   
DEFINE l_month     LIKE type_file.num5
DEFINE l_amt2      LIKE atc_file.atc08
DEFINE l_amt1      LIKE atc_file.atc08
DEFINE l_amt       LIKE atc_file.atc08

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)

     LET l_tot_amt = 0
     LET l_amt2 = 0
     LET l_amt1 = 0
     LET l_amt  = 0

     SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_asg06
     IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為atcc_file or atc_file取各期餘額
     LET l_sql=
     " SELECT atc07,atc12",
     "   FROM atc_file ",
     "  WHERE atc00 = '",g_asz01,"'",          #合併帳別  
     "    AND atc01 = '",tm.asa01,"'", #族群
     "    AND atc02 = '",g_asr.asr02,"'", #公司
     "    AND atc05 = '",g_asr.asr05,"'",
     "    AND atc06= '",tm.yy,"'",
     "    AND atc07 BETWEEN '",tm.bm,"' AND '",tm.em,"'"
     PREPARE p007_atc_p3 FROM l_sql
     DECLARE p007_atc_c3 CURSOR FOR p007_atc_p3
     FOREACH p007_atc_c3 INTO l_month,l_asr12
        IF l_month = 0 THEN CONTINUE FOREACH END IF
        SELECT asg07 INTO l_asg07 FROM asg_file WHERE asg01 = g_asr.asr02
        CASE 
           WHEN p_flag = '1'        #atc_file
               SELECT SUM(atc08-atc09) INTO l_amt2
                 FROM atc_file 
                WHERE atc00 = g_asz01        #合併帳別 
                  AND atc01 = tm.asa01        #族群
                  AND atc02 = g_asr.asr02     #公司
                  AND atc05 = g_asr.asr05
                  AND atc06 = tm.yy
                  AND atc07 = l_month
           WHEN p_flag = '2'        #atcc_file
               SELECT SUM(atcc10-atcc11) INTO l_amt2
                 FROM atcc_file
                WHERE atcc00 = g_asz01
                  AND atcc01 = tm.asa01
                  AND atcc02 = g_asr.asr02
                  AND atcc05 = g_asr.asr05
                  AND atcc07 = g_ass07
                  AND atcc08 = tm.yy
                  AND atcc09 = l_month
        END CASE
        CASE 
           WHEN p_flag = '1'        #atc_file
               SELECT SUM(atc08-atc09) INTO l_amt1
                 FROM atc_file
                WHERE atc00 = g_asz01        #合併帳別 
                  AND atc01 = tm.asa01        #族群
                  AND atc02 = g_asr.asr02     #公司
                  AND atc05 = g_asr.asr05
                  AND atc06 = tm.yy
                  AND atc07 = (SELECT MAX(atc07) FROM atc_file
                                WHERE atc00 = g_asz01        #合併帳別 
                                  AND atc01 = tm.asa01        #族群
                                  AND atc02 = g_asr.asr02     #公司
                                  AND atc05 = g_asr.asr05
                                  AND atc06 = tm.yy
                                  AND atc07 < l_month)
           WHEN p_flag = '2'        #atcc_file
               SELECT SUM(atcc10-atcc11) INTO l_amt1
                 FROM atcc_file
                WHERE atcc00 = g_asz01
                  AND atcc01 = tm.asa01
                  AND atcc02 = g_asr.asr02
                  AND atcc05 = g_asr.asr05
                  AND atcc07 = g_ass07
                  AND atcc08 = tm.yy
                  AND atcc09 = (SELECT MAX(atcc09) FROM atcc_file
                                 WHERE atcc00 = g_asz01
                                   AND atcc01 = tm.asa01
                                   AND atcc02 = g_asr.asr02
                                   AND atcc05 = g_asr.asr05
                                   AND atcc07 = g_ass07
                                   AND atcc08 = tm.yy
                                   AND atcc09 < l_month)
        END CASE
        IF cl_null(l_amt1) THEN LET l_amt1 = 0 END IF
        IF cl_null(l_amt2) THEN LET l_amt2 = 0 END IF
        LET l_amt = l_amt2 - l_amt1

        LET l_r = 1
        LET l_r1 = 1
        CALL p007_getrate('3',tm.yy,l_month,l_asr12,l_asg07)  #取起始月份至當下月份的匯率
        RETURNING l_r   
        IF cl_null(l_r) THEN LET l_r = 1 END IF

        CALL p007_getrate('3',tm.yy,l_month,l_asg07,p_asg06) 
        RETURNING l_r1   
        IF cl_null(l_r1) THEN LET l_r1 = 1 END IF

        LET l_amt = l_amt * l_r * l_r1
        LET l_tot_amt = l_tot_amt + l_amt
     END FOREACH

     RETURN l_tot_amt 
END FUNCTION

FUNCTION p007_ins_ask1_chg(p_type,p_flag,p_asg06)
DEFINE p_asg06     LIKE asg_file.asg06
DEFINE p_asr12     LIKE asr_file.asr12
DEFINE l_asr08     LIKE asr_file.asr08
DEFINE l_asr09     LIKE asr_file.asr09
DEFINE l_asr08_b   LIKE asr_file.asr08
DEFINE l_asr09_b   LIKE asr_file.asr09
DEFINE l_month_amt LIKE asr_file.asr08
DEFINE l_tot_amt   LIKE asr_file.asr08
DEFINE i           LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_cut       LIKE type_file.num5
DEFINE l_asr12     LIKE asr_file.asr12
DEFINE l_r         LIKE ase_file.ase05
DEFINE l_r1        LIKE ase_file.ase05
DEFINE p_flag      LIKE type_file.chr1
DEFINE p_type      LIKE type_file.chr1
DEFINE l_asg07     LIKE asq_file.asq09

     #取下層公司記帳金額期別計算各月異動額
     #轉換為合併幣別金額後加總
     #各期各自先計算出當月金額後累加
     #沖銷金額=1-9月各期餘額加總
     #各期餘額計算方式：例:(9月合併異動(貸)-8月合併異動(貸)*9月匯率) - (9月合併異動(借)-8月合併異動(借) * 9月匯率)
      LET l_asr08 = 0
      LET l_asr09 = 0
      LET l_asr08_b = 0
      LET l_asr09_b = 0
      LET l_month_amt = 0
      LET l_tot_amt = 0
      SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=p_asg06
      IF cl_null(l_cut) THEN LET l_cut = 0 END IF

     #先依來源為ass_file or asr_file取各月餘額
     FOR i = 0 TO tm.em
         SELECT asg07 INTO l_asg07 FROM asg_file WHERE asg01 = g_asr.asr04
         IF p_type = 'A' THEN       #來源公司 
             CASE 
                WHEN p_flag = '1'        #asm_file
                    LET l_sql =
                    " SELECT SUM(asm07-asm08),asm11",
                    "   FROM asm_file ",
                    "  WHERE asm00 = '",g_asz01,"'",        #合併帳別 
                    "    AND asm01 = '",tm.asa01,"'",        #族群
                    "    AND asm02 = '",g_asr.asr04,"'",     #公司
                    "    AND asm04 = '",g_asr.asr05,"'",
                    "    AND asm05 = '",tm.yy,"'",
                    "    AND asm06 = '",i,"'",
                    "  GROUP BY asm11 "
                WHEN p_flag = '2'        #asn_file
                    LET l_sql=
                    " SELECT SUM(asn08-asn09),asn12",
                    "   FROM asn_file",
                    "  WHERE asn00 = '",g_asz01,"'",
                    "    AND asn01 = '",tm.asa01,"'",
                    "    AND asn02 = '",g_asr.asr04,"'",
                    "    AND asn04 = '",g_asr.asr05,"'",
                    "    AND asn05 = '",g_ass07,"'",
                    "    AND asn06 = '",tm.yy,"'",
                    "    AND asn07 = '",i,"'",
                    "  GROUP BY asn12"
            END CASE
        ELSE        #目的公司
            CASE
              WHEN p_flag = '1'        #asm_file
                 LET l_sql =
                 " SELECT SUM(asm07-asm08),asm11",
                 "   FROM asm_file ",
                 "  WHERE asm00 = '",g_asz01,"'",        #合併帳別 
                 "    AND asm01 = '",tm.asa01,"'",        #族群
                 "    AND asm02 = '",g_asr.asr04,"'",     #公司
                 "    AND asm04 = '",g_asr.asr05,"'",
                 "    AND asm05 = '",tm.yy,"'",
                 "    AND asm06 = '",i,"'",
                 "  GROUP BY asm11 "
              WHEN p_flag = '2'        #asn_file
                 LET l_sql=
                 " SELECT SUM(asn08-asn09),asn12",
                 "   FROM asn_file",
                 "  WHERE asn00 = '",g_asz01,"'",
                 "    AND asn01 = '",tm.asa01,"'",
                 "    AND asn02 = '",g_asr.asr04,"'",
                 "    AND asn04 = '",g_asr.asr05,"'",
                 "    AND asn05 = '",g_ass07,"'",
                 "    AND asn06 = '",tm.yy,"'",
                 "    AND asn07 = '",i,"'",
                 "  GROUP BY asn12"
            END CASE
        END IF

        PREPARE p007_ins_ask1_p1 FROM l_sql
        IF STATUS THEN
           LET g_showmsg=g_asa[i].asa01,"/",g_asa[i].asa02,"/",g_asa[i].asa03,"/",tm.yy
           CALL s_errmsg('asr01,asr04,asr041,asr06',g_showmsg,'pre:ins_ask1_p1',STATUS,1)
           LET g_success = 'N'
        END IF
        DECLARE p007_ins_ask1_c1 CURSOR FOR p007_ins_ask1_p1
        FOREACH p007_ins_ask1_c1 INTO l_month_amt,l_asr12    #借-貸/幣別
            LET l_r = 1
            LET l_r1 = 1
            IF i = 0 THEN LET i = 1 END IF  #0期沒有匯率，直接取1期的匯率計算
            CALL p007_getrate('3',tm.yy,i,l_asr12,l_asg07)  #取起始月份至當下月份的匯率
            RETURNING l_r   
            IF cl_null(l_r) THEN LET l_r = 1 END IF
            CALL p007_getrate('3',tm.yy,i,l_asg07,p_asg06) 
            RETURNING l_r1   
            IF cl_null(l_r1) THEN LET l_r1 = 1 END IF
            LET l_month_amt = l_month_amt * l_r * l_r1
            LET l_tot_amt = l_tot_amt + l_month_amt
        END FOREACH
     END FOR
     RETURN l_tot_amt 
END FUNCTION

FUNCTION p007_ins_ask2()   #差異科目
DEFINE l_sumd  LIKE ask_file.ask07,
       l_sumc  LIKE ask_file.ask07,
       l_sumdc LIKE ask_file.ask07
DEFINE l_aag04 LIKE aag_file.aag04
DEFINE l_asg08 LIKE asg_file.asg08    #FUN-B80195

   SELECT asg08 INTO l_asg08 FROM asg_file WHERE asg01 = g_asq.asq09 #FUN-B80195

   INITIALIZE g_ask.* TO NULL

   SELECT SUM(ask07) INTO l_sumd FROM ask_file
    WHERE ask00=g_asz01 AND ask01=g_asj.asj01 AND ask06='1'   #借方合計
   IF cl_null(l_sumd) THEN LET l_sumd = 0 END IF
   SELECT SUM(ask07) INTO l_sumc FROM ask_file
    WHERE ask00=g_asz01 AND ask01=g_asj.asj01 AND ask06='2'   #貸方合計
   IF cl_null(l_sumc) THEN LET l_sumc = 0 END IF
   LET l_sumdc=l_sumd-l_sumc   
   IF l_sumdc = 0 THEN RETURN END IF

   LET g_ask.ask00=g_asz01        #帳別
   LET g_ask.ask01=g_asj.asj01     #傳票編號   

   SELECT MAX(ask02)+1 INTO g_ask.ask02 
     FROM ask_file
    WHERE ask01=g_ask.ask01
      AND ask00=g_ask.ask00
   IF cl_null(g_ask.ask02)  THEN LET g_ask.ask02 = 1 END IF
   LET g_ask.ask03=g_asq.asq04     #科目
   LET g_ask.ask04=' '             #摘要
 # LET g_ask.ask05=' '             #關係人 #FUN-B60134  MARK
 # LET g_ask.ask05= g_asq.asq09    #FUN-B60134 ADD   #FUN-B80195
   LET g_ask.ask05= l_asg08        #FUN-B80195
   IF l_sumdc >0 THEN              #借貸別
      LET g_ask.ask06='2' 
   ELSE 
      LET g_ask.ask06='1' 
   END IF
   LET g_ask.ask07=l_sumdc         #金額
   IF g_ask.ask07<0 THEN LET g_ask.ask07=g_ask.ask07*-1 END IF
   IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF 
   LET g_ask.asklegal=g_legal
   IF g_ask.ask07 != 0 THEN
      INSERT INTO ask_file VALUES (g_ask.*)
      IF SQLCA.sqlcode THEN 
         LET g_showmsg=g_asj.asj07,"/",g_asj.asj01
         CALL s_errmsg('ask00,ask01',g_showmsg ,'ins ask',SQLCA.sqlcode,1)
         LET g_success = 'N' 
         RETURN 
      END IF
      LET l_aag04 = ''
      SELECT aag04 INTO l_aag04
        FROM aag_file
       WHERE aag00 = g_asz01
         AND aag01 = g_ask.ask03
      IF l_aag04 = '2' THEN
           EXECUTE insert_ask_prep USING g_ask.ask03,
                                         g_ask.ask06,g_ask.ask07
      END IF
   END IF

END FUNCTION

FUNCTION get_rate()#持股比率
DEFINE l_asb07    LIKE asb_file.asb07,
       l_asb08    LIKE asb_file.asb08,
       l_asd07b   LIKE asd_file.asd07b,
       l_asd08b   LIKE asd_file.asd08b,
       l_count    LIKE type_file.num5,
       l_sql      LIKE type_file.chr1000,
       l_asg05    LIKE asg_file.asg05

    SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01=g_asq.asq10
    SELECT asb07,asb08 INTO l_asb07,l_asb08 FROM asb_file 
     WHERE asb01=tm.asa01 AND asb02=tm.asa02 AND asb03=tm.asa03
       AND asb04=g_asq.asq10 AND asb05=l_asg05 
    IF STATUS THEN LET g_rate=0 RETURN END IF
    IF g_edate >= l_asb08 OR cl_null(l_asb08) THEN LET g_rate=l_asb07/100 RETURN END IF
    
    LET l_count=0
    LET g_rate =0
    LET l_sql="SELECT asd07b,asd08b  FROM asd_file ",
              " WHERE asd01='",tm.asa01,"'",
              "   AND asd02='",tm.asa02,"' AND asd03='",tm.asa03,"'",
              "   AND asd04b='",g_asq.asq10,"' AND asd05b='",l_asg05,"'",
              " ORDER BY asd08b desc"
    PREPARE p007_asd_p FROM l_sql
    IF STATUS THEN 
        CALL s_errmsg(' ',' ','prepare:6',STATUS,1) LET g_success = 'N'  RETURN
    END IF
    DECLARE p007_asd_c CURSOR FOR p007_asd_p

    FOREACH p007_asd_c INTO l_asd07b,l_asd08b
       IF SQLCA.sqlcode  THEN LET g_rate=0 EXIT FOREACH END IF
       LET l_count=l_count+1
       IF g_edate>=l_asd08b THEN LET g_rate=l_asd07b/100 EXIT FOREACH END IF
    END FOREACH       
    IF l_count=0 THEN LET g_rate=0 RETURN END IF
END FUNCTION

FUNCTION p007_ins_ask1()
DEFINE l_asg06_asq16   LIKE asg_file.asg06
DEFINE l_aag04         LIKE aag_file.aag04
DEFINE l_rate          LIKE ase_file.ase05   #各公司與合併主體公司匯率
DEFINE l_cut           LIKE type_file.num5
DEFINE l_sql           STRING #FUN-C80056 add

   INITIALIZE g_ask.* TO NULL
 
   LET g_ask.ask00=g_asz01        #帳別
   LET g_ask.ask01=g_asj.asj01     #傳票編號   

   SELECT MAX(ask02)+1 INTO g_ask.ask02 
     FROM ask_file 
    WHERE ask01=g_ask.ask01
      AND ask00=g_ask.ask00
   IF g_ask.ask02 IS NULL THEN LET g_ask.ask02 = 1 END IF   #項次
   LET g_ask.ask03=g_asr.asr05                              #科目
   LET g_ask.ask04=' '                                      #摘要
   LET g_ask.ask05=g_affil                                  #關係人
   IF g_asr.asr08 < 0 THEN 
      IF g_dc='1' THEN LET g_dc='2' ELSE LET g_dc='1' END IF
   END IF
   LET g_ask.ask06=g_dc                                     #借貸別
   LET l_rate = 1
   #FUN-C80056 --add-s-tr
   SELECT asr08,g_dc INTO g_asr081,g_dc1 FROM p007_tmp
    WHERE asr06 = g_asr.asr06 AND asr07 = g_asr.asr07
      AND asr05 != g_asr.asr05
   LET l_sql = "SELECT asq18 FROM asq_file WHERE asq02 = ",g_asr.asr05,"AND asq13 = ",g_asq.asq13,
           " AND asq16 = ",g_asq.asq16,"AND asq00 = ",g_asq.asq00," AND asq01 = ",g_asq.asq01,
           " AND asq02 = ",g_asq.asq02,"AND asq09 = ",g_asq.asq09," AND asq10 = ",g_asq.asq10,
           " AND asq12 = ",g_asq.asq12

   SELECT asq18 INTO g_asq18
     FROM asq_file
    WHERE asq02 = g_asq.asq02
      AND asq13 = g_asq.asq13
      AND asq16 = g_asq.asq16
      AND asq00 = g_asq.asq00
      AND asq01 = g_asq.asq01
      AND asq02 = g_asq.asq02
      AND asq09 = g_asq.asq09
      AND asq10 = g_asq.asq10
      AND asq12 = g_asq.asq12
   IF g_asr081 > g_asr.asr08 THEN 
      IF g_asq18 = 1 THEN 
         LET g_asr.asr08 = g_asr081
         LET g_dc = g_dc1
      END IF
      IF g_asq18 = 2 THEN 
         LET g_asr.asr08 = g_asr.asr08
      END IF
   ELSE 
      IF g_asq18 = 1 THEN 
         LET g_asr.asr08 = g_asr.asr08
      END IF
      IF g_asq18 = 2 THEN 
         LET g_asr.asr08 = g_asr081
         LET g_dc = g_dc1
      END IF
   END IF
   #FUN-C80056--add--end
   IF g_asq.asq03='N' OR (g_asq.asq03='Y' AND g_rate=0) THEN
      LET g_ask.ask07=g_asr.asr08                           #金額
   ELSE
      IF g_flag_r='Y' THEN
         LET g_ask.ask07=g_asr.asr08*(1-g_rate)          #金額
         IF g_ask.ask07 > 0 THEN
             LET g_ask.ask06 = '1'
         ELSE
             LET g_ask.ask06 = '2'
         END IF
      ELSE
         LET g_ask.ask07=g_asr.asr08                        #金額
      END IF
   END IF
   #原本都是以tm.asa02為上層公司寫入對沖分錄
   #改以"合併主體(asq16)"寫入對沖分錄上層公司(asj06),
   #對沖金額(ask07)的值原本是以上層公司的幣別計算
   #改以合併主體幣別
   #(asr08,asr09為捲算過後的上層公司記帳幣金額不可直接拿來使用)
   #當要產生對沖分錄時，tm.asa02取asq_file的值(asq16 = tm.asa02)再進行對沖產生
   #並且要把對沖金額換算為合併主體公司記帳幣，才能算出差額科目金額
   #一一將對沖的科目寫入分錄之後(要換算成合併主體幣別)，再計算差額額目(同一組分錄借-貸)
 
   SELECT asg06 INTO l_asg06_asq16 
     FROM asg_file
    WHERE asg01 = g_asq.asq16   #合併主體幣別
  
   #將來源/目的公司的幣別和合併主體幣別做比較
   #幣別相同者不用換，不相同時將幣別換成合併主體幣別and金額
   LET l_rate = 1

   SELECT azi04 INTO l_cut FROM azi_file WHERE azi01=l_asg06_asq16
   IF cl_null(l_cut) THEN LET l_cut = 0 END IF
   LET g_ask.ask07=cl_digcut(g_ask.ask07,l_cut)
   IF g_ask.ask07<0 THEN LET g_ask.ask07=g_ask.ask07*-1 END IF
   LET g_ask.asklegal=g_legal   
   IF g_ask.ask07 IS NULL THEN LET g_ask.ask07=0 END IF
   IF g_ask.ask07 != 0 THEN
      INSERT INTO ask_file VALUES (g_ask.*)
      IF SQLCA.sqlcode THEN 
         LET g_showmsg=g_asj.asj07,"/",g_asj.asj01
         CALL s_errmsg('ask00,ask01',g_showmsg ,'ins ask',SQLCA.sqlcode,1)
         LET g_success = 'N' 
         RETURN 
      END IF
      LET l_aag04 = ''
      SELECT aag04 INTO l_aag04
        FROM aag_file
       WHERE aag00 = g_asz01
         AND aag01 = g_ask.ask03
      IF l_aag04 = '2' THEN
           EXECUTE insert_ask_prep USING g_ask.ask03,g_ask.ask06,g_ask.ask07
                                         
      END IF
   END IF

END FUNCTION
#FUN-B50001

#TQC-B70069   ---start   Add
FUNCTION p007_del()
  LET g_em = tm.em    #TQC-B70069   Add
  #-->delete ask_file(調整與銷除分錄底稿單身檔)
  DELETE FROM ask_file
        WHERE ask00=g_asz01
          AND ask01 IN (SELECT asj01 FROM asj_file
                         WHERE asj00=g_asz01 AND asj05=tm.asa01
                           AND asj06=tm.asa02 AND asj07=tm.asa03
                           AND asj03=tm.yy AND asj04 = tm.em
                           AND asjconf <> 'X'  #CHI-C80041
                           AND (asj21=tm.ver OR asj21=g_em)
                           AND asj08='2')
  IF SQLCA.sqlcode THEN
     CALL cl_err3("del","ask_file",g_asz01,"",SQLCA.sqlcode,"","del ask_file",1)
     LET g_success = 'N'
     RETURN
  END IF

  #-->delete asj_file
  #-->delete asj_file(調整與銷除分錄底稿單頭檔)
  DELETE FROM asj_file
        WHERE asj00=g_asz01
          AND asj05=tm.asa01 AND asj06=tm.asa02 AND asj07=tm.asa03
          AND asj03=tm.yy AND asj04 = tm.em 
          AND asjconf <> 'X'  #CHI-C80041
          AND (asj21=tm.ver OR asj21=g_em) 
          AND asj08='2'
  IF SQLCA.sqlcode THEN
     CALL cl_err3("del","asj_file",tm.asa03,"",SQLCA.sqlcode,"","del asj_file",1)
     LET g_success = 'N'
     RETURN
  END IF
END FUNCTION
#TQC-B70069   ---end     Add

