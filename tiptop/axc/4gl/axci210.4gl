# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axci210.4gl
# Descriptions...: LCM 存貨成品成本維護作業
# Date & Author..: 99/03/26 By Kammy
# Modify.........: No.FUN-4B0015 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.MOD-510001 05/01/03 By ching -239檢查修改
# Modify.........: No.MOD-530170 05/03/21 By Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.FUN-570110 05/07/14 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0019 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7B0118 07/12/18 By Sarah 單頭增加顯示"成本分群"(ima12),"來源碼"(ima08),"產品分類"(ima131)(Display Only)
# Modify.........: No.FUN-8B0047 08/10/21 By sherry 十號公報修改
# Modify.........: No.MOD-910080 09/02/02 By Pengu cma03會變成null值
# Modify.........: NO.FUN-950058 09/05/19 By kim for 十號公報-單身加上顯示參考單據明細
# Modify.........: NO.CHI-970034 09/08/11 By jan 單身第一個page,須加顯示"cmg10/cmg11
# Modify.........: NO.FUN-970102 09/08/11 By jan 計價基准日 重新賦初值
# Modify.........: NO.FUN-980037 09/08/11 By jan 單身第一個page,須加顯示cmg03
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.CHI-9C0025 09/12/28 By jan 新增cma07/cma08欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:CHI-C20059 12/05/08 By bart 增加異動日期欄位

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cma   RECORD LIKE cma_file.*,
    g_cma_t RECORD LIKE cma_file.*,
    g_cma_o RECORD LIKE cma_file.*,
    g_cmz   RECORD LIKE cmz_file.*,
    g_cma01_t LIKE cma_file.cma01,
    g_cma021_t LIKE cma_file.cma021, #FUN-8B0047
    g_cma022_t LIKE cma_file.cma022, #FUN-8B0047
    g_cma07_t  LIKE cma_file.cma07,  #CHI-9C0025
    g_cma08_t  LIKE cma_file.cma08,  #CHI-9C0025
    b_cmb   RECORD LIKE cmb_file.*,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_wc3   STRING,              #FUN-950058
    #FUN-950058................begin
    g_cmg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cmg04   LIKE cmg_file.cmg04,
        cmg03   LIKE cmg_file.cmg03,  #FUN-980037
        cmg05   LIKE cmg_file.cmg05,
        cmg06   LIKE cmg_file.cmg06,
        cmg07   LIKE cmg_file.cmg07,
        cmg09   LIKE cmg_file.cmg09,
        cmg08   LIKE cmg_file.cmg08,
        cmg10   LIKE cmg_file.cmg10,   #CHI-970034
        cmg11   LIKE cmg_file.cmg11    #CHI-970034
                    END RECORD,
    g_cmg_t         RECORD                 #程式變數 (舊值)
        cmg04   LIKE cmg_file.cmg04,
        cmg03   LIKE cmg_file.cmg03,  #FUN-980037
        cmg05   LIKE cmg_file.cmg05,
        cmg06   LIKE cmg_file.cmg06,
        cmg07   LIKE cmg_file.cmg07,
        cmg09   LIKE cmg_file.cmg09,
        cmg08   LIKE cmg_file.cmg08, 
        cmg10   LIKE cmg_file.cmg10,   #CHI-970034
        cmg11   LIKE cmg_file.cmg11    #CHI-970034
                    END RECORD,
    #FUN-950058................end
    g_cmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cmb02		LIKE cmb_file.cmb02,
        cmb03		LIKE cmb_file.cmb03,
        cmb04		LIKE cmb_file.cmb04,
        cmb05		LIKE cmb_file.cmb05,
        cmb06		LIKE cmb_file.cmb06
                    END RECORD,
    g_cmb_t         RECORD                 #程式變數 (舊值)
        cmb02		LIKE cmb_file.cmb02,
        cmb03		LIKE cmb_file.cmb03,
        cmb04		LIKE cmb_file.cmb04,
        cmb05		LIKE cmb_file.cmb05,
        cmb06		LIKE cmb_file.cmb06
                    END RECORD,
    g_buf           LIKE type_file.chr1000,             #                           #No.FUN-680122 VARCHAR(78), 
    g_rec_b_1       LIKE type_file.num10,              #單身1筆數
    g_rec_b_2       LIKE type_file.num10,              #單身2筆數
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_sl            LIKE type_file.num5                                             #No.FUN-680122 SMALLINT              #目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_cnt           LIKE type_file.num10             #No.FUN-680122 INTEGER
DEFINE g_msg           LIKE type_file.chr1000           #No.FUN-680122 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE g_d_flag        LIKE type_file.chr1   #FUN-950058
 
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0146
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    LET p_row = 2 LET p_col = 10
    OPEN WINDOW i210_w AT p_row,p_col
        WITH FORM "axc/42f/axci210"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_d_flag = '1' #FUN-950058
 
    SELECT * INTO g_cmz.*
      FROM cmz_file
      WHERE cmz00='0'
    CALL i210()
    CLOSE WINDOW i210_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION i210()
    INITIALIZE g_cma.* TO NULL
    INITIALIZE g_cma_t.* TO NULL
    INITIALIZE g_cma_o.* TO NULL
    CALL i210_lock_cur()
    CALL i210_menu()
END FUNCTION
 
