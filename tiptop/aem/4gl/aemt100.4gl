# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aemt100.4gl
# Descriptions...: 設備檢查記錄維護作業
# Date & Author..: 04/07/15 By Carrier
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.FUN-4C0069 04/12/13 By Smapmin 加入權限控管
# Modify.........: No.FUN-540036 05/04/19 By wujie   多table顯示
# Modify.........: No.MOD-540141 05/04/20 By vivien  更新control-f的寫法
# Modify.........: No.FUN-550024 05/05/19 By Trisy 單據編號加大
# Modify.........: No.MOD-530629 05/06/08 By Carrier 更改單據查詢
# Modify.........: No.MOD-560238 05/07/27 By vivien 自動編號修改
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-660092 06/06/16 By Jackho cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-680072 06/08/24 By zdyllq 類型轉換
# Modify.........: No.FUN-690024 06/09/18 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0068 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0050 06/11/17 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7A0032 07/10/08 By Pengu 單身輸入保修項目後,保修內容未顯示
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840068 08/04/25 By TSD.Wind 自定欄位功能修改 
# Modify.........: No.TQC-970173 09/07/20 By sherry 資料無效時，不可以刪除   
# Modify.........: No.FUN-980002 09/08/20 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80026 11/08/03 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-B70279 11/08/18 By Vampire FUNCTION t100_fir03() 最後面加上DISPLAY BY NAME g_fir[l_ac].*
# Modify.........: No:TQC-BA0133 12/01/29 By SunLM 資料建立者,資料建立部門,增加查詢條件

# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-CC0114 12/12/24 By qirl點擊【審核】/【取消審核】時，彈出的提示訊息下的選擇按鈕為英文【YES】、【NO】、【cancel】
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D50141 13/05/16 By suncx 第二單身查詢sql錯誤，導致查詢不到結果
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fiq           RECORD LIKE fiq_file.*,
    g_fiq_t         RECORD LIKE fiq_file.*,
    g_fiq_o         RECORD LIKE fiq_file.*,
    g_fiq01_t       LIKE fiq_file.fiq01,
    g_fir           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fir02            LIKE fir_file.fir02,
        fir03            LIKE fir_file.fir03,
        fis02            LIKE fis_file.fis02,
        fir04            LIKE fir_file.fir04,
        #FUN-840068 --start---
        firud01          LIKE fir_file.firud01,
        firud02          LIKE fir_file.firud02,
        firud03          LIKE fir_file.firud03,
        firud04          LIKE fir_file.firud04,
        firud05          LIKE fir_file.firud05,
        firud06          LIKE fir_file.firud06,
        firud07          LIKE fir_file.firud07,
        firud08          LIKE fir_file.firud08,
        firud09          LIKE fir_file.firud09,
        firud10          LIKE fir_file.firud10,
        firud11          LIKE fir_file.firud11,
        firud12          LIKE fir_file.firud12,
        firud13          LIKE fir_file.firud13,
        firud14          LIKE fir_file.firud14,
        firud15          LIKE fir_file.firud15
        #FUN-840068 --end--
                    END RECORD,
    g_fir_t         RECORD                     #程式變數 (舊值)
        fir02            LIKE fir_file.fir02,
        fir03            LIKE fir_file.fir03,
        fis02            LIKE fis_file.fis02,
        fir04            LIKE fir_file.fir04,
        #FUN-840068 --start---
        firud01          LIKE fir_file.firud01,
        firud02          LIKE fir_file.firud02,
        firud03          LIKE fir_file.firud03,
        firud04          LIKE fir_file.firud04,
        firud05          LIKE fir_file.firud05,
        firud06          LIKE fir_file.firud06,
        firud07          LIKE fir_file.firud07,
        firud08          LIKE fir_file.firud08,
        firud09          LIKE fir_file.firud09,
        firud10          LIKE fir_file.firud10,
        firud11          LIKE fir_file.firud11,
        firud12          LIKE fir_file.firud12,
        firud13          LIKE fir_file.firud13,
        firud14          LIKE fir_file.firud14,
        firud15          LIKE fir_file.firud15
        #FUN-840068 --end--
                    END RECORD,
    g_fit           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fit02            LIKE fit_file.fit02,
        fit03            LIKE fit_file.fit03,
        fio02            LIKE fio_file.fio02,
        fio05            LIKE fio_file.fio05,
        fio06            LIKE fio_file.fio06,
        c1               LIKE fiu_file.fiu02,
        fio07            LIKE fio_file.fio07,
        d1               LIKE fja_file.fja02,
        fio08            LIKE fio_file.fio08,
        #FUN-840068 --start---
        fitud01          LIKE fit_file.fitud01,
        fitud02          LIKE fit_file.fitud02,
        fitud03          LIKE fit_file.fitud03,
        fitud04          LIKE fit_file.fitud04,
        fitud05          LIKE fit_file.fitud05,
        fitud06          LIKE fit_file.fitud06,
        fitud07          LIKE fit_file.fitud07,
        fitud08          LIKE fit_file.fitud08,
        fitud09          LIKE fit_file.fitud09,
        fitud10          LIKE fit_file.fitud10,
        fitud11          LIKE fit_file.fitud11,
        fitud12          LIKE fit_file.fitud12,
        fitud13          LIKE fit_file.fitud13,
        fitud14          LIKE fit_file.fitud14,
        fitud15          LIKE fit_file.fitud15
        #FUN-840068 --end--
                    END RECORD,
    g_fit_t         RECORD
        fit02            LIKE fit_file.fit02,
        fit03            LIKE fit_file.fit03,
        fio02            LIKE fio_file.fio02,
        fio05            LIKE fio_file.fio05,
        fio06            LIKE fio_file.fio06,
        c1               LIKE fiu_file.fiu02,
        fio07            LIKE fio_file.fio07,
        d1               LIKE fja_file.fja02,
        fio08            LIKE fio_file.fio08,
        #FUN-840068 --start---
        fitud01          LIKE fit_file.fitud01,
        fitud02          LIKE fit_file.fitud02,
        fitud03          LIKE fit_file.fitud03,
        fitud04          LIKE fit_file.fitud04,
        fitud05          LIKE fit_file.fitud05,
        fitud06          LIKE fit_file.fitud06,
        fitud07          LIKE fit_file.fitud07,
        fitud08          LIKE fit_file.fitud08,
        fitud09          LIKE fit_file.fitud09,
        fitud10          LIKE fit_file.fitud10,
        fitud11          LIKE fit_file.fitud11,
        fitud12          LIKE fit_file.fitud12,
        fitud13          LIKE fit_file.fitud13,
        fitud14          LIKE fit_file.fitud14,
        fitud15          LIKE fit_file.fitud15
        #FUN-840068 --end--
                    END RECORD,
    g_wc,g_wc2,g_wc3  STRING,  #No.FUN-580092 HCN 
    g_rec_b1,g_rec_b2 LIKE type_file.num5,            #單身筆數        #No.FUN-680072 SMALLINT
    g_sql,g_sql1,g_sql2 STRING,  #No.FUN-580092 HCN 
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680072CHAR(500)
    g_t1            LIKE type_file.chr5,                #No.FUN-550024        #No.FUN-680072CHAR(5)
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680072 SMALLINT
 
#主程式開始
DEFINE  p_row,p_col         LIKE type_file.num5          #No.FUN-680072 SMALLINT
#FUN-540036---start
DEFINE  l_action_flag        STRING
#FUN-540036---end
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_chr           LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
DEFINE  g_cnt           LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680072 SMALLINT
DEFINE  g_msg           LIKE ze_file.ze03        #No.FUN-680072CHAR(72)
 
DEFINE  g_row_count    LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_curs_index   LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  g_jump         LIKE type_file.num10         #No.FUN-680072 INTEGER
DEFINE  mi_no_ask      LIKE type_file.num5          #No.FUN-680072 SMALLINT
DEFINE  g_void         LIKE type_file.chr1          #No.FUN-680072CHAR(1)
 
