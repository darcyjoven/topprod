# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxi505.4gl
# Descriptions...: 保稅機器設備收回建立作業
# Date & Author..: 2006/10/13 By kim
# Modify.........: No.FUN-6A0058 06/10/19 By hongmei 將g_no_ask改為mi_no_ask
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能			
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/07 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-850089 08/05/16 By TSD.hoho 傳統報表轉Crystal Report
# Modify.........: No.FUN-890101 08/09/25 by Cockroach 21-->31 CR  
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0145 09/10/27 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ABX
# Modify.........: No:CHI-B10034 10/01/21 By Smapmin 取消確認時不清空確認人/確認日期
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 13/02/05 By bart 無單身刪除單頭
# Modify.........: No.FUN-D20025 13/02/20 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.CHI-C80072 12/03/27 By lujh 統一確認和取消確認時確認人員和確認日期的寫法
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_bzj         RECORD LIKE bzj_file.*,
  g_bzj_t       RECORD LIKE bzj_file.*,       #單頭備份
  g_bzj_o       RECORD LIKE bzj_file.*,       #單頭備份
  g_bzj01_t     LIKE bzj_file.bzj01,       #單頭key備份
  g_bzk         DYNAMIC ARRAY OF RECORD          #單身
     bzk02      LIKE bzk_file.bzk02,       #項次
     bzk03      LIKE bzk_file.bzk03,       #外送單號
     bzk04      LIKE bzk_file.bzk04,       #外送單號－項次
     bzi03      LIKE bzi_file.bzi03,       #機器設備編號
     bzi04      LIKE bzi_file.bzi04,       #序號
     bza02      LIKE bza_file.bza02,       #機器設備中文名稱
     bza03      LIKE bza_file.bza03,       #機器設備英文名稱
     bza04      LIKE bza_file.bza04,       #機器設備規格
     bzb03      LIKE bzb_file.bzb03,       #保管部門代號
     gem02      LIKE gem_file.gem03,             #部門名稱
     bzb04      LIKE bzb_file.bzb04,       #保管人
     gen02      LIKE gen_file.gen02,             #人員名稱
     bzk05      LIKE bzk_file.bzk05,       #本次收回數量
     bzk06      LIKE bzk_file.bzk06        #備註
     #FUN-840202 --start---
     ,bzkud01   LIKE bzk_file.bzkud01,
     bzkud02    LIKE bzk_file.bzkud02,
     bzkud03    LIKE bzk_file.bzkud03,
     bzkud04    LIKE bzk_file.bzkud04,
     bzkud05    LIKE bzk_file.bzkud05,
     bzkud06    LIKE bzk_file.bzkud06,
     bzkud07    LIKE bzk_file.bzkud07,
     bzkud08    LIKE bzk_file.bzkud08,
     bzkud09    LIKE bzk_file.bzkud09,
     bzkud10    LIKE bzk_file.bzkud10,
     bzkud11    LIKE bzk_file.bzkud11,
     bzkud12    LIKE bzk_file.bzkud12,
     bzkud13    LIKE bzk_file.bzkud13,
     bzkud14    LIKE bzk_file.bzkud14,
     bzkud15    LIKE bzk_file.bzkud15
     #FUN-840202 --end--
                   END RECORD,
  g_bzk_t       RECORD                           #單身備份
     bzk02      LIKE bzk_file.bzk02,       #項次
     bzk03      LIKE bzk_file.bzk03,       #外送單號
     bzk04      LIKE bzk_file.bzk04,       #外送單號－項次
     bzi03      LIKE bzi_file.bzi03,       #機器設備編號
     bzi04      LIKE bzi_file.bzi04,       #序號
     bza02      LIKE bza_file.bza02,       #機器設備中文名稱
     bza03      LIKE bza_file.bza03,       #機器設備英文名稱
     bza04      LIKE bza_file.bza04,       #機器設備規格
     bzb03      LIKE bzb_file.bzb03,       #保管部門代號
     gem02      LIKE gem_file.gem03,             #部門名稱
     bzb04      LIKE bzb_file.bzb04,       #保管人
     gen02      LIKE gen_file.gen02,             #人員名稱
     bzk05      LIKE bzk_file.bzk05,       #本次收回數量
     bzk06      LIKE bzk_file.bzk06        #備註
     #FUN-840202 --start---
     ,bzkud01   LIKE bzk_file.bzkud01,
     bzkud02    LIKE bzk_file.bzkud02,
     bzkud03    LIKE bzk_file.bzkud03,
     bzkud04    LIKE bzk_file.bzkud04,
     bzkud05    LIKE bzk_file.bzkud05,
     bzkud06    LIKE bzk_file.bzkud06,
     bzkud07    LIKE bzk_file.bzkud07,
     bzkud08    LIKE bzk_file.bzkud08,
     bzkud09    LIKE bzk_file.bzkud09,
     bzkud10    LIKE bzk_file.bzkud10,
     bzkud11    LIKE bzk_file.bzkud11,
     bzkud12    LIKE bzk_file.bzkud12,
     bzkud13    LIKE bzk_file.bzkud13,
     bzkud14    LIKE bzk_file.bzkud14,
     bzkud15    LIKE bzk_file.bzkud15
     #FUN-840202 --end--
                   END RECORD,
  g_bzk_o       RECORD                           #單身備份
     bzk02      LIKE bzk_file.bzk02,       #項次
     bzk03      LIKE bzk_file.bzk03,       #外送單號
     bzk04      LIKE bzk_file.bzk04,       #外送單號－項次
     bzi03      LIKE bzi_file.bzi03,       #機器設備編號
     bzi04      LIKE bzi_file.bzi04,       #序號
     bza02      LIKE bza_file.bza02,       #機器設備中文名稱
     bza03      LIKE bza_file.bza03,       #機器設備英文名稱
     bza04      LIKE bza_file.bza04,       #機器設備規格
     bzb03      LIKE bzb_file.bzb03,       #保管部門代號
     gem02      LIKE gem_file.gem03,             #部門名稱
     bzb04      LIKE bzb_file.bzb04,       #保管人
     gen02      LIKE gen_file.gen02,             #人員名稱
     bzk05      LIKE bzk_file.bzk05,       #本次收回數量
     bzk06      LIKE bzk_file.bzk06        #備註
     #FUN-840202 --start---
     ,bzkud01   LIKE bzk_file.bzkud01,
     bzkud02    LIKE bzk_file.bzkud02,
     bzkud03    LIKE bzk_file.bzkud03,
     bzkud04    LIKE bzk_file.bzkud04,
     bzkud05    LIKE bzk_file.bzkud05,
     bzkud06    LIKE bzk_file.bzkud06,
     bzkud07    LIKE bzk_file.bzkud07,
     bzkud08    LIKE bzk_file.bzkud08,
     bzkud09    LIKE bzk_file.bzkud09,
     bzkud10    LIKE bzk_file.bzkud10,
     bzkud11    LIKE bzk_file.bzkud11,
     bzkud12    LIKE bzk_file.bzkud12,
     bzkud13    LIKE bzk_file.bzkud13,
     bzkud14    LIKE bzk_file.bzkud14,
     bzkud15    LIKE bzk_file.bzkud15
     #FUN-840202 --end--
                   END RECORD,
  g_wc,g_wc2       STRING,                 #sql字串
  g_sql            STRING,                 #sql字串
  g_rec_b          LIKE type_file.num5,                      #單身筆數
  l_ac             LIKE type_file.num5
 
DEFINE   p_row,p_col          LIKE type_file.num5
DEFINE   g_forupd_sql         STRING          #SELECT ... FOR UPDATE  SQL
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_cnt                LIKE type_file.num10
DEFINE   g_i                  LIKE type_file.num5             #count/index for any purpose
DEFINE   g_msg                LIKE type_file.chr1000
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_row_count          LIKE type_file.num10              #總筆數
DEFINE   g_jump               LIKE type_file.num10              #查詢指定的筆數
DEFINE   mi_no_ask            LIKE type_file.num5             #是否開啟指定筆視窗  #No.FUN-6A0058 g_no_ask
DEFINE   g_t1                 LIKE type_file.chr5           #單別判斷
 
DEFINE   l_table      STRING,    #FUN-850089 add
         g_str        STRING     #FUN-850089 add
 
MAIN
# DEFINE
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
#---FUN-850089 add ---start
 ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
  LET g_sql = "bzj01.bzj_file.bzj01,",
              "bzj02.bzj_file.bzj02,",
              "bzj03.bzj_file.bzj03,",
              "bzj04.bzj_file.bzj04,",
              "gen02a.gen_file.gen02,",      #人員名稱
              "bzj05.bzj_file.bzj05,",
              "bzj06.bzj_file.bzj06,",
              "bzk02.bzk_file.bzk02,",       #項次
              "bzk03.bzk_file.bzk03,",       #外送單號
              "bzk04.bzk_file.bzk04,",       #外送單號－項次
              "bzi03.bzi_file.bzi03,",       #機器設備編號
              "bzi04.bzi_file.bzi04,",       #序號
              "bza02.bza_file.bza02,",       #機器設備中文名稱
              "bza03.bza_file.bza03,",       #機器設備英文名稱
              "bza04.bza_file.bza04,",       #機器設備規格
              "bzb03.bzb_file.bzb03,",       #保管部門代號
              "gem02.gem_file.gem03,",       #部門名稱
              "bzb04.bzb_file.bzb04,",       #保管人
              "gen02b.gen_file.gen02,",      #人員名稱
              "bzk05.bzk_file.bzk05,",       #本次收回數量
              "bzk06.bzk_file.bzk06"         #備註
                                          #21 items
  LET l_table = cl_prt_temptable('abxi505',g_sql) CLIPPED   # 產生Temp Table
  IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
  LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
              "        ?,?,?,?,?, ?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1)
     EXIT PROGRAM
  END IF
 #------------------------------ CR (1) ------------------------------#
