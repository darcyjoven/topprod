# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmt600.4gl
# Descriptions...:  投資資料維護作業
# Date & Author..:  00/07/10 By Mandy
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-4A0248 04/10/22 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-550037 05/05/12 By saki   欄位comment顯示
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.FUN-590111 05/10/04 By Nicola 畫面大調
# Modify.........: No.FUN-630020 06/03/08 By pengu 流程訊息通知功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850038 08/05/12 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-850159 08/05/16 By Sarah 取消bp段的ON ACTION accept
# Modify.........: No.MOD-860085 08/06/11 By Sarah 檢核投資單號若存在於gsh03時,需卡住不可取消確認
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gsb   RECORD   LIKE gsb_file.*,
    g_gsb_t RECORD   LIKE gsb_file.*,
    g_gsb_o RECORD   LIKE gsb_file.*,
    b_gsc   RECORD   LIKE gsc_file.*,
    g_gsc   DYNAMIC ARRAY OF RECORD
            gsc02    LIKE gsc_file.gsc02,
            gsc03    LIKE gsc_file.gsc03,
            gsc04    LIKE gsc_file.gsc04,
            gsc05    LIKE gsc_file.gsc05,
            gsc06    LIKE gsc_file.gsc06,
            gsc07    LIKE gsc_file.gsc07,   #No.FUN-590111
            gsc08    LIKE gsc_file.gsc08,   #No.FUN-590111
            gsf02    LIKE gsf_file.gsf02,   #No.FUN-590111
            gsc09    LIKE gsc_file.gsc09    #No.FUN-590111
            #FUN-850038 --start---
           ,gscud01  LIKE gsc_file.gscud01,
            gscud02  LIKE gsc_file.gscud02,
            gscud03  LIKE gsc_file.gscud03,
            gscud04  LIKE gsc_file.gscud04,
            gscud05  LIKE gsc_file.gscud05,
            gscud06  LIKE gsc_file.gscud06,
            gscud07  LIKE gsc_file.gscud07,
            gscud08  LIKE gsc_file.gscud08,
            gscud09  LIKE gsc_file.gscud09,
            gscud10  LIKE gsc_file.gscud10,
            gscud11  LIKE gsc_file.gscud11,
            gscud12  LIKE gsc_file.gscud12,
            gscud13  LIKE gsc_file.gscud13,
            gscud14  LIKE gsc_file.gscud14,
            gscud15  LIKE gsc_file.gscud15
            #FUN-850038 --end--
            END RECORD,
    g_gsc_t RECORD
            gsc02    LIKE gsc_file.gsc02,
            gsc03    LIKE gsc_file.gsc03,
            gsc04    LIKE gsc_file.gsc04,
            gsc05    LIKE gsc_file.gsc05,
            gsc06    LIKE gsc_file.gsc06,
            gsc07    LIKE gsc_file.gsc07,   #No.FUN-590111
            gsc08    LIKE gsc_file.gsc08,   #No.FUN-590111
            gsf02    LIKE gsf_file.gsf02,   #No.FUN-590111
            gsc09    LIKE gsc_file.gsc09    #No.FUN-590111
            #FUN-850038 --start---
           ,gscud01  LIKE gsc_file.gscud01,
            gscud02  LIKE gsc_file.gscud02,
            gscud03  LIKE gsc_file.gscud03,
            gscud04  LIKE gsc_file.gscud04,
            gscud05  LIKE gsc_file.gscud05,
            gscud06  LIKE gsc_file.gscud06,
            gscud07  LIKE gsc_file.gscud07,
            gscud08  LIKE gsc_file.gscud08,
            gscud09  LIKE gsc_file.gscud09,
            gscud10  LIKE gsc_file.gscud10,
            gscud11  LIKE gsc_file.gscud11,
            gscud12  LIKE gsc_file.gscud12,
            gscud13  LIKE gsc_file.gscud13,
            gscud14  LIKE gsc_file.gscud14,
            gscud15  LIKE gsc_file.gscud15
            #FUN-850038 --end--
            END RECORD,
    g_dbs_gl            LIKE type_file.chr21,         #No.FUN-680107 VARCHAR(21)
    g_nms               RECORD LIKE nms_file.*,
    g_buf               LIKE type_file.chr20,         #No.FUN-680107 VARCHAR(20)
    g_dept              LIKE aab_file.aab02,          #No.FUN-680107 VARCHAR(6)
    m_chr               LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
    g_wc,g_wc1,g_sql    LIKE type_file.chr1000,       #No.FUN-680107 VARCHAR(300)
    g_t1                LIKE gsb_file.gsb01,          #No.FUN-550057        #No.FUN-680107 VARCHAR(5)
    g_nmydmy1           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,              #單身筆數             #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5,              #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_cmd           LIKE type_file.chr1000,           #No.FUN-680107 VARCHAR(100)
    g_argv1         LIKE gsb_file.gsb01               #No.FUN-680107 VARCHAR(16)       #No.FUN-550057
 
DEFINE g_argv2  STRING                                #No.FUN-630020 add
DEFINE g_forupd_sql STRING             #SELECT ... FOR UPDATE SQL       
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680107 SMALLINT
DEFINE g_chr           LIKE type_file.chr1            #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10           #No.FUN-680107 INTEGER
DEFINE g_i             LIKE type_file.num5            #count/index for any purpose        #No.FUN-680107 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000         #No.FUN-680107 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680107 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5           #No.FUN-680107 SMALLINT
DEFINE   g_void         LIKE type_file.chr1           #No.FUN-680107 VARCHAR(1)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0082
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
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
 
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)          #No.FUN-630020 add
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
   LET g_forupd_sql = "SELECT * FROM gsb_file WHERE gsb01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
#NO.CHI-6A0004--BEGIN
#   SELECT azi04 INTO g_azi04 FROM azi_file WHERE azi01 = g_aza.aza17 
#   IF STATUS THEN
#      LET g_azi04 = 0
#   END IF
#NO.CHI-6A0004--END
   LET g_plant_new = g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
 
   LET p_row = 1 LET p_col = 10
 
   OPEN WINDOW t600_w AT p_row,p_col
     WITH FORM "anm/42f/anmt600" ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   # No.FUN-630020--start--
   # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是出貨單號(oga01)
   # 執行I時，g_argv1是單號(gxf011)
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
         OTHERWISE
                CALL t600_q()
      END CASE
   END IF
   #No.FUN-630020 ----end---
   CALL t600_menu()
 
   CLOSE WINDOW t600_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
END MAIN
 