MAIN
#DEFINE   l_time    LIKE type_file.chr8            #No.FUN-6A0068
 
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
 
    LET g_forupd_sql = "SELECT * FROM fiq_file WHERE fiq01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t100_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW t100_w33 AT 2,2 WITH FORM "aem/42f/aemt100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL t100_menu()
 
    CLOSE WINDOW t100_w33
      CALL  cl_used(g_prog,g_time,2) #No.MOD-580088  HCN 20050818  #No.FUN-6A0068
         RETURNING g_time    #No.FUN-6A0068
END MAIN
 
#QBE 查詢資料
FUNCTION t100_cs()
 
 DEFINE  l_type          LIKE type_file.chr2         #No.FUN-680072CHAR(2)
 DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_fir.clear()
   CALL g_fit.clear()
   CALL cl_set_head_visible("folder01","YES")    #No.FUN-6B0029
 
   INITIALIZE g_fiq.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON
                fiq00,fiq01,fiq02,fiq03,fiq04,
                fiq05,fiq06,fiq07,fiq08,fiq09,
                fiqconf,fiquser,fiqgrup,fiqmodu,fiqdate,fiqacti,fiqoriu,fiqorig, #TQC-BA0133 add
                #FUN-840068   ---start---
                fiqud01,fiqud02,fiqud03,fiqud04,fiqud05,
                fiqud06,fiqud07,fiqud08,fiqud09,fiqud10,
                fiqud11,fiqud12,fiqud13,fiqud14,fiqud15
                #FUN-840068    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
   ON ACTION CONTROLP
      CASE
         WHEN INFIELD(fiq01)
#           LET g_t1=g_fiq.fiq01[1,3]
            LET g_t1=s_get_doc_no(g_fiq.fiq01)     #No.FUN-550024
 #MOD-560238 --start
#           CALL q_smy(TRUE,TRUE,g_t1,'aem','2') RETURNING g_qryparam.multiret
             #No.MOD-530629  --begin
#            CALL q_fjh(TRUE,TRUE,g_t1,'aem','02') RETURNING g_qryparam.multiret
             #No.MOD-530629  --end
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fiq"
            LET g_qryparam.default1 = g_fiq.fiq01
            CALL cl_create_qry() RETURNING g_qryparam.multiret
 #MOD-560238 --end
            DISPLAY g_qryparam.multiret TO fiq01
            NEXT FIELD fiq01
         WHEN INFIELD(fiq02)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_fia"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fiq02
            NEXT FIELD fiq02
         WHEN INFIELD(fiq07)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_gen"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fiq07
            NEXT FIELD fiq07
         WHEN INFIELD(fiq08)
            CALL cl_init_qry_var()
            LET g_qryparam.state = "c"
            LET g_qryparam.form ="q_pmc"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO fiq08
            NEXT FIELD fiq08
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
   IF INT_FLAG THEN RETURN END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND fiquser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND fiqgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND fiqgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fiquser', 'fiqgrup')
   #End:FUN-980030
 
 
   LET g_wc2 = " 1=1"
   CONSTRUCT g_wc2 ON fir02,fir03,fir04
                      #No.FUN-840068 --start--
                      ,firud01,firud02,firud03,firud04,firud05
                      ,firud06,firud07,firud08,firud09,firud10
                      ,firud11,firud12,firud13,firud14,firud15
                      #No.FUN-840068 ---end---
        FROM s_fir[1].fir02,s_fir[1].fir03,s_fir[1].fir04
             #No.FUN-840068 --start--
             ,s_fir[1].firud01,s_fir[1].firud02,s_fir[1].firud03
             ,s_fir[1].firud04,s_fir[1].firud05,s_fir[1].firud06
             ,s_fir[1].firud07,s_fir[1].firud08,s_fir[1].firud09
             ,s_fir[1].firud10,s_fir[1].firud11,s_fir[1].firud12
             ,s_fir[1].firud13,s_fir[1].firud14,s_fir[1].firud15
             #No.FUN-840068 ---end---
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fir03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fis"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fir[1].fir03
                NEXT FIELD fir03
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
 
 
   END CONSTRUCT
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   LET g_wc3 = " 1=1"
   CONSTRUCT g_wc3 ON fit02,fit03
                      #No.FUN-840068 --start--
                      ,fitud01,fitud02,fitud03,fitud04,fitud05
                      ,fitud06,fitud07,fitud08,fitud09,fitud10
                      ,fitud11,fitud12,fitud13,fitud14,fitud15
                      #No.FUN-840068 ---end---
         FROM s_fit[1].fit02,s_fit[1].fit03
              #No.FUN-840068 --start--
              ,s_fit[1].fitud01,s_fit[1].fitud02,s_fit[1].fitud03
              ,s_fit[1].fitud04,s_fit[1].fitud05,s_fit[1].fitud06
              ,s_fit[1].fitud07,s_fit[1].fitud08,s_fit[1].fitud09
              ,s_fit[1].fitud10,s_fit[1].fitud11,s_fit[1].fitud12
              ,s_fit[1].fitud13,s_fit[1].fitud14,s_fit[1].fitud15
              #No.FUN-840068 ---end---
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fit03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fio"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fit[1].fit03
                NEXT FIELD fit03
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
 
   LET g_sql  = "SELECT fiq01 "
   LET g_sql1 = " FROM fiq_file "
   LET g_sql2 = " WHERE ", g_wc CLIPPED
 
   IF g_wc2 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",fir_file"
      LET g_sql2= g_sql2 CLIPPED," AND fiq01=fir01",
                                 " AND ",g_wc2 CLIPPED
   END IF
   IF g_wc3 <> " 1=1" THEN
      LET g_sql1= g_sql1 CLIPPED,",fit_file"
      LET g_sql2= g_sql2 CLIPPED," AND fiq01=fit01",
                                 " AND ",g_wc3 CLIPPED
   END IF
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED,' ORDER BY fiq01'
 
   PREPARE t100_prepare FROM g_sql
   DECLARE t100_cs SCROLL CURSOR WITH HOLD FOR t100_prepare
 
   LET g_sql  = "SELECT COUNT(UNIQUE fiq01) "
   LET g_sql = g_sql  CLIPPED,' ',g_sql1 CLIPPED,' ',
               g_sql2 CLIPPED
 
   PREPARE t100_precount FROM g_sql
   DECLARE t100_count CURSOR FOR t100_precount
END FUNCTION
 
FUNCTION t100_menu()
 
   WHILE TRUE
#NO.FUN-540036--start
#     CALL t100_bp("G")
      CASE
         WHEN (l_action_flag IS NULL) OR (l_action_flag = "check_item")
            CALL t100_bp1("G")
         WHEN l_action_flag = "PDM"
            CALL t100_bp2("G")
      END CASE
#NO.FUN-540036--end
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t100_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t100_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t100_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t100_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t100_x()
            END IF
         WHEN "qry_data_of_instrument"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_fiq.fiq02) THEN
                  LET g_cmd = "aemi106 '",g_fiq.fiq02,"'"
                  CALL  cl_cmdrun(g_cmd)
               END IF
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t100_z()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "check_item"
            IF cl_chk_act_auth() THEN
               CALL t100_b1()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "PDM"
            IF cl_chk_act_auth() THEN
               CALL t100_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.FUN-6B0050-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_fiq.fiq01 IS NOT NULL THEN
                 LET g_doc.column1 = "fiq01"
                 LET g_doc.value1 = g_fiq.fiq01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6B0050-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t100_a()
   DEFINE li_result   LIKE type_file.num5          #No.FUN-550024        #No.FUN-680072 SMALLINT
   DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0068
 
   IF s_shut(0) THEN RETURN END IF
   LET l_time =TIME
   MESSAGE ""
   CLEAR FORM
   CALL g_fir.clear()
   CALL g_fit.clear()
   INITIALIZE g_fiq.* LIKE fiq_file.*             #DEFAULT 設定
   LET g_fiq01_t = NULL
   #預設值及將數值類變數清成零
   LET g_fiq.fiquser=g_user
   LET g_fiq.fiqoriu = g_user #FUN-980030
   LET g_fiq.fiqorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_fiq.fiqgrup=g_grup
   LET g_fiq.fiqdate=g_today
   LET g_fiq.fiqacti='Y'              #資料有效
   LET g_fiq.fiqconf='N'
   LET g_fiq.fiq00='2'
   LET g_fiq.fiq03=g_today
   LET g_fiq.fiq04=l_time[1,2],l_time[4,5]
   LET g_fiq.fiq05=g_today
   LET g_fiq.fiq06=l_time[1,2],l_time[4,5]
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t100_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_fiq.* TO NULL
         EXIT WHILE
      END IF
      IF g_fiq.fiq01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
      #No.FUN-550024 --start--
       CALL s_auto_assign_no("aem",g_fiq.fiq01,g_today,"2","fiq_file","fiq01","","","")   #No.MOD-560238
        RETURNING li_result,g_fiq.fiq01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_fiq.fiq01
