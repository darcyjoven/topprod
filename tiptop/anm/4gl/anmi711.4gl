# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...:
# Descriptions...: 合約借款額度維護作業
# Date & Author..: 98/10/28 by plum
# Modify.........: 98/12/18 By ANN CHEN => Adding Page Trailer
# Modify.........: No.7354 03/10/28 By Kitty 配合改為小數4位
# Modify.........: No.8686 03/11/12 By Kitty 單身金額*額匯不可大於單頭核准金額
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470576 04/07/29 By Kitty 修改INSERT INTO 改錯的部份
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0098 05/01/11 By pengu 報表轉XML
# Modify.........: No.MOD-530816 05/03/29 By Smapmin 1.合約對應融資種類(單身資料)
#                                                      在aapt720確認融資資料後還可修改
#                                                    2.額匯輸入錯誤造成金額超過單頭
#                                                      核准金額時無法回頭修改資料
#                                                    3.申請金額,核准金額未依申請幣別做小數取位
#                                                    4.單身金額未依單身幣別做小數取位
# Modify.........: No.FUN-550037 05/05/13 By saki    欄位comment顯示
# Modify.........: No.MOD-590002 05/09/05 By vivien  查詢時欄位修改
# Modify.........: No.TQC-5B0076 05/11/09 By Claire  excel匯出失效
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-5B0129 05/12/15 By Smapmin 單身額匯為與單頭幣別之匯率
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660025 06/06/07 By Smapmin 調整資料列印位置
# Modify.........: No.MOD-590274 06/06/12 By rainy 單身合計不可大於單頭核準金額
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6A0011 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740202 07/05/10 By Carrier by 綜合(nnp04)的值來合計單身金額值是否超過單頭核准金額
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770038 07/07/13 By Carrier 報表轉Crystal Report格式
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-850038 08/05/12 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.TQC-970153 09/07/17 By Carrier l_sum1/l_sum2計算時,卻掉單身null值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-B30108 11/03/11 by Dido 若單身幣別與單頭幣別不同時,nnp08不可為空 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60086 11/06/16 By zhangweib CONSTURCT時加上資料建立者和資料建立部門
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C40191 12/07/18 By lujh 組sql發生錯誤
# Modify.........: No.MOD-C80236 12/09/21 By Elise 綜合修改為不勾選的動作，控卡anm-035的錯誤
# Modify.........: No.MOD-D30043 13/03/06 By Polly 取消額度匯率取位
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nno   RECORD LIKE nno_file.*,
    g_nno_t RECORD LIKE nno_file.*,
    g_nno_o RECORD LIKE nno_file.*,
    g_fahprt        LIKE fah_file.fahprt,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_nnp           DYNAMIC ARRAY OF RECORD               #程式變數(Prinram Variables)
                    nnp02     LIKE nnp_file.nnp02,
                    nnp03     LIKE nnp_file.nnp03,
                    nnn02     LIKE nnn_file.nnn02,
                    nnp04     LIKE nnp_file.nnp04,
                    nnp05     LIKE nnp_file.nnp05,
                    nnp06     LIKE nnp_file.nnp06,
                    nnp07     LIKE nnp_file.nnp07,
                    nnp08     LIKE nnp_file.nnp08,
                    nnp09     LIKE nnp_file.nnp09
                    #FUN-850038 --start---
                    ,nnpud01 LIKE nnp_file.nnpud01,
                    nnpud02 LIKE nnp_file.nnpud02,
                    nnpud03 LIKE nnp_file.nnpud03,
                    nnpud04 LIKE nnp_file.nnpud04,
                    nnpud05 LIKE nnp_file.nnpud05,
                    nnpud06 LIKE nnp_file.nnpud06,
                    nnpud07 LIKE nnp_file.nnpud07,
                    nnpud08 LIKE nnp_file.nnpud08,
                    nnpud09 LIKE nnp_file.nnpud09,
                    nnpud10 LIKE nnp_file.nnpud10,
                    nnpud11 LIKE nnp_file.nnpud11,
                    nnpud12 LIKE nnp_file.nnpud12,
                    nnpud13 LIKE nnp_file.nnpud13,
                    nnpud14 LIKE nnp_file.nnpud14,
                    nnpud15 LIKE nnp_file.nnpud15
                    #FUN-850038 --end--
                    END RECORD,
    g_nnp10         ARRAY[400] of LIKE type_file.num20_6, #No.FUN-680107 DECIMAL(20,6) #No.FUN-4C0010
    g_nnp_t         RECORD
                    nnp02     LIKE nnp_file.nnp02,
                    nnp03     LIKE nnp_file.nnp03,
                    nnn02     LIKE nnn_file.nnn02,
                    nnp04     LIKE nnp_file.nnp04,
                    nnp05     LIKE nnp_file.nnp05,
                    nnp06     LIKE nnp_file.nnp06,
                    nnp07     LIKE nnp_file.nnp07,
                    nnp08     LIKE nnp_file.nnp08,
                    nnp09     LIKE nnp_file.nnp09
                    #FUN-850038 --start---
                    ,nnpud01 LIKE nnp_file.nnpud01,
                    nnpud02 LIKE nnp_file.nnpud02,
                    nnpud03 LIKE nnp_file.nnpud03,
                    nnpud04 LIKE nnp_file.nnpud04,
                    nnpud05 LIKE nnp_file.nnpud05,
                    nnpud06 LIKE nnp_file.nnpud06,
                    nnpud07 LIKE nnp_file.nnpud07,
                    nnpud08 LIKE nnp_file.nnpud08,
                    nnpud09 LIKE nnp_file.nnpud09,
                    nnpud10 LIKE nnp_file.nnpud10,
                    nnpud11 LIKE nnp_file.nnpud11,
                    nnpud12 LIKE nnp_file.nnpud12,
                    nnpud13 LIKE nnp_file.nnpud13,
                    nnpud14 LIKE nnp_file.nnpud14,
                    nnpud15 LIKE nnp_file.nnpud15
                    #FUN-850038 --end--
                    END RECORD,
    g_fah   RECORD LIKE fah_file.*,
    l_azi   RECORD LIKE azi_file.*,
    c_nnp04        LIKE nnp_file.nnp04,                   #主類判繼 #No.FUN-680107 VARCHAR(1)
    g_wc,g_wc2,g_sql  STRING,                             #No.FUN-580092 HCN 
    g_cmd               LIKE type_file.chr1000,           #No.FUN-680107 VARCHAR(200)
    g_t1                LIKE oay_file.oayslip,            #No.FUN-680107 VARCHAR(5)
    g_rec_b             LIKE type_file.num5,              #單身筆數 #No.FUN-680107 SMALLINT
    l_ac                LIKE type_file.num5               #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql     STRING                            #SELECT ... FOR UPDATE SQL   
DEFINE g_before_input_done  LIKE type_file.num5           #No.FUN-680107 SMALLINT
DEFINE g_chr            LIKE type_file.chr1               #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10              #No.FUN-680107 INTEGER
DEFINE g_i              LIKE type_file.num5               #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000            #No.FUN-680107 VARCHAR(72)
DEFINE g_head1          STRING
 
DEFINE   g_row_count    LIKE type_file.num10              #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10              #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10              #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5               #No.FUN-680107 SMALLINT
DEFINE   g_str          STRING                            #No.FUN-770038
DEFINE g_argv1     LIKE nno_file.nno01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
#     DEFINEl_time LIKE type_file.chr8               #No.FUN-6A0082
DEFINE p_row,p_col      LIKE type_file.num5               #No.FUN-680107 SMALLINT
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
   LET g_forupd_sql = "SELECT * FROM nno_file WHERE nno01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i711_cl CURSOR FROM g_forupd_sql
 
   LET g_chr='4'                          #出售
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW i711_w AT p_row,p_col
     WITH FORM "anm/42f/anmi711"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i711_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i711_a()
            END IF
         OTHERWISE        
            CALL i711_q() 
      END CASE
   END IF
   #--
 
   CALL i711_menu()
   CLOSE WINDOW i711_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION i711_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                                    #清除畫面
   CALL g_nnp.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nno.* TO NULL    #No.FUN-750051
  IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" nno01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
  ELSE
   CONSTRUCT BY NAME g_wc ON nno01,nno02,nno03,nno06,nno13,nno04,nno05,nno07,
                             nno08,nno09,nnouser,nnogrup,nnomodu,nnodate,nnoacti
                             #FUN-850038   ---start---
                             ,nnoud01,nnoud02,nnoud03,nnoud04,nnoud05,
                             nnoud06,nnoud07,nnoud08,nnoud09,nnoud10,
                             nnoud11,nnoud12,nnoud13,nnoud14,nnoud15
                             #FUN-850038    ----end----
                            ,nnooriu,nnoorig   #TQC-B60086   Add
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
            WHEN INFIELD(nno02)  #查詢信貸銀行
