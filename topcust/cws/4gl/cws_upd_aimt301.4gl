# Prog. Version..: '5.30.06-13.03.12(00000)'
#
# Pattern name...: cws_upd_aimt301.4gl
# Descriptions...: 根据已有的杂发单审核过账
# Date & Author..:2016-05-26 15:03:09  shenran
# MOD            : 20170802 by nihuan

DATABASE ds                                               
                                                           
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"              
GLOBALS "../../../tiptop/aba/4gl/barcode.global"       
    
GLOBALS 
DEFINE g_ina01_1    LIKE ina_file.ina01  #杂发单号
DEFINE g_ina      RECORD LIKE ina_file.*                   
DEFINE g_buf      LIKE type_file.chr2                      
DEFINE li_result  LIKE type_file.num5                      
DEFINE g_sql      STRING                                                                                     
DEFINE g_cnt     LIKE type_file.num5                       
DEFINE g_rec_b,g_rec_b1,g_rec_b2   LIKE type_file.num5     
DEFINE g_rec_b_1 LIKE type_file.num5                       
DEFINE l_ac      LIKE type_file.num10                      
DEFINE l_ac_t    LIKE type_file.num10                      
DEFINE li_step   LIKE type_file.num5
DEFINE g_ina301   RECORD
                 ina01 LIKE ina_file.ina01
                 END RECORD                      
#add by lili 170109 ---s---
DEFINE g_uid        STRING
DEFINE g_service    STRING
#add by lili 170109 ---e---                      
END GLOBALS                                                          

FUNCTION  cws_upd_aimt301_g()                                                                      
DEFINE l_str     STRING   #add by lili 170109
DEFINE l_stime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_etime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_costtime INTERVAL HOUR TO FRACTION(3)
DEFINE l_stimestr STRING
DEFINE l_etimestr STRING
DEFINE l_logfile  STRING
                                                                                                   
 WHENEVER ERROR CONTINUE                                                                           
                                                                                                   
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序                                           
    
    #add by lili 170109 ---s---
    LET g_service = "cws_upd_aimt301"

    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile) 
    #add by lili 170109 ---e---             
    IF g_status.code = "0" THEN                                                                    
       CALL cws_upd_aimt301_process()                                                           
    END IF                                                                                         
    #add by lili 170109 ---s---	                                                                                        
    LET l_etimestr = CURRENT HOUR TO FRACTION(3)
    LET l_etime = l_etimestr
    LET l_str = g_uid," ",g_service," ",l_etimestr," End"
    CALL writeStringToFile(l_str,l_logfile)
    #add by lili 170109 ---e---
                                                                                                   
    LET l_costtime = l_etime - l_stime
    LET l_str = g_uid," ",g_service," ",l_costtime," Cost"
    CALL writeStringToFile(l_str,l_logfile)
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序                                                                                                            
     DROP TABLE i301_file1                                                                         
END FUNCTION                                                                                       
                                                                                                                                                                                              
FUNCTION cws_upd_aimt301_process() 
   DEFINE l_i          LIKE type_file.num10,
          l_j          LIKE type_file.num10,
          l_k          LIKE type_file.num10
   DEFINE l_cnt        LIKE type_file.num10,
          l_cnt1       LIKE type_file.num10,
          l_cnt2       LIKE type_file.num10,
          l_cnt3       LIKE type_file.num10
   DEFINE l_cnt4       LIKE type_file.num10
   DEFINE l_node1      om.DomNode,
          l_node2      om.DomNode,
          l_node3      om.DomNode         
   DEFINE l_success    CHAR(1)
   DEFINE l_factor     DECIMAL(16,8)
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_img10      LIKE img_file.img10
   DEFINE l_ima108     LIKE ima_file.ima108
   DEFINE l_sr         STRING
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
   DEFINE l_ogb03      LIKE ogb_file.ogb03
   DEFINE l_ima021     LIKE ima_file.ima021   
   DEFINE l_ogb12a     LIKE ogb_file.ogb12
   DEFINE l_num        LIKE type_file.num5
   DEFINE #l_ibb17      LIKE ibb_file.ibb17,
          l_sfa01      LIKE sfa_file.sfa01,
          l_sfa03      LIKE sfa_file.sfa03,
          l_sfa05      LIKE sfa_file.sfa05,
          l_sfaiicd03  LIKE sfai_file.sfaiicd03,
          temp_sum     LIKE ibb_file.ibb07
   DEFINE l_sql        STRING
   DEFINE l_no         LIKE ogb_file.ogb03,
          l_ogb01      LIKE ogb_file.ogb01,
          l_ogb092     LIKE ogb_file.ogb092                                                                                                                            
  DEFINE  l_i301_file1     RECORD    
  	               ina01   LIKE ina_file.ina01,      #单号           
                   barcode LIKE type_file.chr50,     #批次条码   
                   ima01   LIKE ima_file.ima01,      #料件编号   
                   batch   LIKE type_file.chr50,     #批次
                   inb05   LIKE inb_file.inb05,      #仓库 
                   inb06   LIKE inb_file.inb06,      #库位         
                   inb16a  LIKE inb_file.inb16       #数量       
                 END RECORD                                                                        
   DROP TABLE i301_file                                                                            
   DROP TABLE i301_file1
                                                 
   CREATE TEMP TABLE i301_file1(         
                  ina01   LIKE ina_file.ina01,      #单号                                                          
                  barcode LIKE type_file.chr50,     #批次条码   
                  ima01   LIKE ima_file.ima01,      #料件编号   
                  batch   LIKE type_file.chr50,     #批次 
                  inb05   LIKE inb_file.inb05,      #仓库
                  inb06   LIKE inb_file.inb06,      #库位         
                  inb16a  LIKE inb_file.inb16)      #数量
                  
   DROP TABLE aimt301_temp
   LET l_sql ="CREATE GLOBAL TEMPORARY TABLE aimt301_temp AS SELECT * FROM inb_file WHERE 1=2"
   PREPARE aimt301_temp_work_tab FROM l_sql
   EXECUTE aimt301_temp_work_tab                
  #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    INITIALIZE g_ina301.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("ina_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF

    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "ina_file")       #目前處理單檔的 XML 節點

        LET g_ina01_1 = aws_ttsrv_getRecordField(l_node1,"ina01")   

        #----------------------------------------------------------------------#
        # 處理第二單身資料                                                         #
        #----------------------------------------------------------------------#        
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "detail_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_j = 1 TO l_cnt3                                                                      
        INITIALIZE l_i301_file1.* TO NULL                                                       
        LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_j,"detail_file")   #目前                 
            LET l_i301_file1.ina01 = g_ina01_1
            LET l_i301_file1.barcode = aws_ttsrv_getRecordField(l_node3, "barcode") 
            CALL cs_get_barcode_info(l_i301_file1.barcode)
#            IF g_return.stat = 5 OR g_return.stat = 4 THEN #add by yanyl 170215 g_return.stat = 4  
#               SELECT instr(l_i301_file1.barcode, '%',1,2) INTO l_cnt4 FROM DUAL #找第二个%的位置
#               LET l_i301_file1.barcode = l_i301_file1.barcode[1,l_cnt4-1]
#            END IF                                             
            LET l_i301_file1.ima01   = aws_ttsrv_getRecordField(l_node3, "ima01")                    
            LET l_i301_file1.batch   = aws_ttsrv_getRecordField(l_node3, "batch")
            LET l_i301_file1.inb05   = aws_ttsrv_getRecordField(l_node3, "inb05")
            LET l_i301_file1.inb06   = aws_ttsrv_getRecordField(l_node3, "inb06")             
            LET l_i301_file1.inb16a  = aws_ttsrv_getRecordField(l_node3, "qty")                       
            INSERT INTO i301_file1 VALUES (l_i301_file1.*)                                                   
        END FOR 
       IF g_status.code='0' THEN
          CALL cws_upd_i301_load()

          #IF g_success = 'Y' THEN
          #   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_ina301))
          #END IF
       END IF   
    END FOR
     
END FUNCTION
                                                                                           
FUNCTION cws_upd_i301_load()
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_t         LIKE type_file.num5
   DEFINE l_img09     LIKE img_file.img09
   DEFINE l_ogb01a    LIKE ogb_file.ogb01
   DEFINE l_flag0     LIKE type_file.chr1,
          l_sfa01     LIKE sfa_file.sfa01,
          l_sfb01     LIKE sfb_file.sfb01
   DEFINE l_ibb01     LIKE ibb_file.ibb01
   DEFINE l_sfa03     LIKE sfa_file.sfa03
   DEFINE l_sfa30     LIKE sfa_file.sfa30
   DEFINE l_sfa31     LIKE sfa_file.sfa31
   DEFINE l_sfaiicd03 LIKE type_file.chr100
   DEFINE l_ibb07     LIKE ibb_file.ibb07
   DEFINE l_barcode   LIKE type_file.chr50
   DEFINE l_ima01     LIKE ima_file.ima01
   DEFINE l_batch     LIKE type_file.chr50
   DEFINE l_inb05     LIKE inb_file.inb05      #仓库
   DEFINE l_inb06     LIKE inb_file.inb06
   DEFINE l_inb16a    LIKE inb_file.inb16
   DEFINE l_iba       RECORD LIKE iba_file.*
   DEFINE l_ibb       RECORD LIKE ibb_file.*

    
    LET g_success = "Y"

     BEGIN WORK
     IF g_success = "Y" THEN

        INITIALIZE g_tlfb.* TO NULL
        INITIALIZE l_iba.* TO NULL
        INITIALIZE l_ibb.* TO NULL
        LET g_sql ="select barcode,ima01,batch,inb05,inb06,inb16a from i301_file1"
            PREPARE t001_ipb_iba FROM g_sql
            DECLARE t001_iba CURSOR FOR t001_ipb_iba
            FOREACH t001_iba INTO l_barcode,l_ima01,l_batch,l_inb05,l_inb06,l_inb16a
              IF STATUS THEN
               EXIT FOREACH
              END IF
              SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_barcode
              SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_barcode
              IF cl_null(l_n) THEN LET l_n=0 END IF
              IF cl_null(l_t) THEN LET l_t=0 END IF
              IF l_n=0 AND l_t=0 THEN
                    LET l_iba.iba01=l_barcode
                    INSERT INTO iba_file VALUES(l_iba.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        LET g_success = 'N'
                        LET g_status.code = "-1"
                        LET g_status.description = "插入iba_file有误!"
                        RETURN
                    END IF
                    LET l_ibb.ibb01=l_barcode      #条码编号
                    LET l_ibb.ibb02='K'            #条码产生时机点
                    LET l_ibb.ibb03=g_ina01_1    #来源单号
                    LET l_ibb.ibb04=0              #来源项次
                    LET l_ibb.ibb05=0              #包号
                    LET l_ibb.ibb06=l_ima01        #料号
                    LET l_ibb.ibb11='Y'            #使用否         
                    LET l_ibb.ibb12=0              #打印次数
                    LET l_ibb.ibb13=0              #检验批号(分批检验顺序)
                    LET l_ibb.ibbacti='Y'          #资料有效码
#                    LET l_ibb.ibb17=l_batch        #批号
#                    LET l_ibb.ibb14=l_inb16a       #数量
#                    LET l_ibb.ibb20=g_today        #生成日期
                    INSERT INTO ibb_file VALUES(l_ibb.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        LET g_success = 'N'
                        LET g_status.code = "-1"
                        LET g_status.description = "插入ibb_file有误!"
                        RETURN
                    END IF
              END IF

              LET  g_tlfb.tlfb01 = l_barcode
              #SELECT ime01 INTO g_tlfb.tlfb02 FROM ime_file WHERE ime02=l_inb06
              LET  g_tlfb.tlfb02 = l_inb05
              LET  g_tlfb.tlfb03 = l_inb06
              LET  g_tlfb.tlfb04 = l_batch
              LET  g_tlfb.tlfb05 = l_inb16a
              LET  g_tlfb.tlfb09 = g_ina01_1
              LET  g_tlfb.tlfb08 = 0 
              LET  g_tlfb.tlfb07 = g_ina01_1
              LET  g_tlfb.tlfb10 = ' '  
              LET  g_tlfb.tlfb905= g_ina01_1
              LET  g_tlfb.tlfb906= ' '         
              LET  g_tlfb.tlfb06 = -1   #入库
              LET  g_tlfb.tlfb16 = '条码枪'         
              LET  g_tlfb.tlfb17 = ' '             #杂发理由码
              LET  g_tlfb.tlfb18 = ' '             #产品分类码 
              LET  g_tlfb.tlfb19 ='Y'               #扣账否为N
              CALL s_web_tlfb('','','','','')  #更新条码异动档
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
     END IF
     LET g_prog="aimt301"

     IF g_success = "Y" THEN
        CALL exc_item_aimt301(g_ina01_1)
     END IF
     IF g_success = "Y" THEN   #过账检核
        CALL t370sub_s_chk(g_ina01_1,'Y',TRUE,g_today)    #CALL 原確認的 check 段 #FUN-B50138
        #CALL t370sub_s_chk(g_ina01_1,'Y',FALSE,'')
     END IF
     IF g_success = "Y" THEN   #过账
        CALL t370sub_s_upd(g_ina01_1,'1',TRUE)       #CALL 原確認的 update 段#FUN-B50138
     END IF
     LET g_prog="aws_ttsrv2"
     IF g_success = "Y" THEN
        COMMIT WORK
     ELSE 
     	  IF g_status.code = 0 THEN
     	  	 LET g_status.code=-1
   		     LET g_status.description="扣账失败，请检查条码OR料件库存及仓库是否正确！"
     	  END IF
   	    ROLLBACK WORK
     END IF
END FUNCTION                     

FUNCTION exc_item_aimt301(p_ina01)
DEFINE p_ina01       LIKE ina_file.ina01
DEFINE l_sql         STRING
DEFINE l_ina01       LIKE ina_file.ina01
DEFINE l_ima01       LIKE ima_file.ima01
DEFINE l_inb05_sum   LIKE inb_file.inb05
DEFINE l_inb06_sum   LIKE inb_file.inb06
DEFINE l_inb07_sum   LIKE inb_file.inb07
DEFINE l_inb09_sum   LIKE inb_file.inb09
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_inb03       LIKE inb_file.inb03
DEFINE l_inb05       LIKE inb_file.inb05
DEFINE l_inb09       LIKE inb_file.inb09
DEFINE l_inb         RECORD LIKE inb_file.*
   

     
   LET l_sql="insert into aimt301_temp select * from inb_file where inb01='",p_ina01,"'"
   PREPARE aimt301_temp_ins FROM l_sql
   EXECUTE aimt301_temp_ins
     
   DELETE FROM inb_file WHERE inb01=g_sfu01
   
   #汇总扫描数据
   LET l_sql = " SELECT ima01,inb05,inb06,inb07,SUM(inb16a) FROM i301_file1 WHERE ina01 = '",p_ina01 CLIPPED,"'GROUP BY ima01,inb05"
   PREPARE ina_pre FROM l_sql
   DECLARE ina_c CURSOR FOR ina_pre
   FOREACH ina_c INTO l_ima01,l_inb05_sum,l_inb06_sum,l_inb07_sum,l_inb09_sum
      IF l_inb05_sum=0 THEN 
      	 CONTINUE FOREACH 
      END IF 	
      
      LET l_sql ="select * from aimt301_temp where inb09>0 order by inb03"
      PREPARE t301_inb_nh FROM l_sql
      DECLARE t301_inb_curs_nh CURSOR FOR t301_inb_nh
      FOREACH t301_inb_curs_nh INTO l_inb.*
         IF l_inb09_sum=0 THEN #数量必相等,前端控制
            EXIT FOREACH 
         END IF 
         IF l_inb09_sum>=l_inb.inb09 THEN 
         	  LET l_inb09_sum=l_inb09_sum-l_inb.inb09
         	  UPDATE asft620_temp SET inb09=0
         	  WHERE inb01=l_inb.inb01 AND inb03=l_inb.inb03
         ELSE	 
         	  UPDATE asft620_temp SET inb09=l_inb.inb09-l_inb09_sum
           WHERE inb01=l_inb.inb01 AND inb03=l_inb.inb03
           LET l_inb.inb09=l_inb09_sum
           LET l_inb09_sum=0
         END IF
         
         SELECT MAX(inb03)+1 INTO l_inb.inb03 FROM inb_file WHERE inb01=l_gls_af07
         IF cl_null(l_inb.inb03) THEN 
         	 LET l_inb.inb03=1
         END IF 	
         LET l_inb.inb05=l_inb05_sum     #仓库
         LET l_inb.inb06=l_inb06_sum     #储位
         LET l_inb.inb07=l_inb07_sum     #批号
         LET l_inb.inb09=l_inb09_sum     #数量
         
         INSERT INTO inb_file VALUES(l_inb.*)
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
             LET g_success = 'N'
             LET g_status.code = "-1"
             LET g_status.description = "插入inb_file有误!"    
             ROLLBACK WORK   
             RETURN ''
         END IF
      END FOREACH 
      
   END FOREACH 

   UPDATE ina_file SET ina02 = g_today WHERE ina01 = p_ina01
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      LET g_status.code=-1
      LET g_status.description="更新杂发日期失败！"
   END IF


END FUNCTION
	
#add by lili 170109 ---s---
FUNCTION writeStringToFile(p_str,p_logname)
  DEFINE p_str      STRING
  DEFINE l_ch       base.Channel
  DEFINE p_logname  STRING
  DEFINE l_logFile  STRING
  
  IF p_logname IS NULL THEN
    LET l_logFile = "/u1/out/wscosttime.log"
  ELSE
    LET l_logFile = p_logname
  END IF
  LET l_ch = base.Channel.create()
  CALL l_ch.setDelimiter(NULL)
  CALL l_ch.openFile(l_logFile, "a")
  CALL l_ch.write(p_str)
END FUNCTION

FUNCTION getGuid()
  DEFINE l_uid       STRING
  DEFINE l_sb        base.StringBuffer
  LET l_uid = CURRENT HOUR TO FRACTION(5)
  LET l_sb = base.StringBuffer.create()
  CALL l_sb.append(l_uid)
  CALL l_sb.replace(":", "", 0)
  CALL l_sb.replace(".", "", 0)
  RETURN l_sb.toString()
END FUNCTION
#add by lili 170109 ---e---	
