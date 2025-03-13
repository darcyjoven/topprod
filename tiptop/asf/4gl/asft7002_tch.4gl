# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: asft7002_tch.4gl
# Descriptions...: 工單備料狀況查詢 (asft7002_tch)
# Date & Author..: 99/09/07 By Lilan 
# Modify.........: No.FUN-B30216 11/03/30
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正

DATABASE ds

#FUN-B30216

GLOBALS "../../config/top.global"

DEFINE
       g_argv1        LIKE   sfb_file.sfb01,   #工單編號
       g_argv2        LIKE   sfb_file.sfb05,   #生產料件
       g_sfb          RECORD LIKE sfb_file.*,
       g_shb          RECORD LIKE shb_file.*,
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
DEFINE g_sfa DYNAMIC ARRAY OF RECORD
           sfa03      LIKE sfa_file.sfa03,
           ima02      LIKE ima_file.ima02,
           sfa05      LIKE sfa_file.sfa05,
           sfa06      LIKE sfa_file.sfa06,
           sfa567     LIKE sfa_file.sfa07,     #未發數量(sfa05-sfa06-sfa07) 
           ima262     LIKE ima_file.ima262     #庫存可用量
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

     INITIALIZE g_sfb.* TO NULL

     LET g_argv1 = ARG_VAL(1)
     LET g_argv2 = ARG_VAL(2)
     LET g_sfb.sfb01 = g_argv1
     LET g_sfb.sfb05 = g_argv2

     LET p_row = 1
     LET p_col = 10
     LET g_win_style = "touch-w1"   #yen

     OPEN WINDOW asft7002_tch_w AT p_row,p_col WITH FORM "asf/42f/asft7002_tch"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 

     CALL cl_ui_init()

     CALL t7002_tch_show()

     CLOSE WINDOW asft7002_tch_w
     #CALL cl_used(g_prog,l_time,2) RETURNING l_time          #FUN-B80086   MARK
     CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN


FUNCTION t7002_tch_show()
     DEFINE l_i         LIKE type_file.num5
     DEFINE l_j         LIKE type_file.num5
     DEFINE l_ima02     LIKE ima_file.ima02
     DEFINE l_ima021    VARCHAR(240)

     SELECT sfb05,ima02,ima021,
            sfb08,sfb081,sfb09
       INTO g_sfb.sfb05, l_ima02, l_ima021, g_sfb.sfb08,
            g_sfb.sfb081, g_sfb.sfb09      
       FROM sfb_file, ima_file
      WHERE sfb01 = g_sfb.sfb01 
        AND ima01 = sfb05

     LET g_shb.shb05 = g_sfb.sfb01
     LET l_ima021 = l_ima02,' ',l_ima021

    #單頭資料
     DISPLAY BY NAME g_shb.shb05,g_sfb.sfb05,g_sfb.sfb08,g_sfb.sfb081,g_sfb.sfb09
     DISPLAY l_ima021 TO FORMONLY.ima021

    #CALL t7002_tch_pic(g_sfb.sfb05)            #顯示工作站圖片
     CALL t7002_tch_b_fill()

     INPUT BY NAME g_shb.shb05
       ON ACTION close
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
          EXIT PROGRAM
       
       ON IDLE 10
          CALL t7002_tch_b_fill()
          CALL t7002_b_fresh()
     END INPUT
END FUNCTION


FUNCTION t7002_tch_b_fill() 

   LET g_sql = "SELECT sfa03, ima02, sfa05, sfa06,",
               "       (sfa05-sfa06-sfa07) sfa567,",
               "       ima262",
               "  FROM sfa_file,ima_file",
               " WHERE sfa01 = '",g_shb.shb05,"'",  
               "   AND ima01 = sfa03"
 
   PREPARE q7002_prepare FROM g_sql
   DECLARE q7002_cs SCROLL CURSOR FOR q7002_prepare                   #SCROLL CURSOR

   CALL g_sfa.clear()
   LET g_rec_b = 0
   LET g_cnt = 1

   FOREACH q7002_cs INTO g_sfa[g_cnt].sfa03,g_sfa[g_cnt].ima02,g_sfa[g_cnt].sfa05,     
                         g_sfa[g_cnt].sfa06,g_sfa[g_cnt].sfa567,g_sfa[g_cnt].ima262   
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

   CALL g_sfa.deleteElement(g_cnt)   #刪去最後一行空白
   LET g_cnt = g_cnt - 1             #正確的筆數

   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b)
  #  BEFORE DISPLAY
  #      EXIT DISPLAY     
  #   #ON IDLE g_idle_seconds
  #   #   CALL cl_on_idle()
  #   #   CONTINUE DISPLAY
   END DISPLAY   
END FUNCTION  

FUNCTION t7002_b_fresh()
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
          EXIT DISPLAY
   END DISPLAY
END FUNCTION


#顯示工作站圖片
FUNCTION t7002_tch_pic(p_data)
  DEFINE p_data   STRING

    LET g_doc.column1 = "ima01"
    LET g_doc.value1 = p_data
    CALL cl_get_fld_doc("ima04")
END FUNCTION
