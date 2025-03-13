# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: bzmp209.4gl
# Descriptions...: 自动过账失败邮件发送
# Date & Author..: 16/01/01  By  LGe
# Note           :

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

#################################################
#模组变量
#################################################

MAIN

    OPTIONS                               #改變一些系統預設值
       FORM LINE       FIRST + 2,         #畫面開始的位置
       MESSAGE LINE    LAST,              #訊息顯示的位置
       PROMPT LINE     LAST,              #提示訊息的位置
       INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN               #抓取部分參數(g_prog,g_user...)
       EXIT PROGRAM                       #切換成使用者預設的營運中心
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("CMX")) THEN         #抓取權限共用變數及模組變數(g_aza.*...)
       EXIT PROGRAM                       #判斷使用者執行程式權限
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    CALL cs_zmx_transfmail()

    CALL cl_used(g_prog,g_time,2) RETURNING g_time


END MAIN
