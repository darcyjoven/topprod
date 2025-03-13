# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: aecq700.4gl
# Descriptions...: 工單製程數量狀態查詢
# Date & Author..: 99/04/30 By Iceman FOR TIPTOP 4.00
# Modify.........: 99/05/21 By Carol  FOR TIPTOP 4.00
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0034 04/12/07 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-660091 05/06/15 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei欄位型態轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770004 07/07/03 By mike 幫助文件無法跳出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60011 10/06/07 By Carrier add ecm012/ecu014/ecm65 delete ecm57
# Modify.........: No:CHI-A50044 10/06/28 By Summer 工單號碼可開窗
# Modify.........: No:FUN-A50066 10/06/24 By jan 拿掉ecm59的相關處理
# Modify.........: No:FUN-A60095 10/07/20 By jan sma54-->sma541
# Modify.........: No:FUN-A80150 10/09/06 By sabrina GP5.2號機管理
# Modify.........: No:TQC-AC0374 10/12/30 By jan 調用s_schdat_ecu014() 抓取製程段名稱
# Modify.........: No:FUN-B10056 11/02/21 By lixh1 制程段號說明欄位改用實體欄位ecm014來顯示
# Modify.........: No.FUN-A70095 11/06/13 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.......... No.FUN-B90117 11/09/26 By lilingyu 增加TREE控件連動顯示
# Modify.......... No.TQC-BC0034 11/12/07 By destiny 不走平行工艺时不应显示agl1001的讯息
# Modify.........: No:MOD-C40062 12/04/09 By ck2yuan 匯出excel功能修正
# Modify.........: No:MOD-C80162 12/08/22 By ck2yuan 不走平行製程時,則show出 ecm03
# Modify.......... No.TQC-CC0030 12/12/06 By xuxz shb30如果為空則給默認值N

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_sfb   RECORD LIKE sfb_file.*,
    g_sfb_t RECORD LIKE sfb_file.*,
    g_sfb_o RECORD LIKE sfb_file.*,
    g_sfb01_t LIKE sfb_file.sfb01,
    g_sfb02_t LIKE sfb_file.sfb02,
    l_eci01   LIKE eci_file.eci01,
    b_ecm   RECORD LIKE ecm_file.*,
    g_argv1   LIKE sfb_file.sfb01,
    ddflag   LIKE type_file.chr1,                   #No.FUN-680073 VARCHAR(1)
    g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN
    g_cott          LIKE type_file.num5,            #No.FUN-680073 SMALLINT,
    m_ecm   RECORD  LIKE ecm_file.*,
    g_ecm           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ecm03       LIKE ecm_file.ecm03,   #製程序
        ecm012      LIKE ecm_file.ecm012,  #工艺段号   #No.FUN-A60011
      #  ecu014      LIKE ecu_file.ecu014,  #工艺段号名 #No.FUN-A60011  #FUN-B10056 mark
        ecm014      LIKE ecm_file.ecm014,  #FUN-B10056
        ecm06       LIKE ecm_file.ecm06,   #生產站別
        m06_name    LIKE pmc_file.pmc03,   #
        ecm45       LIKE ecm_file.ecm45,   #作業名稱
        ecm65       LIKE ecm_file.ecm65,   #标准产出量 #No.FUN-A60011
        wipqty      LIKE ecm_file.ecm315,  #
        ecm301      LIKE ecm_file.ecm301,  #
        ecm302      LIKE ecm_file.ecm302,  #
        ecm303      LIKE ecm_file.ecm303,
        ecm311      LIKE ecm_file.ecm311,  #
        ecm312      LIKE ecm_file.ecm312,  #
        ecm316      LIKE ecm_file.ecm316,
        ecm313      LIKE ecm_file.ecm313,  #
        ecm314      LIKE ecm_file.ecm314,  #
        shb30       LIKE shb_file.shb30,   #     #FUN-A80150 add
        ecm66       LIKE ecm_file.ecm66,   #     #FUN-A80150 add
        ecm315      LIKE ecm_file.ecm315,  #
        ecm321      LIKE ecm_file.ecm321,  #
        ecm322      LIKE ecm_file.ecm322,  #
        ecm291      LIKE ecm_file.ecm291,  #
        ecm292      LIKE ecm_file.ecm292,
       #ecm57       LIKE ecm_file.ecm57,    #No.FUN-A60011
        ecm58       LIKE ecm_file.ecm58,
        ecm54       LIKE ecm_file.ecm54,    #check-in 否
        ecm52       LIKE ecm_file.ecm52,
        ecm53       LIKE ecm_file.ecm53,
        ecm55       LIKE ecm_file.ecm55,
        ecm56       LIKE ecm_file.ecm56
                    END RECORD,
    g_ecm_t         RECORD                 #程式變數 (舊值)
        ecm03       LIKE ecm_file.ecm03,   #製程序
        ecm012      LIKE ecm_file.ecm012,  #工艺段号   #No.FUN-A60011
     #  ecu014      LIKE ecu_file.ecu014,  #工艺段号名 #No.FUN-A60011  #FUN-B10056 mark
        ecm014      LIKE ecm_file.ecm014,  #FUN-B10056
        ecm06       LIKE ecm_file.ecm06,   #生產站別
        m06_name    LIKE pmc_file.pmc03,   #
        ecm45       LIKE ecm_file.ecm45,   #作業名稱
        ecm65       LIKE ecm_file.ecm65,   #标准产出量 #No.FUN-A60011
        wipqty      LIKE ecm_file.ecm315,  #
        ecm301      LIKE ecm_file.ecm301,  #
        ecm302      LIKE ecm_file.ecm302,  #
        ecm303      LIKE ecm_file.ecm303,
        ecm311      LIKE ecm_file.ecm311,  #
        ecm312      LIKE ecm_file.ecm312,  #
        ecm316      LIKE ecm_file.ecm316,
        ecm313      LIKE ecm_file.ecm313,  #
        ecm314      LIKE ecm_file.ecm314,  #
        shb30       LIKE shb_file.shb30,   #     #FUN-A80150 add
        ecm66       LIKE ecm_file.ecm66,   #     #FUN-A80150 add
        ecm315      LIKE ecm_file.ecm315,  #
        ecm321      LIKE ecm_file.ecm321,  #
        ecm322      LIKE ecm_file.ecm322,  #
        ecm291      LIKE ecm_file.ecm291,  #
        ecm292      LIKE ecm_file.ecm292,
       #ecm57       LIKE ecm_file.ecm57,    #No.FUN-A60011
        ecm58       LIKE ecm_file.ecm58,
        ecm54       LIKE ecm_file.ecm54,    #check-in 否
        ecm52       LIKE ecm_file.ecm52,
        ecm53       LIKE ecm_file.ecm53,
        ecm55       LIKE ecm_file.ecm55,
        ecm56       LIKE ecm_file.ecm56
                    END RECORD,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680073 SMALLINT
    g_ecm59         LIKE ecm_file.ecm59,
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
    l_sl,p_row,p_col            LIKE type_file.num5     #目前處理的SCREEN LINE        #No.FUN-680073 SMALLINT SMALLINT

