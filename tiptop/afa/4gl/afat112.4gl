# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: afat112.4gl
# Descriptions...: 資產族群編號異動維護作業
# Date & Author..: 11/10/03  FUN-B70092 By Sakura

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/14 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_fbo   RECORD LIKE fbo_file.*,
    g_fbo_t RECORD LIKE fbo_file.*,
    g_fbo_o RECORD LIKE fbo_file.*,
    g_fahprt        LIKE fah_file.fahprt,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,
    g_fbp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    fbp02     LIKE fbp_file.fbp02,
                    fbp03     LIKE fbp_file.fbp03,
                    fbp031    LIKE fbp_file.fbp031,
                    faj06     LIKE faj_file.faj06,
                    fbp04     LIKE fbp_file.fbp04,
                    fbp05     LIKE fbp_file.fbp05
                    END RECORD,
    g_fbp_t         RECORD
                    fbp02     LIKE fbp_file.fbp02,
                    fbp03     LIKE fbp_file.fbp03,
                    fbp031    LIKE fbp_file.fbp031,
                    faj06     LIKE faj_file.faj06,
                    fbp04     LIKE fbp_file.fbp04,
                    fbp05     LIKE fbp_file.fbp05
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fbo01_t       LIKE fbo_file.fbo01,
    g_wc,g_wc2,g_sql   STRING,
    l_modify_flag       LIKE type_file.chr1,
    l_flag              LIKE type_file.chr1,
    g_t1                LIKE type_file.chr5,
    g_buf               LIKE type_file.chr1000,
    g_rec_b             LIKE type_file.num5,                #單身筆數
    l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1          LIKE fbo_file.fbo01                 #異動單號
DEFINE g_argv2          STRING                              # 指定執行功能:query or inser
DEFINE g_laststage      LIKE type_file.chr1
DEFINE p_row,p_col      LIKE type_file.num5
DEFINE g_forupd_sql     STRING                              #SELECT ... FOR UPDATE SQL
DEFINE g_BEFORE_input_done LIKE type_file.num5
DEFINE g_chr            LIKE type_file.chr1
DEFINE g_chr2           LIKE type_file.chr1
DEFINE g_cnt            LIKE type_file.num10
DEFINE g_i              LIKE type_file.num5                 #count/index for any purpose
DEFINE g_msg            LIKE type_file.chr1000
DEFINE g_row_count      LIKE type_file.num10
DEFINE g_curs_index     LIKE type_file.num10
DEFINE g_jump           LIKE type_file.num10
DEFINE mi_no_ask        LIKE type_file.num5
DEFINE g_bookno1        LIKE aza_file.aza81
DEFINE g_bookno2        LIKE aza_file.aza82
DEFINE g_flag           LIKE type_file.chr1
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---

MAIN
DEFINE
    l_sql         LIKE type_file.chr1000

    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP                      #輸入的方式: 不打轉
    END IF

    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF


   LET g_forupd_sql = " SELECT * FROM fbo_file WHERE fbo01 =?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t112_cl CURSOR FROM g_forupd_sql

   LET g_wc2 = ' 1=1'
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
        RETURNING g_time

   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      LET p_row = 3 LET p_col = 10
      OPEN WINDOW t112_w AT p_row,p_col              #顯示畫面
           WITH FORM "afa/42f/afat112"
           ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
      CALL cl_ui_init()
   END IF


   IF fgl_getenv('EASYFLOW') = "1" THEN
      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
   END IF

   #建立簽核模式時的 toolbar icon
   CALL aws_efapp_toolbar()

  IF NOT cl_null(g_argv1) THEN
     CASE g_argv2
        WHEN "query"
           LET g_action_choice = "query"
           IF cl_chk_act_auth() THEN
              CALL t112_q()
           END IF
        WHEN "insert"
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t112_a()
           END IF
         WHEN "efconfirm"
            CALL t112_q()
            CALL t112_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t112_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t112_q()
     END CASE
  END IF

   #設定簽核功能及哪些 ACTION 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,   #FUN-D20035 add--undo_void
                              confirm, undo_confirm, easyflow_approval, auto_generate, post, undo_post")
        RETURNING g_laststage

   CALL t112_menu()
   CLOSE WINDOW t112_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
        RETURNING g_time
END MAIN

FUNCTION t112_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01

   CLEAR FORM                             #清除畫面
   CALL g_fbp.clear()
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " fbo01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
      CALL cl_set_head_visible("","YES")

      CONSTRUCT BY NAME g_wc ON                   # 螢幕上取單頭條件
         fbo01,fbo02,fbo03,fbo04,fbo05,fboconf,
         fbopost,fbomksg,fbo06,
         fbouser,fbogrup,fbomodu,fbodate,
         fboud01,fboud02,fboud03,fboud04,fboud05,
         fboud06,fboud07,fboud08,fboud09,fboud10,
         fboud11,fboud12,fboud13,fboud14,fboud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(fbo01)    #異動單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state= "c"
                    LET g_qryparam.form = "q_fbo"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbo01
                    NEXT FIELD fbo01
               WHEN INFIELD(fbo03)    #申請人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = "genacti='Y'"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbo03
                    NEXT FIELD fbo03
               WHEN INFIELD(fbo04)    #申請部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = "gemacti='Y'"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbo04
                    NEXT FIELD fbo04
               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
            CONTINUE CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_DISPLAY_condition(lc_qbe_sn)
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON fbp02,fbp03,fbp031,faj06,fbp04,fbp05
           FROM s_fbp[1].fbp02, s_fbp[1].fbp03, s_fbp[1].fbp031,s_fbp[1].faj06,
                s_fbp[1].fbp04, s_fbp[1].fbp05

		BEFORE CONSTRUCT
		   CALL cl_qbe_DISPLAY_condition(lc_qbe_sn)

         ON ACTION controlp
            CASE
               WHEN INFIELD(fbp03)  #財產編號,財產附號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_faj"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fbp03
                    NEXT FIELD fbp03
               OTHERWISE
                  EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
            CONTINUE CONSTRUCT

         ON ACTION qbe_save
            CALL cl_qbe_save()
            
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF

   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbouser', 'fbogrup')

   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      LET g_sql = "SELECT fbo01 FROM fbo_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY fbo01"
   ELSE                                       # 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT fbo01 ",
                  "  FROM fbo_file, fbp_file",
                  " WHERE fbo01 = fbp01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY fbo01"
   END IF
   PREPARE t112_prepare FROM g_sql
   DECLARE t112_cs SCROLL CURSOR WITH HOLD FOR t112_prepare  #SCROLL CURSOR
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM fbo_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT fbo01) FROM fbo_file,fbp_file",
                " WHERE fbp01 = fbo01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t112_precount FROM g_sql
   DECLARE t112_count CURSOR FOR t112_precount
END FUNCTION

FUNCTION t112_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員
 
   LET l_flowuser = "N"

   WHILE TRUE
      CALL t112_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t112_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t112_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t112_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t112_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t112_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t112_out()
            END IF            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
               CALL t112_g()
               CALL t112_b()
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t112_x()            #FUN-D20035
               CALL t112_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t112_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t112_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t112_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t112_z()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t112_s('S')
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t112_w()
            END IF
          WHEN "related_document"
            IF cl_chk_act_auth() THEN
               IF g_fbo.fbo01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbo01"
                  LET g_doc.value1 = g_fbo.fbo01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fbp),'','')
            END IF
        #@WHEN "簽核狀況"
        WHEN "approval_status"
             IF cl_chk_act_auth() THEN  #DISPLAY ONLY
                IF aws_condition2() THEN
                   CALL aws_efstat2()
                END IF
             END IF

        ##EasyFlow送簽
        WHEN "easyflow_approval"
             IF cl_chk_act_auth() THEN
                CALL t112_ef()
             END IF

        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有>
                CALL t112_y_upd()      #CALL 原確認的 update 段
             ELSE
                LET g_success = "Y"
                IF NOT aws_efapp_formapproval() THEN
                   LET g_success = "N"
                END IF
             END IF
             IF g_success = 'Y' THEN
                IF cl_confirm('aws-081') THEN
                   IF aws_efapp_getnextforminfo() THEN
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                      IF NOT cl_null(g_argv1) THEN
                         CALL t112_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,    #FUN-D20035 add--undo_void
                                                    confirm, undo_confirm, easyflow_approval, auto_generate, post, undo_post")
                              RETURNING g_laststage
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                ELSE
                   EXIT WHILE
                END IF
             END IF

        #@WHEN "不准"
        WHEN "deny"
            IF ( l_creator := aws_efapp_backflow()) IS NOT NULL THEN
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_fbo.fbo06 = 'R'
                     DISPLAY BY NAME g_fbo.fbo06
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t112_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行>
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,    #FUN-D20035 ADD--undo_void
                                                      confirm, undo_confirm, easyflow_approval, auto_generate, post, undo_post")
                                RETURNING g_laststage
                        ELSE
                           EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
             END IF

        #@WHEN "加簽"
        WHEN "modify_flow"
             IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                LET l_flowuser = 'Y'
             ELSE
                LET l_flowuser = 'N'
             END IF

        #@WHEN "撤簽"
        WHEN "withdraw"
             IF cl_confirm("aws-080") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF

        #@WHEN "抽單"
        WHEN "org_withdraw"
             IF cl_confirm("aws-079") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF

        #@WHEN "簽核意見"
        WHEN "phrase"
             CALL aws_efapp_phrase()
      END CASE
   END WHILE
