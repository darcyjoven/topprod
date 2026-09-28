# Prog. Version..: '5.30.06-13.03.12(00000)'
#
# Pattern name...: aws_create_asfi528.4gl
# Descriptions...: 提供产生一般退料单据
# Date & Author..:2016-09-09 15:20:03  shenran
DATABASE ds                                               
                                                           
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"              
GLOBALS "../../aba/4gl/barcode.global"       
    
GLOBALS 
DEFINE g_sfb01    LIKE sfb_file.sfb01        #工单号                                               
DEFINE g_sfs07    LIKE sfs_file.sfs07        #仓库                      
DEFINE g_sfs08    LIKE sfs_file.sfs08        #库位 
DEFINE g_sfp01    LIKE sfp_file.sfp01        #退料单号        
DEFINE g_buf      LIKE type_file.chr2                      
DEFINE li_result  LIKE type_file.num5                      
DEFINE g_sql      STRING                                                                                            
DEFINE g_cnt     LIKE type_file.num5                       
DEFINE g_rec_b,g_rec_b1,g_rec_b2   LIKE type_file.num5     
DEFINE g_rec_b_1 LIKE type_file.num5                       
DEFINE l_ac      LIKE type_file.num10                      
DEFINE l_ac_t    LIKE type_file.num10                      
DEFINE li_step   LIKE type_file.num5
DEFINE g_hlf528   RECORD 
               sfp01 LIKE sfp_file.sfp01
                 END RECORD                                            
END GLOBALS                                                          

FUNCTION  aws_create_asfi528()                                                                      
                                                                                                   
 WHENEVER ERROR CONTINUE                                                                           
                                                                                                   
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序                                           
                                                                                                   
    #--------------------------------------------------------------------------#                   
    # 新增完工入庫單資料                                                       #                   
    #--------------------------------------------------------------------------#                   
    IF g_status.code = "0" THEN                                                                    
       CALL aws_create_asfi528_process()                                                           
    END IF                                                                                         
                                                                                                   
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序                                           
     DROP TABLE i528_file                                                                          
     DROP TABLE i528_file1                                                                         
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
FUNCTION aws_create_asfi528_process() 
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
   DEFINE l_i528_file      RECORD                    #单身                                        
                 sfs04     LIKE sfs_file.sfs04,      #料号       
                 sfs05     LIKE sfs_file.sfs05,      #数量 
                 sfs05a    LIKE sfs_file.sfs05       #匹配量     
                                           
                 END RECORD                                                                        
  DEFINE  l_i528_file1     RECORD               
                   barcode    LIKE ibb_file.ibb01,      #物料编码   
                   ima01      LIKE ima_file.ima01,      #料件编号   
                   batch      LIKE ibb_file.ibb01,      #批号       
                   sfs05b     LIKE sfs_file.sfs05       #数量
                                            
                 END RECORD                                                                        
   DROP TABLE l_i528_file                                                                            
   DROP TABLE l_i528_file1  
                                                                            
   CREATE TEMP TABLE i528_file(                                                                    
                 sfs04     LIKE sfs_file.sfs04,      #料号       
                 sfs05     LIKE sfs_file.sfs05,      #数量 
                 sfs05a    LIKE sfs_file.sfs05)      #匹配量                                
   CREATE TEMP TABLE i528_file1(                                                                   
                   barcode    LIKE ibb_file.ibb01,      #物料编码   
                   ima01      LIKE ima_file.ima01,      #料件编号   
                   batch      LIKE ibb_file.ibb01,      #批号       
                   sfs05b     LIKE sfs_file.sfs05)      #数量 
  #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    LET g_success = 'Y'
    INITIALIZE g_hlf528.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF


    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點

        LET g_sfb01 = aws_ttsrv_getRecordField(l_node1,"sfb01")  
        LET g_sfs07 = aws_ttsrv_getRecordField(l_node1,"sfs07")    
        LET g_sfs08 = aws_ttsrv_getRecordField(l_node1,"sfs08")
        #----------------------------------------------------------------------#
        # 處理第一單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "i528_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_k = 1 TO l_cnt3
            INITIALIZE l_i528_file.* TO NULL
            LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_k,"i528_file")   #目前單身的 XML 節點

            #------------------------------------------------------------------#
            # NODE資料傳到RECORD                                               #
            #------------------------------------------------------------------#

        LET l_i528_file.sfs04  = aws_ttsrv_getRecordField(l_node3, "sfs04")   #取
        LET l_i528_file.sfs05  = aws_ttsrv_getRecordField(l_node3, "sfs05")                        
        LET l_i528_file.sfs05a = aws_ttsrv_getRecordField(l_node3, "sfs05a")                        
                                                                                                   
        INSERT INTO i528_file VALUES (l_i528_file.*)    
        END FOR
        #----------------------------------------------------------------------#
        # 處理第二單身資料                                                         #
        #----------------------------------------------------------------------#        
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "i528_file1")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_j = 1 TO l_cnt2                                                                      
        INITIALIZE l_i528_file1.* TO NULL                                                       
        LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_j,"i528_file1")   #目前                 
                                                                                                   
            ------------------------------------------------------------------#                   
            #NODE資料傳到RECORD                                               #                   
            ------------------------------------------------------------------#                   
            LET l_i528_file1.barcode = aws_ttsrv_getRecordField(l_node2, "barcode")                                              
            LET l_i528_file1.ima01   = aws_ttsrv_getRecordField(l_node2, "ima01")                    
            LET l_i528_file1.batch   = aws_ttsrv_getRecordField(l_node2, "batch")
            LET l_i528_file1.sfs05b  = aws_ttsrv_getRecordField(l_node2, "sfs05b")             
            
                               
            INSERT INTO i528_file1 VALUES (l_i528_file1.*)
        END FOR    
    END FOR

    IF g_status.code='0' THEN 
       CALL i528_load()
       IF g_success = 'Y' THEN
         CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_hlf528))
       END IF
    END IF 
