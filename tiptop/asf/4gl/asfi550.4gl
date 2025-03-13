# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfi550.4gl
# Descriptions...: WO ISSUE
# Date & Author..: 97/06/20 By Roger
# Modify.........: 97/08/08 By Sophia增加一參數p_argv3=單號
# Modify.........: No.FUN-560014 05/06/06 By day  單據編號修改
# Modify.........: No.MOD-580252 05/08/23 By kim 單據編號修改,改用LIKE
# Modify.........: No.FUN-660166 06/06/26 By saki 流程訊息功能,調整參數數目
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.FUN-810016 08/03/04 By hongmei asfi550.4gl->asfi550.src.4gl
# Modify.........: No.FUN-810038 07/03/30 By kim GP5.1 ICD
# Modify.........: No.FUN-870117 08/08/11 BY ve007 debug 810016
# Modify.........: No.FUN-940039 09/04/09 BY dongbg若參數設定不控管套數,欠料補料走成套發料單
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60028 10/06/17 By lilingyu 平行工藝
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan EF(EasyFlow)整合功能
# Modify.........: No:FUN-C70014 12/07/13 By suncx 新增Run Card發料 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasfi551.global"
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0090
#   DEFINE p_argv2 VARCHAR(1)
    DEFINE p_argv2      LIKE sfp_file.sfp01           #No.FUN-660166
   #DEFINE p_argv3 VARCHAR(16)           #傳單號   #No.FUN-560014
    DEFINE p_argv3	LIKE sfp_file.sfp01           #傳單號   #No.MOD-580251
    DEFINE p_argv4      STRING             #No.FUN-660166
    DEFINE p_row,p_col  LIKE type_file.num5           #No.FUN-680121 SMALLINT


   #判斷當不是背景執行程式，才定義系統畫面預設值。
   IF FGL_GETENV("FGLGUI") <> "0" THEN       #FUN-AB0001  
      OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP  #,                  #FUN-A60028 mark ,
   #      FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075  #FUN-A60028
   END IF                                    #FUN-AB0001 add
   DEFER INTERRUPT
 
   LET p_argv2=ARG_VAL(1)
   LET p_argv3=ARG_VAL(2)
   LET p_argv4=ARG_VAL(3)                  #No.FUN-660166
   LET g_prog='asfi510'
    #No.FUN-810016---Begin
    CASE WHEN p_argv2='1' LET g_prog='asfi511'
         WHEN p_argv2='2' LET g_prog='asfi512'
         WHEN p_argv2='3' LET g_prog='asfi513'
         WHEN p_argv2='4' LET g_prog='asfi514'
         WHEN p_argv2='D' LET g_prog='asfi519'   #FUN-C70014 add
         OTHERWISE        LET g_prog='asfi510'
                          LET p_argv4=p_argv3    #No.FUN-660166 因為asfi550進來沒有第一參數
                          LET p_argv3=p_argv2    #No.FUN-660166
    END CASE
    #No.FUN-810016---End
                                                
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   #FUN-940039 add begin 
   IF p_argv2 = '3' AND g_sma.sma129='N' THEN
      CALL cl_err('','asf-389',1)
      EXIT PROGRAM
   END IF 
   #FUN-940039 add end 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0090
 
   LET p_row = 2 LET p_col = 2
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN  #FUN-AB0001 add 
      OPEN WINDOW i550_w AT p_row,p_col WITH FORM "asf/42f/asfi550"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
      #2004/06/02共用程式時呼叫
      CALL cl_set_locale_frm_name("asfi550")
      CALL cl_ui_init()
   END IF                                   #FUN-AB0001 add
   
   DISPLAY 'g_prog: ',g_prog                 #FUN-AB0001 DEBUG
   DISPLAY 'p_argv2: ',p_argv2               #FUN-AB0001 DEBUG
   DISPLAY 'p_argv3: ',p_argv3               #FUN-AB0001 DEBUG
   DISPLAY 'p_argv4: ',p_argv4               #FUN-AB0001 DEBUG

   CALL i551('1', p_argv2,p_argv3,p_argv4)          #No.FUN-660166
   CLOSE WINDOW i550_w                              #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0090
END MAIN
