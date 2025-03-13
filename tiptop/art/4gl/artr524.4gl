# Prog. Version..: '5.30.06-13.03.12(00003)'     #
# Pattern name...: artr524.4gl
# Descriptions...: 銷售折扣分析表
# Date & Author..: #FUN-B80146 11/08/23 by pauline
# Modify.........: No.FUN-BC0026 12/01/30 By Pauline列印前是否有參考p_zz中的設定列印條件選項
# Modify.........: No.FUN-C60001 12/06/01 By pauline 日期錯誤
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm  RECORD                # Print condition RECORD
              wc1     STRING,
              wc      STRING,
              wc2     STRING,
              a       LIKE type_file.chr1,
              more    LIKE type_file.chr1       # Input more condition(Y/N)
              END RECORD
DEFINE g_rate RECORD
             rate1        LIKE type_file.num5,
             rate11       LIKE type_file.num5,
             rate2        LIKE type_file.num5,
             rate22       LIKE type_file.num5,
             rate3        LIKE type_file.num5,
             rate33       LIKE type_file.num5,
             rate4        LIKE type_file.num5,
             rate44       LIKE type_file.num5
             END RECORD

DEFINE   g_sql           STRING
DEFINE   g_str           STRING
DEFINE   l_table         STRING
DEFINE   g_chk_azw01     LIKE type_file.chr1
DEFINE   g_chk_auth      STRING
DEFINE   g_azw01         LIKE azp_file.azp01
DEFINE   g_azw01_str     STRING
DEFINE   g_str1          STRING
DEFINE   g_oga02_str     LIKE oga_file.oga02
DEFINE   g_oga02_end     LIKE oga_file.oga02
#DEFINE   g_oga02_str1    LIKE oga_file.oga02   #FUN-C60001 mark
#DEFINE   g_oga02_end1    LIKE oga_file.oga02   #FUN-C60001 mark 
DEFINE   g_oga02_str1    STRING                 #FUN-C60001 add
DEFINE   g_oga02_end1    STRING                 #FUN-C60001 add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT              


   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)

 IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   LET g_sql = 
                "ima01.ima_file.ima01,",
                "ima02.ima_file.ima02,",
                "ogb05.ogb_file.ogb05,",
                "ima131.ima_file.ima131,",
                "oba02.oba_file.oba02,",
                "ima1005.ima_file.ima1005,",
                "ima1006.ima_file.ima1006,",
                "ogb12_1.ogb_file.ogb12,",
                "ogb14t_1.ogb_file.ogb14t,",
                "ogb12_1l.ogb_file.ogb12,",
                "ogb14t_1l.ogb_file.ogb14t,",
                "ogb12_2.ogb_file.ogb12,",
                "ogb14t_2.ogb_file.ogb14t,",
                "ogb12_2l.ogb_file.ogb12,",
                "ogb14t_2l.ogb_file.ogb14t,",
                "ogb12_3.ogb_file.ogb12,",
                "ogb14t_3.ogb_file.ogb14t,",
                "ogb12_3l.ogb_file.ogb12,",
                "ogb14t_3l.ogb_file.ogb14t,",
                "ogb12_4.ogb_file.ogb12,",
                "ogb14t_4.ogb_file.ogb14t,",
                "ogb12_4l.ogb_file.ogb12,",
                "ogb14t_4l.ogb_file.ogb14t,",  
                "azi04.azi_file.azi04,",
                "tqa02.tqa_file.tqa02"
 
   LET l_table = cl_prt_temptable('artr524',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   CALL cl_del_data(l_table)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?, ?, ?, ?, ?,    ? ,? ,? ,? ,?, ",
                       "?, ?, ?, ?, ?,    ? ,? ,? ,? ,?, ",
                       "?, ?, ?, ?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   IF cl_null(g_bgjob) OR g_bgjob = 'N'     
      THEN CALL artr524_tm(0,0)      
      ELSE CALL artr524()            
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION artr524_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01
DEFINE p_row,p_col    LIKE type_file.num5,
       l_cmd          LIKE type_file.chr1000,
       l_str          STRING
DEFINE l_tok          base.StringTokenizer
DEFINE l_zxy03        LIKE zxy_file.zxy03
DEFINE l_oga02        STRING 
DEFINE l_i            LIKE type_file.num5
DEFINE l_pd           LIKE type_file.num5
DEFINE l_str2         STRING      #FUN-C60001 add

   IF p_row = 0 THEN LET p_row = 6 LET p_col = 14 END IF
   OPEN WINDOW artr524_w AT p_row,p_col WITH FORM "art/42f/artr524"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   INITIALIZE tm.* TO NULL
   LET g_rate.rate1 = 90
   LET g_rate.rate11 = 100
   LET g_rate.rate2 = 80 
   LET g_rate.rate22 = 89
   LET g_rate.rate3 = 70
   LET g_rate.rate33 = 79
   LET g_rate.rate4 = 0
   LET g_rate.rate44 = 69
   LET tm.more = 'N'
   LET tm.a = '1'
   WHILE TRUE

      CONSTRUCT tm.wc1 ON azw01 FROM azw01
         BEFORE CONSTRUCT
             CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(azw01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_azw"
                  LET g_qryparam.where = " azw01 IN ",g_auth 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO azw01
                  NEXT FIELD azw01
            END CASE
         ON ACTION locale
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         ON ACTION help
            CALL cl_show_help()
            CONTINUE WHILE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE WHILE

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION close
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()

      END CONSTRUCT
     
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW artr524_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      

      WHILE TRUE 
      CONSTRUCT tm.wc ON ryf01, oga02,ima131, tqa02, tqa021
         FROM ryf01, oga02,ima131, tqa02, tqa021

         BEFORE CONSTRUCT
             CALL cl_qbe_init()
             LET g_oga02_str1 = NULL
             LET g_oga02_end1 = NULL

         AFTER FIELD oga02 
            #FUN-C60001 mark START
            #LET l_oga02 = GET_FLDBUF(oga02)
            #IF cl_null(l_oga02) OR l_oga02 = '' THEN
            #    CALL cl_err('','art1014',0)
            #    NEXT FIELD oga02
            #END IF
            #LET l_tok = base.StringTokenizer.create(l_oga02,':')
            #LET l_i = 1
            #WHILE l_tok.hasMoreTokens()
            #    IF l_i = 1 THEN 
            #       LET g_oga02_str1 = l_tok.nextToken()
            #    END IF
            #    IF l_i = 2 THEN
            #       LET g_oga02_end1 = l_tok.nextToken()
            #    END IF
            #    LET l_i = l_i+1
            #END WHILE
            #LET g_oga02_str = g_oga02_str1 -12 UNITS MONTH
            #LET g_oga02_end = g_oga02_end1 -12 UNITS MONTH
            #IF cl_null(g_oga02_str) THEN
            #   LET g_str1 = "oga02 =  CAST('",g_oga02_str, " 00:00:00','YY/MM/DD HH24:MI:SS') "
            #   LET g_str1 = cl_replace_str(g_str1, "CAST","TO_DATE")
            #ELSE
            #   LET g_str1 = "oga02 between  CAST('",g_oga02_str, " 00:00:00','YY/MM/DD HH24:MI:SS') and CAST('",g_oga02_end," 00:00:00','YY/MM/DD HH24:MI:SS')" 
            #   LET g_str1 = cl_replace_str(g_str1, "CAST","TO_DATE")
            #END IF
            #FUN-C60001 mark END
         ON ACTION controlp
            CASE
               WHEN INFIELD(ryf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_ryf"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ryf01
                  NEXT FIELD ryf01 
               WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_oba_13"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima131 
                  NEXT FIELD ima131
               WHEN INFIELD(tqa02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = '2'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqa02 
                  NEXT FIELD tqa02 
               WHEN INFIELD(tqa021)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_tqa"
                  LET g_qryparam.arg1 = '3'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tqa021
                  NEXT FIELD tqa021 
            END CASE

         ON ACTION locale
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         ON ACTION help
            CALL cl_show_help()
            CONTINUE WHILE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE WHILE

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION close
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         ON ACTION qbe_select
            CALL cl_qbe_select()
        #FUN-C60001 mark START
        #IF cl_null(g_oga02_str) THEN 
        #   NEXT FIELD oga02
        #END IF 
        #FUN-C60001 mark END
         
      END CONSTRUCT
        #FUN-C60001 add START
         LET l_str2 = tm.wc
         LET l_i= tm.wc.getIndexOf('oga02',1)
         LET g_oga02_str1 = l_str2.substring(l_i+23,l_i+32)
         LET g_oga02_end1 = l_str2.substring(l_i+82,l_i+91)
        #FUN-C60001 add END
        #FUN-C60001 mark START;
         IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
        #IF cl_null(g_oga02_str1) THEN
        #   CALL cl_err('','art1014',0)
        #ELSE 
        #   EXIT WHILE
        #END IF
        #FUN-C60001 mark END
         EXIT WHILE       #FUN-C60001 add
     END WHILE
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW artr524_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
    
      INPUT BY NAME g_rate.*, tm.a  ATTRIBUTES(WITHOUT DEFAULTS=TRUE, UNBUFFERED)
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD rate1   
            IF cl_null(g_rate.rate1) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD rate1
            END IF
            
         AFTER FIELD rate11
            IF cl_null(g_rate.rate11) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD rate11
            END IF
            IF g_rate.rate11 < g_rate.rate1 THEN
               CALL cl_err('','art1013',0)
               NEXT FIELD rate11
            END IF
            LET l_pd = g_rate.rate11 - g_rate.rate1
            LET g_rate.rate22 = g_rate.rate1 - 1
            LET g_rate.rate2  = g_rate.rate22 - l_pd
            LET g_rate.rate33 = g_rate.rate2 - 1
            LET g_rate.rate3  = g_rate.rate33 - l_pd
            LET g_rate.rate44 = g_rate.rate3 - 1 

         AFTER FIELD rate2
            IF cl_null(g_rate.rate2) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD rate2
            END IF
            IF g_rate.rate2 > g_rate.rate1 OR g_rate.rate2 = g_rate.rate1 THEN
               CALL cl_err('','art1017',0)
               NEXT FIELD rate2
            END IF

         AFTER FIELD rate22
            IF cl_null(g_rate.rate22) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD rate22
            END IF
            IF g_rate.rate22 < g_rate.rate2  OR g_rate.rate22 = g_rate.rate2 THEN
               CALL cl_err('','art1013',0)
               NEXT FIELD rate22
            END IF
            IF g_rate.rate22 > g_rate.rate1 OR g_rate.rate22 = g_rate.rate1 THEN
               CALL cl_err('','art1017',0)
               NEXT FIELD rate22
            END IF
            LET l_pd = g_rate.rate22 - g_rate.rate2
            LET g_rate.rate33 = g_rate.rate2 -1
            LET g_rate.rate3  = g_rate.rate33 - l_pd
            LET g_rate.rate44 = g_rate.rate3 - 1

         AFTER FIELD rate3
            IF cl_null(g_rate.rate3) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD rate3
            END IF
            IF g_rate.rate3 > g_rate.rate2 OR g_rate.rate3 = g_rate.rate2 THEN
               CALL cl_err('','art1017',0)
               NEXT FIELD rate3
            END IF
            LET g_rate.rate44 = g_rate.rate3 - 1

         AFTER FIELD rate33
            IF cl_null(g_rate.rate33) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD g_rate.rate33
            END IF
            IF g_rate.rate33 < g_rate.rate3 OR g_rate.rate33 = g_rate.rate3 THEN
               CALL cl_err('','art1013',0)
               NEXT FIELD rate33
            END IF
            IF g_rate.rate33 > g_rate.rate2 OR g_rate.rate33 = g_rate.rate2 THEN
               CALL cl_err('','art1017',0)
               NEXT FIELD rate33
            END IF
            LET g_rate.rate44 = g_rate.rate3 - 1

         AFTER FIELD rate4
            IF cl_null(g_rate.rate4) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD rate4
            END IF
            IF g_rate.rate4 > g_rate.rate3 OR g_rate.rate4 = g_rate.rate3 THEN
               CALL cl_err('','art1017',0)
               NEXT FIELD rate4
            END IF

         AFTER FIELD rate44
            IF cl_null(g_rate.rate44) THEN
               CALL cl_err('','art1012',0)
               NEXT FIELD rate44
            END IF
            IF g_rate.rate44 < g_rate.rate4 OR g_rate.rate44 = g_rate.rate4 THEN
               CALL cl_err('','art1013',0)
               NEXT FIELD rate44
            END IF
            IF g_rate.rate44 > g_rate.rate3 OR g_rate.rate44 = g_rate.rate3 THEN
               CALL cl_err('','art1017',0)
               NEXT FIELD rate44
            END IF

         AFTER INPUT
            IF cl_null(g_rate.rate1) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate1
            END IF 
            IF cl_null(g_rate.rate11) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate11
            END IF 
            IF cl_null(g_rate.rate2) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate2
            END IF 
            IF cl_null(g_rate.rate22) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate22
            END IF 
            IF cl_null(g_rate.rate3) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate3
            END IF 
            IF cl_null(g_rate.rate33) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate33
            END IF 
            IF cl_null(g_rate.rate4) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate4
            END IF 
            IF cl_null(g_rate.rate44) THEN 
               CALL cl_err('','art1012',0)
               NEXT FIELD rate44
            END IF 
            IF g_rate.rate11 < g_rate.rate1 THEN 
               CALL cl_err('','art1013',0)
               NEXT FIELD rate11
            END IF 
            IF g_rate.rate22< g_rate.rate2 THEN 
               CALL cl_err('','art1013',0)
               NEXT FIELD rate22
            END IF 
            IF g_rate.rate33 < g_rate.rate3 THEN 
               CALL cl_err('','art1013',0)
               NEXT FIELD rate33
            END IF 
            IF g_rate.rate44 < g_rate.rate4 THEN 
               CALL cl_err('','art1013',0)
               NEXT FIELD rate44
            END IF 
            IF g_rate.rate2 > g_rate.rate1 THEN 
               CALL cl_err('','art1017',0)
               NEXT FIELD rate2
            END IF 
            IF g_rate.rate22 > g_rate.rate1 THEN 
               CALL cl_err('','art1017',0)
               NEXT FIELD rate22
            END IF 
            IF g_rate.rate3 > g_rate.rate2 THEN 
               CALL cl_err('','art1017',0)
               NEXT FIELD rate3
            END IF 
            IF g_rate.rate33 > g_rate.rate2 THEN 
               CALL cl_err('','art1017',0)
               NEXT FIELD rate33
            END IF 
            IF g_rate.rate4 > g_rate.rate3 THEN 
               CALL cl_err('','art1017',0)
               NEXT FIELD rate4
            END IF 
            IF g_rate.rate44 > g_rate.rate3 THEN
               CALL cl_err('','art1017',0)
               NEXT FIELD rate44
            END IF

         ON ACTION locale
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         ON ACTION help
            CALL cl_show_help()
            CONTINUE WHILE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE WHILE
         ON ACTION controlg
            CALL cl_cmdask()
         ON ACTION close
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_select
            CALL cl_qbe_select()
      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r521_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF

      INPUT BY NAME tm.more ATTRIBUTES(WITHOUT DEFAULTS=TRUE)

         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)

         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                            g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF

         ON ACTION locale
            CALL cl_show_fld_cont()
            CALL cl_dynamic_locale()
            CONTINUE WHILE
         ON ACTION help
            CALL cl_show_help()
            CONTINUE WHILE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE WHILE
         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION close
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         ON ACTION qbe_select
            CALL cl_qbe_select()

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r521_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL artr524()
      ERROR ""
   END WHILE
   CLOSE WINDOW artr524_w
END FUNCTION

FUNCTION artr524()
DEFINE l_sql     STRING
DEFINE l_sql2    STRING
DEFINE l_sql3    STRING
DEFINE l_sql4    STRING
DEFINE l_index   LIKE type_file.num5
DEFINE l_rate    LIKE ogb_file.ogb37
DEFINE l_plant   LIKE  azp_file.azp01,
       l_azp02   LIKE azp_file.azp02
DEFINE l_azi04   LIKE azi_file.azi04
DEFINE sr        RECORD
          num       LIKE type_file.num5,
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005,
          ogb13     LIKE ogb_file.ogb13,
          ogb37     LIKE ogb_file.ogb37,
          tqa0101   LIKE tqa_file.tqa01,
          tqa0102   LIKE tqa_file.tqa01
                  END RECORD

DEFINE sr1        RECORD
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ogb05     LIKE ogb_file.ogb05,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1006,
          oga23     LIKE oga_file.oga23,
          ogb12_1   LIKE ogb_file.ogb12,
          ogb14t_1  LIKE ogb_file.ogb14t,
          ogb12_1l  LIKE ogb_file.ogb12,
          ogb14t_1l LIKE ogb_file.ogb14t,
          ogb12_2   LIKE ogb_file.ogb12,
          ogb14t_2  LIKE ogb_file.ogb14t,
          ogb12_2l  LIKE ogb_file.ogb12,
          ogb14t_2l LIKE ogb_file.ogb14t,
          ogb12_3   LIKE ogb_file.ogb12,
          ogb14t_3  LIKE ogb_file.ogb14t,
          ogb12_3l  LIKE ogb_file.ogb12,
          ogb14t_3l LIKE ogb_file.ogb14t,
          ogb12_4   LIKE ogb_file.ogb12,
          ogb14t_4  LIKE ogb_file.ogb14t,
          ogb12_4l  LIKE ogb_file.ogb12,
          ogb14t_4l LIKE ogb_file.ogb14t,
          azi04     LIKE azi_file.azi04,
          tqa02     LIKE tqa_file.tqa02
                  END RECORD
DEFINE l_wc         STRING
  #FUN-BC0026 add START
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(tm.wc,'ryf01, oga02,ima131, tqa02, tqa021')
      RETURNING l_wc
      LET g_str =l_wc
      IF g_str.getLength() > 1000 THEN
         LET g_str = g_str.subString(1,600)
         LET g_str = g_str,"..."
      END IF
   END IF
  #FUN-BC0026 add END
   LET tm.wc2 = tm.wc
  #FUN-C60001 mark START   
  #LET l_index = tm.wc.getIndexOf('oga02',1)
  #IF cl_null(g_oga02_end)  THEN
  #   LET tm.wc2 = cl_replace_str_by_index(tm.wc,l_index,60,g_str1)
  #ELSE 
  #   LET tm.wc2 = cl_replace_str_by_index(tm.wc,l_index,128,g_str1)
  #END IF
  #FUN-C60001 mark END  
   CALL cl_del_data(l_table)

   DROP TABLE artr524_tmp
#存放所有在折扣比率內的產品資料(本期)
   CREATE TEMP TABLE artr524_tmp(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          tqa0101   LIKE tqa_file.tqa01,
          tqa0102   LIKE tqa_file.tqa01,
          ima       LIKE ima_file.ima1005
          )

   DELETE FROM artr524_tmp

   DROP TABLE artr524_tmp1
#存放所有在第一區間折扣比率內的產品資料(本期)
   CREATE TEMP TABLE artr524_tmp1(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12, #數量
          ogb14t    LIKE ogb_file.ogb14t,#金額
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005
          )
   DELETE FROM artr524_tmp1

   DROP TABLE artr524_tmp2
#存放所有在第區間折扣比率內的產品資料(本期)
   CREATE TEMP TABLE artr524_tmp2(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005
          )   

   DELETE FROM artr524_tmp2

   DROP TABLE artr524_tmp3
#存放所有在第三區間折扣比率內的產品資料(本期)
   CREATE TEMP TABLE artr524_tmp3(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006  LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005
          )   

   DELETE FROM artr524_tmp3

   DROP TABLE artr524_tmp4

#存放所有在第四區間折扣比率內的產品資料(本期)
   CREATE TEMP TABLE artr524_tmp4(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE tqa_file.tqa02,
          ima1006   LIKE tqa_file.tqa02,
          ima       LIKE ima_file.ima1005
          )   

   DELETE FROM artr524_tmp4

   DROP TABLE artr524_tmp1l
#存放所有在第一區間折扣比率內的產品資料(去年)
   CREATE TEMP TABLE artr524_tmp1l(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005
          )
   DELETE FROM artr524_tmp1l

   DROP TABLE artr524_tmp2l
#存放所有在第二區間折扣比率內的產品資料(去年)
   CREATE TEMP TABLE artr524_tmp2l(
          ogaplant  LIKE oga_file.ogaplant, 
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005
          )   

   DELETE FROM artr524_tmp2l

   DROP TABLE artr524_tmp3l
#存放所有在第三區間折扣比率內的產品資料(去年)
   CREATE TEMP TABLE artr524_tmp3l(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005
          )   

   DELETE FROM artr524_tmp3l

   DROP TABLE artr524_tmp4l
#存放所有在第四區間折扣比率內的產品資料(去年)
   CREATE TEMP TABLE artr524_tmp4l(
          ogaplant  LIKE oga_file.ogaplant ,
          azw08     LIKE azw_file.azw08,  
          ryf01     LIKE ryf_file.ryf01,
          ogb05     LIKE ogb_file.ogb05,
          ogb12     LIKE ogb_file.ogb12,
          ogb14t    LIKE ogb_file.ogb14t,
          ima01     LIKE ima_file.ima01,
          ima02     LIKE ima_file.ima02,
          ima131    LIKE ima_file.ima131,
          oba02     LIKE oba_file.oba02,
          ima1005   LIKE ima_file.ima1005,
          ima1006   LIKE ima_file.ima1005,
          ima       LIKE ima_file.ima1005
          )   

   DELETE FROM artr524_tmp4l

     LET l_sql = "SELECT DISTINCT azw01,azw08 FROM azw_file,rtz_file ",
                " WHERE azw01 = rtz01  ",
                " AND ", tm.wc1,
                " AND azw01 IN ",g_auth,
                " ORDER BY azw01 "

   PREPARE sel_azp01_pre FROM l_sql
   DECLARE sel_azp01_cs CURSOR FOR sel_azp01_pre
   FOREACH sel_azp01_cs INTO l_plant,l_azp02
      IF STATUS THEN
        CALL cl_err('PLANT:',SQLCA.sqlcode,1)
        RETURN
      END IF
         LET tm.wc = cl_replace_str(tm.wc,"tqa021","ima1006")
         LET tm.wc = cl_replace_str(tm.wc,"tqa02","ima1005")
      LET tm.wc = cl_replace_str(tm.wc,"oha02","oga02")
      LET l_sql = " SELECT '1',ogaplant,'','',ogb05,ogb12, ogb14t, ima01, ima02, ",
                  "        ima131, oba02, ima1005, ima1006,'',ogb13, ogb37, '','' ",
                  " FROM ",cl_get_target_table(l_plant,'oga_file'),
                  "            JOIN ",cl_get_target_table(l_plant,'ogb_file')," ON oga01 = ogb01",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ima_file')," ON ima01 = ogb04",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'oba_file')," ON oba01 = ima131",
                  "            JOIN ",cl_get_target_table(l_plant,'azw_file')," ON azw01 = ogaplant", 
                  "            JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON rtz01 = azw01",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ryf_file')," ON ryf01 = rtz10  ",
                  " WHERE ogapost='Y' ",
                  "    AND oga09 IN ('2','3','4','6')",
                  "    AND ", tm.wc CLIPPED
      LET tm.wc = cl_replace_str(tm.wc,"oga02","oha02")
      LET l_sql = l_sql,
                  " UNION ALL ",
                  " SELECT '2',ohaplant,'','',ohb05,ohb12*(-1), ohb14t*(-1), ima01, ima02,",
                  "        ima131, oba02, ima1005, ima1006,'' , ohb13, ohb37 , '','' ",
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),
                  "            JOIN ",cl_get_target_table(l_plant,'ohb_file')," ON oha01 = ohb01",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ima_file')," ON ima01 = ohb04 ",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'oba_file')," ON oba01 = ima131",
                  "            JOIN ",cl_get_target_table(l_plant,'azw_file')," ON azw01 = ohaplant",
                  "            JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON rtz01 = azw01",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ryf_file')," ON ryf01 = rtz10 ",
                  " WHERE ohapost='Y'",
                  "     AND oha05 IN ('1','2')",
                  "     AND ", tm.wc CLIPPED 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql
      PREPARE artr524_prepare1 FROM l_sql
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE artr524_curs1 CURSOR FOR artr524_prepare1

      LET tm.wc2 = cl_replace_str(tm.wc2,"tqa021","ima1006")
      LET tm.wc2 = cl_replace_str(tm.wc2,"tqa02","ima1005")
      LET tm.wc2 = cl_replace_str(tm.wc2,"oha02","oga02")
      LET l_sql2 = " SELECT '1',ogaplant,'','',ogb05,ogb12, ogb14t, ima01, ima02, ",
                   "         ima131, oba02, ima1005, ima1006,'',ogb13, ogb37 , '','' ",
                   " FROM ",cl_get_target_table(l_plant,'oga_file'),
                   "            JOIN ",cl_get_target_table(l_plant,'ogb_file')," ON oga01 = ogb01 ",
                   " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ima_file')," ON ima01 = ogb04",
                   " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'oba_file')," ON oba01 = ima131",
                   "            JOIN ",cl_get_target_table(l_plant,'azw_file')," ON azw01 = ogaplant",
                   "            JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON rtz01 = azw01",
                   " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ryf_file')," ON ryf01 = rtz10",
                   " WHERE ogapost='Y' ",
                   "       AND oga09 IN ('2','3','4','6')",
                   "       AND ", tm.wc2 CLIPPED
      LET tm.wc2 = cl_replace_str(tm.wc2,"oga02","oha02")
      LET l_sql2 = l_sql2,
                  " UNION ALL ",
                  "SELECT '2',ohaplant,'','',ohb05,ohb12*(-1), ohb14t*(-1), ima01, ima02,",
                  "       ima131, oba02, ima1005, ima1006,'', ohb13, ohb37, '',''  ",
                  " FROM ",cl_get_target_table(l_plant,'oha_file'),
                  "            JOIN ",cl_get_target_table(l_plant,'ohb_file')," ON oha01 = ohb01",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ima_file')," ON ima01 = ohb04",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'oba_file')," ON oba01 = ima131",
                  "            JOIN ",cl_get_target_table(l_plant,'azw_file')," ON azw01 = ohaplant",
                  "            JOIN ",cl_get_target_table(l_plant,'rtz_file')," ON rtz01 = azw01",
                  " LEFT OUTER JOIN ",cl_get_target_table(l_plant,'ryf_file')," ON ryf01 = rtz10",
                  " WHERE ohapost='Y'",
                  "      AND oha05 IN ('1','2')",
                  "      AND ", tm.wc2 CLIPPED 
      CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
      CALL cl_parse_qry_sql(l_sql2,l_plant) RETURNING l_sql2
      PREPARE artr524_prepare3 FROM l_sql2
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time
         EXIT PROGRAM
      END IF
      DECLARE artr524_curs3 CURSOR FOR artr524_prepare3
      FOREACH artr524_curs1 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF  (sr.ogb13 = 0 OR  cl_null(sr.ogb13)) AND (sr.ogb37 = 0 OR　cl_null(sr.ogb37)) THEN
             LET sr.ogb13 = 1
         END IF
         IF　sr.ogb37 = 0 OR　cl_null(sr.ogb37) THEN
            LET sr.ogb37 = sr.ogb13 
         END IF
         LET l_rate = 0
         LET l_rate = (sr.ogb13 / sr.ogb37) * 100
         LET l_rate = cl_digcut(l_rate,0)
         IF (l_rate<g_rate.rate11 AND l_rate>g_rate.rate4) OR l_rate = g_rate.rate11 or l_rate = g_rate.rate4 THEN
            LET l_sql3 = " SELECT DISTINCT tqa02 FROM ",cl_get_target_table(l_plant,'tqa_file'),
                         " WHERE tqa03 = '2' AND tqa01 = '",sr.ima1005,"'"
            CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3
            CALL cl_parse_qry_sql(l_sql3,l_plant) RETURNING l_sql3
            PREPARE artr524_prepare4 FROM l_sql3
            EXECUTE artr524_prepare4 INTO sr.tqa0101

            LET l_sql4 = " SELECT DISTINCT tqa02 FROM ",cl_get_target_table(l_plant,'tqa_file'),
                         " WHERE tqa03 = '3' AND tqa01 = '",sr.ima1006,"'"
            CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4
            CALL cl_parse_qry_sql(l_sql4,l_plant) RETURNING l_sql4
            PREPARE artr524_prepare5 FROM l_sql4
            EXECUTE artr524_prepare5 INTO sr.tqa0102

            INSERT INTO artr524_tmp
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.tqa0101,sr.tqa0102,sr.ima)
         END IF

         IF (l_rate < g_rate.rate11 AND l_rate > g_rate.rate1) OR l_rate = g_rate.rate1 OR l_rate = g_rate.rate11 THEN
            INSERT INTO artr524_tmp1
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF   
         IF (l_rate < g_rate.rate22 AND l_rate > g_rate.rate2) OR l_rate = g_rate.rate2 OR l_rate = g_rate.rate22 THEN 
            INSERT INTO artr524_tmp2
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF
         IF (l_rate < g_rate.rate33 AND l_rate > g_rate.rate3) OR l_rate = g_rate.rate3 OR l_rate = g_rate.rate33 THEN
            INSERT INTO artr524_tmp3
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF
         IF (l_rate < g_rate.rate44 AND l_rate > g_rate.rate4) OR l_rate = g_rate.rate4 OR l_rate = g_rate.rate44 THEN
            INSERT INTO artr524_tmp4
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF
      END FOREACH
      FOREACH artr524_curs3 INTO sr.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF　sr.ogb13 = 0 OR　cl_null(sr.ogb13) THEN
            LET sr.ogb13 = 1
         END IF
         IF　sr.ogb37 = 0 OR　cl_null(sr.ogb37) THEN
            LET sr.ogb37 = sr.ogb13 
         END IF
         LET l_rate = 0 
         LET l_rate = (sr.ogb13 / sr.ogb37) * 100
         LET l_rate = cl_digcut(l_rate,0)
         IF (l_rate<g_rate.rate11 AND l_rate>g_rate.rate4) OR l_rate = g_rate.rate11 or l_rate = g_rate.rate4 THEN
            INSERT INTO artr524_tmp
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,tqa0101,tqa0102,sr.ima)
         END IF

         IF (l_rate < g_rate.rate11 AND l_rate > g_rate.rate1) OR l_rate = g_rate.rate1 OR l_rate = g_rate.rate11 THEN
            INSERT INTO artr524_tmp1l
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF
         IF (l_rate < g_rate.rate22 AND l_rate > g_rate.rate2) OR l_rate = g_rate.rate2 OR l_rate = g_rate.rate22 THEN
            INSERT INTO artr524_tmp2l
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF
         IF (l_rate < g_rate.rate33 AND l_rate > g_rate.rate3) OR l_rate = g_rate.rate3 OR l_rate = g_rate.rate33 THEN
            INSERT INTO artr524_tmp3l
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF
         IF (l_rate < g_rate.rate44 AND l_rate > g_rate.rate4) OR l_rate = g_rate.rate4 OR l_rate = g_rate.rate44 THEN
            INSERT INTO artr524_tmp4l
              VALUES(sr.ogaplant,sr.azw08,sr.ryf01,sr.ogb05,sr.ogb12,sr.ogb14t,sr.ima01,
               sr.ima02,sr.ima131,sr.oba02,sr.ima1005,sr.ima1006,sr.ima)
         END IF
      END FOREACH
   END FOREACH
   CASE
      WHEN tm.a = '1'
         LET  l_sql = " SELECT DISTINCT ima01, ima02,ogb05,'','','','' FROM artr524_tmp  ORDER BY ima01 " 
      WHEN tm.a = '2'
         LET  l_sql = " SELECT DISTINCT '', '',ogb05,ima131,oba02,'','' FROM artr524_tmp ORDER BY ima131"
      WHEN tm.a = '3'
         LET  l_sql = " SELECT DISTINCT '', '',ogb05,'','',tqa0101,ima1005,'' FROM artr524_tmp WHERE ima1005 is not null"
      WHEN tm.a = '4'
         LET  l_sql = " SELECT DISTINCT '', '',ogb05,'','',tqa0102,'',ima1006 FROM artr524_tmp WHERE ima1006 IS NOT NULL"
   END CASE
   PREPARE artr524_prepare2 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   DECLARE artr524_curs2 CURSOR FOR artr524_prepare2
   FOREACH artr524_curs2 INTO   sr1.ima01, sr1.ima02, sr1.ogb05,sr1.ima131, sr1.oba02,sr1.tqa02,sr1.ima1005, sr1.ima1006                

   CASE
      WHEN tm.a = '1'
         SELECT SUM(ogb12) INTO sr1.ogb12_1 FROM artr524_tmp1 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1 FROM artr524_tmp1 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_1l FROM artr524_tmp1l WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1l FROM artr524_tmp1l WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2 FROM artr524_tmp2 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2 FROM artr524_tmp2 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2l FROM artr524_tmp2l WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2l FROM artr524_tmp2l WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3 FROM artr524_tmp3 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3 FROM artr524_tmp3 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3l FROM artr524_tmp3l WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3l FROM artr524_tmp3l WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4 FROM artr524_tmp4 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4 FROM artr524_tmp4 WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4l FROM artr524_tmp4l WHERE ima01 = sr1.ima01 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4l FROM artr524_tmp4l WHERE ima01 = sr1.ima01  AND ogb05 = sr1.ogb05      
      WHEN tm.a = '2'
         SELECT SUM(ogb12) INTO sr1.ogb12_1 FROM artr524_tmp1 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1 FROM artr524_tmp1 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_1l FROM artr524_tmp1l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1l FROM artr524_tmp1l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2 FROM artr524_tmp2 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2 FROM artr524_tmp2 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2l FROM artr524_tmp2l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2l FROM artr524_tmp2l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3 FROM artr524_tmp3 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3 FROM artr524_tmp3 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3l FROM artr524_tmp3l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3l FROM artr524_tmp3l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4 FROM artr524_tmp4 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4 FROM artr524_tmp4 WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4l FROM artr524_tmp4l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4l FROM artr524_tmp4l WHERE ima131 = sr1.ima131 AND ogb05 = sr1.ogb05
      WHEN tm.a = '3'
         IF cl_null(sr1.ima1005) THEN
            RETURN
         END IF
         SELECT SUM(ogb12) INTO sr1.ogb12_1 FROM artr524_tmp1 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1 FROM artr524_tmp1 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_1l FROM artr524_tmp1l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1l FROM artr524_tmp1l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2 FROM artr524_tmp2 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2 FROM artr524_tmp2 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2l FROM artr524_tmp2l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2l FROM artr524_tmp2l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3 FROM artr524_tmp3 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3 FROM artr524_tmp3 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3l FROM artr524_tmp3l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3l FROM artr524_tmp3l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4 FROM artr524_tmp4 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4 FROM artr524_tmp4 WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4l FROM artr524_tmp4l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4l FROM artr524_tmp4l WHERE ima1005 = sr1.ima1005 AND ogb05 = sr1.ogb05

      WHEN tm.a = '4'
         SELECT SUM(ogb12) INTO sr1.ogb12_1 FROM artr524_tmp1 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1 FROM artr524_tmp1 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_1l FROM artr524_tmp1l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_1l FROM artr524_tmp1l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2 FROM artr524_tmp2 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2 FROM artr524_tmp2 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_2l FROM artr524_tmp2l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_2l FROM artr524_tmp2l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3 FROM artr524_tmp3 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3 FROM artr524_tmp3 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_3l FROM artr524_tmp3l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_3l FROM artr524_tmp3l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4 FROM artr524_tmp4 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4 FROM artr524_tmp4 WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb12) INTO sr1.ogb12_4l FROM artr524_tmp4l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05
         SELECT SUM(ogb14t) INTO sr1.ogb14t_4l FROM artr524_tmp4l WHERE ima1006 = sr1.ima1006 AND ogb05 = sr1.ogb05

   END CASE
      IF cl_null(sr1.ogb12_1) THEN
         LET sr1.ogb12_1 = 0
      END IF

      IF cl_null(sr1.ogb14t_1) THEN
         LET sr1.ogb14t_1 = 0
      END IF

      IF cl_null(sr1.ogb12_1l) THEN
         LET sr1.ogb12_1l = 0
      END IF

      IF cl_null(sr1.ogb14t_1l) THEN
         LET sr1.ogb14t_1l = 0
      END IF

      IF cl_null(sr1.ogb12_2) THEN
         LET sr1.ogb12_2 = 0
      END IF

      IF cl_null(sr1.ogb14t_2) THEN
         LET sr1.ogb14t_2 = 0
      END IF
 
      IF cl_null(sr1.ogb12_2l) THEN
         LET sr1.ogb12_2l = 0
      END IF

      IF cl_null(sr1.ogb14t_2l) THEN
         LET sr1.ogb14t_2l = 0
      END IF

      IF cl_null(sr1.ogb12_3) THEN
         LET sr1.ogb12_3 = 0
      END IF

      IF cl_null(sr1.ogb14t_3) THEN
         LET sr1.ogb14t_3 = 0
      END IF

      IF cl_null(sr1.ogb12_3l) THEN
         LET sr1.ogb12_3l = 0
      END IF

      IF cl_null(sr1.ogb14t_3l) THEN
         LET sr1.ogb14t_3l = 0
      END IF

      IF cl_null(sr1.ogb12_4) THEN
         LET sr1.ogb12_4 = 0
      END IF

      IF cl_null(sr1.ogb14t_4) THEN
         LET sr1.ogb14t_4 = 0
      END IF

      IF cl_null(sr1.ogb12_4l) THEN
         LET sr1.ogb12_4l = 0
      END IF

      IF cl_null(sr1.ogb14t_4l) THEN
         LET sr1.ogb14t_4l = 0
      END IF
      SELECT azi04 INTO sr1.azi04 FROM azi_file WHERE azi01 = g_aza.aza17

      EXECUTE  insert_prep  USING
          sr1.ima01, sr1.ima02,sr1.ogb05, sr1.ima131, sr1.oba02,
          sr1.ima1005, sr1.ima1006, sr1.ogb12_1 , sr1.ogb14t_1, sr1.ogb12_1l , sr1.ogb14t_1l
         , sr1.ogb12_2 , sr1.ogb14t_2, sr1.ogb12_2l , sr1.ogb14t_2l
         , sr1.ogb12_3 , sr1.ogb14t_3, sr1.ogb12_3l , sr1.ogb14t_3l
         , sr1.ogb12_4 , sr1.ogb14t_4, sr1.ogb12_4l , sr1.ogb14t_4l, sr1.azi04, sr1.tqa02 
            

   END FOREACH
   IF cl_null(g_oga02_end1) THEN
      LET g_oga02_end1 = g_oga02_str1
   END IF

   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
  #LET g_str = tm.wc,";",g_rate.rate1,";", g_rate.rate11,";", g_rate.rate2,";", g_rate.rate22,";", g_rate.rate3,";", g_rate.rate33,";",  #FUN-BC0026 mark
   LET g_str = g_str,";",g_rate.rate1,";", g_rate.rate11,";", g_rate.rate2,";", g_rate.rate22,";", g_rate.rate3,";", g_rate.rate33,";",  #FUN-BC0026 add
                g_rate.rate4,";", g_rate.rate44,";",g_oga02_str1,";",g_oga02_end1,";",tm.a
         CALL cl_prt_cs3('artr524','artr524_1',l_sql,g_str)
END FUNCTION
#FUN-B80146
