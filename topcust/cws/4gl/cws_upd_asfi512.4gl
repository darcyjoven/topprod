# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Descriptions...: 
# Date & Author..: by gujq 20161005


DATABASE ds                                               
                                                           
GLOBALS "../../../tiptop/config/top.global"
GLOBALS "../../../tiptop/aws/4gl/aws_ttsrv2_global.4gl"              
GLOBALS "../../../tiptop/aba/4gl/barcode.global"       
    
GLOBALS 
DEFINE g_sfp01    LIKE sfp_file.sfp01        #超领单号                                               
DEFINE g_ogb01    LIKE ogb_file.ogb01                      
DEFINE g_oga01    LIKE oga_file.oga01                      
DEFINE g_buf      LIKE type_file.chr2                      
DEFINE li_result  LIKE type_file.num5                      
DEFINE g_sql      STRING                                   
#DEFINE tmm        RECORD                                    
#                 sfb01   LIKE sfb_file.sfb01,   #工单号      
#                 ime01   LIKE ime_file.ime01,    #仓库编号     
#                 ibb01   LIKE ibb_file.ibb01,    #物料条码     
#                 sfa30   LIKE sfa_file.sfa30,    #仓库       
#                 sfa31   LIKE sfa_file.sfa31,    #库位       
#                 sfa03   LIKE sfa_file.sfa03,    #发料料号     
#                 ima02   LIKE ima_file.ima02,    #品名       
#                 sfa05   LIKE sfa_file.sfa05,    #欠料量      
#                 ibb07   LIKE ibb_file.ibb07     #实发数量     
#                 END RECORD
DEFINE g_hlf01     RECORD 
        sfp01    LIKE sfp_file.sfp01
                 END RECORD                 
DEFINE g_sfa    DYNAMIC ARRAY OF RECORD    #第一单身           
                    sfa03_1     LIKE sfa_file.sfa03,       
                    ima02_1     LIKE ima_file.ima02,       
                    marry_num   LIKE ogb_file.ogb12        
                 END RECORD,                               
       g_sfa_o  RECORD    #第一单身                            
                    sfa03_1     LIKE sfa_file.sfa03,       
                    ima02_1     LIKE ima_file.ima02,       
                    marry_num   LIKE ogb_file.ogb12        
                 END RECORD                               
       --g_sfa_t  RECORD    #第一单身                            
                    --sfa03_1     LIKE sfa_file.sfa03,       
                    --ima02_1     LIKE ima_file.ima02,       
                    --marry_num   LIKE ogb_file.ogb12        
                 --END RECORD                                
                                                           
DEFINE g_cnt     LIKE type_file.num5                       
DEFINE g_rec_b,g_rec_b1,g_rec_b2   LIKE type_file.num5     
DEFINE g_rec_b_1 LIKE type_file.num5                       
DEFINE l_ac      LIKE type_file.num10                      
DEFINE l_ac_t    LIKE type_file.num10                      
DEFINE li_step   LIKE type_file.num5                       
DEFINE g_ibb01   LIKE ibb_file.ibb01
#add by lili 170109 ---s---
DEFINE g_uid        STRING
DEFINE g_service    STRING
#add by lili 170109 ---e---                                              
END GLOBALS                                                          