#              CALL q_alg(5,5,g_nno.nno02) RETURNING g_nno.nno02
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_alg"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nno.nno02
#No.MOD-590002 --start
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nno02
#No.MOD-590002 --end
               NEXT FIELD nno02
            WHEN INFIELD(nno06)  #查詢幣別
#              CALL q_azi(0,0,g_nno.nno06) RETURNING g_nno.nno06
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nno.nno06
#No.MOD-590002 --start
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nno06
#No.MOD-590002 --end
               NEXT FIELD nno06
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
 
   CONSTRUCT g_wc2 ON nnp02,nnp03,nnn02,nnp04,nnp05,nnp06,nnp07,nnp08,nnp09
                      #No.FUN-850038 --start--
                      ,nnpud01,nnpud02,nnpud03,nnpud04,nnpud05,
                      nnpud06,nnpud07,nnpud08,nnpud09,nnpud10,
                      nnpud11,nnpud12,nnpud13,nnpud14,nnpud15
                      #No.FUN-850038 ---end---
                FROM s_nnp[1].nnp02, s_nnp[1].nnp03, s_nnp[1].nnn02,
                     s_nnp[1].nnp04, s_nnp[1].nnp05, s_nnp[1].nnp06,
                     s_nnp[1].nnp07, s_nnp[1].nnp08, s_nnp[1].nnp09
                     #No.FUN-850038 --start--
                     ,s_nnp[1].nnpud01,s_nnp[1].nnpud02,s_nnp[1].nnpud03,s_nnp[1].nnpud04,s_nnp[1].nnpud05,
                     s_nnp[1].nnpud06,s_nnp[1].nnpud07,s_nnp[1].nnpud08,s_nnp[1].nnpud09,s_nnp[1].nnpud10,
                     s_nnp[1].nnpud11,s_nnp[1].nnpud12,s_nnp[1].nnpud13,s_nnp[1].nnpud14,s_nnp[1].nnpud15
                     #No.FUN-850038 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON ACTION controlp
         CASE
            WHEN INFIELD(nnp03)  #查詢授信類別
#              CALL q_nnn(0,0,g_nnp[1].nnp03)
#                   RETURNING g_nnp[1].nnp03,g_nnp[1].nnn02
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nnn"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nnp[1].nnp03
#No.MOD-590002 --start
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nnp03
#No.MOD-590002 --end
               NEXT FIELD nnp03
            WHEN INFIELD(nnp07)  #查詢幣別
#              CALL q_azi(0,0,g_nnp[1].nnp07)
#                   RETURNING g_nnp[1].nnp07
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_nnp[1].nnp07
#No.MOD-590002 --start
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nnp07
#No.MOD-590002 --end
               NEXT FIELD nnp07
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
  END IF  #FUN-7C0050
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND nnouser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND nnogrup LIKE '",g_grup CLIPPED,"%'"
        #CHI-8A0001 寫ora
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND nnogrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnouser', 'nnogrup')
   #End:FUN-980030
 
 
   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      LET g_sql = "SELECT nno01 FROM nno_file",
                  " WHERE ", g_wc CLIPPED,
                  #"ORDER BY nno01"       #TQC-C40191  mark
                  " ORDER BY nno01"       #TQC-C40191  add
   ELSE                                        # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE nno01 ",
                  "  FROM nno_file, nnp_file",
                  " WHERE nno01 = nnp01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  #"ORDER BY nno01"       #TQC-C40191  mark
                  " ORDER BY nno01"       #TQC-C40191  add
   END IF
   PREPARE i711_prepare FROM g_sql
   DECLARE i711_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i711_prepare
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM nno_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT nno01) FROM nno_file,nnp_file WHERE ",
                "nnp01=nno01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i711_prcount FROM g_sql
   DECLARE i711_count CURSOR WITH HOLD FOR i711_prcount
 
END FUNCTION
 
FUNCTION i711_menu()
 
   WHILE TRUE
      CALL i711_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i711_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i711_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i711_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i711_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i711_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i711_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "memo"
            IF not cl_null(g_nno.nno01) THEN
               LET g_cmd = "anmi712 '",g_nno.nno01,"'" clipped
               CALL cl_cmdrun(g_cmd)
            END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnp),'','')
            END IF
         #No.FUN-6A0011-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nno.nno01 IS NOT NULL THEN
                 LET g_doc.column1 = "nno01"
                 LET g_doc.value1 = g_nno.nno01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0011-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i711_a()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_nnp.clear()
   INITIALIZE g_nno.* TO NULL
   INITIALIZE g_nno_t.* TO NULL
   LET g_nno_o.* = g_nno.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_nno.nno03  =g_today
      LET g_nno.nno07=0
      LET g_nno.nno08=0
      LET g_nno.nno09="N"
      LET g_nno.nnoacti="Y"
      LET g_nno.nnouser=g_user
      LET g_nno.nnooriu = g_user #FUN-980030
      LET g_nno.nnoorig = g_grup #FUN-980030
      LET g_nno.nnogrup=g_grup
      LET g_nno.nnodate=g_today
      BEGIN WORK
 
      CALL i711_i("a")                #輸入單頭
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         ROLLBACK WORK
         EXIT WHILE
      END IF
 
      IF g_nno.nno01 IS NULL THEN
         CONTINUE WHILE
      END IF
 
      IF g_nno.nno08 IS NULL THEN
         LET g_nno.nno08 = 0
      END IF
 
      INSERT INTO nno_file VALUES (g_nno.*)
      IF STATUS THEN
