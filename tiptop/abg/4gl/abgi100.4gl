# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abgi100.4gl
# Descriptions...: 銷貨預算資料維護作業
# Date & Author..: Julius 02/09/24
# Modi...........: ching  031028 No.8563 單位換算
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-550037 05/05/13 By saki   欄位comment顯示
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-5A0004 05/10/07 By rosayu r()後筆數不正確
# Modify.........: No.TQC-630053 06/03/07 By Smapmin 單身顯示不正常
#                                                    產品別/品號開窗要開oba_file
# Modify.........: NO.FUN-630015 06/05/24 BY yiting s_rdate2改統一call s_rdatem.4gl
# Modify.........: No.FUN-660105 06/06/15 By hellen     cl_err --> cl_err3
# Modify.........: No.TQC-610054 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680022 06/08/31 By Tracy s_rdatem()增加一個參數 
# Modify.........: No.FUN-680061 06/08/23 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690023 06/09/11 By jamie 判斷occacti
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0003 06/10/11 By jamie 1.FUNCTION i100()_q 一開始應清空g_bgm_hd.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0057 06/10/20 By hongmei 將 g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-680074 06/12/27 By Smapmin 為因應s_rdatem.4gl程式內對於dbname的處理,故LET g_dbs2=g_dbs,'.'
# Modify.........: No.TQC-720019 07/02/27 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760066 07/06/14 By chenl   修正報表打印異常！
# Modify.........: No.FUN-7A0065 07/11/05 By Carrier db判斷時,調用s_dbstring()
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.TQC-980119 09/08/17 By lilingyu 銷售單位欄位如果錄入無效值,應該先去檢查是否存在于gfe_file表,如果不存在則show報錯訊息,然后再去檢查有無轉化率
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/09 By douzh GP5.2集團架構重整,修改sub傳參
# Modify.........: No:MOD-9B0099 09/12/22 By sabrina 單身使用「預設上筆資料」(1)期別沒有自動+1
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
#                                                                            (2)應收款日及票到期日沒有重新計算
# Modify.........: No.FUN-AA0059 10/10/22 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/22 By lixh1  全系統料號的開窗都改為CALL q_sel_ima() 
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-910088 12/01/11 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/14 By yuhuabao 離開單身時單身無資料時提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bgm_hd        RECORD                       #單頭變數
        bgm01       LIKE bgm_file.bgm01,
	bgm02	    LIKE bgm_file.bgm02,
        bgm012      LIKE bgm_file.bgm012,
        bgm013      LIKE bgm_file.bgm013,
        bgm014      LIKE bgm_file.bgm014,
	bgm015	    LIKE bgm_file.bgm015,
	bgm016	    LIKE bgm_file.bgm016,
	bgm017	    LIKE bgm_file.bgm017,
	bgm08 	    LIKE bgm_file.bgm08,
	bgm08_fac   LIKE bgm_file.bgm08_fac
        END RECORD,
    g_bgm_hd_t      RECORD                       #單頭變數
        bgm01       LIKE bgm_file.bgm01,
	bgm02	    LIKE bgm_file.bgm02,
        bgm012      LIKE bgm_file.bgm012,
        bgm013      LIKE bgm_file.bgm013,
        bgm014      LIKE bgm_file.bgm014,
	bgm015	    LIKE bgm_file.bgm015,
	bgm016	    LIKE bgm_file.bgm016,
	bgm017	    LIKE bgm_file.bgm017,
	bgm08 	    LIKE bgm_file.bgm08,
	bgm08_fac   LIKE bgm_file.bgm08_fac
        END RECORD,
    g_bgm_hd_o      RECORD                       #單頭變數
        bgm01       LIKE bgm_file.bgm01,
	bgm02	    LIKE bgm_file.bgm02,
        bgm012      LIKE bgm_file.bgm012,
        bgm013      LIKE bgm_file.bgm013,
        bgm014      LIKE bgm_file.bgm014,
	bgm015	    LIKE bgm_file.bgm015,
	bgm016	    LIKE bgm_file.bgm016,
	bgm017	    LIKE bgm_file.bgm017,
	bgm08 	    LIKE bgm_file.bgm08,
	bgm08_fac   LIKE bgm_file.bgm08_fac
        END RECORD,
    g_bgm           DYNAMIC ARRAY OF RECORD      #程式變數(單身)
	bgm03	    LIKE bgm_file.bgm03,
	bgm04	    LIKE bgm_file.bgm04,
	bga05	    LIKE bga_file.bga05,
	bgm05	    LIKE bgm_file.bgm05,
	bgm06	    LIKE bgm_file.bgm06,
	bgm07	    LIKE bgm_file.bgm07,
	bgm091      LIKE bgm_file.bgm091,
	bgm092      LIKE bgm_file.bgm092,
	bgm093      LIKE bgm_file.bgm093,
	bgm094      LIKE bgm_file.bgm094
        END RECORD,
    g_bgm_t         RECORD                       #程式變數(舊值)
	bgm03	    LIKE bgm_file.bgm03,
	bgm04	    LIKE bgm_file.bgm04,
	bga05	    LIKE bga_file.bga05,
	bgm05	    LIKE bgm_file.bgm05,
	bgm06	    LIKE bgm_file.bgm06,
	bgm07	    LIKE bgm_file.bgm07,
	bgm091      LIKE bgm_file.bgm091,
	bgm092      LIKE bgm_file.bgm092,
	bgm093      LIKE bgm_file.bgm093,
	bgm094      LIKE bgm_file.bgm094
        END RECORD,
     g_wc            string,                         #WHERE CONDITION  #No.FUN-580092 HCN
     g_sql           string,                         #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,             #單身筆數        #No.FUN-680061 SMALLINT
    g_mody          LIKE type_file.chr1,             #單身的鍵值是否改變 #No.FUN-680061 VARCHAR(01)
    l_ac            LIKE type_file.num5              #目前處理的ARRAY CNT #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_sql_tmp       STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680061 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03           #No.FUN-680061 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5     #No.FUN-680061 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680061 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680061 SMALLINT  #No.FUN-6A0057 g_no_ask
DEFINE   g_dbs2         LIKE type_file.chr30         #TQC-680074
DEFINE   g_plant2       LIKE type_file.chr10         #FUN-980020
DEFINE   g_bgm08_t      LIKE bgm_file.bgm08          #FUN-910088
 
#主程式開始
MAIN
 
    OPTIONS                                      #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                              #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABG")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
 
    LET g_plant2 = g_plant                    #FUN-980020
    LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    #FUN-820017
    #No.FUN-7A0065  --End  
    INITIALIZE g_bgm_hd.* to NULL
    INITIALIZE g_bgm_hd_t.* to NULL
 
    OPEN WINDOW i100_w WITH FORM "abg/42f/abgi100"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    CALL i100_menu()
    CLOSE WINDOW i100_w                          #結束畫面
      CALL  cl_used(g_prog,g_time,2)             #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0056
         RETURNING g_time    #No.FUN-6A0056
END MAIN
 
