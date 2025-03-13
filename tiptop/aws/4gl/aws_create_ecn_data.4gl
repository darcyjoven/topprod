# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_create_ecn_data.4gl
# Descriptions...: 提供建立單一主件工程變異單資料的服務
# Date & Author..: 2010/08/02 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-A80017
# Modify.........: No:TQC-AA0004 10/10/05 By Mandy (1)申請人欄位需check員工基本資料檔
#                                                  (2)資料所有著需check p_zx
#                                                  (3)資料來源bmx11以g_plant為主
# Modify.........: No:FUN-AA0035 10/10/27 By Mandy
#                  (1)若有錯誤,錯誤訊息內加上錯誤的Key值
# Modify.........: No:FUN-AB0038 10/11/09 By Mandy (1)申請人(bmx10) not in TP or Error ,申請人(bmx10) default g_user
#                                                  (2)CALL aws_ima01_chk(g_bmy.bmy05,'1')的位置調整
# Modify.........: No:FUN-AC0060 10/12/13 By Mandy PLM-資料中心功能
# Modify.........: No:FUN-B20003 11/02/10 By Mandy PLM-調整
# Modify.........: No:FUN-B50179 11/05/31 By Abby  Bug修正
# Modify.........: No:MOD-B50260 11/05/31 By Abby  重新計算bmy10_fac2的值
#---------------------------------------------------------------------------------------------
# Modify.........: No:FUN-AC0060 11/07/05 By Mandy PLM GP5.1追版至GP5.25 以上為GP5.1單號
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版 str---
# Modify.........: No:DEV-C40006 12/04/27 By Lilan FOR DigiWinPLM整合
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版 end---
#}
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查

DATABASE ds

GLOBALS "../../config/top.global" #FUN-A80017
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

DEFINE g_bmx      RECORD LIKE bmx_file.*
DEFINE g_bmy      RECORD LIKE bmy_file.*
DEFINE g_bmw      RECORD LIKE bmw_file.*
DEFINE g_msg      STRING                #FUN-AA0035 add
DEFINE g_msg_flag LIKE type_file.chr20  #FUN-AA0035 add




#[
# Description....: 提供建立單一主件工程變異單資料的服務(入口 function)
# Date & Author..: 2010/08/02 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_ecn_data()
 
    
    WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增單一主件工程變異單資料                                                           #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_ecn_data_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION


#[
# Description....: 依據傳入資訊新增 ERP 單一主件工程變異單資料
# Date & Author..: 2010/08/02 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_ecn_data_process()
    DEFINE l_msg      STRING            #FUN-AC0060 add
    DEFINE channel    base.Channel      #FUN-AC0060 add
    DEFINE l_cmd      STRING
    DEFINE l_status   LIKE type_file.chr1     
    DEFINE l_i        LIKE type_file.num10
    DEFINE l_j        LIKE type_file.num10
    DEFINE l_sql      STRING        
    DEFINE l_cnt      LIKE type_file.num10
    DEFINE l_cnt1     LIKE type_file.num10
    DEFINE l_cnt2     LIKE type_file.num10
    DEFINE l_node1    om.DomNode
    DEFINE l_node2    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         bmx01   STRING                #回傳的欄位名稱
                      END RECORD

        
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的單一主件工程變異單資料                                      #
    #--------------------------------------------------------------------------#
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("bmx_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***
    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF

    LET l_sql =
       "SELECT * FROM bmx_file WHERE bmx01 = ? FOR UPDATE " #FUN-AC0060(110705) mod
    LET l_sql = cl_forupd_sql(l_sql)                        #FUN-AC0060(110705) add
    DECLARE i720_cl CURSOR FROM l_sql

   #FUN-AC0060---add----str---
    #建立臨時表,用于存放拋轉的資料
   #CALL s_dc_cre_temp_table("bmx_file") RETURNING g_dc_tabname      #FUN-B20003 mark
    CALL s_dc_cre_temp_table("bmx_file") RETURNING g_dc_tabname_bmx  #FUN-B20003 add
    
    #建立歷史資料拋轉的臨時表
    CALL s_dc_cre_temp_table("gex_file") RETURNING g_dc_hist_tab
   #FUN-AC0060---add----str---
    
    BEGIN WORK
    
    LET l_return.bmx01 = NULL
    LET g_return_keyno = NULL   #DEV-C40006 add

    FOR l_i = 1 TO l_cnt1       
        LET g_msg_flag = 'bmx_file' #FUN-AA0035 add
        INITIALIZE g_bmx.* TO NULL
        LET l_status = aws_ttsrv_getParameter("status")            
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "bmx_file")         #目前處理單檔的 XML 節點

        #==>取得此筆單頭資料的欄位值
        LET g_bmx.bmx01   = aws_ttsrv_getRecordField(l_node1,"bmx01")     
        LET g_bmx.bmx02   = aws_ttsrv_getRecordField(l_node1,"bmx02")    
        LET g_bmx.bmx03   = aws_ttsrv_getRecordField(l_node1,"bmx03")    
        LET g_bmx.bmx04   = aws_ttsrv_getRecordField(l_node1,"bmx04")    
        LET g_bmx.bmx05   = aws_ttsrv_getRecordField(l_node1,"bmx05")    
        LET g_bmx.bmx06   = aws_ttsrv_getRecordField(l_node1,"bmx06")    
        LET g_bmx.bmx07   = aws_ttsrv_getRecordField(l_node1,"bmx07")    
        LET g_bmx.bmx08   = aws_ttsrv_getRecordField(l_node1,"bmx08")    
        LET g_bmx.bmx09   = aws_ttsrv_getRecordField(l_node1,"bmx09")    
        LET g_bmx.bmx10   = aws_ttsrv_getRecordField(l_node1,"bmx10")    
        LET g_bmx.bmx11   = aws_ttsrv_getRecordField(l_node1,"bmx11")    
        LET g_bmx.bmx12   = aws_ttsrv_getRecordField(l_node1,"bmx12")    
        LET g_bmx.bmxuser = aws_ttsrv_getRecordField(l_node1,"bmxuser")    
        LET g_bmx.bmxgrup = aws_ttsrv_getRecordField(l_node1,"bmxgrup")    
        LET g_bmx.bmxmodu = aws_ttsrv_getRecordField(l_node1,"bmxmodu")    
        LET g_bmx.bmxdate = aws_ttsrv_getRecordField(l_node1,"bmxdate")    
        LET g_bmx.bmxacti = aws_ttsrv_getRecordField(l_node1,"bmxacti")    
        LET g_bmx.bmxmksg = aws_ttsrv_getRecordField(l_node1,"bmxmksg")    
        #----------------------------------

        #資料檢查
        IF cl_null(g_bmx.bmx01) THEN
           LET g_status.code = "-286"    #主鍵的欄位值不可為 NULL
           EXIT FOR
        END IF
        IF cl_null(g_bmx.bmx02) THEN
           LET g_status.code = "mfg6138" #重要欄位不可空白
           EXIT FOR
        END IF
        IF cl_null(g_bmx.bmx07) THEN
           LET g_status.code = "mfg6138" #重要欄位不可空白
           EXIT FOR
        END IF
       #FUN-AB0038--mark---str---
       #IF cl_null(g_bmx.bmx10) THEN
       #   LET g_status.code = "mfg6138" #重要欄位不可空白
       #   EXIT FOR
       #END IF
       #FUN-AB0038--mark---end---

        #==>單頭預設值及欄位判斷
        IF NOT aws_create_ecn_data_default() THEN         
           EXIT FOR
        END IF
        IF l_status = 'Y' THEN #自動確認
            LET g_bmx.bmxmksg = "N"
        ELSE
            LET g_bmx.bmxmksg = g_smy.smyapr
        END IF
        LET l_return.bmx01 = g_bmx.bmx01
        LET g_return_keyno = g_bmx.bmx01     #DEV-C40006 add

        #------------------------------------------------------------------#
        # RECORD資料傳到NODE                                               #
        #------------------------------------------------------------------#
        CALL aws_ttsrv_setRecordField_record(l_node1,base.Typeinfo.create(g_bmx))
        
        
        LET l_sql = aws_ttsrv_getRecordSql(l_node1, "bmx_file", "I", NULL)   #I 表示取得 INSERT SQL
   
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
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "bmy_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "arm-034"   #無單身資料!
           EXIT FOR
        END IF
        LET g_msg_flag = 'bmy_file' #FUN-AA0035 add
        
        FOR l_j = 1 TO l_cnt2
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmy_file")   #目前單身的 XML 節點
        
            LET g_bmy.bmy01   = g_bmx.bmx01
            CALL aws_ttsrv_setRecordField(l_node2, "bmy01", g_bmy.bmy01)      #寫入自動編號產生的ECN單號  

            #==>取得此筆單身資料的欄位值
            LET g_bmy.bmy02   = aws_ttsrv_getRecordField(l_node2,"bmy02")     
            LET g_bmy.bmy03   = aws_ttsrv_getRecordField(l_node2,"bmy03")     
            LET g_bmy.bmy04   = aws_ttsrv_getRecordField(l_node2,"bmy04")     
            LET g_bmy.bmy05   = aws_ttsrv_getRecordField(l_node2,"bmy05")     
            LET g_bmy.bmy06   = aws_ttsrv_getRecordField(l_node2,"bmy06")     
            LET g_bmy.bmy07   = aws_ttsrv_getRecordField(l_node2,"bmy07")     
            LET g_bmy.bmy08   = aws_ttsrv_getRecordField(l_node2,"bmy08")     
            LET g_bmy.bmy09   = aws_ttsrv_getRecordField(l_node2,"bmy09")     
            LET g_bmy.bmy10   = aws_ttsrv_getRecordField(l_node2,"bmy10")     
            LET g_bmy.bmy10_fac = aws_ttsrv_getRecordField(l_node2,"bmy10_fac")     
            LET g_bmy.bmy10_fac2= aws_ttsrv_getRecordField(l_node2,"bmy10_fac2")     
            LET g_bmy.bmy11   = aws_ttsrv_getRecordField(l_node2,"bmy11")     
            LET g_bmy.bmy13   = aws_ttsrv_getRecordField(l_node2,"bmy13")     
            LET g_bmy.bmy14   = aws_ttsrv_getRecordField(l_node2,"bmy14")     
            LET g_bmy.bmy15   = aws_ttsrv_getRecordField(l_node2,"bmy15")     
            LET g_bmy.bmy16   = aws_ttsrv_getRecordField(l_node2,"bmy16")     
            LET g_bmy.bmy17   = aws_ttsrv_getRecordField(l_node2,"bmy17")     
            LET g_bmy.bmy171  = aws_ttsrv_getRecordField(l_node2,"bmy171")     
            LET g_bmy.bmy18   = aws_ttsrv_getRecordField(l_node2,"bmy18")     
            LET g_bmy.bmy19   = aws_ttsrv_getRecordField(l_node2,"bmy19")     
            LET g_bmy.bmy20   = aws_ttsrv_getRecordField(l_node2,"bmy20")     
            LET g_bmy.bmy21   = aws_ttsrv_getRecordField(l_node2,"bmy21")     
            LET g_bmy.bmy22   = aws_ttsrv_getRecordField(l_node2,"bmy22")     
            LET g_bmy.bmy23   = aws_ttsrv_getRecordField(l_node2,"bmy23")     
            LET g_bmy.bmy25   = aws_ttsrv_getRecordField(l_node2,"bmy25")     
            LET g_bmy.bmy26   = aws_ttsrv_getRecordField(l_node2,"bmy26")     
            LET g_bmy.bmy27   = aws_ttsrv_getRecordField(l_node2,"bmy27")     
            LET g_bmy.bmy29   = aws_ttsrv_getRecordField(l_node2,"bmy29")     
            LET g_bmy.bmy30   = aws_ttsrv_getRecordField(l_node2,"bmy30")     
            LET g_bmy.bmy33   = aws_ttsrv_getRecordField(l_node2,"bmy33")     
            LET g_bmy.bmy34   = aws_ttsrv_getRecordField(l_node2,"bmy34")     
            #----------------------------------
            IF cl_null(g_bmy.bmy29) THEN LET g_bmy.bmy29 = ' ' END IF

            #==>單身預設值及欄位判斷
            IF NOT aws_create_ecn_data_default_b1() THEN         
               EXIT FOR
            END IF
            LET g_bmy.bmy01   = g_bmx.bmx01     
            #------------------------------------------------------------------#
            # RECORD資料傳到NODE                                               #
            #------------------------------------------------------------------#
            CALL aws_ttsrv_setRecordField_record(l_node2,base.Typeinfo.create(g_bmy))

            IF cl_null(g_bmy.bmy29) THEN        # KEY 不可空白
                LET g_bmy.bmy29 = ' '
                CALL aws_ttsrv_setRecordField(l_node2, "bmy29",g_bmy.bmy29)
            END IF
            IF cl_null(g_bmy.bmy33) THEN        # KEY 不可空白
                LET g_bmy.bmy33 = '0'
                CALL aws_ttsrv_setRecordField(l_node2, "bmy33",g_bmy.bmy33)
            END IF
        
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "bmy_file", "I", NULL)   #I 表示取得 INSERT SQL
            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOR
        #FUN-AA0035---add-----str---
        IF g_status.code <> '0' THEN
            EXIT FOR
        END IF
        #FUN-AA0035---add-----end---
        #----------------------------------------------------------------------#
        # 處理第二單身插件位置資料(bmw_file)                                   #
        #----------------------------------------------------------------------#
        LET g_msg_flag = 'bmw_file' #FUN-AA0035 add
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "bmw_file")       #取得目前單頭共有幾筆單身資料
        
        FOR l_j = 1 TO l_cnt2
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j, "bmw_file")   #目前單身的 XML 節點
        
            IF NOT aws_create_ecn_data_default_b2(l_node2) THEN   #檢查 BOM 單身欄位預設值           
               EXIT FOR
            END IF
 
            #-------------------------------------------------------------------#
            # RECORD資料傳到NODE                                                #
            #-------------------------------------------------------------------#
            
            LET g_bmw.bmw01 = g_bmx.bmx01
            LET g_bmw.bmwplant = g_plant #FUN-AC0060 add
            LET g_bmw.bmwlegal = g_legal #FUN-AC0060 add
            CALL aws_ttsrv_setRecordField(l_node2, "bmw01",g_bmw.bmw01)
            CALL aws_ttsrv_setRecordField(l_node2, "bmwplant",g_bmw.bmwplant) #FUN-AC0060 add
            CALL aws_ttsrv_setRecordField(l_node2, "bmwlegal",g_bmw.bmwlegal) #FUN-AC0060 add

 
            LET l_sql = aws_ttsrv_getRecordSql(l_node2, "bmw_file", "I", NULL)   #I 表示取得 INSERT SQL

            #------------------------------------------------------------------#
            # 執行單身 INSERT SQL                                              #
            #------------------------------------------------------------------#
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
               EXIT FOR
            END IF
        END FOR
        IF g_status.code != "0" THEN   #如果單身處理有任何錯誤, 則離開
           EXIT FOR
        END IF
    END FOR
    #全部處理都成功才 COMMIT WORK
    IF g_status.code = "0" THEN
       #FUN-AC0060--mark---str---
       #IF l_status = 'Y' THEN #執行確認段否
       #    LET l_cmd="abmi720 '",g_bmx.bmx01,"' 'aws_create_ecn_data' "
       #    CALL cl_cmdrun(l_cmd)
       #END IF
       #CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的單一主件工程變異單單號
       #COMMIT WORK
       #FUN-AC0060--mark---end---
       #FUN-AC0060---add----str---
        IF l_status = 'Y' THEN #執行確認段否
            CALL i720sub_y_chk(g_bmx.bmx01)   
            IF g_success = "Y" THEN
                CALL i720sub_y_upd(g_bmx.bmx01,'Y')
            END IF
            IF g_err_msg.getLength() <> 0 THEN
                LET g_status.code = 'aws-607'
                CALL cl_get_err_msg() RETURNING l_msg
                LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
                LET g_status.description = g_status.description,"==>",l_msg
               #LET channel = base.Channel.create() 
               #CALL channel.setDelimiter(NULL) 
               #CALL channel.openFile("create_ecn.log", "a") 
               #CALL channel.setDelimiter("") 
               #CALL channel.write(g_status.description) 
               #CALL channel.write("") 
               #CALL channel.close()
                ROLLBACK WORK
            ELSE
                CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(l_return))   #回傳 ERP 建立的單一主件工程變異單單號
                COMMIT WORK
            END IF
        END IF
       #FUN-AC0060---add----end---
    ELSE
        #FUN-AA0035--add----str---
        LET g_status.description = cl_getmsg(g_status.code, g_lang)   #取得error code
        CASE g_msg_flag
             WHEN 'bmx_file' 
                   LET g_msg = cl_mut_get_feldname('bmx01',g_bmx.bmx01,
                                                   'bmx02',g_bmx.bmx02,
                                                   'bmx07',g_bmx.bmx07,
                                                   'bmx10',g_bmx.bmx10,
                                                   '','',
                                                   '','')
             WHEN 'bmy_file'
                   LET g_msg = cl_mut_get_feldname('bmy02',g_bmy.bmy02,
                                                   'bmy03',g_bmy.bmy03,
                                                   'bmy05',g_bmy.bmy05,
                                                   '','',
                                                   '','',
                                                   '','')
             WHEN 'bmt_file'
                   LET g_msg = cl_mut_get_feldname('bmw02',g_bmw.bmw02,
                                                   'bmw03',g_bmw.bmw03,
                                                   '','',
                                                   '','',
                                                   '','',
                                                   '','')
             OTHERWISE EXIT CASE
        END CASE
        LET g_status.description = g_msg CLIPPED,"==>",g_status.description
        #FUN-AA0035--add----end---
        ROLLBACK WORK
    END IF
    #FUN-AC0060---add----str---
    CALL s_dc_drop_temp_table(g_dc_tabname)
    CALL s_dc_drop_temp_table(g_dc_hist_tab)
    #FUN-AC0060---add----end---
