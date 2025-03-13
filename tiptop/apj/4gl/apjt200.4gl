# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: apjt200.4gl
# Descriptions...: 建立網絡活動基本資料維護作業
# Date & Author..: No.FUN-790025 07/11/19 By douzh 
# Modify.........: No.TQC-840009 08/04/03 By douzh 項目管理關聯性質處理
# Modify.........: No.TQC-840046 08/04/18 By douzh 邏輯管控加嚴(已審核的資料只可維護ACTION,不可更新資料)
# Modify.........: No.MOD-840430 08/04/21 By rainy 預計開工日不可小於專案的預計開工日
# Modify.........: No.MOD-840448 08/04/21 By douzh 光標停在活動編號開啟當前活動明細
# Modify.........: No.MOD-840477 08/04/23 By douzh 串apji700項目管理維護作業
# Modify.........: no.MOD-840478 08/04/28 by Yiting 專案編號未確認不可使用
# Modify.........: No.TQC-960248 09/06/22 By destiny 程式SQL執行會有問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 單身/修改/刪除時加上專案是否'結案'的判斷
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A70057 10/07/13 By Carrier CONSTRUCT时加上oriu/orig
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B70164 11/07/21 By lixia 隱藏確認碼欄位
# Modify.........: No.FUN-B80031 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pjj         RECORD LIKE pjj_file.*,       #簽核等級 (單頭)
       g_pjj_t       RECORD LIKE pjj_file.*,       #簽核等級 (舊值)
       g_pjj_o       RECORD LIKE pjj_file.*,       #簽核等級 (舊值)
       g_pjj01_t     LIKE pjj_file.pjj01,          #簽核等級 (舊值)
       g_t1          LIKE oay_file.oayslip,        
       g_sheet       LIKE oay_file.oayslip,        #單別 (沿用)
       g_ydate       LIKE type_file.dat,           #DATE    #單據日期(沿用)
       g_pjk         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           pjk02     LIKE pjk_file.pjk02,          #活動代號
           pjk03     LIKE pjk_file.pjk03,          #活動名稱
           pjk04     LIKE pjk_file.pjk04,          #活動分類
           pjr02     LIKE pjr_file.pjr02,          #分類名稱
           pjk05     LIKE pjk_file.pjk05,          #部門編號
           gem02     LIKE gem_file.gem02,          #部門名稱
           pjk11     LIKE pjk_file.pjk11,          #對應WBS元素
           pjb03     LIKE pjb_file.pjb03,          #WBS名稱
           pjk07     LIKE pjk_file.pjk07,          #進度確認方式
           pjk13     LIKE pjk_file.pjk13           #優先工作否
                     END RECORD,
       g_pjk_t       RECORD                        #程式變數 (舊值)
           pjk02     LIKE pjk_file.pjk02,          #活動代號
           pjk03     LIKE pjk_file.pjk03,          #活動名稱
           pjk04     LIKE pjk_file.pjk04,          #活動分類
           pjr02     LIKE pjr_file.pjr02,          #分類名稱
           pjk05     LIKE pjk_file.pjk05,          #部門編號
           gem02     LIKE gem_file.gem02,          #部門名稱
           pjk11     LIKE pjk_file.pjk11,          #對應WBS元素
           pjb03     LIKE pjb_file.pjb03,          #WBS名稱
           pjk07     LIKE pjk_file.pjk07,          #進度確認方式
           pjk13     LIKE pjk_file.pjk13           #優先工作否
                     END RECORD,
       g_pjk_o       RECORD                        #程式變數 (舊值)
           pjk02     LIKE pjk_file.pjk02,          #活動代號
           pjk03     LIKE pjk_file.pjk03,          #活動名稱
           pjk04     LIKE pjk_file.pjk04,          #活動分類
           pjr02     LIKE pjr_file.pjr02,          #分類名稱
           pjk05     LIKE pjk_file.pjk05,          #部門編號
           gem02     LIKE gem_file.gem02,          #部門名稱
           pjk11     LIKE pjk_file.pjk11,          #對應WBS元素
           pjb03     LIKE pjb_file.pjb03,          #WBS名稱
           pjk07     LIKE pjk_file.pjk07,          #進度確認方式
           pjk13     LIKE pjk_file.pjk13           #優先工作否
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存 
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT 
DEFINE l_ac1         LIKE type_file.num5           #當前光標停留在的ARRAY CNT       #No.MOD-840448
DEFINE g_gec07             LIKE gec_file.gec07
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5 
DEFINE g_chr               LIKE type_file.chr1  
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  
DEFINE g_msg               LIKE ze_file.ze03     
DEFINE g_curs_index        LIKE type_file.num10   
DEFINE g_row_count         LIKE type_file.num10   #總筆數  
DEFINE g_jump              LIKE type_file.num10   #查詢指定的筆數 
DEFINE mi_no_ask           LIKE type_file.num5    #是否開啟指定筆視窗  
DEFINE g_pjk11             LIKE pjk_file.pjk11  
DEFINE l_table             STRING
DEFINE g_str               STRING
DEFINE g_pjz04             LIKE pjz_file.pjz04    #系統參數設置
DEFINE g_pjz05             LIKE pjz_file.pjz05    #系統參數設置
DEFINE l_cmd               LIKE type_file.chr1000
DEFINE g_argv1             LIKE pja_file.pja01    #apji700串參數  #No.MOD-840477
DEFINE g_cn                LIKE type_file.num5    #No.MOD-840477
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = "SELECT * FROM pjj_file WHERE pjj01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t200_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1 = ARG_VAL(1)                       #No.MOD-840477
 
   OPEN WINDOW t200_w WITH FORM "apj/42f/apjt200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_set_locale_frm_name("apjt200")   
   CALL cl_ui_init()
   
   LET g_pdate = g_today   #No.FUN-710091 
   CALL cl_set_comp_visible('pjjconf',FALSE)  #TQC-B70164
 
   IF g_argv1 IS NOT NULL THEN 
      SELECT count(*) INTO g_cn FROM pjk_file,pjj_file
       WHERE pjk01 = pjj01 AND pjj04=g_argv1
      IF g_cn > 0 THEN
         CALL t200_q()
      ELSE
         CALL t200_pjj04('d')
         CALL t200_a()
      END IF
   END IF
 
   LET g_ydate = NULL
 
   CALL t200_menu()
   CLOSE WINDOW t200_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION t200_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
 
   CLEAR FORM 
  IF cl_null(g_argv1) THEN               #No.MOD-840477 add  by douzh 
     CALL g_pjk.clear()
  
      CALL cl_set_head_visible("","YES")          
      INITIALIZE g_pjj.* TO NULL    
      CONSTRUCT BY NAME g_wc ON pjj01,pjj02,pjj04,pjj05,pjj06, 
                                pjj07,pjj08,pjj09,pjj10,pjj03,pjjconf, 
                                pjjuser,pjjgrup,pjjoriu,pjjorig,     #No.TQC-A70057
                                pjjmodu,pjjdate,pjjacti
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(pjj04) #項目編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pjj4"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pjj04
                  NEXT FIELD pjj04
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
      
      IF INT_FLAG THEN
         RETURN
      END IF
 
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjjuser', 'pjjgrup')
 
      CONSTRUCT g_wc2 ON pjk02,pjk03,pjk04,pjk05,pjk11,pjk07,pjk13   #螢幕上取單身條件 
              FROM s_pjk[1].pjk02,s_pjk[1].pjk03,s_pjk[1].pjk04,
                   s_pjk[1].pjk05,s_pjk[1].pjk11,s_pjk[1].pjk07,
                   s_pjk[1].pjk13         
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pjk04) #活動分類
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_pjk04"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pjk04
                    NEXT FIELD pjk04
               WHEN INFIELD(pjk05) #部門編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_pjk05"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pjk05
                    NEXT FIELD pjk05
               WHEN INFIELD(pjk11) #對應的WBS元素
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = 'c'
                    LET g_qryparam.form ="q_pjk11"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pjk11
                    NEXT FIELD pjk11
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
 
   ELSE                                                           #No.MOD-840477
      LET g_wc="pjj04='",g_argv1,"'"                              #No.MOD-840477 
      LET g_wc2 = " 1=1"
   END IF                                                         #No.MOD-840477 
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  pjj01 FROM pjj_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY pjj01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE pjj_file. pjj01 ",
                  "  FROM pjj_file, pjk_file ",
                  " WHERE pjj01 = pjk01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY pjj01"
   END IF
 
   PREPARE t200_prepare FROM g_sql
   DECLARE t200_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t200_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM pjj_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT pjj01) FROM pjj_file,pjk_file WHERE ",
                "pjk01=pjj01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t200_precount FROM g_sql
   DECLARE t200_count CURSOR FOR t200_precount
 
