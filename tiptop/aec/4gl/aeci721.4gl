# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci721.4gl
# Descriptions...: 工單工藝單元明細變更維護作業
# Date & Author..: #No.FUN-810016 07/10/24 By hongmei
# Modify.........: No.FUN-810014 08/02/01 By arman 行業別的修改  
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830121 FUN-840001 08/03/31 By hongmei sgyislk02-->sgy20,sgyislk07-->sgy21 將報工否修改為一般行業
# Modify.........: No.FUN-870124 08/07/28 By jan 服飾作業BUG修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.FUN-920186 09/03/17 By lala  理由碼sgx04必須為工藝原因
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowi定義規範化
# Modify.........: No.FUN-980002 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0123 09/10/23 By lilingyu r.c2 fail,modify rowi
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60092 10/06/30 By lilingyu 平行工藝
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No.TQC-AC0374 10/12/30 By jan 從抓製程料號
# Modify.........: No.FUN-B10056 11/02/11 By vealxu 修改制程段號的管控 
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C80041 12/12/28 By bart 排除作廢
# Modify.........: No:FUN-D40030 13/04/08 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_sgx          RECORD LIKE sgx_file.*,
    g_sgx_t        RECORD LIKE sgx_file.*,
    g_sgx_o        RECORD LIKE sgx_file.*,
    g_sgx01_t      LIKE sgx_file.sgx01,
    g_sgx02_t      LIKE sgx_file.sgx02,
    g_sgx03_t      LIKE sgx_file.sgx03,
    g_sgx012_t     LIKE sgx_file.sgx012,        #FUN-A60092 
    g_sgy           DYNAMIC ARRAY OF RECORD
        sgy05       LIKE sgy_file.sgy05,        #單元編號        
        sgy04       LIKE sgy_file.sgy04,        #原變更方式
        sgyislk01   LIKE sgyi_file.sgyislk01,   #原單元順序
        sgy06       LIKE sgy_file.sgy06,        #原零件數
        sgy07       LIKE sgy_file.sgy07,        #原單位工時
        sgy08       LIKE sgy_file.sgy08,        #原單元工時
        sgy09       LIKE sgy_file.sgy09,        #原單位人力
        sgy10       LIKE sgy_file.sgy10,        #原單位機時
        sgy11       LIKE sgy_file.sgy11,        #原單元機時
        sgy12       LIKE sgy_file.sgy12,        #原可委外
        sgy20       LIKE sgy_file.sgy20,        #原報工  #No.FUN-830121
        sgyislk03   LIKE sgyi_file.sgyislk03,   #原現實工時
        sgyislk04   LIKE sgyi_file.sgyislk04,   #原標准工價
        sgyislk05   LIKE sgyi_file.sgyislk05,   #原現實工價
        sgyislk06   LIKE sgyi_file.sgyislk06,   #新單元順序
        sgy13       LIKE sgy_file.sgy13,        #新零件數
        sgy14       LIKE sgy_file.sgy14,        #新單位工時
        sgy15       LIKE sgy_file.sgy15,        #新單元工時
        sgy16       LIKE sgy_file.sgy16,        #新單位人力
        sgy17       LIKE sgy_file.sgy17,        #新單位機時
        sgy18       LIKE sgy_file.sgy18,        #新單元機時
        sgy19       LIKE sgy_file.sgy19,        #新可委外
        sgy21       LIKE sgy_file.sgy21,        #新報工
        sgyislk08   LIKE sgyi_file.sgyislk08,   #新現實工時
        sgyislk09   LIKE sgyi_file.sgyislk09,   #新標准工價
        sgyislk10   LIKE sgyi_file.sgyislk10    #新現實工價
                    END RECORD,
    g_sgy_t         RECORD
        sgy05       LIKE sgy_file.sgy05,        #單元編號        
        sgy04       LIKE sgy_file.sgy04,        #原變更方式
        sgyislk01   LIKE sgyi_file.sgyislk01,   #原單元順序
        sgy06       LIKE sgy_file.sgy06,        #原零件數
        sgy07       LIKE sgy_file.sgy07,        #原單位工時
        sgy08       LIKE sgy_file.sgy08,        #原單元工時
        sgy09       LIKE sgy_file.sgy09,        #原單位人力
        sgy10       LIKE sgy_file.sgy10,        #原單位機時
        sgy11       LIKE sgy_file.sgy11,        #原單元機時
        sgy12       LIKE sgy_file.sgy12,        #原可委外
        sgy20       LIKE sgy_file.sgy20,        #原報工
        sgyislk03   LIKE sgyi_file.sgyislk03,   #原現實工時
        sgyislk04   LIKE sgyi_file.sgyislk04,   #原標准工價
        sgyislk05   LIKE sgyi_file.sgyislk05,   #原現實工價
        sgyislk06   LIKE sgyi_file.sgyislk06,   #新單元順序
        sgy13       LIKE sgy_file.sgy13,        #新零件數
        sgy14       LIKE sgy_file.sgy14,        #新單位工時
        sgy15       LIKE sgy_file.sgy15,        #新單元工時
        sgy16       LIKE sgy_file.sgy16,        #新單位人力
        sgy17       LIKE sgy_file.sgy17,        #新單位機時
        sgy18       LIKE sgy_file.sgy18,        #新單元機時
        sgy19       LIKE sgy_file.sgy19,        #新可委外
        sgy21       LIKE sgy_file.sgy21,        #新報工
        sgyislk08   LIKE sgyi_file.sgyislk08,   #新現實工時
        sgyislk09   LIKE sgyi_file.sgyislk09,   #新標准工價
        sgyislk10   LIKE sgyi_file.sgyislk10    #新現實工價
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,    
    g_rec_b         LIKE type_file.num5,      #單身筆數        
    g_j             LIKE type_file.num5,      
    l_cmd           LIKE type_file.chr1000, 
#    l_wc            LIKE type_file.chr1000, 
    l_wc            STRING,            #NO.FUN-910082 
    l_ac            LIKE type_file.num5,      #目前處理的ARRAY CNT
    g_before_input_done LIKE type_file.num5,  
    g_forupd_sql    STRING       
#主程式開始
DEFINE   g_cnt          LIKE type_file.num10      
DEFINE   g_msg          LIKE type_file.chr1000  
 
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   mi_no_ask      LIKE type_file.num5
DEFINE   b_sgyi         RECORD LIKE sgyi_file.* 
DEFINE   g_sql_tmp      STRING
 
MAIN
DEFINE p_row,p_col    LIKE type_file.num5
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
#   LET g_forupd_sql = " SELECT * FROM sgx_file WHERE ROWI = ? FOR UPDATE"    #TQC-9A0123
   LET g_forupd_sql = " SELECT * FROM sgx_file WHERE sgx01 = ? AND sgx02 = ? AND sgx03 = ? AND sgx012 = ? FOR UPDATE"    #TQC-9A0123
                                                #FUN-A60092 add sgx012
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i721_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 18
   OPEN WINDOW i721_w AT p_row,p_col WITH FORM "aec/42f/aeci721"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
        
   CALL cl_ui_init()     
        
       CALL cl_set_comp_visible("dummy02,dummy21,dummy22,dummy23,                                 sgyislk01,sgyislk03,sgyislk04,                                 sgyislk05,sgyislk06,sgyislk08,                                 sgyislk09,sgyislk10",FALSE) 

#FUN-A60092 --begin--
   IF g_sma.sma541 = 'Y' THEN 
     CALL cl_set_comp_visible("sgx012",TRUE) 
   ELSE
  	  CALL cl_set_comp_visible("sgx012",FALSE)
   END IF 
#FUN-A60092 --end-- 
 
   CALL i721_menu()
   CLOSE WINDOW i721_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i721_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
    CLEAR FORM       #清除畫面
    CALL g_sgy.clear()
    CALL cl_set_head_visible("","YES")    
 
#-->螢幕上取單頭條件
   INITIALIZE g_sgx.* TO NULL    
    CONSTRUCT BY NAME g_wc ON sgx01,sgx06,sgx04,    #sgx05,    #FUN-A60092 mark
                              sgx07,sgx05,sgx03,sgx012,sgx02,sgx08,sgx09,  #FUN-A60092 add sgx012,sgx05
                              sgxuser,sgxgrup,
                              sgxoriu,sgxorig,   #FUN-A60092 add                              
                              sgxmodu,sgxdate,sgxacti
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sgx01) # 產品料號
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_ecm8"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgx01
                NEXT FIELD sgx01
#FUN-A60092 --begin--
             WHEN INFIELD(sgx012) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_sgx012"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgx012
                NEXT FIELD sgx012            
#FUN-A60092 --end--                
             WHEN INFIELD(sgx04) # 變更原因
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                #LET g_qryparam.form ="q_azf4"      #FUN-920186
                LET g_qryparam.form ="q_azf01a"     #FUN-920186
                LET g_qryparam.arg1  = 'A'          #FUN-920186 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgx04
                NEXT FIELD sgx04  
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about 
          CALL cl_about()
  
       ON ACTION HELP
          CALL cl_show_help()
  
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION qbe_select
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
#-->資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                 #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND sgxuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                 #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sgxgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #群組權限
    #        LET g_wc = g_wc clipped," AND sgxgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sgxuser', 'sgxgrup')
    #End:FUN-980030
 
    CONSTRUCT g_wc2 ON sgy05,sgy04,
                       sgy06,sgy07,sgy08,sgy09,sgy10,sgy11,
                       sgy12,sgy20,
                       sgy13,sgy14,sgy15,sgy16,sgy17,sgy18,sgy19,sgy21
         FROM   s_sgy[1].sgy05,s_sgy[1].sgy04,
                s_sgy[1].sgy06,
                s_sgy[1].sgy07,s_sgy[1].sgy08,s_sgy[1].sgy09,s_sgy[1].sgy10,
                s_sgy[1].sgy11,s_sgy[1].sgy12,s_sgy[1].sgy20,
                s_sgy[1].sgy13,s_sgy[1].sgy14,
                s_sgy[1].sgy15,s_sgy[1].sgy16,s_sgy[1].sgy17,s_sgy[1].sgy18,
                s_sgy[1].sgy19,s_sgy[1].sgy21
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sgy05)   #變更原因說明
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_sga"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_sgy[1].sgy05
                NEXT FIELD sgy05
             OTHERWISE EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about
          CALL cl_about()
  
       ON ACTION HELP
          CALL cl_show_help() 
  
       ON ACTION controlg 
          CALL cl_cmdask()
 
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
#       LET g_sql = "SELECT ROWI, sgx01,sgx02,sgx03 FROM sgx_file ",  #TQC-9A0123
       LET g_sql = "SELECT sgx01,sgx02,sgx03,sgx012 FROM sgx_file ",   #TQC-9A0123  #FUN-A60092 add sgx012
                   " WHERE ", g_wc CLIPPED,
           #        " ORDER BY 2"  #TQC-9A0123
                   " ORDER BY sgx01"   #TQC-9A0123
    ELSE					# 若單身有輸入條件
