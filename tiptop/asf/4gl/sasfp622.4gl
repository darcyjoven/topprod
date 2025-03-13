# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp622.4gl
# Descriptions...: 拆件式工單 BOM 展開
# Date & Author..: No.FUN-880011 08/08/14 By sherry  
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.MOD-8C0073 08/12/09 By sherry 增加對完工入庫日期的控管
# Modify.........: No.MOD-910084 09/01/09 By claire 有勾展至尾階時,M件不應展出
# Modify.........: No.TQC-910052 09/01/21 By claire 修改MOD-8C0073語法
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-950021 09/05/31 By Carrier 組合拆解
# Modify.........: No.FUN-980008 09/08/17 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990069 09/09/21 By Carrier 展bom考慮下階料失效問題
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A30193 10/03/30 By Summer 若輸入的工單是要FQC的則UI畫面的入庫量與是否展至尾階等兩欄位不能輸入,
# Modify.........: No:FUN-A70034 10/07/21 By Carrier 平行工艺-分量损耗运用
#                                                   在產生單身時須依據已經key FQC單且未入庫的做為產生單身資料的依據
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# MOdify.........: No.FUN-910088 11/12/19 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BC0104 12/01/04 By xujing   
# Modify.........: No.FUN-BC0104 12/01/29 By xianghui 數量異動回寫qco20
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:MOD-C60047 12/06/06 By ck2yuan 若事後扣帳,則控卡入庫日期不可小於工單開立日期
# Modify.........: No:FUN-D10094 13/01/21 By fengrui 單身添加理由碼,aza115=Y時預設理由碼
# Modify.........: No:FUN-D20060 13/02/22 By nanbing 設限倉庫控卡
# Modify.........: No:FUN-D60027 13/06/06 By lixiang 對工單是否發料的控管移到對日期的控管之前
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_ksd        RECORD LIKE ksd_file.*, 
    g_sfb        RECORD LIKE sfb_file.*,    
    tm  RECORD	
          part     LIKE ksd_file.ksd01,
          store    LIKE ksd_file.ksd05,
          location LIKE ksd_file.ksd06,
          qty      LIKE ksd_file.ksd09,
          a        LIKE type_file.chr1   	 
        END RECORD,
    g_cnt        LIKE type_file.num5,     
    g_factor     LIKE img_file.img21,
    g_ima44      LIKE ima_file.ima44,
    g_ima25      LIKE ima_file.ima25,
    g_ima906     LIKE ima_file.ima906,
    g_ima907     LIKE ima_file.ima907,
    g_ccc        LIKE type_file.num5,     
    g_argv1      LIKE type_file.chr1,     
    g_ksc04      LIKE ksc_file.ksc04,   
    g_ksc02      LIKE ksc_file.ksc02,  #MOD-8C0073 add
    l_date       LIKE sfp_file.sfp02,  #MOD-8C0073 add  
    g_min_set    LIKE sfb_file.sfb08,
    g_imd02      LIKE imd_file.imd02,
    #g_sql1       LIKE type_file.chr1000,
    #g_sql2       LIKE type_file.chr1000 
    g_sql1,g_sql2        STRING       #NO.FUN-910082  
FUNCTION p622(p_argv1)   
 
   DEFINE l_time  LIKE type_file.chr8,    
          #l_sql   LIKE type_file.chr1000, 
          l_sql        STRING,       #NO.FUN-910082  
          l_n1    LIKE type_file.num5,    
          p_argv1 LIKE ksc_file.ksc01     
   DEFINE l_sfb05 LIKE sfb_file.sfb05
   DEFINE l_sfb05_1 LIKE sfb_file.sfb05,
          l_aa LIKE ksd_file.ksd07
   DEFINE l_sfb39 LIKE sfb_file.sfb39     #MOD-C60047 add

   WHENEVER ERROR CONTINUE
    IF p_argv1 IS NULL OR p_argv1 = ' ' THEN 
       CALL cl_err(p_argv1,'asr-045',0) 
       RETURN
    END IF
 
    LET g_ccc=0
    LET g_ksd.ksd01  = p_argv1
    SELECT ksc04,ksc02 INTO g_ksc04,g_ksc02 FROM ksc_file  #MOD-8C0073 add ksc02 #TQC-910052 modify
                             WHERE ksc01=p_argv1
    IF SQLCA.sqlcode THEN LET g_ksc04=NULL END IF
    LET tm.part=''       #MOD-A30193 add
    LET tm.store=''      #MOD-A30193 add
    LET tm.location=''   #MOD-A30193 add
    LET tm.qty=0
    LET tm.a='N'
 
