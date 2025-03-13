# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: abmi613.4gl
# Descriptions...: 成品材料屬性對應關系維護作業
# Date & Author..: 07/08/01 By  arman 
# Modify.........: No.FUN-810014 08/03/21 By arman  
# Modify.........: No.FUN-830088 08/03/24 By arman  
# Modify.........: No.MOD-840206 08/04/20 By arman   輸入完主件屬性后,游標會移至元件屬性欄位,而非先移至元件款式欄位.
                                                     #若使用者欲輸入元件款式時需自行移動游標  
# Modify.........: NO.MOD-840510 08/04/22 BY yiting 開窗時加入屬性說明
# Modify.........: No.FUN-870127 08/07/24 By arman 服飾版
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改 
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.MOD-AB0130 10/11/12 By zhangll 1.boc_file where条件错误
#                                                    2.由于更改状态下，无栏位供更改，因此取消更改功能，将按钮隐藏掉，原逻辑保留，便于未来增加单头可更改栏位
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting 未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料則應該提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE g_boc         RECORD LIKE boc_file.*,       #簽核等級 (單頭)  #NO.FUN-810014
       g_boc_t       RECORD LIKE boc_file.*,       #簽核等級 (舊值)
       g_boc_o       RECORD LIKE boc_file.*,       #簽核等級 (舊值)
       g_boc01_t     LIKE boc_file.boc01,          #簽核等級 (舊值)
       g_t1          LIKE oay_file.oayslip,       
       g_sheet       LIKE oay_file.oayslip,   
       g_ydate       LIKE type_file.dat,    
       g_bod         DYNAMIC ARRAY OF RECORD  
           bod05     LIKE bod_file.bod05,          #主件屬性值
           bod08     LIKE bod_file.bod08,          #主件屬性值描述
           bod06     LIKE bod_file.bod06,          #部位 
     bod06_bol02     LIKE bol_file.bol02,          #部位描述 
           bod07     LIKE bod_file.bod07,          #元件屬性值
           bod09     LIKE bod_file.bod09           #元件屬性值描述
                     END RECORD,
       g_bod_t       RECORD                        #程式變數 (舊值)
           bod05     LIKE bod_file.bod05,          #主件屬性值
           bod08     LIKE bod_file.bod08,          #主件屬性值描述
           bod06     LIKE bod_file.bod06,          #部位 
     bod06_bol02     LIKE bol_file.bol02,          #部位描述 
           bod07     LIKE bod_file.bod07,          #元件屬性值
           bod09     LIKE bod_file.bod09           #元件屬性值描述
                     END RECORD,
       g_bod_o       RECORD                        #程式變數 (舊值)
           bod05     LIKE bod_file.bod05,          #主件屬性值
           bod08     LIKE bod_file.bod08,          #主件屬性值描述
           bod06     LIKE bod_file.bod06,          #部位 
     bod06_bol02     LIKE bol_file.bol02,          #部位描述 
           bod07     LIKE bod_file.bod07,          #元件屬性值
           bod09     LIKE bod_file.bod09           #元件屬性值描述
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存 TQC-5B0183
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  #No.FUN-680136 SMALLINT
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE g_gec07             LIKE gec_file.gec07    
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    
DEFINE g_chr               LIKE type_file.chr1   
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_row_count         LIKE type_file.num10   #總筆數  #No.FUN-680136 INTEGER
DEFINE g_jump              LIKE type_file.num10   #查詢指定的筆數  #No.FUN-680136 INTEGER
DEFINE g_no_ask           LIKE type_file.num5    #是否開啟指定筆視窗  #No.FUN-680136 SMALLINT      #No.FUN-6A0067
DEFINE g_argv1             LIKE boc_file.boc01   
DEFINE g_argv2             STRING               #指定執行的功能 #TQC-630074
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1=ARG_VAL(1)           #TQC-630074
   LET g_argv2=ARG_VAL(2)           #TQC-630074
   LET g_pdate = g_today   #No.FUN-710091 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM boc_file WHERE boc01 = ? AND boc02 = ? AND boc03 = ? AND boc04 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i613_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i613_w WITH FORM "abm/42f/abmi613"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_set_locale_frm_name("abmi613")   #No.FUN-670099
   
   CALL cl_ui_init()
 
   LET g_ydate = NULL
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i613_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i613_a()
            END IF
         OTHERWISE
            CALL i613_q()
      END CASE
   END IF
 
   CALL i613_menu()
   CLOSE WINDOW i613_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
