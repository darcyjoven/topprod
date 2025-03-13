# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxi504.4gl
# Descriptions...: 保稅機器設備外送建立作業
# Date & Author..: 2006/10/13 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0062 06/11/27 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770005 07/07/10 By ve 報表改為使用crystal report
# Modify.........: No.TQC-780054 07/08/15 By xiaofeizhu 修改INSERT INTO temptable語法(不用ora轉換)
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-840202 08/05/07 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
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
# Modify.........: No.CHI-C80072 12/03/27 By lujh 1:統一確認和取消確認時確認人員和確認日期的寫法 2:原程序審核按鈕無法使用
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_bzh           RECORD LIKE bzh_file.*,      
  g_bzh_t         RECORD LIKE bzh_file.*, 
  g_bzh_o         RECORD LIKE bzh_file.*,
  g_bzh01_t       LIKE bzh_file.bzh01,          
  g_bzi           DYNAMIC ARRAY OF RECORD      
      bzi02       LIKE bzi_file.bzi02,       
      bzi03       LIKE bzi_file.bzi03,       
      bzi04       LIKE bzi_file.bzi04,
      bza02       LIKE bza_file.bza02,
      bza03       LIKE bza_file.bza03,
      bza04       LIKE bza_file.bza04,
      bzb03       LIKE bzb_file.bzb03,
      gem02          LIKE gem_file.gem02,
      bzb04       LIKE bzb_file.bzb04,
      gen02          LIKE gen_file.gen02,
      bzi05       LIKE bzi_file.bzi05,        
      bzi06       LIKE bzi_file.bzi06,        
      bzi07       LIKE bzi_file.bzi07,        
      bzi08       LIKE bzi_file.bzi08,        
      bzi09       LIKE bzi_file.bzi09      
      #FUN-840202 --start---
     ,bziud01     LIKE bzi_file.bziud01,
      bziud02     LIKE bzi_file.bziud02,
      bziud03     LIKE bzi_file.bziud03,
      bziud04     LIKE bzi_file.bziud04,
      bziud05     LIKE bzi_file.bziud05,
      bziud06     LIKE bzi_file.bziud06,
      bziud07     LIKE bzi_file.bziud07,
      bziud08     LIKE bzi_file.bziud08,
      bziud09     LIKE bzi_file.bziud09,
      bziud10     LIKE bzi_file.bziud10,
      bziud11     LIKE bzi_file.bziud11,
      bziud12     LIKE bzi_file.bziud12,
      bziud13     LIKE bzi_file.bziud13,
      bziud14     LIKE bzi_file.bziud14,
      bziud15     LIKE bzi_file.bziud15
      #FUN-840202 --end--
                     END RECORD,
  g_bzi_t         RECORD      
      bzi02       LIKE bzi_file.bzi02,       
      bzi03       LIKE bzi_file.bzi03,       
      bzi04       LIKE bzi_file.bzi04,
      bza02       LIKE bza_file.bza02,
      bza03       LIKE bza_file.bza03,
      bza04       LIKE bza_file.bza04,
      bzb03       LIKE bzb_file.bzb03,
      gem02          LIKE gem_file.gem02,
      bzb04       LIKE bzb_file.bzb04,
      gen02          LIKE gen_file.gen02,
      bzi05       LIKE bzi_file.bzi05,        
      bzi06       LIKE bzi_file.bzi06,        
      bzi07       LIKE bzi_file.bzi07,        
      bzi08       LIKE bzi_file.bzi08,        
      bzi09       LIKE bzi_file.bzi09      
      #FUN-840202 --start---
     ,bziud01     LIKE bzi_file.bziud01,
      bziud02     LIKE bzi_file.bziud02,
      bziud03     LIKE bzi_file.bziud03,
      bziud04     LIKE bzi_file.bziud04,
      bziud05     LIKE bzi_file.bziud05,
      bziud06     LIKE bzi_file.bziud06,
      bziud07     LIKE bzi_file.bziud07,
      bziud08     LIKE bzi_file.bziud08,
      bziud09     LIKE bzi_file.bziud09,
      bziud10     LIKE bzi_file.bziud10,
      bziud11     LIKE bzi_file.bziud11,
      bziud12     LIKE bzi_file.bziud12,
      bziud13     LIKE bzi_file.bziud13,
      bziud14     LIKE bzi_file.bziud14,
      bziud15     LIKE bzi_file.bziud15
      #FUN-840202 --end--
                     END RECORD,
  g_bzi_o         RECORD      
      bzi02       LIKE bzi_file.bzi02,       
      bzi03       LIKE bzi_file.bzi03,       
      bzi04       LIKE bzi_file.bzi04,
      bza02       LIKE bza_file.bza02,
      bza03       LIKE bza_file.bza03,
      bza04       LIKE bza_file.bza04,
      bzb03       LIKE bzb_file.bzb03,
      gem02          LIKE gem_file.gem02,
      bzb04       LIKE bzb_file.bzb04,
      gen02          LIKE gen_file.gen02,
      bzi05       LIKE bzi_file.bzi05,        
      bzi06       LIKE bzi_file.bzi06,        
      bzi07       LIKE bzi_file.bzi07,        
      bzi08       LIKE bzi_file.bzi08,        
      bzi09       LIKE bzi_file.bzi09      
      #FUN-840202 --start---
     ,bziud01     LIKE bzi_file.bziud01,
      bziud02     LIKE bzi_file.bziud02,
      bziud03     LIKE bzi_file.bziud03,
      bziud04     LIKE bzi_file.bziud04,
      bziud05     LIKE bzi_file.bziud05,
      bziud06     LIKE bzi_file.bziud06,
      bziud07     LIKE bzi_file.bziud07,
      bziud08     LIKE bzi_file.bziud08,
      bziud09     LIKE bzi_file.bziud09,
      bziud10     LIKE bzi_file.bziud10,
      bziud11     LIKE bzi_file.bziud11,
      bziud12     LIKE bzi_file.bziud12,
      bziud13     LIKE bzi_file.bziud13,
      bziud14     LIKE bzi_file.bziud14,
      bziud15     LIKE bzi_file.bziud15
      #FUN-840202 --end--
                     END RECORD,
  g_rec_b            LIKE type_file.num5,          #單身筆數
  l_ac               LIKE type_file.num5,          #目前處理的ARRAY CNT
  g_forupd_sql       STRING,            #SELECT ... FOR UPDATE SQL
  g_before_input_done  LIKE type_file.num5,
  g_cnt           LIKE type_file.num10,
  g_curs_index    LIKE type_file.num10,
  g_row_count     LIKE type_file.num10,                 #總筆數
  g_jump          LIKE type_file.num10,                 #查詢指定的筆數
  mi_no_ask       LIKE type_file.num5,                #是否開啟指定筆視窗
  p_row           LIKE type_file.num5,
  p_col           LIKE type_file.num5,
  g_wc            STRING,
  g_wc2           STRING,
  g_sql           STRING,
  g_msg           STRING,
  g_t1            LIKE type_file.chr5,     #單別判斷
  g_i             LIKE type_file.num5,
  g_chk_bzi05     LIKE type_file.num5,     #1=bzi05值ok，2=bzi05值不行
  l_table         STRING,                  #No.FUN-770005  
  g_str           STRING                   #No.FUN-770005
DEFINE g_argv1     LIKE bzh_file.bzh01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
# DEFINE
#       l_time    LIKE type_file.chr8      #No.FUN-6A0062
 
  OPTIONS                                  #改變一些系統預設值
      INPUT NO WRAP
  DEFER INTERRUPT                          #擷取中斷鍵, 由程式處理
 
  IF (NOT cl_user()) THEN
     EXIT PROGRAM
  END IF
  WHENEVER ERROR CALL cl_err_msg_log
  IF (NOT cl_setup("ABX")) THEN
     EXIT PROGRAM
  END IF
  
 # CALL cl_used('abxi504',g_time,1)  RETURNING g_time #FUN-B30211
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
#No.FUN-770005--BEGIN--
  LET g_sql=" bzh01.bzh_file.bzh01,",
            " bzh02.bzh_file.bzh02,",
            " bzh03.bzh_file.bzh03,",
            " bzh04.bzh_file.bzh04,",
            " gen02a.gen_file.gen02,",
            " bzh05.bzh_file.bzh05,",
            " bzh06.bzh_file.bzh06,",
            " bzi02.bzi_file.bzi02,",
            " bzi03.bzi_file.bzi03,",
            " bzi04.bzi_file.bzi04,",
            " bza02.bza_file.bza02,",
            " bza03.bza_file.bza03,",
            " bza04.bza_file.bza04,",
            " bzb03.bzb_file.bzb03,",
            " gem02.gem_file.gem02,",
            " bzb04.bzb_file.bzb03,",
            " gen02b.gen_file.gen02,",
            " bzi05.bzi_file.bzi05,",
            " bzi06.bzi_file.bzi06,",
            " bzi07.bzi_file.bzi07,",
            " bzi08.bzi_file.bzi08,",
            " bzi09.bzi_file.bzi09" 
  LET l_table=cl_prt_temptable('abxi504',g_sql) CLIPPED
  IF l_table=-1 THEN EXIT PROGRAM END IF
# LET g_sql=" INSERT INTO ds_report.",l_table CLIPPED,             # TQC-780054
  LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,    # TQC-780054
            " VALUES(?,?,?,?,?,?,?,?,?,?,",
            "        ?,?,?,?,?,?,?,?,?,?,?,?)"
  PREPARE insert_prep FROM g_sql
  IF STATUS THEN
     CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
  END IF