#       LET g_sql = "SELECT UNIQUE sgx_file.ROWI, sgx01,sgx02,sgx03 ",  #TQC-9A0123
       LET g_sql = "SELECT sgx01,sgx02,sgx03,sgx012 ",   #TQC-9A0123   #FUN-A60092 add sgx012
                   "  FROM sgx_file, sgy_file ",
                   " WHERE sgx01 = sgy01 AND sgx02 = sgy02",
                   "   AND sgx03=sgy03 ",
                   "   AND sgx012=sgy012 ",   #FUN-A60092 add
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  # " ORDER BY 2"  #TQC-9A0123
                   " ORDER BY sgx01"  #TQC-9A0123
    END IF
 
    PREPARE i721_prepare FROM g_sql
    DECLARE i721_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i721_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql_tmp="SELECT UNIQUE sgx01,sgx02,sgx03,sgx012 FROM sgx_file WHERE ",g_wc CLIPPED,
                                                    #FUN-A60092 add sgx012
                      " INTO TEMP x"
    ELSE
         LET g_sql_tmp="SELECT UNIQUE sgx01,sgx02,sgx03,sgx012 FROM sgx_file,sgy_file ",  #FUN-A60092 add sgx012                            
                       " WHERE sgy01=sgx01 AND sgy02=sgx02",
                       "   AND sgy012=sgx012 ",  #FUN-A60092   add
                       "   AND sgy03=sgx03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                       " INTO TEMP x"
    END IF
    DROP TABLE x
    PREPARE i721_precount_x FROM g_sql_tmp
    EXECUTE i721_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i721_precount FROM g_sql
    DECLARE i721_count CURSOR FOR i721_precount
END FUNCTION
 
FUNCTION i721_menu()
 
   WHILE TRUE
      CALL i721_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i721_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i721_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i721_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i721_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i721_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"     #審核
            IF cl_chk_act_auth() THEN
               CALL i721_y()
            END IF
         WHEN "undo_confirm" #取消審核
            IF cl_chk_act_auth() THEN
               CALL i721_z()
            END IF
         WHEN "release"      #發放 
            IF cl_chk_act_auth() THEN
               CALL i721_g()
            END IF      
         WHEN "related_document" #相關文件
            IF cl_chk_act_auth() THEN
               IF g_sgx.sgx01 IS NOT NULL THEN
                  LET g_doc.column1 = "sgx01"
                  LET g_doc.value1 = g_sgx.sgx01
                  LET g_doc.column3 = "sgx02"
                  LET g_doc.value3 = g_sgx.sgx02
                  LET g_doc.column4 = "sgx03"
                  LET g_doc.value4 = g_sgx.sgx03
                  LET g_doc.column5 = "sgx012"     #FUN-A60092 add
                  LET g_doc.value5 = g_sgx.sgx012  #FUN-A60092 add                 
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i721_a()
    IF s_aglshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_sgy.clear()
    INITIALIZE g_sgx.* LIKE sgx_file.*             #DEFAULT 設定
    LET g_sgx01_t = NULL
    LET g_sgx012_t= NULL   #FUN-A60092 add
    
    #預設值及將數值類變數清成零
    LET g_sgx_t.* = g_sgx.*
    LET g_sgx_o.* = g_sgx.*
    LET g_sgx.sgx06 = g_today
    LET g_sgx.sgx08='N'
    LET g_sgx.sgx09='N'
    LET g_sgx.sgxuser=g_user
    LET g_sgx.sgxoriu = g_user #FUN-980030
    LET g_sgx.sgxorig = g_grup #FUN-980030
    LET g_data_plant = g_plant #FUN-980030
    LET g_sgx.sgxdate=g_today
    LET g_sgx.sgxgrup=g_grup
    LET g_sgx.sgxacti = 'Y'   #FUN-A60092 
    CALL cl_opmsg('a')
    BEGIN WORK
    WHILE TRUE
        CALL i721_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_sgx.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        IF cl_null(g_sgx.sgx01) OR cl_null(g_sgx.sgx02) # KEY 不可空白
            OR cl_null(g_sgx.sgx03) 
        THEN CONTINUE WHILE
        END IF
        LET g_sgx.sgxplant = g_plant #FUN-980002
        LET g_sgx.sgxlegal = g_legal #FUN-980002
#FUN-A60092 --begin--        
        IF cl_null(g_sgx.sgx012) THEN 
           LET g_sgx.sgx012 = ' '
        END IF 
