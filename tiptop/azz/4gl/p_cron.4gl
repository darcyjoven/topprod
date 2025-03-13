# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: p_cron.4gl 
# Descriptions...: 使用者自訂 Background Job 作業
# Date & Author..: 2009/12/14 by David Lee
# Modify.........: No.FUN-9B0033 重寫p_cron作業，使用表gde_file,gdf_file,gdi_file存放TIPTOP排程
#                                利用crontab,at,schtasks作業系統命令來實現訂時功能;
#                                通過執行函數執行TIPTOP作業反饋執行狀況並寫回gde_file表;
# Modify.........: No:FUN-930132 09/05/13 By Vicky 單身增加Action(整合報表維護設定)，
#                                限定只有從報表程式串過來才有此功能，單獨執行p_cron則無此功能
# Modify.........: No:FUN-A50008 10/05/06 By Kevin 可以重新產生script
# Modify.........: No:TQC-AA0029 10/10/11 By lilingyu 重新過單
# Modify.........: No:TQC-B60040 11/06/09 By kevin 修正gdf04 改存azp01
# Modify.........: No:TQC-B60314 11/06/24 By kevin 重複產生crontab 指令修正
# Modify.........: No:MOD-B60236 11/06/29 By suncx 郵件收件者維護BUG修改    
# Modify.........: No:TQC-B70051 11/07/07 By yinhy 設置動態參數為月底時無法查詢整月資料，log檔記錄此參數為' '
# Modify.........: No.FUN-B60064 11/09/15 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B70075 11/10/10 By shiwuying BEFORE INSERT中营运中心给值g_plant
# Modify.........: No:FUN-B70085 11/10/13 By kevin 動態參數可以處理月底前 N 天
# Modify.........: No:FUN-B90011 11/10/17 By kevin 收件者無需replace ";"
# Modify.........: No:MOD-BB0087 11/11/09 By suncx 添加背景作業設置成功與失敗的開窗提示
# Modify.........: No:FUN-BA0009 11/11/14 By kevin 資訊安全專案
# Modify.........: No:FUN-BC0016 11/12/16 By henry 改善副件中的寄件人會重複收到信的bug,原因:在產生p_cron資料夾中的script時,前面項目有指定要發mail通知,後面項目若沒有指定要發mail,則會用前一個項目指定的mail去發信
# Modify.........: No:TQC-C60141 12/06/18 By madey 修正 點選"維護參數"->"動態參數設定"後無反應
# Modify.........: NO.MOD-C60230 12/07/02 By madey 修正javamail點選刪除收件者後無法正常刪除問題,一併解決原本MOD-B60236之問題
# MOdify.........: NO.MOD-C70134 12/10/23 By madey 修正使用非tiptop帳號由weblogin登入後設定之p_cron排程無法正常執行
# Modify.........: No:CHI-CA0051 12/10/23 By madey 修正在動態參數設定,間距模式選 M:按月,日 後,在日期欄位上選不到日期1~9號
# Modify.........: No:MOD-D10162 13/01/17 By madey 錯誤代碼msg1000改為cro-145
# Modify.........: No:CHI-D40018 13/04/11 By madey 修正離開p_cron後gbq殘留
# Modify.........: No:FUN-D40057 13/04/15 By madey 透過p_cron執行程式前,先將工作目錄切換至$TEMPDIR
# Modify.........: No:FUN-D30034 13/04/18 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題


IMPORT os
DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS
   DEFINE g_db_type            LIKE type_file.chr3
END GLOBALS

GLOBALS
   DEFINE g_receiver_list      STRING
   DEFINE g_cc_list            STRING
   DEFINE g_bcc_list           STRING
   DEFINE mc_cron_prog         LIKE zz_file.zz01 
END GLOBALS

DEFINE g_gde      RECORD       LIKE gde_file.*    #TQC-AA0029
DEFINE g_gde_t    RECORD       LIKE gde_file.*
DEFINE g_gde_o    RECORD       LIKE gde_file.*
DEFINE g_gde01                 LIKE gde_file.gde01 
DEFINE g_gde12                 LIKE gde_file.gde12 
DEFINE g_gde01_t               LIKE gde_file.gde01
DEFINE g_gdf      DYNAMIC ARRAY OF RECORD
         gdf02                 LIKE gdf_file.gdf02,
         gdf03                 LIKE gdf_file.gdf03,
         gaz03                 LIKE gaz_file.gaz03,
         gdf04                 LIKE gdf_file.gdf04,
         gdf05                 LIKE gdf_file.gdf05,
         gdf06                 LIKE gdf_file.gdf06,
         gdf07                 LIKE gdf_file.gdf07
                           END RECORD
DEFINE g_gdf_t                 RECORD
         gdf02                 LIKE gdf_file.gdf02,
         gdf03                 LIKE gdf_file.gdf03,
         gaz03                 LIKE gaz_file.gaz03,
         gdf04                 LIKE gdf_file.gdf04,
         gdf05                 LIKE gdf_file.gdf05,
         gdf06                 LIKE gdf_file.gdf06,
         gdf07                 LIKE gdf_file.gdf07
                           END RECORD
DEFINE g_gdf_o    RECORD
         gdf02                 LIKE gdf_file.gdf02,
         gdf03                 LIKE gdf_file.gdf03,
         gaz03                 LIKE gaz_file.gaz03,
         gdf04                 LIKE gdf_file.gdf04,
         gdf05                 LIKE gdf_file.gdf05,
         gdf06                 LIKE gdf_file.gdf06,
         gdf07                 LIKE gdf_file.gdf07
                           END RECORD
DEFINE g_gdf02                 LIKE gdf_file.gdf02
DEFINE g_gdi  DYNAMIC ARRAY OF RECORD
         gdi04                 LIKE gdi_file.gdi04,
         gdi05                 LIKE gdi_file.gdi05
                           END RECORD
DEFINE g_gdi_t    RECORD
         gdi04                 LIKE gdi_file.gdi04,
         gdi05                 LIKE gdi_file.gdi05
                           END RECORD
DEFINE g_gdi_o    RECORD
         gdi04                 LIKE gdi_file.gdi04,
         gdi05                 LIKE gdi_file.gdi05
                           END RECORD
DEFINE g_gdi04                 LIKE gdi_file.gdi03
DEFINE g_gdi05                 LIKE gdi_file.gdi05
DEFINE gr_week    RECORD
          week01               LIKE type_File.chr1,
          week02               LIKE type_File.chr1,
          week03               LIKE type_File.chr1,
          week04               LIKE type_File.chr1,
          week05               LIKE type_File.chr1,
          week06               LIKE type_File.chr1,
          week07               LIKE type_File.chr1
                           END RECORD
DEFINE gr_week_t  RECORD
          week01               LIKE type_File.chr1,
          week02               LIKE type_File.chr1,
          week03               LIKE type_File.chr1,
          week04               LIKE type_File.chr1,
          week05               LIKE type_File.chr1,
          week06               LIKE type_File.chr1,
          week07               LIKE type_File.chr1 
                           END RECORD
DEFINE hh_week                 LIKE gde_file.gde05
DEFINE mm_week                 LIKE gde_file.gde06
DEFINE gr_month   RECORD     
          month01              LIKE type_File.chr1,
          month02              LIKE type_File.chr1,
          month03              LIKE type_File.chr1,
          month04              LIKE type_File.chr1,
          month05              LIKE type_File.chr1,
          month06              LIKE type_File.chr1,
          month07              LIKE type_File.chr1, 
          month08              LIKE type_File.chr1,
          month09              LIKE type_File.chr1,
          month10              LIKE type_File.chr1,
          month11              LIKE type_File.chr1,
          month12              LIKE type_File.chr1
                           END RECORD
DEFINE gr_month_t RECORD 
          month01              LIKE type_File.chr1,
          month02              LIKE type_File.chr1,
          month03              LIKE type_File.chr1,
          month04              LIKE type_File.chr1,
          month05              LIKE type_File.chr1,
          month06              LIKE type_File.chr1,
          month07              LIKE type_File.chr1, 
          month08              LIKE type_File.chr1,
          month09              LIKE type_File.chr1,
          month10              LIKE type_File.chr1,
          month11              LIKE type_File.chr1,
          month12              LIKE type_File.chr1
                           END RECORD
DEFINE dd_month                LIKE gde_file.gde09
DEFINE hh_month                LIKE gde_file.gde05
DEFINE mm_month                LIKE gde_file.gde06
DEFINE gr_day     RECORD
          day01                LIKE type_File.chr1,
          day02                LIKE type_File.chr1,
          day03                LIKE type_File.chr1,
          day04                LIKE type_File.chr1,
          day05                LIKE type_File.chr1,
          day06                LIKE type_File.chr1,
          day07                LIKE type_File.chr1,
          day08                LIKE type_File.chr1,
          day09                LIKE type_File.chr1,
          day10                LIKE type_File.chr1,
          day11                LIKE type_File.chr1,
          day12                LIKE type_File.chr1,
          day13                LIKE type_File.chr1,
          day14                LIKE type_File.chr1,
          day15                LIKE type_File.chr1,
          day16                LIKE type_File.chr1,
          day17                LIKE type_File.chr1,
          day18                LIKE type_File.chr1,
          day19                LIKE type_File.chr1,
          day20                LIKE type_File.chr1,
          day21                LIKE type_File.chr1,
          day22                LIKE type_File.chr1,
          day23                LIKE type_File.chr1,
          day24                LIKE type_File.chr1,
          day25                LIKE type_File.chr1,
          day26                LIKE type_File.chr1,
          day27                LIKE type_File.chr1,
          day28                LIKE type_File.chr1,
          day29                LIKE type_File.chr1,
          day30                LIKE type_File.chr1,
          day31                LIKE type_File.chr1
                           END RECORD
DEFINE gr_day_t RECORD 
          day01                LIKE type_File.chr1,
          day02                LIKE type_File.chr1,
          day03                LIKE type_File.chr1,
          day04                LIKE type_File.chr1,
          day05                LIKE type_File.chr1,
          day06                LIKE type_File.chr1,
          day07                LIKE type_File.chr1,
          day08                LIKE type_File.chr1,
          day09                LIKE type_File.chr1,
          day10                LIKE type_File.chr1,
          day11                LIKE type_File.chr1,
          day12                LIKE type_File.chr1,
          day13                LIKE type_File.chr1,
          day14                LIKE type_File.chr1,
          day15                LIKE type_File.chr1,
          day16                LIKE type_File.chr1,
          day17                LIKE type_File.chr1,
          day18                LIKE type_File.chr1,
          day19                LIKE type_File.chr1,
          day20                LIKE type_File.chr1,
          day21                LIKE type_File.chr1,
          day22                LIKE type_File.chr1,
          day23                LIKE type_File.chr1,
          day24                LIKE type_File.chr1,
          day25                LIKE type_File.chr1,
          day26                LIKE type_File.chr1,
          day27                LIKE type_File.chr1,
          day28                LIKE type_File.chr1,
          day29                LIKE type_File.chr1,
          day30                LIKE type_File.chr1,
          day31                LIKE type_File.chr1
                           END RECORD
DEFINE hh_day                  LIKE gde_file.gde05
DEFINE mm_day                  LIKE gde_file.gde06
DEFINE gr_hour  RECORD                             
          hour00               LIKE type_File.chr1,
          hour01               LIKE type_File.chr1,
          hour02               LIKE type_File.chr1,
          hour03               LIKE type_File.chr1,
          hour04               LIKE type_File.chr1,
          hour05               LIKE type_File.chr1,
          hour06               LIKE type_File.chr1,
          hour07               LIKE type_File.chr1,
          hour08               LIKE type_File.chr1,
          hour09               LIKE type_File.chr1,
          hour10               LIKE type_File.chr1,
          hour11               LIKE type_File.chr1,
          hour12               LIKE type_File.chr1,
          hour13               LIKE type_File.chr1,
          hour14               LIKE type_File.chr1,
          hour15               LIKE type_File.chr1,
          hour16               LIKE type_File.chr1,
          hour17               LIKE type_File.chr1,
          hour18               LIKE type_File.chr1,
          hour19               LIKE type_File.chr1,
          hour20               LIKE type_File.chr1,
          hour21               LIKE type_File.chr1,
          hour22               LIKE type_File.chr1,
          hour23               LIKE type_File.chr1
                           END RECORD
DEFINE gr_hour_t RECORD     
          hour00               LIKE type_File.chr1, 
          hour01               LIKE type_File.chr1,
          hour02               LIKE type_File.chr1,
          hour03               LIKE type_File.chr1,
          hour04               LIKE type_File.chr1,
          hour05               LIKE type_File.chr1,
          hour06               LIKE type_File.chr1,
          hour07               LIKE type_File.chr1,
          hour08               LIKE type_File.chr1,
          hour09               LIKE type_File.chr1,
          hour10               LIKE type_File.chr1,
          hour11               LIKE type_File.chr1,
          hour12               LIKE type_File.chr1,
          hour13               LIKE type_File.chr1,
          hour14               LIKE type_File.chr1,
          hour15               LIKE type_File.chr1,
          hour16               LIKE type_File.chr1,
          hour17               LIKE type_File.chr1,
          hour18               LIKE type_File.chr1,
          hour19               LIKE type_File.chr1,
          hour20               LIKE type_File.chr1,
          hour21               LIKE type_File.chr1,
          hour22               LIKE type_File.chr1,
          hour23               LIKE type_File.chr1
                           END RECORD
DEFINE mm_hour                 LIKE gde_file.gde06
DEFINE gr_minute RECORD                            
          minute00             LIKE type_File.chr1, 
          minute01             LIKE type_File.chr1,
          minute02             LIKE type_File.chr1,
          minute03             LIKE type_File.chr1,
          minute04             LIKE type_File.chr1,
          minute05             LIKE type_File.chr1,
          minute06             LIKE type_File.chr1,
          minute07             LIKE type_File.chr1,
          minute08             LIKE type_File.chr1,
          minute09             LIKE type_File.chr1,
          minute10             LIKE type_File.chr1,
          minute11             LIKE type_File.chr1,
          minute12             LIKE type_File.chr1,
          minute13             LIKE type_File.chr1,
          minute14             LIKE type_File.chr1,
          minute15             LIKE type_File.chr1,
          minute16             LIKE type_File.chr1,
          minute17             LIKE type_File.chr1,
          minute18             LIKE type_File.chr1,
          minute19             LIKE type_File.chr1,
          minute20             LIKE type_File.chr1,
          minute21             LIKE type_File.chr1,
          minute22             LIKE type_File.chr1,
          minute23             LIKE type_File.chr1,
          minute24             LIKE type_File.chr1,
          minute25             LIKE type_File.chr1,
          minute26             LIKE type_File.chr1,
          minute27             LIKE type_File.chr1,
          minute28             LIKE type_File.chr1,
          minute29             LIKE type_File.chr1,
          minute30             LIKE type_File.chr1,
          minute31             LIKE type_File.chr1,
          minute32             LIKE type_File.chr1,
          minute33             LIKE type_File.chr1,
          minute34             LIKE type_File.chr1,
          minute35             LIKE type_File.chr1,
          minute36             LIKE type_File.chr1,
          minute37             LIKE type_File.chr1,
          minute38             LIKE type_File.chr1,
          minute39             LIKE type_File.chr1,
          minute40             LIKE type_File.chr1,
          minute41             LIKE type_File.chr1,
          minute42             LIKE type_File.chr1,
          minute43             LIKE type_File.chr1,
          minute44             LIKE type_File.chr1,
          minute45             LIKE type_File.chr1,
          minute46             LIKE type_File.chr1,
          minute47             LIKE type_File.chr1,
          minute48             LIKE type_File.chr1,
          minute49             LIKE type_File.chr1,
          minute50             LIKE type_File.chr1,
          minute51             LIKE type_File.chr1,
          minute52             LIKE type_File.chr1,
          minute53             LIKE type_File.chr1,
          minute54             LIKE type_File.chr1,
          minute55             LIKE type_File.chr1,
          minute56             LIKE type_File.chr1,
          minute57             LIKE type_File.chr1,
          minute58             LIKE type_File.chr1,
          minute59             LIKE type_File.chr1
                           END RECORD                               
DEFINE gr_minute_t RECORD 
          minute00             LIKE type_File.chr1, 
          minute01             LIKE type_File.chr1,
          minute02             LIKE type_File.chr1,
          minute03             LIKE type_File.chr1,
          minute04             LIKE type_File.chr1,
          minute05             LIKE type_File.chr1,
          minute06             LIKE type_File.chr1,
          minute07             LIKE type_File.chr1,
          minute08             LIKE type_File.chr1,
          minute09             LIKE type_File.chr1,
          minute10             LIKE type_File.chr1,
          minute11             LIKE type_File.chr1,
          minute12             LIKE type_File.chr1,
          minute13             LIKE type_File.chr1,
          minute14             LIKE type_File.chr1,
          minute15             LIKE type_File.chr1,
          minute16             LIKE type_File.chr1,
          minute17             LIKE type_File.chr1,
          minute18             LIKE type_File.chr1,
          minute19             LIKE type_File.chr1,
          minute20             LIKE type_File.chr1,
          minute21             LIKE type_File.chr1,
          minute22             LIKE type_File.chr1,
          minute23             LIKE type_File.chr1,
          minute24             LIKE type_File.chr1,
          minute25             LIKE type_File.chr1,
          minute26             LIKE type_File.chr1,
          minute27             LIKE type_File.chr1,
          minute28             LIKE type_File.chr1,
          minute29             LIKE type_File.chr1,
          minute30             LIKE type_File.chr1,
          minute31             LIKE type_File.chr1,
          minute32             LIKE type_File.chr1,
          minute33             LIKE type_File.chr1,
          minute34             LIKE type_File.chr1,
          minute35             LIKE type_File.chr1,
          minute36             LIKE type_File.chr1,
          minute37             LIKE type_File.chr1,
          minute38             LIKE type_File.chr1,
          minute39             LIKE type_File.chr1,
          minute40             LIKE type_File.chr1,
          minute41             LIKE type_File.chr1,
          minute42             LIKE type_File.chr1,
          minute43             LIKE type_File.chr1,
          minute44             LIKE type_File.chr1,
          minute45             LIKE type_File.chr1,
          minute46             LIKE type_File.chr1,
          minute47             LIKE type_File.chr1,
          minute48             LIKE type_File.chr1,
          minute49             LIKE type_File.chr1,
          minute50             LIKE type_File.chr1,
          minute51             LIKE type_File.chr1,
          minute52             LIKE type_File.chr1,
          minute53             LIKE type_File.chr1,
          minute54             LIKE type_File.chr1,
          minute55             LIKE type_File.chr1,
          minute56             LIKE type_File.chr1,
          minute57             LIKE type_File.chr1,
          minute58             LIKE type_File.chr1,
          minute59             LIKE type_File.chr1
                           END RECORD
DEFINE hh_once                 LIKE gde_file.gde05
DEFINE mm_once                 LIKE gde_file.gde06
DEFINE g_mbgjob                LIKE type_file.chr1     #判斷是否為cron/schtask 回叫p_cron代理執行, N:純執行p_cron
DEFINE g_app                   STRING                  #代理執行時的參數 STRING
DEFINE g_para DYNAMIC ARRAY OF RECORD
         id                    LIKE type_file.num10,
         para                  LIKE gdi_file.gdi05     #參數內容 chr(1000) / 若是執行時則為 gde01作業名稱
                           END RECORD
DEFINE g_forupd_sql            STRING 
DEFINE g_rec_b_job             LIKE type_file.num5
DEFINE g_rec_b_para            LIKE type_file.num5 
DEFINE g_ac_job                LIKE type_file.num5
DEFINE g_ac_para               LIKE type_file.num5
DEFINE g_row_count             LIKE type_file.num10                                                 
DEFINE g_curs_index            LIKE type_file.num10
DEFINE g_cnt_job               LIKE type_file.num10
DEFINE g_cnt_para              LIKE type_file.num10
DEFINE g_sql                   STRING
DEFINE g_select                STRING
DEFINE g_from                  STRING
DEFINE g_where                 STRING
DEFINE g_order                 STRING
DEFINE g_wc                    STRING
DEFINE g_wc1                   STRING
DEFINE g_wc2                   STRING
DEFINE g_before_input_done     LIKE type_file.num5
DEFINE g_action_choice_t       STRING
DEFINE g_action_choice_o       STRING 
DEFINE g_cnt                   LIKE type_file.num5
DEFINE g_flag                  LIKE type_file.num5
DEFINE g_jump                  LIKE type_file.num10       
DEFINE g_msg                   LIKE type_file.chr50 
DEFINE g_no_ask                LIKE type_file.num5  
DEFINE g_cb_plant              ui.ComboBox

MAIN
   DEFINE li_i                  LIKE type_file.num10

   IF (NOT cl_user()) THEN
     EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("AZZ")) THEN
     EXIT PROGRAM
   END IF

   LET g_db_type = cl_db_get_database_type() 

   IF NUM_ARGS() > 0 THEN
      #若有參數時表示是代理執行作業
      LET g_action_choice = "bgjob"
      LET g_mbgjob = 'Y'

      INITIALIZE g_app TO NULL
      CALL g_para.clear() 
      FOR li_i = 1 TO NUM_ARGS()
         IF li_i = 1 THEN
            LET g_app = ARG_VAL(1)
         ELSE
            CALL g_para.appendElement() 
            LET g_para[g_para.getLength()].id = li_i - 1            #設定序號
            LET g_para[g_para.getLength()].para = ARG_VAL(li_i)     #gde01 作業名稱
         END IF
      END FOR
   ELSE
      #純執行 p_cron
      LET g_mbgjob = 'N'
   END IF

   LET g_forupd_sql = "SELECT * FROM gde_file WHERE gde01= ? AND gde12= ? FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_cron_cl CURSOR FROM g_forupd_sql

   IF NOT g_app.equals('p_cron') THEN

      OPTIONS
         INPUT NO WRAP
      DEFER INTERRUPT

      CALL cl_used(g_prog,g_time,1) RETURNING g_time 

      OPEN WINDOW p_cron_w WITH FORM "azz/42f/p_cron"
         ATTRIBUTE(STYLE = g_win_style CLIPPED)
      CALL cl_ui_init()
                                                       
      CALL p_cron_initMonth()   #把月份值清空
      CALL p_cron_initWeek()    #週清空
      CALL p_cron_initDay()     #日清空
      CALL p_cron_initHour()    #小時清空
      CALL p_cron_initMinute()  #分鐘清空

      CALL p_cron_schedule()    #重新調整畫面配置
      
      LET g_cb_plant=ui.ComboBox.forName("gdf_file.gdf04")  #調整"工廠欄位ComboBox"內容
   
      LET g_forupd_sql = " SELECT gdf02,gdf03,'',gdf04,gdf05,gdf06,gdf07 FROM gdf_file ",
                          " WHERE gdf01 = ? AND gdf02 = ? AND gdf08 = ? FOR UPDATE "  
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE p_cron_bc_job CURSOR FROM g_forupd_sql

      CALL p_cron_menu()

      CLOSE WINDOW p_cron_w
   ELSE
      #代理執行作業
      IF NOT p_cron_run() THEN
        FREE p_cron_cl
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #CHI-D40018
        EXIT PROGRAM (-1)
      END IF
   END IF

   FREE p_cron_cl
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #CHI-D40018
END MAIN



PRIVATE FUNCTION p_cron_menu()

   WHILE TRUE
      CASE g_action_choice
         WHEN "bgjob"
            IF NOT p_cron_bgjob() THEN 
#MOD-BB0087 add begin-----------------------
               CALL cl_err(NULL, "azz-068", 1)
            ELSE
               CALL cl_err(NULL, "azz-069", 1)
#MOD-BB0087 add end-------------------------
            END IF
            LET g_action_choice = "exit"        
         OTHERWISE
            CALL p_cron_bp_job("G") 
      END CASE

      LET g_action_choice_t = g_action_choice 
      CASE g_action_choice                                                    
         WHEN "insert"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL p_cron_a()                                                    
            END IF 
                                                                       
         WHEN "query"
            IF cl_chk_act_auth() THEN                                           
               CALL p_cron_q()                                                      
            END IF 
          
         WHEN "modify"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL p_cron_u()                                                    
            END IF  

         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL p_cron_x()
            END IF
                                                                         
         WHEN "delete"        
            IF cl_chk_act_auth() THEN 
               CALL p_cron_r()    
            END IF      
          
         WHEN "help"                                                            
            CALL cl_show_help()     

         WHEN "exit"                                                            
            EXIT WHILE  

         WHEN "controlg"                                                        
            CALL cl_cmdask()                                                    

         WHEN "job"        
            IF cl_chk_act_auth() THEN    
               CALL p_cron_b_job()                                                    
            ELSE            
               LET g_action_choice = " "        
            END IF  
            
         WHEN "parameter"        
            IF cl_chk_act_auth() THEN    
               CALL p_cron_b_para()                                                    
            ELSE            
               LET g_action_choice = " "        
            END IF  

         WHEN "jobdetail"        
            CALL p_cron_b_job()          
            IF g_action_choice = "jobdetail" THEN  #FUN-D30034 add
            ELSE               #FUN-D30034 add                           
               LET g_action_choice = " "       
            END IF    #FUN-D30034 add 

         WHEN "paradetail"        
            CALL p_cron_b_para()                                                    
            IF g_action_choice = "paradetail" THEN  #FUN-D30034 add
            ELSE              #FUN-D30034 add
               LET g_action_choice = " "        
            END IF    #FUN-D30034 add
      
         WHEN "report_list" 
            IF cl_chk_act_auth() THEN                                           
               CALL p_cron_l()                                                    
            END IF 

         WHEN "make_script"      #重新產生script   #FUN-A50008
            IF g_row_count > 0 THEN                                           
               IF NOT p_crontab_create() THEN
                  CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1)
               END IF
            END IF   
      END CASE  

      LET g_action_choice_o = g_action_choice 
   END WHILE   
END FUNCTION



PRIVATE FUNCTION p_cron_bp_job(p_ud)

   DEFINE p_ud            LIKE type_file.chr1
   DEFINE li_status       LIKE type_file.num10
   DEFINE ls_cmd          STRING

   IF p_ud <> "G" OR
      g_action_choice = "parameter" OR g_action_choice = "job" OR
      g_action_choice = "paradetail" OR g_action_choice= "jobdetail" THEN 
      RETURN 
   END IF

   LET g_action_choice = " "                                                    
   CALL cl_set_act_visible("accept,cancel", FALSE)     
   
   IF g_row_count > 0 THEN    #FUN-A50008
      CALL cl_set_act_visible("make_script", TRUE) 
   ELSE
      CALL cl_set_act_visible("make_script", FALSE)                         
   END IF

   DISPLAY ARRAY g_gdf TO s_cron.* ATTRIBUTE(COUNT=g_rec_b_job,UNBUFFERED)   

      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )

         LET ls_cmd = os.Path.join(os.Path.join(FGL_GETENV("TEMPDIR"),"p_cron"),g_user CLIPPED)
         IF os.Path.separator() = "/" THEN
            LET ls_cmd = "ls ",ls_cmd.trim(),"/* >/dev/null 2>&1" 
         ELSE
            LET ls_cmd = "dir/b ",ls_cmd," >NUL " 
         END IF
         RUN ls_cmd RETURNING li_status 
         IF li_status > 0 THEN
            CALL DIALOG.setActionActive("report_list", FALSE)
         END IF 
         
      BEFORE ROW   
         LET g_ac_job = ARR_CURR()     
         IF g_gdf.getLength() > 0 THEN
            LET g_gdf02=g_gdf[g_ac_job].gdf02
         ELSE
            INITIALIZE g_gdf02 TO NULL
         END IF
         CALL p_cron_b_para_fill(g_wc2)
         CALL p_cron_bp_para_refresh()

      ON ACTION parameters  
         LET g_action_choice = "paradetail"
         EXIT DISPLAY 

      ON ACTION parameter  
         LET g_action_choice = "paradetail"
         EXIT DISPLAY 

      ON ACTION job
         LET g_action_choice= "jobdetail"
         EXIT DISPLAY

      ON ACTION insert       
         LET g_action_choice="insert"    
         EXIT DISPLAY    

      ON ACTION query       
         LET g_action_choice="query"        
         EXIT DISPLAY          
      
      ON ACTION make_script       #FUN-A50008
         LET g_action_choice="make_script"        
         EXIT DISPLAY
      
      ON ACTION delete      
         LET g_action_choice="delete"      
         EXIT DISPLAY              

      ON ACTION modify          
         LET g_action_choice="modify"       
         EXIT DISPLAY     
   
      ON ACTION report_list
         LET g_action_choice="report_list"
         EXIT DISPLAY

      ON ACTION first
         CALL p_cron_fetch('F')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b_job <> 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF         
         ACCEPT DISPLAY   

      ON ACTION last                                                           
         CALL p_cron_fetch('L')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b_job <> 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF         
         ACCEPT DISPLAY  

      ON ACTION next                                                           
         CALL p_cron_fetch('N')                                                   
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b_job <> 0 THEN                                                 
            CALL fgl_set_arr_curr(1)  
         END IF         
         ACCEPT DISPLAY 
                                                                                      
      ON ACTION previous        
         CALL p_cron_fetch('P')          
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b_job <> 0 THEN               
            CALL fgl_set_arr_curr(1)                
         END IF           
         ACCEPT DISPLAY
                                                                                  
      ON ACTION jump       
         CALL p_cron_fetch('/')         
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b_job <> 0 THEN      
            CALL fgl_set_arr_curr(1)                        
         END IF             
         ACCEPT DISPLAY 
           
      ON ACTION detail    
         LET g_action_choice = "job"
         LET g_ac_job = ARR_CURR()        
         IF g_gdf.getLength() > 0 THEN
            LET g_gdf02 = g_gdf[g_ac_job].gdf02
         ELSE
            INITIALIZE g_gdf02 TO NULL
         END IF
         CALL p_cron_b_para_fill(g_wc2)
         CALL p_cron_bp_para_refresh()
         EXIT DISPLAY      

      ON ACTION help       
         LET g_action_choice = "help"     
         EXIT DISPLAY   
                                                                                  
      ON ACTION locale     
         CALL cl_dynamic_locale()     
         EXIT DISPLAY        
               
      ON ACTION exit      
         LET g_action_choice="exit"   
         EXIT DISPLAY      

      ON ACTION accept      
         LET g_action_choice = "job"
         LET g_ac_job = ARR_CURR()    
         IF g_gdf.getLength() > 0 THEN
            LET g_gdf02=g_gdf[g_ac_job].gdf02
         ELSE
            INITIALIZE g_gdf02 TO NULL
         END IF
         CALL p_cron_b_para_fill(g_wc2)
         CALL p_cron_bp_para_refresh()
         EXIT DISPLAY      
               
      ON ACTION cancel    
         LET g_action_choice="exit"    
         EXIT DISPLAY       
                 
      ON ACTION close       
         LET g_action_choice="exit"    
         EXIT DISPLAY       
              
      ON ACTION controlg     
         LET g_action_choice="controlg"   
         EXIT DISPLAY        
              
      ON IDLE g_idle_seconds      
         CALL cl_on_idle()  
         CONTINUE DISPLAY                                                      

      ON ACTION about     
        CALL cl_about()  
   END DISPLAY   
   CALL cl_set_act_visible("accept,cancel", TRUE)   
END FUNCTION    



#重設gdf04的combox選項 (未使用 cl_set_combo_item)
FUNCTION initPlant(pcb_plant)

   DEFINE pcb_plant   ui.ComboBox
   DEFINE l_azp01     LIKE azp_file.azp01
   DEFINE l_azp03     LIKE azp_file.azp03
   DEFINE li_cnt      LIKE type_file.num10

   CALL pcb_plant.clear() 
   
   DECLARE azp_cur CURSOR FOR SELECT azp01, azp03 FROM azp_file WHERE azp053 = 'Y'
   FOREACH azp_cur INTO l_azp01, l_azp03
      IF SQLCA.SQLCODE THEN
        CONTINUE FOREACH
      END IF 
 
      #若有設定此使用者有使用該工廠的權限時，就可以設定屬於該廠的背景作業
      SELECT COUNT(*) INTO li_cnt FROM zxy_file 
       WHERE zxy01 = g_user AND zxy03 = l_azp01

      IF ( SQLCA.SQLCODE ) OR ( li_cnt = 0 ) THEN
         CONTINUE FOREACH
      END IF

      #CALL pcb_plant.addItem(l_azp03 CLIPPED, l_azp01 CLIPPED)
      CALL pcb_plant.addItem(l_azp01 CLIPPED, l_azp01 CLIPPED)  #TQC-B60040
   END FOREACH

   #全部的工廠  (要在勾選特殊執行條件情況下才會存在)
#  IF g_gde.gde18="Y" THEN
#     CALL pcb_plant.addItem( "ALL", "ALL")
#  END IF
END FUNCTION