#No.FUN-770005--END--
  LET g_forupd_sql = "SELECT * FROM bzh_file  WHERE bzh01 = ? ",
                     " FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i504_cl CURSOR FROM g_forupd_sql
  LET p_row = 2 LET p_col = 9
  OPEN WINDOW i504_w AT p_row,p_col              #顯示畫面
       WITH FORM "abx/42f/abxi504" ATTRIBUTE (STYLE = g_win_style)
  CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i504_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i504_a()
            END IF
         OTHERWISE        
            CALL i504_q() 
      END CASE
   END IF
   #--
  
  CALL i504_menu()
  CLOSE WINDOW i504_w                            #結束畫面
  #CALL cl_used('abxi504',g_time,2) RETURNING g_time   #FUN-B30211
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION i504_menu()
  WHILE TRUE
     CALL i504_bp("G")
     CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i504_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i504_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i504_r()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i504_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i504_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL i504_y()
              CALL i504_pic()
           END IF
        WHEN "undo_confirm"
           IF cl_chk_act_auth() THEN
              CALL i504_z()
              CALL i504_pic() 
           END IF
        WHEN "void"
           IF cl_chk_act_auth() THEN 
              #CALL i504_x() #FUN-D20025 mark
              CALL i504_x(1) #FUN-D20025 add
              CALL i504_pic()
           END IF
        #FUN-D20025 add
        WHEN "undo_void"          #"取消作廢"
           IF cl_chk_act_auth() THEN
              CALL i504_x(2)
              CALL i504_pic()
           END IF
        #FUN-D20025 add   
        WHEN "output"
           IF cl_chk_act_auth() THEN 
              CALL i504_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"   
           CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bzi),'','')
        WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_bzh.bzh01 IS NOT NULL THEN
                LET g_doc.column1 = "bzh01"
                LET g_doc.value1 = g_bzh.bzh01
                CALL cl_doc()
             END IF
          END IF
     END CASE
  END WHILE
END FUNCTION 
 
FUNCTION i504_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN
     RETURN
  END IF
  LET g_action_choice = " "
  CALL cl_set_act_visible("accept,cancel", FALSE)
  
  DISPLAY ARRAY g_bzi TO s_bzi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      CALL i504_fetch('F')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
    ON ACTION previous
      CALL i504_fetch('P')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    ON ACTION jump
      CALL i504_fetch('/')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
    ON ACTION next
      CALL i504_fetch('N')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
    ON ACTION last
      CALL i504_fetch('L')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
    ON ACTION detail
      LET g_action_choice="detail"
      LET l_ac = 1
      EXIT DISPLAY
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
    ON ACTION output
      LET g_action_choice="output"
      EXIT DISPLAY
    ON ACTION help
      LET g_action_choice="help"
      EXIT DISPLAY
    ON ACTION locale
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()
       CALL i504_pic()
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
 
FUNCTION i504_cs()
  DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
  
  CLEAR FORM                             #清除畫面
  CALL g_bzi.clear()
  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INITIALIZE g_bzh.* TO NULL    #No.FUN-750051
 
 IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" bzh01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
 ELSE
  CONSTRUCT BY NAME g_wc ON bzh01,bzh02,bzh03,bzh04,bzh05,bzh06,
                    bzhacti,bzhuser,bzhgrup,bzhmodu,bzhdate
                    #FUN-840202   ---start---
                    ,bzhud01,bzhud02,bzhud03,bzhud04,bzhud05,
                    bzhud06,bzhud07,bzhud08,bzhud09,bzhud10,
                    bzhud11,bzhud12,bzhud13,bzhud14,bzhud15
                    #FUN-840202    ----end----
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
     ON ACTION controlp
        CASE
         WHEN INFIELD(bzh01)                  #^P找單別資料 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_bzh01"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bzh01
              NEXT FIELD bzh01
         WHEN INFIELD(bzh04)
              CALL cl_init_qry_var()             #^P找人員代號
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_gen"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bzh04
              NEXT FIELD bzh04
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bzhuser', 'bzhgrup') #FUN-980030
  IF INT_FLAG THEN
     RETURN                         #不設成0，因為回到i504_b()還要再判斷一次
  END IF
 
  CONSTRUCT g_wc2 ON bzi02,bzi03,bzi04,bzi05,bzi06,bzi07,
                     bzi08,bzi09
                    #No.FUN-840202 --start--
                    ,bziud01,bziud02,bziud03,bziud04,bziud05
                    ,bziud06,bziud07,bziud08,bziud09,bziud10
                    ,bziud11,bziud12,bziud13,bziud14,bziud15
                    #No.FUN-840202 ---end---
            FROM s_bzi[1].bzi02,s_bzi[1].bzi03,s_bzi[1].bzi04,
                 s_bzi[1].bzi05,s_bzi[1].bzi06,s_bzi[1].bzi07,
                 s_bzi[1].bzi08,s_bzi[1].bzi09
           #No.FUN-840202 --start--
           ,s_bzi[1].bziud01,s_bzi[1].bziud02,s_bzi[1].bziud03
           ,s_bzi[1].bziud04,s_bzi[1].bziud05,s_bzi[1].bziud06
           ,s_bzi[1].bziud07,s_bzi[1].bziud08,s_bzi[1].bziud09
           ,s_bzi[1].bziud10,s_bzi[1].bziud11,s_bzi[1].bziud12
           ,s_bzi[1].bziud13,s_bzi[1].bziud14,s_bzi[1].bziud15
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
END IF  #FUN-7C0050
 
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN               #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND bzhuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN               #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND bzhgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
     LET g_sql = "SELECT  bzh01 FROM bzh_file ",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY bzh01"
  ELSE                                    # 若單身有輸入條件
     LET g_sql = "SELECT UNIQUE bzh_file. bzh01 ",
                 "  FROM bzh_file, bzi_file ",
                 " WHERE bzh01 = bzi01",
                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY bzh01"
  END IF
 
  PREPARE i504_prepare FROM g_sql
  DECLARE i504_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i504_prepare
  IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
     LET g_sql="SELECT COUNT(*) FROM bzh_file WHERE ",g_wc CLIPPED
  ELSE
     LET g_sql="SELECT COUNT(DISTINCT bzh01) FROM bzh_file,bzi_file ",
               " WHERE bzi01=bzh01 AND ",g_wc CLIPPED,
               "   AND ",g_wc2 CLIPPED
  END IF
  PREPARE i504_precount FROM g_sql
  DECLARE i504_count CURSOR FOR i504_precount
END FUNCTION
 
FUNCTION i504_a()
  DEFINE li_result   LIKE type_file.num5
 
  MESSAGE ""
  CLEAR FORM
  CALL g_bzi.clear()
  IF s_shut(0) THEN
     RETURN
  END IF
 
  INITIALIZE g_bzh.* LIKE bzh_file.*             #DEFAULT 設定
  LET g_bzh01_t = NULL
  LET g_bzh_t.* = g_bzh.*
  LET g_bzh_o.* = g_bzh.*
 
  CALL cl_opmsg('a')
 
  WHILE TRUE
    LET g_bzh.bzhuser=g_user
    LET g_bzh.bzhgrup=g_grup
    LET g_bzh.bzhdate=g_today
    LET g_bzh.bzhacti='Y'              
    LET g_bzh.bzh02 = g_today
    LET g_bzh.bzh06 = 'N'                           
 
    LET g_bzh.bzhplant = g_plant  #FUN-980001 add
    LET g_bzh.bzhlegal = g_legal  #FUN-980001 add
 
    CALL i504_i("a")                   #輸入單頭
    IF INT_FLAG THEN                   #使用者中斷
       INITIALIZE g_bzh.* TO NULL 
       LET INT_FLAG = 0
       CALL cl_err('',9001,0)
       EXIT WHILE
    END IF
    IF cl_null(g_bzh.bzh01) THEN       # KEY 不可空白
       CONTINUE WHILE
    END IF
    
    BEGIN WORK
      LET g_t1 = s_get_doc_no(g_bzh.bzh01)
      CALL s_auto_assign_no("ABX",g_t1,g_bzh.bzh02,"A","bzh_file","bzh01","","","")
           RETURNING li_result,g_bzh.bzh01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      #進行輸入之單號檢查
      CALL s_mfgchno(g_bzh.bzh01) RETURNING g_i,g_bzh.bzh01
      DISPLAY BY NAME g_bzh.bzh01
      IF NOT g_i THEN CONTINUE WHILE END IF
      
      LET g_bzh.bzhoriu = g_user      #No.FUN-980030 10/01/04
      LET g_bzh.bzhorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO bzh_file VALUES (g_bzh.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN          #置入資料庫不成功
         CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,1)          #No.FUN-B80082---調整至回滾事務前---
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK       
      END IF
 
      SELECT bzh01 INTO g_bzh.bzh01 FROM bzh_file
       WHERE bzh01 = g_bzh.bzh01
      LET g_bzh01_t = g_bzh.bzh01                     #保留舊值
      LET g_bzh_t.* = g_bzh.*
      LET g_bzh_o.* = g_bzh.*
 
      CALL g_bzi.clear()
      LET g_rec_b = 0 
      CALL i504_b()
      EXIT WHILE
  END WHILE     
END FUNCTION
 
FUNCTION i504_i(p_cmd)
  DEFINE
    l_n            LIKE type_file.num5,
    p_cmd          LIKE type_file.chr1,                #a:輸入 u:更改
    li_result      LIKE type_file.num5
  
  IF s_shut(0) THEN
     RETURN
  END IF
  CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
  INPUT BY NAME g_bzh.bzh01,g_bzh.bzh02,g_bzh.bzh03,
                g_bzh.bzh06,g_bzh.bzhuser,g_bzh.bzhgrup,
                g_bzh.bzhmodu,g_bzh.bzhdate,g_bzh.bzhacti
                #FUN-840202     ---start---
               ,g_bzh.bzhud01,g_bzh.bzhud02,g_bzh.bzhud03,g_bzh.bzhud04,
                g_bzh.bzhud05,g_bzh.bzhud06,g_bzh.bzhud07,g_bzh.bzhud08,
                g_bzh.bzhud09,g_bzh.bzhud10,g_bzh.bzhud11,g_bzh.bzhud12,
                g_bzh.bzhud13,g_bzh.bzhud14,g_bzh.bzhud15 
                #FUN-840202     ----end----
                WITHOUT DEFAULTS
 
    BEFORE INPUT
       LET g_before_input_done = FALSE
       CALL i504_set_entry(p_cmd)
       CALL i504_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
      
    AFTER FIELD bzh01
       IF NOT cl_null(g_bzh.bzh01) THEN
          #新增或是修改key值時才檢查key值是否重覆於table中
          IF p_cmd = 'a' OR ( p_cmd ='u' AND g_bzh.bzh01 != g_bzh01_t) THEN
