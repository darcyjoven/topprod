# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: afat114.4gl
# Descriptions...: 固定資產類別異動維護作業
# Date & Author..: 12/01/12 FUN-BC0035 By Sakura

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3判斷的程式，將財二部份拆分出來使用fahdmy32處理
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C50255 12/06/05 By Polly 增加控卡維護拋轉總帳單別
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:TQC-C70106 12/07/17 By lujh 刪除段 npq00 應為 14
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds


GLOBALS "../../config/top.global"

DEFINE
    g_fbx   RECORD LIKE fbx_file.*,
    g_fbx_t RECORD LIKE fbx_file.*,
    g_fbx_o RECORD LIKE fbx_file.*,
    g_fahprt        LIKE fah_file.fahprt,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,
    g_fby           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    fby02     LIKE fby_file.fby02,
                    fby03     LIKE fby_file.fby03,
                    fby031    LIKE fby_file.fby031,
                    faj06     LIKE faj_file.faj06,
                    fby04     LIKE fby_file.fby04,
                    fby05     LIKE fby_file.fby05,
                    fby06     LIKE fby_file.fby06,
                    fby07     LIKE fby_file.fby07,
                    fby08     LIKE fby_file.fby08,
                    fby09     LIKE fby_file.fby09,
                    fby10     LIKE fby_file.fby10,
                    fby11     LIKE fby_file.fby11
                    END RECORD,
    g_fby_t         RECORD
                    fby02     LIKE fby_file.fby02,
                    fby03     LIKE fby_file.fby03,
                    fby031    LIKE fby_file.fby031,
                    faj06     LIKE faj_file.faj06,
                    fby04     LIKE fby_file.fby04,
                    fby05     LIKE fby_file.fby05,
                    fby06     LIKE fby_file.fby06,
                    fby07     LIKE fby_file.fby07,
                    fby08     LIKE fby_file.fby08,
                    fby09     LIKE fby_file.fby09,
                    fby10     LIKE fby_file.fby10,
                    fby11     LIKE fby_file.fby11
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fbx01_t       LIKE fbx_file.fbx01,
    g_wc,g_wc2,g_sql    STRING,
    l_flag              LIKE type_file.chr1,
    g_t1                LIKE type_file.chr5,
    g_rec_b             LIKE type_file.num5,   #單身筆數
    l_ac                LIKE type_file.num5    #目前處理的ARRAY CNT
DEFINE   g_argv1        LIKE fbx_file.fbx01    #異動單號
DEFINE   g_argv2        STRING                 # 指定執行功能:query or inser
DEFINE   g_laststage    LIKE type_file.chr1
DEFINE   g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL
DEFINE   g_chr          LIKE type_file.chr1
DEFINE   g_chr2         LIKE type_file.chr1
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_str          STRING
DEFINE   g_wc_gl        STRING
DEFINE   g_before_input_done LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   g_bookno1      LIKE aza_file.aza81
DEFINE   g_bookno2      LIKE aza_file.aza82
DEFINE   g_flag         LIKE type_file.chr1
DEFINE   g_fby2     DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
                    fby02     LIKE fby_file.fby02,
                    fby03     LIKE fby_file.fby03,
                    fby031    LIKE fby_file.fby031,
                    faj06     LIKE faj_file.faj06,
                    fby04     LIKE fby_file.fby04,
                    fby052    LIKE fby_file.fby052,
                    fby062    LIKE fby_file.fby062,
                    fby072    LIKE fby_file.fby072,   
                    fby08     LIKE fby_file.fby08,  
                    fby092    LIKE fby_file.fby092,
                    fby102    LIKE fby_file.fby102,
                    fby112    LIKE fby_file.fby112  
                    END RECORD,
    g_fby2_t        RECORD
                    fby02     LIKE fby_file.fby02,
                    fby03     LIKE fby_file.fby03,
                    fby031    LIKE fby_file.fby031,
                    faj06     LIKE faj_file.faj06,
                    fby04     LIKE fby_file.fby04,
                    fby052    LIKE fby_file.fby052,
                    fby062    LIKE fby_file.fby062,
                    fby072    LIKE fby_file.fby072,   
                    fby08     LIKE fby_file.fby08,  
                    fby092    LIKE fby_file.fby092,
                    fby102    LIKE fby_file.fby102,
                    fby112    LIKE fby_file.fby112   
                    END RECORD

MAIN
DEFINE l_sql        STRING
DEFINE p_row,p_col  LIKE type_file.num5

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

    LET g_forupd_sql = "SELECT * FROM fbx_file WHERE fbx01 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t114_cl CURSOR FROM g_forupd_sql

    LET g_wc2 = ' 1=1'
       CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)
        RETURNING g_time

    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2)

    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       LET p_row = 3 LET p_col = 7
       OPEN WINDOW t114_w AT p_row,p_col              #顯示畫面
             WITH FORM "afa/42f/afat114"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)

       CALL cl_ui_init()

       IF g_faa.faa31 = 'Y' THEN  
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",TRUE)
          CALL cl_set_comp_visible("fbx072,fbx082",TRUE)
       ELSE
          CALL cl_set_act_visible("fin_audit2,entry_sheet2",FALSE)
          CALL cl_set_comp_visible("fbx072,fbx082",FALSE)
       END IF
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
               CALL t114_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t114_a()
            END IF
         WHEN "efconfirm"
            CALL t114_q()
            CALL t114_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t114_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
            CALL t114_q()
      END CASE
   END IF

    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void, undo_void,       #FUN-D20035 add--undo_void
                               confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                               gen_entry, post, undo_post,carry_voucher,undo_carry_voucher")
         RETURNING g_laststage
    CALL t114_menu()
    CLOSE WINDOW t114_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)
         RETURNING g_time
END MAIN

FUNCTION t114_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

    CLEAR FORM                             #清除畫面
    CALL g_fby.clear()
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " fbx01 = '",g_argv1,"'"
       LET g_wc2 = " 1=1"
    ELSE
      CALL cl_set_head_visible("","YES")
   INITIALIZE g_fbx.* TO NULL

      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
         fbx01,fbx02,fbx03,fbx04,fbx05,fbx07,fbx08,fbx072,fbx082,
         fbxconf,fbxpost,fbxmksg,fbx06,
         fbxuser,fbxgrup,fbxmodu,fbxdate,
         fbxud01,fbxud02,fbxud03,fbxud04,fbxud05,
         fbxud06,fbxud07,fbxud08,fbxud09,fbxud10,
         fbxud11,fbxud12,fbxud13,fbxud14,fbxud15
         BEFORE CONSTRUCT
         CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(fbx01)    #查詢單據性質
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_fbx"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbx01
                  NEXT FIELD fbx01
               WHEN INFIELD(fbx03)    #申請人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbx03
                  NEXT FIELD fbx03
               WHEN INFIELD(fbx04)    #申請部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fbx04
                  NEXT FIELD fbx04
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
      IF INT_FLAG THEN RETURN END IF

      CONSTRUCT g_wc2 ON fby02,fby03,fby031,faj06,fby04,fby05,fby06,fby07,fby08,
                         fby09,fby10,fby11
              FROM s_fby[1].fby02, s_fby[1].fby03, s_fby[1].fby031, s_fby[1].faj06,
                   s_fby[1].fby04, s_fby[1].fby05, s_fby[1].fby06,
                   s_fby[1].fby07, s_fby[1].fby08,
                   s_fby[1].fby09,s_fby[1].fby10, s_fby[1].fby11

      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION controlp
            CASE
               WHEN INFIELD(fby03)  #財產編號,財產附號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_faj"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = "faj02 = fby03 AND faj022 = fby031 "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fby03
                  NEXT FIELD fby03
               WHEN INFIELD(fby08)  #異動後資產類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fab"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fby08
                  NEXT FIELD fby08                  
               WHEN INFIELD(fby09)  #異動後資產科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fby09
                  NEXT FIELD fby09
               WHEN INFIELD(fby10)  #異動後累折科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fby10
                  NEXT FIELD fby10                 
               WHEN INFIELD(fby11)  #異動後折舊科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.arg1 = g_aza.aza81
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO fby11
                  NEXT FIELD fby11
               OTHERWISE
                  EXIT CASE
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
      
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF

   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fbxuser', 'fbxgrup')


   IF g_wc2 = " 1=1" THEN        # 若單身未輸入條件
      LET g_sql = "SELECT fbx01 FROM fbx_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY fbx01"
   ELSE                          # 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT fbx01 ",
                  "  FROM fbx_file, fby_file",
                  " WHERE fbx01 = fby01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY fbx01"
   END IF

   PREPARE t114_prepare FROM g_sql
   DECLARE t114_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t114_prepare

   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fbx_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT fbx01) FROM fbx_file,fby_file",
                 " WHERE fby01 = fbx01 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t114_count_pre FROM g_sql
   DECLARE t114_count CURSOR FOR t114_count_pre
END FUNCTION

FUNCTION t114_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員

   LET l_flowuser = "N"

   WHILE TRUE
      CALL t114_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t114_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t114_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t114_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t114_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t114_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t114_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate" #自動產生
            IF cl_chk_act_auth() THEN
               CALL t114_g()
            END IF
         WHEN "fin_audit2"   #財簽二
            IF cl_chk_act_auth() THEN
               CALL t114_fin_audit2()
            END IF
         WHEN "entry_sheet"  #分錄底稿
            IF cl_chk_act_auth() AND not cl_null(g_fbx.fbx01) THEN
               CALL s_fsgl('FA',14,g_fbx.fbx01,0,g_faa.faa02b,1,g_fbx.fbxconf,'0',g_faa.faa02p)
               CALL t114_npp02('0')
            END IF
         WHEN "entry_sheet2"  #分錄底稿(財簽二)
            IF cl_chk_act_auth() AND not cl_null(g_fbx.fbx01) THEN
               CALL s_fsgl('FA',14,g_fbx.fbx01,0,g_faa.faa02c,1,g_fbx.fbxconf,'1',g_faa.faa02p)
               CALL t114_npp02('1')
            END IF
         WHEN "gen_entry"   #會計分錄產生
            IF cl_chk_act_auth() AND g_fbx.fbxconf <> 'X' THEN
               SELECT fbxpost INTO g_fbx.fbxpost FROM fbx_file
               WHERE fbx01 = g_fbx.fbx01
               IF g_fbx.fbxconf = 'N' THEN
                  LET g_success='Y'
                  BEGIN WORK
                  CALL s_showmsg_init()
                  CALL t114_gl(g_fbx.fbx01,g_fbx.fbx02,'0')
                  IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #使用財二功能
                     CALL t114_gl(g_fbx.fbx01,g_fbx.fbx02,'1')
                  END IF
                  CALL s_showmsg()
                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
                ELSE
                  CALL cl_err(g_fbx.fbx01,'afa-350',0)
               END IF
            END IF
         WHEN "void"   #作廢
            IF cl_chk_act_auth() THEN
              #CALL t114_x()         #FUN-D20035
               CALL t114_x(1)        #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t114_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "carry_voucher"  #拋轉傳票
            IF cl_chk_act_auth() THEN
               IF g_fbx.fbxpost = 'Y' THEN
                  CALL t114_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-557',1)
               END IF 
            END IF
         WHEN "undo_carry_voucher"   #傳票拋轉還原
            IF cl_chk_act_auth() THEN
               IF g_fbx.fbxpost = 'Y' THEN
                  CALL t114_undo_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-558',1)
               END IF 
            END IF
         WHEN "confirm"   #確認
            IF cl_chk_act_auth() THEN
               CALL t114_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t114_y_upd()       #CALL 原確認的 update 段
               END IF
            END IF
         WHEN "undo_confirm" #取消確認
            IF cl_chk_act_auth() THEN
               CALL t114_z()
            END IF
         WHEN "post"    #過帳
            IF cl_chk_act_auth() THEN
               CALL t114_s('S')
            END IF
         WHEN "undo_post"  #過帳還原 
            IF cl_chk_act_auth() THEN
               CALL t114_w()
            END IF
          WHEN "related_document" #相關文件
            IF cl_chk_act_auth() THEN
               IF g_fbx.fbx01 IS NOT NULL THEN
                  LET g_doc.column1 = "fbx01"
                  LET g_doc.value1 = g_fbx.fbx01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #轉Excel檔
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fby),'','')
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
                 CALL t114_ef()
              END IF
         #@WHEN "准"
         WHEN "agree"
              IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                 CALL t114_y_upd()      #CALL 原確認的 update 段
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
                          CALL t114_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void, undo_void,      #FUN-D20035 add--undo_void
                                                     confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                                                     gen_entry, post, undo_post,carry_voucher,undo_carry_voucher")
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
                   IF cl_confirm('aws-081') THEN
                      IF aws_efapp_getnextforminfo() THEN
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                         IF NOT cl_null(g_argv1) THEN
                            CALL t114_q()
                            #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                            CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void, undo_void,        #	FUN-D20035 add--undo_void    
                                                       confirm, undo_confirm, easyflow_approval, auto_generate, entry_sheet, 
                                                       gen_entry, post, undo_post,carry_voucher,undo_carry_voucher")
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