FUNCTION p_schtasks_week(ps_str)

   DEFINE ps_str      STRING
   DEFINE ls_str      STRING
   DEFINE ls_result   STRING
   DEFINE lst_week    base.StringTokenizer

   LET lst_week=base.StringTokenizer.create(ps_str, ",")
   WHILE lst_week.hasMoreTokens() 
      LET ls_str = lst_week.nextToken()
      LET ls_str = ls_str.trim()
      CASE ls_str 
         WHEN "1" LET ls_result="MON,"
         WHEN "2" LET ls_result=ls_result,"TUE,"
         WHEN "3" LET ls_result=ls_result,"WED,"
         WHEN "4" LET ls_result=ls_result,"THU,"
         WHEN "5" LET ls_result=ls_result,"FRI,"
         WHEN "6" LET ls_result=ls_result,"SAT,"
         WHEN "0" LET ls_result=ls_result,"SUN,"
      END CASE 
   END WHILE
   IF length(ls_result) > 1 THEN
      LET ls_result = ls_result.substring(1, Length(ls_result)-1)
   END IF

   IF cl_null(ls_result) THEN
      LET ls_result = "*"
   END IF
   RETURN ls_result
END FUNCTION



FUNCTION p_schtasks_month(ps_str)
   DEFINE ps_str       STRING
   DEFINE ls_str       STRING
   DEFINE ls_result    STRING
   DEFINE lst_month    base.StringTokenizer

   LET lst_month=base.StringTokenizer.create(ps_str, ",")
   WHILE lst_month.hasMoreTokens() 
      LET ls_str = lst_month.nextToken()
      LET ls_str = ls_str.trim()
      CASE ls_str 
         WHEN "01" LET ls_result="JAN,"
         WHEN "02" LET ls_result=ls_result,"FEB,"
         WHEN "03" LET ls_result=ls_result,"MAR,"
         WHEN "04" LET ls_result=ls_result,"APR,"
         WHEN "05" LET ls_result=ls_result,"MAY,"
         WHEN "06" LET ls_result=ls_result,"JUN,"
         WHEN "07" LET ls_result=ls_result,"JUL,"
         WHEN "08" LET ls_result=ls_result,"AUG,"
         WHEN "09" LET ls_result=ls_result,"SEP,"
         WHEN "10" LET ls_result=ls_result,"OCT,"
         WHEN "11" LET ls_result=ls_result,"NOV,"
         WHEN "12" LET ls_result=ls_result,"DEC,"
      END CASE 
   END WHILE

   IF length(ls_result) > 1 THEN
     LET ls_result = ls_result.substring(1, Length(ls_result)-1)
   END IF
 
   IF cl_null(ls_result) THEN
      LET ls_result="*"
   END IF
   RETURN ls_result
END FUNCTION



FUNCTION p_schtasks_time(p_time)

   DEFINE p_time         STRING
   DEFINE ls_hh          STRING
   DEFINE ls_mm          STRING
   DEFINE li_start       LIKE type_file.num10
   DEFINE li_end         LIKE type_file.num10
   DEFINE li_i           LIKE type_file.num10
 
   LET li_start = 1
   LET ls_hh = "00"
   LET ls_mm = "00"
 
   IF time IS NULL THEN
      RETURN ls_hh,ls_mm
   END IF
 
   IF NOT p_time.getindexof(":",1) THEN
      RETURN ls_hh,ls_mm
   END IF
 
   LET li_end = p_time.getindexof(":",li_start)
   LET ls_hh = p_time.substring(li_start,li_end-1)
   
   IF ls_hh.substring(1,2) = "AM" THEN
      LET ls_hh=ls_hh.substring(3,4)
   END IF
 
   IF ls_hh.substring(1,2) = "PM" THEN
      LET li_i = ls_hh.substring(3,4)
      LET li_i = li_i + 12 

      IF li_i = 24 THEN
        LET ls_hh = 00
      ELSE
        LET ls_hh = li_i
      END IF
   END IF
 
   LET li_start = li_end+1
   LET li_end = p_time.getindexof(":",li_start)
   LET ls_mm = p_time.substring(li_start,li_end-1)
 
   RETURN ls_hh,ls_mm 
END FUNCTION


FUNCTION p_cron_month(pc_type)
  DEFINE pc_type     LIKE type_file.chr1
  DEFINE lst_month   base.StringTokenizer
  DEFINE ls_month    STRING

  CASE pc_type
    WHEN "C"
      LET g_gde.gde08 = NULL
      IF gr_month.month01 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "01,"
      END IF
      IF gr_month.month02 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "02,"
      END IF
      IF gr_month.month03 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "03,"
      END IF
      IF gr_month.month04 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "04,"
      END IF
      IF gr_month.month05 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "05,"
      END IF
      IF gr_month.month06 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "06,"
      END IF
      IF gr_month.month07 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "07,"
      END IF
      IF gr_month.month08 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "08,"
      END IF
      IF gr_month.month09 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "09,"
      END IF
      IF gr_month.month10 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "10,"
      END IF
      IF gr_month.month11 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "11,"
      END IF
      IF gr_month.month12 = "Y" THEN
        LET g_gde.gde08 = g_gde.gde08 CLIPPED, "12,"
      END IF
      IF length(g_gde.gde08) > 1 THEN  
        LET g_gde.gde08 = g_gde.gde08[1, Length(g_gde.gde08)-1]
      END IF

    WHEN "D"
      LET lst_month = base.StringTokenizer.create(g_gde.gde08, ",")
      WHILE lst_month.hasMoreTokens()
        LET ls_month = lst_month.nextToken()
        LET ls_month = ls_month.trim()
                 
        CASE ls_month
          WHEN '01'
            LET gr_month.month01 = "Y" 
          WHEN '02'
            LET gr_month.month02 = "Y" 
          WHEN '03'
            LET gr_month.month03 = "Y" 
          WHEN '04'
            LET gr_month.month04 = "Y" 
          WHEN '05'
            LET gr_month.month05 = "Y" 
          WHEN '06'
            LET gr_month.month06 = "Y" 
          WHEN '07'
            LET gr_month.month07 = "Y" 
          WHEN '08'
            LET gr_month.month08 = "Y" 
          WHEN '09'
            LET gr_month.month09 = "Y" 
          WHEN '10'
            LET gr_month.month10 = "Y" 
          WHEN '11'
            LET gr_month.month11 = "Y" 
          WHEN '12'
            LET gr_month.month12 = "Y" 
        END CASE
      END WHILE
    OTHERWISE
  END CASE
END FUNCTION



FUNCTION p_cron_week(pc_type)
  DEFINE pc_type    LIKE type_file.chr1
  DEFINE lst_week   base.StringTokenizer
  DEFINE ls_week    STRING

  CASE pc_type

  WHEN "C"
    LET g_gde.gde07 = NULL
    IF gr_week.week01 = "Y" THEN
      LET g_gde.gde07 = g_gde.gde07 CLIPPED, "1,"
    END IF 
    IF gr_week.week02 = "Y" THEN
      LET g_gde.gde07 = g_gde.gde07 CLIPPED, "2,"
    END IF 
    IF gr_week.week03 = "Y" THEN
      LET g_gde.gde07 = g_gde.gde07 CLIPPED, "3,"
    END IF 
    IF gr_week.week04 = "Y" THEN
      LET g_gde.gde07 = g_gde.gde07 CLIPPED, "4,"
    END IF 
    IF gr_week.week05 = "Y" THEN
      LET g_gde.gde07 = g_gde.gde07 CLIPPED, "5,"
    END IF 
    IF gr_week.week06 = "Y" THEN
      LET g_gde.gde07 = g_gde.gde07 CLIPPED, "6,"
    END IF 
    IF gr_week.week07 = "Y" THEN                                            
      LET g_gde.gde07 = g_gde.gde07 CLIPPED, "0," 
    END IF
    IF length(g_gde.gde07) > 1 THEN  
      LET g_gde.gde07 = g_gde.gde07[1,length(g_gde.gde07)-1]
    END IF
    
  WHEN "D"
    LET lst_week = base.StringTokenizer.create(g_gde.gde07, ",")
    WHILE lst_week.hasMoreTokens()
      LET ls_week = lst_week.nextToken()
      LET ls_week = ls_week.trim()
                 
      CASE ls_week
        WHEN '1'
          LET gr_week.week01 = "Y" 
        WHEN '2'
          LET gr_week.week02 = "Y" 
        WHEN '3'
          LET gr_week.week03 = "Y" 
        WHEN '4'
          LET gr_week.week04 = "Y" 
        WHEN '5'
          LET gr_week.week05 = "Y" 
        WHEN '6'
          LET gr_week.week06 = "Y" 
        WHEN '7'
          LET gr_week.week07 = "Y" 
        WHEN '0'
          LET gr_week.week07 = "Y"
        OTHERWISE 
          CONTINUE WHILE
      END CASE
    END WHILE
  OTHERWISE  
  END CASE
   
END FUNCTION

FUNCTION p_cron_day(pc_type)
  DEFINE pc_type     LIKE type_file.chr1
  DEFINE lst_day     base.StringTokenizer
  DEFINE ls_day      STRING

  CASE pc_type
    WHEN "C"
      LET g_gde.gde09 = NULL
      IF gr_day.day01 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "01,"
      END IF
      IF gr_day.day02 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "02,"
      END IF
      IF gr_day.day03 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "03,"
      END IF
      IF gr_day.day04 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "04,"
      END IF
      IF gr_day.day05 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "05,"
      END IF
      IF gr_day.day06 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "06,"
      END IF
      IF gr_day.day07 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "07,"
      END IF
      IF gr_day.day08 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "08,"
      END IF
      IF gr_day.day09 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "09,"
      END IF
      IF gr_day.day10 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "10,"
      END IF
      IF gr_day.day11 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "11,"
      END IF
      IF gr_day.day12 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "12,"
      END IF
      IF gr_day.day13 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "13,"
      END IF
      IF gr_day.day14 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "14,"
      END IF
      IF gr_day.day15 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "15,"
      END IF
      IF gr_day.day16 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "16,"
      END IF
      IF gr_day.day17 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "17,"
      END IF
      IF gr_day.day18 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "18,"
      END IF
      IF gr_day.day19 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "19,"
      END IF
      IF gr_day.day20 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "20,"
      END IF
      IF gr_day.day21 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "21,"
      END IF
      IF gr_day.day22 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "22,"
      END IF
      IF gr_day.day23 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "23,"
      END IF
      IF gr_day.day24 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "24,"
      END IF
      IF gr_day.day25 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "25,"
      END IF
      IF gr_day.day26 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "26,"
      END IF
      IF gr_day.day27 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "27,"
      END IF
      IF gr_day.day28 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "28,"
      END IF
      IF gr_day.day29 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "29,"
      END IF
      IF gr_day.day30 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "30,"
      END IF
      IF gr_day.day31 = "Y" THEN
        LET g_gde.gde09 = g_gde.gde09 CLIPPED, "31,"
      END IF

      IF length(g_gde.gde09) > 1 THEN  
        LET g_gde.gde09 = g_gde.gde09[1, Length(g_gde.gde09)-1]
      END IF

    WHEN "D"
      LET lst_day = base.StringTokenizer.create(g_gde.gde09, ",")
      WHILE lst_day.hasMoreTokens()
        LET ls_day = lst_day.nextToken()
        LET ls_day = ls_day.trim()
                
        CASE ls_day
          WHEN '01'
            LET gr_day.day01 = "Y" 
          WHEN '02'
            LET gr_day.day02 = "Y" 
          WHEN '03'
            LET gr_day.day03 = "Y" 
          WHEN '04'
            LET gr_day.day04 = "Y" 
          WHEN '05'
            LET gr_day.day05 = "Y" 
          WHEN '06'
            LET gr_day.day06 = "Y" 
          WHEN '07'
            LET gr_day.day07 = "Y" 
          WHEN '08'
            LET gr_day.day08 = "Y" 
          WHEN '09'
            LET gr_day.day09 = "Y" 
          WHEN '10'
            LET gr_day.day10 = "Y" 
          WHEN '11'
            LET gr_day.day11 = "Y" 
          WHEN '12'
            LET gr_day.day12 = "Y" 
          WHEN '13'
            LET gr_day.day13 = "Y" 
          WHEN '14'
            LET gr_day.day14 = "Y" 
          WHEN '15'
            LET gr_day.day15 = "Y" 
          WHEN '16'
            LET gr_day.day16 = "Y" 
          WHEN '17'
            LET gr_day.day17 = "Y"                                                                                  
          WHEN '18'
            LET gr_day.day18 = "Y" 
          WHEN '19'
            LET gr_day.day19 = "Y"   
          WHEN '20'
            LET gr_day.day20 = "Y"     
          WHEN '21'
            LET gr_day.day21 = "Y"  
          WHEN '22'
            LET gr_day.day22 = "Y"  
          WHEN '23'
            LET gr_day.day23 = "Y"  
          WHEN '24'
            LET gr_day.day24 = "Y"  
          WHEN '25'
            LET gr_day.day25 = "Y"  
          WHEN '26'
            LET gr_day.day26 = "Y"  
          WHEN '27'
            LET gr_day.day27 = "Y"  
          WHEN '28'
            LET gr_day.day28 = "Y"  
          WHEN '29'
            LET gr_day.day29 = "Y"  
          WHEN '30'
            LET gr_day.day30 = "Y"  
          WHEN '31'
            LET gr_day.day31 = "Y"                                                                                                                     
        END CASE
      END WHILE
    OTHERWISE
  END CASE
  
END FUNCTION

FUNCTION p_cron_hour(pc_type)
DEFINE pc_type     LIKE type_file.chr1
  DEFINE lst_hour   base.StringTokenizer
  DEFINE ls_hour   STRING
  
  CASE pc_type
    WHEN "C"
      LET g_gde.gde05 = NULL
      IF gr_hour.hour00 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "00,"
      END IF
      IF gr_hour.hour01 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "01,"
      END IF
      IF gr_hour.hour02 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "02,"
      END IF
      IF gr_hour.hour03 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "03,"
      END IF
      IF gr_hour.hour04 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "04,"
      END IF
      IF gr_hour.hour05 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "05,"
      END IF
      IF gr_hour.hour06 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "06,"
      END IF
      IF gr_hour.hour07 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "07,"
      END IF
      IF gr_hour.hour08 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "08,"
      END IF
      IF gr_hour.hour09 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "09,"
      END IF
      IF gr_hour.hour10 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "10,"
      END IF
      IF gr_hour.hour11 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "11,"
      END IF
      IF gr_hour.hour12 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "12,"
      END IF
      IF gr_hour.hour13 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "13,"
      END IF
      IF gr_hour.hour14 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "14,"
      END IF
      IF gr_hour.hour15 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "15,"
      END IF
      IF gr_hour.hour16 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "16,"
      END IF
      IF gr_hour.hour17 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "17,"
      END IF
      IF gr_hour.hour18 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "18,"
      END IF
      IF gr_hour.hour19 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "19,"
      END IF
      IF gr_hour.hour20 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "20,"
      END IF
      IF gr_hour.hour21 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "21,"
      END IF
      IF gr_hour.hour22 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "22,"
      END IF
      IF gr_hour.hour23 = "Y" THEN
        LET g_gde.gde05 = g_gde.gde05 CLIPPED, "23,"
      END IF        
      IF length(g_gde.gde05) > 1 THEN  
        LET g_gde.gde05 = g_gde.gde05[1, Length(g_gde.gde05)-1]
      END IF
 
    WHEN "D"
      LET lst_hour = base.StringTokenizer.create(g_gde.gde05, ",")
      WHILE lst_hour.hasMoreTokens()
        LET ls_hour = lst_hour.nextToken()
        LET ls_hour = ls_hour.trim()
                
        CASE ls_hour
          WHEN '00'
            LET gr_hour.hour00 = "Y" 
          WHEN '01'
            LET gr_hour.hour01 = "Y" 
          WHEN '02'
            LET gr_hour.hour02 = "Y" 
          WHEN '03'
            LET gr_hour.hour03 = "Y" 
          WHEN '04'
            LET gr_hour.hour04 = "Y" 
          WHEN '05'
            LET gr_hour.hour05 = "Y" 
          WHEN '06'
            LET gr_hour.hour06 = "Y" 
          WHEN '07'
            LET gr_hour.hour07 = "Y" 
          WHEN '08'
            LET gr_hour.hour08 = "Y" 
          WHEN '09'
            LET gr_hour.hour09 = "Y" 
          WHEN '10'
            LET gr_hour.hour10 = "Y" 
          WHEN '11'
            LET gr_hour.hour11 = "Y" 
          WHEN '12'
            LET gr_hour.hour12 = "Y" 
          WHEN '13'
            LET gr_hour.hour13 = "Y" 
          WHEN '14'
            LET gr_hour.hour14 = "Y" 
          WHEN '15'
            LET gr_hour.hour15 = "Y" 
          WHEN '16'
            LET gr_hour.hour16 = "Y" 
          WHEN '17'
            LET gr_hour.hour17 = "Y"                                                                                  
          WHEN '18'
            LET gr_hour.hour18 = "Y" 
          WHEN '19'
            LET gr_hour.hour19 = "Y"   
          WHEN '20'
            LET gr_hour.hour20 = "Y"     
          WHEN '21'
            LET gr_hour.hour21 = "Y"  
          WHEN '22'
            LET gr_hour.hour22 = "Y"  
          WHEN '23'
            LET gr_hour.hour23 = "Y" 
        OTHERWISE                                                                                                                                
      END CASE
    END WHILE 
  END CASE
  
END FUNCTION

FUNCTION p_cron_minute(pc_type)
DEFINE pc_type     LIKE type_file.chr1
  DEFINE lst_minute   base.StringTokenizer
  DEFINE ls_minute   STRING

  CASE pc_type
    WHEN "C"
      LET g_gde.gde06 = NULL
      IF gr_minute.minute00 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "00,"
      END IF
      IF gr_minute.minute01 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "01,"
      END IF
      IF gr_minute.minute02 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "02,"
      END IF
      IF gr_minute.minute03 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "03,"
      END IF
      IF gr_minute.minute04 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "04,"
      END IF
      IF gr_minute.minute05 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "05,"
      END IF
      IF gr_minute.minute06 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "06,"
      END IF
      IF gr_minute.minute07 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "07,"
      END IF
      IF gr_minute.minute08 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "08,"
      END IF
      IF gr_minute.minute09 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "09,"
      END IF
      IF gr_minute.minute10 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "10,"
      END IF
      IF gr_minute.minute11 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "11,"
      END IF
      IF gr_minute.minute12 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "12,"
      END IF
      IF gr_minute.minute13 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "13,"
      END IF
      IF gr_minute.minute14 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "14,"
      END IF
      IF gr_minute.minute15 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "15,"
      END IF
      IF gr_minute.minute16 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "16,"
      END IF
      IF gr_minute.minute17 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "17,"
      END IF
      IF gr_minute.minute18 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "18,"
      END IF
      IF gr_minute.minute19 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "19,"
      END IF
      IF gr_minute.minute20 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "20,"
      END IF
      IF gr_minute.minute21 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "21,"
      END IF
      IF gr_minute.minute22 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "22,"
      END IF
      IF gr_minute.minute23 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "23,"
      END IF
      IF gr_minute.minute24 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "24,"
      END IF
      IF gr_minute.minute25 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "25,"
      END IF
      IF gr_minute.minute26 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "26,"
      END IF
      IF gr_minute.minute27 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "27,"
      END IF
      IF gr_minute.minute28 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "28,"
      END IF
      IF gr_minute.minute29 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "29,"
      END IF
      IF gr_minute.minute30 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "30,"
      END IF
      IF gr_minute.minute31 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "31,"
      END IF
      IF gr_minute.minute32 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "32,"
      END IF
      IF gr_minute.minute33 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "33,"
      END IF
      IF gr_minute.minute34 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "34,"
      END IF
      IF gr_minute.minute35 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "35,"
      END IF
      IF gr_minute.minute36 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "36,"
      END IF
      IF gr_minute.minute37 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "37,"
      END IF
      IF gr_minute.minute38 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "38,"
      END IF
      IF gr_minute.minute39 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "39,"
      END IF
      IF gr_minute.minute40 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "40,"
      END IF
      IF gr_minute.minute41 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "41,"
      END IF
      IF gr_minute.minute42 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "42,"
      END IF
      IF gr_minute.minute43 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "43,"
      END IF
      IF gr_minute.minute44 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "44,"
      END IF
      IF gr_minute.minute45 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "45,"
      END IF
      IF gr_minute.minute46 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "46,"
      END IF
      IF gr_minute.minute47 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "47,"
      END IF
      IF gr_minute.minute48 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "48,"
      END IF
      IF gr_minute.minute49 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "49,"
      END IF
      IF gr_minute.minute50 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "50,"
      END IF
      IF gr_minute.minute51 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "51,"
      END IF
      IF gr_minute.minute52 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "52,"
      END IF
      IF gr_minute.minute53 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "53,"
      END IF
      IF gr_minute.minute54 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "54,"
      END IF
      IF gr_minute.minute55 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "55,"
      END IF
      IF gr_minute.minute56 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "56,"
      END IF
      IF gr_minute.minute57 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "57,"
      END IF
      IF gr_minute.minute58 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "58,"
      END IF
      IF gr_minute.minute59 = "Y" THEN
        LET g_gde.gde06 = g_gde.gde06 CLIPPED, "59,"
      END IF
      IF length(g_gde.gde06) > 1 THEN  
        LET g_gde.gde06 = g_gde.gde06[1, Length(g_gde.gde06)-1]
      END IF

    WHEN "D"
      LET lst_minute = base.StringTokenizer.create(g_gde.gde06, ",")
      WHILE lst_minute.hasMoreTokens()
        LET ls_minute = lst_minute.nextToken()
        LET ls_minute = ls_minute.trim()
        CASE ls_minute
          WHEN '00'
            LET gr_minute.minute00 = "Y" 
          WHEN '01'
            LET gr_minute.minute01 = "Y" 
          WHEN '02'
            LET gr_minute.minute02 = "Y" 
          WHEN '03'
            LET gr_minute.minute03 = "Y" 
          WHEN '04'
            LET gr_minute.minute04 = "Y" 
          WHEN '05'
            LET gr_minute.minute05 = "Y" 
          WHEN '06'
            LET gr_minute.minute06 = "Y" 
          WHEN '07'
            LET gr_minute.minute07 = "Y" 
          WHEN '08'
            LET gr_minute.minute08 = "Y" 
          WHEN '09'
            LET gr_minute.minute09 = "Y" 
          WHEN '10'
            LET gr_minute.minute10 = "Y" 
          WHEN '11'
            LET gr_minute.minute11 = "Y" 
          WHEN '12'
            LET gr_minute.minute12 = "Y" 
          WHEN '13'
            LET gr_minute.minute13 = "Y" 
          WHEN '14'
            LET gr_minute.minute14 = "Y" 
          WHEN '15'
            LET gr_minute.minute15 = "Y" 
          WHEN '16'
            LET gr_minute.minute16 = "Y" 
          WHEN '17'
            LET gr_minute.minute17 = "Y" 
          WHEN '18'
            LET gr_minute.minute18 = "Y" 
          WHEN '19'
            LET gr_minute.minute19 = "Y" 
          WHEN '20'
            LET gr_minute.minute20 = "Y" 
          WHEN '21'
            LET gr_minute.minute21 = "Y" 
          WHEN '22'
            LET gr_minute.minute22 = "Y" 
          WHEN '23'
            LET gr_minute.minute23 = "Y" 
          WHEN '24'
            LET gr_minute.minute24 = "Y" 
          WHEN '25'
            LET gr_minute.minute25 = "Y" 
          WHEN '26'
            LET gr_minute.minute26 = "Y" 
          WHEN '27'
            LET gr_minute.minute27 = "Y" 
          WHEN '28'
            LET gr_minute.minute28 = "Y" 
          WHEN '29'
            LET gr_minute.minute29 = "Y" 
          WHEN '30'
            LET gr_minute.minute30 = "Y" 
          WHEN '31'
            LET gr_minute.minute31 = "Y" 
          WHEN '32'
            LET gr_minute.minute32 = "Y" 
          WHEN '33'
            LET gr_minute.minute33 = "Y" 
          WHEN '34'
            LET gr_minute.minute34 = "Y" 
          WHEN '35'
            LET gr_minute.minute35 = "Y" 
          WHEN '36'
            LET gr_minute.minute36 = "Y" 
          WHEN '37'
            LET gr_minute.minute37 = "Y" 
          WHEN '38'
            LET gr_minute.minute38 = "Y" 
          WHEN '39'
            LET gr_minute.minute39 = "Y" 
          WHEN '40'
            LET gr_minute.minute40 = "Y" 
          WHEN '41'
            LET gr_minute.minute41 = "Y" 
          WHEN '42'
            LET gr_minute.minute42 = "Y" 
          WHEN '43'
            LET gr_minute.minute43 = "Y" 
          WHEN '44'
            LET gr_minute.minute44 = "Y" 
          WHEN '45'
            LET gr_minute.minute45 = "Y" 
          WHEN '46'
            LET gr_minute.minute46 = "Y" 
          WHEN '47'
            LET gr_minute.minute47 = "Y" 
          WHEN '48'
            LET gr_minute.minute48 = "Y" 
          WHEN '49'
            LET gr_minute.minute49 = "Y" 
          WHEN '50'
            LET gr_minute.minute50 = "Y" 
          WHEN '51'
            LET gr_minute.minute51 = "Y"  
          WHEN '52'
            LET gr_minute.minute52 = "Y" 
          WHEN '53'
            LET gr_minute.minute53 = "Y" 
          WHEN '54'
            LET gr_minute.minute54 = "Y" 
          WHEN '55'
            LET gr_minute.minute55 = "Y" 
          WHEN '56'
            LET gr_minute.minute56 = "Y" 
          WHEN '57'
            LET gr_minute.minute57 = "Y" 
          WHEN '58'
            LET gr_minute.minute58 = "Y" 
          WHEN '59'
            LET gr_minute.minute59 = "Y"
          OTHERWISE 
        END CASE
      END WHILE
    OTHERWISE
  END CASE
  
END FUNCTION


#重新調整畫面配置
FUNCTION p_cron_schedule()

   #先隱藏所有的時間頁籤
   CALL cl_set_comp_visible("groupMonth", FALSE)
   CALL cl_set_comp_visible("groupWeek", FALSE)
   CALL cl_set_comp_visible("groupDay", FALSE)
   CALL cl_set_comp_visible("groupHour", FALSE)
   CALL cl_set_comp_visible("groupMinute", FALSE)
   CALL cl_set_comp_visible("groupOnce",FALSE)

   #依照情境判斷該顯示哪些頁籤
   CASE g_gde.gde04
      WHEN 'M' #月
               CALL cl_set_comp_visible("groupMonth", TRUE)
      WHEN 'W' #週
               CALL cl_set_comp_visible("groupWeek", TRUE)
      WHEN 'D' #日
               CALL cl_set_comp_visible("groupDay", TRUE)
               IF os.Path.separator() <> "/" THEN   #在非UNIX情況下 (即Windows平台)
                  CALL cl_set_comp_visible("gb13",FALSE)
               END IF
      WHEN 'H' #時
               CALL cl_set_comp_visible("groupHour",TRUE)
               IF os.Path.separator() <> "/" THEN   #在非UNIX情況下 (即Windows平台)
                  CALL cl_set_comp_visible("gb11",FALSE)
               END IF
      WHEN 'F' #分
               IF os.Path.separator() <> "/" THEN   #在非UNIX情況下 (即Windows平台)
               ELSE
                  CALL cl_set_comp_visible("groupMinute",TRUE)
               END IF
      WHEN 'O' #執行一次
               CALL cl_set_comp_visible("groupOnce",TRUE)
   END CASE
END FUNCTION



PRIVATE FUNCTION p_cron_curs()

   CLEAR FORM   
   CALL g_gdf.clear()
   CALL g_gdi.clear()  
   
   CONSTRUCT BY NAME g_wc ON gde01,gde02,gde04,gde03,gde14,gde15,gde13,gde16,gde18,gde19

      ON IDLE g_idle_seconds                                          
         CALL cl_on_idle()                                            
         CONTINUE CONSTRUCT                                           
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION help        
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
   END CONSTRUCT
             
   IF INT_FLAG THEN RETURN END IF
   
   CONSTRUCT g_wc1 ON gdf02,gdf03,gdf04
      FROM gdf02,gdf03,gdf04
             
      ON ACTION CONTROLP                                                  
         CASE
            WHEN INFIELD(gdf03)                                         
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"   
               LET g_qryparam.form = "q_gaz1"
               LET g_qryparam.arg1 = g_lang CLIPPED
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO gdf03
               NEXT FIELD gdf03 
         END CASE
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()                                            
         CONTINUE CONSTRUCT 
   END CONSTRUCT
   
   IF INT_FLAG THEN RETURN END IF
   
   CONSTRUCT g_wc2 ON gdi04,gdf05
                 FROM gdi04,gdf05
      ON ACTION CONTROLP                                                  
         CASE   
            WHEN INFIELD(gdi05)                                         
               CALL p_cron_setpara(g_gdi05) RETURNING g_gdi05
               DISPLAY g_gdi05 to gdi05
               NEXT FIELD gdi05
         END CASE
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()                                            
         CONTINUE CONSTRUCT 
   END CONSTRUCT
   
   IF INT_FLAG THEN RETURN END IF
   
   #由於畫面元件不一定所以要分段組 SQL
   LET g_select = "SELECT"
   LET g_from   = " FROM"
   LET g_where  = " WHERE 1=1 "
   LET g_order  = " ORDER BY"

   IF g_wc.equals(" 1=1") THEN 
      IF g_wc1.equals(" 1=1") THEN 
         IF g_wc2.equals(" 1=1") THEN 
            LET g_select = g_select," gde01,gde12"
            LET g_from   = g_from," gde_file"
            LET g_where  = g_where," AND gde12 = '",g_user,"'"
            LET g_order  = g_order," gde01"
         ELSE
            LET g_select = g_select," UNIQUE gdi01,gdi03"
            LET g_from   = g_from," gdi_file"
            LET g_where  = g_where," AND gdi03 = '",g_user,"' AND ",g_wc2 CLIPPED 
            LET g_order  = g_order," gdi01"
         END IF
      ELSE
         IF g_wc2.equals(" 1=1") THEN 
            LET g_select = g_select," UNIQUE gdf01,gdf08"
            LET g_from   = g_from," gdf_file"
            LET g_where  = g_where ," AND gdf08 = '",g_user,"' AND ",g_wc1 CLIPPED
            LET g_order  = g_order," gdf01"
         ELSE
            LET g_select = g_select," UNIQUE gdf01,gdf08"
            LET g_from   = g_from," gdf_file,gdi_file"
            LET g_where  = g_where ," AND gdf08 = '",g_user,"' AND gdi03 = '",g_user,"'"
                               ," AND gdf01=gdi01 AND gdf02=gdi02 AND gdf08=gdi03"
                               ," AND ",g_wc1 CLIPPED
                               ," AND ",g_wc2 CLIPPED
            LET g_order  = g_order," gde01"
         END IF
      END IF
   ELSE
      IF g_wc1.equals(" 1=1") THEN 
         IF g_wc2.equals(" 1=1") THEN 
            LET g_select = g_select," UNIQUE gde01,gde12"
            LET g_from   = g_from," gde_file"
            LET g_where  = g_where ," AND gde12 = '",g_user,"' AND ",g_wc CLIPPED
            LET g_order  = g_order," gde01"
         ELSE
            LET g_select = g_select," UNIQUE gde01 gde12"
            LET g_from   = g_from," gde_file,gdi_file"
            LET g_where  = g_where ," AND gde12 = '",g_user,"' AND gdi03 = '",g_user,"'"
                              ," AND gdi01=gde01 AND gdi03=gde12"
                              ," AND ",g_wc CLIPPED
                              ," AND ",g_wc2 CLIPPED
            LET g_order = g_order," gde01"
         END IF
      ELSE
         IF g_wc2.equals(" 1=1") THEN 
            LET g_select = g_select," UNIQUE gde01,gde12"
            LET g_from   = g_from," gde_file,gdf_file"
            LET g_where  = g_where," AND gde12 = '",g_user,"' AND gdf08 = '",g_user,"'"
                              ," AND gde01=gdf01 AND gde12=gdf08"
                              ," AND ",g_wc CLIPPED
                              ," AND ",g_wc1 CLIPPED
            LET g_order = g_order," gde01"
         ELSE
            LET g_select = g_select," UNIQUE gde01,gde12"  
            LET g_from   = g_from," gde_file,gdf_file,gdi_file"
            LET g_where  = g_where," AND gde12 = '",g_user,"' AND gdf08 = '",g_user,"' AND gdi03 = '",g_user,"'"
                              ," AND gde01=gdf01 AND gde12=gdf08" 
                              ," AND gdf01=gdi01 AND gdf02=gdi02 AND gdf08=gdi03"
                              ," AND gdi01=gde01 AND gdi03=gde12" 
                              ," AND ",g_wc CLIPPED
                              ," AND ",g_wc1 CLIPPED
                              ," AND ",g_wc2 CLIPPED
            LET g_order = g_order," gde01"
         END IF
      END IF
   END IF

   LET g_sql = g_select,g_from,g_where,g_order
     
   PREPARE p_cron_prepare FROM g_sql     
   DECLARE p_cron_curs SCROLL CURSOR WITH HOLD FOR p_cron_prepare
   
   LET g_sql ="SELECT COUNT(*) FROM (",g_sql,")" 
   
   PREPARE p_cron_precount FROM g_sql                                            
   DECLARE p_cron_count CURSOR FOR  p_cron_precount          