#            CALL s_check_no(g_sys,g_bzh.bzh01,g_bzh01_t,"A","bzh_file","bzh01","")
             CALL s_check_no("abx",g_bzh.bzh01,g_bzh01_t,"A","bzh_file","bzh01","")   #No.FUN-A40041
                  RETURNING li_result,g_bzh.bzh01
             DISPLAY BY NAME g_bzh.bzh01
             IF (NOT li_result) THEN
                NEXT FIELD bzh01
             END IF
          END IF   
          LET g_bzh_o.bzh01 = g_bzh.bzh01
       END IF
 
        #FUN-840202     ---start---
        AFTER FIELD bzhud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzhud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
    AFTER INPUT 
       IF INT_FLAG THEN
          INITIALIZE g_bzh.* TO NULL
          CALL cl_err('',9001,0)
          RETURN
       END IF
 
    ON ACTION CONTROLR                         #必填欄位提示
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    ON ACTION CONTROLF                         #欄位說明
       CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name
       CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
  
    ON ACTION controlp
       CASE
           WHEN INFIELD(bzh01)
              LET g_t1 = s_get_doc_no(g_bzh.bzh01)
#             CALL q_bna(FALSE,TRUE,g_t1,'A',g_sys) RETURNING g_t1
              CALL q_bna(FALSE,TRUE,g_t1,'A','abx') RETURNING g_t1   #No.FUN-A40041
              IF INT_FLAG THEN
                 LET INT_FLAG = 0
              END IF
              LET g_bzh.bzh01 = g_t1
              DISPLAY BY NAME g_bzh.bzh01
              NEXT FIELD bzh01
           WHEN INFIELD(bzh04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gen"
              LET g_qryparam.default1 = g_bzh.bzh04
              CALL cl_create_qry() RETURNING g_bzh.bzh04
              NEXT FIELD bzh04
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
 
FUNCTION i504_u()
  IF s_shut(0) THEN
     RETURN
  END IF
  IF cl_null(g_bzh.bzh01) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  SELECT * INTO g_bzh.* FROM bzh_file
   WHERE bzh01=g_bzh.bzh01
  IF g_bzh.bzh06 ='Y' THEN               #檢查資料是否為確認
     CALL cl_err(g_bzh.bzh01,'9022',0)
     RETURN
  END IF
  IF g_bzh.bzh06 ='X' THEN               #檢查資料是否為作廢
     CALL cl_err(g_bzh.bzh01,'9022',0)
     RETURN
  END IF
  MESSAGE ""
  CALL cl_opmsg('u')
  LET g_bzh01_t = g_bzh.bzh01
 
  BEGIN WORK
 
  OPEN i504_cl USING g_bzh.bzh01
  IF STATUS THEN
     CALL cl_err("OPEN i504_cl:", STATUS, 1)
     CLOSE i504_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH i504_cl INTO g_bzh.*                      # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)   
     CLOSE i504_cl
     ROLLBACK WORK
     RETURN
  END IF
  CALL i504_show()
  
  WHILE TRUE
    LET g_bzh01_t = g_bzh.bzh01
    LET g_bzh_o.* = g_bzh.*
    LET g_bzh.bzhmodu=g_user
    LET g_bzh.bzhdate=g_today
 
    CALL i504_i("u")
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_bzh.*=g_bzh_t.*
       CALL i504_show()
       CALL cl_err('','9001',0)
       EXIT WHILE
    END IF
    
    IF g_bzh.bzh01 != g_bzh01_t THEN        #更改單頭的key值，也要改單身的key值
       UPDATE bzi_file SET bzi01 = g_bzh.bzh01
        WHERE bzi01 = g_bzh01_t
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('bzi',SQLCA.sqlcode,0)
          CONTINUE WHILE
       END IF
    END IF
    
    UPDATE bzh_file SET bzh_file.* = g_bzh.*
     WHERE bzh01 = g_bzh01_t
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)
       CONTINUE WHILE
    ELSE
       MESSAGE 'UPDATE  SUCCESS '   
       EXIT WHILE          
    END IF
  END WHILE
 
  CLOSE i504_cl
  COMMIT WORK
  CALL i504_pic()
END FUNCTION
 
FUNCTION i504_show()
  LET g_bzh_t.* = g_bzh.*                #保存單頭舊值
  LET g_bzh_o.* = g_bzh.*                #保存單頭舊值
  DISPLAY BY NAME g_bzh.bzh01,g_bzh.bzh02,g_bzh.bzh03,
                  g_bzh.bzh04,g_bzh.bzh05,g_bzh.bzh06,
                  g_bzh.bzhuser,g_bzh.bzhgrup,
                  g_bzh.bzhmodu,g_bzh.bzhdate,g_bzh.bzhacti
                  #FUN-840202     ---start---
                 ,g_bzh.bzhud01,g_bzh.bzhud02,g_bzh.bzhud03,g_bzh.bzhud04,
                  g_bzh.bzhud05,g_bzh.bzhud06,g_bzh.bzhud07,g_bzh.bzhud08,
                  g_bzh.bzhud09,g_bzh.bzhud10,g_bzh.bzhud11,g_bzh.bzhud12,
                  g_bzh.bzhud13,g_bzh.bzhud14,g_bzh.bzhud15 
                  #FUN-840202     ----end----
 
  LET g_t1 = s_get_doc_no(g_bzh.bzh01)
  CALL i504_bzh04('d')
  CALL i504_b_fill(g_wc2)                 #單身
  CALL i504_pic()
END FUNCTION
 
FUNCTION i504_q()
  LET g_row_count = 0
  LET g_curs_index = 0
  CALL cl_navigator_setting( g_curs_index, g_row_count )
  MESSAGE ""
  CALL cl_opmsg('q')
  INITIALIZE g_bzh.* TO NULL
  CLEAR FORM
  CALL g_bzi.clear()
  DISPLAY ' ' TO FORMONLY.cnt
  DISPLAY ' ' TO FORMONLY.cnt2
 
  CALL i504_cs()
 
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     INITIALIZE g_bzh.* TO NULL
     RETURN
  END IF 
                         
  OPEN i504_cs 
  IF SQLCA.sqlcode THEN
     CALL cl_err('OPEN i504_cs CURSOER ERROR:',SQLCA.sqlcode,0)
     INITIALIZE g_bzh.* TO NULL
  ELSE
     OPEN i504_count
     FETCH i504_count INTO g_row_count
     DISPLAY g_row_count TO FORMONLY.cnt
     CALL i504_fetch('F')                
  END IF
END FUNCTION
 
FUNCTION i504_fetch(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1
  
  CASE p_flag
     WHEN 'N' FETCH NEXT     i504_cs INTO g_bzh.bzh01
     WHEN 'P' FETCH PREVIOUS i504_cs INTO g_bzh.bzh01
     WHEN 'F' FETCH FIRST    i504_cs INTO g_bzh.bzh01
     WHEN 'L' FETCH LAST     i504_cs INTO g_bzh.bzh01
     WHEN '/'
           IF (NOT mi_no_ask) THEN     #如果是因為刪除單身而來到此行程式
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
           FETCH ABSOLUTE g_jump i504_cs INTO g_bzh.bzh01
           LET mi_no_ask = FALSE
  END CASE
  
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)
     INITIALIZE g_bzh.* TO NULL
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
 
  SELECT * INTO g_bzh.* FROM bzh_file WHERE bzh01 = g_bzh.bzh01
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)
     INITIALIZE g_bzh.* TO NULL
     RETURN
  END IF
 
  CALL i504_show()
END FUNCTION
 