END FUNCTION


#[
# Description....: 單一主件工程變異單(ECN)設定欄位預設值--單頭
# Date & Author..: 2010/08/02 by Mandy
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_ecn_data_default()
  DEFINE l_flag     LIKE type_file.chr1  
  DEFINE l_cnt      LIKE type_file.num10
  DEFINE l_genacti  LIKE gen_file.genacti #TQC-AA0004 add
  DEFINE l_zx03     LIKE zx_file.zx03     #TQC-AA0004 add
  DEFINE l_zxacti   LIKE zx_file.zxacti   #TQC-AA0004 add

        #單據一律是新增
        #----------------------------------------------------------------------#
        # 單一主件工程變異單自動取號                                                       #
        #----------------------------------------------------------------------#       
        CALL s_check_no("abm",g_bmx.bmx01,"","1","bmx_file","bmx01","") 
             RETURNING l_flag,g_bmx.bmx01
        IF NOT l_flag THEN
            LET g_status.code = "aws-383"   #ECN單別不正確!
            RETURN FALSE
        END IF
        CALL s_auto_assign_no("abm",g_bmx.bmx01,g_bmx.bmx02,"1","bmx_file","bmx01","","","")
             RETURNING l_flag, g_bmx.bmx01
        IF NOT l_flag THEN
            LET g_status.code = "aws-384"   #ECN單號自動取號失敗!
            RETURN FALSE
        END IF
        IF NOT cl_null(g_bmx.bmx05) THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM bmr_file
                WHERE bmr01   = g_bmx.bmx05
                  AND bmrconf = 'Y'   
            IF l_cnt=0 THEN
                LET g_status.code = "aws-382" #ECR單號不正確!
                RETURN FALSE
            END IF
        END IF
        #TQC-AA0004--add---str---
        IF NOT cl_null(g_bmx.bmx10) THEN
            LET g_errno = ' '
            SELECT genacti INTO l_genacti
              FROM gen_file
             WHERE gen01 = g_bmx.bmx10
            CASE
               WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                        LET l_genacti = NULL
               WHEN l_genacti = 'N'  LET g_errno = '9028'
               OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF NOT cl_null(g_errno) THEN
               #FUN-AB0038---mod---str
               #LET g_status.code = g_errno
               #RETURN FALSE
                LET g_errno = NULL
                LET g_bmx.bmx10   = g_user
               #FUN-AB0038---mod---end
            END IF
        END IF
        #TQC-AA0004--add---end---
        IF cl_null(g_bmx.bmx02)   THEN LET g_bmx.bmx02   = TODAY    END IF
        IF cl_null(g_bmx.bmx07)   THEN LET g_bmx.bmx07   = TODAY    END IF
        IF cl_null(g_bmx.bmx04)   THEN LET g_bmx.bmx04   = 'N'      END IF
        IF cl_null(g_bmx.bmx06)   THEN LET g_bmx.bmx06   = '2'      END IF
        IF cl_null(g_bmx.bmx09)   THEN LET g_bmx.bmx09   = '0'      END IF
        IF cl_null(g_bmx.bmx10)   THEN LET g_bmx.bmx10   = g_user   END IF                          
       #TQC-AA0004--mod---str---
       #IF cl_null(g_bmx.bmx11)   THEN LET g_bmx.bmx11   = g_plant  END IF 
        LET g_bmx.bmx11 = g_plant
       #TQC-AA0004--mod---end---

       #TQC-AA0004--mod---str---
       #IF cl_null(g_bmx.bmxuser) THEN LET g_bmx.bmxuser = g_user   END IF
       #IF cl_null(g_bmx.bmxgrup) THEN LET g_bmx.bmxgrup = g_grup   END IF
        IF cl_null(g_bmx.bmxuser) THEN 
            LET g_bmx.bmxuser = g_user   
            LET g_bmx.bmxgrup = g_grup
        ELSE
            SELECT zx03,zxacti INTO l_zx03,l_zxacti
              FROM zx_file
             WHERE zx01 = g_bmx.bmxuser
            CASE
               WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aws-398' #個人帳號設定不存在使用者基本資料(p_zx)中!
                                        LET l_zxacti = NULL
               WHEN l_zxacti = 'N'      LET g_errno = 'aws-399' #個人帳號設定在使用者基本資料(p_zx)中已無效!
               OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
            END CASE
            IF cl_null(g_errno) THEN
                LET g_bmx.bmxgrup = l_zx03  
            ELSE
                LET g_bmx.bmxuser = g_user   
               #LET g_bmx.bmxuser = g_grup  #FUN-B50179 mark
                LET g_bmx.bmxgrup = g_grup  #FUN-B50179 add
            END IF
        END IF
       #TQC-AA0004--mod---end---
        IF cl_null(g_bmx.bmxdate) THEN LET g_bmx.bmxdate = g_today  END IF
        IF cl_null(g_bmx.bmxacti) THEN LET g_bmx.bmxacti = 'Y'      END IF
        #FUN-AC0060--add---str--
        LET g_bmx.bmxplant = g_plant 
        LET g_bmx.bmxlegal = g_legal
        LET g_bmx.bmxoriu = g_user 
        LET g_bmx.bmxorig = g_grup 
        #FUN-AC0060--add---str--
        SELECT gen03 INTO g_bmx.bmx13 #申請部門
          FROM gen_file
         WHERE gen01 = g_bmx.bmx10
        #FUN-AC0060--add---end--
        LET g_bmx.bmx50 = '1'
        #FUN-AC0060--add---end--
        RETURN TRUE
