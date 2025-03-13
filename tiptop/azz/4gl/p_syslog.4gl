# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: p_syslog.4gl
# Descriptions...: log 抓取及清除作業
# Date & Author..: 11/12/21 By jrg542
# Modify.........: No.FUN-BC0054 11/12/30 By jrg542 開發 log 抓取及清除機制及修改將系統日誌寫入外部日誌設備 
# Modify.........: No.TQC-C30136 12/03/08 By xujing 處理ON ACITON衝突問題
# Modify.........: No:DEV-C50001 12/05/17 By joyce 新增三個欄位(gdp09、gdp10、gdp11)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_gdp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gdp01       LIKE gdp_file.gdp01,   #日期
        gdp02       LIKE gdp_file.gdp02,   #時間
        gdp03       LIKE gdp_file.gdp03,   #使用者
        gdp04       LIKE gdp_file.gdp04,   #程式來源
        gdp05       LIKE gdp_file.gdp05,   #類別S(系統)/G(一般)/D(細節) 
        gdp06       LIKE gdp_file.gdp06,   #等級W(警告)/E(錯誤)/A(允許)
        gdp07       LIKE gdp_file.gdp07,   #營運中心編號
        gdp09       LIKE gdp_file.gdp09,   #Server IP   # No:DEV-C50001
        gdp10       LIKE gdp_file.gdp10,   #Client IP   # No:DEV-C50001
        gdp11       LIKE gdp_file.gdp11,   #Process ID  # No:DEV-C50001
        gdp08       LIKE gdp_file.gdp08    #說明內容
        
                    END RECORD,
    g_gdp_t         RECORD                 #程式變數 (舊值)
        gdp01       LIKE gdp_file.gdp01,   #日期
        gdp02       LIKE gdp_file.gdp02,   #時間
        gdp03       LIKE gdp_file.gdp03,   #使用者
        gdp04       LIKE gdp_file.gdp04,   #程式來源
        gdp05       LIKE gdp_file.gdp05,   #類別S(系統)/G(一般)/D(細節) 
        gdp06       LIKE gdp_file.gdp06,   #等級W(警告)/E(錯誤)/A(允許)
        gdp07       LIKE gdp_file.gdp07,   #營運中心編號
        gdp09       LIKE gdp_file.gdp09,   #Server IP   # No:DEV-C50001
        gdp10       LIKE gdp_file.gdp10,   #Client IP   # No:DEV-C50001
        gdp11       LIKE gdp_file.gdp11,   #Process ID  # No:DEV-C50001
        gdp08       LIKE gdp_file.gdp08    #說明內容
                    END RECORD,
    g_wc2           STRING,
    g_wc           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, #No.FUN-680102 VARCHAR(80)
    g_rec_b1         LIKE type_file.num10,                #單身筆數  #No.FUN-680102 SMALLINT
    g_rec_b2         LIKE type_file.num10,                #單身筆數  #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680102 SMALLINT

DEFINE g_gdp_detail        DYNAMIC ARRAY OF   RECORD    #程式變數(Program Variables)

        gdp05       LIKE gdp_file.gdp05,   #類別S(系統)/G(一般)/D(細節) 
        gdp01       LIKE gdp_file.gdp01,   #日期
        gdp02       LIKE gdp_file.gdp02,   #時間
        gdp03       LIKE gdp_file.gdp03,   #使用者
        gdp04       LIKE gdp_file.gdp04,   #程式來源
        gdp07       LIKE gdp_file.gdp07,   #營運中心編號
        gdp09       LIKE gdp_file.gdp09,   #Server IP   # No:DEV-C50001
        gdp10       LIKE gdp_file.gdp10,   #Client IP   # No:DEV-C50001
        gdp11       LIKE gdp_file.gdp11,   #Process ID  # No:DEV-C50001
        gdp08       LIKE gdp_file.gdp08    #說明內容        
                    END RECORD
                    
