# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: gglq900.4gl
# Descriptions...: 財務月結數據核查
# Date & Author..: 13/05/29 by lujh  #No.FUN-D40121
# Modify.........: No:TQC-D70023 13/07/05 By lujh 應收裏面的月結按鈕調用aglp130,應收裏面的賬齡更新按鈕調用錯誤
# Modify.........: No:FUN-D70072 13/07/15 By zhangweib 增加選項子模組分錄底稿與總帳檢核
# Modify.........: No:TQC-D80007 13/08/07 By lujh 當匯總條件選擇2和3的時候，出現客戶/廠商編號和簡稱/客戶簡稱的數據錯誤
# Modify.........: No:MOD-DC0092 13/12/13 By fengmy aapt140衝銷單的金額要去除

DATABASE ds
 
GLOBALS "../../config/top.global"  
 
DEFINE tm        RECORD                 
		         wc1     STRING,  
                 wc2     STRING,
                 choice  LIKE type_file.chr1,   #No.FUN-D70072   Add
                 a       LIKE type_file.chr1,
                 b       LIKE type_file.chr1, 
                 n       LIKE type_file.chr1,   #add by zhousw 130731   
                 yy      LIKE type_file.num5,
                 mm      LIKE type_file.num5,
                 e       LIKE type_file.chr1            
                 END RECORD,
       g_null    LIKE type_file.chr1,
       g_print   LIKE type_file.chr1
 
DEFINE g_i            LIKE type_file.num5
DEFINE l_table        STRING,
       g_str          STRING,
       g_sql          STRING
 
DEFINE   g_rec_b    LIKE type_file.num10
DEFINE   g_alz01    LIKE alz_file.alz01
DEFINE   g_aag02    LIKE aag_file.aag02
DEFINE   g_alz14    LIKE alz_file.alz04
DEFINE   g_cnt      LIKE type_file.num10
DEFINE   g_alz      DYNAMIC ARRAY OF RECORD
                    alz01      LIKE alz_file.alz01,      
                    occ02      LIKE occ_file.occ02,    
                    alz14      LIKE alz_file.alz14,
                    aag02      LIKE aag_file.aag02,
                    nma01      LIKE nma_file.nma01,   #No.FUN-D70072   Add
                    nma02      LIKE nma_file.nma02,   #No.FUN-D70072   Add
                    alz10      LIKE alz_file.alz10,
                    alz13f     LIKE alz_file.alz13f,  
                    alz13      LIKE alz_file.alz13,
                    cf         LIKE alz_file.alz13,     #总帐原币当期发生额
                    c          LIKE alz_file.alz13,     #总帐本币当期发生额
                    df_cf      LIKE alz_file.alz13,     #原币当期发生额差异
                    df_c       LIKE alz_file.alz13,     #本币当期发生额差异
                    alz09f     LIKE alz_file.alz09f,
                    alz09      LIKE alz_file.alz09,
                    df         LIKE alz_file.alz13,     #总帐原币期末余额
                    d          LIKE alz_file.alz13,     #总帐本币期末余额
                    df_tf      LIKE alz_file.alz13,     #原币余额差异
                    df_t       LIKE alz_file.alz13      #本币余额差异
                    END RECORD
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   l_ac           LIKE type_file.num5
DEFINE   g_aee02        LIKE aee_file.aee02   
DEFINE   g_comb         ui.ComboBox           
DEFINE   l_sql,l_sql1,l_sql2    STRING 
DEFINE   l_aah,l_abb,l_tah      STRING 
DEFINE   g_cka00        LIKE cka_file.cka00

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc1 = ARG_VAL(7)
   LET tm.wc2 = ARG_VAL(8)
   LET tm.a = ARG_VAL(9)
   LET tm.b = ARG_VAL(10)
   LET tm.yy = ARG_VAL(11)
   LET tm.mm = ARG_VAL(12)
   LET tm.e = ARG_VAL(13)
   LET g_rep_user = ARG_VAL(14)
   LET g_rep_clas = ARG_VAL(15)
   LET g_template = ARG_VAL(16)
   LET g_rpt_name = ARG_VAL(17)
   LET tm.choice = ARG_VAL(18)   #No.FUN-D70072   Add
   IF cl_null(tm.choice) THEN LET tm.choice = 1 END IF   #No.FUN-D70072   Add
 
   OPEN WINDOW q900_w AT 5,10
        WITH FORM "ggl/42f/gglq900" ATTRIBUTE(STYLE = g_win_style)
 
   CALL cl_ui_init()
   
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      CALL gglq900_tm(0,0)
   ELSE
      #CALL gglq900_t()   #No.FUN-D70072   Mark
     #CALL gglq900()     #No.FUN-D70072   Mark
     #No.FUN-D70072 ---Add--- Start
      CALL gglq900_t1_1()
      IF tm.choice = '1' THEN
         LET tm.choice = '1'
         CALL gglq900_t()
         CALL gglq900()
      ELSE
         CALL gglq900_t_1()
         CALL gglq900_1()
      END IF
     #No.FUN-D70072 ---Add--- End
   END IF
 
   CALL q900_menu()
   DROP TABLE gglq900_tmp;
   CLOSE WINDOW q900_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION q900_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000
 
   WHILE TRUE
      CALL q900_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL gglq900_tm(0,0)
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               
            END IF  
         #子系統查詢
         WHEN "inquiry_subsystem"
            IF cl_chk_act_auth() THEN
                CALL q900_inquiry_subsystem()
            END IF
         #總帳查詢
         WHEN "ledger_enquiry"
            IF cl_chk_act_auth() THEN
                CALL q900_ledger_enquiry()
            END IF
         #月結
         WHEN "monthly_statement"
            IF cl_chk_act_auth() THEN
                CALL q900_monthly_statement()
            END IF
            #No.FUN-D70072 ---Add--- Start
        #月結
         WHEN "ap_monthly_statement"
            IF cl_chk_act_auth() THEN
                CALL q900_apmonthly_statement()
            END IF
        #月結          
         WHEN "ar_monthly_statement"
            IF cl_chk_act_auth() THEN
                CALL q900_armonthly_statement()
            END IF
        #No.FUN-D70072 ---Add--- End
        
         #反月結
         WHEN "monthly_statement_return"
            IF cl_chk_act_auth() THEN
                CALL q900_monthly_statement_return()
            END IF
         #帳齡更新
         WHEN "aging_update"
            IF cl_chk_act_auth() THEN
                CALL q900_aging_update()
            END IF
         #關帳
         WHEN "closing"
            IF cl_chk_act_auth() THEN
                CALL q900_closing()
            END IF
             #No.FUN-D70072 ---Add--- Start
         #關帳
         WHEN "ap_closing"
            IF cl_chk_act_auth() THEN
                CALL q900_apclosing()
            END IF
         #關帳
         WHEN "ar_closing"
            IF cl_chk_act_auth() THEN
                CALL q900_arclosing()
            END IF
        #No.FUN-D70072 ---Add--- End
         #银行存款对账关账
         WHEN "check_closing"
            IF cl_chk_act_auth() THEN
                CALL q900_check_closing()
            END IF
         #月结异常单据
         WHEN "anomalies"
            IF cl_chk_act_auth() THEN
                CALL q900_anomalies()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel
               (ui.Interface.getRootNode(),base.TypeInfo.create(g_alz),'','')
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_alz01 IS NOT NULL THEN
                  LET g_doc.column1 = "aed01"
                  LET g_doc.value1 = g_alz01
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION gglq900_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01
   DEFINE p_row,p_col    LIKE type_file.num5,
          l_n            LIKE type_file.num5,
          l_flag         LIKE type_file.num5,
          l_cmd          LIKE type_file.chr1000
   DEFINE li_chk_bookno  LIKE type_file.num5
   DEFINE comb_value STRING
   DEFINE comb_item  STRING 
   DEFINE l_msg1     STRING 

   CLEAR FORM #清除畫面   
   CALL g_alz.clear()   

   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.yy = YEAR(g_today)
   LET tm.mm = MONTH(g_today)
   CALL cl_set_comp_visible('n',FALSE)   #No.FUN-D70072   Add
   LET tm.choice = '1'   #No.FUN-D70072   Add
   LET tm.n = '1'   #No.FUN-D70072   Add
   LET tm.a = '1'
   LET tm.b = '1'   
   LET tm.e ='N'    
   LET g_bgjob = 'N'
   CALL cl_set_comp_visible("alz01,occ02,alz14,aag02",TRUE)
   #IF tm.e = 'Y' THEN 
   #   CALL cl_set_comp_visible("alz13f,cf,df_cf,alz09f,df,df_tf",TRUE)
   #ELSE
   #   CALL cl_set_comp_visible("alz13f,cf,df_cf,alz09f,df,df_tf",FALSE)
   #END IF
   LET comb_value = '1,2,3'
   LET l_msg1 = cl_getmsg('ggl-104',g_lang)
   LET comb_item = l_msg1
   CALL cl_set_combo_items('a',comb_value,comb_item)