END FUNCTION



PRIVATE FUNCTION p_cron_q()

   LET g_row_count = 0                                                         
   LET g_curs_index = 0
                                                           
   CALL cl_navigator_setting( g_curs_index, g_row_count )                      
   MESSAGE ""
   CLEAR FORM
 
   INITIALIZE g_gde.* TO NULL
   CALL p_cron_schedule()   #重新調整畫面配置
   DISPLAY ' ' TO FORMONLY.cnt 

   CALL p_cron_curs()                   
   IF INT_FLAG THEN                         
     LET INT_FLAG = 0 
     INITIALIZE g_gde01 TO NULL
     INITIALIZE g_gde12 TO NULL
     RETURN
   END IF
   
   OPEN p_cron_curs 
   IF SQLCA.sqlcode THEN                    
     CALL cl_err('',SQLCA.sqlcode,0)
     INITIALIZE g_gde.* TO NULL
   ELSE
     OPEN p_cron_count                                                     
     FETCH p_cron_count INTO g_row_count   
     DISPLAY g_row_count TO FORMONLY.cnt  
     CALL p_cron_fetch('F')               
   END IF
   
END FUNCTION




PRIVATE FUNCTION p_cron_fetch(p_flag)

   DEFINE p_flag LIKE type_file.chr1
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_cron_curs INTO g_gde01,g_gde12
      WHEN 'P' FETCH PREVIOUS p_cron_curs INTO g_gde01,g_gde12
      WHEN 'F' FETCH FIRST    p_cron_curs INTO g_gde01,g_gde12
      WHEN 'L' FETCH LAST     p_cron_curs INTO g_gde01,g_gde12
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds 
                  CALL cl_on_idle()  
               ON ACTION about     
                  CALL cl_about()  
               ON ACTION help   
                  CALL cl_show_help()  
               ON ACTION controlg    
                  CALL cl_cmdask() 
            END PROMPT                      
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         
         FETCH ABSOLUTE g_jump p_cron_curs INTO g_gde01,g_gde12
         LET g_no_ask = FALSE
   END CASE
   
   IF SQLCA.sqlcode THEN                         
      CALL cl_err(g_gde.gde01,SQLCA.sqlcode,0)
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1                                         
         WHEN 'P' LET g_curs_index = g_curs_index - 1                          
         WHEN 'N' LET g_curs_index = g_curs_index + 1                          
         WHEN 'L' LET g_curs_index = g_row_count                               
         WHEN '/' LET g_curs_index = g_jump                                    
      END CASE                                                                 
      CALL cl_navigator_setting( g_curs_index, g_row_count )                   
   END IF

   SELECT * INTO g_gde.* FROM gde_file WHERE gde01=g_gde01 AND gde12=g_gde12
   IF SQLCA.sqlcode THEN                         
      CALL cl_err(g_gde.gde01,SQLCA.sqlcode,0)
      INITIALIZE g_gde01 TO NULL
      INITIALIZE g_gde12 TO NULL
      RETURN
   END IF
   CALL p_cron_show()
END FUNCTION



FUNCTION p_cron_show()   
     
   LET g_gde_t.* = g_gde.*   
   LET g_gde_o.* = g_gde.*
   
   CALL p_cron_schedule()    #重新調整畫面配置
    
   DISPLAY BY NAME g_gde.gde01,g_gde.gde02,g_gde.gde03,g_gde.gde04,g_gde.gde13,g_gde.gde14,g_gde.gde15,
                   g_gde.gde16,g_gde.gde18,g_gde.gde19
   CASE g_gde.gde04
      WHEN 'M'
         DISPLAY g_gde.gde05,g_gde.gde06,g_gde.gde09 TO FORMONLY.hh_month,FORMONLY.mm_month,FORMONLY.dd_month

         LET gr_month.*=gr_month_t.*
         CALL p_cron_month("D") 
         DISPLAY BY NAME gr_month.*
         
      WHEN 'W'
         DISPLAY g_gde.gde05,g_gde.gde06 TO FORMONLY.hh_week,FORMONLY.mm_week
         LET gr_week.*=gr_week_t.*
         CALL p_cron_week("D") 
         DISPLAY BY NAME gr_week.*
         
      WHEN 'D'
         DISPLAY g_gde.gde05,g_gde.gde06 TO FORMONLY.hh_day,FORMONLY.mm_day                                                         
         LET gr_day.*=gr_day_t.*
         CALL p_cron_day("D")                                             
         DISPLAY BY NAME gr_day.*  
         
      WHEN 'H'
         DISPLAY g_gde.gde06 TO FORMONLY.mm_hour
         LET gr_hour.*=gr_hour_t.*
         CALL p_cron_hour("D")                                               
         DISPLAY BY NAME gr_hour.* 
        
      WHEN 'F'                                                          
         LET gr_minute.*=gr_minute_t.*
         CALL p_cron_minute("D")                                               
         DISPLAY BY NAME gr_minute.*
        
      WHEN 'O'
        DISPLAY g_gde.gde05,g_gde.gde06,g_gde.gde11 TO FORMONlY.hh_once,FORMONLY.mm_once,gde11
   END CASE  
   
   IF g_gde.gde18 = "Y" THEN  	 
      CALL initPlant(g_cb_plant)
   END IF
    	 
   CALL p_cron_b_job_fill(g_wc1)
   CALL cl_show_fld_cont()                   
END FUNCTION



FUNCTION p_cron_b_job_fill(p_wc1)  

   DEFINE p_wc1 STRING
   DEFINE li_switch LIKE type_file.num10

   IF g_gde01 IS NULL OR g_gde12 IS NULL THEN RETURN END IF
   
   LET g_sql =" SELECT gdf02,gdf03,gdf04,gdf05,gdf06,gdf07 FROM gdf_file ",
               " WHERE gdf01 = '",g_gde01,"' AND gdf08 = '",g_gde12,"'"

   IF NOT cl_null(p_wc1) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc1 CLIPPED
   END IF

   LET g_sql=g_sql CLIPPED," ORDER BY gdf02"

   PREPARE p_cron_pb_job FROM g_sql 
   DECLARE p_cron_curs_jobs CURSOR FOR p_cron_pb_job

   CALL g_gdf.clear()
   LET g_cnt_job = 1
   LET li_switch=1
   FOREACH p_cron_curs_jobs INTO g_gdf[g_cnt_job].gdf02,g_gdf[g_cnt_job].gdf03,g_gdf[g_cnt_job].gdf04,
                                 g_gdf[g_cnt_job].gdf05,g_gdf[g_cnt_job].gdf06,g_gdf[g_cnt_job].gdf07                       
      IF SQLCA.sqlcode THEN                                                   
        CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                             
        EXIT FOREACH                                                        
      END IF 
        
      SELECT gaz03 INTO g_gdf[g_cnt_job].gaz03
        FROM gaz_file 
       WHERE gaz01 = g_gdf[g_cnt_job].gdf03 AND gaz02 = g_lang

      LET g_cnt_job = g_cnt_job + 1                                                   
      IF g_cnt_job > g_max_rec THEN                                             
         CALL cl_err('',9035,0)                                              
         EXIT FOREACH                                                        
      END IF            
   END FOREACH
                  
   CALL g_gdf.deleteElement(g_cnt_job)               

   LET g_rec_b_job = g_cnt_job - 1
   DISPLAY g_rec_b_job TO FORMONLY.cn2
   LET g_cnt_job = 0

END FUNCTION



FUNCTION p_cron_b_para_fill(p_wc2)  

   DEFINE p_wc2 STRING

   IF g_gde01 IS NULL OR g_gde12 IS NULL OR g_gdf02 IS NULL THEN RETURN END IF
   
   LET g_sql =" SELECT gdi04,gdi05 FROM gdi_file",
               " WHERE gdi01 = '",g_gde01,"' AND gdi02 = '",g_gdf02,"' AND gdi03 ='",g_gde12,"'"
   IF NOT cl_null(p_wc2) THEN
     LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY gdi04"

   PREPARE p_cron_pb_para FROM g_sql 
   DECLARE p_cron_curs_para CURSOR FOR p_cron_pb_para
   CALL g_gdi.clear()
   LET g_cnt_para = 1
   FOREACH p_cron_curs_para INTO g_gdi[g_cnt_para].gdi04,g_gdi[g_cnt_para].gdi05                      
     IF SQLCA.sqlcode THEN                                                   
       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                             
       EXIT FOREACH                                                        
     END IF 
      
     LET g_cnt_para = g_cnt_para + 1                                                   
     IF g_cnt_para > g_max_rec THEN                                             
       CALL cl_err('',9035,0)                                              
       EXIT FOREACH                                                        
     END IF            
   END FOREACH
                  
   CALL g_gdi.deleteElement(g_cnt_para)               

   LET g_rec_b_para = g_cnt_para - 1
   DISPLAY g_rec_b_para TO FORMONLY.cn3
   LET g_cnt_para = 0
     
END FUNCTION



FUNCTION p_cron_bp_para_refresh()

  DISPLAY ARRAY g_gdi TO s_para.* ATTRIBUTE(COUNT=g_rec_b_para,UNBUFFERED)   
    BEFORE DISPLAY
      IF g_rec_b_para <> 0 THEN
        CALL fgl_set_arr_curr(1)
      END IF
      EXIT DISPLAY
    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
  END DISPLAY

END FUNCTION



FUNCTION p_cron_b_job()

  DEFINE l_ac_t          LIKE type_file.num5
  DEFINE l_lock_sw       LIKE type_file.chr1
  DEFINE l_n             LIKE type_file.num5
  DEFINE l_modify_flag   LIKE type_file.chr1
  DEFINE l_exit_sw       LIKE type_file.chr1
  DEFINE p_cmd           LIKE type_file.chr1
  DEFINE l_allow_insert  LIKE type_file.chr1
  DEFINE l_allow_delete  LIKE type_file.chr1
  DEFINE l_jump          LIKE type_file.num5
  DEFINE l_para          base.StringTokenizer
  DEFINE l_buff          base.StringBuffer
  DEFINE l_spos          LIKE type_file.num10
  DEFINE l_epos          LIKE type_file.num10
  DEFINE l_i             LIKE type_file.num10
  DEFINE l_alert         LIKE ze_file.ze03
  DEFINE l_mlj09         LIKE mlj_file.mlj09
  DEFINE l_zx09          LIKE zx_file.zx09
  DEFINE l_para_cnt      LIKE type_file.num5
  DEFINE ls_receiver     STRING
  DEFINE ls_cc           STRING
  DEFINE ls_bcc          STRING
  DEFINE ls_msg          STRING
  
  LET g_action_choice= " "

  #系統關閉
  IF s_shut(0) THEN
    RETURN
  END IF

  IF g_gde01 IS NULL OR g_gde12 IS NULL THEN RETURN END IF
      
  LET g_forupd_sql=" SELECT gdi02 FROM gdi_file ",
                    " WHERE gdi01 = ? AND gdi02 = ? AND gdi03 = ? ORDER BY gdi04 FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE p_cron_bc_paras CURSOR FROM g_forupd_sql
    
  LET l_allow_insert = cl_detail_input_auth("insert")                         
  LET l_allow_delete = cl_detail_input_auth("delete")    

  INPUT ARRAY g_gdf WITHOUT DEFAULTS FROM s_cron.*
        ATTRIBUTE(COUNT=g_rec_b_job,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,        
                    APPEND ROW=l_allow_insert)                                  
                                                                                
    BEFORE INPUT                                                            
      IF g_rec_b_job <> 0 THEN               
        CALL fgl_set_arr_curr(g_ac_job)                                      
      END IF 
                                                      
    BEFORE ROW
      LET p_cmd = ''                                                      
      LET g_ac_job = ARR_CURR()
      LET l_lock_sw='N'
      LET l_n  = ARR_COUNT()
      LET l_para_cnt=0
             
      BEGIN WORK 

      OPEN p_cron_cl USING g_gde01,g_gde12
      IF STATUS THEN
        CALL cl_err("OPEN p_cron_cl:",STATUS,1)
        CLOSE p_cron_cl
        ROLLBACK WORK
        RETURN
      END IF

      FETCH p_cron_cl INTO g_gde.*
      IF SQLCA.sqlcode THEN
        CALL cl_err(g_gde.gde01,SQLCA.sqlcode,0)
        CLOSE p_cron_cl
        ROLLBACK WORK
        RETURN
      END IF

      IF g_rec_b_job >= g_ac_job THEN 
        LET p_cmd = 'u'    
        LET g_gdf_t.* = g_gdf[g_ac_job].*
        LET g_gdf_o.* = g_gdf[g_ac_job].*

        LET g_gdf02 = g_gdf[g_ac_job].gdf02

        OPEN p_cron_bc_job USING g_gde01,g_gdf02,g_gde12
        IF STATUS THEN                                                   
          CALL cl_err("OPEN p_cron_bc_job:", STATUS, 1)                                                             
          LET l_lock_sw="Y"
        ELSE                                         
          FETCH p_cron_bc_job INTO g_gdf[g_ac_job].* 
          IF SQLCA.sqlcode THEN
            CALL cl_err(g_gdf02,SQLCA.sqlcode,1)  
            LET l_lock_sw="Y"
          END IF

          SELECT gaz03 INTO g_gdf[g_ac_job].gaz03
            FROM gaz_file
           WHERE gaz01=g_gdf[g_ac_job].gdf03 AND gaz02=g_lang

          SELECT COUNT(*) INTO l_para_cnt
            FROM gdi_file
           WHERE gdi01= g_gde01 AND gdi02= g_gdf02 AND gdi03 = g_gde12

          IF l_para_cnt >0 THEN
            OPEN p_cron_bc_paras USING g_gde01,g_gdf02,g_gde12

            IF STATUS THEN
              CALL cl_err("OPEN p_cron_bc_paras:",STATUS,1)
              LET l_lock_sw="Y"
            ELSE
              FETCH p_cron_bc_paras INTO g_gdf02
              IF SQLCA.sqlcode THEN
                CALL cl_err(g_gdf02,SQLCA.sqlcode,1)
                LET l_lock_sw="Y"
              END IF
            END IF
          END IF

        END IF
      END IF
          
    BEFORE INSERT
      LET l_n = ARR_COUNT()
      LET p_cmd='a'
      INITIALIZE g_gdf[g_ac_job].* TO NULL        
      LET g_gdf_t.* = g_gdf[g_ac_job].*    
      LET g_gdf_o.* = g_gdf[g_ac_job].*
      IF g_mbgjob = "Y" AND g_ac_job = 1 THEN 
        LET g_gdf[g_ac_job].gdf03 = g_app.trim()
        SELECT gaz03 INTO g_gdf[g_ac_job].gaz03 FROM gaz_file
                     WHERE gaz01 =  g_gdf[g_ac_job].gdf03 AND gaz02 = g_lang
        LET g_gdf[g_ac_job].gdf02 = 1
       #LET g_gdf[g_ac_job].gdf04 = g_dbs   #FUN-B70075
        LET g_gdf[g_ac_job].gdf04 = g_plant #FUN-B70075
        LET g_gdf[g_ac_job].gdf05 = FGL_GETENV("MAIL_TO")
        LET g_gdf[g_ac_job].gdf06 = FGL_GETENV("MAIL_CC")
        LET g_gdf[g_ac_job].gdf07 = FGL_GETENV("MAIL_BCC")
        DISPLAY g_gdf[g_ac_job].* TO s_cron.*
      END IF
      NEXT FIELD gdf02

    AFTER INSERT                                                            
      IF INT_FLAG THEN                                                    
        CALL cl_err('',9001,0)                                           
        LET INT_FLAG = 0                                                 
        CANCEL INSERT                                                    
      END IF     
      INSERT INTO gdf_file VALUES(
             g_gde01,g_gdf02,g_gdf[g_ac_job].gdf03,g_gdf[g_ac_job].gdf04,g_gdf[g_ac_job].gdf05,
             g_gdf[g_ac_job].gdf06,g_gdf[g_ac_job].gdf07,g_gde12)
      IF SQLCA.sqlcode THEN       
          CALL cl_err(g_gdf02,SQLCA.sqlcode,0)
          CANCEL INSERT
      ELSE
        IF g_mbgjob = "Y" AND g_ac_job = 1 AND g_para.getLength() > 0 THEN 
          FOR g_ac_para = 1 TO g_para.getLength()  
            LET g_gdi[g_ac_para].gdi04 = g_para[g_ac_para].id USING "&&&" 
            LET g_gdi[g_ac_para].gdi05 = g_para[g_ac_para].para
           
            INSERT INTO gdi_file VALUES(g_gde01 ,g_gdf02 ,g_gde12 ,g_gdi[g_ac_para].gdi04 ,g_gdi[g_ac_para].gdi05)
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_gdi[g_ac_para].gdi04,SQLCA.sqlcode,0)
               CALL cl_err('',9001,0)                                           
               ROLLBACK WORK 
               CANCEL INSERT 
            ELSE
              LET g_rec_b_para=g_rec_b_para+1  
            END IF 
          END FOR
          LET g_gdf_t.* = g_gdf[g_ac_job].*
          
          #FUN-BA0009 start
          LET ls_msg = "p_cron: Insert:",
                       g_gde.gde01 CLIPPED,"--",g_gde.gde04 CLIPPED,"--",
                       g_gde.gde10 CLIPPED,"--",g_gde.gde12 CLIPPED,"--",
                       g_gdf[g_ac_job].gdf03,"--",g_gdf[g_ac_job].gdf04
          IF cl_syslog("A","S",ls_msg) THEN END IF
          #FUN-BA0009 end
        END IF

        COMMIT WORK

        LET g_rec_b_job=g_rec_b_job+1   
        DISPLAY g_rec_b_job TO FORMONLY.cn2
        LET g_action_choice = "parameter"
        ACCEPT INPUT
      END IF   

    BEFORE FIELD gdf02
      IF g_gdf[g_ac_job].gdf02 IS NULL OR g_gdf[g_ac_job].gdf02 =0 THEN
        SELECT MAX(gdf02)+1 INTO g_gdf[g_ac_job].gdf02 FROM gdf_file 
                                                       WHERE gdf01 = g_gde01 AND gdf08 = g_gde12
        IF g_gdf[g_ac_job].gdf02 IS NULL THEN
          LET g_gdf[g_ac_job].gdf02 = 1
        END IF
      END IF
      LET g_gdf02 = g_gdf[g_ac_job].gdf02

      CALL p_cron_b_para_fill(g_wc2)
      CALL p_cron_bp_para_refresh()
	   
    AFTER FIELD gdf02            
      IF g_gdf[g_ac_job].gdf02 IS NOT NULL THEN 
        IF g_gdf[g_ac_job].gdf02 <> g_gdf_t.gdf02 OR g_gdf_t.gdf02 IS NULL THEN   
          SELECT COUNT(*) INTO g_cnt FROM gdf_file
                          WHERE gdf02 = g_gdf[g_ac_job].gdf02 
                          AND gdf01 = g_gde01
                          AND gdf08 = g_gde12
          IF g_cnt > 0 THEN         
            CALL cl_err('',-239,0)         
            LET g_gdf[g_ac_job].gdf02 = g_gdf_t.gdf02
            LET g_gdf02=g_gdf[g_ac_job].gdf02
            NEXT FIELD gdf02 
          END IF
          IF g_gdf[g_ac_job].gdf02 <1 THEN 
            LET g_gdf[g_ac_job].gdf02 = g_gdf_t.gdf02
            LET g_gdf02 = g_gdf[g_ac_job].gdf02
          END IF
               
        END IF
      ELSE
        NEXT FIELD gdf02 
      END IF
        
    AFTER FIELD gdf03
      IF g_gdf[g_ac_job].gdf03 IS NOT NULL THEN  
        SELECT COUNT(*) INTO g_cnt FROM zz_file          
                        WHERE zz01 = g_gdf[g_ac_job].gdf03
        IF g_cnt = 0 THEN
          CALL cl_err('','cro-002',0)
          LET g_gdf[g_ac_job].gdf03= g_gdf_t.gdf03     
          NEXT FIELD gdf03            
        END IF
        SELECT gaz03 INTO g_gdf[g_ac_job].gaz03 FROM gaz_file
                     WHERE gaz01 =  g_gdf[g_ac_job].gdf03 AND gaz02 = g_lang
      END IF
           
    BEFORE DELETE   
      IF NOT cl_null(g_gdf_t.gdf02) THEN
        IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
        END IF       
        IF l_lock_sw="Y" THEN
            CALL cl_err("",-263,1)
            CANCEL DELETE
        END IF
        DELETE FROM gdf_file
               WHERE gdf01 = g_gde01 
               AND gdf02 = g_gdf02
               AND gdf08 = g_gde12
        IF SQLCA.sqlcode THEN
          CALL cl_err(g_gdf02,SQLCA.sqlcode,0)
          ROLLBACK WORK
          CANCEL DELETE
        ELSE
          IF l_para_cnt >0 THEN 
            DELETE FROM gdi_file  
                   WHERE gdi01 = g_gde01
                   AND gdi02 = g_gdf02
                   AND gdi03 = g_gde12
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_gdf02,SQLCA.sqlcode,0)
              ROLLBACK WORK 
              CANCEL DELETE
            END IF
            INITIALIZE g_gdi04 TO NULL
          END IF

          #FUN-BA0009 start
          LET ls_msg = "p_cron: Delete:",
                         g_gde.gde01 CLIPPED,"--",g_gde.gde04 CLIPPED,"--",
                         g_gde.gde10 CLIPPED,"--",g_gde.gde12 CLIPPED,"--",
                         g_gdf_t.gdf03,"--",g_gdf_t.gdf04
          IF cl_syslog("A","S",ls_msg) THEN END IF
          #FUN-BA0009 end
        END IF

        INITIALIZE g_gdf02 TO NULL
        
        LET g_rec_b_job = g_rec_b_job-1
        DISPLAY g_rec_b_job TO FORMONLY.cn2
      END IF
      COMMIT WORK

    ON ROW CHANGE                                                           
        IF INT_FLAG THEN                                                    
          CALL cl_err('',9001,0)                                           
          LET INT_FLAG = 0                                                 
          LET g_gdf[g_ac_job].* = g_gdf_t.*
          CLOSE p_cron_bc_job
          CLOSE p_cron_bc_paras
          CLOSE p_cron_cl
          ROLLBACK WORK
          EXIT INPUT
        END IF                                                                                
        IF l_lock_sw='Y' THEN
          CALL cl_err(g_gdf[g_ac_job].gdf02,-263,1)
          LET g_gdf[g_ac_job].*=g_gdf_t.*     
        ELSE
          UPDATE gdf_file SET gdf02 = g_gdf[g_ac_job].gdf02,
                              gdf03 = g_gdf[g_ac_job].gdf03,  
                              gdf04 = g_gdf[g_ac_job].gdf04,
                              gdf05 = g_gdf[g_ac_job].gdf05,
                              gdf06 = g_gdf[g_ac_job].gdf06,
                              gdf07 = g_gdf[g_ac_job].gdf07
                        WHERE gdf01 = g_gde01 
                          AND gdf02 = g_gdf_t.gdf02 
                          AND gdf08 = g_gde12


          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                   
            CALL cl_err3("upd","gdf_file",g_gde.gde01,g_gdf_t.gdf02,SQLCA.sqlcode,"","",1)      
            LET g_gdf[g_ac_job].* = g_gdf_t.*                                                        
          ELSE                                                    
            LET g_gdf02 = g_gdf[g_ac_job].gdf02

            IF l_para_cnt > 0 THEN
              UPDATE gdi_file SET gdi02 = g_gdf[g_ac_job].gdf02 
                            WHERE gdi01 = g_gde01
                              AND gdi02 =  g_gdf_t.gdf02
                              AND gdi03 = g_gde12

              IF SQLCA.sqlcode THEN                                   
                CALL cl_err3("upd","gdi_file",g_gde.gde01,g_gdf_t.gdf02,SQLCA.sqlcode,"","",1)      
                LET g_gdf[g_ac_job].* = g_gdf_t.*                                                        
                ROLLBACK WORK
              ELSE
                COMMIT WORK
                LET g_action_choice = "paradetail" 
              END IF
            ELSE
                COMMIT WORK
                LET g_action_choice = "paradetail" 
            END IF
     
            #FUN-BA0009 start
            LET ls_msg = "p_cron: Update:",
                         g_gde.gde01 CLIPPED,"--",g_gde.gde12 CLIPPED,"--",
                         g_gdf[g_ac_job].gdf03,"--",g_gdf[g_ac_job].gdf04
            IF cl_syslog("A","S",ls_msg) THEN END IF
            #FUN-BA0009 end
          END IF                                                                 
        END IF

      AFTER ROW
        LET g_ac_job = ARR_CURR()                                               
       #LET l_ac_t = g_ac_job    #FUN-D30034  mark                                               
        IF INT_FLAG THEN                                                    
          CALL cl_err('',9001,0)                                           
          LET INT_FLAG = 0                                                 
          IF p_cmd = 'u' THEN                                              
            LET g_gdf[g_ac_job].* = g_gdf_t.*                                 
          #FUN-D30034--add--begin--
          ELSE
             CALL g_gdf.deleteElement(g_ac_job)
             IF g_rec_b_job != 0 THEN
                LET g_action_choice = "jobdetail"
                LET g_ac_job = l_ac_t
             END IF
          #FUN-D30034--add--end----
          END IF 
          CLOSE p_cron_bc_job
          CLOSE p_cron_bc_paras
          CLOSE p_cron_cl
          ROLLBACK WORK
          IF g_action_choice = "jobdetail" THEN #FUN-D30034 add
          ELSE      #FUN-D30034 add
             LET g_action_choice = " " 
          END IF    #FUN-D30034 add
          EXIT INPUT                                                       
        END IF                                                              
        CLOSE p_cron_bc_job
        CLOSE p_cron_bc_paras
        CLOSE p_cron_cl
        COMMIT WORK 
        LET l_ac_t = g_ac_job   #FUN-D30034 add

        IF g_action_choice= " " AND g_rec_b_job > g_ac_job  THEN
          LET g_action_choice = "paradetail"
          ACCEPT INPUT
        END IF

      ON ACTION parameter
        LET g_action_choice = "paradetail"
        ACCEPT INPUT

      ON ACTION job
        LET g_action_choice= "job"
        ACCEPT INPUT

      ON ACTION parameters
        LET g_action_choice = "paradetail"
        ACCEPT INPUT

      ON ACTION CONTROLP                                                      
        CASE                                                                 
          WHEN INFIELD(gdf03)                                         
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_gaz1"
            LET g_qryparam.default1 = g_gdf[g_ac_job].gdf03
            LET g_qryparam.default2 = NULL
            LET g_qryparam.arg1 = g_lang CLIPPED
            CALL cl_create_qry() RETURNING g_gdf[g_ac_job].gdf03, g_gdf[g_ac_job].gaz03
            DISPLAY g_gdf[g_ac_job].gdf03, g_gdf[g_ac_job].gaz03 TO gdf03,gdf04
        END CASE

      ON ACTION javamail
        LET g_receiver_list = g_gdf[g_ac_job].gdf05
        LET g_cc_list = g_gdf[g_ac_job].gdf06
        LET g_bcc_list = g_gdf[g_ac_job].gdf07
        LET mc_cron_prog = g_gdf[g_ac_job].gdf03
        CALL cl_javamail() RETURNING ls_receiver, ls_cc, ls_bcc

        CALL cl_err(NULL, "lib-288", 1)        #FUN-BA0009
        #MOD-B60236 mark begin------------------#MOD-C60230:將mark處還原--start--
        LET g_gdf[g_ac_job].gdf05 = ls_receiver
        LET g_gdf[g_ac_job].gdf06 = ls_cc
        LET g_gdf[g_ac_job].gdf07 = ls_bcc
        #MOD-B60236 mark end--------------------#MOD-C60230:將mark處還原--end--

        #MOD-B60236 add begin-------------------#mark by MOD-C60230 --start--
        #IF NOT cl_null(ls_receiver) OR (g_gdf_t.gdf05 IS NOT NULL AND g_gdf_t.gdf05<>ls_receiver)THEN
        #   LET g_gdf[g_ac_job].gdf05 = ls_receiver
        #END IF
        #IF NOT cl_null(ls_cc) OR (g_gdf_t.gdf06 IS NOT NULL AND g_gdf_t.gdf06<>ls_cc) THEN
        #   LET g_gdf[g_ac_job].gdf06 = ls_cc
        #END IF
        #IF NOT cl_null(ls_bcc) OR (g_gdf_t.gdf07 IS NOT NULL AND g_gdf_t.gdf07<>ls_bcc)THEN
        #   LET g_gdf[g_ac_job].gdf07 = ls_bcc
        #END IF
        #MOD-B60236 add end--------------------#mark by MOD-C60230 --end--

        DISPLAY g_gdf[g_ac_job].gdf05 TO gdf05
        DISPLAY g_gdf[g_ac_job].gdf06 TO gdf06
        DISPLAY g_gdf[g_ac_job].gdf07 TO gdf07
           
        select mlj09 INTO l_mlj09 from mlj_file WHERE mlj01='CR'
           
        IF l_mlj09 = "N" THEN
          select zx09 INTO l_zx09 from zx_file  where zx01 = g_user
              
          IF cl_null(l_zx09) THEN  
            CALL cl_err(NULL, "cro-144", 1)
          END IF
        END IF                    
          
      ON ACTION CONTROLG
        CALL cl_cmdask()
    
      ON IDLE g_idle_seconds                                                   
        CALL cl_on_idle()                                                     
        CONTINUE INPUT      
 
      ON ACTION about         
        CALL cl_about()     
 
      ON ACTION help          
        CALL cl_show_help() 
 
    END INPUT
    CALL p_cron_delall() 

END FUNCTION



FUNCTION p_cron_delall()
 
  SELECT COUNT(*) INTO g_cnt
    FROM gdf_file 
   WHERE gdf01 = g_gde01 AND gdf08 = g_gde12

  IF g_cnt = 0 THEN
    CALL cl_getmsg('9044',g_lang) RETURNING g_msg
    ERROR g_msg CLIPPED
   
    BEGIN WORK

    DELETE FROM gde_file WHERE gde01 = g_gde01 AND gde12 = g_gde12
    DELETE FROM gdi_file WHERE gdi01 = g_gde01 AND gdi03 = g_gde12

    IF os.Path.separator() = "/" THEN
       # UNIX 走cron
       IF g_gde.gde04='O' THEN
          IF g_gde.gde03 = 'Y' THEN
             IF NOT p_at_delete(g_gde.gde10) THEN
                ROLLBACK WORK 
                RETURN
             END IF
          END IF
       ELSE
          IF NOT p_crontab_delete(g_gde.gde10) THEN
             ROLLBACK WORK
             RETURN
          END IF
       END IF
    ELSE
       # Windows 走schtask  
       IF NOT p_schtasks_delete() THEN
          ROLLBACK WORK
          RETURN
       END IF 
    END IF

    INITIALIZE g_gde.* TO NULL
    CALL g_gdf.clear()
    CALL g_gdi.clear()
    INITIALIZE g_gde01 TO NULL
    INITIALIZE g_gde12 TO NULL
    INITIALIZE g_gdf02 TO NULL
    INITIALIZE g_gdi04 TO NULL

    COMMIT WORK
    LET g_flag = TRUE
  ELSE
    LET g_flag = FALSE
  END IF

END FUNCTION



