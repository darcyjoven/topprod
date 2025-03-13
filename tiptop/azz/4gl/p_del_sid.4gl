# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Program name...: p_del_sid.4gl
# Descriptions...: 刪除sid_file作業
# Date & Author..: 10/09/03 by dikie No.FUN-A40025
# Modify.........: NO.FUN-B70012 11/07/06 By Jay 增加未使用的SESSIONID才刪除之判斷

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE selected_date DATE
DEFINE l_cnt INTEGER

MAIN #No.FUN-A40025
   DEFINE l_ndays  STRING                #FUN-B70012
   DEFINE l_i      LIKE type_file.num5   #FUN-B70012 
   DEFINE l_result LIKE type_file.chr1   #FUN-B70012

   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
    
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF  

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   #如果執行時沒有輸入參數資料,則是跑UI界面是讓使用者輸入日期(如:2011/07/07)
   #如果執行時有輸入參數資料,則是代表跑背景作業是讓使用者輸入天數(如:exe2 p_del_sid 2, 代表要刪除二天前的資料)
   IF NUM_ARGS() == 0 THEN   #FUN-B70012
      OPEN WINDOW sid_w1 
      WITH FORM "azz/42f/p_del_sid"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
   
      CALL cl_ui_init()

      CALL sid_i()

      CLOSE WINDOW sid_w1
   #---FUN-B70012---start-----
   ELSE
      LET l_ndays = ARG_VAL(1)
      LET l_result = TRUE

      #輸入天數不可以小於0,代表不可以刪除大於今天日期的sid_file資料(因為不會產生這種資料)
      IF l_ndays < 0 THEN
         DISPLAY "Please don't delete the data than today's in order to avoid system abnormal."
      ELSE
         #判斷參數資料是不是為數字型態的資料
         FOR l_i = 1 TO l_ndays.getLength()
             IF NOT l_ndays.subString(l_i, l_i) MATCHES "[0-9]" THEN
                DISPLAY "You must enter numeric data."
                LET l_result = FALSE
                EXIT FOR
             END IF
         END FOR 

         #確認是輸入數字型態資料才執行
         IF l_result THEN
            CALL sid_del_bg(l_ndays)
         END IF
      END IF
   END IF
   #---FUN-B70012---end-------

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   
END MAIN

FUNCTION sid_i()
   LET selected_date = NULL
   INPUT selected_date FROM formonly.selected_date ATTRIBUTES(UNBUFFERED=TRUE)

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         #CALL sid_i()   #FUN-B70012 mark 不需要call重回_i()程式段

      ON ACTION close
         EXIT INPUT   #FUN-B70012  將原本的EXIT PROGRAM改成EXIT INPUT
           
      ON ACTION cancel
         EXIT INPUT   #FUN-B70012  將原本的EXIT PROGRAM改成EXIT INPUT
            
      ON ACTION accept
         IF selected_date is null THEN
           CALL cl_err_msg(null,"azz-550",null,0)
           #CALL sid_i()   #FUN-B70012 mark 不需要call重回_i()程式段
         ELSE
           CALL sid_del()
         END IF
     
   END INPUT
END FUNCTION

FUNCTION sid_del()
   DEFINE l_sql   STRING   #FUN-B70012
   
   IF cl_delete() THEN
      SELECT COUNT(*) INTO l_cnt FROM sid_file where sid_file.siddate <= selected_date
        IF l_cnt == 0 THEN
          CALL cl_err_msg(null,"azz-551",null,0)
        ELSE
          IF selected_date >= TODAY THEN
            CALL cl_err_msg(null,"azz-552",null,0)
            #CALL sid_i()   #FUN-B70012 mark 不需要call重回_i()程式段
          ELSE
            #---FUN-B70012---start-----
            #DELETE FROM sid_file WHERE sid_file.siddate <= selected_date
            TRY
               LET l_sql = "DELETE FROM sid_file ",  
                           "  WHERE sid_file.siddate <= '", selected_date, "' AND ",
                           "        sid01 NOT IN (SELECT audsid FROM v$session)"
               PREPARE sid_p1 FROM l_sql
               EXECUTE sid_p1
            #---FUN-B70012---end-------
            
               CALL cl_err_msg(null,"azz-553",null,0)
               
            #---FUN-B70012---start-----
            CATCH
               CALL cl_err("DELETE FROM sid_file", SQLCA.sqlcode, 1)
            END TRY
            #---FUN-B70012---end-------
          END IF
        END IF
   ELSE
     CALL cl_err_msg(null,"azz-554",null,0)	
   END IF
   #CALL sid_i()   #FUN-B70012 mark 不需要call重回_i()程式段
END FUNCTION

#---FUN-B70012---start-----
#sid_del_bg屬背景執行作業,參數資料型態為INTEGER
#sample: CALL sid_del_bg(2)
FUNCTION sid_del_bg(p_ndays)
   DEFINE p_ndays   LIKE type_file.num10
   DEFINE l_date    LIKE type_file.dat
   DEFINE l_sql     STRING   

   TRY
      LET l_date = TODAY - p_ndays  #計算多少天前的日期
      LET l_sql = "DELETE FROM sid_file ",  
                  "  WHERE sid_file.siddate <= '", l_date, "' AND ",
                  "        sid01 NOT IN (SELECT audsid FROM v$session)"
      PREPARE sid_p2 FROM l_sql
      EXECUTE sid_p2
      DISPLAY "rows deleted"
   CATCH
      DISPLAY "DELETE FROM sid_file failure:", SQLCA.sqlcode
   END TRY

END FUNCTION
#---FUN-B70012---end-------
