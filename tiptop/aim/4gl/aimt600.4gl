# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt600.4gl
# Descriptions...: 批序號與特性變更作業
# Date & Author..: No.TQC-B90236 11/10/17 BY yuhuabao
# Modify.........: No.TQC-C20445 12/02/24 By zhuhao AFTER FIELD ine03 錯誤信息長度修改
# Modify.........: No.TQC-C20448 12/02/24 By zhuhao AFTER FIELD inf03 料件編號的檢查，應用標準
#                                                   開窗也請用標準的寫法
# Modify.........: No.TQC-C20481 12/02/24 By yuhuabao 變更後批號(inf04a)、變更後序號(inf05a)可空白，且不需判斷一定要在批號庫存明細檔中
# Modify.........: No.TQC-C20468 12/02/24 By zhuhao 單據確認後，再取消確認，狀況碼變成0
# Modify.........: No.TQC-C20472 12/02/24 By zhuhao mark 匯出Excel
# Modify.........: No.TQC-C20482 12/02/24 By yuhuabao 確認和發出時加上判斷
# Modify.........: No.TQC-C20467 12/02/28 By yuhuabao select from inj_file時加上條件判斷
# Modify.........: No.TQC-C20470 12/02/28 By yuhuabao update inj_file時加上條件判斷
# Modify.........: No.TQC-C20448 12/03/01 By zhuhao 開窗也請用標準的寫法
# Modify.........: No.MOD-C30656 12/03/14 By yuhuabao 製造批號開窗修改
# Modify.........: No.MOD-C30500 12/03/14 By yuhuabao 修改寫入tlfs_file的条件
# Modify.........: No.MOD-C30434 12/03/19 By yuhuabao bug修改
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C50180 12/05/22 By zhuhao 項次大於零，料號不可重複。UPDATE imgs_file 時條件更改
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30106 12/06/17 By bart 可針對已存在的批號作併批處理,加上數量的處理
# Modify.........: No:CHI-C80041 12/12/18 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.FUN-CC0094 13/01/21 By fengrui 增加發出人員、日期、時間
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#变量定义--begin
DEFINE    g_ine    RECORD LIKE   ine_file.*,
          g_ine_t  RECORD LIKE   ine_file.*,
          g_ine_o  RECORD LIKE   ine_file.*
DEFINE    g_smy    RECORD LIKE   smy_file.*
DEFINE    g_ine01         LIKE   ine_file.ine01,    #變更單號
          g_ine01_t       LIKE   ine_file.ine01     #變更單號 (舊值)
DEFINE    g_inf    DYNAMIC ARRAY OF RECORD
             inf02        LIKE   inf_file.inf02,
             inf03        LIKE   inf_file.inf03,
             ima02        LIKE   ima_file.ima02,
             inf04b       LIKE   inf_file.inf04b,
             inf05b       LIKE   inf_file.inf05b,
             inf06b       LIKE   inf_file.inf06b,
             inf07b       LIKE   inf_file.inf07b,
             inf08        LIKE   inf_file.inf08,
             ini02        LIKE   ini_file.ini02,
             inf09b       LIKE   inf_file.inf09b,
             ima021       LIKE   ima_file.ima021,
             inf04a       LIKE   inf_file.inf04a,
             inf05a       LIKE   inf_file.inf05a,
             inf06a       LIKE   inf_file.inf06a,
             inf07a       LIKE   inf_file.inf07a,
             inf09a       LIKE   inf_file.inf09a,
             inf10        LIKE   inf_file.inf10   #FUN-C30106
                          END RECORD
DEFINE    g_inf_t         RECORD
             inf02        LIKE   inf_file.inf02,
             inf03        LIKE   inf_file.inf03,
             ima02        LIKE   ima_file.ima02,
             inf04b       LIKE   inf_file.inf04b,
             inf05b       LIKE   inf_file.inf05b,
             inf06b       LIKE   inf_file.inf06b,
             inf07b       LIKE   inf_file.inf07b,
             inf08        LIKE   inf_file.inf08,
             ini02        LIKE   ini_file.ini02,
             inf09b       LIKE   inf_file.inf09b,
             ima021       LIKE   ima_file.ima021,
             inf04a       LIKE   inf_file.inf04a,
             inf05a       LIKE   inf_file.inf05a,
             inf06a       LIKE   inf_file.inf06a,
             inf07a       LIKE   inf_file.inf07a,
             inf09a       LIKE   inf_file.inf09a,
             inf10        LIKE   inf_file.inf10   #FUN-C30106
                          END RECORD
DEFINE g_wc                STRING
DEFINE g_wc2               STRING
DEFINE g_sql               STRING
DEFINE g_rec_b             LIKE type_file.num5     #單身筆數
DEFINE l_ac                LIKE type_file.num5     #目前處理的ARRAY CNT
DEFINE g_forupd_sql        STRING                  #SELECT ...  FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_chr2              LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE mi_no_ask           LIKE type_file.num5
DEFINE g_t1                LIKE type_file.chr5

#变量定义--end

MAIN
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)
       DEFER INTERRUPT
    END IF

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_wc2=' 1=1'
    LET g_forupd_sql = "SELECT * FROM ine_file WHERE ine01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_cl CURSOR FROM g_forupd_sql

    OPEN WINDOW t600_w WITH FORM "aim/42f/aimt600"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    CALL t600_menu()
    CLOSE t600_cl
    CLOSE WINDOW t600_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#qbe资料查询
FUNCTION  t600_curs()
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
   CLEAR FORM                #NO:7203
   CALL g_inf.clear()
   CALL cl_set_head_visible("","YES")
   INITIALIZE g_ine.* TO NULL
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON ine01,ine02,ine03,ine04,ineconf,ine05,inemksg,
                                ineuser,inegrup,ineoriu,ineorig,inemodu,inedate,
                                inesendu,inesendd,                               #FUN-CC0094 add
                                ineud01,ineud02,ineud03,ineud04,ineud05,ineud06,
                                ineud07,ineud08,ineud09,ineud10,ineud11,ineud12,
                                ineud13,ineud14,ineud15
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT

      CONSTRUCT g_wc2  ON inf02,inf03,inf04b,inf05b,inf06b,inf07b,inf08,inf09b,
                          inf04a,inf05a,inf06a,inf07a,inf09a,inf10  #FUN-C30106
           FROM  s_inf[1].inf02,s_inf[1].inf03,s_inf[1].inf04b,s_inf[1].inf05b,
                 s_inf[1].inf06b,s_inf[1].inf07b,s_inf[1].inf08,s_inf[1].inf09b,
                 s_inf[1].inf04a,s_inf[1].inf05a,s_inf[1].inf06a,s_inf[1].inf07a,
                 s_inf[1].inf09a,s_inf[1].inf10  #FUN-C30106
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT

      ON ACTION controlp
         CASE
            WHEN INFIELD(ine01) #變更單號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ine01"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ine01
               NEXT FIELD ine01

            WHEN INFIELD(ine03) #變更理由
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ine03"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ine03
               NEXT FIELD ine03
               
            WHEN INFIELD(ine04) #變更人員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ine04"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ine04
               NEXT FIELD ine04
               
            WHEN INFIELD(inf03) #料件編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inf03"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inf03
               NEXT FIELD inf03
               
            WHEN INFIELD(inf04a) #變更后製造批號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inf04a"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inf04a
               NEXT FIELD inf04a
               
            WHEN INFIELD(inf04b) #變更前製造批號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inf04b"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inf04b
               NEXT FIELD inf04b
               
            WHEN INFIELD(inf05a) #變更后序號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inf05a"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inf05a
               NEXT FIELD inf05a 
               
            WHEN INFIELD(inf05b) #變更前序號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inf05b"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inf05b
               NEXT FIELD inf05b

            WHEN INFIELD(inf07b) #變更前歸屬單號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inf07b"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inf07b
               NEXT FIELD inf07b
               
            WHEN INFIELD(inf08)  #特性代碼
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_inf08"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inf08
               NEXT FIELD inf08
            OTHERWISE
         END CASE
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION accept
         EXIT DIALOG

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG

      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG
   END DIALOG
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ineuser', 'inegrup')

   IF g_wc2 = " 1=1" THEN
      LET g_sql =  "SELECT UNIQUE ine01 FROM ine_file",
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY ine01"
   ELSE
      LET g_sql = "SELECT UNIQUE ine01 FROM ine_file,inf_file",
                  " WHERE ine01 = inf01 AND ",g_wc CLIPPED,    #MOD-C30434 add
                  "   AND ",g_wc2 CLIPPED,
                  "  ORDER BY ine01"
   END IF

   PREPARE t600_prepare FROM g_sql      #預備一下
   DECLARE t600_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t600_prepare   
                  
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT COUNT(DISTINCT ine01) FROM ine_file",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY ine01"
   ELSE
      LET g_sql = "SELECT COUNT(DISTINCT ine01) FROM ine_file,inf_file",
                  " WHERE ine01 = inf01 AND ",g_wc CLIPPED, #MOD-C30434 add
                  "   AND ",g_wc2 CLIPPED,
                  "  ORDER BY ine01"
   END IF
   
   PREPARE t600_precount FROM g_sql      #預備一下
   DECLARE t600_count                 #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR t600_precount    
END FUNCTION

#菜单
FUNCTION t600_menu()
   WHILE TRUE
      CALL t600_bp('G')
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
        
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF

         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF

         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF

         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t600_b()
            ELSE
               LET g_action_choice = NULL
            END IF 

        #@WHEN "確認"
        WHEN "confirm"
           IF cl_chk_act_auth() THEN
              CALL t600_confirm()
            END IF
            
        #@WHEN "取消確認"     
        WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
              CALL t600_unconfirm()
            END IF
            
         #@WHEN "發出"
         WHEN "issued"
            IF cl_chk_act_auth() THEN
               CALL t600_issued()
            END IF 
            
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
       #TQC-C20472--mark--begin
        #WHEN "exporttoexcel"
        #   IF cl_chk_act_auth() THEN
        #      CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_inf),'','')
        #   END IF
       #TQC-C20472--mark--end
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ine.ine01 IS NOT NULL THEN
                    LET g_doc.column1 = "ine01"
                    LET g_doc.value1 = g_ine.ine01
                 CALL cl_doc()
                 END IF
              END IF   
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t600_v()     #CHI-D20010
               CALL t600_v(1)    #CHI-D20010
               CALL t600_show() 
            END IF
         #CHI-C80041---end   
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t600_v(2)
               CALL t600_show()
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION

#显示单身及action的显示及隐藏及功能的入口
FUNCTION t600_bp(p_ud)
DEFINE   p_ud   LIKE  type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel",FALSE)
   DISPLAY ARRAY g_inf TO s_inf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
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
         CALL t600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY

      ON ACTION previous
         CALL t600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY

      ON ACTION jump
         CALL t600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY

      ON ACTION next
         CALL t600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY

      ON ACTION last
         CALL t600_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY

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
         IF g_ine.ineconf='X' THEN LET g_chr='Y'  ELSE LET g_chr='N'  END IF
         IF g_ine.ine05='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_ine.ineconf,g_chr2,"","",g_chr,"")


      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

     #@ON ACTION 確認
       ON ACTION confirm
          LET g_action_choice="confirm"
          EXIT DISPLAY
   
     #@ON ACTION 取消確認
       ON ACTION unconfirm
          LET g_action_choice="unconfirm"
          EXIT DISPLAY  
             
     #@ON ACTION 發出     
       ON ACTION issued
          LET g_action_choice="issued"
          EXIT DISPLAY
      #CHI-C80041---begin
       ON ACTION void
          LET g_action_choice="void"
          EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
       ON ACTION undo_void
          LET g_action_choice="undo_void"
          EXIT DISPLAY
      #CHI-D20010---end
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

       ON ACTION about
          CALL cl_about()

       ON ACTION related_document
          LET g_action_choice="related_document"
          EXIT DISPLAY
      #TQC-C20472--mark--begin
      #ON ACTION exporttoexcel
      #   LET g_action_choice = 'exporttoexcel'
      #   EXIT DISPLAY
      #TQC-C20472--mark--end   
       AFTER DISPLAY
          CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)       
END FUNCTION

#新增资料
FUNCTION t600_a()
DEFINE    li_result   LIKE  type_file.num5
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_inf.clear()
   INITIALIZE g_ine.*   LIKE ine_file.*             #DEFAULT 設定
   INITIALIZE g_ine_t.* LIKE ine_file.*             #DEFAULT 設定
   INITIALIZE g_ine_o.* LIKE ine_file.*             #DEFAULT 設定

   LET g_ine01_t = NULL
   
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_ine.ine02 = g_today
      LET g_ine.ineconf = 'N'
      LET g_ine.ine05   = '0'
      LET g_ine.inemksg = 'N'
      LET g_ine.ineuser = g_user
      LET g_ine.inegrup = g_grup
      LET g_ine.ineoriu = g_user
      LET g_ine.ineorig = g_grup
      LET g_ine.ineplant = g_plant
      LET g_ine.inelegal = g_legal
      INITIALIZE g_inf_t.* TO NULL

      CALL t600_i("a")
      IF INT_FLAG THEN                   #使用者不玩了
          INITIALIZE g_ine.* TO NULL
          LET INT_FLAG = 0
          CLEAR FORM 
          EXIT WHILE
       END IF

       IF cl_null(g_ine.ine01) THEN
          CONTINUE WHILE
       END IF

       IF g_smy.smyauno='Y' THEN
          CALL s_auto_assign_no("aim",g_ine.ine01,g_ine.ine02,"1","ine_file","ine01","","","")
               RETURNING li_result,g_ine.ine01
          IF (NOT li_result) THEN
             CONTINUE WHILE
          END IF
          DISPLAY BY NAME g_ine.ine01
       END IF
       MESSAGE '' 
       IF cl_null(g_ine.inemksg) THEN
          LET  g_ine.inemksg = g_smy.smyapr
       END IF
       IF cl_null(g_ine.inemksg) THEN
          LET g_ine.inemksg = 'N'
       END IF
       
       INSERT INTO ine_file VALUES(g_ine.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)
          CONTINUE WHILE
       END IF 
       
       LET g_rec_b = 0
       CALL t600_b()
       EXIT WHILE 
    END WHILE 

END FUNCTION

#删除资料
FUNCTION t600_r()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_ine.ine01 IS NULL OR g_ine.ine01 = ' ' THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_ine.ineconf = 'Y' THEN
      CALL cl_err('','apm-242',0)
      RETURN
   END IF
   IF g_ine.ineconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF

   IF g_ine.ine05 matches '[Ss1]' THEN 
       CALL cl_err("","mfg3557",0)
       RETURN
   END IF
   BEGIN WORK

   OPEN t600_cl USING g_ine.ine01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_ine.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t600_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "ine01"
      LET g_doc.value1 = g_ine.ine01
      CALL cl_del_doc()

      DELETE FROM ine_file WHERE ine01 = g_ine.ine01
      DELETE FROM inf_file WHERE inf01 = g_ine.ine01
      
      INITIALIZE g_ine.* TO NULL
      CLEAR FORM
      CALL g_inf.clear()
      
      OPEN t600_count
      FETCH t600_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t600_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t600_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE      
         CALL t600_fetch('/')
      END IF
   END IF
 
   CLOSE t600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ine.ine01,'D')      
END FUNCTION

#修改资料
FUNCTION t600_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_ine.ine01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
   END IF

   IF g_ine.ineconf = 'Y' THEN
      CALL cl_err('','apm-242',0)
      RETURN
   END IF
   IF g_ine.ineconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_ine.ine05 matches '[Ss]' THEN        
      CALL cl_err('','apm-030',0)
      RETURN
   END IF
   IF g_ine.ine05 = '1' AND g_ine.inemksg = 'Y' THEN
      CALL cl_err('','mfg3186',0)
      RETURN
   END IF
   CALL cl_opmsg('u')
  BEGIN WORK

   OPEN t600_cl USING g_ine.ine01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_ine.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t600_cl
       ROLLBACK WORK
       RETURN
   END IF

   LET g_ine01_t = g_ine.ine01
   LET g_ine_o.* = g_ine.*
   CALL t600_show()
   WHILE TRUE
       LET g_ine01_t = g_ine.ine01
       LET g_ine.inemodu=g_user
       LET g_ine.inedate=g_today
       CALL t600_i("u")                      #欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_ine.*=g_ine_o.*
           LET g_ine.ine01 = g_ine_o.ine01
           DISPLAY BY NAME g_ine.ine01
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       IF g_ine.ine01 != g_ine01_t THEN            # 更改單號
          UPDATE inf_file SET inf01 = g_ine.ine01
           WHERE inf01 = g_ine01_t

          IF SQLCA.sqlcode THEN
             CALL cl_err('inf',SQLCA.sqlcode,0) CONTINUE WHILE
          END IF
       END IF
       
       LET g_ine.ine05 = '0'
       UPDATE ine_file SET ine_file.* = g_ine.*
        WHERE ine01 = g_ine01_t
        
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)
          CONTINUE WHILE
       END IF
       EXIT WHILE
   END WHILE

   IF g_ine.ineconf='X' THEN LET g_chr='Y'  ELSE LET g_chr='N'  END IF
   IF g_ine.ine05='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_ine.ineconf,g_chr2,"","",g_chr,"")
   COMMIT WORK
   CALL t600_show()   
END FUNCTION

#查询资料
FUNCTION t600_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   CALL cl_msg("")

   CLEAR FORM
   CALL g_inf.clear()
   CALL t600_curs()                    #取得查詢條件
   DISPLAY '' TO FORMONLY.cnt
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t600_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ine.ine01 TO NULL
   ELSE
      CALL t600_fetch('F')            #讀出TEMP第一筆並顯示
      OPEN t600_count
      FETCH t600_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   END IF

END FUNCTION


#录入数据
FUNCTION t600_i(p_cmd)
DEFINE   p_cmd   LIKE   type_file.chr1,
         li_result  LIKE type_file.num5
   CALL cl_set_head_visible("","YES")
   DISPLAY BY NAME  g_ine.ine02,g_ine.ineconf,g_ine.ine05,g_ine.inemksg,
                    g_ine.ineuser,g_ine.inegrup,g_ine.ineoriu,g_ine.ineorig
   INPUT BY NAME g_ine.ine01,g_ine.ine02,g_ine.ine03,g_ine.ine04,
                 g_ine.ineud01,g_ine.ineud02,g_ine.ineud03,g_ine.ineud04,
                 g_ine.ineud05,g_ine.ineud06,g_ine.ineud07,g_ine.ineud08,
                 g_ine.ineud09,g_ine.ineud10,g_ine.ineud11,g_ine.ineud12,
                 g_ine.ineud13,g_ine.ineud14,g_ine.ineud15
                 WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_set_docno_format("ine01")
         LET  g_before_input_done = FALSE
         CALL t600_set_entry(p_cmd)
         CALL t600_set_no_entry(p_cmd)
         LET  g_before_input_done = TRUE

      AFTER FIELD ine01
         IF NOT cl_null(g_ine.ine01) THEN
            LET g_t1 =  s_get_doc_no(g_ine.ine01)
            CALL s_check_no("aim",g_ine.ine01,g_ine01_t,"J","ine_file","ine01","")
               RETURNING li_result,g_ine.ine01

            DISPLAY BY NAME g_ine.ine01
            IF (NOT li_result) then
               LET g_ine.ine01 = g_ine_t.ine01
               NEXT FIELD ine01
            END IF
            SELECT * INTO g_smy.* FROM smy_file 
             WHERE smyslip = g_t1
            IF g_ine_t.ine01 IS NULL OR 
                (g_ine_t.ine01 != g_ine.ine01) THEN
               LET g_ine.inemksg = g_smy.smyapr
               LET g_ine.ine05   = '0'
               DISPLAY BY NAME g_ine.ine05
               DISPLAY BY NAME g_ine.inemksg
            END IF
         END IF 

      AFTER FIELD ine02
         IF NOT cl_null(g_ine.ine02) THEN
            LET g_errno = ''
            IF YEAR(g_ine.ine02) <> YEAR(g_today) THEN 
               LET g_errno = 'aim1139'
            ELSE
               IF g_ine.ine02 < g_sma.sma53 THEN
                  LET g_errno = 'axm-164'
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ine.ine02 = g_ine_t.ine02
               NEXT FIELD ine02
            END IF
         END IF 
         
      AFTER FIELD ine03
         IF NOT cl_null(g_ine.ine03) THEN
            CALL t600_ine03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ine.ine03 = g_ine_t.ine03
               NEXT FIELD ine03
            END IF
         END IF

      AFTER FIELD ine04
         IF NOT cl_null(g_ine.ine04) THEN
           CALL t600_ine04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_ine.ine04 = g_ine_t.ine04
               NEXT FIELD ine04
            END IF
         END IF

      AFTER FIELD ineud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD ineud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ine01)         
               LET g_t1 = s_get_doc_no(g_ine.ine01)
               CALL q_smy(FALSE,FALSE,g_t1,'AIM','J') RETURNING g_t1
               LET g_ine.ine01 = g_t1
               DISPLAY g_ine.ine01 TO ine01
               NEXT FIELD ine01
               
            WHEN INFIELD(ine03)         
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azf01a"
               LET g_qryparam.default1 = g_ine.ine03
               LET g_qryparam.arg1 = '4'
               CALL cl_create_qry() RETURNING g_ine.ine03
               DISPLAY g_ine.ine03 TO ine03
               NEXT FIELD ine03

            WHEN INFIELD(ine04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               LET g_qryparam.default1 = g_ine.ine04
               CALL cl_create_qry() RETURNING g_ine.ine04
               DISPLAY g_ine.ine04 TO ine04
               NEXT FIELD ine04
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

#根据qbe条件取出资料
FUNCTION t600_fetch(p_flag)
DEFINE   p_flag   LIKE   type_file.chr1
   CALL cl_msg("")

   CASE p_flag
       WHEN 'N' FETCH NEXT     t600_cs INTO g_ine.ine01
       WHEN 'P' FETCH PREVIOUS t600_cs INTO g_ine.ine01
       WHEN 'F' FETCH FIRST    t600_cs INTO g_ine.ine01
       WHEN 'L' FETCH LAST     t600_cs INTO g_ine.ine01
       WHEN '/'
           IF (NOT mi_no_ask) THEN
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
           FETCH ABSOLUTE g_jump t600_cs INTO g_ine.ine01
           LET mi_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN                         
      INITIALIZE g_ine.* TO NULL
      CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)
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
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   SELECT * INTO g_ine.* FROM ine_file WHERE ine01 = g_ine.ine01
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)
      INITIALIZE g_ine.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_ine.ineuser
   LET g_data_group = g_ine.inegrup
   LET g_data_plant = g_ine.ineplant
   CALL t600_show()