DEFINE g_t  DYNAMIC ARRAY OF RECORD
               ecm52  LIKE ecm_file.ecm52,
               ecm53  LIKE ecm_file.ecm53,
               ecm54  LIKE ecm_file.ecm54,
               ecm55  LIKE ecm_file.ecm55,
               ecm56  LIKE ecm_file.ecm56
               END RECORD

DEFINE g_forupd_sql      STRING                       #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680073 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680073 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680073 SMALLINT
#FUN-B90117--begin--
DEFINE   l_tree_ac       LIKE type_file.num5
DEFINE   g_ac            LIKE type_file.num5
DEFINE   g_idx           LIKE type_file.num5
DEFINE   g_tree DYNAMIC ARRAY OF RECORD
          name           STRING,                 #节点名称
          wip            LIKE type_file.num15_3,
          sta            LIKE type_file.chr1,
          img            LIKE type_file.chr1000,
          pid            LIKE ima_file.ima01,    #父节点id
          id             LIKE ima_file.ima01,    #节点id
          has_children   BOOLEAN,                #1:有子节点, null:无子节点
          expanded       BOOLEAN,                #0:不展开, 1展开
          level          LIKE type_file.num5,    #层级
          desc           LIKE type_file.chr100,
          chk            LIKE type_file.chr1,     #是否序号
          ecm03          LIKE ecm_file.ecm03,
          ecm015         LIKE ecm_file.ecm015,
          ecm014         LIKE ecm_file.ecm014
          END RECORD

DEFINE  att DYNAMIC ARRAY OF RECORD
          name           STRING,                 #节点名称
          wip            STRING,
          sta            STRING,
          img            STRING,
          pid            STRING,    #父节点id
          id             STRING,    #节点id
          has_children   STRING,                #1:有子节点, null:无子节点
          expanded       STRING,                #0:不展开, 1展开
          level          STRING,    #层级
          desc           STRING,
          chk            STRING,     #是否序号
          ecm03          STRING,
          ecm015         STRING,
          ecm014         STRING
          END RECORD

DEFINE g_tree_focus_idx  STRING                  #当前节点数
DEFINE g_tree_reload     LIKE type_file.chr1     #tree是否要重新整理 Y/N
DEFINE g_curr_idx       INTEGER
DEFINE g_count          LIKE type_file.num5
CONSTANT  leaf_image = "ssmiley.png"
#FUN-B90117--end--

MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0100
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF


      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
    LET g_argv1 = ARG_VAL(1)
    INITIALIZE g_sfb.* TO NULL
    INITIALIZE g_sfb_t.* TO NULL
    INITIALIZE g_sfb_o.* TO NULL

    LET p_row = 4 LET p_col = 2
    OPEN WINDOW q700_w AT p_row,p_col WITH FORM "aec/42f/aecq700"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()
   # CALL cl_set_comp_visible("ecm012,ecu014",g_sma.sma541='Y')  #FUN-A60095  #FUN-B10056 mark
    CALL cl_set_comp_visible("ecm012,ecm014",g_sma.sma541='Y')  #FUN-B10056
    CALL cl_set_comp_visible("sfb919",g_sma.sma1421='Y')        #FUN-A80150 add
    CALL cl_set_comp_visible("shb30,ecm66",g_sma.sma1431='Y')   #FUN-A80150 add

#FUN-B90117--begin
    IF g_sma.sma541 = 'Y' THEN
       CALL cl_set_comp_visible("tree",TRUE)
    ELSE
    	 CALL cl_set_comp_visible("tree",FALSE)
    END IF
#FUN-B90117--end

    IF NOT cl_null(g_argv1) THEN
       CALL q700_q()
    END IF
    CALL q700()
    CLOSE WINDOW q700_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
END MAIN

FUNCTION q700()
    LET g_forupd_sql =
        "DECLARE q700_cl CURSOR FOR SELECT * FROM sfb_file ",
        " WHERE sfb01 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE q700_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    CALL q700_menu()
END FUNCTION

