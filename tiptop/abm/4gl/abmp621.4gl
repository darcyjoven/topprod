# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Pattern name...: abmp621.4gl
# Descriptions...: 正式BOM底稿批次產生作業   
# Date & Author..: 07/09/13 By arman
# Modify.........: No:FUN-830116 08/04/18 By Arman 
# Modify.........: No:MOD-840517 08/04/25 By Arman DS5
#                                                  程式顯示執行成功,但在 abmi720 中查詢有產生一張112-0804000002
#                                                  的全料號ECN 變更單,但沒有單身資料.
# Modify.........: No:FUN-850017 08/05/05 By Arman 產生意向SQL語句增加條件bma06=bmb29
# Modify.........: No:MOD-C10142 12/01/17 By lilingyu 將程式從17區移植到此，並修改部分產生ECN失敗的BUG
# Modify.........: No:MOD-DC0105 13/12/16 By fengmy 錄入時特性代碼可跳過

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   tm            RECORD
            a2         VARCHAR(16),
            a1         VARCHAR(40),
            a1_ima02   VARCHAR(60),
            a3         VARCHAR(20),
            a4         VARCHAR(16),
            a5         DATE
                       END RECORD,
         g_c  DYNAMIC ARRAY OF RECORD 
            c1         VARCHAR(01),
            c2         VARCHAR(40),
            c2_ima02   VARCHAR(60)
                   END RECORD,
         g_rec_b       LIKE type_file.num10, 
         l_n           LIKE type_file.num5, 
         l_ac          LIKE type_file.num5,
         l_flag        LIKE type_file.chr1,
         g_change_lang LIKE type_file.chr1,
         g_imz  RECORD LIKE imz_file.*      
DEFINE   g_cnt         LIKE type_file.num10  
DEFINE   g_before_input_done LIKE type_file.num5 
DEFINE   g_sma118      LIKE sma_file.sma118
DEFINE   g_t1          LIKE oay_file.oayslip
DEFINE   g_count1      LIKE type_file.num5         #No.FUN-830116
DEFINE   g_flag_2      LIKE type_file.chr1         #No.FUN-850017

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT	         		# Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF

  CALL cl_used(g_prog,g_time,1)  RETURNING g_time
#  CALL s_decl_bmb()
   WHILE TRUE
     BEGIN WORK
     LET g_success = 'N'
     LET g_change_lang = FALSE

     CALL g_c.clear()
     CALL p621_tm()			

     IF g_change_lang = TRUE THEN 
         CONTINUE WHILE
     END IF

     IF INT_FLAG THEN LET INT_FLAG = 0  EXIT WHILE END IF
          CALL p621_array_c()
     IF INT_FLAG THEN LET INT_FLAG = 0  EXIT WHILE END IF

     #-->正式資料拋轉
     IF cl_sure(0,0) THEN
        CALL cl_wait()
        CALL p621()
        IF g_success = 'Y' THEN
           COMMIT WORK
           IF g_flag_2 = 'Y' THEN   #NO.FUN-850017                                                                                  
            CALL cl_err_msg('','abm-311',tm.a4 CLIPPED,1)     #No.FUN-850017                                                        
           END IF                   #No.FUN-850017  
           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
        END IF
        IF l_flag THEN
           CLEAR FORM
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
     END IF
     CLEAR FORM
     ERROR ""
   END WHILE
   CLOSE WINDOW p621_w

  CALL cl_used(g_prog,g_time,2)  RETURNING g_time
END MAIN
   
FUNCTION p621_tm()
DEFINE   p_row,p_col	    LIKE type_file.num5,   #No.FUN-680096 SMALLINT
            l_cnt         LIKE type_file.num5,   #No.FUN-680096 SMALLINT
            l_sql         LIKE type_file.chr1000,
            l_i           LIKE type_file.num5,
            l_n           LIKE type_file.num5,
            l_n1          LIKE type_file.num5,
            l_n2          LIKE type_file.num5
DEFINE li_result LIKE type_file.num5
DEFINE l_ima02   LIKE ima_file.ima02
#  CLEAR FORM
   LET p_row = 3 LET p_col = 18

   OPEN WINDOW p621_w AT p_row,p_col WITH FORM "abm/42f/abmp621" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
    
   CALL cl_ui_init()
   SELECT sma118 INTO g_sma118 FROM sma_file 
   CALL cl_set_comp_visible("a3",g_sma118='Y')

   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL

   INPUT BY NAME tm.a2,tm.a1,tm.a1_ima02,tm.a3,tm.a4,tm.a5 WITHOUT DEFAULTS 

      BEFORE INPUT
      LET tm.a5 = g_today   #NO.FUN-850017
      AFTER FIELD a2
       IF NOT cl_null(tm.a2) THEN
          SELECT COUNT(*)  INTO l_n FROM bmx_file WHERE bmx01=tm.a2 AND bmx04='Y' AND bmxacti='Y'
          IF l_n <= 0 THEN                  
                   CALL cl_err('','mfg2723',0)
                   NEXT FIELD a2
          END IF          
       ELSE
                   NEXT FIELD a2
       END IF
      AFTER FIELD  a1
       IF NOT cl_null(tm.a1)  THEN
          SELECT COUNT(*)  INTO l_n1 FROM bmx_file,ima_file,bmy_file WHERE bmx01=tm.a2 AND bmx04='Y' AND bmx01=bmy01
          AND bmy14=ima01 AND bmy14=tm.a1 AND ima151='Y' AND imaacti='Y'
          IF l_n1 <= 0 THEN                  
                   CALL cl_err('','abm-090',0)
                   NEXT FIELD a1
          END IF
          SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01=tm.a1
          DISPLAY l_ima02 TO a1_ima02
       ELSE
                   NEXT FIELD a1
       END IF 
       
      AFTER FIELD a3
      IF NOT cl_null(tm.a3)  THEN
         SELECT COUNT(*) INTO l_n2 FROM bmy_file WHERE bmy14=tm.a1 AND bmy01=tm.a2 AND bmy29=tm.a3
          IF l_n2 <= 0 THEN                  
                   NEXT FIELD a3
          END IF          
      #ELSE                         #MOD-DC0105 mark
      #            NEXT FIELD a3    #MOD-DC0105 mark
       END IF
      AFTER FIELD a4                      #主件料號
#No.FUN-850017  --begin
#         CALL s_auto_assign_no("abm",tm.a4,g_today,"1","","a4","","","")
#         RETURNING li_result,tm.a4
#         IF (NOT li_result) THEN                                                                                                     
#            NEXT FIELD a4                                                                                                          
#         END IF                                                                                                                      
#         DISPLAY BY NAME tm.a4
#No.FUN-850017  --end
            IF NOT cl_null(tm.a4) THEN                                                                                        
              CALL s_check_no("abm",tm.a4,'',"1","","a4","")                                              
              RETURNING li_result,tm.a4                                                                                        
              DISPLAY BY NAME tm.a4
               IF(NOT li_result) THEN                                                                                                  
                  LET tm.a4=tm.a4                                                                                        
                  DISPLAY BY NAME tm.a4                                                                                         
               END IF
            END IF   
      ON ACTION CONTROLP     #查詢條件 
            CASE
               WHEN INFIELD(a1) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_ima01_b'
                  LET g_qryparam.default1 = tm.a1
                  LET g_qryparam.arg1 = tm.a2
                  CALL cl_create_qry() RETURNING tm.a1
                  DISPLAY BY NAME tm.a1 
                  NEXT FIELD a1
               WHEN INFIELD(a2) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_bmx01'
                  CALL cl_create_qry() RETURNING tm.a2
                  DISPLAY BY NAME tm.a2 
                  NEXT FIELD a2
               WHEN INFIELD(a3) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_bmy29'
                  LET g_qryparam.arg1 = tm.a1
                  LET g_qryparam.arg2 = tm.a2
                  CALL cl_create_qry() RETURNING tm.a3
                  DISPLAY BY NAME tm.a3 
                  NEXT FIELD a3
               WHEN INFIELD(a4)                                                                                           
                  LET g_t1=s_get_doc_no(tm.a4)                                                                              
                  CALL q_smy(FALSE,FALSE,g_t1,'ABM','1') RETURNING g_t1
                  LET tm.a4 = g_t1
                  DISPLAY BY NAME tm.a4                                                                            
                   NEXT FIELD a4
               OTHERWISE EXIT CASE
            END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
      ON ACTION controlg     
         CALL cl_cmdask()    
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                
          LET g_change_lang = TRUE
          EXIT INPUT
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
      AFTER INPUT
   END INPUT
       #No.FUN-830116 --begin
       IF tm.a3 IS NULL THEN
        LET l_sql = " SELECT  DISTINCT '',ima01,ima02 FROM ima_file WHERE ima01 IN(SELECT bma01 ",
                    " FROM bma_file,bmb_file,ima_file,imx_file WHERE bma01=bmb01 ",
                    " AND bma01=ima01 AND ima01=imx000 AND imx00='",tm.a1,"')  ",
                    " AND imaacti='Y'  "
                    # AND ima01=imx000 AND imx00='",tm.a1,"'"   #No.FUN-830116
       ELSE
        LET l_sql = " SELECT DISTINCT  '',ima01,ima02 FROM ima_file,bma_file WHERE ima01 IN(SELECT bma01 ",
                    " FROM bma_file,bmb_file,ima_file,imx_file WHERE bma01=bmb01 ",
                    " AND bma01=ima01 AND ima01=imx000 AND imx00='",tm.a1,"' AND  bma06 = '",tm.a3,"' AND bma06 = bmb29 )  ", #NO.FUN-850017
                    " AND imaacti='Y' " 
                    #AND ima01=imx000 AND imx00='",tm.a1,"'       #No.FUN-830116
       END IF 
       PREPARE p621_c FROM l_sql 
       DECLARE p621_c_curs
              CURSOR WITH HOLD FOR p621_c
       LET l_i = 1
       FOREACH p621_c_curs INTO  g_c[l_i].* 
          IF SQLCA.sqlcode THEN 
               CALL s_errmsg('','','p621_c_curs',SQLCA.sqlcode,1)
               LET g_success = 'N'
               CONTINUE FOREACH
          ELSE
               LET g_success = 'Y'
          END IF
          LET g_c[l_i].c1 = 'Y'
          DISPLAY BY NAME g_c[l_i].c1
          DISPLAY BY NAME g_c[l_i].c2
          DISPLAY BY NAME g_c[l_i].c2_ima02
          LET l_i = l_i + 1 
       END FOREACH
       LET g_count1 = l_i - 1                                                                                                    
       CALL g_c.deleteElement(l_i)
       #No.FUN-830116 -- end