END FUNCTION

#填充资料至单身
FUNCTION t600_b_fill(p_wc)
DEFINE   p_wc    STRING
   LET g_sql = "SELECT inf02,inf03,'',inf04b,inf05b,inf06b,inf07b,inf08,'',inf09b,",
               "                   '',inf04a,inf05a,inf06a,inf07a,         inf09a,", 
               " inf10 ",    #FUN-C30106
               "  FROM inf_file",  
               " WHERE inf01 = '",g_ine.ine01,"'",
               "   AND ",p_wc CLIPPED,
               "  ORDER BY inf02"
   PREPARE t600_pb FROM g_sql
   DECLARE inf_cs CURSOR FOR t600_pb
   CALL g_inf.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH inf_cs INTO g_inf[g_cnt].*
      IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
      END IF

      SELECT ima02,ima021 INTO g_inf[g_cnt].ima02,g_inf[g_cnt].ima021
        FROM ima_file
       WHERE ima01 = g_inf[g_cnt].inf03
      SELECT ini02 INTO g_inf[g_cnt].ini02
        FROM ini_file
       WHERE ini01 = g_inf[g_cnt].inf08
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_inf.deleteElement(g_cnt)

   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   
END FUNCTION

#显示资料至画面档
FUNCTION t600_show()

   LET g_ine_t.* = g_ine.*
   DISPLAY BY NAME g_ine.ine01,g_ine.ine02,g_ine.ine03,g_ine.ine04,g_ine.ineconf,
                   g_ine.ine05,g_ine.inemksg,g_ine.ineuser,g_ine.inegrup,
                   g_ine.ineoriu,g_ine.ineorig,g_ine.inemodu,g_ine.inedate,
                   g_ine.inesendu,g_ine.inesendd,g_ine.inesendt,            #FUN-CC0094 add
                   g_ine.ineud01,g_ine.ineud02,g_ine.ineud03,g_ine.ineud04,
                   g_ine.ineud05,g_ine.ineud06,g_ine.ineud07,g_ine.ineud08,
                   g_ine.ineud09,g_ine.ineud10,g_ine.ineud11,g_ine.ineud12,
                   g_ine.ineud13,g_ine.ineud14,g_ine.ineud15

   IF g_ine.ineconf='X' THEN LET g_chr='Y'  ELSE LET g_chr='N'  END IF
   IF g_ine.ine05='1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_ine.ineconf,g_chr2,"","",g_chr,"")
   CALL t600_ine03('d')
   CALL t600_ine04('d')
   CALL t600_b_fill(g_wc2)
   CALL cl_show_fld_cont()
                  
END FUNCTION

#单身资料的处理
FUNCTION t600_b()
   DEFINE l_ac_t          LIKE type_file.num5     #未取消的ARRAY CNT
   DEFINE l_n             LIKE type_file.num5     #檢查重複用
   DEFINE l_n1            LIKE type_file.num5     #TQC-C50180
   DEFINE l_cnt           LIKE type_file.num5 
   DEFINE l_lock_sw       LIKE type_file.chr1     #單身鎖住否
   DEFINE p_cmd           LIKE type_file.chr1     #處理狀態
   DEFINE l_i             LIKE type_file.num5 
   DEFINE l_allow_insert  LIKE type_file.num5     #可新增否
   DEFINE l_allow_delete  LIKE type_file.num5     #可刪除否

   DEFINE l_flag          LIKE type_file.chr1
   DEFINE l_date          LIKE type_file.dat 
   DEFINE l_inf10         LIKE inf_file.inf10  #FUN-C30106


   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ine.ine01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_ine.* FROM ine_file
    WHERE ine01 = g_ine.ine01


   IF g_ine.ineconf = 'Y' THEN
      CALL cl_err('','apm-242',0)
      RETURN
   END IF
   IF g_ine.ineconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF

   IF g_ine.ine05 matches '[Ss]' THEN
      CALL cl_err('','apm-030',0)
      RETURN
   END IF

   IF g_ine.ine05 = '1' AND g_ine.inemksg = 'Y' THEN
      CALL cl_err('','mfg3186',0)
      RETURN
   END IF

   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT inf02,inf03,'',inf04b,inf05b,inf06b,inf07b,inf08,'',inf09b,",
                      "                   '',inf04a,inf05a,inf06a,inf07a,         inf09a,",  
                      " inf10 ",  #FUN-C30106   
                      "  FROM inf_file",
                      " WHERE inf01 = ? AND inf02 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_inf WITHOUT DEFAULTS FROM s_inf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF

      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK

         OPEN t600_cl USING g_ine.ine01
         IF STATUS THEN
            CALL cl_err("OPEN t600_cl:", STATUS, 1)
            CLOSE t600_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH t600_cl INTO g_ine.*            # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE t600_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_inf_t.* = g_inf[l_ac].*  #BACKUP

  
            OPEN t600_bcl USING g_ine.ine01,g_inf_t.inf02
            IF STATUS THEN
               CALL cl_err("OPEN t600_bcl:", STATUS, 1)
            ELSE
               FETCH t600_bcl INTO g_inf[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_inf_t.inf02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF

               SELECT ima02,ima021 INTO g_inf[l_ac].ima02,g_inf[l_ac].ima021
                 FROM ima_file
                WHERE ima01=g_inf[l_ac].inf03
               SELECT ini02 INTO g_inf[l_ac].ini02
                 FROM ini_file
                WHERE ini01 = g_inf[l_ac].inf08
            END IF
   
            CALL t600_set_entry_b(p_cmd)
            CALL t600_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_inf[l_ac].* TO NULL      

         LET g_inf_t.* = g_inf[l_ac].*         #新輸入資料

         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)
         CALL cl_show_fld_cont()
         NEXT FIELD inf02
         
      BEFORE FIELD inf02    #预设项次
         IF g_inf[l_ac].inf02 IS NULL
            OR g_inf[l_ac].inf02 = 0 THEN
            SELECT MAX(inf02)+1 INTO g_inf[l_ac].inf02
              FROM inf_file
             WHERE inf01 = g_ine.ine01
            IF g_inf[l_ac].inf02 IS NULL THEN
               LET g_inf[l_ac].inf02 = 1
            END IF
         END IF
         
      AFTER FIELD inf02 #重复性检查
         IF NOT cl_null(g_inf[l_ac].inf02) AND (p_cmd = 'a' OR 
             (p_cmd = 'u' AND g_inf[l_ac].inf02 != g_inf_t.inf02 ))THEN
             
           #TQC-C50180 -- add -- begin
            IF g_inf[l_ac].inf02 < 1 THEN
               CALL cl_err('','aec-994',0)
               LET g_inf[l_ac].inf02 = g_inf_t.inf02
               NEXT FIELD inf02
            END IF
           #TQC-C50180 -- add -- end
            SELECT COUNT(*) INTO l_n FROM inf_file
             WHERE inf01 = g_ine.ine01
               AND inf02 = g_inf[l_ac].inf02
            IF l_n<>0 THEN
               CALL cl_err('',-239,0)
               LET g_inf[l_ac].inf02 = g_inf_t.inf02
               DISPLAY g_inf[l_ac].inf02 TO inf02
               NEXT FIELD inf02
            END IF
         END IF

      AFTER FIELD inf03
        #TQC-C20448--mark--begin
        #IF NOT cl_null(g_inf[l_ac].inf03) THEN
        #   CALL t600_inf03()         
        #   IF NOT cl_null(g_errno) THEN
        #      CALL cl_err('',g_errno,0)
        #      LET g_inf[l_ac].inf03 = g_inf_t.inf03
        #      DISPLAY g_inf[l_ac].inf03 TO inf03
        #      NEXT FIELD inf03
        #   END IF 
        #END IF 
        #TQC-C20448--mark--end
        #TQC-C20448--add--begin
         IF NOT cl_null(g_inf[l_ac].inf03) THEN
           #TQC-C50180 -- add -- begin
            LET l_n1 = 0
            SELECT COUNT(inf03) INTO l_n1 FROM inf_file
             WHERE inf01 = g_ine.ine01
               AND inf03 = g_inf[l_ac].inf03
            IF (l_n1 > 0 AND p_cmd='a' ) 
               OR (l_n1 = 1 AND p_cmd='u' AND (g_inf[l_ac].inf03<>g_inf_t.inf03)) THEN
               CALL cl_err('','aim1160',0)
               LET g_inf[l_ac].inf03 = g_inf_t.inf03
               NEXT FIELD inf03
            END IF
           #TQC-C50180 -- add -- end
            IF NOT s_chk_item_no(g_inf[l_ac].inf03,"") THEN
               CALL cl_err('',g_errno,1)
               LET g_inf[l_ac].inf03 = g_inf_t.inf03
               NEXT FIELD inf03
            END IF
         END IF
         IF NOT t600_inf03(p_cmd) THEN
            NEXT FIELD inf03
         END IF
        #TQC-C20448--add--end

      AFTER FIELD inf04b
         #FUN-C30106---begin mark
         #IF NOT cl_null(g_inf[l_ac].inf04b) THEN
         #   SELECT COUNT(*) INTO l_n FROM imgs_file
         #    WHERE imgs01 = g_inf[l_ac].inf03
         #      AND imgs06 = g_inf[l_ac].inf04b
         #   IF l_n = 0 THEN
         #      CALL cl_err('','aim1137',0)
         #      LET g_inf[l_ac].inf04b = g_inf_t.inf04b
         #      DISPLAY g_inf[l_ac].inf04b TO inf04b
         #      NEXT FIELD inf04b
         #   END IF
         #END IF
         #FUN-C30106---end
         #FUN-C30106---begin
         IF NOT cl_null(g_inf[l_ac].inf04b) THEN
            IF NOT cl_null(g_inf[l_ac].inf03) THEN 
              IF cl_null(g_inf[l_ac].inf05b) THEN LET g_inf[l_ac].inf05b = ' ' END IF
              IF cl_null(g_inf[l_ac].inf07b) THEN LET g_inf[l_ac].inf07b = ' ' END IF
              LET g_inf[l_ac].inf10 = 0
              IF NOT cl_null(g_inf[l_ac].inf06b) THEN 
                 SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                  WHERE imgs01 = g_inf[l_ac].inf03
                    AND imgs06 = g_inf[l_ac].inf04b
                    AND imgs05 = g_inf[l_ac].inf05b
                    AND imgs10 = g_inf[l_ac].inf06b
                    AND imgs11 = g_inf[l_ac].inf07b
              ELSE
                 SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                  WHERE imgs01 = g_inf[l_ac].inf03
                    AND imgs06 = g_inf[l_ac].inf04b
                    AND imgs05 = g_inf[l_ac].inf05b
                    AND imgs10 IS NULL 
                    AND imgs11 = g_inf[l_ac].inf07b
              END IF 
              IF cl_null(g_inf[l_ac].inf10) THEN LET g_inf[l_ac].inf10 = 0 END IF
              DISPLAY g_inf[l_ac].inf10 TO inf10
           END IF 
         END IF  
         #FUN-C30106---end
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)
         
      BEFORE FIELD inf04a
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)
   


