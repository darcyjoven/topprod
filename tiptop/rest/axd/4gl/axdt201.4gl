# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdt201.4gl
# Descriptions...: 集團調撥申請單
# Date & Author..: 03/10/08 By  Jack
# Modify      ...: 03/12/23 By Carrier
# Modify.........: No.MOD-4B0082 04/11/10 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY  將變數用Like方式定義
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.MOD-540145 05/05/10 By vivien  更新control-f的寫法
# Modify.........: NO.FUN-550026 05/05/21 By jackie 單據編號加大
# Modify.........: NO.FUN-580033 05/08/05 By Carrier 多單位內容修改
# Modify.........: No:MOD-590121 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No:TQC-610088 06/02/10 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-690022 06/09/19 By jamie 判斷imaacti
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_add           RECORD LIKE add_file.*,
    g_add_t         RECORD LIKE add_file.*,
    g_add01_t       LIKE add_file.add01,
    g_add_rowid     LIKE type_file.chr18,      #ROWID  #No.FUN-680108 INT
    g_t1            LIKE oay_file.oayslip,             #No.FUN-680108 VARCHAR(05)
    g_sheet         LIKE type_file.chr1000,            #No.FUN-680108 VARCHAR(5)
    g_ade           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variatpss)
        ade02       LIKE ade_file.ade02,   #項次
        ade16       LIKE ade_file.ade16,   #異動單號
        ade17       LIKE ade_file.ade17,   #異動單項次
        ade03       LIKE ade_file.ade03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ade04       LIKE ade_file.ade04,   #單位
        ade05       LIKE ade_file.ade05,   #數量
        #No.FUN-580033  --begin
        ade33       LIKE ade_file.ade33,   #單位二
        ade34       LIKE ade_file.ade34,   #單位二轉換率
        ade35       LIKE ade_file.ade35,   #單位二數量
        ade30       LIKE ade_file.ade30,   #單位一
        ade31       LIKE ade_file.ade31,   #單位一轉換率
        ade32       LIKE ade_file.ade32,   #單位一數量
        #No.FUN-580033  --end
        ade12       LIKE ade_file.ade12,   #撥出數量
        ade06       LIKE ade_file.ade06,   #需求工廠
        ade07       LIKE ade_file.ade07,   #撥入倉
        ade15       LIKE ade_file.ade15,   #已撥入量
        ade08       LIKE ade_file.ade08,   #需求日期
        ade09       LIKE ade_file.ade09,   #回復日期
        ade10       LIKE ade_file.ade10,   #預調日期
        ade11       LIKE ade_file.ade11,   #注記
        ade13       LIKE ade_file.ade13,   #結案否
        ade14       LIKE ade_file.ade14    #結案日期
                    END RECORD,
    g_ade_t         RECORD                 #程式變數 (舊值)
        ade02       LIKE ade_file.ade02,   #項次
        ade16       LIKE ade_file.ade16,   #異動單號
        ade17       LIKE ade_file.ade17,   #異動單項次
        ade03       LIKE ade_file.ade03,   #產品編號
        ima02       LIKE ima_file.ima02,   #品名
        ade04       LIKE ade_file.ade04,   #單位
        ade05       LIKE ade_file.ade05,   #數量
        #No.FUN-580033  --begin
        ade33       LIKE ade_file.ade33,   #單位二
        ade34       LIKE ade_file.ade34,   #單位二轉換率
        ade35       LIKE ade_file.ade35,   #單位二數量
        ade30       LIKE ade_file.ade30,   #單位一
        ade31       LIKE ade_file.ade31,   #單位一轉換率
        ade32       LIKE ade_file.ade32,   #單位一數量
        #No.FUN-580033  --end
        ade12       LIKE ade_file.ade12,   #撥出數量
        ade06       LIKE ade_file.ade06,   #需求工廠
        ade07       LIKE ade_file.ade07,   #撥入倉
        ade15       LIKE ade_file.ade15,   #已撥入量
        ade08       LIKE ade_file.ade08,   #需求日期
        ade09       LIKE ade_file.ade09,   #回復日期
        ade10       LIKE ade_file.ade10,   #預調日期
        ade11       LIKE ade_file.ade11,   #注記
        ade13       LIKE ade_file.ade13,   #結案否
        ade14       LIKE ade_file.ade14    #結案日期
                    END RECORD,
    g_ade18         LIKE ade_file.ade18,
    g_ade19         LIKE ade_file.ade19,
    g_ade20         LIKE ade_file.ade20,
    g_argv1         LIKE add_file.add00,
    g_argv2         LIKE add_file.add01,
    g_azp01         LIKE azp_file.azp01,
    g_type          LIKE adz_file.adztype,             #No.FUN-680108 VARCHAR(02) 
    g_wc,g_wc2,g_sql    string,  #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,   #單身筆數   #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT   #No.FUN-680108 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5           #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5       #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE NOWAIT SQL    
DEFINE   g_cnt      LIKE type_file.num10          #No.FUN-680108 INTEGER
DEFINE   g_chr      LIKE add_file.addacti         #No.FUN-680108 VARCHAR(01)
DEFINE   g_i        LIKE type_file.num5   #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE   g_msg      LIKE type_file.chr1000        #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10      #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10      #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10      #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5       #No.FUN-680108 SMALLINT

#FUN-580033  --begin
DEFINE
    g_change        LIKE type_file.chr1,     #No.FUN-680108 VARCHAR(01)
    g_ima906        LIKE ima_file.ima906,
    g_ima907        LIKE ima_file.ima907,
    g_ima25         LIKE img_file.img09,
    g_sw            LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    g_factor        LIKE inb_file.inb08_fac,
    g_tot           LIKE img_file.img10,
    g_flag          LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
    g_qty           LIKE img_file.img10
#FUN-580033  --end

#主程式開始
MAIN
#DEFINE                                          #No.FUN-6A0091      
#       l_time    LIKE type_file.chr8            #No.FUN-6A0091

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091

    LET g_argv1 = ARG_VAL(1)               #參數-1(詢價單號)
    LET g_argv2 = ARG_VAL(2)               #參數-1(詢價單號)
    SELECT azp01 INTO g_azp01 FROM azp_file WHERE azp01 = g_plant
    LET g_forupd_sql =
       "SELECT * FROM add_file WHERE ROWID = ? FOR UPDATE NOWAIT"
    DECLARE t201_cl CURSOR FROM g_forupd_sql

    LET p_row = 4 LET p_col = 5

    OPEN WINDOW t201_w AT p_row,p_col WITH FORM "axd/42f/axdt201"
         ATTRIBUTE(STYLE = g_win_style)

    CALL cl_ui_init()

    CALL g_x.clear()

    #No.FUN-580033  --begin
    CALL t201_mu_ui()
    #No.FUN-580033  --end

    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       CALL t201_q()
    END IF
    CALL t201_menu()

    CLOSE WINDOW t201_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION t201_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_ade.clear()

    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       LET g_wc = " add00 = '",g_argv1,"' AND add01 = '",g_argv2,"'"
    ELSE
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_add.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           add00,add01,add02,add03,add04,add05,add06,addmksg,addsign,
           add07,add08,addconf,adduser,addgrup,addmodu,adddate,addacti

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE WHEN INFIELD(add01)
#                    LET g_t1=g_add.add01[1,3]
                    LET g_t1 = s_get_doc_no(g_add.add01)       #No.FUN-550026
                    #CALL q_adz(FALSE,TRUE,g_t1,g_type,'axd') #TQC-670008 remark
                    CALL q_adz(FALSE,TRUE,g_t1,g_type,'AXD')  #TQC-670008
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO add01
                    NEXT FIELD add01
                WHEN INFIELD(add03)
                    #CALL q_gen(0,0,g_add.add03) RETURNING g_add.add03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO add03
                    NEXT FIELD add03
                WHEN INFIELD(add04)
                    #CALL q_gem(0,0,g_add.add04) RETURNING g_add.add04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO add04
                    NEXT FIELD add04
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No:FUN-580031 --end--       HCN
      END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    END IF
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
       LET g_wc = g_wc clipped," AND adduser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
       LET g_wc = g_wc clipped," AND addgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
       LET g_wc = g_wc clipped," AND addgrup IN ",cl_chk_tgrup_list()
    END IF


    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       LET g_wc2=" 1=1"
    ELSE
    #No.FUN-580033  --begin
    CONSTRUCT g_wc2 ON ade02,ade16,ade17,ade03,ade04,ade05, #螢幕上取單身條件
                       ade33,ade35,ade30,ade32,
                          ade12,ade06,ade07,ade15,ade08,ade09,
                          ade10,ade11,ade13,ade14
               FROM s_ade[1].ade02,s_ade[1].ade16,s_ade[1].ade17,
                    s_ade[1].ade03,s_ade[1].ade04,s_ade[1].ade05,
                    s_ade[1].ade33,s_ade[1].ade35,s_ade[1].ade30,
                    s_ade[1].ade32,
                    s_ade[1].ade12,s_ade[1].ade06,s_ade[1].ade07,
                    s_ade[1].ade15,s_ade[1].ade08,s_ade[1].ade09,
                    s_ade[1].ade10,s_ade[1].ade11,s_ade[1].ade13,
                    s_ade[1].ade14
    #No.FUN-580033  --end

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ade16) #異動單號
                  #CALL q_adi(5,3,g_ade[l_ac].ade16,g_ade[l_ac].ade17,
                  #           g_add.add02,'2')
                  #     RETURNING g_ade[l_ac].ade16,g_ade[l_ac].ade17
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adi"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1=2
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade16
                  NEXT FIELD ade16
               WHEN INFIELD(ade03) #料件編號
                  #CALL q_ima(10,3,g_ade[l_ac].ade03)
                  #     RETURNING g_ade[l_ac].ade03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade03
                  NEXT FIELD ade03
               WHEN INFIELD(ade04) #單位
                  #CALL q_gfe(10,3,g_ade[l_ac].ade04)
                   #   RETURNING g_ade[l_ac].ade04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade04
                  NEXT FIELD ade04
               WHEN INFIELD(ade06)   #工廠
                  #CALL q_adb2(10,3,g_ade[l_ac].ade06,g_plant)
                  #     RETURNING g_ade[l_ac].ade06
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adb2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade06
                  NEXT FIELD ade06
               WHEN INFIELD(ade07)   #倉庫
                  #CALL q_adc(10,3,g_ade[l_ac].ade07,g_ade[l_ac].ade06,'S')
                  #     RETURNING g_ade[l_ac].ade07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adc"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_ade[l_ac].ade06
                  LET g_qryparam.arg2 = 'S'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade07
                  NEXT FIELD ade07
              #No.FUN-580033  --begin
              WHEN INFIELD(ade33)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ade33
                 NEXT FIELD ade33
              WHEN INFIELD(ade30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ade30
                 NEXT FIELD ade30
              #No.FUN-580033  --end
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
      END CONSTRUCT
    END IF
    IF INT_FLAG THEN RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ROWID, add01 FROM add_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 2"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE add_file.ROWID, add01 ",
                   "  FROM add_file, ade_file ",
                   " WHERE add01 = ade01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 2"
    END IF

    PREPARE t201_prepare FROM g_sql
    DECLARE t201_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t201_prepare

    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM add_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT add01) FROM add_file,ade_file WHERE ",
                  "ade01=add01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t201_precount FROM g_sql
    DECLARE t201_count CURSOR FOR t201_precount