DEFINE g_gdp_detail_t  RECORD    #程式變數(Program Variables)

        gdp05       LIKE gdp_file.gdp05,   #類別S(系統)/G(一般)/D(細節) 
        gdp01       LIKE gdp_file.gdp01,   #日期
        gdp02       LIKE gdp_file.gdp02,   #時間
        gdp03       LIKE gdp_file.gdp03,   #使用者
        gdp04       LIKE gdp_file.gdp04,   #程式來源
        gdp07       LIKE gdp_file.gdp07,   #營運中心編號
        gdp09       LIKE gdp_file.gdp09,   #Server IP   # No:DEV-C50001
        gdp10       LIKE gdp_file.gdp10,   #Client IP   # No:DEV-C50001
        gdp11       LIKE gdp_file.gdp11,   #Process ID  # No:DEV-C50001
        gdp08       LIKE gdp_file.gdp08    #說明內容
                    END RECORD

DEFINE  
     g_gdp_head           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        gdp06               LIKE gdp_file.gdp06,   #等級W(警告)/E(錯誤)/A(允許)
        gdp06_cnt           LIKE type_file.num5,
        gdp05_sys_count     LIKE type_file.num5,
        gdp05_gen_count     LIKE type_file.num5,
        gdp05_detail_count  LIKE type_file.num5
                           END RECORD 
DEFINE  
     g_gdp_head_t           RECORD    #程式變數(Program Variables)
        gdp06               LIKE gdp_file.gdp06,   #等級W(警告)/E(錯誤)/A(允許)
        gdp06_cnt           LIKE type_file.num5,
        gdp05_sys_count     LIKE type_file.num5,
        gdp05_gen_count     LIKE type_file.num5,
        gdp05_detail_count  LIKE type_file.num5
                           END RECORD  
                           
DEFINE g_forupd_sql STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-680102 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570110  #No.FUN-680102 SMALLINT
DEFINE g_i          LIKE type_file.num5       #count/index for any purpose  #No.FUN-680102 SMALLINT
DEFINE g_on_change  LIKE type_file.num5       #No.FUN-680102 SMALLINT   #FUN-550077
DEFINE g_row_count  LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_curs_index LIKE type_file.num5       #No.TQC-680158 add
DEFINE g_str        STRING                    #No.FUN-760083     
DEFINE g_argv1      LIKE gdp_file.gdp07       #FUN-A80148--add--
DEFINE gwin_curr    ui.Window                 #Current Window
DEFINE gfrm_curr    ui.Form                   #Current Form
DEFINE g_curr_diag  ui.Dialog                 #Current Dialog
DEFINE g_level      STRING 
DEFINE g_msg        LIKE ze_file.ze03         #No.FUN-680135 VARCHAR(72)

MAIN 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)               #FUN-A80148--add--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
 
    OPEN WINDOW p_syslog_w WITH FORM "azz/42f/p_syslog"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL p_syslog_menu_dialog()            #No.FUN-BC0054 用dialog 包住兩個display  
    CLOSE WINDOW p_syslog_w                #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
         RETURNING g_time    #No.FUN-6A0081
END MAIN