FUNCTION p_cron_b_para()
  DEFINE l_ac_t          LIKE type_file.num5
  DEFINE l_lock_sw       LIKE type_file.chr1
  DEFINE l_n             LIKE type_file.num5
  DEFINE l_modify_flag   LIKE type_file.chr1
  DEFINE l_exit_sw       LIKE type_file.chr1
  DEFINE p_cmd           LIKE type_file.chr1
  DEFINE l_allow_insert  LIKE type_file.chr1
  DEFINE l_allow_delete  LIKE type_file.chr1
  DEFINE l_jump          LIKE type_file.num5
  DEFINE l_para          base.StringTokenizer
  DEFINE l_i             LIKE type_file.num10
  DEFINE l_alert         LIKE ze_file.ze03
  DEFINE l_mlj09         LIKE mlj_file.mlj09
  DEFINE l_zx09          LIKE zx_file.zx09
  DEFINE ls_receiver     STRING
  DEFINE ls_cc           STRING
  DEFINE ls_bcc          STRING
  DEFINE ls_msg          STRING

  LET g_action_choice = " "
          
  #系統關閉
  IF s_shut(0) THEN
    RETURN
  END IF

  IF g_gde01 IS NULL OR g_gde12 IS NULL OR g_gdf02 = 0 OR g_gdf02 IS NULL THEN RETURN END IF
    
  LET g_forupd_sql=" SELECT gdi04,gdi05 FROM gdi_file ",
                    " WHERE gdi01 = ? AND gdi02 = ? AND gdi03 = ? AND gdi04 = ? FOR UPDATE "  
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE p_cron_bc_para CURSOR FROM g_forupd_sql
    
  LET l_allow_insert = cl_detail_input_auth("insert")                         
  LET l_allow_delete = cl_detail_input_auth("delete")    

  INPUT ARRAY g_gdi WITHOUT DEFAULTS FROM s_para.*
        ATTRIBUTE(COUNT=g_rec_b_para,MAXCOUNT=g_max_rec,UNBUFFERED,                
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,        
                    APPEND ROW=l_allow_insert)                                  
                                                                                
    BEFORE INPUT                                                            

      #-FUN-930132--start--
      IF g_mbgjob = 'N' THEN
        CALL cl_set_act_visible("create_rptset",FALSE)
      END IF
      #-FUN-930132--end--                          

      IF g_rec_b_para <> 0 THEN               
        CALL fgl_set_arr_curr(g_ac_para)                                      
      END IF 
                   
    BEFORE ROW
      LET p_cmd = ''                                                      
      LET g_ac_para = ARR_CURR()
      LET l_lock_sw='N'
      LET l_n  = ARR_COUNT()
             
      BEGIN WORK 

      OPEN p_cron_cl USING g_gde01,g_gde12
      IF STATUS THEN
        CALL cl_err("OPEN p_cron_cl:",STATUS,1)
        CLOSE p_cron_cl
        ROLLBACK WORK
        RETURN
      END IF

      FETCH p_cron_cl INTO g_gde.*
      IF SQLCA.sqlcode THEN
        CALL cl_err(g_gde.gde01,SQLCA.sqlcode,0)
        CLOSE p_cron_cl
        ROLLBACK WORK
        RETURN
      END IF

      OPEN p_cron_bc_job USING g_gde01,g_gdf02,g_gde12
      IF STATUS THEN
        CALL cl_err("OPEN p_cron_bc_job:", STATUS, 1)
      ELSE
        FETCH p_cron_bc_job INTO g_gdf[g_ac_job].*
        IF SQLCA.sqlcode THEN
          CALL cl_err(g_gdf02,SQLCA.sqlcode,0)
          CLOSE p_cron_bc_job
          ROLLBACK WORK  
          RETURN
        END IF
        SELECT gaz03 INTO g_gdf[g_ac_job].gaz03 FROM gaz_file WHERE gaz01=g_gdf[g_ac_job].gdf03 AND gaz02=g_lang

      END IF

      IF g_rec_b_para >= g_ac_para THEN 
        LET p_cmd = 'u'    
        LET g_gdi_t.* = g_gdi[g_ac_para].*
        LET g_gdi_o.* = g_gdi[g_ac_para].*

        LET g_gdi04 = g_gdi[g_ac_para].gdi04 

        OPEN p_cron_bc_para USING g_gde01,g_gdf02,g_gde12,g_gdi04
        IF STATUS THEN                                                   
          CALL cl_err("OPEN p_cron_bc_para:", STATUS, 1)                                                             
          LET l_lock_sw="Y"
        ELSE                                         
          FETCH p_cron_bc_para INTO g_gdi[g_ac_para].* 
          IF SQLCA.sqlcode THEN
            CALL cl_err(g_gdi[g_ac_para].gdi04,SQLCA.sqlcode,1)  
            LET l_lock_sw="Y"
          END IF

        END IF
      END IF
          
    BEFORE INSERT
      LET l_n = ARR_COUNT()
      LET p_cmd='a'
      INITIALIZE g_gdi[g_ac_para].* TO NULL        
      LET g_gdi_t.* = g_gdi[g_ac_para].*    
      LET g_gdi_o.* = g_gdi[g_ac_para].*

      NEXT FIELD gdi04

    AFTER INSERT                                                            

      IF INT_FLAG THEN                                                    
        CALL cl_err('',9001,0)                                           
        LET INT_FLAG = 0                                                 
        CANCEL INSERT                                                    
        LET g_action_choice = " "
      END IF     

      INSERT INTO gdi_file VALUES(g_gde01
                                 ,g_gdf02
                                 ,g_gde12
                                 ,g_gdi[g_ac_para].gdi04
                                 ,g_gdi[g_ac_para].gdi05
                                 )

      IF SQLCA.sqlcode THEN       
        CALL cl_err(g_gdi[g_ac_para].gdi04,SQLCA.sqlcode,0)
        CANCEL INSERT
      ELSE
        MESSAGE 'INSERT O.K'   
        COMMIT WORK
        LET g_rec_b_para=g_rec_b_para+1   
        DISPLAY g_rec_b_para TO FORMONLY.cn3
      END IF   

    ON ACTION accept
       LET g_action_choice = "job"
       ACCEPT INPUT

    BEFORE FIELD gdi04
      IF cl_null(g_gdi[g_ac_para].gdi04) THEN
        SELECT MAX(TO_NUMBER(gdi04))+1 INTO l_i FROM gdi_file 
	                                                WHERE gdi01 = g_gde01 AND gdi02 = g_gdf02 AND gdi03 = g_gde12
        
        IF l_i IS NULL THEN
          LET g_gdi[g_ac_para].gdi04 = '001' 
        ELSE
          LET g_gdi[g_ac_para].gdi04 = l_i USING "&&&"
        END IF

        IF g_gdi[g_ac_para].gdi04<0 THEN
          LET g_gdi[g_ac_para].gdi04 = '001'
        END IF
      END IF

      LET g_gdi04=g_gdi[g_ac_para].gdi04 USING "&&&"
	   
    AFTER FIELD gdi04           

      IF NOT cl_null(g_gdi[g_ac_para].gdi04) THEN 
        IF (g_gdi[g_ac_para].gdi04 <> g_gdi_t.gdi04 OR cl_null(g_gdi_t.gdi04)) THEN   
          SELECT COUNT(*) INTO g_cnt FROM gdi_file
                                     WHERE gdi04 = g_gdi[g_ac_para].gdi04 
                                     AND gdi01 = g_gde01
                                     AND gdi02 = g_gdf02
                                     AND gdi03 = g_gde12
          IF g_cnt > 0 THEN         
            CALL cl_err('',-239,0)         
            LET g_gdi[g_ac_para].gdi04 = g_gdi_t.gdi04
            LET g_gdi04=g_gdi[g_ac_para].gdi04
            NEXT FIELD gdi04 
          END IF

        END IF
        IF g_gdi[g_ac_para].gdi04 <1 THEN 
          LET g_gdi[g_ac_para].gdi04 = g_gdi_t.gdi04
          LET g_gdi04=g_gdi[g_ac_para].gdi04
        END IF
      ELSE
        NEXT FIELD gdi04
      END IF

        
    BEFORE DELETE   
      IF NOT cl_null(g_gdi_t.gdi04) THEN
        IF NOT cl_delb(0,0) THEN
          CANCEL DELETE
        END IF       
        IF l_lock_sw="Y" THEN
          CALL cl_err("",-263,1)
          CANCEL DELETE
        END IF
        DELETE FROM gdi_file
               WHERE gdi01 = g_gde01 
               AND gdi02 = g_gdf02
               AND gdi03 = g_gde12
               AND gdi04 = g_gdi_t.gdi04
        IF SQLCA.sqlcode THEN
          CALL cl_err(g_gdi_t.gdi04,SQLCA.sqlcode,0)
          ROLLBACK WORK
          CANCEL DELETE
        END IF
        INITIALIZE g_gdi04 TO NULL
        LET g_rec_b_para = g_rec_b_para-1
        DISPLAY g_rec_b_para TO FORMONLY.cn2
      END IF
      COMMIT WORK

    ON ROW CHANGE                                                           
      IF INT_FLAG THEN                                                    
        CALL cl_err('',9001,0)                                           
        LET INT_FLAG = 0                                                 
        LET g_gdi[g_ac_para].* = g_gdi_t.*
        CLOSE p_cron_bc_job
        CLOSE p_cron_bc_para
        CLOSE p_cron_cl 
        ROLLBACK WORK
        EXIT INPUT
      END IF                                                                                

      IF l_lock_sw='Y' THEN
        CALL cl_err(g_gdi[g_ac_para].gdi04,-263,1)
        LET g_gdi[g_ac_para].*=g_gdi_t.*     
      ELSE
        UPDATE gdi_file
               SET gdi04 = g_gdi[g_ac_para].gdi04,
                   gdi05 = g_gdi[g_ac_para].gdi05
               WHERE gdi01 = g_gde01 AND gdi02 = g_gdf02 AND gdi03= g_gde12 AND gdi04=g_gdi_t.gdi04  

        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN                                   
          CALL cl_err3("upd","gdi_file",g_gde01,g_gdi_t.gdi04,SQLCA.sqlcode,"","",1)      
          LET g_gdi[g_ac_para].* = g_gdi_t.*                                                        
        ELSE                                                    
          MESSAGE 'UPDATE O.K' 
          COMMIT WORK

          #FUN-BA0009 start
          LET ls_msg = "p_cron: Update gdi:",
                       g_gde.gde01 CLIPPED,"--",g_gde.gde12 CLIPPED,"--",
                       g_gdi[g_ac_para].gdi04,"--",g_gdi[g_ac_para].gdi05
          IF cl_syslog("A","S",ls_msg) THEN END IF
          #FUN-BA0009 end
        END IF                                                                 
      END IF

    AFTER ROW
      LET g_ac_para = ARR_CURR()                                               
     #LET l_ac_t = g_ac_para      #FUN-D30034 mark                                             
      IF INT_FLAG THEN                                                    
        CALL cl_err('',9001,0)                                           
        LET INT_FLAG = 0                                                 
        IF p_cmd = 'u' THEN                                              
          LET g_gdi[g_ac_para].* = g_gdi_t.*                                 
        #FUN-D30034--add--begin--
        ELSE
           CALL g_gdi.deleteElement(g_ac_para)
           IF g_rec_b_para != 0 THEN
              LET g_action_choice = "paradetail"
              LET g_ac_para = l_ac_t
           END IF
        #FUN-D30034--add--end----
        END IF 
        CLOSE p_cron_bc_job
        CLOSE p_cron_bc_para
        CLOSE p_cron_cl
        ROLLBACK WORK
        IF g_action_choice = "paradetail" THEN  #FUN-D30034 add
        ELSE      #FUN-D30034 add
           LET g_action_choice = " "
        END IF    #FUN-D30034 add
        EXIT INPUT                                                       
      END IF                                                              
      LET l_ac_t = g_ac_para   #FUN-D30034 add 
      CLOSE p_cron_bc_job
      CLOSE p_cron_bc_para
      CLOSE p_cron_cl
      COMMIT WORK

    ON ACTION parameter  
       LET g_action_choice = "paradetail"
       ACCEPT INPUT 
          
    ON ACTION job
       LET g_action_choice= "job"
       ACCEPT INPUT 

    ON ACTION paraset 
       CALL p_cron_setpara(g_gdi[g_ac_para].gdi05) RETURNING g_gdi[g_ac_para].gdi05
       DISPLAY g_gdi[g_ac_para].gdi05 TO gdi05

    ON ACTION CONTROLP                                                      
       CASE                                                                 
          WHEN INFIELD(gdi05)
             CALL p_cron_setpara(g_gdi[g_ac_para].gdi05) RETURNING g_gdi[g_ac_para].gdi05
             DISPLAY g_gdi[g_ac_para].gdi05 TO gdi05
       END CASE

    #--FUN-930132--start--
    #整合報表維護設定(awsi004)
    ON ACTION create_rptset
       CALL p_cron_create_rptset(g_ac_job)
    #--FUN-930132--end--

    ON ACTION CONTROLG
      CALL cl_cmdask()
    
    ON IDLE g_idle_seconds                                                   
      CALL cl_on_idle()                                                     
      CONTINUE INPUT      
 
    ON ACTION about         
      CALL cl_about()     
 
    ON ACTION help          
      CALL cl_show_help() 
 
  END INPUT

END FUNCTION



FUNCTION p_cron_i(p_cmd)

  DEFINE p_cmd         LIKE type_file.chr1
  DEFINE l_gaz03       LIKE gaz_file.gaz03
  DEFINE l_chr         LIKE type_file.chr50
  DEFINE l_gde01       LIKE type_file.chr37
   
  #系統關閉
  IF s_shut(0) THEN
    RETURN 
  END IF   
    
  DISPLAY g_gde.gde01, g_gde.gde02, g_gde.gde03, g_gde.gde04, g_gde.gde13, g_gde.gde14, g_gde.gde15,
          g_gde.gde16, g_gde.gde18, g_gde.gde19,
          dd_month, hh_month, mm_month, gr_month.*, 
                    hh_week,  mm_week,  gr_week.*,
                    hh_day,   mm_day,   gr_day.*,
                              mm_hour,  gr_hour.*, 
                                        gr_minute.*,
                    hh_once,  mm_once,  g_gde.gde11   

       TO gde01,gde02,gde03,gde04,gde13,gde14,gde15,
          gde16,gde18,gde19,
          dd_month, hh_month, mm_month, month01, month02, month03, month04, month05, month06, month07, month08,
                                        month09, month10, month11, month12, 
                    hh_week,  mm_week,  week01,  week02,  week03,  week04,  week05,  week06,  week07,
                    hh_day,   mm_day,   day01,   day02,   day03,   day04,   day05,   day06,   day07,   day08,
                                        day09,   day10,   day11,   day12,   day13,   day14,   day15,   day16, 
                                        day17,   day18,   day19,   day20,   day21,   day22,   day23,   day24,
                                        day25,   day26,   day27,   day28,   day29,   day30,   day31,  
                              mm_hour,  hour00,  hour01,  hour02,  hour03,  hour04,  hour05,  hour06,  hour07,
                                        hour08,  hour09,  hour10,  hour11,  hour12,  hour13,  hour14,  hour15,
                                        hour16,  hour17,  hour18,  hour19,  hour20,  hour21,  hour22,  hour23,
                                        minute00,minute01,minute02,minute03,minute04,minute05,minute06,minute07,
                                        minute08,minute09,minute10,minute11,minute12,minute13,minute14,minute15,
                                        minute16,minute17,minute18,minute19,minute20,minute21,minute22,minute23,
                                        minute24,minute25,minute26,minute27,minute28,minute29,minute30,minute31,
                                        minute32,minute33,minute34,minute35,minute36,minute37,minute38,minute39,
                                        minute40,minute41,minute42,minute43,minute44,minute45,minute46,minute47,
                                        minute48,minute49,minute50,minute51,minute52,minute53,minute54,minute55,
                                        minute56,minute57,minute58,minute59,
                    hh_once,  mm_once,  gde11   

  CALL p_cron_schedule()    #重新調整畫面配置

  INPUT   g_gde.gde01, g_gde.gde02, g_gde.gde03, g_gde.gde04, g_gde.gde13, g_gde.gde14, g_gde.gde15,
          g_gde.gde16, g_gde.gde18, g_gde.gde19,
          dd_month, hh_month, mm_month, gr_month.*, 
                    hh_week,  mm_week,  gr_week.*,
                    hh_day,   mm_day,   gr_day.*,
                              mm_hour,  gr_hour.*, 
                                        gr_minute.*,
                    hh_once,  mm_once,  g_gde.gde11   
  WITHOUT DEFAULTS               
     FROM gde01,gde02,gde03,gde04,gde13,gde14,gde15,
          gde16,gde18,gde19,
          dd_month, hh_month, mm_month, month01, month02, month03, month04, month05, month06, month07, month08,
                                        month09, month10, month11, month12, 
                    hh_week,  mm_week,  week01,  week02,  week03,  week04,  week05,  week06,  week07,
                    hh_day,   mm_day,   day01,   day02,   day03,   day04,   day05,   day06,   day07,   day08,
                                        day09,   day10,   day11,   day12,   day13,   day14,   day15,   day16, 
                                        day17,   day18,   day19,   day20,   day21,   day22,   day23,   day24,
                                        day25,   day26,   day27,   day28,   day29,   day30,   day31,   
                              mm_hour,  hour00,  hour01,  hour02,  hour03,  hour04,  hour05,  hour06,  hour07,
                                        hour08,  hour09,  hour10,  hour11,  hour12,  hour13,  hour14,  hour15,
                                        hour16,  hour17,  hour18,  hour19,  hour20,  hour21,  hour22,  hour23,
                                        minute00,minute01,minute02,minute03,minute04,minute05,minute06,minute07,
                                        minute08,minute09,minute10,minute11,minute12,minute13,minute14,minute15,
                                        minute16,minute17,minute18,minute19,minute20,minute21,minute22,minute23,
                                        minute24,minute25,minute26,minute27,minute28,minute29,minute30,minute31,
                                        minute32,minute33,minute34,minute35,minute36,minute37,minute38,minute39,
                                        minute40,minute41,minute42,minute43,minute44,minute45,minute46,minute47,
                                        minute48,minute49,minute50,minute51,minute52,minute53,minute54,minute55,
                                        minute56,minute57,minute58,minute59,
                    hh_once,  mm_once,  gde11 ATTRIBUTES(UNBUFFERED)

    BEFORE INPUT
      LET g_before_input_done=FALSE
 
      CASE p_cmd
         WHEN "a" CALL cl_set_comp_entry("gde01", TRUE)          
         WHEN "u" CALL cl_set_comp_entry("gde01", FALSE)
      END CASE
      
      IF g_gde.gde18 = "Y" THEN
       	 CALL cl_set_comp_entry( "gde19", TRUE) 
      ELSE
         CALL cl_set_comp_entry( "gde19", FALSE) 
      END IF
 
      LET g_before_input_done=TRUE

    AFTER FIELD gde01
      IF g_gde.gde01 IS NOT NULL THEN 
        LET l_chr=g_gde.gde01 CLIPPED,'%'
        LET l_gde01=g_gde.gde01
        IF g_gde.gde01 <> g_gde01_t OR g_gde01_t IS NULL THEN   
          LET g_sql="SELECT COUNT(*) FROM gde_file WHERE gde01 LIKE '",l_chr,"' AND gde12 = '",g_gde12 ,"'"
          PREPARE p_cron_pregdecount FROM g_sql
          DECLARE p_cron_gde_count CURSOR FOR  p_cron_pregdecount
          OPEN p_cron_gde_count
          FETCH p_cron_gde_count INTO g_cnt

          IF g_cnt > 0 THEN        
            LET g_gde.gde01 = l_gde01 CLIPPED,"_",g_cnt USING "&&"
            DISPLAY g_gde.gde01 TO gde01
            LET g_gde01=g_gde.gde01
          END IF
        END IF
      END IF
      
    ON CHANGE gde04 
       CALL p_cron_schedule()   #重新調整畫面配置
 
    ON CHANGE gde18
       IF g_gde.gde18 = "Y" THEN
          CALL cl_set_comp_entry( "gde19", TRUE)  	      
       ELSE
          CALL cl_set_comp_entry( "gde19", FALSE)  
          LET g_gde.gde19 = "N"
          DISPLAY g_gde.gde19 TO gde19
       END IF
       CALL initPlant(g_cb_plant) 

    ON ACTION about
      CALL cl_about() 

    ON ACTION controlg 
      CALL cl_cmdask() 

    ON ACTION help      
      CALL cl_show_help() 

    ON IDLE g_idle_seconds  
      CALL cl_on_idle()
      CONTINUE INPUT 
         
    AFTER INPUT
      IF NOT INT_FLAG THEN
        CASE g_gde.gde04
          WHEN "W"
            IF gr_week.* = gr_week_t.* THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD week01
            END IF
            IF cl_null(mm_week) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD mm_week
            END IF
            IF cl_null(hh_week) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD hh_week
            END IF
            LET g_gde.gde05=hh_week
            LET g_gde.gde06=mm_week
            CALL p_cron_week("C") 
                        
          WHEN "M"
            IF gr_month.* = gr_month_t.* THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD month01
            END IF
            IF cl_null(mm_month) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD mm_nonth
            END IF
            IF cl_null(hh_month) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD hh_month
            END IF
            IF cl_null(dd_month) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD dd_month
            END IF
            LET g_gde.gde09=dd_month
            LET g_gde.gde05=hh_month
            LET g_gde.gde06=mm_month
            CALL p_cron_month("C")      
               
          WHEN "H"
            IF gr_hour.* = gr_hour_t.* THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD hour00
            END IF
            IF cl_null(mm_hour) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD mm_hour
            END IF
            LET g_gde.gde06=mm_hour
            CALL p_cron_hour("C") 

          WHEN "F"
            IF gr_minute.* = gr_minute_t.* THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD minute00
            END IF
            CALL p_cron_minute("C") 
                         
          WHEN "D"
            IF gr_day.* = gr_day_t.* THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD day01
            END IF
            IF cl_null(mm_day) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD mm_day
            END IF
            IF cl_null(hh_day) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD hh_day
            END IF
            LET g_gde.gde05=hh_day
            LET g_gde.gde06=mm_day
            CALL p_cron_day("C") 
            
          WHEN "O"
            IF cl_null(g_gde.gde11) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD gde11
            END IF
            IF cl_null(mm_once) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD mm_once
            END IF
            IF cl_null(hh_once) THEN
              CALL cl_err('',"azz-310",0)
              NEXT FIELD hh_once
            END IF
            LET g_gde.gde05=hh_once
            LET g_gde.gde06=mm_once
        
          OTHERWISE             
        END CASE
        
      END IF
  
  END INPUT
  
END FUNCTION



FUNCTION p_cron_a()

   DEFINE lst_time   base.StringTokenizer
   DEFINE li_time    LIKE type_file.num10
   DEFINE li_i       LIKE type_file.num10
 
   #系統關閉時不可新增
   IF s_shut(0) THEN
      RETURN 
   END IF
 
   CLEAR FORM
 
   INITIALIZE gr_month.* TO NULL
   INITIALIZE gr_week.* TO NULL
   INITIALIZE gr_day.* TO NULL
   INITIALIZE gr_hour.* TO NULL
   INITIALIZE gr_minute.* TO NULL
    
   LET hh_month =NULL
   LET hh_week  =NULL
   LET hh_day   =NULL
   LET hh_once  =NULL
   LET mm_month =NULL
   LET mm_week  =NULL
   LET mm_day   =NULL
   LET mm_hour  =NULL
   LET mm_once  =NULL
   LET dd_month =NULL
 
   INITIALIZE g_gde.* LIKE gde_file.*
   LET g_gde_t.* = g_gde.*
   LET g_gde_o.* = g_gde.*
   INITIALIZE g_gde01 TO NULL
   INITIALIZE g_gde12 TO NULL
   INITIALIZE g_gde01_t TO NULL
   
   CALL g_gdf.clear()
   INITIALIZE g_gdf_t.* TO NULL
   INITIALIZE g_gdf_o.* TO NULL
   INITIALIZE g_gdf02 TO NULL
  
   CALL g_gdi.clear() 
   INITIALIZE g_gdi_t.* TO NULL
   INITIALIZE g_gdi_o.* TO NULL
   INITIALIZE g_gdi04 TO NULL
   
   WHILE TRUE
     LET g_gde.gde03 = "Y"
     LET g_gde.gde18 = "N"
     LET g_gde.gde19 = "N"    
     LET g_gde.gde04 = "D"
     LET g_gde.gde15 = g_today
     LET g_gde.gde11 = g_today
     LET g_gde.gde12 = g_user 
     LET g_gde12 = g_gde.gde12
       
     #抓取現在時間
     LET li_i = 1
     LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")
     WHILE lst_time.hasMoreTokens()
        LET li_time = lst_time.nextToken()
        CASE li_i
           WHEN 1
              LET g_gde.gde05 = li_time USING "&&"
           WHEN 2
              LET g_gde.gde06 = li_time USING "&&"
       END CASE
       LET li_i = li_i + 1
     END WHILE
     LET g_gde.gde09 = DAY(TODAY) USING "&&"
 
     LET hh_day   = g_gde.gde05
     LET mm_day   = g_gde.gde06
     LET hh_day   = g_gde.gde05
     LET mm_month = g_gde.gde06
     LET mm_week  = g_gde.gde06
     LET mm_day   = g_gde.gde06
     LET mm_hour  = g_gde.gde06
     LET mm_once  = g_gde.gde06
     LET dd_month = g_gde.gde09
     LET hh_month = g_gde.gde05
     LET hh_week  = g_gde.gde05
     LET hh_once  = g_gde.gde05
 
     CALL p_cron_initWeek()                                                      
     CALL p_cron_initMonth() 
     CALL p_cron_initMinute()
     CALL p_cron_initHour()
     CALL p_cron_initDay()
 
     CALL p_cron_i("a")
     
     IF INT_FLAG THEN
        LET INT_FLAG = FALSE
        INITIALIZE g_gde.* TO NULL
        CLEAR FORM
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
     
     IF cl_null(g_gde.gde01) THEN
        CONTINUE WHILE
     END IF
 
     IF os.Path.separator() = "/" THEN
        #UNIX部份
        IF g_gde.gde04 = 'O' THEN
           IF g_gde.gde03 = 'Y' THEN
              IF NOT p_at_create() THEN
                 CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1) 
                 CONTINUE WHILE
              END IF 
           END IF
        ELSE
           LET g_gde.gde10 = os.Path.join(FGL_GETENV("TOP") CLIPPED,"p_cron"),os.Path.separator(),g_user CLIPPED,
                             os.Path.separator(),"p_cron.",g_gde.gde01 CLIPPED 
        END IF
     ELSE 
        #Windows部份
        LET g_gde.gde10 = os.Path.join(FGL_GETENV("TOP") CLIPPED,"p_cron"),os.Path.separator(),g_user CLIPPED,
                          os.Path.separator(),"p_cron.",g_gde.gde01 CLIPPED,".bat"
     END IF
 
     BEGIN WORK
      
     INSERT INTO gde_file VALUES(g_gde.*)

     IF SQLCA.sqlcode THEN
        CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1) 
 
        IF os.Path.separator() = "/" THEN
            IF g_gde.gde04 = 'O' THEN       #執行一次
               IF g_gde.gde03 = 'Y' THEN
                  IF NOT p_at_delete(g_gde.gde10) THEN
                     CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1)
                  END IF 
               END IF
            END IF
        END IF
 
        ROLLBACK WORK
        CONTINUE WHILE
     END IF
 
     IF os.Path.separator() = "/" THEN
        #UNIX部份
        IF g_gde.gde04 <> 'O' THEN     #不屬於只執行一次的就寫入 crontab
           IF NOT p_crontab_create() THEN
              CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1) 
              ROLLBACK WORK
              CONTINUE WHILE
           END IF
        END IF
     ELSE
        #Windows部份                   #全部都寫入 schtasks
        IF NOT p_schtasks_create() THEN
           CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1) 
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
     END IF
 
     COMMIT WORK
       
     SELECT gde01,gde12 INTO g_gde01 ,g_gde12
       FROM gde_file
      WHERE gde01 = g_gde.gde01 AND gde12 = g_gde.gde12
 
     LET g_gde_t.* = g_gde.*
     LET g_gde_o.* = g_gde.*
       
     CALL g_gdf.clear()
     CALL g_gdi.clear()
     LET g_rec_b_job = 0
     LET g_rec_b_para = 0
      
     CALL p_cron_b_job()
         
     EXIT WHILE
   END WHILE

END FUNCTION



