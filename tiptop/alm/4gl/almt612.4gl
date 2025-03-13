# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: almt612.4gl
# Descriptions...: 卡作废/注销/挂失/续期
# Date & Author..: FUN-960134 09/10/13 By shiwuying
# Modify.........: No:FUN-9B0136 09/11/24 By shiwuying
# Modify.........: No:FUN-9C0101 09/12/23 By shiwuying 開窗修改
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:FUN-A10104 10/01/20 By shiwuying 單身取消時不刪除單頭,方便整批處理資料
# Modify.........: No:TQC-A10140 10/01/22 By shiwuying 卡內有餘額不可註銷
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30212 10/03/26 By Smapmin 增加錯誤訊息
# Modify.........: No:MOD-A30213 10/03/26 By Smapmin 單身預設上筆的功能不做卡號自動累加1的動作.
# Modify.........: No:MOD-A30219 10/03/26 By Smapmin 增加錯誤訊息
# Modify.........: No:FUN-A70064 10/07/12 By shaoyong 發卡原因抓取代碼類別='2.理由碼'且理由碼用途類別='G.卡異動原因'
# Modify.........: No:FUN-A70130 10/08/09 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位  
# Modify.........: No:FUN-AA0072 10/10/25 By huangtao 修改清空lru04，而azf03不清空的bug
# Modify.........: No:MOD-AC0216 10/12/18 By suncx 選擇非該會員擁有的卡種的管控
# Modify.........: No:TQC-B20097 11/02/18 By lilingyu 資料取消審核時,審核人欄位帶入'N'值,應清空
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-C30042 12/03/21 By pauline lph09調整 0.無效期限制  1.指定日期  2.指定長度
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C90070 12/09/20 By xumeimei 添加GR打印功能
# Modify.........: No.FUN-CA0160 12/11/20 By baogc 添加POS單號
# Modify.........: No:FUN-CB0098 12/11/22 By Sakura IFRS 換卡積分清零調整
# Modify.........: No:FUN-CA0096 12/11/27 By pauline 卡掛失時會員編號可以開放為null,將卡掛失取消確認action 拿掉
# Modify.........: No:FUN-CC0060 12/12/06 By johnson wpc通知機制測試
# Modify.........: No:CHI-C80041 12/12/26 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:CHI-D20015 13/03/28 By lixh1 整批修改update[確認]/[取消確認]動作時,要一併異動確認異動人員與確認異動日期
# Modify.........: No:FUN-C30177 13/04/02 By Sakura 卡註銷提供取消確認的動作
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模组变数(Module Variables)
DEFINE g_lru               RECORD LIKE lru_file.*        #签核等级 (单头)
DEFINE g_lru_t             RECORD LIKE lru_file.*        #签核等级 (旧值)
DEFINE g_lru_o             RECORD LIKE lru_file.*        #签核等级 (旧值)
DEFINE g_lru01_t           LIKE lru_file.lru01           #签核等级 (旧值)
DEFINE g_lru00             LIKE lru_file.lru00           #单据类型0/1/2/3
#DEFINE g_t1                LIKE lrk_file.lrkslip        #FUN-A70130  mark
#DEFINE g_sheet             LIKE lrk_file.lrkslip        #FUN-A70130  mark
DEFINE g_t1                LIKE oay_file.oayslip         #FUN-A70130       
DEFINE g_sheet             LIKE oay_file.oayslip         #FUN-A70130 
DEFINE g_lrv               DYNAMIC ARRAY OF RECORD       #程式变数(Program Variables)
                           lrv02   LIKE lrv_file.lrv02,  #卡號
                           lrv03   LIKE lrv_file.lrv03,  #原有效期
                           lrv04   LIKE lrv_file.lrv04   #有效期
                           END RECORD
DEFINE g_lrv_t             RECORD                        #程式变数 (旧值)
                           lrv02   LIKE lrv_file.lrv02,  #卡號
                           lrv03   LIKE lrv_file.lrv03,  #原有效期
                           lrv04   LIKE lrv_file.lrv04   #有效期
                           END RECORD
DEFINE g_lrv_o             RECORD                        #程式变数 (旧值)
                           lrv02   LIKE lrv_file.lrv02,  #卡號
                           lrv03   LIKE lrv_file.lrv03,  #原有效期
                           lrv04   LIKE lrv_file.lrv04   #有效期
                           END RECORD
DEFINE g_sql               STRING                        #CURSOR暂存
DEFINE g_wc                STRING                        #单头CONSTRUCT结果
DEFINE g_wc2               STRING                        #单身CONSTRUCT结果
DEFINE g_rec_b             LIKE type_file.num10          #单身笔数
DEFINE l_ac                LIKE type_file.num10          #目前处理的ARRAY CNT
 
DEFINE g_forupd_sql        STRING                        #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num10          #count/index for any purpose
DEFINE g_msg               LIKE ze_file.ze03
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10          #总笔数
DEFINE g_jump              LIKE type_file.num10          #查询指定的笔数
DEFINE g_no_ask            LIKE type_file.num10          #是否开启指定笔视窗
DEFINE g_argv1             LIKE lru_file.lru00           #单据类型
DEFINE g_argv2             LIKE lru_file.lru01           #单据类型
#DEFINE g_kindtype          LIKE lrk_file.lrkkind        #FUN-A70130  mark
DEFINE g_kindtype          LIKE oay_file.oaytype         #FUN-A70130
#FUN-C90070----add---str
DEFINE g_wc1                 STRING
DEFINE g_wc3                 STRING
DEFINE g_wc4                 STRING
DEFINE l_table               STRING
TYPE sr1_t RECORD
    lruplant  LIKE lru_file.lruplant,
    lru00     LIKE lru_file.lru00,
    lru01     LIKE lru_file.lru01, 
    lru02     LIKE lru_file.lru02,
    lru03     LIKE lru_file.lru03,
    lru04     LIKE lru_file.lru04,
    lru05     LIKE lru_file.lru05,
    lru06     LIKE lru_file.lru06,
    lru07     LIKE lru_file.lru07,
    lru08     LIKE lru_file.lru08,
    lru09     LIKE lru_file.lru09,
    lrv02     LIKE lrv_file.lrv02,
    lrv03     LIKE lrv_file.lrv03,
    rtz13     LIKE rtz_file.rtz13,
    lph02     LIKE lph_file.lph02,
    azf03     LIKE azf_file.azf03
END RECORD
#FUN-C90070----add---end
DEFINE g_void              LIKE type_file.chr1      #CHI-C80041
 
MAIN
   OPTIONS                               #改变一些系统预设值
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT                       #撷取中断键, 由程式处理
 
   LET g_argv1=ARG_VAL(1)                #单据类型
   LET g_argv2=ARG_VAL(2)                #单据编号
   IF cl_null(g_argv1) THEN LET g_argv1 = '1' END IF
   CASE g_argv1
        WHEN '1' LET g_prog = "almt612"
                 LET g_lru00= "1"
                 #LET g_kindtype = '39'   #卡作废 #FUN-A70130
                 LET g_kindtype = 'N4'   #卡作废 #FUN-A70130
        WHEN '2' LET g_prog = "almt613"
                 LET g_lru00= "2"
                 #LET g_kindtype = '40'   #卡注销 #FUN-A70130
                 LET g_kindtype = 'N5'   #卡注销 #FUN-A70130
        WHEN '3' LET g_prog = "almt614"
                 LET g_lru00= "3"
                 #LET g_kindtype = '41'   #卡挂失 #FUN-A70130
                 LET g_kindtype = 'N6'   #卡挂失 #FUN-A70130
        WHEN '4' LET g_prog = "almt615"
                 LET g_lru00= "4"
                 #LET g_kindtype = '42'   #卡续期#FUN-A70130
                 LET g_kindtype = 'N7'   #卡续期#FUN-A70130
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   #FUN-C90070------add-----str
   LET g_pdate = g_today
   LET g_sql ="lruplant.lru_file.lruplant,",
              "lru00.lru_file.lru00,",
              "lru01.lru_file.lru01,",
              "lru02.lru_file.lru02,",
              "lru03.lru_file.lru03,",
              "lru04.lru_file.lru04,",
              "lru05.lru_file.lru05,",
              "lru06.lru_file.lru06,",
              "lru07.lru_file.lru07,",
              "lru08.lru_file.lru08,",
              "lru09.lru_file.lru09,",
              "lrv02.lrv_file.lrv02,",
              "lrv03.lrv_file.lrv03,",
              "rtz13.rtz_file.rtz13,",
              "lph02.lph_file.lph02,",
              "azf03.azf_file.azf03"
   LET l_table = cl_prt_temptable('almt612',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ? )"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end
   LET g_forupd_sql = "SELECT * FROM lru_file WHERE lru01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t612_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW t612_w WITH FORM "alm/42f/almt612"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_set_locale_frm_name("almt612")
  #CALL cl_set_locale_frm_name(g_prog)
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("lrv04",TRUE)
   IF g_argv1 = '4' THEN  #卡续期
      CALL cl_set_comp_visible("lrv04",TRUE)
   ELSE
      CALL cl_set_comp_visible("lrv04",FALSE)
   END IF
  #IF g_argv1 = '2' OR g_argv1 = '4' THEN  #FUN-CA0096 mark 
  #IF g_argv1 = '2' OR g_argv1 = '4' OR g_argv1 = '3' THEN  #FUN-CA0096  add #FUN-C30177 mark 
   IF g_argv1 = '4' OR g_argv1 = '3' THEN  #FUN-CA0096  add #FUN-C30177 add 
      CALL cl_set_act_visible("undo_confirm",FALSE)
   ELSE
      CALL cl_set_act_visible("undo_confirm",TRUE)
   END IF

  #FUN-CA0160 Add Begin ---
   IF g_argv1 = '2' THEN
      CALL cl_set_comp_visible("lru10",TRUE)
   ELSE
      CALL cl_set_comp_visible("lru10",FALSE)
   END IF
  #FUN-CA0160 Add End -----
 
   IF NOT cl_null(g_argv2) THEN
      IF cl_chk_act_auth() THEN
         CALL t612_q()
      END IF
   ELSE
      CALL t612_menu()
   END IF
 
   CLOSE WINDOW t612_w                 #结束画面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
#QBE 查询资料
FUNCTION t612_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM
   CALL g_lrv.clear()
 
   IF NOT cl_null(g_argv2) THEN
      LET g_wc = " lru01 = '",g_argv2,"'"
   ELSE
      CALL cl_set_head_visible("","YES")
      INITIALIZE g_lru.* TO NULL
      DISPLAY g_lru00 TO lru00
      CONSTRUCT BY NAME g_wc ON lruplant,lrulegal,lru01,lru02,lru03,lru04,lru10,  #FUN-CA0160 Add lru10
                                lru05,lru06,lru07,lru08,lru09,
                                lruuser,lrugrup,lruoriu,lruorig,lrucrat,
                                lrumodu,lruacti,lrudate
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(lru01)               #单据编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lru01"
                  LET g_qryparam.arg1 =g_lru00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lru01
                  NEXT FIELD lru01
               WHEN INFIELD(lruplant)               #门店
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lruplant"
                  LET g_qryparam.arg1 =g_lru00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lruplant
                  NEXT FIELD lruplant
               WHEN INFIELD(lrulegal)               #法人
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrulegal"
                  LET g_qryparam.arg1 =g_lru00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrulegal
                  NEXT FIELD lrulegal
               WHEN INFIELD(lru02)               #会员编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lru02"
                  LET g_qryparam.arg1 =g_lru00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lru02
                  NEXT FIELD lru02
               WHEN INFIELD(lru03)               #卡种编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lru03"
                  LET g_qryparam.arg1 =g_lru00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lru03
                  NEXT FIELD lru03
               WHEN INFIELD(lru04)               #原因编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lru04_1"                        #FUN-A70064 mod
                  LET g_qryparam.arg1 =g_lru00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lru04
                  NEXT FIELD lru04
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
 
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
 
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   #FUN-C90070-----add----str
   IF g_wc <> " 1=1" THEN
      LET g_wc = g_wc CLIPPED," AND lru00 = '",g_lru00,"'"
   ELSE
      LET g_wc = " lru00 = '",g_lru00,"'"
   END IF
   #FUN-C90070-----add----end
   #LET g_wc = g_wc CLIPPED," AND lru00 = '",g_lru00,"'"   #FUN-C90070 mark
 
   #资料权限的检查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的资料
   #      LET g_wc = g_wc clipped," AND lruuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的资料
   #      LET g_wc = g_wc clipped," AND lrugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #
   #      LET g_wc = g_wc clipped," AND lrugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lruuser', 'lrugrup')
   #End:FUN-980030
 
   IF NOT cl_null(g_argv2) THEN
      LET g_wc2 = ' 1=1'
   ELSE
      CONSTRUCT g_wc2 ON lrv02,lrv03,lrv04
                FROM s_lrv[1].lrv02,s_lrv[1].lrv03,s_lrv[1].lrv04
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(lrv02)               #卡号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_lrv02"
                  LET g_qryparam.arg1 =g_lru00
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lrv02
                  NEXT FIELD lrv02
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END CONSTRUCT
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
 
   #LET g_wc2 = g_wc2 CLIPPED," AND lrv00 ='",g_lru00,"'"
 
   IF g_wc2 = " 1=1" THEN                  # 若单身未输入条件
      LET g_sql = "SELECT lru01 FROM lru_file ",
                  " WHERE ", g_wc CLIPPED,
                # "   AND lruplant IN ",g_auth,
                  " ORDER BY lru01"
   ELSE                                    # 若单身有输入条件
      LET g_sql = "SELECT UNIQUE lru01 ",
                  "  FROM lru_file, lrv_file ",
                  " WHERE lru01 = lrv01 ",
                  "   AND lru00 = lrv00 ",
                  "   AND lrv00 ='",g_lru00,"'",
                # "   AND lruplant IN ",g_auth,
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY lru01"
   END IF
 
   PREPARE t612_prepare FROM g_sql
   DECLARE t612_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t612_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎条件笔数
      LET g_sql="SELECT COUNT(*) FROM lru_file WHERE ",g_wc CLIPPED
               #"   AND lruplant IN ",g_auth
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT lru01) FROM lru_file,lrv_file",
                " WHERE lru00 = lrv00 ",
                "   AND lru01 = lrv01 ",
                "   AND lrv00 ='",g_lru00,"'",
               #"   AND lruplant IN ",g_auth,
                "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t612_precount FROM g_sql
   DECLARE t612_count CURSOR FOR t612_precount
 