WHILE TRUE 
    #-->條件畫面輸入
    OPEN WINDOW p622_w AT 6,30 WITH FORM "asf/42f/asfp622" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("asfp622")
 
    INPUT BY NAME tm.part,tm.store,tm.location,tm.qty,tm.a WITHOUT DEFAULTS
      #str MOD-A30193 add
       BEFORE FIELD part
          IF cl_null(tm.part) THEN
             CALL p622_set_entry()
          END IF
      #end MOD-A30193 add

       AFTER FIELD part
          IF NOT cl_null(tm.part) THEN
             SELECT sfb39 INTO l_sfb39 FROM sfb_file WHERE sfb01=tm.part   #MOD-C60047 add
             
            #FUN-D60027--add--begin---     
              CALL p622_sfb01()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(tm.part,g_errno,0)
                 NEXT FIELD part
              END IF
            #FUN-D60027--add--end---                  
             
             #MOD-8C0073---Begin
             #檢查工單最小發料日是否小於入庫日
             IF l_sfb39 !=2 THEN                 #MOD-C60047 add
               SELECT MIN(sfp02) INTO l_date FROM sfe_file,sfp_file
                 WHERE sfe01 = tm.part AND sfe02 = sfp01
                IF STATUS OR cl_null(l_date) THEN
                   SELECT MIN(sfp02) INTO l_date FROM sfs_file,sfp_file
                    WHERE sfs03=tm.part AND sfp01=sfs01
                END IF
                IF cl_null(l_date) OR l_date > g_ksc02 THEN
                   CALL cl_err('sel_sfp02','asf-824',1)
                   NEXT FIELD part
                END IF
             #MOD-8C0073---End 
            #MOD-C60047 str add ------
             ELSE
                SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = tm.part
                IF cl_null(l_date) OR l_date > g_ksc02 THEN
                   CALL cl_err(tm.part,'asf-342',1)
                   NEXT FIELD part
                END IF
             END IF
            #MOD-C60047 end add ------
            #FUN-D60027--mark--begin---
             #CALL p622_sfb01()
             #IF NOT cl_null(g_errno) THEN
             #   CALL cl_err(tm.part,g_errno,0)
             #   NEXT FIELD part
             #END IF
            #FUN-D60027--mark--end---
              CALL p622_set_no_entry()   #MOD-A30193 add
          ELSE
                 SELECT * INTO g_sfb.* FROM sfb_file
                  WHERE sfb01=tm.part
                    AND sfb04!= '8' AND sfb02 = 11
                 IF STATUS THEN
                    CALL cl_err3("sel","sfb_file",tm.part,"",STATUS,"","sel sfb",1)  
                    NEXT FIELD part
                 END IF
          END IF
           
        AFTER FIELD store     #倉庫
           IF NOT cl_null(tm.store) THEN
                 SELECT imd02 INTO g_imd02 FROM imd_file
                  WHERE imd01=tm.store AND imd10='S'
                     AND imdacti = 'Y' 
                 IF STATUS THEN
                    CALL cl_err3("sel","imd_file",tm.store,"","mfg1100","","imd",1)  
                    NEXT FIELD store
                 END IF
              #FUN-D20060 str
              #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
              LET g_sql1 = " SELECT sfb05 FROM sfb_file ",
                           "  WHERE sfb01 = '",tm.part,"' "
              PREPARE bom_p12 FROM g_sql1
              DECLARE bom_cs12 CURSOR FOR bom_p12
              FOREACH bom_cs12 INTO l_sfb05
                 IF NOT s_chksmz(l_sfb05, g_ksd.ksd01,tm.store, tm.location) THEN
                    NEXT FIELD store
                 END IF
              END FOREACH
              #FUN-D20060 end  
           
           END IF
 
        AFTER FIELD location   #儲位
           #BugNo:5626 控管是否為全型空白
           IF tm.location = '　' THEN #全型空白
               LET tm.location = ' '
           END IF
           IF tm.location IS NULL THEN LET tm.location = ' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(tm.store) THEN #FUN-D20060 add
           LET g_sql1 = " SELECT sfb05 FROM sfb_file ", 
                       "  WHERE sfb01 = '",tm.part,"' "
           PREPARE bom_p11 FROM g_sql1
           DECLARE bom_cs11 CURSOR FOR bom_p11
           FOREACH bom_cs11 INTO l_sfb05 
             IF NOT s_chksmz(l_sfb05, g_ksd.ksd01,tm.store, tm.location) THEN
                NEXT FIELD location
             END IF
           END FOREACH
           END IF #FUN-D20060 add
       AFTER FIELD qty
          IF cl_null(tm.qty) OR tm.qty<=0 THEN NEXT FIELD qty END IF
       
       AFTER FIELD a
          IF cl_null(tm.a) OR tm.a NOT matches '[YN]' THEN NEXT FIELD a END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
       ON ACTION controlp
          CASE
             WHEN INFIELD(part)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb11"
                LET g_qryparam.default1 = tm.part
                #No.FUN-950021  --Begin
                ##組合拆解的工單不顯示出來!
               #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "     #FUN-B40029
                #No.FUN-950021  --End  
                CALL cl_create_qry() RETURNING tm.part
                DISPLAY tm.part TO FORMONLY.part
                NEXT FIELD part
             WHEN INFIELD(store) OR INFIELD(location) 
             LET g_sql2 = " SELECT sfb05 FROM sfb_file ", 
                       "  WHERE sfb01 = '",tm.part,"' "
           PREPARE bom_p111 FROM g_sql2
           DECLARE bom_cs111 CURSOR FOR bom_p111
           FOREACH bom_cs111 INTO l_sfb05_1 
              #FUN-C30300---begin
              LET g_ima906 = NULL
              SELECT ima906 INTO g_ima906 FROM ima_file
               WHERE ima01 = l_sfb05_1
              #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
              IF s_industry("icd") THEN  #TQC-C60028
                 CALL q_idc(FALSE,TRUE,l_sfb05_1,tm.store,tm.location,'')
                 RETURNING tm.store,tm.location,l_aa
              ELSE
              #FUN-C30300---end 
                 CALL q_img4(FALSE,TRUE,l_sfb05_1,tm.store,   
                                tm.location,'','A')
                      RETURNING tm.store,tm.location,l_aa
              END IF #FUN-C30300
                       DISPLAY tm.store TO FORMONLY.store
                       DISPLAY tm.location TO FORMONLY.location
                       IF INFIELD(store) THEN NEXT FIELD store END IF
                       IF INFIELD(location) THEN NEXT FIELD location END IF
                END FOREACH
             OTHERWISE EXIT CASE
          END CASE
       
       ON ACTION about         
          CALL cl_about()     
 
       ON ACTION help          
          CALL cl_show_help()  
 
       ON ACTION controlg      
          CALL cl_cmdask()     
 
       BEFORE INPUT
           CALL cl_qbe_init()
           CALL p622_set_entry()      #MOD-A30193 add
           CALL p622_set_no_entry()   #MOD-A30193 add
 
       ON ACTION qbe_select
          CALL cl_qbe_select()
       
       ON ACTION qbe_save
          CALL cl_qbe_save()
       
    END INPUT
    IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW p622_w RETURN END IF
    CALL p622_init()
    LET g_ksd.ksd07 = l_aa
   #str MOD-A30193 mod
   #若輸入之工單是要做FQC的,則依據FQC單產生單身,
   #若輸入之工單是不做FQC的,則依據BOM產生單身
   #CALL p622_bom()
    IF g_sfb.sfb94='Y' THEN
       CALL p622_fqc()
    ELSE
       CALL p622_bom()
    END IF
   #end MOD-A30193 mod

    CLOSE WINDOW p622_w
    EXIT WHILE