#        CALL cl_err(g_nno.nno01,STATUS,1)   #No.FUN-660148
         CALL cl_err3("ins","nno_file",g_nno.nno01,"",STATUS,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
 
      COMMIT WORK
      SELECT nno01 INTO g_nno.nno01 FROM nno_file
       WHERE nno01 = g_nno.nno01
 
      LET g_nno_t.* = g_nno.*
 
      LET g_rec_b = 0
 
      CALL i711_b()                      #輸入單身
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i711_u()
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nno.nno01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_nno.* FROM nno_file
    WHERE nno01 = g_nno.nno01
 
   IF g_nno.nnoacti = 'N' THEN
      CALL cl_err('','aoo-062',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nno_o.* = g_nno.*
   BEGIN WORK
 
   OPEN i711_cl USING g_nno.nno01
   IF STATUS THEN
      CALL cl_err("OPEN i711_cl:", STATUS, 1)
      CLOSE i711_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i711_cl INTO g_nno.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nno.nno01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i711_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i711_show()
 
   WHILE TRUE
      LET g_nno.nnomodu=g_user
      LET g_nno.nnodate=g_today
 
      CALL i711_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_nno.*=g_nno_t.*
         CALL i711_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE nno_file SET * = g_nno.* WHERE nno01 = g_nno_t.nno01
      IF STATUS THEN
#        CALL cl_err(g_nno.nno01,STATUS,0)   #No.FUN-660148
         CALL cl_err3("upd","nno_file",g_nno_t.nno01,"",STATUS,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i711_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i711_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1       #a:輸入 u:更改 #No.FUN-680107 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1       #判斷必要欄位是否有輸入 #No.FUN-680107 VARCHAR(1)
  DEFINE l_yy,l_mm       LIKE type_file.num5       #No.FUN-680107 SMALLINT
  DEFINE l_nnp09         LIKE nnp_file.nnp09
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_nno.nno01,g_nno.nno02,g_nno.nno03,g_nno.nno06,g_nno.nno13, g_nno.nnooriu,g_nno.nnoorig,
                 g_nno.nno04,g_nno.nno05,g_nno.nno07,g_nno.nno08,g_nno.nno09,
                 g_nno.nnouser,g_nno.nnogrup,g_nno.nnomodu,g_nno.nnodate,g_nno.nnoacti
                 #FUN-850038     ---start---
                 ,g_nno.nnoud01,g_nno.nnoud02,g_nno.nnoud03,g_nno.nnoud04,
                 g_nno.nnoud05,g_nno.nnoud06,g_nno.nnoud07,g_nno.nnoud08,
                 g_nno.nnoud09,g_nno.nnoud10,g_nno.nnoud11,g_nno.nnoud12,
                 g_nno.nnoud13,g_nno.nnoud14,g_nno.nnoud15 
                 #FUN-850038     ----end----
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i711_set_entry(p_cmd)
         CALL i711_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD nno01  #合約號碼
         IF NOT cl_null(g_nno.nno01) THEN
             IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_nno.nno01 != g_nno_t.nno01) THEN
                LET g_cnt=0
                SELECT COUNT(*) INTO g_cnt FROM nno_file WHERE nno01=g_nno.nno01
                IF g_cnt > 0 THEN   #資料重複
                   CALL cl_err(g_nno.nno01,-239,0)
                   LET g_nno.nno01 = g_nno_t.nno01
                   DISPLAY BY NAME g_nno.nno01
                   NEXT FIELD nno01
                END IF
                LET g_nno_o.nno01 = g_nno.nno01
             END IF
         END IF
 
      AFTER FIELD nno02  #信貸銀行
         IF NOT cl_null(g_nno.nno02) THEN
            CALL i711_nno02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nno.nno02,g_errno,0)
               LET g_nno.nno02 = g_nno_o.nno02
               DISPLAY BY NAME g_nno.nno02
               NEXT FIELD nno02
            END IF
         END IF
 
      AFTER FIELD nno04  #核准日期
         IF NOT cl_null(g_nno.nno04) THEN
            IF g_nno.nno04 < g_nno.nno03 THEN  #核淮日期不可小於申請日期
               CALL cl_err(g_nno.nno04,'anm-600',0)
               LET g_nno.nno04 = g_nno_t.nno04
               NEXT FIELD nno04
            END IF
         END IF
 
      AFTER FIELD nno05  #有效日期
         IF NOT cl_null(g_nno.nno05) THEN
            IF g_nno.nno05 < g_nno.nno03 THEN  #有效日期不可小於申請日期
               CALL cl_err(g_nno.nno05,'anm-600',0)
               LET g_nno.nno05 = g_nno_t.nno05
               NEXT FIELD nno05
            END IF
         END IF
 
      AFTER FIELD nno06  #申請幣別
         IF NOT cl_null(g_nno.nno06) THEN
             SELECT azi04 INTO t_azi04 FROM azi_file    #MOD-530816
              WHERE azi01 = g_nno.nno06   #MOD-530816
            SELECT * INTO l_azi.* FROM azi_file                
             WHERE azi01=g_nno.nno06
               AND aziacti = 'Y'
            IF STATUS THEN
#              CALL cl_err(g_nno.nno06,'axr-144',0)   #No.FUN-660148
               CALL cl_err3("sel","azi_file",g_nno.nno06,"","axr-144","","",1)  #No.FUN-660148
               NEXT FIELD nno06
            END IF
         END IF
 
      AFTER FIELD nno07  #申請金額
         IF NOT cl_null(g_nno.nno07) THEN
            IF g_nno.nno07 < 0 THEN
               CALL cl_err(g_nno.nno07,'agl-006',0)
               NEXT FIELD nno07
            END IF
             LET g_nno.nno07 = cl_digcut(g_nno.nno07,t_azi04)   #MOD-530816
             DISPLAY BY NAME g_nno.nno07   #MOD-530816
         END IF
 
      AFTER FIELD nno08  #核淮金額
         IF NOT cl_null(g_nno.nno08) THEN
            IF g_nno.nno08 < 0 THEN
               CALL cl_err(g_nno.nno08,'agl-006',0)
               NEXT FIELD nno08
            END IF
             LET g_nno.nno08 = cl_digcut(g_nno.nno08,t_azi04)   #MOD-530816
             DISPLAY BY NAME g_nno.nno08   #MOD-530816
         END IF
 
      AFTER FIELD nno09  #暫停
         IF g_nno.nno09 NOT MATCHES '[YN]' THEN
            NEXT FIELD nno09
         END IF
 
      #FUN-850038     ---start---
      AFTER FIELD nnoud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnoud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-850038     ----end----
 
      AFTER INPUT
         LET g_nno.nnouser = s_get_data_owner("nno_file") #FUN-C10039
         LET g_nno.nnogrup = s_get_data_group("nno_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(nno02)  #查詢信貸銀行
#              CALL q_alg(5,5,g_nno.nno02) RETURNING g_nno.nno02
#              CALL FGL_DIALOG_SETBUFFER( g_nno.nno02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_alg"
               LET g_qryparam.default1 = g_nno.nno02
               CALL cl_create_qry() RETURNING g_nno.nno02
#               CALL FGL_DIALOG_SETBUFFER( g_nno.nno02 )
               DISPLAY BY NAME g_nno.nno02
               NEXT FIELD nno02
            WHEN INFIELD(nno06)  #查詢幣別
#              CALL q_azi(0,0,g_nno.nno06) RETURNING g_nno.nno06
#              CALL FGL_DIALOG_SETBUFFER( g_nno.nno06 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nno.nno06
               CALL cl_create_qry() RETURNING g_nno.nno06
#               CALL FGL_DIALOG_SETBUFFER( g_nno.nno06 )
               DISPLAY BY NAME g_nno.nno06
               NEXT FIELD nno06
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
      #ON ACTION CONTROLO                        # 沿用所有欄位
      #   IF INFIELD(nno01) THEN
      #      LET g_nno.* = g_nno_t.*
      #      CALL i711_show()
      #      NEXT FIELD nno01
      #   END IF
        #MOD-650015 --end
 
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
 
FUNCTION i711_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nno.* TO NULL               #No.FUN-6A0011
 
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i711_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_nno.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
 
   OPEN i711_cs                               # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_nno.* TO NULL
   ELSE
      OPEN i711_count
      FETCH i711_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i711_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ""
 
END FUNCTION
 
FUNCTION i711_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,     #處理方式   #No.FUN-680107 VARCHAR(1)
   l_abso          LIKE type_file.num10     #絕對的筆數 #No.FUN-680107 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i711_cs INTO g_nno.nno01
      WHEN 'P' FETCH PREVIOUS i711_cs INTO g_nno.nno01
      WHEN 'F' FETCH FIRST    i711_cs INTO g_nno.nno01
      WHEN 'L' FETCH LAST     i711_cs INTO g_nno.nno01
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
            FETCH ABSOLUTE g_jump i711_cs INTO g_nno.nno01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nno.nno01,SQLCA.sqlcode,0)
      INITIALIZE g_nno.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_nno.* FROM nno_file WHERE nno01 = g_nno.nno01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_nno.nno01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("sel","nno_file",g_nno.nno01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
      INITIALIZE g_nno.* TO NULL
      RETURN
   ELSE
       LET g_data_owner = g_nno.nnouser     #No.FUN-4C0063
       LET g_data_group = g_nno.nnogrup     #No.FUN-4C0063
      CALL i711_show()
   END IF
 
 
END FUNCTION
 
FUNCTION i711_show()
 
   LET g_nno_t.* = g_nno.*                #保存單頭舊值
 
   DISPLAY BY NAME g_nno.nno01,g_nno.nno02,g_nno.nno03,g_nno.nno04,g_nno.nno05, g_nno.nnooriu,g_nno.nnoorig,
                   g_nno.nno09,g_nno.nno06,g_nno.nno07,g_nno.nno08,g_nno.nno13,
                   g_nno.nnouser,g_nno.nnogrup,g_nno.nnomodu,g_nno.nnodate,g_nno.nnoacti
                   #FUN-850038     ---start---
                   ,g_nno.nnoud01,g_nno.nnoud02,g_nno.nnoud03,g_nno.nnoud04,
                   g_nno.nnoud05,g_nno.nnoud06,g_nno.nnoud07,g_nno.nnoud08,
                   g_nno.nnoud09,g_nno.nnoud10,g_nno.nnoud11,g_nno.nnoud12,
                   g_nno.nnoud13,g_nno.nnoud14,g_nno.nnoud15 
                   #FUN-850038     ----end----
 
   CALL i711_nno02('d')
 
   DISPLAY BY NAME g_nno.nno08
 
   CALL i711_b_fill(g_wc2)                    #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i711_nno02(p_cmd)                    #信貸銀行檔
   DEFINE p_cmd     LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
          l_alg021  LIKE alg_file.alg021
 
   LET g_errno = ' '
   SELECT alg021 INTO l_alg021 FROM alg_file WHERE alg01=g_nno.nno02
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-722'
                                  LET l_alg021 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_alg021 TO FORMONLY.alg021
   END IF
 
END FUNCTION
 
FUNCTION i711_r()
   DEFINE l_chr,l_sure LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE l_cnt        LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_count      LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nno.nno01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
 #MOD-530816
   SELECT COUNT(*) INTO l_count FROM ala_file
          WHERE ala33 = g_nno.nno01 AND alafirm ='Y'
   IF l_count > 0 THEN
      CALL cl_err('','axr-913',1)
      RETURN
   END IF
 #END MOD-530816
 
   SELECT * INTO g_nno.* FROM nno_file WHERE nno01 = g_nno.nno01
 
   IF g_nno.nno09   = 'Y' THEN
      CALL cl_err('','aoo-105',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM nne_file WHERE nne30=g_nno.nno01
 
   IF l_cnt > 0 THEN
      CALL cl_err(g_nno.nno01,'anm-633',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i711_cl USING g_nno.nno01
   IF STATUS THEN
      CALL cl_err("OPEN i711_cl:", STATUS, 1)
      CLOSE i711_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i711_cl INTO g_nno.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nno.nno01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i711_show()
 
   IF cl_delh(20,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nno01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nno.nno01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      MESSAGE "Delete nno_file,nnp_file,nnq_file!"
      DELETE FROM nno_file WHERE nno01 = g_nno.nno01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del nno',STATUS,1)   #No.FUN-660148
         CALL cl_err3("del","nno_file",g_nno.nno01,"",STATUS,"","del nno",1)  #No.FUN-660148
         ROLLBACK WORK
         RETURN
      END IF
 
      DELETE FROM nnp_file WHERE nnp01 = g_nno.nno01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('del nnp',STATUS,1)   #No.FUN-660148
         CALL cl_err3("del","nnp_file",g_nno.nno01,"",STATUS,"","del nnp",1)  #No.FUN-660148
         ROLLBACK WORK
         RETURN
      END IF
 
      DELETE FROM nnq_file WHERE nnq01 = g_nnq.nnq01
 
      LET g_msg=TIME
      CLEAR FORM
      CALL g_nnp.clear()
      INITIALIZE g_nno.* TO NULL
      MESSAGE ""
      OPEN i711_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i711_cs
         CLOSE i711_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i711_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i711_cs
         CLOSE i711_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i711_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i711_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i711_fetch('/')
      END IF
   END IF
 
   CLOSE i711_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i711_b()
DEFINE
   l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
   l_row,l_col     LIKE type_file.num5,          #分段輸入之行,列數 #No.FUN-680107 SMALLINT
   l_n,l_cnt       LIKE type_file.num5,          #檢查重複用        #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,          #處理狀態          #No.FUN-680107 VARCHAR(1)
   l_edate         LIKE type_file.dat,           #No.FUN-680107     DATE
   l_nnp09         LIKE nnp_file.nnp09,
   l_flag          LIKE type_file.num10,         #No.FUN-680107     INTGER
   l_allow_insert  LIKE type_file.num5,          #可新增否          #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5,          #可刪除否          #No.FUN-680107 SMALLINT
   l_count         LIKE type_file.num10,         #No.FUN-680107     INTEGER
   l_rate1,l_rate2 LIKE nnp_file.nnp08,          #MOD-5B0129
   l_sum           LIKE nno_file.nno08,          #MOD-590274
   l_sum1          LIKE nno_file.nno08,          #FUN-740202
   l_act           LIKE type_file.chr1           #No.FUN-680107     VARCHAR(1)             #MOD-590274
 
   LET g_action_choice = ""
   LET l_act = ""                           #MOD-590274
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nno.nno01 IS NULL THEN
      RETURN
   END IF
 
   IF g_nno.nnoacti = 'N' THEN
      CALL cl_err('','aoo-062',0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT nnp02,nnp03,'',nnp04,nnp05,nnp06,nnp07,",
                      "       nnp08,nnp09 FROM nnp_file",
                      " WHERE nnp01=? AND nnp02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i711_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nnp WITHOUT DEFAULTS FROM s_nnp.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
       IF g_rec_b!=0 THEN
         CALL fgl_set_arr_curr(l_ac)
       END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
        #LET g_nnp_t.* = g_nnp[l_ac].*  #BACKUP
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
 
         BEGIN WORK
 
         OPEN i711_cl USING g_nno.nno01
         IF STATUS THEN
            CALL cl_err("OPEN i711_cl:", STATUS, 1)
            CLOSE i711_cl
            ROLLBACK WORK
            RETURN
         END IF
 
         FETCH i711_cl INTO g_nno.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_nno.nno01,SQLCA.sqlcode,0)
            ROLLBACK WORK
            RETURN
         END IF
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nnp_t.* = g_nnp[l_ac].*  #BACKUP
            OPEN i711_bcl USING g_nno.nno01,g_nnp_t.nnp02
            IF STATUS THEN
               CALL cl_err("OPEN i711_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i711_bcl INTO g_nnp[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock nnp',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT nnn02 INTO g_nnp[l_ac].nnn02 FROM nnn_file
                   WHERE nnn01 = g_nnp[l_ac].nnp03 AND nnnacti='Y'
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_act = "i"                   #MOD-590274
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nnp[l_ac].* TO NULL
         SELECT COUNT(*) INTO g_cnt FROM nnp_file
          WHERE nnp01=g_nno.nno01 AND nnp04='Y'
         IF g_cnt >0 THEN
            LET g_nnp[l_ac].nnp04='N'
         ELSE
            LET g_nnp[l_ac].nnp04='Y'
         END IF
         LET g_nnp[l_ac].nnp07=g_nno.nno06
         LET g_nnp[l_ac].nnp05=0
         LET g_nnp[l_ac].nnp06=0
         LET g_nnp[l_ac].nnp08=1
         LET g_nnp_t.*=g_nnp[l_ac].*
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD nnp02                  #跳下一ROW
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
          # CALL g_nnp.deleteElement(l_ac)   #取消 Array Element
          # IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
          #    LET g_action_choice = "detail"
          #    LET l_ac = l_ac_t
          # END IF
          # EXIT INPUT
         END IF
         
         INSERT INTO nnp_file (nnp01,nnp02,nnp03,nnp04,nnp05,nnp06,  #No:BUG-470041 #MOD-470576
                               nnp07,nnp08,nnp09,nnp10,nnp11,nnp12,nnp13
                               #No.FUN-850038 --start--
                               ,nnpud01,nnpud02,nnpud03,nnpud04,nnpud05,
                               nnpud06,nnpud07,nnpud08,nnpud09,nnpud10,
                               nnpud11,nnpud12,nnpud13,nnpud14,nnpud15)
                               #No.FUN-850038 ---end---
              VALUES(g_nno.nno01,g_nnp[l_ac].nnp02,g_nnp[l_ac].nnp03,
                     g_nnp[l_ac].nnp04,g_nnp[l_ac].nnp05,g_nnp[l_ac].nnp06,
                     g_nnp[l_ac].nnp07,g_nnp[l_ac].nnp08,g_nnp[l_ac].nnp09,
                     '','','',''
                     #No.FUN-850038 --start--
                     ,g_nnp[l_ac].nnpud01,g_nnp[l_ac].nnpud02,g_nnp[l_ac].nnpud03,
                     g_nnp[l_ac].nnpud04,g_nnp[l_ac].nnpud05,g_nnp[l_ac].nnpud06,
                     g_nnp[l_ac].nnpud07,g_nnp[l_ac].nnpud08,g_nnp[l_ac].nnpud09,
                     g_nnp[l_ac].nnpud10,g_nnp[l_ac].nnpud11,g_nnp[l_ac].nnpud12,
                     g_nnp[l_ac].nnpud13,g_nnp[l_ac].nnpud14,g_nnp[l_ac].nnpud15)
                     #No.FUN-850038 ---end---
         IF SQLCA.sqlcode THEN
#           CALL cl_err('ins nnp',SQLCA.sqlcode,0)   #No.FUN-660148
            CALL cl_err3("ins","nnp_file",g_nno.nno01,"",SQLCA.sqlcode,"","ins nnp",1)  #No.FUN-660148
           #LET g_nnp[l_ac].* = g_nnp_t.*
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
         LET l_act = ""  #MOD-590274
 
      BEFORE FIELD nnp02                            #default 序號
         IF g_nnp[l_ac].nnp02 IS NULL OR g_nnp[l_ac].nnp02 = 0 THEN
            SELECT max(nnp02)+1 INTO g_nnp[l_ac].nnp02
              FROM nnp_file WHERE nnp01 = g_nno.nno01
            IF g_nnp[l_ac].nnp02 IS NULL THEN
               LET g_nnp[l_ac].nnp02 = 1
            END IF
         END IF
 
      AFTER FIELD nnp02                        #check 序號是否重複
         IF NOT cl_null(g_nnp[l_ac].nnp02) THEN
            IF g_nnp[l_ac].nnp02 != g_nnp_t.nnp02 OR g_nnp_t.nnp02 IS NULL THEN
               SELECT count(*) INTO l_n FROM nnp_file
                WHERE nnp01 = g_nno.nno01 AND nnp02 = g_nnp[l_ac].nnp02
               IF l_n > 0 THEN
                  LET g_nnp[l_ac].nnp02 = g_nnp_t.nnp02
                  CALL cl_err('',-239,0)
                  NEXT FIELD nnp02
               END IF
            END IF
         END IF
 
      AFTER FIELD nnp03   #授信類別
 #MOD-530816
         SELECT COUNT(alafirm) INTO l_count FROM ala_file
                WHERE ala33 = g_nno.nno01 AND alafirm ='Y'
                  AND ala35 = g_nnp_t.nnp03
         IF l_count > 0 THEN
            CALL cl_err(g_nnp_t.nnp03,'anm-063',1)
            LET g_nnp[l_ac].nnp03 = g_nnp_t.nnp03
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_nnp[l_ac].nnp03
            #------MOD-5A0095 END------------
            EXIT INPUT
         END IF
         IF g_nnp[l_ac].nnp03 <> g_nnp_t.nnp03 OR g_nnp_t.nnp03 IS NULL THEN
            SELECT count(*) INTO l_count FROM nnp_file
                WHERE nnp01 = g_nno.nno01
                  AND nnp03 = g_nnp[l_ac].nnp03
            IF l_count > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD nnp03
            END IF
         END IF
 #END MOD-530816
         IF NOT cl_null(g_nnp[l_ac].nnp03) THEN
            SELECT count(*) INTO l_n FROM nnp_file
             WHERE nnp01 = g_nno.nno01
               AND nnp02 != g_nnp_t.nnp02
               AND nnp03 = g_nnp[l_ac].nnp03
            IF l_n > 0 THEN
               LET g_nnp[l_ac].nnp03 = g_nnp_t.nnp03
               CALL cl_err('',-239,0)
               NEXT FIELD nnp03
            END IF
            SELECT nnn02 INTO g_nnp[l_ac].nnn02 FROM nnn_file #類別名稱
             WHERE nnn01=g_nnp[l_ac].nnp03 AND nnnacti='Y'
            IF STATUS THEN
#              CALL cl_err(g_nnp[l_ac].nnp03,'anm-601',0)   #No.FUN-660148
               CALL cl_err3("sel","nnn_file",g_nnp[l_ac].nnp03,"","anm-601","","",1)  #No.FUN-660148
               LET g_nnp[l_ac].nnp03 = g_nnp_t.nnp03
               LET g_nnp[l_ac].nnn02 = g_nnp_t.nnn02
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_nnp[l_ac].nnp03
               DISPLAY BY NAME g_nnp[l_ac].nnn02
               #------MOD-5A0095 END------------
               NEXT FIELD nnp03
            END IF
            #------MOD-5A0095 START----------
            DISPLAY BY NAME g_nnp[l_ac].nnn02
            #------MOD-5A0095 END------------
         END IF
 
      AFTER FIELD nnp04   #綜合
         IF NOT cl_null(g_nnp[l_ac].nnp04) THEN
            IF g_nnp[l_ac].nnp04 NOT matches '[YN]' THEN
               NEXT FIELD nnp04
            END IF
            IF g_nnp[l_ac].nnp04='Y' THEN
               SELECT COUNT(*) INTO g_cnt FROM nnp_file
                WHERE nnp01=g_nno.nno01 AND nnp02!=g_nnp[l_ac].nnp02
                  AND nnp04='Y'
               IF g_cnt >0 THEN
                  CALL cl_err(g_nnp[l_ac].nnp04,'anm-604',0)
                  NEXT FIELD nnp04
               END IF
               IF g_nnp_t.nnp07 IS NULL THEN
                  LET g_nnp[l_ac].nnp07=g_nno.nno06
               END IF
               IF g_nnp_t.nnp09 IS NULL THEN
                  LET g_nnp[l_ac].nnp09=g_nno.nno08
               END IF
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_nnp[l_ac].nnp07
               DISPLAY BY NAME g_nnp[l_ac].nnp09
               #------MOD-5A0095 END------------
           #MOD-C80236---S---
            ELSE
               IF g_nnp[l_ac].nnp09 > 0 THEN
                  LET l_sum = 0
                  LET l_sum1= 0
                  IF l_act = "i" THEN
                     FOR l_cnt = 1 TO g_rec_b + 1
                         IF cl_null(g_nnp[l_cnt].nnp09) OR cl_null(g_nnp[l_cnt].nnp08) THEN
                            CONTINUE FOR
                         END IF
                         IF g_nnp[l_cnt].nnp04 = 'Y' THEN
                            LET l_sum = l_sum + (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                         ELSE
                            LET l_sum1= l_sum1+ (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                         END IF
                     END FOR
                  ELSE
                     FOR l_cnt = 1 TO g_rec_b
                         IF cl_null(g_nnp[l_cnt].nnp09) OR cl_null(g_nnp[l_cnt].nnp08) THEN
                            CONTINUE FOR
                         END IF
                         IF g_nnp[l_cnt].nnp04 = 'Y' THEN
                            LET l_sum = l_sum + (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                         ELSE
                            LET l_sum1= l_sum1+ (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                         END IF
                     END FOR
                  END IF
                  IF l_sum > g_nno.nno08 OR l_sum1 > g_nno.nno08 THEN
                     CALL cl_err('','anm-035',1)
                     NEXT FIELD nnp04
                  END IF
               END IF
           #MOD-C80236---E---
            END IF
         END IF
 
      AFTER FIELD nnp05   #利率
         IF NOT cl_null(g_nnp[l_ac].nnp05) THEN
            IF g_nnp[l_ac].nnp05 <0 THEN
               NEXT FIELD nnp05
            END IF
         END IF
 
      AFTER FIELD nnp06   #費率
         IF NOT cl_null(g_nnp[l_ac].nnp06) THEN
            IF g_nnp[l_ac].nnp06 <0 THEN
               NEXT FIELD nnp06
            END IF
         END IF
 
      AFTER FIELD nnp07   #幣別
         IF NOT cl_null(g_nnp[l_ac].nnp07) THEN
             SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file    #MOD-530816
              WHERE azi01 = g_nnp[l_ac].nnp07   #MOD-530816
            IF g_nnp[l_ac].nnp04='Y' AND g_nnp[l_ac].nnp07!=g_nno.nno06 THEN
               CALL cl_err(g_nnp[l_ac].nnp07,'aap-020',0)
               NEXT FIELD nnp07
            END IF
            SELECT COUNT(*) INTO g_cnt FROM azi_file     #幣別檔
             WHERE azi01=g_nnp[l_ac].nnp07 AND aziacti='Y'
            IF g_cnt=0 THEN
               CALL cl_err(g_nnp[l_ac].nnp07,'mfg3008',0)
               NEXT FIELD nnp07
            END IF                    #aza17:本國幣別
         END IF
 
#MOD-5B0129
     BEFORE FIELD nnp08
        CALL s_curr3(g_nno.nno06,g_nno.nno03,'B') RETURNING l_rate1
        CALL s_curr3(g_nnp[l_ac].nnp07,g_nno.nno03,'B') RETURNING l_rate2
        LET g_nnp[l_ac].nnp08 = l_rate2/l_rate1
       #LET g_nnp[l_ac].nnp08 = cl_digcut(g_nnp[l_ac].nnp08,t_azi07)         #MOD-D30043 mark
        DISPLAY BY NAME g_nnp[l_ac].nnp08
#END MOD-5B0129
 
      
 
      AFTER FIELD nnp08   #匯率
         IF NOT cl_null(g_nnp[l_ac].nnp08) THEN
            IF g_nnp[l_ac].nnp08 <0 THEN
               NEXT FIELD nnp08
            END IF
 #MOD-530816
            IF (g_nnp[l_ac].nnp09*g_nnp[l_ac].nnp08)>g_nno.nno08 THEN
                CALL cl_err('','anm-015',1)
               #LET g_nnp[l_ac].nnp08 = cl_digcut(g_nnp[l_ac].nnp08,t_azi07)    #MOD-D30043 mark
                DISPLAY BY NAME g_nnp[l_ac].nnp08
                NEXT FIELD nnp09
            END IF
           #LET g_nnp[l_ac].nnp08 = cl_digcut(g_nnp[l_ac].nnp08,t_azi07)        #MOD-D30043 mark
            DISPLAY BY NAME g_nnp[l_ac].nnp08
 #END MOD-530816
 
            #MOD-590274 add --start
            LET l_sum = 0
            LET l_sum1= 0   #No.FUN-740202
            IF l_act = "i" THEN
               FOR l_cnt = 1 TO g_rec_b + 1
                   #No.TQC-970153  --Begin
                   IF cl_null(g_nnp[l_cnt].nnp09) OR cl_null(g_nnp[l_cnt].nnp08) THEN
                      CONTINUE FOR
                   END IF
                   #No.TQC-970153  --End  
                   #No.FUN-740202  --Begin
                   IF g_nnp[l_cnt].nnp04 = 'Y' THEN
                      LET l_sum = l_sum + (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                   ELSE
                      LET l_sum1= l_sum1+ (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                   END IF
                   #No.FUN-740202  --End  
               END FOR
            ELSE
               FOR l_cnt = 1 TO g_rec_b
                   #No.TQC-970153  --Begin
                   IF cl_null(g_nnp[l_cnt].nnp09) OR cl_null(g_nnp[l_cnt].nnp08) THEN
                      CONTINUE FOR
                   END IF
                   #No.TQC-970153  --End  
                   #No.FUN-740202  --Begin
                   IF g_nnp[l_cnt].nnp04 = 'Y' THEN
                      LET l_sum = l_sum + (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                   ELSE
                      LET l_sum1= l_sum1+ (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                   END IF
                   #No.FUN-740202  --End  
               END FOR
            END IF
            IF l_sum > g_nno.nno08 OR l_sum1 > g_nno.nno08 THEN  #No.FUN-740202
               CALL cl_err('','anm-035',1)
               NEXT FIELD nnp09
            END IF
            #MOD-590274 add--end
       #-MOD-B30108-add-
        ELSE
            IF g_nno.nno06 <> g_nnp[l_ac].nnp07 THEN 
               CALL cl_err('','anm-067',1)
               LET g_nnp[l_ac].nnp08 = g_nnp_t.nnp08 
               DISPLAY BY NAME g_nnp[l_ac].nnp08
               NEXT FIELD nnp08
            END IF
       #-MOD-B30108-end-
        END IF
 
      AFTER FIELD nnp09   #授信額度
         IF NOT cl_null(g_nnp[l_ac].nnp09) THEN
            IF g_nnp[l_ac].nnp09 <0 THEN
               NEXT FIELD nnp09
            #No:8686
            ELSE
              IF (g_nnp[l_ac].nnp09*g_nnp[l_ac].nnp08)>g_nno.nno08 THEN
                 CALL cl_err('','anm-015',1)
                  LET g_nnp[l_ac].nnp09 = cl_digcut(g_nnp[l_ac].nnp09,t_azi04)   #MOD-530816
                  DISPLAY BY NAME g_nnp[l_ac].nnp09   #MOD-530816
                  NEXT FIELD nnp08  #MOD-530816
              END IF
            #No:8686 end
                #MOD-590274 add --start
                LET l_sum = 0
                LET l_sum1= 0   #No.FUN-740202
                IF l_act = "i" THEN
                   FOR l_cnt = 1 TO g_rec_b + 1
                       #No.TQC-970153  --Begin
                       IF cl_null(g_nnp[l_cnt].nnp09) OR cl_null(g_nnp[l_cnt].nnp08) THEN
                          CONTINUE FOR
                       END IF
                       #No.TQC-970153  --End  
                       #No.FUN-740202  --Begin
                       IF g_nnp[l_cnt].nnp04 = 'Y' THEN
                          LET l_sum = l_sum + (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                       ELSE
                          LET l_sum1= l_sum1+ (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                       END IF
                       #No.FUN-740202  --End  
                   END FOR
                ELSE
                   FOR l_cnt = 1 TO g_rec_b
                       #No.TQC-970153  --Begin
                       IF cl_null(g_nnp[l_cnt].nnp09) OR cl_null(g_nnp[l_cnt].nnp08) THEN
                          CONTINUE FOR
                       END IF
                       #No.TQC-970153  --End  
                       #No.FUN-740202  --Begin
                       IF g_nnp[l_cnt].nnp04 = 'Y' THEN
                          LET l_sum = l_sum + (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                       ELSE
                          LET l_sum1= l_sum1+ (g_nnp[l_cnt].nnp09*g_nnp[l_cnt].nnp08)
                       END IF
                       #No.FUN-740202  --End  
                   END FOR
                END IF
                IF l_sum > g_nno.nno08 OR l_sum1 > g_nno.nno08 THEN  #No.FUN-740202
                   CALL cl_err('','anm-035',1)
                   NEXT FIELD nnp09
                END IF
                #MOD-590274 add--end
            END IF
 
 
             LET g_nnp[l_ac].nnp09 = cl_digcut(g_nnp[l_ac].nnp09,t_azi04)   #MOD-530816
             DISPLAY BY NAME g_nnp[l_ac].nnp09   #MOD-530816
         END IF
     
      #No.FUN-850038 --start--
      AFTER FIELD nnpud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD nnpud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #No.FUN-850038 ---end---
 
      BEFORE DELETE       #是否取消單身
 #MOD-530816
         SELECT COUNT(alafirm) INTO l_count FROM ala_file
                WHERE ala33 = g_nno.nno01 AND alafirm ='Y'
                  AND ala35 = g_nnp_t.nnp03
         IF l_count > 0 THEN
            CALL cl_err(g_nnp_t.nnp03,'anm-063',1)
            CANCEL DELETE
         END IF
 #END MOD-530816
         IF g_nnp_t.nnp02 > 0 AND g_nnp_t.nnp02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nnp_file
             WHERE nnp01 = g_nno.nno01 AND nnp02 = g_nnp_t.nnp02
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_nnp_t.nnp02,SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("del","nnp_file",g_nno.nno01,g_nnp_t.nnp02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM nnq_file
             WHERE nnq01 = g_nno.nno01 AND nnq02 = g_nnp_t.nnp02
            COMMIT WORK
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_nnp[l_ac].* = g_nnp_t.*
            CLOSE i711_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nnp[l_ac].nnp02,-263,1)
            LET g_nnp[l_ac].* = g_nnp_t.*
         ELSE
            UPDATE nnp_file SET nnp02 = g_nnp[l_ac].nnp02,
                                nnp03 = g_nnp[l_ac].nnp03,
                                nnp04 = g_nnp[l_ac].nnp04,
                                nnp05 = g_nnp[l_ac].nnp05,
                                nnp06 = g_nnp[l_ac].nnp06,
                                nnp07 = g_nnp[l_ac].nnp07,
                                nnp08 = g_nnp[l_ac].nnp08,
                                nnp09 = g_nnp[l_ac].nnp09
                                #No.FUN-850038 --start--
                                ,nnpud01 = g_nnp[l_ac].nnpud01,
                                nnpud02 = g_nnp[l_ac].nnpud02,
                                nnpud03 = g_nnp[l_ac].nnpud03,
                                nnpud04 = g_nnp[l_ac].nnpud04,
                                nnpud05 = g_nnp[l_ac].nnpud05,
                                nnpud06 = g_nnp[l_ac].nnpud06,
                                nnpud07 = g_nnp[l_ac].nnpud07,
                                nnpud08 = g_nnp[l_ac].nnpud08,
                                nnpud09 = g_nnp[l_ac].nnpud09,
                                nnpud10 = g_nnp[l_ac].nnpud10,
                                nnpud11 = g_nnp[l_ac].nnpud11,
                                nnpud12 = g_nnp[l_ac].nnpud12,
                                nnpud13 = g_nnp[l_ac].nnpud13,
                                nnpud14 = g_nnp[l_ac].nnpud14,
                                nnpud15 = g_nnp[l_ac].nnpud15
                                #No.FUN-850038 ---end---
              WHERE nnp01=g_nno.nno01
                AND nnp02=g_nnp_t.nnp02
            IF SQLCA.sqlcode THEN
#              CALL cl_err('upd nnp',SQLCA.sqlcode,0)   #No.FUN-660148
               CALL cl_err3("upd","nnp_file",g_nno.nno01,g_nnp_t.nnp02,SQLCA.sqlcode,"","upd nnp",1)  #No.FUN-660148
               LET g_nnp[l_ac].* = g_nnp_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac      #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nnp[l_ac].* = g_nnp_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_nnp.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i711_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac      #FUN-D30032 Add
        #LET g_nnp_t.* = g_nnp[l_ac].*
         CLOSE i711_bcl
         COMMIT WORK
 
#     ON ACTION CONTROLN
#        CALL i711_b_askkey()
#        EXIT INPUT
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(nnp02) AND l_ac > 1 THEN
            LET g_nnp[l_ac].* = g_nnp[l_ac-1].*
            LET g_nnp[l_ac].nnp02 = NULL
            NEXT FIELD nnp02
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(nnp03)  #查詢授信類別
#              CALL q_nnn(0,0,g_nnp[l_ac].nnp03)
#                   RETURNING g_nnp[l_ac].nnp03,g_nnp[l_ac].nnn02
#              CALL FGL_DIALOG_SETBUFFER( g_nnp[l_ac].nnp03 )
#              CALL FGL_DIALOG_SETBUFFER( g_nnp[l_ac].nnn02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nnn"
               LET g_qryparam.default1 = g_nnp[l_ac].nnp03
               CALL cl_create_qry() RETURNING g_nnp[l_ac].nnp03,g_nnp[l_ac].nnn02
#               CALL FGL_DIALOG_SETBUFFER( g_nnp[l_ac].nnp03 )
#               CALL FGL_DIALOG_SETBUFFER( g_nnp[l_ac].nnn02 )
                DISPLAY g_nnp[l_ac].nnp03 TO nnp03            #No.MOD-490344
                DISPLAY g_nnp[l_ac].nnn02 TO nnn02            #No.MOD-490344
               NEXT FIELD nnp03
            WHEN INFIELD(nnp07)  #查詢幣別
#              CALL q_azi(0,0,g_nnp[l_ac].nnp07)
#                   RETURNING g_nnp[l_ac].nnp07
#              CALL FGL_DIALOG_SETBUFFER( g_nnp[l_ac].nnp07 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nnp[l_ac].nnp07
               CALL cl_create_qry() RETURNING g_nnp[l_ac].nnp07
#               CALL FGL_DIALOG_SETBUFFER( g_nnp[l_ac].nnp07 )
                DISPLAY g_nnp[l_ac].nnp07 TO nnp07            #No.MOD-490344
               NEXT FIELD nnp07
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
   END INPUT
 
  #start FUN-5A0029
   LET g_nno.nnomodu = g_user
   LET g_nno.nnodate = g_today
   UPDATE nno_file SET nnomodu = g_nno.nnomodu,nnodate = g_nno.nnodate
    WHERE nno01 = g_nno.nno01
   DISPLAY BY NAME g_nno.nnomodu,g_nno.nnodate
  #end FUN-5A0029
 
   CLOSE i711_bcl
   COMMIT WORK
 
#  CALL i711_delall()        #CHI-C30002 mark
   CALL i711_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i711_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM nno_file WHERE nno01 = g_nno.nno01
         INITIALIZE g_nno.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i711_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM nnp_file
#   WHERE nnp01=g_nno.nno01
#
#  IF g_cnt = 0 THEN                         # 未輸入單身資料, 則取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM nno_file WHERE nno01 = g_nno.nno01
#     CLEAR FORM
#     CALL g_nnp.clear()
#     INITIALIZE g_nno.* TO NULL
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i711_b_askkey()
DEFINE l_wc2  LIKE type_file.chr1000#No.FUN-680107 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON nnp02,nnp03,nnn02,nnp04,nnp05,nnp06,nnp07,nnp08,nnp09
                  FROM s_nnp[1].nnp02,s_nnp[1].nnp03,s_nnp[1].nnn02,
                       s_nnp[1].nnp04,s_nnp[1].nnp05,s_nnp[1].nnp06,
                       s_nnp[1].nnp07,s_nnp[1].nnp08,s_nnp[1].nnp09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i711_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i711_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2  LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(200)
 
   LET g_sql = "SELECT nnp02,nnp03,nnn02,nnp04,nnp05,nnp06,nnp07,nnp08,nnp09 ",
               #No.FUN-850038 --start--
               "       ,nnpud01,nnpud02,nnpud03,nnpud04,nnpud05,",
               "       nnpud06,nnpud07,nnpud08,nnpud09,nnpud10,",
               "       nnpud11,nnpud12,nnpud13,nnpud14,nnpud15", 
               #No.FUN-850038 ---end---
               " FROM nnp_file LEFT OUTER JOIN nnn_file",
               " ON nnp03 = nnn_file.nnn01 WHERE ",
               "   nnp01 ='",g_nno.nno01,"'",  #單頭
               "   AND ",p_wc2 CLIPPED,            #單身
               " ORDER BY 1"
 
   PREPARE i711_pb FROM g_sql
   DECLARE nnp_curs CURSOR FOR i711_pb
 
   CALL g_nnp.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
   FOREACH nnp_curs INTO g_nnp[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
 
      IF g_nnp[g_cnt].nnp04='Y' THEN
         LET c_nnp04='N'
      END IF
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
      CALL g_nnp.deleteElement(g_cnt)   #取消 Array Element
 
   LET g_rec_b=g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i711_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnp TO s_nnp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i711_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i711_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i711_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i711_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i711_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
#@    ON ACTION 合約條款及摘要
      ON ACTION memo
         LET g_action_choice="memo"
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i711_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nno01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i711_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nno01",FALSE)
display "cl_set_comp_entry('nno01',FALSE) runed"
   END IF
 
END FUNCTION
 
FUNCTION i711_out()
  DEFINE
    sr              RECORD
        nno01       LIKE nno_file.nno01,   # 合約號碼
        nno02       LIKE nno_file.nno02,   # 信貸銀行
        alg021      LIKE alg_file.alg021,  # 銀行名稱
        nno03       LIKE nno_file.nno03,   # 申請日期
        nno04       LIKE nno_file.nno04,   # 核准日期
        nno05       LIKE nno_file.nno05,   # 有效日期
        nno06       LIKE nno_file.nno06,   # 申請幣別
        nno07       LIKE nno_file.nno07,   # 申請金額
        nno08       LIKE nno_file.nno08,   # 核准金額
        nno09       LIKE nno_file.nno09,   # 暫停
        nno13       LIKE nno_file.nno13,   # 摘要
        nnp02       LIKE nnp_file.nnp02,   # 項次
        nnp03       LIKE nnp_file.nnp03,   # 授信類別
        nnn02       LIKE nnn_file.nnn02,   # 授信名稱
        nnp04       LIKE nnp_file.nnp04,   # 主類
        nnp05       LIKE nnp_file.nnp05,   # 利率
        nnp06       LIKE nnp_file.nnp06,   # 費率
        nnp07       LIKE nnp_file.nnp07,   # 幣別
        nnp08       LIKE nnp_file.nnp08,   # 匯率
        nnp09       LIKE nnp_file.nnp09    # 授信額度
                    END RECORD,
    l_za05          LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(40)
    l_name          LIKE type_file.chr20   #External(Disk) file name #No.FUN-680107 VARCHAR(20)
 
 
    IF g_nno.nno01 IS NULL OR g_wc IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN
    END IF
    #No.FUN-780011  --Begin
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    #No.FUN-780011  --End  
    CALL cl_wait()
    #No.FUN-770038  --Begin
    #LET l_name = 'anmi711.out'
    #CALL cl_outnam('anmi711') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=" SELECT nno01,nno02,alg021,nno03,nno04,nno05,nno06,nno07, ",
              "        nno08,nno09,nno13,nnp02,nnp03,nnn02,nnp04,nnp05,nnp06, ",
              "        nnp07,nnp08,nnp09,a.azi04,b.azi04 t_azi04,b.azi07 t_azi07",
              "   FROM nno_file LEFT OUTER JOIN nnp_file ",
              "                 LEFT OUTER JOIN nnn_file ON nnp03=nnn01 ",
              "                 LEFT OUTER JOIN azi_file b ON nnp07=b.azi01 ",
              "                 ON nno01 = nnp01",
              "                 LEFT OUTER JOIN alg_file ON nno02 = alg01 ",
              "                 LEFT OUTER JOIN azi_file a ON nno06 = a.azi01 ",
              "  WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," ORDER BY nno01,nnp02 "
    #PREPARE i711_p1 FROM g_sql                # RUNTIME 編譯
    #DECLARE i711_co CURSOR FOR i711_p1
 
    #START REPORT i711_rep TO l_name
 
    #FOREACH i711_co INTO sr.*
    #    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
    #    OUTPUT TO REPORT i711_rep(sr.*)
    #END FOREACH
    #FINISH REPORT i711_rep
    #CLOSE i711_co
    #MESSAGE ""
    #CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'nno01')
            RETURNING g_str
    END IF
 
    CALL cl_prt_cs1('anmi711','anmi711',g_sql,g_str)
    #No.FUN-770038  --End  
END FUNCTION
 
#No.FUN-770038  --Begin
#REPORT i711_rep(sr)
# DEFINE
#    l_last_sw    LIKE type_file.chr1,      #No.FUN-680107 VARCHAR(1)
#    l_nnp02      LIKE type_file.chr20,     #No.FUN-680107 VARCHAR(10) #紀錄項次字串
#    sr              RECORD
#        nno01       LIKE nno_file.nno01,   # 合約號碼
#        nno02       LIKE nno_file.nno02,   # 信貸銀行
#        alg021      LIKE alg_file.alg021,  # 銀行名稱
#        nno03       LIKE nno_file.nno03,   # 申請日期
#        nno04       LIKE nno_file.nno04,   # 核准日期
#        nno05       LIKE nno_file.nno05,   # 有效日期
#        nno06       LIKE nno_file.nno06,   # 申請幣別
#        nno07       LIKE nno_file.nno07,   # 申請金額
#        nno08       LIKE nno_file.nno08,   # 核准金額
#        nno09       LIKE nno_file.nno09,   # 暫停
#        nno13       LIKE nno_file.nno13,   # 摘要
#        nnp02       LIKE nnp_file.nnp02,   # 項次
#        nnp03       LIKE nnp_file.nnp03,   # 授信類別
#        nnn02       LIKE nnn_file.nnn02,   # 授信名稱
#        nnp04       LIKE nnp_file.nnp04,   # 主類
#        nnp05       LIKE nnp_file.nnp05,   # 利率
#        nnp06       LIKE nnp_file.nnp06,   # 費率
#        nnp07       LIKE nnp_file.nnp07,   # 幣別
#        nnp08       LIKE nnp_file.nnp08,   # 匯率
#        nnp09       LIKE nnp_file.nnp09    # 授信額度
#                    END RECORD
#
#   OUTPUT
#   TOP MARGIN g_top_margin
#   LEFT MARGIN g_left_margin
#   BOTTOM MARGIN g_bottom_margin
#   PAGE LENGTH g_page_line
#
# ORDER BY sr.nno01,sr.nnp02
#
# FORMAT
#   PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     LET g_pageno=g_pageno+1
#     LET pageno_total=PAGENO USING '<<<',"/pageno"
#     PRINT g_head CLIPPED,pageno_total
#     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=sr.nno06                      #NO.CHI-6A0004
#     LET g_head1=g_x[9] CLIPPED, COLUMN g_c[32],sr.nno01,COLUMN g_c[33],g_x[18] CLIPPED,
#                 COLUMN g_c[34],sr.nno09,COLUMN g_c[35],g_x[10] CLIPPED,COLUMN g_c[36],   #TQC-660025
#                 sr.nno02,COLUMN g_c[37],sr.alg021   #TQC-660025
#     PRINT g_head1
#     LET g_head1=g_x[11] CLIPPED, COLUMN g_c[32],sr.nno06,COLUMN g_c[33],g_x[12] CLIPPED,
#                 COLUMN g_c[34],cl_numfor(sr.nno07,38,t_azi04),COLUMN g_c[37],g_x[13] CLIPPED, #NO.CHI-6A0004
#                 COLUMN g_c[38],cl_numfor(sr.nno08,38,t_azi04)                                 #NO.CHI-6A0004
#     PRINT g_head1
#     LET g_head1=g_x[14] CLIPPED,COLUMN g_c[32],sr.nno03,COLUMN g_c[33],g_x[15] CLIPPED,
#                 COLUMN g_c[35],sr.nno04,COLUMN g_c[37],g_x[16] CLIPPED,COLUMN g_c[38],sr.nno05
#     PRINT g_head1
#     LET g_head1=g_x[17] CLIPPED,COLUMN g_c[32],sr.nno13
#     PRINT g_head1
# 
#     PRINT g_dash[1,g_len]
#     PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#           g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED
#     PRINT g_dash1
#
#     LET l_last_sw = 'y'
#
#    BEFORE GROUP OF sr.nno01
#       SKIP TO TOP OF PAGE
#
#
#    ON EVERY ROW
#       SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file WHERE azi01=sr.nnp07
#       LET l_nnp02=sr.nnp02 USING '--&',' ',sr.nnp03
#       PRINT COLUMN g_c[31],l_nnp02,
#             COLUMN g_c[32],sr.nnn02,
#             COLUMN g_c[33],sr.nnp04,
#             COLUMN g_c[34],sr.nnp05 USING '----&.---&',    #No:7354
#             COLUMN g_c[35],sr.nnp06 USING '---,--&.--&',
#             COLUMN g_c[36],sr.nnp07,
#             COLUMN g_c[37],cl_numfor(sr.nnp08,37,t_azi07),
#             COLUMN g_c[38],cl_numfor(sr.nnp09,38,t_azi04)
#
#    ON LAST ROW
#        PRINT g_dash[1,g_len]
#        PRINT ' ',g_x[4] CLIPPED,COLUMN (g_len-10),g_x[7] CLIPPED
#        LET l_last_sw = 'n'
#
#    PAGE TRAILER
#        IF l_last_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-10),g_x[6] CLIPPED
#        ELSE
#            SKIP 2 LINE
#        END IF
#END REPORT
#No.FUN-770038  --End  
#Patch....NO.MOD-5A0095 <003,001,002> #