END FUNCTION
 
FUNCTION t200_menu()
 
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t200_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t200_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t200_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t200_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t200_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "apjt200" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjk),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pjj.pjj01 IS NOT NULL THEN
                 LET g_doc.column1 = "pjj01"
                 LET g_doc.value1 = g_pjj.pjj01
                 CALL cl_doc()
               END IF
         END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjk TO s_pjk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                  
 
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
         CALL t200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL t200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next
         CALL t200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION last
         CALL t200_fetch('L')
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
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              
 
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
         LET INT_FLAG=FALSE        
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION  AbNetwork            #網路間活動關設定
         IF NOT cl_null(g_pjj.pjj01) THEN
            LET l_cmd="apjt202 '",g_pjj.pjj01,"' "
            CALL cl_cmdrun_wait(l_cmd)
         END IF
 
      ON ACTION  AbDetail2      #活動明細設定
         IF NOT cl_null(g_pjj.pjj01) THEN
            LET l_ac1 = ARR_CURR()
            LET l_cmd="apjt201 '",g_pjj.pjj01,"' '",g_pjk[l_ac1].pjk02,"' "              
            CALL cl_cmdrun_wait(l_cmd)
         END IF
 
      ON ACTION about        
         CALL cl_about()    
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")     
 
      ON ACTION related_document              
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t200_bp_refresh()
  DISPLAY ARRAY g_pjk TO s_pjk.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t200_a()
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10   #No.FUN-680136 INTEGER
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pjk.clear()
   LET g_wc = NULL #MOD-530329
   LET g_wc2= NULL #MOD-530329
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_pjj.* LIKE pjj_file.*             #DEFAULT 設定
   LET g_pjj01_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_pjj_t.* = g_pjj.*
   LET g_pjj_o.* = g_pjj.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      IF g_argv1 IS NOT NULL THEN
         CALL t200_pjj04('d')
         LET g_pjj.pjj04 = g_argv1
      END IF
      LET g_pjj.pjj03 = '1'
      LET g_pjj.pjjconf= 'N'
      LET g_pjj.pjjuser=g_user
      LET g_pjj.pjjoriu = g_user #FUN-980030
      LET g_pjj.pjjorig = g_grup #FUN-980030
      LET g_pjj.pjjgrup=g_grup
      LET g_pjj.pjjdate=g_today
      LET g_pjj.pjjacti='Y'              #資料有效
 
      CALL t200_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_pjj.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_pjj.pjj01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
 
      INSERT INTO pjj_file VALUES (g_pjj.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","pjj_file",g_pjj.pjj01,"",SQLCA.sqlcode,"","",1) #No.FUN-B80031---調整至回滾事務前--- 
         ROLLBACK WORK    
         CONTINUE WHILE
      ELSE
         COMMIT WORK    
         CALL cl_flow_notify(g_pjj.pjj01,'I')
      END IF
 
      SELECT pjj01 INTO g_pjj.pjj01 FROM pjj_file
       WHERE pjj01 = g_pjj.pjj01
      LET g_pjj01_t = g_pjj.pjj01        #保留舊值
      LET g_pjj_t.* = g_pjj.*
      LET g_pjj_o.* = g_pjj.*
      CALL g_pjk.clear()
 
      LET g_rec_b = 0  #No.MOD-490280
      CALL t200_b()                   #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t200_u()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjj.pjj01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_pjj.* FROM pjj_file
    WHERE pjj01=g_pjj.pjj01
 
   IF g_pjj.pjjacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pjj.pjj01,'mfg1000',0)
      RETURN
   END IF
   SELECT pjaclose INTO l_pjaclose FROM pja_file
    WHERE pja01=g_pjj.pjj04
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pjj01_t = g_pjj.pjj01
   BEGIN WORK
 
   OPEN t200_cl USING g_pjj.pjj01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_pjj.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjj.pjj01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t200_show()
 
   WHILE TRUE
      LET g_pjj01_t = g_pjj.pjj01
      LET g_pjj_o.* = g_pjj.*
      LET g_pjj.pjjmodu=g_user
      LET g_pjj.pjjdate=g_today
 
      CALL t200_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pjj.*=g_pjj_t.*
         CALL t200_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_pjj.pjj01 != g_pjj01_t THEN            # 更改單號
         UPDATE pjk_file SET pjk01 = g_pjj.pjj01
          WHERE pjk01 = g_pjj01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pjk_file",g_pjj01_t,"",SQLCA.sqlcode,"","pjk",1)  
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE pjj_file SET pjj_file.* = g_pjj.*
       WHERE pjj01 = g_pjj01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","pjj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t200_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pjj.pjj01,'U')
 
   CALL t200_b_fill("1=1")
   CALL t200_bp_refresh()
 
