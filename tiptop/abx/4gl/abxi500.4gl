# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: abxi500.4gl
# Descriptions...: 保稅機器設備建立作業
# Date & Author..: 06/10/12 By kim
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-840202 08/05/09 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.TQC-8C0044 08/12/18 By clover  DISPLAY g_rec_b TO FORMONLY.cn2畫面改為cnt2
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  將cl_used()改成標準，使用g_prog
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80082 11/08/08 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-910088 11/12/31 By chenjing 增加數量欄位小數取位
# Modify.........: No:MOD-C10215 12/02/03 By ck2yuan 將bza05依不同情況預設bza16
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
  g_bza           RECORD LIKE bza_file.*,       
  g_bza_t         RECORD LIKE bza_file.*,       
  g_bza_o         RECORD LIKE bza_file.*,       
  g_bza01_t       LIKE bza_file.bza01,          
  g_bzb           DYNAMIC ARRAY OF RECORD      
      bzb02       LIKE bzb_file.bzb02,       
      bzb03       LIKE bzb_file.bzb03,       
      gem02          LIKE gem_file.gem02,
      bzb04       LIKE bzb_file.bzb04,
      gen02          LIKE gen_file.gen02,      
      bzb05       LIKE bzb_file.bzb05,        
      bzb06       LIKE bzb_file.bzb06,        
      bzb07       LIKE bzb_file.bzb07,        
      bzb08       LIKE bzb_file.bzb08,        
      bzb09       LIKE bzb_file.bzb09,      
      bzb10       LIKE bzb_file.bzb10,
      bzb11       LIKE bzb_file.bzb11,
      bzb12       LIKE bzb_file.bzb12,
      bzb13       LIKE bzb_file.bzb13,
      bzb14       LIKE bzb_file.bzb14,
      #FUN-840202 --start---
      bzbud01 LIKE bzb_file.bzbud01,
      bzbud02 LIKE bzb_file.bzbud02,
      bzbud03 LIKE bzb_file.bzbud03,
      bzbud04 LIKE bzb_file.bzbud04,
      bzbud05 LIKE bzb_file.bzbud05,
      bzbud06 LIKE bzb_file.bzbud06,
      bzbud07 LIKE bzb_file.bzbud07,
      bzbud08 LIKE bzb_file.bzbud08,
      bzbud09 LIKE bzb_file.bzbud09,
      bzbud10 LIKE bzb_file.bzbud10,
      bzbud11 LIKE bzb_file.bzbud11,
      bzbud12 LIKE bzb_file.bzbud12,
      bzbud13 LIKE bzb_file.bzbud13,
      bzbud14 LIKE bzb_file.bzbud14,
      bzbud15 LIKE bzb_file.bzbud15
      #FUN-840202 --end--
                  END RECORD,
  g_bzb_t         RECORD
      bzb02       LIKE bzb_file.bzb02,
      bzb03       LIKE bzb_file.bzb03,
      gem02          LIKE gem_file.gem02,
      bzb04       LIKE bzb_file.bzb04,
      gen02          LIKE gen_file.gen02,
      bzb05       LIKE bzb_file.bzb05,
      bzb06       LIKE bzb_file.bzb06,
      bzb07       LIKE bzb_file.bzb07,
      bzb08       LIKE bzb_file.bzb08,
      bzb09       LIKE bzb_file.bzb09,
      bzb10       LIKE bzb_file.bzb10,
      bzb11       LIKE bzb_file.bzb11,
      bzb12       LIKE bzb_file.bzb12,
      bzb13       LIKE bzb_file.bzb13,
      bzb14       LIKE bzb_file.bzb14,
      #FUN-840202 --start---
      bzbud01 LIKE bzb_file.bzbud01,
      bzbud02 LIKE bzb_file.bzbud02,
      bzbud03 LIKE bzb_file.bzbud03,
      bzbud04 LIKE bzb_file.bzbud04,
      bzbud05 LIKE bzb_file.bzbud05,
      bzbud06 LIKE bzb_file.bzbud06,
      bzbud07 LIKE bzb_file.bzbud07,
      bzbud08 LIKE bzb_file.bzbud08,
      bzbud09 LIKE bzb_file.bzbud09,
      bzbud10 LIKE bzb_file.bzbud10,
      bzbud11 LIKE bzb_file.bzbud11,
      bzbud12 LIKE bzb_file.bzbud12,
      bzbud13 LIKE bzb_file.bzbud13,
      bzbud14 LIKE bzb_file.bzbud14,
      bzbud15 LIKE bzb_file.bzbud15
                  END RECORD,
  g_bzb_o         RECORD
      bzb02       LIKE bzb_file.bzb02,
      bzb03       LIKE bzb_file.bzb03,
      gem02          LIKE gem_file.gem02,
      bzb04       LIKE bzb_file.bzb04,
      gen02          LIKE gen_file.gen02,
      bzb05       LIKE bzb_file.bzb05,
      bzb06       LIKE bzb_file.bzb06,
      bzb07       LIKE bzb_file.bzb07,
      bzb08       LIKE bzb_file.bzb08,
      bzb09       LIKE bzb_file.bzb09,
      bzb10       LIKE bzb_file.bzb10,
      bzb11       LIKE bzb_file.bzb11,
      bzb12       LIKE bzb_file.bzb12,
      bzb13       LIKE bzb_file.bzb13,
      bzb14       LIKE bzb_file.bzb14,
      #FUN-840202 --start---
      bzbud01 LIKE bzb_file.bzbud01,
      bzbud02 LIKE bzb_file.bzbud02,
      bzbud03 LIKE bzb_file.bzbud03,
      bzbud04 LIKE bzb_file.bzbud04,
      bzbud05 LIKE bzb_file.bzbud05,
      bzbud06 LIKE bzb_file.bzbud06,
      bzbud07 LIKE bzb_file.bzbud07,
      bzbud08 LIKE bzb_file.bzbud08,
      bzbud09 LIKE bzb_file.bzbud09,
      bzbud10 LIKE bzb_file.bzbud10,
      bzbud11 LIKE bzb_file.bzbud11,
      bzbud12 LIKE bzb_file.bzbud12,
      bzbud13 LIKE bzb_file.bzbud13,
      bzbud14 LIKE bzb_file.bzbud14,
      bzbud15 LIKE bzb_file.bzbud15
      #FUN-840202 --end--
                  END RECORD,
  g_rec_b         LIKE type_file.num5,                #單身筆數
  l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT
  g_forupd_sql    STRING,                  #SELECT ... FOR UPDATE SQL
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
  l_lflag         LIKE type_file.chr1
DEFINE g_argv1     LIKE bza_file.bza01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE g_bza08_t   LIKE bza_file.bza08     #FUN-910088--add--
  
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
  
  #CALL cl_used('abxi500',g_time,1)  RETURNING g_time     #FUN-B30211
  CALL cl_used(g_prog,g_time,1)  RETURNING g_time     #FUN-B30211
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
  LET g_forupd_sql = "SELECT * FROM bza_file   WHERE bza01 = ? ",
      " FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i500_cl CURSOR FROM g_forupd_sql
  LET p_row = 2 LET p_col = 9
  OPEN WINDOW i500_w AT p_row,p_col              #顯示畫面
    WITH FORM "abx/42f/abxi500" ATTRIBUTE (STYLE = g_win_style)
  CALL cl_ui_init()
  
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i500_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i500_a()
            END IF
         OTHERWISE        
            CALL i500_q() 
      END CASE
   END IF
   #--
  CALL i500_menu()
  CLOSE WINDOW i500_w                            #結束畫面
  #CALL cl_used('abxi500',g_time,2) RETURNING g_time    #FUN-B30211
   CALL cl_used(g_prog,g_time,2)  RETURNING g_time     #FUN-B30211
