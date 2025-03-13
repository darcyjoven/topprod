# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi253.4gl
# Descriptions...: 料件�供應商關係資料維護作業-品名規格額外說明維護
# Date & Author..: 90/11/18 By Wu
# MODIFY         : 90/11/20 By MAY
# MODIFY         : 95/11/01 By Yin
# Modify.........: No.MOD-480230 04/08/10 By Wiky CONSTRUCT 參數寫
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-580013 05/08/15 By Nigel 改新報表格式
# Modify.........: No.TQC-5B0110 05/11/12 By CoCo 料號位置調整
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/15 By jamie 判斷pmcacti
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860182 08/06/17 By Smapmin 無法由apmi254串接過來
# Modify.........: No.MOD-870255 08/07/22 By Smapmin 由apmi254串接過來時,將原本會先進入查詢然後才可以輸入的方式,改為直接輸入的方式
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.FUN-9A0078 09/10/26 By wujie 5.2转SQL标准语法
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-960296 10/03/04 By vealxu 1.在_cs()段卻有可能組到pmhuser/pmhgrup這些條件，但撈資料join table未包含pmh_file
#                                                   2.在_show()段撈pmh03時，對pmh_file下的條件不是全部的key值，所以會發生回傳多筆資料的-284錯誤，雖然l_pmh03還是會有值..這不知道算不算要改的bug(比如改成fetch的寫法)          
#                                                   3.在AFTER FIELD pmq02也有第2點的問題，這邊如果不改，只要回傳多筆(有sqlca.code)就不能離開這個欄位
#                                                   4.在fetch段撈資料跟算筆數是用distinct pmq01,pmq02,pmq03出來，但在做b_fill是用pmq01,pmq02去撈, pmq03非key值欄位之一，這樣去合不起來
#                                                   5.新增狀況下，如果g_ss = Y，會先跑b_fill()段，但又把g_rec_b清為0，這樣進入_b()段會出錯
# Modify.........: No.FUN-A50010 10/05/04 By vealxu TQC-960296 修正
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B70131 11/07/17 by JoHung 修改TQC-720019
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_pmq01         LIKE pmq_file.pmq01,   #料件編號
        g_pmq01_t       LIKE pmq_file.pmq01,   #
        g_pmq02         LIKE pmq_file.pmq02,   #廠商編號
        g_pmq02_t       LIKE pmq_file.pmq02,   #
        g_pmq03         LIKE pmq_file.pmq03,   #廠商料號
        g_pmq03_t       LIKE pmq_file.pmq03,   #廠商料號(舊值)
    g_pmq           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pmq04           LIKE pmq_file.pmq04,   #行序
        pmq05           LIKE pmq_file.pmq05    #說明
                    END RECORD,
    g_pmq_t         RECORD                     #程式變數 (舊值)
        pmq04           LIKE pmq_file.pmq04,   #行序
        pmq05           LIKE pmq_file.pmq05    #說明
                    END RECORD,
        g_ss            LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
        l_flag          LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
        g_delete        LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1) 
        g_wc,g_sql      STRING,#TQC-630166
        g_rec_b         LIKE type_file.num5,   #單身筆數               #No.FUN-680136 SMALLINT
        l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680136 SMALLINT
        g_argv1         LIKE pmq_file.pmq01,   #料號
        g_argv2         LIKE pmq_file.pmq02,   #供應商編號
        g_argv3         LIKE pmh_file.pmhacti, #資料有效碼
        g_pmc03         LIKE pmc_file.pmc03,
        l_pmh03         LIKE pmh_file.pmh03,
        l_pmq03         LIKE pmq_file.pmq03
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp        STRING   #No.TQC-720019
DEFINE   g_chr          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose #No.FUN-680136 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE   g_sma         RECORD LIKE sma_file.* #No.TQC-960295 add  


MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818

    LET g_pmq01 = g_argv1
    LET g_pmq02 = g_argv2
    INITIALIZE g_pmq_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM pmq_file WHERE pmq01 = ? AND pmq02 = ? AND pmq04 = ? FOR UPDATE"   #No.FUN-9A0078
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i253_crl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    OPEN WINDOW i253_w WITH FORM "apm/42f/apmi253"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL i253_q()
       CALL i253_b()
    END IF
    CALL i253_menu()
    CLOSE WINDOW i253_w

    CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i253_cs()
 DEFINE  l_pmh03   LIKE pmh_file.pmh03
   CLEAR FORM                             #清除畫面
   CALL g_pmq.clear()
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
      DISPLAY g_pmq01 TO pmq01
      DISPLAY g_pmq02 TO pmq02
      DECLARE i253_pmh_cs4 SCROLL CURSOR FOR                         #TQC-960296
      SELECT pmh04,pmh03