FUNCTION i504_b()
  DEFINE
    l_n             LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5,              #可刪除否
    l_ac_t          LIKE type_file.num5      #FUN-D30034 add 
 
  LET g_action_choice = ""
  IF s_shut(0) THEN
    RETURN
  END IF
  IF cl_null(g_bzh.bzh01) THEN
    RETURN
  END IF
  IF g_bzh.bzh06 ='X' THEN               #檢查資料是否為作廢
    CALL cl_err(g_bzh.bzh01,'9022',0)
    RETURN
  END IF
  IF g_bzh.bzh06 ='Y' THEN               #檢查資料是否為確認
    CALL cl_err(g_bzh.bzh01,'9022',0)
    RETURN
  END IF
  CALL cl_opmsg('b')
 
  LET g_forupd_sql = "SELECT bzi02,bzi03,bzi04,'','','','','',",
                     " '','',bzi05,bzi06,bzi07,bzi08,bzi09 ", 
                     ",bziud01,bziud02,bziud03,bziud04,bziud05,",
                     "bziud06,bziud07,bziud08,bziud09,bziud10,",
                     "bziud11,bziud12,bziud13,bziud14,bziud15",
                     " FROM bzi_file",
                     " WHERE bzi01=? AND bzi02=? FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i504_bcl CURSOR FROM g_forupd_sql           # LOCK CURSOR
  LET l_allow_insert = cl_detail_input_auth("insert")
  LET l_allow_delete = cl_detail_input_auth("delete")
  
  INPUT ARRAY g_bzi WITHOUT DEFAULTS FROM s_bzi.*
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
     
       BEGIN WORK
       OPEN i504_cl USING g_bzh.bzh01
       IF STATUS THEN
          CALL cl_err("OPEN CURSOR ERROR: ", STATUS, 1)
          CLOSE i504_cl
          ROLLBACK WORK
          RETURN
       END IF
  
       FETCH i504_cl INTO g_bzh.* # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)    
          CLOSE i504_cl
          ROLLBACK WORK
          RETURN
       END IF
       IF g_rec_b >= l_ac THEN
          LET p_cmd='u'
          LET g_bzi_t.* = g_bzi[l_ac].*  
          LET g_bzi_o.* = g_bzi[l_ac].* 
          OPEN i504_bcl USING g_bzh.bzh01,g_bzi_t.bzi02
          IF STATUS THEN
             CALL cl_err("OPEN i504_bcl:", STATUS, 1)
             LET l_lock_sw = "Y"
             RETURN
          ELSE
             FETCH i504_bcl INTO g_bzi[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_bzi_t.bzi02,SQLCA.sqlcode,1)
               LET l_lock_sw = "Y"
             END IF
             IF NOT cl_null(g_bzi[l_ac].bzi04) THEN
                CALL i504_showfield()
                CALL i504_gem02('a')
                CALL i504_gen02('a')
             END IF
          END IF
       END IF
      
    BEFORE INSERT
       LET p_cmd='a'
       #設定預設值
       INITIALIZE g_bzi[l_ac].* TO NULL  
       IF cl_null(g_bzi[l_ac].bzi02) OR g_bzi[l_ac].bzi02 = 0 THEN
          SELECT max(bzi02)+1 INTO g_bzi[l_ac].bzi02
            FROM bzi_file WHERE bzi01 = g_bzh.bzh01
          IF cl_null(g_bzi[l_ac].bzi02) THEN
             LET g_bzi[l_ac].bzi02 = 1
          END IF
       END IF
       LET g_bzi[l_ac].bzi05 = 0   
       LET g_bzi[l_ac].bzi08 = 0
       LET g_bzi[l_ac].bzi07 =  g_today
       LET g_bzi_t.* = g_bzi[l_ac].*        #新輸入資料備份
       LET g_bzi_o.* = g_bzi[l_ac].*        #新輸入資料備份
       NEXT FIELD bzi02
 
    AFTER INSERT   
       DISPLAY "AFTER INSERT!"
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          CANCEL INSERT
       END IF
       CALL i504_chk_bzi04(p_cmd)
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_bzi[l_ac].bzi04,g_errno,1)
          CALL g_bzi.deleteElement(l_ac)
          CANCEL INSERT
       END IF
       CALL i504_chk_bzi05(p_cmd)
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_bzi[l_ac].bzi05,g_errno,1)
          CALL g_bzi.deleteElement(l_ac)
          CANCEL INSERT
       END IF
       INSERT INTO bzi_file(bzi01,bzi02,bzi03,bzi04,bzi05,bzi06,
                               bzi07,bzi08,bzi09
                               #FUN-840202 --start--
                              ,bziud01,bziud02,bziud03,
                               bziud04,bziud05,bziud06,
                               bziud07,bziud08,bziud09,
                               bziud10,bziud11,bziud12,
                               bziud13,bziud14,bziud15,
                               bziplant,bzilegal)  #FUN-980001 add
                               #FUN-840202 --end--
       VALUES(g_bzh.bzh01,g_bzi[l_ac].bzi02,g_bzi[l_ac].bzi03,
              g_bzi[l_ac].bzi04,g_bzi[l_ac].bzi05,g_bzi[l_ac].bzi06,
              g_bzi[l_ac].bzi07,g_bzi[l_ac].bzi08,g_bzi[l_ac].bzi09
               #FUN-840202 --start--
             ,g_bzi[l_ac].bziud01, g_bzi[l_ac].bziud02,
              g_bzi[l_ac].bziud03, g_bzi[l_ac].bziud04,
              g_bzi[l_ac].bziud05, g_bzi[l_ac].bziud06,
              g_bzi[l_ac].bziud07, g_bzi[l_ac].bziud08,
              g_bzi[l_ac].bziud09, g_bzi[l_ac].bziud10,
              g_bzi[l_ac].bziud11, g_bzi[l_ac].bziud12,
              g_bzi[l_ac].bziud13, g_bzi[l_ac].bziud14,
              g_bzi[l_ac].bziud15,
              #FUN-840202 --end-- 
              g_plant,g_legal)  #FUN-980001 add
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_bzi[l_ac].bzi02,SQLCA.sqlcode,0)
          CANCEL INSERT
       ELSE
          MESSAGE 'INSERT O.K'
          COMMIT WORK
          LET g_rec_b=g_rec_b+1
          DISPLAY g_rec_b TO FORMONLY.cnt2
       END IF
 
    AFTER FIELD bzi02   #項次
       IF NOT cl_null(g_bzi[l_ac].bzi02) THEN
          IF g_bzi[l_ac].bzi02 < 1 THEN
             CALL cl_err('','mfg1322',0)
             LET g_bzi[l_ac].bzi02 = g_bzi_o.bzi02
             DISPLAY BY NAME g_bzi[l_ac].bzi02
             NEXT FIELD bzi02
          END IF
          IF p_cmd = 'a' OR
            (p_cmd = 'u' AND g_bzi[l_ac].bzi02 != g_bzi_t.bzi02 ) THEN
             SELECT count(*) INTO l_n FROM bzi_file 
              WHERE bzi01 = g_bzh.bzh01 AND bzi02 = g_bzi[l_ac].bzi02
             IF l_n > 0 THEN
                CALL cl_err(g_bzi[l_ac].bzi02,-239,0)
                LET g_bzi[l_ac].bzi02 = g_bzi_o.bzi02
                DISPLAY BY NAME g_bzi[l_ac].bzi02
             END IF
          END IF
          LET g_bzi_o.bzi02 = g_bzi[l_ac].bzi02
       END IF   
    
    AFTER FIELD bzi03  #機器設備
       IF NOT cl_null(g_bzi[l_ac].bzi03) THEN
          CALL i504_chk_bzi03(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bzi[l_ac].bzi03,g_errno,0)
             LET g_bzi[l_ac].bzi03 = g_bzi_o.bzi03
             DISPLAY BY NAME g_bzi[l_ac].bzi03
             NEXT FIELD bzi03
          END IF
          LET g_bzi_o.bzi03 = g_bzi[l_ac].bzi03
          #有了機器設備編號和序號才帶出bza02、bza03、bza04、bzb03、bzb04
          IF NOT cl_null(g_bzi[l_ac].bzi04) THEN
             CALL i504_showfield()
             CALL i504_gem02('a')
             CALL i504_gen02('a')
          END IF
       END IF
 
    AFTER FIELD bzi04   #序號
       IF NOT cl_null(g_bzi[l_ac].bzi04) THEN
          #檢查在bzb_file中機器設備編號和序號是否一致
          IF NOT cl_null(g_bzi[l_ac].bzi03) THEN
             CALL i504_chk_bzi04(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_bzi[l_ac].bzi04,g_errno,0)
                LET g_bzi[l_ac].bzi04 = g_bzi_o.bzi04
                DISPLAY BY NAME g_bzi[l_ac].bzi04
                NEXT FIELD bzi04
             END IF
          END IF
          LET g_bzi_o.bzi04 = g_bzi[l_ac].bzi04 
          #有了機器設備編號和序號才帶出bza02、bza03、bza04、bzb03、bzb04
          IF NOT cl_null(g_bzi[l_ac].bzi03) THEN
             CALL i504_showfield()
             CALL i504_gem02('a')
             CALL i504_gen02('a')
          END IF
       END IF
 
    AFTER FIELD bzi05  #外送數量
       IF NOT cl_null(g_bzi[l_ac].bzi05) THEN
          CALL i504_chk_bzi05(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bzi[l_ac].bzi05,g_errno,0)
             LET g_bzi[l_ac].bzi05 = g_bzi_o.bzi05
             DISPLAY BY NAME g_bzi[l_ac].bzi05
             NEXT FIELD bzi05
          END IF
          LET g_bzi_o.bzi05 = g_bzi[l_ac].bzi05
       END IF
      
    AFTER FIELD bzi07
       IF NOT cl_null(g_bzi[l_ac].bzi07) THEN
          IF cl_null(g_bzi_t.bzi07) OR 
             (g_bzi[l_ac].bzi07 != g_bzi_o.bzi07 ) THEN
             IF g_bzi[l_ac].bzi07 < g_bzh.bzh02 THEN
                CALL cl_err(g_bzi[l_ac].bzi07,'abx-022',0)
                LET g_bzi[l_ac].bzi07 = g_bzi_o.bzi07
                NEXT FIELD bzi07
             END IF
          END IF
          LET g_bzi_o.bzi07 = g_bzi[l_ac].bzi07
       END IF   
 
       #No.FUN-840202 --start--
        AFTER FIELD bziud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bziud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
       
    BEFORE DELETE 
       IF g_bzi_t.bzi02 > 0 AND NOT cl_null(g_bzi_t.bzi02) THEN
          IF NOT cl_delb(0,0) THEN
             CANCEL DELETE
          END IF
          IF l_lock_sw = "Y" THEN
             CALL cl_err("", -263, 1)
             CANCEL DELETE
          END IF
          DELETE FROM bzi_file
           WHERE bzi01 = g_bzh.bzh01 
             AND bzi02 = g_bzi_t.bzi02
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_bzi_t.bzi02,SQLCA.sqlcode,0)
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          LET g_rec_b=g_rec_b-1
          DISPLAY g_rec_b TO FORMONLY.cn2
       END IF
       COMMIT WORK
 
    ON ROW CHANGE
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_bzi[l_ac].* = g_bzi_t.*
          CLOSE i504_bcl
          ROLLBACK WORK
          EXIT INPUT
       END IF
       CALL i504_chk_bzi04(p_cmd)
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_bzi[l_ac].bzi04,g_errno,0)
          LET g_bzi[l_ac].bzi04 = g_bzi_o.bzi04
          DISPLAY BY NAME g_bzi[l_ac].bzi04
          NEXT FIELD bzi04
       END IF
       CALL i504_chk_bzi05(p_cmd)
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_bzi[l_ac].bzi05,g_errno,0)
          LET g_bzi[l_ac].bzi05 = g_bzi_o.bzi05
          DISPLAY BY NAME g_bzi[l_ac].bzi05
          NEXT FIELD bzi05
       END IF
       IF l_lock_sw = 'Y' THEN
          CALL cl_err(g_bzi[l_ac].bzi02,-263,1)
          LET g_bzi[l_ac].* = g_bzi_t.*
       ELSE
          UPDATE bzi_file SET bzi02=g_bzi[l_ac].bzi02,
                                 bzi03=g_bzi[l_ac].bzi03,
                                 bzi04=g_bzi[l_ac].bzi04,
                                 bzi05=g_bzi[l_ac].bzi05,
                                 bzi06=g_bzi[l_ac].bzi06,
                                 bzi07=g_bzi[l_ac].bzi07,
                                 bzi08=g_bzi[l_ac].bzi08,
                                 bzi09=g_bzi[l_ac].bzi09,
                                #FUN-840202 --start--
                                bziud01 = g_bzi[l_ac].bziud01,
                                bziud02 = g_bzi[l_ac].bziud02,
                                bziud03 = g_bzi[l_ac].bziud03,
                                bziud04 = g_bzi[l_ac].bziud04,
                                bziud05 = g_bzi[l_ac].bziud05,
                                bziud06 = g_bzi[l_ac].bziud06,
                                bziud07 = g_bzi[l_ac].bziud07,
                                bziud08 = g_bzi[l_ac].bziud08,
                                bziud09 = g_bzi[l_ac].bziud09,
                                bziud10 = g_bzi[l_ac].bziud10,
                                bziud11 = g_bzi[l_ac].bziud11,
                                bziud12 = g_bzi[l_ac].bziud12,
                                bziud13 = g_bzi[l_ac].bziud13,
                                bziud14 = g_bzi[l_ac].bziud14,
                                bziud15 = g_bzi[l_ac].bziud15
                                #FUN-840202 --end-- 
           WHERE bzi01=g_bzh.bzh01 AND bzi02=g_bzi_t.bzi02
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             CALL cl_err(g_bzi[l_ac].bzi02,SQLCA.sqlcode,0)
             LET g_bzi[l_ac].* = g_bzi_t.*
          ELSE
             MESSAGE 'UPDATE O.K'
             COMMIT WORK
          END IF
       END IF
      
    AFTER ROW
       DISPLAY  "AFTER ROW!!" 
       LET l_ac = ARR_CURR()
       IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd = 'u' THEN
             LET g_bzi[l_ac].* = g_bzi_t.*
          #FUN-D30034--add--begin--
          ELSE
             CALL g_bzi.deleteElement(l_ac)
             IF g_rec_b != 0 THEN
                LET g_action_choice = "detail"
                LET l_ac = l_ac_t
             END IF
          #FUN-D30034--add--end----
          END IF
          CLOSE i504_bcl
          ROLLBACK WORK
          EXIT INPUT
       END IF
       LET l_ac_t = l_ac  #FUN-D30034 add
       CLOSE i504_bcl
       COMMIT WORK
 
    ON ACTION CONTROLO                        #沿用所有欄位
       IF INFIELD(bzi02) AND l_ac > 1 THEN
          LET g_bzi[l_ac].* = g_bzi[l_ac-1].*
          DISPLAY BY NAME g_bzi[l_ac].*    #印出畫面，並確保資料存在
          LET g_bzi[l_ac].bzi02 = g_bzi_t.bzi02 
          NEXT FIELD bzi02
       END IF
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
      
    ON ACTION controlp
       CASE
         WHEN INFIELD(bzi03) 
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_bzb"
              LET g_qryparam.default1 = g_bzi[l_ac].bzi03
              LET g_qryparam.default2 = g_bzi[l_ac].bzi04
              CALL cl_create_qry() RETURNING g_bzi[l_ac].bzi03,g_bzi[l_ac].bzi04
              DISPLAY BY NAME g_bzi[l_ac].bzi03,g_bzi[l_ac].bzi04
              IF NOT cl_null(g_bzi[l_ac].bzi03) AND 
                 NOT cl_null(g_bzi[l_ac].bzi04) THEN
                 CALL i504_showfield()
                 CALL i504_gem02('a')
                 CALL i504_gen02('a')
              END IF
              NEXT FIELD bzi03
         WHEN INFIELD(bzi04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_bzb"
              LET g_qryparam.default1 = g_bzi[l_ac].bzi03
              LET g_qryparam.default2 = g_bzi[l_ac].bzi04
              CALL cl_create_qry() RETURNING g_bzi[l_ac].bzi03,g_bzi[l_ac].bzi04
              DISPLAY BY NAME g_bzi[l_ac].bzi03,g_bzi[l_ac].bzi04
              NEXT FIELD bzi04
          OTHERWISE EXIT CASE
       END CASE
 
    ON ACTION CONTROLF
       CALL cl_set_focus_form(ui.Interface.getRootNode()) 
            RETURNING g_fld_name,g_frm_name 
       CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
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
  CLOSE i504_bcl
  COMMIT WORK
  CALL i504_delHeader()     #CHI-C30002 add
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION i504_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_bzh.bzh01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM bzh_file ",
                  "  WHERE bzh01 LIKE '",l_slip,"%' ",
                  "    AND bzh01 > '",g_bzh.bzh01,"'"
      PREPARE i504_pb1 FROM l_sql 
      EXECUTE i504_pb1 INTO l_cnt      
      
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
         #CALL i504_x() #FUN-D20025 mark
         CALL i504_x(1) #FUN-D20025 add
         CALL i504_pic()
      END IF 
      
      IF l_cho = 3 THEN    
      #CHI-C80041---end 
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  bzh_file WHERE bzh01 = g_bzh.bzh01
         INITIALIZE g_bzh.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#檢查機器設備
FUNCTION i504_chk_bzi03(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1,
          l_bzaacti   LIKE bza_file.bzaacti
 
   LET g_errno = '' 
   SELECT bzaacti INTO l_bzaacti
     FROM bza_file
    WHERE bza01 = g_bzi[l_ac].bzi03
   CASE WHEN SQLCA.SQLCODE = 100  
             LET g_errno = 'abx-019' 
             LET l_bzaacti = NULL
        WHEN l_bzaacti <> 'Y'
             LET g_errno = '9028' 
        OTHERWISE          
             LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
#檢查機器設備,序號
FUNCTION i504_chk_bzi04(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1,
          l_n            LIKE type_file.num5
 
   LET g_errno = '' 
   LET l_n = 0
   SELECT count(*) INTO l_n FROM bzb_file 
    WHERE bzb02 = g_bzi[l_ac].bzi04
      AND bzb01 = g_bzi[l_ac].bzi03
   IF l_n IS NULL THEN LET l_n = 0 END IF
   IF l_n <= 0 THEN
      LET g_errno = 'abx-023'
   END IF
END FUNCTION
 
#檢查外送數量
FUNCTION i504_chk_bzi05(p_cmd)
  DEFINE  p_cmd              LIKE type_file.chr1,               #u=修改
          l_qty              LIKE bzb_file.bzb05,  #數量(計算後)
          l_bzb05         LIKE bzb_file.bzb05,  #數量
          l_bzb10         LIKE bzb_file.bzb10,  #外送數量
          l_bzi05         LIKE bzi_file.bzi05,  #該單總外送數量
          l_bzi08         LIKE bzb_file.bzb11,  #總收回數量
          l_bzb12         LIKE bzb_file.bzb12,  #報廢數量
          l_bzb13         LIKE bzb_file.bzb13   #除帳數量
        
  LET g_errno = ''
  IF g_bzi[l_ac].bzi05 <= 0 THEN
     LET g_errno = '-32406'
  ELSE
     #機器設備編號+項次的數量bzb05,外送數量,總收回數量,報廢數量,除帳數量
     LET l_bzb05 = 0
     SELECT bzb05,bzb10,bzb11,bzb12,bzb13
       INTO l_bzb05,l_bzb10,l_bzi08,l_bzb12,l_bzb13
       FROM bzb_file
      WHERE bzb01 = g_bzi[l_ac].bzi03
        AND bzb02 = g_bzi[l_ac].bzi04
     IF l_bzb05 IS NULL THEN LET l_bzb05 = 0 END IF
     IF l_bzb10 IS NULL THEN LET l_bzb10 = 0 END IF
     IF l_bzi08 IS NULL THEN LET l_bzi08 = 0 END IF
     IF l_bzb12 IS NULL THEN LET l_bzb12 = 0 END IF
     IF l_bzb13 IS NULL THEN LET l_bzb13 = 0 END IF
     #該單總外送數量(bzi05)(排除自己本身)
     LET l_bzi05 = 0
     SELECT SUM(bzi05)INTO l_bzi05
       FROM bzh_file,bzi_file
      WHERE bzh06 != 'X' 
        AND bzh01 = bzi01
        AND bzh01 = g_bzh.bzh01
        AND bzi03 = g_bzi[l_ac].bzi03
        AND bzi04 = g_bzi[l_ac].bzi04
        AND NOT(bzi01 = g_bzh.bzh01 AND bzi02 = g_bzi_t.bzi02)
     IF l_bzi05 IS NULL THEN LET l_bzi05 = 0 END IF
     #外送數量
     LET l_qty = l_bzb05 - l_bzi05 - l_bzb10 + l_bzi08 - l_bzb12 - l_bzb13
     #檢查是否超過量
     IF g_bzi[l_ac].bzi05 > l_qty THEN
        LET g_errno = 'abx-024'
     END IF
  END IF
END FUNCTION
 
FUNCTION i504_b_fill(p_wc2)
  DEFINE  p_wc2  STRING
 
  LET g_sql = "SELECT bzi02,bzi03,bzi04,'','','','','','','', ",
              "       bzi05,bzi06,bzi07,bzi08,bzi09 ",
              #No.FUN-840202 --start--
              ",bziud01,bziud02,bziud03,bziud04,bziud05,",
              "bziud06,bziud07,bziud08,bziud09,bziud10,",
              "bziud11,bziud12,bziud13,bziud14,bziud15", 
              #No.FUN-840202 ---end---
              "  FROM bzi_file",
              " WHERE bzi01 = '",g_bzh.bzh01,"' ",
              "   AND ", p_wc2 CLIPPED,
              " ORDER BY bzi02,bzi03,bzi04 " 
  
  PREPARE i504_pb FROM g_sql
  DECLARE bzi_cs CURSOR FOR i504_pb
 
  CALL g_bzi.clear()
  LET g_cnt = 1
  FOREACH bzi_cs INTO g_bzi[g_cnt].*   #單身 ARRAY 填充
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
    END IF
    LET l_ac = g_cnt    #確保找出bza、gen的資料
    CALL i504_showfield()
    CALL i504_gem02('d')
    CALL i504_gen02('d')
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err( 'foreach:', 9035, 0 )
       EXIT FOREACH
    END IF
  END FOREACH
  CALL g_bzi.deleteElement(g_cnt)
  LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cnt2
  LET g_cnt = 0   
END FUNCTION
 
#檢查確認人
FUNCTION i504_bzh04(p_cmd)
  DEFINE
        l_gen02   LIKE gen_file.gen02,
        l_genacti LIKE gen_file.genacti,
        p_cmd          LIKE type_file.chr1
  LET g_errno = " "
  SELECT gen02,genacti
    INTO l_gen02,l_genacti
    FROM gen_file WHERE gen01 = g_bzh.bzh04
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                         LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gen02 TO bzh04_1
  END IF
END FUNCTION
 
#秀出bza和bzb相關欄位的資料
FUNCTION i504_showfield()
  SELECT bza02,bza03,bza04,bzb03,bzb04
    INTO g_bzi[l_ac].bza02,g_bzi[l_ac].bza03,
         g_bzi[l_ac].bza04,
         g_bzi[l_ac].bzb03,g_bzi[l_ac].bzb04
    FROM bza_file,bzb_file
   WHERE bza01 = bzb01
     AND bzb01 = g_bzi[l_ac].bzi03 
     AND bzb02 = g_bzi[l_ac].bzi04
  DISPLAY BY NAME g_bzi[l_ac].bza02,g_bzi[l_ac].bza03,
                  g_bzi[l_ac].bza04,
                  g_bzi[l_ac].bzb03,g_bzi[l_ac].bzb04
END FUNCTION
 
#保管部門
FUNCTION i504_gem02(p_cmd)
  DEFINE 
         l_gem02   LIKE gem_file.gem02,
         l_gemacti LIKE gem_file.gemacti,
         p_cmd          LIKE type_file.chr1
 
  LET g_errno = " "
  SELECT gem02,gemacti
    INTO l_gem02,l_gemacti
    FROM gem_file WHERE gem01 = g_bzi[l_ac].bzb03
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                          LET l_gem02 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_bzi[l_ac].gem02 = l_gem02
     DISPLAY BY NAME g_bzi[l_ac].gem02
  END IF
END FUNCTION
 
#保管人
FUNCTION i504_gen02(p_cmd)
  DEFINE
        l_gen02   LIKE gen_file.gen02,
        l_genacti LIKE gen_file.genacti,
        p_cmd          LIKE type_file.chr1
  LET g_errno = " "
  SELECT gen02,genacti
    INTO l_gen02,l_genacti
    FROM gen_file WHERE gen01 = g_bzi[l_ac].bzb04
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                         LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     LET g_bzi[l_ac].gen02 = l_gen02
     DISPLAY BY NAME g_bzi[l_ac].gen02
  END IF
END FUNCTION
 
#刪除
FUNCTION i504_r()
  DEFINE  l_n  LIKE type_file.num10
  IF s_shut(0) THEN
     RETURN
  END IF
  IF cl_null(g_bzh.bzh01) THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
  SELECT * INTO g_bzh.* FROM bzh_file
   WHERE bzh01=g_bzh.bzh01
  IF g_bzh.bzh06 ='Y' THEN               #檢查資料是否為確認
     CALL cl_err(g_bzh.bzh01,'9021',0)
     RETURN
  END IF
  IF g_bzh.bzh06 ='X' THEN               #檢查資料是否為作廢
     CALL cl_err(g_bzh.bzh01,'9021',0)
     RETURN
  END IF
  MESSAGE ""
  CALL cl_opmsg('r')
 
  BEGIN WORK
    OPEN i504_cl USING g_bzh.bzh01
    IF STATUS THEN
       CALL cl_err("OPEN i504_cl:", STATUS, 1)
       CLOSE i504_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i504_cl INTO g_bzh.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
    END IF
    CALL i504_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bzh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bzh.bzh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM bzh_file WHERE bzh01 = g_bzh.bzh01
       DELETE FROM bzi_file WHERE bzi01 = g_bzh.bzh01
       CLEAR FORM
       CALL g_bzi.clear()
       INITIALIZE g_bzh.* TO NULL
       OPEN i504_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i504_cs
          CLOSE i504_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i504_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i504_cs
          CLOSE i504_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i504_cs
       IF g_curs_index = g_row_count + 1 THEN   #刪除最後一筆row資料
          LET g_jump = g_row_count
          CALL i504_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i504_fetch('/')
       END IF
    END IF
    CLOSE i504_cl
    COMMIT WORK
END FUNCTION
 
#確認
FUNCTION i504_y() #when g_bzh.bzh06='N' (Turn to 'Y')    
   DEFINE     l_cnt    LIKE type_file.num5
  
   #CHI-C30107 ---------- add --------- begin
   IF cl_null(g_bzh.bzh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #IF SQLCA.SQLCODE THEN
   #   CALL cl_err('',100,0)
   #   RETURN
   #END IF
   IF g_bzh.bzh06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_bzh.bzh06 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   #CHI-C30107 ---------- add --------- end
   IF cl_null(g_bzh.bzh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_bzh.* FROM bzh_file WHERE bzh01 = g_bzh.bzh01
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',100,0)
      RETURN
   END IF
   IF g_bzh.bzh06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_bzh.bzh06 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   
   #無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM bzi_file
    WHERE bzi01=g_bzh.bzh01
   IF l_cnt=0 OR cl_null(l_cnt) THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
   CALL i504_update_yz('y')
END FUNCTION
 
#取消確認
FUNCTION i504_z() #when g_bzh.bzh06='Y' (Turn to 'N')
   DEFINE l_n LIKE type_file.num5   
    
   IF cl_null(g_bzh.bzh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF      
   SELECT * INTO g_bzh.* FROM bzh_file WHERE bzh01 = g_bzh.bzh01
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',100,0)
      RETURN
   END IF
   IF g_bzh.bzh06 = 'N' THEN CALL cl_err('',9002,0) RETURN END IF
   IF g_bzh.bzh06 = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   
   #判斷外送單是否有在收回單，而且收回單不為作廢
   LET l_n = 0
   SELECT count(*) INTO l_n
     FROM bzj_file,bzk_file
    WHERE bzj01 = bzk01
      AND bzj06 != 'X' 
      AND bzk03 = g_bzh.bzh01
   IF l_n IS NULL THEN LET l_n = 0 END IF
   IF l_n > 0 THEN
      CALL cl_err('','abx-025',0)
      RETURN
   END IF
 
   CALL i504_update_yz('z')   
END FUNCTION
 
FUNCTION i504_update_yz(p_cmd)
  DEFINE p_cmd              LIKE type_file.chr1,
         l_n                LIKE type_file.num10,
         l_total_bzb07   LIKE bzb_file.bzb07,
         l_qty              LIKE bzb_file.bzb05, #數量
         l_chk_qty          LIKE bzb_file.bzb05, #數量
         l_bzb10         LIKE bzb_file.bzb10, #外送數量
         l_bzb11         LIKE bzb_file.bzb11, #總收回數量
         l_bzb12         LIKE bzb_file.bzb12, #報廢數量
         l_bzb13         LIKE bzb_file.bzb13, #除帳數量
         l_gen02         LIKE gen_file.gen02, #CHI-C80072 add
         l_bzi           RECORD      
               bzi02        LIKE bzi_file.bzi02,
               bzi03        LIKE bzi_file.bzi03,       
               bzi04        LIKE bzi_file.bzi04,
               bzi05        LIKE bzi_file.bzi05    
                            END RECORD 
                            
   BEGIN WORK 
   OPEN i504_cl USING g_bzh.bzh01
   IF STATUS THEN
      CALL cl_err("OPEN i504_cl:", STATUS, 1)
      CLOSE i504_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i504_cl INTO g_bzh.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i504_cl ROLLBACK WORK RETURN
   END IF
   LET g_bzh_t.* = g_bzh.*   #備份值
   LET g_success = 'Y'
 
   LET g_bzh.bzhmodu = g_user
   LET g_bzh.bzhdate = g_today
 
   IF p_cmd = 'y' THEN
      #輸入確認人和確認日期
      LET g_bzh.bzh04 = g_user
      LET g_bzh.bzh05 = g_today
    #CHI-C80072--mark--str--
    # CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
    # INPUT BY NAME g_bzh.bzh04,g_bzh.bzh05 WITHOUT DEFAULTS
    #  AFTER FIELD bzh04
    #    IF NOT cl_null(g_bzh.bzh04) THEN
    #       IF cl_null(g_bzh_t.bzh04) OR 
    #          (g_bzh.bzh04 != g_bzh_o.bzh04 ) THEN
    #          SELECT COUNT(*) INTO l_n FROM gen_file WHERE gen01 = g_bzh.bzh04 
    #          IF l_n < = 0 THEN
    #             CALL cl_err(g_bzh.bzh04,'aap-038',0)
    #             LET g_bzh.bzh04 = g_bzh_o.bzh04
    #             NEXT FIELD bzh04
    #          ELSE 
    #             CALL i504_bzh04('a')
    #             IF NOT cl_null(g_errno) THEN
    #                CALL cl_err(g_bzh.bzh04,'aap-038',0)
    #                LET g_bzh.bzh04 = g_bzh_t.bzh04
    #                DISPLAY BY NAME g_bzh.bzh04
    #             END IF
    #          END IF
    #       END IF
    #       LET g_bzh_o.bzh04 = g_bzh.bzh04
    #    END IF
    #    
    #  AFTER FIELD bzh05
    #    IF NOT cl_null(g_bzh.bzh05) THEN        #確認日期不可小於單據日期
    #       IF cl_null(g_bzh_t.bzh05) OR
    #          (g_bzh.bzh05 != g_bzh_o.bzh05 ) THEN
    #          IF g_bzh.bzh05 < g_bzh.bzh02 THEN
    #             CALL cl_err(g_bzh.bzh05,'abx-026',0)
    #             LET g_bzh.bzh05 = g_bzh_o.bzh05
    #             NEXT FIELD bzh05
    #          END IF
    #       END IF
    #       LET g_bzh_o.bzh05 = g_bzh.bzh05
    #    END IF
    #  
    #  AFTER INPUT
    #    IF INT_FLAG THEN
    #       CALL cl_err('',9001,0)
    #       LET g_success = 'N'
    #       EXIT INPUT
    #    END IF
    #    IF g_bzh.bzh05 < g_bzh.bzh02 THEN
    #       CALL cl_err(g_bzh.bzh05,'abx-026',0)
    #       LET g_bzh.bzh05 = g_bzh_o.bzh05
    #       NEXT FIELD bzh05
    #    END IF
 
    #  ON ACTION controlp
    #    CASE
    #      WHEN INFIELD(bzh04)
    #           CALL cl_init_qry_var()
    #           LET g_qryparam.form ="q_gen"
    #           LET g_qryparam.default1 = g_bzh.bzh04
    #           CALL cl_create_qry() RETURNING g_bzh.bzh04
    #           NEXT FIELD bzh04
    #      OTHERWISE EXIT CASE
    #    END CASE
 
    #  ON IDLE g_idle_seconds
    #    CALL cl_on_idle()
    #    CONTINUE INPUT    
 
    #  ON ACTION CONTROLG
    #    CALL cl_cmdask()
 
    #  ON ACTION about
    #    CALL cl_about()
 
    #  ON ACTION help
    #    CALL cl_show_help()
    #END INPUT
    #CHI-C80072--mark--end--
     LET g_bzh.bzh06 = 'Y'
   ELSE 
     #LET g_bzh.bzh04 = ''   #CHI-B10034
     #LET g_bzh.bzh05 = ''   #CHI-B10034
     LET g_bzh.bzh06 = 'N'
     LET g_bzh.bzh04 = g_user     #CHI-C80072 add
     LET g_bzh.bzh05 = g_today    #CHI-C80072 add
   END IF
   UPDATE bzh_file SET bzh04 = g_bzh.bzh04,
                          bzh05 = g_bzh.bzh05,
                          bzh06 = g_bzh.bzh06,
                          bzhmodu = g_bzh.bzhmodu,
                          bzhdate = g_bzh.bzhdate
    WHERE bzh01 = g_bzh.bzh01 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('update bzh06 error',SQLCA.SQLCODE,1) 
      LET g_success = 'N'
   END IF
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_bzh.bzh04   #CHI-C80072 add
   DISPLAY l_gen02 TO bzh04_1                                          #CHI-C80072 add
   #利用cursor把單身的機器編號、序號、外送數量撈出來，
   #再用foreach一筆一筆row的方式，把外送數量加到bzb_file裡面
   LET g_sql = "SELECT bzi02,bzi03,bzi04,bzi05 FROM bzi_file ",
               " WHERE bzi01 = '",g_bzh.bzh01,"' "
   PREPARE i504_pqty FROM g_sql
   DECLARE send_qty_cs CURSOR FOR i504_pqty
   LET l_ac = 1
   FOREACH send_qty_cs INTO l_bzi.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     IF p_cmd = 'y' THEN
        #機器設備編號+序號的數量
        #外送數量(bzb10),收回數量(bzb11),報廢數量(bzb12),除帳數量(bzb13)
        LET l_qty = 0
        LET l_bzb10 = 0
        LET l_bzb11 = 0
        LET l_bzb12 = 0
        LET l_bzb13 = 0
        SELECT bzb05,bzb10,bzb11,bzb12,bzb13
          INTO l_qty,l_bzb10,l_bzb11,l_bzb12,l_bzb13
          FROM bzb_file
         WHERE bzb01 = l_bzi.bzi03 
           AND bzb02 = l_bzi.bzi04
        IF l_qty IS NULL THEN LET l_qty = 0 END IF
        IF l_bzb10 IS NULL THEN LET l_bzb10 = 0 END IF
        IF l_bzb11 IS NULL THEN LET l_bzb11 = 0 END IF
        IF l_bzb12 IS NULL THEN LET l_bzb12 = 0 END IF
        IF l_bzb13 IS NULL THEN LET l_bzb13 = 0 END IF
        LET l_chk_qty = l_qty-l_bzb10+l_bzb11-l_bzb12-l_bzb13
        IF l_bzi.bzi05 > l_chk_qty THEN
           CALL cl_err(g_bzi[l_ac].bzi05,'abx-024',0)
           LET g_success = 'N'
           EXIT FOREACH
        END IF
        UPDATE bzb_file SET bzb10 = bzb10 + l_bzi.bzi05 
         WHERE bzb01 = l_bzi.bzi03 AND bzb02 = l_bzi.bzi04
     ELSE 
        UPDATE bzb_file SET bzb10 = bzb10 - l_bzi.bzi05 
          WHERE bzb01 = l_bzi.bzi03 AND bzb02 = l_bzi.bzi04
     END IF
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('update bzb10 error',SQLCA.SQLCODE,1) 
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     UPDATE bzb_file SET bzb07 = bzb05 - bzb10 + bzb11 - bzb12 -bzb13
      WHERE bzb01 = l_bzi.bzi03 AND bzb02 = l_bzi.bzi04
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('update bzb07 error',SQLCA.SQLCODE,1) 
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     SELECT SUM(bzb07) INTO l_total_bzb07 FROM bzb_file
      WHERE bzb01 = l_bzi.bzi03
     UPDATE bza_file SET bza16 = l_total_bzb07 
      WHERE bza01 = l_bzi.bzi03
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('update bza16 error',SQLCA.SQLCODE,1) 
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     IF p_cmd ='y' THEN        #將資料存入異動檔bzp_file
        INSERT INTO bzp_file VALUES(g_bzh.bzh01,l_bzi.bzi02,
                                       g_today,'A',-1,
                                       l_bzi.bzi03,l_bzi.bzi04,
                                       l_bzi.bzi05,g_bzh.bzh05,'',
                                       g_plant,g_legal)  #FUN-980001 add
     ELSE 
        DELETE FROM bzp_file
         WHERE bzp01 = g_bzh.bzh01 
           AND bzp02 = l_bzi.bzi02
     END IF           
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err('',SQLCA.SQLCODE,0)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
   END FOREACH
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)  #顯示 COMMIT WORK 訊息
   ELSE
      ROLLBACK WORK
      LET g_bzh.* = g_bzh_t.*
      CALL cl_rbmsg(4)  #顯示 ROLLBACK WORK 訊息
   END IF
   CLOSE i504_cl
   DISPLAY BY NAME g_bzh.bzh04,g_bzh.bzh05,g_bzh.bzh06,
                   g_bzh.bzhmodu,g_bzh.bzhdate
   IF cl_null(g_bzh.bzh04) THEN
      DISPLAY '' TO FORMONLY.bzh04_1
   END IF
END FUNCTION
 
#FUNCTION i504_x() #FUN-D20025 mark
FUNCTION i504_x(p_type) #FUN-D20025 add
   DEFINE l_void    LIKE type_file.chr1  #y=要作廢，n=取消作廢
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add   
   IF cl_null(g_bzh.bzh01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_bzh.* FROM bzh_file WHERE bzh01 = g_bzh.bzh01
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',100,0)
      RETURN
   END IF
   IF g_bzh.bzh06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #FUN-D20025---begin 
    IF p_type = 1 THEN 
       IF g_bzh.bzh06='X' THEN RETURN END IF
    ELSE
       IF g_bzh.bzh06<>'X' THEN RETURN END IF
    END IF 
    #FUN-D20025---end 
   BEGIN WORK
   IF g_bzh.bzh06='X' THEN 
      LET l_void='Y'
   ELSE 
      LET l_void='N' 
   END IF
   BEGIN WORK
     OPEN i504_cl USING g_bzh.bzh01
     IF STATUS THEN
        CALL cl_err("OPEN i504_cl:", STATUS, 1)
        CLOSE i504_cl
        ROLLBACK WORK
        RETURN
     END IF
 
     FETCH i504_cl INTO g_bzh.*               # 鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        CALL cl_err(g_bzh.bzh01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i504_cl
        ROLLBACK WORK
        RETURN
     END IF
     LET g_bzh_t.* = g_bzh.*   #備份值
     LET g_success = 'Y'
 
     IF cl_void(0,0,l_void) THEN 
        IF g_bzh.bzh06='N' THEN
           LET g_bzh.bzh06 = 'X'    
        ELSE
           LET g_bzh.bzh06 = 'N'
        END IF
     END IF
     LET g_bzh.bzhmodu = g_user
     LET g_bzh.bzhdate = g_today
 
     UPDATE bzh_file SET bzh06   = g_bzh.bzh06,
                            bzhmodu = g_bzh.bzhmodu,
                            bzhdate = g_bzh.bzhdate
      WHERE bzh01 = g_bzh.bzh01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('update bzh06 error',SQLCA.SQLCODE,1) 
        LET g_success = 'N'
     END IF
     IF g_success = 'Y' THEN
        COMMIT WORK
        CALL cl_cmmsg(4)  #顯示 COMMIT WORK 訊息
     ELSE
        ROLLBACK WORK
        LET g_bzh.* = g_bzh_t.*
        CALL cl_rbmsg(4)  #顯示 ROLLBACK WORK 訊息
     END IF
     CLOSE i504_cl
     DISPLAY BY NAME g_bzh.bzh06,
                     g_bzh.bzhmodu,g_bzh.bzhdate
END FUNCTION
 
FUNCTION i504_set_entry(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_n      LIKE type_file.num10
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bzh01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i504_set_no_entry(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_n      LIKE type_file.num10
   
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bzh01",FALSE)
   END IF
END FUNCTION
 
FUNCTION i504_pic()
   DEFINE l_void LIKE type_file.chr1
   IF g_bzh.bzh06 = 'X' THEN
      LET l_void = 'Y'
   ELSE
      LET l_void = 'N'
   END IF
   CALL cl_set_field_pic(g_bzh.bzh06,"","","",l_void,"")
END FUNCTION
 
FUNCTION i504_out()
DEFINE sr RECORD 
             bzh01       LIKE bzh_file.bzh01,
             bzh02       LIKE bzh_file.bzh02,
             bzh03       LIKE bzh_file.bzh03,
             bzh04       LIKE bzh_file.bzh04,
             gen02a      LIKE gen_file.gen02,          #人員名稱
             bzh05       LIKE bzh_file.bzh05,
             bzh06       LIKE bzh_file.bzh06,
             bzi02       LIKE bzi_file.bzi02,       
             bzi03       LIKE bzi_file.bzi03,       
             bzi04       LIKE bzi_file.bzi04,
             bza02       LIKE bza_file.bza02,
             bza03       LIKE bza_file.bza03,
             bza04       LIKE bza_file.bza04,
             bzb03       LIKE bzb_file.bzb03,
             gem02       LIKE gem_file.gem02,
             bzb04       LIKE bzb_file.bzb04,
             gen02b      LIKE gen_file.gen02,
             bzi05       LIKE bzi_file.bzi05,        
             bzi06       LIKE bzi_file.bzi06,        
             bzi07       LIKE bzi_file.bzi07,        
             bzi08       LIKE bzi_file.bzi08,        
             bzi09       LIKE bzi_file.bzi09    
          END RECORD,
       l_name LIKE type_file.chr20    # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
   CALL cl_del_data(l_table)          #No.FUN-770005
   IF g_bzh.bzh01 IS NULL THEN
      CALL cl_err('','-400',1)
      RETURN
   END IF
 
   IF cl_null(g_wc) THEN
      LET g_wc=" bzh01='",g_bzh.bzh01,"'"
   END IF
 
   CALL cl_wait()
#   CALL cl_outnam('abxi504') RETURNING l_name                   #No.FUN-770005
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   LET g_sql="SELECT bzh01,bzh02,bzh03,bzh04,b.gen02,bzh05,bzh06,bzi02,",
             "       bzi03,bzi04,bza02,bza03,bza04,bzb03,a.gem02,bzb04,c.gen02,",
             "       bzi05,bzi06,bzi07,bzi08,bzi09 ",
             " FROM  bza_file,bzb_file,bzh_file,bzi_file,",
             " OUTER gem_file a,OUTER gen_file b,OUTER gen_file c",
             " WHERE bza01=bzi03 AND bzb01=bzi03 AND bzb02=bzi04",
             "   AND bzh01=bzi01 AND bzh_file.bzh04=b.gen01",
             "   AND bzb_file.bzb03=a.gem01 AND bzb_file.bzb04=c.gen01",
             "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
 
   PREPARE i504_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i504_co CURSOR FOR i504_p1        # SCROLL CURSOR
#No.FUN-770005--begin--
 
#  START REPORT i504_rep TO l_name
 
   FOREACH i504_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
         EXIT FOREACH
      END IF
#     OUTPUT TO REPORT i504_rep(sr.*)
      EXECUTE insert_prep USING
              sr.bzh01,sr.bzh02,sr.bzh03,sr.bzh04,sr.gen02a,sr.bzh05,
              sr.bzh06,sr.bzi02,sr.bzi03,sr.bzi04,sr.bza02,sr.bza03,
              sr.bza04,sr.bzb03,sr.gem02,sr.bzb04,sr.gen02b,sr.bzi05,sr.bzi06,
              sr.bzi07,sr.bzi08,sr.bzi09
   END FOREACH
#No.FUN-770005 --start--
{
   FINISH REPORT i504_rep
 
   CLOSE i504_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
}  
#No.FUN-770005 --end--
#No.FUN-770005 --start--
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'bzh01,bzh02,bzh03,bzh04,bzh05,bzh06,     
                          bzhacti,bzhuser,bzhgrup,bzhmodu,bzhdate')
           RETURNING g_wc
      LET g_str = g_wc
   END IF
   LET g_str = g_str
   LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   CALL cl_prt_cs3('abxi504','abxi504',g_sql,g_str)
END FUNCTION
#No.FUN-770005 --start--
{
REPORT i504_rep(sr)
DEFINE l_last_sw  LIKE type_file.chr1          #No.FUN-690010 VARCHAR(1),
DEFINE sr RECORD 
             bzh01       LIKE bzh_file.bzh01,
             bzh02       LIKE bzh_file.bzh02,
             bzh03       LIKE bzh_file.bzh03,
             bzh04       LIKE bzh_file.bzh04,
             gen02a      LIKE gen_file.gen02,          #人員名稱
             bzh05       LIKE bzh_file.bzh05,
             bzh06       LIKE bzh_file.bzh06,
             bzi02       LIKE bzi_file.bzi02,       
             bzi03       LIKE bzi_file.bzi03,       
             bzi04       LIKE bzi_file.bzi04,
             bza02       LIKE bza_file.bza02,
             bza03       LIKE bza_file.bza03,
             bza04       LIKE bza_file.bza04,
             bzb03       LIKE bzb_file.bzb03,
             gem02       LIKE gem_file.gem02,
             bzb04       LIKE bzb_file.bzb04,
             gen02b      LIKE gen_file.gen02,
             bzi05       LIKE bzi_file.bzi05,        
             bzi06       LIKE bzi_file.bzi06,        
             bzi07       LIKE bzi_file.bzi07,        
             bzi08       LIKE bzi_file.bzi08,        
             bzi09       LIKE bzi_file.bzi09    
          END RECORD
 
        OUTPUT
                TOP MARGIN g_top_margin
                LEFT MARGIN g_left_margin
                BOTTOM MARGIN g_bottom_margin
                PAGE LENGTH g_page_line
 
        ORDER BY sr.bzh01,sr.bzi02
 
        FORMAT
            PAGE HEADER
               PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
               PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
               LET g_pageno=g_pageno+1
               LET pageno_total=PAGENO USING '<<<',"/pageno"
               PRINT g_head CLIPPED,pageno_total
               PRINT g_dash2
               PRINT g_x[11],sr.bzh01 CLIPPED, COLUMN (g_len/2),g_x[12],sr.bzh02 CLIPPED
               PRINT g_x[14],sr.bzh04 CLIPPED,'  ',sr.gen02a CLIPPED,COLUMN (g_len/2),g_x[15],sr.bzh05 CLIPPED
               PRINT g_x[16],sr.bzh06 CLIPPED, COLUMN (g_len/2),g_x[13],sr.bzh03 CLIPPED
               PRINT g_dash
               PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                              g_x[36],g_x[39],g_x[40],g_x[41],g_x[42]
               PRINTX name=H2 g_x[43],g_x[44],g_x[45],g_x[46],g_x[47]
               PRINT g_dash1
               LET l_last_sw = 'y'
 
            BEFORE GROUP OF sr.bzh01
               SKIP TO TOP OF PAGE
 
            ON EVERY ROW
               PRINTX name=D1 COLUMN g_c[31],cl_numfor(sr.bzi02,31,0),
                              COLUMN g_c[32],sr.bzi03,
                              COLUMN g_c[33],cl_numfor(sr.bzi04,33,0),
                              COLUMN g_c[34],sr.bzb03,
                              COLUMN g_c[35],sr.bzb04,
                              COLUMN g_c[36],cl_numfor(sr.bzi05,36,0),
                              COLUMN g_c[39],sr.bzi06,
                              COLUMN g_c[40],sr.bzi07,
                              COLUMN g_c[41],cl_numfor(sr.bzi08,41,0),
                              COLUMN g_c[42],sr.bzi09
 
               PRINTX name=D2 COLUMN g_c[46],sr.gem02,
                              COLUMN g_c[47],sr.gen02b
 
            ON LAST ROW
              IF g_zz05 = 'Y' THEN PRINT g_dash
                 CALL cl_prt_pos_wc(g_wc)
              END IF
              PRINT g_dash
              LET l_last_sw = 'n'
              PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
 
        PAGE TRAILER
            IF l_last_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4] CLIPPED, COLUMN (g_len-9), g_x[5] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-770005--END--
