# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_runcard.4gl
# Descriptions...: 
# Date & Author..: 90/12/13 By Lee
# Usage..........: CALL s_schdat(p_runcard,p_wono,p_primary,p_part,p_woq) 
#                               RETURNING l_status 
# Input Parameter: p_runcard
#                  p_wono		
#                  p_primary
#                  p_part
#                  p_woq   
# Return code....: l_status
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: NO.MOD-6A0128 2006/11/02 By Mandy 增加考慮生產單位(ima55)與轉入單位(sgm57)的轉換率
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.MOD-6C0112 07/01/09 By pengu 製程資料應該參考ecm_file而非ecb_file
# Modify.........: No.MOD-750138 07/05/31 By pengu RUNCARD的開完工日期，應該以製程的開完工日期為主
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-A60076 10/06/29 By vealxu 製造功能優化-平行制程
# Modify.........: No.FUN-A60095 10/07/06 By jan 平行製程-runcrd調整
# Modify.........: No:FUN-A80102 10/09/12 By kim GP5.25號機管理
# Modify.........: No:FUN-B10056 11/02/14 By lixh1 新增函數1.檢查製程段是否存在  2.抓取制程段号说明
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO sgm_file給sgm66預設值'Y'
# Modify.........: No.FUN-BB0085 11/12/06 By xianghui 增加數量欄位小數取位

DATABASE ds        #FUN-6C0017
 
GLOBALS "../../../tiptop/config/top.global"   #FUN-7C0053
 
DEFINE
    g_sfb RECORD LIKE sfb_file.*, #Work Order
    g_type      LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_track     LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
    g_runcard   LIKE shm_file.shm01,
    g_wono      LIKE sfb_file.sfb01,
    g_part      LIKE sfb_file.sfb05,
    g_primary   LIKE sfb_file.sfb06,
    g_woq       LIKE sfb_file.sfb08, #Qty of W/O
    g_sfb13     LIKE sfb_file.sfb13,
    g_sfb15     LIKE sfb_file.sfb15
DEFINE  g_ecm03  LIKE ecm_file.ecm03 

DEFINE   g_cnt           LIKE type_file.num10
FUNCTION cs_runcard(p_runcard,p_wono,p_primary,p_part,p_woq,l_ecm03) 
DEFINE
   p_runcard  LIKE shm_file.shm01, #Run Card
    p_wono     LIKE sfb_file.sfb01, #工單
    p_primary  LIKE ecm_file.ecm11, #製程編號      #No.MOD-6C0112 modify
    p_part     LIKE sfb_file.sfb05, #料號 
    p_woq      LIKE sfb_file.sfb08, #數量 
    l_part     LIKE ima_file.ima01,
    l_ima571   LIKE ima_file.ima571,
    l_sfb93    LIKE sfb_file.sfb93,          #No.FUN-680147 VARCHAR(01)
    l_exit     LIKE type_file.num5           #No.FUN-680147 SMALLINT
 DEFINE l_ecm03  LIKE ecm_file.ecm03

    WHENEVER ERROR CALL cl_err_msg_log
    LET g_runcard=p_runcard
    LET g_wono=p_wono
    LET g_primary=p_primary
    LET g_part=p_part
    LET g_woq =p_woq  
    LET g_errno= ''
    LET g_ecm03=l_ecm03
    SELECT sfb93,sfb13,sfb15 INTO l_sfb93,g_sfb13,g_sfb15 
      FROM sfb_file WHERE sfb01=g_wono
    IF (l_sfb93='Y' AND g_sma.sma28='2')	        #使用製程排程
            OR (g_sma.sma26 MATCHES '[23]') THEN	#產生製程追蹤
        LET g_cnt=0
       SELECT COUNT(*) INTO g_cnt FROM sgm_file WHERE sgm01=g_runcard AND sgm03>=g_ecm03
        IF SQLCA.sqlcode OR g_cnt=0 OR g_cnt IS NULL THEN #record not exist
             #--> 產生製程追蹤檔
                SELECT ima571 INTO l_ima571 FROM ima_file 
                 WHERE ima01 = g_part
                IF cl_null(l_ima571) THEN LET l_part = g_part END IF
                CALL cs_put2(l_ima571) RETURNING g_cnt 
 
                IF g_cnt = 0 THEN 
                   CALL cs_put2(g_part) RETURNING g_cnt 
                END IF 
        END IF
    END IF
    MESSAGE ""
    RETURN g_errno 
END FUNCTION
 
