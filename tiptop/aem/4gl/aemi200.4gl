# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemi200.4gl
# Descriptions...: 設備工單維護作業
# Date & Author..: 04/07/16 By Carrier
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.FUN-550024 05/05/16 By Trisy 單據編號格式放大
# Modify.........: No.MOD-530629 05/06/08 By Carrier 更改單據查詢
# Modify.........: NO.FUN-560014 05/06/08 By jackie 單據編號修改
# Modify.........: No.MOD-560238 05/07/27 By vivien 自動編號修改
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680072 06/08/23 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750215 07/05/29 By jamie '確認'及'取消確認' action 按下後的窗 , 其中 yes/no/cancel 選項icon 應中文化
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810159 08/01/21 By Carol 單別g_t1只給3碼->改為LIKE oayslip
# Modify.........: No.FUN-840068 08/04/25 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-920111 09/02/27 By chenyu 1.資料無效時，不可以刪除
#                                                   2.單身沒有資料時，點“工作日報”按鈕，程序會當掉
# Modify.........: No.MOD-960030 09/06/03 By lilingyu 過fil04,fil02時若抓不到資料,p_ze的報錯訊息錯誤
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A10077 10/01/20 By Smapmin UPDATE fil17/fil18/fia23的動作需移至月底成本更新時再做
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80026 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No:TQC-C40242 12/04/26 By chenjing 增加”資料建立者、資料建立部門”可以下查詢條件
# Modify.........: No.TQC-C40247 12/04/26 By chenjing 修改輸入完單頭系統提示信息界面的按鈕顯示
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C60051 12/05/05 By suncx 未發料也需要可以完工
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-CB0201 12/11/23 By Elise 避免有更新不即時的情況
# Modify.........: No:TQC-CC0112 12/12/24 By qirl  新增完一筆資料保存後，點擊【更改】按鈕，更改【檢查單號】後，【設備編號】不會跟著檢查單號自動帶出新的資料。
# Modify.........: No:FUN-D30054 13/04/03 By Alberti  增加Action"取消完工"
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fil           RECORD LIKE fil_file.*,
    g_fil_t         RECORD LIKE fil_file.*,
    g_fil_o         RECORD LIKE fil_file.*,
    g_fil01_t       LIKE fil_file.fil01,
    g_fim           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fim02            LIKE fim_file.fim02,
        fim03            LIKE fim_file.fim03,
        fio02            LIKE fio_file.fio02,
        fio05            LIKE fio_file.fio05,
        fio06            LIKE fio_file.fio06,
        fiu02            LIKE fiu_file.fiu02,
        fio07            LIKE fio_file.fio07,
        fja02            LIKE fja_file.fja02,
        fim04            LIKE fim_file.fim04,
        fim05            LIKE fim_file.fim05,
        fim06            LIKE fim_file.fim06,
        fim07            LIKE fim_file.fim07,
        fim08            LIKE fim_file.fim08,
        fim09            LIKE fim_file.fim09,
        fim10            LIKE fim_file.fim10,
        fim11            LIKE fim_file.fim11,
        #FUN-840068 --start---
        fimud01          LIKE fim_file.fimud01,
        fimud02          LIKE fim_file.fimud02,
        fimud03          LIKE fim_file.fimud03,
        fimud04          LIKE fim_file.fimud04,
        fimud05          LIKE fim_file.fimud05,
        fimud06          LIKE fim_file.fimud06,
        fimud07          LIKE fim_file.fimud07,
        fimud08          LIKE fim_file.fimud08,
        fimud09          LIKE fim_file.fimud09,
        fimud10          LIKE fim_file.fimud10,
        fimud11          LIKE fim_file.fimud11,
        fimud12          LIKE fim_file.fimud12,
        fimud13          LIKE fim_file.fimud13,
        fimud14          LIKE fim_file.fimud14,
        fimud15          LIKE fim_file.fimud15
        #FUN-840068 --end--
                    END RECORD,
    g_fim_t         RECORD
        fim02            LIKE fim_file.fim02,
        fim03            LIKE fim_file.fim03,
        fio02            LIKE fio_file.fio02,
        fio05            LIKE fio_file.fio05,
        fio06            LIKE fio_file.fio06,
        fiu02            LIKE fiu_file.fiu02,
        fio07            LIKE fio_file.fio07,
        fja02            LIKE fja_file.fja02,
        fim04            LIKE fim_file.fim04,
        fim05            LIKE fim_file.fim05,
        fim06            LIKE fim_file.fim06,
        fim07            LIKE fim_file.fim07,
        fim08            LIKE fim_file.fim08,
        fim09            LIKE fim_file.fim09,
        fim10            LIKE fim_file.fim10,
        fim11            LIKE fim_file.fim11,
        #FUN-840068 --start---
        fimud01          LIKE fim_file.fimud01,
        fimud02          LIKE fim_file.fimud02,
        fimud03          LIKE fim_file.fimud03,
        fimud04          LIKE fim_file.fimud04,
        fimud05          LIKE fim_file.fimud05,
        fimud06          LIKE fim_file.fimud06,
        fimud07          LIKE fim_file.fimud07,
        fimud08          LIKE fim_file.fimud08,
        fimud09          LIKE fim_file.fimud09,
        fimud10          LIKE fim_file.fimud10,
        fimud11          LIKE fim_file.fimud11,
        fimud12          LIKE fim_file.fimud12,
        fimud13          LIKE fim_file.fimud13,
        fimud14          LIKE fim_file.fimud14,
        fimud15          LIKE fim_file.fimud15
        #FUN-840068 --end--
                    END RECORD,
    g_wc,g_wc2      STRING,  #No.FUN-580092 HCN 
    g_argv1         LIKE fil_file.fil01,
    g_sql           STRING,  #No.FUN-580092 HCN 
    g_cmd           LIKE type_file.chr1000,                                   #No.FUN-680072CHAR(300)
    g_rec_b         LIKE type_file.num5,                #單身筆數             #No.FUN-680072 SMALLINT
    g_t1            LIKE oay_file.oayslip,              #MOD-810159-modify    #No.FUN-550024        #No.FUN-680072CHAR(3)
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680072 SMALLINT
 
#主程式開始
DEFINE  p_row,p_col         LIKE type_file.num5           #No.FUN-680072 SMALLINT
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_chr           LIKE type_file.chr1               #No.FUN-680072 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10              #No.FUN-680072 INTEGER
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03             #No.FUN-680072CHAR(72)
 
DEFINE  g_row_count    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_curs_index   LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_jump         LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  mi_no_ask      LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_void         LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
MAIN
#DEFINE       l_time    LIKE type_file.chr8            #No.FUN-6A0068
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("AEM")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
 
    LET g_forupd_sql = "SELECT * FROM fil_file WHERE fil01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 5
 
    LET g_argv1 = ARG_VAL(1)
 
    OPEN WINDOW i200_w33 AT 2,2 WITH FORM "aem/42f/aemi200"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL i200_q()
       CALL i200_b_fill(" 1=1")
    END IF
 
    CALL i200_menu()
 
    CLOSE WINDOW i200_w33
      CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION i200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_type          LIKE    type_file.chr2    #No.FUN-680072 VARCHAR(2)
   CLEAR FORM                             #清除畫面
   CALL g_fim.clear()
 
    IF NOT cl_null(g_argv1) THEN
       LET g_wc2 = " 1=1"
       LET g_wc  = "  fil01 = '",g_argv1 CLIPPED,"'"
       LET g_sql = "SELECT fil01 FROM fil_file ",
                   " WHERE ",g_wc CLIPPED,
                   " ORDER BY 1"
    ELSE
       CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fil.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
                    fil00,fil01, fil02,fil03,fil04,fil05,fil06,fil07,
                    fil08,fil09, fil10,fil11,fil12,fil13,fil14,fil141,
                 #  fil15,fil151,fil16,fil17,fil18,fil19,fil20,fil21,                        #TQC-C40242--mark--
                 #  filconf,filuser,filgrup,filmodu,fildate,filacti,                         #TQC-C40242--mark-- 
                    fil15,fil151,fil16,fil17,fil18,fil19,fil20,filconf,                      #TQC-C40242--add--
                    fil21,filuser,filgrup,filoriu,filorig,filmodu,fildate,filacti,           #TQC-C40242--add--
                    #FUN-840068   ---start---
                    filud01,filud02,filud03,filud04,filud05,
                    filud06,filud07,filud08,filud09,filud10,
                    filud11,filud12,filud13,filud14,filud15
                    #FUN-840068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fil01)
#               LET g_t1=g_fil.fil01[1,3]
                LET g_t1=s_get_doc_no(g_fil.fil01)     #No.FUN-550024
 #MOD-560238 --start
 #                CALL q_fjh(TRUE,TRUE,g_t1,'aem','01') RETURNING g_qryparam.multiret   #No.MOD-530629
