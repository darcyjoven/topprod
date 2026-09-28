# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 销售出货作业app
# Date & Author..: 2016-05-04 16:30:11 shenran


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"


GLOBALS
DEFINE g_tc_spx01 LIKE tc_spx_file.tc_spx01    #配货计划单号
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_rvv17    LIKE rvv_file.rvv17    #本次数量
DEFINE g_in       LIKE rvv_file.rvv17
DEFINE g_rva01    LIKE rva_file.rva01
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_yy,g_mm   LIKE type_file.num5 
DEFINE g_img09_t LIKE img_file.img09
DEFINE g_i       LIKE type_file.num5
DEFINE g_ima907  LIKE ima_file.ima907
DEFINE g_gec07   LIKE gec_file.gec07
DEFINE g_sql      STRING
DEFINE g_cnt     LIKE type_file.num10
DEFINE g_rec_b   LIKE type_file.num5
DEFINE g_rec_b_1 LIKE type_file.num5
DEFINE l_ac      LIKE type_file.num10
DEFINE l_ac_t    LIKE type_file.num10
DEFINE li_step   LIKE type_file.num5
DEFINE g_img07   LIKE img_file.img07
DEFINE g_img09   LIKE img_file.img09
DEFINE g_img10   LIKE img_file.img10
DEFINE g_ima906  LIKE ima_file.ima906
DEFINE g_flag    LIKE type_file.chr1
DEFINE g_oga     RECORD LIKE oga_file.*
DEFINE g_ogb_cxmt     RECORD LIKE ogb_file.* 
DEFINE g_rva     RECORD LIKE rva_file.*
DEFINE g_rvb     RECORD LIKE rvb_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_exdate  LIKE type_file.dat
DEFINE exT       LIKE oaz_file.oaz70
DEFINE g_oga01     RECORD 
        oga01    LIKE oga_file.oga01
                 END RECORD

END GLOBALS

#[
# Description....: 提供建立完工入庫單資料的服務(入口 function)
# Date & Author..: 
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_cxmt620()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_create_cxmt620_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE cxmt620_file
     DROP TABLE cxmt620_file1

END FUNCTION

#[
# Description....: 依據傳入資訊新增 ERP 完工入庫單資料
# Date & Author..: 
# Parameter......: none
# Return.........: 入庫單號
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_create_cxmt620_process()
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10,
           l_k        LIKE type_file.num10
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10,
           l_cnt3     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode,
           l_node3    om.DomNode
    DEFINE l_flag     LIKE type_file.num10
    DEFINE l_pmm     RECORD LIKE pmm_file.*
    DEFINE l_pmn     RECORD LIKE pmn_file.* 
    DEFINE l_rva     RECORD LIKE rva_file.*
    DEFINE l_rvb     RECORD LIKE rvb_file.*
    DEFINE l_yy,l_mm  LIKE type_file.num5       
    DEFINE l_status   LIKE sfu_file.sfuconf
    DEFINE l_cmd      STRING
    DEFINE l_prog     STRING
    DEFINE l_flag1    LIKE type_file.chr1       #FUN-B70074
    DEFINE l_success    CHAR(1)
   DEFINE l_factor     DECIMAL(16,8)
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_img10      LIKE img_file.img10
   DEFINE l_ima108     LIKE ima_file.ima108
   DEFINE l_n          SMALLINT
   DEFINE l_length     LIKE type_file.num5
   DEFINE p_cmd        LIKE type_file.chr1    #處理狀態
   DEFINE l_t          LIKE type_file.num5
   DEFINE l_inaconf    LIKE ina_file.inaconf
   DEFINE l_ogb04      LIKE ogb_file.ogb04
   DEFINE l_ogb31      LIKE ogb_file.ogb31
   DEFINE l_ogb32      LIKE ogb_file.ogb32
   DEFINE l_sum_ogb12  LIKE ogb_file.ogb12
   DEFINE l_ogb12      LIKE ogb_file.ogb12
   DEFINE l_ogb01a     LIKE ogb_file.ogb01
   DEFINE l_ogb03a     LIKE ogb_file.ogb03
   DEFINE l_ogb01      LIKE ogb_file.ogb01
   DEFINE l_ogb03      LIKE ogb_file.ogb03
   DEFINE l_ima021     LIKE ima_file.ima021   
   DEFINE l_ogb12a     LIKE ogb_file.ogb12
   DEFINE l_sql        STRING
   DEFINE l_pmn04      LIKE pmn_file.pmn04   #料件编码
   DEFINE l_ima02      LIKE ima_file.ima02   #品名
   DEFINE l_pmn07      LIKE pmn_file.pmn07   #单位
   DEFINE l_lotnumber  LIKE type_file.chr50  #批号
   DEFINE l_barcode1   LIKE type_file.chr50  #条码
   DEFINE l_pmn20      LIKE pmn_file.pmn20   #单据数量
   DEFINE l_msg        LIKE type_file.chr50    #No.FUN-680136 VARCHAR(40)
   DEFINE l_pmn01      LIKE pmn_file.pmn01
   DEFINE l_pmm01      LIKE pmm_file.pmm01
   DEFINE l_pmn02      LIKE pmn_file.pmn02
   DEFINE l_pmn02a     LIKE pmn_file.pmn02
   DEFINE l_pmn20a     LIKE pmn_file.pmn20
   DEFINE l_pmn20ab    LIKE pmn_file.pmn20
   DEFINE l_pmn20b     LIKE pmn_file.pmn20
   DEFINE l_sum        LIKE pmn_file.pmn20
   DEFINE l_sl         LIKE pmn_file.pmn20
   DEFINE l_sr         STRING
   DEFINE l_rvb87      LIKE rvb_file.rvb87
   DEFINE l_rvb29      LIKE rvb_file.rvb29
   DEFINE l_pmn50      LIKE pmn_file.pmn50
   DEFINE l_pmn55      LIKE pmn_file.pmn55
   DEFINE l_pmn58      LIKE pmn_file.pmn58
   DEFINE l_rvb07      LIKE rvb_file.rvb07
   DEFINE l_tc_codesys12 LIKE tc_codesys_file.tc_codesys12
   DEFINE l_cxmt620_file     RECORD                                  #单身1
                    tc_spx05      LIKE tc_spx_file.tc_spx05,         #客户编号
                    tc_spy02      LIKE tc_spy_file.tc_spy02,         #项次
                    tc_spy04      LIKE tc_spy_file.tc_spy04,         #料号
                    tc_spy05      LIKE tc_spy_file.tc_spy05,         #申请数量
                    tc_spy06      LIKE tc_spy_file.tc_spy06          #实际数量
                 END RECORD  
  DEFINE  l_cxmt620_file1     RECORD                         #单身2
                    ime02      LIKE ime_file.ime02,         #仓位
                    ibb01      LIKE ibb_file.ibb01,         #批次条码
                    ima01      LIKE ima_file.ima01,        #料件编码
                    lotnumber  LIKE type_file.chr50,        #批号
                    tc_spy06a  LIKE tc_spy_file.tc_spy06          #数量
                 END RECORD
   DROP TABLE cxmt620_file
   DROP TABLE cxmt620_file1 
   CREATE TEMP TABLE cxmt620_file(
                    tc_spx05      LIKE tc_spx_file.tc_spx05,         #客户编号
                    tc_spy02      LIKE tc_spy_file.tc_spy02,         #项次
                    tc_spy04      LIKE tc_spy_file.tc_spy04,         #料号
                    tc_spy05      LIKE tc_spy_file.tc_spy05,         #申请数量
                    tc_spy06      LIKE tc_spy_file.tc_spy06)         #实际数量
   CREATE TEMP TABLE cxmt620_file1(
                    ime02      LIKE ime_file.ime02,         #仓位
                    ibb01      LIKE ibb_file.ibb01,         #批次条码
                    ima01      LIKE ima_file.ima01,        #料件编码
                    lotnumber  LIKE type_file.chr50,        #批号
                    tc_spy06a  LIKE tc_spy_file.tc_spy06)         #数量
            
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    INITIALIZE g_oga01.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET g_tc_spx01 = aws_ttsrv_getRecordField(l_node1,"tc_spx01")
        #单身1
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "cxmt620_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF                
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_cxmt620_file.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"cxmt620_file")   #目前單身的 XML 節點

            LET l_cxmt620_file.tc_spx05 = aws_ttsrv_getRecordField(l_node2, "tc_spx05")
            LET l_cxmt620_file.tc_spy02 = aws_ttsrv_getRecordField(l_node2, "tc_spy02")
            LET l_cxmt620_file.tc_spy04 = aws_ttsrv_getRecordField(l_node2, "tc_spy04")
            LET l_cxmt620_file.tc_spy05 = aws_ttsrv_getRecordField(l_node2, "tc_spy05")
            LET l_cxmt620_file.tc_spy06 = aws_ttsrv_getRecordField(l_node2, "tc_spy06")
            INSERT INTO cxmt620_file VALUES (l_cxmt620_file.*)
        END FOR
        #单身2
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "cxmt620_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF
        FOR l_k = 1 TO l_cnt3
            INITIALIZE l_cxmt620_file1.* TO NULL
            LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"cxmt620_file1")   #目前單身的 XML 節點
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_cxmt620_file1.ime02     = aws_ttsrv_getRecordField(l_node3, "ime02")
            LET l_cxmt620_file1.ibb01     = aws_ttsrv_getRecordField(l_node3, "ibb01") 
            LET l_cxmt620_file1.ima01     = aws_ttsrv_getRecordField(l_node3, "ima01")   
            LET l_cxmt620_file1.lotnumber = aws_ttsrv_getRecordField(l_node3, "lotnumber")
            LET l_cxmt620_file1.tc_spy06a = aws_ttsrv_getRecordField(l_node3, "tc_spy06a")
            
            SELECT tc_codesys12 INTO l_tc_codesys12 FROM tc_codesys_file
            IF cl_null(l_tc_codesys12) THEN LET l_tc_codesys12='N' END IF
            IF l_tc_codesys12='Y' THEN
    	      LET l_sql =" select count(*) FROM",
                  " (select tc_spy04,ima02,",
                  " ibb01,ibb06,imgb02,imgb03,substr(ibb01,length(ibb01)-5,6) ,imgb05,tc_spy05,",
                  " sum(imgb05) over (PARTITION BY tc_spy04 order by tc_spy04,substr(ibb01,length(ibb01)-5,6),ibb01,imgb03) sumimgb05",
                  " from tc_spy_file",
                  " inner join ibb_file on ibb06=tc_spy04",
                  " inner join imgb_file on imgb01=ibb01 and imgb05>0",
                  " inner join ima_file on ima01=ibb06",
                  " where tc_spy05>0", 
                  " and tc_spy01='",g_tc_spx01,"'",
                  " order by tc_spy04,substr(ibb01,length(ibb01)-5,6) ,ibb01,imgb03)  a ",
                  " where a.sumimgb05-a.imgb05<=a.tc_spy05",
                  " and a.ibb01='",l_cxmt620_file1.ibb01,"'",
                  " and a.imgb03='",l_cxmt620_file1.ime02,"'"
    	        PREPARE prep_i510ibb01 FROM l_sql
              EXECUTE prep_i510ibb01 INTO l_n
              IF cl_null(l_n) THEN LET l_n=0 END IF
              IF l_n=0 THEN
       	         LET g_status.code = "-1"
                 LET g_status.description = "扫描料件不符合FIFO规则,请检查!"
                 LET g_success='N'
                 RETURN
              END IF
            END IF
           	
            INSERT INTO cxmt620_file1 VALUES (l_cxmt620_file1.*)
        END FOR
    END FOR
    IF g_success = 'Y' THEN 
       CALL cxmt620_load()
       IF g_success = 'Y' THEN
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_oga01))
       END IF
    END IF
END FUNCTION
FUNCTION cxmt620_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09

   LET g_success = "Y"
   BEGIN WORK
   CALL cxmt620_oga_ogb()
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  ROLLBACK WORK
   END IF
END FUNCTION
FUNCTION cxmt620_oga_ogb()   #No.MOD-8A0112 add
   DEFINE l_rvu       RECORD LIKE rvu_file.*,
          l_occ       RECORD LIKE occ_file.*,
          l_smy57     LIKE type_file.chr1,     # Prog. Version..: '5.20.02-10.08.05(01)   #MOD-740033 modify
          l_t         LIKE smy_file.smyslip    #No.FUN-680136 VARCHAR(5)  #No.FUN-540027
   DEFINE li_result   LIKE type_file.num5      #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE p_chr       LIKE type_file.chr1      #No.MOD-8A0112 add
   DEFINE l_rvb01     LIKE rvb_file.rvb01
   DEFINE l_jce02     LIKE jce_file.jce02
   
 
   #----單頭
   INITIALIZE g_oga.* TO NULL
   select tc_codesys08 into g_oga.oga01 from tc_codesys_file
   CALL s_auto_assign_no("axm",g_oga.oga01,g_today,"50","oga_file","oga01","","","")
   RETURNING li_result,g_oga.oga01
   IF (NOT li_result) THEN
      LET g_status.code = "-1"
      LET g_status.description = "产生单号有误，请检查" 
      LET g_success='N'
      RETURN
   END IF
   SELECT DISTINCT tc_spx05 INTO g_oga.oga03 FROM cxmt620_file  #收款客户
   LET g_oga.ogaud02    = g_tc_spx01   #配货计划单号
   LET g_oga.oga00  ='1'
   #LET g_oga.oga06  = g_oaz.oaz41
   SELECT oaz41 INTO g_oga.oga06 FROM oaz_file
   LET g_oga.oga07  ='N'     #MOD-860254 add
   LET g_oga.oga08  ='1'
   LET g_oga.oga69  =g_today  #No.FUN-950062
   LET g_oga.oga02  =g_today
   LET g_oga.oga14  =g_user
   LET g_oga.oga15  =g_grup
   LET g_oga.oga161 =0
   LET g_oga.oga162 =100
   LET g_oga.oga163 =0
   LET g_oga.oga20  ='Y'
   LET g_oga.oga211 =0
   LET g_oga.oga50  =0
   LET g_oga.oga52  =0
   LET g_oga.oga53  =0
   LET g_oga.oga54  =0
   LET g_oga.oga903 ='N'    #No.B325 add    #No.B325 add
   LET g_oga.ogaconf='N'
   LET g_oga.oga30  ='N'
   LET g_oga.oga65  ='N'   #FUN-650141 add
   LET g_oga.ogapost='N'
   LET g_oga.ogaprsw=0
   LET g_oga.ogauser=g_user
   LET g_oga.ogaoriu = g_user #FUN-980030
   LET g_oga.ogaorig = g_grup #FUN-980030
   LET g_data_plant = g_plant #FUN-980030
   LET g_oga.ogagrup=g_grup
   LET g_oga.ogadate=g_today
   LET g_oga.ogaplant = g_plant #FUN-980010 add
   LET g_oga.ogalegal = g_legal #FUN-980010 add
   LET g_oga.ogaud05 = 'N'
   LET g_oga.oga09 = '3'
   LET exT=g_oaz.oaz70
   SELECT * INTO l_occ.* FROM occ_file
   WHERE occ01=g_oga.oga03
    AND occacti='Y'
    IF SQLCA.sqlcode THEN
      LET g_status.code = "-1"
      LET g_status.description = "账款客户资料查询失败" 
      LET g_success='N'
      RETURN
    END IF
 
    LET g_oga.oga04 = l_occ.occ09
    LET g_oga.oga18 = l_occ.occ07
    LET g_oga.oga13 = l_occ.occ67
    LET g_oga.oga31 = l_occ.occ44
    LET g_oga.oga05 = l_occ.occ08
    LET g_oga.oga14 = l_occ.occ04
    LET g_oga.oga21 = l_occ.occ41
    LET g_oga.oga23 = l_occ.occ42
    LET g_oga.oga25 = l_occ.occ43
    LET g_oga.oga31 = l_occ.occ44  #MOD-940188
    LET g_oga.oga32 = l_occ.occ45
     IF NOT cl_null(g_oga.oga021) THEN
        LET g_exdate = g_oga.oga021    #結關日期
     ELSE
        LET g_exdate = g_oga.oga02     #出貨日期
     END IF 
     CALL s_curr3(g_oga.oga23,g_exdate,exT) RETURNING g_oga.oga24
    
    SELECT gec04,gec05,gec07 INTO g_oga.oga211,g_oga.oga212,g_oga.oga213
      FROM gec_file WHERE gec01=g_oga.oga21
                      AND gec011='2'
 
    IF g_oga.oga03[1,4] != 'MISC' THEN
       LET g_oga.oga032 = l_occ.occ02
    END IF
   IF cl_null(g_oga.oga85) THEN
       LET g_oga.oga85=' '
   END IF
   IF cl_null(g_oga.oga94) THEN
      LET g_oga.oga94='N'
   END IF
   IF cl_null(g_oga.oga57) THEN
      LET g_oga.oga57 = '1'  
   END IF
   IF cl_null(g_oga.ogaslk02) THEN
      LET g_oga.ogaslk02 = '1'
   END IF
