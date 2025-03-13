# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axci001.4gl
# Descriptions...: 人工分攤權數設定作業,製費分攤權數設定作業
# Date & Author..: 06/06/16 By Sarah
# Modify.........: No.FUN-660103 06/06/16 By Sarah 新增"人工分攤權數設定作業,製費分攤權數設定作業"
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660201 06/06/29 By Sarah 當分攤比率來源是2.科目餘額時,需檢查分攤來源科目不可空白 
# Modify.........: No.FUN-670065 06/07/19 By Sarah 新增批次產生功能
# Modify.........: No.FUN-670067 06/08/07 By Jackho voucher型報表轉template1 
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.TQC-6A0006 06/10/16 By Sarah 執行"產生"功能後,單身資料有誤
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0075 06/10/30 By xumin g_no_ask轉mi_no_ask
# Modify.........: No.FUN-6A0092 06/11/10 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720019 07/03/01 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730057 07/03/27 By bnlent  會計科目加帳套 
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-840021 08/04/08 By xiaofeizhu 將報表輸出改為CR
# Modify.........: No.FUN-920010 09/02/05 By jan 調整 整批產生 action
# Modify.........: No.FUN-920108 09/02/17 By jan axci001_g QBE 條件調整成按一次確定
# Modify.........: No.MOD-940386 09/04/30 By Pengu 再抓取會計科目時應加上aag07 <> '1' and aag03 ='2' 的條件
# Modify.........: No.FUN-950076 09/06/04 By jan 新增 整批復制 action
# Modify.........: No.TQC-970267 09/08/07 By liuxqa 將axci002調用的模版跟axci001調用的模版分開。否則會出問題。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Mofify.........: No.FUN-980020 09/09/03 By douzh 集團架構調整
# Modify.........: No.FUN-9A0049 09/11/16 By jan 新增'整批重算'action 
# Modify.........: No.FUN-9B0118 09/11/23 By Carrier 增加cay11帐套
# Modify.........: No.MOD-9C0193 09/12/18 By Carrier open cursor出错,传参顺序不对
# Modify.........: No:MOD-980103 09/12/22 By sabrina 複製時製費1~製費5時無法複製
# Modify.........: No:FUN-9C0112 09/12/22 By Carrier cay05比率变成权数
# Modify.........: No:FUN-9C0073 10/01/08 By chenls 程序精簡
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-AB0049 10/11/05 By sabrina 上期有製費3的資料，會有-239的錯誤
# Modify.........: No:FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:CHI-B30013 11/03/13 By Pengu 1.修改分攤方式在重新計算分攤比率時應先歸0
#                                                  2.計算分攤比例時應處理尾差
# Modify.........: No:FUN-B40004 11/04/06 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:MOD-B40236 11/04/26 By sabrina 在進入單身時要將g_action_choice清空
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B60130 11/06/15 By sabrina 同一部門的不同會科，可以用不同的方式分攤到不同的成本中心
# Modify.........: No:MOD-B60131 11/07/17 By Summer cay00做修改時無法修改成功
# Modify.........: No.TQC-B90005 11/09/01 By yinhy 單頭"成本中心"cay04"，axrs010中ccz06='2'時為必輸欄位，否則為選填欄位
# Modify.........: No:MOD-BA0056 11/10/11 By johung 修改AFTER FIELD mm1 對axci002的判斷與i001_t1相同
# Modify.........: No:MOD-C10040 12/01/05 By ck2yuan 不用限制分攤比例來源
# Modify.........: No:MOD-C20092 12/02/23 By Elise 修改新增一筆單身時會出現null值無法新增
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C60047 12/11/22 By bart 分攤比率來源(cay09)增加"4.生產數量、5.實際工時、6.實際機時、7.標準工時、8.標準機時"
# Modify.........: No:MOD-CC0159 12/12/26 By Elise 單頭的cay01/cay02為年度/期別，應用s_azm抓取
# Modify.........: No:MOD-D30086 13/03/11 By ck2yuan 用cl_set_comp_required控制欄位必輸否，非直接寫死在AFTER FIELD
# Modify.........: No:CHI-D20021 13/03/12 By bart axci001_g增加成本中心
# Modify.........: No:MOD-D30084 13/03/25 By ck2yuan axci002查詢與axci001一樣查詢方式
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_caya           RECORD LIKE cay_file.*,    #成本分攤比例檔
    g_caya_t         RECORD LIKE cay_file.*,    #成本分攤比例檔(舊值)
    g_cay00          LIKE cay_file.cay00,       #分攤類別 1.人工 2.製費 
    g_cay11          LIKE cay_file.cay11,       #帐套     #No.FUN-9B0118
    g_cay01          LIKE cay_file.cay01,       #年度
    g_cay02          LIKE cay_file.cay02,       #月份
    g_cay03          LIKE cay_file.cay03,       #部門編號
    g_cay06          LIKE cay_file.cay06,       #會計科目
    g_cay08          LIKE cay_file.cay08,       #部門屬性
    g_cay09          LIKE cay_file.cay09,       #分攤比率來源
    g_cay10          LIKE cay_file.cay10,       #分攤來源科目
    g_cay            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cay04        LIKE cay_file.cay04,       #成本中心
        gem02_b      LIKE gem_file.gem02,       #名稱
        cay12        LIKE cay_file.cay12,       #分摊方式   #No.FUN-9B0118
        cay05        LIKE cay_file.cay05,       #分攤比例
        cayacti      LIKE cay_file.cayacti      #有效否
                     END RECORD,
    g_cay_t          RECORD                     #程式變數 (舊值)
        cay04        LIKE cay_file.cay04,       #成本中心
        gem02_b      LIKE gem_file.gem02,       #名稱
        cay12        LIKE cay_file.cay12,       #分摊方式   #No.FUN-9B0118
        cay05        LIKE cay_file.cay05,       #分攤比例
        cayacti      LIKE cay_file.cayacti      #有效否
                     END RECORD,
    g_wc,g_wc2,g_sql STRING,  #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num5,                    #單身筆數                   #No.FUN-680122 SMALLINT
    l_ac             LIKE type_file.num5,                    #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    g_argv1          LIKE type_file.chr1                                                 #No.FUN-680122 VARCHAR(1)             #分攤類別
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ...  FOR UPDATE SQL
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_cnt           LIKE type_file.num10             #No.FUN-680122 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000           #No.FUN-680122 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10             #No.FUN-680122 INTEGER
DEFINE g_curs_index    LIKE type_file.num10             #No.FUN-680122 INTEGER
DEFINE g_jump          LIKE type_file.num10             #No.FUN-680122 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5              #No.FUN-680122 SMALLINT   #No.FUN-6A0075
DEFINE g_flag          LIKE type_file.chr1              #No.FUN-730057
DEFINE l_table         STRING,                          ### FUN-840021 ###                                                                  
       g_str           STRING                           ### FUN-840021 ###
DEFINE g_chr           LIKE type_file.chr1              #MOD-CC0159 add
 
MAIN
DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
 
   CASE g_argv1
      WHEN "1" LET g_prog ='axci001'
      WHEN "2" LET g_prog ='axci002'
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
 
   LET g_cay01= NULL
 
   LET p_row = 4 LET p_col = 15
   oPEN WINDOW i001_w AT p_row,p_col WITH FORM "axc/42f/axci001"    #顯示畫面
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * from cay_file WHERE cay00=? AND cay01=? AND cay02=? AND cay03=? AND cay04=? AND cay06=? AND cay11 = ? FOR UPDATE"  #No.FUN-9B0118
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_cl CURSOR FROM g_forupd_sql
 
   CALL i001_menu()
   CLOSE WINDOW i001_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION i001_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_cay.clear()
 
   CASE g_argv1
      WHEN "1" LET g_cay00 ='1'
   END CASE
   DISPLAY g_cay00 TO cay00
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_cay00 TO NULL    #No.FUN-750051
   INITIALIZE g_cay11 TO NULL    #No.FUN-9B0118
   INITIALIZE g_cay01 TO NULL    #No.FUN-750051
   INITIALIZE g_cay02 TO NULL    #No.FUN-750051
   INITIALIZE g_cay03 TO NULL    #No.FUN-750051
  #MOD-D30084 mark------
  #IF g_argv1 = '2' THEN
  #   CONSTRUCT BY NAME g_wc2 ON cay00
  #   BEFORE CONSTRUCT
  #     CALL cl_qbe_init()
  #      IF g_argv1 = '2' THEN
  #         CALL i001_set_cay00()
  #      END IF
  #    AFTER CONSTRUCT
  #      IF g_argv1 = '2' THEN
  #         CALL i001_set_cay00_a()
  #      END IF
  #   END CONSTRUCT
  #   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('cayuser', 'caygrup') #FUN-980030
  #   IF INT_FLAG THEN                                                                                                              
  #      RETURN                                                                                                                     
  #   END IF
  #END IF
  #MOD-D30084 mark ------ 
  IF g_argv1 = '2' THEN     #MOD-D30084 add
  
  #CONSTRUCT g_wc ON cay11,cay01,cay02,cay08,cay03,cay06,cay09,cay10,   #No.FUN-9B0118         #MOD-D30084 mark
   CONSTRUCT g_wc ON cay00,cay11,cay01,cay02,cay08,cay03,cay06,cay09,cay10,   #No.FUN-9B0118   #MOD-D30084 add cay00
                     cay04,cay12,cay05,cayacti                          #No.FUN-9B0118
                FROM cay00,cay11,cay01,cay02,cay08,cay03,cay06,cay09,cay10,   #No.FUN-9B0118   #MOD-D30084 add cay00
                     s_cay[1].cay04,s_cay[1].cay12,s_cay[1].cay05,      #No.FUN-9B0118
                     s_cay[1].cayacti                    
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         CALL i001_set_cay00()                  #MOD-D30084 add
      AFTER CONSTRUCT                           #MOD-D30084 add
         CALL i001_set_cay00_a()                #MOD-D30084 add
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cay03)   #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay03
                 NEXT FIELD cay03
            WHEN INFIELD(cay04)   #成本中心
                 CASE g_ccz.ccz06
                    WHEN '3'
                       CALL q_ecd(TRUE,TRUE,"")
                            RETURNING g_qryparam.multiret
                    WHEN '4'
                       CALL q_eca(TRUE,TRUE,"")
                            RETURNING g_qryparam.multiret
                    OTHERWISE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_gem"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                 END CASE
                 DISPLAY g_qryparam.multiret TO cay04
                 NEXT FIELD cay04
            WHEN INFIELD(cay06)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay06
                 NEXT FIELD cay06
            WHEN INFIELD(cay10)   #分攤來源科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay10
                 NEXT FIELD cay10
            WHEN INFIELD(cay11)   #分攤來源科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay11
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      
   END CONSTRUCT
  #MOD-D30084 str add-----
   ELSE
   CONSTRUCT g_wc ON cay11,cay01,cay02,cay08,cay03,cay06,cay09,cay10,   #No.FUN-9B0118      
                     cay04,cay12,cay05,cayacti                          #No.FUN-9B0118
                FROM cay11,cay01,cay02,cay08,cay03,cay06,cay09,cay10,   #No.FUN-9B0118
                     s_cay[1].cay04,s_cay[1].cay12,s_cay[1].cay05,      #No.FUN-9B0118
                     s_cay[1].cayacti                    
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cay03)   #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay03
                 NEXT FIELD cay03
            WHEN INFIELD(cay04)   #成本中心
                 CASE g_ccz.ccz06
                    WHEN '3'
                       CALL q_ecd(TRUE,TRUE,"")
                            RETURNING g_qryparam.multiret
                    WHEN '4'
                       CALL q_eca(TRUE,TRUE,"")
                            RETURNING g_qryparam.multiret
                    OTHERWISE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form     ="q_gem"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                 END CASE
                 DISPLAY g_qryparam.multiret TO cay04
                 NEXT FIELD cay04
            WHEN INFIELD(cay06)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay06
                 NEXT FIELD cay06
            WHEN INFIELD(cay10)   #分攤來源科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay10
                 NEXT FIELD cay10
            WHEN INFIELD(cay11)   #分攤來源科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay11
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
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      
   END CONSTRUCT
  END IF 
 #MOD-D30084 add end ------

   IF INT_FLAG THEN RETURN END IF
 
 
   LET g_sql= "SELECT UNIQUE cay00,cay11,cay01,cay02,cay03,cay06,cay08,cay09,cay10",  #No.FUN-9B0118
              "  FROM cay_file",
              " WHERE ", g_wc CLIPPED
  #MOD-D30084 str -----
  #CASE g_argv1
  #   WHEN "1" LET g_sql = g_sql CLIPPED," AND cay00 ='1'"
  #   WHEN "2"
  #    IF g_wc2=' 1=1' THEN   #FUN-920010
  #       LET g_sql = g_sql CLIPPED," AND cay00 !='1' AND ",g_wc2 CLIPPED #FUN-920010 
  #    ELSE                   #FUN-920010
  #       LET g_sql = g_sql CLIPPED," AND ",g_wc2 CLIPPED #FUN-920010
  #    END IF
  #END CASE
   IF g_argv1 ='1' THEN
      LET g_sql = g_sql CLIPPED," AND cay00 ='1' "
   ELSE
      LET g_sql = g_sql CLIPPED," AND cay00 !='1' " 
   END IF
  #MOD-D30084 end -----
   LET g_sql = g_sql," ORDER BY cay00,cay11,cay01,cay02,cay03,cay06,cay08,cay09,cay10"  #No.FUN-9B0118
   PREPARE i001_prepare FROM g_sql      #預備一下
   DECLARE i001_b_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i001_prepare
 
   LET g_sql= "SELECT UNIQUE cay00,cay11,cay01,cay02,cay03,cay06,cay08,cay09,cay10",    #No.FUN-9B0118
              "  FROM cay_file",
              " WHERE ", g_wc CLIPPED
  #MOD-D30084 str mark-----
  #CASE g_argv1
  #   WHEN "1" LET g_sql = g_sql CLIPPED," AND cay00 ='1'"
  #   WHEN "2"  
  #    IF g_wc2=' 1=1' THEN   #FUN-920010
  #       LET g_sql = g_sql CLIPPED," AND cay00 !='1' AND ",g_wc2 CLIPPED #FUN-920010 
  #    ELSE                   #FUN-920010
  #       LET g_sql = g_sql CLIPPED," AND ",g_wc2 CLIPPED #FUN-920010
  #    END IF
  #END CASE
   IF g_argv1 ='1' THEN
      LET g_sql = g_sql CLIPPED," AND cay00 ='1' "
   ELSE
      LET g_sql = g_sql CLIPPED," AND cay00 !='1' " 
   END IF
  #MOD-D30084 end mark-----
   LET g_sql_tmp = g_sql," INTO TEMP x"  #No.TQC-720019
   DROP TABLE x
   PREPARE i001_precount_x FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i001_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
   PREPARE i001_precount FROM g_sql
   DECLARE i001_count CURSOR FOR i001_precount