#-->Add new record of tracking file
FUNCTION cs_put2(p_part)
DEFINE
    p_part   LIKE ima_file.ima01,
    l_ecm    RECORD LIKE ecm_file.*, #routing detail file    #No.MOD-6C0112 modify
    l_sgm    RECORD LIKE sgm_file.*, #routing detail file
    l_sgd    RECORD LIKE sgd_file.*, #routing detail file
    l_sgn    RECORD LIKE sgn_file.*, #routing detail file
    l_sgm03,l_sgn03 LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    #MOD-6A0128---add----str----
    l_ima55         LIKE ima_file.ima55,
    l_flag          LIKE type_file.num5,          #SMALLINT
    l_factor        LIKE ima_file.ima31_fac,      #DEC(16,8)
    l_mesg          LIKE ze_file.ze03             #CHAR(200)
    #MOD-6A0128---add----end----
DEFINE l_sfb08,l_shm08   LIKE sfb_file.sfb08      #FUN-A60095
DEFINE l_i          LIKE type_file.num5 
   #-----------No.MOD-6C0112 modify
   #DECLARE c_put CURSOR FOR
   #    SELECT * FROM ecb_file
   #        WHERE ecb01=p_part       #part
   #            AND ecb02=g_primary  #routing
   #            AND ecbacti='Y'
   #        ORDER BY ecb03           #製程序號
   #LET g_cnt=0 LET l_sgm03=0
   #FOREACH c_put INTO l_ecb.*
    SELECT sfb08,shm08 INTO l_sfb08,l_shm08 FROM sfb_file,shm_file #FUN-A60095
     WHERE shm01=g_runcard AND shm012=sfb01  #FUN-A60095
    DECLARE c_put CURSOR FOR
        SELECT * FROM ecm_file
            WHERE ecm01=g_wono       #wono
                AND ecm11=g_primary  #routing
                and ecm03>=g_ecm03  #tianry add 
                AND ecmacti='Y'
            ORDER BY ecm012,ecm03           #製程序號 #FUN-A60095
    LET g_cnt=0 LET l_sgm03=0
    LET l_i=1
    FOREACH c_put INTO l_ecm.*
   #-----------No.MOD-6C0112 end
        IF SQLCA.sqlcode THEN 
           CALL cl_err('c_put',SQLCA.sqlcode,0) EXIT FOREACH 
        END IF
        INITIALIZE l_sgm.* TO NULL  
        LET l_sgm03 = l_sgm03 + g_sma.sma849 
        LET l_sgm.sgm01      =  g_runcard
        LET l_sgm.sgm02      =  g_wono  
        LET l_sgm.sgm03_par  =  g_part
     #   IF g_sma.sma541 = 'N' THEN               #FUN-A60095
     #      LET l_sgm.sgm03      =  l_sgm03 
     #   ELSE
           LET l_sgm.sgm03      =  l_ecm.ecm03   #FUN-A60095     
     #   END IF
#FUN-B10056 --------------------Begin------------------------------
        LET l_sgm.sgm014 = l_ecm.ecm014
        LET l_sgm.sgm015 = l_ecm.ecm015
        IF l_sgm.sgm015 IS NULL THEN
           LET l_sgm.sgm015 = ' '
        END IF 
