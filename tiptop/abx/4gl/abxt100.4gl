# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: abxt100.4gl
# Descriptions...: 廠外加工進廠建立作業  
# Date & Author..: 2006/10/18 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/09 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.FUN-980001 09/08/10 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ABX
# Modify.........: No.FUN-AA0049 10/10/21 by destiny 增加倉庫的權限控管 
# Modify.........: No.FUN-AB0058 10/11/15 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No.FUN-D20025 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-CC0014 13/02/22 By huangtao 去除對設限倉庫的控管
# Modify.........: No.CHI-C80072 13/04/01 By wuxj     取消確認時審核異動人員及審核異動日期給值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_bxb         RECORD LIKE bxb_file.*,
  g_bxb_t       RECORD LIKE bxb_file.*,    #單頭備份
  g_bxb_o       RECORD LIKE bxb_file.*,    #單頭備份
  g_bxb01_t     LIKE bxb_file.bxb01,    #單頭key備份
  g_bxc         DYNAMIC ARRAY OF RECORD       #單身
     bxc02      LIKE bxc_file.bxc02,    #項次
     bxc03      LIKE bxc_file.bxc03,    #材料品號
     ima02         LIKE ima_file.ima02,          #品名       
     ima021        LIKE ima_file.ima021,         #規格     
     ima63         LIKE ima_file.ima63,          #單位   
     bxc07      LIKE bxc_file.bxc07,    #單位用量
     bxc08      LIKE bxc_file.bxc08,    #使用原料總數
     bxc09      LIKE bxc_file.bxc09,    #損耗總數
     bxc11      LIKE bxc_file.bxc11,    #未加工運回原料數量
     bxc04      LIKE bxc_file.bxc04,    #未加工運回原料入庫庫別
     bxc05      LIKE bxc_file.bxc05,    #未加工運回原料入庫儲位
     bxc06      LIKE bxc_file.bxc06,    #未加工運回原料入庫批號
     bxc10      LIKE bxc_file.bxc10,    #下腳料及廢料運回數量
     bxc12      LIKE bxc_file.bxc12,    #下腳料及廢料入庫庫別
     bxc13      LIKE bxc_file.bxc13,    #下腳料及廢料入庫儲位
     bxc14      LIKE bxc_file.bxc14,    #下腳料及廢料入庫批號
     bxc15      LIKE bxc_file.bxc15,     #備註
     #FUN-840202 --start---
     bxcud01 LIKE bxc_file.bxcud01,
     bxcud02 LIKE bxc_file.bxcud02,
     bxcud03 LIKE bxc_file.bxcud03,
     bxcud04 LIKE bxc_file.bxcud04,
     bxcud05 LIKE bxc_file.bxcud05,
     bxcud06 LIKE bxc_file.bxcud06,
     bxcud07 LIKE bxc_file.bxcud07,
     bxcud08 LIKE bxc_file.bxcud08,
     bxcud09 LIKE bxc_file.bxcud09,
     bxcud10 LIKE bxc_file.bxcud10,
     bxcud11 LIKE bxc_file.bxcud11,
     bxcud12 LIKE bxc_file.bxcud12,
     bxcud13 LIKE bxc_file.bxcud13,
     bxcud14 LIKE bxc_file.bxcud14,
     bxcud15 LIKE bxc_file.bxcud15
     #FUN-840202 --end--
                   END RECORD,
  g_bxc_t       RECORD                        #單身備份
     bxc02      LIKE bxc_file.bxc02,    #項次
     bxc03      LIKE bxc_file.bxc03,    #材料品號
     ima02         LIKE ima_file.ima02,          #品名       
     ima021        LIKE ima_file.ima021,         #規格     
     ima63         LIKE ima_file.ima63,          #單位   
     bxc07      LIKE bxc_file.bxc07,    #單位用量
     bxc08      LIKE bxc_file.bxc08,    #使用原料總數
     bxc09      LIKE bxc_file.bxc09,    #損耗總數
     bxc11      LIKE bxc_file.bxc11,    #未加工運回原料數量
     bxc04      LIKE bxc_file.bxc04,    #未加工運回原料入庫庫別
     bxc05      LIKE bxc_file.bxc05,    #未加工運回原料入庫儲位
     bxc06      LIKE bxc_file.bxc06,    #未加工運回原料入庫批號
     bxc10      LIKE bxc_file.bxc10,    #下腳料及廢料運回數量
     bxc12      LIKE bxc_file.bxc12,    #下腳料及廢料入庫庫別
     bxc13      LIKE bxc_file.bxc13,    #下腳料及廢料入庫儲位
     bxc14      LIKE bxc_file.bxc14,    #下腳料及廢料入庫批號
     bxc15      LIKE bxc_file.bxc15,    #備註
     #FUN-840202 --start---
     bxcud01 LIKE bxc_file.bxcud01,
     bxcud02 LIKE bxc_file.bxcud02,
     bxcud03 LIKE bxc_file.bxcud03,
     bxcud04 LIKE bxc_file.bxcud04,
     bxcud05 LIKE bxc_file.bxcud05,
     bxcud06 LIKE bxc_file.bxcud06,
     bxcud07 LIKE bxc_file.bxcud07,
     bxcud08 LIKE bxc_file.bxcud08,
     bxcud09 LIKE bxc_file.bxcud09,
     bxcud10 LIKE bxc_file.bxcud10,
     bxcud11 LIKE bxc_file.bxcud11,
     bxcud12 LIKE bxc_file.bxcud12,
     bxcud13 LIKE bxc_file.bxcud13,
     bxcud14 LIKE bxc_file.bxcud14,
     bxcud15 LIKE bxc_file.bxcud15
     #FUN-840202 --end--
                   END RECORD,
  g_bxc_o       RECORD                        #單身備份
     bxc02      LIKE bxc_file.bxc02,    #項次
     bxc03      LIKE bxc_file.bxc03,    #材料品號
     ima02         LIKE ima_file.ima02,          #品名       
     ima021        LIKE ima_file.ima021,         #規格     
     ima63         LIKE ima_file.ima63,          #單位   
     bxc07      LIKE bxc_file.bxc07,    #單位用量
     bxc08      LIKE bxc_file.bxc08,    #使用原料總數
     bxc09      LIKE bxc_file.bxc09,    #損耗總數
     bxc11      LIKE bxc_file.bxc11,    #未加工運回原料數量
     bxc04      LIKE bxc_file.bxc04,    #未加工運回原料入庫庫別
     bxc05      LIKE bxc_file.bxc05,    #未加工運回原料入庫儲位
     bxc06      LIKE bxc_file.bxc06,    #未加工運回原料入庫批號
     bxc10      LIKE bxc_file.bxc10,    #下腳料及廢料運回數量
     bxc12      LIKE bxc_file.bxc12,    #下腳料及廢料入庫庫別
     bxc13      LIKE bxc_file.bxc13,    #下腳料及廢料入庫儲位
     bxc14      LIKE bxc_file.bxc14,    #下腳料及廢料入庫批號
     bxc15      LIKE bxc_file.bxc15,    #備註
     #FUN-840202 --start---
     bxcud01 LIKE bxc_file.bxcud01,
     bxcud02 LIKE bxc_file.bxcud02,
     bxcud03 LIKE bxc_file.bxcud03,
     bxcud04 LIKE bxc_file.bxcud04,
     bxcud05 LIKE bxc_file.bxcud05,
     bxcud06 LIKE bxc_file.bxcud06,
     bxcud07 LIKE bxc_file.bxcud07,
     bxcud08 LIKE bxc_file.bxcud08,
     bxcud09 LIKE bxc_file.bxcud09,
     bxcud10 LIKE bxc_file.bxcud10,
     bxcud11 LIKE bxc_file.bxcud11,
     bxcud12 LIKE bxc_file.bxcud12,
     bxcud13 LIKE bxc_file.bxcud13,
     bxcud14 LIKE bxc_file.bxcud14,
     bxcud15 LIKE bxc_file.bxcud15
     #FUN-840202 --end--
                   END RECORD,
  g_wc,g_wc2       STRING,                    #sql字串
  g_sql            STRING,                    #sql字串
  g_pmc03          LIKE pmc_file.pmc03,          #客戶簡稱
  g_imf04          LIKE imf_file.imf04,          #最高存量限制
  g_imf05          LIKE imf_file.imf05,          #庫存單位
  g_pmn38          LIKE pmn_file.pmn38,          #可用/不可用
  g_img07          LIKE img_file.img07,          #採購單位/生產單位
  g_img09          LIKE img_file.img09,          #庫存單位
  g_img10          LIKE img_file.img10,          #庫存數量
  g_rec_b          LIKE type_file.num5,                  #單身筆數
  l_ac             LIKE type_file.num5
DEFINE   b_bxc   RECORD LIKE bxc_file.* 
DEFINE   p_row,p_col          LIKE type_file.num5
DEFINE   g_forupd_sql         STRING          #SELECT ... FOR UPDATE  SQL
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_cnt                LIKE type_file.num10
DEFINE   g_i                  LIKE type_file.num5             #count/index for any purpose
DEFINE   g_msg                LIKE type_file.chr1000
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_row_count          LIKE type_file.num10              #總筆數
DEFINE   g_jump               LIKE type_file.num10              #查詢指定的筆數
DEFINE   g_no_ask             LIKE type_file.num5             #是否開啟指定筆視窗
DEFINE   g_t1                 LIKE type_file.chr5           #單別判斷
 
 
MAIN
#DEFINE
#       l_time   LIKE type_file.chr8      #No.FUN-6A0062
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
 
  WHENEVER ERROR CALL cl_err_msg_log
 
  IF (NOT cl_setup("ABX")) THEN
     EXIT PROGRAM
  END IF
 
  #CALL cl_used('abxt100',g_time,1)  RETURNING g_time   #計算使用時間 (進入時間)
  CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
  LET g_forupd_sql = "SELECT * FROM bxb_file WHERE bxb01 = ? FOR UPDATE"
 
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE t100_cl CURSOR FROM g_forupd_sql
 
  LET p_row = 2 LET p_col = 9
 
  OPEN WINDOW t100_w AT p_row,p_col              #顯示畫面
       WITH FORM "abx/42f/abxt100" ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  LET g_action_choice=""
                           
  CALL t100_menu()
  CLOSE WINDOW t100_w                 #結束畫面
  #CALL cl_used('abxt100',g_time,2) RETURNING g_time  #計算使用時間 (退出時間)
  CALL cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
END MAIN
 
FUNCTION t100_menu()
  WHILE TRUE
    CALL t100_bp("G")
    CASE g_action_choice
         WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL t100_a()
              END IF
         WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t100_q()
              END IF
         WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL t100_r()
              END IF
         WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL t100_u()
             END IF
        WHEN "detail"
             IF cl_chk_act_auth() THEN
                CALL t100_b()
             ELSE
                LET g_action_choice = NULL
             END IF
        WHEN "help"
             CALL cl_show_help()
        WHEN "exit"
             EXIT WHILE
        WHEN "controlg"
             CALL cl_cmdask()
        WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_y()
               CALL t100_pic()
            END IF
        WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_z()
               CALL t100_pic()
            END IF
        WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t100_x() #FUN-D20025 mark
               CALL t100_x(1) #FUN-D20025 add
               CALL t100_pic()
            END IF
        #FUN-D20025 add
         WHEN "undo_void"          #"取消作廢"
            IF cl_chk_act_auth() THEN
               CALL t100_x(2)
               CALL t100_pic()
            END IF
         #FUN-D20025 add     
        WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bxc),'','')
            END IF
        WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_bxb.bxb01 IS NOT NULL THEN
                LET g_doc.column1 = "bxb01"
                LET g_doc.value1 = g_bxb.bxb01
                CALL cl_doc()
             END IF
          END IF
    END CASE
  END WHILE
END FUNCTION
 