END FUNCTION

FUNCTION t112_a()
    DEFINE li_result   LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fbp.clear()
    INITIALIZE g_fbo.* TO NULL
    LET g_fbo01_t = NULL
    LET g_fbo_o.* = g_fbo.*
    LET g_fbo_t.* = g_fbo.*

    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fbo.fbo02  =g_today
        LET g_fbo.fbo05  =g_today
        LET g_fbo.fboconf='N'
        LET g_fbo.fbopost='N'
        LET g_fbo.fbouser=g_user
        LET g_fbo.fbooriu = g_user
        LET g_fbo.fboorig = g_grup
        LET g_fbo.fbogrup=g_grup
        LET g_fbo.fbodate=g_today
        LET g_fbo.fbomksg = "N"
        LET g_fbo.fbo06 = "0"
        LET g_fbo.fbolegal = g_legal
        CALL t112_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fbo.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fbo.fbo01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK

        CALL s_auto_assign_no("afa",g_fbo.fbo01,g_fbo.fbo02,"I","fbo_file","fbo01","","","")
             RETURNING li_result,g_fbo.fbo01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbo.fbo01

        INSERT INTO fbo_file VALUES (g_fbo.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fbo_file",g_fbo.fbo01,"",SQLCA.SQLCODE,"","Ins:",1)
           ROLLBACK WORK 
           CONTINUE WHILE
        ELSE
           COMMIT WORK
           CALL cl_flow_notify(g_fbo.fbo01,'I')
        END IF
        LET g_rec_b=0
        LET g_fbo_t.* = g_fbo.*
        LET g_fbo01_t = g_fbo.fbo01
        SELECT fbo01 INTO g_fbo.fbo01
          FROM fbo_file
         WHERE fbo01 = g_fbo.fbo01

        CALL g_fbp.clear()
        CALL t112_g()       #自動產生單身
        CALL t112_b()       
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fbo.fbo01)
        SELECT fahprt,fahconf,fahpost,fahapr
          INTO g_fahprt,g_fahconf,g_fahpost,g_fahapr
        FROM fah_file WHERE fahslip = g_t1

        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"

           CALL t112_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t112_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
        IF g_fbo.fboconf = 'Y' AND g_fahpost = 'Y' THEN
           CALL t112_s('S')
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION t112_u()
   IF s_shut(0) THEN RETURN END IF

    IF g_fbo.fbo01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_fbo.* FROM fbo_file WHERE fbo01 = g_fbo.fbo01
    IF g_fbo.fboconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fbo.fboconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fbo.fbopost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF
    IF g_fbo.fbo06 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fbo01_t = g_fbo.fbo01
    LET g_fbo_o.* = g_fbo.*
    BEGIN WORK

    OPEN t112_cl USING g_fbo.fbo01
    IF STATUS THEN
       CALL cl_err("OPEN t112_cl:", STATUS, 1)
       CLOSE t112_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t112_cl INTO g_fbo.*          # 鎖住將被更改或取消的資料
    IF sqlca.sqlcode THEN
       CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t112_cl ROLLBACK WORK RETURN
    END IF
    CALL t112_show()
    WHILE TRUE
        LET g_fbo01_t = g_fbo.fbo01
        LET g_fbo.fbomodu=g_user
        LET g_fbo.fbodate=g_today
        CALL t112_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_fbo.*=g_fbo_t.*
           CALL t112_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        LET g_fbo.fbo06 = '0'
        IF g_fbo.fbo01 != g_fbo_t.fbo01 THEN
           UPDATE fbp_file SET fbp01=g_fbo.fbo01 WHERE fbp01=g_fbo_t.fbo01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","fbp_file",g_fbo_t.fbo01,"",SQLCA.SQLCODE,"","upd fbp01",1)
              LET g_fbo.*=g_fbo_t.*
              CALL t112_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fbo_file SET * = g_fbo.*
         WHERE fbo01 = g_fbo.fbo01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           CALL cl_err(g_fbo.fbo01,SQLCA.SQLCODE,0)
           CALL cl_err3("upd","fbo_file",g_fbo_t.fbo01,"",SQLCA.SQLCODE,"","",1)
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbo.fbo06
        IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")
        EXIT WHILE
    END WHILE
    CLOSE t112_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbo.fbo01,'U')
END FUNCTION