FUNCTION  cws_upd_asfi512_g()                                                                      
DEFINE l_str     STRING   #add by lili 170109
DEFINE l_stime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_etime    INTERVAL HOUR TO FRACTION(3)
DEFINE l_costtime INTERVAL HOUR TO FRACTION(3)
DEFINE l_stimestr STRING
DEFINE l_etimestr STRING
DEFINE l_logfile  STRING
                                                                                                   
 WHENEVER ERROR CONTINUE                                                                           
                                                                                                   
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序                                           
                                                                                                   
    #--------------------------------------------------------------------------#                   
    # 新增完工入庫單資料                                                       #                   
    #--------------------------------------------------------------------------#
    #add by lili 170109 ---s---
    LET g_service = "cws_upd_asfi512"

    LET g_uid = getGuid()
    LET l_logfile = "/u1/out/aws_ttsrv2costtime-",TODAY USING 'YYYYMMDD',".log"
    LET l_stimestr = CURRENT HOUR TO FRACTION(3)
    LET l_stime = l_stimestr
    LET l_str = g_uid," ",g_service," ",l_stimestr," Start"
    CALL writeStringToFile(l_str,l_logfile) 
    #add by lili 170109 ---e---                   
    IF g_status.code = "0" THEN                                                                    
       CALL cws_upd_asfi512_process()                                                           
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
     DROP TABLE i512_file                                                                          
     DROP TABLE i512_file1                                                                         
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
FUNCTION cws_upd_asfi512_process() 
    DEFINE l_i        LIKE type_file.num10,
           l_j        LIKE type_file.num10,
           l_k        LIKE type_file.num10
    DEFINE l_cnt      LIKE type_file.num10,
           l_cnt1     LIKE type_file.num10,
           l_cnt2     LIKE type_file.num10,
           l_cnt3     LIKE type_file.num10
    DEFINE l_cnt4     LIKE type_file.num10
    DEFINE l_node1    om.DomNode,
           l_node2    om.DomNode,
           l_node3    om.DomNode         
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
   DEFINE l_tc_codesys10 LIKE tc_codesys_file.tc_codesys10
   DEFINE 
          l_sfa01      LIKE sfa_file.sfa01,
          l_sfa03      LIKE sfa_file.sfa03,
          l_sfa05      LIKE sfa_file.sfa05,
          l_sfaiicd03  LIKE sfai_file.sfaiicd03,
          temp_sum     LIKE ibb_file.ibb07
          
   DEFINE l_sql        STRING
   DEFINE l_no         LIKE ogb_file.ogb03,
          l_ogb01      LIKE ogb_file.ogb01,
          l_ogb092     LIKE ogb_file.ogb092                                                    
   DEFINE l_i512_file      RECORD                    #单身                                        
                 sfp01     LIKE sfp_file.sfp01,      #超领单号          
                 sfs04     LIKE sfs_file.sfs04,      #料件编号     
                 ima02     LIKE ima_file.ima02,      #品名    
                 sfs05     LIKE sfs_file.sfs05,      #超领量（原数量）
                 marry_num LIKE pmn_file.pmn20       #匹配数量  0
                                           
                 END RECORD                                                                        
  DEFINE  l_i512_file1     RECORD               
  	               sfp01      LIKE sfp_file.sfp01,      #超领单号
                   ibb01      LIKE ibb_file.ibb01,      #物料编码   
                   sfs04      LIKE sfs_file.sfs04,      #料件编号   
                   sfs07      LIKE sfs_file.sfs07,      #指定仓库 
                   sfs08      LIKE sfs_file.sfs08,      #指定库位         
                   sfaiicd03  LIKE sfai_file.sfaiicd03, #批号       
                   ibb07      LIKE ibb_file.ibb07       #数量
                                            
                 END RECORD                                                                        
   DROP TABLE l_i512_file                                                                            
   DROP TABLE l_i512_file1  
                                                                            
   CREATE TEMP TABLE i512_file(                                                                    
                 sfp01     LIKE sfp_file.sfp01,      #超领单号          
                 sfs04     LIKE sfs_file.sfs04,      #料件编号     
                 ima02     LIKE ima_file.ima02,      #品名    
                 sfs05     LIKE sfs_file.sfs05,      #超领量（原数量）
                 marry_num DECIMAL(15,3)             #匹配数量  0 
                 )                                
   CREATE TEMP TABLE i512_file1(                         
                   sfp01      LIKE sfp_file.sfp01,      #超领单号                                          
                   ibb01      LIKE ibb_file.ibb01,      #物料编码   
                   sfs04      LIKE sfs_file.sfs04,      #料件编号   
                   sfs07      LIKE sfs_file.sfs07,      #指定仓库 
                   sfs08      LIKE sfs_file.sfs08,      #指定库位         
                   sfaiicd03  LIKE sfai_file.sfaiicd03, #批号 
                   ibb07      DECIMAL(15,3)             #数量
                   ) 
  #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    INITIALIZE g_hlf01.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
       LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點

       LET g_sfp01 = aws_ttsrv_getRecordField(l_node1,"sfp01")  
       #LET tmm.sfb01 = aws_ttsrv_getRecordField(l_node1, "sfp01")    

       #----------------------------------------------------------------------#
       # 處理第一單身資料                                                         #
       #----------------------------------------------------------------------#
       #LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "i512_file")       #取得目前單頭共有幾筆單身資料
       #IF l_cnt3 = 0 THEN
       #   LET g_status.code = "mfg-009"   #必須有單身資料
       #   EXIT FOR
       #END IF
       #
       #FOR l_k = 1 TO l_cnt3
       #    INITIALIZE l_i512_file.* TO NULL
       #    LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"i512_file")   #目前單身的 XML 節點
       #
       #    #------------------------------------------------------------------#
       #    # NODE資料傳到RECORD                                               #
       #    #------------------------------------------------------------------#
       #
       #LET l_i512_file.sfp01 = aws_ttsrv_getRecordField(l_node3, "sfp01")   #取                      
       #LET l_i512_file.sfs04 = aws_ttsrv_getRecordField(l_node3, "sfs04")                        
       #LET l_i512_file.ima02 = aws_ttsrv_getRecordField(l_node3, "ima02")                      
       #LET l_i512_file.sfs05 = aws_ttsrv_getRecordField(l_node3, "sfs05")                                              
       #LET l_i512_file.marry_num = aws_ttsrv_getRecordField(l_node3, "marry_num")                      
       #                                                                                           
       #INSERT INTO i512_file VALUES (l_i512_file.sfp01,l_i512_file.sfs04,
       #l_i512_file.ima02,l_i512_file.sfs05,l_i512_file.marry_num )    
       #END FOR
       #----------------------------------------------------------------------#
       # 處理第二單身資料                                                         #
       #----------------------------------------------------------------------#        
       LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "i512_file1")       #取得目前單頭共有幾筆單身資料
       IF l_cnt2 = 0 THEN
          LET g_status.code = "mfg-009"   #必須有單身資料
          EXIT FOR
       END IF
       
       FOR l_j = 1 TO l_cnt2                                                                      
          INITIALIZE l_i512_file1.* TO NULL                                                       
          LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"i512_file1")   #目前                 
                                                                                                  
           ------------------------------------------------------------------#                   
           #NODE資料傳到RECORD                                               #                   
           ------------------------------------------------------------------#  
           LET l_i512_file1.sfp01 = g_sfp01                 
           LET l_i512_file1.ibb01 = aws_ttsrv_getRecordField(l_node2, "ibb01") 