#     IF g_smy.smyauno='Y' AND cl_null(g_fiq.fiq01[5,10]) THEN
#        CALL s_smyauno(g_fiq.fiq01,g_today)
#               RETURNING g_i,g_fiq.fiq01
#        IF g_i THEN CONTINUE WHILE END IF
#        DISPLAY BY NAME g_fiq.fiq01
#     END IF
      #No.FUN-550024 ---end---
      LET g_fiq.fiqplant = g_plant #FUN-980002
      LET g_fiq.fiqlegal = g_legal #FUN-980002
      INSERT INTO fiq_file VALUES (g_fiq.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","fiq_file",g_fiq.fiq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092   #No.FUN-B80026---調整至回滾事務前---
         ROLLBACK WORK
#        CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,1)   #No.FUN-660092
         CONTINUE WHILE
      ELSE
         COMMIT WORK
      END IF
      SELECT fiq01 INTO g_fiq.fiq01 FROM fiq_file
       WHERE fiq01 = g_fiq.fiq01
      LET g_fiq01_t = g_fiq.fiq01        #保留舊值
      LET g_fiq_t.* = g_fiq.*
 
      CALL g_fir.clear()
      LET g_rec_b1=0
      CALL t100_b1()                    #輸入單身-1
 
      CALL g_fit.clear()
      LET g_rec_b2=0
      CALL t100_b2()                   #輸入單身-2
 
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t100_u()
   IF s_shut(0) THEN RETURN END IF
   IF g_fiq.fiq01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_fiq.* FROM fiq_file
    WHERE fiq01=g_fiq.fiq01
   IF g_fiq.fiqacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_fiq.fiq01,9027,0)
      RETURN
   END IF
   IF g_fiq.fiqconf ='Y' THEN    #檢查資料是否為無效
      CALL cl_err(g_fiq.fiq01,9022,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_fiq01_t = g_fiq.fiq01
   LET g_fiq_o.* = g_fiq.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t100_cl USING g_fiq.fiq01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_fiq.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t100_show()
   WHILE TRUE
      LET g_fiq01_t = g_fiq.fiq01
      LET g_fiq.fiqmodu=g_user
      LET g_fiq.fiqdate=g_today
      CALL t100_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_fiq.*=g_fiq_t.*
         CALL t100_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_fiq.fiq01 != g_fiq01_t THEN            # 更改單號
         UPDATE fir_file SET fir01 = g_fiq.fiq01 WHERE fir01 = g_fiq01_t
         UPDATE fit_file SET fit01 = g_fiq.fiq01 WHERE fit01 = g_fiq01_t
      END IF
      UPDATE fiq_file SET fiq_file.* = g_fiq.* WHERE fiq01 = g_fiq01_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)   #No.FUN-660092
         CALL cl_err3("upd","fiq_file",g_fiq.fiq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t100_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t100_i(p_cmd)
DEFINE  li_result   LIKE type_file.num5                 #No.FUN-550024        #No.FUN-680072 SMALLINT
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680072 VARCHAR(1)
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改        #No.FUN-680072 VARCHAR(1)
    CALL cl_set_head_visible("folder01","YES")                   #No.FUN-6B0029
 
    INPUT BY NAME g_fiq.fiqoriu,g_fiq.fiqorig,
          g_fiq.fiq00,g_fiq.fiq01,g_fiq.fiq02,g_fiq.fiq03,
          g_fiq.fiq04,g_fiq.fiq05,g_fiq.fiq06,g_fiq.fiq07,
          g_fiq.fiq08,g_fiq.fiq09,g_fiq.fiqconf,
          g_fiq.fiquser,g_fiq.fiqgrup,g_fiq.fiqmodu,
          g_fiq.fiqdate,g_fiq.fiqacti,
          #FUN-840068     ---start---
          g_fiq.fiqud01,g_fiq.fiqud02,g_fiq.fiqud03,g_fiq.fiqud04,
          g_fiq.fiqud05,g_fiq.fiqud06,g_fiq.fiqud07,g_fiq.fiqud08,
          g_fiq.fiqud09,g_fiq.fiqud10,g_fiq.fiqud11,g_fiq.fiqud12,
          g_fiq.fiqud13,g_fiq.fiqud14,g_fiq.fiqud15 
          #FUN-840068     ----end----
        WITHOUT DEFAULTS
 
       BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t100_set_entry(p_cmd)
           CALL t100_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
         #No.FUN-550024 --start--
         CALL cl_set_docno_format("fiq01")
         #No.FUN-550024 ---end---
 
       AFTER FIELD fiq01   #need modify
         #No.FUN-550024 --start--
         IF NOT cl_null(g_fiq.fiq01) THEN
             CALL s_check_no("aem",g_fiq.fiq01,g_fiq_t.fiq01,"2","fiq_file","fiq01","")   #No.MOD-560238
            RETURNING li_result,g_fiq.fiq01
            DISPLAY BY NAME g_fiq.fiq01
            IF (NOT li_result) THEN
               LET g_fiq.fiq01=g_fiq_t.fiq01
               NEXT FIELD fiq01
            END IF
#           IF NOT cl_null(g_fiq.fiq01) THEN
#             LET g_t1=g_fiq.fiq01[1,3]
#             CALL s_mfgslip(g_t1,'aem','2')
#             IF NOT cl_null(g_errno) THEN                   #抱歉, 有問題
#                CALL cl_err(g_t1,g_errno,0) NEXT FIELD fiq01
#             END IF
#             IF p_cmd = 'a' AND cl_null(g_fiq.fiq01[5,10])
#                AND g_smy.smyauno='N' THEN
#                NEXT FIELD fiq01
#             END IF
#
#             IF g_fiq.fiq01 != g_fiq_t.fiq01 OR g_fiq_t.fiq01 IS NULL THEN
#                IF g_smy.smyauno = 'Y' AND
#                    NOT cl_chk_data_continue(g_fiq.fiq01[5,10]) THEN
#                    CALL cl_err('','9056',0)
#                    NEXT FIELD fiq01
#                 END IF
#                 SELECT COUNT(*) INTO g_cnt FROM fiq_file
#                  WHERE fiq01 = g_fiq.fiq01
#                 IF g_cnt > 0 THEN   #資料重復
#                    CALL cl_err(g_fiq.fiq01,-239,0)
#                    LET g_fiq.fiq01 = g_fiq_t.fiq01
#                    DISPLAY BY NAME g_fiq.fiq01
#                    NEXT FIELD fiq01
#                 END IF
 
#              END IF
           END IF
         #No.FUN-550024 ---end---
        AFTER FIELD fiq02
           IF NOT cl_null(g_fiq.fiq02) THEN
              CALL t100_fiq02(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fiq.fiq02,g_errno,0)
                 LET g_fiq.fiq02 = g_fiq_o.fiq02
                 DISPLAY BY NAME g_fiq.fiq02
                 NEXT FIELD fiq02
              END IF
           END IF
 
        AFTER FIELD fiq04
            IF NOT cl_null(g_fiq.fiq04) THEN
               IF g_fiq.fiq04 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fiq.fiq04[1,2] <'00' OR g_fiq.fiq04[1,2] >'23'
               OR g_fiq.fiq04[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fiq.fiq04,'aem-006',0)
                  NEXT FIELD fiq04
               END IF
           END IF
 
        AFTER FIELD fiq06
            IF NOT cl_null(g_fiq.fiq06) THEN
               IF g_fiq.fiq06 NOT MATCHES '[0-9][0-9][0-9][0-9]'
               OR g_fiq.fiq06[1,2] <'00' OR g_fiq.fiq06[1,2] >'23'
               OR g_fiq.fiq06[3,4] NOT MATCHES '[0-5][0-9]' THEN
                  CALL cl_err(g_fiq.fiq06,'aem-006',0)
                  NEXT FIELD fiq06
               END IF
           END IF
 
        AFTER FIELD fiq07
           IF NOT cl_null(g_fiq.fiq07) THEN
              CALL t100_fiq07(p_cmd)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_fiq.fiq07,g_errno,0)
                 LET g_fiq.fiq07 = g_fiq_o.fiq07
                 DISPLAY BY NAME g_fiq.fiq07
                 NEXT FIELD fiq07
              END IF
           END IF
 
        AFTER FIELD fiq08
            IF NOT cl_null(g_fiq.fiq08) THEN
               CALL t100_fiq08(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fiq.fiq08,g_errno,0)
                  LET g_fiq.fiq08 = g_fiq_o.fiq08
                  DISPLAY BY NAME g_fiq.fiq08
                  NEXT FIELD fiq08
               END IF
            END IF
 
        #FUN-840068     ---start---
        AFTER FIELD fiqud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fiqud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(fiq01)