#TQC-C20481 ----- mark ----- begin
#     AFTER FIELD inf04a
#        IF NOT cl_null(g_inf[l_ac].inf04a) THEN
#           SELECT COUNT(*) INTO l_n FROM imgs_file
#            WHERE imgs01 = g_inf[l_ac].inf03
#              AND imgs06 = g_inf[l_ac].inf04a
#           IF l_n = 0 THEN
#              CALL cl_err('','aim1137',0)
#              LET g_inf[l_ac].inf04a = g_inf_t.inf04b
#              DISPLAY g_inf[l_ac].inf04a TO inf04a
#              NEXT FIELD inf04a
#           END IF
#        END IF
##TQC-C20481 ----- mark ----- end

      AFTER FIELD inf05b
         IF NOT cl_null(g_inf[l_ac].inf05b) THEN
            SELECT COUNT(*) INTO l_n FROM imgs_file
             WHERE imgs01 = g_inf[l_ac].inf03
               AND imgs06 = g_inf[l_ac].inf04b
               AND imgs05 = g_inf[l_ac].inf05b
            IF l_n=0 THEN  #检查存在性
               CALL cl_err('','abx-020',0)
               LET g_inf[l_ac].inf05b = g_inf_t.inf05b
               DISPLAY g_inf[l_ac].inf05b TO inf05b
               NEXT FIELD inf05b
            END IF
           #FUN-C30106---begin
           IF NOT cl_null(g_inf[l_ac].inf03) THEN 
              IF cl_null(g_inf[l_ac].inf04b) THEN LET g_inf[l_ac].inf04b = ' ' END IF
              IF cl_null(g_inf[l_ac].inf07b) THEN LET g_inf[l_ac].inf07b = ' ' END IF
              LET g_inf[l_ac].inf10 = 0
              IF NOT cl_null(g_inf[l_ac].inf06b) THEN 
                 SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                  WHERE imgs01 = g_inf[l_ac].inf03
                    AND imgs06 = g_inf[l_ac].inf04b
                    AND imgs05 = g_inf[l_ac].inf05b
                    AND imgs10 = g_inf[l_ac].inf06b
                    AND imgs11 = g_inf[l_ac].inf07b
              ELSE
                 SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                  WHERE imgs01 = g_inf[l_ac].inf03
                    AND imgs06 = g_inf[l_ac].inf04b
                    AND imgs05 = g_inf[l_ac].inf05b
                    AND imgs10 IS NULL 
                    AND imgs11 = g_inf[l_ac].inf07b
              END IF 
              IF cl_null(g_inf[l_ac].inf10) THEN LET g_inf[l_ac].inf10 = 0 END IF
              DISPLAY g_inf[l_ac].inf10 TO inf10
           END IF 
           #FUN-C30106---end
         END IF 
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)

      BEFORE FIELD inf05a
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)

