# Prog. Version..: '5.30.10-13.11.15(00001)'     #
#
# Pattern name...: axci403.4gl
# Descriptions...: 在製開帳金額維護作業
# Date & Author..: 13/07/31 By zhuhao
# Modify.........: No.FUN-D70055 13/07/31 By zhuhao

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   g_ccf           DYNAMIC ARRAY OF RECORD
        ccf01      LIKE ccf_file.ccf01,
        sfb05      LIKE sfb_file.sfb05,
        ima02      LIKE ima_file.ima02,
        ima021     LIKE ima_file.ima021,
        ccf02      LIKE ccf_file.ccf02,
        ccf03      LIKE ccf_file.ccf03,
        ccf06      LIKE ccf_file.ccf06,
        ccf07      LIKE ccf_file.ccf07,
        ccf04      LIKE ccf_file.ccf04,
        ima02_1    LIKE ima_file.ima02,
        ima021_1   LIKE ima_file.ima021,
        ccf05      LIKE ccf_file.ccf05,
        ccf11      LIKE ccf_file.ccf11,
        ccf12a     LIKE ccf_file.ccf12a,
        ccf12b     LIKE ccf_file.ccf12b,
        ccf12c     LIKE ccf_file.ccf12c,
        ccf12d     LIKE ccf_file.ccf12d,
        ccf12e     LIKE ccf_file.ccf12e,
        ccf12f     LIKE ccf_file.ccf12f,
        ccf12g     LIKE ccf_file.ccf12g,
        ccf12h     LIKE ccf_file.ccf12g,
        ccf12      LIKE ccf_file.ccf12,
        ccfud01    LIKE ccf_file.ccfud01,
        ccfud02    LIKE ccf_file.ccfud02,
        ccfud03    LIKE ccf_file.ccfud03,
        ccfud04    LIKE ccf_file.ccfud04,
        ccfud05    LIKE ccf_file.ccfud05,
        ccfud06    LIKE ccf_file.ccfud06,
        ccfud07    LIKE ccf_file.ccfud07,
        ccfud08    LIKE ccf_file.ccfud08,
        ccfud09    LIKE ccf_file.ccfud09,
        ccfud10    LIKE ccf_file.ccfud10,
        ccfud11    LIKE ccf_file.ccfud11,
        ccfud12    LIKE ccf_file.ccfud12,
        ccfud13    LIKE ccf_file.ccfud13,
        ccfud14    LIKE ccf_file.ccfud14,
        ccfud15    LIKE ccf_file.ccfud15
                   END RECORD,
   g_ccf_t         RECORD 
        ccf01      LIKE ccf_file.ccf01,
        sfb05      LIKE sfb_file.sfb05,
        ima02      LIKE ima_file.ima02,
        ima021     LIKE ima_file.ima021,
        ccf02      LIKE ccf_file.ccf02,
        ccf03      LIKE ccf_file.ccf03,
        ccf06      LIKE ccf_file.ccf06,
        ccf07      LIKE ccf_file.ccf07,
        ccf04      LIKE ccf_file.ccf04,
        ima02_1    LIKE ima_file.ima02,
        ima021_1   LIKE ima_file.ima021,
        ccf05      LIKE ccf_file.ccf05,
        ccf11      LIKE ccf_file.ccf11,
        ccf12a     LIKE ccf_file.ccf12a,
        ccf12b     LIKE ccf_file.ccf12b,
        ccf12c     LIKE ccf_file.ccf12c,
        ccf12d     LIKE ccf_file.ccf12d,
        ccf12e     LIKE ccf_file.ccf12e,
        ccf12f     LIKE ccf_file.ccf12f,
        ccf12g     LIKE ccf_file.ccf12g,
        ccf12h     LIKE ccf_file.ccf12g,
        ccf12      LIKE ccf_file.ccf12,
        ccfud01    LIKE ccf_file.ccfud01,
        ccfud02    LIKE ccf_file.ccfud02,
        ccfud03    LIKE ccf_file.ccfud03,
        ccfud04    LIKE ccf_file.ccfud04,
        ccfud05    LIKE ccf_file.ccfud05,
        ccfud06    LIKE ccf_file.ccfud06,
        ccfud07    LIKE ccf_file.ccfud07,
        ccfud08    LIKE ccf_file.ccfud08,
        ccfud09    LIKE ccf_file.ccfud09,
        ccfud10    LIKE ccf_file.ccfud10,
        ccfud11    LIKE ccf_file.ccfud11,
        ccfud12    LIKE ccf_file.ccfud12,
        ccfud13    LIKE ccf_file.ccfud13,
        ccfud14    LIKE ccf_file.ccfud14,
        ccfud15    LIKE ccf_file.ccfud15
                   END RECORD,
   g_wc,g_sql      STRING,    
   g_ima           RECORD LIKE ima_file.*,
   g_rec_b         LIKE type_file.num5,                #單身筆數     
   l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT       