FUNCTION p_syslog_menu_dialog() 
    DEFINE l_cmd    STRING 
    DEFINE l_cnt    LIKE   type_file.num5
    DEFINE l_act_view_execute_log LIKE type_file.chr1    #TQC-C30136 
    DEFINE l_act_view_db_log      LIKE type_file.chr1    #TQC-C30136

  
    LET gwin_curr = ui.Window.getCurrent()
    LET gfrm_curr = gwin_curr.getForm() 
    
    DIALOG ATTRIBUTES(UNBUFFERED)
        
        #上面 (系統層級)
        DISPLAY ARRAY g_gdp_head TO s_gdp_head.* ATTRIBUTE(COUNT=g_rec_b1)

           BEFORE DISPLAY
               LET l_act_view_execute_log = FALSE  #TQC-C30136
               LET l_act_view_db_log = FALSE       #TQC-C30136  
               CALL cl_set_act_visible("all_delete,all_detail_exporttoexcel,condition_delete,accept,cancel", TRUE)
               
           BEFORE ROW
              LET g_curs_index = DIALOG.getCurrentRow("s_gdp_head")
              CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
              CALL cl_navigator_setting( g_curs_index, g_row_count )
              CALL p_syslog_detail_fill("1=1",g_gdp_head[g_curs_index].gdp06)
              LET g_gdp_head_t.* = g_gdp_head[g_curs_index].*  #BACKUP

        END DISPLAY
        
        #下面 (詳細資料)
        DISPLAY ARRAY g_gdp_detail TO s_gdp_detail.* ATTRIBUTE(COUNT=g_rec_b2)

           BEFORE DISPLAY
              LET l_act_view_execute_log = TRUE  #TQC-C30136
              LET l_act_view_db_log = TRUE       #TQC-C30136 
              CALL cl_set_act_visible("accept,cancel,all_delete,all_detail_exporttoexcel,condition_delete", FALSE)
              
           BEFORE ROW
              LET g_curs_index = DIALOG.getCurrentRow("s_gdp_detail")
              CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
              CALL cl_navigator_setting( g_curs_index, g_row_count )
              LET g_gdp_detail_t.* = g_gdp_detail[g_curs_index].*  #BACKUP             

          #####TQC-C30136---mark---str#####      
          #ON ACTION view_execute_log                    #查看程式執行紀錄                        
          #    LET g_action_choice="view_execute_log"
          #    LET g_msg='p_used '
          #    CALL cl_cmdrun_wait(g_msg)

          #ON ACTION view_db_log
          #    LET g_action_choice="view_db_log"         #查看資料庫異動紀錄 
          #    LET g_msg='aooq030 '
          #    CALL cl_cmdrun_wait(g_msg)
          #####TQC-C30136---mark---end#####

        END DISPLAY

      BEFORE DIALOG
         LET g_wc2 = '1=1'
         CALL p_syslog_b_fill(g_wc2)
         
         LET g_curr_diag = ui.DIALOG.getCurrent()
         LET g_level = "E" 
         CALL p_syslog_detail_fill("1=1",g_level)    #browser page 單身

         ON ACTION all_delete 
               LET g_action_choice="all_delete"                    #整批刪除
                IF cl_chk_act_auth() THEN
                   CALL p_scrtyitem_chk_before_delete(g_gdp_head_t.*)
                   LET g_wc2 = '1=1'
                   CALL p_syslog_b_fill(g_wc2)
                   CALL p_syslog_detail_fill("1=1",g_gdp_head[g_curs_index].gdp06)
                END IF
        ON ACTION all_detail_exporttoexcel
              LET g_action_choice="all_detail_exporttoexcel"       #整批細項匯出
              IF cl_chk_act_auth() THEN
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gdp),'','')
              END IF 

        ON ACTION condition_delete
              LET g_action_choice="condition_delete"               #條件刪除     
              IF cl_chk_act_auth() THEN
                 CALL p_syslog_condition_delete()
                 LET g_wc2 = '1=1'
                   CALL p_syslog_b_fill(g_wc2)
                   CALL p_syslog_detail_fill("1=1",g_gdp_head[g_curs_index].gdp06)
              END IF  
      
      
       ON ACTION view_execute_log                    #查看程式執行紀錄        
           #TQC-C30136---add---str---     
           IF NOT cl_null(l_act_view_execute_log) AND l_act_view_execute_log THEN
              LET g_action_choice="view_execute_log"
              LET g_msg='p_used '
              CALL cl_cmdrun_wait(g_msg)   
           ELSE
           #TQC-C30136---add---end---
              LET g_action_choice="view_execute_log"
              IF cl_chk_act_auth() THEN
                 LET g_msg='p_used '
                 CALL cl_cmdrun_wait(g_msg)
              END IF
           END IF                               #TQC-C30136        

       ON ACTION view_db_log
           #TQC-C30136---add---str---
           IF NOT cl_null(l_act_view_db_log) AND l_act_view_db_log THEN
              LET g_action_choice="view_db_log"         #查看資料庫異動紀錄
              LET g_msg='aooq030 '
              CALL cl_cmdrun_wait(g_msg)
           ELSE
           #TQC-C30136---add---end---
              LET g_action_choice="view_db_log"         #查看資料庫異動紀錄 
              IF cl_chk_act_auth() THEN
                  LET g_msg='aooq030 '
              CALL cl_cmdrun_wait(g_msg)
              END IF
           END IF                                              #TQC-C30136

       ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()         

      ON ACTION close
         EXIT DIALOG

    END  DIALOG 
    #CLOSE p_syslog_curs