#FUN-A60092 --end--     
        #No.FUN-A70131--begin
        IF cl_null(g_sgx.sgx02) THEN 
           LET g_sgx.sgx02=0
        END IF 
        #No.FUN-A70131--end           
        INSERT INTO sgx_file VALUES (g_sgx.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","sgx_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        COMMIT WORK
 
#TQC-9A0123 
#        SELECT ROWI INTO g_sgx_rowi FROM sgx_file
#         WHERE sgx01=g_sgx.sgx01 
#           AND sgx02=g_sgx.sgx02
#           AND sgx03=g_sgx.sgx03
#TQC-9A0123
        LET g_sgx01_t = g_sgx.sgx01        #保留舊值
        LET g_sgx02_t = g_sgx.sgx02        #保留舊值
        LET g_sgx03_t = g_sgx.sgx03        #保留舊值
        LET g_sgx012_t= g_sgx.sgx012       #FUN-A60092 
        LET g_sgx_t.* = g_sgx.*
        CALL g_sgy.clear()
        LET g_rec_b = 0
        CALL i721_b()                      #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i721_u()
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_sgx.sgx01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sgx.* FROM sgx_file
     WHERE sgx01 = g_sgx.sgx01 
       AND sgx02 = g_sgx.sgx02 AND sgx03 = g_sgx.sgx03
       AND sgx012= g_sgx.sgx012   #FUN-A60092 
    IF g_sgx.sgx08='Y'   THEN CALL cl_err('','aec-996',0) RETURN END IF
    IF g_sgx.sgx09='Y'   THEN CALL cl_err('','aec-003',0) RETURN END IF
    IF g_sgx.sgxacti='N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sgx01_t = g_sgx.sgx01
    LET g_sgx02_t = g_sgx.sgx02
    LET g_sgx03_t = g_sgx.sgx03
    LET g_sgx012_t= g_sgx.sgx012    #FUN-A60092 add
    LET g_sgx_o.* = g_sgx.*
    BEGIN WORK
   # OPEN i721_cl USING g_sgx_rowi  #TQC-9A0123
    OPEN i721_cl USING g_sgx01_t,g_sgx02_t,g_sgx03_t,g_sgx012_t  #TQC-9A0123   #FUN-A60092 add sgx012
    FETCH i721_cl INTO g_sgx.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgx.sgx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i721_cl ROLLBACK WORK RETURN
    END IF
    LET g_sgx.sgxmodu = g_user
    LET g_sgx.sgxdate = g_today
    CALL i721_show()
    WHILE TRUE
        LET g_sgx01_t = g_sgx.sgx01
        LET g_sgx02_t = g_sgx.sgx02
        LET g_sgx03_t = g_sgx.sgx03
        LET g_sgx012_t= g_sgx.sgx012   #FUN-A60092 
        CALL i721_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sgx.*=g_sgx_t.*
            CALL i721_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_sgx.sgx01 != g_sgx01_t OR g_sgx.sgx02 != g_sgx02_t 
         OR g_sgx.sgx012 != g_sgx012_t    #FUN-A60092 add
         OR g_sgx.sgx03 != g_sgx03_t THEN
           UPDATE sgy_file SET sgy01=g_sgx.sgx01,
                               sgy02=g_sgx.sgx02,
                               sgy03=g_sgx.sgx03
                              ,sgy012=g_sgx.sgx012   #FUN-A60092 
            WHERE sgy01=g_sgx01_t 
              AND sgy02=g_sgx02_t AND sgy03=g_sgx03_t
              AND sgy012=g_sgx012_t   #FUN-A60092 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","sgy_file",g_sgx01_t,g_sgx02_t,SQLCA.sqlcode,"","",1)
                CONTINUE WHILE
            END IF
        END IF
        UPDATE sgx_file SET sgx_file.* = g_sgx.*
#            WHERE ROWI = g_sgx_rowi  #TQC-9A0123
             WHERE sgx01 = g_sgx01_t  #TQC-9A0123
               AND sgx02 = g_sgx02_t  #TQC-9A0123
               AND sgx03 = g_sgx03_t  #TQC-9A0123
               AND sgx012= g_sgx012_t   #FUN-A60092 
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","sgx_file",g_sgx01_t,g_sgx02_t,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i721_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i721_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,       #判斷必要欄位是否有輸入
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
    l_n,l_cnt       LIKE type_file.num5, 
    l_n1,l_cnt1     LIKE type_file.num5,
    l_ecm60         LIKE ecm_file.ecm60,
    l_azf09         LIKE azf_file.azf09,       #FUN-920186    
    l_cnt2,l_cnt3,l_cnt4  LIKE type_file.num5 
DEFINE l_sfb05      LIKE sfb_file.sfb05   #FUN-A60092
DEFINE l_sfb06      LIKE sfb_file.sfb06   #FUN-A60092    
    
    DISPLAY BY NAME
        g_sgx.sgx07,g_sgx.sgx03,g_sgx.sgx08,g_sgx.sgx09,g_sgx.sgxuser,
        g_sgx.sgxmodu,g_sgx.sgxgrup,g_sgx.sgxdate,g_sgx.sgxacti
 
    CALL cl_set_head_visible("","YES")
 
    INPUT BY NAME g_sgx.sgxoriu,g_sgx.sgxorig,
        g_sgx.sgx01,g_sgx.sgx06,g_sgx.sgx04,
        g_sgx.sgx05,g_sgx.sgx012,g_sgx.sgx02    #FUN-A60092 add sgx012
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i721_set_entry(p_cmd)
          CALL i721_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
 
        AFTER FIELD sgx01 #產品料號
            IF NOT cl_null(g_sgx.sgx01) THEN
               IF g_sgx_t.sgx01 IS NULL OR
                 (g_sgx.sgx01 != g_sgx_t.sgx01) THEN
#FUN-A60092 --begin--                 
#                  CALL i721_sgx01('a')
#                  IF NOT cl_null(g_errno) THEN
#                     CALL cl_err(g_sgx.sgx01,g_errno,0)
#                     LET g_sgx.sgx01 = g_sgx_t.sgx01
#                     DISPLAY BY NAME g_sgx.sgx01
#                     NEXT FIELD sgx01
#                  END IF
#FUN-A60092 --end--
               SELECT count(*) INTO l_n
                 FROM ecm_file,sfb_file
                WHERE sfb01 = ecm01
                  AND sfb87 = 'Y'
                  AND sfb04 != '8'
                  AND sfb01 = g_sgx.sgx01
                IF l_n = 0 THEN
                   CALL cl_err('','asfi115',0)
                   NEXT FIELD sgx01
                END IF
               END IF 
            ELSE                     #FUN-A60092 
            	  NEXT FIELD CURRENT   #FUN-A60092    
            END IF     
                     
        AFTER FIELD sgx04  #變更原因
           IF NOT cl_null(g_sgx.sgx04) THEN
              SELECT count(*) INTO l_n1                                         
               FROM azf_file                                                    
              WHERE azf01 = g_sgx.sgx04                                         
                AND azfacti = 'Y'                                               
                AND azf02 = '2'                                                 
             IF l_n1 = 0 THEN                                                   
                CALL cl_err('','asfi115',0)                                     
                NEXT FIELD sgx04                                                
             END IF
             #No.FUN-920186---begin
             SELECT azf09 INTO l_azf09                                         
               FROM azf_file                                                    
              WHERE azf01 = g_sgx.sgx04                                         
                AND azfacti = 'Y'                                               
                AND azf02 = '2'                                                 
             IF l_azf09 != 'A' THEN                                                   
                CALL cl_err('','aoo-409',0)                                     
                NEXT FIELD sgx04                                                
             END IF
             #No.FUN-920186---end
              CALL i721_sgx04(p_cmd)
           END IF
 
#FUN-A60092 --begin--
        BEFORE FIELD sgx012 
          IF cl_null(g_sgx.sgx01) THEN 
             NEXT FIELD sgx01
          END IF 
          
        AFTER FIELD sgx012 
          IF NOT cl_null(g_sgx.sgx012) THEN 
            IF (g_sgx.sgx012 != g_sgx012_t OR g_sgx012_t IS NULL) OR
              (g_sgx.sgx01 != g_sgx01_t OR g_sgx01_t IS NULL)
             THEN             
              #FUN-B10056 -------mark start----------
              #CALL i721_sgx012()
              #IF NOT cl_null(g_errno) THEN 
              #   CALL cl_err('',g_errno,0)
              #   NEXT FIELD CURRENT 
              #ELSE
              #FUN-B10056 -------mark end----------- 
             	    LET l_cnt = 0
             	    SELECT COUNT(*) INTO l_cnt FROM ecm_file
             	     WHERE ecm01 = g_sgx.sgx01
               	     AND ecm012= g_sgx.sgx012
              	  IF l_cnt = 0 THEN 
              	     CALL cl_err('','aec-097',0)
              	     NEXT FIELD CURRENT 
              	  ELSE
                     CALL i721_sgx01('a')   
                     IF NOT cl_null(g_errno) THEN 
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD CURRENT 
                     END IF            	  	    
              	  END IF      
              #END IF           #FUN-B10056 	mark 
             END IF   
          END IF 
          
        BEFORE FIELD sgx02
          IF cl_null(g_sgx.sgx012) THEN 
             LET g_sgx.sgx012 = ' ' 
          END IF   
#FUN-A60092 --end--
 
        AFTER FIELD sgx02  #工藝序號
            IF NOT cl_null(g_sgx.sgx02) THEN
               IF (g_sgx.sgx01 != g_sgx01_t OR g_sgx01_t IS NULL)
                OR (g_sgx.sgx012 != g_sgx012_t OR g_sgx012_t IS NULL) #FUN-A60092  add
                THEN 
                SELECT COUNT(*) INTO l_cnt2 FROM ecm_file 
                 WHERE ecm01=g_sgx.sgx01
                 # AND ecm02=g_sgx.sgx02       #No.FUN-870124
                   AND ecm03=g_sgx.sgx02       #No.FUN-870124
                   AND ecm012= g_sgx.sgx012    #FUN-A60092 add
                 IF l_cnt2 = 0  THEN
                    CALL cl_err(g_sgx.sgx02,'aec-006',0)
                    LET g_sgx.sgx02 = g_sgx_t.sgx02
                    NEXT FIELD sgx02
                 END IF
               END IF
            LET l_cnt = 0 
              SELECT COUNT(*) INTO l_cnt3 FROM sgt_file,sgu_file
               WHERE sgt01=g_sgx.sgx01
                 AND sgu04=g_sgx.sgx02
                 AND sgt01=sgu_file.sgu01
                 AND sgt08='N'
                 AND sgt012= g_sgx.sgx012   #FUN-A60092 add
                 IF l_cnt3 > 0 THEN
                    CALL cl_err(g_sgx.sgx02,'aec-106',0)
                    NEXT FIELD sgx02
                 END IF
              SELECT COUNT(*) INTO l_cnt4 FROM sgx_file
               WHERE sgx01=g_sgx.sgx01 
                 AND sgx02=g_sgx.sgx02 
                 AND sgx09='N'      
                 AND sgx012 =g_sgx.sgx012   #FUN-A60092 add
                 IF l_cnt4 > 0 THEN
                    CALL cl_err(g_sgx.sgx02,'aec-017',0)
                    NEXT FIELD sgx02
                 END IF
              IF g_sma.sma124!='02' THEN 
              SELECT COUNT(*) INTO l_cnt4 FROM sgl_file,sgk_file
               WHERE sgl04=g_sgx.sgx01
                 AND sgl06=g_sgx.sgx02
                 AND sgl01=sgk_file.sgk01
                 AND sgkacti='Y' 
                 AND (sgl_file.sgl08>0 OR sgl_file.sgl09>0) 
                 AND sgk07 <> 'X'  #CHI-C80041
                 IF l_cnt4 > 0 THEN 
                    CALL cl_err(g_sgx.sgx02,'',0)
                 END IF
              END IF       
            END IF
            
            SELECT ecm60 INTO l_ecm60 FROM ecm_file
             WHERE ecm01=g_sgx.sgx01
               AND ecm03=g_sgx.sgx02  
               AND ecm012 = g_sgx.sgx012   #FUN-A60092 
             IF l_ecm60 IS NULL THEN 
                LET l_ecm60 = 0
             END IF 
             LET g_sgx.sgx03 = l_ecm60 + 1       
            DISPLAY BY NAME g_sgx.sgx03
                  
        AFTER INPUT
           LET g_sgx.sgxuser = s_get_data_owner("sgx_file") #FUN-C10039
           LET g_sgx.sgxgrup = s_get_data_group("sgx_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            LET l_flag='N'
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgx01)  #產品料號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecm8"
                 LET g_qryparam.default1 = g_sgx.sgx01
                 CALL cl_create_qry() RETURNING g_sgx.sgx01
                 DISPLAY BY NAME g_sgx.sgx01
                 NEXT FIELD sgx01
#FUN-A60092 --begin--
              WHEN INFIELD(sgx012) 
                 SELECT sfb05,sfb06 INTO l_sfb05,l_sfb06 FROM sfb_file
                  WHERE sfb01 = g_sgx.sgx01
                 CALL cl_init_qry_var()
              #  LET g_qryparam.form ="q_sgx012_1"        #FUN-B10056 mark
                 LET g_qryparam.form ="q_sgx012_2"        #FUN-B10056 
                 LET g_qryparam.default1 = g_sgx.sgx012
              #  LET g_qryparam.arg1     = l_sfb05        #FUN-B10056 mark
              #  LET g_qryparam.arg2     = l_sfb06        #FUN-B10056 mark
                 LET g_qryparam.arg1     = g_sgx.sgx01    #FUN-B10056
                 LET g_qryparam.arg2     = l_sfb05        #FUN-B10056  
                 CALL cl_create_qry() RETURNING g_sgx.sgx012
                 DISPLAY BY NAME g_sgx.sgx012
                 NEXT FIELD sgx012       
#FUN-A60092 --end--                 
              WHEN INFIELD(sgx04)  #變更原因
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_azf4"      #FUN-920186
                 LET g_qryparam.form ="q_azf01a"     #FUN-920186
                 LET g_qryparam.arg1  = 'A'          #FUN-920186
                 LET g_qryparam.default1 = g_sgx.sgx04
                 CALL cl_create_qry() RETURNING g_sgx.sgx04
                 DISPLAY BY NAME g_sgx.sgx04
                 CALL i721_sgx04('d')
                 NEXT FIELD sgx04  
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION HELP
           CALL cl_show_help()
                                         
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")
 
    END INPUT
END FUNCTION

#FUN-B10056 ---------mark start-----------
##FUN-A60092 --begin--
#FUNCTION i721_sgx012()
#DEFINE l_sfb05   LIKE sfb_file.sfb05
#DEFINE l_sfb06   LIKE sfb_file.sfb06
#DEFINE l_ecu10   LIKE ecu_file.ecu10
#DEFINE l_ecuacti LIKE ecu_file.ecuacti
#DEFINE l_flag    LIKE type_file.num5   #TQC-AC0374
#
#LET g_errno = NULL
#LET l_sfb05 = NULL
#LET l_sfb06 = NULL
#
#SELECT sfb06 INTO l_sfb06 FROM sfb_file   #TQC-AC0374
# WHERE sfb01 = g_sgx.sgx01
#
#CALL s_schdat_sel_ima571(g_sgx.sgx01) RETURNING l_flag,l_sfb05  #TQC-AC0374
#SELECT ecu10,ecuacti INTO l_ecu10,l_ecuacti FROM ecu_file
# WHERE ecu01 = l_sfb05
#   AND ecu02 = l_sfb06
#   AND ecu012= g_sgx.sgx012
#CASE
#    WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-300'
#                              LET l_ecu10 = NULL
#                              LET l_ecuacti = NULL
#     WHEN l_ecu10   ='N'      LET g_errno = 'alm-750'                 
#                              LET l_ecu10 = NULL
#                              LET l_ecuacti = NULL 
#     WHEN l_ecuacti ='N'      LET g_errno = '9028'
#                              LET l_ecu10 = NULL
#                              LET l_ecuacti=NULL
#        OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
#   END CASE       
#END FUNCTION 
##FUN-A60092 --end--
#FUN-B10056 -----------mark end------------- 

FUNCTION  i721_sgx01(p_cmd)    #工單編號
DEFINE
    p_cmd              LIKE type_file.chr1,
    l_ecm03_par        LIKE ecm_file.ecm03_par,
    l_ecmacti          LIKE ecm_file.ecmacti,
    l_ima02            LIKE ima_file.ima02,
    l_imaacti          LIKE ima_file.imaacti
    
    LET g_errno = ' '
#   SELECT DISTINCT ecm03_par,ecmacti INTO l_ecm03_par,l_ecmacti FROM ecm_file  #No.FUN-870124
    SELECT DISTINCT ecm03_par INTO l_ecm03_par FROM ecm_file                    #No.FUN-870124
     WHERE ecm01 = g_sgx.sgx01
       AND ecm012= g_sgx.sgx012   #FUN-A60092  add
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-523'
                                   LET l_ecm03_par = NULL
#        WHEN l_ecmacti='N'        LET g_errno = '9028'                         #No.FUN-870124
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ecm03_par TO FORMONLY.sgx01_sfb05
    END IF
    SELECT ima02,imaacti INTO l_ima02,l_imaacti FROM ima_file
     WHERE ima01=l_ecm03_par
     IF SQLCA.sqlcode THEN 
      LET l_ima02 =''
     END IF
     DISPLAY l_ima02 TO FORMONLY.sgx01_sfb05_ima02
END FUNCTION
 
FUNCTION i721_sgx04(p_cmd)  #變更原因
   DEFINE l_azf03   LIKE azf_file.azf03,
          l_azfacti LIKE azf_file.azfacti,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   SELECT azf03,azfacti
     INTO l_azf03,l_azfacti 
     FROM azf_file WHERE azf01 = g_sgx.sgx04
                     AND azf02 = '2'
                     AND azfacti='Y' 
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_azf03 = NULL
        WHEN l_azfacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_sgx.sgx05 = l_azf03
   END IF
END FUNCTION
    
#Query 查詢
FUNCTION i721_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sgx.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_sgy.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i721_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i721_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sgx.* TO NULL
    ELSE
        OPEN i721_count
        FETCH i721_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i721_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i721_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式
    l_abso          LIKE type_file.num10     #絕對的筆數
 
    CASE p_flag
       # WHEN 'N' FETCH NEXT     i721_cs INTO g_sgx_rowi,g_sgx.sgx01,   #TQC-9A0123
        WHEN 'N' FETCH NEXT     i721_cs INTO g_sgx.sgx01,   #TQC-9A0123
                                             g_sgx.sgx02,g_sgx.sgx03
                                            ,g_sgx.sgx012   #FUN-A60092
#        WHEN 'P' FETCH PREVIOUS i721_cs INTO g_sgx_rowi,g_sgx.sgx01,  #TQC-9A0123
        WHEN 'P' FETCH PREVIOUS i721_cs INTO g_sgx.sgx01,  #TQC-9A0123
                                             g_sgx.sgx02,g_sgx.sgx03
                                            ,g_sgx.sgx012   #FUN-A60092                                             
       # WHEN 'F' FETCH FIRST    i721_cs INTO g_sgx_rowi,g_sgx.sgx01,  #TQC-9A0123
        WHEN 'F' FETCH FIRST    i721_cs INTO g_sgx.sgx01,  #TQC-9A0123
                                             g_sgx.sgx02,g_sgx.sgx03
                                            ,g_sgx.sgx012   #FUN-A60092                                             
       # WHEN 'L' FETCH LAST     i721_cs INTO g_sgx_rowi,g_sgx.sgx01,  #TQC-9A0123
        WHEN 'L' FETCH LAST     i721_cs INTO g_sgx.sgx01,  #TQC -9A0123
                                             g_sgx.sgx02,g_sgx.sgx03
                                            ,g_sgx.sgx012   #FUN-A60092                                             
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
          #  FETCH ABSOLUTE g_jump i721_cs INTO g_sgx_rowi,g_sgx.sgx01,  #TQC-9A0123
            FETCH ABSOLUTE g_jump i721_cs INTO g_sgx.sgx01,  #TQC-9A0123
                                               g_sgx.sgx02,g_sgx.sgx03
                                            ,g_sgx.sgx012   #FUN-A60092                                               
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgx.sgx01,SQLCA.sqlcode,0)
        INITIALIZE g_sgx.* TO NULL
