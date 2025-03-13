# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: amdt001.4gl
# Descriptions...: 進項稅額分攤
# Date & Author..: 11/10/19 By Belle (FUN-BA0021)
# Modify.........: No.MOD-C20236 12/03/03 By Polly 得扣抵之進項稅額合計(1)+(2)+(3)+(4)調整amk65+amk67+amk71+amk73

DATABASE ds

 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
#FUN-BA0021
DEFINE
    g_amk01           LIKE amk_file.amk01,
    g_amk01_t         LIKE amk_file.amk01,
    g_amk02           LIKE amk_file.amk02,
    g_amk02_t         LIKE amk_file.amk02,
    g_amk03           LIKE amk_file.amk03,
    g_amk03_t         LIKE amk_file.amk03,
    g_amk             RECORD                 #程式變數(Program Variables)
        amk01         LIKE amk_file.amk01,
        amk02         LIKE amk_file.amk02,
        amk03         LIKE amk_file.amk03,
        amk04         LIKE amk_file.amk04,
        amk05         LIKE amk_file.amk05,
        amk06         LIKE amk_file.amk06,
        amk07         LIKE amk_file.amk07,
        amk08         LIKE amk_file.amk08,
        amk09         LIKE amk_file.amk09,
        amk10         LIKE amk_file.amk10,
        amk11         LIKE amk_file.amk11,
        amk12         LIKE amk_file.amk12,
        amk13         LIKE amk_file.amk13,
        amk14         LIKE amk_file.amk14,
        amk15         LIKE amk_file.amk15,
        amk16         LIKE amk_file.amk16,
        amk17         LIKE amk_file.amk17,
        amk18         LIKE amk_file.amk18,
        amk19         LIKE amk_file.amk19,
        amk20         LIKE amk_file.amk20,
        amk21         LIKE amk_file.amk21,
        amk22         LIKE amk_file.amk22,
        amk23         LIKE amk_file.amk23,
        amk24         LIKE amk_file.amk24,
        amk25         LIKE amk_file.amk25,
        amk26         LIKE amk_file.amk26,
        amk27         LIKE amk_file.amk27,
        amk28         LIKE amk_file.amk28,
        amk29         LIKE amk_file.amk29,
        amk30         LIKE amk_file.amk30,
        amk31         LIKE amk_file.amk31,
        amk32         LIKE amk_file.amk32,
        amk33         LIKE amk_file.amk33,
        amk34         LIKE amk_file.amk34,
        amk35         LIKE amk_file.amk35,
        amk36         LIKE amk_file.amk36,
        amk37         LIKE amk_file.amk37,
        amk38         LIKE amk_file.amk38,
        amk39         LIKE amk_file.amk39,
        amk40         LIKE amk_file.amk40,
        amk41         LIKE amk_file.amk41,
        amk42         LIKE amk_file.amk42,
        amk43         LIKE amk_file.amk43,
        amk44         LIKE amk_file.amk44,
        amk45         LIKE amk_file.amk45,
        amk46         LIKE amk_file.amk46,
        amk47         LIKE amk_file.amk47,
        amk48         LIKE amk_file.amk48,
        amk49         LIKE amk_file.amk49,
        amk50         LIKE amk_file.amk50,
        amk51         LIKE amk_file.amk51,
        amk52         LIKE amk_file.amk52,
        amk53         LIKE amk_file.amk53,
        amk54         LIKE amk_file.amk54,
        amk55         LIKE amk_file.amk55,
        amk56         LIKE amk_file.amk56,
        amk57         LIKE amk_file.amk57,
        amk58         LIKE amk_file.amk58,
        amk59         LIKE amk_file.amk59,
        amk60         LIKE amk_file.amk60,
        amk61         LIKE amk_file.amk61,
        amk62         LIKE amk_file.amk62,
        amk63         LIKE amk_file.amk63,
        amk64         LIKE amk_file.amk64,
        amk65         LIKE amk_file.amk65,
        amk66         LIKE amk_file.amk66,
        amk67         LIKE amk_file.amk67,
        amk68         LIKE amk_file.amk68,
        amk69         LIKE amk_file.amk69,
        amk70         LIKE amk_file.amk70,
        amk71         LIKE amk_file.amk71,
        amk72         LIKE amk_file.amk72,
        amk73         LIKE amk_file.amk73,
        amk74         LIKE amk_file.amk74,
        amk75         LIKE amk_file.amk75,
        amk76         LIKE amk_file.amk76,
        amk77         LIKE amk_file.amk77
                      END RECORD,
    g_amk_t           RECORD                 #程式變數 (舊值)
        amk01         LIKE amk_file.amk01,
        amk02         LIKE amk_file.amk02,
        amk03         LIKE amk_file.amk03,
        amk04         LIKE amk_file.amk04,
        amk05         LIKE amk_file.amk05,
        amk06         LIKE amk_file.amk06,
        amk07         LIKE amk_file.amk07,
        amk08         LIKE amk_file.amk08,
        amk09         LIKE amk_file.amk09,
        amk10         LIKE amk_file.amk10,
        amk11         LIKE amk_file.amk11,
        amk12         LIKE amk_file.amk12,
        amk13         LIKE amk_file.amk13,
        amk14         LIKE amk_file.amk14,
        amk15         LIKE amk_file.amk15,
        amk16         LIKE amk_file.amk16,
        amk17         LIKE amk_file.amk17,
        amk18         LIKE amk_file.amk18,
        amk19         LIKE amk_file.amk19,
        amk20         LIKE amk_file.amk20,
        amk21         LIKE amk_file.amk21,
        amk22         LIKE amk_file.amk22,
        amk23         LIKE amk_file.amk23,
        amk24         LIKE amk_file.amk24,
        amk25         LIKE amk_file.amk25,
        amk26         LIKE amk_file.amk26,
        amk27         LIKE amk_file.amk27,
        amk28         LIKE amk_file.amk28,
        amk29         LIKE amk_file.amk29,
        amk30         LIKE amk_file.amk30,
        amk31         LIKE amk_file.amk31,
        amk32         LIKE amk_file.amk32,
        amk33         LIKE amk_file.amk33,
        amk34         LIKE amk_file.amk34,
        amk35         LIKE amk_file.amk35,
        amk36         LIKE amk_file.amk36,
        amk37         LIKE amk_file.amk37,
        amk38         LIKE amk_file.amk38,
        amk39         LIKE amk_file.amk39,
        amk40         LIKE amk_file.amk40,
        amk41         LIKE amk_file.amk41,
        amk42         LIKE amk_file.amk42,
        amk43         LIKE amk_file.amk43,
        amk44         LIKE amk_file.amk44,
        amk45         LIKE amk_file.amk45,
        amk46         LIKE amk_file.amk46,
        amk47         LIKE amk_file.amk47,
        amk48         LIKE amk_file.amk48,
        amk49         LIKE amk_file.amk49,
        amk50         LIKE amk_file.amk50,
        amk51         LIKE amk_file.amk51,
        amk52         LIKE amk_file.amk52,
        amk53         LIKE amk_file.amk53,
        amk54         LIKE amk_file.amk54,
        amk55         LIKE amk_file.amk55,
        amk56         LIKE amk_file.amk56,
        amk57         LIKE amk_file.amk57,
        amk58         LIKE amk_file.amk58,
        amk59         LIKE amk_file.amk59,
        amk60         LIKE amk_file.amk60,
        amk61         LIKE amk_file.amk61,
        amk62         LIKE amk_file.amk62,
        amk63         LIKE amk_file.amk63,
        amk64         LIKE amk_file.amk64,
        amk65         LIKE amk_file.amk65,
        amk66         LIKE amk_file.amk66,
        amk67         LIKE amk_file.amk67,
        amk68         LIKE amk_file.amk68,
        amk69         LIKE amk_file.amk69,
        amk70         LIKE amk_file.amk70,
        amk71         LIKE amk_file.amk71,
        amk72         LIKE amk_file.amk72,
        amk73         LIKE amk_file.amk73,
        amk74         LIKE amk_file.amk74,
        amk75         LIKE amk_file.amk75,
        amk76         LIKE amk_file.amk76,
        amk77         LIKE amk_file.amk77  
                      END RECORD
DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  
DEFINE   g_before_input_done   LIKE type_file.num5 #No.FUN-680102 SMALLINT
DEFINE   g_cnt        LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_i          LIKE type_file.num5          #count/index for any purpose
DEFINE   g_msg        LIKE type_file.chr1000       #No.FUN-680102 CHAR(72)
DEFINE   g_row_count  LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_curs_index LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   g_jump       LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE   l_table      STRING                       #No.FUN-760083
DEFINE   g_str        STRING                       #No.FUN-760083
DEFINE   g_wc,g_sql   STRING
DEFINE   g_argv1      LIKE amk_file.amk01
#主程式開始
MAIN
   DEFINE
      p_row,p_col     LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET g_argv1 = ARG_VAL(1)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMD")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_amk.* TO NULL
   INITIALIZE g_amk_t.* TO NULL
 

   LET g_forupd_sql = " SELECT amk01,amk02,amk03,amk04,amk05,amk06,amk07,amk08,amk09,amk10",
                             ",amk11,amk12,amk13,amk14,amk15,amk16,amk17,amk18,amk19,amk20",
                             ",amk21,amk22,amk23,amk24,amk25,amk26,amk27,amk28,amk29,amk30",
                             ",amk31,amk32,amk33,amk34,amk35,amk36,amk37,amk38,amk39,amk40",
                             ",amk41,amk42,amk43,amk44,amk45,amk46,amk47,amk48,amk49,amk50",
                             ",amk51,amk52,amk53,amk54,amk55,amk56,amk57,amk58,amk59,amk60",
                             ",amk61,amk62,amk63,amk64,amk65,amk66,amk67,amk68,amk69,amk70",
                             ",amk71,amk72,amk73,amk74,amk75,amk76,amk77",
                        " FROM amk_file",
                       " WHERE amk01=? AND amk02=? AND amk03=? FOR UPDATE"                                                          
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t001_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR    
   LET p_row = 4 LET p_col = 14
   OPEN WINDOW t001_w AT p_row,p_col
        WITH FORM "amd/42f/amdt001"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   IF NOT cl_null(g_argv1) THEN CALL t001_q() END IF

   LET g_action_choice=""
   CALL t001_menu()
 
   CLOSE WINDOW t001_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
