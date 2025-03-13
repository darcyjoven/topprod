# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: ammt400.4gl
# Descriptions...: 額外領料維護作業
# Date & Author..: 01/01/29 By Chien
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.MOD-4A0248 04/10/18 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0036 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-550054 05/05/28 By wujie   單據編號加大
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/18 By jamie 判斷imaacti
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0"
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-710063 07/01/17 By xufeng  查詢多筆資料時，刪除非最后一筆資料后未顯示下一筆        
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/06 By TSD.liquor 自定欄位功能修改
# Modify.........: No.FUN-980004 09/08/28 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-AA0048 10/10/22 By Carrier GP5.2架构下仓库权限修改
# Modify.........: No.FUN-AA0059 10/11/02 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/11/02 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-BB0086 11/11/30 By tanxc 增加數量欄位小數取位 
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_mmm           RECORD LIKE mmm_file.*,       #異動報表內容單頭
    g_mmm_t         RECORD LIKE mmm_file.*,       #簽核等級 (舊值)
    g_mmm_o         RECORD LIKE mmm_file.*,       #簽核等級 (舊值)
    g_mmm01_t       LIKE mmm_file.mmm01,          #簽核等級 (舊值)
    g_mmm02_t       LIKE mmm_file.mmm02,          #簽核等級 (舊值)
    g_mml           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        mml021      LIKE mml_file.mml021,  #額外領料項次
        mml04       LIKE mml_file.mml04,   #料號
        ima02       LIKE ima_file.ima02,   #品名
        mml05       LIKE mml_file.mml05,   #發料數量
        mml06       LIKE mml_file.mml06,   #發料單位
        mml07       LIKE mml_file.mml07,   #倉庫
        mml08       LIKE mml_file.mml08,   #儲位
        mml09       LIKE mml_file.mml09,   #批號
        #FUN-840202 --start---
        mmlud01 LIKE mml_file.mmlud01,
        mmlud02 LIKE mml_file.mmlud02,
        mmlud03 LIKE mml_file.mmlud03,
        mmlud04 LIKE mml_file.mmlud04,
        mmlud05 LIKE mml_file.mmlud05,
        mmlud06 LIKE mml_file.mmlud06,
        mmlud07 LIKE mml_file.mmlud07,
        mmlud08 LIKE mml_file.mmlud08,
        mmlud09 LIKE mml_file.mmlud09,
        mmlud10 LIKE mml_file.mmlud10,
        mmlud11 LIKE mml_file.mmlud11,
        mmlud12 LIKE mml_file.mmlud12,
        mmlud13 LIKE mml_file.mmlud13,
        mmlud14 LIKE mml_file.mmlud14,
        mmlud15 LIKE mml_file.mmlud15
        #FUN-840202 --end--
                    END RECORD,
    g_mml_t         RECORD                 #程式變數 (舊值)
        mml021      LIKE mml_file.mml021,  #額外領料項次
        mml04       LIKE mml_file.mml04,   #料號
        ima02       LIKE ima_file.ima02,   #品名
        mml05       LIKE mml_file.mml05,   #發料數量
        mml06       LIKE mml_file.mml06,   #發料單位
        mml07       LIKE mml_file.mml07,   #倉庫
        mml08       LIKE mml_file.mml08,   #儲位
        mml09       LIKE mml_file.mml09,   #批號
        #FUN-840202 --start---
        mmlud01 LIKE mml_file.mmlud01,
        mmlud02 LIKE mml_file.mmlud02,
        mmlud03 LIKE mml_file.mmlud03,
        mmlud04 LIKE mml_file.mmlud04,
        mmlud05 LIKE mml_file.mmlud05,
        mmlud06 LIKE mml_file.mmlud06,
        mmlud07 LIKE mml_file.mmlud07,
        mmlud08 LIKE mml_file.mmlud08,
        mmlud09 LIKE mml_file.mmlud09,
        mmlud10 LIKE mml_file.mmlud10,
        mmlud11 LIKE mml_file.mmlud11,
        mmlud12 LIKE mml_file.mmlud12,
        mmlud13 LIKE mml_file.mmlud13,
        mmlud14 LIKE mml_file.mmlud14,
        mmlud15 LIKE mml_file.mmlud15
        #FUN-840202 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        #No.FUN-680100
    g_rec_b         LIKE type_file.num5,                    #單身筆數        #No.FUN-680100 SMALLINT
    g_cmd           LIKE type_file.chr1000,                 #No.FUN-680100 VARCHAR(100)
    l_ac            LIKE type_file.num5                      #目前處理的ARRAY CNT        #No.FUN-680100 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL  #No.FUN-680100
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680100 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680100 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680100 SMALLINT
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0076
    p_row,p_col   LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
   LET p_row = 2 LET p_col = 8
   OPEN WINDOW t400_w AT p_row,p_col
     WITH FORM "amm/42f/ammt400"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
   LET g_forupd_sql = "SELECT * FROM mmm_file WHERE mmm01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t400_cl CURSOR FROM g_forupd_sql
 
   CALL t400_menu()
   CLOSE WINDOW t400_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