#處理input
FUNCTION t112_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入
         l_bdate,l_edate LIKE type_file.dat,
         l_n1            LIKE type_file.num5
  DEFINE li_result   LIKE type_file.num5

    CALL cl_set_head_visible("","YES")

    INPUT BY NAME g_fbo.fbooriu,g_fbo.fboorig,
        g_fbo.fbo01,g_fbo.fbo02,g_fbo.fbo03,g_fbo.fbo04,g_fbo.fbo05,
        g_fbo.fboconf,g_fbo.fbopost,
        g_fbo.fbomksg,g_fbo.fbo06,
        g_fbo.fbouser,g_fbo.fbogrup,g_fbo.fbomodu,g_fbo.fbodate,
        g_fbo.fboud01,g_fbo.fboud02,g_fbo.fboud03,g_fbo.fboud04,
        g_fbo.fboud05,g_fbo.fboud06,g_fbo.fboud07,g_fbo.fboud08,
        g_fbo.fboud09,g_fbo.fboud10,g_fbo.fboud11,g_fbo.fboud12,
        g_fbo.fboud13,g_fbo.fboud14,g_fbo.fboud15 
           WITHOUT DEFAULTS

        BEFORE INPUT
           LET g_BEFORE_input_done = FALSE
           CALL t112_set_entry(p_cmd)
           CALL t112_set_no_entry(p_cmd)
           LET g_BEFORE_input_done = TRUE
           CALL cl_set_docno_format("fbo01")

        AFTER FIELD fbo01
           IF NOT cl_null(g_fbo.fbo01) AND (g_fbo.fbo01 != g_fbo_t.fbo01 OR g_fbo_t.fbo01 IS NULL) THEN
              CALL s_check_no("afa",g_fbo.fbo01,g_fbo01_t,"I","fbo_file","fbo01","")
                   RETURNING li_result,g_fbo.fbo01
              DISPLAY BY NAME g_fbo.fbo01
              IF (NOT li_result) THEN
                 NEXT FIELD fbo01
              END IF
              LET g_t1 = s_get_doc_no(g_fbo.fbo01)
              SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
           END IF
          #帶出單據別設定的"簽核否"值,狀況碼預設為0
           SELECT fahapr,'0' INTO g_fbo.fbomksg,g_fbo.fbo06
             FROM fah_file
            WHERE fahslip = g_t1
           IF cl_null(g_fbo.fbomksg) THEN
              LET g_fbo.fbomksg = 'N'
           END IF

           DISPLAY BY NAME g_fbo.fbomksg,g_fbo.fbo06
           LET g_fbo_o.fbo01 = g_fbo.fbo01

        AFTER FIELD fbo02
           IF NOT cl_null(g_fbo.fbo02) THEN
              CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
              IF g_fbo.fbo02 < l_bdate THEN
                 CALL cl_err(g_fbo.fbo02,'afa-130',0)
                 NEXT FIELD fbo02
              END IF
              IF g_faa.faa31 = "Y" THEN
                 CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_faa.faa02c) RETURNING l_flag,l_bdate,l_edate
                 IF g_fbo.fbo02 < l_bdate THEN
                    CALL cl_err(g_fbo.fbo02,'afa-130',0)
                    NEXT FIELD fbo02
                 END IF
                 IF g_fbo.fbo02 <= g_faa.faa092 THEN
                    CALL cl_err('','mfg9999',1)
                    NEXT FIELD fbo02
                 END IF
              END IF
           END IF
           IF NOT cl_null(g_fbo.fbo02) THEN
              IF g_fbo.fbo02 <= g_faa.faa09 THEN
                 CALL cl_err('','mfg9999',1)
                 NEXT FIELD fbo02
              END IF
           END IF

        AFTER FIELD fbo03
            IF NOT cl_null(g_fbo.fbo03) THEN
               CALL t112_fbo03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbo.fbo03,g_errno,0)
                  LET g_fbo.fbo03 = g_fbo_t.fbo03
                  DISPLAY BY NAME g_fbo.fbo03
                  NEXT FIELD fbo03
               END IF
            END IF
            
            LET g_fbo_o.fbo03 = g_fbo.fbo03
            SELECT gen03 INTO g_fbo.fbo04 FROM gen_file
                   WHERE gen01 = g_fbo.fbo03
        AFTER FIELD fbo04
            IF NOT cl_null(g_fbo.fbo04) THEN
               CALL t112_fbo04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbo.fbo04,g_errno,0)
                  LET g_fbo.fbo04 = g_fbo_t.fbo04
                  DISPLAY BY NAME g_fbo.fbo04
                  NEXT FIELD fbo04
               END IF
            END IF
            LET g_fbo_o.fbo04 = g_fbo.fbo04
            
        AFTER FIELD fboud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fboud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF

        AFTER INPUT
           LET g_fbo.fbouser = s_get_data_owner("fbo_file") #FUN-C10039
           LET g_fbo.fbogrup = s_get_data_group("fbo_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION controlp
           CASE
             WHEN INFIELD(fbo01)    #查詢單據性質
                  LET g_t1 = s_get_doc_no(g_fbo.fbo01)
                  CALL q_fah( FALSE, TRUE,g_t1,'I',g_sys) RETURNING g_t1
                  LET g_fbo.fbo01 = g_t1
                  DISPLAY BY NAME g_fbo.fbo01
                  NEXT FIELD fbo01
             WHEN INFIELD(fbo03)    #申請人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_fbo.fbo03
                  CALL cl_create_qry() RETURNING g_fbo.fbo03
                  DISPLAY BY NAME g_fbo.fbo03
                  NEXT FIELD fbo03
             WHEN INFIELD(fbo04)    #申請部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_fbo.fbo04
                  CALL cl_create_qry() RETURNING g_fbo.fbo04
                  DISPLAY BY NAME g_fbo.fbo04
                  NEXT FIELD fbo04
             OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON ACTION CONTROLO                        # 沿用所有欄位
            IF INFIELD(fbo01) THEN
                LET g_fbo.* = g_fbo_t.*
                LET g_fbo.fbo01 = ' '
                LET g_fbo.fboconf = 'N'
                LET g_fbo.fbopost = 'N'
                CALL t112_show()
                NEXT FIELD fbo01
            END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
           CONTINUE INPUT
 
    END INPUT
END FUNCTION

FUNCTION t112_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'a' AND ( NOT g_BEFORE_input_done ) THEN
       CALL cl_set_comp_entry("fbo01",TRUE)
    END IF

END FUNCTION

FUNCTION t112_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fbo01",FALSE)
    END IF

END FUNCTION

FUNCTION t112_fbo03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti

    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_fbo.fbo03
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-034'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
 
FUNCTION t112_fbo04(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,
          l_gem02    LIKE gem_file.gem02,
          l_gemacti  LIKE gem_file.gemacti

   LET g_errno = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file
    WHERE gem01 = g_fbo.fbo04
   CASE
      WHEN sqLCA.SQLCODE = 100 LET g_errno ='afa-038'
                               LET l_gem02 = NULL
                               LET l_gemacti = NULL
      WHEN l_gemacti = 'N'     LET g_errno = '9028'
      OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION

FUNCTION t112_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fbo.* TO NULL
    CALL cl_msg("")

    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t112_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fbo.* TO NULL
       RETURN
    END IF

    CALL cl_msg(" SEARCHING ! ")

    OPEN t112_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF sqlca.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_fbo.* TO NULL
    ELSE
       OPEN t112_count
       FETCH t112_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t112_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")

END FUNCTION
 
FUNCTION t112_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式
    l_abso          LIKE type_file.num10                 #絕對的筆數

    CASE p_flag
        WHEN 'N' FETCH NEXT     t112_cs INTO g_fbo.fbo01
        WHEN 'P' FETCH PREVIOUS t112_cs INTO g_fbo.fbo01
        WHEN 'F' FETCH FIRST    t112_cs INTO g_fbo.fbo01
        WHEN 'L' FETCH LAST     t112_cs INTO g_fbo.fbo01
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
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t112_cs INTO g_fbo.fbo01
            LET mi_no_ask = FALSE
    END CASE

    IF sqlca.sqlcode THEN
        CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)
        INITIALIZE g_fbo.* TO NULL
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
    SELECT * INTO g_fbo.* FROM fbo_file WHERE fbo01 = g_fbo.fbo01
    IF sqlca.sqlcode THEN

       CALL cl_err3("sel","fbo_file",g_fbo.fbo01,"",SQLCA.SQLCODE,"","",1)
       INITIALIZE g_fbo.* TO NULL
       RETURN
    END IF
    LET g_data_owner = g_fbo.fbouser
    LET g_data_group = g_fbo.fbogrup
 
    CALL t112_show()
END FUNCTION

FUNCTION t112_show()
    LET g_fbo_t.* = g_fbo.*                #保存單頭舊值
    DISPLAY BY NAME g_fbo.fbooriu,g_fbo.fboorig,
        g_fbo.fbo01,g_fbo.fbo02,g_fbo.fbo03,g_fbo.fbo04,g_fbo.fbo05,
        g_fbo.fboconf,g_fbo.fbopost,g_fbo.fbomksg,g_fbo.fbo06,
        g_fbo.fbouser,g_fbo.fbogrup,g_fbo.fbomodu,g_fbo.fbodate,
        g_fbo.fboud01,g_fbo.fboud02,g_fbo.fboud03,g_fbo.fboud04,
        g_fbo.fboud05,g_fbo.fboud06,g_fbo.fboud07,g_fbo.fboud08,
        g_fbo.fboud09,g_fbo.fboud10,g_fbo.fboud11,g_fbo.fboud12,
        g_fbo.fboud13,g_fbo.fboud14,g_fbo.fboud15 
    IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")
    CALL t112_fbo03('d')
    CALL t112_fbo04('d')
    CALL t112_b_fill(g_wc2)
END FUNCTION

FUNCTION t112_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1

    IF s_shut(0) THEN RETURN END IF
    IF g_fbo.fbo01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_fbo.* FROM fbo_file WHERE fbo01 = g_fbo.fbo01
    IF g_fbo.fboconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    IF g_fbo.fboconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fbo.fbopost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    IF g_fbo.fbo06 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
    BEGIN WORK

    OPEN t112_cl USING g_fbo.fbo01
    IF STATUS THEN
       CALL cl_err("OPEN t112_cl:", STATUS, 1)
       CLOSE t112_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t112_cl INTO g_fbo.*
    IF sqlca.sqlcode THEN
       CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)
       CLOSE t112_cl ROLLBACK WORK RETURN
    END IF
    CALL t112_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL
        LET g_doc.column1 = "fbo01"
        LET g_doc.value1 = g_fbo.fbo01
        CALL cl_del_doc()
        MESSAGE "Delete fbo,fbp!"
        DELETE FROM fbo_file WHERE fbo01 = g_fbo.fbo01
        IF SQLCA.SQLERRD[3]=0 THEN

           CALL cl_err3("del","fbo_file",g_fbo.fbo01,"",SQLCA.SQLCODE,"","No fbo deleted",1)
        ELSE
           DELETE FROM fbp_file WHERE fbp01 = g_fbo.fbo01  
           CLEAR FORM
           CALL g_fbp.clear()
        END IF
        INITIALIZE g_fbo.* LIKE fbo_file.*
        OPEN t112_count
        FETCH t112_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t112_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t112_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t112_fetch('/')
        END IF

    END IF
    CLOSE t112_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbo.fbo01,'I')
END FUNCTION
 
