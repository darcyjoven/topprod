# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_taskhur.4gl
# Descriptions...: 計算每一站之尚需工時
# Date & Author..: 92/08/18 By Purple
# Usage..........: CALL s_taskhur(p_bomdat,p_wono,p_primary,p_woq)
#                       RETURNING l_status
# Input Parameter: p_bomdat   BOM Effective Date
#                  p_wono     W/O Number
#                  p_primary  Routing Primary Code
#                  p_woq      W/O Qty
# Return Code....: l_status	0  ok
#                               1  no use routing 
#                               2  no record find
# Memo...........: 可使用之資料: g_takhur[100]
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
 
DATABASE ds        #FUN-6C0017   #FUN-7C0053
 
GLOBALS "../../config/top.global"
 DEFINE 
    g_op ARRAY[100] OF RECORD
        qtytbc LIKE ecm_file.ecm301, #Qty to be complete
        offset1 LIKE ecm_file.ecm13, #offset(=FLT+ULT)
        offset2 LIKE ecm_file.ecm13  #offset(=ULT)
        END RECORD,
        g_wono      LIKE sfb_file.sfb01,  #W/O NO.  
        g_wotype    LIKE sfb_file.sfb02,  #W/O TYPE
        g_part      LIKE sfb_file.sfb05,  #part no.
        g_primary   LIKE ecb_file.ecb02,  #routing no.
        g_woq       LIKE sfb_file.sfb08,  #W/O qty. 
        g_lots LIKE ima_file.ima56  #production lot size
 
DEFINE   g_cnt           LIKE type_file.num10     	#No.FUN-680147 INTEGER
FUNCTION s_taskhur(p_bomdat,p_wono,p_primary,p_woq)
  DEFINE
 
       p_strtdat    LIKE type_file.dat,               #Start Date 	#No.FUN-680147 DATE
       p_duedat     LIKE type_file.dat,               #Due Date 	#No.FUN-680147 DATE
       p_bomdat     LIKE type_file.dat,               #BOM Effective Date 	#No.FUN-680147 DATE
       p_wono LIKE sfb_file.sfb01,   #W/O
       p_part LIKE sfb_file.sfb05,   #work order part number
       p_woq LIKE sfb_file.sfb08,    #Qty of W/O
       p_primary LIKE ecb_file.ecb02,#Primary Code
       l_sfb93      LIKE sfb_file.sfb93,          #No.FUN-680147 VARCHAR(01)
       i       LIKE type_file.num5                #key point 	#No.FUN-680147 SMALLINT
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_wono=p_wono
    LET g_primary=p_primary
    LET g_woq=p_woq
 
#--->First check start date & due date   & array initilize to null
#    start date & due date must have value
 
     IF  p_strtdat IS NULL THEN LET p_strtdat='01/01/01' END IF
     IF  p_duedat  IS NULL THEN LET p_duedat=g_lastdat   END IF
     SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01=g_wono
 
     IF l_sfb93 MATCHES '[nN]'   #不使用製程系統
        THEN  RETURN 1
     END IF
 
     SELECT COUNT(*) INTO g_cnt FROM ecm_file
                               WHERE ecm01=g_wono
 
      IF g_cnt=0  OR g_cnt IS NULL  THEN    #record not exist
         RETURN 2     #本作業應使用製程追蹤才可算其尚需工時的.
      END IF
 
      CALL g_takhur.clear() 
 
      CALL s_needhur() returning g_cnt
      IF g_cnt=1 THEN RETURN 2  END IF
      RETURN 0
 
END FUNCTION
 
#accumulated total need time
 