END FUNCTION
 
FUNCTION t200_i(p_cmd)
DEFINE
   l_n       LIKE type_file.num5, 
   l_n2      LIKE type_file.num5, 
   p_cmd     LIKE type_file.chr1     #a:輸入 u:更改  
DEFINE    li_result   LIKE type_file.num5    
DEFINE    l_pja10     LIKE pja_file.pja10  #MOD-840430
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_pjj.pjjuser,g_pjj.pjjmodu,
       g_pjj.pjjgrup,g_pjj.pjjdate,g_pjj.pjjacti
 
   CALL cl_set_head_visible("","YES")   
   INPUT BY NAME g_pjj.pjj01,g_pjj.pjj02,g_pjj.pjj03,              g_pjj.pjjoriu,g_pjj.pjjorig,
                 g_pjj.pjj04,g_pjj.pjj05,g_pjj.pjj06,  
                 g_pjj.pjj07,g_pjj.pjj08,g_pjj.pjj09,  
                 g_pjj.pjj10,g_pjj.pjjconf
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t200_set_entry(p_cmd)
         CALL t200_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD pjj01
         IF NOT cl_null(g_pjj.pjj01) THEN
            IF g_pjj_o.pjj01 IS NULL OR                                                                                             
               (g_pjj_o.pjj01 != g_pjj.pjj01 ) THEN 
               SELECT COUNT(*) INTO l_n FROM pjj_file
                WHERE pjj01=g_pjj.pjj01
               IF l_n > 0 THEN
                  CALL cl_err(g_pjj.pjj01,"-239",1)
                  LET g_pjj.pjj01 = g_pjj_t.pjj01
                  NEXT FIELD pjj01
               END IF
               SELECT pjz04 INTO g_pjz04 FROM pjz_file 
               LET l_n2 = length(g_pjj.pjj01)
               IF l_n2 != g_pjz04 THEN 
                  CALL cl_err_msg("","apj-038",g_pjz04 CLIPPED,0)
                  LET g_pjj.pjj01 = g_pjj_t.pjj01
                  NEXT FIELD pjj01
               END IF
            END IF
         END IF
 
      AFTER FIELD pjj04                  #專案編號
         IF NOT cl_null(g_pjj.pjj04) THEN
            IF g_pjj_o.pjj04 IS NULL OR                                                                                             
               (g_pjj_o.pjj04 != g_pjj.pjj04 ) THEN 
               SELECT COUNT(*) INTO l_n FROM pjj_file
                  WHERE pjj04=g_pjj.pjj04
               IF l_n > 0 THEN
                  CALL cl_err(g_pjj.pjj04,"-239",1)
                  LET g_pjj.pjj04 = g_pjj_t.pjj04
                  NEXT FIELD pjj04
               END IF
               CALL t200_pjj04('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjj.pjj04,g_errno,0)
                  LET g_pjj.pjj04 = g_pjj_o.pjj04
                  DISPLAY BY NAME g_pjj.pjj04
                  NEXT FIELD pjj04
               END IF
            END IF
         END IF
 
      AFTER FIELD pjj05                  #
         IF NOT cl_null(g_pjj.pjj05) THEN
            IF g_pjj_o.pjj05 IS NULL OR                                                                                             
               (g_pjj_o.pjj05 != g_pjj.pjj05 ) THEN 
               SELECT pja10 INTO l_pja10 FROM pja_file 
                WHERE pja01 = g_pjj.pjj04
               IF g_pjj.pjj05 < l_pja10 THEN
                  CALL cl_err(g_pjj.pjj05,'apj-085',0)
                  LET g_pjj.pjj05 = g_pjj_o.pjj05
                  DISPLAY BY NAME g_pjj.pjj05
                  NEXT FIELD pjj05
               END IF
            END IF
         END IF
 
      AFTER FIELD pjj06                  #
         IF NOT cl_null(g_pjj.pjj06) AND NOT cl_null(g_pjj.pjj05) THEN
            IF g_pjj.pjj06 < g_pjj.pjj05 THEN
               CALL cl_err(g_pjj.pjj06,'apj-044',0)
               LET g_pjj.pjj06 = g_pjj_o.pjj06
               DISPLAY BY NAME g_pjj.pjj06
               NEXT FIELD pjj06
            END IF
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
            WHEN INFIELD(pjj04) #項目編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pja21"
               LET g_qryparam.arg1 = g_pjj.pjj03
               LET g_qryparam.default1 = g_pjj.pjj04
               CALL cl_create_qry() RETURNING g_pjj.pjj04
               DISPLAY BY NAME g_pjj.pjj04
               CALL t200_pjj04('d')
               NEXT FIELD pjj04
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
 
FUNCTION t200_pjj04(p_cmd)  #項目編號
   DEFINE l_pja02   LIKE pja_file.pja02,
          l_pja03   LIKE pja_file.pja03,
          l_pja06   LIKE pja_file.pja06,          #TQC-840009
          l_pjaacti LIKE pja_file.pjaacti,
          l_pja12   LIKE pja_file.pja12,
          l_pjaclose LIKE pja_file.pjaclose,      #No.FUN-960038
          p_cmd     LIKE type_file.chr1 
   DEFINE l_pjaconf LIKE pja_file.pjaconf  #NO.MOD-840478
 
   LET g_errno = ' '
 
    IF g_argv1 IS NOT NULL THEN
       SELECT pja02,pjaacti,pja03,pja06,pja12,pjaconf,pjaclose                #no.MOD-840478 #No.FUN-960038 ADD pjaclose
         INTO l_pja02,l_pjaacti,l_pja03,l_pja06,l_pja12,l_pjaconf,l_pjaclose  #no.MOD-840478 #No.FUN-960038 ADD l_pjaclose
         FROM pja_file WHERE pja01 = g_argv1
    ELSE
       SELECT pja02,pjaacti,pja03,pja06,pja12,pjaconf,pjaclose    #TQC-840009    #NO.MOD-840478 #No.FUN-960038 ADD pjaclose
         INTO l_pja02,l_pjaacti,l_pja03,l_pja06,l_pja12,l_pjaconf,l_pjaclose   #TQC-840009  #NO.MOD-840478 #No.FUN-960038 ADD l_pjaclose
         FROM pja_file WHERE pja01 = g_pjj.pjj04
    END IF
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3064'
                           LET l_pja02 = NULL
                           LET l_pja03 = NULL
        WHEN l_pjaacti='N' LET g_errno = '9028'
        WHEN l_pja12 ='N'  LET g_errno = 'apj-042'
        WHEN l_pjaconf='N' LET g_errno = 'apj-601'
        WHEN l_pjaclose='Y' LET g_errno = 'abg-503'              #No.FUN-960038
        WHEN l_pja06!=g_pjj.pjj03
                           LET g_errno = 'apj-080'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF g_argv1 IS NOT NULL THEN
         LET g_pjj.pjj04 = g_argv1
         DISPLAY g_pjj.pjj04 TO pjb01
      END IF
      DISPLAY l_pja02 TO FORMONLY.pja02
      DISPLAY l_pja03 TO FORMONLY.pja03
   END IF
 
END FUNCTION
 
FUNCTION t200_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pjk.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t200_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pjj.* TO NULL
      RETURN
   END IF
 
   OPEN t200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pjj.* TO NULL
   ELSE
      OPEN t200_count
      FETCH t200_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t200_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t200_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t200_cs INTO g_pjj.pjj01
      WHEN 'P' FETCH PREVIOUS t200_cs INTO g_pjj.pjj01
      WHEN 'F' FETCH FIRST    t200_cs INTO g_pjj.pjj01
      WHEN 'L' FETCH LAST     t200_cs INTO g_pjj.pjj01
      WHEN '/'
            IF (NOT mi_no_ask) THEN      #No.FUN-6A0067
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
            FETCH ABSOLUTE g_jump t200_cs INTO g_pjj.pjj01
            LET mi_no_ask = FALSE     #No.FUN-6A0067
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjj.pjj01,SQLCA.sqlcode,0)
      INITIALIZE g_pjj.* TO NULL               #No.FUN-6A0162
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
      DISPLAY g_curs_index TO FORMONLY.idx                    #No.FUN-4A0089
   END IF
 
   SELECT * INTO g_pjj.* FROM pjj_file WHERE pjj01 = g_pjj.pjj01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pjj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_pjj.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_pjj.pjjuser      #FUN-4C0056 add
   LET g_data_group = g_pjj.pjjgrup      #FUN-4C0056 add
 
   CALL t200_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t200_show()
 
   LET g_pjj_t.* = g_pjj.*                #保存單頭舊值
   LET g_pjj_o.* = g_pjj.*                #保存單頭舊值
   DISPLAY BY NAME g_pjj.pjj01,g_pjj.pjj02,g_pjj.pjj03, g_pjj.pjjoriu,g_pjj.pjjorig,
                   g_pjj.pjj04,g_pjj.pjj05,g_pjj.pjj06,  
                   g_pjj.pjj07,g_pjj.pjj08,g_pjj.pjj09,  
                   g_pjj.pjj10,g_pjj.pjjconf,  
                   g_pjj.pjjuser,g_pjj.pjjgrup,g_pjj.pjjmodu,
                   g_pjj.pjjdate,g_pjj.pjjacti 
 
   CALL t200_pjj04('d')
 
   CALL t200_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()                
 