#QBE 查詢資料
FUNCTION t400_cs()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE m_mmb131         LIKE type_file.chr1000 #No.FUN-680100 VARCHAR(80)
 
   CLEAR FORM                             #清除畫面
   CALL g_mml.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_mmm.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON mmm01,mmm02,mmb131,mmm03,mmm07,mmm04,mmm08,mmm05,mmm06,
                             #FUN-840202   ---start---
                             mmmud01,mmmud02,mmmud03,mmmud04,mmmud05,
                             mmmud06,mmmud07,mmmud08,mmmud09,mmmud10,
                             mmmud11,mmmud12,mmmud13,mmmud14,mmmud15
                             #FUN-840202    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
      AFTER FIELD mmb131
         LET m_mmb131 = GET_FLDBUF(mmb131)
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(mmm01) #查詢單据
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_mmb"
                 LET g_qryparam.default1 = g_mmm.mmm01
                 LET g_qryparam.default2 = g_mmm.mmm02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO mmm01
                 NEXT FIELD mmm01
                #------No.MOD-4A0248------
               WHEN INFIELD(mmm03) #部門代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form     = "q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO mmm03
                 NEXT FIELD mmm03
               #------END----------------
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
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND mmmuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND mmmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND mmmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmmuser', 'mmmgrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON mml021,mml04,mml05,mml06,mml07,mml08,mml09
                      #No.FUN-840202 --start--
                      ,mmlud01,mmlud02,mmlud03,mmlud04,mmlud05
                      ,mmlud06,mmlud07,mmlud08,mmlud09,mmlud10
                      ,mmlud11,mmlud12,mmlud13,mmlud14,mmlud15
                      #No.FUN-840202 ---end---
                 FROM s_mml[1].mml021,s_mml[1].mml04,s_mml[1].mml05,
                      s_mml[1].mml06,s_mml[1].mml07,s_mml[1].mml08,s_mml[1].mml09
                      #No.FUN-840202 --start--
                      ,s_mml[1].mmlud01,s_mml[1].mmlud02,s_mml[1].mmlud03,s_mml[1].mmlud04,s_mml[1].mmlud05
                      ,s_mml[1].mmlud06,s_mml[1].mmlud07,s_mml[1].mmlud08,s_mml[1].mmlud09,s_mml[1].mmlud10
                      ,s_mml[1].mmlud11,s_mml[1].mmlud12,s_mml[1].mmlud13,s_mml[1].mmlud14,s_mml[1].mmlud15
                      #No.FUN-840202 ---end---
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   MESSAGE " WAIT "
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      IF cl_null(m_mmb131) THEN
         LET g_sql = "SELECT  mmm01, mmm02 FROM mmm_file ",
                     " WHERE ", g_wc CLIPPED,
                     " ORDER BY mmm01"
      ELSE
         LET g_sql = "SELECT  mmm01, mmm02 ",
                     " FROM mmm_file,mmb_file ",
                     " WHERE ", g_wc CLIPPED,
                     "   AND mmb01 = mmm01 ",
                     "   AND mmb02 = mmm02 ",
                     " ORDER BY mmm01"
      END IF
   ELSE                              # 若單身有輸入條件
      IF cl_null(m_mmb131) THEN
         LET g_sql = "SELECT DISTINCT  mmm01, mmm02 ",
                     "  FROM mmm_file, mml_file ",
                     " WHERE mmm01 = mml01",
                     "   AND mmm02 = mml02",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     " ORDER BY mmm01"
      ELSE
         LET g_sql = "SELECT DISTINCT  mmm01, mmm02 ",
                     "  FROM mmm_file, mml_file, mmb_file ",
                     " WHERE mmm01 = mml01",
                     "   AND mmm02 = mml02",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND mmb01 = mmm01 ",
                     "   AND mmb02 = mmm02 ",
                     " ORDER BY mmm01"
      END IF
   END IF
   PREPARE t400_prepare FROM g_sql
   DECLARE t400_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t400_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      IF cl_null(m_mmb131) THEN
         LET g_sql="SELECT COUNT(*) FROM mmm_file WHERE ",g_wc CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(*) FROM mmm_file,mmb_file ",
                   " WHERE ",g_wc CLIPPED,
                   "   AND mmb01 = mmm01 ",
                   "   AND mmb02 = mmm02 "
      END IF
   ELSE
      IF cl_null(m_mmb131) THEN
         LET g_sql="SELECT COUNT(DISTINCT mmm01) FROM mmm_file,mml_file WHERE ",
                   "mml01=mmm01 AND mml02 = mmm02 AND ",g_wc CLIPPED,
                   " AND ",g_wc2 CLIPPED
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT mmm01) ",
                   " FROM mmm_file,mml_file,mmb_file WHERE ",
                   "mml01=mmm01 AND mml02 = mmm02 AND ",g_wc CLIPPED,
                   " AND ",g_wc2 CLIPPED,
                   " AND mmb01 = mmm01 ",
                   " AND mmb02 = mmm02 "
      END IF
   END IF
   PREPARE t400_precount FROM g_sql
   DECLARE t400_count CURSOR FOR t400_precount
 
END FUNCTION
 