#FUN-B10056 --------------------End--------------------------------
       #-----------No.MOD-6C0112 modify
        LET l_sgm.sgm04      =  l_ecm.ecm04
        LET l_sgm.sgm05      =  l_ecm.ecm05
        LET l_sgm.sgm06      =  l_ecm.ecm06
        LET l_sgm.sgm07      =  0 LET l_sgm.sgm08      =  0           
        LET l_sgm.sgm09      =  0 LET l_sgm.sgm10      =  0           
        LET l_sgm.sgm11      =  l_ecm.ecm11          #製程編號
        LET l_sgm.sgm13      =  l_ecm.ecm13          #固定工時(秒)
        LET l_sgm.sgm14      =  l_ecm.ecm14*g_woq    #標準工時(秒)
        LET l_sgm.sgm15      =  l_ecm.ecm15          #固定機時(秒)
        LET l_sgm.sgm16      =  l_ecm.ecm16*g_woq    #標準機時(秒)
        LET l_sgm.sgm49      =  l_ecm.ecm49*g_woq    #製程人力
        LET l_sgm.sgm45      =  l_ecm.ecm45          #作業名稱
        LET l_sgm.sgm52      =  l_ecm.ecm52          #SUB 否
        LET l_sgm.sgm53      =  l_ecm.ecm53          #PQC 否
        LET l_sgm.sgm54      =  l_ecm.ecm54          #Check in 否
        LET l_sgm.sgm55      =  l_ecm.ecm55          #Check in Hold 否
        LET l_sgm.sgm56      =  l_ecm.ecm56          #Check Out Hold 否
       #LET l_sgm.sgm57      =  l_ecm.ecm57    #FUN-A60095    
        LET l_sgm.sgm58      =  l_ecm.ecm58       
       #LET l_sgm.sgm59      =  l_ecm.ecm59    #FUN-A60095   
        LET l_sgm.sgm012     =  l_ecm.ecm012   #FUN-A60076
        LET l_sgm.sgm011     =  l_ecm.ecm011   #FUN-A60095
        LET l_sgm.sgm12      =  l_ecm.ecm12    #FUN-A60095
        LET l_sgm.sgm34      =  l_ecm.ecm34    #FUN-A60095
        LET l_sgm.sgm62      =  l_ecm.ecm62    #FUN-A60095
        LET l_sgm.sgm63      =  l_ecm.ecm63    #FUN-A60095
        LET l_sgm.sgm64      =  l_ecm.ecm64    #FUN-A60095
        LET l_sgm.sgm65      =  l_ecm.ecm65*l_shm08/l_sfb08     #FUN-A60095
        LET l_sgm.sgm65      =  s_digqty(l_sgm.sgm65,l_sgm.sgm58)  #FUN-BB0085
        IF cl_null(l_sgm.sgm65) THEN LET l_sgm.sgm65 = 0 END IF #FUN-A60095 
        LET l_sgm.sgm66      =  l_ecm.ecm66    #FUN-A80102
        LET l_sgm.sgm67      =  l_ecm.ecm67    #FUN-A80102
       #-----------No.MOD-6C0112 end
        #------>
        LET l_sgm.sgm291     =  0           
        LET l_sgm.sgm292     =  0           
       ##MOD-6A0128---mod----str---
       #IF g_cnt=0    #第一站default投入量=生產套數
       #THEN LET l_sgm.sgm301     =  g_woq
       #ELSE LET l_sgm.sgm301     =  0           
       #END IF
      #IF g_cnt=0 THEN   #FUN-A60095
       IF NOT s_schdat_chk_min_ecm03(g_wono,l_ecm.ecm012,l_ecm.ecm03) THEN #CHECK最初製程否
       #FUN-A60095--begin--modify-------------------------------- 
       #    SELECT ima55 
       #      INTO l_ima55 
       #      FROM ima_file 
       #     WHERE ima01=g_part
       #    IF STATUS THEN 
       #        LET l_ima55=' ' 
       #    END IF
       #    CALL s_umfchk(g_part,l_ima55,l_sgm.sgm58)  #FUN-A60095
       #         RETURNING l_flag,l_factor
       #    IF l_flag = 1 THEN
       #        LET l_mesg = NULL
       #        LET l_mesg = g_part,"(ima55/sgm58):"   #FUN-A60095
       #        CALL cl_err(l_mesg,'abm-731',1)
       #        LET g_success ='N'
       #    END IF
       #    LET l_sgm.sgm301 = g_woq * l_factor
            LET l_sgm.sgm301 = g_woq * l_sgm.sgm62/l_sgm.sgm63
            LET l_sgm.sgm301 = s_digqty(l_sgm.sgm301,l_sgm.sgm58)   #FUN-BB0085
       #FUN-A60095--end--modify-----------------------------
            LET g_cnt = 3
        ELSE
            LET l_sgm.sgm301     =  0           
        END IF
       ##MOD-6A0128---mod----end---
        LET l_sgm.sgm302     =  0    
        LET l_sgm.sgm303     =  0    LET l_sgm.sgm304     =  0    
        LET l_sgm.sgm311     =  0           
        LET l_sgm.sgm312     =  0    LET l_sgm.sgm313     =  0           
        LET l_sgm.sgm314     =  0    LET l_sgm.sgm315     =  0     
        LET l_sgm.sgm316     =  0    LET l_sgm.sgm317     =  0     
        LET l_sgm.sgm321     =  0    LET l_sgm.sgm322     =  0           
        #------>
       #----------------No.MOD-750138 modify
       #LET l_sgm.sgm50      =  g_sfb13 
       #LET l_sgm.sgm51      =  g_sfb15
        LET l_sgm.sgm50      =  l_ecm.ecm50 
        LET l_sgm.sgm51      =  l_ecm.ecm51
       #----------------No.MOD-750138 end
        LET l_sgm.sgmacti    =  'Y'           
        LET l_sgm.sgmuser    =  g_user         
        LET l_sgm.sgmgrup    =  g_grup        
        LET l_sgm.sgmmodu    =  ''           
        LET l_sgm.sgmdate    =  g_today      
 
        LET l_sgm.sgmplant =  g_plant   #FUN-980012 add
        LET l_sgm.sgmlegal =  g_legal   #FUN-980012 add

        IF cl_null(l_sgm.sgm012) THEN LET l_sgm.sgm012 = ' ' END IF #FUN-A60095
        IF cl_null(l_sgm.sgm66) THEN LET l_sgm.sgm66='Y' END IF     #TQC-B80022
        #str-----add by guanyao160713
        LET l_sgm.ta_sgm01 = l_ecm.ta_ecm01
        LET l_sgm.ta_sgm02 = l_ecm.ta_ecm02
        LET l_sgm.ta_sgm03 = l_ecm.ta_ecm03
        #end-----add by guanyao160713
        #tianry 161214
        SELECT ecbud06 INTO l_sgm.ta_sgm06 FROM ecb_file WHERE ecb01=l_sgm.sgm03_par
        AND ecb02=l_sgm.sgm11 AND ecb03=l_sgm.sgm03 
        AND ecb012=l_sgm.sgm012
        IF cl_null(l_sgm.ta_sgm06) THEN LET l_sgm.ta_sgm06='N' END IF
        IF l_i=1 THEN LET l_sgm.ta_sgm06='Y' END IF 
        #tianry add end 161214

        INSERT INTO sgm_file VALUES(l_sgm.*)
 
        #------>insert sgn_file
        #------>工單製程單元資料 
        LET l_sgn03=0
        DECLARE sgd_cur CURSOR FOR 
           SELECT * FROM sgd_file 
            WHERE  sgd00 = g_wono 
              AND  sgd03 = l_ecm.ecm03   #No.MOD-6C0112 modify
              AND  sgd012= l_ecm.ecm012  #FUN-A60095
        FOREACH sgd_cur INTO l_sgd.*
           IF SQLCA.sqlcode THEN EXIT FOREACH END IF
           INITIALIZE l_sgn.* TO NULL  
           LET l_sgn.sgn00 = g_runcard
           LET l_sgn.sgn01 = l_sgd.sgd01
           LET l_sgn.sgn02 = l_sgd.sgd02
           IF g_sma.sma541 = 'Y' THEN
              LET l_sgn.sgn03=l_sgd.sgd03  #FUN-A60095
           ELSE
              LET l_sgn.sgn03 = l_sgm03       
           END IF
           LET l_sgn.sgn04 = l_sgd.sgd04
           LET l_sgn.sgn05 = l_sgd.sgd05
           LET l_sgn.sgn06 = l_sgd.sgd06
           LET l_sgn.sgn07 = l_sgd.sgd07
           LET l_sgn.sgn08 = l_sgd.sgd08
           LET l_sgn.sgn09 = l_sgd.sgd09
           LET l_sgn.sgn012= l_sgd.sgd012    #FUN-A60095
           LET l_sgn.sgnplant   =  g_plant   #FUN-980012 add
           LET l_sgn.sgnlegal   =  g_legal   #FUN-980012 add
           INSERT INTO sgn_file VALUES(l_sgn.*)
        END FOREACH
        LET g_cnt=g_cnt+1
        LET l_i=l_i+1
    END FOREACH
    RETURN g_cnt
