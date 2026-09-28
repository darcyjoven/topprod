# Prog. Version..: '5.30.03-12.09.18(00000)'
# Program name...: aws_create_asfi512.4gl
# Descriptions...: 更新工单超领单
# Date & Author..: 2016-08-25 14:18:19 by shenran




DATABASE ds                                               
                                                           
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"              
GLOBALS "../../aba/4gl/barcode.global"       
    
GLOBALS 
DEFINE g_sfp01    LIKE sfp_file.sfp01        #超领单号                                                                   
DEFINE g_buf      LIKE type_file.chr2                      
DEFINE li_result  LIKE type_file.num5                      
DEFINE g_sql      STRING                                                                                                             
DEFINE g_cnt     LIKE type_file.num5                       
DEFINE g_rec_b,g_rec_b1,g_rec_b2   LIKE type_file.num5     
DEFINE g_rec_b_1 LIKE type_file.num5                       
DEFINE l_ac      LIKE type_file.num10                      
DEFINE l_ac_t    LIKE type_file.num10                      
DEFINE li_step   LIKE type_file.num5                       
DEFINE g_ibb01   LIKE ibb_file.ibb01                       
DEFINE g_sfp01   LIKE sfp_file.sfp01                       
END GLOBALS                                                          

FUNCTION  aws_create_asfi512()                                                                      
                                                                                                   
 WHENEVER ERROR CONTINUE                                                                           
                                                                                                   
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序                                           
                                                                                                   
    #--------------------------------------------------------------------------#                   
    # 新增完工入庫單資料                                                       #                   
    #--------------------------------------------------------------------------#                   
    IF g_status.code = "0" THEN                                                                    
       CALL aws_create_asfi512_process()                                                           
    END IF                                                                                         
                                                                                                   
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
FUNCTION aws_create_asfi512_process() 
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
   DEFINE l_ibb17      LIKE type_file.chr50,
          l_sfa01      LIKE sfa_file.sfa01,
          l_sfa03      LIKE sfa_file.sfa03,
          l_sfa05      LIKE sfa_file.sfa05,
          l_sfaiicd03  LIKE sfai_file.sfaiicd03,
          temp_sum     LIKE ibb_file.ibb07
          
   DEFINE l_sql        STRING
   DEFINE l_no         LIKE ogb_file.ogb03,
          l_ogb01      LIKE ogb_file.ogb01,
          l_ogb092     LIKE ogb_file.ogb092                                                    
   DEFINE l_i512_file      RECORD                    #第一单身                                        
                 sfs02     LIKE sfs_file.sfs02,      #项次       
                 sfs04     LIKE sfs_file.sfs04,      #料号 （from sfb82=pmc01）    
                 sfs05     LIKE sfs_file.sfs05,      #申请数量     
                 sfs05a    LIKE sfs_file.sfs05       #实发数量    
                                           
                 END RECORD                                                                        
  DEFINE  l_i512_file1     RECORD               
                   ibb01      LIKE ibb_file.ibb01,      #物料编码   
                   sfs04      LIKE sfs_file.sfs04,      #料件编号   
                   sfs07      LIKE sfs_file.sfs07,      #指定仓库 
                   sfs08      LIKE sfs_file.sfs08,      #指定库位         
                   ibb17      LIKE type_file.chr50,      #批号       
                   ibb07      LIKE ibb_file.ibb07       #数量
                 END RECORD                                                                        
   DROP TABLE i512_file                                                                            
   DROP TABLE i512_file1  
                                                                            
   CREATE TEMP TABLE i512_file(                                                                    
                 sfs02     LIKE sfs_file.sfs02,      #项次       
                 sfs04     LIKE sfs_file.sfs04,      #料号 （from sfb82=pmc01）    
                 sfs05     LIKE sfs_file.sfs05,      #申请数量     
                 sfs05a    LIKE sfs_file.sfs05)      #实发数量
                                                 
   CREATE TEMP TABLE i512_file1(                                                                   
                   ibb01      LIKE ibb_file.ibb01,      #物料编码   
                   sfs04      LIKE sfs_file.sfs04,      #料件编号   
                   sfs07      LIKE sfs_file.sfs07,      #指定仓库 
                   sfs08      LIKE sfs_file.sfs08,      #指定库位         
                   ibb17      LIKE ibb_file.ibb17,      #批号       
                   ibb07      LIKE ibb_file.ibb07)      #数量
                    
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

        LET g_sfp01 = aws_ttsrv_getRecordField(l_node1,"sfp01")  
        #----------------------------------------------------------------------#
        # 處理第一單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "i512_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_k = 1 TO l_cnt3
            INITIALIZE l_i512_file.* TO NULL
            LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"i512_file")   #目前單身的 XML 節點

            LET l_i512_file.sfs02  = aws_ttsrv_getRecordField(l_node3, "sfs02")   #取
            LET l_i512_file.sfs04  = aws_ttsrv_getRecordField(l_node3, "sfs04")                        
            LET l_i512_file.sfs05  = aws_ttsrv_getRecordField(l_node3, "sfs05")                        
            LET l_i512_file.sfs05a = aws_ttsrv_getRecordField(l_node3, "sfs05a")                                          
                                                                                                   
            INSERT INTO i512_file VALUES (l_i512_file.* )    
        END FOR
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
            LET l_i512_file1.ibb01 = aws_ttsrv_getRecordField(l_node2, "ibb01")                                              
            LET l_i512_file1.sfs04 = aws_ttsrv_getRecordField(l_node2, "sfs04")                    
            LET l_i512_file1.sfs07 = aws_ttsrv_getRecordField(l_node2, "sfs07")
            LET l_i512_file1.sfs08 = aws_ttsrv_getRecordField(l_node2, "sfs08")             
            LET l_i512_file1.ibb17 = aws_ttsrv_getRecordField(l_node2, "ibb17")                       
            LET l_i512_file1.ibb07 = aws_ttsrv_getRecordField(l_node2, "ibb07")
                            
            INSERT INTO i512_file1 VALUES (l_i512_file1.*)
        END FOR    
    END FOR
    LET l_n=0
    SELECT COUNT(*) INTO l_n FROM i512_file WHERE sfs05a=0
    IF l_n>0 THEN
    	 LET g_status.code = "-1"
       LET g_status.description = "存在实发量为零的数据,请检查!"
    END IF
    IF g_status.code='0' THEN
       CALL i512_load()
    END IF 