FUNCTION q700_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    LET  g_wc2=' 1=1'
    CLEAR FORM
    CALL g_ecm.clear()
    IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON sfb01,sfb05,sfb06,sfb919     #FUN-A80150 add sfb919

               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN

       #CHI-A50044 add --start--
         ON ACTION controlp
            CASE
               WHEN INFIELD(sfb01) #order nubmer
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.form = "q_sfb"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfb01
                     NEXT FIELD sfb01
            END CASE
       #CHI-A50044 add --end--

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

     #  CONSTRUCT g_wc2 ON ecm03,ecm012,ecm06,ecm45,ecm65,ecm301,ecm302,  #No.FUN-A60011  #FUN-B10056  mark
        CONSTRUCT g_wc2 ON ecm03,ecm012,ecm014,ecm06,ecm45,ecm65,ecm301,ecm302,  #FUN-B10056 add ecm014
                 ecm303,ecm311,ecm312,ecm316,ecm313,ecm314,ecm66,ecm315,    #FUN-A80150 add ecm66
                 ecm321,ecm322,ecm291,ecm292,ecm58,ecm54,        #No.FUN-A60011
                 ecm52,ecm53,ecm55,ecm56
            FROM s_ecm[1].ecm03,s_ecm[1].ecm012,     #No.FUN-A60011
                 s_ecm[1].ecm014,                    #FUN-B10056 add ecm014
                 s_ecm[1].ecm06,s_ecm[1].ecm45,
                 s_ecm[1].ecm65,                     #No.FUN-A60011
                 s_ecm[1].ecm301,s_ecm[1].ecm302,
                 s_ecm[1].ecm303,s_ecm[1].ecm311,
                 s_ecm[1].ecm312,s_ecm[1].ecm316,
                 s_ecm[1].ecm313,s_ecm[1].ecm314,s_ecm[1].ecm66,s_ecm[1].ecm315,      #FUN-A80150 add shb30,ecm66
                 s_ecm[1].ecm321,s_ecm[1].ecm322,
                 s_ecm[1].ecm291,s_ecm[1].ecm292,
                 s_ecm[1].ecm58,s_ecm[1].ecm54,      #No.FUN-A60011
                 s_ecm[1].ecm52, s_ecm[1].ecm53,s_ecm[1].ecm55,
                 s_ecm[1].ecm56

		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN

       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc ="sfb01 ='",g_argv1,"'"
    END IF

    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF

    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030

    #No.FUN-A60011  --Begin
    #IF g_wc2=' 1=1' OR g_wc2 IS NULL THEN
    #   LET g_sql="SELECT sfb01 FROM sfb_file ",
    #             " WHERE sfb87!='X' AND ",g_wc CLIPPED, " ORDER BY sfb01"
    #ELSE
       LET g_sql="SELECT DISTINCT sfb01",
                 "  FROM sfb_file,ecm_file ",
                 " WHERE sfb01=ecm01 AND sfb87!='X' ",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY sfb01"
    #END IF
    #No.FUN-A60011  --End

    PREPARE q700_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE q700_cs SCROLL CURSOR WITH HOLD FOR q700_prepare

    #No.FUN-A60011  --Begin
    #LET g_sql= "SELECT COUNT(*) FROM sfb_file WHERE ",g_wc CLIPPED
    LET g_sql="SELECT COUNT(DISTINCT sfb01)",
              "  FROM sfb_file,ecm_file ",
              " WHERE sfb01=ecm01 AND sfb87!='X' ",
              "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    #No.FUN-A60011  --End
    PREPARE q700_precount FROM g_sql
    DECLARE q700_count CURSOR FOR q700_precount

END FUNCTION

FUNCTION q700_menu()

  #MOD-C40062 str add-----
   DEFINE w ui.Window
   DEFINE f ui.Form
   DEFINE page om.DomNode
  #MOD-C40062 end add-----

   WHILE TRUE
      CALL q700_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q700_q()
            END IF
         WHEN "help"
            IF cl_chk_act_auth() THEN            #No.TQC-770004
              CALL cl_show_help()               #No.TQC-770004
            END IF                              #No.TQC-770004
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
             #MOD-C40062 str add------
             #IALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ecm),'','')
              LET w = ui.Window.getCurrent()
              LET f = w.getForm()
              LET page = f.FindNode("Table","s_ecm")
              CALL cl_export_to_excel(page,base.TypeInfo.create(g_ecm),'','')
             #MOD-C40062 end add-----
            END IF
##

#FUN-B90117--begin
          WHEN "fresh"
            IF cl_chk_act_auth() THEN
               CALL q700_tree_fill_1(g_sfb.sfb01)
               CALL q700_b_fill("1=1")
            END IF
#FUN-B90117--End

      END CASE
   END WHILE
   CLOSE q700_cs

END FUNCTION

FUNCTION q700_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL q700_cs()                          # 宣告 SCROLL CURSOR

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_ecm.clear()
       CALL g_t.clear()
#FUN-B90117--begin
       CALL g_tree.clear()
       CALL att.clear()
#FUN-B90117--End
       RETURN
    END IF

    MESSAGE " SEARCHING ! "
    OPEN q700_count
    FETCH q700_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN q700_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL
    ELSE
        CALL q700_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION q700_fetch(p_flsfb)
    DEFINE
        p_flsfb         LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1)
        l_abso          LIKE type_file.num10         #No.FUN-680073 INTEGER

    CASE p_flsfb
        WHEN 'N' FETCH NEXT     q700_cs INTO g_sfb.sfb01
        WHEN 'P' FETCH PREVIOUS q700_cs INTO g_sfb.sfb01
        WHEN 'F' FETCH FIRST    q700_cs INTO g_sfb.sfb01
        WHEN 'L' FETCH LAST     q700_cs INTO g_sfb.sfb01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                     CONTINUE PROMPT

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
            FETCH ABSOLUTE g_jump q700_cs INTO g_sfb.sfb01
            LET mi_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsfb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_sfb.* FROM sfb_file      #重讀DB,因TEMP有不被更新特性
     WHERE sfb01 = g_sfb.sfb01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0) #No.FUN-660091
       CALL cl_err3("sel","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",0) #FUN-660091
    ELSE
       LET g_data_owner = g_sfb.sfbuser      #FUN-4C0034
       LET g_data_group = g_sfb.sfbgrup      #FUN-4C0034
       CALL q700_show()                      #重新顯示
    END IF
END FUNCTION

FUNCTION q700_show()
    LET g_sfb_t.* = g_sfb.*
    DISPLAY BY NAME
      g_sfb.sfb01, g_sfb.sfb05, g_sfb.sfb06, g_sfb.sfb08,
      g_sfb.sfb081, g_sfb.sfb09,g_sfb.sfb919            #FUN-A80150 add sfb919

    CALL q700_tree_fill_1(g_sfb.sfb01)   #FUN-B90117
    CALL q700_sfb05('d')
    CALL q700_b_fill(g_wc2)
#   CALL q700_show_pic(1,'Y')            #FUN-B90117

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION q700_b_askkey()
    CONSTRUCT g_wc2 ON ecm03,ecm54,ecm06,ecm45,ecm301,ecm302,
              ecm311,ecm312,ecm313,ecm314,ecm66,ecm315,ecm321,ecm322,ecm291,ecm292,    #FUN-A80150 add ecm66
              ecm303,ecm316,ecm57,ecm58
         FROM s_ecm[1].ecm03,s_ecm[1].ecm54,s_ecm[1].ecm06,s_ecm[1].ecm45,
              s_ecm[1].ecm301,s_ecm[1].ecm302,
              s_ecm[1].ecm311,s_ecm[1].ecm312,
              s_ecm[1].ecm313,s_ecm[1].ecm314,s_ecm[1].ecm66,s_ecm[1].ecm315,    #FUN-A80150 add ecm66
              s_ecm[1].ecm321,s_ecm[1].ecm322,
              s_ecm[1].ecm291,s_ecm[1].ecm292,
              s_ecm[1].ecm303,s_ecm[1].ecm316,
              s_ecm[1].ecm57,s_ecm[1].ecm57

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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL q700_b_fill(g_wc2)
END FUNCTION


FUNCTION q700_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
   DEFINE   l_wc   LIKE type_file.chr1000       #FUN-B90117

   IF p_ud <> "G"  THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

#FUN-B90117--add Begin
  #CALL cl_set_comp_visible("ecm03,ecm012,ecm014",FALSE)   #MOD-C80162 mark
  #MOD-C80162 str add-----
   IF g_sma.sma541 = 'Y' THEN
      CALL cl_set_comp_visible("ecm03,ecm012,ecm014",FALSE)
   ELSE
      CALL cl_set_comp_visible("ecm012,ecm014",FALSE)
   END IF
  #MOD-C80162 end add-----

    DIALOG ATTRIBUTES(UNBUFFERED)
        DISPLAY ARRAY g_tree TO tree.*
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL dialog.setCellAttributes(att)

         BEFORE ROW
            LET l_tree_ac = ARR_CURR()
            LET g_curr_idx = ARR_CURR()
            IF g_tree[l_tree_ac].chk = '1' THEN  #'1' 表示点击的是最上层的工单
               CALL q700_b_fill("1=1")
            ELSE
               IF g_tree[l_tree_ac].chk = '2' THEN
                 LET l_wc=" ecm014='",g_tree[l_tree_ac].ecm014,"' AND ecm012='",g_tree[l_tree_ac].id,"' AND ecm015='",g_tree[l_tree_ac].ecm015,"'"
                 CALL q700_b_fill(l_wc)
               END IF
               IF g_tree[l_tree_ac].chk = '3' THEN
                 LET l_wc=" ecm03=",g_tree[l_tree_ac].ecm03," AND ecm012='",g_tree[l_tree_ac].id,"' AND ecm014='",g_tree[l_tree_ac].ecm014,"' AND ecm015='",g_tree[l_tree_ac].ecm015,"'"
                 CALL q700_b_fill(l_wc)
               END IF

            END IF
#           CALL q700_show_pic(l_tree_ac,'N')
           # CALL i100_b_init()

        ###双击进单身 ####
        # ON ACTION accept
        #    LET g_action_choice="detail"
        #    LET l_ac = 1
        #    EXIT DIALOG

      END DISPLAY
#FUN-B90117--add end

#  DISPLAY ARRAY g_ecm TO s_ecm.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #FUN-B90117
   DISPLAY ARRAY g_ecm TO s_ecm.*  ATTRIBUTE(COUNT=g_rec_b)             #FUN-B90117

      BEFORE DISPLAY
         CALL fgl_set_arr_curr(g_ac)                                    #FUN-B90117
         CALL cl_navigator_setting( g_curs_index, g_row_count )

#FUN-B90117 --Begin
#      #BEFORE ROW
#      #   LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()

      AFTER DISPLAY
         CONTINUE DIALOG
    END DISPLAY
#FUN-B90117--END

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
#        EXIT DISPLAY                  #FUN-B90117
         EXIT DIALOG                   #FUN-B90117
      ON ACTION first
         CALL q700_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#          ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST  #FUN-B90117
           ACCEPT DIALOG                                             #FUN-B90117

      ON ACTION previous
         CALL q700_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#          ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST  #FUN-B90117
           ACCEPT DIALOG                                             #FUN-B90117


      ON ACTION jump
         CALL q700_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#          ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST  #FUN-B90117
           ACCEPT DIALOG                                             #FUN-B90117


      ON ACTION next
         CALL q700_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#          ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST  #FUN-B90117
           ACCEPT DIALOG                                             #FUN-B90117


      ON ACTION last
         CALL q700_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
#          ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST  #FUN-B90117
           ACCEPT DIALOG                                             #FUN-B90117


      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()                #No.TQC-770004
#        EXIT DISPLAY              #FUN-B90117
         EXIT DIALOG               #FUN-B90117

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        EXIT DISPLAY              #FUN-B90117
         EXIT DIALOG               #FUN-B90117

      ON ACTION exit
         LET g_action_choice="exit"
#        EXIT DISPLAY              #FUN-B90117
         EXIT DIALOG               #FUN-B90117

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
#        EXIT DISPLAY              #FUN-B90117
         EXIT DIALOG               #FUN-B90117

#FUN-B90117--Begin
#     ON ACTION accept
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
#FUN-B90117--end

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
#        EXIT DISPLAY                                              #FUN-B90117
         EXIT DIALOG                                               #FUN-B90117

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
#        CONTINUE DISPLAY                                          #FUN-B90117
         CONTINUE DIALOG                                           #FUN-B90117

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY                                              #FUN-B90117
         EXIT DIALOG                                               #FUN-B90117

#FUN-B90117--add Begin
#      # No.FUN-530067 --start--
#      AFTER DISPLAY
#         CONTINUE DISPLAY
#      # No.FUN-530067 ---end---

      ON ACTION fresh
         LET g_action_choice = 'fresh'
         EXIT DIALOG
#FUN-B90117--add end

##
#NO.FUN-6B0031--BEGIN
        ON ACTION CONTROLS
           CALL cl_set_head_visible("","AUTO")
#NO.FUN-6B0031--END