FUNCTION s_needhur()
DEFINE
    l_ecm RECORD LIKE ecm_file.*, #tracking detail file
    l_need1 LIKE ecm_file.ecm07, #total offset1
    l_need2 LIKE ecm_file.ecm07, #total offset1
    l_wc LIKE ecb_file.ecb08, #work center
    l_eca04 LIKE eca_file.eca04, #work center type code
    l_eca06 LIKE eca_file.eca06, #intensity flag
    l_eca08 LIKE eca_file.eca08, #capacity hour per day
    l_eca09 LIKE eca_file.eca09, #work center queue time
    l_flt LIKE ima_file.ima59, #routing's fixed lead time(FLT)
    l_ult LIKE ima_file.ima60,  #routing's unit lead time(ULT)
    l_run LIKE ecm_file.ecm39, #runtime
    l_qty LIKE ecm_file.ecm301,
    l_lots LIKE type_file.num5,   #production lot size 	#No.FUN-680147 SMALLINT
    l_double LIKE ecm_file.ecm40
 
    DECLARE c_trk CURSOR FOR
        SELECT ecm_file.* FROM ecm_file
            WHERE ecm01=g_wono #W/O
                AND ecm11=g_primary #primary code
            ORDER BY ecm03 
    LET g_cnt=1
    #accumulate total need time
    LET l_need1=0
    LET l_need2=0
    LET l_wc='*'
    SELECT ima56 INTO g_lots FROM ima_file,sfb_file
        WHERE ima01=sfb05 AND imaacti='Y'
          #AND sfb01=p_wono
          AND sfb01=g_wono
    IF SQLCA.sqlcode THEN #selection error
        LET g_lots=1
    END IF
    FOREACH c_trk INTO l_ecm.*  #No.TQC-950134
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        IF l_ecm.ecm40 IS NULL THEN LET l_ecm.ecm40=0 END IF
        IF l_ecm.ecm41 IS NULL THEN LET l_ecm.ecm41=0 END IF
        IF l_wc != l_ecm.ecm06 THEN #w/c changed, get queue time
            SELECT eca04,eca06,eca08,eca09
                INTO l_eca04,l_eca06,l_eca08,l_eca09
                FROM eca_file
                WHERE eca01=l_ecm.ecm06 AND ecaacti='Y'
            IF SQLCA.sqlcode THEN
                 LET l_eca04='0' LET l_eca06='1'
                 LET l_eca08=8   LET l_eca09=0
            ELSE
                IF l_eca04 IS NULL THEN LET l_eca04='0' END IF
                IF l_eca06 IS NULL THEN LET l_eca06='1' END IF
                IF l_eca08 IS NULL THEN LET l_eca08=8 END IF
                IF l_eca09 IS NULL THEN LET l_eca09=0 END IF
            END IF
            LET l_wc=l_ecm.ecm06
        ELSe
            LET l_eca09=0
        END IF
        #這裡的數量為該站未完成之數量
            LET g_op[g_cnt].qtytbc=
                l_ecm.ecm301+l_ecm.ecm302+l_ecm.ecm303-l_ecm.ecm311-l_ecm.ecm312- l_ecm.ecm313-l_ecm.ecm314-l_ecm.ecm316
        #compute offset and need time
        IF l_eca06='1' THEN #labor burdened w/c
            LET l_double=l_ecm.ecm41
        ELSE #machine burdened w/c
            LET l_double=l_ecm.ecm40
        END IF
 
        IF l_eca04='0' THEN #regular w/c
            LET l_lots=(g_op[g_cnt].qtytbc/g_lots)+0.999
            LET l_flt=(l_ecm.ecm37*((100-l_ecm.ecm42)/100)*l_lots+
                      l_ecm.ecm18*l_lots+l_eca09)/(60*l_eca08)
        ELSE #other
            LET l_flt=0
        END IF
 
        IF l_eca04='0' THEN #regular
            LET l_run=l_ecm.ecm38  #人工生產時間
        ELSE #other
            LET l_run=l_ecm.ecm39  #廠外加工時間
        END IF
 
        IF l_ecm.ecm43='1' THEN #hr/unit
            LET l_ult=((l_run*g_op[g_cnt].qtytbc)/(l_eca08*60))
        ELSE #unit/hr
           IF l_run = 0 THEN
              LET l_ult = NULL
           ELSE
              LET l_ult=((g_op[g_cnt].qtytbc)/(l_eca08*60*l_run))
           END IF
        END IF
 
        IF l_flt IS NULL THEN LET l_flt=0 END IF
        IF l_ult IS NULL THEN LET l_ult=0 END IF
        LET g_op[g_cnt].offset1=l_flt+l_ult   #固定+變動
        LET g_op[g_cnt].offset2=l_ult         #變動
        LET l_need1=l_need1+l_flt+l_ult       #total 固定+變動
        LET l_need2=l_need2+l_ult             #total 變動
#--->將相關資料存入陣列
        LET g_takhur[g_cnt].ecb03=l_ecm.ecm03 #operation seq.
        LET g_takhur[g_cnt].ecb06=l_ecm.ecm04 #operation no.
        LET g_takhur[g_cnt].ecb08=l_ecm.ecm06 #work center
        LET g_takhur[g_cnt].takhur=l_flt+l_ult #該站尚未完工工時
        LET g_cnt=g_cnt+1
        IF g_cnt>100 THEN EXIT FOREACH END IF
    END FOREACH
        RETURN g_cnt
END FUNCTION