END FUNCTION
 
FUNCTION t200_x()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038 
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjj.pjj01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT pjaclose INTO l_pjaclose FROM pja_file
    WHERE pja01=g_pjj.pjj04
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t200_cl USING g_pjj.pjj01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_pjj.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjj.pjj01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t200_show()
 
   IF cl_exp(0,0,g_pjj.pjjacti) THEN                   #確認一下
      LET g_chr=g_pjj.pjjacti
      IF g_pjj.pjjacti='Y' THEN
         LET g_pjj.pjjacti='N'
      ELSE
         LET g_pjj.pjjacti='Y'
      END IF
 
      UPDATE pjj_file SET pjjacti=g_pjj.pjjacti,
                          pjjmodu=g_user,
                          pjjdate=g_today
       WHERE pjj01=g_pjj.pjj01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pjj_file",g_pjj.pjj01,"",SQLCA.sqlcode,"","",1) 
         LET g_pjj.pjjacti=g_chr
      END IF
   END IF
 
   CLOSE t200_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_pjj.pjj01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT pjjacti,pjjmodu,pjjdate
     INTO g_pjj.pjjacti,g_pjj.pjjmodu,g_pjj.pjjdate FROM pjj_file
    WHERE pjj01=g_pjj.pjj01
   DISPLAY BY NAME g_pjj.pjjacti,g_pjj.pjjmodu,g_pjj.pjjdate
 
