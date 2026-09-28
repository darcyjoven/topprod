# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 工单调拨发料作业
# Date & Author..: 2016/06/09 11:35:42 nihuan


DATABASE ds

GLOBALS "../../config/top.global"             
GLOBALS "../../aba/4gl/barcode.global"  

GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔


GLOBALS
DEFINE g_imm01    LIKE imm_file.imm01    #调拨单号
DEFINE g_barcode  LIKE type_file.chr50   #批次条码
DEFINE g_pmn20    LIKE pmn_file.pmn20    #数量
DEFINE g_buf      LIKE type_file.chr2
DEFINE li_result  LIKE type_file.num5
DEFINE g_sql      STRING
DEFINE g_cnt1     LIKE type_file.num10
DEFINE g_rec_b   LIKE type_file.num5
DEFINE g_rec_b_1 LIKE type_file.num5
DEFINE l_ac      LIKE type_file.num10
DEFINE l_ac_t    LIKE type_file.num10
DEFINE li_step   LIKE type_file.num5
DEFINE g_img07   LIKE img_file.img07
DEFINE g_img09   LIKE img_file.img09
DEFINE g_flag    LIKE type_file.chr1
DEFINE g_imm     RECORD LIKE imm_file.*
DEFINE g_srm_dbs LIKE  type_file.chr50
DEFINE g_success LIKE type_file.chr1
DEFINE g_yy,g_mm LIKE type_file.num5
DEFINE g_sw      LIKE type_file.num5   #No.FUN-690026 SMALLINT
DEFINE g_factor  LIKE img_file.img21
DEFINE g_forupd_sql         STRING
DEFINE g_debit,g_credit    LIKE img_file.img26
DEFINE g_img10,g_img10_2   LIKE img_file.img10
DEFINE b_imn    RECORD LIKE imn_file.*
DEFINE g_tc_imm    RECORD LIKE tc_imm_file.*

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
FUNCTION aws_csft512_s()
 
 WHENEVER ERROR CONTINUE

    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #--------------------------------------------------------------------------#
    # 新增完工入庫單資料                                                       #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_csft512_s_process()
    END IF

    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序
     DROP TABLE csft512_file1
     DROP TABLE csft512_temp 
END FUNCTION

FUNCTION aws_csft512_s_process()
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
   DEFINE l_pmn50      LIKE pmn_file.pmn50
   DEFINE l_pmn55      LIKE pmn_file.pmn55
   DEFINE l_pmn58      LIKE pmn_file.pmn58
   DEFINE l_rvb07      LIKE rvb_file.rvb07
   DEFINE l_t324_file1      RECORD                                   #单身
                    barcode       LIKE type_file.chr100,             #物料条码
                    warehouse_no  LIKE type_file.chr100,             #拨入仓
                    storgae_space LIKE type_file.chr100,             #拨入库位
                    pihao         LIKE type_file.chr100,             #批号
                    tc_imn01      LIKE tc_imn_file.tc_imn01,         #调拨单   
                    tc_imn05      LIKE tc_imn_file.tc_imn05,         #料号    
                    tc_imn11      LIKE type_file.num10               #实际数量  
                 END RECORD  
   DROP TABLE csft512_file1 
    
   CREATE TEMP TABLE csft512_file1(
                    barcode       LIKE type_file.chr100,    
                    warehouse_no  LIKE type_file.chr100,    
                    storgae_space LIKE type_file.chr100,    
                    pihao         LIKE type_file.chr100,    
                    tc_imn01      LIKE tc_imn_file.tc_imn01, 
                    tc_imn05      LIKE tc_imn_file.tc_imn05, 
                    tc_imn11      LIKE tc_imn_file.tc_imn11)  
                             
    #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'

    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF
    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點
       
        LET l_t324_file1.barcode  = aws_ttsrv_getRecordField(l_node1,"barcode")
        LET l_t324_file1.warehouse_no  = aws_ttsrv_getRecordField(l_node1,"warehouse_no")
        LET l_t324_file1.storgae_space  = aws_ttsrv_getRecordField(l_node1,"storgae_space")
        LET l_t324_file1.pihao  = aws_ttsrv_getRecordField(l_node1,"pi_hao")
        LET l_t324_file1.tc_imn01  = aws_ttsrv_getRecordField(l_node1,"tc_imn01")
        LET g_imm01             = l_t324_file1.tc_imn01
        LET l_t324_file1.tc_imn05  = aws_ttsrv_getRecordField(l_node1,"tc_imp05") 
        LET l_t324_file1.tc_imn11  = aws_ttsrv_getRecordField(l_node1,"tc_imn11")     

        INSERT INTO csft512_file1 VALUES (l_t324_file1.*)

    END FOR
    IF g_status.code='0' THEN
       CALL t512_s_loadmei()
       
       IF g_success = 'N' THEN
       	 IF g_status.code='0' THEN
       	 	   LET g_status.code = "-1"
             LET g_status.description = "接口存在错误,请联系程序员!"
       	 END IF
       END IF
    END IF
END FUNCTION

FUNCTION t512_s_loadmei()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_sql       STRING
   DEFINE l_msg       LIKE type_file.chr50
   DEFINE l_qty       LIKE tc_imp_file.tc_imp08
   DEFINE l_tc_imq05  LIKE tc_imq_file.tc_imq05,    #料号
          l_tc_imq06  LIKE tc_imq_file.tc_imq06,    #仓库
          l_tc_imq07  LIKE tc_imq_file.tc_imq07,    #库位
          l_tc_imq08  LIKE tc_imq_file.tc_imq08,    #批次
          l_sum       LIKE tc_imq_file.tc_imq14,
          l_ibb01     LIKE ibb_file.ibb01           #条码
   DEFINE l_tc_imp    RECORD LIKE tc_imp_file.*    
   DEFINE l_tc_imq    RECORD LIKE tc_imq_file.*       
#   DEFINE g_tlfb     RECORD LIKE tlfb_file.*
   DEFINE l_imp      RECORD 
              tc_imp01      LIKE tc_imp_file.tc_imp01,
              tc_imp02      LIKE tc_imp_file.tc_imp02,
              tc_imp05      LIKE tc_imp_file.tc_imp05,
              tc_imp08      LIKE tc_imp_file.tc_imp08
                     END RECORD ,
           l_imq     RECORD
              tc_imq01      LIKE tc_imq_file.tc_imq01,
              tc_imq02      LIKE tc_imq_file.tc_imq02,
              tc_imq05      LIKE tc_imq_file.tc_imq05,
              tc_imq10      LIKE tc_imq_file.tc_imq10,
              tc_imq11      LIKE tc_imq_file.tc_imq11,
              tc_imq14      LIKE tc_imq_file.tc_imq14,
              tc_imq15      LIKE tc_imq_file.tc_imq15
                     END RECORD 
   DEFINE l_imm      RECORD                          #单身
              barcode       LIKE type_file.chr100,             #物料条码
              warehouse_no  LIKE type_file.chr100,             #拨入仓
              storgae_space LIKE type_file.chr100,             #拨入库位
              pihao         LIKE type_file.chr100,             #批号
              tc_imn01      LIKE tc_imn_file.tc_imn01,         #调拨单
              tc_imn05      LIKE tc_imn_file.tc_imn05,         #料号
              tc_imn11      LIKE tc_imn_file.tc_imn11          #实际数量
                    END RECORD
   
   BEGIN WORK
   INITIALIZE g_tlfb.* TO NULL
   INITIALIZE l_tc_imq.* TO NULL
   INITIALIZE l_tc_imp.* TO NULL
   ###########直接插入tc_imq_file
#   CREATE TEMP TABLE csft512_file1(
#                    barcode       LIKE type_file.chr100,             #物料条码
#                    warehouse_no  LIKE type_file.chr100,             #拨入仓
#                    storgae_space LIKE type_file.chr100,             #拨入库位
#                    pihao         LIKE type_file.chr100,             #批号
#                    tc_imn01      LIKE tc_imn_file.tc_imn01,         #调拨单   
#                    tc_imn05      LIKE tc_imn_file.tc_imn05,         #料号    
#                    tc_imn11      LIKE type_file.num10               #实际数量
#                    )
   ####
   DROP TABLE csft512_temp
   LET l_sql ="CREATE GLOBAL TEMPORARY TABLE csft512_temp AS SELECT * FROM tc_imp_file WHERE 1=2"
   PREPARE csft512_temp FROM l_sql
   EXECUTE csft512_temp
   
   LET l_sql="insert into csft512_temp select * from tc_imp_file where tc_imp01='",g_imm01,"'"
   PREPARE csft512_temp_ins FROM l_sql
   EXECUTE csft512_temp_ins
   
   LET g_success='N'   #不去更新表就是失败
   
   DELETE FROM tc_imq_file WHERE tc_imq01=g_imm01
   LET l_sql=" select barcode,warehouse_no,storgae_space,pihao,tc_imn05,sum(tc_imn11)
               from csft512_file1",
             " where tc_imn11>0",
             " group by barcode,warehouse_no,storgae_space,pihao,tc_imn05"
     PREPARE t324_ipb4 FROM l_sql
     DECLARE t324_ic4 CURSOR FOR t324_ipb4
     FOREACH t324_ic4 INTO l_ibb01,l_tc_imq06,l_tc_imq07,l_tc_imq08,l_tc_imq05,l_sum
        IF STATUS THEN
          #EXIT FOREACH
          LET g_status.code = "-1"
          LET g_status.description = "抓取数据失败!"
          LET g_success='N'
          RETURN 
        END IF
        
        IF l_sum=0 THEN 
        	 CONTINUE FOREACH
        END IF 	
        
        LET l_sql="select * from csft512_temp where tc_imp01='",g_imm01,"'
                   and tc_imp05='",l_tc_imq05,"' 
                   order by tc_imp02"
        PREPARE t512_ipb FROM l_sql
        DECLARE t512_ic CURSOR FOR t512_ipb
        FOREACH t512_ic INTO l_tc_imp.*
           IF l_sum=0 THEN 
           	  EXIT FOREACH 
           END IF
           
           IF l_sum>=l_tc_imp.tc_imp08 THEN 
           	  LET l_sum=l_sum-l_tc_imp.tc_imp08
           	  UPDATE csft512_temp SET tc_imp08=0
           	  WHERE tc_imp01=l_tc_imp.tc_imp01 AND tc_imp02=l_tc_imp.tc_imp02
           ELSE	 
           	  UPDATE csft512_temp SET tc_imp08=l_tc_imp.tc_imp08-l_sum
          	  WHERE tc_imp01=l_tc_imp.tc_imp01 AND tc_imp02=l_tc_imp.tc_imp02
          	  LET l_tc_imp.tc_imp08=l_sum
          	  LET l_sum=0
           END IF
           	
           LET l_tc_imq.tc_imq14=l_tc_imp.tc_imp08
           LET l_tc_imq.tc_imq15=l_tc_imp.tc_imp08
           SELECT MAX(tc_imq02)+1 INTO l_tc_imq.tc_imq02 
           FROM tc_imq_file WHERE tc_imq01=g_imm01
           IF cl_null(l_tc_imq.tc_imq02) THEN 
           	  LET l_tc_imq.tc_imq02 =1
           END IF
           LET l_tc_imq.tc_imq01=g_imm01
           LET l_tc_imq.tc_imq03=l_tc_imp.tc_imp03
           LET l_tc_imq.tc_imq04=l_tc_imp.tc_imp03
           LET l_tc_imq.tc_imq05=l_tc_imp.tc_imp05
           
           LET l_tc_imq.tc_imq06=l_tc_imq06
           LET l_tc_imq.tc_imq07=l_tc_imq07
           LET l_tc_imq.tc_imq08=l_tc_imq08
           
           SELECT DISTINCT img09 INTO l_tc_imq.tc_imq09 
           FROM img_file 
           WHERE img01=l_tc_imq.tc_imq05
           
           LET l_tc_imq.tc_imq10=l_tc_imp.tc_imp06
           
           SELECT tc_imm10 INTO l_tc_imq.tc_imq11 
           FROM tc_imm_file WHERE tc_imm01=g_imm01
           
           LET l_tc_imq.tc_imq12=l_tc_imq08
           LET l_tc_imq.tc_imq13=l_tc_imq.tc_imq09 
           LET l_tc_imq.tc_imq16 = 1
      	 	 LET l_tc_imq.tc_imq17 = 'X01'
      	 	 INSERT INTO tc_imq_file VALUES(l_tc_imq.*)
      	 	 IF STATUS OR SQLCA.SQLCODE THEN
              LET g_status.code = "-1"
              LET g_status.description = "插入tc_imq_file失败!"
         	    LET g_success = "N"
         	    RETURN
         	 ELSE 
         	 	  LET g_success='Y'    
           END IF
   	 
        END FOREACH 	
        #mark by nihuan 20170614-----申请明细不去更新，直接插tc_imq_file---start----	
#        LET l_qty=l_imm.tc_imn11
#        LET l_sql="select tc_imp01,tc_imp02,tc_imp05,tc_imp08 from tc_imp_file where tc_imp01='",l_imm.tc_imn01,"'"	
#        PREPARE t324_imp4 FROM l_sql
#        DECLARE t324_impc4 CURSOR FOR t324_imp4
#        FOREACH t324_impc4 INTO l_imp.*
#           IF l_qty=0 THEN 
#           	  LET l_imp.tc_imp08=0
#           END IF 
#           IF l_imp.tc_imp08>=l_qty THEN 
#              LET l_imp.tc_imp08=l_qty
#              LET l_qty=0
#           ELSE 
#           	  LET l_qty=l_qty-l_imp.tc_imp08 
#           END IF 
#           UPDATE tc_imp_file SET tc_imp08=l_imp.tc_imp08
#           WHERE tc_imp01=l_imm.tc_imn01 AND tc_imp02=l_imp.tc_imp02
#                 AND tc_imp05=l_imp.tc_imp05
#           IF STATUS THEN
#             LET g_status.code = "-1"
#             LET g_status.description = "更新tc_imp表失败!"
#             ROLLBACK WORK 
#             RETURN 
#           END IF      
#        END FOREACH
#        
#        LET l_qty=l_imm.tc_imn11
#        LET l_sql="select tc_imq01,tc_imq02,tc_imq05,tc_imq10,tc_imq11,tc_imq14,tc_imq15 from tc_imq_file where tc_imq01='",l_imm.tc_imn01,"'"	
#        PREPARE t324_imq4 FROM l_sql
#        DECLARE t324_imqc4 CURSOR FOR t324_imq4
#        FOREACH t324_imqc4 INTO l_imq.*
#           IF l_imq.tc_imq10!=l_imm.warehouse_no OR l_imq.tc_imq11!=l_imm.storgae_space THEN 
#              LET g_status.code = "-1"
#              LET g_status.description = "拨入仓库，库位与调拨单上仓库库位不一致!"
#              ROLLBACK WORK 
#              RETURN 
#           END IF 
#           IF l_qty=0 THEN 
#           	  LET l_imq.tc_imq14=0
#           END IF 
#           IF l_imq.tc_imq14>=l_qty THEN 
#              LET l_imq.tc_imq14=l_qty
#              LET l_qty=0
#           ELSE 
#           	  LET l_qty=l_qty-l_imq.tc_imq14
#           END IF 
#           UPDATE tc_imq_file SET tc_imq14=l_imq.tc_imq14,tc_imq15=l_imq.tc_imq14
#           WHERE tc_imq01=l_imm.tc_imn01 AND tc_imq02=l_imq.tc_imq02
#                 AND tc_imq05=l_imq.tc_imq05
#           IF STATUS THEN
#             LET g_status.code = "-1"
#             LET g_status.description = "更新tc_imqp表失败!"
#             ROLLBACK WORK 
#             RETURN 
#           END IF      
#        END FOREACH 
#mark by nihuan 20170614-----申请明细不去更新，直接插tc_imq_file-------end----        

        LET  g_tlfb.tlfb01 = l_ibb01
        LET  g_tlfb.tlfb02 = l_tc_imq06
#        SELECT ime02 INTO g_tlfb.tlfb03 FROM ime_file WHERE ime01=g_tlfb.tlfb02
        LET  g_tlfb.tlfb03 = l_tc_imq07
        LET  g_tlfb.tlfb04 = l_tc_imq08

     #  LET  g_tlfb.tlfb05 = l_sum
        LET  g_tlfb.tlfb05 = l_tc_imp.tc_imp08
        LET  g_tlfb.tlfb06 = -1
        LET  g_tlfb.tlfb07 = g_imm01
        LET  g_tlfb.tlfb08 = ' ' 
        LET  g_tlfb.tlfb09 = g_imm01
        LET  g_tlfb.tlfb10 = ' ' 
        LET  g_tlfb.tlfb11 = g_prog
        LET  g_tlfb.tlfb13 = g_user
        LET  g_tlfb.tlfb14 = g_today
        LET  g_tlfb.tlfb15 = g_time 
        LET  g_tlfb.tlfb16 = 'PDA'
        SELECT to_char(g_today,'hh24:mi:ss') INTO g_tlfb.tlfb15 from dual
        LET  g_tlfb.tlfb905= g_imm01
        LET  g_tlfb.tlfb906= ' '         
        LET  g_tlfb.tlfb17 = ' '             #杂发理由码
        LET  g_tlfb.tlfb18 = ' '             #产品分类码 
        LET  g_tlfb.tlfb19 ='Y'               #扣账否为N
        LET  g_tlfb.tlfbuser = g_user
        LET  g_tlfb.tlfblegal = g_legal
        LET  g_tlfb.tlfbplant = g_plant
#        CALL s_web_tlfb('','','','','')                 #更新条码异动档
            LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'tlfb_file'),
                " (tlfb01,tlfb02,tlfb03,tlfb04,tlfb05, ",
                "  tlfb06,tlfb07,tlfb08,tlfb09,tlfb10,tlfb11, ",
                "  tlfb12,tlfb13,tlfb14,tlfb15,tlfb16,tlfb17, ",
                "  tlfb18,                                    ",
                "  tlfb19,                                    ",
                "  tlfbuser,tlfbgrup,tlfbplant,tlfblegal,tlfb905,tlfb906)     ",
                "VALUES(?,?,?,?,?,  ?,?,?,?,?,    ",
                "       ?,?,?,?,?,  ?,?,?,?,?,    ",
                "       ?,?,?,?,?)                 "
    PREPARE ins_prep FROM g_sql
    EXECUTE ins_prep USING 
          g_tlfb.tlfb01,g_tlfb.tlfb02,
          g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,
          g_tlfb.tlfb07,g_tlfb.tlfb08,g_tlfb.tlfb09,g_tlfb.tlfb10,
          g_tlfb.tlfb11,g_tlfb.tlfb12,g_tlfb.tlfb13,g_tlfb.tlfb14,
          g_tlfb.tlfb15,g_tlfb.tlfb16,g_tlfb.tlfb17,g_tlfb.tlfb18,g_tlfb.tlfb19,
          g_tlfb.tlfbuser,g_tlfb.tlfbgrup,g_tlfb.tlfbplant,g_tlfb.tlfblegal,g_tlfb.tlfb905,g_tlfb.tlfb906
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       IF g_bgerr THEN
          CALL s_errmsg('tlfb12',g_tlfb.tlfb12,'s_tlfb:ins tlfb',STATUS,1)
       ELSE
           CALL cl_err3("ins","tlfb_file",g_tlfb.tlfb01,"",STATUS,"","",1) 
       END IF
       LET g_success='N'
       LET g_status.code = -1
       LET g_status.sqlcode = SQLCA.SQLCODE
       LET g_status.description="插入tlfb_file有误!"
       RETURN
    END IF
        
        LET g_sql =" SELECT COUNT(*) FROM imgb_file ",
                      "WHERE imgb01='",g_tlfb.tlfb01,"'",
                      " AND imgb02='",g_tlfb.tlfb02,"'",
                      " AND imgb03='",g_tlfb.tlfb03,"'" ,
                      " AND imgb04='",g_tlfb.tlfb04,"'"
                      
           PREPARE i510_imgb_pre FROM g_sql
           EXECUTE i510_imgb_pre INTO l_n
           IF l_n = 0 THEN #没有imgb_file，新增imgb_file
              CALL s_ins_imgb(g_tlfb.tlfb01,
                    g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
           ELSE
              CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
               g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
               g_tlfb.tlfb05,g_tlfb.tlfb06,'') 
           END IF
                
     END FOREACH
   
   LET g_prog='csft511'
   CALL i511_post()
   LET g_prog='aws_ttsrv2'
   IF g_success = "N" THEN 
   	  LET g_status.code = -1
   	  IF cl_null(g_status.description) THEN 
         LET g_status.description="过账失败!"
      END IF    
      RETURN
   END IF 	
   
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE
   	  ROLLBACK WORK
   END IF
END FUNCTION

#-->撥出更新
FUNCTION t512_s_sub_t(p_tc_imm,p_tc_imq)
   DEFINE p_tc_imq         RECORD LIKE tc_imq_file.*,
          l_img            RECORD
          img16            LIKE img_file.img16,
          img23            LIKE img_file.img23,
          img24            LIKE img_file.img24,
          img09            LIKE img_file.img09,
          img21            LIKE img_file.img21
                        END RECORD,
          l_qty         LIKE img_file.img10,
          l_factor      LIKE ima_file.ima31_fac 
   DEFINE l_forupd_sql  STRING              
   DEFINE p_tc_imm      RECORD LIKE tc_imm_file.*
   DEFINE l_cnt         LIKE type_file.num5  
   DEFINE l_ima25       LIKE ima_file.ima25

   IF cl_null(p_tc_imq.tc_imq07) THEN LET p_tc_imq.tc_imq07=' ' END IF
   #IF cl_null(p_tc_imq.tc_imq08) THEN LET p_tc_imq.tc_imq07=' ' END IF  #mark by guanyao160923
   IF cl_null(p_tc_imq.tc_imq08) THEN LET p_tc_imq.tc_imq08=' ' END IF 

   LET l_forupd_sql =
       "SELECT img16,img23,img24,img09,img21,img26,img10 FROM img_file ",
       " WHERE img01= ? AND img02=  ? AND img03= ? AND img04=  ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)

   DECLARE img_lock CURSOR FROM l_forupd_sql
 
   OPEN img_lock USING p_tc_imq.tc_imq05,p_tc_imq.tc_imq06,p_tc_imq.tc_imq07,p_tc_imq.tc_imq08
   IF SQLCA.sqlcode THEN
      CALL cl_err("img_lock fail:", STATUS, 1)
      LET g_success = 'N'
      RETURN 1
   ELSE
      FETCH img_lock INTO l_img.*,g_debit,g_img10
      IF SQLCA.sqlcode THEN
         CALL cl_err("sel img_file", STATUS, 1)
         LET g_success = 'N'
         RETURN 1
      END IF
   END IF

   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq09,l_img.img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_tc_imq.tc_imq14 * l_factor

   #-->更新倉庫庫存明細資料
   CALL s_upimg(p_tc_imq.tc_imq05,p_tc_imq.tc_imq06,p_tc_imq.tc_imq07,p_tc_imq.tc_imq08,-1,l_qty,p_tc_imm.tc_immud13,
       '','','','',p_tc_imq.tc_imq01,p_tc_imq.tc_imq02,'','','','','','','','','','','','')

   IF g_success = 'N' THEN RETURN 1 END IF

   #-->若庫存異動後其庫存量小於等於零時將該筆資料刪除
   CALL s_delimg(p_tc_imq.tc_imq05,p_tc_imq.tc_imq06,p_tc_imq.tc_imq07,p_tc_imq.tc_imq08)
 
   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)

   LET l_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ?  FOR UPDATE "  
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock CURSOR FROM l_forupd_sql

   OPEN ima_lock USING p_tc_imq.tc_imq05
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   FETCH ima_lock INTO l_ima25
   IF STATUS THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   #-->料件庫存單位數量
   LET l_qty=p_tc_imq.tc_imq14 * l_img.img21
   IF cl_null(l_qty)  THEN RETURN 1 END IF

   IF s_udima(p_tc_imq.tc_imq05,             #料件編號
              l_img.img23,             #是否可用倉儲
              l_img.img24,             #是否為MRP可用倉儲
              l_qty,                   #調撥數量(換算為料件庫存單位)
              p_tc_imm.tc_immud13,
              -1)                      #表撥出
    THEN RETURN 1
       END IF
   IF g_success = 'N' THEN RETURN 1 END IF

   #-->將已鎖住之資料釋放出來
   CLOSE img_lock
   CLOSE ima_lock
 
   RETURN 0
END FUNCTION

FUNCTION t512_s_sub_t2(p_tc_imm,p_tc_imq)
   DEFINE p_tc_imq          RECORD LIKE tc_imq_file.*,
          l_img          RECORD
             img16          LIKE img_file.img16,
             img23          LIKE img_file.img23,
             img24          LIKE img_file.img24,
             img09          LIKE img_file.img09,
             img21          LIKE img_file.img21,
             img19          LIKE img_file.img19,
             img27          LIKE img_file.img27,
             img28          LIKE img_file.img28,
             img35          LIKE img_file.img35,
             img36          LIKE img_file.img36
                         END RECORD,
          l_factor       LIKE ima_file.ima31_fac,
          l_qty          LIKE img_file.img10
   DEFINE l_forupd_sql   STRING               
   DEFINE p_tc_imm       RECORD LIKE tc_imm_file.*
   DEFINE l_cnt          LIKE type_file.num5  
   DEFINE l_ima25_2      LIKE ima_file.ima25

   LET l_forupd_sql =
       "SELECT img15,img23,img24,img09,img21,img19,img27,",
              "img28,img35,img36,img26,img10 FROM img_file ",
       " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
       " FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE img2_lock CURSOR FROM l_forupd_sql

   OPEN img2_lock USING p_tc_imq.tc_imq05,p_tc_imq.tc_imq10,p_tc_imq.tc_imq11,p_tc_imq.tc_imq12
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock img2 fail',STATUS,1)
      LET g_success = 'N' RETURN 1
   END IF

   FETCH img2_lock INTO l_img.*,g_credit,g_img10_2
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock img2 fail',STATUS,1)
      LET g_success = 'N' RETURN 1
   END IF

   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)

   LET l_forupd_sql = "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE "
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima2_lock CURSOR FROM l_forupd_sql

   OPEN ima2_lock USING p_tc_imq.tc_imq05
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF
   FETCH ima2_lock INTO l_ima25_2
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ima fail',STATUS,1)
       LET g_success='N' RETURN  1
   END IF

   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq13,l_img.img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_tc_imq.tc_imq15 * l_factor

   CALL s_upimg(p_tc_imq.tc_imq05,p_tc_imq.tc_imq10,p_tc_imq.tc_imq11,p_tc_imq.tc_imq12,+1,l_qty,p_tc_imm.tc_immud13,
      p_tc_imq.tc_imq05,p_tc_imq.tc_imq10,p_tc_imq.tc_imq11,p_tc_imq.tc_imq12,
      p_tc_imq.tc_imq01,p_tc_imq.tc_imq02,l_img.img09,l_qty,      l_img.img09,
      1,  l_img.img21,1,
      g_credit,l_img.img35,l_img.img27,l_img.img28,l_img.img19,
      l_img.img36)

   IF g_success = 'N' THEN RETURN 1 END IF

   #-->更新庫存主檔之庫存數量 (單位為主檔之庫存單位)
   LET l_qty = p_tc_imq.tc_imq15 * l_img.img21
   IF s_udima(p_tc_imq.tc_imq05,            #料件編號
              l_img.img23,            #是否可用倉儲
              l_img.img24,            #是否為MRP可用倉儲
              l_qty,                  #發料數量(換算為料件庫存單位)
              p_tc_imm.tc_immud13,    #FUN-D40053
              +1)                     #表收料
        THEN RETURN  1 END IF
   IF g_success = 'N' THEN RETURN 1 END IF
   
   #-->產生異動記錄檔
   #---- 97/06/20 insert 兩筆至 tlf_file 一出一入
   CALL t512_s_sub_log_2(1,0,'1',p_tc_imq.*,p_tc_imm.*) 
   CALL t512_s_sub_log_2(1,0,'0',p_tc_imq.*,p_tc_imm.*) 

   RETURN 0
END FUNCTION

FUNCTION t512_s_sub_log_2(p_stdc,p_reason,p_code,p_tc_imq,p_tc_imm)
   DEFINE p_stdc      LIKE type_file.num5,      #是否需取得標準成本
          p_reason    LIKE type_file.num5,      #是否需取得異動原因
          p_code      LIKE type_file.chr1,      #出/入庫
          p_tc_imq    RECORD LIKE tc_imq_file.*
   DEFINE l_img09     LIKE img_file.img09,
          l_factor    LIKE ima_file.ima31_fac,
          l_qty       LIKE img_file.img10
   DEFINE p_tc_imm    RECORD LIKE tc_imm_file.*
   DEFINE l_cnt       LIKE type_file.num5

   LET l_qty=0
   SELECT img09 INTO l_img09 FROM img_file
      WHERE img01=p_tc_imq.tc_imq05 AND img02=p_tc_imq.tc_imq10
        AND img03=p_tc_imq.tc_imq11 AND img04=p_tc_imq.tc_imq12
   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq09,l_img09) RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN
      CALL cl_err('','mfg3075',1)
      LET g_success = 'N'
      RETURN 1
   END IF
   LET l_qty = p_tc_imq.tc_imq14 * l_factor


   #----來源----
   LET g_tlf.tlf01=p_tc_imq.tc_imq05                 #異動料件編號
   LET g_tlf.tlf02=50                                #來源為倉庫(撥出)
   LET g_tlf.tlf020=g_plant                          #工廠別
   LET g_tlf.tlf021=p_tc_imq.tc_imq06                #倉庫別
   LET g_tlf.tlf022=p_tc_imq.tc_imq07                #儲位別
   LET g_tlf.tlf023=p_tc_imq.tc_imq08                #批號
   LET g_tlf.tlf024=g_img10 - p_tc_imq.tc_imq14      #異動後庫存數量
   LET g_tlf.tlf025=p_tc_imq.tc_imq09                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=p_tc_imq.tc_imq01                #調撥單號
   LET g_tlf.tlf027=p_tc_imq.tc_imq02                #項次
   #----目的----
   LET g_tlf.tlf03=50                                #資料目的為(撥入)
   LET g_tlf.tlf030=g_plant                          #工廠別
   LET g_tlf.tlf031=p_tc_imq.tc_imq10                #倉庫別
   LET g_tlf.tlf032=p_tc_imq.tc_imq11                #儲位別
   LET g_tlf.tlf033=p_tc_imq.tc_imq12                #批號
    LET g_tlf.tlf034=g_img10_2 + l_qty               #異動後庫存量    #-No:MOD-57002
   LET g_tlf.tlf035=p_tc_imq.tc_imq13                #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=p_tc_imq.tc_imq01                #參考號碼
   LET g_tlf.tlf037=p_tc_imq.tc_imq02                #項次

   #---- 97/06/20 調撥作業來源目的碼
   IF p_code='1' THEN #-- 出
      LET g_tlf.tlf02=50
      LET g_tlf.tlf03=99
      LET g_tlf.tlf030=' '
      LET g_tlf.tlf031=' '
      LET g_tlf.tlf032=' '
      LET g_tlf.tlf033=' '
      LET g_tlf.tlf034=0
      LET g_tlf.tlf035=' '
      LET g_tlf.tlf036=' '
      LET g_tlf.tlf037=0
      LET g_tlf.tlf10=p_tc_imq.tc_imq14           #調撥數量
      LET g_tlf.tlf11=p_tc_imq.tc_imq09           #撥出單位
      LET g_tlf.tlf12=1                           #撥出/撥入庫存轉換率
      LET g_tlf.tlf930=p_tc_imm.tc_imm14
   ELSE               #-- 入
      LET g_tlf.tlf02=99
      LET g_tlf.tlf03=50
      LET g_tlf.tlf020=' '
      LET g_tlf.tlf021=' '
      LET g_tlf.tlf022=' '
      LET g_tlf.tlf023=' '
      LET g_tlf.tlf024=0
      LET g_tlf.tlf025=' '
      LET g_tlf.tlf026=' '
      LET g_tlf.tlf027=0
      LET g_tlf.tlf10=p_tc_imq.tc_imq15           #調撥數量
      LET g_tlf.tlf11=p_tc_imq.tc_imq13           #撥入單位
      LET g_tlf.tlf12=1                           #撥入/撥出庫存轉換率
      LET g_tlf.tlf930=p_tc_imm.tc_imm14
   END IF

   #--->異動數量
   LET g_tlf.tlf04=' '                         #工作站
   LET g_tlf.tlf05=' '                         #作業序號
   LET g_tlf.tlf06=p_tc_imm.tc_immud13
   LET g_tlf.tlf07=g_today                     #異動資料產生日期
   LET g_tlf.tlf08=TIME                        #異動資料產生時:分:秒
   LET g_tlf.tlf09=g_user                      #產生人
   LET g_tlf.tlf13='csft512'                   #異動命令代號
   LET g_tlf.tlf14=p_tc_imq.tc_imq17           #異動原因
   LET g_tlf.tlf15=g_debit                     #借方會計科目
   LET g_tlf.tlf16=g_credit                    #貸方會計科目
   LET g_tlf.tlf17=p_tc_imm.tc_imm09                 #remark
   CALL s_imaQOH(p_tc_imq.tc_imq05)
        RETURNING g_tlf.tlf18                  #異動後總庫存量
   #LET g_tlf.tlf19= ' '                       #異動廠商/客戶編號      #MOD-A80004 mark
   LET g_tlf.tlf19= p_tc_imm.tc_imm14          #異動廠商/客戶編號      #MOD-A80004 add
   LET g_tlf.tlf20= ' '                        #project no.
   CALL s_tlf(p_stdc,p_reason)
END FUNCTION


FUNCTION i511_post()
DEFINE l_cnt    LIKE type_file.num10
DEFINE l_sql    LIKE type_file.chr1000
DEFINE p_inTransaction  LIKE type_file.num5
DEFINE l_imn10  LIKE imn_file.imn10
DEFINE l_imn29  LIKE imn_file.imn29
DEFINE l_imn03  LIKE imn_file.imn03
DEFINE l_qcs01  LIKE qcs_file.qcs01
DEFINE l_qcs02  LIKE qcs_file.qcs02
DEFINE l_imd11  LIKE imd_file.imd11
DEFINE l_imd11_1 LIKE imd_file.imd11
DEFINE l_flag    LIKE type_file.num5
DEFINE l_result LIKE type_file.chr1
DEFINE l_date   LIKE type_file.dat    
DEFINE l_img37     LIKE img_file.img37
DEFINE l_cnt_img   LIKE type_file.num5
DEFINE l_cnt_imgg  LIKE type_file.num5
DEFINE l_sel    LIKE type_file.num5   
DEFINE l_t1     LIKE smy_file.smyslip 
DEFINE l_ima906 LIKE ima_file.ima906  
DEFINE p_imm01     LIKE imm_file.imm01   
DEFINE p_argv2     LIKE type_file.chr1
DEFINE p_argv4     STRING
DEFINE l_tc_imm    RECORD LIKE tc_imm_file.*
DEFINE l_tc_imq    RECORD LIKE tc_imq_file.* 
DEFINE l_yy,l_mm   LIKE type_file.num5 
DEFINE l_imm01     LIKE imm_file.imm01
DEFINE l_unit_arr  DYNAMIC ARRAY OF RECORD  
          unit        LIKE ima_file.ima25,
          fac         LIKE img_file.img21,
          qty         LIKE img_file.img10
                   END RECORD
DEFINE l_msg       LIKE type_file.chr1000
DEFINE l_cmd       LIKE type_file.chr1000
DEFINE l_qcs091    LIKE qcs_file.qcs091
DEFINE l_imni      RECORD LIKE imni_file.*
DEFINE l_immud13_t LIKE type_file.dat
   
   WHENEVER ERROR CONTINUE   
   SELECT * INTO g_tc_imm.* FROM tc_imm_file
    WHERE tc_imm01 = g_imm01

   IF g_tc_imm.tc_immconf = 'N' THEN #FUN-660029
   	   LET g_success ='N'
       LET g_status.code = "-1"
       LET g_status.description = "本资料尚未审核，不可过账!"
       RETURN
   END IF

   IF g_tc_imm.tc_imm03 = 'Y' THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "此资料已过账!"
      RETURN
   END IF

   IF g_tc_imm.tc_immconf = 'X' THEN #FUN-660029
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "此笔资料已作废!"
      RETURN
   END IF

   IF g_sma.sma53 IS NOT NULL AND g_tc_imm.tc_imm02 <= g_sma.sma53 THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "异动日期不可小於关账日期, 请重新录入!"
      RETURN
   END IF


   UPDATE tc_imm_file SET tc_immud13 = g_tc_imm.tc_immud13
    WHERE tc_imm01 = g_tc_imm.tc_imm01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('tc_imm01',g_tc_imm.tc_imm01,'up tc_imm_file',SQLCA.sqlcode,1)
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = 'tc_imm01',g_tc_imm.tc_imm01,'up tc_imm_file',SQLCA.sqlcode
      RETURN
   END IF

   DECLARE t512sub_s1_c CURSOR FOR
     SELECT * FROM tc_imq_file WHERE tc_imq01=g_tc_imm.tc_imm01
  
   LET g_success = 'Y'
   

   FOREACH t512sub_s1_c INTO l_tc_imq.*
      IF STATUS THEN EXIT FOREACH END IF

#      LET l_cmd= 's_ read parts:',l_tc_imq.tc_imq05
#      CALL cl_msg(l_cmd)
--    
      #str-----add by guanyao160922
      IF l_tc_imq.tc_imq06 = '欠量' OR l_tc_imq.tc_imq18 = '欠量'  THEN 
         LET g_success = 'N'
         LET g_status.code = "-1"
         LET g_status.description = l_tc_imq.tc_imq02,"有'欠量'数据，请先删除！"
         RETURN
      END IF  
      #end-----add by guanyao160922
      #撥入倉
      LET l_imd11 = ''
      SELECT imd11 INTO l_imd11 FROM imd_file 
       WHERE imd01 = l_tc_imq.tc_imq10

      #撥出倉
      LET l_imd11_1 = ''
      SELECT imd11 INTO l_imd11_1 FROM imd_file 
       WHERE imd01 = l_tc_imq.tc_imq06
      IF l_imd11_1 = 'Y' AND (l_imd11 = 'N' OR l_imd11 IS NULL) THEN 
         CALL t512_s_sub_chk_avl_stk(l_tc_imq.*)     
         IF g_success='N' THEN
            RETURN    
         END IF    
      END IF   

      #撥出倉庫過賬權限檢查
      CALL s_incchk(l_tc_imq.tc_imq06,l_tc_imq.tc_imq07,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_tc_imq.tc_imq05,"/",l_tc_imq.tc_imq06,"/",l_tc_imq.tc_imq07,"/",g_user
         CALL s_errmsg("tc_imq05/tc_imq06/tc_imq07/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF

      #撥入倉庫過賬權限檢查
      CALL s_incchk(l_tc_imq.tc_imq10,l_tc_imq.tc_imq11,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_tc_imq.tc_imq05,"/",l_tc_imq.tc_imq10,"/",l_tc_imq.tc_imq11,"/",g_user
         CALL s_errmsg("tc_imq05/tc_imq10/tc_imq11/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF

      IF cl_null(l_tc_imq.tc_imq06) THEN CONTINUE FOREACH END IF   
 
      SELECT *
        FROM img_file WHERE img01=l_tc_imq.tc_imq05 AND
                            img02=l_tc_imq.tc_imq10 AND
                            img03=l_tc_imq.tc_imq11 AND
                            img04=l_tc_imq.tc_imq12
      IF SQLCA.sqlcode THEN
         IF l_tc_imq.tc_imq07 IS NULL THEN LET l_tc_imq.tc_imq07 =' ' END IF
         IF l_tc_imq.tc_imq08 IS NULL THEN LET l_tc_imq.tc_imq08 =' ' END IF
            SELECT img18,img37 INTO l_date,l_img37 FROM img_file
             WHERE img01 = l_tc_imq.tc_imq05
               AND img02 = l_tc_imq.tc_imq06
               AND img03 = l_tc_imq.tc_imq07
               AND img04 = l_tc_imq.tc_imq08
           IF STATUS=100 THEN 
              LET g_status.code = "-1"
              LET g_status.description =cl_getmsg('mfg6101',g_lang) 
              LET g_success ='N'
              RETURN
           ELSE
              CALL s_date_record(l_date,'Y')
           END IF
            CALL s_idledate_record(l_img37)
            CALL s_add_img(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                           l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                           l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,
                           g_tc_imm.tc_immud13)
      END IF

      #不做sma892[3,3]提示的处理，前FUN-C70087单号已增加
      IF g_sma.sma115 = 'Y' THEN
         LET l_ima906=''
         SELECT ima906 INTO l_ima906 FROM ima_file
          WHERE ima01 = l_tc_imq.tc_imq05
         #母子单位 单位一  --begin
         IF l_ima906 = '2' THEN
            CALL s_chk_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                            l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                            l_tc_imq.tc_imq13) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                               l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                               l_tc_imq.tc_imq13,l_tc_imq.tc_imq13,
                               l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,0)
                    RETURNING l_flag
               IF l_flag = 1 THEN
                  LET g_totsuccess="N"
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         #母子单位 单位一  --end
         #母子单位&参考单位 单位二  --begin
         IF l_ima906 MATCHES '[23]' THEN
            CALL s_chk_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                            l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                            l_tc_imq.tc_imq13) RETURNING l_flag
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_tc_imq.tc_imq05,l_tc_imq.tc_imq10,
                               l_tc_imq.tc_imq11,l_tc_imq.tc_imq12,
                               l_tc_imq.tc_imq13,l_tc_imq.tc_imq13,
                               l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,0)
                    RETURNING l_flag
               IF l_flag = 1 THEN
                  LET g_totsuccess="N"
                  CONTINUE FOREACH
               END IF
            END IF
         END IF
         #母子单位&参考单位 单位二  --end
      END IF

       IF NOT s_stkminus(l_tc_imq.tc_imq05,l_tc_imq.tc_imq06,l_tc_imq.tc_imq07,l_tc_imq.tc_imq08,
                         l_tc_imq.tc_imq14,1,g_tc_imm.tc_immud13) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH
      END IF

      #-->撥出更新
      IF t512_s_sub_t(g_tc_imm.*,l_tc_imq.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH
      END IF

      #IF g_sma.sma115 = 'Y' THEN#此处只有一个库存单位
      #   CALL t512sub_upd_s(l_tc_imq.*,g_tc_imm.*)
      #END IF

      IF g_success = 'N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF

      #-->撥入更新
      IF t512_s_sub_t2(g_tc_imm.*,l_tc_imq.*) THEN
         LET g_totsuccess="N"
         CONTINUE FOREACH
      END IF

      #IF g_sma.sma115 = 'Y' THEN
      #   CALL t512sub_upd_t(l_imn.*,l_imm.*)
      #END IF

      CALL s_updsie_sie(l_tc_imq.tc_imq01,l_tc_imq.tc_imq02,'4')

      IF g_success = 'N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
 
   END FOREACH

   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()
   #str----add by guanyao160922
   IF g_success = 'Y' THEN 
      CALL t512_s_sub_t3()
   END IF 
   #end----add by guanyao160922
  
   UPDATE tc_imm_file SET tc_imm03 = 'Y'
    WHERE tc_imm01 = g_tc_imm.tc_imm01

   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      LET g_success ='N'
      LET g_status.code = "-1"
      LET g_status.description = "更新imm_file有误!"
      RETURN
   END IF

END FUNCTION	
	
FUNCTION t512_s_sub_chk_avl_stk(p_tc_imq)   
   DEFINE l_avl_stk,l_avl_stk_mpsmrp,l_unavl_stk  LIKE type_file.num15_3
   DEFINE l_oeb12   LIKE oeb_file.oeb12
   DEFINE l_qoh     LIKE oeb_file.oeb12 
   DEFINE p_tc_imq  RECORD LIKE tc_imq_file.*   
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE l_sw      LIKE type_file.num5
   DEFINE l_factor  LIKE img_file.img21
   DEFINE l_msg     LIKE type_file.chr1000
   DEFINE l_imd23   LIKE imd_file.imd23

      
   CALL s_getstock(p_tc_imq.tc_imq05,g_plant)
      RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   
   
   LET l_oeb12 = 0
   SELECT SUM(oeb905*oeb05_fac)
    INTO l_oeb12
    FROM oeb_file,oea_file   
   WHERE oeb04=p_tc_imq.tc_imq05
     AND oeb19= 'Y'
     AND oeb70= 'N'  
     AND oea01 = oeb01 AND oeaconf !='X' 
   IF l_oeb12 IS NULL THEN
      LET l_oeb12 = 0
   END IF
   
   LET l_qoh = l_avl_stk - l_oeb12
   
   SELECT ima25 INTO l_ima25 FROM ima_file
     WHERE ima01 = p_tc_imq.tc_imq05
   CALL s_umfchk(p_tc_imq.tc_imq05,p_tc_imq.tc_imq09,l_ima25)
        RETURNING l_sw,l_factor

   INITIALIZE l_imd23 TO NULL 
   CALL s_inv_shrt_by_warehouse(p_tc_imq.tc_imq06,g_plant) RETURNING l_imd23
   IF l_qoh < p_tc_imq.tc_imq14*l_factor AND l_imd23 = 'N' THEN

      LET l_msg = 'Line#',p_tc_imq.tc_imq02 USING '<<<',' ',
                   p_tc_imq.tc_imq05 CLIPPED,'-> QOH < 0 '
#      CALL cl_err(l_msg,'mfg-075',1)  
      LET g_status.code = "-1"
      LET g_status.description = l_msg,"调拨量 > (库存量-备置量) 无法调拨, 请重新输入 !" 
      LET g_success='N' 
      RETURN
   END IF 
END FUNCTION	

FUNCTION t512_s_sub_t3()
DEFINE l_sql   STRING 
DEFINE sr   RECORD 
     tc_imq03    LIKE tc_imq_file.tc_imq03,
     tc_imq04    LIKE tc_imq_file.tc_imq04,
     tc_imq05    LIKE tc_imq_file.tc_imq05,
     tc_imq15    LIKE tc_imq_file.tc_imq15
   END RECORD  
           

     LET l_sql = "SELECT tc_imq03,tc_imq04,tc_imq05,SUM(tc_imq15) ",
                 "  FROM tc_imq_file",
                 " WHERE tc_imq01 = '",g_tc_imm.tc_imm01,"'",
                 " GROUP BY tc_imq03,tc_imq04,tc_imq05"
     PREPARE i511_up_p FROM l_sql
     DECLARE i511_up_c CURSOR FOR i511_up_p
     FOREACH i511_up_c INTO sr.*
        IF sr.tc_imq15 >0 THEN 
           UPDATE tc_imp_file SET tc_imp09 = sr.tc_imq15 
            WHERE tc_imp01 = g_tc_imm.tc_imm01
              AND tc_imp03 = sr.tc_imq03
              AND tc_imp04 = sr.tc_imq04
              AND tc_imp05 = sr.tc_imq05
           IF SQLCA.sqlcode THEN
              LET g_success ='N'
              LET g_status.code = "-1"
              LET g_status.description = "更新tc_imp_file有误!"
              RETURN
           END IF
        END IF 
     END FOREACH 
                  
END FUNCTION 