END WHILE          
END FUNCTION
 
FUNCTION p622_init()
   
    LET g_ksd.ksd03 = 0
    LET g_ksd.ksd11 = ''
    LET g_ksd.ksd04 = ''
    LET g_ksd.ksd08 = ''
    LET g_ksd.ksd05 = tm.store
    LET g_ksd.ksd06 = tm.location
    LET g_ksd.ksd07 = ''
    IF tm.qty != 0 THEN   #MOD-A30193 add
       LET g_ksd.ksd09 = tm.qty
       LET g_ksd.ksd09 = s_digqty(g_ksd.ksd09,g_ksd.ksd08)   #FUN-910088--add--
    END IF   #MOD-A30193 add
    LET g_ksd.ksd12 = ''
    
END FUNCTION
 
#str MOD-A30193 add
FUNCTION p622_fqc()
   DEFINE l_sql       STRING,
          l_qcf       RECORD  LIKE qcf_file.*,
          l_tmp_qcqty LIKE sfv_file.sfv09
   DEFINE l_ksc03     LIKE ksc_file.ksc03  #FUN-D10094
   DEFINE l_ksc04     LIKE ksc_file.ksc04  #FUN-D10094

   LET l_sql = "SELECT * FROM qcf_file ",
               " WHERE qcf02 = '",tm.part,"'",
               "   AND qcf09 <> '2'",
               "   AND qcf14 = 'Y'"
   PREPARE fqc_p1 FROM l_sql
   DECLARE fqc_cs1 CURSOR FOR fqc_p1
   FOREACH fqc_cs1 INTO l_qcf.*
      LET g_ksd.ksd03 = g_ksd.ksd03+1
      LET g_ksd.ksd04 = l_qcf.qcf021
      LET g_ksd.ksd11 = l_qcf.qcf02
      LET g_ksd.ksd17 = l_qcf.qcf01
      LET g_ksd.ksd30 = l_qcf.qcf36
      LET g_ksd.ksd31 = l_qcf.qcf37
      LET g_ksd.ksd32 = l_qcf.qcf38
      LET g_ksd.ksd33 = l_qcf.qcf39
      LET g_ksd.ksd34 = l_qcf.qcf40
      LET g_ksd.ksd35 = l_qcf.qcf41
      LET g_ksd.ksd930=s_costcenter(g_ksc04)

      SELECT ima25 INTO g_ksd.ksd08 FROM ima_file WHERE ima01=g_ksd.ksd04
      LET g_ksd.ksd09 = s_digqty(g_ksd.ksd09,g_ksd.ksd08)    #FUN-910088--add--      

      #工單已入庫量
      SELECT SUM(ksd09) INTO l_tmp_qcqty FROM ksd_file,ksc_file
       WHERE ksd11 = g_ksd.ksd11
         AND ksd17 = g_ksd.ksd17
         AND ksd01 = ksc01
         AND ksc00 = '1'
         AND (ksd01!= g_ksd.ksd01 OR
             (ksd01 = g_ksd.ksd01 AND ksd03 != g_ksd.ksd03))
         AND kscconf <> 'X'
      IF cl_null(l_tmp_qcqty) THEN LET l_tmp_qcqty = 0 END IF
      LET g_ksd.ksd09 = l_qcf.qcf091 - l_tmp_qcqty
      #FUN-BC0104--str---add
      IF cl_null(g_ksd.ksdplant) THEN LET g_ksd.ksdplant = g_plant END IF
      IF cl_null(g_ksd.ksdlegal) THEN LET g_ksd.ksdlegal = g_legal END IF
      #FUN-BC0104---end---add

      #FUN-D10094--add--str--
      IF g_aza.aza115 = 'Y' THEN 
         SELECT ksc03,ksc04 INTO l_ksc03,l_ksc04 FROM ksc_file WHERE ksc01=g_ksd.ksd01 AND ROWNUM=1
         LET g_ksd.ksd36=s_reason_code(g_ksd.ksd01,g_ksd.ksd11,'',g_ksd.ksd04,g_ksd.ksd05,l_ksc03,l_ksc04) 
      END IF
      #FUN-D10094--add--end--
      INSERT INTO ksd_file VALUES(g_ksd.*)
      IF SQLCA.SQLCODE THEN
         ERROR 'ALC1: Insert Failed because of ',SQLCA.SQLCODE
      END IF
   END FOREACH