END FUNCTION
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i001_a()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i001_u()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i001_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
              CALL i001_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i001_copy()
            END IF
         WHEN "reproduce1"
            IF cl_chk_act_auth() THEN
               CALL i001_batch_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i001_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "recalculate"   #重新計算
            IF cl_chk_act_auth() THEN
               IF g_caya.cay09 != '1' THEN  #FUN-9A0049
                  IF cl_sure(0,0) THEN      #FUN-9A0049
                      CALL i001_t(g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay03,    #FUN-9A0049
                                  g_caya.cay06,g_caya.cay09,g_caya.cay10,g_caya.cay11 )   #FUN-9A0049  #No.FUN-9B0118
                  END IF   #FUN-9A0049
               END IF      #FUN-9A0049
            END IF
         WHEN "generate"      #批次產生
            IF cl_chk_act_auth() THEN
               CALL i001_g()
            END IF
         WHEN "recalculate1"
            IF cl_chk_act_auth() THEN
               CALL i001_t1()
            END IF
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cay),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i001_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_cay.clear()
   INITIALIZE g_cay11 LIKE cay_file.cay11     #No.FUN-9B0118
   INITIALIZE g_cay01 LIKE cay_file.cay01
   INITIALIZE g_cay02 LIKE cay_file.cay02
   INITIALIZE g_cay03 LIKE cay_file.cay03
   INITIALIZE g_cay06 LIKE cay_file.cay06
   INITIALIZE g_caya.* LIKE cay_file.*             #DEFAULT 設定
   #預設值及將數值類變數清成零
   LET g_caya_t.* = g_caya.*
   CALL cl_opmsg('a')
   WHILE TRUE
      CASE g_argv1
         WHEN "1" LET g_caya.cay00 ='1'  
         WHEN "2" LET g_caya.cay00 ='2'
      END CASE
      DISPLAY BY NAME g_caya.cay00
      LET g_caya.cay11 = g_aza.aza81       #No.FUN-9B0118
      LET g_caya.cay01 = g_ccz.ccz01
      LET g_caya.cay02 = g_ccz.ccz02
      LET g_caya.cay08 = 'A'
      LET g_caya.cay09 = '1'
      LET g_caya.cayuser=g_user
      LET g_caya.caygrup=g_grup
      LET g_caya.caydate=g_today
      LET g_caya.cayacti='Y'
      LET g_caya.caylegal = g_legal    #FUN-A50075
      CALL i001_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
          INITIALIZE g_caya.* TO NULL
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
      END IF
      IF g_caya.cay01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      LET g_rec_b=0
      CALL i001_b()                   #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i001_u()
   DEFINE l_sql    STRING
   DEFINE l_first  LIKE type_file.num5           #No.FUN-680122 SMALLINT 
 
   IF s_shut(0) THEN RETURN END IF
   IF g_cay01 IS NULL OR g_cay02 IS NULL OR
      g_cay03 IS NULL OR g_cay06 IS NULL OR g_cay11 IS NULL THEN   #No.FUN-9B0118
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   LET l_first = TRUE
   LET l_sql = "SELECT cay00,cay11,cay01,cay02,cay03,cay04,cay06 FROM cay_file",  #No.FUN-9B0118
               " WHERE cay00='",g_cay00,"'",
               "   AND cay11='",g_cay11,"'",   #No.FUN-9B0118
               "   AND cay01='",g_cay01,"'",
               "   AND cay02='",g_cay02,"'",
               "   AND cay03='",g_cay03,"'",
               "   AND cay06='",g_cay06,"'"
   PREPARE i001_u_p1 FROM l_sql
   DECLARE i001_u_c1 CURSOR FOR i001_u_p1
   FOREACH i001_u_c1 INTO g_caya.cay00,g_caya.cay11,g_caya.cay01,g_caya.cay02,g_caya.cay03,g_caya.cay04,g_caya.cay06 #No.FUN-9B0118
      OPEN i001_cl  USING g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay03,g_caya.cay04,g_caya.cay06,g_caya.cay11 #No.FUN-9B0118  #No.MOD-9C0193
      IF STATUS THEN
         CALL cl_err("OPEN i001_cl:", STATUS, 1)
         CLOSE i001_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH i001_cl INTO g_caya.*               # 對DB鎖定
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_caya.cay01,SQLCA.sqlcode,0)
         RETURN
      END IF
      LET g_caya_t.*=g_caya.*
      LET g_caya.caymodu=g_user                   # 修改者
      LET g_caya.caydate=g_today                  # 修改日期
      WHILE TRUE
         IF l_first THEN 
            CALL i001_i("u")                         # 欄位更改
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_caya.*=g_caya_t.*
               CALL i001_show()
               CALL cl_err('',9001,0)
               EXIT WHILE
            END IF
            LET g_cay08 = g_caya.cay08
            LET g_cay09 = g_caya.cay09
            LET g_cay10 = g_caya.cay10
            LET g_cay00 = g_caya.cay00     #MOD-B60131 add
         END IF
         IF g_argv1 = '2' THEN                             #MOD-B60131 add
            UPDATE cay_file SET cay08  =g_cay08,    # 更新DB
                                cay09  =g_cay09,
                                cay10  =g_cay10,
                                cay00  =g_cay00,  #MOD-B60131 add 
                                caymodu=g_user,
                                caydate=g_today
             WHERE cay00=g_caya_t.cay00 AND cay01=g_caya_t.cay01 AND cay02=g_caya_t.cay02 AND cay03=g_caya_t.cay03 AND cay04=g_caya_t.cay04 AND cay06=g_caya_t.cay06
               AND cay11=g_caya_t.cay11     #No.FUN-9B0118
        #MOD-B60131---add--start---
         ELSE
            UPDATE cay_file SET cay08  =g_cay08,    # 更新DB
                                cay09  =g_cay09,
                                cay10  =g_cay10,
                                caymodu=g_user,
                                caydate=g_today
             WHERE cay00=g_caya_t.cay00 AND cay01=g_caya_t.cay01 AND cay02=g_caya_t.cay02 AND cay03=g_caya_t.cay03 AND cay04=g_caya_t.cay04 AND cay06=g_caya_t.cay06
               AND cay11=g_caya_t.cay11 
         END IF
        #MOD-B60131---add---end---
         IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("upd","cay_file",g_caya_t.cay01,g_caya_t.cay02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
         END IF
         LET l_first = FALSE
         EXIT WHILE
      END WHILE
   END FOREACH
   CLOSE i001_cl
   COMMIT WORK
 
   OPEN i001_b_cs
   LET g_jump = g_curs_index
   LET mi_no_ask = TRUE  #No.FUN-6A0075
   CALL i001_fetch('/')
 
END FUNCTION
 
#處理INPUT
FUNCTION i001_i(p_cmd)
   DEFINE l_flag    LIKE type_file.chr1,             #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(1)
          p_cmd     LIKE type_file.chr1              #a:輸入 u:更改                 #No.FUN-680122 VARCHAR(1)
   DEFINE l_aag05   LIKE aag_file.aag05              #No.FUN-B40004
 
   DISPLAY BY NAME g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay08,g_caya.cay11,    #No.FUN-9B0118
                   g_caya.cay09,g_caya.cayuser,g_caya.caygrup,g_caya.caydate
 
   CALL cl_set_head_visible("","YES")                     #No.FUN-6A0092
 
   INPUT BY NAME g_caya.cay00,g_caya.cay11,g_caya.cay01,g_caya.cay02,g_caya.cay08,g_caya.cay03, #FUN-920010   #No.FUN-9B0118
                 g_caya.cay06,g_caya.cay09,g_caya.cay10
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i001_set_entry(p_cmd)
         CALL i001_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      BEFORE FIELD cay00
         IF g_argv1 = '2' THEN
            CALL i001_set_cay00()
         END IF
   
      AFTER FIELD cay00
        IF g_argv1 = '2' THEN 
           CALL i001_set_cay00_a()
           IF NOT cl_null(g_caya.cay00) THEN
              IF g_caya.cay00 NOT matches '[23456]' THEN
                 NEXT FIELD cay00
              END IF
           END IF
        END IF
 
      AFTER FIELD cay01    #年度
         IF NOT cl_null(g_caya.cay01) THEN
            LET g_cay01=g_caya.cay01
            IF g_caya.cay01 < g_ccz.ccz01 THEN
               CALL cl_err(g_caya.cay01,'axc-095',0)
               IF p_cmd='a' THEN
                  NEXT FIELD cay01
               ELSE
                  RETURN
               END IF
            END IF
         ELSE
            CALL cl_err(g_caya.cay01,'mfg5103',0)
            NEXT FIELD cay01
         END IF
 
      AFTER FIELD cay02    #月份
         IF NOT cl_null(g_caya.cay02) THEN
            IF (g_caya.cay01 = g_ccz.ccz01 AND g_caya.cay02 < g_ccz.ccz02 ) THEN
               CALL cl_err(g_caya.cay01,'axc-095',0)
               IF p_cmd='a' THEN
                  NEXT FIELD cay01
               ELSE
                  RETURN
               END IF
            END IF
 
            IF g_caya.cay02 <0 OR g_caya.cay02 > 12 THEN
               CALL cl_err_msg("","lib-232",1 || "|" || 12,0)
               LET g_caya.cay02=g_caya_t.cay02
               DISPLAY BY NAME g_caya.cay02
               NEXT FIELD cay02
            END IF
            LET g_caya_t.cay02=g_caya.cay02
            LET g_cay02=g_caya.cay02
         ELSE
            CALL cl_err(g_caya.cay02,'mfg5103',0)
            NEXT FIELD cay02
         END IF
 
      AFTER FIELD cay03    #部門編號
         LET g_cay03=g_caya.cay03
         IF NOT cl_null(g_caya.cay03) THEN 
            CALL i001_cay03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_caya.cay03,g_errno,0)
               LET g_caya.cay03 = ''
               NEXT FIELD cay03
            END IF
         ELSE
            CALL cl_err(g_caya.cay03,'mfg5103',0)
            NEXT FIELD cay03
         END IF
 
      BEFORE FIELD cay06,cay10
         IF cl_null(g_caya.cay11) THEN NEXT FIELD cay11 END IF
  
      AFTER FIELD cay06    #科目編號
         LET g_cay06=g_caya.cay06
         IF NOT cl_null(g_caya.cay06) THEN 
            CALL i001_cay06('a',g_caya.cay11)      #No.FUN-730057  #No.FUN-9B0118
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_caya.cay06,g_errno,0)
#FUN-B10052 --begin--
#                LET g_caya.cay06 = ''
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.arg1 = g_caya.cay11               
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.where = " aag01 LIKE '",g_caya.cay06 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_caya.cay06
                 DISPLAY BY NAME g_caya.cay06
#FUN-B10052 --end--
               NEXT FIELD cay06
            END IF
            #No.FUN-B40004  --Begin 
            IF NOT cl_null(g_caya.cay03) THEN
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_caya.cay06
                  AND aag00 = g_caya.cay11
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_caya.cay06,g_caya.cay03,g_caya.cay11)
                          RETURNING g_errno
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_caya.cay03,g_errno,0)
                     DISPLAY BY NAME g_caya.cay06
                     NEXT FIELD cay06
                  END IF
               END IF
            END IF
            #No.FUN-B40004  --End
         ELSE
            CALL cl_err(g_caya.cay06,'mfg5103',0)
            NEXT FIELD cay06
         END IF
 
      BEFORE FIELD cay09
         CALL i001_set_entry(p_cmd)
 
      AFTER FIELD cay09    #分攤比例來源
         IF g_caya.cay09 != '2' THEN
            LET g_caya.cay10 = ''
            DISPLAY BY NAME g_caya.cay10
            DISPLAY '' TO FORMONLY.aag02_b
         END IF
         CALL i001_set_no_entry(p_cmd)   #FUN-660201 add
 
      AFTER FIELD cay10    #分攤來源科目
         LET g_cay10=g_caya.cay10
         IF NOT cl_null(g_caya.cay10) THEN 
            CALL i001_cay10('a',g_caya.cay11)  #No.FUN-730057    #No.FUN-9B0118
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_caya.cay10,g_errno,0)
#FUN-B10052 --begin--
#                LET g_caya.cay10 = ''
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.arg1 = g_caya.cay11             
                 LET g_qryparam.construct = "N"
                 LET g_qryparam.where = " aag01 LIKE '",g_caya.cay10 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_caya.cay10
                 DISPLAY BY NAME g_caya.cay10
#FUN-B10052 --end--
               NEXT FIELD cay10
            END IF
            #No.FUN-B40004  --Begin
            IF NOT cl_null(g_caya.cay03) THEN
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_caya.cay10
                  AND aag00 = g_caya.cay11
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_caya.cay10,g_caya.cay03,g_caya.cay11)
                          RETURNING g_errno
                  END IF
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_caya.cay03,g_errno,0)
                     DISPLAY BY NAME g_caya.cay10
                     NEXT FIELD cay10
                  END IF
               END IF
            END IF
            #No.FUN-B40004  --End
         ELSE
            CALL cl_err(g_caya.cay10,'mfg5103',0)
            NEXT FIELD cay10
         END IF

      AFTER FIELD cay11    #帐套
         LET g_cay11=g_caya.cay11
         IF NOT cl_null(g_caya.cay11) THEN 
            CALL i001_cay11(p_cmd,g_caya.cay11)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_caya.cay11,g_errno,0)
               LET g_caya.cay11 = ''
               NEXT FIELD cay11
            END IF
         ELSE
            CALL cl_err(g_caya.cay11,'mfg5103',0)
            NEXT FIELD cay11
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cay03)   #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem"
                 CALL cl_create_qry() RETURNING g_caya.cay03
                 DISPLAY BY NAME g_caya.cay03
                 NEXT FIELD cay03
            WHEN INFIELD(cay06)   #科目編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.arg1 = g_caya.cay11               #No.FUN-9B0118
                 CALL cl_create_qry() RETURNING g_caya.cay06
                 DISPLAY BY NAME g_caya.cay06
                 NEXT FIELD cay06
            WHEN INFIELD(cay10)   #分攤來源科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.arg1 = g_caya.cay11               #No.FUN-9B0118
                 CALL cl_create_qry() RETURNING g_caya.cay10
                 DISPLAY BY NAME g_caya.cay10
                 NEXT FIELD cay10
            WHEN INFIELD(cay11)   #帐套
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING g_caya.cay11
                 DISPLAY BY NAME g_caya.cay11
                 NEXT FIELD cay11
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
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
 