#QBE 查詢資料
FUNCTION i100_curs()
    CLEAR FORM #清除畫面
    CALL g_bgm.clear()
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0033
   INITIALIZE g_bgm_hd.* TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON bgm01, bgm012, bgm02,     #組SQL 條件
		      bgm017,
                      bgm08 , bgm08_fac,
                      bgm014, bgm013, bgm015, bgm016,
                      bgm03, bgm04, bgm05,bgm06,bgm07,
                      bgm091,bgm092,bgm093,bgm094
         FROM bgm01, bgm012,  bgm02,
              bgm017,
	      bgm08 , bgm08_fac,
	      bgm014, bgm013, bgm015, bgm016,
              s_bgm[1].bgm03, s_bgm[1].bgm04, s_bgm[1].bgm05,
              s_bgm[1].bgm06, s_bgm[1].bgm07,
              s_bgm[1].bgm091,s_bgm[1].bgm092,
              s_bgm[1].bgm093,s_bgm[1].bgm094
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
		WHEN INFIELD(bgm012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_gea"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bgm012
		WHEN INFIELD(bgm013)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgm013
		WHEN INFIELD(bgm014)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_occ"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgm014
                WHEN INFIELD(bgm015)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgm015
		WHEN INFIELD(bgm016)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgm016
		WHEN INFIELD(bgm017)
#FUN-AA0059 --Begin--
              #      CALL cl_init_qry_var()
              #      LET g_qryparam.state = "c"
              #      LET g_qryparam.form ="q_ima"   
              #      CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO bgm017
		WHEN INFIELD(bgm08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bgm08
                    NEXT FIELD bgm08
            END CASE
     #-----TQC-630053---------
     ON ACTION CONTROLE
           IF INFIELD (bgm017) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_oba"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO bgm017
           END IF
     #-----END TQC-630053-----
 
 
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
    IF INT_FLAG THEN
        CALL i100_show()
        RETURN
    END IF
 
    LET g_sql = "SELECT UNIQUE bgm01, bgm02, bgm012, bgm013,",
	                     " bgm014, bgm015, bgm016, bgm017,bgm08,bgm08_fac",
                "  FROM bgm_file ",
                " WHERE ", g_wc CLIPPED,
                " ORDER BY bgm01"
    PREPARE i100_prepare FROM g_sql
    DECLARE i100_cs                              #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
 
#   LET g_sql = "SELECT UNIQUE bgm01, bgm02, bgm012, bgm013,",      #No.TQC-720019
    LET g_sql_tmp = "SELECT UNIQUE bgm01, bgm02, bgm012, bgm013,",  #No.TQC-720019
	                     " bgm014, bgm015, bgm016, bgm017,bgm08,bgm08_fac",
                "  FROM bgm_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
#   PREPARE i100_pre_x FROM g_sql      #No.TQC-720019
    PREPARE i100_pre_x FROM g_sql_tmp  #No.TQC-720019
    EXECUTE i100_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE i100_precnt FROM g_sql
    DECLARE i100_cnt CURSOR FOR i100_precnt
 
END FUNCTION
 
#中文的MENU
FUNCTION i100_menu()
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i100_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i100_u()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i100_copy()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i100_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i100_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgm),'','')
            END IF
         #No.FUN-6A0003-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_bgm_hd.bgm02 IS NOT NULL THEN
                LET g_doc.column1 = "bgm02"
                LET g_doc.column2 = "bgn01"
                LET g_doc.column3 = "bgm012"
                LET g_doc.column4 = "bgm017"
                LET g_doc.value1 = g_bgm_hd.bgm02
                LET g_doc.value2 = g_bgm_hd.bgm01
                LET g_doc.value3 = g_bgm_hd.bgm012
                LET g_doc.value4 = g_bgm_hd.bgm017
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0003-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i100_a()
    IF s_shut(0) THEN  RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_bgm.clear()
    INITIALIZE g_bgm_hd TO NULL                  #單頭初始清空
    INITIALIZE g_bgm_hd_o TO NULL                #單頭舊值清空
 
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i100_i("a")                         #輸入單頭
        IF INT_FLAG THEN                         #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
     IF cl_null(g_bgm_hd.bgm012)  OR
        cl_null(g_bgm_hd.bgm013)  OR
        cl_null(g_bgm_hd.bgm014)  OR
        cl_null(g_bgm_hd.bgm015)  OR
        cl_null(g_bgm_hd.bgm016)  OR
        cl_null(g_bgm_hd.bgm017)  OR
        cl_null(g_bgm_hd.bgm08 )  OR
        cl_null(g_bgm_hd.bgm08_fac)  OR
        cl_null(g_bgm_hd.bgm017)  OR
        cl_null(g_bgm_hd.bgm02)  THEN
        CONTINUE WHILE
     END IF
        CALL g_bgm.clear()
        LET g_rec_b=0
        CALL i100_b()                            #輸入單身
        LET g_bgm_hd_o.* = g_bgm_hd.*            #保留舊值
        LET g_bgm_hd_t.* = g_bgm_hd.*            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i100_u()
 
    IF s_shut(0) THEN
	RETURN
    END IF
    IF g_bgm_hd.bgm01 IS NULL THEN
	CALL cl_err('',-400,0)
	RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bgm_hd_t.bgm01 = g_bgm_hd.bgm01
    LET g_bgm_hd_t.bgm02 = g_bgm_hd.bgm02
    LET g_bgm_hd_t.bgm012 = g_bgm_hd.bgm012
    LET g_bgm_hd_t.bgm013 = g_bgm_hd.bgm013
    LET g_bgm_hd_t.bgm014 = g_bgm_hd.bgm014
    LET g_bgm_hd_t.bgm015 = g_bgm_hd.bgm015
    LET g_bgm_hd_t.bgm016 = g_bgm_hd.bgm016
    LET g_bgm_hd_t.bgm017 = g_bgm_hd.bgm017
    LET g_bgm_hd_t.bgm08  = g_bgm_hd.bgm08
    LET g_bgm_hd_t.bgm08_fac = g_bgm_hd.bgm08_fac
    BEGIN WORK
    WHILE TRUE
        CALL i100_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_bgm_hd.bgm01 = g_bgm_hd_t.bgm01
            LET g_bgm_hd.bgm02 = g_bgm_hd_t.bgm02
	    LET g_bgm_hd.bgm012 = g_bgm_hd_t.bgm012
            LET g_bgm_hd.bgm013 = g_bgm_hd_t.bgm013
            LET g_bgm_hd.bgm014 = g_bgm_hd_t.bgm014
            LET g_bgm_hd.bgm015 = g_bgm_hd_t.bgm015
            LET g_bgm_hd.bgm016 = g_bgm_hd_t.bgm016
            LET g_bgm_hd.bgm017 = g_bgm_hd_t.bgm017
            LET g_bgm_hd.bgm08  = g_bgm_hd_t.bgm08
            LET g_bgm_hd.bgm08_fac = g_bgm_hd_t.bgm08_fac
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE bgm_file
	   SET bgm01 = g_bgm_hd.bgm01,
               bgm02 = g_bgm_hd.bgm02,
	       bgm012 = g_bgm_hd.bgm012,
               bgm013 = g_bgm_hd.bgm013,
               bgm014 = g_bgm_hd.bgm014,
               bgm015 = g_bgm_hd.bgm015,
               bgm016 = g_bgm_hd.bgm016,
	       bgm017 = g_bgm_hd.bgm017,
	       bgm08  = g_bgm_hd.bgm08 ,
	       bgm08_fac  = g_bgm_hd.bgm08_fac
         WHERE bgm01 = g_bgm_hd_t.bgm01
           AND bgm02 = g_bgm_hd_t.bgm02
	   AND bgm012 = g_bgm_hd_t.bgm012
           AND bgm013 = g_bgm_hd_t.bgm013
           AND bgm014 = g_bgm_hd_t.bgm014
           AND bgm015 = g_bgm_hd_t.bgm015
           AND bgm016 = g_bgm_hd_t.bgm016
           AND bgm017 = g_bgm_hd_t.bgm017
           AND bgm08  = g_bgm_hd_t.bgm08
           AND bgm08_fac = g_bgm_hd_t.bgm08_fac
        IF SQLCA.sqlcode THEN
#           CALL cl_err('',SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("upd","bgm_file",g_bgm_hd_t.bgm01,g_bgm_hd_t.bgm02,SQLCA.sqlcode,"","",1) #FUN-660105
            CONTINUE WHILE
        END IF
        CALL i100_bgm08_check("u") #FUN-910088 add
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理單頭欄位(bgm01, bgm012, bgm02, bgm017, bgm014, bgm013, bgm015, bgm016)INPUT
FUNCTION i100_i(p_cmd)
DEFINE
    p_cmd   LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680061 VARCHAR(01)
    l_n     LIKE type_file.num5     #No.FUN-680061 SMALLINT
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
    DISPLAY g_bgm_hd.bgm01, g_bgm_hd.bgm012, g_bgm_hd.bgm02, g_bgm_hd.bgm017,
            g_bgm_hd.bgm08 ,g_bgm_hd.bgm08_fac,
            g_bgm_hd.bgm014,g_bgm_hd.bgm013, g_bgm_hd.bgm015,g_bgm_hd.bgm016
         TO bgm01, bgm012, bgm02, bgm017,
            bgm08, bgm08_fac,
	    bgm014, bgm013, bgm015, bgm016
 
    INPUT BY NAME
        g_bgm_hd.bgm01, g_bgm_hd.bgm012, g_bgm_hd.bgm02, g_bgm_hd.bgm017,
        g_bgm_hd.bgm08, g_bgm_hd.bgm08_fac,
        g_bgm_hd.bgm014, g_bgm_hd.bgm013, g_bgm_hd.bgm015, g_bgm_hd.bgm016
    WITHOUT DEFAULTS HELP 1
 
#No.FUN-570108--begin
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i100_set_entry(p_cmd)
           CALL i100_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
