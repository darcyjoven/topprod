# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi520.4gl
# Descriptions...: 產品價格維護作業
# Date & Author..: 02/08/05 By Carrier
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: NO.MOD-530335 05/03/28 By Mandy 1.價格條件開窗時會篩選出取價方式為4.依價格表取價的價格條件編號, 但直接輸入時未檢查取價方式是否符合.
# Modify.........: NO.MOD-530335 05/03/28 By Mandy 2.幣別開窗時會篩選出有效的幣別代碼, 但直接輸入時未檢查幣別代碼是否有效.
# Modify.........: No.FUN-560193 05/06/28 By kim 單身 '單位' 改名為 '銷售單位', 並於其右邊增秀 '計價單位'
# Modify.........: No.MOD-5A0148 05/10/21 By Nicola 列印增加"單位"欄位
# Modify.........: No.TQC-5B0029 05/11/07 By Nicola 列印位置調整
# Modify.........: No.MOD-5A0455 05/11/21 By Nicola 單身sql少一個欄位
# Modify.........: No.FUN-5B0116 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-620009 06/05/22 By Pengu 新增 "複製" 功能，提供使用者複製價格條件
# Modify.........: No.FUN-650086 06/05/23 By Sarah 增加依照參數sma116來判斷要不要顯示計價單位
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time  
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6A0020 06/11/21 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-720019 07/03/02 By carrier 連續刪除2筆翻頁不正確
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-790001 07/09/03 By jamie PK問題
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
# Modify.........: No.FUN-960130 09/08/06 By Sunyanchun GP5.2 oah03取價方式,不再用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990160 09/09/16 By lilingyu 自動生成單身時,料件編號的欄位增加開窗功能
# Modify.........: No.TQC-990067 09/09/16 By lilingyu 帶出單身后,點擊確定時無法顯示資料
# Modify.........: No.FUN-9B0016 09/10/31 By post no 
# Modify.........: No.FUN-9C0163 09/12/28 By Cockroach 增加xme00字段區分axmi520/530單頭 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu 全系統增加料件管控
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B80198 11/08/26 By lixia 查詢欄位
# Modify.........: No:MOD-BA0037 11/10/07 By Summer AFTER FIELD xme02 的地方加上xme00的條件(xme00='1')
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.MOD-D40130 13/04/18 By SunLM 刪除的同時插入azo_file 
# Modify.........: No.TQC-D70002 13/07/01 By lujh 單頭錄入完成後會彈出axmi5201的窗口，其中“分群碼”欄位建議增加開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_xme           RECORD LIKE xme_file.*,  #NO.FUN-9b0016
    g_xme_t         RECORD LIKE xme_file.*,
    g_xme_o         RECORD LIKE xme_file.*,
    g_xme01_t       LIKE xme_file.xme01,
    g_xme02_t       LIKE xme_file.xme02,
    g_xmf           DYNAMIC ARRAY OF RECORD
        xmf03       LIKE xmf_file.xmf03,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        ta_xmf01    LIKE xmf_file.ta_xmf01,
        ta_xmf01_desc LIKE occ_file.occ02,
        xmf04       LIKE xmf_file.xmf04,
        ima908      LIKE ima_file.ima908,  #FUN-560193
        xmf05       LIKE xmf_file.xmf05,
        xmf07       LIKE xmf_file.xmf07,
        ta_xmf03    LIKE xmf_file.ta_xmf03,#add by guanyao160715
        xmf08       LIKE xmf_file.xmf08,
        ta_xmf04    LIKE xmf_file.ta_xmf04, #add by huanglf170317
        ta_xmf05    LIKE xmf_file.ta_xmf05  #add by huanglf170317
                    END RECORD,
    g_xmf_o         RECORD
        xmf03       LIKE xmf_file.xmf03,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        ta_xmf01    LIKE xmf_file.ta_xmf01,
        ta_xmf01_desc LIKE occ_file.occ02,
        xmf04       LIKE xmf_file.xmf04,
        ima908      LIKE ima_file.ima908,  #FUN-560193
        xmf05       LIKE xmf_file.xmf05,
        xmf07       LIKE xmf_file.xmf07,
        ta_xmf03    LIKE xmf_file.ta_xmf03,#add by guanyao160715
        xmf08       LIKE xmf_file.xmf08,
        ta_xmf04    LIKE xmf_file.ta_xmf04, #add by huanglf170317
        ta_xmf05    LIKE xmf_file.ta_xmf05  #add by huanglf170317
                    END RECORD,
    g_xmf_t         RECORD
        xmf03       LIKE xmf_file.xmf03,
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        ta_xmf01    LIKE xmf_file.ta_xmf01,
        ta_xmf01_desc LIKE occ_file.occ02,
        xmf04       LIKE xmf_file.xmf04,
        ima908      LIKE ima_file.ima908,  #FUN-560193
        xmf05       LIKE xmf_file.xmf05,
        xmf07       LIKE xmf_file.xmf07,
        ta_xmf03    LIKE xmf_file.ta_xmf03,#add by guanyao160715
        xmf08       LIKE xmf_file.xmf08,
        ta_xmf04    LIKE xmf_file.ta_xmf04, #add by huanglf170317
        ta_xmf05    LIKE xmf_file.ta_xmf05  #add by huanglf170317
                    END RECORD,
   #g_wc,g_wc2,g_sql    LIKE type_file.chr1000,  #No.FUN-680137 VARCHAR(800)
    g_wc,g_wc2,g_sql    STRING,   #TQC-630166  
    g_wd                LIKE type_file.chr1,     #No.FUN-680137 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,         #單身筆數     #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT   #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE g_sql_tmp    STRING   #No.TQC-720019
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE   g_gec07        LIKE gec_file.gec07          #add by guanyao160715
 
MAIN
#   DEFINE l_time        LIKE type_file.chr8          #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1)     #No.MOD-580088  HCN 20050818   #NO.FUN-6A0094
      RETURNING g_time                            #NO.FUN-6A0094 
 
   LET g_wd = " "
 
  #LET g_forupd_sql = "SELECT * FROM xme_file WHERE xme01=? AND xme02=?  FOR UPDATE"    #FUN-9C0163 MARK
   LET g_forupd_sql = "SELECT * FROM xme_file WHERE xme00='1' AND xme01=? AND xme02=? AND ta_xme01=?  FOR UPDATE"  #FUN-9C0163 ADD 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i520_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 3 LET p_col = 3
   OPEN WINDOW i520_w AT p_row,p_col
     WITH FORM "axm/42f/axmi520" ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #start FUN-650086 add
   IF (g_sma.sma116 MATCHES '[01]') THEN    #No.FUN-610076
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF
   #end FUN-650086 add
 
   CALL i520_menu()
 
   CLOSE WINDOW i520_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094 
      RETURNING g_time                                  #NO.FUN-6A0094 
 
END MAIN
 
FUNCTION i520_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_xmf.clear()
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_xme.* TO NULL      #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON xme01,xme02,xme06,
                             xmeuser,xmegrup,xmemodu,xmedate
                             ,xmeoriu,xmeorig    #TQC-B80198
                             ,ta_xme01           #add by guanyao160711
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(xme01)
#               CALL q_oah1(0,0,g_xme.xme01) RETURNING g_xme.xme01
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oah1"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO xme01
                NEXT FIELD xme01
             WHEN INFIELD(xme02)
