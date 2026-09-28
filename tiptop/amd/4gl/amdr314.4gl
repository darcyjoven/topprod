# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: amdr314.4gl
# Descriptions...: 營業人使用二聯式收銀機發票明細表
# Input parameter:
# Return code....:
# Date & Author..: No.FUN-B90079 11/09/13 by huangtao
# Modify.........: No.FUN-B90115 11/10/18 By huangtao 修正報表相關


DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE tm  RECORD                          
           amd22     STRING,
           amd173    LIKE amd_file.amd173,
           amd174b   LIKE amd_file.amd174,
           amd174e   LIKE amd_file.amd174,  
           more      LIKE type_file.chr1     #Input more condition(Y/N)
           END RECORD
DEFINE g_wc          STRING 
DEFINE g_str         STRING                 
DEFINE g_sql         STRING                
DEFINE l_table       STRING
DEFINE g_amd22       LIKE amd_file.amd22
DEFINE g_amd22_str   STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT 

   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.amd22 = ARG_VAL(7)
   LET tm.amd173 = ARG_VAL(8)
   LET tm.amd174b = ARG_VAL(9)
   LET tm.amd174e = ARG_VAL(10)
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   LET g_sql=  "amd26.amd_file.amd26,","amd27.amd_file.amd27,",
               "amd22.amd_file.amd22,","ama02.ama_file.ama02,",
               "ama07.ama_file.ama07,","ama03.ama_file.ama03,",
               "amd126.amd_file.amd126,","zigui.type_file.chr2,",
               "l_str_1.type_file.chr1000,","l_sum_1.type_file.num20_6,",
               "l_sum1_1.type_file.num20_6,","l_str1_1.type_file.chr1000,",
               "l_str_2.type_file.chr1000,","l_sum_2.type_file.num20_6,",
               "l_sum1_2.type_file.num20_6,","l_str1_2.type_file.chr1000,",
               "l_str_3.type_file.chr1000,","l_sum_3.type_file.num20_6,",
               "l_sum1_3.type_file.num20_6,","l_str1_3.type_file.chr1000,",
               "l_str_4.type_file.chr1000,","l_sum_4.type_file.num20_6,",
               "l_sum1_4.type_file.num20_6,","l_str1_4.type_file.chr1000,",
               "l_str_5.type_file.chr1000,","l_sum_5.type_file.num20_6,",
               "l_sum1_5.type_file.num20_6,","l_str1_5.type_file.chr1000,",
               "l_str_6.type_file.chr1000,","l_sum_6.type_file.num20_6,",
               "l_sum1_6.type_file.num20_6,","l_str1_6.type_file.chr1000,",
               "l_str_7.type_file.chr1000,","l_sum_7.type_file.num20_6,",
               "l_sum1_7.type_file.num20_6,","l_str1_7.type_file.chr1000,",
               "l_str_8.type_file.chr1000,","l_sum_8.type_file.num20_6,",
               "l_sum1_8.type_file.num20_6,","l_str1_8.type_file.chr1000,",
               "l_str_9.type_file.chr1000,","l_sum_9.type_file.num20_6,",
               "l_sum1_9.type_file.num20_6,","l_str1_9.type_file.chr1000,",
               "l_str_10.type_file.chr1000,","l_sum_10.type_file.num20_6,",
               "l_sum1_10.type_file.num20_6,","l_str1_10.type_file.chr1000,",
               "l_str_11.type_file.chr1000,","l_sum_11.type_file.num20_6,",
               "l_sum1_11.type_file.num20_6,","l_str1_11.type_file.chr1000,",
               "l_str_12.type_file.chr1000,","l_sum_12.type_file.num20_6,",
               "l_sum1_12.type_file.num20_6,","l_str1_12.type_file.chr1000,",
               "l_str_13.type_file.chr1000,","l_sum_13.type_file.num20_6,",
               "l_sum1_13.type_file.num20_6,","l_str1_13.type_file.chr1000,",
               "l_str_14.type_file.chr1000,","l_sum_14.type_file.num20_6,",
               "l_sum1_14.type_file.num20_6,","l_str1_14.type_file.chr1000,",
               "l_str_15.type_file.chr1000,","l_sum_15.type_file.num20_6,",
               "l_sum1_15.type_file.num20_6,","l_str1_15.type_file.chr1000,",
               "l_str_16.type_file.chr1000,","l_sum_16.type_file.num20_6,",
               "l_sum1_16.type_file.num20_6,","l_str1_16.type_file.chr1000,",
               "l_str_17.type_file.chr1000,","l_sum_17.type_file.num20_6,",
               "l_sum1_17.type_file.num20_6,","l_str1_17.type_file.chr1000,",
               "l_str_18.type_file.chr1000,","l_sum_18.type_file.num20_6,",
               "l_sum1_18.type_file.num20_6,","l_str1_18.type_file.chr1000,",
               "l_str_19.type_file.chr1000,","l_sum_19.type_file.num20_6,",
               "l_sum1_19.type_file.num20_6,","l_str1_19.type_file.chr1000,",
               "l_str_20.type_file.chr1000,","l_sum_20.type_file.num20_6,",
               "l_sum1_20.type_file.num20_6,","l_str1_20.type_file.chr1000,",
               "l_str_21.type_file.chr1000,","l_sum_21.type_file.num20_6,",
               "l_sum1_21.type_file.num20_6,","l_str1_21.type_file.chr1000,",
               "l_str_22.type_file.chr1000,","l_sum_22.type_file.num20_6,",
               "l_sum1_22.type_file.num20_6,","l_str1_22.type_file.chr1000,",
               "l_str_23.type_file.chr1000,","l_sum_23.type_file.num20_6,",
               "l_sum1_23.type_file.num20_6,","l_str1_23.type_file.chr1000,",
               "l_str_24.type_file.chr1000,","l_sum_24.type_file.num20_6,",
               "l_sum1_24.type_file.num20_6,","l_str1_24.type_file.chr1000,",
               "l_str_25.type_file.chr1000,","l_sum_25.type_file.num20_6,",
               "l_sum1_25.type_file.num20_6,","l_str1_25.type_file.chr1000,",
               "l_str_26.type_file.chr1000,","l_sum_26.type_file.num20_6,",
               "l_sum1_26.type_file.num20_6,","l_str1_26.type_file.chr1000,",
               "l_str_27.type_file.chr1000,","l_sum_27.type_file.num20_6,",
               "l_sum1_27.type_file.num20_6,","l_str1_27.type_file.chr1000,",
               "l_str_28.type_file.chr1000,","l_sum_28.type_file.num20_6,",
               "l_sum1_28.type_file.num20_6,","l_str1_28.type_file.chr1000,",
               "l_str_29.type_file.chr1000,","l_sum_29.type_file.num20_6,",
               "l_sum1_29.type_file.num20_6,","l_str1_29.type_file.chr1000,",
               "l_str_30.type_file.chr1000,","l_sum_30.type_file.num20_6,",
               "l_sum1_30.type_file.num20_6,","l_str1_30.type_file.chr1000,",
               "l_str_31.type_file.chr1000,","l_sum_31.type_file.num20_6,",
               "l_sum1_31.type_file.num20_6,","l_str1_31.type_file.chr1000,",
               "l_sum_amd06.type_file.num20_6,","l_sum_amd08.type_file.num20_6,",
               "l_sum_amd07.type_file.num20_6,","l_sum_amd08_1.type_file.num20_6,",
               "l_sum1_amd06.type_file.num20_6,","l_sum1_amd08.type_file.num20_6,",
               "l_sum1_amd07.type_file.num20_6,","l_sum1_amd08_1.type_file.num20_6,",
               "l_cnt1.type_file.num5,","l_kb1.type_file.chr1000,","l_kb2.type_file.chr1000,",
               "l_i.type_file.num5"
               
               
               
    LET l_table = cl_prt_temptable('amdr314',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
              "        ?,?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN 
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF         

    IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
       CALL amdr314_tm()        # Input print condition
    ELSE 
       CALL amdr314() 
    END IF
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION amdr314_tm()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01     
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          STRING,   
       l_cmd1         LIKE type_file.chr1000
DEFINE tok            base.StringTokenizer 
DEFINE  l_n           LIKE type_file.num5
DEFINE  l_n1           LIKE type_file.num5
DEFINE l_sql          STRING


   LET p_row = 6 LET p_col = 16
   OPEN WINDOW amdr314_w AT p_row,p_col WITH FORM "amd/42f/amdr314" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm.amd173 = YEAR(g_today)
   LET tm.amd174b = MONTH(g_today) 
   LET tm.amd174e = MONTH(g_today) 
 
   WHILE TRUE
      INPUT BY NAME  tm.amd22,tm.amd173,tm.amd174b,tm.amd174e,tm.more WITHOUT DEFAULTS 
         BEFORE INPUT 
           CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD amd22
            IF NOT cl_null(tm.amd22) AND tm.amd22 <> "*" THEN
               LET tok = base.StringTokenizer.create(tm.amd22,"|") 
               LET g_amd22 = ""
               WHILE tok.hasMoreTokens() 
                   LET g_amd22 = tok.nextToken()
                   IF g_amd22_str IS NULL THEN
                      LET g_amd22_str = "'",g_amd22,"'"
                   ELSE
                      LET g_amd22_str = g_amd22_str,",'",g_amd22,"'"
                   END IF 
               END WHILE
               IF g_amd22_str IS NOT NULL THEN
                  LET g_amd22_str = "(",g_amd22_str,")"
               END IF
            END IF
            
        AFTER FIELD amd174b,amd174e
            IF NOT cl_null(tm.amd174b) OR NOT cl_null(tm.amd174e) THEN
               IF tm.amd174b <1 OR tm.amd174b > 12 OR tm.amd174e <1 OR tm.amd174e >12 THEN
                  CALL cl_err('','art-837',0)
                  NEXT FIELD CURRENT
               END IF 
            END IF

         ON ACTION controlp
            CASE
               WHEN INFIELD(amd22)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ama"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tm.amd22 = g_qryparam.multiret
                  DISPLAY tm.amd22 TO amd22
                  NEXT FIELD amd22
            END CASE
            
         ON ACTION CONTROLR
             CALL cl_show_req_fields()
         ON ACTION CONTROLG CALL cl_cmdask()    # Command execution

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT


         ON ACTION locale
            CALL cl_show_fld_cont()                 
            LET g_action_choice = "locale"
            EXIT INPUT
    
         ON ACTION about        
            CALL cl_about()     
 
         ON ACTION help         
            CALL cl_show_help()  
 
 
         ON ACTION EXIT
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW amdr314_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF 


      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF

      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd1 FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='amdr314'
         IF SQLCA.sqlcode OR l_cmd1 IS NULL THEN
            CALL cl_err('amdr314','9031',1)
         ELSE
            LET l_cmd = l_cmd1 CLIPPED,       
                       " '",g_pdate CLIPPED,"'",
                       " '",g_towhom CLIPPED,"'",
                       " '",g_rlang CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'",
                       " '",g_prtway CLIPPED,"'",
                       " '",g_copies CLIPPED,"'",
                       " '",tm.amd22 CLIPPED,"'",
                       " '",tm.amd173 CLIPPED,"'",
                       " '",tm.amd174b CLIPPED,"'",
                       " '",tm.amd174e CLIPPED,"'",
                       " '",g_rep_user CLIPPED,"'",           
                       " '",g_rep_clas CLIPPED,"'",           
                       " '",g_template CLIPPED,"'",           
                       " '",g_rpt_name CLIPPED,"'"            
            CALL cl_cmdat('amdr314',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW amdr314_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL amdr314()
      ERROR ""
   END WHILE
   CLOSE WINDOW amdr314_w
    
END FUNCTION


FUNCTION amdr314() 
DEFINE    l_name    LIKE type_file.chr20,                
          l_sql     STRING ,   
          sr        RECORD
                    amd173 LIKE amd_file.amd173,
                    amd174  LIKE amd_file.amd174,
                    amd22  LIKE amd_file.amd22,
                    ama02  LIKE ama_file.ama02,
                    ama07  LIKE ama_file.ama07,
                    ama03  LIKE ama_file.ama03,
                    amd126 LIKE amd_file.amd126,
                    zigui  LIKE type_file.chr2
                    END RECORD,          
          sr1        RECORD 
                    amd173  LIKE amd_file.amd173,
                    amd174  LIKE amd_file.amd174,
                    amd22  LIKE amd_file.amd22,
                    ama02  LIKE ama_file.ama02,
                    ama07  LIKE ama_file.ama07,
                    ama03  LIKE ama_file.ama03,
                    amd126 LIKE amd_file.amd126,
                    zigui  LIKE type_file.chr2,
                    amd05  LIKE amd_file.amd05,
                    l_day  LIKE type_file.num5
                    END RECORD
               
DEFINE    l_amd     STRING
DEFINE    l_str     STRING
DEFINE    l_str1    STRING
DEFINE    l_s       STRING
DEFINE    l_s1      STRING
DEFINE    l_n       LIKE type_file.num5
DEFINE    l_amd03   LIKE amd_file.amd03
DEFINE    l_amd032  LIKE amd_file.amd032
DEFINE    l_amd09   LIKE amd_file.amd09
DEFINE    l_sum     LIKE type_file.num20_6
DEFINE    l_sum1    LIKE type_file.num20_6
DEFINE    l_sum_amd06 LIKE type_file.num20_6
DEFINE    l_sum_amd08 LIKE type_file.num20_6
DEFINE    l_sum_amd07 LIKE type_file.num20_6
DEFINE    l_sum_amd08_1 LIKE type_file.num20_6
DEFINE    l_sum1_amd06 LIKE type_file.num20_6
DEFINE    l_sum1_amd08 LIKE type_file.num20_6
DEFINE    l_sum1_amd07 LIKE type_file.num20_6
DEFINE    l_sum1_amd08_1 LIKE type_file.num20_6
DEFINE    l_cnt     LIKE type_file.num5
DEFINE    l_cnt1    LIKE type_file.num5
DEFINE    l_count   LIKE type_file.num5 
DEFINE    l_max    LIKE type_file.chr1000
DEFINE    l_kb1    LIKE type_file.chr1000 
DEFINE    l_kb2    LIKE type_file.chr1000 
DEFINE    l_kb1_s      STRING    
DEFINE    l_kb1_str    STRING
DEFINE    l_kb2_str    STRING
DEFINE    ls_format    STRING
DEFINE    l_i      LIKE type_file.num5


DEFINE    l_str_1   LIKE type_file.chr1000 ,l_sum_1 LIKE type_file.num20_6 ,
          l_str1_1  LIKE type_file.chr1000 ,l_sum1_1 LIKE type_file.num20_6 ,
          l_str_2   LIKE type_file.chr1000 ,l_sum_2 LIKE type_file.num20_6 ,
          l_str1_2  LIKE type_file.chr1000 ,l_sum1_2 LIKE type_file.num20_6 ,
          l_str_3   LIKE type_file.chr1000 ,l_sum_3 LIKE type_file.num20_6 ,
          l_str1_3  LIKE type_file.chr1000,l_sum1_3 LIKE type_file.num20_6 ,
          l_str_4   LIKE type_file.chr1000 ,l_sum_4 LIKE type_file.num20_6 ,
          l_str1_4  LIKE type_file.chr1000 ,l_sum1_4 LIKE type_file.num20_6 ,
          l_str_5   LIKE type_file.chr1000,l_sum_5 LIKE type_file.num20_6 ,
          l_str1_5  LIKE type_file.chr1000 ,l_sum1_5 LIKE type_file.num20_6 ,
          l_str_6   LIKE type_file.chr1000 ,l_sum_6 LIKE type_file.num20_6 ,
          l_str1_6  LIKE type_file.chr1000 ,l_sum1_6 LIKE type_file.num20_6 ,
          l_str_7   LIKE type_file.chr1000 ,l_sum_7 LIKE type_file.num20_6 ,
          l_str1_7  LIKE type_file.chr1000 ,l_sum1_7 LIKE type_file.num20_6 ,
          l_str_8   LIKE type_file.chr1000 ,l_sum_8 LIKE type_file.num20_6 ,
          l_str1_8  LIKE type_file.chr1000 ,l_sum1_8 LIKE type_file.num20_6 ,
          l_str_9   LIKE type_file.chr1000 ,l_sum_9 LIKE type_file.num20_6 ,
          l_str1_9  LIKE type_file.chr1000 ,l_sum1_9 LIKE type_file.num20_6 ,
          l_str_10  LIKE type_file.chr1000 ,l_sum_10 LIKE type_file.num20_6 ,
          l_str1_10  LIKE type_file.chr1000,l_sum1_10 LIKE type_file.num20_6 ,
          l_str_11   LIKE type_file.chr1000,l_sum_11 LIKE type_file.num20_6 ,
          l_str1_11  LIKE type_file.chr1000 ,l_sum1_11 LIKE type_file.num20_6 ,
          l_str_12   LIKE type_file.chr1000,l_sum_12 LIKE type_file.num20_6 ,
          l_str1_12  LIKE type_file.chr1000 ,l_sum1_12 LIKE type_file.num20_6 ,
          l_str_13   LIKE type_file.chr1000 ,l_sum_13 LIKE type_file.num20_6 ,
          l_str1_13  LIKE type_file.chr1000 ,l_sum1_13 LIKE type_file.num20_6 ,
          l_str_14   LIKE type_file.chr1000 ,l_sum_14 LIKE type_file.num20_6 ,
          l_str1_14  LIKE type_file.chr1000 ,l_sum1_14 LIKE type_file.num20_6 ,
          l_str_15   LIKE type_file.chr1000 ,l_sum_15 LIKE type_file.num20_6 ,
          l_str1_15  LIKE type_file.chr1000 ,l_sum1_15 LIKE type_file.num20_6 ,
          l_str_16   LIKE type_file.chr1000 ,l_sum_16 LIKE type_file.num20_6 ,
          l_str1_16  LIKE type_file.chr1000 ,l_sum1_16 LIKE type_file.num20_6 ,
          l_str_17   LIKE type_file.chr1000 ,l_sum_17 LIKE type_file.num20_6 ,
          l_str1_17  LIKE type_file.chr1000 ,l_sum1_17 LIKE type_file.num20_6 ,
          l_str_18   LIKE type_file.chr1000,l_sum_18 LIKE type_file.num20_6 ,
          l_str1_18  LIKE type_file.chr1000 ,l_sum1_18 LIKE type_file.num20_6 ,
          l_str_19   LIKE type_file.chr1000 ,l_sum_19 LIKE type_file.num20_6 ,
          l_str1_19  LIKE type_file.chr1000 ,l_sum1_19 LIKE type_file.num20_6 ,
          l_str_20   LIKE type_file.chr1000 ,l_sum_20 LIKE type_file.num20_6 ,
          l_str1_20  LIKE type_file.chr1000,l_sum1_20 LIKE type_file.num20_6 ,
          l_str_21   LIKE type_file.chr1000 ,l_sum_21 LIKE type_file.num20_6 ,
          l_str1_21  LIKE type_file.chr1000 ,l_sum1_21 LIKE type_file.num20_6 ,
          l_str_22   LIKE type_file.chr1000 ,l_sum_22 LIKE type_file.num20_6 ,
          l_str1_22  LIKE type_file.chr1000 ,l_sum1_22 LIKE type_file.num20_6 ,
          l_str_23   LIKE type_file.chr1000 ,l_sum_23 LIKE type_file.num20_6 ,
          l_str1_23  LIKE type_file.chr1000,l_sum1_23 LIKE type_file.num20_6 ,
          l_str_24   LIKE type_file.chr1000 ,l_sum_24 LIKE type_file.num20_6 ,
          l_str1_24  LIKE type_file.chr1000 ,l_sum1_24 LIKE type_file.num20_6 ,
          l_str_25   LIKE type_file.chr1000 ,l_sum_25 LIKE type_file.num20_6 ,
          l_str1_25  LIKE type_file.chr1000 ,l_sum1_25 LIKE type_file.num20_6 ,
          l_str_26   LIKE type_file.chr1000 ,l_sum_26 LIKE type_file.num20_6 ,
          l_str1_26  LIKE type_file.chr1000 ,l_sum1_26 LIKE type_file.num20_6 ,
          l_str_27   LIKE type_file.chr1000 ,l_sum_27 LIKE type_file.num20_6 ,
          l_str1_27  LIKE type_file.chr1000 ,l_sum1_27 LIKE type_file.num20_6 ,
          l_str_28   LIKE type_file.chr1000 ,l_sum_28 LIKE type_file.num20_6 ,
          l_str1_28  LIKE type_file.chr1000,l_sum1_28 LIKE type_file.num20_6 ,
          l_str_29   LIKE type_file.chr1000,l_sum_29 LIKE type_file.num20_6 ,
          l_str1_29  LIKE type_file.chr1000 ,l_sum1_29 LIKE type_file.num20_6 ,
          l_str_30   LIKE type_file.chr1000,l_sum_30 LIKE type_file.num20_6 ,
          l_str1_30  LIKE type_file.chr1000 ,l_sum1_30 LIKE type_file.num20_6 ,
          l_str_31   LIKE type_file.chr1000,l_sum_31 LIKE type_file.num20_6 ,
          l_str1_31  LIKE type_file.chr1000,l_sum1_31 LIKE type_file.num20_6 
      
                    
    INITIALIZE sr.* TO NULL
             
    LET l_sql = " SELECT amd173,amd174,amd22,ama02,ama07,ama03,amd126,SUBSTR(amd03, 1, 2)",
                " FROM amd_file",
                " INNER JOIN ama_file ON amd22 = ama01 ",
                " WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' ",
                " AND amd22 in ",g_amd22_str,
                " AND amd173 = '",tm.amd173,"'",
                " AND amd174 BETWEEN '",tm.amd174b,"' AND '",tm.amd174e,"'",
                " AND amd30 = 'Y' ",
                " GROUP BY amd173,amd174,amd22,ama02,ama07,ama03,amd126,SUBSTR(amd03, 1, 2)"
             
    PREPARE sel_amd_pre FROM l_sql
    DECLARE sel_amd_curs CURSOR FOR sel_amd_pre
    FOREACH sel_amd_curs INTO sr.*
       LET l_cnt1 = 0 
       LET l_sql = " SELECT amd173,amd174,amd22,ama02,ama07,ama03,amd126,SUBSTR(amd03, 1, 2),",
                   " amd05,DAY(amd05)",
                   " FROM amd_file",
                   " INNER JOIN ama_file ON amd22 = ama01 ",
                   " WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' ",
                   " AND amd173 = '",sr.amd173,"' AND amd174= '",sr.amd174,"'",
                   " AND amd22 = '",sr.amd22,"' AND amd126 = '",sr.amd126,"'",
                   " AND SUBSTR(amd03, 1, 2) = '",sr.zigui,"'",
                   " GROUP BY amd173,amd174,amd22,ama02,ama07,ama03,amd126,SUBSTR(amd03, 1, 2),",
                   " amd05,DAY(amd05)",
                   " ORDER BY amd22,amd126, SUBSTR(amd03, 1, 2),amd05"
       PREPARE sel_amd_pre1 FROM l_sql
       DECLARE sel_amd_curs1 CURSOR FOR sel_amd_pre1
       FOREACH sel_amd_curs1 INTO sr1.*           
                 
           DECLARE sel_str_curs CURSOR FOR
            SELECT DISTINCT amd03,amd032,amd09 FROM amd_file 
             WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
               AND amd22 = sr1.amd22 AND amd173 = tm.amd173 AND amd126 = sr1.amd126
               AND amd05 = sr1.amd05 AND SUBSTR(amd03, 1, 2) = sr1.zigui
               AND amd174 = sr1.amd174
               AND amd172 <> 'D' AND amd172 <> 'F' AND amd30 = 'Y'
           LET l_str = ''
           FOREACH  sel_str_curs  INTO l_amd03,l_amd032,l_amd09
              LET l_amd = ''
              LET l_s = l_amd03
              LET l_s = l_s.subString(3,l_s.getLength())
              LET l_s1 = l_amd032
              LET l_s1 = l_s1.subString(3,l_s1.getLength())
              IF l_amd09 = 'A' THEN
                 LET l_amd = l_s,"~",l_s1
                 LET l_max = l_s1
              ELSE 
                 LET l_amd = l_s
                 LET l_max = l_s
              END IF
              
              IF NOT cl_null(l_str) THEN
                 LET l_str = l_str,",",l_amd
              ELSE
                 LET l_str = l_amd
              END IF
            END FOREACH
            IF NOT cl_null(l_max) THEN 
               LET l_max = sr1.zigui,l_max
               SELECT oom09,oom08 INTO l_kb1,l_kb2 FROM oom_file
                WHERE oom07 <= l_max AND oom08> = l_max
                  AND ( oom08 <> oom09 OR oom09 IS NULL OR oom09 = ' ')
      
               IF STATUS <> 100 THEN
                  IF cl_null(l_kb1) AND NOT cl_null(l_kb2) THEN
                     LET l_kb1_str = sr1.zigui,"00000000000000000000000000000000000"
                     LET l_kb2_str = l_kb2
                     LET l_kb1 = l_kb1_str.subString(1,l_kb2_str.getLength()-1),"1"
      #FUN-B90115  ---------------STA  
                  ELSE
                     IF NOT cl_null(l_kb1) AND NOT cl_null(l_kb2) THEN 
                        LET l_kb1_s = l_kb1
                        LET l_kb1_s = l_kb1_s.subString(3,l_kb1_s.getLength())
                        LET l_kb2_str = l_kb2
                        LET ls_format = ''
                        FOR l_count = 1 TO l_kb1_s.getLength()
                           LET ls_format = ls_format,"&"
                        END FOR
                        LET l_kb1 = (l_kb1_s+1) USING ls_format
                        LET l_kb1 = sr1.zigui,l_kb1
                     END IF   
      #FUN-B90115  ----------------END
                  END IF
               END IF
               LET l_kb1_str = l_kb1
               LET l_i =l_kb2_str.subString(3,l_kb2_str.getLength()) - l_kb1_str.subString(3,l_kb1_str.getLength()) +1
            END IF
          SELECT SUM(amd06) INTO l_sum FROM amd_file
           WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
             AND amd22 = sr1.amd22 AND amd173 = tm.amd173 AND amd126 = sr1.amd126
             AND amd05 = sr1.amd05 AND SUBSTR(amd03, 1, 2) = sr.zigui
             AND (amd172 = '1' OR amd172 = '2') AND amd30 = 'Y'
          SELECT SUM(amd06) INTO l_sum1 FROM amd_file
           WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
             AND amd22 = sr1.amd22 AND amd173 = tm.amd173 AND amd126 = sr1.amd126
             AND amd05 = sr1.amd05 AND SUBSTR(amd03, 1, 2) = sr1.zigui
             AND amd172 = '3'  AND amd30 = 'Y' 
#本表合計
          SELECT SUM(amd06),SUM(amd08),SUM(amd07) INTO l_sum_amd06,l_sum_amd08,l_sum_amd07 FROM amd_file
            WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
             AND amd22 = sr1.amd22 AND amd173 = tm.amd173 AND amd126 = sr1.amd126
             AND SUBSTR(amd03, 1, 2) = sr1.zigui
             AND (amd172 = '1' OR amd172 = '2') AND amd30 = 'Y'
         SELECT SUM(amd08) INTO l_sum_amd08_1 FROM amd_file
            WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
             AND amd22 = sr1.amd22 AND amd173 = tm.amd173 AND amd126 = sr1.amd126
             AND SUBSTR(amd03, 1, 2) = sr1.zigui
             AND amd172 = '3' AND amd30 = 'Y'
#本表合計   

#本月合計
        SELECT SUM(amd06),SUM(amd08),SUM(amd07) INTO l_sum1_amd06,l_sum1_amd08,l_sum1_amd07 FROM amd_file
            WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
             AND amd22 = sr1.amd22 AND amd173 = tm.amd173 
             AND (amd172 = '1' OR amd172 = '2') AND amd30 = 'Y'
         SELECT SUM(amd08) INTO l_sum1_amd08_1 FROM amd_file
            WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
             AND amd22 = sr1.amd22 AND amd173 = tm.amd173 AND amd126 = sr1.amd126
             AND SUBSTR(amd03, 1, 2) = sr1.zigui
             AND amd172 = '3' AND amd30 = 'Y'
#本月合計
          
         DECLARE sel_str_curs1 CURSOR FOR
          SELECT amd03,amd032,amd09 FROM amd_file 
           WHERE amd021 = '6' AND amd031 = '5' AND amd171 = '32' 
             AND amd22 = sr1.amd22 AND amd173 = tm.amd173 AND amd126 = sr1.amd126
             AND amd05 = sr1.amd05 AND SUBSTR(amd03, 1, 2) = sr1.zigui
             AND amd174 = sr1.amd174
             AND amd172 = 'F' AND amd30 = 'Y'  
         LET l_cnt = 0 
         LET l_str1 = ''
         FOREACH sel_str_curs1 INTO l_amd03,l_amd032,l_amd09
            LET l_s = l_amd03
            LET l_s = l_s.subString(3,l_s.getLength())
            LET l_amd = l_s
            LET l_cnt =1
            LET l_cnt1 = l_cnt+ l_cnt1
            IF NOT cl_null(l_str1) THEN
               LET l_str1 = l_str1,",",l_amd
            ELSE
               LET l_str1 = l_amd
            END IF
         END FOREACH
         CASE sr1.l_day
          WHEN 1
            LET l_str_1 = l_str    LET l_sum_1 = l_sum
            LET l_sum1_1 = l_sum1  LET l_str1_1 = l_str1
          WHEN 2
            LET l_str_2 = l_str LET l_sum_2 = l_sum
            LET l_sum1_2 = l_sum1 LET l_str1_2 = l_str1
          WHEN 3
            LET l_str_3 = l_str LET l_sum_3 = l_sum
            LET l_sum1_3 = l_sum1 LET l_str1_3 = l_str1
          WHEN 4
            LET l_str_4 = l_str LET l_sum_4 = l_sum
            LET l_sum1_4 = l_sum1 LET l_str1_4 = l_str1
          WHEN 5
            LET l_str_5 = l_str LET l_sum_5 = l_sum
            LET l_sum1_5 = l_sum1 LET l_str1_5 = l_str1
          WHEN 6
            LET l_str_6 = l_str LET l_sum_6 = l_sum
            LET l_sum1_6 = l_sum1 LET l_str1_6 = l_str1 
          WHEN 7
            LET l_str_7 = l_str LET l_sum_7 = l_sum
            LET l_sum1_7 = l_sum1 LET l_str1_7 = l_str1
          WHEN 8
            LET l_str_8 = l_str LET l_sum_8 = l_sum
            LET l_sum1_8 = l_sum1 LET l_str1_8 = l_str1 
          WHEN 9
            LET l_str_9 = l_str LET l_sum_9 = l_sum
            LET l_sum1_9 = l_sum1 LET l_str1_9 = l_str1
          WHEN 10
            LET l_str_10 = l_str LET l_sum_10 = l_sum
            LET l_sum1_10 = l_sum1 LET l_str1_10 = l_str1
          WHEN 11
            LET l_str_11 = l_str LET l_sum_11 = l_sum
            LET l_sum1_11 = l_sum1 LET l_str1_11 = l_str1
          WHEN 12
            LET l_str_12 = l_str LET l_sum_12 = l_sum
            LET l_sum1_12 = l_sum1 LET l_str1_12 = l_str1
          WHEN 13
            LET l_str_13 = l_str LET l_sum_13 = l_sum
            LET l_sum1_13 = l_sum1 LET l_str1_13 = l_str1
          WHEN 14
            LET l_str_14 = l_str LET l_sum_14 = l_sum
            LET l_sum1_14 = l_sum1 LET l_str1_14 = l_str1
          WHEN 15
            LET l_str_15 = l_str LET l_sum_15 = l_sum
            LET l_sum1_15 = l_sum1 LET l_str1_15 = l_str1
          WHEN 16
            LET l_str_16 = l_str LET l_sum_16 = l_sum
            LET l_sum1_16 = l_sum1 LET l_str1_16 = l_str1
          WHEN 17
            LET l_str_17 = l_str LET l_sum_17 = l_sum
            LET l_sum1_17 = l_sum1 LET l_str1_17 = l_str1
          WHEN 18
            LET l_str_18 = l_str LET l_sum_18 = l_sum
            LET l_sum1_18 = l_sum1 LET l_str1_18 = l_str1  
          WHEN 19
            LET l_str_19 = l_str LET l_sum_19 = l_sum
            LET l_sum1_19 = l_sum1 LET l_str1_19 = l_str1  
          WHEN 20
            LET l_str_20 = l_str LET l_sum_20 = l_sum
            LET l_sum1_20 = l_sum1 LET l_str1_20 = l_str1
          WHEN 21
            LET l_str_21 = l_str LET l_sum_21 = l_sum
            LET l_sum1_21 = l_sum1 LET l_str1_21 = l_str1
          WHEN 22
            LET l_str_22 = l_str LET l_sum_22 = l_sum
            LET l_sum1_22 = l_sum1 LET l_str1_22 = l_str1
          WHEN 23
            LET l_str_23 = l_str LET l_sum_23 = l_sum
            LET l_sum1_23 = l_sum1 LET l_str1_23 = l_str1
          WHEN 24
            LET l_str_24 = l_str LET l_sum_24 = l_sum
            LET l_sum1_24 = l_sum1 LET l_str1_24 = l_str1
          WHEN 25
            LET l_str_25 = l_str LET l_sum_25 = l_sum
            LET l_sum1_25 = l_sum1 LET l_str1_25 = l_str1  
          WHEN 26
            LET l_str_26 = l_str LET l_sum_26 = l_sum
            LET l_sum1_26 = l_sum1 LET l_str1_26 = l_str1
          WHEN 27
            LET l_str_27 = l_str LET l_sum_27 = l_sum
            LET l_sum1_27 = l_sum1 LET l_str1_27 = l_str1
          WHEN 28
            LET l_str_28 = l_str LET l_sum_28 = l_sum
            LET l_sum1_28 = l_sum1 LET l_str1_28 = l_str1
          WHEN 29
            LET l_str_29 = l_str LET l_sum_29 = l_sum
            LET l_sum1_29 = l_sum1 LET l_str1_29 = l_str1
          WHEN 30
            LET l_str_30 = l_str LET l_sum_30 = l_sum
            LET l_sum1_30 = l_sum1 LET l_str1_30 = l_str1
          WHEN 31
            LET l_str_31 = l_str LET l_sum_31 = l_sum
            LET l_sum1_31 = l_sum1 LET l_str1_31 = l_str1
        END CASE
       END FOREACH      
       
       EXECUTE insert_prep USING sr.*,l_str_1,l_sum_1,l_sum1_1,l_str1_1,
     l_str_2,l_sum_2,l_sum1_2,l_str1_2,l_str_3,l_sum_3,l_sum1_3,l_str1_3,
     l_str_4,l_sum_4,l_sum1_4,l_str1_4,l_str_5,l_sum_5,l_sum1_5,l_str1_5,
     l_str_6,l_sum_6,l_sum1_6,l_str1_6,l_str_7,l_sum_7,l_sum1_7,l_str1_7,
     l_str_8,l_sum_8,l_sum1_8,l_str1_8,l_str_9,l_sum_9,l_sum1_9,l_str1_9,
     l_str_10,l_sum_10,l_sum1_10,l_str1_10,l_str_11,l_sum_11,l_sum1_11,l_str1_11,
     l_str_12,l_sum_12,l_sum1_12,l_str1_12,l_str_13,l_sum_13,l_sum1_13,l_str1_13,
     l_str_14,l_sum_14,l_sum1_14,l_str1_14,l_str_15,l_sum_15,l_sum1_15,l_str1_15,
     l_str_16,l_sum_16,l_sum1_16,l_str1_16,l_str_17,l_sum_17,l_sum1_17,l_str1_17,
     l_str_18,l_sum_18,l_sum1_18,l_str1_18,l_str_19,l_sum_19,l_sum1_19,l_str1_19,
     l_str_20,l_sum_20,l_sum1_20,l_str1_20,l_str_21,l_sum_21,l_sum1_21,l_str1_21, 
     l_str_22,l_sum_22,l_sum1_22,l_str1_22,l_str_23,l_sum_23,l_sum1_23,l_str1_23, 
     l_str_24,l_sum_24,l_sum1_24,l_str1_24,l_str_25,l_sum_25,l_sum1_25,l_str1_25,
     l_str_26,l_sum_26,l_sum1_26,l_str1_26,l_str_27,l_sum_27,l_sum1_27,l_str1_27,
     l_str_28,l_sum_28,l_sum1_28,l_str1_28,l_str_29,l_sum_29,l_sum1_29,l_str1_29,
     l_str_30,l_sum_30,l_sum1_30,l_str1_30,l_str_31,l_sum_31,l_sum1_31,l_str1_31,
     l_sum_amd06,l_sum_amd08,l_sum_amd07,l_sum_amd08_1,
     l_sum1_amd06,l_sum1_amd08,l_sum1_amd07,l_sum1_amd08_1,l_cnt1,l_kb1,l_kb2,l_i

     INITIALIZE sr.* TO NULL
     LET l_str_1 = '' LET l_sum_1= ''  LET l_sum1_1= ''  LET l_str1_1 = ''
     LET l_str_2 = '' LET l_sum_2 = '' LET l_sum1_2 = '' LET l_str1_2 = ''
     LET l_str_3 = '' LET l_sum_3 = '' LET l_sum1_3 = '' LET l_str1_3 = ''
     LET l_str_4 = '' LET l_sum_4 = '' LET l_sum1_4 = '' LET l_str1_4 = ''
     LET l_str_5 = '' LET l_sum_5 = '' LET l_sum1_5 = '' LET l_str1_5 = ''
     LET l_str_6 = '' LET l_sum_6 = '' LET l_sum1_6 = '' LET l_str1_6 = ''
     LET l_str_7 = '' LET l_sum_7 = '' LET l_sum1_7 = '' LET l_str1_7 = ''
     LET l_str_8 = '' LET l_sum_8 = '' LET l_sum1_8 = '' LET l_str1_8 = ''
     LET l_str_9 = '' LET l_sum_9 = '' LET l_sum1_9 = '' LET l_str1_9 = ''
     LET l_str_10 = '' LET l_sum_10 = '' LET l_sum1_10 = '' LET l_str1_10 = ''
     LET l_str_11 = '' LET l_sum_11 = '' LET l_sum1_11 = '' LET l_str1_11 = ''
     LET l_str_12 = '' LET l_sum_12 = '' LET l_sum1_12 = '' LET l_str1_12= ''
     LET l_str_13 = '' LET l_sum_13 = '' LET l_sum1_13 = '' LET l_str1_13 = ''
     LET l_str_14 = '' LET l_sum_14 = '' LET l_sum1_14 = '' LET l_str1_14 = ''
     LET l_str_15 = '' LET l_sum_15= '' LET l_sum1_15 = '' LET l_str1_15 = ''
     LET l_str_16 = '' LET l_sum_16 = '' LET l_sum1_16 = '' LET l_str1_16 = ''
     LET l_str_17 = '' LET l_sum_17 = '' LET l_sum1_17 = '' LET l_str1_17 = ''
     LET l_str_18 = '' LET l_sum_18 = '' LET l_sum1_18 = '' LET l_str1_18 = ''
     LET l_str_19 = '' LET l_sum_19 = '' LET l_sum1_19 = '' LET l_str1_19 = ''
     LET l_str_20 = '' LET l_sum_20 = '' LET l_sum1_20 = '' LET l_str1_20 = ''
     LET l_str_21 = '' LET l_sum_21 = '' LET l_sum1_21 = '' LET l_str1_21 = ''
     LET l_str_22 = '' LET l_sum_22= '' LET l_sum1_22 = '' LET l_str1_22 = ''
     LET l_str_23 = '' LET l_sum_23= '' LET l_sum1_23 = '' LET l_str1_23 = ''
     LET l_str_24 = '' LET l_sum_24 = '' LET l_sum1_24 = '' LET l_str1_24 = ''
     LET l_str_25 = '' LET l_sum_25 = '' LET l_sum1_25 = '' LET l_str1_25 = ''
     LET l_str_26 = '' LET l_sum_26 = '' LET l_sum1_26 = '' LET l_str1_26 = ''
     LET l_str_27 = '' LET l_sum_27 = '' LET l_sum1_27 = '' LET l_str1_27 = ''
     LET l_str_28 = '' LET l_sum_28 = '' LET l_sum1_28 = '' LET l_str1_28 = ''
     LET l_str_29 = '' LET l_sum_29 = '' LET l_sum1_29 = '' LET l_str1_29 = ''
     LET l_str_30 = '' LET l_sum_30 = '' LET l_sum1_30 = '' LET l_str1_30 = ''
     LET l_str_31 = '' LET l_sum_31 = '' LET l_sum1_31 = '' LET l_str1_31 = ''
     LET l_cnt1 = 0  LET l_kb1 = '' LET l_kb1 = '' LET l_i = 0
     LET l_str = '' LET l_str1 = '' LET l_amd = ''
  
    END FOREACH

    LET g_str = ''
    LET g_wc = " amd22 in ",g_amd22_str," and amd173 = '",tm.amd173,"'",
               " and amd174 between '",tm.amd174b,"' and '",tm.amd174e,"'"
    
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'amd22,amd173,amd174')
             RETURNING g_wc
        LET g_str = g_wc
        IF g_str.getLength() > 1000 THEN
            LET g_str = g_str.subString(1,600)
            LET g_str = g_str,"..."
        END IF
    END IF
   LET g_str = g_str,";",tm.amd173,";",tm.amd174b,';',tm.amd174e,";"
   CALL cl_prt_cs3('amdr314','amdr314',l_sql,g_str) 

END FUNCTION
#No.FUN-B90079