#No.FUN-570108--end
           LET g_bgm08_t = g_bgm_hd.bgm08 #FUN-910088 add
 
        AFTER FIELD bgm01
            IF g_bgm_hd.bgm01 IS NULL THEN
                LET g_bgm_hd.bgm01 = " "
            END IF
 
        AFTER FIELD bgm012
            IF NOT cl_null(g_bgm_hd.bgm012) THEN
		IF g_bgm_hd.bgm012 <> "ALL" THEN
		    LET l_n = 0
		    SELECT COUNT(*)
		      INTO l_n
		      FROM gea_file
		     WHERE gea01 = g_bgm_hd.bgm012
		    IF l_n < 1 THEN
			NEXT FIELD bgm012
		    END IF
		END IF
            END IF
 
	AFTER FIELD bgm02
	    IF cl_null(g_bgm_hd.bgm02)
	    OR g_bgm_hd.bgm02 < 1 THEN
		NEXT FIELD bgm02
	    END IF
 
	AFTER FIELD bgm017
	    IF NOT cl_null(g_bgm_hd.bgm017) THEN
                #FUN-AA0059 -------------------------add start-------------------
                IF NOT s_chk_item_no(g_bgm_hd.bgm017,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bgm017 
                 END IF 
                 #FUN-AA0059 -------------------------add end------------------- 
                CALL i100_bgm017('a',g_bgm_hd.bgm017)
                IF NOT cl_null(g_errno)  THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bgm017
                END IF
	    END IF
            IF cl_null(g_bgm_hd.bgm08) THEN
               SELECT ima31 INTO g_bgm_hd.bgm08
                 FROM ima_file
                WHERE ima01=g_bgm_hd.bgm017
                DISPLAY BY NAME g_bgm_hd.bgm08
            END IF
 
       AFTER FIELD bgm08
           IF NOT cl_null(g_bgm_hd.bgm08 ) THEN
              CALL i100_bgm08('a',g_bgm_hd.bgm08 )
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD bgm08
              END IF
              #FUN-910088--add--str--
              IF p_cmd = "u" THEN            
                 CALL i100_bgm08_check("i")     
              END IF                            
              #FUN-910088--add--end--
           END IF

 
        AFTER FIELD bgm014
	    IF NOT cl_null(g_bgm_hd.bgm014) THEN
                CALL i100_bgm014('a',g_bgm_hd.bgm014)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bgm014
                END IF
	    END IF
 
        AFTER FIELD bgm013
            IF NOT cl_null(g_bgm_hd.bgm013) THEN
                CALL i100_bgm013('a',g_bgm_hd.bgm013)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bgm013
                END IF
            END IF
 
	AFTER FIELD bgm015
	    IF NOT cl_null(g_bgm_hd.bgm015) THEN
                CALL i100_bgm015('a',g_bgm_hd.bgm015)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bgm015
                END IF
	    END IF
 
	AFTER FIELD bgm016
	    IF NOT cl_null(g_bgm_hd.bgm016) THEN
		LET l_n = 0
		SELECT COUNT(*) INTO l_n
		  FROM azi_file
		 WHERE azi01 = g_bgm_hd.bgm016 AND aziacti = 'Y'
		IF l_n < 1 THEN
		    NEXT FIELD bgm016
		END IF
	    END IF
 
        ON ACTION CONTROLF                       #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
		WHEN INFIELD(bgm012)
		#   LET g_qryparam.state = 'c' #FUN-980030
		#   LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#   CALL q_gea(10,3, g_bgm_hd.bgm012)
	        #	RETURNING g_bgm_hd.bgm012
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gea"
                     LET g_qryparam.default1 = g_bgm_hd.bgm012
                     CALL cl_create_qry() RETURNING g_bgm_hd.bgm012
		     DISPLAY g_bgm_hd.bgm012 TO bgm012
		WHEN INFIELD(bgm013)
		#   LET g_qryparam.state = 'c' #FUN-980030
		#   LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#   CALL q_gen(10,35, g_bgm_hd.bgm013)
	        #	RETURNING g_bgm_hd.bgm013
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_bgm_hd.bgm013
                    CALL cl_create_qry() RETURNING g_bgm_hd.bgm013
		    DISPLAY g_bgm_hd.bgm013 TO bgm013
		WHEN INFIELD(bgm014)
		#   LET g_qryparam.state = 'c' #FUN-980030
		#   LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#   CALL q_occ(10,35, g_bgm_hd.bgm014)
		#       RETURNING g_bgm_hd.bgm014
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_occ"
                    LET g_qryparam.default1 = g_bgm_hd.bgm014
                    CALL cl_create_qry() RETURNING g_bgm_hd.bgm014
		    DISPLAY g_bgm_hd.bgm014 TO bgm014
                WHEN INFIELD(bgm015)
                #   CALL q_gem(10,35,g_bgm_hd.bgm015)
                #       RETURNING g_bgm_hd.bgm015
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_bgm_hd.bgm015
                    CALL cl_create_qry() RETURNING g_bgm_hd.bgm015
                    DISPLAY BY NAME g_bgm_hd.bgm015
		WHEN INFIELD(bgm016)
		#   LET g_qryparam.state = 'c' #FUN-980030
		#   LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#   CALL q_azi(12,35, g_bgm_hd.bgm016)
	        #	RETURNING g_bgm_hd.bgm016
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azi"
                    LET g_qryparam.default1 = g_bgm_hd.bgm016
                    CALL cl_create_qry() RETURNING g_bgm_hd.bgm016
                #   CALL FGL_DIALOG_SETBUFFER( g_adu[l_ac].adu10 )
		    DISPLAY g_bgm_hd.bgm016 TO bgm016
		WHEN INFIELD(bgm017)
		#   LET g_qryparam.state = 'c' #FUN-980030
		#   LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#   CALL q_ima(10,35, g_bgm_hd.bgm017)
		#       RETURNING g_bgm_hd.bgm017
#FUN-AA0059 --Begin---
                #    CALL cl_init_qry_var()
                #    LET g_qryparam.form ="q_ima"  
                #    LET g_qryparam.default1=g_bgm_hd.bgm017
                #    CALL cl_create_qry() RETURNING g_bgm_hd.bgm017
                    CALL q_sel_ima(FALSE, "q_ima", "",  g_bgm_hd.bgm017 , "", "", "", "" ,"",'' )  RETURNING g_bgm_hd.bgm017
#FUN-AA0059 --End--
		    DISPLAY g_bgm_hd.bgm017 TO bgm017
		WHEN INFIELD(bgm08)
		#   LET g_qryparam.state = 'c' #FUN-980030
		#   LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#   CALL q_gfe(10,35, g_bgm_hd.bgm08 )
		#       RETURNING g_bgm_hd.bgm08
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1=g_bgm_hd.bgm08
                    CALL cl_create_qry() RETURNING g_bgm_hd.bgm08
		    DISPLAY g_bgm_hd.bgm08  TO bgm08
                    NEXT FIELD bgm08
            END CASE
        ON ACTION CONTROLE
            CASE
		WHEN INFIELD(bgm017)
		#   LET g_qryparam.state = 'c' #FUN-980030
		#   LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#   CALL q_oba(10,3, g_bgm_hd.bgm017)
		#       RETURNING g_bgm_hd.bgm017
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oba"
                    LET g_qryparam.default1 = g_bgm_hd.bgm017
                    CALL cl_create_qry() RETURNING g_bgm_hd.bgm017
		    DISPLAY g_bgm_hd.bgm017 TO bgm017
            END CASE
 
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
 
FUNCTION i100_bgm017(p_cmd,p_key)
 DEFINE l_ima02   LIKE ima_file.ima02,
        l_ima01   LIKE ima_file.ima01 ,
        l_ima021  LIKE ima_file.ima021,
        l_ima25   LIKE ima_file.ima25 ,
        l_imaacti LIKE ima_file.imaacti,
        p_key     LIKE bgm_file.bgm017,
        p_cmd     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT ima02,ima021,imaacti
    INTO l_ima02,l_ima021,l_imaacti
    FROM ima_file  WHERE ima01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL
                                 LET l_ima021=NULl
                                 LET l_imaacti = NULL
       WHEN l_imaacti='N'        LET g_errno = '9028'
  #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF NOT cl_null(g_errno) THEN
     SELECT oba02 INTO l_ima02 FROM oba_file WHERE oba01 = p_key
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno= 'mfg0002'
                                    LET l_ima02 = NULL
          OTHERWISE                 LET g_errno= SQLCA.SQLCODE USING '-------'
     END CASE
  END IF
 
  LET l_ima01=''
  SELECT ima01 INTO l_ima01 FROM ima_file
   WHERE ima01=p_key
  IF cl_null(l_ima01) THEN
     SELECT bgg06 INTO l_ima01 FROM bgg_file
      WHERE bgg01=g_bgm_hd.bgm01
        AND bgg02=p_key
  END IF
  SELECT ima25 INTO l_ima25 FROM ima_file
   WHERE ima01=l_ima01
 
  IF cl_null(g_errno)  OR p_cmd = 'd' THEN
     DISPLAY l_ima02  TO FORMONLY.ima02
     DISPLAY l_ima021 TO FORMONLY.ima021
     DISPLAY l_ima25  TO FORMONLY.ima25
  END IF
END FUNCTION
 
FUNCTION i100_bgm017c(p_cmd,p_key)
 DEFINE l_ima02   LIKE ima_file.ima02,
        l_ima021  LIKE ima_file.ima021,
        l_ima25   LIKE ima_file.ima25 ,
        l_imaacti LIKE ima_file.imaacti,
        p_key     LIKE bgm_file.bgm017,
        p_cmd     LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT ima02,ima021,imaacti
    INTO l_ima02,l_ima021,l_imaacti
    FROM ima_file  WHERE ima01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
       WHEN l_imaacti='N'        LET g_errno = '9028'
  #FUN-690022------mod-------
       WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF NOT cl_null(g_errno) THEN
    SELECT oba02 INTO l_ima02 FROM oba_file WHERE oba01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno= 'mfg0002'
         OTHERWISE                 LET g_errno= SQLCA.SQLCODE USING '-------'
    END CASE
  END IF
 
END FUNCTION
 
FUNCTION i100_bgm08(p_cmd,p_key)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE bgm_file.bgm08,
        p_key2    LIKE bgm_file.bgm08,
        l_fac     LIKE pml_file.pml09,   #No.FUN-680061 DEC(16,8)
        p_cmd     LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
IF cl_null(g_errno) THEN   #TQC-980119
  LET l_ima01=''
  SELECT ima01 INTO l_ima01 FROM ima_file
   WHERE ima01=g_bgm_hd.bgm017
  IF cl_null(l_ima01) THEN
     SELECT bgg06 INTO l_ima01 FROM bgg_file
      WHERE bgg01=g_bgm_hd.bgm01
        AND bgg02=g_bgm_hd.bgm017
  END IF
  SELECT ima25 INTO l_ima25 FROM ima_file
   WHERE ima01=l_ima01
  CALL s_umfchk(l_ima01,p_key,l_ima25)
  RETURNING g_i,l_fac
  IF g_i = 1 THEN
    LET g_errno='abm-731'
    LET l_fac = 1
  END IF
  IF p_cmd='a' THEN
     LET g_bgm_hd.bgm08_fac=l_fac
  END IF
END IF                     #TQC-980119
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_ima25  TO FORMONLY.ima25
     DISPLAY l_fac    TO bgm08_fac
  END IF
END FUNCTION
 
FUNCTION i100_bgm08c(p_cmd,p_key,p_key2,p_key3)
 DEFINE l_gfeacti LIKE gfe_file.gfeacti,
        l_ima25   LIKE ima_file.ima25  ,
        l_ima01   LIKE ima_file.ima01  ,
        p_key     LIKE bgm_file.bgm08,
        p_key2    LIKE bgm_file.bgm01,
        p_key3    LIKE bgm_file.bgm017,
        l_fac     LIKE pml_file.pml09,    #No.FUN-680061 DEC(16,8)
        p_cmd     LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti
    FROM gfe_file  WHERE gfe01 = p_key
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0019'
                                 LET l_gfeacti = NULL
       WHEN l_gfeacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  LET l_ima01=''
  SELECT ima01 INTO l_ima01 FROM ima_file
   WHERE ima01=p_key3
  IF cl_null(l_ima01) THEN
     SELECT bgg06 INTO l_ima01 FROM bgg_file
      WHERE bgg01=p_key2
        AND bgg02=p_key3
  END IF
  SELECT ima25 INTO l_ima25 FROM ima_file
   WHERE ima01=l_ima01
  CALL s_umfchk(l_ima01,p_key,l_ima25)
  RETURNING g_i,l_fac
  IF g_i = 1 THEN
    LET g_errno='abm-731'
    LET l_fac = 1
  END IF
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_fac    TO obgm08_fac
  END IF
  RETURN l_fac
END FUNCTION
 
FUNCTION i100_bgm014(p_cmd,p_key)  #客戶編號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgm_file.bgm014,
           l_occ02   LIKE occ_file.occ02,
           l_occacti LIKE occ_file.occacti
 
    LET g_errno = " "
    SELECT occ02,occacti INTO l_occ02,l_occacti
      FROM occ_file WHERE occ01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2732'
                                   LET l_occ02 = ' '
         WHEN l_occacti='N' LET g_errno = '9028'
     #FUN-690023------mod-------
         WHEN l_occacti MATCHES '[PH]'    LET g_errno = '9038'
                                          LET l_occ02 = NULL
     #FUN-690023------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_bgm_hd.bgm014 = 'ALL' THEN
       LET g_errno = ' ' LET l_occ02 = 'ALL'
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_occ02 TO FORMONLY.occ02
    END IF
END FUNCTION
 
FUNCTION i100_bgm013(p_cmd,p_key)  #員工編號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgm_file.bgm013,
           l_gen02   LIKE gen_file.gen02,
           l_gen03   LIKE gen_file.gen03,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = " "
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
      FROM gen_file WHERE gen01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                   LET l_gen02 = ' '
                                   LET l_gen03 = ' '
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_bgm_hd.bgm013 = 'ALL' THEN
       LET g_errno = ' ' LET l_gen02 = 'ALL'
    END IF
    IF NOT cl_null(l_gen03) AND cl_null(g_bgm_hd.bgm015) THEN
       LET g_bgm_hd.bgm015 = l_gen03
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gen02 TO FORMONLY.gen02
        DISPLAY BY NAME g_bgm_hd.bgm015
    END IF
END FUNCTION
 
FUNCTION i100_bgm015(p_cmd,p_key)  #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgm_file.bgm015,
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = " "
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file WHERE gem01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                   LET l_gem02 = ' '
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF g_bgm_hd.bgm015 = 'ALL' THEN
       LET g_errno = ' ' LET l_gem02 = 'ALL'
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
 
#Query 查詢
FUNCTION i100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bgm_hd.* TO NULL                #No.FUN-6A0003
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bgm.clear()
    DISPLAY '     ' TO FORMONLY.cnt
    CALL i100_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i100_cs                                 # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bgm TO NULL
    ELSE
        OPEN i100_cnt
        FETCH i100_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i100_fetch('F')                     # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i100_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1    #處理方式  #No.FUN-680061 VARCHAR(01)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i100_cs INTO g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                                             g_bgm_hd.bgm012,g_bgm_hd.bgm013,
                                             g_bgm_hd.bgm014,g_bgm_hd.bgm015,
					     g_bgm_hd.bgm016,g_bgm_hd.bgm017,
					     g_bgm_hd.bgm08 ,g_bgm_hd.bgm08_fac
        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                                             g_bgm_hd.bgm012,g_bgm_hd.bgm013,
                                             g_bgm_hd.bgm014,g_bgm_hd.bgm015,
					     g_bgm_hd.bgm016,g_bgm_hd.bgm017,
					     g_bgm_hd.bgm08 ,g_bgm_hd.bgm08_fac
        WHEN 'F' FETCH FIRST    i100_cs INTO g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                                             g_bgm_hd.bgm012,g_bgm_hd.bgm013,
                                             g_bgm_hd.bgm014,g_bgm_hd.bgm015,
					     g_bgm_hd.bgm016,g_bgm_hd.bgm017,
					     g_bgm_hd.bgm08 ,g_bgm_hd.bgm08_fac
        WHEN 'L' FETCH LAST     i100_cs INTO g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                                             g_bgm_hd.bgm012,g_bgm_hd.bgm013,
                                             g_bgm_hd.bgm014,g_bgm_hd.bgm015,
					     g_bgm_hd.bgm016,g_bgm_hd.bgm017,
					     g_bgm_hd.bgm08 ,g_bgm_hd.bgm08_fac
        WHEN '/'
         IF (NOT mi_no_ask) THEN           #No.FUN-6A0057 g_no_ask
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
         FETCH ABSOLUTE g_jump i100_cs INTO g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                                            g_bgm_hd.bgm012,g_bgm_hd.bgm013,
                                            g_bgm_hd.bgm014,g_bgm_hd.bgm015,
	   			       g_bgm_hd.bgm016,g_bgm_hd.bgm017,
				       g_bgm_hd.bgm08 ,g_bgm_hd.bgm08_fac
         LET mi_no_ask = FALSE       #No.FUN-6A0057 g_no_ask
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bgm_hd.bgm01, SQLCA.sqlcode, 0)
        INITIALIZE g_bgm_hd.* TO NULL  #TQC-6B0105
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
    SELECT UNIQUE bgm01, bgm02, bgm012, bgm013,
                  bgm014, bgm015, bgm016, bgm017,
                  bgm08 , bgm08_fac
             INTO g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                  g_bgm_hd.bgm012,g_bgm_hd.bgm013,
                  g_bgm_hd.bgm014,g_bgm_hd.bgm015,
	          g_bgm_hd.bgm016,g_bgm_hd.bgm017,
	          g_bgm_hd.bgm08 ,g_bgm_hd.bgm08_fac
      FROM bgm_file
     WHERE bgm01 = g_bgm_hd.bgm01   AND bgm02 = g_bgm_hd.bgm02
       AND bgm012 = g_bgm_hd.bgm012 AND bgm013 = g_bgm_hd.bgm013
       AND bgm014 = g_bgm_hd.bgm014 AND bgm015 = g_bgm_hd.bgm015
       AND bgm016 = g_bgm_hd.bgm016 AND bgm017 = g_bgm_hd.bgm017
       AND bgm08  = g_bgm_hd.bgm08  AND bgm08_fac= g_bgm_hd.bgm08_fac
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bgm_hd.bgm01, SQLCA.sqlcode, 0) #FUN-660105
        CALL cl_err3("sel","bgm_file",g_bgm_hd.bgm01,g_bgm_hd.bgm02,SQLCA.sqlcode,"","",1) #FUN-660105
        INITIALIZE g_bgm TO NULL
        RETURN
    END IF
    CALL i100_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i100_show()
 
    DISPLAY g_bgm_hd.bgm01, g_bgm_hd.bgm012,     #顯示單頭值
            g_bgm_hd.bgm02, g_bgm_hd.bgm017,
            g_bgm_hd.bgm014, g_bgm_hd.bgm013,
	    g_bgm_hd.bgm015, g_bgm_hd.bgm016,
	    g_bgm_hd.bgm08, g_bgm_hd.bgm08_fac
	 TO bgm01, bgm012,
            bgm02, bgm017,
            bgm014,bgm013,
	    bgm015,bgm016,
	    bgm08 ,bgm08_fac
    CALL i100_bgm017('d',g_bgm_hd.bgm017)
    CALL i100_bgm08('d',g_bgm_hd.bgm08 )
    CALL i100_bgm014('d',g_bgm_hd.bgm014)
    CALL i100_bgm013('d',g_bgm_hd.bgm013)
    CALL i100_bgm015('d',g_bgm_hd.bgm015)
 
    CALL i100_b_fill(g_wc) #單身
    CALL i100_sum()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i100_r()