#               CALL q_azi(0,0,g_xme.xme02) RETURNING g_xme.xme02
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO xme02
                NEXT FIELD xme02
            #str----add by guanyao160711
            WHEN INFIELD(ta_xme01)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gec"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ta_xme01
                NEXT FIELD ta_xme01
            #end----add by guanyao160711
             OTHERWISE
               EXIT CASE
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
   #      LET g_wc = g_wc clipped," AND xmeuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND xmegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND xmegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('xmeuser', 'xmegrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON xmf03,xmf04,xmf05,xmf07,xmf08,ta_xmf03,ta_xmf04,ta_xmf05  #add by huanglf170317
           FROM s_xmf[1].xmf03,s_xmf[1].xmf04,s_xmf[1].xmf05,
                s_xmf[1].xmf07,s_xmf[1].xmf08,s_xmf[1].ta_xmf03,
                s_xmf[1].ta_xmf04,s_xmf[1].ta_xmf05   #add by huanglf170317
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(xmf03)
#              CALL q_ima(10,3,g_xmf[1].xmf03) RETURNING g_xmf[1].xmf03
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.state = 'c'
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO xmf03
               NEXT FIELD xmf03
            WHEN INFIELD(xmf04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.state = 'c'
               LET g_qryparam.default1 = g_xmf[1].xmf04
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO xmf04
               NEXT FIELD xmf04
            OTHERWISE
               EXIT CASE
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
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN
      LET g_sql = "SELECT xme01,xme02,ta_xme01 FROM xme_file ",
                 #" WHERE ",g_wc CLIPPED,                  #FUN-9C0163 MARK
                 #" ORDER BY 1,2"                          #FUN-9C0163 MARK
                  " WHERE xme00='1' AND ",g_wc CLIPPED,   #FUN-9C0163 ADD
                  " ORDER BY xme01,xme02 "               #FUN-9C0163 ADD
   ELSE
      LET g_sql = "SELECT  DISTINCT xme01,xme02,ta_xme01 ",
                  "  FROM xme_file,xmf_file",
                  " WHERE xme01 = xmf01 ",
                  "   AND xme00 = '1' ",                     #FUN-9C0163 ADD
                  "   AND xme02 = xmf02 AND ", g_wc CLIPPED,
                  "   AND ta_xme01 = ta_xmf02",   #add by guanyao160711
                  "   AND ",g_wc2 CLIPPED,
                  " ORDER BY 1,2"
   END IF
 
   PREPARE i520_prepare FROM g_sql
   IF STATUS THEN
      CALL cl_err('pre',STATUS,1)
   END IF
 
   DECLARE i520_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i520_prepare
 
   IF g_wc2 = " 1=1" THEN
#     LET g_sql="SELECT COUNT(*) FROM xme_file WHERE ",g_wc CLIPPED      #No.TQC-720019
      LET g_sql_tmp="SELECT DISTINCT xme01,xme02,ta_xme01 FROM xme_file WHERE xme00='1' AND ",g_wc CLIPPED, #No.TQC-720019 #FUN-9C0163 ADD xme00
                    "  INTO TEMP x "  #No.TQC-720019
   ELSE
#     LET g_sql="SELECT DISTINCT xme01,xme02 ",      #No.TQC-720019
      LET g_sql_tmp="SELECT DISTINCT xme01,xme02,ta_xme01 ",  #No.TQC-720019
                "  FROM xme_file,xmf_file ",
                " WHERE xme01=xmf01 AND xme02=xmf02 ",
                "   AND xme00 = '1' ",             #FUN-9C0163 ADD      
                "   AND ta_xme01 = ta_xmf02",   #add by guanyao160711   
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                "  INTO TEMP x "
   END IF
   #No.TQC-720019  --Begin
   DROP TABLE x
#  PREPARE i520_precount_x  FROM g_sql      #No.TQC-720019
   PREPARE i520_precount_x  FROM g_sql_tmp  #No.TQC-720019
   EXECUTE i520_precount_x
   LET g_sql="SELECT COUNT(*) FROM x "
   #No.TQC-720019  --End  
 
   PREPARE i520_precount FROM g_sql
   IF STATUS THEN
      CALL cl_err('pre',STATUS,1)
   END IF
 
   DECLARE i520_count CURSOR FOR i520_precount
 
END FUNCTION
 
FUNCTION i520_menu()
   WHILE TRUE
      CALL i520_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i520_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i520_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i520_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i520_u()
            END IF
    #------------------No.FUN-620009 add
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i520_copy()
            END IF
    #------------------No.FUN-620009 end
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i520_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i520_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_xmf),'','')
            END IF
         #No.FUN-6A0020-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_xme.xme01 IS NOT NULL THEN
                LET g_doc.column1 = "xme01"
                LET g_doc.column2 = "xme02"
                LET g_doc.value1 = g_xme.xme01
                LET g_doc.value2 = g_xme.xme02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0020-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i520_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_xme.* TO NULL              #No.FUN-6A0020  
 
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   DISPLAY '   ' TO FORMONLY.cnt
   CALL g_xmf.clear()
 
   CALL i520_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   OPEN i520_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_xme.* TO NULL
   ELSE
      OPEN i520_count
      FETCH i520_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i520_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i520_fetch(p_flag)
   DEFINE p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i520_cs INTO 
                                           g_xme.xme01,g_xme.xme02,g_xme.ta_xme01  #add g_xme.ta_xme01 by guanyao160711
      WHEN 'P' FETCH PREVIOUS i520_cs INTO 
                                           g_xme.xme01,g_xme.xme02,g_xme.ta_xme01  #add g_xme.ta_xme01 by guanyao160711
      WHEN 'F' FETCH FIRST    i520_cs INTO 
                                           g_xme.xme01,g_xme.xme02,g_xme.ta_xme01  #add g_xme.ta_xme01 by guanyao160711
      WHEN 'L' FETCH LAST     i520_cs INTO 
                                           g_xme.xme01,g_xme.xme02,g_xme.ta_xme01  #add g_xme.ta_xme01 by guanyao160711
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
        FETCH ABSOLUTE g_jump i520_cs INTO 
                                           g_xme.xme01,g_xme.xme02,g_xme.ta_xme01 #add g_xme.ta_xme01 by guanyao160711
        LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)
      INITIALIZE g_xme.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_xme.* FROM xme_file WHERE xme01 = g_xme.xme01 AND xme02=g_xme.xme02
                                         AND xme00 = '1'                      #FUN-9C0163 ADD 
                                         AND ta_xme01 = g_xme.ta_xme01   #add by guanyao160711
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)   #No.FUN-660167
      CALL cl_err3("sel","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
      INITIALIZE g_xme.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_xme.xmeuser      #FUN-4C0057 add
   LET g_data_group = g_xme.xmegrup      #FUN-4C0057 add
 
   CALL i520_show()
 
END FUNCTION
 
FUNCTION i520_show()
   DEFINE l_oah02 LIKE oah_file.oah02
   DEFINE l_gec02 LIKE gec_file.gec02    #add by guanyao160711
 
   LET g_xme_t.* = g_xme.*                      #保存單頭舊值
 
   SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01 = g_xme.xme01
 
   DISPLAY BY NAME g_xme.xme01,g_xme.xme02,g_xme.xme06, g_xme.xmeoriu,g_xme.xmeorig,
                   g_xme.xmeuser,g_xme.xmegrup,g_xme.xmemodu,g_xme.xmedate
                   ,g_xme.ta_xme01  #add by guanyao160711
   #str----add by guanyao160711
   SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01= g_xme.ta_xme01
   DISPLAY l_gec02 TO gec02
   #end----add by guanyao160711
   DISPLAY l_oah02 TO FORMONLY.oah02
   #str-----add by guanyao160715
   LET g_gec07 = ''
   SELECT gec07 INTO g_gec07 FROM gec_file WHERE gec01 = g_xme.ta_xme01
   #end-----add by guanyao160715
 
#TQC-990067 --begin--
 IF cl_null(g_wc2) THEN 
    CALL i520_b_fill("1=1")
 ELSE
#TQC-990067 --end-- 	   
   CALL i520_b_fill(g_wc2)                 #單身
 END IF  #TQC-990067 
 
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION i520_a()
 
   IF s_shut(0) THEN RETURN END IF
 
   MESSAGE ""
   CLEAR FORM
   CALL g_xmf.clear()
   INITIALIZE g_xme.* LIKE xme_file.*             #DEFAULT 設定
   LET g_xme01_t = NULL
   LET g_xme02_t = NULL
   #預設值及將數值類變數清成零
   LET g_xme_t.* = g_xme.*
   LET g_xme_o.* = g_xme.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_xme.xmeuser=g_user
      LET g_xme.xmeoriu = g_user #FUN-980030
      LET g_xme.xmeorig = g_grup #FUN-980030
      LET g_xme.xmegrup=g_grup
      LET g_xme.xmedate=g_today
      LET g_xme.xme00 = '1'     #FUN-9C0163 ADD
      CALL i520_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_xme.xme01) OR cl_null(g_xme.xme02) THEN    # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      INSERT INTO xme_file VALUES (g_xme.*)
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#        CALL cl_err(g_xme.xme01,SQLCA.sqlcode,1)   #No.FUN-660167
         CALL cl_err3("ins","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
         CONTINUE WHILE
      END IF
 
      LET g_xme_t.* = g_xme.*
      CALL g_xmf.clear()
      LET g_rec_b=0                   #No.FUN-680064
      CALL i520_b()                   #輸入單身
 
      SELECT xme01,xme02 INTO g_xme.xme01,g_xme.xme02 FROM xme_file
       WHERE xme01 = g_xme.xme01
         AND xme02 = g_xme.xme02 AND xme00 = '1'            #FUN-9C0163 ADD
      LET g_xme01_t = g_xme.xme01        #保留舊值
      LET g_xme02_t = g_xme.xme02        #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i520_i(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_oah02         LIKE oah_file.oah02,
          l_n             LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_x             LIKE type_file.num5     #add by guanyao160711
   DEFINE l_gec02         LIKE gec_file.gec02     #add by guanyao160711
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INPUT BY NAME g_xme.xme01,g_xme.xme02,g_xme.xme06, g_xme.xmeoriu,g_xme.xmeorig,
                 g_xme.xmeuser,g_xme.xmegrup,g_xme.xmedate
                 ,g_xme.ta_xme01      #add by guanyao160711
                 WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i520_set_entry(p_cmd)
         CALL i520_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD xme01
         IF NOT cl_null(g_xme.xme01) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_xme.xme01 != g_xme_t.xme01) THEN
               SELECT oah02 INTO l_oah02 FROM oah_file
                WHERE oah01 = g_xme.xme01
                  #AND oah03 = '4' #MOD-530335   #NO.FUN-960130
               IF STATUS THEN