#   END DISPLAY                                              #FUN-B90117
    END DIALOG                                               #FUN-B90117

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q700_sfb05(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680073 VARCHAR(1)
    l_imaacti       LIKE ima_file.imaacti,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021

    LET g_errno = ' '
    SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti FROM ima_file
     WHERE ima01=g_sfb.sfb05
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET g_sfb.sfb05 = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY BY NAME g_sfb.sfb05
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
    END IF

END FUNCTION

FUNCTION q700_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2    LIKE type_file.chr1000   #No.FUN-680073 VARCHAR(200)

    #LET g_sql ="SELECT ecm03,ecm012,'',ecm06,' ',ecm45,ecm65,'',ecm301,ecm302,",  #No.FUN-A60011   #FUN-B10056 mark
     LET g_sql ="SELECT ecm03,ecm012,ecm014,ecm06,' ',ecm45,ecm65,'',ecm301,ecm302,",   #FUN-B10056
               " ecm303,ecm311,ecm312,ecm316,ecm313,ecm314,'',ecm66,ecm315,",    #FUN-A80150 add '',ecm66
               " ecm321,ecm322,ecm291,ecm292,ecm58,ecm54,",  #No.FUN-A60011
               " ecm52,ecm53,ecm55,ecm56,ecm59 ",
               "  FROM ecm_file",
               " WHERE ecm01 = '",g_sfb.sfb01, "'",
               "   AND ",g_wc2 CLIPPED,
               "   AND ",p_wc2 CLIPPED,                 #FUN-B90117
               " ORDER BY ecm012,ecm03 "            #No.FUN-A60011
    PREPARE q7003_pb FROM g_sql
    DECLARE ecm_curs CURSOR FOR q7003_pb

    CALL g_ecm.clear()

    LET g_rec_b = 0
    LET g_cnt = 1
    #單身 ARRAY 填充
    FOREACH ecm_curs  INTO g_ecm[g_cnt].*,g_ecm59
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF

        #No.FUN-A60011  --Begin
        #TQC-AC0374--begin--mark-----
        #SELECT ecu014 INTO g_ecm[g_cnt].ecu014 FROM ecu_file
        # WHERE ecu01 = g_sfb.sfb05
        #   AND ecu02 = g_sfb.sfb06
        #   AND ecu012= g_ecm[g_cnt].ecm012
        #TQC-AC0374--end--mark-------
      #  CALL s_schdat_ecu014(g_sfb.sfb01,g_ecm[g_cnt].ecm012) RETURNING g_ecm[g_cnt].ecu014  #TQC-AC0374  #FUN-B10056 mark
        #No.FUN-A60011  --End

        SELECT eca02 INTO g_ecm[g_cnt].m06_name FROM eca_file
         WHERE eca01 = g_ecm[g_cnt].ecm06
        IF SQLCA.sqlcode THEN LET g_ecm[g_cnt].m06_name = ' ' END IF
        CALL q700_get_wip(g_cnt)  # get WIP QTY

        IF cl_null(g_ecm[g_cnt].ecm52) THEN
           LET g_ecm[g_cnt].ecm52='N'
        END IF
        IF cl_null(g_ecm[g_cnt].ecm53) THEN
           LET g_ecm[g_cnt].ecm53='N'
        END IF
        IF cl_null(g_ecm[g_cnt].ecm54) THEN
           LET g_ecm[g_cnt].ecm54='N'
        END IF
       #FUN-A80150---add---start---
        SELECT shb30 INTO g_ecm[g_cnt].shb30 FROM shb_file
         WHERE shb05=g_sfb.sfb01 AND shb06=g_ecm[g_cnt].ecm03
           AND shb012=g_ecm[g_cnt].ecm012
           AND shbconf = 'Y'  #FUN-A70095
         ORDER BY shb03
       IF cl_null(g_ecm[g_cnt].shb30) THEN LET g_ecm[g_cnt].shb30 = 'N' END IF #TQC-CC0030 add
       #FUN-A80150---add---end---

        LET g_cnt = g_cnt + 1

        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ecm.deleteElement(g_cnt)
    LET g_rec_b= g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION q700_get_wip(p_i)
DEFINE
       p_i     LIKE type_file.num5          #No.FUN-680073 SMALLINT

#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
       IF g_ecm[p_i].ecm54='Y' THEN   #check in 否
        LET g_ecm[p_i].wipqty
                        =  g_ecm[p_i].ecm291                  #check in
                         - g_ecm[p_i].ecm311 #*g_ecm59        #良品轉出  #FUN-A50066
                         - g_ecm[p_i].ecm312 #*g_ecm59        #重工轉出  #FUN-A50066
                         - g_ecm[p_i].ecm313 #*g_ecm59        #當站報廢  #FUN-A50066
                         - g_ecm[p_i].ecm314 #*g_ecm59        #當站下線  #FUN-A50066
                         - g_ecm[p_i].ecm316 #*g_ecm59
#                        - g_ecm[p_i].ecm321                  #委外加工量
#                        + g_ecm[p_i].ecm322                  #委外完工量
       ELSE
        LET g_ecm[p_i].wipqty
                        =  g_ecm[p_i].ecm301                  #良品轉入量
                         + g_ecm[p_i].ecm302                  #重工轉入量
                         + g_ecm[p_i].ecm303
                         - g_ecm[p_i].ecm311 #*g_ecm59        #良品轉出 #FUN-A50066
                         - g_ecm[p_i].ecm312 #*g_ecm59        #重工轉出 #FUN-A50066
                         - g_ecm[p_i].ecm313 #*g_ecm59        #當站報廢 #FUN-A50066
                         - g_ecm[p_i].ecm314 #*g_ecm59        #當站下線 #FUN-A50066
                         - g_ecm[p_i].ecm316 #*g_ecm59
#                        - g_ecm[p_i].ecm321                  #委外加工量
#                        + g_ecm[p_i].ecm322                  #委外完工量
       END IF

       IF cl_null(g_ecm[p_i].wipqty) THEN LET g_ecm[p_i].wipqty=0 END IF

END FUNCTION

#FUN-B90117--Begin
#填充树
FUNCTION q700_tree_fill_1(p_sfb01)
DEFINE p_level      LIKE type_file.num5,
       l_child      INTEGER
DEFINE p_sfb01        LIKE sfb_file.sfb01

   INITIALIZE g_tree TO NULL
    LET p_level = 0
    LET g_idx = 0

   CALL q700_tree_fill_2(NULL,p_level,p_sfb01)
END FUNCTION

#填充树的父亲节点
FUNCTION q700_tree_fill_2(p_pid,p_level,p_sfb01)
DEFINE p_level           LIKE type_file.num5,
       p_pid             STRING,
       l_child           INTEGER
DEFINE p_sfb01             LIKE sfb_file.sfb01
DEFINE p_ecu02           LIKE ecu_file.ecu02
DEFINE l_loop            INTEGER
DEFINE l_sfb          DYNAMIC ARRAY OF RECORD
            sfb01       LIKE sfb_file.sfb01
            END RECORD
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_ecb03         LIKE ecb_file.ecb03
DEFINE l_ecb06         LIKE ecb_file.ecb06
DEFINE l_ecb17         LIKE ecb_file.ecb17
DEFINE l_n             LIKE type_file.num10
DEFINE l_n1            LIKE type_file.num10

   LET g_sql = "SELECT  sfb01 FROM sfb_file",
               " WHERE sfb01='",p_sfb01,"' "

   PREPARE q700_tree_pre1 FROM g_sql
   DECLARE q700_tree_cs1 CURSOR FOR q700_tree_pre1
   LET l_loop = 1
   LET l_cnt = 1
   LET p_level = p_level + 1
   CALL l_sfb.clear()

   FOREACH q700_tree_cs1 INTO l_sfb[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH

   FREE q700_tree_cs1
   CALL l_sfb.deleteelement(l_cnt)
   LET l_cnt = l_cnt - 1
   IF l_cnt >0 THEN
      FOR l_loop=1 TO l_cnt
          LET g_idx = g_idx + 1
          LET g_tree[g_idx].expanded = 1          #0:不展, 1:展
          LET g_tree[g_idx].name = "工单号:",l_sfb[l_loop].sfb01
          LET g_tree[g_idx].id = l_sfb[l_loop].sfb01
          LET g_tree[g_idx].pid = p_pid
          LET g_tree[g_idx].has_children = FALSE
          LET g_tree[g_idx].level = p_level
          LET g_tree[g_idx].desc = p_sfb01
          LET g_tree[g_idx].chk = '1'
          LET g_tree[g_idx].ecm03 = ' '
          LET g_tree[g_idx].ecm015 = ' '
          LET g_tree[g_idx].ecm014 = ' '
          LET att[g_idx].wip=' '

          SELECT COUNT(*) INTO l_child FROM ecm_file
           WHERE ecm01 = l_sfb[l_loop].sfb01 AND (ecm015 IS NULL OR ecm015=' ')
          #存在子节点的情况
          IF l_child > 0  THEN
             LET g_tree[g_idx].has_children = TRUE
             CALL q700_tree_fill(l_sfb[l_loop].sfb01,g_tree[g_idx].desc,p_level,g_idx)
          END IF
       END FOR
    END IF
END FUNCTION

#填充子节点
FUNCTION q700_tree_fill(p_pid,p_tex,p_level,p_idx)
DEFINE p_pid           LIKE sfb_file.sfb01              #父id
DEFINE p_tex           LIKE sfb_file.sfb01
DEFINE p_level         LIKE type_file.num5               #階層
DEFINE p_idx           LIKE type_file.num5              #父的数组下标
DEFINE l_child         INTEGER
DEFINE l_ecm          DYNAMIC ARRAY OF RECORD
            ecm012      LIKE ecm_file.ecm012,
            ecm014      LIKE ecm_file.ecm014,
            ecm015      LIKE ecm_file.ecm015
                      END RECORD
DEFINE l_str           STRING
DEFINE max_level       LIKE type_file.num5               #最大階層數,可避免無窮迴圈.
DEFINE l_i             LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_ecb03         LIKE ecb_file.ecb03
DEFINE l_ecb06         LIKE ecb_file.ecb06
DEFINE l_ecb17         LIKE ecb_file.ecb17
DEFINE l_n             LIKE type_file.num10
DEFINE l_n1            LIKE type_file.num10

   LET max_level = 20          #設定最大階層數為20
   LET p_level = p_level + 1   #下一階層
   IF p_level > max_level THEN
      IF g_sma.sma541 ='Y' THEN   #TQC-BC0034
         CALL cl_err_msg("","agl1001",max_level,0)
      END IF 
      RETURN
   END IF

   IF p_level=2 THEN
       LET g_sql = "SELECT DISTINCT ecm012,ecm014,ecm015 ",
                   "  FROM ecm_file ",
                   " WHERE (ecm015 IS NULL OR ecm015=' ') ",
                   "   AND ecm01 ='",p_tex,"' "
   ELSE
       LET g_sql = "SELECT DISTINCT ecm012,ecm014,ecm015 ",
                   " FROM ecm_file ",
                   " WHERE ecm015 = '",p_pid,"' ",            ########???
                   "   AND ecm01 ='",p_tex,"' "
   END IF

   PREPARE q700_tree_pre2 FROM g_sql
   DECLARE q700_tree_cs2 CURSOR FOR q700_tree_pre2
   LET l_cnt = 1
   CALL l_ecm.clear()
   FOREACH q700_tree_cs2 INTO l_ecm[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH

   FREE q700_tree_cs2
   CALL l_ecm.deleteelement(l_cnt)
   LET l_cnt = l_cnt - 1
      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid
            LET g_tree[g_idx].id = l_ecm[l_i].ecm012
            LET g_tree[g_idx].expanded = 1      #0:不展開, 1:展開
            LET g_tree[g_idx].name =l_ecm[l_i].ecm012,"  ",l_ecm[l_i].ecm014
            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].desc = p_tex
            LET g_tree[g_idx].chk = '2'
            LET g_tree[g_idx].ecm03 = ' '
            LET g_tree[g_idx].ecm015 = l_ecm[l_i].ecm015
            LET g_tree[g_idx].ecm014 = l_ecm[l_i].ecm014
            LET g_tree[g_idx].has_children = TRUE
            LET att[g_idx].wip=' '

            LET g_count = 0
            SELECT COUNT(*) INTO l_child FROM ecm_file
             WHERE ecm015 = l_ecm[l_i].ecm012
               AND ecm01 = p_tex
            LET g_count = l_child

            CALL q700_tree_fill4(g_tree[g_idx].id,g_tree[g_idx].desc,p_level,g_idx,l_ecm[l_i].ecm014,l_ecm[l_i].ecm015)

#           IF l_child > 0 THEN
            IF g_count > 0 THEN
               CALL q700_tree_fill(g_tree[g_idx].id,g_tree[g_idx].desc,p_level,g_idx )
          #  ELSE
          #     CALL q700_tree_fill4(g_tree[g_idx].id,g_tree[g_idx].desc,p_level,g_idx,l_ecm[l_i].ecm014,l_ecm[l_i].ecm015)
            END IF
          END FOR
      END IF
END FUNCTION

FUNCTION q700_tree_fill4(p_pid,p_tex,p_level,p_idx,p_ecm014,p_ecm015)
DEFINE p_pid           LIKE sfb_file.sfb01              #父id
DEFINE p_tex           LIKE sfb_file.sfb01
DEFINE p_level         LIKE type_file.num5               #階層
DEFINE p_idx           LIKE type_file.num5              #父的数组下标
DEFINE p_ecm014        LIKE ecm_file.ecm014
DEFINE p_ecm015        LIKE ecm_file.ecm015
DEFINE l_child         INTEGER
DEFINE l_ecm          DYNAMIC ARRAY OF RECORD
            ecm03       LIKE ecm_file.ecm03,
            ecm012      LIKE ecm_file.ecm012,
            ecm014      LIKE ecm_file.ecm014,
            ecm45       LIKE ecm_file.ecm45,
            wip         LIKE type_file.num15_3,
            ecm65       LIKE ecm_file.ecm65,
            ecm301      LIKE ecm_file.ecm301,
            ecm311      LIKE ecm_file.ecm311
                      END RECORD
DEFINE l_str           STRING
DEFINE max_level       LIKE type_file.num5               #最大階層數,可避免無窮迴圈.
DEFINE l_i             LIKE type_file.num5
DEFINE l_cnt           LIKE type_file.num5
DEFINE l_ecb03         LIKE ecb_file.ecb03
DEFINE l_ecb06         LIKE ecb_file.ecb06
DEFINE l_ecb17         LIKE ecb_file.ecb17
DEFINE l_n             LIKE type_file.num10
DEFINE l_n1            LIKE type_file.num10

   LET max_level = 20          #設定最大階層數為20
   LET p_level = p_level + 1   #下一階層
   IF p_level > max_level THEN
      IF g_sma.sma541 ='Y' THEN   #TQC-BC0034
          CALL cl_err_msg("","agl1001",max_level,0)
      END IF 
      RETURN
   END IF

   LET g_sql=" SELECT ecm03,ecm012,ecm014,ecm45,'',ecm65,ecm301,ecm311 ",
             "   FROM ecm_file ",
             "  WHERE ecm01='",p_tex,"' ",
             "    AND ecm012='",p_pid,"' AND ecm014='",p_ecm014,"' AND ecm015='",p_ecm015,"'"

   PREPARE q700_tree_pre3 FROM g_sql
   DECLARE q700_tree_cs3 CURSOR FOR q700_tree_pre3

   LET l_cnt = 1
   CALL l_ecm.clear()
   FOREACH q700_tree_cs3 INTO l_ecm[l_cnt].*
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      CALL q700_get_wip1(p_tex,l_ecm[l_cnt].ecm03,l_ecm[l_cnt].ecm012) RETURNING l_ecm[l_cnt].wip
      LET l_cnt = l_cnt + 1
   END FOREACH

   FREE q700_tree_cs3
   CALL l_ecm.deleteelement(l_cnt)
   LET l_cnt = l_cnt - 1
      IF l_cnt >0 THEN
         FOR l_i=1 TO l_cnt
            LET g_idx = g_idx + 1
            LET g_tree[g_idx].pid = p_pid
            LET g_tree[g_idx].id = l_ecm[l_i].ecm012
            LET g_tree[g_idx].expanded = 1      #0:不展開, 1:展開
            LET g_tree[g_idx].name =l_ecm[l_i].ecm03,"   ",l_ecm[l_i].ecm45
            LET g_tree[g_idx].wip =l_ecm[l_i].wip
            LET g_tree[g_idx].sta=''

            IF g_tree[g_idx].wip<0 THEN
               LET att[g_idx].wip="red reverse"
            ELSE
               LET att[g_idx].wip=""
            END IF

            IF l_ecm[l_i].ecm311>=l_ecm[l_i].ecm65 AND l_ecm[l_i].wip<=0 THEN
               LET g_tree[g_idx].sta='1'
               LET g_tree[g_idx].img="flag-green.ico"
            END IF

            IF l_ecm[l_i].ecm301>0 AND l_ecm[l_i].wip=0 THEN
                LET g_tree[g_idx].sta='1'
                LET g_tree[g_idx].img="flag-green.ico"
            END IF

            IF l_ecm[l_i].wip>0 THEN
               LET g_tree[g_idx].sta='2'
               LET g_tree[g_idx].img="flag-yellow.ico"
            END IF

            IF l_ecm[l_i].ecm301=0 THEN
               LET g_tree[g_idx].sta='3'
               LET g_tree[g_idx].img="flag-red.ico"
            END IF

            LET g_tree[g_idx].level = p_level
            LET g_tree[g_idx].desc = p_tex
            LET g_tree[g_idx].chk = '3'
            LET g_tree[g_idx].ecm03 = l_ecm[l_i].ecm03
            LET g_tree[g_idx].ecm015 = p_ecm015
            LET g_tree[g_idx].ecm014 = p_ecm014
            LET g_tree[g_idx].has_children = FALSE
          END FOR
      END IF
END FUNCTION

FUNCTION q700_get_wip1(p_ecm01,p_ecm03,p_ecm012)
DEFINE p_ecm01  LIKE ecm_file.ecm01
DEFINE p_ecm03  LIKE ecm_file.ecm03
DEFINE p_ecm012 LIKE ecm_file.ecm012
DEFINE l_ecm    RECORD LIKE ecm_file.*
DEFINE l_wipqty LIKE type_file.num15_3
DEFINE  p_i     LIKE type_file.num5

#      某站若要報工則其可報工數=WIP量(a+b-f-g-d-e-h+i)，
#      若要做Check-In則可報工數=c-f-g-d-e-h+i。
       INITIALIZE l_ecm.* TO NULL

       SELECT * INTO l_ecm.* FROM ecm_file
        WHERE ecm01=p_ecm01
          AND ecm03=p_ecm03
          AND ecm012=p_ecm012

       IF l_ecm.ecm54='Y' THEN   #check in 否
        LET l_wipqty
                        =  l_ecm.ecm291                  #check in
                         - l_ecm.ecm311 #*g_ecm59        #良品轉出
                         - l_ecm.ecm312 #*g_ecm59        #重工轉出
                         - l_ecm.ecm313 #*g_ecm59        #當站報廢
                         - l_ecm.ecm314 #*g_ecm59        #當站下線
                         - l_ecm.ecm316 #*g_ecm59
       ELSE
        LET l_wipqty
                        =  l_ecm.ecm301                  #良品轉入量
                         + l_ecm.ecm302                  #重工轉入量
                         + l_ecm.ecm303
                         - l_ecm.ecm311 #*g_ecm59        #良品轉出
                         - l_ecm.ecm312 #*g_ecm59        #重工轉出
                         - l_ecm.ecm313 #*g_ecm59        #當站報廢
                         - l_ecm.ecm314 #*g_ecm59        #當站下線
                         - l_ecm.ecm316 #*g_ecm59
       END IF

       IF cl_null(l_wipqty) THEN
          LET l_wipqty=0
       END IF

       RETURN l_wipqty
END FUNCTION

# Descriptions...: 顯示圖片(30主機上並未添加顯示圖標控件，所以取消此function功能)
#FUNCTION q700_show_pic(p_idx,p_chk)
#    DEFINE p_idx  LIKE type_file.num5
#    DEFINE l_wc   STRING
#    DEFINE p_ima04 LIKE ima_file.ima04
#    DEFINE l_sfb05 LIKE sfb_file.sfb05
#    DEFINE p_chk   LIKE type_file.chr1
#
#
#    LET g_doc.column1 = "ima01"
#
#    IF g_tree[p_idx].chk='1' OR p_chk='Y' THEN
#        LET l_sfb05=''
#        SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=g_sfb.sfb01
#        LET g_doc.value1 = l_sfb05
#    ELSE
#       LET g_doc.value1 = g_tree[p_idx].id
#    END IF
#    CALL cl_get_fld_doc("ima04")
#
#END FUNCTION
#FUN-B90117--END