FUNCTION t001_i(p_cmd)
DEFINE l_n         LIKE type_file.num5
DEFINE l_n1        LIKE type_file.num20_6
DEFINE p_cmd       LIKE type_file.chr8  
DEFINE li_result   LIKE type_file.num5

   IF s_shut(0) THEN	
      RETURN	
   END IF	
 	
   DISPLAY BY NAME g_amk.amk04,g_amk.amk05,g_amk.amk06,g_amk.amk07,g_amk.amk08,g_amk.amk09,	
                   g_amk.amk10,g_amk.amk11,g_amk.amk12,g_amk.amk13,g_amk.amk14,g_amk.amk15,	
                   g_amk.amk16,g_amk.amk17,g_amk.amk18,g_amk.amk19,g_amk.amk20,g_amk.amk21,	
                   g_amk.amk22,g_amk.amk23,g_amk.amk24,g_amk.amk25,g_amk.amk26,g_amk.amk27,	
                   g_amk.amk28,g_amk.amk29,g_amk.amk30,g_amk.amk31,g_amk.amk32,g_amk.amk33,	
                   g_amk.amk34,g_amk.amk35,g_amk.amk36,g_amk.amk37,g_amk.amk38,g_amk.amk39,	
                   g_amk.amk40,g_amk.amk41,g_amk.amk42,g_amk.amk43,g_amk.amk44,g_amk.amk45,	
                   g_amk.amk46,g_amk.amk47,g_amk.amk48,g_amk.amk49,g_amk.amk50,g_amk.amk51,	
                   g_amk.amk52,g_amk.amk53,g_amk.amk54,g_amk.amk55,g_amk.amk56,g_amk.amk57,	
                   g_amk.amk58,g_amk.amk59,g_amk.amk60,g_amk.amk61,g_amk.amk62,g_amk.amk63,	
                   g_amk.amk64,g_amk.amk65,g_amk.amk66,g_amk.amk67,g_amk.amk68,g_amk.amk69,	
                   g_amk.amk70,g_amk.amk71,g_amk.amk72,g_amk.amk73,g_amk.amk74,g_amk.amk75,	
                   g_amk.amk76,g_amk.amk77	
 	
   INPUT BY NAME   g_amk.amk05,g_amk.amk06,g_amk.amk09,g_amk.amk11,g_amk.amk12,g_amk.amk15,	
                   g_amk.amk17,g_amk.amk18,g_amk.amk21,g_amk.amk23,g_amk.amk24,g_amk.amk27,	
                   g_amk.amk29,g_amk.amk30,g_amk.amk33,g_amk.amk35,g_amk.amk36,g_amk.amk39,	
                   g_amk.amk41,g_amk.amk42,g_amk.amk45,g_amk.amk47,g_amk.amk48,g_amk.amk51,	
                   g_amk.amk53,g_amk.amk54,g_amk.amk57,g_amk.amk59,g_amk.amk60,g_amk.amk63	
       WITHOUT DEFAULTS	
 	
      AFTER FIELD amk05	
         IF NOT cl_null(g_amk.amk05) AND NOT cl_null(g_amk.amk06) AND NOT cl_null(g_amk.amk09)  THEN	
            LET l_n = g_amk.amk05 + g_amk.amk06 + g_amk.amk09	
            IF l_n != g_amk.amk04 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk05,g_amk.amk17,g_amk.amk29,g_amk.amk41,g_amk.amk53) RETURNING g_amk.amk65	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk65,g_amk.amk76	
	 
      AFTER FIELD amk06	
         IF NOT cl_null(g_amk.amk06) THEN	
            CALL i001_temp(g_amk.amk06) RETURNING g_amk.amk07	
            LET g_amk.amk08 = g_amk.amk06 - g_amk.amk07	
         ELSE	
            LET g_amk.amk07 = NULL	
            LET g_amk.amk08 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk05) AND NOT cl_null(g_amk.amk06) AND NOT cl_null(g_amk.amk09)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk05 + g_amk.amk06 + g_amk.amk09	
            IF l_n != g_amk.amk04 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk06,g_amk.amk18,g_amk.amk30,g_amk.amk42,g_amk.amk54) RETURNING g_amk.amk66	
         CALL i001_sum(g_amk.amk07,g_amk.amk19,g_amk.amk31,g_amk.amk43,g_amk.amk55) RETURNING g_amk.amk67	
         CALL i001_sum(g_amk.amk08,g_amk.amk20,g_amk.amk32,g_amk.amk44,g_amk.amk56) RETURNING g_amk.amk68	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk07,g_amk.amk08,g_amk.amk66,g_amk.amk67,g_amk.amk68,g_amk.amk76	
	
      AFTER FIELD amk09	
         IF NOT cl_null(g_amk.amk05) AND NOT cl_null(g_amk.amk06) AND NOT cl_null(g_amk.amk09)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk05 + g_amk.amk06 + g_amk.amk09	
            IF l_n != g_amk.amk04 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk09,g_amk.amk21,g_amk.amk33,g_amk.amk45,g_amk.amk57) RETURNING g_amk.amk69	
         DISPLAY BY NAME g_amk.amk69	
	
      AFTER FIELD amk11	
         IF NOT cl_null(g_amk.amk11) AND NOT cl_null(g_amk.amk12) AND NOT cl_null(g_amk.amk15)  THEN	
            LET l_n = 0	
            IF g_amk.amk11 ! = g_amk.amk11 + g_amk.amk12 + g_amk.amk15 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk11,g_amk.amk23,g_amk.amk35,g_amk.amk47,g_amk.amk59) RETURNING g_amk.amk71	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk71,g_amk.amk76	
	
      AFTER FIELD amk12	
         IF NOT cl_null(g_amk.amk12) THEN	
            CALL i001_temp(g_amk.amk12) RETURNING g_amk.amk13	
            LET g_amk.amk14 = g_amk.amk12 - g_amk.amk13	
         ELSE	
            LET g_amk.amk12 = NULL	
            LET g_amk.amk13 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk11) AND NOT cl_null(g_amk.amk12) AND NOT cl_null(g_amk.amk15)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk11 + g_amk.amk12 + g_amk.amk15	
            IF l_n != g_amk.amk10 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk12,g_amk.amk24,g_amk.amk36,g_amk.amk48,g_amk.amk60) RETURNING g_amk.amk72	
         CALL i001_sum(g_amk.amk13,g_amk.amk25,g_amk.amk37,g_amk.amk49,g_amk.amk61) RETURNING g_amk.amk73	
         CALL i001_sum(g_amk.amk14,g_amk.amk26,g_amk.amk38,g_amk.amk50,g_amk.amk62) RETURNING g_amk.amk74	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk13,g_amk.amk14,g_amk.amk72,g_amk.amk73,g_amk.amk74,g_amk.amk76	
	
      AFTER FIELD amk15	
         IF NOT cl_null(g_amk.amk11) AND NOT cl_null(g_amk.amk12) AND NOT cl_null(g_amk.amk15)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk11 + g_amk.amk12 + g_amk.amk15	
            IF l_n != g_amk.amk10 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk15,g_amk.amk27,g_amk.amk39,g_amk.amk51,g_amk.amk63) RETURNING g_amk.amk75	
         DISPLAY BY NAME g_amk.amk75	
	
      AFTER FIELD amk17	
         IF NOT cl_null(g_amk.amk17) AND NOT cl_null(g_amk.amk18) AND NOT cl_null(g_amk.amk21)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk17 + g_amk.amk18 + g_amk.amk19	
            IF l_n != g_amk.amk16 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk05,g_amk.amk17,g_amk.amk29,g_amk.amk41,g_amk.amk53) RETURNING g_amk.amk65	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk65,g_amk.amk76	
	
      AFTER FIELD amk18	
         IF NOT cl_null(g_amk.amk18) THEN	
            CALL i001_temp(g_amk.amk18) RETURNING g_amk.amk19	
            LET g_amk.amk20 = g_amk.amk18 - g_amk.amk19	
         ELSE	
            LET g_amk.amk18 = NULL	
            LET g_amk.amk19 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk17) AND NOT cl_null(g_amk.amk18) AND NOT cl_null(g_amk.amk21)  THEN	
         LET l_n = 0	
         LET l_n = g_amk.amk17 + g_amk.amk18 + g_amk.amk19	
         IF l_n != g_amk.amk16 THEN	
            CALL cl_err('','amd-034',0)	
         END IF	
      END IF	
      CALL i001_sum(g_amk.amk06,g_amk.amk18,g_amk.amk30,g_amk.amk42,g_amk.amk54) RETURNING g_amk.amk66	
      CALL i001_sum(g_amk.amk07,g_amk.amk19,g_amk.amk31,g_amk.amk43,g_amk.amk55) RETURNING g_amk.amk67	
      CALL i001_sum(g_amk.amk08,g_amk.amk20,g_amk.amk32,g_amk.amk44,g_amk.amk56) RETURNING g_amk.amk68	
     #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
      LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
      DISPLAY BY NAME g_amk.amk19,g_amk.amk20,g_amk.amk66,g_amk.amk67,g_amk.amk68,g_amk.amk76	
	
      AFTER FIELD amk21	
         IF NOT cl_null(g_amk.amk17) AND NOT cl_null(g_amk.amk18) AND NOT cl_null(g_amk.amk21)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk17 + g_amk.amk18 + g_amk.amk19	
            IF l_n != g_amk.amk16 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk09,g_amk.amk21,g_amk.amk33,g_amk.amk45,g_amk.amk57) RETURNING g_amk.amk69	
         DISPLAY BY NAME g_amk.amk69	
	
      AFTER FIELD amk23	
         IF NOT cl_null(g_amk.amk23) AND NOT cl_null(g_amk.amk24) AND NOT cl_null(g_amk.amk27)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk23 + g_amk.amk24 + g_amk.amk27	
            IF l_n != g_amk.amk22 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk11,g_amk.amk23,g_amk.amk35,g_amk.amk47,g_amk.amk59) RETURNING g_amk.amk71	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk71,g_amk.amk76	
	
      AFTER FIELD amk24	
         IF NOT cl_null(g_amk.amk24) THEN	
            CALL i001_temp(g_amk.amk24) RETURNING g_amk.amk25	
            LET g_amk.amk26 = g_amk.amk24 - g_amk.amk25	
         ELSE	
            LET g_amk.amk24 = NULL	
            LET g_amk.amk25 = NULL 	
         END IF	
         IF NOT cl_null(g_amk.amk23) AND NOT cl_null(g_amk.amk24) AND NOT cl_null(g_amk.amk27)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk23 + g_amk.amk24 + g_amk.amk27	
            IF l_n != g_amk.amk22 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk12,g_amk.amk24,g_amk.amk36,g_amk.amk48,g_amk.amk60) RETURNING g_amk.amk72	
         CALL i001_sum(g_amk.amk13,g_amk.amk25,g_amk.amk37,g_amk.amk49,g_amk.amk61) RETURNING g_amk.amk73	
         CALL i001_sum(g_amk.amk14,g_amk.amk26,g_amk.amk38,g_amk.amk50,g_amk.amk62) RETURNING g_amk.amk74	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk25,g_amk.amk26,g_amk.amk72,g_amk.amk73,g_amk.amk74,g_amk.amk76	
	
      AFTER FIELD amk27	
         IF NOT cl_null(g_amk.amk23) AND NOT cl_null(g_amk.amk24) AND NOT cl_null(g_amk.amk27)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk23 + g_amk.amk24 + g_amk.amk27	
            IF l_n != g_amk.amk22 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk15,g_amk.amk27,g_amk.amk39,g_amk.amk51,g_amk.amk63) RETURNING g_amk.amk75	
         DISPLAY BY NAME g_amk.amk75	
	
      AFTER FIELD amk29	
         IF NOT cl_null(g_amk.amk29) AND NOT cl_null(g_amk.amk30) AND NOT cl_null(g_amk.amk33)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk29 + g_amk.amk30 + g_amk.amk33	
            IF l_n != g_amk.amk28 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk05,g_amk.amk17,g_amk.amk29,g_amk.amk41,g_amk.amk53) RETURNING g_amk.amk65	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk65,g_amk.amk76	
	
      AFTER FIELD amk30	
         IF NOT cl_null(g_amk.amk30) THEN	
            CALL i001_temp(g_amk.amk30) RETURNING g_amk.amk31	
            LET g_amk.amk32 = g_amk.amk30 - g_amk.amk31	
         ELSE	
            LET g_amk.amk30 = NULL	
            LET g_amk.amk31 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk29) AND NOT cl_null(g_amk.amk30) AND NOT cl_null(g_amk.amk33)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk29 + g_amk.amk30 + g_amk.amk33	
            IF l_n != g_amk.amk28 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk06,g_amk.amk18,g_amk.amk30,g_amk.amk42,g_amk.amk54) RETURNING g_amk.amk66	
         CALL i001_sum(g_amk.amk07,g_amk.amk19,g_amk.amk31,g_amk.amk43,g_amk.amk55) RETURNING g_amk.amk67	
         CALL i001_sum(g_amk.amk08,g_amk.amk20,g_amk.amk32,g_amk.amk44,g_amk.amk56) RETURNING g_amk.amk68	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk31,g_amk.amk32,g_amk.amk66,g_amk.amk67,g_amk.amk68,g_amk.amk76	
	
      AFTER FIELD amk33	
         IF NOT cl_null(g_amk.amk29) AND NOT cl_null(g_amk.amk30) AND NOT cl_null(g_amk.amk33)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk29 + g_amk.amk30 + g_amk.amk33	
            IF l_n != g_amk.amk28 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk09,g_amk.amk21,g_amk.amk33,g_amk.amk45,g_amk.amk57) RETURNING g_amk.amk69	
         DISPLAY BY NAME g_amk.amk69	
	
      AFTER FIELD amk35	
         IF NOT cl_null(g_amk.amk35) AND NOT cl_null(g_amk.amk36) AND NOT cl_null(g_amk.amk39)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk35 + g_amk.amk36 + g_amk.amk39	
            IF l_n != g_amk.amk34 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk11,g_amk.amk23,g_amk.amk35,g_amk.amk47,g_amk.amk59) RETURNING g_amk.amk71	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk71,g_amk.amk76	
	
      AFTER FIELD amk36	
         IF NOT cl_null(g_amk.amk36) THEN	
            CALL i001_temp(g_amk.amk36) RETURNING g_amk.amk37	
            LET g_amk.amk38 = g_amk.amk36 - g_amk.amk37	
         ELSE	
            LET g_amk.amk36 = NULL	
            LET g_amk.amk37 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk35) AND NOT cl_null(g_amk.amk36) AND NOT cl_null(g_amk.amk39)  THEN	
         LET l_n = 0	
         LET l_n = g_amk.amk35 + g_amk.amk36 + g_amk.amk39	
         IF l_n != g_amk.amk34 THEN	
            CALL cl_err('','amd-034',0)	
         END IF	
      END IF	
      CALL i001_sum(g_amk.amk12,g_amk.amk24,g_amk.amk36,g_amk.amk48,g_amk.amk60) RETURNING g_amk.amk72	
      CALL i001_sum(g_amk.amk13,g_amk.amk25,g_amk.amk37,g_amk.amk49,g_amk.amk61) RETURNING g_amk.amk73	
      CALL i001_sum(g_amk.amk14,g_amk.amk26,g_amk.amk38,g_amk.amk50,g_amk.amk62) RETURNING g_amk.amk74	
     #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
      LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
      DISPLAY BY NAME g_amk.amk37,g_amk.amk38,g_amk.amk72,g_amk.amk73,g_amk.amk74,g_amk.amk76	
	
      AFTER FIELD amk39	
         IF NOT cl_null(g_amk.amk41) AND NOT cl_null(g_amk.amk42) AND NOT cl_null(g_amk.amk45)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk41 + g_amk.amk42 + g_amk.amk45	
            IF l_n != g_amk.amk40 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk05,g_amk.amk17,g_amk.amk29,g_amk.amk41,g_amk.amk53) RETURNING g_amk.amk65	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk65,g_amk.amk76	
	
      AFTER FIELD amk41	
         IF NOT cl_null(g_amk.amk41) AND NOT cl_null(g_amk.amk42) AND NOT cl_null(g_amk.amk45)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk41 + g_amk.amk42 + g_amk.amk45	
            IF l_n != g_amk.amk40 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk05,g_amk.amk17,g_amk.amk29,g_amk.amk41,g_amk.amk53) RETURNING g_amk.amk65	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk65,g_amk.amk72	
	
      AFTER FIELD amk42	
         IF NOT cl_null(g_amk.amk42) THEN	
            CALL i001_temp(g_amk.amk42) RETURNING g_amk.amk43	
            LET g_amk.amk44 = g_amk.amk42 - g_amk.amk43	
         ELSE	
            LET g_amk.amk42 = NULL	
            LET g_amk.amk43 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk41) AND NOT cl_null(g_amk.amk42) AND NOT cl_null(g_amk.amk45)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk41 + g_amk.amk42 + g_amk.amk45	
            IF l_n != g_amk.amk40 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
      CALL i001_sum(g_amk.amk06,g_amk.amk18,g_amk.amk30,g_amk.amk42,g_amk.amk54) RETURNING g_amk.amk66	
      CALL i001_sum(g_amk.amk07,g_amk.amk19,g_amk.amk31,g_amk.amk43,g_amk.amk55) RETURNING g_amk.amk67	
      CALL i001_sum(g_amk.amk08,g_amk.amk20,g_amk.amk32,g_amk.amk44,g_amk.amk56) RETURNING g_amk.amk68	
     #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
      LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
      DISPLAY BY NAME g_amk.amk43,g_amk.amk44,g_amk.amk66,g_amk.amk67,g_amk.amk68,g_amk.amk76	
	
      AFTER FIELD amk45	
         IF NOT cl_null(g_amk.amk41) AND NOT cl_null(g_amk.amk42) AND NOT cl_null(g_amk.amk45)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk41 + g_amk.amk42 + g_amk.amk45	
            IF l_n != g_amk.amk40 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk09,g_amk.amk21,g_amk.amk33,g_amk.amk45,g_amk.amk57) RETURNING g_amk.amk69	
         DISPLAY BY NAME g_amk.amk69	
	
      AFTER FIELD amk47	
         IF NOT cl_null(g_amk.amk47) AND NOT cl_null(g_amk.amk48) AND NOT cl_null(g_amk.amk51)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk47 + g_amk.amk48 + g_amk.amk51	
            IF l_n != g_amk.amk46 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk11,g_amk.amk23,g_amk.amk35,g_amk.amk47,g_amk.amk59) RETURNING g_amk.amk71	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk71,g_amk.amk76	
	
      AFTER FIELD amk48	
         IF NOT cl_null(g_amk.amk48) THEN	
            CALL i001_temp(g_amk.amk48) RETURNING g_amk.amk49	
            LET g_amk.amk50 = g_amk.amk48 - g_amk.amk49	
         ELSE	
            LET g_amk.amk48 = NULL	
            LET g_amk.amk49 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk47) AND NOT cl_null(g_amk.amk48) AND NOT cl_null(g_amk.amk51)  THEN	
         LET l_n = 0	
         LET l_n = g_amk.amk47 + g_amk.amk48 + g_amk.amk51	
            IF l_n != g_amk.amk46 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
        END IF	
         CALL i001_sum(g_amk.amk12,g_amk.amk24,g_amk.amk36,g_amk.amk48,g_amk.amk60) RETURNING g_amk.amk72	
         CALL i001_sum(g_amk.amk13,g_amk.amk25,g_amk.amk37,g_amk.amk49,g_amk.amk61) RETURNING g_amk.amk73	
         CALL i001_sum(g_amk.amk14,g_amk.amk26,g_amk.amk38,g_amk.amk50,g_amk.amk62) RETURNING g_amk.amk74	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk49,g_amk.amk50,g_amk.amk72,g_amk.amk73,g_amk.amk74,g_amk.amk76	
	
      AFTER FIELD amk51	
         IF NOT cl_null(g_amk.amk47) AND NOT cl_null(g_amk.amk48) AND NOT cl_null(g_amk.amk51)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk47 + g_amk.amk48 + g_amk.amk51	
            IF l_n != g_amk.amk46 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk15,g_amk.amk27,g_amk.amk39,g_amk.amk51,g_amk.amk63) RETURNING g_amk.amk75	
         DISPLAY BY NAME g_amk.amk75	
	
      AFTER FIELD amk53	
         IF NOT cl_null(g_amk.amk53) AND NOT cl_null(g_amk.amk54) AND NOT cl_null(g_amk.amk57)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk53 + g_amk.amk54 + g_amk.amk57	
            IF l_n != g_amk.amk52 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk05,g_amk.amk17,g_amk.amk29,g_amk.amk41,g_amk.amk53) RETURNING g_amk.amk65	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk65,g_amk.amk76	
	
      AFTER FIELD amk54	
         IF NOT cl_null(g_amk.amk54) THEN	
            CALL i001_temp(g_amk.amk54) RETURNING g_amk.amk55	
            LET g_amk.amk56 = g_amk.amk54 - g_amk.amk55	
         ELSE	
            LET g_amk.amk54 = NULL	
            LET g_amk.amk55 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk53) AND NOT cl_null(g_amk.amk54) AND NOT cl_null(g_amk.amk57)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk53 + g_amk.amk54 + g_amk.amk57	
            IF l_n != g_amk.amk52 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk06,g_amk.amk18,g_amk.amk30,g_amk.amk42,g_amk.amk54) RETURNING g_amk.amk66	
         CALL i001_sum(g_amk.amk07,g_amk.amk19,g_amk.amk31,g_amk.amk43,g_amk.amk55) RETURNING g_amk.amk67	
         CALL i001_sum(g_amk.amk08,g_amk.amk20,g_amk.amk32,g_amk.amk44,g_amk.amk56) RETURNING g_amk.amk68	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk55,g_amk.amk56,g_amk.amk66,g_amk.amk67,g_amk.amk68,g_amk.amk76	
	
      AFTER FIELD amk57	
         IF NOT cl_null(g_amk.amk59) AND NOT cl_null(g_amk.amk60) AND NOT cl_null(g_amk.amk63)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk59 + g_amk.amk60 + g_amk.amk63	
            IF l_n != g_amk.amk58 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk11,g_amk.amk23,g_amk.amk35,g_amk.amk47,g_amk.amk59) RETURNING g_amk.amk71	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk71,g_amk.amk76	
	
      AFTER FIELD amk59	
         IF NOT cl_null(g_amk.amk59) AND NOT cl_null(g_amk.amk60) AND NOT cl_null(g_amk.amk63)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk59 + g_amk.amk60 + g_amk.amk63	
            IF l_n != g_amk.amk58 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk11,g_amk.amk23,g_amk.amk35,g_amk.amk47,g_amk.amk59) RETURNING g_amk.amk71	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk71,g_amk.amk76	
	
      AFTER FIELD amk60	
         IF NOT cl_null(g_amk.amk60) THEN	
            CALL i001_temp(g_amk.amk60) RETURNING g_amk.amk61	
            LET g_amk.amk62 = g_amk.amk60 - g_amk.amk61	
         ELSE	
            LET g_amk.amk60 = NULL	
            LET g_amk.amk61 = NULL	
         END IF	
         IF NOT cl_null(g_amk.amk59) AND NOT cl_null(g_amk.amk60) AND NOT cl_null(g_amk.amk63)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk59 + g_amk.amk60 + g_amk.amk63	
            IF l_n != g_amk.amk58 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk12,g_amk.amk24,g_amk.amk36,g_amk.amk48,g_amk.amk60) RETURNING g_amk.amk72	
         CALL i001_sum(g_amk.amk13,g_amk.amk25,g_amk.amk37,g_amk.amk49,g_amk.amk61) RETURNING g_amk.amk73	
         CALL i001_sum(g_amk.amk14,g_amk.amk26,g_amk.amk38,g_amk.amk50,g_amk.amk62) RETURNING g_amk.amk74	
        #LET g_amk.amk76 = g_amk.amk65 + g_amk.amk66 + g_amk.amk71 + g_amk.amk72        #MOD-C20236 mark
         LET g_amk.amk76 = g_amk.amk65 + g_amk.amk67 + g_amk.amk71 + g_amk.amk73        #MOD-C20236 add
         DISPLAY BY NAME g_amk.amk61,g_amk.amk62,g_amk.amk72,g_amk.amk73,g_amk.amk74,g_amk.amk76	
	
      AFTER FIELD amk63	
         IF NOT cl_null(g_amk.amk59) AND NOT cl_null(g_amk.amk60) AND NOT cl_null(g_amk.amk63)  THEN	
            LET l_n = 0	
            LET l_n = g_amk.amk59 + g_amk.amk60 + g_amk.amk63	
            IF l_n != g_amk.amk58 THEN	
               CALL cl_err('','amd-034',0)	
            END IF	
         END IF	
         CALL i001_sum(g_amk.amk15,g_amk.amk27,g_amk.amk39,g_amk.amk51,g_amk.amk63) RETURNING g_amk.amk75	
         DISPLAY BY NAME g_amk.amk75	
	
      ON ACTION CONTROLG	
         CALL cl_cmdask()	
 	
      ON IDLE g_idle_seconds	
         CALL cl_on_idle()	
         CONTINUE INPUT	
 	
      ON ACTION about          	
         CALL cl_about()       	
 	
      ON ACTION help           	
         CALL cl_show_help()   	
 	
      AFTER INPUT	
         IF INT_FLAG THEN	
            LET INT_FLAG = 0	
            LET g_amk.amk05 = g_amk_t.amk05	
            LET g_amk.amk06 = g_amk_t.amk06	
            LET g_amk.amk09 = g_amk_t.amk09	
      	
            LET g_amk.amk11 = g_amk_t.amk11	
            LET g_amk.amk12 = g_amk_t.amk12	
            LET g_amk.amk15 = g_amk_t.amk15	
	
            LET g_amk.amk17 = g_amk_t.amk17	
            LET g_amk.amk18 = g_amk_t.amk18	
            LET g_amk.amk21 = g_amk_t.amk21	
	
            LET g_amk.amk23 = g_amk_t.amk23	
            LET g_amk.amk24 = g_amk_t.amk24	
            LET g_amk.amk27 = g_amk_t.amk27	
	
            LET g_amk.amk29 = g_amk_t.amk29	
            LET g_amk.amk30 = g_amk_t.amk30	
            LET g_amk.amk33 = g_amk_t.amk33	
	
            LET g_amk.amk35 = g_amk_t.amk35	
            LET g_amk.amk36 = g_amk_t.amk36	
            LET g_amk.amk39 = g_amk_t.amk39	
	
            LET g_amk.amk41 = g_amk_t.amk41	
            LET g_amk.amk42 = g_amk_t.amk42	
            LET g_amk.amk45 = g_amk_t.amk45	
	
            LET g_amk.amk47 = g_amk_t.amk47	
            LET g_amk.amk48 = g_amk_t.amk48	
            LET g_amk.amk51 = g_amk_t.amk51	
	
            LET g_amk.amk53 = g_amk_t.amk53	
            LET g_amk.amk54 = g_amk_t.amk54	
            LET g_amk.amk57 = g_amk_t.amk57	
	
            LET g_amk.amk59 = g_amk_t.amk59	
            LET g_amk.amk60 = g_amk_t.amk60	
            LET g_amk.amk63 = g_amk_t.amk63	
            RETURN	
         END IF	
         IF g_amk.amk04 != g_amk.amk05 + g_amk.amk06 + g_amk.amk09 THEN	
             CALL cl_err('','amd-034',1)	
             NEXT FIELD amk05	
         END IF	
         IF g_amk.amk10 != g_amk.amk11 + g_amk.amk12 + g_amk.amk15 THEN	
             CALL cl_err('','amd-034',1)	
             NEXT FIELD amk11	
         END IF	
         IF g_amk.amk16 != g_amk.amk17 + g_amk.amk18 + g_amk.amk21 THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk17	
         END IF	
         IF g_amk.amk22 != g_amk.amk23 + g_amk.amk24 + g_amk.amk27 THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk23 	
         END IF	
         IF g_amk.amk28 != g_amk.amk29 + g_amk.amk30 + g_amk.amk33 THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk29	
         END IF	
         IF g_amk.amk34 != g_amk.amk35 + g_amk.amk36 + g_amk.amk39 THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk35	
         END IF	
         IF g_amk.amk40 != g_amk.amk41 + g_amk.amk42 + g_amk.amk45 THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk41	
         END IF	
         IF g_amk.amk46 != g_amk.amk47 + g_amk.amk48 + g_amk.amk51  THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk47	
         END IF	
         IF g_amk.amk52 != g_amk.amk53 + g_amk.amk54 + g_amk.amk57 THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk53	
         END IF	
         IF g_amk.amk58 != g_amk.amk59 + g_amk.amk60 + g_amk.amk63 THEN	
            CALL cl_err('','amd-034',1)	
            NEXT FIELD amk59	
         END IF	
   END INPUT	
