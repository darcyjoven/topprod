# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: atmi209.4gl
# Descriptions...: 媒體基本資料維護作業
# Date & Author..: 05/10/18 By vivien
# Modify.........: NO.FUN-590118 06/01/19 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630069 06/03/07 By Smapmin 流程訊息通知功能
# Modify.........: No.TQC-660071 06/06/14 By Smapmin 補充TQC-630069
# Modify.........: No.FUN-660104 06/06/19 By cl  Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0014 06/11/06 By dxfwo l_time轉g_time 
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6B0043 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.TQC-710043 07/01/11 By Rayven 收視人口’輸入時必須大于0
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/23 By mike報表格式修改為crystal reports
# Modify.........: No.TQC-790021 07/09/03 重過程式到正式區
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/18 By TSD.Wind 自定欄位功能修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-AB0164 10/11/28 By shiwuying CONSTRUCT 加上toforiu,toforig
# Modify.........: No.CHI-B40058 11/05/16 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B80061 11/08/05 By Lujh 模組程序撰寫規範修正
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30033 13/04/10 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_tof           RECORD LIKE tof_file.*,       #媒體資料 #TQC-790021
    g_tof_t         RECORD LIKE tof_file.*,       #媒體資料（舊值）
    g_tof_o         RECORD LIKE tof_file.*,       #媒體資料（舊值）
    g_tof01_t       LIKE tof_file.tof01,          #媒體編號 (舊值)
    g_ydate         LIKE type_file.dat,           #No.FUN-680120 DATE                        #單據日期(沿用)
    g_tog           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        tog02       LIKE tog_file.tog02,          #項次
        tog03       LIKE tog_file.tog03,          #起始時段
        tog04       LIKE tog_file.tog04,          #截止時段
        tog05       LIKE tog_file.tog05,          #單位
        toa02b      LIKE toa_file.toa02,          #單位名稱
        tog06       LIKE tog_file.tog06,          #單價
        tog07       LIKE tog_file.tog07,          #備注
        #FUN-840068 --start---
        togud01     LIKE tog_file.togud01,
        togud02     LIKE tog_file.togud02,
        togud03     LIKE tog_file.togud03,
        togud04     LIKE tog_file.togud04,
        togud05     LIKE tog_file.togud05,
        togud06     LIKE tog_file.togud06,
        togud07     LIKE tog_file.togud07,
        togud08     LIKE tog_file.togud08,
        togud09     LIKE tog_file.togud09,
        togud10     LIKE tog_file.togud10,
        togud11     LIKE tog_file.togud11,
        togud12     LIKE tog_file.togud12,
        togud13     LIKE tog_file.togud13,
        togud14     LIKE tog_file.togud14,
        togud15     LIKE tog_file.togud15
        #FUN-840068 --end--
                    END RECORD,
    g_tog_t         RECORD                        #程式變數 (舊值)
        tog02       LIKE tog_file.tog02,          #項次
        tog03       LIKE tog_file.tog03,          #起始時段
        tog04       LIKE tog_file.tog04,          #截止時段
        tog05       LIKE tog_file.tog05,          #單位
        toa02b      LIKE toa_file.toa02,          #單位名稱
        tog06       LIKE tog_file.tog06,          #單價
        tog07       LIKE tog_file.tog07,          #備注
        #FUN-840068 --start---
        togud01     LIKE tog_file.togud01,
        togud02     LIKE tog_file.togud02,
        togud03     LIKE tog_file.togud03,
        togud04     LIKE tog_file.togud04,
        togud05     LIKE tog_file.togud05,
        togud06     LIKE tog_file.togud06,
        togud07     LIKE tog_file.togud07,
        togud08     LIKE tog_file.togud08,
        togud09     LIKE tog_file.togud09,
        togud10     LIKE tog_file.togud10,
        togud11     LIKE tog_file.togud11,
        togud12     LIKE tog_file.togud12,
        togud13     LIKE tog_file.togud13,
        togud14     LIKE tog_file.togud14,
        togud15     LIKE tog_file.togud15
        #FUN-840068 --end--
                    END RECORD,
    g_tog_o         RECORD                        #程式變數 (舊值)
        tog02       LIKE tog_file.tog02,          #項次
        tog03       LIKE tog_file.tog03,          #起始時段
        tog04       LIKE tog_file.tog04,          #截止時段
        tog05       LIKE tog_file.tog05,          #單位
        toa02b      LIKE toa_file.toa02,          #單位名稱
        tog06       LIKE tog_file.tog06,          #單價
        tog07       LIKE tog_file.tog07,          #備注
        #FUN-840068 --start---
        togud01     LIKE tog_file.togud01,
        togud02     LIKE tog_file.togud02,
        togud03     LIKE tog_file.togud03,
        togud04     LIKE tog_file.togud04,
        togud05     LIKE tog_file.togud05,
        togud06     LIKE tog_file.togud06,
        togud07     LIKE tog_file.togud07,
        togud08     LIKE tog_file.togud08,
        togud09     LIKE tog_file.togud09,
        togud10     LIKE tog_file.togud10,
        togud11     LIKE tog_file.togud11,
        togud12     LIKE tog_file.togud12,
        togud13     LIKE tog_file.togud13,
        togud14     LIKE tog_file.togud14,
        togud15     LIKE tog_file.togud15
        #FUN-840068 --end--
                    END RECORD,
#    g_wc,g_wc2,g_sql    LIKE type_file.chr1000, #NO.TQC-630166 MARK            #No.FUN-680120 VARCHAR(3000)
    g_wc,g_wc2,g_sql     STRING,      #NO.TQC-630166 
    g_rec_b         LIKE type_file.num5,                       #單身筆數        #No.FUN-680120 SMALLINT
    l_ac            LIKE type_file.num5                        #目前處理的ARRAY CNT        #No.FUN-680120 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5                        #No.FUN-680120 SMALLINT
DEFINE g_gec07      LIKE gec_file.gec07
DEFINE g_forupd_sql         STRING                #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_chr                LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i                  LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE g_curs_index         LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_row_count          LIKE type_file.num10         #總筆數                    #No.FUN-680120 INTEGER
DEFINE g_jump               LIKE type_file.num10         #查詢指定的筆數            #No.FUN-680120 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5          #是否開啟指定筆視窗        #No.FUN-680120 SMALLINT
DEFINE g_argv1              LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(16)    #TQC-630069
DEFINE g_argv2         STRING     #TQC-630069
DEFINE g_str           STRING     #No.FUN-760083
DEFINE l_table         STRING     #No.FUN-760083
#主程式開始
MAIN
#DEFINE                                    #No.FUN-6B0014
#       l_time    LIKE type_file.chr8      #No.FUN-6B0014
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   WHENEVER ERROR CALL cl_err_msg_log
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
   LET g_argv1 = ARG_VAL(1)   #TQC-630069
   LET g_argv2 = ARG_VAL(2)   #TQC-630069