FUNCTION p_cron_u()

   DEFINE lst_time   base.StringTokenizer                                       
   DEFINE li_time    LIKE type_file.num10
   DEFINE li_i       LIKE type_file.num10  
   DEFINE ls_msg     STRING

   #系統關閉
   IF s_shut(0) THEN
      RETURN
   END IF

   IF g_gde01 IS NULL OR g_gde12 IS NULL THEN
     CALL cl_err("",-400,0)
     RETURN 
   END IF

   SELECT * INTO g_gde.* FROM gde_file WHERE gde01 = g_gde01 AND gde12 = g_gde12
   IF sqlca.sqlcode THEN
     CALL cl_err("",-400,0)
     RETURN 
   END IF

   MESSAGE ""
   LET g_gde01_t=g_gde.gde01
    
   INITIALIZE gr_month.* TO NULL                                                
   INITIALIZE gr_week.* TO NULL                                                 
   INITIALIZE gr_day.* TO NULL                                                  
   INITIALIZE gr_hour.* TO NULL                                                 
   INITIALIZE gr_minute.* TO NULL                                               
                                                                                 
   LET hh_month =NULL                                                           
   LET hh_week  =NULL                                                           
   LET hh_day   =NULL                                                           
   LET hh_once  =NULL                                                           
   LET mm_month =NULL                                                           
   LET mm_week  =NULL                                                           
   LET mm_day   =NULL                                                           
   LET mm_hour  =NULL                                                           
   LET mm_once  =NULL                                                           
   LET dd_month =NULL                                                           

   CALL p_cron_initWeek()                                                    
   CALL p_cron_initMonth() 
   CALL p_cron_initMinute() 
   CALL p_cron_initHour() 
   CALL p_cron_initDay()  

   CASE g_gde.gde04  
     WHEN 'M' 
       IF cl_null(g_gde.gde08) OR g_gde.gde08 CLIPPED = "*" THEN
         CALL p_cron_month("C") 
       END IF
        
       IF cl_null(g_gde.gde09) OR g_gde.gde09 CLIPPED = "*" THEN
         LET g_gde.gde09 = DAY(TODAY) USING '&&'
       END IF
       IF cl_null(g_gde.gde05) OR g_gde.gde05 CLIPPED = "*" THEN
         LET li_i = 1                                                              
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")            
         WHILE lst_time.hasMoreTokens()                                            
           LET li_time = lst_time.nextToken()                                    
           CASE li_i                                                             
              WHEN 1                                                           
                LET g_gde.gde05 = li_time USING '&&'                                    
           END CASE                                                              
           LET li_i = li_i + 1                                                   
         END WHILE  
       END IF
       IF cl_null(g_gde.gde06) OR g_gde.gde06 CLIPPED = "*" THEN
         LET li_i = 1                                                          
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
         WHILE lst_time.hasMoreTokens()                                        
           LET li_time = lst_time.nextToken()                                  
           CASE li_i                                                           
             WHEN 2                                                           
               LET g_gde.gde06 = li_time USING '&&'                                    
           END CASE                                                            
           LET li_i = li_i + 1                                                 
         END WHILE  
       END IF
       IF cl_null(g_gde.gde07) OR g_gde.gde07 CLIPPED= "*" THEN
         CALL p_cron_week("C")   
       END IF

       LET g_gde.gde11=g_today
            
       IF cl_null(g_gde.gde12) THEN
         LET g_gde.gde12=g_user
       END IF
       LET gr_month.*=gr_month_t.*                                                  
       CALL p_cron_month("D")  
       LET dd_month =g_gde.gde09
       LET mm_day   =g_gde.gde06                                                   
       LET hh_day   =g_gde.gde05                                                   
       LET mm_month =g_gde.gde06                                                   
       LET mm_week  =g_gde.gde06                                                   
       LET mm_day   =g_gde.gde06                                                   
       LET mm_hour  =g_gde.gde06                                                   
       LET mm_once  =g_gde.gde06                                                   
       LET hh_month =g_gde.gde05                                                   
       LET hh_week  =g_gde.gde05                                                   
       LET hh_once  =g_gde.gde05  

     WHEN 'W'                                                  
       IF cl_null(g_gde.gde08) OR g_gde.gde08 CLIPPED = "*" THEN
         CALL p_cron_month("C") 
       END IF
       LET g_gde.gde09 =DAY(TODAY) USING "&&"
       IF cl_null(g_gde.gde05) OR g_gde.gde05 CLIPPED = "*" THEN
         LET li_i = 1                                                              
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")            
         WHILE lst_time.hasMoreTokens()                                            
           LET li_time = lst_time.nextToken()                                    
           CASE li_i                                                             
             WHEN 1                                                           
               LET g_gde.gde05 = li_time USING "&&"                                    
           END CASE                                                              
           LET li_i = li_i + 1                                                   
         END WHILE                   
       END IF
       IF cl_null(g_gde.gde06) OR g_gde.gde06 CLIPPED = "*" OR gr_minute.*=gr_minute_t.* THEN
         LET li_i = 1                                                          
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
         WHILE lst_time.hasMoreTokens()                                        
           LET li_time = lst_time.nextToken()                                  
           CASE li_i                                                           
             WHEN 2                                                           
               LET g_gde.gde06 = li_time USING "&&"                                    
           END CASE                                                            
           LET li_i = li_i + 1                                                 
         END WHILE     
       END IF
       IF cl_null(g_gde.gde07) OR g_gde.gde07 CLIPPED= "*" THEN
         CALL p_cron_week("C")  
       END IF

       LET g_gde.gde11=g_today
            
       IF cl_null(g_gde.gde12) THEN
         LET g_gde.gde12=g_user
       END IF
       LET gr_week.*=gr_week_t.*
       CALL p_cron_week("D")                                                                     
       LET dd_month = g_gde.gde09
       LET mm_day   = g_gde.gde06                                                   
       LET hh_day   = g_gde.gde05                                                   
       LET mm_month = g_gde.gde06                                                   
       LET mm_week  = g_gde.gde06                                                   
       LET mm_day   = g_gde.gde06                                                   
       LET mm_hour  = g_gde.gde06                                                   
       LET mm_once  = g_gde.gde06                                                   
       LET hh_month = g_gde.gde05                                                   
       LET hh_week  = g_gde.gde05                                                   
       LET hh_once  = g_gde.gde05  

     WHEN 'D' 
       IF cl_null(g_gde.gde08) OR g_gde.gde08 CLIPPED = "*" THEN
         CALL p_cron_month("C") 
       END IF
       IF cl_null(g_gde.gde09) OR g_gde.gde09 CLIPPED = "*" THEN
         CALL p_cron_day("C")
       END IF
       IF cl_null(g_gde.gde05) OR g_gde.gde05 CLIPPED = "*" THEN
         LET li_i = 1                                                              
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")            
         WHILE lst_time.hasMoreTokens()                                            
           LET li_time = lst_time.nextToken()                                    
           CASE li_i                                                             
             WHEN 1                                                           
               LET g_gde.gde05 = li_time USING "&&"                                    
           END CASE                                                              
           LET li_i = li_i + 1                                                   
         END WHILE                   
       END IF
       IF cl_null(g_gde.gde06) OR g_gde.gde06 CLIPPED = "*" THEN
         LET li_i = 1                                                          
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
         WHILE lst_time.hasMoreTokens()                                        
           LET li_time = lst_time.nextToken()                                  
           CASE li_i                                                           
             WHEN 2                                                           
               LET g_gde.gde06 = li_time USING "&&"                                   
           END CASE                                                            
           LET li_i = li_i + 1                                                 
         END WHILE     
       END IF
       IF cl_null(g_gde.gde07) OR g_gde.gde07 CLIPPED= "*" THEN
         CALL p_cron_week("C")   
       END IF

       LET g_gde.gde11=g_today
            
       IF cl_null(g_gde.gde12) THEN
         LET g_gde.gde12=g_user
       END IF
       LET gr_day.*=gr_day_t.*    
       CALL p_cron_day("D")                        
       LET dd_month=DAY(TODAY) USING "&&"  
       LET mm_day   =g_gde.gde06                                                   
       LET hh_day   =g_gde.gde05                                                   
       LET mm_month =g_gde.gde06                                                   
       LET mm_week  =g_gde.gde06                                                   
       LET mm_day   =g_gde.gde06                                                   
       LET mm_hour  =g_gde.gde06                                                   
       LET mm_once  =g_gde.gde06                                                   
       LET hh_month =g_gde.gde05                                                   
       LET hh_week  =g_gde.gde05                                                   
       LET hh_once  =g_gde.gde05  
      
     WHEN 'H'
       IF cl_null(g_gde.gde08) OR g_gde.gde08 CLIPPED = "*" THEN
         CALL p_cron_month("C") 
       END IF
       LET g_gde.gde09=DAY(TODAY) USING "&&"
       IF cl_null(g_gde.gde05) OR g_gde.gde05 CLIPPED = "*" THEN                   
         CALL p_cron_hour("C") 
       END IF

       LET li_i = 1                                                          
       LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
       WHILE lst_time.hasMoreTokens()                                        
         LET li_time = lst_time.nextToken()                                  
         CASE li_i                                                           
           WHEN 1                                                           
             LET hh_day= li_time USING  "&&"                                   
         END CASE                                                            
         LET li_i = li_i + 1                                                 
       END WHILE                                                             
       IF cl_null(g_gde.gde06) OR g_gde.gde06 CLIPPED = "*" THEN
         LET li_i = 1                                                          
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
         WHILE lst_time.hasMoreTokens()                                        
           LET li_time = lst_time.nextToken()                                  
           CASE li_i                                                           
             WHEN 2                                                           
               LET g_gde.gde06 = li_time USING "&&"                                    
           END CASE                                                            
           LET li_i = li_i + 1                                                 
         END WHILE     
       END IF
       IF cl_null(g_gde.gde07) OR g_gde.gde07 CLIPPED= "*" THEN
         CALL p_cron_week("C") 
       END IF

       LET g_gde.gde11=g_today
            
       IF cl_null(g_gde.gde12) THEN
         LET g_gde.gde12=g_user
       END IF
       LET gr_hour.*=gr_hour_t.*                                                   
       CALL p_cron_hour("D")                        
       LET dd_month =g_gde.gde09
       LET mm_day   =g_gde.gde06                                                   
       LET mm_month =g_gde.gde06                                                   
       LET mm_week  =g_gde.gde06                                                   
       LET mm_day   =g_gde.gde06                                                   
       LET mm_hour  =g_gde.gde06                                                   
       LET mm_once  =g_gde.gde06                                                   
       LET hh_month =hh_day                                                   
       LET hh_week  =hh_day                                                   
       LET hh_once  =hh_day  
      
     WHEN 'F'
       IF cl_null(g_gde.gde08) OR g_gde.gde08 CLIPPED = "*" THEN              
         CALL p_cron_month("C")                                                 
       END IF                                                                   
       LET g_gde.gde09=DAY(TODAY) USING "&&"                   
       LET li_i = 1                                                          
       LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
       WHILE lst_time.hasMoreTokens()                                        
         LET li_time = lst_time.nextToken()                                  
         CASE li_i                                                           
           WHEN 1                                                           
             LET g_gde.gde05 = li_time  USING "&&"                                   
         END CASE                                                            
         LET li_i = li_i + 1                                                 
       END WHILE                                                             
       IF cl_null(g_gde.gde06) OR g_gde.gde06 CLIPPED = "*" THEN
         CALL p_cron_minute("C")  
       END IF
       LET li_i = 1                                                          
       LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
       WHILE lst_time.hasMoreTokens()                                        
         LET li_time = lst_time.nextToken()                                  
         CASE li_i                                                           
           WHEN 2                                                           
             LET mm_hour= li_time USING "&&"                                    
         END CASE                                                            
         LET li_i = li_i + 1                                                 
       END WHILE     
       IF cl_null(g_gde.gde07) OR g_gde.gde07 CLIPPED= "*" THEN
         CALL p_cron_week("C") 
       END IF
 
       LET g_gde.gde11=g_today
            
       IF cl_null(g_gde.gde12) THEN
         LET g_gde.gde12=g_user
       END IF
       LET gr_minute.*=gr_minute_t.*                                                 
       CALL p_cron_minute("D")            
       LET dd_month =g_gde.gde09
       LET mm_day   =mm_hour                                                   
       LET hh_day   =g_gde.gde05                                                   
       LET mm_month =mm_hour                                                   
       LET mm_week  =mm_hour                                                   
       LET mm_day   =mm_hour                                                   
       LET mm_once  =mm_hour                                                   
       LET hh_month =g_gde.gde05                                                   
       LET hh_week  =g_gde.gde05                                                   
       LET hh_once  =g_gde.gde05  
 
     WHEN 'O'                                                        
       IF cl_null(g_gde.gde08) OR g_gde.gde08 CLIPPED = "*" THEN
         CALL p_cron_month("C") 
       END IF
       LET g_gde.gde09 =DAY(g_gde.gde11) USING "&&"
       IF cl_null(g_gde.gde05) OR g_gde.gde05 CLIPPED = "*" THEN
         LET li_i = 1                                                              
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")            
         WHILE lst_time.hasMoreTokens()                                            
           LET li_time = lst_time.nextToken()                                    
           CASE li_i                                                             
             WHEN 1                                                           
               LET g_gde.gde05 = li_time USING "&&"                                    
           END CASE                                                              
           LET li_i = li_i + 1                                                   
         END WHILE                   
       END IF
       IF cl_null(g_gde.gde06) OR g_gde.gde06 CLIPPED = "*" OR gr_minute.*=gr_minute_t.* THEN
         LET li_i = 1                                                          
         LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")        
         WHILE lst_time.hasMoreTokens()                                        
           LET li_time = lst_time.nextToken()                                  
           CASE li_i                                                           
             WHEN 2                                                           
               LET g_gde.gde06 = li_time USING "&&"                                    
           END CASE                                                            
           LET li_i = li_i + 1                                                 
         END WHILE     
       END IF
       IF cl_null(g_gde.gde07) OR g_gde.gde07 CLIPPED= "*" THEN
         CALL p_cron_week("C")  
       END IF
       IF cl_null(g_gde.gde11) THEN
         LET g_gde.gde11=g_today
       END IF   
       IF cl_null(g_gde.gde12) THEN
         LET g_gde.gde12=g_user
       END IF
       LET dd_month =g_gde.gde09
       LET hh_day   =g_gde.gde05                                                   
       LET mm_day   =g_gde.gde06                                                   
       LET hh_day   =g_gde.gde05                                                   
       LET mm_month =g_gde.gde06                                                   
       LET mm_week  =g_gde.gde06                                                   
       LET mm_day   =g_gde.gde06                                                   
       LET mm_hour  =g_gde.gde06                                                   
       LET mm_once  =g_gde.gde06                                                   
       LET hh_month =g_gde.gde05                                                   
       LET hh_week  =g_gde.gde05                                                   
       LET hh_once  =g_gde.gde05  
     OTHERWISE
       CALL cl_err("",-400,0)
       RETURN
   END CASE   
        
   BEGIN WORK

   OPEN p_cron_cl USING g_gde01,g_gde12
   IF STATUS THEN 
      CALL cl_err("OPEN p_cron_cl:",STATUS,1)
      CLOSE p_cron_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH p_cron_cl INTO g_gde.*
   IF SQLCA.sqlcode THEN
     CALL cl_err(g_gde.gde01,SQLCA.sqlcode,0)
     CLOSE p_cron_cl
     ROLLBACK WORK
     RETURN
   END IF

   CALL p_cron_show()

   WHILE TRUE
     LET g_gde01_t=g_gde.gde01
     LET g_gde_o.*=g_gde.*
     LET g_gde.gde12=g_user
     LET g_gde.gde15=g_today

     CALL p_cron_i("u")

     IF INT_FLAG THEN
       LET INT_FLAG = FALSE
       LET g_gde.*=g_gde_t.*
       CALL p_cron_show()
       CALL cl_err('',9001,0)
       EXIT WHILE
     END IF

     IF os.Path.separator() = "/" THEN 
        IF g_gde.gde04='O' THEN
           IF g_gde_t.gde04='O' THEN
              IF NOT p_at_change() THEN
                 CONTINUE WHILE   
              END IF
           ELSE
              IF NOT p_crontab_delete(g_gde_t.gde10) THEN
                 CONTINUE WHILE
              ELSE 
                 IF NOT p_at_create() THEN
                    CONTINUE WHILE
                 END IF
              END IF
           END IF
        END IF 
     END IF

     UPDATE gde_file  SET gde_file.* = g_gde.*
      WHERE gde01 = g_gde.gde01 AND gde12 = g_gde.gde12
    
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","gde_file","","",SQLCA.sqlcode,"","",1)
        CONTINUE WHILE
     END IF

     #FUN-BA0009 start
     LET ls_msg = "p_cron: Update gde:",
                  g_gde.gde01 CLIPPED,"--",g_gde.gde03 CLIPPED,"--",
                  g_gde.gde04 CLIPPED,"--",g_gde.gde12 CLIPPED
     IF cl_syslog("A","S",ls_msg) THEN END IF
     #FUN-BA0009 end

     IF os.Path.separator() = "/" THEN
        # UNIX 走cron
        IF g_gde.gde04 <> 'O' THEN
          IF g_gde_t.gde04 = 'O' THEN
            IF NOT p_at_delete(g_gde_t.gde10) THEN
              ROLLBACK WORK
              CONTINUE WHILE
            ELSE
              IF NOT p_crontab_create() THEN
                ROLLBACK WORK
                CONTINUE WHILE   
              END IF
            END IF 
          ELSE
             IF NOT p_crontab_change() THEN
                ROLLBACK WORK
                CONTINUE WHILE   
             END IF
          END IF
        END IF
     ELSE
        # WINDOWS 走 schtask
        IF NOT p_schtasks_change() THEN
           ROLLBACK WORK 
           CONTINUE WHILE
        END IF 
     END IF

     EXIT WHILE

   END WHILE
   CLOSE p_cron_cl
    
   COMMIT WORK
END FUNCTION



FUNCTION p_cron_x()

   DEFINE l_chr LIKE type_file.chr1
   
   #系統關閉
   IF s_shut(0) THEN
     RETURN
   END IF

   IF g_gde01 IS NULL OR g_gde12 IS NULL THEN
     CALL cl_err("",-400,0)
     RETURN 
   END IF

   BEGIN WORK

   OPEN p_cron_cl USING g_gde01,g_gde12
   IF STATUS THEN 
      CALL cl_err("OPEN p_cron_cl:",STATUS,1)
      CLOSE p_cron_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH p_cron_cl INTO g_gde.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gde.gde01,SQLCA.sqlcode,0)
      CLOSE p_cron_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success='Y'

   CALL p_cron_show()

   IF cl_exp(0,0,g_gde.gde03) THEN
      LET l_chr = g_gde.gde03
      IF g_gde.gde03='Y' THEN
         LET g_gde.gde03='N'
      ELSE
        LET g_gde.gde03='Y'
      END IF

     IF os.Path.separator() = "/" THEN 
        IF g_gde.gde04='O' THEN  
           IF NOT p_at_change() THEN
              LET g_success='N'
           END IF
        END IF
     END IF
     
     UPDATE gde_file SET gde03 = g_gde.gde03,
                         gde17 = g_gde.gde17,
                         gde15 = g_today  
                   WHERE gde01 = g_gde01 AND gde12 = g_gde12
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","gde_file",g_gde.gde03,"",SQLCA.sqlcode,"","",1)
        LET g_gde.gde03=l_chr
     END IF

     IF os.Path.separator() = "/" THEN 
        IF g_gde.gde04 <> 'O' THEN
           IF NOT p_crontab_change() THEN
              LET g_success='N'
           END IF 
        END IF
     END IF

   END IF

   CLOSE p_cron_cl

   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_gde.gde03,'V')
   ELSE
      ROLLBACK WORK
   END IF

   SELECT gde03,gde15 INTO g_gde.gde03,g_gde.gde15
     FROM gde_file
    WHERE gde01=g_gde01 AND gde12=g_gde12

   DISPLAY BY NAME g_gde.gde03,g_gde.gde15

END FUNCTION



FUNCTION p_cron_r()
   DEFINE ls_msg STRING

   #系統關閉
   IF s_shut(0) THEN
     RETURN
   END IF

   IF g_gde01 IS NULL OR g_gde12 IS NULL THEN 
     CALL cl_err("",-400,0)
     RETURN
   END IF

   SELECT * INTO g_gde.* FROM gde_file
    WHERE gde01 = g_gde01 AND gde12 = g_gde12

   IF g_gde.gde03 = 'N' THEN
     #CALL cl_err(g_gde.gde01,'msg1000',0) #mark by MOD-D10162
      CALL cl_err(g_gde.gde01,'cro-145',0) #MOD-D10162
      RETURN 
   END IF

   BEGIN WORK
   OPEN p_cron_cl USING g_gde01,g_gde12
   IF STATUS THEN
      CALL cl_err("OPEN p_cron_cl:",STATUS,1)
      CLOSE p_cron_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   IF cl_delete() THEN
      DELETE FROM gde_file WHERE gde01 = g_gde.gde01 AND gde12 = g_gde.gde12
      DELETE FROM gdf_file WHERE gdf01 = g_gde.gde01 AND gdf08 = g_gde.gde12
      DELETE FROM gdi_file WHERE gdi01 = g_gde.gde01 AND gdi03 = g_gde.gde12

      IF os.Path.separator() = "/" THEN
         #UNIX 用 cron
         IF g_gde.gde04='O' THEN
            IF NOT p_at_delete(g_gde.gde10) THEN
               ROLLBACK WORK
            END IF  
         ELSE
            IF NOT p_crontab_delete(g_gde.gde10) THEN
               ROLLBACK WORK
            END IF 
         END IF
      ELSE
         #Windows 用 schtask
         IF NOT p_schtasks_delete() THEN
            ROLLBACK WORK 
         END IF
      END IF
 
      #FUN-BA0009 start
      LET ls_msg = "p_cron: Delete Row:",
                   g_gde.gde01 CLIPPED,"--",g_gde.gde04 CLIPPED,"--",g_gde.gde12 CLIPPED
      IF cl_syslog("A","S",ls_msg) THEN END IF
      #FUN-BA0009 end

      CLEAR FORM
      CALL g_gdf.clear()
      CALL g_gdi.clear()
      OPEN p_cron_count
      #FUN-B60064-add-str--
      IF STATUS THEN
         CLOSE p_cron_cl
         CLOSE p_cron_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B60064-add-end--
      FETCH p_cron_count INTO g_row_count
      #FUN-B60064-add-str--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE p_cron_cl
         CLOSE p_cron_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B60064-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN p_cron_curs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count 
         CALL p_cron_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL p_cron_fetch('/')
      END IF  
   END IF

   CLOSE p_cron_cl
   COMMIT WORK

END FUNCTION



FUNCTION p_cron_bgjob()
  DEFINE lst_time   base.StringTokenizer
  DEFINE li_time    LIKE type_file.num10
  DEFINE l_i        LIKE type_file.num10
  DEFINE li_i       LIKE type_file.num10
  DEFINE l_chr      LIKE type_file.chr50
  DEFINE l_gde01    LIKE type_file.chr37

  CLEAR FORM

  INITIALIZE gr_month.* TO NULL
  INITIALIZE gr_week.* TO NULL
  INITIALIZE gr_day.* TO NULL
  INITIALIZE gr_hour.* TO NULL
  INITIALIZE gr_minute.* TO NULL

  LET hh_month =NULL
  LET hh_week  =NULL
  LET hh_day   =NULL
  LET hh_once  =NULL
  LET mm_month =NULL
  LET mm_week  =NULL
  LET mm_day   =NULL
  LET mm_hour  =NULL
  LET mm_once  =NULL
  LET dd_month =NULL


  INITIALIZE g_gde.* LIKE gde_file.*
  LET g_gde_t.* = g_gde.*
  LET g_gde_o.* = g_gde.*
  INITIALIZE g_gde01 TO NULL
  INITIALIZE g_gde12 TO NULL
  INITIALIZE g_gde01_t TO NULL  

  CALL g_gdf.clear()
  INITIALIZE g_gdf_t.* TO NULL
  INITIALIZE g_gdf_o.* TO NULL
  INITIALIZE g_gdf02 TO NULL

  CALL g_gdi.clear()
  INITIALIZE g_gdi_t.* TO NULL
  INITIALIZE g_gdi_o.* TO NULL
  INITIALIZE g_gdi04 TO NULL

  LET g_gde.gde03 = "Y"
  LET g_gde.gde18 = "N"
  LET g_gde.gde19 = "N"
  LET g_gde.gde04 = "D"
  LET g_gde.gde15 = g_today
  LET g_gde.gde11= g_today
  LET g_gde.gde12 = g_user
  LET g_gde12=g_gde.gde12

  LET li_i = 1
  LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")
  WHILE lst_time.hasMoreTokens()
    LET li_time = lst_time.nextToken()
    CASE li_i
      WHEN 1
        LET g_gde.gde05 = li_time USING "&&"
      WHEN 2
        LET g_gde.gde06 = li_time USING "&&"
    END CASE
    LET li_i = li_i + 1
  END WHILE
  LET g_gde.gde09 = DAY(TODAY) USING "&&"

  LET hh_day   =g_gde.gde05
  LET mm_day   =g_gde.gde06
  LET hh_day   =g_gde.gde05
  LET mm_month =g_gde.gde06
  LET mm_week  =g_gde.gde06
  LET mm_day   =g_gde.gde06
  LET mm_hour  =g_gde.gde06
  LET mm_once  =g_gde.gde06
  LET dd_month =g_gde.gde09
  LET hh_month =g_gde.gde05
  LET hh_week  =g_gde.gde05
  LET hh_once  =g_gde.gde05

  CALL p_cron_initWeek()
  CALL p_cron_initMonth()
  CALL p_cron_initMinute()
  CALL p_cron_initHour()
  CALL p_cron_initDay()

  LET g_gde.gde01 = g_app.trim()   
  LET l_chr=g_gde.gde01 CLIPPED,"%"
  LET l_gde01=g_gde.gde01
  SELECT COUNT(*) INTO g_cnt FROM gde_file
                              WHERE gde01 LIKE l_chr AND gde12 = g_gde12
  IF g_cnt > 0 THEN
      LET g_gde.gde01 = l_gde01 CLIPPED,"_",g_cnt USING "&&"
  END IF

  CALL p_cron_i("u")

  IF INT_FLAG THEN
    LET INT_FLAG = FALSE
    INITIALIZE g_gde.* TO NULL
    CLEAR FORM
    CALL cl_err('',9001,0)
    RETURN FALSE
  END IF
       
  IF os.Path.separator() = "/" THEN
     #UNIX
      IF g_gde.gde04='O' THEN
        IF g_gde.gde03 = 'Y' THEN
          IF NOT p_at_create() THEN
            CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1)
            RETURN FALSE
          END IF
        END IF
      ELSE
         LET g_gde.gde10 = os.Path.join(FGL_GETENV("TOP") CLIPPED,"p_cron"),os.Path.separator(),g_user CLIPPED,
                           os.Path.separator(),"p_cron.",g_gde.gde01 CLIPPED 
      END IF
  ELSE
     #Windows
     LET g_gde.gde10 = os.Path.join(FGL_GETENV("TOP") CLIPPED,"p_cron"),os.Path.separator(),g_user CLIPPED,
                       os.Path.separator(),"p_cron.",g_gde.gde01 CLIPPED,".bat"
  END IF
  
  BEGIN WORK

  INSERT INTO gde_file VALUES(g_gde.*);
  IF SQLCA.sqlcode THEN
    CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1)

    IF os.Path.separator() = "/" THEN
       IF g_gde.gde04 = 'O' THEN
          IF g_gde.gde03 = 'Y' THEN
             IF NOT p_at_delete(g_gde.gde10) THEN
                CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1)
             END IF 
          END IF
       END IF
    END IF

    ROLLBACK WORK
    RETURN FALSE
  END IF

  IF os.Path.separator() = "/" THEN
      IF g_gde.gde04 <> 'O' THEN
        IF NOT p_crontab_create() THEN
          CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1)
          ROLLBACK WORK
          RETURN FALSE
        END IF
      END IF
  ELSE
      IF NOT p_schtasks_create() THEN
        CALL cl_err(g_gde.gde01,SQLCA.sqlcode,1)
        ROLLBACK WORK
        RETURN FALSE 
      END IF
  END IF

  COMMIT WORK

  SELECT gde01,gde12 INTO g_gde01 ,g_gde12 FROM gde_file
                      WHERE gde01=g_gde.gde01 AND gde12=g_gde.gde12
   
  LET g_gde_t.* = g_gde.*
  LET g_gde_o.* = g_gde.*

  CALL g_gdf.clear()
  CALL g_gdi.clear()
  LET g_rec_b_job = 0
  LET g_rec_b_para = 0

  CALL p_cron_b_job()  

  IF g_flag  THEN
    LET g_flag = FALSE
    CALL g_gdf.clear()
    CLEAR FORM
    CALL cl_err('',9001,0)
    RETURN FALSE
  END IF

  CALL p_cron_b_para() 

  RETURN TRUE
END FUNCTION

FUNCTION p_cron_setpara(p_para)
DEFINE p_para        STRING

  DEFINE p_result    STRING
  DEFINE ls_macro    STRING
  DEFINE ls_para     STRING
  DEFINE ls_cmd      STRING
  DEFINE lst_macro   base.StringTokenizer
  DEFINE lst_end     base.StringTokenizer
  DEFINE l_i         LIKE type_file.num10
  DEFINE l_j         LIKE type_file.num10
  LET p_result=NULL
  LET ls_macro=NULL

  OPEN WINDOW setpara WITH FORM "azz/42f/p_cron_setpara"
  CALL cl_ui_locale("p_cron_setpara")
  LET l_i = p_para.getIndexOf("$(",1) 
  LET l_j = p_para.getIndexOf(")",l_i)
  IF ( l_i <> -1  AND l_i <> 0 AND l_j <> -1 AND l_j <> 0 ) THEN
    LET lst_macro = base.StringTokenizer.create(p_para,"$")
    LET l_i = 0
    WHILE lst_macro.hasMoreTokens()
      LET ls_macro=lst_macro.nextToken()
      LET l_i = l_i+1
      CASE l_i
        WHEN 1
          IF p_para.getIndexOf("$",1) = 1 THEN
            LET ls_para=ls_para.append("$")
          END IF
        OTHERWISE
          LET ls_para=ls_para.append("$")
      END CASE

      IF ls_macro.getIndexOf("(",1) <> 1 OR ls_macro.getIndexOf(")",1) = 0 THEN
        LET ls_para=ls_para.append(ls_macro)
          CONTINUE WHILE
      END IF
      
      LET l_i=ls_macro.getIndexOf(")",1)
      LET ls_cmd=ls_macro.subString(2,l_i-1) 
      CALL p_cron_setpara_i(ls_cmd) RETURNING p_result
      LET ls_para=ls_para.append("(")
      LET ls_para=ls_para.append(p_result)
      LET l_j=ls_macro.getLength()
      LET ls_macro=ls_macro.subString(l_i,l_j)
      LET ls_para=ls_para.append(ls_macro)
    END WHILE
    LET l_i=p_para.getLength()
    IF '$'==p_para.getCharAt(l_i) THEN
      LET ls_para=ls_para.append("$")
    END IF
    LET p_result=ls_para
  ELSE
    CALL p_cron_setpara_i(NULL) RETURNING p_result
    IF NOT cl_null(p_result) THEN
      LET ls_para=ls_para.append("$(")
      LET p_result=p_result.trim()
      LET ls_para=ls_para.append(p_result)
      LET ls_para=ls_para.append(")")
      LET p_result=ls_para
    END IF
  END IF

  CLOSE WINDOW setpara 
  RETURN p_result
END FUNCTION

FUNCTION p_cron_setpara_i(p_para)
DEFINE p_para        STRING
  DEFINE l_month       LIKE type_file.num10
  DEFINE l_nday        LIKE type_file.num10 
  DEFINE l_week        LIKE type_file.num10
  DEFINE l_weekday     LIKE type_file.num10
  DEFINE l_day         LIKE type_file.num10
  DEFINE l_method      STRING
  DEFINE l_para        STRING
  DEFINE l_str         STRING
  DEFINE l_str0        LIKE ze_file.ze03
  DEFINE l_str1        LIKE ze_file.ze03
  DEFINE l_str2        LIKE ze_file.ze03
  DEFINE l_str3        LIKE ze_file.ze03
  DEFINE l_str4        LIKE ze_file.ze03
  DEFINE l_str5        LIKE ze_file.ze03
  DEFINE l_str6        LIKE ze_file.ze03
  DEFINE l_str7        LIKE ze_file.ze03
  DEFINE l_str8        LIKE ze_file.ze03
  DEFINE lst_macro     base.StringTokenizer
  DEFINE l_i           LIKE type_file.num10
  DEFINE ls_macro      STRING
  DEFINE l_diff        LIKE type_file.num10

  INPUT l_method,l_month,l_day,l_week,l_weekday,l_nday,l_diff  #FUN-B70085
     FROM method,moth,day,week,weekday,nday,diff
 
    BEFORE INPUT 
      IF p_para IS NOT NULL THEN
        LET lst_macro = base.StringTokenizer.create(p_para,",")
        LET l_i = 0
        WHILE lst_macro.hasMoreTokens()
          LET ls_macro=lst_macro.nextToken() 
          LET l_i=l_i+1
          CASE l_i
            WHEN 1 
              LET ls_macro = ls_macro.trim()
              IF ls_macro.equals("#M") OR ls_macro.equals("#W") OR ls_macro.equals("#D") OR ls_macro.equals("#Y")THEN
                LET l_method=ls_macro.getCharAt(2)
              ELSE
                LET l_method=NULL
                EXIT WHILE
              END IF  

            WHEN 2
              CASE
                WHEN l_method.equals("M")
                  LET l_month = ls_macro.trim()
                WHEN l_method.equals("W")
                  LET l_week = ls_macro.trim()
                WHEN l_method.equals("D")   
                  LET l_nday = ls_macro.trim() 
                WHEN l_method.equals("Y")   
                  LET l_nday = ls_macro.trim()  
                OTHERWISE
              END CASE
            WHEN 3
              CASE
                WHEN l_method.equals("M")
                  LET l_day = ls_macro.trim()
                WHEN l_method.equals("W")
                  LET l_weekday = ls_macro.trim()
                OTHERWISE
              END CASE                
            WHEN 4
               IF l_method.equals("M") THEN    #FUN-B70085
                  LET l_diff = ls_macro.trim()
               END IF

            OTHERWISE 
          END CASE
        END WHILE
      END IF

      IF cl_null(l_method) THEN
        LET l_method = "M"
        LET l_month = 0 
        LET l_day=1
        LET l_week = 0
        LET l_weekday = 1
        LET l_nday = 0     
      END IF

      CASE
          WHEN l_method.equals("W")
           #CALL cl_set_comp_visible("moth,day,ndayi,diff", FALSE)  #FUN-B70085 ; mark by TQC-C60141 
            CALL cl_set_comp_visible("moth,day,nday,diff", FALSE)   #TQC-C60141
            CALL cl_set_comp_visible("week,weekday", TRUE)
          WHEN l_method.equals("D")
            CALL cl_set_comp_visible("moth,day,week,weekday,diff",FALSE)
            CALL cl_set_comp_visible("nday",TRUE)
          WHEN l_method.equals("Y")
            CALL cl_set_comp_visible("moth,day,week,weekday,diff",FALSE)
            CALL cl_set_comp_visible("nday",TRUE)  
          OTHERWISE
            CALL cl_set_comp_visible("moth,day", TRUE)
            CALL cl_set_comp_visible("week,weekday,nday", FALSE)
            IF l_day=32 THEN
               CALL cl_set_comp_visible("diff", TRUE)
            ELSE
               CALL cl_set_comp_visible("diff", FALSE)
            END IF
        END CASE

        DISPLAY l_method.trim() TO method
        DISPLAY l_month USING "++&" clipped TO moth  
        DISPLAY l_week USING "++&" clipped  TO week  
       #DISPLAY l_day USING "&&" clipped TO day #mark by CHI-CA0051
        DISPLAY l_day TO day                    #CHI-CA0051
        DISPLAY l_weekday USING "&" clipped TO weekday
        DISPLAY l_nday USING "+++&" clipped TO nday      
        IF cl_null(l_diff)  THEN                     #FUN-B70085
           LET l_diff=0
        END IF
        DISPLAY l_diff  USING "--&" clipped TO diff  #FUN-B70085

        SELECT ze03 INTO l_str0 FROM ze_file 
         WHERE ze01 = "cro-132" and ze02 = g_lang
        DISPLAY l_str0 TO commod
        SELECT ze03 INTO l_str5 FROM ze_file 
         WHERE ze01 = "cro-136" and ze02 = g_lang
        DISPLAY l_str5 TO commod5
        SELECT ze03 INTO l_str4 FROM ze_file 
         WHERE ze01 = "cro-137" and ze02 = g_lang
        DISPLAY l_str4 TO commod4
        SELECT ze03 INTO l_str1 FROM ze_file 
         WHERE ze01 = "cro-133" and ze02 = g_lang
        DISPLAY l_str1 TO commod1
        SELECT ze03 INTO l_str2 FROM ze_file 
         WHERE ze01 = "cro-134" and ze02 = g_lang
        DISPLAY l_str2 TO commod2
        SELECT ze03 INTO l_str3 FROM ze_file 
         WHERE ze01 = "cro-135" and ze02 = g_lang
        DISPLAY l_str3 TO commod3
        SELECT ze03 INTO l_str6 FROM ze_file
         WHERE ze01 = "cro-140" and ze02 = g_lang
        DISPLAY l_str6 TO commod1_1
        SELECT ze03 INTO l_str7 FROM ze_file
         WHERE ze01 = "cro-141" and ze02 = g_lang
        DISPLAY l_str7 TO commod3_1
        SELECT ze03 INTO l_str8 FROM ze_file
         WHERE ze01 = "cro-142" and ze02 = g_lang
        DISPLAY l_str8 TO commod4_1
      ON CHANGE method
        CASE
          WHEN l_method.equals("W") 
            CALL cl_set_comp_visible("moth,day,nday,diff", FALSE)  #FUN-B70085
            CALL cl_set_comp_visible("week,weekday", TRUE) 
          WHEN l_method.equals("D")
            CALL cl_set_comp_visible("moth,day,week,weekday,diff",FALSE)
            CALL cl_set_comp_visible("nday",TRUE)
          WHEN l_method.equals("Y")
            CALL cl_set_comp_visible("moth,day,week,weekday,diff",FALSE)
            CALL cl_set_comp_visible("nday",TRUE)  
          OTHERWISE       
            CALL cl_set_comp_visible("moth,day", TRUE)
            CALL cl_set_comp_visible("week,weekday,nday", FALSE)
        END CASE 
        LET l_month = 0 
        LET l_day=1
        LET l_week = 0
        LET l_weekday = 1
        LET l_nday = 0    
        DISPLAY l_method.trim() TO method
        DISPLAY l_month USING "++&" clipped TO moth
        DISPLAY l_week USING "++&" clipped  TO week
       #DISPLAY l_day USING "&&" clipped TO day #mark by CHI-CA0051
        DISPLAY l_day TO day                    #CHI-CA0051
        DISPLAY l_weekday USING "&" clipped TO weekday
        DISPLAY l_nday USING "+++&" clipped TO nday    

      ON CHANGE day        #FUN-B70085
         IF l_day=32 THEN       
            CALL cl_set_comp_visible("diff", TRUE)
         ELSE
            CALL cl_set_comp_visible("diff", FALSE)
         END IF

      AFTER INPUT
        IF INT_FLAG THEN                                                       
           EXIT INPUT                                                          
        END IF  
        CASE
          WHEN l_method.equals("M")
            LET l_para=l_para.append("#")
            LET l_para=l_para.append(l_method.trim())
            LET l_str=l_month USING "++&" clipped
            LET l_para=l_para.append(",")
            LET l_para=l_para.append(l_str.trim())
            LET l_str=l_day USING "&&" clipped
            LET l_para=l_para.append(",")
            LET l_para=l_para.append(l_str.trim())
            IF l_day=32 THEN                          #FUN-B70085
               LET l_para=l_para.append(",")
               LET l_para=l_para.append(l_diff)
            END IF
          WHEN l_method.equals("W")
            LET l_para=l_para.append("#")
            LET l_para=l_para.append(l_method.trim())
            LET l_str=l_week USING "++&"
            LET l_para=l_para.append(",")
            LET l_para=l_para.append(l_str.trim())
            LET l_str=l_weekday USING "&"
            LET l_para=l_para.append(",")
            LET l_para=l_para.append(l_str.trim())
          OTHERWISE
            LET l_para=l_para.append("#")
            LET l_para=l_para.append(l_method.trim())
            LET l_str=l_nday USING "+++&" clipped
            LET l_para=l_para.append(",")
            LET l_para=l_para.append(l_str.trim())
        END CASE
                                                                               
      ON IDLE g_idle_seconds                                                      
        CALL cl_on_idle()                                                        
        CONTINUE INPUT                                                           
    END INPUT
    IF INT_FLAG THEN                                                     
      LET INT_FLAG = 0                                                          
      RETURN p_para
    ELSE
      RETURN l_para                                                     
    END IF                                                                        
                                                                                