FUNCTION t112_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT
       l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否
       p_cmd           LIKE type_file.chr1,                 #處理狀態
       l_b2            LIKE type_file.chr1000,
       l_faj06         LIKE faj_file.faj06,
       l_faj100        LIKE faj_file.faj100,
       l_qty           LIKE type_file.num20_6,
       l_allow_insert  LIKE type_file.num5,                #可新增否
       l_allow_delete  LIKE type_file.num5                 #可刪除否

    LET g_action_choice = ""

    IF g_fbo.fbo01 IS NULL THEN RETURN END IF
    IF g_fbo.fboconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_fbo.fboconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbo.fbopost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbo.fbo06 <> '0' THEN
       CALL cl_err('','aap-059',0)
       RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT fbp02,fbp03,fbp031,'',fbp04,fbp05 ",
                       " FROM fbp_file  ",
                       " WHERE fbp01 = ? ",
                       " AND fbp02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t112_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_fbp WITHOUT DEFAULTS FROM s_fbp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK

            OPEN t112_cl USING g_fbo.fbo01
            IF STATUS THEN
               CALL cl_err("OPEN t112_cl:", STATUS, 1)
               CLOSE t112_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t112_cl INTO g_fbo.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t112_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET g_fbp_t.* = g_fbp[l_ac].*  #BACKUP
               LET l_flag = 'Y'

               OPEN t112_bcl USING g_fbo.fbo01,g_fbp_t.fbp02
               IF STATUS THEN
                  CALL cl_err("OPEN t112_bcl:", STATUS, 1)   
                  CLOSE t112_bcl
                  LET l_lock_sw = "Y"
                  ROLLBACK WORK
                  RETURN
               ELSE
                  FETCH t112_bcl INTO g_fbp[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock fbp',SQLCA.sqlcode,0)   
                     LET l_lock_sw = "Y"
                  END IF
               END IF
            ELSE
               LET l_flag = 'N'
            END IF
            
            IF l_ac <= l_n then                   #DISPLAY NEWEST
               CALL t112_fbp031(' ')
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               INITIALIZE g_fbp[l_ac].* TO NULL  #重要欄位空白,無效
               DISPLAY g_fbp[l_ac].* TO s_fbp.*
               CALL g_fbp.deleteElement(l_ac)
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF ((g_fbp[l_ac].fbp03 != g_fbp_t.fbp03
                  OR g_fbp_t.fbp03 IS NULL)
              OR (g_fbp[l_ac].fbp031 != g_fbp_t.fbp031)
                  OR g_fbp_t.fbp031 IS NULL) THEN
              SELECT count(*) INTO l_n FROM fbp_file
               WHERE fbp01  = g_fbo.fbo01
                 AND fbp03  = g_fbp[l_ac].fbp03
                 AND fbp031 = g_fbp[l_ac].fbp031
             IF l_n > 0 THEN
                CALL cl_err('','afa-105',1)
                NEXT FIELD fbp02
                CANCEL INSERT
             END IF
            END IF	
            IF g_fbp[l_ac].fbp03 IS NOT NULL AND g_fbp[l_ac].fbp03 != ' ' THEN
               CALL t112_fbp031('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbp[l_ac].fbp031,g_errno,0)
                  NEXT FIELD fbp02
               END IF
            END IF
            IF g_fbp[l_ac].fbp03 IS NULL OR
               g_fbp[l_ac].fbp031 IS NULL THEN
               INITIALIZE g_fbp[l_ac].* TO NULL
            END IF
            IF cl_null(g_fbp[l_ac].fbp04) THEN
               LET g_fbp[l_ac].fbp04 = ' '
            END IF
            IF cl_null(g_fbp[l_ac].fbp05) THEN
               LET g_fbp[l_ac].fbp05 = ' '
            END IF
            IF cl_null(g_fbp[l_ac].fbp031) THEN
               LET g_fbp[l_ac].fbp031 = ' '
            END IF
            
            INSERT INTO fbp_file(fbp01,fbp02,fbp03,fbp031,fbp04,fbp05,fbplegal)
            VALUES(g_fbo.fbo01,g_fbp[l_ac].fbp02,g_fbp[l_ac].fbp03,
                   g_fbp[l_ac].fbp031,g_fbp[l_ac].fbp04,
                   g_fbp[l_ac].fbp05,g_legal)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN

               CALL cl_err3("ins","fbp_file",g_fbo.fbo01,g_fbp[l_ac].fbp02,SQLCA.SQLCODE,"","ins fbp",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fbp[l_ac].* TO NULL
            LET g_fbp_t.* = g_fbp[l_ac].*             #新輸入資料
            NEXT FIELD fbp02

        BEFORE FIELD fbp02                            #項次
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fbp[l_ac].fbp02 IS NULL OR g_fbp[l_ac].fbp02 = 0 THEN
                  SELECT max(fbp02)+1 INTO g_fbp[l_ac].fbp02
                    FROM fbp_file WHERE fbp01 = g_fbo.fbo01
                  IF g_fbp[l_ac].fbp02 IS NULL THEN
                     LET g_fbp[l_ac].fbp02 = 1
                  END IF
               END IF
            END IF

        AFTER FIELD fbp02                        #check 序號是否重複
            IF NOT cl_null(g_fbp[l_ac].fbp02) THEN
               IF g_fbp[l_ac].fbp02 != g_fbp_t.fbp02 OR
                  g_fbp_t.fbp02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fbp_file
                    WHERE fbp01 = g_fbo.fbo01
                      AND fbp02 = g_fbp[l_ac].fbp02
                   IF l_n > 0 THEN
                       LET g_fbp[l_ac].fbp02 = g_fbp_t.fbp02
                       CALL cl_err('',-239,0)
                       NEXT FIELD fbp02
                   END IF
               END IF
            END IF
            
        AFTER FIELD fbp031
           IF g_fbp[l_ac].fbp031 IS NULL THEN
              LET g_fbp[l_ac].fbp031 = ' '
           END IF
           IF ((g_fbp[l_ac].fbp03 != g_fbp_t.fbp03
                 OR g_fbp_t.fbp03 IS NULL)
              OR (g_fbp[l_ac].fbp031 != g_fbp_t.fbp031)
                   OR g_fbp_t.fbp031 IS NULL) THEN
              SELECT count(*) INTO l_n FROM fbp_file
               WHERE fbp01  = g_fbo.fbo01
                 AND fbp03  = g_fbp[l_ac].fbp03
                 AND fbp031 = g_fbp[l_ac].fbp031
             IF l_n > 0 THEN
                CALL cl_err('','afa-105',1)
                NEXT FIELD fbp03
             END IF
            END IF	
           SELECT COUNT(*) INTO g_cnt FROM fca_file
            WHERE fca03  = g_fbp[l_ac].fbp03
              AND fca031 = g_fbp[l_ac].fbp031
              AND fca15  = 'N'
           IF g_cnt > 0 THEN
              CALL cl_err(g_fbp[l_ac].fbp03,'afa-097',0)
              NEXT FIELD fbp03
           END IF
           CALL t112_fbp031('a')
           IF NOT cl_null(g_errno) THEN
              CALL cl_err(g_fbp[l_ac].fbp031,g_errno,0)
              NEXT FIELD fbp03
           END IF
           LET g_fbp_t.fbp03  = g_fbp[l_ac].fbp03
           LET g_fbp_t.fbp031 = g_fbp[l_ac].fbp031

        BEFORE DELETE                            #是否取消單身
            IF g_fbp_t.fbp02 > 0 AND g_fbp_t.fbp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                     ROLLBACK WORK
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fbp_file
                 WHERE fbp01 = g_fbo.fbo01
                   AND fbp02 = g_fbp_t.fbp02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","fbp_file",g_fbo.fbo01,g_fbp_t.fbp02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fbp[l_ac].* = g_fbp_t.*
               CLOSE t112_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fbp[l_ac].fbp02,-263,1)
               LET g_fbp[l_ac].* = g_fbp_t.*
            ELSE
                IF ((g_fbp[l_ac].fbp03 != g_fbp_t.fbp03
                      OR g_fbp_t.fbp03 IS NULL)
                    OR (g_fbp[l_ac].fbp031 != g_fbp_t.fbp031)
                         OR g_fbp_t.fbp031 IS NULL) THEN
                    SELECT count(*) INTO l_n FROM fbp_file
                     WHERE fbp01  = g_fbo.fbo01
                      AND fbp03  = g_fbp[l_ac].fbp03
                      AND fbp031 = g_fbp[l_ac].fbp031
                    IF l_n > 0 THEN
                        CALL cl_err('','afa-105',1)
                        NEXT FIELD fbp02
                    END IF
                END IF  
               IF g_fbp[l_ac].fbp03 IS NOT NULL AND g_fbp[l_ac].fbp03 != ' ' THEN
                  CALL t112_fbp031('d')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fbp[l_ac].fbp031,g_errno,0)
                     NEXT FIELD fbp02
                  END IF
               END IF
               IF g_fbp[l_ac].fbp03 IS NULL OR
                  g_fbp[l_ac].fbp031 IS NULL THEN
                  INITIALIZE g_fbp[l_ac].* TO NULL
               END IF
               IF cl_null(g_fbp[l_ac].fbp04) THEN
                  LET g_fbp[l_ac].fbp04 = ' '
               END IF
               IF cl_null(g_fbp[l_ac].fbp05) THEN
                  LET g_fbp[l_ac].fbp05 = ' '
               END IF
               UPDATE fbp_file SET
                      fbp01=g_fbo.fbo01,fbp02=g_fbp[l_ac].fbp02,
                      fbp03=g_fbp[l_ac].fbp03,fbp031=g_fbp[l_ac].fbp031,
                      fbp04=g_fbp[l_ac].fbp04,fbp05=g_fbp[l_ac].fbp05
               WHERE fbp01=g_fbo.fbo01 AND fbp02=g_fbp_t.fbp02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("upd","fbp_file",g_fbo.fbo01,g_fbp_t.fbp02,SQLCA.sqlcode,"","upd fbp",1)
                  LET g_fbp[l_ac].* = g_fbp_t.*
                  DISPLAY BY NAME g_fbp[l_ac].*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac     #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fbp[l_ac].* = g_fbp_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_fbp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               CLOSE t112_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE t112_bcl
            COMMIT WORK
            CALL g_fbp.deleteElement(g_rec_b+1)

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fbp02) AND l_ac > 1 THEN
                LET g_fbp[l_ac].* = g_fbp[l_ac-1].*
                LET g_fbp[l_ac].fbp02 = NULL
                NEXT FIELD fbp02
            END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(fbp03)  #財產編號,財產附號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_faj"
                   LET g_qryparam.default1 = g_fbp[l_ac].fbp03
                   LET g_qryparam.default2 = g_fbp[l_ac].fbp031
                   CALL cl_create_qry() RETURNING g_fbp[l_ac].fbp03,g_fbp[l_ac].fbp031
                   IF cl_null(g_fbp[l_ac].fbp031) THEN
                      LET g_fbp[l_ac].fbp031 = ' '
                   END IF                    
                   DISPLAY BY NAME g_fbp[l_ac].fbp03,g_fbp[l_ac].fbp031
                   CALL t112_fbp031('d')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(' ',g_errno,0)
                      NEXT FIELD fbp03
                   END IF
                   NEXT FIELD fbp03
              OTHERWISE   EXIT CASE
           END CASE

        ON ACTION CONTROLF
　         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
  
        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
           CONTINUE INPUT
           
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
 
      END INPUT

      DISPLAY BY NAME g_fbo.fbo06
      IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")
      CALL t112_delHeader()     #CHI-C30002 add