#                 CALL cl_err(g_xme.xme01,'mfg4101',0)   #No.FUN-660167
                  CALL cl_err3("sel","oah_file",g_xme.xme01,"","mfg4101","","",1)  #No.FUN-660167
                  NEXT FIELD xme01
               END IF
               DISPLAY l_oah02 TO FORMONLY.oah02
            END IF
         END IF
 
      AFTER FIELD xme02
         IF NOT cl_null(g_xme.xme02) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_xme.xme02 != g_xme_t.xme02) THEN
               SELECT azi01 FROM azi_file
                WHERE azi01 = g_xme.xme02
                  AND aziacti = 'Y' #MOD-530335
               IF STATUS THEN
#                 CALL cl_err(g_xme.xme02,'mfg3008',0)   #No.FUN-660167
                  CALL cl_err3("sel","azi_file",g_xme.xme02,"","mfg3008","","",1)  #No.FUN-660167
                  NEXT FIELD xme02
               END IF
            END IF
            IF p_cmd = "a" OR (p_cmd = "u" AND
               (g_xme.xme01 != g_xme01_t OR g_xme.xme02 != g_xme02_t OR g_xme.ta_xme01 != g_xme_t.ta_xme01)) THEN
               SELECT COUNT(*) INTO l_n FROM xme_file
                WHERE xme01 = g_xme.xme01
                  AND xme02 = g_xme.xme02
                  AND ta_xme01 = g_xme.ta_xme01   #add by guanyao160715
                  AND xme00 = '1'       #MOD-BA0037 add
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_xme.xme01,-239,0)
                  NEXT FIELD xme02
               END IF
            END IF
         END IF

      #str-----add by guanyao160711
      AFTER FIELD ta_xme01
         IF NOT cl_null(g_xme.ta_xme01) THEN 
            LET l_x = 0 
            SELECT COUNT(*) INTO l_x FROM gec_file WHERE gec01 = g_xme.ta_xme01 AND gec011 = '2'
            IF l_x = 0 OR cl_null(l_x) THEN 
               CALL cl_err(g_xme.ta_xme01,'axr-089',0)
               NEXT FIELD ta_xme01
            END IF
            IF p_cmd = "a" OR (p_cmd = "u" AND
               (g_xme.xme01 != g_xme01_t OR g_xme.xme02 != g_xme02_t OR g_xme.ta_xme01 != g_xme_t.ta_xme01)) THEN
               SELECT COUNT(*) INTO l_n FROM xme_file
                WHERE xme01 = g_xme.xme01
                  AND xme02 = g_xme.xme02
                  AND ta_xme01 = g_xme.ta_xme01   #add by guanyao160715
                  AND xme00 = '1'       #MOD-BA0037 add
               IF l_n > 0 THEN                  # Duplicated
                  CALL cl_err(g_xme.xme01,-239,0)
                  NEXT FIELD ta_xme01
               END IF
            END IF
            SELECT gec02 INTO l_gec02 FROM gec_file WHERE gec01 = g_xme.ta_xme01
            DISPLAY l_gec02 TO gec02
            #str-----add by guanyao160715
            LET g_gec07 = ''
            SELECT gec07 INTO g_gec07 FROM gec_file WHERE gec01 = g_xme.ta_xme01
            #end-----add by guanyao160715
         END IF 
      #end-----add by guanyao160711
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(xme01)
#              CALL q_oah1(0,0,g_xme.xme01) RETURNING g_xme.xme01
#              CALL FGL_DIALOG_SETBUFFER( g_xme.xme01 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oah1"
               LET g_qryparam.default1 = g_xme.xme01
               CALL cl_create_qry() RETURNING g_xme.xme01
#              CALL FGL_DIALOG_SETBUFFER( g_xme.xme01 )
               DISPLAY BY name g_xme.xme01
               NEXT FIELD xme01
            WHEN INFIELD(xme02)
#              CALL q_azi(0,0,g_xme.xme02) RETURNING g_xme.xme02
#              CALL FGL_DIALOG_SETBUFFER( g_xme.xme02 )
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_xme.xme02
               CALL cl_create_qry() RETURNING g_xme.xme02
#              CALL FGL_DIALOG_SETBUFFER( g_xme.xme02 )
               DISPLAY BY name g_xme.xme02
               NEXT FIELD xme02
            #str-----add by guanyao160711
            WHEN INFIELD(ta_xme01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gec"
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 = g_xme.ta_xme01
               CALL cl_create_qry() RETURNING g_xme.ta_xme01
               DISPLAY BY name g_xme.ta_xme01                            
               NEXT FIELD ta_xme01
           #end-----add by guanyao160711
            OTHERWISE
               EXIT CASE
         END CASE
      #MOD-650015 --start
      # ON ACTION CONTROLO                        # 沿用所有欄位
      #    IF INFIELD(xme01) THEN
      #       LET g_xme.* = g_xme_t.*
      #       CALL i520_show()
      #       NEXT FIELD xme01
      #    END IF
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
 
FUNCTION i520_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_xme.xme01 IS NULL OR g_xme.xme02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_xme01_t = g_xme.xme01
   LET g_xme02_t = g_xme.xme02
 
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN i520_cl USING g_xme.xme01,g_xme.xme02,g_xme.ta_xme01   #add  g_xme.ta_xme01 by guanyao160711
   IF STATUS THEN
      CALL cl_err("OPEN i520_cl:", STATUS, 1)
      CLOSE i520_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i520_cl INTO g_xme.*                  # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)   # 資料被他人LOCK
      CLOSE i520_cl
      RETURN
   END IF
 
   CALL i520_show()
 
   WHILE TRUE
      LET g_xme01_t = g_xme.xme01
      LET g_xme02_t = g_xme.xme02
      LET g_xme.xmemodu = g_user
      LET g_xme.xmedate = g_today
      LET g_xme.xme00   = '1'     #FUN-9C0163 ADD 
      CALL i520_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_xme.*=g_xme_t.*
         CALL i520_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_xme.xme01 != g_xme01_t OR g_xme.xme02 != g_xme02_t THEN
         UPDATE xmf_file SET xmf01 = g_xme.xme01,
                             xmf02 = g_xme.xme02
          WHERE xmf01 = g_xme01_t
            AND xmf02 = g_xme02_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd xmf',SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","xmf_file",g_xme01_t,g_xme02_t,SQLCA.sqlcode,"","upd xmf",1)  #No.FUN-660167
            ROLLBACK WORK
            RETURN
         END IF
 
#FUN-9C0163  MARK START-----------------------------------------------------------
#        UPDATE xmg_file SET xmg01 = g_xme.xme01,
#                            xmg02 = g_xme.xme02
#         WHERE xmg01 = g_xme01_t
#           AND xmg02 = g_xme02_t
#        IF SQLCA.sqlcode THEN
##          CALL cl_err('upd xmg',SQLCA.sqlcode,0)   #No.FUN-660167
#           CALL cl_err3("upd","xmg_file",g_xme01_t,g_xme02_t,SQLCA.sqlcode,"","upd xmg",1)  #No.FUN-660167
#           ROLLBACK WORK
#           RETURN
#        END IF
#FUN-9C0163  MARK END-----------------------------------------------------------
      END IF
 
      UPDATE xme_file SET xme_file.* = g_xme.*       #更改單頭
       WHERE xme01 = g_xme01_t AND xme02=g_xme02_t
         AND xme00 = '1'     #FUN-9C0163  add

      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)   #No.FUN-660167
         CALL cl_err3("upd","xme_file",g_xme01_t,g_xme02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660167
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
   CLOSE i520_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF
 
END FUNCTION
 
FUNCTION i520_r()
   DEFINE l_chr LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
   DEFINE l_t   LIKE azo_file.azo05         #MOD-D40130 add
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_xme.xme01) OR cl_null(g_xme.xme02) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN i520_cl USING g_xme.xme01,g_xme.xme02,g_xme.ta_xme01  #add by guanyao160711
   IF STATUS THEN
      CALL cl_err("OPEN i520_cl:", STATUS, 1)
      CLOSE i520_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i520_cl INTO g_xme.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)
      RETURN
   END IF
 
   CALL i520_show()
 
   IF cl_delh(20,16) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "xme01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "xme02"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_xme.xme01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_xme.xme02      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      MESSAGE "Delete xme,xmf,xmg!"
 
      DELETE FROM xme_file
       WHERE xme01 = g_xme.xme01
         AND xme02 = g_xme.xme02
         AND xme00 = g_xme.xme00   #FUN-9C0163 ADD 
      IF SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('No xme deleted','',0)   #No.FUN-660167
         CALL cl_err3("del","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","No xme deleted",1)  #No.FUN-660167
         ROLLBACK WORK
         RETURN
      END IF
 
      DELETE FROM xmf_file
       WHERE xmf01 = g_xme.xme01
         AND xmf02 = g_xme.xme02
      IF STATUS THEN