#---FUN-850089 add ---end
 
  #CALL cl_used('abxi505',g_time,1)  RETURNING g_time   #計算使用時間 (進入時間) #FUN-B30211
  CALL cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
  LET g_forupd_sql = "SELECT * FROM bzj_file WHERE bzj01 = ? FOR UPDATE"
 
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i505_cl CURSOR FROM g_forupd_sql
 
  LET p_row = 2 LET p_col = 9
 
  OPEN WINDOW i505_w AT p_row,p_col              #顯示畫面
       WITH FORM "abx/42f/abxi505" ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL i505_menu()
  CLOSE WINDOW i505_w                 #結束畫面
  #CALL cl_used('abxi505',g_time,2) RETURNING g_time  #計算使用時間 (退出時間) #FUN-B30211
  CALL cl_used(g_prog,g_time,2) RETURNING g_time  #計算使用時間 (進入時間)    #FUN-B30211
END MAIN
 
FUNCTION i505_menu()
  WHILE TRUE
    CALL i505_bp("G")
    CASE g_action_choice
         WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL i505_a()
              END IF
         WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL i505_q()
              END IF
         WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL i505_r()
              END IF
         WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL i505_u()
              END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i505_out()
            END IF
        WHEN "detail"
             IF cl_chk_act_auth() THEN
                CALL i505_b()
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
               CALL i505_y()
               CALL i505_pic()
            END IF
        WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i505_z()
               CALL i505_pic()
            END IF
        WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL i505_x() #FUN-D20025 mark
               CALL i505_x(1) #FUN-D20025 add
               CALL i505_pic()
            END IF
        #FUN-D20025 add
        WHEN "undo_void"          #"取消作廢"
           IF cl_chk_act_auth() THEN
              CALL i505_x(2)
              CALL i505_pic()
           END IF
        #FUN-D20025 add      
        WHEN "exporttoexcel"   
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bzk),'','')
        WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_bzj.bzj01 IS NOT NULL THEN
                LET g_doc.column1 = "bzj01"
                LET g_doc.value1 = g_bzj.bzj01
                CALL cl_doc()
             END IF
          END IF
    END CASE
  END WHILE
END FUNCTION
 
FUNCTION i505_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
 
  LET g_action_choice = " "
 
  CALL cl_set_act_visible("accept,cancel", FALSE)
  DISPLAY ARRAY g_bzk TO s_bzk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
    ON ACTION delete
       LET g_action_choice="delete"
       EXIT DISPLAY
    ON ACTION modify
       LET g_action_choice="modify"
       EXIT DISPLAY
    ON ACTION first
       CALL i505_fetch('F')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       CALL fgl_set_arr_curr(1)
    ON ACTION previous
       CALL i505_fetch('P')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       CALL fgl_set_arr_curr(1)
    ON ACTION jump
       CALL i505_fetch('/')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
    ON ACTION next
       CALL i505_fetch('N')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       CALL fgl_set_arr_curr(1)
    ON ACTION last
       CALL i505_fetch('L')
       CALL cl_navigator_setting(g_curs_index, g_row_count)
       CALL fgl_set_arr_curr(1)
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
       CALL i505_pic()
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
       LET g_action_choice="exit"
       EXIT DISPLAY
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE DISPLAY
    ON ACTION exporttoexcel       
       LET g_action_choice = 'exporttoexcel'
       EXIT DISPLAY
    ON ACTION about
       CALL cl_about()
#@    ON ACTION 相關文件
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
     
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i505_cs()
  DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
  CLEAR FORM                             #清除畫面
  CALL g_bzk.clear()
  CALL cl_set_head_visible("","YES")         #No.FUN-6B0033			
 
   INITIALIZE g_bzj.* TO NULL    #No.FUN-750051
  CONSTRUCT BY NAME g_wc ON bzj01,bzj02,bzj03,bzj04,bzj05,bzj06,
                            bzjuser,bzjgrup,bzjmodu,bzjdate,bzjacti
                            #FUN-840202   ---start---
                            ,bzjud01,bzjud02,bzjud03,bzjud04,bzjud05,
                            bzjud06,bzjud07,bzjud08,bzjud09,bzjud10,
                            bzjud11,bzjud12,bzjud13,bzjud14,bzjud15
                            #FUN-840202    ----end----
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION controlp
        CASE
         WHEN INFIELD(bzj01)                           #^P找單別資料 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_bzj01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bzj01
              NEXT FIELD bzj01
         WHEN INFIELD(bzj04)
              CALL cl_init_qry_var()             #^P找人員代號
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_gen"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bzj04
              NEXT FIELD bzj04
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bzjuser', 'bzjgrup') #FUN-980030
 
  IF INT_FLAG THEN RETURN END IF
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN
  #     LET g_wc = g_wc CLIPPED," AND bzjuser = '",g_user CLIPPED,"'"
  #  END IF
 
  #  IF g_priv3='4' THEN
  #     LET g_wc = g_wc CLIPPED," AND bzjgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  CONSTRUCT g_wc2 ON bzk02,bzk03,bzk04,bzk05,bzk06
                     #No.FUN-840202 --start--
                     ,bzkud01,bzkud02,bzkud03,bzkud04,bzkud05
                     ,bzkud06,bzkud07,bzkud08,bzkud09,bzkud10
                     ,bzkud11,bzkud12,bzkud13,bzkud14,bzkud15
                     #No.FUN-840202 ---end---
                FROM s_bzk[1].bzk02,s_bzk[1].bzk03,
                     s_bzk[1].bzk04,s_bzk[1].bzk05,
                     s_bzk[1].bzk06
                     #No.FUN-840202 --start--
                     ,s_bzk[1].bzkud01,s_bzk[1].bzkud02,s_bzk[1].bzkud03,s_bzk[1].bzkud04,s_bzk[1].bzkud05
                     ,s_bzk[1].bzkud06,s_bzk[1].bzkud07,s_bzk[1].bzkud08,s_bzk[1].bzkud09,s_bzk[1].bzkud10
                     ,s_bzk[1].bzkud11,s_bzk[1].bzkud12,s_bzk[1].bzkud13,s_bzk[1].bzkud14,s_bzk[1].bzkud15
                     #No.FUN-840202 ---end---
     BEFORE CONSTRUCT
        CALL cl_qbe_display_condition(lc_qbe_sn)
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
     LET g_sql = "SELECT  bzj01 FROM bzj_file ",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY bzj01"
  ELSE                              # 若單身有輸入條件
     LET g_sql = "SELECT UNIQUE bzj_file. bzj01 ",
                 "  FROM bzj_file, bzk_file ",
                 " WHERE bzj01 = bzk01",
                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY bzj01"
  END IF
 
  PREPARE i505_prepare FROM g_sql
  DECLARE i505_cs SCROLL CURSOR WITH HOLD FOR i505_prepare
 
  IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
     LET g_sql="SELECT COUNT(*) FROM bzj_file WHERE ",g_wc CLIPPED
  ELSE
     LET g_sql="SELECT COUNT(DISTINCT bzj01) FROM bzj_file,bzk_file WHERE ",
               "bzj01=bzk01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
  END IF
 
  PREPARE i505_precount FROM g_sql
  DECLARE i505_count CURSOR FOR i505_precount
 
END FUNCTION
 
FUNCTION i505_a()
  DEFINE li_result   LIKE type_file.num5
  
  MESSAGE ""
  CLEAR FORM
  CALL g_bzk.clear()
 
  IF s_shut(0) THEN
     RETURN
  END IF
 
  INITIALIZE g_bzj.* LIKE bzj_file.*             #DEFAULT 設定
  LET g_bzj01_t = NULL
 
  #預設值及將數值類變數清成零
  LET g_bzj_t.* = g_bzj.*
  LET g_bzj_o.* = g_bzj.*
  CALL cl_opmsg('a')
 
  WHILE TRUE
     LET g_bzj.bzjuser = g_user
     LET g_bzj.bzjgrup = g_grup
     LET g_bzj.bzjdate = g_today
     LET g_bzj.bzjacti = 'Y'              #資料有效
     LET g_bzj.bzj02 = g_today
     LET g_bzj.bzj06 = 'N'
 
    LET g_bzj.bzjplant = g_plant  #FUN-980001 add
    LET g_bzj.bzjlegal = g_legal  #FUN-980001 add
 
     CALL i505_i("a")                   #輸入單頭
 
     IF INT_FLAG THEN                   #使用者不玩了
        INITIALIZE g_bzj.* TO NULL
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
     END IF
 
     IF cl_null(g_bzj.bzj01) THEN       # KEY 不可空白
        CONTINUE WHILE
     END IF
 
     BEGIN WORK
 
     LET g_t1 = s_get_doc_no(g_bzj.bzj01)
     CALL s_auto_assign_no("abx",g_t1,g_bzj.bzj02,"B","bzj_file","bzj01","","","")
          RETURNING li_result,g_bzj.bzj01
     IF (NOT li_result) THEN
        CONTINUE WHILE
     END IF
     #進行輸入之單號檢查
     CALL s_mfgchno(g_bzj.bzj01) RETURNING g_i,g_bzj.bzj01
     DISPLAY BY NAME g_bzj.bzj01
     IF NOT g_i THEN CONTINUE WHILE END IF
 
     LET g_bzj.bzjoriu = g_user      #No.FUN-980030 10/01/04
     LET g_bzj.bzjorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO bzj_file VALUES (g_bzj.*)
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,1)    #No.FUN-B80082---調整至回滾事務前---
        ROLLBACK WORK      
        CONTINUE WHILE
     ELSE
        COMMIT WORK                 
     END IF
 
     SELECT bzj01 INTO g_bzj.bzj01 FROM bzj_file
      WHERE bzj01 = g_bzj.bzj01
     LET g_bzj01_t = g_bzj.bzj01        #保留舊值
     LET g_bzj_t.* = g_bzj.*
     LET g_bzj_o.* = g_bzj.*
     CALL g_bzk.clear()                 #清除單身資料
 
     LET g_rec_b = 0  
     CALL i505_b()                      #輸入單身
     EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION i505_i(p_cmd)
DEFINE
  li_result      LIKE type_file.num5,
  p_cmd          LIKE type_file.chr1                #a:輸入 u:更改
 
  IF s_shut(0) THEN RETURN END IF
  CALL cl_set_head_visible("","YES")         #No.FUN-6B0033			
 
  DISPLAY BY NAME g_bzj.bzj04,g_bzj.bzj05,g_bzj.bzj06
  INPUT BY NAME g_bzj.bzj01,g_bzj.bzj02,g_bzj.bzj03,
                g_bzj.bzjuser,g_bzj.bzjmodu,
                g_bzj.bzjgrup,g_bzj.bzjdate,g_bzj.bzjacti
                #FUN-840202     ---start---
                ,g_bzj.bzjud01,g_bzj.bzjud02,g_bzj.bzjud03,g_bzj.bzjud04,
                g_bzj.bzjud05,g_bzj.bzjud06,g_bzj.bzjud07,g_bzj.bzjud08,
                g_bzj.bzjud09,g_bzj.bzjud10,g_bzj.bzjud11,g_bzj.bzjud12,
                g_bzj.bzjud13,g_bzj.bzjud14,g_bzj.bzjud15 
                #FUN-840202     ----end----
 
                WITHOUT DEFAULTS
    BEFORE INPUT
       LET g_before_input_done = FALSE
       CALL i505_set_entry(p_cmd)
       CALL i505_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
 
    AFTER FIELD bzj01
       IF NOT cl_null(g_bzj.bzj01) THEN
          IF p_cmd = "a" OR (p_cmd = "u" AND g_bzj.bzj01 != g_bzj01_t) THEN  
#            CALL s_check_no(g_sys,g_bzj.bzj01,g_bzj01_t,"B","bzj_file","bzj01","")
             CALL s_check_no("abx",g_bzj.bzj01,g_bzj01_t,"B","bzj_file","bzj01","")   #No.FUN-A40041
                  RETURNING li_result,g_bzj.bzj01
             DISPLAY BY NAME g_bzj.bzj01
             IF (NOT li_result) THEN
                NEXT FIELD bzj01
             END IF
          END IF
       END IF
       LET g_bzj_o.bzj01=g_bzj.bzj01
 
        #FUN-840202     ---start---
        AFTER FIELD bzjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
    AFTER INPUT
       IF INT_FLAG THEN
          EXIT INPUT
       END IF
 
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
           WHEN INFIELD(bzj01)         
              LET g_t1 = s_get_doc_no(g_bzj.bzj01)
#             CALL q_bna(FALSE,TRUE,g_t1,'B',g_sys) RETURNING g_t1
              CALL q_bna(FALSE,TRUE,g_t1,'B','abx') RETURNING g_t1   #No.FUN-A40041
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
              END IF
              LET g_bzj.bzj01 = g_t1
              DISPLAY BY NAME g_bzj.bzj01
              NEXT FIELD bzj01
           OTHERWISE EXIT CASE
       END CASE	
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about
       CALL cl_about()
 
    ON ACTION help
       CALL cl_show_help()
  END INPUT
END FUNCTION
 
FUNCTION i505_u()
  IF s_shut(0) THEN RETURN END IF
 
  IF cl_null(g_bzj.bzj01) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  SELECT * INTO g_bzj.* FROM bzj_file WHERE bzj01=g_bzj.bzj01
 
  IF g_bzj.bzj06 ='Y' THEN    #檢查資料是否為已確認
     CALL cl_err(g_bzj.bzj01,'9022',0)
     RETURN
  END IF
 
  IF g_bzj.bzj06 ='X' THEN    #檢查資料是否為作廢
     CALL cl_err(g_bzj.bzj01,'9022',0)
     RETURN
  END IF
 
  MESSAGE ""
  CALL cl_opmsg('u')
  LET g_bzj01_t = g_bzj.bzj01
  BEGIN WORK
  OPEN i505_cl USING g_bzj.bzj01
  IF STATUS THEN
     CALL cl_err("OPEN i505_cl:", STATUS, 1)
     CLOSE i505_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH i505_cl INTO g_bzj.*                      # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)    # 資料被他人LOCK
      CLOSE i505_cl
      ROLLBACK WORK
      RETURN
  END IF
 
  CALL i505_show()
  WHILE TRUE
     LET g_bzj01_t = g_bzj.bzj01
     LET g_bzj_t.* = g_bzj.*
     LET g_bzj_o.* = g_bzj.*
     LET g_bzj.bzjmodu=g_user
     LET g_bzj.bzjdate=g_today
 
     CALL i505_i("u")                      #欄位更改
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        LET g_bzj.*=g_bzj_t.*
        CALL i505_show()
        CALL cl_err('','9001',0)
        EXIT WHILE
     END IF
 
     IF g_bzj.bzj01 != g_bzj01_t THEN            # 更改單號   
        UPDATE bzk_file SET bzk01 = g_bzj.bzj01
         WHERE bzk01 = g_bzj01_t
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('bzk_file',SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
     END IF
 
     UPDATE bzj_file SET bzj_file.* = g_bzj.*
     WHERE bzj01 = g_bzj01_t
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)
        CONTINUE WHILE
     END IF
     EXIT WHILE
  END WHILE
 
  CLOSE i505_cl
  COMMIT WORK
  CALL i505_pic()
END FUNCTION
 
FUNCTION i505_show()
  LET g_bzj_t.* = g_bzj.*                #保存單頭舊值
  LET g_bzj_o.* = g_bzj.*                #保存單頭舊值
  DISPLAY BY NAME g_bzj.bzj01,g_bzj.bzj02,g_bzj.bzj03,g_bzj.bzj04,
                  g_bzj.bzj05,g_bzj.bzj06,
                  g_bzj.bzjuser,g_bzj.bzjgrup,g_bzj.bzjmodu,
                  g_bzj.bzjdate,g_bzj.bzjacti
                  #FUN-840202     ---start---
                  ,g_bzj.bzjud01,g_bzj.bzjud02,g_bzj.bzjud03,g_bzj.bzjud04,
                  g_bzj.bzjud05,g_bzj.bzjud06,g_bzj.bzjud07,g_bzj.bzjud08,
                  g_bzj.bzjud09,g_bzj.bzjud10,g_bzj.bzjud11,g_bzj.bzjud12,
                  g_bzj.bzjud13,g_bzj.bzjud14,g_bzj.bzjud15 
                  #FUN-840202     ----end----
  CALL i505_bzj04('d')
  CALL i505_b_fill(g_wc2)                 #單身
  CALL i505_pic()
END FUNCTION
 
FUNCTION i505_q()
  LET g_row_count=0
  LET g_curs_index=0
  CALL cl_navigator_setting(g_curs_index,g_row_count)
  MESSAGE ""
  CALL cl_opmsg('q')
  CLEAR FORM
  INITIALIZE g_bzj.* TO NULL
  INITIALIZE g_bzj_o.* TO NULL
  INITIALIZE g_bzj_t.* TO NULL
  LET g_bzj01_t = NULL
  CALL g_bzk.clear()
  DISPLAY '' TO FORMONLY.cnt
  DISPLAY '' TO FORMONLY.cnt2
 
  CALL i505_cs()
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     INITIALIZE g_bzj.* TO NULL
     RETURN
  END IF
 
  OPEN i505_cs                            # 從DB產生合乎條件TEMP(0-30秒)
  IF SQLCA.sqlcode THEN
     CALL cl_err('',SQLCA.sqlcode,0)
     INITIALIZE g_bzj.* TO NULL
  ELSE
     OPEN i505_count
     FETCH i505_count INTO g_row_count
     DISPLAY g_row_count TO FORMONLY.cnt
     CALL i505_fetch('F')                  # 讀出TEMP第一筆並顯示
  END IF
END FUNCTION
 
FUNCTION i505_fetch(p_flag)
  DEFINE p_flag    LIKE type_file.chr1
 
  CASE p_flag
     WHEN 'N' FETCH NEXT     i505_cs INTO g_bzj.bzj01
     WHEN 'P' FETCH PREVIOUS i505_cs INTO g_bzj.bzj01
     WHEN 'F' FETCH FIRST    i505_cs INTO g_bzj.bzj01
     WHEN 'L' FETCH LAST     i505_cs INTO g_bzj.bzj01
     WHEN '/'
           IF (NOT mi_no_ask) THEN             #No.FUN-6A0058 g_no_ask
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
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
           END IF
           FETCH ABSOLUTE g_jump i505_cs INTO g_bzj.bzj01
           LET mi_no_ask = FALSE          #No.FUN-6A0058  g_no_ask
  END CASE
 
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)
     INITIALIZE g_bzj.* TO NULL
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
 
  SELECT * INTO g_bzj.* FROM bzj_file WHERE bzj01 = g_bzj.bzj01
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)
     INITIALIZE g_bzj.* TO NULL
     RETURN
  END IF
  CALL i505_show()
END FUNCTION
 