#       INTO g_pmq03,l_pmh03                                         #TQC-960296
        FROM pmh_file
       WHERE pmh01 = g_pmq01 AND pmh02 = g_pmq02
         AND pmh21 = ' '                                             #CHI-860042                                                    
         AND pmh22 = '1'                                             #CHI-860042
         AND pmh23 = ' '                                             #No.CHI-960033
         AND pmhacti = 'Y'                                           #CHI-910021
      OPEN i253_pmh_cs4                                              #TQC-960296
      FETCH FIRST i253_pmh_cs4 INTO g_pmq03,l_pmh03                  #TQC-960296  
      IF SQLCA.SQLCODE THEN
         LET g_pmq03 = " "
      END IF
      DISPLAY g_pmq03 TO pmq03
      DISPLAY l_pmh03 TO FORMONLY.pmh03
      CALL i253_pmq02('d')
 
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      #INITIALIZE g_pmq02 TO NULL    #No.FUN-750051   #MOD-860182
      #INITIALIZE g_pmq03 TO NULL    #No.FUN-750051   #MOD-860182
      #INITIALIZE g_pmq01 TO NULL    #No.FUN-750051   #MOD-860182
      #-----MOD-870255---------
      #CONSTRUCT g_wc ON pmq04,pmq05    #螢幕上取條件
      #     FROM s_pmq[1].pmq04,s_pmq[1].pmq05
      #        #No.FUN-580031 --start--     HCN
      #        BEFORE CONSTRUCT
      #           CALL cl_qbe_init()
      #        #No.FUN-580031 --end--       HCN
      #   ON IDLE g_idle_seconds
      #      CALL cl_on_idle()
      #      CONTINUE CONSTRUCT
      #
      #ON ACTION about         #MOD-4C0121
      #   CALL cl_about()      #MOD-4C0121
      #
      #ON ACTION help          #MOD-4C0121
      #   CALL cl_show_help()  #MOD-4C0121
      #
      #ON ACTION controlg      #MOD-4C0121
      #   CALL cl_cmdask()     #MOD-4C0121
      #
      #  	#No.FUN-580031 --start--     HCN
      #           ON ACTION qbe_select
      #   	   CALL cl_qbe_select()
      #           ON ACTION qbe_save
      #  	   CALL cl_qbe_save()
      #  	#No.FUN-580031 --end--       HCN
      #END CONSTRUCT
      LET g_wc = "1=1"
      #-----END MOD-870255-----
      LET g_wc = g_wc CLIPPED," AND pmq01 ='",g_argv1,"'",
                              " AND pmq02 ='",g_argv2,"'"
   ELSE
      CONSTRUCT g_wc ON pmq01,pmq03,pmq02,pmq04,pmq05  #螢幕上取條件
           FROM pmq01,pmq03,pmq02,s_pmq[1].pmq04,s_pmq[1].pmq05
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(pmq02) #廠商編號
#                 CALL q_pmc1(0,0,g_pmq02) RETURNING g_pmq02
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_pmc1"
                  LET g_qryparam.default1 = g_pmq02
                   CALL cl_create_qry() RETURNING g_qryparam.multiret   #No.MOD-480230
                   DISPLAY g_qryparam.multiret TO pmq02                 #No.MOD-480230
                  CALL i253_pmq02('d')
                  NEXT FIELD pmq02
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
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND pmhuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND pmhgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND pmhgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmhuser', 'pmhgrup')
   #End:FUN-980030
 
 
   LET g_sql= "SELECT UNIQUE pmq02,pmq03,pmq01 FROM pmq_file ",
              " LEFT OUTER JOIN pmh_file ",                       #TQC-960296
              " ON pmq_file.pmq02 = pmh_file.pmh02",              #TQC-960296
              " AND pmq_file.pmq01 = pmh_file.pmh01",              #TQC-960296
              " WHERE ", g_wc CLIPPED, 
              " ORDER BY pmq01"
   PREPARE i253_prepare FROM g_sql      #預備一下
   DECLARE i253_b_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i253_prepare
 
   LET g_sql_tmp= "SELECT UNIQUE pmq02,pmq03,pmq01 FROM pmq_file ",  #No.TQC-720019
#                 " OUTER pmh_file ",                                #No.TQC-960296  #FUN-A50010 mark
                  " LEFT OUTER JOIN pmh_file ",                      #No.FUN-A50010
                  " ON pmq_file.pmq02 = pmh_file.pmh02",             #No.FUN-A50010   
                  " AND pmq_file.pmq01=pmh_file.pmh01",              #No.FUN-A50010   
                  " WHERE ", g_wc CLIPPED,