#                LET g_t1=g_fiq.fiq01[1,3]
                 LET g_t1=s_get_doc_no(g_fiq.fiq01)     #No.FUN-550024
 #MOD-560238 --start
                 CALL q_smy( FALSE,TRUE,g_t1,'AEM','2') RETURNING g_t1 #TQC-670008
                  #No.MOD-530629  --begin
#                 CALL q_fjh( FALSE,TRUE,g_t1,'aem','02') RETURNING g_t1
                  #No.MOD-530629  --end
 #MOD-560238 --end
#                LET g_fiq.fiq01[1,3]=g_t1
                 LET g_fiq.fiq01 = g_t1                 #No.FUN-550024
                 DISPLAY BY NAME g_fiq.fiq01
                 NEXT FIELD fiq01
              WHEN INFIELD(fiq02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fiq.fiq02
                 LET g_qryparam.form ="q_fia"
                 CALL cl_create_qry() RETURNING g_fiq.fiq02
                 DISPLAY BY NAME g_fiq.fiq02
                 NEXT FIELD fiq02
              WHEN INFIELD(fiq07)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fiq.fiq07
                 LET g_qryparam.form ="q_gen"
                 CALL cl_create_qry() RETURNING g_fiq.fiq07
                 DISPLAY BY NAME g_fiq.fiq07
                 NEXT FIELD fiq07
              WHEN INFIELD(fiq08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.default1 = g_fiq.fiq08
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_fiq.fiq08
                 DISPLAY BY NAME g_fiq.fiq08
                 NEXT FIELD fiq08
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
 
FUNCTION t100_fiq02(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_fia02     LIKE fia_file.fia02
   DEFINE l_fiq08     LIKE fiq_file.fiq08
   DEFINE l_fia08     LIKE fia_file.fia08
   DEFINE l_fia14     LIKE fia_file.fia14
   DEFINE l_fia15     LIKE fia_file.fia15
   DEFINE l_fia16     LIKE fia_file.fia16
   DEFINE l_fia17     LIKE fia_file.fia17
   DEFINE l_fka02     LIKE fka_file.fka02
   DEFINE l_fka02a    LIKE fka_file.fka02
   DEFINE l_fka02b    LIKE fka_file.fka02
   DEFINE l_fka02c    LIKE fka_file.fka02
 
   LET g_errno = ' '
 
   SELECT fia02,  fia09,  fia14,  fia15,  fia16,  fia17
     INTO l_fia02,l_fiq08,l_fia14,l_fia15,l_fia16,l_fia17
     FROM fia_file
    WHERE fia01=g_fiq.fiq02 AND fiaacti ='Y'
 
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
     DISPLAY l_fia08  TO FORMONLY.fia08
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
     LET g_fiq.fiq08 = l_fiq08
     DISPLAY BY NAME g_fiq.fiq08
  END IF
 
END FUNCTION
 
FUNCTION t100_fiq07(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_gen02   LIKE gen_file.gen02
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file WHERE gen01 = g_fiq.fiq07
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
 
FUNCTION t100_fiq08(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
   DEFINE l_pmc03   LIKE pmc_file.pmc03
   DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
   LET g_errno = ' '
   SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_fiq.fiq08
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_pmcacti = 'N'     LET g_errno = '9028'
   #FUN-690024------mod-------
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
   #FUN-690024------mod-------
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
   END IF
END FUNCTION
 
FUNCTION t100_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_fiq.* TO NULL              #No.FUN-6B0050
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_fir.clear()
   CALL g_fit.clear()
 
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t100_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_fiq.* TO NULL
   ELSE
      OPEN t100_count
      FETCH t100_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t100_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t100_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680072 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t100_cs INTO g_fiq.fiq01
      WHEN 'P' FETCH PREVIOUS t100_cs INTO g_fiq.fiq01
      WHEN 'F' FETCH FIRST    t100_cs INTO g_fiq.fiq01
      WHEN 'L' FETCH LAST     t100_cs INTO g_fiq.fiq01
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
         FETCH ABSOLUTE g_jump t100_cs INTO g_fiq.fiq01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)
      INITIALIZE g_fiq.* TO NULL  #TQC-6B0105
      CLEAR FORM
      CALL g_fir.clear()
      CALL g_fit.clear()
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
   SELECT * INTO g_fiq.* FROM fiq_file WHERE fiq01 = g_fiq.fiq01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)   #No.FUN-660092
      CALL cl_err3("sel","fiq_file",g_fiq.fiq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
      INITIALIZE g_fiq.* TO NULL
      RETURN
   END IF
   LET g_data_owner = g_fiq.fiquser   #FUN-4C0069
   LET g_data_group = g_fiq.fiqgrup   #FUN-4C0069
   LET g_data_plant = g_fiq.fiqplant #FUN-980030
   CALL t100_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t100_show()
   LET g_fiq_t.* = g_fiq.*                #保存單頭舊值
   DISPLAY BY NAME g_fiq.fiqoriu,g_fiq.fiqorig,
          g_fiq.fiq00,g_fiq.fiq01,g_fiq.fiq02,g_fiq.fiq03,
          g_fiq.fiq04,g_fiq.fiq05,g_fiq.fiq06,g_fiq.fiq07,
          g_fiq.fiq08,g_fiq.fiq09,g_fiq.fiqconf,
          g_fiq.fiquser,g_fiq.fiqgrup,g_fiq.fiqmodu,
          g_fiq.fiqdate,g_fiq.fiqacti,
          #FUN-840068     ---start---
          g_fiq.fiqud01,g_fiq.fiqud02,g_fiq.fiqud03,g_fiq.fiqud04,
          g_fiq.fiqud05,g_fiq.fiqud06,g_fiq.fiqud07,g_fiq.fiqud08,
          g_fiq.fiqud09,g_fiq.fiqud10,g_fiq.fiqud11,g_fiq.fiqud12,
          g_fiq.fiqud13,g_fiq.fiqud14,g_fiq.fiqud15 
          #FUN-840068     ----end----
   CALL t100_fiq02('d')
   CALL t100_fiq07('d')
   CALL t100_fiq08('d')
   CALL t100_b1_fill(g_wc2)                 #單身
   CALL t100_b2_fill(g_wc3)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t100_r()
   IF s_shut(0) THEN RETURN END IF
   IF g_fiq.fiq01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fiq.* FROM fiq_file WHERE fiq01=g_fiq.fiq01
   IF g_fiq.fiqconf ='Y' THEN    #檢查資料是否為無效
      CALL cl_err(g_fiq.fiq01,9022,0)
      RETURN
   END IF
 
   #TQC-970173---Begin                                                                                                              
   IF g_fiq.fiqacti = 'N' THEN                                                                                                      
      CALL cl_err(g_fiq.fiq01,'abm-033',0)                                                                                          
      RETURN                                                                                                                        
   END IF                                                                                                                           
   #TQC-970173---End  
 
   BEGIN WORK
   OPEN t100_cl USING g_fiq.fiq01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_fiq.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t100_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "fiq01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_fiq.fiq01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM fir_file WHERE fir01 = g_fiq.fiq01
      IF STATUS THEN
#        CALL cl_err('del fir:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fir_file",g_fiq.fiq01,"",STATUS,"","del fir:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fit_file WHERE fit01 = g_fiq.fiq01
      IF STATUS THEN
#        CALL cl_err('del fit:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fit_file",g_fiq.fiq01,"",STATUS,"","del fit:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM fiq_file WHERE fiq01 = g_fiq.fiq01
      IF STATUS THEN
#        CALL cl_err('del fiq:',STATUS,1)   #No.FUN-660092
         CALL cl_err3("del","fiq_file",g_fiq.fiq01,"",STATUS,"","del fiq:",1)  #No.FUN-660092
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_fiq.* TO NULL
      CLEAR FORM
      CALL g_fir.clear()
      CALL g_fit.clear()
      OPEN t100_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t100_cs
             CLOSE t100_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
      FETCH t100_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t100_cs
             CLOSE t100_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--

      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t100_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t100_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t100_fetch('/')
      END IF
   END IF
   CLOSE t100_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t100_b1()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680072 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680072 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680072 VARCHAR(1)
   l_exit_sw       LIKE type_file.chr1,                #No.FUN-680072 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680072 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680072 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fiq.fiq01 IS NULL THEN RETURN END IF
   SELECT * INTO g_fiq.* FROM fiq_file WHERE fiq01=g_fiq.fiq01
   IF g_fiq.fiqacti ='N' THEN CALL cl_err(g_fiq.fiq01,'9027',0) RETURN END IF
   IF g_fiq.fiqconf ='Y' THEN    #檢查資料是否為無效
      CALL cl_err(g_fiq.fiq01,9022,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT fir02,fir03,'',fir04, ",
                      #No.FUN-840068 --start--
                      "       firud01,firud02,firud03,firud04,firud05,",
                      "       firud06,firud07,firud08,firud09,firud10,",
                      "       firud11,firud12,firud13,firud14,firud15 ", 
                      #No.FUN-840068 ---end---
                      " FROM fir_file",
                      " WHERE fir01=? AND fir02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t100_b1_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_fir WITHOUT DEFAULTS FROM s_fir.*
         ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
 
          BEGIN WORK
          OPEN t100_cl USING g_fiq.fiq01
          IF STATUS THEN
             CALL cl_err("OPEN t100_cl:", STATUS, 1)
             CLOSE t100_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t100_cl INTO g_fiq.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE t100_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b1 >= l_ac THEN
             LET p_cmd='u'
             LET g_fir_t.* = g_fir[l_ac].*  #BACKUP
             OPEN t100_b1_cl USING g_fiq.fiq01,g_fir_t.fir02
             IF STATUS THEN
                CALL cl_err("OPEN t100_b1_cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t100_b1_cl INTO g_fir[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_fir_t.fir02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                CALL t100_fir03('d')
             END IF
          END IF
 
       BEFORE INSERT
          LET p_cmd='a'
          LET l_n = ARR_COUNT()
          INITIALIZE g_fir[l_ac].* TO NULL      #900423
          LET g_fir_t.* = g_fir[l_ac].*         #新輸入資料
          LET g_fir[l_ac].fir04='Y'
          NEXT FIELD fir02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO fir_file(fir01,fir02,fir03,fir04,
                               #FUN-840068 --start--
                               firud01,firud02,firud03,firud04,firud05,firud06,
                               firud07,firud08,firud09,firud10,firud11,firud12,
                               firud13,firud14,firud15,
                               firplant,firlegal)
                               #FUN-840068 --end--
          VALUES(g_fiq.fiq01,g_fir[l_ac].fir02,
                 g_fir[l_ac].fir03,g_fir[l_ac].fir04,
                 #FUN-840068 --start--
                 g_fir[l_ac].firud01,g_fir[l_ac].firud02,g_fir[l_ac].firud03,
                 g_fir[l_ac].firud04,g_fir[l_ac].firud05,g_fir[l_ac].firud06,
                 g_fir[l_ac].firud07,g_fir[l_ac].firud08,g_fir[l_ac].firud09,
                 g_fir[l_ac].firud10,g_fir[l_ac].firud11,g_fir[l_ac].firud12,
                 g_fir[l_ac].firud13,g_fir[l_ac].firud14,g_fir[l_ac].firud15,
                 g_plant,g_legal) #FUN-980002
                 #FUN-840068 --end--
          IF SQLCA.sqlcode THEN
#            CALL cl_err(g_fir[l_ac].fir02,SQLCA.sqlcode,0)   #No.FUN-660092
             CALL cl_err3("ins","fir_file",g_fiq.fiq01,g_fir[l_ac].fir02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b1=g_rec_b1+1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             COMMIT WORK
          END IF
 
       BEFORE FIELD fir02                        #default 序號
          IF g_fir[l_ac].fir02 IS NULL OR g_fir[l_ac].fir02 = 0 THEN
             SELECT max(fir02)+1
               INTO g_fir[l_ac].fir02
               FROM fir_file
              WHERE fir01 = g_fiq.fiq01
             IF g_fir[l_ac].fir02 IS NULL THEN
                LET g_fir[l_ac].fir02 = 1
             END IF
          END IF
 
       AFTER FIELD fir02                        #check 序號是否重複
          IF NOT cl_null(g_fir[l_ac].fir02) THEN
             IF g_fir[l_ac].fir02 != g_fir_t.fir02 OR
                g_fir_t.fir02 IS NULL THEN
                SELECT count(*) INTO l_n FROM fir_file
                 WHERE fir01 = g_fiq.fiq01
                   AND fir02 = g_fir[l_ac].fir02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_fir[l_ac].fir02 = g_fir_t.fir02
                   NEXT FIELD fir02
                END IF
             END IF
          END IF
 
       AFTER FIELD fir03
          IF NOT cl_null(g_fir[l_ac].fir03) THEN
             CALL t100_fir03(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fir[l_ac].fir03,SQLCA.sqlcode,0)
                LET g_fir[l_ac].fir03 = g_fir_t.fir03
                NEXT FIELD fir03
             END IF
          END IF
 
       #No.FUN-840068 --start--
       AFTER FIELD firud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD firud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-840068 ---end---
 
       BEFORE DELETE                            #是否取消單身
          IF g_fir_t.fir02 > 0 AND
             g_fir_t.fir02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM fir_file
              WHERE fir01 = g_fiq.fiq01
                AND fir02 = g_fir_t.fir02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fir_t.fir02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("del","fir_file",g_fiq.fiq01,g_fir_t.fir02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b1=g_rec_b1-1
             DISPLAY g_rec_b1 TO FORMONLY.cn2
             MESSAGE "Delete Ok"
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_fir[l_ac].* = g_fir_t.*
             CLOSE t100_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_fir[l_ac].fir02,-263,1)
             LET g_fir[l_ac].* = g_fir_t.*
          ELSE
             UPDATE fir_file SET fir02 = g_fir[l_ac].fir02,
                                 fir03 = g_fir[l_ac].fir03,
                                 fir04 = g_fir[l_ac].fir04,
                                 #FUN-840068 --start--
                                 firud01 = g_fir[l_ac].firud01,
                                 firud02 = g_fir[l_ac].firud02,
                                 firud03 = g_fir[l_ac].firud03,
                                 firud04 = g_fir[l_ac].firud04,
                                 firud05 = g_fir[l_ac].firud05,
                                 firud06 = g_fir[l_ac].firud06,
                                 firud07 = g_fir[l_ac].firud07,
                                 firud08 = g_fir[l_ac].firud08,
                                 firud09 = g_fir[l_ac].firud09,
                                 firud10 = g_fir[l_ac].firud10,
                                 firud11 = g_fir[l_ac].firud11,
                                 firud12 = g_fir[l_ac].firud12,
                                 firud13 = g_fir[l_ac].firud13,
                                 firud14 = g_fir[l_ac].firud14,
                                 firud15 = g_fir[l_ac].firud15
                                 #FUN-840068 --end-- 
              WHERE fir01=g_fiq.fiq01 AND fir02=g_fir_t.fir02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fir[l_ac].fir02,SQLCA.sqlcode,0)   #No.FUN-660092
                CALL cl_err3("upd","fir_file",g_fiq.fiq01,g_fir_t.fir02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                LET g_fir[l_ac].* = g_fir_t.*
                CLOSE t100_b1_cl
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
                LET g_fir[l_ac].* = g_fir_t.*
             #FUN-D40030--add--str--
             ELSE
                CALL g_fir.deleteElement(l_ac)
                IF g_rec_b1 != 0 THEN
                   LET g_action_choice = "check_item"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D40030--add--end--
             END IF
             CLOSE t100_b1_cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D40030
          CLOSE t100_b1_cl
          COMMIT WORK
 
       ON ACTION CONTROLN
          CALL t100_b1_askkey()
          EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fir02) AND l_ac > 1 THEN
               LET g_fir[l_ac].* = g_fir[l_ac-1].*
               NEXT FIELD fir02
           END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fir03)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_fir[l_ac].fir03
                LET g_qryparam.form ="q_fis"
                CALL cl_create_qry() RETURNING g_fir[l_ac].fir03
                NEXT FIELD fir03
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
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end                       
 
   END INPUT
 
  #start FUN-5A0029
   LET g_fiq.fiqmodu = g_user
   LET g_fiq.fiqdate = g_today
   UPDATE fiq_file SET fiqmodu = g_fiq.fiqmodu,fiqdate = g_fiq.fiqdate
    WHERE fiq01 = g_fiq.fiq01
   DISPLAY BY NAME g_fiq.fiqmodu,g_fiq.fiqdate
  #end FUN-5A0029
 
   CLOSE t100_b1_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t100_fir03(p_cmd)
    DEFINE l_fis02    LIKE fis_file.fis02,
           l_fisacti  LIKE fis_file.fisacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT fis02,fisacti INTO l_fis02,l_fisacti
      FROM fis_file WHERE fis01 = g_fir[l_ac].fir03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET l_fis02 = NULL
         WHEN l_fisacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_fir[l_ac].fis02 = l_fis02
    END IF
    DISPLAY BY NAME g_fir[l_ac].*                  #MOD-B70279 add
END FUNCTION
 
FUNCTION t100_b2()
DEFINE
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680072 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680072 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680072 SMALLINT
    l_cnt           LIKE type_file.num5,          #No.FUN-680072 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680072 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680072 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680072 SMALLINT
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fiq.fiq01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fiq.* FROM fiq_file WHERE fiq01=g_fiq.fiq01
    IF g_fiq.fiqacti ='N' THEN CALL cl_err(g_fiq.fiq01,'9027',0) RETURN END IF
    IF g_fiq.fiqconf ='Y' THEN    #檢查資料是否為無效
       CALL cl_err(g_fiq.fiq01,9022,0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT fit02,fit03,'','','','','','','', ",
                       #No.FUN-840068 --start--
                       "       fitud01,fitud02,fitud03,fitud04,fitud05,",
                       "       fitud06,fitud07,fitud08,fitud09,fitud10,",
                       "       fitud11,fitud12,fitud13,fitud14,fitud15 ", 
                       #No.FUN-840068 ---end---
                       "  FROM fit_file",
                       " WHERE fit01=? AND fit02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t100_b2_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_fit WITHOUT DEFAULTS FROM s_fit.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
 
           BEGIN WORK
           OPEN t100_cl USING g_fiq.fiq01
           IF STATUS THEN
              CALL cl_err("OPEN t100_cl:", STATUS, 1)
              CLOSE t100_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t100_cl INTO g_fiq.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t100_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_fit_t.* = g_fit[l_ac].*  #BACKUP
              OPEN t100_b2_cl USING g_fiq.fiq01,g_fit_t.fit02
              IF STATUS THEN
                 CALL cl_err("OPEN t100_b2_cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t100_b2_cl INTO g_fit[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fit_t.fit02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL t100_fit03('d')
              END IF
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_fit[l_ac].* TO NULL
           LET g_fit_t.* = g_fit[l_ac].*         #新輸入資料
           NEXT FIELD fit02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO fit_file(fit01,fit02,fit03,
                                #FUN-840068 --start--
                                fitud01,fitud02,fitud03,fitud04,fitud05,fitud06,
                                fitud07,fitud08,fitud09,fitud10,fitud11,fitud12,
                                fitud13,fitud14,fitud15,
                                fitplant,fitlegal) #FUN-980002
                                #FUN-840068 --end--
            VALUES(g_fiq.fiq01,g_fit[l_ac].fit02,g_fit[l_ac].fit03,
                   #FUN-840068 --start--
                   g_fit[l_ac].fitud01,g_fit[l_ac].fitud02,g_fit[l_ac].fitud03,
                   g_fit[l_ac].fitud04,g_fit[l_ac].fitud05,g_fit[l_ac].fitud06,
                   g_fit[l_ac].fitud07,g_fit[l_ac].fitud08,g_fit[l_ac].fitud09,
                   g_fit[l_ac].fitud10,g_fit[l_ac].fitud11,g_fit[l_ac].fitud12,
                   g_fit[l_ac].fitud13,g_fit[l_ac].fitud14,g_fit[l_ac].fitud15,
                   g_plant,g_legal) #FUN-980002
                   #FUN-840068 --end--
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_fit[l_ac].fit02,SQLCA.sqlcode,0)   #No.FUN-660092
              CALL cl_err3("ins","fit_file",g_fiq.fiq01,g_fit[l_ac].fit02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              COMMIT WORK
           END IF
 
        BEFORE FIELD fit02                        #default 序號
           IF g_fit[l_ac].fit02 IS NULL OR g_fit[l_ac].fit02 = 0 THEN
              SELECT max(fit02)+1
                INTO g_fit[l_ac].fit02
                FROM fit_file
               WHERE fit01 = g_fiq.fiq01
              IF g_fit[l_ac].fit02 IS NULL THEN
                 LET g_fit[l_ac].fit02 = 1
              END IF
           END IF
 
        AFTER FIELD fit02                        #check 序號是否重複
           IF NOT cl_null(g_fit[l_ac].fit02) THEN
              IF g_fit[l_ac].fit02 != g_fit_t.fit02 OR g_fit_t.fit02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM fit_file
                  WHERE fit01 = g_fiq.fiq01
                    AND fit02 = g_fit[l_ac].fit02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_fit[l_ac].fit02 = g_fit_t.fit02
                    NEXT FIELD fit02
                 END IF
              END IF
           END IF
 
       AFTER FIELD fit03
          IF NOT cl_null(g_fit[l_ac].fit03) THEN
             CALL t100_fit03(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fit[l_ac].fit03,SQLCA.sqlcode,0)
                LET g_fit[l_ac].fit03 = g_fit_t.fit03
                NEXT FIELD fit03
             END IF
          END IF
 
       #No.FUN-840068 --start--
       AFTER FIELD fitud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fitud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
           IF g_fit_t.fit02 > 0 AND g_fit_t.fit02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM fit_file
               WHERE fit01 = g_fiq.fiq01
                 AND fit02 = g_fit_t.fit02
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_fit_t.fit02,SQLCA.sqlcode,0)   #No.FUN-660092
                 CALL cl_err3("del","fit_file",g_fiq.fiq01,g_fit_t.fit02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              MESSAGE "Delete Ok"
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fit[l_ac].* = g_fit_t.*
               CLOSE t100_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fit[l_ac].fit02,-263,1)
               LET g_fit[l_ac].* = g_fit_t.*
            ELSE
               UPDATE fit_file SET fit02 = g_fit[l_ac].fit02,
                                   fit03 = g_fit[l_ac].fit03,
                                   #FUN-840068 --start--
                                   fitud01 = g_fit[l_ac].fitud01,
                                   fitud02 = g_fit[l_ac].fitud02,
                                   fitud03 = g_fit[l_ac].fitud03,
                                   fitud04 = g_fit[l_ac].fitud04,
                                   fitud05 = g_fit[l_ac].fitud05,
                                   fitud06 = g_fit[l_ac].fitud06,
                                   fitud07 = g_fit[l_ac].fitud07,
                                   fitud08 = g_fit[l_ac].fitud08,
                                   fitud09 = g_fit[l_ac].fitud09,
                                   fitud10 = g_fit[l_ac].fitud10,
                                   fitud11 = g_fit[l_ac].fitud11,
                                   fitud12 = g_fit[l_ac].fitud12,
                                   fitud13 = g_fit[l_ac].fitud13,
                                   fitud14 = g_fit[l_ac].fitud14,
                                   fitud15 = g_fit[l_ac].fitud15
                                   #FUN-840068 --end-- 
                WHERE fit01=g_fiq.fiq01
                  AND fit02=g_fit_t.fit02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_fit[l_ac].fit02,SQLCA.sqlcode,0)   #No.FUN-660092
                  CALL cl_err3("upd","fit_file",g_fiq.fiq01,g_fit_t.fit02,SQLCA.sqlcode,"","",1)  #No.FUN-660092
                  LET g_fit[l_ac].* = g_fit_t.*
                  CLOSE t100_b2_cl
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
                  LET g_fit[l_ac].* = g_fit_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_fit.deleteElement(l_ac)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "PDM"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t100_b2_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE t100_b2_cl
            COMMIT WORK
 
        ON ACTION CONTROLN
           CALL t100_b2_askkey()
           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(fit02) AND l_ac > 1 THEN
               LET g_fit[l_ac].* = g_fit[l_ac-1].*
               NEXT FIELD fit02
           END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fit03)
                CALL cl_init_qry_var()
                LET g_qryparam.default1 = g_fit[l_ac].fit03
                LET g_qryparam.form ="q_fio"
                CALL cl_create_qry() RETURNING g_fit[l_ac].fit03
                NEXT FIELD fit03
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
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end                       
 
    END INPUT
 
   #start FUN-5A0029
    LET g_fiq.fiqmodu = g_user
    LET g_fiq.fiqdate = g_today
    UPDATE fiq_file SET fiqmodu = g_fiq.fiqmodu,fiqdate = g_fiq.fiqdate
     WHERE fiq01 = g_fiq.fiq01
    DISPLAY BY NAME g_fiq.fiqmodu,g_fiq.fiqdate
   #end FUN-5A0029
 
    CLOSE t100_b2_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t100_fit03(p_cmd)
    DEFINE l_fioacti  LIKE fio_file.fioacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT fio05,fio06,fiu02,fio07,fja02,fio08,fioacti,fio02    #No.MOD-7A0032 add fio02
      INTO g_fit[l_ac].fio05,g_fit[l_ac].fio06,g_fit[l_ac].c1,
           g_fit[l_ac].fio07,g_fit[l_ac].d1,g_fit[l_ac].fio08,l_fioacti,
           g_fit[l_ac].fio02      #No.MOD-7A0032 add fio02
      FROM fio_file LEFT OUTER JOIN fiu_file ON fio_file.fio06=fiu_file.fiu01 LEFT OUTER JOIN fja_file ON fio_file.fio07=fja_file.fja01
     WHERE fio01 = g_fit[l_ac].fit03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                   LET g_fit[l_ac].fio05 = NULL
                                   LET g_fit[l_ac].fio06 = NULL
                                   LET g_fit[l_ac].fio07 = NULL
                                   LET g_fit[l_ac].fio08 = NULL
                                   LET g_fit[l_ac].c1 = NULL
                                   LET g_fit[l_ac].d1 = NULL
         WHEN l_fioacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION t100_b1_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    CONSTRUCT l_wc2 ON fir02,fir03,fir04
                       #No.FUN-840068 --start--
                       ,firud01,firud02,firud03,firud04,firud05
                       ,firud06,firud07,firud08,firud09,firud10
                       ,firud11,firud12,firud13,firud14,firud15
                       #No.FUN-840068 ---end---
            FROM s_fir[1].fir02,s_fir[1].fir03,s_fir[1].fir04
                 #No.FUN-840068 --start--
                 ,s_fir[1].firud01,s_fir[1].firud02,s_fir[1].firud03
                 ,s_fir[1].firud04,s_fir[1].firud05,s_fir[1].firud06
                 ,s_fir[1].firud07,s_fir[1].firud08,s_fir[1].firud09
                 ,s_fir[1].firud10,s_fir[1].firud11,s_fir[1].firud12
                 ,s_fir[1].firud13,s_fir[1].firud14,s_fir[1].firud15
                 #No.FUN-840068 ---end---
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fir03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fis"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fir[1].fir03
                NEXT FIELD fir03
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
    CALL t100_b1_fill(l_wc2)
END FUNCTION
 
FUNCTION t100_b1_fill(p_wc1)
DEFINE
    p_wc1           LIKE type_file.chr1000      #No.FUN-680072CHAR(200)
 
    IF cl_null(p_wc1) THEN LET p_wc1 = ' 1=1' END IF
    LET g_sql = "SELECT fir02,fir03,fis02,fir04,",
                #No.FUN-840068 --start--
                "       firud01,firud02,firud03,firud04,firud05,",
                "       firud06,firud07,firud08,firud09,firud10,",
                "       firud11,firud12,firud13,firud14,firud15", 
                #No.FUN-840068 ---end---
                "  FROM fir_file LEFT OUTER JOIN fis_file ON fir_file.fir03 = fis_file.fis01",
                " WHERE fir01 ='",g_fiq.fiq01,"'",
                "   AND ",p_wc1 CLIPPED,
                " ORDER BY 1"
    PREPARE t100_pb1 FROM g_sql
    DECLARE fir_curs1 CURSOR FOR t100_pb1
 
    CALL g_fir.clear()
    LET g_cnt= 1
    FOREACH fir_curs1 INTO g_fir[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt=g_cnt+1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_fir.deleteElement(g_cnt)
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t100_b2_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    CONSTRUCT l_wc2 ON fit02,fit03
                       #No.FUN-840068 --start--
                       ,fitud01,fitud02,fitud03,fitud04,fitud05
                       ,fitud06,fitud07,fitud08,fitud09,fitud10
                       ,fitud11,fitud12,fitud13,fitud14,fitud15
                       #No.FUN-840068 ---end---
            FROM s_fit[1].fit02,s_fit[1].fit03
                 #No.FUN-840068 --start--
                 ,s_fit[1].fitud01,s_fit[1].fitud02,s_fit[1].fitud03
                 ,s_fit[1].fitud04,s_fit[1].fitud05,s_fit[1].fitud06
                 ,s_fit[1].fitud07,s_fit[1].fitud08,s_fit[1].fitud09
                 ,s_fit[1].fitud10,s_fit[1].fitud11,s_fit[1].fitud12
                 ,s_fit[1].fitud13,s_fit[1].fitud14,s_fit[1].fitud15
                 #No.FUN-840068 ---end---
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(fit03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_fio"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_fir[1].fit03
                NEXT FIELD fit03
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
    CALL t100_b2_fill(l_wc2)
END FUNCTION
 
FUNCTION t100_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680072CHAR(200)
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT fit02,fit03,fio02,fio05,fio06,fiu02,fio07,fja02,fio08, ",   #No.MOD-7A0032 add fio02
                #No.FUN-840068 --start--
                "       fitud01,fitud02,fitud03,fitud04,fitud05,",
                "       fitud06,fitud07,fitud08,fitud09,fitud10,",
                "       fitud11,fitud12,fitud13,fitud14,fitud15 ", 
                #No.FUN-840068 ---end---
               #"  FROM fit_file LEFT OUTER JOIN fio_file LEFT OUTER JOIN fiu_file ON fio_file.fio06=fiu_file.fiu01 LEFT OUTER JOIN fja_file ON fio_file.fio07=fja_file.fja01 ON fit_file.fit03=fio_file.fio01)",  #MOD-D50141 mark
                "  FROM fit_file LEFT OUTER JOIN fio_file LEFT OUTER JOIN fiu_file ON fio_file.fio06=fiu_file.fiu01 LEFT OUTER JOIN fja_file ON fio_file.fio07=fja_file.fja01 ON fit_file.fit03=fio_file.fio01",  #MOD-D50141 del ')'
                " WHERE fit01 ='",g_fiq.fiq01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY 1"
    PREPARE t100_pb2 FROM g_sql
    DECLARE fit_curs2 CURSOR FOR t100_pb2
 
    CALL g_fit.clear()
    LET g_cnt = 1
    FOREACH fit_curs2 INTO g_fit[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_fit.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION
 
#NO.FUN-540036--start
FUNCTION t100_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN     #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "check_item" THEN  #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_fir TO s_fir.* ATTRIBUTE(COUNT=g_rec_b1)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION PDM
         LET l_action_flag = "PDM"
      EXIT DISPLAY
 
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
         CALL t100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL t100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION qry_data_of_instrument
         LET g_action_choice="qry_data_of_instrument"
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
         CALL cl_show_fld_cont()   #FUN-550037(smin)
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#NO.FUN540036--start
#     ON ACTION check_item_detail
      ON ACTION detail
         LET g_action_choice="check_item"
         EXIT DISPLAY
#     ON ACTION processing_decision_making_detail
#        LET g_action_choice="processing_decision_making_detail"
#        EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="check_item"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end                        
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN540036--end
#NO.FUN-540036--start
FUNCTION t100_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN  #FUN-D40030 mark
   IF p_ud <> "G" OR g_action_choice = "PDM" THEN      #FUN-D40030 add
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
 
   DISPLAY ARRAY g_fit TO s_fit.* ATTRIBUTE(COUNT=g_rec_b2)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      ON ACTION check_item
         LET l_action_flag = "check_item"
      EXIT DISPLAY
 
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
         CALL t100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION previous
         CALL t100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION jump
         CALL t100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION next
         CALL t100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION last
         CALL t100_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###fig in 040517
           IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######fig in 040505
           END IF
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION qry_data_of_instrument
         LET g_action_choice="qry_data_of_instrument"
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
         CALL cl_show_fld_cont()   #FUN-550037(smin)
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#NO.FUN540036--start
#     ON ACTION check_item_detail
      ON ACTION detail
         LET g_action_choice="PDM"
         EXIT DISPLAY
#     ON ACTION processing_decision_making_detail
#        LET g_action_choice="processing_decision_making_detail"
#        EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="PDM"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("folder01","AUTO")                    
#No.FUN-6B0029--end                        
 
      ON ACTION related_document                #No.FUN-6B0050  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN540036--end
 
FUNCTION t100_x()
   IF s_shut(0) THEN RETURN END IF
   IF g_fiq.fiq01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_fiq.* FROM fiq_file
    WHERE fiq01=g_fiq.fiq01
   IF g_fiq.fiqconf ='Y' THEN    #檢查資料是否為無效
      CALL cl_err(g_fiq.fiq01,9022,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t100_cl USING g_fiq.fiq01
   IF STATUS THEN
      CALL cl_err("OPEN t100_cl:", STATUS, 1)
      CLOSE t100_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t100_cl INTO g_fiq.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
   CALL t100_show()
   IF cl_exp(0,0,g_fiq.fiqacti) THEN                   #確認一下
       LET g_chr=g_fiq.fiqacti
       IF g_fiq.fiqacti='Y' THEN
           LET g_fiq.fiqacti='N'
       ELSE
           LET g_fiq.fiqacti='Y'
       END IF
       UPDATE fiq_file
          SET fiqacti=g_fiq.fiqacti, #更改有效碼
              fiqmodu=g_user,
              fiqdate=g_today
        WHERE fiq01=g_fiq.fiq01
       IF SQLCA.sqlcode OR STATUS=100 THEN
#          CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)   #No.FUN-660092
           CALL cl_err3("upd","fiq_file",g_fiq.fiq01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660092
           LET g_fiq.fiqacti=g_chr
       END IF
       SELECT fiqacti,fiqmodu,fiqdate
         INTO g_fiq.fiqacti,g_fiq.fiqmodu,g_fiq.fiqdate
         FROM fiq_file
        WHERE fiq01=g_fiq.fiq01
       DISPLAY BY NAME g_fiq.fiqacti,g_fiq.fiqmodu,g_fiq.fiqdate
   END IF
   CLOSE t100_cl
   COMMIT WORK
END FUNCTION
 
FUNCTION t100_y()
    IF g_fiq.fiq01 IS NULL THEN RETURN END IF
#CHI-C30107 ------- add -------- begin
    IF g_fiq.fiqacti='N' THEN
       CALL cl_err(g_fiq.fiq01,'mfg1000',0)
       RETURN
    END IF
    IF g_fiq.fiqconf='Y' THEN RETURN END IF
 #  IF NOT cl_conf(17,12,'axm-108') THEN RETURN END IF  #--TQC-CC0114--mark--
    IF NOT cl_confirm('axm-108') THEN RETURN END IF   #--TQC-CC0114-add--
#CHI-C30107 ------- add -------- end
    SELECT * INTO g_fiq.* FROM fiq_file WHERE fiq01=g_fiq.fiq01
    IF g_fiq.fiqacti='N' THEN
       CALL cl_err(g_fiq.fiq01,'mfg1000',0)
       RETURN
    END IF
    IF g_fiq.fiqconf='Y' THEN RETURN END IF
#   IF NOT cl_conf(17,12,'axm-108') THEN RETURN END IF #CHI-C30107 mark
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t100_cl USING g_fiq.fiq01
    IF STATUS THEN
       CALL cl_err("OPEN t100_cl:", STATUS, 1)
       CLOSE t100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t100_cl INTO g_fiq.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)
        CLOSE t100_cl
        ROLLBACK WORK
        RETURN
    END IF
 
    UPDATE fiq_file SET fiqconf='Y'
     WHERE fiq01 = g_fiq.fiq01
    IF STATUS THEN
#      CALL cl_err('upd fiqconf',STATUS,0)   #No.FUN-660092
       CALL cl_err3("upd","fiq_file","","",STATUS,"","upd fiqconf",1)  #No.FUN-660092
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT fiqconf INTO g_fiq.fiqconf FROM fiq_file
     WHERE fiq01 = g_fiq.fiq01
    DISPLAY BY NAME g_fiq.fiqconf
END FUNCTION
 
FUNCTION t100_z()
DEFINE l_n LIKE type_file.num5          #No.FUN-680072 SMALLINT
 
    IF g_fiq.fiq01 IS NULL THEN RETURN END IF
    SELECT * INTO g_fiq.* FROM fiq_file WHERE fiq01=g_fiq.fiq01
    IF g_fiq.fiqacti='N' THEN
       CALL cl_err(g_fiq.fiq01,'mfg1000',0)
       RETURN
    END IF
    IF g_fiq.fiqconf='N' THEN RETURN END IF
 

 #  IF NOT cl_conf(17,12,'axm-109') THEN RETURN END IF  #--TQC-CC0114--mark--
    IF NOT cl_confirm('axm-109') THEN RETURN END IF   #--TQC-CC0114-add--

 
    LET g_success='Y'
    BEGIN WORK
        OPEN t100_cl USING g_fiq.fiq01
        IF STATUS THEN
           CALL cl_err("OPEN t100_cl:", STATUS, 1)
           CLOSE t100_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t100_cl INTO g_fiq.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_fiq.fiq01,SQLCA.sqlcode,0)
            CLOSE t100_cl
            ROLLBACK WORK
            RETURN
        END IF
        UPDATE fiq_file SET fiqconf='N'
            WHERE fiq01 = g_fiq.fiq01
        IF STATUS THEN
#           CALL cl_err('upd cofconf',STATUS,0)   #No.FUN-660092
            CALL cl_err3("upd","fiq_file",g_fiq.fiq01,"",STATUS,"","upd cofconf",1)  #No.FUN-660092
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT fiqconf INTO g_fiq.fiqconf FROM fiq_file
            WHERE fiq01 = g_fiq.fiq01
        DISPLAY BY NAME g_fiq.fiqconf
END FUNCTION
 
FUNCTION t100_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("fiq00,fiq01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680072 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fiq00,fiq01",FALSE)
    END IF
 
END FUNCTION
#Patch....NO.TQC-610035 <001,002> #