#           CALL cs_get_barcode_info(l_i512_file1.ibb01)
#           IF g_return.stat = 5 THEN
#              SELECT instr(l_i512_file1.ibb01, '%',1,2) INTO l_cnt4 FROM DUAL #找第二个%的位置
#              LET l_i512_file1.ibb01 = l_i512_file1.ibb01[1,l_cnt4-1]
#           END IF                                             
           LET l_i512_file1.sfs04 = aws_ttsrv_getRecordField(l_node2, "sfs04")                    
           LET l_i512_file1.sfs07 = aws_ttsrv_getRecordField(l_node2, "sfs07")
           LET l_i512_file1.sfs08 = aws_ttsrv_getRecordField(l_node2, "sfs08")             
           LET l_i512_file1.sfaiicd03 = aws_ttsrv_getRecordField(l_node2, "sfaiicd03")                       
           LET l_i512_file1.ibb07 = aws_ttsrv_getRecordField(l_node2, "ibb07")
           
           {SELECT tc_codesys10 INTO l_tc_codesys10 FROM tc_codesys_file AND tc_codesysplant = g_plant
           IF cl_null(l_tc_codesys10) THEN LET l_tc_codesys10='N' END IF
           IF l_tc_codesys10='Y' THEN
              LET l_sql =" select count(*) FROM",
                         " (select sfa03,",
                         " ibb01,ibb06,imgb02,imgb03,substr(ibb01,length(ibb01)-5,6) ,imgb05,(sfa05-sfa06) sfa05c,",
                         " sum(imgb05) over (PARTITION BY sfa03 order by sfa03,substr(ibb01,length(ibb01)-5,6),ibb01,imgb03 ) sumimgb05",
                         " from sfb_file",
                         " inner join sfa_file on sfb01=sfa01",
                         " inner join ima_file on ima01=sfb05",
                         " inner join ibb_file on ibb06=sfa03",
                         " inner join imgb_file on imgb01=ibb01 and imgb05>0",
                         " where sfa05>sfa06",
                         " and sfa01='",g_sfa01,"'",
                         " order by sfa03,substr(ibb01,length(ibb01)-5,6) ,ibb01,imgb03)  a",
                         " where a.sumimgb05-a.imgb05<=a.sfa05c",
                         "   and a.ibb01='",l_i512_file1.ibb01,"'",
                         "   and a.imgb03='",l_i512_file1.sfa31,"'"
    	       PREPARE prep_i512ibb01 FROM l_sql
             EXECUTE prep_i512ibb01 INTO l_n
             IF l_n>0 THEN
                LET g_status.code = "-1"
                LET g_status.description = "扫描料件不符合FIFO规则,请检查!"
                LET g_success='N'
                RETURN
             END IF
           END IF    }                
           INSERT INTO i512_file1 VALUES (l_i512_file1.sfp01,l_i512_file1.ibb01,l_i512_file1.sfs04,                   
          l_i512_file1.sfs07,l_i512_file1.sfs08,l_i512_file1.sfaiicd03,l_i512_file1.ibb07)
       END FOR  
       IF g_success = "Y" THEN
          CALL exc_item_asfi512(g_sfp01)	
       END IF   
    END FOR

   IF g_success = "Y" THEN 
       CALL i512_create()
       #IF g_success = 'Y' THEN
       #   CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_hlf01))
       #END IF
   END IF 