END FUNCTION
 
FUNCTION t612_menu()
 
   WHILE TRUE
      CALL t612_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t612_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t612_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t612_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t612_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t612_x()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t612_b('u')
            ELSE
               LET g_action_choice = NULL
            END IF
 
#FUN-C90070------add------str
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t612_out()
           END IF
#FUN-C90070------add------end
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t612_y()
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t612_z()
            END IF
 
         WHEN "gen_body1"
            IF cl_chk_act_auth() THEN
               CALL t612_gen_body()
            END IF
 
         WHEN "delete_body"
            IF cl_chk_act_auth() THEN
               CALL t612_delete_body()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrv),'','')
            END IF
 
         WHEN "related_document"  #相关文件
            IF cl_chk_act_auth() THEN
               IF g_lru.lru01 IS NOT NULL THEN
               LET g_doc.column1 = "lru01"
               LET g_doc.value1 = g_lru.lru01
               CALL cl_doc()
            END IF
         END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t612_v()
               IF g_lru.lru06='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_lru.lru06,'','','',g_void,g_lru.lruacti)
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t612_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lrv TO s_lrv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
        #IF g_lru00 MATCHES '[123]' THEN
        #   CALL cl_set_act_visible("undo_confirm", FALSE)
        #END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL t612_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t612_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t612_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION next
         CALL t612_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION last
         CALL t612_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY
 
      ON ACTION invalid
         LET g_action_choice="invalid"
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
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION gen_body1
         LET g_action_choice="gen_body1"
         EXIT DISPLAY
 
      ON ACTION delete_body
         LET g_action_choice="delete_body"
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t612_bp_refresh()
  DISPLAY ARRAY g_lrv TO s_lrv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION t612_a()
   DEFINE li_result   LIKE type_file.num5
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_lrv.clear()
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_lru.* LIKE lru_file.*             #DEFAULT 设定
   LET g_lru01_t = NULL
 
   #预设值及将数值类变数清成零
   LET g_lru_t.* = g_lru.*
   LET g_lru_o.* = g_lru.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_lru.lruplant = g_plant
      LET g_lru.lrulegal = g_legal
      LET g_lru.lru00 = g_lru00
      LET g_lru.lru05 = g_today
      SELECT * FROM rtz_file WHERE rtz01 = g_plant    
      IF SQLCA.sqlcode = 0 THEN  #若是门店login,非区域时
         LET g_lru.lruplant = g_plant
      END IF
      LET g_lru.lru05 = g_today
      LET g_lru.lru06 = 'N'      #审核状态
      LET g_lru.lruuser=g_user
      LET g_lru.lruoriu = g_user
      LET g_lru.lruorig = g_grup
      LET g_lru.lrugrup=g_grup
      LET g_lru.lrucrat=g_today
      LET g_lru.lruacti='Y'              #资料有效
      LET g_data_plant = g_plant  #No.FUN-A10060
 
      CALL t612_i("a")                   #输入单头
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_lru.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_lru.lru01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #输入后, 若该单据需自动编号, 并且其单号为空白, 则自动赋予单号
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lru.lru01,g_lru.lru05,g_kindtype,"lru_file","lru01",g_lru.lruplant,"","")
           RETURNING li_result,g_lru.lru01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lru.lru01
 
      INSERT INTO lru_file VALUES (g_lru.*)
 
      IF SQLCA.sqlcode THEN                     #置入资料库不成功
         CALL cl_err3("ins","lru_file",g_lru.lru01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_lru.lru01,'I')
      END IF
 
      SELECT * INTO g_lru.* FROM lru_file
       WHERE lru01 = g_lru.lru01
      LET g_lru01_t = g_lru.lru01        #保留旧值
      LET g_lru_t.* = g_lru.*
      LET g_lru_o.* = g_lru.*
      CALL g_lrv.clear()
 
      LET g_rec_b = 0
   #  CALL t612_gen_body()
      CALL t612_b('a')
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t612_u()
   DEFINE l_lrz02       LIKE lrz_file.lrz02
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lru.lru01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lru.* FROM lru_file
    WHERE lru01=g_lru.lru01
   #不可跨门店改动资料
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
 
   IF g_lru.lruacti ='N' THEN    #检查资料是否为无效
      CALL cl_err(g_lru.lru01,'mfg1000',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lru.lru06 = 'Y' THEN
      CALL cl_err(g_lru.lru01,'mfg1005',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lru01_t = g_lru.lru01
   BEGIN WORK
 
   OPEN t612_cl USING g_lru.lru01
   IF STATUS THEN
      CALL cl_err("OPEN t612_cl:", STATUS, 1)
      CLOSE t612_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t612_cl INTO g_lru.*                      # 锁住将被更改或取消的资料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0)    # 资料被他人LOCK
       CLOSE t612_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL t612_show()
 
   WHILE TRUE
      LET g_lru01_t = g_lru.lru01
      LET g_lru_o.* = g_lru.*
      LET g_lru.lrumodu=g_user
      LET g_lru.lrudate=g_today
 
      CALL t612_i("u")                      #栏位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lru.*=g_lru_t.*
         CALL t612_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_lru.lru01 != g_lru01_t THEN            # 更改单号
         UPDATE lrv_file SET lrv01 = g_lru.lru01
          WHERE lrv01 = g_lru01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lrv_file",g_lru01_t,"",SQLCA.sqlcode,"","lrv",1)
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE lru_file SET lru_file.* = g_lru.*
       WHERE lru01 = g_lru01_t
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","lru_file",g_lru01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t612_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lru.lru01,'U')
 
   CALL t612_show()
   CALL t612_b_fill("1=1")
   CALL t612_bp_refresh()
 
END FUNCTION
 
FUNCTION t612_i(p_cmd)
   DEFINE l_n         LIKE type_file.num10
   DEFINE p_cmd       LIKE type_file.chr1     #a:输入 u:更改
   DEFINE li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_lru.lru00,g_lru.lruplant,g_lru.lru01,g_lru.lru02,
                   g_lru.lru03,g_lru.lru04,g_lru.lru05,g_lru.lru06,
                   g_lru.lru07,g_lru.lru08,g_lru.lru09,g_lru.lru10, #FUN-CA0160 Add lru10
                   g_lru.lruuser,g_lru.lrumodu,g_lru.lrucrat,
                   g_lru.lrugrup,g_lru.lrudate,g_lru.lruacti,
                   g_lru.lruoriu,g_lru.lruorig,
                   g_lru.lruplant,g_lru.lrulegal
   CALL t612_lruplant('d')
 
   CALL cl_set_head_visible("","YES")
   INPUT BY NAME g_lru.lruplant,g_lru.lru01,g_lru.lru02,g_lru.lru03,g_lru.lru04,g_lru.lru09
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t612_set_entry(p_cmd)
         CALL t612_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lru01")
 
      AFTER FIELD lru01
         #单号处理方式:
         #在输入单别后, 至单据性质档中读取该单别资料;
         #若该单别不需自动编号, 则让使用者自行输入单号, 并检查其是否重复
         #若要自动编号, 则单号不用输入, 直到单头输入完成后, 再行自动指定单号
         IF NOT cl_null(g_lru.lru01) THEN
            CALL s_check_no("alm",g_lru.lru01,g_lru01_t,g_kindtype,"lru_file","lru01","")
                 RETURNING li_result,g_lru.lru01
            IF (NOT li_result) THEN
               LET g_lru.lru01=g_lru_o.lru01
               NEXT FIELD lru01
            END IF
            DISPLAY BY NAME g_lru.lru01
         END IF
 
      AFTER FIELD lruplant                  #门店编号
         IF NOT cl_null(g_lru.lruplant) THEN
            IF g_lru_o.lruplant IS NULL OR g_lru_o.lruplant != g_lru.lruplant THEN
               CALL t612_lruplant(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lru.lruplant,g_errno,0)
                  LET g_lru.lruplant = g_lru_o.lruplant
                  DISPLAY BY NAME g_lru.lruplant
                  NEXT FIELD lruplant
               END IF
            END IF
            LET g_lru_o.lruplant = g_lru.lruplant
         END IF
 
      AFTER FIELD lru02                  #会员编号
         IF cl_null(g_lru.lruplant) THEN NEXT FIELD lruplant END IF
         IF NOT cl_null(g_lru.lru02) THEN
            IF g_lru_o.lru02 IS NULL OR g_lru_o.lru02 != g_lru.lru02 THEN
               CALL t612_lru02(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lru.lru02,g_errno,0)
                  LET g_lru.lru02 = g_lru_o.lru02
                  DISPLAY BY NAME g_lru.lru02
                  NEXT FIELD lru02
               END IF
            END IF
         END IF
 
      AFTER FIELD lru03                  #卡种编号
         IF cl_null(g_lru.lruplant) THEN NEXT FIELD lruplant END IF
         IF NOT cl_null(g_lru.lru03) THEN
            IF g_lru_o.lru03 IS NULL OR g_lru_o.lru03 != g_lru.lru03 THEN
               CALL t612_lru03(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_lru.lru03,g_errno,0)
                  LET g_lru.lru03 = g_lru_o.lru03
                  DISPLAY BY NAME g_lru.lru03
                  NEXT FIELD lru03
               END IF
            END IF
         END IF
 
      AFTER FIELD lru04                  #原因编号
         IF cl_null(g_lru.lruplant) THEN NEXT FIELD lruplant END IF
         IF NOT cl_null(g_lru.lru04) THEN
            IF g_lru_o.lru04 IS NULL OR g_lru_o.lru04 != g_lru.lru04 THEN
               CALL t612_lru04(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  IF g_errno = 'alm-806' THEN
                     CALL cl_err("",'alm-31',0)
                  ELSE
                     CALL cl_err(g_lru.lru04,g_errno,0)
                  END IF
                  LET g_lru.lru04 = g_lru_o.lru04
                  DISPLAY BY NAME g_lru.lru04
                  NEXT FIELD lru04
               END IF
            END IF
         ELSE
             DISPLAY '' TO FORMONLY.azf03                    #FUN-AA0072
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #栏位说明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lru01)     #单据编号
               LET g_t1=s_get_doc_no(g_lru.lru01)
              # CALL q_lrk(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130  mark
              CALL q_oay(FALSE,FALSE,g_t1,g_kindtype,'ALM') RETURNING g_t1     #FUN-A70130  add
               LET g_lru.lru01 = g_t1
               DISPLAY BY NAME g_lru.lru01
               NEXT FIELD lru01
            WHEN INFIELD(lru02)     #
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lpk"
               LET g_qryparam.default1 = g_lru.lru02
               CALL cl_create_qry() RETURNING g_lru.lru02
               DISPLAY BY NAME g_lru.lru02
               CALL t612_lru02('d')
               NEXT FIELD lru02
            WHEN INFIELD(lru03)     #卡种编号
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_lph1"
               LET g_qryparam.default1 = g_lru.lru03
               CALL cl_create_qry() RETURNING g_lru.lru03
               DISPLAY BY NAME g_lru.lru03
               CALL t612_lru03('d')
               NEXT FIELD lru03
            WHEN INFIELD(lru04)     #原因编号
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf03"                    #FUN-A70064
               LET g_qryparam.default1 = g_lru.lru04
               LET g_qryparam.arg1='2'                            #FUN-A70064
               LET g_qryparam.arg2 = 'G'                          #FUN-A70064
               CALL cl_create_qry() RETURNING g_lru.lru04
               DISPLAY BY NAME g_lru.lru04
               CALL t612_lru04('d')
               NEXT FIELD lru04
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
 
FUNCTION t612_lruplant(p_cmd)  #门店编号
    DEFINE l_rtz13      LIKE rtz_file.rtz13    #FUN-A80148
    DEFINE l_rtz28      LIKE rtz_file.rtz28    #FUN-A80148
  # DEFINE l_rtzacti    LIKE rtz_file.rtzacti  #FUN-A80148 mark by vealxu
    DEFINE l_azwacti    LIKE azw_file.azwacti  #FUN-A80148 add  by vealxu      
    DEFINE p_cmd        LIKE type_file.chr1
    DEFINE l_azt02      LIKE azt_file.azt02
 
   LET g_errno = " "
 
   SELECT rtz13,rtz28,azwacti                    #FUN-A80148 mod rtzacti -> azwacti  by vealxu
     INTO l_rtz13,l_rtz28,l_azwacti              #FUN-A80148 mod l_rtzacti -> l_azwacti by vealxu
     FROM rtz_file INNER JOIN azw_file           #FUN-A80148 add azw_file by vealxu
       ON rtz01 = azw01                          #FUN-A80148 add by vealxu   
    WHERE rtz01 = g_lru.lruplant
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-001'  #该门店编号不存在
                                  LET l_rtz13 = NULL
        WHEN l_rtz28 = 'N'        LET g_errno = 'alm-002'  #该笔门店资料未审核
      # WHEN l_rtzacti = 'N'      LET g_errno = 'aap-223'  #该门店编号无效!          #FUN-A80148 mark by velaxu
        WHEN l_azwacti = 'N'      LET g_errno = 'aap-223'  #该门店编号无效!          #FUN-A80148 add  by vealxu
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
  #IF cl_null(g_errno) THEN
  #   LET g_sql = "SELECT * FROM aza_file WHERE '",g_lru.lruplant,"' IN ",g_auth
  #   PREPARE lruplant_p1 FROM g_sql
  #   EXECUTE lruplant_p1
  #   IF SQLCA.sqlcode THEN
  #      LET g_errno = 'alm-391'   #当前用户不可存取此门店!
  #   END IF
  #END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      IF p_cmd <> 'd' THEN
         SELECT azw02 INTO g_lru.lrulegal FROM azw_file
          WHERE azw01 = g_lru.lruplant
         DISPLAY BY NAME g_lru.lrulegal
      END IF
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lru.lrulegal
      DISPLAY l_azt02 TO FORMONLY.azt02
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION
 
FUNCTION t612_lru02(p_cmd)  #会员编号
 DEFINE l_lpk01      LIKE lpk_file.lpk01
 DEFINE p_cmd        LIKE type_file.chr1
 DEFINE l_cnt        LIKE type_file.num5
 
   LET g_errno = " "
 
   SELECT lpk01 INTO l_lpk01
     FROM lpk_file
    WHERE lpk01 = g_lru.lru02
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-682'  #会员编号不存在
                                  LET l_lpk01 = NULL
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) AND g_rec_b <> 0 THEN
      SELECT COUNT(*) INTO l_cnt FROM lrv_file,lpj_file
       WHERE lpj03 = lrv02
         AND lpj01 <> g_lru.lru02
         AND lrv01 = g_lru.lru01
      IF l_cnt > 0 THEN
         LET g_errno = 'alm-692'
      END IF
   END IF
END FUNCTION
 
FUNCTION t612_lru03(p_cmd)   #卡种编号
 DEFINE l_lph02        LIKE lph_file.lph02
 DEFINE l_lph12        LIKE lph_file.lph12
 DEFINE l_lph24        LIKE lph_file.lph24
 DEFINE l_lphacti      LIKE lph_file.lphacti
 DEFINE p_cmd          LIKE type_file.chr1
  DEFINE l_cnt         LIKE type_file.num5
 
   LET g_errno = " "
 
   SELECT lph02,lph12,lph24,lphacti INTO l_lph02,l_lph12,l_lph24,l_lphacti
     FROM lph_file
    WHERE lph01 = g_lru.lru03
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-635'  #卡种不存在
                                  LET l_lph02 = NULL
                                  LET l_lph24 = NULL
        WHEN l_lph12 <> 'Y' AND g_lru00 = '4'      LET g_errno = 'alm-548'
        WHEN l_lph24 <> 'Y'       LET g_errno = '9029'
        WHEN l_lphacti <> 'Y'     LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) AND g_rec_b <> 0 THEN 
      SELECT COUNT(*) INTO l_cnt FROM lrv_file,lpj_file
       WHERE lpj03 = lrv02
         AND lpj02 <> g_lru.lru03
         AND lrv01 = g_lru.lru01
      IF l_cnt > 0 THEN
         LET g_errno = 'alm-693'
      END IF
   END IF

   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt FROM lnk_file
       WHERE lnk01 = g_lru.lru03
         AND lnk02 = '1'
         AND lnk03 = g_lru.lruplant
         AND lnk05 = 'Y'
      IF l_cnt = 0 THEN
         LET g_errno = 'alm-694'
      END IF
   END IF
   
   #MOD-AC0216 add ----begin---------------------
   IF cl_null(g_errno) AND NOT cl_null(g_lru.lru02) THEN
      SELECT COUNT(*) INTO l_cnt FROM lpj_file,lpk_file
       WHERE lpk01 = g_lru.lru02
         AND lpk01 = lpj01
         AND lpj02 = g_lru.lru03
      IF l_cnt = 0 THEN
         LET g_errno = 'alm1016'
      END IF
   END IF
   #MOD-AC0216 add -----end----------------------
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_lph02 TO FORMONLY.lph02
   END IF
END FUNCTION
 
FUNCTION t612_lru04(p_cmd)   #
    DEFINE l_azf03        LIKE azf_file.azf03
    DEFINE l_azfacti      LIKE azf_file.azfacti
    DEFINE p_cmd          LIKE type_file.chr1
      
   LET g_errno = " " 
 
   SELECT azf03,azfacti INTO l_azf03,l_azfacti
     FROM azf_file
    WHERE azf01 = g_lru.lru04
      AND azf02 = '2'                     #FUN-A70064
      AND azf09 = 'G'                     #FUN-A70064
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-806'
                                  LET l_azf03 = NULL
        WHEN l_azfacti <> 'Y'     LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
   END IF
END FUNCTION 
 
FUNCTION t612_lrv02(p_cmd)   #
 DEFINE p_cmd        LIKE type_file.chr1
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE l_lpj01      LIKE lpj_file.lpj01
 DEFINE l_lpj02      LIKE lpj_file.lpj02
 DEFINE l_lpj09      LIKE lpj_file.lpj09
 DEFINE l_lpj04      LIKE lpj_file.lpj04
 DEFINE l_lpj05      LIKE lpj_file.lpj05
 DEFINE l_lph12      LIKE lph_file.lph12
 DEFINE l_lpj06      LIKE lpj_file.lpj06 #No.TQC-A10140 增加判斷：卡內有餘額不可註銷
 
   LET g_errno = " "
 
   SELECT lpj01,lpj02,lpj09,lpj04,lpj05,lpj06
     INTO l_lpj01,l_lpj02,l_lpj09,l_lpj04,l_lpj05,l_lpj06
     FROM lpj_file
    WHERE lpj03 = g_lrv[l_ac].lrv02
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-806'
        WHEN l_lpj09 <> '2'         LET g_errno = 'alm-688'
        WHEN l_lpj04 > g_today OR l_lpj05 < g_today   
                                  LET g_errno = 'alm-981'   #MOD-A30219
        WHEN l_lpj06 > 0 AND (g_lru00 = '2' OR g_lru00 = '1')
                                  LET g_errno = 'alm-728'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt FROM lru_file,lrv_file
       WHERE lru01 = lrv01
         AND lrv02 = g_lrv[l_ac].lrv02
         AND lruacti = 'Y'
         AND lru06 = 'N'
      IF l_cnt > 0 THEN
         LET g_errno = 'alm-689'
      END IF
      IF NOT cl_null(g_lru.lru02) THEN
      #  IF l_lpj01 <> g_lru.lru02 THEN                     #No.FUN-9B0136
         IF cl_null(l_lpj01) OR l_lpj01 <> g_lru.lru02 THEN #No.FUN-9B0136
            LET g_errno = 'alm-690'
         END IF
      END IF
      IF NOT cl_null(g_lru.lru03) THEN
         IF l_lpj02 <> g_lru.lru03 THEN
            LET g_errno = 'alm-691'
         END IF
      END IF
   END IF
   IF cl_null(g_errno) AND g_lru00 = '4' THEN
      SELECT lph12 INTO l_lph12 FROM lph_file
       WHERE lph01 = l_lpj02
      IF l_lph12 = 'N' THEN
         LET g_errno = 'alm-548'
      END IF
   END IF
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt FROM lnk_file
       WHERE lnk01 = l_lpj02
         AND lnk02 = '1'
         AND lnk03 = g_lru.lruplant
         AND lnk05 = 'Y'
      IF l_cnt = 0 THEN
         LET g_errno = 'alm-694'
      END IF
   END IF
   IF cl_null(g_errno) THEN
      LET g_lrv[l_ac].lrv03 = l_lpj05
      DISPLAY BY NAME g_lrv[l_ac].lrv03
   END IF
END FUNCTION
 
FUNCTION t612_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_lrv.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t612_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_lru.* TO NULL
      RETURN
   END IF
 
   OPEN t612_cs                            # 从DB产生合乎条件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_lru.* TO NULL
   ELSE
      OPEN t612_count
      FETCH t612_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t612_fetch('F')                  # 读出TEMP第一笔并显示
   END IF
 
END FUNCTION
 
FUNCTION t612_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #处理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t612_cs INTO g_lru.lru01
      WHEN 'P' FETCH PREVIOUS t612_cs INTO g_lru.lru01
      WHEN 'F' FETCH FIRST    t612_cs INTO g_lru.lru01
      WHEN 'L' FETCH LAST     t612_cs INTO g_lru.lru01
      WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t612_cs INTO g_lru.lru01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0)
      INITIALIZE g_lru.* TO NULL
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
 
   SELECT * INTO g_lru.* FROM lru_file WHERE lru01 = g_lru.lru01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lru_file",g_lru.lru01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_lru.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_lru.lruuser
   LET g_data_group = g_lru.lrugrup
   LET g_data_plant = g_lru.lruplant #No.FUN-A10060
 
   CALL t612_show()
 