#        CALL cl_err('del xmf',STATUS,0)   #No.FUN-660167
         CALL cl_err3("del","xmf_file",g_xme.xme01,g_xme.xme02,STATUS,"","del xmf",1)  #No.FUN-660167
         ROLLBACK WORK
         RETURN
      END IF
#MOD-D40130 add begin------------------------      
      LET g_msg=TIME
      LET l_t = g_xme.xme00,"/",g_xme.xme01,"/",g_xme.xme02 CLIPPED
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) 
                   VALUES (g_prog,g_user,g_today,g_msg,l_t,'delete',g_plant,g_legal)
#MOD-D40130 add end--------------------------  
#FUN-9C0163 MARK START----------------------------------------------------------------
#     DELETE FROM xmg_file
#      WHERE xmg01 = g_xme.xme01
#        AND xmg02 = g_xme.xme02
#     IF STATUS THEN
##       CALL cl_err('del xmg',STATUS,0)   #No.FUN-660167
#        CALL cl_err3("del","xmg_file",g_xme.xme01,g_xme.xme02,STATUS,"","del xmg",1)  #No.FUN-660167
#        ROLLBACK WORK
#        RETURN
#     END IF
#FUN-9C0163 MARK END----------------------------------------------------------------- 
      CLEAR FORM
      CALL g_xmf.clear()
      INITIALIZE g_xme.* TO NULL
 
      DROP TABLE x  #No.TQC-720019
      PREPARE i520_precount_x2 FROM g_sql_tmp  #No.TQC-720019
      EXECUTE i520_precount_x2                 #No.TQC-720019
      OPEN i520_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i520_cs
         CLOSE i520_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i520_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i520_cs
         CLOSE i520_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN i520_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i520_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i520_fetch('/')
      END IF
 
      MESSAGE ""
   END IF
 
   CLOSE i520_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i520_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
       l_cmd           LIKE type_file.chr1000,             #No.FUN-680137  VARCHAR(60)
       l_flag          LIKE type_file.num5,                #No.FUN-680137 SMALLINT 
       l_i,l_cnt       LIKE type_file.num5,                #No.FUN-680137 SMALLINT
       l_s             LIKE type_file.num5,                #No.FUN-680137 SMALLINT
       l_xmf07         LIKE xmf_file.xmf07,
       l_xmf08         LIKE xmf_file.xmf08,
       l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
#FUN-9C0163 ADD START--------------------
DEFINE
    l_ima31         LIKE ima_file.ima31,
    t_flag          LIKE type_file.chr1,
    l_fac           LIKE type_file.num20_6,
    l_msg           LIKE type_file.chr1000
#FUN-9C0163 ADD END-----------------------
DEFINE l_cn   LIKE type_file.num5
DEFINE l_gec04      LIKE gec_file.gec04    #add by guanyao160715
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_xme.xme01 IS NULL OR g_xme.xme02 IS NULL THEN
      RETURN
   END IF
 
   SELECT * INTO g_xme.* FROM xme_file
    WHERE xme01 = g_xme.xme01
      AND xme02 = g_xme.xme02
      AND xme00 = g_xme.xme00 
      AND ta_xme01 = g_xme.ta_xme01   #add by guanyao160712 
   CALL i520_gen()
 
 
   CALL cl_opmsg('b')
 
 
   LET g_forupd_sql =
     "SELECT xmf03,'','',ta_xmf01,'',xmf04,'',xmf05,xmf07,ta_xmf03,xmf08",   #No.MOD-5A0455 #str—add by huanglf 160707  #add by guanyao160715
     "  FROM xmf_file ",
     " WHERE xmf01 = ? ",
     "   AND xmf02 = ? ",
     "   AND xmf03 = ? ",
     "   AND xmf04 = ? ",
     "   AND xmf05 = ? ",
     "   AND ta_xmf02 = ? ",   #add by guanyao160711
     " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i520_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_xmf WITHOUT DEFAULTS FROM s_xmf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET g_success = 'Y'
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_xmf_t.* = g_xmf[l_ac].*  #BACKUP
            LET g_xmf_o.* = g_xmf[l_ac].*  #BACKUP
            BEGIN WORK
 
            OPEN i520_bcl USING g_xme.xme01,g_xme.xme02,g_xmf_t.xmf03,
                                g_xmf_t.xmf04,g_xmf_t.xmf05,g_xme.ta_xme01  #add by guanyao160711
            IF STATUS THEN
               CALL cl_err("OPEN i520_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i520_bcl INTO g_xmf[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_xmf_t.xmf03,SQLCA.sqlcode,1)
                  RETURN
                  LET l_lock_sw = "Y"
               END IF
               CALL i520_xmf03('d')
               CALL i520_ta_xmf01()
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         LET g_before_input_done = FALSE
         CALL i520_set_entry_b(p_cmd)
         CALL i520_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF cl_null(g_xme.xme01) THEN LET g_xme.xme01=' ' END IF #FUN-790001 add
         INSERT INTO xmf_file (xmf01,xmf02,xmf03,ta_xmf01,xmf04,xmf05,
                               xmf07,xmf08,ta_xmf02,ta_xmf03)#str---add by huanglf160730
                        VALUES(g_xme.xme01,g_xme.xme02,
                               g_xmf[l_ac].xmf03,g_xmf[l_ac].ta_xmf01,
                               g_xmf[l_ac].xmf04,g_xmf[l_ac].xmf05,
                               g_xmf[l_ac].xmf07,g_xmf[l_ac].xmf08,g_xme.ta_xme01,g_xmf[l_ac].ta_xmf03)  #add ta_xme01 by guanyao160712
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_xmf[l_ac].xmf03,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("ins","xmf_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            CANCEL INSERT
            LET g_success = 'N'
         ELSE
            MESSAGE 'INSERT O.K'
            IF g_success = 'Y' THEN
               COMMIT WORK
            END IF
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
#FUN-9C0163 MARK START-------------------------------
#        INSERT INTO xmg_file(xmg01,xmg02,xmg03,xmg04,xmg05,
#                             xmg06,xmg07)
#                      VALUES(g_xme.xme01,g_xme.xme02,
#                             g_xmf[l_ac].xmf03,g_xmf[l_ac].xmf04,
#                             g_xmf[l_ac].xmf05,0,100)
#        IF SQLCA.sqlcode THEN
##          CALL cl_err('xmg',SQLCA.sqlcode,0)   #No.FUN-660167
#           CALL cl_err3("ins","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","xmg",1)  #No.FUN-660167
#           LET g_success = 'N'
#        END IF
#FUN-9C0163 MARK END------------------------------
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_xmf[l_ac].* TO NULL      #900423
         LET g_xmf_t.* = g_xmf[l_ac].*         #新輸入資料
         LET g_xmf_o.* = g_xmf[l_ac].*         #新輸入資料
         LET g_xmf[l_ac].xmf07 = 0
         LET g_xmf[l_ac].ta_xmf03 = 0   #add by guanyao160715
         LET g_xmf[l_ac].xmf08 = 100
         LET g_before_input_done = FALSE
         CALL i520_set_entry_b(p_cmd)
         CALL i520_set_no_entry_b(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD xmf03
 
      BEFORE FIELD xmf04
         IF p_cmd = 'a' OR
           (p_cmd = 'u' AND g_xmf_t.xmf03 != g_xmf[l_ac].xmf03) THEN
            CALL i520_xmf03('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_xmf[l_ac].xmf03,g_errno,0)
               LET g_xmf[l_ac].xmf03 = g_xmf_t.xmf03
               NEXT FIELD xmf03
            END IF
         END IF
 
      AFTER FIELD xmf04
         IF NOT cl_null(g_xmf[l_ac].xmf04) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_xmf_t.xmf04 != g_xmf[l_ac].xmf04) THEN
               CALL i520_xmf04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_xmf[l_ac].xmf04,g_errno,0)
                  LET g_xmf[l_ac].xmf04 = g_xmf_o.xmf04
                  NEXT FIELD xmf04
               #FUN-9C0163 ADD START---------------------
                ELSE
                   IF NOT cl_null(g_xmf[l_ac].xmf03) THEN
                      SELECT ima31 INTO l_ima31 FROM ima_file
                       WHERE ima01 = g_xmf[l_ac].xmf03
                      CALL s_umfchk(g_xmf[l_ac].xmf03,g_xmf[l_ac].xmf04
                                    ,l_ima31)
                      RETURNING t_flag,l_fac
                      IF t_flag = 1 THEN
                         LET l_msg = l_ima31 CLIPPED,'->',
                                     g_xmf[l_ac].xmf04 CLIPPED
                         CALL cl_err(l_msg CLIPPED,'mfg2719',0)
                         NEXT FIELD xmf04
                      END IF
                   END IF
              #FUN-9C0163 ADD END--------------------------
               END IF
            END IF
         END IF
 
      AFTER FIELD xmf05
         IF NOT cl_null(g_xmf[l_ac].xmf05) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND
               (g_xmf_t.xmf03 != g_xmf[l_ac].xmf03 OR
                g_xmf_t.xmf04 != g_xmf[l_ac].xmf04 OR
                g_xmf_t.xmf05 != g_xmf[l_ac].xmf05)) THEN
               SELECT COUNT(*) INTO l_cnt FROM xmf_file
                WHERE xmf01 = g_xme.xme01 AND xmf02 = g_xme.xme02
                  AND xmf03 = g_xmf[l_ac].xmf03
                  AND xmf04 = g_xmf[l_ac].xmf04
                  AND xmf05 = g_xmf[l_ac].xmf05
               IF l_cnt > 0 THEN
                  CALL cl_err(g_xmf[l_ac].xmf05,-239,0)
                  NEXT FIELD xmf03
               END IF
            END IF
         END IF
 
      AFTER FIELD xmf07
         IF NOT cl_null(g_xmf[l_ac].xmf07) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_xmf_t.xmf07 != g_xmf[l_ac].xmf07) THEN
               IF g_xmf[l_ac].xmf07 <=0 THEN
                  CALL cl_err('xmf07','mfg1322',0)
                  NEXT FIELD xmf07
               END IF
               #str-----add by guanyao160715
               LET l_gec04 = 0
               SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_xme.ta_xme01 
               IF cl_null(l_gec04) THEN
                  LET l_gec04 = 0 
               END IF 
               LET g_xmf[l_ac].ta_xmf03 = g_xmf[l_ac].xmf07*(100+l_gec04)/100
               LET g_xmf_t.ta_xmf03 = g_xmf[l_ac].ta_xmf03
               #end-----add by guanyao160715
            END IF 
         END IF