END FUNCTION
 
FUNCTION p621()
  DEFINE  l_ac_t          LIKE type_file.num5,   
          l_i             LIKE type_file.num5,
          n               LIKE type_file.num5,
          k               LIKE type_file.num5,
          j               LIKE type_file.num5,
          i               LIKE type_file.num5,
          l_j             LIKE type_file.num5, 
          l_n1            LIKE type_file.num5, 
          l_n2            LIKE type_file.num5, 
          l_m1            LIKE type_file.num5,
          l_m             LIKE type_file.num5,
          l_n3            LIKE type_file.num5,
          l_imx00         LIKE imx_file.imx00,
          l_imaag         LIKE ima_file.imaag,
          l_allow_insert  LIKE type_file.num5,
          l_imx01         LIKE imx_file.imx01,
          l_imx02         LIKE imx_file.imx02,
          l_imx03         LIKE imx_file.imx03,
          l_boe07         LIKE boe_file.boe07,
          l_boe08         LIKE boe_file.boe08,  
          l_allow_delete  LIKE type_file.num5    
  DEFINE l_sql           LIKE type_file.chr1000
  DEFINE l_sql1          LIKE type_file.chr1000  
  DEFINE l_bmy           RECORD LIKE bmy_file.*
  DEFINE l_bmx           RECORD LIKE bmx_file.*
  DEFINE l_bmy1          RECORD LIKE bmy_file.*
  DEFINE l_bmb02         DYNAMIC ARRAY OF LIKE bmb_file.bmb02,
         l_bmb03         DYNAMIC ARRAY OF LIKE bmb_file.bmb03,  
         l_bmb13         DYNAMIC ARRAY OF LIKE bmb_file.bmb13,
         l_bmb33         DYNAMIC ARRAY OF LIKE bmb_file.bmb33
  DEFINE l_bmb           RECORD LIKE bmb_file.* 
  DEFINE l_f             LIKE agb_file.agb02
  DEFINE l_e             LIKE agb_file.agb02
  DEFINE l_s             LIKE type_file.chr1000
  DEFINE ls_sql          STRING
  DEFINE l_str1          varchar(06)
  DEFINE l_int           LIKE type_file.chr1000
  DEFINE li_result       LIKE abb_file.abb25 
  DEFINE l_result        LIKE type_file.num5      #NO.FUN-850017 
  DEFINE l_agbslk01      LIKE agb_file.agbslk01
  DEFINE l_bmb06         LIKE bmb_file.bmb06
  DEFINE l_bmb08         LIKE bmb_file.bmb08
  DEFINE l_max_bmy02     LIKE bmy_file.bmy02 
  DEFINE l_ima151        LIKE ima_file.ima151
  DEFINE l_count1        LIKE type_file.num5       #NO.FUN-830116
  DEFINE l_count3        LIKE type_file.num5       #NO.MOD-840517 
  DEFINE p_flag          LIKE boe_file.boe07       #No.MOD-840517
  DEFINE p_flag_1        LIKE boe_file.boe08       #No.MOD-840517
   
  CALL cl_opmsg('s')