END FUNCTION
                   
                                                      
                                                                                                   
FUNCTION i512_load() 
   DEFINE l_n         LIKE type_file.num5
   DEFINE l_sql       STRING
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
   DEFINE l_sfs       RECORD 
                 sfs02     LIKE sfs_file.sfs02,      #项次       
                 sfs04     LIKE sfs_file.sfs04,      #料号 （from sfb82=pmc01）    
                 sfs05     LIKE sfs_file.sfs05,      #申请数量     
                 sfs05a    LIKE sfs_file.sfs05       #实发数量
                  END RECORD
  DEFINE  l_sfs1     RECORD               
                 ibb01      LIKE ibb_file.ibb01,      #物料编码   
                 sfs04      LIKE sfs_file.sfs04,      #料件编号   
                 sfs07      LIKE sfs_file.sfs07,      #指定仓库 
                 sfs08      LIKE sfs_file.sfs08,      #指定库位         
                 ibb17      LIKE type_file.chr50,      #批号       
                 ibb07      LIKE ibb_file.ibb07       #数量
                 END RECORD     
     
     BEGIN WORK
     INITIALIZE l_iba.* TO NULL
     INITIALIZE l_ibb.* TO NULL
     INITIALIZE l_sfs.* TO NULL
     INITIALIZE l_sfs1.* TO NULL
     LET l_sql=" select * from i512_file"
            PREPARE i512_file FROM l_sql
            DECLARE i512_file_cur CURSOR FOR i512_file
            FOREACH i512_file_cur INTO l_sfs.*
              IF STATUS THEN
                EXIT FOREACH
              END IF
              UPDATE sfs_file SET sfs05=l_sfs.sfs05a,
                                  sfsud07=l_sfs.sfs05
              WHERE sfs01=g_sfs01
                AND sfs02=l_sfs.sfs02                   
            END FOREACH
     IF g_success = "Y" THEN 
        LET l_sql ="select * from i512_file1"
            PREPARE t001_ipb_iba FROM l_sql
            DECLARE t001_iba CURSOR FOR t001_ipb_iba
            FOREACH t001_iba INTO l_sfs1.*
              IF STATUS THEN
               EXIT FOREACH
              END IF
              LET l_n=0
              LET l_t=0
              SELECT COUNT(*) INTO l_n FROM iba_file WHERE iba01=l_sfs1.ibb01
              SELECT COUNT(*) INTO l_t FROM ibb_file WHERE ibb01=l_sfs1.ibb01
              IF cl_null(l_n) THEN LET l_n=0 END IF
              IF cl_null(l_t) THEN LET l_t=0 END IF
              IF l_n=0 AND l_t=0 THEN
                    LET l_iba.iba01=l_sfs1.ibb01
                    INSERT INTO iba_file VALUES(l_iba.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL s_errmsg('','',"ins_iba():",SQLCA.sqlcode,1)  
                        LET g_success = 'N'
                        RETURN
                    END IF
                    LET l_ibb.ibb01=l_sfs1.ibb01 #条码编号
                    LET l_ibb.ibb02='K'          #条码产生时机点
                    LET l_ibb.ibb03=g_sfp01      #来源单号
                    LET l_ibb.ibb04=0            #来源项次
                    LET l_ibb.ibb05=0            #包号
                    LET l_ibb.ibb06=l_sfs1.sfs04 #料号
                    LET l_ibb.ibb11='Y'          #使用否         
                    LET l_ibb.ibb12=0            #打印次数
                    LET l_ibb.ibb13=0            #检验批号(分批检验顺序)
                    LET l_ibb.ibbacti='Y'        #资料有效码
     #               LET l_ibb.ibb17=l_sfs1.ibb17 #批号
     #               LET l_ibb.ibb14=l_sfs1.ibb07 #数量
     #               LET l_ibb.ibb20=g_today      #生成日期
     #               SELECT to_char(sysdate,'hh24miss') INTO l_ibb.ibb19 from dual
                    INSERT INTO ibb_file VALUES(l_ibb.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL s_errmsg('','',"ins_ibb():",SQLCA.sqlcode,1)  
                        LET g_success = 'N'  
                        LET g_status.code = '-1' 
                        LET g_status.description = '新增ibb_file失败'
                        RETURN
                    END IF
              END IF
              
              #插入tlfb_file,imgb_file
              LET g_tlfb.tlfb01=l_sfs1.ibb01  #条码编号
              LET g_tlfb.tlfb02=l_sfs1.sfs07  #仓库
              LET g_tlfb.tlfb03=l_sfs1.sfs08  #库位
              LET g_tlfb.tlfb04=l_sfs1.ibb17  #批号
              LET g_tlfb.tlfb05=l_sfs1.ibb07  #异动数量
              LET g_tlfb.tlfb06= -1           #出库
              LET g_tlfb.tlfb07=g_sfp01       #来源单号
              LET g_tlfb.tlfb08=0             #项次
              LET g_tlfb.tlfb09=g_sfp01       #目的单号
              LET g_tlfb.tlfb10=0             #目的项次
              LET g_tlfb.tlfb905= g_sfp01     #异动单号
              LET g_tlfb.tlfb906=0            #异动项次
              LET g_tlfb.tlfb17 = ' '        #杂收理由码
              LET g_tlfb.tlfb18 = ' '        #产品分类码 
              LET g_tlfb.tlfb19='Y'          #扣账否为N
              CALL s_web_tlfb('','','','','')  #更新条码异动档
              LET l_sql =" SELECT COUNT(*) FROM imgb_file ",
                            "WHERE imgb01='",g_tlfb.tlfb01,"'",
                            " AND imgb02='",g_tlfb.tlfb02,"'",
                            " AND imgb03='",g_tlfb.tlfb03,"'" ,
                            " AND imgb04='",g_tlfb.tlfb04,"'"
                            
                 PREPARE i512_imgb_pre FROM l_sql
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
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  ROLLBACK WORK
   END IF 
END FUNCTION                                          
                                                                                                   