DEFINE p_row,p_col     LIKE type_file.num5         
DEFINE g_forupd_sql    STRING     #SELECT ... FOR UPDATE SQL    
DEFINE   g_cnt           LIKE type_file.num10           
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        
DEFINE   g_before_input_done    LIKE type_file.num5        
DEFINE gs_location  STRING
DEFINE g_location   STRING
DEFINE l_idx        LIKE type_file.num5
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_ccf00      LIKE ccf_file.ccf00
DEFINE g_chr        LIKE type_file.chr1
 
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("axc")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time                    
 
   OPEN WINDOW i403_w WITH FORM "axc/42f/axci403"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("ccfud01,ccfud02,ccfud03,ccfud04,ccfud05,
                             ccfud06,ccfud07,ccfud08,ccfud09,ccfud10,
                             ccfud11,ccfud12,ccfud13,ccfud14,ccfud15",FALSE)
   
   LET g_ccf00 = '1'
   CALL i403_b_fill(' 1=1')
   CALL i403_menu()
   CLOSE WINDOW i403_w 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i403_menu()
   DEFINE l_cmd  LIKE type_file.chr1000           

   WHILE TRUE
      CALL i403_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               LET g_chr = 'Y'
               CALL i403_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i403_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               LET g_chr = 'N' 
               CALL i403_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ccf),'','')
            END IF
         WHEN "cost_articulation"       #與庫存成本開賬勾稽
            IF cl_chk_act_auth() THEN
               CALL i403_cost()
            END IF
         WHEN "dbload"                  #資料匯入
            IF cl_chk_act_auth() THEN
               CALL i403_dbload()
               CALL i403_b_fill(' 1=1 ')
            END IF
         WHEN "excelexample"        #匯出Excel範本
            IF cl_chk_act_auth() THEN
               CALL i403_excelexample(ui.Interface.getRootNode(),base.TypeInfo.create(g_ccf),'Y')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i403_a()
   DEFINE l_n         LIKE type_file.num5

  #LET g_rec_b = 0
  #LET l_n  = ARR_COUNT()
  #LET l_ac = l_n+1
  #LET g_rec_b = l_n +1
   DISPLAY g_rec_b TO FORMONLY.cnt
  #CLEAR FORM
  #CALL g_ccf.clear()
   CALL i403_b()
END FUNCTION
 
FUNCTION i403_q()
   CALL i403_b_askkey()
END FUNCTION
 
FUNCTION i403_b()
   DEFINE
      l_n             LIKE type_file.num5,                #檢查重複用       
      l_lock_sw       LIKE type_file.chr1,                #單身鎖住否      
      p_cmd           LIKE type_file.chr1,                #處理狀態      
      l_allow_insert  LIKE type_file.num5,                #可新增否       
      l_allow_delete  LIKE type_file.num5,                #可刪除否       
      l_cnt           LIKE type_file.num10,                  
      l_n1            LIKE type_file.num5,                  
      l_n2            LIKE type_file.num5                 
   DEFINE l_sql       STRING                               
   DEFINE i           LIKE type_file.num5                 
   DEFINE l_lph24     LIKE lph_file.lph24                 #審核碼
   DEFINE l_pmc05     LIKE pmc_file.pmc05   
   DEFINE l_chr       LIKE type_file.chr1,
          l_bdate     LIKE sma_file.sma53,
          l_edate     LIKE sma_file.sma53
   DEFINE l_year      LIKE type_file.num5
   DEFINE l_ac_t      LIKE type_file.num5
   DEFINE l_ccf03  LIKE ccf_file.ccf03  #20131209 add by suncx
   DEFINE l_ccf02  LIKE ccf_file.ccf02  #20131209 add by suncx

   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql =  
                      " SELECT ccf01,sfb05, ",
                      "        (SELECT ima02 FROM ima_file WHERE ima01 = sfb05) ima02, ",
                      "        (SELECT ima02 FROM ima_file WHERE ima01 = sfb05) ima021, ",
                      "        ccf02,ccf03,ccf06,ccf07,ccf04, ",
                      "        (SELECT ima02 FROM ima_file WHERE ima01 = ccf04) ima02_1, ",
                      "        (SELECT ima02 FROM ima_file WHERE ima01 = ccf04) ima021, ",
                      "        ccf05,ccf11,ccf12a,ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12h,ccf12, ",
                      "        ccfud01,ccfud02,ccfud03,ccfud04,ccfud05,ccfud06,ccfud07,ccfud08,ccfud09, ",
                      "        ccfud10,ccfud11,ccfud12,ccfud13,ccfud14,ccfud15 ",
                      "   FROM ccf_file left join sfb_file on ccf01 = sfb01 ",
                      "  WHERE ccf01=? AND ccf02=? ",
                      "    AND ccf03=? AND ccf04 =? AND ccf06=? AND ccf07=? FOR UPDATE"  
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i403_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_ccf WITHOUT DEFAULTS FROM s_ccf.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
           
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            IF g_chr = 'Y' THEN 
               LET l_n = ARR_COUNT()
               LET l_ac = l_n + 1
            END IF
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            #131129 add by suncx str------------
            IF g_ccf[l_ac].ccf03 >= 12 THEN
               LET l_ccf02 = g_ccf[l_ac].ccf02 + 1
               LET l_ccf03 = 1
            ELSE
               LET l_ccf02 = g_ccf[l_ac].ccf02
               LET l_ccf03 = g_ccf[l_ac].ccf03 + 1
            END IF
            #131129 add by suncx end------------
           #CALL s_azm(g_ccf[l_ac].ccf02,g_ccf[l_ac].ccf03) RETURNING l_chr,l_bdate,l_edate  
            CALL s_azm(l_ccf02,l_ccf03) RETURNING l_chr,l_bdate,l_edate   #131129 add by suncx
            IF l_edate <= g_sma.sma53 THEN          
               CALL cl_err('','alm1561',0)
               EXIT INPUT
            END IF
            #20131209 add by suncx sta-------
            IF NOT i403_chk(g_ccf[l_ac].ccf02,g_ccf[l_ac].ccf03) THEN
               CALL cl_err('','axc-809',1)
               EXIT INPUT
            END IF
            #20131209 add by suncx end-------

            LET p_cmd='u'
            LET g_ccf_t.* = g_ccf[l_ac].*  #BACKUP
 
            BEGIN WORK
 
            OPEN i403_bcl USING g_ccf_t.ccf01,g_ccf_t.ccf02,g_ccf_t.ccf03,
                                g_ccf_t.ccf04,g_ccf_t.ccf06,g_ccf_t.ccf07
            IF STATUS THEN
               CALL cl_err("OPEN i403_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i403_bcl INTO g_ccf[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ccf_t.ccf01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF                                      
            END IF
            CALL cl_show_fld_cont()     
         END IF
         LET g_before_input_done = FALSE
         CALL i403_set_entry(p_cmd)
         CALL i403_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         IF g_ccf00 = '1' THEN 
            CALL cl_set_docno_format("ccf01")
         END IF 

         LET g_ccf[l_ac].ccf05='P'
         IF g_ccz.ccz28 = '6' THEN
            CALL cl_err('','axc-090',1)
            LET g_ccf[l_ac].ccf06 = ''
         ELSE
            LET g_ccf[l_ac].ccf06=g_ccz.ccz28
         END IF
         LET g_ccf[l_ac].ccf11=0
         LET g_ccf[l_ac].ccf12=0
         LET g_ccf[l_ac].ccf12a=0
         LET g_ccf[l_ac].ccf12b=0
         LET g_ccf[l_ac].ccf12c=0
         LET g_ccf[l_ac].ccf12d=0
         LET g_ccf[l_ac].ccf12e=0
         LET g_ccf[l_ac].ccf12f=0
         LET g_ccf[l_ac].ccf12g=0
         LET g_ccf[l_ac].ccf12h=0
         DISPLAY BY NAME g_ccf[l_ac].ccf11
         DISPLAY BY NAME g_ccf[l_ac].ccf12
         DISPLAY BY NAME g_ccf[l_ac].ccf12a
         DISPLAY BY NAME g_ccf[l_ac].ccf12b
         DISPLAY BY NAME g_ccf[l_ac].ccf12c
         DISPLAY BY NAME g_ccf[l_ac].ccf12d
         DISPLAY BY NAME g_ccf[l_ac].ccf12e
         DISPLAY BY NAME g_ccf[l_ac].ccf12f
         DISPLAY BY NAME g_ccf[l_ac].ccf12g
         DISPLAY BY NAME g_ccf[l_ac].ccf12h
         LET g_before_input_done = FALSE
         CALL i403_set_entry(p_cmd)
         CALL i403_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         LET g_ccf_t.* = g_ccf[l_ac].*
         CALL cl_show_fld_cont()
         NEXT FIELD ccf01

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         #20131209 add by suncx sta-------
         IF NOT i403_chk(g_ccf[l_ac].ccf02,g_ccf[l_ac].ccf03) THEN
            CALL cl_err('','axc-809',1)
            NEXT FIELD ccf02
         END IF
         #20131209 add by suncx end-------
         IF cl_null(g_ccf[l_ac].ccf07) THEN LET g_ccf[l_ac].ccf07 = ' ' END IF
         INSERT INTO ccf_file(ccf00,ccf01,ccf02,ccf03,ccf04,ccf05,ccf06,ccf07,
                              ccf11,ccf12a,ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12h,ccf12,
                              ccfud01,ccfud02,ccfud03,ccfud04,ccfud05,ccfud06,ccfud07,ccfud08,
                              ccfud09,ccfud10,ccfud11,ccfud12,ccfud13,ccfud14,ccfud15,
                              ccfacti,ccfuser,ccfgrup,ccfmodu,ccfdate,ccflegal,ccforiu,ccforig)
            VALUES('1',g_ccf[l_ac].ccf01,g_ccf[l_ac].ccf02,g_ccf[l_ac].ccf03,g_ccf[l_ac].ccf04,
                   g_ccf[l_ac].ccf05,g_ccf[l_ac].ccf06,g_ccf[l_ac].ccf07,g_ccf[l_ac].ccf11,
                   g_ccf[l_ac].ccf12a,g_ccf[l_ac].ccf12b,g_ccf[l_ac].ccf12c,g_ccf[l_ac].ccf12d,
                   g_ccf[l_ac].ccf12e,g_ccf[l_ac].ccf12f,g_ccf[l_ac].ccf12g,g_ccf[l_ac].ccf12h,g_ccf[l_ac].ccf12,
                   g_ccf[l_ac].ccfud01,g_ccf[l_ac].ccfud02,g_ccf[l_ac].ccfud03,g_ccf[l_ac].ccfud04,g_ccf[l_ac].ccfud05,
                   g_ccf[l_ac].ccfud06,g_ccf[l_ac].ccfud07,g_ccf[l_ac].ccfud08,g_ccf[l_ac].ccfud09,g_ccf[l_ac].ccfud10,
                   g_ccf[l_ac].ccfud11,g_ccf[l_ac].ccfud12,g_ccf[l_ac].ccfud13,g_ccf[l_ac].ccfud14,g_ccf[l_ac].ccfud15,
                   'Y',g_user,g_grup,'',g_today,g_legal,g_user,g_grup)
 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","ccf_file",g_ccf[l_ac].ccf01,"",SQLCA.sqlcode,"","",1) 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2      
         END IF
 
      AFTER FIELD ccf01
         IF NOT cl_null(g_ccf[l_ac].ccf01) THEN
            SELECT sfb05 INTO g_ccf[l_ac].sfb05 FROM sfb_file WHERE sfb01=g_ccf[l_ac].ccf01
            IF STATUS THEN
               CALL cl_err3("sel","sfb_file",g_ccf[l_ac].ccf01,"",STATUS,"","sel sfb",1)
               NEXT FIELD ccf01
            END IF
            DISPLAY BY NAME g_ccf[l_ac].sfb05
            IF NOT cl_null(g_ccf[l_ac].sfb05) THEN
               SELECT ima02,ima021 INTO g_ccf[l_ac].ima02,g_ccf[l_ac].ima021
                 FROM ima_file WHERE ima01 = g_ccf[l_ac].sfb05
            END IF
         END IF

      AFTER FIELD ccf02
         IF NOT cl_null(g_ccf[l_ac].ccf02) THEN
            LET l_year = YEAR(g_today)
            IF g_ccf[l_ac].ccf02 > YEAR(g_today) THEN
               CALL cl_err('','afa-370',0)
               NEXT FIELD ccf02
            END IF
            IF LENGTH(g_ccf[l_ac].ccf02) <> '4' THEN
               CALL cl_err('','ask-003',0)
               NEXT FIELD ccf02
            END IF
         END IF

      AFTER FIELD ccf03
         IF g_ccf[l_ac].ccf03 < 1 OR g_ccf[l_ac].ccf03 > 12 THEN
            CALL cl_err('','afa-371',0)
            NEXT FIELD ccf03
         ELSE
            IF NOT cl_null(g_ccf[l_ac].ccf02) AND NOT cl_null(g_ccf[l_ac].ccf03) THEN
               SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
               #131129 add by suncx str------------
               IF g_ccf[l_ac].ccf03 >= 12 THEN
                  LET l_ccf02 = g_ccf[l_ac].ccf02 + 1
                  LET l_ccf03 = 1
               ELSE
                  LET l_ccf02 = g_ccf[l_ac].ccf02
                  LET l_ccf03 = g_ccf[l_ac].ccf03 + 1
               END IF
               #131129 add by suncx end------------
              #CALL s_azm(g_ccf[l_ac].ccf02,g_ccf[l_ac].ccf03) RETURNING l_chr,l_bdate,l_edate
               CALL s_azm(l_ccf02,l_ccf03) RETURNING l_chr,l_bdate,l_edate   #131129 add by suncx
               IF l_edate <= g_sma.sma53 THEN
                  CALL cl_err('','alm1561',1)
                  NEXT FIELD ccf03
               END IF
            END IF
         END IF

      BEFORE FIELD ccf04
         CALL i403_set_entry(p_cmd)

      AFTER FIELD ccf04
         IF NOT cl_null(g_ccf[l_ac].ccf04) AND g_ccf[l_ac].ccf04 != ' DL+OH+SUB' THEN
            IF NOT s_chk_item_no(g_ccf[l_ac].ccf04,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD ccf04
            END IF
         END IF
         IF g_ccf[l_ac].ccf04 IS NULL OR cl_null(g_ccf[l_ac].ccf04) THEN
            LET g_ccf[l_ac].ccf04 = ' '
            LET g_ccf[l_ac].ccf05 = 'M'
            DISPLAY BY NAME g_ccf[l_ac].ccf05
            CALL i403_set_no_entry(p_cmd)
         END IF
         IF NOT cl_null(g_ccf[l_ac].ccf04) AND g_ccf[l_ac].ccf04 != ' DL+OH+SUB' THEN
            SELECT ima02,ima021 INTO g_ccf[l_ac].ima02_1,g_ccf[l_ac].ima021_1
              FROM ima_file WHERE ima01=g_ccf[l_ac].ccf04
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",g_ccf[l_ac].ccf04,"",STATUS,"","sel ima:",1)
               NEXT FIELD ccf04
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND
               (g_ccf[l_ac].ccf01 != g_ccf_t.ccf01 OR g_ccf[l_ac].ccf02 != g_ccf_t.ccf02 OR
                g_ccf[l_ac].ccf03 != g_ccf_t.ccf03 OR g_ccf[l_ac].ccf04 != g_ccf_t.ccf04 OR
                g_ccf[l_ac].ccf06 != g_ccf_t.ccf06 OR g_ccf[l_ac].ccf07 != g_ccf_t.ccf07)) THEN
                SELECT count(*) INTO l_n FROM ccf_file
                    WHERE ccf01 = g_ccf[l_ac].ccf01 AND ccf02 = g_ccf[l_ac].ccf02
                      AND ccf03 = g_ccf[l_ac].ccf03 AND ccf04 = g_ccf[l_ac].ccf04
                      AND ccf06 = g_ccf[l_ac].ccf06 AND ccf07 = g_ccf[l_ac].ccf07 
                IF l_n > 0 THEN 
                    CALL cl_err('count:',-239,0)
                    NEXT FIELD ccf01
                END IF
            END IF
         END IF
         IF g_ccf[l_ac].ccf04 = ' DL+OH+SUB' THEN
            LET g_ccf[l_ac].ccf05 = 'P'
            DISPLAY BY NAME g_ccf[l_ac].ccf05
         END IF

      BEFORE FIELD ccf05
         IF cl_null(g_ccf[l_ac].ccf04) OR g_ccf[l_ac].ccf04 = ' DL+OH+SUB' THEN
         END IF
      AFTER FIELD ccf06
         IF NOT cl_null(g_ccf[l_ac].ccf06) THEN
            IF g_ccf[l_ac].ccf06 NOT MATCHES '[12345]' THEN
               NEXT FIELD ccf06
            END IF
            IF g_ccf[l_ac].ccf06 MATCHES'[12]' THEN
               CALL cl_set_comp_entry("ccf07",FALSE)
               LET g_ccf[l_ac].ccf07 = NULL
            ELSE
               CALL cl_set_comp_entry("ccf07",TRUE)
            END IF
         END IF
      AFTER FIELD ccf07
         IF NOT cl_null(g_ccf[l_ac].ccf07) THEN
            CASE g_ccf[l_ac].ccf06
              WHEN 4
               SELECT pja02 FROM pja_file WHERE pja01 = g_ccf[l_ac].ccf07
                                            AND pjaclose='N'
               IF SQLCA.sqlcode!=0 THEN
                  CALL cl_err3('sel','pja_file',g_ccf[l_ac].ccf07,'',SQLCA.sqlcode,'','',1)
                  NEXT FIELD ccf07
               END IF
              WHEN 5
                SELECT UNIQUE imd09 FROM imd_file WHERE imd09 = g_ccf[l_ac].ccf07
                IF SQLCA.sqlcode!=0 THEN
                  CALL cl_err3('sel','imd_file',g_ccf[l_ac].ccf07,'',SQLCA.sqlcode,'','',1)
                  NEXT FIELD ccf07
               END IF
              OTHERWISE EXIT CASE
             END CASE
         ELSE
            LET g_ccf[l_ac].ccf07 = NULL
         END IF
      AFTER FIELD ccf11,ccf12a,ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12h
         CALL i403_u_cost()

      BEFORE FIELD ccf12a
         IF cl_null(g_ccf[l_ac].ccf04) THEN
            LET g_ccf[l_ac].ccf12 = 0
            LET g_ccf[l_ac].ccf12a= 0
            LET g_ccf[l_ac].ccf12b= 0
            LET g_ccf[l_ac].ccf12c= 0
            LET g_ccf[l_ac].ccf12d= 0
            LET g_ccf[l_ac].ccf12e= 0
            LET g_ccf[l_ac].ccf12f= 0
            LET g_ccf[l_ac].ccf12g= 0
            LET g_ccf[l_ac].ccf12h= 0
            DISPLAY BY NAME g_ccf[l_ac].ccf12, g_ccf[l_ac].ccf12a, g_ccf[l_ac].ccf12b,
                            g_ccf[l_ac].ccf12c, g_ccf[l_ac].ccf12d, g_ccf[l_ac].ccf12e,
                            g_ccf[l_ac].ccf12f, g_ccf[l_ac].ccf12g, g_ccf[l_ac].ccf12h 
            EXIT INPUT
         END IF

      AFTER FIELD ccfud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      AFTER FIELD ccfud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_ccf_t.ccf01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
    
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM ccf_file WHERE ccf01 = g_ccf_t.ccf01 AND ccf02 = g_ccf_t.ccf02 AND ccf03 = g_ccf_t.ccf03
                                   AND ccf04 = g_ccf_t.ccf04 AND ccf06 = g_ccf_t.ccf06 AND ccf07 = g_ccf_t.ccf07
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","ccf_file",g_ccf_t.ccf01,"",SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
               CANCEL DELETE 
            END IF
 
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK"
            CLOSE i403_bcl
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ccf[l_ac].* = g_ccf_t.*
            CLOSE i403_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF

         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ccf[l_ac].ccf01,-263,1)
            LET g_ccf[l_ac].* = g_ccf_t.*
         ELSE
            UPDATE ccf_file SET ccf05 = g_ccf[l_ac].ccf05,ccf11 = g_ccf[l_ac].ccf11,
                                ccf12a = g_ccf[l_ac].ccf12a,ccf12b = g_ccf[l_ac].ccf12b,
                                ccf12c = g_ccf[l_ac].ccf12c,ccf12d = g_ccf[l_ac].ccf12d,
                                ccf12e = g_ccf[l_ac].ccf12e,ccf12f = g_ccf[l_ac].ccf12f,
                                ccf12g = g_ccf[l_ac].ccf12g,ccf12h = g_ccf[l_ac].ccf12h,
                                ccf12 = g_ccf[l_ac].ccf12,ccfmodu= g_user,ccfdate = g_today
             WHERE ccf01 = g_ccf_t.ccf01 AND ccf02 = g_ccf_t.ccf02
               AND ccf03 = g_ccf_t.ccf03 AND ccf04 = g_ccf_t.ccf04
               AND ccf06 = g_ccf_t.ccf06 AND ccf07 = g_ccf_t.ccf07
 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","ccf_file",g_ccf_t.ccf01,"",SQLCA.sqlcode,"","",1) 
               LET g_ccf[l_ac].* = g_ccf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               CLOSE i403_bcl
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()

         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ccf[l_ac].* = g_ccf_t.*
            ELSE
               CALL g_ccf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            CLOSE i403_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac
         IF l_ac = 0 THEN LET l_ac = 0 END IF
         CLOSE i403_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ccf01)   #主件料號
               IF g_ccf00 = "2" THEN
                  CALL q_sel_ima(FALSE, "q_ima","",g_ccf[l_ac].ccf01,"","","","","",'' )
                  RETURNING  g_ccf[l_ac].ccf01
                  DISPLAY BY NAME g_ccf[l_ac].ccf01
                  NEXT FIELD ccf01
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_sfb3"
                  LET g_qryparam.default1 = g_ccf[l_ac].ccf01
                  CALL cl_create_qry() RETURNING g_ccf[l_ac].ccf01
                  DISPLAY BY NAME g_ccf[l_ac].ccf01
                  NEXT FIELD ccf01
               END IF
            WHEN INFIELD(ccf04)   #元件料號
                CALL q_sel_ima(FALSE, "q_ima","",g_ccf[l_ac].ccf04,"","","","","",'' )
                   RETURNING  g_ccf[l_ac].ccf04
                DISPLAY BY NAME g_ccf[l_ac].ccf04
                NEXT FIELD ccf04
            WHEN INFIELD(ccf07)
              IF g_ccf[l_ac].ccf06 MATCHES '[45]' THEN
               CALL cl_init_qry_var()
               CASE g_ccf[l_ac].ccf06
                  WHEN '4'
                    LET g_qryparam.form = "q_pja"
                  WHEN '5'
                    LET g_qryparam.form = "q_gem4"
                  OTHERWISE EXIT CASE
               END CASE
               LET g_qryparam.default1 = g_ccf[l_ac].ccf07
               CALL cl_create_qry() RETURNING g_ccf[l_ac].ccf07
               DISPLAY BY NAME g_ccf[l_ac].ccf07
              END IF
         END CASE

      ON KEY(F1)
          IF INFIELD(ccf04) THEN
             CALL i403_ccf04() DISPLAY BY NAME g_ccf[l_ac].ccf04 NEXT FIELD ccf04
          END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION CONTROLF  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about     
         CALL cl_about()      

      ON ACTION help          
         CALL cl_show_help()  
      
   END INPUT

   CLOSE i403_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i403_b_askkey()
   DEFINE l_ccf06 LIKE ccf_file.ccf06
   CLEAR FORM
   CALL g_ccf.clear()
   CONSTRUCT g_wc ON 
             ccf01,ccf02,ccf03,ccf06,ccf07,ccf04,ccf05,ccf11,ccf12a,
             ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12h,ccf12
        FROM s_ccf[1].ccf01,s_ccf[1].ccf02,s_ccf[1].ccf03,s_ccf[1].ccf06,s_ccf[1].ccf07,
             s_ccf[1].ccf04,s_ccf[1].ccf05,s_ccf[1].ccf11,s_ccf[1].ccf12a,s_ccf[1].ccf12b,
             s_ccf[1].ccf12c,s_ccf[1].ccf12d,s_ccf[1].ccf12e,s_ccf[1].ccf12f,s_ccf[1].ccf12g,
             s_ccf[1].ccf12h,s_ccf[1].ccf12
 
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        AFTER FIELD ccf06                       
           LET l_ccf06 = get_fldbuf(ccf06)
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ccf01)   #主件料號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfb3"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ccf01
                 NEXT FIELD ccf01
              WHEN INFIELD(ccf04)   #元件料號
                 CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ccf04
                 NEXT FIELD ccf04 
              WHEN INFIELD(ccf07)                                               
                 IF l_ccf06 MATCHES '[45]' THEN                                 
                    CALL cl_init_qry_var()                                      
                    LET g_qryparam.state= "c"                                   
                    CASE l_ccf06                                                   
                       WHEN '4'                                                    
                          LET g_qryparam.form = "q_pja"                             
                       WHEN '5'                                                    
                          LET g_qryparam.form = "q_gem4"                            
                       OTHERWISE EXIT CASE                                         
                    END CASE                                                       
                    CALL cl_create_qry() RETURNING g_qryparam.multiret             
                    DISPLAY g_qryparam.multiret TO ccf07                           
                    NEXT FIELD ccf07                                               