END FUNCTION                                                      

#[
# Description....: 單一主件工程變異單(ECN)設定欄位預設值--單身
# Date & Author..: 2010/08/02 by Mandy
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_ecn_data_default_b1()
  DEFINE l_cnt         LIKE type_file.num10
  DEFINE l_item        LIKE ima_file.ima01
  DEFINE l_sw          LIKE type_file.chr1
  DEFINE l_bmy10_fac   LIKE bmy_file.bmy10_fac
  DEFINE l_bmy10_fac2  LIKE bmy_file.bmy10_fac2
  DEFINE l_bmb         RECORD LIKE bmb_file.*
  DEFINE l_ima         RECORD LIKE ima_file.*

        INITIALIZE l_bmb.* TO NULL      
        INITIALIZE l_ima.* TO NULL      

        #=>項次(bmy02)
        IF cl_null(g_bmy.bmy02) OR g_bmy.bmy02 = 0 THEN
            SELECT max(bmy02)+1 INTO g_bmy.bmy02
               FROM bmy_file WHERE bmy01 = g_bmx.bmx01
            IF cl_null(g_bmy.bmy02) THEN
                LET g_bmy.bmy02 = 1
            END IF
        END IF

        #=>變異別(bmy03)
        IF g_bmy.bmy03 NOT MATCHES '[12345]'THEN  
            LET g_status.code = "aws-385"   #變異別不正確!
            RETURN FALSE
        END IF

        #=>組成用量(bmy06)
        IF NOT cl_null(g_bmy.bmy06) THEN
           IF g_bmy.bmy06 <= 0 THEN
               LET g_status.code = "mfg2614"   #組成用量不可小於零
               RETURN FALSE
           END IF
        END IF

        #=>底數(bmy07)
        IF NOT cl_null(g_bmy.bmy07) THEN
           IF g_bmy.bmy07 <= 0 THEN
               LET g_status.code = "mfg2615"   #主件底數不可小於等於零
               RETURN FALSE
           END IF
        END IF

        #=>主件編號(bmy14)
        IF NOT cl_null(g_bmy.bmy14) THEN
            IF NOT cl_null(g_bmy.bmy05) THEN #元件編號
                IF g_bmy.bmy03 MATCHES '[1345]' THEN #變異碼
                    LET l_cnt = 0
                    IF NOT cl_null(g_bmy.bmy04) THEN #產品結構項次
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb02 = g_bmy.bmy04
                           AND bmb03 = g_bmy.bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    ELSE
                        SELECT COUNT(*) INTO l_cnt FROM bmb_file
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb03 = g_bmy.bmy05
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    END IF
                    IF  l_cnt = 0 THEN
                         LET g_status.code = "mfg2631"   #產品結構單身檔無此元件編號
                         RETURN FALSE
                    END IF
                END IF
            END IF
            CALL aws_ima01_chk(g_bmy.bmy14,'3')
            IF NOT cl_null(g_errno) THEN
                LET g_status.code = g_errno  
                RETURN FALSE
            ELSE
                SELECT ima05 INTO g_bmy.bmy171 FROM ima_file
                 WHERE ima01 = g_bmy.bmy14
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM bma_file
             WHERE bma01 = g_bmy.bmy14
               AND (bma05 IS NULL OR bma05 >g_bmx.bmx07)
               AND bma06 = g_bmy.bmy29
            IF l_cnt> 0 THEN
                LET g_status.code = "abm-005" #有效日期不可小於發放日期,或此BOM的發放日期為空白,請查核..!
                RETURN FALSE
            END IF
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM bma_file
               WHERE bma01=g_bmy.bmy14 
                 AND bmaacti='Y'
                 AND bma06=g_bmy.bmy29
            IF l_cnt =0 THEN
                LET g_status.code = "abm-742" #無此產品結構資料!
                RETURN FALSE
            END IF
            IF g_bmy.bmy03 = '2' THEN #變異碼:2: 新元件新增生效
                IF NOT cl_null(g_bmy.bmy04) THEN #產品結構項次
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb02 = g_bmy.bmy04
                       AND bmb29 = g_bmy.bmy29       
                       AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                       AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    IF l_cnt> 0 THEN
                        LET g_status.code = "mfg-015" #該主件料號+項次已存在產品結構中, 請重新輸入!
                        RETURN FALSE
                    END IF
                 END IF
            END IF
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM bma_file
             WHERE bma01  = g_bmy.bmy14
            IF l_cnt = 0 THEN
                LET g_status.code = "abm-748" #欲更新的資料主件不存在產品結構主檔的bma_file中
                RETURN FALSE
            END IF
        END IF

        #=>元件編號(bmy05)
        IF NOT cl_null(g_bmy.bmy05) THEN
            #FUN-AB0038--add---str--
            CALL aws_ima01_chk(g_bmy.bmy05,'1')
            IF NOT cl_null(g_errno) THEN
                LET g_status.code = g_errno  
                RETURN FALSE
            END IF
            #FUN-AB0038--add---end--
            IF g_bmy.bmy03 != '1' THEN
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt
                 FROM ima_file
                WHERE ima01=g_bmy.bmy05
                  AND (ima140='N'
                  OR (ima140='Y' AND ima1401 > g_bmx.bmx07))  
               IF l_cnt = 0 THEN
                   LET g_status.code = "aim-809" #料件已Phase Out!
                   RETURN FALSE
               END IF
               IF g_bmy.bmy05 = g_bmy.bmy14 THEN 
                   LET g_status.code = "mfg2633" #元件料號不可與主件料號相同
                   RETURN FALSE
               END IF
            END IF
            IF g_bmy.bmy03 MATCHES '[13]'  THEN 
                 SELECT bmb31 INTO l_bmb.bmb31 FROM bmb_file
                    WHERE bmb01 = g_bmy.bmy14
                      AND bmb03 = g_bmy.bmy05
                      AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                      AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                 IF cl_null(g_bmy.bmy34) THEN
                     LET g_bmy.bmy34 = l_bmb.bmb31
                 END IF
            END IF          
            IF g_bmy.bmy03 MATCHES '[245]' THEN  
                IF cl_null(g_bmy.bmy34) THEN
                    LET g_bmy.bmy34 = 'N'
                END IF
            END IF             
            IF g_bmy.bmy03 MATCHES '[1345]' THEN   
                LET l_cnt = 0
                IF NOT cl_null(g_bmy.bmy04) THEN
                    SELECT COUNT(*) INTO l_cnt FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb02 = g_bmy.bmy04
                       AND bmb03 = g_bmy.bmy05
                       AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                       AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                ELSE
                    SELECT COUNT(*) INTO l_cnt FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb03 = g_bmy.bmy05
                       AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                       AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                END IF
                IF  l_cnt = 0 THEN
                    LET g_status.code = "mfg2631" #產品結構單身檔無此元件編號
                    RETURN FALSE
                END IF
            END IF
            #Default 底數、組成用量
            IF g_bmy.bmy03 MATCHES '[1345]' THEN  
                IF g_bmy.bmy03 MATCHES '[134]' THEN
                    IF cl_null(g_bmy.bmy04) THEN
                        SELECT bmb06,bmb07,bmb16 INTO l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16 FROM bmb_file     
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb03 = g_bmy.bmy05
                           AND bmb04 = (SELECT MAX(bmb04) FROM bmb_file
                                         WHERE bmb01 = g_bmy.bmy14
                                           AND bmb03 = g_bmy.bmy05)
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    ELSE
                        SELECT bmb06,bmb07,bmb16 INTO l_bmb.bmb06,l_bmb.bmb07,l_bmb.bmb16 FROM bmb_file     
                         WHERE bmb01 = g_bmy.bmy14
                           AND bmb03 = g_bmy.bmy05
                           AND bmb02 = g_bmy.bmy04
                           AND (bmb04 <= g_bmx.bmx07 OR bmb04 IS NULL)
                           AND (bmb05 >  g_bmx.bmx07 OR bmb05 IS NULL)
                    END IF
                    IF cl_null(g_bmy.bmy06) THEN
                        LET g_bmy.bmy06 = l_bmb.bmb06
                    END IF
                    IF cl_null(g_bmy.bmy07) THEN 
                        LET g_bmy.bmy07 = l_bmb.bmb07
                    END IF
                    IF g_bmy.bmy03 MATCHES '[13]' THEN  
                        IF cl_null(g_bmy.bmy16) THEN
                            LET g_bmy.bmy16 = l_bmb.bmb16   
                        END IF
                    END IF   #CHI-960004
                ELSE
                    IF cl_null(g_bmy.bmy06) THEN
                        LET g_bmy.bmy06 = 1
                    END IF
                    IF cl_null(g_bmy.bmy07) THEN
                        LET g_bmy.bmy07 = 1
                    END IF
                END IF
            ELSE
                IF cl_null(g_bmy.bmy06) THEN
                    LET g_bmy.bmy06 = 1
                END IF
            END IF
           #FUN-AB0038--mark--str--
           #此判斷挪至上面
           #CALL aws_ima01_chk(g_bmy.bmy05,'1')
           #IF NOT cl_null(g_errno) THEN
           #    LET g_status.code = g_errno  
           #    RETURN FALSE
           #END IF
           #FUN-AB0038--mark--end--
        END IF

        #=>替代特性(bmy16)
        IF g_bmy.bmy16 NOT MATCHES '[01245]' THEN
             LET g_status.code = "aws-386" #取替代特性不正確!
             RETURN FALSE
        END IF
        IF g_bmy.bmy03 MATCHES '[1123]' THEN
            IF cl_null(g_bmy.bmy16) THEN
                IF g_bmy.bmy03 = '2' THEN
                    LET g_bmy.bmy16 = '0'
                ELSE
                    SELECT bmb16 INTO g_bmy.bmy16
                      FROM bmb_file
                     WHERE bmb01 = g_bmy.bmy14
                       AND bmb02 = g_bmy.bmy04
                       AND bmb29 = g_bmy.bmy29
                       AND (bmb04 IS NULL OR bmb04<=g_bmx.bmx07)
                       AND (bmb05 IS NULL OR bmb05 >g_bmx.bmx07)
                END IF
            END IF
        END IF
        IF g_bmy.bmy03 = '5' THEN
           IF g_bmy.bmy16 NOT MATCHES '[25]' THEN 
              LET g_status.code = "abm-033" #當變異碼(bmy03)為"5:替代"時，取替(bmy16)一定要為"2:可被替代"或"5:可被set替代".
              RETURN FALSE
           END IF
        END IF

        #=>新料料號(bmy27)
        IF NOT cl_null(g_bmy.bmy27) THEN
            CALL aws_ima01_chk(g_bmy.bmy27,'4')
            IF NOT cl_null(g_errno) THEN
                LET g_status.code = g_errno  
                RETURN FALSE
            END IF
            IF g_bmy.bmy03 != '1' THEN
                LET l_cnt = 0 
                SELECT COUNT(*) INTO l_cnt
                  FROM ima_file
                 WHERE ima01 = g_bmy.bmy27
                   AND (ima140 = 'N'
                    OR (ima140 = 'Y' AND ima1401 > g_bmx.bmx07)) 
                IF l_cnt = 0 THEN
                    LET g_status.code = "aim-809" #料件已Phase Out!
                    RETURN FALSE
                END IF
                IF g_bmy.bmy05 = g_bmy.bmy14 THEN 
                    LET g_status.code = "mfg2633" #元件料號不可與主件料號相同
                    RETURN FALSE
                END IF
            END IF
            IF g_bmy.bmy03 = '5' THEN
                #檢查替代料是否一存在于bmd_file
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM bmd_file
                 WHERE bmd08 = g_bmy.bmy14
                   AND bmd01 = g_bmy.bmy05
                   AND bmd04 = g_bmy.bmy27
                   AND bmd02 = '2'
                IF l_cnt > 0 THEN
                    LET g_status.code = "abm-034" #此替代料關係已經存在
                    RETURN FALSE
                END IF
            END IF
        END IF
        IF g_bmy.bmy03 = '4' THEN
           IF cl_null(g_bmy.bmy27) THEN
               LET g_status.code = "aws-389" #變異碼為'4:取代'時,新料料號不可空白!
               RETURN FALSE
           END IF
           IF g_bmy.bmy05 = g_bmy.bmy27 THEN 
               LET g_status.code = "abm-619" #ECN變易方式選擇4.取代時，應控管變異元件料號不可與新元件料號相同!
               RETURN FALSE
           END IF              
        END IF

        #=>損耗率(bmy08)
        IF NOT cl_null(g_bmy.bmy08) THEN
            IF g_bmy.bmy08 < 0 OR g_bmy.bmy08 > 100 THEN
                LET g_status.code = "mfg4063" #本欄位之值不可小於零或大於 100, 請重新輸入
                RETURN FALSE
            END IF
        END IF

        #=>倉庫(bmy25)
        IF NOT cl_null(g_bmy.bmy25) THEN
            SELECT * FROM imd_file
             WHERE imd01 = g_bmy.bmy25
               AND imdacti = 'Y'
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "mfg1100" #無此倉庫或性質不符!
                RETURN FALSE
            END IF
        END IF

        #=>存放位置(bmy26)
        IF NOT cl_null(g_bmy.bmy25) AND g_bmy.bmy26 IS NOT NULL THEN
            SELECT * FROM ime_file
             WHERE ime01 = g_bmy.bmy25
               AND ime02 = g_bmy.bmy26
               AND imeacti = 'Y'       #FUN-D40103
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "asm-020" #無此倉庫+儲位資料
                RETURN FALSE
            END IF
        END IF

        #=>作業編號(bmy09)
        IF NOT cl_null(g_bmy.bmy09) THEN
            SELECT * FROM ecd_file
             WHERE ecd01 = g_bmy.bmy09
            IF SQLCA.SQLCODE THEN
                LET g_status.code = "aec-099" #無此作業編號
                RETURN FALSE
            END IF
        END IF

        #=>發料單位(bmy10)
        IF NOT cl_null(g_bmy.bmy10) THEN
            SELECT * FROM gfe_file
             WHERE gfe01 = g_bmy.bmy10
            IF STATUS THEN
                LET g_status.code = "afa-319" #此單位不存在請重新輸入
                RETURN FALSE
            END IF
            IF g_bmy.bmy03 = '4' THEN
               LET l_item = g_bmy.bmy27
            ELSE
               LET l_item = g_bmy.bmy05
            END IF
            INITIALIZE l_ima.* TO NULL      
            SELECT ima25,ima86 INTO l_ima.ima25,l_ima.ima86
              FROM ima_file
             WHERE ima01 = l_item 
           #IF NOT cl_null(g_bmy.bmy10) AND g_bmy.bmy10 <> l_ima.ima25 THEN #MOD-B50260 mark
            IF NOT cl_null(g_bmy.bmy10) THEN                                #MOD-B50260 add
                CALL s_umfchk(l_item,g_bmy.bmy10,l_ima.ima25)
                     RETURNING l_sw,l_bmy10_fac  #發料/庫存單位
                IF l_sw THEN
                    LET g_status.code = "mfg2721" #發料單位對庫存單位無轉換率
                    RETURN FALSE
                END IF
                #MOD-B50260---add----str---
                IF cl_null(g_bmy.bmy10_fac) THEN
                    LET g_bmy.bmy10_fac = l_bmy10_fac  
                END IF
                #MOD-B50260---add----end---
            END IF
           #IF NOT cl_null(g_bmy.bmy10) AND g_bmy.bmy10 <> l_ima.ima86 THEN #MOD-B50260 mark
            IF NOT cl_null(g_bmy.bmy10) THEN                                #MOD-B50260 add
                CALL s_umfchk(l_item,g_bmy.bmy10,l_ima.ima86)
                     RETURNING l_sw,l_bmy10_fac2  
                IF l_sw THEN
                    LET g_status.code = "mfg2722" #發料單位對成本單位無轉換率
                    RETURN FALSE
                END IF
                #MOD-B50260---add----str---
                IF cl_null(g_bmy.bmy10_fac2) THEN
                    LET g_bmy.bmy10_fac2 = l_bmy10_fac2  
                END IF
                #MOD-B50260---add----end---
            END IF
        END IF

        #工單開立展開選項(bmy20)
        IF NOT cl_null(g_bmy.bmy20) THEN
            IF g_bmy.bmy20 NOT MATCHES '[1234]' THEN
                LET g_status.code = "aws-390" #工單開立選項不正確!
                RETURN FALSE
            END IF
        END IF

        #=>新原件明細
        INITIALIZE l_ima.* TO NULL      
        IF g_bmy.bmy03 = '4' THEN #取代
           SELECT ima25,ima86,ima110 INTO l_ima.ima25,l_ima.ima86,l_ima.ima110 FROM ima_file
            WHERE ima01=g_bmy.bmy27
        ELSE
           SELECT ima25,ima86,ima110 INTO l_ima.ima25,l_ima.ima86,l_ima.ima110 FROM ima_file
            WHERE ima01=g_bmy.bmy05
        END IF
        IF g_bmy.bmy03 = '4' THEN
           LET l_item = g_bmy.bmy27
        ELSE
           LET l_item = g_bmy.bmy05
        END IF
        IF g_bmy.bmy03 MATCHES '[2345]' AND cl_null(g_bmy.bmy10) THEN  
            INITIALIZE l_bmb.* TO NULL      
            IF NOT cl_null(g_bmy.bmy04) THEN
                SELECT * INTO l_bmb.* FROM bmb_file
                 WHERE bmb01 = g_bmy.bmy14
                   AND bmb02 = g_bmy.bmy04
            ELSE
                SELECT * INTO l_bmb.* FROM bmb_file
                 WHERE bmb01 = g_bmy.bmy14
                   AND bmb03 = g_bmy.bmy05
                   AND bmb29 = g_bmy.bmy29
                   AND (bmb05 > g_bmx.bmx07 OR bmb05 IS NULL)
            END IF
            IF cl_null(g_bmy.bmy18) THEN #投料時距
                IF NOT cl_null(l_bmb.bmb18) THEN
                    LET g_bmy.bmy18 = l_bmb.bmb18 
                ELSE
                    LET g_bmy.bmy18 = 0
                END IF
            END IF
            IF cl_null(g_bmy.bmy08) THEN #損耗率
                IF NOT cl_null(l_bmb.bmb08) THEN
                    LET g_bmy.bmy08 = l_bmb.bmb08
                ELSE
                    LET g_bmy.bmy08 = 0
                END IF
            END IF
            IF cl_null(g_bmy.bmy09) THEN #作業編號
                IF NOT cl_null(l_bmb.bmb09) THEN
                    LET g_bmy.bmy09 = l_bmb.bmb09
                ELSE
                    LET g_bmy.bmy09 = ''
                END IF
            END IF
            INITIALIZE l_ima.* TO NULL      
            SELECT ima63,ima63_fac,ima25,ima86                          #MOD-B50260 add ima86
              INTO l_ima.ima63,l_ima.ima63_fac,l_ima.ima25,l_ima.ima86  #MOD-B50260 add ima86
              FROM ima_file 
             WHERE ima01 = l_item
            IF cl_null(g_bmy.bmy10) THEN 
                LET g_bmy.bmy10 = l_ima.ima63
            END IF
            CALL s_umfchk(l_item,g_bmy.bmy10,l_ima.ima25)
                  RETURNING l_sw,l_ima.ima63_fac  #發料/庫存單位
            IF l_sw THEN 
                LET l_ima.ima63_fac = 1 
            END IF
            IF cl_null(g_bmy.bmy10_fac) THEN 
                LET g_bmy.bmy10_fac = l_ima.ima63_fac
            END IF
           #MOD-B50260 add str-----------------------------
            CALL s_umfchk(l_item,g_bmy.bmy10,l_ima.ima86)
                  RETURNING l_sw,l_bmy10_fac2  #發料/成本單位
            IF l_sw THEN
                LET l_bmy10_fac2 = 1
            END IF
            IF cl_null(g_bmy.bmy10_fac2) THEN
                LET g_bmy.bmy10_fac = l_bmy10_fac2
            END IF
           #MOD-B50260 add end-----------------------------
            IF cl_null(g_bmy.bmy20) THEN 
                LET g_bmy.bmy20 = l_bmb.bmb19
            END IF
        END IF 
        IF g_bmy.bmy03 MATCHES '[245]' THEN       #CHI-960004 add 5
           INITIALIZE l_ima.* TO NULL      
           SELECT ima04,ima136,ima137,ima70,ima562
             INTO l_ima.ima04,l_ima.ima136,l_ima.ima137,l_ima.ima70,l_ima.ima562
             FROM ima_file 
            WHERE ima01=l_item
           IF cl_null(g_bmy.bmy11) THEN
               LET g_bmy.bmy11 = l_ima.ima04 
           END IF
           IF cl_null(g_bmy.bmy25) THEN
               LET g_bmy.bmy25 = l_ima.ima136    
           END IF
           #No.FUN-AB0058  --Begin
           IF NOT cl_null(g_bmy.bmy25) THEN
              IF NOT s_chk_ware(g_bmy.bmy25) THEN  #检查仓库是否属于当前门店
                  LET g_bmy.bmy25 = ''
              END IF
           END IF
           #No.FUN-AB0058  --End 
           IF cl_null(g_bmy.bmy26) THEN
               LET g_bmy.bmy26 = l_ima.ima137  
           END IF
           IF cl_null(g_bmy.bmy21) THEN
               LET g_bmy.bmy21 = l_ima.ima70    
               IF cl_null(g_bmy.bmy21) THEN #元件消耗特性
                   LET g_bmy.bmy21 = 'N'  
               END IF
           END IF
           IF cl_null(g_bmy.bmy23) THEN 
               LET g_bmy.bmy23 = 0 
           END IF 
        END IF 
        LET g_bmy.bmyplant = g_plant #FUN-AC0060 add
        LET g_bmy.bmylegal = g_legal #FUN-AC0060 add
        RETURN TRUE
