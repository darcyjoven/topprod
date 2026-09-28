# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abai103.4gl
# Descriptions...: 工单待入库物料条码生成作业
# Date & Author..: 20170502 by nihuan
# 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_tm  RECORD
           tc_ibb03      LIKE tc_ibb_file.tc_ibb03,
           tc_ibb04      LIKE tc_ibb_file.tc_ibb04,
           tc_ibb10      LIKE tc_ibb_file.tc_ibb10,
           tc_ibb06      LIKE tc_ibb_file.tc_ibb06,
           ima02         LIKE ima_file.ima02,
           ima021        LIKE ima_file.ima021,
           tc_ibb22      LIKE tc_ibb_file.tc_ibb22,
           tc_ibb22_n    LIKE pmc_file.pmc03,
           tc_ibb07      LIKE tc_ibb_file.tc_ibb07
              END RECORD,
       g_tm_t  RECORD
           tc_ibb03      LIKE tc_ibb_file.tc_ibb03,
           tc_ibb04      LIKE tc_ibb_file.tc_ibb04,
           tc_ibb10      LIKE tc_ibb_file.tc_ibb10,
           tc_ibb06      LIKE tc_ibb_file.tc_ibb06,
           ima02         LIKE ima_file.ima02,
           ima021        LIKE ima_file.ima021,
           tc_ibb22      LIKE tc_ibb_file.tc_ibb22,
           tc_ibb22_n    LIKE pmc_file.pmc03,
           tc_ibb07      LIKE tc_ibb_file.tc_ibb07
              END RECORD                   
DEFINE g_i             LIKE type_file.num5
DEFINE i,l_i,l_n,l_ac,l_ac_t             LIKE type_file.num5
DEFINE g_rec_b,g_rec_b1 LIKE type_file.num5
DEFINE g_sql,l_sql           STRING
DEFINE g_str           STRING
DEFINE l_table         STRING
DEFINE p_cmd           LIKE type_file.chr1
DEFINE g_row_count     LIKE type_file.num10  
DEFINE g_curs_index    LIKE type_file.num10
DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_tc_ibb   DYNAMIC ARRAY OF RECORD
               tc_ibb06   LIKE tc_ibb_file.tc_ibb06,
               ima02      LIKE ima_file.ima02,
               ima021     LIKE ima_file.ima021,
               ima25      LIKE ima_file.ima25,
               tc_ibb21   LIKE tc_ibb_file.tc_ibb21,
               tc_ibb05   LIKE tc_ibb_file.tc_ibb05,
               tc_ibb07   LIKE tc_ibb_file.tc_ibb07
               END RECORD
DEFINE g_tc_ibb_t   RECORD
               tc_ibb06   LIKE tc_ibb_file.tc_ibb06,
               ima02      LIKE ima_file.ima02,
               ima021     LIKE ima_file.ima021,
               ima25      LIKE ima_file.ima25,
               tc_ibb21   LIKE tc_ibb_file.tc_ibb21,
               tc_ibb05   LIKE tc_ibb_file.tc_ibb05,
               tc_ibb07   LIKE tc_ibb_file.tc_ibb07
                     END RECORD
DEFINE g_gel_t RECORD
               tc_ibb06   LIKE tc_ibb_file.tc_ibb06,
               ima02      LIKE ima_file.ima02,
               ima021     LIKE ima_file.ima021,
               ima25      LIKE ima_file.ima25,
               tc_ibb21   LIKE tc_ibb_file.tc_ibb21,
               tc_ibb05   LIKE tc_ibb_file.tc_ibb05,
               tc_ibb07   LIKE tc_ibb_file.tc_ibb07
                     END RECORD

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ABA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   #LET tm.wc    = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
   
   CALL i103_tm(0,0) 
   CALL cl_ui_init()
   CALL i103_menu()

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN

FUNCTION i103_tm(p_row,p_col)

   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE lc_qbe_sn       LIKE gbm_file.gbm01
   DEFINE l_ima02         LIKE ima_file.ima02
   DEFINE l_ima920        LIKE ima_file.ima920
   DEFINE l_n,l_i         LIKE type_file.num5

   OPEN WINDOW i103_w AT p_row,p_col WITH FORM "aba/42f/abai102"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CLEAR FORM
   CALL cl_opmsg('p')
   INITIALIZE g_tm.* TO NULL
   CALL g_tc_ibb.clear()
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET g_rec_b=0
   CALL cl_set_comp_visible("tc_ibb22,tc_ibb22_n",FALSE)
   
   DIALOG ATTRIBUTE(UNBUFFERED)


      INPUT BY NAME 
                   g_tm.tc_ibb03,g_tm.tc_ibb04,g_tm.tc_ibb10
                   #WITHOUT DEFAULTS
      
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD tc_ibb03
         IF NOT cl_null(g_tm.tc_ibb03) THEN
            SELECT COUNT(*) INTO l_n FROM sfu_file WHERE sfu01 = g_tm.tc_ibb03
            IF l_n = 0 THEN
               CALL cl_err('','单号不存在！',0)
               NEXT FIELD tc_ibb03
            ELSE
            END IF
         ELSE
            CALL cl_err('','单号不可为空！',0)
            NEXT FIELD ima01
         END IF
         
      AFTER FIELD tc_ibb04 
         IF NOT cl_null(g_tm.tc_ibb04) AND NOT cl_null(g_tm.tc_ibb03) THEN
            SELECT COUNT(*) INTO l_n FROM sfv_file WHERE sfv01 = g_tm.tc_ibb03 
            AND sfv03=g_tm.tc_ibb04
            IF l_n = 0 THEN
               CALL cl_err('','单号项次不匹配！',0)
               NEXT FIELD ibb01
            ELSE
               SELECT sfv04,sfv09 INTO g_tm.tc_ibb06,g_tm.tc_ibb07 
               FROM sfv_file WHERE sfv01 = g_tm.tc_ibb03 
                  AND sfv03=g_tm.tc_ibb04
               SELECT ima02,ima021,imaud11 INTO g_tm.ima02,g_tm.ima021,g_tm.tc_ibb10 FROM ima_file
               WHERE ima01=g_tm.tc_ibb06
               IF cl_null(g_tm.tc_ibb10) THEN 
               	  LET g_tm.tc_ibb10=1
               END IF 

               DISPLAY BY NAME g_tm.tc_ibb06,g_tm.tc_ibb07,
                               g_tm.tc_ibb10,g_tm.ima02,
                               g_tm.ima021

            END IF
         END IF

     ON ACTION controlp
         CASE
            WHEN INFIELD(tc_ibb03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfu"
               LET g_qryparam.default1 = g_tm.tc_ibb03
               CALL cl_create_qry() RETURNING g_tm.tc_ibb03
               DISPLAY BY NAME g_tm.tc_ibb03
               NEXT FIELD tc_ibb03

            OTHERWISE 
               EXIT CASE
         END CASE


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about      
         CALL cl_about()
         EXIT DIALOG   
 
      ON ACTION help   
         CALL cl_show_help() 
         EXIT DIALOG  



      END INPUT


   
     INPUT ARRAY g_tc_ibb  FROM s_tc_ibb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,
                    APPEND ROW=FALSE)
      BEFORE INPUT
#####产生单身数据-------------
         SELECT ceil(g_tm.tc_ibb07/g_tm.tc_ibb10) INTO l_n FROM dual
         FOR l_i=1 TO l_n
            LET g_tc_ibb[l_i].tc_ibb06=g_tm.tc_ibb06
            SELECT ima02,ima021,ima25 INTO g_tc_ibb[l_i].ima02,g_tc_ibb[l_i].ima021,g_tc_ibb[l_i].ima25
            FROM ima_file
            WHERE ima01=g_tc_ibb[l_i].tc_ibb06
            LET g_tc_ibb[l_i].tc_ibb05=l_i
            LET g_rec_b=g_rec_b+1
         END FOR 
#####产生单身数据-------------
      DISPLAY "BEFORE INPUT!"
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
      BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_n  = ARR_COUNT()

      BEGIN WORK
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_ibb_t.* = g_tc_ibb[l_ac].*  #BACKUP
              CALL cl_show_fld_cont()
           END IF
      
      AFTER FIELD tc_ibb21
         IF cl_null(g_tc_ibb[l_ac].tc_ibb21) THEN 
            CALL cl_err('批次日期不可为空','!',0)	
            NEXT FIELD tc_ibb21
         END IF 
      
      AFTER FIELD tc_ibb07_1
         IF l_ac>1 THEN 
         IF cl_null(g_tc_ibb[l_ac-1].tc_ibb07) AND NOT cl_null(g_tc_ibb[l_ac].tc_ibb07) THEN 
            CALL cl_err('请先录入小序号的数量','!',0)
            LET g_tc_ibb[l_ac].tc_ibb07=''
            DISPLAY BY NAME g_tc_ibb[l_ac].tc_ibb07
            NEXT FIELD tc_ibb07
         END IF 
         END IF 		
       
      AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_ibb[l_ac].* = g_tc_ibb_t.*
              END IF
              ROLLBACK WORK
              EXIT DIALOG
           END IF
    
       COMMIT WORK 
       

       END INPUT


      ON ACTION controls  
         CALL cl_set_head_visible("","AUTO")
  
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION ACCEPT
#         IF g_tm.ibb17 IS NULL THEN
#            CONTINUE DIALOG
#         ELSE
            ACCEPT DIALOG