END FUNCTION
 
#将资料显示在画面上
FUNCTION t612_show()
 
   LET g_lru_t.* = g_lru.*                #保存单头旧值
   LET g_lru_o.* = g_lru.*                #保存单头旧值
   DISPLAY BY NAME g_lru.lru00,g_lru.lru01,g_lru.lru02,g_lru.lru03,
                   g_lru.lru04,g_lru.lru05,g_lru.lru06,g_lru.lru07,
                   g_lru.lru08,g_lru.lru09,g_lru.lruplant,g_lru.lrulegal,
                   g_lru.lruuser,g_lru.lrugrup,g_lru.lrumodu,
                   g_lru.lrudate,g_lru.lruacti,g_lru.lrucrat,
                   g_lru.lruoriu,g_lru.lruorig,g_lru.lru10   #FUN-CA0160 Add lru10
 
   CALL t612_lruplant('d')
   CALL t612_lru02('d')
   CALL t612_lru03('d')
   CALL t612_lru04('d')
   #CALL cl_set_field_pic(g_lru.lru06,'','','','',g_lru.lruacti)
   IF g_lru.lru06='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_lru.lru06,'','','',g_void,g_lru.lruacti)  #CHI-C80041
 
   CALL t612_b_fill(g_wc2)                 #单身