DEFINE
    l_chr LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_bgm_hd.bgm01 IS NULL THEN
        CALL cl_err('', -400, 0)
        RETURN
    END IF
    BEGIN WORK
    CALL i100_show()
    IF cl_delh(0,0) THEN                         #詢問是否取消資料
        INITIALIZE g_doc.* TO NULL              #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bgm02"             #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bgn01"             #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bgm012"            #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "bgm017"            #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bgm_hd.bgm02       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_bgm_hd.bgm01       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_bgm_hd.bgm012      #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_bgm_hd.bgm017      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                      #No.FUN-9B0098 10/02/24
        DELETE FROM bgm_file
         WHERE bgm01 = g_bgm_hd.bgm01   AND bgm02 = g_bgm_hd.bgm02
           AND bgm012 = g_bgm_hd.bgm012 AND bgm013 = g_bgm_hd.bgm013
           AND bgm014 = g_bgm_hd.bgm014 AND bgm015 = g_bgm_hd.bgm015
	   AND bgm016 = g_bgm_hd.bgm016 AND bgm017 = g_bgm_hd.bgm017
	   AND bgm08  = g_bgm_hd.bgm08  AND bgm08_fac= g_bgm_hd.bgm08_fac
 
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_bgm_hd.bgm01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("del","bgm_file",g_bgm_hd.bgm01,g_bgm_hd.bgm02,SQLCA.sqlcode,"","",1) #FUN-660105
        ELSE
            CLEAR FORM
            #MOD-5A0004 add
            DROP TABLE x