FUNCTION i210_lock_cur()
 
    LET g_forupd_sql = " SELECT * FROM cma_file WHERE cma01 = ? AND cma021 = ? AND cma022 = ? AND cma07 = ? AND cma08 = ? FOR UPDATE " #CHI-9C0025
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i210_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION i210_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE  l_cnt_sql,l_where       STRING  #FUN-950058
DEFINE  l_cma07         LIKE    cma_file.cma07    #CHI-9C0025
 
    CLEAR FORM
    CALL g_cmg.clear() #FUN-950058
    CALL g_cmb.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_cma.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
            cma01,cma021,cma022,cma02,
            cma07,cma08,  #CHI-9C0025 add
            cma03,cma05,cma11,cma12,cma13,cma14, #FUN-8B0047
            cma32,cma25,cma27,cma28,cma29, #FUN-8B0047
            cmauser,cmagrup,cmamodu,cmadate
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN

        #CHI-9C0025--begin--add--
        AFTER FIELD cma07
              LET l_cma07 = get_fldbuf(cma07)
        #CHI-9C0025--end--add-----

        ON ACTION controlp
            CASE
               WHEN INFIELD(cma01) #料件編號
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管                
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form  = "q_ima"
#                  LET g_qryparam.state = "c"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO cma01
                  NEXT FIELD cma01
               #CHI-9C0025--begin--add---
               WHEN INFIELD(cma08)
                 IF l_cma07 MATCHES '[45]' THEN
                    CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                 CASE l_cma07
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"
                    WHEN '5'
                      LET g_qryparam.form = "q_imd09"
                    OTHERWISE EXIT CASE
                 END CASE
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY  g_qryparam.multiret TO cma08
                 NEXT FIELD cma08
                END IF
               #CHI-9C0025--end--add------ 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0 #FUN-950058
       RETURN 
    END IF
    #FUN-950058................begin    
    CONSTRUCT g_wc3 ON cmg04,cmg03,cmg05,cmg06,cmg07,cmg09,cmg08, #FUN-980037
                       cmg10,cmg11  #CHI-970034 add cmg10,cmg11
            FROM s_cmg[1].cmg04,s_cmg[1].cmg03,s_cmg[1].cmg05,s_cmg[1].cmg06, #FUN-980037
                 s_cmg[1].cmg07,s_cmg[1].cmg09,s_cmg[1].cmg08,
                 s_cmg[1].cmg10,s_cmg[1].cmg11                    #CHI-970034
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
        #FUN-980037--begin--ad--
        ON ACTION controlp
            CASE
               WHEN INFIELD(cmg03) #料件編號
#FUN-AA0059---------mod------------str-----------------               
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form  = "q_ima"
#                  LET g_qryparam.state = "c"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO cmg03
                  NEXT FIELD cmg03
               OTHERWISE EXIT CASE
            END CASE
        #FUN-980037--begin--add--
 
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
       LET INT_FLAG = 0
       RETURN 
    END IF
    #FUN-950058................end
    CONSTRUCT g_wc2 ON cmb02,cmb03,cmb04,cmb05,cmb06
            FROM s_cmb[1].cmb02,s_cmb[1].cmb03,s_cmb[1].cmb04,s_cmb[1].cmb05,
                 s_cmb[1].cmb06
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
       LET INT_FLAG = 0 #FUN-950058
       RETURN 
    END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND cmauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cmagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cmagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cmauser', 'cmagrup')
    #End:FUN-980030
 
   #FUN-950058....................begin
    CASE
       WHEN (NOT (g_wc2=' 1=1' OR cl_null(g_wc2))) AND (NOT (g_wc3=' 1=1' OR cl_null(g_wc3)))
            LET l_where =
                      " WHERE cma01=cmb01 ",
                      "   AND cma021=cmb021 ",
                      "   AND cma022=cmb022 ",
                      "   AND cma01=cmg03 ",
                      "   AND cma021=cmg01 ",
                      "   AND cma022=cmg02 ",
                      "   AND cma07=cmg071 ",   #CHI-9C0025
                      "   AND cma08=cmg081 ",   #CHI-9C0025
                      "   AND ",g_wc CLIPPED,
                      "   AND ",g_wc2 CLIPPED,
                      "   AND ",g_wc3 CLIPPED
            
            LET g_sql="SELECT DISTINCT cma01,cma021,cma022,cma07,cma08",  #CHI-9C0025
                      "  FROM cma_file,cmb_file,cmg_file ",
                      l_where CLIPPED,
                      " ORDER BY cma01,cma021,cma022,cma07,cma08"  #CHI-9C0025
            LET l_cnt_sql ="SELECT COUNT(DISTINCT cma01||cma021||cma022||cma07||cma08) ",#CHI-9C0025
                           " FROM cma_file,cmb_file,cmg_file ",l_where CLIPPED
 
       WHEN NOT (g_wc2=' 1=1' OR cl_null(g_wc2))
            LET l_where =
                      " WHERE cma01=cmb01 ",
                      "   AND cma021=cmb021 ",
                      "   AND cma022=cmb022 ",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
            LET g_sql="SELECT DISTINCT cma01,cma021,cma022,cma07,cma08",  #CHI-9C0025
                      "  FROM cma_file,cmb_file ",
                      l_where CLIPPED,
                      " ORDER BY cma01,cma021,cma022,cma07,cma08" #CHI-9C0025
            LET l_cnt_sql ="SELECT COUNT(DISTINCT cma01||cma021||cma022||cma07||cma08) ", #CHI-9C0025
                           " FROM cma_file,cmb_file ",l_where CLIPPED
 
       WHEN NOT (g_wc3=' 1=1' OR cl_null(g_wc3))
            LET l_where =
                      " WHERE cma01=cmg03 ",
                      "   AND cma021=cmg01 ",
                      "   AND cma022=cmg02 ",
                      "   AND cma07=cmg071 ",   #CHI-9C0025
                      "   AND cma08=cmg081 ",   #CHI-9C0025
                      "   AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED
            LET g_sql="SELECT DISTINCT cma01,cma021,cma022,cma07,cma08", #CHI-9C0025
                      "  FROM cma_file,cmg_file ",
                      l_where CLIPPED,
                      " ORDER BY cma01,cma021,cma022,cma07,cma08"  #CHI-9C0025
            LET l_cnt_sql ="SELECT COUNT(DISTINCT cma01||cma021||cma022||cma07||cma08) ",  #CHI-9C0025
                           " FROM cma_file,cmg_file ",l_where CLIPPED
       OTHERWISE
            LET g_sql="SELECT DISTINCT cma01,cma021,cma022,cma07,cma08 FROM cma_file ", #CHI-9C0025
                      " WHERE ",g_wc CLIPPED, " ORDER BY cma01,cma021,cma022,cma07,cma08" #CHI-9C0025
            LET l_cnt_sql ="SELECT COUNT(*) FROM cma_file WHERE ",g_wc CLIPPED
    END CASE
    
    #IF g_wc2=' 1=1' OR cl_null(g_wc2)
    #   THEN LET g_sql="SELECT cma01,cma021,cma022 FROM cma_file ", #FUN-8B0047
    #                  " WHERE ",g_wc CLIPPED, " ORDER BY cma01,cma021,cma022" #FUN-8B0047
    #   ELSE LET g_sql="SELECT cma01,cma021,cma022", #FUN-8B0047
    #                  "  FROM cma_file,cmb_file ",
    #                  " WHERE cma01=cmb01 ",
    #                  "   AND cma021=cmb021 ", #FUN-8B0047
    #                  "   AND cma022=cmb022 ", #FUN-8B0047
    #                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
    #                  " ORDER BY cma01,cma021,cma022"
    #END IF
    #IF g_wc2=' 1=1' THEN
    #   LET g_sql= "SELECT COUNT(*) FROM cma_file WHERE ",g_wc CLIPPED
    #ELSE
    #   LET g_sql= "SELECT COUNT(DISTINCT cma01) FROM cma_file,cmb_file ",
    #              " WHERE ",g_wc CLIPPED,
    #              "   AND ",g_wc2 CLIPPED,
    #              "   AND cma021=cmb021 ", #FUN-8B0047
    #              "   AND cma022=cmb022 ", #FUN-8B0047
    #              "   AND cma01=cmb01"
    #
    #END IF
    #FUN-950058....................end
    PREPARE i210_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i210_cs SCROLL CURSOR WITH HOLD FOR i210_prepare
 
   #PREPARE i210_precount FROM g_sql     #FUN-950058
    PREPARE i210_precount FROM l_cnt_sql #FUN-950058
    DECLARE i210_count CURSOR FOR i210_precount
END FUNCTION
 
FUNCTION i210_menu()
 
   WHILE TRUE
      #FUN-950058.............begin
      CASE g_d_flag
         WHEN "1"
            CALL i210_bp1("G")
         WHEN "2"
            CALL i210_bp2("G")
         OTHERWISE
            LET g_d_flag = '1'
            CALL i210_bp1("G")
      END CASE
      #FUN-950058.............end
     #CALL i210_bp("G")  #FUN-950058 mark
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i210_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i210_q()
            END IF
#        WHEN "delete"
#           IF cl_chk_act_auth() THEN
#              CALL i210_r()
#           END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i210_u()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0015
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                #FUN-950058............begin
                CASE g_d_flag
                   WHEN "1"
                CALL cl_export_to_excel
                      (ui.Interface.getRootNode(),base.TypeInfo.create(g_cmg),'','')
                   WHEN "2"
                      CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cmb),'','')
                END CASE
                #FUN-950058............end
             END IF
         #--
 
#        WHEN "switch_plant"
#           CALL i210_d()
 
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_cma.cma01 IS NOT NULL THEN
                 LET g_doc.column1 = "cma01"
                 LET g_doc.value1 = g_cma.cma01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0019-------add--------end----
      END CASE
   END WHILE
      CLOSE i210_cs
END FUNCTION
 