END FUNCTION
 
FUNCTION t200_r()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pjj.pjj01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   SELECT pjaclose INTO l_pjaclose FROM pja_file                                                                                    
    WHERE pja01=g_pjj.pjj04                                                                                                         
   IF l_pjaclose = 'Y' THEN                                                                                                         
      CALL cl_err('','apj-602',0)                                                                                                   
      RETURN                                                                                                                        
   END IF                                                                                                                           
 
   SELECT * INTO g_pjj.* FROM pjj_file
    WHERE pjj01=g_pjj.pjj01
   BEGIN WORK
 
   OPEN t200_cl USING g_pjj.pjj01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t200_cl INTO g_pjj.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pjj.pjj01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t200_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pjj01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pjj.pjj01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM pjj_file WHERE pjj01 = g_pjj.pjj01
      DELETE FROM pjk_file WHERE pjk01 = g_pjj.pjj01
      CLEAR FORM
      CALL g_pjk.clear()
      OPEN t200_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t200_cs
         CLOSE t200_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t200_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t200_cs
         CLOSE t200_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t200_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t200_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE      #No.FUN-6A0067
         CALL t200_fetch('/')
      END IF
   END IF
 
   CLOSE t200_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pjj.pjj01,'D')
END FUNCTION
 
#單身
FUNCTION t200_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,                #檢查重複用
    l_n2            LIKE type_file.num5,                #檢查重複用 
    l_cnt           LIKE type_file.num5,                #檢查重複用
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態 
    l_misc          LIKE gef_file.gef01,         
    l_allow_insert  LIKE type_file.num5,                #可新增否  
    l_allow_delete  LIKE type_file.num5                 #可刪除否