#           EXECUTE i100_pre_x                  #No.TQC-720019
            PREPARE i100_pre_x2 FROM g_sql_tmp  #No.TQC-720019
            EXECUTE i100_pre_x2                 #No.TQC-720019
            #MOD-5A0004 end
            CALL g_bgm.clear()
            OPEN i100_cnt
            #FUN-B50062-add-start--
            IF STATUS THEN
               CLOSE i100_cs
               CLOSE i100_cnt
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            FETCH i100_cnt INTO g_row_count
            #FUN-B50062-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i100_cs
               CLOSE i100_cnt
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50062-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i100_cs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i100_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE       #No.FUN-6A0057 g_no_ask
               CALL i100_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
#處理單身欄位(bgm03, bgm04, bgm05,bgm06,bgm07)輸入
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT #No.FUN-680061 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用  #No.FUN-680061 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否  #No.FUN-680061 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,      #處理狀態    #No.FUN-680061 VARCHAR(01)
    l_x             LIKE type_file.num5,      #FUN-680061  SMALLINT
    l_date,l_date1,l_date2    LIKE type_file.dat,     #FUN-680061 DATE
    l_occ45         LIKE occ_file.occ45,       
    l_allow_insert  LIKE type_file.num5,      #可新增否    #No.FUN-680061 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否    #No.FUN-680061 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_bgm_hd.bgm01 IS NULL THEN
        RETURN
    END IF
 
    IF s_shut(0) THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT bgm03, bgm04, '', bgm05, bgm06, bgm07,",
        "       bgm091,bgm092,bgm093,bgm094 FROM bgm_file ",
        "  WHERE bgm01 = ? AND bgm02 = ? AND bgm012 = ? AND bgm013 = ? ",
        "   AND bgm014 = ? AND bgm015 = ? AND bgm016 = ? AND bgm017 = ? ",
        "   AND bgm08  = ? AND bgm08_fac = ? AND bgm03 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_bgm WITHOUT DEFAULTS FROM s_bgm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEn
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                  #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_bgm_t.* = g_bgm[l_ac].*    #BACKUP
                OPEN i100_bcl USING g_bgm_hd.bgm01,g_bgm_hd.bgm02, g_bgm_hd.bgm012,g_bgm_hd.bgm013,g_bgm_hd.bgm014, g_bgm_hd.bgm015,g_bgm_hd.bgm016,g_bgm_hd.bgm017, g_bgm_hd.bgm08,g_bgm_hd.bgm08_fac,g_bgm_t.bgm03
                IF STATUS THEN
                   CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_bgm_t.bgm03,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                   FETCH i100_bcl INTO g_bgm[l_ac].*
                   CALL s_bga05(g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                                g_bgm[l_ac].bgm03, g_bgm_hd.bgm016)
                   RETURNING g_bgm[l_ac].bga05
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bgm[l_ac].* TO NULL
            LET g_bgm[l_ac].bgm091=0
            LET g_bgm[l_ac].bgm092=0
            LET g_bgm[l_ac].bgm093=0
            LET g_bgm[l_ac].bgm094=0
            LET g_bgm_t.* = g_bgm[l_ac].*        #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO bgm_file(bgm01,bgm012,bgm013,bgm014,bgm015,bgm016,  #No.MOD-470041
	                         bgm017,bgm02,bgm03,bgm04,bgm05,bgm06,bgm07,
                                  bgm08,bgm08_fac,bgm091,bgm092,bgm093,bgm094)   #No.MOD-560167
                 VALUES(g_bgm_hd.bgm01,g_bgm_hd.bgm012,g_bgm_hd.bgm013,
                        g_bgm_hd.bgm014,g_bgm_hd.bgm015,g_bgm_hd.bgm016,
	                g_bgm_hd.bgm017,g_bgm_hd.bgm02,g_bgm[l_ac].bgm03,
                        g_bgm[l_ac].bgm04,g_bgm[l_ac].bgm05,g_bgm[l_ac].bgm06,
                        g_bgm[l_ac].bgm07,g_bgm_hd.bgm08,g_bgm_hd.bgm08_fac,
                        0,0,0,0)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bgm[l_ac].bgm03,SQLCA.sqlcode,0) #FUN-660105
                CALL cl_err3("ins","bgm_file",g_bgm_hd.bgm01,g_bgm_hd.bgm012,SQLCA.sqlcode,"","",1) #FUN-660105
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b = g_rec_b + 1          #MOD-9B0099 add
	        CALL i100_sum()
                COMMIT WORK
            END IF
 
      AFTER FIELD bgm03
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_bgm[l_ac].bgm03) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_bgm_hd.bgm02
            IF g_azm.azm02 = 1 THEN
               IF g_bgm[l_ac].bgm03 > 12 OR g_bgm[l_ac].bgm03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bgm03
               END IF
            ELSE
               IF g_bgm[l_ac].bgm03 > 13 OR g_bgm[l_ac].bgm03 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bgm03
               END IF
            END IF
