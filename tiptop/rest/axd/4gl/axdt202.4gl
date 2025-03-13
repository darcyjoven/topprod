# Prog. Version..: '5.10.00-08.01.04(00003)'     #
#
# Pattern name...: axdt202.4gl
# Descriptions...: 集團撥出單維護作業
# Date & Author..: 03/12/09 By Carrier
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     

# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_argv1  LIKE adf_file.adf01    #No.FUN-680108  VARCHAR(10)

MAIN
#DEFINE                                    #No.FUN-6A0091    
#       l_time       LIKE type_file.chr8   #No.FUN-6A0091
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680108 SMALLINT

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN                                                      
      EXIT PROGRAM                                                              
   END IF                                                                       
                                                                                
   WHENEVER ERROR CALL cl_err_msg_log                                           
                                                                                
   IF (NOT cl_setup("AXD")) THEN                                                
      EXIT PROGRAM                                                              
   END IF                                                                       
                                                                                
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time   #No:MOD-580088  HCN 20050818  #No.FUN-6A0091

    LET g_argv1=ARG_VAL(1)

    LET p_row = 2 LET p_col = 2

    OPEN WINDOW t202_w AT p_row,p_col WITH FORM "axd/42f/axdt202"
        ATTRIBUTE(STYLE = g_win_style)

    LET g_prog='axdt202'                                                        
    CALL cl_ui_init()                                                           
                                                                                

    CALL t202(g_argv1)
    CLOSE WINDOW t202_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN

