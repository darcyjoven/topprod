# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_sales_statistics_data.4gl
# Descriptions...: 提供取得 ERP 銷售統計資料服務
# Date & Author..: 2007/06/25 by Mandy
# Memo...........:
# Modify.........: 新建立 FUN-760069
# Modify.........: No.FUN-840004 08/06/17 By Echo 新架構的 Services 與舊架構必須進行區別，
#                                                 因此需調整舊 Services 的程式名稱
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
#FUN-760069 #FUN-840004
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此
 
DEFINE g_table     STRING
 
#[
# Description....: 提供取得 ERP 銷售統計資料服務(入口 function)
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getSalesStatisticsData_g()
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_initial()   # 服務初始化動作
 
    #--------------------------------------------------------------------------#
    # 檢查登入資訊                                                             #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_checkSignIn(g_getSalesStatisticsData_in.signIn) THEN    
       LET g_status.code = "aws-100"   #登入檢查錯誤
    END IF
    
    #--------------------------------------------------------------------------#
    # 取得ERP銷售統計資料
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_getSalesStatisticsData_get()
    END IF
    
    LET g_getSalesStatisticsData_out.status = aws_ttsrv_getStatus()
 
END FUNCTION
 
 
#[
# Description....: 取得ERP銷售統計資料
# Date & Author..: 2007/06/25 by Mandy
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_getSalesStatisticsData_get()
    DEFINE l_fld       RECORD 
              fld01   LIKE type_file.num5,       #期別(1~12)
              fld02   LikE type_file.num20_6,    #實際銷售值
              fld03   LIKE type_file.num20_6,    #預算值
              fld04   LIkE type_file.num20_6,    #差異比率 
              fld05   LIKE type_file.num20_6     #累計達成率
           END RECORD 
    DEFINE l_node      om.DomNode
    DEFINE l_sql       STRING
    DEFINE l_a         LIKE type_file.num20_6    #出貨金額
    DEFINE l_b         LIKE type_file.num20_6    #退貨金額
    DEFINE l_year      LIKE type_file.num5       #參數現行年
    DEFINE l_month     LIKE type_file.num5       #月份(1~12)
    DEFINE l_max_bgm01 LIKE bgm_file.bgm01       #當年度最大的版本
    DEFINE l_amount    ARRAY[20] of RECORD
              budget   LIKE type_file.num20_6    #當月預算值
           END RECORD 
    DEFINE l_tot       LIKE type_file.num20_6    #1~12月總預算
    DEFINE l_accm      LIKE type_file.num20_6    #1月累計至當月的實際銷售值
 
    LET g_table = "ogb_file"
 
    #--------------------------------------------------------------------------#
    # 填充服務所使用 TABLE, 其欄位名稱及相對應他系統欄位名稱                   #
    #--------------------------------------------------------------------------#
    IF NOT aws_ttsrv_getServiceColumn(g_service) THEN
       LET g_status.code = "aws-102"   #讀取服務設定錯誤
       RETURN
    END IF
 
    #--------------------------------------------------------------------------#
    #依據資料條件(year),抓取銷售統計資料                                      #
    #--------------------------------------------------------------------------#
    LET l_year = g_getSalesStatisticsData_in.year
    #當年度銷貨預算最大版本
    SELECT MAX(bgm01) INTO l_max_bgm01
      FROM bgm_file
     WHERE bgm02 = l_year
    LET l_tot = 0
    FOR l_month = 1 TO 12
        #預算值#---------------------------------------------------#
        SELECT SUM((bgm04 * bgm05) * bga05 ) #單價*數量*匯率
          INTO l_amount[l_month].budget
          FROM bgm_file,bga_file
         WHERE bgm01 = l_max_bgm01           #版本抓當年度最大的版本 
           AND bgm02 = l_year                #系統參數現行年度
           AND bgm03 = l_month               #期別
           AND bga01 = bgm01                 #版本
           AND bga02 = bgm02                 #年度
           AND bga03 = bgm03                 #期別
           AND bga04 = bgm016                #幣別
        IF cl_null(l_amount[l_month].budget) THEN 
            LET l_amount[l_month].budget = 0
        END IF
        LET l_amount[l_month].budget = (l_amount[l_month].budget/1000)
        LET l_tot = l_tot + l_amount[l_month].budget
    END FOR
 
    LET l_accm = 0
    FOR l_month = 1 TO 12 
        INITIALIZE l_fld.* TO NULL
        LET l_a = 0
        LET l_b = 0
        LET l_fld.fld01 = l_month
        #實際銷售值#---------------------------------------------------#
          #A:出貨
            SELECT (ogb14*oga24)             #原幣未稅金額ogb14 * 匯率oga24
              INTO l_a
              FROM oga_file,ogb_file
             WHERE oga01=ogb01
               AND oga09 IN ('2','3','4')
               AND YEAR(oga02)  = l_year
               AND MONTH(oga02) = l_month
               AND ogapost      = 'Y'
               AND ogaconf      = 'Y'
          #B:退貨
            SELECT (ohb14*oha24)            #原幣未稅金額ogb14 * 匯率oga24
              INTO l_b
              FROM oha_file,ohb_file
             WHERE oha01=ohb01
               AND YEAR(oha02)  = l_year
               AND MONTH(oha02) = l_month
               AND ohapost      = 'Y'
               AND ohaconf      = 'Y'
 
        #實際銷售值 = (A:出貨 - B:退貨)/1000    #單位:仟元
        IF cl_null(l_a) THEN LET l_a = 0 END IF
        IF cl_null(l_b) THEN LET l_b = 0 END IF
        LET l_fld.fld02 = (l_a - l_b)/1000
        IF cl_null(l_fld.fld02) THEN LET l_fld.fld02 = 0 END IF
 
        #預算值#---------------------------------------------------#
        LET l_fld.fld03 = l_amount[l_month].budget/1000  #單位:仟元
        IF cl_null(l_fld.fld03) THEN LET l_fld.fld03 = 0 END IF
 
        #差異比率#---------------------------------------------------#
        #差異比率=當月實際銷售值 - 當月預算值
        LET l_fld.fld04 = l_fld.fld02 - l_fld.fld03
        IF cl_null(l_fld.fld04) THEN LET l_fld.fld04 = 0 END IF
 
        #累計達成率#---------------------------------------------------#
        #累計達成率 =>(1月至當月的實際銷售值加總/1~12月全年度預算加總)*100%
        LET l_accm = l_accm + l_fld.fld02
        LET l_fld.fld05 = (l_accm /l_tot) * 100
        IF cl_null(l_fld.fld05) THEN LET l_fld.fld05 = 0 END IF
 
        #------------------------------------------------------------------#
        # 解析 RecordSet, 回傳於 Table 欄位                                #
        #------------------------------------------------------------------#
        LET l_node = aws_ttsrv_setDataSetRecord(base.TypeInfo.create(l_fld), l_node, g_table)
        
    END FOR
 
    #--------------------------------------------------------------------------#
    # Response Xml 文件改成字串                                                #
    #--------------------------------------------------------------------------#
    LET g_getSalesStatisticsData_out.recd = aws_ttsrv_xmlToString(l_node)
END FUNCTION