#  CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t612_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lru.lru01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   #不可跨门店改动资料
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'Y' THEN
      CALL cl_err(g_lru.lru01,'aap-019',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t612_cl USING g_lru.lru01
   IF STATUS THEN
      CALL cl_err("OPEN t612_cl:", STATUS, 1)
      CLOSE t612_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t612_cl INTO g_lru.*               # 锁住将被更改或取消的资料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0)          #资料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t612_show()
 
   IF cl_exp(0,0,g_lru.lruacti) THEN                   #确认一下
      LET g_chr=g_lru.lruacti
      IF g_lru.lruacti='Y' THEN
         LET g_lru.lruacti='N'
      ELSE
         LET g_lru.lruacti='Y'
      END IF
 
      UPDATE lru_file SET lruacti=g_lru.lruacti,
                          lrumodu=g_user,
                          lrudate=g_today
       WHERE lru01=g_lru.lru01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","lru_file",g_lru.lru01,"",SQLCA.sqlcode,"","",1)
         LET g_lru.lruacti=g_chr
      END IF
   END IF
 
   CLOSE t612_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_lru.lru01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT lruacti,lrumodu,lrudate
     INTO g_lru.lruacti,g_lru.lrumodu,g_lru.lrudate FROM lru_file
    WHERE lru01=g_lru.lru01
   DISPLAY BY NAME g_lru.lruacti,g_lru.lrumodu,g_lru.lrudate
   CALL cl_set_field_pic(g_lru.lru06,'','','','',g_lru.lruacti)
 
END FUNCTION
 
FUNCTION t612_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_lru.lru01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lru.* FROM lru_file
    WHERE lru01=g_lru.lru01
   #不可跨门店改动资料
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
   IF g_lru.lruacti ='N' THEN    #检查资料是否为无效
      CALL cl_err(g_lru.lru01,'alm-147',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lru.lru06 = 'Y' THEN
      CALL cl_err(g_lru.lru01,'alm-028',0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t612_cl USING g_lru.lru01
   IF STATUS THEN
      CALL cl_err("OPEN t612_cl:", STATUS, 1)
      CLOSE t612_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t612_cl INTO g_lru.*                      # 锁住将被更改或取消的资料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0)     # 资料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t612_show()
 
   IF cl_delh(0,0) THEN                   #确认一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "lru01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_lru.lru01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM lru_file WHERE lru01 = g_lru.lru01
      DELETE FROM lrv_file WHERE lrv01 = g_lru.lru01
      CLEAR FORM
      CALL g_lrv.clear()
      OPEN t612_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t612_cs
         CLOSE t612_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t612_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t612_cs
         CLOSE t612_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t612_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t612_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t612_fetch('/')
      END IF
   END IF
 
   CLOSE t612_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lru.lru01,'D')
END FUNCTION
 
FUNCTION t612_b(p_c)
 DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_cnt           LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    p_c             LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.num5,
    l_allow_delete  LIKE type_file.num5
 DEFINE l_lph09     LIKE lph_file.lph09  #No.FUN-9C0101
 DEFINE l_lph10     LIKE lph_file.lph10  #No.FUN-9C0101
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_lru.lru01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_lru.* FROM lru_file
     WHERE lru01=g_lru.lru01
    IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_lru.lru06='Y' THEN 
       CALL cl_err(g_lru.lru06,'9003',0)
       RETURN
    END IF
    
    IF g_lru.lruplant <> g_plant THEN
       CALL cl_err('','alm-399',0)
       RETURN         
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT lrv02,lrv03,lrv04",
                       "  FROM lrv_file",
                       " WHERE lrv01='",g_lru.lru01,"' ",
                       "   AND lrv02=?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t612_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_lrv WITHOUT DEFAULTS FROM s_lrv.*
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
 
           OPEN t612_cl USING g_lru.lru01
           IF STATUS THEN
              CALL cl_err("OPEN t612_cl:", STATUS, 1)
              CLOSE t612_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH t612_cl INTO g_lru.* 
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0) 
              CLOSE t612_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_lrv_t.* = g_lrv[l_ac].*  #BACKUP
              LET g_lrv_o.* = g_lrv[l_ac].*  #BACKUP
              OPEN t612_bcl USING g_lrv_t.lrv02
              IF STATUS THEN
                 CALL cl_err("OPEN t612_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t612_bcl INTO g_lrv[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_lrv_t.lrv02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_set_comp_required("lrv02",TRUE)
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_lrv[l_ac].* TO NULL
           LET g_lrv_t.* = g_lrv[l_ac].* 
           LET g_lrv_o.* = g_lrv[l_ac].* 
           CALL cl_set_comp_required("lrv02",TRUE)
           CALL cl_show_fld_cont()
           NEXT FIELD lrv02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO lrv_file(lrvplant,lrvlegal,lrv00,lrv01,lrv02,lrv03,lrv04)
           VALUES(g_lru.lruplant,g_lru.lrulegal,g_lru.lru00,g_lru.lru01,g_lrv[l_ac].lrv02,
                  g_lrv[l_ac].lrv03,g_lrv[l_ac].lrv04)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","lrv_file",g_lru.lru01,g_lrv[l_ac].lrv02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
       
        AFTER FIELD lrv02 
           IF NOT cl_null(g_lrv[l_ac].lrv02) THEN
              IF g_lrv[l_ac].lrv02 != g_lrv_t.lrv02
                 OR g_lrv_t.lrv02 IS NULL OR p_c = 'c' THEN
                 CALL t612_lrv02(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_lrv[l_ac].lrv02,g_errno,1)
                    LET g_lrv[l_ac].lrv02 = g_lrv_t.lrv02
                    NEXT FIELD lrv02
                 END IF
                 SELECT count(*) INTO l_n FROM lrv_file
                  WHERE lrv01 = g_lru.lru01
                    AND lrv02 = g_lrv[l_ac].lrv02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lrv[l_ac].lrv02 = g_lrv_t.lrv02
                    NEXT FIELD lrv02
                 END IF
              END IF
           END IF
           
       #No.FUN-9C0101 BEGIN -----
        AFTER FIELD lrv04 
           SELECT lph09,lph10 INTO l_lph09,l_lph10
             FROM lph_file,lpj_file
            WHERE lph01 = lpj02
              AND lpj03 = g_lrv[l_ac].lrv02
           IF cl_null(g_lrv[l_ac].lrv04) THEN
              IF NOT cl_null(l_lph10) THEN
                 CALL cl_err('','alm-822',0)
                 NEXT FIELD lrv04
              END IF
           ELSE
              IF g_lrv[l_ac].lrv04 < g_today THEN
                 CALL cl_err('','alm-823',0)
                 NEXT FIELD lrv04
              END IF
             #IF l_lph09 = '0' AND NOT cl_null(l_lph10) THEN  #FUN-C30042 mark
              IF l_lph09 = '1' AND NOT cl_null(l_lph10) THEN  #FUN-C30042 add   #指定日期 
                 IF g_lrv[l_ac].lrv04 > l_lph10 THEN
                    CALL cl_err('','alm-824',0)
                    NEXT FIELD lrv04
                 END IF
              END IF
           END IF
          #No.FUN-9C0101 END -------
           
        BEFORE DELETE 
           DISPLAY "BEFORE DELETE"
           IF g_lrv_t.lrv02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM lrv_file
               WHERE lrv01 = g_lru.lru01
                 AND lrv02 = g_lrv_t.lrv02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","lrv_file",g_lru.lru01,g_lrv_t.lrv02,SQLCA.sqlcode,"","",1)
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
              LET g_lrv[l_ac].* = g_lrv_t.*
              CLOSE t612_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lrv[l_ac].lrv02,-263,1)
              LET g_lrv[l_ac].* = g_lrv_t.*
           ELSE
              UPDATE lrv_file SET lrv02=g_lrv[l_ac].lrv02,
                                  lrv03=g_lrv[l_ac].lrv03,
                                  lrv04=g_lrv[l_ac].lrv04
               WHERE lrv01=g_lru.lru01
                 AND lrv02=g_lrv_t.lrv02
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","lrv_file",g_lru.lru01,g_lrv_t.lrv02,SQLCA.sqlcode,"","",1)
                 LET g_lrv[l_ac].* = g_lrv_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30033 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_lrv[l_ac].* = g_lrv_t.*
              #FUN-D30033--add--str--
              ELSE
                 CALL g_lrv.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end--
              END IF
              CLOSE t612_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30033 Add
           CLOSE t612_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO
           IF INFIELD(lrv02) AND l_ac > 1 THEN
              LET g_lrv[l_ac].* = g_lrv[l_ac-1].*
              #LET g_lrv[l_ac].lrv02 = g_rec_b + 1   #MOD-A30213
              NEXT FIELD lrv02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lrv02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lpj1"
                 LET g_qryparam.arg1='2'
                 LET g_qryparam.default1 = g_lrv[l_ac].lrv02
                #No.FUN-9C0101 BEGIN -----
                 IF NOT cl_null(g_lru.lru02) AND NOT cl_null(g_lru.lru03) THEN
                    LET g_qryparam.where = " lpj01 = '",g_lru.lru02,"' AND lpj02 = '",g_lru.lru03,"'"
                 ELSE
                    IF NOT cl_null(g_lru.lru02) AND cl_null(g_lru.lru03) THEN
                       LET g_qryparam.where = " lpj01 = '",g_lru.lru02,"'"
                    END IF
                    IF cl_null(g_lru.lru02) AND NOT cl_null(g_lru.lru03) THEN
                       LET g_qryparam.where = " lpj02 = '",g_lru.lru03,"'"
                    END IF
                 END IF
                #No.FUN-9C0101 END -------
                 CALL cl_create_qry() RETURNING g_lrv[l_ac].lrv02
                 DISPLAY BY NAME g_lrv[l_ac].lrv02
                 NEXT FIELD lrv02
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controls 
         CALL cl_set_head_visible("","AUTO")
    END INPUT
    IF p_c="u" THEN
       LET g_lru.lrumodu = g_user
       LET g_lru.lrudate = g_today
       UPDATE lru_file SET lrumodu = g_lru.lrumodu,lrudate = g_lru.lrudate
        WHERE lru01 = g_lru.lru01
       DISPLAY BY NAME g_lru.lrumodu,g_lru.lrudate
    END IF
 
    CLOSE t612_bcl
    COMMIT WORK
    
    CALL t612_delHeader()     #CHI-C30002 add
   #No.FUN-A10104 -BEGIN-----
   #SELECT COUNT(*) INTO g_cnt FROM lrv_file
   # WHERE lrv01 = g_lru.lru01
   #IF g_cnt = 0 THEN
   #   CALL cl_getmsg('9044',g_lang) RETURNING g_msg
   #   ERROR g_msg CLIPPED
   #   DELETE FROM lru_file WHERE lru01 = g_lru.lru01
   #END IF
   #No.FUN-A10104 -END-------
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t612_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_lru.lru01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM lru_file ",
                  "  WHERE lru01 LIKE '",l_slip,"%' ",
                  "    AND lru01 > '",g_lru.lru01,"'"
      PREPARE t612_pb1 FROM l_sql 
      EXECUTE t612_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         CALL t612_v()
         IF g_lru.lru06='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_lru.lru06,'','','',g_void,g_lru.lruacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM lru_file WHERE lru01 = g_lru.lru01
         INITIALIZE g_lru.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t612_b_fill(p_wc2)
   DEFINE p_wc2   STRING
 
   LET g_sql = "SELECT lrv02,lrv03,lrv04 FROM lrv_file",
               " WHERE lrv01 ='",g_lru.lru01,"' "   #单头
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY lrv02 "
 
   PREPARE t612_pb FROM g_sql
   DECLARE lrv_cs CURSOR FOR t612_pb
 
   CALL g_lrv.clear()
   LET g_cnt = 1
 
   FOREACH lrv_cs INTO g_lrv[g_cnt].*   #单身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_lrv.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t612_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("lru01,lruplant",TRUE)
    END IF
END FUNCTION
 
FUNCTION t612_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("lru01,lruplant",FALSE)
    END IF
    CALL cl_set_comp_entry("lruplant",FALSE)
   #FUN-CA0096 mark START
   #IF g_lru00 = '3' THEN
   #   CALL cl_set_comp_required("lru02",TRUE)
   #ELSE
   #   CALL cl_set_comp_required("lru02",FALSE)
   #END IF
   #FUN-CA0096 mark END
    CALL cl_set_comp_required("lru02",FALSE)   #FUN-CA0096 add
END FUNCTION
 
FUNCTION t612_gen_body()
   DEFINE l_lph32        LIKE lph_file.lph32 
   DEFINE l_lph33        LIKE lph_file.lph33
   DEFINE l_lph34        LIKE lph_file.lph34
   DEFINE l_lph35        LIKE lph_file.lph35
   DEFINE l_begin_no     LIKE type_file.num20
   DEFINE l_end_no       LIKE type_file.num20
   DEFINE l_date         LIKE type_file.dat
   DEFINE l_i            LIKE type_file.num10
   DEFINE l_j            LIKE type_file.num20
   DEFINE l_k            LIKE type_file.num20
   DEFINE l_format       LIKE type_file.chr20
   DEFINE l_lrv          RECORD LIKE lrv_file.*
   DEFINE l_lrz02        LIKE lrz_file.lrz02
   DEFINE l_lpj17        LIKE lpj_file.lpj17
   DEFINE l_cnt          LIKE type_file.num10
 
   IF g_lru.lru01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lru.* FROM lru_file
    WHERE lru01=g_lru.lru01
 
   #不可跨门店改动资料
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
   IF g_lru.lruacti ='N' THEN    #检查资料是否为无效
      CALL cl_err(g_lru.lru01,'mfg1000',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lru.lru06 = 'Y' THEN
      CALL cl_err(g_lru.lru01,'mfg1005',0)
      RETURN
   END IF
   IF cl_null(g_lru.lru03) THEN
      CALL cl_err('','alm-536',0)   #MOD-A30212
      RETURN
   END IF
 
   SELECT lph32,lph33,lph34,lph35 INTO l_lph32,l_lph33,l_lph34,l_lph35
     FROM lph_file
    WHERE lph01 = g_lru.lru03
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','lph_file',g_lru.lru03,'',SQLCA.sqlcode,'','',0)
      RETURN
   END IF
   LET l_format = ''
   FOR l_i = 1 TO l_lph35 - 1
       LET l_format = l_format CLIPPED,'&'
   END FOR
   IF l_lph35 > 0 THEN
      LET l_format = l_format CLIPPED,"<"
   END IF
   
   OPEN WINDOW t612_1w WITH FORM "alm/42f/almt612_1"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almt612_1")
 
   IF g_lru00 = '4' THEN
      CALL cl_set_comp_visible("validity",TRUE)
   ELSE
      CALL cl_set_comp_visible("validity",FALSE)
   END IF
   DISPLAY l_lph32 TO FORMONLY.lph32
   DISPLAY l_lph33 TO FORMONLY.lph33
   DISPLAY l_lph34 TO FORMONLY.lph34
   DISPLAY l_lph35 TO FORMONLY.lph35
   LET l_date = ''
   DISPLAY l_date TO FORMONLY.date

   INPUT l_begin_no,l_end_no,l_date WITHOUT DEFAULTS 
         FROM FORMONLY.beg_no,FORMONLY.end_no,FORMONLY.validity
         
      AFTER FIELD beg_no
         IF NOT cl_null(l_begin_no) THEN
            IF l_begin_no < 0 THEN
               NEXT FIELD beg_no
            END IF
            IF LENGTH(l_begin_no) > l_lph35 THEN
               CALL cl_err(l_begin_no,'alm-460',0)    #所key数字长度超过流水码位数长度,请重新录入
               LET l_begin_no = NULL
               DISPLAY l_begin_no TO FORMONLY.beg_no
               NEXT FIELD beg_no
            END IF
            IF NOT cl_null(l_end_no) THEN
               IF l_begin_no > l_end_no THEN
                  CALL cl_err(l_begin_no,'alm-461',0) #起始号不可大于终止号
                  LET l_begin_no = NULL
                  DISPLAY l_begin_no TO FORMONLY.beg_no
                  NEXT FIELD beg_no
               END IF
            END IF
      #     LET l_begin_no = l_begin_no USING l_format
         END IF
 
 
      AFTER FIELD end_no
         IF NOT cl_null(l_end_no) THEN
            IF l_end_no < 0 THEN
               NEXT FIELD end_no
            END IF
            IF LENGTH(l_end_no) > l_lph35 THEN
               CALL cl_err(l_end_no,'alm-460',0)    #所key数字长度超过流水码位数长度,请重新录入
               LET l_end_no = NULL
               DISPLAY l_end_no TO FORMONLY.end_no
               NEXT FIELD end_no
            END IF
            IF NOT cl_null(l_begin_no) THEN
               IF l_end_no < l_begin_no THEN
                  CALL cl_err(l_end_no,'alm-461',0) #起始号不可大于终止号
                  LET l_end_no = NULL
                  DISPLAY l_end_no TO FORMONLY.end_no
                  NEXT FIELD end_no
               END IF
            END IF
      #     LET l_end_no = l_end_no USING l_format
         END IF
 
      AFTER FIELD validity
         IF NOT cl_null(l_date) THEN
            IF l_date < g_today THEN
               CALL cl_err(l_date,'alm-531',0)
               LET l_date = ''
               DISPLAY l_date TO FORMONLY.validity
               NEXT FIELD validity
            END IF
         END IF
 
   END INPUT
 
   CLOSE WINDOW t612_1w
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   INITIALIZE l_lrv.* TO NULL
   LET l_lrv.lrv01 = g_lru.lru01
   LET l_lrv.lrv00 = g_lru.lru00
   LET l_lrv.lrvplant = g_lru.lruplant
   LET l_lrv.lrvlegal = g_lru.lrulegal
  
   LET g_success = 'Y'
   DROP TABLE t612_tmp1;
   DROP TABLE t612_tmp2;
   DROP TABLE t612_tmp3;
   DROP TABLE t612_tmp4;
   DROP TABLE t612_tmp5;
   DROP TABLE t612_tmp6;
   DROP TABLE t612_tmp9;
   CREATE TEMP TABLE t612_tmp6(
      lpj03 LIKE lpj_file.lpj03);
   DROP TABLE t612_tmp7;
   BEGIN WORK
   CALL s_showmsg_init()
   
   #t612_gen_body_old,当产生的卡号比较少时用，量大时用另外一个FUNCTION
  #IF l_end_no - l_begin_no <= 50 THEN
  #   CALL t612_gen_body_old(l_begin_no,l_end_no,l_lph34,l_format,l_lrv.*)
  #ELSE
      CALL t612_void(l_lph34,l_lph35,l_begin_no,l_end_no,l_date)
  #END IF
 
   DISPLAY 'finish time:',TIME
   CALL ui.Interface.refresh()
   CALL s_showmsg()
      
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL t612_b_fill("1=1")
   CALL t612_bp_refresh()
END FUNCTION
 
FUNCTION t612_delete_body()
   
   IF g_lru.lru01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #不可跨门店改动资料
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
 
   SELECT * INTO g_lru.* FROM lru_file
    WHERE lru01=g_lru.lru01
 
   IF g_lru.lruacti ='N' THEN    #检查资料是否为无效
      CALL cl_err(g_lru.lru01,'mfg1000',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lru.lru06 = 'Y' THEN
      CALL cl_err(g_lru.lru01,'mfg1005',0)
      RETURN
   END IF
   IF l_ac <= 0 THEN
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   IF NOT cl_null(g_lrv[l_ac].lrv02) THEN
      DELETE FROM lrv_file WHERE lrv01 = g_lru.lru01 
                             AND lrv02 = g_lrv[l_ac].lrv02
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3('del','lrv_file',g_lru.lru01,g_lrv[l_ac].lrv02,SQLCA.sqlcode,'','',1)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL t612_b_fill("1=1")
   CALL t612_bp_refresh()
END FUNCTION
 
FUNCTION t612_y()
   DEFINE l_lrv    RECORD LIKE lrv_file.*
   DEFINE l_lpj    RECORD LIKE lpj_file.*
 
   IF g_lru.lru01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
#CHI-C30107 ------------------ add ----------------- begin
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
   IF g_lru.lruacti ='N' THEN    #检查资料是否为无效
      CALL cl_err(g_lru.lru01,'mfg1000',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lru.lru06 = 'Y' THEN
      CALL cl_err(g_lru.lru01,'mfg1005',0)
      RETURN
   END IF
   IF NOT cl_confirm('aap-017') THEN RETURN END IF
   IF g_rec_b <= 0 THEN
      CALL cl_err(g_lru.lru01,'atm-228',0)
      RETURN
   END IF
#CHI-C30107 ------------------ add ----------------- end
   SELECT * INTO g_lru.* FROM lru_file
    WHERE lru01=g_lru.lru01
 
   #不可跨门店改动资料
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
   IF g_lru.lruacti ='N' THEN    #检查资料是否为无效
      CALL cl_err(g_lru.lru01,'mfg1000',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lru.lru06 = 'Y' THEN
      CALL cl_err(g_lru.lru01,'mfg1005',0)
      RETURN
   END IF
   IF g_rec_b <= 0 THEN
      CALL cl_err(g_lru.lru01,'atm-228',0)
      RETURN
   END IF
 
#  IF NOT cl_confirm('aap-017') THEN RETURN END IF  #CHI-C30107 mark
 
   BEGIN WORK
   OPEN t612_cl USING g_lru.lru01
   IF STATUS THEN
      CALL cl_err("OPEN t612_cl:", STATUS, 1)
      CLOSE t612_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t612_cl INTO g_lru.*               # 锁住将被更改或取消的资料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0)          #资料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   CALL s_showmsg_init()
   CALL t612_y_chk()
 
   UPDATE lru_file SET lru06 = 'Y',lru07 = g_user,lru08 = g_today
    WHERE lru01=g_lru.lru01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('lru01',g_lru.lru01,'update lru_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   DISPLAY "Finish:",TIME
 
   CALL s_showmsg()
      
   CLOSE t612_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      SELECT lru06,lru07,lru08 INTO g_lru.lru06,g_lru.lru07,g_lru.lru08
        FROM lru_file
       WHERE lru01=g_lru.lru01
      DISPLAY BY NAME g_lru.lru06,g_lru.lru07,g_lru.lru08
   ELSE
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic(g_lru.lru06,'','','','',g_lru.lruacti)
 
END FUNCTION
 
FUNCTION t612_z()
   DEFINE l_lrv         RECORD LIKE lrv_file.*
   DEFINE l_lpj17       LIKE lpj_file.lpj17
   DEFINE l_cnt         LIKE type_file.num20
 
   IF g_lru.lru01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lru.* FROM lru_file
    WHERE lru01=g_lru.lru01
 
   #不可跨门店改动资料
   IF g_lru.lruplant <> g_plant THEN
      CALL cl_err(g_lru.lruplant,'alm-399',0)
      RETURN
   END IF
   IF g_lru.lru06 = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lru.lru06 = 'N' THEN  #未审核
      CALL cl_err(g_lru.lru01,'9025',0)
      RETURN
   END IF
 
   #续期注销不可取消审核
  #IF g_lru.lru00 =  '2' OR g_lru.lru00 = '4' THEN #FUN-C30177 mark
   IF g_lru.lru00 = '4' THEN                       #FUN-C30177 add
      CALL cl_err(g_lru.lru01,'alm-436',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('aim-302') THEN RETURN END IF
 
   BEGIN WORK
   OPEN t612_cl USING g_lru.lru01
   IF STATUS THEN
      CALL cl_err("OPEN t612_cl:", STATUS, 1)
      CLOSE t612_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t612_cl INTO g_lru.*               # 锁住将被更改或取消的资料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0)          #资料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
   CALL s_showmsg_init()
   CALL t612_z_chk()
   IF g_success = 'Y' THEN   
   #  UPDATE lru_file SET lru06 = 'N',lru07 = '',lru08 = ''              #CHI-D20015 mark 
      UPDATE lru_file SET lru06 = 'N',lru07 = g_user,lru08 = g_today     #CHI-D20015
       WHERE lru01=g_lru.lru01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lru01',g_lru.lru01,'update lru_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   CALL s_showmsg()
      
   CLOSE t612_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
#     SELECT lru06,lru06,lru08 INTO g_lru.lru06,g_lru.lru07,g_lru.lru08            #TQC-B20097
      SELECT lru06,lru07,lru08 INTO g_lru.lru06,g_lru.lru07,g_lru.lru08            #TQC-B20097
        FROM lru_file
       WHERE lru01=g_lru.lru01
      DISPLAY BY NAME g_lru.lru06,g_lru.lru07,g_lru.lru08
   ELSE
      ROLLBACK WORK
   END IF
   DISPLAY "Undo Confirm End Time:",TIME
   CALL cl_set_field_pic(g_lru.lru06,'','','','',g_lru.lruacti)
END FUNCTION
 
#产生卡号插入t612_tmp1
FUNCTION t612_gen_coupon_no(p_lph34,p_length,p_begin_no,p_end_no,p_step)
   DEFINE p_lph34        LIKE lph_file.lph34
   DEFINE p_length       LIKE type_file.num10
   DEFINE p_begin_no     LIKE type_file.num20
   DEFINE p_end_no       LIKE type_file.num20
   DEFINE p_step         LIKE type_file.num5
   DEFINE l_nums         LIKE type_file.num20
   DEFINE l_rows         LIKE type_file.num20
   DEFINE l_lrv021       LIKE lrv_file.lrv02
 
   LET l_nums = p_end_no - p_begin_no + 1
   IF cl_null(l_nums) THEN LET l_nums = 0 END IF
 
   DISPLAY 'Begin_time:',TIME
 
   ERROR 'Begin Step ',p_step USING "&<",'(产生卡号)'
   CALL ui.Interface.refresh()
   DISPLAY '产生卡号开始:',TIME
   LET g_sql = "SELECT ('",p_lph34 CLIPPED,"'||",
             # "  LPAD(to_char(id+",p_begin_no - 1,"),",p_length,",'0')) as lrv021",
              #No.FUN-A80008 -BEGIN-----
              #" substr(power(10,",p_length,"-length(to_char(id+",p_begin_no-1,"))) || to_char(id+",p_begin_no-1,"),2)) as lrv021",
               " substr(power(10,",p_length,"-length(id+",p_begin_no-1,")) || (id+",p_begin_no-1,"),2)) as lrv021",
              #No.FUN-A80008 -END-------
               "  FROM (SELECT level AS id FROM dual ",
               "         CONNECT BY level <=",l_nums,")",
               "  INTO TEMP t612_tmp1"
   PREPARE t612_reg_p1 FROM g_sql
   EXECUTE t612_reg_p1
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp1',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY '产生卡号结束:',TIME,l_rows
   ERROR 'Finish Step ',p_step USING "&<",'(产生卡号):',l_rows,'rows'
   CALL ui.Interface.refresh()
   CREATE UNIQUE INDEX t612_tmp1_01 ON t612_tmp1(lrv021);
END FUNCTION
 
#将后台表lpj_file插入临时表t612_tmp2
FUNCTION t612_ins_lpj_tmp(p_step)
   DEFINE l_rows         LIKE type_file.num20
   DEFINE p_step         LIKE type_file.num5
 
   ERROR 'Begin Step ',p_step USING '&<','(检查表1)'
   CALL ui.Interface.refresh()
   DISPLAY "产生临时表lpj_file资料开始:",TIME
   LET g_sql = "SELECT UNIQUE lpj03,lpj05,lpj09,lpj01,lpj06 FROM lpj_file",
               " WHERE lpj03 IN (SELECT lrv021 from t612_tmp1)",
               "  INTO TEMP t612_tmp2 "
   PREPARE t612_reg_p2 FROM g_sql
   EXECUTE t612_reg_p2
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp2',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY '产生临时表lpj_file资料结束:',TIME,l_rows
   ERROR 'Finish Step ',p_step USING "&<",'(检查表1):',l_rows,'rows'
   CALL ui.Interface.refresh()
   CREATE UNIQUE INDEX t612_tmp2_01 ON t612_tmp2(lpj03);
END FUNCTION
 
#收集不是发卡状态的卡
FUNCTION t612_lpj_check1(p_table,p_step)
   DEFINE p_table        LIKE gat_file.gat01
   DEFINE p_step         LIKE type_file.num5
   DEFINE l_rows         LIKE type_file.num20
 
   #收集不是发卡状态的卡
   ERROR 'Begin Step ',p_step USING "&<",'(收集不是发卡状态的卡):'
   CALL ui.Interface.refresh()
   DISPLAY "收集不是发卡状态的卡开始:",TIME
   LET g_sql = "SELECT lpj03 FROM ",p_table,#t612_tmp2",
               " WHERE lpj09 <> '2' ",
               "  INTO TEMP t612_tmp4"
   PREPARE t612_reg_p4 FROM g_sql
   EXECUTE t612_reg_p4
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp2',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]                                                
   DISPLAY "收集不是发卡状态的卡结束:",TIME,l_rows
   ERROR 'Finish Step ',p_step USING "&<",'(收集不是发卡状态的卡):',l_rows,'rows'
   CALL ui.Interface.refresh()  
   CREATE UNIQUE INDEX t612_tmp4_01 ON t612_tmp4(lpj03);
 
END FUNCTION
 
#存在于未审核的资料中，则收集至t612_tmp5中
FUNCTION t612_lpj_check2(p_step,p_wc)
   DEFINE p_step         LIKE type_file.num5
   DEFINE p_wc           LIKE type_file.chr1000
   DEFINE l_rows         LIKE type_file.num20
 
   IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF
 
   ERROR 'Begin Step ',p_step USING "&<",'(收集存在于未审核的资料中):'
   CALL ui.Interface.refresh()
   DISPLAY "收集存在于未审核的资料中开始:",TIME
   LET g_sql = "SELECT lpj03 FROM t612_tmp2",
               " WHERE lpj03 IN (SELECT lrv02 FROM lrv_file,lru_file WHERE lru01 = lrv01 AND lru06 = 'N') ",
               "  INTO TEMP t612_tmp5"
   PREPARE t612_reg_p5 FROM g_sql
   EXECUTE t612_reg_p5
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp5',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]                                                
   DISPLAY "收集存在于未审核的资料中结束:",TIME,l_rows
   ERROR 'Finish Step ',p_step USING "&<",'(收集存在于未审核的资料中):',l_rows,'rows'
   CALL ui.Interface.refresh()  
   CREATE UNIQUE INDEX t612_tmp5_01 ON t612_tmp5(lpj03);
END FUNCTION
 
#非单头会员下的卡，则收集至t612_tmp6中
FUNCTION t612_lpj_check3(p_step,p_wc)
   DEFINE p_step         LIKE type_file.num5
   DEFINE p_wc           LIKE type_file.chr1000
   DEFINE l_rows         LIKE type_file.num20
 
   IF cl_null(p_wc) THEN LET p_wc = " 1=1" END IF
 
   ERROR 'Begin Step ',p_step USING "&<",'(非单头会员下的卡):'
   CALL ui.Interface.refresh()
   DISPLAY "收集非单头会员下的卡开始:",TIME
   LET g_sql = "SELECT lpj03 FROM t612_tmp2",
             # " WHERE lpj01 <> '",g_lru.lru02,"' ",                #No.FUN-9B0136
               " WHERE lpj01 <> '",g_lru.lru02,"' OR lpj01 IS NULL",#No.FUN-9B0136
               "  INTO TEMP t612_tmp6"
   PREPARE t612_reg_p6 FROM g_sql
   EXECUTE t612_reg_p6
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp6',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]                                                
   DISPLAY "非单头会员下的卡结束:",TIME,l_rows
   ERROR 'Finish Step ',p_step USING "&<",'(非单头会员下的卡):',l_rows,'rows'
   CALL ui.Interface.refresh()  
   CREATE UNIQUE INDEX t612_tmp6_01 ON t612_tmp6(lpj03);
END FUNCTION

#No.TQC-A10140 -BEGIN-----
FUNCTION t612_lpj_check4()
   LET g_sql = "SELECT lpj03 FROM t612_tmp2",
               " WHERE lpj06 > 0",
               "  INTO TEMP t612_tmp9"
   PREPARE t612_reg_p9 FROM g_sql
   EXECUTE t612_reg_p9
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp9',SQLCA.sqlcode,1)
      RETURN
   END IF
   CREATE UNIQUE INDEX t612_tmp9_01 ON t612_tmp9(lpj03);
END FUNCTION
#No.TQC-A10140 -END-------


#将满足条件的卡号插入单身表中
FUNCTION t612_ins_lrv_tmp(p_step)
   DEFINE p_step         LIKE type_file.num5
   DEFINE l_rows         LIKE type_file.num20
 
   ERROR 'Begin Step ',p_step USING '&<.1','(检查表2)'
   CALL ui.Interface.refresh()
   DISPLAY "产生临时表lrv_file资料开始:",TIME
   LET g_sql = "SELECT t612_tmp2.lpj03,t612_tmp2.lpj05 FROM t612_tmp2",
               " WHERE t612_tmp2.lpj03 NOT IN (SELECT t612_tmp4.lpj03 FROM t612_tmp4) ",
               "   AND t612_tmp2.lpj03 NOT IN (SELECT t612_tmp5.lpj03 FROM t612_tmp5) ",
               "   AND t612_tmp2.lpj03 NOT IN (SELECT t612_tmp6.lpj03 FROM t612_tmp6) "
   IF g_lru00 = '2' OR g_lru00 = '1' THEN
      LET g_sql = g_sql CLIPPED,
               "   AND t612_tmp2.lpj03 NOT IN (SELECT t612_tmp9.lpj03 FROM t612_tmp9) "
   END IF
   LET g_sql = g_sql CLIPPED,
               "  INTO TEMP t612_tmp7 "
   PREPARE t612_reg_p7 FROM g_sql
   EXECUTE t612_reg_p7
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp7',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY "产生临时表lrv_file资料结束:",TIME,l_rows
   ERROR 'Finish Step ',p_step USING "&<.1",'(检查表2):',l_rows,'rows'
END FUNCTION
 
#将OK的卡号插入正式表
FUNCTION t612_ins_lrv(p_table,p_step)
   DEFINE p_table     LIKE gat_file.gat01
   DEFINE p_step      LIKE type_file.num5
   DEFINE l_rows      LIKE type_file.num20
 
   ERROR 'Begin Step ',p_step USING '&<','(卡号插入正式表)'
   CALL ui.Interface.refresh()
   DISPLAY "插入正式表开始:",TIME
      LET g_sql = "INSERT INTO lrv_file(lrvplant,lrvlegal,lrv00,lrv01,lrv02,lrv03,lrv04)",
                  "SELECT '",g_lru.lruplant,"',",
                  "       '",g_lru.lrulegal,"',",
                  "       '",g_lru.lru00,"',",
                  "       '",g_lru.lru01,"',lpj03,lpj05,'' ",
                  "  FROM ",p_table
   PREPARE t612_reg_p8 FROM g_sql
   EXECUTE t612_reg_p8
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert lrv_file',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]
   DISPLAY "插入正式表结束:",TIME,l_rows
   ERROR 'Finish Step ',p_step USING '&<','(卡号插入正式表):',l_rows,'rows'
   CALL ui.Interface.refresh()
END FUNCTION
 
#错误讯息记录array
FUNCTION t612_error(p_table,p_step,p_errno)
   DEFINE p_table        LIKE gat_file.gat01
   DEFINE p_step         LIKE type_file.num5
   DEFINE p_errno        LIKE ze_file.ze01
   DEFINE l_lpj03        LIKE lpj_file.lpj03
   DEFINE l_i            LIKE type_file.num10
 
   ERROR 'Begin Step ',p_step USING '&<','(报错信息汇总',p_table CLIPPED,')'
   CALL ui.Interface.refresh()
   DISPLAY "报错",p_table CLIPPED,'开始:',TIME
   LET g_sql = "SELECT lpj03  FROM ",p_table
   DECLARE t612_tmp5_cs CURSOR FROM g_sql
   LET l_i = 1
   FOREACH t612_tmp5_cs INTO l_lpj03
      IF l_i > 10000 THEN
         EXIT FOREACH
      END IF
      CALL s_errmsg('lpj03',l_lpj03,'foreach t612_tmp5_cs',p_errno,1)
      LET l_i = l_i + 1
   END FOREACH
   DISPLAY "报错",p_table CLIPPED,'结束:',TIME
   ERROR 'Finish Step ',p_step USING '&<','(报错信息汇总',p_table CLIPPED,')'
   CALL ui.Interface.refresh()
 
END FUNCTION
 
FUNCTION t612_void(p_lph34,p_length,p_begin_no,p_end_no,p_date)
   DEFINE p_lph34        LIKE lph_file.lph34
   DEFINE p_length       LIKE type_file.num10
   DEFINE p_begin_no     LIKE type_file.num20
   DEFINE p_end_no       LIKE type_file.num20
   DEFINE p_date         LIKE type_file.dat
   DEFINE l_nums         LIKE type_file.num20
   DEFINE l_rows         LIKE type_file.num20
   DEFINE l_lrv021       LIKE lrv_file.lrv02
   DEFINE l_wc           LIKE type_file.chr1000
 
   #Step 1:产生卡号
   CALL t612_gen_coupon_no(p_lph34,p_length,p_begin_no,p_end_no,1)
   IF g_success = 'N' THEN RETURN END IF
 
   #Step 2.dbo.lpj_file资料丢入TEMP TABLE
   CALL t612_ins_lpj_tmp(2)
   IF g_success = 'N' THEN RETURN END IF
 
   #Step 3:不存在于lpj_file资料的卡，则收集至t612_tmp3中
   ERROR 'Begin Step 03(不存在于lpj_file资料的卡):'
   CALL ui.Interface.refresh()
   DISPLAY "产生去掉lpj_file资料的卡资料开始:",TIME
   LET g_sql = "SELECT lrv021 as lpj03 FROM t612_tmp1 ",
               " WHERE t612_tmp1.lrv021 NOT IN (SELECT t612_tmp2.lpj03 FROM t612_tmp2) ",
               "  INTO TEMP t612_tmp3"
   PREPARE t612_reg_p41 FROM g_sql
   EXECUTE t612_reg_p41
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL s_errmsg('','','insert temp t612_tmp3',SQLCA.sqlcode,1)
      RETURN
   END IF
   LET l_rows = SQLCA.sqlerrd[3]                                                
   DISPLAY "不存在于lpj_file资料的卡结束:",TIME,l_rows
   ERROR 'Finish Step 03','(不存在于lpj_file资料的卡):',l_rows,'rows'
   CALL ui.Interface.refresh()  
   CREATE UNIQUE INDEX t612_tmp3_01 ON t612_tmp3(lrv021);
 
   #Step 4:不是发卡状态，则收集至t612_tmp4中
   CALL t612_lpj_check1('t612_tmp2',4)
   IF g_success = 'N' THEN RETURN END IF
 
   #Step 5:存在于未审核的资料中，则收集至t612_tmp5中
   CALL t612_lpj_check2(5,l_wc)
   IF g_success = 'N' THEN RETURN END IF
 
   #Step 6:不是单头会员编号下的卡，则收集至t612_tmp6中
   IF NOT cl_null(g_lru.lru02) THEN
      CALL t612_lpj_check3(6,l_wc)
      IF g_success = 'N' THEN RETURN END IF
   END IF 

#No.TQC-A10140 -BEGIN-----
   IF g_lru00 = '2' OR g_lru00 = '1' THEN
      CALL t612_lpj_check4()
      IF g_success = 'N' THEN RETURN END IF
   END IF
#No.TQC-A10140 -END-------

   #Step 7:将满足条件的卡号插入t612_tmp7
   CALL t612_ins_lrv_tmp(7)
   IF g_success = 'N' THEN RETURN END IF

   CALL t612_error('t612_tmp3',8,'alm-218')   #不存在于lpj_file资料的卡
   CALL t612_error('t612_tmp4',9,'alm-688')  #不是发卡状态
   CALL t612_error('t612_tmp5',10,'alm-689')  #存在于未审核的资料中
   CALL t612_error('t612_tmp6',11,'alm-690')  #不是单头会员编号下的卡
#No.TQC-A10140 -BEGIN-----
   IF g_lru00 = '2' OR g_lru00 = '1' THEN
      CALL t612_error('t612_tmp9',11,'alm-728')  #卡内有余额
   END IF
#No.TQC-A10140 -END-------

   #Step 7:正确的卡号插入lrv_file中
   SELECT COUNT(*) INTO g_cnt FROM t612_tmp7
   IF g_cnt > 0 THEN
      CALL t612_ins_lrv('t612_tmp7',12)
      IF g_success = 'N' THEN RETURN END IF
      IF g_lru00 = '4' THEN
         UPDATE lrv_file set lrv04 = p_date
          WHERE lrv01 = g_lru.lru01
            AND lrv02 IN (SELECT lpj03 FROM t612_tmp7)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','UPD lrv_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t612_y_chk()
 DEFINE l_cnt LIKE type_file.num5
 
   DROP TABLE t612_tmp8;
   DROP TABLE t612_tmp4;
   DELETE FROM t612_tmp8
   LET g_sql = "SELECT lpj03,lpj09,lrv04 FROM lrv_file,lpj_file",
               " WHERE lrv02 = lpj03 AND lrv01 = '",g_lru.lru01,"' ",
               "  INTO TEMP t612_tmp8"
   PREPARE t612_reg_py FROM g_sql
   EXECUTE t612_reg_py
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','insert temp t612_tmp8',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
      
   #不是发卡状态，则收集至t612_tmp4中
   CALL t612_lpj_check1('t612_tmp8',2)
   IF g_success = 'N' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM t612_tmp4
   IF g_cnt > 0 THEN
      CALL t612_error('t612_tmp4',3,'alm-688')  #不是发卡状态
      LET g_success = 'N'
      RETURN
   ELSE
      CALL t612_y_new()
   END IF
END FUNCTION
 
FUNCTION t612_y_new()
   DEFINE l_lpj         RECORD LIKE lpj_file.*
   DEFINE l_cnt         LIKE type_file.num20
   DEFINE l_cnt1        LIKE type_file.num20
   DEFINE l_lrz02       LIKE lrz_file.lrz02
   DEFINE l_lpj03       LIKE lpj_file.lpj03
   DEFINE l_lrv04       LIKE lrv_file.lrv04
   DEFINE l_lpj12       LIKE lpj_file.lpj12 #FUN-CB0098 add
   DEFINE l_lsm04       LIKE lsm_file.lsm04 #FUN-CB0098 add
   DEFINE l_sql         STRING              #FUN-CB0098 add
 
   DISPLAY "Confirm Begin:",TIME

   CASE g_lru00
        WHEN '1' 
             LET g_sql = " UPDATE lpj_file SET lpj09 = ?,lpj10 = ?,",
                         "                     lpj20 = ?, ",
                         "                     lpjpos = '2' ",  #FUN-D30007 add
                         "  WHERE EXISTS (SELECT 'X' FROM t612_tmp8 ",
                         "                 WHERE t612_tmp8.lpj03 = lpj_file.lpj03) "
             PREPARE t612_ry5 FROM g_sql
             EXECUTE t612_ry5 USING '3',g_today,g_lru.lruplant
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lpj_file:",TIME,SQLCA.sqlerrd[3]
        WHEN '2' 
#FUN-CB0098---add---START
             LET l_sql = " SELECT lpj03,lpj12 FROM lrv_file left join lpj_file ON lrv02 = lpj03 ",
                         "   WHERE lrv01 = '",g_lru.lru01,"' "
             PREPARE t612_ry6_1 FROM l_sql
             DECLARE t612_ry6_1_cs1 CURSOR FOR t612_ry6_1 
             FOREACH t612_ry6_1_cs1 INTO l_lpj03,l_lpj12
               #INSER INTO 一筆異動記錄檔至lsm_file(almq618),異動別為3.積分清零 
               LET g_sql = " INSERT INTO lsm_file (lsm01,lsm02,lsm03,lsm04,lsm05,lsm06,lsm08,lsmstore,lsmlegal,lsm15)",
                           "   VALUES(?,'3','",g_lru.lru01,"',?,'",g_today,"','',0,'",g_plant,"','",g_legal,"','1')"
               PREPARE t612_ry6_2 FROM g_sql
               LET l_lsm04 = l_lpj12 * (-1)
               EXECUTE t612_ry6_2 USING l_lpj03,l_lsm04
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  CALL s_errmsg('','','ins lsm_file',SQLCA.sqlcode,1)
                  RETURN
               END IF
             END FOREACH 
#FUN-CB0098---add-----END
             LET g_sql = " UPDATE lpj_file SET lpj09 = ?,lpj21 = ?,",
                         "                     lpj22 = ?,lpj12 = 0, ",  #FUN-CB0098 add lpj12
                         "                     lpjpos = '2'  ",  #FUN-D30007 add
                         "  WHERE EXISTS (SELECT 'X' FROM t612_tmp8 ",
                         "                 WHERE t612_tmp8.lpj03 = lpj_file.lpj03) "
             PREPARE t612_ry6 FROM g_sql
             EXECUTE t612_ry6 USING '4',g_today,g_lru.lruplant
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lpj_file:",TIME,SQLCA.sqlerrd[3]
        WHEN '3' 
             LET g_sql = " UPDATE lpj_file SET lpj09 = ?,lpj23 = ?,",
                         "                     lpj24 = ? ,",
                         "                     lpjpos = '2' ",
                         "  WHERE EXISTS (SELECT 'X' FROM t612_tmp8 ",
                         "                 WHERE t612_tmp8.lpj03 = lpj_file.lpj03) "
             PREPARE t612_ry7 FROM g_sql
             EXECUTE t612_ry7 USING '5',g_today,g_lru.lruplant
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lpj_file:",TIME,SQLCA.sqlerrd[3]
        WHEN '4'
             DECLARE t615_cs CURSOR FOR
              SELECT lpj03,lrv04 FROM t612_tmp8

             FOREACH t615_cs INTO l_lpj03,l_lrv04

                UPDATE lpj_file SET lpj09 = '2',lpj05 = l_lrv04,
                                    lpjpos = '2'    #FUN-D30007 add 
                 WHERE lpj03 = l_lpj03
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
                   LET g_success = 'N'
                END IF
             END FOREACH
           # LET g_sql = " UPDATE lpj_file SET lpj09 = ?,lpj05 = ? ",
           #             "  WHERE EXISTS (SELECT 'X' FROM t612_tmp8 ",
           #             "                 WHERE t612_tmp8.lpj03 = lpj_file.lpj03) "
           # PREPARE t612_ry9 FROM g_sql
           # EXECUTE t612_ry9 USING '2' 
           # IF SQLCA.sqlcode THEN
           #    CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
           #    LET g_success = 'N'
           # END IF
             DISPLAY "Update lpj_file:",TIME,SQLCA.sqlerrd[3]
   END CASE
END FUNCTION

FUNCTION t612_z_chk()
   DEFINE l_lrv01       LIKE lrv_file.lrv01 #FUN-C30177 add
   DEFINE l_lrv02       LIKE lrv_file.lrv02 #FUN-C30177 add
   DELETE FROM t612_tmp2
   LET g_sql = "SELECT lpj03,lpj05,lpj09,lpj01,lpj06 FROM lrv_file,lpj_file",
               " WHERE lrv02 = lpj03 AND lrv01 = '",g_lru.lru01,"' ",
               "  INTO TEMP t612_tmp2"
   PREPARE t612_reg_py1 FROM g_sql
   EXECUTE t612_reg_py1
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','insert temp t612_tmp2',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CASE g_lru00
        WHEN '1' 
             LET g_sql = " UPDATE lpj_file a SET lpj09 = ?,lpj10 = ?,",
                         "                       lpj20 = ? ,",
                         "                       lpjpos = '2'  ",   #FUN-D30007 add
                         "  WHERE EXISTS (SELECT 'X' FROM t612_tmp2 ",
                         "                 WHERE t612_tmp2.lpj03 = a.lpj03) "
             PREPARE t612_rz1 FROM g_sql
             EXECUTE t612_rz1 USING '2','',''
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DECLARE t612__1_cs1 CURSOR FOR t612_ry6_1
#FUN-C30177---add---START 
        WHEN '2'
             LET g_sql = " UPDATE lpj_file a SET lpj09 = ?,lpj21 = ?,",
                         "                       lpj22 = ? ,",
                         "                       lpjpos = '2'  ",
                         "  WHERE EXISTS (SELECT 'X' FROM t612_tmp2 ",
                         "                 WHERE t612_tmp2.lpj03 = a.lpj03) "
             PREPARE t612_rz3 FROM g_sql
             EXECUTE t612_rz3 USING '2','',''
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lpj_file:",TIME,SQLCA.sqlerrd[3]
             #一併刪除lsm_file紀錄 
             LET g_sql = " SELECT lrv01,lrv02 FROM lrv_file ",             
                         "   WHERE lrv01 = '",g_lru.lru01,"' "  
             PREPARE t612_rz3_1 FROM g_sql
             DECLARE t612_rz3_1_cs1 CURSOR FOR t612_rz3_1
             FOREACH t612_rz3_1_cs1 INTO l_lrv01,l_lrv02
               DELETE FROM lsm_file WHERE lsm01 = l_lrv02
                                      AND lsm03 = l_lrv01
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3('del','lsm_file',g_lru.lru01,l_lrv02,SQLCA.sqlcode,'','',1)
                  LET g_success = 'N'
               END IF               
             END FOREACH
#FUN-C30177---add-----END
        WHEN '3' LET g_sql = " UPDATE lpj_file a SET lpj09 = ?,lpj23 = ?,",
                         "                     lpj24 = ?, ",
                         "                     lpjpos = '2'   ",   #FUN-D30007 add
                         "  WHERE EXISTS (SELECT 'X' FROM t612_tmp2 ",
                         "                 WHERE t612_tmp2.lpj03 = a.lpj03) "
             PREPARE t612_rz2 FROM g_sql
             EXECUTE t612_rz2 USING '2','',''
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','update lpj_file',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             DISPLAY "Update lpj_file:",TIME,SQLCA.sqlerrd[3]
   END CASE
END FUNCTION

#原来单身产生的FUNCTION（TEST OK，但是由于PERFORMANCE原因，而不用了）
FUNCTION t612_gen_body_old(p_begin_no,p_end_no,p_lph34,p_format,p_lrv,p_date)
   DEFINE p_begin_no     LIKE type_file.num20
   DEFINE p_end_no       LIKE type_file.num20
   DEFINE p_lph34        LIKE lph_file.lph34 
   DEFINE p_format       LIKE type_file.chr20
   DEFINE p_lrv          RECORD LIKE lrv_file.*
   DEFINE p_date         LIKE type_file.dat
   DEFINE l_i            LIKE type_file.num10
   DEFINE l_j            LIKE type_file.num20
   DEFINE l_k            LIKE type_file.num20
   DEFINE l_cnt          LIKE type_file.num10
   DEFINE l_lpj01        LIKE lpj_file.lpj01
   DEFINE l_lpj09        LIKE lpj_file.lpj09
   DEFINE l_lpj05        LIKE lpj_file.lpj05
 
   LET l_j = p_begin_no - 1
   LET l_k = 0
   WHILE TRUE
       LET g_success = 'Y'    #Carrier 前面即使有部分资料出现错误，其他资料也要插入
       LET l_j = l_j + 1
       IF l_j > p_end_no THEN EXIT WHILE END IF
       LET p_lrv.lrv02 = p_lph34 CLIPPED,l_j USING p_format    
       #若为0开始时,由于p_format中最后一位为<,导致会少一位
       IF l_j = 0 THEN
          LET p_lrv.lrv02 = p_lrv.lrv02 CLIPPED,'0'
       END IF
 
       #CKP#1
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM lpj_file WHERE lpj03 = p_lrv.lrv02
       IF l_cnt < 1 THEN   #无此卡号,不可作废,注销,挂失,续期
          LET g_success = 'N'
          CALL s_errmsg('lrv02',p_lrv.lrv02,'sel lpj','alm-218',1)
          CONTINUE WHILE
       END IF
       #CKP#2
       SELECT lpj05,lpj09 INTO l_lpj05,l_lpj09 FROM lpj_file WHERE lpj03 = p_lrv.lrv02
       IF l_lpj09 <> '2' THEN #只有'2-发卡'状态的卡才可以作废,注销,挂失,续期
          LET g_success = 'N'
          CALL s_errmsg('lrv02',p_lrv.lrv02,'sel lpj','alm-688',1)
          CONTINUE WHILE
       END IF
       #CKP#3
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM lru_file,lrv_file
       WHERE lru01 = lrv01
         AND lrv02 = p_lrv.lrv02
         AND lruacti = 'Y' 
         AND lru06 = 'N'             #未审核
       IF l_cnt > 0 THEN #检查lru_fie中1.发售 2.退回 3.作废 未确认资料中是否存在此卡信息
          LET g_success = 'N'
          CALL s_errmsg('lrv02',p_lrv.lrv02,'sel lrv','alm-689',1)
          CONTINUE WHILE
       END IF
       IF NOT cl_null(g_lru.lru02) THEN
          SELECT lpj01 INTO l_lpj01 FROM lpj_file
           WHERE lpj03 = p_lrv.lrv02
          IF l_lpj01 <> g_lru.lru02 THEN
             LET g_success = 'N'
             CALL s_errmsg('lrv02',p_lrv.lrv02,'sel lrv','alm-690',1)
             CONTINUE WHILE
          END IF
       END IF
       IF g_lru00 = '1' OR g_lru00 = '2' OR g_lru00 = '3' THEN #卡作废,注销,挂失
          #判断有效期
       END IF
       LET p_lrv.lrv03 = l_lpj05
       LET p_lrv.lrv04 = p_date
       IF g_success = 'Y' THEN
          INSERT INTO lrv_file VALUES(p_lrv.*)
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
             LET g_success = 'N'
             CALL s_errmsg('lrv02',p_lrv.lrv02,'insert lrv',SQLCA.sqlcode,1)
          END IF
       END IF
 
       #carrier
       LET l_k = l_k + 1
       #IF l_k > g_max_rec THEN
       #   CALL s_errmsg('','','while',9035,0)
       #   EXIT WHILE
       #END IF
       IF l_j MOD 100 = 0 THEN
          MESSAGE l_j
          CALL ui.Interface.refresh()
       END IF
   END WHILE
END FUNCTION
#No.FUN-960134
#FUN-C90070-------add------str
FUNCTION t612_out()
DEFINE l_sql    LIKE type_file.chr1000, 
       l_rtz13  LIKE rtz_file.rtz13,
       l_lph02  LIKE lph_file.lph02,
       l_azf03  LIKE azf_file.azf03,
       sr       RECORD
                lruplant  LIKE lru_file.lruplant,
                lru00     LIKE lru_file.lru00,
                lru01     LIKE lru_file.lru01, 
                lru02     LIKE lru_file.lru02,
                lru03     LIKE lru_file.lru03,
                lru04     LIKE lru_file.lru04,
                lru05     LIKE lru_file.lru05,
                lru06     LIKE lru_file.lru06,
                lru07     LIKE lru_file.lru07,
                lru08     LIKE lru_file.lru08,
                lru09     LIKE lru_file.lru09,
                lrv02     LIKE lrv_file.lrv02,
                lrv03     LIKE lrv_file.lrv03
                END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lruuser', 'lrugrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lru01 = '",g_lru.lru01,"'" END IF
     IF cl_null(g_wc2) THEN LET g_wc2 = " lrv01 = '",g_lru.lru01,"'" END IF
     IF g_argv1 = '1' THEN
        LET l_sql = "SELECT lruplant,lru00,lru01,lru02,lru03,lru04,lru05,lru06,",
                    "       lru07,lru08,lru09,lrv02,lrv03",
                    "  FROM lru_file,lrv_file",
                    " WHERE lru01 = lrv01",
                    "   AND lru00 = '1'",
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED
     END IF
     IF g_argv1 = '2' THEN
        LET l_sql = "SELECT lruplant,lru00,lru01,lru02,lru03,lru04,lru05,lru06,",
                    "       lru07,lru08,lru09,lrv02,lrv03",
                    "  FROM lru_file,lrv_file",
                    " WHERE lru01 = lrv01",
                    "   AND lru00 = '2'",
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED
     END IF
     IF g_argv1 = '3' THEN
        LET l_sql = "SELECT lruplant,lru00,lru01,lru02,lru03,lru04,lru05,lru06,",
                    "       lru07,lru08,lru09,lrv02,lrv03",
                    "  FROM lru_file,lrv_file",
                    " WHERE lru01 = lrv01",
                    "   AND lru00 = '3'",
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED
     END IF
     IF g_argv1 = '4' THEN
        LET l_sql = "SELECT lruplant,lru00,lru01,lru02,lru03,lru04,lru05,lru06,",
                    "       lru07,lru08,lru09,lrv02,lrv03",
                    "  FROM lru_file,lrv_file",
                    " WHERE lru01 = lrv01",
                    "   AND lru00 = '4'",
                    "   AND ",g_wc CLIPPED,
                    "   AND ",g_wc2 CLIPPED
     END IF

     PREPARE t612_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t612_cs1 CURSOR FOR t612_prepare1

     DISPLAY l_table
     FOREACH t612_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
  
       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01=sr.lruplant
       LET l_lph02 = ' '
       SELECT lph02 INTO l_lph02 FROM lph_file WHERE lph01=sr.lru03
       LET l_azf03 = ' '
       SELECT azf03 INTO l_azf03 FROM azf_file WHERE azf01=sr.lru04 AND azf02='2' AND azf09='G'
       EXECUTE insert_prep USING sr.*,l_rtz13,l_lph02,l_azf03
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lruplant,lru00,lru01,lru02,lru03,lru04,lru05,lru06,lru07,lru08,lru09')
          RETURNING g_wc1
     CALL cl_wcchp(g_wc2,'lrv01,lrv02,lrv03')
          RETURNING g_wc3
     IF g_wc = " 1=1" THEN
        LET g_wc1='' 
     END IF
     IF g_wc2 = " 1=1" THEN
        LET g_wc3='' 
     END IF            
     IF g_wc <> " 1=1" AND g_wc2 <> " 1=1" THEN
        LET g_wc4 = g_wc1," AND ",g_wc3
     ELSE      
        IF g_wc = " 1=1" AND g_wc2 = " 1=1" THEN
           LET g_wc4 = "1=1"
        ELSE
           LET g_wc4 = g_wc1,g_wc3
        END IF 
     END IF
     CALL t612_grdata()
END FUNCTION

FUNCTION t612_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       IF g_argv1 = '1' THEN LET handler = cl_gre_outnam("almt612") END IF
       IF g_argv1 = '2' THEN LET handler = cl_gre_outnam("almt613") END IF
       IF g_argv1 = '3' THEN LET handler = cl_gre_outnam("almt614") END IF
       IF g_argv1 = '4' THEN LET handler = cl_gre_outnam("almt615") END IF
       IF handler IS NOT NULL THEN
           START REPORT t612_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lru01,lrv02"
           DECLARE t612_datacur1 CURSOR FROM l_sql
           FOREACH t612_datacur1 INTO sr1.*
               OUTPUT TO REPORT t612_rep(sr1.*)
           END FOREACH
           FINISH REPORT t612_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t612_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_lru00  STRING
    DEFINE l_lru06  STRING

    
    ORDER EXTERNAL BY sr1.lru01,sr1.lrv02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1,g_wc3,g_wc4
              
        BEFORE GROUP OF sr1.lru01
            LET l_lineno = 0
        BEFORE GROUP OF sr1.lrv02
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lru00 = cl_gr_getmsg("gre-309",g_lang,sr1.lru00)
            LET l_lru06 = cl_gr_getmsg("gre-302",g_lang,sr1.lru06)
            PRINTX sr1.*
            PRINTX l_lru00
            PRINTX l_lru06

        AFTER GROUP OF sr1.lru01
        AFTER GROUP OF sr1.lrv02

        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end
#FUN-CC0060
#CHI-C80041---begin
FUNCTION t612_v()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_lru.lru01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t612_cl USING g_lru.lru01
   IF STATUS THEN
      CALL cl_err("OPEN t612_cl:", STATUS, 1)
      CLOSE t612_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t612_cl INTO g_lru.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lru.lru01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t612_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_lru.lru06 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_lru.lru06)   THEN 
        LET g_chr=g_lru.lru06
        IF g_lru.lru06='N' THEN 
            LET g_lru.lru06='X' 
        ELSE
            LET g_lru.lru06='N'
        END IF
        UPDATE lru_file
            SET lru06=g_lru.lru06,  
                lrumodu=g_user,
                lrudate=g_today
            WHERE lru01=g_lru.lru01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","lru_file",g_lru.lru01,"",SQLCA.sqlcode,"","",1)  
            LET g_lru.lru06=g_chr 
        END IF
        DISPLAY BY NAME g_lru.lru06 
   END IF
 
   CLOSE t612_cl
   COMMIT WORK
   CALL cl_flow_notify(g_lru.lru01,'V')
 
END FUNCTION
#CHI-C80041---end