END FUNCTION


#啟動使用者設定的背景作業
PRIVATE FUNCTION p_cron_run()

   DEFINE l_ch         base.Channel
   DEFINE l_logFile    STRING
   DEFINE l_str        STRING
   DEFINE li_i         LIKE type_file.num10 
   DEFINE ls_cmd       STRING
   DEFINE li_j         LIKE type_file.num10
   DEFINE ls_para      STRING
   DEFINE li_k         LIKE type_file.num10
   DEFINE l_zz08       LIKE zz_file.zz08
   DEFINE lst_tok      base.StringTokenizer
   DEFINE li_status    LIKE type_file.num5
   DEFINE ls_fglgui    STRING 
   DEFINE ls_db        STRING
   DEFINE ls_bgjob     STRING
   DEFINE ls_mail_to   STRING
   DEFINE ls_mail_cc   STRING 
   DEFINE ls_mail_bcc  STRING
   DEFINE ls_mail      base.StringBuffer
   DEFINE ls_str       STRING
   DEFINE l_channel    base.Channel
   DEFINE l_azp03      LIKE azp_file.azp03    #TQC-B60040
   DEFINE ls_parentdb  STRING                 #TQC-B60040
   DEFINE ls_p_cron_user LIKE type_file.chr10 #MOD-C70134

   WHENEVER ERROR CONTINUE

   #MOD-C70134 --start--
   #若環境變數WEBUSER存在表示這個排程是由web登入設定的，讀取p_cron相關資料庫應該以WEBUSER這個使用者當key
   IF NOT cl_null(FGL_GETENV("WEBUSER")) THEN
      LET ls_p_cron_user = FGL_GETENV("WEBUSER")
   ELSE
      LET ls_p_cron_user = g_user
   END IF
   #MOD-C70134 --end--

   LET l_channel = base.channel.create()

   #設定記錄檔位置
   LET l_logFile = FGL_GETENV("TEMPDIR"), os.Path.separator(), "p_cron-", TODAY USING 'YYYYMMDD', ".log"

   LET l_ch = base.Channel.create()
   CALL l_ch.setDelimiter(NULL)
   CALL l_ch.openFile(l_logFile, "a")

   IF STATUS = 0 THEN
      LET l_str = "#--------------------------- (", CURRENT YEAR TO SECOND, " Start) ----------------------------#\n"
      CALL l_ch.write(l_str)

      LET g_sql = " SELECT gdf02,gdf03,gdf04,gdf05,gdf06,gdf07 FROM gdf_file ",
                   " WHERE gdf01 = ? AND gdf08 = ? ORDER BY gdf02 "
      PREPARE p_cron_prerun FROM g_sql
      DECLARE p_cron_cursrun CURSOR FOR p_cron_prerun 

      LET g_sql = " SELECT gdi05 FROM gdi_file ",
                   " WHERE gdi01 = ? AND gdi02 = ? AND gdi03 = ? ORDER BY gdi04 " 
      PREPARE p_cron_prepara FROM g_sql 
      DECLARE p_cron_curspara CURSOR FOR p_cron_prepara

      LET ls_mail = base.StringBuffer.create()

      FOR li_i = 1 TO g_para.getLength()  

         LET g_gde.gde01 = g_para[li_i].para CLIPPED   #填入作業名稱

         BEGIN WORK
        #OPEN p_cron_cl USING g_gde.gde01, g_user         #mark by MOD-C70134
         OPEN p_cron_cl USING g_gde.gde01, ls_p_cron_user #MOD-C70134
         IF STATUS THEN
            ROLLBACK WORK
            CONTINUE FOR
         END IF

         FETCH p_cron_cl INTO g_gde.*
         IF SQLCA.sqlcode THEN
            CLOSE p_cron_cl
            ROLLBACK WORK
            CONTINUE FOR
         END IF
        
         #把現在日期更新至 gde16(執行開始時間) 清空gde13(執行結束時間)
         LET g_gde.gde16 = g_today
         INITIALIZE g_gde.gde13 TO NULL

         UPDATE gde_file SET gde16 = g_gde.gde16 ,gde13 = g_gde.gde13
          WHERE CURRENT OF p_cron_cl 
        
         LET l_str = "p_cron        :   ",g_para[li_i].para 
         CALL l_ch.write(l_str)

         #抓取批次大項內要執行的各別作業
         CALL g_gdf.clear()
         LET g_cnt_job = 1
        #FOREACH p_cron_cursrun USING g_para[li_i].para,g_user         #mark by MOD-C70134
         FOREACH p_cron_cursrun USING g_para[li_i].para,ls_p_cron_user #MOD-C70134
            INTO g_gdf[g_cnt_job].gdf02,g_gdf[g_cnt_job].gdf03,g_gdf[g_cnt_job].gdf04,
                 g_gdf[g_cnt_job].gdf05,g_gdf[g_cnt_job].gdf06,g_gdf[g_cnt_job].gdf07  
            IF SQLCA.sqlcode THEN
               EXIT FOREACH
            END IF   
            LET g_cnt_job = g_cnt_job + 1
         END FOREACH   
         CALL g_gdf.deleteElement(g_cnt_job)
         
         #以下開始執行各別作業
         LET li_j = 1
         FOR li_j = 1 TO g_gdf.getLength()
           #LET l_str = "\nUser          :   ",g_user,           #mark by MOD-C70134
            LET l_str = "\nUser          :   ",ls_p_cron_user,   #MOD-C70134
                        "\nProgram       :   ",g_gdf[li_j].gdf03,
                        "\nPlant         :   ",g_gdf[li_j].gdf04
            CALL l_ch.write(l_str)

            #抓取各別作業所需要的參數 gdi_file (參數 gdi05 only)
            CALL g_gdi.clear()
            LET g_cnt_para = 1
           #FOREACH p_cron_curspara USING g_para[li_i].para,g_gdf[li_j].gdf02,g_user INTO g_gdi[g_cnt_para].gdi05         #mark by MOD-C70134
            FOREACH p_cron_curspara USING g_para[li_i].para,g_gdf[li_j].gdf02,ls_p_cron_user INTO g_gdi[g_cnt_para].gdi05 #MOD-C70134
               IF SQLCA.sqlcode THEN
                  EXIT FOREACH
               END IF
               LET g_cnt_para = g_cnt_para +1 
            END FOREACH
            CALL g_gdi.deleteElement(g_cnt_para)
           
            FOR li_k = 1 TO g_gdi.getLength() 
               LET g_gdi[li_k].gdi05 = p_cron_enpara(g_gdi[li_k].gdi05)
               LET g_gdi[li_k].gdi05 = p_cron_explainPara(g_gdi[li_k].gdi05)  #檢查參數內是否有p_cron函式(如TIME())
            END FOR
           
            FOR li_k = 1 TO g_gdi.getLength() 
               IF li_k = 1 THEN
                  LET ls_para = "'",g_gdi[li_k].gdi05
                  IF li_k = g_gdi.getLength() THEN
                     LET ls_para = ls_para,"'"
                  END IF
               ELSE
                  IF li_k = g_gdi.getLength() THEN
                     LET ls_para = ls_para,"' '",g_gdi[li_k].gdi05,"'"
                  ELSE
                     LET ls_para = ls_para, "' '",g_gdi[li_k].gdi05  
                  END IF
               END IF
            END FOR 

            SELECT zz08 INTO l_zz08 FROM zz_file WHERE zz01 = g_gdf[li_j].gdf03
            IF SQLCA.SQLCODE THEN
               EXIT FOR 
            ELSE
               #---------------------------------------------------------------------
               # 抓取 zz08 執行指令(前兩段字串 --- $FGLRUN xxxx), 後續若有訂立參數則忽略
               #---------------------------------------------------------------------
               LET lst_tok = base.StringTokenizer.create(l_zz08, " ")
               LET l_str = lst_tok.nextToken()
               LET l_zz08 = l_str
               LET l_str = lst_tok.nextToken()
               LET l_zz08 = l_zz08 CLIPPED, " ", l_str
            END IF 

            IF os.Path.separator() = "/" THEN
               LET ls_cmd = l_zz08," ",ls_para," 2>&1"
            ELSE
               LET ls_cmd = l_zz08," ",ls_para
            END IF

            LET ls_fglgui = FGL_GETENV("FGLGUI")
            LET ls_db = FGL_GETENV("DB")             
            LET ls_parentdb = FGL_GETENV("PARENTDB")       #TQC-B60040      
            LET ls_bgjob= FGL_GETENV("BGJOB")
            LET ls_mail_to = FGL_GETENV("MAIL_TO")
            LET ls_mail_cc = FGL_GETENV("MAIL_CC")
            LET ls_mail_bcc = FGL_GETENV("MAIL_BCC")
          
            CALL FGL_SETENV("FGLGUI","0")
            #CALL FGL_SETENV("DB",g_gdf[li_j].gdf04)        #TQC-B60040
            SELECT azp03 INTO l_azp03 
              FROM azp_file 
             WHERE azp01= g_gdf[li_j].gdf04
            CALL FGL_SETENV("DB", l_azp03 )                 #TQC-B60040
            CALL FGL_SETENV("PARENTDB",g_gdf[li_j].gdf04 )  #TQC-B60040
            CALL FGL_SETENV("BGJOB",1)

            IF NOT cl_null(g_gdf[li_j].gdf05) THEN 
               CALL ls_mail.clear()
               CALL p_cron_mailName(g_gdf[li_j].gdf05) RETURNING ls_str
               CALL ls_mail.append(ls_str)
               #CALL ls_mail.replace(";", "\\;", 0)       #FUN-B90011
               CALL FGL_SETENV("MAIL_TO",ls_mail.toString())
            END IF
            IF NOT cl_null(g_gdf[li_j].gdf06) THEN 
               CALL ls_mail.clear()
               CALL p_cron_mailName(g_gdf[li_j].gdf06) RETURNING ls_str
               CALL ls_mail.append(ls_str)
               #CALL ls_mail.replace(";", "\\;", 0)       #FUN-B90011
               CALL FGL_SETENV("MAIL_CC",ls_mail.toString())
            END IF
            IF NOT cl_null(g_gdf[li_j].gdf07) THEN 
               CALL ls_mail.clear()
               CALL p_cron_mailName(g_gdf[li_j].gdf07) RETURNING ls_str
               CALL ls_mail.append(ls_str)
               #CALL ls_mail.replace(";", "\\;", 0)       #FUN-B90011
               CALL FGL_SETENV("MAIL_BCC",ls_mail.toString())
            END IF

            #FUN-BC0016-henry-解決方法:若沒有設定mail,產生p_cron資料夾中的script時,還是會產生紀錄,但收件人的名稱和代號皆清空
            IF cl_null(g_gdf[li_j].gdf05) THEN 
               CALL FGL_SETENV("MAIL_TO","")
            END IF
            IF cl_null(g_gdf[li_j].gdf06) THEN 
               CALL FGL_SETENV("MAIL_CC","")
            END IF
            IF cl_null(g_gdf[li_j].gdf07) THEN 
               CALL FGL_SETENV("MAIL_BCC","")
            END IF
            #FUN-BC0016-henry-解決方法:若沒有設定mail,產生p_cron資料夾中的script時,還是會產生紀錄,但收件人的名稱和代號皆清空
          
            LET l_str = "\n[Full Command  :" 
                       ,"\n  export FGLGUI=\"",FGL_GETENV("FGLGUI"),"\";"
                       ,"\n  export DB=\"",FGL_GETENV("DB"),"\";"
                       ,"\n  export PARENTDB=\"",FGL_GETENV("PARENTDB"),"\";"
                       ,"\n  export BGJOB=\"",FGL_GETENV("BGJOB"),"\";"
            CALL l_ch.write(l_str)

            LET l_str = "\n  export MAIL_TO=\"",FGL_GETENV("MAIL_TO"),"\";"
                       ,"\n  export MAIL_CC=\"",FGL_GETENV("MAIL_CC"),"\";" 
                       ,"\n  export MAIL_BCC=\"",FGL_GETENV("MAIL_BCC"),"\";" 
            CALL l_ch.write(l_str)

            LET l_str = "\n  ",ls_cmd,";"
                       ,"\n]\n"
            CALL l_ch.write(l_str)

            CALL l_channel.setDelimiter("")
            CALL l_channel.openpipe(ls_cmd,"r")
            IF STATUS < 0 THEN 
               LET g_gde.gde13 = g_today
               LET g_gde.gde14 = 'N' 
               UPDATE gde_file SET gde13 = g_gde.gde13 , gde14 = g_gde.gde14 WHERE CURRENT OF p_cron_cl 

               CALL FGL_SETENV("FGLGUI",ls_fglgui)
               CALL FGL_SETENV("DB",ls_db)
               CALL FGL_SETENV("PARENTDB",ls_parentdb)   #TQC-B60040
               CALL FGL_SETENV("BGJOB",ls_bgjob)

               EXIT FOR
            ELSE
               WHILE l_channel.read(l_str)
                  CALL l_ch.write(l_str) 
               END WHILE
               CALL l_channel.close()

               CALL FGL_SETENV("FGLGUI",ls_fglgui)
               CALL FGL_SETENV("DB",ls_db)
               CALL FGL_SETENV("PARENTDB",ls_parentdb)   #TQC-B60040
               CALL FGL_SETENV("BGJOB",ls_bgjob)
               LET g_gde.gde13 = g_today
               LET g_gde.gde14 = 'Y'
               UPDATE gde_file SET gde13 = g_gde.gde13 , gde14 = g_gde.gde14 WHERE CURRENT OF p_cron_cl
            END IF
         END FOR
         COMMIT WORK
         CLOSE p_cron_cl 

      END FOR

      FREE p_cron_prerun 
      FREE p_cron_cursrun

      FREE p_cron_prepara 
      FREE p_cron_curspara

      LET l_str ="\n#--------------------------- (", CURRENT YEAR TO SECOND, " End) ------------------------------#\n"
      CALL l_ch.write(l_str)
      CALL l_ch.close()
      RUN "chmod 666 " || l_logFile || " >/dev/null 2>&1" WITHOUT WAITING

   ELSE 
      CALL l_ch.close()
      RETURN FALSE
   END IF

   RETURN TRUE
END FUNCTION




FUNCTION runApplication(pname)
  DEFINE pname STRING
  DEFINE cmd STRING
  DEFINE result LIKE type_file.num5 

  LET cmd = "$FGLRUN " || pname
  IF fgl_getenv("FGLGUI") == 1 THEN
    RUN cmd WITHOUT WAITING
  ELSE
    RUN cmd RETURNING result 
  END IF

  IF fgl_getenv("OS") MATCHES "Win*" THEN
    RETURN result
  ELSE
    RETURN ( result / 256 )
  END IF
END FUNCTION

FUNCTION runBatch(cmd, silent)
  DEFINE cmd STRING
  DEFINE silent STRING
  DEFINE result LIKE type_file.num5
  IF silent THEN
    RUN cmd IN FORM MODE RETURNING result
  ELSE
    RUN cmd IN LINE MODE RETURNING result
  END IF
  IF fgl_getenv("OS") MATCHES "Win*" THEN
    RETURN result
  ELSE
    RETURN ( result / 256 )
  END IF
END FUNCTION

FUNCTION p_cron_pre()
 
  DEFINE li_status   LIKE type_file.num10

  #----------
  # Create directory for placing every user's execution file
  #----------
  RUN "ls -d $TOP/p_cron >/dev/null 2>&1" RETURNING li_status
  IF li_status <> 0 THEN
    RUN "mkdir -p $TOP/p_cron >/dev/null 2>&1" RETURNING li_status
    IF li_status <> 0 THEN
      RETURN FALSE
    END IF

    RUN "chmod -R 777 $TOP/p_cron >/dev/null 2>&1"
  END IF
  #----------

  #----------
  # Create directory for placing every user's report file(generated by background job)
  #----------
  RUN "ls -d $TEMPDIR/p_cron >/dev/null 2>&1" RETURNING li_status
  IF li_status <> 0 THEN
    RUN "mkdir -p $TEMPDIR/p_cron >/dev/null 2>&1" RETURNING li_status
    IF li_status <> 0 THEN
      RETURN FALSE
    END IF

    RUN "chmod -R 777 $TEMPDIR/p_cron >/dev/null 2>&1"
  END IF
  #----------

  #----------
  # Create user directory for placing execution file
  #----------
  RUN "ls -d $TOP/p_cron/" || g_user CLIPPED || " >/dev/null 2>&1" RETURNING li_status
  IF li_status <> 0 THEN
    RUN "mkdir -p $TOP/p_cron/" || g_user CLIPPED || " >/dev/null 2>&1" RETURNING li_status
    IF li_status <> 0 THEN
      RETURN FALSE
    END IF

    RUN "chmod -R 777 $TOP/p_cron/" || g_user CLIPPED || " >/dev/null 2>&1"
  END IF
  #----------

  #----------
  # Create user directory for placing report file(generated by background job)
  #----------
  RUN "ls -d $TEMPDIR/p_cron/" || g_user CLIPPED || " >/dev/null 2>&1" RETURNING li_status
  IF li_status <> 0 THEN
    RUN "mkdir -p $TEMPDIR/p_cron/" || g_user CLIPPED || " >/dev/null 2>&1" RETURNING li_status
    IF li_status <> 0 THEN
      RETURN FALSE
    END IF

    RUN "chmod -R 777 $TEMPDIR/p_cron/" || g_user CLIPPED || " >/dev/null 2>&1"
  END IF
  #----------



RETURN TRUE
END FUNCTION

FUNCTION p_cron_env()
  DEFINE ls_result STRING
  DEFINE lch_pipe    base.Channel
        ,ls_buf      STRING
        ,ls_env      STRING
        ,li_pos      LIKE type_file.num10


  LET ls_result = "#!/bin/ksh\n"
  LET lch_pipe = base.Channel.create()
  CALL lch_pipe.openPipe("env", "r")
  WHILE lch_pipe.read(ls_buf)
    LET ls_buf = ls_buf.trim()
      CASE
        WHEN ls_buf.getIndexOf("FGLGUI", 1) <> 0
          CONTINUE WHILE
        #In AIX OS, you can't include 'LOGNAME' in the executed script!
        WHEN ls_buf.getIndexOf("LOGNAME", 1) <> 0  
          CONTINUE WHILE
        OTHERWISE
      END CASE

      LET li_pos = ls_buf.getIndexof("=",1)
      LET ls_env=ls_buf.substring(1,li_pos-1)
                     
      LET ls_result=ls_result,ls_env,"=\"",FGL_GETENV(ls_env),"\"; export ",ls_env,"\n"

   END WHILE
   CALL lch_pipe.close()
RETURN ls_result
END FUNCTION 


#產生UNIX cron執行shell script
FUNCTION p_crontab_create()

   DEFINE li_status   LIKE type_file.num10
   DEFINE ls_file     STRING
   DEFINE lch_file    base.Channel
   DEFINE ls_cronFile STRING
   DEFINE lch_pipe    base.Channel
   DEFINE ls_uname    STRING
   DEFINE ls_buf      STRING
   DEFINE li_i        LIKE type_file.num10
   DEFINE ls_cmd      STRING
   DEFINE l_zz08      LIKE zz_file.zz08
   DEFINE lst_tok     base.StringTokenizer
   DEFINE ls_str      STRING
   DEFINE l_gde10     STRING
 
   #Crontab time format revised
   CASE g_gde.gde04               #週期
      WHEN "D"                    #日
         LET g_gde.gde07 = "*"        #週
         LET g_gde.gde08 = "*"        #月
      WHEN "W"                    #週
         LET g_gde.gde08 = "*"        #月
         LET g_gde.gde09 = "*"        #日
      WHEN "M"                    #月
         LET g_gde.gde07 = "*"        #週
      WHEN "H"                    #時
         LET g_gde.gde07 = "*"        #週
         LET g_gde.gde08 = "*"        #月
         LET g_gde.gde09 = "*"        #日
      WHEN "F"                    #分
         LET g_gde.gde05 = "*"        #小時
         LET g_gde.gde07 = "*"        #週
         LET g_gde.gde08 = "*"        #月
         LET g_gde.gde09 = "*"        #日
      OTHERWISE 
        RETURN FALSE
   END CASE
 
   IF NOT p_cron_pre() THEN
     RETURN FALSE
   END IF
 
   # Test if 'crontab' can be executed properly,
   # for some OS(LIKE HP-UX), it should grant the executing privilege to user on system side first
   #----------
   RUN "crontab -l >/dev/null 2>&1" RETURNING li_status
   IF li_status <> 0 THEN
      LET ls_file = "/tmp/", g_user CLIPPED, ".", FGL_GETPID() USING '<<<<<<<<<<'
      LET lch_file = base.Channel.create()
      CALL lch_file.openFile(ls_file, "w")
      CALL lch_file.setDelimiter(NULL)
      CALL lch_file.write("0 0 * * * ls")
      CALL lch_file.close()
      RUN "crontab " || ls_file || " >/dev/null 2>&1" RETURNING li_status
      RUN "rm -f " || ls_file
      IF li_status <> 0 THEN
        RETURN FALSE
      ELSE
        RUN "crontab -r >/dev/null 2>&1"
      END IF
   END IF
   
   #----------
   # Prepare a temporary file to store current list of installed scheduled job
   #----------
   LET ls_cronFile = "/tmp/p_cron.", FGL_GETPID() USING '<<<<<<<<<<'
   LET lch_file = base.Channel.create()
   CALL lch_file.openFile(ls_cronFile, "w")
   CALL lch_file.setDelimiter(NULL)
 
   # Get OS type
   LET ls_uname = cl_get_os_type()
   LET l_gde10 = g_gde.gde10        #TQC-B60314
 
   LET lch_pipe = base.Channel.create()
   CALL lch_pipe.openPipe("crontab -l 2>/dev/null", "r")
   WHILE lch_pipe.read(ls_buf)

      # If OS is Linux, then need to ignore first three line,
      # because it will show three lines of comments while using 'crontab -l'
      # 當作業系統為 LINUX時，略去 crontab -l 前三行，那些是註解
      IF ( ls_uname.getIndexOf("LINUX",1) ) AND ( li_i <= 3 ) AND ( ls_buf.subString(1,2) = "# " ) THEN
         LET li_i = li_i + 1
         CONTINUE WHILE
      END IF

      IF ls_buf.getIndexOf(l_gde10,(ls_buf.getLength()-l_gde10.getLength()+1))>0 THEN #TQC-B60314
         LET li_i = li_i +1
         CONTINUE WHILE
      END IF

      CALL lch_file.write(ls_buf)
      LET li_i = li_i + 1

   END WHILE
 
   #----------
   # Writting execution time & command to 'crontab' file
   #----------
 
   INITIALIZE ls_buf TO NULL
 
   IF g_gde.gde03 = "N" OR g_gde.gde18 = "Y" THEN
      LET ls_buf = "#p_cron-"
   END IF
 
   LET ls_buf = ls_buf CLIPPED
                ,g_gde.gde06 CLIPPED
                ," ", g_gde.gde05 CLIPPED
                ," ", g_gde.gde09 CLIPPED
                ," ", g_gde.gde08 CLIPPED
                ," ", g_gde.gde07 CLIPPED
                ," ", g_gde.gde10 CLIPPED
   CALL lch_file.write(ls_buf)
   CALL lch_file.close()
   #---------
 
   LET ls_buf = p_cron_env()
 
   IF g_gui_type MATCHES "[23]" THEN
      LET ls_buf = ls_buf CLIPPED,"WEBUSER=", g_user CLIPPED, "; export WEBUSER\n"
   END IF
 
   SELECT zz08 INTO l_zz08 FROM zz_file WHERE zz01 = 'p_cron'
   IF SQLCA.SQLCODE THEN
      RETURN FALSE
   ELSE
      #---------------------------------------------------------------------
      # 抓取 zz08 執行指令(前兩段字串 --- $FGLRUN xxxx), 後續若有訂立參數則忽略
      #---------------------------------------------------------------------
      LET lst_tok = base.StringTokenizer.create(l_zz08, " ")
      LET ls_str = lst_tok.nextToken()
      LET l_zz08 = ls_str
      LET ls_str = lst_tok.nextToken()
      LET l_zz08 = l_zz08 CLIPPED, " ", ls_str
   END IF
 
   LET ls_buf = ls_buf CLIPPED,"cd $TEMPDIR\n"  #FUN-D40057
   LET ls_buf = ls_buf CLIPPED,l_zz08 CLIPPED," \"p_cron\" \"",g_gde.gde01,"\""
 
   LET lch_file = base.Channel.create()
   CALL lch_file.openFile(g_gde.gde10, "w")
   CALL lch_file.setDelimiter("")
 
   CALL lch_file.write(ls_buf);
 
   CALL lch_file.close()
 
   RUN "chmod 777 " || g_gde.gde10 CLIPPED || " >/dev/null 2>&1"
 
   LET ls_cmd= "crontab " || ls_cronFile 
   CALL runBatch(ls_cmd, TRUE) RETURNING li_status
   IF li_status <> 0 THEN
     
     LET ls_cmd =  "rm -f " || g_gde.gde10 CLIPPED || " >/dev/null 2>&1"
     CALL runBatch(ls_cmd,TRUE) RETURNING li_status
     IF li_status <> 0 THEN
 
     END IF
 
     LET ls_cmd =  "rm -f " || ls_cronFile CLIPPED || " >/dev/null 2>&1"
     CALL runBatch(ls_cmd,TRUE) RETURNING li_status
     IF li_status <> 0 THEN
 
     END IF
     
     RETURN FALSE 
   END IF
 
 
   LET ls_cmd =  "rm -f " || ls_cronFile CLIPPED || " >/dev/null 2>&1"
   CALL runBatch(ls_cmd,TRUE) RETURNING li_status
   IF li_status <> 0 THEN
 
   END IF
 
   RETURN TRUE
END FUNCTION


FUNCTION p_crontab_change()

   DEFINE lch_pipe    base.Channel
   DEFINE ls_buf      STRING
   DEFINE ls_uname    STRING 
   DEFINE li_i        LIKE type_file.num10
   DEFINE lch_file    base.Channel
   DEFINE l_gde10     STRING
   DEFINE ls_cmd      STRING
   DEFINE ls_cronFile STRING
   DEFINE li_status   LIKE type_file.num10 
   DEFINE li_flag     LIKE type_file.num5

   #----------
   #Crontab time format revised
   #----------
   CASE g_gde.gde04
     WHEN "D"
       LET g_gde.gde07 = "*"
       LET g_gde.gde08 = "*"
     WHEN "W" 
       LET g_gde.gde09 = "*"
       LET g_gde.gde08 = "*"
     WHEN "M"
       LET g_gde.gde07 = "*"
     WHEN "H"
       LET g_gde.gde08 = "*"
       LET g_gde.gde07 = "*"
       LET g_gde.gde09 = "*"
     WHEN "F"
       LET g_gde.gde08 = "*"
       LET g_gde.gde07 = "*"
       LET g_gde.gde09 = "*"
       LET g_gde.gde05 = "*"
     OTHERWISE
       RETURN FALSE
   END CASE

   #----------
   # Prepare a temporary file to store current list of installed scheduled job
   #----------
   LET ls_cronFile = "/tmp/p_cron.", FGL_GETPID() USING '<<<<<<<<<<'
   LET lch_file = base.Channel.create()
   CALL lch_file.openFile(ls_cronFile, "w")
   CALL lch_file.setDelimiter(NULL)

   LET l_gde10 = g_gde_t.gde10 CLIPPED
   LET li_flag =FALSE
   LET lch_pipe = base.Channel.create()

   # Get OS type
   LET ls_uname = cl_get_os_type()

   CALL lch_pipe.openPipe("crontab -l 2>/dev/null", "r")
   WHILE lch_pipe.read(ls_buf)

     #----------
     # If OS is Linux, then need to ignore first three line,
     # because it will show three lines of comments while using 'crontab -l'
     #----------
     IF ( ls_uname.getIndexOf("LINUX",1) ) AND ( li_i <= 3 ) AND ( ls_buf.subString(1,2) = "# " ) THEN
        LET li_i = li_i + 1
        CONTINUE WHILE
     END IF
     #----------

     IF NOT li_flag THEN
       IF ls_buf.getIndexOf(l_gde10,(ls_buf.getLength()-l_gde10.getLength()+1))>0 THEN   
         LET li_flag = TRUE
         LET li_i = li_i +1
         CONTINUE WHILE            
       END IF
     END IF

     CALL lch_file.write(ls_buf)
     LET li_i = li_i + 1
   END WHILE

   IF NOT li_flag THEN

     LET ls_cmd =  "rm -f " || ls_cronFile CLIPPED || " >/dev/null 2>&1"
     CALL runBatch(ls_cmd,TRUE) RETURNING li_status
     IF li_status <> 0 THEN

     END IF
     RETURN FALSE
   END IF

   #----------
   # Writting execution time & command to 'crontab' file
   #----------

   INITIALIZE ls_buf TO NULL
   IF g_gde.gde03 = "N" OR g_gde.gde18 = "Y" THEN
     LET ls_buf = "#p_cron-"
   END IF

   LET ls_buf = ls_buf CLIPPED
                ,g_gde.gde06 CLIPPED
                ," ", g_gde.gde05 CLIPPED
                ," ", g_gde.gde09 CLIPPED
                ," ", g_gde.gde08 CLIPPED
                ," ", g_gde.gde07 CLIPPED
                ," ", g_gde.gde10 CLIPPED
   CALL lch_file.write(ls_buf)
   CALL lch_file.close()
   #---------


   LET ls_cmd= "crontab " || ls_cronFile
   CALL runBatch(ls_cmd, TRUE) RETURNING li_status
   IF li_status <> 0 THEN
     LET ls_cmd =  "rm -f " || ls_cronFile CLIPPED || " >/dev/null 2>&1"
     CALL runBatch(ls_cmd,TRUE) RETURNING li_status
     IF li_status <> 0 THEN
     
     END IF
     RETURN FALSE
   END IF

   LET ls_cmd =  "rm -f " || ls_cronFile CLIPPED || " >/dev/null 2>&1"
   CALL runBatch(ls_cmd,TRUE) RETURNING li_status
   IF li_status <> 0 THEN

   END IF

   RETURN TRUE