#         END IF

      ON ACTION CANCEL
         EXIT DIALOG
    END DIALOG
    
END FUNCTION

FUNCTION i103_menu()
    DEFINE l_cmd    STRING 

    MENU ""
        BEFORE MENU
           MESSAGE ""
           CALL cl_navigator_setting(g_curs_index, g_row_count)
        ON ACTION INSERT
           CALL g_tc_ibb.clear()
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i103_tm(0,0)
           END IF

        ON ACTION tmsc
            LET g_action_choice="tmsc"
            IF cl_chk_act_auth() THEN
               CALL i103_generate()
            END IF
        ON ACTION modify
           LET g_action_choice="modify"
           LET g_tm_t.*=g_tm.*
           IF cl_chk_act_auth() THEN
              CALL i103_u()
           END IF
        
        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about      
           CALL cl_about() 
 
        ON ACTION close 
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
#        ON ACTION related_document
#           LET g_action_choice="related_document"
#           IF cl_chk_act_auth() THEN
#              IF g_tm.ima01 IS NOT NULL THEN
#                 LET g_doc.column1 = "ima01"
#                 LET g_doc.value1 = g_tm.ima01
#                 CALL cl_doc()
#              END IF
#           END IF

         &include "qry_string.4gl"
    END MENU
    #CLOSE i103_cs1
END FUNCTION

FUNCTION i103_generate()
   DEFINE l_n1,l_n2    LIKE type_file.num5
   DEFINE l_tc_ibb     RECORD LIKE tc_ibb_file.*
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_date       LIKE tc_ibb_file.tc_ibb01
   DEFINE l_nu         LIKE tc_ibb_file.tc_ibb01
   DEFINE l_tc_ibb01   LIKE tc_ibb_file.tc_ibb01
   DEFINE l_tc_ibb07   LIKE tc_ibb_file.tc_ibb07
   DEFINE l_tc_ibb17   LIKE tc_ibb_file.tc_ibb17
   DEFINE l_success    LIKE type_file.chr1
          
   BEGIN WORK

   IF cl_null(g_tm.tc_ibb03) THEN 
      CALL cl_err('单号不可为空','!',0)
      RETURN 
   END IF 
   
   LET l_success='Y'
   LET l_tc_ibb07=0
   IF g_tm.tc_ibb03 IS NOT NULL THEN
   	  FOR l_i=1 TO g_rec_b
   	     INITIALIZE l_tc_ibb TO NULL
   	     IF cl_null(g_tc_ibb[l_i].tc_ibb07) THEN 
   	     	  CONTINUE FOR 
   	     END IF 
   	     
   	     LET l_date=g_tc_ibb[l_i].tc_ibb21 USING 'yyyymmdd'
   	     SELECT to_char(l_i,'000') INTO l_nu FROM dual
   	  #  LET l_tc_ibb01=g_tc_ibb[l_i].tc_ibb06,'%',l_date,'_',g_tm.tc_ibb22,'%',l_nu
   	  #  LET l_tc_ibb17=l_date,'_',g_tm.tc_ibb22
             IF  cl_null(g_tm.tc_ibb22) THEN
               LET l_tc_ibb01=g_tc_ibb[l_i].tc_ibb06,'%',l_date,'%',l_nu
               LET l_tc_ibb17=l_date
             ELSE
               LET l_tc_ibb01=g_tc_ibb[l_i].tc_ibb06,'%',l_date,'_',g_tm.tc_ibb22,'%',l_nu
               LET l_tc_ibb17=l_date,'_',g_tm.tc_ibb22
             END IF

   	     CALL cl_replace_str(l_tc_ibb01," ","") RETURNING l_tc_ibb01
   	     CALL cl_replace_str(l_tc_ibb17," ","") RETURNING l_tc_ibb17
   	     
   	     LET l_tc_ibb.tc_ibb01=l_tc_ibb01       #条码
   	     LET l_tc_ibb.tc_ibb02='1'              #产生来源，1：收货，2：工单入库，3：销售退货，4：杂收
   	     LET l_tc_ibb.tc_ibb03=g_tm.tc_ibb03
   	     LET l_tc_ibb.tc_ibb04=g_tm.tc_ibb04
   	     LET l_tc_ibb.tc_ibb05=g_tc_ibb[l_i].tc_ibb05
   	     LET l_tc_ibb.tc_ibb06=g_tc_ibb[l_i].tc_ibb06
   	     LET l_tc_ibb.tc_ibb07=g_tc_ibb[l_i].tc_ibb07
   	     LET l_tc_ibb07=l_tc_ibb07+l_tc_ibb.tc_ibb07
   	     LET l_tc_ibb.tc_ibb08=''
   	     LET l_tc_ibb.tc_ibb09=''
   	     LET l_tc_ibb.tc_ibb10=g_tm.tc_ibb10    #最小包装数量
   	     LET l_tc_ibb.tc_ibb11='Y'
   	     LET l_tc_ibb.tc_ibb12=''
   	     LET l_tc_ibb.tc_ibbacti='Y'
   	     LET l_tc_ibb.tc_ibb13=''
   	     LET l_tc_ibb.tc_ibb14=''
   	     LET l_tc_ibb.tc_ibb15=''
   	     LET l_tc_ibb.tc_ibb16=''
   	     LET l_tc_ibb.tc_ibb17=l_tc_ibb17       #批号
   	     LET l_tc_ibb.tc_ibb18=''
   	     LET l_tc_ibb.tc_ibb19=''
   	     LET l_tc_ibb.tc_ibb20=g_today          #生成日期
   	     LET l_tc_ibb.tc_ibb21=g_tc_ibb[l_i].tc_ibb21     #生产收货日期
   	     SELECT sfv11 INTO l_tc_ibb.tc_ibb22 FROM sfv_file 
   	     WHERE sfv01 = g_tm.tc_ibb03 AND sfv03=g_tm.tc_ibb04