#FUN-D70055 ---------- add ----------- begin -------------
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ccf07"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ccf07
                    NEXT FIELD ccf07
#FUN-D70055 ---------- add ----------- end ---------------
                 END IF                                                         
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg      
           CALL cl_cmdask()     
 
        ON ACTION qbe_select
          CALL cl_qbe_select() 
        ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED
 
    CALL i403_b_fill(g_wc)
   
END FUNCTION
 
FUNCTION i403_b_fill(p_wc)             
   DEFINE p_wc       STRING
 
   IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF
   LET g_sql =
       " SELECT ccf01,sfb05, ",
       "        (SELECT ima02 FROM ima_file WHERE ima01 = sfb05) ima02, ",
       "        (SELECT ima02 FROM ima_file WHERE ima01 = sfb05) ima021, ",
       "        ccf02,ccf03,ccf06,ccf07,ccf04, ",
       "        (SELECT ima02 FROM ima_file WHERE ima01 = ccf04) ima02_1, ",
       "        (SELECT ima02 FROM ima_file WHERE ima01 = ccf04) ima021, ",
       "        ccf05,ccf11,ccf12a,ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12h,ccf12, ",
       "        ccfud01,ccfud02,ccfud03,ccfud04,ccfud05,ccfud06,ccfud07,ccfud08,ccfud09, ",
       "        ccfud10,ccfud11,ccfud12,ccfud13,ccfud14,ccfud15 ",
       "   FROM ccf_file left join sfb_file on ccf01 = sfb01 ",
       "  WHERE ccf00 ='1' AND ", p_wc CLIPPED, 
       "  ORDER BY ccf02 DESC,ccf03 DESC,ccf01"

   PREPARE i403_pb FROM g_sql
   DECLARE ccf_curs CURSOR FOR i403_pb
 
   CALL g_ccf.clear()
   LET g_cnt = 1

   FOREACH ccf_curs INTO g_ccf[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_ccf.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION i403_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1        
   DEFINE   l_location  STRING
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ccf TO s_ccf.* ATTRIBUTE(COUNT=g_rec_b)

      BEFORE DISPLAY 
         CALL DIALOG.setSelectionMode( "s_ccf", 1 )        #支持單身多選
         CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
         DISPLAY l_ac TO FORMONLY.cn2
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY    

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about       
         CALL cl_about()     
   
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION cost_articulation       #與庫存成本開賬勾稽
         LET g_action_choice ="cost_articulation"
         EXIT DISPLAY

      ON ACTION dbload                  #資料匯入
         LET g_action_choice="dbload"
         EXIT DISPLAY

      ON ACTION excelexample
         LET g_action_choice="excelexample"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i403_ccf04()
   IF g_ccf[l_ac].sfb05 MATCHES '5*99' THEN   # SMT-5*99 取下階料為'P*'者
     SELECT MAX(sfa03) INTO g_ccf[l_ac].ccf04 FROM sfa_file
      WHERE sfa01=g_ccf[l_ac].ccf01 AND sfa03 MATCHES 'P*'
   END IF
   IF g_ccf[l_ac].sfb05 MATCHES '5*00' THEN   # Touch-Up 取下階料為'*99'者
     SELECT MAX(sfa03) INTO g_ccf[l_ac].ccf04 FROM sfa_file
      WHERE sfa01=g_ccf[l_ac].ccf01 AND sfa03 MATCHES '*99'
   END IF
   IF g_ccf[l_ac].sfb05 MATCHES '2*00' THEN   # Packing 取下階料為'5*'者
     SELECT MAX(sfa03) INTO g_ccf[l_ac].ccf04 FROM sfa_file
      WHERE sfa01=g_ccf[l_ac].ccf01 AND sfa03 MATCHES '5*'
   END IF
   IF g_ccf[l_ac].sfb05 MATCHES '8*' THEN             # 磁片委外取下階料為'KZ*'者
     SELECT MAX(sfa03) INTO g_ccf[l_ac].ccf04 FROM sfa_file
      WHERE sfa01=g_ccf[l_ac].ccf01 AND sfa03 MATCHES 'KZ*'
   END IF
END FUNCTION

FUNCTION i403_u_cost()
   LET g_ccf[l_ac].ccf12=g_ccf[l_ac].ccf12a+g_ccf[l_ac].ccf12b+g_ccf[l_ac].ccf12c+
                   g_ccf[l_ac].ccf12d+g_ccf[l_ac].ccf12e+g_ccf[l_ac].ccf12f+
                   g_ccf[l_ac].ccf12g+g_ccf[l_ac].ccf12h 
   DISPLAY BY NAME g_ccf[l_ac].ccf12
END FUNCTION

FUNCTION i403_set_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1 

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ccf01,ccf02,ccf03,ccf04,ccf06,ccf07",TRUE)
   END IF
   CASE WHEN INFIELD(ccf04) OR ( NOT g_before_input_done )
               CALL cl_set_comp_entry("ccf05",TRUE)
   END CASE
END FUNCTION

FUNCTION i403_set_no_entry(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1     

   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND
      (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ccf01,ccf02,ccf03,ccf04,ccf06,ccf07",FALSE)
   END IF
   CASE WHEN INFIELD(ccf04) OR ( NOT g_before_input_done )
             IF cl_null(g_ccf[l_ac].ccf04) OR g_ccf[l_ac].ccf04=' DL+OH+SUB' THEN
                CALL cl_set_comp_entry("ccf05",FALSE)
             END IF
   END CASE
   IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
      (NOT g_before_input_done) THEN
      IF g_ccf[l_ac].ccf06 MATCHES'[12]' THEN
         CALL cl_set_comp_entry("ccf07",FALSE)
      ELSE
         CALL cl_set_comp_entry("ccf07",TRUE)
      END IF
   END IF
END FUNCTION

#如果当期同一成本计算类别有元件料号在ccf中，但不在cca表中，就把这些料号用报表汇出
FUNCTION i403_cost()
   DEFINE l_sql       STRING
   DEFINE l_sql1      STRING
   DEFINE l_num       LIKE type_file.num5
   DEFINE l_str       STRING
   DEFINE l_table     STRING

   LET l_sql = " ccf04.ccf_file.ccf04,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " ccf02.ccf_file.ccf02,",
               " ccf03.ccf_file.ccf03,",
               " ccf06.ccf_file.ccf06,",
               " ccf07.ccf_file.ccf07,",
               " ccf11.ccf_file.ccf11,",
               " ccf12a.ccf_file.ccf12a,",
               " ccf12b.ccf_file.ccf12b,",
               " ccf12c.ccf_file.ccf12c,",
               " ccf12d.ccf_file.ccf12d,",
               " ccf12e.ccf_file.ccf12e,",
               " ccf12f.ccf_file.ccf12f,",
               " ccf12g.ccf_file.ccf12g,",
               " ccf12h.ccf_file.ccf12h,",
               " ccf12.ccf_file.ccf12"

   LET l_table = cl_prt_temptable('axci403',l_sql) CLIPPED
   IF l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM 
   END IF


   CALL cl_del_data(l_table)  

   LET l_sql1 = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " SELECT DISTINCT ccf04,(SELECT ima02 FROM ima_file WHERE ima01 = ccf04) ima02,
                         (SELECT ima021 FROM ima_file WHERE ima01 = ccf04) ima021,
                         ccf02,ccf03,ccf06,ccf07,ccf11,
                         ccf12a,ccf12b,ccf12c,ccf12d,ccf12e,ccf12f,ccf12g,ccf12g,ccf12
                    FROM ccf_file
                   WHERE NOT EXISTS(SELECT 1 FROM cca_file
                                           WHERE cca01 = ccf04 AND cca02 = ccf02
                                             AND cca03 = ccf03 AND cca06 = ccf06
                                             AND ccaacti = ccfacti AND ccaacti = 'Y')
                     AND ccfacti = 'Y' AND ccf00 ='1' 
                   ORDER BY ccf04 "

   PREPARE insert_prep FROM l_sql1
   EXECUTE insert_prep
    
   LET l_sql1 = null
   LET l_num = 0
   LET l_sql1 = " SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   PREPARE insert_prep1 FROM l_sql1
   EXECUTE insert_prep1 INTO l_num
   
   IF l_num = 0 THEN
      CALL cl_err('','apm1031',1)
   ELSE
      LET l_str = ' 1=1'
      LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
      CALL cl_prt_cs3('axci403','axci403',l_sql,l_str)
      IF cl_confirm('axc-220') THEN
         MESSAGE "OK"
         LET l_sql = null
         LET l_sql = " INSERT INTO cca_file 
                       SELECT ccf04,ccf02,ccf03,'',ccf11,ccf12,ccf12a,ccf12b,ccf12c,ccf12d,ccf12e, 
                              '','','','','','', 'Y','",g_user,"','",g_grup,"','','",g_today,"',   
                              ccf06,ccf07,ccf12f,ccf12g,ccf12h,'','','',                           
                              '','','','','', '','','','','', '','','','','',                      
                              '",g_legal,"','",g_user,"','",g_grup,"'                              
                         FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
         PREPARE insert_prep2 FROM l_sql
         EXECUTE insert_prep2
      ELSE
         MESSAGE "NO"
      END IF
   END IF

END FUNCTION

#FUN-D70055 ----------- add -----------
#20131209 add by suncx begin--------------------------------
FUNCTION i403_chk(p_yy,p_mm)
DEFINE p_yy        LIKE type_file.num5,
       p_mm        LIKE type_file.num5
DEFINE l_bdate     LIKE type_file.dat,
       l_edate     LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_n         LIKE type_file.num5
DEFINE l_correct   LIKE type_file.chr1

      LET l_n = 0
      CALL s_azm(p_yy,p_mm) RETURNING l_correct, l_bdate, l_edate
      LET l_sql = " SELECT COUNT(*) FROM npp_file",
                  "  WHERE nppsys  = 'CA'",
                  "    AND npp011  = '1'",
                  "    AND npp00 >= 2 AND npp00 <= 7 ",
                  "    AND npp00 <> 6 ",
                  "    AND nppglno IS NOT NULL ",
                  "    AND YEAR(npp02) = ",p_yy,
                  "    AND MONTH(npp02) = ",p_mm,
                  "    AND npp03 BETWEEN '",l_bdate,"' AND '",l_edate ,"' "

      PREPARE npq_pre FROM l_sql
      DECLARE npq_cs CURSOR FOR npq_pre
      OPEN npq_cs
      FETCH npq_cs INTO l_n
      CLOSE npq_cs

      IF l_n > 0 THEN
         RETURN FALSE
      END IF
      RETURN TRUE
END FUNCTION
#20131209 add by suncx end----------------------------------
