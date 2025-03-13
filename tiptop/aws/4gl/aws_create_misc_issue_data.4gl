# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_misc_issue_data.4gl
# Descriptions...: 提供建立倉庫雜項發料資料的服務
# Date & Author..: 2008/08/08 by kim (FUN-840012)
# Memo...........:
#}
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AC0068 10/12/29 By Lilan 新增CRM整合服務
# Modify.........: No.MOD-C50065 12/05/11 By Abby 抓取CRM傳回ina07值，並回寫TIPTOP資料庫
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查

DATABASE ds
 
#FUN-840012
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
GLOBALS "../../aim/4gl/saimt370.global"
 
#GLOBALS
#DEFINE   g_argv1 LIKE type_file.chr1     #1:倉庫雜項發料作業;
#                                         #2:WIP 雜項發料作業;
#                                         #3:倉庫雜項收料作業;
#                                         #4:WIP 雜項收料作業;
#                                         #5:庫存雜項報廢作業;
#                                         #6:WIP 雜項報廢作業
DEFINE mb_inb05  LIKE inb_file.inb05
DEFINE mb_inb06  LIKE inb_file.inb06
DEFINE mb_inb07  LIKE inb_file.inb07
#END GLOBALS
 
#[
# Description....: 提供建立倉庫雜項發料資料的服務(入口 function)
# Date & Author..: 2008/08/08 by kim
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_misc_issue_data()
 
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增倉庫雜項發料資料                                                     #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_misc_issue_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
#[
# Description....: 依據傳入資訊新增 ERP 倉庫雜項發料資料
# Date & Author..: 2008/08/08 by kim
# Parameter......: none
# Return.........: 發料單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_misc_issue_data_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10
    DEFINE l_sql      STRING
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_cnt1     LIKE type_file.num10
    DEFINE l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         ina01   LIKE ina_file.ina01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_status   LIKE ina_file.inaconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING

    LET g_lastdat = MDY(12,31,9999) 
 
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的倉庫雜項發料資料                                    #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("ina_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
 
    SELECT * INTO g_sma.*
      FROM sma_file
     WHERE sma00='0'
 
    IF g_sma.sma115='Y' THEN  #不可使用多單位
       LET g_status.code = "asm-383"
       RETURN
    END IF
 
    IF g_access.application = "CRM" THEN   #FUN-AC0068 add 
       LET g_argv1 = ''                    #FUN-AC0068 add 
    ELSE                                   #FUN-AC0068 add 
       LET g_argv1 = '1'
    END IF                                 #FUN-AC0068 add 

    BEGIN WORK
 
    FOR l_i = 1 TO l_cnt1
        INITIALIZE g_ina.* TO NULL
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "ina_file")        #目前處理單檔的 XML 節點
        LET l_status = aws_ttsrv_getParameter("status")
 
       #FUN-AC0068 add str -----
        IF g_access.application = "CRM" THEN                            
           LET g_ina.ina00 = aws_ttsrv_getRecordField(l_node1, "ina00")
           LET g_argv1 = g_ina.ina00
        ELSE
       #FUN-AC0068 add end -----
           LET g_ina.ina00 = g_argv1
        END IF                                                          #FUN-AC0068 add

        LET g_ina.ina01 = aws_ttsrv_getRecordField(l_node1, "ina01")    #取得此筆單檔資料的欄位值
        LET g_ina.ina03 = aws_ttsrv_getRecordField(l_node1, "ina03")
        LET g_ina.ina02 = g_ina.ina03
        LET g_ina.ina07 = aws_ttsrv_getRecordField(l_node1, "ina07")    #MOD-C50065 add
 
        LET gi_err_code="0"    
        LET g_errno=NULL

        #不可大於現行年月
        IF NOT t370_chk_ina02() THEN
           CALL aws_create_misc_issue_data_error()
           EXIT FOR
        END IF
 
        IF (cl_null(g_ina.ina01)) OR (NOT t370_chk_ina01()) THEN
           LET g_status.code = "apm-920"   #倉庫雜項發料自動取號失敗
           EXIT FOR
        END IF
 
        #重設人員和部門
        LET g_ina.ina11 = aws_ttsrv_getRecordField(l_node1, "ina11")         #申請人員
        LET g_ina.ina04 = aws_ttsrv_getRecordField(l_node1, "ina04")         #申請部門
 
        #------------------------------------------------------------------#
        # 設定入庫單頭預設值                                               #
        #------------------------------------------------------------------#
        IF g_access.application <> "CRM" THEN             #FUN-AC0068 add
           CALL t370_a_default()
        END IF                                            #FUN-AC0068 add

        IF NOT cl_null(g_errno) THEN
           LET g_status.code = g_errno
           EXIT FOR
        END IF
        
        #重設人員和部門
        LET g_ina.ina11 = aws_ttsrv_getRecordField(l_node1, "ina11")         #申請人員
        LET g_ina.ina04 = aws_ttsrv_getRecordField(l_node1, "ina04")         #申請部門
 
        IF cl_null(g_ina.ina11) THEN
           LET g_ina.ina11=g_user
        END IF
 
        IF cl_null(g_ina.ina04) THEN
           LET g_ina.ina04=g_grup
        END IF
 
        #單據日期
        LET g_ina.ina03 = aws_ttsrv_getRecordField(l_node1, "ina03")
        LET g_ina.ina02 = g_ina.ina03
 
       #FUN-AC0068 add str----
        IF g_access.application = "CRM" THEN      
           LET g_ina.ina10 = aws_ttsrv_getRecordField(l_node1, "ina10")  #CRM單號               
           CALL aws_create_misc_issue_data_crmdefault()                  #給予欄位預設值(單頭)
        END IF     
       #FUN-AC0068 add end----

        #----------------------------------------------------------------------#
        # 倉庫雜項發料自動取號                                                 #
        #----------------------------------------------------------------------#
        IF NOT t370_a_inschk() THEN
           LET g_status.code = "apm-920"   #倉庫雜項發料自動取號失敗
        END IF
 
        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(g_ina))
 
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "ina_file", "I", NULL)   #I 表示取得 INSERT SQL
 
        #----------------------------------------------------------------------#
        # 執行單頭 INSERT SQL                                                  #
        #----------------------------------------------------------------------#
        EXECUTE IMMEDIATE l_sql
        IF SQLCA.SQLCODE THEN
           LET g_status.code = SQLCA.SQLCODE
           LET g_status.sqlcode = SQLCA.SQLCODE
           EXIT FOR
        END IF
        
        #----------------------------------------------------------------------#
        # 處理單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "inb_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
 
        CALL cl_flow_notify(g_ina.ina01,'I')  #新增資料到 p_flow
        
        FOR l_j = 1 TO l_cnt2
            INITIALIZE b_inb.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "inb_file")   #目前單身的 XML 節點
 
            LET l_ac=l_j
            #------------------------------------------------------------------#
            # 設定欄位預設值                                                   #
            #------------------------------------------------------------------#
            CALL t370_b_bef_ins()    #預設值給在g_inb[l_ac]
            CALL t370_b_move_back()  #g_inb[l_ac]=>b_inb
            LET g_chr4  = '0'
            LET g_chr3  = '0'
            IF g_argv1 MATCHES '[135]' THEN
               LET g_imd10='S'
            ELSE
               LET g_imd10='W'
            END IF
 
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET b_inb.inb03 = l_ac                                        #項次
            LET b_inb.inb04 = aws_ttsrv_getRecordField(l_node2, "inb04")  #料
            LET b_inb.inb05 = aws_ttsrv_getRecordField(l_node2, "inb05")  #倉
            LET b_inb.inb06 = aws_ttsrv_getRecordField(l_node2, "inb06")  #儲
            LET b_inb.inb07 = aws_ttsrv_getRecordField(l_node2, "inb07")  #批
            LET b_inb.inb09 = aws_ttsrv_getRecordField(l_node2, "inb09")  #異動數量
            LET b_inb.inb15 = aws_ttsrv_getRecordField(l_node2, "inb15")  #理由碼

           #FUN-AC0068 add str----
            IF g_access.application = "CRM" THEN
               IF cl_null(b_inb.inb15) THEN
                  LET g_status.code = 'aim-709'    #與CRM整合時,理由碼不可為空
                  EXIT FOR
               END IF
               LET b_inb.inb11 = aws_ttsrv_getRecordField(l_node2, "inb11")  
            END IF
           #FUN-AC0068 add end----

            LET mb_inb05 = b_inb.inb05
            LET mb_inb06 = b_inb.inb06
            LET mb_inb07 = b_inb.inb07
            
            CALL t370_b_move_to()  #b_inb=>g_inb[l_ac]
 
            LET b_inb.inb01=g_ina.ina01
            LET b_inb.inbplant = g_plant  #FUN-AC0068 add 
            LET b_inb.inblegal = g_legal  #FUN-AC0068 add 
            #------------------------------------------------------------------#
            # 欄位檢查                                                         #
            #------------------------------------------------------------------#
            IF NOT aws_create_misc_issue_data_check_inb() THEN
               CALL aws_create_misc_issue_data_error()
               EXIT FOR
            END IF
 
            CALL t370_b_else()
            CALL t370_b_move_back() #g_inb[l_ac]=>b_inb

           #FUN-AC0068 add str----
            IF g_access.application = "CRM" THEN
               SELECT aaz90 INTO g_aaz.aaz90
                 FROM aaz_file
               LET b_inb.inb16 = b_inb.inb09
               LET b_inb.inb930 = s_costcenter(g_ina.ina04)
            END IF
           #FUN-AC0068 add end--- 

            #------------------------------------------------------------------#
            # RECORD資料傳到NODE2                                              #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(b_inb))
 
            IF cl_null(b_inb.inb05) THEN 
               LET b_inb.inb05=" "
               CALL aws_ttsrv_setRecordField(l_node2, "inb05", " ")
            END IF
            IF cl_null(b_inb.inb06) THEN 
               LET b_inb.inb06=" "
               CALL aws_ttsrv_setRecordField(l_node2, "inb06", " ")
            END IF
            IF cl_null(b_inb.inb07) THEN 
               LET b_inb.inb07=" "
               CALL aws_ttsrv_setRecordField(l_node2, "inb07", " ")
            END IF
 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "inb_file", "I", NULL) #I 表示取得 INSERT SQL
 
            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               lET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
    END FOR
    
    IF g_status.code = "0" THEN
       LET l_return.ina01 = g_ina.ina01
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
    IF g_access.application<>"CRM" OR g_smy.smydmy4='Y' THEN   #FUN-AC0068 add
       IF (l_status='Y') AND (g_status.code = "0") THEN
          LET l_prog = 'aimt370'
          LET l_cmd=l_prog," '",g_argv1,"' '",g_ina.ina01 CLIPPED,"' 'stock_post'"
          CALL cl_cmdrun_wait(l_cmd)
          CALL aws_ttsrv_cmdrun_checkStatus(l_prog)
       END IF
    END IF                                                     #FUN-AC0068 add

    CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳自動取號結果
