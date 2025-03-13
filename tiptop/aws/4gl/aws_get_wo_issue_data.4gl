# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_get_wo_issue_data.4gl
# Descriptions...: 提供取得 ERP 領料單相關資料
# Date & Author..: 2008/05/14 by kim (FUN-840012)
# Memo...........:
# Modify.........:
#
#}
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
           
 
#[
# Description....: 提供取得 ERP 領料單相關資料(入口 function)
# Date & Author..: 2008/05/14 by kim  (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_wo_issue_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 查詢 領料單 資料                                                         #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_wo_issue_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 
 
#[
# Description....: 查詢 ERP 領料單
# Date & Author..: 2008/05/14 by kim (FUN-840012)
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_get_wo_issue_data_process()
    DEFINE l_sfs       RECORD 
                         sfp06   LIKE sfp_file.sfp06,    #發料類別
                         sfs01   LIKE sfs_file.sfs01,    #發料單號   
                         sfs02   LIKE sfs_file.sfs02,    #項次    
                         sfs03   LIKE sfs_file.sfs03,    #工單單號
                         sfs04   LIKE sfs_file.sfs04,    #料號    
                         sfs05   LIKE sfs_file.sfs05,    #發料數量
                         sfs06   LIKE sfs_file.sfs06,    #發料單位
                         sfs07   LIKE sfs_file.sfs07,    #倉庫    
                         sfs08   LIKE sfs_file.sfs08,    #儲位    
                         sfs09   LIKE sfs_file.sfs09,    #批號    
                         sfs10   LIKE sfs_file.sfs10,    #作業編號
                         sfs21   LIKE sfs_file.sfs21,    #備註    
                         sfs26   LIKE sfs_file.sfs26,    #替代碼                    
                         sfs27   LIKE sfs_file.sfs27,    #被替代料號                
                         sfs28   LIKE sfs_file.sfs28,    #替代率                    
                         sfs30   LIKE sfs_file.sfs30,    #單位一                    
                         sfs31   LIKE sfs_file.sfs31,    #單位一換算率(與發料單位)  
                         sfs32   LIKE sfs_file.sfs32,    #單位一數量                
                         sfs33   LIKE sfs_file.sfs33,    #單位二                    
                         sfs34   LIKE sfs_file.sfs34,    #單位二換算率(與與發料單位)
                         sfs35   LIKE sfs_file.sfs35,    #單位二數量                
                         sfs930  LIKE sfs_file.sfs930,   #成本中心                  
                         sfa04   LIKE sfa_file.sfa04,    #原發數量
                         sfa05   LIKE sfa_file.sfa05,    #應發數量
                         sfa06   LIKE sfa_file.sfa06,    #已發數量
                         sfa061  LIKE sfa_file.sfa061,   #已領數量
                         sfa062  LIKE sfa_file.sfa062    #超領數量                         
                       END RECORD
    DEFINE l_sql       STRING
    DEFINE l_wc        STRING
    DEFINE l_i         LIKE type_file.num10
    DEFINE l_node      om.DomNode
    DEFINE l_sfa04     LIKE sfa_file.sfa04 
    DEFINE l_sfa05     LIKE sfa_file.sfa05 
    DEFINE l_sfa06     LIKE sfa_file.sfa06 
    DEFINE l_sfa061    LIKE sfa_file.sfa061
    DEFINE l_sfa062    LIKE sfa_file.sfa062
 
 
    LET l_wc = aws_ttsrv_getParameter("condition")   #取由呼叫端呼叫時給予的 SQL Condition
    IF cl_null(l_wc) THEN LET l_wc=" 1=1" END IF
    LET l_sql = "SELECT sfp06,sfs01,sfs02, sfs03, sfs04, sfs05, sfs06, sfs07,",
                " sfs08, sfs09, sfs10, sfs21, sfs26, sfs27, sfs28, sfs30,",
                " sfs31, sfs32, sfs33, sfs34, sfs35, sfs930,",
                " 0,0,0,0,0 ",
                " FROM sfp_file,sfs_file WHERE ",
                " sfs01=sfp01 AND sfpconf='N'",
                " AND ",l_wc,
                " AND sfp06 NOT IN ('A','B','C')",
                " ORDER BY sfs01,sfs02"
 
    DECLARE sfs_curs CURSOR FROM l_sql
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF  
 
    FOREACH sfs_curs INTO l_sfs.*
       IF SQLCA.SQLCODE THEN
          LET g_status.code = SQLCA.SQLCODE
          LET g_status.sqlcode = SQLCA.SQLCODE
          RETURN
       END IF
 
       SELECT sfa04 ,sfa05 ,sfa06 ,sfa061,sfa062 
         INTO l_sfa04 ,l_sfa05 ,l_sfa06 ,l_sfa061,l_sfa062
         FROM sfa_file
        WHERE sfa01 = l_sfs03
          AND sfa03 = l_sfs04
          AND sfa08 = l_sfs10
          AND sfa12 = l_sfs06
       IF NOT SQLCA.sqlcode THEN
          LET l_sfs.sfa04  = l_sfa04 
          LET l_sfs.sfa05  = l_sfa05 
          LET l_sfs.sfa06  = l_sfa06 
          LET l_sfs.sfa061 = l_sfa061
          LET l_sfs.sfa062 = l_sfa062
       END IF
       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_sfs), "sfs_file")   #加入此筆單頭資料至 Respo_receiving_innse 中
    END FOREACH
 
END FUNCTION