END MAIN
 
FUNCTION i500_menu()
   WHILE TRUE
 
     LET l_lflag ='0'
 
     CALL i500_bp("G")
     CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i500_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i500_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i500_r()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i500_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i500_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_bza.bza01) THEN
                 CALL i500_out()
              END IF
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        WHEN "exporttoexcel"
           IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bzb),'','')
           END IF
        WHEN "related_document"
          IF cl_chk_act_auth() THEN
             IF g_bza.bza01 IS NOT NULL THEN
                LET g_doc.column1 = "bza01"
                LET g_doc.value1 = g_bza.bza01
                CALL cl_doc()
             END IF
          END IF
 
     END CASE
  END WHILE
END FUNCTION 
 
FUNCTION i500_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1
 
  IF p_ud <> "G" OR g_action_choice = "detail" THEN
    RETURN
  END IF
  LET g_action_choice = " "
  CALL cl_set_act_visible("accept,cancel", FALSE)
  
  DISPLAY ARRAY g_bzb TO s_bzb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      CALL i500_fetch('F')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
    ON ACTION previous
      CALL i500_fetch('P')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    ON ACTION jump
      CALL i500_fetch('/')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
    ON ACTION next
      CALL i500_fetch('N')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL fgl_set_arr_curr(1)
    ON ACTION last
      CALL i500_fetch('L')
      CALL cl_navigator_setting(g_curs_index, g_row_count)
       CALL fgl_set_arr_curr(1)
    ON ACTION detail
      LET g_action_choice="detail"
      LET l_ac = 1
      EXIT DISPLAY
    ON ACTION output
      LET g_action_choice="output"
      EXIT DISPLAY   
    ON ACTION help
      LET g_action_choice="help"
      EXIT DISPLAY
    ON ACTION locale
       CALL cl_dynamic_locale()
#@    ON ACTION 相關文件
      ON ACTION related_document
        LET g_action_choice="related_document"
        EXIT DISPLAY
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
    ON ACTION exporttoexcel
      LET g_action_choice="exporttoexcel"
      EXIT DISPLAY
    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DISPLAY
 
    ON ACTION controls                       #No.FUN-6B0033
       CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
    END DISPLAY
 
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i500_cs()
 DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
  CLEAR FORM                             #清除畫面
  CALL g_bzb.clear()
  CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   INITIALIZE g_bza.* TO NULL    #No.FUN-750051
 IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" bza01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
 ELSE
 
  CONSTRUCT BY NAME g_wc ON bza01,bza02,bza03,bza04,bza05,bza06,
                            bza07,bza08,bza09,bza10,bza11,bza12,
                            bza13,bza14,bza15,bza16,
                            bzauser,bzamodu,bzagrup,bzadate,bzaacti,
                           #FUN-840202   ---start---
                            bzaud01,bzaud02,bzaud03,bzaud04,bzaud05,
                            bzaud06,bzaud07,bzaud08,bzaud09,bzaud10,
                            bzaud11,bzaud12,bzaud13,bzaud14,bzaud15
                           #FUN-840202    ----end----
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
                            
    ON ACTION controlp
      CASE
         WHEN INFIELD(bza06)
           CALL cl_init_qry_var()
           LET g_qryparam.state = 'c'
           LET g_qryparam.form ="q_bza"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO bza06
           NEXT FIELD bza06
         WHEN INFIELD(bza08)
           CALL cl_init_qry_var()
           LET g_qryparam.state = 'c'
           LET g_qryparam.form ="q_gfe"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO bza08
           NEXT FIELD bza08
         OTHERWISE EXIT CASE
      END CASE
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
  END CONSTRUCT 
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bzauser', 'bzagrup') #FUN-980030
  IF INT_FLAG THEN
     RETURN                         #不設成0，因為回到i500_b()還要再判斷一次
  END IF
 
 
  CONSTRUCT g_wc2 ON bzb02,bzb03,bzb04,bzb05,bzb06,bzb07,
                     bzb08,bzb09,bzb10,
                     bzb11,bzb12,bzb13,bzb14
                   #No.FUN-840202 --start--
                    ,bzbud01,bzbud02,bzbud03,bzbud04,bzbud05
                    ,bzbud06,bzbud07,bzbud08,bzbud09,bzbud10
                    ,bzbud11,bzbud12,bzbud13,bzbud14,bzbud15
                   #No.FUN-840202 ---end---
            FROM s_bzb[1].bzb02,s_bzb[1].bzb03,s_bzb[1].bzb04,
                 s_bzb[1].bzb05,s_bzb[1].bzb06,s_bzb[1].bzb07,
                 s_bzb[1].bzb08,s_bzb[1].bzb09,s_bzb[1].bzb10,
                 s_bzb[1].bzb11,s_bzb[1].bzb12,s_bzb[1].bzb13,
                 s_bzb[1].bzb14
            #No.FUN-840202 --start--
                ,s_bzb[1].bzbud01,s_bzb[1].bzbud02,s_bzb[1].bzbud03,s_bzb[1].bzbud04,s_bzb[1].bzbud05
                ,s_bzb[1].bzbud06,s_bzb[1].bzbud07,s_bzb[1].bzbud08,s_bzb[1].bzbud09,s_bzb[1].bzbud10
                ,s_bzb[1].bzbud11,s_bzb[1].bzbud12,s_bzb[1].bzbud13,s_bzb[1].bzbud14,s_bzb[1].bzbud15
            #No.FUN-840202 ---end---
 
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
    ON ACTION controlp
      CASE
            WHEN INFIELD(bzb03)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_gem"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              NEXT FIELD bzb03
            WHEN INFIELD(bzb04)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_gen"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              NEXT FIELD bzb04
            OTHERWISE EXIT CASE
      END CASE
    ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
      ON ACTION qbe_save
          CALL cl_qbe_save()
  END CONSTRUCT
  IF INT_FLAG THEN
    RETURN
  END IF
 END IF  #FUN-7C0050
 
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN               #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND bzauser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN               #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND bzagrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
  IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
     LET g_sql = "SELECT  bza01 FROM bza_file ",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY bza01"
  ELSE                                    # 若單身有輸入條件
     LET g_sql = "SELECT UNIQUE bza_file. bza01 ",
                 "  FROM bza_file, bzb_file ",
                 " WHERE bza01 = bzb01",
                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY bza01"
  END IF
 
  PREPARE i500_prepare FROM g_sql
  DECLARE i500_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i500_prepare
  IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
     LET g_sql="SELECT COUNT(*) FROM bza_file WHERE ",g_wc CLIPPED
  ELSE
     LET g_sql="SELECT COUNT(DISTINCT bza01) FROM bza_file,bzb_file WHERE ",
               "bzb01=bza01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
  END IF
  PREPARE i500_precount FROM g_sql
  DECLARE i500_count CURSOR FOR i500_precount
END FUNCTION
 