#                 " AND pmq_file.pmq02 = pmh_file.pmh02",            #No.TQC-960296  mark
#                 " AND pmq_file.pmq01=pmh_file.pmh01",              #No.TQC-960296  mark
                  " INTO TEMP x"
   DROP TABLE x
   PREPARE i253_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i253_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x"
   PREPARE i253_precount FROM g_sql
   DECLARE i253_count CURSOR FOR i253_precount
 
END FUNCTION
 
FUNCTION i253_menu()
 
   WHILE TRUE
      CALL i253_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i253_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i253_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i253_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i253_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i253_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i253_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmq),'','')
            END IF
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_pmq02 IS NOT NULL THEN
                LET g_doc.column1 = "pmq02"
                LET g_doc.column2 = "pmq03"
                LET g_doc.column3 = "pmq01"
                LET g_doc.value1 = g_pmq02
                LET g_doc.value2 = g_pmq03
                LET g_doc.value3 = g_pmq01
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i253_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_pmq.clear()
   INITIALIZE g_pmq01 LIKE  pmq_file.pmq01
   INITIALIZE g_pmq02 LIKE  pmq_file.pmq02
   LET g_pmq01_t  = NULL
   LET g_pmq02_t  = NULL
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i253_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_pmq01=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_pmq.clear()
      ELSE
         CALL i253_b_fill('1=1')      #單身
      END IF
#     IF cl_null(g_rec_b) THEN        #No.TQC-960296   #MOD-B70131 mark
         LET g_rec_b =0               #NO.FUN-680064 
#     END IF                          #No.TQC-960296   #MOD-B70131 mark
      CALL i253_b()                   #輸入單身
 
      LET g_pmq01_t = g_pmq01
      LET g_pmq02_t = g_pmq02
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i253_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改 #No.FUN-680136 VARCHAR(1)
    l_n             LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    l_str           LIKE aaf_file.aaf03      #No.FUN-680136 VARCHAR(40)
 
    LET g_ss='Y'
    DISPLAY  g_pmq01,g_pmq02 TO pmq01,pmq02
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_pmq01,g_pmq02 WITHOUT DEFAULTS FROM pmq01,pmq02
 
        BEFORE FIELD pmq01
           IF g_sma.sma60 = 'Y' THEN
              CALL s_inp5(7,13,g_pmq01) RETURNING g_pmq01
              DISPLAY g_pmq01 TO pmq01
           END IF

        AFTER FIELD pmq01                   #料件編號
           IF NOT cl_null(g_pmq01) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_pmq01,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_pmq01= g_pmq01_t
                 NEXT FIELD pmq01
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              CALL i253_pmq01(g_pmq01)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pmq01,g_errno,0)
                 LET g_pmq01  = g_pmq01_t
                 DISPLAY BY NAME g_pmq01
                 NEXT FIELD pmq01
              END IF
              IF g_pmq01 != g_pmq01_t OR g_pmq01_t IS NULL THEN
                 SELECT UNIQUE pmq01 INTO g_chr
                   FROM pmq_file
                  WHERE pmq01=g_pmq01
                 IF SQLCA.sqlcode THEN             #不存在, 新來的
                    IF p_cmd='a' THEN
                       LET g_ss='N'
                    END IF
                 ELSE
                    IF p_cmd='u' THEN
                       CALL cl_err(g_pmq01,-239,0)
                       LET g_pmq01=g_pmq01_t
                       NEXT FIELD pmq01
                    END IF
                 END IF
              END IF
           END IF
 
        AFTER FIELD pmq02     #供應商
           IF NOT cl_null(g_pmq02) THEN
             SELECT COUNT(*) INTO l_n FROM pmq_file
              WHERE pmq01 = g_pmq01
                AND pmq02 = g_pmq02
             IF l_n > 0 THEN
                LET l_str = g_pmq01 CLIPPED,'+',g_pmq02
                CALL cl_err(l_str,'mfg0003',0)
                NEXT FIELD pmq01
             END IF
 
             DECLARE i253_pmh_cs SCROLL CURSOR FOR                          #TQC-960296
             SELECT pmh03,pmh04
#              INTO l_pmh03,g_pmq03                                         #TQC-960296
               FROM pmh_file
              WHERE pmh01 = g_pmq01 AND pmh02 = g_pmq02
                AND pmh21 = " "                                             #CHI-860042                                             
                AND pmh22 = '1'                                             #CHI-860042
                AND pmh23 = ' '                                             #No.CHI-960033
                AND pmhacti = 'Y'                                           #CHI-910021
             IF SQLCA.sqlcode  THEN
                LET g_msg = g_pmq01  CLIPPED,'+',g_pmq02