#QBE 查詢資料
FUNCTION i613_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM 
   CALL g_bod.clear()
  
   #TQC-630074
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " boc01 = '",g_argv1,"'"  #FUN-580120
   ELSE
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      INITIALIZE g_boc.* TO NULL     
      CONSTRUCT BY NAME g_wc ON boc01,boc02,
                                boc03,boc04,
                                bocuser,bocgrup,bocmodu,bocdate,bocacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
          CASE
            WHEN INFIELD(boc01) 
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.state = 'c'
            #   LET g_qryparam.form ="q_boc01"
            #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima( TRUE, "q_boc01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
               DISPLAY g_qryparam.multiret TO boc01
               NEXT FIELD boc01
 
            WHEN INFIELD(boc02)
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.state = 'c'
            #   LET g_qryparam.form ="q_boc01"
            #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima( TRUE, "q_boc01","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
               DISPLAY g_qryparam.multiret TO boc02
               NEXT FIELD boc02
            WHEN INFIELD(boc03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               #LET g_qryparam.form ="q_boc03"
               LET g_qryparam.form ="q_boc03_1"  #no.MOD-840510 mod
               LET g_qryparam.arg1 = g_boc.boc01
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO boc03
               NEXT FIELD boc03
            #No.FUN-870127  --begin
            WHEN INFIELD(boc04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_boc04_1"  
               LET g_qryparam.arg1 = g_boc.boc02
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO boc04
               NEXT FIELD boc04
            #No.FUN-870127 --end 
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND bocuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND bocgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND bocgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bocuser', 'bocgrup')
   #End:FUN-980030
 
 
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON bod05,bod08,bod06,bod07,bod09              
              FROM s_bod[1].bod05,s_bod[1].bod08,s_bod[1].bod06,  
                   s_bod[1].bod07,s_bod[1].bod09
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(bod06) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_bod06"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bod06
              NEXT FIELD bod06
            END CASE
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
    
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
    
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
    #END TQC-630074
 
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT boc01,boc02,boc03,boc04 FROM boc_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY boc01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT boc01,boc02,boc03,boc04 ",
                  "  FROM boc_file, bod_file ",
                  " WHERE boc01 = bod01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY boc01"
   END IF
 
   PREPARE i613_prepare FROM g_sql
   DECLARE i613_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i613_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM boc_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT boc01) FROM boc_file,bod_file WHERE ",
                "bod01=boc01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i613_precount FROM g_sql
   DECLARE i613_count CURSOR FOR i613_precount
 
END FUNCTION
 
FUNCTION i613_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
      CALL i613_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i613_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i613_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i613_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i613_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i613_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i613_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i613_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL i613_out()
#           END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bod),'','')
            END IF
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_boc.boc01 IS NOT NULL THEN
                 LET g_doc.column1 = "boc01"
                 LET g_doc.value1 = g_boc.boc01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i613_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bod TO s_bod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
     #Mark No.MOD-AB0130
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
     #End Mark No.MOD-AB0130
 
      ON ACTION first
         CALL i613_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i613_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION jump
         CALL i613_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next
         CALL i613_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION last
         CALL i613_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #No.FUN-6C0055 --start--
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
#           CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         #No.FUN-6C0055 --end--
 
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
         LET INT_FLAG=FALSE          #MOD-570244  mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #No.FUN-6C0055 --start--   
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
      #No.FUN-6C0055 --end--
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#start FUN-640063 add
FUNCTION i613_bp_refresh()
  DISPLAY ARRAY g_bod TO s_bod.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
#end FUN-640063 add
 
FUNCTION i613_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bod.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   INITIALIZE g_boc.* LIKE boc_file.*             #DEFAULT 設定
   LET g_boc01_t = NULL
 
 
   #預設值及將數值類變數清成零
   LET g_boc_t.* = g_boc.*
   LET g_boc_o.* = g_boc.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_boc.bocuser=g_user
      LET g_boc.bocoriu = g_user #FUN-980030
      LET g_boc.bocorig = g_grup #FUN-980030
      LET g_boc.bocgrup=g_grup
      LET g_boc.bocdate=g_today
      LET g_boc.bocacti='Y'              #資料有效
      CALL i613_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_boc.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_boc.boc01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO boc_file VALUES (g_boc.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","boc_file",g_boc.boc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129  #No.FUN-B80100---上移一行調整至回滾事務前---
         ROLLBACK WORK      
         CONTINUE WHILE
      ELSE
         COMMIT WORK        #No:7857
         CALL cl_flow_notify(g_boc.boc01,'I')
      END IF
 
      SELECT boc01,boc02,boc03,boc04 INTO g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04 FROM boc_file
       WHERE boc01 = g_boc.boc01
         AND boc02 = g_boc.boc02
         AND boc03 = g_boc.boc03
         AND boc04 = g_boc.boc04
 
      LET g_boc01_t = g_boc.boc01        #保留舊值
      LET g_boc_t.* = g_boc.*
      LET g_boc_o.* = g_boc.*
      CALL g_bod.clear()
 
      LET g_rec_b = 0  #No.MOD-490280
      CALL i613_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i613_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_boc.boc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_boc.* FROM boc_file
    WHERE boc01=g_boc.boc01
    #Add No.MOD-AB0130
      AND boc02=g_boc.boc02
      AND boc03=g_boc.boc03
      AND boc04=g_boc.boc04
    #End Add No.MOD-AB0130
 
   IF g_boc.bocacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_boc.boc01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_boc01_t = g_boc.boc01
   BEGIN WORK
 
   OPEN i613_cl USING g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
   IF STATUS THEN
      CALL cl_err("OPEN i613_cl:", STATUS, 1)
      CLOSE i613_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i613_cl INTO g_boc.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_boc.boc01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i613_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i613_show()
 
   WHILE TRUE
      LET g_boc01_t = g_boc.boc01
      LET g_boc_o.* = g_boc.*
      LET g_boc.bocmodu=g_user
      LET g_boc.bocdate=g_today
 
      CALL i613_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_boc.*=g_boc_t.*
         CALL i613_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_boc.boc01 != g_boc01_t THEN            # 更改單號
         UPDATE bod_file SET bod01 = g_boc.boc01
          WHERE bod01 = g_boc01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","bod_file",g_boc01_t,"",SQLCA.sqlcode,"","bod",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE boc_file SET boc_file.* = g_boc.*
       WHERE boc01 = g_boc.boc01 AND boc02 = g_boc.boc02 AND boc03 = g_boc.boc03 AND boc04 = g_boc.boc04
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","boc_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i613_cl
   COMMIT WORK
   CALL cl_flow_notify(g_boc.boc01,'U')
 
  #start FUN-640063 add
   CALL i613_b_fill("1=1")
   CALL i613_bp_refresh()
  #end FUN-640063 add
 
END FUNCTION
 
FUNCTION i613_i(p_cmd)
DEFINE
   l_pmc05   LIKE pmc_file.pmc05,
   l_pmc30   LIKE pmc_file.pmc30,
   l_n       LIKE type_file.num5,  
   l_n2      LIKE type_file.num5,  
   l_n3      LIKE type_file.num5,  
   l_n4      LIKE type_file.num5,  
   l_cnt     LIKE type_file.num5,  
   p_cmd     LIKE type_file.chr1 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_boc.bocuser,g_boc.bocmodu,
       g_boc.bocgrup,g_boc.bocdate,g_boc.bocacti
 
   CALL cl_set_head_visible("","YES")          
#  INPUT BY NAME g_boc.boc01,g_boc.boc02,g_boc.boc03, 
   INPUT BY NAME g_boc.bocoriu,g_boc.bocorig,g_boc.boc01,g_boc.boc03,g_boc.boc02,     #No.MOD-840206 
                 g_boc.boc04
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i613_set_entry(p_cmd)
         CALL i613_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD boc01
         IF NOT cl_null(g_boc.boc01) THEN
          #FUN-AA0059 ------------------------add start------------------------
          IF NOT s_chk_item_no(g_boc.boc01,'') THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD boc01
          END IF 
          #FUN-AA0059 ------------------------add end---------------------------  
          IF NOT cl_null(g_boc.boc02) THEN
            IF g_boc.boc01 = g_boc.boc02 THEN
                CALL cl_err('','abm-321',0)
                   NEXT FIELD  boc01 
            END IF
          END IF
            SELECT COUNT(*) INTO l_n FROM ima_file WHERE 
                            ima01=g_boc.boc01 and ima151='Y' and imaacti='Y'
            IF l_n <= 0 THEN 
                     CALL cl_err('','abm-090',0)
                     NEXT FIELD boc01
            END IF
            CALL i613_boc01('d')
         END IF
 
      AFTER FIELD boc02
         IF NOT cl_null(g_boc.boc02) THEN
          #FUN-AA0059 ----------------------add start-----------------------
          IF NOT s_chk_item_no(g_boc.boc02,'') THEN
             CALL cl_err('',g_errno,1)
             NEXT FIELD boc02
          END IF 
          #FUN-AA0059 ---------------------add end---------------------------
          IF NOT cl_null(g_boc.boc01) THEN
            IF g_boc.boc01 = g_boc.boc02 THEN
                CALL cl_err('','abm-321',0)
                   NEXT FIELD  boc02 
            END IF
          END IF
            SELECT COUNT(*) INTO l_n2 FROM ima_file WHERE 
                                      ima01=g_boc.boc02 and ima151='Y' and imaacti='Y'
            IF l_n2 <= 0 THEN 
                     CALL cl_err('','abm-121',0)
                     NEXT FIELD boc02
            END IF
            #No.FUN-870127 ---begin
             LET l_n2 = 0 
             SELECT COUNT(*) INTO l_n2 FROM bmb_file WHERE
                                       bmb01 = g_boc.boc01 AND bmb03 = g_boc.boc02
            IF l_n2 <= 0 THEN 
                     CALL cl_err('','abm-062',0)
                     NEXT FIELD boc02
            END IF
             
            #No.FUN-870127 ---end
            CALL i613_boc02('d')
         END IF
      AFTER FIELD boc03
         IF NOT cl_null(g_boc.boc03) THEN
            SELECT COUNT(*) INTO l_n3 FROM ima_file,agb_file,aga_file WHERE 
                   agb01=aga01 and aga01=imaag and ima01=g_boc.boc01
                   and agaacti='Y' and imaacti='Y' and agb03=g_boc.boc03
            IF l_n3 <= 0 THEN 
                     CALL cl_err('','abm_613',0)
                     NEXT FIELD boc03
            END IF
            CALL i613_boc03('d')
         ELSE 
            LET g_boc.boc03 = ' '
         END IF
      AFTER FIELD boc04               
         IF NOT cl_null(g_boc.boc04) THEN
            SELECT COUNT(*) INTO l_n4 FROM ima_file,agb_file,aga_file WHERE
                            agb01=aga01 and aga01=imaag and ima01=g_boc.boc02
                            and agaacti='Y' and imaacti='Y' and agb03=g_boc.boc04 
            IF l_n4 <= 0 THEN 
                     CALL cl_err('','abm_611',0)
                     NEXT FIELD boc04
            END IF
            CALL i613_boc04('d')
         ELSE
            LET g_boc.boc04 = ' '
         END IF
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM boc_file WHERE boc01 = g_boc.boc01
                                                    AND boc02 = g_boc.boc02
                                                    AND boc03 = g_boc.boc03
                                                    AND boc04 = g_boc.boc04
         IF l_cnt >0 THEN
              CALL cl_err('','atm-310',0)
              NEXT FIELD boc04
         END IF 
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(boc01) 
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form ="q_boc01"
             #  LET g_qryparam.default1 = g_boc.boc01
             #  CALL cl_create_qry() RETURNING g_boc.boc01
               CALL q_sel_ima(FALSE, "q_boc01", "", g_boc.boc01, "", "", "", "" ,"",'' )  RETURNING g_boc.boc01
#FUN-AA0059 --End--
               DISPLAY BY NAME g_boc.boc01
               NEXT FIELD boc01
 
            WHEN INFIELD(boc02)
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form ="q_boc01"
            #   LET g_qryparam.default1 = g_boc.boc02
            #   CALL cl_create_qry() RETURNING g_boc.boc02
               CALL q_sel_ima(FALSE, "q_boc01", "",g_boc.boc02, "", "", "", "" ,"",'' )  RETURNING g_boc.boc02
#FUN-AA0059 --End--
               DISPLAY BY NAME g_boc.boc02
               NEXT FIELD boc02
 
            WHEN INFIELD(boc03)
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_boc03"
               LET g_qryparam.form ="q_boc03_1"   #no.MOD-840510 mod
               LET g_qryparam.default1 = g_boc.boc03
               LET g_qryparam.arg1 = g_boc.boc01
               CALL cl_create_qry() RETURNING g_boc.boc03
               DISPLAY BY NAME g_boc.boc03
               NEXT FIELD boc03
 
            WHEN INFIELD(boc04)
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_boc04"
               LET g_qryparam.form ="q_boc04_1"   #no.MOD-840510 mod
               LET g_qryparam.default1 = g_boc.boc04
               LET g_qryparam.arg1 = g_boc.boc02
               CALL cl_create_qry() RETURNING g_boc.boc04
               DISPLAY BY NAME g_boc.boc04
               NEXT FIELD boc04
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      END INPUT
 
END FUNCTION
 
FUNCTION i613_boc01(p_cmd)  #廠商編號
    DEFINE l_ima02 LIKE ima_file.ima02,
           l_imaag LIKE ima_file.imaag,
           l_aga02 LIKE aga_file.aga02,
           l_imaacti LIKE ima_file.imaacti,
           p_cmd   LIKE type_file.chr1
 
   LET g_errno = " "
   SELECT ima02,imaag,imaacti 
     INTO l_ima02,l_imaag  FROM ima_file WHERE ima01 = g_boc.boc01
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                           LET l_ima02 = NULL
                           LET l_imaag = NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
    SELECT aga02 INTO l_aga02 FROM aga_file,ima_file WHERE aga01=imaag and ima01=g_boc.boc01
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ima02 TO FORMONLY.boc01_ima02
      DISPLAY l_imaag TO FORMONLY.boc01_imaag
      DISPLAY l_aga02 TO FORMONLY.boc01_imaag_aga02
   END IF
 
END FUNCTION
 
FUNCTION i613_boc02(p_cmd)  #廠商編號
    DEFINE l_ima02 LIKE ima_file.ima02,
           l_imaag LIKE ima_file.imaag,
           l_aga02 LIKE aga_file.aga02,
           l_imaacti LIKE ima_file.imaacti,
           p_cmd   LIKE type_file.chr1
 
   LET g_errno = " "
   SELECT ima02,imaag,imaacti 
     INTO l_ima02,l_imaag  FROM ima_file WHERE ima01 = g_boc.boc02
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                           LET l_ima02 = NULL
                           LET l_imaag = NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
    SELECT aga02 INTO l_aga02 FROM aga_file,ima_file WHERE aga01=imaag and ima01=g_boc.boc02
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_ima02 TO FORMONLY.boc02_ima02
      DISPLAY l_imaag TO FORMONLY.boc02_imaag
      DISPLAY l_aga02 TO FORMONLY.boc02_imaag_aga02
   END IF
 
END FUNCTION
FUNCTION i613_boc03(p_cmd)  
   DEFINE l_agc02   LIKE agc_file.agc02,
          p_cmd     LIKE type_file.chr1 
 
   LET g_errno = ' '
   SELECT agc02 INTO l_agc02 FROM  agc_file WHERE  agc01=g_boc.boc03 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_agc02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_agc02 TO FORMONLY.boc03_agc02
   END IF
 
END FUNCTION
 
FUNCTION i613_boc04(p_cmd)  
   DEFINE l_agc02   LIKE agc_file.agc02,
          p_cmd     LIKE type_file.chr1 
 
   LET g_errno = ' '
   SELECT agc02 INTO l_agc02 FROM  agc_file WHERE  agc01=g_boc.boc04 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_agc02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_agc02 TO FORMONLY.boc04_agc02
   END IF
 
END FUNCTION
 
FUNCTION i613_bod06(p_cmd)  
   DEFINE l_bol02   LIKE bol_file.bol02,
          p_cmd     LIKE type_file.chr1 
 
   LET g_errno = ' '
       SELECT bol02  INTO l_bol02 FROM  bol_file WHERE  bol01=g_bod[l_ac].bod06 AND bolacti='Y'
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_bol02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_bod[l_ac].bod06_bol02 = l_bol02
      DISPLAY BY NAME g_bod[l_ac].bod06_bol02
   END IF
 
END FUNCTION
FUNCTION i613_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_bod.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i613_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_boc.* TO NULL
      RETURN
   END IF
 
   OPEN i613_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_boc.* TO NULL
   ELSE
      OPEN i613_count
      FETCH i613_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i613_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i613_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i613_cs INTO g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
      WHEN 'P' FETCH PREVIOUS i613_cs INTO g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
      WHEN 'F' FETCH FIRST    i613_cs INTO g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
      WHEN 'L' FETCH LAST     i613_cs INTO g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
      WHEN '/'
            IF (NOT g_no_ask) THEN      #No.FUN-6A0067
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                END PROMPT
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i613_cs INTO g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
            LET g_no_ask = FALSE     #No.FUN-6A0067
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_boc.boc01,SQLCA.sqlcode,0)
      INITIALIZE g_boc.* TO NULL               #No.FUN-6A0162
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
#     DISPLAY g_curs_index TO FORMONLY.cnt2                    #No.FUN-4A0089
   END IF
 
   SELECT * INTO g_boc.* FROM boc_file WHERE boc01 = g_boc.boc01 AND boc02 = g_boc.boc02 AND boc03 = g_boc.boc03 AND boc04 = g_boc.boc04
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_boc.boc01,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("sel","boc_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_boc.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_boc.bocuser      #FUN-4C0056 add
   LET g_data_group = g_boc.bocgrup      #FUN-4C0056 add
 
   CALL i613_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i613_show()
 
   LET g_boc_t.* = g_boc.*                #保存單頭舊值
   LET g_boc_o.* = g_boc.*                #保存單頭舊值
   DISPLAY BY NAME g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04, g_boc.bocoriu,g_boc.bocorig,
                   g_boc.bocuser,g_boc.bocgrup,g_boc.bocmodu,
                   g_boc.bocdate,g_boc.bocacti 
 
   CALL i613_boc01('d')
   CALL i613_boc02('d')
   CALL i613_boc03('d')
   CALL i613_boc04('d')
   
   CALL i613_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i613_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_boc.boc01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i613_cl USING g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
   IF STATUS THEN
      CALL cl_err("OPEN i613_cl:", STATUS, 1)
      CLOSE i613_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i613_cl INTO g_boc.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_boc.boc01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i613_show()
 
   IF cl_exp(0,0,g_boc.bocacti) THEN                   #確認一下
      LET g_chr=g_boc.bocacti
      IF g_boc.bocacti='Y' THEN
         LET g_boc.bocacti='N'
      ELSE
         LET g_boc.bocacti='Y'
      END IF
 
      UPDATE boc_file SET bocacti=g_boc.bocacti,
                          bocmodu=g_user,
                          bocdate=g_today
       WHERE boc01=g_boc.boc01
       #Add No.MOD-AB0130
         AND boc02=g_boc.boc02
         AND boc03=g_boc.boc03
         AND boc04=g_boc.boc04
       #End Add No.MOD-AB0130
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err(g_boc.boc01,SQLCA.sqlcode,0)   #No.FUN-660129
         CALL cl_err3("upd","boc_file",g_boc.boc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_boc.bocacti=g_chr
      END IF
   END IF
 
   CLOSE i613_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_boc.boc01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT bocacti,bocmodu,bocdate
     INTO g_boc.bocacti,g_boc.bocmodu,g_boc.bocdate FROM boc_file
    WHERE boc01=g_boc.boc01
    #Add No.MOD-AB0130
      AND boc02=g_boc.boc02
      AND boc03=g_boc.boc03
      AND boc04=g_boc.boc04
    #End Add No.MOD-AB0130
   DISPLAY BY NAME g_boc.bocacti,g_boc.bocmodu,g_boc.bocdate
 
END FUNCTION
 
FUNCTION i613_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_boc.boc01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_boc.* FROM boc_file
    WHERE boc01=g_boc.boc01
      AND boc02=g_boc.boc02
      AND boc03=g_boc.boc03
      AND boc04=g_boc.boc04
   IF g_boc.bocacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_boc.boc01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN i613_cl USING g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
   IF STATUS THEN
      CALL cl_err("OPEN i613_cl:", STATUS, 1)
      CLOSE i613_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i613_cl INTO g_boc.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_boc.boc01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i613_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "boc01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_boc.boc01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM boc_file WHERE boc01 = g_boc.boc01
                             AND boc02 = g_boc.boc02
                             AND boc03 = g_boc.boc03
                             AND boc04 = g_boc.boc04
      DELETE FROM bod_file WHERE bod01 = g_boc.boc01
                             AND bod02 = g_boc.boc02
                             AND bod03 = g_boc.boc03
                             AND bod04 = g_boc.boc04
      CLEAR FORM
      CALL g_bod.clear()
      OPEN i613_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE i613_cs
         CLOSE i613_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH i613_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i613_cs
         CLOSE i613_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i613_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i613_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL i613_fetch('/')
      END IF
   END IF
 
   CLOSE i613_cl
   COMMIT WORK
   CALL cl_flow_notify(g_boc.boc01,'D')
END FUNCTION
 
#單身
FUNCTION i613_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_cnt           LIKE type_file.num5,                #檢查重複用 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否  
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_misc          LIKE gef_file.gef01,               
   l_n1      LIKE type_file.num5,  
   l_n2      LIKE type_file.num5,  
   l_n3      LIKE type_file.num5,  
   l_n4      LIKE type_file.num5,  
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                  #可刪除否  #No.FUN-680136 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_boc.boc01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_boc.* FROM boc_file
     WHERE boc01=g_boc.boc01
       AND boc02=g_boc.boc02
       AND boc03=g_boc.boc03
       AND boc04=g_boc.boc04
    IF g_boc.bocacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_boc.boc01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bod05,bod08,bod06,bod07,bod09",
                       "  FROM bod_file",
                       " WHERE bod01=? AND bod02=? AND bod03=? AND bod04=? AND bod05=? AND bod06=? FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i613_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bod WITHOUT DEFAULTS FROM s_bod.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
            CALL cl_set_comp_entry("bod08",TRUE)
            CALL cl_set_comp_entry("bod09",TRUE)
           
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i613_cl USING g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04
           IF STATUS THEN
              CALL cl_err("OPEN i613_cl:", STATUS, 1)
              CLOSE i613_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i613_cl INTO g_boc.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_boc.boc01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i613_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_bod_t.* = g_bod[l_ac].*  #BACKUP
              LET g_bod_o.* = g_bod[l_ac].*  #BACKUP
              OPEN i613_bcl USING g_boc.boc01,g_boc.boc02,g_boc.boc03,g_boc.boc04,g_bod_t.bod05,g_bod_t.bod06
              IF STATUS THEN
                 CALL cl_err("OPEN i613_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i613_bcl INTO g_bod[l_ac].bod05,g_bod[l_ac].bod08,
                                     g_bod[l_ac].bod06,g_bod[l_ac].bod07,
                                     g_bod[l_ac].bod09  
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_bod_t.bod05,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
 
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_bod[l_ac].* TO NULL      #900423
           LET g_bod_t.* = g_bod[l_ac].*         #新輸入資料
           LET g_bod_o.* = g_bod[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()       
           NEXT FIELD bod05
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO bod_file(bod01,bod02,bod03,bod04,bod05,bod06,
                                bod07,bod08,bod09)
           VALUES(g_boc.boc01,g_boc.boc02,
                  g_boc.boc03,g_boc.boc04,
                  g_bod[l_ac].bod05,g_bod[l_ac].bod06,
                  g_bod[l_ac].bod07,g_bod[l_ac].bod08,
                  g_bod[l_ac].bod09
                  )
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","bod_file",g_boc.boc01,g_bod[l_ac].bod05,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cnt2
           END IF
 
        AFTER FIELD bod05                        #check 序號是否重複
           IF NOT cl_null(g_bod[l_ac].bod05) THEN
             SELECT COUNT(*) INTO l_n1 FROM agd_file,agc_file
                    WHERE  (agd02=g_bod[l_ac].bod05 AND agd01=agc01 AND agc01=g_boc.boc03 AND agc04='2')
                       OR  ((g_bod[l_ac].bod05 BETWEEN agc05 AND agc06) AND agc01=g_boc.boc03 AND agc04='3')
                       OR   (agc04='1' and agc01=g_boc.boc03)
             IF l_n1 <= 0 THEN  
                         CALL cl_err('','abm_613',0)
                         NEXT FIELD bod05
             END IF
                  CALL i613_bod05_bod08()
           END IF
         
        AFTER FIELD bod06
           IF NOT cl_null(g_bod[l_ac].bod06) THEN
              SELECT COUNT(*) INTO l_n2 FROM bol_file WHERE  bolacti='Y' AND bol01=g_bod[l_ac].bod06
              IF l_n2 <= 0 THEN 
                      CALL cl_err('','abmi613',0)
                      NEXT FIELD bod06
              END IF
           ELSE	 
              LET g_bod[l_ac].bod06= ' '
           END IF 
              CALL i613_bod06('d')
        AFTER FIELD bod07
           IF NOT cl_null(g_bod[l_ac].bod07) THEN 
             SELECT COUNT(*) INTO l_n2 FROM agd_file,agc_file 
                             WHERE (agd02=g_bod[l_ac].bod07 AND  agd01=agc01 AND agc01=g_boc.boc04 AND agc04='2')
                                OR ((g_bod[l_ac].bod07 BETWEEN agc05 AND agc06) AND agc01=g_boc.boc04 AND agc04='3')
                                OR (agc04='1' AND agc01=g_boc.boc04)
             IF l_n2 <= 0 THEN 
                      CALL cl_err('','abm_611',0)
                      NEXT FIELD bod07
             END IF
                  CALL i613_bod09()
                  CALL i613_set_no_entry_bod09('d')
           END IF
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF  g_bod_t.bod05 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM bod_file
               WHERE bod01 = g_boc.boc01
                 AND bod02 = g_boc.boc02
                 AND bod03 = g_boc.boc03
                 AND bod04 = g_boc.boc04
                 AND bod05 = g_bod_t.bod05
                 AND bod06 = g_bod_t.bod06
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_bod_t.bod05,SQLCA.sqlcode,0)   #No.FUN-660129
                 CALL cl_err3("del","bod_file",g_boc.boc01,g_bod_t.bod05,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cnt2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_bod[l_ac].* = g_bod_t.*
              CLOSE i613_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_bod[l_ac].bod05,-263,1)
              LET g_bod[l_ac].* = g_bod_t.*
           ELSE
              UPDATE bod_file SET bod05=g_bod[l_ac].bod05,
                                  bod08=g_bod[l_ac].bod08,
                                  bod06=g_bod[l_ac].bod06,
                                  bod07=g_bod[l_ac].bod07,
                                  bod09=g_bod[l_ac].bod09 
               WHERE bod01=g_boc.boc01
                 AND bod02=g_boc.boc02
                 AND bod03=g_boc.boc03
                 AND bod04=g_boc.boc04
                 AND bod05=g_bod_t.bod05
                 AND bod06=g_bod_t.bod06
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                CALL cl_err(g_bod[l_ac].bod05,SQLCA.sqlcode,0)   #No.FUN-660129
                 CALL cl_err3("upd","bod_file",g_boc.boc01,g_bod_t.bod05,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_bod[l_ac].* = g_bod_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D40030
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_bod[l_ac].* = g_bod_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_bod.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i613_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D40030
           CLOSE i613_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(bod05) AND l_ac > 1 THEN
              LET g_bod[l_ac].* = g_bod[l_ac-1].*
              NEXT FIELD bod05
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION itemno
           IF g_sma.sma38 matches'[Yy]' THEN
              CALL cl_cmdrun("aimi109 ")
           ELSE
              CALL cl_err(g_sma.sma38,'mfg0035',1)
           END IF
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(bod05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_bod05"
               LET g_qryparam.default1 = g_bod[l_ac].bod05
               LET g_qryparam.arg1 = g_boc.boc03
               CALL cl_create_qry() RETURNING g_bod[l_ac].bod05
               DISPLAY BY NAME g_bod[l_ac].bod05
               NEXT FIELD bod05
 
             WHEN INFIELD(bod06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_bod06"
               LET g_qryparam.default1 = g_bod[l_ac].bod06
               CALL cl_create_qry() RETURNING g_bod[l_ac].bod06
               DISPLAY BY NAME g_bod[l_ac].bod06
               NEXT FIELD bod06
 
             WHEN INFIELD(bod07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_bod07"
               LET g_qryparam.default1 = g_bod[l_ac].bod07
               LET g_qryparam.arg1 = g_boc.boc04
               CALL cl_create_qry() RETURNING g_bod[l_ac].bod07
               DISPLAY BY NAME g_bod[l_ac].bod07
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE i613_bcl
    COMMIT WORK
#   CALL i613_delall()           #CHI-C30002 mark
    CALL i613_delHeader()        #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 ------- add -------- begin
FUNCTION i613_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM boc_file WHERE boc01 = g_boc.boc01
                                AND boc02 = g_boc.boc02
                                AND boc03 = g_boc.boc03
                               AND boc04 = g_boc.boc04
         INITIALIZE  g_boc.* TO NULL
         CLEAR FORM
      END IF
   END IF
        
END FUNCTION
#CHI-C30002 ------- add -------- end
#CHI-C30002 ------- mark ------- begin
#FUNCTION i613_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM bod_file
#   WHERE bod01 = g_boc.boc01
#     AND bod02 = g_boc.boc02
#     AND bod03 = g_boc.boc03
#     AND bod04 = g_boc.boc04
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM boc_file WHERE boc01 = g_boc.boc01
#                            AND boc02 = g_boc.boc02
#                            AND boc03 = g_boc.boc03
#                            AND boc04 = g_boc.boc04
#  END IF
#
#END FUNCTION
#CHI-C30002 ------- mark ------- end
 
FUNCTION i613_bod05_bod08()  #料件編號
   DEFINE l_agd03    LIKE agd_file.agd03,
          p_cmd      LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT agd03  INTO l_agd03 FROM agd_file 
          WHERE agd02=g_bod[l_ac].bod05 AND agd01=g_boc.boc03
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
        LET l_agd03 = NULL 
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(l_agd03) THEN
      LET g_bod[l_ac].bod08 = l_agd03
      DISPLAY BY NAME g_bod[l_ac].bod08
   END IF
   IF NOT cl_null(l_agd03) THEN
      CALL i613_set_no_entry_bod08('d')
   END IF
END FUNCTION
 
FUNCTION i613_bod09()  #單位
   DEFINE l_agd03    LIKE agd_file.agd03  
 
  LET g_errno = " "
  SELECT agd03 INTO l_agd03 FROM  agd_file 
   WHERE agd02=g_bod[l_ac].bod07 AND agd01=g_boc.boc04
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_agd03   = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(l_agd03) THEN
      LET g_bod[l_ac].bod09 = l_agd03
      DISPLAY BY NAME g_bod[l_ac].bod09
    END IF
   IF NOT cl_null(l_agd03) THEN
      CALL i613_set_no_entry_bod09('d')
   END IF
END FUNCTION
 
FUNCTION i613_b_askkey()
 
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON bod05,bod08,bod06,bod07,bod09
            FROM s_bod[1].bod05,s_bod[1].bod08,s_bod[1].bod06,
                 s_bod[1].bod07,s_bod[1].bod09 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
            WHEN INFIELD(bod05) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_pmc2"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bod05
              NEXT FIELD bod05
           END CASE
      #FUN-650191 add--end
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                #No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
                   CALL cl_qbe_select()
                 ON ACTION qbe_save
                   CALL cl_qbe_save()
                #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
 
    CALL i613_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i613_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT bod05,bod08,bod06,'',bod07,bod09",
               "  FROM bod_file",    #No.FUN-550019
               " WHERE bod01 ='",g_boc.boc01,"' ",  
               "   AND bod02 ='",g_boc.boc02,"'",
               "   AND bod03 ='",g_boc.boc03,"'",
               "   AND bod04 ='",g_boc.boc04,"'" 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY bod08,bod05,bod04 "
   DISPLAY g_sql
 
   PREPARE i613_pb FROM g_sql
   DECLARE bod_cs CURSOR FOR i613_pb
 
   CALL g_bod.clear()
   LET g_cnt = 1
 
   FOREACH bod_cs INTO g_bod[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT bol02  INTO g_bod[g_cnt].bod06_bol02 FROM  bol_file WHERE  bol01=g_bod[g_cnt].bod06 AND bolacti='Y'
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_bod.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i613_copy()
   DEFINE l_newno1     LIKE boc_file.boc01,
          l_newno2     LIKE boc_file.boc02,
          l_newno3     LIKE boc_file.boc03,
          l_newno4     LIKE boc_file.boc04,
          l_n       LIKE type_file.num5,  
          l_n2      LIKE type_file.num5,  
          l_n3      LIKE type_file.num5,  
          l_n4      LIKE type_file.num5,  
          l_oldno1    LIKE boc_file.boc01,
          l_oldno2    LIKE boc_file.boc02,
          l_oldno3    LIKE boc_file.boc03,
          l_oldno4    LIKE boc_file.boc04
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_ima02 LIKE ima_file.ima02        #No.FUN-870127  
   DEFINE l_imaag LIKE ima_file.imaag        #No.FUN-870127  
   DEFINE l_aga02 LIKE aga_file.aga02        #No.FUN-870127  
   DEFINE l_agc02 LIKE agc_file.agc02        #No.FUN-870127  
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_boc.boc01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
    LET g_before_input_done = FALSE    #No.FUN-870127
    CALL i613_set_entry('a')           #No.FUN-870127
 
   INPUT l_newno1,l_newno2,l_newno3,l_newno4 FROM boc01,boc02,boc03,boc04
#      BEFORE INPUT
#          CALL cl_set_docno_format("boc01")
 
      AFTER FIELD boc01
      #  IF NOT cl_null(g_boc.boc01) THEN
         IF NOT cl_null(l_newno1) THEN
           #FUN-AA0059 -------------------------add start-------------------------
            IF NOT s_chk_item_no(l_newno1,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD boc01
            END IF 
           #FUN-AA0059 -------------------------add end---------------------------
            IF NOT cl_null(l_newno2) THEN
               IF l_newno1 = l_newno2 THEN
                  CALL cl_err('','abm-321',0)
                  NEXT FIELD boc01 
               END IF
            END IF
            SELECT COUNT(*) INTO l_n FROM ima_file WHERE 
                            ima01=l_newno1 and ima151='Y' and imaacti='Y'
            IF l_n <= 0 THEN 
               NEXT FIELD boc01
            END IF
         #No.FUN-870127  ---begin
            SELECT ima02,imaag 
              INTO l_ima02,l_imaag  FROM ima_file WHERE ima01 = l_newno1
            SELECT aga02 INTO l_aga02 FROM aga_file,ima_file WHERE aga01=imaag and ima01= l_newno1
          DISPLAY l_ima02 TO FORMONLY.boc01_ima02
          DISPLAY l_imaag TO FORMONLY.boc01_imaag
          DISPLAY l_aga02 TO FORMONLY.boc01_imaag_aga02
         #No.FUN-870127 ----end
     #      CALL i613_boc01('d')
         END IF
 
      AFTER FIELD boc02
      #  IF NOT cl_null(g_boc.boc02) THEN
         IF NOT cl_null(l_newno2) THEN
            #FUN-AA0059 ------------------------add start----------------------
            IF NOT s_chk_item_no(l_newno2,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD boc02
            END IF 
            #FUN-AA0059 -----------------------add end-------------------------
            IF NOT cl_null(l_newno1) THEN
               IF l_newno1 = l_newno2 THEN
                   CALL cl_err('','abm-321',0)
                   NEXT FIELD boc02
               END IF
            END IF 
            SELECT COUNT(*) INTO l_n2 FROM ima_file WHERE 
                                      ima01=l_newno2 and ima151='Y' and imaacti='Y'
            IF l_n2 <= 0 THEN 
                     NEXT FIELD boc02
            END IF
          #No.FUN-870127 ---begin
            SELECT ima02,imaag 
              INTO l_ima02,l_imaag  FROM ima_file WHERE ima01 = l_newno2
            SELECT aga02 INTO l_aga02 FROM aga_file,ima_file WHERE aga01=imaag and ima01= l_newno2
            DISPLAY l_ima02 TO FORMONLY.boc02_ima02
            DISPLAY l_imaag TO FORMONLY.boc02_imaag
            DISPLAY l_aga02 TO FORMONLY.boc02_imaag_aga02
          #No.FUN-870127 --end
     #      CALL i613_boc02('d')
         END IF
      AFTER FIELD boc03
      #  IF NOT cl_null(g_boc.boc03) THEN
         IF NOT cl_null(l_newno3) THEN
            SELECT COUNT(*) INTO l_n3 FROM ima_file,agb_file,aga_file WHERE 
                   agb01=aga01 and aga01=imaag and ima01=l_newno1
                #  and agaacti='Y' and imaacti='Y' and agb01=l_newno3
                   and agaacti='Y' and imaacti='Y' and agb03=l_newno3
            IF l_n3 <= 0 THEN 
                     NEXT FIELD boc03
            END IF
            SELECT agc02 INTO l_agc02 FROM  agc_file WHERE  agc01=l_newno3 #NO.FUN-870127 
            DISPLAY l_agc02 TO FORMONLY.boc03_agc02                        #No.FUN-870127
     #      CALL i613_boc03('d')
         END IF
      AFTER FIELD boc04               
      #  IF NOT cl_null(g_boc.boc04) THEN
         IF NOT cl_null(l_newno4) THEN
            SELECT COUNT(*) INTO l_n4 FROM ima_file,agb_file,aga_file WHERE
                    #       agb01=aga01 and aga01=imaag and ima01=l_newno1
                            agb01=aga01 and aga01=imaag and ima01=l_newno2
                    #       and agaacti='Y' and imaacti='Y' and agb01=l_newno4 
                            and agaacti='Y' and imaacti='Y' and agb03=l_newno4 
            IF l_n4 <= 0 THEN 
                     NEXT FIELD boc04
            END IF
            SELECT agc02 INTO l_agc02 FROM  agc_file WHERE  agc01=l_newno4   #No.FUN-870127 
            DISPLAY l_agc02 TO FORMONLY.boc04_agc02                          #No.FUN-870127
     #      CALL i613_boc04('d')
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(boc01) 
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form ="q_boc01"
             #  LET g_qryparam.default1 = g_boc.boc01
             #  CALL cl_create_qry() RETURNING l_newno1
               CALL q_sel_ima(FALSE, "q_boc01", "", g_boc.boc01, "", "", "", "" ,"",'' )  RETURNING l_newno1
#FUN-AA0059 --End--
               DISPLAY l_newno1 TO boc01
               NEXT FIELD boc01
 
            WHEN INFIELD(boc02)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form ="q_boc01"
             #  LET g_qryparam.default1 = g_boc.boc02
             #  CALL cl_create_qry() RETURNING l_newno2 
               CALL q_sel_ima(FALSE, "q_boc01", "", g_boc.boc02, "", "", "", "" ,"",'' )  RETURNING l_newno2
#FUN-AA0059 --End--
           #   DISPLAY BY NAME l_newno2
               DISPLAY l_newno2 TO boc02
               NEXT FIELD boc02
 
            WHEN INFIELD(boc03)
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_boc03"
               LET g_qryparam.form ="q_boc03_1"  #NO.MOD-840510 mod
               LET g_qryparam.default1 = g_boc.boc03
            #  LET g_qryparam.arg1 = g_boc.boc01
               LET g_qryparam.arg1 = l_newno1
               CALL cl_create_qry() RETURNING l_newno3
            #  DISPLAY BY NAME l_newno3
               DISPLAY l_newno3 TO boc03
               NEXT FIELD boc03
 
            WHEN INFIELD(boc04)
               CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_boc04"
               LET g_qryparam.form ="q_boc04_1"    #NO.MOD-840510 mod
               LET g_qryparam.default1 = g_boc.boc04
            #  LET g_qryparam.arg1 = g_boc.boc02
               LET g_qryparam.arg1 = l_newno2
               CALL cl_create_qry() RETURNING l_newno4
            #  DISPLAY BY NAME l_newno4
               DISPLAY l_newno4 TO boc04
               NEXT FIELD boc04
 
            OTHERWISE EXIT CASE
          END CASE
 
     ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
 
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_boc.boc01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM boc_file         #單頭複製
       WHERE boc01=g_boc.boc01
         AND boc02=g_boc.boc02
         AND boc03=g_boc.boc03
         AND boc04=g_boc.boc04
       INTO TEMP y
 
   UPDATE y
       SET boc01=l_newno1,    #新的鍵值
           boc02=l_newno2,
           boc03=l_newno3,
           boc04=l_newno4,
           bocuser=g_user,   #資料所有者
           bocgrup=g_grup,   #資料所有者所屬群
           bocmodu=NULL,     #資料修改日期
           bocdate=g_today,  #資料建立日期
           bocacti='Y'       #有效資料
 
   INSERT INTO boc_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","boc_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM bod_file         #單身複製
       WHERE bod01=g_boc.boc01
         AND bod02=g_boc.boc02
         AND bod03=g_boc.boc03
         AND bod04=g_boc.boc04
            
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET bod01=l_newno1,
                bod02=l_newno2,
                bod03=l_newno3,
                bod04=l_newno4
 
   INSERT INTO bod_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","bod_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129  #No.FUN-B80100---上移一行調整至回滾事務前---
      ROLLBACK WORK #No:7857
      RETURN
   ELSE
       COMMIT WORK #No:7857
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
   LET l_oldno1 = g_boc.boc01
   LET l_oldno2 = g_boc.boc02
   LET l_oldno3 = g_boc.boc03
   LET l_oldno4 = g_boc.boc04
   SELECT boc_file.* INTO g_boc.* FROM boc_file WHERE boc01 = l_newno1 
                                                                    AND boc02 = l_newno2
                                                                    AND boc03 = l_newno3
                                                                    AND boc04 = l_newno4
 # CALL i613_u()                     #by ve007
   CALL i613_b()
   #FUN-C30027---begin
   #SELECT boc_file.* INTO g_boc.* FROM boc_file WHERE boc01 = l_oldno1
   #                                                                 AND boc02 = l_oldno2
   #                                                                 AND boc03 = l_oldno3
   #                                                                 AND boc04 = l_oldno4
   #CALL i613_show()
   #FUN-C30027---end
END FUNCTION
 
{FUNCTION i613_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    sr              RECORD
        boc01       LIKE boc_file.boc01,   #單據編號
        bod05       LIKE bod_file.bod05,   #廠商編號 #FUN-650191
        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
        boc04       LIKE boc_file.boc04,   #交易幣別
        boc06       LIKE boc_file.boc06,   #詢價日期
        bocacti     LIKE boc_file.bocacti, #資料有效碼
        bod05       LIKE bod_file.bod05,   #項次
        bod08       LIKE bod_file.bod08,   #料件編號
        bod081      LIKE bod_file.bod081,  #品名
        bod082      LIKE bod_file.bod082,  #規格      #MOD-640052
        bod06       LIKE bod_file.bod06,   #No.FUN-670099
        bod09       LIKE bod_file.bod09,   #詢價單位
        bod06       LIKE bod_file.bod06,   #採購價格
        bod03       LIKE bod_file.bod03,   #上限數量
        bod07       LIKE bod_file.bod07,   #折扣比率
        bod04       LIKE bod_file.bod04,   #生效日期
        bod05       LIKE bod_file.bod05,   #失效日期
        boc05       LIKE boc_file.boc05,   #稅別
        bod06t      LIKE bod_file.bod06t,  #含稅單價
        gec07       LIKE gec_file.gec07    #含稅否
       END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name 
    l_za05          LIKE za_file.za05,   
    l_azi03         LIKE azi_file.azi03,  
     #MOD-530329
    l_wc            STRING               
 
    IF cl_null(g_boc.boc01) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    IF cl_null(g_wc) THEN
       LET g_wc =" boc01='",g_boc.boc01,"'"       #TQC-760033 modify
       LET g_wc2=" 1=1 AND bod11='",g_bod11,"'"   #TQC-760033 modify
    END IF
     #MOD-530329(end)
 
    CALL cl_wait()
   #CALL cl_outnam('abmi613') RETURNING l_name   #No.FUN-710091  mark
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   #TQC-760033 add
    #No.FUN-710091   --begin
    CALL cl_del_data(l_table)
    LET  g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err("insert_prep:",STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B30211
       EXIT PROGRAM
    END IF
    #No.FUN-710091   --end
    #No.FUN-550019
    #LET g_sql="SELECT boc01,boc03,pmc03,boc04,boc06,bocacti,",  #FUN-650191
    LET g_sql="SELECT boc01,bod05,pmc03,boc04,boc06,bocacti,",   #FUN-650191 boc03->bod05
          " bod05,bod08,bod081,bod082,bod06,bod09,bod06,bod03,bod07,bod04,bod05,", #MOD-640052  #No.FUN-670099
          " boc05,boc051,bod06t,gec07",
          " FROM boc_file,bod_file,OUTER pmc_file,OUTER gec_file",
         #" WHERE bod01 = boc01 AND boc03=pmc_file.pmc01 AND ",g_wc CLIPPED, #FUN-650191
          " WHERE bod01 = boc01 AND bod05=pmc_file.pmc01 AND ",g_wc CLIPPED, #FUN-650191
          "   AND boc05 = gec_file.gec01 AND ",g_wc2 CLIPPED
    LET g_sql = g_sql CLIPPED," ORDER BY boc01,bod05"  #No.FUN-710091
    PREPARE i613_p1 FROM g_sql                # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('i613_p1',STATUS,0) END IF
    #end No.FUN-550019
 
    DECLARE i613_co                         # CURSOR
        CURSOR FOR i613_p1
 
   #START REPORT i613_rep TO l_name  #No.FUN-710091 mark
 
    FOREACH i613_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#No.FUN-610018
        #No.FUN-550019
#       IF sr.gec07 = 'Y' THEN      #No.FUN-560102
#          LET sr.bod06 = sr.bod06t
#       END IF
        #end No.FUN-550019
       #OUTPUT TO REPORT i613_rep(sr.*)  #No.FUN-710091
        SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01=sr.boc04
        EXECUTE insert_prep USING sr.*,l_azi03  #No.FUN-710091 
    END FOREACH
    #No.FUN-710091  --begin
    #str TQC-760033 modify
    #是否列印選擇條件
    #將cl_wcchp轉換後的g_wc放到l_wc,不要改變原來g_wc的值,不然第二次執行會有問題
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'boc01,boc06,boc04,boc05,boc051,bocuser,bocgrup,bocmodu,bocdate,bocacti')                 
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
   #CALL cl_wcchp(g_wc,'boc01,boc06,boc04,boc05,boc051,bocuser,bocgrup,bocmodu,bocdate,bocacti')                 
   #     RETURNING g_wc
    #end TQC-760033 modify
#   CALL cl_wcchp(g_wc2,'bod05,bod05,bod08,bod09,ima44,ima908,bod04,bod05,bod03,bod06,bod06t,bod07,bod082,bod11')
#        RETURNING  g_wc2
 
  # FINISH REPORT i613_rep   #No.FUN-710091 
 
    CLOSE i613_co
    ERROR ""
  # CALL cl_prt(l_name,' ','1',g_len)  #No.FUN-710091 mark
END FUNCTION
#No.FUN-710091  --begin
#REPORT i613_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680136 
#    l_str1          LIKE type_file.chr1000,#No.FUN-680136 
#    l_i             LIKE type_file.num5,  
#    sr              RECORD
#        boc01       LIKE boc_file.boc01,   #單據編號
#       #boc03       LIKE boc_file.boc03,   #廠商編號  #FUN-650191
#        bod05       LIKE bod_file.bod05,   #廠商編號  #FUN-650191
#        pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
#        boc04       LIKE boc_file.boc04,   #交易幣別
#        boc06       LIKE boc_file.boc06,   #詢價日期
#        bocacti     LIKE boc_file.bocacti, #資料有效碼
#        bod05       LIKE bod_file.bod05,   #項次
#        bod08       LIKE bod_file.bod08,   #料件編號
#        bod081      LIKE bod_file.bod081,  #品名
#        bod082      LIKE bod_file.bod082,  #規格        #MOD-640052
#        bod06       LIKE bod_file.bod06,   #No.FUN-670099
#        bod09       LIKE bod_file.bod09,   #詢價單位
#        bod06       LIKE bod_file.bod06,   #採購價格
#        bod03       LIKE bod_file.bod03,   #上限數量
#        bod07       LIKE bod_file.bod07,   #折扣比率
#        bod04       LIKE bod_file.bod04,   #生效日期
#        bod05       LIKE bod_file.bod05,   #失效日期
#        #No.FUN-550019
#        boc05       LIKE boc_file.boc05,   #稅別
#        boc051      LIKE boc_file.boc051,  #稅率
#        bod06t      LIKE bod_file.bod06t,  #含稅單價
#        gec07       LIKE gec_file.gec07    #含稅否
#        #end No.FUN-550019
#                    END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.boc01,sr.bod05
#    FORMAT
#        PAGE HEADER
##No.FUN-580010 --start
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#      LET l_trailer_sw = 'y'
## No.FUN-580013 --end---
#
#        BEFORE GROUP OF sr.boc01  #單據編號
#         IF (PAGENO > 1 OR LINENO > 9)
#            THEN SKIP TO TOP OF PAGE
#         END IF
#    #----------No.FUN-5A0139 begin
#         PRINTX name=H1
#               g_x[31],g_x[52],g_x[32],g_x[33],g_x[34], #TQC-5B0037 52->40   #TQC-6C0031 40->52
#               g_x[35],g_x[36],g_x[37],g_x[38]
##              g_x[39]   #No.FUN-610018
#         PRINTX name=H2
#               g_x[41],g_x[40],g_x[42],g_x[43],g_x[44], #TQC-5B0037 40->52   #TQC-6C0031 52->40
#               g_x[45],g_x[46]
#         PRINTX name=H3
#               g_x[47],g_x[51],g_x[48],g_x[53],g_x[49],g_x[50]  #No.FUN-610018
#         PRINTX name=H4 
#               g_x[54],g_x[55],g_x[56],g_x[57]     #MOD-640052  #No.FUN-670099
#         PRINT g_dash1
#         IF sr.bocacti MATCHES'[Nn]'  THEN
#            PRINTX name=D1
#               COLUMN g_c[31],'*';
#         END IF
#         SELECT azi03,azi04,azi05
#           INTO t_azi03,t_azi04,t_azi05          #幣別檔小數位數讀取   #No.CHI-6A0004
#           FROM azi_file
#          WHERE azi01=sr.boc04
#         LET l_str1=sr.boc051 USING '#############&','%'  #No.FUN-610018
#         PRINTX name=D1
#        #      COLUMN g_c[40],sr.bod05 USING '####', #TQC-5B0037 add   #TQC-6C0031 mark
#               COLUMN g_c[32],sr.boc01,
#               COLUMN g_c[33],sr.boc06,  #單據編號,日期
#               #COLUMN g_c[34],sr.boc03,  #FUN-650191
#               COLUMN g_c[34],sr.bod05,   #FUN-650191
#               COLUMN g_c[35],sr.pmc03,  #廠商
#               COLUMN g_c[36],sr.boc04;  #幣別
#         #No.FUN-550019
#         PRINTX name=D1
#               COLUMN g_c[37],sr.boc05,
#               COLUMN g_c[38],l_str1 CLIPPED
##              COLUMN g_c[39],sr.gec07   #No.FUN-610018
#         #end No.FUN-550019
#
#        ON EVERY ROW
#         PRINTX name=D2
#               COLUMN g_c[40],sr.bod05 USING '####', #TQC-5B0037 mark   #TQC-6C0031 mark回復
#               COLUMN g_c[42],sr.bod08,
#               COLUMN g_c[43],sr.bod09,
#               COLUMN g_c[44],cl_numfor(sr.bod06,44,t_azi03),  #No.CHI-6A0004
#               COLUMN g_c[45],sr.bod07 USING '######.###',
#               COLUMN g_c[46],cl_numfor(sr.bod03,46,t_azi03)   #No.CHI-6A0004
#         PRINTX name=D3
#               COLUMN g_c[48],sr.bod081 CLIPPED,  #MOD-640052
#               COLUMN g_c[53],cl_numfor(sr.bod06t,44,t_azi03),  #No.FUN-610018  #No.CHI-6A0004
#               COLUMN g_c[49],sr.bod04,
#               COLUMN g_c[50],sr.bod05
##----------No.FUN-5A0139 end
#         PRINTX name=D4 COLUMN g_c[56],sr.bod082 CLIPPED,   #MOD-640052
#                        COLUMN g_c[57],sr.bod06 CLIPPED
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
#               IF g_wc.subString(001,080) > ' ' THEN
#                  PRINT g_x[8] CLIPPED,g_wc.subString(001,070) CLIPPED
#               END IF
#               IF g_wc.subString(071,140) > ' ' THEN
#                  PRINT COLUMN 10,     g_wc.subString(071,140) CLIPPED
#               END IF
#               IF g_wc.subString(141,210) > ' ' THEN
#                  PRINT COLUMN 10,     g_wc.subString(141,210) CLIPPED
#               END IF
#               PRINT g_dash[1,g_len]
#            END IF
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        AFTER  GROUP OF sr.boc01  #單據編號
#            PRINT ' '
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-710091  --end
}
FUNCTION i613_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
 
     IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("boc01,boc02,boc03,boc04",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i613_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
     IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("boc01,boc02,boc03,boc04",FALSE)
     END IF
 
END FUNCTION
 
FUNCTION i613_set_no_entry_bod08(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
  DEFINE l_agc04 LIKE agc_file.agc04
      SELECT agc04 INTO l_agc04  FROM agc_file WHERE agc01=g_boc.boc03
       IF l_agc04!='2'  THEN
          CALL cl_set_comp_entry("bod08",TRUE)
       ELSE 
          CALL cl_set_comp_entry("bod08",FALSE)
       END IF
 
END FUNCTION
 
FUNCTION i613_set_no_entry_bod09(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
  DEFINE l_agc04 LIKE agc_file.agc04
      SELECT agc04 INTO l_agc04  FROM agc_file WHERE agc01=g_boc.boc04  #NO.FUN-830088
       IF l_agc04!='2'  THEN
          CALL cl_set_comp_entry("bod09",TRUE)
       ELSE 
          CALL cl_set_comp_entry("bod09",FALSE)
       END IF
 
END FUNCTION
#No.FUN-810014
#No.FUN-870127
