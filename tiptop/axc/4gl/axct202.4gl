# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axct202.4gl
# Descriptions...: 每日產品投入工時維護作業
# Date & Author..: 06/01/24 By Sarah
# Modify.........: No.FUN-610080 06/01/24 By Sarah 新增"每日產品投入工時維護作業"
# Modify.........: No.MOD-640412 06/04/12 By Sarah 新增時不用Default成本中心
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-670067 06/07/19 By Johnray voucher型報表轉template1
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0075 06/10/23 By bnlent g_no_ask --> mi_no_ask 
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/10 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/06 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-880023 08/08/05 By Pengu 1.複製已確認的單據時，應該將確認碼更改為N
#                                                  2.單頭成本中心應允許開窗，且檢核輸入值是否正確
# Modify.........: No.FUN-830164 08/09/22 By dxfwo   報表改由CR輸出
# Modify.........: No.CHI-970021 09/08/21 By jan 新增srl09欄位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0145 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C80046 12/08/20 By bart 複製後停在新資料畫
# Modify.........: No:CHI-C80041 13/01/03 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_srk     RECORD LIKE srk_file.*,
    g_srk_t   RECORD LIKE srk_file.*,
    g_srk_o   RECORD LIKE srk_file.*,
    g_srk01_t LIKE srk_file.srk01,
    b_srl     RECORD LIKE srl_file.*,
    g_wc,g_wc2,g_sql STRING,  #No.FUN-580092 HCN
    g_srl            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        srl03         LIKE srl_file.srl03,
        srl04         LIKE srl_file.srl04,
        ima02         LIKE ima_file.ima02,
        ima021        LIKE ima_file.ima021,
        ima55         LIKE ima_file.ima55,
        srl06         LIKE srl_file.srl06,
        srl05         LIKE srl_file.srl05,
        srl09         LIKE srl_file.srl09,  #CHI-970021
        srl08         LIKE srl_file.srl08,
       #FUN-840202 --start---
        srlud01       LIKE srl_file.srlud01,
        srlud02       LIKE srl_file.srlud02,
        srlud03       LIKE srl_file.srlud03,
        srlud04       LIKE srl_file.srlud04,
        srlud05       LIKE srl_file.srlud05,
        srlud06       LIKE srl_file.srlud06,
        srlud07       LIKE srl_file.srlud07,
        srlud08       LIKE srl_file.srlud08,
        srlud09       LIKE srl_file.srlud09,
        srlud10       LIKE srl_file.srlud10,
        srlud11       LIKE srl_file.srlud11,
        srlud12       LIKE srl_file.srlud12,
        srlud13       LIKE srl_file.srlud13,
        srlud14       LIKE srl_file.srlud14,
        srlud15       LIKE srl_file.srlud15
       #FUN-840202 --end--
                     END RECORD,
    g_srl_t          RECORD                 #程式變數 (舊值)
        srl03         LIKE srl_file.srl03,
        srl04         LIKE srl_file.srl04,
        ima02         LIKE ima_file.ima02,
        ima021        LIKE ima_file.ima021,
        ima55         LIKE ima_file.ima55,
        srl06         LIKE srl_file.srl06,
        srl05         LIKE srl_file.srl05,
        srl09         LIKE srl_file.srl09,  #CHI-970021
        srl08         LIKE srl_file.srl08,
       #FUN-840202 --start---
        srlud01       LIKE srl_file.srlud01,
        srlud02       LIKE srl_file.srlud02,
        srlud03       LIKE srl_file.srlud03,
        srlud04       LIKE srl_file.srlud04,
        srlud05       LIKE srl_file.srlud05,
        srlud06       LIKE srl_file.srlud06,
        srlud07       LIKE srl_file.srlud07,
        srlud08       LIKE srl_file.srlud08,
        srlud09       LIKE srl_file.srlud09,
        srlud10       LIKE srl_file.srlud10,
        srlud11       LIKE srl_file.srlud11,
        srlud12       LIKE srl_file.srlud12,
        srlud13       LIKE srl_file.srlud13,
        srlud14       LIKE srl_file.srlud14,
        srlud15       LIKE srl_file.srlud15
       #FUN-840202 --end--
                     END RECORD,
    g_rec_b          LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac             LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql  STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_cnt         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_msg         LIKE ze_file.ze03            #No.FUN-680122 VARCHAR(72)
DEFINE g_i           LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_row_count   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_curs_index  LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_jump        LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5          #No.FUN-680122 SMALLINT   #No.FUN-6A0075
DEFINE g_confirm     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
DEFINE g_approve     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
DEFINE g_post        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
DEFINE g_close       LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
DEFINE g_void        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
DEFINE g_valid       LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
DEFINE l_table       STRING                       #No.FUN-830164                                                             
DEFINE l_sql         STRING                       #No.FUN-830164                                                             
DEFINE g_str         STRING                       #No.FUN-830164
DEFINE g_sql_tmp     STRING                       #CHI-970021
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0146
DEFINE    p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-830164---Begin 
   LET g_sql = " srk01.srk_file.srk01,",
               " srk03.srk_file.srk03,",
               " l_gem02.gem_file.gem02,",
               " srk02.srk_file.srk02,", 
               " srkfirm.srk_file.srkfirm,",
               " srl03.srl_file.srl03,",
               " srl04.srl_file.srl04,",
               " ima02.ima_file.ima02,",
               " ima021.ima_file.ima021,",
               " ima55.ima_file.ima55,", 
               " srl06.srl_file.srl06,", 
               " srl05.srl_file.srl05,", 
               " srl08.srl_file.srl08 "
   LET l_table = cl_prt_temptable('axct202',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF            
#No.FUN-830164---End  
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW t202_w AT p_row,p_col WITH FORM "axc/42f/axct202"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL t202()
   CLOSE WINDOW t202_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t202()
    INITIALIZE g_srk.* TO NULL
    INITIALIZE g_srk_t.* TO NULL
    INITIALIZE g_srk_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM srk_file WHERE srk01 = ? AND srk02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t202_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL t202_menu()
END FUNCTION
 
FUNCTION t202_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_srl.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_srk.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON srk01,srk02,srk03,srkfirm,srk05,
                           #FUN-840202   ---start---
                              srkud01,srkud02,srkud03,srkud04,srkud05,
                              srkud06,srkud07,srkud08,srkud09,srkud10,
                              srkud11,srkud12,srkud13,srkud14,srkud15
                           #FUN-840202    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION controlp
          CASE
             WHEN INFIELD(srk02)  #成本中心
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gem"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srk02
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
 
    CONSTRUCT g_wc2 ON srl03,srl04,srl05,srl09,srl08 #CHI-970021 add srl09
                     #No.FUN-840202 --start--
                      ,srlud01,srlud02,srlud03,srlud04,srlud05
                      ,srlud06,srlud07,srlud08,srlud09,srlud10
                      ,srlud11,srlud12,srlud13,srlud14,srlud15
                     #No.FUN-840202 ---end---
         FROM s_srl[1].srl03,s_srl[1].srl04,s_srl[1].srl05,
              s_srl[1].srl09,s_srl[1].srl08   #CHI-970021
            #No.FUN-840202 --start--
             ,s_srl[1].srlud01,s_srl[1].srlud02,s_srl[1].srlud03
             ,s_srl[1].srlud04,s_srl[1].srlud05,s_srl[1].srlud06
             ,s_srl[1].srlud07,s_srl[1].srlud08,s_srl[1].srlud09
             ,s_srl[1].srlud10,s_srl[1].srlud11,s_srl[1].srlud12
             ,s_srl[1].srlud13,s_srl[1].srlud14,s_srl[1].srlud15
            #No.FUN-840202 ---end---
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
 
       ON ACTION controlp
       CASE WHEN INFIELD(srl04)
#FUN-AA0059---------mod------------str-----------------	
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima"
#              LET g_qryparam.state = "c"
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
               DISPLAY g_qryparam.multiret TO ccl04
               NEXT FIELD ccl04
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
    IF INT_FLAG THEN RETURN END IF
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND srkuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND srkgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND srkgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('srkuser', 'srkgrup')
    #End:FUN-980030
 
    IF g_wc2=' 1=1' THEN
       LET g_sql="SELECT srk01,srk02 FROM srk_file ",
                 " WHERE ",g_wc CLIPPED, " ORDER BY srk01,srk02"
    ELSE
       LET g_sql="SELECT srk01,srk02",
                 "  FROM srk_file,srl_file ",
                 " WHERE srk01=srl01 AND srk02=srl02",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY srk01,srk02"
    END IF
    PREPARE t202_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE t202_cs SCROLL CURSOR WITH HOLD FOR t202_prepare
 
    IF g_wc2 = " 1=1" THEN                         # 取合乎條件筆數
      #LET g_sql="SELECT COUNT(*) FROM srk_file ", #CHI-970021
       LET g_sql_tmp="SELECT DISTINCT srk01,srk02 FROM srk_file ", #CHI-970021  #No.TQC-9A0145
                     " WHERE ",g_wc CLIPPED, #" ORDER BY srk01,srk02" #CHI-970021
                     "  INTO TEMP x"  #CHI-970021
    ELSE
      #LET g_sql="SELECT COUNT(*)",   #CHI-970021
       LET g_sql_tmp="SELECT DISTINCT srk01,srk02 ", #CHI-970021  #No.TQC-9A0145
                 "  FROM srk_file,srl_file ",
                 " WHERE srk01=srl01 AND srk02=srl02",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    #" ORDER BY srk01,srk02"  #CHI-970021
                     "  INTO TEMP x"  #CHI-970021
    END IF
    DROP TABLE x                            #CHI-970021
    PREPARE t202_precount_x FROM g_sql_tmp  #CHI-970021
    EXECUTE t202_precount_x                 #CHI-970021
    LET g_sql="SELECT COUNT(*) FROM x "     #CHI-970021
    PREPARE t202_precount FROM g_sql
    DECLARE t202_count CURSOR FOR t202_precount
END FUNCTION
 
FUNCTION t202_menu()
 
   WHILE TRUE
      CALL t202_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t202_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t202_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t202_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t202_u()
            END IF
         WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL t202_copy()
           END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t202_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t202_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t202_firm1()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_srk.srkfirm,"","","","",g_srk.srkacti)
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t202_firm2()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_srk.srkfirm,"","","","",g_srk.srkacti)
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_srl),'','')
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_srk.srk01 IS NOT NULL THEN
                LET g_doc.column1 = "srk01"
                LET g_doc.column2 = "srk02"
                LET g_doc.value1 = g_srk.srk01
                LET g_doc.value2 = g_srk.srk02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0019-------add--------end----
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t202_v()             #CHI-D20010
               CALL t202_v(1)            #CHI-D20010
               IF g_srk.srkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_srk.srkfirm,"","","",g_void,g_srk.srkacti)
            END IF
         #CHI-C80041---end 

         #CHI-D20010---add--str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t202_v(2)           
               IF g_srk.srkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_srk.srkfirm,"","","",g_void,g_srk.srkacti)
            END IF
         #CHI-D20010---add--end
      END CASE
   END WHILE
   CLOSE t202_cs