FUNCTION t100_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
 
  LET g_action_choice = " "
 
  CALL cl_set_act_visible("accept,cancel", FALSE)
  DISPLAY ARRAY g_bxc TO s_bxc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
  BEFORE DISPLAY
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
  BEFORE ROW
    LET l_ac = ARR_CURR()
    ON ACTION insert
       LET g_action_choice="insert"
       EXIT DISPLAY
    ON ACTION query
       LET g_action_choice="query"
       EXIT DISPLAY
    ON ACTION delete
       LET g_action_choice="delete"
       EXIT DISPLAY
    ON ACTION modify
       LET g_action_choice="modify"
       EXIT DISPLAY
    ON ACTION first
       CALL t100_fetch('F')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)
       END IF
       ACCEPT DISPLAY
    ON ACTION previous
       CALL t100_fetch('P')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)
       END IF
       ACCEPT DISPLAY
    ON ACTION jump
       CALL t100_fetch('/')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)
       END IF
       ACCEPT DISPLAY
    ON ACTION next
       CALL t100_fetch('N')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)
       END IF
       ACCEPT DISPLAY
    ON ACTION last
       CALL t100_fetch('L')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(1)
       END IF
       ACCEPT DISPLAY
    ON ACTION confirm
       LET g_action_choice="confirm"
       EXIT DISPLAY
    ON ACTION undo_confirm
       LET g_action_choice="undo_confirm"
       EXIT DISPLAY
    ON ACTION void
       LET g_action_choice="void"
       EXIT DISPLAY
    #FUN-D20025 add
    ON ACTION undo_void         #取消作廢
       LET g_action_choice="undo_void"
       EXIT DISPLAY
    #FUN-D20025 add     
    ON ACTION detail
       LET g_action_choice="detail"
       LET l_ac = 1
       EXIT DISPLAY
    ON ACTION help
       LET g_action_choice="help"
       EXIT DISPLAY
    ON ACTION locale
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()
       CALL t100_pic()
    ON ACTION exit
       LET g_action_choice="exit"
       EXIT DISPLAY
    ON ACTION controlg
       LET g_action_choice="controlg"
       EXIT DISPLAY
    ON ACTION accept
       LET g_action_choice="detail"
       LET l_ac = ARR_CURR()
       EXIT DISPLAY
    ON ACTION cancel
       LET INT_FLAG = FALSE
       LET g_action_choice="exit"
       EXIT DISPLAY
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE DISPLAY
    ON ACTION about
       CALL cl_about()
    ON ACTION exporttoexcel
       LET g_action_choice = 'exporttoexcel'
       EXIT DISPLAY
#@  ON ACTION 相關文件
    ON ACTION related_document
      LET g_action_choice="related_document"
      EXIT DISPLAY
    AFTER DISPLAY
       CONTINUE DISPLAY
 
    ON ACTION controls                       #No.FUN-6B0033
       CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t100_cs()
  DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
  DEFINE l_temp STRING
  CLEAR FORM                             #清除畫面
  CALL g_bxc.clear()
  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INITIALIZE g_bxb.* TO NULL    #No.FUN-750051
  CONSTRUCT BY NAME g_wc ON bxb01,bxb02,bxb03,bxb16,bxb04,
                            bxb05,bxb14,bxb13,bxb08,bxb06,
                            bxb10,bxb11,bxb07,bxb15,bxb18,
                            bxb17,bxb09,bxbconf,bxb12,
                            bxbuser,bxbgrup,bxbmodu,bxbdate,
                           #FUN-840202   ---start---
                            bxbud01,bxbud02,bxbud03,bxbud04,bxbud05,
                            bxbud06,bxbud07,bxbud08,bxbud09,bxbud10,
                            bxbud11,bxbud12,bxbud13,bxbud14,bxbud15
                           #FUN-840202    ----end----
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION controlp
        CASE
         WHEN INFIELD(bxb01)      #單別   
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form  = "q_bxb01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxb01
              NEXT FIELD bxb01
         WHEN INFIELD(bxb03)      #加工廠商
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_pmc2"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxb03
              CALL t100_bxb03('d')
              NEXT FIELD bxb03
         WHEN INFIELD(bxb04)      #委外單號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_rvu02"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxb04
              CALL t100_bxb04('d')
              NEXT FIELD bxb04
         WHEN INFIELD(bxb13)      #部門代號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_gem" 
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxb13
              CALL t100_bxb13('d')
              NEXT FIELD bxb13
         WHEN INFIELD(bxb14)      #員工代號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_gen" 
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxb14
              CALL t100_bxb14('d')
              NEXT FIELD bxb14
         WHEN INFIELD(bxb16)     #工單資料
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_sfb06"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxb16
              NEXT FIELD bxb16
         WHEN INFIELD(bxb10)     #倉庫資料
              #No.FUN-AA0049--begin
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="q_imd02"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret      
              CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
              #No.FUN-AA0049--end
              DISPLAY g_qryparam.multiret TO bxb10              
              NEXT FIELD bxb10
         WHEN INFIELD(bxb11)     #儲位資料
              #No.FUN-AB0058  --Begin
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="q_ime01"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_ime_1(TRUE,TRUE,g_bxb.bxb11,g_bxb.bxb10,"","","","","") RETURNING g_qryparam.multiret
              #No.FUN-AB0058  --End
              DISPLAY g_qryparam.multiret TO bxb11
              NEXT FIELD bxb11
         WHEN INFIELD(bxb12)     #批號資料
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_img"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxb12
              NEXT FIELD bxb12
         OTHERWISE EXIT CASE
        END CASE	
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION help
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
     ON ACTION qbe_select
        CALL cl_qbe_list() RETURNING lc_qbe_sn
        CALL cl_qbe_display_condition(lc_qbe_sn)        
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bxbuser', 'bxbgrup') #FUN-980030
 
  IF INT_FLAG THEN RETURN END IF
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN
  #     LET g_wc = g_wc CLIPPED," AND bxbuser = '",g_user CLIPPED,"'"
  #  END IF
 
  #  IF g_priv3='4' THEN
  #     LET g_wc = g_wc CLIPPED," AND bxbgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  CONSTRUCT g_wc2 ON bxc02,bxc03,bxc07,bxc08,bxc09,
                     bxc11,bxc04,bxc05,bxc06,bxc10,
                     bxc12,bxc13,bxc14,bxc15
                  #No.FUN-840202 --start--
                    ,bxcud01,bxcud02,bxcud03,bxcud04,bxcud05
                    ,bxcud06,bxcud07,bxcud08,bxcud09,bxcud10
                    ,bxcud11,bxcud12,bxcud13,bxcud14,bxcud15
                  #No.FUN-840202 ---end---
                FROM s_bxc[1].bxc02,s_bxc[1].bxc03,
                     s_bxc[1].bxc07,s_bxc[1].bxc08,
                     s_bxc[1].bxc09,s_bxc[1].bxc11,
                     s_bxc[1].bxc04,s_bxc[1].bxc05,
                     s_bxc[1].bxc06,s_bxc[1].bxc10,
                     s_bxc[1].bxc12,s_bxc[1].bxc13,
                     s_bxc[1].bxc14,s_bxc[1].bxc15
                 #No.FUN-840202 --start--
                    ,s_bxc[1].bxcud01,s_bxc[1].bxcud02,s_bxc[1].bxcud03,s_bxc[1].bxcud04,s_bxc[1].bxcud05
                    ,s_bxc[1].bxcud06,s_bxc[1].bxcud07,s_bxc[1].bxcud08,s_bxc[1].bxcud09,s_bxc[1].bxcud10
                    ,s_bxc[1].bxcud11,s_bxc[1].bxcud12,s_bxc[1].bxcud13,s_bxc[1].bxcud14,s_bxc[1].bxcud15
                 #No.FUN-840202 ---end---
     BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
 
     ON ACTION controlp
        CASE
         WHEN INFIELD(bxc04)     #倉庫資料
              #No.FUN-AA0049--begin
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="q_imd02"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
              #No.FUN-AA0049--end
              DISPLAY g_qryparam.multiret TO bxc04
              NEXT FIELD bxc04
         WHEN INFIELD(bxc05)     #儲位資料
              #No.FUN-AB0058  --Begin
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="q_ime01"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_ime_1(TRUE,TRUE,g_bxc[1].bxc05,"","","","","","") RETURNING g_qryparam.multiret
              #No.FUN-AB0058  --End
              DISPLAY g_qryparam.multiret TO bxc05
              NEXT FIELD bxc05
         WHEN INFIELD(bxc06)     #批號資料
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_img"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxc06
              NEXT FIELD bxc06
         WHEN INFIELD(bxc12)     #倉庫資料
              #No.FUN-AA0049--begin
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="q_imd02"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
              #No.FUN-AA0049--end
              DISPLAY g_qryparam.multiret TO bxc12
              NEXT FIELD bxc12
         WHEN INFIELD(bxc13)     #儲位資料
              #No.FUN-AB0058  --Begin
              #CALL cl_init_qry_var()
              #LET g_qryparam.state = 'c'
              #LET g_qryparam.form ="q_ime01"
              #CALL cl_create_qry() RETURNING g_qryparam.multiret
              CALL q_ime_1(TRUE,TRUE,g_bxc[1].bxc13,"","","","","","") RETURNING g_qryparam.multiret
              #No.FUN-AB0058  --End
              DISPLAY g_qryparam.multiret TO bxc13
              NEXT FIELD bxc13
         WHEN INFIELD(bxc14)     #批號資料
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_img"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bxc14
              NEXT FIELD bxc14
         OTHERWISE EXIT CASE
        END CASE	
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION help
        CALL cl_show_help()
 
     ON ACTION controlg
        CALL cl_cmdask()
     ON ACTION qbe_save
        CALL cl_qbe_save()
  END CONSTRUCT
 
  IF INT_FLAG THEN
     RETURN
  END IF
 
  IF g_wc2 = " 1=1" THEN            # 若單身未輸入條件
     LET g_sql = " SELECT bxb01 FROM bxb_file ",
                 "  WHERE ", g_wc CLIPPED,
                 "  ORDER BY bxb01"
  ELSE                              # 若單身有輸入條件
     LET g_sql = " SELECT UNIQUE bxb_file.bxb01 ",
                 "   FROM bxb_file, bxc_file ",
                 "  WHERE bxb01 = bxc01",
                 "    AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 "  ORDER BY bxb01"
  END IF
 
  PREPARE t100_prepare FROM g_sql
  DECLARE t100_cs SCROLL CURSOR WITH HOLD FOR t100_prepare
 
  IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
     LET g_sql=" SELECT COUNT(*) FROM bxb_file WHERE ",g_wc CLIPPED
  ELSE
     LET g_sql=" SELECT COUNT(DISTINCT bxb01) ",
               "   FROM bxb_file,bxc_file ",
               "  WHERE bxb01=bxc01 AND ",g_wc CLIPPED,
               "    AND ",g_wc2 CLIPPED
  END IF
 
  PREPARE t100_precount FROM g_sql
  DECLARE t100_count CURSOR FOR t100_precount
 
END FUNCTION
 