#            IF NOT cl_null(g_bgm[l_ac].bgm03) THEN
#               IF g_bgm[l_ac].bgm03 < 1
#                  OR g_bgm[l_ac].bgm03 > 12 THEN
#                  NEXT FIELD bgm03
#No.TQC-720032 -- end --
         ELSE
            IF g_bgm[l_ac].bgm03 <> g_bgm_t.bgm03 OR
               cl_null(g_bgm_t.bgm03) THEN
               LET l_n = 0
               SELECT COUNT(*)
                  INTO l_n
                  FROM bgm_file
                  WHERE bgm01 = g_bgm_hd.bgm01
                  AND bgm02 = g_bgm_hd.bgm02
                  AND bgm012 = g_bgm_hd.bgm012
                  AND bgm013 = g_bgm_hd.bgm013
                  AND bgm014 = g_bgm_hd.bgm014
                  AND bgm015 = g_bgm_hd.bgm015
                  AND bgm016 = g_bgm_hd.bgm016
                  AND bgm017 = g_bgm_hd.bgm017
                  AND bgm08  = g_bgm_hd.bgm08
                  AND bgm08_fac = g_bgm_hd.bgm08_fac
                  AND bgm03 = g_bgm[l_ac].bgm03
               IF l_n > 0 THEN
                  CALL cl_err( g_bgm[l_ac].bgm03, -239, 0)
                  NEXT FIELD bgm03
               END IF
            END IF   
         END IF
         SELECT occ45 INTO l_occ45 FROM occ_file
            WHERE occ01 = g_bgm_hd.bgm014
         LET l_x = cl_days(g_bgm_hd.bgm02,g_bgm[l_ac].bgm03)
         LET l_date = MDY(g_bgm[l_ac].bgm03,l_x,g_bgm_hd.bgm02)
#         CALL s_rdate2(g_bgm_hd.bgm014,l_occ45,l_date,l_date)
#         CALL s_rdatem(g_bgm_hd.bgm014,l_occ45,l_date,l_date,g_dbs)         #No.FUN-680022 mark
         #CALL s_rdatem(g_bgm_hd.bgm014,l_occ45,l_date,l_date,l_date,g_dbs)  #No.FUN-680022 #TQC-680074
#        CALL s_rdatem(g_bgm_hd.bgm014,l_occ45,l_date,l_date,l_date,g_dbs2)  #No.FUN-680022 #TQC-680074  #FUN-980020 mark
         CALL s_rdatem(g_bgm_hd.bgm014,l_occ45,l_date,l_date,l_date,g_plant2)#FUN-980020 
            RETURNING l_date1,l_date2
         LET g_bgm[l_ac].bgm06 = l_date1
         LET g_bgm[l_ac].bgm07 = l_date2
 
         AFTER FIELD bgm04
	    IF g_bgm[l_ac].bgm04 < 0 THEN
		NEXT FIELD bgm04
	    END IF
	    LET g_bgm[l_ac].bga05 =
            s_bga05( g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                     g_bgm[l_ac].bgm03, g_bgm_hd.bgm016)
 
        AFTER FIELD bgm05
            IF g_bgm[l_ac].bgm05 < 0 THEN
                NEXT FIELD bgm05
            END IF
            LET g_bgm[l_ac].bgm05 = s_digqty(g_bgm[l_ac].bgm05,g_bgm_hd.bgm08)    #FUN-910088--add--
            DISPLAY BY NAME g_bgm[l_ac].bgm05                                     #FUN-910088--add--
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_bgm_t.bgm03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bgm_file             #刪除該筆單身資料
                 WHERE bgm01 = g_bgm_hd.bgm01
                   AND bgm02 = g_bgm_hd.bgm02
                   AND bgm012 = g_bgm_hd.bgm012
                   AND bgm013 = g_bgm_hd.bgm013
                   AND bgm014 = g_bgm_hd.bgm014
		   AND bgm015 = g_bgm_hd.bgm015
		   AND bgm016 = g_bgm_hd.bgm016
		   AND bgm017 = g_bgm_hd.bgm017
		   AND bgm08  = g_bgm_hd.bgm08
		   AND bgm08_fac = g_bgm_hd.bgm08_fac
		   AND bgm03 = g_bgm_t.bgm03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bgm_t.bgm03,SQLCA.sqlcode,0) #FUN-660105
                    CALL cl_err3("del","bgm_file",g_bgm_hd.bgm01,g_bgm_t.bgm03,SQLCA.sqlcode,"","",1) #FUN-660105
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
		CALL i100_sum()
            END IF
        	COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bgm[l_ac].* = g_bgm_t.*
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bgm[l_ac].bgm03,-263,1)
               LET g_bgm[l_ac].* = g_bgm_t.*
            ELSE
               UPDATE bgm_file
                  SET  bgm03=g_bgm[l_ac].bgm03,
                       bgm04=g_bgm[l_ac].bgm04,
                       bgm05=g_bgm[l_ac].bgm05,
                       bgm06=g_bgm[l_ac].bgm06,
                       bgm07=g_bgm[l_ac].bgm07
                WHERE bgm01 = g_bgm_hd.bgm01
	          AND bgm02 = g_bgm_hd.bgm02
                  AND bgm012 = g_bgm_hd.bgm012
                  AND bgm013 = g_bgm_hd.bgm013
                  AND bgm014 = g_bgm_hd.bgm014
	          AND bgm015 = g_bgm_hd.bgm015
	          AND bgm016 = g_bgm_hd.bgm016
	          AND bgm017 = g_bgm_hd.bgm017
	          AND bgm08  = g_bgm_hd.bgm08
	          AND bgm08_fac = g_bgm_hd.bgm08_fac
	          AND bgm03 = g_bgm[l_ac].bgm03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_bgm[l_ac].bgm03, SQLCA.sqlcode, 0) #FUN-660105
                   CALL cl_err3("upd","bgm_file",g_bgm_hd.bgm01,g_bgm_hd.bgm02,SQLCA.sqlcode,"","",1) #FUN-660105
                   LET g_bgm[l_ac].* = g_bgm_t.*
                   ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
	           CALL i100_sum()
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_bgm[l_ac].* = g_bgm_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_bgm.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE i100_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac #FUN-D30032 add
            CLOSE i100_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i100_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(bgm03) AND l_ac > 1 THEN
                LET g_bgm[l_ac].* = g_bgm[l_ac-1].*
              #MOD-9B0099---add---start---
                LET g_bgm[l_ac].bgm03 = g_rec_b + 1        
                LET l_x = cl_days(g_bgm_hd.bgm02,g_bgm[l_ac].bgm03)
                LET l_date = MDY(g_bgm[l_ac].bgm03,l_x,g_bgm_hd.bgm02)
                CALL s_rdatem(g_bgm_hd.bgm014,l_occ45,l_date,l_date,l_date,g_dbs2) 
                   RETURNING l_date1,l_date2
                LET g_bgm[l_ac].bgm06 = l_date1
                LET g_bgm[l_ac].bgm07 = l_date2
              #MOD-9B0099---add---end---
                NEXT FIELD bgm03
            END IF
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
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
    
      ON ACTION controls                      #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")  #No.FUN-6B0033
 
        END INPUT
    CALL i100_delHeader()  #CHI-C30002 add
    CLOSE i100_bcl
    COMMIT WORK
#   CALL i100_delall()     #CHI-C30002 mark
END FUNCTION

#CHI-C30002 ------- add ------- begin
FUNCTION i100_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bgm_file
          WHERE bgm01 = g_bgm_hd.bgm01
            AND bgm02 = g_bgm_hd.bgm02
            AND bgm012 = g_bgm_hd.bgm012
            AND bgm013 = g_bgm_hd.bgm013
            AND bgm014 = g_bgm_hd.bgm014
            AND bgm015 = g_bgm_hd.bgm015
            AND bgm016 = g_bgm_hd.bgm016
            AND bgm017 = g_bgm_hd.bgm017
            AND bgm08  = g_bgm_hd.bgm08
            AND bgm08_fac= g_bgm_hd.bgm08_fac
         INITIALIZE g_bgm_hd.* TO NULL
         CLEAR FORM
      END IF
   END IF

END FUNCTION
#CHI-C30002 ------- add ------- end
#CHI-C30002 ------- mark -------- begin 
#FUNCTION i100_delall()
#   SELECT COUNT(*) INTO g_cnt
#     FROM bgm_file
#    WHERE bgm01 = g_bgm_hd.bgm01
#      AND bgm02 = g_bgm_hd.bgm02
#      AND bgm012 = g_bgm_hd.bgm012
#      AND bgm013 = g_bgm_hd.bgm013
#      AND bgm014 = g_bgm_hd.bgm014
#      AND bgm015 = g_bgm_hd.bgm015
#      AND bgm016 = g_bgm_hd.bgm016
#      AND bgm017 = g_bgm_hd.bgm017
#      AND bgm08  = g_bgm_hd.bgm08
#      AND bgm08_fac = g_bgm_hd.bgm08_fac
#
#   IF g_cnt = 0 THEN                      # 未輸入單身資料, 是否取消單頭資料
#       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#       ERROR g_msg CLIPPED
#       DELETE FROM bgm_file
#        WHERE bgm01 = g_bgm_hd.bgm01
#          AND bgm02 = g_bgm_hd.bgm02
#          AND bgm012 = g_bgm_hd.bgm012
#          AND bgm013 = g_bgm_hd.bgm013
#          AND bgm014 = g_bgm_hd.bgm014
#          AND bgm015 = g_bgm_hd.bgm015
#          AND bgm016 = g_bgm_hd.bgm016
#          AND bgm017 = g_bgm_hd.bgm017
#          AND bgm08  = g_bgm_hd.bgm08
#          AND bgm08_fac= g_bgm_hd.bgm08_fac
#   END IF
#END FUNCTION
#CHI-C30002 ------- mark -------- end
 