FUNCTION i505_b()
  DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重複用
    l_cnt           LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5               #可刪除否
 
  LET g_action_choice = ""
 
  IF s_shut(0) THEN RETURN END IF
 
  IF cl_null(g_bzj.bzj01) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  SELECT * INTO g_bzj.* FROM bzj_file WHERE bzj01=g_bzj.bzj01
 
  IF g_bzj.bzj06 ='Y' THEN    #檢查資料是否為已確認
     CALL cl_err(g_bzj.bzj01,'9022',0)
     RETURN
  END IF
 
  IF g_bzj.bzj06 ='X' THEN    #檢查資料是否為作廢
     CALL cl_err(g_bzj.bzj01,'9022',0)
     RETURN
  END IF
 
  CALL cl_opmsg('b')
 
  LET g_forupd_sql = "SELECT bzk02,bzk03,bzk04,'','','','','','', ",
                     "        '','','',bzk05,bzk06 ",
                     ",bzkud01,bzkud02,bzkud03,bzkud04,bzkud05,",
                     "bzkud06,bzkud07,bzkud08,bzkud09,bzkud10,",
                     "bzkud11,bzkud12,bzkud13,bzkud14,bzkud15",
                     "  FROM bzk_file ",
                     " WHERE bzk01=? and bzk02=? FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i505_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
  LET l_allow_insert = cl_detail_input_auth("insert")
  LET l_allow_delete = cl_detail_input_auth("delete")
 
  INPUT ARRAY g_bzk WITHOUT DEFAULTS FROM s_bzk.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                  APPEND ROW=l_allow_insert)
 
    BEFORE INPUT
      IF g_rec_b != 0 THEN CALL fgl_set_arr_curr(l_ac) END IF
 
    BEFORE ROW
      LET p_cmd = ''
      LET l_ac = ARR_CURR()
      LET l_lock_sw = 'N'
      LET l_n = ARR_COUNT()
 
      BEGIN WORK
 
      OPEN i505_cl USING g_bzj.bzj01
      IF STATUS THEN
         CALL cl_err("OPEN i505_cl:",STATUS,1)
         CLOSE i505_cl
         ROLLBACK WORK
         RETURN
      END IF 
 
      FETCH i505_cl INTO g_bzj.*
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)
         CLOSE i505_cl
         ROLLBACK WORK
         RETURN
      END IF
 
      IF g_rec_b >= l_ac THEN
         LET p_cmd = 'u'
         LET g_bzk_t.* = g_bzk[l_ac].*
         LET g_bzk_o.* = g_bzk[l_ac].*
         OPEN i505_bcl USING g_bzj.bzj01,g_bzk_t.bzk02
 
         IF STATUS THEN
            CALL cl_err("OPEN i505_bcl:",STATUS,1)
            LET l_lock_sw = "Y"
         ELSE
            FETCH i505_bcl INTO g_bzk[l_ac].*
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_bzk_t.bzk02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
            END IF           
            CALL i505_bzk04('d')
         END IF
      END IF
      CALL i505_set_entry_b()
      CALL i505_set_no_entry_b()
 
    BEFORE INSERT
      LET l_n = ARR_COUNT()
      LET p_cmd = 'a'
      INITIALIZE g_bzk[l_ac].* TO NULL
      LET g_bzk[l_ac].bzk05 = 0  
      LET g_bzk_t.* = g_bzk[l_ac].*
      LET g_bzk_o.* = g_bzk[l_ac].*
      NEXT FIELD bzk02
 
    AFTER INSERT
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         CANCEL INSERT
         CALL i505_show()
      END IF
      CALL i505_bzk04('a')
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_bzk[l_ac].bzk04,g_errno,0)
         CALL g_bzk.deleteElement(l_ac)
         CANCEL INSERT
      END IF
      CALL i505_bzk05(p_cmd)
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_bzk[l_ac].bzk05,g_errno,1)
         CALL g_bzk.deleteElement(l_ac)
         CANCEL INSERT
      END IF
      INSERT INTO bzk_file (bzk01,bzk02,bzk03,bzk04,bzk05,bzk06,
                            #FUN-840202 --start--
                            bzkud01,bzkud02,bzkud03,
                            bzkud04,bzkud05,bzkud06,
                            bzkud07,bzkud08,bzkud09,
                            bzkud10,bzkud11,bzkud12,
                            bzkud13,bzkud14,bzkud15,
                            #FUN-840202 --end--
                            bzkplant,bzklegal)  #FUN-980001 add
                       VALUES (g_bzj.bzj01,g_bzk[l_ac].bzk02,
                               g_bzk[l_ac].bzk03,g_bzk[l_ac].bzk04,
                               g_bzk[l_ac].bzk05,g_bzk[l_ac].bzk06,
                               #FUN-840202 --start--
                               g_bzk[l_ac].bzkud01,
                               g_bzk[l_ac].bzkud02,
                               g_bzk[l_ac].bzkud03,
                               g_bzk[l_ac].bzkud04,
                               g_bzk[l_ac].bzkud05,
                               g_bzk[l_ac].bzkud06,
                               g_bzk[l_ac].bzkud07,
                               g_bzk[l_ac].bzkud08,
                               g_bzk[l_ac].bzkud09,
                               g_bzk[l_ac].bzkud10,
                               g_bzk[l_ac].bzkud11,
                               g_bzk[l_ac].bzkud12,
                               g_bzk[l_ac].bzkud13,
                               g_bzk[l_ac].bzkud14,
                               g_bzk[l_ac].bzkud15,
                               #FUN-840202 --end--
                               g_plant,g_legal)  #FUN-980001 add
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_bzk[l_ac].bzk02,SQLCA.sqlcode,0)
         CANCEL INSERT
      ELSE
         MESSAGE 'INSERT O.K '
         COMMIT WORK
         LET g_rec_b = g_rec_b + 1
         DISPLAY g_rec_b TO FORMONLY.cnt2  
      END IF
 
    BEFORE FIELD bzk02
      IF cl_null(g_bzk[l_ac].bzk02) OR g_bzk[l_ac].bzk02 = 0 THEN
         SELECT MAX (bzk02) + 1 INTO g_bzk[l_ac].bzk02  #給預設值
           FROM bzk_file WHERE bzk01 = g_bzj.bzj01
         IF cl_null(g_bzk[l_ac].bzk02) THEN
            LET g_bzk[l_ac].bzk02 =1
         END IF
         LET g_bzk_o.bzk02 = g_bzk[l_ac].bzk02
      END IF
 
    AFTER FIELD bzk02
      IF NOT cl_null(g_bzk[l_ac].bzk02) THEN
         IF g_bzk[l_ac].bzk02 < 1 THEN
            CALL cl_err('','mfg1322',0)
            LET g_bzk[l_ac].bzk02 = g_bzk_o.bzk02
            DISPLAY BY NAME g_bzk[l_ac].bzk02
            NEXT FIELD bzk02
         END IF
         IF p_cmd = "a" OR 
           (p_cmd = "u" AND g_bzk[l_ac].bzk02 != g_bzk_t.bzk02) THEN
            LET l_n = 0
            SELECT count(*) INTO l_n FROM bzk_file        #檢查key值 
             WHERE bzk01 = g_bzj.bzj01
               AND bzk02 = g_bzk[l_ac].bzk02
            IF l_n IS NULL THEN LET l_n = 0 END IF
            IF l_n > 0 THEN 
               CALL cl_err('',-239,0)
               LET g_bzk[l_ac].bzk02 = g_bzk_o.bzk02
               DISPLAY BY NAME g_bzk[l_ac].bzk02
               NEXT FIELD bzk02
            END iF
         END IF
         LET g_bzk_o.bzk02 = g_bzk[l_ac].bzk02
      END IF
 
    BEFORE FIELD bzk03
      CALL i505_set_entry_b()
 
    AFTER FIELD bzk03
      IF NOT cl_null(g_bzk[l_ac].bzk03) THEN
         CALL i505_bzk03('a')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_bzk[l_ac].bzk03,g_errno,0)
            LET g_bzk[l_ac].bzk03 = g_bzk_o.bzk03
            NEXT FIELD bzk03
         END IF
      END IF
      LET g_bzk_o.bzk03 = g_bzk[l_ac].bzk03
      CALL i505_set_no_entry_b()
 
    BEFORE FIELD bzk04
      CALL i505_set_entry_b()
 
    AFTER FIELD bzk04
      IF NOT cl_null(g_bzk[l_ac].bzk04) THEN
         CALL i505_bzk04('a')
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_bzk[l_ac].bzk04,g_errno,0)
            LET g_bzk[l_ac].bzk04 = g_bzk_o.bzk04
            NEXT FIELD bzk04
         END IF
      END IF
      LET g_bzk_o.bzk04 = g_bzk[l_ac].bzk04
      CALL i505_set_no_entry_b()
 
    AFTER FIELD bzk05
      IF NOT cl_null(g_bzk[l_ac].bzk05) THEN
         CALL i505_bzk05(p_cmd)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_bzk[l_ac].bzk05,g_errno,0)
            LET g_bzk[l_ac].bzk05 = g_bzk_o.bzk05
            NEXT FIELD bzk05
         END IF
      END IF
      LET g_bzk_o.bzk05 = g_bzk[l_ac].bzk05
 
        #No.FUN-840202 --start--
        AFTER FIELD bzkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
    ON ROW CHANGE
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_bzk[l_ac].* = g_bzk_t.*
         CLOSE i505_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF
      CALL i505_bzk04('a')
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_bzk[l_ac].bzk04,g_errno,0)
         NEXT FIELD bzk04
      END IF
      CALL i505_bzk05(p_cmd)
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_bzk[l_ac].bzk05,g_errno,0)
         NEXT FIELD bzk05
      END IF
      IF l_lock_sw = 'Y' THEN 
         CALL cl_err(g_bzk[l_ac].bzk02,-263,1)
         LET g_bzk[l_ac].* = g_bzk_t.*
      ELSE
         UPDATE bzk_file SET bzk02 = g_bzk[l_ac].bzk02,
                                bzk03 = g_bzk[l_ac].bzk03,
                                bzk04 = g_bzk[l_ac].bzk04,
                                bzk05 = g_bzk[l_ac].bzk05,
                                bzk06 = g_bzk[l_ac].bzk06,
                                #FUN-840202 --start--
                                bzkud01 = g_bzk[l_ac].bzkud01,
                                bzkud02 = g_bzk[l_ac].bzkud02,
                                bzkud03 = g_bzk[l_ac].bzkud03,
                                bzkud04 = g_bzk[l_ac].bzkud04,
                                bzkud05 = g_bzk[l_ac].bzkud05,
                                bzkud06 = g_bzk[l_ac].bzkud06,
                                bzkud07 = g_bzk[l_ac].bzkud07,
                                bzkud08 = g_bzk[l_ac].bzkud08,
                                bzkud09 = g_bzk[l_ac].bzkud09,
                                bzkud10 = g_bzk[l_ac].bzkud10,
                                bzkud11 = g_bzk[l_ac].bzkud11,
                                bzkud12 = g_bzk[l_ac].bzkud12,
                                bzkud13 = g_bzk[l_ac].bzkud13,
                                bzkud14 = g_bzk[l_ac].bzkud14,
                                bzkud15 = g_bzk[l_ac].bzkud15
                                #FUN-840202 --end-- 
          WHERE bzk01 = g_bzj.bzj01 AND bzk02 = g_bzk_t.bzk02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err(g_bzk[l_ac].bzk02,SQLCA.sqlcode,0)
            LET g_bzk[l_ac].* = g_bzk_t.*
         ELSE
            MESSAGE 'UPDATE O.K '
            COMMIT WORK
         END IF
      END IF
 
    BEFORE DELETE
      IF g_bzk_t.bzk02 > 0 AND g_bzk_t.bzk02 IS NOT NULL THEN
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         DELETE FROM bzk_file
          WHERE bzk01 = g_bzj.bzj01 
            AND bzk02 = g_bzk_t.bzk02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err(g_bzk_t.bzk02,SQLCA.sqlcode,0)
            ROLLBACK WORK
            CANCEL DELETE
         END IF
         LET g_rec_b = g_rec_b - 1
         DISPLAY g_rec_b TO FORMONLY.cnt2
      END IF
      COMMIT WORK
 
    AFTER ROW
      LET l_ac = ARR_CURR()
     #LET l_ac_t = l_ac   #FUN-D30034 mark
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         IF p_cmd = 'u' THEN
            LET g_bzk[l_ac].* = g_bzk_t.*
         #FUN-D30034--add--begin--
         ELSE
            CALL g_bzk.deleteElement(l_ac)
            IF g_rec_b != 0 THEN
               LET g_action_choice = "detail"
               LET l_ac = l_ac_t
            END IF
         #FUN-D30034--add--end----
         END IF
         CLOSE i505_bcl
         ROLLBACK WORK
         EXIT INPUT
      END IF
      LET l_ac_t = l_ac   #FUN-D30034 add
      CLOSE i505_bcl
      COMMIT WORK
 
    ON ACTION CONTROLO                                  
       IF INFIELD(bzk02) AND l_ac > 1 THEN
          LET g_bzk[l_ac].* = g_bzk[l_ac-1].*
          LET g_bzk[l_ac].bzk02 =g_bzk_t.bzk02 #g_rec_b + 1
          DISPLAY BY NAME g_bzk[l_ac].bzk02
          NEXT FIELD bzk02
       END IF
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    ON ACTION controlp
       CASE
           WHEN INFIELD(bzk03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_bzi"
                LET g_qryparam.default1 = g_bzk[l_ac].bzk03
                LET g_qryparam.default2 = g_bzk[l_ac].bzk04
                CALL cl_create_qry() RETURNING 
                                     g_bzk[l_ac].bzk03,g_bzk[l_ac].bzk04
                DISPLAY BY NAME g_bzk[l_ac].bzk03
                CALL i505_bzk03('a')
                CALL i505_bzk04('a')
                NEXT FIELD bzk03
           WHEN INFIELD(bzk04)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_bzi"
                LET g_qryparam.where =" bzi01='",g_bzk[l_ac].bzk03,"'"
                LET g_qryparam.default1 = g_bzk[l_ac].bzk03
                LET g_qryparam.default2 = g_bzk[l_ac].bzk04
                CALL cl_create_qry() RETURNING 
                                     g_bzk[l_ac].bzk03,g_bzk[l_ac].bzk04
                DISPLAY BY NAME g_bzk[l_ac].bzk04
                CALL i505_bzk04('a')
                NEXT FIELD bzk04
           OTHERWISE EXIT CASE
       END CASE
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
  CLOSE i505_bcl
  COMMIT WORK
  CALL i505_delHeader()     #CHI-C30002 add
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION i505_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_bzj.bzj01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM bzj_file ",
                  "  WHERE bzj01 LIKE '",l_slip,"%' ",
                  "    AND bzj01 > '",g_bzj.bzj01,"'"
      PREPARE i505_pb1 FROM l_sql 
      EXECUTE i505_pb1 INTO l_cnt      
      
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
         #CALL i505_x() #FUN-D20025 mark
         CALL i505_x(1) #FUN-D20025 add
         CALL i505_pic()
      END IF 
      
      IF l_cho = 3 THEN    
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN
         DELETE FROM bzj_file WHERE bzj01 = g_bzj.bzj01
         INITIALIZE g_bzj.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i505_b_fill(p_wc2)
  DEFINE p_wc2   STRING
 
  LET g_sql = "SELECT bzk02,bzk03,bzk04,'','','','','','','','','',",
              "       bzk05,bzk06 ",
                      #No.FUN-840202 --start--
                      ",bzkud01,bzkud02,bzkud03,bzkud04,bzkud05,",
                      "bzkud06,bzkud07,bzkud08,bzkud09,bzkud10,",
                      "bzkud11,bzkud12,bzkud13,bzkud14,bzkud15", 
                      #No.FUN-840202 ---end---
              "  FROM bzk_file",
              " WHERE bzk01 ='",g_bzj.bzj01,"'"
 
  IF NOT cl_null(p_wc2) THEN
     LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
  END IF
  LET g_sql=g_sql CLIPPED," ORDER BY bzk02,bzk03,bzk04 "
 
  PREPARE i505_pb FROM g_sql
  DECLARE bzk_cs CURSOR FOR i505_pb
 
  CALL g_bzk.clear()
  LET g_cnt = 1
 
  FOREACH bzk_cs INTO g_bzk[g_cnt].*   #單身 ARRAY 填充
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach bzk_cs:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    LET l_ac = g_cnt
    CALL i505_bzk04('d')
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  CALL g_bzk.deleteElement(g_cnt)
  LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cnt2
  LET g_cnt = 0
END FUNCTION
 
FUNCTION i505_r()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_bzj.bzj01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_bzj.* FROM bzj_file WHERE bzj01=g_bzj.bzj01
   IF g_bzj.bzj06 ='Y' THEN    #檢查資料是否為已確認
      CALL cl_err(g_bzj.bzj01,'9021',0)
      RETURN
   END IF
 
   IF g_bzj.bzj06 ='X' THEN    #檢查資料是否為作廢
      CALL cl_err(g_bzj.bzj01,'9021',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i505_cl USING g_bzj.bzj01
   IF STATUS THEN
      CALL cl_err("OPEN i505_cl:", STATUS, 1)
      CLOSE i505_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i505_cl INTO g_bzj.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i505_show()
 
   IF cl_delh(0,0) THEN                   #確認一下 
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "bzj01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_bzj.bzj01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM bzj_file WHERE bzj01 = g_bzj.bzj01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
 
      DELETE FROM bzk_file WHERE bzk01 = g_bzj.bzj01
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)
         ROLLBACK WORK
         RETURN
      END IF
 
      CLEAR FORM
      INITIALIZE g_bzj.* TO NULL
      INITIALIZE g_bzj_o.* TO NULL
      INITIALIZE g_bzj_t.* TO NULL
      LET g_bzj01_t = NULL
      CALL g_bzk.clear()
      OPEN i505_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i505_cs
         CLOSE i505_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--

      FETCH i505_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i505_cs
         CLOSE i505_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i505_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i505_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE         #No.FUN-6A0058 g_no_ask
         CALL i505_fetch('/')
      END IF
   END IF      
   CLOSE i505_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i505_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("bzj01",TRUE)
  END IF
END FUNCTION
 
FUNCTION i505_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("bzj01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i505_set_entry_b()
   CALL cl_set_comp_entry("bzk04,bzk05",TRUE)
END FUNCTION
 
FUNCTION i505_set_no_entry_b()
    IF INFIELD(bzk03) AND cl_null(g_bzk[l_ac].bzk03) THEN
       CALL cl_set_comp_entry("bzk04,bzk05",FALSE)
    END IF
    IF INFIELD(bzk04) AND cl_null(g_bzk[l_ac].bzk04) THEN
       CALL cl_set_comp_entry("bzk05",FALSE)
    END IF
END FUNCTION
 
#檢查確認人
FUNCTION i505_bzj04(p_cmd)  
  DEFINE 
    l_gen02    LIKE gen_file.gen02,
    l_genacti  LIKE gen_file.genacti,
    p_cmd      LIKE type_file.chr1
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
  FROM gen_file WHERE gen01 = g_bzj.bzj04        
 
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                                 LET l_gen02 = NULL
       WHEN l_genacti= 'N' LET g_errno = '9028'
       OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    DISPLAY l_gen02 TO FORMONLY.gen02a
  END IF
END FUNCTION
 
#檢查外送單號
FUNCTION i505_bzk03(p_cmd)  
  DEFINE 
    l_bzh06    LIKE bzh_file.bzh06,
    p_cmd         LIKE type_file.chr1
 
  LET g_errno = ' '
  SELECT bzh06 INTO l_bzh06 
    FROM bzh_file WHERE bzh01 = g_bzk[l_ac].bzk03
 
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abx-027'
       WHEN l_bzh06 != 'Y' LET g_errno = 'abx-028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
#檢查外送單號、項次
FUNCTION i505_bzk04(p_cmd)  
  DEFINE
    l_bzi03    LIKE bzi_file.bzi03,
    l_bzi04    LIKE bzi_file.bzi04,
    l_bza02    LIKE bza_file.bza02,
    l_bza03    LIKE bza_file.bza03,
    l_bza04    LIKE bza_file.bza04,
    l_bzb03    LIKE bzb_file.bzb03, 
    l_gem02       LIKE gem_file.gem02,
    l_bzb04    LIKE bzb_file.bzb04, 
    l_gen02       LIKE gen_file.gen02,
    p_cmd         LIKE type_file.chr1
 
  LET g_errno = ' '
 
  SELECT bzi03, bzi04, bzb_file.bzb03,bzb_file.bzb04 
    INTO l_bzi03, l_bzi04, l_bzb03, l_bzb04 
    FROM bzi_file, OUTER bzb_file 
   WHERE bzi01 = g_bzk[l_ac].bzk03 
     AND bzi02 = g_bzk[l_ac].bzk04
     AND bzb_file.bzb01=bzi_file.bzi03 
     AND bzb_file.bzb02=bzi_file.bzi04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abx-020'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) THEN
     SELECT bza02,bza03,bza04 INTO l_bza02,l_bza03,l_bza04
       FROM bza_file WHERE bza01=l_bzi03
     SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=l_bzb03 
     SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=l_bzb04 
  END IF
 
  IF cl_null(g_errno) OR p_cmd = 'd' OR (p_cmd = 'a' AND cl_null(g_errno)) THEN
       LET g_bzk[l_ac].bzi03 = l_bzi03
       LET g_bzk[l_ac].bzi04 = l_bzi04
       LET g_bzk[l_ac].bza02 = l_bza02
       LET g_bzk[l_ac].bza03 = l_bza03
       LET g_bzk[l_ac].bza04 = l_bza04
       LET g_bzk[l_ac].bzb03 = l_bzb03
       LET g_bzk[l_ac].gem02 = l_gem02
       LET g_bzk[l_ac].bzb04 = l_bzb04
       LET g_bzk[l_ac].gen02 = l_gen02
  END IF
END FUNCTION
 
#檢查外送數量
FUNCTION i505_bzk05(p_cmd)  
  DEFINE 
    p_cmd         LIKE type_file.chr1,
    l_count       LIKE type_file.num5               #計算回收數量
 
  LET g_errno = ' '
  IF g_bzk[l_ac].bzk05 <= 0 THEN
     LET g_errno = '-32406'
  END IF
  #取出此收回單號已存在相同之外送單號之已收回數量，並加上此次收回數量
  LET l_count = 0
  SELECT SUM(bzk05) INTO l_count FROM bzk_file 
   WHERE bzk01=g_bzj.bzj01
     AND bzk03=g_bzk[l_ac].bzk03 
     AND bzk04=g_bzk[l_ac].bzk04 
  IF cl_null(l_count) THEN LET l_count=0 END IF
  IF p_cmd='u' AND g_bzk[l_ac].bzk03 = g_bzk_t.bzk03 AND
     g_bzk[l_ac].bzk04 = g_bzk_t.bzk04  THEN 
     LET l_count=l_count-g_bzk_t.bzk05 
  END IF
  LET l_count=l_count + g_bzk[l_ac].bzk05
  #取出外送單號剩餘之可收回數量，並減去將可能收回之數量，
  #扣除後之值不可小於零
  SELECT bzi05 - bzi08- l_count INTO l_count FROM bzi_file
   WHERE bzi01 = g_bzk[l_ac].bzk03 
     AND bzi02 = g_bzk[l_ac].bzk04
  IF cl_null(l_count) THEN LET l_count=0 END IF
  IF l_count < 0 THEN
     LET g_errno = 'abx-029'
  END IF
END FUNCTION
 
#確認
FUNCTION i505_y()
  DEFINE
    l_bzb01 LIKE bzb_file.bzb01,
    l_bzb02 LIKE bzb_file.bzb02,
    l_bzi01 LIKE bzi_file.bzi01,
    l_bzi02 LIKE bzi_file.bzi02,
    l_bzi03 LIKE bzi_file.bzi03,
    l_bzi04 LIKE bzi_file.bzi04,
    l_bzi05 LIKE bzi_file.bzi05,
    l_bzi08 LIKE bzi_file.bzi08,
    l_bzk01 LIKE bzk_file.bzk01,
    l_bzk02 LIKE bzk_file.bzk02,
    l_bzk05 LIKE bzk_file.bzk05, 
    l_count    LIKE type_file.num5,
    l_gen02 LIKE gen_file.gen02   #CHI-C80072 add
 
   IF cl_null(g_bzj.bzj01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
      #已確認資料不可確認                                            #CHI-C30107 add
   IF g_bzj.bzj06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF    #CHI-C30107 add

   #已作癈資料不可確認                                               #CHI-C30107 add
   IF g_bzj.bzj06 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF  #CHI-C30107 add
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
 
   SELECT * INTO g_bzj.* FROM bzj_file WHERE bzj01=g_bzj.bzj01
 
   #已確認資料不可確認
   IF g_bzj.bzj06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
 
   #已作癈資料不可確認
   IF g_bzj.bzj06 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   #無單身資料不可確認
   SELECT COUNT(*) INTO l_count FROM bzk_file
    WHERE bzk01=g_bzj.bzj01
   IF l_count=0 OR cl_null(l_count) THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i505_cl USING g_bzj.bzj01
   IF STATUS THEN
      CALL cl_err("OPEN i505_cl:", STATUS, 1)
      CLOSE i505_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i505_cl INTO g_bzj.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i505_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_bzj_t.* = g_bzj.*  #備份值
   LET g_success = 'Y'
 
   LET g_bzj.bzj04 = g_user 
   LET g_bzj.bzj05 = g_today
   LET g_bzj_o.bzj05 = g_today
   LET g_bzj.bzj06 = 'N'
   LET g_bzj.bzjmodu = g_user
   LET g_bzj.bzjdate = g_today
  #CHI-C80072--mark--str--
  #CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
  #INPUT BY NAME g_bzj.bzj04,g_bzj.bzj05,g_bzj.bzj06 WITHOUT DEFAULTS
  #  AFTER FIELD bzj04     
  #     IF NOT cl_null(g_bzj.bzj04) THEN
  #        CALL i505_bzj04('a')
  #        IF NOT cl_null(g_errno) THEN
  #           CALL cl_err(g_bzj.bzj04,g_errno,0)
  #           LET g_bzj.bzj04 = g_bzj_o.bzj04
  #           NEXT FIELD bzj04
  #        END IF
  #     END IF
  #     LET g_bzj_o.bzj04 = g_bzj.bzj04
 
  #  AFTER FIELD bzj05     
  #     IF NOT cl_null(g_bzj.bzj05) THEN
  #        IF g_bzj.bzj05 < g_bzj.bzj02 THEN
  #           CALL cl_err(g_bzj.bzj05,'abx-026',0)
  #           LET g_bzj.bzj05 = g_bzj_o.bzj05
  #           NEXT FIELD bzj05
  #        END IF
  #     END IF
  #     LET g_bzj_o.bzj05 = g_bzj.bzj05
 
  #  ON ACTION CONTROLR
  #     CALL cl_show_req_fields()
 
  #  ON ACTION CONTROLG
  #     CALL cl_cmdask()
 
  #  ON ACTION CONTROLF                  #欄位說明
  #     CALL cl_set_focus_form(ui.Interface.getRootNode())
  #          RETURNING g_fld_name,g_frm_name
  #     CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
  #  ON ACTION controlp
  #     CASE
  #         WHEN INFIELD(bzj04)
  #            CALL cl_init_qry_var()
  #            LET g_qryparam.form ="q_gen"
  #            LET g_qryparam.default1 = g_bzj.bzj04
  #            CALL cl_create_qry() RETURNING g_bzj.bzj04
  #            DISPLAY BY NAME g_bzj.bzj04
  #            CALL i505_bzj04('a')
  #            NEXT FIELD bzj04
  #         OTHERWISE EXIT CASE
  #     END CASE
 
  #  ON IDLE g_idle_seconds
  #     CALL cl_on_idle()
  #     CONTINUE INPUT
 
  #  ON ACTION about
  #     CALL cl_about()
 
  #  ON ACTION help
  #     CALL cl_show_help()
 
  #  AFTER INPUT
  #     IF INT_FLAG THEN
  #        CALL cl_err('',9001,0)
  #        LET INT_FLAG = 0
  #        LET g_success = 'N'
  #        EXIT INPUT
  #     END IF        
  #CHI-C80072--mark--end--
        LET g_bzj.bzj06 = 'Y'
        UPDATE bzj_file SET bzj04=g_bzj.bzj04,
                               bzj05=g_bzj.bzj05,
                               bzj06=g_bzj.bzj06,
                               bzjmodu = g_bzj.bzjmodu,
                               bzjdate = g_bzj.bzjdate
         WHERE bzj01=g_bzj.bzj01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('',SQLCA.SQLCODE,1)
           LET g_success = 'N'
  #         EXIT INPUT      #CHI-C80072 mark
        END IF
        SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_bzj.bzj04    #CHI-C80072 add
        DISPLAY l_gen02 TO gen02a                                            #CHI-C80072 add
        LET g_sql = "SELECT bzk03,bzk04,SUM(bzk05) FROM bzk_file ",
                    " WHERE bzk01='",g_bzj.bzj01,
                    "' GROUP BY bzk03,bzk04"
        PREPARE i505_pqty FROM g_sql
        DECLARE i505_qty_cs CURSOR FOR i505_pqty
        FOREACH i505_qty_cs INTO l_bzi01,l_bzi02,l_bzk05
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH i505_qty_cs:',SQLCA.SQLCODE,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          #取出外送單資料之外送數量及收回數量
          SELECT bzi05,bzi08 INTO l_bzi05,l_bzi08 FROM bzi_file
           WHERE bzi01=l_bzi01 AND bzi02 = l_bzi02
          IF SQLCA.sqlcode THEN
             CALL cl_err('',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          #計算並判斷寫回外送單資料後，是否收回數量小於等於外送數量　
          IF l_bzi05 >=  l_bzi08+l_bzk05 THEN
             UPDATE bzi_file SET bzi08=bzi08+l_bzk05
              WHERE bzi01=l_bzi01 AND bzi02 = l_bzi02   
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err('',SQLCA.sqlcode,1)
                LET g_success = 'N'
                EXIT FOREACH
             END IF
          ELSE
             CALL cl_err(l_bzi01,'abx-030',1) #發生收回數量大於外送數量之例外
             LET g_success = 'N'
             EXIT FOREACH
          END IF
        END FOREACH  
        #IF g_success = 'N' THEN EXIT INPUT END IF      #CHI-C80072 mark
        LET g_sql = "SELECT bzi03,bzi04,SUM(bzk05) ",
                    "  FROM bzi_file,bzk_file ",
                    " WHERE bzk01='",g_bzj.bzj01,"' ",
                    "   AND bzk03=bzi01 AND bzk04=bzi02 ",
                    " GROUP BY bzi03,bzi04"
        PREPARE i505_pqty2 FROM g_sql
        DECLARE i505_qty_cs2 CURSOR FOR i505_pqty2
        FOREACH i505_qty_cs2 INTO l_bzb01,l_bzb02,l_bzk05
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH i505_qty_cs2:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          UPDATE bzb_file SET bzb11=bzb11+l_bzk05 
           WHERE bzb01=l_bzb01 AND bzb02 = l_bzb02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err('',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          UPDATE bzb_file SET bzb07=bzb05-bzb10+bzb11-bzb12-bzb13 
           WHERE bzb01=l_bzb01 AND bzb02 = l_bzb02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err('',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          UPDATE bza_file SET bza16=(SELECT SUM(bzb07) FROM bzb_file 
           WHERE bzb01=l_bzb01) WHERE bza01=l_bzb01
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err('',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
        END FOREACH 
        #IF g_success = 'N' THEN EXIT INPUT END IF     #CHI-C80072 mark
        LET g_sql = "SELECT bzk01,bzk02,bzi03,bzi04,bzk05 ",
                    "  FROM bzk_file,bzi_file ",
                    " WHERE bzk01='",g_bzj.bzj01,"' ",
                    "   AND bzk03=bzi01 AND bzk04=bzi02"
        PREPARE i505_pqty3 FROM g_sql
        DECLARE i505_qty_cs3 CURSOR FOR i505_pqty3
        FOREACH i505_qty_cs3 INTO l_bzk01,l_bzk02,l_bzi03,l_bzi04,l_bzk05
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH i505_qty_cs3:',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
          INSERT INTO bzp_file(bzp01,bzp02,bzp03,bzp04,bzp05,
                                  bzp06,bzp07,bzp08,bzp09,
                                  bzpplant,bzplegal)  #FUN-980001 add
                           VALUES(l_bzk01,l_bzk02,g_today,'B','1',
                                  l_bzi03,l_bzi04,l_bzk05,
                                  g_bzj.bzj05,
                                  g_plant,g_legal)  #FUN-980001 add
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err('',SQLCA.sqlcode,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
        END FOREACH 
        #IF g_success = 'N' THEN EXIT INPUT END IF  #CHI-C80072 mark
   #END INPUT      #CHI-C80072 mark
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)  #顯示 COMMIT WORK 訊息
   ELSE
      ROLLBACK WORK
      LET g_bzj.* = g_bzj_t.*
      CALL cl_rbmsg(4)  #顯示 ROLLBACK WORK 訊息
   END IF
   CLOSE i505_cl
   DISPLAY BY NAME g_bzj.bzj04,g_bzj.bzj05,g_bzj.bzj06,
                   g_bzj.bzjmodu,g_bzj.bzjdate
   IF cl_null(g_bzj.bzj05) THEN
      DISPLAY ' ' TO FORMONLY.gen02a
   END IF
END FUNCTION
 
FUNCTION i505_z()
  DEFINE
    l_bzb01 LIKE bzb_file.bzb01,
    l_bzb02 LIKE bzb_file.bzb02,
    l_bzi01 LIKE bzi_file.bzi01,
    l_bzi02 LIKE bzi_file.bzi02,
    l_bzi03 LIKE bzi_file.bzi03,
    l_bzi04 LIKE bzi_file.bzi04,
    l_bzk01 LIKE bzk_file.bzk01,
    l_bzk02 LIKE bzk_file.bzk02,
    l_bzk05 LIKE bzk_file.bzk05, 
    l_gen02 LIKE gen_file.gen02      #CHI-C80072 add       
 
   IF cl_null(g_bzj.bzj01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   SELECT * INTO g_bzj.* FROM bzj_file WHERE bzj01=g_bzj.bzj01
 
   IF g_bzj.bzj06 = 'N' THEN CALL cl_err('',9002,0) RETURN END IF
   IF g_bzj.bzj06 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   BEGIN WORK
 
   OPEN i505_cl USING g_bzj.bzj01
   IF STATUS THEN
      CALL cl_err("OPEN i505_cl:", STATUS, 1)
      CLOSE i505_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i505_cl INTO g_bzj.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)          #資料被他人LOCK
      CLOSE i505_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_bzj_t.* = g_bzj.*  #備份值
   LET g_success = 'Y'
 
   #LET g_bzj.bzj04 = ''    #CHI-B10034  
   #LET g_bzj.bzj05 = ''    #CHI-B10034  
   LET g_bzj.bzj06 = 'N'    
   LET g_bzj.bzjmodu = g_user
   LET g_bzj.bzjdate = g_today
   LET g_bzj.bzj04 = g_user       #CHI-C80072 add
   LET g_bzj.bzj05 = g_today      #CHI-C80072 add
 
   UPDATE bzj_file SET bzj04 = g_bzj.bzj04,
                          bzj05 = g_bzj.bzj05,
                          bzj06 = g_bzj.bzj06,
                          bzjmodu = g_bzj.bzjmodu,
                          bzjdate = g_bzj.bzjdate
 
    WHERE bzj01=g_bzj.bzj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF

   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_bzj.bzj04    #CHI-C80072 add
   DISPLAY l_gen02 TO gen02a                                            #CHI-C80072 add
 
   LET g_sql = "SELECT bzk03,bzk04,SUM(bzk05) FROM bzk_file ",
               " WHERE bzk01='",g_bzj.bzj01,"' GROUP BY bzk03,bzk04"
   PREPARE i505_pqty4 FROM g_sql
   DECLARE i505_qty_cs4 CURSOR FOR i505_pqty4
   FOREACH i505_qty_cs4 INTO l_bzi01,l_bzi02,l_bzk05
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH i505_qty_cs4:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      UPDATE bzi_file SET bzi08=bzi08-l_bzk05
       WHERE bzi01=l_bzi01 AND bzi02 = l_bzi02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH  
   
   LET g_sql = "SELECT bzi03,bzi04,SUM(bzk05) ",
               "  FROM bzi_file,bzk_file ",
               " WHERE bzk01='",g_bzj.bzj01,"' ",
               "   AND bzk03=bzi01 AND bzk04=bzi02 ",
               " GROUP BY bzi03,bzi04"
   PREPARE i505_pqty5 FROM g_sql
   DECLARE i505_qty_cs5 CURSOR FOR i505_pqty5
   FOREACH i505_qty_cs5 INTO l_bzb01,l_bzb02,l_bzk05
     IF SQLCA.sqlcode THEN
        CALL cl_err('FOREACH i505_qty_cs5:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     UPDATE bzb_file SET bzb11=bzb11-l_bzk05 
      WHERE bzb01=l_bzb01 AND bzb02 = l_bzb02
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     UPDATE bzb_file SET bzb07=bzb05-bzb10+bzb11-bzb12-bzb13 
      WHERE bzb01=l_bzb01 AND bzb02 = l_bzb02
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     UPDATE bza_file SET bza16=(SELECT SUM(bzb07) FROM bzb_file 
      WHERE bzb01=l_bzb01) WHERE bza01=l_bzb01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
   END FOREACH 
   
   DELETE FROM bzp_file WHERE bzp01=g_bzj.bzj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CLOSE i505_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)  #顯示 COMMIT WORK 訊息
   ELSE
      ROLLBACK WORK
      LET g_bzj.* = g_bzj_t.*
      CALL cl_rbmsg(4)  #顯示 ROLLBACK WORK 訊息
   END IF
   DISPLAY BY NAME g_bzj.bzj04,g_bzj.bzj05,g_bzj.bzj06,
                   g_bzj.bzjmodu,g_bzj.bzjdate
   #DISPLAY ' ' TO FORMONLY.gen02a      #CHI-C80072 mark
END FUNCTION
 
#FUNCTION i505_x() #FUN-D20025 mark
FUNCTION i505_x(p_type) #FUN-D20025 add
  DEFINE l_void    LIKE type_file.chr1  
  DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add  
  IF cl_null(g_bzj.bzj01) THEN
     CALL cl_err("",-400,0)
     RETURN
  END IF
 
  SELECT * INTO g_bzj.* FROM bzj_file WHERE bzj01=g_bzj.bzj01
 
  IF g_bzj.bzj06 = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF
  #FUN-D20025---begin 
  IF p_type = 1 THEN 
     IF g_bzj.bzj06='X' THEN RETURN END IF
  ELSE
     IF g_bzj.bzj06<>'X' THEN RETURN END IF
  END IF 
  #FUN-D20025---end 
  IF g_bzj.bzj06='X' THEN 
     LET l_void='Y'
  ELSE
     LET l_void='N' 
  END IF
  BEGIN WORK
 
  OPEN i505_cl USING g_bzj.bzj01
  IF STATUS THEN
     CALL cl_err("OPEN i505_cl:", STATUS, 1)
     CLOSE i505_cl
     ROLLBACK WORK
     RETURN
  END IF
 
  FETCH i505_cl INTO g_bzj.*               # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bzj.bzj01,SQLCA.sqlcode,0)          #資料被他人LOCK
     CLOSE i505_cl
     ROLLBACK WORK
     RETURN
  END IF
  LET g_bzj_t.* = g_bzj.*  #備份值
 
  IF cl_void(0,0,l_void) THEN
     IF g_bzj.bzj06='N' THEN
        LET g_bzj.bzj06='X'    
     ELSE
        LET g_bzj.bzj06='N'
     END IF
     LET g_bzj.bzjmodu = g_user
     LET g_bzj.bzjdate = g_today
 
     UPDATE bzj_file SET bzj06   = g_bzj.bzj06,
                            bzjmodu = g_bzj.bzjmodu,
                            bzjdate = g_bzj.bzjdate
      WHERE bzj01=g_bzj.bzj01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('',SQLCA.SQLCODE,1)
        LET g_bzj.* = g_bzj_t.*
        DISPLAY BY NAME g_bzj.bzj06,
                        g_bzj.bzjmodu,g_bzj.bzjdate
        ROLLBACK WORK
        RETURN
     END IF
     DISPLAY BY NAME g_bzj.bzj06,g_bzj.bzjmodu,g_bzj.bzjdate
     IF g_bzj.bzj06='N' THEN
        MESSAGE 'UNDO-VOID O.K '
     ELSE
        MESSAGE 'VOID O.K '
     END IF
  END IF
  CLOSE i505_cl
  COMMIT WORK
END FUNCTION
 
FUNCTION i505_pic()
   DEFINE l_void LIKE type_file.chr1
   IF g_bzj.bzj06 = 'X' THEN
      LET l_void = 'Y'
   ELSE
      LET l_void = 'N'
   END IF
   CALL cl_set_field_pic(g_bzj.bzj06,"","","",l_void,"")
END FUNCTION
 
FUNCTION i505_out()
DEFINE sr RECORD 
             bzj01      LIKE bzj_file.bzj01,
             bzj02      LIKE bzj_file.bzj02,
             bzj03      LIKE bzj_file.bzj03,
             bzj04      LIKE bzj_file.bzj04,
             gen02a     LIKE gen_file.gen02,       #人員名稱
             bzj05      LIKE bzj_file.bzj05,
             bzj06      LIKE bzj_file.bzj06,
             bzk02      LIKE bzk_file.bzk02,       #項次
             bzk03      LIKE bzk_file.bzk03,       #外送單號
             bzk04      LIKE bzk_file.bzk04,       #外送單號－項次
             bzi03      LIKE bzi_file.bzi03,       #機器設備編號
             bzi04      LIKE bzi_file.bzi04,       #序號
             bza02      LIKE bza_file.bza02,       #機器設備中文名稱
             bza03      LIKE bza_file.bza03,       #機器設備英文名稱
             bza04      LIKE bza_file.bza04,       #機器設備規格
             bzb03      LIKE bzb_file.bzb03,       #保管部門代號
             gem02      LIKE gem_file.gem03,       #部門名稱
             bzb04      LIKE bzb_file.bzb04,       #保管人
             gen02b     LIKE gen_file.gen02,       #人員名稱
             bzk05      LIKE bzk_file.bzk05,       #本次收回數量
             bzk06      LIKE bzk_file.bzk06        #備註
          END RECORD,
       l_name LIKE type_file.chr20    # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
 
#FUN-850089 add---START
   DEFINE l_sql    STRING
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
    CALL cl_del_data(l_table)
   #------------------------------ CR (2) ------------------------------#
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
#FUN-850089 add---END
 
   IF g_bzj.bzj01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
 
   IF cl_null(g_wc) THEN
      LET g_wc=" bzj01='",g_bzj.bzj01,"'"
   END IF
 
   CALL cl_wait()
#   CALL cl_outnam('abxi505') RETURNING l_name   #No.FUN-850089
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   #No.TQC-9A0145  --Begin
   LET g_sql="SELECT bzj01,bzj02,bzj03,bzj04,b.gen02,bzj05,bzj06,bzk02,",
             "       bzk03,bzk04,bzi03,bzi04,bza02,bza03,bza04,",
             "       bzb03,gem02,bzb04,c.gen02,bzk05,bzk06 ",
             "  FROM bzk_file,bzj_file LEFT OUTER JOIN gen_file b",
             "                         ON bzj04 = b.gen01,",
             "       bzi_file LEFT OUTER JOIN bza_file ",
             "                ON bzi03 = bza01 ",
             "                LEFT OUTER JOIN (bzb_file LEFT OUTER JOIN gem_file ",
             "                                          ON bzb03 = gem01 ",
             "                                          LEFT OUTER JOIN gen_file c ",
             "                                          ON bzb04 = c.gen01)",
             "                ON bzi03 = bzb01 AND bzi04 = bzb02 ",
             " WHERE bzk01 =bzj01 AND bzi01=bzk03 AND bzi02=bzk04",
             "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED


   #LET g_sql="SELECT bzj01,bzj02,bzj03,bzj04,b.gen02,bzj05,bzj06,bzk02,",
   #          "       bzk03,bzk04,bzi03,bzi04,d.bza02,d.bza03,d.bza04,",
   #          "       e.bzb03,a.gem02,e.bzb04,c.gen02,bzk05,bzk06 ",
   #          "  FROM bzj_file LEFT OUTER JOIN gen_file b ON bzj_file.bzj04=b.gen01,",
   #          "       bzk_file,bzi_file LEFT OUTER JOIN bza_file d ON bzi_file.bzi03=d.bza01",
   #          "       LEFT OUTER JOIN (bzb_file e LEFT OUTER JOIN gem_file a ON e.bzb03=a.gem01 ",
   #          "       LEFT OUTER JOIN gen_file c ON e.bzb04=c.gen01 ) ON bzi_file.bzi03=e.bzb01 AND bzi_file.bzi04=e.bzb02 ",
   #          "   WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED 
   #No.TQC-9A0145  --End  
   
   PREPARE i505_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i505_co CURSOR FOR i505_p1        # SCROLL CURSOR
 
#   START REPORT i505_rep TO l_name         #No.FUN-850089
 
   FOREACH i505_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
         EXIT FOREACH
      END IF
      #---FUN-850089 add---START
       EXECUTE insert_prep USING sr.bzj01, sr.bzj02, sr.bzj03, sr.bzj04,
                                 sr.gen02a,sr.bzj05, sr.bzj06, sr.bzk02, 
                                 sr.bzk03, sr.bzk04, sr.bzi03, sr.bzi04, 
                                 sr.bza02, sr.bza03, sr.bza04, sr.bzb03, 
                                 sr.gem02, sr.bzb04, sr.gen02b,sr.bzk05,
                                 sr.bzk06
       IF SQLCA.sqlcode  THEN
          CALL cl_err('insert_prep:',STATUS,1) EXIT FOREACH
       END IF
      #---FUN-850089 add---END
#      OUTPUT TO REPORT i505_rep(sr.*)          #No.FUN-850089
   END FOREACH
 
  #FUN-850089  ---start---
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> 
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " ORDER BY bzj01,bzk02"
 
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'bzj01,bzj02,bzj03,bzj04,bzj05,bzj06,bzjuser,bzjgrup,bzjmodu,bzjdate,bzjacti')
            RETURNING g_str
    ELSE
       LET g_str = ''
    END IF
    LET g_str = g_str
    CALL cl_prt_cs3('abxi505','abxi505',l_sql,g_str)
    #------------------------------ CR (4) ------------------------------#
  #FUN-850089  ----end---
 
#   FINISH REPORT i505_rep                      #No.FUN-850089
 
   CLOSE i505_co
   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)           #No.FUN-850089 
END FUNCTION
 
#No.FUN-850089  ----begin---
#REPORT i505_rep(sr)
#DEFINE l_last_sw  LIKE type_file.chr1          #No.FUN-690010 VARCHAR(1),
#DEFINE sr RECORD 
#            bzj01      LIKE bzj_file.bzj01,
#            bzj02      LIKE bzj_file.bzj02,
#            bzj03      LIKE bzj_file.bzj03,
#            bzj04      LIKE bzj_file.bzj04,
#            gen02a     LIKE gen_file.gen02,       #人員名稱
#            bzj05      LIKE bzj_file.bzj05,
#            bzj06      LIKE bzj_file.bzj06,
#            bzk02      LIKE bzk_file.bzk02,       #項次
#            bzk03      LIKE bzk_file.bzk03,       #外送單號
#            bzk04      LIKE bzk_file.bzk04,       #外送單號－項次
#            bzi03      LIKE bzi_file.bzi03,       #機器設備編號
#            bzi04      LIKE bzi_file.bzi04,       #序號
#            bza02      LIKE bza_file.bza02,       #機器設備中文名稱
#            bza03      LIKE bza_file.bza03,       #機器設備英文名稱
#            bza04      LIKE bza_file.bza04,       #機器設備規格
#            bzb03      LIKE bzb_file.bzb03,       #保管部門代號
#            gem02      LIKE gem_file.gem03,       #部門名稱
#            bzb04      LIKE bzb_file.bzb04,       #保管人
#            gen02b     LIKE gen_file.gen02,       #人員名稱
#            bzk05      LIKE bzk_file.bzk05,       #本次收回數量
#            bzk06      LIKE bzk_file.bzk06        #備註
#         END RECORD
 
#       OUTPUT
#               TOP MARGIN g_top_margin
#               LEFT MARGIN g_left_margin
#               BOTTOM MARGIN g_bottom_margin
#               PAGE LENGTH g_page_line
 
#       ORDER BY sr.bzj01,sr.bzk02
 
#       FORMAT
#           PAGE HEADER
#              PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#              PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#              LET g_pageno=g_pageno+1
#              LET pageno_total=PAGENO USING '<<<',"/pageno"
#              PRINT g_head CLIPPED,pageno_total
#              PRINT g_dash2
#              PRINT g_x[11],sr.bzj01 CLIPPED,COLUMN (g_len/2),g_x[12],sr.bzj02 CLIPPED
#              PRINT g_x[14],sr.bzj04 CLIPPED,'  ',sr.gen02a CLIPPED,COLUMN (g_len/2),g_x[15],sr.bzj05 CLIPPED 
#              PRINT g_x[16],sr.bzj06 CLIPPED,COLUMN (g_len/2),g_x[13],sr.bzj03 CLIPPED
#              PRINT g_dash
#              PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                             g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                             g_x[41]
#              PRINTX name=H2 g_x[42],g_x[43],g_x[44],g_x[45],g_x[46],
#                             g_x[47],g_x[48],g_x[49],g_x[50]
#              PRINT g_dash1
#              LET l_last_sw = 'y'
 
#           BEFORE GROUP OF sr.bzj01
#              SKIP TO TOP OF PAGE
 
#           ON EVERY ROW
#              PRINTX name=D1 COLUMN g_c[31],cl_numfor(sr.bzk02,31,0),
#                             COLUMN g_c[32],sr.bzk03,
#                             COLUMN g_c[33],cl_numfor(sr.bzk04,33,0),
#                             COLUMN g_c[34],sr.bzi03,
#                             COLUMN g_c[35],cl_numfor(sr.bzi04,35,0),
#                             COLUMN g_c[36],sr.bza02,
#                             COLUMN g_c[37],sr.bza04,
#                             COLUMN g_c[38],sr.bzb03,
#                             COLUMN g_c[39],sr.bzb04,
#                             COLUMN g_c[40],cl_numfor(sr.bzk05,40,0),
#                             COLUMN g_c[41],sr.bzk06
 
#              PRINTX name=D2 COLUMN g_c[47],sr.bza03,
#                             COLUMN g_c[49],sr.gem02,
#                             COLUMN g_c[50],sr.gen02b
 
#           ON LAST ROW
#             IF g_zz05 = 'Y' THEN PRINT g_dash
#                CALL cl_prt_pos_wc(g_wc)
#             END IF
#             PRINT g_dash
#             LET l_last_sw = 'n'
#             PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
 
#       PAGE TRAILER
#           IF l_last_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[5] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#TQC-790177
#No.FUN-850089  ----end---
#No.FUN-890101
