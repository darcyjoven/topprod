# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_color.4gl
# Descriptions...: 
# Date & Author..: 
# Input Parameter: 
# Return code....: 
# Modify.........: No.FUN-680085 06/08/25 By kim 加入FUNCTION random color
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE處理
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_color(l_color)
 
    DEFINE l_color     LIKE cre_file.cre08         #No.FUN-680147 VARCHAR(10)
    DEFINE l_co        RECORD 
             co_blue   LIKE cre_file.cre08,        #No.FUN-680147 VARCHAR(10)
             co_cyan   LIKE cre_file.cre08,        #No.FUN-680147 VARCHAR(10)
             co_gren   LIKE cre_file.cre08,        #No.FUN-680147 VARCHAR(10)
             co_mage   LIKE cre_file.cre08,        #No.FUN-680147 VARCHAR(10)
             co_red    LIKE cre_file.cre08,        #No.FUN-680147 VARCHAR(10)
             co_whit   LIKE cre_file.cre08,        #No.FUN-680147 VARCHAR(10)
             co_yelo   LIKE cre_file.cre08         #No.FUN-680147 VARCHAR(10)
                   END RECORD
 
    WHENEVER ERROR CALL cl_err_msg_log
    INITIALIZE l_co TO NULL
 
    OPEN WINDOW s_color_w WITH FORM "sub/42f/s_color"
    ATTRIBUTE (STYLE = 'sm3')  # <- 強制指定, 要做出 netterm 的效果
 
    CALL cl_ui_locale("s_color")
 
#   DISPLAY BY NAME l_co.*
    INPUT BY NAME l_co.* WITHOUT DEFAULTS
 
    BEFORE INPUT
       CASE l_color
          WHEN "blue"    NEXT FIELD co_blue
          WHEN "cyan"    NEXT FIELD co_cyan
          WHEN "green"   NEXT FIELD co_gren
          WHEN "magenta" NEXT FIELD co_mage
          WHEN "red"     NEXT FIELD co_red 
          WHEN "white"   NEXT FIELD co_whit
          WHEN "yellow"  NEXT FIELD co_yelo
          OTHERWISE      NEXT FIELD co_blue
       END CASE
 
    BEFORE FIELD co_blue
       LET l_co.co_blue='Active'
       LET l_co.co_cyan=''
       DISPLAY l_co.co_blue,l_co.co_cyan TO co_blue,co_cyan
 
    AFTER FIELD co_blue
 
    BEFORE FIELD co_cyan
       LET l_co.co_blue=''
       LET l_co.co_cyan='Active'
       LET l_co.co_gren=''
       DISPLAY l_co.co_blue,l_co.co_cyan,l_co.co_gren TO co_blue,co_cyan,co_gren
 
    AFTER FIELD co_cyan
 
    BEFORE FIELD co_gren
       LET l_co.co_cyan=''
       LET l_co.co_gren='Active'
       LET l_co.co_mage=''
       DISPLAY l_co.co_cyan,l_co.co_gren,l_co.co_mage TO co_cyan,co_gren,co_mage
 
    AFTER FIELD co_gren
 
    BEFORE FIELD co_mage
       LET l_co.co_gren=''
       LET l_co.co_mage='Active'
       LET l_co.co_red =''
       DISPLAY l_co.co_gren,l_co.co_mage,l_co.co_red  TO co_gren,co_mage,co_red
 
    AFTER FIELD co_mage
 
    BEFORE FIELD co_red 
       LET l_co.co_mage=''
       LET l_co.co_red ='Active'
       LET l_co.co_whit=''
       DISPLAY l_co.co_mage,l_co.co_red ,l_co.co_whit TO co_mage,co_red ,co_whit
 
    AFTER FIELD co_red 
 
    BEFORE FIELD co_whit
       LET l_co.co_red =''
       LET l_co.co_whit='Active'
       LET l_co.co_yelo=''
       DISPLAY l_co.co_red ,l_co.co_whit,l_co.co_yelo TO co_red ,co_whit,co_yelo
 
    AFTER FIELD co_whit
 
    BEFORE FIELD co_yelo
       LET l_co.co_whit=''
       LET l_co.co_yelo='Active'
       DISPLAY l_co.co_whit,l_co.co_yelo TO co_whit,co_yelo
 
    AFTER FIELD co_yelo
 
    AFTER INPUT
       CASE
          WHEN l_co.co_blue IS NOT NULL  
             LET l_color='blue'
          WHEN l_co.co_cyan IS NOT NULL 
             LET l_color='cyan'
          WHEN l_co.co_gren IS NOT NULL 
             LET l_color='green'
          WHEN l_co.co_mage IS NOT NULL 
             LET l_color='magenta'
          WHEN l_co.co_red  IS NOT NULL 
             LET l_color='red'
          WHEN l_co.co_whit IS NOT NULL 
             LET l_color='white'
          WHEN l_co.co_yelo IS NOT NULL  
             LET l_color='yellow'
          OTHERWISE 
             LET l_color=''
       END CASE
 
#--NO.MOD-860078 start---
  
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
#--NO.MOD-860078 end------- 
    END INPUT
    CLOSE WINDOW s_color_w
 
    RETURN l_color
END FUNCTION
 
#FUN-680085 傳入一個INTEGER,回傳一個color name
FUNCTION s_randomcolor(p_i)
DEFINE l_color  LIKE cre_file.cre08     #No.FUN-680147 VARCHAR(10)
DEFINE p_i LIKE type_file.num10         #No.FUN-680147 INTEGER
 
   LET p_i=p_i MOD 6
   CASE p_i
      WHEN 0
         LET l_color='blue'
      WHEN 1
         LET l_color='cyan'
      WHEN 2
         LET l_color='green'
      WHEN 3
         LET l_color='magenta'
      WHEN 4
         LET l_color='red'
      WHEN 5
         LET l_color='white'
      WHEN 6
         LET l_color='yellow'
      OTHERWISE 
         LET l_color=''
   END CASE
   RETURN l_color
END FUNCTION