FUNCTION i001_cay03(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_gem02         LIKE gem_file.gem02,
          l_gemacti       LIKE gem_file.gemacti 
 
   LET g_errno = ' '
 
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti 
     FROM gem_file
    WHERE gem01 = g_caya.cay03
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-003'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
 
   IF cl_null(g_errno) OR  p_cmd = 'a' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   ELSE
      DISPLAY '' TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION i001_cay06(p_cmd,p_bookno)                     #No.FUN-730057
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_aag02         LIKE aag_file.aag02,
          l_aag03         LIKE aag_file.aag03,
          l_aag07         LIKE aag_file.aag07,
          l_aagacti       LIKE aag_file.aagacti
   DEFINE p_bookno        LIKE aag_file.aag00           #No.FUN-730057
 
   LET g_errno = ' '
 
   SELECT aag02,aag03,aag07,aagacti 
     INTO l_aag02,l_aag03,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01 = g_caya.cay06
      AND aag00 = p_bookno                               #No.FUN-730057
      AND aag07 <> '1' AND aag03 = '2'
      AND aagacti = 'Y'
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07   = '1'     LET g_errno = 'agl-015'
        WHEN l_aag03  != '2'     LET g_errno = 'agl-201'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
 
   IF cl_null(g_errno) OR  p_cmd = 'a' THEN
      DISPLAY l_aag02 TO FORMONLY.aag02_a
   ELSE
      DISPLAY '' TO FORMONLY.aag02_a
   END IF
 
END FUNCTION
 
FUNCTION i001_cay10(p_cmd,p_bookno)                     #No.FUN-730057
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_aag02         LIKE aag_file.aag02,
          l_aag03         LIKE aag_file.aag03,
          l_aag07         LIKE aag_file.aag07,
          l_aagacti       LIKE aag_file.aagacti
   DEFINE p_bookno        LIKE aag_file.aag00            #No.FUN-730057
 
   LET g_errno = ' '
 
   SELECT aag02,aag03,aag07,aagacti 
     INTO l_aag02,l_aag03,l_aag07,l_aagacti
     FROM aag_file
    WHERE aag01 = g_caya.cay10
      AND aag00 = p_bookno                  #No.FUN-730057
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-001'
        WHEN l_aagacti = 'N'     LET g_errno = '9028'
        WHEN l_aag07   = '1'     LET g_errno = 'agl-015'
        WHEN l_aag03  != '2'     LET g_errno = 'agl-201'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
 
   IF cl_null(g_errno) OR  p_cmd = 'a' THEN
      DISPLAY l_aag02 TO FORMONLY.aag02_b
   ELSE
      DISPLAY '' TO FORMONLY.aag02_b
   END IF
 
END FUNCTION

FUNCTION i001_cay11(p_cmd,p_cay11) 
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE p_cay11         LIKE cay_file.cay11
   DEFINE l_aaaacti       LIKE aaa_file.aaaacti
 
   LET g_errno = ' '
 
   SELECT aaaacti INTO l_aaaacti
     FROM aaa_file
    WHERE aaa01 = p_cay11
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-095'
        WHEN l_aaaacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
 
END FUNCTION
 
FUNCTION i001_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cay01,cay02,cay03,cay06,cay11",TRUE)   #No.FUN-9B0118
   END IF
 
   IF INFIELD(cay09) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cay10",TRUE)
   END IF
 
   IF INFIELD(b) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("c",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i001_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("cay01,cay02,cay03,cay06,cay11",FALSE)   #No.FUN-9B0118
   END IF
 
   IF INFIELD(cay09) OR ( NOT g_before_input_done ) THEN
      IF g_caya.cay09 != '2' THEN
         CALL cl_set_comp_entry("cay10",FALSE)
      END IF
   END IF
 
   IF INFIELD(b) OR ( NOT g_before_input_done ) THEN
      IF g_caya.cay09 != '2' THEN
         CALL cl_set_comp_entry("c",FALSE)
      END IF
   END IF
      IF g_argv1 = '1' THEN
         CALL cl_set_comp_entry("cay00",FALSE)
      ELSE
         CALL cl_set_comp_entry("cay00",TRUE)
      END IF
END FUNCTION
 
FUNCTION i001_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   CALL i001_cs()                    #取得查詢條件
   IF INT_FLAG THEN                  #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN i001_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN             #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cay01 TO NULL
   ELSE
      OPEN i001_count
      FETCH i001_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i001_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION i001_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680122 VARCHAR(1)
 
   CASE p_flag
        WHEN 'N' FETCH NEXT     i001_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay03,   #No.FUN-9B0118
                                               g_cay06,g_cay08,g_cay09,g_cay10
        WHEN 'P' FETCH PREVIOUS i001_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay03,   #No.FUN-9B0118
                                               g_cay06,g_cay08,g_cay09,g_cay10
        WHEN 'F' FETCH FIRST    i001_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay03,   #No.FUN-9B0118
                                               g_cay06,g_cay08,g_cay09,g_cay10
        WHEN 'L' FETCH LAST     i001_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay03,   #No.FUN-9B0118
                                               g_cay06,g_cay08,g_cay09,g_cay10
        WHEN '/'
             IF (NOT mi_no_ask) THEN   #No.FUN-6A0075
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
             FETCH ABSOLUTE g_jump i001_b_cs INTO g_cay00,g_cay11,g_cay01,g_cay02,g_cay03,   #No.FUN-9B0118
                                                  g_cay06,g_cay08,g_cay09,g_cay10
             LET mi_no_ask = FALSE   #No.FUN-6A0075
   END CASE
 
   LET g_caya.cay00 = g_cay00
   LET g_caya.cay01 = g_cay01
   LET g_caya.cay02 = g_cay02
   LET g_caya.cay03 = g_cay03
   LET g_caya.cay06 = g_cay06
   LET g_caya.cay08 = g_cay08
   LET g_caya.cay09 = g_cay09
   LET g_caya.cay10 = g_cay10
   LET g_caya.cay11 = g_cay11     #No.FUN-9B0118
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cay01,SQLCA.sqlcode,0)
      INITIALIZE g_cay00 TO NULL  #TQC-6B0105
      INITIALIZE g_cay01 TO NULL  #TQC-6B0105
      INITIALIZE g_cay02 TO NULL  #TQC-6B0105
      INITIALIZE g_cay03 TO NULL  #TQC-6B0105
      INITIALIZE g_cay06 TO NULL  #TQC-6B0105
      INITIALIZE g_cay08 TO NULL  #TQC-6B0105
      INITIALIZE g_cay09 TO NULL  #TQC-6B0105
      INITIALIZE g_cay10 TO NULL  #TQC-6B0105
      INITIALIZE g_cay11 TO NULL  #No.FUN-9B0118
   ELSE
      CALL i001_show()
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
FUNCTION i001_show()
   DISPLAY BY NAME g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay03,
                   g_caya.cay06,g_caya.cay08,g_caya.cay09,g_caya.cay10,g_caya.cay11     #No.FUN-9B0118
   CALL i001_cay03('d')
   CALL i001_cay06('d',g_caya.cay11)
   CALL i001_cay10('d',g_caya.cay11)
   CALL i001_b_fill(g_wc)                 #單身
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i001_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680122 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680122 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680122 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680122 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680122 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680122 SMALLINT
 
   LET g_action_choice = ''       #MOD-B40236 add
   IF g_cay01 IS NULL OR g_cay02 IS NULL OR g_cay11 IS NULL OR   #No.FUN-9B0118
      g_cay03 IS NULL OR g_cay06 IS NULL THEN 
      RETURN
   END IF
   LET g_caya.caylegal = g_legal   #MOD-C20092 add
 
   CALL cl_opmsg('b')
 
   LET g_action_choice = ""
 
   LET g_forupd_sql = "SELECT cay04,'',cay12,cay05,cayacti",   #No.FUN-9B0118
                      "  FROM cay_file ",
                      "  WHERE cay00=?",
                      "   AND cay01=?",
                      "   AND cay02=?",
                      "   AND cay03=?",
                      "   AND cay06=?",
                      "   AND cay11=?",    #No.FUN-9B0118
                      "   AND cay04=?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_cay WITHOUT DEFAULTS FROM s_cay.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL i001_set_required()     #MOD-D30086 add
         CALL i001_set_no_required()  #MOD-D30086 add
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b>=l_ac THEN
            LET g_cay_t.* = g_cay[l_ac].*  #BACKUP
            LET p_cmd='u'
            BEGIN WORK
            OPEN i001_bcl USING g_caya.cay00,g_caya.cay01,g_caya.cay02,
                                g_caya.cay03,g_caya.cay06,g_caya.cay11,g_cay_t.cay04  #No.FUN-9B0118
            IF STATUS THEN
               CALL cl_err("OPEN i001_bcl:", STATUS, 1)
               CLOSE i001_bcl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH i001_bcl INTO g_cay[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_cay_t.cay04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL i001_cay04(g_cay[l_ac].cay04) RETURNING g_cay[l_ac].gem02_b
            DISPLAY g_cay[l_ac].gem02_b TO FORMONLY.gem02_b
            SELECT ccz06 INTO g_ccz.ccz06 FROM ccz_file
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
        #MOD-D30086 
         IF g_ccz.ccz06 != '2' THEN
            LET g_cay[l_ac].cay04 = ' '
         END IF
        #MOD-D30086
         INSERT INTO cay_file(cay00,cay01,cay02,cay03,
                              cay04,cay05,cay06,cay08,
                              cay09,cay10,cayacti,
                              cayuser,caygrup,caymodu,caydate,cay11,cay12,cayoriu,cayorig,caylegal)  #No.FUN-9B0118  #FUN-A50075 add legal
         VALUES(g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay03,
                g_cay[l_ac].cay04,g_cay[l_ac].cay05,g_caya.cay06,g_caya.cay08,
                g_caya.cay09,g_caya.cay10,g_cay[l_ac].cayacti,
                g_user,g_grup,'',g_today,g_caya.cay11,g_cay[l_ac].cay12, g_user, g_grup,g_caya.caylegal)    #No.FUN-9B0118      #No.FUN-980030 10/01/04  insert columns oriu, orig    #FUN-A50075 add legal
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","cay_file",g_caya.cay01,g_caya.cay02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      AFTER FIELD cay04
         IF NOT cl_null(g_cay[l_ac].cay04) THEN
            CALL i001_cay04(g_cay[l_ac].cay04) RETURNING g_cay[l_ac].gem02_b
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cay[l_ac].cay04,g_errno,0)
               LET g_cay[l_ac].cay04=g_cay_t.cay04
               NEXT FIELD cay04
            END IF
            CALL i001_check_cay12(p_cmd,g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay03,
                                  g_cay[l_ac].cay04,g_caya.cay06,g_caya.cay11,
                                  g_cay[l_ac].cay12)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cay[l_ac].cay12,g_errno,0)
               NEXT FIELD cay04
            END IF
            DISPLAY g_cay[l_ac].gem02_b TO FORMONLY.gem02_b
            IF p_cmd = 'a' OR p_cmd = 'u' AND g_cay[l_ac].cay04 != g_cay_t.cay04 THEN  #No.FUN-9B0118
               SELECT COUNT(*) INTO g_cnt
                 FROM cay_file
                WHERE cay00 = g_caya.cay00
                  AND cay01 = g_caya.cay01
                  AND cay02 = g_caya.cay02
                  AND cay03 = g_caya.cay03
                  AND cay06 = g_caya.cay06
                  AND cay11 = g_caya.cay11         #No.FUN-9B0118
                  AND cay04 = g_cay[l_ac].cay04
               IF g_cnt > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_cay[l_ac].cay04 = g_cay_t.cay04
                  NEXT FIELD cay04
               END IF
            END IF
         #No.TQC-B90005  --Mark Begin
         #ELSE
         #   CALL cl_err(g_cay[l_ac].cay04,'mfg5103',0)
         #   NEXT FIELD cay04
         #No.TQC-B90005  --Mark End
         END IF
         #No.TQC-B90005  --Begin
         IF cl_null(g_cay[l_ac].cay04) THEN
            IF g_ccz.ccz06 != '2' THEN
               LET g_caya.cay04 = ' '
           #MOD-D30086 str mark----- 
           #ELSE
           #   CALL cl_err('','anm-103',0)
           #   NEXT FIELD cay04
           #MOD-D30086 end mark----- 
            END IF
         END IF
         #No.TQC-B90005  --End
      AFTER FIELD cay12
         IF NOT cl_null(g_cay[l_ac].cay12) THEN
            CALL i001_check_cay12(p_cmd,g_caya.cay00,g_caya.cay01,g_caya.cay02,g_caya.cay03,
                                  g_cay[l_ac].cay04,g_caya.cay06,g_caya.cay11,
                                  g_cay[l_ac].cay12)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_cay[l_ac].cay12,g_errno,0)
               NEXT FIELD cay12
            END IF
         END IF
 
      AFTER FIELD cay05
         IF NOT cl_null(g_cay[l_ac].cay05) THEN
            IF g_cay[l_ac].cay05 < 0 THEN
               CALL cl_err(g_cay[l_ac].cay05,"aec-020",0)
               NEXT FIELD cay05
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_cay_t.cay04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM cay_file
             WHERE cay00 = g_caya.cay00
               AND cay01 = g_caya.cay01
               AND cay02 = g_caya.cay02
               AND cay03 = g_caya.cay03
               AND cay06 = g_caya.cay06
               AND cay11 = g_caya.cay11     #No.FUN-9B0118
               AND cay04 = g_cay_t.cay04
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","cay_file",g_caya.cay01,g_caya.cay02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
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
            LET g_cay[l_ac].* = g_cay_t.*
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_cay[l_ac].cay05,-263,1)
            LET g_cay[l_ac].* = g_cay_t.*
         ELSE
            UPDATE cay_file SET cay04  =g_cay[l_ac].cay04,
                                cay05  =g_cay[l_ac].cay05,
                                cay12  =g_cay[l_ac].cay12,    #No.FUN-9B0118
                                cayacti=g_cay[l_ac].cayacti,
                                caymodu=g_user,
                                caydate=g_today
                          WHERE cay00  =g_caya.cay00
                            AND cay01  =g_caya.cay01
                            AND cay02  =g_caya.cay02
                            AND cay03  =g_caya.cay03
                            AND cay06  =g_caya.cay06
                            AND cay11  =g_caya.cay11      #No.FUN-9B0118
                            AND cay04  =g_cay_t.cay04
 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","cay_file",g_caya.cay01,g_caya.cay02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               LET g_cay[l_ac].* = g_cay_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_cay[l_ac].* TO NULL      #900423
         LET g_cay_t.* = g_cay[l_ac].*         #新輸入資料
         LET g_cay[l_ac].cay05 = 0
        #LET g_cay[l_ac].cay04 = ' '           #TQC-B90005     #MOD-D30086 mark
        #LET g_cay[l_ac].cay12 = 1             #No.FUN-9B0118  #MOD-B60130 mark
         LET g_cay[l_ac].cayacti = 'Y'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac           #FUN-D40030 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_cay[l_ac].* = g_cay_t.*
            #FUN-D40030---add---str---
            ELSE
               CALL g_cay.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D40030---add---end---
            END IF
            CLOSE i001_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D40030 add
         CLOSE i001_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
      ON ACTION controlp
         CASE 
            WHEN INFIELD(cay04)    #成本中心
               IF g_caya.cay08='A' THEN
                  CASE g_ccz.ccz06
                     WHEN '3'
                        CALL q_ecd(FALSE,TRUE,g_cay[l_ac].cay04)
                             RETURNING g_cay[l_ac].cay04
                     WHEN '4'
                        CALL q_eca(FALSE,TRUE,g_cay[l_ac].cay04)
                             RETURNING g_cay[l_ac].cay04
                     OTHERWISE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     ="q_gem"
                        LET g_qryparam.default1 = g_cay[l_ac].cay04
                        CALL cl_create_qry() RETURNING g_cay[l_ac].cay04
                  END CASE
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     ="q_gem"
                  LET g_qryparam.default1 = g_cay[l_ac].cay04
                  CALL cl_create_qry() RETURNING g_cay[l_ac].cay04
               END IF
               DISPLAY BY NAME g_cay[l_ac].cay04
               NEXT FIELD cay04
            OTHERWISE EXIT CASE
         END CASE
      
      ON ACTION controls                                #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")            #No.FUN-6A0092 
  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE i001_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i001_cay04(p_cay04)
   DEFINE p_cay04         LIKE cay_file.cay04,
          l_gem02         LIKE gem_file.gem02,
          l_gemacti       LIKE gem_file.gemacti 
 
   LET g_errno = ' '
 
   IF g_caya.cay08='A' THEN
      CASE g_ccz.ccz06
         WHEN '3'
            SELECT ecd02,ecdacti INTO l_gem02,l_gemacti
              FROM ecd_file
             WHERE ecd01 = p_cay04
         WHEN '4'
            SELECT eca02,ecaacti INTO l_gem02,l_gemacti
              FROM eca_file
             WHERE eca01 = p_cay04
         OTHERWISE
            SELECT gem02,gemacti INTO l_gem02,l_gemacti
              FROM gem_file
             WHERE gem01 = p_cay04
      END CASE
   ELSE
      SELECT gem02,gemacti INTO l_gem02,l_gemacti
        FROM gem_file
       WHERE gem01 = p_cay04
   END IF
 
   CASE WHEN SQLCA.SQLCODE=100   LET g_errno = 'agl-003'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        OTHERWISE                LET g_errno = SQLCA.sqlcode USING '----------'
   END CASE
 
   IF cl_null(l_gem02) THEN LET l_gem02 = ' ' END IF
   RETURN l_gem02
 