END FUNCTION
#end MOD-A30193 add


###展BOM
 
 FUNCTION p622_bom()
   DEFINE l_ima562     LIKE ima_file.ima562,
          l_ima910     LIKE ima_file.ima910, 
          l_ima55      LIKE ima_file.ima55, 
          l_ima86      LIKE ima_file.ima86, 
          l_ima86_fac  LIKE ima_file.ima86_fac
   DEFINE l_ksd04      LIKE ksd_file.ksd04 
   DEFINE #l_sql        LIKE type_file.chr1000 
          l_sql        STRING       #NO.FUN-910082   
    LET l_sql = " SELECT sfb05 FROM sfb_file ", 
                "  WHERE sfb01 = '",tm.part,"' "
    PREPARE bom_p1 FROM l_sql
    DECLARE bom_cs1 CURSOR FOR bom_p1
    FOREACH bom_cs1 INTO l_ksd04 
       SELECT ima562,ima55,ima86,ima86_fac,ima910 INTO  
            l_ima562,l_ima55,l_ima86,l_ima86_fac,l_ima910  
       FROM ima_file
      WHERE ima01=l_ksd04 AND imaacti='Y'
     IF SQLCA.sqlcode THEN RETURN END IF
     IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
     IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF 
     CALL p622_bom2(0,l_ksd04,l_ima910,tm.qty,1)
          IF g_ccc=0 THEN
             LET g_errno='asf-014'
          END IF    #有BOM但無有效者
    
     MESSAGE ""
     RETURN 
    END FOREACH