END FUNCTION



FUNCTION p_crontab_delete(p_gde10)

  DEFINE p_gde10     LIKE gde_file.gde10 
  DEFINE lch_pipe    base.Channel
  DEFINE ls_buf      STRING
  DEFINE ls_uname    STRING 
  DEFINE li_i        LIKE type_file.num10
  DEFINE lch_file    base.Channel
  DEFINE l_gde10     STRING
  DEFINE ls_cmd      STRING
  DEFINE ls_cronFile STRING
  DEFINE li_status   LIKE type_file.num10 
  DEFINE li_flag     LIKE type_file.num5

  #----------
  # Prepare a temporary file to store current list of installed scheduled job
  #----------
  LET ls_cronFile = "/tmp/p_cron.", FGL_GETPID() USING '<<<<<<<<<<'
  LET lch_file = base.Channel.create()
  CALL lch_file.openFile(ls_cronFile, "w")
  CALL lch_file.setDelimiter(NULL)


  LET l_gde10 = p_gde10 CLIPPED
  LET li_flag =FALSE

  # Get OS type
  LET ls_uname = cl_get_os_type()

  LET lch_pipe = base.Channel.create()
  CALL lch_pipe.openPipe("crontab -l 2>/dev/null", "r")

  WHILE lch_pipe.read(ls_buf)
    #----------
    # If OS is Linux, then need to ignore first three line,
    # because it will show three lines of comments while using 'crontab -l'
    #----------
    IF ( ls_uname.getIndexOf("LINUX",1) ) AND ( li_i <= 3 ) AND ( ls_buf.subString(1,2) = "# " ) THEN
       LET li_i = li_i + 1
       CONTINUE WHILE
    END IF
    #----------

    IF NOT li_flag THEN
      IF ls_buf.getIndexOf(l_gde10,(ls_buf.getLength()-l_gde10.getLength()+1))>0 THEN   
        LET li_flag = TRUE
        LET li_i = li_i +1
        CONTINUE WHILE            
      END IF
    END IF

    CALL lch_file.write(ls_buf)
    LET li_i = li_i + 1
  END WHILE

  IF NOT li_flag THEN

    LET ls_cmd =  "rm -f " || ls_cronFile CLIPPED || " >/dev/null 2>&1"
    CALL runBatch(ls_cmd,TRUE) RETURNING li_status
    IF li_status <> 0 THEN

    END IF

    RETURN FALSE
  END IF

  LET ls_cmd= "crontab " || ls_cronFile
  CALL runBatch(ls_cmd, TRUE) RETURNING li_status
  IF li_status <> 0 THEN
    RETURN FALSE
  END IF

  
  LET ls_cmd =  "rm -f " || ls_cronFile CLIPPED || " >/dev/null 2>&1"
  CALL runBatch(ls_cmd,TRUE) RETURNING li_status
  IF li_status <> 0 THEN

  END IF
 
  LET ls_cmd =  "rm -f " || p_gde10 CLIPPED || " >/dev/null 2>&1"
  CALL runBatch(ls_cmd,TRUE) RETURNING li_status
  IF li_status <> 0 THEN

  END IF

  RETURN TRUE
END FUNCTION


FUNCTION p_at_create()
  DEFINE ls_year     STRING
        ,ls_month    STRING
        ,ls_day      STRING
        ,ls_hh       STRING
        ,ls_mm       STRING
        ,ls_job      STRING
        ,ls_file     STRING 
  DEFINE lch_pipe    base.Channel
        ,li_i        LIKE type_file.num10
        ,ls_buf      STRING
        ,ls_cmd      STRING
        ,l_str       STRING              
        ,ls_str      STRING              
        ,ls_at       base.StringTokenizer
        ,l_zz08      LIKE zz_file.zz08
        ,lch_file    base.Channel
        ,lst_tok     base.StringTokenizer

  IF NOT p_cron_pre() THEN
    RETURN FALSE
  END IF

  LET ls_file = os.Path.join(FGL_GETENV("TOP") CLIPPED,"p_cron"),os.Path.separator(),g_user CLIPPED,
                             os.Path.separator(),"p_cron.",g_gde.gde01 CLIPPED 
  LET ls_str = p_cron_env()

  IF g_gui_type MATCHES "[23]" THEN
     LET ls_str = ls_str CLIPPED,"WEBUSER=", g_user CLIPPED, "; export WEBUSER\n"
  END IF

  SELECT zz08 INTO l_zz08 FROM zz_file WHERE zz01 = 'p_cron'
  IF SQLCA.SQLCODE THEN
     RETURN FALSE 
  ELSE
    #---------------------------------------------------------------------
    # 抓取 zz08 執行指令(前兩段字串 --- $FGLRUN xxxx), 後續若有訂立參數則忽略
    #---------------------------------------------------------------------
    LET lst_tok = base.StringTokenizer.create(l_zz08, " ")
    LET l_str = lst_tok.nextToken()
    LET l_zz08 = l_str
    LET l_str = lst_tok.nextToken()
    LET l_zz08 = l_zz08 CLIPPED, " ", l_str
  END IF

  LET ls_str = ls_str CLIPPED,l_zz08 CLIPPED," \"p_cron\" \"",g_gde.gde01,"\"" 

  LET lch_file = base.Channel.create()
  CALL lch_file.openFile(ls_file, "w")
  CALL lch_file.setDelimiter("")       

  CALL lch_file.write(ls_str); 
  
  CALL lch_file.close()

  RUN "chmod 777 " || ls_file CLIPPED || " >/dev/null 2>&1"

  IF g_gde.gde03 = "Y" THEN
    LET ls_year =Year(g_gde.gde11) USING "&&&&"
    LET ls_month=Month(g_gde.gde11) USING "&&"
    LET ls_day  =Day(g_gde.gde11) USING "&&"
    LET ls_hh   =g_gde.gde05 USING "&&"
    LET ls_mm   =g_gde.gde06 USING "&&"
    LET ls_cmd = "at -f " || ls_file," -t " || ls_year || ls_month || ls_day || ls_hh || ls_mm || " 2>&1"            
    LET lch_pipe = base.Channel.create()
    CALL lch_pipe.openPipe(ls_cmd,"r")
    INITIALIZE ls_buf TO NULL
    WHILE lch_pipe.read(ls_buf)
      DISPLAY ls_buf,"\n"
      IF ls_buf.subString(1,3)="job " THEN
        LET li_i=1
        LET ls_at= base.StringTokenizer.create(ls_buf," ")
        WHILE ls_at.hasMoreTokens()
          LET ls_str = ls_at.nextToken()
          LET ls_str =ls_str.trim()
          CASE li_i
            WHEN 2
              LET ls_job=ls_str CLIPPED
            OTHERWISE
          END CASE
          LET li_i=li_i+1
        END WHILE
      ELSE
        RETURN FALSE
      END IF
    END WHILE
    LET g_gde.gde17=ls_job CLIPPED
  END IF

  LET g_gde.gde10=ls_file CLIPPED

RETURN TRUE
END FUNCTION


FUNCTION p_at_change()
  DEFINE li_status   LIKE type_file.num5
  DEFINE ls_cmd      STRING
        ,lst_tok     base.StringTokenizer
        ,ls_job      STRING  
        ,ls_file     STRING
        ,ls_str      STRING
        ,ls_buf      STRING
        ,li_flag     LIKE type_file.num5
        ,lch_pipe    base.Channel
  DEFINE ls_year     STRING
        ,ls_month    STRING
        ,ls_day      STRING
        ,ls_hh       STRING
        ,ls_mm       STRING
        ,ls_at       base.StringTokenizer
        ,li_i        LIKE type_file.num10

  
  IF g_gde_t.gde03 = "Y" THEN
 
    LET ls_job=g_gde_t.gde17 CLIPPED

    LET ls_cmd = "at -l "|| ls_job || " 2>&1"
    LET lch_pipe = base.Channel.create()
    CALL lch_pipe.openPipe(ls_cmd,"r")
    INITIALIZE ls_buf TO NULL
    LET li_flag=FALSE

    WHILE lch_pipe.read(ls_buf) 
      LET lst_tok = base.StringTokenizer.create(ls_buf, "\t") 
      IF NOT li_flag THEN
        IF lst_tok.hasMoreTokens() THEN  
          IF ls_job.equals(lst_tok.nextToken()) THEN 
            LET li_flag=TRUE
          ELSE
            CONTINUE WHILE
          END IF
        END IF    
      ELSE
        EXIT WHILE 
      END IF
    END WHILE

  ELSE
    LET li_flag=FALSE
  END IF 

  IF li_flag THEN
    LET ls_cmd = "at -d " || ls_job CLIPPED || " >/dev/null 2>&1"
    CALL runBatch(ls_cmd, TRUE) RETURNING li_status
    IF li_status <> 0 THEN 
      RETURN FALSE
    END IF
  END IF

  IF g_gde.gde03 = "Y" THEN
    LET ls_file=g_gde_t.gde10 CLIPPED
    LET ls_year =Year(g_gde.gde11) USING "&&&&"
    LET ls_month=Month(g_gde.gde11) USING "&&"
    LET ls_day  =Day(g_gde.gde11) USING "&&"
    LET ls_hh   =g_gde.gde05 USING "&&"
    LET ls_mm   =g_gde.gde06 USING "&&"
    LET ls_cmd = "at -f " || ls_file," -t " || ls_year || ls_month || ls_day || ls_hh || ls_mm || " 2>&1"
    LET lch_pipe = base.Channel.create()
    CALL lch_pipe.openPipe(ls_cmd,"r")
    INITIALIZE ls_buf TO NULL
    WHILE lch_pipe.read(ls_buf)
      DISPLAY ls_buf,"\n"
      IF ls_buf.subString(1,3)="job " THEN
        LET li_i=1
        LET ls_at= base.StringTokenizer.create(ls_buf," ")
        WHILE ls_at.hasMoreTokens()
          LET ls_str = ls_at.nextToken()
          LET ls_str = ls_str.trim()
          CASE li_i
            WHEN 2
              LET ls_job=ls_str CLIPPED
            OTHERWISE
          END CASE
          LET li_i=li_i+1
        END WHILE
      ELSE
        RETURN FALSE
      END IF
    END WHILE
    LET g_gde.gde17=ls_job CLIPPED

  ELSE
    INITIALIZE g_gde.gde17 TO NULL
  END IF

RETURN TRUE
END FUNCTION


FUNCTION p_at_delete(p_gde10)
DEFINE p_gde10 LIKE gde_file.gde10
  DEFINE li_status   LIKE type_file.num5
  DEFINE ls_cmd      STRING
        ,lst_tok     base.StringTokenizer
        ,ls_job      STRING  
        ,ls_file     STRING
        ,ls_str      STRING
        ,ls_buf      STRING
        ,li_flag     LIKE type_file.num5
        ,lch_pipe    base.Channel

 
  LET ls_job=g_gde.gde17 CLIPPED 
  LET ls_file=g_gde.gde10 CLIPPED

  LET ls_cmd = "at -l "|| ls_job || " 2>&1"
  LET lch_pipe = base.Channel.create()
  CALL lch_pipe.openPipe(ls_cmd,"r")
  INITIALIZE ls_buf TO NULL
  LET li_flag=FALSE

  WHILE lch_pipe.read(ls_buf) 
    LET lst_tok = base.StringTokenizer.create(ls_buf, "\t") 
    IF NOT li_flag THEN
      IF lst_tok.hasMoreTokens() THEN  
        IF ls_job.equals(lst_tok.nextToken()) THEN 
          LET li_flag=TRUE
        ELSE
          CONTINUE WHILE
        END IF
      END IF    
    ELSE
      EXIT WHILE 
    END IF
  END WHILE

  
  IF li_flag THEN
    LET ls_cmd = "at -d " || ls_job CLIPPED || " >/dev/null 2>&1"
    CALL runBatch(ls_cmd, TRUE) RETURNING li_status
    IF li_status <> 0 THEN 
      RETURN FALSE
    END IF

  END IF

  LET ls_cmd = "rm -f " || ls_file CLIPPED || " >/dev/null 2>&1" 
  CALL runBatch(ls_cmd, TRUE) RETURNING li_status
  IF li_status <> 0 THEN 
  END IF
  
RETURN TRUE
END FUNCTION


#產生Windows Schtasks 執行 shell script
FUNCTION p_schtasks_create()

   DEFINE ls_str     STRING 
   DEFINE li_i 	     LIKE type_file.num10
   DEFINE lst_time   base.StringTokenizer
   DEFINE li_time    LIKE type_file.num10

   CASE  g_gde.gde04
      WHEN 'O'
         LET ls_str="schtasks /create"
                   ," /tn \"",g_gde.gde01,"\""  
                   ," /tr \"",g_gde.gde10,"\"" 
                   ," /sc \"ONCE\""
                   ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                   ," /sd \"",g_gde.gde11,"\"" 
                   ," /F"
                   ," "
      WHEN 'D'
         LET ls_str="schtasks /create"
                   ," /tn \"",g_gde.gde01,"\""  
                   ," /tr \"",g_gde.gde10,"\"" 
                   ," /sc \"DAILY\""
                   ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                   ," /F"
                   ," "
      WHEN 'W' 
        LET ls_str="schtasks /create"
                  ," /tn \"",g_gde.gde01,"\""  
                  ," /tr \"",g_gde.gde10,"\"" 
                  ," /sc \"WEEKLY\""
                  ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                  ," /d \"",p_schtasks_week(g_gde.gde07),"\""
                  ," /F"
                  ," "
      WHEN 'M'
        LET ls_str="schtasks /create"
                  ," /tn \"",g_gde.gde01,"\""  
                  ," /tr \"",g_gde.gde10,"\"" 
                  ," /sc \"MONTHLY\""
                  ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                  ," /d \"",g_gde.gde09 USING "&&","\""
                  ," /m \"",p_schtasks_month(g_gde.gde08),"\""
                  ," /F"
                  ," "
      WHEN 'H'
        LET li_i = 1
        LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")
        WHILE lst_time.hasMoreTokens()
            LET li_time = lst_time.nextToken()
            CASE li_i
                 WHEN 1
                      LET g_gde.gde05 = li_time USING "&&"
            END CASE
            LET li_i = li_i + 1
        END WHILE

        LET ls_str="schtasks /create"
                  ," /tn \"",g_gde.gde01,"\""  
                  ," /tr \"",g_gde.gde10,"\"" 
                  ," /sc \"HOURLY\""
                  ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                  ," /F"
                  ," "
      WHEN 'F'
        LET ls_str="schtasks /create"
                  ," /tn \"",g_gde.gde01,"\""  
                  ," /tr \"",g_gde.gde10,"\"" 
                  ," /sc \"MINUTE\""
                  ," /F"
                  ," "
      OTHERWISE
   END CASE
   DISPLAY ls_str

   RUN ls_str RETURNING li_i
   IF li_i <> 0 THEN
      DISPLAY "ERROR:",ls_str,"\nSTATUS:",li_i
   END IF

   RETURN TRUE 
END FUNCTION



FUNCTION p_schtasks_change()

   DEFINE ls_str     STRING 
   DEFINE li_i       LIKE type_file.num10
   DEFINE lst_time   base.StringTokenizer
   DEFINE li_time    LIKE type_file.num10

   CASE  g_gde.gde04
     WHEN 'O'
       LET ls_str="schtasks /create"
                 ," /tn \"",g_gde.gde01,"\""  
                 ," /tr \"",g_gde.gde10,"\"" 
                 ," /sc \"ONCE\""
                 ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                 ," /sd \"",g_gde.gde11,"\"" 
                 ," /F"
                 ," "
     WHEN 'D'
       LET ls_str="schtasks /create"
                 ," /tn \"",g_gde.gde01,"\""  
                 ," /tr \"",g_gde.gde10,"\"" 
                 ," /sc \"DAILY\""
                 ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                 ," /F"
                 ," "
     WHEN 'W' 
       LET ls_str="schtasks /create"
                 ," /tn \"",g_gde.gde01,"\""  
                 ," /tr \"",g_gde.gde10,"\"" 
                 ," /sc \"WEEKLY\""
                 ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                 ," /d \"",p_schtasks_week(g_gde.gde07),"\""
                 ," /F"
                 ," "
     WHEN 'M'
       LET ls_str="schtasks /create"
                 ," /tn \"",g_gde.gde01,"\""  
                 ," /tr \"",g_gde.gde10,"\"" 
                 ," /sc \"MONTHLY\""
                 ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                 ," /d \"",g_gde.gde09 USING "&&","\""
                 ," /m \"",p_schtasks_month(g_gde.gde08),"\""
                 ," /F"
                 ," "
     WHEN 'H'
        LET li_i = 1
        LET lst_time = base.StringTokenizer.create(TIME(CURRENT), ":")
        WHILE lst_time.hasMoreTokens()
            LET li_time = lst_time.nextToken()
            CASE li_i
                 WHEN 1
                      LET g_gde.gde05 = li_time USING "&&"
            END CASE
            LET li_i = li_i + 1
        END WHILE

        LET ls_str="schtasks /create"
                  ," /tn \"",g_gde.gde01,"\""  
                  ," /tr \"",g_gde.gde10,"\"" 
                  ," /sc \"HOURLY\""
                  ," /st \"",g_gde.gde05 USING "&&",":",g_gde.gde06 USING "&&","\""
                  ," /F"
                  ," "
     WHEN 'F'
       LET ls_str="schtasks /create"
                 ," /tn \"",g_gde.gde01,"\""  
                 ," /tr \"",g_gde.gde10,"\"" 
                 ," /sc \"MINUTE\""
                 ," /F"
                 ," "
   END CASE
   DISPLAY ls_str

   RUN ls_str RETURNING li_i
   IF li_i <> 0 THEN
     DISPLAY "ERROR:",ls_str,"\nSTATUS:",li_i
   END IF

   RETURN TRUE 
END FUNCTION


#刪除 Windows平台下 schtask 內的啟動資料
FUNCTION p_schtasks_delete()

   DEFINE ls_str   STRING
   DEFINE li_i     LIKE type_file.num10
   
   LET ls_str="schtasks /delete /tn \"",g_gde.gde01,"\" /F"
   DISPLAY ls_str

   RUN ls_str RETURNING li_i
   IF li_i <> 0 THEN
      DISPLAY "ERROR:",ls_str,"\nSTATUS:",li_i
   END IF

   LET ls_str = "rm -f " || g_gde.gde10
   RUN ls_str RETURNING li_i
   IF li_i <> 0 THEN
      DISPLAY "ERROR:",ls_str,"\nSTATUS:",li_i
   END IF

   RETURN TRUE 
END FUNCTION



PRIVATE FUNCTION p_cron_enpara(p_para)

   DEFINE p_para  STRING
   DEFINE l_ret1  STRING
   DEFINE l_ret2  STRING
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_j     LIKE type_file.num5
   DEFINE l_k     LIKE type_file.num5
   DEFINE l_l     LIKE type_file.num5
   DEFINE l_str   STRING

   LET l_i = p_para.getIndexOf("$(",1)
   LET l_j = p_para.getIndexOf(")",l_i)

   IF (l_i < l_j) THEN
      LET l_i = 1
      LET l_j = 1
      LET l_k = 1
      LET l_l = 1
      LET l_str = p_para

      WHILE TRUE
        LET l_j = p_para.getIndexOf("$(",l_i) 
        LET l_k = p_para.getIndexOf(")",l_j)

        IF ( l_i = 0 OR l_i = -1 OR l_j = 0 OR l_j = -1 OR l_k = 0 OR l_k = -1 OR l_l = 0 OR l_l = -1 ) THEN
           EXIT WHILE
        ELSE
           IF p_para.getCharAt(l_j + 2) = "#" THEN
              IF cl_null(l_ret1) THEN
                 LET l_ret1 = "time:",p_para clipped,";"
              END IF
              LET l_ret2=l_ret2.append(p_para.subString(l_i,l_j-1))
              LET l_ret2=l_ret2.append("TIME(")
              LET l_ret2=l_ret2.append(p_para.subString(l_j+3,l_k-1))
              LET l_ret2=l_ret2.append(")")
              LET l_l=p_para.getIndexOf("$(",l_k)
              IF (l_l = 0 OR l_l = -1 ) THEN
                 LET l_l=p_para.getLength()+1
              END IF
              LET l_i=l_l
              LET l_ret2=l_ret2.append(p_para.subString(l_k+1,l_l-1))
           ELSE           
              IF cl_null(l_ret1) THEN
                 LET l_ret1 = "time:",p_para clipped,";"
              END IF
              LET l_ret2=l_ret2.append(p_para.subString(l_i,l_j-1))
              LET l_ret2=l_ret2.append("UNKOWN(")
              LET l_ret2=l_ret2.append(p_para.subString(l_j+3,l_k-1))
              LET l_ret2=l_ret2.append(")")
              LET l_l=p_para.getIndexOf("$(",l_k)
              IF (l_l = 0 OR l_l = -1 ) THEN
                 LET l_l=p_para.getLength()+1
              END IF
              LET l_i=l_l
              LET l_ret2=l_ret2.append(p_para.subString(l_k+1,l_l-1))
           END IF
        END IF  

        LET l_l = p_para.getIndexOf("$(",l_k)
        IF (l_l = 0 OR l_l = -1 ) THEN
           LET l_l=p_para.getLength() 
        END IF
      END WHILE
   ELSE
      LET l_ret2 = "PARA(",p_para clipped,")"
   END IF
   RETURN l_ret2
END FUNCTION



FUNCTION p_cron_depara(p_str)

   DEFINE p_str STRING
   IF p_str.substring(1,5) = "para:" THEN
      RETURN p_str.subString(6,p_str.getLength())
   END IF
   IF p_str.substring(1,5) = "time:" THEN
      RETURN p_str.subString(6,p_str.getLength())
   END IF

   RETURN ''
END FUNCTION



FUNCTION p_cron_mailName(p_str)

   DEFINE p_str     STRING
   DEFINE l_restr   STRING
   DEFINE l_tmp     STRING
   DEFINE l_str     STRING
   DEFINE l_str1    STRING
   DEFINE l_str2    STRING
   DEFINE l_str3    STRING
   DEFINE l_index   LIKE type_file.num10
   DEFINE l_tok     base.StringTokenizer   
   
   #123@dsc.com.tw:123 Lin:5 轉成 123@dsc.com.tw:'123 Lin':5
   LET l_tok = base.StringTokenizer.createExt(p_str CLIPPED,";","",TRUE)	#指定分隔符號
   WHILE l_tok.hasMoreTokens()	#依序取得子字串
      LET l_tmp=l_tok.nextToken()
      LET l_index = l_tmp.getIndexOf(":" ,1)
      LET l_str1 = l_tmp.substring(1, l_index-1)                  #123@dsc.com.tw
      LET l_str = l_tmp.substring(l_index+1, l_tmp.getLength())   #123 Lin:5
      LET l_index = l_str.getIndexOf(":" ,1)
      LET l_str2 = l_str.substring(1, l_index-1)                  #123 Lin
      LET l_str3 = l_str.substring(l_index+1, l_str.getLength())  #5      

      IF cl_null(l_restr) THEN 
         LET l_restr = l_str1 CLIPPED,":'",l_str2 CLIPPED,"':",l_str3 CLIPPED
      ELSE
         LET l_restr = l_restr CLIPPED,";",l_str1 CLIPPED,":'",l_str2 CLIPPED,"':",l_str3 CLIPPED
      END IF
   END WHILE
   
   RETURN l_restr
END FUNCTION



FUNCTION p_cron_replace_str(ps_source, ps_old, ps_new)
   DEFINE ps_source,ps_old,ps_new STRING
   DEFINE ls_source_left,ls_source_right,ls_result STRING
   DEFINE li_old_index  LIKE type_file.num5
 
   LET li_old_index = ps_source.getIndexOf(ps_old, 1)
 
   IF (li_old_index >= 1) THEN
      IF li_old_index = 1 THEN
         LET ls_source_left = ""
      ELSE
         LET ls_source_left = ps_source.subString(1, li_old_index-1)
      END IF
      LET ls_source_right = ps_source.subString(li_old_index+ps_old.getLength(), ps_source.getLength())
      LET ls_result = ls_result,ls_source_left,ps_new,p_cron_replace_str(ls_source_right, ps_old, ps_new)
   ELSE
      LET ls_result =ls_result,ps_source
   END IF
 
   RETURN ls_result
END FUNCTION


#Report List

FUNCTION p_cron_l()

  DEFINE lch_cmd      base.Channel
  DEFINE ls_cmd       STRING
  DEFINE ls_buf       STRING
  DEFINE ls_tok       STRING
  DEFINE ls_file      STRING
  DEFINE li_i         LIKE type_file.num10
  DEFINE li_cnt       LIKE type_file.num10
  DEFINE li_row       LIKE type_file.num10
  DEFINE li_status    LIKE type_file.num10
  DEFINE lst_report   base.StringTokenizer
  DEFINE la_report    DYNAMIC ARRAY OF RECORD
                        xdate1      LIKE type_file.chr1000,
                        xtime       LIKE type_file.chr1000,
                        xline       LIKE type_file.chr1000,
                        xreport     LIKE type_file.chr1000
                     END RECORD

  #----------
  # List report files generated from background job
  # Remark: file name looks LIKE: "2004-11-01.10:00.aimr100.60r"
  #----------
  CALL la_report.clear()
  LET lch_cmd = base.Channel.create()

  IF os.Path.separator() = "/" THEN
     LET ls_cmd = "cd $TEMPDIR/p_cron/", g_user CLIPPED,"; ls -t * 2>/dev/null"
  ELSE
     LET ls_cmd = "cd ",os.Path.join(FGL_GETENV("TEMPDIR"),"p_cron"),os.Path.separator(), g_user CLIPPED,"; dir/b 2>NUL"
  END IF

  LET li_cnt = 0
  CALL lch_cmd.openPipe(ls_cmd, "r")
  WHILE lch_cmd.read(ls_buf)
    LET li_cnt = li_cnt + 1

    LET li_i = 1
    LET lst_report = base.StringTokenizer.create(ls_buf, ".")
    WHILE lst_report.hasMoreTokens()
      LET ls_tok = lst_report.nextToken()
      CASE li_i
        #----------
        # Get generated day of report file
        #----------
        WHEN 1
          LET la_report[li_cnt].xdate1 = ls_tok

          #----------
          # Get generated time of report file
          #----------
        WHEN 2
          LET la_report[li_cnt].xtime = ls_tok

          #----------
          # Get line number per page of report file
          #----------
        WHEN 3
          IF lst_report.countTokens() = 1 THEN
            LET la_report[li_cnt].xline = "-1"
            LET la_report[li_cnt].xreport = ls_tok
          ELSE
            LET la_report[li_cnt].xline = ls_tok
          END IF

          #----------
          # Get displayed file name
          #----------
        OTHERWISE
          IF la_report[li_cnt].xreport IS NOT NULL THEN
            LET la_report[li_cnt].xreport = la_report[li_cnt].xreport, "."
          END IF
          LET la_report[li_cnt].xreport = la_report[li_cnt].xreport, ls_tok
      END CASE

      LET li_i = li_i + 1
    END WHILE
  END WHILE
  CALL lch_cmd.close()

  OPEN WINDOW p_cron_rl_w WITH FORM "azz/42f/p_cron_rl"
     ATTRIBUTE(STYLE = g_win_style CLIPPED)
  CALL cl_ui_locale("p_cron_rl")

  DISPLAY ARRAY la_report TO s_report.* ATTRIBUTE(COUNT=li_cnt, UNBUFFERED)

    BEFORE DISPLAY 
      CALL DIALOG.setActionHidden("accept", TRUE)
      CALL DIALOG.setActionHidden("cancel", TRUE)

      #----------
      # If there's no any report file, then disable 'delete' action
      #----------
      IF li_cnt = 0 THEN
         CALL DIALOG.setActionActive("delete", FALSE)
      END IF

     AFTER DISPLAY
       CONTINUE DISPLAY

     BEFORE ROW 
       LET li_row = ARR_CURR()

     ON ACTION delete
       IF cl_delete() THEN
          LET ls_cmd = "rm -f $TEMPDIR/p_cron/" , g_user CLIPPED , "/" , la_report[li_row].xdate1 CLIPPED , "." , la_report[li_row].xtime CLIPPED , "." , la_report[li_row].xreport 
          RUN ls_cmd RETURNING li_status
          IF li_status = 0 THEN
           CALL la_report.deleteElement(li_row)
           LET li_cnt = li_cnt - 1

           #----------
           # After deletion, if there's no morereport file, then disable 'delete' action
           #----------
           IF li_cnt = 0 THEN
             CALL DIALOG.setActionActive("delete", FALSE)
           END IF
           #----------

         END IF

         ACCEPT DISPLAY
       END IF

     ON ACTION output
       LET ls_file = FGL_GETPID() USING '<<<<<<<<<<', ".rep"
       #TQC-610031 BEGIN
       IF la_report[li_row].xline = "-1" THEN
         LET ls_cmd = "cp -p $TEMPDIR/p_cron/" , g_user CLIPPED , "/" , la_report[li_row].xdate1 CLIPPED , "." , la_report[li_row].xtime CLIPPED , "." , la_report[li_row].xreport , " $TEMPDIR/" , ls_file
         RUN ls_cmd
         LET g_page_line = 66
       ELSE
         LET ls_cmd  = "cp -p $TEMPDIR/p_cron/" , g_user CLIPPED , "/" , la_report[li_row].xdate1 CLIPPED , "." , la_report[li_row].xtime CLIPPED , "." , la_report[li_row].xline , "." , la_report[li_row].xreport , " $TEMPDIR/" , ls_file
         RUN ls_cmd
         LET g_page_line = la_report[li_row].xline
       END IF
       #TQC-610031 END
       CALL cl_prt(ls_file, NULL, '1', 66)
       RUN "rm -f $TEMPDIR/" || ls_file
       MESSAGE ''

     ON ACTION exit
       EXIT DISPLAY

     ON ACTION cancel
       IF INT_FLAG THEN
         LET INT_FLAG = FALSE
       END IF
       EXIT DISPLAY
   
     ON ACTION accept

       #----------
       # While double click the entry, same as 'output' action
       #----------
       LET ls_file = FGL_GETPID() USING '<<<<<<<<<<', ".rep"
       #TQC-610031 BEGIN
       IF la_report[li_row].xline = -1 THEN
         LET ls_cmd = "cp -p $TEMPDIR/p_cron/" , g_user CLIPPED , "/" , la_report[li_row].xdate1 CLIPPED , "." , la_report[li_row].xtime CLIPPED , "." , la_report[li_row].xreport , " $TEMPDIR/" , ls_file
         RUN ls_cmd
         LET g_page_line = 66
       ELSE
         LET ls_cmd = "cp -p $TEMPDIR/p_cron/" , g_user CLIPPED , "/" , la_report[li_row].xdate1 CLIPPED, "." , la_report[li_row].xtime CLIPPED , "." || la_report[li_row].xline clipped , "* $TEMPDIR/" , ls_file
         RUN ls_cmd
         LET g_page_line = la_report[li_row].xline
       END IF
       #TQC-610031 END
       CALL cl_prt(ls_file, NULL, '1', 66)
       RUN "rm -f $TEMPDIR/" || ls_file
       MESSAGE ''
       #----------
 
     ON IDLE g_idle_seconds
       CALL cl_on_idle()

     ON ACTION about         
       CALL cl_about()      
 
     ON ACTION help          
       CALL cl_show_help()  
 
     ON ACTION controlg     
       CALL cl_cmdask()     
 
   END DISPLAY

   CLOSE WINDOW p_cron_rl_w
 
END FUNCTION