WHILE TRUE
    DIALOG ATTRIBUTES(UNBUFFERED) 
    INPUT BY NAME tm.choice,tm.a,tm.b,tm.n,tm.yy,tm.mm,tm.e   #No.FUN-D70072   Add tm.choice,tm.n      
          ATTRIBUTE(WITHOUT DEFAULTS=TRUE)
 
        BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
            
            #No.FUN-D70072 ---Add--- Start
        ON CHANGE choice
           IF NOT cl_null(tm.choice) THEN
              CALL gglq900_t1_1()
              CASE
                 WHEN tm.choice = '1' CALL gglq900_t()
                                      LET tm.a = '1'
                                      CALL cl_set_comp_visible('n',FALSE)
                 WHEN tm.choice = '2' CALL gglq900_t_1()
                    IF tm.b = '1' THEN LET tm.a = '3' ELSE LET tm.a = '1' END IF
                    IF tm.b = '2' THEN CALL cl_set_comp_visible('n',TRUE) END IF
              END CASE
           END IF
       #No.FUN-D70072 ---Add--- End

        ON CHANGE a
           IF cl_null(tm.a) THEN NEXT FIELD a END IF

        ON CHANGE b
           IF cl_null(tm.b) THEN 
              NEXT FIELD b 
           ELSE
             #CALL gglq900_t()   #No.FUN-D70072   Mark
             #No.FUN-D70072 ---Add--- Start
              CASE
                 WHEN tm.choice = '1' CALL gglq900_t()
                 WHEN tm.choice = '2' CALL gglq900_t_1()
                                      CALL gglq900_t1_1()
                    IF tm.b = '1' THEN LET tm.a = '3' ELSE LET tm.a = '1' END IF
                    IF tm.b = '2' THEN CALL cl_set_comp_visible('n',TRUE) ELSE CALL cl_set_comp_visible('n',FALSE) END IF
              END CASE
             #No.FUN-D70072 ---Add--- End
           END IF
 
        AFTER FIELD yy
           IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
        AFTER FIELD mm
           IF cl_null(tm.mm) OR tm.mm > 13 OR tm.mm < 1 THEN
              NEXT FIELD mm
           END IF
 
        ON CHANGE e
           IF tm.e NOT MATCHES "[YyNn]"  THEN
              NEXT FIELD e
           END IF
            
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT DIALOG     

         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLG
            CALL cl_cmdask()  
              
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG  

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()          
                        
    END INPUT     
    
    CONSTRUCT tm.wc1 ON alz01
                  FROM s_alz[1].alz01
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(alz01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_pmc14'
               LET g_qryparam.state= 'c'                  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO alz01
               NEXT FIELD alz01     
       END CASE

    END CONSTRUCT

    CONSTRUCT tm.wc2 ON alz14
                  FROM s_alz[1].alz14
      BEFORE CONSTRUCT
        CALL cl_qbe_init()

      ON ACTION CONTROLP
       CASE 
          WHEN INFIELD(alz14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_aag'
               LET g_qryparam.state= 'c'
               LET g_qryparam.where = " aag00 = '",g_aza.aza81 CLIPPED,"'"                     
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO alz14
               NEXT FIELD alz14     
       END CASE

    END CONSTRUCT
    
    ON ACTION EXIT
       LET INT_FLAG = 1
       EXIT DIALOG   

    ON ACTION ACCEPT
       EXIT DIALOG  
            
    ON ACTION cancel 
        LET INT_FLAG = 1
        EXIT DIALOG  
    END DIALOG 
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW gglq900_w
       RETURN
    END IF             
   
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    

    IF g_bgjob = 'Y' THEN
       SELECT zz08 INTO l_cmd FROM zz_file
              WHERE zz01='gglq900'
       IF SQLCA.sqlcode OR l_cmd IS NULL THEN
          CALL cl_err('gglq900','9031',1)
       ELSE
          LET tm.wc1=cl_replace_str(tm.wc1, "'", "\"")
          LET tm.wc2=cl_replace_str(tm.wc2, "'", "\"")
          LET l_cmd = l_cmd CLIPPED,
                          " '",g_pdate  CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          " '",g_rlang CLIPPED,"'",
                          " '",g_bgjob  CLIPPED,"'",
                          " '",g_prtway CLIPPED,"'",
                          " '",g_copies CLIPPED,"'",
                          " '",tm.wc1   CLIPPED,"'" ,
                          " '",tm.wc2   CLIPPED,"'" ,
                          " '",tm.a     CLIPPED,"'",
                          " '",tm.b     CLIPPED,"'",
                          " '",tm.yy    CLIPPED,"'" ,
                          " '",tm.mm    CLIPPED,"'" ,
                          " '",tm.e     CLIPPED,"'" ,
                          " '",g_rep_user CLIPPED,"'",
                          " '",g_rep_clas CLIPPED,"'",
                          " '",g_template CLIPPED,"'",
                          " '",g_rpt_name CLIPPED,"'"
          CALL cl_cmdat('gglq900',g_time,l_cmd)
       END IF
       CLOSE WINDOW gglq900_w   
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    CALL cl_wait()

    CALL gglq900() 
    
     #No.FUN-D70072 ---Add--- Start
    IF tm.choice = '1' THEN
       LET tm.choice = '1'
       CALL gglq900_t()
       CALL gglq900()
    ELSE
       CALL gglq900_t_1()
       CALL gglq900_1()
    END IF
   #No.FUN-D70072 ---Add--- End 

    ERROR ""
    EXIT WHILE
END WHILE
   IF INT_FLAG THEN    
      LET INT_FLAG = 0
      RETURN         
   END IF           
    #CALL gglq900_t()   #No.FUN-D70072   Mark
    #No.FUN-D70072 ---Add--- Start
   IF tm.choice = '1' THEN
      CALL gglq900_t()
   ELSE
      CALL gglq900_t_1()
   END IF
  #No.FUN-D70072 ---Add--- End
   LET g_alz01 = NULL
   LET g_aag02 = NULL
   LET g_alz14 = NULL
  #CLEAR FORM    #MOD-DC0092
   CALL g_alz.clear()
   CALL gglq900_cs()
 
END FUNCTION

FUNCTION gglq900()
   CALL gglq900_table()
   DELETE FROM gglq900_tmp
   IF tm.b = '1' OR tm.b = '2' THEN 
      IF tm.e = 'N' THEN 
         CALL gglq900_ar_ap()
      ELSE
         CALL gglq900_ar_ap_1()
      END IF 
   END IF 
   IF tm.b = '3' THEN 
      CALL gglq900_nm()
   END IF 
   IF tm.b = '4' THEN 
      CALL gglq900_fa()
   END IF  
   IF tm.b = '5' THEN 
      CALL gglq900_gl()
   END IF 
END FUNCTION

#No.FUN-D70072 ---Add--- Start
FUNCTION gglq900_1()
   CALL gglq900_table()
   DELETE FROM gglq900_tmp
   IF tm.b = '1' THEN 
      IF tm.e = 'N' THEN 
         CALL gglq900_ar_ap2()
      ELSE
         CALL gglq900_ar_ap2_1()
      END IF 
   END IF 
   IF tm.b = '2' THEN 
      IF tm.n = '1' THEN
         CALL gglq900_nm21()
      ELSE
         CALL gglq900_nm22()
      END IF
   END IF 
   IF tm.b = '3' THEN 
      CALL gglq900_fa2()
   END IF  
END FUNCTION
#No.FUN-D70072 ---Add--- End

FUNCTION gglq900_curs()
   
   #共用條件 aah_file
   LET l_aah = " SELECT SUM(aah04),SUM(aah05) FROM aah_file",
               "  WHERE aah00 = '",g_aza.aza81,"'",
               "    AND aah01 = ?",
               "    AND aah02 =  ",tm.yy
   #共用條件 abb_file
   LET l_abb = " SELECT SUM(abb07),sum(abb07f) FROM aba_file,abb_file",
               "  WHERE aba00 = abb00 AND aba01 = abb01 ",
               "    AND aba00 = '",g_aza.aza81,"'",
               "    AND aba03 =  ",tm.yy,
               "    AND abb03 LIKE ? ",
               "    AND abb06 = ?",
               "    AND aba19 <> 'X' ",   
               "    AND abaacti = 'Y' " ,
               "    AND ( aba19 = 'N' OR ( aba19 = 'Y' AND abapost = 'N'))"

   #期初(1)-aah_file
   LET l_sql = l_aah CLIPPED, " AND aah03 < ",tm.mm
   PREPARE gglq900_qc_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             
      CALL cl_err('gglq900_qc_p1',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_qc_cs1 CURSOR FOR gglq900_qc_p1

   #期初(2)-abb_file 
   LET l_sql = l_abb CLIPPED," AND aba04 < ",tm.mm
   PREPARE gglq900_qc_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             
      CALL cl_err('gglq900_qc_p2',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_qc_cs2 CURSOR FOR gglq900_qc_p2

   #原币期初-异动
   LET l_sql=l_abb CLIPPED," AND aba04 < ",tm.mm," AND abb24= ? "
   PREPARE gglq900_ybqc_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')            
      CALL cl_err('gglq900_ybqc_p2',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ybqc_cs2 CURSOR FOR gglq900_ybqc_p2

   #期間(1)-aah_file
   LET l_sql = l_aah CLIPPED, " AND aah03 =",tm.mm
   PREPARE gglq900_qj_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             
      CALL cl_err('gglq900_qj_p1',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_qj_cs1 CURSOR FOR gglq900_qj_p1
 
   #期間(2)-abb_file
   LET l_sql = l_abb CLIPPED, " AND aba04 =",tm.mm
   PREPARE gglq900_qj_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             
      CALL cl_err('gglq900_qj_p2',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_qj_cs2 CURSOR FOR gglq900_qj_p2
   #原币期间-异动
   LET l_sql = l_abb CLIPPED, " AND aba04 =",tm.mm," AND abb24= ? "
   PREPARE gglq900_ybqj_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
   CALL s_log_upd(g_cka00,'N')             
      CALL cl_err('gglq900_ybqj_p2',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ybqj_cs2 CURSOR FOR gglq900_ybqj_p2

   #foreach幣別
   LET l_sql1 = " SELECT UNIQUE tah08 FROM tah_file WHERE tah00='",g_aza.aza81,"' ",
                "   AND tah01 LIKE ? AND tah02='",tm.yy,"' "
   LET l_sql1 = l_sql1 CLIPPED," UNION SELECT UNIQUE abb24 FROM aba_file,abb_file",
                "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                "    AND aba00 = '",g_aza.aza81,"'",
                "    AND aba03 = ",tm.yy,
                "    AND abaacti='Y' ",
                "    AND abb03 LIKE ? ",
                "    AND aba19 <> 'X' " 

   PREPARE gglq900_abb24_p FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')            
      CALL cl_err('prepare gglq900_abb24_p',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_abb24_cs CURSOR FOR gglq900_abb24_p

   LET l_tah=" SELECT SUM(tah04),sum(tah05),SUM(tah09),SUM(tah10) FROM tah_file ",
             " WHERE tah00='",g_aza.aza81,"' AND tah01= ? AND tah02='",tm.yy,"' ",
             " AND tah08= ? "

   #原币期初
   LET l_sql2=l_tah CLIPPED," AND tah03< ",tm.mm           
   PREPARE gglq900_ybqc_p FROM l_sql2
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             
      CALL cl_err('prepare gglq900_ybqc_p',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ybqc_cs CURSOR FOR gglq900_ybqc_p   
      
   #原币期间
   LET l_sql2=l_tah CLIPPED," AND tah03 =",tm.mm
   PREPARE gglq900_ybqj_p FROM l_sql2
   IF SQLCA.sqlcode != 0 THEN
      CALL s_log_upd(g_cka00,'N')             
      CALL cl_err('prepare gglq900_ybqj_p',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ybqj_cs CURSOR FOR gglq900_ybqj_p 
END FUNCTION 

FUNCTION gglq900_ar_ap()
   DEFINE  l_alz01       LIKE alz_file.alz01
   DEFINE  l_alz14       LIKE alz_file.alz14
   DEFINE  l_alz14_str   LIKE alz_file.alz14
   DEFINE  l_alz10       LIKE alz_file.alz10
   DEFINE  l_alz13f      LIKE alz_file.alz13f
   DEFINE  l_alz13       LIKE alz_file.alz13
   DEFINE  l_alz15       LIKE alz_file.alz15
   DEFINE  l_alz09f      LIKE alz_file.alz09f
   DEFINE  l_alz09       LIKE alz_file.alz09
   DEFINE  qj_abb07_1    LIKE abb_file.abb07
   DEFINE  qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qj_abb07_2    LIKE abb_file.abb07
   DEFINE  qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE  qc_abb07_1    LIKE abb_file.abb07
   DEFINE  qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qc_abb07_2    LIKE abb_file.abb07
   DEFINE  qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE  l_aag02       LIKE aag_file.aag02
   DEFINE  l_aag06       LIKE aag_file.aag06
   DEFINE  l_occ02       LIKE occ_file.occ02
   DEFINE  l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE  l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE  l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE  l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE  l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE  l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE  l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE  l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE  l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE  l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE  qc_aed05      LIKE aed_file.aed05  #期初
   DEFINE  qc_aed06      LIKE aed_file.aed06
   DEFINE  qj_aed05      LIKE aed_file.aed05  #期間
   DEFINE  qj_aed06      LIKE aed_file.aed06
   DEFINE  l_aed05       LIKE aed_file.aed05
   DEFINE  l_aed06       LIKE aed_file.aed06
   DEFINE  l_aed         STRING 

   LET l_sql = "SELECT DISTINCT alz01,alz14 ",
               "  FROM alz_file ",
               " WHERE alz02 = '",tm.yy,"'", 
               "   AND alz03 = '",tm.mm,"'",
               "   AND ",tm.wc1 CLIPPED,
               "   AND ",tm.wc2 CLIPPED
   IF tm.b = '1' THEN 
      LET l_sql = l_sql," AND alz00 = '2' "
   ELSE
      LET l_sql = l_sql," AND alz00 = '1' "
   END IF 
   PREPARE gglq900_alz_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_alz_cs1 CURSOR FOR gglq900_alz_p1
   FOREACH gglq900_alz_cs1 INTO l_alz01,l_alz14
      LET l_alz14_str = l_alz14 CLIPPED,'\%'
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_alz_cs1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      #TQC-D80007--mark--str--
      #LET l_sql = " SELECT SUM(alz13f),SUM(alz13),SUM(alz15),SUM(alz09f),SUM(alz09)",
      #            "   FROM alz_file",
      #            "  WHERE alz02 = '",tm.yy,"'",
      #            "    AND alz03 = '",tm.mm,"'",
      #            "    AND alz01 = '",l_alz01,"'",
      #            "    AND alz14 = '",l_alz14,"'"
      #TQC-D80007--mark--end--
      #TQC-D80007--add--str--
      IF tm.b = '1' THEN
         LET l_sql = "SELECT SUM(alz13_bf - alz13_af),SUM(alz13_b - alz13_a),SUM(alz15), ",
                     "       SUM(alz09_bf - alz09_af),SUM(alz09_b - alz09_a) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af,",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     #MOD-DC0092--begin---
                     "                      AND NOT EXISTS (SELECT 1  FROM apa_file,oma_file ",
                     "                                       WHERE apa01 = e.alz04 AND oma16=apa01 ",
                     "                                         AND apa00 ='14' )",
                     #MOD-DC0092--end
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file g ",
                     "                     WHERE a.alz00 = g.alz00 ",
                     "                       AND a.alz01 = g.alz01 ",
                     "                       AND a.alz02 = g.alz02 ",
                     "                       AND a.alz03 = g.alz03 ",
                     "                       AND a.alz04 = g.alz04 ",
                     "                       AND a.alz05 = g.alz05 ",
                     "                       AND g.alz09f > 0),0)  alz09_bf, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file h ",
                     "                     WHERE a.alz00 = h.alz00 ",
                     "                       AND a.alz01 = h.alz01 ",
                     "                       AND a.alz02 = h.alz02 ",
                     "                       AND a.alz03 = h.alz03 ",
                     "                       AND a.alz04 = h.alz04 ",
                     "                       AND a.alz05 = h.alz05 ",
                     "                       AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file i ",
                     "                     WHERE a.alz00 = i.alz00 ",
                     "                       AND a.alz01 = i.alz01 ",
                     "                       AND a.alz02 = i.alz02 ",
                     "                       AND a.alz03 = i.alz03 ",
                     "                       AND a.alz04 = i.alz04 ",
                     "                       AND a.alz05 = i.alz05 ",
                     #MOD-DC0092--begin---
                     "                       AND NOT EXISTS (SELECT 1  FROM apa_file,oma_file ",
                     "                                        WHERE apa01 = i.alz04 AND oma16=apa01 ",
                     "                                          AND apa00 ='14' )",
                     #MOD-DC0092--end
                     "                       AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '1') ",
                     " UNION ",
                     "SELECT  SUM(alz13_af - alz13_bf),SUM(alz13_a - alz13_b),SUM(alz15), ",
                     "        SUM(alz09_af - alz09_bf),SUM(alz09_a - alz09_b) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af, ",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     #MOD-DC0092--begin---
                     "                       AND NOT EXISTS (SELECT 1  FROM apa_file,oma_file ",
                     "                                        WHERE apa01 = e.alz04 AND oma16=apa01 ",
                     "                                          AND apa00 ='14' )",
                     #MOD-DC0092--end
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file g ",
                     "                     WHERE a.alz00 = g.alz00 ",
                     "                       AND a.alz01 = g.alz01 ",
                     "                       AND a.alz02 = g.alz02 ",
                     "                       AND a.alz03 = g.alz03 ",
                     "                       AND a.alz04 = g.alz04 ",
                     "                       AND a.alz05 = g.alz05 ",
                     "                       AND g.alz09f > 0),0)  alz09_bf, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file h ",
                     "                     WHERE a.alz00 = h.alz00 ",
                     "                       AND a.alz01 = h.alz01 ",
                     "                       AND a.alz02 = h.alz02 ",
                     "                       AND a.alz03 = h.alz03 ",
                     "                       AND a.alz04 = h.alz04 ",
                     "                       AND a.alz05 = h.alz05 ",
                     "                       AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file i ",
                     "                     WHERE a.alz00 = i.alz00 ",
                     "                       AND a.alz01 = i.alz01 ",
                     "                       AND a.alz02 = i.alz02 ",
                     "                       AND a.alz03 = i.alz03 ",
                     "                       AND a.alz04 = i.alz04 ",
                     "                       AND a.alz05 = i.alz05 ",
                     #MOD-DC0092--begin---
                     "                       AND NOT EXISTS (SELECT 1  FROM apa_file,oma_file ",
                     "                                        WHERE apa01 = i.alz04 AND oma16=apa01 ",
                     "                                          AND apa00 ='14' )",
                     #MOD-DC0092--end
                     "                       AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '2') "
      ELSE
         LET l_sql = "SELECT  SUM(alz13_af - alz13_bf),SUM(alz13_a - alz13_b),SUM(alz15), ",
                     "        SUM(alz09_af - alz09_bf),SUM(alz09_a - alz09_b) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af,",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     #MOD-DC0092--begin---
                     "                       AND NOT EXISTS (SELECT 1  FROM oma_file,apa_file ",
                     "                                        WHERE oma01 = d.alz04 AND oma16=apa01",
                     "                                          AND oma00 ='20' )",
                     #MOD-DC0092--end
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file g ",
                     "                     WHERE a.alz00 = g.alz00 ",
                     "                       AND a.alz01 = g.alz01 ",
                     "                       AND a.alz02 = g.alz02 ",
                     "                       AND a.alz03 = g.alz03 ",
                     "                       AND a.alz04 = g.alz04 ",
                     "                       AND a.alz05 = g.alz05 ",
                     "                       AND g.alz09f > 0),0)  alz09_bf, ",
                     "               NVL ((SELECT SUM(alz09) ",
                     "                      FROM alz_file h ",
                     "                     WHERE a.alz00 = h.alz00 ",
                     "                       AND a.alz01 = h.alz01 ",
                     "                       AND a.alz02 = h.alz02 ",
                     "                       AND a.alz03 = h.alz03 ",
                     "                       AND a.alz04 = h.alz04 ",
                     "                       AND a.alz05 = h.alz05 ",
                     #MOD-DC0092--begin---
                     "                       AND NOT EXISTS (SELECT 1  FROM oma_file,apa_file ",
                     "                                        WHERE oma01 = h.alz04 AND oma16=apa01",
                     "                                          AND oma00 ='20' )",
                     #MOD-DC0092--end
                     "                       AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file i ",
                     "                     WHERE a.alz00 = i.alz00 ",
                     "                       AND a.alz01 = i.alz01 ",
                     "                       AND a.alz02 = i.alz02 ",
                     "                       AND a.alz03 = i.alz03 ",
                     "                       AND a.alz04 = i.alz04 ",
                     "                       AND a.alz05 = i.alz05 ",
                     "                       AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '1') ",
                     " UNION ",
                     "SELECT  SUM(alz13_bf - alz13_af),SUM(alz13_b - alz13_a),SUM(alz15), ",
                     "        SUM(alz09_bf - alz09_af),SUM(alz09_b - alz09_a) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af, ",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     #MOD-DC0092--begin---
                     "                       AND NOT EXISTS (SELECT 1  FROM oma_file,apa_file ",
                     "                                        WHERE oma01 = d.alz04 AND oma16=apa01",
                     "                                          AND oma00 ='20' )",
                     #MOD-DC0092--end
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "                NVL((SELECT SUM(alz09f) ",
                     "                       FROM alz_file g ",
                     "                      WHERE a.alz00 = g.alz00 ",
                     "                        AND a.alz01 = g.alz01 ",
                     "                        AND a.alz02 = g.alz02 ",
                     "                        AND a.alz03 = g.alz03 ",
                     "                        AND a.alz04 = g.alz04 ",
                     "                        AND a.alz05 = g.alz05 ",
                     "                        AND g.alz09f > 0),0)  alz09_bf, ",
                     "                NVL((SELECT SUM(alz09) ",
                     "                       FROM alz_file h ",
                     "                      WHERE a.alz00 = h.alz00 ",
                     "                        AND a.alz01 = h.alz01 ",
                     "                        AND a.alz02 = h.alz02 ",
                     "                        AND a.alz03 = h.alz03 ",
                     "                        AND a.alz04 = h.alz04 ",
                     "                        AND a.alz05 = h.alz05 ",
                     #MOD-DC0092--begin---
                     "                       AND NOT EXISTS (SELECT 1  FROM oma_file,apa_file ",
                     "                                        WHERE oma01 = h.alz04 AND oma16=apa01",
                     "                                          AND oma00 ='20' )",
                     #MOD-DC0092--end
                     "                        AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "                NVL((SELECT SUM(alz09) ",
                     "                       FROM alz_file i ",
                     "                      WHERE a.alz00 = i.alz00 ",
                     "                        AND a.alz01 = i.alz01 ",
                     "                        AND a.alz02 = i.alz02 ",
                     "                        AND a.alz03 = i.alz03 ",
                     "                        AND a.alz04 = i.alz04 ",
                     "                        AND a.alz05 = i.alz05 ",
                     "                        AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '2') "
      END IF
      #TQC-D80007--add--end--
      PREPARE gglq900_alz_p2 FROM l_sql 
      EXECUTE gglq900_alz_p2 INTO l_alz13f,l_alz13,l_alz15,
                                  l_alz09f,l_alz09
      IF cl_null(l_alz13f) THEN 
         LET l_alz13f = 0
      END IF 
      IF cl_null(l_alz13) THEN 
         LET l_alz13 = 0
      END IF 
      IF cl_null(l_alz15) THEN 
         LET l_alz15 = 0
      END IF 
      IF cl_null(l_alz09f) THEN 
         LET l_alz09f = 0
      END IF 
      IF cl_null(l_alz09) THEN 
         LET l_alz09 = 0
      END IF 

      #共用條件
      LET l_aed = "SELECT SUM(aed05),SUM(aed06) FROM aed_file",
                  " WHERE aed00 = '",g_aza.aza81,"'",
                  "   AND aed01 LIKE ? ",                #科目
                  "   AND aed02 = '",l_alz01,"'",        #核算項
                  "   AND aed011 = '1'",
                  "   AND aed03 = ",tm.yy

      LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "    AND aba00 = '",g_aza.aza81,"'",
                  "    AND abb03 LIKE ?   ",             #科目
                  "    AND abb11  = '",l_alz01,"'",    #核算項值
                  "    AND aba03 = ",tm.yy,
                  "    AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
 
      #當期異動 
      LET l_sql1 = l_aed CLIPPED, "   AND aed04 = ? "  #當期
      LET l_sql1 = l_sql1 CLIPPED,
                   " UNION ",
                   #未過帳 - 借
                   " SELECT SUM(abb07),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '1' ",
                   "    AND aba04 = ?   ",              #當期未過帳資料
                   " UNION ",
                   #未過帳 - 貸
                   " SELECT 0,SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '2' ",
                   "    AND aba04 = ?   "               #當期未過帳資料
      PREPARE gglq900_qj_p FROM l_sql1
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE gglq900_qj_cs CURSOR FOR gglq900_qj_p
 
      #期初余額
      LET l_sql1 = l_aed CLIPPED, "   AND aed04 < ? "  #期初
      LET l_sql1 = l_sql1 CLIPPED,
                   " UNION ",
                   #未過帳 - 借
                   " SELECT SUM(abb07),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '1' ",
                   "    AND aba04 < ?   ",              #期初未過帳資料
                   " UNION ",
                   #未過帳 - 貸
                   " SELECT 0,SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '2' ",
                   "    AND aba04 < ?   "               #期初未過帳資料
      PREPARE gglq900_qc_p FROM l_sql1
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE gglq900_qc_cs CURSOR FOR gglq900_qc_p

      LET qc_aed05 = 0  #期初
      LET qc_aed06 = 0
      LET qj_aed05 = 0  #期間
      LET qj_aed06 = 0

      FOREACH gglq900_qc_cs USING l_alz14_str,tm.mm,
                                  l_alz14_str,tm.mm,
                                  l_alz14_str,tm.mm
                             INTO l_aed05,l_aed06
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq701_aed02_cs foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
         END IF
         IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
         IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF

         LET qc_aed05 = qc_aed05 + l_aed05    
         LET qc_aed06 = qc_aed06 + l_aed06    

      END FOREACH

      FOREACH gglq900_qj_cs USING l_alz14_str,tm.mm,
                                  l_alz14_str,tm.mm,
                                  l_alz14_str,tm.mm
                             INTO l_aed05,l_aed06
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
         IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF
         
         LET qj_aed05 = qj_aed05 + l_aed05  
         LET qj_aed06 = qj_aed06 + l_aed06   
      END FOREACH

       

      LET l_aag02 = NULL 
      IF tm.b = '1' THEN    #TQC-D80007 add
         SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = l_alz01  
      #TQC-D80007--add--str--
      ELSE
          SELECT pmc03 INTO l_occ02 FROM pmc_file WHERE pmc01 = l_alz01
      END IF
      #TQC-D80007--add--end--
      SELECT aag02,aag06 INTO l_aag02,l_aag06 
        FROM aag_file 
        WHERE aag00 = g_aza.aza81 
         AND aag01 = l_alz14

      #借余
      IF l_aag06 = '1' THEN 
         LET l_cf = 0
         LET l_c  = qj_aed05  - qj_aed06
         LET l_qcf = 0
         LET l_qc  = qc_aed05  - qc_aed06
      END IF 
      #貸余
      IF l_aag06 = '2' THEN 
         LET l_cf = 0
         LET l_c  = qj_aed06  - qj_aed05
         LET l_qcf = 0
         LET l_qc  = qc_aed06  - qc_aed05
      END IF 
      IF cl_null(l_c) THEN 
         LET l_c = 0
      END IF  
      IF cl_null(l_qc) THEN 
         LET l_qc = 0
      END IF

      #TQC-D80007--add--str--
      IF l_c = 0 AND l_qc = 0 THEN 
         CALL gglq900_qj(l_alz14) RETURNING l_qc,l_qcf,l_c,l_cf 
      END IF 
      #TQC-D80007--add--end--

      #總帳原幣期末餘額
      LET l_df = 0

      #總帳本幣期末餘額
      LET l_d  = l_qc  + l_c
      IF cl_null(l_d) THEN 
         LET l_d = 0
      END IF 
      
      #原幣當期發生額差異
      LET l_df_cf = 0

      #本幣當期發生額差異
      LET l_df_c  = l_c  - l_alz13
      IF cl_null(l_df_c) THEN 
         LET l_df_c = 0
      END IF

      #原幣餘額差異
      LET l_df_tf = 0

      #本幣餘額差異
      LET l_df_t  = l_d  - l_alz09
      IF cl_null(l_df_t) THEN 
         LET l_df_t = 0
      END IF

      INSERT INTO gglq900_tmp 
      VALUES(l_alz01,l_occ02,l_alz14,l_aag02,'',l_alz13f,l_alz13,
             l_cf,l_c,l_df_cf,l_df_c,l_alz09f,l_alz09,l_df,l_d,
             l_df_tf,l_df_t)
      
   END FOREACH 
END FUNCTION 

FUNCTION gglq900_ar_ap_1()
   DEFINE  l_alz01       LIKE alz_file.alz01
   DEFINE  l_alz14       LIKE alz_file.alz14
   DEFINE  l_alz14_str   LIKE alz_file.alz14
   DEFINE  l_alz10       LIKE alz_file.alz10
   DEFINE  l_alz13f      LIKE alz_file.alz13f
   DEFINE  l_alz13       LIKE alz_file.alz13
   DEFINE  l_alz15       LIKE alz_file.alz15
   DEFINE  l_alz09f      LIKE alz_file.alz09f
   DEFINE  l_alz09       LIKE alz_file.alz09
   DEFINE  qj_abb07_1    LIKE abb_file.abb07
   DEFINE  qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qj_abb07_2    LIKE abb_file.abb07
   DEFINE  qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE  qc_abb07_1    LIKE abb_file.abb07
   DEFINE  qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qc_abb07_2    LIKE abb_file.abb07
   DEFINE  qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE  l_aag02       LIKE aag_file.aag02
   DEFINE  l_aag06       LIKE aag_file.aag06
   DEFINE  l_occ02       LIKE occ_file.occ02
   DEFINE  l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE  l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE  l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE  l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE  l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE  l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE  l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE  l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE  l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE  l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE  qc_ted05      LIKE ted_file.ted05    #期初
   DEFINE  qc_ted06      LIKE ted_file.ted06
   DEFINE  qj_ted05      LIKE ted_file.ted05    #期間
   DEFINE  qj_ted06      LIKE ted_file.ted06
   DEFINE  qc_ted10      LIKE ted_file.ted10    #期初
   DEFINE  qc_ted11      LIKE ted_file.ted11
   DEFINE  qj_ted10      LIKE ted_file.ted10    #期間
   DEFINE  qj_ted11      LIKE ted_file.ted11
   DEFINE  l_ted05       LIKE ted_file.ted05
   DEFINE  l_ted06       LIKE ted_file.ted06
   DEFINE  l_ted10       LIKE ted_file.ted10 
   DEFINE  l_ted11       LIKE ted_file.ted11
   DEFINE  l_ted         STRING 

   LET l_sql = "SELECT DISTINCT alz01,alz14,alz10 ",
               "  FROM alz_file ",
               " WHERE alz02 = '",tm.yy,"'", 
               "   AND alz03 = '",tm.mm,"'",
               "   AND ",tm.wc1 CLIPPED,
               "   AND ",tm.wc2 CLIPPED
   IF tm.b = '1' THEN 
      LET l_sql = l_sql," AND alz00 = '2' "
   ELSE
      LET l_sql = l_sql," AND alz00 = '1' "
   END IF 
   PREPARE gglq900_alz_p1f FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_alz_cs1f CURSOR FOR gglq900_alz_p1f
   FOREACH gglq900_alz_cs1f INTO l_alz01,l_alz14,l_alz10
      LET l_alz14_str = l_alz14 CLIPPED,'\%'
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_alz_cs1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      #TQC-D80007--mark--str--
      #LET l_sql = " SELECT SUM(alz13f),SUM(alz13),SUM(alz15),SUM(alz09f),SUM(alz09)",
      #            "   FROM alz_file",
      #            "  WHERE alz02 = '",tm.yy,"'",
      #            "    AND alz03 = '",tm.mm,"'",
      #            "    AND alz01 = '",l_alz01,"'",
      #            "    AND alz14 = '",l_alz14,"'",
      #            "    AND alz10 = '",l_alz10,"'"
      #TQC-D80007--mark--end--
      #TQC-D80007--add--str--
      IF tm.b = '1' THEN
         LET l_sql = "SELECT SUM(alz13_bf - alz13_af),SUM(alz13_b - alz13_a),SUM(alz15), ",
                     "       SUM(alz09_bf - alz09_af),SUM(alz09_b - alz09_a) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af,",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file g ",
                     "                     WHERE a.alz00 = g.alz00 ",
                     "                       AND a.alz01 = g.alz01 ",
                     "                       AND a.alz02 = g.alz02 ",
                     "                       AND a.alz03 = g.alz03 ",
                     "                       AND a.alz04 = g.alz04 ",
                     "                       AND a.alz05 = g.alz05 ",
                     "                       AND g.alz09f > 0),0)  alz09_bf, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file h ",
                     "                     WHERE a.alz00 = h.alz00 ",
                     "                       AND a.alz01 = h.alz01 ",
                     "                       AND a.alz02 = h.alz02 ",
                     "                       AND a.alz03 = h.alz03 ",
                     "                       AND a.alz04 = h.alz04 ",
                     "                       AND a.alz05 = h.alz05 ",
                     "                       AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file i ",
                     "                     WHERE a.alz00 = i.alz00 ",
                     "                       AND a.alz01 = i.alz01 ",
                     "                       AND a.alz02 = i.alz02 ",
                     "                       AND a.alz03 = i.alz03 ",
                     "                       AND a.alz04 = i.alz04 ",
                     "                       AND a.alz05 = i.alz05 ",
                     "                       AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '1') ",
                     " UNION ",
                     "SELECT  SUM(alz13_af - alz13_bf),SUM(alz13_a - alz13_b),SUM(alz15), ",
                     "        SUM(alz09_af - alz09_bf),SUM(alz09_a - alz09_b) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af, ",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file g ",
                     "                     WHERE a.alz00 = g.alz00 ",
                     "                       AND a.alz01 = g.alz01 ",
                     "                       AND a.alz02 = g.alz02 ",
                     "                       AND a.alz03 = g.alz03 ",
                     "                       AND a.alz04 = g.alz04 ",
                     "                       AND a.alz05 = g.alz05 ",
                     "                       AND g.alz09f > 0),0)  alz09_bf, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file h ",
                     "                     WHERE a.alz00 = h.alz00 ",
                     "                       AND a.alz01 = h.alz01 ",
                     "                       AND a.alz02 = h.alz02 ",
                     "                       AND a.alz03 = h.alz03 ",
                     "                       AND a.alz04 = h.alz04 ",
                     "                       AND a.alz05 = h.alz05 ",
                     "                       AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file i ",
                     "                     WHERE a.alz00 = i.alz00 ",
                     "                       AND a.alz01 = i.alz01 ",
                     "                       AND a.alz02 = i.alz02 ",
                     "                       AND a.alz03 = i.alz03 ",
                     "                       AND a.alz04 = i.alz04 ",
                     "                       AND a.alz05 = i.alz05 ",
                     "                       AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '2') "
      ELSE
         LET l_sql = "SELECT  SUM(alz13_af - alz13_bf),SUM(alz13_a - alz13_b),SUM(alz15), ",
                     "        SUM(alz09_af - alz09_bf),SUM(alz09_a - alz09_b) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af,",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file g ",
                     "                     WHERE a.alz00 = g.alz00 ",
                     "                       AND a.alz01 = g.alz01 ",
                     "                       AND a.alz02 = g.alz02 ",
                     "                       AND a.alz03 = g.alz03 ",
                     "                       AND a.alz04 = g.alz04 ",
                     "                       AND a.alz05 = g.alz05 ",
                     "                       AND g.alz09f > 0),0)  alz09_bf, ",
                     "               NVL ((SELECT SUM(alz09) ",
                     "                      FROM alz_file h ",
                     "                     WHERE a.alz00 = h.alz00 ",
                     "                       AND a.alz01 = h.alz01 ",
                     "                       AND a.alz02 = h.alz02 ",
                     "                       AND a.alz03 = h.alz03 ",
                     "                       AND a.alz04 = h.alz04 ",
                     "                       AND a.alz05 = h.alz05 ",
                     "                       AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "               NVL((SELECT SUM(alz09) ",
                     "                      FROM alz_file i ",
                     "                     WHERE a.alz00 = i.alz00 ",
                     "                       AND a.alz01 = i.alz01 ",
                     "                       AND a.alz02 = i.alz02 ",
                     "                       AND a.alz03 = i.alz03 ",
                     "                       AND a.alz04 = i.alz04 ",
                     "                       AND a.alz05 = i.alz05 ",
                     "                       AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '1') ",
                     " UNION ",
                     "SELECT  SUM(alz13_bf - alz13_af),SUM(alz13_b - alz13_a),SUM(alz15), ",
                     "        SUM(alz09_bf - alz09_af),SUM(alz09_b - alz09_a) ",
                     "  FROM (SELECT NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file b ",
                     "                     WHERE a.alz00 = b.alz00 ",
                     "                       AND a.alz01 = b.alz01 ",
                     "                       AND a.alz02 = b.alz02 ",
                     "                       AND a.alz03 = b.alz03 ",
                     "                       AND a.alz04 = b.alz04 ",
                     "                       AND a.alz05 = b.alz05 ",
                     "                       AND b.alz13f < 0),0) * -1 alz13_af, ",
                     "               NVL((SELECT SUM(alz13f) ",
                     "                      FROM alz_file c ",
                     "                     WHERE a.alz00 = c.alz00 ",
                     "                       AND a.alz01 = c.alz01 ",
                     "                       AND a.alz02 = c.alz02 ",
                     "                       AND a.alz03 = c.alz03 ",
                     "                       AND a.alz04 = c.alz04 ",
                     "                       AND a.alz05 = c.alz05 ",
                     "                       AND c.alz13f > 0),0) alz13_bf, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file d ",
                     "                     WHERE a.alz00 = d.alz00 ",
                     "                       AND a.alz01 = d.alz01 ",
                     "                       AND a.alz02 = d.alz02 ",
                     "                       AND a.alz03 = d.alz03 ",
                     "                       AND a.alz04 = d.alz04 ",
                     "                       AND a.alz05 = d.alz05 ",
                     "                       AND d.alz13 < 0),0) * -1 alz13_a, ",
                     "               NVL((SELECT SUM(alz13) ",
                     "                      FROM alz_file e ",
                     "                     WHERE a.alz00 = e.alz00 ",
                     "                       AND a.alz01 = e.alz01 ",
                     "                       AND a.alz02 = e.alz02 ",
                     "                       AND a.alz03 = e.alz03 ",
                     "                       AND a.alz04 = e.alz04 ",
                     "                       AND a.alz05 = e.alz05 ",
                     "                       AND e.alz13 > 0),0)  alz13_b, ",
                     "               alz15, ",
                     "               NVL((SELECT SUM(alz09f) ",
                     "                      FROM alz_file f ",
                     "                     WHERE a.alz00 = f.alz00 ",
                     "                       AND a.alz01 = f.alz01 ",
                     "                       AND a.alz02 = f.alz02 ",
                     "                       AND a.alz03 = f.alz03 ",
                     "                       AND a.alz04 = f.alz04 ",
                     "                       AND a.alz05 = f.alz05 ",
                     "                       AND f.alz09f < 0),0) * -1 alz09_af, ",
                     "                NVL((SELECT SUM(alz09f) ",
                     "                       FROM alz_file g ",
                     "                      WHERE a.alz00 = g.alz00 ",
                     "                        AND a.alz01 = g.alz01 ",
                     "                        AND a.alz02 = g.alz02 ",
                     "                        AND a.alz03 = g.alz03 ",
                     "                        AND a.alz04 = g.alz04 ",
                     "                        AND a.alz05 = g.alz05 ",
                     "                        AND g.alz09f > 0),0)  alz09_bf, ",
                     "                NVL((SELECT SUM(alz09) ",
                     "                       FROM alz_file h ",
                     "                      WHERE a.alz00 = h.alz00 ",
                     "                        AND a.alz01 = h.alz01 ",
                     "                        AND a.alz02 = h.alz02 ",
                     "                        AND a.alz03 = h.alz03 ",
                     "                        AND a.alz04 = h.alz04 ",
                     "                        AND a.alz05 = h.alz05 ",
                     "                        AND h.alz09 < 0),0) * -1 alz09_a, ",
                     "                NVL((SELECT SUM(alz09) ",
                     "                       FROM alz_file i ",
                     "                      WHERE a.alz00 = i.alz00 ",
                     "                        AND a.alz01 = i.alz01 ",
                     "                        AND a.alz02 = i.alz02 ",
                     "                        AND a.alz03 = i.alz03 ",
                     "                        AND a.alz04 = i.alz04 ",
                     "                        AND a.alz05 = i.alz05 ",
                     "                        AND i.alz09 > 0),0)  alz09_b ",
                     "          FROM alz_file a, aag_file ",
                     "         WHERE alz02 = '",tm.yy,"'",
                     "           AND alz03 = '",tm.mm,"'",
                     "           AND alz01 = '",l_alz01,"'",
                     "           AND alz14 = '",l_alz14,"'",
                     "           AND aag00 = '",g_aza.aza81,"'",   #TQC-D80007  add
                     "           AND aag01 = alz14 AND aag06 = '2') "
      END IF
      #TQC-D80007--add--end--
      PREPARE gglq900_alz_p2f FROM l_sql 
      EXECUTE gglq900_alz_p2f INTO l_alz13f,l_alz13,l_alz15,
                                  l_alz09f,l_alz09
      IF cl_null(l_alz13f) THEN 
         LET l_alz13f = 0
      END IF 
      IF cl_null(l_alz13) THEN 
         LET l_alz13 = 0
      END IF 
      IF cl_null(l_alz15) THEN 
         LET l_alz15 = 0
      END IF 
      IF cl_null(l_alz09f) THEN 
         LET l_alz09f = 0
      END IF 
      IF cl_null(l_alz09) THEN 
         LET l_alz09 = 0
      END IF 

      #共用條件
      LET l_ted = "SELECT SUM(ted05),SUM(ted06),SUM(ted10),SUM(ted11) FROM ted_file",
                  " WHERE ted00 = '",g_aza.aza81,"'",
                  "   AND ted01 LIKE ? ",                #科目
                  "   AND ted02 = '",l_alz01,"'",        #核算項
                  "   AND ted09 = ? ",  
                  "   AND ted011 = '",tm.a,"'",
                  "   AND ted03 = ",tm.yy

      LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
                  "    AND aba00 = '",g_aza.aza81,"'",
                  "    AND abb03 LIKE ?   ",             #科目
                  "    AND abb11 = '",l_alz01,"'",       #核算項值
                  "    AND aba03 = ",tm.yy,
                  "    AND abb24 = ?   ",
                  "    AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
 
      #當期異動
      LET l_sql1 = l_ted CLIPPED, "   AND ted04 = ? "   #當期
      LET l_sql1 = l_sql1 CLIPPED,
                   " UNION ",
                   #未過帳 - 借
                   " SELECT SUM(abb07),0,SUM(abb07f),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '1' ",
                   "    AND aba04 = ?   ",              #當期未過帳資料
                   " UNION ",
                   #未過帳 - 貸
                   " SELECT 0,SUM(abb07),0,SUM(abb07f) FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '2' ",
                   "    AND aba04 = ?   "               #當期未過帳資料
      PREPARE gglq900_qj_pf FROM l_sql1
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE gglq900_qj_csf CURSOR FOR gglq900_qj_pf
 
      #期初余額
      LET l_sql1 = l_ted CLIPPED, "   AND ted04 < ? "  #期初
      LET l_sql1 = l_sql1 CLIPPED,
                   " UNION ",
                   #未過帳 - 借
                   " SELECT SUM(abb07),0,SUM(abb07f),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '1' ",
                   "    AND aba04 < ?   ",              #期初未過帳資料
                   " UNION ",
                   #未過帳 - 貸
                   " SELECT 0,SUM(abb07),0,SUM(abb07f) FROM aba_file,abb_file ",l_abb CLIPPED,
                   "    AND abb06 = '2' ",
                   "    AND aba04 < ?   "               #期初未過帳資料
     PREPARE gglq900_qc_pf FROM l_sql1
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     DECLARE gglq900_qc_csf CURSOR FOR gglq900_qc_pf

     LET qc_ted05 = 0  #期初
     LET qc_ted06 = 0
     LET qj_ted05 = 0  #期間
     LET qj_ted06 = 0
     LET qc_ted10 = 0  #期初
     LET qc_ted11 = 0
     LET qj_ted10 = 0  #期間
     LET qj_ted11 = 0

     FOREACH gglq900_qc_csf USING l_alz14_str,l_alz10,tm.mm,
                                  l_alz14_str,l_alz10,tm.mm,
                                  l_alz14_str,l_alz10,tm.mm
                             INTO l_ted05,l_ted06,l_ted10,l_ted11
        IF SQLCA.sqlcode THEN
           CALL cl_err('gglq701_ted02_cs foreach:',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        IF cl_null(l_ted05) THEN LET l_ted05 = 0 END IF
        IF cl_null(l_ted06) THEN LET l_ted06 = 0 END IF
        IF cl_null(l_ted10) THEN LET l_ted10 = 0 END IF
        IF cl_null(l_ted11) THEN LET l_ted11 = 0 END IF
        LET qc_ted05 = qc_ted05 + l_ted05
        LET qc_ted06 = qc_ted06 + l_ted06
        LET qc_ted10 = qc_ted10 + l_ted10
        LET qc_ted11 = qc_ted11 + l_ted11
     END FOREACH

     FOREACH gglq900_qj_csf USING l_alz14_str,l_alz10,tm.mm,
                                  l_alz14_str,l_alz10,tm.mm,
                                  l_alz14_str,l_alz10,tm.mm
                             INTO l_ted05,l_ted06,l_ted10,l_ted11
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        IF cl_null(l_ted05) THEN LET l_ted05 = 0 END IF
        IF cl_null(l_ted06) THEN LET l_ted06 = 0 END IF
        IF cl_null(l_ted10) THEN LET l_ted10 = 0 END IF
        IF cl_null(l_ted11) THEN LET l_ted11 = 0 END IF
        LET qj_ted05 = qj_ted05 + l_ted05
        LET qj_ted06 = qj_ted06 + l_ted06
        LET qj_ted10 = qj_ted10 + l_ted10
        LET qj_ted11 = qj_ted11 + l_ted11
     END FOREACH

       

      LET l_aag02 = NULL 
      IF tm.b = '1' THEN    #TQC-D80007 add
         SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = l_alz01  
      #TQC-D80007--add--str--
      ELSE
         SELECT pmc03 INTO l_occ02 FROM pmc_file WHERE pmc01 = l_alz01
      END IF
      #TQC-D80007--add--end--
      SELECT aag02,aag06 INTO l_aag02,l_aag06 
        FROM aag_file 
        WHERE aag00 = g_aza.aza81 
         AND aag01 = l_alz14

      #借余
      IF l_aag06 = '1' THEN 
         LET l_cf = qj_ted10 - qj_ted11
         LET l_c  = qj_ted05 - qj_ted06
         LET l_qcf = qc_ted10 - qc_ted11
         LET l_qc  = qc_ted05  - qc_ted06
         
      END IF 
      #貸余
      IF l_aag06 = '2' THEN 
         LET l_cf = qj_ted11 - qj_ted10
         LET l_c  = qj_ted06 - qj_ted05
         LET l_qcf = qc_ted11 - qc_ted10
         LET l_qc  = qc_ted06  - qc_ted05
      END IF 
      IF cl_null(l_cf) THEN 
         LET l_cf = 0
      END IF  
      IF cl_null(l_c) THEN 
         LET l_c = 0
      END IF
      IF cl_null(l_qcf) THEN 
         LET l_qcf = 0
      END IF
      IF cl_null(l_qc) THEN 
         LET l_qc = 0
      END IF

      #TQC-D80007--add--str--
      IF l_c = 0 AND l_cf = 0 AND l_qc = 0 AND l_qcf = 0 THEN 
         CALL gglq900_qj(l_alz14) RETURNING l_qc,l_qcf,l_c,l_cf 
      END IF 
      #TQC-D80007--add--end--

      #總帳原幣期末餘額
      LET l_df = l_qcf + l_cf
      IF cl_null(l_df) THEN 
         LET l_df = 0
      END IF 

      #總帳本幣期末餘額
      LET l_d  = l_qc  + l_c
      IF cl_null(l_d) THEN 
         LET l_d = 0
      END IF 
      
      #原幣當期發生額差異
      LET l_df_cf = l_cf - l_alz13f
      IF cl_null(l_df_cf) THEN 
         LET l_df_cf = 0
      END IF 

      #本幣當期發生額差異
      LET l_df_c  = l_c  - l_alz13
      IF cl_null(l_df_c) THEN 
         LET l_df_c = 0
      END IF

      #原幣餘額差異
      LET l_df_tf = l_df - l_alz09f
      IF cl_null(l_df_tf) THEN 
         LET l_df_tf = 0
      END IF

      #本幣餘額差異
      LET l_df_t  = l_d  - l_alz09
      IF cl_null(l_df_t) THEN 
         LET l_df_t = 0
      END IF

      INSERT INTO gglq900_tmp 
      VALUES(l_alz01,l_occ02,l_alz14,l_aag02,l_alz10,l_alz13f,l_alz13,
             l_cf,l_c,l_df_cf,l_df_c,l_alz09f,l_alz09,l_df,l_d,
             l_df_tf,l_df_t)
      
   END FOREACH 
END FUNCTION 

#No.FUN-D70072 ---Add--- Start
FUNCTION gglq900_ar_ap2()
   DEFINE  l_alz01       LIKE alz_file.alz01
   DEFINE  l_alz14       LIKE alz_file.alz14
   DEFINE  l_alz14_str   LIKE alz_file.alz14
   DEFINE  l_alz10       LIKE alz_file.alz10
   DEFINE  l_alz13f      LIKE alz_file.alz13f
   DEFINE  l_alz13       LIKE alz_file.alz13
   DEFINE  l_alz09f      LIKE alz_file.alz09f
   DEFINE  l_alz09       LIKE alz_file.alz09
   DEFINE  qj_abb07_1    LIKE abb_file.abb07
   DEFINE  qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qj_abb07_2    LIKE abb_file.abb07
   DEFINE  qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE  qc_abb07_1    LIKE abb_file.abb07
   DEFINE  qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qc_abb07_2    LIKE abb_file.abb07
   DEFINE  qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE  l_aag02       LIKE aag_file.aag02
   DEFINE  l_aag06       LIKE aag_file.aag06
   DEFINE  l_occ02       LIKE occ_file.occ02
   DEFINE  l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE  l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE  l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE  l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE  l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE  l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE  l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE  l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE  l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE  l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE  qc_aed05      LIKE aed_file.aed05  #期初
   DEFINE  qc_aed06      LIKE aed_file.aed06
   DEFINE  qj_aed05      LIKE aed_file.aed05  #期間
   DEFINE  qj_aed06      LIKE aed_file.aed06
   DEFINE  l_aed05       LIKE aed_file.aed05
   DEFINE  l_aed06       LIKE aed_file.aed06
   DEFINE  l_aed         STRING 
   DEFINE  l_npr06f      LIKE npr_file.npr06f
   DEFINE  l_npr07f      LIKE npr_file.npr07f
   DEFINE  l_npr06       LIKE npr_file.npr06
   DEFINE  l_npr07       LIKE npr_file.npr07
   DEFINE  l_npr06f_1    LIKE npr_file.npr06f
   DEFINE  l_npr07f_1    LIKE npr_file.npr07f
   DEFINE  l_npr06_1     LIKE npr_file.npr06
   DEFINE  l_npr07_1     LIKE npr_file.npr07

  #獲取科目/廠商
   LET tm.wc1 = cl_replace_str(tm.wc1,"alz01","aed02")
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","aag01")
   LET l_sql = "SELECT UNIQUE aed02,aag01 FROM aag_file,aed_file ",
               " WHERE aag00 = aed00 AND aed00 = '",g_aza.aza81,"'",
               "   AND ",tm.wc1 CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND aed01 LIKE aag01||'%' ",           #科目
               "   AND aed011 = '1'"
   LET tm.wc1 = cl_replace_str(tm.wc1,"aed02","abb11")
   LET l_sql = l_sql," UNION ",
               " SELECT abb11,aag01 FROM aag_file,aba_file,abb_file",
               "  WHERE aag00 = aba00 AND aba00 = abb00 AND aba01 = abb01 ",
               "    AND ",tm.wc1 CLIPPED,
               "    AND ",tm.wc2 CLIPPED,
               "    AND aba00 = '",g_aza.aza81,"'",
               "    AND abb03 LIKE aag01||'%' ",          #科目
               "    AND abb11 IS NOT NULL"
   PREPARE gglq900_ap2_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ap2_c1 CURSOR FOR gglq900_ap2_p1

  #子系統---期初余額
   LET l_sql ="SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07) ",
               "  FROM npr_file ",
               " WHERE npr00 LIKE ?  AND npr01 = ? ",
               "   AND npr04 = '",tm.yy,"'",
               "   AND npr05 < '",tm.mm,"' ",
               "   AND (npr08 = '",g_plant,"' OR npr08 IS NULL OR npr08 =' ') ",
               "   AND npr09 = '",g_aza.aza81,"'"
   PREPARE gglq900_ap2_p2 FROM l_sql
  #子系統---期間發生額
   LET l_sql ="SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07) ",
               "  FROM npr_file ",
               " WHERE npr00 LIKE ? AND npr01 = ? ",
               "   AND npr04 = ",tm.yy,"'",
               "   AND npr05 = '",tm.mm,"' ",
               "   AND (npr08 = '",g_plant CLIPPED,"' OR npr08 IS NULL OR npr08 =' ')",  
               "   AND npr09 = '",g_aza.aza81,"'"
   PREPARE gglq900_ap2_p3 FROM l_sql 

  #總帳---共用條件
   LET l_aed = "SELECT SUM(aed05),SUM(aed06) FROM aed_file",
               " WHERE aed00 = '",g_aza.aza81,"'",
               "   AND aed01 LIKE ? ",                #科目
               "   AND aed02 = ? ",                   #核算項
               "   AND aed011 = '1'",
               "   AND aed03 = ",tm.yy

   LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
               "    AND aba00 = '",g_aza.aza81,"'",
               "    AND abb03 LIKE ?   ",             #科目
               "    AND abb11  = ? ",    #核算項值
               "    AND aba03 = ",tm.yy,
               "    AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
 
  #當期異動 
   LET l_sql1 = l_aed CLIPPED, " AND aed04 = ? "  #當期
   LET l_sql1 = l_sql1 CLIPPED," UNION ",
               #未過帳 - 借
                " SELECT SUM(abb07),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '1' ",
                "    AND aba04 = ?   ",              #當期未過帳資料
                " UNION ",
               #未過帳 - 貸
                " SELECT 0,SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '2' ",
                "    AND aba04 = ?   "               #當期未過帳資料
   PREPARE gglq900_ap2_p4 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ap2_c3 CURSOR FOR gglq900_ap2_p4
 
  #期初余額
   LET l_sql1 = l_aed CLIPPED, "   AND aed04 < ? "  #期初
   LET l_sql1 = l_sql1 CLIPPED," UNION ",
               #未過帳 - 借
                " SELECT SUM(abb07),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '1' ",
                "    AND aba04 < ?   ",              #期初未過帳資料
                " UNION ",
               #未過帳 - 貸
                " SELECT 0,SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '2' ",
                "    AND aba04 < ?   "               #期初未過帳資料
   PREPARE gglq900_ap2_p5 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ap2_c5 CURSOR FOR gglq900_ap2_p5
   
   FOREACH gglq900_ap2_c1 INTO l_alz01,l_alz14
      LET l_alz14_str = l_alz14 CLIPPED,'\%'
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_ap_c1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF

      SELECT aag02,aag06 INTO l_aag02,l_aag06 
        FROM aag_file 
       WHERE aag00 = g_aza.aza81 
         AND aag01 = l_alz14
      
     #子系統金額
      EXECUTE gglq900_ap2_p2 USING l_alz14_str,l_alz01
                              INTO l_npr06f,l_npr07f,l_npr06,l_npr07
      IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
      IF cl_null(l_npr06 ) THEN LET l_npr06  = 0 END IF
      IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
      IF cl_null(l_npr07 ) THEN LET l_npr07  = 0 END IF
      EXECUTE gglq900_ap2_p3 USING l_alz14_str,l_alz01
                              INTO l_npr06f_1,l_npr07f_1,l_npr06_1,l_npr07_1
      IF cl_null(l_npr06f_1) THEN LET l_npr06f_1 = 0 END IF 
      IF cl_null(l_npr06_1 ) THEN LET l_npr06_1  = 0 END IF
      IF cl_null(l_npr07f_1) THEN LET l_npr07f_1 = 0 END IF 
      IF cl_null(l_npr07_1 ) THEN LET l_npr07_1  = 0 END IF

      IF l_aag06 = '1' THEN
         LET l_alz13f = l_npr06f_1 - l_npr07f_1
         LET l_alz13  = l_npr06_1  - l_npr07_1
         LET l_alz09f = (l_npr06f - l_npr07f) - (l_npr06f_1 - l_npr07f_1)
         LET l_alz09  = (l_npr06  - l_npr07 ) - (l_npr06_1  - l_npr07_1 )
      ELSE
         LET l_alz13f = l_npr07f_1 - l_npr06f_1
         LET l_alz13  = l_npr07_1  - l_npr06_1
         LET l_alz09f = (l_npr07f - l_npr06f) - (l_npr07f_1 - l_npr06f_1)
         LET l_alz09  = (l_npr07  - l_npr06 ) - (l_npr07_1  - l_npr06_1 )
      END IF

      LET qc_aed05 = 0  #期初
      LET qc_aed06 = 0
      LET qj_aed05 = 0  #期間
      LET qj_aed06 = 0

      FOREACH gglq900_ap2_c5 USING l_alz14_str,l_alz01,tm.mm,
                                  l_alz14_str,l_alz01,tm.mm,
                                  l_alz14_str,l_alz01,tm.mm
                             INTO l_aed05,l_aed06
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq900_ap2_c5 foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
         END IF
         IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
         IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF

         LET qc_aed05 = qc_aed05 + l_aed05    
         LET qc_aed06 = qc_aed06 + l_aed06    

      END FOREACH

      FOREACH gglq900_ap2_c3 USING l_alz14_str,l_alz01,tm.mm,
                                   l_alz14_str,l_alz01,tm.mm,
                                   l_alz14_str,l_alz01,tm.mm
                              INTO l_aed05,l_aed06
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq900_ap2_c3 foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         IF cl_null(l_aed05) THEN LET l_aed05 = 0 END IF
         IF cl_null(l_aed06) THEN LET l_aed06 = 0 END IF
         
         LET qj_aed05 = qj_aed05 + l_aed05  
         LET qj_aed06 = qj_aed06 + l_aed06   
      END FOREACH

      LET l_aag02 = NULL 
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = l_alz01  
      SELECT aag02,aag06 INTO l_aag02,l_aag06
        FROM aag_file
        WHERE aag00 = g_aza.aza81
         AND aag01 = l_alz14

      #借余
      IF l_aag06 = '1' THEN 
         LET l_cf = 0
         LET l_c  = qj_aed05  - qj_aed06
         LET l_qcf = 0
         LET l_qc  = qc_aed05  - qc_aed06
      END IF 
      #貸余
      IF l_aag06 = '2' THEN 
         LET l_cf = 0
         LET l_c  = qj_aed06  - qj_aed05
         LET l_qcf = 0
         LET l_qc  = qc_aed06  - qc_aed05
      END IF 
      IF cl_null(l_c) THEN 
         LET l_c = 0
      END IF  
      IF cl_null(l_qc) THEN 
         LET l_qc = 0
      END IF

      #總帳原幣期末餘額
      LET l_df = 0

      #總帳本幣期末餘額
      LET l_d  = l_qc  + l_c
      IF cl_null(l_d) THEN 
         LET l_d = 0
      END IF 
      
      #原幣當期發生額差異
      LET l_df_cf = 0

      #本幣當期發生額差異
      LET l_df_c  = l_c  - l_alz13
      IF cl_null(l_df_c) THEN 
         LET l_df_c = 0
      END IF

      #原幣餘額差異
      LET l_df_tf = 0

      #本幣餘額差異
      LET l_df_t  = l_d  - l_alz09
      IF cl_null(l_df_t) THEN 
         LET l_df_t = 0
      END IF

      IF l_alz13 = 0 AND l_c = 0 AND l_alz09 = 0 AND l_d = 0 THEN CONTINUE FOREACH END IF

      INSERT INTO gglq900_tmp 
      VALUES(l_alz01,l_occ02,l_alz14,l_aag02,'',l_alz13f,l_alz13,
             l_cf,l_c,l_df_cf,l_df_c,l_alz09f,l_alz09,l_df,l_d,
             l_df_tf,l_df_t)
      
   END FOREACH 
END FUNCTION 

FUNCTION gglq900_ar_ap2_1()
   DEFINE  l_alz01       LIKE alz_file.alz01
   DEFINE  l_alz14       LIKE alz_file.alz14
   DEFINE  l_alz14_str   LIKE alz_file.alz14
   DEFINE  l_alz10       LIKE alz_file.alz10
   DEFINE  l_alz13f      LIKE alz_file.alz13f
   DEFINE  l_alz13       LIKE alz_file.alz13
   DEFINE  l_alz09f      LIKE alz_file.alz09f
   DEFINE  l_alz09       LIKE alz_file.alz09
   DEFINE  qj_abb07_1    LIKE abb_file.abb07
   DEFINE  qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qj_abb07_2    LIKE abb_file.abb07
   DEFINE  qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE  qc_abb07_1    LIKE abb_file.abb07
   DEFINE  qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE  qc_abb07_2    LIKE abb_file.abb07
   DEFINE  qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE  l_aag02       LIKE aag_file.aag02
   DEFINE  l_aag06       LIKE aag_file.aag06
   DEFINE  l_occ02       LIKE occ_file.occ02
   DEFINE  l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE  l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE  l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE  l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE  l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE  l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE  l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE  l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE  l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE  l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE  qc_aed05      LIKE aed_file.aed05  #期初
   DEFINE  qc_aed06      LIKE aed_file.aed06
   DEFINE  qj_aed05      LIKE aed_file.aed05  #期間
   DEFINE  qj_aed06      LIKE aed_file.aed06
   DEFINE  l_aed05       LIKE aed_file.aed05
   DEFINE  l_aed06       LIKE aed_file.aed06
   DEFINE  l_aed         STRING 
   DEFINE  qc_ted05      LIKE ted_file.ted05    #期初
   DEFINE  qc_ted06      LIKE ted_file.ted06
   DEFINE  qj_ted05      LIKE ted_file.ted05    #期間
   DEFINE  qj_ted06      LIKE ted_file.ted06
   DEFINE  qc_ted10      LIKE ted_file.ted10    #期初
   DEFINE  qc_ted11      LIKE ted_file.ted11
   DEFINE  qj_ted10      LIKE ted_file.ted10    #期間
   DEFINE  qj_ted11      LIKE ted_file.ted11
   DEFINE  l_ted05       LIKE ted_file.ted05
   DEFINE  l_ted06       LIKE ted_file.ted06
   DEFINE  l_ted10       LIKE ted_file.ted10 
   DEFINE  l_ted11       LIKE ted_file.ted11
   DEFINE  l_ted         STRING 
   DEFINE  l_npr06f      LIKE npr_file.npr06f
   DEFINE  l_npr07f      LIKE npr_file.npr07f
   DEFINE  l_npr06       LIKE npr_file.npr06
   DEFINE  l_npr07       LIKE npr_file.npr07
   DEFINE  l_npr06f_1    LIKE npr_file.npr06f
   DEFINE  l_npr07f_1    LIKE npr_file.npr07f
   DEFINE  l_npr06_1     LIKE npr_file.npr06
   DEFINE  l_npr07_1     LIKE npr_file.npr07

  #獲取科目/廠商
   LET tm.wc1 = cl_replace_str(tm.wc1,"alz01","ted02")
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","aag01")
   LET l_sql = "SELECT UNIQUE ted02,aag01,ted09 FROM aag_file,ted_file ",
               " WHERE aag00 = ted00 AND ted00 = '",g_aza.aza81,"'",
               "   AND ",tm.wc1 CLIPPED,
               "   AND ",tm.wc2 CLIPPED,
               "   AND ted01 LIKE aag01||'%' ",           #科目
               "   AND ted011 = '1'"
   LET tm.wc1 = cl_replace_str(tm.wc1,"ted02","abb11")
   LET l_sql = l_sql," UNION ",
               " SELECT abb11,aag01,abb24 FROM aag_file,aba_file,abb_file",
               "  WHERE aag00 = aba00 AND aba00 = abb00 AND aba01 = abb01 ",
               "    AND ",tm.wc1 CLIPPED,
               "    AND ",tm.wc2 CLIPPED,
               "    AND aba00 = '",g_aza.aza81,"'",
               "    AND abb03 LIKE aag01||'%' ",          #科目
               "    AND abb11 IS NOT NULL"
   PREPARE gglq900_ap2_p1f FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ap2_c1f CURSOR FOR gglq900_ap2_p1f

  #子系統---期初余額
   LET l_sql ="SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07) ",
               "  FROM npr_file ",
               " WHERE npr00 LIKE ?  AND npr01 = ? ",
               "   AND npr04 = '",tm.yy,"'",
               "   AND npr05 < '",tm.mm,"' ",
               "   AND npr11 = ?",
               "   AND (npr08 = '",g_plant,"' OR npr08 IS NULL OR npr08 =' ') ",
               "   AND npr09 = '",g_aza.aza81,"'"
   PREPARE gglq900_ap2_p2f FROM l_sql
  #子系統---期間發生額
   LET l_sql ="SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07) ",
               "  FROM npr_file ",
               " WHERE npr00 LIKE ? AND npr01 = ? ",
               "   AND npr04 = ",tm.yy,"'",
               "   AND npr05 = '",tm.mm,"' ",
               "   AND npr11 = ?",
               "   AND (npr08 = '",g_plant CLIPPED,"' OR npr08 IS NULL OR npr08 =' ')",  
               "   AND npr09 = '",g_aza.aza81,"'"
   PREPARE gglq900_ap2_p3f FROM l_sql 

  #總帳---共用條件
   LET l_aed = "SELECT SUM(ted05),SUM(ted06),SUM(ted10),SUM(ted11) FROM ted_file",
               " WHERE ted00 = '",g_aza.aza81,"'",
               "   AND ted01 LIKE ? ",                #科目
               "   AND ted02 = ? ",                   #核算項
               "   AND ted011 = '1'",
               "   AND ted09 = ?",
               "   AND ted03 = ",tm.yy

   LET l_abb = "  WHERE aba00 = abb00 AND aba01 = abb01 ",
               "    AND aba00 = '",g_aza.aza81,"'",
               "    AND abb03 LIKE ?   ",             #科目
               "    AND abb11  = ? ",    #核算項值
               "    AND abb24 = ? ",
               "    AND aba03 = ",tm.yy,
               "    AND (aba19 = 'N' OR ( aba19 ='Y' and abapost = 'N'))"
 
  #當期異動 
   LET l_sql1 = l_aed CLIPPED, " AND ted04 = ? "  #當期
   LET l_sql1 = l_sql1 CLIPPED," UNION ",
               #未過帳 - 借
                " SELECT SUM(abb07),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '1' ",
                "    AND aba04 = ?   ",              #當期未過帳資料
                " UNION ",
               #未過帳 - 貸
                " SELECT 0,SUM(abb07) FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '2' ",
                "    AND aba04 = ?   "               #當期未過帳資料
   PREPARE gglq900_ap2_p4f FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ap2_c3f CURSOR FOR gglq900_ap2_p4f
 
  #期初余額
   LET l_sql1 = l_aed CLIPPED, "   AND ted04 < ? "  #期初
   LET l_sql1 = l_sql1 CLIPPED," UNION ",
               #未過帳 - 借
                " SELECT SUM(abb07),0,SUM(abb07f),0 FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '1' ",
                "    AND aba04 < ?   ",              #期初未過帳資料
                " UNION ",
               #未過帳 - 貸
                " SELECT 0,SUM(abb07),0,SUM(abb07f) FROM aba_file,abb_file ",l_abb CLIPPED,
                "    AND abb06 = '2' ",
                "    AND aba04 < ?   "               #期初未過帳資料
   PREPARE gglq900_ap2_p5f FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_ap2_c5f CURSOR FOR gglq900_ap2_p5f
   
   FOREACH gglq900_ap2_c1f INTO l_alz01,l_alz14,l_alz10
      LET l_alz14_str = l_alz14 CLIPPED,'\%'
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_ap_c1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF

      SELECT aag02,aag06 INTO l_aag02,l_aag06 
        FROM aag_file 
       WHERE aag00 = g_aza.aza81 
         AND aag01 = l_alz14
      
     #子系統金額
      EXECUTE gglq900_ap2_p2f USING l_alz14_str,l_alz01,l_alz10
                               INTO l_npr06f,l_npr07f,l_npr06,l_npr07
      IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
      IF cl_null(l_npr06 ) THEN LET l_npr06  = 0 END IF
      IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
      IF cl_null(l_npr07 ) THEN LET l_npr07  = 0 END IF
      EXECUTE gglq900_ap2_p3f USING l_alz14_str,l_alz01,l_alz10
                               INTO l_npr06f_1,l_npr07f_1,l_npr06_1,l_npr07_1
      IF cl_null(l_npr06f_1) THEN LET l_npr06f_1 = 0 END IF 
      IF cl_null(l_npr06_1 ) THEN LET l_npr06_1  = 0 END IF
      IF cl_null(l_npr07f_1) THEN LET l_npr07f_1 = 0 END IF 
      IF cl_null(l_npr07_1 ) THEN LET l_npr07_1  = 0 END IF

      IF l_aag06 = '1' THEN
         LET l_alz13f = l_npr06f_1 - l_npr07f_1
         LET l_alz13  = l_npr06_1  - l_npr07_1
         LET l_alz09f = (l_npr06f - l_npr07f) - (l_npr06f_1 - l_npr07f_1)
         LET l_alz09  = (l_npr06  - l_npr07 ) - (l_npr06_1  - l_npr07_1 )
      ELSE
         LET l_alz13f = l_npr07f_1 - l_npr06f_1
         LET l_alz13  = l_npr07_1  - l_npr06_1
         LET l_alz09f = (l_npr07f - l_npr06f) - (l_npr07f_1 - l_npr06f_1)
         LET l_alz09  = (l_npr07  - l_npr06 ) - (l_npr07_1  - l_npr06_1 )
      END IF

     LET qc_ted05 = 0  #期初
     LET qc_ted06 = 0
     LET qj_ted05 = 0  #期間
     LET qj_ted06 = 0
     LET qc_ted10 = 0  #期初
     LET qc_ted11 = 0
     LET qj_ted10 = 0  #期間
     LET qj_ted11 = 0

      FOREACH gglq900_ap2_c5f USING l_alz14_str,l_alz01,l_alz10,tm.mm,
                                    l_alz14_str,l_alz01,l_alz10,tm.mm,
                                    l_alz14_str,l_alz01,l_alz10,tm.mm
                               INTO l_ted05,l_ted06,l_ted10,l_ted11
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq900_ap2_c5 foreach:',SQLCA.sqlcode,0)
             EXIT FOREACH
         END IF
         IF cl_null(l_ted05) THEN LET l_ted05 = 0 END IF
         IF cl_null(l_ted06) THEN LET l_ted06 = 0 END IF
         IF cl_null(l_ted10) THEN LET l_ted10 = 0 END IF
         IF cl_null(l_ted11) THEN LET l_ted11 = 0 END IF
         LET qc_ted05 = qc_ted05 + l_ted05
         LET qc_ted06 = qc_ted06 + l_ted06
         LET qc_ted10 = qc_ted10 + l_ted10
         LET qc_ted11 = qc_ted11 + l_ted11
      END FOREACH

      FOREACH gglq900_ap2_c3 USING l_alz14_str,l_alz01,l_alz10,tm.mm,
                                   l_alz14_str,l_alz01,l_alz10,tm.mm,
                                   l_alz14_str,l_alz01,l_alz10,tm.mm
                              INTO l_ted05,l_ted06,l_ted10,l_ted11
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq900_ap2_c3 foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
         END IF
         IF cl_null(l_ted05) THEN LET l_ted05 = 0 END IF
         IF cl_null(l_ted06) THEN LET l_ted06 = 0 END IF
         IF cl_null(l_ted10) THEN LET l_ted10 = 0 END IF
         IF cl_null(l_ted11) THEN LET l_ted11 = 0 END IF
         LET qj_ted05 = qj_ted05 + l_ted05
         LET qj_ted06 = qj_ted06 + l_ted06
         LET qj_ted10 = qj_ted10 + l_ted10
         LET qj_ted11 = qj_ted11 + l_ted11
      END FOREACH

      LET l_aag02 = NULL 
      SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = l_alz01  
      SELECT aag02,aag06 INTO l_aag02,l_aag06
        FROM aag_file
        WHERE aag00 = g_aza.aza81
         AND aag01 = l_alz14

      #借余
      IF l_aag06 = '1' THEN 
         LET l_cf = qj_ted10 - qj_ted11
         LET l_c  = qj_ted05 - qj_ted06
         LET l_qcf = qc_ted10 - qc_ted11
         LET l_qc  = qc_ted05  - qc_ted06
      END IF 
      #貸余
      IF l_aag06 = '2' THEN 
         LET l_cf = qj_ted11 - qj_ted10
         LET l_c  = qj_ted06 - qj_ted05
         LET l_qcf = qc_ted11 - qc_ted10
         LET l_qc  = qc_ted06  - qc_ted05
      END IF 
      IF cl_null(l_cf) THEN 
         LET l_cf = 0
      END IF  
      IF cl_null(l_c) THEN 
         LET l_c = 0
      END IF
      IF cl_null(l_qcf) THEN 
         LET l_qcf = 0
      END IF
      IF cl_null(l_qc) THEN 
         LET l_qc = 0
      END IF

      #總帳原幣期末餘額
      LET l_df = l_qcf + l_cf
      IF cl_null(l_df) THEN 
         LET l_df = 0
      END IF 

      #總帳本幣期末餘額
      LET l_d  = l_qc  + l_c
      IF cl_null(l_d) THEN 
         LET l_d = 0
      END IF 
      
      #原幣當期發生額差異
      LET l_df_cf = 0

      #本幣當期發生額差異
      LET l_df_c  = l_c  - l_alz13
      IF cl_null(l_df_c) THEN 
         LET l_df_c = 0
      END IF

      #原幣餘額差異
      LET l_df_tf = l_df - l_alz09f
      IF cl_null(l_df_tf) THEN 
         LET l_df_tf = 0
      END IF

      #本幣餘額差異
      LET l_df_t  = l_d  - l_alz09
      IF cl_null(l_df_t) THEN 
         LET l_df_t = 0
      END IF
      
      IF l_alz13 = 0 AND l_c = 0 AND l_alz09 = 0 AND l_d = 0 THEN CONTINUE FOREACH END IF

      INSERT INTO gglq900_tmp 
      VALUES(l_alz01,l_occ02,l_alz14,l_aag02,l_alz10,l_alz13f,l_alz13,
             l_cf,l_c,l_df_cf,l_df_c,l_alz09f,l_alz09,l_df,l_d,
             l_df_tf,l_df_t)
      
   END FOREACH 
END FUNCTION 
#No.FUN-D70072 ---Add--- End

FUNCTION gglq900_nm()
   DEFINE l_nmp04       LIKE nmp_file.nmp04
   DEFINE l_nmp05       LIKE nmp_file.nmp05
   DEFINE l_nmp06       LIKE nmp_file.nmp06
   DEFINE l_nmp07       LIKE nmp_file.nmp07
   DEFINE l_nmp08       LIKE nmp_file.nmp08
   DEFINE l_nmp09       LIKE nmp_file.nmp09
   DEFINE l_nma05       LIKE nma_file.nma05
   DEFINE l_nma_str     LIKE nma_file.nma05
   DEFINE qj_nmpf       LIKE nmp_file.nmp04     #原幣當期發生額
   DEFINE qj_nmp        LIKE nmp_file.nmp07     #本幣當期發生額
   DEFINE qm_nmpf       LIKE nmp_file.nmp06     #原幣期末餘額
   DEFINE qm_nmp        LIKE nmp_file.nmp09     #本幣期末餘額
   DEFINE qj_abb07_1    LIKE abb_file.abb07
   DEFINE qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE qj_abb07_2    LIKE abb_file.abb07
   DEFINE qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE qc_abb07_1    LIKE abb_file.abb07
   DEFINE qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE qc_abb07_2    LIKE abb_file.abb07
   DEFINE qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_abb24       LIKE abb_file.abb24
   DEFINE l_aah041      LIKE aah_file.aah04
   DEFINE l_aah042      LIKE aah_file.aah04
   DEFINE l_aah051      LIKE aah_file.aah05
   DEFINE l_aah052      LIKE aah_file.aah05
   DEFINE l_tah091      LIKE tah_file.tah09
   DEFINE l_tah092      LIKE tah_file.tah09
   DEFINE l_tah101      LIKE tah_file.tah10
   DEFINE l_tah102      LIKE tah_file.tah10
   DEFINE qc_aah04      LIKE aah_file.aah04
   DEFINE qc_aah05      LIKE aah_file.aah05
   DEFINE qc_tah09      LIKE tah_file.tah09
   DEFINE qc_tah10      LIKE tah_file.tah10
   DEFINE qj_aah04      LIKE aah_file.aah04
   DEFINE qj_aah05      LIKE aah_file.aah05
   DEFINE qj_tah09      LIKE tah_file.tah09
   DEFINE qj_tah10      LIKE tah_file.tah10
   DEFINE qm_aah04      LIKE aah_file.aah04
   DEFINE qm_aah05      LIKE aah_file.aah05
   DEFINE qm_tah09      LIKE tah_file.tah09
   DEFINE qm_tah10      LIKE tah_file.tah10

   CALL gglq900_curs() 
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","nma05") 
   LET l_sql = "SELECT SUM(nmp04),SUM(nmp05),SUM(nmp06),SUM(nmp07),SUM(nmp08), ",
               "       SUM(nmp09),nma05 ",
               "  FROM nmp_file,nma_file ",
               " WHERE nmp01 = nma01 ",
               "   AND nmp02 = '",tm.yy,"'",
               "   AND nmp03 = '",tm.mm,"'",
               "   AND ",tm.wc2 CLIPPED,
               " GROUP BY nma05"
   PREPARE gglq900_nmp_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_nmp_cs1 CURSOR FOR gglq900_nmp_p1
   FOREACH gglq900_nmp_cs1 INTO l_nmp04,l_nmp05,l_nmp06,l_nmp07,l_nmp08,l_nmp09,l_nma05
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_nmp_cs1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF

      LET l_nma_str = l_nma05 CLIPPED,'\%'

      IF tm.e = 'Y' THEN 
         FOREACH gglq900_abb24_cs USING l_nma_str,l_nma_str INTO l_abb24
            #原币，本币期初
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqc_cs USING l_nma05,l_abb24
            FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqc_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

            #借
            OPEN gglq900_ybqc_cs2 USING l_nma_str,'1',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqc_cs2 USING l_nma_str,'2',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

            LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
            LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
            LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
            LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

            #原币，本币期间
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0           
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqj_cs USING l_nma05,l_abb24
            FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqj_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 
 
            #借
            OPEN gglq900_ybqj_cs2 USING l_nma_str,'1',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqj_cs2 USING l_nma_str,'2',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052
            LET qj_tah09 = l_tah091 + l_tah092
            LET qj_tah10 = l_tah101 + l_tah102

            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05
            LET qm_tah09 = qc_tah09 + qj_tah09
            LET qm_tah10 = qc_tah10 + qj_tah10

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_nma05

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
            END IF
            IF cl_null(l_qc) THEN 
               LET l_qc = 0
            END IF 
            IF cl_null(l_qcf) THEN 
               LET l_qcf = 0
            END IF 
            IF cl_null(l_c) THEN 
               LET l_c = 0
            END IF 
            IF cl_null(l_cf) THEN 
               LET l_cf = 0
            END IF 
            IF cl_null(l_d) THEN 
               LET l_d = 0
            END IF 
            IF cl_null(l_df) THEN 
               LET l_df = 0
            END IF 
         
         
            LET qj_nmpf = l_nmp04 - l_nmp05        #原幣當期發生額
            IF cl_null(qj_nmpf) THEN 
               LET qj_nmpf = 0
            END IF 
            LET qj_nmp  = l_nmp07 - l_nmp08        #本幣當期發生額
            IF cl_null(qj_nmp) THEN 
               LET qj_nmp = 0
            END IF
            LET qm_nmpf = l_nmp06                  #原幣期末餘額
            IF cl_null(qm_nmpf) THEN 
               LET qm_nmpf = 0
            END IF
            LET qm_nmp  = l_nmp09                  #本幣期末餘額
            IF cl_null(qm_nmp) THEN 
               LET qm_nmp = 0
            END IF
            LET l_df_c  = l_c  - qj_nmp            #本幣當期發生額差異
            IF cl_null(l_df_c) THEN 
               LET l_df_c = 0
            END IF
            LET l_df_cf = l_cf - qj_nmpf           #原幣當期發生額差異
            IF cl_null(l_df_cf) THEN 
               LET l_df_cf = 0
            END IF
            LET l_df_t  = l_d  - qm_nmp            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_nmpf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES('','',l_nma05,l_aag02,l_abb24,qj_nmpf,qj_nmp,
                   l_cf,l_c,l_df_cf,l_df_c,qm_nmp,qm_nmp,l_df,l_d,
                   l_df_tf,l_df_t)
         END FOREACH  
      ELSE
         #期初值
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qc_cs1 USING l_nma05
         FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qc_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qc_cs2 USING l_nma_str,'1'
         FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qc_cs2 USING l_nma_str,'2'
         FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qc_aah04 = l_aah041 + l_aah042
         LET qc_aah05 = l_aah051 + l_aah052

         #期間
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qj_cs1 USING l_nma05
         FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qj_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qj_cs2 USING l_nma_str,'1'
         FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qj_cs2 USING l_nma_str,'2'
         FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052

         #期末
         LET qm_aah04 = qc_aah04 + qj_aah04
         LET qm_aah05 = qc_aah05 + qj_aah05

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = l_nma05

         #借余
         IF l_aag06 = '1' THEN 
            LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF

         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_d) THEN 
            LET l_d = 0
         END IF 
         
         
         LET qj_nmpf = l_nmp04 - l_nmp05        #原幣當期發生額
         IF cl_null(qj_nmpf) THEN 
            LET qj_nmpf = 0
         END IF 
         LET qj_nmp  = l_nmp07 - l_nmp08        #本幣當期發生額
         IF cl_null(qj_nmp) THEN 
            LET qj_nmp = 0
         END IF
         LET qm_nmpf = l_nmp06                  #原幣期末餘額
         IF cl_null(qm_nmpf) THEN 
            LET qm_nmpf = 0
         END IF
         LET qm_nmp  = l_nmp09                  #本幣期末餘額
         IF cl_null(qm_nmp) THEN 
            LET qm_nmp = 0
         END IF
         LET l_df_c  = l_c  - qj_nmp            #本幣當期發生額差異
         IF cl_null(l_df_c) THEN 
            LET l_df_c = 0
         END IF
         LET l_df_cf = l_cf - qj_nmpf           #原幣當期發生額差異
         IF cl_null(l_df_cf) THEN 
            LET l_df_cf = 0
         END IF
         LET l_df_t  = l_d  - qm_nmp            #本幣餘額差異
         IF cl_null(l_df_t) THEN 
            LET l_df_t = 0
         END IF
         LET l_df_tf = l_df - qm_nmpf           #原幣餘額差異
         IF cl_null(l_df_tf) THEN 
            LET l_df_tf = 0
         END IF

         INSERT INTO gglq900_tmp 
         VALUES('','',l_nma05,l_aag02,'',qj_nmpf,qj_nmp,
                l_cf,l_c,l_df_cf,l_df_c,qm_nmp,qm_nmp,l_df,l_d,
                l_df_tf,l_df_t)
      END IF 
   END FOREACH 
END FUNCTION 


#No.FUN-D70072 ---Add--- Start
FUNCTION gglq900_nm21()
   DEFINE l_nmp04       LIKE nmp_file.nmp04
   DEFINE l_nmp05       LIKE nmp_file.nmp05
   DEFINE l_nmp06       LIKE nmp_file.nmp06
   DEFINE l_nmp07       LIKE nmp_file.nmp07
   DEFINE l_nmp08       LIKE nmp_file.nmp08
   DEFINE l_nmp09       LIKE nmp_file.nmp09
   DEFINE l_nma05       LIKE nma_file.nma05
   DEFINE l_nma_str     LIKE nma_file.nma05
   DEFINE qj_nmpf       LIKE nmp_file.nmp04     #原幣當期發生額
   DEFINE qj_nmp        LIKE nmp_file.nmp07     #本幣當期發生額
   DEFINE qm_nmpf       LIKE nmp_file.nmp06     #原幣期末餘額
   DEFINE qm_nmp        LIKE nmp_file.nmp09     #本幣期末餘額
   DEFINE qj_abb07_1    LIKE abb_file.abb07
   DEFINE qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE qj_abb07_2    LIKE abb_file.abb07
   DEFINE qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE qc_abb07_1    LIKE abb_file.abb07
   DEFINE qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE qc_abb07_2    LIKE abb_file.abb07
   DEFINE qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_abb24       LIKE abb_file.abb24
   DEFINE l_aah041      LIKE aah_file.aah04
   DEFINE l_aah042      LIKE aah_file.aah04
   DEFINE l_aah051      LIKE aah_file.aah05
   DEFINE l_aah052      LIKE aah_file.aah05
   DEFINE l_tah091      LIKE tah_file.tah09
   DEFINE l_tah092      LIKE tah_file.tah09
   DEFINE l_tah101      LIKE tah_file.tah10
   DEFINE l_tah102      LIKE tah_file.tah10
   DEFINE qc_aah04      LIKE aah_file.aah04
   DEFINE qc_aah05      LIKE aah_file.aah05
   DEFINE qc_tah09      LIKE tah_file.tah09
   DEFINE qc_tah10      LIKE tah_file.tah10
   DEFINE qj_aah04      LIKE aah_file.aah04
   DEFINE qj_aah05      LIKE aah_file.aah05
   DEFINE qj_tah09      LIKE tah_file.tah09
   DEFINE qj_tah10      LIKE tah_file.tah10
   DEFINE qm_aah04      LIKE aah_file.aah04
   DEFINE qm_aah05      LIKE aah_file.aah05
   DEFINE qm_tah09      LIKE tah_file.tah09
   DEFINE qm_tah10      LIKE tah_file.tah10
   DEFINE sr               RECORD
                                  nma01 LIKE nma_file.nma01, #銀行編號
                                  nma02 LIKE nma_file.nma02, #銀行全名
                                  nma05 LIKE nma_file.nma05, #科目
                                  nma10 LIKE nma_file.nma10, #幣別
                                  rest1 LIKE nme_file.nme04, #原幣 餘額
                                  rest2 LIKE nme_file.nme04  #本幣 餘額
                        END RECORD
   DEFINE l_mm          LIKE type_file.num5
   DEFINE l_yy          LIKE type_file.num5
   DEFINE l_azi04_1     LIKE azi_file.azi04
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE bal01         LIKE npg_file.npg16
   DEFINE bal02         LIKE npg_file.npg19
   DEFINE l_nme07       LIKE nme_file.nme07
   DEFINE l_nme12       LIKE nme_file.nme12
   DEFINE l_count       LIKE type_file.num5
   DEFINE bal1          LIKE nmp_file.nmp16
   DEFINE bal2          LIKE nmp_file.nmp19
   DEFINE l_d1          LIKE nme_file.nme04
   DEFINE l_c1          LIKE nme_file.nme04
   DEFINE l_d2          LIKE nme_file.nme08
   DEFINE l_c2          LIKE nme_file.nme08
   DEFINE l_bdate       LIKE type_file.dat
   DEFINE l_edate       LIKE type_file.dat

   CALL gglq900_curs() 
   LET l_mm = tm.mm - 1
   LET l_yy = tm.yy
   IF l_mm = 0 THEN LET l_yy = tm.yy - 1 LET l_mm = 12 END IF
   CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
   
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","nma05") 
   LET l_sql = "SELECT '','',nma05,nma10,0,0 FROM nma_file",
               " WHERE ", tm.wc2 CLIPPED
   PREPARE gglq900_nmp_p21 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   DECLARE gglq900_nmp_cs21 CURSOR FOR gglq900_nmp_p21
   FOREACH gglq900_nmp_cs21 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_nmp_cs21 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF

      SELECT nma01,nma02 INTO sr.nma01,sr.nma02 FROM nma_file
       WHERE nma05 = sr.nma05
         AND nma10 = sr.nma10

      LET l_nma_str = sr.nma05 CLIPPED,'\%'

      SELECT azi04 INTO l_azi04_1 FROM azi_file WHERE azi01 = sr.nma10   
       
      LET l_cnt = 0  
      SELECT COUNT(*) INTO l_cnt FROM npg_file
       WHERE npg01 = sr.nma01 AND npg02 = g_yy0 AND npg03 = g_mm0
      IF cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF

     #將npg_file開帳資料納入本月存款資料呈現
      LET bal01=0  LET bal02=0
      SELECT SUM(npg16),SUM(npg19) INTO bal01,bal02
        FROM npg_file
       WHERE npg01 = sr.nma01 AND npg02 = g_yy0 AND npg03 = g_mm0                                               
      IF bal01 IS NULL OR bal01 = ' ' THEN LET bal01 = 0 END IF                                                                       
      IF bal02 IS NULL OR bal02 = ' ' THEN LET bal02 = 0 END IF          
        
      IF g_nmz.nmz20 = 'Y' THEN
         LET l_sql = "SELECT nme12 FROM nme_file",
                          " WHERE nme01 = '",sr.nma01,"'",
                          "   AND MONTH(nme16) <= '",tm.mm,"'",
                          "   AND nme12 IS NOT NULL",
                          " ORDER BY nme16 DESC"
         PREPARE r322_prepare08 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('r322_prepare08:',SQLCA.sqlcode,1)
            CALL cl_used(g_prog,g_time,2) RETURNING g_time
            EXIT PROGRAM
         END IF
         DECLARE r322_nme12 CURSOR FOR r322_prepare08
         
         LET l_nme07 = ''
         FOREACH r322_nme12 INTO l_nme12 
            WHILE cl_null(l_nme07)
               LET l_sql = "SELECT COUNT(*) FROM oox_file",
                             " WHERE oox00 = 'NM' AND oox01 <= '",tm.yy,"'",
                             "   AND cast(oox02 AS decimal(8,2)) <= '",tm.mm,"'", 
                             "   AND oox03 = '",l_nme12,"'",
                             "   AND oox04 = '0'",
                             "   AND oox041 = '0'"                             
               PREPARE r322_prepare7 FROM l_sql
               DECLARE r322_oox7 CURSOR FOR r322_prepare7
               OPEN r322_oox7
               FETCH r322_oox7 INTO l_count
               CLOSE r322_oox7                       
               IF l_count = 0 THEN
                  EXIT WHILE     
               ELSE                  
                  LET l_sql = "SELECT oox07 FROM oox_file",             
                                " WHERE oox00 = 'NM' AND oox01 = '",tm.yy,"'",
                                "   AND oox02 = '",tm.mm,"'",
                                "   AND oox03 = '",l_nme12,"'",
                                "   AND oox04 = '0'",
                                "   AND oox041 = '0'"
               END IF                  
               IF tm.mm = '01' THEN
                  LET tm.mm = '12'
                  LET tm.yy = tm.yy-1
               ELSE    
                  LET tm.mm = tm.mm-1
               END IF            
               
               IF l_count <> 0 THEN        
                  PREPARE r322_prepare07 FROM l_sql
                  DECLARE r322_oox07 CURSOR FOR r322_prepare07
                  OPEN r322_oox07
                  FETCH r322_oox07 INTO l_nme07
                  CLOSE r322_oox07
               END IF      
            END WHILE
            IF NOT cl_null(l_nme07) THEN EXIT FOREACH END IF
         END FOREACH
      END IF       

      SELECT SUM(nmp16),SUM(nmp19) INTO bal1,bal2 FROM nmp_file
       WHERE nmp01 = sr.nma01 AND nmp02 = g_yy AND nmp03 = g_mm
              
      IF g_nmz.nmz20 = 'Y' AND l_nme07 != '1' THEN  
         LET bal2 = bal1 * l_nme07
      END IF          
      IF bal1 IS NULL OR bal1 = ' ' THEN LET bal1 = 0 END IF
      IF bal2 IS NULL OR bal2 = ' ' THEN LET bal2 = 0 END IF    
      SELECT SUM(nme04),SUM(nme08) INTO l_d1,l_d2 FROM nme_file,nmc_file
       WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '1'
         AND nme16 BETWEEN l_bdate AND l_edate
      SELECT SUM(nme04),SUM(nme08) INTO l_c1,l_c2 FROM nme_file,nmc_file
       WHERE nme01 = sr.nma01 AND nme03 = nmc01 AND nmc03 = '2'
         AND nme16 BETWEEN l_bdate AND l_edate
      IF g_nmz.nmz20 = 'Y' AND l_nme07 != '1' THEN  
         LET l_d2 = l_d1 * l_nme07
         LET l_c2 = l_c1 * l_nme07
      END IF          
       
      IF l_d1 IS NULL THEN LET l_d1 = 0 END IF
      IF l_d2 IS NULL THEN LET l_d2 = 0 END IF
      IF l_c1 IS NULL THEN LET l_c1 = 0 END IF
      IF l_c2 IS NULL THEN LET l_c2 = 0 END IF

      IF l_cnt > 0 THEN
         LET l_d1 = 0
         LET l_c1 = 0
         LET l_d2 = 0
         LET l_c2 = 0
      END IF 

     #期末餘額
      LET sr.rest1 = bal1 + l_d1 - l_c1 + bal01  
      LET sr.rest2 = bal2 + l_d2 - l_c2 + bal02      
      
      IF tm.e = 'Y' THEN 
         FOREACH gglq900_abb24_cs USING l_nma_str,l_nma_str INTO l_abb24
            #原币，本币期初
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqc_cs USING sr.nma05,l_abb24
            FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqc_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

            #借
            OPEN gglq900_ybqc_cs2 USING l_nma_str,'1',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqc_cs2 USING l_nma_str,'2',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

            LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
            LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
            LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
            LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

            #原币，本币期间
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0           
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqj_cs USING sr.nma05,l_abb24
            FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqj_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 
 
            #借
            OPEN gglq900_ybqj_cs2 USING l_nma_str,'1',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqj_cs2 USING l_nma_str,'2',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052
            LET qj_tah09 = l_tah091 + l_tah092
            LET qj_tah10 = l_tah101 + l_tah102

            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05
            LET qm_tah09 = qc_tah09 + qj_tah09
            LET qm_tah10 = qc_tah10 + qj_tah10

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = sr.nma05

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
            END IF
            IF cl_null(l_qc)  THEN LET l_qc = 0  END IF 
            IF cl_null(l_qcf) THEN LET l_qcf = 0 END IF 
            IF cl_null(l_c) THEN   LET l_c = 0   END IF 
            IF cl_null(l_cf) THEN  LET l_cf = 0  END IF 
            IF cl_null(l_d) THEN   LET l_d = 0   END IF 
            IF cl_null(l_df) THEN  LET l_df = 0  END IF 
         
            LET qm_nmpf = sr.rest1                 #原幣期末餘額
            IF cl_null(qm_nmpf) THEN 
               LET qm_nmpf = 0
            END IF
            LET qm_nmp  = sr.rest2                 #本幣期末餘額
            IF cl_null(qm_nmp) THEN 
               LET qm_nmp = 0
            END IF
            LET l_df_t  = l_d  - qm_nmp            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_nmpf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES(sr.nma01,sr.nma02,sr.nma05,l_aag02,l_abb24,0,0,
                   0,0,0,0,qm_nmp,qm_nmp,l_df,l_d,
                   l_df_tf,l_df_t)
         END FOREACH  
      ELSE
         #期初值
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qc_cs1 USING sr.nma05
         FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qc_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qc_cs2 USING l_nma_str,'1'
         FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qc_cs2 USING l_nma_str,'2'
         FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qc_aah04 = l_aah041 + l_aah042
         LET qc_aah05 = l_aah051 + l_aah052

         #期間
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qj_cs1 USING sr.nma05
         FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qj_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qj_cs2 USING l_nma_str,'1'
         FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qj_cs2 USING l_nma_str,'2'
         FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052

         #期末
         LET qm_aah04 = qc_aah04 + qj_aah04
         LET qm_aah05 = qc_aah05 + qj_aah05

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = sr.nma05

         #借余
         IF l_aag06 = '1' THEN 
            LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF

         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_d) THEN 
            LET l_d = 0
         END IF 

         LET qm_nmpf = sr.rest1                 #原幣期末餘額
         IF cl_null(qm_nmpf) THEN 
            LET qm_nmpf = 0
         END IF
         LET qm_nmp  = sr.rest2                 #本幣期末餘額
         IF cl_null(qm_nmp) THEN 
            LET qm_nmp = 0
         END IF
         LET l_df_t  = l_d  - qm_nmp            #本幣餘額差異
         IF cl_null(l_df_t) THEN 
            LET l_df_t = 0
         END IF
         LET l_df_tf = l_df - qm_nmpf           #原幣餘額差異
         IF cl_null(l_df_tf) THEN 
            LET l_df_tf = 0
         END IF

         INSERT INTO gglq900_tmp 
         VALUES(sr.nma01,sr.nma02,sr.nma05,l_aag02,'',0,0,
                0,0,0,0,qm_nmp,qm_nmp,l_df,l_d,
                l_df_tf,l_df_t)
      END IF 
   END FOREACH 
END FUNCTION 

FUNCTION gglq900_nm22()
   DEFINE l_nmp04       LIKE nmp_file.nmp04
   DEFINE l_nmp05       LIKE nmp_file.nmp05
   DEFINE l_nmp06       LIKE nmp_file.nmp06
   DEFINE l_nmp07       LIKE nmp_file.nmp07
   DEFINE l_nmp08       LIKE nmp_file.nmp08
   DEFINE l_nmp09       LIKE nmp_file.nmp09
   DEFINE l_nma05       LIKE nma_file.nma05
   DEFINE l_nma_str     LIKE nma_file.nma05
   DEFINE qj_nmpf       LIKE nmp_file.nmp04     #原幣當期發生額
   DEFINE qj_nmp        LIKE nmp_file.nmp07     #本幣當期發生額
   DEFINE qm_nmpf       LIKE nmp_file.nmp06     #原幣期末餘額
   DEFINE qm_nmp        LIKE nmp_file.nmp09     #本幣期末餘額
   DEFINE qj_abb07_1    LIKE abb_file.abb07
   DEFINE qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE qj_abb07_2    LIKE abb_file.abb07
   DEFINE qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE qc_abb07_1    LIKE abb_file.abb07
   DEFINE qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE qc_abb07_2    LIKE abb_file.abb07
   DEFINE qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_abb24       LIKE abb_file.abb24
   DEFINE l_aah041      LIKE aah_file.aah04
   DEFINE l_aah042      LIKE aah_file.aah04
   DEFINE l_aah051      LIKE aah_file.aah05
   DEFINE l_aah052      LIKE aah_file.aah05
   DEFINE l_tah091      LIKE tah_file.tah09
   DEFINE l_tah092      LIKE tah_file.tah09
   DEFINE l_tah101      LIKE tah_file.tah10
   DEFINE l_tah102      LIKE tah_file.tah10
   DEFINE qc_aah04      LIKE aah_file.aah04
   DEFINE qc_aah05      LIKE aah_file.aah05
   DEFINE qc_tah09      LIKE tah_file.tah09
   DEFINE qc_tah10      LIKE tah_file.tah10
   DEFINE qj_aah04      LIKE aah_file.aah04
   DEFINE qj_aah05      LIKE aah_file.aah05
   DEFINE qj_tah09      LIKE tah_file.tah09
   DEFINE qj_tah10      LIKE tah_file.tah10
   DEFINE qm_aah04      LIKE aah_file.aah04
   DEFINE qm_aah05      LIKE aah_file.aah05
   DEFINE qm_tah09      LIKE tah_file.tah09
   DEFINE qm_tah10      LIKE tah_file.tah10
   DEFINE sr               RECORD
                                  nma01 LIKE nma_file.nma01, #銀行編號
                                  nma02 LIKE nma_file.nma02, #銀行全名
                                  nma05 LIKE nma_file.nma05, #科目
                                  nma10 LIKE nma_file.nma10, #幣別
                                  rest1 LIKE nme_file.nme04, #原幣 餘額
                                  rest2 LIKE nme_file.nme04  #本幣 餘額
                        END RECORD
   DEFINE l_aag02_d     STRING
   DEFINE l_yy          LIKE type_file.num5
   DEFINE l_mm          LIKE type_file.num5
   DEFINE l_alz09       LIKE alz_file.alz09
   DEFINE l_alz09f      LIKE alz_file.alz09f
   DEFINE l_alz14       LIKE alz_file.alz14
   DEFINE  l_npr06f      LIKE npr_file.npr06f
   DEFINE  l_npr07f      LIKE npr_file.npr07f
   DEFINE  l_npr06       LIKE npr_file.npr06
   DEFINE  l_npr07       LIKE npr_file.npr07
   DEFINE  l_npr06f_1    LIKE npr_file.npr06f
   DEFINE  l_npr07f_1    LIKE npr_file.npr07f
   DEFINE  l_npr06_1     LIKE npr_file.npr06
   DEFINE  l_npr07_1     LIKE npr_file.npr07
   DEFINE l_alz14_str    LIKE alz_file.alz14
   DEFINE l_nma01       LIKE nma_file.nma01
   DEFINE l_nma02       LIKE nma_file.nma02

   CALL gglq900_curs() 
   LET l_mm = tm.mm - 1
   LET l_yy = tm.yy
   IF l_mm = 0 THEN LET l_yy = tm.yy - 1 LET l_mm = 12 END IF
   
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","aag01") 
   IF tm.n = '2' THEN
      CALL cl_getmsg('ggl-016',g_lang) RETURNING l_aag02_d 
   END IF
   IF tm.n = '3' THEN
      CALL cl_getmsg('ggl-017',g_lang) RETURNING l_aag02_d 
   END IF
   LET l_sql = " SELECT aag01 FROM aag_file",
               "  WHERE ",tm.wc2 CLIPPED,
               "    AND aag00 = '",g_aza.aza81,"'",       
               "    AND aag02 LIKE '",l_aag02_d,"' "         #科目
   PREPARE gglq900_nmp_p22 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

  #子系統---期初余額
   LET l_sql ="SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07) ",
               "  FROM npr_file ",
               " WHERE npr00 LIKE ?  ",
               "   AND npr04 = '",tm.yy,"'",
               "   AND npr05 < '",tm.mm,"' ",
               "   AND (npr08 = '",g_plant,"' OR npr08 IS NULL OR npr08 =' ') ",
               "   AND npr09 = '",g_aza.aza81,"'"
   IF tm.e = 'Y' THEN LET l_sql = l_sql CLIPPED," AND npr11 = ?" END IF
   PREPARE gglq900_nm2_p2 FROM l_sql
  #子系統---期間發生額
   LET l_sql ="SELECT SUM(npr06f),SUM(npr07f),SUM(npr06),SUM(npr07) ",
               "  FROM npr_file ",
               " WHERE npr00 LIKE ? ",
               "   AND npr04 = ",tm.yy,"'",
               "   AND npr05 = '",tm.mm,"' ",
               "   AND (npr08 = '",g_plant CLIPPED,"' OR npr08 IS NULL OR npr08 =' ')",
               "   AND npr09 = '",g_aza.aza81,"'"
   IF tm.e = 'Y' THEN LET l_sql = l_sql CLIPPED," AND npr11 = ?" END IF
   PREPARE gglq900_nm2_p3 FROM l_sql

   DECLARE gglq900_nmp_cs22 CURSOR FOR gglq900_nmp_p22
   FOREACH gglq900_nmp_cs22 INTO l_alz14
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_nmp_cs21 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF

      SELECT aag02,aag06 INTO l_aag02,l_aag06
        FROM aag_file
       WHERE aag00 = g_aza.aza81
         AND aag01 = l_alz14

      SELECT nma01,nma02 INTO l_nma01,l_nma02 FROM nma_file WHERE nma05 = l_alz14
      LET l_alz14_str = l_alz14 CLIPPED,'\%'

    IF tm.e = 'N' THEN
     #子系統金額
      EXECUTE gglq900_nm2_p2 USING l_alz14_str
                              INTO l_npr06f,l_npr07f,l_npr06,l_npr07
      IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
      IF cl_null(l_npr06 ) THEN LET l_npr06  = 0 END IF
      IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
      IF cl_null(l_npr07 ) THEN LET l_npr07  = 0 END IF
      EXECUTE gglq900_nm2_p3 USING l_alz14_str
                              INTO l_npr06f_1,l_npr07f_1,l_npr06_1,l_npr07_1
      IF cl_null(l_npr06f_1) THEN LET l_npr06f_1 = 0 END IF
      IF cl_null(l_npr06_1 ) THEN LET l_npr06_1  = 0 END IF
      IF cl_null(l_npr07f_1) THEN LET l_npr07f_1 = 0 END IF
      IF cl_null(l_npr07_1 ) THEN LET l_npr07_1  = 0 END IF

      IF l_aag06 = '1' THEN
         LET l_alz09f = (l_npr06f - l_npr07f) - (l_npr06f_1 - l_npr07f_1)
         LET l_alz09  = (l_npr06  - l_npr07 ) - (l_npr06_1  - l_npr07_1 )
      ELSE
         LET l_alz09f = (l_npr07f - l_npr06f) - (l_npr07f_1 - l_npr06f_1)
         LET l_alz09  = (l_npr07  - l_npr06 ) - (l_npr07_1  - l_npr06_1 )
      END IF
    END IF

      LET l_nma_str = l_alz14 CLIPPED,'\%'
      
      IF tm.e = 'Y' THEN 
         FOREACH gglq900_abb24_cs USING l_nma_str,l_nma_str INTO l_abb24
           #子系統金額
            EXECUTE gglq900_nm2_p2 USING l_alz14_str,l_abb24
                                    INTO l_npr06f,l_npr07f,l_npr06,l_npr07
            IF cl_null(l_npr06f) THEN LET l_npr06f = 0 END IF
            IF cl_null(l_npr06 ) THEN LET l_npr06  = 0 END IF
            IF cl_null(l_npr07f) THEN LET l_npr07f = 0 END IF
            IF cl_null(l_npr07 ) THEN LET l_npr07  = 0 END IF
            EXECUTE gglq900_nm2_p3 USING l_alz14_str,l_abb24
                                    INTO l_npr06f_1,l_npr07f_1,l_npr06_1,l_npr07_1
            IF cl_null(l_npr06f_1) THEN LET l_npr06f_1 = 0 END IF
            IF cl_null(l_npr06_1 ) THEN LET l_npr06_1  = 0 END IF
            IF cl_null(l_npr07f_1) THEN LET l_npr07f_1 = 0 END IF
            IF cl_null(l_npr07_1 ) THEN LET l_npr07_1  = 0 END IF

            IF l_aag06 = '1' THEN
               LET l_alz09f = (l_npr06f - l_npr07f) - (l_npr06f_1 - l_npr07f_1)
               LET l_alz09  = (l_npr06  - l_npr07 ) - (l_npr06_1  - l_npr07_1 )
            ELSE
               LET l_alz09f = (l_npr07f - l_npr06f) - (l_npr07f_1 - l_npr06f_1)
               LET l_alz09  = (l_npr07  - l_npr06 ) - (l_npr07_1  - l_npr06_1 )
            END IF
            #原币，本币期初
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqc_cs USING l_nma05,l_abb24
            FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqc_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

            #借
            OPEN gglq900_ybqc_cs2 USING l_nma_str,'1',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqc_cs2 USING l_nma_str,'2',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

            LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
            LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
            LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
            LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

            #原币，本币期间
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0           
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqj_cs USING l_nma05,l_abb24
            FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqj_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 
 
            #借
            OPEN gglq900_ybqj_cs2 USING l_nma_str,'1',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqj_cs2 USING l_nma_str,'2',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052
            LET qj_tah09 = l_tah091 + l_tah092
            LET qj_tah10 = l_tah101 + l_tah102

            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05
            LET qm_tah09 = qc_tah09 + qj_tah09
            LET qm_tah10 = qc_tah10 + qj_tah10

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_alz14

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
            END IF
            IF cl_null(l_qc)  THEN LET l_qc = 0  END IF 
            IF cl_null(l_qcf) THEN LET l_qcf = 0 END IF 
            IF cl_null(l_c) THEN   LET l_c = 0   END IF 
            IF cl_null(l_cf) THEN  LET l_cf = 0  END IF 
            IF cl_null(l_d) THEN   LET l_d = 0   END IF 
            IF cl_null(l_df) THEN  LET l_df = 0  END IF 
         
            LET qm_nmpf = l_alz09f                 #原幣期末餘額
            IF cl_null(qm_nmpf) THEN 
               LET qm_nmpf = 0
            END IF
            LET qm_nmp  = l_alz09                  #本幣期末餘額
            IF cl_null(qm_nmp) THEN 
               LET qm_nmp = 0
            END IF
            LET l_df_t  = l_d  - qm_nmp            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_nmpf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES(l_nma01,l_nma02,l_alz14,l_aag02,l_abb24,0,0,
                   0,0,0,0,qm_nmp,qm_nmp,l_df,l_d,
                   l_df_tf,l_df_t)
         END FOREACH  
      ELSE
         #期初值
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qc_cs1 USING l_nma05
         FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qc_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qc_cs2 USING l_nma_str,'1'
         FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qc_cs2 USING l_nma_str,'2'
         FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qc_aah04 = l_aah041 + l_aah042
         LET qc_aah05 = l_aah051 + l_aah052

         #期間
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qj_cs1 USING l_nma05
         FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qj_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qj_cs2 USING l_nma_str,'1'
         FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qj_cs2 USING l_nma_str,'2'
         FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052

         #期末
         LET qm_aah04 = qc_aah04 + qj_aah04
         LET qm_aah05 = qc_aah05 + qj_aah05

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = l_alz14

         #借余
         IF l_aag06 = '1' THEN 
            LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF

         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_d) THEN 
            LET l_d = 0
         END IF 

         LET qm_nmpf = l_alz09f                 #原幣期末餘額
         IF cl_null(qm_nmpf) THEN 
            LET qm_nmpf = 0
         END IF
         LET qm_nmp  = l_alz09                  #本幣期末餘額
         IF cl_null(qm_nmp) THEN 
            LET qm_nmp = 0
         END IF
         LET l_df_t  = l_d  - qm_nmp            #本幣餘額差異
         IF cl_null(l_df_t) THEN 
            LET l_df_t = 0
         END IF
         LET l_df_tf = l_df - qm_nmpf           #原幣餘額差異
         IF cl_null(l_df_tf) THEN 
            LET l_df_tf = 0
         END IF

         INSERT INTO gglq900_tmp 
         VALUES(l_nma01,l_nma02,l_alz14,l_aag02,'',qj_nmpf,qj_nmp,
                l_cf,l_c,l_df,l_d,qm_nmp,qm_nmp,l_df,l_d,
                l_df_tf,l_df_t)
      END IF 
   END FOREACH 
END FUNCTION 

FUNCTION gglq900_fa2()
   DEFINE l_fan11       LIKE fan_file.fan11
   DEFINE l_fan12       LIKE fan_file.fan12
   DEFINE l_fan20       LIKE fan_file.fan20
   DEFINE l_fan_str     LIKE fan_file.fan11
   DEFINE l_faj16       LIKE faj_file.faj16
   DEFINE l_faj14       LIKE faj_file.faj14
   DEFINE l_fan07       LIKE fan_file.fan07
   DEFINE l_fan15       LIKE fan_file.fan15
   DEFINE qj_fanf       LIKE fan_file.fan07     #原幣當期發生額
   DEFINE qj_fan        LIKE fan_file.fan07     #本幣當期發生額
   DEFINE qm_fanf       LIKE fan_file.fan07     #原幣期末餘額
   DEFINE qm_fan        LIKE fan_file.fan07     #本幣期末餘額
   DEFINE qj_abb07_1    LIKE abb_file.abb07
   DEFINE qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE qj_abb07_2    LIKE abb_file.abb07
   DEFINE qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE qc_abb07_1    LIKE abb_file.abb07
   DEFINE qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE qc_abb07_2    LIKE abb_file.abb07
   DEFINE qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_abb24       LIKE abb_file.abb24
   DEFINE l_aah041      LIKE aah_file.aah04
   DEFINE l_aah042      LIKE aah_file.aah04
   DEFINE l_aah051      LIKE aah_file.aah05
   DEFINE l_aah052      LIKE aah_file.aah05
   DEFINE l_tah091      LIKE tah_file.tah09
   DEFINE l_tah092      LIKE tah_file.tah09
   DEFINE l_tah101      LIKE tah_file.tah10
   DEFINE l_tah102      LIKE tah_file.tah10
   DEFINE qc_aah04      LIKE aah_file.aah04
   DEFINE qc_aah05      LIKE aah_file.aah05
   DEFINE qc_tah09      LIKE tah_file.tah09
   DEFINE qc_tah10      LIKE tah_file.tah10
   DEFINE qj_aah04      LIKE aah_file.aah04
   DEFINE qj_aah05      LIKE aah_file.aah05
   DEFINE qj_tah09      LIKE tah_file.tah09
   DEFINE qj_tah10      LIKE tah_file.tah10
   DEFINE qm_aah04      LIKE aah_file.aah04
   DEFINE qm_aah05      LIKE aah_file.aah05
   DEFINE qm_tah09      LIKE tah_file.tah09
   DEFINE qm_tah10      LIKE tah_file.tah10
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE l_wc          STRING
   DEFINE l_fap57       LIKE fap_file.fap57
   DEFINE l_faj27       LIKE faj_file.faj27
   DEFINE l_year        LIKE type_file.num5
   DEFINE l_mon         LIKE type_file.num5
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_cnt1        LIKE type_file.num5
   DEFINE l_adj_fan07   LIKE fan_file.fan07
   DEFINE l_fan08       LIKE fan_file.fan08
   DEFINE l_sub_fan07   LIKE fan_file.fan07
   DEFINE l_faj43       LIKE faj_file.faj43
   DEFINE l_faj57       LIKE faj_file.faj57
   DEFINE l_faj15       LIKE faj_file.faj15
   DEFINE l_faj02       LIKE faj_file.faj02
   DEFINE l_faj022      LIKE faj_file.faj022
   DEFINE l_faj571      LIKE faj_file.faj571
   DEFINE l_curr_fan07  LIKE fan_file.fan07
   DEFINE l_pre_fan15   LIKE fan_file.fan05
   DEFINE l_fab11       LIKE fab_file.fab11
   DEFINE l_fab12       LIKE fab_file.fab12
   DEFINE l_fap56       LIKE fap_file.fap56
   DEFINE l_fap661      LIKE fap_file.fap661
   DEFINE l_fap54       LIKE fap_file.fap54
   DEFINE l_fap10       LIKE fap_file.fap10
   DEFINE g_edate       LIKE type_file.dat
   DEFINE g_bdate       LIKE type_file.dat
   
   CALL gglq900_curs()  

   CALL s_azn01(tm.yy,tm.mm) RETURNING g_bdate,g_edate

   DROP TABLE gglq900_tmp_fa;
   CREATE TEMP TABLE gglq900_tmp_fa(
                    fab11      LIKE fab_file.fab11,
                    faj14      LIKE faj_file.faj14,
                    faj15      LIKE faj_file.faj15,
                    faj16      LIKE faj_file.faj16);

   IF tm.wc2 = " 1=1" THEN
      LET l_flag = 'A'
   ELSE
      LET l_wc = cl_replace_str(tm.wc2,"nma05","fab11") 
      LET l_sql = "SELECT COUNT(*) FROM fab_file WHERE ",l_wc CLIPPED
      PREPARE q900_fa2_pre FROM l_sql
      EXECUTE q900_fa2_pre INTO l_cnt
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
      IF l_cnt > 0 THEN LET l_flag = 'C' END IF
      LET l_wc = cl_replace_str(tm.wc2,"nma05","fab12") 
      LET l_sql = "SELECT COUNT(*) FROM fab_file WHERE ",l_wc CLIPPED
      PREPARE q900_fa2_pre1 FROM l_sql
      EXECUTE q900_fa2_pre1 INTO l_cnt1
      IF cl_null(l_cnt1) THEN LET l_cnt = 0 END IF
      IF l_cnt1 > 0 THEN LET l_flag = 'Z' END IF
      IF l_cnt = 0 AND l_cnt1 = 0 THEN RETURN END IF
      IF l_cnt > 0 AND l_cnt1 > 0 THEN LET l_flag = 'A' END IF
   END IF

   IF l_flag != 'Z' THEN
     #資產會計科目
      DELETE FROM gglq900_tmp_fa
      LET l_wc = cl_replace_str(tm.wc2,"nma05","fab11") 
      LET l_sql = "SELECT faj02,faj022,faj14+faj141-faj59,faj15,0,fab11",
                  "  FROM fab_file,faj_file ",
                  " WHERE faj04 = fab01",
                  "   AND ",l_wc CLIPPED
      PREPARE gglq900_fan_p12 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE gglq900_fan_cs12 CURSOR FOR gglq900_fan_p12
      LET l_faj14  = 0 LET l_fap661 = 0
      LET l_fap661 = 0 LET l_fap10  = 0
      LET l_fap54  = 0 LET l_fap56  = 0
      FOREACH gglq900_fan_cs12 INTO l_faj02,l_faj022,l_faj14,l_faj15,l_faj16,l_fab11
         IF SQLCA.sqlcode THEN
            CALL cl_err('gglq900_fan_cs12 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
         END IF

         SELECT SUM(fap661),SUM(fap10) INTO l_fap661,l_fap10 FROM fap_file
          WHERE fap03 IN ('9') AND fap02=l_faj02
            AND fap021=l_faj022 AND fap04 > g_edate
         IF cl_null(l_fap661) THEN LET l_fap661 = 0 END IF
         IF cl_null(l_fap10 ) THEN LET l_fap10  = 0 END IF

         SELECT SUM(fap54) INTO l_fap54 FROM fap_file                
          WHERE fap03 IN ('7','8')              
            AND fap02=l_faj02
            AND fap021=l_faj022 
            AND fap04 > g_edate
         IF cl_null(l_fap54) THEN LET l_fap54 = 0 END IF

         SELECT SUM(fap56) INTO l_fap56 FROM fap_file
          WHERE fap03 IN ('4','5','6','7','8','9') AND fap02=l_faj02
            AND fap021=l_faj022 AND fap04 > g_edate  
         IF cl_null(l_fap56) THEN LET l_fap56 = 0  END IF

         LET l_faj14 = l_faj14-(l_fap661-l_fap10)-l_fap54 + l_fap56

         INSERT INTO gglq900_tmp_fa VALUES (l_fab11,l_faj14,l_faj15,l_faj16)
         
      END FOREACH

      LET l_sql = "SELECT DISTINCT fab11 FROM gglq900_tmp_fa"
      PREPARE q900_fab11_p FROM l_sql
      DECLARE q900_fab11_c CURSOR FOR q900_fab11_p

      FOREACH q900_fab11_c INTO l_fab11

         LET l_fan_str = l_fab11 CLIPPED,'\%'

         IF tm.e = 'Y' THEN
            LET l_sql = "SELECT SUM(faj14) FROM gglq900_tmp_fa WHERE faj15 = ?",
                        "   AND fab11 = ?"
            PREPARE q900_fa2_p3 FROM l_sql
            DECLARE q900_fa2_c3 CURSOR FOR q900_fa2_p3
            FOREACH gglq900_abb24_cs USING l_fan_str,l_fan_str INTO l_abb24
               #原币，本币期初
               LET l_aah041=0   LET l_aah051=0
               LET l_aah042=0   LET l_aah052=0
               LET l_tah091=0   LET l_tah101=0
               LET l_tah092=0   LET l_tah102=0
               OPEN gglq900_ybqc_cs USING l_fab11,l_abb24
               FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
               CLOSE gglq900_ybqc_cs
               IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
               IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
               IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
               IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

               #借
               OPEN gglq900_ybqc_cs2 USING l_fan_str,'1',l_abb24
               FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
               CLOSE gglq900_ybqc_cs2
               IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
               IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
               #貸
               OPEN gglq900_ybqc_cs2 USING l_fan_str,'2',l_abb24
               FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
               CLOSE gglq900_ybqc_cs2
               IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
               IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

               LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
               LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
               LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
               LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

               #原币，本币期间
               LET l_aah041=0   LET l_aah051=0
               LET l_aah042=0   LET l_aah052=0           
               LET l_tah091=0   LET l_tah101=0
               LET l_tah092=0   LET l_tah102=0
               OPEN gglq900_ybqj_cs USING l_fab11,l_abb24
               FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
               CLOSE gglq900_ybqj_cs
               IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
               IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
               IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
               IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 

               #借
               OPEN gglq900_ybqj_cs2 USING l_fan_str,'1',l_abb24
               FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
               CLOSE gglq900_ybqj_cs2
               IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
               IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
               #貸
               OPEN gglq900_ybqj_cs2 USING l_fan_str,'2',l_abb24
               FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
               CLOSE gglq900_ybqj_cs2
               IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
               IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

               LET qj_aah04 = l_aah041 + l_aah042
               LET qj_aah05 = l_aah051 + l_aah052
               LET qj_tah09 = l_tah091 + l_tah092
               LET qj_tah10 = l_tah101 + l_tah102

               LET qm_aah04 = qc_aah04 + qj_aah04
               LET qm_aah05 = qc_aah05 + qj_aah05
               LET qm_tah09 = qc_tah09 + qj_tah09
               LET qm_tah10 = qc_tah10 + qj_tah10

               LET l_aag02 = NULL 
               SELECT aag02,aag06 INTO l_aag02,l_aag06 
                 FROM aag_file 
                WHERE aag00 = g_aza.aza81 
                  AND aag01 = l_fab11

               #借余
               IF l_aag06 = '1' THEN 
                  LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
                  LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
                  LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
                  LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
                  LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
                  LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
               END IF 
               #貸余
               IF l_aag06 = '2' THEN 
                  LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
                  LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
                  LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
                  LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
                  LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
                  LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
               END IF

               IF cl_null(l_qc) THEN 
                  LET l_qc = 0
               END IF 
               IF cl_null(l_qcf) THEN 
                  LET l_qcf = 0
               END IF 
               IF cl_null(l_c) THEN 
                  LET l_c = 0
               END IF 
               IF cl_null(l_cf) THEN 
                  LET l_cf = 0
               END IF 
               IF cl_null(l_d) THEN 
                  LET l_d = 0
               END IF 
               IF cl_null(l_df) THEN 
                  LET l_df = 0
               END IF 

               OPEN q900_fa2_c3 USING l_abb24,l_fab11
               FETCH q900_fa2_c3 INTO l_faj14
            
               LET qj_fanf = 0                        #原幣當期發生額
               LET qj_fan  = 0                        #本幣當期發生額
               LET qm_fanf = l_faj16                  #原幣期末餘額
               IF cl_null(qm_fanf) THEN 
                  LET qm_fanf = 0
               END IF
               LET qm_fan  = l_faj14                  #本幣期末餘額
               IF cl_null(qm_fan) THEN 
                  LET qm_fan = 0
               END IF
               LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
               IF cl_null(l_df_c) THEN 
                  LET l_df_c = 0
               END IF
               LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
               IF cl_null(l_df_cf) THEN 
                  LET l_df_cf = 0
               END IF
               LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
               IF cl_null(l_df_t) THEN 
                  LET l_df_t = 0
               END IF
               LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
               IF cl_null(l_df_tf) THEN 
                  LET l_df_tf = 0
               END IF

               INSERT INTO gglq900_tmp 
               VALUES('','',l_fab11,l_aag02,l_abb24,qj_fanf,qj_fan,
                      l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                      l_df_tf,l_df_t)
            END FOREACH 
         ELSE
            LET l_sql = "SELECT SUM(faj14) FROM gglq900_tmp_fa WHERE fab11 = ?"
            PREPARE q900_fa2_p4 FROM l_sql
            DECLARE q900_fa2_c4 CURSOR FOR q900_fa2_p4
            #期初值
            LET l_aah041 = 0    LET l_aah051 = 0
            LET l_aah042 = 0    LET l_aah052 = 0
            OPEN gglq900_qc_cs1 USING l_fab11
            FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
            CLOSE gglq900_qc_cs1
            IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
            IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

            OPEN gglq900_qc_cs2 USING l_fan_str,'1'
            FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_qc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            OPEN gglq900_qc_cs2 USING l_fan_str,'2'
            FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_qc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

            LET qc_aah04 = l_aah041 + l_aah042
            LET qc_aah05 = l_aah051 + l_aah052

            #期間
            LET l_aah041 = 0    LET l_aah051 = 0
            LET l_aah042 = 0    LET l_aah052 = 0
            OPEN gglq900_qj_cs1 USING l_fab11
            FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
            CLOSE gglq900_qj_cs1
            IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
            IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

            OPEN gglq900_qj_cs2 USING l_fan_str,'1'
            FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_qj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            OPEN gglq900_qj_cs2 USING l_fan_str,'2'
            FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_qj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052

            #期末
            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_fab11

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = 0                       #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = 0                       #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = 0                       #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = 0                       #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = 0                       #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = 0                       #總帳原幣期末餘額
            END IF

            IF cl_null(l_qc) THEN 
               LET l_qc = 0
            END IF 
            IF cl_null(l_c) THEN 
               LET l_c = 0
            END IF 
            IF cl_null(l_d) THEN 
               LET l_d = 0
            END IF 
            
            OPEN q900_fa2_c4 USING l_fab11
            FETCH q900_fa2_c4 INTO l_faj14
            
            LET qj_fanf = 0                        #原幣當期發生額
            LET qj_fan  = 0                        #本幣當期發生額
            LET qm_fanf = l_faj16                  #原幣期末餘額
            IF cl_null(qm_fanf) THEN 
               LET qm_fanf = 0
            END IF
            LET qm_fan  = l_faj14                  #本幣期末餘額
            IF cl_null(qm_fan) THEN 
               LET qm_fan = 0
            END IF
            LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
            IF cl_null(l_df_c) THEN 
               LET l_df_c = 0
            END IF
            LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
            IF cl_null(l_df_cf) THEN 
               LET l_df_cf = 0
            END IF
            LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES('','',l_fab11,l_aag02,'',qj_fanf,qj_fan,
                   l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                   l_df_tf,l_df_t)
         END IF 
      END FOREACH 
   END IF

   #折舊會計科目
   IF l_flag != 'C' THEN
      DELETE FROM gglq900_tmp_fa
      LET l_wc = cl_replace_str(tm.wc2,"nma05","fab12") 
      LET l_sql = "SELECT faj02,faj022,faj57,faj571,faj27,faj15,fab12",
                  "  FROM fab_file,faj_file ",
                  " WHERE faj04 = fab01",
                  "   AND ",l_wc CLIPPED
      PREPARE q900_fa2_p5 FROM l_sql
      DECLARE q900_fa2_c5 CURSOR FOR q900_fa2_p5
      FOREACH q900_fa2_c5 INTO l_faj02,l_faj022,l_faj57,l_faj571,l_faj27,l_faj15,l_fab12
         LET l_cnt = 0
         LET l_adj_fan07 = 0
         LET l_sub_fan07 = 0             
         SELECT COUNT(*) INTO l_cnt FROM fan_file
          WHERE fan01 = l_faj02 AND fan02 = l_faj022
            AND fan03 = tm.yy AND fan04 = tm.mm
            AND fan041 = '1'
         IF (tm.yy >= l_faj57 AND tm.mm>l_faj571) THEN
            SELECT SUM(fan07) INTO l_adj_fan07 FROM fan_file
             WHERE fan01 = l_faj02
               AND fan02 = l_faj022
               AND ((fan03 = l_faj57 AND fan04 > l_faj571) AND (fan03 = tm.yy AND fan04 <= tm.mm))
               AND fan041 = '2'
               AND fan05 IN ('1','2')                
         END IF
         IF tm.yy = l_faj57 AND tm.mm = l_faj571 THEN    
            SELECT SUM(fan07) INTO l_adj_fan07 FROM fan_file
             WHERE fan01 = l_faj02 AND fan02 = l_faj022
               AND fan03 = tm.yy AND fan04 = tm.mm
               AND fan041 = '2'
               AND fan05 IN ('1','2')        
         END IF 
         IF cl_null(l_adj_fan07) THEN LET l_adj_fan07 = 0 END IF

         IF l_cnt > 0 THEN
            IF g_aza.aza26 <> '2' THEN
               LET l_adj_fan07 = 0
            ELSE
              #大陸版有可能先折舊再調整
               SELECT fan15 INTO l_pre_fan15 FROM fan_file
                WHERE fan01 = l_faj02 AND fan02 = l_faj022
                  AND fan041 = '1'
                  AND fan03 || fan04 IN (
                        SELECT MAX(fan03) || MAX(fan04) FROM fan_File
                         WHERE fan01 = l_faj02 AND fan02 = l_faj022
                           AND ((fan03 < tm.yy) OR (fan03 = tm.yy AND fan04 < tm.mm))
                           AND fan041 = '1')
               SELECT fan07 INTO l_curr_fan07 FROM fan_file
                WHERE fan01 = l_faj02 AND fan02 = l_faj022
                  AND fan03 = tm.yy AND fan04 = tm.mm
                  AND fan041 = '1'
               IF cl_null(l_curr_fan07) THEN LET l_curr_fan07 = 0 END IF
               IF cl_null(l_pre_fan15) THEN LET l_pre_fan15 = 0 END IF   
               IF l_fan15 = (l_pre_fan15 + l_curr_fan07 + l_adj_fan07) THEN
                   LET l_adj_fan07 = 0
               END IF
            END IF
         END IF
         IF l_faj43 = '4' AND (tm.yy < l_faj57  OR l_faj57 = 0 OR l_faj57 IS NULL) THEN
             LET l_sub_fan07 = l_adj_fan07
         END IF
         LET l_fan15 = l_fan15 + l_adj_fan07 - l_sub_fan07  
         LET l_fan08 = l_fan08 + l_adj_fan07
         SELECT COUNT(*) INTO l_cnt 
           FROM fan_file
          WHERE fan01=l_faj02 AND fan02=l_faj022
            AND fan03 = tm.yy AND fan04 = tm.mm
            AND fan041 IN ('0','1')
            AND fan05 IN ('1','2') 
         IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
         LET l_cnt1 = 0
         SELECT COUNT(*) INTO l_cnt1 FROM fap_file
          WHERE fap03 IN ('4','5','6')
            AND fap02 = l_faj02
            AND fap021 = l_faj022
            AND YEAR(fap04) = tm.yy 
            AND MONTH(fap04) = tm.mm
         IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
         IF l_cnt = 0 AND l_cnt1 > 0 THEN
            SELECT SUM(fap57)                           
              INTO l_fap57 FROM fap_file                 
             WHERE fap03 IN ('4','5','6') 
               AND fap02 = l_faj02
               AND fap021 = l_faj022
               AND YEAR(fap04) = tm.yy 
               AND MONTH(fap04) = tm.mm
         END IF
         
         LET l_year = l_faj27[1,4]
         LET l_mon  = l_faj27[5,6]
         IF (l_year=tm.yy AND l_mon > tm.mm) OR l_year > tm.yy THEN
            LET l_faj14 = 0                 
         ELSE
            LET l_faj14 = l_fan15 - l_fap57       #累折
         END IF

         INSERT INTO gglq900_tmp_fa VALUES (l_fab11,l_faj14,l_faj15,l_faj16)
      END FOREACH

      LET l_sql = "SELECT DISTINCT fab11 FROM gglq900_tmp_fa"
      PREPARE q900_fab11_p1 FROM l_sql
      DECLARE q900_fab11_c1 CURSOR FOR q900_fab11_p1
      FOREACH q900_fab11_c1 INTO l_fab12
         LET l_fan_str = l_fab12 CLIPPED,'\%'

         IF tm.e = 'Y' THEN 
            LET l_sql = "SELECT SUM(faj14) FROM gglq900_tmp_fa WHERE faj15 = ?",
                        "   AND fab11 = ?"
            PREPARE q900_fa2_p6 FROM l_sql
            DECLARE q900_fa2_c6 CURSOR FOR q900_fa2_p6
            FOREACH gglq900_abb24_cs USING l_fan_str,l_fan_str INTO l_abb24
               #原币，本币期初
               LET l_aah041=0   LET l_aah051=0
               LET l_aah042=0   LET l_aah052=0
               LET l_tah091=0   LET l_tah101=0
               LET l_tah092=0   LET l_tah102=0
               OPEN gglq900_ybqc_cs USING l_fab12,l_abb24
               FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
               CLOSE gglq900_ybqc_cs
               IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
               IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
               IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
               IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

               #借
               OPEN gglq900_ybqc_cs2 USING l_fan_str,'1',l_abb24
               FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
               CLOSE gglq900_ybqc_cs2
               IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
               IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
               #貸
               OPEN gglq900_ybqc_cs2 USING l_fan_str,'2',l_abb24
               FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
               CLOSE gglq900_ybqc_cs2
               IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
               IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

               LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
               LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
               LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
               LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

               #原币，本币期间
               LET l_aah041=0   LET l_aah051=0
               LET l_aah042=0   LET l_aah052=0           
               LET l_tah091=0   LET l_tah101=0
               LET l_tah092=0   LET l_tah102=0
               OPEN gglq900_ybqj_cs USING l_fab12,l_abb24
               FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
               CLOSE gglq900_ybqj_cs
               IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
               IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
               IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
               IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 

               #借
               OPEN gglq900_ybqj_cs2 USING l_fan_str,'1',l_abb24
               FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
               CLOSE gglq900_ybqj_cs2
               IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
               IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
               #貸
               OPEN gglq900_ybqj_cs2 USING l_fan_str,'2',l_abb24
               FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
               CLOSE gglq900_ybqj_cs2
               IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
               IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

               LET qj_aah04 = l_aah041 + l_aah042
               LET qj_aah05 = l_aah051 + l_aah052
               LET qj_tah09 = l_tah091 + l_tah092
               LET qj_tah10 = l_tah101 + l_tah102

               LET qm_aah04 = qc_aah04 + qj_aah04
               LET qm_aah05 = qc_aah05 + qj_aah05
               LET qm_tah09 = qc_tah09 + qj_tah09
               LET qm_tah10 = qc_tah10 + qj_tah10

               LET l_aag02 = NULL 
               SELECT aag02,aag06 INTO l_aag02,l_aag06 
                 FROM aag_file 
                WHERE aag00 = g_aza.aza81 
                  AND aag01 = l_fab12

               #借余
               IF l_aag06 = '1' THEN 
                  LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
                  LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
                  LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
                  LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
                  LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
                  LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
               END IF 
               #貸余
               IF l_aag06 = '2' THEN 
                  LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
                  LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
                  LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
                  LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
                  LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
                  LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
               END IF

               IF cl_null(l_qc) THEN 
                  LET l_qc = 0
               END IF 
               IF cl_null(l_qcf) THEN 
                  LET l_qcf = 0
               END IF 
               IF cl_null(l_c) THEN 
                  LET l_c = 0
               END IF 
               IF cl_null(l_cf) THEN 
                  LET l_cf = 0
               END IF 
               IF cl_null(l_d) THEN 
                  LET l_d = 0
               END IF 
               IF cl_null(l_df) THEN 
                  LET l_df = 0
               END IF

               OPEN q900_fa2_c6 USING l_fab12,l_abb24
               FETCH q900_fa2_c6 INTO l_fan07
            
               LET qj_fanf = 0                        #原幣當期發生額
               LET qj_fan  = l_fan07                  #本幣當期發生額
               IF cl_null(qj_fan) THEN 
                  LET qj_fan = 0
               END IF
               LET qm_fanf = 0                        #原幣期末餘額
               LET qm_fan  = 0                        #本幣期末餘額
               LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
               IF cl_null(l_df_c) THEN 
                  LET l_df_c = 0
               END IF
               LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
               IF cl_null(l_df_cf) THEN 
                  LET l_df_cf = 0
               END IF
               LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
               IF cl_null(l_df_t) THEN 
                  LET l_df_t = 0
               END IF
               LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
               IF cl_null(l_df_tf) THEN 
                  LET l_df_tf = 0
               END IF

               INSERT INTO gglq900_tmp 
               VALUES('','',l_fab12,l_aag02,l_abb24,qj_fanf,qj_fan,
                      l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                      l_df_tf,l_df_t)
            END FOREACH  
         ELSE
            LET l_sql = "SELECT SUM(faj14) FROM gglq900_tmp_fa WHERE fab11 = ?"
            PREPARE q900_fa2_p7 FROM l_sql
            DECLARE q900_fa2_c7 CURSOR FOR q900_fa2_p7
            #期初值
            LET l_aah041 = 0    LET l_aah051 = 0
            LET l_aah042 = 0    LET l_aah052 = 0
            OPEN gglq900_qc_cs1 USING l_fan12
            FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
            CLOSE gglq900_qc_cs1
            IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
            IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

            OPEN gglq900_qc_cs2 USING l_fan_str,'1'
            FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_qc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            OPEN gglq900_qc_cs2 USING l_fan_str,'2'
            FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_qc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

            LET qc_aah04 = l_aah041 + l_aah042
            LET qc_aah05 = l_aah051 + l_aah052

            #期間
            LET l_aah041 = 0    LET l_aah051 = 0
            LET l_aah042 = 0    LET l_aah052 = 0
            OPEN gglq900_qj_cs1 USING l_fan12
            FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
            CLOSE gglq900_qj_cs1
            IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
            IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

            OPEN gglq900_qj_cs2 USING l_fan_str,'1'
            FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_qj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            OPEN gglq900_qj_cs2 USING l_fan_str,'2'
            FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_qj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052

            #期末
            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_fab12

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = 0                       #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = 0                       #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = 0                       #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = 0                       #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = 0                       #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = 0                       #總帳原幣期末餘額
            END IF

            IF cl_null(l_qc) THEN 
               LET l_qc = 0
            END IF 
            IF cl_null(l_c) THEN 
               LET l_c = 0
            END IF 
            IF cl_null(l_d) THEN 
               LET l_d = 0
            END IF 
            
            OPEN q900_fa2_c7 USING l_fan12
            FETCH q900_fa2_c7 INTO l_fan07
            
            LET qj_fanf = 0                        #原幣當期發生額
            LET qj_fan  = l_fan07                  #本幣當期發生額
            IF cl_null(qj_fan) THEN 
               LET qj_fan = 0
            END IF
            LET qm_fanf = 0                        #原幣期末餘額
            LET qm_fan  = 0                        #本幣期末餘額
            LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
            IF cl_null(l_df_c) THEN 
               LET l_df_c = 0
            END IF
            LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
            IF cl_null(l_df_cf) THEN 
               LET l_df_cf = 0
            END IF
            LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES('','',l_fan12,l_aag02,'',qj_fanf,qj_fan,
                   l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                   l_df_tf,l_df_t)
         END IF
      END FOREACH
   END IF
END FUNCTION 
#No.FUN-D70072 ---Add--- End

FUNCTION gglq900_fa()
   DEFINE l_fan11       LIKE fan_file.fan11
   DEFINE l_fan12       LIKE fan_file.fan12
   DEFINE l_fan20       LIKE fan_file.fan20
   DEFINE l_fan_str     LIKE fan_file.fan11
   DEFINE l_faj16       LIKE faj_file.faj16
   DEFINE l_faj14       LIKE faj_file.faj14
   DEFINE l_fan07       LIKE fan_file.fan07
   DEFINE l_fan15       LIKE fan_file.fan15
   DEFINE qj_fanf       LIKE fan_file.fan07     #原幣當期發生額
   DEFINE qj_fan        LIKE fan_file.fan07     #本幣當期發生額
   DEFINE qm_fanf       LIKE fan_file.fan07     #原幣期末餘額
   DEFINE qm_fan        LIKE fan_file.fan07     #本幣期末餘額
   DEFINE qj_abb07_1    LIKE abb_file.abb07
   DEFINE qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE qj_abb07_2    LIKE abb_file.abb07
   DEFINE qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE qc_abb07_1    LIKE abb_file.abb07
   DEFINE qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE qc_abb07_2    LIKE abb_file.abb07
   DEFINE qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE l_qcf         LIKE abb_file.abb07f   #總帳原幣期初餘額
   DEFINE l_qc          LIKE abb_file.abb07    #總帳本幣期初餘額
   DEFINE l_cf          LIKE abb_file.abb07f   #總帳原幣當期發生額
   DEFINE l_c           LIKE abb_file.abb07    #總帳本幣當期發生額
   DEFINE l_df_cf       LIKE abb_file.abb07f   #原幣當期發生額差異
   DEFINE l_df_c        LIKE abb_file.abb07    #本幣當期發生額差異
   DEFINE l_df          LIKE abb_file.abb07f   #總帳原幣期末餘額
   DEFINE l_d           LIKE abb_file.abb07    #總帳本幣期末餘額
   DEFINE l_df_tf       LIKE abb_file.abb07f   #原幣餘額差異
   DEFINE l_df_t        LIKE abb_file.abb07    #本幣餘額差異
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_abb24       LIKE abb_file.abb24
   DEFINE l_aah041      LIKE aah_file.aah04
   DEFINE l_aah042      LIKE aah_file.aah04
   DEFINE l_aah051      LIKE aah_file.aah05
   DEFINE l_aah052      LIKE aah_file.aah05
   DEFINE l_tah091      LIKE tah_file.tah09
   DEFINE l_tah092      LIKE tah_file.tah09
   DEFINE l_tah101      LIKE tah_file.tah10
   DEFINE l_tah102      LIKE tah_file.tah10
   DEFINE qc_aah04      LIKE aah_file.aah04
   DEFINE qc_aah05      LIKE aah_file.aah05
   DEFINE qc_tah09      LIKE tah_file.tah09
   DEFINE qc_tah10      LIKE tah_file.tah10
   DEFINE qj_aah04      LIKE aah_file.aah04
   DEFINE qj_aah05      LIKE aah_file.aah05
   DEFINE qj_tah09      LIKE tah_file.tah09
   DEFINE qj_tah10      LIKE tah_file.tah10
   DEFINE qm_aah04      LIKE aah_file.aah04
   DEFINE qm_aah05      LIKE aah_file.aah05
   DEFINE qm_tah09      LIKE tah_file.tah09
   DEFINE qm_tah10      LIKE tah_file.tah10
   
   CALL gglq900_curs()  
   #資產會計科目
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","fan11") 
   LET l_sql = "SELECT fan11,SUM(faj16),SUM(faj14)",
               "  FROM fan_file,faj_file ",
               " WHERE fan01 = faj02",
               "   AND fan02 = faj022",
               "   AND fan03 = '",tm.yy,"'",
               "   AND fan04 = '",tm.mm,"'",
               "   AND ",tm.wc2 CLIPPED,
               " GROUP BY fan11"
   PREPARE gglq900_fan_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_fan_cs1 CURSOR FOR gglq900_fan_p1
   FOREACH gglq900_fan_cs1 INTO l_fan11,l_faj16,l_faj14
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_fan_cs1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      LET l_fan_str = l_fan11 CLIPPED,'\%'

      IF tm.e = 'Y' THEN 
         FOREACH gglq900_abb24_cs USING l_fan_str,l_fan_str INTO l_abb24
            #原币，本币期初
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqc_cs USING l_fan11,l_abb24
            FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqc_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

            #借
            OPEN gglq900_ybqc_cs2 USING l_fan_str,'1',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqc_cs2 USING l_fan_str,'2',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

            LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
            LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
            LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
            LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

            #原币，本币期间
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0           
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqj_cs USING l_fan11,l_abb24
            FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqj_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 

            #借
            OPEN gglq900_ybqj_cs2 USING l_fan_str,'1',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqj_cs2 USING l_fan_str,'2',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052
            LET qj_tah09 = l_tah091 + l_tah092
            LET qj_tah10 = l_tah101 + l_tah102

            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05
            LET qm_tah09 = qc_tah09 + qj_tah09
            LET qm_tah10 = qc_tah10 + qj_tah10

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_fan11

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
            END IF

            IF cl_null(l_qc) THEN 
               LET l_qc = 0
            END IF 
            IF cl_null(l_qcf) THEN 
               LET l_qcf = 0
            END IF 
            IF cl_null(l_c) THEN 
               LET l_c = 0
            END IF 
            IF cl_null(l_cf) THEN 
               LET l_cf = 0
            END IF 
            IF cl_null(l_d) THEN 
               LET l_d = 0
            END IF 
            IF cl_null(l_df) THEN 
               LET l_df = 0
            END IF 
         
         
            LET qj_fanf = 0                        #原幣當期發生額
            LET qj_fan  = 0                        #本幣當期發生額
            LET qm_fanf = l_faj16                  #原幣期末餘額
            IF cl_null(qm_fanf) THEN 
               LET qm_fanf = 0
            END IF
            LET qm_fan  = l_faj14                  #本幣期末餘額
            IF cl_null(qm_fan) THEN 
               LET qm_fan = 0
            END IF
            LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
            IF cl_null(l_df_c) THEN 
               LET l_df_c = 0
            END IF
            LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
            IF cl_null(l_df_cf) THEN 
               LET l_df_cf = 0
            END IF
            LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES('','',l_fan11,l_aag02,l_abb24,qj_fanf,qj_fan,
                   l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                   l_df_tf,l_df_t)
         END FOREACH 
      ELSE
         #期初值
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qc_cs1 USING l_fan11
         FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qc_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qc_cs2 USING l_fan_str,'1'
         FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qc_cs2 USING l_fan_str,'2'
         FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qc_aah04 = l_aah041 + l_aah042
         LET qc_aah05 = l_aah051 + l_aah052

         #期間
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qj_cs1 USING l_fan11
         FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qj_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qj_cs2 USING l_fan_str,'1'
         FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qj_cs2 USING l_fan_str,'2'
         FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052

         #期末
         LET qm_aah04 = qc_aah04 + qj_aah04
         LET qm_aah05 = qc_aah05 + qj_aah05

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = l_fan20

         #借余
         IF l_aag06 = '1' THEN 
            LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF

         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_d) THEN 
            LET l_d = 0
         END IF 
         
         
         LET qj_fanf = 0                        #原幣當期發生額
         LET qj_fan  = 0                        #本幣當期發生額
         LET qm_fanf = l_faj16                  #原幣期末餘額
         IF cl_null(qm_fanf) THEN 
            LET qm_fanf = 0
         END IF
         LET qm_fan  = l_faj14                  #本幣期末餘額
         IF cl_null(qm_fan) THEN 
            LET qm_fan = 0
         END IF
         LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
         IF cl_null(l_df_c) THEN 
            LET l_df_c = 0
         END IF
         LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
         IF cl_null(l_df_cf) THEN 
            LET l_df_cf = 0
         END IF
         LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
         IF cl_null(l_df_t) THEN 
            LET l_df_t = 0
         END IF
         LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
         IF cl_null(l_df_tf) THEN 
            LET l_df_tf = 0
         END IF

         INSERT INTO gglq900_tmp 
         VALUES('','',l_fan12,l_aag02,'',qj_fanf,qj_fan,
                l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                l_df_tf,l_df_t)
      END IF  
   END FOREACH 

   #折舊會計科目
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","fan12") 
   LET l_sql = "SELECT fan12,SUM(fan07)",
               "  FROM fan_file",
               " WHERE fan03 = '",tm.yy,"'",
               "   AND fan04 = '",tm.mm,"'",
               "   AND ",tm.wc2 CLIPPED,
               " GROUP BY fan12"
   PREPARE gglq900_fan_p2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_fan_cs2 CURSOR FOR gglq900_fan_p2
   FOREACH gglq900_fan_cs2 INTO l_fan12,l_fan07
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_fan_cs2 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      LET l_fan_str = l_fan12 CLIPPED,'\%'

      IF tm.e = 'Y' THEN 
         FOREACH gglq900_abb24_cs USING l_fan_str,l_fan_str INTO l_abb24
            #原币，本币期初
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqc_cs USING l_fan12,l_abb24
            FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqc_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

            #借
            OPEN gglq900_ybqc_cs2 USING l_fan_str,'1',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqc_cs2 USING l_fan_str,'2',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

            LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
            LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
            LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
            LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

            #原币，本币期间
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0           
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqj_cs USING l_fan12,l_abb24
            FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqj_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 

            #借
            OPEN gglq900_ybqj_cs2 USING l_fan_str,'1',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqj_cs2 USING l_fan_str,'2',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052
            LET qj_tah09 = l_tah091 + l_tah092
            LET qj_tah10 = l_tah101 + l_tah102

            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05
            LET qm_tah09 = qc_tah09 + qj_tah09
            LET qm_tah10 = qc_tah10 + qj_tah10

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_fan12

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
            END IF

            IF cl_null(l_qc) THEN 
               LET l_qc = 0
            END IF 
            IF cl_null(l_qcf) THEN 
               LET l_qcf = 0
            END IF 
            IF cl_null(l_c) THEN 
               LET l_c = 0
            END IF 
            IF cl_null(l_cf) THEN 
               LET l_cf = 0
            END IF 
            IF cl_null(l_d) THEN 
               LET l_d = 0
            END IF 
            IF cl_null(l_df) THEN 
               LET l_df = 0
            END IF
         
            LET qj_fanf = 0                        #原幣當期發生額
            LET qj_fan  = l_fan07                  #本幣當期發生額
            IF cl_null(qj_fan) THEN 
               LET qj_fan = 0
            END IF
            LET qm_fanf = 0                        #原幣期末餘額
            LET qm_fan  = 0                        #本幣期末餘額
            LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
            IF cl_null(l_df_c) THEN 
               LET l_df_c = 0
            END IF
            LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
            IF cl_null(l_df_cf) THEN 
               LET l_df_cf = 0
            END IF
            LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES('','',l_fan12,l_aag02,l_abb24,qj_fanf,qj_fan,
                   l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                   l_df_tf,l_df_t)
         END FOREACH  
      ELSE
         #期初值
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qc_cs1 USING l_fan12
         FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qc_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qc_cs2 USING l_fan_str,'1'
         FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qc_cs2 USING l_fan_str,'2'
         FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qc_aah04 = l_aah041 + l_aah042
         LET qc_aah05 = l_aah051 + l_aah052

         #期間
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qj_cs1 USING l_fan12
         FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qj_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qj_cs2 USING l_fan_str,'1'
         FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qj_cs2 USING l_fan_str,'2'
         FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052

         #期末
         LET qm_aah04 = qc_aah04 + qj_aah04
         LET qm_aah05 = qc_aah05 + qj_aah05

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = l_fan20

         #借余
         IF l_aag06 = '1' THEN 
            LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF

         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_d) THEN 
            LET l_d = 0
         END IF 
         
         
         LET qj_fanf = 0                        #原幣當期發生額
         LET qj_fan  = l_fan07                  #本幣當期發生額
         IF cl_null(qj_fan) THEN 
            LET qj_fan = 0
         END IF
         LET qm_fanf = 0                        #原幣期末餘額
         LET qm_fan  = 0                        #本幣期末餘額
         LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
         IF cl_null(l_df_c) THEN 
            LET l_df_c = 0
         END IF
         LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
         IF cl_null(l_df_cf) THEN 
            LET l_df_cf = 0
         END IF
         LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
         IF cl_null(l_df_t) THEN 
            LET l_df_t = 0
         END IF
         LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
         IF cl_null(l_df_tf) THEN 
            LET l_df_tf = 0
         END IF

         INSERT INTO gglq900_tmp 
         VALUES('','',l_fan12,l_aag02,'',qj_fanf,qj_fan,
                l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                l_df_tf,l_df_t)
      END IF 
   END FOREACH 

   #累折科目
   LET l_fan07 = NULL  #TQC-D80007 add
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","fan12") 
   LET l_sql = "SELECT fan20,fan07,SUM(fan15)",    #TQC-D80007 add fan07
               "  FROM fan_file",
               " WHERE fan03 = '",tm.yy,"'",
               "   AND fan04 = '",tm.mm,"'",
               "   AND ",tm.wc2 CLIPPED,
               " GROUP BY fan20,fan07"    #TQC-D80007 add fan07
   PREPARE gglq900_fan_p3 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_fan_cs3 CURSOR FOR gglq900_fan_p3
   FOREACH gglq900_fan_cs3 INTO l_fan20,l_fan07,l_fan15    #TQC-D80007 add l_fan07
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_fan_cs3 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      LET l_fan_str = l_fan12 CLIPPED,'\%'

      IF tm.e = 'Y' THEN 
         FOREACH gglq900_abb24_cs USING l_fan_str,l_fan_str INTO l_abb24
            #原币，本币期初
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqc_cs USING l_fan20,l_abb24
            FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqc_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

            #借
            OPEN gglq900_ybqc_cs2 USING l_fan_str,'1',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqc_cs2 USING l_fan_str,'2',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

            LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
            LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
            LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
            LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

            #原币，本币期间
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0           
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqj_cs USING l_fan20,l_abb24
            FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqj_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 

            #借
            OPEN gglq900_ybqj_cs2 USING l_fan_str,'1',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqj_cs2 USING l_fan_str,'2',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052
            LET qj_tah09 = l_tah091 + l_tah092
            LET qj_tah10 = l_tah101 + l_tah102

            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05
            LET qm_tah09 = qc_tah09 + qj_tah09
            LET qm_tah10 = qc_tah10 + qj_tah10

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_fan20

            #借余
            IF l_aag06 = '1' THEN 
               LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
               LET l_qcf = qc_tah09 - qc_tah10     #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
               LET l_cf  = qj_tah09 - qj_tah10     #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
               LET l_df  = qm_tah09 - qm_tah10     #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
               LET l_qcf = qc_tah10 - qc_tah09     #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
               LET l_cf  = qj_tah10 - qj_tah09     #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
               LET l_df  = qm_tah10 - qm_tah09     #總帳原幣期末餘額
            END IF

            IF cl_null(l_qc) THEN 
               LET l_qc = 0
            END IF 
            IF cl_null(l_qcf) THEN 
               LET l_qcf = 0
            END IF 
            IF cl_null(l_c) THEN 
               LET l_c = 0
            END IF 
            IF cl_null(l_cf) THEN 
               LET l_cf = 0
            END IF 
            IF cl_null(l_d) THEN 
               LET l_d = 0
            END IF 
            IF cl_null(l_df) THEN 
               LET l_df = 0
            END IF
         
         
            LET qj_fanf = 0                        #原幣當期發生額
            #LET qj_fan  = 0                       #本幣當期發生額    #TQC-D80007 mark
            #TQC-D80007--add--str--
            LET qj_fan  = l_fan07                  #本幣當期發生額    
            IF cl_null(qj_fan) THEN                 
               LET qj_fan = 0
            END IF
            #TQC-D80007--add--end--
            LET qm_fanf = 0                        #原幣期末餘額
            LET qm_fan  = l_fan15                  #本幣期末餘額
            IF cl_null(qm_fan) THEN 
               LET qm_fan = 0
            END IF
            LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
            IF cl_null(l_df_c) THEN 
               LET l_df_c = 0
            END IF
            LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
            IF cl_null(l_df_cf) THEN 
               LET l_df_cf = 0
            END IF
            LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
            IF cl_null(l_df_t) THEN 
               LET l_df_t = 0
            END IF
            LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
            IF cl_null(l_df_tf) THEN 
               LET l_df_tf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES('','',l_fan12,l_aag02,l_abb24,qj_fanf,qj_fan,
                   l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                   l_df_tf,l_df_t)
         END FOREACH  
      ELSE
         #期初值
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qc_cs1 USING l_fan20
         FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qc_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qc_cs2 USING l_fan_str,'1'
         FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qc_cs2 USING l_fan_str,'2'
         FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qc_aah04 = l_aah041 + l_aah042
         LET qc_aah05 = l_aah051 + l_aah052

         #期間
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qj_cs1 USING l_fan20
         FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qj_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qj_cs2 USING l_fan_str,'1'
         FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qj_cs2 USING l_fan_str,'2'
         FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052

         #期末
         LET qm_aah04 = qc_aah04 + qj_aah04
         LET qm_aah05 = qc_aah05 + qj_aah05

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = l_fan20

         #借余
         IF l_aag06 = '1' THEN 
            LET l_qc  = qc_aah04 - qc_aah05     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah04 - qm_aah05     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_qc  = qc_aah05 - qc_aah04     #總帳本幣期初餘額
            LET l_qcf = 0                       #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04     #總帳本幣當期發生額
            LET l_cf  = 0                       #總帳原幣當期發生額
            LET l_d   = qm_aah05 - qm_aah04     #總帳本幣期末餘額 
            LET l_df  = 0                       #總帳原幣期末餘額
         END IF

         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_d) THEN 
            LET l_d = 0
         END IF 
         
         LET qj_fanf = 0                        #原幣當期發生額
         #LET qj_fan  = 0                       #本幣當期發生額    #TQC-D80007 mark
         LET qj_fan  = l_fan07                  #本幣當期發生額    #TQC-D80007 add
         #TQC-D80007--add--str--
         LET qj_fan  = l_fan07                  #本幣當期發生額    
         IF cl_null(qj_fan) THEN                 
            LET qj_fan = 0
         END IF
         #TQC-D80007--add--end--
         LET qm_fanf = 0                        #原幣期末餘額
         LET qm_fan  = l_fan15                  #本幣期末餘額
         IF cl_null(qm_fan) THEN 
            LET qm_fan = 0
         END IF
         LET l_df_c  = l_c  - qj_fan            #本幣當期發生額差異
         IF cl_null(l_df_c) THEN 
            LET l_df_c = 0
         END IF
         LET l_df_cf = l_cf - qj_fanf           #原幣當期發生額差異
         IF cl_null(l_df_cf) THEN 
            LET l_df_cf = 0
         END IF
         LET l_df_t  = l_d  - qm_fan            #本幣餘額差異
         IF cl_null(l_df_t) THEN 
            LET l_df_t = 0
         END IF
         LET l_df_tf = l_df - qm_fanf           #原幣餘額差異
         IF cl_null(l_df_tf) THEN 
            LET l_df_tf = 0
         END IF

         INSERT INTO gglq900_tmp 
         VALUES('','',l_fan12,l_aag02,'',qj_fanf,qj_fan,
                l_cf,l_c,l_df_cf,l_df_c,qm_fanf,qm_fan,l_df,l_d,
                l_df_tf,l_df_t)
      END IF 
   END FOREACH 
END FUNCTION 

FUNCTION gglq900_gl()
   DEFINE l_abb03       LIKE abb_file.abb03
   DEFINE l_abb_str     LIKE abb_file.abb03
   DEFINE qj_abb07_1    LIKE abb_file.abb07
   DEFINE qj_abb07f_1   LIKE abb_file.abb07f
   DEFINE qj_abb07_2    LIKE abb_file.abb07
   DEFINE qj_abb07f_2   LIKE abb_file.abb07f
   DEFINE dq_abb07_1    LIKE abb_file.abb07
   DEFINE dq_abb07f_1   LIKE abb_file.abb07f
   DEFINE dq_abb07_2    LIKE abb_file.abb07
   DEFINE dq_abb07f_2   LIKE abb_file.abb07f
   DEFINE qc_abb07_1    LIKE abb_file.abb07
   DEFINE qc_abb07f_1   LIKE abb_file.abb07f
   DEFINE qc_abb07_2    LIKE abb_file.abb07
   DEFINE qc_abb07f_2   LIKE abb_file.abb07f
   DEFINE l_dqf         LIKE abb_file.abb07f    #原幣當期發生額
   DEFINE l_dq          LIKE abb_file.abb07     #本幣當期發生額
   DEFINE l_cf          LIKE abb_file.abb07f    #總帳原幣當期發生額
   DEFINE l_c           LIKE abb_file.abb07     #總帳本幣當期發生額
   DEFINE l_df_cf       LIKE abb_file.abb07f    #原幣當期發生額差異
   DEFINE l_df_c        LIKE abb_file.abb07     #本幣當期發生額差異
   DEFINE l_df          LIKE abb_file.abb07f    #總帳原幣期末餘額
   DEFINE l_d           LIKE abb_file.abb07     #總帳本幣期末餘額
   DEFINE l_qcf         LIKE abb_file.abb07f    #總帳原幣期初餘額
   DEFINE l_qc          LIKE abb_file.abb07     #總帳本幣期初餘額
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_abb24       LIKE abb_file.abb24
   DEFINE l_aah041      LIKE aah_file.aah04
   DEFINE l_aah042      LIKE aah_file.aah04
   DEFINE l_aah051      LIKE aah_file.aah05
   DEFINE l_aah052      LIKE aah_file.aah05
   DEFINE l_tah091      LIKE tah_file.tah09
   DEFINE l_tah092      LIKE tah_file.tah09
   DEFINE l_tah101      LIKE tah_file.tah10
   DEFINE l_tah102      LIKE tah_file.tah10
   DEFINE qc_aah04      LIKE aah_file.aah04
   DEFINE qc_aah05      LIKE aah_file.aah05
   DEFINE qc_tah09      LIKE tah_file.tah09
   DEFINE qc_tah10      LIKE tah_file.tah10
   DEFINE qj_aah04      LIKE aah_file.aah04
   DEFINE qj_aah05      LIKE aah_file.aah05
   DEFINE qj_tah09      LIKE tah_file.tah09
   DEFINE qj_tah10      LIKE tah_file.tah10
   DEFINE qm_aah04      LIKE aah_file.aah04
   DEFINE qm_aah05      LIKE aah_file.aah05
   DEFINE qm_tah09      LIKE tah_file.tah09
   DEFINE qm_tah10      LIKE tah_file.tah10

   CALL gglq900_curs()  
   LET tm.wc2 = cl_replace_str(tm.wc2,"alz14","aag01") 
   LET l_sql = "SELECT DISTINCT aag01",
                  "  FROM aag_file,abb_file ",
                  " WHERE aag00 = '",g_aza.aza81,"'",
                  "   AND aag01 = abb03",
                  "   AND ",tm.wc2 CLIPPED
   PREPARE gglq900_abb_p9 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE gglq900_abb_cs1 CURSOR FOR gglq900_abb_p9
   FOREACH gglq900_abb_cs1 INTO l_abb03
      IF SQLCA.sqlcode THEN
         CALL cl_err('gglq900_abb_cs1 foreach:',SQLCA.sqlcode,0) EXIT FOREACH
      END IF

      LET l_abb_str = l_abb03 CLIPPED,'\%'
      IF tm.e = 'Y' THEN 
         FOREACH gglq900_abb24_cs USING l_abb_str,l_abb_str INTO l_abb24
            #當期發生額  借
            LET l_sql = "SELECT SUM(abb07),sum(abb07f)",
                        "  FROM aba_file,abb_file ",
                        " WHERE aba00 = abb00 ",
                        "   AND aba01 = abb01 ",
                        "   AND aba00 = '",g_aza.aza81,"'",
                        "   AND aba03 = ",tm.yy,
                        "   AND aba04 = ",tm.mm,
                        "   AND abb06 = 1 ",
                        "   AND aba19 <> 'X' ",
                        "   AND abaacti = 'Y'",
                        "   AND abb03 LIKE '",l_abb03,"%'",
                        "   AND abb24 = '",l_abb24,"'"
            PREPARE gglq900_abb_p10 FROM l_sql
            EXECUTE gglq900_abb_p10 INTO dq_abb07_1,dq_abb07f_1
            IF cl_null(dq_abb07_1) THEN 
               LET dq_abb07_1 = 0
            END IF 
            IF cl_null(dq_abb07f_1) THEN 
               LET dq_abb07f_1 = 0
            END IF 
      

            #當期發生額  貸
            LET l_sql = "SELECT SUM(abb07),sum(abb07f)",
                        "  FROM aba_file,abb_file ",
                        " WHERE aba00 = abb00 ",
                        "   AND aba01 = abb01 ",
                        "   AND aba00 = '",g_aza.aza81,"'",
                        "   AND aba03 = ",tm.yy,
                        "   AND aba04 = ",tm.mm,
                        "   AND abb06 = 2 ",
                        "   AND aba19 <> 'X' ",
                        "   AND abaacti = 'Y'",
                        "   AND abb03 LIKE '",l_abb03,"%'",
                        "   AND abb24 = '",l_abb24,"'"
            PREPARE gglq900_abb_p11 FROM l_sql
            EXECUTE gglq900_abb_p11 INTO dq_abb07_2,dq_abb07f_2
            IF cl_null(dq_abb07_2) THEN 
               LET dq_abb07_2 = 0
            END IF 
            IF cl_null(dq_abb07f_2) THEN 
               LET dq_abb07f_2 = 0
            END IF 
       
            #原币，本币期初
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqc_cs USING l_abb03,l_abb24
            FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqc_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

            #借
            OPEN gglq900_ybqc_cs2 USING l_abb_str,'1',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqc_cs2 USING l_abb_str,'2',l_abb24
            FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqc_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

            LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
            LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
            LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
            LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣

            #原币，本币期间
            LET l_aah041=0   LET l_aah051=0
            LET l_aah042=0   LET l_aah052=0           
            LET l_tah091=0   LET l_tah101=0
            LET l_tah092=0   LET l_tah102=0
            OPEN gglq900_ybqj_cs USING l_abb03,l_abb24
            FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
            CLOSE gglq900_ybqj_cs
            IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
            IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
            IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
            IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 

            #借
            OPEN gglq900_ybqj_cs2 USING l_abb_str,'1',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
            IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
            #貸
            OPEN gglq900_ybqj_cs2 USING l_abb_str,'2',l_abb24
            FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
            CLOSE gglq900_ybqj_cs2
            IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
            IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

            LET qj_aah04 = l_aah041 + l_aah042
            LET qj_aah05 = l_aah051 + l_aah052
            LET qj_tah09 = l_tah091 + l_tah092
            LET qj_tah10 = l_tah101 + l_tah102

            LET qm_aah04 = qc_aah04 + qj_aah04
            LET qm_aah05 = qc_aah05 + qj_aah05
            LET qm_tah09 = qc_tah09 + qj_tah09
            LET qm_tah10 = qc_tah10 + qj_tah10

            LET l_aag02 = NULL 
            SELECT aag02,aag06 INTO l_aag02,l_aag06 
              FROM aag_file 
             WHERE aag00 = g_aza.aza81 
               AND aag01 = l_abb03

            #借余
            IF l_aag06 = '1' THEN 
               LET l_dqf = dq_abb07f_1 - dq_abb07f_2       #原幣當期發生額
               LET l_dq  = dq_abb07_1  - dq_abb07_2        #本幣當期發生額  
               LET l_qc  = qc_aah04 - qc_aah05             #總帳本幣期初餘額
               LET l_qcf = qc_tah09 - qc_tah10             #總帳原幣期初餘額
               LET l_c   = qj_aah04 - qj_aah05             #總帳本幣當期發生額
               LET l_cf  = qj_tah09 - qj_tah10             #總帳原幣當期發生額
               LET l_d   = qm_aah04 - qm_aah05             #總帳本幣期末餘額 
               LET l_df  = qm_tah09 - qm_tah10             #總帳原幣期末餘額
            END IF 
            #貸余
            IF l_aag06 = '2' THEN 
               LET l_dqf = dq_abb07f_2 - dq_abb07f_1       #原幣當期發生額
               LET l_dq  = dq_abb07_2  - dq_abb07_1        #本幣當期發生額
               LET l_qc  = qc_aah05 - qc_aah04             #總帳本幣期初餘額
               LET l_qcf = qc_tah10 - qc_tah09             #總帳原幣期初餘額
               LET l_c   = qj_aah05 - qj_aah04             #總帳本幣當期發生額
               LET l_cf  = qj_tah10 - qj_tah09             #總帳原幣當期發生額
               LET l_d   = qm_aah05 - qm_aah04             #總帳本幣期末餘額 
               LET l_df  = qm_tah10 - qm_tah09             #總帳原幣期末餘額
            END IF

            IF cl_null(l_dqf) THEN 
               LET l_dqf = 0
            END IF 
            IF cl_null(l_dq) THEN 
               LET l_dq = 0
            END IF 
            IF cl_null(l_qc) THEN 
               LET l_qc = 0
            END IF 
            IF cl_null(l_qcf) THEN 
               LET l_qcf = 0
            END IF 
            IF cl_null(l_c) THEN 
               LET l_c = 0
            END IF 
            IF cl_null(l_cf) THEN 
               LET l_cf = 0
            END IF 
            IF cl_null(l_d) THEN 
               LET l_d = 0
            END IF 
            IF cl_null(l_df) THEN 
               LET l_df = 0
            END IF
         
         
            LET l_df_c  = l_c  - l_dq                     #本幣當期發生額差異
            IF cl_null(l_df_c) THEN 
               LET l_df_c = 0
            END IF
            LET l_df_cf = l_cf - l_dqf                    #原幣當期發生額差異
            IF cl_null(l_df_cf) THEN 
               LET l_df_cf = 0
            END IF

            INSERT INTO gglq900_tmp 
            VALUES('','',l_abb03,l_aag02,l_abb24,l_dqf,l_dq,
                   l_cf,l_c,l_df_cf,l_df_c,0,0,l_df,l_d,
                   0,0)
         END FOREACH 
      ELSE
         #當期發生額  借
         LET l_sql = "SELECT SUM(abb07),sum(abb07f)",
                     "  FROM aba_file,abb_file ",
                     " WHERE aba00 = abb00 ",
                     "   AND aba01 = abb01 ",
                     "   AND aba00 = '",g_aza.aza81,"'",
                     "   AND aba03 = ",tm.yy,
                     "   AND aba04 = ",tm.mm,
                     "   AND abb06 = 1 ",
                     "   AND aba19 <> 'X' ",
                     "   AND abaacti = 'Y'",
                     "   AND abb03 LIKE '",l_abb03,"%'"
         PREPARE gglq900_abb_p10_1 FROM l_sql
         EXECUTE gglq900_abb_p10_1 INTO dq_abb07_1,dq_abb07f_1
         IF cl_null(dq_abb07_1) THEN 
            LET dq_abb07_1 = 0
         END IF 
         IF cl_null(dq_abb07f_1) THEN 
            LET dq_abb07f_1 = 0
         END IF 
      

         #當期發生額  貸
         LET l_sql = "SELECT SUM(abb07),sum(abb07f)",
                     "  FROM aba_file,abb_file ",
                     " WHERE aba00 = abb00 ",
                     "   AND aba01 = abb01 ",
                     "   AND aba00 = '",g_aza.aza81,"'",
                     "   AND aba03 = ",tm.yy,
                     "   AND aba04 = ",tm.mm,
                     "   AND abb06 = 2 ",
                     "   AND aba19 <> 'X' ",
                     "   AND abaacti = 'Y'",
                     "   AND abb03 LIKE '",l_abb03,"%'"
         PREPARE gglq900_abb_p11_1 FROM l_sql
         EXECUTE gglq900_abb_p11_1 INTO dq_abb07_2,dq_abb07f_2
         IF cl_null(dq_abb07_2) THEN 
            LET dq_abb07_2 = 0
         END IF 
         IF cl_null(dq_abb07f_2) THEN 
            LET dq_abb07f_2 = 0
         END IF 
      
         #期初值
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qc_cs1 USING l_abb03
         FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qc_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qc_cs2 USING l_abb_str,'1'
         FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qc_cs2 USING l_abb_str,'2'
         FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qc_aah04 = l_aah041 + l_aah042
         LET qc_aah05 = l_aah051 + l_aah052

         #期間
         LET l_aah041 = 0    LET l_aah051 = 0
         LET l_aah042 = 0    LET l_aah052 = 0
         OPEN gglq900_qj_cs1 USING l_abb03
         FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
         CLOSE gglq900_qj_cs1
         IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
         IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

         OPEN gglq900_qj_cs2 USING l_abb_str,'1'
         FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         OPEN gglq900_qj_cs2 USING l_abb_str,'2'
         FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_qj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052

         #期末
         LET qm_aah04 = qc_aah04 + qj_aah04
         LET qm_aah05 = qc_aah05 + qj_aah05

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = l_abb03

         #借余
         IF l_aag06 = '1' THEN 
            LET l_dqf = 0                               #原幣當期發生額
            LET l_dq  = dq_abb07_1  - dq_abb07_2        #本幣當期發生額  
            LET l_qc  = qc_aah04 - qc_aah05             #總帳本幣期初餘額
            LET l_qcf = 0                               #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05             #總帳本幣當期發生額
            LET l_cf  = 0                               #總帳原幣當期發生額
            LET l_d   = qm_aah04 - qm_aah05             #總帳本幣期末餘額 
            LET l_df  = 0                               #總帳原幣期末餘額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_dqf = 0                               #原幣當期發生額
            LET l_dq  = dq_abb07_2  - dq_abb07_1        #本幣當期發生額
            LET l_qc  = qc_aah05 - qc_aah04             #總帳本幣期初餘額
            LET l_qcf = 0                               #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04             #總帳本幣當期發生額
            LET l_cf  = 0                               #總帳原幣當期發生額
            LET l_d   = qm_aah05 - qm_aah04             #總帳本幣期末餘額 
            LET l_df  = 0                               #總帳原幣期末餘額
         END IF

         IF cl_null(l_dq) THEN 
            LET l_dq = 0
         END IF
         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_d) THEN 
            LET l_d = 0
         END IF 
         
         
         LET l_df_c  = l_c  - l_dq                     #本幣當期發生額差異
         IF cl_null(l_df_c) THEN 
            LET l_df_c = 0
         END IF
         LET l_df_cf = 0                               #原幣當期發生額差異
         IF cl_null(l_df_cf) THEN 
            LET l_df_cf = 0
         END IF

         INSERT INTO gglq900_tmp 
         VALUES('','',l_abb03,l_aag02,'',l_dqf,l_dq,
                l_cf,l_c,l_df_cf,l_df_c,0,0,l_df,l_d,
                0,0)
      END IF 
   END FOREACH  
   DELETE FROM gglq900_tmp 
    WHERE alz13f = 0
      AND alz13  = 0
      AND cf = 0
      AND c = 0
      AND df = 0
      AND d = 0
END FUNCTION 
 
#TQC-D80007--add--str--
FUNCTION gglq900_qj(l_abb03)
   DEFINE l_abb03       LIKE abb_file.abb03
   DEFINE l_abb_str     LIKE abb_file.abb03
   DEFINE l_cf          LIKE abb_file.abb07f    #總帳原幣當期發生額
   DEFINE l_c           LIKE abb_file.abb07     #總帳本幣當期發生額
   DEFINE l_qcf         LIKE abb_file.abb07f    #總帳原幣期初餘額
   DEFINE l_qc          LIKE abb_file.abb07     #總帳本幣期初餘額
   DEFINE l_aag02       LIKE aag_file.aag02
   DEFINE l_aag06       LIKE aag_file.aag06
   DEFINE l_abb24       LIKE abb_file.abb24
   DEFINE l_aah041      LIKE aah_file.aah04
   DEFINE l_aah042      LIKE aah_file.aah04
   DEFINE l_aah051      LIKE aah_file.aah05
   DEFINE l_aah052      LIKE aah_file.aah05
   DEFINE l_tah091      LIKE tah_file.tah09
   DEFINE l_tah092      LIKE tah_file.tah09
   DEFINE l_tah101      LIKE tah_file.tah10
   DEFINE l_tah102      LIKE tah_file.tah10
   DEFINE qc_aah04      LIKE aah_file.aah04
   DEFINE qc_aah05      LIKE aah_file.aah05
   DEFINE qc_tah09      LIKE tah_file.tah09
   DEFINE qc_tah10      LIKE tah_file.tah10
   DEFINE qj_aah04      LIKE aah_file.aah04
   DEFINE qj_aah05      LIKE aah_file.aah05
   DEFINE qj_tah09      LIKE tah_file.tah09
   DEFINE qj_tah10      LIKE tah_file.tah10


   CALL gglq900_curs()  
   
   LET l_abb_str = l_abb03 CLIPPED,'\%'
   IF tm.e = 'Y' THEN 
      FOREACH gglq900_abb24_cs USING l_abb_str,l_abb_str INTO l_abb24
         #原币，本币期初
         LET l_aah041=0   LET l_aah051=0
         LET l_aah042=0   LET l_aah052=0
         LET l_tah091=0   LET l_tah101=0
         LET l_tah092=0   LET l_tah102=0
         OPEN gglq900_ybqc_cs USING l_abb03,l_abb24
         FETCH gglq900_ybqc_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
         CLOSE gglq900_ybqc_cs
         IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
         IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
         IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
         IF cl_null(l_tah101) THEN LET l_tah101=0 END IF  

         #借
         OPEN gglq900_ybqc_cs2 USING l_abb_str,'1',l_abb24
         FETCH gglq900_ybqc_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_ybqc_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
         #貸
         OPEN gglq900_ybqc_cs2 USING l_abb_str,'2',l_abb24
         FETCH gglq900_ybqc_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_ybqc_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
         IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF 

         LET qc_aah04 = l_aah041 + l_aah042    #借   本幣
         LET qc_aah05 = l_aah051 + l_aah052    #貸   本幣
         LET qc_tah09 = l_tah091 + l_tah092    #借   原幣
         LET qc_tah10 = l_tah101 + l_tah102    #貸   原幣
      
         #原币，本币期间
         LET l_aah041=0   LET l_aah051=0
         LET l_aah042=0   LET l_aah052=0           
         LET l_tah091=0   LET l_tah101=0
         LET l_tah092=0   LET l_tah102=0
         OPEN gglq900_ybqj_cs USING l_abb03,l_abb24
         FETCH gglq900_ybqj_cs INTO l_aah041,l_aah051,l_tah091,l_tah101
         CLOSE gglq900_ybqj_cs
         IF cl_null(l_aah041) THEN LET l_aah041=0 END IF 
         IF cl_null(l_aah051) THEN LET l_aah051=0 END IF 
         IF cl_null(l_tah091) THEN LET l_tah091=0 END IF 
         IF cl_null(l_tah101) THEN LET l_tah101=0 END IF 

         #借
         OPEN gglq900_ybqj_cs2 USING l_abb_str,'1',l_abb24
         FETCH gglq900_ybqj_cs2 INTO l_aah042,l_tah092
         CLOSE gglq900_ybqj_cs2
         IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
         IF cl_null(l_tah092) THEN LET l_tah092 = 0 END IF
         #貸
         OPEN gglq900_ybqj_cs2 USING l_abb_str,'2',l_abb24
         FETCH gglq900_ybqj_cs2 INTO l_aah052,l_tah102
         CLOSE gglq900_ybqj_cs2
         IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF
         IF cl_null(l_tah102) THEN LET l_tah102 = 0 END IF

         LET qj_aah04 = l_aah041 + l_aah042
         LET qj_aah05 = l_aah051 + l_aah052
         LET qj_tah09 = l_tah091 + l_tah092
         LET qj_tah10 = l_tah101 + l_tah102

         LET l_aag02 = NULL 
         SELECT aag02,aag06 INTO l_aag02,l_aag06 
           FROM aag_file 
          WHERE aag00 = g_aza.aza81 
            AND aag01 = l_abb03

         #借余
         IF l_aag06 = '1' THEN 
            LET l_qc  = qc_aah04 - qc_aah05             #總帳本幣期初餘額
            LET l_qcf = qc_tah09 - qc_tah10             #總帳原幣期初餘額
            LET l_c   = qj_aah04 - qj_aah05             #總帳本幣當期發生額
            LET l_cf  = qj_tah09 - qj_tah10             #總帳原幣當期發生額
         END IF 
         #貸余
         IF l_aag06 = '2' THEN 
            LET l_qc  = qc_aah05 - qc_aah04             #總帳本幣期初餘額
            LET l_qcf = qc_tah10 - qc_tah09             #總帳原幣期初餘額
            LET l_c   = qj_aah05 - qj_aah04             #總帳本幣當期發生額
            LET l_cf  = qj_tah10 - qj_tah09             #總帳原幣當期發生額
         END IF

         IF cl_null(l_qc) THEN 
            LET l_qc = 0
         END IF 
         IF cl_null(l_qcf) THEN 
            LET l_qcf = 0
         END IF
         IF cl_null(l_c) THEN 
            LET l_c = 0
         END IF 
         IF cl_null(l_cf) THEN 
            LET l_cf = 0
         END IF 

         RETURN l_qc,l_qcf,l_c,l_cf  
      END FOREACH 
   ELSE  
      #期初值
      LET l_aah041 = 0    LET l_aah051 = 0
      LET l_aah042 = 0    LET l_aah052 = 0
      OPEN gglq900_qc_cs1 USING l_abb03
      FETCH gglq900_qc_cs1 INTO l_aah041,l_aah051
      CLOSE gglq900_qc_cs1
      IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
      IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

      OPEN gglq900_qc_cs2 USING l_abb_str,'1'
      FETCH gglq900_qc_cs2 INTO l_aah042,l_tah092
      CLOSE gglq900_qc_cs2
      IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
      OPEN gglq900_qc_cs2 USING l_abb_str,'2'
      FETCH gglq900_qc_cs2 INTO l_aah052,l_tah102
      CLOSE gglq900_qc_cs2
      IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

      LET qc_aah04 = l_aah041 + l_aah042
      LET qc_aah05 = l_aah051 + l_aah052
   
      #期間
      LET l_aah041 = 0    LET l_aah051 = 0
      LET l_aah042 = 0    LET l_aah052 = 0
      OPEN gglq900_qj_cs1 USING l_abb03
      FETCH gglq900_qj_cs1 INTO l_aah041,l_aah051
      CLOSE gglq900_qj_cs1
      IF cl_null(l_aah041) THEN LET l_aah041 = 0 END IF
      IF cl_null(l_aah051) THEN LET l_aah051 = 0 END IF

      OPEN gglq900_qj_cs2 USING l_abb_str,'1'
      FETCH gglq900_qj_cs2 INTO l_aah042,l_tah092
      CLOSE gglq900_qj_cs2
      IF cl_null(l_aah042) THEN LET l_aah042 = 0 END IF
      OPEN gglq900_qj_cs2 USING l_abb_str,'2'
      FETCH gglq900_qj_cs2 INTO l_aah052,l_tah102
      CLOSE gglq900_qj_cs2
      IF cl_null(l_aah052) THEN LET l_aah052 = 0 END IF

      LET qj_aah04 = l_aah041 + l_aah042
      LET qj_aah05 = l_aah051 + l_aah052

      LET l_aag02 = NULL 
      SELECT aag02,aag06 INTO l_aag02,l_aag06 
        FROM aag_file 
       WHERE aag00 = g_aza.aza81 
         AND aag01 = l_abb03

      #借余
      IF l_aag06 = '1' THEN 
         LET l_qc  = qc_aah04 - qc_aah05             #總帳本幣期初餘額
         LET l_qcf = 0                               #總帳原幣期初餘額
         LET l_c   = qj_aah04 - qj_aah05             #總帳本幣當期發生額
         LET l_cf  = 0                               #總帳原幣當期發生額
      END IF 
      #貸余
      IF l_aag06 = '2' THEN 
         LET l_qc  = qc_aah05 - qc_aah04             #總帳本幣期初餘額
         LET l_qcf = 0                               #總帳原幣期初餘額 
         LET l_c   = qj_aah05 - qj_aah04             #總帳本幣當期發生額
         LET l_cf  = 0                               #總帳原幣當期發生額
      END IF

      IF cl_null(l_qc) THEN 
         LET l_qc = 0
      END IF 
      IF cl_null(l_c) THEN 
         LET l_c = 0
      END IF 
      
      RETURN l_qc,l_qcf,l_c,l_cf    
   END IF 
END FUNCTION 
#TQC-D80007--add--end--

FUNCTION gglq900_table()
     DROP TABLE gglq900_tmp;
     CREATE TEMP TABLE gglq900_tmp(
                    alz01      LIKE alz_file.alz01,      
                    occ02      LIKE occ_file.occ02,    
                    alz14      LIKE alz_file.alz14,
                    aag02      LIKE aag_file.aag02,
                    alz10      LIKE alz_file.alz10,
                    alz13f     LIKE alz_file.alz13f,  
                    alz13      LIKE alz_file.alz13,
                    cf         LIKE alz_file.alz13,     #总帐原币当期发生额
                    c          LIKE alz_file.alz13,     #总帐本币当期发生额
                    df_cf      LIKE alz_file.alz13,     #原币当期发生额差异
                    df_c       LIKE alz_file.alz13,     #本币当期发生额差异
                    alz09f     LIKE alz_file.alz09f,
                    alz09      LIKE alz_file.alz09,
                    df         LIKE alz_file.alz13,     #总帐原币期末余额
                    d          LIKE alz_file.alz13,     #总帐本币期末余额
                    df_tf      LIKE alz_file.alz13,     #原币余额差异
                    df_t       LIKE alz_file.alz13);    #本币余额差异
END FUNCTION
 
FUNCTION q900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      INPUT tm.a FROM a ATTRIBUTE(WITHOUT DEFAULTS) 
         ON CHANGE a
            IF NOT cl_null(tm.a)  THEN
               CALL gglq900_b_fill()
            END IF 
      END INPUT
      DISPLAY ARRAY g_alz TO s_alz.* ATTRIBUTE(COUNT=g_rec_b)
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         IF g_rec_b != 0 AND l_ac != 0 THEN  
            CALL fgl_set_arr_curr(l_ac)     
         END IF                            
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG
         
      END DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
 
      #子系統查詢
      ON ACTION inquiry_subsystem
         LET g_action_choice="inquiry_subsystem"
         EXIT DIALOG
         
      #總帳查詢
      ON ACTION ledger_enquiry
         LET g_action_choice="ledger_enquiry"
         EXIT DIALOG  
         
      #月結
      ON ACTION monthly_statement
         LET g_action_choice="monthly_statement"
         EXIT DIALOG
 #No.FUN-D70072 ---Add--- Start
      #應付月结
      ON ACTION ap_monthly_statement
         LET g_action_choice="ap_monthly_statement"
         EXIT DIALOG

      #應收月结
      ON ACTION ar_monthly_statement
         LET g_action_choice="ar_monthly_statement"
         EXIT DIALOG
     #No.FUN-D70072 ---Add--- End

      #反月結
      ON ACTION monthly_statement_return
         LET g_action_choice="monthly_statement_return"
         EXIT DIALOG

      #帳齡更新
      ON ACTION aging_update
         LET g_action_choice="aging_update"
         EXIT DIALOG
         
      #關帳
      ON ACTION closing
         LET g_action_choice="closing"
         EXIT DIALOG
         #No.FUN-D70072 ---Add--- Start
      #關帳
      ON ACTION ap_closing
         LET g_action_choice="ap_closing"
         EXIT DIALOG
      #關帳
      ON ACTION ar_closing
         LET g_action_choice="ar_closing"
         EXIT DIALOG
     #No.FUN-D70072 ---Add--- ENd

      #银行存款对账关账
      ON ACTION check_closing
         LET g_action_choice="check_closing"
         EXIT DIALOG

      #月结异常单据
      ON ACTION anomalies
         LET g_action_choice="anomalies"
         EXIT DIALOG   
         
      ON ACTION first
         CALL gglq900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG
 
      ON ACTION previous
         CALL gglq900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG
 
      ON ACTION jump
         CALL gglq900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG
 
      ON ACTION next
         CALL gglq900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG
 
      ON ACTION last
         CALL gglq900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION gglq900_cs()
     LET g_sql = "SELECT UNIQUE alz01,alz14 FROM gglq900_tmp ",
                 " ORDER BY alz01,alz14"
     PREPARE gglq900_ps FROM g_sql
     DECLARE gglq900_curs SCROLL CURSOR WITH HOLD FOR gglq900_ps
 
     LET g_sql = "SELECT UNIQUE alz01,alz14 FROM gglq900_tmp ",
                 "  INTO TEMP x "
     DROP TABLE x
     PREPARE gglq900_ps1 FROM g_sql
     EXECUTE gglq900_ps1
 
     LET g_sql = "SELECT COUNT(*) FROM x"
     PREPARE gglq900_ps2 FROM g_sql
     DECLARE gglq900_cnt CURSOR FOR gglq900_ps2
 
     OPEN gglq900_curs
     IF SQLCA.sqlcode THEN
        CALL cl_err('OPEN gglq900_curs',SQLCA.sqlcode,0)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        EXIT PROGRAM
     ELSE
        OPEN gglq900_cnt
        FETCH gglq900_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL gglq900_fetch('F')
     END IF
END FUNCTION
 
FUNCTION gglq900_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,
   l_abso          LIKE type_file.num10
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     gglq900_curs INTO g_alz01,g_alz14
      WHEN 'P' FETCH PREVIOUS gglq900_curs INTO g_alz01,g_alz14
      WHEN 'F' FETCH FIRST    gglq900_curs INTO g_alz01,g_alz14
      WHEN 'L' FETCH LAST     gglq900_curs INTO g_alz01,g_alz14
      WHEN '/'
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION about
                   CALL cl_about()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION controlg
                   CALL cl_cmdask()
 
             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
 
         END IF
         FETCH ABSOLUTE g_jump gglq900_curs INTO g_alz01,g_alz14
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_alz01,SQLCA.sqlcode,0)
      INITIALIZE g_alz01 TO NULL
      INITIALIZE g_alz14 TO NULL
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   CALL gglq900_show()
END FUNCTION
 
FUNCTION gglq900_show()

   DISPLAY tm.a    TO a
   DISPLAY tm.b    TO b
   DISPLAY tm.yy   TO yy
   DISPLAY tm.mm   TO mm
   DISPLAY tm.e    TO e
 
   CALL gglq900_b_fill()
 
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION gglq900_b_fill()
  DEFINE  l_npq06    LIKE npq_file.npq06
  DEFINE  l_type     LIKE type_file.chr1
  DEFINE  l_memo     LIKE abb_file.abb04

   IF tm.a = '1' THEN 
      IF tm.e = 'N' THEN 
      #No.FUN-D70072 ---Add--- Start
         IF tm.b = '2' AND tm.choice = '2' THEN
            LET g_sql = "SELECT alz01,occ02,alz14,aag02,'','','',SUM(alz13f),SUM(alz13),SUM(cf),SUM(c),SUM(df_cf),SUM(df_c),",
                        "       SUM(alz09f),SUM(alz09),SUM(df),SUM(d),SUM(df_tf),SUM(df_t)",
                        " FROM gglq900_tmp",
                        " GROUP BY alz01,occ02,alz14,aag02",
                        " ORDER BY alz14,aag02"
         ELSE
        #No.FUN-D70072 ---Add--- End
         LET g_sql = "SELECT '','',alz14,aag02,'','','',SUM(alz13f),SUM(alz13),SUM(cf),SUM(c),SUM(df_cf),SUM(df_c),",  #No.FUN-D70072   Add '',''
                     "       SUM(alz09f),SUM(alz09),SUM(df),SUM(d),SUM(df_tf),SUM(df_t)",
                     " FROM gglq900_tmp",
                     " GROUP BY alz14,aag02",
                     " ORDER BY alz14,aag02"  
                     END IF   #No.FUN-D70072   Add
         ELSE
     #No.FUN-D70072 ---Add--- Start
         IF tm.b = '2' AND tm.choice = '2' THEN
        LET g_sql = "SELECT alz01,occ02,alz14,aag02,'','',alz10,SUM(alz13f),SUM(alz13),SUM(cf),SUM(c),SUM(df_cf),SUM(df_c),",
                     "       SUM(alz09f),SUM(alz09),SUM(df),SUM(d),SUM(df_tf),SUM(df_t)",
                     " FROM gglq900_tmp",
                     " GROUP BY alz01,occ02,alz14,aag02,alz10",
                     " ORDER BY alz14,aag02,alz10"
         ELSE
        #No.FUN-D70072 ---Add--- End
       LET g_sql = "SELECT '','',alz14,aag02,'','',alz10,SUM(alz13f),SUM(alz13),SUM(cf),SUM(c),SUM(df_cf),SUM(df_c),",    #No.FUN-D70072   Add '',''
                     "       SUM(alz09f),SUM(alz09),SUM(df),SUM(d),SUM(df_tf),SUM(df_t)",
                     " FROM gglq900_tmp",
                     " GROUP BY alz14,aag02,alz10",
                     " ORDER BY alz14,aag02,alz10" 
                      END IF   #No.FUN-D70072   Add 
     END IF 
   END IF 

   IF tm.a = '2' THEN 
      IF tm.e = 'N' THEN 
         LET g_sql = "SELECT alz01,occ02,'','','','','',SUM(alz13f),SUM(alz13),SUM(cf),SUM(c),SUM(df_cf),SUM(df_c),",    #No.FUN-D70072   Add '',''
                     "       SUM(alz09f),SUM(alz09),SUM(df),SUM(d),SUM(df_tf),SUM(df_t)",
                     " FROM gglq900_tmp",
                     " GROUP BY alz01,occ02",
                     " ORDER BY alz01,occ02"  
      ELSE 
        LET g_sql = "SELECT alz01,occ02,'','','','',alz10,SUM(alz13f),SUM(alz13),SUM(cf),SUM(c),SUM(df_cf),SUM(df_c),",  #No.FUN-D70072   Add '',''  
                     "       SUM(alz09f),SUM(alz09),SUM(df),SUM(d),SUM(df_tf),SUM(df_t)",
                     " FROM gglq900_tmp",
                     " GROUP BY alz01,occ02,alz10",
                     " ORDER BY alz01,occ02,alz10" 
      END IF 
   END IF 

   IF tm.a = '3' THEN 
      IF tm.e = 'N' THEN 
         LET g_sql = "SELECT alz01,occ02,alz14,aag02,'','','',alz13f,alz13,cf,c,df_cf,df_c,",  #No.FUN-D70072   Add '',''   
                     "       alz09f,alz09,df,d,df_tf,df_t",
                     " FROM gglq900_tmp",
                     " ORDER BY alz01,alz14"   
      ELSE 
         LET g_sql = "SELECT alz01,occ02,alz14,aag02,'','',alz10,alz13f,alz13,cf,c,df_cf,df_c,",     #No.FUN-D70072   Add '',''  
                     "       alz09f,alz09,df,d,df_tf,df_t",
                     " FROM gglq900_tmp",
                     " ORDER BY alz01,alz14,alz10" 
      END IF 
   END IF             
 
   PREPARE gglq900_pb FROM g_sql
   DECLARE aed_curs  CURSOR FOR gglq900_pb
 
   CALL g_alz.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH aed_curs INTO g_alz[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #No.FUN-D70072 ---Add--- Start
      LET g_alz[g_cnt].nma01 = g_alz[g_cnt].alz01
      LET g_alz[g_cnt].nma02 = g_alz[g_cnt].occ02
     #No.FUN-D70072 ---Add--- End
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_alz.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cnt
   CALL gglq900_t1()
END FUNCTION

FUNCTION gglq900_t()
   DEFINE comb_value STRING
   DEFINE comb_item  STRING 
   DEFINE l_msg1     STRING 
   DEFINE l_msg2     STRING 
   DEFINE l_msg3     STRING 

   #子系統查詢  inquiry_subsystem
   #總帳查詢    ledger_enquiry
   #月結       monthly_statement
   #帳齡更新    aging_update
   #關帳       closing
   #银行存款对账关账   check_closing
   #反月結       monthly_statement_return
   #月结异常单据   anomalies
   
   #No.FUN-D70072 ---Add--- Start
   IF cl_null(tm.b) THEN RETURN END IF
   CALL cl_set_comp_visible("nma01,nma02",FALSE)
  #No.FUN-D70072 ---Add--- End

   IF tm.e = 'Y' THEN 
      CALL cl_set_comp_visible("alz10,alz13f,cf,df_cf,alz09f,df,df_tf",TRUE)
   ELSE
      CALL cl_set_comp_visible("alz10,alz13f,cf,df_cf,alz09f,df,df_tf",FALSE)
   END IF
   
   CALL cl_set_act_visible("inquiry_subsystem,ledger_enquiry,monthly_statement,aging_update",FALSE)
   CALL cl_set_act_visible("closing,check_closing,monthly_statement_return",FALSE)
   
   IF tm.b = '1' OR tm.b = '2' THEN
      CALL cl_set_comp_visible("alz01,occ02,alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz13,c,df_c,alz09,d,df_t",TRUE)
      CALL cl_set_act_visible("inquiry_subsystem,ledger_enquiry,monthly_statement,aging_update,closing",TRUE)
   END IF  
   
   IF tm.b = '3' THEN 
      CALL cl_set_act_visible("inquiry_subsystem,ledger_enquiry,monthly_statement,check_closing,closing",TRUE)
      CALL cl_set_comp_visible("alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz01,occ02",FALSE)
      CALL cl_set_comp_visible("alz13,c,df_c,alz09,d,df_t",TRUE)
   END IF 

   IF tm.b = '4' THEN 
      CALL cl_set_comp_visible("alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz01,occ02",FALSE)
      CALL cl_set_comp_visible("alz13,c,df_c,alz09,d,df_t",TRUE)
      CALL cl_set_act_visible("monthly_statement,monthly_statement_return,closing",TRUE)
   END IF 
   
   IF tm.b = '5' THEN 
      CALL cl_set_comp_visible("alz09f,alz09,df_tf,df_t,d,df",FALSE)
      CALL cl_set_comp_visible("alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz01,occ02",FALSE)
      CALL cl_set_act_visible("monthly_statement,monthly_statement_return,closing",TRUE)
   END IF 

    
   LET g_comb = ui.ComboBox.forName("a")
   IF tm.b = '3' THEN
      CALL g_comb.removeItem('2')
      CALL g_comb.removeItem('3')
   END IF
   LET comb_value = '1,2,3'
   LET l_msg1 = cl_getmsg('ggl-104',g_lang)
   LET l_msg2 = cl_getmsg('ggl-105',g_lang)
   LET l_msg3 = cl_getmsg('ggl-106',g_lang)
   LET comb_item = l_msg1
   CALL cl_set_combo_items('a',comb_value,comb_item)
   IF tm.b = '3' OR tm.b = '4' OR tm.b = '5' THEN 
      LET comb_value = '1'
      LET l_msg1 = cl_getmsg('ggl-105',g_lang)
      CALL cl_set_combo_items('a',comb_value,comb_item)
   END IF 
   #No.FUN-D70072 ---Add--- Start
   IF tm.choice = '1' THEN
      CALL cl_set_act_visible("ap_closing,ar_closing,ap_monthly_statement,ar_monthly_statement",FALSE) 
   ELSE
     IF tm.b = '1' THEN
        CALL cl_set_act_visible("ap_closing,ar_closing,ap_monthly_statement,ar_monthly_statement",TRUE) 
        CALL cl_set_act_visible("closing,closing,monthly_statement,monthly_statement",FALSE) 
     ELSE
        CALL cl_set_act_visible("ap_closing,ar_closing,ap_monthly_statement,ar_monthly_statement",FALSE)
        CALL cl_set_act_visible("closing,closing,monthly_statement,monthly_statement",TRUE)
     END IF
   END IF
  #No.FUN-D70072 ---Add--- End
END FUNCTION 

FUNCTION gglq900_t1()
   IF tm.a = '1' THEN 
      CALL cl_set_comp_visible("alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz01,occ02",FALSE)
   END IF  
   IF tm.a = '2' THEN 
      CALL cl_set_comp_visible("alz14,aag02",FALSE)
      CALL cl_set_comp_visible("alz01,occ02",TRUE)
   END IF
   IF tm.a = '3' THEN 
      CALL cl_set_comp_visible("alz01,occ02,alz14,aag02",TRUE)
   END IF 
   #No.FUN-D70072 ---Add--- Start
   IF tm.b = '2' AND tm.choice = '2' THEN
      CALL cl_set_comp_visible("alz13 ,c ,df_c",FALSE)
   ELSE
      CALL cl_set_comp_visible("alz13 ,c ,df_c",TRUE)
   END IF
  #No.FUN-D70072 ---Add--- End
END FUNCTION 

#No.FUN-D70072 ---Add--- Start
FUNCTION gglq900_t_1()
   DEFINE comb_value STRING
   DEFINE comb_item  STRING 
   DEFINE l_msg1     STRING 
   DEFINE l_msg2     STRING 
   DEFINE l_msg3     STRING 

   #子系統查詢  inquiry_subsystem
   #總帳查詢    ledger_enquiry
   #月結       monthly_statement
   #帳齡更新    aging_update
   #關帳       closing
   #银行存款对账关账   check_closing
   #反月結       monthly_statement_return
   #月结异常单据   anomalies

   IF cl_null(tm.b) THEN RETURN END IF
   CALL cl_set_comp_visible("nma01,nma02",TRUE)
   
   IF tm.e = 'Y' THEN 
      CALL cl_set_comp_visible("alz10,alz13f,cf,df_cf,alz09f,df,df_tf",TRUE)
   ELSE
      CALL cl_set_comp_visible("alz10,alz13f,cf,df_cf,alz09f,df,df_tf",FALSE)
   END IF
   
   CALL cl_set_act_visible("inquiry_subsystem,ledger_enquiry,monthly_statement,aging_update",FALSE)
   CALL cl_set_act_visible("closing,check_closing,monthly_statement_return",FALSE)
   
   IF tm.b = '1' THEN
      CALL cl_set_comp_visible("alz01,occ02,alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz13,c,df_c,alz09,d,df_t",TRUE)
      CALL cl_set_comp_visible("nma01,nma02",FALSE)
      CALL cl_set_act_visible("inquiry_subsystem,ledger_enquiry,monthly_statement,aging_update,closing",TRUE)
   END IF  
   
   IF tm.b = '2' THEN 
      CALL cl_set_act_visible("inquiry_subsystem,ledger_enquiry,monthly_statement,check_closing,closing",TRUE)
      CALL cl_set_comp_visible("nma01,nma02,alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz01,occ02",FALSE)
      CALL cl_set_comp_visible("nma01,nma02",TRUE)
      CALL cl_set_comp_visible("alz13,c,df_c,alz09,d,df_t",TRUE)
   END IF 

   IF tm.b = '3' THEN 
      CALL cl_set_comp_visible("alz14,aag02",TRUE)
      CALL cl_set_comp_visible("alz01,occ02",FALSE)
      CALL cl_set_comp_visible("alz13,c,df_c,alz09,d,df_t",TRUE)
      CALL cl_set_comp_visible("nma01,nma02",FALSE)
      CALL cl_set_act_visible("monthly_statement,monthly_statement_return,closing",TRUE)
   END IF
    
   LET g_comb = ui.ComboBox.forName("a")
   IF tm.b = '3' THEN
      CALL g_comb.removeItem('2')
      CALL g_comb.removeItem('3')
   END IF
   LET comb_value = '1,2,3'
   LET comb_item = cl_getmsg('ggl-104',g_lang)
   CALL cl_set_combo_items('a',comb_value,comb_item)
   IF tm.b = '3' OR tm.b = '4' THEN 
      LET comb_value = '1'
      LET l_msg1 = cl_getmsg('ggl-105',g_lang)
      CALL cl_set_combo_items('a',comb_value,comb_item)
   END IF 
  #No.FUN-D70072 ---Add--- Start
   IF tm.choice = '1' THEN
      CALL cl_set_act_visible("ap_closing,ar_closing,ap_monthly_statement,ar_monthly_statement",FALSE) 
   ELSE
     IF tm.b = '1' THEN
        CALL cl_set_act_visible("ap_closing,ar_closing,ap_monthly_statement,ar_monthly_statement",TRUE) 
        CALL cl_set_act_visible("closing,closing,monthly_statement,monthly_statement",FALSE) 
     ELSE
        CALL cl_set_act_visible("ap_closing,ar_closing,ap_monthly_statement,ar_monthly_statement",FALSE)
        CALL cl_set_act_visible("closing,closing,monthly_statement,monthly_statement",TRUE)
     END IF
   END IF
  #No.FUN-D70072 ---Add--- End
END FUNCTION 

FUNCTION gglq900_t1_1()
   DEFINE comb_value STRING
   DEFINE comb_item  STRING 
   
   LET g_comb = ui.ComboBox.forName("choice")
   CALL g_comb.removeItem('1')
   CALL g_comb.removeItem('2')
   CALL g_comb.removeItem('3')
   CALL g_comb.removeItem('4')
   CALL g_comb.removeItem('5')
   CASE
      WHEN tm.choice = '1'
         LET comb_value = '1,2,3,4,5'
         LET comb_item = cl_getmsg('ggl-106',g_lang)
         CALL cl_set_combo_items('b',comb_value,comb_item)
      WHEN tm.choice = '2'
         LET comb_value = '1,2,3'
         LET comb_item = cl_getmsg('ggl-107',g_lang)
         CALL cl_set_combo_items('b',comb_value,comb_item)
   END CASE
  #No.FUN-D70072 ---Add--- Start
   IF tm.b = '2' AND tm.choice = '2' THEN
      CALL cl_set_comp_visible("alz13 ,c ,df_c",FALSE)
   ELSE
      CALL cl_set_comp_visible("alz13 ,c ,df_c",TRUE)
   END IF
  #No.FUN-D70072 ---Add--- End
END FUNCTION 

#No.FUN-D70072 ---Add--- End



#子系統查詢     
FUNCTION q900_inquiry_subsystem()
   DEFINE l_wc   STRING 
   DEFINE l_str  STRING
   DEFINE l_str1 STRING 
   DEFINE l_str2 STRING 
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_nma01 LIKE nma_file.nma01
   IF s_shut(0) THEN
       RETURN
   END IF
   IF l_ac = 0 THEN 
      RETURN 
   END IF 
   IF cl_null(g_alz[l_ac].alz01) THEN 
      LET l_str1 = " AND 1=1"
   ELSE 
      IF tm.b = '1' THEN 
         LET l_str1 = " AND oma03=",'"',g_alz[l_ac].alz01,'"'
      END IF 
      IF tm.b = '2' THEN 
         LET l_str1 = " AND apa05=",'"',g_alz[l_ac].alz01,'"'
      END IF 
   END IF 
   IF cl_null(g_alz[l_ac].alz14) THEN 
      LET l_str2 = " AND 1=1" 
   ELSE 
      IF tm.b = '1' THEN 
         LET l_str2 = " AND oma18=",'"',g_alz[l_ac].alz14,'"'
      END IF 
      IF tm.b = '2' THEN 
         LET l_str2 = " AND apa54=",'"',g_alz[l_ac].alz14,'"'
      END IF 
   END IF 
   IF tm.b = '1' THEN 
      IF tm.a = '1' THEN 
         #LET l_wc = 'YEAR(oma02)="',tm.yy,'" AND MONTH(oma02)= "',tm.mm,'"',l_str2
         LET l_wc = " oma18=",'"',g_alz[l_ac].alz14,'"'
      END IF 
      IF tm.a = '2' THEN 
         #LET l_wc = 'YEAR(oma02)="',tm.yy,'" AND MONTH(oma02)= "',tm.mm,'"',l_str1
         LET l_wc = " oma03=",'"',g_alz[l_ac].alz01,'"'
      END IF 
      IF tm.a = '3' THEN 
          #LET l_wc = 'YEAR(oma02)="',tm.yy,'" AND MONTH(oma02)= "',tm.mm,'"',l_str1,l_str2
          LET l_wc = " oma18=",'"',g_alz[l_ac].alz14,'"'," AND oma03=",'"',g_alz[l_ac].alz01,'"'
      END IF 
   END IF 
   IF tm.b = '2' THEN 
      IF tm.a = '1' THEN 
         #LET l_wc = 'YEAR(apa02)="',tm.yy,'" AND MONTH(apa02)= "',tm.mm,'"',l_str2
         LET l_wc = " apa54=",'"',g_alz[l_ac].alz14,'"'
      END IF 
      IF tm.a = '2' THEN 
         #LET l_wc = 'YEAR(apa02)="',tm.yy,'" AND MONTH(apa02)= "',tm.mm,'"',l_str1 
         LET l_wc = " apa05=",'"',g_alz[l_ac].alz01,'"'
      END IF 
      IF tm.a = '3' THEN 
         LET l_wc = " apa54=",'"',g_alz[l_ac].alz14,'"'," AND apa05=",'"',g_alz[l_ac].alz01,'"'
      END IF 
   END IF 
   IF tm.b = '3' THEN 
      LET l_str1 = NULL 
      CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
      LET g_sql = "SELECT nma01 FROM nma_file ",
                  " WHERE nma05 = '",g_alz[l_ac].alz14,"'"
      PREPARE q900_pre_nma FROM g_sql
      DECLARE q900_cs_nma CURSOR FOR q900_pre_nma
      FOREACH q900_cs_nma INTO l_nma01
         IF cl_null(l_str1) THEN 
            LET l_str1 = '"',l_nma01,'"'
         ELSE
            LET l_str1 = l_str1,',"',l_nma01,'"'
         END IF 
      END FOREACH 
      LET l_wc = ' nma01 IN (',l_str1,') AND YEAR(nme16)="',tm.yy,'" AND MONTH(nme16)="',tm.mm,'"'
   END IF 

	 IF tm.choice = '1' THEN   #No.FUN-D70072   Add
   IF tm.b = '1' THEN 
      LET l_str="axrq310 '",tm.a,"' '",tm.e,"' 'N' '",l_wc,"'"
   END IF 
   IF tm.b = '2' THEN 
      LET l_str="aapq100 '",tm.a,"' '",tm.e,"' 'N' '",l_wc,"'"
   END IF 
   IF tm.b = '3' THEN 
      LET l_str="anmq300 '' '",l_wc,"'"
   END IF
   #No.FUN-D70072 ---Add--- Start
   ELSE
      IF tm.b = '1' THEN
         CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
         IF NOT cl_null(g_alz[l_ac].alz10) THEN
            LET l_wc = 'npq21 = "',g_alz[l_ac].alz01,'" AND npq22 = "',g_alz[l_ac].occ02,'" AND npq03 = "',g_alz[l_ac].alz14,'" AND npq24 = "',g_alz[l_ac].alz10,'"'
         ELSE
            LET l_wc = 'npq21 = "',g_alz[l_ac].alz01,'" AND npq22 = "',g_alz[l_ac].occ02,'" AND npq03 = "',g_alz[l_ac].alz14,'"'
         END IF
         LET l_str = "gapq910 '' '' '",g_lang,"' 'Y' '' '' '",l_wc CLIPPED,"' '",l_bdate,"' '",l_edate,"' '",g_aza.aza81,"' '",tm.e,"' '",g_alz[l_ac].alz10,"' '1' 'N' '' '' '' ''"
      END IF
   IF tm.b = '2' THEN
      LET l_str="aapq100 '",tm.a,"' '",tm.e,"' 'N' '",l_wc,"'"
   END IF
   IF tm.b = '3' THEN
      LET l_str="anmq300 '' '",l_wc,"'"
   END IF
   END IF
  #No.FUN-D70072 ---Add--- End
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

#總帳查詢
FUNCTION q900_ledger_enquiry()
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_wc1  STRING
   DEFINE l_wc2  STRING  
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   
   IF l_ac = 0 THEN 
      RETURN 
   END IF 
   
   IF tm.b = '1' OR tm.b = '2' THEN 
      IF cl_null(g_alz[l_ac].alz14) THEN 
         LET l_wc1 = " 1=1 " 
      ELSE
         LET l_wc1 = 'aag01 like "',g_alz[l_ac].alz14,'%"'
      END IF 
      IF cl_null(g_alz[l_ac].alz01) THEN 
         LET l_wc2 = " 1=1 " 
      ELSE 
         LET l_wc2 = 'ted02 = "',g_alz[l_ac].alz01,'"'
      END IF 
      CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
   
      LET l_str = "gglq702 '",g_aza.aza81,"' '' '' '",g_lang,"' 'Y' '' '' '",l_wc1 CLIPPED,"' '",l_wc2 CLIPPED,"' '",l_bdate,"' '",l_edate,"' '1' '",tm.e,"' '1' 'N' '' '' '' '' '' 'Y' 'N'"  
   END IF 
   IF tm.b = '3' THEN 
      LET l_wc1 = 'aah01 = "',g_alz[l_ac].alz14,'"'
      LET l_str = "gglq305 '' '' '",g_lang,"' 'N' '' '' '",g_aza.aza81,"' '",tm.yy,"' '",tm.mm,"' '",tm.mm,"' '1' 'N' '99' 'N' 'N' 'N' 'N' '",tm.e,"' '' 'N' '",l_wc1,"' 'N' 'Y' 'Y'"
   END IF 
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

#月結
FUNCTION q900_monthly_statement()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   IF tm.choice = '1' THEN    #No.FUN-D70072   Add
   IF tm.b = '1' THEN 
      #LET l_str="axrp500 '",tm.yy,"' '",tm.mm,"' 'N'"   #TQC-D70023 mark
      LET l_str="aglp130 '",tm.yy,"' '",tm.mm,"' "       #TQC-D70023 add
   END IF 
   IF tm.b = '2' THEN 
      LET l_str="aapp101 '",tm.yy,"' '",tm.mm,"' '' 'N'"
   END IF 
   IF tm.b = '3' THEN 
      LET l_str="anmp320 '",tm.yy,"' '",tm.mm,"' '' 'N'"
   END IF
   IF tm.b = '4' THEN 
      LET l_str="afap304 '",tm.yy,"' '",tm.mm,"' 'N' "
   END IF
   IF tm.b = '5' THEN 
      LET l_str="aglp201 '",g_aza.aza81,"' '' '' 'N'"
   END IF 
   #No.FUN-D70072 ---Add--- Start
   ELSE
      IF tm.b = '2' THEN
         LET l_str="anmp320 '",tm.yy,"' '",tm.mm,"' '' 'N'"
      END IF
      IF tm.b = '3' THEN 
         LET l_str="afap304 '",tm.yy,"' '",tm.mm,"' 'N' "
      END IF
   END IF
  #No.FUN-D70072 ---Add--- End
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

#No.FUN-D70072 ---Add--- Start
#月結
FUNCTION q900_apmonthly_statement()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF

   IF tm.b = '1' THEN
      LET l_str="aapp101 '",tm.yy,"' '",tm.mm,"' '' 'N'"
   END IF
   CALL cl_cmdrun_wait(l_str)
END FUNCTION

#月結
FUNCTION q900_armonthly_statement()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF

   IF tm.b = '1' THEN
      LET l_str="aglp130 '",tm.yy,"' '",tm.mm,"' "        
   END IF
   CALL cl_cmdrun_wait(l_str)
END FUNCTION

#關帳
FUNCTION q900_apclosing()
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
   LET l_str="aapp500 '' '' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION

#關帳
FUNCTION q900_arclosing()
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
   LET l_str="axrp401 '' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION
#No.FUN-D70072 ---Add--- End

#帳齡更新
FUNCTION q900_aging_update()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   
   IF tm.b = '1' THEN 
      #LET l_str="aapp600 '2'"  #TQC-D70023 mark
      LET l_str="axrp600 "      #TQC-D70023 add
   END IF 
   IF tm.b = '2' THEN 
      #LET l_str="aapp600 '1'"  #TQC-D70023 mark
      LET l_str="aapp600 "      #TQC-D70023 add
   END IF 
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

#關帳
FUNCTION q900_closing()
   DEFINE l_bdate LIKE type_file.dat
   DEFINE l_edate LIKE type_file.dat
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   CALL s_azn01(tm.yy,tm.mm) RETURNING l_bdate,l_edate
   IF tm.choice = '1' THEN   #No.FUN-D70072   Add
   IF tm.b = '1' THEN 
      LET l_str="axrp401 '' 'N'"
   END IF 
   IF tm.b = '2' THEN 
      LET l_str="aapp500 '' '' 'N'"
   END IF 
   IF tm.b = '3' THEN 
      LET l_str="anmp600 '' 'N'"
   END IF
   IF tm.b = '4' THEN 
      LET l_str="afap010 '",l_bdate,"' '",l_edate,"' 'N' ''"
   END IF
   IF tm.b = '5' THEN 
      LET l_str="aglp301 '",g_aza.aza81,"' '' '' 'N'"
   END IF
    #No.FUN-D70072 ---Add--- Start
   ELSE
      IF tm.b = '2' THEN
         LET l_str="anmp600 '' 'N'"
      END IF
      IF tm.b = '3' THEN
         LET l_str="afap010 '",l_bdate,"' '",l_edate,"' 'N' ''"
      END IF
   END IF
   #No.FUN-D70072 ---Add--- End
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

#银行存款对账关账
FUNCTION q900_check_closing()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   LET l_str="anmp340 '' '' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

#反月結
FUNCTION q900_monthly_statement_return()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   IF tm.choice = '1' THEN   #No.FUN-D70072   Add
   IF tm.b = '4' THEN 
      LET l_str="afap307 '' '' 'N'"
   END IF 
   IF tm.b = '5' THEN 
      LET l_str="gglp200 '",g_aza.aza81,"' '' '' 'N'"
   END IF 
   #No.FUN-D70072 ---Add--- Start
   ELSE
      IF tm.b = '3' THEN
          LET l_str="afap307 '' '' 'N'"
      END IF
   END IF
  #No.FUN-D70072 ---Add--- End
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

#月结异常单据
FUNCTION q900_anomalies()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   IF tm.choice = '1' THEN   #No.FUN-D70072   Add
   LET l_str="gglq901 '",tm.yy,"' '",tm.mm,"' '",tm.b,"' '1=1'"
   #No.FUN-D70072 ---add--- Start
   ELSE
      IF tm.b = '1' THEN
      LET l_str="gglq901 '",tm.yy,"' '",tm.mm,"' '1' '1=1'"
      END IF
      IF tm.b = '2' THEN
      LET l_str="gglq901 '",tm.yy,"' '",tm.mm,"' '3' '1=1'"
      END IF
      IF tm.b = '3' THEN
      LET l_str="gglq901 '",tm.yy,"' '",tm.mm,"' '4' '1=1'"
      END IF
   END IF
  #No.FUN-D70072 ---add--- End
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 
#FUN-D40121