END FUNCTION

#中文的MENU
FUNCTION t201_menu()

   WHILE TRUE
      CALL t201_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL t201_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL t201_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL t201_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t201_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL t201_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL t201_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t201_y()
                CALL cl_set_field_pic(g_add.addconf,"","",g_add.add07,"",g_add.addacti)  #NO.MOD-4B0082
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t201_z()
                CALL cl_set_field_pic(g_add.addconf,"","",g_add.add07,"",g_add.addacti)  #NO.MOD-4B0082
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t201_x()
                CALL cl_set_field_pic(g_add.addconf,"","",g_add.add07,"",g_add.addacti)  #NO.MOD-4B0082
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t201_out('o')
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No:FUN-6A0165-------add--------str----
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_add.add01 IS NOT NULL THEN
                LET g_doc.column1 = "add01"
                LET g_doc.value1 = g_add.add01
                CALL cl_doc()
              END IF
        END IF
        #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION t201_a()
DEFINE li_result   LIKE type_file.num5        #No.FUN-550026        #No.FUN-680108 SMALLINT
    MESSAGE ""
    CLEAR FORM
    CALL g_ade.clear()

    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_add.* LIKE add_file.*        #DEFAULT 設定
    LET g_add01_t = NULL
    LET g_add_t.* = g_add.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_add.add00 = '1'
        LET g_add.add02 = g_today
        LET g_add.add06 = '0'   #狀態碼
        LET g_add.add07 = 'N'   #結案碼
        LET g_add.add03 = g_user
        LET g_add.add04 = g_grup
        LET g_add.addconf= 'N'
        LET g_add.adduser=g_user
        LET g_add.addgrup=g_grup
        LET g_add.adddate=g_today
        LET g_add.addacti='Y'              #資料有效
        CALL t201_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_add.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_add.add01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK
#No.FUN-550026 --start--
        CALL s_auto_assign_no("axd",g_add.add01,g_add.add02,g_type,"add_file","add01","","","")
             RETURNING li_result,g_add.add01
        IF (NOT li_result) THEN
              ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_add.add01
{
        IF g_adz.adzauno='Y' THEN #自動賦予銷單編號
           CALL s_axdauno(g_add.add01,g_add.add02)
                RETURNING g_i,g_add.add01
           IF g_i THEN
              ROLLBACK WORK
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_add.add01
        END IF
}
#No.FUN-550026 ---end--
        INSERT INTO add_file VALUES (g_add.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_add.add01,SQLCA.sqlcode,1)
           CONTINUE WHILE
        END IF
        COMMIT WORK
        SELECT ROWID INTO g_add_rowid FROM add_file
            WHERE add01 = g_add.add01
        LET g_add01_t = g_add.add01        #保留舊值
        LET g_add_t.* = g_add.*

        CALL g_ade.clear()
        LET g_rec_b=0
        CALL t201_b()                   #輸入單身
        SELECT * FROM add_file WHERE add01 = g_add.add01
        IF SQLCA.sqlcode = 0 THEN
           IF g_adz.adzconf = 'Y' THEN CALL t201_y() END IF
           IF g_adz.adzprnt = 'Y' THEN CALL t201_prt() END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION t201_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_add.add01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_add.addconf = 'Y' THEN CALL cl_err("","9022",0) RETURN END IF
    IF g_add.add07 = 'Y' THEN CALL cl_err("","aap-730",0) RETURN END IF
    SELECT * INTO g_add.* FROM add_file WHERE add01=g_add.add01
    IF g_add.addacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_add.add01,'mfg1000',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_add01_t = g_add.add01
    LET g_add_t.* = g_add.*
    BEGIN WORK
    OPEN t201_cl USING g_add_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_add.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_add.add01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t201_cl
        ROLLBACK WORK
        RETURN
    END IF
    LET g_add.addmodu=g_user
    LET g_add.adddate=g_today
    CALL t201_show()
    WHILE TRUE
        CALL t201_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_add.*=g_add_t.*
            CALL t201_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_add.add01 != g_add01_t THEN            # 更改單號
            UPDATE ade_file
               SET ade01 = g_add.add01
             WHERE ade01 = g_add01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err('ade',SQLCA.sqlcode,0)
                CONTINUE WHILE
            END IF
        END IF
        UPDATE add_file
           SET add_file.* = g_add.*
         WHERE ROWID = g_add_rowid
        IF SQLCA.sqlcode OR STATUS = 100 THEN
            CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION

#處理INPUT
FUNCTION t201_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_gem02   LIKE gem_file.gem02,
    l_gen02   LIKE gen_file.gen02,
    l_cr      LIKE type_file.chr1000,               #No.FUN-680108 VARCHAR(4)
    l_n       LIKE type_file.num5,                  #No.FUN-680108 SMALLINT
    l_sw      LIKE type_file.chr1,                  #No.FUN-680108 VARCHAR(01)
    p_cmd     LIKE type_file.chr1    #a:輸入 u:更改 #No.FUN-680108 VARCHAR(1)
DEFINE li_result LIKE type_file.num5    #No.FUN-550026   #No.FUN-680108 SMALLINT 

   IF s_shut(0) THEN RETURN END IF
   CALL t201_add06()
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INPUT BY NAME
     g_add.add00,g_add.add01,g_add.add02,g_add.add03,g_add.add04,g_add.add05,
        g_add.add06,g_add.addmksg,g_add.addsign,g_add.add07,g_add.add08,
        g_add.addconf,g_add.adduser,g_add.addgrup,
        g_add.addmodu,g_add.adddate,g_add.addacti
        WITHOUT DEFAULTS HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t201_set_entry(p_cmd)
            CALL t201_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550026 --start--
         CALL cl_set_docno_format("add01")
#No.FUN-550026 ---end---

        AFTER FIELD add00
            IF NOT cl_null(g_add.add00) THEN
               CALL t201_add00()
               IF g_add.add00 = '1' THEN LET g_type = '10' END IF
               IF g_add.add00 = '2' THEN LET g_type = '11' END IF
               IF g_add.add00 = '3' THEN LET g_type = '12' END IF
            END IF

        AFTER FIELD add01
            IF NOT cl_null(g_add.add01) AND (g_add.add01!=g_add01_t) THEN
#No.FUN-550026 --start--
              CALL s_check_no("axd",g_add.add01,g_add01_t,g_type,"add_file","add01","")
                   RETURNING li_result,g_add.add01
              DISPLAY BY NAME g_add.add01
              IF (NOT li_result) THEN
                  NEXT FIELD add01
              END IF
{
               LET g_t1=g_add.add01[1,3]
               SELECT * INTO g_adz.* FROM adz_file
                WHERE adzslip = g_t1 AND adztype = g_type
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_add.add01,'mfg0014',0)
                  NEXT FIELD add01
               END IF
}
               LET g_add.addmksg = g_adz.adzapr
               LET g_add.addsign = g_adz.adzsign
               DISPLAY BY NAME g_add.addmksg,g_add.addsign
{
               IF p_cmd = 'a' AND cl_null(g_add.add01[5,10]) AND g_adz.adzauno='N' THEN
                  NEXT FIELD add01
               END IF
               IF g_add.add01 != g_add_t.add01 OR g_add_t.add01 IS NULL THEN
                  IF g_adz.adzauno = 'Y' AND NOT cl_chk_data_continue(g_add.add01[5,10]) THEN
                     CALL cl_err('','9056',0)
                     NEXT FIELD add01
                  END IF
                  SELECT COUNT(*) INTO g_cnt FROM add_file
                   WHERE add01 = g_add.add01
                  IF g_cnt > 0 THEN   #資料重復
                     CALL cl_err(g_add.add01,-239,0)
                     LET g_add.add01 = g_add_t.add01
                     DISPLAY BY NAME g_add.add01
                     NEXT FIELD add01
                  END IF
               END IF
}
#No.FUN-550026 ---end--
            END IF

        AFTER FIELD add03        #員工
            IF NOT cl_null(g_add.add03) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_add.add03 != g_add_t.add03) THEN
                  CALL t201_add03('a')
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(g_add.add03,g_errno,0)
                     LET g_add.add03 = g_add_t.add03
                     DISPLAY BY NAME g_add.add03
                     NEXT FIELD add03
                  END IF
                  SELECT gen03 INTO g_add.add04 FROM gen_file
                   WHERE gen01 = g_add.add03
                  DISPLAY BY NAME g_add.add03
                  DISPLAY BY NAME g_add.add04
               END IF
            END IF

        AFTER FIELD add04           #部門
            IF NOT cl_null(g_add.add04) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_add.add04 != g_add_t.add04) THEN
                  CALL t201_add04('a')
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err(g_add.add04,g_errno,0)
                     LET g_add.add04 = g_add_t.add04
                     DISPLAY BY NAME g_add.add04
                     NEXT FIELD add04
                  END IF
               END IF
            END IF

        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLF                 #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

        ON ACTION CONTROLP
           CASE WHEN INFIELD(add01)