#TQC-C20481 ----- mark ----- begin
#     AFTER FIELD inf05a
#        IF NOT cl_null(g_inf[l_ac].inf05a) THEN
#           SELECT COUNT(*) INTO l_n FROM imgs_file
#            WHERE imgs01 = g_inf[l_ac].inf03
#              AND imgs06 = g_inf[l_ac].inf04b
#              AND imgs05 = g_inf[l_ac].inf05a
#           IF l_n=0 THEN  #检查存在性
#              CALL cl_err('','abx-020',0)
#              LET g_inf[l_ac].inf05a = g_inf_t.inf05a
#              DISPLAY g_inf[l_ac].inf05a TO inf05a
#              NEXT FIELD inf05a
#           END IF
#        END IF
#TQC-C20481 ----- mark ----- end

      AFTER FIELD  inf06b
           #FUN-C30106---begin
           IF NOT cl_null(g_inf[l_ac].inf03) AND NOT cl_null(g_inf[l_ac].inf06b) THEN
              IF NOT cl_null(g_inf[l_ac].inf04b) OR NOT cl_null(g_inf[l_ac].inf05b) THEN 
                 IF cl_null(g_inf[l_ac].inf04b) THEN LET g_inf[l_ac].inf04b = ' ' END IF
                 IF cl_null(g_inf[l_ac].inf05b) THEN LET g_inf[l_ac].inf05b = ' ' END IF
                 IF cl_null(g_inf[l_ac].inf07b) THEN LET g_inf[l_ac].inf07b = ' ' END IF
                 LET g_inf[l_ac].inf10 = 0
                 IF NOT cl_null(g_inf[l_ac].inf06b) THEN 
                    SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                     WHERE imgs01 = g_inf[l_ac].inf03
                       AND imgs06 = g_inf[l_ac].inf04b
                       AND imgs05 = g_inf[l_ac].inf05b
                       AND imgs10 = g_inf[l_ac].inf06b
                       AND imgs11 = g_inf[l_ac].inf07b
                 ELSE
                    SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                     WHERE imgs01 = g_inf[l_ac].inf03
                       AND imgs06 = g_inf[l_ac].inf04b
                       AND imgs05 = g_inf[l_ac].inf05b
                       AND imgs10 IS NULL 
                       AND imgs11 = g_inf[l_ac].inf07b
                 END IF 
                 IF cl_null(g_inf[l_ac].inf10) THEN LET g_inf[l_ac].inf10 = 0 END IF
                 DISPLAY g_inf[l_ac].inf10 TO inf10
              END IF 
           END IF 
           #FUN-C30106---end
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)

      AFTER FIELD inf06a
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)


      BEFORE FIELD inf07b
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)


      AFTER FIELD inf07b
         IF NOT cl_null(g_inf[l_ac].inf07b) THEN
            SELECT COUNT(*) INTO l_n FROM imgs_file
             WHERE imgs01 = g_inf[l_ac].inf03
               AND imgs06 = g_inf[l_ac].inf04b
               AND imgs05 = g_inf[l_ac].inf05b
               AND imgs11 = g_inf[l_ac].inf07b
            IF l_n = 0 THEN
               CALL cl_err('','aim1121',0)
               LET g_inf[l_ac].inf07b = g_inf_t.inf07b
               DISPLAY  g_inf[l_ac].inf07b TO inf07b
               NEXT FIELD inf07b
            END IF 
            #FUN-C30106---begin
            IF NOT cl_null(g_inf[l_ac].inf03) THEN
               IF NOT cl_null(g_inf[l_ac].inf04b) OR NOT cl_null(g_inf[l_ac].inf05b) THEN 
                  IF cl_null(g_inf[l_ac].inf04b) THEN LET g_inf[l_ac].inf04b = ' ' END IF
                  IF cl_null(g_inf[l_ac].inf05b) THEN LET g_inf[l_ac].inf05b = ' ' END IF
                  LET g_inf[l_ac].inf10 = 0
                  IF NOT cl_null(g_inf[l_ac].inf06b) THEN 
                     SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                      WHERE imgs01 = g_inf[l_ac].inf03
                        AND imgs06 = g_inf[l_ac].inf04b
                        AND imgs05 = g_inf[l_ac].inf05b
                        AND imgs10 = g_inf[l_ac].inf06b
                        AND imgs11 = g_inf[l_ac].inf07b
                  ELSE
                     SELECT SUM(imgs08) INTO g_inf[l_ac].inf10 FROM imgs_file
                      WHERE imgs01 = g_inf[l_ac].inf03
                        AND imgs06 = g_inf[l_ac].inf04b
                        AND imgs05 = g_inf[l_ac].inf05b
                        AND imgs10 IS NULL 
                        AND imgs11 = g_inf[l_ac].inf07b
                  END IF 
                  IF cl_null(g_inf[l_ac].inf10) THEN LET g_inf[l_ac].inf10 = 0 END IF
                  DISPLAY g_inf[l_ac].inf10 TO inf10
               END IF 
            END IF 
            #FUN-C30106---end
         END IF

      BEFORE FIELD inf07a
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)


      AFTER FIELD inf07a
         IF NOT cl_null(g_inf[l_ac].inf07a) THEN
            CALL t600_inf07a()   #检查存在性
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET  g_inf[l_ac].inf07a = g_inf_t.inf07a
               DISPLAY  g_inf[l_ac].inf07a TO inf07a
               NEXT FIELD inf07a
            END IF 
         END IF 

      AFTER FIELD inf08
         IF NOT cl_null(g_inf[l_ac].inf08) THEN
            CALL t600_inf08()
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               LET  g_inf[l_ac].inf08 = g_inf_t.inf08
               DISPLAY  g_inf[l_ac].inf08 TO inf08
               NEXT FIELD inf08
            END IF 
         END IF
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)

      BEFORE FIELD inf09a
         CALL t600_set_entry_b(p_cmd)
         CALL t600_set_no_entry_b(p_cmd)

      #FUN-C30106--begin
      AFTER FIELD inf10
         IF cl_null(g_inf[l_ac].inf03) THEN LET g_inf[l_ac].inf03 = ' ' END IF
         IF cl_null(g_inf[l_ac].inf04b) THEN LET g_inf[l_ac].inf04b = ' ' END IF
         IF cl_null(g_inf[l_ac].inf05b) THEN LET g_inf[l_ac].inf05b = ' ' END IF
         IF cl_null(g_inf[l_ac].inf07b) THEN LET g_inf[l_ac].inf07b = ' ' END IF
         LET l_inf10 = 0
         IF NOT cl_null(g_inf[l_ac].inf06b) THEN 
            SELECT SUM(imgs08) INTO l_inf10 FROM imgs_file
             WHERE imgs01 = g_inf[l_ac].inf03
               AND imgs06 = g_inf[l_ac].inf04b
               AND imgs05 = g_inf[l_ac].inf05b
               AND imgs10 = g_inf[l_ac].inf06b
               AND imgs11 = g_inf[l_ac].inf07b
         ELSE
            SELECT SUM(imgs08) INTO l_inf10 FROM imgs_file
             WHERE imgs01 = g_inf[l_ac].inf03
               AND imgs06 = g_inf[l_ac].inf04b
               AND imgs05 = g_inf[l_ac].inf05b
               AND imgs10 IS NULL 
               AND imgs11 = g_inf[l_ac].inf07b
         END IF
         IF g_inf[l_ac].inf10 > l_inf10 OR g_inf[l_ac].inf10 < 0 THEN
            CALL cl_err('','aim-169',1)
            LET g_inf[l_ac].inf10 = g_inf_t.inf10
            DISPLAY g_inf[l_ac].inf10 TO inf10
            NEXT FIELD inf10
         END IF 
      #FUN-C30106---end
         
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE t600_bcl
            CANCEL INSERT
         END IF

         IF cl_null(g_inf[l_ac].inf04b) THEN
            LET  g_inf[l_ac].inf04b = " "
         END IF 
         IF cl_null(g_inf[l_ac].inf04a) THEN
            LET  g_inf[l_ac].inf04a = " "
         END IF
         IF cl_null(g_inf[l_ac].inf05b) THEN
            LET  g_inf[l_ac].inf05b = " "
         END IF
         IF cl_null(g_inf[l_ac].inf05a) THEN
            LET  g_inf[l_ac].inf05a = " "
         END IF

         IF cl_null(g_inf[l_ac].inf07b) THEN
            LET  g_inf[l_ac].inf07b = " "
         END IF
         IF cl_null(g_inf[l_ac].inf07a) THEN
            LET  g_inf[l_ac].inf07a = " "
         END IF

         INSERT INTO inf_file(inf01,inf02,inf03,inf04b,inf04a,inf05b,inf05a,
                              inf06b,inf06a,inf07b,inf07a,inf08,inf09b,inf09a,inf10) #FUN-C30106
         VALUES(g_ine.ine01,g_inf[l_ac].inf02,g_inf[l_ac].inf03,
                g_inf[l_ac].inf04b,g_inf[l_ac].inf04a,g_inf[l_ac].inf05b,
                g_inf[l_ac].inf05a,g_inf[l_ac].inf06b,g_inf[l_ac].inf06a,
                g_inf[l_ac].inf07b,g_inf[l_ac].inf07a,g_inf[l_ac].inf08,
                g_inf[l_ac].inf09b,g_inf[l_ac].inf09a,g_inf[l_ac].inf10)  #FUN-C30106
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_inf[l_ac].inf02,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_inf[l_ac].* = g_inf_t.*
            CLOSE t600_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_inf[l_ac].inf02,-263,1)
            LET g_inf[l_ac].* = g_inf_t.*
         ELSE
            IF cl_null(g_inf[l_ac].inf04b) THEN
               LET  g_inf[l_ac].inf04b = " "
            END IF 
            IF cl_null(g_inf[l_ac].inf04a) THEN
               LET  g_inf[l_ac].inf04a = " "
            END IF
            IF cl_null(g_inf[l_ac].inf05b) THEN
               LET  g_inf[l_ac].inf05b = " "
            END IF
            IF cl_null(g_inf[l_ac].inf05a) THEN
               LET  g_inf[l_ac].inf05a = " "
            END IF

            IF cl_null(g_inf[l_ac].inf07b) THEN
               LET  g_inf[l_ac].inf07b = " "
            END IF
            IF cl_null(g_inf[l_ac].inf07a) THEN
               LET  g_inf[l_ac].inf07a = " "
            END IF 

            UPDATE inf_file SET inf02   = g_inf[l_ac].inf02,
                                inf03   = g_inf[l_ac].inf03,
                                inf04b  = g_inf[l_ac].inf04b,
                                inf04a  = g_inf[l_ac].inf04a,
                                inf05b  = g_inf[l_ac].inf05b,
                                inf05a  = g_inf[l_ac].inf05a,
                                inf06b  = g_inf[l_ac].inf06b,
                                inf06a  = g_inf[l_ac].inf06a,
                                inf07b  = g_inf[l_ac].inf07b,
                                inf07a  = g_inf[l_ac].inf07a,
                                inf08   = g_inf[l_ac].inf08,
                                inf09b  = g_inf[l_ac].inf09b,
                                inf09a  = g_inf[l_ac].inf09a,
                                inf10   = g_inf[l_ac].inf10  #FUN-C30106
             WHERE inf01 = g_ine.ine01
               AND inf02 = g_inf_t.inf02
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_inf[l_ac].inf02,SQLCA.sqlcode,0)
               LET g_inf[l_ac].* = g_inf_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF    
         
      BEFORE DELETE
         IF g_inf_t.inf02 > 0 AND
            g_inf_t.inf02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF

            DELETE FROM inf_file WHERE inf01 = g_ine.ine01
                                   AND inf02 = g_inf_t.inf02
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_inf_t.inf02,SQLCA.sqlcode,0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF             
         
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D40030 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_inf[l_ac].* = g_inf_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_inf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE t600_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D40030 Add
         CLOSE t600_bcl
         COMMIT WORK

      ON ACTION controlp
         CASE
            WHEN INFIELD(inf03)
             #TQC-C20448--mark--begin
              #CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_ima20'
              #LET g_qryparam.default1 = g_inf[l_ac].inf03
              #CALL cl_create_qry() RETURNING g_inf[l_ac].inf03
             #TQC-C20448--mark--end
               CALL q_sel_ima(FALSE, "q_ima20", "", g_inf[l_ac].inf03, "", "", "", "" ,"",'' )  RETURNING g_inf[l_ac].inf03  #TQC-C20448 add
               DISPLAY BY NAME g_inf[l_ac].inf03
               NEXT FIELD inf03
      
            WHEN INFIELD(inf04b)
               CALL cl_init_qry_var()
#MOD-C30656 ----- mark ----- begin
#              LET g_qryparam.form = 'q_imgs06'
#              LET g_qryparam.arg1 = g_inf[l_ac].inf03
#              LET g_qryparam.default1 = g_inf[l_ac].inf04b
#              CALL cl_create_qry() RETURNING g_inf[l_ac].inf04b
#MOD-C30656 ----- mark ----- end
#MOD-C30656 ----- add  ----- begin
               IF NOT cl_null(g_inf[l_ac].inf03) THEN
                  LET g_qryparam.form = 'q_imgs06'
                  LET g_qryparam.arg1 = g_inf[l_ac].inf03
                  LET g_qryparam.default1 = g_inf[l_ac].inf04b
                  CALL cl_create_qry() RETURNING g_inf[l_ac].inf04b
               ELSE
                  LET g_qryparam.form = 'q_imgs06_1'
                  LET g_qryparam.default1 = g_inf[l_ac].inf04b
                  CALL cl_create_qry() 
                   RETURNING g_inf[l_ac].inf03,g_inf[l_ac].inf04b
                  DISPLAY BY NAME g_inf[l_ac].inf03 
               END IF