DEFINE l_pjk27      LIKE pjk_file.pjk27                 #活動審核碼
DEFINE l_pjaclose   LIKE pja_file.pjaclose              #No.FUN-960038
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_pjj.pjj01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_pjj.* FROM pjj_file
     WHERE pjj01=g_pjj.pjj01
 
    IF g_pjj.pjjacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_pjj.pjj01,'mfg1000',0)
       RETURN
    END IF
   SELECT pjaclose INTO l_pjaclose FROM pja_file
    WHERE pja01=g_pjj.pjj04
   IF l_pjaclose = 'Y' THEN
      CALL cl_err('','apj-602',0)
      RETURN
   END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pjk02,pjk03,pjk04,'',pjk05,'',pjk11,'',pjk07,pjk13 ", 
                       "  FROM pjk_file",
                       "  WHERE pjk01=? AND pjk02=? ",
                       " FOR UPDATE " 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pjk WITHOUT DEFAULTS FROM s_pjk.*
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
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN t200_cl USING g_pjj.pjj01
           IF STATUS THEN
              CALL cl_err("OPEN t200_cl:", STATUS, 1)
              CLOSE t200_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t200_cl INTO g_pjj.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_pjj.pjj01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t200_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_pjk_t.* = g_pjk[l_ac].*  #BACKUP
              LET g_pjk_o.* = g_pjk[l_ac].*  #BACKUP
              OPEN t200_bcl USING g_pjj.pjj01,g_pjk_t.pjk02
              IF STATUS THEN
                 CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t200_bcl INTO g_pjk[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pjk_t.pjk02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t200_pjk04('d',l_ac)
                 CALL t200_pjk05('d',l_ac)
                 CALL t200_pjk11('d',l_ac)
              END IF
              CALL cl_show_fld_cont()     
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pjk[l_ac].* TO NULL      #900423
           LET g_pjk[l_ac].pjk07   = '0'         #進度確認方式
           LET g_pjk[l_ac].pjk13   = 'N'         #優先否
           LET g_pjk_t.* = g_pjk[l_ac].*         #新輸入資料
           LET g_pjk_o.* = g_pjk[l_ac].*         #新輸入資料
           IF l_ac > 1 THEN
              LET g_pjk[l_ac].pjk04 = g_pjk[l_ac-1].pjk04
           ELSE
              LET g_pjk[l_ac].pjk04 = g_pjj.pjj06
           END IF
           CALL cl_show_fld_cont()         
           NEXT FIELD pjk02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO pjk_file(pjk01,pjk02,pjk03,pjk04,pjk05,pjk07,
                                pjk11,pjk13,pjkacti,pjkuser,pjkgrup,pjkdate,pjkoriu,pjkorig) 
           VALUES(g_pjj.pjj01,g_pjk[l_ac].pjk02,
                  g_pjk[l_ac].pjk03,g_pjk[l_ac].pjk04,
                  g_pjk[l_ac].pjk05,g_pjk[l_ac].pjk07,
                  g_pjk[l_ac].pjk11,g_pjk[l_ac].pjk13,
                  'Y',g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","pjk_file",g_pjj.pjj01,g_pjk[l_ac].pjk02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        AFTER FIELD pjk02                        #check 序號是否重複
           IF NOT cl_null(g_pjk[l_ac].pjk02) THEN
              IF g_pjk[l_ac].pjk02 != g_pjk_t.pjk02
                 OR g_pjk_t.pjk02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM pjk_file
                  WHERE pjk01 = g_pjj.pjj01
                    AND pjk02 = g_pjk[l_ac].pjk02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pjk[l_ac].pjk02 = g_pjk_t.pjk02
                    NEXT FIELD pjk02
                 END IF
                 SELECT pjz05 INTO g_pjz05 FROM pjz_file 
                 LET l_n2 = length(g_pjk[l_ac].pjk02)
                 IF l_n2 != g_pjz05 THEN 
                    CALL cl_err_msg("","apj-038",g_pjz05 CLIPPED,0)
                    LET g_pjk[l_ac].pjk02 = g_pjk_t.pjk02
                    NEXT FIELD pjk02
                 END IF
              END IF
           END IF
 
      AFTER FIELD pjk03                    #活動名稱
         IF NOT cl_null(g_pjk[l_ac].pjk03) THEN
             
         END IF
 
        AFTER FIELD pjk04                  #活動分類
           IF NOT cl_null(g_pjk[l_ac].pjk04) THEN
               CALL t200_pjk04('d',l_ac)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pjk[l_ac].pjk04,g_errno,0)
                  LET g_pjk[l_ac].pjk04 = g_pjk_o.pjk04
                  DISPLAY BY NAME g_pjk[l_ac].pjk04
                  NEXT FIELD pjk04
               END IF
           END IF
 
        AFTER FIELD pjk05                  #部門代號
           IF NOT cl_null(g_pjk[l_ac].pjk05) THEN
              CALL t200_pjk05('d',l_ac)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pjk[l_ac].pjk05,g_errno,0)
                 LET g_pjk[l_ac].pjk05 = g_pjk_o.pjk05
                 DISPLAY BY NAME g_pjk[l_ac].pjk05
                 NEXT FIELD pjk05
              END IF
           END IF
 
        AFTER FIELD pjk11                  #對應WBS分類
           IF NOT cl_null(g_pjk[l_ac].pjk11) THEN
              CALL t200_pjk11('d',l_ac)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pjk[l_ac].pjk11,g_errno,0)
                 LET g_pjk[l_ac].pjk11 = g_pjk_o.pjk11
                 DISPLAY BY NAME g_pjk[l_ac].pjk11
                 NEXT FIELD pjk11
              END IF
           END IF
 
        AFTER FIELD pjk07                 #進度確認方式
           IF NOT cl_null(g_pjk[l_ac].pjk07) THEN
           END IF
 
        AFTER FIELD pjk13                  #優先工作否
           IF NOT cl_null(g_pjk[l_ac].pjk13) THEN
           END IF
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_pjk_t.pjk02 IS NOT NULL THEN
               SELECT pjk27 INTO l_pjk27 
                 FROM pjk_file WHERE pjk01 = g_pjj.pjj01
                 AND pjk02 = g_pjk_t.pjk02
               IF l_pjk27 = '1' THEN
                  CALL cl_err(g_pjk[l_ac].pjk02,'apj-084',0)
                  CANCEL DELETE
               END IF
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pjk_file
               WHERE pjk01 = g_pjj.pjj01
                 AND pjk02 = g_pjk_t.pjk02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pjk_file",g_pjj.pjj01,g_pjk_t.pjk02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_pjk[l_ac].* = g_pjk_t.*
              CLOSE t200_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           SELECT pjk27 INTO l_pjk27 
             FROM pjk_file WHERE pjk01 = g_pjj.pjj01
             AND pjk02 = g_pjk_t.pjk02
           IF l_pjk27 = '1' THEN
              CALL cl_err(g_pjk[l_ac].pjk02,'apj-084',0)
              LET g_pjk[l_ac].* = g_pjk_t.*
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pjk[l_ac].pjk02,-263,1)
              LET g_pjk[l_ac].* = g_pjk_t.*
           ELSE
              UPDATE pjk_file SET pjk02=g_pjk[l_ac].pjk02,
                                  pjk03=g_pjk[l_ac].pjk03,
                                  pjk04=g_pjk[l_ac].pjk04,
                                  pjk05=g_pjk[l_ac].pjk05,
                                  pjk07=g_pjk[l_ac].pjk07,
                                  pjk11=g_pjk[l_ac].pjk11, 
                                  pjk13=g_pjk[l_ac].pjk13,
                                  pjkacti='Y',
                                  pjkuser=g_user,
                                  pjkgrup=g_grup,
                                  pjkdate=g_today 
               WHERE pjk01=g_pjj.pjj01
                 AND pjk02=g_pjk_t.pjk02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","pjk_file",g_pjj.pjj01,g_pjk_t.pjk02,SQLCA.sqlcode,"","",1) 
                 LET g_pjk[l_ac].* = g_pjk_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_pjk[l_ac].* = g_pjk_t.*
              #FUN-D30034--add--begin--
              ELSE
                 CALL g_pjk.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034--add--end----
              END IF
              CLOSE t200_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30034 add
           CLOSE t200_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pjk02) AND l_ac > 1 THEN
              LET g_pjk[l_ac].* = g_pjk[l_ac-1].*
              LET g_pjk[l_ac].pjk02 = g_rec_b + 1
              NEXT FIELD pjk02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(pjk04) #活動分類
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pjr"
                 LET g_qryparam.default1 = g_pjk[l_ac].pjk04
                 CALL cl_create_qry() RETURNING g_pjk[l_ac].pjk04
                 DISPLAY BY NAME g_pjk[l_ac].pjk04              #No.MOD-490371
                 CALL t200_pjk04('d',l_ac)
                 NEXT FIELD pjk04
              WHEN INFIELD(pjk05) #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_pjk[l_ac].pjk05
                 CALL cl_create_qry() RETURNING g_pjk[l_ac].pjk05
                 DISPLAY BY NAME g_pjk[l_ac].pjk05
                 CALL t200_pjk05('d',l_ac)
                 NEXT FIELD pjk05
              WHEN INFIELD(pjk11) #對應WBS元素
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pjb5"
                 LET g_qryparam.arg1 = g_pjj.pjj04
                 LET g_qryparam.default1 = g_pjk[l_ac].pjk11
                 CALL cl_create_qry() RETURNING g_pjk[l_ac].pjk11
                 DISPLAY BY NAME g_pjk[l_ac].pjk11
                 CALL t200_pjk11('d',l_ac)
                 NEXT FIELD pjk11
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION Aplanmaterial     #活動預計材料需求
         IF NOT cl_null(g_pjk[l_ac].pjk02) THEN
            LET l_cmd="apjt203 '",g_pjj.pjj01,"' '",g_pjk[l_ac].pjk02,"'"              
            CALL cl_cmdrun_wait(l_cmd)
         END IF
 
      ON ACTION Ahuman            #活動預計人力需求
         IF NOT cl_null(g_pjk[l_ac].pjk02) THEN
            LET l_cmd="apjt204 '",g_pjj.pjj01,"' '",g_pjk[l_ac].pjk02,"'"              
            CALL cl_cmdrun_wait(l_cmd)
         END IF
 
      ON ACTION Aequipment        #活動預計設備需求
         IF NOT cl_null(g_pjk[l_ac].pjk02) THEN
            LET l_cmd="apjt205 '",g_pjj.pjj01,"' '",g_pjk[l_ac].pjk02,"'"              
            CALL cl_cmdrun_wait(l_cmd)
         END IF
 
      ON ACTION Aexpense         #活動預計費用需求
         IF NOT cl_null(g_pjk[l_ac].pjk02) THEN
            LET l_cmd="apjt206 '",g_pjj.pjj01,"' '",g_pjk[l_ac].pjk02,"'"              
            CALL cl_cmdrun_wait(l_cmd)
         END IF
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_pjj.pjjmodu = g_user
    LET g_pjj.pjjdate = g_today
    UPDATE pjj_file SET pjjmodu = g_pjj.pjjmodu,pjjdate = g_pjj.pjjdate
     WHERE pjj01 = g_pjj.pjj01
    DISPLAY BY NAME g_pjj.pjjmodu,g_pjj.pjjdate
 
    CLOSE t200_bcl
    COMMIT WORK
