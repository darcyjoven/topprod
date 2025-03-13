# Prog. Version..: '5.30.03-13.04.08(00010)'     #
#
# Pattern name...: ghri006.4gl
# Descriptions...: 人员信息维护作业
# Date & Author..: 13/04/08 By yougs  
DATABASE ds                                               #建立與資料庫的連線
 
GLOBALS "../../config/top.global"                         #存放的為TIPTOP GP系統整體全域變數定義  
 
DEFINE g_hrat                 RECORD LIKE hrat_file.*
DEFINE g_hrat_t               RECORD LIKE hrat_file.*     #備份舊值
DEFINE g_hrat01_t             LIKE hrat_file.hrat01       #Key值備份
DEFINE g_wc                   STRING                      #儲存 user 的查詢條件  
DEFINE g_sql                  STRING                      #組 sql 用 
DEFINE g_forupd_sql           STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done    LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                  LIKE hrat_file.hratacti
DEFINE g_cnt                  LIKE type_file.num10       
DEFINE g_i                    LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                  STRING
DEFINE g_curs_index           LIKE type_file.num10
DEFINE g_row_count            LIKE type_file.num10        #總筆數     
DEFINE g_jump                 LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask               LIKE type_file.num5         #是否開啟指定筆視窗 
 
 
MAIN
    OPTIONS  
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("ghr")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   IF g_bgjob = 'N' OR g_bgjob IS NULL THEN 
      OPEN WINDOW i006_w WITH FORM "ghr/42f/ghri006"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
      CALL cl_ui_init()   
      CALL cl_set_label_justify("i006_w","right")  	
   END IF 
   
   CALL sghri006()
   CLOSE WINDOW i006_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 

	