END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t112_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fbo.fbo01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fbo_file ",
                  "  WHERE fbo01 LIKE '",l_slip,"%' ",
                  "    AND fbo01 > '",g_fbo.fbo01,"'"
      PREPARE t112_pb1 FROM l_sql 
      EXECUTE t112_pb1 INTO l_cnt 
      
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
        #CALL t112_x()            #FUN-D20035
         CALL t112_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fbo_file WHERE fbo01 = g_fbo.fbo01
         INITIALIZE g_fbo.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t112_fbp031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,
         l_n         LIKE type_file.num5,
         l_faj06     LIKE faj_file.faj06,
         l_faj93     LIKE faj_file.faj93,
         l_faj43     LIKE faj_file.faj43
DEFINE   l_faj432    LIKE faj_file.faj432

         
    LET g_errno = ' '
      SELECT faj06,faj93,faj43,faj432
        INTO l_faj06,l_faj93,l_faj43,l_faj432
        FROM faj_file
       WHERE faj02  = g_fbp[l_ac].fbp03
         AND faj022 = g_fbp[l_ac].fbp031
         AND fajconf = 'Y'
     CASE
        #WHEN SQLCA.SQLCODE = 100       LET g_errno = 'afa-093'    #MOD-C70265 mark
         WHEN SQLCA.SQLCODE = 100       LET g_errno = 'afa-134'    #MOD-C70265 add
         WHEN l_faj43 MATCHES '[056X]'  LET g_errno = 'afa-093'
         WHEN l_faj432 MATCHES '[056X]' AND g_faa.faa31 ='Y'
              LET g_errno = 'afa-093'
         OTHERWISE                      
         LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF p_cmd = 'a' or p_cmd = 'u'  THEN    #a:輸入 u:更改
         LET g_fbp[l_ac].faj06 = l_faj06
         LET g_fbp[l_ac].fbp04 = l_faj93
         DISPLAY g_fbp[l_ac].faj06 TO faj06
         DISPLAY g_fbp[l_ac].fbp04 TO fbp04
     END IF

     IF cl_null(g_errno) OR p_cmd = 'd' THEN
         LET g_fbp[l_ac].faj06 = l_faj06
         LET g_fbp[l_ac].fbp04 = l_faj93
         DISPLAY g_fbp[l_ac].faj06 TO faj06
         DISPLAY g_fbp[l_ac].fbp04 TO fbp04
     END IF
END FUNCTION

FUNCTION t112_b_fill(p_wc2)
    DEFINE p_wc2    LIKE type_file.chr1000

    LET g_sql =
        " SELECT fbp02,fbp03,fbp031,faj06,fbp04,fbp05 ",
        "  FROM fbp_file, faj_file ",
        "  WHERE fbp01  ='",g_fbo.fbo01,"'",  #單頭
        "    AND fbp03  = faj02",
        "    AND fbp031 = faj022",
        "    AND fajconf='Y'",
        "    AND ",p_wc2 CLIPPED,             #單身
        "  ORDER BY fbp02"

    PREPARE t112_pb FROM g_sql
    DECLARE fbp_curs CURSOR FOR t112_pb       #SCROLL CURSOR

    CALL g_fbp.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fbp_curs INTO g_fbp[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
       END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fbp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t112_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY arraY g_fbp TO s_fbp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      ##########################################################################
      # standard 4ad ACTION
      ##########################################################################
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
         CALL t112_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION previous
         CALL t112_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION jump
         CALL t112_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION next
         CALL t112_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
      ON ACTION last
         CALL t112_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
 
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
         
         IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
      #@ON ACTION 相關文件
       ON ACTION related_document
         LET g_action_choice="related_document"
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
 
      ON ACTION about
         CALL cl_about()
         CONTINUE DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

     ON ACTION easyflow_approval
        LET g_action_choice = 'easyflow_approval'
        EXIT DISPLAY

     ON ACTION approval_status
        LET g_action_choice="approval_status"
        EXIT DISPLAY

     ON ACTION agree
        LET g_action_choice = 'agree'
        EXIT DISPLAY

     ON ACTION deny
        LET g_action_choice = 'deny'
        EXIT DISPLAY

     ON ACTION modify_flow
        LET g_action_choice = 'modify_flow'
        EXIT DISPLAY

     ON ACTION withdraw
        LET g_action_choice = 'withdraw'
        EXIT DISPLAY

     ON ACTION org_withdraw
        LET g_action_choice = 'org_withdraw'
        EXIT DISPLAY

     ON ACTION phrase
        LET g_action_choice = 'phrase'
        EXIT DISPLAY
        
     ON ACTION controls                                        
        CALL cl_set_head_visible("","AUTO")                    

      &include "qry_string.4gl"

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t112_bp_refresh()
   DISPLAY ARRAY g_fbp TO s_fbp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
         CONTINUE DISPLAY
 
   END DISPLAY
END FUNCTION

#---自動產生-------
FUNCTION t112_g()
 DEFINE l_wc        LIKE type_file.chr1000,
        l_sql       LIKE type_file.chr1000,
        tm          RECORD
               a         LIKE fbp_file.fbp05
               END RECORD,
        l_faj       RECORD
               faj02       LIKE faj_file.faj02,
               faj022      LIKE faj_file.faj022,
               faj93       LIKE faj_file.faj93,
               newfaj93    LIKE faj_file.faj93
               END RECORD,
        i           LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF g_fbo.fbo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbo.fboconf='X' THEN CALL cl_err(g_fbo.fbo01,'9024',0) RETURN END IF
   IF g_fbo.fboconf='Y' THEN CALL cl_err(g_fbo.fbo01,'afa-107',0) RETURN END IF
   IF NOT cl_confirm('afa-103') THEN RETURN END IF
   LET INT_FLAG = 0

      LET p_row = 4 LET p_col = 10
      OPEN WINDOW t112_w2 AT p_row,p_col WITH FORM "afa/42f/afat1122"
           ATTRIBUTE (STYLE = g_win_style)

      CALL cl_ui_locale("afat1122")
 
      CONSTRUCT l_wc ON faj01,faj93,faj02,faj022
                   FROM faj01,faj93,faj02,faj022
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
            CONTINUE CONSTRUCT
 
      END CONSTRUCT

      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1)
         LET INT_FLAG = 1
      END IF

      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t112_w2 RETURN END IF

      INPUT BY NAME tm.a

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION controlg
           CALL cl_cmdask()
           CONTINUE INPUT
 
     END INPUT
     IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t112_w2 RETURN END IF
     #------自動產生------
      BEGIN WORK
      LET l_sql ="SELECT faj02,faj022,faj93",
                 "  FROM faj_file",
                 " WHERE faj43 NOT IN ('0','5','6','X')",
                 "   AND  faj432 NOT IN ('0','5','6','X')",
                 "   AND fajconf = 'Y' ",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY faj02"
     PREPARE t112_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        ROLLBACK WORK RETURN
     END IF
     DECLARE t112_curs2 CURSOR FOR t112_prepare_g

     SELECT max(fbp02)+1 INTO i FROM fbp_file WHERE fbp01 = g_fbo.fbo01
     IF cl_null(i) THEN LET i = 1 END IF
     FOREACH t112_curs2 INTO l_faj.*
       IF sqlca.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF

       SELECT COUNT(*) INTO g_cnt FROM fbp_file
        WHERE fbp01 =  g_fbo.fbo01
          AND fbp03  = l_faj.faj02
          AND fbp031 = l_faj.faj022
       IF g_cnt > 0 THEN
          CONTINUE FOREACH
       END IF
       
       IF not cl_null(tm.a) THEN LET l_faj.newfaj93 = tm.a END IF
       IF cl_null(l_faj.faj022) THEN LET l_faj.faj022 = ' ' END IF
       INSERT INTO fbp_file(fbp01,fbp02,fbp03,fbp031,fbp04,fbp05,fbplegal)
                    VALUES (g_fbo.fbo01,i,l_faj.faj02,l_faj.faj022,
                            l_faj.faj93,l_faj.newfaj93,g_legal)
       IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
          CALL cl_err3("ins","fbp_file",g_fbo.fbo01,i,SQLCA.SQLCODE,"","ins fbp",1)
          ROLLBACK WORK
          CLOSE WINDOW t112_w2
          RETURN
       END IF
       LET i = i + 1
     END FOREACH
     CLOSE WINDOW t112_w2
     COMMIT WORK
     CALL t112_b_fill(l_wc)