#                    LET g_t1=g_add.add01[1,3]
                    LET g_t1 = s_get_doc_no(g_add.add01)       #No.FUN-550026
                    #CALL q_adz(FALSE,FALSE,g_t1,g_type,'axd') RETURNING g_t1  #TQC-670008 remark
                    CALL q_adz(FALSE,FALSE,g_t1,g_type,'AXD') RETURNING g_t1   #TQC-670008
#                    LET g_add.add01[1,3]=g_t1
                    LET g_add.add01=g_t1               #No.FUN-550026
                    DISPLAY BY NAME g_add.add01
                    NEXT FIELD add01
                WHEN INFIELD(add03)
                    #CALL q_gen(0,0,g_add.add03) RETURNING g_add.add03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_add.add03
                    CALL cl_create_qry() RETURNING g_add.add03
#                    CALL FGL_DIALOG_SETBUFFER( g_add.add03 )
                    DISPLAY BY NAME g_add.add03
                    NEXT FIELD add03
                WHEN INFIELD(add04)
                    #CALL q_gem(0,0,g_add.add04) RETURNING g_add.add04
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_add.add04
                    CALL cl_create_qry() RETURNING g_add.add04
#                    CALL FGL_DIALOG_SETBUFFER( g_add.add04 )
                    DISPLAY BY NAME g_add.add04
                    NEXT FIELD add04
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

FUNCTION t201_add00()
    CASE g_add.add00
        WHEN '1' LET g_msg= cl_getmsg('axd-082',g_lang)
        WHEN '2' LET g_msg= cl_getmsg('axd-083',g_lang)
        WHEN '3' LET g_msg= cl_getmsg('axd-084',g_lang)
    END CASE
    DISPLAY g_msg TO FORMONLY.e
END FUNCTION

FUNCTION t201_add03(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gen02     LIKE gen_file.gen02,
        l_gen03     LIKE gen_file.gen03,
        l_genacti   LIKE gen_file.genacti

  LET g_errno = ' '
  SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
    FROM gen_file
   WHERE gen01 = g_add.add03

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                                 LET g_add.add03 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
     IF cl_null(g_add.add04) THEN LET g_add.add04 = l_gen03 END IF
     DISPLAY BY NAME g_add.add04
  END IF
END FUNCTION

FUNCTION t201_add04(p_cmd)    #部門
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gem02     LIKE gem_file.gem02,
        l_gemacti   LIKE gem_file.gemacti

  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
   WHERE gem01 = g_add.add04

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET g_add.add04 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION

FUNCTION t201_add06()
    DEFINE l_str  LIKE type_file.chr8               #No.FUN-680108 VARCHAR(08) 

    CASE g_add.add06
         WHEN '0' CALL cl_getmsg('apy-558',g_lang) RETURNING l_str
         WHEN '1' CALL cl_getmsg('apy-559',g_lang) RETURNING l_str
         WHEN 'S' CALL cl_getmsg('apy-561',g_lang) RETURNING l_str
         WHEN 'R' CALL cl_getmsg('apy-562',g_lang) RETURNING l_str
         WHEN 'W' CALL cl_getmsg('apy-563',g_lang) RETURNING l_str
    END CASE
    DISPLAY l_str TO FORMONLY.desc

END FUNCTION

#Query 查詢
FUNCTION t201_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )

    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_ade.clear()
    DISPLAY '   ' TO FORMONLY.cnt           #ATTRIBUTE(YELLOW)
    CALL t201_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_add.* TO NULL
        RETURN
    END IF

    OPEN t201_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_add.* TO NULL
    ELSE
        OPEN t201_count
        FETCH t201_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t201_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION t201_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-680108 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     t201_cs INTO g_add_rowid,g_add.add01
        WHEN 'P' FETCH PREVIOUS t201_cs INTO g_add_rowid,g_add.add01
        WHEN 'F' FETCH FIRST    t201_cs INTO g_add_rowid,g_add.add01
        WHEN 'L' FETCH LAST     t201_cs INTO g_add_rowid,g_add.add01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
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
             FETCH ABSOLUTE g_jump t201_cs INTO g_add_rowid,g_add.add01
             LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
       CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
       INITIALIZE g_add.* TO NULL              #No.FUN-6A0165
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

    SELECT * INTO g_add.* FROM add_file WHERE ROWID = g_add_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
        INITIALIZE g_add.* TO NULL
        RETURN
    ELSE
       LET g_data_owner=g_add.adduser           #FUN-4C0052權限控管
       LET g_data_group=g_add.addgrup
    END IF
    CALL t201_show()
END FUNCTION

#將資料顯示在畫面上
FUNCTION t201_show()
    LET g_add_t.* = g_add.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
     g_add.add00,g_add.add01,g_add.add02,g_add.add03,g_add.add04,
        g_add.add05,g_add.add06,g_add.addmksg,g_add.addsign,
        g_add.add07,g_add.add08,g_add.addconf,
        g_add.adduser,g_add.addgrup,g_add.addmodu,
        g_add.adddate,g_add.addacti
     CALL cl_set_field_pic(g_add.addconf,"","",g_add.add07,"",g_add.addacti)  #NO.MOD-4B0082
    CALL t201_add00()
    CALL t201_add03('d')
    CALL t201_add04('d')
    CALL t201_add06()
    CALL t201_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION t201_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_add.add01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_add.addconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_add.add01,'9022',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t201_cl USING g_add_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_add.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_add.add01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t201_show()
    IF cl_exp(0,0,g_add.addacti) THEN                   #確認一下
        LET g_chr=g_add.addacti
        IF g_add.addacti='Y' THEN
            LET g_add.addacti='N'
        ELSE
            LET g_add.addacti='Y'
        END IF
        UPDATE add_file
           SET addacti=g_add.addacti, #更改有效碼
               addmodu=g_user,
               adddate=g_today
         WHERE add01=g_add.add01
        IF SQLCA.sqlcode OR STATUS=100 THEN
            CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
            LET g_add.addacti=g_chr
        END IF
        SELECT addacti,addmodu,adddate
          INTO g_add.addacti,g_add.addmodu,g_add.adddate FROM add_file
         WHERE add01=g_add.add01
        DISPLAY BY NAME g_add.addacti,g_add.addmodu,g_add.adddate
                ATTRIBUTE(RED)
    END IF
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION

#取消整筆 (所有合乎單頭的資料)
FUNCTION t201_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_add.add01 IS NULL  THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_add.addconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_add.add01,'9022',0)
        RETURN
    END IF
    IF g_add.add07 = 'Y' THEN
       CALL cl_err("","aap-730",0)
       RETURN
    END IF
    SELECT * INTO g_add.* FROM add_file
     WHERE add01=g_add.add01
    IF g_add.addacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_add.add01,'mfg1000',0)
        RETURN
    END IF
    BEGIN WORK
    OPEN t201_cl USING g_add_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_add.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_add.add01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t201_show()
    IF cl_delh(0,0) THEN                   #確認一下
            DELETE FROM add_file WHERE add01 = g_add.add01
            DELETE FROM ade_file WHERE ade01 = g_add.add01
            CLEAR FORM
            CALL g_ade.clear()
--mi
         OPEN t201_count
         FETCH t201_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t201_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t201_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t201_fetch('/')
         END IF
--#
    END IF
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION

#單身
FUNCTION t201_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重復用  #No.FUN-680108 SMALLINT
    l_cnt           LIKE type_file.num5,    #檢查重復用  #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態    #No.FUN-680108 VARCHAR(1)
    l_adi10         LIKE adi_file.adi10,
    l_ade12         LIKE ade_file.ade12,
    l_azp02         LIKE azp_file.azp02,
    l_imd02         LIKE imd_file.imd02,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_azp03         LIKE azp_file.azp03,
    l_misc          LIKE type_file.chr1000, #No.FUN-680108 VARCHAR(04)
    l_allow_insert  LIKE type_file.num5,   #可新增否        #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否        #No.FUN-680108 SMALLINT

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    IF g_add.add01 IS NULL THEN RETURN END IF
    SELECT * INTO g_add.* FROM add_file WHERE add01=g_add.add01
    IF g_add.addacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_add.add01,'mfg1000',0) RETURN
    END IF
    IF g_add.addconf ='Y' THEN    #檢查資料是否為審核
        CALL cl_err(g_add.add01,'9022',0) RETURN
    END IF
    IF g_add.add07 = 'Y' THEN
       CALL cl_err("","aap-730",0) RETURN
    END IF

    CALL cl_opmsg('b')

    #No.FUN-580033  --begin
    LET g_forupd_sql = "SELECT ade02,ade16,ade17,ade03,'',ade04,ade05, ",
                             " ade33,ade34,ade35,ade30,ade31,ade32, ",
                             " ade12,ade06,ade07,ade15,ade08,ade09,ade10, ",
                             " ade11,ade13,ade14,ade18,ade19,ade20 ",
                         "FROM ade_file ",
                       " WHERE ade01=? AND ade02=? ",
                         " FOR UPDATE NOWAIT "
    #No.FUN-580033  --end
    DECLARE t201_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR

      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")

      INPUT ARRAY g_ade WITHOUT DEFAULTS FROM s_ade.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'

            BEGIN WORK
            OPEN t201_cl USING g_add_rowid
            IF STATUS THEN
               CALL cl_err('OPEN t201_cl:',STATUS,1)
               CLOSE t201_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t201_cl INTO g_add.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_add.add01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t201_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ade_t.* = g_ade[l_ac].*  #BACKUP
               OPEN t201_b_cl USING g_add.add01,g_ade_t.ade02
               IF STATUS THEN
                  CALL cl_err('OPEN t201_b_cl:', STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH t201_b_cl INTO g_ade[l_ac].*,g_ade18,g_ade19,g_ade20
                  IF SQLCA.sqlcode THEN
                      CALL cl_err(g_ade_t.ade02,SQLCA.sqlcode,1)
                      LET l_lock_sw = 'Y'
                  END IF
                  IF cl_null(g_ade18) THEN
                     SELECT ima96 INTO g_ade18 FROM ima_file
                      WHERE ima01=g_ade[l_ac].ade03
                  END IF
                  SELECT ima02 INTO g_ade[l_ac].ima02 FROM ima_file
                   WHERE ima01 = g_ade[l_ac].ade03
               END IF
               #No.FUN-580033  --begin
               LET g_change='N'
               #No.FUN-580033  --end
               CALL t201_set_entry_b(p_cmd)
               CALL t201_set_no_entry_b(p_cmd)
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_ade[l_ac].* TO NULL      #900423
            INITIALIZE g_ade18 TO NULL
            INITIALIZE g_ade19 TO NULL
            INITIALIZE g_ade20 TO NULL
            LET g_ade_t.* = g_ade[l_ac].*         #新輸入資料
            LET g_ade[l_ac].ade16 = ' '
            LET g_ade[l_ac].ade17 = ' '
            LET g_ade[l_ac].ade13 = 'N'
            LET g_ade[l_ac].ade12 = 0
            LET g_ade[l_ac].ade15 = 0
            #No.FUN-580033  --begin
            LET g_ade[l_ac].ade31=1
            LET g_ade[l_ac].ade34=1
            LET g_change='Y'
            #No.FUN-580033  --end
            CALL t201_set_entry_b(p_cmd)
            CALL t201_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ade02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-580033  --begin
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_ade[l_ac].ade03)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD ade03
               END IF
               CALL t201_du_data_to_correct()
            END IF
            CALL t201_set_origin_field()
            INSERT INTO ade_file(ade01,ade02,ade03,ade04,ade05,
                                 ade06,ade07,ade08,ade09,ade10,
                                 ade11,ade12,ade13,ade14,ade15,
                                 ade16,ade17,ade18,ade19,ade20,
                                 ade30,ade31,ade32,ade33,ade34,ade35)
            VALUES(g_add.add01,g_ade[l_ac].ade02,
                   g_ade[l_ac].ade03,g_ade[l_ac].ade04,
                   g_ade[l_ac].ade05,g_ade[l_ac].ade06,
                   g_ade[l_ac].ade07,g_ade[l_ac].ade08,
                   g_ade[l_ac].ade09,g_ade[l_ac].ade10,
                   g_ade[l_ac].ade11,g_ade[l_ac].ade12,
                   g_ade[l_ac].ade13,g_ade[l_ac].ade14,
                   g_ade[l_ac].ade15,g_ade[l_ac].ade16,
                   g_ade[l_ac].ade17,g_ade18,g_ade19,g_ade20,
                   g_ade[l_ac].ade30,g_ade[l_ac].ade31,
                   g_ade[l_ac].ade32,g_ade[l_ac].ade33,
                   g_ade[l_ac].ade34,g_ade[l_ac].ade35)
            #No.FUN-580033
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_ade[l_ac].ade02,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                IF g_aza.aza40='Y' THEN  #NO.A112
                   IF g_add.add00<>'1' THEN   #銷售預測
                      CALL t201_m()
                   END IF
                END IF  #NO.A112
                COMMIT WORK
            END IF

        BEFORE FIELD ade02                        #default 序號
            IF g_ade[l_ac].ade02 IS NULL OR g_ade[l_ac].ade02 = 0 THEN
               SELECT MAX(ade02)+1 INTO g_ade[l_ac].ade02 FROM ade_file
                WHERE ade01 = g_add.add01
               IF g_ade[l_ac].ade02 IS NULL THEN
                  LET g_ade[l_ac].ade02 = 1
               END IF
            END IF

        AFTER FIELD ade02                        #check 序號是否重復
            IF NOT cl_null(g_ade[l_ac].ade02)THEN
               IF g_ade[l_ac].ade02 != g_ade_t.ade02 OR
                  g_ade_t.ade02 IS NULL THEN
                  SELECT COUNT(*) INTO l_n FROM ade_file
                   WHERE ade01 = g_add.add01
                     AND ade02 = g_ade[l_ac].ade02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_ade[l_ac].ade02 = g_ade_t.ade02
                     NEXT FIELD ade02
                  END IF
               END IF
            END IF

        #No.FUN-580033  --begin
        BEFORE FIELD ade17
           CALL t201_set_entry_b(p_cmd)
           CALL t201_set_no_required()
        #No.FUN-580033  --end

        AFTER FIELD ade17
            IF NOT cl_null(g_ade[l_ac].ade17) THEN
               #No.FUN-580033  --begin
               SELECT adi05,adi09,adi10-adi17,pmm09,adi18,adi19,adi20, #外部撥入單
                      adi30,adi31,adi32,adi33,adi34,adi35
                 INTO g_ade[l_ac].ade03,g_ade[l_ac].ade04,
                      g_ade[l_ac].ade05,g_ade[l_ac].ade06,
                      g_ade18,g_ade19,g_ade20,
                      g_ade[l_ac].ade30,g_ade[l_ac].ade31,
                      g_ade[l_ac].ade32,g_ade[l_ac].ade33,
                      g_ade[l_ac].ade34,g_ade[l_ac].ade35
               #No.FUN-580033  --end
                 FROM adh_file,adi_file,pmm_file
                WHERE adh01 = adi01 AND adh00 = '2'   #外部撥入
                  AND adhpost = 'Y' AND adh06 <= g_add.add02
                  AND adhacti = 'Y' AND adhconf = 'Y'
                  AND adi01 = g_ade[l_ac].ade16 AND adi02 = g_ade[l_ac].ade17
                  AND pmm01 = adi15
               IF SQLCA.sqlcode = 100 THEN
                  CALL cl_err(g_ade[l_ac].ade16,'axd-072',0)
                  NEXT FIELD ade16
               END IF
               LET l_adi10=g_ade[l_ac].ade05
               IF cl_null(g_ade[l_ac].ade03) THEN NEXT FIELD ade16 END IF
               #No.FUN-580033  --begin
               SELECT ima02,ima25,ima906,ima907
                 INTO g_ade[l_ac].ima02,g_ima25,g_ima906,g_ima907
                 FROM ima_file WHERE ima01 = g_ade[l_ac].ade03
               #No.FUN-580033  --end
            END IF
            #No.FUN-580033  --begin
            CALL t201_set_no_entry_b(p_cmd)
            CALL t201_set_required()
            #No.FUN-580033  --end

        BEFORE FIELD ade03
           #No.FUN-580033  --begin
           CALL t201_set_entry_b(p_cmd)
           CALL t201_set_no_required()
           #No.FUN-580033  --end

        AFTER FIELD ade03
            IF g_ade_t.ade03 IS NULL OR
              (g_ade[l_ac].ade03 != g_ade_t.ade03 ) THEN
               CALL t201_ade03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ade[l_ac].ade03,g_errno,0)
                  LET g_ade[l_ac].ade03 = g_ade_t.ade03
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_ade[l_ac].ade03
                  #------MOD-5A0095 END------------
                  NEXT FIELD ade03
               END IF
               SELECT ima96 INTO g_ade18 FROM ima_file
                WHERE ima01=g_ade[l_ac].ade03
               #No.FUN-580033  --begin
                  LET g_change = 'Y'
            END IF
            #No.FUN-580033  --begin
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_ade[l_ac].ade03)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD ade03
               END IF
               IF g_ima906 = '3' THEN
                  LET g_ade[l_ac].ade33=g_ima907
               END IF
            END IF
            CALL t201_du_default(p_cmd)
            CALL t201_set_no_entry_b(p_cmd)
            CALL t201_set_required()
            #No.FUN-580033  --end

        AFTER FIELD ade04                  #單位
            IF NOT cl_null(g_ade[l_ac].ade04) THEN
               SELECT gfe01 FROM gfe_file WHERE  gfe01= g_ade[l_ac].ade04
               IF STATUS THEN
                  CALL cl_err(g_ade[l_ac].ade04,STATUS ,0)
                  LET g_ade[l_ac].ade04 = g_ade_t.ade04
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_ade[l_ac].ade04
                  #------MOD-5A0095 END------------
                  NEXT FIELD ade04
               END IF
            END IF

     AFTER FIELD ade05   #數量
            IF NOT cl_null(g_ade[l_ac].ade05) THEN
               IF g_ade[l_ac].ade05 <=0 THEN
                  NEXT FIELD ade05
               END IF
               IF g_add.add00 = '3' THEN
                  IF g_ade[l_ac].ade05 > l_adi10 THEN
                     CALL cl_err(g_ade[l_ac].ade05,'axd-071',0)
                     LET g_ade[l_ac].ade05 = g_ade_t.ade05
                     #------MOD-5A0095 START----------
                     DISPLAY BY NAME g_ade[l_ac].ade05
                     #------MOD-5A0095 END------------
                     NEXT FIELD ade05
                  END IF
               END IF
            END IF

        #No.FUN-580033  --begin
        BEFORE FIELD ade33
           CALL t201_set_no_required()

        AFTER FIELD ade33  #第二單位
           IF cl_null(g_ade[l_ac].ade03) THEN NEXT FIELD ade03 END IF
           IF NOT cl_null(g_ade[l_ac].ade33) THEN
              CALL t201_unit(g_ade[l_ac].ade33)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD ade33
              END IF
              CALL s_du_umfchk(g_ade[l_ac].ade03,'','','',
                               g_ima25,g_ade[l_ac].ade33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ade[l_ac].ade33,g_errno,0)
                 NEXT FIELD ade33
              END IF
              LET g_ade[l_ac].ade34 = g_factor
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_ade[l_ac].ade34
              #------MOD-5A0095 END------------
           END IF
           CALL t201_set_required()
           CALL cl_show_fld_cont()                   #No:FUN-560197

        BEFORE FIELD ade35
           IF cl_null(g_ade[l_ac].ade03) THEN NEXT FIELD ade03 END IF
           IF NOT cl_null(g_ade[l_ac].ade33) AND g_ima906 = '3' THEN
              CALL s_du_umfchk(g_ade[l_ac].ade03,'','','',
                               g_ima25,g_ade[l_ac].ade33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ade[l_ac].ade33,g_errno,0)
                 NEXT FIELD ade11
              END IF
              LET g_ade[l_ac].ade34 = g_factor
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_ade[l_ac].ade34
              #------MOD-5A0095 END------------
           END IF

        AFTER FIELD ade35  #第二數量
           IF NOT cl_null(g_ade[l_ac].ade35) THEN
              IF g_ade[l_ac].ade35 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD ade35
              END IF
              IF p_cmd = 'a' THEN
                 IF g_ima906='3' THEN
                    LET g_tot=g_ade[l_ac].ade35*g_ade[l_ac].ade34
                    IF cl_null(g_ade[l_ac].ade32) OR g_ade[l_ac].ade32=0 THEN
                       LET g_ade[l_ac].ade32=g_tot*g_ade[l_ac].ade31
                       #------MOD-5A0095 START----------
                       DISPLAY BY NAME g_ade[l_ac].ade32
                       #------MOD-5A0095 END------------
                    END IF
                 END IF
              END IF
           END IF
           CALL cl_show_fld_cont()                   #No:FUN-560197

        BEFORE FIELD ade30
           CALL t201_set_no_required()

        AFTER FIELD ade30  #第一單位
           IF cl_null(g_ade[l_ac].ade03) THEN NEXT FIELD ade03 END IF
           IF NOT cl_null(g_ade[l_ac].ade30) THEN
              CALL t201_unit(g_ade[l_ac].ade30)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD ade30
              END IF
              CALL s_du_umfchk(g_ade[l_ac].ade03,'','','',
                               g_ima25,g_ade[l_ac].ade30,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ade[l_ac].ade30,g_errno,0)
                 NEXT FIELD ade30
              END IF
              LET g_ade[l_ac].ade31 = g_factor
              #------MOD-5A0095 START----------
              DISPLAY BY NAME g_ade[l_ac].ade31
              #------MOD-5A0095 END------------
           END IF
           CALL t201_set_required()
           CALL cl_show_fld_cont()                   #No:FUN-560197

        AFTER FIELD ade32  #第一數量
           IF NOT cl_null(g_ade[l_ac].ade32) THEN
              IF g_ade[l_ac].ade32 < 0 THEN
                 CALL cl_err('','aim-391',0)  #
                 NEXT FIELD ade32
              END IF
           END IF
           CALL t201_du_data_to_correct()
           CALL t201_set_origin_field()
           CALL t201_unit(g_ade[l_ac].ade04)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              IF g_ima906 MATCHES '[23]' THEN
                 NEXT FIELD ade35
              ELSE
                 NEXT FIELD ade32
              END IF
           END IF
           IF g_ade[l_ac].ade05 <=0 THEN
              IF g_ima906 MATCHES '[23]' THEN
                 NEXT FIELD ade35
              ELSE
                 NEXT FIELD ade32
              END IF
           END IF
           IF g_add.add00 = '3' THEN
              IF g_ade[l_ac].ade05 > l_adi10 THEN
                 CALL cl_err(g_ade[l_ac].ade05,'axd-071',0)
                 LET g_ade[l_ac].ade05 = g_ade_t.ade05
                 IF g_ima906 MATCHES '[23]' THEN
                    NEXT FIELD ade35
                 ELSE
                    NEXT FIELD ade32
                 END IF
              END IF
           END IF
        #No.FUN-580033  --end

        AFTER FIELD ade06  #需求工廠
            IF NOT cl_null(g_ade[l_ac].ade06) THEN
               SELECT COUNT(*) INTO l_n FROM ada_file,adb_file
                WHERE ada01 =adb01 AND ada01 = g_plant
                  AND adb02 = g_ade[l_ac].ade06
               IF l_n =0 THEN
                  NEXT FIELD ade06
               END IF
               IF g_add.add00='2' THEN
                  IF g_ade[l_ac].ade06 = g_azp01 THEN
                     CALL cl_err(g_ade[l_ac].ade06,'axd-032',0)
                     NEXT FIELD ade06
                  END IF
               END IF
            END IF

        AFTER FIELD ade07  #倉庫
            IF NOT cl_null(g_ade[l_ac].ade07) THEN
               SELECT COUNT(*) INTO l_n FROM adc_file
               WHERE adc01 = g_ade[l_ac].ade06 AND adc02= g_ade[l_ac].ade07
                 AND adc08 = 'S' AND adcacti = 'Y'
               IF l_n=0 THEN
                  NEXT FIELD ade07
               END IF
            END IF

        AFTER FIELD ade09  #回復日期
            IF NOT cl_null(g_ade[l_ac].ade09)
               AND NOT cl_null(g_ade[l_ac].ade08) THEN
               IF g_ade[l_ac].ade09 < g_ade[l_ac].ade08 THEN
                  NEXT FIELD ade08
               END IF
            END IF

        AFTER FIELD ade10  #預撥日期
            IF NOT cl_null(g_ade[l_ac].ade10)
               AND NOT cl_null(g_ade[l_ac].ade09) THEN
               IF g_ade[l_ac].ade10 < g_ade[l_ac].ade09 THEN
                  NEXT FIELD ade09
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_ade_t.ade02 > 0 AND
               g_ade_t.ade02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ade_file
                    WHERE ade01 = g_add.add01 AND
                          ade02 = g_ade_t.ade02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ade_t.ade02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ade[l_ac].* = g_ade_t.*
               CLOSE t201_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ade[l_ac].ade02,-263,1)
               LET g_ade[l_ac].* = g_ade_t.*
            ELSE
               #No.FUN-580033  --begin
               IF g_sma.sma115 = 'Y' THEN
                  CALL s_chk_va_setting(g_ade[l_ac].ade03)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD ade03
                  END IF
                  CALL t201_du_data_to_correct()
               END IF
               CALL t201_set_origin_field()
               UPDATE ade_file
                  SET ade02 = g_ade[l_ac].ade02,
                      ade03 = g_ade[l_ac].ade03,
                      ade04 = g_ade[l_ac].ade04,
                      ade05 = g_ade[l_ac].ade05,
                      ade06 = g_ade[l_ac].ade06,
                      ade07 = g_ade[l_ac].ade07,
                      ade08 = g_ade[l_ac].ade08,
                      ade09 = g_ade[l_ac].ade09,
                      ade10 = g_ade[l_ac].ade10,
                      ade11 = g_ade[l_ac].ade11,
                      ade12 = g_ade[l_ac].ade12,
                      ade13 = g_ade[l_ac].ade13,
                      ade14 = g_ade[l_ac].ade14,
                      ade15 = g_ade[l_ac].ade15,
                      ade16 = g_ade[l_ac].ade16,
                      ade17 = g_ade[l_ac].ade17,
                      ade18 = g_ade18,
                      ade19 = g_ade19,
                      ade20 = g_ade20,
                      ade30 = g_ade[l_ac].ade30,
                      ade31 = g_ade[l_ac].ade31,
                      ade32 = g_ade[l_ac].ade32,
                      ade33 = g_ade[l_ac].ade33,
                      ade34 = g_ade[l_ac].ade34,
                      ade35 = g_ade[l_ac].ade35
               #No.FUN-580033  --end
                WHERE CURRENT OF t201_b_cl
               IF SQLCA.sqlcode OR STATUS = 100 THEN
                   CALL cl_err(g_ade[l_ac].ade02,SQLCA.sqlcode,0)
                   LET g_ade[l_ac].* = g_ade_t.*
                   CLOSE t201_b_cl
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   IF g_aza.aza40='Y' THEN  #NO.A112
                      IF g_add.add00<>'1' THEN   #銷售預測
                         CALL t201_m()
                      END IF
                   END IF  #NO.A112
                   COMMIT WORK
               END IF
            END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ade[l_ac].* = g_ade_t.*
               END IF
               CLOSE t201_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t201_b_cl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL t201_b_askkey()
            EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(ade02) AND l_ac > 1 THEN
                LET g_ade[l_ac].* = g_ade[l_ac-1].*
                NEXT FIELD ade02
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ade16) #異動單號
                  #CALL q_adi(5,3,g_ade[l_ac].ade16,g_ade[l_ac].ade17,
                  #           g_add.add02,'2')
                  #     RETURNING g_ade[l_ac].ade16,g_ade[l_ac].ade17
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ='q_adi'
                  LET g_qryparam.default1=g_ade[l_ac].ade16
                  LET g_qryparam.default2=g_ade[l_ac].ade17
                  LET g_qryparam.arg1=2
                  LET g_qryparam.arg2=g_add.add02
                  CALL cl_create_qry() RETURNING g_ade[l_ac].ade16,g_ade[l_ac].ade17