#        LET g_sgx_rowi = NULL  #TQC-9A0123
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
    SELECT * INTO g_sgx.* FROM sgx_file 
    # WHERE ROWI = g_sgx_rowi  #TQC-9A0123
      WHERE sgx01 = g_sgx.sgx01  #TQC-9A0123
        AND sgx02 = g_sgx.sgx02  #TQC-9A0123
        AND sgx03 = g_sgx.sgx03  #TQC-9A0123
        AND sgx012= g_sgx.sgx012 #FUN-A60092 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sgx_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","",1)
       INITIALIZE g_sgx.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_sgx.sgxuser
       LET g_data_group = g_sgx.sgxgrup
       LET g_data_plant = g_sgx.sgxplant #FUN-980030
       CALL i721_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i721_show()
 
    LET g_sgx_t.* = g_sgx.*                #保存單頭舊值
    DISPLAY BY NAME g_sgx.sgxoriu,g_sgx.sgxorig,
        g_sgx.sgx01,g_sgx.sgx06,g_sgx.sgx04,g_sgx.sgx05,
        g_sgx.sgx07,g_sgx.sgx02,g_sgx.sgx03,
        g_sgx.sgx08,g_sgx.sgx09,g_sgx.sgxuser,g_sgx.sgxgrup,
        g_sgx.sgxmodu,g_sgx.sgxdate
       ,g_sgx.sgx012   #FUN-A60092        
    CALL i721_sgx01('d')    
    CALL i721_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont() 
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i721_r()
   DEFINE l_n    LIKE type_file.num5 
   DEFINE l_flag LIKE type_file.chr1
 
    IF s_aglshut(0) THEN 
       RETURN 
    END IF
    IF g_sgx.sgx01 IS NULL THEN 
       CALL cl_err("",-400,0) 
       RETURN 
    END IF
        
    IF g_sgx.sgx08='Y' THEN                                                     
       CALL cl_err('','aec-996',0)                                              
       RETURN                                                                   
    END IF
 
    IF g_sgx.sgx09='Y' THEN 
       CALL cl_err('','mfg1005',0) 
       RETURN 
    END IF
    
    BEGIN WORK
   # OPEN i721_cl USING g_sgx_rowi  #TQC-9A0123
    OPEN i721_cl USING g_sgx.sgx01,g_sgx.sgx02,g_sgx.sgx03  #TQC-9A0123
                                            ,g_sgx.sgx012   #FUN-A60092    
    FETCH i721_cl INTO g_sgx.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgx.sgx01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i721_cl ROLLBACK WORK RETURN
    END IF
    CALL i721_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sgx01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sgx.sgx01      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "sgx02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_sgx.sgx02      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "sgx03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_sgx.sgx03      #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "sgx012"        #FUN-A60092 
        LET g_doc.value5 = g_sgx.sgx012     #FUN-A60092        
        CALL cl_del_doc()                   #No.FUN-9B0098 10/02/24
       DELETE FROM sgx_file
        WHERE sgx01 = g_sgx.sgx01 
          AND sgx02 = g_sgx.sgx02 
          AND sgx03 = g_sgx.sgx03
          AND sgx012= g_sgx.sgx012   #FUN-A60092 add
       DELETE FROM sgy_file 
        WHERE sgy01 = g_sgx.sgx01 
          AND sgy02 = g_sgx.sgx02 
          AND sgy03 = g_sgx.sgx03
          AND sgy012= g_sgx.sgx012  #FUN-A60092 
       INITIALIZE g_sgx.* TO NULL
       CALL g_sgy.clear()
       CLEAR FORM
       OPEN i721_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i721_cs
          CLOSE i721_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i721_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i721_cs
          CLOSE i721_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i721_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i721_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i721_fetch('/')
       END IF
    END IF
    CLOSE i721_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i721_b()