END FUNCTION
#FUN-B10056 ---------------------Begin----------------------
#檢查製程段是否存在
FUNCTION cs_runcard_sgm012(p_sgm01,p_sgm012)
   DEFINE p_sgm01     LIKE sgm_file.sgm01
   DEFINE p_sgm012    LIKE sgm_file.sgm012
   DEFINE l_cnt       LIKE type_file.num10
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sgm_file
    WHERE sgm01 = p_sgm01 
      AND sgm012 = p_sgm012
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      RETURN TRUE
   ELSE 
      RETURN FALSE 
   END IF
END FUNCTION
#抓取制程段号说明
FUNCTION cs_runcard_sgm014(p_sgm01,p_sgm012)
   DEFINE p_sgm01     LIKE sgm_file.sgm01
   DEFINE p_sgm012    LIKE sgm_file.sgm012
   DEFINE l_sgm014    LIKE sgm_file.sgm014
   DECLARE sgm014_cs CURSOR FOR 
           SELECT DISTINCT sgm014 FROM sgm_file
            WHERE sgm01=p_sgm01 AND sgm012=p_sgm012
   FOREACH sgm014_cs INTO l_sgm014
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
      END IF
      EXIT FOREACH
   END FOREACH
   RETURN l_sgm014
END FUNCTION
#FUN-B10056 ---------------------End-------------------------