FUNCTION i500_a()
  MESSAGE ""
  CLEAR FORM
  CALL g_bzb.clear()
  IF s_shut(0) THEN
     RETURN
  END IF
 
  INITIALIZE g_bza.* LIKE bza_file.*             #DEFAULT 設定
  LET g_bza01_t = NULL
  LET g_bza_t.* = g_bza.*
  LET g_bza_o.* = g_bza.*
  LET g_bza08_t = NULL        #FUN-910088--add--
  LET g_bza.bza09   = 1
 #LET g_bza.bza16   = 0   #MOD-C10215 mark
  LET g_bza.bza16   = 1   #MOD-C10215 add
  
  CALL cl_opmsg('a')
 
  WHILE TRUE
    LET g_bza.bzauser=g_user
    LET g_bza.bzagrup=g_grup
    LET g_bza.bzadate=g_today
    LET g_bza.bzaacti='Y'              #資料有效
 
    CALL i500_i("a")                   #輸入單頭
    IF INT_FLAG THEN                   #使用者中斷
      CLEAR FORM
      INITIALIZE g_bza.* TO NULL
      LET INT_FLAG = 0
      CALL cl_err('',9001,0)
      EXIT WHILE
    END IF
    IF cl_null(g_bza.bza01) THEN       # KEY 不可空白
      CONTINUE WHILE
    END IF
    
    BEGIN WORK
      LET g_bza.bzaoriu = g_user      #No.FUN-980030 10/01/04
      LET g_bza.bzaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO bza_file VALUES (g_bza.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN          #置入資料庫不成功
         CALL cl_err(g_bza.bza01,SQLCA.sqlcode,1)          #No.FUN-B80082---調整至回滾事務前---
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK       
      END IF
 
     SELECT bza01 INTO g_bza.bza01 FROM bza_file
      WHERE bza01 = g_bza.bza01
     LET g_bza01_t = g_bza.bza01                     #保留舊值
     LET g_bza_t.* = g_bza.*
     LET g_bza_o.* = g_bza.*
 
     CALL g_bzb.clear()
     LET g_rec_b = 0 
     CALL i500_b()
     EXIT WHILE
  END WHILE     
END FUNCTION
 
FUNCTION i500_i(p_cmd)
  DEFINE
    l_n            LIKE type_file.num5,
    p_cmd          LIKE type_file.chr1                #a:輸入 u:更改

 
  IF s_shut(0) THEN
    RETURN
  END IF
  CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
  INPUT BY NAME g_bza.bza01,g_bza.bza02,g_bza.bza03,
                g_bza.bza04,g_bza.bza05,g_bza.bza06,
                g_bza.bza07,g_bza.bza08,g_bza.bza09,
                g_bza.bza10,g_bza.bza11,g_bza.bza12,
                g_bza.bza13,g_bza.bza14,g_bza.bza15,
                g_bza.bza16,
                g_bza.bzauser,g_bza.bzamodu,g_bza.bzagrup,
                g_bza.bzadate,g_bza.bzaacti,
              #FUN-840202     ---start---
                g_bza.bzaud01,g_bza.bzaud02,g_bza.bzaud03,g_bza.bzaud04,
                g_bza.bzaud05,g_bza.bzaud06,g_bza.bzaud07,g_bza.bzaud08,
                g_bza.bzaud09,g_bza.bzaud10,g_bza.bzaud11,g_bza.bzaud12,
                g_bza.bzaud13,g_bza.bzaud14,g_bza.bzaud15 
              #FUN-840202     ----end----
    WITHOUT DEFAULTS
 
    BEFORE INPUT
      LET g_before_input_done = FALSE
      CALL i500_set_entry(p_cmd)
      CALL i500_set_no_entry(p_cmd)
      LET g_before_input_done = TRUE
      
    AFTER FIELD bza01
      IF NOT cl_null(g_bza.bza01) THEN
        #新增或是修改key值時才檢查key值是否重覆於table中
        IF p_cmd = 'a' OR ( p_cmd ='u' AND g_bza.bza01 != g_bza01_t) THEN      
           SELECT count(*) INTO l_n FROM bza_file 
            WHERE bza01 = g_bza.bza01
          IF l_n > 0 THEN  
             CALL cl_err(g_bza.bza01,-239,0)
             LET g_bza.bza01 = g_bza01_t
             DISPLAY BY NAME g_bza.bza01
             NEXT FIELD bza01
          END IF
        END IF   
        IF g_bza.bza05='1' THEN
           LET g_bza.bza06 = g_bza.bza01
           DISPLAY BY NAME g_bza.bza06
        END IF
      END IF
 
    BEFORE FIELD bza05
      CALL i500_set_entry(p_cmd)
 
    AFTER FIELD bza05
      IF NOT cl_null(g_bza.bza05) THEN
         IF g_bza.bza05 = '1' THEN
            LET g_bza.bza06 = g_bza.bza01
            DISPLAY BY NAME g_bza.bza06
         END IF
      END IF
      #--- 將set_no_entry放在所有判斷之外   
      CALL i500_set_no_entry(p_cmd)
 
     #---如主件被參照到,開放bza05,show出警告訊息,LET bza05=1
      IF l_lflag = '1' THEN
         CALL cl_err('','abx-014',1)
         LET g_bza.bza05 = '1'
         DISPLAY BY NAME g_bza.bza05
         LET l_lflag = '0'
      END IF
  
    AFTER FIELD bza06
      IF NOT cl_null(g_bza.bza06) THEN
        IF cl_null(g_bza_t.bza06) 
           OR (g_bza.bza06 != g_bza_o.bza06 ) THEN
           SELECT count(*) INTO l_n FROM bza_file
             WHERE bza01 = g_bza.bza06 AND bza05 = '1'
           IF l_n = 0 THEN      
              CALL cl_err(g_bza.bza06,'mfg9329',0)
              LET g_bza.bza06 = g_bza_o.bza06
              NEXT FIELD bza06
           END IF
           #主件編號不可等於機器設備編號
           IF g_bza.bza05 = 2 AND g_bza.bza06 = g_bza.bza01 THEN
              CALL cl_err(g_bza.bza06,'abx-015',0)
              NEXT FIELD bza06
           END IF
        END IF
      LET g_bza_o.bza06 = g_bza.bza06 
      END IF
 
    AFTER FIELD bza08
      IF NOT cl_null(g_bza.bza08) THEN
        IF cl_null(g_bza_t.bza08) 
           OR (g_bza.bza08 != g_bza_o.bza08 ) THEN
           SELECT count(*) INTO l_n FROM gfe_file
	     WHERE g_bza.bza08 = gfe01
	   IF l_n = 0 THEN
             CALL cl_err(g_bza.bza08,'mfg9329',0)
             LET g_bza.bza08 = g_bza_o.bza08
             NEXT FIELD bza08
           END IF
        END IF
     #FUN-910088--add--start--
       #IF NOT i500_bza09_check() THEN        #MOD-C10215 mark
        IF NOT i500_bza09_check(p_cmd) THEN   #MOD-C10215 add
           LET g_bza08_t = g_bza.bza08
           LET g_bza_o.bza08 = g_bza.bza08
           NEXT FIELD bza09
        END IF
        LET g_bza08_t = g_bza.bza08
     #FUN-910088--add--end--
      LET g_bza_o.bza08 = g_bza.bza08
      END IF
   
    AFTER FIELD bza09
      #IF NOT i500_bza09_check() THEN NEXT FIELD bza09 END IF     #FUN-910088--add-- #MOD-C10215 mark
       IF NOT i500_bza09_check(p_cmd) THEN NEXT FIELD bza09 END IF                   #MOD-C10215 add
   #FUN-910088--mark-start--
   #  IF NOT cl_null(g_bza.bza09) THEN
   #    IF g_bza.bza09 <=0 THEN
   #      CALL cl_err(g_bza.bza09,-32406,1)
   #      LET g_bza.bza09 = g_bza_o.bza09
   #      NEXT FIELD bza09
   #    END IF
   #  LET g_bza_o.bza09 = g_bza.bza09
   #  END IF 
   #FUN-910088--mark--end--
  
    AFTER FIELD bza10
      IF NOT cl_null(g_bza.bza10) THEN
        IF g_bza.bza10 <= 0 THEN
          CALL cl_err(g_bza.bza10,-32406,1)
          LET g_bza.bza10 = g_bza_o.bza10
          NEXT FIELD bza10
        END IF
      LET g_bza_o.bza10 = g_bza.bza10
      END IF
 
        #FUN-840202     ---start---
        AFTER FIELD bzaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
    AFTER INPUT 
      IF INT_FLAG THEN
        INITIALIZE g_bza.* TO NULL
        CALL cl_err('',9001,0)
        RETURN
      END IF
 
      IF g_bza.bza05 = 2 AND cl_null(g_bza.bza06) THEN
        CALL cl_err(g_bza.bza06,'abx-015',0)
        NEXT FIELD bza06
      END IF
      IF g_bza.bza05 = 2 AND g_bza.bza01 = g_bza.bza06 THEN
        CALL cl_err(g_bza.bza06,'abx-015',0)
        NEXT FIELD bza06
      END IF
      #新增時不跑下面程式(修改過bza01時，判斷bza06是否合法)
      IF g_bza.bza01!=g_bza01_t AND g_bza.bza05 = '2' AND   
         g_bza.bza06 = g_bza01_t AND NOT cl_null(g_bza01_t) THEN
         CALL cl_err(g_bza.bza06,'abx-016',0)
         NEXT FIELD bza06
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
           WHEN INFIELD(bza06)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_bza"
              LET g_qryparam.default1 = g_bza.bza06
              IF cl_null(g_bza01_t) THEN             #給p_qry中判斷用
                LET g_qryparam.arg1 = g_bza.bza01 #新增的情形
              ELSE
                LET g_qryparam.arg1 = g_bza01_t      #修改的情形
              END IF
              CALL cl_create_qry() RETURNING g_bza.bza06
              DISPLAY BY NAME g_bza.bza06
              NEXT FIELD bza06
           WHEN INFIELD(bza08)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gfe"
              LET g_qryparam.default1 = g_bza.bza08
              CALL cl_create_qry() RETURNING g_bza.bza08
              DISPLAY BY NAME g_bza.bza08
              NEXT FIELD bza08
           OTHERWISE EXIT CASE
     END CASE
     ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
  END INPUT
END FUNCTION
 
FUNCTION i500_u()
  IF s_shut(0) THEN
    RETURN
  END IF
  IF cl_null(g_bza.bza01) THEN
    CALL cl_err('',-400,0)
    RETURN
  END IF
  SELECT * INTO g_bza.* FROM bza_file
   WHERE bza01=g_bza.bza01
  IF g_bza.bzaacti ='N' THEN               #檢查資料是否為無效
    CALL cl_err(g_bza.bza01,'mfg1000',0)
    RETURN
  END IF
  MESSAGE ""
  CALL cl_opmsg('u')
  LET g_bza01_t = g_bza.bza01
  LET g_bza08_t = g_bza.bza08      #FUN-910088--add--
 
  BEGIN WORK
 
  OPEN i500_cl USING g_bza.bza01
  IF STATUS THEN
    CALL cl_err("OPEN i500_cl:", STATUS, 1)
    CLOSE i500_cl
    ROLLBACK WORK
    RETURN
  END IF
  FETCH i500_cl INTO g_bza.*                      # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
    CALL cl_err(g_bza.bza01,SQLCA.sqlcode,0)   
    CLOSE i500_cl
    ROLLBACK WORK
    RETURN
  END IF
  CALL i500_show()
  
  WHILE TRUE
    LET g_bza01_t = g_bza.bza01
    LET g_bza_o.* = g_bza.*
    LET g_bza.bzamodu=g_user
    LET g_bza.bzadate=g_today
 
    CALL i500_i("u")
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_bza.*=g_bza_t.*
      CALL i500_show()
      CALL cl_err('','9001',0)
      EXIT WHILE
    END IF
    
    IF g_bza.bza01 != g_bza01_t THEN  #更改單頭的key值，也要改單身的key值
      UPDATE bzb_file SET bzb01 = g_bza.bza01
      WHERE bzb01 = g_bza01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err('bzb',SQLCA.sqlcode,0)
        CONTINUE WHILE
      END IF
    END IF
    
    UPDATE bza_file SET bza_file.* = g_bza.*
     WHERE bza01 = g_bza01_t
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err(g_bza.bza01,SQLCA.sqlcode,0)
      CONTINUE WHILE
    ELSE
      MESSAGE 'UPDATE  SUCCESS '   
      EXIT WHILE          
    END IF
  END WHILE
 
  CLOSE i500_cl
  COMMIT WORK
END FUNCTION
 
FUNCTION i500_show()
  LET g_bza_t.* = g_bza.*                #保存單頭舊值
  LET g_bza_o.* = g_bza.*                #保存單頭舊值
  DISPLAY BY NAME g_bza.bza01,g_bza.bza02,g_bza.bza03,
                  g_bza.bza04,g_bza.bza05,g_bza.bza06,
                  g_bza.bza07,g_bza.bza08,g_bza.bza09,
                  g_bza.bza10,g_bza.bza11,g_bza.bza12,
                  g_bza.bza13,g_bza.bza14,g_bza.bza15,
                  g_bza.bza16,
                  g_bza.bzauser,g_bza.bzagrup,g_bza.bzamodu,
                  g_bza.bzadate,g_bza.bzaacti,
              #FUN-840202     ---start---
                  g_bza.bzaud01,g_bza.bzaud02,g_bza.bzaud03,g_bza.bzaud04,
                  g_bza.bzaud05,g_bza.bzaud06,g_bza.bzaud07,g_bza.bzaud08,
                  g_bza.bzaud09,g_bza.bzaud10,g_bza.bzaud11,g_bza.bzaud12,
                  g_bza.bzaud13,g_bza.bzaud14,g_bza.bzaud15 
              #FUN-840202     ----end----
 
 
  CALL i500_b_fill(g_wc2)                 #單身
END FUNCTION
 
FUNCTION i500_q()
  LET g_row_count = 0
  LET g_curs_index = 0
  CALL cl_navigator_setting( g_curs_index, g_row_count )
  MESSAGE ""
  CALL cl_opmsg('q')
  INITIALIZE g_bza.* TO NULL
  CLEAR FORM
  CALL g_bzb.clear()
  DISPLAY ' ' TO FORMONLY.cnt
  DISPLAY ' ' TO FORMONLY.cnt2
 
  CALL i500_cs()
 
  IF INT_FLAG THEN
    LET INT_FLAG=0
    CLEAR FORM
    CALL g_bzb.clear()
    INITIALIZE g_bza.* TO NULL
    RETURN
  END IF 
                         
  OPEN i500_cs 
  IF SQLCA.sqlcode THEN
    CALL cl_err('OPEN i500_cs CURSOER ERROR:',SQLCA.sqlcode,0)
    INITIALIZE g_bza.* TO NULL
  ELSE
    OPEN i500_count
    FETCH i500_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    CALL i500_fetch('F')                
  END IF
END FUNCTION
 
FUNCTION i500_fetch(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1
  
  CASE p_flag
     WHEN 'N' FETCH NEXT     i500_cs INTO g_bza.bza01
     WHEN 'P' FETCH PREVIOUS i500_cs INTO g_bza.bza01
     WHEN 'F' FETCH FIRST    i500_cs INTO g_bza.bza01
     WHEN 'L' FETCH LAST     i500_cs INTO g_bza.bza01
     WHEN '/'
           IF (NOT mi_no_ask) THEN     #如果是因為刪除單身而來到此行程式
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
           FETCH ABSOLUTE g_jump i500_cs INTO g_bza.bza01
           LET mi_no_ask = FALSE
  END CASE
  
  IF SQLCA.sqlcode THEN
    CALL cl_err(g_bza.bza01,SQLCA.sqlcode,0)
    INITIALIZE g_bza.* TO NULL
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
 
  SELECT * INTO g_bza.* FROM bza_file WHERE bza01 = g_bza.bza01
  IF SQLCA.sqlcode THEN
    CALL cl_err(g_bza.bza01,SQLCA.sqlcode,0)
    INITIALIZE g_bza.* TO NULL
    RETURN
  END IF
 
  CALL i500_show()
END FUNCTION
 
FUNCTION i500_b()
  DEFINE
    l_bzb05         LIKE  bzb_file.bzb05,
    l_n             LIKE type_file.num5,              #檢查重複用
    l_cnt           LIKE type_file.num5,              #檢查重複用
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否
    p_cmd           LIKE type_file.chr1,            #處理狀態
    l_allow_insert  LIKE type_file.num5,              #可新增否
    l_allow_delete  LIKE type_file.num5,              #可刪除否
    l_ac_t          LIKE type_file.num5             #FUN-D30034 add

  LET g_action_choice = ""
  IF s_shut(0) THEN
    RETURN
  END IF
  IF cl_null(g_bza.bza01) THEN
    RETURN
  END IF
  IF g_bza.bzaacti ='N' THEN               #檢查資料是否為無效
    CALL cl_err(g_bza.bza01,'mfg1000',0)
    RETURN
  END IF
  CALL cl_opmsg('b')
 
  LET g_forupd_sql = "SELECT bzb02,bzb03,'',bzb04,'',bzb05,bzb06,",
                     " bzb07,bzb08,bzb09,bzb10,bzb11,bzb12, ",
                     " bzb13,bzb14, ", 
                   #No.FUN-840202 --start--
                     " bzbud01,bzbud02,bzbud03,bzbud04,bzbud05,",
                     " bzbud06,bzbud07,bzbud08,bzbud09,bzbud10,",
                     " bzbud11,bzbud12,bzbud13,bzbud14,bzbud15",
                   #No.FUN-840202 ---end---
                     " FROM bzb_file",
                     " WHERE bzb01=? AND bzb02=? FOR UPDATE "
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE i500_bcl CURSOR FROM g_forupd_sql           # LOCK CURSOR
  LET l_allow_insert = cl_detail_input_auth("insert")
  LET l_allow_delete = cl_detail_input_auth("delete")
  
  INPUT ARRAY g_bzb WITHOUT DEFAULTS FROM s_bzb.*
    ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
              APPEND ROW=l_allow_insert)
  BEFORE INPUT
    DISPLAY "BEFORE INPUT!"
    IF g_rec_b != 0 THEN
      CALL fgl_set_arr_curr(l_ac)
    END IF
  
  BEFORE ROW
    DISPLAY "BEFORE ROW!"
    LET p_cmd = ''
    LET l_ac = ARR_CURR()
    LET l_lock_sw = 'N'          
     
  BEGIN WORK
    OPEN i500_cl USING g_bza.bza01
    IF STATUS THEN
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
    END IF
  
    FETCH i500_cl INTO g_bza.* # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
        CALL cl_err(g_bza.bza01,SQLCA.sqlcode,0)    
        CLOSE i500_cl
        ROLLBACK WORK
        RETURN
      END IF
      IF g_rec_b >= l_ac THEN
        LET p_cmd='u'
        LET g_bzb_t.* = g_bzb[l_ac].*  
        LET g_bzb_o.* = g_bzb[l_ac].* 
        OPEN i500_bcl USING g_bza.bza01,g_bzb_t.bzb02
        IF STATUS THEN
          CALL cl_err("OPEN i500_bcl:", STATUS, 1)
          LET l_lock_sw = "Y"
        ELSE
          FETCH i500_bcl INTO g_bzb[l_ac].*
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_bzb_t.bzb02,SQLCA.sqlcode,1)
              LET l_lock_sw = "Y"
            END IF
            CALL i500_bzb03('d')
            CALL i500_bzb04('d')
            IF SQLCA.sqlcode THEN
              CALL cl_err(g_bzb_t.bzb02,SQLCA.sqlcode,1)
              LET l_lock_sw = "Y"
            END IF
        END IF
      END IF
      
    BEFORE INSERT
      DISPLAY "BEFORE INSERT!"
      LET p_cmd='a'
      #設定預設值
      INITIALIZE g_bzb[l_ac].* TO NULL  
      IF cl_null(g_bzb[l_ac].bzb02) OR g_bzb[l_ac].bzb02 = 0 THEN
        SELECT max(bzb02)+1 INTO g_bzb[l_ac].bzb02
                            FROM bzb_file WHERE bzb01 = g_bza.bza01
        IF cl_null(g_bzb[l_ac].bzb02) THEN
          LET g_bzb[l_ac].bzb02 = 1
        END IF
      END IF
      LET g_bzb[l_ac].bzb07 =  0   
      LET g_bzb[l_ac].bzb08 =  1
      LET g_bzb[l_ac].bzb10 =  0
      LET g_bzb[l_ac].bzb11 =  0
      LET g_bzb[l_ac].bzb12 =  0
      LET g_bzb[l_ac].bzb13 =  0 
      LET g_bzb_t.* = g_bzb[l_ac].*        #新輸入資料備份
      LET g_bzb_o.* = g_bzb[l_ac].*        #新輸入資料備份
      NEXT FIELD bzb02
 
    AFTER INSERT   
      DISPLAY "AFTER INSERT!"
      IF INT_FLAG THEN
        CALL cl_err('',9001,0)
        LET INT_FLAG = 0
        CANCEL INSERT
      END IF
      INSERT INTO bzb_file(bzb01,bzb02,bzb03,bzb04,bzb05,bzb06,
        bzb07,bzb08,bzb09,bzb10,bzb11,bzb12,bzb13,bzb14,
             #FUN-840202 --start--
                 bzbud01,bzbud02,bzbud03,
                 bzbud04,bzbud05,bzbud06,
                 bzbud07,bzbud08,bzbud09,
                 bzbud10,bzbud11,bzbud12,
                 bzbud13,bzbud14,bzbud15)
             #FUN-840202 --end--
        VALUES(g_bza.bza01,g_bzb[l_ac].bzb02,g_bzb[l_ac].bzb03,
               g_bzb[l_ac].bzb04,g_bzb[l_ac].bzb05,
               g_bzb[l_ac].bzb06,g_bzb[l_ac].bzb07,
               g_bzb[l_ac].bzb08,g_bzb[l_ac].bzb09,
               g_bzb[l_ac].bzb10,g_bzb[l_ac].bzb11,
               g_bzb[l_ac].bzb12,g_bzb[l_ac].bzb13,
               g_bzb[l_ac].bzb14, 
               #FUN-840202 --start--
               g_bzb[l_ac].bzbud01,
               g_bzb[l_ac].bzbud02,
               g_bzb[l_ac].bzbud03,
               g_bzb[l_ac].bzbud04,
               g_bzb[l_ac].bzbud05,
               g_bzb[l_ac].bzbud06,
               g_bzb[l_ac].bzbud07,
               g_bzb[l_ac].bzbud08,
               g_bzb[l_ac].bzbud09,
               g_bzb[l_ac].bzbud10,
               g_bzb[l_ac].bzbud11,
               g_bzb[l_ac].bzbud12,
               g_bzb[l_ac].bzbud13,
               g_bzb[l_ac].bzbud14,
               g_bzb[l_ac].bzbud15)
               #FUN-840202 --end--
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err(g_bzb[l_ac].bzb02,SQLCA.sqlcode,0)
        CANCEL INSERT
      ELSE
        MESSAGE 'INSERT O.K'
        COMMIT WORK
        LET g_rec_b=g_rec_b+1
        DISPLAY g_rec_b TO FORMONLY.cnt2   #TQC-8C0044
      END IF
 
    AFTER FIELD bzb02
      IF NOT cl_null(g_bzb[l_ac].bzb02) THEN
        IF g_bzb[l_ac].bzb02 < 1 THEN
          CALL cl_err('','mfg1322',0)
          LET g_bzb[l_ac].bzb02 = g_bzb_o.bzb02
          DISPLAY BY NAME g_bzb[l_ac].bzb02
          NEXT FIELD bzb02
        END IF
        IF p_cmd = 'a' OR
          (p_cmd = 'u' AND g_bzb[l_ac].bzb02 != g_bzb_t.bzb02 ) THEN
          SELECT count(*) INTO l_n FROM bzb_file 
            WHERE bzb01 = g_bza.bza01
              AND bzb02 = g_bzb[l_ac].bzb02
          IF l_n > 0 THEN
            CALL cl_err(g_bzb[l_ac].bzb02,-239,0)
            LET g_bzb[l_ac].bzb02 = g_bzb_o.bzb02
            DISPLAY BY NAME g_bzb[l_ac].bzb02
          END IF
        END IF
      LET g_bzb_o.bzb02 = g_bzb[l_ac].bzb02
      END IF   
    
    AFTER FIELD bzb03
      IF NOT cl_null(g_bzb[l_ac].bzb03) THEN
        IF cl_null(g_bzb_t.bzb03) 
           OR (g_bzb[l_ac].bzb03 != g_bzb_o.bzb03 ) THEN
           CALL i500_bzb03('a')
           IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bzb[l_ac].bzb03,g_errno,0)
             LET g_bzb[l_ac].bzb03 = g_bzb_o.bzb03
             LET g_bzb[l_ac].gem02 = g_bzb_o.gem02
             DISPLAY BY NAME g_bzb[l_ac].bzb03
             DISPLAY BY NAME g_bzb[l_ac].gem02
             NEXT FIELD bzb03
           END IF
        END IF
      LET g_bzb_o.bzb03 = g_bzb[l_ac].bzb03
      LET g_bzb_o.gem02 = g_bzb[l_ac].gem02
      END IF
 
    AFTER FIELD bzb04
      IF NOT cl_null(g_bzb[l_ac].bzb04) THEN
        IF cl_null(g_bzb_t.bzb04) 
           OR (g_bzb[l_ac].bzb04 != g_bzb_o.bzb04 ) THEN
           CALL i500_bzb04('a')
           IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_bzb[l_ac].bzb04,g_errno,0)
             LET g_bzb[l_ac].bzb04 = g_bzb_o.bzb04
             LET g_bzb[l_ac].gen02 = g_bzb_o.gen02
             DISPLAY BY NAME g_bzb[l_ac].bzb04
             DISPLAY BY NAME g_bzb[l_ac].gen02
             NEXT FIELD bzb04
           END IF
        END IF
      LET g_bzb_o.bzb04 = g_bzb[l_ac].bzb04
      LET g_bzb_o.gen02 = g_bzb[l_ac].gen02
      END IF
 
    AFTER FIELD bzb05
      IF NOT cl_null(g_bzb[l_ac].bzb05) THEN
        IF g_bzb[l_ac].bzb05 <= 0 THEN
          CALL cl_err(g_bzb[l_ac].bzb05,-32406,0)
          LET g_bzb[l_ac].bzb05 = g_bzb_o.bzb05
          NEXT FIELD bzb05
        END IF
        LET g_bzb_o.bzb05 = g_bzb[l_ac].bzb05
        LET g_bzb[l_ac].bzb07 = g_bzb[l_ac].bzb05 -
                                g_bzb[l_ac].bzb10
                               +g_bzb[l_ac].bzb11 - g_bzb[l_ac].bzb12
                               -g_bzb[l_ac].bzb13
        DISPLAY BY NAME g_bzb[l_ac].bzb07
      END IF
    
        #No.FUN-840202 --start--
        AFTER FIELD bzbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bzbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
    BEFORE DELETE 
      DISPLAY "BEFORE DELETE"
      IF g_bzb_t.bzb02 > 0 AND NOT cl_null(g_bzb_t.bzb02) THEN
        IF NOT cl_delb(0,0) THEN
          CANCEL DELETE
        END IF
        IF l_lock_sw = "Y" THEN
          CALL cl_err("", -263, 1)
          CANCEL DELETE
        END IF
        DELETE FROM bzb_file WHERE bzb01 = g_bza.bza01 
                               AND bzb02 = g_bzb_t.bzb02
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_bzb_t.bzb02,SQLCA.sqlcode,0)
          ROLLBACK WORK
          CANCEL DELETE
        END IF
        LET g_rec_b=g_rec_b-1
        DISPLAY g_rec_b TO FORMONLY.cnt2   #TQC-8C0044
      END IF
      COMMIT WORK
 
    ON ROW CHANGE
      IF INT_FLAG THEN
        CALL cl_err('',9001,0)
        LET INT_FLAG = 0
        LET g_bzb[l_ac].* = g_bzb_t.*
        CLOSE i500_bcl
        ROLLBACK WORK
        EXIT INPUT
      END IF
      IF l_lock_sw = 'Y' THEN
        CALL cl_err(g_bzb[l_ac].bzb02,-263,1)
        LET g_bzb[l_ac].* = g_bzb_t.*
      ELSE
         UPDATE bzb_file SET bzb02=g_bzb[l_ac].bzb02,
                             bzb03=g_bzb[l_ac].bzb03,
                             bzb04=g_bzb[l_ac].bzb04,
                             bzb05=g_bzb[l_ac].bzb05,
                             bzb06=g_bzb[l_ac].bzb06,
                             bzb07=g_bzb[l_ac].bzb07,
                             bzb08=g_bzb[l_ac].bzb08,
                             bzb09=g_bzb[l_ac].bzb09,
                             bzb10=g_bzb[l_ac].bzb10,
                             bzb11=g_bzb[l_ac].bzb11,
                             bzb12=g_bzb[l_ac].bzb12,
                             bzb13=g_bzb[l_ac].bzb13,
                             bzb14=g_bzb[l_ac].bzb14,
                             #FUN-840202 --start--
                             bzbud01 = g_bzb[l_ac].bzbud01,
                             bzbud02 = g_bzb[l_ac].bzbud02,
                             bzbud03 = g_bzb[l_ac].bzbud03,
                             bzbud04 = g_bzb[l_ac].bzbud04,
                             bzbud05 = g_bzb[l_ac].bzbud05,
                             bzbud06 = g_bzb[l_ac].bzbud06,
                             bzbud07 = g_bzb[l_ac].bzbud07,
                             bzbud08 = g_bzb[l_ac].bzbud08,
                             bzbud09 = g_bzb[l_ac].bzbud09,
                             bzbud10 = g_bzb[l_ac].bzbud10,
                             bzbud11 = g_bzb[l_ac].bzbud11,
                             bzbud12 = g_bzb[l_ac].bzbud12,
                             bzbud13 = g_bzb[l_ac].bzbud13,
                             bzbud14 = g_bzb[l_ac].bzbud14,
                             bzbud15 = g_bzb[l_ac].bzbud15
                             #FUN-840202 --end-- 
         WHERE bzb01=g_bza.bza01 AND bzb02=g_bzb_t.bzb02
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err(g_bzb[l_ac].bzb02,SQLCA.sqlcode,0)
           LET g_bzb[l_ac].* = g_bzb_t.*
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
             LET g_bzb[l_ac].* = g_bzb_t.*
           #FUN-D30034--add--begin--
           ELSE
              CALL g_bzb.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D30034--add--end----
           END IF
           CLOSE i500_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac  #FUN-D30034 add
        CLOSE i500_bcl
        COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
        IF INFIELD(bzb02) AND l_ac > 1 THEN
          LET g_bzb[l_ac].* = g_bzb[l_ac-1].*
          DISPLAY BY NAME g_bzb[l_ac].*    #印出畫面，並確保資料存在
          LET g_bzb[l_ac].bzb02 = g_bzb_t.bzb02 
          NEXT FIELD bzb02
        END IF
 
      ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
        CALL cl_cmdask()
      
      ON ACTION controlp
        CASE
            WHEN INFIELD(bzb03) 
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gem"
              LET g_qryparam.default1 = g_bzb[l_ac].bzb03
              CALL cl_create_qry() RETURNING g_bzb[l_ac].bzb03
              DISPLAY BY NAME g_bzb[l_ac].bzb03
              IF NOT cl_null(g_bzb[l_ac].bzb03) THEN
                CALL i500_bzb03('a')
              END IF
              NEXT FIELD bzb03
            WHEN INFIELD(bzb04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_gen"
              LET g_qryparam.default1 = g_bzb[l_ac].bzb04
              CALL cl_create_qry() RETURNING g_bzb[l_ac].bzb04
              DISPLAY BY NAME g_bzb[l_ac].bzb04
              IF NOT cl_null(g_bzb[l_ac].bzb04) THEN
                CALL i500_bzb04('a')
              END IF
              NEXT FIELD bzb04
            OTHERWISE EXIT CASE
        END CASE
 
      ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) 
             RETURNING g_fld_name,g_frm_name 
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
    END INPUT
 
   #---單身確認後,比較值是否相等---------------------
    IF cl_null(g_action_choice) OR g_action_choice <> "detail" THEN  #FUN-D30034 add
       LET l_bzb05 = 0 
       SELECT SUM(bzb05) INTO l_bzb05
           FROM  bzb_file
          WHERE bzb01 = g_bza.bza01
       IF l_bzb05 != g_bza.bza09 THEN
          CALL cl_err(l_bzb05,'abx-017',1)  #---單身數量總和不等於單頭數量
       END IF
    END IF   #FUN-D30034 add 
    CLOSE i500_bcl
    COMMIT WORK
    CALL i500_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i500_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bza_file WHERE bza01 = g_bza.bza01
         INITIALIZE g_bza.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i500_b_fill(p_wc2)
  DEFINE  p_wc2  STRING
 
  LET g_sql = "SELECT bzb02,bzb03,'',bzb04,'',bzb05,bzb06,",
              " bzb07,bzb08,bzb09,",
              " bzb10,bzb11,bzb12,bzb13,bzb14, ",  
             #No.FUN-840202 --start--
              " bzbud01,bzbud02,bzbud03,bzbud04,bzbud05,",
              " bzbud06,bzbud07,bzbud08,bzbud09,bzbud10,",
              " bzbud11,bzbud12,bzbud13,bzbud14,bzbud15", 
             #No.FUN-840202 ---end---
              " FROM bzb_file",
              " WHERE bzb01 = '",g_bza.bza01,"' ",
              " AND ", p_wc2 CLIPPED,
              " ORDER BY bzb02,bzb03,bzb04 " 
  
  PREPARE i500_pb FROM g_sql
  DECLARE bzb_cs CURSOR FOR i500_pb
 
  CALL g_bzb.clear()
  LET g_cnt = 1
  FOREACH bzb_cs INTO g_bzb[g_cnt].*   #單身 ARRAY 填充
    IF SQLCA.sqlcode THEN
      CALL cl_err('foreach:',SQLCA.sqlcode,1)
      EXIT FOREACH
    END IF
    LET l_ac = g_cnt    #確保找出gem、gen的資料
    CALL i500_bzb03('d')
    CALL i500_bzb04('d')
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
      CALL cl_err( 'foreach:',9035, 0 )
      EXIT FOREACH
    END IF
  END FOREACH
  CALL g_bzb.deleteElement(g_cnt)
  LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cnt2
  LET g_cnt = 0   
