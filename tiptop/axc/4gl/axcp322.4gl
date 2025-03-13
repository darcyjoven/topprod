# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axcp322.4gl
# Descriptions...: 销货成本分录底稿整批生成作业
# Date & Author..: 10/07/07 By elva #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 分錄底稿根據幣種取位
# Modify.........: No:FUN-BB0038 11/11/18 By elva 成本改善
# Modify.........: No:FUN-C80009 12/08/03 By elva 增加开票单来源
# Modify.........: No:FUN-C90002 12/09/04 By minpp 成本类型给默认值ccz28
# Modify.........: No:FUN-C80094 12/10/16 By xuxz 發出商品
# Modify.........: No.MOD-CB0221 12/11/23 By wujie 账套没控管合法性
# Modify.........: No.MOD-CC0001 12/12/03 By wujie 金额小数位数用ccz26截位
# Modify.........: No.MOD-D40042 13/04/09 By wujie 不产生金额为0的cdj资料
# Modify.........: No:MOD-D50133 13/05/15 By suncx 參數設置存貨科目取自料件分群碼檔時，應該根據ima06去imz39，而不是根據ima12
# Modify.........: No:FUN-D70068 13/07/11 By zhangweib Mark oaz93 = 'N'的邏輯,不納入成本計算不會用到這隻作業了
# Modify.........: No:FUN-D90054 13/09/17 By yangtt cdj10賦值為tlf10*tlf60

DATABASE ds   

GLOBALS "../../config/top.global"

#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE g_cdj               RECORD LIKE cdj_file.* 
DEFINE l_cdj               RECORD LIKE cdj_file.*
DEFINE g_wc                STRING 
DEFINE g_sql               STRING 
DEFINE g_rec_b             LIKE type_file.num5                #單身筆數
DEFINE l_ac                LIKE type_file.num5                #目前處理的ARRAY CNT
DEFINE g_argv1             LIKE type_file.chr1
DEFINE tm                  RECORD 
                           tlfctype    LIKE tlfc_file.tlfctype, #FUN-BB0038
                           yy          LIKE type_file.num5, #FUN-BB0038
                           mm          LIKE type_file.num5, #FUN-BB0038
                           b    LIKE aaa_file.aaa01
                           END RECORD 
#主程式開始
DEFINE g_flag              LIKE type_file.chr1
DEFINE l_flag              LIKE type_file.chr1
DEFINE g_change_lang       LIKE type_file.chr1

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                               
 
    
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_time = TIME   
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
   

 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p322_tm()
         IF cl_sure(18,20) THEN 
            CALL p322_p() 
             IF g_success ='Y' THEN 
                CALL cl_end2(1) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p322_w
                   EXIT WHILE 
                END IF
             ELSE
                CALL cl_end2(2) RETURNING l_flag
                IF l_flag THEN 
                   CONTINUE WHILE 
                ELSE 
                   CLOSE WINDOW p322_w
                   EXIT WHILE 
                END IF

             END IF  
          ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p322_w
      ELSE
         CALL p322_p()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN

FUNCTION p322_tm()
DEFINE p_row,p_col    LIKE type_file.num5  
DEFINE l_cnt          LIKE type_file.num5    #No.MOD-CB0221
 
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW p322_w AT p_row,p_col WITH FORM "axc/42f/axcp323" 
      ATTRIBUTE (STYLE = g_win_style)
    
   CALL cl_ui_init() 
   CALL cl_opmsg('q')

   CLEAR FORM
   ERROR '' 
   #FUN-BB0038 --begin     #