END FUNCTION
                   
                                                      
                                                                                                   
FUNCTION i528_load() 
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

    
    #LET g_success = "Y"

     BEGIN WORK

     IF g_success = "Y" THEN
        CALL ins_asfi528()
     END IF
     INITIALIZE l_iba.* TO NULL
     INITIALIZE l_ibb.* TO NULL
     INITIALIZE g_tlfb.* TO NULL
   
     IF g_success = "Y" THEN 
        LET g_sql ="select * FROM i528_file1",
   	             " order by barcode"
            PREPARE t001_ipb_iba FROM g_sql
            DECLARE t001_iba CURSOR FOR t001_ipb_iba
            FOREACH t001_iba INTO l_ibb01,l_sfa03,l_sfaiicd03,l_ibb07
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
        #            LET l_ibb.ibb17=l_sfaiicd03  #批号
        #            LET l_ibb.ibb14=l_ibb07      #数量
        #            LET l_ibb.ibb20=g_today      #生成日期
        #            SELECT to_char(sysdate,'hh24miss') INTO l_ibb.ibb19 from dual
        #            SELECT to_char(sysdate,'hh24miss') INTO l_ibb.ibb19 from dual
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
        LET g_sql ="select barcode,batch,sfs05b FROM i528_file1",
   	              " order by barcode"
          INITIALIZE g_tlfb.* TO NULL
          PREPARE i510_ipb5 FROM g_sql
          DECLARE i510_ic5 CURSOR FOR i510_ipb5              
            FOREACH i510_ic5 INTO g_tlfb.tlfb01,g_tlfb.tlfb04,g_tlfb.tlfb05
             IF STATUS THEN
#               CALL cl_err('foreach i510_ic1:',STATUS,1)
               EXIT FOREACH
             END IF 
              LET  g_tlfb.tlfb02 =g_sfs07
              LET  g_tlfb.tlfb03 =g_sfs08
              LET  g_tlfb.tlfb09 =g_sfp01
              LET  g_tlfb.tlfb10 =0
              LET  g_tlfb.tlfb07 =g_sfb01
              LET  g_tlfb.tlfb08 =0
              LET  g_tlfb.tlfb905= g_sfp01
              LET  g_tlfb.tlfb906=0         
              LET  g_tlfb.tlfb06 = 1   #入库
              LET  g_tlfb.tlfb17 = ' '             #杂收理由码
              LET  g_tlfb.tlfb18 = ' '             #产品分类码 
              LET  g_tlfb.tlfb19='Y'               #扣账否为N
              CALL s_web_tlfb('','','','','')  #更新条码异动档
              LET g_sql =" SELECT COUNT(*) FROM imgb_file ",
                            "WHERE imgb01='",g_tlfb.tlfb01,"'",
                            " AND imgb02='",g_tlfb.tlfb02,"'",
                            " AND imgb03='",g_tlfb.tlfb03,"'" ,
                            " AND imgb04='",g_tlfb.tlfb04,"'"
                            
                 PREPARE i510_imgb_pre FROM g_sql
                 EXECUTE i510_imgb_pre INTO l_n
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
      LET g_prog = 'asfi528'   
   	  CALL i501sub_s('2',g_sfp01,TRUE,'N')
      LET g_prog = 'aws_ttsrv2'    
   END IF
   IF g_success = "Y" THEN
      COMMIT WORK
   ELSE 
   	  ROLLBACK WORK
   END IF 
END FUNCTION                                                                                                       
                                                                                                   