#                  CALL FGL_DIALOG_SETBUFFER( g_ade[l_ac].ade16 )
#                  CALL FGL_DIALOG_SETBUFFER( g_ade[l_ac].ade17 )
                  NEXT FIELD ade16
               WHEN INFIELD(ade03) #料件編號
                  #CALL q_ima(10,3,g_ade[l_ac].ade03)
                  #     RETURNING g_ade[l_ac].ade03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ima"
                  LET g_qryparam.default1=g_ade[l_ac].ade03
                  CALL cl_create_qry() RETURNING g_ade[l_ac].ade03
#                  CALL FGL_DIALOG_SETBUFFER( g_ade[l_ac].ade03 )
                  NEXT FIELD ade03
               WHEN INFIELD(ade04) #單位
                  #CALL q_gfe(10,3,g_ade[l_ac].ade04)
                  #   RETURNING g_ade[l_ac].ade04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1=g_ade[l_ac].ade04
                  CALL cl_create_qry() RETURNING g_ade[l_ac].ade04
#                  CALL FGL_DIALOG_SETBUFFER( g_ade[l_ac].ade04 )
                  NEXT FIELD ade04
               WHEN INFIELD(ade06)   #工廠
                  #CALL q_adb2(10,3,g_ade[l_ac].ade06,g_plant)
                  #    RETURNING g_ade[l_ac].ade06
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adb2"
                  LET g_qryparam.default1=g_ade[l_ac].ade06
                  LET g_qryparam.arg1 = g_plant
                  CALL cl_create_qry() RETURNING g_ade[l_ac].ade06