FUNCTION t114_a()
DEFINE li_result LIKE type_file.num5

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fby.clear()
    INITIALIZE g_fbx.* TO NULL
    LET g_fbx01_t = NULL
    LET g_fbx_o.* = g_fbx.*
    LET g_fbx_t.* = g_fbx.*
    LET g_fbx.fbx03 = g_user
    
    CALL t114_fbx03('d')
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fbx.fbx02   = g_today
        LET g_fbx.fbx05   = g_today
        LET g_fbx.fbxconf = 'N'
        LET g_fbx.fbxpost = 'N'
        LET g_fbx.fbxmksg = 'N'
        LET g_fbx.fbx06   = '0'
        LET g_fbx.fbxuser = g_user
        LET g_fbx.fbxgrup = g_grup
        LET g_fbx.fbxdate = g_today
        LET g_fbx.fbxoriu = g_user
        LET g_fbx.fbxorig = g_grup
        LET g_fbx.fbxlegal= g_legal
        CALL t114_i("a")       #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fbx.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fbx.fbx01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
        CALL s_auto_assign_no("afa",g_fbx.fbx01,g_fbx.fbx02,"K","fbx_file","fbx01","","","") 
             RETURNING li_result,g_fbx.fbx01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbx.fbx01

        INSERT INTO fbx_file VALUES (g_fbx.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fbx_file",g_fbx.fbx01,g_fbx.fbx02,SQLCA.sqlcode,"","Ins:",1)
           ROLLBACK WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
           CALL cl_flow_notify(g_fbx.fbx01,'I')
        END IF
        CALL g_fby.clear()
        LET g_rec_b=0
        LET g_fbx_t.* = g_fbx.*
        LET g_fbx01_t = g_fbx.fbx01
        SELECT fbx01 INTO g_fbx.fbx01
          FROM fbx_file
         WHERE fbx01 = g_fbx.fbx01
 
        CALL t114_g()
        CALL t114_b()       #自動產生單身
        #---判斷是否直接列印,確認,過帳---------
        LET g_t1 = s_get_doc_no(g_fbx.fbx01)
        SELECT fahprt,fahconf,fahpost,fahapr
              INTO g_fahprt,g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
        IF g_fahprt = 'Y' THEN
           IF NOT cl_confirm('afa-128') THEN RETURN END IF
           CALL t114_out()
        END IF

        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
           CALL t114_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t114_y_upd()       #CALL 原確認的 update 段
           END IF
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t114_s('S')
        END IF
        EXIT WHILE
        END WHILE
END FUNCTION

FUNCTION t114_u()
   IF s_shut(0) THEN RETURN END IF

    IF g_fbx.fbx01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
    IF g_fbx.fbxconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fbx.fbxconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fbx.fbxpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF

    IF g_fbx.fbx06 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fbx01_t = g_fbx.fbx01
    LET g_fbx_o.* = g_fbx.*
    BEGIN WORK

    OPEN t114_cl USING g_fbx.fbx01
    IF STATUS THEN
       CALL cl_err("OPEN t114_cl:", STATUS, 1)
       CLOSE t114_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t114_cl INTO g_fbx.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t114_cl ROLLBACK WORK RETURN
    END IF
    CALL t114_show()
    WHILE TRUE
        LET g_fbx01_t = g_fbx.fbx01
        LET g_fbx.fbxmodu=g_user
        LET g_fbx.fbxdate=g_today
        CALL t114_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fbx.*=g_fbx_t.*
            CALL t114_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fbx.fbx06 = '0'
        IF g_fbx.fbx01 != g_fbx_t.fbx01 THEN
           UPDATE fby_file SET fby01=g_fbx.fbx01 WHERE fby01=g_fbx_t.fbx01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("upd","fby_file",g_fbx_t.fbx01,"",SQLCA.sqlcode,"","upd fby01",1)
              LET g_fbx.*=g_fbx_t.*
              CALL t114_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fbx_file SET * = g_fbx.*
         WHERE fbx01 = g_fbx.fbx01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
           CALL cl_err3("upd","fbx_file",g_fbx01_t,"",SQLCA.sqlcode,"","",1)
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fbx.fbx06
        IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")

        IF g_fbx.fbx02 != g_fbx_t.fbx02 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_fbx.fbx02
            WHERE npp01=g_fbx.fbx01 AND npp00=2 AND npp011=1
              AND nppsys = 'FA'
           IF STATUS THEN
              CALL cl_err3("upd","npp_file",g_fbx.fbx01,"",STATUS,"","upd npp02:",1)
           END IF
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t114_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbx.fbx01,'U')
END FUNCTION

FUNCTION t114_npp02(p_npptype)
  DEFINE p_npptype   LIKE npp_file.npptype

   IF p_npptype = "0" THEN
      IF g_fbx.fbx07 IS NULL OR g_fbx.fbx07=' ' THEN
         UPDATE npp_file SET npp02=g_fbx.fbx02
            WHERE npp01=g_fbx.fbx01 AND npp00=2 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_fbx.fbx01,"",STATUS,"","upd npp02:",1)
         END IF
      END IF
   ELSE
      IF g_fbx.fbx072 IS NULL OR g_fbx.fbx072=' ' THEN
         UPDATE npp_file SET npp02=g_fbx.fbx02
            WHERE npp01=g_fbx.fbx01 AND npp00=2 AND npp011=1
            AND nppsys = 'FA'
            AND npptype = p_npptype
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_fbx.fbx01,"",STATUS,"","upd npp02:",1)
         END IF
      END IF
   END IF
END FUNCTION

#處理INPUT
FUNCTION t114_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改
         l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入
         l_bdate,l_edate LIKE type_file.dat,
         l_n1            LIKE type_file.num5
  DEFINE li_result       LIKE type_file.num5
    CALL cl_set_head_visible("","YES")
 
    INPUT BY NAME
        g_fbx.fbx01,g_fbx.fbx02,g_fbx.fbx03,g_fbx.fbx04,g_fbx.fbx05,
        g_fbx.fbx07,g_fbx.fbx08,g_fbx.fbx072,g_fbx.fbx082,  
        g_fbx.fbxconf,g_fbx.fbxpost,
        g_fbx.fbxmksg,g_fbx.fbx06,
        g_fbx.fbxuser,g_fbx.fbxgrup,g_fbx.fbxmodu,g_fbx.fbxdate,
        g_fbx.fbxoriu,g_fbx.fbxorig,
        g_fbx.fbxud01,g_fbx.fbxud02,g_fbx.fbxud03,g_fbx.fbxud04,
        g_fbx.fbxud05,g_fbx.fbxud06,g_fbx.fbxud07,g_fbx.fbxud08,
        g_fbx.fbxud09,g_fbx.fbxud10,g_fbx.fbxud11,g_fbx.fbxud12,
        g_fbx.fbxud13,g_fbx.fbxud14,g_fbx.fbxud15
        WITHOUT DEFAULTS

        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t114_set_entry(p_cmd)
           CALL t114_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("fbx01")

        AFTER FIELD fbx01
            IF NOT cl_null(g_fbx.fbx01) AND (cl_null(g_fbx01_t) OR g_fbx.fbx01!=g_fbx01_t) THEN
            CALL s_check_no("afa",g_fbx.fbx01,g_fbx01_t,"K","fbx_file","fbx01","")  returning li_result,g_fbx.fbx01
            DISPLAY BY NAME g_fbx.fbx01
            IF (NOT li_result) THEN
               NEXT FIELD fbx01
            END IF
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
            END IF
           #帶出單據別設定的"簽核否"值,狀況碼預設為0
            SELECT fahapr,'0' INTO g_fbx.fbxmksg,g_fbx.fbx06
              FROM fah_file
             WHERE fahslip = g_t1
            IF cl_null(g_fbx.fbxmksg) THEN
                 LET g_fbx.fbxmksg = 'N'            
            END IF
            DISPLAY BY NAME g_fbx.fbxmksg,g_fbx.fbx06
            LET g_fbx_o.fbx01 = g_fbx.fbx01

        AFTER FIELD fbx02
            IF NOT cl_null(g_fbx.fbx02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fbx.fbx02 < l_bdate
               THEN CALL cl_err(g_fbx.fbx02,'afa-130',0)
                    NEXT FIELD fbx02
               END IF
               IF g_faa.faa31 = "Y" THEN
                  CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
                  IF g_fbx.fbx02 < l_bdate THEN
                     CALL cl_err(g_fbx.fbx02,'afa-130',0)
                     NEXT FIELD fbx02
                  END IF
               END IF
            END IF
            IF NOT cl_null(g_fbx.fbx02) THEN
               IF g_fbx.fbx02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fbx02
               END IF
               IF g_faa.faa31 = "Y" THEN
                  IF g_fbx.fbx02 <= g_faa.faa092 THEN
                     CALL cl_err('','mfg9999',1)
                     NEXT FIELD fbx02
                  END IF
               END IF                                          
               CALL s_get_bookno(YEAR(g_fbx.fbx02))
                    RETURNING g_flag,g_bookno1,g_bookno2
               IF g_flag =  '1' THEN  #抓不到帳別
                  CALL cl_err(g_fbx.fbx02,'aoo-081',1)
                  NEXT FIELD fbx02
               END IF
               #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
               #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
               IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF    
            END IF

        AFTER FIELD fbx03
            IF NOT cl_null(g_fbx.fbx03) THEN
               CALL t114_fbx03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbx.fbx03,g_errno,0)
                  LET g_fbx.fbx03 = g_fbx_t.fbx03
                  DISPLAY BY NAME g_fbx.fbx03
                  NEXT FIELD fbx03
               END IF
            END IF
            LET g_fbx_o.fbx03 = g_fbx.fbx03

        AFTER FIELD fbx04
            IF NOT cl_null(g_fbx.fbx04) THEN
               CALL t114_fbx04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fbx.fbx04,g_errno,0)
                  LET g_fbx.fbx04 = g_fbx_t.fbx04
                  DISPLAY BY NAME g_fbx.fbx04
                  NEXT FIELD fbx04
               END IF
            END IF
            LET g_fbx_o.fbx04 = g_fbx.fbx04
 
        AFTER FIELD fbxud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fbxud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER INPUT
          LET g_fbx.fbxuser = s_get_data_owner("fbx_file") #FUN-C10039
          LET g_fbx.fbxgrup = s_get_data_group("fbx_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION controlp
           CASE
              WHEN INFIELD(fbx01)    #查詢單據性質
                 LET g_t1 = s_get_doc_no(g_fbx.fbx01)
                 CALL q_fah( FALSE, TRUE,g_t1,'K','AFA') RETURNING g_t1
                 LET g_fbx.fbx01=g_t1
                 DISPLAY BY NAME g_fbx.fbx01
                 NEXT FIELD fbx01
              WHEN INFIELD(fbx03)    #申請人員
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fbx.fbx03
                 CALL cl_create_qry() RETURNING g_fbx.fbx03
                 DISPLAY BY NAME g_fbx.fbx03
                 NEXT FIELD fbx03
              WHEN INFIELD(fbx04)    #申請部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fbx.fbx04
                 CALL cl_create_qry() RETURNING g_fbx.fbx04
                 DISPLAY BY NAME g_fbx.fbx04
                 NEXT FIELD fbx04
              OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
 
    END INPUT
END FUNCTION
FUNCTION t114_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1

   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fbx01",TRUE)
   END IF

END FUNCTION
FUNCTION t114_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fbx01",FALSE)
    END IF
END FUNCTION

FUNCTION t114_fbx03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti,
          l_gen03    LIKE gen_file.gen03

    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
      FROM gen_file
     WHERE gen01 = g_fbx.fbx03
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-034'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
                                 LET l_gen03 = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_fbx.fbx04 = l_gen03
      DISPLAY BY NAME g_fbx.fbx04
   END IF
   IF cl_null(g_errno) OR p_cmd = 'd'
   THEN DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
 
FUNCTION t114_fbx04(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,
          l_gem02    LIKE gem_file.gem02,
          l_gemacti  LIKE gem_file.gemacti

    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fbx.fbx04
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-038'
                                 LET l_gem02 = NULL
                                 LET l_gemacti = NULL
        WHEN l_gemacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd'
   THEN DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION

FUNCTION t114_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fbx.* TO NULL
    CALL cl_msg("")
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t114_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fbx.* TO NULL
       RETURN
    END IF
    CALL cl_msg(" SEARCHING ! ")
    OPEN t114_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fbx.* TO NULL
    ELSE
        OPEN t114_count
        FETCH t114_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t114_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    CALL cl_msg("")
END FUNCTION

FUNCTION t114_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式
    l_abso          LIKE type_file.num10                 #絕對的筆數

    CASE p_flag
        WHEN 'N' FETCH NEXT     t114_cs INTO g_fbx.fbx01
        WHEN 'P' FETCH PREVIOUS t114_cs INTO g_fbx.fbx01
        WHEN 'F' FETCH FIRST    t114_cs INTO g_fbx.fbx01
        WHEN 'L' FETCH LAST     t114_cs INTO g_fbx.fbx01
        WHEN '/'
             IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                 LET INT_FLAG = 0  #add for prompt bug
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
            FETCH ABSOLUTE g_jump t114_cs INTO g_fbx.fbx01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0)
        INITIALIZE g_fbx.* TO NULL
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
    SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fbx_file",g_fbx.fbx01,"",SQLCA.sqlcode,"","",1)
        INITIALIZE g_fbx.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fbx.fbxuser
    LET g_data_group = g_fbx.fbxgrup
    CALL s_get_bookno(YEAR(g_fbx.fbx02))
         RETURNING g_flag,g_bookno1,g_bookno2
    #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
    #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
    IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF    
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_fbx.fbx02,'aoo-081',1)
    END IF
    CALL t114_show()
END FUNCTION

FUNCTION t114_show()
    LET g_fbx_t.* = g_fbx.*                #保存單頭舊值
    DISPLAY BY NAME
        g_fbx.fbx01,g_fbx.fbx02,g_fbx.fbx03,g_fbx.fbx04,g_fbx.fbx05,
        g_fbx.fbx07,g_fbx.fbx08,g_fbx.fbx072,g_fbx.fbx082,  
        g_fbx.fbxconf,g_fbx.fbxpost,
        g_fbx.fbxmksg,g_fbx.fbx06,
        g_fbx.fbxuser,g_fbx.fbxgrup,g_fbx.fbxmodu,g_fbx.fbxdate,
        g_fbx.fbxoriu,g_fbx.fbxorig,
        g_fbx.fbxud01,g_fbx.fbxud02,g_fbx.fbxud03,g_fbx.fbxud04,
        g_fbx.fbxud05,g_fbx.fbxud06,g_fbx.fbxud07,g_fbx.fbxud08,
        g_fbx.fbxud09,g_fbx.fbxud10,g_fbx.fbxud11,g_fbx.fbxud12,
        g_fbx.fbxud13,g_fbx.fbxud14,g_fbx.fbxud15
        
    IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")

    CALL t114_fbx03('d')
    CALL t114_fbx04('d')
    CALL t114_b_fill(g_wc2)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t114_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1

    IF s_shut(0) THEN RETURN END IF
    IF g_fbx.fbx01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
    IF g_fbx.fbxconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fbx.fbxconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fbx.fbxpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
    IF g_fbx.fbx06 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF

    BEGIN WORK

    OPEN t114_cl USING g_fbx.fbx01
    IF STATUS THEN
       CALL cl_err("OPEN t114_cl:", STATUS, 1)
       CLOSE t114_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t114_cl INTO g_fbx.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL t114_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL
        LET g_doc.column1 = "fbx01"
        LET g_doc.value1 = g_fbx.fbx01
        CALL cl_del_doc()
        MESSAGE "Delete fbx,fby!"
        DELETE FROM fbx_file WHERE fbx01 = g_fbx.fbx01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","fbx_file",g_fbx.fbx01,"",SQLCA.sqlcode,"","No fbx deleted",1)
        ELSE
           DELETE FROM fby_file WHERE fby01 = g_fbx.fbx01
           DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 2
                                  AND npp01 = g_fbx.fbx01
                                  AND npp011= 1
           #DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 2        #TQC-C70106  mark
           DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 14        #TQC-C70106  add
                                  AND npq01 = g_fbx.fbx01
                                  AND npq011= 1
           CLEAR FORM
           CALL g_fby.clear()
           CALL g_fby.clear()
        END IF
        INITIALIZE g_fbx.* LIKE fbx_file.*
        OPEN t114_count
        FETCH t114_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t114_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t114_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t114_fetch('/')
        END IF

    END IF
    CLOSE t114_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fbx.fbx01,'D')
END FUNCTION

FUNCTION t114_b()
DEFINE l_ac_t          LIKE type_file.num5,         #未取消的ARRAY CNT
       l_row,l_col     LIKE type_file.num5,         #分段輸入之行,列數
       l_n,l_cnt       LIKE type_file.num5,         #檢查重複用
       l_lock_sw       LIKE type_file.chr1,         #單身鎖住否
       p_cmd           LIKE type_file.chr1,         #處理狀態
       l_faj28         LIKE faj_file.faj28,
       l_b2            LIKE type_file.chr1000,
       l_faj06         LIKE faj_file.faj06,
       l_qty           LIKE type_file.num20_6,
       l_allow_insert  LIKE type_file.num5,         #可新增否
       l_allow_delete  LIKE type_file.num5          #可刪除否
DEFINE l_fbx06         LIKE fbx_file.fbx06
DEFINE l_faj04         LIKE faj_file.faj04
DEFINE l_faj20         LIKE faj_file.faj20
DEFINE l_fbi02         LIKE fbi_file.fbi02
DEFINE l_fbi021        LIKE fbi_file.fbi021
DEFINE l_faj09         LIKE faj_file.faj09

    LET l_fbx06 = g_fbx.fbx06 #由TIPTOP處理前端簽核動作
    LET g_action_choice = ""
    IF g_fbx.fbx01 IS NULL THEN RETURN END IF
    IF g_fbx.fbxconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_fbx.fbxconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fbx.fbxpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
    IF g_fbx.fbx06 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_forupd_sql = " SELECT fby02,fby03,fby031,' ',fby04,fby05,fby06,fby07,fby08,fby09, ",
                       "  fby10,fby11 ",
                       "  FROM fby_file ",
                       "  WHERE fby01 = ? ",
                       "  AND fby02 = ? ",
                       "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)                       
    DECLARE t114_bcl CURSOR FROM g_forupd_sql

   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   IF g_rec_b=0 THEN CALL g_fby.clear() END IF

      INPUT ARRAY g_fby WITHOUT DEFAULTS FROM s_fby.*
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
            LET l_lock_sw = 'N'
            LET l_n  = ARR_COUNT()
            BEGIN WORK

            OPEN t114_cl USING g_fbx.fbx01
            IF STATUS THEN
               CALL cl_err("OPEN t114_cl:", STATUS, 1)
               CLOSE t114_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t114_cl INTO g_fbx.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0)  # 資料被他人LOCK
               CLOSE t114_cl ROLLBACK WORK RETURN
            END IF
             IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fby_t.* = g_fby[l_ac].*
                LET l_flag = 'Y'

                OPEN t114_bcl USING g_fbx.fbx01,g_fby_t.fby02
                IF STATUS THEN
                   CALL cl_err("OPEN t114_bcl:", STATUS, 1)
                   CLOSE t114_bcl
                   LET l_lock_sw = "Y"
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t114_bcl INTO g_fby[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fby',SQLCA.sqlcode,0)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()
             ELSE
               LET l_flag='N'
               CALL cl_show_fld_cont()
             END IF
            IF l_ac <= l_n then
               SELECT faj06 INTO g_fby[l_ac].faj06
                 FROM faj_file
                WHERE faj02=g_fby[l_ac].fby03
                LET g_fby_t.faj06 =g_fby[l_ac].faj06
            END IF

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_fby[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fby[l_ac].* TO s_fby.*
              CALL g_fby.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
            END IF
            IF g_fby[l_ac].fby03 IS NOT NULL AND g_fby[l_ac].fby03 != ' ' THEN
               CALL t114_fby031('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fby[l_ac].fby031,g_errno,0)
                  NEXT FIELD fby02
               END IF
            END IF
            IF cl_null(g_fby[l_ac].fby031) THEN
               LET g_fby[l_ac].fby031 = ' '
            END IF
             INSERT INTO fby_file (fby01,fby02,fby03,fby031,fby04,fby05,
                                   fby06,fby07,fby08,fby09,fby10,fby11,
                                   fby052,fby062,fby072,
                                   fby092,fby102,fby112,fbylegal)
                 VALUES(g_fbx.fbx01,g_fby[l_ac].fby02,g_fby[l_ac].fby03,
                        g_fby[l_ac].fby031,g_fby[l_ac].fby04,g_fby[l_ac].fby05,
                        g_fby[l_ac].fby06,g_fby[l_ac].fby07,
                        g_fby[l_ac].fby08,g_fby[l_ac].fby09,
                        g_fby[l_ac].fby10,g_fby[l_ac].fby11,
                        g_fby2[l_ac].fby052,g_fby2[l_ac].fby062,g_fby2[l_ac].fby072,
                        g_fby2[l_ac].fby092,g_fby2[l_ac].fby102,g_fby2[l_ac].fby112,
                        g_legal)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
               CALL cl_err3("ins","fby_file",g_fbx.fbx01,g_fby[l_ac].fby02,SQLCA.sqlcode,"","ins fby",1)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fbx06 = '0'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fby[l_ac].* TO NULL
            LET g_fby_t.* = g_fby[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()
            NEXT FIELD fby02

        BEFORE FIELD fby02                            #defbxlt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fby[l_ac].fby02 IS NULL OR g_fby[l_ac].fby02 = 0 THEN
                   SELECT max(fby02)+1 INTO g_fby[l_ac].fby02
                      FROM fby_file WHERE fby01 = g_fbx.fbx01
                   IF g_fby[l_ac].fby02 IS NULL THEN
                       LET g_fby[l_ac].fby02 = 1
                   END IF
               END IF
            END IF

        AFTER FIELD fby02                        #check 序號是否重複
            IF g_fby[l_ac].fby02 != g_fby_t.fby02 OR
               g_fby_t.fby02 IS NULL THEN
                SELECT count(*) INTO l_n FROM fby_file
                 WHERE fby01 = g_fbx.fbx01
                   AND fby02 = g_fby[l_ac].fby02
                IF l_n > 0 THEN
                    LET g_fby[l_ac].fby02 = g_fby_t.fby02
                    CALL cl_err('',-239,0)
                    NEXT FIELD fby02
                END IF
            END IF

        AFTER FIELD fby03
           IF g_fby[l_ac].fby031 IS NULL THEN
              LET g_fby[l_ac].fby031 = ' '
           END IF
           IF NOT cl_null(g_fby[l_ac].fby03) AND g_fby[l_ac].fby031 IS NOT NULL THEN
              #該資產盤點
              SELECT COUNT(*) INTO g_cnt FROM fca_file
               WHERE fca03  = g_fby[l_ac].fby03
                 AND fca031 = g_fby[l_ac].fby031
                 AND fca15  = 'N'
              IF g_cnt > 0 THEN
                 CALL cl_err(g_fby[l_ac].fby03,'afa-097',0) 
                 NEXT FIELD fby03
              END IF
              #單號重複
              SELECT count(*) INTO l_n FROM faj_file
               WHERE faj02 =g_fby[l_ac].fby03
              IF l_n > 0 THEN 
                 CALL t114_fby031('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fby[l_ac].fby031,g_errno,0)
                    NEXT FIELD fby031
                 END IF
              ELSE 
                 CALL cl_err(g_fby[l_ac].fby03,'afa-160',0)
                 LET g_fby[l_ac].fby03 = g_fby_t.fby03
                 NEXT FIELD fby03
              END IF
           END IF

        AFTER FIELD fby031
           IF g_fby[l_ac].fby031 IS NULL THEN
              LET g_fby[l_ac].fby031 = ' '
           END IF
           IF NOT cl_null(g_fby[l_ac].fby03) THEN
              #該資產盤點              
              SELECT COUNT(*) INTO g_cnt FROM fca_file
               WHERE fca03  = g_fby[l_ac].fby03
                 AND fca031 = g_fby[l_ac].fby031
                 AND fca15  = 'N'
               IF g_cnt > 0 THEN
                  CALL cl_err(g_fby[l_ac].fby03,'afa-097',0)
                  LET g_fby[l_ac].fby031 = g_fby_t.fby031
                  NEXT FIELD fby03
               END IF
              CALL t114_fby031('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_fby[l_ac].fby031,g_errno,0)
                   LET g_fby[l_ac].fby031 = g_fby_t.fby031
                   NEXT FIELD fby03
                END IF
           END IF

        AFTER FIELD fby08
           IF NOT cl_null(g_fby[l_ac].fby08) THEN
              CALL t114_fby08('a')
              DISPLAY BY NAME g_fby[l_ac].fby08
           END IF

        AFTER FIELD fby09
           IF NOT cl_null(g_fby[l_ac].fby09) THEN
              CALL t114_fby09('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fby[l_ac].fby09 = g_fby_t.fby09
                 DISPLAY BY NAME g_fby[l_ac].fby09
                 CALL cl_err(g_fby[l_ac].fby09,g_errno,0)
                 NEXT FIELD fby09
              END IF
           END IF

        AFTER FIELD fby10
           IF NOT cl_null(g_fby[l_ac].fby10) THEN
              CALL t114_fby10('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fby[l_ac].fby10 = g_fby_t.fby10
                 DISPLAY BY NAME g_fby[l_ac].fby10
                 CALL cl_err(g_fby[l_ac].fby10,g_errno,0)
                 NEXT FIELD fby10
              END IF
           END IF

        AFTER FIELD fby11
           IF NOT cl_null(g_fby[l_ac].fby11) THEN
              CALL t114_fby11('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fby[l_ac].fby11 = g_fby_t.fby11
                 DISPLAY BY NAME g_fby[l_ac].fby11
                 CALL cl_err(g_fby[l_ac].fby11,g_errno,0)
                 NEXT FIELD fby11
              END IF
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_fby_t.fby02 > 0 AND g_fby_t.fby02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fby_file
                 WHERE fby01 = g_fbx.fbx01
                   AND fby02 = g_fby_t.fby02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fby_file",g_fbx.fbx01,g_fby_t.fby02,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET l_fbx06 = '0'
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fby[l_ac].* = g_fby_t.*
               CLOSE t114_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF g_fby[l_ac].fby03 IS NOT NULL AND g_fby[l_ac].fby03 != ' ' THEN
               CALL t114_fby031('d')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fby[l_ac].fby031,g_errno,0)
                  NEXT FIELD fby02
               END IF
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fby[l_ac].fby02,-263,1)
               LET g_fby[l_ac].* = g_fby_t.*
            ELSE
               IF cl_null(g_fby[l_ac].fby11) THEN
                  LET g_fby[l_ac].fby11 = ' '
               END IF
               UPDATE fby_file SET
                      fby01=g_fbx.fbx01      ,fby02=g_fby[l_ac].fby02,
                      fby03=g_fby[l_ac].fby03,fby031=g_fby[l_ac].fby031,
                      fby04=g_fby[l_ac].fby04,fby05=g_fby[l_ac].fby05,
                      fby06=g_fby[l_ac].fby06,fby07=g_fby[l_ac].fby07,
                      fby08=g_fby[l_ac].fby08,fby09=g_fby[l_ac].fby09,
                      fby10=g_fby[l_ac].fby10,fby11=g_fby[l_ac].fby11
                      WHERE fby01=g_fbx.fbx01 AND fby02=g_fby_t.fby02

               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err3("upd","fby_file",g_fbx.fbx01,g_fby_t.fby02,SQLCA.sqlcode,"","upd fby",1)
                  LET g_fby[l_ac].* = g_fby_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fbx06 = '0'
                  COMMIT WORK
               END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac  #FUN-D30032 mark
             IF INT_FLAG THEN
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_fby[l_ac].* = g_fby_t.*
            #FUN-D30032--add--str--
                ELSE
                   CALL g_fby.deleteElement(l_ac)
                   IF g_rec_b != 0 THEN
                      LET g_action_choice = "detail"
                      LET l_ac = l_ac_t
                   END IF
            #FUN-D30032--add--end--
                END IF
                CLOSE t114_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac  #FUN-D30032 add
             CLOSE t114_bcl
             COMMIT WORK
 
             CALL g_fby.deleteElement(g_rec_b+1)

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fby02) AND l_ac > 1 THEN
                LET g_fby[l_ac].* = g_fby[l_ac-1].*
                LET g_fby[l_ac].fby02 = NULL
                NEXT FIELD fby02
            END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(fby03)  #財產編號,財產附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fby[l_ac].fby03
                 LET g_qryparam.default2 = g_fby[l_ac].fby031
                 CALL cl_create_qry() RETURNING g_fby[l_ac].fby03,g_fby[l_ac].fby031
                 DISPLAY g_fby[l_ac].fby03 TO fby03
                 DISPLAY g_fby[l_ac].fby031 TO fby031
                 CALL t114_fby031('d')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fby03
                 END IF
                 NEXT FIELD fby03
               WHEN INFIELD(fby08)  #異動後資產類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fab"
                  LET g_qryparam.default1 = g_fby[l_ac].fby08
                  CALL cl_create_qry() RETURNING g_fby[l_ac].fby08
                  DISPLAY g_fby[l_ac].fby08 TO fby08
                  NEXT FIELD fby08                  
               WHEN INFIELD(fby09)  #異動後資產科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.default1 = g_fby[l_ac].fby09
                  LET g_qryparam.arg1 = g_bookno1
                  CALL cl_create_qry() RETURNING g_fby[l_ac].fby09
                  DISPLAY g_fby[l_ac].fby09 TO fby09
                  NEXT FIELD fby09
               WHEN INFIELD(fby10)  #異動後累折科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.default1 = g_fby[l_ac].fby10
                  LET g_qryparam.arg1 = g_bookno1
                  CALL cl_create_qry() RETURNING g_fby[l_ac].fby10
                  DISPLAY g_fby[l_ac].fby10 TO fby10
                  NEXT FIELD fby10                 
               WHEN INFIELD(fby11)  #異動後折舊科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.default1 = g_fby[l_ac].fby11
                  LET g_qryparam.arg1 = g_bookno1
                  CALL cl_create_qry() RETURNING g_fby[l_ac].fby11
                  DISPLAY g_fby[l_ac].fby11 TO fby11
                  NEXT FIELD fby11
              OTHERWISE
                 EXIT CASE
           END CASE

        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG CALL cl_cmdask()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()          
           
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    

      END INPUT

      LET g_fbx.fbxmodu = g_user
      LET g_fbx.fbxdate = g_today
      UPDATE fbx_file SET fbxmodu = g_fbx.fbxmodu,
                          fbxdate = g_fbx.fbxdate
       WHERE fbx01 = g_fbx.fbx01
      DISPLAY BY NAME g_fbx.fbxmodu,g_fbx.fbxdate

      UPDATE fbx_file SET fbx06=l_fbx06 WHERE fbx01 = g_fbx.fbx01
      LET g_fbx.fbx06 = l_fbx06
      DISPLAY BY NAME g_fbx.fbx06
      IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")
      CLOSE t114_bcl
      COMMIT WORK
      CALL t114_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t114_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fbx.fbx01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fbx_file ",
                  "  WHERE fbx01 LIKE '",l_slip,"%' ",
                  "    AND fbx01 > '",g_fbx.fbx01,"'"
      PREPARE t114_pb1 FROM l_sql 
      EXECUTE t114_pb1 INTO l_cnt 
      
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
        #CALL t114_x()         #FUN-D20035
         CALL t114_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00 = 2
                                AND npp01 = g_fbx.fbx01
                                AND npp011= 1
         DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00 = 14  
                                AND npq01 = g_fbx.fbx01
                                AND npq011= 1
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fbx_file WHERE fbx01 = g_fbx.fbx01
         INITIALIZE g_fbx.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t114_fby031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,
         l_n         LIKE type_file.num5,
         l_faj06     LIKE faj_file.faj06,
         l_faj04     LIKE faj_file.faj04,
         l_faj53     LIKE faj_file.faj53,
         l_faj54     LIKE faj_file.faj54,
         l_faj55     LIKE faj_file.faj55,
         l_faj531    LIKE faj_file.faj531,
         l_faj541    LIKE faj_file.faj541,
         l_faj551    LIKE faj_file.faj551  

   LET g_errno = ' '
    IF ((g_fby[l_ac].fby03 != g_fby_t.fby03 OR g_fby_t.fby03 IS NULL) OR
        (g_fby[l_ac].fby031 != g_fby_t.fby031 OR g_fby_t.fby031 IS NULL)) THEN
      SELECT count(*) INTO l_n FROM fby_file
       WHERE fby01  = g_fbx.fbx01
         AND fby03  = g_fby[l_ac].fby03
         AND fby031 = g_fby[l_ac].fby031
       IF l_n > 0 THEN
          LET g_errno = 'afa-105' #財產編號+附號不可重覆!
          RETURN
       END IF
      SELECT count(*) INTO l_n FROM fby_file,fbx_file
        WHERE fby01 = fbx01
         AND fby03  = g_fby[l_ac].fby03
         AND fby031 = g_fby[l_ac].fby031
         AND fbx02 <= g_fbx.fbx02
         AND fbxpost = 'N'
         AND fbx01 != g_fbx.fbx01
         AND fbxconf <> 'X'   
      IF l_n  > 0 THEN
          LET g_errno = 'afa-309'
          RETURN
       END IF
      SELECT faj06,faj04,faj53,faj54,faj55,
             faj531,faj541,faj551       #預設財二科目
        INTO l_faj06,l_faj04,l_faj53,l_faj54,l_faj55,
             l_faj531,l_faj541,l_faj551 #預設財二科目
        FROM faj_file
       WHERE faj02  = g_fby[l_ac].fby03
         AND faj022 = g_fby[l_ac].fby031
         AND faj43  NOT IN ('0','5','6','X','Z')
         AND fajconf = 'Y'
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-160'
         OTHERWISE LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     IF p_cmd = 'a' THEN
        LET g_fby[l_ac].faj06 = l_faj06     
        LET g_fby[l_ac].fby04 = l_faj04
        LET g_fby[l_ac].fby05 = l_faj53
        LET g_fby[l_ac].fby06 = l_faj54
        LET g_fby[l_ac].fby07 = l_faj55
        LET g_fby2[l_ac].fby052 = l_faj531
        LET g_fby2[l_ac].fby062 = l_faj541
        LET g_fby2[l_ac].fby072 = l_faj551
        
        DISPLAY BY NAME g_fby[l_ac].faj06
        DISPLAY BY NAME g_fby[l_ac].fby04
        DISPLAY BY NAME g_fby[l_ac].fby05
        DISPLAY BY NAME g_fby[l_ac].fby06
        DISPLAY BY NAME g_fby[l_ac].fby07
        DISPLAY BY NAME g_fby2[l_ac].fby052
        DISPLAY BY NAME g_fby2[l_ac].fby062
        DISPLAY BY NAME g_fby2[l_ac].fby072
     END IF
    END IF
END FUNCTION

FUNCTION t114_fby08(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,
         l_fab01     LIKE fab_file.fab01,
         l_fab11     LIKE fab_file.fab11,
         l_fab12     LIKE fab_file.fab12,
         l_fab13     LIKE fab_file.fab13,
         l_fab111     LIKE fab_file.fab111,
         l_fab121     LIKE fab_file.fab121,
         l_fab131     LIKE fab_file.fab131

      SELECT fab01,fab11,fab12,fab13
        INTO l_fab01,l_fab11,l_fab12,l_fab13
        FROM fab_file
       WHERE fab01  = g_fby[l_ac].fby08
         AND fabacti = 'Y'
      SELECT fab111,fab121,fab131
        INTO l_fab111,l_fab121,l_fab131
       FROM fab_file
       WHERE fab01  = g_fby[l_ac].fby08
         AND fabacti = 'Y'
     IF p_cmd = 'a' THEN
        LET g_fby[l_ac].fby08 = l_fab01
        LET g_fby[l_ac].fby09 = l_fab11
        LET g_fby[l_ac].fby10 = l_fab12
        LET g_fby[l_ac].fby11 = l_fab13
        LET g_fby2[l_ac].fby092 = l_fab111
        LET g_fby2[l_ac].fby102 = l_fab121
        LET g_fby2[l_ac].fby112 = l_fab131        
        
        DISPLAY BY NAME g_fby[l_ac].fby08
        DISPLAY BY NAME g_fby[l_ac].fby09
        DISPLAY BY NAME g_fby[l_ac].fby10
        DISPLAY BY NAME g_fby[l_ac].fby11
        DISPLAY BY NAME g_fby2[l_ac].fby092
        DISPLAY BY NAME g_fby2[l_ac].fby102
        DISPLAY BY NAME g_fby2[l_ac].fby112
     END IF
END FUNCTION

FUNCTION  t114_fby09(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fby[l_ac].fby09
       AND aag00 = g_bookno1
    CASE 
      WHEN STATUS=100          
         LET g_errno = 'afa-085'
         LET l_aag02   = NULL
      WHEN l_aagacti = 'N' 
         LET g_errno = '9028'
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

FUNCTION  t114_fby10(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fby[l_ac].fby10
       AND aag00 = g_bookno1
    CASE 
      WHEN STATUS=100         
       LET g_errno = 'afa-085'
       LET l_aag02   = NULL
    WHEN l_aagacti = 'N' 
       LET g_errno = '9028'
    OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

FUNCTION  t114_fby11(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fby[l_ac].fby11
       AND aag00 = g_bookno1
    CASE 
      WHEN STATUS=100          
         LET g_errno = 'afa-085'
                                  LET l_aag02   = NULL
      WHEN l_aagacti = 'N' 
         LET g_errno = '9028'
          OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

FUNCTION  t114_fby092(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,
       l_aag02         LIKE aag_file.aag02,
       l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fby2[l_ac].fby092
       AND aag00 = g_bookno2
    CASE 
      WHEN STATUS=100          
         LET g_errno = 'afa-085'
         LET l_aag02   = NULL
      WHEN l_aagacti = 'N' 
         LET g_errno = '9028'
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

FUNCTION t114_fby102(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_aag02         LIKE aag_file.aag02,
    l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fby2[l_ac].fby102
       AND aag00 = g_bookno2
    CASE 
       WHEN STATUS=100          
          LET g_errno = 'afa-085'
          LET l_aag02   = NULL
       WHEN l_aagacti = 'N' 
          LET g_errno = '9028'
       OTHERWISE 
          LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

FUNCTION  t114_fby112(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1,
       l_aag02         LIKE aag_file.aag02,
       l_aagacti       LIKE aag_file.aagacti

    LET g_errno = ' '
    SELECT aag02,aagacti
      INTO l_aag02,l_aagacti
      FROM aag_file
     WHERE aag01 = g_fby2[l_ac].fby112
       AND aag00 = g_bookno2
    CASE 
       WHEN STATUS=100          
          LET g_errno = 'afa-085'
          LET l_aag02   = NULL
       WHEN l_aagacti = 'N' 
          LET g_errno = '9028'
       OTHERWISE 
          LET g_errno = SQLCA.sqlcode USING '----------'
    END CASE
END FUNCTION

FUNCTION t114_b_fill(p_wc2)
DEFINE p_wc2           LIKE type_file.chr1000

    LET g_sql =
        "SELECT fby02,fby03,fby031,faj06,fby04,fby05,fby06,fby07,fby08,fby09,",
        "fby10,fby11 ",
        "  FROM fby_file ",
        "  LEFT OUTER JOIN faj_file ON fby03 = faj02 AND fby031 = faj022",
        " WHERE fby01  ='",g_fbx.fbx01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,             #單身
        " ORDER BY fby02 "

    PREPARE t114_pb FROM g_sql
    DECLARE fby_curs                       #SCROLL CURSOR
        CURSOR FOR t114_pb
 
    CALL g_fby.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fby_curs INTO g_fby[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fby.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t114_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_fby TO s_fby.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #財簽二
         IF g_faa.faa31 = 'Y' THEN
            CALL cl_set_act_visible("entry_sheet2",TRUE)
         ELSE
            CALL cl_set_act_visible("entry_sheet2",FALSE)
         END IF

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
         CALL t114_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
           ACCEPT DISPLAY
      ON ACTION previous
         CALL t114_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
        ACCEPT DISPLAY                   
 

      ON ACTION jump
         CALL t114_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 

      ON ACTION next
         CALL t114_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
            IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
            END IF
         ACCEPT DISPLAY                   
 

      ON ACTION last
         CALL t114_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 

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
         IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY

      ON ACTION fin_audit2   #財簽二
         LET g_action_choice="fin_audit2"
         EXIT DISPLAY

      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿2
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #@ON ACTION 作廢

      ON ACTION carry_voucher #傳票拋轉 
         LET g_action_choice="carry_voucher" 
         EXIT DISPLAY 

      ON ACTION undo_carry_voucher #傳票拋轉還原 
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY 

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
                LET INT_FLAG=FALSE
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

      AFTER DISPLAY
         CONTINUE DISPLAY

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

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION t114_out()
   DEFINE l_cmd        LIKE type_file.chr1000,
          l_wc,l_wc2    LIKE type_file.chr50,
          l_prtway     LIKE type_file.chr1

      CALL cl_wait()
      LET l_wc='fbx01="',g_fbx.fbx01,'"'
      #SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar114' #FUN-C30085 mark
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag114' #FUN-C30085 add
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
         LET l_wc2 = " '3' '3' "
      END IF
      #LET l_cmd = "afar114",  #FUN-C30085 mark
      LET l_cmd = "afag114",  #FUN-C30085 add
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                   " '",l_wc CLIPPED,"' ",l_wc2
      CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION

#---自動產生-------
FUNCTION t114_g()
 DEFINE  l_wc        LIKE type_file.chr1000,
         l_sql       STRING,
         l_faj       RECORD
               faj02     LIKE faj_file.faj02,
               faj022    LIKE faj_file.faj022,
               faj04     LIKE faj_file.faj04,
               faj06     LIKE faj_file.faj06,
               faj53     LIKE faj_file.faj53,
               faj54     LIKE faj_file.faj54,
               faj55     LIKE faj_file.faj55,
               faj531    LIKE faj_file.faj531,               
               faj541    LIKE faj_file.faj541,
               faj551    LIKE faj_file.faj551
               END RECORD,
         i           LIKE type_file.num5
 DEFINE ls_tmp STRING

   IF s_shut(0) THEN RETURN END IF
   IF g_fbx.fbx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbx.fbxconf='Y' THEN CALL cl_err(g_fbx.fbx01,'afa-107',0) RETURN END IF
   IF g_fbx.fbxconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF NOT cl_confirm('afa-103') THEN RETURN END IF #是否自動產生單身資料(Y/N)
   LET INT_FLAG = 0

      OPEN WINDOW t114_w2 AT 4,10 WITH FORM "afa/42f/afat1142"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale("afat1142")
      
      CONSTRUCT l_wc ON faj01,faj93,faj02,faj022
                   FROM faj01,faj93,faj02,faj022

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

      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1)
         LET INT_FLAG = 1
      END IF
      
     #------自動產生------
      BEGIN WORK
      LET l_sql ="SELECT faj02,faj022,faj04,faj06,faj53,",
                 " faj54,faj55,faj531,faj541,faj551 ",
                 "  FROM faj_file",
                 " WHERE faj43 NOT IN('0','5','6','X','Z')",
                 "   AND fajconf = 'Y' ",
                 "   AND ",l_wc CLIPPED,
                 "   ORDER BY faj02"
                 
     PREPARE t114_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        ROLLBACK WORK RETURN
     END IF
     DECLARE t114_curs2 CURSOR WITH HOLD FOR t114_prepare_g

     SELECT MAX(fby02)+1 INTO i FROM fby_file WHERE fby01 = g_fbx.fbx01
     IF cl_null(i) THEN LET i = 1 END IF
     LET g_success='Y'
     CALL s_showmsg_init()
     FOREACH t114_curs2 INTO l_faj.*                                                                                          
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        

       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          ROLLBACK WORK EXIT FOREACH
       END IF

      #判斷輸入日期之前是否有未過帳
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt 
         FROM fby_file,fbx_file
        WHERE fby01 = fbx01
          AND fby03 = l_faj.faj02
          AND fby031= l_faj.faj022 
          AND fbx02 <= g_fbx.fbx02   
          AND fbxpost = 'N'
          AND fbx01 != g_fbx.fbx01
          AND fbxconf <> 'X'  
       IF g_cnt > 0 THEN
          CONTINUE FOREACH
       END IF
        
        INSERT INTO fby_file (fby01,fby02,fby03,fby031,fby04,fby05,
                             fby06,fby07,fby052,fby062,fby072,fbylegal)
            VALUES (g_fbx.fbx01,i,l_faj.faj02,l_faj.faj022,l_faj.faj04,
                    l_faj.faj53,l_faj.faj54,l_faj.faj55,l_faj.faj531,
                    l_faj.faj541,l_faj.faj551,g_legal)
              IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
                 LET g_showmsg = g_fbx.fbx01,"/",i
                 CALL s_errmsg('fby01,fby02',g_showmsg,'ins fby',STATUS,1)
                 LET g_success = 'N' CONTINUE FOREACH
              END IF
              LET i = i + 1
     END FOREACH
                                                                                                         
     IF g_totsuccess="N" THEN                                                                                                        
        LET g_success="N"                                                                                                            
     END IF                                                                                                                          

     CLOSE WINDOW t114_w2
     IF g_success = 'Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     CALL t114_b_fill(l_wc)
END FUNCTION

FUNCTION t114_y()
  DEFINE l_bdate,l_edate        LIKE type_file.dat
  DEFINE l_flag                 LIKE type_file.chr1
  DEFINE l_cnt                  LIKE type_file.num5

   SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
   IF g_fbx.fbxconf='Y' THEN RETURN END IF
   IF g_fbx.fbxconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF

   SELECT COUNT(*) INTO l_cnt FROM fby_file
    WHERE fby01= g_fbx.fbx01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   #-->折舊年月判斷
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套

   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   IF g_fbx.fbx02 < l_bdate THEN
      CALL cl_err(g_fbx.fbx02,'afa-308',0)
      RETURN
   END IF

   #-->立帳日期小於關帳日期
   IF g_fbx.fbx02 < g_faa.faa09 THEN
      CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
   END IF
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
      IF g_fbx.fbx02 < l_bdate THEN
         CALL cl_err(g_fbx.fbx02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期小於關帳日期
      IF g_fbx.fbx02 < g_faa.faa092 THEN
         CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
      END IF
   END IF

   #----------------------------------- 檢查分錄底稿平衡正確否
#FUN-C30313---mark---START
#   IF g_fah.fahdmy3 = 'Y' THEN  
#      CALL s_chknpq(g_fbx.fbx01,'FA',1,'0',g_bookno1)
#      IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN
#         CALL s_chknpq(g_fbx.fbx01,'FA',1,'1',g_bookno2)
#      END IF
#   END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
    IF g_fah.fahdmy3 = 'Y' THEN
       CALL s_chknpq(g_fbx.fbx01,'FA',1,'0',g_bookno1)
    END IF
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN
       IF g_fah.fahdmy32 = 'Y' THEN
          CALL s_chknpq(g_fbx.fbx01,'FA',1,'1',g_bookno2)
       END IF
    END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK

   LET g_success = 'Y'
   UPDATE fbx_file SET fbxconf = 'Y' WHERE fbx01 = g_fbx.fbx01
       IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err3("upd","fbx_file",g_fbx.fbx01,"",STATUS,"","upd fbxconf",1)
          LET g_success = 'N'
       END IF
       IF g_success = 'Y' THEN
          LET g_fbx.fbxconf='Y'
          COMMIT WORK
          DISPLAY BY NAME g_fbx.fbxconf
          CALL cl_flow_notify(g_fbx.fbx01,'Y')
       ELSE
          LET g_fbx.fbxconf='N'
          ROLLBACK WORK
       END IF
 
    IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")
END FUNCTION


FUNCTION t114_y_chk()
   DEFINE l_bdate,l_edate        LIKE type_file.dat
   DEFINE l_flag                 LIKE type_file.chr1
   DEFINE l_cnt                  LIKE type_file.num5     

   LET g_success = 'Y'
#CHI-C30107 ------------ add -------------- begin
   #檢查確認碼="Y"
   IF g_fbx.fbxconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF
   #檢查確認碼="X"
   IF g_fbx.fbxconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
      g_action_choice CLIPPED = "insert"  THEN
      IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF 
   END IF
#CHI-C30107 ------------ add -------------- end
   SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
   #檢查確認碼="Y"
   IF g_fbx.fbxconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   #檢查確認碼="X"
   IF g_fbx.fbxconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   #單身無資料
   SELECT COUNT(*) INTO l_cnt FROM fby_file
    WHERE fby01= g_fbx.fbx01
   IF l_cnt = 0 THEN
      LET g_success = 'N'   
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #-->折舊年月判斷
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   IF g_fbx.fbx02 < l_bdate THEN
      LET g_success = 'N'   
      CALL cl_err(g_fbx.fbx02,'afa-308',0)
      RETURN
   END IF
   #-->立帳日期小於關帳日期
   IF g_fbx.fbx02 < g_faa.faa09 THEN
      LET g_success = 'N'   
      CALL cl_err(g_fbx.fbx01,'aap-176',1)
      RETURN
   END IF
   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
      IF g_fbx.fbx02 < l_bdate THEN
         LET g_success = 'N'   
         CALL cl_err(g_fbx.fbx02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期小於關帳日期
      IF g_fbx.fbx02 < g_faa.faa092 THEN
         LET g_success = 'N'   
         CALL cl_err(g_fbx.fbx01,'aap-176',1)
         RETURN
      END IF
   END IF
   #----------------------------------- 檢查分錄底稿平衡正確否
   LET g_t1 = s_get_doc_no(g_fbx.fbx01)                                                                             
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1  
#FUN-C30313---mark---START
#  IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN  
#     CALL s_chknpq(g_fbx.fbx01,'FA',1,'0',g_bookno1)
#     IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN
#        CALL s_chknpq(g_fbx.fbx01,'FA',1,'1',g_bookno2)
#     END IF
#  END IF
#FUN-C30313---mark---END

#FUN-C30313---add---START-----
   IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'N' THEN
      CALL s_chknpq(g_fbx.fbx01,'FA',1,'0',g_bookno1)
   END IF
   IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN
      IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'N' THEN
         CALL s_chknpq(g_fbx.fbx01,'FA',1,'1',g_bookno2)
      END IF
   END IF
#FUN-C30313---add---END-------
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION t114_y_upd()
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_fby     RECORD LIKE fby_file.*
   DEFINE l_msg     LIKE type_file.chr1000 #CHI-C30107 mark
   DEFINE l_n       LIKE type_file.num10              #MOD-C50255 add

   LET g_success = 'Y'
   IF g_action_choice CLIPPED = "confirm"    #按「確認」時
      OR g_action_choice CLIPPED = "insert" THEN
      IF g_fbx.fbxmksg='Y'   THEN
          IF g_fbx.fbx06 != '1' THEN
             CALL cl_err('','aws-078',1)
             LET g_success = 'N'
             RETURN
          END IF
      END IF
#     IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   END IF

   BEGIN WORK

   DECLARE t114_fby_cur CURSOR FOR
      SELECT * FROM fby_file WHERE fby01=g_fbx.fbx01
   FOREACH t114_fby_cur INTO l_fby.*
      SELECT count(*) INTO l_cnt FROM fby_file,fbx_file
       WHERE fby01 = fbx01
         AND fby03 = l_fby.fby03
         AND fby031= l_fby.fby031 AND fbx02 <= g_fbx.fbx02
         AND fbxpost = 'N'
         AND fbx01 != g_fbx.fbx01
         AND fbxconf <> 'X'
      IF l_cnt  > 0 THEN
         LET l_msg = l_fby.fby01,' ',l_fby.fby02,' ',
                     l_fby.fby03,' ',l_fby.fby031
         CALL s_errmsg('','',l_msg,'afa-309',1)
         LET g_success = 'N'
      END IF
   END FOREACH
   IF g_success = 'N' THEN
      CALL s_showmsg()
      RETURN
   END IF

   LET g_success = 'Y'
  #----------------------------------------MOD-C50255------------------------------(S)
   SELECT count(*) INTO l_n FROM npq_file
    WHERE npq01 = g_fbx.fbx01
      AND npq011 = 1
      AND npqsys = 'FA'
      AND npq00 = 14
   IF l_n = 0 AND
      ((g_fah.fahdmy3 = 'Y') OR (g_faa.faa31 = 'Y' AND g_fah.fahdmy32 = 'Y' )) THEN
      CALL t114_gen_glcr(g_fbx.*,g_fah.*)
   END IF
   IF g_success = 'Y' THEN
      IF g_fah.fahdmy3 = 'Y' AND g_fah.fahglcr = 'Y' THEN
         IF g_fah.fahfa1 = 'Y' THEN
            CALL s_chknpq(g_fbx.fbx01,'FA',1,'0',g_bookno1)
         END IF
      END IF
      IF g_faa.faa31 = 'Y' AND g_success = 'Y' AND g_fah.fahfa2="Y" THEN
         IF g_fah.fahdmy32 = 'Y' AND g_fah.fahglcr = 'Y' THEN
            CALL s_chknpq(g_fbx.fbx01,'FA',1,'1',g_bookno2)
         END IF
      END IF
   END IF
   IF g_success = 'N' THEN RETURN END IF
  #---------------------------------------MOD-C50255------------------------------(E)
  #update 確認碼
   UPDATE fbx_file SET fbxconf = 'Y' WHERE fbx01 = g_fbx.fbx01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('fbx01',g_fbx.fbx01,'upd fbxconf',STATUS,1)
      LET g_success = 'N'
   END IF

   CALL s_showmsg()
   #update狀況碼   
   IF g_success = 'Y' THEN
      IF g_fbx.fbxmksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
             WHEN 0  #呼叫 EasyFlow 簽核失敗
                  LET g_fbx.fbxconf="N"
                  LET g_success = "N"
                  ROLLBACK WORK
                  RETURN
             WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                  LET g_fbx.fbxconf="N"
                  ROLLBACK WORK
                  RETURN
         END CASE
      END IF
      IF g_success = 'Y' THEN
         LET g_fbx.fbx06='1'             #執行成功, 狀態值顯示為 '1' 已核准
         UPDATE fbx_file SET fbx06 = g_fbx.fbx06 WHERE fbx01=g_fbx.fbx01
         IF SQLCA.sqlerrd[3]=0 THEN
            LET g_success='N'
         END IF
         LET g_fbx.fbxconf='Y'           #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
         DISPLAY BY NAME g_fbx.fbxconf
         DISPLAY BY NAME g_fbx.fbx06   
         CALL cl_flow_notify(g_fbx.fbx01,'Y')
      ELSE
         LET g_fbx.fbxconf='N'
         LET g_success = 'N'   
         ROLLBACK WORK
      END IF
   ELSE
      LET g_fbx.fbxconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
   IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")
END FUNCTION

FUNCTION t114_ef()

   CALL t114_y_chk()      #CALL 原確認的 check 段
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

   IF aws_efcli2(base.TypeInfo.create(g_fbx),base.TypeInfo.create(g_fby),'','','','')
   THEN
      LET g_success='Y'
      LET g_fbx.fbx06='S'
      DISPLAY BY NAME g_fbx.fbx06
   ELSE
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t114_z()
   DEFINE l_bdate,l_edate   LIKE type_file.dat

   SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
   IF g_fbx.fbx06   = 'S' THEN CALL cl_err("","mfg3557",0) RETURN END IF
   IF g_fbx.fbxconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF   
   IF g_fbx.fbxconf = 'N' THEN RETURN END IF
   IF g_fbx.fbxpost = 'Y' THEN CALL cl_err('fbxpost=Y:','afa-101',0) RETURN END IF
   #-->折舊年月判斷
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2
   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   IF g_fbx.fbx02 < l_bdate THEN
      CALL cl_err(g_fbx.fbx02,'afa-308',0)
      RETURN
   END IF
   #-->立帳日期不可小於關帳日期
   IF g_fbx.fbx02 < g_faa.faa09 THEN
      CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
   END IF

   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                 #TQC-B50158   Add
      IF g_fbx.fbx02 < l_bdate THEN
         CALL cl_err(g_fbx.fbx02,'afa-308',0)
         RETURN
      END IF
      #-->立帳日期不可小於關帳日期
      IF g_fbx.fbx02 < g_faa.faa092 THEN
         CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
      END IF
   END IF

   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK

    OPEN t114_cl USING g_fbx.fbx01
    IF STATUS THEN
       CALL cl_err("OPEN t114_cl:", STATUS, 1)
       CLOSE t114_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t114_cl INTO g_fbx.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t114_cl ROLLBACK WORK RETURN
    END IF

   LET g_success = 'Y'
   UPDATE fbx_file SET fbxconf = 'N',fbx06 ='0' WHERE fbx01 = g_fbx.fbx01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN LET g_success = 'N' END IF
   IF g_success = 'Y' THEN
      LET g_fbx.fbxconf='N'
      LET g_fbx.fbx06='0'
      COMMIT WORK
      DISPLAY BY NAME g_fbx.fbxconf
      DISPLAY BY NAME g_fbx.fbx06
   ELSE
      LET g_fbx.fbxconf='Y'
      ROLLBACK WORK
   END IF
   IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")
END FUNCTION

#----過帳--------
FUNCTION t114_s(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1,
          l_fbx       RECORD LIKE fbx_file.*,
          l_fby       RECORD LIKE fby_file.*,
          l_faj       RECORD LIKE faj_file.*,
          l_cnt       LIKE type_file.num5,
          l_bdate,l_edate     LIKE type_file.dat,
          l_flag      LIKE type_file.chr1,
          l_msg       LIKE type_file.chr1000

   IF s_shut(0) THEN RETURN END IF
   IF g_fbx.fbx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
   IF g_fbx.fbxconf != 'Y' OR g_fbx.fbxpost != 'N' THEN
      CALL cl_err(g_fbx.fbx01,'afa-100',0)
      RETURN
   END IF
   #-->立帳日期小於關帳日期
   IF g_fbx.fbx02 < g_faa.faa09 THEN
      CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
   END IF
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fbx.fbx02 < g_faa.faa092 THEN
         CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
      END IF
   END IF

   LET g_t1 = s_get_doc_no(g_fbx.fbx01)
   SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
   #--->折舊年月判斷
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   IF g_fbx.fbx02 < l_bdate OR g_fbx.fbx02 > l_edate THEN
      CALL cl_err(g_fbx.fbx02,'afa-308',0)
      RETURN
   END IF
   IF g_faa.faa31 = 'Y' THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate                 #TQC-B50158   Add 
      IF g_fbx.fbx02 < l_bdate OR g_fbx.fbx02 > l_edate THEN
         CALL cl_err(g_fbx.fbx02,'afa-308',0)
         RETURN
      END IF
   END IF
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK

    OPEN t114_cl USING g_fbx.fbx01
    IF STATUS THEN
       CALL cl_err("OPEN t114_cl:", STATUS, 1)
       CLOSE t114_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t114_cl INTO g_fbx.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t114_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   #--------- 過帳(2)insert fap_file
   DECLARE t114_cur2 CURSOR FOR
      SELECT * FROM fby_file WHERE fby01=g_fbx.fbx01
   CALL s_showmsg_init()    
   FOREACH t114_cur2 INTO l_fby.*                                                                                   
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        

      IF SQLCA.sqlcode != 0 THEN         
         CALL s_errmsg('fby01',g_fbx.fbx01,'foreach:',SQLCA.sqlcode,1)   
         EXIT FOREACH
         LET g_success='N'
      END IF
      #------- 先找出對應之 faj_file 資料
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fby.fby03
                                            AND faj022=l_fby.fby031
      IF STATUS THEN
         LET g_showmsg = l_fby.fby03,"/",l_fby.fby031                 
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   
         LET g_success = 'N'
      END IF
      #-->判斷輸入日期之前是否有未過帳
      SELECT count(*) INTO l_cnt FROM fby_file,fbx_file
       WHERE fby01 = fbx01
         AND fby03 = l_fby.fby03
         AND fby031= l_fby.fby031 
         AND fbx02 <= g_fbx.fbx02
         AND fbx01 != g_fbx.fbx01
         AND fbxconf <> 'X'         
         AND fbxpost = 'N'
   
      IF l_cnt  > 0 THEN
         LET l_msg = l_fby.fby01,' ',l_fby.fby02,' ',
                     l_fby.fby03,' ',l_fby.fby031 
         CALL s_errmsg('','',l_msg,'afa-309',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF

      IF cl_null(l_fby.fby031) THEN
         LET l_fby.fby031 = ' '
      END IF

      INSERT INTO fap_file (fap02,fap021,fap03,fap04,fap28,fap82,
                            fap12,fap13,fap14,fap58,
                            fap59,fap60,fap121,fap131,
                            fap141,fap581,fap591,fap601,
                            fap50,faplegal)
      VALUES (l_fby.fby03,l_fby.fby031,'K',g_fbx.fbx02,l_fby.fby04,l_fby.fby08,
              l_fby.fby05,l_fby.fby06,l_fby.fby07,l_fby.fby09,
              l_fby.fby10,l_fby.fby11,l_fby.fby052,l_fby.fby062,
              l_fby.fby072,l_fby.fby092,l_fby.fby102,l_fby.fby112,
              g_fbx.fbx01,g_legal)
      IF STATUS THEN
         LET g_showmsg = l_fby.fby03,"/",l_fby.fby031,"/",'3',"/",g_fbx.fbx02    
         CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)  
         LET g_success = 'N'
      END IF
      #--------- 過帳(3)update faj_file
      UPDATE faj_file SET faj04 = l_fby.fby08, #異動後資產類別
                          faj53 = l_fby.fby09, #異動後資產科目
                          faj54 = l_fby.fby10, #異動後累折科目
                          faj55 = l_fby.fby11  #異動後折舊科目
       WHERE faj02=l_fby.fby03 AND faj022=l_fby.fby031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fby.fby03,"/",l_fby.fby031                 
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   
         LET g_success = 'N'
      END IF
      IF g_faa.faa31 = 'Y' THEN
         UPDATE faj_file SET faj531 = l_fby.fby092, #異動後資產科目
                             faj541 = l_fby.fby102, #異動後累折科目
                             faj551 = l_fby.fby112  #異動後折舊科目
         WHERE faj02=l_fby.fby03 AND faj022=l_fby.fby031
         IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
            LET g_showmsg = l_fby.fby03,"/",l_fby.fby031
            CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)
            LET g_success = 'N'
         END IF
      END IF
   END FOREACH                                                                                      
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          

   IF g_success = 'Y' THEN
      #--------- 過帳(1)update fbxpost
      UPDATE fbx_file SET fbxpost = 'Y' WHERE fbx01 = g_fbx.fbx01
          IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
             CALL s_errmsg('fbx01',g_fbx.fbx01,'upd fbxpost',STATUS,1)
             LET g_fbx.fbxpost='N'
             LET g_success = 'N'
          ELSE
             LET g_fbx.fbxpost='Y'
             LET g_success = 'Y'
          END IF
   END IF
   CALL s_showmsg()
   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_flow_notify(g_fbx.fbx01,'S')
   ELSE
      COMMIT WORK
   END IF
   DISPLAY BY NAME g_fbx.fbxpost
   
   IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t114_w()
   DEFINE l_sql    STRING                     
   DEFINE l_fby    RECORD LIKE fby_file.*,
          l_faj    RECORD LIKE faj_file.*,
          l_cnt             LIKE type_file.num5,
          l_msg             LIKE type_file.chr1000,
          l_bdate,l_edate   LIKE type_file.dat,
          l_fbx02  LIKE fbx_file.fbx02          

   IF s_shut(0) THEN RETURN END IF
   IF g_fbx.fbx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01 = g_fbx.fbx01
   #檢查過帳碼
   IF g_fbx.fbxpost != 'Y' THEN
      CALL cl_err(g_fbx.fbx01,'afa-108',0)
      RETURN
   END IF   
   #-->立帳日期小於關帳日期
   IF g_fbx.fbx02 < g_faa.faa09 THEN
      CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
   END IF
   IF g_faa.faa31 = "Y" THEN
      #-->立帳日期小於關帳日期
      IF g_fbx.fbx02 < g_faa.faa092 THEN
         CALL cl_err(g_fbx.fbx01,'aap-176',1) RETURN
      END IF
   END IF
   #--->折舊年月判斷必須為當月
   SELECT fbx02 INTO l_fbx02 FROM fbx_file WHERE fbx01 = g_fbx.fbx01
   IF SQLCA.sqlcode THEN LET l_fbx02 = ' '  RETURN END IF
   CALL s_get_bookno(g_faa.faa07)
       RETURNING g_flag,g_bookno1,g_bookno2

   #固資己不和二套掛勾，所以原本利用s_get_bookno取到帳別一及帳別二是用是否使用二套帳來判斷
   #此處取帳別二要重新處理，應取固資參數欄位財二帳套faa02c做為帳別二的帳套
   IF g_faa.faa31 = 'Y' THEN LET g_bookno2 = g_faa.faa02c END IF
   CALL s_azm(g_faa.faa07,g_faa.faa08) RETURNING l_flag,l_bdate,l_edate
   IF g_fbx.fbx02 < l_bdate OR g_fbx.fbx02 > l_edate THEN
      CALL cl_err(g_fbx.fbx02,'afa-339',0)
      RETURN
   END IF

   IF g_faa.faa31 = "Y" THEN
      CALL s_azmm(g_faa.faa072,g_faa.faa082,g_plant,g_bookno1) RETURNING l_flag,l_bdate,l_edate
      IF g_fbx.fbx02 < l_bdate OR g_fbx.fbx02 > l_edate THEN
         CALL cl_err(g_fbx.fbx02,'afa-339',0)
         RETURN
      END IF
   END IF

   IF NOT cl_null(g_fbx.fbx07) AND g_fah.fahglcr = 'N' THEN
      CALL cl_err(g_fbx.fbx07,'afa-311',0) RETURN
   END IF

   IF g_faa.faa31 = "Y" THEN
      IF NOT cl_null(g_fbx.fbx072) AND g_fah.fahglcr = 'N' THEN   
         CALL cl_err(g_fbx.fbx072,'afa-311',0) RETURN
      END IF
   END IF

   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK

    OPEN t114_cl USING g_fbx.fbx01
    IF STATUS THEN
       CALL cl_err("OPEN t114_cl:", STATUS, 1)
       CLOSE t114_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t114_cl INTO g_fbx.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t114_cl ROLLBACK WORK RETURN
    END IF

   LET g_success = 'Y'
   #--------- 還原過帳(2)update faj_file/fga_file
   DECLARE t114_cur3 CURSOR FOR
      SELECT * FROM fby_file WHERE fby01=g_fbx.fbx01
   CALL s_showmsg_init()    
   FOREACH t114_cur3 INTO l_fby.*                                                                                                      
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success = 'Y'                                                                                                         
      END IF                                                                                                                        

      IF SQLCA.sqlcode != 0 THEN 
         CALL s_errmsg('fby01',g_fbx.fbx01,'foreach:',SQLCA.sqlcode,0)    
         EXIT FOREACH
      END IF
      #-->判斷輸入日期之前是否有已過帳
      SELECT count(*) INTO l_cnt FROM fby_file,fbx_file
       WHERE fby01  = fbx01
         AND fby03  = l_fby.fby03
         AND fby031 = l_fby.fby031
         AND fbx02 >= l_fbx02
         AND fbx01 != g_fbx.fbx01
         AND fbxpost= 'Y'

      IF l_cnt  > 0 THEN
         LET l_msg = l_fby.fby01,' ',l_fby.fby02,' ',
                     l_fby.fby03,' ',l_fby.fby031
         CALL s_errmsg('','',l_msg,'afa-310',1)  
         LET g_success = 'N'
         CONTINUE FOREACH   
      END IF
      #--> 找出 faj_file 中對應之財產編號+附號
      SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fby.fby03
                                            AND faj022=l_fby.fby031
      IF STATUS THEN
         LET g_showmsg = l_fby.fby03,"/",l_fby.fby031                 
         CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,0)
         CONTINUE FOREACH   
      END IF
      IF cl_null(l_fby.fby031) THEN LET l_fby.fby031 = ' ' END IF
      UPDATE faj_file SET faj04  = l_fby.fby04,
                          faj53  = l_fby.fby05,
                          faj54  = l_fby.fby06,
                          faj55  = l_fby.fby07
       WHERE faj02=l_fby.fby03 AND faj022=l_fby.fby031
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fby.fby03,"/",l_fby.fby031                 
         CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   
         LET g_success = 'N'
      END IF
      
     IF g_faa.faa31 = 'Y' THEN
        UPDATE faj_file SET faj531  = l_fby.fby052,
                            faj541  = l_fby.fby062,
                            faj551  = l_fby.fby072
         WHERE faj02=l_fby.fby03 AND faj022=l_fby.fby031
        IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
           LET g_showmsg = l_fby.fby03,"/",l_fby.fby031                 
           CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj',STATUS,1)   
           LET g_success = 'N'
        END IF        
     END IF
      #--------- 還原過帳(3)delete fap_file
      IF cl_null(l_fby.fby031) THEN
         LET l_fby.fby031 = ' '
      END IF
      
      DELETE FROM fap_file
       WHERE fap02 = l_fby.fby03 AND fap021 = l_fby.fby031
         AND fap03 = 'K' AND fap04 = g_fbx.fbx02
         AND fap50 = g_fbx.fbx01
         
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
         LET g_showmsg = l_fby.fby01,"/",l_fby.fby02,"/",'3'                
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)   
         LET g_success = 'N'
      END IF
   END FOREACH                                                                                                   
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          

   #--------- 還原過帳(1)update fbx_file
   IF g_success = 'Y' THEN
      UPDATE fbx_file SET fbxpost = 'N' WHERE fbx01 = g_fbx.fbx01
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('fbx01',g_fbx.fbx01,'upd fbxpost',STATUS,1)
            LET g_fbx.fbxpost='Y'
            LET g_success = 'N'
         ELSE
            LET g_fbx.fbxpost='N'
            LET g_success = 'Y'
         END IF
   END IF
   CALL s_showmsg()
   IF g_success = 'N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
   DISPLAY BY NAME g_fbx.fbxpost
   
   IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")
END FUNCTION

#FUNCTION t114_x()                       #FUN-D20035
FUNCTION t114_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fbx.* FROM fbx_file WHERE fbx01=g_fbx.fbx01
   IF g_fbx.fbx06 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
   IF g_fbx.fbx01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fbx.fbxconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #作废操作
   IF p_type = 1 THEN
      IF g_fbx.fbxconf ='X' THEN RETURN END IF
   ELSE
   #取消作废
      IF g_fbx.fbxconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'

   OPEN t114_cl USING g_fbx.fbx01
   IF STATUS THEN
      CALL cl_err("OPEN t114_cl:", STATUS, 1)
      CLOSE t114_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t114_cl INTO g_fbx.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fbx.fbx01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t114_cl ROLLBACK WORK RETURN
   END IF
  #IF cl_void(0,0,g_fbx.fbxconf)   THEN      #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF     #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                          #FUN-D20035
      LET g_chr=g_fbx.fbxconf
     #IF g_fbx.fbxconf ='N' THEN                                      #FUN-D20035
      IF p_type = 1 THEN                                              #FUN-D20035
          LET g_fbx.fbxconf='X'
        LET g_fbx.fbx06 = '9'   
      ELSE
          LET g_fbx.fbxconf='N'
        LET g_fbx.fbx06 = '0'   
      END IF
      UPDATE fbx_file SET fbxconf = g_fbx.fbxconf,
                          fbx06   = g_fbx.fbx06,   
                          fbxmodu = g_user,
                          fbxdate = TODAY
                    WHERE fbx01 = g_fbx.fbx01
      IF STATUS THEN 
         CALL cl_err3("upd","fbx_file",g_fbx.fbx01,"",STATUS,"","upd fbxconf:",1)
         LET g_success='N' 
      END IF
      IF g_success='Y' THEN
          COMMIT WORK
          IF g_fbx.fbxconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
          IF g_fbx.fbx06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
          CALL cl_set_field_pic(g_fbx.fbxconf,g_chr2,g_fbx.fbxpost,"",g_chr,"")
          CALL cl_flow_notify(g_fbx.fbx01,'V')
      ELSE
          ROLLBACK WORK
      END IF
      SELECT fbxconf,fbx06 INTO g_fbx.fbxconf,g_fbx.fbx06   
        FROM fbx_file
       WHERE fbx01 = g_fbx.fbx01
      DISPLAY BY NAME g_fbx.fbxconf
        DISPLAY BY NAME g_fbx.fbx06    
   END IF
END FUNCTION

FUNCTION t114_gen_glcr(p_fbx,p_fah)
  DEFINE p_fbx     RECORD LIKE fbx_file.*
  DEFINE p_fah     RECORD LIKE fah_file.*

    IF cl_null(p_fah.fahgslp) THEN
       CALL cl_err(p_fbx.fbx01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL s_showmsg_init()
    CALL t114_gl(g_fbx.fbx01,g_fbx.fbx02,'0')
    IF g_faa.faa31= 'Y' AND g_success = 'Y' THEN
       CALL t114_gl(g_fbx.fbx01,g_fbx.fbx02,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF

END FUNCTION

FUNCTION t114_carry_voucher()
  DEFINE l_fahgslp    LIKE fah_file.fahgslp
  DEFINE li_result    LIKE type_file.num5
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5

    IF NOT cl_confirm('aap-989') THEN RETURN END IF
    IF NOT cl_null(g_fbx.fbx07) THEN
       CALL cl_err(g_fbx.fbx07,'aap-618',1)
       RETURN
    END IF
   IF g_faa.faa31 = "Y" THEN
      IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
         IF NOT cl_null(g_fbx.fbx072) THEN
            CALL cl_err(g_fbx.fbx072,'aap-618',1)
            RETURN
         END IF
      END IF #FUN-C30313 add
   END IF

    CALL s_get_doc_no(g_fbx.fbx01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1
    IF g_fah.fahdmy3 = 'N' THEN RETURN END IF  
    IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp)) THEN    
       LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new
       LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                   "  WHERE aba00 = '",g_faa.faa02b,"'",
                   "    AND aba01 = '",g_fbx.fbx07,"'"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_fbx.fbx07,'aap-991',1)
          RETURN
       END IF

       LET l_fahgslp = g_fah.fahgslp
    ELSE
       CALL cl_err('','aap-936',1)    
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'Y' OR ( g_fah.fahglcr = 'N' AND NOT cl_null(g_fah.fahgslp1)) THEN
          LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_fbx.fbx072,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          PREPARE aba_pre22 FROM l_sql
          DECLARE aba_cs22 CURSOR FOR aba_pre22
          OPEN aba_cs22
          FETCH aba_cs22 INTO l_n
          IF l_n > 0 THEN
             CALL cl_err(g_fbx.fbx072,'aap-991',1)
             RETURN
          END IF
       ELSE
          CALL cl_err('','aap-936',1) 
          RETURN
       END IF
    END IF

    IF cl_null(l_fahgslp) THEN
       CALL cl_err(g_fbx.fbx01,'axr-070',1)
       RETURN
    END IF

    IF g_faa.faa31= 'Y' THEN
       IF cl_null(g_fah.fahgslp1) THEN
          CALL cl_err(g_fbx.fbx01,'axr-070',1)
          RETURN
       END IF
    END IF
    LET g_wc_gl = 'npp01 = "',g_fbx.fbx01,'" AND npp011 = 1'
    LET g_str="afap302 '",g_wc_gl CLIPPED,"' '",g_fbx.fbxuser,"' '",g_fbx.fbxuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbx.fbx02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
    CALL cl_cmdrun_wait(g_str)

    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET g_str="afap202 '",g_wc_gl CLIPPED,"' '",g_fbx.fbxuser,"' '",g_fbx.fbxuser,"' '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",l_fahgslp,"' '",g_fbx.fbx02,"' 'Y' '1' 'Y' '",g_faa.faa02c,"' '",g_fah.fahgslp1,"'"
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF

    SELECT fbx07,fbx08,fbx072,fbx082  
      INTO g_fbx.fbx07,g_fbx.fbx08,g_fbx.fbx072,g_fbx.fbx082  
      FROM fbx_file
     WHERE fbx01 = g_fbx.fbx01
    DISPLAY BY NAME g_fbx.fbx07
    DISPLAY BY NAME g_fbx.fbx08
    DISPLAY BY NAME g_fbx.fbx072  
    DISPLAY BY NAME g_fbx.fbx082
    
END FUNCTION

FUNCTION t114_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_dbs      STRING 
  DEFINE l_sql      STRING

    IF NOT cl_confirm('aap-988') THEN RETURN END IF

    IF cl_null(g_fbx.fbx07)  THEN
       CALL cl_err(g_fbx.fbx07,'aap-619',1)
       RETURN
    END IF
    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          IF cl_null(g_fbx.fbx072)  THEN
             CALL cl_err(g_fbx.fbx072,'aap-619',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF

    CALL s_get_doc_no(g_fbx.fbx01) RETURNING g_t1
    SELECT * INTO g_fah.* FROM fah_file WHERE fahslip=g_t1

    IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp) THEN   
       CALL cl_err('','aap-936',1)                           
       RETURN
    END IF

    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahglcr = 'N' AND cl_null(g_fah.fahgslp1) THEN
          CALL cl_err('','aap-936',1)
          RETURN
       END IF
    END IF

    LET g_plant_new=g_faa.faa02p CALL s_getdbs() LET l_dbs=g_dbs_new

    LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                "  WHERE aba00 = '",g_faa.faa02b,"'",
                "    AND aba01 = '",g_fbx.fbx07,"'"
	CALL cl_replace_sqldb(l_sql) RETURNING l_sql
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_fbx.fbx07,'axr-071',1)
       RETURN
    END IF

    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
                      "  WHERE aba00 = '",g_faa.faa02c,"'",
                      "    AND aba01 = '",g_fbx.fbx072,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          PREPARE aba_pre12 FROM l_sql
          DECLARE aba_cs12 CURSOR FOR aba_pre1
          OPEN aba_cs12
          FETCH aba_cs12 INTO l_aba19
          IF l_aba19 = 'Y' THEN
             CALL cl_err(g_fbx.fbx072,'axr-071',1)
             RETURN
          END IF
       END IF #FUN-C30313 add
    END IF

    LET g_str="afap303 '",g_faa.faa02p,"' '",g_faa.faa02b,"' '",g_fbx.fbx07,"' '14' 'Y'"
    CALL cl_cmdrun_wait(g_str)

    IF g_faa.faa31 = "Y" THEN
       IF g_fah.fahdmy32 = "Y" THEN #FUN-C30313 add
          LET g_str="afap203 '",g_faa.faa02p,"' '",g_faa.faa02c,"' '",g_fbx.fbx072,"' '14' 'Y'"
          CALL cl_cmdrun_wait(g_str)
       END IF #FUN-C30313 add
    END IF

    SELECT fbx07,fbx08,fbx072,fbx082  
      INTO g_fbx.fbx07,g_fbx.fbx08,g_fbx.fbx072,g_fbx.fbx082  
      FROM fbx_file
     WHERE fbx01 = g_fbx.fbx01
    DISPLAY BY NAME g_fbx.fbx07
    DISPLAY BY NAME g_fbx.fbx08
    DISPLAY BY NAME g_fbx.fbx072  
    DISPLAY BY NAME g_fbx.fbx082  

END FUNCTION

FUNCTION t114_fin_audit2()
   DEFINE l_cnt      LIKE type_file.num5
   DEFINE l_rec_b2   LIKE type_file.num5


   OPEN WINDOW t1149_w2 WITH FORM "afa/42f/afat1149"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("afat1149")

   LET g_sql = 
       "SELECT fby02,fby03,fby031,'',fby04,fby052,fby062,fby072,fby08,", 
        "fby092,fby102,fby112 ",
        "  FROM fby_file ",
        " WHERE fby01  ='",g_fbx.fbx01,"'",  #單頭
        " ORDER BY fby01"

   PREPARE afat114_2_pre FROM g_sql
   DECLARE afat114_2_c CURSOR FOR afat114_2_pre
   CALL g_fby2.clear()
   LET l_cnt = 1

   FOREACH afat114_2_c INTO g_fby2[l_cnt].*
      IF STATUS THEN
         CALL cl_err('foreach fby2',STATUS,0)
         EXIT FOREACH
      END IF
      #取faj06中文名稱
      SELECT faj06
        INTO g_fby2[l_cnt].faj06
        FROM faj_file
       WHERE faj02 = g_fby2[l_cnt].fby03
         AND faj022 = g_fby2[l_cnt].fby031
      LET l_cnt = l_cnt + 1
   END FOREACH

   CALL g_fby2.deleteElement(l_cnt)
   LET l_rec_b2 = l_cnt - 1
   LET l_ac = 1
   CALL cl_set_act_visible("cancel", FALSE)

   IF g_fbx.fbxconf != 'N' THEN   #已確認或作廢單據只能查詢 
      DISPLAY ARRAY g_fby2 TO s_fby2.* ATTRIBUTE(COUNT=l_rec_b2,UNBUFFERED)

         ON ACTION CONTROLG
            CALL cl_cmdask()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
         
         ON ACTION about
            CALL cl_about()
         
         ON ACTION help
            CALL cl_show_help()

      END DISPLAY
   ELSE
    LET g_forupd_sql = " SELECT fby02,fby03,fby031,' ',",
                       "  fby04,fby052,fby062,fby072,  ",  
                       "  fby08,fby092,fby102,fby112 ",   
                       "  FROM fby_file ",
                       "  WHERE fby01 = ? ",
                       "  AND fby02 = ? ",
                       "  FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE t114_2_bcl CURSOR FROM g_forupd_sql 
       
      INPUT ARRAY g_fby2 WITHOUT DEFAULTS FROM s_fby2.*
            ATTRIBUTE(COUNT=l_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
      
         BEFORE INPUT     
            IF l_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
         BEFORE ROW            
            LET l_ac = ARR_CURR()
            BEGIN WORK
            IF l_rec_b2 >= l_ac THEN 
               LET g_fby2_t.* = g_fby2[l_ac].* 
               OPEN t114_2_bcl USING g_fbx.fbx01,g_fby2_t.fby02
            END IF

         ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fby2[l_ac].* = g_fby2_t.*
               CLOSE t114_2_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
        
           UPDATE fby_file SET fby092 = g_fby2[l_ac].fby092,
                               fby102 = g_fby2[l_ac].fby102,
                               fby112 = g_fby2[l_ac].fby112
             WHERE fby01 = g_fbx.fbx01
               AND fby02 = g_fby2_t.fby02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","fby_file",g_fbx.fbx01,g_fby2_t.fby02,SQLCA.sqlcode,"","",1)  
               LET g_fby2[l_ac].* = g_fby2_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
        
        AFTER FIELD fby092
           IF NOT cl_null(g_fby2[l_ac].fby092) THEN
              CALL t114_fby092('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fby2[l_ac].fby092 = g_fby2_t.fby092
                 DISPLAY BY NAME g_fby2[l_ac].fby092
                 CALL cl_err(g_fby2[l_ac].fby092,g_errno,0)
                 NEXT FIELD fby092
              END IF
           END IF

        AFTER FIELD fby102
           IF NOT cl_null(g_fby2[l_ac].fby102) THEN
              CALL t114_fby102('a')
              IF NOT cl_null(g_errno) THEN
                 LET g_fby2[l_ac].fby102 = g_fby2_t.fby102
                 DISPLAY BY NAME g_fby2[l_ac].fby102
                 CALL cl_err(g_fby2[l_ac].fby102,g_errno,0)
                 NEXT FIELD fby102
              END IF
           END IF

        AFTER FIELD fby112
           IF NOT cl_null(g_fby2[l_ac].fby112) THEN
              CALL t114_fby112('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fby2[l_ac].fby112,g_errno,0)
                 NEXT FIELD fby112
              END IF
           END IF           
      
         AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN 
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fby2[l_ac].* = g_fby2_t.*
               CLOSE t114_2_bcl 
               ROLLBACK WORK 
               EXIT INPUT
            END IF
            CLOSE t114_2_bcl 
            COMMIT WORK

        ON ACTION controlp  
           CASE
               WHEN INFIELD(fby092)  #異動後資產科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.default1 = g_fby2[l_ac].fby092
                  LET g_qryparam.arg1 = g_bookno2
                  CALL cl_create_qry() RETURNING g_fby2[l_ac].fby092
                  DISPLAY g_fby2[l_ac].fby092 TO fby092
                  NEXT FIELD fby092
               WHEN INFIELD(fby102)  #異動後累折科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.default1 = g_fby2[l_ac].fby102
                  LET g_qryparam.arg1 = g_bookno2
                  CALL cl_create_qry() RETURNING g_fby2[l_ac].fby102
                  DISPLAY g_fby2[l_ac].fby102 TO fby102
                  NEXT FIELD fby102                 
               WHEN INFIELD(fby112)  #異動後折舊科目
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.where = "aag07 MATCHES '[23]' AND aag03 MATCHES '[2]' "
                  LET g_qryparam.default1 = g_fby2[l_ac].fby112
                  LET g_qryparam.arg1 = g_bookno2
                  CALL cl_create_qry() RETURNING g_fby2[l_ac].fby112
                  DISPLAY g_fby2[l_ac].fby112 TO fby112
                  NEXT FIELD fby112
              OTHERWISE
                 EXIT CASE
           END CASE

         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()    
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION controlg 
            CALL cl_cmdask()
      
         ON ACTION about 
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
      
         ON ACTION CONTROLZ 
            CALL cl_show_req_fields() 
      
         ON ACTION exit
            EXIT INPUT

      END INPUT
   END IF
   
   CLOSE WINDOW t1149_w2

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF

END FUNCTION
#FUN-BC0035