FUNCTION i210_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
        l_ima02         LIKE ima_file.ima02,
        l_ima12         LIKE ima_file.ima12,         #FUN-7B0118 add
        l_ima08         LIKE ima_file.ima08,         #FUN-7B0118 add
        l_ima131        LIKE ima_file.ima131,        #FUN-7B0118 add
        l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_correct   LIKE type_file.chr1 #FUN-8B0047
   DEFINE l_date      LIKE type_file.dat  #FUN-8B0047
   DEFINE l_n1        LIKE type_file.num5 #CHI-9C0025
 
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
 
    INPUT BY NAME g_cma.cmaoriu,g_cma.cmaorig,
           g_cma.cma01, g_cma.cma021,g_cma.cma022,
           g_cma.cma07, g_cma.cma08,   #CHI-9C0025
           g_cma.cma03, g_cma.cma05, #FUN-8B0047
           g_cma.cma11, g_cma.cma12, g_cma.cma13, g_cma.cma14,
           g_cma.cmauser,g_cma.cmagrup,g_cma.cmamodu,g_cma.cmadate
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i210_set_entry(p_cmd)
           CALL i210_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
          # IF p_cmd='u' THEN NEXT FIELD cma11 END IF
 
        AFTER FIELD cma01
            DISPLAY "AFTER FIELD cma01"
            IF NOT cl_null(g_cma.cma01) THEN
              #FUN-AA0059 -----------------------add start--------------------
               IF NOT s_chk_item_no(g_cma.cma01,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cma01
               END IF 
              #FUN-AA0059 -----------------------add end--------------------
              #str FUN-7B0118 mod
              #SELECT ima02,ima09 
              #  INTO l_ima02,g_cma.cma03
               SELECT ima02,ima12,ima08,ima131     #No.MOD-910080  del ima09
                 INTO l_ima02,l_ima12,l_ima08,l_ima131  #No.MOD-910080  del cma03
              #end FUN-7B0118 mod
                FROM ima_file
               WHERE ima01 = g_cma.cma01 AND imaacti='Y'
               IF SQLCA.SQLCODE THEN
#                 CALL cl_err('sel ima:',SQLCA.SQLCODE,1)   #No.FUN-660127
                  CALL cl_err3("sel","ima_file",g_cma.cma01,"",SQLCA.SQLCODE,"","sel ima",1)  #No.FUN-660127
                  NEXT FIELD cma01
               END IF
              #--------------No.MOD-910080 add
               IF l_ima08 MATCHES '[PV]' THEN
                  LET g_cma.cma03 = '0'
               ELSE
                  LET g_cma.cma03 = '2'
               END IF
              #--------------No.MOD-910080 end
              # #MOD-510001
              #IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              #  (p_cmd = "u" AND g_cma.cma01 != g_cma01_t) THEN
              #    SELECT count(*) INTO l_n FROM cma_file
              #        WHERE cma01 = g_cma.cma01
              #    IF l_n > 0 THEN                  # Duplicated
              #        CALL cl_err(g_cma.cma01,-239,0)
              #        LET g_cma.cma01 = g_cma01_t
              #        DISPLAY BY NAME g_cma.cma01
              #        NEXT FIELD cma01
              #    END IF
              #END IF
              ##--
            END IF
            DISPLAY l_ima02 TO ima02
            DISPLAY l_ima12,l_ima08,l_ima131 TO ima12,ima08,ima131  #FUN-7B0118 add
            DISPLAY BY NAME g_cma.cma03
 
         #FUN-8B0047
         AFTER FIELD cma021
            IF NOT cl_null(g_cma.cma021) THEN
               IF g_cma.cma021 < 0 THEN
                  CALL cl_err('','mfg5034',0)
                  NEXT FIELD cma021
               END IF
            END IF
 
         AFTER FIELD cma022
            IF NOT cl_null(g_cma.cma022) THEN
               IF g_cma.cma022 < 1 OR g_cma.cma022 > 12 THEN
                  CALL cl_err('','aom-580',0)
                  NEXT FIELD cma022
               END IF
               CALL s_azm(g_cma.cma021,g_cma.cma022) 
               RETURNING l_correct, l_date, g_cma.cma02
               DISPLAY BY NAME g_cma.cma02
               IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                 (p_cmd = "u" AND (g_cma.cma01 != g_cma01_t OR
                                   g_cma.cma021 != g_cma021_t OR
                                   g_cma.cma022 != g_cma022_t)) THEN
                   SELECT count(*) INTO l_n FROM cma_file
                       WHERE cma01 = g_cma.cma01
                         AND cma021= g_cma.cma021
                         AND cma022= g_cma.cma022
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_cma.cma01,-239,0)
                       LET g_cma.cma01 = g_cma01_t
                       LET g_cma.cma021= g_cma021_t
                       LET g_cma.cma022= g_cma022_t
                       DISPLAY BY NAME g_cma.cma01
                       DISPLAY BY NAME g_cma.cma021
                       DISPLAY BY NAME g_cma.cma022
                       NEXT FIELD cma01
                   END IF
               END IF
               #--
            END IF
 
        #CHI-9C0025--begin--add-------
        AFTER FIELD cma07
          IF g_cma.cma07 IS NOT NULL THEN
             IF g_cma.cma07 NOT MATCHES '[12345]' THEN
                NEXT FIELD cma07
             END IF
               IF g_cma.cma07 MATCHES'[12]' THEN
                  CALL cl_set_comp_entry("cma08",FALSE)
                  LET g_cma.cma08 = ' '
               ELSE
                  CALL cl_set_comp_entry("cma08",TRUE)
               END IF
          END IF

         AFTER FIELD cma08
          IF NOT cl_null(g_cma.cma08) THEN
             IF p_cmd = "a" OR
              (p_cmd = "u" AND
               (g_cma.cma01 != g_cma01_t OR g_cma.cma021 != g_cma021_t OR
                g_cma.cma022 != g_cma022_t OR
                g_cma.cma07 != g_cma07_t OR g_cma.cma08 != g_cma08_t)) THEN

                CASE g_cma.cma07
                 WHEN 4
                  SELECT pja02 FROM pja_file WHERE pja01 = g_cma.cma08
                                               AND pjaclose='N' 
                  IF SQLCA.sqlcode!=0 THEN
                     CALL cl_err3('sel','pja_file',g_cma.cma08,'',SQLCA.sqlcode,'','',1)
                     NEXT FIELD cma08
                  END IF
                 WHEN 5
                   LET l_n1 = 0
                   SELECT COUNT(*) INTO l_n1 FROM imd_file 
                    WHERE imd09 = g_cma.cma08 
                      AND imdacti = 'Y'
                   IF l_n1=0 THEN
                     CALL cl_err3('sel','imd_file',g_cma.cma08,'',100,'','',1)
                     NEXT FIELD cma08
                  END IF
                 OTHERWISE EXIT CASE
                END CASE
                SELECT count(*) INTO l_n FROM cma_file
                 WHERE cma01 = g_cma.cma01
                   AND cma021 = g_cma.cma021 AND cma022 = g_cma.cma022
                   AND cma07 = g_cma.cma07 AND cma08 = g_cma.cma08
                IF l_n > 0 THEN
                   CALL cl_err('count:',-239,0)
                   NEXT FIELD cma01
                END IF
             END IF
          ELSE
             LET g_cma.cma08=' '
          END IF
        #CHI-9C0025--end--add--------

        AFTER FIELD cma03
            DISPLAY "AFTER FIELD cma03"
            IF NOT cl_null(g_cma.cma03) THEN
               IF g_cma.cma03 NOT MATCHES '[02]' THEN
                  NEXT FIELD cma03
               END IF
            END IF
 
        AFTER FIELD cma05
            DISPLAY "AFTER FIELD cma05"
            IF NOT cl_null(g_cma.cma05) THEN
               IF g_cma.cma05 NOT MATCHES '[ISCB]' THEN
                  NEXT FIELD cma05
               END IF
            END IF
 
        AFTER FIELD cma11
            DISPLAY "AFTER FIELD cma11"
            IF NOT cl_null(g_cma.cma11) THEN
               IF g_cma.cma11 < 0 THEN
                  NEXT FIELD cma11
               END IF
            END IF
 
        AFTER FIELD cma12
            IF NOT cl_null(g_cma.cma12) THEN
               IF g_cma.cma12 < 0 THEN
                  NEXT FIELD cma12
               END IF
            END IF
 
        AFTER FIELD cma13
            IF NOT cl_null(g_cma.cma13) THEN
               IF g_cma.cma13 < 0 THEN
                  NEXT FIELD cma13
               END IF
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_cma.cmauser = s_get_data_owner("cma_file") #FUN-C10039
           LET g_cma.cmagrup = s_get_data_group("cma_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
 
      #MOD-650015 ------------------start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(cma01) THEN
      #          LET g_cma.* = g_cma_t.*
      #          CALL i210_show()
      #          NEXT FIELD cma01
      #      END IF
      #MOD-650015 ------------------end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(cma01) #料件編號
#FUN-AA0059---------mod------------str-----------------               
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form     = "q_ima"
#                  LET g_qryparam.default1 = g_cma.cma01
#                  CALL cl_create_qry() RETURNING g_cma.cma01
                   CALL q_sel_ima(FALSE, "q_ima","",g_cma.cma01,"","","","","",'' ) 
                       RETURNING  g_cma.cma01

#FUN-AA0059---------mod------------end-----------------
#                  CALL FGL_DIALOG_SETBUFFER( g_cma.cma01 )
                  DISPLAY BY NAME g_cma.cma01
                  NEXT FIELD cma01
               #CHI-9C0025--begin--add--------
               WHEN INFIELD(cma08)
                IF g_cma.cma07 MATCHES '[45]' THEN
                    CALL cl_init_qry_var()
                 CASE g_cma.cma07
                    WHEN '4'
                      LET g_qryparam.form = "q_pja"
                    WHEN '5'
                      LET g_qryparam.form = "q_imd09"
                    OTHERWISE EXIT CASE
                 END CASE
                 LET g_qryparam.default1 =g_cma.cma08
                 CALL cl_create_qry() RETURNING g_cma.cma08
                DISPLAY BY NAME g_cma.cma08
                 NEXT FIELD cma08
               END IF
               #CHI-9C0025--end--add-------
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
 
FUNCTION i210_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
      CALL cl_set_comp_entry("cma01,cma03,cma05,cma02,cma021,cma022,cma07,cma08",TRUE) #FUN-8B0047#CHI-9C0025
 
END FUNCTION
 
FUNCTION i210_set_no_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
    IF p_cmd='u'AND g_chkey = 'N' THEN        #No.FUN-570110
        CALL cl_set_comp_entry("cma01,cma03,cma05,cma02,cma021,cma022,cma07,cma08",FALSE) #FUN-8B0047 #CHI-9C0025
    END IF
    #CHI-9C0025--begin--add----
    IF p_cmd = 'u' AND g_chkey MATCHES '[Yy]' AND
       (NOT g_before_input_done) THEN
       IF g_cma.cma07 MATCHES'[12]' THEN
          CALL cl_set_comp_entry("cma08",FALSE)
       ELSE
          CALL cl_set_comp_entry("cma08",TRUE)
       END IF
    END IF
    #CHI-9C0025--end--add---
END FUNCTION
 
FUNCTION i210_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cma.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i210_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_cmg.clear() #FUN-950058
        CALL g_cmb.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i210_count
    FETCH i210_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i210_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cma.cma01,SQLCA.sqlcode,0)
        INITIALIZE g_cma.* TO NULL
    ELSE
        CALL i210_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i210_fetch(p_flcma)
    DEFINE
        p_flcma         LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1),
        l_abso          LIKE type_file.num10         #No.FUN-680122 INTEGER
 
    CASE p_flcma
       #WHEN 'N' FETCH NEXT     i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022 #FUN-8B0047 #FUN-950058
       #WHEN 'P' FETCH PREVIOUS i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022 #FUN-8B0047 #FUN-950058
       #WHEN 'F' FETCH FIRST    i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022 #FUN-8B0047 #FUN-950058
       #WHEN 'L' FETCH LAST     i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022 #FUN-8B0047 #FUN-950058
        WHEN 'N' FETCH NEXT     i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022, #FUN-950058
                                             g_cma.cma07,g_cma.cma08   #CHI-9C0025
        WHEN 'P' FETCH PREVIOUS i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022, #FUN-950058
                                             g_cma.cma07,g_cma.cma08   #CHI-9C0025
        WHEN 'F' FETCH FIRST    i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022, #FUN-950058
                                             g_cma.cma07,g_cma.cma08   #CHI-9C0025
        WHEN 'L' FETCH LAST     i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022, #FUN-950058
                                             g_cma.cma07,g_cma.cma08   #CHI-9C0025
        WHEN '/'
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
           #FETCH ABSOLUTE l_abso i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022 #FUN-8B0047 #FUN-950058
           FETCH ABSOLUTE l_abso i210_cs INTO g_cma.cma01,g_cma.cma021,g_cma.cma022, #FUN-950058
                                              g_cma.cma07,g_cma.cma08   #CHI-9C0025
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cma.cma01,SQLCA.sqlcode,0)
        INITIALIZE g_cma.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcma
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT cma_file.*
      INTO g_cma.* FROM cma_file       # 重讀DB,因TEMP有不被更新特性 #FUN-950058
       WHERE cma01=g_cma.cma01    #FUN-950058
         AND cma021=g_cma.cma021  #FUN-950058
         AND cma022=g_cma.cma022  #FUN-950058
         AND cma07=g_cma.cma07    #CHI-9C0025
         AND cma08=g_cma.cma08    #CHI-9C0025
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cma.cma01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","cma_file",g_cma.cma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
        LET g_data_owner=g_cma.cmauser           #FUN-4C0061權限控管
        LET g_data_group=g_cma.cmagrup
        CALL i210_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i210_show()
    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima12  LIKE ima_file.ima12,    #FUN-7B0118 add
           l_ima08  LIKE ima_file.ima08,    #FUN-7B0118 add
           l_ima131 LIKE ima_file.ima131    #FUN-7B0118 add
 
    LET g_cma_t.* = g_cma.*
    DISPLAY BY NAME g_cma.cmaoriu,g_cma.cmaorig,
           g_cma.cma021,g_cma.cma022,g_cma.cma32,g_cma.cma25, #FUN-8B0047
           g_cma.cma07,g_cma.cma08, #CHI-9C0025
           g_cma.cma27,g_cma.cma28,g_cma.cma29, #FUN-8B0047
           g_cma.cma01, g_cma.cma02, g_cma.cma03, g_cma.cma05,
           g_cma.cma11, g_cma.cma12, g_cma.cma13, g_cma.cma14,
           g_cma.cmauser,g_cma.cmagrup,g_cma.cmamodu,g_cma.cmadate,g_cma.cma16  #CHI-C20059 add cma16
   #str FUN-7B0118 mod
   #增加顯示"成本分群"(ima12),"來源碼"(ima08),"產品分類"(ima131)
   #SELECT ima02 INTO l_ima02 
    SELECT ima02,ima12,ima08,ima131 INTO l_ima02,l_ima12,l_ima08,l_ima131
   #end FUN-7B0118 mod
      FROM ima_file WHERE ima01=g_cma.cma01
    DISPLAY l_ima02  TO ima02
    DISPLAY l_ima12,l_ima08,l_ima131 TO ima12,ima08,ima131   #FUN-7B0118 add
    CALL i210_b_fill_1(g_wc3)  #FUN-950058
    CALL i210_b_fill_2(g_wc2)  #FUN-950058 rename _2
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i210_a()
DEFINE l_correct   LIKE type_file.chr1 #FUN-970102
DEFINE l_date      LIKE type_file.dat  #FUN-970102
 
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM
    CALL g_cmg.clear() #FUN-950058
    CALL g_cmb.clear()
    LET g_cma_t.*=g_cma.*
    INITIALIZE g_cma.* TO NULL
    LET g_cma.cmauser = g_user
    LET g_cma.cmaoriu = g_user #FUN-980030
    LET g_cma.cmaorig = g_grup #FUN-980030
    LET g_cma.cmagrup = g_grup               #使用者所屬群
    LET g_cma.cmadate = g_today
    LET g_cma.cma05='C'
   #LET g_cma.cma02 = g_cmz.cmz01   #FUN-970102
    LET g_cma.cma021= g_ccz.ccz01 #FUN-8B0047
    LET g_cma.cma022= g_ccz.ccz02 #FUN-8B0047
    CALL s_azm(g_cma.cma021,g_cma.cma022) RETURNING l_correct, l_date, g_cma.cma02 #FUN-970102
    DISPLAY BY NAME g_cma.cma02  #FUN-970102
    LET g_cma.cma11 = 0
    LET g_cma.cma12 = 0
    LET g_cma.cma13 = 0
    LET g_cma.cma14 = 0
    LET g_cma_t.*=g_cma.*
    LET g_cma01_t = NULL
    LET g_cma021_t = NULL  #CHI-9C0025
    LET g_cma022_t = NULL  #CHI-9C0025
    LET g_cma07_t = NULL   #CHI-9C0025
    LET g_cma08_t = NULL   #CHI-9C0025
    CALL cl_opmsg('a')
    WHILE TRUE

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE 
       END IF