END FUNCTION
 
FUNCTION i001_b_askkey()
   DEFINE l_wc            STRING
 
   CALL cl_opmsg('q')
   CLEAR cay03,cay04,cay05
   CONSTRUCT l_wc ON cay04,cay05,cayacti     #螢幕上取條件
                FROM s_cay[1].cay04,s_cay[1].cay05,s_cay[1].cayacti
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
  
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   CALL i001_b_fill(l_wc)
   CALL cl_opmsg('b')
END FUNCTION
 
FUNCTION i001_t1()
   DEFINE p_row,p_col  LIKE type_file.num5          
   DEFINE l_sql        STRING
   DEFINE tm           RECORD
                        cay11 LIKE cay_file.cay11,    #No.FUN-9B0118
                        yy    LIKE cay_file.cay01,
                        mm    LIKE cay_file.cay02
                       END RECORD
   DEFINE l_cay        RECORD LIKE cay_file.*
   DEFINE l_where      STRING
   DEFINE l_where1     STRING
   DEFINE l_cay00      LIKE cay_file.cay00
   DEFINE l_cay01      LIKE cay_file.cay01
   DEFINE l_cay02      LIKE cay_file.cay02
   DEFINE l_cay03      LIKE cay_file.cay03
   DEFINE l_cay06      LIKE cay_file.cay06
   DEFINE l_cay09      LIKE cay_file.cay09
   DEFINE l_cay10      LIKE cay_file.cay10
   DEFINE l_cay11      LIKE cay_file.cay11    #No.FUN-9B0118

   LET p_row = 6 LET p_col = 6

   OPEN WINDOW i001_w_t AT p_row,p_col WITH FORM "axc/42f/axci001_t"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("axci001_t")

   INITIALIZE tm.* TO NULL
   INPUT BY NAME tm.cay11,tm.yy,tm.mm WITHOUT DEFAULTS  #No.FUN-9B0118

      AFTER FIELD cay11
         IF NOT cl_null(tm.cay11) THEN 
            CALL i001_cay11('a',tm.cay11)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.cay11,g_errno,0)
               LET tm.cay11 = ''
               DISPLAY BY NAME tm.cay11
               NEXT FIELD cay11
            END IF
         ELSE
            CALL cl_err(tm.cay11,'mfg5103',0)
            NEXT FIELD cay11
         END IF

      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            CALL cl_err(tm.yy,'mfg0037',0)
            NEXT FIELD yy
         END IF

      AFTER FIELD mm
         IF cl_null(tm.mm) THEN
            CALL cl_err(tm.mm,'mfg0037',0)
            NEXT FIELD mm
         ELSE
            CASE g_prog
               WHEN "axci001" LET l_where1 = " cay00 = '1'" 
               WHEN "axci002" LET l_where1 = " cay00 IN ('2','3','4','5','6') "
            END CASE
            LET l_sql = "SELECT COUNT(*) FROM cay_file",
                        " WHERE cay01=",tm.yy,
                        "   AND cay02=",tm.mm,
                        "   AND cay11='",tm.cay11,"'",    #No.FUN-9B0118
                        "   AND cay09 != '1'",
                        "   AND ",l_where1 CLIPPED    
            PREPARE i001_t1_p1 FROM l_sql
            DECLARE i001_t1_c1 CURSOR FOR i001_t1_p1
            OPEN i001_t1_c1
            FETCH i001_t1_c1 INTO g_cnt
            IF g_cnt = 0 THEN
               CALL cl_err('','mfg9089',1)
               NEXT FIELD cay11 #No.FUN-9B0118
            END IF
         END IF

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121

      ON ACTION controlp
         CASE
            WHEN INFIELD(cay11)   #分攤來源科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.cay11
                 DISPLAY BY NAME tm.cay11
            OTHERWISE EXIT CASE
         END CASE
 
   END INPUT
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW i001_w_t 
      RETURN
   END IF
   CLOSE WINDOW i001_w_t 
   IF NOT cl_sure(0,0) THEN RETURN END IF
   IF g_prog='axci001' THEN
      LET l_where = " cay00 = '1'"
   ELSE
      LET l_where = " cay00 IN ('2','3','4','5','6') "
   END IF
   LET l_sql = "SELECT DISTINCT cay00,cay01,cay02,cay03,cay06,cay09,cay10,cay11 FROM cay_file",  #No.FUN-9B0118
               " WHERE cay01=",tm.yy,
               "   AND cay02=",tm.mm,
               "   AND cay11='",tm.cay11,"'",    #No.FUN-9B0118
               "   AND cay09 != '1'",
               "   AND ",l_where CLIPPED    

   PREPARE i001_t1 FROM l_sql
   DECLARE i001_c1 CURSOR FOR i001_t1
   FOREACH i001_c1 INTO l_cay00,l_cay01,l_cay02,l_cay03,l_cay06,l_cay09,l_cay10,l_cay11  #No.FUN-9B0118
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      CALL i001_t(l_cay00,l_cay01,l_cay02,l_cay03,l_cay06,l_cay09,l_cay10,l_cay11)   #No.FUN-9B0118
   END FOREACH
END FUNCTION