#MOD-C30656 ----- add  ----- end
               DISPLAY BY NAME g_inf[l_ac].inf04b
               NEXT FIELD inf04b

            WHEN INFIELD(inf04a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_imgs06'
               LET g_qryparam.arg1 = g_inf[l_ac].inf03
               LET g_qryparam.default1 = g_inf[l_ac].inf04a
               CALL cl_create_qry() RETURNING g_inf[l_ac].inf04a
               DISPLAY BY NAME g_inf[l_ac].inf04a
               NEXT FIELD inf04a

            WHEN INFIELD(inf05b)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_imgs05'
               LET g_qryparam.arg1 = g_inf[l_ac].inf03
               LET g_qryparam.arg2 = g_inf[l_ac].inf04b
               LET g_qryparam.default1 = g_inf[l_ac].inf05b
               CALL cl_create_qry() RETURNING g_inf[l_ac].inf05b
               DISPLAY BY NAME g_inf[l_ac].inf05b
               NEXT FIELD inf05b

            WHEN INFIELD(inf05a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_imgs05'
               LET g_qryparam.arg1 = g_inf[l_ac].inf03
               LET g_qryparam.arg2 = g_inf[l_ac].inf04b
               LET g_qryparam.default1 = g_inf[l_ac].inf05a
               CALL cl_create_qry() RETURNING g_inf[l_ac].inf05a
               DISPLAY BY NAME g_inf[l_ac].inf05a
               NEXT FIELD inf05a

            WHEN INFIELD(inf07b)
               CALL cl_init_qry_var()
               LET g_qryparam.form = 'q_imgs11'
               LET g_qryparam.arg1 = g_inf[l_ac].inf03
               LET g_qryparam.arg2 = g_inf[l_ac].inf04b
               LET g_qryparam.arg3 = g_inf[l_ac].inf05b
               LET g_qryparam.default1 = g_inf[l_ac].inf07b
               CALL cl_create_qry() RETURNING g_inf[l_ac].inf07b
               DISPLAY BY NAME g_inf[l_ac].inf07b
               NEXT FIELD inf07b

            WHEN INFIELD(inf08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_imac04_1"
               LET g_qryparam.arg1 = g_inf[l_ac].inf03
               LET g_qryparam.default1 = g_inf[l_ac].inf08
               CALL cl_create_qry() RETURNING g_inf[l_ac].inf08
               DISPLAY BY NAME g_inf[l_ac].inf08
               NEXT FIELD inf08
            OTHERWISE EXIT CASE
         END CASE

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
      ON ACTION about
         CALL cl_about()
   
      ON ACTION HELP
         CALL cl_show_help()
   END INPUT
   UPDATE ine_file SET inemodu=g_user,inedate=g_today,ine05='0'
    WHERE ine01=g_ine.ine01

   DISPLAY BY NAME g_ine.inemodu,g_ine.inedate,g_ine.ine05
   CLOSE t600_bcl
   COMMIT WORK
#  CALL t600_delall()      #CHI-C30002 mark
   CALL t600_delHeader()     #CHI-C30002 add
   
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t600_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ine.ine01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ine_file ",
                  "  WHERE ine01 LIKE '",l_slip,"%' ",
                  "    AND ine01 > '",g_ine.ine01,"'"
      PREPARE t600_pb1 FROM l_sql 
      EXECUTE t600_pb1 INTO l_cnt       
      
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
        #CALL t600_v()    #CHI-D20010
         CALL t600_v(1)   #CHI-D20010
         CALL t600_show()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ine_file WHERE ine01 = g_ine.ine01
         INITIALIZE g_ine.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t600_delall()  # 未輸入單身資料, 是否取消單頭資料
## SELECT COUNT(*) INTO g_cnt
##   FROM inf_file
##  WHERE inf01 = g_ine.ine01
## IF g_cnt = 0 THEN
##    CALL cl_getmsg('9044',g_lang) RETURNING g_msg
##    ERROR g_msg CLIPPED
##    DELETE FROM ine_file WHERE ine01 = g_ine.ine01
## END IF
##
#END FUNCTION
#CHI-C30002 -------- mark -------- end

#確認
FUNCTION t600_confirm()
 DEFINE   l_n  LIKE  type_file.num5
#TQC-C20482 ----- add ----- begin
 DEFINE   li_i        LIKE  type_file.num5
 DEFINE   l_inf04a    LIKE inf_file.inf04a,
          l_inf05a    LIKE inf_file.inf05a
#TQC-C20482 ----- add ----- end
 DEFINE   l_inf10     LIKE inf_file.inf10  #FUN-C30106
   IF s_shut(0) THEN 
      RETURN
   END IF
#CHI-C30107 --------- add -------- begin
   IF g_ine.ine01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   IF g_ine.ineconf <> 'N' THEN
     CALL cl_err('','aim1123',0)
     RETURN
   END IF
   IF NOT cl_confirm('aim-301') THEN 
      RETURN
   END IF
   SELECT * INTO g_ine.* FROM ine_file WHERE ine01 = g_ine.ine01
#CHI-C30107 --------- add -------- end
   IF g_ine.ine01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   
   IF g_ine.ineconf <> 'N' THEN
     CALL cl_err('','aim1123',0)
     RETURN
   END IF 

   SELECT COUNT(*) INTO l_n FROM inf_file
    WHERE inf01 = g_ine.ine01
   IF l_n = 0 THEN
      CALL cl_err('','art-486',0)
      RETURN
   END IF


   FOR li_i = 1 TO g_inf.getLength() #TQC-C20482 add
#TQC-C20482 ----- modify ----- begin  modify l_ac->li_i
#TQC-C20482 ----- mark ----- begin
#     IF NOT cl_null(g_inf[li_i].inf04b) THEN
#        IF cl_null(g_inf[li_i].inf04a) THEN
#           CALL cl_err('','aim1124',0)
#           RETURN
#        END IF
#     END IF

#     IF NOT cl_null(g_inf[li_i].inf05b) THEN
#        IF cl_null(g_inf[li_i].inf05a) THEN
#           CALL cl_err('','aim1125',0)
#           RETURN
#        END IF
#     END IF
#TQC-C20482 ----- mark ----- end
      IF NOT cl_null(g_inf[li_i].inf07b) THEN
         IF cl_null(g_inf[li_i].inf06a) THEN
            CALL cl_err('','aim1126',0)
            RETURN
         END IF
      END IF 

      IF NOT cl_null(g_inf[li_i].inf09b) THEN
         IF cl_null(g_inf[li_i].inf09a) THEN
            CALL cl_err('','aim1127',0)
            RETURN
         END IF
      END IF 
#FUN-C30106---begin mark
#TQC-C20482 ----- add ----- begin
#      LET l_n = 0
#      LET l_inf04a = g_inf[li_i].inf04a
#      LET l_inf05a = g_inf[li_i].inf05a
#      IF NOT cl_null(g_inf[li_i].inf04a) 
#          OR NOT cl_null(g_inf[li_i].inf05a) THEN
#         IF cl_null(g_inf[li_i].inf04a) THEN
#            LET l_inf04a = g_inf[li_i].inf04b
#         END IF
#         IF cl_null(g_inf[li_i].inf05a) THEN
#            LET l_inf05a = g_inf[li_i].inf05b
#         END IF
#         SELECT COUNT(*) INTO l_n FROM imgs_file
#          WHERE imgs01 = g_inf[li_i].inf03
#            AND imgs06 = l_inf04a
#            AND imgs05 = l_inf05a
#         IF l_n > 0 THEN
#            CALL cl_err('','aim1148',1)
#            RETURN
#         END IF  
#      END IF
#TQC-C20482 ----- add ----- end
#FUN-C30106---end
      #FUN-C30106---begin
      LET l_inf10 = 0
      IF NOT cl_null(g_inf[li_i].inf06b) THEN 
         SELECT SUM(imgs08) INTO l_inf10 FROM imgs_file
          WHERE imgs01 = g_inf[li_i].inf03
            AND imgs06 = g_inf[li_i].inf04b
            AND imgs05 = g_inf[li_i].inf05b
            AND imgs10 = g_inf[li_i].inf06b
            AND imgs11 = g_inf[li_i].inf07b
      ELSE
         SELECT SUM(imgs08) INTO l_inf10 FROM imgs_file
          WHERE imgs01 = g_inf[li_i].inf03
            AND imgs06 = g_inf[li_i].inf04b
            AND imgs05 = g_inf[li_i].inf05b
            AND imgs10 IS NULL 
            AND imgs11 = g_inf[li_i].inf07b
      END IF
      IF g_inf[li_i].inf10 > l_inf10 THEN 
         CALL cl_err('','asf-375',0)
         RETURN
      END IF 
   #FUN-C30106---end
   END FOR   #TQC-C20482 add
#TQC-C20482 ----- modify ----- end  modify l_ac->li_i

#CHI-C30107 ------- mark ------ begin
#  IF NOT cl_confirm('aim-301') THEN 
#     RETURN
#  END IF
#CHI-C30107 ------- mark ------ end

   BEGIN WORK

   OPEN t600_cl USING g_ine.ine01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_ine.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   CALL t600_show()

   LET g_ine.ineconf = 'Y'
   LET g_ine.ine05   = '1'
   UPDATE ine_file SET ineconf = g_ine.ineconf,
                       ine05   = g_ine.ine05
    WHERE ine01 = g_ine.ine01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
      CALL cl_err3('upd','ine_file',g_ine.ine01,'',SQLCA.sqlcode,'','',1)
      ROLLBACK WORK 
   END IF
   CLOSE t600_cl
   COMMIT WORK
   SELECT * INTO g_ine.* FROM ine_file WHERE ine01 = g_ine.ine01
   CALL t600_show()
END FUNCTION

#取消確認
FUNCTION t600_unconfirm()
   IF s_shut(0) THEN RETURN END IF 

   IF cl_null(g_ine.ine01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_ine.ine05 = '2' THEN
      CALL cl_err('','aim1128',0)
      RETURN
   END IF 

   IF g_ine.ineconf = 'N' THEN
      CALL cl_err('','aim1129',0)
      RETURN
   END IF 

   IF NOT cl_confirm('aim-302') THEN  RETURN END IF 
   BEGIN WORK

   OPEN t600_cl USING g_ine.ine01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_ine.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   CALL t600_show()

   LET g_ine.ineconf = 'N'
   LET g_ine.ine05   = '0'    #TQC-C20468 modify '0'
   UPDATE ine_file SET ineconf = g_ine.ineconf,
                       ine05   = g_ine.ine05
    WHERE ine01 = g_ine.ine01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
      CALL cl_err3('upd','ine_file',g_ine.ine01,'',SQLCA.sqlcode,'','',1)
      ROLLBACK WORK 
   END IF
   CLOSE t600_cl
   COMMIT WORK
   SELECT * INTO g_ine.* FROM ine_file WHERE ine01 = g_ine.ine01
   CALL t600_show()   
END FUNCTION 

#發出
FUNCTION t600_issued()
DEFINE    l_inf   RECORD  LIKE  inf_file.*,
          l_imgs  RECORD  LIKE  imgs_file.*,
          l_sql   STRING

#TQC-C20482 ----- add ----- begin
DEFINE    l_inf04a        LIKE  inf_file.inf04a,
          l_inf05a        LIKE  inf_file.inf05a,
          l_inf06a        LIKE  inf_file.inf06a,   #MOD-C30500 add
          l_inf07a        LIKE  inf_file.inf07a    #MOD-C30500 add
#TQC-C20482 ----- add ----- end
DEFINE    l_imac03        LIKE  imac_file.imac03   #TQC-C20470 add
DEFINE    l_check         LIKE  type_file.chr1     #FUN-C30106
DEFINE    l_time          LIKE  ine_file.inesendt  #FUN-CC0094
DEFINE    l_inf10         LIKE  inf_file.inf10     #FUN-C30106
DEFINE    l_imgs08        LIKE  imgs_file.imgs08   #FUN-C30106

   IF s_shut(0) THEN RETURN END IF 

   IF cl_null(g_ine.ine01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_ine.ineconf != 'Y' THEN
      CALL cl_err('','art-124',0)
      RETURN
   END IF 

   IF g_ine.ine05 != '1' THEN 
      CALL cl_err('','apm-299',0)
      RETURN
   END IF 

   IF NOT cl_confirm('aim1130') THEN
      RETURN
   END IF
   BEGIN WORK 

   OPEN t600_cl USING g_ine.ine01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_ine.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF

   CALL t600_show()   
   LET g_success = 'Y'
   LET g_sql = "SELECT * FROM inf_file WHERE inf01 = '",g_ine.ine01,"'"
   PREPARE pre_ins FROM g_sql
   DECLARE ins_cs CURSOR FOR pre_ins
   FOREACH ins_cs INTO l_inf.*
      IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           LET g_success = 'N'
           EXIT FOREACH
      END IF
#TQC-C20482 ----- add ----- begin
      LET l_inf04a = l_inf.inf04a
      LET l_inf05a = l_inf.inf05a
      LET l_inf06a = l_inf.inf06a
      LET l_inf07a = l_inf.inf07a
      LET l_inf10 = l_inf.inf10  #FUN-C30106
#TQC-C20482 ----- add ----- end
      IF (NOT cl_null(l_inf.inf04a)) OR  (NOT cl_null(l_inf.inf05a))
         OR (NOT cl_null(l_inf.inf07a)) THEN
         LET l_sql = "SELECT * FROM imgs_file ",
                     " WHERE imgs01 = '",l_inf.inf03,"'"
 #MOD-C30500 ---------- add ---------- begin
         IF NOT cl_null(l_inf.inf04b) THEN
            LET l_sql = l_sql,"  AND imgs06 = '",l_inf.inf04b,"'"
         END IF

         IF NOT cl_null(l_inf.inf05b) THEN
            LET l_sql = l_sql,"  AND imgs05 = '",l_inf.inf05b,"'"
         END IF

         IF NOT cl_null(l_inf.inf06b) THEN
            LET l_sql = l_sql,"  AND imgs10 = '",l_inf.inf06b,"'"
         END IF

         IF NOT cl_null(l_inf.inf07b) THEN
            LET l_sql = l_sql,"  AND imgs11 = '",l_inf.inf07b,"'"
         END IF
 #MOD-C30500 ---------- add ---------- end
         PREPARE pre_ins_1 FROM l_sql
         DECLARE ins_cs_1 CURSOR FOR pre_ins_1
         FOREACH ins_cs_1 INTO l_imgs.*
            IF SQLCA.sqlcode THEN
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            IF l_inf10 = 0 THEN CONTINUE FOREACH END IF  #FUN-C30106
          
#MOD-C30500  --------- add -------- begin
            IF cl_null(l_inf.inf04a) THEN LET l_inf04a = l_imgs.imgs06 END IF
            IF cl_null(l_inf.inf05a) THEN LET l_inf05a = l_imgs.imgs05 END IF
            IF cl_null(l_inf.inf06a) THEN LET l_inf06a = l_imgs.imgs10 END IF
            IF cl_null(l_inf.inf07a) THEN LET l_inf07a = l_imgs.imgs11 END IF
#MOD-C30500  --------- add -------- end 
            #FUN-C30106---begin
            SELECT imgs08 INTO l_imgs08
              FROM imgs_file
             WHERE imgs01 = l_imgs.imgs01
               AND imgs02 = l_imgs.imgs02
               AND imgs03 = l_imgs.imgs03
               AND imgs04 = l_imgs.imgs04
               AND imgs05 = l_imgs.imgs05
               AND imgs06 = l_imgs.imgs06
               AND imgs11 = l_imgs.imgs11
            IF cl_null(l_imgs08) THEN LET l_imgs08 = 0 END IF 
            IF l_imgs08 >= l_inf10 THEN
               LET l_imgs08 = l_inf10
               LET l_inf10 = 0
            ELSE
               LET l_inf10 = l_inf10 - l_imgs08
            END IF 
            #FUN-C30106---end
            #變更前庫存減少
            INSERT INTO tlfs_file VALUES(l_imgs.imgs01,l_imgs.imgs02,
                                         l_imgs.imgs03,l_imgs.imgs04,
                                         l_imgs.imgs05,l_imgs.imgs06,
                                         l_imgs.imgs07,'aimt600',
                                         -1,g_ine.ine01,
                                         l_inf.inf02,g_today,
                                         #l_imgs.imgs08,l_imgs.imgs10,  #FUN-C30106
                                         l_imgs08,l_imgs.imgs10,     #FUN-C30106
                                         l_imgs.imgs11,g_ine.ine02,
                                         g_plant,g_legal)
 
            IF SQLCA.sqlcode THEN
               CALL cl_err3('ins','tlfs_file','','',SQLCA.sqlcode,'','',1)
               LET g_success = 'N'
               ROLLBACK WORK
               EXIT FOREACH
            END IF 
 
            #變更后庫存增加
            INSERT INTO tlfs_file VALUES(l_imgs.imgs01,l_imgs.imgs02,
                                         l_imgs.imgs03,l_imgs.imgs04,
#                                        l_inf.inf05a,l_inf.inf04a, #TQC-C20482 mark
                                         l_inf05a,l_inf04a,         #TQC-C20482 add
                                         l_imgs.imgs07,'aimt600',
                                         1,g_ine.ine01,
                                         l_inf.inf02,g_today,
                                         #l_imgs.imgs08,l_inf06a,   #MOD-C30500 modify l_inf.inf06a->l_inf06a #FUN-C30106
                                         l_imgs08,l_inf06a,      #FUN-C30106
                                         l_inf07a,g_ine.ine02,      #MOD-C30500 modify l_inf.inf07a->l_inf07a
                                         g_plant,g_legal) 
         
            IF SQLCA.sqlcode THEN
               CALL cl_err3('ins','tlfs_file','','',SQLCA.sqlcode,'','',1)
               LET g_success = 'N'
               ROLLBACK WORK
               EXIT FOREACH
            END IF
            #FUN-C30106---begin
            #變更前
            UPDATE imgs_file 
               SET imgs08 = imgs08 - l_imgs08
             WHERE imgs01 = l_imgs.imgs01
               AND imgs02 = l_imgs.imgs02
               AND imgs03 = l_imgs.imgs03
               AND imgs04 = l_imgs.imgs04
               AND imgs05 = l_imgs.imgs05
               AND imgs06 = l_imgs.imgs06
               AND imgs11 = l_imgs.imgs11
            IF SQLCA.sqlcode THEN
               CALL cl_err3('upd','imgs_file','','',SQLCA.sqlcode,'','',1)
               LET g_success = 'N'
               ROLLBACK WORK
               EXIT FOREACH
            END IF
            #變更後
            LET l_check = 'N'
            SELECT 'Y' INTO l_check
              FROM imgs_file
             WHERE imgs01 = l_imgs.imgs01
               AND imgs02 = l_imgs.imgs02
               AND imgs03 = l_imgs.imgs03
               AND imgs04 = l_imgs.imgs04
               AND imgs05 = l_inf05a
               AND imgs06 = l_inf04a  
               AND imgs11 = l_inf07a

            IF l_check = 'Y' THEN
               UPDATE imgs_file 
                  SET imgs08 = imgs08 + l_imgs08,
                      imgs10 = l_inf06a
                WHERE imgs01 = l_imgs.imgs01
                  AND imgs02 = l_imgs.imgs02
                  AND imgs03 = l_imgs.imgs03
                  AND imgs04 = l_imgs.imgs04
                  AND imgs05 = l_inf05a
                  AND imgs06 = l_inf04a
                  AND imgs11 = l_inf07a
               IF SQLCA.sqlcode THEN
                  CALL cl_err3('upd','imgs_file','','',SQLCA.sqlcode,'','',1)
                  LET g_success = 'N'
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
            ELSE
               INSERT INTO imgs_file VALUES(l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,l_imgs.imgs04,
               l_inf05a,l_inf04a,l_imgs.imgs07,l_imgs08,l_imgs.imgs09,l_inf06a,l_inf07a,g_plant,g_legal)
               IF SQLCA.sqlcode THEN
                  CALL cl_err3('insert','imgs_file','','',SQLCA.sqlcode,'','',1)
                  LET g_success = 'N'
                  ROLLBACK WORK
                  EXIT FOREACH
               END IF
            END IF 
            #FUN-C30106---end
#FUN-C30106---mark 
#           #更新imgs_file庫存資料
#               UPDATE imgs_file SET   imgs06 = l_inf04a,      #TQC-C20482 add
#                                      imgs05 = l_inf05a,      #TQC-C20482 add       
##                                     imgs06 = l_inf.inf04a,  #TQC-C20482 mark
##                                     imgs05 = l_inf.inf05a,  #TQC-C20482 mark
#                                     imgs10 = l_inf06a,       #MOD-C30500 modify l_inf.inf06a->l_inf06a
#                                     imgs11 = l_inf07a        #MOD-C30500 modify l_inf.inf07a->l_inf07a
#                WHERE imgs01 = l_imgs.imgs01
#                  AND imgs02 = l_imgs.imgs02
#                  AND imgs03 = l_imgs.imgs03
#                  AND imgs04 = l_imgs.imgs04
#                  AND imgs05 = l_imgs.imgs05
#                  AND imgs06 = l_imgs.imgs06
#                 #AND imgs10 = l_imgs.imgs10#        #TQC-C50180 mark
#                  AND imgs11 = l_imgs.imgs11
#               IF SQLCA.sqlcode THEN
#                  CALL cl_err3('upd','imgs_file','','',SQLCA.sqlcode,'','',1)
#                  LET g_success = 'N'
#                  ROLLBACK WORK
#                  EXIT FOREACH
#               END IF  
#FUN-C30106---end         
         END FOREACH
      END IF

      #更新特性值
      IF NOT cl_null(l_inf.inf09a) THEN 
         #更新料件特性資料檔
#TQC-C20470 ----- add ----- begin
         SELECT imac03 INTO l_imac03 FROM imac_file
          WHERE imac01 = l_inf.inf03
            AND imac04  =  l_inf.inf08
         IF l_imac03 = '1' THEN
            UPDATE inj_file SET inj04 = l_inf.inf09a
             WHERE inj01 = l_inf.inf03
               AND inj03 = l_inf.inf08
         ELSE
#TQC-C20470 ----- add ----- end
            UPDATE inj_file SET inj04 = l_inf.inf09a
             WHERE inj01 = l_inf.inf03
               AND inj02 = l_inf.inf04b
               AND inj03 = l_inf.inf08
         END IF  #TQC-C20470 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3('ins','inj_file','','',SQLCA.sqlcode,'','',1)
            LET g_success = 'N'
            ROLLBACK WORK
            EXIT FOREACH
         END IF 
         #歸屬階層為料件則更新imac_file
         UPDATE imac_file SET imac05 = l_inf.inf09a
          WHERE imac01  =  l_inf.inf03
            AND imac03  = '1'
            AND imac04  =  l_inf.inf08
         IF SQLCA.sqlcode THEN
            CALL cl_err3('ins','imac_file','','',SQLCA.sqlcode,'','',1)
            LET g_success = 'N'
            ROLLBACK WORK
            EXIT FOREACH
         END IF
      END IF          
   END FOREACH

   IF g_success = 'Y' THEN
      UPDATE ine_file SET ine05 = '2'
       WHERE ine01 = g_ine.ine01
      IF SQLCA.sqlcode THEN 
         CALL cl_err3('upd','ine_file',g_ine.ine01,'',SQLCA.sqlcode,'','',1) 
         ROLLBACK WORK
      #FUN-CC0094--add--str--
      ELSE
         LET l_time = TIME
         UPDATE ine_file 
            SET inesendu = g_user,
                inesendd = g_today,
                inesendt = l_time
          WHERE ine01=g_ine.ine01
      #FUN-CC0094--add--end--
      END IF
      MESSAGE 'ISSUE.OK'
      CLOSE t600_cl 
      COMMIT WORK 
   ELSE
      ROLLBACK WORK 
      RETURN
   END IF 
   CLOSE t600_cl
   SELECT * INTO g_ine.* FROM ine_file WHERE ine01 = g_ine.ine01
   CALL t600_show() 
END FUNCTION
#單頭欄位開啟控制
FUNCTION t600_set_entry(p_cmd)
DEFINE   p_cmd   LIKE   type_file.chr1
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ine01",TRUE)
   END IF 
END FUNCTION

#但投籃未關閉控制
FUNCTION t600_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE   type_file.chr1
    IF p_cmd = 'u' AND (NOT g_before_input_done) AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("ine01",FALSE)
    END IF 
END FUNCTION

#單身欄位開啟控制
FUNCTION t600_set_entry_b(p_cmd)
DEFINE   p_cmd   LIKE   type_file.chr1
    CALL cl_set_comp_required("inf04a,inf05a,inf07b,inf07a,inf09a",FALSE)
    IF NOT cl_null(g_inf[l_ac].inf04b) THEN
       CALL cl_set_comp_entry("inf04a",TRUE)
#      CALL cl_set_comp_required("inf04a",TRUE)  #TQC-C20481 mark
    END IF 
    IF NOT cl_null(g_inf[l_ac].inf05b) THEN 
       CALL cl_set_comp_entry("inf05a",TRUE)
#      CALL cl_set_comp_required("inf05a",TRUE)  #TQC-C20481 mark
    END IF
    IF NOT cl_null(g_inf[l_ac].inf06b) THEN 
       CALL cl_set_comp_entry("inf07b",TRUE)
       CALL cl_set_comp_required("inf07b",TRUE)
    END IF 
    IF NOT cl_null(g_inf[l_ac].inf06a) THEN 
       CALL cl_set_comp_entry("inf07a",TRUE)
       CALL cl_set_comp_required("inf07a",TRUE)
    END IF 
    IF NOT cl_null(g_inf[l_ac].inf08) THEN 
       CALL  cl_set_comp_entry("inf09a",TRUE)
       CALL  cl_set_comp_required("inf09a",TRUE)
    END IF     
END FUNCTION

#單身欄位關閉控制
FUNCTION t600_set_no_entry_b(p_cmd)
DEFINE   p_cmd   LIKE   type_file.chr1
    IF cl_null(g_inf[l_ac].inf04b) THEN 
       LET g_inf[l_ac].inf04a = ""
       DISPLAY  g_inf[l_ac].inf04a TO inf04a
       CALL cl_set_comp_entry("inf04a",FALSE)
    END IF
    
    IF cl_null(g_inf[l_ac].inf05b) THEN
       LET g_inf[l_ac].inf05a = ""
       DISPLAY  g_inf[l_ac].inf05a TO inf05a
       CALL cl_set_comp_entry("inf05a",FALSE)
    END IF 
    IF cl_null(g_inf[l_ac].inf06b) THEN
        CALL cl_set_comp_entry("inf07b",FALSE)
    END IF 
    IF cl_null(g_inf[l_ac].inf06a) THEN
       CALL cl_set_comp_entry("inf07a",FALSE)
    END IF 

    IF cl_null(g_inf[l_ac].inf08) THEN 
       CALL  cl_set_comp_entry("inf09a",FALSE)
    END IF 

 
END FUNCTION

FUNCTION t600_ine03(p_cmd)
DEFINE   p_cmd    LIKE   type_file.chr1,
         l_azf03  LIKE   azf_file.azf03
   LET  g_errno = ''
   SELECT azf03 INTO l_azf03 FROM azf_file
    WHERE azf01 = g_ine.ine03
      AND azf02 = '2'
      AND azf09 = '4'

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'aim1131'
         LET l_azf03 = NULL
      OTHERWISE
        #LET g_errno = SQLCA.sqlcode USING '--------'   #TQC-C20445 mark
         LET g_errno = SQLCA.sqlcode USING '-------'    #TQC-C20445 add
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azf03 TO azf03
   END IF
END FUNCTION

FUNCTION t600_ine04(p_cmd)
DEFINE   p_cmd     LIKE    type_file.chr1,
         l_gen02   LIKE    gen_file.gen02,
         l_genacti LIKE    gen_file.genacti

   LET  g_errno = ''
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_ine.ine04

   CASE
      WHEN  SQLCA.sqlcode = 100
         LET g_errno = 'aoo-017'
         LET l_gen02 = NULL
      WHEN l_genacti <> 'Y'
         LET g_errno = 'alm1092'
         LET l_gen02 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO gen02
   END IF
END FUNCTION

#TQC-C20448--mark--begin    
#FUNCTION t600_inf03()
#DEFINE  l_ima02   LIKE  ima_file.ima02,
#       l_ima021  LIKE  ima_file.ima021,
#       l_imaacti LIKE  ima_file.imaacti
#  LET  g_errno = ''
#  SELECT ima02,ima021 INTO l_ima02,l_ima021
#    FROM ima_file
#   WHERE ima01 = g_inf[l_ac].inf03
#  CASE
#     WHEN SQLCA.sqlcode = 100
#        LET g_errno = 'ams-003'
#     WHEN l_imaacti = 'N'
#        LET g_errno = 'aic-020'
#        LET l_ima02 = NULL
#        LET l_ima021 = NULL
#     OTHERWISE
#        LET g_errno = SQLCA.sqlcode USING '-------'
#  END CASE
#  
#  IF cl_null(g_errno) THEN
#     LET g_inf[l_ac].ima02 = l_ima02
#     LET g_inf[l_ac].ima021 = l_ima021
#     DISPLAY l_ima02 TO ima02
#     DISPLAY l_ima021 TO ima021
#  END IF
#END FUNCTION
#TQC-C20448--mark--end
#TQC-C20448--add--begin
FUNCTION t600_inf03(p_cmd)
   DEFINE  p_cmd     LIKE type_file.chr1
   DEFINE  l_cnt     LIKE type_file.num5
   DEFINE  l_inf03   LIKE  inf_file.inf03
   DEFINE  l_ima02   LIKE  ima_file.ima02,
           l_ima021  LIKE  ima_file.ima021

   IF NOT cl_null(g_inf[l_ac].inf03) THEN
      IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
         (p_cmd = "u" AND g_inf[l_ac].inf03 != g_inf_t.inf03) THEN

         SELECT COUNT(*) INTO l_cnt FROM ima_file
          WHERE ima01 = g_inf[l_ac].inf03
            AND imaacti = 'Y'
         IF l_cnt <> 1 THEN                  
            CALL cl_err('','ams-003',0)
            LET g_inf[l_ac].inf03 = g_inf_t.inf03
            RETURN FALSE
         END IF

         SELECT ima02,ima021 INTO l_ima02,l_ima021
           FROM ima_file
          WHERE ima01 = g_inf[l_ac].inf03
         LET g_inf[l_ac].ima02 = l_ima02
         LET g_inf[l_ac].ima021 = l_ima021
         DISPLAY l_ima02 TO ima02
         DISPLAY l_ima021 TO ima021

      END IF
   END IF
   RETURN TRUE
END FUNCTION
#TQC-C20448--add--end

FUNCTION t600_inf07a()

   LET g_errno = ''
   CASE g_inf[l_ac].inf06a
      WHEN "1"
         SELECT * FROM oea_file WHERE oea01 = g_inf[l_ac].inf07a
         IF SQLCA.sqlcode = 100 THEN
            LET g_errno = 'aim1132'
         END IF
      WHEN "2"
         SELECT * FROM sfb_file WHERE sfb01 = g_inf[l_ac].inf07a
         IF SQLCA.sqlcode = 100 THEN
            LET g_errno = 'aim1133'
         END IF
      WHEN "3"
         SELECT * FROM pja_file WHERE pja01 = g_inf[l_ac].inf07a
         IF SQLCA.sqlcode = 100 THEN
            LET g_errno = 'aim1134'
         END IF
   END CASE
END FUNCTION

FUNCTION t600_inf08()
DEFINE   l_ini02    LIKE  ini_file.ini02,
         l_inj04    LIKE  inj_file.inj04,
         l_imac03   LIKE  imac_file.imac04  
       
   LET   g_errno = ''
#TQC-C20467 ----- mark ----- begin
#  SELECT inj04 INTO l_inj04 FROM inj_file
#   WHERE inj01 = g_inf[l_ac].inf03
#     AND inj02 = g_inf[l_ac].inf04b
#     And inj03 = g_inf[l_ac].inf08
#TQC-C20467 ----- mark ----- end

   SELECT ini02,imac03 INTO l_ini02,l_imac03 FROM ini_file,imac_file
    WHERE ini01 = imac04
      AND imac01 = g_inf[l_ac].inf03
      AND imac04 = g_inf[l_ac].inf08

#TQC-C20467 ----- add ----- begin
   IF l_imac03 = '1' THEN
      SELECT DISTINCT(inj04) INTO l_inj04 FROM inj_file
       WHERE inj01 = g_inf[l_ac].inf03
         And inj03 = g_inf[l_ac].inf08
   END IF

   IF l_imac03 = '2' THEN
      SELECT inj04 INTO l_inj04 FROM inj_file
       WHERE inj01 = g_inf[l_ac].inf03
         AND inj02 = g_inf[l_ac].inf04b
         And inj03 = g_inf[l_ac].inf08
   END IF
#TQC-C20467 ----- add ----- end

   CASE
      WHEN SQLCA.sqlcode = 100
         LET g_errno = 'aim1112'
         LET l_ini02 = NULL
         LET l_inj04 = NULL
      OTHERWISE
         LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_inf[l_ac].inf04b) THEN
      IF l_imac03 = '2' THEN
         LET g_errno = 'aim1135'
      END IF
   ELSE
      IF l_imac03 = '1' THEN
         LET g_errno = 'aim1136'
      END IF
   END IF
 
   IF cl_null(g_errno) THEN
      LET g_inf[l_ac].ini02 = l_ini02
      LET g_inf[l_ac].inf09b = l_inj04
      DISPLAY l_ini02 TO ini02
      DISPLAY l_inj04 TO inf09b
   END IF

END FUNCTION

#TQC-B90236--end
#CHI-C80041---begin
#FUNCTION t600_v()       #CHI-D20010
FUNCTION t600_v(p_type)  #CHI-D20010
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  #CHI-D20010
DEFINE   p_type             LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_ine.ine01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_ine.ineconf ='X' THEN RETURN END IF
   ELSE
      IF g_ine.ineconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end 

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t600_cl USING g_ine.ine01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_ine.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ine.ine01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t600_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_ine.ineconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_ine.ineconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_ine.ineconf)   THEN 
   IF cl_void(0,0,l_flag)   THEN   #CHI-D20010
        LET l_chr=g_ine.ineconf
       #IF g_ine.ineconf='N' THEN #CHI-D20010
        IF p_type = 1 THEN #CHI-D20010
            LET g_ine.ineconf='X' 
        ELSE
            LET g_ine.ineconf='N'
        END IF
        UPDATE ine_file
            SET ineconf=g_ine.ineconf,  
                inemodu=g_user,
                inedate=g_today
            WHERE ine01=g_ine.ine01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ine_file",g_ine.ine01,"",SQLCA.sqlcode,"","",1)  
            LET g_ine.ineconf=l_chr 
        END IF
        DISPLAY BY NAME g_ine.ineconf 
   END IF
 
   CLOSE t600_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ine.ine01,'V')
 
END FUNCTION
#CHI-C80041---end