END FUNCTION
 
FUNCTION aws_create_misc_issue_data_error()
   IF gi_err_code<>"0" THEN
      LET g_status.code = gi_err_code
   ELSE
      IF NOT cl_null(g_errno) THEN
         LET g_status.code = g_errno
      ELSE
         LET g_status.code = '-1106'
      END IF
   END IF
END FUNCTION
 
#[
# Description....: 檢查單身欄位
# Date & Author..: 2008/08/08 by kim
# Parameter......: no
# Return.........: TRUE/FALSE
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_misc_issue_data_check_inb()
  DEFINE l_cnt  LIKE type_file.num5 

  LET g_errno=NULL
  LET gi_err_code="0"
 
  IF NOT t370_chk_inb03() THEN
     RETURN FALSE
  END IF
 
  IF NOT t370_chk_inb911() THEN
     RETURN FALSE
  END IF
 
  IF NOT t370_chk_inb912() THEN
     RETURN FALSE
  END IF
 
  IF NOT t370_chk_inb04_1() THEN
     RETURN FALSE
  END IF
 
  #倉儲批會被上個FUN重設成料件的主倉儲批,須改回來
  LET g_inb[l_ac].inb05 = mb_inb05
  LET g_inb[l_ac].inb06 = mb_inb06
  LET g_inb[l_ac].inb07 = mb_inb07
 
  CASE t370_chk_inb05()
     WHEN "inb05" RETURN FALSE
  END CASE
 
  CASE t370_chk_inb06()
     WHEN "inb05" RETURN FALSE
     WHEN "inb06" RETURN FALSE
  END CASE

  SELECT count(*) INTO l_cnt
    FROM ime_file
   WHERE ime01 = g_inb[l_ac].inb05 
     AND ime02 = g_inb[l_ac].inb06
     AND imeacti = 'Y'    #FUN-D40103
  IF l_cnt = 0 THEN
     IF g_sma.sma39='N' THEN
        LET g_errno = 'mfg1020'                   
        RETURN FALSE
     END IF
  END IF  
 
  CASE t370_chk_inb07('a')
     WHEN "inb04" RETURN FALSE
     WHEN "inb06" RETURN FALSE
     WHEN "inb07" RETURN FALSE
  END CASE
 
  IF NOT t370_chk_inb08() THEN
     RETURN FALSE
  END IF
 
  IF NOT t370_chk_inb09() THEN
     RETURN FALSE
  END IF                              
 
  #多單位處理,可省略
  CALL t370_du_data_to_correct()
  CALL t370_set_origin_field()
 
  IF NOT t370_chk_inb15() THEN
     RETURN FALSE
  END IF
 
  IF NOT t370_chk_inb901() THEN
     RETURN FALSE
  END IF
 
  IF NOT t370_chk_inb930() THEN
     RETURN FALSE
  END IF
 
  CASE t370_b_inschk()
     WHEN "inb04"  RETURN FALSE
     WHEN "inb907" RETURN FALSE
     WHEN "inb904" RETURN FALSE
     WHEN "inb05"  RETURN FALSE
     WHEN "errno"  RETURN FALSE
  END CASE
 
  RETURN TRUE  
