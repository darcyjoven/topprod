# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft710.4gl
# Descriptions...: 稼動效率資料維護作業
# Date & Author..: 98/05/20 BY Carol
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530436 05/03/28 By pengu  1、新增輸入時，員工編號應預設輸入人員
                                             #      2、單身已確認之資料，應亦不可用 B單身再進入修改，不可刪除
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.MOD-5B0306 05/12/06 By Claire 單身無資料時第一筆沒有走BEFORE INSERT
# Modify.........: No.MOD-5B0055 05/12/20 By Pengu 1若單身無資料時，進入單身程式會當掉
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6C0220 07/01/02 By rainy QBE下單身條件時，筆數顯示錯誤
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770003 07/07/02 By zhoufeng 維護幫助按鈕
# Modify.........: No.MOD-7A0017 07/10/04 By Carol [確認]後還原 insert,delete action 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/21 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80040 11/09/08 By jason 新增複製功能
# Modify.........: No.TQC-B90180 11/09/27 By houlia 單身字段全部NOENTRY時,自動帶到下一行可edit的行
# Modify.........: No.TQC-BC0157 12/02/01 By destiny 光标跳到已审核过的资料时程序会荡出
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sfb   RECORD LIKE sfb_file.*,
    g_shf   RECORD LIKE shf_file.*,
    g_shf_t RECORD LIKE shf_file.*,
    g_shf_o RECORD LIKE shf_file.*,
    g_shf01_t LIKE shf_file.shf01,
    g_shf02_t LIKE shf_file.shf02,
    g_shf03_t LIKE shf_file.shf03,
    b_shg       RECORD LIKE shg_file.*,
    g_ima       RECORD LIKE ima_file.*,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_gen02             LIKE gen_file.gen02,
    m_shg               RECORD LIKE shg_file.*,
    g_shg               DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        shg03           LIKE shg_file.shg03,
        shg04           LIKE shg_file.shg04,
        sgb05           LIKE sgb_file.sgb05,
        shg05           LIKE shg_file.shg05,
        shg06           LIKE shg_file.shg06,
        shg07           LIKE shg_file.shg07,
        shg08           LIKE shg_file.shg08,
        ima02           LIKE ima_file.ima02,
        ima021          LIKE ima_file.ima021,
        shg09           LIKE shg_file.shg09,
        shg10           LIKE shg_file.shg10,
        shg11           LIKE shg_file.shg11,
        #FUN-840068 --start---
        shgud01         LIKE shg_file.shgud01,
        shgud02         LIKE shg_file.shgud02,
        shgud03         LIKE shg_file.shgud03,
        shgud04         LIKE shg_file.shgud04,
        shgud05         LIKE shg_file.shgud05,
        shgud06         LIKE shg_file.shgud06,
        shgud07         LIKE shg_file.shgud07,
        shgud08         LIKE shg_file.shgud08,
        shgud09         LIKE shg_file.shgud09,
        shgud10         LIKE shg_file.shgud10,
        shgud11         LIKE shg_file.shgud11,
        shgud12         LIKE shg_file.shgud12,
        shgud13         LIKE shg_file.shgud13,
        shgud14         LIKE shg_file.shgud14,
        shgud15         LIKE shg_file.shgud15
        #FUN-840068 --end--
                    END RECORD,
    g_shg_t         RECORD                 #程式變數 (舊值)
        shg03           LIKE shg_file.shg03,
        shg04           LIKE shg_file.shg04,
        sgb05           LIKE sgb_file.sgb05,
        shg05           LIKE shg_file.shg05,
        shg06           LIKE shg_file.shg06,
        shg07           LIKE shg_file.shg07,
        shg08           LIKE shg_file.shg08,
        ima02           LIKE ima_file.ima02,
        ima021          LIKE ima_file.ima021,
        shg09           LIKE shg_file.shg09,
        shg10           LIKE shg_file.shg10,
        shg11           LIKE shg_file.shg11,
        #FUN-840068 --start---
        shgud01         LIKE shg_file.shgud01,
        shgud02         LIKE shg_file.shgud02,
        shgud03         LIKE shg_file.shgud03,
        shgud04         LIKE shg_file.shgud04,
        shgud05         LIKE shg_file.shgud05,
        shgud06         LIKE shg_file.shgud06,
        shgud07         LIKE shg_file.shgud07,
        shgud08         LIKE shg_file.shgud08,
        shgud09         LIKE shg_file.shgud09,
        shgud10         LIKE shg_file.shgud10,
        shgud11         LIKE shg_file.shgud11,
        shgud12         LIKE shg_file.shgud12,
        shgud13         LIKE shg_file.shgud13,
        shgud14         LIKE shg_file.shgud14,
        shgud15         LIKE shg_file.shgud15
        #FUN-840068 --end--
                    END RECORD,
    g_buf           LIKE type_file.chr1000,             ##No.FUN-680121 VARCHAR(78)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    g_argv1         LIKE shf_file.shf01,
    g_argv2         LIKE shf_file.shf02,
    p_row,p_col     LIKE type_file.num5,                #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
 
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_msg                LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE g_curs_index        LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE g_jump              LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_edit               LIKE type_file.chr1          #TQC-B90180
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0090
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   INITIALIZE g_shf.* TO NULL
   INITIALIZE g_shf_t.* TO NULL
   INITIALIZE g_shf_o.* TO NULL
 
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW t710_w AT p_row,p_col
        WITH FORM "asf/42f/asft710"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL t710_q()
    END IF
 
    LET g_argv1=''
    LET g_argv2=''
 
    CALL t710()
 
    CLOSE WINDOW t710_w
 
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
END MAIN
 