END FUNCTION                                                      

FUNCTION aws_ima01_chk(p_ima01,p_type)
   DEFINE  p_ima01   LIKE ima_file.ima01
   DEFINE  p_type    LIKE type_file.chr1 #'1':檢核bmy05元件 ,'3':檢核bmy14主件,'4':檢核bmy27新料
   DEFINE  l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT imaacti
      INTO l_imaacti
      FROM ima_file 
     WHERE ima01 = p_ima01
    IF SQLCA.SQLCODE = 100 THEN
        CASE p_type
              WHEN '1' 
                  LET g_errno = 'aws-194' #元件編號不存在料件主檔(ima_file)中!
              WHEN '3' 
                  LET g_errno = 'aws-196' #主件編號不存在料件主檔(ima_file)中!
              WHEN '4' 
                  LET g_errno = 'aws-387' #新料料號不存在料件主檔(ima_file)中!
        END CASE
        RETURN 
    END IF
    IF SQLCA.SQLCODE THEN
        LET g_errno = SQLCA.SQLCODE USING '-------'
        RETURN 
    END IF
    IF l_imaacti <>'Y' THEN LET g_errno = '9029'
        CASE p_type
              WHEN '1' 
                  LET g_errno = 'aws-197' #元件編號資料尚未確認,不可使用!
              WHEN '3' 
                  LET g_errno = 'aws-199' #主件編號資料尚未確認,不可使用!
              WHEN '4' 
                  LET g_errno = 'aws-388' #新料料號資料尚未確認,不可使用!
        END CASE
        RETURN 
    END IF
    LET g_errno = SQLCA.SQLCODE USING '-------'
END FUNCTION

#[
# Description.....  ECN 第二單身(bmw_file)欄位預設值
# Parameter......: p_node   - om.DomNode - ECN第二單身 XML 節點 
#
#]
FUNCTION aws_create_ecn_data_default_b2(p_node)
    DEFINE p_node      om.DomNode
  

    LET g_bmw.bmw02 = aws_ttsrv_getRecordField(p_node,"bmw02")    
    LET g_bmw.bmw03 = aws_ttsrv_getRecordField(p_node,"bmw03")    

    IF cl_null(g_bmw.bmw02) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    IF cl_null(g_bmw.bmw03) THEN 
        LET g_status.code = "mfg6138" #重要欄位不可空白
        RETURN FALSE
    END IF
    RETURN TRUE
END FUNCTION
#FUN-D10092