FUNCTION i001_t(p_cay00,p_cay01,p_cay02,p_cay03,p_cay06,p_cay09,p_cay10,p_cay11)  #FUN-9A0049   #No.FUN-9B0118
   DEFINE l_sql   STRING,
          l_dbs   LIKE azp_file.azp03,
          l_sum   LIKE aao_file.aao05,
          l_aao01 LIKE aao_file.aao01,
          l_aao02 LIKE aao_file.aao02,
          l_aao05 LIKE aao_file.aao05,
          l_aao06 LIKE aao_file.aao06,
          l_aag06 LIKE aag_file.aag06,
          l_tot   LIKE aao_file.aao05,
          l_cay05 LIKE cay_file.cay05,
          l_bdate LIKE cam_file.cam01,
          l_edate LIKE cam_file.cam01,
          l_cam02 LIKE cam_file.cam02,
          l_cam07 LIKE cam_file.cam07
   DEFINE l_plant LIKE type_file.chr10          #FUN-980020
   DEFINE p_cay00      LIKE cay_file.cay00 #FUN-9A0049
   DEFINE p_cay01      LIKE cay_file.cay01 #FUN-9A0049
   DEFINE p_cay02      LIKE cay_file.cay02 #FUN-9A0049
   DEFINE p_cay03      LIKE cay_file.cay03 #FUN-9A0049
   DEFINE p_cay06      LIKE cay_file.cay06 #FUN-9A0049
   DEFINE p_cay09      LIKE cay_file.cay09 #FUN-9A0049
   DEFINE p_cay10      LIKE cay_file.cay10 #FUN-9A0049
   DEFINE p_cay11      LIKE cay_file.cay11 #No.FUN-9B0118
   DEFINE l_cay05_tot  LIKE cay_file.cay05 #No:CHI-B30013 add
   DEFINE l_cay05_t    LIKE cay_file.cay05 #No:CHI-B30013 add
   DEFINE l_cay04      LIKE cay_file.cay04 #No:CHI-B30013 add
   DEFINE l_ccj02      LIKE ccj_file.ccj02 #FUN-C60047
   DEFINE l_ccj06      LIKE ccj_file.ccj06 #FUN-C60047
   DEFINE l_ccj05      LIKE ccj_file.ccj05 #FUN-C60047
   DEFINE l_ccj051     LIKE ccj_file.ccj051 #FUN-C60047
   DEFINE l_ccj07      LIKE ccj_file.ccj07 #FUN-C60047
   DEFINE l_ccj071     LIKE ccj_file.ccj071 #FUN-C60047
      
     #--------------------No:CHI-B30013 add
     #在重新計算前先將分攤率歸為0
      UPDATE cay_file SET cay05  =0,
                          caymodu=g_user,
                          caydate=g_today
                    WHERE cay00  =p_cay00 
                      AND cay01  =p_cay01 
                      AND cay02  =p_cay02 
                      AND cay03  =p_cay03 
                      AND cay06  =p_cay06 
                      AND cay11  =p_cay11
                      AND cayacti='Y'
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1) 
         LET g_cay[l_ac].* = g_cay_t.*
      END IF
      LET l_cay05_tot = 0      
      LET l_cay05_t = NULL      
      LET l_cay04 = NULL      
     #--------------------No:CHI-B30013 end
         CASE P_cay09     #FUN-9A0049
            WHEN '2'   #科目餘額
              #當分攤比例來源(cay09) = '2' (科目餘額)時，
              #根據來源科目編號的科目餘額該成本中心所佔比例更新分攤比例
 
               #取參數設定ccz11,ccz12總帳所在工廠編號,帳別
               LET l_plant = g_ccz.ccz11                 #FUN-980020
               LET g_plant_new = g_ccz.ccz11                                         #FUN-980020
               #CALL s_getdbs()               #FUN-A50102
               #LET l_dbs = g_dbs_new CLIPPED #FUN-A50102
 
               #先算科目餘額合計
               LET l_sql = "SELECT SUM(aao05-aao06)",
                           #"  FROM ",l_dbs CLIPPED,"aao_file, ",
                           #          l_dbs CLIPPED,"aag_file ",
                           "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),",", #FUN-A50102
                                     cl_get_target_table(g_plant_new,'aag_file'),     #FUN-A50102
                           " WHERE aao00 ='",p_cay11    ,"'",   #No.FUN-9B0118 ccz12->cay11
                           "   AND aao01 ='",p_cay10,"'",   #FUN-9A0049
                           "   AND aao02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'",#FUN-9A0049
                           "                    AND cay01='",p_cay01,"'",#FUN-9A0049
                           "                    AND cay02='",p_cay02,"'",#FUN-9A0049
                           "                    AND cay03='",p_cay03,"'",#FUN-9A0049
                           "                    AND cay06='",p_cay06,"'",#FUN-9A0049
                           "                    AND cay11='",p_cay11,"'",#No.FUN-9B0118
                           "                    AND cayacti='Y')",
                           "   AND aao03 ='",p_cay01,"'", #FUN-9A0049
                           "   AND aao04 ='",p_cay02,"'", #FUN-9A0049
                           "   AND aag01 =aao01",
                           "   AND aag00 =aao00",                 #No.FUN-730057   
                           "   AND aag00 = '",p_cay11  ,"'",      #No.FUN-730057  #No.FUN-9B0118
                           "   AND aag07!='1'"    #非統制帳戶
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE i001_t_p1 FROM l_sql
               DECLARE i001_t_c1 CURSOR FOR i001_t_p1
               OPEN i001_t_c1
               FETCH i001_t_c1 INTO l_sum
               IF cl_null(l_sum) THEN LET l_sum = 0 END IF
 
               LET l_sql = "SELECT aao01,aao02,aao05,aao06,aag06",
                           #"  FROM ",l_dbs CLIPPED,"aao_file, ",
                           #          l_dbs CLIPPED,"aag_file ",
                           "  FROM ",cl_get_target_table(g_plant_new,'aao_file'),",", #FUN-A50102
                                     cl_get_target_table(g_plant_new,'aag_file'),     #FUN-A50102
                           " WHERE aao00 ='",p_cay11    ,"'",   #No.FUN-9B0118 ccz12->cay11  #No.FUN-9B0118
                           "   AND aao01 ='",p_cay10,"'", #FUN-9A0049
                           "   AND aao02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", #FUN-9A0049
                           "                    AND cay01='",p_cay01,"'", #FUN-9A0049
                           "                    AND cay02='",p_cay02,"'", #FUN-9A0049
                           "                    AND cay03='",p_cay03,"'", #FUN-9A0049
                           "                    AND cay06='",p_cay06,"'", #FUN-9A0049
                           "                    AND cay11='",p_cay11,"'", #No.FUN-9B0118
                           "                    AND cayacti='Y')",
                           "   AND aao03 ='",p_cay01,"'", #FUN-9A0049
                           "   AND aao04 ='",p_cay02,"'", #FUN-9A0049
                           "   AND aag01 =aao01",
                           "   AND aag00 =aao00",                 #No.FUN-730057   
                           "   AND aag00 = '",p_cay11  ,"'",      #No.FUN-730057  #No.FUN-9B0118
                           "   AND aag07!='1'"    #非統制帳戶
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
               PREPARE i001_t_p2 FROM l_sql
               DECLARE i001_t_c2 CURSOR FOR i001_t_p2
 
               MESSAGE "WORKING !"
               FOREACH i001_t_c2 INTO l_aao01,l_aao02,l_aao05,l_aao06,l_aag06
                  IF cl_null(l_aao05) THEN LET l_aao05 = 0 END IF
                  IF cl_null(l_aao06) THEN LET l_aao06 = 0 END IF
                  IF l_aag06='1' THEN           #正常餘額為借餘時
                     LET l_tot=l_aao05-l_aao06
                  ELSE
                     LET l_tot=l_aao06-l_aao05
                  END IF
                  LET l_cay05 = l_tot / l_sum
                  IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
 
                  UPDATE cay_file SET cay05  =l_cay05,
                                      caymodu=g_user,
                                      caydate=g_today
                                WHERE cay00  =p_cay00 #FUN-9A0049
                                  AND cay01  =p_cay01 #FUN-9A0049
                                  AND cay02  =p_cay02 #FUN-9A0049
                                  AND cay03  =p_cay03 #FUN-9A0049
                                  AND cay06  =p_cay06 #FUN-9A0049
                                  AND cay11  =p_cay11 #No.FUN-9B0118
                                  AND cay04  =l_aao02
                                  AND cayacti='Y'
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1)  #No.FUN-660127 #FUN-9A0049
                     LET g_cay[l_ac].* = g_cay_t.*
                  END IF
                 #--------------------No:CHI-B30013 add
                  IF cl_null(l_cay05_t) THEN
                     LET l_cay05_t = l_cay05
                     LET l_cay04 = l_aao02
                  ELSE
                     IF l_cay05 > l_cay05_t THEN
                        LET l_cay05_t = l_cay05
                        LET l_cay04 = l_aao02
                     END IF
                  END IF
                  LET l_cay05_tot = l_cay05_tot + l_cay05    
                 #--------------------No:CHI-B30013 end
               END FOREACH
            WHEN '3'   #約當產量
              #當分攤比例來源(cay09) = '3' (約當產量)時，
              #根據約當產量該成本中心所佔比例更新分攤比例
 
              #MOD-CC0159---mark---S
              #LET l_bdate = MDY(p_cay02,1,p_cay01)     #FUN-9A0049
              #LET l_edate = MDY(p_cay02+1,1,p_cay01)-1 #FUN-9A0049
              #MOD-CC0159---mark---E
              #MOD-CC0159---S
               CALL s_azm(p_cay01,p_cay02)
                  RETURNING g_chr,l_bdate,l_edate
              #MOD-CC0159---E
               #先算約當產量合計
               LET l_sql = "SELECT SUM(cam07)",
                           "  FROM cam_file",
                           " WHERE cam01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND cam02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", #FUN-9A0049
                           "                    AND cay01='",p_cay01,"'", #FUN-9A0049
                           "                    AND cay11='",p_cay11,"'", #No.FUN-9B0118
                           "                    AND cay02='",p_cay02,"'", #FUN-9A0049
                           "                    AND cay03='",p_cay03,"'", #FUN-9A0049
                           "                    AND cay06='",p_cay06,"'", #FUN-9A0049
                           "                    AND cayacti='Y')"
               PREPARE i001_t_p3 FROM l_sql
               DECLARE i001_t_c3 CURSOR FOR i001_t_p3
               OPEN i001_t_c3
               FETCH i001_t_c3 INTO l_sum
               IF cl_null(l_sum) THEN LET l_sum = 0 END IF
 
               LET l_sql = "SELECT cam02,SUM(cam07)",
                           "  FROM cam_file",
                           " WHERE cam01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND cam02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", #FUN-9A0049
                           "                    AND cay01='",p_cay01,"'", #FUN-9A0049
                           "                    AND cay11='",p_cay11,"'", #No.FUN-9B0118
                           "                    AND cay02='",p_cay02,"'", #FUN-9A0049
                           "                    AND cay03='",p_cay03,"'", #FUN-9A0049
                           "                    AND cay06='",p_cay06,"'", #FUN-9A0049
                           "                    AND cayacti='Y')",
                           " GROUP BY cam02"
               PREPARE i001_t_p4 FROM l_sql
               DECLARE i001_t_c4 CURSOR FOR i001_t_p4
 
               MESSAGE "WORKING !"
               FOREACH i001_t_c4 INTO l_cam02,l_cam07
                  LET l_cay05 = l_cam07 / l_sum
                  IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
 
                  UPDATE cay_file SET cay05  =l_cay05,
                                      caymodu=g_user,
                                      caydate=g_today
                                WHERE cay00  =p_cay00 #FUN-9A0049
                                  AND cay01  =p_cay01 #FUN-9A0049
                                  AND cay11  =p_cay11 #No.FUN-9B0118
                                  AND cay02  =p_cay02 #FUN-9A0049
                                  AND cay03  =p_cay03 #FUN-9A0049
                                  AND cay06  =p_cay06 #FUN-9A0049
                                  AND cay04  =l_cam02
                                  AND cayacti='Y'
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1)  #No.FUN-660127#FUN-9A0049
                     LET g_cay[l_ac].* = g_cay_t.*
                  END IF
                 #--------------------No:CHI-B30013 add
                  IF cl_null(l_cay05_t) THEN
                     LET l_cay05_t = l_cay05
                     LET l_cay04 = l_cam02
                  ELSE
                     IF l_cay05 > l_cay05_t THEN
                        LET l_cay05_t = l_cay05
                        LET l_cay04 = l_cam02
                     END IF
                  END IF
                  LET l_cay05_tot = l_cay05_tot + l_cay05    
                 #--------------------No:CHI-B30013 end
               END FOREACH
            #FUN-C60047---begin
            WHEN '4'     #生產數量
              #MOD-CC0159---mark---S
              #LET l_bdate = MDY(p_cay02,1,p_cay01)     
              #LET l_edate = MDY(p_cay02+1,1,p_cay01)-1
              #MOD-CC0159---mark---E
              #MOD-CC0159---S
               CALL s_azm(p_cay01,p_cay02)
                  RETURNING g_chr,l_bdate,l_edate
              #MOD-CC0159---E
               #先算生產數量合計
               LET l_sql = "SELECT SUM(ccj06)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')"
               PREPARE i001_t_p5 FROM l_sql
               DECLARE i001_t_c5 CURSOR FOR i001_t_p5
               OPEN i001_t_c5
               FETCH i001_t_c5 INTO l_sum
               IF cl_null(l_sum) THEN LET l_sum = 0 END IF

               LET l_sql = "SELECT ccj02,SUM(ccj06)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')",
                           " GROUP BY ccj02"
               PREPARE i001_t_p6 FROM l_sql
               DECLARE i001_t_c6 CURSOR FOR i001_t_p6
               
               MESSAGE "WORKING !"
               FOREACH i001_t_c6 INTO l_ccj02,l_ccj06
                  LET l_cay05 = l_ccj06 / l_sum
                  IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
 
                  UPDATE cay_file SET cay05  =l_cay05,
                                      caymodu=g_user,
                                      caydate=g_today
                                WHERE cay00  =p_cay00 
                                  AND cay01  =p_cay01 
                                  AND cay11  =p_cay11 
                                  AND cay02  =p_cay02 
                                  AND cay03  =p_cay03 
                                  AND cay06  =p_cay06 
                                  AND cay04  =l_ccj02
                                  AND cayacti='Y'
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1) 
                     LET g_cay[l_ac].* = g_cay_t.*
                  END IF

                  IF cl_null(l_cay05_t) THEN
                     LET l_cay05_t = l_cay05
                     LET l_cay04 = l_ccj02
                  ELSE
                     IF l_cay05 > l_cay05_t THEN
                        LET l_cay05_t = l_cay05
                        LET l_cay04 = l_ccj02
                     END IF
                  END IF
                  LET l_cay05_tot = l_cay05_tot + l_cay05    
               END FOREACH

            WHEN '5'     #實際工時
              #MOD-CC0159---mark---S
              #LET l_bdate = MDY(p_cay02,1,p_cay01)     
              #LET l_edate = MDY(p_cay02+1,1,p_cay01)-1
              #MOD-CC0159---mark---E
              #MOD-CC0159---S
               CALL s_azm(p_cay01,p_cay02)
                  RETURNING g_chr,l_bdate,l_edate
              #MOD-CC0159---E
               #先算實際工時合計
               LET l_sql = "SELECT SUM(ccj05)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')"
               PREPARE i001_t_p7 FROM l_sql
               DECLARE i001_t_c7 CURSOR FOR i001_t_p7
               OPEN i001_t_c7
               FETCH i001_t_c7 INTO l_sum
               IF cl_null(l_sum) THEN LET l_sum = 0 END IF

               LET l_sql = "SELECT ccj02,SUM(ccj05)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')",
                           " GROUP BY ccj02"
               PREPARE i001_t_p8 FROM l_sql
               DECLARE i001_t_c8 CURSOR FOR i001_t_p8
               
               MESSAGE "WORKING !"
               FOREACH i001_t_c8 INTO l_ccj02,l_ccj05
                  LET l_cay05 = l_ccj05 / l_sum
                  IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
 
                  UPDATE cay_file SET cay05  =l_cay05,
                                      caymodu=g_user,
                                      caydate=g_today
                                WHERE cay00  =p_cay00 
                                  AND cay01  =p_cay01 
                                  AND cay11  =p_cay11 
                                  AND cay02  =p_cay02 
                                  AND cay03  =p_cay03 
                                  AND cay06  =p_cay06 
                                  AND cay04  =l_ccj02
                                  AND cayacti='Y'
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1) 
                     LET g_cay[l_ac].* = g_cay_t.*
                  END IF

                  IF cl_null(l_cay05_t) THEN
                     LET l_cay05_t = l_cay05
                     LET l_cay04 = l_ccj02
                  ELSE
                     IF l_cay05 > l_cay05_t THEN
                        LET l_cay05_t = l_cay05
                        LET l_cay04 = l_ccj02
                     END IF
                  END IF
                  LET l_cay05_tot = l_cay05_tot + l_cay05    
               END FOREACH

            WHEN '6'     #實際機時
              #MOD-CC0159---mark---S
              #LET l_bdate = MDY(p_cay02,1,p_cay01)     
              #LET l_edate = MDY(p_cay02+1,1,p_cay01)-1
              #MOD-CC0159---mark---E
              #MOD-CC0159---S
               CALL s_azm(p_cay01,p_cay02)
                  RETURNING g_chr,l_bdate,l_edate
              #MOD-CC0159---E
               #先算實際機時合計
               LET l_sql = "SELECT SUM(ccj051)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')"
               PREPARE i001_t_p9 FROM l_sql
               DECLARE i001_t_c9 CURSOR FOR i001_t_p9
               OPEN i001_t_c9
               FETCH i001_t_c9 INTO l_sum
               IF cl_null(l_sum) THEN LET l_sum = 0 END IF

               LET l_sql = "SELECT ccj02,SUM(ccj051)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')",
                           " GROUP BY ccj02"
               PREPARE i001_t_p10 FROM l_sql
               DECLARE i001_t_c10 CURSOR FOR i001_t_p10
               
               MESSAGE "WORKING !"
               FOREACH i001_t_c10 INTO l_ccj02,l_ccj051
                  LET l_cay05 = l_ccj051 / l_sum
                  IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
 
                  UPDATE cay_file SET cay05  =l_cay05,
                                      caymodu=g_user,
                                      caydate=g_today
                                WHERE cay00  =p_cay00 
                                  AND cay01  =p_cay01 
                                  AND cay11  =p_cay11 
                                  AND cay02  =p_cay02 
                                  AND cay03  =p_cay03 
                                  AND cay06  =p_cay06 
                                  AND cay04  =l_ccj02
                                  AND cayacti='Y'
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1) 
                     LET g_cay[l_ac].* = g_cay_t.*
                  END IF

                  IF cl_null(l_cay05_t) THEN
                     LET l_cay05_t = l_cay05
                     LET l_cay04 = l_ccj02
                  ELSE
                     IF l_cay05 > l_cay05_t THEN
                        LET l_cay05_t = l_cay05
                        LET l_cay04 = l_ccj02
                     END IF
                  END IF
                  LET l_cay05_tot = l_cay05_tot + l_cay05    
               END FOREACH

            WHEN '7'     #標準工時
              #MOD-CC0159---mark---S
              #LET l_bdate = MDY(p_cay02,1,p_cay01)     
              #LET l_edate = MDY(p_cay02+1,1,p_cay01)-1
              #MOD-CC0159---mark---E
              #MOD-CC0159---S
               CALL s_azm(p_cay01,p_cay02)
                  RETURNING g_chr,l_bdate,l_edate
              #MOD-CC0159---E
               #先算標準工時合計
               LET l_sql = "SELECT SUM(ccj07)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')"
               PREPARE i001_t_p11 FROM l_sql
               DECLARE i001_t_c11 CURSOR FOR i001_t_p11
               OPEN i001_t_c11
               FETCH i001_t_c11 INTO l_sum
               IF cl_null(l_sum) THEN LET l_sum = 0 END IF

               LET l_sql = "SELECT ccj02,SUM(ccj07)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')",
                           " GROUP BY ccj02"
               PREPARE i001_t_p12 FROM l_sql
               DECLARE i001_t_c12 CURSOR FOR i001_t_p12
               
               MESSAGE "WORKING !"
               FOREACH i001_t_c12 INTO l_ccj02,l_ccj07
                  LET l_cay05 = l_ccj07 / l_sum
                  IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
 
                  UPDATE cay_file SET cay05  =l_cay05,
                                      caymodu=g_user,
                                      caydate=g_today
                                WHERE cay00  =p_cay00 
                                  AND cay01  =p_cay01 
                                  AND cay11  =p_cay11 
                                  AND cay02  =p_cay02 
                                  AND cay03  =p_cay03 
                                  AND cay06  =p_cay06 
                                  AND cay04  =l_ccj02
                                  AND cayacti='Y'
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1) 
                     LET g_cay[l_ac].* = g_cay_t.*
                  END IF

                  IF cl_null(l_cay05_t) THEN
                     LET l_cay05_t = l_cay05
                     LET l_cay04 = l_ccj02
                  ELSE
                     IF l_cay05 > l_cay05_t THEN
                        LET l_cay05_t = l_cay05
                        LET l_cay04 = l_ccj02
                     END IF
                  END IF
                  LET l_cay05_tot = l_cay05_tot + l_cay05    
               END FOREACH

            WHEN '8'     #標準機時
              #MOD-CC0159---mark---S
              #LET l_bdate = MDY(p_cay02,1,p_cay01)     
              #LET l_edate = MDY(p_cay02+1,1,p_cay01)-1
              #MOD-CC0159---mark---E
              #MOD-CC0159---S
               CALL s_azm(p_cay01,p_cay02)
                  RETURNING g_chr,l_bdate,l_edate
              #MOD-CC0159---E
               #先算標準機時合計
               LET l_sql = "SELECT SUM(ccj071)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')"
               PREPARE i001_t_p13 FROM l_sql
               DECLARE i001_t_c13 CURSOR FOR i001_t_p13
               OPEN i001_t_c13
               FETCH i001_t_c13 INTO l_sum
               IF cl_null(l_sum) THEN LET l_sum = 0 END IF

               LET l_sql = "SELECT ccj02,SUM(ccj071)",
                           "  FROM ccj_file",
                           " WHERE ccj01 BETWEEN '",l_bdate,"' AND '",l_edate,"'",
                           "   AND ccj02 IN (SELECT cay04 FROM cay_file",
                           "                  WHERE cay00='",p_cay00,"'", 
                           "                    AND cay01='",p_cay01,"'", 
                           "                    AND cay11='",p_cay11,"'", 
                           "                    AND cay02='",p_cay02,"'", 
                           "                    AND cay03='",p_cay03,"'", 
                           "                    AND cay06='",p_cay06,"'", 
                           "                    AND cayacti='Y')",
                           " GROUP BY ccj02"
               PREPARE i001_t_p14 FROM l_sql
               DECLARE i001_t_c14 CURSOR FOR i001_t_p14
               
               MESSAGE "WORKING !"
               FOREACH i001_t_c14 INTO l_ccj02,l_ccj071
                  LET l_cay05 = l_ccj071 / l_sum
                  IF cl_null(l_cay05) THEN LET l_cay05 = 0 END IF
 
                  UPDATE cay_file SET cay05  =l_cay05,
                                      caymodu=g_user,
                                      caydate=g_today
                                WHERE cay00  =p_cay00 
                                  AND cay01  =p_cay01 
                                  AND cay11  =p_cay11 
                                  AND cay02  =p_cay02 
                                  AND cay03  =p_cay03 
                                  AND cay06  =p_cay06 
                                  AND cay04  =l_ccj02
                                  AND cayacti='Y'
                  IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","cay_file",p_cay01,p_cay02,SQLCA.sqlcode,"","",1) 
                     LET g_cay[l_ac].* = g_cay_t.*
                  END IF

                  IF cl_null(l_cay05_t) THEN
                     LET l_cay05_t = l_cay05
                     LET l_cay04 = l_ccj02
                  ELSE
                     IF l_cay05 > l_cay05_t THEN
                        LET l_cay05_t = l_cay05
                        LET l_cay04 = l_ccj02
                     END IF
                  END IF
                  LET l_cay05_tot = l_cay05_tot + l_cay05    
               END FOREACH
            #FUN-C60047---end 
         END CASE
        #-----------------No:CHI-B30013 add
        #尾差處哩，將尾差歸在分攤比例最大那一筆
         IF l_cay05_tot != 0 AND l_cay05_tot != 1 AND NOT cl_null(l_cay04) THEN
            UPDATE cay_file SET cay05  =cay05+(1 - l_cay05_tot),
                                caymodu=g_user,
                                caydate=g_today
                          WHERE cay00  =p_cay00 
                            AND cay01  =p_cay01 
                            AND cay02  =p_cay02 
                            AND cay03  =p_cay03 
                            AND cay06  =p_cay06 
                            AND cay11  =p_cay11 
                            AND cay04  =l_cay04
                            AND cayacti='Y'
         END IF
        #-----------------No:CHI-B30013 end
   CALL i001_b_fill(" 1=1")                 #單身
   MESSAGE ""