FUNCTION t710()
 
    LET g_forupd_sql = "SELECT * FROM shf_file WHERE shf01 = ? AND shf02 = ? AND shf03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t710_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL t710_menu()
 
END FUNCTION
 
FUNCTION t710_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_shg.clear()
 
    IF cl_null(g_argv1) AND cl_null(g_argv2) THEN
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031 
   INITIALIZE g_shf.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON shf01,shf03,shf02,
                                #FUN-840068   ---start---
                                shfud01,shfud02,shfud03,shfud04,shfud05,
                                shfud06,shfud07,shfud08,shfud09,shfud10,
                                shfud11,shfud12,shfud13,shfud14,shfud15
                                #FUN-840068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
                 WHEN INFIELD(shf03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     ="q_ecg"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shf03
                      NEXT FIELD shf03
                 WHEN INFIELD(shf02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_gen"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shf02
                      NEXT FIELD shf02
                 OTHERWISE EXIT CASE
            END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON shg03,shg04,shg05,shg06,shg07,shg09,shg10,shg11
                          #No.FUN-840068 --start--
                          ,shgud01,shgud02,shgud03,shgud04,shgud05
                          ,shgud06,shgud07,shgud08,shgud09,shgud10
                          ,shgud11,shgud12,shgud13,shgud14,shgud15
                          #No.FUN-840068 ---end---
            FROM s_shg[1].shg03,s_shg[1].shg04,s_shg[1].shg05,s_shg[1].shg06,
                 s_shg[1].shg07,s_shg[1].shg09,s_shg[1].shg10,s_shg[1].shg11
                 #No.FUN-840068 --start--
                 ,s_shg[1].shgud01,s_shg[1].shgud02,s_shg[1].shgud03
                 ,s_shg[1].shgud04,s_shg[1].shgud05,s_shg[1].shgud06
                 ,s_shg[1].shgud07,s_shg[1].shgud08,s_shg[1].shgud09
                 ,s_shg[1].shgud10,s_shg[1].shgud11,s_shg[1].shgud12
                 ,s_shg[1].shgud13,s_shg[1].shgud14,s_shg[1].shgud15
                 #No.FUN-840068 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE WHEN INFIELD(shg04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_sgb"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shg04
                      NEXT FIELD shg04
#q_sfb01(沒傳l_sta)及q_sfb02(有傳l_sta)
                 WHEN INFIELD(shg06)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form = "q_sfb01"
                      LET g_qryparam.construct = "Y"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shg06
                      NEXT FIELD shg06
                 WHEN INFIELD(shg10)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_gem"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO shg10
                      NEXT FIELD shg10
            END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
          ON ACTION help
             CALL cl_show_help()           #No.TQC-770003
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
      LET g_wc= g_wc clipped," shf01= '",g_argv1,"' AND shf02='",g_argv2,"'"
      LET g_wc2=' 1=1'
    END IF
 
    IF g_wc='' OR g_wc=' '    THEN  LET g_wc= ' 1=1'  END IF
    IF g_wc2='' OR g_wc2=' '  THEN  LET g_wc2= ' 1=1'  END IF
    IF g_wc2=' 1=1' THEN
#MOD-7A0017-modify
       LET g_sql="SELECT shf01,shf03,shf02 FROM shf_file ",
#MOD-7A0017-modify-end
                 " WHERE ",g_wc CLIPPED, " ORDER BY shf01,shf03,shf02"
    ELSE
       LET g_sql="SELECT shf01,shf03,shf02 ",
                 "  FROM shf_file,shg_file ",
                 " WHERE shf01=shg01 AND shf02=shg02 AND shf03=shg021 ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY shf01,shf03,shf02"
    END IF
    PREPARE t710_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE t710_cs SCROLL CURSOR WITH HOLD FOR t710_prepare
  #TQC-6C0220--begin
    #LET g_sql= "SELECT COUNT(*) FROM shf_file WHERE ",g_wc CLIPPED
    IF g_wc2=' 1=1' THEN
       LET g_sql= "SELECT COUNT(*) FROM shf_file WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql= "SELECT COUNT(UNIQUE shf01||shf02||shf03) FROM shf_file,shg_file ",
                  " WHERE shf01=shg01 AND shf02=shg02 ",
                  "   AND shf03=shg021 ",
                  "   AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED
       
    END IF
  #TQC-6C0220--end
    PREPARE t710_precount FROM g_sql
    DECLARE t710_count CURSOR FOR t710_precount
END FUNCTION
 
FUNCTION t710_menu()
 
   WHILE TRUE
      CALL t710_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t710_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t710_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t710_r()
            END IF
#        WHEN "modify"
#           IF cl_chk_act_auth() THEN
#              CALL t710_u()
#           END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET l_ac = 1          #No.MOD-5B0055 add
               CALL t710_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
#        WHEN "output"
#           IF cl_chk_act_auth() THEN
#              CALL cl_cmdrun('asfr711')
#           END IF
         WHEN "exit"
          EXIT WHILE
         WHEN "controlg"
          CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t710_b('1')
#MOD-7A0017-add
               CALL cl_set_act_visible("insert,delete", TRUE)
#MOD-7A0017-add-end
            END IF
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shg),'','')
            END IF
##
         #No.FUN-6A0164-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_shf.shf01 IS NOT NULL THEN
                LET g_doc.column1 = "shf01"
                LET g_doc.column2 = "shf03"
                LET g_doc.column3 = "shf02"
                LET g_doc.value1 = g_shf.shf01
                LET g_doc.value2 = g_shf.shf03
                LET g_doc.value3 = g_shf.shf02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0164-------add--------end----

         #FUN-B80040 --START--
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t710_copy()
            END IF
         #FUN-B80040 --END--   
      END CASE
   END WHILE
   CLOSE t710_cs