FUNCTION t600_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM
   CALL g_gsc.clear()
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
  #IF g_argv1<>' ' THEN             #No.FUN-630020 mark
   IF NOT cl_null(g_argv1) THEN         #No.FUN-630020 add
      LET g_wc=" gsb01='",g_argv1,"'"
      LET g_wc1=" 1=1"
   ELSE
      #-----No.FUN-590111-----
   INITIALIZE g_gsb.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON gsb01,gsb03,gsb04,gsb02,gsb05,gsb06,
                                gsb13,gsbconf,gsb09,gsb10,gsb101,
                                gsb15,gsb11,gsb111,gsb12,gsb121,gsb16,
                                gsbuser,gsbgrup,gsbmodu,gsbdate
                                #FUN-850038   ---start---
                                ,gsbud01,gsbud02,gsbud03,gsbud04,gsbud05,
                                gsbud06,gsbud07,gsbud08,gsbud09,gsbud10,
                                gsbud11,gsbud12,gsbud13,gsbud14,gsbud15
                                #FUN-850038    ----end----
      #-----No.FUN-590111 END-----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
         ON ACTION controlp
            CASE
                #--No.MOD-4A0248--#
               WHEN INFIELD(gsb01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gsb01"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gsb01
                  NEXT FIELD gsb01
               #-------END-------#
               WHEN INFIELD(gsb02)
#                 CALL q_gen(06,11,g_gsb.gsb02) RETURNING g_gsb.gsb02
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gsb02
                  NEXT FIELD gsb02
               WHEN INFIELD(gsb05)
#                 CALL q_gsa(06,12,g_gsb.gsb05) RETURNING g_gsb.gsb05
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gsa"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gsb05
                  NEXT FIELD gsb05
            #  WHEN INFIELD(gsb07)   #No.FUN-590111 Mark
#           #     CALL q_azi(05,11,g_gsb.gsb07) RETURNING g_gsb.gsb07
            #     CALL cl_init_qry_var()
            #     LET g_qryparam.form = "q_azi"
            #     LET g_qryparam.state = "c"
            #     CALL cl_create_qry() RETURNING g_qryparam.multiret
            #     DISPLAY g_qryparam.multiret TO gsb07
            #     NEXT FIELD gsb07
               WHEN INFIELD(gsb13)
#                 CALL q_nma(0,0,g_gsb.gsb13) RETURNING g_gsb.gsb13
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO gsb13
                  NEXT FIELD gsb13
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
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET g_wc = g_wc clipped," AND gsbuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET g_wc = g_wc clipped," AND gsbgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET g_wc = g_wc clipped," AND gsbgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('gsbuser', 'gsbgrup')
      #End:FUN-980030
 
 
      CONSTRUCT g_wc1 ON gsc02,gsc03,gsc04,gsc05,gsc06,gsc07,gsc08,gsc09   #No.FUN-590111
                         #No.FUN-850038 --start--
                         ,gscud01,gscud02,gscud03,gscud04,gscud05
                         ,gscud06,gscud07,gscud08,gscud09,gscud10
                         ,gscud11,gscud12,gscud13,gscud14,gscud15
                         #No.FUN-850038 ---end---
           FROM s_gsc[1].gsc02,s_gsc[1].gsc03,s_gsc[1].gsc04,
                s_gsc[1].gsc05,s_gsc[1].gsc06,
                s_gsc[1].gsc07,s_gsc[1].gsc08,s_gsc[1].gsc09   #No.FUN-590111
                #No.FUN-850038 --start--
                ,s_gsc[1].gscud01,s_gsc[1].gscud02,s_gsc[1].gscud03
                ,s_gsc[1].gscud04,s_gsc[1].gscud05,s_gsc[1].gscud06
                ,s_gsc[1].gscud07,s_gsc[1].gscud08,s_gsc[1].gscud09
                ,s_gsc[1].gscud10,s_gsc[1].gscud11,s_gsc[1].gscud12
                ,s_gsc[1].gscud13,s_gsc[1].gscud14,s_gsc[1].gscud15
                #No.FUN-850038 ---end---
 
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
   END IF
 
   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN
      LET g_sql="SELECT gsb01 FROM gsb_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY gsb01"
   ELSE
      LET g_sql="SELECT UNIQUE gsb_file.gsb01 ",
                "  FROM gsb_file,gsc_file ", # 組合出 SQL 指令
                " WHERE gsb01=gsc01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                " ORDER BY gsb01"
   END IF
 
   PREPARE t600_pr FROM g_sql           # RUNTIME 編譯
 
   DECLARE t600_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t600_pr
 
   IF cl_null(g_wc1) OR g_wc1=" 1=1 " THEN    #捉出符合QBE條件的
      LET g_sql="SELECT COUNT(*) FROM gsb_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT gsb01) FROM gsb_file,gsc_file ",
                " WHERE gsb01=gsc01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
   END IF
 
   PREPARE t600_precount FROM g_sql                           # row的個數
   DECLARE t600_count CURSOR FOR t600_precount
 
END FUNCTION
 
FUNCTION t600_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(100)
 
   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
      #  WHEN "detail"   #No.FUN-590111 Mark
      #     IF cl_chk_act_auth() THEN
      #        CALL t600_b()
      #     ELSE
      #        LET g_action_choice = NULL
      #     END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "memo"
            IF cl_chk_act_auth() THEN
               CALL t600_m()
            END IF
#        WHEN "expense_data"   #No.FUN-590111 Mark
#           IF cl_chk_act_auth() THEN
#              CALL t600_cost()
#           END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               
               #CALL t600_x() #FUN-D20035 Mark
               CALL t600_x(1) #FUN-D20035 add
               IF g_gsb.gsbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gsb.gsbconf,"","","",g_void,"")
            END IF
 #FUN-D20035 add
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t600_x(2) 
               IF g_gsb.gsbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gsb.gsbconf,"","","",g_void,"")
            END IF
 #FUN-D20035 end 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_firm1()
               IF g_gsb.gsbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gsb.gsbconf,"","","",g_void,"")
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_firm2()
               IF g_gsb.gsbconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_gsb.gsbconf,"","","",g_void,"")
            END IF
        WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gsc),'','')
            END IF
        #No.FUN-6A0011---------add---------str----
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_gsb.gsb01 IS NOT NULL THEN
                LET g_doc.column1 = "gsb01"
                LET g_doc.value1 = g_gsb.gsb01
                CALL cl_doc()
              END IF
        END IF
        #No.FUN-6A0011---------add---------end----
      END CASE
   END WHILE
    CLOSE t600_cs
END FUNCTION
 