#   SELECT occud02 
#   INTO g_oga.ogaud02
#   FROM occ_file
#   WHERE occ01=g_oga.oga04
#     AND occacti='Y'
#   IF NOT cl_null(g_oga.ogaud02) THEN
#       LET l_jce02= NULL
#       select jce02 INTO l_jce02 from jce_file where jce02=g_oga.ogaud02
#       IF NOT cl_null(l_jce02) THEN
#          LET g_status.code = "-1"
#          LET g_status.description = "非成本仓，不能出货!" 
#          LET g_success='N'
#          RETURN
#       END IF
#   ELSE 
#   	  LET g_status.code = "-1"
#      LET g_status.description = "客户对应仓库未设默认值,请检查!" 
#      LET g_success='N'
#      RETURN
#   END IF
   INSERT INTO oga_file VALUES (g_oga.*)
   IF STATUS THEN
      LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="产生oga_file有错误!"
      LET g_success='N'
      RETURN
   ELSE
   	  LET g_oga01.oga01 = g_oga.oga01  #赋值传出单号
   END IF
   IF g_success='Y' THEN
      CALL cxmt620_ins_ogb(g_oga.oga01) #NO:7143單身  #FUN-810038
   END IF
   IF g_success='Y' THEN
       CALL t650sub_y(g_oga.oga01)                         #FUN-B10004 add
        IF g_success = "Y" THEN
           UPDATE oga_file set ogaud03=g_user,
                               ogaud13=g_today
                         WHERE oga01=g_oga.oga01
          SELECT ogapost INTO g_oga.ogapost FROM oga_file
          WHERE oga01=g_oga.oga01
          IF g_oga.ogapost ='Y'THEN
             UPDATE oga_file set ogaud04=g_user,
                                 ogaud14=g_today
                           WHERE oga01=g_oga.oga01
          END IF
        END IF
   END IF
   IF g_success='Y' THEN
      CALL cxmt620_ins_tlfb()
   END IF
 