#轉換在記錄內的公式定義
PRIVATE FUNCTION p_cron_explainPara(p_para)

   DEFINE p_para       STRING
   DEFINE l_para       STRING
   DEFINE l_newpara    STRING
   DEFINE l_time       base.StringTokenizer
   DEFINE l_str1       STRING
   DEFINE l_char       STRING
   DEFINE l_i          LIKE type_file.num10
   DEFINE l_newyear    LIKE type_file.num10
   DEFINE l_newmonth   LIKE type_file.num10
   DEFINE l_newday     LIKE type_file.num10
   DEFINE l_year       LIKE type_file.num10
   DEFINE l_des        STRING
   DEFINE l_month      STRING
   DEFINE l_week       STRING
   DEFINE l_weekday    STRING
   DEFINE l_day        STRING
   DEFINE l_nday       STRING 
   DEFINE l_recycle    STRING
   DEFINE l_today      DATE 
   DEFINE l_s          LIKE type_file.num5
   DEFINE l_j          LIKE type_file.num5
   DEFINE l_k          LIKE type_file.num5
   DEFINE l_l          LIKE type_file.num5
   DEFINE l_ret        STRING
   DEFINE l_diff       LIKE type_file.num5      #FUN-B70085

   #如果參數是時間性的動態參數, 形式為 TIME(M,+1,3) W按照月，日設置,+1,3後一個月的３號
   #                            或者為 TIME(W,-1,3) W按照週，禮拜設置，-1,3前一週的禮拜三
   #                                   TIME(D,+1)   D按日設置，+/-１代表執行當時日期的前或后一天
   #如果為一般的靜態的參數,形式為:PARA(-d)

   IF NOT cl_null(p_para) THEN

      #對一般參數的處理 如果為一般的靜態的參數,形式為:PARA(-d)
      LET l_para = p_para
      IF l_para.getIndexOf("PARA(",1) THEN
         LET l_newpara = l_para.subString(6,l_para.getLength()-1)
         LET l_ret = l_newpara CLIPPED
      END IF

      #時間性的動態參數
      LET l_s = p_para.getIndexOf("TIME(",1)
      LET l_j = p_para.getIndexOf(")",l_s)

      IF (l_s < l_j) THEN
         LET l_s = 1
         LET l_j = 1
         LET l_k = 1
         LET l_l = 1

         WHILE TRUE
            LET l_j = p_para.getIndexOf("TIME(",l_s)
            LET l_k = p_para.getIndexOf(")",l_j)
            IF ( l_s = 0 OR l_s = -1 OR l_j = 0 OR l_j = -1 OR l_k = 0 OR l_k = -1 OR l_l = 0 OR l_l = -1 ) THEN
               EXIT WHILE
            ELSE
               LET l_ret = l_ret.append(p_para.subString(l_s,l_j-1))
               LET l_para = p_para.subString(l_j,l_k)

               #時間性的動態參數
               IF l_para.getIndexOf("TIME(",1) THEN
                  LET l_para = l_para.subString(6,l_para.getLength()-1)
                  LET l_time = base.StringTokenizer.create(l_para,",")
                  LET l_str1 = l_time.nextToken()

                  #按照月,日來設定日期
                  IF l_str1 = "M" THEN
                     LET l_char = NULL
                     LET l_i = 2

                     WHILE l_time.hasMoreTokens()
                        CASE l_i
                           WHEN '2'
                              LET l_char = l_time.nextToken()
                              LET l_des = l_char.subString(1,1)
                              IF l_des = "+" OR l_des = "-" THEN
                                 LET l_month = l_char.subString(2,l_char.getLength())
                              ELSE
                                LET l_month = l_char.subString(1,l_char.getLength())
                              END IF
                           WHEN '3'
                              LET l_day = l_time.nextToken()                            
                           WHEN '4'
                              LET l_diff = l_time.nextToken()  #FUN-B70085
                        END CASE
                        LET l_i = l_i+1
                     END WHILE

                     IF l_des = "+" OR l_des = "0" THEN
                        LET l_month = MONTH(TODAY) + l_month
                        LET l_newmonth = l_month MOD 12
                        IF l_newmonth = 0 THEN
                           LET l_newmonth = 12
                        END IF
                        LET l_year = (l_month -1 ) / 12
                        LET l_newyear = YEAR(TODAY) + l_year
                        #IF l_day.getLength() > 2 THEN         #No.TQC-B70051
                        IF l_day = "32" THEN                   #No.TQC-B70051
                           LET l_day = getMonthEnd(l_newyear, l_newmonth)                          
                           LET l_day = l_day + l_diff          #FUN-B70085
                        END IF
                        LET l_newpara = MDY(l_newmonth,l_day,l_newyear)
                     END IF

                     IF l_des = "-" THEN
                        IF l_month >= MONTH(TODAY) THEN
                           LET l_newmonth = 12 - (l_month-MONTH(TODAY)) MOD 12
                           LET l_year = (l_month-MONTH(TODAY)+1)/12
                           LET l_newyear = YEAR(TODAY)-1-l_year
                           #IF l_day.getLength() > 2 THEN    #No.TQC-B70051
                           IF l_day = "32" THEN              #No.TQC-B70051
                              LET l_day = getMonthEnd(l_newyear,l_newmonth)
                              LET l_day = l_day + l_diff          #FUN-B70085
                           END IF
                           LET l_newpara = MDY(l_newmonth,l_day,l_newyear)
                        ELSE
                           LET l_newmonth = MONTH(TODAY)-l_month
                           #IF l_day.getLength() > 2 THEN    #No.TQC-B70051
                           IF l_day = "32" THEN              #No.TQC-B70051
                              LET l_day = getMonthEnd(YEAR(TODAY),l_newmonth)
                              LET l_day = l_day + l_diff          #FUN-B70085
                           END IF
                           LET l_newpara = MDY(l_newmonth,l_day,YEAR(TODAY))
                        END IF
                     END IF
                  END IF

                  #按照週,禮拜來設置
                  IF l_str1 = "W" THEN
                     LET l_char = NULL
                     LET l_i = 2
                     WHILE l_time.hasMoreTokens()
                        CASE l_i
                           WHEN '2'
                              LET l_char = l_time.nextToken()
                              LET l_des = l_char.subString(1,1)
                              IF l_des = "+" OR l_des = "-" THEN
                                 LET l_week = l_char.subString(2,l_char.getLength())
                              ELSE
                                 LET l_week = l_char.subString(1,l_char.getLength())
                              END IF
                           WHEN '3'
                              LET l_weekday = l_time.nextToken()
                        END CASE
                        LET l_i = l_i+1
                     END WHILE

                     IF l_des = "+" OR l_des = "0" THEN
                        #基準日為禮拜日時
                        IF l_week > 0 AND WEEKDAY(TODAY) = 0 THEN
                          LET l_newday = 7*(l_week-1)+l_weekday
                          LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)+l_newday)
                        END IF
                        IF l_week = 0 AND WEEKDAY(TODAY) = 0 THEN
                          LET l_newday = 7-l_weekday
                          LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)-l_newday)
                        END IF

                        #基準日不為禮拜日時
                        IF l_week > 0 AND WEEKDAY(TODAY) <> 0 THEN
                          LET l_newday = 7*l_week+l_weekday
                          LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)+l_newday)
                        END IF
                        IF l_week = 0 AND WEEKDAY(TODAY) <> 0 THEN
                          LET l_newday = l_weekday
                          LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)+l_newday)
                        END IF
                     END IF

                     IF l_des = "-" THEN
                        #基準日為禮拜日時
                        IF l_week > 0 AND WEEKDAY(TODAY) = 0 THEN
                           LET l_newday = 7*(l_week+1)-l_weekday
                           LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)-l_newday)
                        END IF
                        #基準日不為禮拜日時
                        IF l_week > 0 AND WEEKDAY(TODAY) <> 0 THEN
                           LET l_newday = 7*l_week-l_weekday
                           LET l_newpara = DATE(TODAY-WEEKDAY(TODAY)-l_newday)
                        END IF
                     END IF
                  END IF

                  #按照日來設定日期
                  IF l_str1 = "D" THEN
                     LET l_char = NULL
                     LET l_i = 2
                     WHILE l_time.hasMoreTokens()
                        IF l_i = '2' THEN
                           LET l_char = l_time.nextToken()
                           LET l_des = l_char.subString(1,1)
                           IF l_des = "+" OR l_des = "-" THEN
                              LET l_nday = l_char.subString(2,l_char.getLength())
                           ELSE
                              LET l_nday = l_char.subString(1,l_char.getLength())
                           END IF
                        ELSE
                           LET l_recycle= l_time.nextToken()
                        END IF
                       LET l_i = l_i+1
                     END WHILE

                     LET l_today = TODAY
                     IF l_des = "+" OR l_des = "0" THEN
                        LET l_newpara=cal(l_today,0,l_nday)
                     END IF
                     IF l_des = "-" THEN
                        LET l_nday="-",l_nday
                        LET l_newpara=cal(l_today,0,l_nday)
                     END IF
                  END IF

                  #按照年來設定日期
                  IF l_str1 = "Y" THEN
                     LET l_char = NULL
                     LET l_i = 2
                     WHILE l_time.hasMoreTokens()
                        IF l_i = '2' THEN
                           LET l_char = l_time.nextToken()
                           LET l_des = l_char.subString(1,1)
                           IF l_des = "+" OR l_des = "-" THEN
                              LET l_nday = l_char.subString(2,l_char.getLength())
                           ELSE
                              LET l_nday = l_char.subString(1,l_char.getLength())
                           END IF
                        ELSE
                           LET l_recycle= l_time.nextToken()
                        END IF
                        LET l_i = l_i+1
                     END WHILE
                     
                     IF l_des = "+" OR l_des = "0" THEN
                        LET l_year = YEAR(TODAY) + l_nday
                        LET l_newpara= l_year USING "&&&&"
                     END IF
                     IF l_des = "-" THEN
                        LET l_year = YEAR(TODAY) - l_nday
                        LET l_newpara= l_year USING "&&&&"
                     END IF
                  END IF #計算 year
               END IF
              
               LET l_ret = l_ret.append(l_newpara clipped)

               LET l_l = p_para.getIndexOf("TIME(",l_k)
               IF ( l_l = 0 OR l_l = -1 ) THEN
                  LET l_l=p_para.getLength()+1
               END IF
               LET l_s=l_l
               LET l_ret=l_ret.append(p_para.subString(l_k+1,l_l-1))
            END IF
         END WHILE
      END IF
   END IF

   IF NOT os.Path.separator() = "/" THEN
      LET l_ret = "\"",l_ret clipped,"\""
   END IF

   RETURN l_ret

END FUNCTION



#計算是否為潤年
PRIVATE FUNCTION IsLeapYear(p_year)
   DEFINE p_year   LIKE type_file.num5

   IF (p_year mod 4 = 0) AND (p_year mod 100 <> 0) THEN
      RETURN 1
   END IF
   IF p_year mod 400 = 0 THEN
      RETURN 1
   END IF
   RETURN 0

END FUNCTION


#計算每個月份有幾天
PRIVATE FUNCTION getMonthEnd(p_year,p_month)

   DEFINE p_year   LIKE type_file.num5
   DEFINE p_month  LIKE type_file.num5

   CASE p_month
      WHEN 1 RETURN 31
      WHEN 2
         IF IsLeapYear(p_year) THEN
            RETURN 29
         ELSE
            RETURN 28
         END IF
      WHEN 3 RETURN 31
      WHEN 4 RETURN 30
      WHEN 5 RETURN 31
      WHEN 6 RETURN 30
      WHEN 7 RETURN 31
      WHEN 8 RETURN 31
      WHEN 9 RETURN 30
      WHEN 10 RETURN 31
      WHEN 11 RETURN 30
      WHEN 12 RETURN 31
      OTHERWISE RETURN -1
   END CASE
END FUNCTION



FUNCTION cal(p_date,p_month,p_day)
DEFINE p_date  LIKE type_file.dat
      ,p_month LIKE type_file.num5
      ,p_day   LIKE type_file.num5

  DEFINE i,j   LIKE type_file.num5
        ,l_year  LIKE abk_file.abk03
        ,l_year1 LIKE abk_file.abk03
        ,l_month LIKE type_file.num5
        ,l_last  LIKE type_file.chr1
        ,l_day   LIKE type_file.num5
        ,l_day1  LIKE type_file.num5
        ,l_date  LIKE type_file.dat
        ,l_ryear LIKE type_file.chr1
        ,l_mm    LIKE type_file.num5

  LET l_year  = YEAR(p_date)
  LET l_month = MONTH(p_date)
  LET l_day   = DAY(p_date)

  LET l_day1 = 28
  LET l_ryear = 'N'
  IF ( l_year >1582 AND (l_year mod 4 = 0)
     AND ((l_year mod 100 <> 0) OR (l_year mod 400 = 0)))
     OR (l_year <=1582 AND l_year mod 4 = 0 ) THEN
    LET l_ryear = 'Y'
    LET l_day1 = 29
  END IF

  CASE
    WHEN ((l_month=1 OR l_month=3 OR l_month=5
         OR l_month=7 OR l_month=8 OR l_month=10 OR l_month=12)
         AND l_day = 31)
      LET l_last = 'Y'

    WHEN ((l_month=4 OR l_month=6 OR l_month=9 OR l_month=11)
         AND l_day >= 30)
      LET l_last = 'Y'

    WHEN (l_ryear ='Y' AND l_month=2 AND l_day >= 29 )
      LET l_last = 'Y'

    WHEN (l_ryear ='N' AND l_month=2 AND l_day >= 28 )
      LET l_last = 'Y'

    OTHERWISE
      LET l_last = 'N'
  END CASE

  LET l_month = l_month + p_month

  IF l_month > 12 THEN
    LET l_year1 = l_month / 12
    LET l_year  = l_year + l_year1
    LET l_month = l_month - 12 * l_year1
  END IF

  WHILE TRUE

    CASE
      WHEN ((l_month mod 12)=1
           OR (l_month mod 12)=3
           OR (l_month mod 12)=5
           OR (l_month mod 12)=7
           OR (l_month mod 12)=8
           OR (l_month mod 12)=10
           OR (l_month mod 12)=0 )
        LET l_day1 = 31
        IF l_day > l_day1 AND l_last ='N'  THEN
          LET l_day = l_day - l_day1
          LET l_month = l_month + 1
        END IF
        IF l_day < l_day1 and l_last = 'Y'  THEN
          LET l_day = l_day1
          IF p_day > 0 THEN
            LET l_month = l_month + 1
            LET l_day = p_day
            LET p_day = 0

          END IF
        END IF
        EXIT CASE

      WHEN ((l_month mod 12)=4 
           OR (l_month mod 12)=6 
           OR (l_month mod 12)=9 
           OR (l_month mod 12)=11 )

        LET l_day1 = 30
        IF l_day > l_day1 AND l_last = 'N' THEN
          LET l_day = l_day - l_day1
          LET l_month = l_month + 1
        END IF
        IF l_day <> l_day1 and l_last = 'Y'  THEN
          LET l_day = l_day1
          IF p_day > 0 THEN
            LET l_month = l_month + 1
            LET l_day = p_day
            LET p_day = 0

          END IF
        END IF
        EXIT CASE

      WHEN (l_month mod 12)=2
        LET l_day1=28
        LET l_ryear = 'N'
        IF ( l_year >1582 AND (l_year mod 4 = 0)
           AND ((l_year mod 100 <> 0) OR (l_year mod 400 = 0)))
           OR (l_year <=1582 AND l_year mod 4 = 0 ) THEN
                  
          LET l_day1=29
          LET l_ryear = 'Y'
        END IF
        IF l_day > l_day1  AND l_last = 'N' THEN
          LET l_day = l_day - l_day1
          LET l_month = l_month + 1
        END IF
        IF l_day <> l_day1 and l_last = 'Y'  THEN
          LET l_day = l_day1
          IF p_day > 0 THEN
            LET l_month = l_month + 1
            LET l_day = p_day
            LET p_day = 0
          END IF
        END IF
        EXIT CASE
      OTHERWISE
        EXIT CASE
    END CASE
    LET l_last = 'N'
    IF l_last = 'N' AND p_day > 0 THEN
      LET l_day = l_day + p_day
      LET p_day = 0
    END IF
    if l_month>12 then let l_mm=l_month mod 12 else let l_mm=l_month end if
    IF ((l_mm=1 OR l_mm=3 OR l_mm=5
       OR l_mm=7 OR l_mm=8 OR l_mm=10 OR l_mm=12)
       AND l_day > 31)
       OR ((l_mm=4 OR l_mm=6 OR l_mm=9 OR l_mm=11)
       AND l_day > 30)
       OR (l_ryear ='Y' AND l_mm=2 AND l_day > 29 )
       OR (l_ryear ='N' AND l_mm=2 AND l_day > 28 )
    THEN CONTINUE WHILE
    ELSE EXIT WHILE
    END IF

  END WHILE
  IF l_month > 12 THEN
    LET l_year1 = l_month / 12
    LET l_year  = l_year + l_year1
    LET l_month = l_month - 12 * l_year1
  END IF
  IF p_day < 0 THEN
    RETURN MDY(l_month,l_day,l_year) + p_day
  ELSE
    RETURN MDY(l_month,l_day,l_year)
  END IF

END FUNCTION


#整合報表維護設定 (專用action)
FUNCTION p_cron_create_rptset(p_ac)

   DEFINE p_ac    LIKE type_file.num10
   DEFINE ls_cmd  STRING
   DEFINE li_num  LIKE type_file.num10
   DEFINE li_i    LIKE type_file.num10
   DEFINE ls_para STRING
          
   LET ls_cmd = "awsi004 '", g_app CLIPPED, "'"

   LET li_num = g_gdi.getLength() - 1

   FOR li_i =1 TO li_num
      IF li_i = 1 THEN
         LET ls_para = " '",g_gdi[li_i].gdi05
         IF li_i = li_num THEN
            LET ls_para = ls_para,"'"
         END IF
      ELSE
         IF li_i = li_num THEN
            LET ls_para = ls_para,"' '",g_gdi[li_i].gdi05,"'"
         ELSE
            LET ls_para = ls_para, "' '",g_gdi[li_i].gdi05
         END IF
      END IF
   END FOR

   LET ls_cmd = ls_cmd,ls_para

   CALL FGL_SETENV("PARANUM",li_num)
   CALL cl_cmdrun_wait(ls_cmd)

END FUNCTION



#清空月設定
PRIVATE FUNCTION p_cron_initMonth()

   LET gr_month.month01 = "Y"
   LET gr_month.month02 = "Y"
   LET gr_month.month03 = "Y"
   LET gr_month.month04 = "Y"
   LET gr_month.month05 = "Y"
   LET gr_month.month06 = "Y"
   LET gr_month.month07 = "Y"
   LET gr_month.month08 = "Y"
   LET gr_month.month09 = "Y"
   LET gr_month.month10 = "Y"
   LET gr_month.month11 = "Y"
   LET gr_month.month12 = "Y"
 
   LET gr_month_t.month01 = "N"
   LET gr_month_t.month02 = "N"
   LET gr_month_t.month03 = "N"
   LET gr_month_t.month04 = "N"
   LET gr_month_t.month05 = "N"
   LET gr_month_t.month06 = "N"
   LET gr_month_t.month07 = "N"
   LET gr_month_t.month08 = "N"
   LET gr_month_t.month09 = "N"
   LET gr_month_t.month10 = "N"
   LET gr_month_t.month11 = "N"
   LET gr_month_t.month12 = "N"
  
END FUNCTION

#清空週設定
PRIVATE FUNCTION p_cron_initWeek()

   LET gr_week.week01 = "Y"
   LET gr_week.week02 = "Y"
   LET gr_week.week03 = "Y"
   LET gr_week.week04 = "Y"
   LET gr_week.week05 = "Y"
   LET gr_week.week06 = "Y"
   LET gr_week.week07 = "Y"

   LET gr_week_t.week01 = "N"
   LET gr_week_t.week02 = "N"
   LET gr_week_t.week03 = "N"
   LET gr_week_t.week04 = "N"
   LET gr_week_t.week05 = "N"
   LET gr_week_t.week06 = "N"
   LET gr_week_t.week07 = "N"
  
END FUNCTION

#清空日設定
PRIVATE FUNCTION p_cron_initDay()

   LET gr_day.day01 = "Y"
   LET gr_day.day02 = "Y"
   LET gr_day.day03 = "Y"
   LET gr_day.day04 = "Y"
   LET gr_day.day05 = "Y"
   LET gr_day.day06 = "Y"
   LET gr_day.day07 = "Y"
   LET gr_day.day08 = "Y"
   LET gr_day.day09 = "Y"
   LET gr_day.day10 = "Y"
   LET gr_day.day11 = "Y"
   LET gr_day.day12 = "Y"
   LET gr_day.day13 = "Y"
   LET gr_day.day14 = "Y"
   LET gr_day.day15 = "Y"
   LET gr_day.day16 = "Y"
   LET gr_day.day17 = "Y"
   LET gr_day.day18 = "Y"
   LET gr_day.day19 = "Y"
   LET gr_day.day20 = "Y"
   LET gr_day.day21 = "Y"
   LET gr_day.day22 = "Y"
   LET gr_day.day23 = "Y"
   LET gr_day.day24 = "Y"
   LET gr_day.day25 = "Y"
   LET gr_day.day26 = "Y"
   LET gr_day.day27 = "Y"
   LET gr_day.day28 = "Y"
   LET gr_day.day29 = "Y"
   LET gr_day.day30 = "Y"
   LET gr_day.day31 = "Y"

   LET gr_day_t.day01 = "N"
   LET gr_day_t.day02 = "N"
   LET gr_day_t.day03 = "N"
   LET gr_day_t.day04 = "N"
   LET gr_day_t.day05 = "N"
   LET gr_day_t.day06 = "N"
   LET gr_day_t.day07 = "N"
   LET gr_day_t.day08 = "N"
   LET gr_day_t.day09 = "N"
   LET gr_day_t.day10 = "N"
   LET gr_day_t.day11 = "N"
   LET gr_day_t.day12 = "N"
   LET gr_day_t.day13 = "N"
   LET gr_day_t.day14 = "N"
   LET gr_day_t.day15 = "N"
   LET gr_day_t.day16 = "N"
   LET gr_day_t.day17 = "N"
   LET gr_day_t.day18 = "N"
   LET gr_day_t.day19 = "N"
   LET gr_day_t.day20 = "N"
   LET gr_day_t.day21 = "N"
   LET gr_day_t.day22 = "N"
   LET gr_day_t.day23 = "N"
   LET gr_day_t.day24 = "N"
   LET gr_day_t.day25 = "N"
   LET gr_day_t.day26 = "N"
   LET gr_day_t.day27 = "N"
   LET gr_day_t.day28 = "N"
   LET gr_day_t.day29 = "N"
   LET gr_day_t.day30 = "N"
   LET gr_day_t.day31 = "N"

  
END FUNCTION



#清空時設定
PRIVATE FUNCTION p_cron_inithour()

   LET gr_hour.hour00 = "Y"
   LET gr_hour.hour01 = "Y"
   LET gr_hour.hour02 = "Y"
   LET gr_hour.hour03 = "Y"
   LET gr_hour.hour04 = "Y"
   LET gr_hour.hour05 = "Y"
   LET gr_hour.hour06 = "Y"
   LET gr_hour.hour07 = "Y"
   LET gr_hour.hour08 = "Y"
   LET gr_hour.hour09 = "Y"
   LET gr_hour.hour10 = "Y"
   LET gr_hour.hour11 = "Y"
   LET gr_hour.hour12 = "Y"
   LET gr_hour.hour13 = "Y"
   LET gr_hour.hour14 = "Y"
   LET gr_hour.hour15 = "Y"
   LET gr_hour.hour16 = "Y"
   LET gr_hour.hour17 = "Y"
   LET gr_hour.hour18 = "Y"
   LET gr_hour.hour19 = "Y"
   LET gr_hour.hour20 = "Y"
   LET gr_hour.hour21 = "Y"
   LET gr_hour.hour22 = "Y"
   LET gr_hour.hour23 = "Y"
   
   LET gr_hour_t.hour00 = "N"
   LET gr_hour_t.hour01 = "N"
   LET gr_hour_t.hour02 = "N"
   LET gr_hour_t.hour03 = "N"
   LET gr_hour_t.hour04 = "N"
   LET gr_hour_t.hour05 = "N"
   LET gr_hour_t.hour06 = "N"
   LET gr_hour_t.hour07 = "N"
   LET gr_hour_t.hour08 = "N"
   LET gr_hour_t.hour09 = "N"
   LET gr_hour_t.hour10 = "N"
   LET gr_hour_t.hour11 = "N"
   LET gr_hour_t.hour12 = "N"
   LET gr_hour_t.hour13 = "N"
   LET gr_hour_t.hour14 = "N"
   LET gr_hour_t.hour15 = "N"
   LET gr_hour_t.hour16 = "N"
   LET gr_hour_t.hour17 = "N"
   LET gr_hour_t.hour18 = "N"
   LET gr_hour_t.hour19 = "N"
   LET gr_hour_t.hour20 = "N"
   LET gr_hour_t.hour21 = "N"
   LET gr_hour_t.hour22 = "N"
   LET gr_hour_t.hour23 = "N"
 
END FUNCTION


#清空分設定
PRIVATE FUNCTION p_cron_initminute()

   LET gr_minute.minute00 = "Y"
   LET gr_minute.minute01 = "Y"
   LET gr_minute.minute02 = "Y"
   LET gr_minute.minute03 = "Y"
   LET gr_minute.minute04 = "Y"
   LET gr_minute.minute05 = "Y"
   LET gr_minute.minute06 = "Y"
   LET gr_minute.minute07 = "Y"
   LET gr_minute.minute08 = "Y"
   LET gr_minute.minute09 = "Y"
   LET gr_minute.minute10 = "Y"
   LET gr_minute.minute11 = "Y"
   LET gr_minute.minute12 = "Y"
   LET gr_minute.minute13 = "Y"
   LET gr_minute.minute14 = "Y"
   LET gr_minute.minute15 = "Y"
   LET gr_minute.minute16 = "Y"
   LET gr_minute.minute17 = "Y"
   LET gr_minute.minute18 = "Y"
   LET gr_minute.minute19 = "Y"
   LET gr_minute.minute20 = "Y"
   LET gr_minute.minute21 = "Y"
   LET gr_minute.minute22 = "Y"
   LET gr_minute.minute23 = "Y"
   LET gr_minute.minute24 = "Y"
   LET gr_minute.minute25 = "Y"
   LET gr_minute.minute26 = "Y"
   LET gr_minute.minute27 = "Y"
   LET gr_minute.minute28 = "Y"
   LET gr_minute.minute29 = "Y"
   LET gr_minute.minute30 = "Y"
   LET gr_minute.minute31 = "Y"
   LET gr_minute.minute32 = "Y"
   LET gr_minute.minute33 = "Y"
   LET gr_minute.minute34 = "Y"
   LET gr_minute.minute35 = "Y"
   LET gr_minute.minute36 = "Y"
   LET gr_minute.minute37 = "Y"
   LET gr_minute.minute38 = "Y"
   LET gr_minute.minute39 = "Y"
   LET gr_minute.minute40 = "Y"
   LET gr_minute.minute41 = "Y"
   LET gr_minute.minute42 = "Y"
   LET gr_minute.minute43 = "Y"
   LET gr_minute.minute44 = "Y"
   LET gr_minute.minute45 = "Y"
   LET gr_minute.minute46 = "Y"
   LET gr_minute.minute47 = "Y"
   LET gr_minute.minute48 = "Y"
   LET gr_minute.minute49 = "Y"
   LET gr_minute.minute50 = "Y"
   LET gr_minute.minute51 = "Y"
   LET gr_minute.minute52 = "Y"
   LET gr_minute.minute53 = "Y"
   LET gr_minute.minute54 = "Y"
   LET gr_minute.minute55 = "Y"
   LET gr_minute.minute56 = "Y"
   LET gr_minute.minute57 = "Y"
   LET gr_minute.minute58 = "Y"
   LET gr_minute.minute59 = "Y"
 
   LET gr_minute_t.minute00 = "N" 
   LET gr_minute_t.minute01 = "N"
   LET gr_minute_t.minute02 = "N"
   LET gr_minute_t.minute03 = "N"
   LET gr_minute_t.minute04 = "N"
   LET gr_minute_t.minute05 = "N"
   LET gr_minute_t.minute06 = "N"
   LET gr_minute_t.minute07 = "N"
   LET gr_minute_t.minute08 = "N"
   LET gr_minute_t.minute09 = "N"
   LET gr_minute_t.minute10 = "N"
   LET gr_minute_t.minute11 = "N"
   LET gr_minute_t.minute12 = "N"
   LET gr_minute_t.minute13 = "N"
   LET gr_minute_t.minute14 = "N"
   LET gr_minute_t.minute15 = "N"
   LET gr_minute_t.minute16 = "N"
   LET gr_minute_t.minute17 = "N"
   LET gr_minute_t.minute18 = "N"
   LET gr_minute_t.minute19 = "N"
   LET gr_minute_t.minute20 = "N"
   LET gr_minute_t.minute21 = "N"
   LET gr_minute_t.minute22 = "N"
   LET gr_minute_t.minute23 = "N"
   LET gr_minute_t.minute24 = "N"
   LET gr_minute_t.minute25 = "N"
   LET gr_minute_t.minute26 = "N"
   LET gr_minute_t.minute27 = "N"
   LET gr_minute_t.minute28 = "N"
   LET gr_minute_t.minute29 = "N"
   LET gr_minute_t.minute30 = "N"
   LET gr_minute_t.minute31 = "N"
   LET gr_minute_t.minute32 = "N"
   LET gr_minute_t.minute33 = "N"
   LET gr_minute_t.minute34 = "N"
   LET gr_minute_t.minute35 = "N"
   LET gr_minute_t.minute36 = "N"
   LET gr_minute_t.minute37 = "N"
   LET gr_minute_t.minute38 = "N"
   LET gr_minute_t.minute39 = "N"
   LET gr_minute_t.minute40 = "N"
   LET gr_minute_t.minute41 = "N"
   LET gr_minute_t.minute42 = "N"
   LET gr_minute_t.minute43 = "N"
   LET gr_minute_t.minute44 = "N"
   LET gr_minute_t.minute45 = "N"
   LET gr_minute_t.minute46 = "N"
   LET gr_minute_t.minute47 = "N"
   LET gr_minute_t.minute48 = "N"
   LET gr_minute_t.minute49 = "N"
   LET gr_minute_t.minute50 = "N"
   LET gr_minute_t.minute51 = "N"
   LET gr_minute_t.minute52 = "N"
   LET gr_minute_t.minute53 = "N"
   LET gr_minute_t.minute54 = "N"
   LET gr_minute_t.minute55 = "N"
   LET gr_minute_t.minute56 = "N"
   LET gr_minute_t.minute57 = "N"
   LET gr_minute_t.minute58 = "N"
   LET gr_minute_t.minute59 = "N"
  
END FUNCTION



#dd_month 欄位初始設定函式 (直接被4fd呼叫)
FUNCTION initDay1(pcb_day)
   DEFINE pcb_day   ui.ComboBox
   DEFINE li_i      LIKE type_file.num10
   DEFINE l_str     LIKE type_file.chr10

   CALL pcb_day.clear()
   FOR li_i = 1 TO 31
     CALL pcb_day.addItem(li_i USING '&&', li_i USING '&&')
   END FOR
END FUNCTION



FUNCTION initDay2(pcb_day)
   DEFINE pcb_day   ui.ComboBox
   DEFINE li_i      LIKE type_file.num10
   DEFINE l_str     LIKE type_file.chr10

   CALL pcb_day.clear()
   FOR li_i = 1 TO 31
     #CALL pcb_day.addItem(li_i USING '&&', li_i USING '&&') #mark by CHI-CA0051
      CALL pcb_day.addItem(li_i, li_i USING '&&')            #CHI-CA0051 add ,value由字串改為數值形態
   END FOR

   SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'cro-139' AND ze02 = g_lang
   CALL pcb_day.addItem(32,l_str)
END FUNCTION



#hh_xxxx 欄位初始設定函式 (直接被4fd呼叫)
FUNCTION initWeekDay(pcb_day)
   DEFINE pcb_day   ui.ComboBox
   DEFINE li_i      LIKE type_file.num10

   CALL pcb_day.clear()
   FOR li_i = 1 TO 7
     CALL pcb_day.addItem(li_i, li_i USING '&')
   END FOR
END FUNCTION


#hh_xxxx 欄位初始設定函式 (直接被4fd呼叫)
FUNCTION initHour(pcb_hour)
   DEFINE pcb_hour   ui.ComboBox
   DEFINE li_i       LIKE type_file.num10 

   CALL pcb_hour.clear()
   FOR li_i = 0 TO 23
     CALL pcb_hour.addItem(li_i USING '&&', li_i USING '&&')
   END FOR
END FUNCTION


#mm_xxxx 欄位初始設定函式 (直接被4fd呼叫)
FUNCTION initMinute(pcb_minute)
   DEFINE pcb_minute   ui.ComboBox
   DEFINE li_i         LIKE type_file.num10
   
   CALL pcb_minute.clear()
   FOR li_i = 0 TO 59
     CALL pcb_minute.addItem(li_i USING '&&', li_i USING '&&')
   END FOR
END FUNCTION


FUNCTION p_schtasks_date(date)
DEFINE date STRING

RETURN date
END FUNCTION

FUNCTION initday3(pcb_day)          #FUN-B70085
   DEFINE pcb_day   ui.ComboBox
   DEFINE li_i      LIKE type_file.num10
   DEFINE l_str     LIKE type_file.chr10

   CALL pcb_day.clear()
   FOR li_i = 0 TO -31 STEP -1
      CALL pcb_day.addItem(li_i USING '--&', li_i USING '--&')
   END FOR

END FUNCTION