FUNCTION ins_asfi528()
   DEFINE l_sfp  RECORD LIKE sfp_file.*
   DEFINE l_sfq  RECORD LIKE sfq_file.*
   DEFINE l_sfs  RECORD LIKE sfs_file.*
   DEFINE l_rvbs RECORD LIKE rvbs_file.*
   DEFINE l_j,l_j2    LIKE sfs_file.sfs02
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
   DEFINE l_sfs04    LIKE sfs_file.sfs04
   DEFINE l_sfs05    LIKE sfs_file.sfs05
   DEFINE l_sfs05a   LIKE sfs_file.sfs05
   DEFINE l_sfa03    LIKE sfa_file.sfa03,
          l_sfa30    LIKE sfa_file.sfa30,
          l_sfa31    LIKE sfa_file.sfa31,
          l_ibb07    LIKE ibb_file.ibb07,
          l_sfb01  LIKE sfb_file.sfb01,
          l_n,l_cnt11      LIKE type_file.num5
   
  
   INITIALIZE l_sfp.* TO NULL
   LET l_sfp.sfp02 = g_today
   LET l_sfp.sfp03 = g_today

   SELECT tc_codesys14 INTO l_sfp.sfp01 FROM tc_codesys_file WHERE tc_codesys00='0'
   IF cl_null(l_sfp.sfp01) THEN
      LET g_status.code = "-1"
      LET g_status.description = "没有维护此工单相应的发料单别!"
   	  LET g_success = 'N'
      RETURN
   END IF
   CALL s_auto_assign_no("asf",l_sfp.sfp01,l_sfp.sfp02,"","sfp_file","sfp01","","","")
        RETURNING li_result,l_sfp.sfp01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   LET g_sfp01  =  l_sfp.sfp01
   LET g_hlf528.sfp01 = g_sfp01
   LET l_sfp.sfp04 = 'N'
   LET l_sfp.sfp05 = 'N'
   LET l_sfp.sfp06 = '8'
   LET l_sfp.sfpuser = g_user
   
   SELECT gen03 INTO l_sfp.sfpgrup
     FROM gen_file
    WHERE gen01 = l_sfp.sfpuser
   LET l_sfp.sfp16 = g_user
   LET l_sfp.sfp07 = l_sfp.sfpgrup
   LET l_sfp.sfp09 = 'N'
   LET l_sfp.sfpdate = g_today
   LET l_sfp.sfpconf = 'Y'
   LET l_sfp.sfpplant = g_plant
   LET l_sfp.sfplegal = g_legal
   LET l_sfp.sfpmksg = 'N'
   LET l_sfp.sfp15 = '1'
   #客户特有
   LET l_sfp.sfpud02=g_sfs07  #仓库
   
   INSERT INTO sfp_file VALUES (l_sfp.*)
   IF SQLCA.SQLCODE THEN
      LET g_success = 'N'
      RETURN
   END IF
      
    LET l_sql = " SELECT sfs04,sfs05,sfs05a FROM i528_file",
                " ORDER BY sfs04"
    PREPARE t510_rvbs_p FROM l_sql
    IF STATUS THEN
          LET g_status.code = "-1"
          LET g_status.description = "接口存在错误!"
             EXIT PROGRAM
    END IF
    DECLARE t528_rvbs_c CURSOR FOR t510_rvbs_p
    
    FOREACH t528_rvbs_c INTO l_sfs04,l_sfs05,l_sfs05a
       IF SQLCA.SQLCODE THEN 
       	LET g_success = 'N' 
       	EXIT FOREACH 
       END IF
       
          INITIALIZE l_sfs.* TO NULL
          LET l_sfs.sfs01 = l_sfp.sfp01
          SELECT MAX(sfs02)+1 INTO l_sfs.sfs02 FROM sfs_file WHERE sfs01=l_sfs.sfs01
          IF cl_null(l_sfs.sfs02) THEN
          	  LET l_sfs.sfs02=1
          END IF
          LET l_sfs.sfs03 = g_sfb01
          LET l_sfs.sfs04 = l_sfs04
          
          IF cl_null(l_sfs.sfs04) THEN
             LET g_success = 'N'
             LET g_status.code = "-1"
             LET g_status.description = "料号为空!"
             RETURN	
          END IF
          LET l_sfs.sfs07 = g_sfs07
          LET l_sfs.sfs08 = ' '   #库位
          LET l_sfs.sfs09 = ' '   #批号
          LET l_sfs.sfs05 = l_sfs05a #数量
          SELECT sfa26,sfa27,sfa28,sfa12,sfa08
            INTO l_sfs.sfs26,l_sfs.sfs27,l_sfs.sfs28,l_sfs.sfs06,l_sfs.sfs10
            FROM sfa_file
           WHERE sfa01 = g_sfb01
             AND sfa03 = l_sfs.sfs04
             
          
          
          LET l_sfs.sfsplant = g_plant
          LET l_sfs.sfslegal = g_legal
          LET l_sfs.sfs014 = ' '
          LET l_sfs.sfs012 = ' '
          LET l_sfs.sfs013 = 0
          
          INSERT INTO sfs_file VALUES (l_sfs.*)
          IF SQLCA.SQLCODE THEN
           	 LET g_success = 'N'
             LET g_status.code = "-1"
             LET g_status.description = "插入sfs_file发生错误！"
           	 RETURN
          END IF
           
   END FOREACH

END FUNCTION                                                                    
                                                                                                   
                                                                                                   