END FUNCTION
 
FUNCTION t202_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_srl.clear()
    INITIALIZE g_srk.* LIKE srk_file.*
    LET g_srk01_t = NULL
    LET g_srk.srk01 = g_today
   #LET g_srk.srk02 = g_grup   #MOD-640412 mark
    LET g_srk.srk05 = 0
    LET g_srk.srkfirm = 'N'
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_srk.srkacti ='Y'                   # 有效的資料
        LET g_srk.srkuser = g_user
        LET g_srk.srkoriu = g_user #FUN-980030
        LET g_srk.srkorig = g_grup #FUN-980030
        LET g_srk.srkgrup = g_grup               # 使用者所屬群
        LET g_srk.srkdate = g_today
        LET g_srk.srkinpd = g_today
        CALL t202_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_srl.clear()
            EXIT WHILE
        END IF
        IF g_srk.srk01 IS NULL THEN              # KEY 不可空白
           CONTINUE WHILE
        END IF
        INSERT INTO srk_file VALUES(g_srk.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)   #No.FUN-660127
           CALL cl_err3("ins","srk_file",g_srk.srk01,g_srk.srk02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
           CONTINUE WHILE
        ELSE
           LET g_srk_t.* = g_srk.*               # 保存上筆資料
           SELECT srk01,srk02 INTO g_srk.srk01,g_srk.srk02 FROM srk_file
                  WHERE srk01 = g_srk.srk01 AND
                        srk02 = g_srk.srk02
        END IF
        LET g_rec_b=0
        CALL t202_b('0')
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t202_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,       #No.FUN-680122 VARCHAR(1)
        l_flag          LIKE type_file.chr1,       #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(1)
        l_n             LIKE type_file.num5        #No.FUN-680122 SMALLINT
    CALL cl_set_head_visible("","YES")            #No.FUN-6A0092 
 
    INPUT BY NAME g_srk.srkoriu,g_srk.srkorig,
           g_srk.srk01,g_srk.srk02,g_srk.srk03,
           g_srk.srkfirm,
           g_srk.srkuser,g_srk.srkgrup,g_srk.srkmodu,g_srk.srkdate,
         #FUN-840202     ---start---
           g_srk.srkud01,g_srk.srkud02,g_srk.srkud03,g_srk.srkud04,
           g_srk.srkud05,g_srk.srkud06,g_srk.srkud07,g_srk.srkud08,
           g_srk.srkud09,g_srk.srkud10,g_srk.srkud11,g_srk.srkud12,
           g_srk.srkud13,g_srk.srkud14,g_srk.srkud15
         #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t202_set_entry(p_cmd)
            CALL t202_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD srk01
            ##--No:9310
            IF NOT cl_null(g_srk.srk01) THEN
               IF (p_cmd='a') OR (p_cmd='u' AND g_srk.srk01!=g_srk_t.srk01) THEN #MOD-580263 add
                  SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
                  IF g_sma.sma53 IS NOT NULL AND g_srk.srk01 <= g_sma.sma53 THEN
                     CALL cl_err('','mfg9999',0)
                     NEXT FIELD srk01
                  END IF
               END IF
            END IF
            #--No:9310
 
        AFTER FIELD srk02
            IF NOT cl_null(g_srk.srk02) THEN
               LET g_msg=NULL
               SELECT gem02 INTO g_msg FROM gem_file WHERE gem01=g_srk.srk02
                  AND gemacti='Y'   #NO:6950
               IF STATUS THEN 
#                 CALL cl_err('sel gem:',STATUS,1)    #No.FUN-660127
                  CALL cl_err3("sel","gem_file",g_srk.srk02,"",STATUS,"","sel gem:",1)  #No.FUN-660127
                  NEXT FIELD srk02   #MOD-640412 add
               END IF
               DISPLAY g_msg TO gem02
               IF (g_srk.srk01 != g_srk01_t) OR (g_srk01_t IS NULL) THEN
                  SELECT count(*) INTO g_cnt FROM srk_file
                   WHERE srk01 = g_srk.srk01 AND srk02 = g_srk.srk02
                  IF g_cnt > 0 THEN                   # 資料重複
                     CALL cl_err('count>1:',-239,0)
                     LET g_srk.srk01 = g_srk01_t
                     DISPLAY BY NAME g_srk.srk01
                     NEXT FIELD srk01
                  END IF
               END IF
            END IF
 
      #FUN-840202     ---start---
        AFTER FIELD srkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      #FUN-840202     ----end----
 
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_srk.srkuser = s_get_data_owner("srk_file") #FUN-C10039
           LET g_srk.srkgrup = s_get_data_group("srk_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF l_flag='Y' THEN NEXT FIELD srk01 END IF
 
        ON KEY(F1)
            NEXT FIELD srk01
 
        ON KEY(F2)
            NEXT FIELD srk06
      #MOD-650015 --start
      #  ON ACTION CONTROLO                        # 沿用所有欄位
      #      IF INFIELD(srk01) THEN
      #         LET g_srk.* = g_srk_t.*
      #         CALL t202_show()
      #         NEXT FIELD srk01
      #      END IF
      #MOD-650015 --end
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(srk02)  #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem"
                  LET g_qryparam.default1 = g_srk.srk02
                  CALL cl_create_qry() RETURNING g_srk.srk02
                  DISPLAY BY NAME g_srk.srk02
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
FUNCTION t202_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("srk01,srk02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t202_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("srk01,srk02",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_srk.* TO NULL              #No.FUN-6A0019 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t202_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       CALL g_srl.clear()
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t202_count
    FETCH t202_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t202_cs                        # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)
       INITIALIZE g_srk.* TO NULL
    ELSE
       CALL t202_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t202_fetch(p_flsrk)
    DEFINE
        p_flsrk          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
 
    CASE p_flsrk
        WHEN 'N' FETCH NEXT     t202_cs INTO g_srk.srk01,g_srk.srk02
        WHEN 'P' FETCH PREVIOUS t202_cs INTO g_srk.srk01,g_srk.srk02
        WHEN 'F' FETCH FIRST    t202_cs INTO g_srk.srk01,g_srk.srk02
        WHEN 'L' FETCH LAST     t202_cs INTO g_srk.srk01,g_srk.srk02
        WHEN '/'
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0075
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t202_cs INTO g_srk.srk01,g_srk.srk02
            LET mi_no_ask = FALSE   #No.FUN-6A0075
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)
        INITIALIZE g_srk.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flsrk
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_srk.* FROM srk_file       # 重讀DB,因TEMP有不被更新特性
     WHERE srk01 = g_srk.srk01 AND srk02 = g_srk.srk02
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)   #No.FUN-660127
       CALL cl_err3("sel","srk_file",g_srk.srk01,g_srk.srk02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
       LET g_data_owner=g_srk.srkuser           #FUN-4C0061權限控管
       LET g_data_group=g_srk.srkgrup
       CALL t202_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t202_show()
    LET g_srk_t.* = g_srk.*
    DISPLAY BY NAME g_srk.srkoriu,g_srk.srkorig,
           g_srk.srk01, g_srk.srk02, g_srk.srk03, g_srk.srk05,
           g_srk.srkfirm,
           g_srk.srkuser,g_srk.srkgrup,g_srk.srkmodu,g_srk.srkdate,
         #FUN-840202     ---start---
           g_srk.srkud01,g_srk.srkud02,g_srk.srkud03,g_srk.srkud04,
           g_srk.srkud05,g_srk.srkud06,g_srk.srkud07,g_srk.srkud08,
           g_srk.srkud09,g_srk.srkud10,g_srk.srkud11,g_srk.srkud12,
           g_srk.srkud13,g_srk.srkud14,g_srk.srkud15
         #FUN-840202     ----end----
 
    LET g_msg=NULL
    SELECT gem02 INTO g_msg FROM gem_file WHERE gem01=g_srk.srk02
    DISPLAY g_msg TO gem02
    #圖形顯示
    #CALL cl_set_field_pic(g_srk.srkfirm,"","","","",g_srk.srkacti)  #CHI-C80041
    IF g_srk.srkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_srk.srkfirm,"","","",g_void,g_srk.srkacti)  #CHI-C80041
    CALL t202_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t202_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_srk.srk01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_srk.* FROM srk_file
     WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
    IF g_srk.srkfirm='X' THEN RETURN END IF  #CHI-C80041
    IF g_srk.srkfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_srk.srkacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_srk.srk01,'9027',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN t202_cl USING g_srk.srk01,g_srk.srk02
    IF STATUS THEN
       CALL cl_err("OPEN t202_cl:", STATUS, 1)
       CLOSE t202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t202_cl INTO g_srk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_srk01_t = g_srk.srk01
    LET g_srk_o.*=g_srk.*
    LET g_srk.srkmodu = g_user                # 修改者
    LET g_srk.srkdate = g_today               # 修改日期
    CALL t202_show()                          # 顯示最新資料
    WHILE TRUE
       CALL t202_i("u")                      # 欄位更改
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_srk.*=g_srk_t.*
          CALL t202_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF
       UPDATE srk_file SET srk_file.* = g_srk.*    # 更新DB
        WHERE srk01 = g_srk.srk01 AND srk02 = g_srk.srk02             # COLAUTH?
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)   #No.FUN-660127
          CALL cl_err3("upd","srk_file",g_srk01_t,g_srk_o.srk02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
          CONTINUE WHILE
       END IF
       EXIT WHILE
    END WHILE
    CLOSE t202_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t202_r()
    DEFINE l_chr   LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
           l_cnt   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_srk.srk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_srk.srkfirm='X' THEN RETURN END IF  #CHI-C80041
    IF g_srk.srkfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    BEGIN WORK
 
    OPEN t202_cl USING g_srk.srk01,g_srk.srk02
    IF STATUS THEN
       CALL cl_err("OPEN t202_cl:", STATUS, 1)
       CLOSE t202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t202_cl INTO g_srk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t202_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "srk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "srk02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_srk.srk01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_srk.srk02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM srk_file WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
        IF STATUS THEN 
#        CALL cl_err('del srk:',STATUS,0)     #No.FUN-660127
         CALL cl_err3("del","srk_file",g_srk.srk01,g_srk.srk02,STATUS,"","del srk:",1)  #No.FUN-660127
        RETURN END IF
        DELETE FROM srl_file WHERE srl01 = g_srk.srk01 AND srl02 = g_srk.srk02
        IF STATUS THEN 
#        CALL cl_err('del srl:',STATUS,0)     #No.FUN-660127
         CALL cl_err3("del","srl_file",g_srk.srk01,g_srk.srk02,STATUS,"","del srl:",1)  #No.FUN-660127
        RETURN END IF
        CLEAR FORM

        #No.TQC-9A0145  --Begin
        DROP TABLE x
        PREPARE t202_precount_x2 FROM g_sql_tmp
        EXECUTE t202_precount_x2
        #No.TQC-9A0145  --End  

        CALL g_srl.clear()
        INITIALIZE g_srk.* TO NULL
        MESSAGE ""
        OPEN t202_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t202_cl
           CLOSE t202_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH t202_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t202_cl 
           CLOSE t202_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t202_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t202_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE   #No.FUN-6A0075
           CALL t202_fetch('/')
        END IF
    END IF
    CLOSE t202_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t202_copy()
   DEFINE  l_n                LIKE type_file.num5,          #No.FUN-680122 SMALLINT
           l_srk              RECORD LIKE srk_file.*,
           l_oldno1,l_newno1  LIKE srk_file.srk01,
           l_oldno2,l_newno2  LIKE srk_file.srk02
 
   IF s_shut(0) THEN RETURN END IF
   IF g_srk.srk01 IS NULL OR g_srk.srk02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL t202_set_entry('a')
   CALL t202_set_no_entry('a')
   LET g_before_input_done = TRUE
   CALL cl_set_head_visible("","YES")              #No.FUN-6A0092
 
   INPUT l_newno1,l_newno2 FROM srk01,srk02
      AFTER FIELD srk01
         IF cl_null(l_newno1) THEN
            NEXT FIELD srk01
         END IF
 
      AFTER FIELD srk02
         IF cl_null(l_newno2) THEN
            NEXT FIELD srk02
         END IF
        #------------No.MOD-880023 add
         LET g_msg=NULL
         SELECT gem02 INTO g_msg FROM gem_file WHERE gem01=l_newno2
            AND gemacti='Y'   
         IF STATUS THEN 
            CALL cl_err3("sel","gem_file",l_newno2,"",STATUS,"","sel gem:",1) 
            NEXT FIELD srk02  
         END IF
         DISPLAY g_msg TO gem02
        #------------No.MOD-880023 end
 
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM srk_file
          WHERE srk01 = l_newno1 AND srk02 = l_newno2
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD srk01
         END IF
         LET g_cnt = 0
         SELECT count(*) INTO g_cnt FROM srl_file
          WHERE srl01 = l_newno1 AND srl02 = l_newno2
         IF g_cnt > 0 THEN
            CALL cl_err(l_newno1,-239,0)
            NEXT FIELD srk01
         END IF
 
       #-----------------No.MOD-880023 add
        ON ACTION controlp
            CASE
               WHEN INFIELD(srk02)  #成本中心
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem"
                  LET g_qryparam.default1 = l_newno2
                  CALL cl_create_qry() RETURNING l_newno2
                  DISPLAY l_newno2 TO srk02
               OTHERWISE EXIT CASE
            END CASE
       #-----------------No.MOD-880023 end
 
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
       DISPLAY BY NAME g_srk.srk01,g_srk.srk02
       RETURN
   END IF
 
   #---------------COPY HEAD---------------
   DROP TABLE y
   SELECT * FROM srk_file
    WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
     INTO TEMP y
   UPDATE y
      SET srk01=l_newno1,   #日期
          srk02=l_newno2,   #成本中心
          srkuser=g_user,   #資料所有者
          srkgrup=g_grup,   #資料所有者所屬群
          srkmodu=NULL,     #資料修改日期
          srkdate=g_today,  #資料建立日期
          srkfirm='N',      #確認碼         #No.MOD-880023 add
          srkacti='Y'       #有效資料
   INSERT INTO srk_file SELECT * FROM y
   IF STATUS OR SQLCA.SQLCODE THEN
#     CALL cl_err('ins srk: ',SQLCA.SQLCODE,1)   #No.FUN-660127
      CALL cl_err3("ins","srk_file",l_newno1,l_newno2,SQLCA.SQLCODE,"","ins srk:",1)  #No.FUN-660127
      LET g_success = 'N'
      ROLLBACK WORK
      RETURN
   END IF
 
   #---------------COPY BODY---------------
   DROP TABLE x
   SELECT * FROM srl_file         #單身複製
    WHERE srl01=g_srk.srk01 AND srl02=g_srk.srk02
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      LET g_msg=g_srk.srk01 CLIPPED,'+',g_srk.srk02 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660127
      CALL cl_err3("ins","x",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
      RETURN
   END IF
   UPDATE x SET srl01 = l_newno1 , srl02 = l_newno2
   INSERT INTO srl_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      LET g_msg=g_srk.srk01 CLIPPED,'+',g_srk.srk02 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660127
      CALL cl_err3("ins","srl_file",g_msg,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
      RETURN
   END IF
   LET g_msg=l_newno1 CLIPPED,'+',l_newno2 CLIPPED
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
   LET l_oldno1 = g_srk.srk01
   LET l_oldno2 = g_srk.srk02
   SELECT * INTO g_srk.* FROM srk_file
    WHERE srk01 = l_newno1 AND srk02 = l_newno2
   CALL t202_b('0')
   #FUN-C80046---begin
   #LET g_srk.srk01 = l_oldno1
   #LET g_srk.srk02 = l_oldno2
   #SELECT * INTO g_srk.* FROM srk_file
   # WHERE srk01 = l_oldno1 AND srk02 = l_oldno2
   #CALL t202_show()
   #DISPLAY BY NAME g_srk.srk01,g_srk.srk02
   #FUN-C80046---end
END FUNCTION
 
FUNCTION t202_out()
   DEFINE
      l_i          LIKE type_file.num5,          #No.FUN-680122 SMALLINT
      sr           RECORD
                    srk01       LIKE srk_file.srk01,   #日期
                    srk02       LIKE srk_file.srk02,   #成本中心
                    srk03       LIKE srk_file.srk03,   #備註
                    srkfirm     LIKE srk_file.srkfirm, #確認碼
                    srl03       LIKE srl_file.srl03,   #序號
                    srl04       LIKE srl_file.srl04,   #產品編號
                    ima02       LIKE ima_file.ima02,   #品名
                    ima021      LIKE ima_file.ima021,  #規格
                    ima55       LIKE ima_file.ima55,   #單位
                    srl06       LIKE srl_file.srl06,   #生產數量
                    srl05       LIKE srl_file.srl05,   #投入工時
                    srl08       LIKE srl_file.srl08    #備註
                   END RECORD,
      l_gem02      LIKE gem_file.gem02,                #部門名稱              
      l_name       LIKE type_file.chr20         #No.FUN-680122  VARCHAR(20)              #External(Disk) file name
 
   IF cl_null(g_srk.srk01) OR cl_null(g_srk.srk02) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
   IF cl_null(g_wc) THEN
      LET g_wc ="  srk01='",g_srk.srk01,"' AND srk02='",g_srk.srk02,"'"
      LET g_wc2=" 1=1 "
   END IF
 
   CALL cl_wait()
#  CALL cl_outnam('axct202') RETURNING l_name                        #No.FUN-830164
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR           #No.FUN-670067
   LET g_pageno = 0
 
   LET g_sql="SELECT srk01,srk02,srk03,srkfirm, ",
             "       srl03,srl04,ima02,ima021,ima55,srl06,srl05,srl08 ",
             "  FROM srk_file,srl_file LEFT OUTER JOIN ima_file ON srl04 = ima01 ",
             " WHERE srk01 = srl01 AND srk02 = srk02 ",
             "   AND ",g_wc CLIPPED,
             "   AND ",g_wc2 CLIPPED
   PREPARE t202_p1 FROM g_sql                # RUNTIME 編譯
   IF STATUS THEN CALL cl_err('t202_p1',STATUS,0) END IF
   DECLARE t202_co CURSOR FOR t202_p1        # CURSOR
 
#  START REPORT t202_rep TO l_name           #No.FUN-830164
   CALL cl_del_data(l_table)                 #No.FUN-830164
 
   FOREACH t202_co INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#No.FUN-830164---Begin
      SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.srk02                                                               
      IF cl_null(l_gem02) THEN LET l_gem02 = ' ' END IF                                                                          
      LET l_gem02 = ' ',l_gem02 
#     OUTPUT TO REPORT t202_rep(sr.*)
      EXECUTE insert_prep USING sr.srk01, sr.srk03, l_gem02, sr.srk02, sr.srkfirm,
                                sr.srl03, sr.srl04, sr.ima02,sr.ima021,sr.ima55,
                                sr.srl06, sr.srl05, sr.srl08 
   END FOREACH
#  FINISH REPORT t202_rep
 
   CLOSE t202_co
   ERROR ""
#  CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
     IF    g_zz05 = 'Y' THEN                                                        
        CALL cl_wcchp(g_wc,'srl03,srl04,srl05,srl08')         
          RETURNING g_wc                                                                                                             
    END IF             
#                 p1     
    LET g_str = g_wc                                                       
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
    CALL cl_prt_cs3('axct202','axct202',l_sql,g_str)
#No.FUN-830164---End
END FUNCTION
#No.FUN-830164---Begin
#REPORT t202_rep(sr)
#   DEFINE
#      l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(01)
#      l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
#      sr              RECORD
#                       srk01       LIKE srk_file.srk01,   #日期
#                       srk02       LIKE srk_file.srk02,   #成本中心
#                       srk03       LIKE srk_file.srk03,   #備註
#                       srkfirm     LIKE srk_file.srkfirm, #確認碼
#                       srl03       LIKE srl_file.srl03,   #序號
#                       srl04       LIKE srl_file.srl04,   #產品編號
#                       ima02       LIKE ima_file.ima02,   #品名
#                       ima021      LIKE ima_file.ima021,  #規格
#                       ima55       LIKE ima_file.ima55,   #單位
#                       srl06       LIKE srl_file.srl06,   #生產數量
#                       srl05       LIKE srl_file.srl05,   #投入工時
#                       srl08       LIKE srl_file.srl08    #備註
#                      END RECORD,
#      l_gem02         LIKE gem_file.gem02                 #部門名稱
#
#    OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.srk01,sr.srk02
#   FORMAT
#      
#   PAGE HEADER 
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#        #No.FUN-670067---Begin   
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED, pageno_total
#        # PRINT COLUMN g_len-7,g_x[3] CLIPPED,g_pageno USING '<<<'
#        #No.FUN-670067---End
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'y'
#
##-----------No.FUN-670067 --begin--
#         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.srk02                                                               
#         IF cl_null(l_gem02) THEN LET l_gem02 = ' ' END IF                                                                          
#         LET l_gem02 = ' ',l_gem02                                                                                                  
#                                                                                                                                    
#         PRINT COLUMN  1,g_x[10],sr.srk01 CLIPPED,                                                                                  
#               COLUMN 41,g_x[11],sr.srk03 CLIPPED                                                                                   
#         PRINT COLUMN  1,g_x[12],sr.srk02 CLIPPED,l_gem02 CLIPPED,                                                                  
#               COLUMN 41,g_x[13],sr.srkfirm CLIPPED  
#         PRINT                                                                                
#         PRINT g_dash2[1,g_len]
#         PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,                                                                     
#               g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED 
#         PRINT g_dash1
##-----------No.FUN-670067 --end--
#
#      BEFORE GROUP OF sr.srk02  #成本中心
#         IF (PAGENO > 1 OR LINENO > 9)
#            THEN SKIP TO TOP OF PAGE
#         END IF
#
##-----------No.FUN-670067 --begin--
##         SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.srk02
##         IF cl_null(l_gem02) THEN LET l_gem02 = ' ' END IF
##         LET l_gem02 = ' ',l_gem02
##
##         PRINT COLUMN  1,g_x[10],sr.srk01 CLIPPED,
##               COLUMN 41,g_x[11],sr.srk03 CLIPPED
##         PRINT COLUMN  1,g_x[12],sr.srk02 CLIPPED,l_gem02 CLIPPED,
##               COLUMN 41,g_x[13],sr.srkfirm CLIPPED
##         PRINT
##         PRINT COLUMN   1,g_x[31],
##               COLUMN   8,g_x[32],
##               COLUMN  39,g_x[33],
##               COLUMN  70,g_x[34],
##               COLUMN 101,g_x[35],
##               COLUMN 106,g_x[36],
##               COLUMN 125,g_x[37],
##               COLUMN 144,g_x[38]
##         PRINT "------ ------------------------------ ",
##               "------------------------------ ------------------------------ ",
##               "---- ------------------ ------------------ --------------------"
##--------No.FUN-670067 --end--
#
#      ON EVERY ROW
#
##--------No.FUN-670067 --begin--
##         PRINT COLUMN   1,sr.srl03,
##               COLUMN   8,sr.srl04,
##               COLUMN  39,sr.ima02,
##               COLUMN  70,sr.ima021,
##               COLUMN 101,sr.ima55,
##               COLUMN 106,cl_numfor(sr.srl06,17,3),
##               COLUMN 125,cl_numfor(sr.srl05,17,3),
##               COLUMN 144,sr.srl08
#         PRINT COLUMN g_c[31],sr.srl03,
#               COLUMN g_c[32],sr.srl04,
#               COLUMN g_c[33],sr.ima02,
#               COLUMN g_c[34],sr.ima021,
#               COLUMN g_c[35],sr.ima55,
#               COLUMN g_c[36],cl_numfor(sr.srl06,36,3),
#               COLUMN g_c[37],cl_numfor(sr.srl05,37,3),
#               COLUMN g_c[38],sr.srl08
##--------No.FUN-670067 --end--
#
#      ON LAST ROW
#         PRINT g_dash[1,g_len]
#         IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
#            IF g_wc.subString(001,080) > ' ' THEN
#               PRINT g_x[8] CLIPPED,g_wc.subString(001,070) CLIPPED
#            END IF
#            IF g_wc.subString(071,140) > ' ' THEN
#               PRINT COLUMN 10,     g_wc.subString(071,140) CLIPPED
#            END IF
#            IF g_wc.subString(141,210) > ' ' THEN
#               PRINT COLUMN 10,     g_wc.subString(141,210) CLIPPED
#            END IF
#            PRINT g_dash[1,g_len]
#         END IF
#         LET l_trailer_sw = 'n'
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#      AFTER  GROUP OF sr.srk02  #成本中心
#         PRINT COLUMN g_c[36],g_x[9] CLIPPED,
#               COLUMN g_c[37],cl_numfor(GROUP SUM(sr.srl05),37,3)
#         PRINT ' '
#
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#END REPORT
#No.FUN-830164---End
 
FUNCTION t202_firm1()
   IF g_srk.srk01 IS NULL THEN RETURN END IF
#CHI-C30107 ----------- add --------------- begin
   IF g_srk.srkfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_srk.srkfirm='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF 
#CHI-C30107 ----------- add --------------- end
   SELECT * INTO g_srk.* FROM srk_file
    WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
   IF g_srk.srkfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_srk.srkfirm='Y' THEN RETURN END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t202_cl USING g_srk.srk01,g_srk.srk02
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t202_cl INTO g_srk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_srk.srkfirm ='Y'
   UPDATE srk_file SET srkfirm = 'Y' WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK LET g_srk.srkfirm ='N'
   END IF
   DISPLAY BY NAME g_srk.srkfirm
END FUNCTION
 
FUNCTION t202_firm2()
   IF g_srk.srk01 IS NULL THEN RETURN END IF
   SELECT * INTO g_srk.* FROM srk_file
    WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
   IF g_srk.srkfirm='X' THEN RETURN END IF  #CHI-C80041
   IF g_srk.srkfirm='N' THEN RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK LET g_success='Y'
 
   OPEN t202_cl USING g_srk.srk01,g_srk.srk02
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t202_cl INTO g_srk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   LET g_srk.srkfirm ='N'
   UPDATE srk_file SET srkfirm = 'N' WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
   IF g_success='Y' THEN
      COMMIT WORK LET g_srk.srkfirm ='N'
   ELSE
      ROLLBACK WORK LET g_srk.srkfirm ='Y'
   END IF
   DISPLAY BY NAME g_srk.srkfirm
END FUNCTION
 
#FUNCTION t202_d()
#   DEFINE l_plant,l_dbs	LIKE type_file.chr21         #No.FUN-680122 VARCHAR(21)
#
#            LET INT_FLAG = 0  ######add for prompt bug
#   PROMPT 'PLANT CODE:' FOR l_plant
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
#
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
#
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
#
#   END PROMPT
#   IF l_plant IS NULL THEN RETURN END IF
#   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#   IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#   DATABASE l_dbs
#   IF STATUS THEN ERROR 'open database error!' RETURN END IF
#   LET g_plant = l_plant
#   LET g_dbs   = l_dbs
#END FUNCTION
 
FUNCTION t202_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(01) 		   #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680122 SMALLINT
    l_yymm          LIKE type_file.num5,          #No.FUN-680122 SMALLINR             #檢查重複用
    l_qty           LIKE type_file.num10,         #No.FUN-680122 INTEGER              #
    l_sfb08,l_sfb09 LIKE sfb_file.sfb08,          #No.FUN-680122 INTEGER              #
    l_sfb81         LIKE sfb_file.sfb81,
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #處理狀態        #No.FUN-680122 VARCHAR(1)
    l_sfb38         LIKE type_file.dat,           #No.FUN-680122 DATE
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5,          #可刪除否        #No.FUN-680122 SMALLINT
    l_cnt           LIKE type_file.num5           #MOD-5C0031        #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_srk.srk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_srk.* FROM srk_file
     WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
    IF g_srk.srkfirm='X' THEN RETURN END IF  #CHI-C80041
    IF g_srk.srkfirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    #--No:9310
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    IF g_sma.sma53 IS NOT NULL AND g_srk.srk01 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0)
       RETURN
    END IF
    #--No:9310
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT srl03,srl04,'','','',srl06,srl05,srl09,srl08, ", #CHI-970021 add srl09
                     #No.FUN-840202 --start--
                       "       srlud01,srlud02,srlud03,srlud04,srlud05,",
                       "       srlud06,srlud07,srlud08,srlud09,srlud10,",
                       "       srlud11,srlud12,srlud13,srlud14,srlud15 ",
                     #No.FUN-840202 ---end---
                       "  FROM srl_file ",
                       " WHERE srl01=? AND srl02=? ",
                       "   AND srl03=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t202_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_srl WITHOUT DEFAULTS FROM s_srl.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t202_cl USING g_srk.srk01,g_srk.srk02
            IF STATUS THEN
               CALL cl_err("OPEN t202_cl:", STATUS, 1)
               CLOSE t202_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t202_cl INTO g_srk.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b>=l_ac THEN
               LET g_srl_t.* = g_srl[l_ac].*  #BACKUP
               LET p_cmd='u'
 
               OPEN t202_bcl USING g_srk.srk01,g_srk.srk02,g_srl_t.srl03
               IF STATUS THEN
                  CALL cl_err("OPEN t202_bcl:", STATUS, 1)
                  CLOSE t202_bcl
                  ROLLBACK WORK
                  RETURN
               END IF
               FETCH t202_bcl INTO g_srl[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_srl_t.srl03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               LET g_srl[l_ac].ima02 = g_srl_t.ima02
               LET g_srl[l_ac].ima021= g_srl_t.ima021
               LET g_srl[l_ac].ima55 = g_srl_t.ima55
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
               EXIT INPUT
            END IF
            INSERT INTO srl_file(srl01,srl02,srl03,srl04,
                                 srl05,srl06,srl08,srl09, #CHI-970021
                               #FUN-840202 --start--
                                 srlud01,srlud02,srlud03,
                                 srlud04,srlud05,srlud06,
                                 srlud07,srlud08,srlud09,
                                 srlud10,srlud11,srlud12,
                                 srlud13,srlud14,srlud15)
                               #FUN-840202 --end--
            VALUES(g_srk.srk01,g_srk.srk02,
                   g_srl[l_ac].srl03,g_srl[l_ac].srl04,
                   g_srl[l_ac].srl05,g_srl[l_ac].srl06,
                   g_srl[l_ac].srl08,g_srl[l_ac].srl09, #CHI-970021
                 #FUN-840202 --start--
                   g_srl[l_ac].srlud01, g_srl[l_ac].srlud02,
                   g_srl[l_ac].srlud03, g_srl[l_ac].srlud04,
                   g_srl[l_ac].srlud05, g_srl[l_ac].srlud06,
                   g_srl[l_ac].srlud07, g_srl[l_ac].srlud08,
                   g_srl[l_ac].srlud09, g_srl[l_ac].srlud10,
                   g_srl[l_ac].srlud11, g_srl[l_ac].srlud12,
                   g_srl[l_ac].srlud13, g_srl[l_ac].srlud14,
                   g_srl[l_ac].srlud15)
                 #FUN-840202 --end--
 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_srl[l_ac].srl03,SQLCA.sqlcode,0)   #No.FUN-660127
               CALL cl_err3("ins","srl_file",g_srk.srk01,g_srk.srk02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
               CALL t202_b_tot()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_srl[l_ac].* TO NULL      #900423
            LET g_srl[l_ac].srl05 = 0
            LET g_srl[l_ac].srl06 = 0
            LET g_srl[l_ac].srl09 = 0   #CHI-970021
            LET g_srl_t.* = g_srl[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD srl03
 
        BEFORE FIELD srl03                        #default 序號
            IF g_srl[l_ac].srl03 IS NULL OR
               g_srl[l_ac].srl03 = 0 THEN
               SELECT max(srl03)+1 INTO g_srl[l_ac].srl03
                 FROM srl_file
                WHERE srl01 = g_srk.srk01 AND srl02 = g_srk.srk02
               IF g_srl[l_ac].srl03 IS NULL THEN
                  LET g_srl[l_ac].srl03 = 1
               END IF
            END IF
 
        AFTER FIELD srl03                        #check 序號是否重複
            IF NOT cl_null(g_srl[l_ac].srl03) THEN
               IF g_srl[l_ac].srl03 != g_srl_t.srl03 OR
                  g_srl_t.srl03 IS NULL THEN
                  SELECT count(*) INTO l_n
                    FROM srl_file
                   WHERE srl01 = g_srk.srk01 AND srl02 = g_srk.srk02
                     AND srl03 = g_srl[l_ac].srl03
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_srl[l_ac].srl03 = g_srl_t.srl03
                     NEXT FIELD srl03
                  END IF
               END IF
            END IF
 
        AFTER FIELD srl04
            IF NOT cl_null(g_srl[l_ac].srl04) THEN
              #FUN-AA0059 ----------------------------add start-----------------------
               IF NOT s_chk_item_no(g_srl[l_ac].srl04,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD srl04
               END IF 
              #FUN-AA0059 ----------------------------add end-------------------------    
               SELECT ima02,ima021,ima55
                 INTO g_srl[l_ac].ima02,g_srl[l_ac].ima021,g_srl[l_ac].ima55
                 FROM ima_file
                WHERE ima01=g_srl[l_ac].srl04
               IF STATUS THEN
#                 CALL cl_err('sel ima:',STATUS,0)    #No.FUN-660127
                  CALL cl_err3("sel","ima_file",g_srl[l_ac].srl04,"",STATUS,"","sel ima:",1)  #No.FUN-660127
                  NEXT FIELD srl04
               END IF
            END IF
            DISPLAY g_srl[l_ac].ima02 TO ima02
            DISPLAY g_srl[l_ac].ima021 TO ima021
            DISPLAY g_srl[l_ac].ima55 TO ima55
 
        AFTER FIELD srl06
            SELECT SUM(srl06) INTO l_qty FROM srl_file
             WHERE srl04=g_srl[l_ac].srl04
               AND srl02=g_srk.srk02
               AND (srl01!=g_srk.srk01 OR srl03!=g_srl[l_ac].srl03)
            IF l_qty IS NULL THEN LET l_qty=0 END IF
            LET l_qty = l_qty + g_srl[l_ac].srl06
 
        #CHI-970021--begin--add-
        AFTER FIELD srl09
          IF NOT cl_null(g_srl[l_ac].srl09) THEN
             IF g_srl[l_ac].srl09 < 0 THEN
                CALL cl_err('','aec-020',0)
                NEXT FIELD srl09
             END IF
          END IF
        #CHI-9700021--end--add--
 
      #No.FUN-840202 --start--
 
        AFTER FIELD srlud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD srlud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_srl_t.srl03 > 0 AND g_srl_t.srl03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM srl_file
                  WHERE srl01 = g_srk.srk01 AND srl02 = g_srk.srk02
                        AND srl03 = g_srl_t.srl03
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_srl_t.srl03,SQLCA.sqlcode,0)
                   CALL cl_err3("del","srl_file",g_srk.srk01,g_srk.srk02,SQLCA.SQLCODE,"","",1)  #No.FUN-660127
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
               CALL t202_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_srl[l_ac].* = g_srl_t.*
               CLOSE t202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_srl[l_ac].srl03,-263,1)
               LET g_srl[l_ac].* = g_srl_t.*
            ELSE
               UPDATE srl_file SET srl03 = g_srl[l_ac].srl03,
                                   srl04 = g_srl[l_ac].srl04,
                                   srl05 = g_srl[l_ac].srl05,
                                   srl06 = g_srl[l_ac].srl06,
                                   srl08 = g_srl[l_ac].srl08,
                                   srl09 = g_srl[l_ac].srl09,  #CHI-970021
                                 #FUN-840202 --start--
                                   srlud01 = g_srl[l_ac].srlud01,
                                   srlud02 = g_srl[l_ac].srlud02,
                                   srlud03 = g_srl[l_ac].srlud03,
                                   srlud04 = g_srl[l_ac].srlud04,
                                   srlud05 = g_srl[l_ac].srlud05,
                                   srlud06 = g_srl[l_ac].srlud06,
                                   srlud07 = g_srl[l_ac].srlud07,
                                   srlud08 = g_srl[l_ac].srlud08,
                                   srlud09 = g_srl[l_ac].srlud09,
                                   srlud10 = g_srl[l_ac].srlud10,
                                   srlud11 = g_srl[l_ac].srlud11,
                                   srlud12 = g_srl[l_ac].srlud12,
                                   srlud13 = g_srl[l_ac].srlud13,
                                   srlud14 = g_srl[l_ac].srlud14,
                                   srlud15 = g_srl[l_ac].srlud15
                                 #FUN-840202 --end-- 
                WHERE srl01=g_srk.srk01 AND srl02=g_srk.srk02
                  AND srl03=g_srl_t.srl03
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_srl[l_ac].srl03,SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","srl_file",g_srk.srk01,g_srk.srk02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                  LET g_srl[l_ac].* = g_srl_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
            CALL t202_b_tot()
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac                 #FUN-D40030 mark
#           CALL g_srl.deleteElement(g_rec_b+1) #MOD-490200  #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_srl[l_ac].* = g_srl_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_srl.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE t202_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac                 #FUN-D40030 add
            CALL g_srl.deleteElement(g_rec_b+1) #FUN-D40030 add 
            CLOSE t202_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE WHEN INFIELD(srl04)
#FUN-AA0059---------mod------------str-----------------
#             CALL cl_init_qry_var()
#             LET g_qryparam.form = "q_ima"
#             LET g_qryparam.default1 = g_srl[l_ac].srl04
#             CALL cl_create_qry() RETURNING g_srl[l_ac].srl04
              CALL q_sel_ima(FALSE, "q_ima","",g_srl[l_ac].srl04,"","","","","",'' ) 
                RETURNING  g_srl[l_ac].srl04   
#FUN-AA0059---------mod------------end-----------------
              DISPLAY g_srl[l_ac].srl04 TO srl04
              NEXT FIELD srl04
           END CASE
 
        ON ACTION controls                                #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")              #No.FUN-6A0092 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(srl03) AND l_ac > 1 THEN
              LET g_srl[l_ac].* = g_srl[l_ac-1].*
              NEXT FIELD srl03
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
    CALL t202_b_tot()
 
   #FUN-5B0113-begin
    LET g_srk.srkmodu = g_user
    LET g_srk.srkdate = g_today
    UPDATE srk_file SET srkmodu = g_srk.srkmodu,srkdate = g_srk.srkdate
     WHERE srk01 = g_srk.srk01
       AND srk02 = g_srk.srk02
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd srk',SQLCA.SQLCODE,1)   #No.FUN-660127
       CALL cl_err3("upd","srk_file",g_srk.srk01,g_srk.srk02,SQLCA.SQLCODE,"","upd srk",1)  #No.FUN-660127
    END IF
    DISPLAY BY NAME g_srk.srkmodu,g_srk.srkdate
   #FUN-5B0113-end
 
   CLOSE t202_bcl
   COMMIT WORK
   CALL t202_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t202_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
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
        #CALL t202_v()     #CHI-D20010
         CALL t202_v(1)    #CHI-D20010
         IF g_srk.srkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_srk.srkfirm,"","","",g_void,g_srk.srkacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041-
         DELETE FROM srk_file  WHERE srk01 = g_srk.srk01 AND srk02 = g_srk.srk02
         INITIALIZE g_srk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
FUNCTION t202_b_tot()
   SELECT SUM(srl05) INTO g_srk.srk05
     FROM srl_file
    WHERE srl01 = g_srk.srk01 AND srl02 = g_srk.srk02
   IF g_srk.srk05 IS NULL THEN LET g_srk.srk05 = 0 END IF
   DISPLAY BY NAME g_srk.srk05
   UPDATE srk_file SET srk05 = g_srk.srk05
    WHERE srk01=g_srk.srk01 AND srk02=g_srk.srk02
END FUNCTION
 
FUNCTION t202_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
    CONSTRUCT g_wc2 ON srl03,srl04,srl05,srl09,srl08  #CHI-970021
                     #No.FUN-840202 --start--
                      ,srlud01,srlud02,srlud03,srlud04,srlud05
                      ,srlud06,srlud07,srlud08,srlud09,srlud10
                      ,srlud11,srlud12,srlud13,srlud14,srlud15
                     #No.FUN-840202 ---end---
         FROM s_srl[1].srl03,s_srl[1].srl04,s_srl[1].srl05,
              s_srl[1].srl09,s_srl[1].srl08  #CHI-970021 add srl09
            #No.FUN-840202 --start--
             ,s_srl[1].srlud01,s_srl[1].srlud02,s_srl[1].srlud03
             ,s_srl[1].srlud04,s_srl[1].srlud05,s_srl[1].srlud06
             ,s_srl[1].srlud07,s_srl[1].srlud08,s_srl[1].srlud09
             ,s_srl[1].srlud10,s_srl[1].srlud11,s_srl[1].srlud12
             ,s_srl[1].srlud13,s_srl[1].srlud14,s_srl[1].srlud15
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t202_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t202_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    LET g_sql =
        "SELECT srl03,srl04,ima02,ima021,ima55,srl06,srl05,srl09,srl08, ", #CHI-970021 add srl09
      #No.FUN-840202 --start--
        "       srlud01,srlud02,srlud03,srlud04,srlud05,",
        "       srlud06,srlud07,srlud08,srlud09,srlud10,",
        "       srlud11,srlud12,srlud13,srlud14,srlud15 ",
      #No.FUN-840202 ---end---
        "  FROM srl_file LEFT OUTER JOIN  ima_file ON srl04 = ima01 ",
        " WHERE srl01 ='",g_srk.srk01,"' AND srl02 ='",g_srk.srk02,"'",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY srl03"
    PREPARE t202_pb FROM g_sql
    DECLARE srl_curs CURSOR FOR t202_pb
 
    CALL g_srl.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH srl_curs INTO g_srl[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_srl.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t202_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_srl TO s_srl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t202_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t202_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
  	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t202_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t202_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t202_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
         #圖形顯示
         #CALL cl_set_field_pic(g_srk.srkfirm,"","","","",g_srk.srkacti)  #CHI-C80041
         IF g_srk.srkfirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_srk.srkfirm,"","","",g_void,g_srk.srkacti)  #CHI-C80041
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
        ON ACTION controls                                     #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")                   #No.FUN-6A0092
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end

      #CHI-D20010--add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010--add---end 
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
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY                                    
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
##wiky just do it
#FUNCTION t202_g()
#
#  DEFINE n INTEGER
#  DEFINE l_cnt INTEGER
#  DEFINE l_srl   RECORD LIKE srl_file.*
#  DEFINE l_srl_t RECORD LIKE srl_file.*
#  DEFINE l_tm RECORD
#            wc   VARCHAR(300)
#            END RECORD
#  DEFINE l_sql_g    VARCHAR(600)
#  DEFINE l_tlf06  LIKE tlf_file.tlf06,
#         l_tlf19  LIKE tlf_file.tlf19,
#         l_tlf026 LIKE tlf_file.tlf026,
#         l_ima58  LIKE ima_file.ima58,
#         l_ima01  LIKE ima_file.ima01,
#         l_ccz01  LIKE ccz_file.ccz01,
#         l_ccz02  LIKE ccz_file.ccz02,
#     #    l_qty1,l_qty,l_tqty   LIKE ima_file.ima26,    #No.FUN-680122 DEC(15,3),#FUN-A20044
#         l_qty1,l_qty,l_tqty   LIKE type_file.num15_3,    #No.FUN-680122 DEC(15,3),#FUN-A20044
#         x RECORD
#           yy,mm LIKE type_file.num5            #No.FUN-680122 smallint
#           END RECORD
#  DEFINE l_flag   LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
#         g_bdate  LIKE type_file.dat,           #No.FUN-680122 DATE,
#         g_edate  LIKE type_file.dat            #No.FUN-680122 DATE
#  DEFINE g_chr LIKE type_file.chr1              #No.FUN-680122 VARCHAR(1)
#  LET g_chr = 'y'
#  LET x.yy = YEAR(TODAY)
#  LET x.mm = MONTH(TODAY)
#  SELECT ccz01,ccz02 INTO x.yy,x.mm FROM ccz_file
#
#  OPEN WINDOW t202_gw AT 06,11 WITH FORM "axc/42f/axct202_g"
#    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#
#  CALL cl_ui_locale("axct202_g")
#
#
#  CONSTRUCT BY NAME l_tm.wc ON sfb01,sfb05,sfb81
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#  END CONSTRUCT
#
#  INPUT BY NAME x.yy,x.mm WITHOUT DEFAULTS
#     AFTER FIELD yy
#        IF cl_null(x.yy) THEN NEXT FIELD yy END IF
#     AFTER FIELD mm
#        IF cl_null(x.mm) THEN NEXT FIELD mm END IF
#        IF x.mm>12 OR x.mm<1 THEN NEXT FIELD mm END IF
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#     #MOD-490324
#     AFTER INPUT
#        IF INT_FLAG THEN EXIT INPUT END IF    #MOD-4A0228 modify
#
#        IF x.yy*12+x.mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
#           CALL cl_err('','axc-095',1)
#           NEXT FIELD yy
#        END IF
#     #--
#  END INPUT
#  IF INT_FLAG THEN
#     LET INT_FLAG=0
#     CLOSE WINDOW t202_gw
#     RETURN
#  END IF
#
#  CALL s_azm(x.yy,x.mm) RETURNING l_flag,g_bdate, g_edate
#
#  DELETE FROM srk_file WHERE srk01 BETWEEN g_bdate AND g_edate
#  DELETE FROM srl_file WHERE srl01 BETWEEN g_bdate AND g_edate
#  MESSAGE " Working ...."
# #LET l_sql_g = "SELECT tlf01,ima58,' ',tlf62,SUM(tlf10),tlf06",     #FUN-5B0077 mark
#  LET l_sql_g = "SELECT tlf01,ima58,tlf19,tlf62,SUM(tlf10),tlf06",   #FUN-5B0077
#                "  FROM tlf_file,ima_file,sfb_file",
#                "  WHERE (tlf06 BETWEEN '",g_bdate,"' AND '", g_edate, "')",
#                "   AND (tlf13='asft6101' OR tlf13='asft6201')",
#                "   AND tlf907<>0 ",
#                "   AND ima01 = tlf01 ",
#                "   AND tlf62 = sfb01 ",
#                "   AND sfb99='N'",
#                "   AND sfb02 != '7' AND sfb02 != '8'",   #FUN-5B0091
#                "   AND ",l_tm.wc CLIPPED,
# #              " GROUP BY tlf01,ima58,' ',tlf62,tlf06 ",             #FUN-5B0077 mark
#                " GROUP BY tlf01,ima58,tlf19,tlf62,tlf06 ",           #FUN-5B0077
#                " ORDER BY tlf06"
#  LET n = 0
#  INITIALIZE l_srl_t.* TO NULL
#  PREPARE t202_g_prepare1 FROM l_sql_g
#  DECLARE tlf_curs CURSOR FOR t202_g_prepare1
#  FOREACH tlf_curs INTO l_ima01,l_ima58,l_tlf19,l_tlf026,l_qty1,l_tlf06
#     #start FUN-5B0077
#      SELECT ccz06 INTO g_ccz.ccz06 FROM ccz_file
#      IF g_ccz.ccz06 != '2' THEN LET l_tlf19 = '' END IF
#     #end FUN-5B0077
#      IF l_tlf19 IS NULL THEN LET l_tlf19=' ' END IF
#      LET l_srl.srl01=l_tlf06
#      LET l_srl.srl02=l_tlf19
#      IF l_srl_t.srl01 IS NULL OR
#         l_srl.srl01!=l_srl_t.srl01 OR l_srl.srl02!=l_srl_t.srl02 THEN
#         IF l_srl_t.srl01 IS NOT NULL THEN
#            INSERT INTO srk_file(srk01,srk02,srk05,srkinpd,srkfirm,
#                               srkacti,srkuser,srkgrup)
#                VALUES(l_srl_t.srl01,l_srl_t.srl02,l_tqty,g_today,'Y','Y',
#                       g_user,g_grup)
#         END IF
#         LET n = 0
#         LET l_tqty = 0
#         LET l_srl_t.srl01=l_srl.srl01
#         LET l_srl_t.srl02=l_srl.srl02
#      END IF
#      LET n = n+1
#      IF l_ima58 IS NULL THEN LET l_ima58=0 END IF
#      LET l_qty  = l_qty1
#      LET l_qty1 = l_qty * l_ima58
#      LET l_tqty = l_tqty+l_qty1
#      LET l_srl.srl03=n
#      LET l_srl.srl04=l_tlf026
#      LET l_srl.srl05=l_qty1
#      LET l_srl.srl06=l_qty
#      INSERT INTO srl_file VALUES(l_srl.*)
#      IF STATUS THEN
#         UPDATE srl_file SET srl05 = srl05+l_srl.srl05
#            WHERE srl01 = l_srl.srl01
#              AND srl02 = l_srl.srl02
#              AND srl04 = l_srl.srl04
#      END IF
#  END FOREACH
#  INSERT INTO srk_file(srk01,srk02,srk05,srkinpd,srkfirm,
#                       srkacti,srkuser,srkgrup)
#                VALUES(l_srl_t.srl01,l_srl_t.srl02,l_tqty,g_today,'Y','Y',
#                       g_user,g_grup)
#  CLOSE WINDOW t202_gw
#END FUNCTION

#CHI-C80041---begin
#FUNCTION t202_v()                #CHI-D20010
FUNCTION t202_v(p_type)                #CHI-D20010
   DEFINE l_chr LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_srk.srk01) OR cl_null(g_srk.srk02) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_srk.srkfirm='X' THEN RETURN END IF
   ELSE
      IF g_srk.srkfirm<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
  
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t202_cl USING g_srk.srk01,g_srk.srk02
   IF STATUS THEN
      CALL cl_err("OPEN t202_cl:", STATUS, 1)
      CLOSE t202_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t202_cl INTO g_srk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_srk.srk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t202_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_srk.srkfirm = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
  #IF cl_void(0,0,g_srk.srkfirm)   THEN                                #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
        LET l_chr=g_srk.srkfirm                                               
        #IF g_srk.srkfirm='N' THEN                                     #CHI-D20010
        IF p_type = 1 THEN                                             #CHI-D20010   
            LET g_srk.srkfirm='X' 
        ELSE
            LET g_srk.srkfirm='N'
        END IF
        UPDATE srk_file
            SET srkfirm=g_srk.srkfirm,  
                srkmodu=g_user,
                srkdate=g_today
            WHERE srk01=g_srk.srk01
              AND srk02=g_srk.srk02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","srk_file",g_srk.srk01,"",SQLCA.sqlcode,"","",1)  
            LET g_srk.srkfirm=l_chr 
        END IF
        DISPLAY BY NAME g_srk.srkfirm
   END IF
 
   CLOSE t202_cl
   COMMIT WORK
   CALL cl_flow_notify(g_srk.srk01,'V')
 
END FUNCTION
#CHI-C80041---end