#                  CALL FGL_DIALOG_SETBUFFER( g_ade[l_ac].ade06 )
                  NEXT FIELD ade06
               WHEN INFIELD(ade07)   #倉庫
                  #CALL q_adc(10,3,g_ade[l_ac].ade07,g_ade[l_ac].ade06,'S')
                  #     RETURNING g_ade[l_ac].ade07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adc"
                  LET g_qryparam.default1=g_ade[l_ac].ade07
                  LET g_qryparam.arg1 = g_ade[l_ac].ade06
                  LET g_qryparam.arg2 = 'S'
                  CALL cl_create_qry() RETURNING g_ade[l_ac].ade07
#                  CALL FGL_DIALOG_SETBUFFER( g_ade[l_ac].ade07 )
                  NEXT FIELD ade07
              #FUN-580033  --begin
              WHEN INFIELD(ade30) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ade[l_ac].ade30
                   CALL cl_create_qry() RETURNING g_ade[l_ac].ade30
                   DISPLAY BY NAME g_ade[l_ac].ade30
                   NEXT FIELD ade30

              WHEN INFIELD(ade33) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_ade[l_ac].ade33
                   CALL cl_create_qry() RETURNING g_ade[l_ac].ade33
                   DISPLAY BY NAME g_ade[l_ac].ade33
                   NEXT FIELD ade33
              #FUN-580033  --end
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

    #FUN-5B0113-begin
     LET g_add.addmodu = g_user
     LET g_add.adddate = g_today
     UPDATE add_file SET addmodu = g_add.addmodu,adddate = g_add.adddate
      WHERE add01 = g_add.add01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err('upd add',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_add.addmodu,g_add.adddate
    #FUN-5B0113-end

    CLOSE t201_b_cl
    COMMIT WORK
#    CALL t201_delall()
END FUNCTION

FUNCTION t201_delall()
    SELECT COUNT(*) INTO g_cnt FROM ade_file
        WHERE ade01 = g_add.add01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM add_file WHERE add01 = g_add.add01
    END IF
END FUNCTION

FUNCTION t201_ade03(p_cmd)  #料件編號
    DEFINE l_ima02    LIKE ima_file.ima02,
           l_ima44    LIKE ima_file.ima44,
           l_ima021   LIKE ima_file.ima021,
           l_imaacti  LIKE ima_file.imaacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

    LET g_errno = ' '
    SELECT ima02,ima021,ima44,imaacti INTO l_ima02,l_ima021,l_ima44,l_imaacti
      FROM ima_file WHERE ima01 = g_ade[l_ac].ade03

    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                            LET l_ima02 = NULL
                            LET l_ima021= NULL
                            LET l_ima44= NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'    LET g_errno = '9038'   #NO.FUN-690022 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE

    IF p_cmd = 'a' THEN
       LET g_ade[l_ac].ade04 = l_ima44
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_ade[l_ac].ade04
       #------MOD-5A0095 END------------
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_ade[l_ac].ima02 = l_ima02
       #------MOD-5A0095 START----------
       DISPLAY BY NAME g_ade[l_ac].ima02
       #------MOD-5A0095 END------------
    END IF
END FUNCTION

FUNCTION t201_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

 #No.FUN-580033  --begin
 CONSTRUCT l_wc2 ON ade02,ade16,ade17,ade03,ade04,ade05,
                       ade33,ade35,ade30,ade32,
                       ade12,ade06,ade07,ade15,ade08,ade09,
                       ade10,ade11,ade13,ade14
            FROM s_ade[1].ade02,s_ade[1].ade16,s_ade[1].ade17,
                 s_ade[1].ade03,s_ade[1].ade04,s_ade[1].ade05,
                 s_ade[1].ade33,s_ade[1].ade35,s_ade[1].ade30,
                 s_ade[1].ade32,
                 s_ade[1].ade12,s_ade[1].ade06,s_ade[1].ade07,
                 s_ade[1].ade15,s_ade[1].ade08,s_ade[1].ade09,
                 s_ade[1].ade10,s_ade[1].ade11,s_ade[1].ade13,
                 s_ade[1].ade14
 #No.FUN-580033  --end

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(ade16) #異動單號
                  #CALL q_adi(5,3,g_ade[l_ac].ade16,g_ade[l_ac].ade17,
                  #           g_add.add02,'2')
                  #     RETURNING g_ade[l_ac].ade16,g_ade[l_ac].ade17
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adi"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1=2
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade16
                  NEXT FIELD ade16
               WHEN INFIELD(ade03) #料件編號
                  #CALL q_ima(10,3,g_ade[l_ac].ade03)
                  #     RETURNING g_ade[l_ac].ade03
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade03
                  NEXT FIELD ade03
               WHEN INFIELD(ade04) #單位
                  #CALL q_gfe(10,3,g_ade[l_ac].ade04)
                   #   RETURNING g_ade[l_ac].ade04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade04
                  NEXT FIELD ade04
               WHEN INFIELD(ade06)   #工廠
                  #CALL q_adb2(10,3,g_ade[l_ac].ade06,g_plant)
                  #     RETURNING g_ade[l_ac].ade06
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adb2"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_plant
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade06
                  NEXT FIELD ade06
               WHEN INFIELD(ade07)   #倉庫
                  #CALL q_adc(10,3,g_ade[l_ac].ade07,g_ade[l_ac].ade06,'S')
                  #     RETURNING g_ade[l_ac].ade07
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_adc"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.arg1 = g_ade[l_ac].ade06
                  LET g_qryparam.arg2 = 'S'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_ade[1].ade07
                  NEXT FIELD ade07
              #No.FUN-580033  --begin
              WHEN INFIELD(ade33)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ade33
                 NEXT FIELD ade33
              WHEN INFIELD(ade30)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ade30
                 NEXT FIELD ade30
              #No.FUN-580033  --end
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t201_b_fill(l_wc2)
END FUNCTION

FUNCTION t201_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(200)
    l_ima02    LIKE ima_file.ima02,
    l_imd02    LIKE imd_file.imd02,
    l_azp02    LIKE azp_file.azp02,
    l_ima021   LIKE ima_file.ima021

    #No.FUN-580033  --begin
    LET g_sql =
        "SELECT ade02,ade16,ade17,ade03,ima02,ade04,ade05,",
        "       ade33,ade34,ade35,ade30,ade31,ade32,ade12,ade06,",
        "       ade07,ade15,ade08,ade09,ade10,ade11,ade13,ade14",
        "  FROM ade_file,OUTER ima_file",
        " WHERE ade01 ='",g_add.add01,"'",
        "   AND ade03 = ima_file.ima01 AND ",p_wc2 CLIPPED, #單身
        " ORDER BY ade02 "
    #No.FUN-580033  --end
    PREPARE t201_pb FROM g_sql
    DECLARE ade_cs CURSOR FOR t201_pb

    #單身 ARRAY 乾洗
    CALL g_ade.clear()
    LET g_cnt = 1
    FOREACH ade_cs INTO g_ade[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ade.deleteElement(g_cnt)

    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION t201_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ade TO s_ade.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
         CALL t201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL t201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL t201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL t201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last
         CALL t201_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

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
         CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
         CALL t201_mu_ui()   #FUN-610006
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION related_document                #No:FUN-6A0165  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION t201_copy()
DEFINE
    l_newno         LIKE add_file.add01,
    l_newdate       LIKE add_file.add02,
    l_oldno         LIKE add_file.add01
DEFINE li_result   LIKE type_file.num5        #No.FUN-550026        #No.FUN-680108 SMALLINT


    IF s_shut(0) THEN RETURN END IF
    IF g_add.add01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_add.add00 = '1' THEN LET g_type = '10' END IF
    IF g_add.add00 = '2' THEN LET g_type = '11' END IF
    IF g_add.add00 = '3' THEN LET g_type = '12' END IF

    LET g_before_input_done = FALSE
    CALL t201_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno FROM add01

#No.FUN-550026 --start--
    BEFORE INPUT
       CALL cl_set_docno_format("add01")
#No.FUN-550026 ---end---

        AFTER FIELD add01
            IF l_newno IS NULL THEN
                NEXT FIELD add01
            END IF
#No.FUN-550026 --start--
    CALL s_check_no("axd",l_newno,"",g_type,"add_file","add01","")
         RETURNING li_result,l_newno
    DISPLAY l_newno TO add01
       IF (NOT li_result) THEN
          NEXT FIELD add01
       END IF
{
            LET g_t1=l_newno[1,3]
            SELECT * INTO g_adz.* FROM adz_file
             WHERE adzslip = g_t1 AND adztype = g_type
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_newno,'mfg0014',0)
               NEXT FIELD add01
            END IF
            IF cl_null(l_newno[5,10]) AND g_adz.adzauno='N'
               THEN NEXT FIELD add01
            END IF
            IF g_adz.adzauno='Y' THEN
               CALL s_axdauno(l_newno,g_add.add02) RETURNING g_i,l_newno
               IF g_i THEN #有問題
                  NEXT FIELD add01
               END IF
               DISPLAY l_newno TO add01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM add_file
             WHERE add01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD add01
            END IF
}

        ON ACTION CONTROLP
           CASE WHEN INFIELD(add01)
#                    LET g_t1=l_newno[1,3]
                    LET g_t1=s_get_doc_no(l_newno)    #No.FUN-550026
                   #CALL q_adz(FALSE,FALSE,g_t1,g_type,'axd') RETURNING g_t1   #TQC-670008 remark
                    CALL q_adz(FALSE,FALSE,g_t1,g_type,'AXD') RETURNING g_t1   #TQC-670008
#                    LET l_newno[1,3]=g_t1
                    LET l_newno=g_t1
                    DISPLAY l_newno TO add01
                    NEXT FIELD add01
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM add_file         #單頭復制
        WHERE add01=g_add.add01
        INTO TEMP y
    UPDATE y
        SET add01=l_newno,    #新的鍵值
            adduser=g_user,   #資料所有者
            addgrup=g_grup,   #資料所有者所屬群
            y.adddate = g_today,
            y.addacti = 'Y',
            y.addconf = 'N'
    INSERT INTO add_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL  cl_err(l_newno,SQLCA.sqlcode,0)
    END IF

    DROP TABLE x
    SELECT * FROM ade_file         #單身復制
        WHERE ade01=g_add.add01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
        RETURN
    END IF
    UPDATE x
        SET ade01=l_newno
    INSERT INTO ade_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        ATTRIBUTE(REVERSE)
     LET l_oldno = g_add.add01
     SELECT ROWID,add_file.* INTO g_add_rowid,g_add.* FROM add_file WHERE add01 = l_newno
     CALL t201_u()
     CALL t201_b()
     SELECT ROWID,add_file.* INTO g_add_rowid,g_add.* FROM add_file WHERE add01 = l_oldno
     CALL t201_show()
END FUNCTION

FUNCTION t201_y()
    IF g_add.add01 IS NULL THEN RETURN END IF
    SELECT * INTO g_add.* FROM add_file WHERE add01=g_add.add01
    IF g_add.addacti='N' THEN
       CALL cl_err(g_add.add01,'mfg1000',0)
       RETURN
    END IF
    IF g_add.addconf='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK

    OPEN t201_cl USING g_add_rowid
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_add.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
        CLOSE t201_cl
        ROLLBACK WORK
        RETURN
    END IF

    IF g_add.add00='3' THEN   #check 撥入
       CALL t201_yy()
    END IF

    UPDATE add_file SET addconf='Y',add06='1'
     WHERE add01 = g_add.add01
    IF STATUS THEN
       CALL cl_err('upd addconf',STATUS,0)
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT addconf,add06 INTO g_add.addconf,g_add.add06 FROM add_file
     WHERE add01 = g_add.add01
    DISPLAY BY NAME g_add.addconf
    DISPLAY BY NAME g_add.add06
    CALL t201_add06()
END FUNCTION

FUNCTION t201_z()
DEFINE l_n LIKE type_file.num5          #No.FUN-680108 SMALLINT

    IF g_add.add01 IS NULL THEN RETURN END IF
    SELECT * INTO g_add.* FROM add_file WHERE add01=g_add.add01
    IF g_add.addconf='N' THEN RETURN END IF
    IF g_add.add07 = 'Y' THEN
       CALL cl_err("","aap-730",0)
       RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM adg_file,adf_file
      WHERE adf01=adg01 AND adg03 = g_add.add01
       AND adfpost='Y'  AND adfacti = 'Y' AND adfconf='Y'
    IF l_n > 0 THEN
       CALL cl_err(g_add.add01,'axd-033',0)
       RETURN
    END IF
    SELECT COUNT(*) INTO l_n FROM ade_file WHERE ade01 = g_add.add01
       AND ade13 = 'Y'
    IF l_n > 0 THEN
       CALL cl_err(g_add.add01,'axd-048',0)
       RETURN
    END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK
        OPEN t201_cl USING g_add_rowid
        IF STATUS THEN
           CALL cl_err("OPEN t201_cl:", STATUS, 1)
           CLOSE t201_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t201_cl INTO g_add.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_add.add01,SQLCA.sqlcode,0)
            CLOSE t201_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE add_file SET addconf='N',add06='0'
            WHERE add01 = g_add.add01
        IF STATUS THEN
            CALL cl_err('upd cofconf',STATUS,0)
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT addconf,add06 INTO g_add.addconf,g_add.add06 FROM add_file
            WHERE add01 = g_add.add01
        DISPLAY BY NAME g_add.addconf
        DISPLAY BY NAME g_add.add06
        CALL t201_add06()