#   	     LET l_tc_ibb.tc_ibb22=g_tm.tc_ibb22    #厂商编号（客户编号，工单号）
   	     
   	     INSERT INTO tc_ibb_file VALUES(l_tc_ibb.*)
   	     IF SQLCA.sqlcode THEN
             CALL cl_err('',SQLCA.sqlcode,0)
             LET l_success='N'
             ROLLBACK WORK
             RETURN
         ELSE
#             MESSAGE '条码生成成功！'
             
         END IF
   	          
   	  END FOR 
   	  
   	  IF l_tc_ibb07<>g_tm.tc_ibb07 THEN 
   	     CALL cl_err('单身数量之和不等于单头数量','!',0)
   	     LET l_success='N'
   	     ROLLBACK WORK 
   	     RETURN 
   	  END IF
   	  
   	  IF l_success='Y' THEN 
   	     MESSAGE '条码生成成功！'
   	     COMMIT WORK 	
   	  END IF 	 

   END IF
END FUNCTION

FUNCTION i103_u()
DEFINE l_lock_sw       LIKE type_file.chr1
   DEFINE lc_qbe_sn LIKE gbm_file.gbm01
   DEFINE l_n,l_i         LIKE type_file.num5

   DIALOG ATTRIBUTE(UNBUFFERED)
   INPUT BY NAME 
                   g_tm.tc_ibb03,g_tm.tc_ibb04,g_tm.tc_ibb10 
                   ATTRIBUTE(WITHOUT DEFAULTS = TRUE)
                   #WITHOUT DEFAULTS
      
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      AFTER FIELD tc_ibb03
         IF NOT cl_null(g_tm.tc_ibb03) THEN
            SELECT COUNT(*) INTO l_n FROM sfu_file WHERE sfu01 = g_tm.tc_ibb03
            IF l_n = 0 THEN
               CALL cl_err('','单号不存在！',0)
               NEXT FIELD tc_ibb03
            ELSE
                          

            END IF
         ELSE
            CALL cl_err('','单号不可为空！',0)
            NEXT FIELD ima01
         END IF
         
      AFTER FIELD tc_ibb04 
         IF NOT cl_null(g_tm.tc_ibb04) AND NOT cl_null(g_tm.tc_ibb03) THEN
            SELECT COUNT(*) INTO l_n FROM sfv_file WHERE sfv01 = g_tm.tc_ibb03 
            AND sfv03=g_tm.tc_ibb04
            IF l_n = 0 THEN
               CALL cl_err('','单号项次不匹配！',0)
               NEXT FIELD ibb01
            ELSE
               SELECT sfv04,sfv09 INTO g_tm.tc_ibb06,g_tm.tc_ibb07 
               FROM sfv_file WHERE sfv01 = g_tm.tc_ibb03 
                  AND sfv03=g_tm.tc_ibb04
               SELECT ima02,ima021,imaud11 INTO g_tm.ima02,g_tm.ima021,g_tm.tc_ibb10 FROM ima_file
               WHERE ima01=g_tm.tc_ibb06
               IF cl_null(g_tm.tc_ibb10) THEN 
               	  LET g_tm.tc_ibb10=1
               END IF 

               DISPLAY BY NAME g_tm.tc_ibb06,g_tm.tc_ibb07,
                               g_tm.tc_ibb10,g_tm.ima02,
                               g_tm.ima021

            END IF
         END IF

     ON ACTION controlp
         CASE
            WHEN INFIELD(tc_ibb03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_sfu"
               LET g_qryparam.default1 = g_tm.tc_ibb03
               CALL cl_create_qry() RETURNING g_tm.tc_ibb03
               DISPLAY BY NAME g_tm.tc_ibb03
               NEXT FIELD tc_ibb03

            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about      
         CALL cl_about()
         EXIT DIALOG   
 
      ON ACTION help   
         CALL cl_show_help() 
         EXIT DIALOG  

      END INPUT
      


     INPUT ARRAY g_tc_ibb  FROM s_tc_ibb.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,WITHOUT DEFAULTS=TRUE,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,
                    APPEND ROW=FALSE)
      BEFORE INPUT
      IF cl_null(g_tc_ibb[1].tc_ibb06) THEN 