END FUNCTION
 
FUNCTION i500_bzb03(p_cmd)
  DEFINE 
         l_gem02   LIKE gem_file.gem02,
         l_gemacti LIKE gem_file.gemacti,
         p_cmd          LIKE type_file.chr1
 
  LET g_errno = " "
  SELECT gem02,gemacti
    INTO l_gem02,l_gemacti
    FROM gem_file WHERE gem01 = g_bzb[l_ac].bzb03
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-039'
                          LET l_gem02 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    LET g_bzb[l_ac].gem02 = l_gem02
    DISPLAY BY NAME g_bzb[l_ac].gem02
  END IF
END FUNCTION
 
FUNCTION i500_bzb04(p_cmd)
  DEFINE
        l_gen02   LIKE gen_file.gen02,
        l_genacti LIKE gen_file.genacti,
        p_cmd          LIKE type_file.chr1
  LET g_errno = " "
  SELECT gen02,genacti
    INTO l_gen02,l_genacti
    FROM gen_file WHERE gen01 = g_bzb[l_ac].bzb04
  CASE 
       WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                         LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
    LET g_bzb[l_ac].gen02 = l_gen02
    DISPLAY BY NAME g_bzb[l_ac].gen02
  END IF
END FUNCTION
 
FUNCTION i500_r()
  DEFINE  l_n  LIKE type_file.num10
  IF s_shut(0) THEN
    RETURN
  END IF
  IF cl_null(g_bza.bza01) THEN
    CALL cl_err('',-400,0)
    RETURN
  END IF
  SELECT * INTO g_bza.* FROM bza_file
    WHERE bza01=g_bza.bza01
  IF g_bza.bzaacti ='N' THEN               #檢查資料是否為無效
    CALL cl_err(g_bza.bza01,'mfg1000',0)
    RETURN
  END IF
  MESSAGE ""
  CALL cl_opmsg('r')
 
  BEGIN WORK
    OPEN i500_cl USING g_bza.bza01
    IF STATUS THEN
      CALL cl_err("OPEN i500_cl:", STATUS, 1)
      CLOSE i500_cl
      ROLLBACK WORK
      RETURN
    END IF
    FETCH i500_cl INTO g_bza.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_bza.bza01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
    END IF
    CALL i500_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bza01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bza.bza01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      SELECT COUNT(*) INTO l_n FROM bza_file #如果此單頭為別人的主件時，不能刪
        WHERE bza06 = g_bza.bza01 AND bza05 = '2'
      IF l_n>0 THEN
        CALL cl_err(g_bza.bza01,'abx-014',0)
        ROLLBACK WORK
        RETURN
      ELSE
        DELETE FROM bza_file WHERE bza01 = g_bza.bza01
        DELETE FROM bzb_file WHERE bzb01 = g_bza.bza01
        CLEAR FORM
        CALL g_bzb.clear()
        INITIALIZE g_bza.* TO NULL
        OPEN i500_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i500_cs
             CLOSE i500_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH i500_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i500_cs
             CLOSE i500_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i500_cs
        IF g_curs_index = g_row_count + 1 THEN   #刪除最後一筆row資料
          LET g_jump = g_row_count
          CALL i500_fetch('L')
        ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i500_fetch('/')
        END IF
      END IF
    END IF
    CLOSE i500_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i500_b_askkey()
  DEFINE  l_wc2           STRING
 
  CONSTRUCT l_wc2 ON bzb02,bzb03,bzb04,bzb05,bzb06,bzb07,bzb08,
                     bzb09,bzb10,bzb11,bzb12,bzb13,bzb14
           FROM s_bzb[1].bzb02,s_bzb[1].bzb03,s_bzb[1].bzb04,
                s_bzb[1].bzb05,s_bzb[1].bzb06,s_bzb[1].bzb07,
                s_bzb[1].bzb08,s_bzb[1].bzb09,s_bzb[1].bzb10,
                s_bzb[1].bzb11,s_bzb[1].bzb12,s_bzb[1].bzb13,
                s_bzb[1].bzb14
 
     BEFORE CONSTRUCT
         CALL cl_qbe_init()
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
         CALL cl_qbe_select()
     ON ACTION qbe_save
         CALL cl_qbe_save()
  END CONSTRUCT
 
  IF INT_FLAG THEN
    LET INT_FLAG = 0
    RETURN
  END IF
 
  CALL i500_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i500_set_entry(p_cmd)
  DEFINE p_cmd    LIKE type_file.chr1,
         l_n      LIKE type_file.num10
 
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("bza01",TRUE)
  END IF
  
  SELECT COUNT(*) INTO l_n FROM bza_file #如果此單頭不為別人的主件時，能修改
    WHERE bza06 = g_bza.bza01 AND bza05 = '2'
  IF p_cmd ='u' AND l_n = 0 THEN
     CALL cl_set_comp_entry("bza01,bza06",TRUE)
  END IF
  CALL cl_set_comp_entry("bza06",TRUE)