END FUNCTION	

FUNCTION t001_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_amk.amk01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF
   SELECT amk01,amk02,amk03,amk04,amk05,amk06,amk07,amk08,amk09,amk10
         ,amk11,amk12,amk13,amk14,amk15,amk16,amk17,amk18,amk19,amk20
         ,amk21,amk22,amk23,amk24,amk25,amk26,amk27,amk28,amk29,amk30
         ,amk31,amk32,amk33,amk34,amk35,amk36,amk37,amk38,amk39,amk40
         ,amk41,amk42,amk43,amk44,amk45,amk46,amk47,amk48,amk49,amk50
         ,amk51,amk52,amk53,amk54,amk55,amk56,amk57,amk58,amk59,amk60
         ,amk61,amk62,amk63,amk64,amk65,amk66,amk67,amk68,amk69,amk70
         ,amk71,amk72,amk73,amk74,amk75,amk76,amk77
     INTO g_amk.* FROM amk_file WHERE amk01=g_amk.amk01
                                  AND amk02=g_amk.amk02
                                  AND amk03=g_amk.amk03
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_amk_t.* = g_amk.*
    BEGIN WORK
 
    OPEN t001_cl USING g_amk.amk01,g_amk.amk02,g_amk.amk03
    IF STATUS THEN
       CALL cl_err("OPEN t001_cl:", STATUS, 1)
       CLOSE t001_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t001_cl INTO g_amk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amk.amk01,SQLCA.sqlcode,0)
        RETURN
    END IF

    CALL t001_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t001_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_amk.*=g_amk_t.*
           CALL t001_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE amk_file SET amk04 = g_amk.amk04,amk05 = g_amk.amk05,amk06 = g_amk.amk06
                           ,amk07 = g_amk.amk07,amk08 = g_amk.amk08,amk09 = g_amk.amk09
                           ,amk10 = g_amk.amk10,amk11 = g_amk.amk11,amk12 = g_amk.amk12
                           ,amk13 = g_amk.amk13,amk14 = g_amk.amk14,amk15 = g_amk.amk15
                           ,amk16 = g_amk.amk16,amk17 = g_amk.amk17,amk18 = g_amk.amk18
                           ,amk19 = g_amk.amk19,amk20 = g_amk.amk20,amk21 = g_amk.amk21
                           ,amk22 = g_amk.amk22,amk23 = g_amk.amk23,amk24 = g_amk.amk24
                           ,amk25 = g_amk.amk25,amk26 = g_amk.amk26,amk27 = g_amk.amk27
                           ,amk28 = g_amk.amk28,amk29 = g_amk.amk29,amk30 = g_amk.amk30
                           ,amk31 = g_amk.amk31,amk32 = g_amk.amk32,amk33 = g_amk.amk33
                           ,amk34 = g_amk.amk34,amk35 = g_amk.amk35,amk36 = g_amk.amk36
                           ,amk37 = g_amk.amk37,amk38 = g_amk.amk38,amk39 = g_amk.amk39
                           ,amk40 = g_amk.amk40,amk41 = g_amk.amk41,amk42 = g_amk.amk42
                           ,amk43 = g_amk.amk43,amk44 = g_amk.amk44,amk45 = g_amk.amk45
                           ,amk46 = g_amk.amk46,amk47 = g_amk.amk47,amk48 = g_amk.amk48
                           ,amk49 = g_amk.amk49,amk50 = g_amk.amk50,amk51 = g_amk.amk51
                           ,amk52 = g_amk.amk52,amk53 = g_amk.amk53,amk54 = g_amk.amk54
                           ,amk55 = g_amk.amk55,amk56 = g_amk.amk56,amk57 = g_amk.amk57
                           ,amk58 = g_amk.amk58,amk59 = g_amk.amk59,amk60 = g_amk.amk60
                           ,amk61 = g_amk.amk61,amk62 = g_amk.amk62,amk63 = g_amk.amk63
                           ,amk64 = g_amk.amk64,amk65 = g_amk.amk65,amk66 = g_amk.amk66
                           ,amk67 = g_amk.amk67,amk68 = g_amk.amk68,amk69 = g_amk.amk69
                           ,amk70 = g_amk.amk70,amk71 = g_amk.amk71,amk72 = g_amk.amk72
                           ,amk73 = g_amk.amk73,amk74 = g_amk.amk74,amk75 = g_amk.amk75
                           ,amk76 = g_amk.amk76,amk77 = g_amk.amk77
         WHERE amk01=g_amk.amk01 AND amk02=g_amk.amk02 AND amk03=g_amk.amk03
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","amk_file",g_amk_t.amk01,g_amk_t.amk02,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t001_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t001_cs()
    CLEAR FORM
    INITIALIZE g_amk.* TO NULL
    IF cl_null(g_argv1) THEN
       CONSTRUCT BY NAME g_wc ON amk01,amk02,amk03
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
             ON ACTION controlp                        # 查詢其他主檔資料
          CASE
             WHEN INFIELD(amk01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO amk01
                NEXT FIELD amk01
             END CASE
   
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
    
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
    
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
    
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
   
          ON ACTION qbe_select
             CALL cl_qbe_select()
   
          ON ACTION qbe_save
             CALL cl_qbe_save()
   
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = " amk01 = '",g_argv1 CLIPPED,"'"
    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('amkuser', 'amkgrup')
 
    LET g_sql="SELECT amk01,amk02,amk03,amk04,amk05,amk06,amk07,amk08,amk09,amk10"
                   ,",amk11,amk12,amk13,amk14,amk15,amk16,amk17,amk18,amk19,amk20"
                   ,",amk21,amk22,amk23,amk24,amk25,amk26,amk27,amk28,amk29,amk30"
                   ,",amk31,amk32,amk33,amk34,amk35,amk36,amk37,amk38,amk39,amk40"
                   ,",amk41,amk42,amk43,amk44,amk45,amk46,amk47,amk48,amk49,amk50"
                   ,",amk51,amk52,amk53,amk54,amk55,amk56,amk57,amk58,amk59,amk60"
                   ,",amk61,amk62,amk63,amk64,amk65,amk66,amk67,amk68,amk69,amk70"
                   ,",amk71,amk72,amk73,amk74,amk75,amk76,amk77"
              ," FROM amk_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY amk01"
    PREPARE t001_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t001cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t001_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM amk_file WHERE ",g_wc CLIPPED
    PREPARE t001_precount FROM g_sql
    DECLARE t001_count CURSOR FOR t001_precount
END FUNCTION
 
FUNCTION t001_menu()
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t001_q()
            END IF
        ON ACTION next
            CALL t001_fetch('N')
        ON ACTION previous
            CALL t001_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t001_u()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL t001_fetch('/')
        ON ACTION first
           CALL t001_fetch('F')
        ON ACTION last
           CALL t001_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()

        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION close
            LET INT_FLAG=FALSE
            LET g_action_choice = "exit"
            EXIT MENU

    END MENU
    CLOSE t001cs
END FUNCTION

FUNCTION t001_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_amk.* TO NULL              #No.FUN-6A0015
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t001_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t001_count
    FETCH t001_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t001cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amk.amk01,SQLCA.sqlcode,0)
        INITIALIZE g_amk.* TO NULL
    ELSE
    CALL t001_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
 