END FUNCTION 

#系統等級單頭 
FUNCTION p_syslog_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2         STRING
    DEFINE l_cnt_detail  LIKE type_file.num10
    DEFINE l_cnt_gen     LIKE type_file.num10
    DEFINE l_cnt_sys     LIKE type_file.num10
    DEFINE l_count       LIKE type_file.num10
    DEFINE l_type        LIKE gdp_file.gdp06
    DEFINE l_level       LIKE gdp_file.gdp05

    LET l_type = 'E'
    LET l_level = 'S'
    MESSAGE "Searching!"
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb1 FROM g_sql
    EXECUTE p_syslog_pb1 USING l_type,l_level INTO l_cnt_sys
    FREE p_syslog_pb1 

    LET l_type = 'E'
    LET l_level = 'G'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb2 FROM g_sql
    EXECUTE p_syslog_pb2 USING l_type,l_level INTO l_cnt_gen
    FREE p_syslog_pb2
    
    LET l_type = 'E'
    LET l_level = 'D'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb3 FROM g_sql
    EXECUTE p_syslog_pb3 USING l_type,l_level INTO l_cnt_detail
    FREE p_syslog_pb3 

    LET g_rec_b1 = l_cnt_sys + l_cnt_gen + l_cnt_detail
    LET g_gdp_head[1].gdp06 = 'E'
    LET g_gdp_head[1].gdp06_cnt = l_cnt_sys + l_cnt_gen + l_cnt_detail
    LET g_gdp_head[1].gdp05_sys_count = l_cnt_sys
    LET g_gdp_head[1].gdp05_gen_count = l_cnt_gen
    LET g_gdp_head[1].gdp05_detail_count = l_cnt_detail

    LET l_type = 'W'
    LET l_level = 'S'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb4 FROM g_sql
    EXECUTE p_syslog_pb4 USING l_type,l_level INTO l_cnt_sys
    FREE p_syslog_pb4 

    LET l_type = 'W'
    LET l_level = 'G'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb5 FROM g_sql
    EXECUTE p_syslog_pb5 USING l_type,l_level INTO l_cnt_gen
    FREE p_syslog_pb5 
    
    LET l_type = 'W'
    LET l_level = 'D'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb6 FROM g_sql
    EXECUTE p_syslog_pb6 USING l_type,l_level INTO l_cnt_detail
    FREE p_syslog_pb6 
    
    LET g_rec_b1 = g_rec_b1 + l_cnt_sys + l_cnt_gen + l_cnt_detail
    LET g_gdp_head[2].gdp06 = 'W'
    LET g_gdp_head[2].gdp06_cnt = l_cnt_sys + l_cnt_gen + l_cnt_detail
    LET g_gdp_head[2].gdp05_sys_count = l_cnt_sys
    LET g_gdp_head[2].gdp05_gen_count = l_cnt_gen
    LET g_gdp_head[2].gdp05_detail_count = l_cnt_detail
   

    LET l_type = 'A'
    LET l_level = 'S'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb7 FROM g_sql
    EXECUTE p_syslog_pb7 USING l_type,l_level INTO l_cnt_sys
    FREE p_syslog_pb7 

    LET l_type = 'A'
    LET l_level = 'G'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb8 FROM g_sql
    EXECUTE p_syslog_pb8 USING l_type,l_level INTO l_cnt_gen
    FREE p_syslog_pb8 
    
    LET l_type = 'A'
    LET l_level = 'D'
    LET g_sql = "SELECT COUNT(*)  FROM gdp_file WHERE ",p_wc2 CLIPPED ,
                "AND gdp06 = ? AND  gdp05 = ?"
    PREPARE p_syslog_pb9 FROM g_sql
    EXECUTE p_syslog_pb9 USING l_type,l_level INTO l_cnt_detail
    FREE p_syslog_pb9 
    MESSAGE ""
    LET g_rec_b1 = g_rec_b1 + l_cnt_sys + l_cnt_gen + l_cnt_detail
    LET g_gdp_head[3].gdp06 = 'A'
    LET g_gdp_head[3].gdp06_cnt = l_cnt_sys + l_cnt_gen + l_cnt_detail
    LET g_gdp_head[3].gdp05_sys_count = l_cnt_sys
    LET g_gdp_head[3].gdp05_gen_count = l_cnt_gen
    LET g_gdp_head[3].gdp05_detail_count = l_cnt_detail
    