END FUNCTION
                                                                                       
FUNCTION i512_create() 
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
   DEFINE l_iba       RECORD LIKE iba_file.*
   DEFINE l_ibb       RECORD LIKE ibb_file.*
   DEFINE l_sfscnt   LIKE type_file.num5        #add by zl 170417 begin
   DEFINE l_sfecnt   LIKE type_file.num5
   DEFINE l_tlfcnt   LIKE type_file.num5        #add by zl 170417 end
   DEFINE l_sfb02    LIKE sfb_file.sfb02

     BEGIN WORK

     #IF g_success = "Y" THEN
     #   CALL ins_asfi512_g()
     #END IF
     IF g_success = "Y" THEN 
        LET g_sql ="select UNIQUE ibb01,sfs04,sfs07,sfs08,sfaiicd03,SUM(ibb07)",
                 " from i512_file1",
                 " GROUP BY ibb01,sfs04,sfs07,sfs08,sfaiicd03",
   	             " order by ibb01,sfs04,sfs07,sfs08,sfaiicd03"
            PREPARE t001_ipb_iba FROM g_sql
            DECLARE t001_iba CURSOR FOR t001_ipb_iba
            FOREACH t001_iba INTO l_ibb01,l_sfa03,l_sfa30,l_sfa31,l_sfaiicd03,l_ibb07
              IF STATUS THEN
               EXIT FOREACH
              END IF
              SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_ibb01
              SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_ibb01
              IF cl_null(l_n) THEN LET l_n=0 END IF
              IF cl_null(l_t) THEN LET l_t=0 END IF
              IF l_n=0 AND l_t=0 THEN
                    LET l_iba.iba01=l_ibb01
                    INSERT INTO iba_file VALUES(l_iba.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL s_errmsg('','',"ins_iba():",SQLCA.sqlcode,1)  
                        LET g_success = 'N'
                        RETURN
                    END IF
                    LET l_ibb.ibb01=l_ibb01      #条码编号
                    LET l_ibb.ibb02='K'          #条码产生时机点
                    LET l_ibb.ibb03=g_sfp01      #来源单号
                    LET l_ibb.ibb04=0            #来源项次
                    LET l_ibb.ibb05=0            #包号
                    LET l_ibb.ibb06=l_sfa03      #料号
                    LET l_ibb.ibb11='Y'          #使用否         
                    LET l_ibb.ibb12=0            #打印次数
                    LET l_ibb.ibb13=0            #检验批号(分批检验顺序)
                    LET l_ibb.ibbacti='Y'        #资料有效码
#                    LET l_ibb.ibb17=l_sfaiicd03  #批号
#                    LET l_ibb.ibb14=l_ibb07      #数量
#                    LET l_ibb.ibb20=g_today      #生成日期
#              SELECT to_char(sysdate,'hh24miss') INTO l_ibb.ibb19 from dual
#                    SELECT to_char(sysdate,'hh24miss') INTO l_ibb.ibb19 from dual
                    INSERT INTO ibb_file VALUES(l_ibb.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL s_errmsg('','',"ins_ibb():",SQLCA.sqlcode,1)  
                        LET g_success = 'N'  
                        LET g_status.code = '-1' 
                        LET g_status.description = '新增ibb_file失败'
                        RETURN
                    END IF
              ELSE
              	 CONTINUE FOREACH
              END IF
            END FOREACH
     END IF
     IF g_success = "Y" THEN
        LET g_sql ="select UNIQUE ibb01,sfs07,sfs08,sfaiicd03,SUM(ibb07)",
                 " from i512_file1",
                 " GROUP BY ibb01,sfs07,sfs08,sfaiicd03",
   	             " order by ibb01,sfs07,sfs08,sfaiicd03"
            INITIALIZE g_tlfb.* TO NULL
          PREPARE i512_ipb5 FROM g_sql
          DECLARE i512_ic5 CURSOR FOR i512_ipb5              
            FOREACH i512_ic5 INTO g_tlfb.tlfb01,g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05
             IF STATUS THEN
#               CALL cl_err('foreach i512_ic1:',STATUS,1)
               EXIT FOREACH
             END IF 
              LET  g_tlfb.tlfb09=g_sfp01
              LET  g_tlfb.tlfb08=' ' 
              LET  g_tlfb.tlfb07=g_sfp01
              LET  g_tlfb.tlfb10=' '  
              LET  g_tlfb.tlfb905= g_sfp01
              LET  g_tlfb.tlfb906=' '         
              LET  g_tlfb.tlfb06= -1   #出库
              LET  g_tlfb.tlfb16 = '条码枪'
              LET  g_tlfb.tlfb17 = ' '             #杂收理由码
              LET  g_tlfb.tlfb18 = ' '             #产品分类码 
              LET  g_tlfb.tlfb19='Y'               #扣账否为N
              IF cl_null(g_tlfb.tlfb08) THEN
              	 LET g_tlfb.tlfb08 = 0
              END IF
              CALL s_web_tlfb('','','','','')  #更新条码异动档
              
              LET g_sql =" SELECT COUNT(*) FROM imgb_file ",
                            "WHERE imgb01='",g_tlfb.tlfb01,"'",
                            " AND imgb02='",g_tlfb.tlfb02,"'",
                            " AND imgb03='",g_tlfb.tlfb03,"'" ,
                            " AND imgb04='",g_tlfb.tlfb04,"'"
                            
                 PREPARE i512_imgb_pre FROM g_sql
                 EXECUTE i512_imgb_pre INTO l_n
                 IF l_n = 0 THEN #没有imgb_file，新增imgb_file
                    CALL s_ins_imgb(g_tlfb.tlfb01,g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,g_tlfb.tlfb05,g_tlfb.tlfb06,'')
                                IF g_success = 'N' THEN
                                   LET g_status.code = '9052'
                                END IF
                 ELSE
                    CALL s_up_imgb(g_tlfb.tlfb01,    #更新条码库存档
                     g_tlfb.tlfb02,g_tlfb.tlfb03,g_tlfb.tlfb04,
                     g_tlfb.tlfb05,g_tlfb.tlfb06,'') 
                     IF g_success = 'N' THEN
                        LET g_status.code = '9050'
                     END IF
                 END IF
           END FOREACH
     END IF
   
   IF g_success = "Y" THEN
      LET g_prog = 'asfi512'   
   	  CALL i501sub_s('1',g_sfp01,TRUE,'N')
      LET g_prog = 'aws_ttsrv2'    
   END IF
   #add by zl 170417
   IF g_success = 'Y' THEN
      SELECT sfb02 INTO l_sfb02 FROM sfs_file,sfb_file WHERE sfb01=sfs03 and sfs01 = g_sfp01 AND sfs02 = 1
      IF l_sfb02 = '7' THEN  #只看委外
      SELECT COUNT(*) INTO l_sfscnt FROM sfs_file WHERE sfs01 = g_sfp01
      SELECT COUNT(*) INTO l_sfecnt FROM sfe_file WHERE sfe02 = g_sfp01
      SELECT COUNT(*) INTO l_tlfcnt FROM tlf_file WHERE tlf026 = g_sfp01
      IF l_sfscnt > 0 or l_sfecnt = 0 or l_tlfcnt = 0 THEN 
         LET g_success = 'N'
         LET g_status.code = "-1"
      	  LET g_status.description = "sfs,sfe,tlf更新异常请检查",g_sfp01 #add by zl 170417
      END IF  
      END IF
   END IF
   #add by zl 170417  
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  IF g_status.code = "0" THEN
   	  	 LET g_status.code = "-1"
   	  	 LET g_status.description = "过账失败,请联系系统管理员！",g_sfp01 #add by zl 170417 add g_sfp01
   	  END IF
   	  ROLLBACK WORK
   END IF 
END FUNCTION

FUNCTION exc_item_asfi512(p_sfp01)
DEFINE p_sfp01       LIKE sfp_file.sfp01
DEFINE l_sql         STRING
DEFINE l_sfs02       LIKE sfs_file.sfs02
DEFINE l_sfs03       LIKE sfs_file.sfs03
DEFINE l_sfs04       LIKE sfs_file.sfs04
DEFINE l_sfs05       LIKE sfs_file.sfs05
DEFINE l_sfs07_sum   LIKE sfs_file.sfs07
DEFINE l_sfs07       LIKE sfs_file.sfs07
DEFINE l_sfs10       LIKE sfs_file.sfs10
DEFINE l_sfs05_sum   LIKE sfs_file.sfs05
#DEFINE l_tc_qcs07    LIKE tc_qcs_file.tc_qcs07  #报工量
DEFINE l_sfa161      LIKE sfa_file.sfa161       #qpa
DEFINE l_sfa063      LIKE sfa_file.sfa063       #报废量
DEFINE l_sfa06       LIKE sfa_file.sfa06        #已发量
DEFINE l_cnt         LIKE type_file.num5
   
   #汇总扫描数据
   LET l_sql = " SELECT sfs04,sfs07,SUM(ibb07) FROM i512_file1 WHERE sfp01 = '",p_sfp01 CLIPPED,"'GROUP BY sfs04,sfs07"
   PREPARE sfp_pre FROM l_sql
   DECLARE sfp_c CURSOR FOR sfp_pre
   FOREACH sfp_c INTO l_sfs04,l_sfs07_sum,l_sfs05_sum
   	  #根据料号找退料单中的单身笔数
   	  LET l_cnt = 0
   	  SELECT COUNT(*) INTO l_cnt FROM sfs_file WHERE sfs01 = p_sfp01 AND sfs04 = l_sfs04
   	  IF l_cnt = 0 THEN #扫了退料单中不存在的料号，报错
   	  	 LET g_status.code=-1
   	     LET g_status.description="料件",l_sfs04,"不存在于超领单",p_sfp01,"中，请重新扫描"
   	     LET g_success = "N"
   	     EXIT FOREACH
   	  ELSE
   	  	 IF l_cnt = 1 THEN #仅有一笔，直接匹配
   	  	    #抓取超领单身
   	  	    SELECT sfs02,sfs03,sfs10,sfs05,sfs07 INTO l_sfs02,l_sfs03,l_sfs10,l_sfs05,l_sfs07
   	  	      FROM sfs_file
   	  	     WHERE sfs01 = p_sfp01 AND sfs04 = l_sfs04
            
            #校验仓库
            IF l_sfs07 <> l_sfs07_sum THEN
            	 LET g_success='N'
               LET g_status.code=-1
   		         LET g_status.description="扫描仓库与单据仓库不符！,项次",l_sfs02
   		         EXIT FOREACH
            END IF
            
   	  	    #实际超领量不可大于单据数量
   	  	    IF l_sfs05_sum > l_sfs05 THEN
   	  	    	 LET g_success='N'
               LET g_status.code=-1
   		         LET g_status.description="实际超领量不可大于单据数量,项次",l_sfs02
   		         EXIT FOREACH
   	  	    ELSE
   	  	    	 UPDATE sfs_file SET sfs05 = l_sfs05_sum WHERE sfs01 = p_sfp01 AND sfs02 = l_sfs02
   	  	    	 IF SQLCA.sqlcode THEN 
   		           	LET g_success='N'
               		LET g_status.code=-1
   		         	  LET g_status.description="更新数量失败,项次",l_sfs02
   		         	  EXIT FOREACH
   		         END IF
   	  	    END IF
   	  	    LET l_sfs05_sum = 0
   	  	 ELSE#存在多笔，先分配
   	  	    LET l_sql = "SELECT sfs02,sfs03,sfs10,sfs05,sfs07 FROM sfs_file WHERE sfs01 = '",p_sfp01 CLIPPED,"' AND sfs04 = '",l_sfs04 CLIPPED,"'"
   	  	    PREPARE sfs_pre FROM l_sql
            DECLARE sfs_c CURSOR FOR sfs_pre
            FOREACH sfs_c INTO l_sfs02,l_sfs03,l_sfs10,l_sfs05,l_sfs07
            	 #校验仓库
               IF l_sfs07 <> l_sfs07_sum THEN
               	  LET g_success='N'
                  LET g_status.code=-1
   		            LET g_status.description="扫描仓库与单据仓库不符！,项次",l_sfs02
   		            EXIT FOREACH
               END IF
   	  	       IF l_sfs05_sum < = l_sfs05 THEN
   	  	          UPDATE sfs_file SET sfs05 = l_sfs05_sum WHERE sfs01 = p_sfp01 AND sfs02 = l_sfs02
   	  	          IF SQLCA.sqlcode THEN 
   		               LET g_success='N'
                     LET g_status.code=-1
   		               LET g_status.description="更新数量失败,项次",l_sfs02
   		               EXIT FOREACH
   		            END IF
   	  	          LET l_sfs05_sum = 0 
   	  	          #EXIT FOREACH #分配完了,继续分配，后面的全部给0
   	  	       ELSE
   	  	       	  LET l_sfs05_sum = l_sfs05_sum - l_sfs05
   	  	       END IF
            END FOREACH
            
            IF l_sfs05_sum > 0 THEN #最终也还没分配完
            	 LET g_success='N'
               LET g_status.code=-1
   		         LET g_status.description="数量超过超领单中该料件的总量,料件",l_sfs04
   		         EXIT FOREACH
            END IF
   	  	 END IF
   	  END IF
   END FOREACH
#add wanjz by 170213 start----------
#将超领单日期修改问作业日期
     UPDATE sfp_file SET sfp03 = g_today WHERE sfp01 = p_sfp01
     IF SQLCA.sqlcode THEN
         LET g_success='N'
         LET g_status.code=-1
         LET g_status.description="更新超领单日期失败！"
     END IF

#add wanjz by 170213 end ---------


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