#               CALL cl_err(g_msg,'mfg0031',0)   #No.FUN-660129
                CALL cl_err3("sel","pmh_file",g_pmq01,g_pmq02,"mfg0031","","",1)  #No.FUN-660129
                NEXT FIELD pmq01
             ELSE
                DISPLAY g_pmq03 TO pmq03
                DISPLAY l_pmh03 TO FORMONLY.pmh03
             END IF
 
             CALL i253_pmq02('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_pmq02,g_errno,0)
                LET g_pmq02 = g_pmq02_t
                DISPLAY BY NAME g_pmq02
                NEXT FIELD pmq02
             END IF
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(pmq02) #廠商編號
#                CALL q_pmc1(0,0,g_pmq02) RETURNING g_pmq02
#                CALL FGL_DIALOG_SETBUFFER( g_pmq02 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc1"
                 LET g_qryparam.default1 = g_pmq02
                 CALL cl_create_qry() RETURNING g_pmq02
#                 CALL FGL_DIALOG_SETBUFFER( g_pmq02 )
                  DISPLAY BY NAME g_pmq02
                  CALL i253_pmq02('d')
                  NEXT FIELD pmq02
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
END FUNCTION
 
FUNCTION i253_pmq02(p_cmd)  #供應商
    DEFINE p_cmd    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
           l_pmc03   LIKE pmc_file.pmc03,
           l_pmcacti LIKE pmc_file.pmcacti
 
   LET g_errno = ' '
   SELECT pmc03,pmcacti
     INTO l_pmc03,l_pmcacti
     FROM pmc_file
     WHERE pmc01 = g_pmq02
 
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
                             LET l_pmc03 = NULL
          WHEN l_pmcacti='N' LET g_errno = '9028'
          WHEN l_pmcacti MATCHES '[PH]'   LET g_errno = '9038'  #FUN-FUN-690024 add 
          OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO pmc03
   END IF
 
END FUNCTION
 
FUNCTION i253_pmq01(p_item)  #料件編號
    DEFINE l_imaacti LIKE ima_file.imaacti,
           p_item    LIKE ima_file.ima01
 
  LET g_errno = ' '
  SELECT imaacti INTO l_imaacti
    FROM ima_file
    WHERE ima01 = p_item
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i253_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    IF cl_null(g_argv1) THEN   #MOD-860182
       INITIALIZE g_pmq01 TO NULL              #No.FUN-6A0162
       INITIALIZE g_pmq02 TO NULL              #No.FUN-6A0162
    END IF   #MOD-860182
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pmq.clear()
 
   CALL i253_cs()                           #取得查詢條件
 
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_pmq01 TO NULL
      INITIALIZE g_pmq02 TO NULL
      RETURN
   END IF
 
   OPEN i253_b_cs                           #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmq01 TO NULL
      INITIALIZE g_pmq02 TO NULL
   ELSE
      OPEN i253_count
      FETCH i253_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i253_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i253_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i253_b_cs INTO g_pmq02,g_pmq03,g_pmq01
        WHEN 'P' FETCH PREVIOUS i253_b_cs INTO g_pmq02,g_pmq03,g_pmq01
        WHEN 'F' FETCH FIRST    i253_b_cs INTO g_pmq02,g_pmq03,g_pmq01
        WHEN 'L' FETCH LAST     i253_b_cs INTO g_pmq02,g_pmq03,g_pmq01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump i253_b_cs INTO g_pmq02,g_pmq03,g_pmq01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       IF cl_null(g_argv1) THEN   #MOD-860182
          CALL cl_err(g_pmq01,SQLCA.sqlcode,0)
          INITIALIZE g_pmq01 TO NULL  #TQC-6B0105
          INITIALIZE g_pmq02 TO NULL  #TQC-6B0105
          INITIALIZE g_pmq03 TO NULL  #TQC-6B0105
       END IF   #MOD-860182
    ELSE
       OPEN i253_count
       FETCH i253_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
 
       CALL i253_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i253_show()
 
    DISPLAY g_pmq01 TO pmq01               #單頭
    DISPLAY g_pmq02 TO pmq02               #單頭
 
    DECLARE i253_pmh_cs1 SCROLL CURSOR FOR                         #TQC-960296
    SELECT pmh03
#     INTO l_pmh03                                                 #TQC-960296
      FROM pmh_file
     WHERE g_pmq01 = pmh01 AND g_pmq02 = pmh02
       AND pmh21 = " "                                             #CHI-860042                                                      
       AND pmh22 = '1'                                             #CHI-860042
       AND pmh23 = ' '                                             #No.CHI-960033
       AND pmhacti = 'Y'                                           #CHI-910021
 
    OPEN i253_pmh_cs1                                              #TQC-960296
    FETCH FIRST i253_pmh_cs1 INTO l_pmh03                          #TQC-960296

    IF SQLCA.sqlcode THEN LET l_pmh03 = NULL END IF

    DECLARE i253_pmh_cs2 SCROLL CURSOR FOR                         #TQC-960296
    SELECT pmh04
#     INTO g_pmq03                                                 #TQC-960296
      FROM pmh_file
     WHERE g_pmq01 = pmh01 AND g_pmq02 = pmh02
       AND pmh21 = " "                                             #CHI-860042                                                      
       AND pmh22 = '1'                                             #CHI-860042
       AND pmh23 = ' '                                             #No.CHI-960033
       AND pmhacti = 'Y'                                           #CHI-910021
    OPEN i253_pmh_cs2                                              #TQC-960296
    FETCH FIRST i253_pmh_cs2 INTO g_pmq03                          #TQC-960296 
 
    IF SQLCA.sqlcode THEN LET g_pmq03 = NULL END IF
    DISPLAY g_pmq03 TO pmq03
    DISPLAY l_pmh03 TO pmh03
    CALL i253_pmq02('d')                #單身
 
    CALL i253_b_fill(g_wc)              #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i253_r()
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_pmq01 IS NULL THEN
       CALL cl_err("",-400,0)                 #No.FUN-6A0162
       RETURN
    END IF
 
    BEGIN WORK
 
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pmq02"      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "pmq03"      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "pmq01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pmq02       #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_pmq03       #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_pmq01       #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM pmq_file WHERE pmq01 = g_pmq01 AND pmq02 = g_pmq02
       IF SQLCA.sqlcode THEN
#         CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)   #No.FUN-660129
          CALL cl_err3("del","pmq_file",g_pmq01,g_pmq02,SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660129
       ELSE
          CLEAR FORM
          CALL g_pmq.clear()
          LET g_cnt=SQLCA.SQLERRD[3]
          LET g_delete = 'Y'
          MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
          IF NOT cl_null(g_sql_tmp) THEN   #MOD-B70131 add
             DROP TABLE x
#            EXECUTE i253_precount_x                  #No.TQC-720019
             PREPARE i253_precount_x2 FROM g_sql_tmp  #No.TQC-720019
             EXECUTE i253_precount_x2                 #No.TQC-720019
          END IF                           #MOD-B70131 add
          OPEN i253_count
          #FUN-B50063-add-start--
          IF STATUS THEN
             CLOSE i253_b_cs
             CLOSE i253_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end-- 
          FETCH i253_count INTO g_row_count
          #FUN-B50063-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i253_b_cs
             CLOSE i253_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50063-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i253_b_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i253_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET g_no_ask = TRUE
             CALL i253_fetch('/')
          END IF
       END IF
    END IF
 
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i253_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_str           LIKE type_file.chr20,               #No.FUN-680136 VARCHAR(20)
    l_acti          LIKE pmh_file.pmhacti,
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680136 SMALLINT
 
    IF s_shut(0)  THEN RETURN END IF
    IF g_pmq01 IS NULL  THEN
       RETURN
    END IF
    IF g_argv3 = 'N' THEN CALL cl_err('','mfg3028',0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_action_choice = ""
    LET g_forupd_sql = "SELECT pmq04,pmq05 FROM pmq_file",
                       "  WHERE pmq01=? AND pmq02 =?",
                       "   AND pmq04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i253_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmq WITHOUT DEFAULTS FROM s_pmq.*
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
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_pmq_t.* = g_pmq[l_ac].*  #BACKUP
              OPEN i253_bcl USING g_pmq01,g_pmq02,g_pmq_t.pmq04
              IF STATUS THEN
                 CALL cl_err("OPEN i253_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i253_bcl INTO g_pmq[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pmq_t.pmq04,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pmq[l_ac].* TO NULL      #900423
           LET g_pmq_t.* = g_pmq[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD pmq04
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO pmq_file(pmq01,pmq02,pmq03,pmq04,pmq05)
           VALUES(g_pmq01,g_pmq02,g_pmq03,g_pmq[l_ac].pmq04,g_pmq[l_ac].pmq05)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_pmq[l_ac].pmq04,SQLCA.sqlcode,0)   #No.FUN-660129
              CALL cl_err3("ins","pmq_file",g_pmq01,g_pmq02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD pmq04                        # dgeeault 序號
           IF cl_null(g_pmq[l_ac].pmq04) OR g_pmq[l_ac].pmq04 = 0 THEN
              SELECT max(pmq04)+1 INTO g_pmq[l_ac].pmq04 FROM pmq_file
               WHERE pmq01 = g_pmq01 AND pmq02 = g_pmq02
              IF g_pmq[l_ac].pmq04 IS NULL THEN
                 LET g_pmq[l_ac].pmq04 = 1
              END IF
           END IF
 
        AFTER FIELD pmq04                        #check 序號是否重複
           IF NOT cl_null(g_pmq[l_ac].pmq04) AND
              (g_pmq[l_ac].pmq04 != g_pmq_t.pmq04 OR
               g_pmq_t.pmq04 IS NULL) THEN
              SELECT count(*) INTO l_n
                FROM pmq_file
               WHERE pmq01 = g_pmq01 AND pmq02 = g_pmq02
                 AND pmq04 = g_pmq[l_ac].pmq04
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_pmq[l_ac].pmq04 = g_pmq_t.pmq04
                 NEXT FIELD pmq04
              END IF
           END IF
           LET g_cnt = g_cnt + 1
 
        BEFORE DELETE                            #是否取消單身
           IF g_pmq_t.pmq04 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pmq_file
               WHERE pmq01 = g_pmq01 AND pmq02 = g_pmq02
                 AND pmq04 = g_pmq_t.pmq04
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_pmq_t.pmq04,SQLCA.sqlcode,0)   #No.FUN-660129
                  CALL cl_err3("del","pmq_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                  ROLLBACK WORK
                  CANCEL DELETE
              END IF
              LET g_rec_b = g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pmq[l_ac].* = g_pmq_t.*
              CLOSE i253_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pmq[l_ac].pmq04,-263,1)
              LET g_pmq[l_ac].* = g_pmq_t.*
           ELSE
              UPDATE pmq_file SET pmq04=g_pmq[l_ac].pmq04,
                                  pmq05=g_pmq[l_ac].pmq05
               WHERE pmq01 = g_pmq01  #MOD-860182
                 AND pmq02 = g_pmq02  #MOD-860182
                 AND pmq04 = g_pmq_t.pmq04
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_pmq[l_ac].pmq04,SQLCA.sqlcode,0)   #No.FUN-660129
                 CALL cl_err3("upd","pmq_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_pmq[l_ac].* = g_pmq_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac       #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_pmq[l_ac].* = g_pmq_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_pmq.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE i253_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac       #FUN-D30034 add
           CLOSE i253_bcl
           COMMIT WORK
 
#       ON ACTION CONTROLN
#          CALL i253_b_askkey()
#          EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pmq04) AND l_ac > 1 THEN
              LET g_pmq[l_ac].* = g_pmq[l_ac-1].*
              NEXT FIELD pmq04
           END IF
 
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
 
       ON ACTION controls                           #No.FUN-6B0032             
          CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032  
    END INPUT
 
    CLOSE i253_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i253_b_askkey()
DEFINE
   l_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   CONSTRUCT l_wc ON pmq04,pmq05    #螢幕上取條件
      FROM s_pmq[1].pmq04,s_pmq[1].pmq05
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
 
   IF INT_FLAG THEN RETURN END IF
 
   CALL i253_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i253_b_fill(p_wc)              #BODY FILL UP
DEFINE
   p_wc            LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
 
   LET g_sql = "SELECT pmq04,pmq05",
               " FROM pmq_file ",
               " WHERE pmq01 = '",g_pmq01,"' AND ",
               " pmq02 = '",g_pmq02,"' AND ",
                 p_wc CLIPPED ,
               " ORDER BY pmq04"
   PREPARE i253_prepare2 FROM g_sql      #預備一下
   DECLARE pmq_cs CURSOR FOR i253_prepare2
 
   CALL g_pmq.clear()
   LET g_cnt = 1
   FOREACH pmq_cs INTO g_pmq[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmq.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i253_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmq TO s_pmq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION first
         CALL i253_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i253_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i253_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i253_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i253_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i253_copy()
DEFINE l_newno1,l_oldno1  LIKE pmq_file.pmq01,
      l_newno2,l_oldno2  LIKE pmq_file.pmq02,
      l_pmq03     LIKE pmq_file.pmq03,
      l_pmc03     LIKE pmc_file.pmc03
 
   IF s_shut(0) THEN RETURN END IF
   IF g_pmq01 IS NULL
      THEN CALL cl_err('',-400,0)
           RETURN
   END IF
   DISPLAY ' ' TO pmq03
   DISPLAY ' ' TO pmc03
   DISPLAY ' ' TO pmh03
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT l_newno1,l_newno2 FROM pmq01,pmq02
 
       BEFORE FIELD pmq01
          IF g_sma.sma60 = 'Y' THEN
             CALL s_inp5(7,13,l_newno1) RETURNING l_newno1
             DISPLAY l_newno1 TO pmq01
          END IF
 
       AFTER FIELD pmq01
          IF cl_null(l_newno1) THEN
             NEXT FIELD pmq01
          ELSE
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(l_newno1,"") THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD pmq01
            END IF
#FUN-AA0059 ---------------------end-------------------------------
             CALL i253_pmq01(l_newno1)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(l_newno1,g_errno,0)
                NEXT FIELD pmq01
             END IF
          END IF
 
       AFTER FIELD pmq02
          IF cl_null(l_newno2) THEN
              NEXT FIELD pmq02
          END IF
          SELECT count(*) INTO g_cnt FROM pmh_file #檢查此條件是否存在
              WHERE pmh01 = l_newno1  AND pmh02 = l_newno2
                AND pmh21 = " "                                             #CHI-860042                                             
                AND pmh22 = '1'                                             #CHI-860042
                AND pmh23 = ' '                                             #No.CHI-960033
                AND pmhacti = 'Y'                                           #CHI-910021
          IF g_cnt = 0
          THEN CALL cl_err(l_newno1,'mfg3160',0)
               NEXT FIELD pmq01
          END IF
          SELECT count(*) INTO g_cnt FROM  pmq_file
                 WHERE pmq01 = l_newno1 AND pmq02 = l_newno2
          IF g_cnt > 0 THEN
              CALL cl_err(l_newno1,-239,0)
              NEXT FIELD pmq01
          END IF
   
          DECLARE i253_pmh_cs3 SCROLL CURSOR FOR                         #TQC-960296 
          SELECT pmh04,pmh03
#           INTO l_pmq03,l_pmh03                                         #TQC-960296
            FROM pmh_file
           WHERE pmh01=l_newno1 AND pmh02=l_newno2
             AND pmh21 = " "                                             #CHI-860042                                                
             AND pmh22 = '1'                                             #CHI-860042
             AND pmh23 = ' '                                             #No.CHI-960033
             AND pmhacti = 'Y'                                           #CHI-910021
          OPEN i253_pmh_cs3
          FETCH FIRST i253_pmh_cs3 INTO l_pmq03,l_pmh03                  #TQC-960296
          SELECT pmc03 INTO l_pmc03 FROM pmc_file
                       WHERE pmc01 =  l_newno2
          DISPLAY l_pmq03 TO pmq03
          DISPLAY l_pmc03 TO pmc03
          DISPLAY l_pmh03 TO pmh03
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(pmq02) #廠商編號
#               CALL q_pmc1(0,0,g_pmq02) RETURNING l_newno2
#               CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc1"
                LET g_qryparam.default1 = g_pmq02
                CALL cl_create_qry() RETURNING l_newno2
#                CALL FGL_DIALOG_SETBUFFER( l_newno2 )
                DISPLAY l_newno2 TO pmq02
                CALL i253_pmq02('d')
                NEXT FIELD pmq02
           END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY  g_pmq01 TO pmq01
      DISPLAY  g_pmq02 TO pmq02
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pmq_file         #單身複製
       WHERE g_pmq01=pmq01 AND g_pmq02 = pmq02
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      LET g_msg = g_pmq01 CLIPPED,'+',g_pmq02
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("sel","pmq_file",g_pmq01,g_pmq02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x
       SET pmq01 = l_newno1,
           pmq02 = l_newno2,
           pmq03 = l_pmq03
 
   INSERT INTO pmq_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      LET g_msg = l_newno1 CLIPPED,'+',l_newno2
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("ins","pmq_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
 
   LET l_oldno1= g_pmq01
   LET l_oldno2= g_pmq02
   LET g_pmq01=l_newno1
   LET g_pmq02=l_newno2
 
   CALL i253_b()
 
   #LET g_pmq01=l_oldno1  #FUN-C80046
   #LET g_pmq02=l_oldno2  #FUN-C80046
 
   #CALL i253_show()      #FUN-C80046
 
END FUNCTION
 
FUNCTION i253_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680136 SMALLINT
    sr              RECORD
        pmq01       LIKE pmq_file.pmq01,   #料件編號
        pmq02       LIKE pmq_file.pmq02,   #說明性質
        pmq03       LIKE pmq_file.pmq03,   #廠商料件編號
        pmq04       LIKE pmq_file.pmq04,   #行序
        pmq05       LIKE pmq_file.pmq05,   #說明
        pmh03       LIKE pmh_file.pmh03    #主要否
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680136 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(40)
 
    IF cl_null(g_wc) THEN
        LET g_wc="     pmq01='",g_pmq01,"'",
                 " AND pmq02='",g_pmq02,"'",
                 " AND pmq03='",g_pmq03,"'"
    END IF
    CALL cl_wait()
#   LET l_name = 'apmi253.out'
    CALL cl_outnam('apmi253') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
# No.FUN-580013 ---start---
{    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'apmi253_'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR}
# No.FUN-580013 ---end---
    LET g_sql="SELECT pmq01,pmq02,pmq03,pmq04,pmq05,pmh03",
#No.FUN-9A0078 --begin
              " FROM pmq_file ,LEFT OUTER JOIN pmh_file ",  # 組合出 SQL 指令
              "   ON  pmh21 = ' ' ", #CHI-860042                                                                                    
              "   AND pmh22 = '1' ", #CHI-860042
              "   AND pmh23 = ' ' ", #No.CHI-960033
              "   AND pmhacti = 'Y'",                                           #CHI-910021
              "   AND pmq01=pmh01 AND pmq02=pmh02 WHERE ",g_wc CLIPPED,
#             " FROM pmq_file ,OUTER pmh_file ",  # 組合出 SQL 指令
#             " WHERE pmq01=pmh_file.pmh01 AND pmq02=pmh_file.pmh02 AND ",g_wc CLIPPED,
#             "   AND pmh_file.pmh21 = ' ' ", #CHI-860042                                                                                    
#             "   AND pmh_file.pmh22 = '1' ", #CHI-860042
#             "   AND pmh_file.pmh23 = ' ' ", #No.CHI-960033
#             "   AND pmh_file.pmhacti = 'Y'",                                           #CHI-910021
#No.FUN-9A0078 --end
              " ORDER BY pmq01,pmq02,pmq03,pmq04 "
    PREPARE i253_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i253_co                         # CURSOR
        CURSOR FOR i253_p1
 
    START REPORT i253_rep TO l_name
 
    FOREACH i253_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT i253_rep(sr.*)
    END FOREACH
 
    FINISH REPORT i253_rep
 
    CLOSE i253_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT i253_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    l_pmhacti       LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    l_acti          LIKE pmh_file.pmhacti,       #No.FUN-680136 VARCHAR(1)
    l_sw            LIKE type_file.chr1,         #No.FUN-680136 VARCHAR(1)
    sr              RECORD
        pmq01       LIKE pmq_file.pmq01,         #產品編號
        pmq02       LIKE pmq_file.pmq02,         #說明性質
        pmq03       LIKE pmq_file.pmq03,         #廠商料件編號
        pmq04       LIKE pmq_file.pmq04,         #行序
        pmq05       LIKE pmq_file.pmq05,         #說明
        pmh03       LIKE pmh_file.pmh03          #主要否
                    END RECORD,
    l_pmc03    LIKE pmc_file.pmc03
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.pmq01,sr.pmq02,sr.pmq03
 
    FORMAT
        PAGE HEADER
# No.FUN-580013 ---start---
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
 
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT g_dash[1,g_len]
            SELECT pmc03 INTO l_pmc03 FROM pmc_file
                         WHERE pmc01 = sr.pmq02
# No.FUN-580013 --end---
            IF SQLCA.SQLCODE THEN LET l_pmc03 = " " END IF
            PRINT column 2,g_x[11] clipped,sr.pmq01
##TQC-5B0110&051112 START##
            PRINT column 2,g_x[12] clipped,sr.pmq02,
            #      column 50,g_x[13] clipped,l_pmc03
                  column 27,g_x[13] clipped,l_pmc03,
                  column 62,g_x[15] clipped,sr.pmh03
            PRINT column 2,g_x[14] clipped,sr.pmq03
            #      column 50,g_x[15] clipped,sr.pmh03
##TQC-5B0110&051112 END##
            PRINT g_x[31],g_x[32]
 
# No.FUN-580013 ---start---
         {   PRINT column 5,'---- ---------------------------------',
                           '---------------------------'  }
# No.FUN-580013 ---end--
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.pmq03
           IF PAGENO > 1 OR LINENO > 7
              THEN SKIP TO TOP OF PAGE
           END IF
 
# No.FUN-580013 ---start---
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.pmq04 USING '###&',
                  COLUMN g_c[32],sr.pmq05
# No.FUN-580013 ---end---
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc,'pmq01,pmq02,pmq03,pmq04')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
            #TQC-630166
            {
               IF g_sql[001,080] > ' ' THEN
                   PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               IF g_sql[071,140] > ' ' THEN
                   PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               IF g_sql[141,210] > ' ' THEN
                   PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
            }
              CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
#Patch....NO.TQC-610036 <> #