FUNCTION t100_a()
  DEFINE li_result   LIKE type_file.num5
 
  MESSAGE ""
  CLEAR FORM
  CALL g_bxc.clear()
 
  IF s_shut(0) THEN
     RETURN
  END IF
 
  INITIALIZE g_bxb.* LIKE bxb_file.*             #DEFAULT 設定
  LET g_bxb01_t = NULL
 
  #預設值及將數值類變數清成零
  LET g_bxb_t.* = g_bxb.*
  LET g_bxb_o.* = g_bxb.*
  CALL cl_opmsg('a')
 
  WHILE TRUE
     LET g_bxb.bxbuser = g_user
     LET g_bxb.bxbgrup = g_grup
     LET g_bxb.bxbdate = g_today
     LET g_bxb.bxb02   = g_today
     LET g_bxb.bxb08   = g_today
     LET g_bxb.bxbconf = 'N'
 
     LET g_bxb.bxbplant = g_plant  #FUN-980001 add
     LET g_bxb.bxblegal = g_legal  #FUN-980001 add
 
     CALL t100_i("a")                   #輸入單頭
 
     IF INT_FLAG THEN                   #使用者不玩了
        INITIALIZE g_bxb.* TO NULL
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
 
     IF cl_null(g_bxb.bxb01) THEN       # KEY 不可空白
        CONTINUE WHILE
     END IF
 
     BEGIN WORK
 
     LET g_t1 = s_get_doc_no(g_bxb.bxb01)
     CALL s_auto_assign_no("abx",g_t1,g_bxb.bxb02,"E","","","","","")
          RETURNING li_result,g_bxb.bxb01
     IF (NOT li_result) THEN
        ROLLBACK WORK      
        CONTINUE WHILE
     END IF
     #進行輸入之單號檢查
     CALL s_mfgchno(g_bxb.bxb01) RETURNING g_i,g_bxb.bxb01
     DISPLAY BY NAME g_bxb.bxb01
     IF NOT g_i THEN
        ROLLBACK WORK      
        CONTINUE WHILE
     END IF
 
     LET g_bxb.bxboriu = g_user      #No.FUN-980030 10/01/04
     LET g_bxb.bxborig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO bxb_file VALUES (g_bxb.*)
 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,1)   #No.FUN-B80082---調整至回滾事務前---
        ROLLBACK WORK      
        CONTINUE WHILE
     END IF
   
     IF t100_bxb16_gen() THEN   #將工單單身資料複製至此筆單身   
        ROLLBACK WORK
        CONTINUE WHILE
     END IF
 
     COMMIT WORK
 
     SELECT bxb01 INTO g_bxb.bxb01 FROM bxb_file
      WHERE bxb01 = g_bxb.bxb01
     LET g_bxb01_t = g_bxb.bxb01        #保留舊值
     LET g_bxb_t.* = g_bxb.*
     LET g_bxb_o.* = g_bxb.*
     CALL g_bxc.clear()              #清除單身資料
     CALL t100_show()                   #重新載入單頭單身
     CALL t100_b()                      #輸入單身
     EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION t100_i(p_cmd)
DEFINE
  l_n            LIKE type_file.num5,
  p_cmd          LIKE type_file.chr1,           #a:輸入 u:更改
  l_code         LIKE type_file.num5,
  sn1,sn2        LIKE type_file.num5,
  l_sfb82        LIKE sfb_file.sfb82,
  l_sfb1001    LIKE sfb_file.sfb1001,
  li_result      LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   DISPLAY BY NAME g_bxb.bxb06,g_bxb.bxb08,g_bxb.bxb09,
                   g_bxb.bxbconf,g_bxb.bxb16
 
   CALL cl_set_head_visible("","YES")  #No.FUN-6B0033
 
   INPUT BY NAME g_bxb.bxb01,g_bxb.bxb02,g_bxb.bxb03,
                 g_bxb.bxb16,g_bxb.bxb04,g_bxb.bxb05,
                 g_bxb.bxb14,g_bxb.bxb13,g_bxb.bxb10,
                 g_bxb.bxb11,g_bxb.bxb07,g_bxb.bxb15,
                 g_bxb.bxb17,g_bxb.bxb12,
                 g_bxb.bxbuser,g_bxb.bxbgrup,g_bxb.bxbmodu,
                 g_bxb.bxbdate,
                #FUN-840202     ---start---
                 g_bxb.bxbud01,g_bxb.bxbud02,g_bxb.bxbud03,g_bxb.bxbud04,
                 g_bxb.bxbud05,g_bxb.bxbud06,g_bxb.bxbud07,g_bxb.bxbud08,
                 g_bxb.bxbud09,g_bxb.bxbud10,g_bxb.bxbud11,g_bxb.bxbud12,
                 g_bxb.bxbud13,g_bxb.bxbud14,g_bxb.bxbud15 
                #FUN-840202     ----end----
                 WITHOUT DEFAULTS
  
    BEFORE INPUT
       LET g_before_input_done = FALSE
       CALL t100_set_entry(p_cmd)
       CALL t100_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
 
    AFTER FIELD bxb01   #進廠單號
       IF NOT cl_null(g_bxb.bxb01) THEN
          IF p_cmd = "a" OR (p_cmd = "u" AND g_bxb.bxb01 != g_bxb01_t) THEN  
