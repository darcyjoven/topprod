# Prog. Version..: '5.30.06-13.03.12(00000)'
#
# Pattern name...: aws_create_aimt301.4gl
# Descriptions...: 提供产生杂项发料单据
# Date & Author..:2016-05-26 15:03:09  shenran

DATABASE ds                                               
                                                           
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aws_ttsrv2_global.4gl"              
GLOBALS "../../aba/4gl/barcode.global"       
    
GLOBALS 
DEFINE g_ina11    LIKE ina_file.ina11        #申请人编码                                               
DEFINE g_ina04    LIKE ina_file.ina04        #部门编码
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
                      
END GLOBALS                                                          

FUNCTION  aws_create_aimt301()                                                                      
                                                                                                   
 WHENEVER ERROR CONTINUE                                                                           
                                                                                                   
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序                                           
                 
    IF g_status.code = "0" THEN                                                                    
       CALL aws_create_aimt301_process()                                                           
    END IF                                                                                         
                                                                                                   
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序                                           
     DROP TABLE i301_file                                                                   
     DROP TABLE i301_file1                                                                         
END FUNCTION                                                                                       
                                                                                                                                                                                              
FUNCTION aws_create_aimt301_process() 
   DEFINE l_i          LIKE type_file.num10,
          l_j          LIKE type_file.num10,
          l_k          LIKE type_file.num10
   DEFINE l_cnt        LIKE type_file.num10,
          l_cnt1       LIKE type_file.num10,
          l_cnt2       LIKE type_file.num10,
          l_cnt3       LIKE type_file.num10
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
   DEFINE l_i301_file      RECORD                    #单身1                                        
                 inb15     LIKE inb_file.inb15,      #理由码编码       
                 inb04     LIKE inb_file.inb04,      #料件    
                 inb16     LIKE inb_file.inb16,      #数量     
                 inb05     LIKE inb_file.inb05       #仓库    
                 END RECORD                                                                        
  DEFINE  l_i301_file1     RECORD               
                   barcode LIKE type_file.chr50,     #批次条码   
                   ima01   LIKE ima_file.ima01,      #料件编号   
                   batch   LIKE type_file.chr50,     #批次 
                   inb06   LIKE inb_file.inb06,      #库位         
                   inb16a  LIKE inb_file.inb16       #数量       
                 END RECORD                                                                        
   DROP TABLE i301_file                                                                            
   DROP TABLE i301_file1
                                                                            
   CREATE TEMP TABLE i301_file(                                                                  
                 inb15     LIKE inb_file.inb15,      #理由码编码       
                 inb04     LIKE inb_file.inb04,      #料件    
                 inb16     LIKE inb_file.inb16,      #数量     
                 inb05     LIKE inb_file.inb05)      #仓库 
                                                 
   CREATE TEMP TABLE i301_file1(                                                                   
                  barcode LIKE type_file.chr50,     #批次条码   
                  ima01   LIKE ima_file.ima01,      #料件编号   
                  batch   LIKE type_file.chr50,     #批次 
                  inb06   LIKE inb_file.inb06,      #库位         
                  inb16a  LIKE inb_file.inb16)      #数量
                    
  #--------------------------------------------------------------------------#
    # 處理呼叫方傳遞給 ERP 的完工入庫單資料                                    #
    #--------------------------------------------------------------------------#
    INITIALIZE g_ina301.* TO NULL
    LET l_cnt1 = aws_ttsrv_getMasterRecordLength("Master")            #取得共有幾筆單檔資料 *** 原則上應該僅一次一筆！ ***

    IF l_cnt1 = 0 THEN
       LET g_status.code = "-1"
       LET g_status.description = "No recordset processed!"
       RETURN
    END IF

    FOR l_i = 1 TO l_cnt1
        LET l_node1 = aws_ttsrv_getMasterRecord(l_i, "Master")       #目前處理單檔的 XML 節點

        LET g_ina11 = aws_ttsrv_getRecordField(l_node1,"ina11")  
        LET g_ina04 = aws_ttsrv_getRecordField(l_node1,"ina04")    

        #----------------------------------------------------------------------#
        # 處理第一單身資料                                                         #
        #----------------------------------------------------------------------#
        LET l_cnt2 = aws_ttsrv_getDetailRecordLength(l_node1, "i301_file")       #取得目前單頭共有幾筆單身資料
        IF l_cnt2 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_k = 1 TO l_cnt2
            INITIALIZE l_i301_file.* TO NULL
            LET l_node2 = aws_ttsrv_getDetailRecord(l_node1, l_k,"i301_file")   #目前單身的 XML 節點

            LET l_i301_file.inb15 = aws_ttsrv_getRecordField(l_node2, "inb15")
            LET l_i301_file.inb04 = aws_ttsrv_getRecordField(l_node2, "inb04")                        
            LET l_i301_file.inb16 = aws_ttsrv_getRecordField(l_node2, "inb16")                        
            LET l_i301_file.inb05 = aws_ttsrv_getRecordField(l_node2, "inb05")                                            
                                                                                                      
            INSERT INTO i301_file VALUES (l_i301_file.*)    
        END FOR
        #----------------------------------------------------------------------#
        # 處理第二單身資料                                                         #
        #----------------------------------------------------------------------#        
        LET l_cnt3 = aws_ttsrv_getDetailRecordLength(l_node1, "i301_file1")       #取得目前單頭共有幾筆單身資料
        IF l_cnt3 = 0 THEN
           LET g_status.code = "mfg-009"   #必須有單身資料
           EXIT FOR
        END IF
        
        FOR l_j = 1 TO l_cnt3                                                                      
        INITIALIZE l_i301_file1.* TO NULL                                                       
        LET l_node3 = aws_ttsrv_getDetailRecord(l_node1, l_j,"i301_file1")   #目前                 

            LET l_i301_file1.barcode = aws_ttsrv_getRecordField(l_node3, "barcode")                                              
            LET l_i301_file1.ima01   = aws_ttsrv_getRecordField(l_node3, "ima01")                    
            LET l_i301_file1.batch   = aws_ttsrv_getRecordField(l_node3, "batch")
            LET l_i301_file1.inb06   = aws_ttsrv_getRecordField(l_node3, "inb06")             
            LET l_i301_file1.inb16a  = aws_ttsrv_getRecordField(l_node3, "inb16a")                       
            INSERT INTO i301_file1 VALUES (l_i301_file1.*)                                                   
        END FOR    
    END FOR
    IF g_status.code='0' THEN
       CALL i301_load()

       IF g_success = 'Y' THEN
          CALL aws_ttsrv_addParameterRecord(base.TypeInfo.create(g_ina301))
       END IF
    END IF 
END FUNCTION
                   
                                                      
                                                                                                   
FUNCTION i301_load()
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
   DEFINE l_inb06     LIKE inb_file.inb06
   DEFINE l_inb16a    LIKE inb_file.inb16
   DEFINE l_iba       RECORD LIKE iba_file.*
   DEFINE l_ibb       RECORD LIKE ibb_file.*

    
    LET g_success = "Y"

     BEGIN WORK

     CALL ins_aimt301()
     
     IF g_success = "Y" THEN

        INITIALIZE g_tlfb.* TO NULL
        INITIALIZE l_iba.* TO NULL
        INITIALIZE l_ibb.* TO NULL
        LET g_sql ="select barcode,ima01,batch,inb06,inb16a from i301_file1"
            PREPARE t001_ipb_iba FROM g_sql
            DECLARE t001_iba CURSOR FOR t001_ipb_iba
            FOREACH t001_iba INTO l_barcode,l_ima01,l_batch,l_inb06,l_inb16a
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
                    LET l_ibb.ibb03=g_ina.ina01    #来源单号
                    LET l_ibb.ibb04=0              #来源项次
                    LET l_ibb.ibb05=0              #包号
                    LET l_ibb.ibb06=l_ima01        #料号
                    LET l_ibb.ibb11='Y'            #使用否         
                    LET l_ibb.ibb12=0              #打印次数
                    LET l_ibb.ibb13=0              #检验批号(分批检验顺序)
                    LET l_ibb.ibbacti='Y'          #资料有效码
          #          LET l_ibb.ibb17=l_batch        #批号
          #          LET l_ibb.ibb14=l_inb16a       #数量
          #          LET l_ibb.ibb20=g_today        #生成日期
                    INSERT INTO ibb_file VALUES(l_ibb.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        LET g_success = 'N'
                        LET g_status.code = "-1"
                        LET g_status.description = "插入ibb_file有误!"
                        RETURN
                    END IF
              END IF

              LET  g_tlfb.tlfb01 = l_barcode
              SELECT ime01 INTO g_tlfb.tlfb02 FROM ime_file WHERE ime02=l_inb06
              LET  g_tlfb.tlfb03 = l_inb06
              LET  g_tlfb.tlfb04 = l_batch
              LET  g_tlfb.tlfb05 = l_inb16a
              LET  g_tlfb.tlfb09 = g_ina.ina01
              LET  g_tlfb.tlfb08 = ' ' 
              LET  g_tlfb.tlfb07 = g_ina.ina01
              LET  g_tlfb.tlfb10 = ' '  
              LET  g_tlfb.tlfb905= g_ina.ina01
              LET  g_tlfb.tlfb906= ' '         
              LET  g_tlfb.tlfb06 = -1   #入库
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
     IF g_success = 'Y' THEN   #审核检核
       CALL t370sub_y_chk(g_ina.ina01,'1','N') #FUN-B50138  #TQC-C40079 add Y
     END IF
     IF g_success = "Y" THEN   #审核
        CALL t370sub_y_upd(g_ina.ina01,'N',TRUE) #FUN-B50138
     END IF
     IF g_success = "Y" THEN   #过账检核
        CALL t370sub_s_chk(g_ina.ina01,'N',TRUE,g_today)    #CALL 原確認的 check 段 #FUN-B50138
     END IF
     IF g_success = "Y" THEN   #过账
        CALL t370sub_s_upd(g_ina.ina01,'1',TRUE)       #CALL 原確認的 update 段#FUN-B50138
     END IF
     LET g_prog="aws_ttsrv2"
     IF g_success = "Y" THEN
        COMMIT WORK
     ELSE 
   	    ROLLBACK WORK
     END IF
END FUNCTION                                                                                                                                         
                                                                                                   
FUNCTION ins_aimt301()
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
   DEFINE l_sfs06    LIKE sfs_file.sfs06
   DEFINE l_inb      RECORD LIKE inb_file.*  
   DEFINE l_sfa03    LIKE sfa_file.sfa03,
          l_sfa30    LIKE sfa_file.sfa30,
          l_sfa31    LIKE sfa_file.sfa31,
          l_ibb07    LIKE ibb_file.ibb07,
          l_sfb01  LIKE sfb_file.sfb01,
          l_n      LIKE type_file.num5
   
     INITIALIZE g_ina.* TO NULL
     LET g_ina.ina04=g_ina04
     LET g_ina.ina11=g_ina11
     LET g_ina.ina00='1'
     LET g_ina.ina02=g_today
     LET g_ina.ina03=g_today
     LET g_ina.ina08='0'
     LET g_ina.inapost='N'
     LET g_ina.inauser=g_user
     LET g_ina.inagrup=g_grup
     LET g_ina.inamodu=g_user
     LET g_ina.inadate=g_today
     LET g_ina.inamksg='N'
     LET g_ina.inaconf='N'
     LET g_ina.inaspc='0'
     LET g_ina.ina12='N'
     LET g_ina.inacond=g_today
     LET g_ina.inacont= time
     LET g_ina.inaconu= g_user
     LET g_ina.inapos= 'N'
     LET g_ina.inaplant= g_plant
     LET g_ina.inalegal= g_legal
     LET g_ina.inaoriu= g_user
     LET g_ina.inaorig= g_grup
     LET g_ina.inaprsw ='0'
     SELECT tc_codesys04 INTO g_ina.ina01 FROM tc_codesys_file WHERE tc_codesys00='0'
     CALL s_auto_assign_no("aim",g_ina.ina01,g_ina.ina03,"1","ina_file","ina01","","","")
     RETURNING li_result,g_ina.ina01
     IF (NOT li_result) THEN
        LET g_success = 'N'
        LET g_status.code = "-1"
        LET g_status.description = "产生杂发单号有误!"
        RETURN
     END IF
     INSERT INTO ina_file VALUES(g_ina.*)
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        LET g_success = 'N'
        LET g_status.code = "-1"
        LET g_status.description = "插入ina_file有误!"        
        RETURN
     ELSE 
     	  LET g_ina301.ina01=g_ina.ina01
     END IF

     LET l_sql=" select inb15,inb04,inb16,inb05 from i301_file"
     PREPARE t906_ipb4 FROM l_sql
     DECLARE t906_ic4 CURSOR FOR t906_ipb4
     FOREACH t906_ic4 INTO l_inb.inb15,l_inb.inb04,l_inb.inb16,l_inb.inb05
        IF STATUS THEN
          EXIT FOREACH
        END IF
        LET l_inb.inb01 = g_ina.ina01
        LET l_inb.inb07 = ' '
        LET l_inb.inb06 = ' '
        SELECT MAX(inb03)+1 INTO l_inb.inb03 FROM inb_file WHERE inb01=l_inb.inb01
        IF cl_null(l_inb.inb03) THEN
        	  LET l_inb.inb03=1
        END IF
        SELECT img09 INTO l_inb.inb08 FROM img_file
        WHERE img01=l_inb.inb04 AND img02=l_inb.inb05
          AND img03=l_inb.inb06 AND img04=l_inb.inb07
        IF STATUS THEN
        CALL s_add_img(l_inb.inb04,l_inb.inb05,
                       l_inb.inb06,l_inb.inb07,
                       g_ina.ina01,l_inb.inb03,g_ina.ina02)
        END IF
        SELECT img09 INTO l_inb.inb08 FROM img_file
        WHERE img01=l_inb.inb04 AND img02=l_inb.inb05
          AND img03=l_inb.inb06 AND img04=l_inb.inb07
        LET l_inb.inb08_fac=1  
        LET l_inb.inb09 = l_inb.inb16
        LET l_inb.inb10='N'
        LET l_inb.inb11=' '
        LET l_inb.inb12=' '
        LET l_inb.inb13=0
        LET l_inb.inb901=' '
        LET l_inb.inb908=0
        LET l_inb.inb909=0
        LET l_inb.inbplant=g_plant
        LET l_inb.inblegal=g_legal
        
        INSERT INTO inb_file VALUES(l_inb.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success = 'N'
           LET g_status.code = "-1"
           LET g_status.description = "插入inb_file有误!"      
           RETURN
        END IF
     END FOREACH
END FUNCTION                                                                    
                                                                                                   
                                                                                                   