END FUNCTION

FUNCTION t201_prt()
   IF cl_confirm('mfg3242') THEN CALL t201_out('a') END IF
END FUNCTION

FUNCTION t201_out(p_cmd)
   DEFINE l_cmd         LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(200)
          p_cmd         LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(01)
          l_prog        LIKE zz_file.zz01,     #No.FUN-680108 VARCHAR(10)
          l_wc,l_wc2    LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(500) #No:TQC-610088 modify        
          l_prtway      LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
          l_lang        LIKE type_file.chr1    # Prog. Version..: '5.10.00-08.01.04(0.中文/1.英文/2.簡體)  #No.FUN-680108 VARCHAR(1)

   IF cl_null(g_add.add01) THEN CALL cl_err('','-400',0) RETURN END IF
   OPTIONS FORM LINE FIRST + 1

 #NO.MOD-4B0082  --begin
#   LET p_row = 3 LET p_col = 3
#   OPEN WINDOW w1 AT p_row,p_col WITH 2 ROWS, 75 COLUMNS
#        ATTRIBUTE(STYLE = g_win_style)
   MENU ""
        ON ACTION Appl_Note_LIst_Of_Group_Trans
           LET l_prog='axdr200'
           EXIT MENU
        ON ACTION Appl_Note_Detail_List_Of_Group_Trans
           LET l_prog='axdr206'
           EXIT MENU
        ON ACTION exit
           EXIT MENU

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 


        -- for Windows close event trapped
        COMMAND KEY(INTERRUPT)
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU

   END MENU
   IF NOT cl_null(l_prog) THEN #BugNo:5548
      IF l_prog = 'axdr200' OR p_cmd = 'a' THEN
         LET l_wc='add01="',g_add.add01,'"'
      ELSE
         LET l_wc=g_wc CLIPPED,' AND ',g_wc2
      END IF
      SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
       WHERE zz01 = l_prog
      IF SQLCA.sqlcode OR l_wc2 IS NULL OR l_wc = ' ' THEN
         LET l_wc2 = " 'Y' 'Y' 'Y' "
      END IF
      LET l_cmd = l_prog CLIPPED,
              " '",g_today CLIPPED,"' ''",
              " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
              " '",l_wc CLIPPED,"' ",l_wc2
      CALL cl_cmdrun(l_cmd)
   END IF
   #CLOSE WINDOW w1
   #OPTIONS FORM LINE FIRST + 2
 #NO.MOD-4B0082  --end
END FUNCTION