END FUNCTION
 
FUNCTION i500_set_no_entry(p_cmd)
   DEFINE p_cmd    LIKE type_file.chr1,
          l_n      LIKE type_file.num10
   
   LET l_lflag ='0'  
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("bza01",FALSE)
   END IF
   SELECT COUNT(*) INTO l_n FROM bza_file #如果此單頭為別人的主件時，不能修改
     WHERE bza06 = g_bza.bza01 AND bza05 = '2'
   IF p_cmd='u'AND l_n > 0 THEN
      CALL cl_set_comp_entry("bza01,bza06",FALSE)
      LET l_lflag = '1'
   END IF
   #若不為附件則關閉主件編號欄位
   IF INFIELD(bza05) AND  g_bza.bza05 != '2' THEN 
     CALL cl_set_comp_entry("bza06",FALSE)
   END IF
END FUNCTION
 
FUNCTION i500_out()
DEFINE l_name          LIKE type_file.chr20,
   l_cmd  STRING,
   l_prt_con LIKE zz_file.zz21,
   l_prt_way LIKE zz_file.zz22,
   l_wc   STRING,
   l_lang LIKE type_file.chr1
 
   IF cl_null(g_bza.bza01) THEN CALL cl_err('',-400,0) RETURN END IF
 
   LET l_wc= "'",g_bza.bza01,"'"
   LET l_name = 'abxr501'
   SELECT zz21,zz22 INTO l_prt_con,l_prt_way FROM zz_file WHERE zz01 = p_cmd
   IF SQLCA.sqlcode OR cl_null(l_prt_con) OR l_wc = ' ' THEN
      LET l_prt_con = " 'Y' "
      LET l_cmd = l_name CLIPPED,
                 " '",g_today CLIPPED,"' ''",
                 " '",g_lang CLIPPED,"' 'Y' '",l_prt_way,"' ' '",
                  " '",l_wc CLIPPED,"' ",l_prt_con
      CALL cl_cmdrun_wait(l_cmd)
   END IF
