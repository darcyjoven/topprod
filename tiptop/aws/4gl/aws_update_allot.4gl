# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 采购扫描入库作业
# Date & Author..: 2016-03-16 杨兰


DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔

GLOBALS "../../aba/4gl/barcode.global"


GLOBALS
DEFINE g_rvv32    LIKE rvv_file.rvv32    #仓库
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_rvv17    LIKE rvv_file.rvv17    #本次数量
DEFINE g_in       LIKE rvv_file.rvv17
DEFINE g_imm01    LIKE imm_file.imm01
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
DEFINE g_pmm     RECORD LIKE pmm_file.*
DEFINE g_pmn     RECORD LIKE pmn_file.* 
DEFINE g_imm     RECORD LIKE imm_file.*
DEFINE g_imn     RECORD LIKE imn_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_sr     RECORD 
        rvu01    LIKE rvu_file.rvu01
                 END RECORD


#DEFINE   g_cnt  LIKE type_file.num5  #MOD-880015
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
FUNCTION aws_update_allot()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_update_allot_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE t324_file
     DROP TABLE t324_file1
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
FUNCTION aws_update_allot_process()
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
    DEFINE l_return   RECORD                           #回傳值必須宣告為一個 RECORD 變數, 且此 RECORD 需包含所有要回傳的欄位名稱與定義
                         sfu01   LIKE sfu_file.sfu01   #回傳的欄位名稱
                      END RECORD
    DEFINE l_pmm     RECORD LIKE pmm_file.*
    DEFINE l_pmn     RECORD LIKE pmn_file.* 
    DEFINE l_imm     RECORD LIKE imm_file.*
    DEFINE l_imn     RECORD LIKE imn_file.*
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
   DEFINE l_imn29      LIKE imn_file.imn29
   DEFINE l_pmn50      LIKE pmn_file.pmn50
   DEFINE l_pmn55      LIKE pmn_file.pmn55
   DEFINE l_pmn58      LIKE pmn_file.pmn58
   DEFINE l_imn07      LIKE imn_file.imn07
   DEFINE l_tc_codesys11 LIKE tc_codesys_file.tc_codesys11
   DEFINE l_t324_file1      RECORD                       #单身
					imn01     LIKE imn_file.imn01,         #单号
					imn02	    LIKE imn_file.imn02,         #项次
					imnud07   LIKE imn_file.imnud07,     #调拨申请量
					imn10	    LIKE imn_file.imn10           #实际的调拨数量
                 END RECORD  
  DEFINE  l_t324_file     RECORD
					imn01       LIKE imn_file.imn01,         #收货单号
					imn05       LIKE imn_file.imn05,         #拨出库位
					imn16      LIKE imn_file.imn16,          #拨入库位
					barcode     LIKE type_file.chr100,      #条码
					lotnumber   LIKE type_file.chr100,     #批号
					imn03       LIKE imn_file.imn03,         #料件
					imn10       LIKE imn_file.imn10          #数量
                 END RECORD
   DROP TABLE t324_file
   DROP TABLE t324_file1 
 {  CREATE TEMP TABLE t324_file(
                    imn01       LIKE imn_file.imn01,    #收货单号
					imn05       LIKE imn_file.imn05,    #仓库
					imn16      LIKE imn_file.imn16,         #拨入库位
					barcode     LIKE type_file.chr100,    #条码
					lotnumber   LIKE type_file.chr100,     #批号
					imn03       LIKE imn_file.imn03,    #料件
					imn10       LIKE imn_file.imn10 )    #数量
					
   CREATE TEMP TABLE t324_file1( 
        imn01      LIKE imn_file.imn01,         #单号
	imn02	    LIKE imn_file.imn02,         #项次
	imnud07 LIKE imn_file.imnud07,     #调拨申请量
	imn10	    LIKE imn_file.imn10 )          #实际的调拨数量
}

	   CREATE TABLE t324_file(
			imn01        VARCHAR(20),         #收货单号
			imn05        VARCHAR(10),         #仓库
			imn16       VARCHAR(10),              #拨入库位
			barcode      VARCHAR(100),         #条码
			lotnumber    VARCHAR(100),          #批号
			imn03        VARCHAR(40),         #料件
			imn10        DECIMAL(15,3))         #数量
						
	   CREATE TABLE t324_file1(
			imn01       VARCHAR(20),              #单号
			imn02	     SMALLINT,              #项次
			imnud07  DECIMAL(15,3),          #调拨申请量
			imn10	     DECIMAL(15,3))               #实际的调拨数量

             
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    INITIALIZE g_sr.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       LET g_success='N'
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
        
        LET g_imm01 = aws_ttsrv_getRecordField(l_node1,"imm01")
        #----------------------------------------------------------------------#
        # 處理單身資料#
        #----------------------------------------------------------------------#
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "t324_file1")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF
        FOR l_k = 1 TO l_cnt3
            INITIALIZE l_t324_file1.* TO NULL
            LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"t324_file1")   #目前單身的 XML 節點
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_t324_file1.imn01  = g_imm01
            LET l_t324_file1.imn02  = aws_ttsrv_getRecordField(l_node3, "imn02")
            LET l_t324_file1.imnud07  = aws_ttsrv_getRecordField(l_node3, "imnud07") 
            LET l_t324_file1.imn10  = aws_ttsrv_getRecordField(l_node3, "imn10") 
            INSERT INTO t324_file1 VALUES (l_t324_file1.*)
        END FOR
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "t324_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           LET g_success='N'
           EXIT FOR
        END IF                
        FOR l_j = 1 TO l_cnt2
            INITIALIZE l_t324_file.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"t324_file")   #目前單身的 XML 節點
            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#
            LET l_t324_file.imn01=g_imm01
            LET l_t324_file.imn05 = aws_ttsrv_getRecordField(l_node2, "imn05")
            LET l_t324_file.imn16 = aws_ttsrv_getRecordField(l_node2, "imn16")
            LET l_t324_file.barcode = aws_ttsrv_getRecordField(l_node2, "barcode")
            LET l_t324_file.lotnumber = aws_ttsrv_getRecordField(l_node2, "lotnumber")
            LET l_t324_file.imn03 = aws_ttsrv_getRecordField(l_node2, "imn03")
            LET l_t324_file.imn10 = aws_ttsrv_getRecordField(l_node2, "imn10")
            SELECT tc_codesys11 INTO l_tc_codesys11 FROM tc_codesys_file
            IF cl_null(l_tc_codesys11) THEN LET l_tc_codesys11='N' END IF
            IF l_tc_codesys11='Y' THEN
               LET l_sql =" select count(*) from",
                          " (select imn03,",
                          " ibb01,ibb06,imgb02,imgb03,substr(ibb01,length(ibb01)-5,6) ,imgb05,imn10,",
                          " sum(imgb05) over (PARTITION BY imn03 order by imn03,substr(ibb01,length(ibb01)-5,6),ibb01,imgb03 ) sumimgb05",
                          " from imn_file",
                          " inner join ibb_file on ibb06=imn03",
                          " inner join imgb_file on imgb01=ibb01 and imgb02=imn04 and imgb05>0",
                          " where imn10>0",
                          " and imn01='",g_imm01,"'",
                          " order by imn03,substr(ibb01,length(ibb01)-5,6) ,ibb01,imgb03)  a",
                          " where a.sumimgb05-a.imgb05<=a.imn10",
                          "   and a.ibb01='",l_t324_file.barcode,"'",
                          "   and a.imgb03='",l_t324_file.imn05,"'"
                  PREPARE prep_t324ibb01 FROM l_sql
                  EXECUTE prep_t324ibb01 INTO l_n
                  IF l_n>0 THEN
       	             LET g_status.code = "-1"
                     LET g_status.description = "扫描料件不符合FIFO规则,请检查!"
                     LET g_success='N'
                     RETURN
                  END IF
            END IF
            INSERT INTO t324_file VALUES (l_t324_file.*)
        END FOR
    END FOR
    
    IF g_success = 'Y' THEN 
       CALL t324_load()
#       IF g_success = 'Y' THEN
#          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_sr))
##       ELSE
##       	  IF g_status.code='0' THEN
##            LET g_status.code = "-1"
##            LET g_status.description = "接口程序存在错误，请程序员检查，谢谢!"
##          END IF
#       END IF
    END IF
END FUNCTION
FUNCTION t324_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09

   LET g_success = "Y"
   BEGIN WORK
   CALL t324_update_allot()
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
     #--------huxy160622------Beg-------------
     IF g_status.code = '0' THEN
        LET g_status.code = '-1'
        LET g_status.description = '调拨备货失败'
     END IF
     #--------huxy160622------End-------------
   	  ROLLBACK WORK
   END IF
END FUNCTION
FUNCTION t324_update_allot()   #No.MOD-8A0112 add
   DEFINE l_rvu       RECORD LIKE rvu_file.*,
          l_smy57     LIKE type_file.chr1,     # Prog. Version..: '5.20.02-10.08.05(01)   #MOD-740033 modify
          l_t         LIKE smy_file.smyslip    #No.FUN-680136 VARCHAR(5)  #No.FUN-540027
   DEFINE li_result   LIKE type_file.num5      #No.FUN-540027  #No.FUN-680136 SMALLINT
   DEFINE p_chr       LIKE type_file.chr1      #No.MOD-8A0112 add
   DEFINE l_imn01     LIKE imn_file.imn01
	
   IF g_success='Y' THEN
      CALL t324_update_imn() #NO:7143單身  #FUN-810038
   END IF 
   IF g_success='Y' THEN
      CALL t324_ins_tlfb()
   END IF
 
END FUNCTION

FUNCTION t324_update_imn()     #FUN-810038
 DEFINE l_ima44   LIKE ima_file.ima44      #No.FUN-540027
 DEFINE l_rvv     RECORD LIKE rvv_file.*,
        l_rvuconf LIKE rvu_file.rvuconf,
        l_smy57   LIKE type_file.chr1,     #MOD-740033 add
        l_t       LIKE smy_file.smyslip,   #MOD-740033 add
        p_rvv01   LIKE rvv_file.rvv01
 DEFINE p_rvu00   LIKE rvu_file.rvu00      #FUN-810038
 DEFINE l_flag    LIKE type_file.num5      #FUN-810038
 DEFINE l_sql     STRING  #No.FUN-810036
 DEFINE l_pmm43   LIKE pmm_file.pmm43      #CHI-830033
 DEFINE l_cnt     LIKE type_file.num5      #MOD-840263
 DEFINE b_imn     RECORD LIKE imn_file.*
 DEFINE l_imn01   LIKE imn_file.imn01
 DEFINE l_imn02   LIKE imn_file.imn02
 DEFINE l_imn07   LIKE imn_file.imn07
 DEFINE l_rvv17a  LIKE rvv_file.rvv17
 DEFINE l_rvv32   LIKE rvv_file.rvv32

    DEFINE l_imn RECORD 
	imn01     LIKE imn_file.imn01   ,
	imn02     LIKE imn_file.imn02   ,
	imnud07  LIKE imn_file.imnud07,
	imn10     LIKE imn_file.imn10   
     END RECORD 

 

 LET l_sql =" select * from t324_file1",
            " order by imn01,imn02"
 PREPARE t324_file_rvv FROM l_sql
 DECLARE t324_file_rvv_curs CURSOR FOR t324_file_rvv
 FOREACH t324_file_rvv_curs INTO l_imn.*
     IF STATUS THEN
       LET g_success = 'N'
       EXIT FOREACH
     END IF

      UPDATE imn_file 
             SET imn10 = l_imn.imn10,
                 imn22 = l_imn.imn10,
                 imnud07 = l_imn.imnud07,
                 imnud06 = 'Y'
      WHERE imn01 = l_imn.imn01 
          AND imn02 = l_imn.imn02
      
      IF SQLCA.SQLCODE THEN
         LET g_status.code = SQLCA.SQLCODE
         LET g_status.sqlcode = SQLCA.SQLCODE
         LET g_success='N'
         RETURN
      END IF 

   END FOREACH
END FUNCTION
FUNCTION t324_ins_tlfb()
	DEFINE l_sql    STRING
	DEFINE p_rvv01  LIKE rvv_file.rvv01
	DEFINE l_imn03   LIKE imn_file.imn03
	DEFINE l_imn16   LIKE imn_file.imn16
	DEFINE l_n       LIKE type_file.num5

             LET l_sql="select * from t324_file"
             PREPARE t324_file_tlfb FROM l_sql
             DECLARE t324_file_tlfb_curs CURSOR FOR t324_file_tlfb
             FOREACH t324_file_tlfb_curs INTO g_tlfb.tlfb07,g_tlfb.tlfb03,l_imn16,g_tlfb.tlfb01,g_tlfb.tlfb04,l_imn03,g_tlfb.tlfb05
                SELECT ime01 INTO g_tlfb.tlfb02 FROM ime_file WHERE ime02=g_tlfb.tlfb03
                LET g_tlfb.tlfb09 = g_tlfb.tlfb07         #单号
                LET g_tlfb.tlfb06 = -1               #出库
                LET g_tlfb.tlfb14 = g_today         #扫描日期
                LET g_tlfb.tlfb17 = ' '             #杂收理由码
                LET g_tlfb.tlfb18 = ' '             #产品分类码
                LET g_tlfb.tlfb905 = g_tlfb.tlfb09
                LET g_tlfb.tlfb906 = g_tlfb.tlfb10             
          #      CALL s_web_tlfb('','','','','')  #更新条码异动档
                
                #拨入异动档tlfb_file和条码库存imgb_file
                 #SELECT ime01 INTO g_tlfb.tlfb02 FROM ime_file WHERE ime02=l_imn16 #拨入仓库
                 LET g_tlfb.tlfb02 = l_imn16        #仓库
                 LET g_tlfb.tlfb03 = l_imn16        #库位
                 LET g_tlfb.tlfb06 = 1              #入库
                 CALL s_web_tlfb('','','','','')  #更新条码异动档   
                               
                # LET g_sql =" SELECT COUNT(*) FROM imgb_file ",
                #            " WHERE imgb01='",g_tlfb.tlfb01,"'",
                #            " AND imgb04='",g_tlfb.tlfb04,"'",
                #            " AND imgb02='",g_tlfb.tlfb02,"'",
                #            " AND imgb03='",g_tlfb.tlfb03,"'" 
                # PREPARE t324_imgb_pre FROM g_sql
                # EXECUTE t324_imgb_pre INTO l_n
                # IF l_n = 0 THEN #没有imgb_file，新增imgb_file
                #    CALL s_ins_imgb(g_tlfb.tlfb01,
                #          g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,1,'')
                #  ELSE
                #    CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
                #     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                #     g_tlfb.tlfb05,1,'') 
                # END IF 
            END FOREACH
END FUNCTION


	