#FUN-BC0062 --end--
        LET g_cma.cma07 = g_ccz.ccz28   #CHI-9C0025
        LET g_cma.cma08 = ' '           #CHI-9C0025
        CALL i210_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_cma.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_cmg.clear() #FUN-950058
            CALL g_cmb.clear()
            EXIT WHILE
        END IF
        IF g_cma.cma01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        IF cl_null(g_cma.cma08) THEN LET g_cma.cma08 = ' ' END IF  #CHI-9C0025 
        LET g_cma.cmalegal = g_legal   #FUN-A50075
        INSERT INTO cma_file VALUES(g_cma.*)
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cma.cma01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","cma_file",g_cma.cma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            LET g_cma_t.* = g_cma.*                # 保存上筆資料
            SELECT cma01,cma021,cma022,cma07,cma08      #CHI-9C0025
              INTO g_cma.cma01,g_cma.cma021,g_cma.cma022,g_cma.cma07,g_cma.cma08 #CHI-9C0025
              FROM cma_file
             WHERE cma01 = g_cma.cma01
               AND cma021= g_cma.cma021 #FUN-8B0047
               AND cma022= g_cma.cma022 #FUN-8B0047
               AND cma07 = g_cma.cma07  #CHI-9C0025
               AND cma08 = g_cma.cma08  #CHI-9C0025
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i210_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cma.cma01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cma.* FROM cma_file
     WHERE cma01=g_cma.cma01 AND cma02=g_cma.cma02
        AND cma021= g_cma.cma021 #FUN-8B0047
        AND cma022= g_cma.cma022 #FUN-8B0047
        AND cma07 = g_cma.cma07  #CHI-9C0025
        AND cma08 = g_cma.cma08  #CHI-9C0025
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i210_cl USING g_cma.cma01,g_cma.cma021,g_cma.cma022,g_cma.cma07,g_cma.cma08   #CHI-9C0025
    IF STATUS THEN
      CALL cl_err("OPEN i210_cl:", STATUS, 1)   
       CLOSE i210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i210_cl INTO g_cma.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cma.cma01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cma01_t = g_cma.cma01
    LET g_cma021_t = g_cma.cma021 #FUN-8B0047
    LET g_cma022_t = g_cma.cma022 #FUN-8B0047
    LET g_cma07_t  = g_cma.cma07  #CHI-9C0025
    LET g_cma08_t  = g_cma.cma08  #CHI-9C0025
    LET g_cma_o.*=g_cma.*
    LET g_cma.cmamodu=g_user                     #修改者
    LET g_cma.cmadate = g_today                  #修改日期
    CALL i210_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i210_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cma.*=g_cma_t.*
            CALL i210_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cma_file SET cma_file.* = g_cma.*    # 更新DB
            WHERE cma01 = g_cma_t.cma01 AND cma021 = g_cma_t.cma021 AND cma022 = g_cma_t.cma022            # COLAUTH?
              AND cma07 = g_cma_t.cma07 AND cma08 = g_cma_t.cma08  #CHI-9C0025
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cma.cma01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("upd","cma_file",g_cma01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i210_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i210_r()
    DEFINE l_chr   LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
           l_cnt   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cma.cma01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT count(*) INTO l_cnt FROM cmb_file WHERE cmb01 = g_cma.cma01
    IF l_cnt > 0 THEN
       CALL cl_err(g_cma.cma01,'axc-190',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN i210_cl USING g_cma.cma01,g_cma.cma021,g_cma.cma022,g_cma.cma07,g_cma.cma08  #CHI-9C0025
    IF STATUS THEN
       CALL cl_err("OPEN i210_cl:", STATUS, 1)
       CLOSE i210_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i210_cl INTO g_cma.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_cma.cma01,SQLCA.sqlcode,0) RETURN END IF
    CALL i210_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cma01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cma.cma01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM cma_file WHERE cma01 = g_cma.cma01 AND cma021 = g_cma.cma021 AND cma022 = g_cma.cma022
                               AND cma07 = g_cma.cma07 AND cma08 = g_cma.cma08  #CHI-9C0025
        IF STATUS THEN 
#          CALL cl_err('del cma:',STATUS,0)       #No.FUN-660127
           CALL cl_err3("del","cma_file",g_cma.cma01,"",STATUS,"","del cma:",1)  #No.FUN-660127
           RETURN END IF
        DELETE FROM cmb_file WHERE cmb01 = g_cma.cma01
           AND cmb021= g_cma.cma021 #FUN-8B0047
           AND cmb022= g_cma.cma022 #FUN-8B0047
        IF STATUS THEN 
#          CALL cl_err('del cmb:',STATUS,0)      #No.FUN-660127
           CALL cl_err3("del","cmb_file",g_cma.cma01,"",STATUS,"","del cmb:",1)  #No.FUN-660127
           RETURN END IF
        INITIALIZE g_cma.* TO NULL
        CLEAR FORM
        CALL g_cmg.clear() #FUN-950058
        CALL g_cmb.clear()
    END IF
    CLOSE i210_cl
    COMMIT WORK
END FUNCTION
{
FUNCTION i210_out(p_cmd)
   DEFINE p_cmd		    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_cmd		    LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(400),  
          l_wc          LIKE type_file.chr1000            #No.FUN-680122 VARCHAR(200) 
 
   CALL cl_wait()
   IF p_cmd= 'a'
      THEN LET l_wc = 'cma01="',g_cma.cma01,'"' 		# "新增"則印單張
      ELSE LET l_wc = g_wc                     			# 其他則印多張
   END IF
   IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
      #CALL cl_err('',-400,0) END IF
   LET l_cmd = "axcr510",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
}
FUNCTION i210_d()
   DEFINE l_plant,l_dbs	LIKE type_file.chr21          #No.FUN-680122CHAR(21)
 
            LET INT_FLAG = 0  ######add for prompt bug
   PROMPT 'PLANT CODE:' FOR l_plant
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
#         CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END PROMPT
   IF l_plant IS NULL THEN RETURN END IF
   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
   DATABASE l_dbs
#   CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
   CALL cl_ins_del_sid(1,l_plant) #FUN-980030  #FUN-990069
   IF STATUS THEN ERROR 'open database error!' RETURN END IF
   LET g_plant = l_plant
   LET g_dbs   = l_dbs
   CALL i210_lock_cur()
END FUNCTION
 
FUNCTION i210_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200) 
 
    CONSTRUCT l_wc2 ON cmb02,cmb03,cmb04,cmb05,cmb06
            FROM s_cmb[1].cmb02,s_cmb[1].cmb03,s_cmb[1].cmb04,s_cmb[1].cmb05,
                 s_cmb[1].cmb06
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
    CALL i210_b_fill_2(l_wc2) #FUN-950058 rename _2
