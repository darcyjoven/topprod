# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aeci121.4gl
# Descriptions...: 產品工藝單元明細變更維護作業 
# Date & Author..: #No.FUN-810016 FUN-840001 07/10/24 By hongmei
# Modify.........: #No.FUN-830088 08/04/01 By jan sgcslk01->sgc14
# Modify.........: #No.FUN-870124 08/07/25 By jan 服飾作業功能完善
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING 
# Modify.........: No.FUN-920186 09/03/17 By lala  理由碼sgv05必須為工藝原因
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9A0120 09/10/23 By liuxqa 修改ROWID
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A60021 10/06/04 By lilingyu 平行工藝
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝 
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AB0025 10/11/10 By vealxu 取消料件的管控	
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80046 11/08/03 By minpp 程序撰写规范修改
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/16 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_sgv          RECORD LIKE sgv_file.*,
    g_sgv_t        RECORD LIKE sgv_file.*,
    g_sgv_o        RECORD LIKE sgv_file.*,
    g_sgv01_t      LIKE sgv_file.sgv01,
    g_sgv012_t     LIKE sgv_file.sgv012,   #FUN-A60021 add
    g_sgv02_t      LIKE sgv_file.sgv02,
    g_sgv03_t      LIKE sgv_file.sgv03,
    g_sgv04_t      LIKE sgv_file.sgv04,
    g_sgw           DYNAMIC ARRAY OF RECORD
        sgw06       LIKE sgw_file.sgw06,        #單元編號        
        sgw05       LIKE sgw_file.sgw05,        #原變更方式
        sgwslk01    LIKE sgw_file.sgwslk01,     #原單元順序
        sgw07       LIKE sgw_file.sgw07,        #原零件數
        sgw08       LIKE sgw_file.sgw08,        #原單位工時
        sgw09       LIKE sgw_file.sgw09,        #原單元工時
        sgw10       LIKE sgw_file.sgw10,        #原單位人力
        sgw11       LIKE sgw_file.sgw11,        #原單位機時
        sgw12       LIKE sgw_file.sgw12,        #原單元機時
        sgw13       LIKE sgw_file.sgw13,        #原可委外
        sgw21       LIKE sgw_file.sgw21,        #原報工
        sgwslk03    LIKE sgw_file.sgwslk03,     #原現實工時
        sgwslk04    LIKE sgw_file.sgwslk04,     #原標准工價
        sgwslk05    LIKE sgw_file.sgwslk05,     #原現實工價
        sgwslk06    LIKE sgw_file.sgwslk06,     #新單元順序
        sgw14       LIKE sgw_file.sgw14,        #新零件數
        sgw15       LIKE sgw_file.sgw15,        #新單位工時
        sgw16       LIKE sgw_file.sgw16,        #新單元工時
        sgw17       LIKE sgw_file.sgw17,        #新單位人力
        sgw18       LIKE sgw_file.sgw18,        #新單位機時
        sgw19       LIKE sgw_file.sgw19,        #新單元機時
        sgw20       LIKE sgw_file.sgw20,        #新可委外
        sgw22       LIKE sgw_file.sgw22,        #新報工
        sgwslk08    LIKE sgw_file.sgwslk08,     #新現實工時
        sgwslk09    LIKE sgw_file.sgwslk09,     #新標准工價
        sgwslk10    LIKE sgw_file.sgwslk10      #新現實工價
                    END RECORD,
    g_sgw_t         RECORD
        sgw06       LIKE sgw_file.sgw06,        #單元編號        
        sgw05       LIKE sgw_file.sgw05,        #原變更方式
        sgwslk01    LIKE sgw_file.sgwslk01,     #原單元順序
        sgw07       LIKE sgw_file.sgw07,        #原零件數
        sgw08       LIKE sgw_file.sgw08,        #原單位工時
        sgw09       LIKE sgw_file.sgw09,        #原單元工時
        sgw10       LIKE sgw_file.sgw10,        #原單位人力
        sgw11       LIKE sgw_file.sgw11,        #原單位機時
        sgw12       LIKE sgw_file.sgw12,        #原單元機時
        sgw13       LIKE sgw_file.sgw13,        #原可委外
        sgw21       LIKE sgw_file.sgw21,        #原報工
        sgwslk03    LIKE sgw_file.sgwslk03,     #原現實工時
        sgwslk04    LIKE sgw_file.sgwslk04,     #原標准工價
        sgwslk05    LIKE sgw_file.sgwslk05,     #原現實工價
        sgwslk06    LIKE sgw_file.sgwslk06,     #新單元順序
        sgw14       LIKE sgw_file.sgw14,        #新零件數
        sgw15       LIKE sgw_file.sgw15,        #新單位工時
        sgw16       LIKE sgw_file.sgw16,        #新單元工時
        sgw17       LIKE sgw_file.sgw17,        #新單位人力
        sgw18       LIKE sgw_file.sgw18,        #新單位機時
        sgw19       LIKE sgw_file.sgw19,        #新單元機時
        sgw20       LIKE sgw_file.sgw20,        #新可委外
        sgw22       LIKE sgw_file.sgw22,        #新報工
        sgwslk08    LIKE sgw_file.sgwslk08,     #新現實工時
        sgwslk09    LIKE sgw_file.sgwslk09,     #新標准工價
        sgwslk10    LIKE sgw_file.sgwslk10      #新現實工價
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,    
    g_rec_b         LIKE type_file.num5,      #單身筆數        
    g_j             LIKE type_file.num5,      
    l_cmd           LIKE type_file.chr1000, 
#    l_wc            LIKE type_file.chr1000, 
    l_wc            STRING,    #NO.FUN-910082 
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
DEFINE   g_sql_tmp      STRING
 
MAIN
DEFINE p_row,p_col    LIKE type_file.num5
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_prog = "aeci121_slk"                                                  
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_forupd_sql = " SELECT * FROM sgv_file WHERE sgv01 = ? AND sgv02 = ? AND sgv03 =? AND sgv04 = ? AND sgv012 = ? FOR UPDATE"  #No.TQC-9A0120 mod  #FUN-A60021 add sgv012
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i121_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 4 LET p_col = 18
   OPEN WINDOW i121_w AT p_row,p_col WITH FORM "aec/42f/aeci121"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
        
   CALL cl_ui_init()     
        
       CALL cl_set_comp_visible("dummy02,dummy21,dummy22,dummy23,                                 sgwslk01,sgwslk03,sgwslk04,                                 sgwslk05,sgwslk06,sgwslk08,                                 sgwslk09,sgwslk10",TRUE) 
 
#FUN-A60021 --begin--
  IF g_sma.sma541 = 'Y' THEN 
     CALL cl_set_comp_visible("sgv012",TRUE)
  ELSE
     CALL cl_set_comp_visible("sgv012",FALSE) 	  
  END IF 
#FUN-A60021 --end--
 
   CALL i121_menu()
   CLOSE WINDOW i121_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i121_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01  
    CLEAR FORM                         #清除畫面
    CALL g_sgw.clear()
    CALL cl_set_head_visible("","YES")    
 
#-->螢幕上取單頭條件
   INITIALIZE g_sgv.* TO NULL    
#FUN-A60021 --begin--
#    CONSTRUCT BY NAME g_wc ON sgv01,sgv07,sgv05,sgv06,sgv02,        
#                              sgv08,sgv03,sgv04,sgv09,sgv10,
#                              sgvuser,sgvgrup,sgvmodu,sgvdate,sgvacti
     CONSTRUCT BY NAME g_wc ON sgv01,sgv07,sgv05,sgv02,sgv08,sgv06,sgv012,
                               sgv03,sgv04,sgv09,sgv10,
                               sgvuser,sgvgrup,sgvoriu,sgvorig,sgvmodu,sgvdate,sgvacti
#FUN-A60021 --end--                              
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sgv01) # 產品料號
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_ecu02"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgv01
                NEXT FIELD sgv01
#FUN-A60021 --begin--                
             WHEN INFIELD(sgv012) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_sgv012"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgv012
                NEXT FIELD sgv012
#FUN-A60021 --end--                                
             WHEN INFIELD(sgv02) # 工藝編號
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_ecu03"   
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgv02
                NEXT FIELD sgv02
             WHEN INFIELD(sgv05) # 變更原因
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                #LET g_qryparam.form ="q_azf4"      #FUN-920186
                LET g_qryparam.form ="q_azf01a"     #FUN-920186
                LET g_qryparam.arg1  = 'A'          #FUN-920186   
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO sgv05
                NEXT FIELD sgv05  
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
    #        LET g_wc = g_wc clipped," AND sgvuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                 #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND sgvgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #群組權限
    #        LET g_wc = g_wc clipped," AND sgvgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sgvuser', 'sgvgrup')
    #End:FUN-980030
 
    CONSTRUCT g_wc2 ON sgw06,sgw05,
                       sgwslk01,
                       sgw07,sgw08,sgw09,sgw10,sgw11,sgw12,
                       sgw13,sgw21,
                       sgwslk03,sgwslk04,sgwslk05,sgwslk06,
                       sgw14,sgw15,sgw16,sgw17,sgw18,sgw19,sgw20,sgw22
                      ,sgwslk08,sgwslk09,sgwslk10
         FROM   s_sgw[1].sgw06,s_sgw[1].sgw05,
                s_sgw[1].sgwslk01,
                s_sgw[1].sgw07,
                s_sgw[1].sgw08,s_sgw[1].sgw09,s_sgw[1].sgw10,s_sgw[1].sgw11,
                s_sgw[1].sgw12,s_sgw[1].sgw13,s_sgw[1].sgw21,
                s_sgw[1].sgwslk03,s_sgw[1].sgwslk04,
                s_sgw[1].sgwslk05,s_sgw[1].sgwslk06,
                s_sgw[1].sgw14,s_sgw[1].sgw15,
                s_sgw[1].sgw16,s_sgw[1].sgw17,s_sgw[1].sgw18,s_sgw[1].sgw19,
                s_sgw[1].sgw20,s_sgw[1].sgw22
               ,s_sgw[1].sgwslk08,
                s_sgw[1].sgwslk09,s_sgw[1].sgwslk10
       BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(sgw06)   #變更原因說明
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_sga"
                LET g_qryparam.state = 'c'
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_sgw[1].sgw06
                NEXT FIELD sgw06
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
       LET g_sql = "SELECT  sgv01,sgv02,sgv03,sgv04,sgv012 FROM sgv_file ",  #No.TQC-9A0120 mod   #FUN-A60021 add sgv012
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY sgv01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  sgv01,sgv02,sgv03,sgv04,sgv012 ",   #No.TQC-9A0120 mod  #FUN-A60021 add sgv012
                   "  FROM sgv_file, sgw_file ",
                   " WHERE sgv01 = sgw01 AND sgv02 = sgw02 AND sgv03 = sgw03",
                   "  AND sgv04=sgw04 ",
                   "  AND sgv012=sgw012",   #FUN-A60021
                   "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY sgv01"
    END IF
 
    PREPARE i121_prepare FROM g_sql
    DECLARE i121_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i121_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql_tmp= "SELECT UNIQUE sgv01,sgv02,sgv03,sgv04,sgv012 FROM sgv_file WHERE ",g_wc CLIPPED,  #FUN-A60021 add sgv012
                       " INTO TEMP x"
    ELSE
        LET g_sql_tmp="SELECT UNIQUE sgv01,sgv02,sgv03,sgv04,sgv012 FROM sgv_file,sgw_file ",  #FUN-A60021 add sgv012
                   " WHERE sgv01 = sgw01 AND sgv02 = sgw02 AND sgv03 = sgw03",
                   "  AND sgv04=sgw04 ",
                   "  AND sgv012 = sgw012",  #FUN-A60021 add
                   "  AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " INTO TEMP x"
    END IF
    DROP TABLE x
    PREPARE i121_precount_x FROM g_sql_tmp
    EXECUTE i121_precount_x
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i121_precount FROM g_sql
    DECLARE i121_count CURSOR FOR i121_precount