#  WHILE TRUE  
#  CONSTRUCT BY NAME g_wc ON ccc07,ccc02,ccc03
#
#     BEFORE CONSTRUCT
#         CALL cl_qbe_init()
#
#     ON ACTION CONTROLR
#        CALL cl_show_req_fields()
#
#     ON ACTION CONTROLG
#        CALL cl_cmdask()        # Command execution
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE CONSTRUCT
#
#     ON ACTION about          
#        CALL cl_about()       
#
#     ON ACTION help           
#        CALL cl_show_help()   
#
#     ON ACTION locale                    #genero
#        LET g_change_lang = TRUE
#        EXIT CONSTRUCT
#
#     ON ACTION exit              #加離開功能genero
#        LET INT_FLAG = 1
#        EXIT CONSTRUCT
# 
#     ON ACTION qbe_select
#        CALL cl_qbe_select()
#
#  END CONSTRUCT
# 
#  IF g_change_lang THEN
#     LET g_change_lang = FALSE
#     CALL cl_dynamic_locale()
#     CALL cl_show_fld_cont()   
#     LET g_flag = 'N'
#     RETURN
#  END IF 
 
   #carrier 20130618  --Begin
   #SELECT sma51,sma52 INTO tm.yy,tm.mm FROM sma_file
   LET tm.yy = g_ccz.ccz01
   LET tm.mm = g_ccz.ccz02
   LET tm.tlfctype = g_ccz.ccz28   #No.MOD-CB0221
   LET tm.b = g_ccz.ccz12          #No.MOD-CB0221
   DISPLAY BY NAME tm.tlfctype,tm.yy,tm.mm,tm.b
   #carrier 20130618  --End  
   LET g_bgjob = 'N'   
   INPUT BY NAME
      tm.tlfctype,tm.yy,tm.mm,tm.b       
      WITHOUT DEFAULTS 


      BEFORE INPUT                        #FUN-C90002
         LET tm.tlfctype = g_ccz.ccz28    #FUN-C90002 
      AFTER FIELD b
         IF tm.b IS NULL THEN
            NEXT FIELD b
         END IF
#No.MOD-CB0221 --begin
         SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=tm.b
         IF l_cnt=0 THEN
            CALL cl_err('sel aaa',100,0)
            NEXT FIELD b
         END IF
#No.MOD-CB0221 --end
 
      AFTER FIELD tlfctype
         IF tm.tlfctype NOT MATCHES '[12345]' THEN 
            LET tm.tlfctype =NULL 
            NEXT FIELD tlfctype
         END IF  
 
      AFTER INPUT
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p322_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
         IF cl_null(tm.tlfctype)THEN 
            NEXT FIELD tlfctype 
         END IF  
         IF cl_null(tm.yy) THEN
            NEXT FIELD yy 
         END IF  
         IF cl_null(tm.mm) THEN
            NEXT FIELD mm 
         END IF 
         IF cl_null(tm.b) THEN
            NEXT FIELD b 
         END IF 
  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION HELP          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
      ON ACTION qbe_save
           CALL cl_qbe_save()
      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_aaa"
               CALL cl_create_qry() RETURNING tm.b
               DISPLAY BY NAME tm.b
               NEXT FIELD b
         END CASE
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p322_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

#FUN-BB0038 --end

END FUNCTION

FUNCTION p322_p()
   
   BEGIN WORK 
   CALL p322_chk()
   IF g_flag ='N' THEN LET g_success = 'N' ROLLBACK WORK RETURN END IF   #FUN-BB0038
   CALL p322_ins_cdj()
   IF g_success ='N' THEN 
      ROLLBACK WORK 
      RETURN 
   END IF 
   CALL p322_gl(tm.*,'1')   #FUN-BB0038   #FUN-C80094 add'1'
   IF g_success ='N' THEN 
      ROLLBACK WORK 
   ELSE       
      COMMIT WORK 
   END IF 
END FUNCTION 