#            CALL s_check_no(g_sys,g_bxb.bxb01,g_bxb01_t,"E","bxb_file","bxb01","")
             CALL s_check_no("abx",g_bxb.bxb01,g_bxb01_t,"E","bxb_file","bxb01","")  #No.FUN-A40041
                  RETURNING li_result,g_bxb.bxb01
             DISPLAY BY NAME g_bxb.bxb01
             IF (NOT li_result) THEN
                NEXT FIELD bxb01
             END IF
          END IF
       END IF
       LET g_bxb_o.bxb01 = g_bxb.bxb01
   
    AFTER FIELD bxb02    #單據日期
       LET g_bxb.bxb08 = g_bxb.bxb02
       DISPLAY BY NAME g_bxb.bxb08
       LET g_bxb_o.bxb02 = g_bxb.bxb02
 
    AFTER FIELD bxb03   #加工廠商
       IF NOT cl_null(g_bxb.bxb03) THEN
          CALL t100_bxb03('a')
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bxb.bxb03,g_errno,0)
             LET g_bxb.bxb03 = g_bxb_o.bxb03
             NEXT FIELD bxb03
          END IF
         #IF 加工廠商代號變動 THEN 清空 委外入庫單號、品號、數量、工單單號
          IF g_bxb.bxb03 != g_bxb_o.bxb03 OR
             cl_null(g_bxb_o.bxb03) THEN
             LET g_bxb.bxb04 = NULL
             LET g_bxb.bxb05 = NULL
             LET g_bxb.bxb06 = NULL
             LET g_bxb.bxb07 = NULL
             LET g_bxb.bxb16 = NULL
             LET g_bxb_o.bxb04 = NULL
             LET g_bxb_o.bxb05 = NULL
             LET g_bxb_o.bxb16 = NULL
             CALL t100_ima()
             DISPLAY BY NAME g_bxb.bxb04,g_bxb.bxb06,
                             g_bxb.bxb07,g_bxb.bxb16
          END IF
       END IF
       LET g_bxb_o.bxb03 = g_bxb.bxb03
 
    AFTER FIELD bxb16   #工單單號
       IF cl_null(g_bxb.bxb03) THEN
          CALL cl_err('','mfg5103',0)
          NEXT FIELD bxb03
       END IF
       IF NOT cl_null(g_bxb.bxb16) THEN
          CALL t100_bxb16('a')
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bxb.bxb16,g_errno,0)
             LET g_bxb.bxb16 = g_bxb_o.bxb16
             NEXT FIELD bxb16
          END IF
         #IF 工單單號 THEN 清空 委外入庫單號、品號、數量
          IF g_bxb.bxb16 != g_bxb_o.bxb16 OR
             cl_null(g_bxb_o.bxb16) THEN
             LET g_bxb.bxb04 = NULL
             LET g_bxb.bxb05 = NULL
             LET g_bxb.bxb06 = NULL
             LET g_bxb.bxb07 = NULL
             LET g_bxb_o.bxb04 = NULL
             LET g_bxb_o.bxb05 = NULL
             CALL t100_ima()
             DISPLAY BY NAME g_bxb.bxb04,g_bxb.bxb06,
                             g_bxb.bxb07
          END IF
       END IF
       LET g_bxb_o.bxb16 = g_bxb.bxb16   
 
    AFTER FIELD bxb04   #委外入庫單號
       IF NOT cl_null(g_bxb.bxb04) THEN
          IF g_bxb.bxb04 != g_bxb_o.bxb04 OR
             cl_null(g_bxb_o.bxb04) THEN
             CALL t100_bxb04('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_bxb.bxb04,g_errno,0)
                LET g_bxb.bxb04 = g_bxb_o.bxb04
                NEXT FIELD bxb04
             END IF
             IF NOT cl_null(g_bxb.bxb05) THEN
                IF g_bxb.bxb04 != g_bxb_o.bxb04 OR
                   g_bxb.bxb05 != g_bxb_o.bxb05 OR
                   cl_null(g_bxb_o.bxb04) OR
                   cl_null(g_bxb_o.bxb05) THEN
                   CALL t100_bxb05('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_bxb.bxb05,g_errno,0)
                      LET g_bxb.bxb05 = g_bxb_o.bxb05
                      NEXT FIELD bxb05
                   END IF
                END IF
             END IF
          END IF
       END IF
       LET g_bxb_o.bxb04 = g_bxb.bxb04
 
    AFTER FIELD bxb05   #委外入庫項次
       IF cl_null(g_bxb.bxb04) THEN
          CALL cl_err('','mfg5103',0)
          NEXT FIELD bxb04
       END IF
       IF NOT cl_null(g_bxb.bxb05) THEN
          IF g_bxb.bxb04 != g_bxb_o.bxb04 OR
             g_bxb.bxb05 != g_bxb_o.bxb05 OR
             cl_null(g_bxb_o.bxb04) OR cl_null(g_bxb_o.bxb05) THEN
             CALL t100_bxb05('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_bxb.bxb05,g_errno,0)
                LET g_bxb.bxb05 = g_bxb_o.bxb05
                NEXT FIELD bxb05
             END IF
          END IF
       END IF
       LET g_bxb_o.bxb05 = g_bxb.bxb05
 
    AFTER FIELD bxb14   #員工代號
       IF NOT cl_null(g_bxb.bxb14) THEN
          CALL t100_bxb14('a')
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bxb.bxb14,g_errno,0)
             LET g_bxb.bxb14 = g_bxb_o.bxb14
             NEXT FIELD bxb14
          END IF
       END IF
       LET g_bxb_o.bxb14 = g_bxb.bxb14
 
    AFTER FIELD bxb13   #部門代號
       IF NOT cl_null(g_bxb.bxb13) THEN
          CALL t100_bxb13('a')
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bxb.bxb13,g_errno,0)
             LET g_bxb.bxb13 = g_bxb_o.bxb13
             NEXT FIELD bxb13
          END IF
       END IF
       LET g_bxb_o.bxb13 = g_bxb.bxb13
 
    AFTER FIELD bxb10   #庫別
       IF NOT cl_null(g_bxb.bxb10) THEN
          #No.FUN-AA0049--begin
          IF NOT s_chk_ware(g_bxb.bxb10) THEN
             NEXT FIELD bxc10
          END IF 
          #No.FUN-AA0049--end           
          #------>check-1  檢查該料是否可收至該倉
          IF NOT s_imfchk1(g_bxb.bxb06,g_bxb.bxb10) THEN
             LET g_bxb.bxb10=g_bxb_o.bxb10
             CALL cl_err('s_imfchk1:','mfg9036',0) 
             NEXT FIELD bxb10
          END IF
          #------>check-2  檢查倉庫須存在否
          CALL s_stkchk(g_bxb.bxb10,'A') RETURNING l_code
          IF NOT l_code THEN
             LET g_bxb.bxb10=g_bxb_o.bxb10
             CALL cl_err('s_stkchk:','mfg1100',0)
             NEXT FIELD bxb10
          END IF
          #------>check-3  檢查是否為可用倉
          CALL s_swyn(g_bxb.bxb10) RETURNING sn1,sn2
          IF sn1=1 AND g_bxb.bxb10 != g_bxb_o.bxb10 THEN
             LET g_bxb.bxb10 = g_bxb_o.bxb10
             CALL cl_err(g_bxb.bxb10,'mfg6080',0) 
             NEXT FIELD bxb10
          ELSE
             IF sn2=2 AND g_bxb.bxb10 != g_bxb_o.bxb10 THEN
                LET g_bxb.bxb10=g_bxb_o.bxb10
                CALL cl_err(g_bxb.bxb10,'mfg6085',0)
                NEXT FIELD bxb10
             END IF
          END IF
          LET sn1=0 LET sn2=0      
       END IF
       LET g_bxb_o.bxb10 = g_bxb.bxb10
 
    AFTER FIELD bxb11   #儲位
       IF NOT cl_null(g_bxb.bxb11) THEN
          #CHI-CC0014 -----------mark ---------begin
          #------>檢查料號預設倉儲及單別預設倉儲
          #IF NOT s_chksmz(g_bxb.bxb06,g_bxb.bxb04,
          #                g_bxb.bxb10,g_bxb.bxb11) THEN
          #   NEXT FIELD bxb11 
          #END IF
          #CHI-CC0014 ----------mark -----------end
          #------>check-1  檢查該料是否可收至該倉/儲位
          IF NOT s_imfchk(g_bxb.bxb06,g_bxb.bxb10,
                          g_bxb.bxb11) THEN
             LET g_bxb.bxb11 = g_bxb_o.bxb11
             CALL cl_err(g_bxb.bxb11,'mfg6095',0) 
             NEXT FIELD bxb11
          END IF
          #------>check-2  檢查該倉庫/儲位是否存在
          CALL s_hqty(g_bxb.bxb06,g_bxb.bxb10,g_bxb.bxb11)
               RETURNING g_cnt,g_imf04,g_imf05
          IF g_imf04 IS NULL THEN LET g_imf04=0 END IF
          CALL s_lwyn(g_bxb.bxb10,g_bxb.bxb11)
               RETURNING sn1,sn2    #可用否
          IF sn2 = 2 THEN
             IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF
          ELSE
             IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF
          END IF
          LET sn1=0 LET sn2=0
       ELSE
          LET g_bxb.bxb11 = ' '
       END IF
       LET g_bxb_o.bxb11 = g_bxb.bxb11
 
    AFTER FIELD bxb12   #批號
       IF cl_null(g_bxb.bxb12) THEN LET g_bxb.bxb12 = ' ' END IF
       LET g_bxb_o.bxb12 = g_bxb.bxb12
 
    AFTER FIELD bxb07   #進廠數量
       IF NOT cl_null(g_bxb.bxb07) AND g_bxb.bxb07<0 THEN
          LET g_bxb.bxb07=g_bxb_o.bxb07
          CALL cl_err('','mfg5034',0)
          NEXT FIELD bxb07
       END IF
       LET g_bxb_o.bxb07 = g_bxb.bxb07
 
        #FUN-840202     ---start---
        AFTER FIELD bxbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    ON ACTION CONTROLF                  #欄位說明
       CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
       CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
    ON ACTION controlp
       CASE
           WHEN INFIELD(bxb01)     #單別        
              LET g_t1 = s_get_doc_no(g_bxb.bxb01)
#             CALL q_bna(FALSE,TRUE,g_t1,'E',g_sys) RETURNING g_t1
              CALL q_bna(FALSE,TRUE,g_t1,'E','abx') RETURNING g_t1   #No.FUN-A40041
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
              END IF
              LET g_bxb.bxb01 = g_t1
              NEXT FIELD bxb01
           WHEN INFIELD(bxb03)     #委外廠商
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc2"
                LET g_qryparam.default1 = g_bxb.bxb03
                CALL cl_create_qry() RETURNING g_bxb.bxb03
                CALL t100_bxb03('a')
                NEXT FIELD bxb03
           WHEN INFIELD(bxb04)     #委外單號
                CALL cl_init_qry_var()   
                LET g_qryparam.form ="q_rvu02"
                LET g_qryparam.default1 = g_bxb.bxb04
                IF cl_null(g_bxb.bxb16) THEN
                   LET g_qryparam.arg1= ' '
                ELSE
                   LET g_qryparam.arg1= g_bxb.bxb16
                END IF
                CALL cl_create_qry() RETURNING g_bxb.bxb04,
                                               g_bxb.bxb05
                CALL t100_bxb04('a')
                NEXT FIELD bxb04
           WHEN INFIELD(bxb13)     #部門代號
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gem" 
                LET g_qryparam.default1 = g_bxb.bxb13
                CALL cl_create_qry() RETURNING g_bxb.bxb13
                CALL t100_bxb13('a')
                NEXT FIELD bxb13
           WHEN INFIELD(bxb14)     #員工代號
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen" 
                LET g_qryparam.default1 = g_bxb.bxb14
                CALL cl_create_qry() RETURNING g_bxb.bxb14
                CALL t100_bxb14('a')
                NEXT FIELD bxb14
           WHEN INFIELD(bxb10) OR INFIELD(bxb11) OR INFIELD(bxb12)
                CALL q_img4(FALSE,FALSE,
                            g_bxb.bxb06,g_bxb.bxb10,
                            g_bxb.bxb11,g_bxb.bxb12,'A')
                RETURNING g_bxb.bxb10,g_bxb.bxb11,g_bxb.bxb12
                DISPLAY g_bxb.bxb10 TO bxb10
                DISPLAY g_bxb.bxb11 TO bxb11
                DISPLAY g_bxb.bxb12 TO bxb12
                IF INFIELD(bxb10) THEN NEXT FIELD bxb10 END IF
                IF INFIELD(bxb11) THEN NEXT FIELD bxb11 END IF
                IF INFIELD(bxb12) THEN NEXT FIELD bxb12 END IF
           WHEN INFIELD(bxb16)     #工單資料
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_sfb06"
                LET g_qryparam.arg1 = g_bxb.bxb03
                LET g_qryparam.default1 = g_bxb.bxb16
                CALL cl_create_qry() RETURNING g_bxb.bxb16
                CALL t100_bxb16('a')
                NEXT FIELD bxb16
           OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLA  #查預設倉庫/儲位
       CASE
           WHEN INFIELD(bxb10)   #庫別
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imf"
                IF cl_null(g_bxb.bxb06) THEN
                   LET g_qryparam.arg1 = " "
                ELSE
                   LET g_qryparam.arg1 = g_bxb.bxb06 
                END IF
                LET g_qryparam.default1 = g_bxb.bxb10,
                                          g_bxb.bxb11
                CALL cl_create_qry() RETURNING g_bxb.bxb10,
                                               g_bxb.bxb11
                NEXT FIELD bxb10
           OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLB  #建立倉庫/儲位
       CASE
           WHEN INFIELD(bxb10)   #庫別
                CALL cl_cmdrun("aimi200")
                NEXT FIELD bxb10
           WHEN INFIELD(bxb11)   #儲位
                CALL cl_cmdrun("aimi201")
                NEXT FIELD bxb11
           OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLC  #查倉庫別/儲位別
       CASE
           WHEN INFIELD(bxb10)   #庫別
                #No.FUN-AA0049--begin
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_imd02"
                #LET g_qryparam.default1 = g_bxb.bxb10
                #CALL cl_create_qry() RETURNING g_bxb.bxb10
                CALL q_imd_1(FALSE,TRUE,g_bxb.bxb10,"","","","") RETURNING g_bxb.bxb10
                #No.FUN-AA0049--end
                NEXT FIELD bxb10
           WHEN INFIELD(bxb11)   #儲位
                #No.FUN-AA0049--begin
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_ime01"
                #IF cl_null(g_bxb.bxb10) THEN
                #   LET g_qryparam.arg1 = " "
                #ELSE
                #   LET g_qryparam.arg1 = g_bxb.bxb10 
                #END IF
                #LET g_qryparam.default1 = g_bxb.bxb11
                #CALL cl_create_qry() RETURNING g_bxb.bxb11
                CALL q_ime_1(FALSE,TRUE,g_bxb.bxb11,g_bxb.bxb10,"",g_plant,"","","") RETURNING g_bxb.bxb11
                #No.FUN-AA0049--end
                NEXT FIELD bxb11
           OTHERWISE EXIT CASE
       END CASE
    	
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about
       CALL cl_about()
 
    ON ACTION help
       CALL cl_show_help()
 
    AFTER INPUT
       IF INT_FLAG THEN EXIT INPUT END IF
   END INPUT
 
END FUNCTION
 
FUNCTION t100_u()
 
  IF s_shut(0) THEN RETURN END IF
 
  IF cl_null(g_bxb.bxb01) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  SELECT * INTO g_bxb.* FROM bxb_file WHERE bxb01 = g_bxb.bxb01
 
  IF g_bxb.bxbconf ='Y' THEN    #檢查資料是否為已確認
     CALL cl_err(g_bxb.bxb01,'9022',0)
     RETURN
  END IF
  IF g_bxb.bxbconf ='X' THEN    #檢查資料是否為作廢
     CALL cl_err(g_bxb.bxb01,'9022',0)
     RETURN
  END IF
 
  MESSAGE ""
  CALL cl_opmsg('u')
  LET g_bxb01_t = g_bxb.bxb01
  BEGIN WORK
  OPEN t100_cl USING g_bxb.bxb01
  IF STATUS THEN
     CALL cl_err("OPEN t100_cl:", STATUS, 1)
     CLOSE t100_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH t100_cl INTO g_bxb.*                      # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)    # 資料被他人LOCK
     CLOSE t100_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  CALL t100_show()
  WHILE TRUE
     LET g_bxb01_t = g_bxb.bxb01
     LET g_bxb_t.* = g_bxb.*
     LET g_bxb_o.* = g_bxb.*
     LET g_bxb.bxbmodu=g_user
     LET g_bxb.bxbdate=g_today
 
     CALL t100_i("u")                      #欄位更改
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_bxb.*=g_bxb_t.*
        CALL t100_show()
        CALL cl_err('','9001',0)
        EXIT WHILE
     END IF
 
     IF g_bxb.bxb01 != g_bxb01_t THEN            # 更改單號   
        UPDATE bxc_file SET bxc01 = g_bxb.bxb01 
        WHERE bxc01 = g_bxb01_t
        IF SQLCA.sqlcode THEN
           CALL cl_err('bxc_file',SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
     END IF
 
      UPDATE bxb_file SET bxb_file.* = g_bxb.*
       WHERE bxb01 = g_bxb01_t
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)
        CONTINUE WHILE
     END IF
 
     CALL t100_show()
     EXIT WHILE
  END WHILE
 
  CLOSE t100_cl
  COMMIT WORK
  CALL t100_pic()
END FUNCTION
 
FUNCTION t100_show()
  LET g_bxb_t.* = g_bxb.*                #保存單頭舊值
  LET g_bxb_o.* = g_bxb.*                #保存單頭舊值
  DISPLAY BY NAME g_bxb.bxb01,g_bxb.bxb02,g_bxb.bxb03,
                  g_bxb.bxb04,g_bxb.bxb05,g_bxb.bxb06,
                  g_bxb.bxb07,g_bxb.bxb08,g_bxb.bxb09,
                  g_bxb.bxb10,g_bxb.bxb11,g_bxb.bxb12,
                  g_bxb.bxb13,g_bxb.bxb14,g_bxb.bxb15,
                  g_bxb.bxb16,g_bxb.bxb17,g_bxb.bxb18,
                  g_bxb.bxbconf,g_bxb.bxbuser,g_bxb.bxbgrup,
                  g_bxb.bxbmodu,g_bxb.bxbdate,
           #FUN-840202     ---start---
           g_bxb.bxbud01,g_bxb.bxbud02,g_bxb.bxbud03,g_bxb.bxbud04,
           g_bxb.bxbud05,g_bxb.bxbud06,g_bxb.bxbud07,g_bxb.bxbud08,
           g_bxb.bxbud09,g_bxb.bxbud10,g_bxb.bxbud11,g_bxb.bxbud12,
           g_bxb.bxbud13,g_bxb.bxbud14,g_bxb.bxbud15 
           #FUN-840202     ----end----
  CALL t100_ima()
  CALL t100_bxb03('d')
  CALL t100_bxb13('d')
  CALL t100_bxb14('d')
  CALL t100_bxb09()
  CALL t100_b_fill(g_wc2)                 #單身
  CALL t100_pic()
END FUNCTION
 
FUNCTION t100_q()
  LET g_row_count=0
  LET g_curs_index=0
  CALL cl_navigator_setting(g_curs_index,g_row_count)
  MESSAGE ""
  CALL cl_opmsg('q')
  CLEAR FORM
  INITIALIZE g_bxb.* TO NULL
  INITIALIZE g_bxb_o.* TO NULL
  INITIALIZE g_bxb_t.* TO NULL
  LET g_bxb01_t = NULL
  CALL g_bxc.clear()
  DISPLAY '' TO FORMONLY.cnt
  DISPLAY '' TO FORMONLY.cn2
 
  CALL t100_cs()
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     INITIALIZE g_bxb.* TO NULL
     RETURN
  END IF
 
  OPEN t100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
  IF SQLCA.sqlcode THEN
     CALL cl_err('',SQLCA.sqlcode,0)
     INITIALIZE g_bxb.* TO NULL
  ELSE
     OPEN t100_count
     FETCH t100_count INTO g_row_count
     DISPLAY g_row_count TO FORMONLY.cnt
     CALL t100_fetch('F')                  # 讀出TEMP第一筆並顯示
  END IF
END FUNCTION
 
FUNCTION t100_fetch(p_flag)
  DEFINE p_flag LIKE type_file.chr1
 
  CASE p_flag
     WHEN 'N' FETCH NEXT     t100_cs INTO g_bxb.bxb01
     WHEN 'P' FETCH PREVIOUS t100_cs INTO g_bxb.bxb01
     WHEN 'F' FETCH FIRST    t100_cs INTO g_bxb.bxb01
     WHEN 'L' FETCH LAST     t100_cs INTO g_bxb.bxb01
     WHEN '/'
           IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
               END PROMPT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
           END IF
           FETCH ABSOLUTE g_jump t100_cs INTO g_bxb.bxb01
           LET g_no_ask = FALSE
  END CASE
 
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)
     INITIALIZE g_bxb.* TO NULL
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
 
  SELECT * INTO g_bxb.* FROM bxb_file WHERE bxb01 = g_bxb.bxb01
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)
     INITIALIZE g_bxb.* TO NULL
     RETURN
  END IF
 
  CALL t100_show()
 