END FUNCTION

FUNCTION t112_y_chk()       #Action"確認"
  DEFINE l_bdate,l_edate        LIKE type_file.dat
  DEFINE l_flag                 LIKE type_file.chr1
  DEFINE l_cnt                  LIKE type_file.num5

  LET g_success = 'Y'
#CHI-C30107 -------------- add -------------- begin
  IF g_fbo.fboconf='X' THEN     #檢查確認碼="X"
     LET g_success = 'N'
     CALL cl_err('','9024',0)
     RETURN
  END IF
  IF g_fbo.fboconf='Y' THEN     #檢查確認碼="Y"
     LET g_success = 'N'
     CALL cl_err('','9023',0)
     RETURN
  END IF
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
     g_action_choice CLIPPED = "insert"  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
  END IF
#CHI-C30107 -------------- add -------------- end
  SELECT * intO g_fbo.* FROM fbo_file WHERE fbo01 = g_fbo.fbo01
  IF g_fbo.fboconf='X' THEN     #檢查確認碼="X"
     LET g_success = 'N'
     CALL cl_err('','9024',0)
     RETURN
  END IF
  IF g_fbo.fboconf='Y' THEN     #檢查確認碼="Y"
     LET g_success = 'N'
     CALL cl_err('','9023',0)
     RETURN
  END IF

  SELECT count(*) INTO l_cnt FROM fbp_file
   WHERE fbp01= g_fbo.fbo01
  IF l_cnt = 0 THEN             #單身無資料
     LET g_success = 'N'
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
   #此單據日期不介於現行年月
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
       
   LET g_bookno2 = g_faa.faa02c
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   
  IF g_fbo.fbo02 < l_bdate THEN
     LET g_success = 'N'
     CALL cl_err(g_fbo.fbo02,'afa-308',0)
     RETURN
  END IF
  #-->立帳日期小於關帳日期
  IF g_fbo.fbo02 < g_faa.faa09 THEN
     LET g_success = 'N'
     CALL cl_err(g_fbo.fbo01,'aap-176',1)
     RETURN
  END IF

  IF g_faa.faa31 = 'Y' THEN
     CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
     IF g_fbo.fbo02 < l_bdate THEN
        LET g_success = 'N'
        CALL cl_err(g_fbo.fbo02,'afa-308',0)
        RETURN
     END IF
     #-->立帳日期小於關帳日期
     IF g_fbo.fbo02 < g_faa.faa092 THEN
        LET g_success = 'N'  
        CALL cl_err(g_fbo.fbo01,'aap-176',1)
        RETURN
     END IF
  END IF
  
  IF g_success = 'N' THEN RETURN END IF

END FUNCTION

FUNCTION t112_y_upd()

  LET g_success = 'Y'
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
     g_action_choice CLIPPED = "insert"  THEN
     IF g_fbo.fbomksg='Y'   THEN
        IF g_fbo.fbo06 != '1' THEN
           CALL cl_err('','aws-078',1)  #此狀況碼不為「1.已核准」，不可確認!!
           LET g_success = 'N'
           RETURN
        END IF
     END IF
#    IF NOT cl_confirm('axm-108') THEN RETURN END IF    #確認此張單據? #CHI-C30107 mark
  END IF

  BEGIN WORK
  LET g_success = 'Y'

  OPEN t112_cl USING g_fbo.fbo01
  IF STATUS thEN
     CALL cl_err("OPEN t112_cl:", STATUS, 1)
     CLOSE t112_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t112_cl INTO g_fbo.*          # 鎖住將被更改或取消的資料
  IF SQLCA.SQLCODE THEN
     CALL cl_err(g_fbo.fbo01,SQLCA.SQLCODE,0)     # 資料被他人LOCK
     CLOSE t112_cl ROLLBACK WORK RETURN
  END IF
  LET g_success = 'Y'
  UPDATE fbo_file SET fboconf = 'Y' WHERE fbo01 = g_fbo.fbo01
  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN

     CALL cl_err3("upd","fbo_file",g_fbo.fbo01,"",SQLCA.SQLCODE,"","upd fboconf",1)
     LET g_success = 'N'
  END IF
 
  IF g_success = 'Y' THEN
     IF g_fbo.fbomksg = 'Y' THEN #簽核模式
        CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
                 LET g_fbo.fboconf="N"
                 LET g_success = "N"
                 ROLLBACK WORK
                 RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                 LET g_fbo.fboconf="N"
                 ROLLBACK WORK
                 RETURN
        END CASE
     END IF
 
     CLOSE t112_cl
     IF g_success = 'Y' THEN
        
        LET g_fbo.fbo06='1'         #執行成功, 狀態值顯示為 '1' 已核准
        UPDATE fbo_file SET fbo06 = g_fbo.fbo06 WHERE fbo01=g_fbo.fbo01
        IF SQLCA.sqlerrd[3]=0 THEN
           LET g_success='N'
        END IF
        
        LET g_fbo.fboconf='Y'       #執行成功, 確認碼顯示為 'Y' 已確認
        COMMIT WORK
        DISPLAY BY NAME g_fbo.fboconf
        DISPLAY BY NAME g_fbo.fbo06
        CALL cl_flow_notify(g_fbo.fbo01,'Y')
     ELSE
        LET g_fbo.fboconf='N'
        LET g_success = 'N'
        ROLLBACK WORK
     END IF
 
  ELSE
     LET g_fbo.fboconf='N'
     LET g_success = 'N'
     ROLLBACK WORK
  END IF
 

  IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF

  IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
 
  CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")


END FUNCTION

FUNCTION t112_ef()

  CALL t112_y_chk()      #CALL 原確認的 check 段
  IF g_success = "N" THEN
     RETURN
  END IF

  CALL aws_condition()   #判斷送簽資料
  IF g_success = 'N' THEN
     RETURN
  END IF

######################################
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
######################################

  IF aws_efcli2(base.TypeInfo.create(g_fbo),base.TypeInfo.create(g_fbp),'','','','')
  THEN
     LET g_success='Y'
     LET g_fbo.fbo06='S'
     DISPLAY BY NAME g_fbo.fbo06
  ELSE
     LET g_success='N'
  END IF
END FUNCTION