FUNCTION p322_ins_cdj()
DEFINE l_ccc01    LIKE ccc_file.ccc01
DEFINE l_ccc02    LIKE ccc_file.ccc02
DEFINE l_ccc03    LIKE ccc_file.ccc03
DEFINE l_ccc07    LIKE ccc_file.ccc07
DEFINE l_ccc08    LIKE ccc_file.ccc08
DEFINE l_ccc23    LIKE ccc_file.ccc23
DEFINE l_ccc61    LIKE ccc_file.ccc61
DEFINE l_ccc62    LIKE ccc_file.ccc62
DEFINE l_ima12    LIKE ima_file.ima12
DEFINE l_azf14    LIKE azf_file.azf14
DEFINE l_azf07    LIKE azf_file.azf07
DEFINE l_ccclegal LIKE ccc_file.ccclegal
DEFINE l_sql      STRING 
DEFINE l_ccz12    LIKE ccz_file.ccz12 
DEFINE l_ccz07    LIKE ccz_file.ccz07  #FUN-BB0038
DEFINE actno_c1   LIKE cdj_file.cdj08   #FUN-BB0038 
DEFINE actno_c2   LIKE cdj_file.cdj08   #FUN-BB0038
DEFINE actno_d1   LIKE cdj_file.cdj08   #FUN-BB0038
DEFINE actno_d2   LIKE cdj_file.cdj08   #FUN-BB0038
DEFINE l_ool01    LIKE ool_file.ool01   #FUN-BB0038
DEFINE l_ooz08    LIKE ooz_file.ooz08   #FUN-BB0038

   #FUN-BB0038 --begin
  # LET l_sql ="SELECT ccc01,ccc02,ccc03,ccc07,ccc08,ccc23,ccc61,ccc62,ima12,ccclegal ",
  #            "  FROM ccc_file,ima_file ",
  #            " WHERE ccc01 = ima01 AND ccc62 <>0 ",
  #            "   AND ",g_wc CLIPPED 
   #  LET l_sql ="SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,tlfc21,",
   #             "       oga03,oga15,tlf15,tlf16,oga032 ",
   #             "  FROM tlf_file,tlfc_file,oga_file ",
   #             " WHERE tlf026=oga01 AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02",
   #             "   AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903",
   #             "   AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906",
   #             "   AND YEAR(tlf06)='",tm.yy,"' ",
   #             "   AND MONTH(tlf06)='",tm.mm,"' ",
   #             "   AND tlfctype='",tm.tlfctype,"' ", 
   #             "   AND (tlf13='axmt620' OR tlf13='axmt628' OR tlf13='axmt650' OR tlf13='axmt700') ", 
   DROP TABLE cdj_temp
   #FUN-C80009 --begin
   SELECT oaz92,oaz93 INTO g_oaz.oaz92,g_oaz.oaz93 FROM oaz_file   #FUN-C90002
   IF g_oaz.oaz92 = 'N' OR (g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y') THEN  #FUN-C90002
      SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,-(tlf907*tlfc21) a,oga03,oga15,tlf15,tlf16,oga032,(tlf10*tlf60) b   #FUN-D90054 add (tlf10*tlf60) b
        FROM tlf_file,tlfc_file,oga_file                                           
       WHERE tlf905=oga01 AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02        
         AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903     
         AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
         AND YEAR(tlf06)=tm.yy AND MONTH(tlf06)=tm.mm                                              
         AND tlfctype=tm.tlfctype          
         AND oga57<>'2' #过滤代收                                
 #       AND (tlf13='axmt620' OR tlf13='axmt628' OR tlf13='axmt650') 
         AND tlf13 LIKE 'axmt6%'
         AND tlf13 <> 'axmt670' #FUN-C80009
         AND tlf902 not in (select jce02 from jce_file)
        INTO TEMP cdj_temp 

#     SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file              #FUN-C90002
      IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN           #FUN-C90002
         SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,tlfc21 a,omf05 oga03,oga15,tlf15,tlf16,omf051 oga032,(tlf10*tlf60) b   #FUN-D90054 add (tlf10*tlf60)
           FROM tlf_file,tlfc_file,omf_file,oga_file                                           
          WHERE tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02        
            AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903     
            AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
            AND tlf905=omf00 and tlf906=omf21 and omf11=oga01 and omf13=tlf01 
            AND YEAR(tlf06)=tm.yy AND MONTH(tlf06)=tm.mm                                              
            AND tlfctype=tm.tlfctype          
            AND oga57<>'2' #过滤代收                                
            AND tlf13 ='axmt670'
            AND tlf902 not IN (select jce02 from jce_file)
            AND omf10='1' #出货
           INTO TEMP cdj_temp 
        END IF
    END IF
   #No.FUN-D70068 ---Mark--- Start
   #FUN-C90002  --begin
   #IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'N' THEN
   #   SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,ccc23*cfc15 a,oga03,oga15,tlf15,tlf16,oga032
   #     FROM tlf_file,tlfc_file,oga_file,cfc_file,ccc_file
   #    WHERE tlf905=oga01 AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
   #      AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
   #      AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
   #      AND cfc05=tm.yy AND cfc06=tm.mm
   #      AND tlf905=cfc03 AND tlf906=cfc04
   #      AND tlf01=ccc01 AND ccc02=YEAR(tlf06) AND ccc03=MONTH(tlf06)
   #      AND cfc01=-1 AND cfc00<>'3'
   #      AND tlfctype=tm.tlfctype
   #     AND oga57<>'2' #过滤代收
   #      AND tlf13 LIKE 'axmt6%'
   #      AND tlf13 <> 'axmt670' #FUN-C80009
   #      AND tlf902 not in (select jce02 from jce_file)
   #     INTO TEMP cdj_temp
   #END IF
   #No.FUN-D70068 ---Mark--- Start
   #FUN-C90002  --end
   IF g_oaz.oaz92 = 'N' OR (g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y') THEN  #FUN-C90002
   SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,-(tlf907*tlfc21) a,oha03 oga03,oha15 oga15,tlf15,tlf16,oha032 oga032,(tlf10*tlf60) b   #FUN-D90054 add (tlf10*tlf60) b
     FROM tlf_file,tlfc_file,oha_file                                           
    WHERE tlf905=oha01 AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02        
      AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903     
      AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
      AND YEAR(tlf06)=tm.yy AND MONTH(tlf06)=tm.mm                                              
      AND tlfctype=tm.tlfctype          
      AND oha57<>'2' #过滤代收                                
      AND tlf13='aomt800' 
      AND tlf902 not in (select jce02 from jce_file)
     INTO TEMP cdj_temp 
     
#   IF g_oaz.oaz92 = 'Y' THEN                       #FUN-C90002
    IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN  #FUN-C90002
      SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,-tlfc21 a,omf05 oga03,oha15 oga15,tlf15,tlf16,omf051 oga032,(tlf10*tlf60) b   #FUN-D90054 add (tlf10*tlf60) b
        FROM tlf_file,tlfc_file,omf_file,oha_file                                           
       WHERE tlf905=omf00 AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02        
         AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903     
         AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
         AND YEAR(tlf06)=tm.yy AND MONTH(tlf06)=tm.mm                                              
         AND tlfctype=tm.tlfctype          
         AND oha57<>'2' #过滤代收                                
         AND tlf13='axmt670' AND omf11=oha01 and tlf906=omf21 and omf13=tlf01 
         AND omf10='2' #销退
         AND tlf902 not in (select jce02 from jce_file)
        INTO TEMP cdj_temp 
     END IF
   END IF  #FUN-C90002
   #No.FUN-D70068 ---Add--- Start
   #FUN-C90002  --begin
   #IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'N' THEN
   #   SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,ccc23*cfc15 a,oha03 oga03,oha15 oga15,tlf15,tlf16,oha032 oga032      
   #     FROM tlf_file,tlfc_file,oha_file,cfc_file,ccc_file
   #    WHERE tlf905=oha01 AND tlfc01=tlf01 AND tlfc06=tlf06 AND tlfc02=tlf02
   #      AND tlfc03=tlf03 AND tlfc13=tlf13 AND tlfc902=tlf902 AND tlfc903=tlf903
   #      AND tlfc904=tlf904 AND tlfc907=tlf907 AND tlfc905=tlf905 AND tlfc906=tlf906
   #      AND YEAR(tlf06)=ccc02 AND MONTH(tlf06)=ccc03
   #      AND cfc05=tm.yy AND cfc06=tm.mm
   #      AND cfc01=-1 AND cfc00='3'
   #      AND tlf905=cfc03 AND tlf906=cfc04
   #      AND tlf01=ccc01 AND ccc02=tm.yy AND ccc03=tm.mm
   #      AND tlfctype=tm.tlfctype
   #      AND oha57<>'2' #过滤代收   
   #      AND tlf13='aomt800'
   #      AND tlf902 not in (select jce02 from jce_file)
   #     INTO TEMP cdj_temp
   #END IF
   #FUN-C90002  --end
   #No.FUN-D70068 ---Add--- End
   #FUN-C80009 --end
   #将相同客户，部门，理由码，科目汇总 
   LET l_sql = " SELECT tlfclegal,tlfctype,tlfccost,tlf01,tlf14,SUM(a),oga03,oga15,tlf15,tlf16,oga032,b ",  #FUN-D90054 add b
               "   FROM cdj_temp ",
               "  GROUP BY tlfclegal,tlfctype,tlfccost,tlf01,tlf14,oga03,oga15,tlf15,tlf16,oga032,b "   #FUN-D90054 add b
   PREPARE p322_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p322_c1 CURSOR FOR p322_p1 
   INITIALIZE g_cdj.* TO NULL
   LET g_cdj.cdj17 =  0 
   FOREACH p322_c1 INTO l_cdj.cdjlegal,l_cdj.cdj04,l_cdj.cdj05,l_cdj.cdj06,l_cdj.cdj07,l_cdj.cdj12,
                        l_cdj.cdj14,l_cdj.cdj15,l_cdj.cdj08,l_cdj.cdj09,l_cdj.cdj142,l_cdj.cdj10   #FUN-D90054 add l_cdj.cdj10
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF l_cdj.cdj12 = 0 OR cl_null(l_cdj.cdj12) THEN CONTINUE FOREACH END IF     #No.MOD-D40042
      LET g_cdj.cdj01 = tm.b
      LET g_cdj.cdj02 = tm.yy
      LET g_cdj.cdj03 = tm.mm
      LET g_cdj.cdj04 = l_cdj.cdj04
      LET g_cdj.cdj05 = l_cdj.cdj05
      LET g_cdj.cdj06 = l_cdj.cdj06
      LET g_cdj.cdj07 = l_cdj.cdj07

        
     #LET g_cdj.cdj10 = l_cdj.cdj10
     #LET g_cdj.cdj11 = l_cdj.cdj11
      LET g_cdj.cdj11 = 0
     #LET g_cdj.cdj10 = 0             #FUN-D90054 mark
      LET g_cdj.cdj10 = l_cdj.cdj10   #FUN-D90054 add
      LET g_cdj.cdj12 = l_cdj.cdj12  
      LET g_cdj.cdj14 = l_cdj.cdj14
      LET g_cdj.cdj142= l_cdj.cdj142
      LET g_cdj.cdj15 = l_cdj.cdj15
      LET g_cdj.cdj17 = g_cdj.cdj17 + 1
  
      IF cl_null(g_cdj.cdj10) THEN LET g_cdj.cdj10 = 0 END IF
      IF cl_null(g_cdj.cdj11) THEN LET g_cdj.cdj11 = 0 END IF
      IF cl_null(g_cdj.cdj12) THEN LET g_cdj.cdj12 = 0 END IF
      LET g_cdj.cdj11 = cl_digcut(g_cdj.cdj11,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi03 -->ccz26
      LET g_cdj.cdj12 = cl_digcut(g_cdj.cdj12,g_ccz.ccz26)       #TQC-BB0046   #No.MOD-CC0001 azi04 -->ccz26
      LET g_cdj.cdjlegal = l_cdj.cdjlegal #FUN-BB0038
      LET g_cdj.cdjconf = 'N'   
      #借方科目优先根据tlf15抓取,若为空则根据以下顺序抓取
      #1.根据理由码抓销货费用科目azf14 
      #2.产品分类码抓销货成本科目oba16 
      #3.axri090抓ool43
      IF cl_null(l_cdj.cdj08) THEN   #借方
         IF NOT cl_null(l_cdj.cdj07) THEN 
            SELECT azf14,azf141 INTO actno_d1,actno_d2 FROM azf_file 
             WHERE azf01=l_cdj.cdj07 AND azf02='2' and azfacti='Y'
         END IF
         IF cl_null(actno_d1) THEN 
           SELECT oba16,oba161 INTO actno_d1,actno_d2 FROM oba_file 
            WHERE oba01 IN (SELECT ima131 FROM ima_file WHERE ima01=tlf01)
         END IF
         IF cl_null(actno_d1) THEN 
            SELECT occ67 INTO l_ool01 FROM occ_file WHERE occ01=l_cdj.cdj14
            SELECT ooz08 INTO l_ooz08 FROM ooz_file WHERE ooz00='0'
             IF NOT cl_null(l_ool01) THEN
                SELECT ool43,ool431 INTO actno_d1,actno_d2 FROM ool_file WHERE ool01 = l_ool01
             ELSE
                SELECT ool43,ool431 INTO actno_d1,actno_d2 FROM ool_file WHERE ool01 =l_ooz08
             END IF
         END IF
         IF g_cdj.cdj01 = g_aza.aza82 THEN
            LET g_cdj.cdj08=actno_d2
         ELSE
            LET g_cdj.cdj08=actno_d1
         END IF      
      ELSE 
         LET g_cdj.cdj08 = l_cdj.cdj08 	   
     	END IF  
      IF cl_null(l_cdj.cdj09) THEN #贷方 
         SELECT ccz07,ccz12 INTO l_ccz07,l_ccz12 FROM ccz_file 
         IF g_cdj.cdj01 = l_ccz12 THEN 
            IF l_ccz07 = '2' THEN 
                  SELECT imz39 INTO g_cdj.cdj09
                    FROM ima_file,imz_file
                   WHERE ima01 = l_cdj.cdj06
                    #AND ima12 = imz01  #MOD-D50133 mark
                     AND ima06 = imz01  #MOD-D50133 ima12->ima06  
            ELSE 
                  SELECT ima39 INTO g_cdj.cdj09
                    FROM ima_file
                   WHERE ima01 = l_cdj.cdj06
            END IF  
         ELSE
            IF l_ccz07 = '2' THEN 
                  SELECT imz391 INTO g_cdj.cdj09
                    FROM ima_file,imz_file
                   WHERE ima01 = l_cdj.cdj06
                    #AND ima12 = imz01  #MOD-D50133 mark
                     AND ima06 = imz01  #MOD-D50133 ima12->ima06  
            ELSE 
                  SELECT ima391 INTO g_cdj.cdj09
                    FROM ima_file
                   WHERE ima01 = l_cdj.cdj06
            END IF  
         END IF
      ELSE  
         LET g_cdj.cdj09 = l_cdj.cdj09 	   
      END IF 
     	
      #FUN-BB0038 --end
      LET g_cdj.cdj00 = '1' #FUN-C80094    
      INSERT INTO cdj_file VALUES(g_cdj.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err('ins cdj',SQLCA.sqlcode,1)
         LET g_success ='N'
         EXIT FOREACH 
      END IF  
      INITIALIZE l_cdj.* TO NULL #FUN-BB0038 
   END FOREACH 

END FUNCTION 

FUNCTION p322_chk()
DEFINE l_wc        STRING
DEFINE l_sql       STRING
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_cdjconf   LIKE cdj_file.cdjconf #FUN-BB0038

#FUN-BB0038 --begin
  # LET l_wc = cl_replace_str(g_wc,"ccc07","cdj04")   
  # LET l_wc = cl_replace_str(l_wc,"ccc02","cdj02")
  # LET l_wc = cl_replace_str(l_wc,"ccc03","cdj03")
   
   
   LET l_sql = "SELECT count(*) ",
               "  FROM cdj_file ",
               " WHERE cdj01 ='",tm.b CLIPPED,"'",
            #   "   AND ",l_wc CLIPPED  
               "   AND cdj00 = 1 ",   #FUN-C80094
               "   AND cdj02 = '",tm.yy CLIPPED,"'",
               "   AND cdj02 = '",tm.yy CLIPPED,"'",
               "   AND cdj03 = '",tm.mm CLIPPED,"'", 
               "   AND cdj04 = '",tm.tlfctype CLIPPED,"'"
               

   PREPARE p322_p6 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF
   DECLARE p322_c6 CURSOR FOR p322_p6
   LET l_sql = "DELETE ",
               "  FROM cdj_file ",
               " WHERE cdj01 ='",tm.b CLIPPED,"'",
              # "   AND ",l_wc CLIPPED  
               "   AND cdj00 = 1 ",   #FUN-C80094
               "   AND cdj02 = '",tm.yy CLIPPED,"'",
               "   AND cdj03 = '",tm.mm CLIPPED,"'", 
               "   AND cdj04 = '",tm.tlfctype CLIPPED,"'"
               

   PREPARE p322_p7 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   OPEN p322_c6 
   FETCH p322_c6 INTO l_cnt
   IF l_cnt >0 THEN 
      #FUN-BB0038 --begin
      SELECT UNIQUE cdjconf INTO l_cdjconf FROM cdj_file
       WHERE cdj01=tm.b 
         AND cdj00=1    ##FUN-C80094
         AND cdj02=tm.yy
         AND cdj03=tm.mm
         AND cdj04=tm.tlfctype
      IF l_cdjconf='Y' THEN
         CALL cl_err('','afa-364',1)
         LET g_flag='N'
      ELSE 
      #FUN-BB0038 --end
         IF cl_confirm('mfg8002') THEN 
            LET g_flag ='Y'
            EXECUTE p322_p7
         ELSE 
            LET g_flag ='N'
         END IF 
      END IF  #FUN-BB0038
   ELSE 
         LET g_flag ='Y'
   END IF 
   CLOSE p322_c6 
#FUN-BB0038 --end  
END FUNCTION 