END FUNCTION

#細項單身
FUNCTION p_syslog_detail_fill(p_wc,ps_level) 
   DEFINE p_wc   STRING
   DEFINE ps_level STRING

#  LET g_sql = "SELECT gdp05 ,gdp01,gdp02,gdp03,gdp04,gdp07,gdp08 ",
   LET g_sql = "SELECT gdp05 ,gdp01,gdp02,gdp03,gdp04,gdp07,gdp09,gdp10,gdp11,gdp08 ",   # No:DEV-C50001
               " FROM  gdp_file  WHERE ",p_wc CLIPPED ," AND gdp06 = '",ps_level,"'"
   PREPARE p_syslog_pb FROM g_sql
   DECLARE p_syslog_cs CURSOR FOR p_syslog_pb

   CALL g_gdp_detail.clear()
   LET g_cnt = 1

   FOREACH p_syslog_cs INTO g_gdp_detail[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF  
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_gdp_detail.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt-1
   LET g_row_count  = g_rec_b2
   DISPLAY g_rec_b2 TO FORMONLY.cnt2 
   LET g_cnt = 0

END FUNCTION
                                                                
#整批刪除       
FUNCTION p_scrtyitem_chk_before_delete(p_gdp_head_t)

    DEFINE  
          p_gdp_head_t           RECORD              #程式變數(Program Variables)
          gdp06               LIKE gdp_file.gdp06,   #等級W(警告)/E(錯誤)/A(允許)
          gdp06_cnt           LIKE type_file.num5,
          gdp05_sys_count     LIKE type_file.num5,
          gdp05_gen_count     LIKE type_file.num5,
          gdp05_detail_count  LIKE type_file.num5
                           END RECORD 
    
    IF p_gdp_head_t.gdp06 IS NOT NULL THEN

        IF NOT cl_delete() THEN
            RETURN 
        END IF
        BEGIN WORK 
        DELETE FROM gdp_file WHERE gdp06 = p_gdp_head_t.gdp06 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","gdp_file",p_gdp_head_t.gdp06,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK      #FUN-680010
        END IF
        COMMIT WORK  
    END IF   

END FUNCTION 

#條件刪除
FUNCTION p_syslog_condition_delete()

   DEFINE   ls_str       STRING
   DEFINE   li_cnt       LIKE type_file.num5    #FUN-680135 SMALLINT
   DEFINE   ls_sql       STRING
   DEFINE   l_row_count  LIKE type_file.num10         #No.FUN-680102 INTEGER
   DEFINE   li_result      LIKE type_file.num5  
   
    OPEN WINDOW p_syslog_condition_delete_w WITH FORM "azz/42f/p_syslog_delete"   
      ATTRIBUTE(STYLE="dialog")
      CALL cl_ui_locale("p_syslog")
      
      CONSTRUCT g_wc ON gdp01,gdp02,gdp03,gdp04,gdp05,gdp06,gdp07,gdp09,gdp10,gdp11,gdp08   # No:DEV-C50001
                   FROM gdp01,gdp02,gdp03,gdp04,gdp05,gdp06,gdp07,gdp09,gdp10,gdp11,gdp08                  #No.FUN-710055
                        
         #No.FUN-610065 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-610065 ---end---
        
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

          ON ACTION locale
             CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()
 
      END CONSTRUCT
      IF INT_FLAG THEN 
         LET INT_FLAG=FALSE
         CLOSE WINDOW p_syslog_condition_delete_w  
         RETURN 
      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      CLOSE WINDOW p_syslog_condition_delete_w
      
      LET g_sql= "SELECT COUNT(*)  FROM gdp_file WHERE ",g_wc CLIPPED
      PREPARE p_syslog_precount FROM g_sql
      DECLARE p_syslog_count CURSOR FOR p_syslog_precount
      OPEN p_syslog_count
      FETCH p_syslog_count INTO l_row_count
      LET li_result =  p_syslog_confirm_delete(l_row_count)  
      
      IF li_result THEN  
         BEGIN WORK 
         LET g_sql= " DELETE FROM gdp_file WHERE ",g_wc
         PREPARE p_syslog_pre FROM g_sql
         EXECUTE p_syslog_pre 
         FREE p_syslog_pre
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","gdp_file",l_row_count,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            ROLLBACK WORK      #FUN-680010
         END IF
         COMMIT WORK 
    
      END IF   

END FUNCTION 

FUNCTION p_syslog_confirm_delete(p_row_count)
     DEFINE   p_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER 
     DEFINE   ls_msg         LIKE type_file.chr1000       #No.FUN-690005 VARCHAR(1000)
     DEFINE   li_result      LIKE type_file.num5          #No.FUN-690005 SMALLINT
     DEFINE   lc_msg         LIKE ze_file.ze03
     DEFINE   ls_zemsg       STRING
     DEFINE   lc_title       LIKE ze_file.ze03            #No.FUN-690005 VARCHAR(50)
      
     IF (cl_null(g_lang)) THEN
          LET g_lang = "1"
     END IF
       
       SELECT ze03 INTO lc_title FROM ze_file WHERE ze01 = 'lib-042' AND ze02 = g_lang
       IF SQLCA.SQLCODE THEN
          LET lc_title = "Confirm"
       END IF
     
       LET ls_msg = "azz1187"
       SELECT ze03 INTO lc_msg FROM ze_file WHERE ze01 = ls_msg AND ze02 = g_lang
       IF NOT SQLCA.SQLCODE THEN
          LET ls_zemsg =lc_msg CLIPPED
       END IF
      
       LET li_result = FALSE
       IF (cl_null(lc_msg))  THEN    # FUN-870095  參數不為ze訊息代碼時，lc_title後面()內的資訊不用顯示
          LET lc_title=lc_title CLIPPED
       ELSE
     
          LET lc_title=lc_title CLIPPED,'(',ls_msg,')' #MOD-4A0143 show ze01
       END IF

       LET ls_zemsg = ls_zemsg,p_row_count
       MENU lc_title ATTRIBUTE (STYLE="dialog", COMMENT=ls_zemsg.trim(), IMAGE="question")
          ON ACTION yes
             LET li_result = TRUE
             EXIT MENU
          ON ACTION no
             EXIT MENU
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE MENU
       
       END MENU
     
       IF (INT_FLAG) THEN
          LET INT_FLAG = FALSE
          LET li_result = FALSE
       END IF
     
       RETURN li_result
END FUNCTION 