#Action"取消確認" 
FUNCTION t112_z()       
 DEFINE l_bdate,l_edate   LIKE type_file.dat,
        l_fbo02           LIKE fbo_file.fbo02

   SELECT * INTO g_fbo.* FROM fbo_file WHERE fbo01 = g_fbo.fbo01
   IF g_fbo.fbo06  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF
   IF g_fbo.fboconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_fbo.fboconf='N' THEN RETURN END IF
   IF g_fbo.fbopost='Y' THEN
      CALL cl_err('fbopost=Y:','afa-101',0)
      RETURN
   END IF
   #此單據日期不介於現行年月
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
       
   LET g_bookno2 = g_faa.faa02c
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate

   IF g_fbo.fbo02 < l_bdate THEN
      CALL cl_err(g_fbo.fbo02,'afa-308',0)
      RETURN
   END IF
   #-->立帳日期不可小於關帳日期
   IF g_fbo.fbo02 < g_faa.faa09 THEN
      CALL cl_err(g_fbo.fbo01,'aap-176',1) RETURN
   END IF

   IF g_faa.faa31 = 'Y' THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbo.fbo02 < l_bdate THEN
         CALL cl_err(g_fbo.fbo02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbo.fbo02 < g_faa.faa092 THEN
         CALL cl_err(g_fbo.fbo01,'aap-176',1) RETURN
      END IF
   END IF
   
   IF NOT cl_confirm('axm-109') THEN RETURN END IF      #是否確定取消確認(Y/N)?
   BEGIN WORK

    OPEN t112_cl USING g_fbo.fbo01
    IF STATUS THEN
       CALL cl_err("OPEN t112_cl:", STATUS, 1)
       CLOSE t112_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t112_cl INTO g_fbo.*          # 鎖住將被更改或取消的資料
    IF sqlca.sqlcode THEN
        CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t112_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'

   UPDATE fbo_file SET fboconf = 'N',fbo06 ='0'
    WHERE fbo01 = g_fbo.fbo01
   IF sqlca.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN LET g_success = 'N' END IF
   CLOSE t112_cl
   IF g_success = 'Y' THEN
      LET g_fbo.fboconf='N'
      LET g_fbo.fbo06='0'
      COMMIT WORK
      DISPLAY bY NAME g_fbo.fboconf
      DISPLAY BY NAME g_fbo.fbo06
   ELSE
      LET g_fbo.fboconf='Y'
      ROLLBACK WORK
   END IF
   IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")
END FUNCTION

#----過帳--------
FUNCTION t112_s(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,
          l_fbp       RECORD LIKE fbp_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_yy        LIKE type_file.chr4,
          l_mm        LIKE type_file.chr2,
          l_cnt       LIKE type_file.num5,
          l_bdate,l_edate     LIKE type_file.dat,
          l_flag      LIKE type_file.chr1,
          l_fbo02     LIKE fbo_file.fbo02,
          l_msg       LIKE type_file.chr1000

   IF s_shut(0) THEN RETURN END IF
   IF g_fbo.fbo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF     #請先選取欲處理的資料！
   SELECT * INTO g_fbo.* FROM fbo_file WHERE fbo01 = g_fbo.fbo01
   IF g_fbo.fboconf != 'Y' OR g_fbo.fbopost != 'N' THEN
      CALL cl_err(g_fbo.fbo01,'afa-100',0)      #未確認或已過帳資料不可過帳!
      RETURN
   END IF
  
   #-->立帳日期小於關帳日期
   IF g_fbo.fbo02 < g_faa.faa09 THEN
      CALL cl_err(g_fbo.fbo01,'aap-176',1) RETURN
   END IF
   #此單據日期不介於現行年月
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
       
   LET g_bookno2 = g_faa.faa02c 
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate

   IF g_fbo.fbo02 < l_bdate OR g_fbo.fbo02 > l_edate THEN
      CALL cl_err(g_fbo.fbo02,'afa-308',0)
      RETURN
   END IF

   IF g_faa.faa31 = 'Y' THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbo.fbo02 < l_bdate THEN
         CALL cl_err(g_fbo.fbo02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbo.fbo02 < g_faa.faa092 THEN
         CALL cl_err(g_fbo.fbo01,'aap-176',1) RETURN
      END IF
   END IF
   
   IF NOT cl_sure(18,20) THEN RETURN END IF     #是否確定要過帳
   BEGIN WORK

   OPEN t112_cl USING g_fbo.fbo01
   IF STATUS THEN
      CALL cl_err("OPEN t112_cl:", STATUS, 1)
      CLOSE t112_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t112_cl INTO g_fbo.*          # 鎖住將被更改或取消的資料
   IF sqlca.sqlcode THEN
      CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t112_cl ROLLBACK WORK RETURN
   END IF
   LET g_success = 'Y'
   #--------- 過帳(2)insert fap_file
   DECLARE t112_cur2 CURSOR FOR
      SELECT * FROM fbp_file WHERE fbp01=g_fbo.fbo01
   CALL s_showmsg_init()
   FOREACH t112_cur2 INTO l_fbp.*
                                                                                                      
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        

      IF sqlca.sqlcode != 0 THEN

         CALL s_errmsg('fbp01',g_fbo.fbo01,'foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02 =l_fbp.fbp03
                                            AND faj022=l_fbp.fbp031
      IF status THEN

         LET g_showmsg = l_fbp.fbp03,"/",l_fbp.fbp031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)
         LET g_success = 'N'
      END IF
      #-->免稅資料
      IF l_faj.faj40 = '3' AND p_cmd = 'S' THEN
         LET l_msg = l_faj.faj02,' ',l_faj.faj022 clipped
         CALL s_errmsg('','',l_msg,'afa-305',1)
         LET g_success = 'N'

         CONTINUE FOREACH
      END IF
      #-->判斷輸入日期之前是否有未過帳
      SELECT COUNT(*) INTO l_cnt FROM fbp_file,fbo_file
       WHERE fbp01 = fbo01
         AND fbp03 = l_fbp.fbp03
         AND fbp031= l_fbp.fbp031
         AND fbo02 <= l_fbo02
         AND fbopost = 'N'
         AND fbo01 != g_fbo.fbo01
         AND fboconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbp.fbp01,' ',l_fbp.fbp02,' ',
                     l_fbp.fbp03,' ',l_fbp.fbp031

         CALL s_errmsg('','',l_msg,'afa-309',1)
         LET g_success = 'N'

         CONTINUE FOREACH
      END IF

      IF cl_null(l_fbp.fbp031) THEN
         LET l_fbp.fbp031 = ' '
      END IF

     #CHI-C60010---str---
      SELECT aaa03 INTO g_faj143 FROM aaa_file
       WHERE aaa01 = g_faa.faa02c
      IF NOT cl_null(g_faj143) THEN
         SELECT azi04 INTO g_azi04_1 FROM azi_file
          WHERE azi01 = g_faj143
      END IF
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj3312,g_azi04_1) RETURNING l_faj.faj3312
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
     #CHI-C60010---end---
      INSERT INTO fap_file (fap01,fap02,fap021,fap03,
                            fap04,fap05,fap06,fap07,
                            fap08,fap09,fap10,fap101,
                            fap11,fap12,fap13,fap14,
                            fap15,fap16,fap17,fap18,
                            fap19,fap20,fap201,fap21,
                            fap22,fap23,fap24,fap25,
                            fap26,fap30,fap31,fap32,
                            fap33,fap34,fap341,fap35,
                            fap36,fap37,fap38,fap39,
                            fap40,fap41,fap50,fap501,
                            fap58,fap59,fap60,fap61,
                            fap62,fap27,fap81,fap77,
                            fap052,fap062,fap072,fap082,
                            fap092,fap103,fap1012,fap112,
                            fap152,fap162,fap212,fap222,
                            fap232,fap242,fap252,fap262,
                            fap772,fap56,faplegal)
      VALUES (l_faj.faj01,l_fbp.fbp03,l_fbp.fbp031,'I',
              g_fbo.fbo02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
              l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33,
              l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
              l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
              l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
              l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
              l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
              l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
              l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
              l_faj.faj73,l_faj.faj100,l_fbp.fbp01,l_fbp.fbp02,
              l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj23,
              l_faj.faj24,l_fbp.fbp04,l_fbp.fbp05,l_faj.faj43,
              l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
              l_faj.faj142,l_faj.faj1412,l_faj.faj332+l_faj.faj3312,l_faj.faj322,
              l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
              l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,
              l_faj.faj432,0,g_legal)              

      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbp.fbp03,"/",l_fbp.fbp031,"/",'I',"/",g_fbo.fbo02
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)
         LET g_success = 'N'
      END IF
      
      #--------- 過帳(3)update faj_file
      UPDATE faj_file SET faj93  = l_fbp.fbp05 #變更後族群編號
       WHERE faj02=l_fbp.fbp03 AND faj022=l_fbp.fbp031
       
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbp.fbp03,"/",l_fbp.fbp031
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
         LET g_success = 'N'
      END IF
      
   END FOREACH
   
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          

   CLOSE t112_cl
   IF g_success = 'Y' THEN
      #--------- 過帳(1)update fbopost
      UPDATE fbo_file SET fbopost = 'Y' WHERE fbo01 = g_fbo.fbo01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('fbo01',g_fbo.fbo01,'upd fbopost',STATUS,1)
         LET g_fbo.fbopost='N'
         LET g_success = 'N'
      ELSE
         LET g_fbo.fbopost='Y'
         LET g_success = 'Y'
      END IF
   END IF
   CALL s_showmsg()
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
      CALL cl_flow_notify(g_fbo.fbo01,'S')
   END IF
   DISPLAY BY NAME g_fbo.fbopost
   IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")
END FUNCTION

#----過帳還原--------
FUNCTION t112_w()
   DEFINE l_fbp    RECORD LIKE fbp_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_fap17  LIKE fap_file.fap17,
          l_fap18  LIKE fap_file.fap18,
          l_fap19  LIKE fap_file.fap19,
          l_fap41  LIKE fap_file.fap41,
          l_fbo02  LIKE fbo_file.fbo02,
          l_faf03  LIKE faf_file.faf03,
          l_cnt             LIKE type_file.num5,
          l_msg             LIKE type_file.chr1000,
          l_bdate,l_edate   LIKE type_file.dat

   IF s_shut(0) THEN RETURN END IF
   IF g_fbo.fbo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF     #請先選取欲處理的資料！

   SELECT * INTO g_fbo.* FROM fbo_file WHERE fbo01 = g_fbo.fbo01
   #-->立帳日期小於關帳日期
   IF g_fbo.fbo02 < g_faa.faa09 THEN
      CALL cl_err(g_fbo.fbo01,'aap-176',1) RETURN
   END IF
   
   #--->折舊年月判斷必須為當月
   SELECT fbo02 INTO l_fbo02 FROM fbo_file WHERE fbo01 = g_fbo.fbo01
   IF sqlca.sqlcode THEN LET l_fbo02 = ' '  RETURN END IF
   CALL s_get_bookno(g_faa.faa07)   
       RETURNING g_flag,g_bookno1,g_bookno2
       
   LET g_bookno2 = g_faa.faa02c       
      CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate

   IF g_fbo.fbo02 < l_bdate OR g_fbo.fbo02 > l_edate THEN
      CALL cl_err(g_fbo.fbo02,'afa-339',0)
      RETURN
   END IF
   
   IF g_faa.faa31 = 'Y' THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno2) RETURNING l_flag,l_bdate,l_edate
      IF g_fbo.fbo02 < l_bdate THEN
         CALL cl_err(g_fbo.fbo02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbo.fbo02 < g_faa.faa092 THEN
         CALL cl_err(g_fbo.fbo01,'aap-176',1) RETURN
      END IF
   END IF
   
   IF g_fbo.fbopost != 'Y' THEN     
      CALL cl_err(g_fbo.fbo01,'afa-108',0)      #未過帳資料不可過帳還原!
      RETURN
   END IF
   
   IF NOT cl_sure(18,20) THEN RETURN END IF     #是否確定要過帳
   BEGIN WORK

   OPEN t112_cl USING g_fbo.fbo01
   IF STATUS THEN
      CALL cl_err("OPEN t112_cl:", STATUS, 1)
      CLOSE t112_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t112_cl INTO g_fbo.*          # 鎖住將被更改或取消的資料
   IF sqlca.sqlcode THEN
      CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t112_cl ROLLBACK WORK RETURN
   END IF

   LET g_success = 'Y'
   #--------- 還原過帳(2)update faj_file
   DECLARE t112_cur3 CURSOR FOR
      SELECT * FROM fbp_file WHERE fbp01=g_fbo.fbo01
   CALL s_showmsg_init()
   FOREACH t112_cur3 INTO l_fbp.*                                                                                                             
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
      IF sqlca.sqlcode != 0 THEN
         CALL s_errmsg('fbp01',g_fbo.fbo01,'foreach:',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      #-->判斷輸入日期之前是否有已過帳
      SELECT COUNT(*) INTO l_cnt FROM fbp_file,fbo_file
       WHERE fbp01  = fbo01
         AND fbp03  = l_fbp.fbp03
         AND fbp031 = l_fbp.fbp031
         AND fbo02 >= l_fbo02
         AND fbopost= 'Y'
         AND fbo01 != g_fbo.fbo01
      IF l_cnt  > 0 THEN
         LET l_msg = l_fbp.fbp01,' ',l_fbp.fbp02,' ',
                     l_fbp.fbp03,' ',l_fbp.fbp031
         CALL s_errmsg('','',l_msg,'afa-310',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      IF cl_null(l_fbp.fbp031) THEN
        LET l_fbp.fbp031 = ' '
      END IF
      
      #--> 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fbp.fbp03
                                            AND faj022=l_fbp.fbp031
      IF status THEN
         LET g_showmsg = l_fbp.fbp03,"/",l_fbp.fbp031
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)
         RETURN
         CONTINUE FOREACH
      END IF
      #----- 找出 fap_file 之 fap05 以便 update faj_file.faj43
      SELECT fap17,fap18,fap19,fap41
        INTO l_fap17,l_fap18,l_fap19,l_fap41
        FROM fap_file
       WHERE fap50=l_fbp.fbp01 AND fap501=l_fbp.fbp02 AND fap03='I'
      IF STATUS THEN
         LET g_showmsg = l_fbp.fbp02,"/",'I'
         CALL s_errmsg('fap501,fap03',g_showmsg,'sel fap',STATUS,1)
         LET g_success = 'N'
      END IF
      
      UPDATE faj_file SET faj93  = l_fbp.fbp04 #變更後族群編號
       WHERE faj02=l_fbp.fbp03 AND faj022=l_fbp.fbp031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbp.fbp03,"/",l_fbp.fbp031
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
         LET g_success = 'N'
      END IF
      
      #--------- 還原過帳(3)delete fap_file
      DELETE FROM fap_file WHERE fap50=l_fbp.fbp01 AND fap501= l_fbp.fbp02
                             AND fap03 = 'I'
      IF status OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fbp.fbp01,"/",l_fbp.fbp02,"/",'I'
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)
         LET g_success = 'N'
      END IF
   END FOREACH

   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          


   #--------- 還原過帳(1)update fbo_file
   IF g_success = 'Y' THEN
      UPDATE fbo_file SET fbopost = 'N' WHERE fbo01 = g_fbo.fbo01
         IF staTUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('fbo01',g_fbo.fbo01,'upd fbopost',STATUS,1)
            LET g_fbo.fbopost='Y'
            LET g_success = 'N'
         ELSE
            LET g_fbo.fbopost='N'
            LET g_success = 'Y'
         END IF
   END IF
   CLOSE t112_cl
   CALL s_showmsg()
   IF g_success = 'N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
   DISPLAY by nAME g_fbo.fbopost
   IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF

   IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF

   CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")
END FUNCTION

#Action"作廢"
#FUNCTION t112_x()                       #FUN-D20035
FUNCTION t112_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fbo.* FROM fbo_file WHERE fbo01=g_fbo.fbo01
   IF g_fbo.fbo06 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF

   IF g_fbo.fbo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbo.fboconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   #作废操作
   IF p_type = 1 THEN
      IF g_fbo.fboconf ='X' THEN RETURN END IF
   ELSE
   #取消作废
      IF g_fbo.fboconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'

   OPEN t112_cl USING g_fbo.fbo01
   IF status THEN
      CALL cl_err("OPEN t112_cl:", STATUS, 1)
      CLOSE t112_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t112_cl INTO g_fbo.*          #鎖住將被更改或取消的資料
   IF sqlca.sqlcode THEN
      CALL cl_err(g_fbo.fbo01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t112_cl ROLLBACK WORK RETURN
   END IF
   
  #-->作廢轉換
 #IF cl_void(0,0,g_fbo.fboconf)   THEN         
  IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
  IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
     LET g_chr=g_fbo.fboconf
    #IF g_fbo.fboconf ='N' THEN                                      #FUN-D20035
     IF p_type = 1 THEN                                              #FUN-D20035
        LET g_fbo.fboconf='X'
        LET g_fbo.fbo06 = '9'
     ELSE
        LET g_fbo.fboconf='N'
        LET g_fbo.fbo06 = '0'
     END IF
 
     UPDATE fbo_file SET fboconf =g_fbo.fboconf,
                         fbo06   =g_fbo.fbo06,
                         fbomodu =g_user,
                         fbodate =TODAY
                   WHERE fbo01 = g_fbo.fbo01
     IF status THEN 
        CALL cl_err3("upd","fbo_file",g_fbo.fbo01,"",SQLCA.SQLCODE,"","upd fboconf:",1)
        LET g_success='N' 
     END IF
     IF g_success='Y' THEN
        COMMIT WORK
        IF g_fbo.fboconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbo.fbo06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbo.fboconf,g_chr2,g_fbo.fbopost,"",g_chr,"")
        CALL cl_flow_notify(g_fbo.fbo01,'I')
     ELSE
        ROLLBACK WORK
     END IF
     SELECT fboconf,fbo06 INTO g_fbo.fboconf,g_fbo.fbo06
       FROM fbo_file
      WHERE fbo01 = g_fbo.fbo01
     DISPLAY BY NAME g_fbo.fboconf
     DISPLAY BY NAME g_fbo.fbo06
  END IF
END FUNCTION

#列印報表
FUNCTION t112_out()
   DEFINE l_cmd         LIKE type_file.chr1000,      
          l_wc,l_wc2    LIKE type_file.chr50,        
          l_prtway      LIKE type_file.chr1        

      CALL cl_wait()
      LET l_wc='fbo01="',g_fbo.fbo01,'"'
     # SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar112' #FUN-C30085 mark
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag112' #FUN-C30085 add
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
         LET l_wc2 = " '3' '3' "   
      END IF
     # LET l_cmd = "afar112", #FUN-C30085 mark
      LET l_cmd = "afag112", #FUN-C30085 add
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                   " '",l_wc CLIPPED,"' ",l_wc2
      CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
#FUN-B70092