#單身重查
FUNCTION i100_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON bgm03, bgm04, bgm05,bgm06,bgm07
         FROM s_bgm[1].bgm03, s_bgm[1].bgm04, s_bgm[1].bgm05,
              s_bgm[1].bgm06, s_bgm[1].bgm07
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
    CALL i100_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)                      #BODY FILL UP
DEFINE
    p_wc2    LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
    LET g_sql =
        "SELECT bgm03, bgm04, '', bgm05,bgm06,bgm07, ",
        "       bgm091,bgm092,bgm093,bgm094",
        "  FROM bgm_file",
        " WHERE bgm01 ='", g_bgm_hd.bgm01, "' ",
	"   AND bgm02 =", g_bgm_hd.bgm02,
        "   AND bgm012 ='", g_bgm_hd.bgm012, "' ",
        "   AND bgm013 ='", g_bgm_hd.bgm013, "' ",
        "   AND bgm014 ='", g_bgm_hd.bgm014, "' ",
	"   AND bgm015 ='", g_bgm_hd.bgm015, "' ",
	"   AND bgm016 ='", g_bgm_hd.bgm016, "' ",
	"   AND bgm017 ='", g_bgm_hd.bgm017, "' ",
	"   AND bgm08  ='", g_bgm_hd.bgm08 , "' ",
	"   AND bgm08_fac =", g_bgm_hd.bgm08_fac,
	"   AND ", p_wc2 CLIPPED,
        " ORDER BY bgm03"
    PREPARE i100_pb
       FROM g_sql
    DECLARE i100_bcs                             #SCROLL CURSOR
     CURSOR FOR i100_pb
 
    CALL g_bgm.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH i100_bcs INTO g_bgm[g_cnt].*         #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL s_bga05(g_bgm_hd.bgm01, g_bgm_hd.bgm02,
                     g_bgm[g_cnt].bgm03, g_bgm_hd.bgm016)
        RETURNING g_bgm[g_cnt].bga05
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bgm.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i100_copy()
DEFINE
    old_ver     LIKE bgm_file.bgm01,       #原版本 #NO.FUN-680061 VARCHAR(10)
    oyy         LIKE bgm_file.bgm02,       #原年度 #NO.FUN-680061 VARCHAR(04)
    obgm016	LIKE bgm_file.bgm016,      #幣別
    obgm014	LIKE bgm_file.bgm014,	   #客戶編號
    obgm012	LIKE bgm_file.bgm012,	   #地區編號
    obgm015	LIKE bgm_file.bgm015,	   #部門編號
    obgm017	LIKE bgm_file.bgm017,	   #產品分類
    obgm08 	LIKE bgm_file.bgm08 ,	   #
    obgm08_fac  LIKE bgm_file.bgm08_fac,   #
    new_ver     LIKE bgm_file.bgm01,       #新版本   #NO.FUN-680061 VARCHAR(10)
    nyy         LIKE bgm_file.bgm02,       #新年度   #NO.FUN-680061 VARCHAR(04)
    l_i         LIKE type_file.num10,      #拷貝筆數 #No.FUN-680061 INTEGER
    l_bgm       RECORD  LIKE bgm_file.*    #複製用buffer
 
 
    OPEN WINDOW i100_c_w AT 09,20 WITH FORM "abg/42f/abgi100_c"
        ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_locale("abgi100_c")     #TQC-630053
 
    IF STATUS THEN
       CALL cl_err('open window i100_c_w:',STATUS,0)
       RETURN
    END IF
 WHILE TRUE
    LET old_ver = g_bgm_hd.bgm01
    LET oyy = g_bgm_hd.bgm02
    LET obgm016 =g_bgm_hd.bgm016
    LET obgm014 =g_bgm_hd.bgm014
    LET obgm012 =g_bgm_hd.bgm012
    LET obgm015 =g_bgm_hd.bgm015
    LET obgm017 =g_bgm_hd.bgm017
    LET obgm08  =g_bgm_hd.bgm08
    LET obgm08_fac = g_bgm_hd.bgm08_fac
    LET new_ver = NULL
    LET nyy = NULL
 
    INPUT old_ver, oyy, obgm016, obgm014, obgm012, obgm015,
          obgm017,obgm08,obgm08_fac,
          new_ver, nyy     WITHOUT DEFAULTS
     FROM old_ver, oyy, obgm016, obgm014, obgm012, obgm015,
          obgm017, obgm08 , obgm08_fac,
          new_ver, nyy
	
        AFTER FIELD old_ver
	    IF old_ver IS NULL THEN LET old_ver = ' ' END IF
 
        AFTER FIELD oyy
	    IF cl_null(oyy) OR oyy < 0 THEN
		NEXT FIELD oyy
	    END IF
 
        AFTER FIELD obgm016
	    IF NOT cl_null(obgm016) THEN
               SELECT azi01 FROM azi_file
                WHERE azi01 = obgm016 AND aziacti = 'Y'
		IF STATUS THEN
#                  CALL cl_err('sel azi:',STATUS,0) #FUN-660105
                   CALL cl_err3("sel","azi_file",obgm016,"",STATUS,"","sel azi:",1) #FUN-660105
                   NEXT FIELD obgm016
		END IF
	    END IF
 
        AFTER FIELD obgm014
	    IF NOT cl_null(obgm014) THEN
                CALL i100_bgm014('a',obgm014)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD obgm014
                END IF
	    END IF
 
	AFTER FIELD obgm015
	    IF NOT cl_null(obgm015) THEN
                CALL i100_bgm015('a',obgm015)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD obgm015
                END IF
	    END IF
 
	AFTER FIELD obgm017
	    IF NOT cl_null(obgm017) THEN
               CALL i100_bgm017c('a',obgm017)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD bgm017
               END IF
            END IF
 
       AFTER FIELD obgm08
           IF NOT cl_null(obgm08 ) THEN
               CALL i100_bgm08c('a',obgm08,old_ver,obgm017 )
               RETURNING obgm08_fac
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD obgm08
               END IF
           END IF
 
        AFTER FIELD new_ver
	    IF new_ver IS NULL THEN LET new_ver = ' ' END IF
 
        AFTER FIELD nyy
	    IF cl_null(nyy) OR nyy < 0 THEN
               NEXT FIELD nyy
	    END IF
      ON ACTION CONTROLP
           CASE
		WHEN INFIELD(obgm012)
                #    CALL q_gea(8 ,32, obgm012) RETURNING obgm012
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gea"
                     LET g_qryparam.default1 = obgm012
                     CALL cl_create_qry() RETURNING obgm012
		     DISPLAY BY NAME obgm012
		WHEN INFIELD(obgm014)
                #    CALL q_occ(8 ,32, obgm014) RETURNING obgm014
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_occ"
                     LET g_qryparam.default1 = obgm014
                     CALL cl_create_qry() RETURNING obgm014
		     DISPLAY BY NAME obgm014
                WHEN INFIELD(obgm015)
                #    CALL q_gem(8 ,32,obgm015) RETURNING obgm015
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = obgm015
                     CALL cl_create_qry() RETURNING obgm015
                     DISPLAY BY NAME obgm015
		WHEN INFIELD(obgm016)
		#    LET g_qryparam.state = 'c' #FUN-980030
		#    LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#    CALL q_azi( 8,32, obgm016) RETURNING obgm016
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azi"
                     LET g_qryparam.default1 = obgm016
                     CALL cl_create_qry() RETURNING obgm016
		     DISPLAY BY NAME obgm016
		WHEN INFIELD(obgm017)
		#    LET g_qryparam.state = 'c' #FUN-980030
		#    LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#    CALL q_ima(8 ,32, obgm017) RETURNING obgm017
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form ="q_ima"
                 #    LET g_qryparam.default1=obgm017
                 #    CALL cl_create_qry() RETURNING obgm017
                     CALL q_sel_ima(FALSE, "q_ima", "",obgm017, "", "", "", "" ,"",'' )  RETURNING obgm017