END FUNCTION

#FUN-910088--add--start--
#FUNCTION i500_bza09_check()       #MOD-C10215 mark
FUNCTION i500_bza09_check(p_cmd)   #MOD-C10215 add

   DEFINE l_result  LIKE type_file.num5   #MOD-C10215 add
   DEFINE p_cmd     LIKE type_file.chr1   #處理狀態 #MOD-C10215 add
   IF NOT cl_null(g_bza.bza09) AND NOT cl_null(g_bza.bza08) THEN 
      IF cl_null(g_bza08_t) OR cl_null(g_bza_t.bza09) OR g_bza08_t != g_bza.bza08 OR g_bza_t.bza09 != g_bza.bza09 THEN 
         LET g_bza.bza09 = s_digqty(g_bza.bza09,g_bza.bza08)
         DISPLAY BY NAME g_bza.bza09
      END IF
   END IF 
   IF NOT cl_null(g_bza.bza09) THEN
     IF g_bza.bza09 <=0 THEN
       CALL cl_err(g_bza.bza09,-32406,1)
       LET g_bza.bza09 = g_bza_o.bza09
       RETURN FALSE    
     END IF
   #-----MOD-C10215 str add-----
   IF (p_cmd = 'a') THEN
       LET g_bza.bza16=g_bza.bza09
       DISPLAY BY NAME g_bza.bza16
   ELSE
     IF g_bza_o.bza09 <>  g_bza.bza09  THEN
       CALL cl_confirm("abx-088") RETURNING l_result
       IF l_result THEN
         LET g_bza.bza16=g_bza.bza09
         DISPLAY BY NAME g_bza.bza16
       END IF
     END IF
   END IF
   #-----MOD-C10215 end add-----
   LET g_bza_o.bza09 = g_bza.bza09
   END IF 
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