#   CALL t200_delall()  #CHI-C30002 mark
    CALL t200_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t200_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM pjj_file WHERE pjj01 = g_pjj.pjj01
         INITIALIZE g_pjj.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t200_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM pjk_file
#   WHERE pjk01 = g_pjj.pjj01
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM pjj_file WHERE pjj01 = g_pjj.pjj01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t200_pjk04(p_cmd,l_cnt)  #活動分類編號
   DEFINE l_pjr00   LIKE pjr_file.pjr00,
          l_pjr02   LIKE pjr_file.pjr02,
          l_pjracti LIKE pjr_file.pjracti,
          p_cmd     LIKE type_file.chr1,
          l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
 
   SELECT pjr02,pjracti                                                                                                       
     INTO l_pjr02,l_pjracti                                                                                                 
     FROM pjr_file
    WHERE pjr01 = g_pjk[l_cnt].pjk04 
      AND pjr00 ='1'
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-050'
                           LET l_pjr02 = NULL
        WHEN l_pjracti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pjk[l_cnt].pjr02 = l_pjr02
      DISPLAY BY NAME g_pjk[l_cnt].pjr02
   END IF
 
END FUNCTION
 
FUNCTION t200_pjk05(p_cmd,l_cnt)  #部門編號
   DEFINE l_gem02   LIKE gem_file.gem02,
          l_gemacti LIKE gem_file.gemacti,
          p_cmd     LIKE type_file.chr1,
          l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti  
     FROM gem_file WHERE gem01 = g_pjk[l_cnt].pjk05
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                           LET l_gem02 = NULL
        WHEN l_gemacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pjk[l_cnt].gem02 = l_gem02
      DISPLAY BY NAME g_pjk[l_cnt].gem02
   END IF
 