END FUNCTION
 
FUNCTION p622_bom2(p_level,p_key,p_key2,p_total,p_QPA) 
#No.FUN-A70034  --Begin
DEFINE l_total_1   LIKE sfa_file.sfa06
DEFINE l_QPA_1     LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
 
DEFINE
    p_level      LIKE type_file.num5,         #level code    
    p_total      LIKE sfb_file.sfb08,         
#   p_QPA        LIKE ima_file.ima26, 	      
#   l_QPA        LIKE ima_file.ima26,         
    p_QPA        LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044 	      
    l_QPA        LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044        
    l_total      LIKE sfb_file.sfb08,         #原發數量      
    l_total2     LIKE sfb_file.sfb08,         #應發數量      
    p_key        LIKE bma_file.bma01,         #assembly part number
    p_key2       LIKE bma_file.bma06,         
    l_ac,l_i,l_x LIKE type_file.num5,         #
    arrno        LIKE type_file.num5,         #BUFFER SIZE 
    b_seq,l_double LIKE type_file.num10,      #restart sequence (line number) 	
    l_ima45      LIKE ima_file.ima45,
    l_ima46      LIKE ima_file.ima46,
    sr DYNAMIC ARRAY OF RECORD  #array for storage
        bmb02 LIKE bmb_file.bmb02, #項次
        bmb03 LIKE bmb_file.bmb03, #料號                     
        bmb16 LIKE bmb_file.bmb16, #取替代碼
        bmb06 LIKE bmb_file.bmb06, #QPA
        bmb08 LIKE bmb_file.bmb08, #損耗率
        bmb10 LIKE bmb_file.bmb10, #發料單位
        bmb10_fac LIKE bmb_file.bmb10_fac, #換算率
        bmb25 LIKE bmb_file.bmb25,
        bmb26 LIKE bmb_file.bmb26,
        ima08 LIKE ima_file.ima08, #來源碼
        ima02 LIKE ima_file.ima02, #品名規格
        ima05 LIKE ima_file.ima05, #版本  
        ima44 LIKE ima_file.ima44, #採購單位
        ima25 LIKE ima_file.ima25, #庫存單位 
        ima44_fac LIKE ima_file.ima44_fac,  #採購單位/庫存單位 換算率
        ima49  LIKE ima_file.ima49,  #到廠前置期
        ima491 LIKE ima_file.ima491, #入庫前置期
        bma01 LIKE bma_file.bma01, #項次
        #No.FUN-A70034  --Begin
        bmb081 LIKE bmb_file.bmb081,
        bmb082 LIKE bmb_file.bmb082 
        #No.FUN-A70034  --End  
    END RECORD,
    l_ima08     LIKE ima_file.ima08,        #source code
#   l_ima26     LIKE ima_file.ima26,        #QOH  #NO.FUN-A20044
    l_chr       LIKE type_file.chr1,        
    l_ActualQPA LIKE bmb_file.bmb06,        
    l_cnt,l_c   LIKE type_file.num5,       
    l_cmd       LIKE type_file.chr1000,     
    l_status    LIKE type_file.num5,   	    
    l_factor    LIKE ima_file.ima31_fac     
DEFINE  l_ima908     LIKE ima_file.ima908   
DEFINE  l_ima44      LIKE ima_file.ima44
DEFINE  l_ima906     LIKE ima_file.ima906
DEFINE  l_ima907     LIKE ima_file.ima907
DEFINE  l_ksd07        LIKE ksd_file.ksd07
DEFINE  l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
#FUN-BC0104-add-str--
DEFINE l_ksd03  LIKE ksd_file.ksd03,
       l_ksd17  LIKE ksd_file.ksd17,
       l_ksd47  LIKE ksd_file.ksd47,
       l_flagg  LIKE type_file.chr1,
       l_flag   LIKE type_file.chr1