FUNCTION t201_m()
DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
        l_ade           RECORD LIKE ade_file.*,
        l_desc          LIKE type_file.chr20          #No.FUN-680108 VARCHAR(20)

    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    OPEN WINDOW t201_ww AT 8,10     #顯示畫面 統一編號欄位加長
         WITH FORM "axd/42f/axdt201_m"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #顯示畫面 統一編號欄位加長 #No:FUN-580092 HCN
         CALL cl_ui_locale("axdt201_m")
    CALL cl_opmsg('u')

    CALL t201_ade18(g_ade18) RETURNING l_desc
    DISPLAY g_ade18 TO FORMONLY.ade18
    DISPLAY g_ade19 TO FORMONLY.ade19
    DISPLAY g_ade20 TO FORMONLY.ade20
    DISPLAY l_desc TO FORMONLY.desc
    IF g_add.add00='3' THEN
       CALL cl_anykey('')
    ELSE
       INPUT g_ade19,g_ade20 WITHOUT DEFAULTS FROM ade19,ade20
           AFTER FIELD ade19
                 IF NOT cl_null(g_ade19) THEN
                    SELECT UNIQUE obd021 FROM obd_file
                     WHERE obd01 =g_ade[l_ac].ade03 AND obd02=g_ade18
                       AND obd021=g_ade19
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ade[l_ac].ade03,'axd-088',0)
                       NEXT FIELD ade19
                    END IF
                 ELSE
                    LET g_ade20=NULL
                    DISPLAY g_ade20 TO FORMONLY.ade20
                 END IF

           AFTER FIELD ade20
                 IF NOT cl_null(g_ade19) THEN
                    IF cl_null(g_ade20) THEN NEXT FIELD ade20 END IF
                    SELECT * FROM obd_file
                     WHERE obd01 =g_ade[l_ac].ade03 AND obd02=g_ade18
                       AND obd021=g_ade19 AND obd03=g_ade20
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ade[l_ac].ade03,'axd-089',0)
                       NEXT FIELD ade19
                    END IF
                 ELSE
                    LET g_ade20=NULL
                    DISPLAY g_ade20 TO FORMONLY.ade20
                 END IF

           ON ACTION CONTROLF                       # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 

           ON ACTION CONTROLP
              CASE WHEN INFIELD(ade19)
                       #CALL q_obd(0,0,g_ade[l_ac].ade03,g_ade18,g_ade19,g_ade20)
                       #     RETURNING g_ade19,g_ade20
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_obd"
                       LET g_qryparam.default1 = g_ade19
                       LET g_qryparam.default1 = g_ade20
                       LET g_qryparam.arg1 =g_ade[l_ac].ade03
                       LET g_qryparam.arg2 =g_ade18
                       CALL cl_create_qry() RETURNING g_ade19,g_ade20
                       DISPLAY g_ade19 TO FORMONLY.ade19
                       DISPLAY g_ade20 TO FORMONLY.ade20
                       NEXT FIELD ade19
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

       IF INT_FLAG THEN                   #使用者不玩了
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
       END IF

       CLOSE WINDOW t201_ww

       UPDATE ade_file SET ade19 = g_ade19,
                           ade20 = g_ade20
        WHERE ade01 = g_add.add01 AND ade02 = g_ade[l_ac].ade02
       IF SQLCA.sqlcode OR STATUS = 100  THEN
          CALL cl_err('t201_1 upd ade_file',SQLCA.sqlcode,0)
       END IF
    END IF
END FUNCTION

FUNCTION t201_ade18(p_ade18)
DEFINE p_ade18  LIKE ade_file.ade18
DEFINE l_desc   LIKE type_file.chr20                   #No.FUN-680108 VARCHAR(20)

    CASE p_ade18
         WHEN '1'  CALL cl_getmsg('axm-024',g_lang) RETURNING l_desc
         WHEN '2'  CALL cl_getmsg('axm-025',g_lang) RETURNING l_desc
         WHEN '3'  CALL cl_getmsg('axm-026',g_lang) RETURNING l_desc
    END CASE
    RETURN l_desc
END FUNCTION

FUNCTION t201_yy()
  DEFINE b_ade       RECORD
                     ade16  LIKE ade_file.ade16,   #撥入單
                     ade17  LIKE ade_file.ade17,   #撥入單項次
                     ade03  LIKE ade_file.ade03,   #申請料號
                     ade05  LIKE ade_file.ade05    #申請數量
                     END RECORD,
         l_adi10     LIKE adi_file.adi10    #撥入數量

  DECLARE t201_yy_cur CURSOR FOR
   SELECT ade16,ade17,ade03,SUM(ade05)
     FROM ade_file,add_file
    WHERE ade01=add01 AND add01=g_add.add01
    GROUP BY ade16,ade17,ade03

  FOREACH t201_yy_cur INTO b_ade.*
      IF STATUS THEN LET g_success='N' EXIT FOREACH END IF

      SELECT adi10-adi17 INTO l_adi10
        FROM adi_file,adh_file
       WHERE adi01=adh01 AND adi01=b_ade.ade16 AND adi02=b_ade.ade17
         AND adh00='2' AND adi05=b_ade.ade03 AND adhpost='Y'
         AND adhacti='Y' AND adhconf='Y' AND adh06<=g_add.add02
      IF SQLCA.sqlcode=100 THEN
         CALL cl_err(b_ade.ade16,'axd-091',1)
         LET g_success='N' RETURN
      END IF
      IF cl_null(l_adi10) THEN LET l_adi10=0 END IF
      IF b_ade.ade05>l_adi10 THEN
         CALL cl_err(b_ade.ade16,'axd-091',1)
         LET g_success='N' RETURN
      END IF
  END FOREACH

END FUNCTION

FUNCTION t201_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("add00,add01",TRUE)
   END IF

END FUNCTION

FUNCTION t201_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("add00,add01",FALSE)
       END IF
   END IF

END FUNCTION

FUNCTION t201_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

      CALL cl_set_comp_entry("ade03,ade04,ade06,ade16,ade17",TRUE)

      #No.FUN-580033  --begin
      CALL cl_set_comp_entry("ade33,ade35",TRUE)
      #No.FUN-580033  --end
END FUNCTION

FUNCTION t201_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

      CASE g_add.add00
           WHEN '1' LET g_ade[l_ac].ade06 = g_azp01
                    CALL cl_set_comp_entry("ade06,ade16,ade17",FALSE)
           WHEN '2' CALL cl_set_comp_entry("ade16,ade17",FALSE)
           WHEN '3' CALL cl_set_comp_entry("ade03,ade04,ade06",FALSE)
      END CASE

      #FUN-580033  --begin
      IF g_ima906 = '1' THEN
         CALL cl_set_comp_entry("ade33,ade35",FALSE)
      END IF
      #參考單位，每個料件只有一個，所以不開放讓用戶輸入
      IF g_ima906 = '3' THEN
         CALL cl_set_comp_entry("ade33",FALSE)
      END IF
      #FUN-580033  --end

END FUNCTION

#No.FUN-580033  --begin
FUNCTION t201_mu_ui()
    CALL cl_set_comp_visible("ade31,ade34",FALSE)
    CALL cl_set_comp_visible("ade30,ade33,ade32,ade35",g_sma.sma115='Y')
    CALL cl_set_comp_visible("ade05,ade04",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade35",g_msg CLIPPED)
       CALL cl_getmsg('asm-402',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade30",g_msg CLIPPED)
       CALL cl_getmsg('asm-403',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ade32",g_msg CLIPPED)
    END IF

END FUNCTION
#用于default 雙單位/轉換率/數量
FUNCTION t201_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-680108 VARCHAR(01)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680108 DECIMAL(16,8)

    LET l_item = g_ade[l_ac].ade03

    SELECT ima25,ima906,ima907 INTO g_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item

    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',g_ima25,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = g_ima25
    LET l_fac1  = 1
    LET l_qty1  = 0

    IF p_cmd = 'a' OR g_change = 'Y' THEN
       LET g_ade[l_ac].ade33 =l_unit2
       LET g_ade[l_ac].ade34 =l_fac2
       LET g_ade[l_ac].ade35 =l_qty2
       LET g_ade[l_ac].ade30 =l_unit1
       LET g_ade[l_ac].ade31 =l_fac1
       LET g_ade[l_ac].ade32 =l_qty1
    END IF
END FUNCTION

FUNCTION t201_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680108 DECIMAL(16,8)

    #No.MOD-590121  --begin
    IF g_sma.sma115='N' THEN RETURN END IF
    #No.MOD-590121  --end
    LET l_fac2=g_ade[l_ac].ade34
    LET l_qty2=g_ade[l_ac].ade35
    LET l_fac1=g_ade[l_ac].ade31
    LET l_qty1=g_ade[l_ac].ade32

    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_ade[l_ac].ade04=g_ade[l_ac].ade30
                   LET g_ade[l_ac].ade05=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_ade[l_ac].ade04=g_ima25
                   LET g_ade[l_ac].ade05=l_tot
          WHEN '3' LET g_ade[l_ac].ade04=g_ade[l_ac].ade30
                   LET g_ade[l_ac].ade05=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_ade[l_ac].ade34 =l_qty1/l_qty2
                   ELSE
                      LET g_ade[l_ac].ade34 =0
                   END IF
       END CASE
    #No.MOD-590121  --begin
    #ELSE  #不使用雙單位
    #   LET g_ade[l_ac].ade04=g_ade[l_ac].ade30
    #   LET g_ade[l_ac].ade05=l_qty1
    #No.MOD-590121  --end
    END IF

END FUNCTION

FUNCTION t201_set_required()

  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("ade33,ade35,ade30,ade32",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_ade[l_ac].ade30) THEN
     CALL cl_set_comp_required("ade32",TRUE)
  END IF
  IF NOT cl_null(g_ade[l_ac].ade33) THEN
     CALL cl_set_comp_required("ade35",TRUE)
  END IF

END FUNCTION

FUNCTION t201_set_no_required()

  CALL cl_set_comp_required("ade33,ade35,ade30,ade32",FALSE)

END FUNCTION

#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t201_du_data_to_correct()

   IF cl_null(g_ade[l_ac].ade33) THEN
      LET g_ade[l_ac].ade34 = NULL
      LET g_ade[l_ac].ade35 = NULL
   END IF

   IF cl_null(g_ade[l_ac].ade30) THEN
      LET g_ade[l_ac].ade31 = NULL
      LET g_ade[l_ac].ade32 = NULL
   END IF
   DISPLAY BY NAME g_ade[l_ac].ade31
   DISPLAY BY NAME g_ade[l_ac].ade32
   DISPLAY BY NAME g_ade[l_ac].ade34
   DISPLAY BY NAME g_ade[l_ac].ade35

END FUNCTION
#檢查單位是否存在於單位檔中
FUNCTION t201_unit(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti

    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
#No.FUN-580033  --end
#Patch....NO:MOD-5A0095 <002,003,004,005> #
#Patch....NO:TQC-610037 <001,002> #
