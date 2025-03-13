# Prog. Version..: '5.30.06-13.03.15(00005)'     #
#
# Program name...: s_icdfun.4gl
# Descriptions...: icd行業使用的函式庫集合
# Memo...........: 此函式庫僅供icd行業使用,在其他行業運用時會有問題
# Date & Author..: 08/01/23 by kim (FUN-810038)
# Modify.........: No.FUN-850069 08/05/14 By alex 調整說明
# Modify.........: No.FUN-980063 09/11/04 By jan 新增傳入參數
# Modify.........: No.FUN-B30192 11/05/05 By shenyang 新增函数
# Modify.........: No.FUN-B30187 11/07/07 By jason 新增母批預設值函数
# Modify.........: No.FUN-BA0051 11/10/11 By jason 新增是否使用刻號/BIN函數s_icdbin,s_icdbin_multi 
# Modify.........: No.FUN-BC0109 12/02/07 By jason 新增取得date code值之函式
# Modify.........: No.MOD-C30547 12/03/14 By bart 抓取母批直接抓idc10就好,不需做任何判斷
# Modify.........: No.MOD-D30027 13/03/05 By bart ICD一般料不自動產生採購單與發料單

DATABASE ds #FUN-850069
 
GLOBALS "../../config/top.global"
 
#ICD begin
#FUN-810038................begin 
#新增料號時一併產生 icb_file 的資料
FUNCTION s_icd_ins_icb(p_ima01,p_icc01)  #FUN-980063 add p_icc01
   DEFINE p_ima01    LIKE ima_file.ima01
   DEFINE p_icc01    LIKE icc_file.icc01 #FUN-980063
   DEFINE l_imaicd01 LIKE imaicd_file.imaicd01
   DEFINE l_imaicd05 LIKE imaicd_file.imaicd05
   DEFINE l_imaicd10 LIKE imaicd_file.imaicd10
   DEFINE l_icb RECORD LIKE icb_file.*
   DEFINE l_icc RECORD LIKE icc_file.*
   DEFINE l_cnt LIKE type_file.num5
   
   SELECT imaicd01,imaicd05,imaicd10
     INTO l_imaicd01,l_imaicd05,l_imaicd10
     FROM imaicd_file
    WHERE imaicd00=p_ima01
   IF (cl_null(l_imaicd01)) OR
     #(cl_null(l_imaicd10)) OR   #FUN-980063
      (cl_null(p_icc01)) OR      #FUN-980063
      (l_imaicd05 MATCHES '[6]') THEN
      RETURN 
   END IF
   LET l_cnt=0
  #SELECT COUNT(*) INTO l_cnt FROM icb_file WHERE icb01=l_imaicd10  #FUN-980063
   SELECT COUNT(*) INTO l_cnt FROM icb_file WHERE icb01=p_ima01     #FUN-980063
   IF l_cnt>0 THEN RETURN END IF
 
  #SELECT * INTO l_icc.* FROM icc_file WHERE icc01=l_imaicd10  #FUN-980063
   SELECT * INTO l_icc.* FROM icc_file WHERE icc01=p_icc01     #FUN-980063
   INITIALIZE l_icb.* TO NULL
   LET l_icb.icb01   = p_ima01         #主件料件編號                   
   LET l_icb.icb02   = l_icc.icc02     #MASK GROUP/光罩群組            
   LET l_icb.icb03   = l_icc.icc03     #PRODUCT LINE                   
   LET l_icb.icb04   = l_icc.icc04     #CHIP SIZE(mm)WAFER             
   LET l_icb.icb05   = l_icc.icc05     #GROSS DIE(ea)WAFER    #FUN-B30192
 # LET l_icb.imaicd14= l_icc.icc05     #FUN-B30192         
   LET l_icb.icb06   = l_icc.icc06     #STATUS for WAFER               
   LET l_icb.icb07   = l_icc.icc07     #PURPOSE for WAFER              
   LET l_icb.icb08   = l_icc.icc08     #vender                         
   LET l_icb.icb09   = l_icc.icc09     #PROCESS TYPE for WAFER         
   LET l_icb.icb10   = l_icc.icc10     #REASON FOR VERSION CHANGE WAFER
   LET l_icb.icb11   = l_icc.icc11     #MASK VENDOR for WAFER          
   LET l_icb.icb12   = l_icc.icc12     #WAFER SIZE(inch) for WAFER     
   LET l_icb.icb13   = l_icc.icc13     #SCRIBE-LINE WIDTH(um)WAFER     
   LET l_icb.icb14   = l_icc.icc14     #TECHNOLOGY for WAFER           
   LET l_icb.icb15   = l_icc.icc15     #W/F THICKNESS(MIL) for WAFER   
   LET l_icb.icb16   = l_icc.icc16     #STD YLD(%)                     
   LET l_icb.icb17   = l_icc.icc17     #CLAIMED YIELD(%)               
   LET l_icb.icb18   = l_icc.icc18     #RETURN YIELD(%)                
   LET l_icb.icb19   = l_icc.icc19     #FCST YIELD(%)                  
   LET l_icb.icb20   = l_icc.icc20     #ACT YIELD(%)                   
   LET l_icb.icb21   = l_icc.icc21     #CP PGM NAME CP                 
   LET l_icb.icb22   = l_icc.icc22     #CP PGM VER CP                  
   LET l_icb.icb23   = l_icc.icc23     #RELEASED DATE CP               
   LET l_icb.icb24   = l_icc.icc24     #ALARM BIN CP                   
   LET l_icb.icb25   = l_icc.icc25     #ECN FILE CP                    
   LET l_icb.icb26   = l_icc.icc26     #HOLD YIED (%) CP               
   LET l_icb.icb27   = l_icc.icc27     #供應商Site                     
   LET l_icb.icb28   = l_icc.icc28     #NO USE                         
   LET l_icb.icb29   = l_icc.icc29     #NO USE                         
   LET l_icb.icb30   = l_icc.icc30     #轉Code否                       
   LET l_icb.icb31   = l_icc.icc31     #No User                        
   LET l_icb.icb32   = l_icc.icc32     #DURATION                       
   LET l_icb.icb33   = l_icc.icc33     #VALID DATE(RP)                 
   LET l_icb.icb34   = l_icc.icc34     #VALID DATE(HOLD)               
   LET l_icb.icb35   = l_icc.icc35     #VALID DATE(CLOSE)              
   LET l_icb.icb36   = l_icc.icc36     #MASK No                        
   LET l_icb.icb37   = l_icc.icc37     #MASK Ver                       
   LET l_icb.icb38   = l_icc.icc38     #LOGO                           
   LET l_icb.icb39   = l_icc.icc39     #New Code否                     
   LET l_icb.icb40   = l_icc.icc40     #NO USE                         
   LET l_icb.icb41   = l_icc.icc41     #NO USE                         
   LET l_icb.icb42   = l_icc.icc42     #NO USE                         
   LET l_icb.icb43   = l_icc.icc43     #NO USE                         
   LET l_icb.icb44   = l_icc.icc44     #NO USE                         
   LET l_icb.icb45   = l_icc.icc45     #NO USE                         
   LET l_icb.icb45   = l_icc.icc45     #NO USE                         
   LET l_icb.icb46   = l_icc.icc46     #NO USE FT                      
   LET l_icb.icb47   = l_icc.icc47     #FTNO USE FT                    
   LET l_icb.icb48   = l_icc.icc48     #NO USE                         
   LET l_icb.icb49   = l_icc.icc49     #NO USE                         
   LET l_icb.icb50   = l_icc.icc50     #NO USE                         
   LET l_icb.icb51   = l_icc.icc51     #NO USE                         
   LET l_icb.icb52   = l_icc.icc52     #NO USE                         
   LET l_icb.icb53   = l_icc.icc53     #NO USE                         
   LET l_icb.icb54   = l_icc.icc54     #NO USE                         
   LET l_icb.icb55   = l_icc.icc55     #NO USE                         
   LET l_icb.icb56   = l_icc.icc56     #NO USE                         
   LET l_icb.icb57   = l_icc.icc57     #NO USE                         
   LET l_icb.icb58   = l_icc.icc58     #No Use FT                      
   LET l_icb.icb59   = l_icc.icc59     #NO USE          
   LET l_icb.icb60   = l_icc.icc60     #NO USE                         
   LET l_icb.icb61   = l_icc.icc61     #NO USE                         
   LET l_icb.icb62   = l_icc.icc62     #NO USE                         
   LET l_icb.icb63   = l_icc.icc63     #NO USE                         
   LET l_icb.icb64   = l_icc.icc64     #NO USE                         
   LET l_icb.icb65   = l_icc.icc65     #NO USE                         
   LET l_icb.icb66   = l_icc.icc66     #NO USE                         
   LET l_icb.icb67   = l_icc.icc67     #NO USE                         
   LET l_icb.icb68   = l_icc.icc68     #NO USE                         
   LET l_icb.icb69   = l_icc.icc69     #NO USE                         
   LET l_icb.icb70   = l_icc.icc70     #Leadframe for ASS              
   LET l_icb.icb71   = l_icc.icc71     #Epoxy for ASS                  
   LET l_icb.icb72   = l_icc.icc72     #Gold Wire for ASS              
   LET l_icb.icb73   = l_icc.icc73     #Compound for ASS               
   LET l_icb.icb74   = l_icc.icc74     #Soldering for ASS              
   LET l_icb.icb75   = l_icc.icc75     #EQA Test Program for ASS       
   LET l_icb.icb76   = l_icc.icc76     #Outline Dimension              
   LET l_icb.icb77   = l_icc.icc77     #NO USE                         
   LET l_icb.icb78   = l_icc.icc78     #HOLDING YIELD (%) for ASS      
  #LET l_icb.icb79   = l_icc.icc79     #ICD GROUP        #FUN-980063              
   LET l_icb.icb79   = p_icc01         #ICD GROUP        #FUN-980063              
   LET l_icb.icbuser = g_user
   LET l_icb.icbgrup = g_grup
  #LET l_icb.icbmodu =
   LET l_icb.icbdate = g_today
   LET l_icb.icbacti = 'Y'
   
   INSERT INTO icb_file values (l_icb.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","icb_file",p_ima01,"",SQLCA.sqlcode,"","",1)
   END IF
END FUNCTION
#FUN-810038................end
#FUN-B30192--add--begin
FUNCTION s_icdfun_imaicd14(p_ima01) 
  DEFINE p_ima01       LIKE ima_file.ima01
  DEFINE l_imaicd14    LIKE imaicd_file.imaicd14
  DEFINE l_imaicd16    LIKE imaicd_file.imaicd16
  DEFINE l_sql         STRING
  DEFINE l_bmb01       LIKE bmb_file.bmb01
  DEFINE l_bmb03       LIKE bmb_file.bmb03

  IF p_ima01 IS NULL THEN RETURN 0 END IF
  #1.先抓本顆料的 gross die
  SELECT imaicd14,imaicd16 INTO l_imaicd14,l_imaicd16 FROM ima_file  
    LEFT OUTER JOIN imaicd_file ON (imaicd00=ima01)
     WHERE ima01 = p_ima01   
  #2.抓不到,在抓WAFER型號的 gross die
  IF (l_imaicd14 IS NULL OR l_imaicd14 = 0) AND (NOT cl_null(l_imaicd16)) THEN
     SELECT imaicd14 INTO l_imaicd14 FROM ima_file  
       LEFT OUTER JOIN imaicd_file ON (imaicd00=ima01)
        WHERE ima01 = l_imaicd16   
  END IF
  #3.抓不到,再由BOM推至尾階抓第一筆WAFER的 gross die
  IF (l_imaicd14 IS NULL OR l_imaicd14 = 0) THEN
     LET l_bmb01=p_ima01
     LET l_sql = "SELECT bmb03,imaicd14 FROM ima_file,bmb_file ",
                 "  LEFT OUTER JOIN imaicd_file ON (imaicd00=bmb03) ",
                 " WHERE ima910=bmb29 AND ima01=bmb01 AND ima01= ?  ",
                 "   AND (bmb04 <='", g_today, "' OR bmb04 IS NULL) ",
                 "   AND (bmb05 > '", g_today, "' OR bmb05 IS NULL) "
     DECLARE s_icdfun_imaicd14_c CURSOR FROM l_sql
     WHILE l_imaicd14 > 0
        LET l_bmb03=NULL
        OPEN s_icdfun_imaicd14_c USING l_bmb01
        FETCH s_icdfun_imaicd14_c INTO l_bmb03,l_imaicd14
        CLOSE s_icdfun_imaicd14_c
        IF l_bmb03 IS NULL THEN
           EXIT WHILE
        END IF
        IF l_imaicd14 IS NULL THEN LET l_imaicd14 = 0 END IF
     END WHILE
  END IF
  RETURN l_imaicd14
END FUNCTION
#FUN-B30192--add--end
#FUN-B30187 --START--
#母批預設值
FUNCTION s_icdfun_def_slot(p_idc01,p_idc02,p_idc03,p_idc04)
   DEFINE l_idc10    LIKE idc_file.idc10,
          l_idc11    LIKE idc_file.idc11
   #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   DEFINE p_idc01    LIKE idc_file.idc01
   DEFINE p_idc02    LIKE idc_file.idc02
   DEFINE p_idc03    LIKE idc_file.idc03
   DEFINE p_idc04    LIKE idc_file.idc04
   DEFINE l_sql STRING
   #FUN-BA0051 --STATR mark--
   #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file     
   #                WHERE imaicd00 = p_idc01
   #IF NOT cl_null(l_imaicd08) AND l_imaicd08 <> 'Y' THEN
   #FUN-BA0051 --END mark--
   #IF s_icdbin(p_idc01) THEN   #FUN-BA0051   #MOD-C30547 mark  
      LET l_sql = "SELECT idc10,idc11 FROM idc_file",
                   " WHERE idc01 = '", p_idc01, "' ",
                     " AND idc02 = '", p_idc02, "' ",
                     " AND idc03 = '", p_idc03, "' ",
                     " AND idc04 = '", p_idc04, "' "                     
      PREPARE icddef_slot_p FROM l_sql
      DECLARE icddef_slot_cs CURSOR FOR icddef_slot_p
      OPEN icddef_slot_cs
      FETCH icddef_slot_cs INTO l_idc10,l_idc11      
      CLOSE icddef_slot_cs
      RETURN TRUE, l_idc10,l_idc11
   #ELSE                                      #MOD-C30547 mark
   #   RETURN FALSE, '', ''                   #MOD-C30547 mark
   #END IF                                    #MOD-C30547 mark
END FUNCTION
#FUN-B30187 --END--
#FUN-BA0051 --START--
FUNCTION s_icdbin(p_imaicd00)
DEFINE p_imaicd00 LIKE imaicd_file.imaicd00
DEFINE l_imaicd08 LIKE imaicd_file.imaicd08
DEFINE l_imaicd09 LIKE imaicd_file.imaicd09

   LET l_imaicd08 = 'N'
   LET l_imaicd09 = 'N'
                     
   SELECT imaicd08,imaicd09 INTO l_imaicd08,l_imaicd09 
    FROM imaicd_file WHERE imaicd00 = p_imaicd00
   IF SQLCA.sqlcode THEN
      #CALL cl_err('SEL imaicd',SQLCA.sqlcode,0) #MOD-D30027
      RETURN FALSE 
   END IF
   
   IF l_imaicd08 = 'N' AND l_imaicd09 = 'N' THEN
      RETURN FALSE 
   END IF  
   
RETURN TRUE                 
END FUNCTION

FUNCTION s_icdbin_multi(p_imaicd00,p_plant_new)
DEFINE p_imaicd00  LIKE imaicd_file.imaicd00
DEFINE p_plant_new LIKE type_file.chr20
DEFINE l_imaicd08  LIKE imaicd_file.imaicd08
DEFINE l_imaicd09  LIKE imaicd_file.imaicd09
DEFINE l_sql       STRING
 
   LET l_imaicd08 = 'N'
   LET l_imaicd09 = 'N'

   LET l_sql = "SELECT imaicd08,imaicd09 FROM ",cl_get_target_table(p_plant_new,'imaicd_file'),
                  " WHERE imaicd00 = '",p_imaicd00,"' "

   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
   CALL cl_parse_qry_sql(l_sql,p_plant_new) RETURNING l_sql
   PREPARE icdbin_p1 FROM l_sql
   EXECUTE icdbin_p1 INTO l_imaicd08,l_imaicd09                             
   IF SQLCA.sqlcode THEN
      CALL cl_err('SEL imaicd',SQLCA.sqlcode,0)
      RETURN FALSE 
   END IF
   
   IF l_imaicd08 = 'N' AND l_imaicd09 = 'N' THEN
      RETURN FALSE 
   END IF  
   
RETURN TRUE                 
END FUNCTION  
#FUN-BA0051 --END--

#FUN-BC0109 --START--
#回傳DATE CODE資料,若多筆時即以","做分隔
FUNCTION s_icdfun_datecode(p_type,p_idb07,p_idb08)
DEFINE l_sql     STRING 
DEFINE l_res     STRING
DEFINE l_res_o   STRING
DEFINE p_type    LIKE type_file.chr1   #出入庫類別 1.入庫 2.出庫
DEFINE p_idb07   LIKE idb_file.idb07
DEFINE p_idb08   LIKE idb_file.idb08
DEFINE l_idb15   LIKE idb_file.idb15 
DEFINE l_lenth   LIKE type_file.num10

   CASE p_type
      WHEN "1"   #出庫
         LET l_sql = "SELECT DISTINCT idb15 FROM idb_file",
                     " WHERE idb07 = '", p_idb07, "'",
                     " AND idb08 = ", p_idb08
      WHEN "2"   #入庫
         LET l_sql = "SELECT DISTINCT ida16 FROM ida_file",
                     " WHERE ida07 = '", p_idb07, "'",
                     " AND ida08 = ", p_idb08                     
      OTHERWISE
         RETURN l_res
   END CASE
      
   PREPARE s_icdfun_dc_p1 FROM l_sql   
   DECLARE s_icdfun_dc_c1 CURSOR FOR s_icdfun_dc_p1
   FOREACH s_icdfun_dc_c1 INTO l_idb15
      IF NOT cl_null(l_idb15) THEN
         LET l_res = l_res, ",", l_idb15 #串接datecode
         #最大長度不可超過80
         IF l_res.getlength() > 80 THEN
            LET l_res = l_res_o
            EXIT FOREACH
         ELSE
            LET l_res_o = l_res    
         END IF 
      END IF      
   END FOREACH
   #去除第一個,號   
   LET l_lenth = l_res.getlength() 
   IF l_lenth >= 2 THEN    
      LET l_res=l_res.Substring(2,l_lenth)
   END IF    
   RETURN l_res
END FUNCTION
#FUN-BC0109 --END--
#ICD end