END FUNCTION
 
#start FUN-670065 add
FUNCTION i001_g()
   DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sql,l_wc,l_wc1          STRING
   DEFINE d_cnt,a_cnt    LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE i,j            LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE tm             RECORD
                          cay11 LIKE cay_file.cay11,   #No.FUN-9B0118
                          yy    LIKE cay_file.cay01,
                          mm    LIKE cay_file.cay02,
                          d     ARRAY[10] OF LIKE cay_file.cay03,
                          a     ARRAY[10] OF LIKE cay_file.cay06,
                          b     LIKE cay_file.cay09,
                          c     LIKE cay_file.cay10,
                          cay03 LIKE cay_file.cay03,
                          cay06 LIKE cay_file.cay06,
                          cay00 LIKE cay_file.cay00,
                          cay09 LIKE cay_file.cay09,
                          cay10 LIKE cay_file.cay10,
                          cay08 LIKE cay_file.cay08,
                          cay12 LIKE cay_file.cay12    #No.FUN-9B118
                         END RECORD
   DEFINE l_cay          RECORD LIKE cay_file.*
   DEFINE g_change_lang  LIKE type_file.chr1           #No.FUN-680122 VARCHAR(1)      #是否有做語言切換
   DEFINE l_wc2          STRING  #CHI-D20021
 
   LET p_row = 6 LET p_col = 6
 
   OPEN WINDOW i001_w_g AT p_row,p_col WITH FORM "axc/42f/axci001_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axci001_g")
   #CHI-D20021---begin
   IF g_ccz.ccz06 = '1' OR g_ccz.ccz06 = '2' THEN 
      CALL cl_set_comp_visible('cay04',TRUE)
   ELSE  
      CALL cl_set_comp_visible('cay04',FALSE)
   END IF  
   #CHI-D20021---end
   
   INITIALIZE tm.* TO NULL
   LET tm.cay11 = g_aza.aza81    #No.FUN-9B0118
   LET tm.yy = g_ccz.ccz01
   LET tm.mm = g_ccz.ccz02
   DISPLAY tm.yy TO FORMONLY.yy
   DISPLAY tm.mm TO FORMONLY.mm
   LET d_cnt = 10
   LET a_cnt = 10
 
  WHILE TRUE
   INPUT BY NAME tm.cay11,tm.yy,tm.mm WITHOUT DEFAULTS    #No.FUN-9B0118
      AFTER FIELD cay11
         IF NOT cl_null(tm.cay11) THEN 
            CALL i001_cay11('a',tm.cay11)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.cay11,g_errno,0)
               LET tm.cay11 = ''
               DISPLAY BY NAME tm.cay11
               NEXT FIELD cay11
            END IF
         ELSE
            CALL cl_err(tm.cay11,'mfg5103',0)
            NEXT FIELD cay11
         END IF

      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            CALL cl_err(tm.yy,'mfg5103',0)
            NEXT FIELD yy
         END IF
 
      AFTER FIELD mm
         IF cl_null(tm.mm) THEN
            CALL cl_err(tm.mm,'mfg5103',0)
            NEXT FIELD mm
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(cay11)   #分攤來源科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.cay11
                 DISPLAY BY NAME tm.cay11
            OTHERWISE EXIT CASE
         END CASE
 
   END INPUT
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW i001_w_g 
      RETURN
   END IF
 
 
 
   INPUT BY NAME tm.cay00,tm.cay09,tm.cay10,tm.cay08,tm.cay12 WITHOUT DEFAULTS  #FUN-920010  #No.FUN-9B0118
   
   BEFORE INPUT 
     IF g_argv1 = '2' THEN
        CALL cl_set_comp_entry("cay00",TRUE)
     ELSE
        CALL cl_set_comp_entry("cay00",FALSE)
        LET tm.cay00 = '1'
        DISPLAY tm.cay00 TO FORMONLY.cay00
     END IF
     
      BEFORE FIELD cay00
         IF g_argv1 = '2' THEN
            CALL i001_set_cay00()
         END IF
   
      AFTER FIELD cay00
        IF g_argv1 = '2' THEN 
           CALL i001_set_cay00_a()
           IF NOT cl_null(tm.cay00) THEN
              IF tm.cay00 NOT matches '[23456]' THEN
                 NEXT FIELD cay00
              END IF
           END IF
        END IF
 
      BEFORE FIELD cay09
          CALL cl_set_comp_entry("cay10",TRUE)
 
      AFTER FIELD cay09              #FUN-920010  b-->cay09 
         LET g_caya.cay09 = tm.cay09 #FUN-920010  b-->cay09
         IF tm.cay09 != '2' THEN     #FUN-920010  b-->cay09
            LET tm.cay10 = ''        #FUN-920010  c-->cay10
            DISPLAY tm.cay10 TO FORMONLY.cay10   #FUN-920010  c-->cay10
         END IF
         IF tm.cay09 !='2' THEN
            CALL cl_set_comp_entry("cay10",FALSE)
         END IF
 
      AFTER FIELD cay10
         IF cl_null(tm.cay10) THEN
            CALL cl_err(tm.cay10,'mfg5103',0)
            NEXT FIELD cay10
         ELSE
            LET g_caya.cay10 = tm.cay10
            CALL i001_cay10('a',tm.cay11 )     #No.FUN-730057  #No.FUN-9B0118 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.cay10,g_errno,0)
#FUN-B10052 --begin--
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.default1 = tm.cay10
                 LET g_qryparam.arg1 = tm.cay11        
                 LET g_qryparam.construct = "N"
                 LET g_qryparam.where = " aag01 LIKE '",tm.cay10 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING tm.cay10
                 DISPLAY tm.cay10 TO FORMONLY.cay10