END FUNCTION
 
FUNCTION t710_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_shg.clear()
    INITIALIZE g_shf.* LIKE shf_file.*
    LET g_shf01_t = TODAY
    LET g_shf02_t = NULL
    LET g_shf03_t = NULL
    LET g_shf.shf01=TODAY
    LET g_shf.shf02=g_user   #No.MOD-530436
    LET g_shf.shfplant = g_plant #FUN-980008 add
    LET g_shf.shflegal = g_legal #FUN-980008 add
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL t710_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
   CALL g_shg.clear()
            EXIT WHILE
        END IF
        INSERT INTO shf_file VALUES(g_shf.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_shf.shf01,SQLCA.sqlcode,0)   #No.FUN-660128
           CALL cl_err3("ins","shf_file",g_shf.shf01,g_shf.shf02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
           CONTINUE WHILE
        ELSE
           LET g_shf_t.* = g_shf.*               # 保存上筆資料
           SELECT shf01,shf02,shf03 INTO g_shf.shf01,g_shf.shf02,g_shf.shf03 FROM shf_file
                  WHERE shf01 = g_shf.shf01 AND shf02 = g_shf.shf02
                    AND shf03 = g_shf.shf03
        END IF
 
        CALL g_shg.clear()
        LET g_rec_b = 0
        LET l_ac = 1          #No.MOD-5B0055 add
        CALL t710_b('0')
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t710_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入        #No.FUN-680121 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680121 SMALLINT
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME
        g_shf.shf01,g_shf.shf03,g_shf.shf02, 
        #FUN-840068     ---start---
        g_shf.shfud01,g_shf.shfud02,g_shf.shfud03,g_shf.shfud04,
        g_shf.shfud05,g_shf.shfud06,g_shf.shfud07,g_shf.shfud08,
        g_shf.shfud09,g_shf.shfud10,g_shf.shfud11,g_shf.shfud12,
        g_shf.shfud13,g_shf.shfud14,g_shf.shfud15 
        #FUN-840068     ----end----
        WITHOUT DEFAULTS
 
        AFTER FIELD shf01
            IF g_shf.shf01 IS NULL THEN
               LET g_shf.shf01=TODAY
               NEXT FIELD shf01
            END IF
 
        AFTER FIELD shf03
            IF NOT cl_null(g_shf.shf03) THEN
               SELECT count(*) INTO g_cnt FROM ecg_file
                WHERE ecg01=g_shf.shf03
               IF g_cnt=0 THEN
                  CALL cl_err('sel ecg',100,0)
                  LET g_shf.shf03=' '
                  NEXT FIELD shf03
               END IF
            END IF
 
        AFTER FIELD shf02
            IF NOT cl_null(g_shf.shf02) THEN
               SELECT COUNT(*) INTO g_cnt FROM gen_file
               WHERE gen01 = g_shf.shf02
               IF cl_null(g_cnt) OR g_cnt = 0 THEN
                  CALL cl_err('','aap-038',0)
                  NEXT FIELD shf02
               END IF
               SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_shf.shf02
               DISPLAY g_gen02 TO FORMONLY.gen02
               SELECT count(*) INTO g_cnt FROM shf_file
                WHERE shf01 = g_shf.shf01 AND shf02 = g_shf.shf02
                  AND shf03 = g_shf.shf03
               IF g_cnt > 0 THEN    # 資料重複
                  ERROR 'Data Duplicate'
                  LET g_shf.shf02 = ' '
                  LET g_gen02=' '
                  DISPLAY BY NAME g_shf.shf02
                  DISPLAY g_gen02 TO FORMONLY.gen02
                  NEXT FIELD shf02
               END IF
            END IF
 
        #FUN-840068     ---start---
        AFTER FIELD shfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
            CASE
                 WHEN INFIELD(shf03)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     ="q_ecg"
                      LET g_qryparam.default1 = g_shf.shf03
                      CALL cl_create_qry() RETURNING g_shf.shf03
#                      CALL FGL_DIALOG_SETBUFFER( g_shf.shf03 )
                      DISPLAY BY NAME g_shf.shf03
                 WHEN INFIELD(shf02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_gen"
                      LET g_qryparam.default1 = g_shf.shf02
                      CALL cl_create_qry() RETURNING g_shf.shf02
#                      CALL FGL_DIALOG_SETBUFFER( g_shf.shf02 )
                      DISPLAY BY NAME g_shf.shf02
                 OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
FUNCTION t710_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_shf.* TO NULL              #No.FUN-6A0164
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t710_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_shg.clear()
        CALL g_shg.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
 
    OPEN t710_count
    FETCH t710_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN t710_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shf.shf01,SQLCA.sqlcode,0)
        INITIALIZE g_shf.* TO NULL
    ELSE
        CALL t710_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t710_fetch(p_flshf)
    DEFINE
        p_flshf         LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680121 INTEGER
 
    CASE p_flshf
        WHEN 'N' FETCH NEXT     t710_cs INTO g_shf.shf01,
                                             g_shf.shf03,g_shf.shf02
        WHEN 'P' FETCH PREVIOUS t710_cs INTO g_shf.shf01,
                                             g_shf.shf03,g_shf.shf02
        WHEN 'F' FETCH FIRST    t710_cs INTO g_shf.shf01,
                                             g_shf.shf03,g_shf.shf02
        WHEN 'L' FETCH LAST     t710_cs INTO g_shf.shf01,
                                             g_shf.shf03,g_shf.shf02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t710_cs INTO g_shf.shf01,
                                                g_shf.shf03,g_shf.shf02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_shf.shf01,SQLCA.sqlcode,0)
        INITIALIZE g_shf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flshf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_shf.* FROM shf_file       # 重讀DB,因TEMP有不被更新特性
     WHERE shf01=g_shf.shf01 AND shf02 = g_shf.shf02 AND shf03 = g_shf.shf03
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_shf.shf01,SQLCA.sqlcode,0)   #No.FUN-660128
       CALL cl_err3("sel","shf_file",g_shf.shf01,g_shf.shf02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_shf.* TO NULL            #FUN-4C0035
    ELSE
       LET g_data_owner = ''                 #FUN-4C0035
       LET g_data_group = ''                 #FUN-4C0035
       CALL t710_show()                      # 重新顯示
    END IF
 
END FUNCTION
 
FUNCTION t710_show()
    LET g_shf_t.* = g_shf.*
    DISPLAY BY NAME g_shf.shf01, g_shf.shf02,g_shf.shf03,
                    #FUN-840068     ---start---
                    g_shf.shfud01,g_shf.shfud02,g_shf.shfud03,g_shf.shfud04,
                    g_shf.shfud05,g_shf.shfud06,g_shf.shfud07,g_shf.shfud08,
                    g_shf.shfud09,g_shf.shfud10,g_shf.shfud11,g_shf.shfud12,
                    g_shf.shfud13,g_shf.shfud14,g_shf.shfud15 
                    #FUN-840068     ----end----
    INITIALIZE g_gen02 TO NULL
    SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=g_shf.shf02
    DISPLAY g_gen02 TO FORMONLY.gen02
    CALL t710_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION t710_r()
    DEFINE l_chr   LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
           l_cnt   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_shf.shf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    BEGIN WORK
 
    OPEN t710_cl USING g_shf.shf01,g_shf.shf02,g_shf.shf03
    IF STATUS THEN
       CALL cl_err("OPEN t710_cl:", STATUS, 1)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t710_cl INTO g_shf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_shf.shf01,SQLCA.sqlcode,0)
       CLOSE t710_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t710_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "shf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "shf03"         #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "shf02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_shf.shf01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_shf.shf03      #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_shf.shf02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       DELETE FROM shf_file WHERE shf01=g_shf.shf01 AND shf02 = g_shf.shf02 AND shf03 = g_shf.shf03
       IF STATUS THEN