END FUNCTION

FUNCTION cxmt620_ins_ogb(p_oga01)     #FUN-810038
 DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027
 DEFINE l_rvv     RECORD LIKE rvv_file.*,
        l_rvuconf LIKE rvu_file.rvuconf,
        l_smy57   LIKE type_file.chr1,     #MOD-740033 add
        l_t       LIKE smy_file.smyslip,   #MOD-740033 add
        p_oga01   LIKE oga_file.oga01
 DEFINE p_rvu00   LIKE rvu_file.rvu00      #FUN-810038
 DEFINE l_flag    LIKE type_file.num5      #FUN-810038
 DEFINE l_sql     STRING  #No.FUN-810036
 DEFINE l_rvbs    RECORD LIKE rvbs_file.*  #No.FUN-810036
 DEFINE l_pmm43   LIKE pmm_file.pmm43      #CHI-830033
 DEFINE l_cnt     LIKE type_file.num5      #MOD-840263
 DEFINE l_ogb1004	LIKE ogb_file.ogb1004
 DEFINE l_ogb15   LIKE ogb_file.ogb15
 DEFINE l_ime02   LIKE ime_file.ime02
 DEFINE l_tc_spx05  LIKE tc_spx_file.tc_spx05         #客户编号
 DEFINE l_tc_spy02  LIKE tc_spy_file.tc_spy02         #项次
 DEFINE l_tc_spy04  LIKE tc_spy_file.tc_spy04         #料号
 DEFINE l_tc_spy05  LIKE tc_spy_file.tc_spy05         #申请数量
 DEFINE l_tc_spy06  LIKE tc_spy_file.tc_spy06          #实际数量 


 
 LET g_ogb_cxmt.ogb01 = p_oga01    #单号 

 LET l_sql =" select * from cxmt620_file",
            " where tc_spy06>0",
            " order by tc_spy02"
 PREPARE cxmt620_file_rvv FROM l_sql
 DECLARE cxmt620_file_rvv_curs CURSOR FOR cxmt620_file_rvv
 FOREACH cxmt620_file_rvv_curs INTO l_tc_spx05,l_tc_spy02,l_tc_spy04,l_tc_spy05,l_tc_spy06
     IF STATUS THEN
       EXIT FOREACH
     END IF
     #更新配货计划单实发数量 str
      UPDATE tc_spy_file SET tc_spy06 = l_tc_spy06 
      WHERE tc_spy01=g_tc_spx01 AND tc_spy02=l_tc_spy02
     #更新配货计划单 end
      SELECT max(ogb03)+1 INTO g_ogb_cxmt.ogb03        #项次
      FROM ogb_file WHERE ogb01 = g_ogb_cxmt.ogb01
      IF g_ogb_cxmt.ogb03 IS NULL THEN
         LET g_ogb_cxmt.ogb03 = 1
      END IF
      LET g_ogb_cxmt.ogb04 = l_tc_spy04  #料号
      SELECT ima25,ima02 INTO g_ogb_cxmt.ogb05,g_ogb_cxmt.ogb06 FROM ima_file WHERE ima01=g_ogb_cxmt.ogb04 #销售单位#品名
#      IF NOT cl_null(g_oga.ogaud02) THEN 
#         LET g_ogb_cxmt.ogb09 = g_oga.ogaud02
#      END IF
      #关于仓库选择问题,ERP只管理到仓库，所以扫描料件条码至少要保证是在同一个仓库,判断放在前端判断
      SELECT ime02 INTO l_ime02 FROM cxmt620_file1 WHERE ima01= l_tc_spy04 AND rownum=1
      SELECT ime01 INTO g_ogb_cxmt.ogb09 FROM ime_file WHERE ime02=l_ime02
      #关于仓库选择问题,ERP只管理到仓库，所以扫描料件条码至少要保证是在同一个仓库
      LET g_ogb_cxmt.ogb091 = ' '
      LET g_ogb_cxmt.ogb092 = ' '
      SELECT COUNT(*) INTO l_cnt FROM img_file
      WHERE img01=g_ogb_cxmt.ogb04
        AND img02=g_ogb_cxmt.ogb09
        AND img03=g_ogb_cxmt.ogb091
        AND img04=g_ogb_cxmt.ogb092
    IF l_cnt=0 THEN 
  	   CALL s_add_img(g_ogb_cxmt.ogb04,g_ogb_cxmt.ogb09,g_ogb_cxmt.ogb091,g_ogb_cxmt.ogb092,g_ogb_cxmt.ogb01,g_ogb_cxmt.ogb03,g_today)
    END IF

    LET g_ogb_cxmt.ogb1005 = '1'
    LET g_ogb_cxmt.ogb1013 = 0
    LET g_ogb_cxmt.ogb05_fac = 1  
    LET g_ogb_cxmt.ogb07     = ' '
    LET g_ogb_cxmt.ogb08 =    g_plant
    LET g_ogb_cxmt.ogb19     = 'N'

    SELECT obk03 INTO g_ogb_cxmt.ogb11 FROM obk_file
     WHERE obk01 = g_ogb_cxmt.ogb04 AND obk02 = g_oga.oga03 AND rownum = 1
     
    LET g_ogb_cxmt.ogb12     = l_tc_spy06
    LET g_ogb_cxmt.ogb12     = s_digqty(g_ogb_cxmt.ogb12,g_ogb_cxmt.ogb05) #FUN-BB0083 add
  
    SELECT ogb1004 INTO l_ogb1004 FROM ogb_file
              WHERE ogb01=g_oga.oga01 AND ogb03=g_ogb_cxmt.ogb03
    CALL s_fetch_price_new(g_oga.oga03,g_ogb_cxmt.ogb04,'',g_ogb_cxmt.ogb05,g_oga.oga02,'2', 
                           g_plant,g_oga.oga23,g_oga.oga31,g_oga.oga32,g_oga.oga01,g_ogb_cxmt.ogb03,
                           g_ogb_cxmt.ogb12,l_ogb1004,'a')
         RETURNING g_ogb_cxmt.ogb13,g_ogb_cxmt.ogb37 # No.FUN-AB0061

    IF cl_null(g_ogb_cxmt.ogb916) THEN
       LET g_ogb_cxmt.ogb916=g_ogb_cxmt.ogb05
       LET g_ogb_cxmt.ogb917=g_ogb_cxmt.ogb12
    END IF
    
    IF g_ogb_cxmt.ogb05 = g_ogb_cxmt.ogb916 AND g_sma.sma115 = 'N' THEN 
       LET g_ogb_cxmt.ogb917 = g_ogb_cxmt.ogb12
    END IF
    IF g_oga.oga213 = 'N' THEN
       LET g_ogb_cxmt.ogb14  = g_ogb_cxmt.ogb917 * g_ogb_cxmt.ogb13     #CHI-710059 mod
       LET g_ogb_cxmt.ogb14t = g_ogb_cxmt.ogb14  * (1 + g_oga.oga211/100)
    ELSE
       LET g_ogb_cxmt.ogb14t = g_ogb_cxmt.ogb917 * g_ogb_cxmt.ogb13     #CHI-710059 mod
       LET g_ogb_cxmt.ogb14  = g_ogb_cxmt.ogb14t / (1 + g_oga.oga211/100)
    END IF
  
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oga.oga23
    CALL cl_digcut(g_ogb_cxmt.ogb14,t_azi04) RETURNING g_ogb_cxmt.ogb14
    CALL cl_digcut(g_ogb_cxmt.ogb14t,t_azi04)RETURNING g_ogb_cxmt.ogb14t

  
    SELECT img09 INTO l_ogb15 FROM img_file
     WHERE img01 = g_ogb_cxmt.ogb04 AND img02 = g_ogb_cxmt.ogb09
       AND img03 = g_ogb_cxmt.ogb091 AND img04 = g_ogb_cxmt.ogb092
  
    IF cl_null(g_ogb_cxmt.ogb15) THEN LET g_ogb_cxmt.ogb15 = l_ogb15 END IF
  
    IF STATUS=0 THEN
       IF g_ogb_cxmt.ogb05 = g_ogb_cxmt.ogb15 THEN 
          LET g_ogb_cxmt.ogb15_fac =1 
       ELSE 
          #檢查該發料單位與主檔之單位是否可以轉換
          CALL s_umfchk(g_ogb_cxmt.ogb04,g_ogb_cxmt.ogb05,g_ogb_cxmt.ogb15)
                    RETURNING g_cnt,g_ogb_cxmt.ogb15_fac
          IF g_cnt = 1 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="单位无法与料件主档之库存单位转换,请重新录入!"
             LET g_success='N'
             RETURN
          END IF
       END IF
    END IF
  
    IF cl_null(g_ogb_cxmt.ogb15) THEN LET g_ogb_cxmt.ogb15  = g_ogb_cxmt.ogb05 END IF
    IF cl_null(g_ogb_cxmt.ogb15_fac) THEN LET g_ogb_cxmt.ogb15_fac = 1 END IF
    LET g_ogb_cxmt.ogb16 = g_ogb_cxmt.ogb12 * g_ogb_cxmt.ogb15_fac
    LET g_ogb_cxmt.ogb16 = s_digqty(g_ogb_cxmt.ogb16,g_ogb_cxmt.ogb15) #FUN-BB0083 add
    LET g_ogb_cxmt.ogb17 = 'N'
    LET g_ogb_cxmt.ogb18 = g_ogb_cxmt.ogb12
    LET g_ogb_cxmt.ogb60 = 0
    LET g_ogb_cxmt.ogb63 = 0
    LET g_ogb_cxmt.ogb64 = 0
    LET g_ogb_cxmt.ogb1014='N' #FUN-6B0044
    LET g_ogb_cxmt.ogb1012 = 'N'  #No.TQC-740232
    LET g_ogb_cxmt.ogbplant=g_plant
    LET g_ogb_cxmt.ogblegal=g_legal
    LET g_ogb_cxmt.ogb47=0
    LET g_ogb_cxmt.ogb50=0
    LET g_ogb_cxmt.ogb51=0
    LET g_ogb_cxmt.ogb52=0
    LET g_ogb_cxmt.ogb53=0
    LET g_ogb_cxmt.ogb54=0
    LET g_ogb_cxmt.ogb55=0
    LET g_ogb_cxmt.ogb44='1'
    
    INSERT INTO ogb_file VALUES (g_ogb_cxmt.*)
    IF STATUS THEN
   	  LET g_status.code = -1
      LET g_status.sqlcode = SQLCA.SQLCODE
      LET g_status.description="插入ogb_file有错误!"
      LET g_success='N'
      RETURN
    END IF
   END FOREACH
   SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file WHERE ogb01 = g_oga.oga01
   IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
   LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
   LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
   UPDATE oga_file SET oga50=g_oga.oga50,
                       oga52=g_oga.oga52,
                       oga53=g_oga.oga53
    WHERE oga01 = g_oga.oga01
END FUNCTION
FUNCTION cxmt620_ins_tlfb()
	DEFINE l_sql    STRING
	DEFINE p_rvv01  LIKE rvv_file.rvv01
	DEFINE l_ima01   LIKE ima_file.ima01
	DEFINE l_lotnumber LIKE type_file.chr50
	DEFINE l_tc_spy06a LIKE tc_spy_file.tc_spy06
	DEFINE l_n       LIKE type_file.num5
	DEFINE l_t       LIKE type_file.num5
	DEFINE l_ibb01   LIKE ibb_file.ibb01
	DEFINE l_iba     RECORD LIKE iba_file.*
	DEFINE l_ibb     RECORD LIKE ibb_file.*

      LET l_sql=" select ibb01,ima01,lotnumber,tc_spy06a from asft620_file1"
                PREPARE cxmt620_file1 FROM l_sql
                DECLARE cxmt620_file1_curs1 CURSOR FOR cxmt620_file1
                FOREACH cxmt620_file1_curs1 INTO l_ibb01,l_ima01,l_lotnumber,l_tc_spy06a
      SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_ibb01
      SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_ibb01
      IF cl_null(l_n) THEN LET l_n=0 END IF
      IF cl_null(l_t) THEN LET l_t=0 END IF
      IF l_n=0 AND l_t=0 THEN
         LET l_iba.iba01=l_ibb01
         INSERT INTO iba_file VALUES(l_iba.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生iba_file有错误!" 
             LET g_success = 'N'
             RETURN
         END IF
         LET l_ibb.ibb01=l_ibb01                 #条码编号
         LET l_ibb.ibb02='K'                     #条码产生时机点
         LET l_ibb.ibb03=g_oga.oga01                 #来源单号
         LET l_ibb.ibb04=0                       #来源项次
         LET l_ibb.ibb05=0                       #包号
         LET l_ibb.ibb06=l_ima01                 #料号
         LET l_ibb.ibb11='Y'                     #使用否         
         LET l_ibb.ibb12=0                       #打印次数
         LET l_ibb.ibb13=0                       #检验批号(分批检验顺序)
         LET l_ibb.ibbacti='Y'                   #资料有效码
    #     LET l_ibb.ibb17=l_lotnumber                 #批号
    #     LET l_ibb.ibb14=l_tc_spy06a                 #数量
    #     LET l_ibb.ibb20=g_today                 #生成日期
         INSERT INTO ibb_file VALUES(l_ibb.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_status.code = -1
             LET g_status.sqlcode = SQLCA.SQLCODE
             LET g_status.description="产生ibb_file有错误!" 
             LET g_success = 'N'
            RETURN
         END IF
      END IF
      END FOREACH
             LET l_sql="select * from cxmt620_file1"
             PREPARE cxmt620_file_tlfb FROM l_sql
             DECLARE cxmt620_file_tlfb_curs CURSOR FOR cxmt620_file_tlfb
             FOREACH cxmt620_file_tlfb_curs INTO g_tlfb.tlfb03,g_tlfb.tlfb01,l_ima01,
                                              g_tlfb.tlfb04,g_tlfb.tlfb05
                SELECT ime01 INTO g_tlfb.tlfb02 FROM ime_file WHERE ime02=g_tlfb.tlfb03
                LET g_tlfb.tlfb09 = g_oga.oga01     #入库单号
                LET g_tlfb.tlfb06 = -1              #出库
                LET g_tlfb.tlfb14 = g_today         #扫描日期
                LET g_tlfb.tlfb17 = ' '             #杂收理由码
                LET g_tlfb.tlfb18 = ' '             #产品分类码
                LET g_tlfb.tlfb905 = g_oga.oga01
                LET g_tlfb.tlfb906 = 0          
                CALL s_web_tlfb('','','','','')  #更新条码异动档
                 
                 LET g_sql =" SELECT COUNT(*) FROM imgb_file ",
                            "WHERE imgb01='",g_tlfb.tlfb01,"'",
                            " AND imgb04='",g_tlfb.tlfb04,"'",
                            " AND imgb02='",g_tlfb.tlfb02,"'",
                            " AND imgb03='",g_tlfb.tlfb03,"'" 
                 PREPARE cxmt620_imgb_pre FROM g_sql
                 EXECUTE cxmt620_imgb_pre INTO l_n
                 IF l_n = 0 THEN #没有imgb_file，新增imgb_file
                    CALL s_ins_imgb(g_tlfb.tlfb01,
                          g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
                  ELSE
                    CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
                     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                     g_tlfb.tlfb05,g_tlfb.tlfb06,'')
                 END IF 
            END FOREACH
END FUNCTION