FUNCTION t001_fetch(p_flamk)
   DEFINE
      p_flamk         LIKE type_file.chr1,
      l_abso          LIKE type_file.num10

   CASE p_flamk
       WHEN 'N' FETCH NEXT     t001cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN 'P' FETCH PREVIOUS t001cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN 'F' FETCH FIRST    t001cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN 'L' FETCH LAST     t001cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       WHEN '/'
          IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()

                ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121

                ON ACTION help          #MOD-4C0121
                   CALL cl_show_help()  #MOD-4C0121
 
                ON ACTION controlg      #MOD-4C0121
                   CALL cl_cmdask()     #MOD-4C0121

             END PROMPT
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
             END IF
          END IF
       FETCH ABSOLUTE g_jump t001cs INTO g_amk.amk01,g_amk.amk02,g_amk.amk03
       LET mi_no_ask = FALSE
   END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_amk.amk01,SQLCA.sqlcode,0)
        INITIALIZE g_amk.* TO NULL  #TQC-6B0105
        LET g_amk.amk01 = NULL      #TQC-6B0105
        RETURN
    ELSE
       CASE p_flamk
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT amk01,amk02,amk03,amk04,amk05,amk06,amk07,amk08,amk09,amk10
          ,amk11,amk12,amk13,amk14,amk15,amk16,amk17,amk18,amk19,amk20
          ,amk21,amk22,amk23,amk24,amk25,amk26,amk27,amk28,amk29,amk30
          ,amk31,amk32,amk33,amk34,amk35,amk36,amk37,amk38,amk39,amk40
          ,amk41,amk42,amk43,amk44,amk45,amk46,amk47,amk48,amk49,amk50
          ,amk51,amk52,amk53,amk54,amk55,amk56,amk57,amk58,amk59,amk60
          ,amk61,amk62,amk63,amk64,amk65,amk66,amk67,amk68,amk69,amk70
          ,amk71,amk72,amk73,amk74,amk75,amk76,amk77
      INTO g_amk.* FROM amk_file             # 重讀DB,因TEMP有不被更新特性
     WHERE amk01=g_amk.amk01 AND amk02=g_amk.amk02 AND amk03=g_amk.amk03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","amk_file",g_amk.amk01,g_amk.amk02,SQLCA.sqlcode,"","",1)
    ELSE
       CALL t001_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t001_show()
    LET g_amk_t.* = g_amk.*
    DISPLAY BY NAME g_amk.amk01,g_amk.amk02,g_amk.amk03,g_amk.amk04,g_amk.amk05
                   ,g_amk.amk06,g_amk.amk07,g_amk.amk08,g_amk.amk09,g_amk.amk10
                   ,g_amk.amk11,g_amk.amk12,g_amk.amk13,g_amk.amk14,g_amk.amk15
                   ,g_amk.amk16,g_amk.amk17,g_amk.amk18,g_amk.amk19,g_amk.amk20
                   ,g_amk.amk21,g_amk.amk22,g_amk.amk23,g_amk.amk24,g_amk.amk25
                   ,g_amk.amk26,g_amk.amk27,g_amk.amk28,g_amk.amk29,g_amk.amk30
                   ,g_amk.amk31,g_amk.amk32,g_amk.amk33,g_amk.amk34,g_amk.amk35
                   ,g_amk.amk36,g_amk.amk37,g_amk.amk38,g_amk.amk39,g_amk.amk40
                   ,g_amk.amk41,g_amk.amk42,g_amk.amk43,g_amk.amk44,g_amk.amk45
                   ,g_amk.amk46,g_amk.amk47,g_amk.amk48,g_amk.amk49,g_amk.amk50
                   ,g_amk.amk51,g_amk.amk52,g_amk.amk53,g_amk.amk54,g_amk.amk55
                   ,g_amk.amk56,g_amk.amk57,g_amk.amk58,g_amk.amk59,g_amk.amk60
                   ,g_amk.amk61,g_amk.amk62,g_amk.amk63,g_amk.amk64,g_amk.amk65
                   ,g_amk.amk66,g_amk.amk67,g_amk.amk68,g_amk.amk69,g_amk.amk70
                   ,g_amk.amk71,g_amk.amk72,g_amk.amk73,g_amk.amk74,g_amk.amk75
                   ,g_amk.amk76,g_amk.amk77
 
    CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i001_sum(a1,a2,a3,a4,a5)