END FUNCTION
 
FUNCTION i121_menu()
 
   WHILE TRUE
      CALL i121_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i121_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i121_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i121_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i121_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i121_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"  #審核
            IF cl_chk_act_auth() THEN
               CALL i121_y()
            END IF
         WHEN "undo_confirm" #取消審核
            IF cl_chk_act_auth() THEN
               CALL i121_z()
            END IF
         WHEN "release"      #發放 
            IF cl_chk_act_auth() THEN
               CALL i121_g()
            END IF      
         WHEN "related_document" #相關文件
            IF cl_chk_act_auth() THEN
               IF g_sgv.sgv01 IS NOT NULL THEN
                  LET g_doc.column1 = "sgv01"
                  LET g_doc.value1 = g_sgv.sgv01
                  LET g_doc.column2 = "sgv02"
                  LET g_doc.value2 = g_sgv.sgv02
                  LET g_doc.column3 = "sgv03"
                  LET g_doc.value3 = g_sgv.sgv03
                  LET g_doc.column4 = "sgv04"
                  LET g_doc.value4 = g_sgv.sgv04
                  LET g_doc.column5 = "sgv012"       #FUN-A60021 add
                  LET g_doc.value5  = g_sgv.sgv012   #FUN-A60021 add
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i121_a()
    IF s_aglshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_sgw.clear()
    INITIALIZE g_sgv.* LIKE sgv_file.*             #DEFAULT 設定
    LET g_sgv01_t = NULL
    #預設值及將數值類變數清成零
    LET g_sgv_t.* = g_sgv.*
    LET g_sgv_o.* = g_sgv.*
    LET g_sgv.sgv07 = g_today
    LET g_sgv.sgv09='N'
    LET g_sgv.sgv10='N'
    LET g_sgv.sgvoriu = g_user #FUN-980030                                                                                      
    LET g_sgv.sgvorig = g_grup #FUN-980030
    LET g_sgv.sgvuser=g_user
    LET g_sgv.sgvdate=g_today
    LET g_sgv.sgvgrup=g_grup
    CALL cl_opmsg('a')
    BEGIN WORK
    WHILE TRUE
        CALL i121_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_sgv.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        IF cl_null(g_sgv.sgv01) OR cl_null(g_sgv.sgv02) OR  # KEY 不可空白
           cl_null(g_sgv.sgv03) OR cl_null(g_sgv.sgv04) 
           OR g_sgv.sgv012 IS NULL   #FUN-A60021 
        THEN CONTINUE WHILE
        END IF
        IF cl_null(g_sgv.sgv012) THEN LET g_sgv.sgv012 = ' ' END IF   #FUN-A60021 add
        IF cl_null(g_sgv.sgv03) THEN LET g_sgv.sgv03=0 END IF  #No.FUN-A70131
        INSERT INTO sgv_file VALUES (g_sgv.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","sgv_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        COMMIT WORK
 
#No.TQC-9A0120 mark
        #SELECT ROWID INTO g_sgv_rowid FROM sgv_file
        # WHERE sgv01=g_sgv.sgv01 
        #   AND sgv02=g_sgv.sgv02 
        #   AND sgv03=g_sgv.sgv03
        #   AND sgv04=g_sgv.sgv04
#No.TQC-9A0120 mark
        LET g_sgv01_t = g_sgv.sgv01        #保留舊值
        LET g_sgv012_t= g_sgv.sgv012       #FUN-A60021 
        LET g_sgv02_t = g_sgv.sgv02        #保留舊值
        LET g_sgv03_t = g_sgv.sgv03        #保留舊值
        LET g_sgv04_t = g_sgv.sgv04        #保留舊值
        LET g_sgv_t.* = g_sgv.*
        CALL g_sgw.clear()
        LET g_rec_b = 0
        CALL i121_b()                      #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i121_u()
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_sgv.sgv01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sgv.* FROM sgv_file
     WHERE sgv01 = g_sgv.sgv01 AND sgv02 = g_sgv.sgv02
       AND sgv03 = g_sgv.sgv03 AND sgv04 = g_sgv.sgv04
       AND sgv012= g_sgv.sgv012      #FUN-A60021
    IF g_sgv.sgv09='Y'   THEN CALL cl_err('','aec-996',0) RETURN END IF
    IF g_sgv.sgv10='Y'   THEN CALL cl_err('','aec-003',0) RETURN END IF
    IF g_sgv.sgvacti='N' THEN CALL cl_err('','mfg1000',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sgv01_t = g_sgv.sgv01
    LET g_sgv012_t= g_sgv.sgv012    #FUN-A60021
    LET g_sgv02_t = g_sgv.sgv02
    LET g_sgv03_t = g_sgv.sgv03
    LET g_sgv04_t = g_sgv.sgv04
    LET g_sgv_o.* = g_sgv.*
    BEGIN WORK
    OPEN i121_cl USING g_sgv.sgv01,g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012  #No.TQC-9A0120 mod  #FUN-A60021 add sgv012
    FETCH i121_cl INTO g_sgv.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgv.sgv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i121_cl ROLLBACK WORK RETURN
    END IF
    LET g_sgv.sgvmodu = g_user
    LET g_sgv.sgvdate = g_today
    CALL i121_show()
    WHILE TRUE
        LET g_sgv01_t = g_sgv.sgv01
        LET g_sgv012_t= g_sgv.sgv012    #FUN-A60021 add
        LET g_sgv02_t = g_sgv.sgv02
        LET g_sgv03_t = g_sgv.sgv03
        LET g_sgv04_t = g_sgv.sgv04
        CALL i121_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sgv.*=g_sgv_t.*
            CALL i121_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_sgv.sgv01 != g_sgv01_t OR g_sgv.sgv02 != g_sgv02_t
           OR g_sgv.sgv03 != g_sgv03_t OR g_sgv.sgv04 != g_sgv04_t 
           OR g_sgv.sgv012 !=g_sgv012_t  #FUN-A60021
           THEN
           UPDATE sgw_file SET sgw01=g_sgv.sgv01,sgw02=g_sgv.sgv02,
                               sgw03=g_sgv.sgv03,sgw04=g_sgv.sgv04
                              ,sgw012=g_sgv.sgv012   #FUN-A60021 add 
            WHERE sgw01=g_sgv01_t AND sgw02=g_sgv02_t
              AND sgw03=g_sgv03_t AND sgw04=g_sgv04_t
              AND sgw012=g_sgv012_t   #FUN-A60021
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","sgw_file",g_sgv01_t,g_sgv02_t,SQLCA.sqlcode,"","",1)
                CONTINUE WHILE
            END IF
        END IF
        UPDATE sgv_file SET sgv_file.* = g_sgv.*
            WHERE sgv01 = g_sgv01_t AND sgv02 = g_sgv02_t AND sgv03 = g_sgv03_t AND sgv04 = g_sgv04_t   #No.TQC-9A0120 mod 
              AND sgv012 = g_sgv012_t        #FUN-A60021
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","sgv_file",g_sgv01_t,g_sgv02_t,SQLCA.sqlcode,"","",1)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i121_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i121_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,       #判斷必要欄位是否有輸入
    p_cmd           LIKE type_file.chr1,       #a:輸入 u:更改
    l_n,l_cnt       LIKE type_file.num5, 
    l_n1,l_cnt1     LIKE type_file.num5,
    l_ecb47         LIKE ecb_file.ecb47,    
    l_cnt2,l_cnt3,l_cnt4  LIKE type_file.num5 
    DISPLAY BY NAME
        g_sgv.sgv08,g_sgv.sgv04,g_sgv.sgv09,g_sgv.sgv10,g_sgv.sgvuser,
        g_sgv.sgvmodu,g_sgv.sgvgrup,g_sgv.sgvdate,g_sgv.sgvacti
 
    CALL cl_set_head_visible("","YES")
 
    INPUT BY NAME g_sgv.sgvoriu,g_sgv.sgvorig,
        g_sgv.sgv01,g_sgv.sgv07,g_sgv.sgv05,
        g_sgv.sgv06,g_sgv.sgv02,g_sgv.sgv012,g_sgv.sgv03    #FUN-A60021 add sgv012
        WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i121_set_entry(p_cmd)
          CALL i121_set_no_entry(p_cmd)
#FUN-A60021  --begin--          
          IF p_cmd = 'a' THEN 
            LET g_sgv.sgv012 = ' '         
          END IF    
#FUN-A60021 --end--          
          LET g_before_input_done = TRUE
 
        AFTER FIELD sgv01 #產品料號
            IF NOT cl_null(g_sgv.sgv01) THEN
#FUN-AB0025 -----------mark start---------
#             #FUN-AA0059 -------------------add start------------
#              IF NOT s_chk_item_no(g_sgv.sgv01,'') THEN
#                 CALL cl_err('',g_errno,1)
#                 LET g_sgv.sgv01 = g_sgv_t.sgv01
#                 DISPLAY BY NAME g_sgv.sgv01
#                 NEXT FIELD sgv01
#              END IF
#             #FUN-AA0059 -------------------add end---------------- 
#FUN-AB0025 ----------mark end-------------
               SELECT count(*) INTO l_cnt FROM ecu_file
                WHERE ecu01=g_sgv.sgv01
                  AND ecuacti = 'Y'
               IF l_cnt = 0  THEN
                  CALL cl_err(g_sgv.sgv01,'mfg9089',0)
                  LET g_sgv.sgv01 = g_sgv_t.sgv01
                  DISPLAY BY NAME g_sgv.sgv01
                  NEXT FIELD sgv01
               END IF
#FUN-A60021 --begin--               
            ELSE
            	 NEXT FIELD CURRENT    
#FUN-A60021 --end--            	 
            END IF
            LET g_sgv_o.sgv01 = g_sgv.sgv01 
 
        AFTER FIELD sgv02  #工藝編號
            IF NOT cl_null(g_sgv.sgv02) THEN
               SELECT count(*) INTO l_cnt1 FROM ecu_file
                WHERE ecu01=g_sgv.sgv01
                  AND ecu02=g_sgv.sgv02
                  AND ecuacti = 'Y'
               IF l_cnt1 = 0  THEN
                  CALL cl_err(g_sgv.sgv02,'mfg9089',0)
                  LET g_sgv.sgv02 = g_sgv_t.sgv02
                  DISPLAY BY NAME g_sgv.sgv02
                  NEXT FIELD sgv02
               END IF
#FUN-A60021 --begin--               
            ELSE
            	 NEXT FIELD CURRENT    
#FUN-A60021 --end--                 
            END IF
            LET g_sgv_o.sgv02 = g_sgv.sgv02

#FUN-A60021 --begin--
        AFTER FIELD sgv012
          IF g_sgv.sgv012 IS NOT NULL THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM ecu_file
              WHERE ecu01  = g_sgv.sgv01
                AND ecu02  = g_sgv.sgv02
                AND ecu012 = g_sgv.sgv012
                AND ecuacti= 'Y'
             IF l_cnt = 0 THEN 
                CALL cl_err('','mfg9089',0)
                NEXT FIELD CURRENT 
             END IF                 
          ELSE
          	 NEXT FIELD CURRENT 
          END IF 
#FUN-A60021 --end--            
            
        AFTER FIELD sgv03  #工藝序號
          IF NOT cl_null(g_sgv.sgv03) THEN
             IF (g_sgv.sgv01 != g_sgv01_t) OR (g_sgv01_t IS NULL) THEN 
                 SELECT COUNT(*) INTO l_cnt2 FROM ecb_file
                  WHERE ecb01=g_sgv.sgv01 
                    AND ecb02=g_sgv.sgv02
                    AND ecb03=g_sgv.sgv03     
                    AND ecb012=g_sgv.sgv012   #FUN-A60021 add
                IF l_cnt2 = 0  THEN
                   CALL cl_err(g_sgv.sgv03,'mfg9089',0)
                   LET g_sgv.sgv03 = g_sgv_t.sgv03
                   NEXT FIELD sgv03
                END IF
             END IF
             
            LET l_cnt = 0 
            SELECT COUNT(*) INTO l_cnt3 FROM sgr_file,sgs_file
             WHERE sgr01=g_sgv.sgv01 
               AND sgr02=g_sgv.sgv02
               AND sgr01=sgs_file.sgs01 
               AND sgr02=sgs_file.sgs02 
               AND sgs05=g_sgv.sgv03 
               AND sgr09='N'
               AND sgr012 = g_sgv.sgv012   #FUN-A60021 add
               IF l_cnt3 > 0 THEN
                  CALL cl_err(g_sgv.sgv03,'aec-106',0)
                  NEXT FIELD sgv03
               END IF
            SELECT COUNT(*) INTO l_cnt4 FROM sgv_file
             WHERE sgv01=g_sgv.sgv01 
               AND sgv02=g_sgv.sgv02 
               AND sgv03=g_sgv.sgv03 
               AND sgv10='N'      
               AND sgv012=g_sgv.sgv012      #FUN-A60021 add
               IF l_cnt4 > 0 THEN
                  CALL cl_err(g_sgv.sgv03,'aec-017',0)
                  NEXT FIELD sgv03
               END IF
            END IF
            SELECT ecb47 INTO l_ecb47 FROM ecb_file
             WHERE ecb01=g_sgv.sgv01
               AND ecb02=g_sgv.sgv02 
               AND ecb03=g_sgv.sgv03
               AND ecb012=g_sgv.sgv012        #FUN-A60021 add
              IF l_ecb47 IS NULL THEN 
                LET l_ecb47 = 0
              END IF 
              LET g_sgv.sgv04 = l_ecb47 + 1       
              DISPLAY BY NAME g_sgv.sgv04
        
        AFTER FIELD sgv05  #變更原因
           IF NOT cl_null(g_sgv.sgv05) THEN
              SELECT count(*) INTO l_n1                                        
               FROM azf_file                                                    
              WHERE azf01 = g_sgv.sgv05                                         
                AND azfacti = 'Y'                                               
                AND azf02 = '2'                                                 
             IF l_n1 = 0 THEN                                                   
                CALL cl_err('','asfi115',0)                                     
                NEXT FIELD sgv05
             END IF    
              CALL i121_sgv05(p_cmd)
              #No.FUN-920186---begin
              IF NOT cl_null(g_errno) THEN 
                 CALL cl_err(g_sgv.sgv05,g_errno,0)
                 LET g_sgv.sgv05 = g_sgv_t.sgv05
                 DISPLAY BY NAME g_sgv.sgv05
                 NEXT FIELD sgv05
              END IF
              #No.FUN-920186---end
           END IF
        
        AFTER INPUT
           LET g_sgv.sgvuser = s_get_data_owner("sgv_file") #FUN-C10039
           LET g_sgv.sgvgrup = s_get_data_group("sgv_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            LET l_flag='N'
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sgv01)  #產品料號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecu02"
                 LET g_qryparam.default1 = g_sgv.sgv01
                 CALL cl_create_qry() RETURNING g_sgv.sgv01
                 DISPLAY BY NAME g_sgv.sgv01
                 NEXT FIELD sgv01
#FUN-A60021 --begin--
              WHEN INFIELD(sgv012)  
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_sgv012_1"
                 LET g_qryparam.arg1 = g_sgv.sgv01
                 LET g_qryparam.arg2 = g_sgv.sgv02
                 LET g_qryparam.default1 = g_sgv.sgv012
                 CALL cl_create_qry() RETURNING g_sgv.sgv012
                 DISPLAY BY NAME g_sgv.sgv012
                 NEXT FIELD sgv012
#FUN-A60021 --end--                 
              WHEN INFIELD(sgv02)  #工藝編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ecu03"
                 LET g_qryparam.arg1 = g_sgv.sgv01
                 LET g_qryparam.default1 = g_sgv.sgv02
                 CALL cl_create_qry() RETURNING g_sgv.sgv02
                 DISPLAY BY NAME g_sgv.sgv02
                 NEXT FIELD sgv02
              WHEN INFIELD(sgv05)  #變更原因
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_azf4"     #FUN-920186
                 LET g_qryparam.form = "q_azf01a"   #FUN-920186
                 LET g_qryparam.arg1  = 'A'         #FUN-920186
                 LET g_qryparam.default1 = g_sgv.sgv05
                 CALL cl_create_qry() RETURNING g_sgv.sgv05
                 DISPLAY BY NAME g_sgv.sgv05
                 CALL i121_sgv05('d')
                 NEXT FIELD sgv05  
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
 
FUNCTION i121_sgv05(p_cmd)  #變更原因
   DEFINE l_azf03   LIKE azf_file.azf03,
          l_azf09   LIKE azf_file.azf09,        #FUN-920186
          l_azfacti LIKE azf_file.azfacti,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno = ' '
   
   #SELECT azf03,azfacti             #FUN-920186
     #INTO l_azf03,l_azfacti         #FUN-920186
   SELECT azf03,azf09,azfacti        #FUN-920186
     INTO l_azf03,l_azf09,l_azfacti  #FUN-920186
     FROM azf_file WHERE azf01 = g_sgv.sgv05
                     AND azf02 = '2'
                     AND azfacti = 'Y'
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_azf03 = NULL
        WHEN l_azfacti='N' LET g_errno = '9028'
        WHEN l_azf09 != 'A'     LET g_errno = 'aoo-408'     #FUN-920186
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_sgv.sgv06 = l_azf03
   END IF
   DISPLAY BY NAME g_sgv.sgv06
END FUNCTION
    
#Query 查詢
FUNCTION i121_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_sgv.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_sgw.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i121_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i121_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sgv.* TO NULL
    ELSE
        OPEN i121_count
        FETCH i121_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i121_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i121_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式
    l_abso          LIKE type_file.num10     #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i121_cs INTO g_sgv.sgv01,   #No.TQC-9A0120 mod
                                             g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012    #FUN-A60021 add sgv012
        WHEN 'P' FETCH PREVIOUS i121_cs INTO g_sgv.sgv01,   #No.TQC-9A0120 mod
                                             g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012    #FUN-A60021 add sgv012
        WHEN 'F' FETCH FIRST    i121_cs INTO g_sgv.sgv01,
                                             g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012    #FUN-A60021 add sgv012
        WHEN 'L' FETCH LAST     i121_cs INTO g_sgv.sgv01,
                                             g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012    #FUN-A60021 add sgv012
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
            FETCH ABSOLUTE g_jump i121_cs INTO g_sgv.sgv01,   #No.TQC-9A0120 mod
                                               g_sgv.sgv02,g_sgv.sgv03,
                                               g_sgv.sgv04,g_sgv.sgv012    #FUN-A60021 add sgv012
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgv.sgv01,SQLCA.sqlcode,0)
        INITIALIZE g_sgv.* TO NULL
        #LET g_sgv_rowid = NULL   #No.TQC-9A1020 mark
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
    SELECT * INTO g_sgv.* FROM sgv_file 
     WHERE sgv01 = g_sgv.sgv01 AND sgv02 = g_sgv.sgv02 
       AND sgv03 = g_sgv.sgv03 AND sgv04 = g_sgv.sgv04 #No.TQC-9A0120 mod 
       AND sgv012= g_sgv.sgv012     #FUN-A60021
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sgv_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","",1)
       INITIALIZE g_sgv.* TO NULL
       RETURN
    ELSE
       LET g_data_owner = g_sgv.sgvuser
       LET g_data_group = g_sgv.sgvgrup
       CALL i121_show()
    END IF
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i121_show()
 
    LET g_sgv_t.* = g_sgv.*                #保存單頭舊值
    DISPLAY BY NAME g_sgv.sgvoriu,g_sgv.sgvorig,
 
        g_sgv.sgv01,g_sgv.sgv07,g_sgv.sgv05,g_sgv.sgv06,
        g_sgv.sgv02,g_sgv.sgv08,g_sgv.sgv03,g_sgv.sgv04,
        g_sgv.sgv09,g_sgv.sgv10,g_sgv.sgvuser,g_sgv.sgvgrup,
        g_sgv.sgvmodu,g_sgv.sgvdate,g_sgv.sgv012    #FUN-A60021 add sgv012
    CALL i121_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont() 
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i121_r()
  DEFINE l_n    LIKE type_file.num5 
    IF s_aglshut(0) THEN 
       RETURN 
    END IF
    IF g_sgv.sgv01 IS NULL THEN 
       CALL cl_err("",-400,0) 
       RETURN 
    END IF
    IF g_sgv.sgv09='Y' THEN                                                     
       CALL cl_err('','aec-996',0)                                              
       RETURN                                                                   
    END IF
    IF g_sgv.sgv10='Y' THEN 
       CALL cl_err('','mfg1005',0) 
       RETURN 
    END IF
    
    BEGIN WORK
    OPEN i121_cl USING g_sgv.sgv01,g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012  #No.TQC-9A0120  mod #FUN-A60021 add sgv012
    FETCH i121_cl INTO g_sgv.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sgv.sgv01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i121_cl ROLLBACK WORK RETURN
    END IF
    CALL i121_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sgv01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sgv.sgv01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "sgv02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_sgv.sgv02      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "sgv03"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_sgv.sgv03      #No.FUN-9B0098 10/02/24
        LET g_doc.column4 = "sgv04"         #No.FUN-9B0098 10/02/24
        LET g_doc.value4 = g_sgv.sgv04      #No.FUN-9B0098 10/02/24
        LET g_doc.column5 = "sgv012"        #FUN-A60021
        LET g_doc.value5  = g_sgv.sgv012    #FUN-A60021
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM sgv_file
        WHERE sgv01 = g_sgv.sgv01 AND sgv02 = g_sgv.sgv02
          AND sgv03 = g_sgv.sgv03 AND sgv04 = g_sgv.sgv04
          AND sgv012= g_sgv.sgv012  #FUN-A60021 
       IF STATUS THEN 
        CALL cl_err3("del","sgv_file",g_sgv.sgv01,g_sgv.sgv02,STATUS,"","del sgr:",1)     
        RETURN END IF   
       DELETE FROM sgw_file 
        WHERE sgw01 = g_sgv.sgv01 AND sgw02 = g_sgv.sgv02
          AND sgw03 = g_sgv.sgv03 AND sgw04 = g_sgv.sgv04
          AND sgw012= g_sgv.sgv012   #FUN-A60021
       IF STATUS THEN 
        CALL cl_err3("del","sgw_file",g_sgv.sgv01,g_sgv.sgv02,STATUS,"","del sgs:",1)       
        RETURN END IF   
       INITIALIZE g_sgv.* TO NULL
       CALL g_sgw.clear()
       CLEAR FORM
       OPEN i121_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i121_cs
          CLOSE i121_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i121_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i121_cs
          CLOSE i121_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i121_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i121_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i121_fetch('/')
       END IF
    END IF
    CLOSE i121_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i121_b()
   
   DEFINE
    l_ac_t          LIKE type_file.num5,           #未取消的ARRAY CNT
    l_n,l_cnt,l_num,l_numcr,l_numma,l_nummi    LIKE  type_file.num5,     #檢查重複用
    l_lock_sw       LIKE type_file.chr1,           #單身鎖住否
    p_cmd           LIKE type_file.chr1,           #處理狀態
    l_sql           LIKE type_file.chr1000,
    l_allow_insert  LIKE type_file.num5,           #可新增否
    l_allow_delete  LIKE type_file.num5,           #可刪除否
    l_cmd           LIKE type_file.chr1,
    l_n1            LIKE type_file.num5 
 
    LET g_action_choice = ""
 
    IF s_aglshut(0) THEN RETURN END IF
    IF cl_null(g_sgv.sgv01)  THEN RETURN END IF
    IF cl_null(g_sgv.sgv02)  THEN RETURN END IF
    IF cl_null(g_sgv.sgv03)  THEN RETURN END IF
    IF cl_null(g_sgv.sgv04)  THEN RETURN END IF
    IF g_sgv.sgv012 IS NULL THEN RETURN END IF   #FUN-A60021 add
#    SELECT * INTO g_sgv.* FROM sgv_file
#     WHERE sgv01=g_sgv.sgv01 AND sgv02=g_sgv.sgv02
#       AND sgv03=g_sgv.sgv03 AND sgv04=g_sgv.sgv04
    IF g_sgv.sgv09='Y' THEN
       CALL cl_err("",'9022',0) RETURN 
    END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT sgw06,sgw05,sgwslk01,sgw07,sgw08,sgw09,sgw10,",
                       "       sgw11,sgw12,sgw13,sgw21,sgwslk03,sgwslk04,",   
                       "       sgwslk05,sgwslk06,sgw14,sgw15,sgw16,sgw17,", 
                       "       sgw18,sgw19,sgw20,sgw22,sgwslk08,sgwslk09,sgwslk10",
                       "  FROM sgw_file ",
                       " WHERE sgw01 = ? AND sgw02 = ? AND sgw03 = ? ",
                       "   AND sgw04 = ? AND sgw06 = ? AND sgw012 = ? FOR UPDATE"  #FUN-A60021 add sgw012
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i121_bcl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    INPUT ARRAY g_sgw WITHOUT DEFAULTS FROM s_sgw.*
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
 
            OPEN i121_cl USING g_sgv.sgv01,g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012
            
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_sgv.sgv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i121_cl
               ROLLBACK WORK 
               RETURN
            ELSE
              FETCH i121_cl INTO g_sgv.*            # 鎖住將被更改或取消的資料
              
              
                
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_sgv.sgv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                  CLOSE i121_cl
                  ROLLBACK WORK 
                  RETURN
               END IF
            END IF
          

               IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_sgw_t.* = g_sgw[l_ac].*  #BACKUP
                OPEN i121_bcl USING g_sgv.sgv01,g_sgv.sgv02,
                                    g_sgv.sgv03,g_sgv.sgv04,g_sgw_t.sgw06,g_sgv.sgv012   #FUN-A60021 add sgv012
                IF STATUS THEN
                   CALL cl_err("OPEN i121_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i121_bcl INTO g_sgw[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_sgw_t.sgw06,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()
                NEXT FIELD sgw06       #No.FUN-870124
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_sgw[l_ac].* TO NULL 
#No.FUN-870124--BEGIN--MARK--
#           LET g_sgw[l_ac].sgw13 = 'N'
#           LET g_sgw[l_ac].sgw15 = 0
#           LET g_sgw[l_ac].sgw16 = 0
#           LET g_sgw[l_ac].sgw17 = 0
#           LET g_sgw[l_ac].sgw18 = 0
#           LET g_sgw[l_ac].sgw19 = 0
#           LET g_sgw[l_ac].sgw20 = 'N'
#           LET g_sgw[l_ac].sgw21 = 'N'
#           LET g_sgw[l_ac].sgw22 = 'N'
#&ifdef SLK
#           LET g_sgw[l_ac].sgwslk08 = 0
#           LET g_sgw[l_ac].sgwslk09 = 0
#           LET g_sgw[l_ac].sgwslk10 = 0
#&endif
#No.FUN-870124--END--
           LET g_sgw_t.* = g_sgw[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
           NEXT FIELD sgw06
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            #No.FUN-A70131--begin
            IF cl_null(g_sgv.sgv012) THEN 
               LET g_sgv.sgv012=' '
            END IF 
            IF cl_null(g_sgv.sgv03) THEN 
               LET g_sgv.sgv03=0
            END IF 
            #No.FUN-A70131--end
            #--Move original INSERT block from AFTER ROW to here
            INSERT INTO sgw_file (sgw01,sgw02,sgw03,sgw04,sgw06,sgw05,sgwslk01,
                                  sgw07,sgw08,sgw09,sgw10,sgw11,sgw12,sgw13,
                                  sgw21,sgwslk03,sgwslk04,sgwslk05,
                                  sgwslk06,sgw14,sgw15,sgw16,sgw17,sgw18,
                                  sgw19,sgw20,sgw22,sgwslk08,sgwslk09,
                                  sgwslk10,sgw012) #FUN-A60021 add sgw012
             VALUES(g_sgv.sgv01,g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,
                    g_sgw[l_ac].sgw06,g_sgw[l_ac].sgw05,g_sgw[l_ac].sgwslk01,
                    g_sgw[l_ac].sgw07,g_sgw[l_ac].sgw08,g_sgw[l_ac].sgw09,
                    g_sgw[l_ac].sgw10,g_sgw[l_ac].sgw11,g_sgw[l_ac].sgw12,
                    g_sgw[l_ac].sgw13,g_sgw[l_ac].sgw21,
                    g_sgw[l_ac].sgwslk03,g_sgw[l_ac].sgwslk04,
                    g_sgw[l_ac].sgwslk05,g_sgw[l_ac].sgwslk06,
                    g_sgw[l_ac].sgw14,g_sgw[l_ac].sgw15,g_sgw[l_ac].sgw16,
                    g_sgw[l_ac].sgw17,g_sgw[l_ac].sgw18,g_sgw[l_ac].sgw19,
                    g_sgw[l_ac].sgw20,g_sgw[l_ac].sgw22,
                    g_sgw[l_ac].sgwslk08,g_sgw[l_ac].sgwslk09,
                    g_sgw[l_ac].sgwslk10,g_sgv.sgv012)            #FUN-A60021 add g_sgv.sgv012
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","sgw_file",g_sgv.sgv01,g_sgw[l_ac].sgw06,SQLCA.sqlcode,"","",1)
                CANCEL INSERT
            ELSE
                LET g_rec_b = g_rec_b + 1
                DISPLAY g_rec_b TO FORMONLY.cn2
                MESSAGE 'INSERT O.K'
            END IF
 
        AFTER FIELD sgw06   #單元編號
#No.FUN-870124--BEGIN--
       CALL cl_set_comp_entry("sgwslk06,sgw14,sgw15,sgw16,sgw17,sgw18,sgw19,sgw20,sgw22,                               sgwslk08,sgwslk09,sgwslk10",TRUE)
#No.FUN-870124--END--
            IF NOT cl_null(g_sgw[l_ac].sgw06) THEN
#              IF g_sgw[l_ac].sgw06 != g_sgw_t.sgw06 OR  #No.FUN-870124
#                  g_sgw_t.sgw06 IS NULL THEN            #No.FUN-870124
                  CALL cl_set_comp_entry("sgw05",TRUE)   #No.FUN-870124
                   SELECT COUNT(*) INTO l_n FROM sga_file 
                    WHERE sga01=g_sgw[l_ac].sgw06
                      AND sgaacti='Y'
                  IF l_n = 0 THEN
                   CALL cl_err(g_sgw[l_ac].sgw06,'mfg9089',0)
                   DISPLAY BY NAME g_sgw[l_ac].sgw06
                   NEXT FIELD sgw06
                  END IF
                  
                  IF l_n > 0 THEN 
                     SELECT COUNT(*) INTO l_n1 FROM sgc_file 
                      WHERE sgc01=g_sgv.sgv01
                        AND sgc02=g_sgv.sgv02
                        AND sgc03=g_sgv.sgv03 
                        AND sgc05=g_sgw[l_ac].sgw06
                        AND sgc012=g_sgv.sgv012     #FUN-A60021 
                      IF l_n1 = 0  THEN 
                         LET g_sgw[l_ac].sgw05 = '1'
                         CALL cl_set_comp_entry("sgw05",FALSE)
                         LET g_sgw[l_ac].sgwslk01 = " "
                         LET g_sgw[l_ac].sgw07 = " "
                         LET g_sgw[l_ac].sgw08 = " "
                         LET g_sgw[l_ac].sgw09 = " "
                         LET g_sgw[l_ac].sgw10 = " "
                         LET g_sgw[l_ac].sgw11 = " "
                         LET g_sgw[l_ac].sgw12 = " "
                         LET g_sgw[l_ac].sgw13 = "N"
                         LET g_sgw[l_ac].sgw21 = "N"  
                         LET g_sgw[l_ac].sgwslk03 = " "
                         LET g_sgw[l_ac].sgwslk04 = " "
                         LET g_sgw[l_ac].sgwslk05 = " "
                         #No.FUN-870124--BEGIN--
                         IF g_sgw_t.sgw06 IS NULL THEN
                         LET g_sgw[l_ac].sgwslk08 = 0
                         LET g_sgw[l_ac].sgwslk09 = 0
                         LET g_sgw[l_ac].sgwslk10 = 0
                         END IF
                         #No.FUN-870124--END--
                         #No.FUN-870124--BEGIN--
                         IF g_sgw_t.sgw06 IS NULL THEN
                         LET g_sgw[l_ac].sgw20 = 'N'
                         LET g_sgw[l_ac].sgw22 = 'N'
                         LET g_sgw[l_ac].sgw15 = 0
                         LET g_sgw[l_ac].sgw16 = 0
                         LET g_sgw[l_ac].sgw17 = 0
                         LET g_sgw[l_ac].sgw18 = 0
                         LET g_sgw[l_ac].sgw19 = 0
                         END IF
                         #No.FUN-870124--END--
                      END IF 
                      IF l_n1 > 0 THEN
                      SELECT 
                             sgcslk05,
                             sgc06,sgc07,sgc08,sgc09,sgc10,
                             sgc11,sgc13,sgc14                  #No.FUN-830088
                            ,sgcslk02,sgcslk03,
                             sgcslk04
                        INTO
                             g_sgw[l_ac].sgwslk01,
                             g_sgw[l_ac].sgw07,
                             g_sgw[l_ac].sgw08,g_sgw[l_ac].sgw09,
                             g_sgw[l_ac].sgw10,g_sgw[l_ac].sgw11,
                             g_sgw[l_ac].sgw12,g_sgw[l_ac].sgw13,
                             g_sgw[l_ac].sgw21
                            ,g_sgw[l_ac].sgwslk03,
                             g_sgw[l_ac].sgwslk04,g_sgw[l_ac].sgwslk05
                        FROM sgc_file    
                       WHERE sgc01 = g_sgv.sgv01
                         AND sgc02 = g_sgv.sgv02
                         AND sgc03 = g_sgv.sgv03
                         AND sgc05 = g_sgw[l_ac].sgw06
                         AND sgc012= g_sgv.sgv012  #FUN-A60021 add
                      IF cl_null(g_sgw[l_ac].sgw05) OR g_sgw[l_ac].sgw05 = '1' THEN   #No.FUN-870124
                       LET g_sgw[l_ac].sgw05 = '3'
                      END IF                                           #No.FUN-870124
                       DISPLAY BY NAME g_sgw[l_ac].sgwslk01
                       DISPLAY BY NAME g_sgw[l_ac].sgw07
                       DISPLAY BY NAME g_sgw[l_ac].sgw08
                       DISPLAY BY NAME g_sgw[l_ac].sgw09
                       DISPLAY BY NAME g_sgw[l_ac].sgw10
                       DISPLAY BY NAME g_sgw[l_ac].sgw11
                       DISPLAY BY NAME g_sgw[l_ac].sgw12
                       DISPLAY BY NAME g_sgw[l_ac].sgw13
                       DISPLAY BY NAME g_sgw[l_ac].sgw21
                       DISPLAY BY NAME g_sgw[l_ac].sgwslk03
                       DISPLAY BY NAME g_sgw[l_ac].sgwslk04
                       DISPLAY BY NAME g_sgw[l_ac].sgwslk05
                       #No.FUN-870124--BEGIN--
                       IF g_sgw_t.sgw06 IS NULL THEN
                       LET g_sgw[l_ac].sgwslk08 = NULL
                       LET g_sgw[l_ac].sgwslk09 = NULL
                       LET g_sgw[l_ac].sgwslk10 = NULL
                       END IF
                       #No.FUN-870124--END--
                       #No.FUN-870124--BEGIN--
                       IF g_sgw_t.sgw06 IS NULL THEN
                       LET g_sgw[l_ac].sgw20 = NULL
                       LET g_sgw[l_ac].sgw22 = NULL
                       LET g_sgw[l_ac].sgw15 = NULL
                       LET g_sgw[l_ac].sgw16 = NULL
                       LET g_sgw[l_ac].sgw17 = NULL
                       LET g_sgw[l_ac].sgw18 = NULL
                       LET g_sgw[l_ac].sgw19 = NULL
                       END IF
                       #No.FUN-870124--END--
 
                      END IF
                  END IF                 
#               END IF    #No.FUN-870124
            END IF 
       BEFORE FIELD sgw05 #變更方式
         CALL i121_set_sgw05()
       
       AFTER FIELD sgw05
         CALL i121_set_sgw05_1()
         IF g_sgw[l_ac].sgw05 = '2' THEN
#No.FUN-870124--begin--
#            CALL cl_set_comp_entry("
#&ifdef SLK           
#                                   sgwslk06,
#&endif                                   
#                                   sgw14,sgw15,sgw16,sgw17,sgw18,sgw19,sgw20,sgw22
#&ifdef SLK                                   
#                                  ,sgwslk08,sgwslk09,sgwslk10
#&endif                                  
#                                   ",FALSE)
       CALL cl_set_comp_entry("sgwslk06,sgw14,sgw15,sgw16,sgw17,sgw18,sgw19,sgw20,sgw22,                               sgwslk08,sgwslk09,sgwslk10",FALSE)
#No.FUN-870124--END--
         END IF 
         IF g_sgw[l_ac].sgw05 = '1' OR g_sgw[l_ac].sgw05 = '3' THEN
#No.FUN-870124--BEGIN--
#            CALL cl_set_comp_entry("
#&ifdef SLK            
#                                   sgwslk06,
#&endif
#                                   sgw14,sgw15,sgw16,sgw17,sgw18,sgw19,sgw20,sgw22
#&ifdef SLK
#                                  ,sgwslk08,sgwslk09,sgwslk10
#&endif
#                                   ",TRUE)         
       CALL cl_set_comp_entry("sgwslk06,sgw14,sgw15,sgw16,sgw17,sgw18,sgw19,sgw20,sgw22,                               sgwslk08,sgwslk09,sgwslk10",TRUE)
#No.FUN-870124--END--
         END IF
          
       AFTER FIELD sgwslk06  #單元順序
            IF NOT cl_null(g_sgw[l_ac].sgwslk06) THEN                     
               IF g_sgw[l_ac].sgwslk06 < 0 THEN                          
                  CALL cl_err(g_sgw[l_ac].sgwslk06,'aec-020',0)          
                  NEXT FIELD sgwslk06                                  
               END IF 
            END IF
       
       AFTER FIELD sgw14   #零件數
            IF g_sgw[l_ac].sgw05 = '1' THEN
               IF g_sgw[l_ac].sgw14 IS NULL THEN
                  CALL cl_err('','aec-019',0)
                  NEXT FIELD sgw14
               END IF
            END IF
            IF NOT cl_null(g_sgw[l_ac].sgw14) THEN
               IF g_sgw[l_ac].sgw14 = 0  THEN
                  NEXT FIELD sgw14
               END IF
               LET g_sgw[l_ac].sgw16 = g_sgw[l_ac].sgw15 * g_sgw[l_ac].sgw14
               LET g_sgw[l_ac].sgw19 = g_sgw[l_ac].sgw18 * g_sgw[l_ac].sgw14
               DISPLAY BY NAME g_sgw[l_ac].sgw16
               DISPLAY BY NAME g_sgw[l_ac].sgw19
               IF g_sgw[l_ac].sgw14 <1 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD sgw14
               END IF
            END IF
       
        BEFORE FIELD sgw17  #單位人力
            IF cl_null(g_sma.sma551) THEN
               LET g_sma.sma551=480
            END IF
            LET g_sgw[l_ac].sgw17 = g_sgw[l_ac].sgw16 / (g_sma.sma551 * 60)
            IF g_sgw[l_ac].sgw17 < 0.001 THEN
               LET g_sgw[l_ac].sgw17 = 0.001
            END IF
            DISPLAY BY NAME g_sgw[l_ac].sgw17
 
        AFTER FIELD sgw17
            IF g_sgw[l_ac].sgw05 = '1' THEN
               IF g_sgw[l_ac].sgw17 IS NULL THEN
                  CALL cl_err('','aec-019',0)
                  NEXT FIELD sgw17
               END IF
            END IF 
            IF NOT cl_null(g_sgw[l_ac].sgw17) THEN
               IF g_sgw[l_ac].sgw17 = 0  THEN
                  NEXT FIELD sgw17
               END IF
               IF g_sgw[l_ac].sgw17 <=0 THEN
                  CALL cl_err('','aec-994',0)
                  NEXT FIELD sgw17
               END IF
            END IF
            
        AFTER FIELD sgw20   #可委外
            IF g_sgw[l_ac].sgw05 = '1' THEN
               IF g_sgw[l_ac].sgw20 IS NULL THEN
                  CALL cl_err('','aec-019',0)
                  NEXT FIELD sgw20
               END IF
            END IF                    
        AFTER FIELD sgw22  #報工
            IF g_sgw[l_ac].sgw05 = '1' THEN
               IF g_sgw[l_ac].sgw22 IS NULL THEN
                  CALL cl_err('','aec-019',0)
                  NEXT FIELD sgw22
               END IF
            END IF    
            
        AFTER FIELD sgwslk08  #現實工時
            IF NOT cl_null(g_sgw[l_ac].sgwslk08) THEN                    
               IF g_sgw[l_ac].sgwslk08 < 0 THEN                          
                  CALL cl_err(g_sgw[l_ac].sgwslk03,'aec-019',0)           
                  NEXT FIELD sgwslk08                                    
               END IF                                                     
            END IF
            
        AFTER FIELD sgwslk09  #標准工價                                        
            IF NOT cl_null(g_sgw[l_ac].sgwslk09) THEN                  
               IF g_sgw[l_ac].sgwslk09 < 0 THEN                          
                  CALL cl_err(g_sgw[l_ac].sgwslk09,'aec-019',0)        
                  NEXT FIELD sgwslk09 
               END IF                                                      
            END IF
 
        AFTER FIELD sgwslk10  #現實工價                               
            IF NOT cl_null(g_sgw[l_ac].sgwslk10) THEN                    
               IF g_sgw[l_ac].sgwslk10 < 0 THEN                           
                  CALL cl_err(g_sgw[l_ac].sgwslk10,'aec-019',0)  
                  NEXT FIELD sgwslk10                                   
               END IF                                                     
            END IF
                                                   
        BEFORE DELETE                            #是否取消單身
            IF g_sgw_t.sgw06 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
               DELETE FROM sgw_file
                 WHERE sgw01 = g_sgv.sgv01 AND sgw02 = g_sgv.sgv02 
                   AND sgw03 = g_sgv.sgv03 AND sgw04 = g_sgv.sgv04
                   AND sgw06 = g_sgw_t.sgw06
                   AND sgw012= g_sgv.sgv012     #FUN-A60021 add
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","sgw_file",g_sgv.sgv01,g_sgw_t.sgw06,SQLCA.sqlcode,"","",1)
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
               LET g_sgw[l_ac].* = g_sgw_t.*
               CLOSE i121_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sgw[l_ac].sgw06,-263,1)
               LET g_sgw[l_ac].* = g_sgw_t.*
            ELSE
                UPDATE sgw_file 
                   SET sgw06=g_sgw[l_ac].sgw06,
                       sgw05=g_sgw[l_ac].sgw05,
                       sgwslk01=g_sgw[l_ac].sgwslk01,
                       sgw07=g_sgw[l_ac].sgw07,
                       sgw08=g_sgw[l_ac].sgw08,
                       sgw09=g_sgw[l_ac].sgw09,
                       sgw10=g_sgw[l_ac].sgw10,
                       sgw11=g_sgw[l_ac].sgw11,
                       sgw12=g_sgw[l_ac].sgw12,
                       sgw13=g_sgw[l_ac].sgw13,
                       sgw21=g_sgw[l_ac].sgw21,
 
                       sgwslk03=g_sgw[l_ac].sgwslk03,
                       sgwslk04=g_sgw[l_ac].sgwslk04,
                       sgwslk05=g_sgw[l_ac].sgwslk05,
                       sgwslk06=g_sgw[l_ac].sgwslk06,
                       sgw14=g_sgw[l_ac].sgw14,
                       sgw15=g_sgw[l_ac].sgw15,
                       sgw16=g_sgw[l_ac].sgw16,
                       sgw17=g_sgw[l_ac].sgw17,
                       sgw18=g_sgw[l_ac].sgw18,
                       sgw19=g_sgw[l_ac].sgw19,
                       sgw20=g_sgw[l_ac].sgw20,
                       sgw22=g_sgw[l_ac].sgw22
 
                      ,sgwslk08=g_sgw[l_ac].sgwslk08,
                       sgwslk09=g_sgw[l_ac].sgwslk09,
                       sgwslk10=g_sgw[l_ac].sgwslk10
                 WHERE sgw01 = g_sgv.sgv01 AND sgw02 = g_sgv.sgv02 
                   AND sgw03 = g_sgv.sgv03 AND sgw04 = g_sgv.sgv04
                   AND sgw06 = g_sgw_t.sgw06
                   AND sgw012= g_sgv.sgv012    #FUN-A60021 add
 
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","sgw_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","",1)
                    LET g_sgw[l_ac].* = g_sgw_t.*
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
                  LET g_sgw[l_ac].* = g_sgw_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i121_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i121_bcl
            COMMIT WORK
 
        ON ACTION controlp  
           CASE WHEN INFIELD(sgw06)   #單元編號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sga"
                LET g_qryparam.default1 = g_sgw[l_ac].sgw06
                CALL cl_create_qry() RETURNING g_sgw[l_ac].sgw06
                DISPLAY BY NAME  g_sgw[l_ac].sgw06
                NEXT FIELD sgw06
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(sgw06) AND l_ac > 1 THEN
               LET g_sgw[l_ac].* = g_sgw[l_ac-1].*
               LET g_sgw[l_ac].sgw06 = NULL
               NEXT FIELD sgw06
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
 
    LET g_sgv.sgvmodu = g_user
    LET g_sgv.sgvdate = g_today
    UPDATE sgv_file SET sgvmodu = g_sgv.sgvmodu,sgvdate = g_sgv.sgvdate
     WHERE sgv01 = g_sgv.sgv01 AND sgv02 = g_sgv.sgv02 AND sgv03 = g_sgv.sgv03 AND sgv04 = g_sgv.sgv04 #NO.TQC-9A0120 mod 
       AND sgv012= g_sgv.sgv012   #FUN-A60021 add
    DISPLAY BY NAME g_sgv.sgvmodu,g_sgv.sgvdate
 
    CLOSE i121_bcl
    COMMIT WORK
#   CALL i121_delall()    #CHI-C30002 mark
    CALL i121_delHeader()     #CHI-C30002 add
 
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION i121_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM sgv_file
          WHERE sgv01 = g_sgv.sgv01 AND sgv02 = g_sgv.sgv02
            AND sgv03 = g_sgv.sgv03 AND sgv04 = g_sgv.sgv04
            AND sgv012= g_sgv.sgv012
         INITIALIZE g_sgv.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i121_set_sgw05()
DEFINE lcbo_target ui.ComboBox                          
 
   LET lcbo_target = ui.ComboBox.forName("sgw05")   
      CALL lcbo_target.RemoveItem("1") 
END FUNCTION        
 
FUNCTION i121_set_sgw05_1()
   DEFINE lcbo_target ui.ComboBox
   DEFINE l_str    STRING
   DEFINE l_ze03   LIKE ze_file.ze03
   
   SELECT ze03 INTO l_ze03 FROM ze_file
   WHERE ze01='aec-115'
     AND ze02=g_lang
   
   LET lcbo_target = ui.ComboBox.forName("sgw05")
   LET l_str = l_ze03
   CALL lcbo_target.AddItem("1",l_str)
END FUNCTION
 
#CHI-C30002 -------- mark -------- begin
#FUNCTION i121_delall()	# 未輸入單身資料, 是否取消單頭資料
#   SELECT COUNT(*) INTO g_cnt FROM sgw_file
#    WHERE sgw01 = g_sgv.sgv01 AND sgw02 = g_sgv.sgv02 
#      AND sgw03 = g_sgv.sgv03 AND sgw04 = g_sgv.sgv04
#      AND sgw012= g_sgv.sgv012   #FUN-A60021 add          
#   IF g_cnt = 0 THEN
#      DISPLAY 'Del All Record'
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM sgv_file
#       WHERE sgv01 = g_sgv.sgv01 AND sgv02 = g_sgv.sgv02 
#         AND sgv03 = g_sgv.sgv03 AND sgv04 = g_sgv.sgv04
#         AND sgv012= g_sgv.sgv012 
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
 
FUNCTION i121_b_askkey()
DEFINE
 #   l_wc2           LIKE type_file.chr1000 
    l_wc2           STRING       #NO.FUN-910082 
 
    CONSTRUCT g_wc2 ON sgw06,sgw05,
                       sgwslk01,
                       sgw07,sgw08,sgw09,sgw10,sgw11,sgw12,sgw13,sgw21,
                       sgwslk03,sgwslk04,sgwslk05,sgwslk06,
                       sgw14,sgw15,sgw16,sgw17,sgw18,sgw19,sgw20,sgw22
                      ,sgwslk08,sgwslk09,sgwslk10
              FROM  s_sgw[1].sgw06,s_sgw[1].sgw05,
                    s_sgw[1].sgwslk01,
                    s_sgw[1].sgw07,s_sgw[1].sgw08,s_sgw[1].sgw09,
                    s_sgw[1].sgw10,s_sgw[1].sgw11,s_sgw[1].sgw12,
                    s_sgw[1].sgw13,s_sgw[1].sgw21,
                    s_sgw[1].sgwslk03,
                    s_sgw[1].sgwslk04,s_sgw[1].sgwslk05,s_sgw[1].sgwslk06,
                    s_sgw[1].sgw14,s_sgw[1].sgw15,s_sgw[1].sgw16,s_sgw[1].sgw17,
                    s_sgw[1].sgw18,s_sgw[1].sgw19,s_sgw[1].sgw20,s_sgw[1].sgw22
                   ,s_sgw[1].sgwslk08,
                    s_sgw[1].sgwslk09,s_sgw[1].sgwslk10 
                     
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
    CALL i121_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i121_b_fill(p_wc2)              #BODY FILL UP
DEFINE
#    p_wc2      LIKE type_file.chr1000,
    p_wc2      STRING,       #NO.FUN-910082 
    l_n1       LIKE type_file.num5
 
    IF p_wc2 IS NULL THEN LET p_wc2=" 1=1 " END IF
    LET g_sql =
        "SELECT sgw06,sgw05,sgwslk01,sgw07,sgw08,sgw09,",
        "       sgw10,sgw11,sgw12,sgw13,sgw21,sgwslk03,",
        "       sgwslk04,sgwslk05,sgwslk06,sgw14,sgw15,sgw16,",
        "       sgw17,sgw18,sgw19,sgw20,sgw22,sgwslk08,",
        "       sgwslk09,sgwslk10 ",
        "  FROM sgw_file  ",
        " WHERE sgw01='",g_sgv.sgv01,"' AND sgw02='",g_sgv.sgv02,"'",
        "   AND sgw03='",g_sgv.sgv03,"' AND sgw04='",g_sgv.sgv04,"' ",
        "   AND sgw012= '",g_sgv.sgv012,"'",   #FUN-A60021
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
               
    PREPARE i121_pb FROM g_sql
    DECLARE sgw_curs                       #SCROLL CURSOR
        CURSOR FOR i121_pb
    CALL g_sgw.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH sgw_curs INTO g_sgw[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_sgw.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt -1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i121_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgw TO s_sgw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i121_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
         ACCEPT DISPLAY
         
      ON ACTION previous
         CALL i121_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	       ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL i121_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	       ACCEPT DISPLAY
 
      ON ACTION next
         CALL i121_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)
           END IF
	       ACCEPT DISPLAY
 
      ON ACTION last
         CALL i121_fetch('L')
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
 
FUNCTION i121_y()   #確認
   DEFINE l_n    LIKE type_file.num5,
          l_n1   LIKE type_file.num5
 
    IF cl_null(g_sgv.sgv01) OR cl_null(g_sgv.sgv02) 
      OR cl_null(g_sgv.sgv03) OR cl_null(g_sgv.sgv04) 
      OR g_sgv.sgv012 IS NULL                            #FUN-A60021 add
      THEN      
       CALL cl_err('',-400,0)                                            
       RETURN                                                             
    END IF                                                                
#CHI-C30107 --------- add ----------- begin
    IF g_sgv.sgv09="Y" THEN
       CALL cl_err("",9023,1)
       RETURN
    END IF
    IF g_sgv.sgvacti="N" THEN
       CALL cl_err("",'aec-024',1)
       RETURN
    END IF
    IF NOT cl_confirm('aec-025') THEN RETURN END IF
    SELECT * INTO g_sgv.* FROM sgv_file WHERE sgv01=g_sgv.sgv01
                                          AND sgv02=g_sgv.sgv02
                                          AND sgv03=g_sgv.sgv03
                                          AND sgv04=g_sgv.sgv04
                                          AND sgv012=g_sgv.sgv012
#CHI-C30107 --------- add ----------- end
    IF g_sgv.sgv09="Y" THEN                                              
       CALL cl_err("",9023,1)                                             
       RETURN                                                             
    END IF
    IF g_sgv.sgvacti="N" THEN                                              
       CALL cl_err("",'aec-024',1) 
       RETURN                                                              
    END IF 
 
    SELECT COUNT(*) INTO l_n
      FROM sgv_file
     WHERE sgv01=g_sgv.sgv01 
       AND sgv02=g_sgv.sgv02 
       AND sgv03=g_sgv.sgv03
       AND sgr10='N' 
       AND sgv04!=g_sgv.sgv04 
       AND sgv012=g_sgv.sgv012   #FUN-A60021 
     IF l_n > 0 THEN
        CALL cl_err('','aec-022',0)
        RETURN
     END IF
    SELECT COUNT(*) INTO l_n1
      FROM sgr_file,sgs_file
     WHERE sgr01=g_sgv.sgv01
       AND sgr02=g_sgv.sgv02
       AND sgr01=sgs_file.sgs01
       AND sgr02=sgs_file.sgs02 
       AND sgs05=g_sgv.sgv03 
       AND sgr09='N' 
       AND sgr012=g_sgv.sgv012  #FUN-A60021
     IF l_n1 > 0 THEN 
        CALL cl_err('','aec-023',0) 
        RETURN 
     END IF     
#   IF cl_confirm('aec-025') THEN   #CHI-C30107 mark                                                                   
       BEGIN WORK 
                                                              
       UPDATE sgv_file                                                    
          SET sgv09="Y"                                                   
        WHERE sgv01=g_sgv.sgv01
          AND sgv02=g_sgv.sgv02
          AND sgv03=g_sgv.sgv03
          AND sgv04=g_sgv.sgv04
          AND sgv012=g_sgv.sgv012   #FUN-A60021 add 
        IF SQLCA.sqlcode THEN                                             
            CALL cl_err3("upd","sgv_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgv09",1)                                            
            ROLLBACK WORK                                                 
        ELSE                                                             
            COMMIT WORK                                                 
            LET g_sgv.sgv09="Y"                                          
            DISPLAY BY NAME g_sgv.sgv09
        END IF
#   END IF  #CHI-C30107  mark
END FUNCTION
 
FUNCTION i121_z()
    IF cl_null(g_sgv.sgv01) OR cl_null(g_sgv.sgv02) 
      OR cl_null(g_sgv.sgv03) OR cl_null(g_sgv.sgv04) 
      OR g_sgv.sgv012 IS NULL             #FUN-A60021 add
      THEN             
       CALL cl_err('',-400,0)                                            
       RETURN                                                              
    END IF
    IF g_sgv.sgv09="N" OR g_sgv.sgvacti="N" THEN                          
        CALL cl_err("",'aec-027',1) 
        RETURN
    END IF
    IF g_sgv.sgv10='Y' THEN
       CALL cl_err('','aec-108',0)
       RETURN
    END IF
    IF cl_confirm('aec-028') THEN  
                                       
       BEGIN WORK                                                         
       UPDATE sgv_file                                                    
           SET sgv09="N"                                                 
         WHERE sgv01=g_sgv.sgv01
           AND sgv02=g_sgv.sgv02
           AND sgv03=g_sgv.sgv03
           AND sgv04=g_sgv.sgv04
           AND sgv012=g_sgv.sgv012   #FUN-A60021
        IF SQLCA.sqlcode THEN                                
          CALL cl_err3("upd","sgv_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgv09",1)                                               
          ROLLBACK WORK
        ELSE                                                 
          COMMIT WORK                                       
          LET g_sgv.sgv09="N"                           
          DISPLAY BY NAME g_sgv.sgv09
        END IF
    END IF
END FUNCTION
 
FUNCTION i121_g()  #發放
  DEFINE l_cmd     LIKE type_file.chr1000 
  DEFINE l_ecb08   LIKE ecb_file.ecb08
  IF s_shut(0) THEN RETURN END IF
  IF cl_null(g_sgv.sgv01) THEN CALL cl_err('','-400',0) RETURN END IF  
  IF g_sgv.sgv09 = 'N' THEN CALL cl_err('','aec-029',0) RETURN END IF
  IF g_sgv.sgvacti = 'N' THEN CALL cl_err('','mfg1000',0) RETURN END IF 
  IF g_sgv.sgv10 = 'Y' THEN CALL cl_err(g_sgv.sgv10,'aec-031',0) RETURN END IF
  BEGIN WORK                                             
                                                           
    OPEN i121_cl USING g_sgv.sgv01,g_sgv.sgv02,g_sgv.sgv03,g_sgv.sgv04,g_sgv.sgv012 #No.TQC-9A0120 mod  #FUN-A60021 add sgv012
    IF STATUS THEN                                         
       CALL cl_err("OPEN i121_cl:", STATUS, 1)             
       CLOSE i121_cl                                       
       ROLLBACK WORK                                       
       RETURN                                              
    END IF                                                 
   
  

    FETCH i121_cl INTO g_sgv.*                             
      IF SQLCA.sqlcode THEN                                  
       CALL cl_err(g_sgv.sgv01,SQLCA.sqlcode,0) RETURN     
    END IF                                                 
    CALL i121_show()                                       
    IF NOT cl_confirm('aec-032') THEN RETURN END IF        
    LET g_sgv.sgv08=g_today                                
    CALL cl_set_head_visible("","YES")
    INPUT BY NAME g_sgv.sgv08 WITHOUT DEFAULTS             
                                                           
      AFTER FIELD sgv08                                  
        IF cl_null(g_sgv.sgv08) THEN NEXT FIELD sgv08 END IF                                                                        
        IF g_sgv.sgv08 < g_sgv.sgv07 THEN
           CALL cl_err('','aec-033',0)
           NEXT FIELD sgv08
        END IF
                                                           
      AFTER INPUT                                          
        IF INT_FLAG THEN EXIT INPUT END IF                 
        IF cl_null(g_sgv.sgv08) THEN NEXT FIELD sgv08 END IF
 
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
         LET g_sgv.sgv08=NULL      
         DISPLAY BY NAME g_sgv.sgv08            
         LET INT_FLAG=0            
         ROLLBACK WORK
         RETURN       
      END IF          
      
     LET g_success = 'Y'
     DECLARE sgw_cury CURSOR FOR
             SELECT sgw06,sgw05,sgwslk01,sgw07,sgw08,sgw09,     #No.FUN-870124
                    sgw10,sgw11,sgw12,sgw13,sgw21,sgwslk03,
                    sgwslk04,sgwslk05,sgwslk06,sgw14,sgw15,sgw16,
                    sgw17,sgw18,sgw19,sgw20,sgw22,sgwslk08,
                    sgwslk09,sgwslk10
               FROM sgw_file 
              WHERE sgw01 = g_sgv.sgv01
                AND sgw02 = g_sgv.sgv02
                AND sgw03 = g_sgv.sgv03
                AND sgw04 = g_sgv.sgv04
                AND sgw012= g_sgv.sgv012   #FUN-A60021 add
     FOREACH sgw_cury INTO g_sgw[l_ac].*
       CASE g_sgw[l_ac].sgw05
         WHEN '1' 
          SELECT ecb08 INTO l_ecb08 FROM ecb_file
           WHERE ecb01=g_sgv.sgv01
             AND ecb02=g_sgv.sgv02
             AND ecb03=g_sgv.sgv03
             AND ecb012=g_sgv.sgv012  #FUN-A60021
          #No.FUN-A70131--begin
           IF cl_null(g_sgv.sgv012) THEN 
              LET g_sgv.sgv012=' '
           END IF 
           IF cl_null(g_sgv.sgv03) THEN 
              LET g_sgv.sgv03=0
           END IF 
           #No.FUN-A70131--end   
          INSERT INTO sgc_file(sgc01,sgc02,sgc03,sgc04,sgc05,
                               sgcslk05,
                               sgc06,sgc07,
                               sgc08,sgc09,sgc10,sgc11,sgc13,sgc14
                               ,sgcslk02,sgcslk03,sgcslk04
                               
                            ,sgc012)   #FUN-A60021 add sgv012
          VALUES(g_sgv.sgv01,g_sgv.sgv02,g_sgv.sgv03,l_ecb08,g_sgw[l_ac].sgw06,
                 g_sgw[l_ac].sgwslk06,
                 g_sgw[l_ac].sgw14,g_sgw[l_ac].sgw15,
                 g_sgw[l_ac].sgw16,g_sgw[l_ac].sgw17,g_sgw[l_ac].sgw18,
                 g_sgw[l_ac].sgw19,g_sgw[l_ac].sgw20,g_sgw[l_ac].sgw22
                ,g_sgw[l_ac].sgwslk08,g_sgw[l_ac].sgwslk09,
                 g_sgw[l_ac].sgwslk10
                 ,g_sgv.sgv012)    #FUN-A60021 add sgv012
          IF SQLCA.sqlcode  THEN            
             CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","",1)      
             LET g_success = 'N'   
             EXIT FOREACH          
          END IF
          
         WHEN '2' 
               DELETE FROM sgc_file
                WHERE sgc01=g_sgv.sgv01
                  AND sgc02=g_sgv.sgv02
                  AND sgc03=g_sgv.sgv03
                  AND sgc05=g_sgw[l_ac].sgw06
                  AND sgc012=g_sgv.sgv012    #FUN-A60021
               IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","",1)     
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
      
         WHEN '3'
               IF NOT cl_null(g_sgw[l_ac].sgwslk06) THEN
                  UPDATE sgc_file SET sgcslk05 = g_sgw[l_ac].sgwslk06
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012        #FUN-A60021 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgcslk05",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw14) THEN
                  UPDATE sgc_file SET sgc06 = g_sgw[l_ac].sgw14
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012         #FUN-A60021
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc06",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw15) THEN
                  UPDATE sgc_file SET sgc07 = g_sgw[l_ac].sgw15
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012        #FUN-A60021 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc07",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw16) THEN
                  UPDATE sgc_file SET sgc08 = g_sgw[l_ac].sgw16
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012        #FUN-A60021 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc08",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw17) THEN
                  UPDATE sgc_file SET sgc09 = g_sgw[l_ac].sgw17
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012   #FUN-A60021 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc09",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw18) THEN
                  UPDATE sgc_file SET sgc10 = g_sgw[l_ac].sgw18
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012     #FUN-A60021 
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc10",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw19) THEN
                  UPDATE sgc_file SET sgc11 = g_sgw[l_ac].sgw19
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06
                     AND sgc012=g_sgv.sgv012        #FUN-A60021  
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc11",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw20) THEN
                  UPDATE sgc_file SET sgc13 = g_sgw[l_ac].sgw20
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012     #FUN-A60021 
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc13",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgw22) THEN
                  UPDATE sgc_file SET sgc14 = g_sgw[l_ac].sgw22
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012          #FUN-A60021 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgc14",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgwslk08) THEN
                  UPDATE sgc_file SET sgcslk02 = g_sgw[l_ac].sgwslk08
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012       #FUN-A60021 add
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgcslk02",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgwslk09) THEN
                  UPDATE sgc_file SET sgcslk03 = g_sgw[l_ac].sgwslk09
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012 = g_sgv.sgv012     #FUN-A60021 
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgcslk03",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
               IF NOT cl_null(g_sgw[l_ac].sgwslk10) THEN
                  UPDATE sgc_file SET sgcslk04 = g_sgw[l_ac].sgwslk10
                   WHERE sgc01=g_sgv.sgv01 
                     AND sgc02=g_sgv.sgv02
                     AND sgc03=g_sgv.sgv03
                     AND sgc05=g_sgw[l_ac].sgw06 
                     AND sgc012=g_sgv.sgv012      #FUN-A60021 
                  IF SQLCA.sqlcode  THEN            
                     CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","sgcslk04",1)      
                     LET g_success = 'N'   
                     EXIT FOREACH          
                  END IF
               END IF
       END CASE
     LET l_ac=l_ac+1
     END FOREACH
 
     IF SQLCA.sqlcode  THEN            
        CALL cl_err3("sql","sgc_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","up sgc",1)      
        LET g_success = 'N'
     END IF
     UPDATE ecb_file SET ecb47=g_sgv.sgv04 
      WHERE ecb01=g_sgv.sgv01
        AND ecb02=g_sgv.sgv02
        AND ecb03=g_sgv.sgv03
        AND ecb012=g_sgv.sgv012   #FUN-A60021
     IF SQLCA.sqlcode  THEN            
        CALL cl_err3("sql","ecb_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","up ecb",1)      
        LET g_success = 'N'
     END IF   
     UPDATE sgv_file SET sgv08=g_sgv.sgv08,    
                         sgv10='Y'
                      WHERE sgv01=g_sgv.sgv01
                        AND sgv02=g_sgv.sgv02
                        AND sgv03=g_sgv.sgv03
                        AND sgv04=g_sgv.sgv04    
                        AND sgv012=g_sgv.sgv012  #FUN-A60021 add
     IF SQLCA.SQLERRD[3]=0 THEN   
        LET g_sgv.sgv08=NULL      
        DISPLAY BY NAME g_sgv.sgv08
        CALL cl_err3("upd","sgv_file",g_sgv.sgv01,g_sgv.sgv02,SQLCA.sqlcode,"","up sgv08",1)           
        LET g_success = 'N'
        RETURN       
     END IF
 
  

    IF g_success = 'N' THEN         
       ROLLBACK WORK 
    ELSE
       COMMIT WORK  
    END IF
    SELECT sgv10 INTO g_sgv.sgv10
      FROM sgv_file
     WHERE sgv01=g_sgv.sgv01
       AND sgv02=g_sgv.sgv02
       AND sgv03=g_sgv.sgv03
       AND sgv04=g_sgv.sgv04
       AND sgv012=g_sgv.sgv012 #FUN-A60021
    DISPLAY BY NAME g_sgv.sgv08
    DISPLAY BY NAME g_sgv.sgv10
END FUNCTION
 
FUNCTION i121_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'a' AND
    ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("sgv01,sgv02,sgv03,sgv04,sgv012",TRUE)  #FUN-A60021 add sgv012
   END IF
END FUNCTION
 
FUNCTION i121_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("sgv01,sgv02,sgv03,sgv04,sgv012",FALSE)  #FUN-A60021 add sgv012
   END IF
END FUNCTION
#No.FUN-810016 FUN-840001
#NO.FUN-B80046  