#No.FUN-760083  --BEGIN--
   LET g_sql = "tof01.tof_file.tof01,",
               "tof02.tof_file.tof02,",
               "tof03.tof_file.tof03,",
               "toa02.toa_file.toa02,",
               "tof04.tof_file.tof04,",
               "toa02a.toa_file.toa02,",
               "tof05.tof_file.tof05,",
               "tof06.tof_file.tof06,",
               "too02.too_file.too02,",
               "tof07.tof_file.tof07,",
               "top02.top_file.top02,",
               "tof08.tof_file.tof08,",
               "toq02.toq_file.toq02,",
               "tof09.tof_file.tof09,",
               "tof10.tof_file.tof10,",                                                                    
               "pma02.pma_file.pma02,",
               "tof11.tof_file.tof11,",
               "azi02.azi_file.azi02,",
               "tof12.tof_file.tof12,",
               "gec02.gec_file.gec02,",
               "tof13.tof_file.tof13,",
               "tof14.tof_file.tof14,",
               "tof15.tof_file.tof15,",                                                                    
               "tof16.tof_file.tof16,",
               "tof17.tof_file.tof17,",
               "tof18.tof_file.tof18,",
               "tof19.tof_file.tof19,",
               "tof20.tof_file.tof20,",
               "tof21.tof_file.tof21,",
               "tof22.tof_file.tof22,",
               "tofacti.tof_file.tofacti,",                                                         
               "tog02.tog_file.tog02,",
               "tog03.tog_file.tog03,",
               "tog04.tog_file.tog04,",
               "tog05.tog_file.tog05,",
               "toa02b.toa_file.toa02,",
               "tog06.tog_file.tog06,",
               "tog07.tog_file.tog07,",
               "geo02.geo_file.geo02"
   LET l_table=cl_prt_temptable("atmi209",g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM  g_sql
   IF STATUS THEN
     CALL cl_err("insert_prep:",status,1)
   END IF
#No.FUN-760083  --END--     
   LET g_forupd_sql = "SELECT * FROM tof_file WHERE tof01 = ? FOR UPDATE"                                                           
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i209_cl CURSOR FROM g_forupd_sql                           
   LET p_row = 2 LET p_col = 9
   OPEN WINDOW i209_w AT p_row,p_col        #顯示畫面
       WITH FORM "atm/42f/atmi209"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   #-----TQC-630069---------
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i209_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i209_a()
            END IF
         OTHERWISE   #TQC-660071
            CALL i209_q()   #TQC-660071
      END CASE
   END IF
   #-----END TQC-630069-----
   CALL i209_menu()
   CLOSE WINDOW i209_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
#QBE 查詢資料
FUNCTION i209_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                               #清除畫面
   CALL g_tog.clear()
   IF cl_null(g_argv1) THEN   #TQC-630069
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_tof.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON tof01,tof02,tof03,tof04,tof05,tof06,tof07,tof08,
                             tof09,tof10,tof17,tof11,tof12,tof13,tof14,tof15,
                             tof16,tof18,tof19,tof20,tof21,tof22,tofuser,
                            #tofgrup,tofmodu,tofdate,tofacti,                 #TQC-AB0164
                             tofgrup,toforiu,toforig,tofmodu,tofdate,tofacti, #TQC-AB0164
                             #FUN-840068   ---start---
                             tofud01,tofud02,tofud03,tofud04,tofud05,
                             tofud06,tofud07,tofud08,tofud09,tofud10,
                             tofud11,tofud12,tofud13,tofud14,tofud15
                             #FUN-840068    ----end----
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
             WHEN INFIELD(tof03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = '2'
                 LET g_qryparam.form ="q_toa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof03
                 NEXT FIELD tof03
           WHEN INFIELD(tof04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = '3'
                 LET g_qryparam.form ="q_toa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof04
                 NEXT FIELD tof04
            WHEN INFIELD(tof05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_geo"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof05
                 NEXT FIELD tof05
            WHEN INFIELD(tof06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_too1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof06
                 NEXT FIELD tof06
            WHEN INFIELD(tof07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_top1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof07
                 NEXT FIELD tof07
            WHEN INFIELD(tof08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 =g_tof.tof07
                 LET g_qryparam.form = "q_toq"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof08
                 NEXT FIELD tof08
            WHEN INFIELD(tof10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pma"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof10
                 NEXT FIELD tof10
            WHEN INFIELD(tof11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof11
                 NEXT FIELD tof11
            WHEN INFIELD(tof12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gec"
                 LET g_qryparam.arg1 = "1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tof12
                 NEXT FIELD tof12
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
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND tofuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND tofgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND tofgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tofuser', 'tofgrup')
   #End:FUN-980030
   CONSTRUCT g_wc2 ON tog02,tog03,tog04,tog05,tog06,tog07
             #No.FUN-840068 --start--
             ,togud01,togud02,togud03,togud04,togud05
             ,togud06,togud07,togud08,togud09,togud10
             ,togud11,togud12,togud13,togud14,togud15
             #No.FUN-840068 ---end---
           FROM s_tog[1].tog02,s_tog[1].tog03,s_tog[1].tog04,
                s_tog[1].tog05,s_tog[1].tog06,
                s_tog[1].tog07
                #No.FUN-840068 --start--
                ,s_tog[1].togud01,s_tog[1].togud02,s_tog[1].togud03
                ,s_tog[1].togud04,s_tog[1].togud05,s_tog[1].togud06
                ,s_tog[1].togud07,s_tog[1].togud08,s_tog[1].togud09
                ,s_tog[1].togud10,s_tog[1].togud11,s_tog[1].togud12
                ,s_tog[1].togud13,s_tog[1].togud14,s_tog[1].togud15
                #No.FUN-840068 ---end---
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
             WHEN INFIELD(tog05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = '6'
                 LET g_qryparam.form ="q_toa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tog05
                 NEXT FIELD tog05
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
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN
      RETURN
   END IF
   #-----TQC-630069---------
   ELSE
   LET g_wc = "tof01 = '",g_argv1,"'"
   LET g_wc2 = " 1=1"
   END IF
   #-----END TQC-630069-----
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  tof01 FROM tof_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY tof01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT  tof01 ",
                  "  FROM tof_file, tog_file ",
                  " WHERE tof01 = tog01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY tof01"
   END IF
   PREPARE i209_prepare FROM g_sql
   DECLARE i209_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i209_prepare
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM tof_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT tof01) FROM tof_file,tog_file WHERE ",
                "tog01=tof01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i209_precount FROM g_sql
   DECLARE i209_count CURSOR FOR i209_precount
END FUNCTION
FUNCTION i209_menu()
   WHILE TRUE
      CALL i209_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i209_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i209_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i209_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i209_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i209_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i209_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i209_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i209_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "about"
            CALL cl_about()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tog),'','')
            END IF
         #No.FUN-6B0043-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tof.tof01 IS NOT NULL THEN
                 LET g_doc.column1 = "tof01"
                 LET g_doc.value1 = g_tof.tof01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0043-------add--------end----
      END CASE
   END WHILE
END FUNCTION
FUNCTION i209_a()
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10            #No.FUN-680120 INTEGER
   MESSAGE ""
   CLEAR FORM
   CALL g_tog.clear()
   IF s_shut(0) THEN
      RETURN
   END IF
   INITIALIZE g_tof.* LIKE tof_file.*             #DEFAULT 設定
   LET g_tof01_t = NULL
   #預設值及將數值類變數清成零
   LET g_tof_t.* = g_tof.*
   LET g_tof_o.* = g_tof.*
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_tof.tofuser=g_user
      LET g_tof.toforiu = g_user #FUN-980030
      LET g_tof.toforig = g_grup #FUN-980030
      LET g_tof.tofgrup=g_grup
      LET g_tof.tofdate=g_today
      LET g_tof.tofacti='Y'              #資料有效
      #-----TQC-630069---------
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_tof.tof01 = g_argv1
      END IF
      #-----END TQC-630069-----
      CALL i209_i("a")                   #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_tof.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_tof.tof01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
      INSERT INTO tof_file VALUES (g_tof.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","tof_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)     #No.FUN-660104       #FUN-B80061    ADD
         ROLLBACK WORK
      #  CALL cl_err(g_tof.tof01,SQLCA.sqlcode,1)    #No.FUN-660104
      #   CALL cl_err3("ins","tof_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)     #No.FUN-660104      #FUN-B80061    MARK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_tof.tof01,'I')
      END IF
      SELECT tof01 INTO g_tof.tof01 FROM tof_file
       WHERE tof01 = g_tof.tof01
      LET g_tof01_t = g_tof.tof01        #保留舊值
      LET g_tof_t.* = g_tof.*
      LET g_tof_o.* = g_tof.*
      CALL g_tog.clear()
       LET g_rec_b = 0
      CALL i209_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
FUNCTION i209_u()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_tof.tof01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_tof.* FROM tof_file
    WHERE tof01=g_tof.tof01
   IF g_tof.tofacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tof.tof01,'mfg1000',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_tof01_t = g_tof.tof01
   BEGIN WORK
   OPEN i209_cl USING g_tof.tof01
   IF STATUS THEN
      CALL cl_err("OPEN i209_cl:", STATUS, 1)
      CLOSE i209_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i209_cl INTO g_tof.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i209_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL i209_show()
   WHILE TRUE
      LET g_tof01_t = g_tof.tof01
      LET g_tof_o.* = g_tof.*
      LET g_tof.tofmodu=g_user
      LET g_tof.tofdate=g_today
      CALL i209_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_tof.*=g_tof_t.*
         CALL i209_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_tof.tof01 != g_tof01_t THEN            # 更改單號
         UPDATE tog_file SET tog01 = g_tof.tof01
          WHERE tog01 = g_tof01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         #  CALL cl_err('tog',SQLCA.sqlcode,0)   #No.FUN-660104
            CALL cl_err3("upd","tog_file",g_tof01_t,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
            CONTINUE WHILE
         END IF
      END IF
      UPDATE tof_file SET tof_file.* = g_tof.*
       WHERE tof01 = g_tof01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      #  CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","tof_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE i209_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tof.tof01,'U')
   CALL i209_show()
END FUNCTION
FUNCTION i209_i(p_cmd)
DEFINE
   l_tog02   LIKE tog_file.tog02,
   l_toa02   LIKE toa_file.toa02,
   l_toa02a  LIKE toa_file.toa02,
   l_geo02   LIKE geo_file.geo02,
   l_too02   LIKE too_file.too02,
   l_top02   LIKE top_file.top02,
   l_toq02   LIKE toq_file.toq02,
   l_pma02   LIKE pma_file.pma02,
   l_azi02   LIKE azi_file.azi02,
   l_gec02   LIKE gec_file.gec02,
   l_n       LIKE type_file.num5,          #No.FUN-680120 SMALLINT
   p_cmd     LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680120 VARCHAR(1)
   IF s_shut(0) THEN
      RETURN
   END IF
   DISPLAY BY NAME g_tof.tofuser,g_tof.tofmodu,
       g_tof.tofgrup,g_tof.tofdate,g_tof.tofacti   
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INPUT BY NAME g_tof.tof01,g_tof.tof02,g_tof.tof03,g_tof.tof04, g_tof.toforiu,g_tof.toforig,
                 g_tof.tof05,g_tof.tof06,g_tof.tof07,g_tof.tof08,
                 g_tof.tof09,g_tof.tof10,g_tof.tof17,g_tof.tof11,
                 g_tof.tof12,g_tof.tof13,g_tof.tof14,g_tof.tof15,
                 g_tof.tof16,g_tof.tof18,g_tof.tof19,g_tof.tof20,
                 g_tof.tof21,g_tof.tof22,
                 #FUN-840068     ---start---
                 g_tof.tofud01,g_tof.tofud02,g_tof.tofud03,g_tof.tofud04,
                 g_tof.tofud05,g_tof.tofud06,g_tof.tofud07,g_tof.tofud08,
                 g_tof.tofud09,g_tof.tofud10,g_tof.tofud11,g_tof.tofud12,
                 g_tof.tofud13,g_tof.tofud14,g_tof.tofud15 
                 #FUN-840068     ----end----
       WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i209_set_entry(p_cmd)
         CALL i209_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
      AFTER FIELD tof01
         IF NOT cl_null(g_tof.tof01) THEN
            SELECT tog02 INTO l_tog02 FROM tog_file
             WHERE tog01=g_tof.tof01
             DISPLAY l_tog02 TO FORMONLY.tog02
            IF g_tof.tof01 !=g_tof01_t OR g_tof01_t IS NULL THEN
               SELECT count(*) INTO l_n FROM tof_file
                WHERE tof01 = g_tof.tof01
                IF l_n > 0 THEN
                  CALL cl_err(g_tof.tof01,-239,0)
                  LET g_tof.tof01 = g_tof01_t
                  DISPLAY BY NAME g_tof.tof01
                  NEXT FIELD tof01
                END IF
            END IF
         END IF
      AFTER FIELD tof03
         IF NOT cl_null(g_tof.tof03) THEN
            IF cl_null(g_tof_o.tof03) OR
               (g_tof.tof03 != g_tof_o.tof03 ) THEN
               CALL i209_tof03('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof03,g_errno,0)
                  LET g_tof.tof03 = g_tof_o.tof03
                  DISPLAY BY NAME g_tof.tof03
                  NEXT FIELD tof03
               END IF
            END IF
         ELSE
            LET l_toa02=''
            DISPLAY l_toa02 TO FORMONLY.toa02
         END IF
      AFTER FIELD tof04
         IF NOT cl_null(g_tof.tof04) THEN
            IF cl_null(g_tof_o.tof04) OR
               (g_tof.tof04 != g_tof_o.tof04 ) THEN
                CALL i209_tof04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof04,g_errno,0)
                  LET g_tof.tof04 = g_tof_o.tof04
                  DISPLAY BY NAME g_tof.tof04
                  NEXT FIELD tof04
               END IF
            END IF
         ELSE
            LET l_toa02a=''
            DISPLAY l_toa02a TO FORMONLY.toa02a
         END IF
      AFTER FIELD tof05
         IF NOT cl_null(g_tof.tof05) THEN
            IF cl_null(g_tof_o.tof05) OR
               (g_tof.tof05 != g_tof_o.tof05 ) THEN
                CALL i209_tof05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof05,g_errno,0)
                  LET g_tof.tof05 = g_tof_o.tof05
                  DISPLAY BY NAME g_tof.tof05
                  NEXT FIELD tof05
               END IF
            END IF
         ELSE
            LET l_geo02=''
            DISPLAY l_geo02 TO FORMONLY.geo02
         END IF
      AFTER FIELD tof06
         IF NOT cl_null(g_tof.tof06) THEN
            IF cl_null(g_tof_o.tof06) OR
               (g_tof.tof06 != g_tof_o.tof06 ) THEN
                CALL i209_tof06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof06,g_errno,0)
                  LET g_tof.tof06 = g_tof_o.tof06
                  DISPLAY BY NAME g_tof.tof06
                  NEXT FIELD tof06
               END IF
         ELSE
            LET l_too02=''
            DISPLAY l_too02 TO FORMONLY.too02
            END IF
         END IF
      AFTER FIELD tof07
         IF NOT cl_null(g_tof.tof07) THEN
            IF cl_null(g_tof_o.tof07) OR
               (g_tof.tof07 != g_tof_o.tof07 ) THEN
                CALL i209_tof07('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof07,g_errno,0)
                  LET g_tof.tof07 = g_tof_o.tof07
                  DISPLAY BY NAME g_tof.tof07
                  NEXT FIELD tof07
               END IF
         ELSE
            LET l_top02=''
            DISPLAY l_top02 TO FORMONLY.top02
            END IF
         END IF
      AFTER FIELD tof08
         IF NOT cl_null(g_tof.tof08) THEN
            IF cl_null(g_tof_o.tof08) OR
               (g_tof.tof08 != g_tof_o.tof08 ) THEN
                CALL i209_tof08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof08,g_errno,0)
                  LET g_tof.tof08 = g_tof_o.tof08
                  DISPLAY BY NAME g_tof.tof08
                  NEXT FIELD tof08
               END IF
            END IF
         ELSE
            LET l_toq02=''
            DISPLAY l_toq02 TO FORMONLY.toq02
         END IF
      AFTER FIELD tof09
         IF NOT cl_null(g_tof.tof09) THEN
            IF cl_null(g_tof_o.tof09) OR
               (g_tof.tof09 != g_tof_o.tof09 ) THEN
#              IF g_tof.tof09<0 THEN   #No.TQC-710043 mark
               IF g_tof.tof09<=0 THEN  #No.TQC-710043
                  CALL cl_err(g_tof.tof09,'atm-201',0)
                  LET g_tof.tof09 = g_tof_o.tof09
                  DISPLAY BY NAME g_tof.tof09
                  NEXT FIELD tof09
               END IF
            END IF
         END IF
      AFTER FIELD tof10
         IF NOT cl_null(g_tof.tof10) THEN
            IF cl_null(g_tof_o.tof10) OR
               (g_tof.tof10 != g_tof_o.tof10 ) THEN
                CALL i209_tof10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof10,g_errno,0)
                  LET g_tof.tof10 = g_tof_o.tof10
                  DISPLAY BY NAME g_tof.tof10
                  NEXT FIELD tof10
               END IF
            END IF
         ELSE
            LET l_pma02=''
            DISPLAY l_pma02 TO FORMONLY.pma02
         END IF
      AFTER FIELD tof11
         IF NOT cl_null(g_tof.tof11) THEN
            IF cl_null(g_tof_o.tof11) OR
               (g_tof.tof11 != g_tof_o.tof11 ) THEN
                CALL i209_tof11('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof11,g_errno,0)
                  LET g_tof.tof11 = g_tof_o.tof11
                  DISPLAY BY NAME g_tof.tof11
                  NEXT FIELD tof11
               END IF
            END IF
         ELSE
            LET l_azi02=''
            DISPLAY l_azi02 TO FORMONLY.azi02
         END IF
      AFTER FIELD tof12
         IF NOT cl_null(g_tof.tof12) THEN
            IF cl_null(g_tof_o.tof12) OR
               (g_tof.tof12 != g_tof_o.tof12 ) THEN
                CALL i209_tof12('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tof.tof12,g_errno,0)
                  LET g_tof.tof12 = g_tof_o.tof12
                  DISPLAY BY NAME g_tof.tof12
                  NEXT FIELD tof12
               END IF
            END IF
         ELSE
            LET l_gec02=''
            DISPLAY l_gec02 TO FORMONLY.gec02
         END IF
 
        #FUN-840068     ---start---
        AFTER FIELD tofud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tofud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode())
              RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
      ON ACTION controlp
         CASE
            WHEN INFIELD(tof03)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_toa"
               LET g_qryparam.default1 = g_tof.tof03
               LET g_qryparam.arg1 = '2'
               CALL cl_create_qry() RETURNING g_tof.tof03
               DISPLAY BY NAME g_tof.tof03
               CALL i209_tof03('a')
               NEXT FIELD tof03
            WHEN INFIELD(tof04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_toa"
               LET g_qryparam.default1 = g_tof.tof04
               LET g_qryparam.arg1     = '3'
               CALL cl_create_qry() RETURNING g_tof.tof04
               DISPLAY BY NAME g_tof.tof04
               CALL i209_tof04('a')
               NEXT FIELD tof04
            WHEN INFIELD(tof05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_geo"
               LET g_qryparam.default1 = g_tof.tof05
               CALL cl_create_qry() RETURNING g_tof.tof05
               DISPLAY BY NAME g_tof.tof05
               CALL i209_tof05('a')
               NEXT FIELD tof05
            WHEN INFIELD(tof06)
               CALL cl_init_qry_var()
               LET g_qryparam.arg1 = g_tof.tof05
               LET g_qryparam.form ="q_too1"
               LET g_qryparam.default1 = g_tof.tof06
               CALL cl_create_qry() RETURNING g_tof.tof06
               DISPLAY BY NAME g_tof.tof06
               NEXT FIELD tof06
            WHEN INFIELD(tof07)
               CALL cl_init_qry_var()
               LET g_qryparam.arg1 = g_tof.tof06
               LET g_qryparam.form ="q_top1"
               LET g_qryparam.default1 = g_tof.tof07
               CALL cl_create_qry() RETURNING g_tof.tof07
               DISPLAY BY NAME g_tof.tof07
               NEXT FIELD tof07
            WHEN INFIELD(tof08)
               CALL cl_init_qry_var()
               LET g_qryparam.arg1 = g_tof.tof07
               LET g_qryparam.form ="q_toq"
               LET g_qryparam.default1 = g_tof.tof08
               CALL cl_create_qry() RETURNING g_tof.tof08
               DISPLAY BY NAME g_tof.tof08
               NEXT FIELD tof08
            WHEN INFIELD(tof10)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pma"
               LET g_qryparam.default1 = g_tof.tof10
               CALL cl_create_qry() RETURNING g_tof.tof10
               DISPLAY BY NAME g_tof.tof10
               NEXT FIELD tof10
            WHEN INFIELD(tof11)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_tof.tof11
               CALL cl_create_qry() RETURNING g_tof.tof11
               DISPLAY BY NAME g_tof.tof11
               NEXT FIELD tof11
            WHEN INFIELD(tof12)
               CALL cl_init_qry_var()
               LET g_qryparam.arg1 ='1'
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.default1 = g_tof.tof12
               CALL cl_create_qry() RETURNING g_tof.tof12
               DISPLAY BY NAME g_tof.tof12
               NEXT FIELD tof12
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
FUNCTION i209_tof03(p_cmd)
   DEFINE l_toa02   LIKE toa_file.toa02,
          l_toaacti LIKE toa_file.toaacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT toa02,toaacti
     INTO l_toa02,l_toaacti
     FROM toa_file WHERE toa01 = g_tof.tof03 AND toa03='2'
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-202'
                                  LET l_toa02 = NULL
        WHEN l_toaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_toa02 TO FORMONLY.toa02
   END IF
END FUNCTION
FUNCTION i209_tof04(p_cmd)
   DEFINE l_toa02   LIKE toa_file.toa02,
          l_toaacti LIKE toa_file.toaacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT toa02,toaacti
     INTO l_toa02,l_toaacti
     FROM toa_file WHERE toa01 = g_tof.tof04 AND toa03='3'
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-203'
                                  LET l_toa02 = NULL
        WHEN l_toaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_toa02 TO FORMONLY.toa02a
   END IF
END FUNCTION
FUNCTION i209_tof05(p_cmd)
   DEFINE l_geo02   LIKE geo_file.geo02,
          l_geoacti LIKE geo_file.geoacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT geo02,geoacti
     INTO l_geo02,l_geoacti
     FROM geo_file WHERE geo01 = g_tof.tof05
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-301'
                                  LET l_geo02 = NULL
        WHEN l_geoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_geo02 TO FORMONLY.geo02
   END IF
END FUNCTION
FUNCTION i209_tof06(p_cmd)
   DEFINE l_too02   LIKE too_file.too02,
          l_tooacti LIKE too_file.tooacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT too02,tooacti
     INTO l_too02,l_tooacti
     FROM too_file WHERE too01 = g_tof.tof06 AND too03=g_tof.tof05
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-205'
                                  LET l_too02 = NULL
        WHEN l_tooacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_too02 TO FORMONLY.too02
   END IF
END FUNCTION
FUNCTION i209_tof07(p_cmd)
   DEFINE l_top02   LIKE top_file.top02,
          l_topacti LIKE top_file.topacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT top02,topacti
     INTO l_top02,l_topacti
     FROM top_file WHERE top01 = g_tof.tof07 AND top03=g_tof.tof06
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-304'
                                  LET l_top02 = NULL
        WHEN l_topacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_top02 TO FORMONLY.top02
   END IF
END FUNCTION
FUNCTION i209_tof08(p_cmd)
   DEFINE l_toq02   LIKE toq_file.toq02,
          l_toqacti LIKE toq_file.toqacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT toq02,toqacti
     INTO l_toq02,l_toqacti
     FROM toq_file WHERE toq01 = g_tof.tof08 AND toq03=g_tof.tof07
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'atm-302'
                                  LET l_toq02 = NULL
        WHEN l_toqacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_toq02 TO FORMONLY.toq02
   END IF
END FUNCTION
FUNCTION i209_tof10(p_cmd)
   DEFINE l_pma02   LIKE pma_file.pma02,
          l_pmaacti LIKE pma_file.pmaacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT pma02,pmaacti
     INTO l_pma02,l_pmaacti
     FROM pma_file WHERE pma01 = g_tof.tof10
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
                                  LET l_pma02 = NULL
        WHEN l_pmaacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pma02 TO FORMONLY.pma02
   END IF
END FUNCTION
FUNCTION i209_tof11(p_cmd)  #幣別
   DEFINE l_azi02   LIKE azi_file.azi02,
          l_aziacti LIKE azi_file.aziacti,
          p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = ' '
   SELECT azi02,aziacti
     INTO l_azi02,l_aziacti
     FROM azi_file WHERE azi01 = g_tof.tof11
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_azi02 = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
END FUNCTION
FUNCTION i209_tof12(p_cmd)  #稅別
    DEFINE  l_gec02   LIKE gec_file.gec02,
            l_gecacti LIKE gec_file.gecacti,
            p_cmd     LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
	
    LET g_errno = " "
    SELECT gec02,gecacti INTO l_gec02,l_gecacti
      FROM gec_file
     WHERE gec01 = g_tof.tof12 AND gec011='1'  #進項
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                   LET l_gec02 =NULL
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gec02 TO FORMONLY.gec02
    END IF
END FUNCTION
FUNCTION i209_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_tof.* TO NULL              #No.FUN-6B0043
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_tog.clear()
   DISPLAY ' ' TO FORMONLY.cnt
   CALL i209_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_tof.* TO NULL
      RETURN
   END IF
   OPEN i209_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_tof.* TO NULL
   ELSE
      OPEN i209_count
      FETCH i209_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i209_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
FUNCTION i209_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680120 VARCHAR(1)
   CASE p_flag
      WHEN 'N' FETCH NEXT     i209_cs INTO g_tof.tof01
      WHEN 'P' FETCH PREVIOUS i209_cs INTO g_tof.tof01
      WHEN 'F' FETCH FIRST    i209_cs INTO g_tof.tof01
      WHEN 'L' FETCH LAST     i209_cs INTO g_tof.tof01
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
            FETCH ABSOLUTE g_jump i209_cs INTO g_tof.tof01
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)
      INITIALIZE g_tof.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_tof.* FROM tof_file WHERE tof01 = g_tof.tof01
   IF SQLCA.sqlcode THEN
  #   CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)   #No.FUN-660104
      CALL cl_err3("sel","tof_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
      INITIALIZE g_tof.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_tof.tofuser
   LET g_data_group = g_tof.tofgrup
   CALL i209_show()
END FUNCTION
#將資料顯示在畫面上
FUNCTION i209_show()
   LET g_tof_t.* = g_tof.*                #保存單頭舊值
   LET g_tof_o.* = g_tof.*                #保存單頭舊值
   DISPLAY BY NAME g_tof.tof01,g_tof.tof02,g_tof.tof03,g_tof.tof04, g_tof.toforiu,g_tof.toforig,
                   g_tof.tof05,g_tof.tof06,g_tof.tof07,g_tof.tof08,
                   g_tof.tof09,g_tof.tof10,g_tof.tof11,g_tof.tof12,
                   g_tof.tof13,g_tof.tof14,g_tof.tof15,g_tof.tof16,
                   g_tof.tof17,g_tof.tof18,g_tof.tof19,g_tof.tof20,
                   g_tof.tof21,g_tof.tof22,
                   g_tof.tofuser,g_tof.tofgrup,g_tof.tofmodu,
                   g_tof.tofdate,g_tof.tofacti,
                   #FUN-840068     ---start---
                   g_tof.tofud01,g_tof.tofud02,g_tof.tofud03,g_tof.tofud04,
                   g_tof.tofud05,g_tof.tofud06,g_tof.tofud07,g_tof.tofud08,
                   g_tof.tofud09,g_tof.tofud10,g_tof.tofud11,g_tof.tofud12,
                   g_tof.tofud13,g_tof.tofud14,g_tof.tofud15 
                   #FUN-840068     ----end----
   CALL i209_tof03('d')
   CALL i209_tof04('d')
   CALL i209_tof05('d')
   CALL i209_tof06('d')
   CALL i209_tof07('d')
   CALL i209_tof08('d')
   CALL i209_tof10('d')
   CALL i209_tof11('d')
   CALL i209_tof12('d')
   CALL i209_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()
END FUNCTION
FUNCTION i209_x()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_tof.tof01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   BEGIN WORK
   OPEN i209_cl USING g_tof.tof01
   IF STATUS THEN
      CALL cl_err("OPEN i209_cl:", STATUS, 1)
      CLOSE i209_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i209_cl INTO g_tof.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   LET g_success = 'Y'
   CALL i209_show()
   IF cl_exp(0,0,g_tof.tofacti) THEN                   #確認一下
      LET g_chr=g_tof.tofacti
      IF g_tof.tofacti='Y' THEN
         LET g_tof.tofacti='N'
      ELSE
         LET g_tof.tofacti='Y'
      END IF
      UPDATE tof_file SET tofacti=g_tof.tofacti,
                          tofmodu=g_user,
                          tofdate=g_today
       WHERE tof01=g_tof.tof01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","tof_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_tof.tofacti=g_chr
      END IF
   END IF
   CLOSE i209_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_tof.tof01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   SELECT tofacti,tofmodu,tofdate
     INTO g_tof.tofacti,g_tof.tofmodu,g_tof.tofdate FROM tof_file
    WHERE tof01=g_tof.tof01
   DISPLAY BY NAME g_tof.tofacti,g_tof.tofmodu,g_tof.tofdate
END FUNCTION
FUNCTION i209_r()
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_tof.tof01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   SELECT * INTO g_tof.* FROM tof_file
    WHERE tof01=g_tof.tof01
   IF g_tof.tofacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_tof.tof01,'mfg1000',0)
      RETURN
   END IF
   BEGIN WORK
   OPEN i209_cl USING g_tof.tof01
   IF STATUS THEN
      CALL cl_err("OPEN i209_cl:", STATUS, 1)
      CLOSE i209_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i209_cl INTO g_tof.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL i209_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "tof01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_tof.tof01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM tof_file WHERE tof01 = g_tof.tof01
      DELETE FROM tog_file WHERE tog01 = g_tof.tof01
      CLEAR FORM
      CALL g_tog.clear()
      OPEN i209_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i209_cs
         CLOSE i209_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i209_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i209_cs
         CLOSE i209_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i209_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i209_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i209_fetch('/')
      END IF
   END IF
   CLOSE i209_cl
   COMMIT WORK
   CALL cl_flow_notify(g_tof.tof01,'D')
END FUNCTION
#單身
FUNCTION i209_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680120 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用        #No.FUN-680120 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680120 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680120 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680120 SMALLINT #TQC-840066
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680120 SMALLINT
    l_t1            LIKE type_file.num5,                #No.FUN-680120 SMALLINT
    l_t2            LIKE type_file.num5,                #No.FUN-680120 SMALLINT
    l_t3            LIKE type_file.num5                 #No.FUN-680120 SMALLINT
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
    IF g_tof.tof01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_tof.* FROM tof_file
     WHERE tof01=g_tof.tof01
    IF g_tof.tofacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_tof.tof01,'mfg1000',0)
       RETURN
    END IF
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT tog02,tog03,tog04,tog05,'',",
                       "       tog06,tog07, ",
                       #No.FUN-840068 --start--
                       "       togud01,togud02,togud03,togud04,togud05,",
                       "       togud06,togud07,togud08,togud09,togud10,",
                       "       togud11,togud12,togud13,togud14,togud15", 
                       #No.FUN-840068 ---end---
                       "  FROM tog_file",
                       " WHERE tog01=? AND tog02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i209_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_tog WITHOUT DEFAULTS FROM s_tog.*
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
           OPEN i209_cl USING g_tof.tof01
           IF STATUS THEN
              CALL cl_err("OPEN i209_cl:", STATUS, 1)
              CLOSE i209_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH i209_cl INTO g_tof.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i209_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_tog_t.* = g_tog[l_ac].*  #BACKUP
              LET g_tog_o.* = g_tog[l_ac].*  #BACKUP
              OPEN i209_bcl USING g_tof.tof01,g_tog_t.tog02
              IF STATUS THEN
                 CALL cl_err("OPEN i209_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i209_bcl INTO g_tog[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_tog_t.tog02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT toa02 INTO g_tog[l_ac].toa02b
                   FROM toa_file
                  WHERE toa01=g_tog[l_ac].tog05 AND toa03='6'
              END IF
              CALL cl_show_fld_cont()
           END IF
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_tog[l_ac].* TO NULL
           LET g_tog[l_ac].tog06 =  0            #Body default
           LET g_tog_t.* = g_tog[l_ac].*         #新輸入資料
           LET g_tog_o.* = g_tog[l_ac].*         #新輸入資料
           IF l_ac > 1 THEN
              LET g_tog[l_ac].tog03 = g_tog[l_ac-1].tog03
           END IF
           CALL cl_show_fld_cont()
           NEXT FIELD tog02
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO tog_file(tog01,tog02,tog03,tog04,tog05,tog06,
                                tog07,
                                #FUN-840068 --start--
                                togud01,togud02,togud03,togud04,togud05,togud06,
                                togud07,togud08,togud09,togud10,togud11,togud12,
                                togud13,togud14,togud15)
                                #FUN-840068 --end--
           VALUES(g_tof.tof01,g_tog[l_ac].tog02,
                  g_tog[l_ac].tog03,g_tog[l_ac].tog04,
                  g_tog[l_ac].tog05,g_tog[l_ac].tog06,
                  g_tog[l_ac].tog07,
                  #FUN-840068 --start--
                  g_tog[l_ac].togud01,g_tog[l_ac].togud02,
                  g_tog[l_ac].togud03,g_tog[l_ac].togud04,
                  g_tog[l_ac].togud05,g_tog[l_ac].togud06,
                  g_tog[l_ac].togud07,g_tog[l_ac].togud08,
                  g_tog[l_ac].togud09,g_tog[l_ac].togud10,
                  g_tog[l_ac].togud11,g_tog[l_ac].togud12,
                  g_tog[l_ac].togud13,g_tog[l_ac].togud14,
                  g_tog[l_ac].togud15)
                  #FUN-840068 --end--
           IF SQLCA.sqlcode THEN
           #  CALL cl_err(g_tog[l_ac].tog02,SQLCA.sqlcode,0)   #No.FUN-660104
              CALL cl_err3("ins","tog_file",g_tog[l_ac].tog02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
        BEFORE FIELD tog02                        #default 序號
           IF g_tog[l_ac].tog02 IS NULL OR g_tog[l_ac].tog02 = 0 THEN
              SELECT max(tog02)+1
                INTO g_tog[l_ac].tog02
                FROM tog_file
               WHERE tog01 = g_tof.tof01
              IF g_tog[l_ac].tog02 IS NULL THEN
                 LET g_tog[l_ac].tog02 = 1
              END IF
           END IF
        AFTER FIELD tog02                        #check 序號是否重複
           IF NOT cl_null(g_tog[l_ac].tog02) THEN
              IF g_tog[l_ac].tog02 != g_tog_t.tog02
                 OR g_tog_t.tog02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM tog_file
                  WHERE tog01 = g_tof.tof01
                    AND tog02 = g_tog[l_ac].tog02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tog[l_ac].tog02 = g_tog_t.tog02
                    NEXT FIELD tog02
                 END IF
              END IF
           END IF
        AFTER FIELD tog03
          IF NOT cl_null(g_tog[l_ac].tog03) THEN
             CALL i209_chk_time(g_tog[l_ac].tog03,'1')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD tog03
             END IF
          END IF
        AFTER FIELD tog04
            IF NOT cl_null(g_tog[l_ac].tog04) THEN
               CALL i209_chk_time(g_tog[l_ac].tog04,'2')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD tog04
               END IF
            END IF
        AFTER FIELD tog05                  #單位
           IF NOT cl_null(g_tog[l_ac].tog05) THEN
              IF g_tog_t.tog05 IS NULL OR
                 (g_tog[l_ac].tog05 != g_tog_o.tog05) THEN
                 CALL i209_tog05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_tog[l_ac].tog05,g_errno,0)
                    LET g_tog[l_ac].tog05 = g_tog_o.tog05
                    DISPLAY BY NAME g_tog[l_ac].tog05
                    NEXT FIELD tog05
                 END IF
              END IF
           END IF
           LET g_tog_o.tog05 = g_tog[l_ac].tog05
 
        #No.FUN-840068 --start--
        AFTER FIELD togud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD togud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_tog_t.tog02 > 0 AND g_tog_t.tog02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM tog_file
               WHERE tog01 = g_tof.tof01
                 AND tog02 = g_tog_t.tog02
              IF SQLCA.sqlcode THEN
              #  CALL cl_err(g_tog_t.tog02,SQLCA.sqlcode,0)   #No.FUN-660104
                 CALL cl_err3("del","tog_file",g_tog_t.tog02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
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
              LET g_tog[l_ac].* = g_tog_t.*
              CLOSE i209_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_tog[l_ac].tog02,-263,1)
              LET g_tog[l_ac].* = g_tog_t.*
           ELSE
              UPDATE tog_file SET tog02 =g_tog[l_ac].tog02,
                                  tog03 =g_tog[l_ac].tog03,
                                  tog04 =g_tog[l_ac].tog04,
                                  tog05 =g_tog[l_ac].tog05,
                                  tog06 =g_tog[l_ac].tog06,
                                  tog07 =g_tog[l_ac].tog07,
                                  #FUN-840068 --start--
                                  togud01 = g_tog[l_ac].togud01,
                                  togud02 = g_tog[l_ac].togud02,
                                  togud03 = g_tog[l_ac].togud03,
                                  togud04 = g_tog[l_ac].togud04,
                                  togud05 = g_tog[l_ac].togud05,
                                  togud06 = g_tog[l_ac].togud06,
                                  togud07 = g_tog[l_ac].togud07,
                                  togud08 = g_tog[l_ac].togud08,
                                  togud09 = g_tog[l_ac].togud09,
                                  togud10 = g_tog[l_ac].togud10,
                                  togud11 = g_tog[l_ac].togud11,
                                  togud12 = g_tog[l_ac].togud12,
                                  togud13 = g_tog[l_ac].togud13,
                                  togud14 = g_tog[l_ac].togud14,
                                  togud15 = g_tog[l_ac].togud15
                                  #FUN-840068 --end-- 
               WHERE tog01=g_tof.tof01
                 AND tog02=g_tog_t.tog02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #  CALL cl_err(g_tog[l_ac].tog02,SQLCA.sqlcode,0)   #No.FUN-660104
                 CALL cl_err3("upd","tog_file",g_tog[l_ac].tog02,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
                 LET g_tog[l_ac].* = g_tog_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30033 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_tog[l_ac].* = g_tog_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_tog.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
              CLOSE i209_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac  #FUN-D30033 add
           CLOSE i209_bcl
           COMMIT WORK     
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END         
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(tog02) AND l_ac > 1 THEN
              LET g_tog[l_ac].* = g_tog[l_ac-1].*
              LET g_tog[l_ac].tog02 = g_rec_b + 1
              NEXT FIELD tog02
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON ACTION controlp
           CASE
              WHEN INFIELD(tog05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.arg1 ='6'
                 LET g_qryparam.form ="q_toa"
                 LET g_qryparam.default1 = g_tog[l_ac].tog05
                 CALL cl_create_qry() RETURNING g_tog[l_ac].tog05
                  DISPLAY BY NAME g_tog[l_ac].tog05
                 NEXT FIELD tog05
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
    END INPUT
    CLOSE i209_bcl
    COMMIT WORK
#   CALL i209_delall()  #CHI-C30002 mark
    CALL i209_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i209_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM tof_file WHERE tof01 = g_tof.tof01
         INITIALIZE g_tof.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i209_delall()
#   SELECT COUNT(*) INTO g_cnt FROM tog_file
#    WHERE tog01 = g_tof.tof01
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM tof_file WHERE tof01 = g_tof.tof01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
FUNCTION i209_tog05(p_cmd)  #單位
   DEFINE l_toaacti  LIKE toa_file.toaacti,
          l_toa02    LIKE toa_file.toa02,
          p_cmd      LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   LET g_errno = " "
   SELECT toa02,toaacti INTO l_toa02,l_toaacti FROM toa_file
    WHERE toa01 = g_tog[l_ac].tog05 AND toa03='6'
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                                    LET l_toa02 = NULL
          WHEN l_toaacti='N' LET g_errno = '9028'
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
   IF cl_null(g_errno) OR p_cmd='d' THEN
      LET g_tog[l_ac].toa02b=l_toa02
   END IF
END FUNCTION
FUNCTION i209_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    CONSTRUCT l_wc2 ON tog02,tog03,tog04,tog05,tog06,tog07,
                       #No.FUN-840068 --start--
                       togud01,togud02,togud03,togud04,togud05,
                       togud06,togud07,togud08,togud09,togud10,
                       togud11,togud12,togud13,togud14,togud15
                       #No.FUN-840068 ---end---
         FROM s_tog[1].tog02,s_tog[1].tog03,s_tog[1].tog04,
              s_tog[1].tog05,
              s_tog[1].tog06,s_tog[1].tog07,
              #No.FUN-840068 --start--
              s_tog[1].togud01,s_tog[1].togud02,s_tog[1].togud03,
              s_tog[1].togud04,s_tog[1].togud05,s_tog[1].togud06,
              s_tog[1].togud07,s_tog[1].togud08,s_tog[1].togud09,
              s_tog[1].togud10,s_tog[1].togud11,s_tog[1].togud12,
              s_tog[1].togud13,s_tog[1].togud14,s_tog[1].togud15
              #No.FUN-840068 ---end---
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
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
    CALL i209_b_fill(l_wc2)
END FUNCTION
FUNCTION i209_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(200)
    LET g_sql = "SELECT tog02,tog03,tog04,tog05,' ',tog06,tog07,",
                #No.FUN-840068 --start--
                "       togud01,togud02,togud03,togud04,togud05,",
                "       togud06,togud07,togud08,togud09,togud10,",
                "       togud11,togud12,togud13,togud14,togud15", 
                #No.FUN-840068 ---end---
                "  FROM tog_file",
                " WHERE tog01 ='",g_tof.tof01,"' "   #單頭
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    LET g_sql=g_sql CLIPPED," ORDER BY tog02 "
    DISPLAY g_sql
    PREPARE i209_pb FROM g_sql
    DECLARE tog_cs                       #CURSOR
        CURSOR FOR i209_pb
    CALL g_tog.clear()
    LET g_cnt = 1
    FOREACH tog_cs INTO g_tog[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      SELECT toa02 INTO g_tog[g_cnt].toa02b
        FROM toa_file
       WHERE toa01=g_tog[g_cnt].tog05 AND toa03='6'
      DISPLAY BY NAME g_tog[g_cnt].toa02b
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_tog.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
FUNCTION i209_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tog TO s_tog.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()  
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END     
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
         CALL i209_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION previous
         CALL i209_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION jump
         CALL i209_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION next
         CALL i209_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
      ON ACTION last
         CALL i209_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
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
      ON ACTION about
         CALL cl_about()
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6B0043  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i209_copy()
DEFINE
    l_newno         LIKE tof_file.tof01,
    l_oldno         LIKE tof_file.tof01,
    l_n             LIKE type_file.num5          #No.FUN-680120 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    IF g_tof.tof01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i209_set_entry('a')   
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno FROM tof01
        AFTER FIELD tof01
           IF l_newno IS NULL THEN
               NEXT FIELD tof01
           END IF
           SELECT COUNT(*) INTO l_n
           FROM tof_file
           WHERE tof01 = l_newno
           IF l_n>0 THEN
              CALL cl_err(l_newno,-239,0)
              NEXT FIELD tof01
           END IF
        BEGIN WORK
           SELECT COUNT(*) INTO l_n
           FROM tof_file
           WHERE tof01 = l_newno
           IF l_n>0 THEN
              CALL cl_err('',-239,1)
              NEXT FIELD tof01
           END IF
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION about
         CALL cl_about()
      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_tof.tof01
       RETURN
    END IF
    DROP TABLE y
    SELECT * FROM tof_file         #單頭複製
     WHERE tof01=g_tof.tof01
      INTO TEMP y
    UPDATE y
       SET tof01=l_newno,    #新的鍵值
           tofuser=g_user,   #資料所有者
           tofgrup=g_grup,   #資料所有者所屬群
           tofmodu=NULL,     #資料修改日期
           tofdate=g_today,  #資料建立日期
           tofacti='Y'       #有效資料
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)   #No.FUN-660104
         CALL cl_err3("upd","temp_y",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
         LET g_tof.tofacti=g_chr
      END IF
    INSERT INTO tof_file
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
    #   CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)   #No.FUN-660104
        CALL cl_err3("ins","tof_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
        ROLLBACK WORK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    DROP TABLE x
    SELECT * FROM tog_file         #單身複製
     WHERE tog01=g_tof.tof01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
    #  CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)   #No.FUN-660104
       CALL cl_err3("ins","x",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104
       RETURN
    END IF
    UPDATE x
       SET tog01=l_newno
    INSERT INTO tog_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","tog_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104      #FUN-B80061   ADD
        ROLLBACK WORK #No:7857
   #    CALL cl_err(g_tof.tof01,SQLCA.sqlcode,0)   #No.FUN-660104
   #     CALL cl_err3("ins","tog_file",g_tof.tof01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660104     #FUN-B80061   MARK
        RETURN
    ELSE
        COMMIT WORK
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
     LET l_oldno = g_tof.tof01
     SELECT tof_file.* INTO g_tof.*
       FROM tof_file
      WHERE tof01 = l_newno
     CALL i209_u()
     CALL i209_b()
     #FUN-C80046---begin
     #SELECT * INTO g_tof.*
     #  FROM tof_file
     # WHERE tof01 = l_oldno
     #CALL i209_show()
     #FUN-C80046---end
END FUNCTION
FUNCTION i209_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680120 SMALLINT
    sr              RECORD
        tof01       LIKE tof_file.tof01,
        tof02       LIKE tof_file.tof02,
        tof03       LIKE tof_file.tof03,
        toa02       LIKE toa_file.toa02,
        tof04       LIKE tof_file.tof04,
        toa02a      LIKE toa_file.toa02,
        tof05       LIKE tof_file.tof05,
        tof06       LIKE tof_file.tof06,
        too02       LIKE too_file.too02,
        tof07       LIKE tof_file.tof07,
        top02       LIKE top_file.top02,
        tof08       LIKE tof_file.tof08,
        toq02       LIKE toq_file.toq02,
        tof09       LIKE tof_file.tof09,
        tof10       LIKE tof_file.tof10,
        pma02       LIKE pma_file.pma02,
        tof11       LIKE tof_file.tof11,
        azi02       LIKE azi_file.azi02,
        tof12       LIKE tof_file.tof12,
        gec02       LIKE gec_file.gec02,
        tof13       LIKE tof_file.tof13,
        tof14       LIKE tof_file.tof14,
        tof15       LIKE tof_file.tof15,
        tof16       LIKE tof_file.tof16,
        tof17       LIKE tof_file.tof17,
        tof18       LIKE tof_file.tof18,
        tof19       LIKE tof_file.tof19,
        tof20       LIKE tof_file.tof20,
        tof21       LIKE tof_file.tof21,
        tof22       LIKE tof_file.tof22,
        tofacti     LIKE tof_file.tofacti,
        tog02       LIKE tog_file.tog02,
        tog03       LIKE tog_file.tog03,
        tog04       LIKE tog_file.tog04,
        tog05       LIKE tog_file.tog05,
        toa02b      LIKE toa_file.toa02,
        tog06       LIKE tog_file.tog06,
        tog07       LIKE tog_file.tog07
       END RECORD,
    l_name          LIKE type_file.chr20,            #No.FUN-680120 VARCHAR(20)             #External(Disk) file name
    l_za05          LIKE type_file.chr1000             #No.FUN-680120 VARCHAR(40)              #
 DEFINE  l_geo02    LIKE geo_file.geo02                #No.FUN-760083 
    IF cl_null(g_tof.tof01) THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    IF cl_null(g_wc) THEN
        LET g_wc ="  tof01='",g_tof.tof01,"'"
        LET g_wc2=" 1=1 "
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT UNIQUE tof01,tof02,tof03,'',tof04,'',tof05,",
                      "tof06,'',tof07,'',tof08,'',tof09,tof10,",
                      "'',tof11,'',tof12,'',tof13,tof14,tof15,",
                      "tof16,tof17,tof18,tof19,tof20,tof21,tof22,tofacti,",
                      " tog02,tog03,tog04,tog05,'',tog06,tog07",
              "  FROM tof_file,tog_file",
              " WHERE tog01=tof01 AND ",g_wc CLIPPED
    PREPARE i209_p1 FROM g_sql                # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('i209_p1',STATUS,0) END IF
    DECLARE i209_co                         # CURSOR
        CURSOR FOR i209_p1
    #CALL cl_outnam('atmi209') RETURNING l_name       #No.FUN-760083
    #START REPORT i209_rep TO l_name                  #No.FUN-760083 
    LET g_str=''                                      #No.FUN-760083
    CALL cl_del_data(l_table)                         #No.FUN-760083
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog   #No.FUN-760083
    FOREACH i209_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT toa02 INTO sr.toa02 FROM toa_file
         WHERE toa01 = sr.tof03
        SELECT toa02 INTO sr.toa02a FROM toa_file
         WHERE toa01 = sr.tof04
        SELECT too02 INTO sr.too02 FROM too_file
         WHERE too01=sr.tof06
        SELECT top02 INTO sr.top02 FROM top_file
         WHERE top01=sr.tof07 AND top03=sr.tof06
        SELECT toq02 INTO sr.toq02 FROM toq_file
         WHERE toq01=sr.tof08 AND toq03=sr.tof07
        SELECT pma02 INTO sr.pma02 FROM pma_file
         WHERE pma01=sr.tof10
        SELECT azi02 INTO sr.azi02 FROM azi_file
         WHERE azi01=sr.tof11
        SELECT gec02 INTO sr.gec02 FROM gec_file
         WHERE gec01=sr.tof12
        SELECT toa02 INTO sr.toa02b FROM toa_file
         WHERE toa01=sr.tog05 AND toa03='6'
        #OUTPUT TO REPORT i209_rep(sr.*)           #No.FUN-760083
        SELECT geo02 INTO l_geo02 FROM geo_file    #No.FUN-760083                                                                                     
          WHERE geo01 = sr.tof05                   #No.FUN-760083 
        EXECUTE insert_prep USING sr.tof01,sr.tof02,sr.tof03,sr.toa02,sr.tof04,  #No.FUN-760083
                                  sr.toa02a,sr.tof05,sr.tof06,sr.too02,sr.tof07, #No.FUN-760083
                                  sr.top02,sr.tof08,sr.toq02,sr.tof09,sr.tof10,  #No.FUN-760083
                                  sr.pma02,sr.tof11,sr.azi02,sr.tof12,sr.gec02,  #No.FUN-760083
                                  sr.tof13,sr.tof14,sr.tof15,sr.tof16,sr.tof17,  #No.FUN-760083
                                  sr.tof18,sr.tof19,sr.tof20,sr.tof21,sr.tof22,  #No.FUN-760083
                                  sr.tofacti,sr.tog02,sr.tog03,sr.tog04,sr.tog05, #No.FUN-760083
                                  sr.toa02b,sr.tog06,sr.tog07,l_geo02            #No.FUN-760083
    END FOREACH
    #FINISH REPORT i209_rep
    CLOSE i209_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)      #No.FUN-760083
#No.FUN-760083  --begin--
    IF g_zz05='Y' THEN
      CALL  cl_wcchp(g_wc,'tof01,tof02,tof03,tof04,tof05,tof06,tof07,tof08,                                       
                           tof09,tof10,tof17,tof11,tof12,tof13,tof14,tof15,                                               
                           tof16,tof18,tof19,tof20,tof21,tof22,tofuser,                                                   
                           tofgrup,tofmodu,tofdate,tofacti')
      RETURNING  g_wc
    END IF
    LET g_str=g_wc,';',g_azi04
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3("atmi209","atmi209",g_sql,g_str)   
#No.FUN-760083 --end--
 
END FUNCTION
 
#No.FUN-760083 --begin--
{
REPORT i209_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(1)
    l_i             LIKE type_file.num5,             #No.FUN-680120 SMALLINT
    sr              RECORD
        tof01       LIKE tof_file.tof01,
        tof02       LIKE tof_file.tof02,
        tof03       LIKE tof_file.tof03,
        toa02       LIKE toa_file.toa02,
        tof04       LIKE tof_file.tof04,
        toa02a      LIKE toa_file.toa02,
        tof05       LIKE tof_file.tof05,
        tof06       LIKE tof_file.tof06,
        too02       LIKE too_file.too02,
        tof07       LIKE tof_file.tof07,
        top02       LIKE top_file.top02,
        tof08       LIKE tof_file.tof08,
        toq02       LIKE toq_file.toq02,
        tof09       LIKE tof_file.tof09,
        tof10       LIKE tof_file.tof10,
        pma02       LIKE pma_file.pma02,
        tof11       LIKE tof_file.tof11,
        azi02       LIKE azi_file.azi02,
        tof12       LIKE tof_file.tof12,
        gec02       LIKE gec_file.gec02,
        tof13       LIKE tof_file.tof13,
        tof14       LIKE tof_file.tof14,
        tof15       LIKE tof_file.tof15,
        tof16       LIKE tof_file.tof16,
        tof17       LIKE tof_file.tof17,
        tof18       LIKE tof_file.tof18,
        tof19       LIKE tof_file.tof19,
        tof20       LIKE tof_file.tof20,
        tof21       LIKE tof_file.tof21,
        tof22       LIKE tof_file.tof22,
        tofacti     LIKE tof_file.tofacti,
        tog02       LIKE tog_file.tog02,
        tog03       LIKE tog_file.tog03,
        tog04       LIKE tog_file.tog04,
        tog05       LIKE tog_file.tog05,
        toa02b      LIKE toa_file.toa02,
        tog06       LIKE tog_file.tog06,
        tog07       LIKE tog_file.tog07
                    END RECORD,
        l_geo02     LIKE geo_file.geo02,
        l_t1        LIKE zaa_file.zaa08       #No.FUN-680120 VARCHAR(10)
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
    ORDER BY sr.tof01,sr.tog02
    FORMAT
      PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT COLUMN 01,g_x[10],sr.tof01 CLIPPED,
            COLUMN 40,g_x[11],sr.tof02 CLIPPED
      PRINT COLUMN 01,g_x[12],sr.tof03 CLIPPED,
            COLUMN 20,sr.toa02 CLIPPED,
            COLUMN 40,g_x[13],sr.tof04 CLIPPED,
            COLUMN 60,sr.toa02a
      SELECT geo02 INTO l_geo02 FROM geo_file
       WHERE geo01 = sr.tof05
      PRINT COLUMN 01,g_x[14],sr.tof05 CLIPPED,
            COLUMN 20,l_geo02 CLIPPED,
            COLUMN 40,g_x[15],sr.tof06 CLIPPED,
            COLUMN 60,sr.too02
      PRINT COLUMN 01,g_x[16],sr.tof07 CLIPPED,
            COLUMN 20,sr.top02 CLIPPED,
            COLUMN 40,g_x[17],sr.tof08 CLIPPED,
            COLUMN 60,sr.toq02
      PRINT COLUMN 01,g_x[18],sr.tof09 CLIPPED,
            COLUMN 40,g_x[19],sr.tof10 CLIPPED,
            COLUMN 60,sr.pma02
      PRINT COLUMN 01,g_x[20],sr.tof11 CLIPPED,
            COLUMN 20,sr.azi02 CLIPPED,
            COLUMN 40,g_x[21],sr.tof12 CLIPPED,
            COLUMN 60,sr.gec02
      PRINT COLUMN 01,g_x[22],sr.tof13 CLIPPED,
            COLUMN 40,g_x[23],sr.tof14
      PRINT COLUMN 01,g_x[24],sr.tof15 CLIPPED,
            COLUMN 40,g_x[25],sr.tof16
      PRINT COLUMN 01,g_x[26],sr.tof17
      PRINT COLUMN 01,g_x[27],sr.tof18 CLIPPED,
            COLUMN 40,g_x[28],sr.tof19
      IF sr.tof21='1' THEN
         LET l_t1=g_x[42]
      ELSE IF sr.tof21='2' THEN
              LET l_t1=g_x[43]
           END IF
      END IF
      PRINT COLUMN 01,g_x[29],sr.tof20 CLIPPED,
            COLUMN 40,g_x[30],sr.tof21 CLIPPED,' ',l_t1
      PRINT COLUMN 01,g_x[31],sr.tof22
      PRINT g_dash[1,g_len]
      PRINT g_x[35],g_x[36],g_x[37],g_x[38],g_x[39],
            g_x[40],g_x[41]
      PRINT g_dash1
      LET l_trailer_sw = 'y'
        BEFORE GROUP OF sr.tof01  #單據編號
         IF (PAGENO > 1 OR LINENO > 9)
            THEN SKIP TO TOP OF PAGE
         END IF
        ON EVERY ROW
         PRINT
               COLUMN g_c[35],sr.tog02 USING '###&', #FUN-590118
               COLUMN g_c[36],sr.tog03 CLIPPED,
               COLUMN g_c[37],sr.tog04 CLIPPED,
               COLUMN g_c[38],sr.tog05 CLIPPED,
               COLUMN g_c[39],sr.toa02b CLIPPED,
               COLUMN g_c[40],cl_numfor(sr.tog06,40,g_azi04),
               COLUMN g_c[41],sr.tog07
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN
#NO.TQC-630166 start-- 
#                   IF g_wc[001,080] > ' ' THEN
#
#                   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                    IF g_wc[141,210] > ' ' THEN
#                   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                    CALL cl_prt_pos_wc(g_wc)
#NO.TQC-630166 end--
                    PRINT g_dash[1,g_len]
            END IF
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        AFTER  GROUP OF sr.tof01  #單據編號
            PRINT ' '
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760083  --end--
 
FUNCTION i209_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("tof01",TRUE)
    END IF
END FUNCTION
FUNCTION i209_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680120 VARCHAR(1)
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tof01",FALSE)
    END IF
END FUNCTION
FUNCTION  i209_chk_time(p_time,p_code)
   DEFINE p_time     LIKE tog_file.tog03,     #No.FUN-680120 VARCHAR(05)   
          p_code     LIKE type_file.chr1,     #No.FUN-680120 VARCHAR(01)
          l_time     LIKE type_file.num20_6,  #LIKE cqg_file.cqg06,     #No.FUN-680120 DEC(8,4)     #TQC-B90211
          l_time1    LIKE type_file.num20_6,  #LIKE cqg_file.cqg06,     #No.FUN-680120 DEC(8,4)     #TQC-B90211
          l_time2    LIKE type_file.num20_6   #LIKE cqg_file.cqg06      #No.FUN-680120 DEC(8,4)     #TQC-B90211
   LET g_errno=''
#   IF length(p_time)!=5 THEN LET g_errno='apy-080' END IF                           #CHI-B40058
#   IF p_time[1,1] < '0'  OR p_time[1,1] > '2'  THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[2,2] < '0'  OR p_time[2,2] > '9'  THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[1,2] < '00' OR p_time[1,2] > '23' THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[4,5] < '00' OR p_time[4,5] > '59' THEN LET g_errno='apy-080' END IF    #CHI-B40058
#   IF p_time[3,3]!=':'  THEN LET g_errno='apy-080' END IF                           #CHI-B40058
   IF length(p_time)!=5 THEN LET g_errno='asr-057' END IF                            #CHI-B40058
   IF p_time[1,1] < '0'  OR p_time[1,1] > '2'  THEN LET g_errno='asr-057' END IF     #CHI-B40058
   IF p_time[2,2] < '0'  OR p_time[2,2] > '9'  THEN LET g_errno='asr-057' END IF     #CHI-B40058
   IF p_time[1,2] < '00' OR p_time[1,2] > '23' THEN LET g_errno='asr-057' END IF     #CHI-B40058
   IF p_time[4,5] < '00' OR p_time[4,5] > '59' THEN LET g_errno='asr-057' END IF     #CHI-B40058
   IF p_time[3,3]!=':'  THEN LET g_errno='asr-057' END IF                            #CHI-B40058


END FUNCTION
