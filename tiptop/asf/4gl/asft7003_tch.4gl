# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: asft7003_tch.4gl
# Descriptions...: 歷史製程移轉資料查詢 (asft7003_tch)
# Date & Author..: 99/09/07 By Lilan 
# Modify.........: No.FUN-B30216 11/03/30
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正

DATABASE ds

#FUN-B30216

GLOBALS "../../config/top.global"

DEFINE
       g_argv1        LIKE   shb_file.shb07,   #工作站
       g_shb2         RECORD LIKE shb_file.*,
       g_ecm          RECORD LIKE ecm_file.*,
       g_eca          RECORD LIKE eca_file.*,
       g_cond         LIKE   ze_file.ze03,     #VARCHAR(10) 
       g_wc,g_wc2     string,                
       g_sql          string,                      
       g_cnt          LIKE type_file.num10,    #INTEGER
       g_rec_b        LIKE type_file.num5      #SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5      #SMALLINT
DEFINE g_msg          LIKE ze_file.ze03,       #VARCHAR(1500)
       l_ac           LIKE type_file.num5      #目前處理的ARRAY CNT        #SMALLINT
DEFINE g_row_count    LIKE type_file.num10     #INTEGER
DEFINE g_i            LIKE type_file.num5      #記錄現在是哪個ecm ARRAY
DEFINE g_shb DYNAMIC ARRAY OF RECORD
           shb01      LIKE shb_file.shb01,
           shb05      LIKE shb_file.shb05,
           shb06      LIKE shb_file.shb06,
           shb02      LIKE shb_file.shb02,
           shb021     LIKE shb_file.shb021,
           shb031     LIKE shb_file.shb031,	
           shb10      LIKE shb_file.shb10,
           shb111     LIKE shb_file.shb111,
           shb115     LIKE shb_file.shb115,
           shb112     LIKE shb_file.shb112,
           shb113     LIKE shb_file.shb113,
           shb12      LIKE shb_file.shb12,
           shb114     LIKE shb_file.shb114,
           shb17      LIKE shb_file.shb17
       END RECORD

MAIN
   DEFINE l_time   LIKE type_file.chr8    #VARCHAR(8)

     OPTIONS
       #FORM LINE     FIRST + 2,               #畫面開始的位置
       #MESSAGE LINE  LAST,                    #訊息顯示的位置
       #PROMPT LINE   LAST,                    #提示訊息的位置
        INPUT NO WRAP                          #輸入的方式:不打轉
     DEFER INTERRUPT                           #擷取中斷鍵

     IF (NOT cl_user()) THEN
        EXIT PROGRAM
     END IF

     WHENEVER ERROR CALL cl_err_msg_log

     IF (NOT cl_setup("ASF")) THEN
       EXIT PROGRAM
     END IF

    # CALL cl_used(g_prog,l_time,1) RETURNING l_time          #FUN-B80086   MARK
     CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80086   ADD

     INITIALIZE g_shb2.* TO NULL

     LET g_argv1 = ARG_VAL(1)
     LET g_shb2.shb07 = g_argv1
    #LET g_shb2.shb07 = '1784' #g_argv1

     LET p_row = 1
     LET p_col = 10
     LET g_win_style = "touch-w1"   #yen

     OPEN WINDOW asft7003_tch_w AT p_row,p_col WITH FORM "asf/42f/asft7003_tch"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 

     CALL cl_ui_init()

     LET g_shb2.shb04 = g_user    #開啟畫面時，此欄位預設登入者代號
     CALL t7003_tch_show()

     CLOSE WINDOW asft7003_tch_w
    # CALL cl_used(g_prog,l_time,2) RETURNING l_time
     CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN


FUNCTION t7003_tch_show()
     DEFINE l_i         LIKE type_file.num5
     DEFINE l_j         LIKE type_file.num5
     DEFINE l_eca02     LIKE eca_file.eca02

     SELECT eca02 INTO l_eca02
       FROM eca_file
      WHERE eca01 = g_shb2.shb07

     DISPLAY l_eca02 TO FORMONLY.eca02
     DISPLAY BY NAME g_shb2.shb07

     CALL t7003_tch_pic(g_shb2.shb07)            #顯示工作站圖片
     CALL t7003_tch_b_fill()

     INPUT BY NAME g_shb2.shb07
       ON ACTION close
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
          EXIT PROGRAM
       
       ON IDLE 10
          CALL t7003_tch_b_fill()
          CALL t7003_b_fresh()
     END INPUT
END FUNCTION


FUNCTION t7003_tch_b_fill() 

   LET g_sql = "SELECT shb01,shb05,shb06,shb02,shb021,shb031,shb10,", 
               "       shb111,shb115,shb112,shb113,shb12,shb114,shb17", 
               "  FROM shb_file",     
               " WHERE shb07 = '",g_shb2.shb07,"'",  
               "   AND shbuser = '",g_user,"'",
              #"   AND shb02 >= to_char(sysdate-3)",  #報工日期近三天的資料
               "   AND shb02 >= cl_tp_tochar(sysdate-3)",
               "   AND shb02 <= '",g_today,"'",       #報工日期近三天的資料
               " ORDER BY shb02 desc,shb021,shb01"
   PREPARE q7003_prepare FROM g_sql
   DECLARE q7003_cs SCROLL CURSOR FOR q7003_prepare                   #SCROLL CURSOR

   CALL g_shb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1

   FOREACH q7003_cs INTO g_shb[g_cnt].shb01,g_shb[g_cnt].shb05,g_shb[g_cnt].shb06,	 
                         g_shb[g_cnt].shb02,g_shb[g_cnt].shb021,g_shb[g_cnt].shb031, 	
                         g_shb[g_cnt].shb10,g_shb[g_cnt].shb111,g_shb[g_cnt].shb115, 
                         g_shb[g_cnt].shb112,g_shb[g_cnt].shb113,g_shb[g_cnt].shb12,	 
                         g_shb[g_cnt].shb114,g_shb[g_cnt].shb17   
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_shb.deleteElement(g_cnt)   #刪去最後一行空白
   LET g_cnt = g_cnt - 1             #正確的筆數

   DISPLAY ARRAY g_shb TO s_shb.* ATTRIBUTE(COUNT=g_rec_b)
  #  BEFORE DISPLAY
  #      EXIT DISPLAY     
  #   #ON IDLE g_idle_seconds
  #   #   CALL cl_on_idle()
  #   #   CONTINUE DISPLAY
   END DISPLAY   
END FUNCTION  

FUNCTION t7003_b_fresh()
   DISPLAY ARRAY g_shb TO s_shb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
          EXIT DISPLAY
   END DISPLAY
END FUNCTION


#顯示工作站圖片
FUNCTION t7003_tch_pic(p_data)
  DEFINE p_data   STRING

    LET g_doc.column1 = "eca01"
    LET g_doc.value1 = p_data
    CALL cl_get_fld_doc("ima04")
END FUNCTION