FUNCTION t400_menu()
 
   WHILE TRUE
      CALL t400_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t400_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t400_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t400_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t400_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t400_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "post"
            IF cl_chk_act_auth() THEN
               LET g_cmd = "ammp300 '",g_mmm.mmm01,"'"
               #CALL cl_cmdrun(g_cmd)      #FUN-660216 remark
               CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
            END IF
         WHEN "exporttoexcel"     #FUN-4B0036
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mml),'','')
            END IF
         #No.FUN-6B0079-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_mmm.mmm01 IS NOT NULL THEN
                LET g_doc.column1 = "mmm01"
                LET g_doc.column2 = "mmm02"
                LET g_doc.value1 = g_mmm.mmm01
                LET g_doc.value2 = g_mmm.mmm02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6B0079-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t400_a()
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_mml.clear()
   INITIALIZE g_mmm.* LIKE mmm_file.*             #DEFAULT 設定
   LET g_mmm01_t = NULL
   LET g_mmm02_t = NULL
   #預設值及將數值類變數清成零
   LET g_mmm_o.* = g_mmm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_mmm.mmm04   = g_today
      LET g_mmm.mmm08   = 0
      LET g_mmm.mmm06   = 'N'
      LET g_mmm.mmmuser = g_user
      LET g_data_plant = g_plant #FUN-980030
      LET g_mmm.mmmgrup = g_grup
      LET g_mmm.mmmdate = g_today
      LET g_mmm.mmmacti = 'Y'         #資料有效
      LET g_mmm.mmmplant = g_plant #FUN-980004 add
      LET g_mmm.mmmlegal = g_legal #FUN-980004 add
 
      CALL t400_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_mmm.mmm01 IS NULL OR g_mmm.mmm02 IS NULL THEN    # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      LET g_mmm.mmmoriu = g_user      #No.FUN-980030 10/01/04
      LET g_mmm.mmmorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO mmm_file VALUES (g_mmm.*)
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#         CALL cl_err(g_mmm.mmm01,SQLCA.sqlcode,1) #No.FUN-660094
          CALL cl_err3("ins","mmm_file",g_mmm.mmm01,g_mmm.mmm02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
         CONTINUE WHILE
      END IF
 
      LET g_mmm_t.* = g_mmm.*
      LET g_rec_b =0                  #NO.FUN-680064   
      CALL t400_b()                   #輸入單身
 
      SELECT mmm01 INTO g_mmm.mmm01 FROM mmm_file
       WHERE mmm01 = g_mmm.mmm01
         AND mmm02 = g_mmm.mmm02
      LET g_mmm01_t = g_mmm.mmm01        #保留舊值
      LET g_mmm02_t = g_mmm.mmm02        #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION t400_u()
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   IF g_mmm.mmm01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_mmm.* FROM mmm_file
    WHERE mmm01 = g_mmm.mmm01
      AND mmm02 = g_mmm.mmm02
 
   IF g_mmm.mmmacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_mmm.mmm01,9027,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_mmm01_t = g_mmm.mmm01
   LET g_mmm02_t = g_mmm.mmm02
   LET g_mmm_o.* = g_mmm.*
   BEGIN WORK
 
   OPEN t400_cl USING g_mmm.mmm01
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t400_cl INTO g_mmm.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_mmm.mmm01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t400_cl
       RETURN
   END IF
 
   CALL t400_show()
 
   WHILE TRUE
      LET g_mmm01_t = g_mmm.mmm01
      LET g_mmm02_t = g_mmm.mmm02
      LET g_mmm.mmmmodu=g_user
      LET g_mmm.mmmdate=g_today
 
      CALL t400_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_mmm.*=g_mmm_t.*
         CALL t400_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_mmm.mmm01 != g_mmm01_t OR g_mmm.mmm02 != g_mmm02_t THEN  #更改單號
         UPDATE mmm_file SET mmm01 = g_mmm.mmm01,
                             mmm02 = g_mmm.mmm02
          WHERE mmm01 = g_mmm01_t
            AND mmm02 = g_mmm02_t
         IF SQLCA.sqlcode THEN
#            CALL cl_err('mmm',SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("upd","mmm_file",g_mmm01_t,g_mmm02_t,SQLCA.SQLCODE,"","mmm",1)       #NO.FUN-660094
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE mmm_file SET mmm_file.* = g_mmm.*
       WHERE mmm01 = g_mmm.mmm01
      IF SQLCA.sqlcode THEN
#         CALL cl_err(g_mmm.mmm01,SQLCA.sqlcode,0) #No.FUN-660094
          CALL cl_err3("upd","mmm_file",g_mmm01_t,g_mmm02_t,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE t400_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION t400_i(p_cmd)
DEFINE
   l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680100 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改                 #No.FUN-680100 VARCHAR(1)
   l_mmb           RECORD LIKE mmb_file.*
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_mmm.mmm01,g_mmm.mmm02,g_mmm.mmm03,g_mmm.mmm07,g_mmm.mmm04,
                 g_mmm.mmm08,g_mmm.mmm05,g_mmm.mmm06,
                 #FUN-840202     ---start---
                 g_mmm.mmmud01,g_mmm.mmmud02,g_mmm.mmmud03,g_mmm.mmmud04,
                 g_mmm.mmmud05,g_mmm.mmmud06,g_mmm.mmmud07,g_mmm.mmmud08,
                 g_mmm.mmmud09,g_mmm.mmmud10,g_mmm.mmmud11,g_mmm.mmmud12,
                 g_mmm.mmmud13,g_mmm.mmmud14,g_mmm.mmmud15 
                 #FUN-840202     ----end----
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t400_set_entry(p_cmd)
         CALL t400_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
#No.FUN-550054--begin
         CALL cl_set_docno_format("mmm01")
#No.FUn-550054--end
 
      AFTER FIELD mmm02
         IF NOT cl_null(g_mmm.mmm02) THEN
            IF g_mmm.mmm01 != g_mmm_t.mmm01 OR
              (g_mmm.mmm01 IS NOT NULL AND g_mmm_t.mmm01 IS NULL) OR
               g_mmm.mmm02 != g_mmm_t.mmm02 OR
              (g_mmm.mmm02 IS NOT NULL AND g_mmm_t.mmm02 IS NULL) THEN
               LET g_cnt=0
               SELECT COUNT(*) INTO g_cnt FROM mmm_file
                WHERE mmm01 = g_mmm.mmm01
                  AND mmm02 = g_mmm.mmm02
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  NEXT FIELD mmm01
               END IF
               SELECT * INTO l_mmb.* FROM mmb_file
                WHERE mmb01 = g_mmm.mmm01
                  AND mmb02 = g_mmm.mmm02
               IF STATUS THEN
 #                 CALL cl_err('','amm-023',0) #No.FUN-660094
                   CALL cl_err3("sel","mmb_file",g_mmm.mmm01,g_mmm.mmm02,"amm-023","","",1)       #NO.FUN-660094
                  NEXT FIELD mmm01
               END IF
               IF l_mmb.mmb14 = 'Y' THEN
                  CALL cl_err('','amm-042',0)
                  NEXT FIELD mmm01
               ELSE
                  IF l_mmb.mmb13 = '2' THEN
                     CALL cl_err('','amm-043',0)
                  ELSE
                     IF l_mmb.mmbacti = 'Y' THEN
                        CALL cl_err('','amm-044',0)
                     ELSE
                        CALL cl_err('','amm-045',0)
                     END IF
                     NEXT FIELD mmm01
                  END IF
               END IF
               LET g_mmm.mmm07 = l_mmb.mmb05
               DISPLAY BY NAME g_mmm.mmm07
               DISPLAY l_mmb.mmb131 TO mmb131
            END IF
         END IF
 
      AFTER FIELD mmm03
         IF NOT cl_null(g_mmm.mmm03) THEN
            CALL t400_mmm03()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_mmm.mmm03,'aap-039',0)
               LET g_mmm.mmm03 =g_mmm_t.mmm03
               DISPLAY BY NAME g_mmm.mmm03
               NEXT FIELD mmm03
            END IF
         END IF
 
      AFTER FIELD mmm08
         IF NOT cl_null(g_mmm.mmm08) THEN
            IF g_mmm.mmm08 < 0 THEN
               NEXT FIELD mmm08
            END IF
         END IF
 
      #FUN-840202     ---start---
      AFTER FIELD mmmud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmmud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840202     ----end----
 
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_mmm.mmm01 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_mmm.mmm01
         END IF
         IF g_mmm.mmm02 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_mmm.mmm02
         END IF
         IF g_mmm.mmm03 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_mmm.mmm03
         END IF
         IF g_mmm.mmm04 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_mmm.mmm04
         END IF
         IF g_mmm.mmm08 IS NULL THEN
            LET l_flag='Y'
            DISPLAY BY NAME g_mmm.mmm08
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD mmm01
         END IF
 
      ON ACTION controlp                  #欄位說明
         CASE WHEN INFIELD(mmm01)
                #CALL q_mmb(10,3,g_mmm.mmm01,'') RETURNING g_mmm.mmm01,g_mmm.mmm02
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_mmb"
                 LET g_qryparam.default1 = g_mmm.mmm01
                 LET g_qryparam.default2 = g_mmm.mmm02
                 CALL cl_create_qry() RETURNING g_mmm.mmm01,g_mmm.mmm02
#                 CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm01 )
#                 CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm02 )
                 DISPLAY BY NAME g_mmm.mmm01,g_mmm.mmm02
                 NEXT FIELD mmm01
              WHEN INFIELD(mmm02)
                #CALL q_mmb(10,3,g_mmm.mmm01,g_mmm.mmm02) RETURNING g_mmm.mmm01,g_mmm.mmm02
                #CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm01 )
                #CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm02 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_mmb"
                 LET g_qryparam.default1 = g_mmm.mmm01
                 LET g_qryparam.default2 = g_mmm.mmm02
                 CALL cl_create_qry() RETURNING g_mmm.mmm01,g_mmm.mmm02
#                 CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm01 )
#                 CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm02 )
                 DISPLAY BY NAME g_mmm.mmm01,g_mmm.mmm02
                 NEXT FIELD mmm02
              WHEN INFIELD(mmm03)
                #CALL q_gem(05,11,g_mmm.mmm03) RETURNING g_mmm.mmm03
                #CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gem"
                 LET g_qryparam.default1 = g_mmm.mmm03
                 CALL cl_create_qry() RETURNING g_mmm.mmm03
#                 CALL FGL_DIALOG_SETBUFFER( g_mmm.mmm03 )
                 DISPLAY BY NAME g_mmm.mmm03
                 NEXT FIELD mmm03
          END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON ACTION CONTROLZ
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
 
FUNCTION t400_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_mml.clear()
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL t400_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN t400_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_mmm.* TO NULL
   ELSE
      OPEN t400_count
      FETCH t400_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t400_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
 
END FUNCTION
 
FUNCTION t400_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680100 VARCHAR(1)
   l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680100 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t400_cs INTO g_mmm.mmm01,g_mmm.mmm02
      WHEN 'P' FETCH PREVIOUS t400_cs INTO g_mmm.mmm01,g_mmm.mmm02
      WHEN 'F' FETCH FIRST    t400_cs INTO g_mmm.mmm01,g_mmm.mmm02
      WHEN 'L' FETCH LAST     t400_cs INTO g_mmm.mmm01,g_mmm.mmm02
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
         FETCH ABSOLUTE g_jump t400_cs INTO g_mmm.mmm01,g_mmm.mmm02
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mmm.mmm01,SQLCA.sqlcode,0)
      INITIALIZE g_mmm.* TO NULL    #No.FUN-6B0079  add
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
 
   SELECT * INTO g_mmm.* FROM mmm_file WHERE mmm01 = g_mmm.mmm01
   IF SQLCA.sqlcode THEN
#      CALL cl_err(g_mmm.mmm01,SQLCA.sqlcode,0) #No.FUN-660094
       CALL cl_err3("sel","mmm_file",g_mmm.mmm01,g_mmm.mmm02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
      INITIALIZE g_mmm.* TO NULL
      RETURN
   END IF
 
   CALL t400_show()
 
END FUNCTION
 
FUNCTION t400_show()
DEFINE l_mmb131   LIKE mmb_file.mmb131
 
   LET g_mmm_t.* = g_mmm.*                #保存單頭舊值
   DISPLAY BY NAME g_mmm.mmm01,g_mmm.mmm02,g_mmm.mmm03,g_mmm.mmm07,g_mmm.mmm04,
                   g_mmm.mmm08,g_mmm.mmm05,g_mmm.mmm06,
                   #FUN-840202     ---start---
                   g_mmm.mmmud01,g_mmm.mmmud02,g_mmm.mmmud03,g_mmm.mmmud04,
                   g_mmm.mmmud05,g_mmm.mmmud06,g_mmm.mmmud07,g_mmm.mmmud08,
                   g_mmm.mmmud09,g_mmm.mmmud10,g_mmm.mmmud11,g_mmm.mmmud12,
                   g_mmm.mmmud13,g_mmm.mmmud14,g_mmm.mmmud15 
                   #FUN-840202     ----end----
 
   CALL t400_mmm03()
 
   SELECT mmb131 INTO l_mmb131 FROM mmb_file
    WHERE mmb01 = g_mmm.mmm01
      AND mmb02 = g_mmm.mmm02
 
   DISPLAY l_mmb131 TO mmb131
 
   CALL t400_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t400_r()
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   IF g_mmm.mmm01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t400_cl USING g_mmm.mmm01
   IF STATUS THEN
      CALL cl_err("OPEN t400_cl:", STATUS, 1)
      CLOSE t400_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t400_cl INTO g_mmm.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_mmm.mmm01,SQLCA.sqlcode,0)          #資料被他人LOCK
      RETURN
   END IF
 
   CALL t400_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "mmm01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "mmm02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_mmm.mmm01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_mmm.mmm02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM mmm_file
       WHERE mmm01 = g_mmm.mmm01
         AND mmm02 = g_mmm.mmm02
 
      DELETE FROM mml_file
       WHERE mml01 = g_mmm.mmm01
         AND mml02 = g_mmm.mmm02
 
      CLEAR FORM
      CALL g_mml.clear()
   END IF
 
   CLOSE t400_cl
   COMMIT WORK
    #No.TQC-710063  --begin
    OPEN t400_count                                                                                                                 
    #FUN-B50063-add-start--
    IF STATUS THEN
       CLOSE t400_cs
       CLOSE t400_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50063-add-end-- 
    FETCH t400_count INTO g_row_count                                                                                               
    #FUN-B50063-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE t400_cs
       CLOSE t400_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50063-add-end--
    DISPLAY g_row_count TO FORMONLY.cnt                                                                                             
    OPEN t400_cs                                                                                                                    
    IF g_curs_index = g_row_count + 1 THEN                                                                                          
       LET g_jump = g_row_count                                                                                                     
       CALL t400_fetch('L')                                                                                                         
    ELSE                                                                                                                            
       LET g_jump = g_curs_index                                                                                                    
       LET mi_no_ask = TRUE                                                                                                         
       CALL t400_fetch('/')                                                                                                         
    END IF             
    #No.TQC-710063  --begin
 
END FUNCTION
 
FUNCTION t400_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680100 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680100 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680100 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態        #No.FUN-680100 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680100 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680100 SMALLINT
 
   LET g_action_choice = ""
 
   IF s_ammshut(0) THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT mml021,mml04,'',mml05,mml06,mml07,",
                      "       mml08,mml09 FROM mml_file",
                      "  WHERE mml01 = ? AND mml02 = ?",
                      "   AND mml021= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t400_bcl CURSOR FROM g_forupd_sql      #LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_mml WITHOUT DEFAULTS FROM s_mml.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd = 'u'
            LET g_mml_t.* = g_mml[l_ac].*  #BACKUP
            OPEN t400_bcl USING g_mmm.mmm01,g_mmm.mmm02,g_mml_t.mml021
            IF STATUS THEN
               CALL cl_err("OPEN t400_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t400_bcl INTO g_mml[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_mml_t.mml021,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         NEXT FIELD mml021
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_mml[l_ac].* TO NULL      #900423
         LET g_mml_t.* = g_mml[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD mml021
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO mml_file(mml01,mml02,mml021,mml04,mml05,mml06,
                              mml07,mml08,mml09,
                              #FUN-840202 --start--
                              mmlud01,mmlud02,mmlud03,
                              mmlud04,mmlud05,mmlud06,
                              mmlud07,mmlud08,mmlud09,
                              mmlud10,mmlud11,mmlud12,
                              mmlud13,mmlud14,mmlud15,mmlplant,mmllegal  #FUN-980004 add mmlplant,mmllegal
                              #FUN-840202 --end--
                             )
              VALUES(g_mmm.mmm01,g_mmm.mmm02,g_mml[l_ac].mml021,
                     g_mml[l_ac].mml04,g_mml[l_ac].mml05,g_mml[l_ac].mml06,
                     g_mml[l_ac].mml07,g_mml[l_ac].mml08,g_mml[l_ac].mml09,
                     #FUN-840202 --start--
                     g_mml[l_ac].mmlud01, g_mml[l_ac].mmlud02,
                     g_mml[l_ac].mmlud03, g_mml[l_ac].mmlud04,
                     g_mml[l_ac].mmlud05, g_mml[l_ac].mmlud06,
                     g_mml[l_ac].mmlud07, g_mml[l_ac].mmlud08,
                     g_mml[l_ac].mmlud09, g_mml[l_ac].mmlud10,
                     g_mml[l_ac].mmlud11, g_mml[l_ac].mmlud12,
                     g_mml[l_ac].mmlud13, g_mml[l_ac].mmlud14,
                     g_mml[l_ac].mmlud15, g_plant,g_legal   #FUN-980004 add g_plant,g_legal
                     #FUN-840202 --end--
                    )
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_mml[l_ac].mml021,SQLCA.sqlcode,0) #No.FUN-660094
             CALL cl_err3("ins","mml_file",g_mmm.mmm01,g_mmm.mmm02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094    
            LET g_mml[l_ac].* = g_mml_t.*
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
            COMMIT WORK
         END IF
 
      BEFORE FIELD mml021                        #check 編號是否重複
         IF cl_null(g_mml[l_ac].mml021) THEN
            SELECT MAX(mml021)+ 1 INTO g_mml[l_ac].mml021
              FROM mml_file
             WHERE mml01 = g_mmm.mmm01
               AND mml02 = g_mmm.mmm02
            IF SQLCA.SQLCODE OR cl_null(g_mml[l_ac].mml021) THEN
               LET g_mml[l_ac].mml021 = 1
            END IF
         END IF
 
      AFTER FIELD mml04                        #發料料號
        #FUN-AA0059 -----------add start---------------
         IF NOT cl_null(g_mml[l_ac].mml04) THEN
            IF NOT s_chk_item_no(g_mml[l_ac].mml04,'') THEN
               CALL cl_err('',g_errno,1)
               LET g_mml[l_ac].mml04 = g_mml_t.mml04
               DISPLAY BY NAME g_mml[l_ac].mml04
               NEXT FIELD mml04
            END IF 
         END IF 
        #FUN-AA0059 -------------add end-----------------
         IF g_mml[l_ac].mml04 != g_mml_t.mml04 OR
            (g_mml[l_ac].mml04 IS NOT NULL AND g_mml_t.mml04 IS NULL) THEN
            CALL t400_mml04('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_mml[l_ac].mml04 = g_mml_t.mml04
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_mml[l_ac].mml04
               #------MOD-5A0095 END------------
               NEXT FIELD mml04
            END IF
         END IF
 
      AFTER FIELD mml05                        #數量
         IF NOT cl_null(g_mml[l_ac].mml05) THEN
            IF g_mml[l_ac].mml05 <= 0 THEN
               NEXT FIELD mml05
            END IF
            #No.FUN-BB0086--add--begin--
            LET g_mml[l_ac].mml05 = s_digqty(g_mml[l_ac].mml05,g_mml[l_ac].mml06)  
            DISPLAY BY NAME g_mml[l_ac].mml05
            #No.FUN-BB0086--add--end-- 
         END IF

 
      AFTER FIELD mml07                        #倉庫
         IF NOT cl_null(g_mml[l_ac].mml07) THEN
            SELECT imd02 FROM imd_file
             WHERE imd01= g_mml[l_ac].mml07
               AND imdacti='Y'
            IF SQLCA.SQLCODE <> 0 THEN
#               CALL cl_err('','mfg4020',0) #No.FUN-660094
                CALL cl_err3("sel","imd_file",g_mml[l_ac].mml07,"","mfg4020","","",1)       #NO.FUN-660094 
               NEXT FIELD mml07
            END IF
            #No.FUN-AA0048  --Begin
            IF NOT s_chk_ware(g_mml[l_ac].mml07) THEN
               NEXT FIELD mml07
            END IF
            #No.FUN-AA0048  --End  
         END IF
 
      AFTER FIELD mml08                        #儲位
         IF cl_null(g_mml[l_ac].mml08) THEN
            LET g_mml[l_ac].mml08 =' '
         END IF
 
      AFTER FIELD mml09                        #批號
         IF cl_null(g_mml[l_ac].mml09) THEN
            LET g_mml[l_ac].mml09 =' '
         END IF
 
      #No.FUN-840202 --start--
      AFTER FIELD mmlud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD mmlud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #No.FUN-840202 ---end---
 
 
      BEFORE DELETE                            #是否取消單身
         IF g_mml_t.mml021 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM mml_file
             WHERE mml01  = g_mmm.mmm01
               AND mml02  = g_mmm.mmm02
               AND mml021 = g_mml_t.mml021
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_mml_t.mml021,SQLCA.sqlcode,0) #No.FUN-660094
                CALL cl_err3("del","mml_file",g_mmm.mmm01,g_mmm.mmm02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094 
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
            LET g_mml[l_ac].* = g_mml_t.*
            CLOSE t400_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mml[l_ac].mml021,-263,1)
            LET g_mml[l_ac].* = g_mml_t.*
         ELSE
            UPDATE mml_file SET mml021=g_mml[l_ac].mml021,
                                mml04=g_mml[l_ac].mml04,
                                mml05=g_mml[l_ac].mml05,
                                mml06=g_mml[l_ac].mml06,
                                mml07=g_mml[l_ac].mml07,
                                mml08=g_mml[l_ac].mml08,
                                mml09=g_mml[l_ac].mml09,
                                #FUN-840202 --start--
                                mmlud01 = g_mml[l_ac].mmlud01,
                                mmlud02 = g_mml[l_ac].mmlud02,
                                mmlud03 = g_mml[l_ac].mmlud03,
                                mmlud04 = g_mml[l_ac].mmlud04,
                                mmlud05 = g_mml[l_ac].mmlud05,
                                mmlud06 = g_mml[l_ac].mmlud06,
                                mmlud07 = g_mml[l_ac].mmlud07,
                                mmlud08 = g_mml[l_ac].mmlud08,
                                mmlud09 = g_mml[l_ac].mmlud09,
                                mmlud10 = g_mml[l_ac].mmlud10,
                                mmlud11 = g_mml[l_ac].mmlud11,
                                mmlud12 = g_mml[l_ac].mmlud12,
                                mmlud13 = g_mml[l_ac].mmlud13,
                                mmlud14 = g_mml[l_ac].mmlud14,
                                mmlud15 = g_mml[l_ac].mmlud15
                                #FUN-840202 --end-- 
             WHERE mml01 = g_mmm.mmm01
               AND mml02 = g_mmm.mmm02
               AND mml021= g_mml_t.mml021
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_mml[l_ac].mml021,SQLCA.sqlcode,0) #No.FUN-660094
                CALL cl_err3("upd","mml_file",g_mmm.mmm01,g_mmm.mmm02,SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
               LET g_mml[l_ac].* = g_mml_t.*
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
            IF p_cmd = 'u' THEN
               LET g_mml[l_ac].* = g_mml_t.*
            #FUN-D40030--add--str--
            ELSE
               CALL g_mml.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030--add--end--
            END IF
            CLOSE t400_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D40030 Add
         CLOSE t400_bcl
         COMMIT WORK
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(mml04)
              #CALL q_ima(10,3,g_mml[l_ac].mml04) RETURNING g_mml[l_ac].mml04
              #CALL FGL_DIALOG_SETBUFFER( g_mml[l_ac].mml04 )
#FUN-AA0059 --Begin--
            #   CALL cl_init_qry_var()
            #   LET g_qryparam.form     ="q_ima"
            #   LET g_qryparam.default1 = g_mml[l_ac].mml04
            #   CALL cl_create_qry() RETURNING g_mml[l_ac].mml04
                CALL q_sel_ima(FALSE, "q_ima", "", g_mml[l_ac].mml04, "", "", "", "" ,"",'' )  RETURNING g_mml[l_ac].mml04
#FUN-AA0059 --End--
#               CALL FGL_DIALOG_SETBUFFER( g_mml[l_ac].mml04 )
                DISPLAY BY NAME g_mml[l_ac].mml04           #No.MOD-490371
               CALL t400_mml04('a')
               NEXT FIELD mml04
            WHEN INFIELD(mml07)
               #No.FUN-AA0048  --Begin
               #CALL cl_init_qry_var()
               #LET g_qryparam.form     = "q_imd"
               #LET g_qryparam.default1 = g_mml[l_ac].mml07
               #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
               #CALL cl_create_qry() RETURNING g_mml[l_ac].mml07
               CALL q_imd_1(FALSE,TRUE,g_mml[l_ac].mml07,"","","","") RETURNING g_mml[l_ac].mml07
               #No.FUN-AA0048  --End  
               DISPLAY BY NAME g_mml[l_ac].mml07           #No.MOD-490371
               NEXT FIELD mml07                            #No.MOD-490371
            WHEN INFIELD(mml08)
              #CALL q_ime(10,3,g_mml[l_ac].mml07,g_mml[l_ac].mml08,'A') RETURNING g_mml[l_ac].mml08
              #CALL FGL_DIALOG_SETBUFFER( g_mml[l_ac].mml08 )
               CALL cl_init_qry_var()
               LET g_qryparam.form     ="q_ime"
                LET g_qryparam.default1 = g_mml[l_ac].mml08 #MOD-4A0063
                LET g_qryparam.arg1     = g_mml[l_ac].mml07 #倉庫編號 #MOD-4A0063
                LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
               #MOD-4A0063 MARK
              #LET g_qryparam.arg1     = g_mml[l_ac].mml08
              #LET g_qryparam.arg2     = "A"
              #IF g_qryparam.arg2 != 'A' THEN
              #   LET g_qryparam.where = g_qryparam.where CLIPPED, " AND ime04='",g_qryparam.arg2,"'"
              #END IF
              #LET g_qryparam.where = g_qryparam.where CLIPPED, " ORDER BY ime02"
               CALL cl_create_qry() RETURNING g_mml[l_ac].mml08
#               CALL FGL_DIALOG_SETBUFFER( g_mml[l_ac].mml08 )
                DISPLAY BY NAME g_mml[l_ac].mml08           #No.MOD-490371
                NEXT FIELD mml08                            #No.MOD-490371
            OTHERWISE
               EXIT CASE
          END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(mml01) AND l_ac > 1 THEN
            LET g_mml[l_ac].* = g_mml[l_ac-1].*
            NEXT FIELD mml01
         END IF
 
      ON ACTION CONTROLZ
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
 
   CLOSE t400_bcl
   COMMIT WORK
   CALL t400_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t400_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM mmm_file WHERE mmm01 = g_mmm.mmm01
                                AND mmm02 = g_mmm.mmm02
         INITIALIZE g_mmm.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t400_b_askkey()
 
   CLEAR FORM
   CALL g_mml.clear()
 
   CONSTRUCT g_wc2 ON mml021,mml04,mml05,mml06,mml07,mml08,mml09
                      #No.FUN-840202 --start--
                      ,mmlud01,mmlud02,mmlud03,mmlud04,mmlud05
                      ,mmlud06,mmlud07,mmlud08,mmlud09,mmlud10
                      ,mmlud11,mmlud12,mmlud13,mmlud14,mmlud15
                      #No.FUN-840202 ---end---
           FROM s_mml[1].mml021,s_mml[1].mml04,s_mml[1].mml05,s_mml[1].mml06,
                s_mml[1].mml07,s_mml[1].mml08,s_mml[1].mml09
                #No.FUN-840202 --start--
                ,s_mml[1].mmlud01,s_mml[1].mmlud02,s_mml[1].mmlud03,s_mml[1].mmlud04,s_mml[1].mmlud05
                ,s_mml[1].mmlud06,s_mml[1].mmlud07,s_mml[1].mmlud08,s_mml[1].mmlud09,s_mml[1].mmlud10
                ,s_mml[1].mmlud11,s_mml[1].mmlud12,s_mml[1].mmlud13,s_mml[1].mmlud14,s_mml[1].mmlud15
                #No.FUN-840202 ---end---
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
 
   CALL t400_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION t400_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2          LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(200)
 
   LET g_sql = "SELECT mml021,mml04,ima02,mml05,",
               "       mml06,mml07,mml08,mml09, ",
               #No.FUN-840202 --start--
               "       mmlud01,mmlud02,mmlud03,mmlud04,mmlud05,",
               "       mmlud06,mmlud07,mmlud08,mmlud09,mmlud10,",
               "       mmlud11,mmlud12,mmlud13,mmlud14,mmlud15", 
               #No.FUN-840202 ---end---
               "  FROM mml_file LEFT OUTER JOIN ima_file ON mml04=ima_file.ima01",
               " WHERE mml01 = '",g_mmm.mmm01,"'",
               "   AND mml02 = '",g_mmm.mmm02,"'",
               "   AND  ", p_wc2 CLIPPED,
               " ORDER BY 1"
   PREPARE t400_pb FROM g_sql
   DECLARE mml_curs CURSOR FOR t400_pb
 
   LET g_cnt = 1
   MESSAGE "Searching!"
   FOREACH mml_curs INTO g_mml[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_mml.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t400_mmm03()    #部門
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
         l_gem02     LIKE gem_file.gem02,
         l_gemacti   LIKE gem_file.gemacti
 
  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
   WHERE gem01=g_mmm.mmm03
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                 LET l_gem02 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028' LET l_gem02 = NULL
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  DISPLAY l_gem02 TO FORMONLY.gem02
 
END FUNCTION
 
FUNCTION t400_mml04(p_cmd)     #料件編號
DEFINE l_ima02 LIKE ima_file.ima02,
       l_ima021 LIKE ima_file.ima021,
       l_ima35  LIKE ima_file.ima35,
       l_ima36  LIKE ima_file.ima36,
       l_ima63  LIKE ima_file.ima63,
       l_imaacti LIKE ima_file.imaacti,
       p_no      LIKE type_file.chr4,         #No.FUN-680100 VARCHAR(04)
       p_cmd     LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   LET g_errno = " "
 
   SELECT ima02,ima021,ima35,ima36,ima63,imaacti
     INTO l_ima02,l_ima021,l_ima35,l_ima36,l_ima63,l_imaacti
     FROM ima_file
    WHERE ima01 = g_mml[l_ac].mml04
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                  LET l_ima02 = NULL  LET l_imaacti = NULL
                                  LET l_ima021= NULL
        WHEN l_imaacti='N'        LET g_errno = '9028'
      #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
      #FUN-690022------mod-------        
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd='a' THEN
      LET g_mml[l_ac].mml06 = l_ima63
      #No.FUN-BB0086--add--begin--
      LET g_mml[l_ac].mml05 = s_digqty(g_mml[l_ac].mml05,g_mml[l_ac].mml06)
      DISPLAY BY NAME g_mml[l_ac].mml05
      #No.FUN-BB0086--add--end--
      LET g_mml[l_ac].mml07 = l_ima35
      LET g_mml[l_ac].mml08 = l_ima36
   END IF

   LET g_mml[l_ac].ima02 = l_ima02
 
END FUNCTION
 
FUNCTION t400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mml TO s_mml.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t400_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t400_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t400_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t400_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t400_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
#@    ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
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
 
      ON ACTION exporttoexcel       #FUN-4B0036
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------    
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t400_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("mmm01,mmm02",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t400_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("mmm01,mmm02",FALSE)
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <003> #