END FUNCTION
 
FUNCTION t100_b()
  DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重複用
    l_cnt           LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5,              #可刪除否
    l_count         LIKE type_file.num5,              #計算回收數量
    l_code          LIKE type_file.num5,
    sn1,sn2         LIKE type_file.num5
 
 
  LET g_action_choice = ""
 
  IF s_shut(0) THEN RETURN END IF
 
  IF cl_null(g_bxb.bxb01) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  SELECT * INTO g_bxb.* FROM bxb_file WHERE bxb01=g_bxb.bxb01
 
  IF g_bxb.bxbconf ='Y' THEN    #檢查資料是否為已確認
     CALL cl_err(g_bxb.bxb01,'9022',0)
     RETURN
  END IF
  IF g_bxb.bxbconf ='X' THEN    #檢查資料是否為作廢
     CALL cl_err(g_bxb.bxb01,'9022',0)
     RETURN
  END IF
 
  CALL cl_opmsg('b')
 
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM bxc_file
   WHERE bxc01 = g_bxb.bxb01
  IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
  IF l_cnt = 0 THEN
     IF cl_confirm('abx-039') THEN  #詢問是否自動產生單身
        BEGIN WORK
        IF t100_bxb16_gen() THEN   #將工單單身資料複製至此筆單身   
           ROLLBACK WORK
        ELSE
           COMMIT WORK
        END IF
        CALL t100_show()
     END IF
  END IF
 
  LET g_forupd_sql = " SELECT bxc02,bxc03,'','','',bxc07, ",
                     "        bxc08,bxc09,bxc11,bxc04, ",
                     "        bxc05,bxc06,bxc10,bxc12, ",
                     "        bxc13,bxc14,bxc15, ",
                  #No.FUN-840202 --start--
                     "        bxcud01,bxcud02,bxcud03,bxcud04,bxcud05,",
                     "        bxcud06,bxcud07,bxcud08,bxcud09,bxcud10,",
                     "        bxcud11,bxcud12,bxcud13,bxcud14,bxcud15 ",
                  #No.FUN-840202 ---end---
                     "   FROM bxc_file ",
                     "  WHERE bxc01=? and bxc02=? FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE t100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
  LET l_allow_insert = 0
  LET l_allow_delete = cl_detail_input_auth("delete")
 
  INPUT ARRAY g_bxc WITHOUT DEFAULTS FROM s_bxc.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN 
          CALL fgl_set_arr_curr(l_ac) 
       END IF
 
    BEFORE ROW
       LET p_cmd = ''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'
       LET l_n = ARR_COUNT()
 
       BEGIN WORK
 
       OPEN t100_cl USING g_bxb.bxb01
       IF STATUS THEN
          CALL cl_err("OPEN t100_cl:",STATUS,1)
          CLOSE t100_cl
          ROLLBACK WORK
          RETURN
       END IF 
 
       FETCH t100_cl INTO g_bxb.*
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)
          CLOSE t100_cl
          ROLLBACK WORK
          RETURN
       END IF
 
       IF g_rec_b >= l_ac THEN
          LET p_cmd = 'u'
          LET g_bxc_t.* = g_bxc[l_ac].*
          LET g_bxc_o.* = g_bxc[l_ac].*
          OPEN t100_bcl USING g_bxb.bxb01,g_bxc_t.bxc02
          IF STATUS THEN
             CALL cl_err("OPEN t100_bcl:",STATUS,1)
             LET l_lock_sw = "Y"
          ELSE
             FETCH t100_bcl INTO g_bxc[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_bxc_t.bxc02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF           
             CALL t100_bxc03('d')
          END IF
       ELSE
          IF g_rec_b <= 0 THEN   #無單身資料，即離開單身作業
             RETURN          
          END IF
       END IF
 
    AFTER FIELD bxc02   #項次
       IF NOT cl_null(g_bxc[l_ac].bxc02) THEN
          IF g_bxc[l_ac].bxc02 < 1 THEN
             CALL cl_err('','mfg1322',0)
             LET g_bxc[l_ac].bxc02 = g_bxc_o.bxc02
             DISPLAY BY NAME g_bxc[l_ac].bxc02
             NEXT FIELD bxc02
          END IF
          IF g_bxc[l_ac].bxc02 != g_bxc_t.bxc02 THEN
             SELECT count(*) INTO l_n FROM bxc_file        #檢查key值 
              WHERE bxc01 = g_bxb.bxb01 
                AND bxc02 = g_bxc[l_ac].bxc02
             IF l_n > 0 THEN 
                CALL cl_err('',-239,0)
                LET g_bxc[l_ac].bxc02 = g_bxc_o.bxc02
                DISPLAY BY NAME g_bxc[l_ac].bxc02
                NEXT FIELD bxc02
             END iF
          END IF
          LET g_bxc_o.bxc02 = g_bxc[l_ac].bxc02
       END IF
 
    AFTER FIELD bxc08   #使用原料總數
       IF NOT cl_null(g_bxc[l_ac].bxc08) THEN
          IF g_bxc[l_ac].bxc08 < 0 THEN
             CALL cl_err('','mfg5034',0)
             LET g_bxc[l_ac].bxc08 = g_bxc_o.bxc08
             DISPLAY BY NAME g_bxc[l_ac].bxc08
             NEXT FIELD bxc08          
          END IF
       END IF
       LET g_bxc_o.bxc08=g_bxc[l_ac].bxc08
 
    AFTER FIELD bxc09   #損耗總數
       IF NOT cl_null(g_bxc[l_ac].bxc09) THEN
          IF g_bxc[l_ac].bxc09 < 0 THEN
             CALL cl_err('','mfg5034',0)
             LET g_bxc[l_ac].bxc09 = g_bxc_o.bxc09
             DISPLAY BY NAME g_bxc[l_ac].bxc09
             NEXT FIELD bxc09          
          END IF
       END IF
       LET g_bxc_o.bxc09=g_bxc[l_ac].bxc09
 
    AFTER FIELD bxc11   #未加工運回原料數量
       IF NOT cl_null(g_bxc[l_ac].bxc11) THEN
          IF g_bxc[l_ac].bxc11 < 0 THEN
             CALL cl_err('','mfg5034',0)
             LET g_bxc[l_ac].bxc11 = g_bxc_o.bxc11
             DISPLAY BY NAME g_bxc[l_ac].bxc11
             NEXT FIELD bxc11          
          END IF
       END IF
       LET g_bxc_o.bxc11=g_bxc[l_ac].bxc11
 
    AFTER FIELD bxc04   #未加工運回原料入庫庫別
       IF NOT cl_null(g_bxc[l_ac].bxc04) THEN
          #No.FUN-AA0049--begin
          IF NOT s_chk_ware(g_bxc[l_ac].bxc04) THEN
             NEXT FIELD bxc04
          END IF 
          #No.FUN-AA0049--end       
          #------>check    運回回原料庫別不可和下腳料庫別相同
          IF g_bxc[l_ac].bxc04 = g_bxc[l_ac].bxc12 THEN
             CALL cl_err(g_bxc[l_ac].bxc04,'abx-040',0)
             NEXT FIELD bxc04
          END IF
          #------>check-1  檢查該料是否可收至該倉
          IF NOT s_imfchk1(g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc04) THEN
             LET g_bxc[l_ac].bxc04=g_bxc_o.bxc04
             CALL cl_err('s_imfchk1:','mfg9036',0)
             NEXT FIELD bxc04
          END IF
          #------>check-2  檢查倉庫須存在否
          CALL s_stkchk(g_bxc[l_ac].bxc04,'A') RETURNING l_code
          IF NOT l_code THEN
             LET g_bxc[l_ac].bxc04=g_bxc_o.bxc04
             CALL cl_err('s_stkchk:','mfg1100',0)
             NEXT FIELD bxc04
          END IF
         #------>check-3  檢查是否為可用倉
          CALL s_swyn(g_bxc[l_ac].bxc04) RETURNING sn1,sn2
          IF sn1=1 AND g_bxc[l_ac].bxc04 != g_bxc_t.bxc04 THEN
             LET g_bxc[l_ac].bxc04=g_bxc_o.bxc04
             CALL cl_err(g_bxc[l_ac].bxc04,'mfg6080',0)
             NEXT FIELD bxc04
          ELSE
             IF sn2=2 AND g_bxc[l_ac].bxc04 != g_bxc_t.bxc04 THEN
                LET g_bxc[l_ac].bxc04=g_bxc_o.bxc04
                CALL cl_err(g_bxc[l_ac].bxc04,'mfg6085',0)
                NEXT FIELD bxc04
             END IF
          END IF
          LET sn1=0 LET sn2=0
       END IF
       LET g_bxc_o.bxc04 = g_bxc[l_ac].bxc04
 
    AFTER FIELD bxc05          #運回原料儲位
       IF NOT cl_null(g_bxc[l_ac].bxc05) THEN
          #------>check-1  檢查該料是否可收至該倉/儲位
          IF NOT s_imfchk(g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc04,
                          g_bxc[l_ac].bxc05) THEN
             LET g_bxc[l_ac].bxc05=g_bxc_o.bxc05
             CALL cl_err(g_bxc[l_ac].bxc05,'mfg6095',0)
             NEXT FIELD bxc05
          END IF
          #------>check-2  檢查該倉庫/儲位是否存在
          CALL s_hqty(g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc04,
                      g_bxc[l_ac].bxc05)
               RETURNING g_cnt,g_imf04,g_imf05
          IF g_imf04 IS NULL THEN LET g_imf04=0 END IF
          CALL s_lwyn(g_bxc[l_ac].bxc04,g_bxc[l_ac].bxc05)
               RETURNING sn1,sn2    #可用否
          IF sn2 = 2 THEN
             IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF
          ELSE
             IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF
          END IF
          LET sn1=0 LET sn2=0
       ELSE
          LET g_bxc[l_ac].bxc05 = ' '
       END IF
       LET g_bxc_o.bxc05=g_bxc[l_ac].bxc05
 
    AFTER FIELD bxc06   #運回原料批號
       IF cl_null(g_bxc[l_ac].bxc06) THEN
          LET g_bxc[l_ac].bxc06 = ' '
       END IF  
       LET g_bxc_o.bxc06 = g_bxc[l_ac].bxc06
 
    AFTER FIELD bxc10   #下腳及廢料運回數量
       IF NOT cl_null(g_bxc[l_ac].bxc10) THEN
          IF g_bxc[l_ac].bxc10 < 0 THEN
             CALL cl_err('','mfg5034',0)
             LET g_bxc[l_ac].bxc10 = g_bxc_o.bxc10
             DISPLAY BY NAME g_bxc[l_ac].bxc10
             NEXT FIELD bxc10          
          END IF
       END IF
 
    BEFORE FIELD bxc12   #default 上一筆庫別代號
       IF cl_null(g_bxc[l_ac].bxc12) THEN
          IF l_ac > 1 THEN
             LET g_bxc[l_ac].bxc12 = g_bxc[l_ac-1].bxc12
             DISPLAY BY NAME g_bxc[l_ac].bxc12
          END IF
       END IF
 
    AFTER FIELD bxc12   #下腳料及廢料入庫庫別
       IF NOT cl_null(g_bxc[l_ac].bxc12) THEN
          #No.FUN-AA0049--begin
          IF NOT s_chk_ware(g_bxc[l_ac].bxc12) THEN
             NEXT FIELD bxc12
          END IF 
          #No.FUN-AA0049--end         
          #------>check    運回回原料庫別不可和下腳料庫別相同
          IF NOT cl_null(g_bxc[l_ac].bxc04) AND
             NOT cl_null(g_bxc[l_ac].bxc12) THEN
             IF g_bxc[l_ac].bxc04 = g_bxc[l_ac].bxc12 THEN
                CALL cl_err(g_bxc[l_ac].bxc12,'abx-040',0)
                NEXT FIELD bxc12
             END IF
          END IF
          #------>check-1  檢查該料是否可收至該倉
          IF NOT s_imfchk1(g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc12) THEN
             LET g_bxc[l_ac].bxc12=g_bxc_o.bxc12
             CALL cl_err('s_imfchk1:','mfg9036',0)
             NEXT FIELD bxc12
          END IF
          #------>check-2  檢查倉庫須存在否
          CALL s_stkchk(g_bxc[l_ac].bxc12,'A') RETURNING l_code
          IF NOT l_code THEN
             LET g_bxc[l_ac].bxc12=g_bxc_o.bxc12
             CALL cl_err('s_stkchk:','mfg1100',0)
             NEXT FIELD bxc12
          END IF
         #------>check-3  檢查是否為可用倉
          CALL s_swyn(g_bxc[l_ac].bxc12) RETURNING sn1,sn2
          IF sn1=1 AND g_bxc[l_ac].bxc12 != g_bxc_t.bxc12 THEN
             LET g_bxc[l_ac].bxc12=g_bxc_o.bxc12
             CALL cl_err(g_bxc[l_ac].bxc12,'mfg6080',0)
             NEXT FIELD bxc12
          ELSE
             IF sn2=2 AND g_bxc[l_ac].bxc12 != g_bxc_t.bxc12 THEN
                LET g_bxc[l_ac].bxc12=g_bxc_o.bxc12
                CALL cl_err(g_bxc[l_ac].bxc12,'mfg6085',0)
                NEXT FIELD bxc12
             END IF
          END IF
          LET sn1=0 LET sn2=0    
       ELSE
          #若下腳料數量大於0 倉庫不可空白
          IF NOT cl_null(g_bxc[l_ac].bxc10) AND 
             g_bxc[l_ac].bxc10 > 0 THEN
             CALL cl_err('','abx-041',0)
             NEXT FIELD bxc12
          END IF
       END IF
       LET g_bxc_o.bxc12 = g_bxc[l_ac].bxc12
 
    AFTER FIELD bxc13          #下腳料及廢料儲位
       IF NOT cl_null(g_bxc[l_ac].bxc13) THEN
          #------>check-1  檢查該料是否可收至該倉/儲位
          IF NOT s_imfchk(g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc12,
                          g_bxc[l_ac].bxc13) THEN
             LET g_bxc[l_ac].bxc13=g_bxc_o.bxc13
             CALL cl_err(g_bxc[l_ac].bxc13,'mfg6095',0)
             NEXT FIELD bxc13
          END IF
          #------>check-2  檢查該倉庫/儲位是否存在
          CALL s_hqty(g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc12,
                      g_bxc[l_ac].bxc13)
               RETURNING g_cnt,g_imf04,g_imf05
          IF g_imf04 IS NULL THEN LET g_imf04=0 END IF
          CALL s_lwyn(g_bxc[l_ac].bxc12,g_bxc[l_ac].bxc13)
               RETURNING sn1,sn2    #可用否
          IF sn2 = 2 THEN
             IF g_pmn38 = 'Y' THEN CALL cl_err('','mfg9132',0) END IF
          ELSE
             IF g_pmn38 = 'N' THEN CALL cl_err('','mfg9131',0) END IF
          END IF
          LET sn1=0 LET sn2=0
       ELSE
          LET g_bxc[l_ac].bxc13 = ' '
       END IF
       LET g_bxc_o.bxc13=g_bxc[l_ac].bxc13
 
    AFTER FIELD bxc14   #下腳料及廢料批號
       IF cl_null(g_bxc[l_ac].bxc14) THEN
          LET g_bxc[l_ac].bxc14 = ' '
       END IF  
       LET g_bxc_o.bxc14 = g_bxc[l_ac].bxc14
 
        #No.FUN-840202 --start--
        AFTER FIELD bxcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bxcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
    ON ROW CHANGE
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_bxc[l_ac].* = g_bxc_t.*
          CLOSE t100_bcl
          ROLLBACK WORK
          EXIT INPUT
       END IF
       #------>check    運回回原料庫別不可和下腳料庫別相同
       IF NOT cl_null(g_bxc[l_ac].bxc04) AND
          NOT cl_null(g_bxc[l_ac].bxc12) THEN
          IF g_bxc[l_ac].bxc04 = g_bxc[l_ac].bxc12 THEN
             CALL cl_err(g_bxc[l_ac].bxc12,'abx-040',0)
             NEXT FIELD bxc12
          END IF
       END IF
       #若下腳料數量大於0 倉庫不可空白
       IF NOT cl_null(g_bxc[l_ac].bxc10) AND
          cl_null(g_bxc[l_ac].bxc12) AND
          g_bxc[l_ac].bxc10 > 0 THEN
          CALL cl_err('','abx-041',0)
          NEXT FIELD bxc12
       END IF
       IF l_lock_sw = 'Y' THEN 
          CALL cl_err(g_bxc[l_ac].bxc02,-263,1)
          LET g_bxc[l_ac].* = g_bxc_t.*
       ELSE
          UPDATE bxc_file SET bxc02 = g_bxc[l_ac].bxc02,
                                 bxc04 = g_bxc[l_ac].bxc04,
                                 bxc05 = g_bxc[l_ac].bxc05,
                                 bxc06 = g_bxc[l_ac].bxc06,
                                 bxc07 = g_bxc[l_ac].bxc07,
                                 bxc08 = g_bxc[l_ac].bxc08,
                                 bxc09 = g_bxc[l_ac].bxc09,
                                 bxc10 = g_bxc[l_ac].bxc10,
                                 bxc11 = g_bxc[l_ac].bxc11,
                                 bxc12 = g_bxc[l_ac].bxc12,
                                 bxc13 = g_bxc[l_ac].bxc13,
                                 bxc14 = g_bxc[l_ac].bxc14,
                                 bxc15 = g_bxc[l_ac].bxc15,
                                #FUN-840202 --start--
                                bxcud01 = g_bxc[l_ac].bxcud01,
                                bxcud02 = g_bxc[l_ac].bxcud02,
                                bxcud03 = g_bxc[l_ac].bxcud03,
                                bxcud04 = g_bxc[l_ac].bxcud04,
                                bxcud05 = g_bxc[l_ac].bxcud05,
                                bxcud06 = g_bxc[l_ac].bxcud06,
                                bxcud07 = g_bxc[l_ac].bxcud07,
                                bxcud08 = g_bxc[l_ac].bxcud08,
                                bxcud09 = g_bxc[l_ac].bxcud09,
                                bxcud10 = g_bxc[l_ac].bxcud10,
                                bxcud11 = g_bxc[l_ac].bxcud11,
                                bxcud12 = g_bxc[l_ac].bxcud12,
                                bxcud13 = g_bxc[l_ac].bxcud13,
                                bxcud14 = g_bxc[l_ac].bxcud14,
                                bxcud15 = g_bxc[l_ac].bxcud15
                                #FUN-840202 --end-- 
           WHERE bxc01 = g_bxb.bxb01 AND bxc02 = g_bxc_t.bxc02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err(g_bxc[l_ac].bxc02,SQLCA.sqlcode,0)
             LET g_bxc[l_ac].* = g_bxc_t.*
             ROLLBACK WORK
          ELSE
             MESSAGE 'UPDATE O.K '
             COMMIT WORK
          END IF
       END IF
 
    BEFORE DELETE
       IF NOT cl_delb(0,0) THEN
          CANCEL DELETE
       END IF
       IF l_lock_sw = "Y" THEN
          CALL cl_err("", -263, 1)
          CANCEL DELETE
       END IF
       DELETE FROM bxc_file WHERE bxc01 = g_bxb.bxb01 
          AND bxc02 = g_bxc_t.bxc02
 
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err(g_bxc_t.bxc02,SQLCA.sqlcode,0)
          ROLLBACK WORK
          CANCEL DELETE
       END IF
       LET g_rec_b=g_rec_b-1
       DISPLAY g_rec_b TO FORMONLY.cn2
       COMMIT WORK
 
    AFTER ROW
       LET l_ac = ARR_CURR()
       LET l_ac_t = l_ac
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd = 'u' THEN
             LET g_bxc[l_ac].* = g_bxc_t.*
          END IF
          CLOSE t100_bcl
          ROLLBACK WORK
          EXIT INPUT
       END IF
       CLOSE t100_bcl
       COMMIT WORK
 
    ON ACTION controlp
       CASE
           WHEN INFIELD(bxc04) OR INFIELD(bxc05) OR INFIELD(bxc06)
                CALL q_img4(FALSE,FALSE,
                            g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc04,
                            g_bxc[l_ac].bxc05,g_bxc[l_ac].bxc06,'A')
                     RETURNING g_bxc[l_ac].bxc04,g_bxc[l_ac].bxc05,
                               g_bxc[l_ac].bxc06
                DISPLAY BY NAME g_bxc[l_ac].bxc04,g_bxc[l_ac].bxc05,
                                g_bxc[l_ac].bxc06
                IF INFIELD(bxc04) THEN NEXT FIELD bxc04 END IF
                IF INFIELD(bxc05) THEN NEXT FIELD bxc05 END IF
                IF INFIELD(bxc06) THEN NEXT FIELD bxc06 END IF
           WHEN INFIELD(bxc12) OR INFIELD(bxc13) OR INFIELD(bxc14)
                CALL q_img4(FALSE,FALSE,
                            g_bxc[l_ac].bxc03,g_bxc[l_ac].bxc12,
                            g_bxc[l_ac].bxc13,g_bxc[l_ac].bxc14,'A')
                     RETURNING g_bxc[l_ac].bxc12,g_bxc[l_ac].bxc13,
                               g_bxc[l_ac].bxc14
                DISPLAY BY NAME g_bxc[l_ac].bxc12,g_bxc[l_ac].bxc13,
                                g_bxc[l_ac].bxc14
                IF INFIELD(bxc12) THEN NEXT FIELD bxc12 END IF
                IF INFIELD(bxc13) THEN NEXT FIELD bxc13 END IF
                IF INFIELD(bxc14) THEN NEXT FIELD bxc14 END IF
           OTHERWISE EXIT CASE
       END CASE	
 
    ON ACTION CONTROLA  #查預設倉庫/儲位
       CASE
           WHEN INFIELD(bxc04)   #未加工運回原料入庫庫別
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imf"
                IF cl_null(g_bxc[l_ac].bxc03) THEN
                   LET g_qryparam.arg1 = " "
                ELSE
                   LET g_qryparam.arg1 = g_bxc[l_ac].bxc03
                END IF
                LET g_qryparam.default1 = g_bxc[l_ac].bxc04,
                                          g_bxc[l_ac].bxc05
                CALL cl_create_qry() RETURNING g_bxc[l_ac].bxc04,
                                               g_bxc[l_ac].bxc05
                NEXT FIELD bxc04
           WHEN INFIELD(bxc12)   #下腳料及廢料入庫庫別
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_imf"
                IF cl_null(g_bxc[l_ac].bxc03) THEN
                   LET g_qryparam.arg1 = " "
                ELSE
                   LET g_qryparam.arg1 = g_bxc[l_ac].bxc03
                END IF
                LET g_qryparam.default1 = g_bxc[l_ac].bxc12,
                                          g_bxc[l_ac].bxc13
                CALL cl_create_qry() RETURNING g_bxc[l_ac].bxc12,
                                               g_bxc[l_ac].bxc13
                NEXT FIELD bxc04
           OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLB  #建立倉庫/儲位
       CASE
           WHEN INFIELD(bxc04)   #未加工運回原料入庫庫別
                CALL cl_cmdrun("aimi200")
                NEXT FIELD bxc04
           WHEN INFIELD(bxc05)   #運回原料儲位
                CALL cl_cmdrun("aimi201")
                NEXT FIELD bxc05
           WHEN INFIELD(bxc12)   #下腳料及廢料入庫庫別
                CALL cl_cmdrun("aimi200")
                NEXT FIELD bxc12
           WHEN INFIELD(bxc13)   #下腳料及廢料儲位
                CALL cl_cmdrun("aimi201")
                NEXT FIELD bxc13
           OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLC  #查倉庫別/儲位別
       CASE
           WHEN INFIELD(bxc04)   #未加工運回原料入庫庫別
                #No.FUN-AA0049--begin
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_imd02"
                #LET g_qryparam.default1 = g_bxc[l_ac].bxc04
                #CALL cl_create_qry() RETURNING g_bxc[l_ac].bxc04
                CALL q_imd_1(FALSE,TRUE,g_bxc[l_ac].bxc04,"","","","") RETURNING g_bxc[l_ac].bxc04
                #No.FUN-AA0049--end
                NEXT FIELD bxc04
           WHEN INFIELD(bxc05)   #運回原料儲位
                #No.FUN-AB0058  --Begin
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_ime01"
                #IF cl_null(g_bxc[l_ac].bxc04) THEN
                  #LET g_qryparam.arg1 = " "
                 # CALL q_ime_1(FALSE,TRUE,g_bxc[l_ac].bxc05,"","","","","","") RETURNING g_bxc[l_ac].bxc05
                #ELSE
                  #LET g_qryparam.arg1 = g_bxc[l_ac].bxc04 
                  CALL q_ime_1(FALSE,TRUE,g_bxc[l_ac].bxc05,g_bxc[l_ac].bxc04,"","","","","") RETURNING g_bxc[l_ac].bxc05
                #END IF
                #LET g_qryparam.default1 = g_bxc[l_ac].bxc05
                #CALL cl_create_qry() RETURNING g_bxc[l_ac].bxc05
                #No.FUN-AB0058  --End
                NEXT FIELD bxc05
           WHEN INFIELD(bxc12)   #下腳料及廢料入庫庫別
                #No.FUN-AA0049--begin
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_imd02"
                #LET g_qryparam.default1 = g_bxc[l_ac].bxc12
                #CALL cl_create_qry() RETURNING g_bxc[l_ac].bxc12
                CALL q_imd_1(FALSE,TRUE,g_bxc[l_ac].bxc12,"","","","") RETURNING g_bxc[l_ac].bxc12
                #No.FUN-AA0049--end
                NEXT FIELD bxc12
           WHEN INFIELD(bxc13)   #下腳料及廢料儲位
                #No.FUN-AB0058  --Begin
                #CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_ime01"
                #IF cl_null(g_bxc[l_ac].bxc12) THEN
                  #LET g_qryparam.arg1 = " "
                 # CALL q_ime_1(FALSE,TRUE,g_bxc[l_ac].bxc13,"","","","","","") RETURNING g_bxc[l_ac].bxc13
                #ELSE
                  # LET g_qryparam.arg1 = g_bxc[l_ac].bxc12 
                  CALL q_ime_1(FALSE,TRUE,g_bxc[l_ac].bxc13,g_bxc[l_ac].bxc12,"","","","","") RETURNING g_bxc[l_ac].bxc13
                #END IF
                #LET g_qryparam.default1 = g_bxc[l_ac].bxc13
                #CALL cl_create_qry() RETURNING g_bxc[l_ac].bxc13
                #No.FUN-AB0058  --End
                NEXT FIELD bxc13
           OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about
       CALL cl_about()
 
    ON ACTION help
       CALL cl_show_help()
 
    ON ACTION controls                       #No.FUN-6B0033
       CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033 
 
  END INPUT
  CLOSE t100_bcl
  COMMIT WORK
  CALL t100_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t100_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_bxb.bxb01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM bxb_file ",
                  "  WHERE bxb01 LIKE '",l_slip,"%' ",
                  "    AND bxb01 > '",g_bxb.bxb01,"'"
      PREPARE t100_pb1 FROM l_sql 
      EXECUTE t100_pb1 INTO l_cnt  
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         #CALL t100_x() #FUN-D20025 mark
         CALL t100_x(1) #FUN-D20025 add
         CALL t100_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM bxb_file WHERE bxb01 = g_bxb.bxb01
         INITIALIZE g_bxb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t100_b_fill(p_wc2)
 
  DEFINE p_wc2 STRING
  LET g_sql = " SELECT bxc02,bxc03,'','','',bxc07, ",
              "        bxc08,bxc09,bxc11,bxc04, ",
              "        bxc05,bxc06,bxc10,bxc12, ",
              "        bxc13,bxc14,bxc15, ",
        #No.FUN-840202 --start--
              "       bxcud01,bxcud02,bxcud03,bxcud04,bxcud05,",
              "       bxcud06,bxcud07,bxcud08,bxcud09,bxcud10,",
              "       bxcud11,bxcud12,bxcud13,bxcud14,bxcud15", 
        #No.FUN-840202 ---end---
              " FROM bxc_file ",
              " WHERE bxc01 ='",g_bxb.bxb01,"'"
 
  IF NOT cl_null(p_wc2) THEN
     LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
  END IF
  LET g_sql=g_sql CLIPPED," ORDER BY bxc02,bxc03 "
 
  PREPARE t100_pb FROM g_sql
  DECLARE bxc_cs CURSOR FOR t100_pb
 
  CALL g_bxc.clear()
  LET g_cnt = 1
 
  FOREACH bxc_cs INTO g_bxc[g_cnt].*   #單身 ARRAY 填充
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    LET l_ac = g_cnt
    CALL t100_bxc03('d')
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  CALL g_bxc.deleteElement(g_cnt)
 
  LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cn2
  LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION t100_r()
  DEFINE l_n LIKE type_file.num5
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_bxb.bxb01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bxb.* FROM bxb_file WHERE bxb01=g_bxb.bxb01
   IF g_bxb.bxbconf ='Y' THEN    #檢查資料是否為已確認
      CALL cl_err(g_bxb.bxb01,'9021',0)
      RETURN
   END IF
   IF g_bxb.bxbconf ='X' THEN    #檢查資料是否為確認
      CALL cl_err(g_bxb.bxb01,'9021',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t100_cl USING g_bxb.bxb01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_bxb.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t100_show()
 
   IF cl_delh(0,0) THEN                   #確認一下 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bxb01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bxb.bxb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM bxb_file WHERE bxb01 = g_bxb.bxb01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
 
      DELETE FROM bxc_file WHERE bxc01 = g_bxb.bxb01
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
 
      CLEAR FORM
      INITIALIZE g_bxb.* TO NULL
      INITIALIZE g_bxb_o.* TO NULL
      INITIALIZE g_bxb_t.* TO NULL
      LET g_bxb01_t = NULL
      CALL g_bxc.clear()
      OPEN t100_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t100_cs
         CLOSE t100_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t100_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t100_cs
         CLOSE t100_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t100_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t100_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t100_fetch('/')
      END IF
   END IF      
 
   CLOSE t100_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t100_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,
          l_n     LIKE type_file.num5
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bxb01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1,
          l_n     LIKE type_file.num5
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bxb01",FALSE)
   END IF
 
END FUNCTION
 
#檢查部門代號
FUNCTION t100_bxb13(p_cmd)  
  DEFINE 
    l_gem02    LIKE gem_file.gem02,
    l_gemacti  LIKE gem_file.gemacti,
    p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti
  FROM gem_file WHERE gem01 = g_bxb.bxb13        
 
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039'
                                 LET l_gem02 = NULL
       WHEN l_gemacti= 'N' LET g_errno = 'asf-472'
       OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
 
END FUNCTION
 
#檢查員工代號
FUNCTION t100_bxb14(p_cmd)  
  DEFINE 
    l_gen02    LIKE gen_file.gen02,
    l_genacti  LIKE gen_file.genacti,
    p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
  FROM gen_file WHERE gen01 = g_bxb.bxb14        
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-053'
                                 LET l_gen02 = NULL
       WHEN l_genacti= 'N' LET g_errno = '9028'
       OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
 
END FUNCTION
 
#檢查加工廠商
FUNCTION t100_bxb03(p_cmd)  
  DEFINE 
    p_sfb82    LIKE sfb_file.sfb82,
    l_pmc03    LIKE pmc_file.pmc03,
    l_pmcacti  LIKE pmc_file.pmcacti,
    p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
  SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti 
    FROM pmc_file WHERE pmc01 = g_bxb.bxb03       
 
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-061'
       WHEN l_pmcacti != 'Y' LET g_errno = '9028'    
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    DISPLAY l_pmc03 TO FORMONLY.pmc03 
  END IF
END FUNCTION
 
#檢查工單單號
FUNCTION t100_bxb16(p_cmd)  
  DEFINE 
    l_sfb87    LIKE sfb_file.sfb87,
    p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
  
  SELECT sfb1001,sfb87
    INTO g_bxb.bxb18,l_sfb87
    FROM sfb_file
   WHERE sfb01 = g_bxb.bxb16
     AND sfb02 IN ('7','8')
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-318'
       WHEN l_sfb87 != 'Y'       LET g_errno = 'asf-104'    
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF NOT cl_null(g_errno) THEN
     LET g_bxb.bxb18 = NULL
  END IF
  DISPLAY BY NAME g_bxb.bxb18
END FUNCTION
 
#檢查委外入庫單號
FUNCTION t100_bxb04(p_cmd)  
  DEFINE  p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
  LET g_cnt = 0
  SELECT COUNT(*) INTO g_cnt FROM rvv_file,rvu_file
   WHERE rvu01 = g_bxb.bxb04
     AND rvu00 = 1 AND rvu08 = 'SUB'
     AND rvv18 =g_bxb.bxb16
     AND rvu01 = rvv01
  CASE 
       WHEN g_cnt=0     LET g_errno = 'abx-042' RETURN
       OTHERWISE        LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
#檢查委外入庫項次
FUNCTION t100_bxb05(p_cmd)  
  DEFINE p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
 
  SELECT rvu07,rvu06,rvv31,rvv17,rvv32,rvv33,rvv34
    INTO g_bxb.bxb14,g_bxb.bxb13,g_bxb.bxb06,
         g_bxb.bxb07,g_bxb.bxb10,g_bxb.bxb11,
         g_bxb.bxb12
    FROM rvu_file, rvv_file
   WHERE rvu01 = rvv01
     AND rvv01 = g_bxb.bxb04                          
     AND rvv02 = g_bxb.bxb05 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abx-043'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  CALL t100_ima()
  IF cl_null(g_errno) THEN
     CALL t100_bxb13('d')
     CALL t100_bxb14('d')
  END IF
END FUNCTION
 
FUNCTION t100_ima()  
  DEFINE l_ima02    LIKE ima_file.ima02,
         l_ima021   LIKE ima_file.ima021,
         l_ima55    LIKE ima_file.ima55
 
  SELECT ima02,ima021,ima55 INTO l_ima02,l_ima021,l_ima55
    FROM ima_file
   WHERE ima01 = g_bxb.bxb06
  DISPLAY BY NAME g_bxb.bxb14,g_bxb.bxb13,g_bxb.bxb06,
                  g_bxb.bxb07,g_bxb.bxb10,g_bxb.bxb11,
                  g_bxb.bxb12
  DISPLAY l_ima02  TO FORMONLY.ima02a
  DISPLAY l_ima021 TO FORMONLY.ima021a
  DISPLAY l_ima55  TO FORMONLY.ima55
  SELECT pmn38 INTO g_pmn38 FROM pmn_file,rvv_file
   WHERE pmn01 = rvv36 AND pmn02 = rvv37
     AND rvv01 = g_bxb.bxb04
     AND rvv02 = g_bxb.bxb05
END FUNCTION
 
#工單單號
FUNCTION t100_bxb16_gen()
  DEFINE l_sfa03 LIKE sfa_file.sfa03,
         l_sfa161 LIKE sfa_file.sfa161,
         l_cnt           LIKE type_file.num5
 
  #若工單單號(bxb16)不為空白,則當單頭輸入完後移至單身時,
  #做工單備料檔(sfa_file)展開 關連 
  #廠外加工進廠單頭檔.工單單號(bxb16) *= 工單備料檔.工單編號(sfa01)
  
  LET g_cnt=0
  SELECT count(*) INTO g_cnt FROM sfa_file
   WHERE sfa01 = g_bxb.bxb16
 
  IF g_cnt IS NOT NULL AND g_cnt > 0 THEN
     LET g_sql = "SELECT sfa03,sfa161 FROM sfa_file ",
                 " WHERE sfa01 = '",g_bxb.bxb16,"'"
     PREPARE t100_pqty1 FROM g_sql
     DECLARE t100_qty_cs1 CURSOR FOR t100_pqty1
     LET l_cnt=0
     display 'l_cnt=',l_cnt
     FOREACH t100_qty_cs1 INTO l_sfa03,l_sfa161
       IF SQLCA.SQLCODE THEN
          CALL cl_err('FOREACH t100_qty_cs1:',SQLCA.SQLCODE,1)
          RETURN 1
       END IF
       LET l_cnt = l_cnt + 1
       display 'l_cnt=',l_cnt
       INSERT INTO bxc_file (bxc01,bxc02,bxc03,bxc04,
                                bxc05,bxc06,bxc07,bxc08,
                                bxc09,bxc10,bxc11,bxc12,
                                bxc13,bxc14,bxc15,
                                bxcplant,bxclegal)  #FUN-980001 add
       VALUES(g_bxb.bxb01,l_cnt,l_sfa03,' ',' ',' ',l_sfa161,
              0,0,0,0,' ',' ',' ',' ',
              g_plant,g_legal)  #FUN-980001 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,1)
          RETURN 1
       END IF
     END FOREACH
  END IF
  LET g_rec_b = l_cnt
  RETURN 0
  #RETURN 0 表示無error, 1 表示有error
END FUNCTION
 
#確認者
FUNCTION t100_bxb09()
  DEFINE l_zx02 LIKE zx_file.zx02
 
  SELECT zx02 INTO l_zx02 FROM zx_file WHERE zx01=g_bxb.bxb09
  DISPLAY l_zx02 TO zx02
 
END FUNCTION
 
#檢查品號
FUNCTION t100_bxc03(p_cmd)  
  DEFINE p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
 
  SELECT ima02,ima021,ima63 
    INTO g_bxc[l_ac].ima02,g_bxc[l_ac].ima021,g_bxc[l_ac].ima63
    FROM ima_file
   WHERE ima01=g_bxc[l_ac].bxc03
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0016'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
END FUNCTION
 
#確認
FUNCTION t100_y()
   LET g_success = 'Y'   #No.FUN-AB0058
#CHI-C30107 ------- add ------- begin
   IF cl_null(g_bxb.bxb01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #已確認資料不可確認
   IF g_bxb.bxbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_bxb.bxbconf = 'X' THEN CALL cl_err('',9022,0) RETURN END IF

   IF NOT cl_confirm('axm-108') THEN RETURN END IF 
#CHI-C30107 ------- add ------- end
   IF cl_null(g_bxb.bxb01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bxb.* FROM bxb_file WHERE bxb01=g_bxb.bxb01
   #已確認資料不可確認
   IF g_bxb.bxbconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_bxb.bxbconf = 'X' THEN CALL cl_err('',9022,0) RETURN END IF
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   #No.FUN-AB0058  --Begin
   IF NOT s_chk_ware(g_bxb.bxb10) THEN
      LET g_success='N'
      RETURN
   END IF 
   #No.FUN-AB0058  --End 
   BEGIN WORK
 
   OPEN t100_cl USING g_bxb.bxb01
   IF STATUS THEN
      LET g_success='N'    #No.FUN-AB0058
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_bxb.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'   #No.FUN-AB0058
      CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   #No.FUN-AB0058  --Begin
   DECLARE t100_y_c2 CURSOR FOR
      SELECT * FROM bxc_file WHERE bxc01=g_bxb.bxb01
   FOREACH t100_y_c2 INTO b_bxc.*
     IF SQLCA.sqlcode THEN
        LET g_showmsg = g_bxb.bxb01,'t100_y_c2 foreach:'
        CALL s_errmsg('bxb01',g_bxb.bxb01,g_showmsg,SQLCA.sqlcode,1)
        LET g_success='N'
     END IF
     IF NOT cl_null(b_bxc.bxc04) THEN 
        IF NOT s_chk_ware(b_bxc.bxc04) THEN  #检查仓库是否属于当前门店
           LET g_success='N'
        END IF
     END IF
     IF NOT cl_null(b_bxc.bxc12) THEN 
       IF NOT s_chk_ware(b_bxc.bxc12) THEN  #检查仓库是否属于当前门店
           LET g_success='N'
        END IF
     END IF  
     IF g_success='N' THEN
        CLOSE t100_y_c2
        RETURN
     END IF 
   END FOREACH
   #No.FUN-AB0058  --End
   LET g_bxb_t.* = g_bxb.*   #備份值
   LET g_bxb.bxb09 = g_user
   LET g_bxb.bxbconf = 'Y'
   CALL t100_bxb09()
   LET g_bxb.bxbmodu = g_user
   LET g_bxb.bxbdate = g_today   
   UPDATE bxb_file set bxb09 = g_bxb.bxb09,
                          bxbconf = g_bxb.bxbconf,
                          bxbmodu = g_bxb.bxbmodu,
                          bxbdate = g_bxb.bxbdate
    WHERE bxb01=g_bxb.bxb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success='N'  #No.FUN-AB0058
      CALL cl_err('',SQLCA.sqlcode,1)
      LET g_bxb.* = g_bxb_t.*
      CLOSE t100_cl
      ROLLBACK WORK
   END IF
   #No.FUN-AB0058  --Begin
   IF g_success='Y' THEN           
       DISPLAY BY NAME g_bxb.bxb09  ,g_bxb.bxbconf,
                       g_bxb.bxbmodu,g_bxb.bxbdate
       COMMIT WORK                 
       MESSAGE 'CONFIRM O.K '                       
   END IF                          
   CLOSE t100_cl                   
   #COMMIT WORK                
   #MESSAGE 'CONFIRM O.K '
   #No.FUN-AB0058  --End
END FUNCTION
 
#取消確認
FUNCTION t100_z()
 
   IF cl_null(g_bxb.bxb01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bxb.* FROM bxb_file WHERE bxb01=g_bxb.bxb01
   #非確認資料不可取消確認
   IF g_bxb.bxbconf = 'N' THEN CALL cl_err('',9002,0) RETURN END IF
   IF g_bxb.bxbconf = 'X' THEN CALL cl_err('',9022,0) RETURN END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   OPEN t100_cl USING g_bxb.bxb01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_bxb.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_bxb_t.* = g_bxb.*   #備份值
  #LET g_bxb.bxb09=''         #CHI-C80072 mark 
   LET g_bxb.bxb09=g_user     #CHI-C80072 add     
   LET g_bxb.bxbconf='N'
   CALL t100_bxb09()
   LET g_bxb.bxbmodu = g_user
   LET g_bxb.bxbdate = g_today
 
   UPDATE bxb_file set bxb09 = g_bxb.bxb09,
                          bxbconf = g_bxb.bxbconf,
                          bxbmodu = g_bxb.bxbmodu,
                          bxbdate = g_bxb.bxbdate
    WHERE bxb01=g_bxb.bxb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      LET g_bxb.* = g_bxb_t.*
      CLOSE t100_cl
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_bxb.bxb09  ,g_bxb.bxbconf,
                   g_bxb.bxbmodu,g_bxb.bxbdate
   CLOSE t100_cl
   COMMIT WORK
   MESSAGE 'UNDO-CONFIRM O.K '
END FUNCTION
 
#作廢
#FUNCTION t100_x()  #FUN-D20025 mark
FUNCTION t100_x(p_type)  #FUN-D20025 add

   DEFINE l_void    LIKE type_file.chr1  #y=要作廢，n=取消作廢
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add
   IF cl_null(g_bxb.bxb01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bxb.* FROM bxb_file WHERE bxb01=g_bxb.bxb01
   #已確認資料不可作廢
   IF g_bxb.bxbconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
  #FUN-D20025---begin 
  IF p_type = 1 THEN 
     IF g_bxb.bxbconf='X' THEN RETURN END IF
  ELSE
     IF g_bxb.bxbconf<>'X' THEN RETURN END IF
  END IF 
  #FUN-D20025---end     
   IF g_bxb.bxbconf = 'X' THEN 
      LET l_void='Y'
   ELSE 
      LET l_void='N' 
   END IF
 
   BEGIN WORK
 
   OPEN t100_cl USING g_bxb.bxb01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t100_cl INTO g_bxb.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bxb.bxb01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_bxb_t.* = g_bxb.*   #備份值
   LET g_success = 'Y'
 
   IF cl_void(0,0,l_void) THEN 
      IF g_bxb.bxbconf = 'N' THEN
         LET g_bxb.bxbconf = 'X'    
      ELSE
         LET g_bxb.bxbconf = 'N'
      END IF
   END IF
   LET g_bxb.bxbmodu = g_user
   LET g_bxb.bxbdate = g_today
 
   UPDATE bxb_file set bxbconf = g_bxb.bxbconf,
                          bxbmodu = g_bxb.bxbmodu,
                          bxbdate = g_bxb.bxbdate
    WHERE bxb01=g_bxb.bxb01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)  #顯示 COMMIT WORK 訊息
   ELSE
      ROLLBACK WORK
      LET g_bxb.* = g_bxb_t.*
      CALL cl_rbmsg(4)  #顯示 ROLLBACK WORK 訊息
   END IF
   DISPLAY BY NAME g_bxb.bxb09  ,g_bxb.bxbconf,
                   g_bxb.bxbmodu,g_bxb.bxbdate
   CLOSE t100_cl
END FUNCTION
 
FUNCTION t100_pic()
   DEFINE l_void LIKE type_file.chr1
   #IF g_bxb.bxbconf = 'X' THEN     #FUN-AB0058 mark
   IF g_bxb.bxbconf = 'X' AND g_success='Y' THEN  #FUN-AB0058 add
      LET l_void = 'Y'
   ELSE
      LET l_void = 'N'
   END IF
   CALL cl_set_field_pic(g_bxb.bxbconf,"","","",l_void,"")
END FUNCTION