DEFINE a1    LIKE type_file.num20_6,
       a2    LIKE type_file.num20_6,
       a3    LIKE type_file.num20_6,
       a4    LIKE type_file.num20_6,
       a5    LIKE type_file.num20_6,
       a6    LIKE type_file.num20_6

      if cl_null(a1) then LET a1 = 0 end if
      if cl_null(a2) then LET a2 = 0 end if
      if cl_null(a3) then LET a3 = 0 end if
      if cl_null(a4) then LET a4 = 0 end if
      if cl_null(a5) then LET a5 = 0 end if

      LET a6 = a1 + a2 + a3 + a4 - a5
      CALL cl_digcut(a6,0) RETURNING a6 
      return a6
END FUNCTION

FUNCTION i001_temp(p_amk01)
DEFINE p_amk01          LIKE amk_file.amk01 
DEFINE l_amk77          LIKE amk_file.amk77
DEFINE l_n1             LIKE type_file.num20_6
DEFINE temp_num         LIKE type_file.num10
   SELECT amk77 INTO l_amk77 FROM amk_file WHERE amk01 = g_amk.amk01
   LET l_n1 = p_amk01*(1 - l_amk77/100)		
   CALL cl_digcut(l_n1,0) RETURNING temp_num
   RETURN temp_num
END FUNCTION