#FUN-BC0104-add-end--
DEFINE l_ksc03  LIKE ksc_file.ksc03  #FUN-D10094
DEFINE l_ksc04  LIKE ksc_file.ksc04  #FUN-D10094
 
    LET p_level = p_level + 1
    LET arrno = 500
        LET l_cmd=" SELECT 0,bmb03,bmb16,bmb06/bmb07,bmb08,bmb10,bmb10_fac,bmb25,bmb26,",
                  "        ima08,ima02,ima05,ima44,ima25,ima44_fac,ima49,ima491,bma01,",
                  "        bmb081,bmb082 ",        #No.FUN-A70034
                  "   FROM bmb_file,OUTER ima_file,OUTER bma_file ",
                  "  WHERE bmb01='",p_key,"' AND bmb02 > ?",
                  "    AND bmb29='",p_key2,"'", 
                  "    AND bmb03 = bma_file.bma01",
                  "    AND bmb29 = bma_file.bma06",      
                  "    AND bmb03 = ima_file.ima01",
                  #No.TQC-990069  --Begin
                  "   AND (bmb04 <='", g_today,"'"," OR bmb04 IS NULL )",            
                  "   AND (bmb05 >  '",g_today,"'"," OR bmb05 IS NULL )",
                  #No.TQC-990069  --End  
                  " ORDER BY 1"
        
        PREPARE bom_p FROM l_cmd
        DECLARE bom_cs CURSOR FOR bom_p
        IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN  END IF
 
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH bom_cs USING b_seq INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
            #FUN-8B0035--BEGIN--
            LET l_ima910[l_ac]=''
            SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
            IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF 
            #FUN-8B0035--END-- 
            LET l_ac = l_ac + 1    #check limitation
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
 
        #insert into allocation file
        FOR l_i = 1 TO l_x
 
            #No.FUN-A70034  --Begin
            ##inflate yield
            #IF g_sma.sma71='N' THEN LET sr[l_i].bmb08=0 END IF
            ##Actual QPA
            #LET l_ActualQPA=(sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
            #LET l_QPA=sr[l_i].bmb06 * p_QPA
            #LET l_total=sr[l_i].bmb06*p_total*((100+sr[l_i].bmb08))/100  #量

            CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,sr[l_i].bmb06,p_QPA)
                 RETURNING l_total_1,l_QPA,l_ActualQPA
            LET l_QPA_1 = l_ActualQPA
            LET l_total = l_total_1
            #No.FUN-A70034  --End  
   
           IF sr[l_i].ima08='X' THEN       ###為 X PART 由參數決定
              IF sr[l_i].bma01 IS NOT NULL THEN 
                   #CALL p622_bom2(p_level,sr[l_i].bmb03,' ',          #FUN-8B0035
                    #No.FUN-A70034  --Begin
                    #CALL p622_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],#FUN-8B0035     
                    #    p_total*sr[l_i].bmb06,l_ActualQPA)
                    CALL p622_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i],#FUN-8B0035     
                         l_total_1,l_QPA_1)
                    #No.FUN-A70034  --End  
                      CONTINUE FOR  #MOD-910084 
                END IF
            END IF
 
 
            IF sr[l_i].ima08='M' OR 
               sr[l_i].ima08='S' THEN     ###為 M PART 由人決定
               IF tm.a='Y' THEN
                  IF sr[l_i].bma01 IS NOT NULL THEN 
                    #CALL p622_bom2(p_level,sr[l_i].bmb03,' ',           #FUN-8B0035
                     #No.FUN-A70034  --Begin
                     #CALL p622_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i], #FUN-8B0035   
                     #     p_total*sr[l_i].bmb06,l_ActualQPA)
                     CALL p622_bom2(p_level,sr[l_i].bmb03,l_ima910[l_i], #FUN-8B0035   
                          l_total_1,l_QPA_1)
                     #No.FUN-A70034  --End  
                      CONTINUE FOR  #MOD-910084 
                  ELSE
                      CONTINUE FOR
                  END IF
               END IF
            END IF
            
              LET g_ccc=g_ccc+1
              LET g_ksd.ksd11=tm.part
              LET g_ksd.ksd04=sr[l_i].bmb03
              LET g_ksd.ksd08=sr[l_i].ima25
              IF  NOT cl_null(sr[l_i].bmb25) THEN 
                 LET g_ksd.ksd05=sr[l_i].bmb25
              ELSE 
              	 LET g_ksd.ksd05=tm.store
              END IF
              IF NOT cl_null(sr[l_i].bmb26) THEN
                 LET g_ksd.ksd06=sr[l_i].bmb26
              ELSE 
              	 LET g_ksd.ksd06=tm.location
              END IF              
               
               CALL s_umfchk(g_ksd.ksd04,sr[l_i].bmb10,sr[l_i].ima44)
                    RETURNING l_status,l_factor
               IF l_status THEN
                  CALL cl_err(g_ksd.ksd04,'mfg1206',1)
                  CONTINUE FOR
               END IF
               LET g_ksd.ksd09=l_total * l_factor
               LET g_ksd.ksd09 = s_digqty(g_ksd.ksd09,g_ksd.ksd08)   #FUN-910088--add-- 
              
             ### 寫進 ksd_file
               SELECT COUNT(*) INTO l_cnt FROM ksd_file
                WHERE ksd01=g_ksd.ksd01 AND ksd04=g_ksd.ksd04
               IF l_cnt > 0 THEN   #Duplicate   數量相加
                  SELECT ima25,ima44,ima906,ima907 
                    INTO g_ima25,g_ima44,g_ima906,g_ima907
                    FROM ima_file WHERE ima01=g_ksd.ksd04
                  IF SQLCA.sqlcode =100 THEN                                                  
                     IF g_ksd.ksd04 MATCHES 'MISC*' THEN                                
                        SELECT ima25,ima44,ima906,ima907 
                          INTO g_ima25,g_ima44,g_ima906,g_ima907                               
                          FROM ima_file WHERE ima01='MISC'                                    
                     END IF                                                                   
                  END IF                                                                      
                  IF cl_null(g_ima44) THEN LET g_ima44 = g_ima25 END IF
                  IF g_ima906 = '3' THEN
                     LET g_factor = 1
                     CALL s_umfchk(g_ksd.ksd04,g_ksd.ksd30,g_ksd.ksd33)
                          RETURNING g_cnt,g_factor
                     IF g_cnt = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET g_ksd.ksd35 = g_ksd.ksd09*g_factor
                     LET g_ksd.ksd35 = s_digqty(g_ksd.ksd35,g_ksd.ksd33)   #FUN-910088--add--
                  END IF
                 #判斷若使用多單位時，單位一的數量default建議量
                 #否則單位一數量不default任何值
                  IF g_sma.sma115 = 'Y' THEN 
                     LET g_ksd.ksd32 = g_ksd.ksd09
                     LET g_ksd.ksd32 =s_digqty(g_ksd.ksd32,g_ksd.ksd30)   #FUN-910088--add--
                  ELSE 
                     LET g_ksd.ksd32 = 0
                  END IF
                 
                  UPDATE ksd_file SET ksd09=ksd09+g_ksd.ksd09,
                                      ksd32=ksd32+g_ksd.ksd32,     
                                      ksd35=ksd35+g_ksd.ksd35 
                   WHERE ksd01=g_ksd.ksd01 AND ksd04=g_ksd.ksd04
                  #FUN-BC0104-add-str--
                  DECLARE upd_ksd CURSOR FOR
                   SELECT ksd03 FROM ksd_file WHERE ksd01 = g_ksd.ksd01
                  FOREACH upd_ksd INTO l_ksd03
                     CALL s_iqctype_ksd(g_ksd.ksd01,l_ksd03) RETURNING l_ksd17,l_ksd47,l_flagg
                     IF l_flagg = 'Y' THEN
                        LET l_flag = s_iqctype_upd_qco20(l_ksd17,'','',l_ksd47,'3') 
                     END IF
                  END FOREACH
                  #FUN-BC0104-add-end--                  
               ELSE
                  LET g_ksd.ksd03=g_ksd.ksd03+1
                  IF g_sma.sma115 = 'Y' THEN
                     SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
                       FROM ima_file 
                      WHERE ima01=g_ksd.ksd04
                     LET g_ksd.ksd30=g_ksd.ksd08
                     LET l_factor = 1
                     CALL s_umfchk(g_ksd.ksd04,g_ksd.ksd30,l_ima44)
                          RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN
                        LET l_factor = 1
                     END IF
                     LET g_ksd.ksd31=l_factor
                     LET g_ksd.ksd32=g_ksd.ksd09
                     LET g_ksd.ksd33=l_ima907
                     LET l_factor = 1
                     CALL s_umfchk(g_ksd.ksd04,g_ksd.ksd33,l_ima44)
                          RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN
                        LET l_factor = 1
                     END IF
                     LET g_ksd.ksd34=l_factor
                     LET g_ksd.ksd35=0
                     IF l_ima906 = '3' THEN
                        LET l_factor = 1
                        CALL s_umfchk(g_ksd.ksd04,g_ksd.ksd30,g_ksd.ksd35)
                             RETURNING l_cnt,l_factor
                        IF l_cnt = 1 THEN
                           LET l_factor = 1
                        END IF
                        LET g_ksd.ksd35=g_ksd.ksd32*l_factor
                        LET g_ksd.ksd35 = s_digqty(g_ksd.ksd35,g_ksd.ksd33)   #FUN-910088--add--
                     END IF
                  END IF
                  LET g_ksd.ksd930=s_costcenter(g_ksc04)
                  SELECT img04 INTO l_ksd07 FROM img_file 
                   WHERE img01 = g_ksd.ksd04 AND img02 = g_ksd.ksd05
                     AND img03 = g_ksd.ksd06
                  IF NOT cl_null(l_ksd07) THEN
                     LET g_ksd.ksd07 = l_ksd07
                  END IF
 
                  LET g_ksd.ksdplant = g_plant #FUN-980008 add
                  LET g_ksd.ksdlegal = g_legal #FUN-980008 add
 
                  #FUN-D10094--add--str--
                  IF g_aza.aza115 = 'Y' THEN
                     SELECT ksc03,ksc04 INTO l_ksc03,l_ksc04 FROM ksc_file WHERE ksc01=g_ksd.ksd01 AND ROWNUM=1
                     LET g_ksd.ksd36=s_reason_code(g_ksd.ksd01,g_ksd.ksd11,'',g_ksd.ksd04,g_ksd.ksd05,l_ksc03,l_ksc04)
                  END IF
                  #FUN-D10094--add--end--

                  INSERT INTO ksd_file VALUES(g_ksd.*)
                  IF SQLCA.SQLCODE THEN 
                     ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
                  END IF
               END IF
        END FOR
        IF l_x < arrno OR l_ac=1 THEN #nothing left
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
    # 避免 'X' PART 重複計算
    IF p_level >1 THEN
       RETURN
    END IF
 
 