FUNCTION t600_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_gsb.* TO NULL              #NO.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t600_cs()                          # 宣告 SCROLL CURSOR
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      LET g_gsb.gsb01 = NULL   #MOD-660086 add
      RETURN 
   END IF
 
   OPEN t600_count
   FETCH t600_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN t600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)
      INITIALIZE g_gsb.* TO NULL
   ELSE
      CALL t600_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t600_fetch(p_flgsb)
   DEFINE
      p_flgsb         LIKE type_file.chr1,             #No.FUN-680107 VARCHAR(1)    #處理方式
      l_abso          LIKE type_file.num10             #絕對的筆數        #No.FUN-680107 INTEGER
 
   CASE p_flgsb
      WHEN 'N' FETCH NEXT     t600_cs INTO g_gsb.gsb01
      WHEN 'P' FETCH PREVIOUS t600_cs INTO g_gsb.gsb01
      WHEN 'F' FETCH FIRST    t600_cs INTO g_gsb.gsb01
      WHEN 'L' FETCH LAST     t600_cs INTO g_gsb.gsb01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt mod
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
            FETCH ABSOLUTE g_jump t600_cs INTO g_gsb.gsb01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)
      INITIALIZE g_gsb.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flgsb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_gsb.* FROM gsb_file            # 重讀DB,因TEMP有不被更新特性
    WHERE gsb01 = g_gsb.gsb01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)   #No.FUN-660148
      CALL cl_err3("sel","gsb_file",g_gsb.gsb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_gsb.gsbuser     #No.FUN-4C0063
      LET g_data_group = g_gsb.gsbgrup     #No.FUN-4C0063
      CALL t600_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION t600_show()
   DEFINE l_azi02,a,b     LIKE type_file.chr20         #No.FUN-680107 VARCHAR(20)
   DEFINE l_gsc02         LIKE gsc_file.gsc02          #No.FUN-680107 VARCHAR(12)
   DEFINE l_gsa02         LIKE gsa_file.gsa02
   DEFINE l_gen02         LIKE gen_file.gen02
 
   #-----No.FUN-590111-----
   DISPLAY BY NAME g_gsb.gsb01,g_gsb.gsb02,g_gsb.gsb03,g_gsb.gsb04, g_gsb.gsboriu,g_gsb.gsborig,
                   g_gsb.gsb05,g_gsb.gsb06,g_gsb.gsb09,g_gsb.gsb10,
                   g_gsb.gsb101,g_gsb.gsb11,g_gsb.gsb111,g_gsb.gsb12,
                   g_gsb.gsb121,g_gsb.gsb13,g_gsb.gsb15,g_gsb.gsb16,
                   g_gsb.gsbconf,g_gsb.gsbuser,g_gsb.gsbgrup,g_gsb.gsbmodu,
                   g_gsb.gsbdate
                  #FUN-850038     ---start---
                 ,g_gsb.gsbud01,g_gsb.gsbud02,g_gsb.gsbud03,g_gsb.gsbud04,
                  g_gsb.gsbud05,g_gsb.gsbud06,g_gsb.gsbud07,g_gsb.gsbud08,
                  g_gsb.gsbud09,g_gsb.gsbud10,g_gsb.gsbud11,g_gsb.gsbud12,
                  g_gsb.gsbud13,g_gsb.gsbud14,g_gsb.gsbud15 
                  #FUN-850038     ----end----
   #-----No.FUN-590111 END-----
 
   SELECT gsa02 INTO l_gsa02 FROM gsa_file
    WHERE gsa01=g_gsb.gsb05
 
   DISPLAY l_gsa02 TO gsa02
 
   SELECT gen02 INTO l_gen02 FROM gen_file
    WHERE gen01=g_gsb.gsb02
 
   DISPLAY l_gen02 TO gen02
 
   CALL t600_b_fill(g_wc1)
 
   IF g_gsb.gsbconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
 
   CALL cl_set_field_pic(g_gsb.gsbconf,"","","",g_void,"")
 
END FUNCTION
 
FUNCTION t600_a()           #輸入
   DEFINE l_cmd       LIKE type_file.chr1000   #No.FUN-680107 VARCHAR(400)
   DEFINE li_result   LIKE type_file.num5      #No.FUN-550057        #No.FUN-680107 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_gsc.clear()
   INITIALIZE g_gsb.* TO NULL
   LET g_gsb_t.*     = g_gsb.*
   LET g_gsb.gsbconf = 'N'
   LET g_gsb.gsb03   = g_today
   LET g_gsb.gsbuser = g_user
   LET g_gsb.gsboriu = g_user #FUN-980030
   LET g_gsb.gsborig = g_grup #FUN-980030
   LET g_gsb.gsbgrup = g_grup               #使用者所屬群
   LET g_gsb.gsbdate = g_today
   #-----No.FUN-590111-----
   LET g_gsb.gsb09   = 0
   LET g_gsb.gsb10   = 0
   LET g_gsb.gsb101  = 0
   LET g_gsb.gsb15   = 0
   LET g_gsb.gsb11   = 0
   LET g_gsb.gsb111  = 0
   LET g_gsb.gsb12   = 0
   LET g_gsb.gsb121  = 0
   LET g_gsb.gsb16   = 0
   #-----No.FUN-590111 END-----
 
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL t600_i('a')
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_gsb.* TO NULL
         EXIT WHILE
      END IF
 
      IF cl_null(g_gsb.gsb01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK  #No.7875
 
#No.FUN-550057 --start--
        CALL s_auto_assign_no("anm",g_gsb.gsb01,g_gsb.gsb03,"8","gsb_file","gsb01","","","")
             RETURNING li_result,g_gsb.gsb01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_gsb.gsb01
 
#      IF g_nmy.nmyauno='Y' THEN
#         CALL s_nmyauno(g_gsb.gsb01,g_gsb.gsb03,'8')
#              RETURNING g_i,g_gsb.gsb01
#        IF g_i THEN CONTINUE WHILE END IF
#        DISPLAY BY NAME g_gsb.gsb01
#      END IF
#No.FUN-550057 ---end--
 
      #FUN-980005 add legal 
      LET g_gsb.gsblegal = g_legal 
      #FUN-980005 end legal 
 
      INSERT INTO gsb_file VALUES (g_gsb.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","gsb_file",g_gsb.gsb01,"",SQLCA.sqlcode,"","t600_ins_gsb:",1)  #No.FUN-660148 #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK #No.7875
#        CALL cl_err('t600_ins_gsb:',SQLCA.sqlcode,1)   #No.FUN-660148
         LET g_success = 'N' CONTINUE WHILE
      ELSE
        #-MOD-AC0073-add-
         #---判斷是否立即confirm-----
         LET g_t1 = s_get_doc_no(g_gsb.gsb01)    
         SELECT nmydmy1 INTO g_nmydmy1
           FROM nmy_file
          WHERE nmyslip = g_t1 AND nmyacti = 'Y'
         IF g_nmydmy1 = 'Y' THEN CALL t600_firm1() END IF
        #-MOD-AC0073-end-
         COMMIT WORK #No.7875
         CALL cl_flow_notify(g_gsb.gsb01,'I')
      END IF
 
      CALL g_gsc.clear()
 
      SELECT gsb01 INTO g_gsb.gsb01 FROM gsb_file WHERE gsb01 = g_gsb.gsb01
 
      LET g_gsb_t.* = g_gsb.*
      LET g_rec_b=0
 
  #   CALL t600_b()   #No.FUN-590111 Mark
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t600_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE l_n          LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_tot        LIKE type_file.num20_6       #No.FUN-4C0010        #No.FUN-680107 DEC(20,6)
   DEFINE l_nma02      LIKE nma_file.nma02
   DEFINE l_nma21      LIKE nma_file.nma21
   DEFINE l_gsbacti    LIKE gsb_file.gsbacti
   DEFINE l_flag       LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE l_msg        LIKE ze_file.ze03            #No.FUN-680107 VARCHAR(30)
   DEFINE g_t1         LIKE gsb_file.gsb01          #No.FUN-550057        #No.FUN-680107 VARCHAR(5)
   DEFINE l_gen02      LIKE gen_file.gen02
   DEFINE l_gsa02      LIKE gsa_file.gsa02 
   DEFINE li_result    LIKE type_file.num5          #No.FUN-550057        #No.FUN-680107 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   #-----No.FUN-590111-----
   INPUT BY NAME g_gsb.gsb01,g_gsb.gsb03,g_gsb.gsb04,g_gsb.gsb02,g_gsb.gsb05, g_gsb.gsboriu,g_gsb.gsborig,
                 g_gsb.gsb06,g_gsb.gsb13,g_gsb.gsbconf,g_gsb.gsbuser,
                 g_gsb.gsbgrup,g_gsb.gsbmodu,g_gsb.gsbdate 
                 #FUN-850038     ---start---
                ,g_gsb.gsbud01,g_gsb.gsbud02,g_gsb.gsbud03,g_gsb.gsbud04,
                 g_gsb.gsbud05,g_gsb.gsbud06,g_gsb.gsbud07,g_gsb.gsbud08,
                 g_gsb.gsbud09,g_gsb.gsbud10,g_gsb.gsbud11,g_gsb.gsbud12,
                 g_gsb.gsbud13,g_gsb.gsbud14,g_gsb.gsbud15 
                 #FUN-850038     ----end----
                 WITHOUT DEFAULTS
   #-----No.FUN-590111 END-----
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t600_set_entry(p_cmd)
         CALL t600_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#No.FUN-550057 --start--
         CALL cl_set_docno_format("gsb01")
#No.FUN-550057 --end--
 
      AFTER FIELD gsb01
         IF NOT cl_null(g_gsb.gsb01) THEN
#No.FUN-550057 --start--
    CALL s_check_no("anm",g_gsb.gsb01,g_gsb_t.gsb01,"8","gsb_file","gsb01","")
         RETURNING li_result,g_gsb.gsb01
    DISPLAY BY NAME g_gsb.gsb01
       IF (NOT li_result) THEN
          NEXT FIELD gsb01
       END IF
#            IF NOT cl_null(g_gsb.gsb01[5,10]) THEN
#               IF p_cmd='a' OR (p_cmd='u' THEN
#    g_argv1         VARCHAR(10),
#                  SELECT count(*) INTO l_n FROM gsb_file
#                   WHERE gsb01=g_gsb.gsb01
#                  IF l_n > 0 THEN    #Duplicated
#                     CALL cl_err(g_gsb.gsb01,-239,0)
#                     LET g_gsb.gsb01 = g_gsb_t.gsb01
#                     DISPLAY BY NAME g_gsb.gsb01
#                     NEXT FIELD gsb01
#                  END IF
#               END IF
#            END IF
#            LET g_t1=g_gsb.gsb01[1,3]
#            CALL s_nmyslip(g_t1,'8',g_sys)  # 單別,單據性質NO:6842
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(g_t1,g_errno,0)
#               NEXT FIELD gsb01
#            END IF
#            IF g_nmy.nmyauno MATCHES '[nN]' THEN
#               IF cl_null(g_gsb.gsb01[5,10]) THEN
#                  CALL cl_err(g_gsb.gsb01,'anm-108',0)
#                  NEXT FIELD gsb01
#               END IF
#            END IF
#No.FUN-550057 ---end--
         END IF
 
      AFTER FIELD gsb02
         IF NOT cl_null(g_gsb.gsb02) THEN
            SELECT count(*) INTO l_n FROM gen_file
             WHERE gen01 = g_gsb.gsb02
            IF l_n > 0 THEN
               SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01 = g_gsb.gsb02
               DISPLAY l_gen02 TO gen02
            ELSE
               NEXT FIELD gsb02
            END IF
         ELSE
            DISPLAY '' TO gen02
         END IF
 
      AFTER FIELD gsb03
         IF NOT cl_null(g_gsb.gsb03) THEN
            IF g_gsb.gsb03 <= g_nmz.nmz10 THEN
               CALL cl_err('','aap-176',1)
               NEXT FIELD gsb03
            END IF
         END IF
 
      AFTER FIELD gsb05
         IF NOT cl_null(g_gsb.gsb05) THEN
            SELECT count(*) INTO l_n FROM gsa_file
             WHERE gsa01=g_gsb.gsb05
            IF l_n > 0 THEN
               SELECT gsa02 INTO l_gsa02 FROM gsa_file
                WHERE gsa01=g_gsb.gsb05
               DISPLAY l_gsa02 TO gsa02
            ELSE
               NEXT FIELD gsb05
            END IF
         END IF
 
      AFTER FIELD gsb13
         IF NOT cl_null(g_gsb.gsb13) THEN
            SELECT nma01 INTO g_gsb.gsb13
              FROM nma_file WHERE nma01 = g_gsb.gsb13
            IF STATUS THEN
#              CALL cl_err('select nma',STATUS,0)   #No.FUN-660148
               CALL cl_err3("sel","nma_file",g_gsb.gsb13,"",STATUS,"","select nma",1)  #No.FUN-660148
               NEXT FIELD gsb13
            END IF
         END IF
 
     ##-----No.FUN-590111 Mark-----
     #AFTER FIELD gsb07
     #   IF NOT cl_null(g_gsb.gsb07) THEN
     #      SELECT azi01
     #        FROM azi_file WHERE azi01=g_gsb.gsb07
     #      IF STATUS THEN
     #         CALL cl_err('select azi',STATUS,0)
     #         NEXT FIELD gsb07
     #      END IF
     #      IF g_aza.aza17 = g_gsb.gsb07 THEN #本幣
     #         LET g_gsb.gsb08 = 1
     #      ELSE
     #         CALL s_curr3(g_gsb.gsb07,g_gsb.gsb03,'B')
     #              RETURNING g_gsb.gsb08
     #      END IF
     #      DISPLAY BY NAME g_gsb.gsb08
     #   END IF
 
     #AFTER FIELD gsb08
     #   IF NOT cl_null(g_gsb.gsb08) THEN
     #      IF g_gsb.gsb08 < 0 THEN
     #         NEXT FIELD gsb08
     #      END IF
 
     #      #FUN-4C0070
     #      IF g_gsb.gsb07 =g_aza.aza17 THEN
     #         LET g_gsb.gsb08 =1
     #         DISPLAY BY NAME g_gsb.gsb08
     #      END IF
     #      #--END
 
     #   END IF
 
     #AFTER FIELD gsb09
     #   IF NOT cl_null(g_gsb.gsb09) THEN
     #      IF g_gsb.gsb09 < 0 THEN
     #         NEXT FIELD gsb09
     #      END IF
     #   END IF
 
     #AFTER FIELD gsb10
     #   IF NOT cl_null(g_gsb.gsb10) THEN
     #      LET g_gsb.gsb12 = g_gsb.gsb10 - g_gsb.gsb11
     #      LET g_gsb.gsb17 = g_gsb.gsb09 * g_gsb.gsb10
     #      DISPLAY BY NAME g_gsb.gsb11,g_gsb.gsb12,g_gsb.gsb17
     #   END IF
 
     #AFTER FIELD gsb101
     #   IF NOT cl_null(g_gsb.gsb101) THEN
     #      IF g_gsb.gsb101 < 0 THEN
     #         NEXT FIELD gsb101
     #      END IF
     #      LET g_gsb.gsb121 = g_gsb.gsb101 - g_gsb.gsb111
     #      DISPLAY BY NAME g_gsb.gsb111,g_gsb.gsb121
     #   END IF
 
     #BEFORE FIELD gsb14
     #    IF cl_null(g_gsb.gsb14) THEN
     #       LET g_gsb.gsb14 = 0
     #    END IF
 
     #AFTER FIELD gsb14
     #   IF cl_null(g_gsb.gsb14) THEN
     #      LET g_gsb.gsb14 = 0
     #      DISPLAY BY NAME g_gsb.gsb14
     #   END IF
 
     #BEFORE FIELD gsb15
     #   IF cl_null(g_gsb.gsb15) THEN
     #      LET g_gsb.gsb15 = 0
     #   END IF
 
     #AFTER FIELD gsb15
     #   IF cl_null(g_gsb.gsb15) THEN
     #      LET g_gsb.gsb15 = 0
     #      DISPLAY BY NAME g_gsb.gsb15
     #   END IF
     ##-----No.FUN-590111 Mark END-----
 
        #FUN-850038     ---start---
        AFTER FIELD gsbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gsbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850038     ----end----
 
      AFTER INPUT
         LET g_gsb.gsbuser = s_get_data_owner("gsb_file") #FUN-C10039
         LET g_gsb.gsbgrup = s_get_data_group("gsb_file") #FUN-C10039
         IF INT_FLAG THEN EXIT INPUT END IF
         IF cl_null(g_gsb.gsb01) THEN
            NEXT FIELD gsb01
         END IF
         LET l_flag='N'
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(gsb01)
               LET g_t1 = s_get_doc_no(g_gsb.gsb01)       #No.FUN-550057
              #CALL q_nmy(FALSE,FALSE,g_t1,'8',g_sys) RETURNING g_t1  #TQC-670008 remark
               CALL q_nmy(FALSE,FALSE,g_t1,'8','ANM') RETURNING g_t1  #TQC-670008 
#               CALL FGL_DIALOG_SETBUFFER( g_t1 )
               LET g_gsb.gsb01= g_t1      #No.FUN-550057
               DISPLAY BY NAME g_gsb.gsb01
               NEXT FIELD gsb01
            WHEN INFIELD(gsb02)
#              CALL q_gen(06,11,g_gsb.gsb02) RETURNING g_gsb.gsb02
#              CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = g_gsb.gsb02
               CALL cl_create_qry() RETURNING g_gsb.gsb02
#               CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb02 )
               SELECT gen02 INTO l_gen02 FROM gen_file
                WHERE gen01=g_gsb.gsb02
               DISPLAY l_gen02 TO gen02
               NEXT FIELD gsb02
            WHEN INFIELD(gsb05)
#              CALL q_gsa(06,12,g_gsb.gsb05) RETURNING g_gsb.gsb05
#              CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb05 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gsa"
               LET g_qryparam.default1 = g_gsb.gsb05
               CALL cl_create_qry() RETURNING g_gsb.gsb05
#               CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb05 )
               SELECT gsa02 INTO l_gsa02 FROM gsa_file
                WHERE gsa01=g_gsb.gsb05
               DISPLAY l_gsa02 TO gsa02
               NEXT FIELD gsb05
           #WHEN INFIELD(gsb07)   #No.FUN-590111 Mark
#          #   CALL q_azi(05,11,g_gsb.gsb07) RETURNING g_gsb.gsb07
#          #   CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb07 )
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form = "q_azi"
           #   LET g_qryparam.default1 = g_gsb.gsb07
           #   CALL cl_create_qry() RETURNING g_gsb.gsb07
#          #    CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb07 )
           #   DISPLAY BY NAME g_gsb.gsb07
           #   NEXT FIELD gsb07
            WHEN INFIELD(gsb13)
#              CALL q_nma(0,0,g_gsb.gsb13) RETURNING g_gsb.gsb13
#              CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb13 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nma"
               LET g_qryparam.default1 = g_gsb.gsb13
               CALL cl_create_qry() RETURNING g_gsb.gsb13
#               CALL FGL_DIALOG_SETBUFFER( g_gsb.gsb13 )
               DISPLAY BY NAME g_gsb.gsb13
               NEXT FIELD gsb13
              #-----No.FUN-4B0052-----
              WHEN INFIELD(gsb08)
                   CALL s_rate(g_gsb.gsb07,g_gsb.gsb08) RETURNING g_gsb.gsb08
                   DISPLAY BY NAME g_gsb.gsb08
                   NEXT FIELD gsb08
              #-----No.FUN-4B0052 END-----
            OTHERWISE EXIT CASE
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
 
FUNCTION t600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_row,l_col     LIKE type_file.num5,          #No.FUN-680107 SMALLINT     #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,          #檢查重複用         #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否         #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #處理狀態           #No.FUN-680107 VARCHAR(1)
    l_nmaacti       LIKE nma_file.nmaacti,
    l_b2            LIKE type_file.chr50,         #No.FUN-680107 VARCHAR(30) #TQC-840066
    l_flag          LIKE type_file.num10,         #No.FUN-680107 INTEGER
    l_dir           LIKE type_file.chr1,          #No.FUN-680107 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680107 SMALLINT
 
    LET g_action_choice = ""
    SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = g_gsb.gsb01
    IF cl_null(g_gsb.gsb01) THEN RETURN END IF
    IF g_gsb.gsbconf = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
    IF g_gsb.gsbconf = 'Y' THEN
       CALL cl_err('','anm-105',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM gsc_file WHERE gsc01=? AND gsc02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gsc WITHOUT DEFAULTS FROM s_gsc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
        IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)
        END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
         #LET g_gsc_t.* = g_gsc[l_ac].*  #BACKUP
          LET l_lock_sw = 'N'                   #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          OPEN t600_cl USING g_gsb.gsb01
          IF STATUS THEN
             CALL cl_err("OPEN t600_cl:", STATUS, 1)
             CLOSE t600_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t600_cl INTO g_gsb.*
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)
             CLOSE t600_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
         #IF NOT cl_null(g_gsc[l_ac].gsc02) THEN
             LET p_cmd='u'
             LET g_gsc_t.* = g_gsc[l_ac].*  #BACKUP
             OPEN t600_bcl USING g_gsb.gsb01,g_gsc_t.gsc02
             IF STATUS THEN
                CALL cl_err("OPEN t600_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t600_bcl INTO b_gsc.*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('lock gsc',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   CALL t600_b_move_to()
                END IF
             END IF
             CALL cl_show_fld_cont()     #No.FUN-550037
          END IF
         #LET g_gsc_t.* = g_gsc[l_ac].*  #BACKUP
         #NEXT FIELD gsc02
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_gsc[l_ac].* TO NULL      #900423
          LET b_gsc.gsc01=g_gsb.gsb01
          INITIALIZE g_gsc_t.* TO NULL
          NEXT FIELD gsc02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
            #CALL g_gsc.deleteElement(l_ac)   #取消 Array Element
            #IF g_rec_b != 0 THEN   #單身有資料時取消新增而不離開輸入
            #   LET g_action_choice = "detail"
            #   LET l_ac = l_ac_t
            #END IF
            #EXIT INPUT
          END IF
          LET g_success='Y'
          CALL t600_b_move_back()
          INSERT INTO gsc_file VALUES(b_gsc.*)
          IF SQLCA.sqlcode THEN
#            CALL cl_err('ins gsc',SQLCA.sqlcode,0)   #No.FUN-660148
             CALL cl_err3("ins","gsc_file",b_gsc.gsc01,b_gsc.gsc02,SQLCA.sqlcode,"","ins gsc",1)  #No.FUN-660148
            #LET g_gsc[l_ac].* = g_gsc_t.*
             CANCEL INSERT
          ELSE
             IF g_success='Y' THEN
                COMMIT WORK
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
             ELSE
                ROLLBACK WORK
                MESSAGE 'ROLLBACK'
             END IF
          END IF
 
       BEFORE FIELD gsc02                            #default 序號
          IF cl_null(g_gsc[l_ac].gsc02) OR g_gsc[l_ac].gsc02 = 0 THEN
             SELECT max(gsc02)+1 INTO g_gsc[l_ac].gsc02
               FROM gsc_file WHERE gsc01 = g_gsb.gsb01
             IF cl_null(g_gsc[l_ac].gsc02) THEN
                LET g_gsc[l_ac].gsc02 = 1
             END IF
          END IF
 
       AFTER FIELD gsc02                        #check 序號是否重複
          IF NOT cl_null(g_gsc[l_ac].gsc02) THEN
             IF g_gsc[l_ac].gsc02 != g_gsc_t.gsc02 OR cl_null(g_gsc_t.gsc02) THEN
                SELECT count(*) INTO l_n FROM gsc_file
                 WHERE gsc01 = g_gsb.gsb01 AND gsc02 = g_gsc[l_ac].gsc02
                IF l_n > 0 THEN
                   LET g_gsc[l_ac].gsc02 = g_gsc_t.gsc02
                   CALL cl_err('',-239,0)
                   NEXT FIELD gsc02
                END IF
             END IF
          END IF
 
        #No.FUN-850038 --start--
        AFTER FIELD gscud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD gscud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850038 ---end---
 
       BEFORE DELETE                            #是否取消單身
          IF g_gsc_t.gsc02 > 0 AND g_gsc_t.gsc02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
             DELETE FROM gsc_file
              WHERE gsc01 = g_gsb.gsb01 AND gsc02 = g_gsc_t.gsc02
             IF SQLCA.SQLCODE THEN
#               CALL cl_err('del gsc',SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("del","gsc_file",g_gsb.gsb01,g_gsc_t.gsc02,SQLCA.sqlcode,"","del gsc",1)  #No.FUN-660148
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             COMMIT WORK
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_gsc[l_ac].* = g_gsc_t.*
              CLOSE t600_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_gsc[l_ac].gsc02,-263,1)
              LET g_gsc[l_ac].* = g_gsc_t.*
           ELSE
              LET g_success='Y'
              CALL t600_b_move_back()
              UPDATE gsc_file SET * = b_gsc.*
               WHERE gsc01 =g_gsb.gsb01 AND gsc02=g_gsc_t.gsc02
              IF SQLCA.sqlcode THEN
#                CALL cl_err('upd gsc',SQLCA.sqlcode,0)   #No.FUN-660148
                 CALL cl_err3("upd","gsc_file",g_gsb.gsb01,g_gsc_t.gsc02,SQLCA.sqlcode,"","upd gsc",1)  #No.FUN-660148
                 LET g_gsc[l_ac].* = g_gsc_t.*
              ELSE
                 IF g_success='Y' THEN
                    COMMIT WORK
                    MESSAGE 'UPDATE O.K'
                 ELSE
                    ROLLBACK WORK
                    MESSAGE 'ROLLBACK'
                 END IF
              END IF
           END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gsc[l_ac].* = g_gsc_t.*
             END IF
             CLOSE t600_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
         #LET g_gsc_t.* = g_gsc[l_ac].*
          CLOSE t600_bcl
          COMMIT WORK
 
#      ON ACTION CONTROLN
#         CALL t600_baskey()
#         EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(gsc02) AND l_ac > 1 THEN
             LET g_gsc[l_ac].* = g_gsc[l_ac-1].*
             LET g_gsc[l_ac].gsc02 = NULL
             NEXT FIELD gsc02
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
    END INPUT
 
    UPDATE gsb_file SET gsbdate = g_today
     WHERE gsb01 = g_gsb.gsb01
    CLOSE t600_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t600_baskey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(200)
 
   CONSTRUCT g_wc1 ON gsc02,gsc03,gsc04,gsc05,gsc06
                 FROM s_gsc[1].gsc02,s_gsc[1].gsc03,
                      s_gsc[1].gsc04,s_gsc[1].gsc05,s_gsc[1].gsc06
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
   CALL t600_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t600_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680107 VARCHAR(300)
 
    LET g_sql = "SELECT gsc02,gsc03,gsc04,gsc05,gsc06,gsc07,gsc08,'',gsc09",   #No.FUN-590111
                #No.FUN-850038 --start--
                ",gscud01,gscud02,gscud03,gscud04,gscud05,",
                "gscud06,gscud07,gscud08,gscud09,gscud10,",
                "gscud11,gscud12,gscud13,gscud14,gscud15", 
                #No.FUN-850038 ---end---
                " FROM gsc_file",
                " WHERE gsc01 ='",g_gsb.gsb01,"' AND ", p_wc2 CLIPPED,
                " ORDER BY gsc03"  #No.FUN-590111
 
    PREPARE t600_pb FROM g_sql
    DECLARE gsc_curs CURSOR FOR t600_pb
 
    CALL g_gsc.clear()
    LET g_cnt = 1
    FOREACH gsc_curs INTO g_gsc[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
 
       #-----No.FUN-590111-----
       SELECT gsf02 INTO g_gsc[g_cnt].gsf02
         FROM gsf_file
        WHERE gsf01 = g_gsc[g_cnt].gsc08
       #-----No.FUN-590111 END-----
 
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
 
    END FOREACH
    CALL g_gsc.deleteElement(g_cnt)   #取消 Array Element
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gsc TO s_gsc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()              #No.FUN-550037
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
         CALL t600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION previous
         CALL t600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION jump
         CALL t600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION next
         CALL t600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION last
         CALL t600_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
    # ON ACTION detail   #No.FUN-590111 Mark
    #    LET g_action_choice="detail"
    #    LET l_ac = 1
    #    EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         IF g_gsb.gsbconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_gsb.gsbconf,"","","",g_void,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
#     #@ON ACTION 費用資料   #No.FUN-590111 Mark
#     ON ACTION expense_data
#        LET g_action_choice="expense_data"
#        EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #FUN-D20035 add sta
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY  
      #FUN-D20035 add end   
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
     #str MOD-850159 mark
     #ON ACTION accept
     #   LET g_action_choice="detail"
     #   LET l_ac = ARR_CURR()
     #   EXIT DISPLAY
     #end MOD-850159 mark
 
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
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------   
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t600_b_move_to()
   LET g_gsc[l_ac].gsc02 = b_gsc.gsc02
   LET g_gsc[l_ac].gsc03 = b_gsc.gsc03
   LET g_gsc[l_ac].gsc04 = b_gsc.gsc04
   LET g_gsc[l_ac].gsc05 = b_gsc.gsc05
   LET g_gsc[l_ac].gsc06 = b_gsc.gsc06
   #NO.FUN-850038 --start--
   LET g_gsc[l_ac].gscud01 = b_gsc.gscud01
   LET g_gsc[l_ac].gscud02 = b_gsc.gscud02
   LET g_gsc[l_ac].gscud03 = b_gsc.gscud03
   LET g_gsc[l_ac].gscud04 = b_gsc.gscud04
   LET g_gsc[l_ac].gscud05 = b_gsc.gscud05
   LET g_gsc[l_ac].gscud06 = b_gsc.gscud06
   LET g_gsc[l_ac].gscud07 = b_gsc.gscud07
   LET g_gsc[l_ac].gscud08 = b_gsc.gscud08
   LET g_gsc[l_ac].gscud09 = b_gsc.gscud09
   LET g_gsc[l_ac].gscud10 = b_gsc.gscud10
   LET g_gsc[l_ac].gscud11 = b_gsc.gscud11
   LET g_gsc[l_ac].gscud12 = b_gsc.gscud12
   LET g_gsc[l_ac].gscud13 = b_gsc.gscud13
   LET g_gsc[l_ac].gscud14 = b_gsc.gscud14
   LET g_gsc[l_ac].gscud15 = b_gsc.gscud15
   #NO.FUN-850038 --end--
END FUNCTION
 
FUNCTION t600_b_move_back()
   LET b_gsc.gsc01 = g_gsb.gsb01
   LET b_gsc.gsc02 = g_gsc[l_ac].gsc02
   LET b_gsc.gsc03 = g_gsc[l_ac].gsc03
   LET b_gsc.gsc04 = g_gsc[l_ac].gsc04
   LET b_gsc.gsc05 = g_gsc[l_ac].gsc05
   LET b_gsc.gsc06 = g_gsc[l_ac].gsc06
   #No.FUN-850038 --start--
   LET b_gsc.gscud01 = g_gsc[l_ac].gscud01
   LET b_gsc.gscud02 = g_gsc[l_ac].gscud02
   LET b_gsc.gscud03 = g_gsc[l_ac].gscud03
   LET b_gsc.gscud04 = g_gsc[l_ac].gscud04
   LET b_gsc.gscud05 = g_gsc[l_ac].gscud05
   LET b_gsc.gscud06 = g_gsc[l_ac].gscud06
   LET b_gsc.gscud07 = g_gsc[l_ac].gscud07
   LET b_gsc.gscud08 = g_gsc[l_ac].gscud08
   LET b_gsc.gscud09 = g_gsc[l_ac].gscud09
   LET b_gsc.gscud10 = g_gsc[l_ac].gscud10
   LET b_gsc.gscud11 = g_gsc[l_ac].gscud11
   LET b_gsc.gscud12 = g_gsc[l_ac].gscud12
   LET b_gsc.gscud13 = g_gsc[l_ac].gscud13
   LET b_gsc.gscud14 = g_gsc[l_ac].gscud14
   LET b_gsc.gscud15 = g_gsc[l_ac].gscud15
   #NO.FUN-850038 --end--
 
   #FUN-980005 add legal 
   LET b_gsc.gsclegal = g_legal 
   #FUN-980005 end legal 
END FUNCTION
 
 
 
FUNCTION t600_u()
   DEFINE    l_flag   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gsb.gsb01) THEN
      CALL cl_err('',-400,2)
      RETURN
   END IF
   SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = g_gsb.gsb01
   IF g_gsb.gsbconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_gsb.gsbconf='Y' THEN
      CALL cl_err(g_gsb.gsb01,'anm-105',2)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t600_cl USING g_gsb.gsb01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_gsb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_gsb_o.* = g_gsb.*
   LET g_gsb_t.* = g_gsb.*
   CALL t600_show()
   IF g_success = 'N' THEN
      LET g_gsb.* = g_gsb_t.*
      CALL t600_show()
      ROLLBACK WORK
      RETURN
   END IF
   CALL t600_i('u')
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_gsb.* = g_gsb_t.*
      CALL t600_show()
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE gsb_file SET * = g_gsb.* WHERE gsb01 = g_gsb_t.gsb01
   IF STATUS THEN
#     CALL cl_err('up gsb',STATUS,1)   #No.FUN-660148
      CALL cl_err3("upd","gsb_file",g_gsb_t.gsb01,"",STATUS,"","up gsb",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   CALL t600_show()
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_gsb.gsb01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t600_r()
   DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gsb.gsb01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = g_gsb.gsb01
   IF g_gsb.gsbconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_gsb.gsbconf='Y' THEN
      CALL cl_err(g_gsb.gsb01,'anm-105',2)
      RETURN
   END IF
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t600_cl USING g_gsb.gsb01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_gsb.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_gsb_o.* = g_gsb.*
   LET g_gsb_t.* = g_gsb.*
   CALL t600_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gsb01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gsb.gsb01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM gsb_file
       WHERE gsb01 = g_gsb.gsb01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('(t600_r:delete gsb)',SQLCA.sqlcode,1)   #No.FUN-660148
         CALL cl_err3("del","gsb_file",g_gsb.gsb01,"",SQLCA.sqlcode,"","(t600_r:delete gsb)",1)  #No.FUN-660148
         LET g_success='N' 
      END IF
      DELETE FROM gsc_file WHERE gsc01 = g_gsb.gsb01
      IF SQLCA.sqlcode THEN
#        CALL cl_err('(t600_r:delete gsc)',SQLCA.sqlcode,1)    #No.FUN-660148
         CALL cl_err3("del","gsc_file",g_gsb.gsb01,"",SQLCA.sqlcode,"","(t600_r:delete gsc)",1)  #No.FUN-660148
         LET g_success='N'
      END IF
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)   #FUN-980005 add plant & legal 
                   VALUES ('anmt600',g_user,g_today,g_msg,g_gsb.gsb01,'Delete',g_plant,g_legal)
      INITIALIZE g_gsb.* TO NULL
      IF g_success = 'Y' THEN
         COMMIT WORK
         LET g_gsb_t.* = g_gsb.*
         CALL cl_flow_notify(g_gsb.gsb01,'D')
         OPEN t600_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE t600_cs
            CLOSE t600_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH t600_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t600_cs
            CLOSE t600_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t600_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t600_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t600_fetch('/')
         END IF
      ELSE
         ROLLBACK WORK
         LET g_gsb.* = g_gsb_t.*
      END IF
   END IF
   CALL t600_show()
END FUNCTION
 
FUNCTION t600_firm1()
   DEFINE l_gsb01_old LIKE gsb_file.gsb01
 
   LET l_gsb01_old=g_gsb.gsb01    # backup old key value gsb01
   LET g_success='Y'
#CHI-C30107 --------- add -------- begin
   IF g_gsb.gsbconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF

   IF g_gsb.gsbconf='Y' THEN
      RETURN
   END IF
   IF NOT cl_sure(20,20) THEN
      RETURN
   END IF
   SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = g_gsb.gsb01
#CHI-C30107 --------- add -------- end
   IF g_gsb.gsbconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_gsb.gsbconf='Y' THEN
      RETURN
   END IF
 
  ##-----No.FUN-590111 Mark-----
  #SELECT COUNT(*) INTO g_cnt FROM gsc_file
  # WHERE gsc01 = g_gsb.gsb01
  #IF g_cnt = 0 THEN
  #   CALL cl_err('','anm-242',1)
  #   RETURN
  #END IF
  ##-----No.FUN-590111 Mark END-----
 
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_gsb.gsb03 <= g_nmz.nmz10 THEN
      CALL cl_err(g_gsb.gsb01,'aap-176',1)
      RETURN
   END IF
 
#CHI-C30107 ----------mark ---------- begin
#  IF NOT cl_sure(20,20) THEN
#     RETURN
#  END IF
#CHI-C30107 ----------mark ---------- end
 
   BEGIN WORK
 
   OPEN t600_cl USING g_gsb.gsb01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_gsb.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE gsb_file SET gsbconf = 'Y' WHERE gsb01 = g_gsb.gsb01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#     CALL cl_err('upd gsbconf',STATUS,1)   #No.FUN-660148
      CALL cl_err3("upd","gsb_file",g_gsb.gsb01,"",STATUS,"","upd gsbconf",1)  #No.FUN-660148
      SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = l_gsb01_old
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_success='N' THEN
      SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = l_gsb01_old
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
      CALL cl_flow_notify(g_gsb.gsb01,'Y')
      CALL cl_cmmsg(1)
   END IF
 
   SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = l_gsb01_old
   DISPLAY g_gsb.gsbconf TO gsbconf
   CALL cl_set_field_pic(g_gsb.gsbconf,"","","","N","")   #MOD-AC0073
 
END FUNCTION
 
FUNCTION t600_firm2()
   DEFINE l_gsb01_old LIKE gsb_file.gsb01
 
   LET l_gsb01_old=g_gsb.gsb01    # backup old key value gsb01
   LET g_success='Y'
 
   IF g_gsb.gsbconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
 
   IF g_gsb.gsbconf='N' THEN
      RETURN
   END IF
 
   #-----No.FUN-590111-----
   SELECT COUNT(*) INTO g_cnt FROM gsc_file
    WHERE gsc01 = g_gsb.gsb01
   IF g_cnt != 0 THEN
      CALL cl_err('','anm-242',1)
      RETURN
   END IF
   #-----No.FUN-590111 END-----
 
  #str MOD-860085 add
  #檢核投資單號若存在於gsh03時,需卡住不可取消確認
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM gsh_file
    WHERE gsh03 = g_gsb.gsb01
   IF g_cnt != 0 THEN
      CALL cl_err('','anm-660',1)
      RETURN
   END IF
  #end MOD-860085 add

#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end-------------------------- 
   #-->立帳日期不可小於關帳日期
   IF g_gsb.gsb03 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_gsb.gsb01,'aap-176',1)
      RETURN
   END IF
 
   IF NOT cl_sure(20,20) THEN
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t600_cl USING g_gsb.gsb01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t600_cl INTO g_gsb.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE gsb_file SET gsbconf = 'N' WHERE gsb01 = g_gsb.gsb01
   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#     CALL cl_err('upd gsbconf',STATUS,1)   #No.FUN-660148
      CALL cl_err3("upd","gsb_file",g_gsb.gsb01,"",STATUS,"","upd gsbconf",1)  #No.FUN-660148
      SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = l_gsb01_old
      ROLLBACK WORK
      RETURN
   END IF
 
   IF g_success='N' THEN
      SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = l_gsb01_old
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
      CALL cl_cmmsg(1)
   END IF
 
   SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01 = l_gsb01_old
   DISPLAY g_gsb.gsbconf TO gsbconf
 
END FUNCTION
 
FUNCTION t600_cost()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_gsb.gsbconf = 'X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_gsb.gsb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01=g_gsb.gsb01
   LET g_chr='u'
   IF g_gsb.gsbacti ='N' OR g_gsb.gsbconf='Y' THEN
      LET g_chr='d'
   END IF
   CALL anmt600_s(g_gsb.gsb01,g_chr)
END FUNCTION
 
FUNCTION t600_m()
 
   IF NOT cl_null(g_gsb.gsb01) THEN
      LET g_msg="anmt601 '" ,g_gsb.gsb01,"' "
      #CALL cl_cmdrun(g_msg)      #FUN-660216 remark
      CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
   END IF
 
END FUNCTION
 
#FUNCTION t600_x() #FUN-D20035 Mark
FUNCTION t600_x(p_type) #FUN-D20035 add
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_gsb.* FROM gsb_file WHERE gsb01=g_gsb.gsb01
   IF g_gsb.gsb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_gsb.gsbconf = 'Y' THEN
      CALL cl_err('',9023,0)
      RETURN
   END IF
   #FUN-D20035---begin 
   IF p_type = 1 THEN 
      IF g_gsb.gsbconf='X' THEN RETURN END IF
   ELSE
      IF g_gsb.gsbconf<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20035---end   
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t600_cl USING g_gsb.gsb01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_gsb.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gsb.gsb01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   #-->作廢轉換01/08/16
  
   IF cl_void(0,0,g_gsb.gsbconf)  THEN 
      LET g_chr=g_gsb.gsbconf
      IF g_gsb.gsbconf ='N' THEN
         LET g_gsb.gsbconf='X'
      ELSE
         LET g_gsb.gsbconf='N'
      END IF
 
      UPDATE gsb_file SET gsbconf =g_gsb.gsbconf,gsbmodu=g_user,gsbdate=TODAY
       WHERE gsb01 = g_gsb.gsb01
      IF STATUS THEN
#        CALL cl_err('upd gsbconf:',STATUS,1)   #No.FUN-660148
         CALL cl_err3("upd","gsb_file",g_gsb.gsb01,"",STATUS,"","upd gsbconf:",1)  #No.FUN-660148
         LET g_success='N'
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
         CALL cl_flow_notify(g_gsb.gsb01,'V')
      ELSE
         ROLLBACK WORK
      END IF
      SELECT gsbconf INTO g_gsb.gsbconf FROM gsb_file
       WHERE gsb01 = g_gsb.gsb01
      DISPLAY BY NAME g_gsb.gsbconf
   END IF
END FUNCTION
 
FUNCTION t600_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("gsb01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("gsb01",FALSE)
    END IF
 
END FUNCTION
 
 