#####产生单身数据-------------
         SELECT ceil(g_tm.tc_ibb07/g_tm.tc_ibb10) INTO l_n FROM dual
         FOR l_i=1 TO l_n
            LET g_tc_ibb[l_i].tc_ibb06=g_tm.tc_ibb06
            SELECT ima02,ima021,ima25 INTO g_tc_ibb[l_i].ima02,g_tc_ibb[l_i].ima021,g_tc_ibb[l_i].ima25
            FROM ima_file
            WHERE ima01=g_tc_ibb[l_i].tc_ibb06
            LET g_tc_ibb[l_i].tc_ibb05=l_i
            LET g_rec_b=g_rec_b+1
         END FOR 
#####产生单身数据-------------
      
      END IF 
      DISPLAY "BEFORE INPUT!"
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
      BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_n  = ARR_COUNT()

      BEGIN WORK
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tc_ibb_t.* = g_tc_ibb[l_ac].*  #BACKUP
              CALL cl_show_fld_cont()
           END IF
      
      AFTER FIELD tc_ibb21
         IF cl_null(g_tc_ibb[l_ac].tc_ibb21) THEN 
            CALL cl_err('批次日期不可为空','!',0)	
            NEXT FIELD tc_ibb21
         END IF 
      
      AFTER FIELD tc_ibb07_1
         IF l_ac>1 THEN 
         IF l_ac>1 AND cl_null(g_tc_ibb[l_ac-1].tc_ibb07) AND NOT cl_null(g_tc_ibb[l_ac].tc_ibb07) THEN 
            CALL cl_err('请先录入小序号的数量','!',0)
            LET g_tc_ibb[l_ac].tc_ibb07=''
            DISPLAY BY NAME g_tc_ibb[l_ac].tc_ibb07
            NEXT FIELD tc_ibb07
         END IF 	
         END IF 	
       
      AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tc_ibb[l_ac].* = g_tc_ibb_t.*
              END IF
              ROLLBACK WORK
              EXIT DIALOG
           END IF
    
       COMMIT WORK 
       END INPUT


      ON ACTION controls  
         CALL cl_set_head_visible("","AUTO")
  
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION ACCEPT
#         IF g_tm.ibb17 IS NULL THEN
#            CONTINUE DIALOG
#         ELSE
            ACCEPT DIALOG
#         END IF

      ON ACTION CANCEL
         EXIT DIALOG
    END DIALOG

END FUNCTION