END FUNCTION
 
#FUN-950058.............begin
FUNCTION i210_b_fill_1(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING
 
    LET g_sql =
        "SELECT cmg04,cmg03,cmg05,cmg06,cmg07,cmg09,cmg08,cmg10,cmg11", #CHI-970034 add cmg10,cmg11#FUN-980037
        " FROM cmg_file ",
        " WHERE cmg03 ='",g_cma.cma01,"' ",
        "   AND ",p_wc2 CLIPPED,
        "   AND cmg01=",g_cma.cma021,
        "   AND cmg02=",g_cma.cma022,
        "   AND cmg071='",g_cma.cma07,"' ",  #CHI-9C0025
        "   AND cmg081='",g_cma.cma08,"' ",  #CHI-9C0025
        " ORDER BY cmg04"
    PREPARE i210_pb_cmg FROM g_sql
    DECLARE cmg_curs CURSOR FOR i210_pb_cmg
    CALL g_cmg.clear()
    LET g_rec_b_1 = 0
    LET g_cnt = 1
    FOREACH cmg_curs INTO g_cmg[g_cnt].*   #單身 ARRAY 填充
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
    LET g_rec_b_1=(g_cnt-1)
    DISPLAY g_rec_b_1 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
#FUN-950058.............end
 
FUNCTION i210_b_fill_2(p_wc2)              #BODY FILL UP #FUN-950058 rename _2
DEFINE
    p_wc2           STRING       #No.FUN-680122 VARCHAR(200)  #FUN-950058
 
    LET g_sql =
        "SELECT cmb02,cmb03,cmb04,cmb05,cmb06",
        " FROM cmb_file ",
        " WHERE cmb01 ='",g_cma.cma01,"' ",
        "   AND cmb021=",g_cma.cma021, #FUN-8B0047
        "   AND cmb022=",g_cma.cma022, #FUN-8B0047
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 2,1"
    PREPARE i210_pb FROM g_sql
    DECLARE cmb_curs CURSOR FOR i210_pb
    CALL g_cmb.clear()
    LET g_rec_b_2 = 0  #FUN-950058
    LET g_cnt = 1
    FOREACH cmb_curs INTO g_cmb[g_cnt].*   #單身 ARRAY 填充
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
    LET g_rec_b_2=(g_cnt-1) #FUN-950058
   #DISPLAY g_rec_b_2 TO FORMONLY.cn2 #FUN-950058
    DISPLAY g_rec_b_2 TO FORMONLY.cn3 #FUN-950058
    LET g_cnt = 0
END FUNCTION
 
#FUN-950058............begin
FUNCTION i210_bp1(p_ud)  
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cmg TO s_cmg.* ATTRIBUTE(COUNT=g_rec_b_1,UNBUFFERED)  #FUN-950058
 
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
#     ON ACTION delete
#        LET g_action_choice="delete"
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b_1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b_1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b_1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b_1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i210_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b_1 != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	       ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 #MOD-530170
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#     ON ACTION switch_plant
#        LET g_action_choice="switch_plant"
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION d_page1
         LET g_d_flag = '1'
         EXIT DISPLAY
 
      ON ACTION d_page2
         LET g_d_flag = '2'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-950058............end
 
FUNCTION i210_bp2(p_ud)  #FUN-950058 rename
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cmb TO s_cmb.* ATTRIBUTE(COUNT=g_rec_b_2,UNBUFFERED)  #FUN-950058
 
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
#     ON ACTION delete
#        LET g_action_choice="delete"
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b_2 != 0 THEN  #FUN-950058
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b_2 != 0 THEN  #FUN-950058
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b_2 != 0 THEN  #FUN-950058
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b_2 != 0 THEN  #FUN-950058
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i210_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b_2 != 0 THEN  #FUN-950058
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 #MOD-530170
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
#     ON ACTION switch_plant
#        LET g_action_choice="switch_plant"
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0015
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      #FUN-950058...............begin
      ON ACTION d_page1
         LET g_d_flag = '1'
         EXIT DISPLAY
 
      ON ACTION d_page2
         LET g_d_flag = '2'
         EXIT DISPLAY
      #FUN-950058...............end
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #

