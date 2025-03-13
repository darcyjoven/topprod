# Prog. Version..: '5.30.06-13.03.12(00000)'
#
# Pattern name...: cws_upd_axmt620.4gl
# Descriptions...: 一般出货单过账
# Date & Author..: 20161222 by gujq 

DATABASE ds                                               
                                                           
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"              
GLOBALS "../../../tiptop/aba/4gl/barcode.global"       
    
GLOBALS 
DEFINE g_ina01_1    LIKE ina_file.ina01  #杂发单号
DEFINE g_oga01_1    LIKE oga_file.oga01                   
DEFINE g_buf        LIKE type_file.chr2                      
DEFINE li_result    LIKE type_file.num5                      
DEFINE g_sql        STRING                                                                                     
DEFINE g_cnt        LIKE type_file.num5                       
DEFINE g_rec_b,g_rec_b1,g_rec_b2   LIKE type_file.num5     
DEFINE g_rec_b_1    LIKE type_file.num5                       
DEFINE l_ac         LIKE type_file.num10                      
DEFINE l_ac_t       LIKE type_file.num10                      
DEFINE li_step      LIKE type_file.num5
DEFINE g_oga_r   RECORD
                 oga01 LIKE oga_file.oga01
                 END RECORD                      
DEFINE g_uid        STRING          #add by lidj170109
DEFINE g_service    STRING          #add by lidj170109
DEFINE l_str        STRING          #add by lidj170109
DEFINE l_stime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_etime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_costtime INTERVAL HOUR TO FRACTION(3)
DEFINE l_stimestr STRING
DEFINE l_etimestr STRING
DEFINE l_logfile  STRING

DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
DEFINE g_ima930  LIKE ima_file.ima930  #DEV-D30040 add
DEFINE g_ima906  LIKE ima_file.ima906  #MOD-C50088
DEFINE g_forupd_sql    STRING
DEFINE p_success1    LIKE type_file.chr1     #No.TQC-7C0114
DEFINE   g_flag          LIKE type_file.chr1          #No.FUN-730057
DEFINE   g_flag2         LIKE type_file.chr1          #FUN-C80107 add
DEFINE   g_msg         LIKE type_file.chr1000  #No.FUN-7B0014
DEFINE g_inTransaction         LIKE type_file.chr1  #MOD-CA0131 add                      
END GLOBALS                                                          

FUNCTION  cws_upd_axmt620_g()                                                                      
                                                                                                   
 WHENEVER ERROR CONTINUE                                                                           
                                                                                                   
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序                                           
    
    #add by lidj170109-----str------
	  LET g_service = "cws_upd_axmt620"
    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile)
    #add by lidj170109-----end------               
    IF g_status.code = "0" THEN                                                                    
       CALL cws_upd_axmt620_process()                                                           
    END IF   
    #add by lidj170109-----str------
    LET l_etimestr = CURRENT HOUR TO FRACTION(3)
    LET l_etime = l_etimestr
    LET l_str = g_uid," ",g_service," ",l_etimestr," End"
    CALL writeStringToFile(l_str,l_logfile)
    #add by lidj170109-----end------					                                                                                      
                                                                                                   
    LET l_costtime = l_etime - l_stime
    LET l_str = g_uid," ",g_service," ",l_costtime," Cost"
    CALL writeStringToFile(l_str,l_logfile)
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序                                                                                                            
     DROP TABLE togb_file                                                                         
END FUNCTION                                                                                       
                                                                                                                                                                                              
FUNCTION cws_upd_axmt620_process() 
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
DEFINE l_ogb_file     RECORD    
	               ogb01   LIKE ina_file.ina01,      #单号           
                 barcode LIKE type_file.chr50,     #批次条码   
                 ima01   LIKE ima_file.ima01,      #料件编号   
                 batch   LIKE type_file.chr50,     #批次
                 ogb09   LIKE inb_file.inb05,      #仓库 
                 ogb091  LIKE inb_file.inb06,      #库位         
                 ogb12  LIKE inb_file.inb16       #数量       
               END RECORD
                                                 
   CREATE TEMP TABLE togb_file(         
                   ogb01    LIKE ina_file.ina01,     #单号           
                   barcode LIKE type_file.chr50,     #批次条码   
                   ima01   LIKE ima_file.ima01,      #料件编号   
                   batch   LIKE type_file.chr50,     #批次
                   ogb09   LIKE inb_file.inb05,      #仓库 
                   ogb091  LIKE inb_file.inb06,      #库位          
                   ogb12   LIKE inb_file.inb16)      #数量
                    
   #--------------------------------------------------------------------------#
   # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
   #--------------------------------------------------------------------------#
   SELECT * INTO g_pod.* FROM pod_file WHERE pod00='0' #add by liudong 170118 多角抛转需引用此参数
   SELECT * INTO g_oax.* FROM oax_file WHERE oax00='0' #add by liudong 170118
    INITIALIZE g_oga_r.* TO NULL
   LET l_cnt1 = aws_ttsrv_getMasterRecordLength("oga_file")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

   IF l_cnt1 = 0 THEN
      LET g_status.code = "-1"
      LET g_status.description = "No recordset processed!"
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   FOR l_i = 1 TO l_cnt1
      LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "oga_file")       #目前處理單檔的 XML 節點

      LET g_oga01_1 = aws_ttsrv_getRecordField(l_node1,"oga01")   

      #----------------------------------------------------------------------#
      # 處理第二單身資料                                                         #
      #----------------------------------------------------------------------#        
      LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "detail_file")       #取得目前單頭共有幾筆單身資料
      IF l_cnt3 = 0 THEN
         LET g_status.code = "mfg-009"   #必須有單身資料
         EXIT FOR
      END IF
      
      FOR l_j = 1 TO l_cnt3                                                                      
      INITIALIZE l_ogb_file.* TO NULL                                                       
      LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_j,"detail_file")   #目前                 
          LET l_ogb_file.ogb01 = g_oga01_1
          LET l_ogb_file.barcode = aws_ttsrv_getRecordField(l_node3, "barcode") 
          CALL cs_get_barcode_info(l_ogb_file.barcode)
#          IF g_return.stat = 5 OR g_return.stat = 4 THEN
#             SELECT instr(l_ogb_file.barcode, '%',1,2) INTO l_cnt4 FROM DUAL #找第二个%的位置
#             LET l_ogb_file.barcode = l_ogb_file.barcode[1,l_cnt4-1]
#          END IF                                             
          LET l_ogb_file.ima01   = aws_ttsrv_getRecordField(l_node3, "ima01")                    
          LET l_ogb_file.batch   = aws_ttsrv_getRecordField(l_node3, "batch")
          LET l_ogb_file.ogb09   = aws_ttsrv_getRecordField(l_node3, "ogb09")
          LET l_ogb_file.ogb091   = aws_ttsrv_getRecordField(l_node3, "ogb091")             
          LET l_ogb_file.ogb12  = aws_ttsrv_getRecordField(l_node3, "qty")  
                  
          INSERT INTO togb_file VALUES (l_ogb_file.*)                                                   
      END FOR 
      IF g_status.code='0' THEN
         CALL aws_axmt620_s_ins()
      END IF   
   END FOR
   
   IF g_success = 'Y' THEN
   	  COMMIT WORK
      CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_oga_r))
   ELSE
      IF g_status.code = 0 THEN
         LET g_status.code = -1
         LET g_status.description = "出货单过账失败，请检查资料是否正确！"
      END IF
      ROLLBACK WORK
   END IF
     
END FUNCTION

FUNCTION aws_axmt620_s_ins()
	DEFINE g_oga      RECORD LIKE oga_file.*  
  DEFINE g_ogb_nh      RECORD LIKE ogb_file.*  
   DEFINE l_sfp  RECORD LIKE sfp_file.*
   DEFINE l_sfq  RECORD LIKE sfq_file.*
   DEFINE l_sfs  RECORD LIKE sfs_file.*
   DEFINE l_rvbs RECORD LIKE rvbs_file.*
   DEFINE l_j,l_j2      LIKE sfs_file.sfs02
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_cnt0,l_cnt1 LIKE sfs_file.sfs02
   DEFINE l_sql  STRING
   DEFINE l_sfs01 LIKE sfs_file.sfs01
   DEFINE l_sfs03 LIKE sfs_file.sfs03
   DEFINE l_rvbs04_t LIKE rvbs_file.rvbs04
   DEFINE l_rvbs021_t LIKE rvbs_file.rvbs021
   DEFINE l_rvbs03_t LIKE rvbs_file.rvbs03
   DEFINE l_rvbs08_t LIKE rvbs_file.rvbs08
   DEFINE l_rvbs01_t LIKE rvbs_file.rvbs01
   DEFINE l_sfa06    LIKE sfa_file.sfa06
   DEFINE l_sfa05    LIKE sfa_file.sfa05
   DEFINE l_ima06 LIKE ima_file.ima06
   DEFINE l_flag  LIKE type_file.chr1 
   DEFINE l_cn,l_cn0    LIKE sfa_file.sfa06
   DEFINE l_factor   LIKE type_file.num26_10
   DEFINE l_ima25    LIKE ima_file.ima25
   DEFINE l_sfs06    LIKE sfs_file.sfs06
   DEFINE l_inb      RECORD LIKE inb_file.*  
   DEFINE g_no       LIKE oga_file.oga01
   DEFINE li_result  LIKE type_file.num5  
   DEFINE l_ogb      RECORD LIKE ogb_file.*  
   DEFINE l_poz00    LIKE poz_file.poz00
   DEFINE l_num      LIKE ogb_file.ogb12
   DEFINE l_ogb04    LIKE ogb_file.ogb04
   DEFINE l_ogb12    LIKE ogb_file.ogb12
   DEFINE t_azi03    LIKE azi_file.azi03,
          t_azi04    LIKE azi_file.azi04
   DEFINE l_oea61    LIKE oea_file.oea61,
          l_oea1008  LIKE oea_file.oea1008,
          l_oea261   LIKE oea_file.oea261,
          l_oea262   LIKE oea_file.oea262,
          l_oea263   LIKE oea_file.oea263
   DEFINE l_abc           LIKE ogb_file.ogb15_fac       
   DEFINE l_nh            RECORD           
                 ogb01     LIKE ogb_file.ogb01,      #出通单号      
                 barcode   LIKE type_file.chr50,     #批次条码       
                 ogb04     LIKE ogb_file.ogb04,      #料件 
                 ogb092    LIKE ogb_file.ogb092,     #批号   
                 ogb09     LIKE ogb_file.ogb09,      #仓库
                 ogb091    LIKE ogb_file.ogb091,     #库位     
                 ogb12     LIKE ogb_file.ogb12       #数量   
                 END RECORD    

     LET g_success = "Y"

     INITIALIZE g_oga.* TO NULL
     INITIALIZE g_ogb_nh.* TO NULL
     
     SELECT DISTINCT ogb01 INTO g_no FROM togb_file

     SELECT COUNT(oga01) INTO l_cnt FROM oga_file,ogb_file                                                                          
     WHERE oga01 = ogb01 AND oga09 IN ('2','4','6') 
       AND ogaconf != 'X' AND ogb03 IS NOT NULL                                                                                                       
       AND oga011 = g_no                                                                                                          
        
      IF l_cnt > 0 THEN    
         LET g_status.code = "-1"
         LET g_status.description = "已抛转出通/出货单!"                                                                                                
         LET g_success = 'N'    
         ROLLBACK WORK                                                                                                      
         RETURN                                                                                                                      
      END IF
        
        SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_no
        
        LET g_oga.oga01='XRD'
        
        CALL s_auto_assign_no("axm",g_oga.oga01,g_today,"","oga_file","oga01",g_plant,"","")
        RETURNING li_result,g_oga.oga01
                                       
        IF (NOT li_result) THEN                                                   
           LET g_success = 'N'
           LET g_status.code = "-1"
           LET g_status.description = "出货单生成失败!"   
           ROLLBACK WORK
           RETURN 
        END IF 
        	
        LET g_oga.oga02=g_today
        LET g_oga.oga69=g_today
        LET g_oga.ogaconf='N'
        LET g_oga.oga011=g_no
        CASE
         WHEN g_oga.oga09 = '1' #一單出貨通知單
           LET g_oga.oga09 = '2'
         WHEN g_oga.oga09 = '5' #多角貿易出或通知單
           SELECT poz00 INTO l_poz00 FROM oga_file
             LEFT OUTER JOIN oea_file ON oga16 = oea01
             LEFT OUTER JOIN poz_file ON oea904 = poz01
           WHERE oga01 = g_no1
           IF l_poz00 = '1' THEN   #1.銷售
              LET g_oga.oga09 = '4'
           ELSE                    #2.代採
              LET g_oga.oga09 = '6'
           END IF
         END CASE
        
        SELECT azi03,azi04 INTO t_azi03,t_azi04
            FROM azi_file
        WHERE azi01=g_oga.oga23
        
        LET l_sql="select * from togb_file where ogb01='",g_no,"' "
           
        PREPARE t620_pb1 FROM l_sql
        DECLARE t620_ic1 CURSOR FOR t620_pb1
        FOREACH t620_ic1 INTO l_nh.*
           IF STATUS THEN
             EXIT FOREACH
           END IF
           
           LET l_sql="select * from ogb_file where ogb01='",g_no,"' and ogb04='",l_nh.ogb04,"' order by ogb03"	
        
           PREPARE t620_pb2 FROM l_sql
           DECLARE t620_ic2 CURSOR FOR t620_pb2
           FOREACH t620_ic2 INTO g_ogb_nh.*
              IF STATUS THEN
                EXIT FOREACH
              END IF
              #获取出通单+项次可转出货单数量
              CALL aws_shipment(g_ogb_nh.ogb01,g_ogb_nh.ogb03) RETURNING l_num
              IF l_num=0 THEN 
              	CONTINUE FOREACH 
              ELSE 
              	LET g_ogb_nh.ogb12=l_num
              END IF
              
              LET g_ogb_nh.ogb01=g_oga.oga01	
              
              SELECT MAX(ogb03)+1 INTO g_ogb_nh.ogb03 FROM ogb_file 
              WHERE ogb01=g_ogb_nh.ogb01
              IF cl_null(g_ogb_nh.ogb03) THEN 
              	 LET g_ogb_nh.ogb03=1
              END IF 	
              
              IF g_ogb_nh.ogb12>=l_nh.ogb12 THEN 
                 LET g_ogb_nh.ogb12=l_nh.ogb12
                 LET l_nh.ogb12=0     
              ELSE 
              	 IF g_ogb_nh.ogb12<l_nh.ogb12 THEN  
              	    LET l_nh.ogb12=l_nh.ogb12-g_ogb_nh.ogb12
              	 END IF 
              END IF 
              LET g_ogb_nh.ogb09  = l_nh.ogb09   #仓库
              LET g_ogb_nh.ogb091 = l_nh.ogb091  #库位
              LET g_ogb_nh.ogb092 = l_nh.ogb092  #批号
              #LET g_ogb_nh.ogb916 = g_ogb_nh.ogb05
              LET g_ogb_nh.ogb917 = g_ogb_nh.ogb12
             #MOD-720003---add---str---
              IF g_sma.sma115 = 'N' AND g_sma.sma116 MATCHES '[23]' THEN
                 CALL s_umfchk(g_ogb_nh.ogb04,g_ogb_nh.ogb15,g_ogb_nh.ogb916)
                     RETURNING l_cnt,l_abc                                                                                           
                 IF l_cnt = '1'  THEN                                                                                                   
                    LET l_abc=1                                                                                                        
                 END IF          
                 LET g_ogb_nh.ogb917 = g_ogb_nh.ogb12 * l_abc
              END IF 
              
              
              LET g_ogb_nh.ogb917 = s_digqty(g_ogb_nh.ogb917,g_ogb_nh.ogb916)  
              LET g_ogb_nh.ogb16 = g_ogb_nh.ogb12*g_ogb_nh.ogb15_fac 
              LET g_ogb_nh.ogb18 = g_ogb_nh.ogb12
              
              IF g_oga.oga213 = 'N' THEN                                                                                       
                 LET g_ogb_nh.ogb14 = g_ogb_nh.ogb917* g_ogb_nh.ogb13   #CHI-B70039
                 CALL cl_digcut(g_ogb_nh.ogb14,t_azi04)  RETURNING g_ogb_nh.ogb14                                        
                 LET g_ogb_nh.ogb14t= g_ogb_nh.ogb14*(1+ g_oga.oga211/100)                                               
                 CALL cl_digcut(g_ogb_nh.ogb14t,t_azi04) RETURNING g_ogb_nh.ogb14t   
              ELSE                                                                                                             
                 LET g_ogb_nh.ogb14t= g_ogb_nh.ogb917*g_ogb_nh.ogb13   #CHI-B70039
                 CALL cl_digcut(g_ogb_nh.ogb14t,t_azi04) RETURNING g_ogb_nh.ogb14t                                       
                 LET g_ogb_nh.ogb14 = g_ogb_nh.ogb14t/(1+ g_oga.oga211/100)                                              
                 CALL cl_digcut(g_ogb_nh.ogb14,t_azi04)  RETURNING g_ogb_nh.ogb14                                        
              END IF

              INSERT INTO ogb_file VALUES(g_ogb_nh.*)
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  LET g_success = 'N'
                  LET g_status.code = "-1"
                  LET g_status.description = "插入ogb_file有误!"    
                  ROLLBACK WORK   
                  RETURN
              END IF
              	
              IF NOT cl_null(g_ogb_nh.ogb31) THEN
                   SELECT oea61,oea1008,oea261,oea262,oea263
                     INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
                     FROM oea_file
                   #WHERE oea01 = g_ogb_nh[l_m].ogb31  #MOD-C70208 mark 
                    WHERE oea01 = g_ogb_nh.ogb31           #MOD-C70208 add
                   IF g_oga.oga213 = 'Y' THEN
                      LET g_oga.oga52 = g_oga.oga52 + g_ogb_nh.ogb14 * l_oea261 / l_oea1008                      #MOD-C70208 add              
                      #No.yinhy131217  --Begin
                      IF g_aza.aza26='2' AND g_ooz.ooz33 = 'N' AND g_oga.oga161 >0 THEN
                         LET g_oga.oga53 = g_oga.oga50*(l_oea261+l_oea262+l_oea263)/ l_oea1008
                      ELSE
                      #No.yinhy131217  --End
                          LET g_oga.oga53 = g_oga.oga53 + g_ogb_nh.ogb14 * (l_oea262+l_oea263) / l_oea1008           #MOD-C70208 add
                      END IF   #yinhy131217   
                      ELSE
                        LET g_oga.oga52 = g_oga.oga52 + g_ogb_nh.ogb14 * l_oea261 / l_oea61                        #MOD-C70208 add
                         #No.yinhy131217  --Begin
                         IF g_aza.aza26='2' AND g_ooz.ooz33 = 'N' AND g_oga.oga161 >0 THEN
                            LET g_oga.oga53 = g_oga.oga50 * (l_oea261+l_oea262+l_oea263) / l_oea61
                         ELSE
                         #No.yinhy131217  --End
                            LET g_oga.oga53 = g_oga.oga53 + g_ogb_nh.ogb14 * (l_oea262+l_oea263) / l_oea61             #MOD-C70208 add
                         END IF   #yinhy131217   
                      END IF
              ELSE #无订单号码
                 LET g_oga.oga52 = g_oga.oga52 + g_ogb_nh.ogb14 * g_oga.oga161 / 100                    #MOD-C70208 add
                 #No.yinhy131217  --Begin
                 IF g_aza.aza26='2' AND g_ooz.ooz33 = 'N' AND g_oga.oga161 >0 THEN
                    LET g_oga.oga53 = g_oga.oga53 + g_ogb_nh.ogb14 * (g_oga.oga161+g_oga.oga162+g_oga.oga163) / 100
                 ELSE
                 #No.yinhy131217  --End
                    LET g_oga.oga53 = g_oga.oga53 + g_ogb_nh.ogb14 * (g_oga.oga162+g_oga.oga163) / 100     #MOD-C70208 add
                 END IF   #No.yinhy131217
 	
              END IF
              
              IF cl_null(g_oga.oga50) THEN LET g_oga.oga50=0 END IF 
              IF cl_null(g_oga.oga51) THEN LET g_oga.oga51=0 END IF	
              	
              LET g_oga.oga50= g_oga.oga50+g_ogb_nh.ogb14
              LET g_oga.oga51= g_oga.oga51+g_ogb_nh.ogb14T	
              			
              IF l_nh.ogb12=0 THEN 
              	 EXIT FOREACH 
              END IF 	   
           END FOREACH 
           IF l_nh.ogb12>0 THEN
           	  LET g_success = 'N'
              LET g_status.code = "-1"
              LET g_status.description = "料号",g_ogb_nh.ogb04,"扫描数量大于单据数量!"     
              ROLLBACK WORK  
              RETURN  
           END IF  
        END FOREACH
     	
     	INSERT INTO oga_file VALUES(g_oga.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success = 'N'
           LET g_status.code = "-1"
           LET g_status.description = "插入oga_file有误!"     
           ROLLBACK WORK  
           RETURN 
        END IF
     
     #审核
     
     SELECT * INTO g_azw.* FROM azw_file WHERE azw01=g_plant
     SELECT * INTO g_oaz.* FROM oaz_file 
     SELECT * INTO g_aza.* FROM aza_file
     
     LET g_prog="axmt620"
     CALL t600_app_sub_y_chk(g_oga.oga01,"") #CALL 原確認的 check 段 #FUN-740034 #CHI-C30118 add g_action_choice
     IF g_success = "Y" THEN
        CALL t600_app_sub_y_upd(g_oga.oga01,"")      #CALL 原確認的 update 段 #FUN-740034
     END IF
     IF g_success='N' THEN
     	  LET g_success = 'N'
        LET g_status.code = "-1"
        LET g_status.description = "审核失败!"     
        ROLLBACK WORK  
        RETURN 
     END IF
     #过账
     CALL t600_app_sub_s('2',TRUE,g_oga.oga01,FALSE)
     IF g_success='N' THEN
     	  LET g_success = 'N'
        LET g_status.code = "-1"
        LET g_status.description = "过账失败!"     
        ROLLBACK WORK  
        RETURN 
     END IF
     
     LET g_prog="aws_ttsrv2"
     IF g_success = 'Y' THEN
        CALL t600_ins_tlfb()
     END IF
     IF g_success = 'Y' THEN 
        LET g_oga_r.oga01 = g_oga.oga01
     END IF 
END FUNCTION         
                                                                                           
FUNCTION t600_ins_tlfb()
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
DEFINE l_ogb09     LIKE inb_file.inb05      #仓库
DEFINE l_ogb091    LIKE inb_file.inb06
DEFINE l_ogb12     LIKE inb_file.inb16

   INITIALIZE g_tlfb.* TO NULL
   
   LET g_sql ="select barcode,ima01,batch,ogb09,ogb091,ogb12 from togb_file"
   PREPARE t600_ins_tlfb FROM g_sql
   DECLARE t600_ins_tlfb_c CURSOR FOR t600_ins_tlfb
   FOREACH t600_ins_tlfb_c INTO l_barcode,l_ima01,l_batch,l_ogb09,l_ogb091,l_ogb12
      IF STATUS THEN
         LET g_success='N'
         LET g_status.code=-1
   		   LET g_status.description="抓取扫描资料失败,请重新提交！"
   		   EXIT FOREACH
      END IF

      LET  g_tlfb.tlfb01 = l_barcode
      LET  g_tlfb.tlfb02 = l_ogb09
      LET  g_tlfb.tlfb03 = l_ogb091
      LET  g_tlfb.tlfb04 = l_batch
      LET  g_tlfb.tlfb05 = l_ogb12
      LET  g_tlfb.tlfb09 = g_oga_r.oga01
      LET  g_tlfb.tlfb08 = 0 
      LET  g_tlfb.tlfb07 = g_oga_r.oga01
      LET  g_tlfb.tlfb10 = ' '  
      LET  g_tlfb.tlfb905= g_oga_r.oga01
      LET  g_tlfb.tlfb906= ' '         
      LET  g_tlfb.tlfb06 = -1   #出库
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

END FUNCTION
	
#add by lidj170109-----str-----
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
#add by lidj170109-----end-----			


#获取出通单+项次可转出货单数量
FUNCTION aws_shipment(p_oga01,p_ogb03)
   DEFINE p_oga01   LIKE oga_file.oga01
   DEFINE p_ogb03   LIKE ogb_file.ogb03
   DEFINE l_ogb12   LIKE ogb_file.ogb12   
   DEFINE l_a_ogb12 LIKE ogb_file.ogb12
   DEFINE l_ogb04   LIKE ogb_file.ogb04
   DEFINE l_ogb31   LIKE ogb_file.ogb31
   DEFINE l_ogb32   LIKE ogb_file.ogb32
   	 
	 SELECT ogb04,ogb12,ogb31,ogb32 INTO l_ogb04,l_ogb12,l_ogb31,l_ogb32 FROM ogb_file,oga_file 
	 WHERE oga01=ogb01 and ogb01=p_oga01 AND ogb03=p_ogb03 AND oga09 IN ('1','5')
	 SELECT SUM(ogb12) INTO l_a_ogb12 #已轉數量
    FROM oga_file,ogb_file
   WHERE oga01    = ogb01
     AND oga011   = p_oga01         #出貨通知單
     AND oga09 IN ('2','4','6','8') #FUN-C30086 add 4.多角貿易出貨單6.多角代採出貨單
     AND ogb31    = l_ogb31         #No:7099
     AND ogb32    = l_ogb32         #No:7099
     AND ogb04    = l_ogb04         #產品編號
     AND ogaconf != 'X'             #No:5445
     IF cl_null(l_ogb12) THEN LET l_ogb12=0 END IF     
     IF cl_null(l_a_ogb12) THEN LET l_a_ogb12=0 END IF
     RETURN l_ogb12-l_a_ogb12
END FUNCTION 