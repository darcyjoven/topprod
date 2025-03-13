# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimt826.4gl
# Descriptions...: 初盤adjust作業－現有庫存
# Date & Author..: 93/06/11 By Apple
# NOTE...........: 本程式的設計必須考慮使用者的操作輸入為主
# Modify.........: No.FUN-570082 By Carrier 多單位修改
# Modify.........: No.FUN-570028 05/07/04 By kim 快速輸入第一筆取消+1
# Modify.........: No.FUN-5B0137 05/12/01 By kim 只查詢盤點差異功能無效
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: No.TQC-620068 06/02/17 By Claire 調整數寫入錯誤
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-8A0147 08/12/08 By douzh 批序號-盤點調整參數傳入邏輯
# Modify.........: No.MOD-8C0201 08/12/19 By chenyu pia40是數值型，不能用' '匹配
# Modify.........: No.FUN-930121 09/04/09 By zhaijie新增字段pia931
# Modify.........: No.MOD-940074 09/05/25 By Pengu 只有需要做批序號的料件才需要呼叫s_lotcheck
# Modify.........: No.TQC-960358 09/06/30 By lilingyu 查出一筆資料后,按下"快速調整"按鈕,然后按取消,畫面上欄位都空白了
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B70032 11/08/11 By jason 刻號/BIN盤點
# Modify.........: No:FUN-BB0086 11/12/12 By tanxc 增加數量欄位小數取位 
# Modify.........: No.TQC-CB0097 12/11/26 By qirl 去掉-
# Modify.........: No:FUN-CB0087 12/12/13 By qiull 庫存單據理由碼改善
# Modify.........: No:TQC-CC0095 12/12/18 By qirl 點擊“快速調整”按鈕，然後點擊“退出”，下方會顯示-201發生語法錯誤的提示
# Modify.........: No:TQC-D10103 13/01/30 By qiull 理由碼檢查放在必輸條件下
# Modify.........: No.TQC-D20042 13/02/25 By qiull 修改理由碼改善測試問題
# Modify.........: No.TQC-D20047 13/02/27 By qiull 修改理由碼改善測試問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pia                  RECORD LIKE pia_file.*,
    g_pia_t                RECORD LIKE pia_file.*,
    g_pia_o                RECORD LIKE pia_file.*,
    g_pia01_t              LIKE pia_file.pia01,
    g_ima25                LIKE ima_file.ima25,
    g_unit,g_unit_o        LIKE gfe_file.gfe01,
    g_wc,g_sql             string,                #No.FUN-580092 HCN
    g_ima906               LIKE ima_file.ima906,  #No.FUN-570082
    g_qty                  LIKE pia_file.pia30
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_qty_t             LIKE pia_file.pia30    #No.FUN-8A0147
DEFINE l_y                 LIKE type_file.chr1    #No.FUN-8A0147
DEFINE l_qty               LIKE pia_file.pia30    #No.FUN-8A0147
DEFINE g_no_ep_1           LIKE type_file.num5    #No.FUN-8A0147
DEFINE g_chr               LIKE type_file.chr1     #TQC-960358
DEFINE g_unit_t            LIKE gfe_file.gfe01    #No.FUN-BB0086
DEFINE g_azf03             LIKE azf_file.azf03    #FUN-CB0087

MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    INITIALIZE g_pia.* TO NULL
    INITIALIZE g_pia_t.* TO NULL
    INITIALIZE g_pia_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM pia_file WHERE pia01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t826_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW t826_w WITH FORM "aim/42f/aimt826"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    CALL cl_set_comp_required("pia70",g_aza.aza115='Y')        #FUN-CB0087 add
    CALL cl_set_comp_visible("pia930,gem02",g_aaz.aaz90='Y')   #FUN-670093
    #FUN_B70032 --START--
    IF s_industry('icd') THEN
       CALL cl_set_act_visible("icdcheck,icd_checking",TRUE)
    ELSE
       CALL cl_set_act_visible("icdcheck,icd_checking",FALSE)
    END if 
    #FUN_B70032 --END--
 
    WHILE TRUE
      LET g_action_choice=""
      CALL t826_menu()
      IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t826_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION t826_cs()
 DEFINE  l_code  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_str   LIKE ze_file.ze03       #No.FUN-690026 VARCHAR(70)
 
    CLEAR FORM
    CALL cl_getmsg('mfg0126',g_lang) RETURNING l_str
IF g_chr != 'N' THEN       #TQC-960358           
    CALL cl_prompt(0,0,l_str) RETURNING l_code
END IF                       #TQC-960358     
    
    INITIALIZE g_pia.* TO NULL    #FUN-640213 add