DEFINE
       l_ac_t          LIKE type_file.num5,           #未取消的ARRAY CNT
       l_n,l_cnt,l_num,l_numcr,l_numma,l_nummi LIKE type_file.num5,     #檢查重複用
       l_lock_sw       LIKE type_file.chr1,           #單身鎖住否
       p_cmd           LIKE type_file.chr1,           #處理狀態
       #l_sql           LIKE type_file.chr1000,
       l_sql           STRING,      #NO.FUN-910082
       l_allow_insert  LIKE type_file.num5,           #可新增否
       l_allow_delete  LIKE type_file.num5,           #可刪除否
       l_cmd           LIKE type_file.chr1,
       l_n1            LIKE type_file.num5 
 
    LET g_action_choice = ""
 
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_sgx.sgx01)  THEN RETURN END IF
    IF cl_null(g_sgx.sgx02)  THEN RETURN END IF
    IF cl_null(g_sgx.sgx03)  THEN RETURN END IF
    IF g_sgx.sgx012 IS NULL THEN RETURN END IF   #FUN-A60092 
    
    IF g_sgx.sgx08='Y' THEN
       CALL cl_err("",'aec-996',0) RETURN 
    END IF
 
    CALL cl_opmsg('b')
#&ifdef SLK
#    LET g_forupd_sql = "SELECT sgy05,sgy04,sgyislk01,sgy06,sgy07,sgy08,sgy09,",
#                       "       sgy10,sgy11,sgy12,sgy20,sgyislk03,sgyislk04,",   
#                       "       sgyislki05,sgyislk06,sgy13,sgy14,sgy15,sgy16,", 
#                       "       sgy17,sgy18,sgy19,sgy21,sgyislki08,sgyislk09,sgyislk10",
#                       "  FROM sgy_file,sgyi_file ",
#                       " WHERE sgy01 = ? AND sgy02 = ? ",
#                       "   AND sgy01 = sgyi01 AND sgy02 = sgyi02",
#                       "   AND sgy03 = sgyi03 AND sgy05 = sgyi05",
#                       "   AND sgy03 = ? AND sgy05 = ? FOR UPDATE" 
#&else
    LET g_forupd_sql = "SELECT sgy05,sgy04,'',sgy06,sgy07,sgy08,sgy09,",
                       "       sgy10,sgy11,sgy12,sgy20,'','',",   
                       "       '','',sgy13,sgy14,sgy15,sgy16,", 
                       "       sgy17,sgy18,sgy19,sgy21,'','',''",
                       "  FROM sgy_file ",
                       " WHERE sgy01 = ? AND sgy02 = ? ",
                       "   AND sgy03 = ? AND sgy05 = ? AND sgy012 = ? FOR UPDATE" 
                                                     #FUN-A60092 add sgy012