#FUN-B10052 --end--
               NEXT FIELD cay10
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE WHEN INFIELD(cay10)     #會計科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.default1 = tm.cay10
                 LET g_qryparam.arg1 = tm.cay11        #No.FUN-730057  #No.FUN-9B0118
                 CALL cl_create_qry() RETURNING tm.cay10
                 DISPLAY tm.cay10 TO FORMONLY.cay10
                 NEXT FIELD cay10
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
      LET INT_FLAG = 0 
      CLOSE WINDOW i001_w_g 
      RETURN
   END IF
 
 DIALOG ATTRIBUTES(UNBUFFERED)    #FUN-920108
   CONSTRUCT BY NAME l_wc ON gem01
   
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
   ON ACTION controlp
         CASE
            WHEN INFIELD(gem01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gem01
                 NEXT FIELD gem01
            WHEN INFIELD(cay06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay06
                 NEXT FIELD cay06
             OTHERWISE EXIT CASE
          END CASE
 
   AFTER CONSTRUCT
 
   END CONSTRUCT
 
   CONSTRUCT BY NAME l_wc1 ON aag01
   
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
   ON ACTION controlp
         CASE
            WHEN INFIELD(aag01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aag07"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO aag01
                 NEXT FIELD aag01
             OTHERWISE EXIT CASE
          END CASE
 
      AFTER CONSTRUCT
 
   END CONSTRUCT
#CHI-D20021---begin
   CONSTRUCT BY NAME l_wc2 ON cay04
   
   BEFORE CONSTRUCT
         CALL cl_qbe_init()
  
   ON ACTION controlp
         CASE
            WHEN INFIELD(cay04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     ="q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cay04
             OTHERWISE EXIT CASE
          END CASE
 
      AFTER CONSTRUCT
 
   END CONSTRUCT
#CHI-D20021---end  
      ON IDLE g_idle_seconds                                                                                                
          CALL cl_on_idle()                                                                                                         
          CONTINUE DIALOG                                                                                                           
                                                                                                                                    
      ON ACTION about         #MOD-4C0121                                                                                           
         CALL cl_about()      #MOD-4C0121                                                                                           
                                                                                                                                    
      ON ACTION controlg      #MOD-4C0121                                                                                           
         CALL cl_cmdask()     #MOD-4C0121                                                                                           
                                                                                                                                    
      ON ACTION help          #MOD-4C0121                                                                                           
         CALL cl_show_help()  #MOD-4C0121                                                                                           
                                                                                                                                    
      ON ACTION accept                                                                                                              
         EXIT DIALOG                                                                                                                
                                                                                                                                    
      ON ACTION cancel                                                                                                              
         LET INT_FLAG = TRUE                                                                                                        
         EXIT DIALOG                                                                                                                
                                                                                                                                    
   END DIALOG 
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW i001_w_g RETURN END IF
   IF NOT cl_confirm('abx-080') THEN    #是否確定執行 (Y/N) ?
      CLOSE WINDOW i001_w_c 
      RETURN 
   END IF
   LET l_sql="SELECT gem01 FROM gem_file ",
             " WHERE ",l_wc CLIPPED
   PREPARE i001_cay_p1 FROM l_sql
   DECLARE i001_cay_c1 CURSOR FOR i001_cay_p1
   LET l_sql="SELECT aag01 FROM aag_file ",
             " WHERE ",l_wc1 CLIPPED,
             "   AND aag07 <> '1' AND aag03 = '2' ",
             "   AND aagacti = 'Y' "
   LET l_sql=l_sql CLIPPED,"AND aag00='",tm.cay11   ,"'" 
   PREPARE i001_cay_p2 FROM l_sql
   DECLARE i001_cay_c2 CURSOR FOR i001_cay_p2
   #CHI-D20021---begin
   CALL cl_replace_str(l_wc2,"cay04","gem01") RETURNING l_wc2
   LET l_sql="SELECT gem01 FROM gem_file ",
             " WHERE ",l_wc2 CLIPPED
   PREPARE i001_cay_p3 FROM l_sql
   DECLARE i001_cay_c3 CURSOR FOR i001_cay_p3
   #CHI-D20021---end
   FOREACH i001_cay_c1 INTO tm.cay03
     IF SQLCA.sqlcode THEN
        CALL cl_err(g_caya.cay01,SQLCA.sqlcode,0)
        RETURN
     END IF
     FOREACH i001_cay_c2 INTO tm.cay06
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_caya.cay01,SQLCA.sqlcode,0)
          RETURN
       END IF
     
 
 
       #寫入資料
       #先檢查是否已經有存在資料,若有則跳過
       LET g_cnt = 0
       LET l_sql = "SELECT COUNT(*) FROM cay_file ",
                   " WHERE cay00='",tm.cay00,"'",     #FUN-920010
                   "   AND cay01='",tm.yy,"'",
                   "   AND cay02='",tm.mm,"'",
                   "   AND cay11='",tm.cay11,"'",     #No.FUN-9B0118
                   "   AND cay03='",tm.cay03,"'",     #FUN-920010
                   "   AND cay06='",tm.cay06,"'"      #FUN-920010
       PREPARE i001_g_p1 FROM l_sql
       DECLARE i001_g_c1 CURSOR FOR i001_g_p1
       OPEN i001_g_c1
       FETCH i001_g_c1 INTO g_cnt
       IF g_cnt > 0 THEN
          CONTINUE FOREACH  #FUN-920010
       END IF
 
       LET l_cay.cay00=tm.cay00           #FUN-920010
       LET l_cay.cay01=tm.yy              #年度
       LET l_cay.cay02=tm.mm              #月份
       LET l_cay.cay03=tm.cay03           #部門編號 #FUN-920010
       LET l_cay.cay04=' '                #TQC-B90005
       LET l_cay.cay05=0                  #分攤比例
       LET l_cay.cay06=tm.cay06           #會計科目#FUN-920010
       LET l_cay.cay08=tm.cay08           #部門屬性:A.直接部門 #FUN-920010
       LET l_cay.cay09=tm.cay09           #分攤比率來源   #FUN-920010
       LET l_cay.cay10=tm.cay10           #分攤來源科目   #FUN-920010
       LET l_cay.cay11=tm.cay11           #帐套           #No.FUN-9B0118
       LET l_cay.cay12=tm.cay12           #分摊方式       #No.FUN-9B0118
       LET l_cay.cayacti='Y'
       LET l_cay.cayuser=g_user
       LET l_cay.caygrup=g_grup
       LET l_cay.caymodu=''
       LET l_cay.caydate=g_today
       LET l_cay.caylegal = g_legal    #FUN-A50075
 
       #依參數選擇寫入cay04
       CASE g_ccz.ccz06
          WHEN '3'   #作業編號
            #作業編號抓取方式為針對直接部門=eca03,抓取所有eca01=ecd07,抓取ecd01
             DECLARE i001_ecd CURSOR FOR SELECT ecd01 FROM ecd_file,eca_file
                                          WHERE eca03 = tm.cay03  #FUN-920010
                                            AND eca01 = ecd07
             FOREACH i001_ecd INTO l_cay.cay04
                LET l_cay.cayoriu = g_user      #No.FUN-980030 10/01/04
                LET l_cay.cayorig = g_grup      #No.FUN-980030 10/01/04
                INSERT INTO cay_file VALUES (l_cay.* )
                IF STATUS THEN
                   CALL cl_err3("ins","cay_file",l_cay.cay01,l_cay.cay02,STATUS,"","ins_cay:",1)  #No.FUN-660127
                   CLOSE WINDOW i001_w_g
                   RETURN
                END IF
             END FOREACH
          WHEN '4'   #工作站
            #成本中心以直接部門為單身產生資料=eca03
             DECLARE i001_eca CURSOR FOR SELECT eca01 FROM eca_file
                                          WHERE eca03 = tm.cay03   #FUN-920010
             FOREACH i001_eca INTO l_cay.cay04
                INSERT INTO cay_file VALUES (l_cay.* )
                IF STATUS THEN
                   CALL cl_err3("ins","cay_file",l_cay.cay01,l_cay.cay02,STATUS,"","ins_cay:",1)  #No.FUN-660127
                   CLOSE WINDOW i001_w_g
                   RETURN
                END IF
             END FOREACH
          OTHERWISE 
             #LET l_cay.cay04=tm.cay03     #FUN-920010  #CHI-D20021
             FOREACH i001_cay_c3 INTO l_cay.cay04  #CHI-D20021
                INSERT INTO cay_file VALUES (l_cay.* )
                IF STATUS THEN
                   CALL cl_err3("ins","cay_file",l_cay.cay01,l_cay.cay02,STATUS,"","ins_cay:",1)  #No.FUN-660127
                   CLOSE WINDOW i001_w_g
                   RETURN
                END IF
             END FOREACH   #CHI-D20021
       END CASE
     END FOREACH
   END FOREACH
   EXIT WHILE
  END WHILE
  MESSAGE ""
  CLOSE WINDOW i001_w_g
END FUNCTION
 
FUNCTION i001_copy()
   DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sql        STRING
   DEFINE tm           RECORD
                        b1    LIKE aaa_file.aaa01,  #No.FUN-9B0118
                        yy1   LIKE cay_file.cay01,
                        mm1   LIKE cay_file.cay02,
                        b2    LIKE aaa_file.aaa01,  #No.FUN-9B0118
                        yy2   LIKE cay_file.cay01,
                        mm2   LIKE cay_file.cay02 
                       END RECORD
   DEFINE g_caya_new   RECORD LIKE cay_file.*
   DEFINE l_cay        RECORD LIKE cay_file.*
   DEFINE l_cay12      LIKE cay_file.cay12          #No.FUN-9B0118
 
   LET p_row = 6 LET p_col = 6
 
   OPEN WINDOW i001_w_c AT p_row,p_col WITH FORM "axc/42f/axci001_c"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axci001_c")
   INITIALIZE tm.* TO NULL

   CALL cl_set_comp_visible('b1,yy1,mm1',FALSE)
   LET tm.b1 = g_cay11
   LET tm.yy1= g_cay01
   LET tm.mm1= g_cay02
 
   INPUT BY NAME tm.b1,tm.yy1,tm.mm1,tm.b2,tm.yy2,tm.mm2 WITHOUT DEFAULTS   #No.FUN-9B0118


      AFTER FIELD b2
         IF NOT cl_null(tm.b2) THEN 
            CALL i001_cay11('a',tm.b2)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.b2,g_errno,0)
               LET tm.b2=''
               DISPLAY BY NAME tm.b2
               NEXT FIELD b2
            END IF
         ELSE
            CALL cl_err(tm.b2,'mfg5103',0)
            NEXT FIELD b2
         END IF

 
 
      AFTER FIELD yy2
         IF cl_null(tm.yy2) THEN
            CALL cl_err(tm.yy2,'mfg0037',0)
            NEXT FIELD yy2
         ELSE
            IF tm.yy2 < g_ccz.ccz01 THEN
               CALL cl_err(tm.yy2,'axc-095',0)
               NEXT FIELD yy2
            END IF
         END IF
 
      AFTER FIELD mm2
         IF cl_null(tm.mm2) THEN
            CALL cl_err(tm.mm2,'mfg0037',0)
            NEXT FIELD mm2
         ELSE
            IF tm.yy2 = g_ccz.ccz01 AND tm.mm2 < g_ccz.ccz02 THEN
               CALL cl_err(tm.mm2,'axc-095',0)
               NEXT FIELD nn2
            END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(b1)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.b1
                 DISPLAY BY NAME tm.b1
            WHEN INFIELD(b2)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.b2
                 DISPLAY BY NAME tm.b2
            OTHERWISE EXIT CASE
         END CASE
 
   END INPUT
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW i001_w_c 
      RETURN
   END IF
 
   LET l_sql = "SELECT * FROM cay_file",
               " WHERE cay00='",g_cay00,"'",
               "   AND cay01='",tm.yy1,"'",
               "   AND cay02='",tm.mm1,"'",
               "   AND cay11='",tm.b1 ,"'",   #No.FUN-9B0118
               "   AND cay03='",g_cay03,"'",
               "   AND cay06='",g_cay06,"'"
   PREPARE i001_copy FROM l_sql
   DECLARE i001_c_c1 CURSOR FOR i001_copy
 
   LET l_sql = "SELECT COUNT(*) FROM cay_file ",
               " WHERE cay00='",g_cay00,"'",
               "   AND cay01='",tm.yy2,"'",
               "   AND cay02='",tm.mm2,"'",
               "   AND cay11='",tm.b2 ,"'",   #No.FUN-9B0118
               "   AND cay03='",g_cay03,"'",
               "   AND cay06='",g_cay06,"'"
   PREPARE i001_count1 FROM l_sql
   DECLARE i001_c_c2 CURSOR FOR i001_count1
   OPEN i001_c_c2
   FETCH i001_c_c2 INTO g_cnt
   IF g_cnt > 0 THEN
      IF NOT cl_confirm('axc-096') THEN 
         CLOSE WINDOW i001_w_c 
         RETURN 
      END IF
 
      #先delete 再複製
      DELETE FROM cay_file WHERE cay00=g_cay00
                             AND cay01=tm.yy2
                             AND cay02=tm.mm2 
                             AND cay11=tm.b2      #No.FUN-9B0118
                             AND cay03=g_cay03
                             AND cay06=g_cay06
      IF SQLCA.SQLERRD[3] =0 OR STATUS THEN
         CALL cl_err3("del","cay_file",tm.yy2,tm.mm2,STATUS,"","del_cay",1)  #No.FUN-660127
         CLOSE WINDOW i001_w_c 
         RETURN 
      END IF
   END IF
 
   MESSAGE "WORKING !"
   FOREACH i001_c_c1 INTO l_cay.*
      LET l_cay.cay00=g_cay00
      LET l_cay.cay01=tm.yy2
      LET l_cay.cay02=tm.mm2
      LET l_cay.cay03=g_cay03
      LET l_cay.cay06=g_cay06
      LET l_cay.cay11=tm.b2     #No.FUN-9B0118
      LET l_cay.cayacti='Y'
      LET l_cay.cayuser=g_user
      LET l_cay.caygrup=g_grup
      LET l_cay.caymodu=''
      LET l_cay.caydate=g_today
      CALL i001_get_cay12(l_cay.cay00,l_cay.cay01,l_cay.cay02,l_cay.cay11,l_cay.cay04) RETURNING l_cay12
      IF NOT cl_null(l_cay12) THEN
         LET l_cay.cay12 = l_cay12
      END IF
      LET l_cay.cayoriu = g_user      #No.FUN-980030 10/01/04
      LET l_cay.cayorig = g_grup      #No.FUN-980030 10/01/04
      LET l_cay.caylegal = g_legal    #FUN-A50075
      INSERT INTO cay_file VALUES (l_cay.* )
      IF STATUS THEN
          CALL cl_err3("ins","cay_file",l_cay.cay01,l_cay.cay02,STATUS,"","ins_cay:",1)  #No.FUN-660127
         CLOSE WINDOW i001_w_c 
         RETURN
      END IF
   END FOREACH
   MESSAGE ""
   CLOSE WINDOW i001_w_c
   #FUN-C80046---begin
   LET g_caya.cay01 = tm.yy2
   LET g_caya.cay02 = tm.mm2
   LET g_caya.cay11 = tm.b2
   CALL i001_show()
   #FUN-C80046---end
END FUNCTION
 
FUNCTION i001_batch_copy()
   DEFINE p_row,p_col  LIKE type_file.num5          
   DEFINE l_sql        STRING
   DEFINE tm           RECORD
                        b1    LIKE cay_file.cay11,    #No.FUN-9B0118
                        yy1   LIKE cay_file.cay01,
                        mm1   LIKE cay_file.cay02,
                        b2    LIKE cay_file.cay11,    #No.FUN-9B0118
                        yy2   LIKE cay_file.cay01,
                        mm2   LIKE cay_file.cay02 
                       END RECORD
   DEFINE g_caya_new   RECORD LIKE cay_file.*
   DEFINE l_cay        RECORD LIKE cay_file.*
   DEFINE l_cay12      LIKE cay_file.cay12            #No.FUN-9B0118
   DEFINE l_where      STRING                         #MOD-980103 add 
   DEFINE l_where1     STRING                         #MOD-BA0056 add
    
   LET p_row = 6 LET p_col = 6
 
   OPEN WINDOW i001_w_c AT p_row,p_col WITH FORM "axc/42f/axci001_c"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_locale("axci001_c")
 
   INITIALIZE tm.* TO NULL
   INPUT BY NAME tm.b1,tm.yy1,tm.mm1,tm.b2,tm.yy2,tm.mm2 WITHOUT DEFAULTS  #No.FUN-9B0118
      AFTER FIELD b1
         IF NOT cl_null(tm.b1) THEN 
            CALL i001_cay11('a',tm.b1)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.b1,g_errno,0)
               LET tm.b1=''
               DISPLAY BY NAME tm.b1
               NEXT FIELD b1
            END IF
         ELSE
            CALL cl_err(tm.b1,'mfg5103',0)
            NEXT FIELD b1
         END IF

      AFTER FIELD b2
         IF NOT cl_null(tm.b2) THEN 
            CALL i001_cay11('a',tm.b2)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.b2,g_errno,0)
               LET tm.b2=''
               DISPLAY BY NAME tm.b2
               NEXT FIELD b2
            END IF
         ELSE
            CALL cl_err(tm.b2,'mfg5103',0)
            NEXT FIELD b2
         END IF

      AFTER FIELD yy1
         IF cl_null(tm.yy1) THEN
            CALL cl_err(tm.yy1,'mfg0037',0)
            NEXT FIELD yy1
         END IF
 
      AFTER FIELD mm1
         IF cl_null(tm.mm1) THEN
            CALL cl_err(tm.mm1,'mfg0037',0)
            NEXT FIELD mm1
         ELSE
            CASE g_prog
              #WHEN "axci001" LET g_cay00 ='1'                                    #MOD-BA0056 mark
              #WHEN "axci002" LET g_cay00 ='2'                                    #MDO-BA0056 mark
               WHEN "axci001" LET l_where1 = " cay00 = '1' "                      #MOD-BA0056
               WHEN "axci002" LET l_where1 = " cay00 IN ('2','3','4','5','6') "   #MOD-BA0056
            END CASE
           #MOD-BA0056 -- mark begin --
           #SELECT COUNT(*) INTO g_cnt 
           #  FROM cay_file
           # WHERE cay00=g_cay00
           #   AND cay01=tm.yy1
           #   AND cay02=tm.mm1
           #   AND cay11=tm.b1      #No.FUN-9B0118
           #MOD-BA0056 -- mark end --
            #MOD-BA0056 -- begin --
            LET l_sql = "SELECT COUNT(*) FROM cay_file",
                        " WHERE cay01=",tm.yy1,
                        "   AND cay02=",tm.mm1,
                        "   AND cay11='",tm.b1,"'",
                       #"   AND cay09 != '1'",          #MOD-C10040 mark
                        "   AND ",l_where1 CLIPPED
            PREPARE i001_batch_copy_p1 FROM l_sql
            DECLARE i001_batch_copy_c1 CURSOR FOR i001_batch_copy_p1
            OPEN i001_batch_copy_c1
            FETCH i001_batch_copy_c1 INTO g_cnt
            #MOD-BA0056 -- end --
            IF g_cnt = 0 THEN
               CALL cl_err('','mfg9089',1)
               NEXT FIELD b1        #No.FUN-9B0118
            END IF
         END IF
 
      AFTER FIELD yy2
         IF cl_null(tm.yy2) THEN
            CALL cl_err(tm.yy2,'mfg0037',0)
            NEXT FIELD yy2
         ELSE
            IF tm.yy2 < g_ccz.ccz01 THEN
               CALL cl_err(tm.yy2,'axc-095',0)
               NEXT FIELD yy2
            END IF
         END IF
 
      AFTER FIELD mm2
         IF cl_null(tm.mm2) THEN
            CALL cl_err(tm.mm2,'mfg0037',0)
            NEXT FIELD mm2
         ELSE
            IF tm.yy2 = g_ccz.ccz01 AND tm.mm2 < g_ccz.ccz02 THEN
               CALL cl_err(tm.mm2,'axc-095',0)
               NEXT FIELD nn2
            END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(b1)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.b1
                 DISPLAY BY NAME tm.b1
            WHEN INFIELD(b2)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_aaa"
                 CALL cl_create_qry() RETURNING tm.b2
                 DISPLAY BY NAME tm.b2
            OTHERWISE EXIT CASE
         END CASE
 
   END INPUT
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW i001_w_c 
      RETURN
   END IF
   IF g_prog='axci001' THEN
      LET l_where = " cay00 = '1'"
   ELSE
      LET l_where = " cay00 IN ('2','3','4','5','6') "
   END IF
 
   LET l_sql = "SELECT * FROM cay_file",
               " WHERE cay01='",tm.yy1,"'",
               "   AND cay02='",tm.mm1,"'",
               "   AND ",l_where CLIPPED    
 
   PREPARE i001_batch_copy FROM l_sql
   DECLARE i001_batch_c CURSOR FOR i001_batch_copy
 
   LET l_sql = "SELECT COUNT(*) FROM cay_file ",
              #" WHERE cay00='",g_cay00,"'",       #MOD-AB0049 mark
               " WHERE cay00= ? ",                 #MOD-AB0049 add
               "   AND cay01='",tm.yy2,"'",
               "   AND cay02='",tm.mm2,"'",
               "   AND cay11='",tm.b2 ,"'",   #No.FUN-9B0118
               "   AND cay03= ? ",
               "   AND cay04= ? ",
               "   AND cay06= ? "
    DECLARE i001_batch_c2 CURSOR FROM l_sql
 
   MESSAGE "WORKING !"
   FOREACH i001_batch_c INTO l_cay.*
    #OPEN i001_batch_c2 USING l_cay.cay03,l_cay.cay04,l_cay.cay06               #MOD-AB0049 mark 
     OPEN i001_batch_c2 USING l_cay.cay00,l_cay.cay03,l_cay.cay04,l_cay.cay06   #MOD-AB0049 add 
     FETCH i001_batch_c2 INTO g_cnt
     IF g_cnt > 0 THEN
        DELETE FROM cay_file WHERE cay00=l_cay.cay00   #MOD-980103 g_cay00 modify l_cay.cay00
                               AND cay01=tm.yy2
                               AND cay02=tm.mm2 
                               AND cay11=tm.b2       #No.FUN-9B0118  
                               AND cay03=l_cay.cay03
                               AND cay04=l_cay.cay04
                               AND cay06=l_cay.cay06
        IF SQLCA.SQLERRD[3] =0 THEN
           CALL cl_err3("del","cay_file",tm.yy2,tm.mm2,'axc-005',"","del_cay",1) 
           CLOSE WINDOW i001_w_c 
           RETURN 
        END IF
      END IF
      LET l_cay.cay01=tm.yy2
      LET l_cay.cay02=tm.mm2
      LET l_cay.cay11=tm.b2    #No.FUN-9B0118
      LET l_cay.cayacti='Y'
      LET l_cay.cayuser=g_user
      LET l_cay.caygrup=g_grup
      LET l_cay.caymodu=''
      LET l_cay.caydate=g_today
      CALL i001_get_cay12(l_cay.cay00,l_cay.cay01,l_cay.cay02,l_cay.cay11,l_cay.cay04) RETURNING l_cay12
      IF NOT cl_null(l_cay12) THEN
         LET l_cay.cay12 = l_cay12
      END IF
      LET l_cay.cayoriu = g_user      #No.FUN-980030 10/01/04
      LET l_cay.cayorig = g_grup      #No.FUN-980030 10/01/04
      LET l_cay.caylegal = g_legal    #FUN-A50075
      INSERT INTO cay_file VALUES (l_cay.* )
      IF STATUS THEN
         CALL cl_err3("ins","cay_file",l_cay.cay01,l_cay.cay02,STATUS,"","ins_cay:",1)  
         CLOSE WINDOW i001_w_c 
         RETURN
      END IF
   END FOREACH
   MESSAGE ""
   CLOSE WINDOW i001_w_c
END FUNCTION
 
FUNCTION i001_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc            STRING
 
   LET g_sql = "SELECT cay04,'',cay12,cay05,cayacti",  #No.FUN-9B0118
               "  FROM cay_file",
               " WHERE cay00 = '",g_cay00,"'",
               "   AND cay01 = '",g_cay01,"'",
               "   AND cay02 = '",g_cay02,"'",
               "   AND cay03 = '",g_cay03,"'",
               "   AND cay06 = '",g_cay06,"'",
               "   AND cay11 = '",g_cay11,"'",   #No.FUN-9B0118
               "   AND ",p_wc CLIPPED ,
               " ORDER BY cay04"
    PREPARE i001_prepare2 FROM g_sql      #預備一下
    IF SQLCA.SQLCODE THEN
       CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
       RETURN
    END IF
    DECLARE i001_b_c1 CURSOR FOR i001_prepare2
    CALL g_cay.clear()
    LET g_cnt = 1
    FOREACH i001_b_c1 INTO g_cay[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       CALL i001_cay04(g_cay[g_cnt].cay04) RETURNING g_cay[g_cnt].gem02_b
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cay.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cay TO s_cay.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i001_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i001_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i001_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i001_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i001_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
         
      ON ACTION reproduce1
         LET g_action_choice="reproduce1"
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
 
      #@ON ACTION 重新計算
      ON ACTION recalculate
         LET g_action_choice="recalculate"
         EXIT DISPLAY
 
      #@ON ACTION 批次產生
      ON ACTION generate
         LET g_action_choice="generate"
         EXIT DISPLAY
 
     #整批計算
      ON ACTION recalculate1
         LET g_action_choice="recalculate1"
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
 
      ON ACTION controls                             #No.FUN-6A0092                                                                 
         CALL cl_set_head_visible("","AUTO")         #No.FUN-6A0092
        
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i001_r()
   IF g_cay01 IS NULL OR g_cay02 IS NULL OR
      g_cay03 IS NULL OR g_cay06 IS NULL THEN
      CALL cl_err("",-400,0)                        #No.FUN-6A0019 
      RETURN 
   END IF
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM cay_file WHERE cay00 = g_cay00
                             AND cay01 = g_cay01
                             AND cay02=  g_cay02
                             AND cay03 = g_cay03
                             AND cay06 = g_cay06
                             AND cay11 = g_cay11    #No.FUN-9B0118
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","cay_file",g_cay01,g_cay02,SQLCA.sqlcode,"","BODY DELETE",1)  #No.FUN-660127
      ELSE
         CLEAR FORM
         CALL g_cay.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         DROP TABLE x
         PREPARE i001_precount_x2 FROM g_sql_tmp  #No.TQC-720019
         EXECUTE i001_precount_x2                 #No.TQC-720019
         OPEN i001_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE i001_b_cs
            CLOSE i001_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH i001_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i001_b_cs
            CLOSE i001_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i001_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i001_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE  #No.FUN-6A0075
            CALL i001_fetch('/')
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION i001_set_cay00()                                                                                                           
DEFINE lcbo_target ui.ComboBox                                                                                                      
                                                                                                                                    
   LET lcbo_target = ui.ComboBox.forName("cay00")                                                                                   
      CALL lcbo_target.RemoveItem("1")                                                                                              
END FUNCTION            
                                                                                                            
#MOD-D30086 srt add-----
FUNCTION i001_set_required()

  CALL cl_set_comp_required("cay04",TRUE)

END FUNCTION

FUNCTION i001_set_no_required()

  IF g_ccz.ccz06 != '2' THEN
     CALL cl_set_comp_required("cay04",FALSE)
  END IF

END FUNCTION
#MOD-D30086 end add-----
                                                                                                                                    
FUNCTION i001_set_cay00_a()                                                                                                          
   DEFINE lcbo_target ui.ComboBox                                                                                                   
   DEFINE l_str       STRING                                                                                                        
   DEFINE l_ze03 LIKE ze_file.ze03                                                                                                  
   SELECT ze03 INTO l_ze03 FROM ze_file                                                                                             
   WHERE ze01='axc-006'                                                                                                             
     AND ze02=g_lang                                                                                                                
                                                                                                                                    
   LET lcbo_target = ui.ComboBox.forName("cay00")                                                                                   
   LET l_str = l_ze03                                                                                                               
   CALL lcbo_target.AddItem("1",l_str)                                                                                              
END FUNCTION   
 
FUNCTION i001_out()
   DEFINE l_cmd   LIKE type_file.chr1000
   DEFINE l_wc    STRING
   DEFINE l_wc1   STRING

    LET l_wc  = g_wc 
    IF cl_null(g_wc) AND NOT cl_null(g_caya.cay00)
                     AND NOT cl_null(g_caya.cay11)
                     AND NOT cl_null(g_caya.cay01)
                     AND NOT cl_null(g_caya.cay02)
                     AND NOT cl_null(g_caya.cay03)
                     AND NOT cl_null(g_caya.cay06)
                     AND NOT cl_null(g_caya.cay08)
                     AND NOT cl_null(g_caya.cay09)
                     AND NOT cl_null(g_caya.cay10) THEN
       LET g_wc="     cay00 = '",g_caya.cay00,"'",
                " AND cay11 = '",g_caya.cay11,"'",
                " AND cay01 = '",g_caya.cay01,"'",
                " AND cay02 = '",g_caya.cay02,"'",
                " AND cay03 = '",g_caya.cay03,"'",
                " AND cay06 = '",g_caya.cay06,"'",
                " AND cay08 = '",g_caya.cay08,"'",
                " AND cay09 = '",g_caya.cay09,"'",
                " AND cay10 = '",g_caya.cay10,"'"
    END IF
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0)
       RETURN
    END IF
    IF g_caya.cay00 = '1' THEN   #人工
       LET l_cmd = 'p_query "axci001" "',g_wc CLIPPED,'"'
    ELSE
       LET l_cmd = 'p_query "axci002" "',g_wc CLIPPED,'"'
    END IF
    CALL cl_cmdrun(l_cmd)
    LET g_wc  = l_wc    #MOD-960319 add

END FUNCTION
 

FUNCTION i001_check_cay12(p_cmd,p_cay00,p_cay01,p_cay02,p_cay03,p_cay04,p_cay06,p_cay11,p_cay12)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE p_cay00         LIKE cay_file.cay00
   DEFINE p_cay01         LIKE cay_file.cay01
   DEFINE p_cay02         LIKE cay_file.cay02
   DEFINE p_cay03         LIKE cay_file.cay03
   DEFINE p_cay04         LIKE cay_file.cay04
   DEFINE p_cay06         LIKE cay_file.cay06
   DEFINE p_cay11         LIKE cay_file.cay11
   DEFINE p_cay12         LIKE cay_file.cay12
   DEFINE l_cay12         LIKE cay_file.cay12
   DEFINE l_cnt           LIKE type_file.num5


   IF p_cay00 IS NULL OR p_cay01 IS NULL OR p_cay02 IS NULL OR 
      p_cay11 IS NULL OR p_cay04 IS NULL OR p_cay12 IS NULL THEN
      RETURN
   END IF

   LET g_errno = NULL

   SELECT UNIQUE cay12 INTO l_cay12 FROM cay_file
    WHERE cay00 = p_cay00
      AND cay01 = p_cay01
      AND cay02 = p_cay02
      AND cay04 = p_cay04
      AND cay11 = p_cay11
      AND NOT (cay00 = p_cay00 AND cay01 = p_cay01 AND cay02 = p_cay02 AND cay03 = p_cay03
           AND cay04 = p_cay04 AND cay06 = p_cay06 AND cay11 = p_cay11)
   IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
      LET g_errno = SQLCA.sqlcode
      RETURN
   END IF


   IF NOT cl_null(l_cay12) THEN
      IF l_cay12 <> p_cay12 THEN
         LET g_errno = 'axc-086'
         RETURN
      END IF
   END IF
   
END FUNCTION

FUNCTION i001_get_cay12(p_cay00,p_cay01,p_cay02,p_cay11,p_cay04)
   DEFINE p_cay00         LIKE cay_file.cay00
   DEFINE p_cay01         LIKE cay_file.cay01
   DEFINE p_cay02         LIKE cay_file.cay02
   DEFINE p_cay11         LIKE cay_file.cay11
   DEFINE p_cay04         LIKE cay_file.cay04
   DEFINE l_cay12         LIKE cay_file.cay12


   IF p_cay00 IS NULL OR p_cay01 IS NULL OR p_cay02 IS NULL OR 
      p_cay11 IS NULL OR p_cay04 IS NULL THEN
      RETURN NULL
   END IF

   SELECT UNIQUE cay12 INTO l_cay12 FROM cay_file
    WHERE cay00 = p_cay00
      AND cay01 = p_cay01
      AND cay02 = p_cay02
      AND cay11 = p_cay11
      AND cay04 = p_cay04
   IF SQLCA.sqlcode THEN
      RETURN NULL
   END IF
   RETURN l_cay12
   
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/08
