# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_rate.4gl
# Descriptions...: 匯率計算   
# Date & Author..: 2004/11/12 By Nicola
# Usage..........: CALL s_rate(p_curr,p_rate) RETURNING l_rate
# Input Parameter: p_curr  幣別
#                  p_rate  匯率    
# Return Code....: l_rate  匯率       
# Modify.........: No.FUN-510049 05/01/28 Kitty 加show原幣幣別代號名稱,本幣幣別代號名稱,及增加取位 #                 05/03/18 MOD-530161 Kitty 匯率取位錯誤
# Modify.........: No.MOD-530645 05/03/26 alex 修正說明字串
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: NO.MOD-860078 08/06/10 BY yiting IDLE
# Modify.........: NO.MOD-990067 09/09/08 By mike 取出匯率后不需以cl_digcut取位   
# Modify.........: NO.MOD-B70259 11/08/03 By sabrina 若按放棄離開畫面，應該INT_FLAG=0
# Modify.........: No.MOD-C50231 12/05/30 By Polly 將除的用法makr

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_rate(p_curr,p_rate)
   DEFINE p_curr      LIKE azi_file.azi01        #No.FUN-680147 VARCHAR(04)
   DEFINE p_rate      LIKE azj_file.azj03        #No.FUN-680147 DECIMAL(20,10)
   DEFINE l_rate      LIKE azj_file.azj03        #No.FUN-680147 DECIMAL(20,10)
   DEFINE l_a1        LIKE azj_file.azj03        #No.FUN-680147 DECIMAL(20,10)
   DEFINE l_a2        LIKE azj_file.azj03        #No.FUN-680147 DECIMAL(20,10)
   DEFINE l_azi10     LIKE azi_file.azi10               #No.FUN-510049
   DEFINE l_azi07     LIKE azi_file.azi07               #No.FUN-510049
   DEFINE l_azi02     LIKE azi_file.azi02               #No.FUN-510049
   DEFINE l_azi02_ori LIKE azi_file.azi02
 
   IF cl_null(p_rate) THEN
      LET p_rate = 0
   END IF
 
   OPEN WINDOW s_rate_w AT 10,20 WITH FORM "sub/42f/s_rate"
   ATTRIBUTE(STYLE="popup")
 
   CALL cl_ui_locale("s_rate")
 
   LET l_azi10 = NULL
   LET l_a1 = 0
   LET l_a2 = 0
   LET l_rate = 0
 
#  #FUN-510049
   SELECT azi02,azi07,azi10 INTO l_azi02,l_azi07,l_azi10
     FROM azi_file WHERE azi01 = p_curr 
   IF SQLCA.SQLCODE OR l_azi10 IS NULL OR l_azi10 = " " THEN
      LET l_azi10="1"
   END IF
 
   SELECT azi02 INTO l_azi02_ori FROM azi_file
    WHERE azi01 = g_aza.aza17
 
   CASE
      WHEN l_azi10 = "1"    #乘
         CALL cl_set_comp_entry("a1",FALSE)
         CALL cl_set_comp_entry("a2",TRUE)
         LET l_a1 = 1
         LET l_a2 = p_rate * l_a1
        #LET l_a2 = cl_digcut(l_a2,l_azi07)      #No.FUN-510049  #No.MOD-530161 #MOD-990067  
 
      WHEN l_azi10 = "2"    #除
         CALL cl_set_comp_entry("a1",TRUE)
         CALL cl_set_comp_entry("a2",FALSE)
         LET l_a2 = 1
        #LET l_a1 = l_a2 / p_rate                #MOD-C50231 mark
         LET l_a1 = p_rate                       #MOD-C50231 add
        #LET l_a1 = cl_digcut(l_a1,l_azi07)      #No.FUN-510049  #No.MOD-530161 #MOD-990067  
 
   END CASE
 
   DISPLAY p_curr,     l_azi02,    l_a2,l_azi10 TO r1,d1,a2,azi10
   DISPLAY g_aza.aza17,l_azi02_ori,l_a1         TO r2,d2,a1
 
   INPUT l_a1,l_a2 WITHOUT DEFAULTS FROM a1,a2
 
      AFTER FIELD a1
         IF cl_null(l_a1) OR l_a1 < 0 THEN
            CALL cl_err("","asf-745",0)
            NEXT FIELD a1
         END IF
 
      AFTER FIELD a2
         IF cl_null(l_a2) OR l_a2 < 0 THEN
            CALL cl_err("","asf-745",0)
            NEXT FIELD a2
         END IF
 
      AFTER INPUT
         LET l_rate = l_a2 / l_a1
        #MOD-B70259---add---start---
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
        #MOD-B70259---add---end---
        #LET l_rate = cl_digcut(l_rate,l_azi07)      #No.FUN-510049 #MOD-990067   
#        DISPLAY "l_rate= ",l_rate
 
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
 
   CLOSE WINDOW s_rate_w
 
   RETURN l_rate 
 
END FUNCTION