#         CALL cl_err('del shf:',STATUS,0)   #No.FUN-660128
          CALL cl_err3("del","shf_file",g_shf.shf01,g_shf.shf02,STATUS,"","del shf:",1)  #No.FUN-660128
          ROLLBACK WORK
          CLOSE t710_cl
          RETURN
       END IF
       DELETE FROM shg_file
        WHERE shg01=g_shf.shf01 AND shg02=g_shf.shf02 AND shg021=g_shf.shf03
       IF STATUS THEN
#         CALL cl_err('del shg:',STATUS,0)   #No.FUN-660128
          CALL cl_err3("del","shg_file",g_shf.shf01,g_shf.shf02,STATUS,"","del shg:",1)  #No.FUN-660128
          ROLLBACK WORK
          CLOSE t710_cl
          RETURN
       END IF
       INITIALIZE g_shf.* TO NULL
       CLEAR FORM
       CALL g_shg.clear()
       CALL g_shg.clear()
       OPEN t710_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t710_cs
          CLOSE t710_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t710_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t710_cs
          CLOSE t710_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t710_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t710_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t710_fetch('/')
       END IF
 
    END IF
 
    CLOSE t710_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t710_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,                #No.FUN-680121 VARCHAR(1)#修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_sfb38         LIKE type_file.dat,                 #No.FUN-680121 DATE
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_shf.shf01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT shg03,shg04,'',shg05,shg06,shg07,shg08,'','',shg09,shg10,shg11, ",
        #No.FUN-840068 --start--
        "       shgud01,shgud02,shgud03,shgud04,shgud05,",
        "       shgud06,shgud07,shgud08,shgud09,shgud10,",
        "       shgud11,shgud12,shgud13,shgud14,shgud15", 
        #No.FUN-840068 ---end---
        " FROM shg_file ",
        "  WHERE shg01= ? AND shg02 = ? AND shg021 = ? AND shg03 = ? ",
        " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t710_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    
    INPUT ARRAY g_shg WITHOUT DEFAULTS FROM s_shg.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
              #MOD-5B0306-begin
               CALL t710_set_entry_b(p_mod_seq)
               CALL t710_set_no_entry_b(p_mod_seq)
              #MOD-5B0306-end
            END IF
            #MOD-5B0306-begin-mark
            #CALL t710_set_entry_b(p_mod_seq)
            #CALL t710_set_no_entry_b(p_mod_seq)
            #MOD-5B0306-end-mark
            #TQC-B90180 --begin  houlia
            IF g_edit = 'N' THEN
               LET l_ac= l_ac + 1
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #TQC-B90180 --end  houlia
             #-------------No.MOD-530436----------------------
            IF p_mod_seq='1' THEN
              CALL cl_set_act_visible("insert,delete", FALSE)
            END IF
             #-----------------No.MOD-530436 END--------------
 
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            #TQC-BC0157--begin
            IF g_shg[l_ac].shg11='Y' THEN
               LET l_ac=l_ac_t
               CALL fgl_set_arr_curr(l_ac)
            END IF
            #TQC-BC0157--end 
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t710_cl USING g_shf.shf01,g_shf.shf02,g_shf.shf03
            IF STATUS THEN
               CALL cl_err("OPEN t710_cl:", STATUS, 1)
               CLOSE t710_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t710_cl INTO g_shf.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_shf.shf01,SQLCA.sqlcode,0)
                  CLOSE t710_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_shg_t.* = g_shg[l_ac].*  #BACKUP
                OPEN t710_bcl USING g_shf.shf01,g_shf.shf02,g_shf.shf03,
                                    g_shg_t.shg03
                IF STATUS THEN
                   CALL cl_err("OPEN t710_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t710_bcl INTO g_shg[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_shg_t.shg03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      SELECT sgb05 INTO g_shg[l_ac].sgb05 FROM sgb_file
                       WHERE sgb01= g_shg[l_ac].shg04
                      SELECT ima02,ima021 INTO g_shg[l_ac].ima02,g_shg[l_ac].ima021 FROM ima_file
                       WHERE ima01= g_shg[l_ac].shg08
                       CALL t710_set_entry_b(p_mod_seq)
                       CALL t710_set_no_entry_b(p_mod_seq)
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
          # IF p_mod_seq='0' THEN
          #    NEXT FIELD shg03
          # ELSE
          #    NEXT FIELD shg09
          # END IF
 
        BEFORE INSERT
             #-------------No.MOD-530436----------------------
            IF p_mod_seq='1' THEN
              CANCEL INSERT
            END IF
             #-------------No.MOD-530436 END----------------------
            CALL t710_set_entry_b(p_mod_seq)
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_shg[l_ac].* TO NULL      #900423
#           LET g_shg[l_ac].shg04 = ' '
            LET g_shg[l_ac].shg05 = 0
#           LET g_shg[l_ac].shg06 = ' '
            LET g_shg[l_ac].shg07 = ' '
            LET g_shg[l_ac].shg08 = ' '
            LET g_shg[l_ac].shg09 = 0
            LET g_shg[l_ac].shg10 = ' '
            LET g_shg[l_ac].shg11 = 'N'
            LET g_shg_t.* = g_shg[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shg03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_shg[l_ac].shg04) THEN
               INITIALIZE g_shg[l_ac].* TO NULL      #900423
               NEXT FIELD shg03
            END IF
            IF cl_null(g_shg[l_ac].shg09) THEN
               LET g_shg[l_ac].shg09 = 0
            END IF
            LET m_shg.shg01 =g_shf.shf01
            LET m_shg.shg02 =g_shf.shf02
            LET m_shg.shg021=g_shf.shf03
            LET m_shg.shg03 =g_shg[l_ac].shg03
            LET m_shg.shg04 =g_shg[l_ac].shg04
            LET m_shg.shg05 =g_shg[l_ac].shg05
            LET m_shg.shg06 =g_shg[l_ac].shg06
            LET m_shg.shg07 =g_shg[l_ac].shg07
            LET m_shg.shg08 =g_shg[l_ac].shg08
            LET m_shg.shg09 =g_shg[l_ac].shg09
            LET m_shg.shg10 =g_shg[l_ac].shg10
            LET m_shg.shg11 =g_shg[l_ac].shg11
            #FUN-840068 --start--
            LET m_shg.shgud01 =g_shg[l_ac].shgud01
            LET m_shg.shgud02 =g_shg[l_ac].shgud02
            LET m_shg.shgud03 =g_shg[l_ac].shgud03
            LET m_shg.shgud04 =g_shg[l_ac].shgud04
            LET m_shg.shgud05 =g_shg[l_ac].shgud05
            LET m_shg.shgud06 =g_shg[l_ac].shgud06
            LET m_shg.shgud07 =g_shg[l_ac].shgud07
            LET m_shg.shgud08 =g_shg[l_ac].shgud08
            LET m_shg.shgud09 =g_shg[l_ac].shgud09
            LET m_shg.shgud10 =g_shg[l_ac].shgud10
            LET m_shg.shgud11 =g_shg[l_ac].shgud11
            LET m_shg.shgud12 =g_shg[l_ac].shgud12
            LET m_shg.shgud13 =g_shg[l_ac].shgud13
            LET m_shg.shgud14 =g_shg[l_ac].shgud14
            LET m_shg.shgud15 =g_shg[l_ac].shgud15
            #FUN-840068 --end--
            LET m_shg.shgplant = g_plant #FUN-980008 add
            LET m_shg.shglegal = g_legal #FUN-980008 add
            INSERT INTO shg_file VALUES(m_shg.*)
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins ecm:',SQLCA.sqlcode,0)   #No.FUN-660128
               CALL cl_err3("ins","shg_file",m_shg.shg01,m_shg.shg02,SQLCA.sqlcode,"","ins ecm:",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE FIELD shg03                        #default 序號
            IF g_shg[l_ac].shg03 IS NULL OR
               g_shg[l_ac].shg03 = 0 THEN
                SELECT max(shg03)+1 INTO g_shg[l_ac].shg03 FROM shg_file
                   WHERE shg01 = g_shf.shf01 AND shg02 = g_shf.shf02
                IF g_shg[l_ac].shg03 IS NULL THEN
                    LET g_shg[l_ac].shg03 = 1
                END IF
            END IF
 
        AFTER FIELD shg03                        #check 序號是否重複
            IF NOT cl_null(g_shg[l_ac].shg03) THEN
               IF g_shg[l_ac].shg03 != g_shg_t.shg03 OR
                  g_shg_t.shg03 IS NULL THEN
                  SELECT count(*) INTO l_n FROM shg_file
                   WHERE shg01 = g_shf.shf01 AND shg02 = g_shf.shf02
                     AND shg03 = g_shg[l_ac].shg03
                     AND shg021= g_shf.shf03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_shg[l_ac].shg03 = g_shg_t.shg03
                     NEXT FIELD shg03
                  END IF
               END IF
            END IF
 
        AFTER FIELD shg04
            IF NOT cl_null(g_shg[l_ac].shg04) THEN
               SELECT sgb05 INTO g_shg[l_ac].sgb05 FROM sgb_file
                WHERE sgb01= g_shg[l_ac].shg04
               IF STATUS THEN
#                 CALL cl_err(g_shg[l_ac].shg04,'aoo-018',0)   #No.FUN-660128
                  CALL cl_err3("sel","sgb_file",g_shg[l_ac].shg04,"","aoo-018","","",1)  #No.FUN-660128
                  LET g_shg[l_ac].shg04 =' '
                  NEXT FIELD shg04
               END IF
               LET l_n=0
            END IF
 
        AFTER FIELD shg06
            IF NOT cl_null(g_shg[l_ac].shg06) THEN
               SELECT * INTO g_sfb.* FROM sfb_file
                WHERE sfb01=g_shg[l_ac].shg06
                  AND sfb87!='X'
               IF STATUS <> 0 THEN
#                 CALL cl_err('','asf-312',0)   #No.FUN-660128
                  CALL cl_err3("sel","sfb_file",g_shg[l_ac].shg06,"","asf-312","","",1)  #No.FUN-660128
                  LET g_shg[l_ac].shg06 =' '
                  NEXT FIELD shg06
               END IF
               LET g_shg[l_ac].shg07=g_sfb.sfb06
               LET g_shg[l_ac].shg08=g_sfb.sfb05
               SELECT ima02,ima021 INTO g_shg[l_ac].ima02,g_shg[l_ac].ima021 FROM ima_file
                WHERE ima01= g_shg[l_ac].shg08
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_shg[l_ac].shg07
               DISPLAY BY NAME g_shg[l_ac].shg08
               DISPLAY BY NAME g_shg[l_ac].ima02
               DISPLAY BY NAME g_shg[l_ac].ima021
               #------MOD-5A0095 END------------
            END IF
 
        AFTER FIELD shg10
            IF NOT cl_null(g_shg[l_ac].shg10) THEN
               SELECT * FROM gem_file WHERE gem01=g_shg[l_ac].shg10
                  AND gemacti='Y'   #NO:6950
               IF STATUS  THEN
#No.MOD-580322--begin
#                 CALL cl_err('','agl-004','1')   #No.FUN-660128
                  CALL cl_err3("sel","gem_file",g_shg[l_ac].shg10,"","agl-004","","",1)  #No.FUN-660128
#                 ERROR '無此部門代號! '
#No.MOD-580322--end
                  LET g_shg[l_ac].shg10 =' '
                  NEXT FIELD shg10
               END IF
            END IF
 
        BEFORE FIELD shg11
            IF cl_null(g_shg[l_ac].shg11) THEN
               LET g_shg[l_ac].shg11 ='N'
            END IF
 
        AFTER FIELD shg11
            IF NOT cl_null(g_shg[l_ac].shg11) THEN
               IF g_shg[l_ac].shg11 NOT MATCHES '[YN]' THEN
                  LET g_shg[l_ac].shg11 ='N'
                  NEXT FIELD shg11
               END IF
            END IF
 
        #No.FUN-840068 --start--
        AFTER FIELD shgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD shgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_shg_t.shg03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
             # ----------------No.MOD-530436------------------------
            # IF g_shg_t.shg11 = "Y" THEN
            #    CALL cl_err("", aap-019, 1)
            #    CANCEL DELETE
            # END IF
             # ----------------No.MOD-530436 END------------------------
                # genero shell add end
               DELETE FROM shg_file
                WHERE shg01 = g_shf.shf01 AND shg02 = g_shf.shf02
                  AND shg03 = g_shg_t.shg03 AND shg021=g_shf.shf03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_shg_t.shg03,SQLCA.sqlcode,0)   #No.FUN-660128
                  CALL cl_err3("del","shg_file",g_shf.shf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
 
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_shg[l_ac].* = g_shg_t.*
               CLOSE t710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shg[l_ac].shg03,-263,1)
               LET g_shg[l_ac].* = g_shg_t.*
            ELSE
               IF cl_null(g_shg[l_ac].shg09) THEN
                  LET g_shg[l_ac].shg09 = 0
               END IF
               UPDATE shg_file SET shg03=g_shg[l_ac].shg03,
                                   shg04=g_shg[l_ac].shg04,
                                   shg05=g_shg[l_ac].shg05,
                                   shg06=g_shg[l_ac].shg06,
                                   shg07=g_shg[l_ac].shg07,
                                   shg08=g_shg[l_ac].shg08,
                                   shg09=g_shg[l_ac].shg09,
                                   shg10=g_shg[l_ac].shg10,
                                   shg11=g_shg[l_ac].shg11,
                                   #FUN-840068 --start--
                                   shgud01 = g_shg[l_ac].shgud01,
                                   shgud02 = g_shg[l_ac].shgud02,
                                   shgud03 = g_shg[l_ac].shgud03,
                                   shgud04 = g_shg[l_ac].shgud04,
                                   shgud05 = g_shg[l_ac].shgud05,
                                   shgud06 = g_shg[l_ac].shgud06,
                                   shgud07 = g_shg[l_ac].shgud07,
                                   shgud08 = g_shg[l_ac].shgud08,
                                   shgud09 = g_shg[l_ac].shgud09,
                                   shgud10 = g_shg[l_ac].shgud10,
                                   shgud11 = g_shg[l_ac].shgud11,
                                   shgud12 = g_shg[l_ac].shgud12,
                                   shgud13 = g_shg[l_ac].shgud13,
                                   shgud14 = g_shg[l_ac].shgud14,
                                   shgud15 = g_shg[l_ac].shgud15
                                   #FUN-840068 --end-- 
                WHERE shg01=g_shf.shf01
                  AND shg02= g_shf.shf02
                  AND shg03=g_shg_t.shg03
                  AND shg021= g_shf.shf03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_shg[l_ac].shg03,SQLCA.sqlcode,0)   #No.FUN-660128
                   CALL cl_err3("upd","shg_file",g_shf.shf01,g_shf.shf02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   LET g_shg[l_ac].* = g_shg_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_shg[l_ac].* = g_shg_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t710_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t710_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL t710_b_askkey()
#           EXIT INPUT
 
        ON ACTION controlp
            CASE WHEN INFIELD(shg04)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_sgb"
                      LET g_qryparam.default1 = g_shg[l_ac].shg04
                      CALL cl_create_qry() RETURNING g_shg[l_ac].shg04
#                      CALL FGL_DIALOG_SETBUFFER( g_shg[l_ac].shg04 )
                       DISPLAY BY NAME g_shg[l_ac].shg04  #No.MOD-490371
                      NEXT FIELD shg04
#q_sfb01(沒傳l_sta)及q_sfb02(有傳l_sta)
                 WHEN INFIELD(shg06)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_sfb01"
                      LET g_qryparam.construct = "Y"
                      LET g_qryparam.default1 = g_shg[l_ac].shg06
                      CALL cl_create_qry() RETURNING g_shg[l_ac].shg06
#                      CALL FGL_DIALOG_SETBUFFER( g_shg[l_ac].shg06 )
                       DISPLAY BY NAME  g_shg[l_ac].shg06   #No.MOD-490371
                      NEXT FIELD shg06
                 WHEN INFIELD(shg10)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_gem"
                      LET g_qryparam.default1 = g_shg[l_ac].shg10
                      CALL cl_create_qry() RETURNING g_shg[l_ac].shg10
#                      CALL FGL_DIALOG_SETBUFFER( g_shg[l_ac].shg10 )
                       DISPLAY BY NAME g_shg[l_ac].shg10     #No.MOD-490371
                      NEXT FIELD shg10
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
    END INPUT
 
    CLOSE t710_bcl
    COMMIT WORK
    CALL t710_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t710_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM shf_file WHERE shf01 = g_shf.shf01
                                AND shf02 = g_shf.shf02
                                AND shf03 = g_shf.shf03
         INITIALIZE g_shf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t710_set_entry_b(p_mod_seq)
 #-------------------No.MOD-530436-------------------------------------------
 DEFINE  p_mod_seq    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)#修改次數 (0表開狀)
    IF p_mod_seq !='0' THEN
       CALL cl_set_comp_entry("shg09,shg10,shg11",TRUE)
    ELSE
        CALL cl_set_comp_entry("shg03,shg04,shg05,shg06",TRUE)  #MOD-490112
    END IF
 