END FUNCTION
 
FUNCTION t200_pjk11(p_cmd,l_cnt)  #對應的WBS元素
   DEFINE l_pjb03   LIKE pjb_file.pjb03,
          l_pjb09   LIKE pjb_file.pjb09,
          l_pjb25   LIKE pjb_file.pjb25,
          l_pjbacti LIKE pjb_file.pjbacti,
          p_cmd     LIKE type_file.chr1,
          l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
   SELECT pjb03,pjbacti,pjb09,pjb25
     INTO l_pjb03,l_pjbacti,l_pjb09,l_pjb25
     FROM pjb_file WHERE pjb01 = g_pjj.pjj04
      AND pjb02 = g_pjk[l_cnt].pjk11
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'apj-051'
                           LET l_pjb03 = NULL
        WHEN l_pjbacti='N' LET g_errno = '9028'
        WHEN l_pjb09  ='N' LET g_errno = 'apj-086'
        WHEN l_pjb25  ='N' LET g_errno = 'apj-045'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pjk[l_cnt].pjb03 = l_pjb03
      DISPLAY BY NAME g_pjk[l_cnt].pjb03
   END IF
 
END FUNCTION
 
FUNCTION t200_b_askkey()
 
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON pjk02,pjk03,pjk04,pjk05,
                       pjk11,pjk07,pjk13   
            FROM s_pjk[1].pjk02,s_pjk[1].pjk03,s_pjk[1].pjk04,
                 s_pjk[1].pjk05,s_pjk[1].pjk11,
                 s_pjk[1].pjk07,s_pjk[1].pjk13
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
            WHEN INFIELD(pjk04) #活動分類
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_pjk04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk04
                 NEXT FIELD pjk04
            WHEN INFIELD(pjk05) #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_pjk05"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk05
                 NEXT FIELD pjk05
            WHEN INFIELD(pjk11) #對應的WBS元素
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_pjk11"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk11
                 NEXT FIELD pjk11
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
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
               
    END CONSTRUCT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    LET l_wc2 = l_wc2 CLIPPED," AND pjk11 ='",g_pjk11,"'"  #No.FUN-670099
 
    CALL t200_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t200_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT pjk02,pjk03,pjk04,'',pjk05,'',pjk11,'',pjk07,pjk13 ", 
               " FROM pjk_file", 
               " WHERE pjk01 ='",g_pjj.pjj01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pjk02"
   DISPLAY g_sql
 
   PREPARE t200_pb FROM g_sql
   DECLARE pjk_cs CURSOR FOR t200_pb
 
   CALL g_pjk.clear()
   LET g_cnt = 1
 
   FOREACH pjk_cs INTO g_pjk[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL t200_pjk04('d',g_cnt) 
       CALL t200_pjk05('d',g_cnt) 
       CALL t200_pjk11('d',g_cnt) 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_pjk.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t200_copy()
   DEFINE l_newno     LIKE pjj_file.pjj01,
          l_oldno     LIKE pjj_file.pjj01
   DEFINE li_result   LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pjj.pjj01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t200_set_entry('a')
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT l_newno FROM pjj01
       
       BEFORE INPUT
 
       AFTER FIELD pjj01
           IF cl_null(g_pjj.pjj01) THEN
              LET g_pjj.pjj01 = g_pjj_o.pjj01
              NEXT FIELD pjj01
           END IF
           DISPLAY BY NAME g_pjj.pjj01          
 
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
      DISPLAY BY NAME g_pjj.pjj01
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM pjj_file         #單頭複製
       WHERE pjj01=g_pjj.pjj01
       INTO TEMP y
 
   UPDATE y
       SET pjj01=l_newno,    #新的鍵值
           pjjuser=g_user,   #資料所有者
           pjjgrup=g_grup,   #資料所有者所屬群
           pjjmodu=NULL,     #資料修改日期
           pjjdate=g_today,  #資料建立日期
           pjjacti='Y'       #有效資料
 
   INSERT INTO pjj_file SELECT * FROM y
  
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pjj_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pjk_file         #單身複製
       WHERE pjk01=g_pjj.pjj01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET pjk01=l_newno
 
   INSERT INTO pjk_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pjk_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-B80031---調整至回滾事務前--- 
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pjj.pjj01
   SELECT pjj_file.* INTO g_pjj.* FROM pjj_file WHERE pjj01 = l_newno
   CALL t200_u()
   CALL t200_b()
   #SELECT pjj_file.* INTO g_pjj.* FROM pjj_file WHERE pjj01 = l_oldno  #FUN-C80046
   #CALL t200_show()  #FUN-C80046
 
END FUNCTION
 
FUNCTION t200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pjj01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("pjj01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t200_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
    CALL cl_set_comp_entry("",TRUE)    #No.FUN-610018
 
END FUNCTION
 
FUNCTION t200_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
  CALL cl_set_comp_entry("pjk081,pjk082",FALSE)
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