#FUN-AA0059 --End--
		     DISPLAY BY NAME obgm017
		WHEN INFIELD(obgm08 )
		#    LET g_qryparam.state = 'c' #FUN-980030
		#    LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
		#    CALL q_gfe(8 ,32, obgm08 ) RETURNING obgm08
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1=obgm08
                     CALL cl_create_qry() RETURNING obgm08
		     DISPLAY BY NAME obgm08
            END CASE
 
       ON ACTION CONTROLE
           CASE
               WHEN INFIELD(obgm017)
               #   CALL q_oba(8,32, obgm017)
               #       RETURNING obgm017
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_oba"
                    LET g_qryparam.default1 = obgm017
                    CALL cl_create_qry() RETURNING obgm017
                   DISPLAY obgm017 TO bgm017
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
    IF INT_FLAG THEN
	LET INT_FLAG=0
        CLOSE WINDOW i100_c_w
	RETURN
    END IF
   IF cl_null(new_ver) OR cl_null(nyy      ) THEN
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
    CLOSE WINDOW i100_c_w
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0033
    BEGIN WORK
    LET g_success='Y'
    DECLARE i100_c CURSOR FOR
        SELECT *
          FROM bgm_file
         WHERE bgm01 = old_ver
           AND bgm02 = oyy
           AND bgm016 = obgm016
	       AND bgm014 = obgm014
           AND bgm012 = obgm012
	       AND bgm015 = obgm015
	       AND bgm017 = obgm017
	       AND bgm08  = obgm08
	       AND bgm08_fac = obgm08_fac
    LET l_i = 0
    FOREACH i100_c INTO l_bgm.*
        LET l_i = l_i+1
        LET l_bgm.bgm01 = new_ver
        LET l_bgm.bgm02 = nyy
        INSERT INTO bgm_file VALUES(l_bgm.*)
        IF STATUS THEN
#           CALL cl_err('ins bgm:',STATUS,1) #FUN-660105
            CALL cl_err3("ins","bgm_file",l_bgm.bgm01,l_bgm.bgm02,STATUS,"","ins bgm:",1) #FUN-660105
            LET g_success='N'
        END IF
    END FOREACH
    IF g_success='Y' THEN
        COMMIT WORK
        #FUN-C30027---begin
        LET g_bgm_hd.bgm01 = new_ver
        LET g_bgm_hd.bgm02 = nyy
        LET g_bgm_hd.bgm016 = obgm016
        LET g_bgm_hd.bgm014 = obgm014
        LET g_bgm_hd.bgm012 = obgm012
        LET g_bgm_hd.bgm015 = obgm015
        LET g_bgm_hd.bgm017 = obgm017
        LET g_bgm_hd.bgm08 = obgm08
        LET g_bgm_hd.bgm08_fac = obgm08_fac
        LET g_wc = '1=1'
        CALL i100_show()          
        #FUN-C30027---end  
        MESSAGE l_i, ' rows copied!'
    ELSE
        ROLLBACK WORK
        MESSAGE 'rollback work!'
    END IF
END FUNCTION
 
#單身顯示
FUNCTION i100_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1      #No.FUN-680061 VARCHAR(01)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   #DISPLAY ARRAY g_bgm TO s_bgm.* ATTRIBUTE(COUNT=g_rec_b)     #TQC-630053
   DISPLAY ARRAY g_bgm TO s_bgm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)     #TQC-630053
 
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
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i100_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i100_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i100_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i100_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i100_fetch('L')
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
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel   #No.FUN-4B0021
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0003  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i100_sum()
    DEFINE
	l_tot1	    LIKE type_file.num20_6, #No.FUN-680061 DECIMAL(20,6)
	l_tot2	    LIKE type_file.num20_6, #No.FUN-680061 DECIMAL(20,6)
	l_tot_c	    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
	l_cnt	      LIKE type_file.num5   #No.FUN-680061 SMALLINT
 
    LET l_tot1 = 0
    LET l_tot2 = 0
 
    SELECT COUNT(*) INTO l_tot_c
      FROM bgm_file
     WHERE bgm01 = g_bgm_hd.bgm01
       AND bgm02 = g_bgm_hd.bgm02
       AND bgm012 = g_bgm_hd.bgm012
       AND bgm013 = g_bgm_hd.bgm013
       AND bgm014 = g_bgm_hd.bgm014
       AND bgm015 = g_bgm_hd.bgm015
       AND bgm016 = g_bgm_hd.bgm016
       AND bgm017 = g_bgm_hd.bgm017
       AND bgm08  = g_bgm_hd.bgm08
       AND bgm08_fac = g_bgm_hd.bgm08_fac
 
    FOR l_cnt = 1 TO l_tot_c
	LET l_tot1 = l_tot1 + ( g_bgm[l_cnt].bgm04
			      * g_bgm[l_cnt].bga05
			      * g_bgm[l_cnt].bgm05 )
	LET l_tot2 = l_tot2 + g_bgm[l_cnt].bgm05 * ( g_bgm[l_cnt].bgm091
						   + g_bgm[l_cnt].bgm092
						   + g_bgm[l_cnt].bgm093
						   + g_bgm[l_cnt].bgm094)
    END FOR
 
    DISPLAY l_tot1, l_tot2 TO tot1, tot2
 
END FUNCTION
 
FUNCTION i100_out()
DEFINE l_cmd LIKE type_file.chr1000,        #No.FUN-680061 VARCHAR(400)
       l_wc,l_wc2    LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(1300)
       l_prtway      LIKE zz_file.zz22
 
    CALL cl_wait()
 
    IF cl_null(g_wc) THEN
       #-----TQC-610054---------
       LET l_wc=' bgm012="',g_bgm_hd.bgm012,'" ',
                ' AND bgm014="',g_bgm_hd.bgm014,'" ',
                ' AND bgm013="',g_bgm_hd.bgm013,'" ',
                ' AND bgm015="',g_bgm_hd.bgm015,'" '
       #LET l_wc=' bgm01="',g_bgm_hd.bgm01,'" ',
       #         ' AND bgm02="',g_bgm_hd.bgm02,'" ',
       #         ' AND bgm017="',g_bgm_hd.bgm017,'" '
       #-----END TQC-610054-----
    ELSE
       LET l_wc=g_wc CLIPPED
    END IF
    SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
     WHERE zz01 = 'abgr503'
    IF SQLCA.sqlcode OR l_wc2 IS NULL OR l_wc = ' ' THEN
       #LET l_wc2 = " 'Y' 'Y' 'Y' "   #TQC-610054
      #LET l_wc2 = " '' ''  '' 'NNN' 'NNN' 'default' 'default' 'voucher' "   #TQC-610054    #No.TQC-760066 mark
       LET l_wc2 = " '' ''  '' 'NNN' 'NNN' 'default' 'default' 'template1' "   #No.TQC-760066  #報表類型已更改，則voucher應改為template1型
    END IF
    LET l_cmd = "abgr503 ",
                " '",g_today CLIPPED,"' ''",
                " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1' ",
                #" '",l_wc CLIPPED,"' ",l_wc2       #TQC-610054
                " \"",l_wc CLIPPED,"\"",l_wc2       #TQC-610054
    CALL cl_cmdrun(l_cmd)
    ERROR ' '
 
END FUNCTION
 
#No.FUN-570108--begin
FUNCTION i100_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("bgm01,bgm012,bgm02,bgm08,bgm017,bgm013,bgm014,bgm015,bgm016",TRUE)
   END IF
END FUNCTION
 
FUNCTION i100_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680061 VARCHAR(01)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("bgm01,bgm012,bgm02,bgm08,bgm017,bgm013,bgm014,bgm015,bgm016",FALSE)
   END IF
END FUNCTION
#No.FUN-570108--end
#Patch....NO.TQC-610035 <001,002> #

#FUN-910088--add--start--
FUNCTION i100_bgm08_check(p_update)
   DEFINE p_update LIKE type_file.chr1
   DEFINE l_ac1 LIKE type_file.num5
   IF g_rec_b > 0 AND g_bgm08_t != g_bgm_hd.bgm08 THEN
      FOR l_ac1 = 1  TO g_rec_b
         LET g_bgm[l_ac1].bgm05 = s_digqty(g_bgm[l_ac1].bgm05,g_bgm_hd.bgm08)
         DISPLAY BY NAME g_bgm[l_ac1].bgm05 
         IF p_update = 'u' THEN
            UPDATE bgm_file SET bgm05 = g_bgm[l_ac1].bgm05
             WHERE bgm01 = g_bgm_hd.bgm01
               AND bgm02 = g_bgm_hd.bgm02
               AND bgm012 = g_bgm_hd.bgm012
               AND bgm013 = g_bgm_hd.bgm013 
               AND bgm014 = g_bgm_hd.bgm014 
               AND bgm015 = g_bgm_hd.bgm015 
               AND bgm016 = g_bgm_hd.bgm016 
               AND bgm017 = g_bgm_hd.bgm017
               AND bgm08  = g_bgm_hd.bgm08 
               AND bgm08_fac = g_bgm_hd.bgm08_fac  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","bgm_file",g_bgm_hd_t.bgm01,g_bgm_hd_t.bgm02,SQLCA.sqlcode,"","",1) 
            END IF 
         END IF
      END FOR
   END IF
END FUNCTION
#FUN-910088--add--end--