END FUNCTION
 
FUNCTION t710_set_no_entry_b(p_mod_seq)
 DEFINE  p_mod_seq    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)#修改次數 (0表開狀)
  LET g_edit = 'Y'    #TQC-B90180  add
    IF p_mod_seq !='0' THEN
        CALL cl_set_comp_entry("shg03,shg04,shg05,shg06",FALSE) #MOD-490112
    ELSE
       IF g_shg[l_ac].shg11 = 'Y' THEN
          CALL cl_set_comp_entry("shg03,shg04,shg05,shg06",FALSE) #MOD-490112
          CALL cl_set_comp_entry("shg09,shg10,shg11",FALSE)
          LET g_edit = 'N'    #TQC-B90180  add
       ELSE
          CALL cl_set_comp_entry("shg09,shg10,shg11",FALSE)
       END IF
    END IF
 #------------------------------------No.MOD-530436 END-----------------
END FUNCTION
 
FUNCTION t710_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON shg03,shg04,shg05,shg06,shg07,shg08,shg09,shg10,shg11
              #No.FUN-840068 --start--
              ,shgud01,shgud02,shgud03,shgud04,shgud05
              ,shgud06,shgud07,shgud08,shgud09,shgud10
              ,shgud11,shgud12,shgud13,shgud14,shgud15
              #No.FUN-840068 ---end---
            FROM s_shg[1].shg03,s_shg[1].shg04,s_shg[1].shg05,s_shg[1].shg06,
                 s_shg[1].shg07,s_shg[1].shg08,s_shg[1].shg09,s_shg[1].shg10,
                 s_shg[1].shg11
                 #No.FUN-840068 --start--
                 ,s_shg[1].shgud01,s_shg[1].shgud02,s_shg[1].shgud03
                 ,s_shg[1].shgud04,s_shg[1].shgud05,s_shg[1].shgud06
                 ,s_shg[1].shgud07,s_shg[1].shgud08,s_shg[1].shgud09
                 ,s_shg[1].shgud10,s_shg[1].shgud11,s_shg[1].shgud12
                 ,s_shg[1].shgud13,s_shg[1].shgud14,s_shg[1].shgud15
                 #No.FUN-840068 ---end---
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
       ON ACTION help
          CALL cl_show_help()                    #No.TQC-770003
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t710_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t710_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    LET g_sql =
     "SELECT shg03,shg04,sgb05,shg05,shg06,shg07,shg08,ima02,ima021,shg09,shg10,shg11,",
     #No.FUN-840068 --start--
     "       shgud01,shgud02,shgud03,shgud04,shgud05,",
     "       shgud06,shgud07,shgud08,shgud09,shgud10,",
     "       shgud11,shgud12,shgud13,shgud14,shgud15", 
     #No.FUN-840068 ---end---
     " FROM shg_file,OUTER sgb_file,OUTER ima_file",
     " WHERE shg01 ='",g_shf.shf01,"' AND shg02 ='",g_shf.shf02,"'",
     "   AND shg021 ='",g_shf.shf03,"'",
     " AND shg_file.shg04=sgb_file.sgb01 ",
     " AND shg_file.shg08=ima_file.ima01 ",
     " AND ",p_wc2 CLIPPED,
     " ORDER BY 1"
    PREPARE t710_pb FROM g_sql
    DECLARE shg_curs CURSOR FOR t710_pb
 
    CALL g_shg.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH shg_curs INTO g_shg[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_shg.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t710_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shg TO s_shg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
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
#     ON ACTION modify
#        LET g_action_choice="modify"
      ON ACTION first
         CALL t710_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t710_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t710_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t710_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t710_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#     ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
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
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
 
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      ON ACTION help
         CALL cl_show_help()                    #No.TQC-770003 
 
      #FUN-B80040 --START--
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY   
      #FUN-B80040 --END--   
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-B80040 --START--
FUNCTION t710_copy()
   DEFINE l_newshf01     LIKE shf_file.shf01,
          l_newshf02     LIKE shf_file.shf02,
          l_newshf03     LIKE shf_file.shf03,          
          l_oldshf01     LIKE shf_file.shf01,
          l_oldshf02     LIKE shf_file.shf02,
          l_oldshf03     LIKE shf_file.shf03
   DEFINE li_result   LIKE type_file.num5  
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_shf.shf01) OR cl_null(g_shf.shf02) OR cl_null(g_shf.shf03) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   
   CALL cl_set_head_visible("","YES")
   
   INPUT l_newshf01,l_newshf03,l_newshf02 FROM shf01,shf03,shf02
   
        AFTER FIELD shf01
            IF l_newshf01 IS NULL THEN
               LET l_newshf01=TODAY
               NEXT FIELD shf01
            END IF

        AFTER FIELD shf03
            IF NOT cl_null(l_newshf03) THEN
               SELECT count(*) INTO g_cnt FROM ecg_file
                WHERE ecg01=l_newshf03
               IF g_cnt=0 THEN
                  CALL cl_err('sel ecg',100,0)
                  LET l_newshf03=' '
                  NEXT FIELD shf03
               END IF
            END IF              
            
        AFTER FIELD shf02
            IF NOT cl_null(l_newshf02) THEN
               SELECT COUNT(*) INTO g_cnt FROM gen_file
               WHERE gen01 = l_newshf02
               IF cl_null(g_cnt) OR g_cnt = 0 THEN
                  CALL cl_err('','aap-038',0)
                  NEXT FIELD shf02
               END IF
               SELECT gen02 INTO g_gen02 FROM gen_file WHERE gen01=l_newshf02
               DISPLAY g_gen02 TO FORMONLY.gen02
               SELECT count(*) INTO g_cnt FROM shf_file
                WHERE shf01 = l_newshf01 AND shf02 = l_newshf02
                  AND shf03 = l_newshf03
               IF g_cnt > 0 THEN    # 資料重複
                  ERROR 'Data Duplicate'
                  LET l_newshf02 = ' '
                  LET g_gen02=' '
                  DISPLAY l_newshf02 TO shf02
                  DISPLAY g_gen02 TO FORMONLY.gen02
                  NEXT FIELD shf02
               END IF
            END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(shf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_ecg"
                  LET g_qryparam.default1 = l_newshf03
                  CALL cl_create_qry() RETURNING l_newshf03
                  DISPLAY l_newshf03 TO shf03
             WHEN INFIELD(shf02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gen"
                  LET g_qryparam.default1 = l_newshf02
                  CALL cl_create_qry() RETURNING l_newshf02
                  DISPLAY l_newshf02 TO shf02
             OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
 
     ON ACTION controlg      
        CALL cl_cmdask()     

     AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
        IF INT_FLAG THEN EXIT INPUT END IF 

   END INPUT
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_shf.shf01
      DISPLAY BY NAME g_shf.shf02
      DISPLAY BY NAME g_shf.shf03       
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM shf_file         #單頭複製
       WHERE shf01=g_shf.shf01
         AND shf02=g_shf.shf02
         AND shf03=g_shf.shf03
       INTO TEMP y
       
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","y","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE y
       SET shf01=l_newshf01,    #新的鍵值
           shf02=l_newshf02,    #新的鍵值
           shf03=l_newshf03     #新的鍵值           
 
   INSERT INTO shf_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","shf_file","","",SQLCA.sqlcode,"","",1)  
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM shg_file         #單身複製
       WHERE shg01 =g_shf.shf01
         AND shg02 =g_shf.shf02
         AND shg021=g_shf.shf03
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
      RETURN
   END IF
 
   UPDATE x SET shg01 =l_newshf01,    #新的鍵值
                shg02 =l_newshf02,    #新的鍵值
                shg021=l_newshf03     #新的鍵值 
 
   INSERT INTO shg_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmx_file","","",SQLCA.sqlcode,"","",1)     
      ROLLBACK WORK 
      RETURN
   ELSE
       COMMIT WORK 
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newshf01,') O.K'
 
   LET l_oldshf01 = g_shf.shf01
   LET l_oldshf02 = g_shf.shf02
   LET l_oldshf03 = g_shf.shf03
   
   SELECT shf_file.* INTO g_shf.* FROM shf_file 
    WHERE shf01 = l_newshf01 AND shf02 = l_newshf02 AND shf03 = l_newshf03
    
   CALL t710_b('0')
   
   #SELECT shf_file.* INTO g_shf.* FROM shf_file   #FUN-C80046
   # WHERE shf01 = l_oldshf01 AND shf02 = l_oldshf02 AND shf03 = l_oldshf03  #FUN-C80046
   #CALL t710_show()  #FUN-C80046
END FUNCTION
#FUN-B80040 --END--
 
#Patch....NO.MOD-5A0095 <001> #
