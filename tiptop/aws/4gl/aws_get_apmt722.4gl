# Prog. Version..: '5.30.03-12.09.18(00000)'     #
#{
# Program name...: aws_get_apmt722.4gl
# Descriptions...: 获取仓库退货
# Date & Author..: 2016-09-08 9:45:06 by shenran

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP 服務使用的變數檔, 服務輸入/出變數均需定義於此

FUNCTION aws_get_apmt722()
    
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序 #FUN-860037
    
    #--------------------------------------------------------------------------#
    # 查詢 ERP 客戶編號                                                    #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_get_apmt722_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
END FUNCTION
 

FUNCTION aws_get_apmt722_process()
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_cnt   LIKE type_file.num10
    DEFINE l_sfa01 LIKE sfa_file.sfa01
    DEFINE l_node  om.DomNode

   #FUN-B90089 add str---
    DEFINE l_wc     STRING
    DEFINE l_str    STRING
    DEFINE l_end    STRING
    DEFINE l_sql    STRING
    DEFINE l_n      LIKE type_file.num10
    DEFINE l_supp   LIKE type_file.chr1000 #供应商
    DEFINE l_propos LIKE type_file.chr1000 #申请人
    DEFINE l_depart LIKE gem_file.gem02    #部门
    DEFINE l_bdate  LIKE type_file.dat     #开始日期
    DEFINE l_edate  LIKE type_file.dat     #结束日期
    DEFINE l_rvu    RECORD 
               rvu03    LIKE rvu_file.rvu03,         #日期
               rvu04    LIKE rvu_file.rvu04,         #供应商
               rvu05    LIKE rvu_file.rvu05,         #供应商简称
               rvu06    LIKE rvu_file.rvu06,         #部门编码
               gem02    LIKE gem_file.gem02,         #部门名称
               rvu07    LIKE rvu_file.rvu07,         #申请人
               gen02    LIKE gen_file.gen02,         #申请人姓名
               rvu01    LIKE rvu_file.rvu01,         #单号
               rvv02    LIKE rvv_file.rvv02,         #项次
               rvv31    LIKE rvv_file.rvv31,         #料号
               rvv031   LIKE rvv_file.rvv031,        #品名
               ima021   LIKE ima_file.ima021,        #规格
               rvv35    LIKE rvv_file.rvv35,         #单位
               rvv32    LIKE rvv_file.rvv32,         #仓库
               rvv17    LIKE rvv_file.rvv17,         #申请量
               rvv17a   LIKE rvv_file.rvv17          #匹配量
                    END RECORD
    
    INITIALIZE l_rvu.*  TO NULL
    LET l_supp=''
    LET l_propos=''
    LET l_depart=''
    LET l_bdate=''
    LET l_edate=''
    LET l_supp   = aws_ttsrv_getParameter("supp")    #取由呼叫端呼叫時給予的 SQL Condition  
    LET l_propos   = aws_ttsrv_getParameter("propos")    #取由呼叫端呼叫時給予的 SQL Condition   
    LET l_depart = aws_ttsrv_getParameter("depart")    #取由呼叫端呼叫時給予的 SQL Condition
    LET l_bdate  = aws_ttsrv_getParameter("bdate")    #取由呼叫端呼叫時給予的 SQL Condition
    LET l_edate  = aws_ttsrv_getParameter("edate")   #取由呼叫端呼叫時給予的 SQL Condition

    LET l_sql=" select rvu03,rvu04,rvu05,rvu06,gem02,rvu07,gen02,",
              " rvu01,rvv02,rvv31,rvv031,ima021,rvv35,rvv32,rvv17,0",
              " from rvu_file",
              " inner join gem_file on gem01=rvu06",
              " inner join gen_file on gen01=rvu07",
              " inner join rvv_file on rvu01=rvv01",
              " inner join ima_file on rvv31=ima01",
              " where rvu00='3' and rvu08<>'SUB' and rvu116<>'3'",
              " and rvuconf='N'"

    IF NOT cl_null(l_supp) THEN
    	 LET l_sql = l_sql," and (rvu04 like '%",l_supp,"%' or rvu05 like '%",l_supp,"%')"
    END IF      
    IF NOT cl_null(l_propos) THEN
    	 LET l_sql = l_sql," and (rvu07 like '%",l_propos,"%' or gen02 like '%",l_propos,"%')"
    END IF
    IF NOT cl_null(l_depart) THEN
    	 LET l_sql = l_sql," and (rvu06 like '%",l_depart,"%' or gem02 like '%",l_depart,"%')" 
    END IF
    IF NOT cl_null(l_bdate) AND NOT cl_null(l_edate) THEN
    	 LET l_sql = l_sql," and rvu03 between '",l_bdate,"' and '",l_edate,"'"
    END IF

    LET l_sql = l_sql," order by rvu03 desc"
    
    DECLARE occ_cur CURSOR FROM l_sql
   
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
    
    FOREACH occ_cur INTO l_rvu.*

       LET l_node = aws_ttsrv_addMasterRecord(base.TypeInfo.create(l_rvu), "Master")   #加入此筆單檔資料至 Response 中
    
    END FOREACH
    
    IF SQLCA.SQLCODE THEN
       LET g_status.code = SQLCA.SQLCODE
       LET g_status.sqlcode = SQLCA.SQLCODE
       RETURN
    END IF
END FUNCTION