#&endif
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i721_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    INPUT ARRAY g_sgy WITHOUT DEFAULTS FROM s_sgy.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
           # OPEN i721_cl USING g_sgx_rowi  #TQC-9A0123
            OPEN i721_cl USING g_sgx.sgx01,g_sgx.sgx02,g_sgx.sgx03 #TQC-9A0123
                              ,g_sgx.sgx012   #FUN-A60092 add            
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_sgx.sgx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i721_cl
                ROLLBACK WORK 
                RETURN
            ELSE
               FETCH i721_cl INTO g_sgx.*            # 鎖住將被更改或取消的資料
               
       
                  
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_sgx.sgx01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                  CLOSE i721_cl
                  ROLLBACK WORK 
                  RETURN
               END IF
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_sgy_t.* = g_sgy[l_ac].*  #BACKUP
                OPEN i721_bcl USING g_sgx.sgx01,g_sgx.sgx02,
                                    g_sgx.sgx03,g_sgy_t.sgy05,g_sgx.sgx012   #FUN-A60092 add sgx012
                IF STATUS THEN
                   CALL cl_err("OPEN i721_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i721_bcl INTO g_sgy[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_sgy_t.sgy05,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()
                NEXT FIELD sgy05       #No.FUN-870124
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_sgy[l_ac].* TO NULL
#No.FUN-870124--BEGIN--
#           LET g_sgy[l_ac].sgy12 ='N'
#           LET g_sgy[l_ac].sgy13 = 0 
#           LET g_sgy[l_ac].sgy14 = 0
#           LET g_sgy[l_ac].sgy15 = 0
#           LET g_sgy[l_ac].sgy16 = 0
#           LET g_sgy[l_ac].sgy17 = 0
#           LET g_sgy[l_ac].sgy18 = 0
#           LET g_sgy[l_ac].sgy19 = 'N'
#           LET g_sgy[l_ac].sgy20 = 'N'
#           LET g_sgy[l_ac].sgy21 = 'N'
#&ifdef SLK
#           LET g_sgy[l_ac].sgyislk08 = 0
#           LET g_sgy[l_ac].sgyislk09 = 0
#           LET g_sgy[l_ac].sgyislk10 = 0
#&endif 
#No.FUN-870124--END--          
           LET g_sgy_t.* = g_sgy[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD sgy05
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-A70131--begin            
            IF cl_null(g_sgx.sgx012) THEN 
               LET g_sgx.sgx012 = ' '
            END IF     
            IF cl_null(g_sgx.sgx02) THEN 
               LET g_sgx.sgx02=0
            END IF 
            #No.FUN-A70131--end                 
            #--Move original INSERT block from AFTER ROW to here
            INSERT INTO sgy_file (sgy01,sgy02,sgy03,sgy05,sgy04,
                                  sgy06,sgy07,sgy08,sgy09,sgy10,sgy11,sgy12,
                                  sgy20,sgy13,sgy14,sgy15,sgy16,sgy17,
                                  sgy18,sgy19,sgy21,
                                  sgyplant,sgylegal #FUN-980002
                                 ,sgy012)   #FUN-A60092 add sgy012
             VALUES(g_sgx.sgx01,g_sgx.sgx02,g_sgx.sgx03,
                    g_sgy[l_ac].sgy05,g_sgy[l_ac].sgy04,
                    g_sgy[l_ac].sgy06,g_sgy[l_ac].sgy07,g_sgy[l_ac].sgy08,
                    g_sgy[l_ac].sgy09,g_sgy[l_ac].sgy10,g_sgy[l_ac].sgy11,
                    g_sgy[l_ac].sgy12,g_sgy[l_ac].sgy20,
                    g_sgy[l_ac].sgy13,g_sgy[l_ac].sgy14,g_sgy[l_ac].sgy15,
                    g_sgy[l_ac].sgy16,g_sgy[l_ac].sgy17,g_sgy[l_ac].sgy18,
                    g_sgy[l_ac].sgy19,g_sgy[l_ac].sgy21,
                    g_plant,g_legal,g_sgx.sgx012) #FUN-980002  #FUN-A60092 add sgx012
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","sgy_file",g_sgx.sgx01,g_sgy[l_ac].sgy05,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
            ELSE
                   LET g_rec_b = g_rec_b + 1
                   DISPLAY g_rec_b TO FORMONLY.cn2
                   MESSAGE 'INSERT O.K'
            END IF
            
        AFTER FIELD sgy05   #單元編號
       CALL cl_set_comp_entry("sgy13,sgy14,sgy15,sgy16,sgy17,sgy18,                               sgy19,sgy21",TRUE)
            IF NOT cl_null(g_sgy[l_ac].sgy05) THEN
#               IF g_sgy[l_ac].sgy05 != g_sgy_t.sgy05 OR   #No.FUN-870124
#                  g_sgy_t.sgy05 IS NULL THEN              #No.FUN-870124
                  CALL cl_set_comp_entry("sgy04",TRUE)     #No.FUN-870124
                   SELECT COUNT(*) INTO l_n FROM sga_file 
                    WHERE sga01=g_sgy[l_ac].sgy05
                      AND sgaacti='Y'
                  IF l_n = 0 THEN
                   CALL cl_err(g_sgy[l_ac].sgy05,'apm-105',0)
                   DISPLAY BY NAME g_sgy[l_ac].sgy05
                   NEXT FIELD sgy05
                  END IF
                  
                  IF l_n > 0 THEN 
                     SELECT COUNT(*) INTO l_n1 FROM sgd_file
                      WHERE sgd00=g_sgx.sgx01
                        AND sgd03=g_sgx.sgx02
                        AND sgd05=g_sgy[l_ac].sgy05
                        AND sgd012=g_sgx.sgx012   #FUN-A60092 add
                      IF l_n1 = 0  THEN 
                         LET g_sgy[l_ac].sgy04 = '1'
                         CALL cl_set_comp_entry("sgy04",FALSE)
                         LET g_sgy[l_ac].sgy07 = " "
                         LET g_sgy[l_ac].sgy08 = " "
                         LET g_sgy[l_ac].sgy09 = " "
                         LET g_sgy[l_ac].sgy10 = " "
                         LET g_sgy[l_ac].sgy11 = " "
                         LET g_sgy[l_ac].sgy12 = " "
                         LET g_sgy[l_ac].sgy20 = " "
                         
                         #No.FUN-870124--BEGIN--
                       IF g_sgy_t.sgy05 IS NULL  THEN
                         LET g_sgy[l_ac].sgy13 = 0
                         LET g_sgy[l_ac].sgy14 = 0
                         LET g_sgy[l_ac].sgy15 = 0
                         LET g_sgy[l_ac].sgy16 = 0
                         LET g_sgy[l_ac].sgy17 = 0
                         LET g_sgy[l_ac].sgy18 = 0
                         LET g_sgy[l_ac].sgy19 = "N"
                         LET g_sgy[l_ac].sgy21 = "N"
                        END IF
                         #No.FUN-870124--END--
                      END IF 
                      IF l_n1 > 0 THEN
                      SELECT 
                              sgd06,sgd07,sgd08,sgd09,sgd10, 
                              sgd11,sgd13
                        INTO 
                              g_sgy[l_ac].sgy06,
                              g_sgy[l_ac].sgy07,g_sgy[l_ac].sgy08,
                              g_sgy[l_ac].sgy09,g_sgy[l_ac].sgy10,
                              g_sgy[l_ac].sgy11,g_sgy[l_ac].sgy12,
                              g_sgy[l_ac].sgy20
                        FROM sgd_file    
                       WHERE sgd00 = g_sgx.sgx01
                         AND sgd03 = g_sgx.sgx02
                         AND sgd05 = g_sgy[l_ac].sgy05
                         AND sgd012= g_sgx.sgx012      #FUN-A60092 add
                    IF g_sgy[l_ac].sgy04 IS NULL OR g_sgy[l_ac].sgy04 = '1' THEN   #No.FUN-870124
                       LET g_sgy[l_ac].sgy04 = '3'  
                    END IF                                                         #No.FUN-870124
                       DISPLAY BY NAME g_sgy[l_ac].sgy06
                       DISPLAY BY NAME g_sgy[l_ac].sgy07
                       DISPLAY BY NAME g_sgy[l_ac].sgy08
                       DISPLAY BY NAME g_sgy[l_ac].sgy09
                       DISPLAY BY NAME g_sgy[l_ac].sgy10
                       DISPLAY BY NAME g_sgy[l_ac].sgy11
                       DISPLAY BY NAME g_sgy[l_ac].sgy12
                       DISPLAY BY NAME g_sgy[l_ac].sgy20
                       
                         #No.FUN-870124--BEGIN--
                       IF g_sgy_t.sgy05 IS NULL  THEN
                         LET g_sgy[l_ac].sgy13 = NULL
                         LET g_sgy[l_ac].sgy14 = NULL
                         LET g_sgy[l_ac].sgy15 = NULL
                         LET g_sgy[l_ac].sgy16 = NULL
                         LET g_sgy[l_ac].sgy17 = NULL
                         LET g_sgy[l_ac].sgy18 = NULL
                         LET g_sgy[l_ac].sgy19 = NULL
                         LET g_sgy[l_ac].sgy21 = NULL
                        END IF
                         #No.FUN-870124--END--
                      END IF
                  END IF                 
#               END IF   #No.FUN-870124
            END IF 
       BEFORE FIELD sgy04 #變更方式
         CALL i721_set_sgy04()
       
       AFTER FIELD sgy04
         CALL i721_set_sgy04_1()
         IF g_sgy[l_ac].sgy04 = '2' THEN
            CALL cl_set_comp_entry("sgy13,sgy14,sgy15,                                   sgy16,sgy17,sgy18,sgy19,sgy21",FALSE)
         END IF 
         IF g_sgy[l_ac].sgy04 = '1' OR g_sgy[l_ac].sgy04 = '3' THEN
            CALL cl_set_comp_entry("sgy13,sgy14,sgy15,sgy16,sgy17,                                    sgy18,sgy19,sgy21",TRUE)         
         END IF 
          
#No.FUN-870124--BEGIN--mark
#        AFTER FIELD sgy06     #零件數
#            IF NOT cl_null(g_sgy[l_ac].sgy06) THEN
#              IF g_sgy[l_ac].sgy06 = 0  THEN
#                 NEXT FIELD sgy06
#              END IF
#              LET g_sgy[l_ac].sgy08 = g_sgy[l_ac].sgy07 * g_sgy[l_ac].sgy06
#              LET g_sgy[l_ac].sgy11 = g_sgy[l_ac].sgy10 * g_sgy[l_ac].sgy06
#              DISPLAY BY NAME g_sgy[l_ac].sgy08
#              DISPLAY BY NAME g_sgy[l_ac].sgy11
#           END IF
 
#       BEFORE FIELD sgy09     #發放碼
#           LET g_sgy[l_ac].sgy09 = g_sgy[l_ac].sgy08 / 500
#           IF g_sgy[l_ac].sgy09 < 0.001 THEN
#              LET g_sgy[l_ac].sgy09 = 0.001
#           END IF
#           DISPLAY BY NAME g_sgy[l_ac].sgy09
 
#       AFTER FIELD sgy09
#           IF NOT cl_null(g_sgy[l_ac].sgy09) THEN
#              IF g_sgy[l_ac].sgy09 = 0  THEN
#                 NEXT FIELD sgy09
#              END IF
#           END IF
#No.FUN-870124--END--MARK
#No.FUN-870124--BEGIN--ADD
        AFTER FIELD sgy13
         IF g_sgy_t.sgy13 IS NULL OR g_sgy[l_ac].sgy13 != g_sgy_t.sgy13 THEN
          IF g_sgy[l_ac].sgy04 = '1' THEN                                                                                         
             IF g_sgy[l_ac].sgy13 IS NULL THEN                                                                                    
                CALL cl_err('','agl-154',0)                                                                                       
                NEXT FIELD sgy13                                                                                                  
             END IF                                                                                                               
          END IF
          IF NOT cl_null(g_sgy[l_ac].sgy13) THEN 
             IF g_sgy[l_ac].sgy13 = 0  THEN                                                                                       
                NEXT FIELD sgy13                                                                                                  
             END IF
             LET g_sgy[l_ac].sgy15 = g_sgy[l_ac].sgy14 * g_sgy[l_ac].sgy13                                                        
             LET g_sgy[l_ac].sgy18 = g_sgy[l_ac].sgy17 * g_sgy[l_ac].sgy13
             DISPLAY BY NAME g_sgy[l_ac].sgy15
             DISPLAY BY NAME g_sgy[l_ac].sgy18
          END IF
         END IF
         
         BEFORE FIELD sgy16                                                                                                          
            LET g_sgy[l_ac].sgy16 = g_sgy[l_ac].sgy15 / 500                                                                         
            IF g_sgy[l_ac].sgy16 < 0.001 THEN                                                                                       
               LET g_sgy[l_ac].sgy16 = 0.001                                                                                        
            END IF                                                                                                                  
            DISPLAY BY NAME g_sgy[l_ac].sgy16                                                                                       
                                                                                                                                    
        AFTER FIELD sgy16                                                                                                           
         IF g_sgy_t.sgy16 IS NULL OR g_sgy[l_ac].sgy16 != g_sgy_t.sgy16 THEN
            IF g_sgy[l_ac].sgy04 = '1' THEN                                                                                         
               IF g_sgy[l_ac].sgy16 IS NULL THEN                                                                                    
                  CALL cl_err('','agl-154',0)                                                                                       
                  NEXT FIELD sgy16                                                                                                  
               END IF                                                                                                               
            END IF
            IF NOT cl_null(g_sgy[l_ac].sgy16) THEN                                                                                  
               IF g_sgy[l_ac].sgy16 = 0  THEN                                                                                       
                  NEXT FIELD sgy16                                                                                                  
               END IF                                                                                                               
            END IF  
         END IF
 
       AFTER FIELD sgy19
          IF g_sgy[l_ac].sgy04 = '1' THEN                                                                                         
             IF g_sgy[l_ac].sgy19 IS NULL THEN                                                                                    
                CALL cl_err('','agl-154',0)                                                                                       
                NEXT FIELD sgy19                                                                                                  
             END IF                                                                                                               
          END IF
 
       AFTER FIELD sgy21
          IF g_sgy[l_ac].sgy04 = '1' THEN                                                                                         
             IF g_sgy[l_ac].sgy21 IS NULL THEN                                                                                    
                CALL cl_err('','agl-154',0)                                                                                       
                NEXT FIELD sgy21                                                                                                  
             END IF                                                                                                               
          END IF
#No.FUN-870124--END--ADD--
 
        BEFORE DELETE                            #是否取消單身
#           IF g_sgy_t.sgy05 > 0 AND             #NO.FUN-870124
            IF g_sgy_t.sgy05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               DELETE FROM sgy_file
                 WHERE sgy01 = g_sgx.sgx01  
                   AND sgy02 = g_sgx.sgx02 
                   AND sgy03 = g_sgx.sgx03
                   AND sgy05 = g_sgy_t.sgy05
                   AND sgy012= g_sgx.sgx012    #FUN-A60092 add 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","sgy_file",g_sgx.sgx01,g_sgy_t.sgy05,SQLCA.sqlcode,"","",1)
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
               LET g_sgy[l_ac].* = g_sgy_t.*
               CLOSE i721_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgy[l_ac].sgy05,-263,1)
               LET g_sgy[l_ac].* = g_sgy_t.*
            ELSE
                UPDATE sgy_file 
                   SET sgy05=g_sgy[l_ac].sgy05,
                       sgy04=g_sgy[l_ac].sgy04,
                       sgy06=g_sgy[l_ac].sgy06,
                       sgy07=g_sgy[l_ac].sgy07,
                       sgy08=g_sgy[l_ac].sgy08,
                       sgy09=g_sgy[l_ac].sgy09,
                       sgy10=g_sgy[l_ac].sgy10,
                       sgy11=g_sgy[l_ac].sgy11,
                       sgy12=g_sgy[l_ac].sgy12,
                       sgy20=g_sgy[l_ac].sgy20,
                       
                       sgy13=g_sgy[l_ac].sgy13,
                       sgy14=g_sgy[l_ac].sgy14,
                       sgy15=g_sgy[l_ac].sgy15,
                       sgy16=g_sgy[l_ac].sgy16,
                       sgy17=g_sgy[l_ac].sgy17,
                       sgy18=g_sgy[l_ac].sgy18,
                       sgy19=g_sgy[l_ac].sgy19,
                       sgy21=g_sgy[l_ac].sgy21
                        
                 WHERE sgy01 = g_sgx.sgx01 
                   AND sgy02 = g_sgx.sgx02
                   AND sgy03 = g_sgx.sgx03
                   AND sgy05 = g_sgy_t.sgy05
                   AND sgy012= g_sgx.sgx012              #FUN-A60092 add 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","sgy_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","",1)
                    LET g_sgy[l_ac].* = g_sgy_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sgy[l_ac].* = g_sgy_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgy.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i721_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i721_bcl
            COMMIT WORK
 
        ON ACTION controlp  
           CASE WHEN INFIELD(sgy05)   #單元編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sga"
                LET g_qryparam.default1 = g_sgy[l_ac].sgy05
                CALL cl_create_qry() RETURNING g_sgy[l_ac].sgy05
                DISPLAY BY NAME  g_sgy[l_ac].sgy05
                NEXT FIELD sgy05
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(sgy05) AND l_ac > 1 THEN
               LET g_sgy[l_ac].* = g_sgy[l_ac-1].*
               LET g_sgy[l_ac].sgy05 = NULL
               NEXT FIELD sgy05
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION HELP
           CALL cl_show_help()
 
    END INPUT
 
    LET g_sgx.sgxmodu = g_user
    LET g_sgx.sgxdate = g_today
    UPDATE sgx_file SET sgxmodu = g_sgx.sgxmodu,sgxdate = g_sgx.sgxdate
    # WHERE ROWI = g_sgx_rowi #TQC-9A0123
     WHERE sgx01 = g_sgx.sgx01 #TQC-9A0123
      AND sgx02 = g_sgx.sgx02 #TQC-9A0123
      AND sgx03 = g_sgx.sgx03 #TQC-9A0123
      AND sgx012= g_sgx.sgx012  #FUN-A60092 
    DISPLAY BY NAME g_sgx.sgxmodu,g_sgx.sgxdate
 
    CLOSE i721_bcl
    COMMIT WORK
#   CALL i721_delall()        #CHI-C30002 mark
    CALL i721_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i721_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM sgx_file
          WHERE sgx01 = g_sgx.sgx01
            AND sgx02 = g_sgx.sgx02
            AND sgx03 = g_sgx.sgx03
            AND sgx012= g_sgx.sgx012

         INITIALIZE g_sgx.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i721_set_sgy04()
DEFINE lcbo_target ui.ComboBox                          
 
   LET lcbo_target = ui.ComboBox.forName("sgy04")   
      CALL lcbo_target.RemoveItem("1") 
END FUNCTION        
 
FUNCTION i721_set_sgy04_1()
   DEFINE lcbo_target ui.ComboBox
   DEFINE l_str    STRING
   DEFINE l_ze03   LIKE ze_file.ze03
   
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-115'
     AND ze02=g_lang
   
   LET lcbo_target = ui.ComboBox.forName("sgy04")
   LET l_str = l_ze03
   CALL lcbo_target.AddItem("1",l_str)
END FUNCTION
 
#CHI-C30002 -------- mark -------- begin
#FUNCTION i721_delall()	# 未輸入單身資料, 是否取消單頭資料
#   SELECT COUNT(*) INTO g_cnt FROM sgy_file
#    WHERE sgy01 = g_sgx.sgx01 
#      AND sgy02 = g_sgx.sgx02 
#      AND sgy03 = g_sgx.sgx03
#      AND sgy012= g_sgx.sgx012  #FUN-A60092           
#   IF g_cnt = 0 THEN
#      DISPLAY 'Del All Record'
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM sgx_file
#       WHERE sgx01 = g_sgx.sgx01  
#         AND sgx02 = g_sgx.sgx02 
#         AND sgx03 = g_sgx.sgx03
#         AND sgx012= g_sgx.sgx012  #FUN-A60092 
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
 
FUNCTION i721_b_askkey()
DEFINE
#    l_wc2           LIKE type_file.chr1000 
    l_wc2           STRING    #NO.FUN-910082 
 
    CONSTRUCT g_wc2 ON sgy05,sgy04,
                       sgy06,sgy07,sgy08,
                       sgy09,sgy10,sgy11,sgy12,sgy20,
                       sgy13,sgy14,sgy15,
                       sgy16,sgy17,sgy18,sgy19,sgy21
              FROM  s_sgy[1].sgy05,s_sgy[1].sgy04,
                    s_sgy[1].sgy06,s_sgy[1].sgy07,s_sgy[1].sgy08,
                    s_sgy[1].sgy09,s_sgy[1].sgy10,s_sgy[1].sgy11,
                    s_sgy[1].sgy12,s_sgy[1].sgy20,
                    s_sgy[1].sgy13,s_sgy[1].sgy14,s_sgy[1].sgy15,s_sgy[1].sgy16,
                    s_sgy[1].sgy17,s_sgy[1].sgy18,s_sgy[1].sgy19,s_sgy[1].sgy21
                     
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
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
         CALL cl_qbe_select()
        
      ON ACTION qbe_save
         CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i721_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i721_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#    p_wc2      LIKE type_file.chr1000,
    p_wc2      STRING,       #NO.FUN-910082 
    l_n1       LIKE type_file.num5
 
    IF p_wc2 IS NULL THEN LET p_wc2=" 1=1 " END IF
    LET g_sql =
        "SELECT sgy05,sgy04,'',sgy06,sgy07,sgy08,",
        "       sgy09,sgy10,sgy11,sgy12,sgy20,'',",
        "       '','','',sgy13,sgy14,sgy15,",
        "       sgy16,sgy17,sgy18,sgy19,sgy21,'',",
        "       '','' ",
        "  FROM sgy_file  ",
        " WHERE sgy01='",g_sgx.sgx01,"'",
        "   AND sgy02='",g_sgx.sgx02,"' AND sgy03='",g_sgx.sgx03,"' ",
        "   AND sgy012= '",g_sgx.sgx012,"'",   #FUN-A60092 
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
    #NO.FUN-810014  -----end
    PREPARE i721_pb FROM g_sql
    DECLARE sgy_curs                       #SCROLL CURSOR
        CURSOR FOR i721_pb
    CALL g_sgy.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgy_curs INTO g_sgy[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_sgy.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i721_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgy TO s_sgy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
 
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
         CALL i721_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY
         
      ON ACTION previous
         CALL i721_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	       ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL i721_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DISPLAY
 
      ON ACTION next
         CALL i721_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	       ACCEPT DISPLAY
 
      ON ACTION last
         CALL i721_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DISPLAY 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
     #@ ON ACTION 確認
        ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
     #@ ON ACTION 取消確認
         ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
     #@ ON ACTION 發放
       ON ACTION release  
         LET g_action_choice="release"  
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
 
#@    ON ACTION 相關文件
       ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                            
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i721_y()   #確認
   DEFINE l_n          LIKE type_file.num5,
          l_n1         LIKE type_file.num5          
 
    IF cl_null(g_sgx.sgx01) 
      OR cl_null(g_sgx.sgx02) OR cl_null(g_sgx.sgx03) 
      OR g_sgx.sgx012 IS NULL   #FUN-A60092 
      THEN      
       CALL cl_err('',-400,0)                                            
       RETURN                                                             
    END IF                                                                
#CHI-C30107 ------------ add ------------ begin
    IF g_sgx.sgx08="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_sgx.sgxacti="N" THEN
       CALL cl_err("",'aec-024',1)
       RETURN
    END IF
    IF NOT cl_confirm('aec-025') THEN RETURN END IF
    SELECT * INTO g_sgx.* FROM sgx_file WHERE sgx01=g_sgx.sgx01
                                          AND sgx02=g_sgx.sgx02
                                          AND sgx03=g_sgx.sgx03
                                          AND sgx012=g_sgx.sgx012
#CHI-C30107 ------------ add ------------ end
    IF g_sgx.sgx08="Y" THEN                                              
       CALL cl_err("",9023,1)                                             
       RETURN                                                             
    END IF
    IF g_sgx.sgxacti="N" THEN                                              
       CALL cl_err("",'aec-024',1) 
       RETURN                                                              
    END IF 
 
    SELECT COUNT(*) INTO l_n
      FROM sgx_file
     WHERE sgx01=g_sgx.sgx01
       AND sgx02=g_sgx.sgx02
       AND sgx09='N'
       AND sgx03!=g_sgx.sgx03
       AND sgx012=g_sgx.sgx012   #FUN-A60092 
     IF l_n > 0 THEN
        CALL cl_err('','aec-034',0)
        RETURN
     END IF
    SELECT COUNT(*) INTO l_n1
      FROM sgt_file,sgu_file
     WHERE sgt01=g_sgx.sgx01
       AND sgu04=g_sgx.sgx02
       AND sgt01=sgu_file.sgu01 
       AND sgt08='N'       
     IF l_n1 > 0 THEN 
        CALL cl_err('','aec-023',0) 
        RETURN 
     END IF     
#   IF cl_confirm('aec-025') THEN         #CHI-C30107 mark                                                             
       BEGIN WORK 
                                                              
       UPDATE sgx_file                                                    
          SET sgx08="Y"                                                   
        WHERE sgx01=g_sgx.sgx01
          AND sgx02=g_sgx.sgx02
          AND sgx03=g_sgx.sgx03
          AND sgx012=g_sgx.sgx012   #FUN-A60092 add
        IF SQLCA.sqlcode THEN                                             
            CALL cl_err3("upd","sgx_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgx08",1)                                            
            ROLLBACK WORK                                                 
        ELSE                                                             
            COMMIT WORK                                                 
            LET g_sgx.sgx08="Y"                                          
            DISPLAY BY NAME g_sgx.sgx08
        END IF
#   END IF       #CHI-C30107 mark
END FUNCTION
 
FUNCTION i721_z()
    IF cl_null(g_sgx.sgx01) 
      OR cl_null(g_sgx.sgx02) OR cl_null(g_sgx.sgx03) 
      OR g_sgx.sgx012 IS NULL        #FUN-A60092 add
      THEN             
       CALL cl_err('',-400,0)                                            
       RETURN                                                              
    END IF
    IF g_sgx.sgx08="N" OR g_sgx.sgxacti="N" THEN                          
        CALL cl_err("",'aec-027',1) 
        RETURN
    END IF
    IF g_sgx.sgx09='Y' THEN
       CALL cl_err('','aec-108',0)
       RETURN
    END IF
    IF cl_confirm('aec-028') THEN  
                                       
       BEGIN WORK                                                         
       UPDATE sgx_file                                                    
           SET sgx08="N"                                                 
         WHERE sgx01=g_sgx.sgx01
           AND sgx02=g_sgx.sgx02
           AND sgx03=g_sgx.sgx03
           AND sgx012= g_sgx.sgx012   #FUN-A60092 add
        IF SQLCA.sqlcode THEN                                
          CALL cl_err3("upd","sgx_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgx08",1)                                               
          ROLLBACK WORK
        ELSE                                                 
          COMMIT WORK                                       
          LET g_sgx.sgx08="N"                           
          DISPLAY BY NAME g_sgx.sgx08
        END IF
    END IF
END FUNCTION
 
FUNCTION i721_g()    #發放
  DEFINE l_cmd       LIKE type_file.chr1000,
         l_ecm11     LIKE ecm_file.ecm11,
         l_ecm06     LIKE ecm_file.ecm06,
         l_ecm03_par LIKE ecm_file.ecm03_par
           
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_sgx.sgx01) THEN CALL cl_err('','-400',0) RETURN END IF  
  IF g_sgx.sgx08 = 'N' THEN CALL cl_err('','aec-029',0) RETURN END IF
  IF g_sgx.sgxacti = 'N' THEN CALL cl_err('','aec-030',0) RETURN END IF 
  IF g_sgx.sgx09 = 'Y' THEN CALL cl_err(g_sgx.sgx09,'aec-031',0) RETURN END IF
  BEGIN WORK                                             
                                                           
#    OPEN i721_cl USING g_sgx_rowi   #TQC-9A0123                        
    OPEN i721_cl USING g_sgx.sgx01,g_sgx.sgx02,g_sgx.sgx03                #TQC-9A0123           
                      ,g_sgx.sgx012   #FUN-A60092 add
    IF STATUS THEN                                         
       CALL cl_err("OPEN i721_cl:", STATUS, 1)             
       CLOSE i721_cl                                       
       ROLLBACK WORK                                       
       RETURN
    END IF
    FETCH i721_cl INTO g_sgx.* 
    IF SQLCA.sqlcode THEN                                  
       CALL cl_err(g_sgx.sgx01,SQLCA.sqlcode,0) RETURN
    END IF                                                 
    CALL i721_show()
    IF NOT cl_confirm('aec-032') THEN RETURN END IF 
    LET g_sgx.sgx07=g_today    
    CALL cl_set_head_visible("","YES")
    INPUT BY NAME g_sgx.sgx07 WITHOUT DEFAULTS      
                                                           
      AFTER FIELD sgx07                
        IF cl_null(g_sgx.sgx07) THEN NEXT FIELD sgx07 END IF
        IF g_sgx.sgx07 < g_sgx.sgx06 THEN
           CALL cl_err('','aec-033',0)
           NEXT FIELD sgx07
        END IF
                                                           
      AFTER INPUT      
        IF INT_FLAG THEN EXIT INPUT END IF                 
        IF cl_null(g_sgx.sgx07) THEN NEXT FIELD sgx07 END IF
 
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
         LET g_sgx.sgx07=NULL      
         DISPLAY BY NAME g_sgx.sgx07            
         LET INT_FLAG=0            
         ROLLBACK WORK
         RETURN       
      END IF          
      
     LET g_success = 'Y'
       LET g_sql = 
            " SELECT sgy05,sgy04,'',sgy06,sgy07,sgy08, ",
            "        sgy09,sgy10,sgy11,sgy12,sgy20,'', ",
            "        '','','',sgy13,sgy14,sgy15, ",
            "        sgy16,sgy17,sgy18,sgy19,sgy21,'', ",
            "        '','' ",
            "   FROM sgy_file  ",
            "  WHERE sgy01 = '",g_sgx.sgx01,"' ",
            "    AND sgy02 = '",g_sgx.sgx02,"' ",
            "    AND sgy03 = '",g_sgx.sgx03,"' "
           ,"    AND sgy012= '",g_sgx.sgx012,"'"   #FUN-A60092 
     #NO.FUN-810014   ------end
     DECLARE sgY_cury CURSOR FROM g_sql
     FOREACH sgy_cury INTO g_sgy[l_ac].*
       CASE g_sgy[l_ac].sgy04
         WHEN '1' 
          SELECT ecm11,ecm06,ecm03_par INTO l_ecm11,l_ecm06,l_ecm03_par FROM ecm_file
           WHERE ecm01 = g_sgx.sgx01
             AND ecm03 = g_sgx.sgx02
             AND ecm012= g_sgx.sgx012   #FUN-A60092 add
          #No.FUN-A70131--begin            
          IF cl_null(g_sgx.sgx012) THEN 
             LET g_sgx.sgx012 = ' '
          END IF     
          IF cl_null(g_sgx.sgx02) THEN 
             LET g_sgx.sgx02=0
          END IF 
          #No.FUN-A70131--end                           
          INSERT INTO sgd_file(sgd00,sgd01,sgd02,sgd03,sgd04,sgd05,sgd06,sgd07,
                               sgd08,sgd09,sgd10,sgd11,sgd13,sgd14, 
                               sgdplant,sgdlegal,sgd012) #FUN-980002  #FUN-A60092 add sgd012
          VALUES(g_sgx.sgx01,l_ecm03_par,l_ecm11,g_sgx.sgx02,l_ecm06,g_sgy[l_ac].sgy05,
                 g_sgy[l_ac].sgy13,g_sgy[l_ac].sgy14,
                 g_sgy[l_ac].sgy15,g_sgy[l_ac].sgy16,g_sgy[l_ac].sgy17,
                 g_sgy[l_ac].sgy18,g_sgy[l_ac].sgy19,g_sgy[l_ac].sgy21, 
                 g_plant,g_legal,g_sgx.sgx012) #FUN-980002  #FUN-A60092 add sgx012
                 
          IF SQLCA.sqlcode  THEN            
             CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","",1)      
             LET g_success = 'N'   
             EXIT FOREACH          
          END IF
          
         WHEN '2' 
               DELETE FROM sgd_file 
                WHERE sgd00=g_sgx.sgx01
                  AND sgd03=g_sgx.sgx02 
                  AND sgd05=g_sgy[l_ac].sgy05
                  AND sgd012=g_sgx.sgx012   #FUN-A60092 add
               IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","",1)     
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
      
         WHEN '3' 
               IF NOT cl_null(g_sgy[l_ac].sgy13) THEN
                  UPDATE sgd_file SET sgd06 = g_sgy[l_ac].sgy13
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                     AND sgd012=g_sgx.sgx012    #FUN-A60092 add 
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd06",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgy[l_ac].sgy14) THEN
                  UPDATE sgd_file SET sgd07 = g_sgy[l_ac].sgy14
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                     AND sgd012=g_sgx.sgx012      #FUN-A60092 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd07",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgy[l_ac].sgy15) THEN
                  UPDATE sgd_file SET sgd08 = g_sgy[l_ac].sgy15
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                     AND sgd012 =g_sgx.sgx012    #FUN-A60092 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd08",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgy[l_ac].sgy16) THEN
                  UPDATE sgd_file SET sgd09 = g_sgy[l_ac].sgy16
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                     AND sgd012=g_sgx.sgx012     #FUN-A60092 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd09",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgy[l_ac].sgy17) THEN
                  UPDATE sgd_file SET sgd10 = g_sgy[l_ac].sgy17
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                     AND sgd012=g_sgx.sgx012    #FUN-A60092 
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd10",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgy[l_ac].sgy18) THEN
                  UPDATE sgd_file SET sgd11 = g_sgy[l_ac].sgy18
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                    AND sgd012=g_sgx.sgx012    #FUN-A60092                      
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd11",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgy[l_ac].sgy19) THEN
                  UPDATE sgd_file SET sgd13 = g_sgy[l_ac].sgy19
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                    AND sgd012=g_sgx.sgx012    #FUN-A60092                      
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd13",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
 
               IF NOT cl_null(g_sgy[l_ac].sgy21) THEN
                  UPDATE sgd_file SET sgd14 = g_sgy[l_ac].sgy21
                   WHERE sgd00=g_sgx.sgx01 
                     AND sgd03=g_sgx.sgx02
                     AND sgd05=g_sgy[l_ac].sgy05 
                     AND sgd012=g_sgx.sgx012    #FUN-A60092                      
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","sgd14",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
       END CASE
     LET l_ac=l_ac+1
     END FOREACH
 
     IF SQLCA.sqlcode  THEN            
        CALL cl_err3("sql","sgd_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","up sgd",1)      
        LET g_success = 'N'
     END IF
     UPDATE ecm_file SET ecm60=g_sgx.sgx03 
      WHERE ecm01=g_sgx.sgx01 
        and ecm03=g_sgx.sgx02 
        AND ecm012=g_sgx.sgx012   #FUN-A60092 add
     IF SQLCA.sqlcode  THEN            
        CALL cl_err3("sql","ecb_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","up ecm",1)      
        LET g_success = 'N'
     END IF   
     UPDATE sgx_file SET sgx07=g_sgx.sgx07,    
                         sgx09='Y'
                      WHERE sgx01=g_sgx.sgx01
                        AND sgx02=g_sgx.sgx02
                        AND sgx03=g_sgx.sgx03    
                        AND sgx012=g_sgx.sgx012  #FUN-A60092 add
     IF SQLCA.SQLERRD[3]=0 THEN   
        LET g_sgx.sgx07=NULL      
        DISPLAY BY NAME g_sgx.sgx07
        CALL cl_err3("upd","sgx_file",g_sgx.sgx01,g_sgx.sgx02,SQLCA.sqlcode,"","up sgx07",1)           
        LET g_success = 'N'
        RETURN       
     END IF
 
    IF g_success = 'N' THEN         
       ROLLBACK WORK 
    ELSE
       COMMIT WORK  
    END IF
    SELECT sgx09 INTO g_sgx.sgx09
      FROM sgx_file
     WHERE sgx01=g_sgx.sgx01
       AND sgx02=g_sgx.sgx02
       AND sgx03=g_sgx.sgx03
       AND sgx012=g_sgx.sgx012   #FUN-A60092 add
    DISPLAY BY NAME g_sgx.sgx07
    DISPLAY BY NAME g_sgx.sgx09
END FUNCTION
 
FUNCTION i721_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND
    ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("sgx01,sgx02,sgx03,sgx012",TRUE)  #FUN-A60092 add sgx012
   END IF
END FUNCTION
 
FUNCTION i721_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("sgx01,sgx02,sgx03,sgx012",FALSE)   #FUN-A60092 add sgx012
   END IF
END FUNCTION
#No.FUN-810016 FUN-840001
#No.FUN-B80046