#                CALL q_smy(TRUE,TRUE,g_t1,'aem','1') RETURNING g_qryparam.multiret
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fil"
                LET g_qryparam.default1 = g_fil.fil01
                CALL cl_create_qry() RETURNING g_qryparam.multiret
 #MOD-560238 --end
                DISPLAY g_qryparam.multiret TO fil01
                NEXT FIELD fil01
             WHEN INFIELD(fil02)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fiq"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fil02
                NEXT FIELD fil02
             WHEN INFIELD(fil03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fia"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fil03
                NEXT FIELD fil03
             WHEN INFIELD(fil04)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fje"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fil04
                NEXT FIELD fil04
             WHEN INFIELD(fil08)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gen"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fil08
                NEXT FIELD fil08
             WHEN INFIELD(fil09)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_gem"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fil09
                NEXT FIELD fil09
             OTHERWISE EXIT CASE
          END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       #資料權限的檢查
       #Begin:FUN-980030
       #       IF g_priv2='4' THEN                           #只能使用自己的資料
       #          LET g_wc = g_wc clipped," AND filuser = '",g_user,"'"
       #       END IF
       #       IF g_priv3='4' THEN                           #只能使用相同群的資料
       #          LET g_wc = g_wc clipped," AND filgrup MATCHES '",g_grup CLIPPED,"*'"
       #       END IF
 
       #       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       #          LET g_wc = g_wc clipped," AND filgrup IN ",cl_chk_tgrup_list()
       #       END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('filuser', 'filgrup')
       #End:FUN-980030
 
 
       LET g_wc2 = " 1=1"
       CONSTRUCT g_wc2 ON fim02,fim03,fim04,fim05,fim06,
                          fim07,fim08,fim09,fim10,fim11
                          #No.FUN-840068 --start--
                          ,fimud01,fimud02,fimud03,fimud04,fimud05
                          ,fimud06,fimud07,fimud08,fimud09,fimud10
                          ,fimud11,fimud12,fimud13,fimud14,fimud15
                          #No.FUN-840068 ---end---
             FROM s_fim[1].fim02,s_fim[1].fim03,s_fim[1].fim04,
                  s_fim[1].fim05,s_fim[1].fim06,s_fim[1].fim07,
                  s_fim[1].fim08,s_fim[1].fim09,s_fim[1].fim10,
                  s_fim[1].fim11
                  #No.FUN-840068 --start--
                  ,s_fim[1].fimud01,s_fim[1].fimud02,s_fim[1].fimud03
                  ,s_fim[1].fimud04,s_fim[1].fimud05,s_fim[1].fimud06
                  ,s_fim[1].fimud07,s_fim[1].fimud08,s_fim[1].fimud09
                  ,s_fim[1].fimud10,s_fim[1].fimud11,s_fim[1].fimud12
                  ,s_fim[1].fimud13,s_fim[1].fimud14,s_fim[1].fimud15
                  #No.FUN-840068 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(fim03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_fio"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_fim[1].fim03
                    NEXT FIELD fim03
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
       IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
          LET g_sql = "SELECT fil01 FROM fil_file ",
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY 1"
       ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE fil01 ",
                      "  FROM fil_file, fim_file ",
                      " WHERE fil01 = fim01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      " ORDER BY 1"
       END IF
   END IF
 
   PREPARE i200_prepare FROM g_sql
   DECLARE i200_cs SCROLL CURSOR WITH HOLD FOR i200_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fil_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT fil01) FROM fil_file,fim_file WHERE ",
                 "fil01=fim01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i200_precount FROM g_sql
   DECLARE i200_count CURSOR FOR i200_precount
END FUNCTION
 
FUNCTION i200_menu()
 
   WHILE TRUE
      CALL i200_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i200_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i200_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i200_u()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i200_r()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i200_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i200_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "daily_work_report"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_fil.fil01) THEN
                  CALL i200_wr()
               END IF
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i200_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i200_z()
            END IF
         WHEN "work_finish"
            IF cl_chk_act_auth() THEN
               CALL i200_wf()
            END IF
        #FUN-D30054-START-add   
         WHEN "undo_work_finish"
            IF cl_chk_act_auth() THEN
               CALL i200_uwf()
            END IF   
        #FUN-D30054-END-add    
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
        
 
        WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fim),'','')
            END IF
 
        #No.FUN-6B0050-------add--------str----
        WHEN "related_document"  #相關work_finish文件
             IF cl_chk_act_auth() THEN
                IF g_fil.fil01 IS NOT NULL THEN
                LET g_doc.column1 = "fil01"
                LET g_doc.value1 = g_fil.fil01
                CALL cl_doc()
              END IF
        END IF
        #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i200_a()
   DEFINE li_result  LIKE type_file.num5           #No.FUN-550024        #No.FUN-680072 SMALLINT
   DEFINE   l_time LIKE type_file.chr8         #No.FUN-6A0068
 
   IF s_shut(0) THEN RETURN END IF
   LET l_time =TIME
   MESSAGE ""
   CLEAR FORM
   CALL g_fim.clear()
   INITIALIZE g_fil.* LIKE fil_file.*             #DEFAULT 設定
   LET g_fil01_t = NULL
   #預設值及將數值類變數清成零
   LET g_fil.filuser=g_user
   LET g_fil.filoriu = g_user #FUN-980030
   LET g_fil.filorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_fil.filgrup=g_grup
   LET g_fil.fildate=g_today
   LET g_fil.filacti='Y'              #資料有效
   LET g_fil.filconf='N'
   LET g_fil.fil00  ='1'
   LET g_fil.fil05  ='1'
   LET g_fil.fil10  =g_today
   LET g_fil.fil11  =l_time[1,2],l_time[4,5]
   LET g_fil.fil12  =g_today
   LET g_fil.fil13  =g_today
   LET g_fil.fil14  =g_today
   LET g_fil.fil141 =l_time[1,2],l_time[4,5]
   LET g_fil.fil19  =0
   LET g_fil.fil20  =0
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL i200_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_fil.* TO NULL
         EXIT WHILE
      END IF
      IF g_fil.fil01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
      #No.FUN-550024 --start--
 
      CALL s_auto_assign_no("aem",g_fil.fil01,g_today,"1","fil_file","fil01","","","")         #No.FUN-560014
                                                                                                #No.MOD-560238
        RETURNING li_result,g_fil.fil01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_fil.fil01
 
#       IF g_smy.smyauno='Y' AND cl_null(g_fil.fil01[5,10]) THEN
#         CALL s_smyauno(g_fil.fil01,g_today)
#                RETURNING g_i,g_fil.fil01
#         IF g_i THEN CONTINUE WHILE END IF
#         DISPLAY BY NAME g_fil.fil01
#      END IF
#
      #No.FUN-550024 ---end---
      LET g_fil.filplant = g_plant #FUN-980002
      LET g_fil.fillegal = g_legal #FUN-980002
      INSERT INTO fil_file VALUES (g_fil.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092 #No.FUN-B80026---調整至回滾事務前---
         ROLLBACK WORK
#        CALL cl_err(g_fil.fil01,SQLCA.sqlcode,1)   #No.FUN-660092
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      SELECT fil01 INTO g_fil.fil01 FROM fil_file
       WHERE fil01 = g_fil.fil01
      LET g_fil01_t = g_fil.fil01        #保留舊值
      LET g_fil_t.* = g_fil.*
 
      CALL g_fim.clear()
      LET g_rec_b=0
      IF NOT cl_null(g_fil.fil02) THEN
    #    IF cl_conf(17,12,'aem-014') THEN    #TQC-C40247--mark
         IF cl_confirm('aem-014') THEN       #TQC-C40247--add--
            CALL i200_g_b_1()
         END IF
      ELSE
#        IF cl_conf(17,12,'aem-035') THEN
#        IF cl_conf(17,12,'aem-045') THEN  #No.MOD-530629    #TQC-C40247--mark
         IF cl_confirm('aem-045') THEN  #No.MOD-530629    #TQC-C40247--add
            CALL i200_g_b_2()
         END IF
      END IF
      CALL i200_b()                   #輸入單身-2
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i200_g_b_1()
  DEFINE l_fit  RECORD LIKE fit_file.*
  DEFINE l_fim  RECORD LIKE fim_file.*
 
    IF g_fil.fil02 IS NULL THEN RETURN END IF
 
    DECLARE i200_fim_b_cur1 CURSOR FOR
     SELECT * FROM fit_file
      WHERE fit01=g_fil.fil02
    IF SQLCA.sqlcode THEN RETURN END IF
    FOREACH i200_fim_b_cur1 INTO l_fit.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach i200_fim_b_cur1',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        INITIALIZE l_fim.* TO NULL
        LET l_fim.fim01 = g_fil.fil01
        LET l_fim.fim02 = l_fit.fit02
        LET l_fim.fim03 = l_fit.fit03
        LET l_fim.fim04 = g_today
        LET l_fim.fim05 = g_today
        SELECT fio03,fio04,fio08 INTO l_fim.fim06,l_fim.fim07,l_fim.fim08
          FROM fio_file
         WHERE fio01= l_fim.fim03
        LET l_fim.fim09 = 0
        LET l_fim.fim11 = 'N'
        LET l_fim.fimplant = g_plant #FUN-980002
        LET l_fim.fimlegal = g_legal #FUN-980002 
        INSERT INTO fim_file VALUES(l_fim.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err('i200_fim_b_cur1',SQLCA.sqlcode,0)   #No.FUN-660092
           CALL cl_err3("ins","fim_file",l_fim.fim01,l_fim.fim02,SQLCA.sqlcode,"","i200_fim_b_cur1",1)  #No.FUN-660092
           EXIT FOREACH
        END IF
    END FOREACH
    CALL i200_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION i200_g_b_2()
  DEFINE l_fjc  RECORD LIKE fjc_file.*
  DEFINE l_fim  RECORD LIKE fim_file.*
 
    IF g_fil.fil03 IS NULL THEN RETURN END IF
 
    DECLARE i200_fim_b_cur2 CURSOR FOR
     SELECT * FROM fjc_file
      WHERE fjc01=g_fil.fil03
    IF SQLCA.sqlcode THEN RETURN END IF
    FOREACH i200_fim_b_cur2 INTO l_fjc.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach i200_fim_b_cur2',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        INITIALIZE l_fim.* TO NULL
        LET l_fim.fim01 = g_fil.fil01
        LET l_fim.fim02 = l_fjc.fjc02
        LET l_fim.fim03 = l_fjc.fjc03
        LET l_fim.fim04 = g_today
        LET l_fim.fim05 = g_today
        SELECT fio03,fio04,fio08 INTO l_fim.fim06,l_fim.fim07,l_fim.fim08
          FROM fio_file
         WHERE fio01= l_fim.fim03
        LET l_fim.fim09 = 0
        LET l_fim.fim11 = 'N'
 
        LET l_fim.fimplant = g_plant #FUN-980002
        LET l_fim.fimlegal = g_legal #FUN-980002 
        INSERT INTO fim_file VALUES(l_fim.*)
        IF SQLCA.sqlcode THEN
#          CALL cl_err('i200_fim_b_cur2',SQLCA.sqlcode,0)   #No.FUN-660092
           CALL cl_err3("ins","fim_file",l_fim.fim01,l_fim.fim02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
           EXIT FOREACH
        END IF
    END FOREACH
    CALL i200_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION i200_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_fil.fil01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fil.* FROM fil_file
    WHERE fil01=g_fil.fil01
   IF g_fil.filacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_fil.fil01,9027,0)
      RETURN
   END IF
   IF g_fil.filconf ='Y' THEN    #檢查資料是否為無效
      CALL cl_err(g_fil.fil01,9022,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_fil01_t = g_fil.fil01
   LET g_fil_o.* = g_fil.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i200_cl USING g_fil.fil01
   IF STATUS THEN
      CALL cl_err("OPEN i200_cl:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i200_cl INTO g_fil.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL i200_show()
   WHILE TRUE
      LET g_fil01_t = g_fil.fil01
      LET g_fil.filmodu=g_user
      LET g_fil.fildate=g_today
      CALL i200_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_fil.*=g_fil_t.*
         CALL i200_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_fil.fil01 != g_fil01_t THEN            # 更改單號
         UPDATE fim_file SET fim01 = g_fil.fil01 WHERE fim01 = g_fil01_t
      END IF
      UPDATE fil_file SET fil_file.* = g_fil.* WHERE fil01 = g_fil01_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)   #No.FUN-660092
         CALL cl_err3("upd","fil_file",g_fil.fil01,g_fil.fil02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i200_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i200_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入 #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改          #No.FUN-680072 VARCHAR(1)
DEFINE
    li_result       LIKE type_file.num5                  #No.FUN-550024          #No.FUN-680072 SMALLINT
 
    CALL i200_fil05()
    CALL cl_set_head_visible("","YES")                   #No.FUN-6B0029
    INPUT BY NAME g_fil.filoriu,g_fil.filorig,
          g_fil.fil00,g_fil.fil01, g_fil.fil02,g_fil.fil03,
          g_fil.fil04,g_fil.fil05, g_fil.fil06,g_fil.fil07,
          g_fil.fil08,g_fil.fil09, g_fil.fil10,g_fil.fil11,
          g_fil.fil12,g_fil.fil13, g_fil.fil14,g_fil.fil141,
          g_fil.fil16,g_fil.fil17,
          g_fil.fil18,g_fil.fil19, g_fil.fil20,g_fil.fil21,
          g_fil.filconf,g_fil.filuser,g_fil.filgrup,
          g_fil.filmodu,g_fil.fildate,g_fil.filacti,
          #FUN-840068     ---start---
          g_fil.filud01,g_fil.filud02,g_fil.filud03,g_fil.filud04,
          g_fil.filud05,g_fil.filud06,g_fil.filud07,g_fil.filud08,
          g_fil.filud09,g_fil.filud10,g_fil.filud11,g_fil.filud12,
          g_fil.filud13,g_fil.filud14,g_fil.filud15 
          #FUN-840068     ----end----
        WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i200_set_entry(p_cmd)
           CALL i200_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
         #No.FUN-550024 --start--
           CALL cl_set_docno_format("fil01")
           CALL cl_set_docno_format("fil02")
         #No.FUN-550024 ---end---
 
       AFTER FIELD fil01
         #No.FUN-550024 --start--
#No.FUN-560014 --start--
         IF NOT cl_null(g_fil.fil01) THEN
             CALL s_check_no("aem",g_fil.fil01,g_fil01_t,"1","fil_file","fil01","")  #No.MOD-560238
            RETURNING li_result,g_fil.fil01
            DISPLAY BY NAME g_fil.fil01
            IF (NOT li_result) THEN
               LET g_fil.fil01=g_fil_o.fil01
               NEXT FIELD fil01
            END IF
 
#            IF NOT cl_null(g_fil.fil01) THEN
#               LET g_t1=g_fil.fil01[1,3]
#               CALL s_mfgslip(g_t1,'aem','1')
#               IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
#                   CALL cl_err(g_t1,g_errno,0) NEXT FIELD fil01
#               END IF
#               IF p_cmd = 'a' AND cl_null(g_fil.fil01[5,10])
#                  AND g_smy.smyauno='N' THEN
#                  NEXT FIELD fil01
#               END IF
#
#               IF g_fil.fil01 != g_fil_t.fil01 OR g_fil_t.fil01 IS NULL THEN
#
#                  IF g_smy.smyauno = 'Y' AND
#                     NOT cl_chk_data_continue(g_fil.fil01[5,10]) THEN
#                     CALL cl_err('','9056',0)
#                     NEXT FIELD fil01
#                  END IF
#                  SELECT COUNT(*) INTO g_cnt FROM fil_file
#                   WHERE fil01 = g_fil.fil01
#                  IF g_cnt > 0 THEN   #資料重復
#                     CALL cl_err(g_fil.fil01,-239,0)
#                     LET g_fil.fil01 = g_fil_t.fil01
#                     DISPLAY BY NAME g_fil.fil01
#                     NEXT FIELD fil01
#                  END IF
#
#               END IF
#No.FUN-560014 ---end--
            END IF
 
        BEFORE FIELD fil02
           CALL i200_set_entry(p_cmd)
 
        AFTER FIELD fil02
           IF NOT cl_null(g_fil.fil02) THEN
              CALL i200_fil02(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fil.fil02,g_errno,0)
                 LET g_fil.fil02 = g_fil_o.fil02
                 DISPLAY BY NAME g_fil.fil02
                 NEXT FIELD fil02
              END IF
           END IF
           CALL i200_set_no_entry(p_cmd)
 
        AFTER FIELD fil03
           IF NOT cl_null(g_fil.fil03) THEN
              CALL i200_fil03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fil.fil03,g_errno,0)
                 LET g_fil.fil03 = g_fil_o.fil03
                 DISPLAY BY NAME g_fil.fil03
                 NEXT FIELD fil03
              END IF
           END IF
 
        AFTER FIELD fil04
           IF NOT cl_null(g_fil.fil04) THEN
              CALL i200_fil04(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fil.fil04,g_errno,0)
                 LET g_fil.fil04 = g_fil_o.fil04
                 DISPLAY BY NAME g_fil.fil04
                 NEXT FIELD fil04
              END IF
           END IF
 
        AFTER FIELD fil05
           IF NOT cl_null(g_fil.fil05) THEN
              CALL i200_fil05()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fil.fil05,g_errno,0)
                 LET g_fil.fil05 = g_fil_o.fil05
                 DISPLAY BY NAME g_fil.fil05
                 NEXT FIELD fil05
              END IF
           END IF
 
        AFTER FIELD fil08
            IF NOT cl_null(g_fil.fil08) THEN
               CALL i200_fil08(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fil.fil08,g_errno,0)
                  LET g_fil.fil08 = g_fil_o.fil08
                  DISPLAY BY NAME g_fil.fil08
                  NEXT FIELD fil08
               END IF
            END IF
 
        AFTER FIELD fil09
            IF NOT cl_null(g_fil.fil09) THEN
               CALL i200_fil09(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fil.fil09,g_errno,0)
                  LET g_fil.fil09 = g_fil_o.fil09
                  DISPLAY BY NAME g_fil.fil09
                  NEXT FIELD fil09
               END IF
            END IF
 
        AFTER FIELD fil11
            IF NOT cl_null(g_fil.fil11) THEN
               LET g_i=LENGTH(g_fil.fil11)
               IF g_i <> 4 THEN
                  CALL cl_err(g_fil.fil11,'aem-006',0)
                  NEXT FIELD fil11
               END IF
               IF g_fil.fil11 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fil.fil11[1,2] <'00' OR g_fil.fil11[1,2]>'23'
               OR g_fil.fil11[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fil.fil11,'aem-006',0)
                  NEXT FIELD fil11
               END IF
           END IF
 
        AFTER FIELD fil141
            IF NOT cl_null(g_fil.fil141) THEN
               LET g_i=LENGTH(g_fil.fil141)
               IF g_i <> 4 THEN
                  CALL cl_err(g_fil.fil141,'aem-006',0)
                  NEXT FIELD fil141
               END IF
               IF g_fil.fil141 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fil.fil141[1,2] <'00' OR g_fil.fil141[1,2]>'23'
               OR g_fil.fil141[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fil.fil141,'aem-006',0)
                  NEXT FIELD fil141
               END IF
           END IF
 
        AFTER FIELD fil16
           IF g_fil.fil16 = 'N' THEN
              DISPLAY NULL TO FORMONLY.fia12
           END IF
 
        #FUN-840068     ---start---
        AFTER FIELD filud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD filud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fil01)
#                LET g_t1=g_fil.fil01[1,3]
                 LET g_t1=s_get_doc_no(g_fil.fil01)     #No.FUN-550024
 #No.MOD-560238 --start
                 CALL q_smy(FALSE,FALSE,g_t1,'AEM','1') RETURNING g_t1 #TQC-670008
                  #No.MOD-530629  --begin
#                 CALL q_fjh(FALSE,FALSE,g_t1,'aem','01') RETURNING g_t1
                  #No.MOD-530629  --end
 #No.MOD-560238 --end
#                LET g_fil.fil01[1,3]=g_t1
                 LET g_fil.fil01 = g_t1                 #No.FUN-550024
                 DISPLAY BY NAME g_fil.fil01
                 NEXT FIELD fil01
              WHEN INFIELD(fil02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fil.fil02
                 LET g_qryparam.form ="q_fiq"
                 CALL cl_create_qry() RETURNING g_fil.fil02
                 DISPLAY BY NAME g_fil.fil02
                 NEXT FIELD fil02
              WHEN INFIELD(fil03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fil.fil03
                 LET g_qryparam.form ="q_fia"
                 CALL cl_create_qry() RETURNING g_fil.fil03
                 DISPLAY BY NAME g_fil.fil03
                 NEXT FIELD fil03
              WHEN INFIELD(fil04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fil.fil04
                 LET g_qryparam.form ="q_fje"
                 CALL cl_create_qry() RETURNING g_fil.fil04
                 DISPLAY BY NAME g_fil.fil04
                 NEXT FIELD fil04
              WHEN INFIELD(fil08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fil.fil08
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_fil.fil08
                 DISPLAY BY NAME g_fil.fil08
                 NEXT FIELD fil08
              WHEN INFIELD(fil09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fil.fil09
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_fil.fil09
                 DISPLAY BY NAME g_fil.fil09
                 NEXT FIELD fil09
              OTHERWISE EXIT CASE
        END CASE
 
 #No.MOD-540141--begin
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 #No.MOD-540141--end
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i200_fil02(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fiq02   LIKE fiq_file.fiq02
   DEFINE l_fiqacti LIKE fiq_file.fiqacti
 
   SELECT fiq02,fiqacti INTO l_fiq02,l_fiqacti
     FROM fiq_file WHERE fiq01 = g_fil.fil02
   LET g_errno = ' '
  #CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'   #MOD-960030
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-054'   #MOD-960030
        WHEN l_fiqacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'a' OR p_cmd = 'u' THEN   #--TQC-CC0112--add
      LET g_fil.fil03 = l_fiq02
      DISPLAY BY NAME g_fil.fil03
      CALL i200_fil03(p_cmd)
   END IF
END FUNCTION
 
FUNCTION i200_fil03(p_cmd)
   DEFINE p_cmd       LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fil16     LIKE fil_file.fil16
   DEFINE l_fia02     LIKE fia_file.fia02
   DEFINE l_fia04     LIKE fia_file.fia04
   DEFINE l_fia05     LIKE fia_file.fia05
   DEFINE l_fia12     LIKE fia_file.fia12
   DEFINE l_fia14     LIKE fia_file.fia14
   DEFINE l_fia15     LIKE fia_file.fia15
   DEFINE l_fia16     LIKE fia_file.fia16
   DEFINE l_fia17     LIKE fia_file.fia17
   DEFINE l_fia20     LIKE fia_file.fia20
   DEFINE l_fka02     LIKE fka_file.fka02
   DEFINE l_fka02a    LIKE fka_file.fka02
   DEFINE l_fka02b    LIKE fka_file.fka02
   DEFINE l_fka02c    LIKE fka_file.fka02
 
   LET g_errno = ' '
 
   SELECT fia02,  fia04,  fia05,  fia12,  fia14,  fia15,  fia16,  fia17,  fia20
     INTO l_fia02,l_fia04,l_fia05,l_fia12,l_fia14,l_fia15,l_fia16,l_fia17,l_fia20
     FROM fia_file
    WHERE fia01=g_fil.fil03 AND fiaacti ='Y'
 
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     SELECT fka02 INTO l_fka02  FROM fka_file
      WHERE fka01=l_fia14 AND fka03=g_plant
     SELECT fka02 INTO l_fka02a FROM fka_file
      WHERE fka01=l_fia15 AND fka03=g_plant
     SELECT fka02 INTO l_fka02b FROM fka_file
      WHERE fka01=l_fia16 AND fka03=g_plant
     SELECT fka02 INTO l_fka02c FROM fka_file
      WHERE fka01=l_fia17 AND fka03=g_plant
     DISPLAY l_fia02  TO FORMONLY.fia02
     DISPLAY l_fia04  TO FORMONLY.fia04
     DISPLAY l_fia05  TO FORMONLY.fia05
     DISPLAY l_fia14  TO FORMONLY.fia14
     DISPLAY l_fia15  TO FORMONLY.fia15
     DISPLAY l_fia16  TO FORMONLY.fia16
     DISPLAY l_fia17  TO FORMONLY.fia17
     DISPLAY l_fka02  TO FORMONLY.fka02
     DISPLAY l_fka02a TO FORMONLY.fka02a
     DISPLAY l_fka02b TO FORMONLY.fka02b
     DISPLAY l_fka02c TO FORMONLY.fka02c
  END IF
  IF p_cmd='a' AND cl_null(g_errno) THEN
     IF l_fia12 < g_today THEN
        LET g_fil.fil16 = 'Y'
        DISPLAY l_fia12 TO FORMONLY.fia12
     ELSE
        LET g_fil.fil16 = 'N'
     END IF
     DISPLAY BY NAME g_fil.fil16
  END IF
 
END FUNCTION
 
FUNCTION i200_fil04(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fje02   LIKE fje_file.fje02
 
   SELECT fje02 INTO l_fje02
     FROM fje_file WHERE fje01 = g_fil.fil04
   LET g_errno = ' '
#  CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'    #MOD-960030
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-119'    #MOD-960030
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_fje02 TO FORMONLY.fje02
   END IF
END FUNCTION
 
FUNCTION i200_fil05()
    CASE g_fil.fil05
        WHEN '1' LET g_msg= cl_getmsg('aem-010',g_lang)
        WHEN '2' LET g_msg= cl_getmsg('aem-012',g_lang)
        WHEN '3' LET g_msg= cl_getmsg('aem-013',g_lang)
        WHEN '4' LET g_msg= cl_getmsg('aem-016',g_lang)
    END CASE
    DISPLAY g_msg TO FORMONLY.d5
 
END FUNCTION
 
FUNCTION i200_fil08(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
     FROM gen_file WHERE gen01 = g_fil.fil08
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
   IF cl_null(g_errno) AND p_cmd = 'a' THEN
      LET g_fil.fil09 = l_gen03
      DISPLAY BY NAME g_fil.fil09
   END IF
END FUNCTION
 
FUNCTION i200_fil09(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gem02,gemacti INTO l_gem02,l_gemacti
     FROM gem_file WHERE gem01 = g_fil.fil09
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION i200_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_fil.* TO NULL               #NO.FUN-6B0050
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_fim.clear()
 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i200_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN i200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_fil.* TO NULL
   ELSE
      OPEN i200_count
      FETCH i200_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i200_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i200_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i200_cs INTO g_fil.fil01
      WHEN 'P' FETCH PREVIOUS i200_cs INTO g_fil.fil01
      WHEN 'F' FETCH FIRST    i200_cs INTO g_fil.fil01
      WHEN 'L' FETCH LAST     i200_cs INTO g_fil.fil01
      WHEN '/'
         IF NOT mi_no_ask THEN
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump i200_cs INTO g_fil.fil01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)
      INITIALIZE g_fil.* TO NULL  #TQC-6B0105
      CLEAR FORM
      CALL g_fim.clear()
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
   SELECT * INTO g_fil.* FROM fil_file WHERE fil01 = g_fil.fil01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("sel","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
      INITIALIZE g_fil.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_fil.filuser
      LET g_data_group = g_fil.filgrup
      LET g_data_plant = g_fil.filplant #FUN-980030
   END IF
   LET g_data_owner = g_fil.filuser   #FUN-4C0069
   LET g_data_group = g_fil.filgrup   #FUN-4C0069
   CALL i200_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i200_show()
   LET g_fil_t.* = g_fil.*                #保存單頭舊值
   DISPLAY BY NAME g_fil.filoriu,g_fil.filorig,
          g_fil.fil00,g_fil.fil01, g_fil.fil02,g_fil.fil03,
          g_fil.fil04,g_fil.fil05, g_fil.fil06,g_fil.fil07,
          g_fil.fil08,g_fil.fil09, g_fil.fil10,g_fil.fil11,
          g_fil.fil12,g_fil.fil13, g_fil.fil14,g_fil.fil141,
          g_fil.fil15,g_fil.fil151,g_fil.fil16,g_fil.fil17,
          g_fil.fil18,g_fil.fil19, g_fil.fil20,g_fil.fil21,
          g_fil.filconf,g_fil.filuser,g_fil.filgrup,
          g_fil.filmodu,g_fil.fildate,g_fil.filacti,
          #FUN-840068     ---start---
          g_fil.filud01,g_fil.filud02,g_fil.filud03,g_fil.filud04,
          g_fil.filud05,g_fil.filud06,g_fil.filud07,g_fil.filud08,
          g_fil.filud09,g_fil.filud10,g_fil.filud11,g_fil.filud12,
          g_fil.filud13,g_fil.filud14,g_fil.filud15 
          #FUN-840068     ----end----
   CALL i200_fil03('d')
   CALL i200_fil04('d')
   CALL i200_fil05()
   CALL i200_fil08('d')
   CALL i200_fil09('d')
   CALL i200_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i200_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_fil.fil01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fil.* FROM fil_file WHERE fil01=g_fil.fil01
   IF g_fil.filconf ='Y' THEN    #檢查資料是否為無效
      CALL cl_err(g_fil.fil01,9022,0)
      RETURN
   END IF
   #No.TQC-920111 add --begin
   IF g_fil.filacti = 'N' THEN
      CALL cl_err('','abm-950',0)
      RETURN
   END IF
   #No.TQC-920111 add --end
 
   BEGIN WORK
   OPEN i200_cl USING g_fil.fil01
   IF STATUS THEN
      CALL cl_err("OPEN i200_cl:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i200_cl INTO g_fil.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i200_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "fil01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_fil.fil01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM fim_file WHERE fim01 = g_fil.fil01
      IF STATUS THEN
#        CALL cl_err('del fim:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fim_file",g_fil.fil01,"",STATUS,"","del fim:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fil_file WHERE fil01 = g_fil.fil01
      IF STATUS THEN
#        CALL cl_err('del fil:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","del fil:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_fil.* TO NULL
      CLEAR FORM
      CALL g_fim.clear()
      OPEN i200_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i200_cs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
      FETCH i200_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i200_cs
             CLOSE i200_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i200_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i200_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i200_fetch('/')
      END IF
   END IF
   CLOSE i200_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i200_b()
DEFINE
    p_cmd           LIKE type_file.chr1,                 #處理狀態          #No.FUN-680072 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,                 #檢查重複用        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,                                    #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                 #可新增否          #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5                  #可刪除否          #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fil.fil01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fil.* FROM fil_file WHERE fil01=g_fil.fil01
    IF g_fil.filacti ='N' THEN CALL cl_err(g_fil.fil01,'9027',0) RETURN END IF
    IF g_fil.filconf ='Y' THEN    #檢查資料是否為無效
       CALL cl_err(g_fil.fil01,9022,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fim02,fim03,'','','','','','',fim04, ",
                       "       fim05,fim06,fim07,fim08,fim09,fim10,fim11,",
                       #No.FUN-840068 --start--
                       "       fimud01,fimud02,fimud03,fimud04,fimud05,",
                       "       fimud06,fimud07,fimud08,fimud09,fimud10,",
                       "       fimud11,fimud12,fimud13,fimud14,fimud15 ", 
                       #No.FUN-840068 ---end---
                       "  FROM fim_file",
                       " WHERE fim01=? AND fim02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i200_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fim WITHOUT DEFAULTS FROM s_fim.*
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
 
           BEGIN WORK
           OPEN i200_cl USING g_fil.fil01
           IF STATUS THEN
              CALL cl_err("OPEN i200_cl:", STATUS, 1)
              CLOSE i200_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i200_cl INTO g_fil.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i200_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_fim_t.* = g_fim[l_ac].*  #BACKUP
              OPEN i200_b_cl USING g_fil.fil01,g_fim_t.fim02
              IF STATUS THEN
                 CALL cl_err("OPEN i200_b_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i200_b_cl INTO g_fim[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fim_t.fim02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i200_fim03('d')
              END IF
              CALL i200_set_entry_b(p_cmd)
              CALL i200_set_no_entry_b(p_cmd)
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_fim[l_ac].* TO NULL
           LET g_fim_t.* = g_fim[l_ac].*         #新輸入資料
           LET g_fim[l_ac].fim04=g_today
           LET g_fim[l_ac].fim05=g_today
           LET g_fim[l_ac].fim11='N'
           CALL i200_set_entry_b(p_cmd)
           CALL i200_set_no_entry_b(p_cmd)
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD fim02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO fim_file(fim01,fim02,fim03,fim04,fim05,fim06,fim07,
                                fim08,fim09,fim10,fim11,
                                #FUN-840068 --start--
                                fimud01,fimud02,fimud03,fimud04,fimud05,fimud06,
                                fimud07,fimud08,fimud09,fimud10,fimud11,fimud12,
                                fimud13,fimud14,fimud15,
                                fimplant ,fimlegal) #FUN-980002
                                #FUN-840068 --end--
            VALUES(g_fil.fil01,      g_fim[l_ac].fim02,g_fim[l_ac].fim03,
                   g_fim[l_ac].fim04,g_fim[l_ac].fim05,g_fim[l_ac].fim06,
                   g_fim[l_ac].fim07,g_fim[l_ac].fim08,g_fim[l_ac].fim09,
                   g_fim[l_ac].fim10,g_fim[l_ac].fim11,
                   #FUN-840068 --start--
                   g_fim[l_ac].fimud01,g_fim[l_ac].fimud02,g_fim[l_ac].fimud03,
                   g_fim[l_ac].fimud04,g_fim[l_ac].fimud05,g_fim[l_ac].fimud06,
                   g_fim[l_ac].fimud07,g_fim[l_ac].fimud08,g_fim[l_ac].fimud09,
                   g_fim[l_ac].fimud10,g_fim[l_ac].fimud11,g_fim[l_ac].fimud12,
                   g_fim[l_ac].fimud13,g_fim[l_ac].fimud14,g_fim[l_ac].fimud15,
                   g_plant,g_legal) #FUN-980002
                   #FUN-840068 --end--
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_fim[l_ac].fim02,SQLCA.sqlcode,0)   #No.FUN-660092
              CALL cl_err3("ins","fim_file",g_fil.fil01,g_fim[l_ac].fim02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF
 
        BEFORE FIELD fim02                        #default 序號
           IF g_fim[l_ac].fim02 IS NULL OR g_fim[l_ac].fim02 = 0 THEN
              SELECT max(fim02)+1
                INTO g_fim[l_ac].fim02
                FROM fim_file
               WHERE fim01 = g_fil.fil01
              IF g_fim[l_ac].fim02 IS NULL THEN
                 LET g_fim[l_ac].fim02 = 1
              END IF
           END IF
 
        AFTER FIELD fim02                        #check 序號是否重複
           IF NOT cl_null(g_fim[l_ac].fim02) THEN
              IF g_fim[l_ac].fim02 != g_fim_t.fim02 OR g_fim_t.fim02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM fim_file
                  WHERE fim01 = g_fil.fil01
                    AND fim02 = g_fim[l_ac].fim02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fim[l_ac].fim02 = g_fim_t.fim02
                    NEXT FIELD fim02
                 END IF
              END IF
           END IF
 
        AFTER FIELD fim03
           IF NOT cl_null(g_fim[l_ac].fim03) THEN
              CALL i200_fim03(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fim[l_ac].fim03,SQLCA.sqlcode,0)
                 LET g_fim[l_ac].fim03 = g_fim_t.fim03
                 NEXT FIELD fim03
                 #------MOD-5A0095 START----------
                 DISPLAY BY NAME g_fim[l_ac].fim03
                 #------MOD-5A0095 END------------
              END IF
           END IF
 
        AFTER FIELD fim06
           IF g_fim[l_ac].fim06 < 0 THEN NEXT FIELD fim06 END IF
 
        AFTER FIELD fim07
           IF g_fim[l_ac].fim07 < 0 THEN NEXT FIELD fim07 END IF
 
        BEFORE FIELD fim08
           CALL i200_set_entry_b(p_cmd)
 
        AFTER FIELD fim08
           IF g_fim[l_ac].fim08 = 'Y' THEN
              IF cl_null(g_fim[l_ac].fim09) THEN
                 LET g_fim[l_ac].fim09=0
              END IF
           ELSE
              LET g_fim[l_ac].fim09=0
              LET g_fim[l_ac].fim10=''
           END IF
           #------MOD-5A0095 START----------
           DISPLAY BY NAME g_fim[l_ac].fim09
           DISPLAY BY NAME g_fim[l_ac].fim10
           #------MOD-5A0095 END------------
           CALL i200_set_no_entry_b(p_cmd)
 
        #No.FUN-840068 --start--
        AFTER FIELD fimud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fimud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
           IF g_fim_t.fim02 > 0 AND g_fim_t.fim02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM fim_file
               WHERE fim01 = g_fil.fil01
                 AND fim02 = g_fim_t.fim02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fim_t.fim02,SQLCA.sqlcode,0)   #No.FUN-660092
                 CALL cl_err3("del","fim_file",g_fil.fil01,g_fim_t.fim02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              MESSAGE "Delete Ok"
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fim[l_ac].* = g_fim_t.*
               CLOSE i200_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fim[l_ac].fim02,-263,1)
               LET g_fim[l_ac].* = g_fim_t.*
            ELSE
               UPDATE fim_file SET fim02 = g_fim[l_ac].fim02,
                                   fim03 = g_fim[l_ac].fim03,
                                   fim04 = g_fim[l_ac].fim04,
                                   fim05 = g_fim[l_ac].fim05,
                                   fim06 = g_fim[l_ac].fim06,
                                   fim07 = g_fim[l_ac].fim07,
                                   fim08 = g_fim[l_ac].fim08,
                                   fim09 = g_fim[l_ac].fim09,
                                   fim10 = g_fim[l_ac].fim10,
                                   fim11 = g_fim[l_ac].fim11,
                                   #FUN-840068 --start--
                                   fimud01 = g_fim[l_ac].fimud01,
                                   fimud02 = g_fim[l_ac].fimud02,
                                   fimud03 = g_fim[l_ac].fimud03,
                                   fimud04 = g_fim[l_ac].fimud04,
                                   fimud05 = g_fim[l_ac].fimud05,
                                   fimud06 = g_fim[l_ac].fimud06,
                                   fimud07 = g_fim[l_ac].fimud07,
                                   fimud08 = g_fim[l_ac].fimud08,
                                   fimud09 = g_fim[l_ac].fimud09,
                                   fimud10 = g_fim[l_ac].fimud10,
                                   fimud11 = g_fim[l_ac].fimud11,
                                   fimud12 = g_fim[l_ac].fimud12,
                                   fimud13 = g_fim[l_ac].fimud13,
                                   fimud14 = g_fim[l_ac].fimud14,
                                   fimud15 = g_fim[l_ac].fimud15
                                   #FUN-840068 --end-- 
                WHERE fim01=g_fil.fil01
                  AND fim02=g_fim_t.fim02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fim[l_ac].fim02,SQLCA.sqlcode,0)   #No.FUN-660092
                  CALL cl_err3("upd","fim_file",g_fil.fil01,g_fim_t.fim02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  LET g_fim[l_ac].* = g_fim_t.*
                  CLOSE i200_b_cl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_fim[l_ac].* = g_fim_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fim.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i200_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i200_b_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
           CALL i200_b_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fim02) AND l_ac > 1 THEN
               LET g_fim[l_ac].* = g_fim[l_ac-1].*
               NEXT FIELD fim02
           END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fim03)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_fim[l_ac].fim03
                LET g_qryparam.form ="q_fio"
                CALL cl_create_qry() RETURNING g_fim[l_ac].fim03
                NEXT FIELD fim03
             OTHERWISE EXIT CASE
          END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                       
 
    END INPUT
 
   #start FUN-5A0029
    LET g_fil.filmodu = g_user
    LET g_fil.fildate = g_today
    UPDATE fil_file SET filmodu = g_fil.filmodu,fildate = g_fil.fildate
     WHERE fil01 = g_fil.fil01
    DISPLAY BY NAME g_fil.filmodu,g_fil.fildate
   #end FUN-5A0029
 
    CLOSE i200_b_cl
    COMMIT WORK
    CALL i200_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i200_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM fil_file WHERE fil01 = g_fil.fil01
         INITIALIZE g_fil.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i200_fim03(p_cmd)
    DEFINE l_fioacti  LIKE fio_file.fioacti,
           l_fio03    LIKE fio_file.fio03,
           l_fio04    LIKE fio_file.fio04,
           l_fio08    LIKE fio_file.fio08,
           p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT fio02,fio03,fio04,fio05,fio06,fiu02,fio07,fja02,fio08,fioacti
      INTO g_fim[l_ac].fio02,l_fio03,l_fio04,g_fim[l_ac].fio05,
           g_fim[l_ac].fio06,g_fim[l_ac].fiu02,g_fim[l_ac].fio07,
           g_fim[l_ac].fja02,l_fio08,l_fioacti
      FROM fio_file LEFT OUTER JOIN fiu_file ON fio_file.fio06=fiu_file.fiu01 LEFT OUTER JOIN fja_file ON fio_file.fio07=fja_file.fja01
     WHERE fio01 = g_fim[l_ac].fim03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET g_fim[l_ac].fio02 = NULL
                                   LET g_fim[l_ac].fio05 = NULL
                                   LET g_fim[l_ac].fio06 = NULL
                                   LET g_fim[l_ac].fio07 = NULL
                                   LET g_fim[l_ac].fiu02 = NULL
                                   LET g_fim[l_ac].fja02 = NULL
         WHEN l_fioacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
   IF cl_null(g_errno) AND p_cmd = 'a' THEN
      LET g_fim[l_ac].fim06 = l_fio03
      LET g_fim[l_ac].fim07 = l_fio04
      LET g_fim[l_ac].fim08 = l_fio08
   END IF
   #------MOD-5A0095 START----------
   DISPLAY BY NAME g_fim[l_ac].fio02
   DISPLAY BY NAME g_fim[l_ac].fio05
   DISPLAY BY NAME g_fim[l_ac].fio06
   DISPLAY BY NAME g_fim[l_ac].fiu02
   DISPLAY BY NAME g_fim[l_ac].fio07
   DISPLAY BY NAME g_fim[l_ac].fja02
   DISPLAY BY NAME g_fim[l_ac].fim06
   DISPLAY BY NAME g_fim[l_ac].fim07
   DISPLAY BY NAME g_fim[l_ac].fim08
   #------MOD-5A0095 END------------
END FUNCTION
 
FUNCTION i200_b_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
     CONSTRUCT g_wc2 ON fim02,fim03,fim04,fim05,fim06,
                        fim07,fim08,fim09,fim10,fim11
                        #No.FUN-840068 --start--
                        ,fimud01,fimud02,fimud03,fimud04,fimud05
                        ,fimud06,fimud07,fimud08,fimud09,fimud10
                        ,fimud11,fimud12,fimud13,fimud14,fimud15
                        #No.FUN-840068 ---end---
           FROM s_fim[1].fim02,s_fim[1].fim03,s_fim[1].fim04,
                s_fim[1].fim05,s_fim[1].fim06,s_fim[1].fim07,
                s_fim[1].fim08,s_fim[1].fim09,s_fim[1].fim10,
                s_fim[1].fim11
                #No.FUN-840068 --start--
                ,s_fim[1].fimud01,s_fim[1].fimud02,s_fim[1].fimud03
                ,s_fim[1].fimud04,s_fim[1].fimud05,s_fim[1].fimud06
                ,s_fim[1].fimud07,s_fim[1].fimud08,s_fim[1].fimud09
                ,s_fim[1].fimud10,s_fim[1].fimud11,s_fim[1].fimud12
                ,s_fim[1].fimud13,s_fim[1].fimud14,s_fim[1].fimud15
                #No.FUN-840068 ---end---
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fim03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fio"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO s_fim[1].fim03
              NEXT FIELD fim03
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    LET g_sql = "SELECT fim02,fim03,fio02,fio05,fio06,fiu02,fio07,fja02,",
                "       fim04,fim05,fim06,fim07,fim08,fim09,fim10,fim11,",
                #No.FUN-840068 --start--
                "       fimud01,fimud02,fimud03,fimud04,fimud05,",
                "       fimud06,fimud07,fimud08,fimud09,fimud10,",
                "       fimud11,fimud12,fimud13,fimud14,fimud15 ", 
                #No.FUN-840068 ---end---
                "  FROM fim_file LEFT OUTER JOIN fio_file LEFT OUTER JOIN fiu_file ON fio_file.fio06=fiu_file.fiu01 LEFT OUTER JOIN fja_file ON fio_file.fio07=fja_file.fja01 ON fim_file.fim03=fio_file.fio01 ",
                " WHERE fim01 ='",g_fil.fil01,"'"
    #No.FUN-8B0123---Begin
    #           "   AND ",p_wc2 CLIPPED,
    #           " ORDER BY 1"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1" 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i200_pb2 FROM g_sql
    DECLARE fim_curs2 CURSOR FOR i200_pb2
 
    CALL g_fim.clear()
    LET g_cnt = 1
    FOREACH fim_curs2 INTO g_fim[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fim.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
  #DISPLAY ARRAY g_fim TO s_fim.* ATTRIBUTE(COUNT=g_rec_b)             #MOD-CB0201 mark
   DISPLAY ARRAY g_fim TO s_fim.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-CB0201
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION previous
         CALL i200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION jump
         CALL i200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION next
         CALL i200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION last
         CALL i200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION work_finish
         LET g_action_choice="work_finish"
         EXIT DISPLAY
      #FUN-D30054-START-add   
      ON ACTION undo_work_finish
         LET g_action_choice="undo_work_finish"
         EXIT DISPLAY   
      #FUN-D30054-END-add    
      ON ACTION daily_work_report
         LET g_action_choice="daily_work_report"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
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
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0049
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end                       
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i200_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_fil.fil01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fil.* FROM fil_file
    WHERE fil01=g_fil.fil01
   IF g_fil.filconf ='Y' THEN    #檢查資料是否為無效
      CALL cl_err(g_fil.fil01,9022,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i200_cl USING g_fil.fil01
   IF STATUS THEN
      CALL cl_err("OPEN i200_cl:", STATUS, 1)
      CLOSE i200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i200_cl INTO g_fil.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
   CALL i200_show()
   IF cl_exp(0,0,g_fil.filacti) THEN                   #確認一下
       LET g_chr=g_fil.filacti
       IF g_fil.filacti='Y' THEN
           LET g_fil.filacti='N'
       ELSE
           LET g_fil.filacti='Y'
       END IF
       UPDATE fil_file
          SET filacti=g_fil.filacti, #更改有效碼
              filmodu=g_user,
              fildate=g_today
        WHERE fil01=g_fil.fil01
       IF SQLCA.sqlcode OR STATUS = 100 THEN
#          CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)   #No.FUN-660092
           CALL cl_err3("upd","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
           LET g_fil.filacti=g_chr
       END IF
       SELECT filacti,filmodu,fildate
         INTO g_fil.filacti,g_fil.filmodu,g_fil.fildate
         FROM fil_file
        WHERE fil01=g_fil.fil01
       DISPLAY BY NAME g_fil.filacti,g_fil.filmodu,g_fil.fildate
   END IF
   CLOSE i200_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION i200_wf()   #need modify
  DEFINE l_fiw11_1    LIKE fiw_file.fiw11
  DEFINE l_fiw11_2    LIKE fiw_file.fiw11
  DEFINE l_i          LIKE type_file.num5          #No.FUN-680072 SMALLINT
  DEFINE  l_time LIKE type_file.chr8           #No.FUN-6A0068
 
  #MOD-C60051 mark----------------
  #IF g_fil.fil05 <> '2' THEN
  #   RETURN
  #END IF
  #MOD-C60051 mark end----------
 
  LET l_time=TIME
  LET g_fil.fil15=g_today
  LET g_fil.fil151=l_time[1,2],l_time[4,5]
  INPUT BY NAME g_fil.fil15,g_fil.fil151
        WITHOUT DEFAULTS
 
        AFTER FIELD fil151
            IF NOT cl_null(g_fil.fil151) THEN
               LET g_i=LENGTH(g_fil.fil151)
               IF g_i <> 4 THEN
                  CALL cl_err(g_fil.fil151,'aem-006',0)
                  NEXT FIELD fil151
               END IF
               IF g_fil.fil151 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fil.fil151[1,2] <'00' OR g_fil.fil151[1,2]>'23'
               OR g_fil.fil151[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fil.fil151,'aem-006',0)
                  NEXT FIELD fil151
               END IF
           END IF
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg 
            CALL cl_cmdask()
        #-----END TQC-860018-----
  END INPUT
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     LET g_fil.fil15=''
     LET g_fil.fil151=''
     DISPLAY BY NAME g_fil.fil15,g_fil.fil151
     RETURN
  END IF
 
  LET g_success='Y'
  BEGIN WORK
 
  UPDATE fil_file SET fil15=g_fil.fil15,fil151=g_fil.fil151
   WHERE fil01=g_fil.fil01
  IF SQLCA.sqlcode THEN
#    CALL cl_err('update fil15',SQLCA.sqlcode,0)   #No.FUN-660092
     CALL cl_err3("upd","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","update fil15",1)  #No.FUN-660092
     LET g_success='N'
  END IF
  DISPLAY BY NAME g_fil.fil15,g_fil.fil151
 
  UPDATE fia_file SET fia24=g_fil.fil19 WHERE fia01=g_fil.fil03
  IF SQLCA.sqlcode THEN
#    CALL cl_err('update fia24',SQLCA.sqlcode,0)   #No.FUN-660092
     CALL cl_err3("upd","fia_file",g_fil.fil03,"",SQLCA.sqlcode,"","update fia24",1)  #No.FUN-660092
     LET g_success='N'
  END IF
 
  #-----MOD-A10077---------
  #SELECT SUM(fiw11) INTO l_fiw11_1 FROM fiw_file,fiv_file
  # WHERE fiv01=fiw01 AND fiv02=g_fil.fil01 AND fiw09='Y' AND fivpost='Y'
  #   AND fiv00='1'   AND fivconf='Y'
  
  #SELECT SUM(fiw11) INTO l_fiw11_2 FROM fiw_file,fiv_file
  # WHERE fiv01=fiw01 AND fiv02=g_fil.fil01 AND fiw09='Y' AND fivpost='Y'
  #   AND fiv00='2'   AND fivconf='Y'
  
  #IF cl_null(l_fiw11_1) THEN LET l_fiw11_1=0 END IF
  #IF cl_null(l_fiw11_2) THEN LET l_fiw11_2=0 END IF
  #UPDATE fil_file SET fil17=l_fiw11_1-l_fiw11_2 WHERE fil01=g_fil.fil01
  #IF SQLCA.sqlcode THEN
  #   #CALL cl_err('update fil17',SQLCA.sqlcode,0)   #No.FUN-660092
  #   CALL cl_err3("upd","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","update fil17",1)  #No.FUN-660092
  #   LET g_success='N'
  #END IF
  #DISPLAY BY NAME g_fil.fil17
  
  #SELECT SUM(fiw11) INTO l_fiw11_1 FROM fiw_file,fiv_file
  # WHERE fiv01=fiw01 AND fiv02=g_fil.fil01 AND fiw09='N' AND fivpost='Y'
  #   AND fiv00='1'   AND fivconf='Y'
  
  #SELECT SUM(fiw11) INTO l_fiw11_2 FROM fiw_file,fiv_file
  # WHERE fiv01=fiw01 AND fiv02=g_fil.fil01 AND fiw09='N' AND fivpost='Y'
  #   AND fiv00='2'   AND fivconf='Y'
  
  #IF cl_null(l_fiw11_1) THEN LET l_fiw11_1=0 END IF
  #IF cl_null(l_fiw11_2) THEN LET l_fiw11_2=0 END IF
  #UPDATE fil_file SET fil18=l_fiw11_1-l_fiw11_2 WHERE fil01=g_fil.fil01
  #IF SQLCA.sqlcode THEN
  #   #CALL cl_err('update fil18',SQLCA.sqlcode,0)   #No.FUN-660092
  #   CALL cl_err3("upd","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","update fil18",1)  #No.FUN-660092
  #   LET g_success='N'
  #END IF
  #DISPLAY BY NAME g_fil.fil18
  
  #UPDATE fia_file SET fia23=(SELECT fil17+fil18 FROM fil_file
  #                            WHERE fil01=g_fil.fil01)
  # WHERE fia01=g_fil.fil03
  #IF SQLCA.sqlcode THEN
  #   #CALL cl_err('update fia23',SQLCA.sqlcode,0)   #No.FUN-660092
  #   CALL cl_err3("upd","fia_file",g_fil.fil03,"",SQLCA.sqlcode,"","update fia23",1)  #No.FUN-660092
  #   LET g_success='N'
  #END IF
  #-----END MOD-A10077-----
 
  UPDATE fil_file SET fil05='3' WHERE fil01=g_fil.fil01
  IF SQLCA.sqlcode THEN
#    CALL cl_err('update fil05',SQLCA.sqlcode,0)   #No.FUN-660092
     CALL cl_err3("upd","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","update fil05",1)  #No.FUN-660092
     LET g_success='N'
  ELSE
     LET g_fil.fil05='3'
     CALL i200_fil05()
     DISPLAY BY NAME g_fil.fil05
  END IF
 
  IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
 
END FUNCTION
 
FUNCTION i200_y()
    IF g_fil.fil01 IS NULL THEN RETURN END IF
#CHI-C30107 -------- add -------- begin
    IF g_fil.filacti='N' THEN
       CALL cl_err(g_fil.fil01,'mfg1000',0)
       RETURN
    END IF
    IF g_fil.filconf='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 -------- add -------- end
    SELECT * INTO g_fil.* FROM fil_file WHERE fil01=g_fil.fil01
    IF g_fil.filacti='N' THEN
       CALL cl_err(g_fil.fil01,'mfg1000',0)
       RETURN
    END IF
    IF g_fil.filconf='Y' THEN RETURN END IF
   #IF NOT cl_conf(17,12,'axm-108') THEN RETURN END IF   #TQC-750215 mark
#   IF NOT cl_confirm('axm-108') THEN RETURN END IF      #TQC-750215 mod #CHI-C30107 mark
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN i200_cl USING g_fil.fil01
    IF STATUS THEN
       CALL cl_err("OPEN i200_cl:", STATUS, 1)
       CLOSE i200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i200_cl INTO g_fil.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)
        CLOSE i200_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE fil_file SET filconf='Y'
     WHERE fil01 = g_fil.fil01
    IF STATUS THEN
#      CALL cl_err('upd filconf',STATUS,0)   #No.FUN-660092
       CALL cl_err3("upd","fil_file",g_fil.fil01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT filconf INTO g_fil.filconf FROM fil_file
     WHERE fil01 = g_fil.fil01
    DISPLAY BY NAME g_fil.filconf
END FUNCTION

#FUN-D30054-START-ADD
FUNCTION i200_uwf()
DEFINE l_i LIKE type_file.num5 

   IF g_fil.fil05='3' THEN

      IF NOT cl_confirm('axm-387') THEN RETURN END IF
      UPDATE fil_file SET fil15=' ',fil151 = ' '
      WHERE fil01=g_fil.fil01
      LET g_fil.fil15 = ' '
      LET g_fil.fil151 = ' '
      UPDATE fia_file SET fia24 = '0'
      WHERE fil01=g_fil.fil01

      SELECT COUNT(*) INTO l_i FROM fiv_file WHERE fiv02=g_fil.fil01 AND fivpost='Y'   
      IF l_i > 0 THEN
         UPDATE fil_file SET fil05='2'
         WHERE fil01=g_fil.fil01
         LET g_fil.fil05 = '2' 
      ELSE
         UPDATE fil_file SET fil05='1'
         WHERE fil01=g_fil.fil01 
         LET g_fil.fil05 = '1'
      END IF
      
      DISPLAY BY NAME g_fil.fil05,g_fil.fil15,g_fil.fil151
      CALL i200_fil05()            
   END IF
END FUNCTION
#FUN-D30054-END-ADD
 
FUNCTION i200_z()
DEFINE l_n LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    IF g_fil.fil01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fil.* FROM fil_file WHERE fil01=g_fil.fil01
    IF g_fil.filacti='N' THEN
       CALL cl_err(g_fil.fil01,'mfg1000',0)
       RETURN
    END IF
    IF g_fil.filconf='N' THEN RETURN END IF
 
    IF g_fil.fil05 <> '1' THEN
       CALL cl_err(g_fil.fil01,'aem-027',0)
       RETURN
    END IF
 
   #IF NOT cl_conf(17,12,'axm-109') THEN RETURN END IF  #TQC-750215 mark
    IF NOT cl_confirm('axm-109') THEN RETURN END IF     #TQC-750215 mod
 
    LET g_success='Y'
    BEGIN WORK
        OPEN i200_cl USING g_fil.fil01
        IF STATUS THEN
           CALL cl_err("OPEN i200_cl:", STATUS, 1)
           CLOSE i200_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH i200_cl INTO g_fil.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_fil.fil01,SQLCA.sqlcode,0)
            CLOSE i200_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE fil_file SET filconf='N'
            WHERE fil01 = g_fil.fil01
        IF STATUS THEN
#           CALL cl_err('upd cofconf',STATUS,0)   #No.FUN-660092
            CALL cl_err3("upd","fil_file",g_fil.fil01,"",STATUS,"","",1)  #No.FUN-660092
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT filconf INTO g_fil.filconf FROM fil_file
            WHERE fil01 = g_fil.fil01
        DISPLAY BY NAME g_fil.filconf
END FUNCTION
 
FUNCTION i200_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fil00,fil01",TRUE)
    END IF
    CALL cl_set_comp_entry("fil03",TRUE)
 
END FUNCTION
 
FUNCTION i200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fil00,fil01",FALSE)
    END IF
    IF g_fil.fil02 IS NOT NULL THEN
       CALL cl_set_comp_entry("fil03",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i200_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
      CALL cl_set_comp_entry("fim09,fim10",TRUE)
 
END FUNCTION
 
FUNCTION i200_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
      IF g_fim[l_ac].fim08 = 'N' THEN
         CALL cl_set_comp_entry("fim09,fim10",FALSE)
      END IF
 
END FUNCTION
 
FUNCTION i200_wr()
  DEFINE l_fim03  LIKE fim_file.fim03
  DEFINE l_fim02  LIKE fim_file.fim02
  DEFINE l_cnt    LIKE type_file.num5   #No.TQC-920111 add
 
 
    IF g_fil.fil05 MATCHES '[34]' THEN
       CALL cl_err(g_fil.fil01,'aem-024',0)
       RETURN
    END IF
    #No.TQC-920111 add --begin
    SELECT COUNT(*) INTO l_cnt FROM fim_file
     WHERE fim01 = g_fil.fil01
    IF l_cnt = 0 THEN   #單身沒有資料
       RETURN
    END IF
    #No.TQC-920111 add --end
{
    OPEN WINDOW i200_m_w AT 10,10           #顯示畫面
        WITH FORM "aem/42f/aemi200_m"
        ATTRIBUTE(STYLE = g_win_style)
    LET l_fim02 = 1
    INPUT l_fim02 WITHOUT DEFAULTS FROM fim02
       AFTER FIELD fim02
          SELECT fim03 INTO l_fim03 FROM fim_file
           WHERE fim01=g_fil.fil01 AND fim02=l_fim02
          IF SQLCA.sqlcode THEN
#            CALL cl_err(l_fim02,SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("sel","fim_file",g_fil.fil01,l_fim02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
             NEXT FIELD fim02
          END IF
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controlg 
            CALL cl_cmdask()
        #-----END TQC-860018-----
    END INPUT
    CLOSE WINDOW i200_m_w                    #結束畫面
 
    LET g_cmd = "aemi201"," '",g_fil.fil01 CLIPPED,"' '",l_fim03,"'"
}
    LET g_cmd = "aemi201"," '",g_fil.fil01 CLIPPED,"' '",g_fim[l_ac].fim03,"'"
    CALL cl_cmdrun(g_cmd)
END FUNCTION
#Patch....NO.MOD-5A0095 <001,002,003> #
#Patch....NO.TQC-610035 <001,002> #