END FUNCTION

#FUN-AC0068 add str -----------------
FUNCTION aws_create_misc_issue_data_crmdefault()
  DEFINE l_genacti   LIKE gen_file.genacti   
  DEFINE l_gen02     LIKE gen_file.gen02     
  
    IF cl_null(g_ina.ina02) THEN
       LET g_ina.ina02 = g_today
    END IF
   
    IF cl_null(g_ina.ina03) THEN
       LET g_ina.ina03 = g_today
    END IF
 
    IF cl_null(g_ina.ina05) THEN
       LET g_ina.ina05 = 'Y'        #是否與CRM整合
    END IF
  
    IF NOT cl_null(g_ina.ina11) THEN
       SELECT gen02,genacti
         INTO l_gen02,l_genacti
         FROM gen_file
        WHERE gen01 = g_ina.ina11
       CASE WHEN SQLCA.SQLCODE = 100
                 LET g_ina.ina11 = g_user
                 LET g_ina.ina04 = g_grup
            WHEN l_genacti='N'
                 LET g_status.code = '9028'
                 RETURN FALSE
           #OTHERWISE
           #     LET g_status.code = SQLCA.SQLCODE USING '-------'
           #     RETURN FALSE
       END CASE
    ELSE
       LET g_ina.ina11 = g_user
       LET g_ina.ina04 = g_grup
    END IF
   
    LET g_ina.ina08 = '0'
    LET g_ina.ina12 = 'N' 
    LET g_ina.inapost = 'N'
    LET g_ina.inaconf = 'N'     
    LET g_ina.inaspc  = '0'     
    LET g_ina.inauser = g_user
    LET g_ina.inaoriu = g_user 
    LET g_ina.inaorig = g_grup 
    LET g_data_plant  = g_plant 
    LET g_ina.inagrup = g_grup
    LET g_ina.inadate = g_today
    LET g_ina.inaplant = g_plant 
    LET g_ina.inalegal = g_legal
    LET g_ina.inamksg = 'N'      #簽核否
    LET g_ina.inapos  = 'N'       
    LET g_ina.inacont = ''       
    LET g_ina.inaconu = ''       
END FUNCTION
#FUN-AC0068 add end -----------------