#str------add by guanyao160715
      AFTER FIELD ta_xmf03
         IF NOT cl_null(g_xmf[l_ac].ta_xmf03) THEN
            IF p_cmd = 'a' OR
              (p_cmd = 'u' AND g_xmf_t.ta_xmf03 != g_xmf[l_ac].ta_xmf03) THEN
               IF g_xmf[l_ac].ta_xmf03 <=0 THEN
                  CALL cl_err('ta_xmf03','mfg1322',0)
                  NEXT FIELD ta_xmf03
               END IF
               #str-----add by guanyao160715
               LET l_gec04 = 0
               SELECT gec04 INTO l_gec04 FROM gec_file WHERE gec01 = g_xme.ta_xme01 
               IF cl_null(l_gec04) THEN
                  LET l_gec04 = 0 
               END IF 
               LET g_xmf[l_ac].xmf07 = g_xmf[l_ac].ta_xmf03/((100+l_gec04)/100)
               LET g_xmf_t.xmf07 = g_xmf[l_ac].xmf07
               #end-----add by guanyao160715
            END IF 
         END IF
#end------add by guanyao160715
 
      AFTER FIELD xmf08
         IF NOT cl_null(g_xmf[l_ac].xmf08) THEN
            IF g_xmf[l_ac].xmf08 <=0 OR g_xmf[l_ac].xmf08 >100 THEN
               CALL cl_err('xmf08','mfg1332',0)
               NEXT FIELD xmf08
            END IF
         END IF
    #str—add by huanglf 160711
    AFTER FIELD ta_xmf01  
    IF NOT cl_null(g_xmf[l_ac].ta_xmf01) THEN
    SELECT count(*) INTO l_cn FROM occ_file WHERE occ01=g_xmf[l_ac].ta_xmf01
     IF l_cn>0 THEN 
             CALL i520_ta_xmf01()
     ELSE 
             CALL cl_err('','cxm-014',0)
             NEXT FIELD ta_xmf01
             END IF 
     END IF    
     #end—add by huanglf 160711
     
      
      BEFORE DELETE                            #是否取消單身
         IF g_xmf_t.xmf03 IS NOT NULL AND g_xmf_t.xmf04 IS NOT NULL AND
            g_xmf_t.xmf05 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM xmf_file                 #刪除單身
             WHERE xmf01 = g_xme.xme01 AND xmf02 = g_xme.xme02
               AND xmf03 = g_xmf_t.xmf03
               AND xmf04 = g_xmf_t.xmf04
               AND xmf05 = g_xmf_t.xmf05
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_xmf_t.xmf03,SQLCA.sqlcode,0)   #No.FUN-660167
               CALL cl_err3("del","xmf_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               ROLLBACK WORK
               CANCEL DELETE
            END IF

#FUN-9C0163 MARK START------------------------------------------------- 
#           DELETE FROM xmg_file                 #刪除xmg table
#            WHERE xmg01 = g_xme.xme01 AND xmg02 = g_xme.xme02
#              AND xmg03 = g_xmf_t.xmf03
#              AND xmg04 = g_xmf_t.xmf04
#              AND xmg05 = g_xmf_t.xmf05
#           IF SQLCA.sqlcode THEN
##             CALL cl_err(g_xmf_t.xmf03,SQLCA.sqlcode,0)   #No.FUN-660167
#              CALL cl_err3("del","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
#              ROLLBACK WORK
#              CANCEL DELETE
#           END IF
#FUN-9C0163 MARK END-------------------------------------------------
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         IF g_success ='Y' THEN COMMIT WORK END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_xmf[l_ac].* = g_xmf_t.*
            CLOSE i520_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_xmf[l_ac].xmf03,-263,1)
            LET g_xmf[l_ac].* = g_xmf_t.*
         ELSE
            UPDATE xmf_file SET xmf03=g_xmf[l_ac].xmf03,
                                ta_xmf01=g_xmf[l_ac].ta_xmf01,
                                xmf04=g_xmf[l_ac].xmf04,
                                xmf05=g_xmf[l_ac].xmf05,
                                xmf07=g_xmf[l_ac].xmf07,
                                xmf08=g_xmf[l_ac].xmf08,
                                ta_xmf03=g_xmf[l_ac].ta_xmf03
             WHERE xmf01 = g_xme.xme01
               AND xmf02 = g_xme.xme02
               AND xmf03 = g_xmf_t.xmf03
               AND xmf04 = g_xmf_t.xmf04
               AND xmf05 = g_xmf_t.xmf05
               AND ta_xmf02= g_xme.ta_xme01   #add by guanyao160711
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_xmf[l_ac].xmf03,-239,0)   #No.FUN-660167
               CALL cl_err3("upd","xmf_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               LET g_xmf[l_ac].* = g_xmf_t.*
               LET g_success = 'N'
            ELSE
               MESSAGE 'UPDATE O.K'
               IF g_success = 'Y' THEN COMMIT WORK END IF
            END IF
         END IF
 
      AFTER ROW
  #str---add by huanglf160730
       UPDATE xmf_file SET xmf03=g_xmf[l_ac].xmf03,
                                ta_xmf01=g_xmf[l_ac].ta_xmf01,
                                xmf04=g_xmf[l_ac].xmf04,
                                xmf05=g_xmf[l_ac].xmf05,
                                xmf07=g_xmf[l_ac].xmf07,
                                xmf08=g_xmf[l_ac].xmf08,
                                ta_xmf03=g_xmf[l_ac].ta_xmf03
             WHERE xmf01 = g_xme.xme01
               AND xmf02 = g_xme.xme02
               AND xmf03 = g_xmf_t.xmf03
               AND xmf04 = g_xmf_t.xmf04
               AND xmf05 = g_xmf_t.xmf05
               AND ta_xmf02= g_xme.ta_xme01
 #end---add by huanglf160730
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac  #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_xmf[l_ac].* = g_xmf_t.*
            #FUN-D30034--add--begin--
            ELSE
               CALL g_xmf.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034--add--end----
            END IF
            CLOSE i520_cl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30034 add
         CLOSE i520_cl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(xmf03)
#FUN-AA0059---------mod------------str-----------------            
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_xmf[l_ac].xmf03
#                 CALL cl_create_qry() RETURNING g_xmf[l_ac].xmf03
                  CALL q_sel_ima(FALSE, "q_ima","",g_xmf[l_ac].xmf03,"","","","","",'' ) 
                      RETURNING  g_xmf[l_ac].xmf03

#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME g_xmf[l_ac].xmf03          #No.MOD-490371
            WHEN INFIELD(xmf04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_xmf[l_ac].xmf04
                 CALL cl_create_qry() RETURNING g_xmf[l_ac].xmf04
#                 CALL FGL_DIALOG_SETBUFFER(g_xmf[l_ac].xmf04)
                 DISPLAY g_xmf[l_ac].xmf04 TO xmf04
                 NEXT FIELD xmf04
#str—add by huanglf 160711
            WHEN INFIELD(ta_xmf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ta_xmf01"
                 LET g_qryparam.default1 = g_xmf[l_ac].ta_xmf01
                 CALL cl_create_qry() RETURNING g_xmf[l_ac].ta_xmf01
#                 CALL FGL_DIALOG_SETBUFFER(g_xmf[l_ac].xmf04)
                 CALL i520_ta_xmf01()
                 DISPLAY g_xmf[l_ac].ta_xmf01 TO ta_xmf01
                 NEXT FIELD ta_xmf01
#end—add by huanglf 160711
                 
            OTHERWISE
                EXIT CASE
         END CASE
 
      #BugNo:6638
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION set_price          #延用定價
         CALL i520_ctry_xmf07()
         NEXT FIELD xmf07
   
      ON ACTION set_discount
         CALL i520_ctry_xmf08()
         NEXT FIELD xmf08
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(xmf03) AND l_ac > 1 THEN
            LET g_xmf[l_ac].* = g_xmf[l_ac-1].*
            NEXT FIELD xmf03
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
 
 
   END INPUT
 
     #FUN-5B0116-begin
      LET g_xme.xmemodu = g_user
      LET g_xme.xmedate = g_today
      UPDATE xme_file SET xmemodu = g_xme.xmemodu,xmedate = g_xme.xmedate
       WHERE xme01 = g_xme.xme01
         AND xme02 = g_xme.xme02
         AND xme00 = g_xme.xme00      #FUN-9C0163 ADD
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#        CALL cl_err('upd xme',SQLCA.SQLCODE,1)   #No.FUN-660167
         CALL cl_err3("upd","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.SQLCODE,"","upd xme",1)  #No.FUN-660167
      END IF
      DISPLAY BY NAME g_xme.xmemodu,g_xme.xmedate
     #FUN-5B0116-end
 
   CLOSE i520_bcl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   CALL i520_delHeader()     #CHI-C30002 add
   CALL i520_show()
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i520_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM xme_file WHERE xme01 = g_xme.xme01
                                AND xme02 = g_xme.xme02
                                AND xme00 = g_xme.xme00
         INITIALIZE g_xme.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i520_xmf03(p_cmd)  #料件編號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021,
          l_ima31    LIKE ima_file.ima31,
          l_ima33    LIKE ima_file.ima33,
          l_imaacti  LIKE ima_file.imaacti,
          l_ima908   LIKE ima_file.ima908,  #FUN-560193
          l_cnt      LIKE type_file.num5,   #No.FUN-680137 SMALLINT
          p_cmd      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_gec04    LIKE gec_file.gec04    #add by guanyao160715
   DEFINE l_gec07    LIKE gec_file.gec07    #add by guanyao160715 
 
   LET g_errno = ' '
   SELECT ima02,ima021,imaacti,ima31,ima33,ima908  #FUN-560193
     INTO l_ima02,l_ima021,l_imaacti,l_ima31,l_ima33,l_ima908  #FUN-560193
     FROM ima_file
    WHERE ima01 = g_xmf[l_ac].xmf03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                           LET l_ima02 = NULL
                           LET l_ima021= NULL
                           LET l_ima908= NULL #FUN-560193
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'   LET g_errno = '9038'   #No.FUN-690022
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd = 'a' THEN
      LET g_xmf[l_ac].xmf04 = l_ima31
      #str-------add by guanyao160715
      LET l_gec04 = 0
      LET l_gec07 = ''
      SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file WHERE gec01 = g_xme.ta_xme01 
      IF l_gec04 = 0 OR cl_null(l_gec04) THEN 
         LET l_gec04 = 0
      END IF
      IF l_gec07 = 'Y' THEN 
         LET g_xmf[l_ac].ta_xmf03 = l_ima33
         IF g_xmf[l_ac].ta_xmf03 IS NULL THEN
            LET g_xmf[l_ac].ta_xmf03 = 0
         END IF
         LET g_xmf[l_ac].xmf07 = g_xmf[l_ac].ta_xmf03*(100+l_gec04)/100
      ELSE 
      #end-------add by guanyao160715
         LET g_xmf[l_ac].xmf07 = l_ima33
         IF g_xmf[l_ac].xmf07 IS NULL THEN
            LET g_xmf[l_ac].xmf07 = 0
         END IF
         LET g_xmf[l_ac].ta_xmf03 = g_xmf[l_ac].xmf07*(100-l_gec04)/100
      END IF 
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_xmf[l_ac].ima02 = l_ima02
      LET g_xmf[l_ac].ima021= l_ima021
      LET g_xmf[l_ac].ima908= l_ima908  #FUN-560193
   END IF
 
END FUNCTION

#str—add by huanglf 160711
FUNCTION i520_ta_xmf01()
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_ta_xmf01_desc    LIKE occ_file.occ02#客户简称

   
   SELECT occ02 INTO g_xmf[l_ac].ta_xmf01_desc
   FROM occ_file
   WHERE occ01 = g_xmf[l_ac].ta_xmf01
   DISPLAY g_xmf[l_ac].ta_xmf01_desc TO ta_xmf01_desc 

END FUNCTION
#str—add by huanglf 160711

 
FUNCTION i520_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
   CONSTRUCT l_wc2 ON xmf03,xmf04,xmf05,xmf07,xmf08
              FROM s_xmf[1].xmf03,s_xmf[1].xmf04,s_xmf[1].xmf05,
                   s_xmf[1].xmf07,s_xmf[1].xmf08
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
 
   CALL i520_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i520_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
   LET g_sql =
       "SELECT xmf03,ima02,ima021,ta_xmf01,'',xmf04,ima908,xmf05,xmf07,ta_xmf03,xmf08,ta_xmf04,ta_xmf05 ", #add by huanglf170317#FUN-560193 @mod by huanglf 160711 #add ta_xmf03 by guabyao160715
       "  FROM xmf_file LEFT OUTER JOIN ima_file ON xmf_file.xmf03=ima_file.ima01",
       " WHERE xmf01 = '",g_xme.xme01,
       "'  AND xmf02 = '",g_xme.xme02,
       "'  AND ta_xmf02 = '",g_xme.ta_xme01,  
       "'",
       "   AND ", p_wc2 CLIPPED,                     #單身
       " ORDER BY 1,2"
   PREPARE i520_pb FROM g_sql
   IF STATUS THEN CALL cl_err('per',STATUS,1) RETURN END IF
   DECLARE xmf_curs CURSOR FOR i520_pb
 
   CALL g_xmf.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH xmf_curs INTO g_xmf[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #str—add by huanglf 160711
   SELECT occ02 INTO g_xmf[g_cnt].ta_xmf01_desc
   FROM occ_file
   WHERE occ01 = g_xmf[g_cnt].ta_xmf01
      
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_xmf.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i520_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_xmf TO s_xmf.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
    #------------------No.FUN-620009 add
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
    #------------------No.FUN-620009 end
      ON ACTION first
         CALL i520_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i520_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i520_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i520_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i520_fetch('L')
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE                 #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0020  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i520_gen()     #自動產生單身資料
   DEFINE l_wc          LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   DEFINE l_ima         RECORD LIKE ima_file.*
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(300)
   #yemy 20130513  --Begin
   DEFINE l_cnt         LIKE type_file.num10
   DEFINE l_sw          LIKE type_file.num10
   #yemy 20130513  --End  
 
   SELECT COUNT(*) INTO l_cnt FROM xmf_file
    WHERE xmf01 = g_xme.xme01
      AND xmf02 = g_xme.xme02
   IF l_cnt > 0 THEN RETURN END IF
 
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW i520_w1 AT p_row,p_col         #顯示畫面
        WITH FORM "axm/42f/axmi5201"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmi5201")
 
   CONSTRUCT BY NAME l_wc ON ima06,ima01
 
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
         
 #MOD-990160 --begin--
      ON ACTION controlp
         CASE
           #TQC-D70002--add--str-- 
           WHEN INFIELD(ima06)
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_imz'
              LET g_qryparam.state = 'c'
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima06
              NEXT FIELD ima06
           #TQC-D70002--add--end-- 
           WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------             
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima02"
#                LET g_qryparam.state = 'c'
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima02","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                DISPLAY g_qryparam.multiret TO ima01
                NEXT FIELD ima01              
         END CASE  
#MOD-990160 --end--
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i520_w1
      RETURN
   END IF
 
   LET l_cnt=0
   LET l_sql = "SELECT * FROM ima_file WHERE ",l_wc CLIPPED
 
   PREPARE i5201_prepare FROM l_sql
   IF STATUS THEN
      CALL cl_err('pre',STATUS,1)
      CLOSE WINDOW i520_w1
      RETURN
   END IF
 
   DECLARE i5201_cs CURSOR FOR i5201_prepare

   #yemy 20130513  --Begin
   LET l_sql = "SELECT COUNT(*) FROM ima_file WHERE ",l_wc CLIPPED
   PREPARE i5201_cnt_pre FROM l_sql
   EXECUTE i5201_cnt_pre INTO l_cnt
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      CALL cl_progress_bar(l_cnt)
   END IF
   #yemy 20130513  --End  
 
   FOREACH i5201_cs INTO l_ima.*

      #yemy 20130513  --Begin
      CALL cl_progressing(" ")
      #yemy 20130513  --End  

      #FUN-AB0025 ------------add start-----------
      IF NOT cl_null(l_ima.ima01 ) THEN
         IF NOT s_chk_item_no(l_ima.ima01,'') THEN
            CONTINUE FOREACH
         END IF
      END IF
      #FUN-AB0025 ------------add end------------
      IF l_ima.ima33 IS NULL THEN LET l_ima.ima33 = 0   END IF
      IF l_ima.ima31 IS NULL THEN LET l_ima.ima31 = " " END IF
      IF cl_null(g_xme.xme01) THEN LET g_xme.xme01= ' ' END IF #FUN-790001 add
      INSERT INTO xmf_file(xmf01,xmf02,xmf03,xmf04,xmf05,xmf07,xmf08,ta_xmf02)
                    VALUES(g_xme.xme01,g_xme.xme02,l_ima.ima01,
                           l_ima.ima31,g_today,l_ima.ima33,100,g_xme.ta_xme01)
      IF STATUS THEN 
#        CALL cl_err('ins xmf',STATUS,0)   #No.FUN-660167
         CALL cl_err3("ins","xmf_file",g_xme.xme01,g_xme.xme02,SQLCA.SQLCODE,"","ins xmf",1)  #No.FUN-660167
         EXIT FOREACH 
      END IF
#FUN-9C0163 MARK START--------------------------------------------------------------
#     INSERT INTO xmg_file(xmg01,xmg02,xmg03,xmg04,xmg05,xmg06,xmg07)
#                   VALUES(g_xme.xme01,g_xme.xme02,l_ima.ima01,
#                          l_ima.ima31,g_today,0,100)
#     IF STATUS THEN 
##       CALL cl_err('ins xmg',STATUS,0)  #No.FUN-660167
#        CALL cl_err3("ins","xmg_file",g_xme.xme01,g_xme.xme02,SQLCA.SQLCODE,"","ins xmg",1)  #No.FUN-660167
#        EXIT FOREACH 
#     END IF
#FUN-9C0163 MARK END-------------------------------------------------------------
   END FOREACH
 
   ERROR ""
   CLOSE WINDOW i520_w1
 
   CALL i520_b_fill("1=1")
 
END FUNCTION
 
FUNCTION i520_xmf04()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
   LET g_errno = " "
 
   SELECT gfeacti INTO l_gfeacti FROM gfe_file
    WHERE gfe01 = g_xmf[l_ac].xmf04
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg3098'
         LET l_gfeacti = NULL
      WHEN l_gfeacti='N'
         LET g_errno = '9028'
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
#No.FUN-7C0043--start-- 
FUNCTION i520_out()
 DEFINE l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       sr              RECORD
                          xme01       LIKE xme_file.xme01,
                          xme02       LIKE xme_file.xme02,
                          xmf03       LIKE xmf_file.xmf03,
                          xmf04       LIKE xmf_file.xmf04,   #No.MOD-5A0148
                          xmf05       LIKE xmf_file.xmf05,
                          xmf07       LIKE xmf_file.xmf07,
                          xmf08       LIKE xmf_file.xmf08,
                          azi03       LIKE azi_file.azi03,
                          oah02       LIKE oah_file.oah02,
                          ima02       LIKE ima_file.ima02,
                          ima021      LIKE ima_file.ima021
                       END RECORD,
       l_name          LIKE type_file.chr20                #External(Disk) file name        #No.FUN-680137 VARCHAR(20)
 DEFINE l_cmd          LIKE type_file.chr1000              #No.FUN-7C0043                                                                    
   IF cl_null(g_wc) AND NOT cl_null(g_xme.xme01) AND NOT cl_null(g_xme.xme02) THEN                                                  
      LET g_wc=" xme00='1' AND xme01='",g_xme.xme01,"' AND xme02='",g_xme.xme02,"' "                                                              
   END IF                                                                                                                           
   IF g_wc IS NULL THEN                                                                                                             
      CALL cl_err('','9057',0)                                                                                                      
      RETURN                                                                                                                        
   END IF                                                                                                                           
   IF cl_null(g_wc2) THEN                                                                                                           
      LET g_wc2=" 1=1"                                                                                                              
   END IF                                                                                                                           
   LET l_cmd = 'p_query "axmi520" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                           
   CALL cl_cmdrun(l_cmd)                                                                                                            
   RETURN    
#  IF g_wc IS NULL THEN
#     CALL cl_err('','9057',0)
#     RETURN
#  END IF
 
#  CALL cl_wait()
 
#  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
#  LET g_sql="SELECT xme01,xme02,xmf03,xmf04,xmf05,xmf07,xmf08,", #No.MOD-5A0148
#            "       azi03,oah02,ima02,ima021",
#            "  FROM xmf_file LEFT OUTER JOIN ima_file ON xmf_file.xmf03=ima_file.ima01,xme_file LEFT OUTER JOIN azi_file ON xme_file.xme02=azi_file.xme01 ",
#            "  LEFT OUTER JOIN oah_file ON xme_file.xme01=oah_file.oah01 ",
#            " WHERE xmf01=xme01 AND xmf02 = xme02 ",
#            "   AND ",g_wc CLIPPED,
#            "   AND ",g_wc2 CLIPPED,
#            " ORDER BY xme01,xme02,xmf03,xmf05"
 
#  PREPARE i520_p1 FROM g_sql                # RUNTIME 編譯
#  IF SQLCA.SQLCODE THEN
#     CALL cl_err('pare: ',SQLCA.SQLCODE,0)
#     RETURN
#  END IF
 
#  DECLARE i520_co CURSOR FOR i520_p1
 
#  LET g_rlang = g_lang                               #FUN-4C0096 add
#  CALL cl_outnam('axmi520') RETURNING l_name
#  START REPORT i520_rep TO l_name
 
#  FOREACH i520_co INTO sr.*
#     IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)
#        EXIT FOREACH
#     END IF
#     OUTPUT TO REPORT i520_rep(sr.*)
#  END FOREACH
 
#  FINISH REPORT i520_rep
 
#  CLOSE i520_co
#  ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
 
END FUNCTION
 
#REPORT i520_rep(sr)
#DEFINE l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1) 
#      l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
#      sr              RECORD
#                         xme01       LIKE xme_file.xme01,
#                         xme02       LIKE xme_file.xme02,
#                         xmf03       LIKE xmf_file.xmf03,
#                         xmf04       LIKE xmf_file.xmf04,  #No.MOD-5A0148
#                         xmf05       LIKE xmf_file.xmf05,
#                         xmf07       LIKE xmf_file.xmf07,
#                         xmf08       LIKE xmf_file.xmf08,
#                         azi03       LIKE azi_file.azi03,
#                         oah02       LIKE oah_file.oah02,
#                         ima02       LIKE ima_file.ima02,
#                         ima021      LIKE ima_file.ima021
#                      END RECORD
 
#  OUTPUT
#     TOP MARGIN g_top_margin
#     LEFT MARGIN g_left_margin
#     BOTTOM MARGIN g_bottom_margin
#     PAGE LENGTH g_page_line
 
#  ORDER BY sr.xme01,sr.xme02,sr.xmf03,sr.xmf05
 
#  FORMAT
#     PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#        LET g_pageno = g_pageno + 1
#        LET pageno_total = PAGENO USING '<<<','/pageno'
#        PRINT g_head CLIPPED, pageno_total
#        #PRINT ''     #No.TQC-6A0091
#        PRINT g_dash
#        PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#              g_x[40],g_x[38],g_x[39]  #No.MOD-5A0148
#        PRINT g_dash1
#        LET l_trailer_sw = 'y'
 
#     BEFORE GROUP OF sr.xme02
#        PRINT COLUMN g_c[31],sr.xme01,
#              COLUMN g_c[32],sr.oah02,
#              COLUMN g_c[33],sr.xme02;
 
#     ON EVERY ROW
#        PRINT COLUMN g_c[34],sr.xmf05,
#              COLUMN g_c[35],sr.xmf03[1,30],    #No.TQC-6A0091
#              COLUMN g_c[36],sr.ima02[1,30],    #No.TQC-6A0091
#              COLUMN g_c[37],sr.ima021[1,30],   #No.TQC-6A0091
#              COLUMN g_c[40],sr.xmf04,   #No.MOD-5A0148
#              COLUMN g_c[38],cl_numfor(sr.xmf07,38,sr.azi03),
#              COLUMN g_c[39],sr.xmf08 USING '##&'
 
#     AFTER GROUP OF sr.xme02
#        SKIP 1 LINE
 
#     ON LAST ROW
#        PRINT g_dash
#        IF g_zz05 = 'Y' THEN
#          #TQC-630166
#          #IF g_wc[001,080] > ' ' THEN
#          #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED
#          #END IF
#          #IF g_wc[071,140] > ' ' THEN
#          #   PRINT COLUMN 10,g_wc[071,140] CLIPPED
#          #END IF
#          #IF g_wc[141,210] > ' ' THEN
#          #   PRINT COLUMN 10,g_wc[141,210] CLIPPED
#          #END IF 
#           CALL cl_prt_pos_wc(g_wc)
#          #END TQC-630166
#           PRINT g_dash
#        END IF
#        PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  #No.TQC-5B0029  #No.TQC-6A0091
#        LET l_trailer_sw = 'n'
 
#     PAGE TRAILER
#        IF l_trailer_sw = 'y' THEN
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED  #No.TQC-5B0029  #No.TQC-6A0091
#        ELSE
#           SKIP 2 LINE
#        END IF
 
#END REPORT
#No.FUN-7C0043--end--
FUNCTION i520_ctry_xmf07()
 DEFINE l_i    LIKE type_file.num10,         #No.FUN-680137  INTEGER
        l_xmf07 LIKE xmf_file.xmf07
 
   LET l_i = l_ac
   LET l_xmf07 = g_xmf[l_ac].xmf07
 
   IF cl_confirm('abx-080') THEN
      WHILE l_i <= g_rec_b  #自本行至最后一行延用其上的值
         UPDATE xmf_file
            SET xmf07 = l_xmf07
          WHERE xmf01 = g_xme.xme01
            AND xmf02 = g_xme.xme02
            AND xmf03 = g_xmf[l_i].xmf03
            AND xmf04 = g_xmf[l_i].xmf04
            AND xmf05 = g_xmf[l_i].xmf05
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_xmf[l_i].xmf05,SQLCA.sqlcode,0)   #No.FUN-660167
            CALL cl_err3("upd","xmf_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
            LET g_success='N'
            EXIT WHILE
         END IF
         LET l_i = l_i + 1
         IF l_i   > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT WHILE
         END IF
      END WHILE
   END IF
 
   CALL i520_show()
 
END FUNCTION
 
FUNCTION i520_ctry_xmf08()
 DEFINE l_i    LIKE type_file.num10,         #No.FUN-680137 INTEGER 
        l_xmf08 LIKE xmf_file.xmf08
 
   LET l_i = l_ac
   LET l_xmf08 = g_xmf[l_ac].xmf08
 
   IF cl_confirm('abx-080') THEN
      WHILE l_i <= g_rec_b
         UPDATE xmf_file set xmf08 = l_xmf08
          WHERE xmf01 = g_xme.xme01
            AND xmf02 = g_xme.xme02
            AND xmf03 = g_xmf[l_i].xmf03
            AND xmf04 = g_xmf[l_i].xmf04
            AND xmf05 = g_xmf[l_i].xmf05
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_xmf[l_i].xmf05,SQLCA.sqlcode,0)   #No.FUN-660167
             CALL cl_err3("upd","xmf_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
             LET g_success='N'
             EXIT WHILE
         END IF
         LET l_i = l_i + 1
         IF l_i   > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
            EXIT WHILE
         END IF
      END WHILE
   END IF
 
   CALL i520_show()
 
END FUNCTION
 
FUNCTION i520_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("xme01,xme02,ta_xme01",TRUE)  #add  ta_xme01 by guanyao160711
   END IF
 
END FUNCTION
 
FUNCTION i520_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' AND g_chkey = 'N' THEN
         CALL cl_set_comp_entry("xme01,xme02,ta_xme01",FALSE)  #add ta_xme01 by guanyao160711
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i520_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("xmf03",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i520_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      IF p_cmd = 'u' THEN
         CALL cl_set_comp_entry("xmf03",FALSE)
      END IF
   END IF
 
END FUNCTION
 
#------------------------No.FUN-620009 add-----------------------------
FUNCTION i520_copy()
DEFINE l_xme01,l_xme01_o  LIKE xme_file.xme01,
       l_xme02,l_xme02_o  LIKE xme_file.xme02,
       l_n                  LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_oah02              LIKE oah_file.oah02
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_xme.xme01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i520_set_entry('a')
    LET g_before_input_done = TRUE
 
    DISPLAY ' ' TO xme01
    DISPLAY ' ' TO xme02
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
    INPUT l_xme01,l_xme02 FROM xme01,xme02 
 
       AFTER FIELD xme01
          IF NOT cl_null(l_xme01) THEN
             SELECT oah02 INTO l_oah02 FROM oah_file WHERE oah01=l_xme01
                                                        #AND oah03='4'   #NO.FUN-960130
             IF STATUS THEN
#               CALL cl_err(l_xme01,'mfg4101',0)    #No.FUN-660167
                CALL cl_err3("sel","oah_file",l_xme01,"","mfg4101","","",1)  #No.FUN-660167
                NEXT FIELD xme01
             END IF
             DISPLAY l_oah02 TO FORMONLY.oah02
          END IF
 
       #AFTER FIELD xme02
       #    IF NOT cl_null(l_xme02) THEN
       #       SELECT azi01 FROM azi_file WHERE azi01=l_xme02
       #                                     AND aziacti='Y' 
       #       IF STATUS THEN
       #          CALL cl_err(l_xme02,'mfg3008',0) NEXT FIELD xme02
       #       END IF
       #       SELECT COUNT(*) INTO l_n FROM xme_file
       #        WHERE xme01 = l_xme01 AND xme02 = l_xme02
       #       IF l_n > 0 THEN                 
       #          CALL cl_err(l_xme01,-239,0) NEXT FIELD xme02
       #       END IF
       #    END IF
 
       ON ACTION controlp
          CASE
                WHEN INFIELD(xme01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_oah1"
                     LET g_qryparam.default1 = l_xme01
                     CALL cl_create_qry() RETURNING l_xme01
                     DISPLAY BY name l_xme01
                     NEXT FIELD xme01
                WHEN INFIELD(xme02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = l_xme02
                     CALL cl_create_qry() RETURNING l_xme02
                     DISPLAY BY name l_xme02
                     NEXT FIELD xme02
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
 
 
    END INPUT
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY g_xme.xme01 TO xme01 
       DISPLAY g_xme.xme02 TO xme02 
       RETURN
    END IF
 
    DROP TABLE x
 
    SELECT * FROM xme_file WHERE xme01 = g_xme.xme01
        AND xme02 = g_xme.xme02
        AND xme00 = g_xme.xme00             #FUN-9C0163 ADD
        INTO TEMP x
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
 
    UPDATE x SET xme01 = l_xme01,
                 xme02 = l_xme02,
                 xme06 = NULL,
                 xmeuser=g_user,
                 xmemodu=g_user,
                 xmegrup=g_grup,
                 xmedate=g_today 
 
    INSERT INTO xme_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("ins","xme_file",l_xme01,l_xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_xme01,') O.K'
 
    DROP TABLE y
 
    SELECT * FROM xmf_file WHERE xmf01 = g_xme.xme01
        AND xmf02 = g_xme.xme02
        INTO TEMP y
 
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("sel","xmf_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
 
    UPDATE y SET xmf01 = l_xme01,
                 xmf02 = l_xme02
    IF cl_null(l_xme01) THEN LET l_xme01=' ' END IF   #FUN-790001 add
    INSERT INTO xmf_file SELECT * FROM y
    IF SQLCA.sqlcode THEN
#      CALL cl_err(l_xme01,SQLCA.sqlcode,0)   #No.FUN-660167
       CALL cl_err3("ins","xmf_file",l_xme01,l_xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_xme01,') O.K'
 
     LET l_xme01_o= g_xme.xme01
     LET g_xme.xme01=l_xme01
     LET l_xme02_o= g_xme.xme02
     LET g_xme.xme02=l_xme02
 
     SELECT * INTO g_xme.* FROM xme_file WHERE xme01 = g_xme.xme01
                                           AND xme02 = g_xme.xme02
                                           AND xme00 = g_xme.xme00
     IF SQLCA.sqlcode THEN
#       CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)   #No.FUN-660167
        CALL cl_err3("sel","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
        INITIALIZE g_xme.* TO NULL
        RETURN
     END IF
     CALL i520_show()
     CALL i520_b_fill("1=1")
     CALL i520_b()
 
#FUN-C80046---begin 
#     LET g_xme.xme01=l_xme01_o
#     LET g_xme.xme02=l_xme02_o
#     SELECT * INTO g_xme.* FROM xme_file WHERE xme01 = g_xme.xme01
#                                           AND xme02 = g_xme.xme02
#     IF SQLCA.sqlcode THEN
##       CALL cl_err(g_xme.xme01,SQLCA.sqlcode,0)   #No.FUN-660167
#        CALL cl_err3("sel","xme_file",g_xme.xme01,g_xme.xme02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
#        INITIALIZE g_xme.* TO NULL
#        RETURN
#     END IF
#     CALL i520_show()
#FUN-C80046---end 
END FUNCTION
#------------------------No.FUN-620009 end-----------------------------
