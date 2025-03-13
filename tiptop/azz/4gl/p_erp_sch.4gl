# Prog. Version..: '09.12.2510.04.08(00001)'
#
# Pattern name...: p_erp_sch.4gl
# Descriptions...: 顯示目前已經建立的ERP schema有哪些
# Date & Author..: No.FUN-A20056 10/02/25 By tommas
# Modify.........: 

import os
 
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_list DYNAMIC ARRAY OF RECORD            #No.FUN-A20056
              legal LIKE azw_file.azw02,         #法人
              legal_db LIKE azw_file.azw09,      #法人Schema
              schema LIKE azw_file.azw06,        #Schema
              is_virtual LIKE type_file.chr1,    #是否為虛擬
              target_schema LIKE azw_file.azw05  #目標Schema
              END RECORD

MAIN
   OPTIONS                                  
      INPUT NO WRAP
   DEFER INTERRUPT #擷取中斷鍵, 由程式處理
 
   WHENEVER ERROR CALL cl_err_msg_log
   IF NOT cl_user() THEN
      EXIT PROGRAM
   END IF
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF

   OPEN WINDOW p_erp_sch_w WITH FORM "azz/42f/p_erp_sch"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()

   CALL p_erp_sch_menu()
 
   CLOSE WINDOW p_erp_sch_w 
END MAIN

FUNCTION p_erp_sch_menu()
   WHILE TRUE
      CALL p_erp_sch_bp()

      CASE g_action_choice
         WHEN "exit"
            EXIT WHILE
      END CASE
   END WHILE
END FUNCTION

FUNCTION p_erp_sch_bp()
   DEFINE l_azw_sql STRING,
          l_i SMALLINT
   LET l_azw_sql = "SELECT distinct azw02 ,azw09 ,azw05 ,'N' ,null FROM azw_file ",
                   "INNER JOIN azp_file on azp_file.azp03 = azw_file.azw05 AND azp_file.azp01 = azw_file.azw01 ",
                   "union ",
                   "SELECT distinct azw02 ,azw09 ,azw06 ,'Y' ,azw05 FROM azw_file ",
                   "INNER JOIN azp_file on azp_file.azp03 = azw_file.azw06 AND azp_file.azp01 = azw_file.azw01 ",
                   "WHERE azw05<>azw06 "

   DECLARE azw_cs CURSOR FROM l_azw_sql
   
   LET l_i = 1
   FOREACH azw_cs INTO g_list[l_i].*
      IF SQLCA.SQLCODE THEN
         CALL cl_err('FOREACH:',SQLCA.SQLCODE,1)    
         EXIT FOREACH
      END IF

      IF NOT cl_chk_schema_has_built(g_list[l_i].schema) THEN #如果schema還沒有建立，則跳過
         CONTINUE FOREACH
      END IF
      
      LET l_i = l_i + 1
   END FOREACH
   CALL g_list.deleteElement(l_i)

   DISPLAY ARRAY g_list TO s_tb1.*
      BEFORE DISPLAY 
         CALL cl_set_act_visible("accept,cancel", FALSE)
      ON ACTION exit
         LET g_action_choice = "exit"
         LET INT_FLAG = FALSE
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice = "exit"
         LET INT_FLAG = FALSE
         EXIT DISPLAY
   END DISPLAY

END FUNCTION