END FUNCTION
 
#--->拆件式工單相關資料顯示於劃面
FUNCTION  p622_sfb01()
   DEFINE
          l_ksd09   LIKE ksd_file.ksd09,
          l_cnt     LIKE type_file.num5,    
          l_d2      LIKE type_file.chr20,   
          l_d4      LIKE type_file.chr20,   
          l_no      LIKE oay_file.oayslip,  
          l_status  LIKE type_file.num10,   
          p_ac      LIKE type_file.num5,    
          p_sl      LIKE type_file.num5     
   DEFINE l_slip    LIKE smy_file.smyslip  #No.FUN-950021
 
    INITIALIZE g_sfb.* TO NULL
    LET g_min_set = 0
    SELECT sfb_file.*
    INTO g_sfb.*
    FROM  sfb_file
    WHERE sfb01=tm.part
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF
    LET g_errno=' '
 
    #No.FUN-950021  --Begin
    LET l_slip = s_get_doc_no(g_sfb.sfb01)
    
    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt FROM smy_file
     WHERE smy69 = l_slip          #No.FUN-950021
    IF l_cnt > 0 THEN
       LET g_errno = 'asf-873'     #組合拆解對應的工單,不得使用!
       RETURN
    END IF
    #No.FUN-950021  --End  
 
    CASE
       WHEN g_sfb.sfbacti='N' LET g_errno = '9028'
       WHEN g_sfb.sfb04 = '8' # 不得為已結案
            LET g_errno = 'mfg3430'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       WHEN g_sfb.sfb02 != 11  # 僅允許輸入拆件式工單
            LET g_errno = 'asf-813'
       WHEN g_sfb.sfb04 < '4'
            IF g_sfb.sfb39 !=2 THEN    #MOD-C60047 add            
               LET g_errno='asf-570'
            END IF                     #MOD-C60047 add
     
       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
END FUNCTION
#No.FUN-880011

#str MOD-A30193 add
FUNCTION p622_set_entry()
   CALL cl_set_comp_entry("qty,a",TRUE)
END FUNCTION

FUNCTION p622_set_no_entry()
   IF g_sfb.sfb94='Y' THEN
      CALL cl_set_comp_entry("qty,a",FALSE)
   END IF
END FUNCTION
#end MOD-A30193 add