#  CALL l_bmy.clear()
#  CALL l_bmy1.clear()
   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
   CALL s_auto_assign_no("abm",tm.a4,g_today,"1","","a4","","","")
     RETURNING l_result,tm.a4
     IF (NOT l_result) THEN                                                                                                     
        CALL cl_err('','abm-621',0)                                                                                                          
     END IF                                                                                                                      
   SELECT * INTO l_bmx.* FROM bmx_file WHERE bmx01 = tm.a2
   LET l_bmx.bmx01 = tm.a4
   LET l_bmx.bmx02 = tm.a5
   LET l_bmx.bmx04 = 'N'
   LET l_bmx.bmx06 = '2'
   LET l_bmx.bmxuser = g_user
   LET l_bmx.bmxgrup = g_grup
   LET l_bmx.bmxmodu = ''
   LET l_bmx.bmxdate = g_today
   LET l_bmx.bmxacti = 'Y'
   LET l_bmx.bmx09 = '0'
   INSERT INTO bmx_file VALUES(l_bmx.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err(l_bmx.bmx01,SQLCA.sqlcode,0)
        LET g_success = 'N'
        ROLLBACK WORK
     ELSE
        LET g_success = 'Y'
        MESSAGE 'INSERT O.K'            
     END IF
#NO.FUN-830116 ---begin
#  IF tm.a3 IS NULL THEN
#       LET l_sql = " SELECT ima01,ima02 FROM ima_file,imx_file,bma_file WHERE ima01 IN(SELECT bma01 ",
#                   " FROM bma_file,bmb_file,ima_file,imx_file WHERE bma01=bmb01 ",
#                   " AND bma01=ima01 AND ima01=imx000 AND imx00='",tm.a1,"')  ",
#                   " AND imaacti='Y' AND ima01=imx000 AND imx00='",tm.a1,"'"
#  ELSE
#       LET l_sql = " SELECT ima01,ima02 FROM ima_file,imx_file,bma_file WHERE ima01 IN(SELECT bma01 ",
#                   " FROM bma_file,bmb_file,ima_file,imx_file WHERE bma01=bmb01 ",
#                   " AND bma01=ima01 AND ima01=imx000 AND imx00='",tm.a1,"')  ",
#                   " AND imaacti='Y' AND ima01=imx000 AND imx00='",tm.a1,"' AND bma06='",tm.a3,"' "
#  END IF 
#      PREPARE p621_c_2 FROM l_sql 
#      DECLARE p621_c_2_curs
#             CURSOR WITH HOLD FOR p621_c_2
#      LET l_i = 1
#      LET l_j = 1
#      FOREACH p621_c_2_curs INTO  g_c[l_i].* 
#         IF SQLCA.sqlcode THEN 
#              CALL s_errmsg('','','p621_c_curs',SQLCA.sqlcode,1)
#              LET g_success = 'N'
#              CONTINUE FOREACH
#         ELSE
#              LET g_success = 'Y'
#         END IF
        FOR l_count1 = 1 TO g_count1 
         IF g_c[l_count1].c1 = 'Y' THEN     #NO.FUN-850017
#NO.FUN-830116   ---end
          IF tm.a3 IS NULL THEN
                LET l_sql = "SELECT * FROM bmy_file,bmx_file WHERE bmy01=bmx01 AND bmx01='",tm.a2,"' AND bmx04='Y' AND bmy14='",tm.a1,"' "
          ELSE
                LET l_sql = "SELECT * FROM bmy_file,bmx_file WHERE bmy01=bmx01 AND bmx01='",tm.a2,"' AND bmx04='Y' AND bmy14='",tm.a1,"' AND bmy29='",tm.a3,"' "
          END IF 
                PREPARE p621_pro FROM l_sql 
                DECLARE p621_pro_curs
                CURSOR WITH HOLD FOR p621_pro
                LET l_i = 1
                FOREACH p621_pro_curs INTO  l_bmy1.* 
                IF SQLCA.sqlcode THEN 
                   CALL s_errmsg('','','p621_pro_curs',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                   CONTINUE FOREACH
                ELSE
                   LET g_success = 'Y'
                END IF
                SELECT ima151 INTO l_ima151 FROM ima_file WHERE ima01=l_bmy1.bmy05
                IF (l_ima151 !='Y') THEN
                   SELECT MAX(bmy02) INTO l_max_bmy02 FROM bmy_file WHERE bmy01 = tm.a2
                   IF STATUS THEN
                       CALL cl_err3("sel","bmy_file",l_max_bmy02,"","-808","","",1)
                   END IF
                   IF l_max_bmy02 IS NULL THEN
                     LET l_max_bmy02 = 0  
                   END IF
                  LET l_max_bmy02 = l_max_bmy02+1
                  LET l_bmy.* = l_bmy1.* 
                  LET l_bmy.bmy01 = tm.a4
                  LET l_bmy.bmy02 = l_max_bmy02
                  LET l_bmy.bmy14 = g_c[l_count1].c2
                  IF l_bmy1.bmy03 ='1' OR l_bmy1.bmy03='3' OR l_bmy1.bmy03='4' THEN
                     IF cl_null(l_bmy1.bmy04) THEN
                       IF tm.a3 IS NULL THEN
                         LET l_sql1 = " SELECT bmb02,bmb33  FROM bmb_file WHERE bmb01='",l_bmy.bmy14,"' AND bmb03='",l_bmy.bmy05,"' ",
                                      " AND (bmb05 IS NULL OR bmb05='') "
                       ELSE
                         LET l_sql1 = " SELECT bmb02,bmb33  FROM bmb_file WHERE bmb01='",l_bmy.bmy14,"' AND bmb03='",l_bmy.bmy05,"' ",
                                      " AND (bmb05 IS NULL OR bmb05='') AND bmb29='",tm.a3,"' "
                       END IF
                       PREPARE p621_bmb FROM l_sql1 
                       DECLARE p621_bmb_curs
                       CURSOR WITH HOLD FOR p621_bmb
                       LET l_m = 1
                       LET l_m1 =1
                       FOREACH p621_bmb_curs INTO l_bmb02[l_m],l_bmb33[l_m1]
                       IF SQLCA.sqlcode THEN 
                            CALL s_errmsg('','','p621_bmb_curs',SQLCA.sqlcode,1)
                            LET g_success = 'N'
                            CONTINUE FOREACH
                       ELSE
                            LET g_success = 'Y'
                       END IF
                         LET l_bmy.bmy04=l_bmb02[l_m]
#                        LET l_bmy.bmy33=l_bmb33[l_m1]        #No.FUN-850017
                         LET l_bmy.bmy33=l_bmy1.bmy33         #No.FUN-850017
                         LET l_bmy.bmy30= '1'      #NO.FUN-850017
                         INSERT INTO bmy_file VALUES(l_bmy.*)
                         IF SQLCA.sqlcode THEN
                            CALL cl_err(l_bmy.bmy01,SQLCA.sqlcode,0)
                            LET g_success = 'N'
                            ROLLBACK WORK
                         ELSE
                            LET g_flag_2 = 'Y'    #No.FUN-850017
                            LET g_success = 'Y'
                            MESSAGE 'INSERT O.K'            
                         END IF
                       LET l_m = l_m+1
                       LET l_m1 = l_m1 +1
                       END FOREACH
                     ELSE
                       IF tm.a3 IS NULL THEN
                          SELECT bmb02 INTO l_bmy.bmy04 FROM bmb_file WHERE bmb01=l_bmy.bmy14 AND bmb03=l_bmy.bmy05
                                       AND (bmb05 IS NULL OR bmb05='') AND bmb33=l_bmy1.bmy04 
                       ELSE
                           SELECT bmb02 INTO l_bmy.bmy04 FROM bmb_file WHERE bmb01=l_bmy.bmy14 AND bmb03=l_bmy.bmy05
                                       AND (bmb05 IS NULL OR bmb05='') AND bmb33=l_bmy1.bmy04 AND bmb29=tm.a3
                       END IF
                       IF STATUS THEN
                              CALL cl_err3("sel","bmb_file",l_bmy.bmy04,"","-808","","",1)
                       END IF
                      #LET l_bmy.bmy33=l_bmy1.bmy04   #No.FUN-850017
                       LET l_bmy.bmy33=l_bmy1.bmy33   #No.FUN-850017
                       LET l_bmy.bmy30= '1'           #No.FUN-850017
                       INSERT INTO bmy_file VALUES(l_bmy.*)
                         IF SQLCA.sqlcode THEN
                            CALL cl_err(l_bmy.bmy01,SQLCA.sqlcode,0)
                            LET g_success = 'N'
                            ROLLBACK WORK
                         ELSE
                            LET g_flag_2 = 'Y'    #No.FUN-850017
                            LET g_success = 'Y'
                            MESSAGE 'INSERT O.K'            
                         END IF
                     END IF
                  END IF
                ELSE
                  IF l_bmy1.bmy03 = '1' THEN
                    LET l_sql1 = " SELECT bmb02,bmb03 FROM bmb_file,ima_file,imx_file " ,
                                 " WHERE bmb01='",g_c[l_count1].c2,"' AND bmb03=ima01 AND ima01=imx000 ",
                                 " AND imx00='",l_bmy1.bmy05,"' AND (bmb05 IS NULL OR bmb05='') " 
                    IF NOT cl_null(l_bmy1.bmy04) THEN
                       LET l_sql1 = l_sql1," AND bmb33='",l_bmy1.bmy04,"'"
                    END IF
                    IF NOT cl_null(tm.a3) THEN
                       LET l_sql1 = l_sql1," AND bmb29='",tm.a3,"' "
                    END IF
                    LET l_n1 = 1
                    LET l_n2 = 1
                    PREPARE p621_bmb_1 FROM l_sql1 
                    DECLARE p621_bmb_1_curs
                    CURSOR WITH HOLD FOR p621_bmb_1
                    FOREACH p621_bmb_1_curs INTO l_bmb02[l_n1],l_bmb03[l_n2]
                       IF SQLCA.sqlcode THEN 
                            CALL s_errmsg('','','p621_bmb_curs',SQLCA.sqlcode,1)
                            LET g_success = 'N'
                            CONTINUE FOREACH
                       ELSE
                            LET g_success = 'Y'
                       END IF
                       SELECT MAX(bmy02) INTO l_max_bmy02 FROM bmy_file WHERE bmy01 = tm.a2
                         IF STATUS THEN
                              CALL cl_err3("sel","bmy_file",l_max_bmy02,"","-808","","",1)
                         END IF
                         IF l_max_bmy02 IS NULL THEN
                            LET l_max_bmy02 = 0  
                         END IF
                         LET l_max_bmy02 = l_max_bmy02+1
                       LET l_bmy.* = l_bmy1.*
                       LET  l_bmy.bmy01= tm.a4
                       LET  l_bmy.bmy02= l_max_bmy02
                       LET  l_bmy.bmy14= g_c[l_count1].c2
                       LET  l_bmy.bmy04=l_bmb02[l_n1]
                       LET  l_bmy.bmy05=l_bmb03[l_n2]
                      #LET  l_bmy.bmy33=l_bmy1.bmy04   #No.FUN-850017
                       LET  l_bmy.bmy33=l_bmy1.bmy33   #No.FUN-850017
                       LET  l_bmy.bmy30= '1'       #NO.FUN-850017
                       INSERT INTO bmy_file VALUES(l_bmy.*)
                         IF SQLCA.sqlcode THEN
                            CALL cl_err(l_bmy.bmy01,SQLCA.sqlcode,0)
                            LET g_success = 'N'
                            ROLLBACK WORK
                         ELSE
                            LET g_flag_2 = 'Y'    #No.FUN-850017
                            LET g_success = 'Y'
                            MESSAGE 'INSERT O.K'            
                         END IF
                    LET l_n1 = l_n1 +1
                    LET l_n2 = l_n2 +1
                    END FOREACH
                  ELSE
                    IF l_bmy1.bmy03='3' THEN
                    LET l_sql1 = " SELECT bmb02,bmb03 FROM bmb_file,imx_file,ima_file " ,     #MOD-840517  add imx_file ima_file
                                 " WHERE bmb01='",g_c[l_count1].c2,"' AND bmb03=ima01 AND ima01=imx000 ",
                                 " AND imx00='",l_bmy1.bmy05,"' AND (bmb05 IS NULL OR bmb05='') " 
                    IF NOT cl_null(l_bmy1.bmy04) THEN
                       LET l_sql1 = l_sql1," AND bmb33='",l_bmy1.bmy04,"'"
                    END IF
                    IF NOT cl_null(tm.a3) THEN
                       LET l_sql1 = l_sql1," AND bmb29='",tm.a3,"' "
                    END IF
                    LET l_n1 = 1
                    LET l_n2 = 1
                    PREPARE p621_bmb_2 FROM l_sql1 
                    DECLARE p621_bmb_2_curs
                    CURSOR WITH HOLD FOR p621_bmb_2
                    FOREACH p621_bmb_2_curs INTO l_bmb02[l_n1],l_bmb03[l_n2]
                       IF SQLCA.sqlcode THEN 
                            CALL s_errmsg('','','p621_bmb_curs',SQLCA.sqlcode,1)
                            LET g_success = 'N'
                            CONTINUE FOREACH
                       ELSE
                            LET g_success = 'Y'
                       END IF
                      #SELECT MAX(bmy02) INTO l_max_bmy02 FROM bmy_file WHERE bmy01 = tm.a2           #NO.FUN-850017 
                       SELECT MAX(bmy02) INTO l_max_bmy02 FROM bmy_file WHERE bmy01 = tm.a4           #NO.FUN-850017
                         IF STATUS THEN
                              CALL cl_err3("sel","bmy_file",l_max_bmy02,"","-808","","",1)
                         END IF
                         IF l_max_bmy02 IS NULL THEN
                            LET l_max_bmy02 = 0  
                         END IF
                         LET l_max_bmy02 = l_max_bmy02+1
                       LET  l_bmy.* = l_bmy1.*
                       LET  l_bmy.bmy01= tm.a4
                       LET  l_bmy.bmy02= l_max_bmy02
                       LET  l_bmy.bmy14=g_c[l_count1].c2
                       LET  l_bmy.bmy04=l_bmb02[l_n1]
                       LET  l_bmy.bmy05=l_bmb03[l_n2]
                      #LET  l_bmy.bmy33=l_bmy1.bmy04      #No.FUN-850017
                       LET  l_bmy.bmy33=l_bmy1.bmy33      #No.FUN-850017
#數呾郪傖蚚講
                       IF tm.a3 IS NULL THEN
                        SELECT bmb06 INTO l_bmb06 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                  AND bmb33 = l_bmy1.bmy04    #No.FUN-850017
                       ELSE
                        SELECT bmb06 INTO l_bmb06 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                  AND bmb33 = l_bmy1.bmy04 AND bmb29 = tm.a3   #No.FUN-850017
                       END IF
                       IF STATUS THEN
                              CALL cl_err3("sel","bmb_file",l_bmb06,"","-808","","",1)
                       END IF

                         #SELECT imx00,imaag  INTO l_imx00,l_imaag FROM imx_file,ima_file WHERE imx000=ima01 
                          SELECT imx00,imaag1  INTO l_imx00,l_imaag FROM imx_file,ima_file WHERE imx000=ima01    #No.FUN-850017
                                                            # AND ima01=l_bmy.bmy08
                                                             AND ima01=l_bmy.bmy14   # MOD-840517
                          SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 1       
                           IF l_agbslk01='Y'  THEN                                             
                              SELECT imx01 INTO l_imx01 FROM imx_file  WHERE imx000=l_bmy.bmy14  # MOD-840517   change bmy08 to bmy14
                           END IF                                                               
                           SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 2      
                           IF l_agbslk01='Y' THEN                                              
                              SELECT imx02 INTO l_imx02 FROM imx_file  WHERE imx000=l_bmy.bmy14  # MOD-840517   change bmy08 to bmy14 
                           END IF                                                               
                           SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 3      
                           IF l_agbslk01='Y' THEN                                              
                              SELECT imx03 INTO l_imx03 FROM imx_file  WHERE imx000=l_bmy.bmy14  # MOD-840517   change bmy08 to bmy14
                           END IF                                                               
                           #NO.MOD-840517 begin                                                                                            
                            IF l_imx01 IS NULL THEN                                                                                         
                               LET l_imx01  = ' '                                                                                           
                            END IF                                                                                                          
                            IF l_imx02 IS NULL THEN                                                                                         
                               LET l_imx02  = ' '                                                                                           
                            END IF                                                                                                          
                            IF l_imx03 IS NULL THEN                                                                                         
                               LET l_imx03  = ' '                                                                                           
                            END IF                                                                                                          
                           #SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05    #No.FUN-850017
                            SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_imx00 and boe02=l_bmy1.bmy05       #No.FUN-850017
                             AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                             AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                             AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                             AND boe06 = l_bmy.bmy13                                            
                            IF l_count3 <=0 THEN
                           #SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05    #No.FUN-850017
                            SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_imx00  and boe02=l_bmy1.bmy05      #No.FUN-850017
                             AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                             AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                             AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                             AND (boe06 IS NULL OR boe06 = ' ') 
                            END IF
                           #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05        #No.FUN-850017
                            SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00  and boe02=l_bmy1.bmy05          #No.FUN-850017
                             AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                             AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                             AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                             AND boe06 = l_bmy.bmy13                                            
                            IF (l_boe07 IS NULL OR l_boe07 = ' ') AND (l_boe08 IS NULL OR l_boe08 = ' ') THEN
                           #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05       #No.FUN-850017
                            SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00 and boe02=l_bmy1.bmy05          #No.FUN-850017
                             AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                             AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                             AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                             AND (boe06 IS NULL OR boe06 = ' ')
                            END IF
                          #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05
                          #AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                          #AND (boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                          #AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')
                          #AND boe06 = l_bmy.bmy13                                            
                          #NO.MOD-840517 end  
                         #IF STATUS THEN
                         #    CALL cl_err3("sel","boe_file",l_boe07,"","-808","","",1)
                         #END IF
                          IF l_bmy1.bmy06 != l_bmb06 THEN
                               SELECT TRIM(l_boe07) INTO l_s FROM DUAL 
                               LET j=1
                               LET n=1
                               LET l_int = l_bmy.bmy06    #No.MOD-840517
                               FOR i=1 TO length(l_s)
                                IF i = length(l_s)  THEN
                                 IF l_s[j,j+1] = '$$' THEN
                                 LET l_str1 = l_s[j+2,i]   #NO.MOD-840517
                                   SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05 AND agb03 = l_str1
                                           IF l_e = '1' THEN
                                             #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05    #NO.MOD-840517
                                           END IF
                                           IF l_e = '2' THEN
                                             #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                           END IF
                                           IF l_e = '3' THEN
                                             #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                           END IF
                                 ELSE
                                  IF l_s[j,j] = '$' THEN
                                  LET l_str1 = l_s[j+1,i]   #NO.MOD-840517
                                   SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                           IF l_f = '1' THEN
                                             #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517 
                                           END IF
                                           IF l_f = '2' THEN
                                             #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517
                                           END IF
                                           IF l_f = '3' THEN
                                             #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517
                                           END IF
                                  ELSE
                                   LET l_str1 = l_s[j,i]   #NO.MOD-840517
                                   SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1                           #NO.MOD-840517
                                  END IF		
                                 END IF
                                 LET l_int = l_int,p_flag CLIPPED  #NO.MOD-840517
                                END IF  
                                IF l_s[i,i] = '_' THEN
                                 IF l_s[j,j+1] = '$$' THEN
                                   LET l_str1 = l_s[j+2,i-1]
                                  #SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                   SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05  AND agb03 = l_str1   #NO.MOD-840517
                                           IF l_e = '1' THEN
                                             #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                           END IF
                                           IF l_e = '2' THEN
                                             #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                           END IF
                                           IF l_e = '3' THEN
                                             #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                           END IF
                                 ELSE
                                  IF l_s[j,j] = '$' THEN
                                   LET l_str1 = l_s[j+1,i-1]
                                   SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                           IF l_f = '1' THEN
                                             #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                           END IF
                                           IF l_f = '2' THEN
                                             #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                           END IF
                                           IF l_f = '3' THEN
                                             #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                           END IF
                                  ELSE
                                   LET l_str1 = l_s[j,i-1]
                                  #SELECT boi02 INTO l_boe07[n] FROM boi_file  WHERE boi01 = l_str1
                                   IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'                                                          
                                    OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN  
                                        LET p_flag = l_str1    
                                   ELSE  
                                   SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1                       #NO.MOD-840517
                                   END IF      
                                   #NO.MOD-840517 ...end        
                                  END IF		
                                 END IF
                                   LET j=i+1
                                   LET n=n+1
                                ELSE
                                   CONTINUE FOR
                                END IF
                                LET l_int = l_int,p_flag CLIPPED  #NO.MOD-840517
                               END FOR
                              #NO.MOD-840517 begin
                              #LET l_int = l_bmy.bmy06
                              #FOR k=1 TO n-1
                              #    LET l_int = l_int,l_boe07[n] CLIPPED 
                              #END FOR
                              #NO.MOD-840517 end
                               LET ls_sql = "SELECT ",l_int," FROM DUAL"
                               PREPARE power_curs FROM ls_sql                                                                         
                               EXECUTE power_curs INTO li_result                                                                                                                
#                              RETURN li_result    #NO.FUN-850017
                               #NO.MOD-840517 begin
                               IF li_result IS NULL THEN                                                                                    
                                 LET li_result = l_bmy.bmy06                                                                               
                               END IF                                                                                                       
                               #NO.MOD-840517 end
                               LET l_bmy.bmy06 = li_result  
                       END IF
                       #No.FUN-850017 ---begin
                       IF tm.a3 IS NULL THEN
                           SELECT bmb08 INTO l_bmb08 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                     AND bmb33= l_bmy1.bmy04 
                       ELSE
                           SELECT bmb08 INTO l_bmb08 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                     AND bmb33= l_bmy1.bmy04  AND bmb29 = tm.a3
                       END IF
                       #No.FUN-850017 --end
                       IF STATUS THEN
                              CALL cl_err3("sel","bmb_file",l_bmb08,"","-808","","",1)
                       END IF
                       IF l_bmy1.bmy08 != l_bmb08 THEN
                       SELECT TRIM(l_boe08) INTO l_s FROM DUAL 
                               LET j=1
                               LET n=1
                               LET l_int = l_bmy.bmy08    #NO.MOD-840517
                               FOR i=1 TO length(l_s)
                                IF i = length(l_s)  THEN
                                 IF l_s[j,j+1] = '$$' THEN
                                 LET l_str1 = l_s[j+2,i]  #NO.MOD-840517 
                                   SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05 AND agb03 = l_str1
                                           IF l_e = '1' THEN
                                             #SELECT imx01 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                           END IF
                                           IF l_e = '2' THEN
                                             #SELECT imx02 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                           END IF
                                           IF l_e = '3' THEN
                                             #SELECT imx03 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                              SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                           END IF
                                 ELSE
                                  IF l_s[j,j] = '$' THEN
                                  LET l_str1 = l_s[j+1,i]   #NO.MOD-840517
                                   SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                           IF l_f = '1' THEN
                                             #SELECT imx01 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #NO.MOD-840517 
                                           END IF
                                           IF l_f = '2' THEN
                                             #SELECT imx02 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #No.MOD-840517
                                           END IF
                                           IF l_f = '3' THEN
                                             #SELECT imx03 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                              SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #NO.MOD-840517
                                           END IF
                                  ELSE
                                   LET l_str1 = l_s[j,i]    #NO.MOD-840517
                                  #SELECT boi02 INTO l_boe08[n] FROM boi_file  WHERE boi01 = l_str1
                                   SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1    #NO.MOD-840517
                                  END IF		
                                 END IF
                                 LET l_int = l_int,p_flag_1 CLIPPED  #NO.MOD-840517
                                END IF  
                                IF l_s[i,i] = '_' THEN
                                 IF l_s[j,j+1] = '$$' THEN
                                   LET l_str1 = l_s[j+2,i-1]
                                  #SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                   SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05  AND agb03 = l_str1   #NO.MOD-840517
                                           IF l_e = '1' THEN
                                              SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517 
                                           END IF
                                           IF l_e = '2' THEN
                                              SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                           END IF
                                           IF l_e = '3' THEN
                                              SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05 #NO.MOD-840517
                                           END IF
                                 ELSE
                                  IF l_s[j,j] = '$' THEN
                                   LET l_str1 = l_s[j+1,i-1]
                                   SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                           IF l_f = '1' THEN
                                              SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2  #No.MOD-840517
                                           END IF
                                           IF l_f = '2' THEN
                                              SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2 #NO.MOD-840517 
                                           END IF
                                           IF l_f = '3' THEN
                                              SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2 #NO.MOD-840517
                                           END IF
                                  ELSE
                                   LET l_str1 = l_s[j,i-1]
                                   #NO.MOD-840517  ...begin
                                   IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'                                                          
                                    OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN  
                                        LET p_flag_1 = l_str1    
                                   ELSE  
                                   SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1                       #NO.MOD-840517
                                   END IF      
                                   #NO.MOD-840517 ...end        
                                  END IF		
                                 END IF
                                   LET j=i+1
                                   LET n=n+1
                                ELSE
                                   CONTINUE FOR
                                END IF
                                LET l_int = l_int,p_flag_1 CLIPPED  #NO.MOD-840517
                               END FOR
                              #NO.MOD-840517 ..begin
                              #LET l_int = l_bmy.bmy08
                              #FOR k=1 TO n-1
                              #    LET l_int = l_int,l_boe08[n] CLIPPED 
                              #END FOR
                              #NO.MOD-840517 ..end
                               LET ls_sql = "SELECT ",l_int," FROM DUAL"
                               PREPARE power_curs_0 FROM ls_sql                                                                         
                               EXECUTE power_curs_0 INTO li_result                                                                                                                
                               #RETURN li_result
                               #NO.MOD-840517 begin
                               IF li_result IS NULL THEN                                                                                    
                                 LET li_result = l_bmy.bmy08                                                                               
                               END IF                                                                                                       
                               #NO.MOD-840517 end
                               LET l_bmy.bmy08 = li_result  
                       END IF
                       #NO.MOD-840517 begin
                       IF l_bmy.bmy33 IS NULL THEN
                          LET l_bmy.bmy33 =0 
                       END IF 
                       #NO.MOD-840517 end
                       LET l_bmy.bmy30 = '1'      #No.FUN-850017
                       INSERT INTO bmy_file VALUES(l_bmy.*)
                         IF SQLCA.sqlcode THEN
                            CALL cl_err(l_bmy.bmy01,SQLCA.sqlcode,0)
                            LET g_success = 'N'
                            ROLLBACK WORK
                         ELSE
                            LET g_flag_2 = 'Y'    #No.FUN-850017
                            LET g_success = 'Y'
                            MESSAGE 'INSERT O.K'            
                            COMMIT WORK       #NO.MOD-840517
                         END IF    
                           LET l_n1 = l_n1 +1
                           LET l_n2 = l_n2 +1
                           END FOREACH   
# l_bmy1.bmy03='2'(陔啋璃汜虴) 
                    ELSE
                      IF l_bmy1.bmy03='2' THEN
                        LET l_sql1 = " SELECT * FROM bmb_file WHERE bmb01='",g_c[l_count1].c2,"' AND bmb03=ima01 AND ima01=imx000 ",
                                     " AND imx00='",l_bmy1.bmy05,"' AND (bmb05 IS NULL OR bmb05='') "
                        IF NOT cl_null(tm.a3) THEN
                           LET l_sql1 = l_sql1," AND bmb29='",tm.a3,"' "
                        END IF
                        LET l_n1 = 1
                        LET l_n2 = 1
                        PREPARE p621_bmb_4 FROM l_sql1 
                        DECLARE p621_bmb_4_curs
                        CURSOR WITH HOLD FOR p621_bmb_4
                        FOREACH p621_bmb_4_curs INTO l_bmb02[l_n1],l_bmb03[l_n2]
                           IF SQLCA.sqlcode THEN 
                                CALL s_errmsg('','','p621_bmb_2_curs',SQLCA.sqlcode,1)
                                LET g_success = 'N'
                                CONTINUE FOREACH
                           ELSE
                                LET g_success = 'Y'
                           END IF
                           SELECT MAX(bmy02) INTO l_max_bmy02 FROM bmy_file WHERE bmy01 = tm.a2
                             IF STATUS THEN
                                  CALL cl_err3("sel","bmy_file",l_max_bmy02,"","-808","","",1)
                             END IF
                             IF l_max_bmy02 IS NULL THEN
                                LET l_max_bmy02 = 0  
                             END IF
                             LET l_max_bmy02 = l_max_bmy02+1
                           LET  l_bmy.* = l_bmy1.*
                           LET  l_bmy.bmy01= tm.a4
                           LET  l_bmy.bmy02= l_max_bmy02
#MOD-C10142 --begin--
                          CALL p621_check(l_bmy.bmy01,l_bmy.bmy02)     
                               RETURNING l_bmy.bmy02
                          IF cl_null(l_bmy.bmy02) THEN
                             LET l_bmy.bmy02 = 0                        
                          END IF
#MOD-C10142 --end--                         
                           
                           LET  l_bmy.bmy14=g_c[l_count1].c2
                          #LET  l_bmy.bmy33=l_bmy1.bmy04    #No.FUN-850017
                           LET  l_bmy.bmy33=l_bmy1.bmy33    #No.FUN-850017
#數呾郪傖蚚講
                           SELECT bmb06 INTO l_bmb06 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                           IF STATUS THEN
                                  CALL cl_err3("sel","bmb_file",l_bmb06,"","-808","","",1)
                           END IF
    
                             #SELECT imx00,imaag  INTO l_imx00,l_imaag FROM imx_file,ima_file WHERE imx000=ima01     #No.FUN-850017
                              SELECT imx00,imaag1  INTO l_imx00,l_imaag FROM imx_file,ima_file WHERE imx000=ima01    #No.FUN-850017
                                                                 AND ima01=l_bmy.bmy08
                              SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 1       
                               IF l_agbslk01='Y'  THEN                                             
                                  SELECT imx01 INTO l_imx01 FROM imx_file  WHERE imx000=l_bmy.bmy08
                               END IF                                                               
                               SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 2      
                               IF l_agbslk01='Y' THEN                                              
                                  SELECT imx02 INTO l_imx02 FROM imx_file  WHERE imx000=l_bmy.bmy08 
                               END IF                                                               
                               SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 3      
                               IF l_agbslk01='Y' THEN                                              
                                  SELECT imx03 INTO l_imx03 FROM imx_file  WHERE imx000=l_bmy.bmy08
                               END IF                                                               
                              
                               #NO.MOD-840517 begin                                                                                            
                                IF l_imx01 IS NULL THEN                                                                                         
                                   LET l_imx01  = ' '                                                                                           
                                END IF                                                                                                          
                                IF l_imx02 IS NULL THEN                                                                                         
                                   LET l_imx02  = ' '                                                                                           
                                END IF                                                                                                          
                                IF l_imx03 IS NULL THEN                                                                                         
                                   LET l_imx03  = ' '                                                                                           
                                END IF                                                                                                          
                               #SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05    #No.FUN-850017
                                SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_imx00 and boe02=l_bmy1.bmy05       #No.FUN-850017
                                 AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                 AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                 AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                 AND boe06 = l_bmy.bmy13                                            
                                IF l_count3 <=0 THEN
                               #SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05    #No.FUN-850017
                                SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_imx00  and boe02=l_bmy1.bmy05      #No.FUN-850017
                                 AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                 AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                 AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                 AND (boe06 IS NULL OR boe06 = ' ') 
                                END IF
                               #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05        #No.FUN-850017
                                SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00  and boe02=l_bmy1.bmy05          #No.FUN-850017
                                 AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                 AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                 AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                 AND boe06 = l_bmy.bmy13                                            
                                IF (l_boe07 IS NULL OR l_boe07 = ' ') AND (l_boe08 IS NULL OR l_boe08 = ' ') THEN
                               #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05       #No.FUN-850017
                                SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00 and boe02=l_bmy1.bmy05          #No.FUN-850017
                                 AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                 AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                 AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                 AND (boe06 IS NULL OR boe06 = ' ')
                                END IF
                              #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05
                              #AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                              #AND (boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                              #AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')
                              #AND boe06 = l_bmy.bmy13                                            
                              #NO.MOD-840517 end  
                             #IF STATUS THEN
                             #    CALL cl_err3("sel","boe_file",l_boe07,"","-808","","",1)
                             #END IF
                              IF l_bmy1.bmy06 != l_bmb06 THEN
                                   SELECT TRIM(l_boe07) INTO l_s FROM DUAL 
                                   LET j=1
                                   LET n=1
                                   LET l_int = l_bmy.bmy06    #No.MOD-840517
                                   FOR i=1 TO length(l_s)
                                    IF i = length(l_s)  THEN
                                     IF l_s[j,j+1] = '$$' THEN
                                     LET l_str1 = l_s[j+2,i]   #NO.MOD-840517
                                       SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05 AND agb03 = l_str1
                                               IF l_e = '1' THEN
                                                 #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05    #NO.MOD-840517
                                               END IF
                                               IF l_e = '2' THEN
                                                 #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                               END IF
                                               IF l_e = '3' THEN
                                                 #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                               END IF
                                     ELSE
                                      IF l_s[j,j] = '$' THEN
                                      LET l_str1 = l_s[j+1,i]   #NO.MOD-840517
                                       SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                               IF l_f = '1' THEN
                                                 #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517 
                                               END IF
                                               IF l_f = '2' THEN
                                                 #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517
                                               END IF
                                               IF l_f = '3' THEN
                                                 #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517
                                               END IF
                                      ELSE
                                       LET l_str1 = l_s[j,i]   #NO.MOD-840517
                                       SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1                           #NO.MOD-840517
                                      END IF		
                                     END IF
                                     LET l_int = l_int,p_flag CLIPPED  #NO.MOD-840517
                                    END IF  
                                    IF l_s[i,i] = '_' THEN
                                     IF l_s[j,j+1] = '$$' THEN
                                       LET l_str1 = l_s[j+2,i-1]
                                      #SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                       SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05  AND agb03 = l_str1   #NO.MOD-840517
                                               IF l_e = '1' THEN
                                                 #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                               END IF
                                               IF l_e = '2' THEN
                                                 #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                               END IF
                                               IF l_e = '3' THEN
                                                 #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                               END IF
                                     ELSE
                                      IF l_s[j,j] = '$' THEN
                                       LET l_str1 = l_s[j+1,i-1]
                                       SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                               IF l_f = '1' THEN
                                                 #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                               END IF
                                               IF l_f = '2' THEN
                                                 #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                               END IF
                                               IF l_f = '3' THEN
                                                 #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                               END IF
                                      ELSE
                                       LET l_str1 = l_s[j,i-1]
                                      #SELECT boi02 INTO l_boe07[n] FROM boi_file  WHERE boi01 = l_str1
                                       IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'                                                          
                                        OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN  
                                            LET p_flag = l_str1    
                                       ELSE  
                                       SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1                       #NO.MOD-840517
                                       END IF      
                                       #NO.MOD-840517 ...end        
                                      END IF		
                                     END IF
                                       LET j=i+1
                                       LET n=n+1
                                    ELSE
                                       CONTINUE FOR
                                    END IF
                                    LET l_int = l_int,p_flag CLIPPED  #NO.MOD-840517
                                   END FOR
                                  #NO.MOD-840517 begin
                                  #LET l_int = l_bmy.bmy06
                                  #FOR k=1 TO n-1
                                  #    LET l_int = l_int,l_boe07[n] CLIPPED 
                                  #END FOR
                                  #NO.MOD-840517 end
                                   LET ls_sql = "SELECT ",l_int," FROM DUAL"
                                   PREPARE power_curs_1 FROM ls_sql                                                                         
                                   EXECUTE power_curs_1 INTO li_result                                                                                                                
    #                              RETURN li_result    #NO.FUN-850017
                                   #NO.MOD-840517 begin
                                   IF li_result IS NULL THEN                                                                                    
                                     LET li_result = l_bmy.bmy06                                                                               
                                   END IF                                                                                                       
                                   #NO.MOD-840517 end
                                   LET l_bmy.bmy06 = li_result  
                           END IF

#MOD-C10142 --begin--
                          IF cl_null(l_bmy1.bmy04) THEN
                             LET l_bmy1.bmy04 = 0 
                          END IF
#MOD-C10142  --end--
                           
                           #No.FUN-850017 ---begin
                           IF tm.a3 IS NULL THEN
                               SELECT bmb08 INTO l_bmb08 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                         AND bmb33= l_bmy1.bmy04 
                           ELSE
                               SELECT bmb08 INTO l_bmb08 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                         AND bmb33= l_bmy1.bmy04  AND bmb29 = tm.a3
                           END IF
                           #No.FUN-850017 --end
#MOD-C10142 --begin--
#                           IF STATUS THEN
#                                  CALL cl_err3("sel","bmb_file",l_bmb08,"","-808","","",1)
#                           END IF
 
                           IF cl_null(l_bmb08) THEN 
                              LET l_bmb08 = 0 
                           END IF
                           IF cl_null(l_bmy1.bmy08) THEN
                              LET l_bmy1.bmy08 = 0
                           END IF
#MOD-C10142 --end--
                           IF l_bmy1.bmy08 != l_bmb08 THEN
                           SELECT TRIM(l_boe08) INTO l_s FROM DUAL 
                                   LET j=1
                                   LET n=1
                                   LET l_int = l_bmy.bmy08    #NO.MOD-840517
                                   FOR i=1 TO length(l_s)
                                    IF i = length(l_s)  THEN
                                     IF l_s[j,j+1] = '$$' THEN
                                     LET l_str1 = l_s[j+2,i]  #NO.MOD-840517 
                                       SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05 AND agb03 = l_str1
                                               IF l_e = '1' THEN
                                                 #SELECT imx01 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                               END IF
                                               IF l_e = '2' THEN
                                                 #SELECT imx02 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                               END IF
                                               IF l_e = '3' THEN
                                                 #SELECT imx03 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                  SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                               END IF
                                     ELSE
                                      IF l_s[j,j] = '$' THEN
                                      LET l_str1 = l_s[j+1,i]   #NO.MOD-840517
                                       SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                               IF l_f = '1' THEN
                                                 #SELECT imx01 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #NO.MOD-840517 
                                               END IF
                                               IF l_f = '2' THEN
                                                 #SELECT imx02 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #No.MOD-840517
                                               END IF
                                               IF l_f = '3' THEN
                                                 #SELECT imx03 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                  SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #NO.MOD-840517
                                               END IF
                                      ELSE
                                       LET l_str1 = l_s[j,i]    #NO.MOD-840517
                                      #SELECT boi02 INTO l_boe08[n] FROM boi_file  WHERE boi01 = l_str1
                                       SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1    #NO.MOD-840517
                                      END IF		
                                     END IF
                                     LET l_int = l_int,p_flag_1 CLIPPED  #NO.MOD-840517
                                    END IF  
                                    IF l_s[i,i] = '_' THEN
                                     IF l_s[j,j+1] = '$$' THEN
                                       LET l_str1 = l_s[j+2,i-1]
                                      #SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                       SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05  AND agb03 = l_str1   #NO.MOD-840517
                                               IF l_e = '1' THEN
                                                  SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517 
                                               END IF
                                               IF l_e = '2' THEN
                                                  SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                               END IF
                                               IF l_e = '3' THEN
                                                  SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05 #NO.MOD-840517
                                               END IF
                                     ELSE
                                      IF l_s[j,j] = '$' THEN
                                       LET l_str1 = l_s[j+1,i-1]
                                       SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                               IF l_f = '1' THEN
                                                  SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2  #No.MOD-840517
                                               END IF
                                               IF l_f = '2' THEN
                                                  SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2 #NO.MOD-840517 
                                               END IF
                                               IF l_f = '3' THEN
                                                  SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2 #NO.MOD-840517
                                               END IF
                                      ELSE
                                       LET l_str1 = l_s[j,i-1]
                                       #NO.MOD-840517  ...begin
                                       IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'                                                          
                                        OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN  
                                            LET p_flag_1 = l_str1    
                                       ELSE  
                                       SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1                       #NO.MOD-840517
                                       END IF      
                                       #NO.MOD-840517 ...end        
                                      END IF		
                                     END IF
                                       LET j=i+1
                                       LET n=n+1
                                    ELSE
                                       CONTINUE FOR
                                    END IF
                                    LET l_int = l_int,p_flag_1 CLIPPED  #NO.MOD-840517
                                   END FOR
                                  #NO.MOD-840517 ..begin
                                  #LET l_int = l_bmy.bmy08
                                  #FOR k=1 TO n-1
                                  #    LET l_int = l_int,l_boe08[n] CLIPPED 
                                  #END FOR
                                  #NO.MOD-840517 ..end
                                   LET ls_sql = "SELECT ",l_int," FROM DUAL"
                                   PREPARE power_curs_2 FROM ls_sql                                                                         
                                   EXECUTE power_curs_2 INTO li_result                                                                                                                
                                   #RETURN li_result
                                   #NO.MOD-840517 begin
                                   IF li_result IS NULL THEN                                                                                    
                                     LET li_result = l_bmy.bmy08                                                                               
                                   END IF                                                                                                       
                                   #NO.MOD-840517 end
                                   LET l_bmy.bmy08 = li_result  
                           END IF
                           #NO.MOD-840517 begin
                           IF l_bmy.bmy33 IS NULL THEN
                              LET l_bmy.bmy33 =0 
                           END IF 
                           #NO.MOD-840517 end  
                           LET   l_bmy.bmy30 = '1'    #No.FUN-850017
                           INSERT INTO bmy_file VALUES(l_bmy.*)
                             IF SQLCA.sqlcode THEN
                                CALL cl_err(l_bmy.bmy01,SQLCA.sqlcode,0)
                                LET g_success = 'N'
                                ROLLBACK WORK
                             ELSE
                                LET g_flag_2 = 'Y'    #No.FUN-850017
                                LET g_success = 'Y'
                                MESSAGE 'INSERT O.K'            
                             END IF    
                               LET l_n1 = l_n1 +1
                               LET l_n2 = l_n2 +1
                        END FOREACH
                      ELSE
                        IF l_bmy1.bmy03='4'  THEN
                           LET l_sql1 = " SELECT bmb02,bmb03,bmb13 FROM bmb_file WHERE bmb01='",g_c[l_count1].c2,"' ",
                                        " AND bmb03=ima01 AND ima01=imx000 ",
                                        " AND imx00='",l_bmy1.bmy05,"' AND (bmb05 IS NULL OR bmb05='')  "

                           IF NOT cl_null(l_bmy1.bmy04) THEN
                              LET l_sql1 = l_sql1," AND bmb33='",l_bmy1.bmy04,"'"
                           END IF            
                           IF NOT cl_null(tm.a3) THEN
                              LET l_sql1 = l_sql1," AND bmb29='",tm.a3,"' "
                           END IF
                           LET l_n1 = 1
                           LET l_n2 = 1
                           PREPARE p621_bmb_3 FROM l_sql1 
                           DECLARE p621_bmb_3_curs
                           CURSOR WITH HOLD FOR p621_bmb_3
                           FOREACH p621_bmb_3_curs INTO l_bmb02[l_n1],l_bmb03[l_n2],l_bmb13[l_n3]
                              IF SQLCA.sqlcode THEN 
                                   CALL s_errmsg('','','p621_bmb_2_curs',SQLCA.sqlcode,1)
                                   LET g_success = 'N'
                                   CONTINUE FOREACH
                              ELSE
                                   LET g_success = 'Y'
                              END IF
                              SELECT MAX(bmy02) INTO l_max_bmy02 FROM bmy_file WHERE bmy01 = tm.a2
                                IF STATUS THEN
                                     CALL cl_err3("sel","bmy_file",l_max_bmy02,"","-808","","",1)
                                END IF
                                IF l_max_bmy02 IS NULL THEN
                                   LET l_max_bmy02 = 0  
                                END IF
                                LET l_max_bmy02 = l_max_bmy02+1
                              LET  l_bmy.* = l_bmy1.*
                              LET  l_bmy.bmy01= tm.a4
                              LET  l_bmy.bmy02= l_max_bmy02
                              LET  l_bmy.bmy14=g_c[l_count1].c2
                              LET  l_bmy.bmy04=l_bmb02[l_n1]
                              LET  l_bmy.bmy05=l_bmb03[l_n2]
                              LET  l_bmy.bmy13=l_bmb13[l_n3]
                             #LET  l_bmy.bmy33=l_bmy1.bmy04        #No.FUN-850017
                              LET  l_bmy.bmy33=l_bmy1.bmy33        #No.FUN-850017
   #數呾郪傖蚚講
                              SELECT bmb06 INTO l_bmb06 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                              IF STATUS THEN
                                     CALL cl_err3("sel","bmb_file",l_bmb06,"","-808","","",1)
                              END IF
       
                                #SELECT imx00,imaag  INTO l_imx00,l_imaag FROM imx_file,ima_file WHERE imx000=ima01     #No.FUN-850017
                                 SELECT imx00,imaag1  INTO l_imx00,l_imaag FROM imx_file,ima_file WHERE imx000=ima01    #No.FUN-850017 
                                                                    AND ima01=l_bmy.bmy08
                                 SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 1       
                                  IF l_agbslk01='Y'  THEN                                             
                                     SELECT imx01 INTO l_imx01 FROM imx_file  WHERE imx000=l_bmy.bmy08
                                  END IF                                                               
                                  SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 2      
                                  IF l_agbslk01='Y' THEN                                              
                                     SELECT imx02 INTO l_imx02 FROM imx_file  WHERE imx000=l_bmy.bmy08 
                                  END IF                                                               
                                  SELECT agbslk01 INTO l_agbslk01 FROM agb_file WHERE agb01 = l_imaag AND agb02 = 3      
                                  IF l_agbslk01='Y' THEN                                              
                                     SELECT imx03 INTO l_imx03 FROM imx_file  WHERE imx000=l_bmy.bmy08
                                  END IF                                                               
                                 
                                  #NO.MOD-840517 begin                                                                                            
                                   IF l_imx01 IS NULL THEN                                                                                         
                                      LET l_imx01  = ' '                                                                                           
                                   END IF                                                                                                          
                                   IF l_imx02 IS NULL THEN                                                                                         
                                      LET l_imx02  = ' '                                                                                           
                                   END IF                                                                                                          
                                   IF l_imx03 IS NULL THEN                                                                                         
                                      LET l_imx03  = ' '                                                                                           
                                   END IF                                                                                                          
                                  #SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05    #No.FUN-850017
                                   SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_imx00 and boe02=l_bmy1.bmy27       #No.FUN-850017
                                    AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                    AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                    AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                    AND boe06 = l_bmy.bmy13                                            
                                   IF l_count3 <=0 THEN
                                  #SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05    #No.FUN-850017
                                   SELECT COUNT(*)  INTO l_count3 FROM boe_file WHERE boe01=l_imx00  and boe02=l_bmy1.bmy27      #No.FUN-850017
                                    AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                    AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                    AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                    AND (boe06 IS NULL OR boe06 = ' ') 
                                   END IF
                                  #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05        #No.FUN-850017
                                   SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00  and boe02=l_bmy1.bmy27          #No.FUN-850017
                                    AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                    AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                    AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                    AND boe06 = l_bmy.bmy13                                            
                                   IF (l_boe07 IS NULL OR l_boe07 = ' ') AND (l_boe08 IS NULL OR l_boe08 = ' ') THEN
                                  #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05       #No.FUN-850017
                                   SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_imx00 and boe02=l_bmy1.bmy27          #No.FUN-850017
                                    AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                    AND(boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                    AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')                                               
                                    AND (boe06 IS NULL OR boe06 = ' ')
                                   END IF
                                 #SELECT boe07,boe08 INTO l_boe07,l_boe08 FROM boe_file WHERE boe01=l_bmy.bmy14 and boe02=l_bmy.bmy05
                                 #AND (boe03=l_imx01 OR boe03 IS NULL OR boe03=' ')                                               
                                 #AND (boe04=l_imx02 OR boe04 IS NULL OR boe04=' ')                                                
                                 #AND (boe05=l_imx03 OR boe05 IS NULL OR boe05=' ')
                                 #AND boe06 = l_bmy.bmy13                                            
                                 #NO.MOD-840517 end  
                                #IF STATUS THEN
                                #    CALL cl_err3("sel","boe_file",l_boe07,"","-808","","",1)
                                #END IF
                                 IF l_bmy1.bmy06 != l_bmb06 THEN
                                      SELECT TRIM(l_boe07) INTO l_s FROM DUAL 
                                      LET j=1
                                      LET n=1
                                      LET l_int = l_bmy.bmy06    #No.MOD-840517
                                      FOR i=1 TO length(l_s)
                                       IF i = length(l_s)  THEN
                                        IF l_s[j,j+1] = '$$' THEN
                                        LET l_str1 = l_s[j+2,i]   #NO.MOD-840517
                                          SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05 AND agb03 = l_str1
                                                  IF l_e = '1' THEN
                                                    #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05    #NO.MOD-840517
                                                  END IF
                                                  IF l_e = '2' THEN
                                                    #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                                  END IF
                                                  IF l_e = '3' THEN
                                                    #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                                  END IF
                                        ELSE
                                         IF l_s[j,j] = '$' THEN
                                         LET l_str1 = l_s[j+1,i]   #NO.MOD-840517
                                          SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                                  IF l_f = '1' THEN
                                                    #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517 
                                                  END IF
                                                  IF l_f = '2' THEN
                                                    #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517
                                                  END IF
                                                  IF l_f = '3' THEN
                                                    #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2      #NO.MOD-840517
                                                  END IF
                                         ELSE
                                          LET l_str1 = l_s[j,i]   #NO.MOD-840517
                                          SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1                           #NO.MOD-840517
                                         END IF		
                                        END IF
                                        LET l_int = l_int,p_flag CLIPPED  #NO.MOD-840517
                                       END IF  
                                       IF l_s[i,i] = '_' THEN
                                        IF l_s[j,j+1] = '$$' THEN
                                          LET l_str1 = l_s[j+2,i-1]
                                         #SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                          SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05  AND agb03 = l_str1   #NO.MOD-840517
                                                  IF l_e = '1' THEN
                                                    #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                                  END IF
                                                  IF l_e = '2' THEN
                                                    #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                                  END IF
                                                  IF l_e = '3' THEN
                                                    #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05           #NO.MOD-840517
                                                  END IF
                                        ELSE
                                         IF l_s[j,j] = '$' THEN
                                          LET l_str1 = l_s[j+1,i-1]
                                          SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                                  IF l_f = '1' THEN
                                                    #SELECT imx01 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx01 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                                  END IF
                                                  IF l_f = '2' THEN
                                                    #SELECT imx02 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx02 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                                  END IF
                                                  IF l_f = '3' THEN
                                                    #SELECT imx03 INTO l_boe07[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx03 INTO p_flag FROM imx_file WHERE imx000 = g_c[l_count1].c2  #NO.MOD-840517
                                                  END IF
                                         ELSE
                                          LET l_str1 = l_s[j,i-1]
                                         #SELECT boi02 INTO l_boe07[n] FROM boi_file  WHERE boi01 = l_str1
                                          IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'                                                          
                                           OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN  
                                               LET p_flag = l_str1    
                                          ELSE  
                                          SELECT boi02 INTO p_flag FROM boi_file  WHERE boi01 = l_str1                       #NO.MOD-840517
                                          END IF      
                                          #NO.MOD-840517 ...end        
                                         END IF		
                                        END IF
                                          LET j=i+1
                                          LET n=n+1
                                       ELSE
                                          CONTINUE FOR
                                       END IF
                                       LET l_int = l_int,p_flag CLIPPED  #NO.MOD-840517
                                      END FOR
                                     #NO.MOD-840517 begin
                                     #LET l_int = l_bmy.bmy06
                                     #FOR k=1 TO n-1
                                     #    LET l_int = l_int,l_boe07[n] CLIPPED 
                                     #END FOR
                                     #NO.MOD-840517 end
                                      LET ls_sql = "SELECT ",l_int," FROM DUAL"
                                      PREPARE power_curs_3 FROM ls_sql                                                                         
                                      EXECUTE power_curs_3 INTO li_result                                                                                                                
       #                              RETURN li_result    #NO.FUN-850017
                                      #NO.MOD-840517 begin
                                      IF li_result IS NULL THEN                                                                                    
                                        LET li_result = l_bmy.bmy06                                                                               
                                      END IF                                                                                                       
                                      #NO.MOD-840517 end
                                      LET l_bmy.bmy06 = li_result  
                              END IF
                              #No.FUN-850017 ---begin
                              IF tm.a3 IS NULL THEN
                                  SELECT bmb08 INTO l_bmb08 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                            AND bmb33= l_bmy1.bmy04 
                              ELSE
                                  SELECT bmb08 INTO l_bmb08 FROM bmb_file WHERE bmb01=g_c[l_count1].c2 AND bmb02=l_bmb02[l_n1] AND bmb03=l_bmb03[l_n2]
                                                                            AND bmb33= l_bmy1.bmy04  AND bmb29 = tm.a3
                              END IF
                              #No.FUN-850017 --end
                              IF STATUS THEN
                                     CALL cl_err3("sel","bmb_file",l_bmb08,"","-808","","",1)
                              END IF
                              IF l_bmy1.bmy08 != l_bmb08 THEN
                              SELECT TRIM(l_boe08) INTO l_s FROM DUAL 
                                      LET j=1
                                      LET n=1
                                      LET l_int = l_bmy.bmy08    #NO.MOD-840517
                                      FOR i=1 TO length(l_s)
                                       IF i = length(l_s)  THEN
                                        IF l_s[j,j+1] = '$$' THEN
                                        LET l_str1 = l_s[j+2,i]  #NO.MOD-840517 
                                          SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05 AND agb03 = l_str1
                                                  IF l_e = '1' THEN
                                                    #SELECT imx01 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                                  END IF
                                                  IF l_e = '2' THEN
                                                    #SELECT imx02 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                                  END IF
                                                  IF l_e = '3' THEN
                                                    #SELECT imx03 INTO l_boe08[n] FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05
                                                     SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05     #NO.MOD-840517
                                                  END IF
                                        ELSE
                                         IF l_s[j,j] = '$' THEN
                                         LET l_str1 = l_s[j+1,i]   #NO.MOD-840517
                                          SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag AND agb03 = l_str1
                                                  IF l_f = '1' THEN
                                                    #SELECT imx01 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #NO.MOD-840517 
                                                  END IF
                                                  IF l_f = '2' THEN
                                                    #SELECT imx02 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #No.MOD-840517
                                                  END IF
                                                  IF l_f = '3' THEN
                                                    #SELECT imx03 INTO l_boe08[n] FROM imx_file WHERE imx000 = g_c[l_count1].c2 
                                                     SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2   #NO.MOD-840517
                                                  END IF
                                         ELSE
                                          LET l_str1 = l_s[j,i]    #NO.MOD-840517
                                         #SELECT boi02 INTO l_boe08[n] FROM boi_file  WHERE boi01 = l_str1
                                          SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1    #NO.MOD-840517
                                         END IF		
                                        END IF
                                        LET l_int = l_int,p_flag_1 CLIPPED  #NO.MOD-840517
                                       END IF  
                                       IF l_s[i,i] = '_' THEN
                                        IF l_s[j,j+1] = '$$' THEN
                                          LET l_str1 = l_s[j+2,i-1]
                                         #SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =t_tbmb.tbmb01  AND agb03 = l_str1
                                          SELECT agb02 INTO l_e FROM agb_file,ima_file WHERE agb01 = imaag  AND ima01 =l_bmy.bmy05  AND agb03 = l_str1   #NO.MOD-840517
                                                  IF l_e = '1' THEN
                                                     SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517 
                                                  END IF
                                                  IF l_e = '2' THEN
                                                     SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05   #NO.MOD-840517
                                                  END IF
                                                  IF l_e = '3' THEN
                                                     SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = l_bmy.bmy14 AND imx00 = l_bmy.bmy05 #NO.MOD-840517
                                                  END IF
                                        ELSE
                                         IF l_s[j,j] = '$' THEN
                                          LET l_str1 = l_s[j+1,i-1]
                                          SELECT agb02 INTO l_f FROM agb_file WHERE agb01 = l_imaag  AND agb03 = l_str1
                                                  IF l_f = '1' THEN
                                                     SELECT imx01 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2  #No.MOD-840517
                                                  END IF
                                                  IF l_f = '2' THEN
                                                     SELECT imx02 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2 #NO.MOD-840517 
                                                  END IF
                                                  IF l_f = '3' THEN
                                                     SELECT imx03 INTO p_flag_1 FROM imx_file WHERE imx000 = g_c[l_count1].c2 #NO.MOD-840517
                                                  END IF
                                         ELSE
                                          LET l_str1 = l_s[j,i-1]
                                          #NO.MOD-840517  ...begin
                                          IF l_str1 = '+' OR l_str1 = '-' OR l_str1 = '*'                                                          
                                           OR l_str1 = '/' OR l_str1 = '(' OR l_str1 = ')' THEN  
                                               LET p_flag_1 = l_str1    
                                          ELSE  
                                          SELECT boi02 INTO p_flag_1 FROM boi_file  WHERE boi01 = l_str1                       #NO.MOD-840517
                                          END IF      
                                          #NO.MOD-840517 ...end        
                                         END IF		
                                        END IF
                                          LET j=i+1
                                          LET n=n+1
                                       ELSE
                                          CONTINUE FOR
                                       END IF
                                       LET l_int = l_int,p_flag_1 CLIPPED  #NO.MOD-840517
                                      END FOR
                                     #NO.MOD-840517 ..begin
                                     #LET l_int = l_bmy.bmy08
                                     #FOR k=1 TO n-1
                                     #    LET l_int = l_int,l_boe08[n] CLIPPED 
                                     #END FOR
                                     #NO.MOD-840517 ..end
                                      LET ls_sql = "SELECT ",l_int," FROM DUAL"
                                      PREPARE power_curs_4 FROM ls_sql                                                                         
                                      EXECUTE power_curs_4 INTO li_result                                                                                                                
                                      #RETURN li_result
                                      #NO.MOD-840517 begin
                                      IF li_result IS NULL THEN                                                                                    
                                        LET li_result = l_bmy.bmy08                                                                               
                                      END IF                                                                                                       
                                      #NO.MOD-840517 end
                                      LET l_bmy.bmy08 = li_result  
                              END IF
                              #NO.MOD-840517 begin
                              IF l_bmy.bmy33 IS NULL THEN
                                 LET l_bmy.bmy33 =0 
                              END IF 
                              #NO.MOD-840517 end
                              LET   l_bmy.bmy30 = '1'    #No.FUN-850017
                              INSERT INTO bmy_file VALUES(l_bmy.*)
                                IF SQLCA.sqlcode THEN
                                   CALL cl_err(l_bmy.bmy01,SQLCA.sqlcode,0)
                                   LET g_success = 'N'
                                   ROLLBACK WORK
                                ELSE
                                   LET g_flag_2 = 'Y'    #No.FUN-850017
                                   LET g_success = 'Y'
                                   MESSAGE 'INSERT O.K'            
                                END IF    
                                  LET l_n1 = l_n1 +1
                                  LET l_n2 = l_n2 +1
                           END FOREACH
                        END IF   
                      END IF
                    END IF   
                  END IF
                END IF
                END FOREACH
         END IF               # No.FUN-850017
#         LET l_i = l_i + 1     # NO.FUN-830116 
#      END FOREACH              # NO.FUN-830116
        END FOR                 # NO.FUN-830116
   
END FUNCTION

#MOD-C10142 --begin--
FUNCTION p621_check(p_bmy01,p_bmy02)
DEFINE p_bmy01       LIKE bmy_file.bmy01
DEFINE p_bmy02       LIKE bmy_file.bmy02
DEFINE l_cnt         LIKE type_file.num5
      
     LET l_cnt = 0 
     SELECT COUNT(*) INTO l_cnt FROM bmy_file 
      WHERE bmy01 = p_bmy01
        AND bmy02 = p_bmy02 
     IF l_cnt > 0 THEN
        LET p_bmy02 = p_bmy02 + 1 
        CALL p621_check(p_bmy01,p_bmy02)
            RETURNING p_bmy02
     END IF

      RETURN p_bmy02
END FUNCTION
#MOD-C10142 --end--

FUNCTION p621_array_c()
  DEFINE  l_ac_t          LIKE type_file.num5,  
          l_cnt           LIKE type_file.num5,   
          l_allow_insert  LIKE type_file.num5,   
          l_allow_delete  LIKE type_file.num5    
   DEFINE l_sql           LIKE type_file.chr1000 
   DEFINE l_i             LIKE type_file.num5
   CALL cl_opmsg('s')

   LET l_ac_t = 0
   LET l_allow_insert = FALSE
   LET l_allow_delete = FALSE
     
     INPUT ARRAY g_c WITHOUT DEFAULTS FROM s_c.*
            
      BEFORE INPUT
          LET g_before_input_done = FALSE
          LET g_before_input_done = TRUE
          
      BEFORE ROW
          LET l_ac = ARR_CURR()
          LET l_n  = ARR_COUNT()
          NEXT FIELD c1     
      AFTER ROW
         IF INT_FLAG THEN EXIT INPUT END IF
      ON ROW CHANGE
         LET g_c[l_ac].c1 =g_c[l_ac].c1 
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help() 
 
      ON ACTION controlg
         CALL cl_cmdask()    
 
      ON ACTION controls                                      
   
   END INPUT
END FUNCTION

FUNCTION p620_create_tbok_file()
 DROP TABLE tbok_file
 DROP INDEX tbok_01
 CREATE TEMP TABLE tbok_file (
     tbok01 LIKE type_file.chr50,
     tbok02 LIKE type_file.num10,
     tbok03 LIKE type_file.chr20, 
     tbok04 LIKE type_file.chr10,
     tbok05 LIKE type_file.chr1 
     )
create unique index tbok_01 on tbok_file(tbok01,tbok02,tbok04,tbok05);
END FUNCTION

FUNCTION p620_create_tbmb_file()
 DROP TABLE tbmb_file
 DROP INDEX tbmb_01
 CREATE TEMP TABLE tbmb_file (
      tbmb01 LIKE type_file.chr50,
      tbmb02 LIKE type_file.chr20,
      tbmb03 LIKE type_file.chr20, 
      tbmb04 LIKE type_file.chr20,
      tbmb05 LIKE type_file.chr10, 
      tbmb06 LIKE type_file.num20_6,
      tbmb07 LIKE type_file.num15_3,  
      tbmb08 LIKE type_file.chr50
     )
create unique index tbmb_01 on tbmb_file(tbmb01,tbmb02,tbmb03,tbmb04,tbmb05);
END FUNCTION