IF g_chr != 'N' THEN                             #TQC-960358           
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        pia01, pia02, pia03, pia04, pia05 ,pia931,pia930, #FUN-670093  #FUN-930121 add pia931  
        pia70                                                         #FUN-CB0087 add>pia70
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
#----TQC-CB0097---ADD---STAR--
              WHEN INFIELD(pia01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_pia01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia01
                 NEXT FIELD pia01
              WHEN INFIELD(pia02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_pia02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia02
                 NEXT FIELD pia02
              WHEN INFIELD(pia03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_pia03"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia03
                 NEXT FIELD pia03
              WHEN INFIELD(pia04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_pia04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia04
                 NEXT FIELD pia04
              WHEN INFIELD(pia05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_pia05"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pia05
                 NEXT FIELD pia05
#----TQC-CB0097---ADD---end--
                #FUN-670093...............begin 
                WHEN INFIELD(pia930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem4"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_pia.pia930
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO pia930
                   NEXT FIELD pia930
                #FUN-670093...............end
               #FUN-CB0087---add---str---
               WHEN INFIELD(pia70)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     ="q_azf41"
                  LET g_qryparam.default1 = g_pia.pia70
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pia70
                  NEXT FIELD pia70
               #FUN-CB0087---add---end---
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
END IF 	 #TQC-960358          
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT pia01 FROM pia_file ", # 組合出 SQL 指令
              " WHERE (pia02 IS NOT NULL AND pia02 != ' ' ) ",
              "   AND (pia30 IS NOT NULL OR pia40 IS NOT NULL ",
             #"        OR CAST(pia30 AS varchar(15)) != '' OR pia40 != ' ' )",  #No.MOD-8C0201 mark
              "        OR CAST(pia30 AS varchar(15)) != '' OR CAST(pia40 AS varchar(15)) != '' )",   #No.MOD-8C0201 add
              " AND ",g_wc CLIPPED
    IF l_code THEN
          LET g_sql = g_sql clipped,
                  " AND (pia30 != pia40 OR pia30 IS NULL OR pia40 IS NULL",
                 #"      OR pia30 ='' OR pia40 =' ') ", #FUN-5B0137
                  "      ) ", #FUN-5B0137
                   " ORDER BY pia01 "
    ELSE  LET g_sql = g_sql clipped, " ORDER BY pia01"
    END IF
    PREPARE t826_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t826_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t826_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pia_file  ",
              " WHERE (pia02 IS NOT NULL AND pia02 != ' ' ) ",
              "   AND (pia30 IS NOT NULL OR pia40 IS NOT NULL ",
             #"        OR CAST(pia30 AS varchar(15)) != '' OR pia40 != ' ' )",  #No.MOD-8C0201 mark
              "        OR CAST(pia30 AS varchar(15)) != '' OR CAST(pia40 AS varchar(15)) != '' )",   #No.MOD-8C0201 add
              " AND ",g_wc CLIPPED
    IF l_code THEN
       LET g_sql = g_sql clipped,
                  " AND (pia30 != pia40 OR pia30 IS NULL OR pia40 IS NULL",
                 #"      OR pia30 ='' OR pia40 =' ') " #FUN-5B0137
                  "      ) " #FUN-5B0137
    END IF
    PREPARE t826_precount FROM g_sql
    DECLARE t826_count CURSOR FOR t826_precount
END FUNCTION
 
FUNCTION t826_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            #No.FUN-570082  --begin
            IF g_sma.sma115 = 'N' THEN
               CALL cl_set_act_visible("multi_unit_adjust",FALSE)
            ELSE
               CALL cl_set_act_visible("multi_unit_adjust",TRUE)
            END IF
            #No.FUN-570082  --end
 
        ON ACTION fast_adjust
            LET g_chr = 'Y'         #TQC-960358                 
            LET g_action_choice="fast_adjust"
            IF cl_chk_act_auth() THEN
                 CALL t826_a()
            END IF
        ON ACTION query
            LET g_chr = 'Y'         #TQC-960358                 
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t826_q()
            END IF
 
#No.FUN-8A0147--begin
        ON ACTION lot_checking
            LET g_action_choice="lot_checking"   #FUN-B70032
            IF NOT cl_chk_act_auth() THEN RETURN END IF
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM pias_file
             WHERE pias01=g_pia.pia01
            IF g_cnt= 0 THEN RETURN END IF
            CALL s_lotcheck(g_pia.pia01,g_pia.pia02, 
                            g_pia.pia03,g_pia.pia04, 
                            g_pia.pia05,g_qty,'QRY')
                  RETURNING l_y,l_qty                 
            IF l_y = 'Y' THEN                        
               LET g_qty = l_qty          
            END IF                                 
#No.FUN-8A0147--begin
 
        #FUN-B70032 --START--
        ON ACTION icd_checking
            LET g_action_choice="icd_checking"
            IF NOT cl_chk_act_auth() THEN RETURN END IF
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM piad_file
             WHERE piad01=g_pia.pia01
            IF g_cnt= 0 THEN RETURN END IF
            CALL s_icdcount(g_pia.pia01,g_pia.pia02, 
                            g_pia.pia03,g_pia.pia04, 
                            g_pia.pia05,g_qty,'QRY')
                  RETURNING l_y,l_qty                             
        #FUN-B70032 --END--
        
        ON ACTION next
            CALL t826_fetch('N')
        ON ACTION previous
            CALL t826_fetch('P')
        ON ACTION adjust
            CALL t826_u()
        #No.FUN-570082  --begin
        ON ACTION multi_unit_adjust
            LET g_sql = "aimt828"," '",g_pia.pia01 CLIPPED,"'"
            CALL cl_cmdrun_wait(g_sql)
            CALL t826_multi_unit()
        #No.FUN-570082  --end
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t826_fetch('/')
        ON ACTION first
            CALL t826_fetch('F')
        ON ACTION last
            CALL t826_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
{
       ON ACTION mntn_unit
             #WHEN INFIELD(unit) #單位換算
                   CALL cl_cmdrun("aooi101 ")
 
       ON ACTION mntn_unit_conv
             #WHEN INFIELD(unit) #單位換算
                   CALL cl_cmdrun("aooi102 ")
 
       ON ACTION mntn_item_unit_conv
             #WHEN INFIELD(unit) #料件單位換算資料
                   CALL cl_cmdrun("aooi103")
}
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t826_cs
END FUNCTION
 
 
#快速輸入
FUNCTION t826_a()
 DEFINE  l_msg1,l_msg2   LIKE ze_file.ze03     #No.FUN-690026 VARCHAR(70)
 DEFINE  l_i             LIKE type_file.num5   #No.FUN-570028  #No.FUN-690026 SMALLINT
 DEFINE  l_no_ep         LIKE type_file.num5   #No.FUN-8A0147
 DEFINE  l_chr           LIKE type_file.chr1   #TQC-960358 
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                      # 清螢墓欄位內容
#No.FUN-8A0147--begin
    LET l_no_ep=LENGTH(g_pia.pia01)
    IF l_no_ep = 0 OR cl_null(l_no_ep) THEN
       LET l_no_ep = 16
    END IF    
#No.FUN-8A0147--end
    INITIALIZE g_pia.* LIKE pia_file.*
    LET g_pia01_t = NULL
    LET g_qty = 0
    LET l_msg1 = 'Del:登錄結束,<^F>:欄位說明'
    LET l_msg2=  '↑↓←→:移動游標, <^A>:插字,<^X>:消字'
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       MESSAGE l_msg1,l_msg2
    ELSE
       DISPLAY l_msg1 AT 1,1
       DISPLAY l_msg2 AT 2,1
    END IF
    LET l_i=0 #FUN-570028
    LET l_chr = 'Y'   #TQC-960358  
        
    WHILE TRUE
 
        CLEAR FORM
        INITIALIZE g_pia.* LIKE pia_file.*
        LET g_qty  = NULL
        LET g_unit = NULL
       #LET g_pia.pia01 = g_pia_t.pia01[1,3]
       #start FUN-5A0199
       #LET g_pia.pia01 = g_pia_t.pia01[1,3],'-',
       #                # g_pia_t.pia01[5,10] + 1 using '&&&&&&'
       #                  g_pia_t.pia01[5,10] +l_i using '&&&&&&' #FUN-570028
#No.FUN-8A0147--begin
#       LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                         g_pia_t.pia01[g_no_sp,g_no_ep] +l_i using '&&&&&&' #FUN-570028
#----TQC-CB0097---MARK---
#       CASE l_no_ep
#         WHEN 5  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&'
#         WHEN 6  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&'
#         WHEN 7  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&'
#         WHEN 8  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&'
#         WHEN 9  LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&'
#         WHEN 10 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&'
#         WHEN 11 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&'
#         WHEN 12 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&'
#         WHEN 13 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&'
#         WHEN 14 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&'
#         WHEN 15 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&&'
#         WHEN 16 LET g_pia.pia01 = g_pia_t.pia01[1,g_doc_len],'-',
#                                   g_pia_t.pia01[g_no_sp,l_no_ep] +l_i using '&&&&&&&&&&&&'
#       END CASE 
#----TQC-CB0097---MARK---
#No.FUN-8A0147--end
       #end FUN-5A0199
        LET l_i=1 #FUN-570028
 
        CALL t826_i("a")                            # 各欄位輸入
        LET l_no_ep = g_no_ep_1                     #No.FUN-8A0147
        IF INT_FLAG THEN                            # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_pia.* TO NULL
            LET l_chr = 'N'   #TQC-960358
            LET g_chr = 'N'   #TQC-960358                 
            LET g_qty = NULL  LET g_unit = NULL
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_pia.pia01 IS NULL OR g_unit IS NULL OR
           g_qty IS NULL
        THEN CONTINUE WHILE
        END IF
        IF g_pia.pia03 IS NULL THEN LET g_pia.pia03 = ' ' END IF
        IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
        IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
        IF g_pia.pia931 IS NULL THEN LET g_pia.pia931 = '1' END IF    #FUN-930121
        LET g_pia.pia30 = g_qty
        LET g_pia.pia40 = g_qty
        LET g_pia.pia09 = g_unit
        UPDATE pia_file SET pia_file.* = g_pia.*    # 更新DB
            WHERE pia01 = g_pia.pia01               # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
            CALL cl_err3("upd","pia_file",g_pia_t.pia01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
            CONTINUE WHILE
        END IF
        LET g_pia_t.* = g_pia.*                # 保存上筆資料
    END WHILE
#TQC-960358 --begin--
#   IF g_chr = 'N' AND l_chr = 'N' THEN      #TQC-CC0095--mark--
    IF g_chr = 'N' AND l_chr = 'N' AND g_row_count > 0 THEN   #TQC-CC0095-add
       CALL t826_q()
    END IF 
#TQC-960358 --end--      
END FUNCTION
 
FUNCTION t826_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
	l_ime09         LIKE ime_file.ime09,
	l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_sw            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
    DEFINE l_cnt1          LIKE type_file.num5    #No.MOD-940074 add
    DEFINE l_tf         LIKE type_file.chr1     #No.FUN-BB0086
    DEFINE l_sql        STRING                #FUN-CB0087
    DEFINE l_where      STRING                #FUN-CB0087
 
    IF g_pia.pia19 ='Y' THEN
       CALL cl_err(g_pia.pia01,'mfg0132',0) RETURN
    END IF
    #No.FUN-570082  --begin
    IF p_cmd='a' AND g_sma.sma115='Y' THEN
       CALL t826_pia01('d')
    END IF
    #No.FUN-570082  --end  
    INPUT g_pia.pia01,g_pia.pia02,g_pia.pia03,g_pia.pia04,
          g_pia.pia05,g_pia.pia06,g_pia.pia09,g_pia.pia07,
          g_qty,g_unit,g_pia.pia930,     #FUN-670093   
          g_pia.pia70                   #FUN-CB0087 add>pia70
          WITHOUT DEFAULTS
      FROM pia01,pia02,pia03,pia04,
           pia05,pia06,pia09,pia07,
           qty,unit,pia930, #FUN-670093             
           pia70                     #FUN-CB0087 add>pia70
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i110_set_entry(p_cmd)
         CALL i110_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         #No.FUN-BB0086--add--start--
         IF p_cmd = 'u' THEN 
            LET g_unit_t = g_unit   
         END IF 
         IF p_cmd = 'a' THEN 
            LET g_unit_t = ""
         END IF 
         #No.FUN-BB0086--add--end--
 
#        BEFORE FIELD pia01
#            IF p_cmd = 'u' THEN NEXT FIELD qty  END IF
 
        AFTER FIELD pia01
           LET l_tf = ""   #No.FUN-BB0086
           IF g_pia.pia01 IS NOT NULL OR g_pia.pia01 != ' ' THEN
             CALL t826_pia01('d')
                IF NOT cl_null(g_errno)  THEN
                   CALL cl_err(g_pia.pia01,'mfg0114',0)
                   NEXT FIELD pia01
                END IF
                #No.FUN-BB0086--add--begin--
                IF g_sma.sma115='Y' AND g_ima906='2' THEN
                   LET g_qty=s_digqty(g_qty,g_unit)
                   DISPLAY g_qty TO FORMONLY.qty
                ELSE 
                   CALL t826_qty_check(l_cnt1,p_cmd) RETURNING l_tf   
                END IF 
                #No.FUN-BB0086--add--end--
           END IF
#No.FUN-8A0147--begin
           LET g_no_ep_1 = LENGTH(g_pia.pia01)
           IF g_no_ep_1 = 0 OR cl_null(g_no_ep_1) THEN
              LET g_no_ep_1 = 16
           END IF           
#No.FUN-8A0147--end
           #No.FUN-BB0086--add--start--
           LET g_unit_t = g_unit
           IF NOT l_tf THEN NEXT FIELD qty END IF 
           #No.FUN-BB0086--add--end--
 
        #No.FUN-570082  --begin
        BEFORE FIELD qty
            IF g_sma.sma115='Y' THEN
               LET g_ima906=NULL
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01=g_pia.pia02
               IF g_ima906='2' THEN
                  LET g_sql = "aimt828"," '",g_pia.pia01 CLIPPED,"'"
                  CALL cl_cmdrun_wait(g_sql)
                  CALL t826_multi_unit()
                  CALL i110_set_entry(p_cmd)
                  CALL i110_set_no_entry(p_cmd)
               END IF
               IF p_cmd='a' THEN
                  CALL cl_anykey('')
               END IF
            END IF
        #No.FUN-570082  --end
 
        AFTER FIELD qty
           IF NOT t826_qty_check(l_cnt1,p_cmd) THEN NEXT FIELD qty END IF   #No.FUN-BB0086
            #No.FUN-BB0086--mark--start---
				##No.FUN-8A0147--begin
            #IF NOT cl_null(g_qty) THEN
            #   IF g_qty < 0 THEN 
            #      LET g_qty = g_qty_t
            #      NEXT FIELD qty
            #   END IF 
            #   IF g_qty != g_qty_t OR g_qty_t IS NULL THEN
            #     #-----------No.MOD-940074 add
            #      LET l_cnt1=0
            #      SELECT COUNT(*) INTO l_cnt1 FROM pias_file
            #       WHERE pias01=g_pia.pia01
            #      IF l_cnt1 > 0 THEN
            #     #-----------No.MOD-940074 end
            #         CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
            #                         g_pia.pia03,g_pia.pia04,
            #                         g_pia.pia05,g_qty,'SET')
            #              RETURNING l_y,l_qty  
            #      END IF     #No.MOD-940074 add 
            #      #FUN-B70032 --START--
            #      IF s_industry('icd') THEN
            #         LET l_cnt1=0
            #         SELECT COUNT(*) INTO l_cnt1 FROM piad_file
            #          WHERE piad01=g_pia.pia01
            #         IF l_cnt1 > 0 THEN                 
            #            CALL s_icdcount(g_pia.pia01,g_pia.pia02,
            #                            g_pia.pia03,g_pia.pia04,
            #                            g_pia.pia05,g_qty,'SET')
            #                 RETURNING l_y,l_qty  
            #         END IF
            #      END IF    
            #      #FUN-B70032 --END--
            #   END IF
            #   IF l_y = 'Y' THEN   
            #      LET g_qty = l_qty
            #      LET g_qty_t = g_qty   #FUN-B70032
            #      DISPLAY g_qty TO FORMONLY.qty
            #   END IF
            #END IF 
					  ##No.FUN-8A0147--end
            #IF p_cmd ='u' OR
            #   (p_cmd = 'a' AND g_pia.pia16 = 'N')
            #THEN 
            #   #EXIT INPUT #mark by FUN-670093
            #END IF
            #No.FUN-BB0086--mark--end---
 
        AFTER FIELD unit
	        IF g_unit IS NOT NULL OR g_unit != ' ' THEN
                 CALL t826_unit(g_unit)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_unit,g_errno,0)
                    LET g_unit = g_unit_o
                    DISPLAY BY NAME g_unit
                    NEXT FIELD unit
                 END IF
                 IF g_sma.sma12 = 'Y' THEN
                    CALL s_umfchk(g_pia.pia02,g_ima25,g_unit)
                         RETURNING g_cnt,g_pia.pia10
                    IF g_cnt THEN
                       CALL cl_err('','mfg3075',0)
                       LET g_unit = g_unit_o
                       DISPLAY g_unit TO FORMONLY.unit
                       NEXT FIELD unit
                    END IF
                 ELSE
                    LET g_pia.pia10 = 1
                 END IF
                 #No.FUN-BB0086--add--start--
                 IF g_sma.sma115='Y' AND g_ima906='2' THEN
                    LET g_qty = s_digqty(g_qty,g_unit)
                    DISPLAY g_qty TO FORMONLY.qty
                 ELSE 
                    IF NOT t826_qty_check(l_cnt1,p_cmd) THEN 
                       LET g_unit_t = g_unit
                       LET g_unit_o = g_pia.pia09
                       NEXT FIELD qty
                    END IF    
                 END IF 
                 LET g_unit_t = g_unit
                 #No.FUN-BB0086--add--end--
            END IF
            LET g_unit_o = g_pia.pia09
        #FUN-670093...............begin
        AFTER FIELD pia930
            IF NOT s_costcenter_chk(g_pia.pia930) THEN
               LET g_pia.pia930=g_pia_t.pia930
               DISPLAY NULL TO FORMONLY.gem02
               DISPLAY BY NAME g_pia.pia930
               NEXT FIELD pia930
            ELSE
               DISPLAY s_costcenter_desc(g_pia.pia930) TO FORMONLY.gem02
            END IF
        #FUN-670093...............end
        #FUN-CB0087---add---str---
        BEFORE FIELD pia70
           IF g_aza.aza115 = 'Y' AND cl_null(g_pia.pia70) THEN
              CALL s_reason_code(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,'','') RETURNING g_pia.pia70
              CALL t826_pia70()
              DISPLAY BY NAME g_pia.pia70
           END IF

        AFTER FIELD pia70
           IF g_pia.pia70 IS NOT NULL THEN
              LET l_n = 0
              CALL s_get_where(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,'','') RETURNING l_flag,l_where
              IF g_aza.aza115='Y' AND l_flag THEN
                 LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pia.pia70,"' AND ",l_where
                 PREPARE ggc08_pre FROM l_sql
                 EXECUTE ggc08_pre INTO l_n
                 IF l_n < 1 THEN
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD pia70
                 END IF
              ELSE
                 SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=g_pia.pia70 AND azf02='2'
                 IF l_n < 1 THEN
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD pia70
                 END IF
              END IF
           END IF                 #TQC-D20047---add---
           CALL t826_pia70()
          # END IF                 #TQC-D20047---mark---
        #FUN-CB0087---add---end--- 

        AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT  END IF
          IF g_aza.aza115 = 'Y' THEN              #TQC-D10103---add---
             #FUN-CB0087---add---str---
             LET l_n = 0
             CALL s_get_where(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,'','') RETURNING l_flag,l_where
             IF g_aza.aza115='Y' AND l_flag AND NOT cl_null(g_pia.pia70) THEN
                LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_pia.pia70,"' AND ",l_where
                PREPARE ggc08_pre1 FROM l_sql
                EXECUTE ggc08_pre1 INTO l_n
                IF l_n < 1 THEN
                   CALL cl_err('','aim-425',0)
                   NEXT FIELD pia70
                END IF
             ELSE
                SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=g_pia.pia70 AND azf02='2'
                IF l_n < 1 THEN
                   CALL cl_err('','aim-425',0)
                   NEXT FIELD pia70
                END IF
             END IF
             #FUN-CB0087---add---end---
          END IF                                 #TQC-D10103---add---
          CALL t826_pia70()                      #TQC-D20042
 
        ON ACTION controlp
            CASE
#----TQC-CB0097---ADD---STAR--
              WHEN INFIELD(pia01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pia01"
                 CALL cl_create_qry() RETURNING g_pia.pia01
                 DISPLAY BY NAME g_pia.pia01
                 NEXT FIELD pia01
              WHEN INFIELD(pia02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pia02"
                 CALL cl_create_qry() RETURNING g_pia.pia02
                 DISPLAY BY NAME g_pia.pia02
                 NEXT FIELD pia02
              WHEN INFIELD(pia03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pia03"
                 CALL cl_create_qry() RETURNING g_pia.pia03
                 DISPLAY BY NAME g_pia.pia03
                 NEXT FIELD pia03
              WHEN INFIELD(pia04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pia04"
                 CALL cl_create_qry() RETURNING g_pia.pia04
                 DISPLAY BY NAME g_pia.pia04
                 NEXT FIELD pia04
              WHEN INFIELD(pia05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pia05"
                 CALL cl_create_qry() RETURNING g_pia.pia05 
                 DISPLAY BY NAME g_pia.pia05
                 NEXT FIELD pia05
#----TQC-CB0097---ADD---end--
               WHEN INFIELD(unit) #庫存單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_gfe"
                  LET g_qryparam.default1 = g_unit
                  CALL cl_create_qry() RETURNING g_unit
                  DISPLAY g_unit TO FORMONLY.unit
                  NEXT FIELD unit
               #FUN-670093...............begin
               WHEN INFIELD(pia930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem4"
                  CALL cl_create_qry() RETURNING g_pia.pia930
                  DISPLAY BY NAME g_pia.pia930
                  NEXT FIELD pia930
               #FUN-670093...............end
               #FUN-CB0087---add---str---
               WHEN INFIELD(pia70)
                  CALL s_get_where(g_pia.pia01,'','',g_pia.pia02,g_pia.pia03,'','') RETURNING l_flag,l_where
                  IF g_aza.aza115='Y' AND l_flag THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_pia.pia70
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_azf41"
                     LET g_qryparam.default1 = g_pia.pia70
                  END IF
                  CALL cl_create_qry() RETURNING g_pia.pia70
                  DISPLAY BY NAME g_pia.pia70
                  CALL t826_pia70()
                  NEXT FIELD pia70
               #FUN-CB0087---add---end---
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION mntn_unit
             #WHEN INFIELD(unit) #單位換算
                   CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
             #WHEN INFIELD(unit) #單位換算
                   CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv
             #WHEN INFIELD(unit) #料件單位換算資料
                   CALL cl_cmdrun("aooi103")
 
#No.FUN-8A0147--begin
       ON ACTION lotcheck
         #-----------No.MOD-940074 add
          LET l_cnt1=0
          SELECT COUNT(*) INTO l_cnt1 FROM pias_file
           WHERE pias01=g_pia.pia01
          IF l_cnt1 > 0 THEN
         #-----------No.MOD-940074 end
             CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
                             g_pia.pia03,g_pia.pia04,
                             g_pia.pia05,g_qty,'SET')
                   RETURNING l_y,l_qty             
          END IF      #No.MOD-940074 add
          IF l_y = 'Y' THEN                    
             LET g_qty = l_qty      
          END IF                             
#No.FUN-8A0147--begin

        #FUN-B70032 --START-- 
        ON ACTION icdcheck         
          LET l_cnt1=0
          SELECT COUNT(*) INTO l_cnt1 FROM piad_file
           WHERE piad01=g_pia.pia01
          IF l_cnt1 > 0 THEN         
             CALL s_icdcount(g_pia.pia01,g_pia.pia02,
                             g_pia.pia03,g_pia.pia04,
                             g_pia.pia05,g_qty,'SET')
                   RETURNING l_y,l_qty             
          END IF      
          IF l_y = 'Y' THEN                    
             LET g_qty = l_qty
             LET g_qty_t = g_qty
             DISPLAY g_qty TO FORMONLY.qty      
          END IF    
        #FUN-B70032 --END--     
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
    
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
 
    END INPUT
END FUNCTION
 
FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pia01",TRUE)
   END IF
 
   #No.FUN-570082  --begin
   CALL cl_set_comp_entry("qty",TRUE)
   #No.FUN-570082  --end
 
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pia01",FALSE)
   END IF
 
   #No.FUN-570082  --begin
   IF INFIELD(qty) THEN
      IF g_sma.sma115='Y' AND g_ima906='2' THEN
         CALL cl_set_comp_entry("qty",FALSE)
      END IF
   END IF
   #No.FUN-570082  --end
 
END FUNCTION
 
FUNCTION t826_pia01(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT pia_file.*, ima02,ima021,ima25,imaacti
      INTO g_pia.*, l_ima02,l_ima021,g_ima25,l_imaacti
      FROM pia_file, OUTER ima_file
      WHERE pia01 = g_pia.pia01 AND pia_file.pia02 = ima_file.ima01
 
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
               LET g_pia.pia02  = NULL
              LET g_pia.pia03 = NULL LET g_pia.pia04 = NULL
              LET g_pia.pia05 = NULL LET g_pia.pia06 = NULL
              LET g_pia.pia07 = NULL LET g_pia.pia09 = NULL
              LET l_ima02     = NULL LET l_ima021    = NULL
              LET l_imaacti   = NULL
    	WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_pia.pia02,g_pia.pia03,g_pia.pia04,
                       g_pia.pia05,g_pia.pia06,g_pia.pia07,
                       g_pia.pia09,g_pia.pia30,g_pia.pia40
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY g_pia.pia09 TO FORMONLY.pia09_1
       DISPLAY g_pia.pia09 TO FORMONLY.pia09_2
       LET g_unit = g_pia.pia09
       DISPLAY g_pia.pia09 TO FORMONLY.unit
    END IF
END FUNCTION
 
FUNCTION t826_pia02(p_cmd)  #料件編號
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
	LET l_ima02=' '
	LET l_ima021=' '
    SELECT ima02,ima021,ima25,imaacti INTO l_ima02,l_ima021,g_ima25,l_imaacti
           FROM ima_file WHERE ima01 = g_pia.pia02
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg0002'
		  LET l_ima02 = NULL
		  LET l_ima021 = NULL
    	WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
    IF p_cmd = 'a' THEN LET g_pia.pia09 = g_ima25 END IF
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY BY NAME g_pia.pia09
    END IF
END FUNCTION
 
#檢查單位是否存在於單位檔中
FUNCTION t826_unit(p_unit)
    DEFINE p_unit    LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = p_unit
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t826_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t826_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t826_count
    FETCH t826_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t826_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        INITIALIZE g_pia.* TO NULL
        LET g_qty = NULL LET g_unit =NULL
    ELSE
        CALL t826_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t826_fetch(p_flpia)
    DEFINE
        p_flpia          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flpia
        WHEN 'N' FETCH NEXT     t826_cs INTO g_pia.pia01
        WHEN 'P' FETCH PREVIOUS t826_cs INTO g_pia.pia01
        WHEN 'F' FETCH FIRST    t826_cs INTO g_pia.pia01
        WHEN 'L' FETCH LAST     t826_cs INTO g_pia.pia01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t826_cs INTO g_pia.pia01
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        INITIALIZE g_pia.* TO NULL  #TQC-6B0105
              #TQC-6B0105
        RETURN
    ELSE
       CASE p_flpia
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_pia.* FROM pia_file   # 重讀DB,因TEMP有不被更新特性
       WHERE pia01 = g_pia.pia01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","pia_file",g_pia.pia01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
 
        CALL t826_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t826_show()
    LET g_pia_t.* = g_pia.*
    LET g_qty = NULL LET g_unit = NULL
    DISPLAY BY NAME
        g_pia.pia01,g_pia.pia02,g_pia.pia03,g_pia.pia04,
        g_pia.pia05,g_pia.pia06,g_pia.pia09,
        g_pia.pia07,g_pia.pia30,g_pia.pia40,g_pia.pia930,g_pia.pia70 #FUN-670093  #FUN-CB0087 add>pia70
    DISPLAY g_qty       TO FORMONLY.qty
    DISPLAY g_unit      TO FORMONLY.unit
    DISPLAY g_pia.pia09 TO FORMONLY.pia09_1
    DISPLAY g_pia.pia09 TO FORMONLY.pia09_2
    LET g_unit = g_pia.pia09
    CALL t826_pia02('d')
    #FUN-CB0087---add---str---
    IF g_pia.pia70 IS NOT NULL THEN
       CALL t826_pia70()
    ELSE
       DISPLAY '' TO azf03
    END IF
    #FUN-CB0087---add---end---
    DISPLAY s_costcenter_desc(g_pia.pia930) TO FORMONLY.gem02 #FUN-670093
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t826_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_pia.pia01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pia01_t = g_pia.pia01
    LET g_qty_t = g_qty                 #No.FUN-8A0147
    LET g_pia_o.*=g_pia.*
    LET g_qty = NULL  LET g_unit = NULL
    BEGIN WORK
 
    #-genero-------------------------------------------------------------
    #(1) If you have "?" inside above DECLARE SELECT FOR UPDATE SQL
    #(2) Then using syntax: "OPEN cursor USING variable"
    #For example, "OPEN a USING g_a_worid"
    #
    #* Remember to remove releated block of *.ora file, no more needed
    #--------------------------------------------------------------------
    #--Put variable into LOCK CURSOR
    OPEN t826_cl USING g_pia.pia01
    #--Add exception check during OPEN CURSOR
    IF STATUS THEN
       CALL cl_err("OPEN t826_cl:", STATUS, 1)
       CLOSE t826_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t826_cl INTO g_pia.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t826_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t826_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pia.*=g_pia_t.*
            CALL t826_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
{&}     IF g_pia.pia03 IS NULL THEN LET g_pia.pia03 = ' ' END IF
        IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
        IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
        LET g_pia.pia30 = g_qty
        LET g_pia.pia40 = g_qty
        LET g_pia.pia09 = g_unit
        UPDATE pia_file SET pia_file.* = g_pia.*    # 更新DB
            WHERE pia01 = g_pia01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_pia.pia01,SQLCA.sqlcode,0)
           CALL cl_err3("upd","pia_file",g_pia_t.pia01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t826_cl
    COMMIT WORK
END FUNCTION
 
#No.FUN-570082  --begin
FUNCTION t826_multi_unit()
  DEFINE l_ima906  LIKE ima_file.ima906
 
    IF cl_null(g_pia.pia01) THEN RETURN END IF
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_pia.pia02 
   #IF l_ima906 = '2' THEN #FUN-5B0137
    IF (l_ima906 = '2') OR (l_ima906='3') THEN #FUN-5B0137
       SELECT SUM(piaa30*piaa10) INTO g_pia.pia30 FROM piaa_file
        WHERE piaa01=g_pia.pia01
          AND piaa02=g_pia.pia02
          AND piaa03=g_pia.pia03
          AND piaa04=g_pia.pia04
          AND piaa05=g_pia.pia05
          AND piaa30 IS NOT NULL
          AND piaa10 IS NOT NULL
       SELECT SUM(piaa40*piaa10) INTO g_pia.pia40 FROM piaa_file
        WHERE piaa01=g_pia.pia01
          AND piaa02=g_pia.pia02
          AND piaa03=g_pia.pia03
          AND piaa04=g_pia.pia04
          AND piaa05=g_pia.pia05
          AND piaa40 IS NOT NULL
          AND piaa10 IS NOT NULL
       UPDATE pia_file SET pia30=g_pia.pia30,
                           pia40=g_pia.pia40
              WHERE pia01=g_pia.pia01
       IF SQLCA.sqlcode THEN
#         CALL cl_err('update pia',SQLCA.sqlcode,0)
          CALL cl_err3("upd","pia_file",g_pia.pia01,"",SQLCA.sqlcode,"",
                       "update pia",1)   #NO.FUN-640266 #No.FUN-660156
       END IF
       IF g_pia.pia30=g_pia.pia40 THEN
          LET g_qty=g_pia.pia30
       END IF
    END IF
    DISPLAY BY NAME g_pia.pia30
    DISPLAY BY NAME g_pia.pia40
    DISPLAY g_qty TO FORMONLY.qty
END FUNCTION
#No.FUN-570082  --end  

#No.FUN-BB0086--add--start--
FUNCTION t826_qty_check(l_cnt1,p_cmd)
DEFINE l_cnt1          LIKE type_file.num5
DEFINE p_cmd           LIKE type_file.chr1
   IF NOT cl_null(g_qty) AND NOT cl_null(g_unit) THEN
      IF cl_null(g_qty_t) OR cl_null(g_unit_t) OR g_qty_t != g_qty OR g_unit_t != g_unit THEN
         LET g_qty=s_digqty(g_qty,g_unit)
         DISPLAY g_qty TO FORMONLY.qty
      END IF
   END IF
   IF NOT cl_null(g_qty) THEN
      IF g_qty < 0 THEN 
         LET g_qty = g_qty_t
         RETURN FALSE 
      END IF 
      IF g_qty != g_qty_t OR g_qty_t IS NULL THEN
        #-----------No.MOD-940074 add
         LET l_cnt1=0
         SELECT COUNT(*) INTO l_cnt1 FROM pias_file
          WHERE pias01=g_pia.pia01
         IF l_cnt1 > 0 THEN
        #-----------No.MOD-940074 end
            CALL s_lotcheck(g_pia.pia01,g_pia.pia02,
                            g_pia.pia03,g_pia.pia04,
                            g_pia.pia05,g_qty,'SET')
                 RETURNING l_y,l_qty  
         END IF     #No.MOD-940074 add 
         #FUN-B70032 --START--
         IF s_industry('icd') THEN
            LET l_cnt1=0
            SELECT COUNT(*) INTO l_cnt1 FROM piad_file
             WHERE piad01=g_pia.pia01
            IF l_cnt1 > 0 THEN                 
               CALL s_icdcount(g_pia.pia01,g_pia.pia02,
                               g_pia.pia03,g_pia.pia04,
                               g_pia.pia05,g_qty,'SET')
                    RETURNING l_y,l_qty  
            END IF
         END IF    
         #FUN-B70032 --END--
      END IF
      IF l_y = 'Y' THEN   
         LET g_qty = l_qty
         LET g_qty_t = g_qty   #FUN-B70032
         DISPLAY g_qty TO FORMONLY.qty
      END IF
   END IF 
#No.FUN-8A0147--end
   IF p_cmd ='u' OR
      (p_cmd = 'a' AND g_pia.pia16 = 'N')
   THEN 
      #EXIT INPUT #mark by FUN-670093
   END IF
   RETURN TRUE 
END FUNCTION 
#No.FUN-BB0086--add--end--
#FUN-CB0087---add---str---
FUNCTION t826_pia70()
 IF g_pia.pia70 IS NOT NULL THEN
   SELECT azf03 INTO g_azf03
     FROM azf_file
    WHERE azf01 = g_pia.pia70
      AND azf02 = '2'
   DISPLAY g_azf03 TO azf03
 ELSE
   DISPLAY '' TO azf03
 END IF
END FUNCTION
#FUN-CB0087---add---end---

